# Dictionnaire CSV gold
Dictionnaires des CSV filtrés et nettoyés

## CSV : circuits.csv
| Colonne | Type | Contraintes | Source / Description |
| :--- | :--- | :--- | :--- |
| `id_circuit` | `INT` | `PK, AUTOINCREMENT` | Identifiant du circuit |
| `nom_circuit` | `VARCHAR(255)` | `NOT NULL` | Nom du circuit |
| `nom_officiel` | `VARCHAR(255)` | `NOT NULL` | Nom officiel circuit |
| `id_pays` | `VARCHAR(2)` | `NOT NULL` | Nom du pays |
| `url_img_circuit` | `TEXT` | `NOT NULL` | URL du visuel / tracé du circuit |