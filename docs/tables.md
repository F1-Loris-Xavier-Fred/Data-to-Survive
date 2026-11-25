# Dictionnaire des données — Data to Survive (V3)

Modèle relationnel cible (**`F1_Data` — V3**) pour le projet **Data to Survive (1997–2026)**, filtré sur 5 circuits (**Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka**) et centré sur l'**Axe 1 : Vitesse & Chronos**.

---

## 1. Tables de dimension

### `pays`
Référentiel des pays associés aux circuits, écuries et pilotes[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pays` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique du pays[cite: 2] |
| `nom_pays` | `VARCHAR(255)` | `NOT NULL` | Nom du pays ou nationalité[cite: 2] |
| `url_drapeau` | `TEXT` | `NOT NULL` | URL du visuel drapeau[cite: 2] |

### `circuits`
Les 5 circuits retenus pour l'étude[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_circuit` | `INT` | `PK, AUTOINCREMENT` | Identifiant du circuit[cite: 2] |
| `nom_circuit` | `VARCHAR(255)` | `NOT NULL` | Nom du circuit[cite: 2] |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays du circuit[cite: 2] |
| `url_img_circuit` | `TEXT` | `NOT NULL` | URL du visuel / tracé du circuit[cite: 2] |

### `ecuries`
Constructeurs engagés sur les courses filtrées[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_ecurie` | `INT` | `PK, AUTOINCREMENT` | Identifiant de l'écurie[cite: 2] |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays / nationalité de l'écurie[cite: 2] |
| `nom_ecurie` | `VARCHAR(255)` | `NOT NULL` | Nom de l'écurie[cite: 2] |
| `code_couleur` | `INT` | `NOT NULL` | Code couleur de l'écurie (selon V3)[cite: 2] |
| `url_logo` | `TEXT` | `NOT NULL` | URL du logo de l'écurie[cite: 2] |

### `pilotes`
Pilotes ayant pris le départ des Grands Prix filtrés[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_pilote` | `INT` | `PK, AUTOINCREMENT` | Identifiant du pilote[cite: 2] |
| `nom_pilote` | `VARCHAR(255)` | `NOT NULL` | Nom de famille[cite: 2] |
| `prenom_pilote` | `VARCHAR(255)` | `NOT NULL` | Prénom[cite: 2] |
| `id_pays` | `INT` | `NOT NULL, FK -> pays.id_pays` | Pays / nationalité du pilote[cite: 2] |
| `url_img_casque` | `TEXT` | `NOT NULL` | URL du visuel casque[cite: 2] |

### `reglementations`
Découpage des ères réglementaires de la F1[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_reglementation` | `INT` | `PK, AUTOINCREMENT` | Identifiant unique de la réglementation[cite: 2] |
| `annee_deb_regle` | `INT` | `NOT NULL` | Année de début de la réglementation[cite: 2] |
| `annee_fin_regle` | `INT` | `NULL` | Année de fin de la réglementation[cite: 2] |
| `caracteristiques` | `VARCHAR(255)` | `NOT NULL` | Caractéristiques techniques de la réglementation[cite: 2] |

### `saisons`
Saisons rattachées à une réglementation[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_saison` | `INT` | `PK, AUTOINCREMENT` | Saison (`year`, 1997–2026)[cite: 2] |
| `id_reglementation` | `INT` | `NOT NULL, FK -> reglementations.id_reglementation` | Réglementation associée[cite: 2] |

### `grand_prix`
Éditions des Grands Prix disputés sur les 5 circuits (1997–2026)[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_grand_prix` | `INT` | `PK, AUTOINCREMENT` | Identifiant du Grand Prix[cite: 2] |
| `id_saison` | `INT` | `NOT NULL, FK -> saisons.id_saison` | Saison associée[cite: 2] |
| `id_circuit` | `INT` | `NOT NULL, FK -> circuits.id_circuit` | Circuit associé[cite: 2] |
| `nom_grand_prix` | `VARCHAR(255)` | `NOT NULL` | Nom du Grand Prix[cite: 2] |
| `date_grand_prix` | `DATE` | `NOT NULL` | Date du Grand Prix[cite: 2] |

### `statuts`
Statuts d'arrivée ou d'abandon en course[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_statut` | `INT` | `PK, AUTOINCREMENT` | Identifiant du statut[cite: 2] |
| `libelle_statut` | `VARCHAR(255)` | `NOT NULL` | Libellé du statut[cite: 2] |

### `users`
Comptes et rôles applicatifs[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_user` | `INT` | `PK, AUTOINCREMENT` | Identifiant utilisateur[cite: 2] |
| `nom_user` | `VARCHAR(255)` | `NOT NULL` | Nom d'utilisateur[cite: 2] |
| `mdp_user` | `VARCHAR(255)` | `NOT NULL` | Mot de passe[cite: 2] |
| `role` | `VARCHAR(255)` | `NOT NULL` | Rôle utilisateur[cite: 2] |

---

## 2. Table de faits

### `resultats_laps`
Performances tour par tour par Grand Prix et par pilote. Clé primaire composite : `(id_grand_prix, id_pilote, id_lap)`[cite: 2].

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_grand_prix` | `INT` | `PK (1/3), AUTOINCREMENT, FK -> grand_prix.id_grand_prix` | Grand Prix[cite: 2] |
| `id_pilote` | `INT` | `PK (2/3), FK -> pilotes.id_pilote` | Pilote[cite: 2] |
| `id_lap` | `INT` | `PK (3/3), NOT NULL` | Numéro de tour[cite: 2] |
| `id_ecurie` | `INT` | `NOT NULL, FK -> ecuries.id_ecurie` | Écurie[cite: 2] |
| `id_statut` | `INT` | `NOT NULL, FK -> statuts.id_statut` | Statut de fin de course[cite: 2] |
| `lap_time` | `TIME` | `NULL` | Temps du tour[cite: 2] |
| `lap_top_speed` | `FLOAT` | `NULL` | Vitesse maximale / pointe sur le tour[cite: 2] |
| `lap_avg_speed` | `FLOAT` | `NULL` | Vitesse moyenne sur le tour[cite: 2] |