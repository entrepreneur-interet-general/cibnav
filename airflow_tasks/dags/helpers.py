# -*- coding: utf-8 -*-

from datetime import datetime, timedelta

from airflow.models import Variable
from airflow.operators.bash_operator import BashOperator
from dotenv import load_dotenv
from hashlib import sha1
from sqlalchemy import create_engine
import os
import re

load_dotenv()

def connection_db():
    engine = create_engine(
        "postgresql://{user}:{pwd}@{host}:{port}/{db}".format(
            user = os.environ['EMBULK_POSTGRESQL_USER'],
            pwd  = os.environ['EMBULK_POSTGRESQL_PASSWORD'],
            host = os.environ['EMBULK_POSTGRESQL_HOST'],
            port = os.environ['EMBULK_POSTGRESQL_PORT'],
            db   = os.environ['EMBULK_POSTGRESQL_DB']
            )
        )
    return engine


def base_path():
    return os.path.join("/", "opt")


def embulk_filepath():
    return os.path.join(base_path(), "etl", "embulk",
                        "oracle_to_postgres.yml.liquid")


def embulk_bin():
    return "embulk run -l debug"


def yesterday_date():
    return datetime.now() - timedelta(days=1)


def default_env():
    # Fetching the variables stored in config.json
    ocan_config = Variable.get("cibnav-ocan-config", deserialize_json=True)
    return {
        # PostgreSQL
        'EMBULK_POSTGRESQL_HOST'     : os.environ['EMBULK_POSTGRESQL_HOST'],
        'EMBULK_POSTGRESQL_USER'     : os.environ['EMBULK_POSTGRESQL_USER'],
        'EMBULK_POSTGRESQL_DB'       : os.environ['EMBULK_POSTGRESQL_DB'],
        'EMBULK_POSTGRESQL_PORT'     : os.environ['EMBULK_POSTGRESQL_PORT'],
        'EMBULK_POSTGRESQL_PASSWORD' : os.environ['EMBULK_POSTGRESQL_PASSWORD'],
        # Oracle
        'EMBULK_ORACLE_DRIVER_PATH'   : ocan_config['EMBULK_ORACLE_DRIVER_PATH'],
        'EMBULK_ORACLE_HOST'          : ocan_config['EMBULK_ORACLE_HOST'],
        'EMBULK_ORACLE_OCAN_USER'     : ocan_config['EMBULK_ORACLE_OCAN_USER_CIBLAGE'],
        'EMBULK_ORACLE_OCAN_DATABASE' : ocan_config['EMBULK_ORACLE_OCAN_DATABASE'],
        'EMBULK_ORACLE_OCAN_PASSWORD' : os.environ['EMBULK_ORACLE_OCAN_PASSWORD_CIBLAGE'],

    }


def resolve_env(env):
    if type(env) == dict:
        return {**(default_env()), **env}
    return default_env()


def embulk_run(dag, script, table, env=None, task_id=None):
    return BashOperator(task_id=task_id or 'embulk_run_' + script,
        bash_command="EMBULK_QUERY=$(cat \"/opt/etl/sql/{table}.sql\" | tr \'\n\' \' \') {bin} {file}".format(
            table=table, bin=embulk_bin(), file=embulk_filepath()), dag=dag,
        env=resolve_env(env))


def read_sql_query(filename):
    filepath = os.path.join(base_path(), "etl", "sql",
                            "{filename}.sql".format(filename=filename))
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    return re.sub('\s+', ' ', content)


def default_args(conf):
    default = {'owner': 'quentin-loridant', 'depends_on_past': False,
        'email': ['quentin.loridant@developpement-durable.gouv.fr'],
        'email_on_failure': True, 'email_on_retry': False, 'retries': 1,
        'retry_delay': timedelta(minutes=1), }
    return {**default, **conf}


def numero_immatriculation(val, secret):
    hashed = sha1('{secret}{immatriculation}'.format(secret=secret,
        immatriculation=val).encode('utf-8')).hexdigest()
    return hashed
