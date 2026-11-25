CREATE TABLE IF NOT EXISTS "pays" (
	"id_pays" serial NOT NULL,
	"nom_pays" varchar(255) NOT NULL,
	"url_drapeau" text(65535) NOT NULL,
	PRIMARY KEY("id_pays")
);

CREATE TABLE IF NOT EXISTS "circuits" (
	"id_circuit" serial NOT NULL,
	"nom_circuit" varchar(255) NOT NULL,
	"id_pays" int NOT NULL,
	"url_img_circuit" text(65535) NOT NULL,
	PRIMARY KEY("id_circuit")
);

CREATE TABLE IF NOT EXISTS "pilotes" (
	"id_pilote" serial NOT NULL,
	"nom_pilote" varchar(255) NOT NULL,
	"prenom_pilote" varchar(255) NOT NULL,
	"id_pays" int NOT NULL,
	"url_img_casque" text(65535) NOT NULL,
	PRIMARY KEY("id_pilote")
);

CREATE TABLE IF NOT EXISTS "ecuries" (
	"id_ecurie" serial NOT NULL,
	"id_pays" int NOT NULL,
	"nom_ecurie" varchar(255) NOT NULL,
	"code_couleur" int NOT NULL,
	"url_logo" text(65535) NOT NULL,
	PRIMARY KEY("id_ecurie")
);

CREATE TABLE IF NOT EXISTS "saisons" (
	"id_saison" serial NOT NULL,
	"id_reglementation" int NOT NULL,
	PRIMARY KEY("id_saison")
);

CREATE TABLE IF NOT EXISTS "reglementations" (
	"id_reglementation" serial NOT NULL,
	"nom_ere" varchar(255) NOT NULL,
	"caracteristiques" varchar(255) NOT NULL,
	"annee_deb_regle" int NOT NULL,
	"annee_fin_regle" int,
	PRIMARY KEY("id_reglementation")
);

CREATE TABLE IF NOT EXISTS "grand_prix" (
	"id_grand_prix" serial NOT NULL,
	"id_saison" int NOT NULL,
	"id_circuit" int NOT NULL,
	"nom_grand_prix" varchar(255) NOT NULL,
	"date_grand_prix" date NOT NULL,
	PRIMARY KEY("id_grand_prix")
);

CREATE TABLE IF NOT EXISTS "resultats_laps" (
	"id_grand_prix" serial NOT NULL,
	"id_pilote" int NOT NULL,
	"id_lap" int NOT NULL,
	"id_ecurie" int NOT NULL,
	"id_statut" int NOT NULL,
	"lap_time" time,
	"lap_top_speed" float,
	"lap_avg_speed" float,
	PRIMARY KEY("id_grand_prix", "id_pilote", "id_lap")
);

CREATE TABLE IF NOT EXISTS "statuts" (
	"id_statut" serial NOT NULL,
	"libelle_statut" varchar(255) NOT NULL,
	PRIMARY KEY("id_statut")
);

CREATE TABLE IF NOT EXISTS "users" (
	"id_user" serial NOT NULL,
	"nom_user" varchar(255) NOT NULL,
	"mdp_user" varchar(255) NOT NULL,
	"role" varchar(255) NOT NULL,
	PRIMARY KEY("id_user")
);

ALTER TABLE "statuts"
ADD FOREIGN KEY("id_statut") REFERENCES "resultats_laps"("id_statut")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "pays"
ADD FOREIGN KEY("id_pays") REFERENCES "pilotes"("id_pays")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "pays"
ADD FOREIGN KEY("id_pays") REFERENCES "ecuries"("id_pays")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "circuits"
ADD FOREIGN KEY("id_pays") REFERENCES "pays"("id_pays")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "reglementations"
ADD FOREIGN KEY("id_reglementation") REFERENCES "saisons"("id_reglementation")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "saisons"
ADD FOREIGN KEY("id_saison") REFERENCES "grand_prix"("id_saison")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "grand_prix"
ADD FOREIGN KEY("id_grand_prix") REFERENCES "resultats_laps"("id_grand_prix")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "circuits"
ADD FOREIGN KEY("id_circuit") REFERENCES "grand_prix"("id_circuit")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "ecuries"
ADD FOREIGN KEY("id_ecurie") REFERENCES "resultats_laps"("id_ecurie")
ON UPDATE NO ACTION ON DELETE NO ACTION;
ALTER TABLE "pilotes"
ADD FOREIGN KEY("id_pilote") REFERENCES "resultats_laps"("id_pilote")
ON UPDATE NO ACTION ON DELETE NO ACTION;