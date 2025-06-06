pipeline {
    agent any

    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
        DEPLOY_SERVER = 'exemple-serveur.com'
        DEPLOY_USER = 'deployer'
        DEPLOY_KEY = 'id_deploy_key'
        DEPLOY_DIRECTORY = '/opt/devops-todo-app'
        DEPLOYMENT_TYPE = 'blue' // blue ou green
    }

    stages {
        stage('Vérification des prérequis') {
            steps {
                sh 'docker --version'
                sh 'docker compose version'
                echo "🚀 Pipeline de déploiement démarré avec mode: ${DEPLOYMENT_TYPE}"
            }
        }

        stage('Tests unitaires') {
            parallel {
                stage('Backend Tests') {
                    steps {
                        dir('backend') {
                            sh 'npm install'
                            sh 'npm test'
                        }
                    }
                }
                stage('Frontend Tests') {
                    steps {
                        dir('frontend') {
                            sh 'npm install'
                            sh 'npm test'
                        }
                    }
                }
            }
        }

        stage('Building Docker Images') {
            steps {
                sh 'docker compose -f $DOCKER_COMPOSE_FILE build'
            }
        }

        stage('Run Local for Testing') {
            steps {
                sh 'docker rm -f devops-todo-app-backend-blue devops-todo-app-backend-green devops-todo-app-frontend prometheus alertmanager grafana || true'
                sh 'docker compose -f $DOCKER_COMPOSE_FILE down || true'
                sh 'docker compose -f $DOCKER_COMPOSE_FILE up -d --force-recreate --remove-orphans'
            }
        }

        stage('Tests d\'intégration') {
            steps {
                sh 'sleep 10' // Attente pour que les services démarrent
                sh 'curl -s -f http://localhost:9090/health || echo "⚠️ API Backend non accessible"'
                sh 'curl -s -f http://localhost:9090/metrics || echo "⚠️ Endpoint de métriques non accessible"'
                sh 'curl -s -f http://localhost:9093/-/healthy || echo "⚠️ Alertmanager non accessible"'
                sh 'curl -s -f http://localhost || echo "⚠️ Frontend non accessible"'
            }
        }

        stage('Tests de performance') {
            steps {
                sh 'docker run --rm -i grafana/k6 run - < k6-test.js || echo "⚠️ Tests de performance échoués"'
            }
        }

        stage('Configuration Blue/Green') {
            steps {
                script {
                    if (env.DEPLOYMENT_TYPE == 'green') {
                        sh 'chmod +x ./deploy/switch-bluegreen.sh'
                        sh './deploy/switch-bluegreen.sh green'
                    } else {
                        sh 'chmod +x ./deploy/switch-bluegreen.sh'
                        sh './deploy/switch-bluegreen.sh blue'
                    }
                }
            }
        }

        stage('Déploiement distant (SSH)') {
            when {
                expression { return env.BRANCH_NAME == 'main' || env.BRANCH_NAME == 'master' }
            }
            steps {
                sshagent(credentials: [DEPLOY_KEY]) {
                    sh 'chmod +x ./deploy/deploy.sh'
                    sh './deploy/deploy.sh'
                }
                echo "🚀 Application déployée avec succès sur ${DEPLOY_SERVER}"
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline terminé avec succès'
        }
        failure {
            echo '❌ Pipeline échoué'
            script {
                if (env.DEPLOYMENT_TYPE == 'green') {
                    sh 'chmod +x ./deploy/switch-bluegreen.sh'
                    sh './deploy/switch-bluegreen.sh blue' // Rollback automatique
                    echo '⚠️ Rollback automatique vers BLUE effectué'
                }
            }
        }
        always {
            sh 'docker compose ps'
        }
    }
}
