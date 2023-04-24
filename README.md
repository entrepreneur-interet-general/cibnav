<img src="https://eig.etalab.gouv.fr/img/eig3-cibnav.svg" width="250"/>

## Documentation

La documentation de l'outil, des variables et du modèle est disponible
[ici](https://entrepreneur-interet-general.github.io/cibnav/).

La source en markdown est dans le dossier "docs", et la documentation est 
mise-à-jour en cas de changement à chaque push. 

## Data Engineering For CibNav

Utiliser Python3

## Connexion au serveur

L'accès au serveur se fait via Bastion. 

* [Lien bastion](https://access-manager-dam.din.developpement-durable.gouv.fr/wabam/dam?domain=local). Le premier mot de passe est le mot de passe personnel et le deuxième est le mot de passe d'application (token InWebo).

## Backend

* Base de données : Postgresql, utilisateur `cibnav`, nom de la base `cibnav`

Commande de connexion :

```sh
psql -U cibnav -W -h localhost
```

* Dashboard : Metabase

### Metabase en local

#### Exporter les données

```sh
make dump-data
```
 
#### Exporter la configuration Metabase

```sh
make dump-metabase-config
```

#### Télécharger les données localement avec scp via bastion

Menu contextuel > "Téléchargement SCP"

Et récupérer :
* `/root/cibnav-dev/dump/metabase.tar`
* `/root/cibnav-dev/dump/cibnav.tar`


#### Lancer le docker-compose

```sh
make run-metabase
```

#### Config connecteur postgresql - metabase

Se connecter au metabase après avoir lancé le docker-compose : `firefox localhost:3000`
Le compte adminstrateur est diponible dans le keepass : `Cibnav Metabase Admin` 

Allez dans le panneau `Réglages Adminstrateur` puis choisir l'onglet `Base de Données`. Séléctionnez la base CibNav et éditez les informations suivantes :
* Host : Adresse IP du containeur `postgres` (utiliser `docker inspect`)
* Port : 5432
* Nom de la database : cibnav
* User : cibnav
* Password : Défini par la variable $POSTGRES_PASSWORD
* Option SSL : Non

### Airflow en local

#### Configuration d'Airflow

- L'installation d'Airflow se fait via pip selon la manière recommandée sur le 
  [site officiel](https://airflow.apache.org/docs/apache-airflow/stable/installation/installing-from-pypi.html#)
- Mettre à jour le répertoire des DAGs `dags_folder` dans 
  "~/airflow/airflow.cfg"
- Créer un utilisateur Airflow avec la commande :

```sh
airflow users create --username admin --firstname F --lastname L --role Admin --email F.L@aol.fr
```

- Créer le fichier .env `cp .env.example .env` et compléter les variables 
  d'environnement.
  
- Lancer airflow avec `make run-airflow`.

### Python en local

Nous utilisons l'outil poetry pour gérer les dépendances et le packaging.

- [Installer poetry](https://python-poetry.org/docs/#installation) au besoin
- Installer les dépendances avec poetry `poetry install`
- Activer le shell `poetry shell`
- Installer le reste des dépendances (notamment airflow qui ne supporte pas 
  poetry) via `pip install -r requirements.txt`


### Déploiement

#### Sans mise à jour des données

Nécessite sur le serveurs les fichiers suivants :
* scripts/setup_db.sh
* docker-compose.yml
* dump/cibnav.tar
* dump/metabase.tar

Nécessite les variables d'environnement suivantes :
* PGPASSWORD (mot de passe de la base de données pour l'utilisateur postgres)
* POSTGRES_PASSWORD (mot de passe de la base de données pour l'utilisateur cibnav, si la base n'est pas encore crée, le mot de passe sera initialisé avec cette valeur)
