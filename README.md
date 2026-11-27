# 🏎️ Data to Survive

Analyse historique des performances en Formule 1 (**1997–2026**) sur cinq circuits emblématiques (**Monza, Monaco, Spa-Francorchamps, Silverstone et Suzuka**), centrée sur l'**Axe 1 : Vitesse pure & Chronos en course**.

**Équipe :** Loris, Xavier et Fred

---

## 🎯 Objectifs du projet (Focus Courses — Axe 1)

* Mesurer l'évolution des temps au tour et des vitesses par circuit, saison et ère réglementaire.
* Isoler les courses validées via la gestion des status d'arrivée afin d'éviter les biais liés aux abandons précoces.
* Restituer les analyses via une base relationnelle **Snowflake** et une application interactive **Streamlit**.

---

## 📋 Suivi du projet & Organisation

* **Suivi quotidien des tâches (Google Sheets) :** [Tableau de suivi — Data to Survive](https://docs.google.com/spreadsheets/d/1i7hicBHCIE0ChhZ_ZcqStX2iAYfbgVwJfkxkMjlQ4_U/edit?gid=0#gid=0)
* **Workflow Git :**
  * `main` : version stable du projet.
  * `dev` : branche d'intégration commune de l'équipe.
  * `dev-fred`, `dev-xavier`, `dev-loris` : branches de développement individuelles.

---

## 📦 Source des données

### Datasets utilisés

* **TracingInsights RaceData (`TracingInsights/RaceData`) :** <https://github.com/TracingInsights/RaceData> (Licence CC0-1.0)
* **F1DB :** <https://github.com/f1db/f1db> (Licence CC-BY-4.0)

### Fichiers CSV utilisés par source

#### 1. `TracingInsights/RaceData` (`data/01_bronze/dataset_2.zip` principalement)
* **`circuits.csv`** : référentiel des circuits (`circuitId`, `circuitRef`, `name`, `country`).
* **`races.csv`** : calendrier des Grands Prix (`raceId`, `year`, `round`, `circuitId`, `name`, `date`).
* **`drivers.csv`** : informations pilotes (`driverId`, `driverRef`, `forename`, `surname`, `nationality`).
* **`constructors.csv`** : informations écuries (`constructorId`, `constructorRef`, `name`, `nationality`).
* **`status.csv`** : libellés des status de fin de course (`statusId`, `status`).
* **`results.csv`** : résultats par pilote et par course (`raceId`, `driverId`, `constructorId`, `statusId`, `fastestLapTime`, `fastestLapSpeed`).
* **`lap_times.csv`** : temps tour par tour (`raceId`, `driverId`, `lap`, `milliseconds`).

#### 2. `F1DB` (`data/01_bronze/` et `data/02_silver/`)
* **`f1db-races.csv`** : calendrier des Grands Prix et longueurs de tracé (`courseLength`, `laps`, `year`, `date`).
* **`f1db-races-fastest-laps.csv`** : meilleurs tours par pilote et par course (`raceId`, `driverId`, `lap`, `time`, `timeMillis`).
* **`f1db-constructors-chronology.csv`** : filiation et chronologie des écuries (`parentConstructorId`, `constructorId`, `yearFrom`, `yearTo`).

---

## 🗄️ Architecture de la base de données (V3 — `F1_Data`)

| Nom | Description |
| :--- | :--- |
| **`pays`** | Référentiel des pays (`id_pays`, `nom_pays`, `url_drapeau`) |
| **`circuits`** | Les 5 circuits étudiés (`id_circuit`, `nom_circuit`, `id_pays`, `url_img_circuit`) |
| **`ecuries`** | Constructeurs engagés (`id_ecurie`, `id_pays`, `nom_ecurie`, `code_couleur`, `url_logo`) |
| **`pilotes`** | Pilotes engagés (`id_pilote`, `nom_pilote`, `prenom_pilote`, `id_pays`, `url_img_casque`) |
| **`reglementations`** | Ères réglementaires (`id_reglementation`, `nom_ere`, `caracteristiques`, `annee_deb_regle`, `annee_fin_regle`) |
| **`saisons`** | Saisons rattachées aux réglementations (`id_saison`, `id_reglementation`) |
| **`grand_prix`** | Grands Prix disputés sur le périmètre retenu (`id_grand_prix`, `id_saison`, `id_circuit`, `nom_grand_prix`, `date_grand_prix`) |
| **`status`** | status de fin de course (`id_statut`, `libelle_statut`) |
| **`resultats_laps`** | Table de faits tour par tour (`id_grand_prix`, `id_pilote`, `id_lap`, `id_ecurie`, `id_statut`, `lap_time`, `lap_avg_speed`) |
| **`users`** | Comptes et rôles applicatifs (`id_user`, `nom_user`, `mdp_user`, `role`) |

---

## 🛠️ Stack technique & Pipeline (Architecture Médaillon)

1. **Bronze (`data/01_bronze/`) :** stockage brut des archives `.zip` et des CSV sources non modifiés.
2. **Silver (`data/02_silver/`) :** extraction, filtrage sur la période **1997–2026** et les **5 circuits**, et normalisation des CSV intermédiaires.
3. **Gold (`data/03_gold/`) :** génération des tables finales nettoyées prêtes pour le chargement.
4. **Stockage & Modélisation (Snowflake) :** création du schéma (`sql/schema.sql`), chargement des données et requêtage SQL.
5. **Visualisation (Streamlit) :** application interactive modulaire (`app.py`, `onglets/`).

---

### Dictionnaire Gold & Alimentation de `data/03_gold/`

Le fichier **`docs/dictionnaire_csv_gold.md`** documente la structure exacte des CSV produits dans **`data/03_gold/`** (colonnes, types, contraintes et fichiers `data/02_silver/` utilisés en entrée), incluant les adaptations et simplifications décidées pour la couche Gold avant chargement dans Snowflake. Pour remplir `data/03_gold/`, chaque notebook de nettoyage dédié dans `scripts/` (ex. `clean_circuits.ipynb`, `clean_status.ipynb`, `clean_lap_times.ipynb`) lit les CSV filtrés de `data/02_silver/` sur le périmètre **1997–2026** et les **5 circuits**, nettoie et renomme les champs selon le dictionnaire Gold, puis exporte le CSV final correspondant dans `data/03_gold/`.

---

## 📁 Structure du dépôt

```text
Data-to-Survive/
├── .streamlit/
│   └── config.toml          # Configuration du thème Streamlit
├── data/
│   ├── 01_bronze/           # Archives brutes (.zip) et CSV sources non modifiés
│   ├── 02_silver/           # CSV extraits et filtrés (1997–2026, 5 circuits)
│   └── 03_gold/             # Fichiers CSV finaux nettoyés prêts pour Snowflake
├── docs/
│   ├── cahier_des_charges.md
│   └── dictionnaire_tables.md  # Dictionnaire des données et modèle relationnel (V3)
├── onglets/
│   ├── __init__.py
│   ├── accueil.py           # Vue d'ensemble et KPIs globaux
│   ├── vitesse.py           # Axe 1 : Vitesse & Chronos
│   ├── circuits.py          # Comparatif des 5 circuits
│   └── ecuries.py           # Analyse par écurie
├── scripts/
│   ├── clean_data.py        # Nettoyage et préparation des données (Bronze -> Silver -> Gold)
│   └── load_snowflake.py    # Chargement des tables Gold dans Snowflake
├── sql/
│   └── schema.sql           # Création des tables (V3)
├── .gitignore
├── app.py                   # Point d'entrée de l'application Streamlit
├── README.md
└── requirements.txt         # Dépendances Python
```

---

## 🚀 Lancement de l'application

```bash
pip install -r requirements.txt
streamlit run app.py
```

---

## 📈 Évolution prévisionnelle : Axes 2 & 3 *(si le temps le permet)*

Après validation du périmètre initial (**Axe 1 — Vitesse & Chronos**), le projet pourra s'étendre sur :

* **Axe 2 — Compétitivité / Serrage de la grille :** écarts de performance entre pilotes/écuries et évolution des positions/chronos selon les réglementations.
* **Axe 3 — Fiabilité mécanique :** taux d'abandon et répartition des causes (mécanique vs incident/accident ou course terminée) par ère et par circuit.

| Axe / Périmètre | Évolutions tables / colonnes | Dataset source & CSV |
| :--- | :--- | :--- |
| **Axe 2 — Compétitivité** | Enrichir les données de course (`grid`, `positionOrder`, `laps`) et éventuellement ajouter une table `qualifications` (`q1`, `q2`, `q3`) | `TracingInsights/RaceData` (`dataset_2.zip`, CC0-1.0) : `results.csv`, `lap_times.csv`, `qualifying.csv` |
| **Axe 3 — Fiabilité** | Catégoriser les status (`Termine`, `Mecanique`, `Accident/Incident`, `Autre`) et exploiter `laps` | `TracingInsights/RaceData` (`dataset_2.zip`, CC0-1.0) : `status.csv`, `results.csv` |