pipeline {
    agent any

    environment {
        // Définition de variables pour le nommage
        IMAGE_NAME    = 'mon-image-web-locale'
        CONTAINER_NAME = 'mon-conteneur-web-local'
        PORT_HOTE      = '8082' // Le port sur lequel on accèdera au site
    }

    stages {
        stage('Génération des fichiers') {
            steps {
                echo 'Création de la page web index.html à la volée... Formation Jenkins - ASCENT Version 1.0'

                checkout scm

                echo 'Création du Dockerfile à la volée...'

                writeFile file: 'Dockerfile', text: '''
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
'''
            }
        }
        // ... (autres stages éventuels)
    }
}
