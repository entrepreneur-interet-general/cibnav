/* Attention : les commentaires introduits avec '--' ne fonctionnent pas en passant par Airflow */

/* Requête qui extrait les données sur les navires contenues dans :
 - NAVPRO.NAV_FLOTTEUR, NAVPRO.NAV_NAVIRE_FRANCAIS, NAVPRO.NAV_PA, NAV_CODE_STATUT_FLOTTEUR,NAVPRO.NAV_CODE_STATUT_PA
 - GINA.GIN_NAVIRE_VERSION, GINA.GIN_CERTIFICAT
 - C_CODE_PAYS
 */

/*ici la sous requete permet de recuperer tous les certficats, le filtre pour les permis de navigations est dans "app.py"*/
WITH pn_statut AS (
    SELECT *
        FROM (
            SELECT
                GINA.GIN_NAVIRE_VERSION.NUM_IMMAT as pn_num_immat ,
                GINA.GIN_CERTIFICAT.IDC_GIN_CERTIFICAT as idc_certificat,
                GINA.GIN_CERTIFICAT.IDC_GIN_ETAT_CERTIFICAT as idc_etat_certificat,
                GINA.GIN_CODE_ETAT_CERTIFICAT.LIBELLE as libelle_etat_certificat,
                GINA.GIN_CODE_CERTIFICAT.LIBELLE as libelle_certificat,
/* afin de pouvoir filtrer sur les permis de navigation illimités et les clauses de revoyure par la suite */
                GINA.GIN_CERTIFICAT.DATE_EXPIRATION as date_expiration,
                GINA.GIN_CERTIFICAT.DATE_DELIVRANCE as date_delivrance,
                GINA.GIN_CERTIFICAT.OBSERVATIONS as observations,
                GINA.GIN_NAVIRE_VERSION.NUM_VERSION,
                ROW_NUMBER() OVER(
                    PARTITION BY GINA.GIN_CERTIFICAT.NUM_IMMAT
                        ORDER BY
                            GINA.GIN_CERTIFICAT.DATE_EXPIRATION DESC
                    ) AS ordre_antichronologique
                    FROM GINA.GIN_NAVIRE_VERSION
                        LEFT JOIN GINA.GIN_CERTIFICAT
                    ON GINA.GIN_CERTIFICAT.NUM_IMMAT = GINA.GIN_NAVIRE_VERSION.NUM_IMMAT
                LEFT JOIN GINA.GIN_CODE_CERTIFICAT
                    ON GINA.GIN_CERTIFICAT.IDC_GIN_CERTIFICAT= GINA.GIN_CODE_CERTIFICAT.IDC_GIN_CERTIFICAT
                LEFT JOIN GINA.GIN_CODE_ETAT_CERTIFICAT
                    ON GINA.GIN_CODE_ETAT_CERTIFICAT.IDC_GIN_ETAT_CERTIFICAT=GINA.GIN_CERTIFICAT.IDC_GIN_ETAT_CERTIFICAT
           )
           WHERE ordre_antichronologique = 1
    ),

/* Recuperer la version de Gina Navire Version la plus récente (1 = la plus récente) */
navire_version_recent as (
  SELECT *
  FROM (
    SELECT
      GINA.GIN_NAVIRE_VERSION.NUM_IMMAT,
      GINA.GIN_NAVIRE_VERSION.NUM_VERSION,
      GINA.GIN_NAVIRE_VERSION.IDC_GIN_STATUT_ACTIVITE,
      GINA.GIN_NAVIRE_VERSION.IDC_GIN_CENTRE_SECU_DELEGUE,
      GINA.GIN_NAVIRE_VERSION.IDC_GIN_CENTRE_SECU_GESTION,
      GINA.GIN_NAVIRE_VERSION.IDC_GIN_DIVISION_SECU,
      GINA.GIN_NAVIRE_VERSION.EFFECTIF_MINIMUM,
      GINA.GIN_NAVIRE_VERSION.TYPE_PECHE_PRINCIPAL,
      GINA.GIN_NAVIRE_VERSION.TECHNIQUE_PECHE_PRINCIPALE,
      ROW_NUMBER() OVER(
        PARTITION BY GINA.GIN_NAVIRE_VERSION.NUM_IMMAT
        ORDER BY
          GINA.GIN_NAVIRE_VERSION.DATE_EFFET DESC
    ) AS ordre_antichronologique
    FROM GINA.GIN_NAVIRE_VERSION
  )
  LEFT JOIN GINA.GIN_CODE_UNITE ON GINA.GIN_CODE_UNITE.IDC_GIN_UNITE = IDC_GIN_CENTRE_SECU_GESTION
  WHERE ordre_antichronologique = 1
),
/* Recuperer la version de Gina Certificats de Franc Bord la plus récente (1 = la plus récente) 
La sous requete suivante ne permet pas ici de récupérer le certificat franc bord associé à un navire en raison du filtre sur l'IDC_GIN_CERTIFICAT à la fin de la requete
*/
certificat_franc_bord as (
  SELECT *
  FROM (
    SELECT
      GINA.GIN_CERTIFICAT.NUM_IMMAT,
      GINA.GIN_CERTIFICAT.DATE_EXPIRATION,
      GINA.GIN_CERTIFICAT.IDC_GIN_ETAT_CERTIFICAT,
      ROW_NUMBER() OVER(
        PARTITION BY GINA.GIN_CERTIFICAT.NUM_IMMAT
        ORDER BY
          GINA.GIN_CERTIFICAT.DATE_EXPIRATION DESC
    ) AS ordre_antichronologique
    FROM GINA.GIN_CERTIFICAT
    WHERE GINA.GIN_CERTIFICAT.IDC_GIN_CERTIFICAT = 48
  )
  WHERE ordre_antichronologique = 1
),
/* Recuperer la version de navire statut la plus récente (1 = la plus récente) */
statut_navire as (
  SELECT statut_code.*, COMMUN.C_CODE_GENRE_NAVIGATION.LIBELLE_COURT as genre_navigation
  FROM (
    SELECT *
    FROM (
      SELECT
        NAVPRO.NAV_NAVIRE_STATUT.ID_NAV_FLOTTEUR,
        NAVPRO.NAV_NAVIRE_STATUT.DATE_DEBUT,
        NAVPRO.NAV_NAVIRE_STATUT.IDC_GENRE_NAVIGATION,
        ROW_NUMBER() OVER(
          PARTITION BY NAVPRO.NAV_NAVIRE_STATUT.ID_NAV_FLOTTEUR
          ORDER BY
            NAVPRO.NAV_NAVIRE_STATUT.DATE_DEBUT DESC
      ) AS ordre_antichronologique
      FROM NAVPRO.NAV_NAVIRE_STATUT
    )
    WHERE ordre_antichronologique = 1
  ) statut_code
  LEFT JOIN COMMUN.C_CODE_GENRE_NAVIGATION
  ON COMMUN.C_CODE_GENRE_NAVIGATION.IDC_GENRE_NAVIGATION = statut_code.IDC_GENRE_NAVIGATION
),

/*Recupération des informations sur les visites suivantes : Date de la visite, Nb de jours depuis la dernière visite et lieu de la dernière visite*/ 
info_derniere_visite as (
SELECT  NUM_IMMAT, DATE_DE_VISITE, DELAI_VISITE, LIEU_VISITE
	FROM (
	SELECT
		GIN_VISITE.NUM_IMMAT as NUM_IMMAT,
		GIN_VISITE.DATE_VISITE AS DATE_DE_VISITE,
		CAST(CURRENT_DATE - GIN_VISITE.DATE_VISITE AS INT) AS DELAI_VISITE,
		GIN_VISITE.LIEU AS LIEU_VISITE,
		ROW_NUMBER() OVER( PARTITION BY GIN_VISITE.NUM_IMMAT
		                 ORDER BY GIN_VISITE.DATE_VISITE desc) AS ORDRE_ANTICHRO
		FROM GIN_VISITE )
		WHERE ORDRE_ANTICHRO = 1
),

/*Recuperation des differents champs afin de pouvoir proposer plus de details et de filtres sur Metabase */
/*NB : Ces champs ne sont pas utilises pour l'apprentissage du modele */
navire_detail as (
  SELECT GIN_VUE_NAVIRE_DETAIL.ID_NAV_FLOTTEUR, 
	GIN_VUE_NAVIRE_DETAIL.ENGIN_PRINCIPAL, 
	GIN_VUE_NAVIRE_DETAIL.LIB_ENGIN_PRINCIPAL, 
	GIN_VUE_NAVIRE_DETAIL.IDC_CATEG_ENGIN_PRINCIPAL, 
	GIN_VUE_NAVIRE_DETAIL.LIB_CATEG_ENGIN_PRINCIPAL, 
	GIN_VUE_NAVIRE_DETAIL.IDC_NATURE_ENGIN_PRINCIPAL, 
	GIN_VUE_NAVIRE_DETAIL.LIB_NATURE_ENGIN_PRINCIPAL, 
  	GIN_VUE_NAVIRE_DETAIL.IDC_CATEG_ENGIN_SECONDAIRE,
  	GIN_VUE_NAVIRE_DETAIL.LIB_CATEG_ENGIN_SECONDAIRE,
  	GIN_VUE_NAVIRE_DETAIL.LIB_NATURE_ENGIN_SECONDAIRE,
  	GIN_VUE_NAVIRE_DETAIL.IDC_NATURE_ENGIN_SECONDAIRE
  FROM GIN_VUE_NAVIRE_DETAIL
  RIGHT JOIN (
  SELECT id_nav_flotteur, MAX(date_creation_version) keep (dense_rank first order by rownum) date_creation_version 
  FROM GIN_VUE_NAVIRE_DETAIL
  GROUP BY id_nav_flotteur
  ) unique_navire
  ON GIN_VUE_NAVIRE_DETAIL.ID_NAV_FLOTTEUR = unique_navire.ID_NAV_FLOTTEUR AND GIN_VUE_NAVIRE_DETAIL.DATE_CREATION_VERSION = unique_navire.DATE_CREATION_VERSION
/* Nous eliminons 5 navires qui nous posent problemes pour des raison de cles dupliquees. Attention a les remettre */
  WHERE unique_navire.ID_NAV_FLOTTEUR != '1241250' AND unique_navire.ID_NAV_FLOTTEUR != '1547672' AND unique_navire.ID_NAV_FLOTTEUR != '1772605' AND unique_navire.ID_NAV_FLOTTEUR != '1234669'
/* Afin d eviter le doublon sur le navire NUKUHAU ,on considere la version pour laquelle type de navire nest pas bloqué sur NavPro */
  OR (unique_navire.ID_NAV_FLOTTEUR = '1238185' AND GIN_VUE_NAVIRE_DETAIL.CODE_TYPE_NAVIRE != '3101')
/* Nous eliminons ici le navire Testing qui est un navire fictif utilisé sous GINA auquel est, en particulier, associé un certificat Clause de revoyure */
  AND unique_navire.ID_NAV_FLOTTEUR != '1678826'
),
/*Recuperation des differents champs afin de pouvoir proposer plus de details sur Metabase notamment concernant l'effectif du navire */
navire_categ as (
  SELECT DISTINCT GIN_NAVIRE_CATEG_NAVIG.NUM_IMMAT, GIN_NAVIRE_CATEG_NAVIG.NUM_VERSION, GIN_NAVIRE_CATEG_NAVIG.EFFECTIF_MINIMUM
  FROM GIN_NAVIRE_CATEG_NAVIG
  RIGHT JOIN (
	SELECT DISTINCT num_immat, MAX(num_version) num_version FROM GIN_NAVIRE_CATEG_NAVIG GROUP BY num_immat
  ) unique_version
  ON unique_version.num_immat = GIN_NAVIRE_CATEG_NAVIG.num_immat AND unique_version.num_version = GIN_NAVIRE_CATEG_NAVIG.num_version
)

/* Début Requête centrale
   Attendu en sortie : Une entrée par navire actif du projet cibnav
 */
SELECT
  NAVPRO.NAV_FLOTTEUR.ID_NAV_FLOTTEUR,
  NAVPRO.NAV_FLOTTEUR.NUM_IMO,
  NAVPRO.NAV_FLOTTEUR.NOM_NAVIRE,
  NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS,
  NAVPRO.NAV_FLOTTEUR.IDC_SITUATION,
  NAVPRO.NAV_FLOTTEUR.NUMERO_MMSI as num_mmsi,
  NAVPRO.NAV_CODE_SITUATION.libelle as situation_flotteur,
  NAVPRO.NAV_CODE_STATUT_FLOTTEUR.libelle as statut_flotteur,
  NAVPRO.NAV_NAVIRE_FRANCAIS.CHANTIER_CONSTRUCTION,
  NAVPRO.NAV_NAVIRE_FRANCAIS.ANNEE_CONSTRUCTION,
  NAVPRO.NAV_NAVIRE_FRANCAIS.PUISSANCE_PROPULSIVE,
  NAVPRO.NAV_NAVIRE_FRANCAIS.PUISSANCE_ADMINISTRATIVE,
  NAVPRO.NAV_NAVIRE_FRANCAIS.LONGUEUR_HORS_TOUT,
  NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_PROPULSION,
  NAVPRO.NAV_NAVIRE_FRANCAIS.NOMBRE_MOTEUR,
  NAVPRO.NAV_NAVIRE_FRANCAIS.DATE_DEBUT_FRANCISATION as date_francisation,
  NAVPRO.NAV_NAVIRE_FRANCAIS.JAUGE_LONDRES,
  NAVPRO.NAV_NAVIRE_FRANCAIS.JAUGE_NETTE,
  NAVPRO.NAV_NAVIRE_FRANCAIS.JAUGE_OSLO,
  NAVPRO.NAV_CODE_TYPE_MOTEUR.LIBELLE as type_moteur,  
  NAVPRO.NAV_CODE_ORIGINE.LIBELLE as origine,
  COMMUN.C_CODE_MATERIAU_COQUE.LIBELLE as materiau_coque,
  COMMUN.C_CODE_CARBURANT.LIBELLE as type_carburant,
  COMMUN.C_CODE_QUARTIER.libelle as quartier,
  NAVPRO.NAV_CODE_TYPE_NAVIRE.LIBELLE as type_navire,
  info_derniere_visite.DATE_DE_VISITE as date_visite,
  info_derniere_visite.DELAI_VISITE as delai_visite,
  info_derniere_visite.LIEU_VISITE as lieu_visite,
  pn_statut.pn_num_immat,
  pn_statut.idc_certificat as idc_certificat,
  pn_statut.idc_etat_certificat as idc_etat_certificat,
  pn_statut.libelle_etat_certificat,
  pn_statut.libelle_certificat,
  pn_statut.observations,
  pn_statut.date_expiration,
  pn_statut.date_delivrance,
  navire_version_recent.NUM_VERSION,
  navire_version_recent.IDC_GIN_STATUT_ACTIVITE,
  navire_version_recent.IDC_GIN_CENTRE_SECU_DELEGUE,
  navire_version_recent.IDC_GIN_DIVISION_SECU,
  navire_version_recent.libelle as centre_secu_gestion,
  navire_version_recent.effectif_minimum,
  navire_version_recent.type_peche_principal as g_type_peche_principal,
  navire_version_recent.technique_peche_principale as g_technique_peche_principale,
  /*navire_detail.engin_principal,
  navire_detail.lib_engin_principal, */
  navire_detail.idc_categ_engin_principal,
  navire_detail.lib_categ_engin_principal,
  navire_detail.idc_nature_engin_principal,
  navire_detail.lib_nature_engin_principal, 
  navire_detail.idc_categ_engin_secondaire,
  navire_detail.lib_categ_engin_secondaire,
  navire_detail.lib_nature_engin_secondaire,
  navire_detail.idc_nature_engin_secondaire,
  certificat_franc_bord.DATE_EXPIRATION as expiration_franc_bord,
  certificat_franc_bord.IDC_GIN_ETAT_CERTIFICAT as etat_certificat,
  statut_navire.genre_navigation
FROM
  NAVPRO.NAV_FLOTTEUR

/* Jointure avec navire francais pour avoir des informations complementaires */
LEFT JOIN NAVPRO.NAV_NAVIRE_FRANCAIS
ON NAVPRO.NAV_NAVIRE_FRANCAIS.ID_NAV_FLOTTEUR = NAVPRO.NAV_FLOTTEUR.ID_NAV_FLOTTEUR
/* Fin de la jointure avec navire francais */

/* Jointure avec navire francais pour avoir des informations sur le permis de navigation*/
LEFT JOIN pn_statut
ON NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS=pn_statut.pn_num_immat

/* Jointure avec navire_version_recent (cf sous-requete au dessus) */
LEFT JOIN navire_version_recent
ON navire_version_recent.NUM_IMMAT = NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS
/* Fin de la jointure avec navire version recent */

/* Jointure avec navire_version_recent (cf sous-requete au dessus) */
LEFT JOIN certificat_franc_bord
ON certificat_franc_bord.NUM_IMMAT = NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS
/* Fin de la jointure avec navire version recent */

/* Jointure avec navire_statut  */
LEFT JOIN statut_navire
ON statut_navire.ID_NAV_FLOTTEUR = NAVPRO.NAV_FLOTTEUR.ID_NAV_FLOTTEUR
/* Fin de la jointure avec navire version recent */

/* Jointure avec COMMUN.C_CODE_QUARTIER pour récuperer les quartiers des navires */
LEFT JOIN COMMUN.C_CODE_QUARTIER
ON COMMUN.C_CODE_QUARTIER.IDC_QUARTIER = NAVPRO.NAV_FLOTTEUR.IDC_QUARTIER_IMMAT

/* Jointure pour avoir le libelle du type de carburant */
LEFT JOIN COMMUN.C_CODE_CARBURANT
on COMMUN.C_CODE_CARBURANT.IDC_CARBURANT =  NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_CARBURANT

/* Jointure pour avoir le libelle du type de materiau_coque */
LEFT JOIN COMMUN.C_CODE_MATERIAU_COQUE
on COMMUN.C_CODE_MATERIAU_COQUE.IDC_MATERIAU_COQUE =  NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_MATERIAU_COQUE

/* Jointure pour avoir le libelle du type de moteur */
LEFT JOIN NAVPRO.NAV_CODE_TYPE_MOTEUR
on NAVPRO.NAV_CODE_TYPE_MOTEUR.IDC_TYPE_MOTEUR =  NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_TYPE_MOTEUR

/* Jointure pour avoir le libelle du type d'origine*/
LEFT JOIN NAVPRO.NAV_CODE_ORIGINE
on NAVPRO.NAV_CODE_ORIGINE.IDC_ORIGINE =  NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_ORIGINE

/* Jointure pour avoir le libelle du type de navire dans NavPro */
LEFT JOIN NAV_CODE_TYPE_NAVIRE
on NAV_CODE_TYPE_NAVIRE.IDC_TYPE_NAVIRE = NAVPRO.NAV_NAVIRE_FRANCAIS.IDC_TYPE_NAVIRE

/* Jointure pour avoir les informations de la derniere visite de securite*/
LEFT JOIN info_derniere_visite
ON info_derniere_visite.NUM_IMMAT= NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS

/* Jointure pour avoir des détails sur les navires*/
LEFT JOIN navire_detail 
ON navire_detail.ID_NAV_FLOTTEUR = NAVPRO.NAV_FLOTTEUR.ID_NAV_FLOTTEUR 

/* Jointure pour avoir des détails sur les categories des navires*/
/*RIGHT JOIN  navire_categ
ON navire_categ.NUM_IMMAT = NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS */


/* ---------      JOINTURES POUR FILTRER       ---------------------- */
LEFT JOIN NAVPRO.NAV_CODE_SITUATION ON NAVPRO.NAV_FLOTTEUR.idc_situation = NAVPRO.NAV_CODE_SITUATION.idc_situation
LEFT JOIN NAVPRO.NAV_CODE_STATUT_FLOTTEUR ON NAVPRO.NAV_FLOTTEUR.idc_statut_flotteur = NAVPRO.NAV_CODE_STATUT_FLOTTEUR.code

/*  Situation : Plaisance, Francais peche, Francais commerce, Peche Communautaire, Peche Non Communautaire
    Statut : En Service, Indefini
    Categ navigation : informations de type plaisance, niveau éloignement cote....
    Certificat : permis de navigation 47,67,68,69, clause de revoyure 1007
*/

WHERE
  NAVPRO.NAV_CODE_SITUATION.idc_situation in (2, 3, 4, 5)
  AND NAVPRO.NAV_CODE_STATUT_FLOTTEUR.idc_statut_flotteur in (1, 2)
  AND NAVPRO.NAV_NAVIRE_FRANCAIS.est_dernier = 1 
  AND pn_statut.idc_certificat in (47,67,68,69,1007)
  AND ((pn_statut.idc_etat_certificat <=3) or (pn_statut.idc_etat_certificat=6))
  
