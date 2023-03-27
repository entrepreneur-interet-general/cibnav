from datetime import datetime, timedelta

import pandas as pd
from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from dotenv import load_dotenv
from helpers import connection_db

load_dotenv()


def test():
    engine = connection_db()

    df2 = pd.DataFrame({"name": ["User 6", "User 7"]})
    print(df2)
    df2.to_sql("sitrep", con=engine, if_exists="replace")
    engine.execute("SELECT * FROM sitrep").fetchall()


dag = DAG(
    "sitrep_test",
    start_date=datetime(2019, 3, 17, 6, 40),
    max_active_runs=1,
    concurrency=2,
    catchup=False,
    schedule_interval="@daily",
)

dag.doc_md = __doc__


test_op = PythonOperator(
    task_id="test_op",
    python_callable=test,
    execution_timeout=timedelta(minutes=60),
    dag=dag,
)

start = EmptyOperator(task_id="start", dag=dag)
end = EmptyOperator(task_id="end", dag=dag)

test_op.set_upstream(start)

end.set_upstream(test_op)
