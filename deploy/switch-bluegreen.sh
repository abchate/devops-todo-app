#!/bin/bash
# Script pour basculer entre les déploiements blue et green

# Variables de couleur pour les logs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Vérifier l'environnement actif
check_active() {
    if grep -q "server backend-blue:5000;" ./nginx/backend-proxy.conf && ! grep -q "server backend-green:5000;" ./nginx/backend-proxy.conf; then
        echo "blue"
    elif grep -q "server backend-green:5000;" ./nginx/backend-proxy.conf && ! grep -q "server backend-blue:5000;" ./nginx/backend-proxy.conf; then
        echo "green"
    else
        echo "unknown"
    fi
}

# Afficher le statut actuel
current=$(check_active)
echo -e "${YELLOW}[INFO]${NC} Configuration actuelle: ${current}"

# Fonction pour basculer vers blue
switch_to_blue() {
    echo -e "${BLUE}[INFO]${NC} Bascule vers le déploiement BLUE..."
    sed -i 's/server backend-green:5000;/# server backend-green:5000;/g' ./nginx/backend-proxy.conf
    sed -i 's/# server backend-blue:5000;/server backend-blue:5000;/g' ./nginx/backend-proxy.conf
    docker compose restart backend-proxy
    echo -e "${GREEN}[SUCCÈS]${NC} Bascule vers BLUE terminée!"
}

# Fonction pour basculer vers green
switch_to_green() {
    echo -e "${GREEN}[INFO]${NC} Bascule vers le déploiement GREEN..."
    
    # Vérifier que le green est lancé
    if ! docker compose ps | grep -q "devops-todo-app-backend-green"; then
        echo -e "${YELLOW}[INFO]${NC} Démarrage du déploiement GREEN..."
        docker compose --profile green-deployment up -d backend-green
        sleep 5 # Attendre que le conteneur démarre
    fi
    
    # Mettre à jour la configuration nginx
    sed -i 's/server backend-blue:5000;/# server backend-blue:5000;/g' ./nginx/backend-proxy.conf
    sed -i 's/# server backend-green:5000;/server backend-green:5000;/g' ./nginx/backend-proxy.conf
    
    # Redémarrer le proxy
    docker compose restart backend-proxy
    echo -e "${GREEN}[SUCCÈS]${NC} Bascule vers GREEN terminée!"
}

# Fonction pour valider le nouveau déploiement
validate_deployment() {
    echo -e "${YELLOW}[INFO]${NC} Validation du déploiement..."
    
    # Simple check de santé avec curl
    sleep 2 # Attendre que le proxy soit réinitialisé
    response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9090/health)
    
    if [ "$response" == "200" ]; then
        echo -e "${GREEN}[SUCCÈS]${NC} Déploiement validé (status: $response)"
        return 0
    else
        echo -e "${RED}[ERREUR]${NC} Le déploiement ne répond pas correctement (status: $response)"
        return 1
    fi
}

# Fonction pour rollback en cas de problème
rollback() {
    echo -e "${RED}[ALERT]${NC} Problème détecté! Retour à l'ancienne version..."
    if [ "$1" == "blue" ]; then
        switch_to_blue
    else
        switch_to_green
    fi
    echo -e "${YELLOW}[INFO]${NC} Rollback terminé."
}

# Gérer les arguments
case "$1" in
    blue)
        if [ "$current" == "blue" ]; then
            echo -e "${YELLOW}[INFO]${NC} Déjà sur le déploiement BLUE, rien à faire."
            exit 0
        fi
        switch_to_blue
        validate_deployment || rollback "green"
        ;;
    green)
        if [ "$current" == "green" ]; then
            echo -e "${YELLOW}[INFO]${NC} Déjà sur le déploiement GREEN, rien à faire."
            exit 0
        fi
        switch_to_green
        validate_deployment || rollback "blue"
        ;;
    status)
        echo -e "${YELLOW}[INFO]${NC} Environnement actif: ${current}"
        ;;
    *)
        echo -e "Usage: $0 {blue|green|status}"
        echo -e "  blue   - Basculer vers le déploiement BLUE"
        echo -e "  green  - Basculer vers le déploiement GREEN"
        echo -e "  status - Afficher l'environnement actuel"
        exit 1
        ;;
esac

exit 0
