# Le modèle

## Comment choisir un modèle

Nous choisissons d'essayer d'estimer le nombre futur de *prescriptions 
majeures*, comme proxy à la priorité à donner à la visite d'un navire plutôt 
qu'un autre. Il s'agit d'un problème de régression, car l'estimation est une estimation 
numérique. 

La question qui se pose légitimement est de savoir comment avons-nous fait 
pour sélectionner un algorithme parmi la multitude de choix possible ?

Ici nous avons séparé notre base de données en deux : les visites de l'années 
2021 et les autres visites antérieures. Nous avons entrainé plusieurs modèles 
sur les visites de 2015 à 2020. Nous avons ensuite essayé de prédire les 
visites de de l'année 2021 et nous avons comparé avec ce qui s'est 
effectivement produit en 2021.

La mesure de la pertinence du modèle s'est faite selon deux critères :

- une métrique d'évaluation qui mesure l'écart des prédictions aux 
  observations.
- la capacité du modèle à fournir des éléments d'explication fiables quant à 
  sa prédiction (selon notre apprèciation personnelle). 

## Le modèle de prédiction utilisé : la régression de Poisson

L'algorithme ici considéré est issu de la famille des modèles linéaires 
généralisés, modèles statistiques couramment utilisés. 

Plus précisément, c'est une régression de Poisson que nous réalison, modèle 
adapté aux prédictions de comptages. Le modèle négatif binomial pourra être 
considéré dans le futur comme une alternative intéressante. 

Ces modèles sont additifs, c'est-à-dire que les contributions individuelles de 
chaque facteur à la prévision finale ne dépend pas des autres facteurs. Cela 
permet une grande transparence du fonctionnement du modèle. 

