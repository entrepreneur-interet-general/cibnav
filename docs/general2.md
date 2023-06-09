# Présentation générale
::: tip Nouvelle version de CibNav
CibNav a évolué vers CibNav V4. 

Vous pouvez voir un résumé des modifications apportées et des motivations de CibNav V4 en cliquant [ici](./evolution_cibnav_v2.md#)
:::

Le logiciel CibNav est un outil d'aide à la décision pour la réalisation des visites de sécurité dites ciblées, 
(effectuées en application du décret n°84-810 modifié), via une identification des navires présentant la plus grande probabilité d'écart à la réglementation.

Cibnav est un logiciel basé sur des algorithmes alimentés par les données issues des visites de sécurité enregistrées sous la base de données Gina.

Son livrable est un tableau de bord pour les ISN listant les navires en fonction de leur priorité à réaliser une visite de sécurité.

Cette priorisation se fait à l'aide d'un modèle d'apprentissage statistique. 
Le principe d'un tel modèle est d'établir une règle de décision qui pourrait se traduire en termes simples de la sorte pour le fonctionnement de Cibnav :

> « Combien de prescriptions majeures y aurait-il si l'on réalisait une visite de sécurité un an après la précédente ? ».

Un rang de priorité est donné pour chaque navire, obtenu en calculant 
l'estimation de ce nombre de prescriptions majeures (appelé « score »), avec 
comme hypothèse sous-jacente qu'un navire pour lequel on s'attendrait à un 
plus grand nombre de prescriptions majeures serait prioritaire. Pour éviter 
que des navires récemment visités n'apparaissent comme prioritaire, ce rang 
est donc transformé en fréquence de visite recommandée plus ou moins élevée.
 
Cette règle au cœur du fonctionnement de l’algorithme a ainsi été choisie parce qu’elle permet de correspondre
 le mieux avec la définition d’un critère le plus commun avec l’approche généralement constatée lors de l’exercice 
 du jugement professionnel des ISNPRPM quant au niveau de sécurité de nature à limiter les titres de sécurité.
 
Bien entendu, le modèle fonctionne à partir d’éléments connus, analysés à 
partir d'exemples antérieurs.
 Ainsi, à l'aide de l'historique des données, notamment celles des prescriptions réalisées et enregistrées sous Gina depuis 2016, 
 la meilleure règle de prédiction permettant de décider de  classification des prochaines visites a été recherchée, 
 tout en veillant à se rapprocher de celle généralement mise en œuvre par un ISNPRPM.

Pour plus d'informations sur l'usage de CibNav au quotidien, se référer à la page [usage de CibNav pour les visites de sécurité](./usage-cibnav.md)

Si le sujet de l'apprentissage statistique vous intéresse, vous pouvez retrouver ce super article de vulgarisation à ce sujet sur le [blog binaire](https://www.lemonde.fr/blog/binaire/2017/10/20/jouez-avec-les-neurones-de-la-machine/).

Voici les deux éléments importants dans le cadre de notre classification :

1. [Les données](./donnees2.md) : les données utilisées dans le cadre de CibNav.

2. [Création du modèle](./algorithme2.md) : Comment avons nous aboutit au modèle considéré.

