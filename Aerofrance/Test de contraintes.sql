--Insertion un nouvel AEROPORT sans clé primaire
INSERT INTO BESSY_AEROFRANCE.AEROPORT (AERONUM,AERONOM,AEROTAXE) VALUES 
('','toulouse','20');

--Insertion un billet avec une date de départ avant la date d'achat
INSERT INTO BESSY_AEROFRANCE.BILLET 
(BILLNUM,TRANUM,BILLDATEACHAT,BILLDATEDEPART,BILLETAT)
VALUES 
('12','3',TO_DATE('28/11/2019','DD/MM/YYYY'),TO_DATE('10/11/2019','DD/MM/YYYY'),'terminé');

--Insertion un bagage avec bagkg négatif
INSERT INTO BESSY_AEROFRANCE.BAGAGE (BAGNUM,BILLNUM,BAGKG) VALUES ('12','10','-
11');

--Insertion un coupon_vol sans les informations requises
INSERT INTO BESSY_AEROFRANCE.COUPON_VOL 
(COUPNUM,OCCNUM,BILLNUM,COUPETAT)
VALUES ('17','37',' ','réservé');

--Insertion une occurrence_vol avec une information incorrect
INSERT INTO BESSY_AEROFRANCE.OCCURRENCE_VOL 
(OCCNUM,VOLNUM,OCCDATE,OCCETAT)
VALUES ('37','15',TO_DATE('02/12/2019','DD/MM/YYYY'),'réservé');

