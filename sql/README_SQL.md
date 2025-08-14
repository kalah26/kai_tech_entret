# 📊 SQL & Base de données Kaikai IoT

## 🎯 Partie C : Création de la base de données SQLite

### 📁 Structure des fichiers SQL

```
sql/
├── script.sql          # Script complet tout-en-un
└── README_SQL.md       # Cette documentation
```

### 🚀 Utilisation avec SQLiteOnline

1. **Aller sur SQLiteOnline** : https://sqliteonline.com/
2. **Copier-coller** le contenu de `script.sql`
3. **Cliquer "Run"** pour créer la base complète
4. **Vérifier** que les tables et données sont créées


```

## 📋 Structure de la base de données

### 🏭 Table `sensors` (Capteurs)
```sql
sensor_id      VARCHAR(50) PRIMARY KEY  -- Identifiant unique
location_name  VARCHAR(100) NOT NULL    -- Nom de la localisation
location_type  VARCHAR(50)              -- Type (Educational, Commercial, etc.)
latitude       DECIMAL(10, 8)           -- Coordonnée GPS latitude
longitude      DECIMAL(11, 8)           -- Coordonnée GPS longitude
install_date   DATE                     -- Date d'installation
```

### 📊 Table `measurements` (Mesures)
```sql
measurement_id INTEGER PRIMARY KEY AUTOINCREMENT  -- ID auto-incrémenté
sensor_id      VARCHAR(50)                        -- Référence au capteur
timestamp      DATETIME NOT NULL                  -- Horodatage de la mesure
pm25          DECIMAL(6, 2)                      -- Particules fines (μg/m³)
temperature   DECIMAL(4, 2)                      -- Température (°C)
humidity      DECIMAL(5, 2)                      -- Humidité (%)
co2           INTEGER                            -- CO2 (ppm)
```

## 🔍 Index créés pour optimisation

### **Index Créés**

1. **`idx_measurements_sensor_id`** sur `measurements(sensor_id)`
   - **Justification :** Accélère les jointures entre `sensors` et `measurements`

2. **`idx_measurements_timestamp`** sur `measurements(timestamp)`
   - **Justification :** Optimise les filtres temporels et les tris chronologiques

3. **`idx_measurements_pm25`** sur `measurements(pm25)`
   - **Justification :** Accélère les filtres sur les seuils de pollution

4. **`idx_sensors_location`** sur `sensors(location_name)`
   - **Justification :** Optimise les recherches géographiques

## 📊 Données d'exemple incluses

- **5 capteurs** répartis à Dakar et Saint-Louis
- **Types variés** : Educational, Commercial, Health Center, Test Site
- **Mesures récentes** avec différents niveaux de pollution :
    - **SENS001** : Dakar - Plateau (Urban) - Zone urbaine dense
    - **SENS002** : Dakar - Almadies (Residential) - Zone résidentielle
    - **SENS003** : Saint-Louis - Centre Ville (Urban) - Ville historique
    - **SENS004** : Dakar - Médina (Commercial) - Zone commerciale intense
    - **SENS005** : Dakar - HLM Grand Yoff (Residential) - Quartier populaire

## ✅ Points de la consigne respectés

## 🔍 REQUÊTES SQL DÉVELOPPÉES

### 1. **Requête Simple**
```sql
-- Capteurs installés à Dakar triés par date d'installation
SELECT sensor_id, location_name, location_type, installation_date
FROM sensors 
WHERE location_name LIKE '%Dakar%'
ORDER BY installation_date DESC;
```
**Résultat attendu :** 4 capteurs de Dakar triés du plus récent au plus ancien.

### 2. **Jointure avec Agrégation**
```sql
-- Statistiques par capteur : nombre de mesures et dernière date
SELECT s.sensor_id, s.location_name, 
       COUNT(m.measurement_id) as total_mesures,
       MAX(m.timestamp) as derniere_mesure,
       ROUND(AVG(m.pm25), 2) as pm25_moyenne
FROM sensors s
LEFT JOIN measurements m ON s.sensor_id = m.sensor_id
GROUP BY s.sensor_id, s.location_name;
```

### 3. **Analyse Temporelle (2 points)**
```sql
-- Moyenne horaire PM2.5 sur les dernières 24 heures
SELECT s.sensor_id, s.location_name,
       strftime('%H', m.timestamp) as heure,
       ROUND(AVG(m.pm25), 2) as pm25_moyenne
FROM sensors s
JOIN measurements m ON s.sensor_id = m.sensor_id
WHERE m.timestamp >= datetime('now', '-24 hours')
GROUP BY s.sensor_id, strftime('%H', m.timestamp);
```

### 4. **Requête Complexe avec CTE (2 points)**
```sql
-- Analyser la qualité de l'air par type de zone avec sous-requêtes
-- et classement des performances
WITH zone_stats AS (
    SELECT 
        s.location_type,
        COUNT(DISTINCT s.sensor_id) as nb_capteurs,
        COUNT(m.measurement_id) as nb_mesures,
        AVG(m.pm25) as avg_pm25,
        AVG(m.temperature) as avg_temp,
        AVG(m.humidity) as avg_humidity,
        AVG(m.co2) as avg_co2
    FROM sensors s
    JOIN measurements m ON s.sensor_id = m.sensor_id
    GROUP BY s.location_type
),
zone_ranking AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY avg_pm25 ASC) as rang_qualite_air
    FROM zone_stats
)
SELECT 
    location_type as "Type de Zone",
    nb_capteurs as "Nombre de Capteurs",
    nb_mesures as "Total Mesures",
    ROUND(avg_pm25, 2) as "PM2.5 Moyenne",
    ROUND(avg_temp, 1) as "Température Moyenne",
    ROUND(avg_humidity, 1) as "Humidité Moyenne",
    ROUND(avg_co2, 0) as "CO2 Moyen",
    rang_qualite_air as "Rang Qualité Air",
    CASE 
        WHEN avg_pm25 <= 12 THEN '🟢 EXCELLENT'
        WHEN avg_pm25 <= 35 THEN '🟡 MODÉRÉ'
        WHEN avg_pm25 <= 55 THEN '🟠 MAUVAIS'
        ELSE '🔴 CRITIQUE'
    END as "Évaluation"
FROM zone_ranking
ORDER BY rang_qualite_air;
```
