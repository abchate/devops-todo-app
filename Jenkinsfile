pipeline {
    agent any

    environment {
        COMPOSE_FILE = 'docker compose.yml'
    }

    stages {
        stage('Build & Run via Docker Compose') {
            steps {
                sh 'docker compose down || true' // pour nettoyer les anciens containers
                sh 'docker compose up -d --build'
            }
        }

        stage('Test Backend API') {
            steps {
                sh 'sleep 5' // attendre que les services démarrent
                sh 'curl -f http://localhost:9090 || echo " Backend non accessible"'
            }
        }

        stage('Test Frontend') {
            steps {
                sh 'curl -f http://localhost || echo " Frontend non accessible"'
            }
        }
    }

    post {
        always {
            echo '🧹 Nettoyage...'
            sh 'docker compose down'
        }
    }
}
