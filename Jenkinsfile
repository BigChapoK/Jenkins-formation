pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                // Récupération du code source
                checkout scm
            }
        }
        
        stage('Test') {
            agent {
                docker {
                    // Jenkins télécharge cette image et démarre un conteneur éphémère.
                    // Le code source est automatiquement monté à l'intérieur.
                    image 'maven:3.9.6-eclipse-temurin-21'
                    // On partage le dossier .m2 pour éviter de retélécharger les dépendances à chaque build
                    args '-v $HOME/.m2:/root/.m2'
                }
            }
            steps {
                // Exécution des tests unitaires
                sh 'mvn test'
            }
        }
        
        stage('SonarScanner') {
            steps {
                // Transmission des métriques analytiques au serveur SonarQube
                withSonarQubeEnv('ServeurSonarQubeTP') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                // Frontière automatisée et intraitable
                timeout(time: 1, unit: 'HOURS') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
    
    post {
        always {
            // Remontée et automatisation des rapports dans l'interface Jenkins
            junit '**/target/surefire-reports/*.xml'
        }
    }
}
