# Dictionnaire des données — Data to Survive

Modèle relationnel cible (**`F1_Data` — V3**) pour le projet **Data to Survive (1997–2026)**, alimenté depuis la couche **`data/03_gold/`**, filtré sur 5 circuits (**Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka**) et centré sur l'**Axe 1 : Vitesse & Chronos**.

---

## 1. Tables de dimension

### `pays` (`data/03_gold/pays.csv`)
Référentiel des pays associés aux circuits, écuries et pilotes.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pays` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique du pays |
| `nom_pays` | `VARCHAR(255)` | `NOT NULL` | Nom du pays ou nationalité |
| `url_drapeau` | `TEXT` | `NOT NULL` | URL du visuel drapeau |

### `circuits` (`data/03_gold/circuits.csv`)
Les 5 circuits retenus pour l'étude.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_circuit` | `INT` | `PK, AUTOINCREMENT` | Identifiant du circuit |
| `nom_circuit` | `VARCHAR(255)` | `NOT NULL` | Nom du circuit |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays du circuit |
| `url_img_circuit` | `TEXT` | `NOT NULL` | URL du visuel / tracé du circuit |

### `ecuries` (`data/03_gold/ecuries.csv`)
Constructeurs engagés sur les courses filtrées.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_ecurie` | `INT` | `PK, AUTOINCREMENT` | Identifiant de l'écurie |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays / nationalité de l'écurie |
| `nom_ecurie` | `VARCHAR(255)` | `NOT NULL` | Nom de l'écurie |
| `code_couleur` | `VARCHAR(10)` | `NOT NULL` | Code couleur hexadécimal ou identifiant couleur de l'écurie |
| `url_logo` | `TEXT` | `NOT NULL` | URL du logo de l'écurie |

### `pilotes` (`data/03_gold/pilotes.csv`)
Pilotes ayant pris le départ des Grands Prix filtrés.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pilote` | `INT` | `PK, AUTOINCREMENT` | Identifiant du pilote |
| `nom_pilote` | `VARCHAR(255)` | `NOT NULL` | Nom de famille |
| `prenom_pilote` | `VARCHAR(255)` | `NOT NULL` | Prénom |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays / nationalité du pilote |
| `url_img_casque` | `TEXT` | `NOT NULL` | URL du visuel casque |

### `reglementations` (`data/03_gold/reglementations.csv`)
Découpage des ères réglementaires de la F1.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_reglementation` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique de la réglementation |
| `nom_ere` | `VARCHAR(255)` | `NOT NULL` | Nom de l'ère réglementaire |
| `caracteristiques` | `VARCHAR(255)` | `NOT NULL` | Caractéristiques techniques de la réglementation |
| `annee_deb_regle` | `INT` | `NOT NULL` | Année de début de la réglementation |
| `annee_fin_regle` | `INT` | `NULL` | Année de fin de la réglementation |

### `saisons` (`data/03_gold/saisons.csv`)
Saisons rattachées à une réglementation.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_saison` | `INT` | `PK, NOT NULL` | Saison (`year`, 1997–2026) |
| `id_reglementation` | `INT` | `NOT NULL, FK -> reglementations.id_reglementation` | Réglementation associée |

### `grand_prix` (`data/03_gold/grand_prix.csv`)
Éditions des Grands Prix disputés sur les 5 circuits (1997–2026).

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_grand_prix` | `INT` | `PK, AUTOINCREMENT` | Identifiant du Grand Prix |
| `id_saison` | `INT` | `NOT NULL, FK -> saisons.id_saison` | Saison associée |
| `id_circuit` | `INT` | `NOT NULL, FK -> circuits.id_circuit` | Circuit associé |
| `nom_grand_prix` | `VARCHAR(255)` | `NOT NULL` | Nom du Grand Prix |
| `date_grand_prix` | `DATE` | `NOT NULL` | Date du Grand Prix |

### `status` (`data/03_gold/status.csv`)
status d'arrivée ou d'abandon en course.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_statut` | `INT` | `PK, AUTOINCREMENT` | Identifiant du statut |
| `libelle_statut` | `VARCHAR(255)` | `NOT NULL` | Libellé du statut |

### `users` (`data/03_gold/users.csv`)
Comptes et rôles applicatifs.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_user` | `INT` | `PK, AUTOINCREMENT` | Identifiant utilisateur |
| `nom_user` | `VARCHAR(255)` | `NOT NULL` | Nom d'utilisateur |
| `mdp_user` | `VARCHAR(255)` | `NOT NULL` | Mot de passe (hashé de préférence) |
| `role` | `VARCHAR(255)` | `NOT NULL` | Rôle utilisateur |

---

## 2. Table de faits

### `resultats_laps` (`data/03_gold/resultats_laps.csv`)
Performances tour par tour par Grand Prix et par pilote. Clé primaire composite : `(id_grand_prix, id_pilote, id_lap)`.

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_grand_prix` | `INT` | `PK (1/3), NOT NULL, FK -> grand_prix.id_grand_prix` | Grand Prix |
| `id_pilote` | `INT` | `PK (2/3), NOT NULL, FK -> pilotes.id_pilote` | Pilote |
| `id_lap` | `INT` | `PK (3/3), NOT NULL` | Numéro de tour |
| `id_ecurie` | `INT` | `NOT NULL, FK -> ecuries.id_ecurie` | Écurie |
| `id_statut` | `INT` | `NOT NULL, FK -> status.id_statut` | Statut de fin de course |
| `lap_time` | `TIME` | `NULL` | Temps du tour |
| `lap_avg_speed` | `FLOAT` | `NULL` | Vitesse moyenne sur le tour |