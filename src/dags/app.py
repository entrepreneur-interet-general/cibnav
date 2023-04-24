# -*- coding: utf-8 -*-
"""
# App : Core functions of cibnav project


pré-réquis : - chaque navire a ses informations a jour dans la table navire (dag : navire_oracle_postgre, navire_version_oracle_postgre, navire_version_gina_oracle_postgre   )
             - les visites sont a jour dans la table visite (dag : visite_oracle_postgre  )

Ce dag a pour objet la création d'un dataset

Ce DAG peut être executé seulement à l'intérieur du Ministère de la Transition Ecologique Et Solidaire.
"""
import pickle
from datetime import datetime

import numpy as np
import pandas as pd
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from helpers import connection_db, default_args
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import PoissonRegressor
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import FunctionTransformer, OneHotEncoder, StandardScaler

INPUT_VISITS_PARAMS = [
    "id_nav_flotteur",
    "date_visite",
    "nombre_prescriptions",
    "nombre_prescriptions_majeurs",
    "id_gin_visite",
]

INPUT_SITREP_PARAMS = ["id_nav_flotteur", "annee", "sitrep"]

INPUT_NAVIRE_PARAMS = [
    "id_nav_flotteur",
    "annee_construction",
    "genre_navigation",
    "materiau_coque",
    "situation_flotteur",
    "type_carburant",
    "type_moteur",
    "idc_gin_categ_navigation",
    "longueur_hors_tout",
    "jauge_oslo",
    "puissance_administrative",
    "num_version",
]

OUTPUT_CAT_PARAM = [
    "genre_navigation",
    "materiau_coque",
    "situation_flotteur",
    "type_moteur",
    "idc_gin_categ_navigation",
]

OUTPUT_NUM_PARAM = [
    "longueur_hors_tout",
    "puissance_administrative",
    "nombre_prescriptions_hist",
    "nombre_prescriptions_majeurs_hist",
    "age",
]

LOG_PARAM = [
    "longueur_hors_tout",
    "puissance_administrative",
]


default_args = default_args({"start_date": datetime(2019, 3, 17, 6, 40), "retries": 0})


dag = DAG(
    dag_id="app",
    default_args=default_args,
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval="@daily",
)

dag.doc_md = __doc__


def load_visits(engine):
    ## Résumés de visites avec le nombre de prescriptions
    query = pd.read_sql(
        f"select {', '.join(INPUT_VISITS_PARAMS)} from visite_securite where extract(year from date_visite) >= 2015",
        engine,
    )
    query["annee_visite"] = query["date_visite"].apply(
        lambda date_visite: date_visite.year
    )
    query["date_visite"] = query["date_visite"].apply(
        lambda date_visite: date_visite.date()
    )
    return query.fillna(0)


def load_sitrep(engine):
    return pd.read_sql(f"select {', '.join(INPUT_SITREP_PARAMS)} from sitrep", engine)


def load_navire(engine, prediction_phase=False):
    query = f"select {', '.join(INPUT_NAVIRE_PARAMS)} from navire where longueur_hors_tout < 24"
    if (
        prediction_phase
    ):  ## Nous ne gardons que les navires dont le PN est actif pour le ranking
        return pd.read_sql(
            "{} and (idc_certificat in (47,67,68,69,1007)) and (idc_etat_certificat<=3 or idc_etat_certificat=6)".format(
                query
            ),
            engine,
        )
    else:
        return pd.read_sql(query, engine)


def exporter_df(df: pd.DataFrame, engine, indexes: list = []):
    df.date_visite = df.date_visite.astype(str)
    df = df.set_index(indexes)
    df.to_sql("dataset_train", engine, if_exists="replace")


def trie_dataset(df):
    """Retourne un dataset groupé par navire, trié par date de visite"""
    df = df.set_index(["id_nav_flotteur", "date_visite"])
    df = df.sort_index()
    return df.reset_index()


def sitrep_anterieur_visite(visite, sitreps: pd.DataFrame):
    """
    Retourne le nombre de sitreps (Situation Report) connus dans tout l'historique jusqu'à l'année précédent à la visite
    """
    navire = visite["id_nav_flotteur"]
    annee_visite = visite["date_visite"].year
    return sitreps[
        (sitreps["id_nav_flotteur"] == navire) & (sitreps["annee"] < annee_visite)
    ]["sitrep"].sum()


def ajout_delai_entre_visites(df):
    df_time = df.copy()
    engine = connection_db()  ## Connection aux tables postgres

    df_time.to_sql("debug_visits", engine, if_exists="replace")

    df_time["delai_visites"] = df_time["date_visite"].diff()
    df_time["checkindex"] = df_time["id_nav_flotteur"].diff()

    # The diff function will apply to all the visits. We will only consider the lines where the vessel is the same (id_nav_flotteur - id_nav_flotteur == 0)
    df_time["delai_visites"] = df_time.apply(
        lambda row: row["delai_visites"].days if row["checkindex"] == 0 else np.nan,
        axis=1,
    )
    df_time["delai_visites"] = df_time["delai_visites"].fillna(365)
    del df_time["checkindex"]
    return df_time


def recode_categ(categ):
    mapping = {
        1: "5ème (eaux abritées)",
        2: "4ème (5 milles des eaux abritées)",
        3: "4ème (5 milles des eaux abritées)",
        4: "4ème (5 milles des eaux abritées)",
        5: "3ème (20 milles de la terre)",
        7: "3ème (20 milles de la terre)",
        8: "2ème (200 milles d'un port)",
        9: "2ème (200 milles d'un port)",
        10: "1ère",
        11: "6ème plaisance (2 milles d'un abri)",
        12: "5ème plaisance (5 milles d'un abri)",
        13: "4ème plaisance (20 milles d'un abri)",
        14: "3ème plaisance (60 milles d'un abri)",
    }
    return categ.replace(mapping)


def recode_materiau_coque(materiau_coque):
    mapping = {
        "AG/4 - ALU": "METAL",
        "ACIER": "METAL",
        "ACIER / INOX": "METAL",
        "ALLIAGE LEGER": "METAL",
        "BOIS MASSIF": "BOIS",
        "BOIS MOULE": "BOIS",
        "CONTREPLAQUE": "BOIS",
        "POLYESTER EPOXY": "PLASTIQUE",
        "POLYETHYLENE": "PLASTIQUE",
        "PLASTIQUE SANDWICH": "PLASTIQUE",
        "INCONNU": None,
    }

    return materiau_coque.replace(mapping)


def recode_type_moteur(type_moteur):
    type_moteur.loc[
        np.logical_and(type_moteur != "Explosion", type_moteur != "Combustion interne")
    ] = "Autre"
    return type_moteur


def lag_variable_by_year(data, variable):
    """
    Cette fonction permet de créer une nouvelle variable (avec le suffixe
    "_hist") qui contient la valeur de l'année précédente (sommée si plusieurs
    observations.
    """

    # On copie pour ne pas modifier directement notre Dataframe
    df = data.copy(deep=True)

    df = (
        df.groupby(["id_nav_flotteur", "annee_visite"])[variable]
        .sum()
        .reset_index(name=variable)
    )
    df = df.sort_values(by="annee_visite")

    lagged_variable_name = f"{variable}_hist"
    df[lagged_variable_name] = df.groupby("id_nav_flotteur")[variable].shift(1)

    df = pd.merge(
        data,
        df.drop(columns=[variable]),
        on=["id_nav_flotteur", "annee_visite"],
        how="left",
    )

    return df


# Création de la cible au moins une prescription majeure ou au moins 4 mineurs
def creation_cibles(df: pd.DataFrame):
    df["cible"] = df["nombre_prescriptions_majeurs"]
    return df


def creation_visite_simulee(visites):
    tmp = pd.DataFrame()
    for navire in visites["id_nav_flotteur"].unique():
        ligne = {
            "date_visite": datetime.today(),
            "annee_visite": datetime.today().year,
            "id_nav_flotteur": navire,
            "id_gin_visite": -1,
            "nombre_prescriptions": 0,
            "annee_construction": visites[visites["id_nav_flotteur"] == navire][
                "annee_construction"
            ].max(),
            "nombre_prescriptions_majeurs": 0,
        }
        for param in OUTPUT_CAT_PARAM + OUTPUT_NUM_PARAM:
            if param not in [
                "nombre_prescriptions_hist",
                "nombre_prescriptions_majeurs_hist",
                "age",
                "sitrep_history",
                "delai_visites",
                "annee_visite",
            ]:
                ligne[param] = visites[visites["id_nav_flotteur"] == navire][
                    param
                ].max()
        tmp = pd.concat([tmp, pd.DataFrame([ligne])], ignore_index=True)
    return tmp


## Début First Task - Creation des dataset predict et train


## Load visit, navire and sitrep databases and merge
def creation_dataset(engine, prediction_phase=False):
    visites = load_visits(engine)
    navires = load_navire(engine, prediction_phase)
    sitreps = load_sitrep(engine)

    df = pd.merge(
        left=visites,
        right=navires,
        left_on="id_nav_flotteur",
        right_on="id_nav_flotteur",
    )

    # A ce stade, une ligne correspond a une visite de sécurité
    if prediction_phase:
        df = creation_visite_simulee(df)

    df = trie_dataset(df)
    # Ajout pour chaque visite des sitrep anterieures
    df["sitrep_history"] = df.apply(
        lambda row: sitrep_anterieur_visite(row, sitreps), axis=1
    ).fillna(0)
    return df


# Creation des dataset, entrainement ou prevision
# Sortie : Ecriture directe dans la table dataset_train / ou renvoi dataset_predict
def process_dataset(prediction_phase=False):
    engine = connection_db()  ## Connection aux tables postgres
    df = creation_dataset(engine, prediction_phase=prediction_phase)

    df = ajout_delai_entre_visites(df)

    # Calcul des historiques de prescriptions
    df = lag_variable_by_year(df, "nombre_prescriptions")
    df = lag_variable_by_year(df, "nombre_prescriptions_majeurs")
    df["nombre_prescriptions_hist"] = df["nombre_prescriptions_hist"].fillna(0)
    df["nombre_prescriptions_majeurs_hist"] = df[
        "nombre_prescriptions_majeurs_hist"
    ].fillna(0)

    df["age"] = df["annee_visite"] - df["annee_construction"]  # probleme : age erroné
    del df["annee_construction"]

    df["idc_gin_categ_navigation"] = recode_categ(df["idc_gin_categ_navigation"])
    df["materiau_coque"] = recode_materiau_coque(df["materiau_coque"])
    df["type_moteur"] = recode_type_moteur(df["type_moteur"])

    if not prediction_phase:  ## Pour l entrainement du modele
        df = creation_cibles(df)
        exporter_df(df, engine, ["id_nav_flotteur", "annee_visite"])
    else:  ## Pour la prediction
        df = df[df.id_gin_visite == -1]
        return df


## Début Seconde Task - Entrainement du modele de machine learning


def chargement_dataset(
    engine, columns, database="dataset_train", prediction_phase=False
):
    query = f"select {', '.join(columns)}"
    ## Renvoi de la cible pour entrainement modele
    if not prediction_phase:
        df = pd.read_sql("{}, cible  from {}".format(query, database), engine)
    else:
        df = pd.read_sql("{} from {}".format(query, database), engine)

    if "situation_flotteur" in df:
        df["situation_flotteur"] = df["situation_flotteur"].astype(str)
    if "genre_navigation" in df:
        df["genre_navigation"] = df["genre_navigation"].astype(str)
    if "type_moteur" in df:
        df["type_moteur"] = df["type_moteur"].astype(str)
    if "type_carburant" in df:
        df["type_carburant"] = df["type_carburant"].astype(str)
    if "materiau_coque" in df:
        df["materiau_coque"] = df["materiau_coque"].astype(str)
    return df


def split_target(df, prediction_phase=False):
    y = df["cible"].copy()
    del df["cible"]
    if prediction_phase:
        return df
    else:
        return df, y


def predict_cible(model, X):
    y_pred = model.predict(X)
    return y_pred


def create_preprocessing_pipeline():
    categorical_preprocessing = Pipeline(
        [
            ("imputer_str", SimpleImputer(strategy="constant", fill_value="None")),
            ("ohe", OneHotEncoder(handle_unknown="ignore")),
        ]
    )

    log_preprocessing = Pipeline(
        steps=[
            (FunctionTransformer(np.log1p)),
        ]
    )

    numeric_preprocessing = Pipeline(
        steps=[
            ("imputer_num", SimpleImputer(strategy="mean")),
            ("scaler", StandardScaler()),
        ]
    )

    preprocess = ColumnTransformer(
        [
            ("categorical_preprocessing", categorical_preprocessing, OUTPUT_CAT_PARAM),
            ("log transformation", log_preprocessing, LOG_PARAM),
            ("numerical_preprocessing", numeric_preprocessing, OUTPUT_NUM_PARAM),
        ]
    )
    return preprocess


def train():
    engine = connection_db()

    df = chargement_dataset(
        engine, columns=OUTPUT_NUM_PARAM + OUTPUT_CAT_PARAM, prediction_phase=False
    )

    model_pipe = Pipeline(
        [
            ("preprocess", create_preprocessing_pipeline()),
            ("Poisson glm", PoissonRegressor()),
        ]
    )

    x, y = split_target(df, prediction_phase=False)

    model = model_pipe.fit(x, y)

    # Saving model
    pickle.dump(model, open("/opt/etl/airflow/modeles/cibnav_ml_v4.pkle", "wb"))


## Début Troisième Task - Génération d un jeu de donnees qui simule pour chaque navire une visite de securite aujourd hui
## Creation du dataset de ciblage pour la production
## Sortie : Table dataset_predict


def export_dataset_predict():
    engine = connection_db()
    df = process_dataset(prediction_phase=True)
    # On enleve les cibles de prevision
    del df["nombre_prescriptions"]
    del df["nombre_prescriptions_majeurs"]
    df.to_sql("dataset_predict", engine, if_exists="replace", index=False)


## Début Quatrieme Task - Prévision sur la flotte actuelle et priorisation


def prediction_flotte():
    engine = connection_db()
    df = chargement_dataset(
        engine,
        columns=OUTPUT_NUM_PARAM + OUTPUT_CAT_PARAM + ["id_nav_flotteur"],
        database="dataset_predict",
        prediction_phase=True,
    )

    previsions = pd.DataFrame(index=df.id_nav_flotteur)

    del df["id_nav_flotteur"]

    model_pipe = pickle.load(open("./dump/cibnav_ml_v4.pkle", "rb"))
    y_pred = predict_cible(model_pipe, df)
    previsions["prevision"] = y_pred

    previsions = previsions.sort_values(by="prevision", ascending=False)
    previsions["ranking"] = np.arange(start=1, stop=len(previsions) + 1)
    previsions.to_sql(
        "score_v4",
        engine,
        if_exists="replace",
    )


## Definition des task Airflow

task_process_data = PythonOperator(
    task_id="process_training_data",
    python_callable=process_dataset,
    dag=dag,
)

task_train_model = PythonOperator(
    task_id="train_model",
    python_callable=train,
    dag=dag,
)

task_dataset_flotte = PythonOperator(
    task_id="process_prediction_data",
    python_callable=export_dataset_predict,
    dag=dag,
)


task_prediction_visites = PythonOperator(
    task_id="predict_prod",
    python_callable=prediction_flotte,
    dag=dag,
)

## Ordre des taches Airflow
start = EmptyOperator(task_id="start", dag=dag)
end = EmptyOperator(task_id="end", dag=dag)

task_process_data.set_upstream(start)
task_dataset_flotte.set_upstream(start)

task_train_model.set_upstream(task_process_data)

task_prediction_visites.set_upstream([task_dataset_flotte, task_train_model])

end.set_upstream(task_prediction_visites)
