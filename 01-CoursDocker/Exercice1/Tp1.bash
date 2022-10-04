######################################################################
#				Tp1 - Premier conteneur Debian
######################################################################

## => Démarer un conteneur à partir d'une image debian:latest
## => Se connecter au bash du conteneur
## => mise à jour de ce conteneur
## => Installer l'editeur nano (vim)
## => Ecrire un fichier texte contenant du texte nommé text.txt
## => Afficher le contenu du fichier text.txt

######################## Correction ##################################

## Rechercher l'image de Debian:latest
$ docker search debian:latest

## Téléchargement de l'image debian:latest
$ docker pull debian:latest

## Création d'une instance de l'image debian
$ docker run -it --name=my_debian_container debian:latest 

## Executer le bash
$ docker exec -i my_debian_container bash

## Télécharger les mises à jour puis metre à jour puis installer nano
$ apt update && apt upgrade -y && apt install nano -y

## Création du fichier text text.txt
$ nano text.txt

## Execution du fichier txt
cat text.txt