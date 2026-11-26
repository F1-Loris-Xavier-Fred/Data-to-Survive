-- Schéma relationnel — Snowflake
-- Périmètre : 1997–2026, 5 circuits (Monza, Monaco, Spa-Francorchamps, Silverstone, Suzuka)

CREATE TABLE IF NOT EXISTS "pays" (
    "id_pays" INT AUTOINCREMENT,
    "nom_pays" VARCHAR(255) NOT NULL,
    "url_drapeau" TEXT NOT NULL,
    PRIMARY KEY ("id_pays")
);

CREATE TABLE IF NOT EXISTS "circuits" (
    "id_circuit" INT AUTOINCREMENT,
    "nom_circuit" VARCHAR(255) NOT NULL,
    "id_pays" INT NOT NULL,
    "url_img_circuit" TEXT NOT NULL,
    PRIMARY KEY ("id_circuit"),
    CONSTRAINT "fk_circuits_pays" FOREIGN KEY ("id_pays") REFERENCES "pays" ("id_pays")
);

CREATE TABLE IF NOT EXISTS "pilotes" (
    "id_pilote" INT AUTOINCREMENT,
    "nom_pilote" VARCHAR(255) NOT NULL,
    "prenom_pilote" VARCHAR(255) NOT NULL,
    "id_pays" INT NOT NULL,
    "url_img_casque" TEXT NOT NULL,
    PRIMARY KEY ("id_pilote"),
    CONSTRAINT "fk_pilotes_pays" FOREIGN KEY ("id_pays") REFERENCES "pays" ("id_pays")
);

CREATE TABLE IF NOT EXISTS "ecuries" (
    "id_ecurie" INT AUTOINCREMENT,
    "id_pays" INT NOT NULL,
    "nom_ecurie" VARCHAR(255) NOT NULL,
    "code_couleur" VARCHAR(10) NOT NULL,
    "url_logo" TEXT NOT NULL,
    PRIMARY KEY ("id_ecurie"),
    CONSTRAINT "fk_ecuries_pays" FOREIGN KEY ("id_pays") REFERENCES "pays" ("id_pays")
);

CREATE TABLE IF NOT EXISTS "reglementations" (
    "id_reglementation" INT AUTOINCREMENT,
    "nom_ere" VARCHAR(255) NOT NULL,
    "caracteristiques" VARCHAR(255) NOT NULL,
    "annee_deb_regle" INT NOT NULL,
    "annee_fin_regle" INT,
    PRIMARY KEY ("id_reglementation")
);

CREATE TABLE IF NOT EXISTS "saisons" (
    "id_saison" INT NOT NULL,
    "id_reglementation" INT NOT NULL,
    PRIMARY KEY ("id_saison"),
    CONSTRAINT "fk_saisons_reglementations" FOREIGN KEY ("id_reglementation") REFERENCES "reglementations" ("id_reglementation")
);

CREATE TABLE IF NOT EXISTS "grand_prix" (
    "id_grand_prix" INT AUTOINCREMENT,
    "id_saison" INT NOT NULL,
    "id_circuit" INT NOT NULL,
    "nom_grand_prix" VARCHAR(255) NOT NULL,
    "date_grand_prix" DATE NOT NULL,
    PRIMARY KEY ("id_grand_prix"),
    CONSTRAINT "fk_grand_prix_saisons" FOREIGN KEY ("id_saison") REFERENCES "saisons" ("id_saison"),
    CONSTRAINT "fk_grand_prix_circuits" FOREIGN KEY ("id_circuit") REFERENCES "circuits" ("id_circuit")
);

CREATE TABLE IF NOT EXISTS "statuts" (
    "id_statut" INT AUTOINCREMENT,
    "libelle_statut" VARCHAR(255) NOT NULL,
    PRIMARY KEY ("id_statut")
);

CREATE TABLE IF NOT EXISTS "resultats_laps" (
    "id_grand_prix" INT NOT NULL,
    "id_pilote" INT NOT NULL,
    "id_lap" INT NOT NULL,
    "id_ecurie" INT NOT NULL,
    "id_statut" INT NOT NULL,
    "lap_time" TIME,
    "lap_avg_speed" FLOAT,
    PRIMARY KEY ("id_grand_prix", "id_pilote", "id_lap"),
    CONSTRAINT "fk_resultats_laps_grand_prix" FOREIGN KEY ("id_grand_prix") REFERENCES "grand_prix" ("id_grand_prix"),
    CONSTRAINT "fk_resultats_laps_pilotes" FOREIGN KEY ("id_pilote") REFERENCES "pilotes" ("id_pilote"),
    CONSTRAINT "fk_resultats_laps_ecuries" FOREIGN KEY ("id_ecurie") REFERENCES "ecuries" ("id_ecurie"),
    CONSTRAINT "fk_resultats_laps_statuts" FOREIGN KEY ("id_statut") REFERENCES "statuts" ("id_statut")
);

CREATE TABLE IF NOT EXISTS "users" (
    "id_user" INT AUTOINCREMENT,
    "nom_user" VARCHAR(255) NOT NULL,
    "mdp_user" VARCHAR(255) NOT NULL,
    "role" VARCHAR(255) NOT NULL,
    PRIMARY KEY ("id_user")
);