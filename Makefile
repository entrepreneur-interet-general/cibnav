.PHONY: dump-data

AIRFLOW_CMD=airflow
CURRENT_DIRECTORY=cibnav

# AIRFLOW_CMD=/usr/local/bin/airflow

ifneq (,$(wildcard ./.env))
    include .env
endif

dump-data:
	@ docker exec $(CURRENT_DIRECTORY)-postgres-1 ash -c "PGPASSWORD=$(POSTGRES_PASSWORD) pg_dump  -U cibnav -h postgres --format=c -W --exclude-table ais --exclude-table avis --exclude-table user_account --exclude-table agent --exclude-table avis_id_seq --exclude-table user_account_id_seq> /home/data/cibnav.tar"

dump-metabase-config:
	@ docker exec $(CURRENT_DIRECTORY)-mb-postgres-1 ash -c "PGPASSWORD=$(MB_POSTGRES_PASSWORD) pg_dump -h mb-postgres --format=c -U metabase -W > /home/data/metabase.tar"

run-metabase:
	@ docker compose up --build

run-airflow: run-airflow-scheduler run-airflow-webserver

run-airflow-scheduler:
	@ $(AIRFLOW_CMD) scheduler &

run-airflow-webserver:
	@ $(AIRFLOW_CMD) webserver -p 8080 &

reset-postgres:
	sudo rm -rfI docker/postgres

reset-mb-postgres:
	sudo rm -rfI docker/mb-postgres
