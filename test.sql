SET SERVEROUTPUT ON;
-- Services
INSERT INTO Service VALUES (1,'Cardiologie',2);
INSERT INTO Service VALUES (2,'Pediatrie',3);
-- Patients
INSERT INTO Patient VALUES (1,'Ali','Marzouk',
TO_DATE('12-05-2000','DD-MM-YYYY'),
'Tunis','12345678');
INSERT INTO Patient VALUES (2,'Ahmed','hassen',
TO_DATE('01-01-1998','DD-MM-YYYY'),
'Ariana','87654321');
INSERT INTO Patient VALUES (3,'Amin','yahyeoui',
TO_DATE('05-07-1998','DD-MM-YYYY'),
'Ariana','87654341');
-- Médecins
INSERT INTO Medecin VALUES (1,'Dr Karim',
'Cardiologue',3000,1);
INSERT INTO Medecin VALUES (2,'Dr Lina',
'Pediatre',2800,2);
-- Médicaments
INSERT INTO Medicament VALUES (1,'Paracetamol',50,2.5);
INSERT INTO Medicament VALUES (2,'Ibuprofene',0,3.0);
COMMIT;


--Test ajout patient
BEGIN
pkg_hopital.ajouter_patient(
3,'Hedi','Mourad',
TO_DATE('15-03-2001','DD-MM-YYYY'),
'Sousse','99999999');
END;
/

--Test modification patient
BEGIN
pkg_hopital.modifier_patient(
3,'Monastir','11111111');
END;
/
--Test suppression patient
BEGIN
pkg_hopital.supprimer_patient(3);
END;
/
--on a implementé Trigger de suppression en cascade
--Test afficher patient
BEGIN
pkg_hopital.afficher_patient(1);
END;
/

--Test curseur paramétré
INSERT INTO RendezVous
VALUES (1,1,1,SYSDATE,'Planifie');

INSERT INTO RendezVous
VALUES (2,2,1,SYSDATE+1,'Planifie');

COMMIT;
BEGIN
pkg_hopital.afficher_rdv_medecin(1);
END;
/
--test fonction nb_patients_service
INSERT INTO Hospitalisation
VALUES (1,1,1,SYSDATE-2,SYSDATE);
INSERT INTO Hospitalisation
VALUES (2,2,1,SYSDATE-3,SYSDATE);
COMMIT;

DECLARE
v_nb NUMBER;
BEGIN
v_nb := pkg_hopital.nb_patients_service(1);
DBMS_OUTPUT.PUT_LINE('Nombre patients : ' || v_nb);
END;
/
--total_medicament_patient et trigger stock_medicament
-- Prescription
INSERT INTO Prescription
VALUES (1,1,1,SYSDATE);
INSERT INTO Ligne_Prescription
VALUES (1,1,5);
INSERT INTO Ligne_Prescription
VALUES (1,2,1);
COMMIT;
DECLARE
v_total NUMBER;
BEGIN
v_total :=pkg_hopital.total_medicaments_patient(1);
DBMS_OUTPUT.PUT_LINE('Total medicaments : ' || v_total);
END;
/
--cout_prescription
DECLARE
v_cout NUMBER;
BEGIN
v_cout :=pkg_hopital.cout_prescription(1);
DBMS_OUTPUT.PUT_LINE('Cout prescription : ' || v_cout);
END;
/
--test liste_hospitalisations
BEGIN
pkg_hopital.liste_hospitalisations;
END;
/
--medicaments_rupture
BEGIN
pkg_hopital.medicament_rupture;
END;
/
--Tests Exceptions
--stock insuffisant
BEGIN
pkg_hopital.prescrire_medicament(2,1,1,2,10);
END;
/
--conflit rendez-vous
-- Rendez-vous existant
INSERT INTO RendezVous
VALUES (10,1,1,TO_DATE('20-05-2026 10:00','DD-MM-YYYY HH24:MI'),'Planifie');

-- Conflit
INSERT INTO RendezVous
VALUES (11,2,1,TO_DATE('20-05-2026 10:00','DD-MM-YYYY HH24:MI'),'Planifie');
--capacité service dépassée
INSERT INTO Hospitalisation
VALUES (2,2,1,SYSDATE,SYSDATE+2);

INSERT INTO Hospitalisation
VALUES (3,1,1,SYSDATE,SYSDATE+3);
insert into Hospitalisation values(4,3,1,sysdate,sysdate+4);

--Test Procédure métier
--prescrire medicament
BEGIN
pkg_hopital.prescrire_medicament(2, 1, 1, 1,3 );
END;
/
--Trigger BEFORE INSERT RENDEZVOUS
INSERT INTO RendezVous
VALUES (20,1,1,SYSDATE,'Planifie');
INSERT INTO RendezVous VALUES (12,2,1,SYSDATE,'Planifié');
--trigger AFTER UPDATE PRESCRIPTION
-- Cas de test pour déclencher le trigger AFTER UPDATE
BEGIN
UPDATE Prescription
SET datePresc = SYSDATE
WHERE idPresc = 1;
COMMIT;
END;
/
--Trigger DDL
CREATE TABLE TestDDL(
id NUMBER
);
--test no data found
BEGIN
pkg_hopital.afficher_patient(999);
END;
/





