# -*- coding: utf-8 -*-
"""
# controles_securite_oracle_postgre
Extract Administrated data from the Oracle database and dump it to CSV.

This DAG can only be executed from within the intranet of the MTES.
"""
from datetime import datetime

from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from helpers import default_args, embulk_run, read_sql_query

default_args = default_args({
    'start_date': datetime(2019, 3, 17, 6, 40),
})

table = "visite_securite"

dag = DAG(
    'visite_oracle_postgre',
    default_args=default_args,
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval='@daily'
)

dag.doc_md = __doc__


def embulk_export(dag, table):
    return embulk_run(
        dag,
        'oracle_to_postgresql',
        table,
        env={
            'EMBULK_TABLE_NAME': table,
            'EMBULK_ID_MERGE': "id_gin_visite",
        },
        task_id='export_' + table
    )


start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)

export = embulk_export(dag, table)
export.set_upstream(start)
end.set_upstream(export)

