# 🏎️ Projet Data Analyst : Évolution de la Formule 1 sur 5 Circuits Historiques (1997–2026)

**Équipe :** Fred • Xavier • Loris  
**Durée :** 10 jours (2 semaines)  
**Stack Technique :** Python (Pandas) • Snowflake • Streamlit

## 🎯 1. Problématique & Périmètre d'Analyse

### Problématique retenue

> **« Entre 1997 et 2026 sur 5 circuits historiques de Formule 1 (Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka), comment les grands virages réglementaires ont-ils fait évoluer la vitesse pure des monoplaces (chronos et vitesses en course) au regard de l’équilibre compétitif et de la fiabilité mécanique ? »**

### Pourquoi ce périmètre est optimal

* **Réponse directe aux questions de performance :** Permet de mesurer précisément quelles ères techniques ont bridé ou relancé les chronos.
* **5 tracés complémentaires et stables :** Monza (vitesse pure), Monaco (appui maximal urbain), Spa (puissance & dénivelé), Silverstone (aéro haute vitesse) et Suzuka (équilibre technique global).
* **Données homogènes dès 1997 :** S'appuie sur des variables disponibles sur toute la période (`results`, `lap_times`, `status`, `races`, `circuits`) sans dépendre des données récentes comme les arrêts au stand (`pit_stops`, disponibles uniquement à partir de 2011).

### Découpage des Ères Réglementaires (`reglementations`)

1. **1997–2005 :** Ère Moteurs V10 (puissance brute, ravitaillements en course).
2. **2006–2013 :** Ère Moteurs V8 atmosphériques (limitation des régimes, interdiction des ravitaillements en 2010).
3. **2014–2016 :** Ère Hybride V6 Turbo (première génération, monoplaces étroites).
4. **2017–2021 :** Ère Aéro Large & Hybride (monoplaces élargies, appui aérodynamique record).
5. **2022–2026 :** Ère Effet de Sol (nouvelle philosophie aérodynamique destinée à favoriser les dépassements).

---

## 📦 2. Sources de Datasets & Pipeline Médaillon (`scripts/clean_data.py`)

### Sources utilisées (format multi-tables CSV)

1. **TracingInsights RaceData (`TracingInsights/RaceData` — Licence CC0-1.0)**
   * *Archives :* `data/01_bronze/dataset_1.zip` à `dataset_5.zip` (référentiel principal sur `dataset_2.zip` pour les IDs numériques `lap_times.csv` et `status.csv`)
   * *Fichiers clés :* `circuits.csv`, `races.csv`, `results.csv`, `lap_times.csv`, `status.csv`, `drivers.csv`, `constructors.csv`.
2. **F1DB (`f1db/f1db` — Licence CC-BY-4.0)**
   * *Fichiers clés (`data/01_bronze/` et `data/02_silver/`) :* `f1db-races.csv` (longueurs de tracé `courseLength`, `laps`), `f1db-races-fastest-laps.csv`, `f1db-constructors-chronology.csv`.

### Architecture Médaillon & Nettoyage (`scripts/clean_data.py`)

* **`data/01_bronze/` (Brut) :** Stockage des archives `.zip` et des exports CSV bruts non modifiés.
* **`data/02_silver/` (Intermédiaire) :** Extraction, remplacement des valeurs nulles spécifiques (`\N` -> `NaN`), filtrage strict sur `1997–2026` et les 5 circuits (`Monza`, `Monaco`, `Spa-Francorchamps`, `Silverstone`, `Suzuka`), et harmonisation des clés.
* **`data/03_gold/` (Prêt pour Snowflake) :** Production des 10 tables normalisées du modèle **V3 (`F1_Data`)** (`pays`, `circuits`, `ecuries`, `pilotes`, `reglementations`, `saisons`, `grand_prix`, `statuts`, `resultats_laps`, `users`) avec formatage des chronos au tour (`lap_time` en `TIME`) et calcul des vitesses (`lap_top_speed`, `lap_avg_speed`).

---

## 👥 3. Répartition des 3 Axes Analytiques (Fred, Xavier, Loris)

Chacun pilote un axe métier complet (requête SQL Snowflake + onglet Streamlit) :

* **Axe 1 — Vitesse pure & Chronos (Focus prioritaire) :** Évolution des temps au tour et des vitesses (moyenne et de pointe) par circuit, saison et ère réglementaire.
* **Axe 2 — Serrage de la grille & Compétitivité *(extension)* :** Écarts de performance entre pilotes/écuries et diversité des résultats par ère sur ces 5 tracés.
* **Axe 3 — Fiabilité mécanique *(extension)* :** Évolution du taux d'abandons techniques (`statuts`) face à la complexification des moteurs et de l'aérodynamique.

---

## 🔄 4. Organisation du Projet avec la Méthode Agile (Approche Pragmatique)

L'équipe utilise les grands principes de la **méthode Agile** pour avancer par étapes courtes et livrer rapidement une première version fonctionnelle (MVP) :

* **Découpage en 2 Sprints de 5 jours :**
  * **Sprint 1 (Semaine 1 — Le MVP) :** Mettre en place le tuyau technique de bout en bout (`01_bronze -> 02_silver -> 03_gold -> Snowflake -> Streamlit`) sur l'Axe 1 pour valider l'architecture dès le Jour 5.
  * **Sprint 2 (Semaine 2 — Enrichissement & Finitions) :** Compléter les analyses, affiner les filtres Streamlit (`onglets/`), corriger les bugs et préparer la démonstration.
* **Suivi partagé (Google Sheets) & Workflow Git :**
  * Branches `main`, `dev`, et branches individuelles `dev-fred`, `dev-xavier`, `dev-loris`.
* **Rituels courts :**
  * **Daily Stand-up (10 min chaque matin) :** Tour de table rapide à trois (*Qu'ai-je fait hier ? Que fais-je aujourd'hui ? Ai-je un blocage ?*).
  * **Revue & Rétrospective (fin du Jour 5) :** Démonstration interne à mi-parcours et ajustement des priorités pour la deuxième semaine.