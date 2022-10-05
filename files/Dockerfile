# import de l'image de base
FROM debian

# Information complementaire sur la version dockerfile
LABEL version="1.0" maintainer="Antony <antony.alsberghe@hotmail.fr>"

# Commande a executer dans le conteneur
RUN apt update && apt upgrade -y && apt install nodejs -y && apt install npm -y && apt install nano -y

# Se placer dans le working directory
WORKDIR /home/web

# Copie des fichiers a l'interieur de notre container
COPY . .

# Exposition des ports
EXPOSE 80

# Commande a executer dans le conteneur
RUN npm install express

# Commande de démarage du conteneur
CMD ["node", "index.js"]