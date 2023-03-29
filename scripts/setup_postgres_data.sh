#!/usr/bin/env bash

######################################
# Must be used in docker environment
######################################


# script setup
set -e # will stop the script if any command fails with a non-zero exit code
set -o pipefail # ... even for tests which pipe their output to indent

# Helper functions
function indent {
  sed 's/^/  /'
}


export PGPASSWORD="${POSTGRES_PASSWORD}"

USER=cibnav
HOST=postgres ## Name of the service in the docker compose
PORT=5432

# Check if database already exists
DBEXISTS=$(psql -U postgres -h "${HOST}" --tuples-only -c "SELECT datname FROM pg_catalog.pg_database WHERE datname='cibnav'")

if [ -z "${DBEXISTS}" ]
then
  echo "🔍 database \"cibnav\" does not exist."

  echo "🆕 Creating database..."
  (
  psql -h "${HOST}" -p "${PORT}" -U postgres \
    -c "CREATE USER ${USER} WITH PASSWORD '$POSTGRES_PASSWORD';" \
    -c "CREATE DATABASE cibnav OWNER ${USER};"
      ) 2>&1 | indent
  echo "Database creation DONE"

  echo "🗂️ Importing database... In case of failure, clean the database with scripts/drop_data_db.sh"
  (pg_restore --host "${HOST}" --port "${PORT}" --username "${USER}" --dbname cibnav --schema public --exit-on-error ./dump/cibnav.tar) 2>&1 | indent
  echo "Data import DONE"

else
  echo "🔍 Database \"cibnav\" already exists."
  echo "   Drop it for a new import with scripts/drop_data_db.sh"
  echo "   Skipping setup."
fi
