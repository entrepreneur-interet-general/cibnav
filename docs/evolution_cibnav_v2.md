# Passage de CibNav V2 à CibNav V3


CibNav V3 se situe dans la lignée de CibNav V2. L'objectif principal de ce modèle est d'améliorer son pouvoir prédictif.
La philosophie reste la même mais plusieurs évolutions sont à noter :

1- La cible de prévision devient la probabilité d'avoir une prescription majeure ou au moins 4 non majeure et non plus seulement une prescription majeure.

[//]: # (Cette cible a été modifiée pour pallier l'hétérogénéité des types prescriptions et la classification biaisée entre prescription majeure et mineure)
2- Ajouts de nombreuses nouvelles variables (cf la partie données).

3- Une nouvelle fonction de pondération a été implémentée pour mieux prendre en compte les visites antérieures.

4- Prise en compte des valeurs manquates.

[//]: # (Avant les bateaux n'ayant pas toutes les caractéristiques n'étaient pas pris en compte)
5- Modification du modèle d'apprentissage statistique.

[//]: # (Eventuellement faire une doc technique ?)

# Passage de CibNav V1 à CibNav V2

L'évolution vers CibNav V2 se caractérise par deux éléments majeurs : 

1- Nous considérons une visite de sécurité associée à un navire et non plus juste un navire

2- Notre cible de prévision devient la probabilité d'une prescription majeure et non plus une note artificielle d'accidentologie.

3- Simplification importante

4- Meilleure prise en compte des données historiques (les données récentes pèsent plus que les anciennes)

5- Evaluation du modèle beaucoup plus simple à mettre en place.
