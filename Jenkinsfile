pipeline {
    agent any

    environment {
        // Définition de variables pour le nommage
        IMAGE_NAME       = "mon-app-java"
        IMAGE_TAG        = "${env.BUILD_NUMBER}"
        CONTAINER_NAME   = "mon-app-java-cointaner"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération depuis le repo git'
                checkout scm
            }
        }
        stage('Build & Tests (Containerized)') {
            agent {
                docker {
                    image "maven:3.9.6-eclipse-temurin-21"
                    args "-v $HOME/.m2:/root/.m2"
                }
            }
            steps {
                sh "mvn clean package -DskipTests"
            }
        }
        stage('Build Docker Image') {
            steps {
                echo 'Construction de l\'image via Docker CLI'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }
        stage('Run Locally') {
            steps {
                echo 'Arrêt et suppression de l\'ancien conteneur (s\'il existe)'
                // Le "|| true" permet au pipeline de ne pas échouer si le conteneur n'existe pas encore
                sh "docker rm -f ${CONTAINER_NAME} || true"

                echo 'Démarrage du nouveau conteneur...'
                // Exécution en tâche de fond (-d) et mapping du port 8080
                sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
            }
        }
        stage('Local Cleanup') {
            steps {
                echo 'Nettoyage des images intermédiaires...'
                sh "docker image prune -f"
            }
        }
    }
}
