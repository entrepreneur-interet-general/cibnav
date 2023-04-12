---
pageClass: full_page
---

::: warning Travail en cours
Les contrôles présentés ici ont été elaborés au sein du projet CibNav avec les bureau GM3. Pour des raisons de calendrier et de modules techniques manquants, ces contrôles seront implémentés plus tard (horizon milieu 2020). Ces implémentations dépendront notamment du bon fonctionnement du ciblage des visites de sécurité. Nous vous laissons les contrôles à titre informatif. 
:::

# Contrôles Gens de Mer 

## Vue Générale
| Infraction / Risque  | Contrôle  | Priorité dans le développement de l'outil (1-3) | Données | Source des données   | Proprietaire des données | Description de l'algorithme  |
| --- | --- | --- | --- | --- | --- | --- | --- |
| [Navigation avec PA invalide](./controles_gens_de_mer.md#permis-d-armement-invalide)  | Contrôle automatique avec ou sans croisement : PA retiré ou suspendu par l'administration (pas de croisement) Pa actif dans le SI mais un des titres le constituant est échu| 1   | Statut PA  Validité des titres constitutifs du PA         | NAVPRO/ GINA         | DAM  | SI PA : suspendu/ retiré : alerte  SI PA valide mais PME échu/retiré ou PN échu/retiré : alerte  |
| Le fait d'admettre à bord un membre de l'équipage ne disposant pas des qualifications adéquates au pont et pour les soins médicaux (délit)       | Contrôle automatique fait par l'outil, qui alerte l'agent.     Position par rapport aux qualifications détenues par les marins limitées par la distance des côtes (brevets pont, EM...)  | 2  | Position navire  Qualifications détenues par le marin Déclarations sociales       | Spationav Lise/outil-DSN Item    | DAM  | Si un marin est déclaré sur un navire qui navigue plus loin que les limites de ses qualifications : alerte.    |
| Le fait d'admettre à bord un membre de l'équipage ne disposant pas des qualifications adéquates par rapport aux caractéristiques du navire (jauge, puissance nominale...) | Contrôle automatique fait par l'outil, qui alerte l'agent.     Comparaison des caractéristiques du navire et des qualifications détenues par les marins.        | 3  | Puissance du navire Jauge Caractéristiques comme : HSC, GNL, IGF... Qualifications détenues par le marin Déclarations sociales    | GINA Lise/outil-DSN Item         | DAM | Alerte         |
| Le fait d'admettre à bord un membre de l'équipage ne disposant pas des qualifications adéquates par rapport à l'intitulé de la fonction déclarée (délit)     | Contrôle automatique fait par l'outil, qui alerte l'agent.     Comparaison entre fonction déclarée socialement et les qualifications détenues       | 1  | Fonctions déclarées Qualifications du marin   | Lise/outil-DSN Item  | DAM   | Alerte         |
| Le fait de naviguer avec un effectif inférieur à celui prévu par la fiche d'effectif minimal annexée au permis d'armement    | Contrôle automatique, Alerte  Croisement entre le nombre de marins embarqués (ne concernent pas les gens de mer autres que marins) renseignés dans DTA (à terme, DSN) et FE dans NAVPRO  | 1  | Fonctions déclarées dans NAVPRO (via PDA) pour constitution fiche d’effectif minimal  Déclarations sociales portant sur le navire (liste d’équipage à l’instant t) | NAVPRO/ Lise (à l'heure actuelle)        | DAM  | Si nombre de marins dans Lise < au nombre de fonctions renseignées dans NAVPRO : alerte        |
| Navire peu contrôlé à bord duquel un nombre X de plaintes a pourtant été déposé      | Croisement entre le nombre de plaintes déposées et le nombre de rapports d'inspection portant sur le navire     | 3  | Plaintes / rapports d'inspection  | GINA (plaintes, développement qui devrait avoir lieu dans le futur) / Outil de rapports en cours de développement | DAM  | Si nombre de plaintes X fois supérieur au nombre de rapports : alerte (par exemple 5 plainte pour un rapport d'inspection)  Voir s'il ne faut pas inclure une période d'évaluation. |


## Permis d'Armement invalide
[Lien légifrance sur le permis d'armement](https://www.legifrance.gouv.fr/affichTexte.do?cidTexte=JORFTEXT000034674552&categorieLien=id)

[Lien Ministère sur le permis d'armement](https://www.ecologique-solidaire.gouv.fr/armement-dun-navire-professionnel)

Le permis d'armement (appelé PA ensuite) est un titre de navigation. Tout navire professionnel ayant a son bord des marins doit avoir ce titre à jour.  

Le contrôle sur le PA, vérifie dans les donnés des Affaires Maritimes si un navire professionnel actif possède au moins un PA valide (pêche/culture ou commerce)/
Si ca n'est pas le cas, c'est à dire, si le navire ne possède aucun PA valide, le navire est signalé aux agents et est consideré comme prioritaire pour les contrôles. 

