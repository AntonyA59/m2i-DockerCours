## Décompresser l'archive
app.zip

##################
# Création image #
##################

## Création du docker file pour création de l'image
FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js"]

## Build de l'image de notre application
$ docker build -t docker_demo_image .

######################
# Création Container #
######################

## Instanciation de l'image crée
$ docker run --name=docker_demo_container -dp 3000:3000 --rm docker_demo_image

## Vérification du fonctionnement de l'app
http://localhost:3000

####################
# Update Container #
####################

## Arret du container
$ docker stop docker_demo_container

## Modification de notre application src/static/js/app.js
-  <p className="text-center">You have no todo items yet! Add one above!</p>
+  <p className="text-center">You have nothing in the todolist! Add one above!</p>

## Re-build de l'image de notre application
$ docker build -t docker_demo_image .

## Instanciation de l'image modifiée
$ docker run --name=docker_demo_container -dp 3000:3000 --rm docker_demo_image

## Vérification de la modification l'app
http://localhost:3000

##############
# DOCKER HUB #
##############

## Création d'une image MAJ pour la push sur le HUB => Convention de nommage : NomUtilisateurReposDocker/NomImage
$ docker commit docker_demo_container petitvulcan/my_demo_docker

## Push de notre image sur le Hub Docker => Possibilité de lui ajouter un tag
$ docker push petitvulcan/my_demo_docker:latest

## Stop du container en cours d'exe
$ docker stop docker_demo_container

## Instanciation de l'image depuis le hub
$ docker run --name=my_docker_demo_container -dp 3000:3000 --rm petitvulcan/my_demo_docker:latest

## Vérification de la modification l'app
http://localhost:3000

###########
# Volumes #
###########

# Création d'un volume todo-db
$ docker volume create todo-db

# Vérification de la création du volume
$ docker volume ls

## Instanciation de l'image et connection au volume
$ docker run --name=my_docker_demo_container --rm -dp 3000:3000 -v todo-db:/etc/todos petitvulcan/my_demo_docker:latest

## Vérification de la modification l'app => Ajout de données
http://localhost:3000

## Observer le Volume
$ docker volume inspect todo-db

## Arret du Container (suppression auto)
$ docker stop my_docker_demo_container

## Re-Instanciation de l'image et connection au volume
$ docker run --name=my_docker_demo_container --rm -dp 3000:3000 -v todo-db:/etc/todos petitvulcan/my_demo_docker:latest

## Vérification de la modification l'app => Les Données sont toujours présentes (persistance)
http://localhost:3000

###############################
# Point de Liaison (montage=) #
###############################

## Arret du Container (suppression auto)
$ docker stop my_docker_demo_container

## Instanciation d'un conteneur node:Alpine et bind de notre repertoire de travail en Volume
$ MSYS_NO_PATHCONV=1 docker run --name=my_demo_docker_container_dev --rm -dp 3000:3000 -w /app -v "$(pwd):/app" node:12-alpine sh -c "yarn install && yarn run dev"

# MSYS_NO_PATHCONV=1 => Resoud les problemes de chemein absolu sous windows
# -dp 3000:3000 - pareil qu'avant. Exécuter en mode détaché (arrière-plan) et créer un mappage de port
# -w /app - définit le "répertoire de travail" où le répertoire actuel à partir duquel la commande sera exécutée
# -v "$(pwd):/app" - lier monter le répertoire courant de l'hôte dans le conteneur dans le répertoire /app 
# node:12-alpine - l'image à utiliser. Notez qu'il s'agit de l'image de base de notre application à partir du Dockerfile
# sh -c "yarn install && yarn run dev" - la commande. Nous démarrons un shell en utilisant sh(alpine n'a pas bash) et en cours d'exécution yarn install 
# pour installer toutes les dépendances, puis en exécutant yarn run dev. Si nous regardons dans le package.json, nous verrons que le devscript démarre nodemon.

## Affichage des logs du serveur
$ docker logs -f my_demo_docker_container_dev

#######################
# Multi-Container-App #
#######################

# Création d'un réseau
$ docker network create todo-db

# Instanciation d'un container MySql
$ docker run --name=my_sql_container --rm -d --network todo-db --network-alias mysql -v todo-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=todos mysql:5.7.

# Connection à la BDD
$ docker exec -it my_sql_container mysql -u root -p

# Saisir le MDP
secret

# Une fois dans le shell mysql saisir
mysql> SHOW DATABASES;

# Retourne 
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| todos              |
+--------------------+
5 rows in set (0.00 sec)


## Instanciation de l'application dans un conteneur en mode dev avec connection au réseau et injection
$ MSYS_NO_PATHCONV=1 docker run --name=todo_app_container --rm -dp 3000:3000 \
   -w /app -v "$(pwd):/app" \
   --network todo-db \
   -e MYSQL_HOST=mysql \
   -e MYSQL_USER=root \
   -e MYSQL_PASSWORD=secret \
   -e MYSQL_DB=todos \
   node:12-alpine \
   sh -c "yarn install && yarn run dev"

## Vérification de la modification l'app => Ajouter des datas
http://localhost:3000

#######################
#   Docker-Compose    #
#######################

# Création d'un fichier Docker-Compose a la racine de notre app

version: '3.7'

services:
    db:
        image: mysql:5.7
        container_name: mysql-container_name
        volumes:
            - todo-mysql-data:/var/lib/mysql
        environment:
            - MYSQL_ROOT_PASSWORD:secret
            - MYSQL_DATABASE:todos
    app:
        image: node:12-alpine
        command: sh -c "yarn install && yarn run dev"
        ports:
            - 3000:3000
        working_dir: /app
        volumes:
            - ./:/app
        environment:
            - MYSQL_HOST:mysql
            - MYSQL_USER:root
            - MYSQL_PASSWORD:secret
            - MYSQL_DB:todos
volumes:
    todo-mysql-data:


# Démarrage de notre application multi container
$ docker compose up -d