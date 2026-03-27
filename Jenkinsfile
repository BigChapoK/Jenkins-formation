pipeline {
    // ÉTAPE 0 : Définition de l'agent global
    // "agent any" signifie que le pipeline commence par s'exécuter directement sur le serveur Debian (le noeud Jenkins).
    agent any

    environment {
        IMAGE_NAME = "mon-app-java"
        IMAGE_TAG  = "${env.BUILD_NUMBER}" // Utilise le numéro de build Jenkins comme tag unique
        CONTAINER_NAME = "mon-app-java-container" 
    }

    stages {
        // ÉTAPE 1 : Récupération du code source
        stage('Checkout') {
            steps {
                // Récupère le code depuis le dépôt Git configuré dans le job Jenkins
                checkout scm
            }
        }

        // ÉTAPE 2 : Compilation isolée (Le coeur de l'Agent Docker)
        stage('Build & Test (Containerized)') {
            agent {
                docker {
                    // Jenkins télécharge cette image et démarre un conteneur éphémère.
                    // Le code source est automatiquement monté à l'intérieur.
                    image 'maven:3.9.6-eclipse-temurin-21'
                    // On partage le dossier .m2 pour éviter de retélécharger les dépendances à chaque build
                    args '-u root -v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                // Cette commande s'exécute À L'INTÉRIEUR du conteneur Maven ci-dessus.
                // Elle produit le fichier JAR dans le dossier target/
                sh 'mvn clean package -DskipTests'
            }
            // À la fin de ce stage, le conteneur Maven est automatiquement détruit.
        }

        // ÉTAPE 3 : Création de l'image de production (Utilisation du Dockerfile)
        stage('Build Docker Image') {
            steps {
                echo 'Construction de l\'image via Docker CLI...'
                // Ici, on revient sur l'hôte Debian. 
                // Docker build lit le fichier "Dockerfile" et y injecte le JAR généré à l'étape précédente.
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                // On crée un alias "latest" pour faciliter le déploiement
                sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${IMAGE_NAME}:latest"
            }
        }

        // ÉTAPE 4 : Déploiement local (Cycle de vie du conteneur)
        stage('Run Locally') {
            steps {
                echo 'Arrêt et suppression de l\'ancien conteneur (s\'il existe)...'
                // On nettoie l'ancienne version pour libérer le port 8080
                sh "docker rm -f ${CONTAINER_NAME} || true"
                
                echo 'Démarrage du nouveau conteneur...'
                // Lancement de l'application :
                // -d : mode détaché (arrière-plan)
                // -p : map le port 8080 du serveur vers le 8080 du conteneur
                sh "docker run -d -p 8080:8080 --name ${CONTAINER_NAME} ${IMAGE_NAME}:latest"
            }
        }

        // ÉTAPE 5 : Maintenance du serveur
        stage('Local Cleanup') {
            steps {
                echo 'Nettoyage des images intermédiaires...'
                // Supprime les images "dangling" (sans nom) créées durant le build pour ne pas saturer le disque
                sh "docker image prune -f"
            }
        }
    }
}
