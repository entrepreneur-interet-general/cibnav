# -*- coding: utf-8 -*-
"""
# historicize_score 


This DAG can only be executed from within the intranet of the MTES.
"""
from datetime import datetime, timedelta
import csv
import os
import pandas as pd 

from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from helpers import default_args, embulk_run, read_sql_query, connection_db, numero_immatriculation
from sqlalchemy import create_engine
from sqlalchemy import update
from airflow.models import Variable
from datetime import date


default_args = default_args({
    'start_date': datetime(2019, 3, 17, 6, 40),
    'retries': 0
})


dag = DAG(
    'historicize_score',
    default_args=default_args,
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval='@daily'
)

dag.doc_md = __doc__


def historicize():
    engine = connection_db()
    df_score = pd.read_sql('select * from score_v3', engine)
    df_score['datetime'] = date.today()
    df_score.to_sql("score_v3_history", engine, if_exists='append')


task_historicize = PythonOperator(
    task_id='historicize',
    python_callable=historicize,
    execution_timeout=timedelta(minutes=60),
    dag=dag,
)

start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)


task_historicize.set_upstream(start)
end.set_upstream(task_historicize)

