# Dictionnaire des données — Data to Survive

Modèle relationnel cible sous **Snowflake** pour le projet **Data to Survive (1997–2026)**, filtré sur 5 circuits (**Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka**) et centré sur l'**Axe 1 : Vitesse & Chronos**.

---

## 1. Tables de dimension

### `pays`
Référentiel normalisé des pays (circuits, écuries, pilotes).

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pays` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique généré |
| `nom_pays` | `VARCHAR(100)` | `NOT NULL, UNIQUE` | Nom du pays ou nationalité normalisée |

### `circuits`
Les 5 circuits retenus pour l'étude.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_circuit` | `INT` | `PK` | `circuitId` (`circuits.csv`) |
| `nom_circuit` | `VARCHAR(150)` | `NOT NULL, UNIQUE` | `name` (`circuits.csv`) |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays du circuit |

### `ecuries`
Constructeurs engagés sur les courses filtrées.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_ecurie` | `INT` | `PK` | `constructorId` (`constructors.csv`) |
| `nom_ecurie` | `VARCHAR(150)` | `NOT NULL, UNIQUE` | `name` (`constructors.csv`) |
| `code_couleur` | `VARCHAR(7)` | `NULL` | Dernière couleur officielle hexadécimale (`#RRGGBB`) ajoutée hors CSV |
| `id_pays` | `INT` | `NULL, FK -> pays.id_pays` | Nationalité de l'écurie (peut être null si non renseignée / à normaliser) |

### `pilotes`
Pilotes ayant pris le départ des Grands Prix filtrés.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pilote` | `INT` | `PK` | `driverId` (`drivers.csv`) |
| `prenom_pilote` | `VARCHAR(100)` | `NOT NULL` | `forename` (`drivers.csv`) |
| `nom_pilote` | `VARCHAR(100)` | `NOT NULL` | `surname` (`drivers.csv`) |
| `id_pays` | `INT` | `FK -> pays.id_pays` | Nationalité du pilote |

### `reglementations`
Grandes ères techniques de la Formule 1 (1997–2026).

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_reglementation` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique généré |
| `nom_ere` | `VARCHAR(100)` | `NOT NULL` | Ex. `V10`, `V8`, `Hybride 2014`, `Aero 2017`, `Effet de sol 2022` |
| `annee_debut` | `INT` | `NOT NULL` | Année de début de l'ère |
| `annee_fin` | `INT` | `NOT NULL` | Année de fin de l'ère |
| `caracteristiques` | `VARCHAR(1000)` | `NULL` | Résumé des évolutions moteur / aéro / pneus |

### `saisons`
Années de championnat rattachées à leur ère réglementaire.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_saison` | `INT` | `PK` | Année (`year` de `races.csv`, 1997 à 2026) |
| `id_reglementation` | `INT` | `NOT NULL, FK -> reglementations.id_reglementation` | Ère technique correspondante |

### `grand_prix`
Éditions des Grands Prix disputés sur les 5 circuits entre 1997 et 2026.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_gp` | `INT` | `PK` | `raceId` (`races.csv`) |
| `id_saison` | `INT` | `NOT NULL, FK -> saisons.id_saison` | Saison (`year`) |
| `id_circuit` | `INT` | `NOT NULL, FK -> circuits.id_circuit` | Circuit (`circuitId`) |
| `nom_gp` | `VARCHAR(150)` | `NOT NULL` | Nom officiel du Grand Prix (`name`) |
| `date_course` | `DATE` | `NOT NULL` | Date de la course (`date`) |

### `statuts`
Statuts d'arrivée ou d'abandon en course.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_statut` | `INT` | `PK` | `statusId` (`status.csv`) |
| `libelle_statut` | `VARCHAR(120)` | `NOT NULL, UNIQUE` | Libellé (`status`, ex. `Finished`, `Engine`, `Collision`) |

---

## 2. Table de faits

### `resultats`
Performances chronométriques et vitesses par pilote et par Grand Prix. Clé primaire composite : `(id_gp, id_pilote)`.

| Colonne | Type Snowflake | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_gp` | `INT` | `PK (1/2), FK -> grand_prix.id_gp` | Grand Prix (`raceId`) |
| `id_pilote` | `INT` | `PK (2/2), FK -> pilotes.id_pilote` | Pilote (`driverId`) |
| `id_ecurie` | `INT` | `NOT NULL, FK -> ecuries.id_ecurie` | Écurie (`constructorId`) |
| `id_statut` | `INT` | `NOT NULL, FK -> statuts.id_statut` | Statut d'arrivée (`statusId`) |
| `avg_chrono` | `INT` | `NULL` | Moyenne des temps au tour en ms (`lap_times.csv`) |
| `top_chrono` | `INT` | `NULL` | Meilleur chrono en ms (`fastestLapTime` / min `lap_times.csv`) |
| `avg_speed` | `FLOAT` | `NULL` | Moyenne des relevés de vitesse (en km/h) agrégée par circuit et par année |
| `top_speed` | `FLOAT` | `NULL` | Vitesse du meilleur tour en km/h (`fastestLapSpeed`) |