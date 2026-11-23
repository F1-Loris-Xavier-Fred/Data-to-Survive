# 🏎️ Projet Data Analyst : Évolution de la Formule 1 sur 5 Circuits Historiques (1997–2026)

**Équipe :** Fred • Xavier • Loris  
**Durée :** 10 jours (2 semaines)  
**Stack Technique :** Python (Pandas) • PostgreSQL • FastAPI • Streamlit

## 🎯 1. Problématique & Périmètre d'Analyse

### Problématique retenue

> **« Entre 1997 et 2026 sur 5 circuits historiques de Formule 1 (Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka), comment les grands virages réglementaires ont-ils fait évoluer la vitesse pure des monoplaces (qualifications et meilleurs tours) au regard de l’équilibre compétitif et de la fiabilité mécanique ? »**

### Pourquoi ce périmètre est optimal

* **Réponse directe aux questions de performance :** Permet de mesurer précisément quelles ères techniques ont bridé ou relancé les chronos.
* **5 tracés complémentaires et stables :** Monza (vitesse pure), Monaco (appui maximal urbain), Spa (puissance & dénivelé), Silverstone (aéro haute vitesse) et Suzuka (équilibre technique global).
* **Données homogènes dès 1997 :** S'appuie sur des variables disponibles sur toute la période (`qualifying`, `results`, `status`, `races`, `circuits`) sans dépendre des données récentes comme les arrêts au stand (`pit_stops`, disponibles uniquement à partir de 2011).

### Découpage des Ères Réglementaires (Variable analytique à créer en ETL)

1. **1997–2005 :** Ère Moteurs V10 (puissance brute, ravitaillements en course).
2. **2006–2013 :** Ère Moteurs V8 atmosphériques (limitation des régimes, interdiction des ravitaillements en 2010).
3. **2014–2016 :** Ère Hybride V6 Turbo (première génération, monoplaces étroites).
4. **2017–2021 :** Ère Aéro Large & Hybride (monoplaces élargies, appui aérodynamique record).
5. **2022–2026 :** Ère Effet de Sol (nouvelle philosophie aérodynamique destinée à favoriser les dépassements).

---

## 📦 2. Sources de Datasets & Nettoyage Prévu (`etl.py`)

### Sources recommandées (format multi-tables CSV)

1. **Formula 1 World Championship Dataset (1950–2026) — Kaggle**
   * *Recherche Kaggle :* `formula-1-world-championship-dataset` (ex. `fleongg/formula-1-results-and-standings-1950-present` ou `mkaur1141/formula-1-world-championship-dataset-2000-2026`).
   * *Fichiers clés à utiliser :* `circuits.csv`, `races.csv`, `results.csv`, `qualifying.csv`, `status.csv`, `drivers.csv`, `constructors.csv`.
2. **Dépôts GitHub F1 (Ergast / Jolpica Mirror)**
   * *Recherche GitHub :* `muharsyad/formula-one-datasets` ou `TracingInsights/RaceData`.
   * *Intérêt :* Permet de récupérer les mises à jour récentes des saisons 2024–2026 au même format relationnel.


### Opérations de nettoyage à implémenter dans Pandas (`etl.py`)

Les exports historiques F1 contiennent des anomalies classiques idéales pour démontrer vos compétences de Data Analyst :

1. **Gestion des valeurs nulles spécifiques (`\N`) :** Remplacement de la chaîne littérale `"\N"` (héritée d'Ergast/MySQL) par de vrais `NaN` / `NULL` SQL.
2. **Conversion des chronos textuels en millisecondes :** Parsing des colonnes `q1`, `q2`, `q3` et `fastestLapTime` (format `"1:21.456"`) en valeurs numériques (`float` ou `int` en millisecondes) pour permettre les calculs de moyennes et d'écarts.
3. **Filtrage périmètre & gestion des valeurs aberrantes :**
   * Filtrage strict sur `year >= 1997` et sur les 5 `circuitId` ciblés.
   * Exclusion des temps de qualification anormaux dus à la pluie extrême ou aux drapeaux rouges (ou marquage via un indicateur booléen).
4. **Catégorisation des statuts (`status.csv`) :** Regroupement des dizaines de statuts bruts (`Engine`, `Gearbox`, `Hydraulics`, `Collision`, `Spun off`, `Finished`, `+1 Lap`) en 3 catégories propres : `Classé`, `Abandon Mécanique`, `Incident / Accident`.
5. **Enrichissement (Feature Engineering) :** Création automatique de la colonne `regulatory_era` à partir de l'année de la course pour faciliter les regroupements SQL et API.

---

## 👥 3. Répartition des 3 Axes Analytiques (Fred, Xavier, Loris)

Chacun pilote un axe métier complet (requête SQL + endpoint FastAPI + visualisation Streamlit) :

* **Axe 1 — Vitesse pure & Chronos :** Évolution des temps de pole position et des meilleurs tours en course par circuit et par ère réglementaire.
* **Axe 2 — Serrage de la grille & Compétitivité :** Écart moyen entre le 1ᵉʳ et le 10ᵉ en qualification et diversité des vainqueurs par ère sur ces 5 tracés.
* **Axe 3 — Fiabilité mécanique :** Évolution du taux d'abandons techniques (`Abandon Mécanique`) face à la complexification des moteurs et de l'aérodynamique.

---

## 🔄 4. Organisation du Projet avec la Méthode Agile (Approche Pragmatique)

Sans chercher à appliquer tout le formalisme théorique de Scrum à la lettre, l'équipe utilise les grands principes de la **méthode Agile** comme fil conducteur pour avancer par étapes courtes, livrer rapidement une première version fonctionnelle (MVP) et s'adapter en continu :

* **Découpage en 2 Sprints de 5 jours :**
  * **Sprint 1 (Semaine 1 — Le MVP) :** Mettre en place le tuyau technique de bout en bout (`CSV -> Pandas -> PostgreSQL -> 1 route FastAPI -> 1 graphique Streamlit`) sur un premier circuit/axe pour valider l'architecture dès le Jour 5.
  * **Sprint 2 (Semaine 2 — Enrichissement & Finitions) :** Ajouter les 3 axes analytiques complets, affiner les filtres Streamlit, corriger les bugs et préparer la démonstration.
* **Un tableau Kanban partagé (Trello, Notion ou GitHub Projects) :**
  * Structuré en 4 colonnes simples : `À faire (Backlog)`, `En cours`, `En relecture / Test`, `Terminé`. Chacun déplace ses tickets au fur et à mesure pour garder une visibilité claire sur l'avancement collectif.
* **Rituels courts et efficaces :**
  * **Daily Stand-up (10 min chaque matin) :** Tour de table rapide à trois (*Qu'ai-je fait hier ? Que fais-je aujourd'hui ? Ai-je un blocage sur la BDD ou l'API ?*).
  * **Revue & Rétrospective (fin du Jour 5) :** Démonstration interne de ce qui fonctionne à mi-parcours et ajustement des priorités pour la deuxième semaine si une tâche prend plus de temps que prévu.