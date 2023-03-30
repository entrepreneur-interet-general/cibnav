> **Warning**
> Projet en cours d'archivage. Se reporter au [nouveau repo](https://github.com/entrepreneur-interet-general/cibnav).

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
* `/root/cibnav-dev/dump/metabase.sql`
* `/root/cibnav-dev/dump/cibnav.sql`


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
