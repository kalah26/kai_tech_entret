#!/usr/bin/env python3
"""
🌍 Kaikai IoT Air Quality Analysis Script
Script simple pour l'analyse des données de capteurs IoT
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import json
from datetime import datetime
import sys
import os

def load_csv_robust(file_path):
    """Charge un fichier CSV avec gestion d'erreurs d'encodage"""
    encodings = ['utf-8', 'latin-1', 'cp1252', 'iso-8859-1']
    
    for encoding in encodings:
        try:
            df = pd.read_csv(file_path, encoding=encoding, low_memory=False)
            print(f"✅ Chargement réussi avec encodage: {encoding}")
            return df
        except UnicodeDecodeError:
            continue
        except Exception as e:
            print(f"❌ Erreur: {e}")
            return None
    
    print("❌ Impossible de charger le fichier")
    return None

def analyze_sensor_data(filepath):
    """Analyse simple des données de capteurs"""
    print("🚀 Analyse des données de capteurs Kaikai")
    print("=" * 40)
    
    # Chargement
    df = load_csv_robust(filepath)
    if df is None:
        return None
    
    print(f"📊 Dataset: {df.shape[0]:,} lignes × {df.shape[1]} colonnes")
    
    # Identifier les colonnes PM2.5
    pm25_cols = [col for col in df.columns if 'pm2.5' in col.lower()]
    location_cols = [col for col in df.columns if 'location' in col.lower()]
    
    if not pm25_cols:
        print("❌ Aucune colonne PM2.5 trouvée")
        return None
    
    pm25_col = pm25_cols[0]
    location_col = 'Location Name' if 'Location Name' in df.columns else (location_cols[0] if location_cols else None)
    
    # Métriques de base
    pm25_data = df[pm25_col].dropna()
    
    results = {
        'timestamp': datetime.now().isoformat(),
        'filepath': filepath,
        'total_measurements': len(df),
        'pm25_stats': {
            'mean': float(pm25_data.mean()),
            'median': float(pm25_data.median()),
            'max': float(pm25_data.max()),
            'min': float(pm25_data.min()),
            'who_exceedances': int((pm25_data > 15).sum()),
            'who_exceedances_percent': float((pm25_data > 15).sum() / len(pm25_data) * 100)
        }
    }
    
    # Analyse par localisation si disponible
    if location_col:
        location_stats = df.groupby(location_col)[pm25_col].agg(['mean', 'count']).round(2)
        most_polluted = location_stats['mean'].idxmax()
        results['most_polluted_location'] = {
            'name': str(most_polluted),
            'mean_pm25': float(location_stats.loc[most_polluted, 'mean'])
        }
    
    # Affichage des résultats
    print(f"\n📈 RÉSULTATS D'ANALYSE:")
    print(f"  • PM2.5 moyenne: {results['pm25_stats']['mean']:.1f} μg/m³")
    print(f"  • PM2.5 maximum: {results['pm25_stats']['max']:.1f} μg/m³")
    print(f"  • Dépassements OMS: {results['pm25_stats']['who_exceedances_percent']:.1f}%")
    
    if 'most_polluted_location' in results:
        loc = results['most_polluted_location']
        print(f"  • Localisation la plus polluée: {loc['name']} ({loc['mean_pm25']:.1f} μg/m³)")
    
    return results

def main():
    """Fonction principale"""
    # Fichier d'entrée par défaut
    input_file = "/app/data/capteur_temp.csv"
    output_dir = "/app/output"
    
    # Arguments en ligne de commande simples
    if len(sys.argv) > 1:
        input_file = sys.argv[1]
    if len(sys.argv) > 2:
        output_dir = sys.argv[2]
    
    # Vérifier que le fichier existe
    if not os.path.exists(input_file):
        print(f"❌ Fichier non trouvé: {input_file}")
        # Essayer le fichier local
        if os.path.exists("capteur_temp.csv"):
            input_file = "capteur_temp.csv"
            print(f"✅ Utilisation du fichier local: {input_file}")
        else:
            sys.exit(1)
    
    # Analyse
    results = analyze_sensor_data(input_file)
    
    if results:
        # Créer le dossier de sortie
        os.makedirs(output_dir, exist_ok=True)
        
        # Sauvegarder les résultats
        output_file = os.path.join(output_dir, "kaikai_analysis_results.json")
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        
        print(f"\n💾 Résultats sauvegardés: {output_file}")
        print("🎉 Analyse terminée avec succès!")
    else:
        print("❌ Analyse échouée")
        sys.exit(1)

if __name__ == "__main__":
    main()
