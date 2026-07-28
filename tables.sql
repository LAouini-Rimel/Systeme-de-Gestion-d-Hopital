CREATE TABLE Service (
    idService INTEGER PRIMARY KEY,
    nomService VARCHAR2(100),
    capacite INTEGER
);

CREATE TABLE Medecin (
    idMedecin INTEGER PRIMARY KEY,
    nom VARCHAR2(100),
    specialite VARCHAR2(100),
    salaire NUMBER(10,2),
    idService INTEGER,
    CONSTRAINT fk_medecin_service
        FOREIGN KEY (idService) REFERENCES Service(idService)
);


CREATE TABLE Patient (
    idPatient INTEGER PRIMARY KEY,
    nom VARCHAR2(100),
    prenom VARCHAR2(100),
    dateNaissance DATE,
    adresse VARCHAR2(200),
    telephone VARCHAR2(20)
);

CREATE TABLE RendezVous (
    idRdv INTEGER PRIMARY KEY,
    idPatient INTEGER,
    idMedecin INTEGER,
    dateRdv DATE,
    statut VARCHAR2(50),
    CONSTRAINT fk_rdv_patient
        FOREIGN KEY (idPatient) REFERENCES Patient(idPatient),
    CONSTRAINT fk_rdv_medecin
        FOREIGN KEY (idMedecin) REFERENCES Medecin(idMedecin)
);

CREATE TABLE Hospitalisation (
    idHosp INTEGER PRIMARY KEY,
    idPatient INTEGER,
    idService INTEGER,
    dateEntree DATE,
    dateSortie DATE,
    CONSTRAINT fk_hosp_patient
        FOREIGN KEY (idPatient) REFERENCES Patient(idPatient),
    CONSTRAINT fk_hosp_service
        FOREIGN KEY (idService) REFERENCES Service(idService)
);

CREATE TABLE Medicament (
    idMed INTEGER PRIMARY KEY,
    nom VARCHAR2(100),
    stock INTEGER,
    prix NUMBER(10,2)
);

CREATE TABLE Prescription (
    idPresc INTEGER PRIMARY KEY,
    idPatient INTEGER,
    idMedecin INTEGER,
    datePresc DATE,
    CONSTRAINT fk_presc_patient
        FOREIGN KEY (idPatient) REFERENCES Patient(idPatient),
    CONSTRAINT fk_presc_medecin
        FOREIGN KEY (idMedecin) REFERENCES Medecin(idMedecin)
);

CREATE TABLE Ligne_Prescription (
    idPresc INTEGER,
    idMed INTEGER,
    quantite INTEGER,
    PRIMARY KEY (idPresc, idMed),
    CONSTRAINT fk_lp_presc
        FOREIGN KEY (idPresc) REFERENCES Prescription(idPresc),
    CONSTRAINT fk_lp_med
        FOREIGN KEY (idMed) REFERENCES Medicament(idMed)
);