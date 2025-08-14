#!/bin/bash
# Script de déploiement simple pour Kaikai IoT Analysis

echo "🚀 Déploiement Kaikai IoT Analysis avec Ansible"
echo "=============================================="

# Vérifier qu'Ansible est installé
if ! command -v ansible-playbook &> /dev/null; then
    echo "❌ Ansible n'est pas installé. Installation..."
    sudo apt update
    sudo apt install -y ansible
fi

# Vérifier la connexion aux serveurs
echo "🔍 Test de connexion aux serveurs..."
ansible all -m ping

if [ $? -eq 0 ]; then
    echo "✅ Connexion réussie aux serveurs"
    
    # Exécuter le playbook
    echo "📦 Déploiement en cours..."
    ansible-playbook deploy-kaikai.yml -v
    
    if [ $? -eq 0 ]; then
        echo "🎉 Déploiement réussi!"
        echo "📋 Vérification du statut..."
        ansible all -m shell -a "docker ps | grep kaikai"
        ansible all -m shell -a "crontab -l | grep kaikai"
    else
        echo "❌ Échec du déploiement"
        exit 1
    fi
else
    echo "❌ Impossible de se connecter aux serveurs"
    echo "Vérifiez votre fichier inventory.ini et vos clés SSH"
    exit 1
fi
