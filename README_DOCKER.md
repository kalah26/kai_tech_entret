# 🐳 Kaikai IoT Analysis - Docker

Containerisation simple de l'analyse des données de capteurs IoT Kaikai.

## 🚀 Utilisation

### Avec Docker
```bash
# Construire l'image
docker build -t kaikai-analysis .

# Exécuter le container
docker run --rm -v $(pwd)/output:/app/output kaikai-analysis
```

### Avec Docker Compose
```bash
# Lancer l'analyse
docker-compose up

# Avec rebuild
docker-compose up --build
```

## 📁 Structure

- `Dockerfile` - Configuration simple du container
- `docker-compose.yml` - Orchestration avec volumes et variables
- `kaikai_sensor_analysis.py` - Script d'analyse Python
- `requirements.txt` - Dépendances Python
- `output/` - Résultats de l'analyse (JSON)

## 📊 Fonctionnalités

✅ **Image de base Python 3.11**  
✅ **Installation des dépendances** (pandas, matplotlib, numpy, seaborn)  
✅ **Copie du script** d'analyse  
✅ **Commande d'exécution** automatique  
✅ **Montage de volume** pour données CSV  
✅ **Variables d'environnement** configurées  
✅ **Génération de résultats** JSON  

## 📈 Résultats

L'analyse génère un fichier `kaikai_analysis_results.json` contenant :
- Métriques PM2.5 (moyenne, médiane, max)
- Pourcentage de dépassements des seuils OMS
- Localisation la plus polluée
- Timestamp de l'analyse
