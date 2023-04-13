# Données

Les données sont le fuel du modèle :fuelpump:.

Le principe est de simuler par calcul, chaque jour, les conséquences d'une visite de sécurité réalisée sur chaque navire.

Dans le projet CibNav, nous avons créé un historique des visites de sécurité 
en renseignant des données pertinentes pour la prévision.

Voici un exemple d'une entrée indiquant les éléments constitutifs pris en compte pour chaque navire :

| Paramètre | Valeur | Commentaire |
| --- |  --- | --- |
| Âge | 38 | Âge du navire lors de la visite|
| Année Visite | 2020 | |
| Délai Visite | 431 | Délai depuis la dernière visite (en jours) |
| Genre Navigation | Navigation côtière | |
| Jauge Oslo | 7.56 | |
| Longueur Hors Tout | 8.07 | |
| Materiau Coque | METAL | |
| Nombre Moteur | 2 | |
| Num Version | 2 | Nombre de modification dans GINA|
| Puissance Administrative | 147.0 | |
| Situation Flotteur | Français Commerce | |
| Type Carburant | ESSENCE | |
| Type Moteur | Explosion | |
| Nombre Prescriptions Hist | 4 | Somme pondérée de l'ensemble des prescriptions en fonction du rang d'antériorité de la visite (la dernière visite peu avoir un poids différent de la précédente, qui peut avoir un poids différent de celle d'avant, ...) |
| Nombre Prescriptions Majeures Hist | 0.2 | Somme pondérée des prescriptions majeur (même principe que ci-dessus) |
| Sitrep History | 0  | Moyenne sur les 5 dernières années du nombre de SitRep |

Une fonction de pondération de l'historique des visites du navire est utilisé pour moduler son influence selon le type de prescription (majeure/ non- majeure) et l'ancienneté de la prescription, 
il est introduit dans `Nombre Prescriptions Hist` et `Nombre Prescriptions Majeures Hist`. 

Une fonction de pondération de l'historique des visites du navire est utilisée pour moduler son influence selon 
le type de prescription (majeure/ non- majeure) et l'ancienneté de la prescription, 
il est introduit dans `Nombre Prescriptions Hist` et `Nombre Prescriptions Majeures Hist`. 

Ces données sont ensuite injectées dans le modèle, dont l’algorithme de fonctionnement est déterminé 
selon son adaptation à la nature de la prédiction souhaitée.
