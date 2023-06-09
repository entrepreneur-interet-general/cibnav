# Données

Les données sont le fuel du modèle :fuelpump:.

Le principe est de simuler par calcul, chaque jour, les conséquences d'une visite de sécurité réalisée sur chaque navire.

Dans le projet CibNav, nous avons créé un historique des visites de sécurité 
en renseignant des données pertinentes pour la prévision.

Voici un exemple d'une entrée indiquant les éléments constitutifs pris en compte pour chaque navire :

| Paramètre                          | Valeur             | Commentaire                                                                                                                                                                                                               |
| ---                                | ---                | ---                                                                                                                                                                                                                       |
| Âge                                | 38                 | Âge du navire lors de la visite                                                                                                                                                                                           |
| Genre Navigation                   | Navigation côtière |                                                                                                                                                                                                                           |
| Jauge Oslo                         | 7.56               |                                                                                                                                                                                                                           |
| Longueur Hors Tout                 | 8.07               |                                                                                                                                                                                                                           |
| Materiau Coque                     | METAL              |                                                                                                                                                                                                                           |
| Nombre Moteur                      | 2                  |                                                                                                                                                                                                                           |
| Puissance Administrative           | 147.0              |                                                                                                                                                                                                                           |
| Situation Flotteur                 | Français Commerce  |                                                                                                                                                                                                                           |
| Type Moteur                        | Explosion          |                                                                                                                                                                                                                           
|
| Nombre Prescriptions Hist          | 4                  | Nombre de prescriptions lors de la dernière visite périodique |
| Nombre Prescriptions Majeures Hist | 0.2                | Nombre de prescriptions majeur de la dernière visite périodique|

Ces données sont ensuite injectées dans le modèle, dont l’algorithme de 
fonctionnement est déterminé selon son adaptation à la nature de la prédiction 
souhaitée.
