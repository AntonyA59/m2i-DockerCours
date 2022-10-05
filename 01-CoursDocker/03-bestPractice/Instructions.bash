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





