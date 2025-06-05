pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "fatousamba/devops-todo-app" // modifie selon ton Docker ID
    }

    stages {
        stage('Cloner le projet') {
            steps {
                git 'https://github.com/abchate/devops-todo-app.git'
            }
        }

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
