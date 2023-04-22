.PHONY: dump-data

AIRFLOW_CMD=airflow
CURRENT_DIRECTORY=cibnav

# AIRFLOW_CMD=/usr/local/bin/airflow

ifneq (,$(wildcard ./.env))
    include .env
endif

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk -F ":" '{print $$2 ":" $$3}' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'



dump-data: ## Dump data to "dump/cibnav.tar"
	@ docker exec $(CURRENT_DIRECTORY)-postgres-1 ash -c "PGPASSWORD=$(POSTGRES_PASSWORD) pg_dump  -U cibnav -h postgres --format=c -W --exclude-table ais --exclude-table avis --exclude-table user_account --exclude-table agent --exclude-table avis_id_seq --exclude-table user_account_id_seq> /home/data/cibnav.tar"

dump-metabase-config: ## Dump configuration to "dump/metabase.tar"
	@ docker exec $(CURRENT_DIRECTORY)-mb-postgres-1 ash -c "PGPASSWORD=$(MB_POSTGRES_PASSWORD) pg_dump -h mb-postgres --format=c -U metabase -W > /home/data/metabase.tar"

run-metabase: ## Run metabase docker container and dependencies
	@ docker compose up --build

run-airflow: run-airflow-scheduler run-airflow-webserver ## Run airflow server

run-airflow-scheduler:
	@ $(AIRFLOW_CMD) scheduler &

run-airflow-webserver:
	@ $(AIRFLOW_CMD) webserver -p 8080 &

reset-postgres: ## Irreversibly removes data (e.g. for a new fresh import)
	sudo rm -rfI docker/postgres

reset-mb-postgres: ## Irreversibly removes metabase config (e.g. for a new fresh import)
	sudo rm -rfI docker/mb-postgres

