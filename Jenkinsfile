pipeline {
    agent any

    environment {
        // Définition de variables pour le nommage
        IMAGE_NAME    = 'mon-image-web-locale'
        CONTAINER_NAME = 'mon-conteneur-web-local'
        PORT_HOTE      = '8081' // Le port sur lequel on accèdera au site
    }

    stages {
        stage('Génération des fichiers') {
            steps {
                echo 'Récupération de la page web index.html et du Dockerfile depuis le repo git'
                checkout scm
            }
        }
        stage('Build Java') {
            steps {
                echo 'Maven clean package'
                sh "mvn clean package -DskipTests"
            }
        }
        stage('Build Image Docker') {
            steps {
                echo 'Construction de l\'image Docker en local...'
                // Le point (.) indique à Docker de chercher le Dockerfile dans le dossier courant
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }
        stage('Nettoyage') {
            steps {
                echo 'Suppression de l\'ancien conteneur s\'il tourne déjà...'
                // Le "|| true" évite que le job plante si c'est la première fois qu'on le lance
                sh "docker rm -f ${CONTAINER_NAME} || true"
            }
        }
        stage('Lancement du Conteneur') {
            steps {
                echo 'Démarrage du nouveau conteneur...'
                sh "docker run -d -p ${PORT_HOTE}:80 --name ${CONTAINER_NAME} ${IMAGE_NAME}"
            }
        }
    }
}
