# 1. Accidentologie

## Général 
Les informations utilisées pour définir l'accidentologie sont les [SITREP](https://www.data.gouv.fr/fr/datasets/operations-coordonnees-par-les-cross/) et les accidents de travail. La combinaison des ces deux informations nous donne un indicateur d'accidentologie couvrant une large représentation de l'accidentologie maritime. 


Notre étude consiste à **prédire cette note**.

> **Pourquoi prédire cette note et ne pas simplement la calculer ?**
>
> Nous pourrions en effet calculer cette note. Nous avons tout ce qu'il nous faut ! Cependant nous passerions à côté d'informations très intéressantes. Grâce à a la prévision, nous travaillons sur des tendances et non plus que sur des cas isolés. Nous avons également la possibilité de prédire une note sur un navire que nous connaissons moins bien (ex: navire importé). 
> 
> Enfin, cela nous donne la possibilité d'utiliser d'autres données qui sont correlés avec l'accidentologie pour améliorer la robustesse du modèle.



## Filtres sur les SITREPS

Pour affiner notre définition de l'accidentologie, nous avons filtrés les SITREPS pris en compte :


1. **Types:** SAR (Search And Rescue) et MAS (Maritime Assistance)
2. **Résultats:** Tous sauf les fausses alertes
3. **Evénements:** voir détails dans le [tableau ci dessous](./accidentologie.md#evenements-pris-en-compte)

|Nom de l'événement|Pris en compte|
|---|---|
|Abordage|Oui|
|Absence d'un moyen de communication|Oui|
|Accident aéronautique|Non|
|Accident en mer|Oui|
|Acte de piraterie / terrorisme|Non|
|Autre accident|Oui|
|Autre événement|Oui|
|Avarie de l'appareil à gouverner|Oui|
|Avarie des systèmes de communication|Oui|
|Avarie du système de propulsion|Oui|
|Avarie électrique|Oui|
|Baignade|Non|
|Blessé EvaMed|Oui|
|Blessé EvaSan|Oui|
|Blessé avec déroutement|Oui|
|Blessé avec soin sans déroutement|Oui|
|Blessé projection d'une équipe médicale|Oui|
|Chasse sous-marine|Non|
|Chavirement|Oui|
|Chute falaise / Emporté par une lame|Oui|
|Difficulté de manoeuvre|Oui|
|Disparu en mer|Oui|
|Découverte d'explosif|Oui|
|Découverte de corps|Oui|
|Démâtage|Oui|
|Désarrimage cargaison|Oui|
|Encalminage|Oui|
|Explosif dans engin|Oui|
|Explosion|Oui|
|Heurt|Oui|
|Homme à la mer|Oui|
|Immobilisé dans engins / hélice engagée|Oui|
|Incendie|Oui|
|Incertitude|Oui|
|Incertitude sur la position|Oui|
|Isolement par la marée / Envasé|Non|
|Loisir nautique|Oui|
|Malade EvaMed|Oui|
|Malade EvaSan|Oui|
|Malade avec déroutement|Oui|
|Malade avec soin sans déroutement|Oui|
|Malade projection d'une équipe médicale|Oui|
|Panne de carburant|Oui|
|Perte de pontée|Oui|
|Perte de stabilité / Ripage de cargaison|Oui|
|Plongée avec bouteille|Oui|
|Plongée en apnée|Oui|
|Rupture de mouillage|Oui|
|Sans avarie en dérive|Oui|
|Sans avarie inexpérience|Oui|
|Ski nautique|Oui|
|Suicide|Oui|
|Toutes fausses alertes|Oui|
|Transport sanitaire île-continent|Non|
|Voie d'eau|Oui|
|Échouement|Oui|
