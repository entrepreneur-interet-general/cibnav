#!/bin/bash

# script setup
set -e # will stop the script if any command fails with a non-zero exit code
set -o pipefail # ... even for tests which pipe their output to indent

# Helper functions
function indent {
  sed 's/^/  /'
}

create_or_import_database() {

  local HOST="$1"
  local PORT="$2"
  local DB="$3"
  local USER="$4"
  export PGPASSWORD="$5"

  # Check if database already exists
  DBEXISTS=$(psql -U postgres -h "${HOST}" --tuples-only -c "SELECT datname FROM pg_catalog.pg_database WHERE datname='${DB}'")

  if [ -z "${DBEXISTS}" ]
  then
    echo "🔍 database \"${DB}\" does not exist."

    echo "🆕 Creating database..."
    (
    psql -h "${HOST}" -p "${PORT}" -U postgres \
      -c "CREATE USER ${USER} WITH PASSWORD '${PGPASSWORD}';" \
      -c "CREATE DATABASE ${DB} OWNER ${USER};" \
      -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;" 
        ) 2>&1 | indent
    echo "Database creation DONE"

    echo "🗂️ Importing database... In case of failure, clean the database with scripts/drop_data_db.sh"
    (psql -h "${HOST}" -p "${PORT}" -U "${USER}"\
      -c "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;" 
        ) 2>&1 | indent
    (pg_restore --host "${HOST}" --port "${PORT}" --username "${USER}" --dbname "${DB}" --schema public --exit-on-error ./dump/"${DB}".tar) 2>&1 | indent
    echo "Import DONE"

  else
    echo "🔍 Database \"${DB}\" already exists."
    echo "   Drop it for a new import with scripts/drop_data_db.sh"
    echo "   Skipping setup."
  fi
}

