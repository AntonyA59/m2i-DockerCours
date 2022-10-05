# import de l'image de base
FROM openjdk:8

RUN apt update && apt upgrade -y

WORKDIR /usr/src/myapp

COPY . .

RUN javac Main.java

CMD ["java", "Main"]