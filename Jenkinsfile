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
