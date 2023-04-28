# Passage de CibNav V3 à CibNav V4 (printemps 2023)

Afin d'améliorer la compréhension du score, celui-ci a été transformé en fréquence de visite. Ainsi, Cibnav permet d'adapter la fréquence de visite en fonction du profil du navire.

* Transformation du score en fréquence de visite (recommandée et obligatoire)
* Ajout du paramètre catégorie de navigation
* Suppression du paramètre genre de navigation
* Suppression (temporaire) du paramètre nombre_de_sitrep en attendant le rétablissement de son connecteur
* Transformation du modèle Random Forest en Loi Poisson
* Modification de la prise en compte des variables historiques afin de limiter l'importance des événements anciens


# Passage de CibNav V2 à CibNav V3


CibNav V3 se situe dans la lignée de CibNav V2. L'objectif principal de ce modèle est d'améliorer son pouvoir prédictif.
La philosophie reste la même mais plusieurs évolutions sont à noter :

* La cible de prévision devient la probabilité d'avoir une prescription majeure ou au moins 4 non majeure et non plus seulement une prescription majeure.

[//]: # (Cette cible a été modifiée pour pallier l'hétérogénéité des types prescriptions et la classification biaisée entre prescription majeure et mineure)
* Ajouts de nombreuses nouvelles variables (cf la partie données).

* Une nouvelle fonction de pondération a été implémentée pour mieux prendre en compte les visites antérieures.

* Prise en compte des valeurs manquates.

[//]: # (Avant les bateaux n'ayant pas toutes les caractéristiques n'étaient pas pris en compte)
* Modification du modèle d'apprentissage statistique.

[//]: # (Eventuellement faire une doc technique ?)

# Passage de CibNav V1 à CibNav V2

L'évolution vers CibNav V2 se caractérise par deux éléments majeurs : 

* Nous considérons une visite de sécurité associée à un navire et non plus juste un navire

* Notre cible de prévision devient la probabilité d'une prescription majeure et non plus une note artificielle d'accidentologie.

* Simplification importante

* Meilleure prise en compte des données historiques (les données récentes pèsent plus que les anciennes)
* 
* Evaluation du modèle beaucoup plus simple à mettre en place.
