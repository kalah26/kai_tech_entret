-- =================================================================
-- LIVRABLE FINAL - TÂCHE C : BASE DE DONNÉES SQL 
-- =================================================================

-- =================================================================
-- PARTIE 1 : CRÉATION DES TABLES 
-- =================================================================

-- Table des capteurs
CREATE TABLE IF NOT EXISTS sensors (
    sensor_id TEXT PRIMARY KEY,
    location_name TEXT NOT NULL,
    location_type TEXT NOT NULL,
    latitude REAL NOT NULL,
    longitude REAL NOT NULL,
    installation_date DATE NOT NULL
);

-- Table des mesures
CREATE TABLE IF NOT EXISTS measurements (
    measurement_id INTEGER PRIMARY KEY AUTOINCREMENT,
    sensor_id TEXT NOT NULL,
    timestamp DATETIME NOT NULL,
    pm25 REAL NOT NULL,
    temperature REAL NOT NULL,
    humidity REAL NOT NULL,
    co2 INTEGER NOT NULL,
    FOREIGN KEY (sensor_id) REFERENCES sensors(sensor_id)
);

-- Index pour optimiser les performances
CREATE INDEX IF NOT EXISTS idx_measurements_sensor_id ON measurements(sensor_id);
CREATE INDEX IF NOT EXISTS idx_measurements_timestamp ON measurements(timestamp);
CREATE INDEX IF NOT EXISTS idx_measurements_pm25 ON measurements(pm25);
CREATE INDEX IF NOT EXISTS idx_sensors_location ON sensors(location_name);

-- =================================================================
-- PARTIE 2 : INSERTION DES DONNÉES (C1 - 3 points)
-- =================================================================

-- Insérez au moins 5 capteurs
INSERT INTO sensors VALUES
('SENS001', 'Dakar - Plateau', 'Urban', 14.6937, -17.4441, '2024-01-15'),
('SENS002', 'Dakar - Almadies', 'Residential', 14.7481, -17.4738, '2024-02-01'),
('SENS003', 'Saint-Louis - Centre Ville', 'Urban', 16.0267, -16.4969, '2024-02-15'),
('SENS004', 'Dakar - Médina', 'Commercial', 14.6953, -17.4439, '2024-03-01'),
('SENS005', 'Dakar - HLM Grand Yoff', 'Residential', 14.7500, -17.4600, '2024-03-15');

-- Insérez au moins 20 mesures 
INSERT INTO measurements (sensor_id, timestamp, pm25, temperature, humidity, co2) VALUES
('SENS001', '2024-11-01 08:00:00', 42.5, 28.3, 65.2, 412),
('SENS001', '2024-11-01 09:00:00', 38.2, 29.1, 62.8, 408),
('SENS001', '2024-11-01 10:00:00', 35.7, 29.8, 60.4, 405),
('SENS001', '2024-11-01 11:00:00', 41.3, 30.5, 58.9, 410),
('SENS001', '2024-11-01 12:00:00', 45.8, 31.2, 57.3, 415),

('SENS002', '2024-11-01 08:00:00', 18.6, 26.2, 71.3, 385),
('SENS002', '2024-11-01 09:00:00', 22.1, 27.0, 69.7, 390),
('SENS002', '2024-11-01 10:00:00', 19.4, 27.8, 67.2, 388),
('SENS002', '2024-11-01 11:00:00', 24.8, 28.5, 65.8, 395),
('SENS002', '2024-11-01 12:00:00', 21.7, 29.2, 64.1, 392),

('SENS003', '2024-11-01 08:00:00', 12.3, 24.1, 73.6, 365),
('SENS003', '2024-11-01 09:00:00', 14.7, 25.2, 71.9, 370),
('SENS003', '2024-11-01 10:00:00', 11.8, 26.3, 69.4, 368),
('SENS003', '2024-11-01 11:00:00', 16.2, 27.1, 67.8, 375),
('SENS003', '2024-11-01 12:00:00', 13.5, 28.0, 66.2, 372),

('SENS004', '2024-11-01 08:00:00', 56.4, 29.7, 68.1, 445),
('SENS004', '2024-11-01 09:00:00', 62.8, 30.4, 66.3, 450),
('SENS004', '2024-11-01 10:00:00', 58.9, 31.2, 64.7, 448),
('SENS004', '2024-11-01 11:00:00', 67.3, 32.0, 62.5, 455),
('SENS004', '2024-11-01 12:00:00', 71.2, 32.8, 60.9, 460),

('SENS005', '2024-11-01 08:00:00', 31.5, 27.6, 70.2, 420),
('SENS005', '2024-11-01 09:00:00', 34.8, 28.3, 68.6, 425),
('SENS005', '2024-11-01 10:00:00', 29.7, 29.1, 66.9, 418),
('SENS005', '2024-11-01 11:00:00', 36.2, 29.8, 65.1, 430),
('SENS005', '2024-11-01 12:00:00', 33.9, 30.5, 63.4, 427);

-- =================================================================
-- PARTIE 3 : REQUÊTES SQL 
-- =================================================================

-- =================================================================
-- 1. REQUÊTE SIMPLE
-- =================================================================

-- Sélectionner tous les capteurs installés à Dakar avec leur date d'installation
-- Trier par date d'installation décroissante
SELECT 
    sensor_id as "ID Capteur",
    location_name as "Localisation",
    location_type as "Type de Zone",
    installation_date as "Date d'Installation"
FROM sensors 
WHERE location_name LIKE '%Dakar%'
ORDER BY installation_date DESC;

-- =================================================================
-- 2. JOINTURE AVEC AGRÉGATION
-- =================================================================

-- Pour chaque capteur, afficher le nombre total de mesures
-- et la dernière date de mesure
SELECT 
    s.sensor_id as "ID Capteur",
    s.location_name as "Localisation",
    COUNT(m.measurement_id) as "Nombre Total de Mesures",
    MAX(m.timestamp) as "Dernière Date de Mesure",
    ROUND(AVG(m.pm25), 2) as "PM2.5 Moyenne"
FROM sensors s
LEFT JOIN measurements m ON s.sensor_id = m.sensor_id
GROUP BY s.sensor_id, s.location_name
ORDER BY COUNT(m.measurement_id) DESC;

-- =================================================================
-- 3. ANALYSE TEMPORELLE (2 points)
-- =================================================================

-- Calculer la moyenne horaire de PM2.5 pour chaque capteur
-- sur les dernières 24 heures
SELECT 
    s.sensor_id as "ID Capteur",
    s.location_name as "Localisation",
    strftime('%H', m.timestamp) as "Heure",
    ROUND(AVG(m.pm25), 2) as "PM2.5 Moyenne",
    COUNT(m.measurement_id) as "Nb Mesures"
FROM sensors s
JOIN measurements m ON s.sensor_id = m.sensor_id
WHERE m.timestamp >= datetime('now', '-24 hours')
GROUP BY s.sensor_id, s.location_name, strftime('%H', m.timestamp)
ORDER BY s.sensor_id, strftime('%H', m.timestamp);

-- =================================================================
-- 4. REQUÊTE COMPLEXE AVEC CTE
-- =================================================================

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

