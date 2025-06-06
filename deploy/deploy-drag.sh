#!/bin/bash
# Script de déploiement simplifié via l'interface Netlify

# Variables de couleur pour les logs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}=== PRÉPARATION DU DÉPLOIEMENT NETLIFY ====${NC}\n"

# Construire le frontend
echo -e "${YELLOW}[ÉTAPE 1]${NC} Construction du frontend..."
(cd ../frontend && npm install && npm run build)
if [ $? -ne 0 ]; then
    echo -e "${RED}[ERREUR]${NC} Échec de la construction du frontend"
    exit 1
fi

echo -e "\n${GREEN}[SUCCÈS]${NC} Build frontend réussi!"
echo -e "${YELLOW}[INFO]${NC} Le dossier 'frontend/dist' est prêt à être déployé.\n"

# Instructions pour le déploiement manuel
echo -e "${BLUE}=== INSTRUCTIONS DE DÉPLOIEMENT MANUEL ===${NC}"
echo -e "${YELLOW}[ÉTAPE 2]${NC} Pour déployer votre application:\n"
echo -e "1. Ouvrir le site Netlify dans votre navigateur (il s'ouvrira automatiquement)"
echo -e "2. Connectez-vous à votre compte Netlify"
echo -e "3. Cliquez sur 'Add new site' > 'Deploy manually'"
echo -e "4. Glissez-déposez le dossier: ${GREEN}$(pwd)/../frontend/dist${NC}"
echo -e "\nLe lien de votre site sera affiché une fois le téléchargement terminé!"

# Ouvrir Netlify
echo -e "\n${YELLOW}[INFO]${NC} Ouverture de Netlify dans votre navigateur..."
open "https://app.netlify.com"

echo -e "${GREEN}[INFO]${NC} Une fois déployé, votre site sera accessible depuis l'URL fournie par Netlify.\n"
