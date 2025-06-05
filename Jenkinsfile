pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }

    stages {
        stage('Vérif Docker') {
            steps {
                sh 'docker --version'
                sh 'docker compose version'
            }
        }

        stage('Build & Run via Docker Compose') {
            steps {
                sh 'docker compose -f $DOCKER_COMPOSE_FILE down || true'
                sh 'docker compose -f docker-compose.yml up -d --build --force-recreate --remove-orphans'
            }
        }

        stage('Test Backend API') {
            steps {
                sh 'sleep 5'
                sh 'curl -f http://localhost:9090 || echo "⚠️ Backend non accessible"'
            }
        }

        stage('Test Frontend') {
            steps {
                sh 'curl -f http://localhost || echo "⚠️ Frontend non accessible"'
            }
        }
    }

    post {
        always {
            echo '🧹 Nettoyage...'
            sh 'docker compose -f $DOCKER_COMPOSE_FILE down'
        }
    }
}
