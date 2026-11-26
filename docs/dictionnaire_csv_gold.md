# Dictionnaire CSV gold
Dictionnaires des CSV filtrés et nettoyés

## CSV : circuits.csv

Script : `clean_circuits.ipynb`  
data silver : `circuits.csv` | `traces_drapeaux_circuits.csv`  
data gold : `circuits.csv`

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_circuit` | `INT` | `PK, AUTOINCREMENT` | Identifiant du circuit |
| `nom_circuit` | `VARCHAR(255)` | `NOT NULL` | Nom du circuit |
| `nom_officiel` | `VARCHAR(255)` | `NOT NULL` | Nom officiel circuit |
| `id_pays` | `VARCHAR(2)` | `NOT NULL` | Nom du pays |
| `url_img_circuit` | `TEXT` | `NOT NULL` | URL du visuel / tracé du circuit |

---

## CSV : status.csv

Script : `clean_statuts.ipynb`  
data silver : `statuts.csv`  
data gold : `statuts.csv`

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_statut` | `INT` | `PK, AUTOINCREMENT` | Identifiant du statut |
| `libelle_statut` | `VARCHAR(255)` | `NOT NULL` | Libellé du statut |


--- 

## CSV : resultats_laps.csv

Script : `clean_lap_times.ipynb`
data silver : `lap_times.csv` | `f1db-races.csv`
data gold : `resultats_laps.csv`

| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_grand_prix` | `INT` | `PK (1/3), NOT NULL, FK -> grand_prix.id_grand_prix` | Grand Prix |
| `id_pilote` | `INT` | `PK (2/3), NOT NULL, FK -> pilotes.id_pilote` | Pilote |
| `id_lap` | `INT` | `PK (3/3), NOT NULL` | Numéro de tour |
| `id_ecurie` | `INT` | `NOT NULL, FK -> ecuries.id_ecurie` | Écurie |
| `id_statut` | `INT` | `NOT NULL, FK -> statuts.id_statut` | Statut de fin de course |
| `lap_time` | `TIME` | `NULL` | Temps du tour |
| `lap_avg_speed` | `FLOAT` | `NULL` | Vitesse moyenne sur le tour |

## CSV :