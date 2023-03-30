.PHONY: dump-data

AIRFLOW_CMD=airflow
# AIRFLOW_CMD=/usr/local/bin/airflow

dump-data:
	@ pg_dump  -U cibnav -h localhost -W --exclude-table ais --exclude-table avis --exclude-table user_account --exclude-table agent --exclude-table avis_id_seq --exclude-table user_account_id_seq> ./dump/cibnav.sql

dump-metabase-config:
	@ pg_dump -h localhost -U metabase -W > dump/metabase.sql

run-metabase: 
	@ docker compose up --build

run-airflow: run-airflow-scheduler run-airflow-webserver

run-airflow-scheduler:
	@ $(AIRFLOW_CMD) scheduler &

run-airflow-webserver:
	@ $(AIRFLOW_CMD) webserver -p 8080 &
