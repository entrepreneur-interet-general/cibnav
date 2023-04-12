# Le modèle

## Comment choisir un modèle

Il existe une multitude d'algorithmes permettant de réaliser une classification binaire, classification jugée la plus proche de l’objectif recherché pour la prédiction de Cibnav.
 C’est-à-dire qu’ une multitude de méthodes permet de ranger les navires dans les deux catégories qui nous intéresse à savoir :
- Ceux susceptibles d'avoir au moins une prescription majeure et/ou au moins 4 prescriptions non majeures (la catégorie 1 que l'on dira ciblée) 
- les autres (la catégorie 0 que l'on dira non ciblée).

Dans CibNav, chaque navire est classé selon sa probabilité d'appartenir à la classe 1 (ciblée) : 
si le modèle prédit que le navire A possède 90% de probabilité d'être ciblé (au sens ci-dessus),
 il sera affiché avant un navire B qui lui possède une probabilité de 80%.
 
La question qui se pose légitimement est de savoir comment avons-nous fait pour 
sélectionner un algorithme parmi la multitude de choix possible ?



Ici nous avons séparé notre base de données en deux : les visites de l'années 2021 et les autres visites antérieures. Nous avons entrainé plusieurs modèles sur les visites de 2015 à 2021. Nous avons ensuite essayé de prédire les visites de de l'année 2021 et nous avons comparé avec ce qui s'est effectivement produit en 2021.

Il faut savoir qu'il n'y a pas une manière unique d'évaluer l'efficacité d'un modèle.
Une manière classique est de comparer les **matrices de confusion** qui comparent les prédictions de l'algorithme à la réalité.
Ces dernières se présentent de la façon suivante : 

|  | Prévision Navire à cibler (au moins une prescription majeure et/ou au moins de 4 prescriptions) |  Prévision Navire à ne pas cibler (pas de prescription majeure et moins de 3 prescriptions) |
| --- | --- | --- |
| Navire à **cibler** (le navire avait au moins une prescription majeure ou au moins 4 prescriptions lors de la visite) | **Vrai Positifs** | **Faux Négatifs** |
| Navire à **ne pas cibler** (pas de prescription majeure et moins de 3 prescriptions lors de la visite) | **Faux Positifs** | **Vrai Négatifs** |

Par exemple, si nous classons les visites au hasard en suivant la proportion de visites ayant abouti à 
au moins une prescription majeure et/ou au moins quatre prescriptions non-majeures (on dira que le **navire est à cibler**) nous obtenons sur les 23 704 visites considérées :

|  | Prévision Navire à cibler  |  Prévision Navire à ne pas cibler |
| --- | --- | --- |
| Navire à **cibler** | **1636** (29%) | **1487** (26%) |
| Navire à **ne pas cibler** | **1367** (24%) | **1166** (21%) |

Pour 2021 nous obtenons la matrice suivante :

|  | Prévision Navire à cibler  |  Prévision Navire à ne pas cibler |
| --- | --- | --- |
| Navire à **cibler** | **2889** (51%) | **2295** (41%) |
| Navire à **ne pas cibler** | **114** (2%) | **358** (6%) |


Nous pouvons voir en comparant ces deux matrices que notre modèle fait mieux que le hasard :
- Il prédit correctement plus de visites donnant lieu à prescription
- Il est plus précis, avec un taux de prédictions correctes `accuracy score` supérieur à 57% et un `balanced accuracy score` à 66% pour CibNav contre 51% pour le hasard. Cette dernière évaluation prend en compte une répartition inégale des classes, elle est calculée via la formule `(Spécificité + Sensibilité)/2`. 
- Il fait cependant plus d'erreur de faux négatifs. Autrement dit, il classe 2295 navires comme n'ayant pas besoin de visite alors que le navire a des anomalies qui devraient engendrer des prescriptions lors d'une visite. 

L'enjeu étant de limiter ce taux de faux négatifs, nous nous attachons à améliorer la `Sensibilité` (`Vrai Positifs/(Vrai Positifs + Faux Négatifs)`) associée au modèle sans toutefois trop détériorer la probabilité qu’un navire n’appartienne pas à la classe Navire à cibler à juste titre. Pour le test effectué sur l'année 2021 nous obtenons une `Sensibilité` de 56%.

## Le modèle de prédiction utilisé : la forêt aléatoire

L'algorithme ici considéré est issu de la famille des forêts aléatoire (ou *random forest* en anglais).

### De l'arbre...
L'idée est de construire plusieurs arbres de décisions et de les aggréger.



Un arbres de décision peut être représenté de la manière suivante :
</center>
![Arbre de décision](Arbre_de_décision.png)
</center>
Pour chaque observation nous suivons les différentes règles de décisions jusqu'à aboutir à une classification. 

Par exemple ici, nous essayons de prédire si une personne à ou non du cholestérol. 
Si l'on prend un individu pesant 87 kg et n'étant pas cardiaque :
À la question : son poids est-il supérieur à 120 kg nous répondons non, nous allons donc vers le noeud correspondant qui est de savoir si notre individu est cardiaque ou non.
Comme ce n'est pas la cas, la règle de décision nous indique que notre homme n'a donc pas de cholestérol.



### ...À la forêt
Le problème des arbres de décision simples est qu’ils ne sont pas très efficaces 
et qu’ils sont peu robustes aux changements sur les données. Autrement dit, l'arbre
 a de forte chances d'être complètement différent si l'on change les données sur 
 lesquelles il a été entraîné, or il devrait rester stable indépendamment des données
 sur lesquelles il apprend pour être fiable.
 
 Pour pallier ce problème, nous pouvons agréger plusieurs arbres de décision et faire une forme de votes de leurs prédictions respectives pour obtenir la prédiction 
 finale la plus fiable et robuste possible. Pour ce faire, nous créons une multitude
 d'arbres (plusieurs centaines) à partir de sous-échantillons de nos données initiales. 
 Et pour chaque navire nous prenons le vote majoritaire pour chaque arbre. 
 C'est ce qu'on appelle une forêt aléatoire.
 
 Par exemple, si sur 100 arbres, 58 prédisent que le navire est ciblé alors nous considérerons ce dernier comme ciblé. À l'inverse, si 21/100 prédisent qu’il sera
 ciblé alors nous le considérons comme non-ciblé. Cela donne de meilleurs résultats que les arbres de décisions classiques 
 et permet des modélisations plus robustes aux données.
 
 Cependant ils ne permettent pas de mettre en lumière de manière claire les règles de décisions ayant aboutit à
 la classification (contrairement à un arbre de décision simple) ce qui limite un peu son interprétabilité.

Vous pouvez en apprendre plus sur les arbres de décisions sur [wikipedia](https://fr.wikipedia.org/wiki/Arbre_de_d%C3%A9cision)
ou pour les anglophones sur la chaîne de [Statquest](https://www.youtube.com/watch?v=7VeUPuFGJHk)

## Identification des caractéristiques les plus importantes pour le modèle

Comme expliqué plus haut, il est difficile de rendre interprétables, les décisions prises par un modèle de type Random Forest. Il est cependant possible d’utiliser une fonction permettant d’identifier les caractéristiques les plus importantes pour les prédictions du modèle. Le calcul de l’importance d’une caractéristique repose sur l’indice de Gini. 


Ainsi pour Cibnav on identifie en suivant, les 10 caractéristiques les plus influentes :
<p align="center">
  <img src="features_importances_top10.png">
</p>
Remarque : Au vue de ce classement, il est important de rappeler que la caractéristique 'Num Version' correspond au nombre de modifications enregistrées sur GINA.

## Les autres algorithmes envisagés

Pour sélectionner notre modèle nous ne nous sommes pas contenté de le comparer avec le hasard. 
Nous l'avons aussi mi en compétition avec une multitude d'autres algorithmes.
Ainsi, nous avons testé des forêts aléatoires avec différents paramètres (comme par exemple la taille des arbres, le critère de décision) mais 
aussi d'autres familles d'algorithmes comme des **arbres de décisions** simples, des **régressions** ou encore des **réseaux de neurones**.

Pour choisir le meilleur modèle nous observons celui qui a le meilleur score final.
Ici, nous avons choisi un score qui privilégie les modèles faisant peu de faux négatifs et c'est la **forêt aléatoire** utilisée dans CibNav V3 qui a été sélectionnée.

Nous utilisons ici modèle et algorithme de manière indifférenciée.
