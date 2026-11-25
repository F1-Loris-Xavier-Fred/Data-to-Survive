# 🏎️ Data to Survive

Analyse historique des performances en Formule 1 (**1997–2026**) sur cinq circuits emblématiques (**Monza, Monaco, Spa-Francorchamps, Silverstone et Suzuka**), centrée dans un premier temps sur l'**Axe 1 : Vitesse pure & Chronos en course**.

**Équipe :** Loris, Xavier et Fred

---

## 🎯 Objectifs du projet (Focus Courses — Axe 1)
- Mesurer l'évolution des temps au tour et des vitesses par circuit, saison et ère réglementaire.
- Isoler les courses validées via la gestion des statuts d'arrivée afin d'éviter les biais liés aux abandons précoces.
- Restituer les analyses via une base relationnelle et une application interactive **Streamlit**.

---

## 📋 Suivi du projet & Organisation

- **Suivi quotidien des tâches (Google Sheets) :** [Tableau de suivi — Data to Survive](https://docs.google.com/spreadsheets/d/1i7hicBHCIE0ChhZ_ZcqStX2iAYfbgVwJfkxkMjlQ4_U/edit?gid=0#gid=0)
- **Workflow Git :**
  - `main` : version stable du projet.
  - `dev` : branche d'intégration commune de l'équipe.
  - `dev-fred`, `dev-xavier`, `dev-loris` : branches de développement individuelles.

---

## 📦 Source des données

### TracingInsights RaceData (`TracingInsights/RaceData`)
- **Dépôt GitHub :** [https://github.com/TracingInsights/RaceData](https://github.com/TracingInsights/RaceData)
- **Archive ZIP (dernière version) :** [https://github.com/TracingInsights/RaceData/releases/latest/download/data.zip](https://github.com/TracingInsights/RaceData/releases/latest/download/data.zip)
- **Miroir HuggingFace :** [https://huggingface.co/datasets/tracinginsights/RaceData](https://huggingface.co/datasets/tracinginsights/RaceData)
- **Licence :** CC0-1.0 (Domaine public — données Ergast / Jolpica-F1 mises à jour jusqu'à la saison 2026)

### Fichiers CSV utilisés
Les fichiers CSV ci-dessous proviennent de l'archive **`data/data_brute/dataset#2.zip`** (source **`TracingInsights/RaceData`**) :
- **`circuits.csv`** : référentiel des circuits (`circuitId`, `name`, `country`).
- **`races.csv`** : calendrier des Grands Prix (`raceId`, `year`, `circuitId`, `name`, `date`).
- **`drivers.csv`** : informations pilotes (`driverId`, `forename`, `surname`, `nationality`).
- **`constructors.csv`** : informations écuries (`constructorId`, `name`, `nationality`).
- **`status.csv`** : libellés des statuts de fin de course (`statusId`, `status`).
- **`results.csv`** : résultats par pilote et par course (`raceId`, `driverId`, `constructorId`, `statusId`, `fastestLapTime`, `fastestLapSpeed`).
- **`lap_times.csv`** : temps tour par tour (`raceId`, `driverId`, `lap`, `milliseconds`).

---

## 🗄️ Architecture de la base de données (V3 — `F1_Data`)

| Nom | Description |
| :--- | :--- |
| **`pays`** | Référentiel des pays (`id_pays`, `nom_pays`, `url_drapeau`)[cite: 2]. |
| **`circuits`** | Les 5 circuits étudiés (`id_circuit`, `nom_circuit`, `id_pays`, `url_img_circuit`)[cite: 2]. |
| **`ecuries`** | Constructeurs engagés (`id_ecurie`, `id_pays`, `nom_ecurie`, `code_couleur`, `url_logo`)[cite: 2]. |
| **`pilotes`** | Pilotes engagés (`id_pilote`, `nom_pilote`, `prenom_pilote`, `id_pays`, `url_img_casque`)[cite: 2]. |
| **`reglementations`** | Ères réglementaires (`id_reglementation`, `annee_deb_regle`, `annee_fin_regle`, `caracteristiques`)[cite: 2]. |
| **`saisons`** | Saisons rattachées aux réglementations (`id_saison`, `id_reglementation`)[cite: 2]. |
| **`grand_prix`** | Grands Prix disputés sur le périmètre retenu (`id_grand_prix`, `id_saison`, `id_circuit`, `nom_grand_prix`, `date_grand_prix`)[cite: 2]. |
| **`statuts`** | Statuts de fin de course (`id_statut`, `libelle_statut`)[cite: 2]. |
| **`resultats_laps`** | Table de faits tour par tour (`id_grand_prix`, `id_pilote`, `id_lap`, `id_ecurie`, `id_statut`, `lap_time`, `lap_top_speed`, `lap_avg_speed`)[cite: 2]. |
| **`users`** | Comptes et rôles applicatifs (`id_user`, `nom_user`, `mdp_user`, `role`)[cite: 2]. |

---

## 🛠️ Stack technique & Pipeline
1. **Extraction & Nettoyage (Python / Pandas) :** filtrage sur 1997–2026 et les 5 circuits, structuration par tour (`resultats_laps`) et préparation des tables[cite: 2].
2. **Stockage & Modélisation :** création du schéma (`sql/schema.sql`), chargement des données et requêtage SQL[cite: 2].
3. **Visualisation (Streamlit) :** application interactive modulaire (`app.py`, `onglets/`).

---

## 📁 Structure du dépôt

```text
Data-to-Survive/
├── .streamlit/
│   └── config.toml          # Configuration du thème Streamlit
├── data/
│   ├── data_brute/          # Archives brutes (.zip) issues des datasets sources
│   └── data_clean/          # Fichiers CSV nettoyés prêts pour chargement
├── docs/
│   ├── cahier_des_charges_architecture_donnees.md
│   └── tables.md            # Dictionnaire des données et modèle relationnel (V3)
├── onglets/
│   ├── __init__.py
│   ├── accueil.py           # Vue d'ensemble et KPIs globaux
│   ├── vitesse.py           # Axe 1 : Vitesse & Chronos
│   ├── circuits.py          # Comparatif des 5 circuits
│   └── ecuries.py           # Analyse par écurie
├── scripts/
│   ├── clean_data.py        # Nettoyage et préparation des données (Pandas)
│   └── load_snowflake.py    # Chargement des tables
├── sql/
│   └── schema.sql           # Création des tables (V3)
├── .gitignore
├── app.py                   # Point d'entrée de l'application Streamlit
├── README.md
└── requirements.txt         # Dépendances Python


---

```

---

## 🚀 Lancement de l'application

```bash
pip install -r requirements.txt
streamlit run app.py
```

---

## 📈 Évolution prévisionnelle : Axes 2 & 3 *(si le temps le permet)*

Après validation du périmètre initial (**Axe 1 — Vitesse & Chronos** en course), le projet pourra s'étendre sur deux axes complémentaires :
- **Axe 2 — Compétitivité / Serrage de la grille :** analyse des écarts de performance entre pilotes/écuries et de l'évolution des positions/chronos selon les réglementations.
- **Axe 3 — Fiabilité mécanique :** analyse des taux d'abandon et de la répartition des causes (problèmes mécaniques/moteur/boîte vs incidents/accidents ou courses terminées) par ère et par circuit.

### Besoins complémentaires (Tables & Dataset source)

| Axe / Périmètre | Tables à ajouter ou enrichir | Dataset source & fichiers CSV nécessaires |
| :--- | :--- | :--- |
| **Axe 2 — Compétitivité** | • Enrichir **`resultats`** avec `position_depart` (`grid`), `position_arrivee` (`positionOrder`) et `tours_effectues` (`laps`)<br>• *(Optionnel)* Ajouter **`qualifications`** si analyse des chronos qualif (`q1`, `q2`, `q3` en ms) | • **Toujours `TracingInsights/RaceData` (`dataset#2.zip`, CC0-1.0)** — aucun nouveau dataset requis<br>• `results.csv` (`grid`, `positionOrder`, `laps`) et `lap_times.csv`<br>• *(Optionnel)* `qualifying.csv` |
| **Axe 3 — Fiabilité** | • Enrichir **`statuts`** avec `categorie_fiabilite` (ex. `Termine`, `Mecanique`, `Accident/Incident`, `Autre`)<br>• Enrichir **`resultats`** avec `tours_effectues` (`laps`) | • **Toujours `TracingInsights/RaceData` (`dataset#2.zip`, CC0-1.0)** — aucun nouveau dataset requis<br>• `status.csv` (`statusId`, `status`) et `results.csv` (`statusId`, `laps`) |


test