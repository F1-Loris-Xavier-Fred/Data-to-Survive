# 🏎️ Data to Survive

Analyse historique des performances en Formule 1 (**1997–2026**) sur cinq circuits emblématiques (**Monza, Monaco, Spa-Francorchamps, Silverstone et Suzuka**), centrée dans un premier temps sur l'**Axe 1 : Vitesse pure & Chronos en course**.

---

## 🎯 Objectifs du projet (Focus Courses — Axe 1)
* Mesurer l'évolution des temps au tour (**moyen** et **meilleur chrono** en millisecondes) et des vitesses (**moyenne** et **de pointe** en km/h) par circuit et par ère réglementaire.
* Isoler les courses validées via la gestion des statuts d'arrivée afin d'éviter les biais liés aux abandons précoces.
* Restituer les analyses via une base relationnelle **Snowflake** et une application interactive **Streamlit**.

---

## 📦 Source des données

### TracingInsights RaceData (`TracingInsights/RaceData`)
* **Dépôt GitHub :** [https://github.com/TracingInsights/RaceData](https://github.com/TracingInsights/RaceData)
* **Archive ZIP (dernière version) :** [https://github.com/TracingInsights/RaceData/releases/latest/download/data.zip](https://github.com/TracingInsights/RaceData/releases/latest/download/data.zip)
* **Miroir HuggingFace :** [https://huggingface.co/datasets/tracinginsights/RaceData](https://huggingface.co/datasets/tracinginsights/RaceData)
* **Licence :** CC0-1.0 (Domaine public — données Ergast / Jolpica-F1 mises à jour jusqu'à la saison 2026)

### Fichiers CSV utilisés
* **`circuits.csv`** : référentiel des circuits (`circuitId`, `name`, `country`).
* **`races.csv`** : calendrier des Grands Prix (`raceId`, `year`, `circuitId`, `name`, `date`).
* **`drivers.csv`** : informations pilotes (`driverId`, `forename`, `surname`, `nationality`).
* **`constructors.csv`** : informations écuries (`constructorId`, `name`, `nationality`).
* **`status.csv`** : libellés des statuts de fin de course (`statusId`, `status`).
* **`results.csv`** : résultats par pilote et par course (`raceId`, `driverId`, `constructorId`, `statusId`, `fastestLapTime`, `fastestLapSpeed`).
* **`lap_times.csv`** : temps tour par tour (`raceId`, `driverId`, `lap`, `milliseconds`) pour le calcul des moyennes en course.

---

## 🗄️ Architecture de la base de données (Snowflake)

| Nom | Description |
| :--- | :--- |
| **`pays`** | Référentiel des pays associés aux circuits ainsi qu'aux nationalités des pilotes et des écuries (`id_pays`, `nom_pays`). |
| **`circuits`** | Liste des 5 circuits retenus pour l'étude (Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka) reliés à leur pays (`id_circuit`, `nom_circuit`, `id_pays`). |
| **`ecuries`** | Référentiel des constructeurs engagés en championnat (`id_ecurie`, `nom_ecurie`, `id_pays`). |
| **`pilotes`** | Référentiel des pilotes ayant pris le départ des Grands Prix étudiés (`id_pilote`, `prenom_pilote`, `nom_pilote`, `id_pays`). |
| **`reglementations`** | Découpage des grandes ères techniques et réglementaires de la F1 (`id_reglementation`, `nom_ere`, `annee_debut`, `annee_fin`, `caracteristiques`). |
| **`saisons`** | Table des saisons de 1997 à 2026 rattachées à leur ère réglementaire respective (`id_saison`, `id_reglementation`). |
| **`grand_prix`** | Informations générales de chaque Grand Prix disputé sur le périmètre retenu (`id_gp`, `id_saison`, `id_circuit`, `nom_gp`, `date_course`). |
| **`statuts`** | Référentiel des statuts d'arrivée permettant de filtrer les courses validées et d'écarter les abandons précoces (`id_statut`, `libelle_statut`). |
| **`resultats`** | Table centrale des performances par pilote et par course (`id_gp`, `id_pilote`, `id_ecurie`, `id_statut`, `avg_chrono`, `top_chrono`, `avg_speed`, `top_speed`). |

---

## 🛠️ Stack technique & Pipeline
1. **Extraction & Nettoyage (Python / Pandas) :** filtrage sur la période 1997–2026 et les 5 circuits, gestion des valeurs nulles, conversion des chronos en millisecondes (`INT`) et calcul des moyennes par course.
2. **Stockage & Modélisation (Snowflake) :** chargement des 9 tables normalisées et requêtage analytique SQL.
3. **Visualisation (Streamlit) :** tableau de bord interactif avec filtres par circuit, saison et ère réglementaire.

---

## 📁 Structure du dépôt
```text
├── data/
│   ├── raw/            # Fichiers CSV bruts issus de TracingInsights/RaceData
│   └── clean/          # Fichiers CSV nettoyés prêts pour Snowflake
├── notebooks/
│   └── exploration.ipynb
├── scripts/
│   ├── clean_data.py   # Nettoyage, normalisation et calcul des indicateurs Pandas
│   └── load_snowflake.py
├── sql/
│   └── schema.sql      # Création des tables Snowflake
├── app/
│   └── app.py          # Application Streamlit
└── README.md

---


## 🚀 Évolution prévue : Axes 2 & 3

Après validation du périmètre initial (**Axe 1 — Vitesse & Chronos** en course), le projet a vocation à s'étendre sur deux axes complémentaires :
* **Axe 2 — Compétitivité / Serrage de la grille :** analyse des écarts de performance entre pilotes/écuries et de l'évolution des positions/chronos selon les réglementations.
* **Axe 3 — Fiabilité mécanique :** analyse des taux d'abandon et de la répartition des causes (problèmes mécaniques/moteur/boîte vs incidents/accidents ou courses terminées) par ère et par circuit.

### Besoins complémentaires (Tables & Dataset source)

| Axe / Périmètre | Tables à ajouter ou enrichir | Dataset source & fichiers CSV nécessaires |
| :--- | :--- | :--- |
| **Axe 2 — Compétitivité** | • Enrichir **`resultats`** avec `position_depart` (`grid`), `position_arrivee` (`positionOrder`) et `tours_effectues` (`laps`)<br>• *(Optionnel)* Ajouter **`qualifications`** si analyse des chronos qualif (`q1`, `q2`, `q3` en ms) | • **Toujours `TracingInsights/RaceData` (CC0-1.0)** — aucun nouveau dataset requis<br>• `results.csv` (`grid`, `positionOrder`, `laps`) et `lap_times.csv`<br>• *(Optionnel)* `qualifying.csv` |
| **Axe 3 — Fiabilité** | • Enrichir **`statuts`** avec `categorie_fiabilite` (ex. `Termine`, `Mecanique`, `Accident/Incident`, `Autre`)<br>• Enrichir **`resultats`** avec `tours_effectues` (`laps`) | • **Toujours `TracingInsights/RaceData` (CC0-1.0)** — aucun nouveau dataset requis<br>• `status.csv` (`statusId`, `status`) et `results.csv` (`statusId`, `laps`) |