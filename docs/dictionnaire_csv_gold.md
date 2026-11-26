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
