#!/bin/bash
# Script de déploiement automatique pour Netlify

# Variables de couleur pour les logs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}=== DÉPLOIEMENT AUTOMATIQUE NETLIFY ====${NC}\n"

# 1. Construction du frontend
echo -e "${YELLOW}[ÉTAPE 1]${NC} Construction du frontend..."
(cd ./frontend && npm install && npm run build)
if [ $? -ne 0 ]; then
    echo -e "${RED}[ERREUR]${NC} Échec de la construction du frontend"
    exit 1
fi
echo -e "${GREEN}[SUCCÈS]${NC} Build frontend réussi!\n"

# 2. Installer Netlify CLI si nécessaire
if ! command -v netlify &> /dev/null; then
    echo -e "${YELLOW}[INFO]${NC} Installation de Netlify CLI..."
    npm install -g netlify-cli
    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERREUR]${NC} Impossible d'installer Netlify CLI"
        exit 1
    fi
fi

# 3. Déployer sur Netlify
echo -e "${YELLOW}[ÉTAPE 2]${NC} Déploiement sur Netlify..."

# Nom de site unique pour éviter les conflits
SITE_NAME="devops-todo-app-$(date +%s | tail -c 8)"
echo -e "${BLUE}[INFO]${NC} Nom du site: ${GREEN}$SITE_NAME${NC}"

cd ./frontend

# Vérifier si l'utilisateur est déjà connecté à Netlify
netlify status &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}[INFO]${NC} Connexion à Netlify requise..."
    echo -e "${BLUE}[ACTION]${NC} Veuillez vous connecter à Netlify dans la fenêtre qui s'ouvre"
    netlify login
fi

# Déploiement direct et interactif
echo -e "${YELLOW}[INFO]${NC} Démarrage du déploiement interactif avec Netlify..."
echo -e "${BLUE}[INSTRUCTIONS]${NC} Veuillez suivre les étapes suivantes dans le terminal:"
echo -e "  1. Sélectionnez ${GREEN}+ Create & configure a new site${NC}"
echo -e "  2. Choisissez votre équipe"
echo -e "  3. Donnez un nom à votre site (ou acceptez celui généré)"
echo -e "  4. Le chemin est déjà correct (${GREEN}dist${NC})"
echo -e "  5. L'URL du site déployé s'affichera à la fin"
echo

# On lance juste la commande interactive et on laisse l'utilisateur interagir
netlify deploy --prod --dir=dist
DEPLOY_STATUS=$?

cd ..

if [ $DEPLOY_STATUS -eq 0 ]; then
    echo -e "\n${GREEN}[SUCCÈS]${NC} Déploiement terminé!"
    echo -e "${YELLOW}[NOTE]${NC} L'URL de votre application est indiquée ci-dessus dans 'Website URL'"
    echo -e "\n${BLUE}=======================================${NC}"
    echo -e "${BLUE}       DÉPLOIEMENT TERMINÉ       ${NC}"
    echo -e "${BLUE}=======================================${NC}"
    
    echo -e "${YELLOW}[NOTE]${NC} Pour un déploiement complet, n'oubliez pas que:"
    echo -e "  - Le backend devra être déployé sur un service comme Heroku ou Railway"
    echo -e "  - Vous devrez mettre à jour l'URL du backend dans votre frontend\n"
else
    echo -e "\n${RED}[ERREUR]${NC} Le déploiement a échoué."
    
    # Solution alternative
    echo -e "\n${YELLOW}[SOLUTION ALTERNATIVE]${NC} Pour déployer manuellement:"
    echo -e "1. Visitez ${GREEN}https://app.netlify.com${NC}"
    echo -e "2. Cliquez sur 'Add new site' > 'Deploy manually'"
    echo -e "3. Glissez-déposez le dossier ${GREEN}frontend/dist${NC}"
    
    # Ouvrir automatiquement Netlify
    echo -e "${YELLOW}[INFO]${NC} Ouverture de Netlify dans votre navigateur..."
    open https://app.netlify.com
    
    exit 1
fi

exit 0
