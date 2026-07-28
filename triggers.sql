--trigger pour supprimer les rendez vous,les prescriptions de ce medecin qu'on veut supprimer de la base
create or replace trigger supprimer_medecin
before delete on Medecin
for each row
declare
cursor cur is select idPresc from Prescription where idMedecin=:old.idMedecin;
BEGIN
delete from RendezVous where idMedecin=:old.idMedecin;
for rec in cur loop
delete from Ligne_Prescription where idPresc=rec.idPresc;
end loop;
delete from Prescription where idMedecin=:old.idMedecin;
end;
/

create or replace trigger supprimer_medicament
before delete on Medicament
for each row
BEGIN
delete from Ligne_Prescription where idMed=:old.idMed;
end;
/

create or replace trigger supprimer_patient
before delete on Patient
for each row 
declare 
cursor cur is select idPresc from Prescription where idPatient=:old.idPatient;
BEGIN
delete from RendezVous where idPatient=:old.idPatient;
delete from Hospitalisation where idPatient=:old.idPatient;
for rec in cur loop
delete from Ligne_Prescription where idPresc=rec.idPresc;
end loop; 
delete from Prescription where idPatient=:old.idPatient;
end;
/

--Trigger BEFORE INSERT sur la table RENDEZVOUS
create or replace trigger verif_before_insert_rdv
before insert on RendezVous
for each row
declare
v number;
begin
select count(*) into v from RendezVous where idMedecin=:new.idMedecin and dateRdv=:new.dateRdv;
if v>0 then
raise_application_error(-20000,'medecin non dispo a cette date  ou il y a double reservation pour un meme medecin!');
end if;
end;
/
--Trigger AFTER UPDATE sur la table PRESCRIPTION
create or replace trigger mise_a_jour_stock
after update on PRESCRIPTION
for each row
declare
cursor cur is select idMed,quantite from Ligne_Prescription where idPresc=:New.idPresc;
stck Medicament.stock%type;
begin
for rec in cur loop
select stock into stck from Medicament where idMed=rec.idMed;
if rec.quantite>stck then
raise_application_error(-20000,'Erreur:Qte prescrite > au stock');
end if;
update Medicament set stock=stock-rec.quantite where idMed=rec.idMed;
end loop;
end;
/
--Trigger DDL
--Trigger 1
create or replace trigger info_event
after create or alter or drop ON SCHEMA
begin
    dbms_output.put_line('Operation DDL : ' || ORA_SYSEVENT ||' | Objet concerne : ' || ORA_DICT_OBJ_NAME);
end;
/
--Trigger 2
create or replace trigger logon_notification
after logon on Database
begin
dbms_output.put_line('Bienvenue!connexion détecté pour l utilisateur  '|| USER);
end;
/

CREATE OR REPLACE TRIGGER trg_rdv_double
before insert or update on  RendezVous
for each row
declare
    v_count NUMBER;
BEGIN
    select COUNT(*) into v_count from RendezVous where idMedecin = :NEW.idMedecin AND dateRdv = :NEW.dateRdv AND (:NEW.idRdv IS NULL OR idRdv <> :NEW.idRdv);
    if v_count > 0 then
        RAISE_APPLICATION_ERROR(-20011,'Rendez-vous déjà existant pour ce médecin à cette date/heure');
    end if;
end trg_rdv_double;
/

create or replace trigger trg_capacite_service
before insert or update on hospitalisation
for each row
declare
v_nb  number;
v_cap number;
begin
select count(*) into v_nb from hospitalisation where idservice = :new.idservice;
select capacite into v_cap from service where idservice = :new.idservice;
if v_nb >= v_cap then
    raise_application_error(-20012,'capacité du service dépassée');
end if;
end trg_capacite_service;
/
create or replace trigger trg_stock_medicament
before insert or update on ligne_prescription
for each row
declare
v_stock medicament.stock%type;
begin
select stock into v_stock from medicament where idmed = :new.idmed;
if v_stock < :new.quantite then
    raise_application_error(-20020,'stock insuffisant pour ce médicament');
end if;
end;
/
create or replace trigger trg_double_hospitalisation
before insert or update on hospitalisation
for each row
declare
v_count number;
begin
select count(*) into v_count from hospitalisation where idpatient = :new.idpatient and (:new.dateentree <= nvl(datesortie, to_date('9999-12-31','yyyy-mm-dd')) and :new.datesortie >= dateentree) and (idhosp <> :new.idhosp or :new.idhosp is null);
if v_count > 0 then
    raise_application_error(-20014,'patient déjà hospitalisé sur cette période');
end if;
end;
/
