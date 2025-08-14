# 🚀 README - KAIKAI IoT ANALYSIS PLATFORM
## Test Technique - Data Engineer & DevOps Junior

**Candidat :** [Votre Nom]  
**Date :** 14 août 2025  
**Dépôt Github :** Solution complète pour l'analyse des données de capteurs IoT Kaikai  

---

## 📋 APERÇU DE LA SOLUTION

Cette solution complète comprend :
- **Analyse Python** des données de qualité de l'air (Notebook Colab)
- **Infrastructure DevOps** avec conteneurisation et CI/CD

---

## 🏗️ ARCHITECTURE DE LA SOLUTION

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Data Sources  │───▶│  Kaikai Analysis │───▶│   Monitoring    │
│   (IoT Sensors) │    │     Pipeline     │    │   & Alertes     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---

## 📁 STRUCTURE DU PROJET

```
kai_tech_entret/
├── 📊 capteur.ipynb                    # Notebook analyse Python (Google Colab)
├── 🐳 Dockerfile                       # Conteneurisation de l'application
├── 🐳 docker-compose.yml               # Orchestration des services
├── 🔧 requirements.txt                 # Dépendances Python
├── 🤖 .gitlab-ci.yml                   # Pipeline CI/CD
├── 📋 LIVRABLE_DEVOPS_SQL.md           # Document technique complet
├── 📖 README.md                        # Ce fichier
├── 
├── 🗂️ ansible/                         # Infrastructure as Code
│   ├── deploy-kaikai.yml               # Playbook de déploiement
│   ├── inventory.yml                   # Inventaire des serveurs
│   └── templates/                      # Templates de configuration
│
├── 🗄️ sql/                             # Scripts de base de données
│   ├── kaikai_livrable_final.sql       # Script SQL complet
│   ├── 01_create_tables.sql            # Création des tables
│   ├── 02_insert_sample_data.sql       # Données d'exemple
│   ├── 03_queries.sql                  # Requêtes d'analyse
│   └── README_Livrable_SQL.md          # Documentation SQL
└──  
```

---

## 🚀 GUIDE D'EXÉCUTION

### **Option 1 : Exécution Rapide avec Docker** ⚡

#### Prérequis
- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM disponible

#### Lancement
```bash
# 1. Cloner le projet
git clone <repository-url>
cd kai_tech_entret

# 2. Préparer les données (optionnel pour test)
mkdir -p data output logs
# Placer le fichier capteur_temp.csv dans ./data/

# 3. Lancer l'infrastructure complète
docker-compose up -d

# 4. Vérifier le statut des services
docker-compose ps
docker-compose logs kaikai-analysis
```


### **Option 2 : Exécution Locale** 🖥️

#### Prérequis
- Python 3.11+
- SQLite3
- 2GB RAM

#### Installation
```bash
# 1. Environnement virtuel
python -m venv kaikai_env
source kaikai_env/bin/activate  # Linux/Mac
# ou : kaikai_env\Scripts\activate  # Windows

# 2. Installation des dépendances
pip install -r requirements.txt

# 3. Lancement de l'analyse
python kaikai_sensor_analysis.py
```

### **Option 3 : Déploiement Production avec Ansible** 🏭

#### Prérequis
- Ansible 2.9+
- Serveur Ubuntu 20.04+
- Accès SSH configuré

#### Déploiement
```bash
# 1. Configuration de l'inventaire
cd ansible
cp inventory.yml.example inventory.yml
# Éditer inventory.yml avec vos serveurs

# 2. Déploiement automatisé
ansible-playbook -i inventory.yml deploy-kaikai.yml

# 3. Vérification du déploiement
ansible kaikai_servers -i inventory.yml -m shell -a "docker ps"
```

---

## 🧪 TESTS ET VALIDATION

### **Tests Automatisés**
```bash
# Tests unitaires
pytest tests/ -v

# Tests d'intégration Docker
docker-compose -f docker-compose.test.yml up --abort-on-container-exit

# Validation des requêtes SQL
cd sql && sqlite3 test.db < kaikai_livrable_final.sql
```

---

## 📊 UTILISATION DES LIVRABLES

### **1. Notebook Python (Google Colab)**
- **Fichier** : `capteur.ipynb`
- **Accès** : [Lien Google Colab]
- **Contenu** : Analyse complète A1.1 à A3 

### **2. Document Technique DevOps**
- **Fichier** : `LIVRABLE_DEVOPS_SQL.md`
- **Contenu** : Réponses DevOps B1-B3 + SQL C1-C2 

### **3. Scripts SQL**
- **Fichier principal** : `sql/script.sql`

---

## 🎯 RÉSUMÉ TECHNIQUE

| Component | Technology | Status | Points |
|-----------|------------|--------|--------|
| **Analyse Python** | Pandas, NumPy, Matplotlib | ✅ Complet |
| **Conteneurisation** | Docker, Docker Compose | ✅ Complet |
| **CI/CD** | GitLab CI, Ansible | ✅ Complet |
| **Monitoring** | Prometheus, Grafana | ✅ Complet |
| **Documentation** | Markdown, README | ✅ Complet | ✓ |


---

**Contact :** [moussaaminata.gueye@gmail.com] | **Linkedin :** [Linkedin](https://www.linkedin.com/in/moussa-aminata-gueye/)
