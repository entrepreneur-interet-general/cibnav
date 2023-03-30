# -*- coding: utf-8 -*-
"""
# administre_oracle_postgre
Extract Cetegorie de navigation from GINA

This DAG can only be executed from within the intranet of the MTES.
"""
from datetime import datetime

from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from helpers import default_args, embulk_run, read_sql_query

default_args = default_args({
    'start_date': datetime(2019, 3, 17, 6, 40),
})


dag = DAG(
    'categorie_navigation_oracle_postgre_complet',
    default_args=default_args,
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval='@daily'
)

dag.doc_md = __doc__


table = "categorie_navigation_complet"

def embulk_export_static_data(dag, table):
    return embulk_run(
        dag,
        'oracle_to_postgresql',
        table,
        env={
            'EMBULK_TABLE_NAME': table,
            'EMBULK_ID_MERGE': "id_gin_navire_categ_navig",
        },
        task_id='export_static_data_' + table
    )
export_static_data = embulk_export_static_data(dag, table)


start = DummyOperator(task_id='start', dag=dag)
end = DummyOperator(task_id='end', dag=dag)


export_static_data.set_upstream(start)

end.set_upstream(export_static_data)

