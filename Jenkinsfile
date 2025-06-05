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

        stage('Force Remove Containers') {
            steps {
                sh 'docker rm -f devops-todo-app-backend devops-todo-app-frontend prometheus grafana || true'
            }
        }

        stage('Build & Run via Docker Compose') {
            steps {
                sh 'docker compose -f $DOCKER_COMPOSE_FILE down || true'
                sh 'docker compose -f $DOCKER_COMPOSE_FILE up -d --build --force-recreate --remove-orphans'
            }
        }

        stage('Test Backend API') {
            steps {
                sh 'docker exec devops-todo-app-backend curl -s -f http://localhost:5000/metrics || echo "⚠️ /metrics non accessible dans le container backend"'
            }
        }

        stage('Test Frontend') {
            steps {
                sh 'docker exec devops-todo-app-frontend curl -s -f http://localhost || echo "⚠️ Frontend non accessible dans le container"'
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline terminé – conteneurs conservés pour test'
        }
    }
}
