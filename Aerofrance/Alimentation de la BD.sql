---------------------------- Vérification---------------------------------------

DROP TABLE COUPON_VOL CASCADE CONSTRAINTS;
DROP TABLE OCCURRENCE_VOL CASCADE CONSTRAINTS;
DROP TABLE VOL CASCADE CONSTRAINTS;
DROP TABLE AEROPORT CASCADE CONSTRAINTS;
DROP TABLE BILLET CASCADE CONSTRAINTS;
DROP TABLE TRAJET CASCADE CONSTRAINTS;
DROP TABLE CONTAINER CASCADE CONSTRAINTS;
DROP TABLE BAGAGE CASCADE CONSTRAINTS;
DROP TABLE CONSTITUER CASCADE CONSTRAINTS;
DROP TABLE AFFECTER CASCADE CONSTRAINTS;

---- Creation des tables-----------

CREATE TABLE COUPON_VOL
( COUPNUM NUMBER(4) NOT NULL ,
OCCNUM NUMBER(4) NOT NULL,
BILLNUM NUMBER(4) NOT NULL,
COUPETAT VARCHAR2(128) NULL,
CONSTRAINT PK_COUPON_VOL PRIMARY KEY (COUPNUM) 

-- Mise en place de contraintes de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE COUPON_VOL
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_COUPON_VOL_OCCURRENCE_VOL
ON COUPON_VOL (OCCNUM ASC);
CREATE INDEX I_FK_COUPON_VOL_BILLET
ON COUPON_VOL (BILLNUM ASC);
-- -----------------------------------------------------------------------------
TABLE : OCCURRENCE_VOL
-- -----------------------------------------------------------------------------
CREATE TABLE OCCURRENCE_VOL
( OCCNUM NUMBER(4) NOT NULL,
VOLNUM NUMBER(4) NOT NULL,
OCCDATE DATE NULL,
OCCETAT VARCHAR2(25) NULL
, CONSTRAINT PK_OCCURRENCE_VOL PRIMARY KEY (OCCNUM) 

-- Mise en place de contraintes de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE OCCURRENCE_VOL
-- ----------------------------------------------------------------------------

CREATE INDEX I_FK_OCCURRENCE_VOL_VOL
ON OCCURRENCE_VOL (VOLNUM ASC) ;
-- -----------------------------------------------------------------------------
TABLE : VOL
-- -----------------------------------------------------------------------------
CREATE TABLE VOL
( VOLNUM NUMBER(4) NOT NULL,
VOLAERONUM_ARRIVEE NUMBER(4) NOT NULL,
VOLAERONUM_DEPART NUMBER(4) NOT NULL,
VOLH_DEPART VARCHAR2(5) NULL,
VOLH_ARRIVEE VARCHAR2(5) NULL,
VOLNBPLACES NUMBER(4) NULL
, CONSTRAINT PK_VOL PRIMARY KEY (VOLNUM) 

-- Mise en place de contraintes de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE VOL
-- -----------------------------------------------------------------------------

CREATE INDEX I_FK_VOL_AEROPORT
ON VOL (VOLAERONUM_ARRIVEE ASC) ;
CREATE INDEX I_FK_VOL_AEROPORT2
ON VOL (VOLAERONUM_DEPART ASC);
-- -----------------------------------------------------------------------------
TABLE : AEROPORT
-- -----------------------------------------------------------------------------
CREATE TABLE AEROPORT
( AERONUM NUMBER(4) NOT NULL,
AERONOM VARCHAR2(25) NULL,
AEROTAXE NUMBER NULL
, CONSTRAINT PK_AEROPORT PRIMARY KEY (AERONUM) -- Mise en place de contraintes 
de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
TABLE : BILLET
-- -----------------------------------------------------------------------------
CREATE TABLE BILLET
( BILLNUM NUMBER(4) NOT NULL,
TRANUM NUMBER(4) NOT NULL,
BILLDATEACHAT DATE NULL,
BILLDATEDEPART DATE NULL,
BILLETAT VARCHAR2(128) NULL
, CONSTRAINT PK_BILLET PRIMARY KEY (BILLNUM) -- Mise en place de contraintes de 
table ici PRIMARY KEY) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE BILLET
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_BILLET_TRAJET
ON BILLET (TRANUM ASC);
-- -----------------------------------------------------------------------------
TABLE : TRAJET
-- ----------------------------------------------------------------------------
CREATE TABLE TRAJET
( TRANUM NUMBER(4) NOT NULL,
TRAAERONUM_DEPART NUMBER(4) NOT NULL,
TRAAERONUM_ARRIVEE NUMBER(4) NOT NULL,
TRATARIFBILLET NUMBER NULL,
TRANBKGBAG NUMBER NULL,
TRATARIFKGSUP NUMBER NULL
, CONSTRAINT PK_TRAJET PRIMARY KEY (TRANUM) -- Mise en place de contraintes de 
table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE TRAJET
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_TRAJET_AEROPORT
ON TRAJET (TRAAERONUM_DEPART ASC);
CREATE INDEX I_FK_TRAJET_AEROPORT2
ON TRAJET (TRAAERONUM_ARRIVEE ASC);
-- -----------------------------------------------------------------------------
TABLE : CONTAINER
-- -----------------------------------------------------------------------------
CREATE TABLE CONTAINER
( CONTNUM NUMBER(4) NOT NULL,
CONTETAT VARCHAR2(128) NULL,
OCCNUM_PROVENIR NUMBER(4) NULL,
OCCNUM_DESTINER NUMBER(4) NULL,
CONTPOIDSMAX NUMBER(4) NULL
, CONSTRAINT PK_CONTAINER PRIMARY KEY (CONTNUM) -- Mise en place de 
contraintes de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE CONTAINER
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_CONTAINER_OCCURRENCE_VOL
ON CONTAINER (OCCNUM_DESTINER ASC);
CREATE INDEX I_FK_CONTAINER_OCCURRENCE_VOL2
ON CONTAINER (OCCNUM_PROVENIR ASC);
-- -----------------------------------------------------------------------------
TABLE : BAGAGE
-- -----------------------------------------------------------------------------
CREATE TABLE BAGAGE
( BAGNUM NUMBER(4) NOT NULL,
BILLNUM NUMBER(4) NOT NULL,
BAGKG NUMBER(2) NULL
, CONSTRAINT PK_BAGAGE PRIMARY KEY (BAGNUM) -- Mise en place de contraintes de 
table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE BAGAGE
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_BAGAGE_BILLET
ON BAGAGE (BILLNUM ASC);
-- -----------------------------------------------------------------------------
TABLE : CONSTITUER
-- -----------------------------------------------------------------------------
CREATE TABLE CONSTITUER
( TRANUM NUMBER(4) NOT NULL,
VOLNUM NUMBER(4) NOT NULL,
NUMORDRE NUMBER(1) NULL,
JOURPLUS NUMBER(1) NULL
, CONSTRAINT PK_CONSTITUER PRIMARY KEY (TRANUM, VOLNUM) -- Mise en place 
de contraintes de table ici PRIMARY KEY ) ;
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE CONSTITUER
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_CONSTITUER_TRAJET
ON CONSTITUER (TRANUM ASC);
CREATE INDEX I_FK_CONSTITUER_VOL
ON CONSTITUER (VOLNUM ASC);
-- -----------------------------------------------------------------------------
TABLE : AFFECTER
-- -----------------------------------------------------------------------------
CREATE TABLE AFFECTER
( BAGNUM NUMBER(4) NOT NULL,
CONTNUM NUMBER(4) NOT NULL,
CONSTRAINT PK_AFFECTER PRIMARY KEY (BAGNUM, CONTNUM); 

-- Mise en place de contraintes de table ici PRIMARY KEY)
-- -----------------------------------------------------------------------------
-- INDEX DE LA TABLE AFFECTER
-- -----------------------------------------------------------------------------
CREATE INDEX I_FK_AFFECTER_BAGAGE
ON AFFECTER (BAGNUM ASC);
CREATE INDEX I_FK_AFFECTER_CONTAINER
ON AFFECTER (CONTNUM ASC);

-------- Ajouter des clés étrangères-----------------

ALTER TABLE COUPON_VOL ADD (
CONSTRAINT FK_COUPON_VOL_OCCURRENCE_VOL
FOREIGN KEY (OCCNUM)
REFERENCES OCCURRENCE_VOL (OCCNUM)) ; 

-- Mise en place de contraintes de table ici FOREIGN KEY

ALTER TABLE COUPON_VOL ADD (
CONSTRAINT FK_COUPON_VOL_BILLET
FOREIGN KEY (BILLNUM)
REFERENCES BILLET (BILLNUM));
ALTER TABLE OCCURRENCE_VOL ADD
(CONSTRAINT FK_OCCURRENCE_VOL_VOL
FOREIGN KEY (VOLNUM)
REFERENCES VOL (VOLNUM)) ;
ALTER TABLE VOL ADD
(CONSTRAINT FK_VOL_AEROPORT
FOREIGN KEY (VOLAERONUM_DEPART)
REFERENCES AEROPORT (AERONUM)) ;
ALTER TABLE VOL ADD
(CONSTRAINT FK_VOL_AEROPORT2
FOREIGN KEY (VOLAERONUM_ARRIVEE)
REFERENCES AEROPORT (AERONUM)) ;
ALTER TABLE BILLET ADD
(CONSTRAINT FK_BILLET_TRAJET
FOREIGN KEY (TRANUM)
REFERENCES TRAJET (TRANUM)) ;
ALTER TABLE TRAJET ADD
(CONSTRAINT FK_TRAJET_AEROPORT
FOREIGN KEY (TRAAERONUM_DEPART)
REFERENCES AEROPORT (AERONUM)) ;
ALTER TABLE TRAJET ADD
(CONSTRAINT FK_TRAJET_AEROPORT2
FOREIGN KEY (TRAAERONUM_ARRIVEE)
REFERENCES AEROPORT (AERONUM)) ;
ALTER TABLE CONTAINER ADD
(CONSTRAINT FK_CONTAINER_OCCURRENCE_VOL
FOREIGN KEY (OCCNUM_DESTINER)
REFERENCES OCCURRENCE_VOL (OCCNUM)) ;
ALTER TABLE CONTAINER ADD
(CONSTRAINT FK_CONTAINER_OCCURRENCE_VOL2
FOREIGN KEY (OCCNUM_PROVENIR)
REFERENCES OCCURRENCE_VOL (OCCNUM)) ;
ALTER TABLE BAGAGE ADD
(CONSTRAINT FK_BAGAGE_BILLET
FOREIGN KEY (BILLNUM)
REFERENCES BILLET (BILLNUM)) ;
ALTER TABLE CONSTITUER ADD
(CONSTRAINT FK_CONSTITUER_TRAJET
FOREIGN KEY (TRANUM)
REFERENCES TRAJET (TRANUM)) ;
ALTER TABLE CONSTITUER ADD
(CONSTRAINT FK_CONSTITUER_VOL
FOREIGN KEY (VOLNUM)
REFERENCES VOL (VOLNUM)) ;
ALTER TABLE AFFECTER ADD
(CONSTRAINT FK_AFFECTER_BAGAGE
FOREIGN KEY (BAGNUM)
REFERENCES BAGAGE (BAGNUM)) ;
ALTER TABLE AFFECTER ADD
(CONSTRAINT FK_AFFECTER_CONTAINER
FOREIGN KEY (CONTNUM)
REFERENCES CONTAINER (CONTNUM)) ;


---- AJouter les contraintes de chaque table utilisation de la contrainte CHECK-----

-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE COUPON_VOL
-- -----------------------------------------------------------------------------
ALTER TABLE COUPON_VOL ADD CONSTRAINT COUPON_VOL_ck_COUPNUM CHECK(COUPNUM>0);
ALTER TABLE COUPON_VOL ADD CONSTRAINT COUPON_VOL_ck_COUPETAT CHECK(COUPETAT 
in('réservé','enregistré','annulé','arrivé'));
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE OCCURRENCE_VOL
-- -----------------------------------------------------------------------------
ALTER TABLE OCCURRENCE_VOL ADD CONSTRAINT OCCURRENCE_VOL_ck_OCCNUM 
CHECK(OCCNUM>0);
ALTER TABLE OCCURRENCE_VOL ADD CONSTRAINT OCCURRENCE_VOL_ck_OCCETAT 
CHECK(OCCETAT in('ouverte à la réservation', 'ouverte à l’embarquement', 'ouverte
à la liste d’attente', 'décollée, annulée', 'retardée', 'arrivé'));

-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE VOL
-- -----------------------------------------------------------------------------
ALTER TABLE VOL ADD CONSTRAINT VOL_ck_VOLNUM CHECK(VOLNUM>0);
ALTER TABLE VOL ADD CONSTRAINT VOL_ck_VOLNBPLACES CHECK(VOLNBPLACES>=0);
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE AEROPORT
-- -----------------------------------------------------------------------------
ALTER TABLE AEROPORT ADD CONSTRAINT AEROPORT_ck_AERONUM CHECK(AERONUM>0);
ALTER TABLE AEROPORT ADD CONSTRAINT AEROPORT_ck_AEROTAXE CHECK(AEROTAXE>=0);
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE BILLET
-- -----------------------------------------------------------------------------
ALTER TABLE BILLET ADD CONSTRAINT BILLET_ck_BILLNUM CHECK(BILLNUM>0);
ALTER TABLE BILLET ADD CONSTRAINT BILLET_ck_BILLDATEACHAT 
CHECK(BILLDATEACHAT<=BILLDATEDEPART );
ALTER TABLE BILLET ADD CONSTRAINT BILLET_ck_ BILLDATEDEPART CHECK( 
BILLDATEDEPART >BILLDATEACHAT);

ALTER TABLE BILLET ADD CONSTRAINT BILLET_ck_BILLETAT CHECK(BILLETAT IN ('émis', 'en cours', 
'terminé'));
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE TRAJET
-- -----------------------------------------------------------------------------
ALTER TABLE TRAJET ADD CONSTRAINT TRAJET_ck_TRANUM CHECK(TRANUM>0);
ALTER TABLE TRAJET ADD CONSTRAINT TRAJET_ck_TRATARIFBILLET 
CHECK(TRATARIFBILLET>=0);
ALTER TABLE TRAJET ADD CONSTRAINT TRAJET_ck_TRANBKGBAG CHECK(TRANBKGBAG>=0);
ALTER TABLE TRAJET ADD CONSTRAINT TRAJET_ck_TRATARIFKGSUP CHECK(TRATARIFKGSUP>=0 
);
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE CONTAINER
-- -----------------------------------------------------------------------------
ALTER TABLE CONTAINER ADD CONSTRAINT CONTAINER_ck_CONTNUM CHECK(CONTNUM>0);
ALTER TABLE CONTAINER ADD CONSTRAINT CONTAINER_ck_CONTETAT CHECK(CONTETAT IN ('en 
cours de chargement', 'chargé',' en cours de chargement', 'chargé', 'en cours de dechargement', 
'déchargé'));
ALTER TABLE CONTAINER ADD CONSTRAINT 
CONTAINER_ck_CONTPOIDSMAX CHECK(CONTPOIDSMAX =0);
-- ----------------------------------------------------------------------------

-- AJOUTER LES CONTRAINTES DE TABLE BAGAGE
-- -----------------------------------------------------------------------------
ALTER TABLE BAGAGE ADD CONSTRAINT BAGAGE_ck_BAGNUM CHECK( BAGNUM>0);
ALTER TABLE BAGAGE ADD CONSTRAINT BAGAGE_ck_ BAGKG CHECK( BAGKG>=0);
ALTER TABLE BAGAGE ADD CONSTRAINT BAGAGE_ck_BAGKG CHECK (BAGKG>=0) 
ENABLE;
-- -----------------------------------------------------------------------------
-- AJOUTER LES CONTRAINTES DE TABLE CONSTITUER
-- -----------------------------------------------------------------------------
ALTER TABLE CONSTITUER ADD CONSTRAINT CONSTITUER_ck_NUMORDRE CHECK( 
NUMORDRE>0);
ALTER TABLE CONSTITUER ADD CONSTRAINT CONSTITUER_ck_JOURPLUS CHECK( JOURPLUS>=0);




 







