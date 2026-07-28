--package specification
create or replace package pkg_hopital is 
procedure ajouter_medecin(med IN Medecin.idMedecin%type ,nom IN Medecin.nom%type,specialite IN Medecin.specialite%type,salaire IN Medecin.salaire%type,service IN Medecin.idService%type) ;
procedure ajouter_medicament(med IN Medicament.idMed%type,nom IN Medicament.nom%type,stock IN Medicament.stock%type,prix IN Medicament.prix%type);
procedure ajouter_patient(id in Patient.idPatient%type,nom IN Patient.nom%type ,prenom IN Patient.prenom%type ,dateNaissance IN Patient.dateNaissance%type , adresse IN Patient.adresse%type ,telephone IN Patient.telephone%type );
procedure ajouter_rdv(rdv IN RendezVous.idRdv%type,pt IN RendezVous.idPatient%type,med IN RendezVous.idMedecin%type,daterdv IN RendezVous.dateRdv%type,statut IN RendezVous.statut%type);
procedure modifier_rdv(p_idRdv IN RendezVous.idRdv%type,p_idp in RendezVous.idPatient%type,p_idmed in RendezVous.idMedecin%type,p_dateRdv IN RendezVous.dateRdv%type,p_statut IN RendezVous.statut%type);
procedure modifier_patient(id_p IN Patient.idPatient%type,adresse_p IN Patient.adresse%type ,telephone_p IN Patient.telephone%type);
procedure modifier_medicament(med IN Medicament.idMed%type,m_stock IN Medicament.stock%type,m_prix IN Medicament.prix%type);
PROCEDURE modifier_medecin(p_med IN Medecin.idMedecin%type,p_specialite IN Medecin.specialite%type,p_salaire IN Medecin.salaire%type,p_service IN Medecin.idService%type);
PROCEDURE supprimer_patient(p_idPatient IN Patient.idPatient%TYPE);
PROCEDURE supprimer_rdv(p_idRdv IN RendezVous.idRdv%TYPE);
PROCEDURE supprimer_medicament(p_idMed IN Medicament.idMed%TYPE);
PROCEDURE supprimer_medecin(p_idMed IN Medecin.idMedecin%TYPE);
procedure afficher_medecin(id_med IN Medecin.idMedecin%type);
procedure afficher_medicament(medic IN Medicament.idMed%type);
PROCEDURE afficher_Patient(id_pt IN Patient.idPatient%type);
procedure afficher_rdv (rdv IN RendezVous.idRdv%type);
function cout_prescription(p_idPresc IN Prescription.idPresc%TYPE) return Number;
function nb_patients_service(p_idService IN Service.idService%type) return number;
function total_medicaments_patient(p_idPatient IN Patient.idPatient%type) return number;
PROCEDURE prescrire_medicament(p_idpresc   IN prescription.idpresc%TYPE,p_idpatient IN patient.idpatient%TYPE,p_idmedecin IN medecin.idmedecin%TYPE,p_idmed IN medicament.idmed%TYPE,p_quantite   IN NUMBER);
procedure afficher_rdv_medecin(p_idMedecin IN Medecin.idMedecin%type);
procedure liste_hospitalisations;
procedure medicament_rupture;
end;
/
--package body
create or replace package body pkg_hopital is
--procedure d'ajout
procedure ajouter_medecin(med IN Medecin.idMedecin%type ,nom IN Medecin.nom%type,specialite IN Medecin.specialite%type,salaire IN Medecin.salaire%type,service IN Medecin.idService%type) 
IS 
ex_prk_existant exception;
pragma exception_init(ex_prk_existant,-1);--pour garantir l'unicité de la cle primaire!
ex_fk_inexistant exception;
pragma exception_init(ex_fk_inexistant,-2291);
salaire_invalide exception;
champ_notnull exception;
begin
if salaire <= 0 then
    raise salaire_invalide;
end if;
if nom IS NULL then
    raise champ_notnull;
end if;
if specialite IS NULL then
    raise champ_notnull;
end if;
insert into Medecin values(med,nom,specialite,salaire,service);
dbms_output.put_line('Medecin ajoute avec succes');
exception
when ex_prk_existant then
    dbms_output.put_line('id existe deja');
when ex_fk_inexistant then
    dbms_output.put_line('erreur:cle etrangere n existe pas dans la table Service');
when salaire_invalide then
    dbms_output.put_line('erreur:salaire invalide');
when champ_notnull then
    dbms_output.put_line('erreur:il y a des champs null!');    
end ajouter_medecin;

procedure ajouter_medicament(med IN Medicament.idMed%type,nom IN Medicament.nom%type,stock IN Medicament.stock%type,prix IN Medicament.prix%type)
is 
ex_prk_existant exception;
pragma exception_init(ex_prk_existant,-1);
champ_notnull exception;
ex_stock_invalide exception;
prix_invalide exception;
begin
if nom IS NULL then
    raise champ_notnull;
end if;
if stock < 0 then
    raise ex_stock_invalide;
end if;
if prix <= 0 then
    raise prix_invalide;
end if;
insert into Medicament values (med,nom,stock,prix);
dbms_output.put_line('MEdicament ajoute avec succes');
exception
when ex_prk_existant then
   dbms_output.put_line('Erreur medicament existe deja');
when champ_notnull then
   dbms_output.put_line('Erreur: le nom est obligatoire');
when ex_stock_invalide then
   dbms_output.put_line('Erreur:Stock invalide');
when prix_invalide then
   dbms_output.put_line('Erreur :le prix est invalide');      
end ajouter_medicament;
procedure ajouter_patient(id in Patient.idPatient%type,nom IN Patient.nom%type ,prenom IN Patient.prenom%type ,dateNaissance IN Patient.dateNaissance%type , adresse IN Patient.adresse%type ,telephone IN Patient.telephone%type )
is 
ex_prk_existant Exception;
pragma exception_init(ex_prk_existant,-00001);
dte_naiss exception;
champ_notnull exception;
begin
if nom IS NULL then
    raise champ_notnull;
end if;
if prenom IS NULL then
    raise champ_notnull;
end if;
if telephone IS NULL then
    raise champ_notnull;
end if;
if adresse IS NULL then
    raise champ_notnull;
end if;
if dateNaissance > SYSDATE then
    raise dte_naiss;
end if;
insert into Patient values (id,nom,prenom,dateNaissance,adresse,telephone);
dbms_output.put_line('Patient ajoute avec succes');
Exception
when ex_prk_existant then
    dbms_output.put_line('Erreur le patient existe deja');
when dte_naiss then
    dbms_output.put_line('la date de naissance est invalide');
when champ_notnull then
    dbms_output.put_line('erreur:il y a des champs null!');         
end ajouter_patient;
procedure ajouter_rdv(rdv IN RendezVous.idRdv%type,pt IN RendezVous.idPatient%type,med IN RendezVous.idMedecin%type,daterdv IN RendezVous.dateRdv%type,statut IN RendezVous.statut%type)
is
ex_prk_existant exception;
pragma exception_init(ex_prk_existant,-00001);
ex_fk_inexistant exception;
pragma exception_init(ex_fk_inexistant,-2291);
ex_rdv_conflit exception;
ex_dterdv Exception;
v number;
begin
if daterdv < SYSDATE then
    raise ex_dterdv;
end if ;
select count(*)into v from RendezVous where idMedecin=med and dateRdv=daterdv;
if v>0 then
    raise ex_rdv_conflit;
end if;
insert into RendezVous values (rdv,pt,med,daterdv,statut);
exception
when ex_prk_existant then
    dbms_output.put_line('Erreur Rendez-vous existe deja');
when ex_fk_inexistant then
    dbms_output.put_line('erreur:cle etrangere violee');
when ex_rdv_conflit then
    dbms_output.put_line('Erreur le meme medecin ne peut pas avoir deux rendezvous a la meme date');
when ex_dterdv then
     dbms_output.put_line('Erreur:la date rdv est dans le passée!impossible');      
end ajouter_rdv;
--procedure de modification
PROCEDURE modifier_medecin(p_med IN Medecin.idMedecin%type,p_specialite IN Medecin.specialite%type,p_salaire IN Medecin.salaire%type,p_service IN Medecin.idService%type
)
IS
cle_pr_inexistant Exception;
ex_fk Exception;
pragma exception_init(ex_fk,-2291);
ex_salaire_invalide Exception;
ex_specialite_invalide Exception;
v number;
begin
if p_salaire <= 0 then
    raise ex_salaire_invalide;
end if;
if p_specialite IS NULL then
    raise ex_specialite_invalide;
end if;
select count(*) into v from Medecin where idMedecin=p_med;
if v=0 then
raise cle_pr_inexistant;
end if;
update Medecin
set
    specialite = p_specialite,
    salaire = p_salaire,
    idService=p_service
where idMedecin = p_med;
dbms_output.put_line('Modification reussie');
exception 
when cle_pr_inexistant then 
    dbms_output.put_line('erreur: le Medecin dont l id fourni n existe pas');
when ex_fk then
    dbms_output.put_line('Erreur: l id service qui fera une cle etrangere n existe pas dans la table Service');
when ex_specialite_invalide then
    dbms_output.put_line('Erreur :specialite invalide');
when ex_salaire_invalide then
    dbms_output.put_line('Erreur :salaire invalide');            
end modifier_medecin;
procedure modifier_medicament(med IN Medicament.idMed%type,m_stock IN Medicament.stock%type,m_prix IN Medicament.prix%type)
is 
cle_pr_inexistant Exception;
ex_stock_insuffisant Exception;
prix_invalide Exception;
v number;
begin
select count(*)into v from Medicament where idMed=med;
if v=0 then
raise cle_pr_inexistant;
end if;
if m_stock < 0 then
    raise ex_stock_insuffisant;
end if;
if m_prix <= 0 then
    raise prix_invalide;
end if;
update Medicament set stock=m_stock,prix=m_prix where idMed=med;
dbms_output.put_line('Modification reussie');
exception
when cle_pr_inexistant then 
dbms_output.put_line('Medicament n existe pas');
when ex_stock_insuffisant then
    dbms_output.put_line('Erreur: le stock introduit est insuffisant');
when prix_invalide then
dbms_output.put_line('Erreur: le prix introduit est <=0');    
end modifier_medicament;
procedure modifier_patient(id_p IN Patient.idPatient%type,adresse_p IN Patient.adresse%type ,telephone_p IN Patient.telephone%type)
is 
cle_pr_inexistant Exception;
ex_champ_notnull Exception;
v number;
begin
if telephone_p IS NULL then
    raise ex_champ_notnull;
end if;
if adresse_p IS NULL then
    raise ex_champ_notnull;
end if;
select count(*) into v from Patient where idPatient=id_p;
if v=0 then
    raise cle_pr_inexistant;
end if;
update Patient set telephone=telephone_p,adresse=adresse_p where idPatient=id_p;
dbms_output.put_line('Patient mis a jour avec succes.');
exception 
when cle_pr_inexistant then 
    dbms_output.put_line('Erreur :le patient dont l id est fourni n existe pas');
when ex_champ_notnull then
    dbms_output.put_line('Erreur: adresse ou telephone invalide');
end modifier_patient;
procedure modifier_rdv(p_idRdv IN RendezVous.idRdv%type,p_idp in RendezVous.idPatient%type,p_idmed in RendezVous.idMedecin%type,p_dateRdv IN RendezVous.dateRdv%type,p_statut IN RendezVous.statut%type)
IS
cle_pr_inexistant Exception;
ex_frkey Exception;
pragma exception_init(ex_frkey,-2291);
ex_rdv_conflit Exception;
v number;
begin
select count(*)into v from RendezVous where idRdv=p_idRdv;
if v=0 then
raise cle_pr_inexistant;
end if;
if p_dateRdv < SYSDATE then
    raise ex_rdv_conflit;
end if;
select count(*)into v from RendezVous where idMedecin=p_idmed and dateRdv=p_dateRdv and idRdv<>p_idRdv;
if v>0 then
    raise ex_rdv_conflit;
end if;
update RendezVous
set idPatient=p_idp,
    idMedecin=p_idmed,
    dateRdv = p_dateRdv,
    statut = p_statut
where idRdv = p_idRdv;
dbms_output.put_line('Modification rendez-vous reussie');
exception
    when cle_pr_inexistant then
        dbms_output.put_line('Erreur: le rdv dont l id est fourni n existe pas dans la table RendezVous');
    when ex_frkey then
        dbms_output.put_line('Erreur:la cle etrangere n existe pas');   
    when ex_rdv_conflit then
        dbms_output.put_line('Erreur:date du rdv est invalide ou conflit du rdv');   
end modifier_rdv;
-- procedure de suppression
PROCEDURE supprimer_medecin(p_idMed IN Medecin.idMedecin%TYPE)
IS
ex_fk_delete Exception;
pragma exception_init(ex_fk_delete,-2292);   
BEGIN
    DELETE FROM Medecin
    WHERE idMedecin = p_idMed;
    if SQL%rowcount=0 then
         DBMS_OUTPUT.PUT_LINE('Medecin introuvable');
    else
        DBMS_OUTPUT.PUT_LINE('Medecin supprime');
    end if;     
Exception
when ex_fk_delete then
   dbms_output.put_line('Erreur(suppression impossible):Medecin lié a d autres tables');
END supprimer_medecin;
PROCEDURE supprimer_medicament(p_idMed IN Medicament.idMed%TYPE)
IS
ex_fk_delete Exception;
pragma exception_init(ex_fk_delete,-2292);   
BEGIN
    DELETE FROM Medicament
    WHERE idMed = p_idMed;
    if SQL%rowcount=0 then
       DBMS_OUTPUT.PUT_LINE('Medicament introuvable');
    else
       DBMS_OUTPUT.PUT_LINE('Medicament supprimé');
    end if;
Exception       
when ex_fk_delete then
   dbms_output.put_line('Erreur(suppression impossible):Medicament lié a d autres tables');
END supprimer_medicament;
PROCEDURE supprimer_rdv(p_idRdv IN RendezVous.idRdv%TYPE)
IS  
BEGIN
    DELETE FROM RendezVous
    WHERE idRdv = p_idRdv;
    if SQL%rowcount=0 then
        DBMS_OUTPUT.PUT_LINE('RendezVous introuvable');
    else
       DBMS_OUTPUT.PUT_LINE('Rendez-vous supprimé');
    end if;
    commit;
END supprimer_rdv;
PROCEDURE supprimer_patient(p_idPatient IN Patient.idPatient%TYPE)is 
ex_fk_delete Exception;
pragma exception_init(ex_fk_delete,-2292);
BEGIN
    DELETE FROM Patient
    WHERE idPatient = p_idPatient;
    if SQL%rowcount=0 then
        dbms_output.put_line('patient introuvable');
    else    
        DBMS_OUTPUT.PUT_LINE('Patient supprimé');
    end if;    
Exception 
when ex_fk_delete then
   dbms_output.put_line('Erreur(suppression impossible):Patient lié a d autres tables');
END supprimer_patient;

-- procedure d'affichage
procedure afficher_medecin(id_med IN Medecin.idMedecin%type)
IS
v_med Medecin%rowtype;
srv Service.nomService%type;

v_id        Medecin.idMedecin%type;
v_nom       Medecin.nom%type;
v_spec      Medecin.specialite%type;
v_sal       Medecin.salaire%type;
v_service   Medecin.idService%type;
begin
select m.idMedecin,m.nom,m.specialite,m.salaire,m.idService,s.nomService into   v_id,v_nom,v_spec,v_sal,v_service,srv
from Medecin m
join Service s 
on m.idService = s.idService
where m.idMedecin = id_med;
v_med.idMedecin := v_id;
v_med.nom := v_nom;
v_med.specialite := v_spec;
v_med.salaire := v_sal;
v_med.idService := v_service;

dbms_output.put_line(
'ID : ' || v_med.idMedecin ||
' Nom : ' || v_med.nom ||
' Specialité: ' || v_med.specialite ||
' Salaire: ' || v_med.salaire ||
' Service: ' || srv
);
exception 
when NO_DATA_FOUND then 
    dbms_output.put_line('Erreur medecin n existe pas');
-- pour la securite    
when too_many_rows then
    dbms_output.put_line('Erreur : doublon de Medecin (problème clé primaire)');      
end afficher_medecin; 
procedure afficher_medicament(medic in Medicament.idMed%type)
IS
v_medic Medicament%rowtype;
begin
select * into v_medic from Medicament where idMed=medic;
dbms_output.put_line('ID: '||v_medic.idMed||' Nom: '||v_medic.nom||' Stock: '||v_medic.stock||' Prix: '||v_medic.prix);
exception 
when NO_DATA_FOUND then 
dbms_output.put_line('Erreur medicament n existe pas');
when TOO_MANY_ROWS then
dbms_output.put_line('Erreur : doublon medicament');
end afficher_medicament; 
PROCEDURE afficher_Patient(id_pt IN Patient.idPatient%type)
IS
v_pt Patient%rowtype;
begin
select * into v_pt from Patient where idPatient=id_pt;
dbms_output.put_line('Patient: ');
dbms_output.put_line('ID : ' || v_pt.idPatient||' Nom : ' || v_pt.nom||' Prenom : ' || v_pt.prenom||' Date Naissance : ' || v_pt.dateNaissance||' Adresse : ' || v_pt.adresse||' Telephone : ' || v_pt.telephone);
exception 
when NO_DATA_FOUND then dbms_output.put_line('Erreur patient n existe pas');
--pour la securite
when TOO_MANY_ROWS then
    dbms_output.put_line('Erreur : doublon de patient (problème clé primaire)');
end afficher_Patient; 
procedure afficher_rdv (rdv IN RendezVous.idRdv%type)
IS
v_rdv RendezVous%rowtype;
begin
select * into v_rdv from RendezVous where idRdv=rdv;
dbms_output.put_line('ID: '||v_rdv.idRdv);
afficher_Patient(v_rdv.idPatient);
afficher_medecin(v_rdv.idMedecin);
dbms_output.put_line('Date rendez-vous:'||v_rdv.dateRdv||' Statut: '||v_rdv.statut);
exception 
when NO_DATA_FOUND then 
dbms_output.put_line('Erreur Rendez-vous n existe pas');
end afficher_rdv; 
--fonctions
function cout_prescription(p_idPresc IN Prescription.idPresc%TYPE)
return number
IS
s number := 0;
BEGIN
select NVL(SUM(lp.quantite * m.prix),0) into s FROM Ligne_Prescription lp JOIN Medicament m ON lp.idMed = m.idMed
WHERE lp.idPresc = p_idPresc;
RETURN s;
EXCEPTION
when NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('Aucune hospitalisation pour ce service.');
    return 0;
when TOO_MANY_ROWS then
    DBMS_OUTPUT.PUT_LINE('Erreur : plusieurs lignes trouvées (anormal pour COUNT).');
    return -1;
when OTHERS then
    DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    return -1;
END cout_prescription;
function nb_patients_service(p_idService IN Service.idService%type)
return number IS
nb_p number;
begin
select count(idPatient) into nb_p from Hospitalisation where idService=p_idService;
return nb_p;
exception
when NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('Aucune hospitalisation pour ce service.');
    return 0;
when TOO_MANY_ROWS then
    DBMS_OUTPUT.PUT_LINE('Erreur : plusieurs lignes trouvées (anormal pour COUNT).');
    return -1;
when OTHERS then
    DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
    return -1;
end nb_patients_service;
function total_medicaments_patient(p_idPatient IN Patient.idPatient%type)
return number
IS
nb_qt number:=0;
s number:=0;
cursor cur_pt is select idPresc from Prescription where idPatient=p_idPatient;
begin
for row in cur_pt loop
select NVL(SUM(quantite),0) into nb_qt from Ligne_Prescription where idPresc=row.idPresc;
s:=s+nb_qt;
end loop;
return s;
exception 
when NO_DATA_FOUND then 
dbms_output.put_line('Patient inexistant');
return 0;
when TOO_MANY_ROWS then
return -1;
when OTHERS then
DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
return -1;
end total_medicaments_patient;
--metier complexe
PROCEDURE prescrire_medicament(p_idpresc IN prescription.idpresc%TYPE,p_idpatient IN patient.idpatient%TYPE,p_idmedecin IN medecin.idmedecin%TYPE,p_idmed Medicament.idmed%type,p_quantite IN NUMBER)
IS
v_stock NUMBER;
v_count NUMBER;
BEGIN
SELECT COUNT(*) INTO v_count FROM patient WHERE idpatient = p_idpatient;
IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'patient inexistant');
END IF;
SELECT COUNT(*) INTO v_count FROM medecin WHERE idmedecin = p_idmedecin;
IF v_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'médecin inexistant');
END IF;
SELECT stock INTO v_stock FROM medicament WHERE idmed = p_idmed;
IF v_stock < p_quantite THEN
    RAISE_APPLICATION_ERROR(-20003, 'stock insuffisant');
END IF;
INSERT INTO prescription(idpresc, idpatient, idmedecin, datepresc) VALUES (p_idpresc, p_idpatient, p_idmedecin, SYSDATE);
INSERT INTO ligne_prescription(idpresc, idmed, quantite) VALUES (p_idpresc, p_idmed, p_quantite);
UPDATE medicament SET stock = stock - p_quantite WHERE idmed = p_idmed;
COMMIT;
DBMS_OUTPUT.PUT_LINE('Prescription effectuée avec succès');
EXCEPTION
WHEN NO_DATA_FOUND THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erreur : médicament introuvable');
WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END prescrire_medicament;
procedure afficher_rdv_medecin(p_idMedecin IN Medecin.idMedecin%type)is
CURSOR cur IS SELECT r.dateRdv,p.nom,r.statut FROM RendezVous r JOIN Patient p ON r.idPatient = p.idPatient
WHERE r.idMedecin = p_idMedecin;

v number :=0;
rdv_inexistant exception;
begin
for rec in cur loop
    v := v + 1;
    dbms_output.put_line('----------------------');
    dbms_output.put_line('Date RDV : ' || rec.dateRdv);
    dbms_output.put_line('Patient  : ' || rec.nom);
    dbms_output.put_line('Statut   : ' || rec.statut);
END LOOP;
if v=0 then
    raise rdv_inexistant;
end if;
exception
when rdv_inexistant then
    dbms_output.put_line('Aucun Rendez Vous n est trouvé pour le medecin spécifié!');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);        
End afficher_rdv_medecin;
procedure liste_hospitalisations is
cursor cur is select p.nom,s.nomService,(h.dateSortie-h.dateEntree) as dureesej from Hospitalisation h join Patient p
on h.idPatient=p.idPatient join Service s on s.idService=h.idService;
cpte number :=0;
hospitalisations_inexistantes exception;
begin
for rec in cur loop
   cpte:=cpte+1;
   DBMS_OUTPUT.PUT_LINE('------------------------------');
   dbms_output.put_line('Le nom du patient: '|| rec.nom || ' Le nom du service: '|| rec.nomService || ' La durée du séjour: '|| rec.dureesej ||' jours');
end loop;
if cpte=0 then
   raise hospitalisations_inexistantes;
end if;
exception
when hospitalisations_inexistantes then
dbms_output.put_line('Aucune hospitalisation n est trouvée!');
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
end liste_hospitalisations;
procedure medicament_rupture
is
type tab is table of Medicament.idMed%type index by binary_integer;
i integer:=1;
T tab;
cursor cur_rupt is select idMed from Medicament where stock=0;
medi_rupture_inexistant exception;
begin
for row in cur_rupt loop
T(i):=row.idMed;
i:=i+1;
end loop;
if T.count=0 then
raise medi_rupture_inexistant;
end if;
i:=T.first;
while i is not NULL loop
dbms_output.put_line('Medicament ID: '||T(i));
i:=T.next(i);
end loop;
exception 
when medi_rupture_inexistant then 
dbms_output.put_line('Aucun medicament est en rupture');
when others then
dbms_output.put_line('erreur!');
end medicament_rupture;
end pkg_hopital;
/