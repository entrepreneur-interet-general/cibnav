#!/usr/bin/env bash

# script setup
set -e # will stop the script if any command fails with a non-zero exit code


# Load environment variables
set -o allexport && . .env && set +o allexport
export PGPASSWORD="${POSTGRES_PASSWORD}"

HOST="${EMBULK_POSTGRESQL_HOST}"
PORT="${EMBULK_POSTGRESQL_PORT}"

read -p "Are you sure ? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo Dropping database cibnav
  psql -h "${HOST}" -p "${PORT}" -U postgres \
    -c "DROP DATABASE cibnav;"
fi


