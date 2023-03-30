# -*- coding: utf-8 -*-
"""
# sitrep_web_postgre
Fetch data from data.gouv.fr and transform it. Then dump it in the postgres database. used to create the dataset

This DAG can only be executed from within the intranet of the MTES.
"""
import os
from datetime import datetime, timedelta
from io import StringIO

import pandas as pd
import requests
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from dotenv import load_dotenv
from helpers import connection_db, default_args, numero_immatriculation

load_dotenv()

default_args = default_args({"start_date": datetime(2019, 3, 17, 6, 40), "retries": 0})

dag = DAG(
    "sitrep_web_postgre",
    default_args=default_args,
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval="@daily",
)

dag.doc_md = __doc__


def filtre_sitrep():
    df = pd.read_csv(os.environ["SECMAR_FILTER_PATH"])
    return df[df["Etat"] == "Oui"]["Nom de l'événement"].tolist()


def telechargement_secmar(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.3"
    }
    req = requests.get(url, headers=headers, stream=True)
    data = StringIO(req.text)
    return pd.read_csv(data)


def annualisation_sitrep(df):
    df["annee"] = df["date"].apply(lambda x: x.year)
    df = df.groupby(["annee", "numero_immatriculation"]).count().reset_index()
    return df.rename(columns={"date": "sitrep"})


def recuperation_immat(df, engine):
    navire = pd.read_sql(
        "select id_nav_flotteur, num_immat_francais from navire", engine
    )
    navire["numero_immatriculation"] = navire["num_immat_francais"].apply(
        lambda x: numero_immatriculation(x, os.environ["IMMAT_HASH_SECRET"])
    )

    df2023 = df[df.annee == "2023"]
    df2023merged = pd.merge(navire, df2023, how="left", on="numero_immatriculation")
    print(df2023merged)
    print(df2023merged[~df2023merged["id_nav_flotteur"].isna()])

    df = pd.merge(navire, df, how="inner", on="numero_immatriculation")
    print(df)
    return df[
        ["annee", "id_nav_flotteur", "sitrep"]
    ]  # Modification pour obtention date evenement mer


def sitrep_transform(df, engine):
    df["numero_immatriculation"] = df["numero_immatriculation"].astype(str)
    df = df[df["numero_immatriculation"] != "nan"]
    df = df[df.type_operation.isin(["SAR", "MAS"])]
    df = df[df.evenement.isin(filtre_sitrep())]
    df = df[df.resultat_flotteur != "Non assisté, cas de fausse alerte"]
    time_format = "%Y-%m-%dT%H:%M:%SZ"

    df["date"] = df["date_heure_reception_alerte"].apply(
        lambda date: datetime.strptime(date.split("+")[0], time_format).date()
    )
    df = df[["date", "numero_immatriculation", "operation_id"]]
    df = df.drop_duplicates()

    ## Annualisation
    df = annualisation_sitrep(df)
    return recuperation_immat(df, engine)


def sitrep_fetching():
    """
    Source des données :
    https://www.data.gouv.fr/fr/datasets/operations-coordonnees-par-les-cross/
    """
    engine = connection_db()

    operations = telechargement_secmar(
        url="https://www.data.gouv.fr/fr/datasets/r/fae6bc13-fe4c-4838-b281-b16628b7babe"
    )
    flotteurs = telechargement_secmar(
        url="https://www.data.gouv.fr/fr/datasets/r/ae0e17e4-7117-45f0-80c4-b11b38f31c5c"
    )
    df_sitreps = pd.merge(flotteurs, operations, how="inner", on="operation_id")
    df_sitreps = sitrep_transform(df_sitreps, engine)

    print(df_sitreps.annee.unique())
    df_sitreps.to_sql("sitrep", engine, if_exists="replace")


sitreps = PythonOperator(
    task_id="telechargement_sitrep",
    python_callable=sitrep_fetching,
    execution_timeout=timedelta(minutes=60),
    dag=dag,
)

start = EmptyOperator(task_id="start", dag=dag)
end = EmptyOperator(task_id="end", dag=dag)

sitreps.set_upstream(start)

end.set_upstream(sitreps)
