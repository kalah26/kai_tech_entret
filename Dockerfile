# Dockerfile simple pour l'analyse des données de capteurs IoT Kaikai
# Image de base Python
FROM python:3.11-slim

# Répertoire de travail
WORKDIR /app

# Copier et installer les dépendances (pandas, matplotlib, etc.)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du script
COPY kaikai_sensor_analysis.py .
COPY capteur_temp.csv .

# Créer les dossiers de sortie
RUN mkdir -p /app/output /app/data

# Commande d'exécution
CMD ["python", "kaikai_sensor_analysis.py"]
