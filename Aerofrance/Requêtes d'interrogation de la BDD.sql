--- Donner pour chaque aéroport, la liste des trajets dont il constitue l'aéroport de départ et pour lesquels le prix des kilos supplémentaires de bagages est supérieur à 5% du prix du trajet.---

SELECT A.AERONUM, T.TRANUM
FROM AEROPORT A, TRAJET T
WHERE A.AERONUM=T.TRAAERONUM_DEPART
AND T.TRATARIFKGSUP> 0.05*T.TRATARIFBILLET
ORDER BY A.AERONUM;


-- Numéro, aéroports de départ et d'arrivée des trajets constitués de plus de deux vols--

SELECT DISTINCT TRAAERONUM_DEPART, TRAAERONUM_ARRIVEE, C.NUMORDRE
FROM AEROPORT A, TRAJET T, CONSTITUER C
WHERE T.TRANUM=C.TRANUM
AND C.NUMORDRE>2;


-- Liste des vols partant à la même heure et du même aéroport--

SELECT V1.VOLNUM,V2.VOLNUM
FROM VOL V1, VOL V2
WHERE V1.VOLNUM <> V2.VOLNUM
AND V1.VOLAERONUM_DEPART=V2.VOLAERONUM_DEPART
AND V1.VOLH_DEPART=V2.VOLH_DEPART;

--Afficher pour chaque billet son numéro, les aéroports de départ et d'arrivée et le poids total des bagages associés (classement par ordre alphabétique des aéroports de départ)--

SELECT A.AERONOM as aeronom_depart, Bi.BILLNUM, 
T.TRAAERONUM_DEPART,T.TRAAERONUM_ARRIVEE,SUM(BAGKG) Tkbag
FROM AEROPORT A, TRAJET T, BILLET Bi, BAGAGE Ba
WHERE T.TRANUM=Bi.TRANUM
AND Bi.BILLNUM=Ba.BILLNUM
AND T.TRAAERONUM_DEPART=A.AERONUM
GROUP BY Bi.BILLNUM, T.TRAAERONUM_DEPART, T.TRAAERONUM_ARRIVEE, 
A.AERONOM
ORDER BY A.AERONOM;

--Afficher pour chaque billet le prix à payer pour son excédant de poids des bagages associés, s'il y en a un.--

SELECT B.BILLNUM, SUM((BA.BAGKG-T.TRANBKGBAG)*T.TRATARIFBILLET) as 
prixsupbag 
FROM BILLET B, BAGAGE BA, TRAJET T
WHERE B.TRANUM=T.TRANUM
AND B.BILLNUM=BA.BILLNUM
GROUP BY B.BILLNUM 
HAVING SUM(BA.BAGKG-T.TRANBKGBAG)>0;

--  Liste des trajets au départ de Toulouse qui n'ont pas fait l'objet d'un billet en 2019.-- 

SELECT T1.TRANUM
FROM TRAJET T1, AEROPORT A
WHERE T1.TRAAERONUM_DEPART=A.AERONUM 
AND A.AERONOM='toulouse'
AND T1.TRANUM NOT IN ( SELECT T2.TRANUM 
 FROM TRAJET T2, BILLET B
 WHERE T2.TRANUM=B.TRANUM
 AND B.BILLDATEACHAT=TO_DATE('19','YY'));
 
 -- Liste des trajets ayant uniquement fait l'objet de billets dont la date de départ est fixée au mois de novembre (toutes années confondues). Trier le résultat par aéroport de destINation.
 
SELECT DISTINCT T1.TRANUM,T1.TRAAERONUM_ARRIVEE
FROM TRAJET T1, BILLET B1
WHERE T1.TRANUM=B1.TRANUM
AND to_char (B1.BILLDATEDEPART,'MM')='11'
AND T1.TRANUM NOT IN (SELECT T2.TRANUM
 FROM TRAJET T2, BILLET B2
 WHERE T2.TRANUM=B2.TRANUM
 AND to_char(B2.BILLDATEDEPART,'MM')<>'11')
ORDER By T1.TRAAERONUM_ARRIVEE asc;


-- Numéro du contaINer ayant transporté le bagage le plus lourd. Afficher aussi les numéros du bagage, du billet et du vol concernés, si possible

SELECT C.CONTNUM, B.BILLNUM, BA.BAGNUM, V.VOLNUM, SUM(BA.BAGKG) AS 
LOURD
FROM CONTAINER C,BILLET B, BAGAGE BA, VOL V, AFFECTER A, TRAJET T, 
CONSTITUER CO 
WHERE C.CONTNUM=A.CONTNUM
AND A.BAGNUM=BA.BAGNUM
AND BA.BILLNUM=B.BILLNUM
AND B.TRANUM=T.TRANUM
AND T.TRANUM=CO.TRANUM
AND CO.VOLNUM=V.VOLNUM
AND BA.BAGKG IN 
( SELECT max(BAGKG)
 FROM BAGAGE b1)
GROUP BY C.CONTNUM, B.BILLNUM, BA.BAGNUM, V.VOLNUM
ORDER BY LOURD DESC;

--  Liste des trajets constitués par un vol commun. Afficher les aéroports de départ et d'arrivée des deux trajets

SELECT T.TRANUM, T.TRAAERONUM_DEPART, T.TRAAERONUM_ARRIVEE
FROM TRAJET T, CONSTITUER C, VOL V
WHERE T.TRANUM=C.TRANUM
AND C.VOLNUM=V.VOLNUM
AND V.VOLNUM IN 
( 
		SELECT V2.VOLNUM
		FROM VOL V2, TRAJET T2, CONSTITUER C2
		WHERE T2.TRANUM=C2.TRANUM 
		AND C2.VOLNUM=V2.VOLNUM AND T.TRANUM <> T2.TRANUM);
		
-- Liste des contaINers en surcharge, c’est-à-dire pour lesquels la somme du poids des bagages qui lui sont affectés est supérieure au poids maximum que peut supporter le contaINer


SELECT C2.CONTNUM
		FROM 
		(SELECT C.CONTNUM, SUM(Ba.BAGKG) AS TOTALKG
		 FROM CONTAINER C, AFFECTER A, BAGAGE BA
		 WHERE C.CONTNUM=A.CONTNUM
		 AND BA.BAGNUM=A.BAGNUM
		 GROUP BY C.CONTNUM) t,CONTAINER c2
WHERE c2.CONTNUM = t.CONTNUM
AND c2.CONTPOIDSMAX<t.totalkg;

--Liste de billets pour lesquels il y a une erreur d'affectation dans les coupons, c’est-à-dire pour lesquels il manque un coupon pour un des vols constituant le trajet, ou pour lesquels il y a un coupon pour un vol qui ne fait pas parti du trajet, ou pour lesquels on a des occurrences de vol qui ne correspondent pas à la date de départ du trajet.

SELECT b. BILLNUM
FROM billet b, coupon_vol c 
WHERE b.billnum = c.billnum
AND c.coupnum NOT IN( SELECT cv.coupnum
 FROM coupon_vol cv, occurrence_vol o, vol v, CONSTITUER con, trajet t
 WHERE cv.OCCNUM=o.occnum
 AND o.volnum = v.volnum
 AND v.volnum= con.volnum
 AND con.tranum =t.tranum)
UNION 
SELECT b.billnum
FROM BILLET b, coupon_vol cv, occurrence_vol o, vol v, CONSTITUER con, trajet t
WHERE b.billnum = cv.billnum
AND cv.OCCNUM=o.occnum
AND o.volnum = v.volnum
AND v.volnum= con.volnum
AND con.tranum =t.tranum 
AND v.volnum NOT IN (SELECT v2.volnum
 FROM vol v2, constituer c2, trajet t2,billet b2
 WHERE v2.volnum=c2.volnum
 AND c2.tranum = t2.tranum
 AND b2.tranum = t2.tranum
 AND b.billnum =b2.billnum)
UNION
SELECT DISTINCT b.billnum
FROM BILLET b, coupon_vol cv, occurrence_vol o
WHERE b.billnum = cv.billnum
AND cv.OCCNUM=o.occnum
AND o.occdate NOT IN 
(SELECT b.BILLDATEDEPART
 FROM billet b2
 WHERE b.BILLNUM = b2.BILLNUM );
 
-- Afficher pour chaque vol la date de la dernière occurrence de vol pour laquelle un coupon de vol a été émis-- 
		
SELECT V.VOLNUM, MAX(OV.OCCDATE) AS DERNIERE_EMISSION
FROM VOL V, OCCURRENCE_VOL OV, COUPON_VOL CV
WHERE V.VOLNUM=OV.VOLNUM
AND OV.OCCNUM=CV.OCCNUM
AND CV.COUPETAT='réservé'
GROUP BY V.VOLNUM;	