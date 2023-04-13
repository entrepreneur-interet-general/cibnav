---
pageClass: full_page
---

# Modèle de données

### Navire

- Clé primaire : `id_nav_flotteur`


|Nom|Titre|Type|Description|Exemple|Propriétés|
|-|-|-|-|-|-|
|id_nav_flotteur|Identifiant Navire Flotteur|int|Identifiant unique pour un même navire quels que soient les événements au cours de sa vie|1001|Valeur obligatoire|
|num_immat_francais|Numéro Immatriculation Française|text|6 chiffres d'immatriculation professionnelle française 1 lettre et cinq chiffres pour les navires immatriculés en plaisance. Si le navire de plaisance vient à passer en professionnel, il prend un numéro définitif à 6 chiffres.|762413 (Navigation Professionnelle) A62413 (Plaisance)|Valeur obligatoire|
|nom_navire|Nom du Navire|text|Nom utilisé pour identifier un navire. Ce champ n'est pas unique et peut changer (notamment lors d'un changemement de propriétaire|Houba Houba|Valeur obligatoire|
|numero_mmsi|Numéro MMSI|text|Série de 9 chiffres définissants l'identité radiophonique d'un navire|247594000|Valeur obligatoire|
|situation_flotteur|Situation flotteur|text|Qui ce sert de cette données ?|Français peche|Valeur obligatoire|
|statut_flotteur|Statut flotteur|text|Le statut définit si un navire est encore actif ou non. Les navires inactifs ne sont pas ciblés mais ils sont utiles pour créer le modèle|actif|Valeur obligatoire|
|chantier_construction|Chantier construction|text| - |CHANTIER NAVAL TARIN|Valeur optionnelle|
|annee_construction|Année de Construction|double precision| -  |1989|Valeur obligatoire|
|puissance_propulsive|Puissance Propulsive|double precision|Puissance propulsive en kW| - | Valeur optionnelle|
|longueur_hors_tout|Longueur Hors Tout|double precision|Distance entre les points extrêmes avant et arrière de la structure permanente du bateau|11.9|Valeur obligatoire|
|statut_pa_peche_culture|Statut permis d'armement pêche/culture marine|double precision|cf permis d'armement|6|Valeur obligatoire|
|lib_statut_pa_peche_culture|Libellé statut permis d'armement pêche/culture marine|text|Suspendu|Valeur obligatoire|
|date_debut_pa_peche_culture|Date début permis d'armement pêche/culture marine|date|Date de début après nouvelle demande de permis d'armement. Si la date est le 01 janvier 2018, le permis d'armement a été attribué automatiquement.|2018/06/29|Valeur obligatoire|
|date_fin_pa_peche_culture|Date fin permis d'armement pêche/culture marine|date|Les permis d'armement ayant une date de fin sont ceux a durée limité, ou ceux qui ont été suspendus|2018/07/31|Valeur optionnelle|
|statut_pa_commerce|Statut permis d'armement|double precision|cf permis d'armement|2|Valeur obligatoire|
|date_debut_pa_commerce|Date début permis d'armement commerce|date||2018/07/31|Valeur obligatoire|
|date_fin_pa_commerce|Date fin permis d'armement commerce|date||2018/07/31|Valeur obligatoire|
|lib_statut_pa_commerce|Libellé statut permis d'armement commerce|text|||Valeur obligatoire|
|num_version| Numéro version|double precision|||Valeur obligatoire|
|idc_gin_statut_activite|Code du statut d'activité|double precision|||Valeur obligatoire|
|idc_gin_centre_secu_delegue|Code du Centre de Sécurité Délégué|double precision|||Valeur obligatoire|
|idc_gin_division_secu|Code de la division de sécurité|double precision||Valeur obligatoire|
|centre_secu_gestion|Centre sécurité gestionnaire|text|Un centre de sécurité est un service régional de la prévention des risques professionnels maritimes. Il a pour tâche principale la visite de navires professionnels français qui doivent être titulaires d’un permis de navigation (titre de sécurité).|CSN Caen|Valeur obligatoire|
|expiration_franc_bord| Expiration du Franc-Bord|text|||Valeur obligatoire|
|etat_certificat| Etat du certificat|double precision|Etat du certificat de franc-bord||Valeur obligatoire|
|genre_navigation|Genre Navigation|text||CI-CABOTAGE INTERNATIONAL|Valeur obligatoire|


### Avis ciblage

- Clé primaire : `id_avis_ciblage`


|Nom|Titre|Type|Description|Exemple|Propriétés|
|-|-|-|-|-|-|
|id_avis_ciblage| Identifiant de l'avis ciblage |int| Identifiant unique et pérenne de l'avis | 181010 | Valeur obligatoire |
|id_nav_flotteur| Identifiant Navire Flotteur |int| Identifiant unique et pérenne du navire concerné | 182716 | Valeur obligatoire |
|date_ajout| Date d'ajout|date|Date d'ajout de l'avis du commentaire. |12-12-2019|Valeur obligatoire - Ajout automatique par l'application|
|note|Note sur le ciblage|int (catégorie)|L'inspecteur note le ciblage après une visite en choisissant une note parmis 5 options {-2: Note Beaucoup trop importante, -1:  Note trop importante, 0: Note juste, 1: Note pas assez importante, 2: Note vraiment pas assez importante}|1|Valeur obligatoire|
|commentaire|Commentaire |str|Commentaire sur l'avis. Ce champs permettre de tester de nouveaux paramètres | vetusté , nbre de presciptions, suspension du PN|Valeur facultative|
|nom|Nom|str|Identifiant unique pour un même navire quels que soient les événements au cours de sa vie|Dupont|Valeur obligatoire|
|prenom|Prénom|str|Identifiant unique pour un même navire quels que soient les événements au cours de sa vie|Paul|Valeur obligatoire|
|organisme|Organisme|str|Organisme de l'inspecteur ayant completé l'avis|CSN Caen|Valeur obligatoire|

### Lignes de services

- Clé primaire : `id_avis_ciblage`

|Nom|Titre|Type|Description|Exemple|Propriétés|
|-|-|-|-|-|-|
|id_lis_ligne_service| Identifiant de l'avis ciblage |int| Identifiant unique et pérenne de l'avis | 181010 | Valeur obligatoire  |
|date_debut| Date début |date| Date du début de la ligne de service | 2018/07/31 | Valeur obligatoire  |
|date_fin| Date fin |date| Date de fin de la ligne de service | 2018/07/31 | Valeur obligatoire  |
|id_adm_employe| Identifiant Administré Employé |int| Identifiant unique de l'employe| 456872 | Valeur obligatoire  |
|id_adm_employeur| Identifiant Administré Employeur |int| Identifiant unique de l'employeur| 456872 | Valeur obligatoire  |


### Turn Over

- Clé primaire : `id_nav_flotteur`

|Nom|Titre|Type|Description|Exemple|Propriétés|
|-|-|-|-|-|-|
|id_nav_flotteur| Identifiant Navire Flotteur |int| Identifiant unique et pérenne du navire concerné | 182716 | Valeur obligatoire |
|turn_over| Taux de renouvellement - Turn over |float - [0,1]| Taux de renouvellement de l'équipage moyenné sur les 3 dernières années - [Détails du calcul](./analyse_securite.md#turn-over-equipage) | 0.7 | Valeur obligatoire |

### Score

- Clé primaire : `id_nav_flotteur`

|Nom|Titre|Type|Description|Exemple|Propriétés|
|-|-|-|-|-|-|
|id_nav_flotteur| Identifiant Navire Flotteur |int| Identifiant unique et pérenne du navire concerné | 182716 | Valeur obligatoire |
|date| Date ajout dans la base |date| Date à laquelle ce score a été calculé et inseré | 2018/07/31 | Valeur obligatoire |
|score| Score total |float| Score total du navire. Correspond à la somme de tous les autres scores | 0.8 | Valeur obligatoire |
|score_annee_contruction| Score Année Construction |float|  | 0.8 | Valeur obligatoire |
|score_genre_navigation| Score Genre Navigation |float|  | 0.8 | Valeur obligatoire |
|score_longueur_hors_tout| Score Longueur Hors Tout |float|  | 0.8 | Valeur obligatoire |
|score_nombre_prescriptions| Score Nombre Prescriptions |float|  | 0.8 | Valeur obligatoire |
|score_nombre_prescriptions_majeurs| Score Nombre Prescriptions Majeurs |float|  | 0.8 | Valeur obligatoire |
|score_origine| Score Origine |float|  | 0.8 | Valeur obligatoire |
|score_type_carburant| Score Type Carburant |float|  | 0.8 | Valeur obligatoire |
