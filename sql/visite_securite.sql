/* Requête qui extrait les données sur visites de sécurité des navires :
 */
with prescriptions as (
  select sum(controles_unitaires.nombre_prescriptions_navire) as nombre_prescriptions, controles_unitaires.id_gin_visite
  from (
    select GINA.GIN_VISITE.id_gin_visite,
        case GINA.GIN_RESULTAT_CONTROLE.IDC_GIN_RESULTAT_CONTROLE /* Changement dans les valeurs pour additionner facilement les prescriptions */
          when 1 then 0 /* n'arrive pas car filtré */
          when 2 then 0
          when 3 then 1
          when 4 then 1
          when 5 then 0
          when 6 then 0
          when 7 then 0
          when 8 then 0
          else 0
        end as nombre_prescriptions_navire
    from GINA.GIN_RESULTAT_CONTROLE
    left join  GINA.GIN_CODE_CONTROLE ON  GINA.GIN_CODE_CONTROLE.idc_gin_controle = GINA.GIN_RESULTAT_CONTROLE.idc_gin_controle
    left join GINA.GIN_VISITE on GINA.GIN_RESULTAT_CONTROLE.id_gin_visite =  GINA.GIN_VISITE.id_gin_visite
    where GINA.GIN_RESULTAT_CONTROLE.idc_gin_resultat_controle != 1 and GINA.GIN_CODE_CONTROLE.est_majeur != 1 and extract(year from GINA.GIN_VISITE.DATE_VISITE) > 2015 and (GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 3 or GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 2)
    /* Suppresion des contrôles non performés */
  ) controles_unitaires
  group by id_gin_visite
), prescriptions_majeurs as (
  select sum(controles_unitaires.nombre_prescriptions_navire) as nombre_prescriptions_majeurs, controles_unitaires.id_gin_visite
  from (
    select GINA.GIN_VISITE.id_gin_visite,
        case GINA.GIN_RESULTAT_CONTROLE.IDC_GIN_RESULTAT_CONTROLE /* Changement dans les valeurs pour additionner facilement les prescriptions */
          when 1 then 0 /* n'arrive pas car filtré */
          when 2 then 0
          when 3 then 1
          when 4 then 1
          when 5 then 0
          when 6 then 0
          when 7 then 0
          when 8 then 0
          else 0
        end as nombre_prescriptions_navire
    from GINA.GIN_RESULTAT_CONTROLE
    left join  GINA.GIN_CODE_CONTROLE ON  GINA.GIN_CODE_CONTROLE.idc_gin_controle = GINA.GIN_RESULTAT_CONTROLE.idc_gin_controle
    left join GINA.GIN_VISITE on GINA.GIN_RESULTAT_CONTROLE.id_gin_visite =  GINA.GIN_VISITE.id_gin_visite
    where GINA.GIN_RESULTAT_CONTROLE.idc_gin_resultat_controle != 1 and GINA.GIN_CODE_CONTROLE.est_majeur = 1 and extract(year from GINA.GIN_VISITE.DATE_VISITE) > 2015 and (GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 3 or GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 2)
    /* Suppresion des contrôles non performés */
  ) controles_unitaires
  group by id_gin_visite
)

select NAVPRO.NAV_FLOTTEUR.id_nav_flotteur, GINA.GIN_VISITE.id_gin_visite, GINA.GIN_VISITE.date_visite, prescriptions.nombre_prescriptions, prescriptions_majeurs.nombre_prescriptions_majeurs
from GINA.GIN_VISITE
left join prescriptions on prescriptions.id_gin_visite = GINA.GIN_VISITE.id_gin_visite
left join prescriptions_majeurs on prescriptions_majeurs.id_gin_visite = GINA.GIN_VISITE.id_gin_visite
left join NAVPRO.NAV_FLOTTEUR on NAVPRO.NAV_FLOTTEUR.NUM_IMMAT_FRANCAIS = GINA.GIN_VISITE.num_immat 
where (GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 3 OR GINA.GIN_VISITE.IDC_GIN_TYPE_VISITE = 2)  and extract(year from GINA.GIN_VISITE.DATE_VISITE) > 2015/* visites periodiques */
