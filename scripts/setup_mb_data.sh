#!/usr/bin/env bash

# script setup
set -e # will stop the script if any command fails with a non-zero exit code
set -o pipefail # ... even for tests which pipe their output to indent

# Helper functions
function indent {
  sed 's/^/  /'
}


export PGPASSWORD="${MB_POSTGRES_PASSWORD}"

USER="${MB_POSTGRES_USER}"
HOST="${MB_POSTGRES_HOST}"
PORT="${MB_POSTGRES_PORT}"


# Check if database already exists
DBEXISTS=$(psql -U postgres -h "${MB_POSTGRES_HOST}" --tuples-only -c "SELECT datname FROM pg_catalog.pg_database WHERE datname='metabase'")

if [ -z "${DBEXISTS}" ]
then
  echo "🔍 database \"metabase\" does not exist."

  echo "🆕 Creating database..."
  (
  psql -h "${MB_POSTGRES_HOST}" -p "${PORT}" -U postgres \
    -c "CREATE USER ${USER} WITH PASSWORD '${PGPASSWORD}';" \
    -c "CREATE DATABASE metabase OWNER ${USER};"
      ) 2>&1 | indent
  echo "Database creation DONE"

  echo "🗂️ Importing database... In case of failure, clean the database with scripts/drop_data_db.sh"
  (pg_restore --host postgres --port 5432 --username metabase --dbname metabase --schema public --exit-on-error ./dump/metabase.tar) 2>&1 | indent
  echo "Data import DONE"

else
  echo "🔍 Database \"metabase\" already exists."
  echo "   Drop it for a new import with scripts/drop_data_db.sh"
  echo "   Skipping setup."
fi
