pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "fatousamba/devops-todo-app" // adapte à ton Docker ID
    }

    stages {
        stage('Installer les dépendances') {
            steps {
                dir('backend') {
                    sh 'npm install'
                }
                dir('frontend') {
                    sh 'npm install'
                }
            }
        }

        stage('Build Docker image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }
    }
}
