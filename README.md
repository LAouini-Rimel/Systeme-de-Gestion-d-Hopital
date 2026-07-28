Projet:Systeme de gestion d'un hopital(PLSQL)
📌Description:
Ce projet consiste à développer un système de gestion d'un hôpital en utilisant **Oracle Database et PL/SQL.
L'objectif est de concevoir une base de données permettant de gérer les différentes opérations d'un hôpital comme les patients, les médecins, les rendez-vous,
services,hospitalisations,prescriptions et les lignes de prescriptions.


Le projet met en pratique :
- La modélisation d'une base de données relationnelle
- La création des tables et des contraintes
- L'utilisation du langage SQL
- La programmation en PL/SQL (procédures, fonctions, triggers, curseurs...)


🛢️Structure de la base de données:
  👤Patient(idPatient PK, nom, prenom, dateNaissance,adresse, telephone)
  👨‍⚕️Medecin(idMedecin PK, nom, specialite, salaire, idService FK)
  🏥Service(idService PK, nomService, capacite)
  📅RendezVous(idRdv PK, idPatient FK, idMedecin FK, dateRdv, statut)
   Hospitalisation(idHosp PK, idPatient FK, idService FK,dateEntree,dateSortie)
   Medicament(idMed PK, nom, stock, prix)
   Prescription(idPrescPK, idPatient FK, idMedecin FK, datePresc)
   Ligne_Prescription(idPrescFK, idMed FK, quantite, PK(idPresc,idMed))                            NB:(PK : clé primaire ; FK : clé étrangère)


   ⚙️ Fonctionnalités réalisées:
              🛠️Ajout des medecins
              🛠️Ajout des medicaments
              🛠️Ajout des patients
              🛠️Ajout des rendez vous
              🛠️modification des données de rendezvous,patients,medicaments et medecins
              🛠️Suppression des medecins,medicaments,patients et rendez vous
              🛠️Affichage des données
              🛠️les fonctions stockées pour realiser differentes taches(cout prescription,nombre de patients par service...)
              🛠️les procedures stockées
              🛠️les triggers stockés pour assurer la cohérence de la base(disponibilité des medecins....)
              🛠️Curseurs:Utilisés pour parcourir et traiter plusieurs lignes de données.

              
  📂 Organisation du projet:
           Gestion-Hopital-PLSQL/
              │
              ├── tables.sql
              │   Création des tables et des contraintes de la base de données.
              │
              ├── package_hopital.sql
              │   Contient les packages PL/SQL (spécification et corps) regroupant les procédures et fonctions du système.
              │
              ├── triggers.sql
              │   Définition des triggers permettant d'automatiser certaines opérations et de garantir l'intégrité des données.
              │
              ├── test.sql
              │   Jeu de tests permettant de vérifier le bon fonctionnement des procédures, fonctions et triggers.
              │
              └── README.md
                  Documentation du projet : présentation, fonctionnalités, structure
👥 Auteur:LAouini Rimel
               💼 LinkedIn :https://www.linkedin.com/in/l-aouini-rimel-39aa09422/
               📧laouinirimel04@gmail.com
voici le lien du pdf du test:./Test.pdf
