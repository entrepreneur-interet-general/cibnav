# 4. Moteur de règles

## Fonctionnement
Le moteur de règle est une simplification de l'algorithme de machine learning. Les coefficients et les termes ont été choisis grâce aux [analyses de chaque paramètre](./analyse_securite.md#).

> **Coefficient** : Nombre qui définit l'importance d'un paramètre par rapport aux autres. Cette valeur est multipliée au terme.


> **Terme** : Nombre associé à la valeur ou la catégorie qu'un paramètre peut prendre. 


## Exemple
Prenons un navire de pêche français comme exemple. 

La vision de ce navire pour l'algorithme CibNav est :

|Paramètre| Valeur| Terme| Coefficient | Résultat paramètre |
| -------- | -------- | -------- | -------- | -------- |
| Genre de Navigation | *Pêche au large* | 12.2 | 11 | 12.2 * 11 = **134.2**|
| Type de carburant | *Gazole* | 1 | 9.1 | 1 * 9.1 = **9.1** |
| Nombre de Prescriptions dans les 5 dernières années | *14* | 0 | 8.8 | 0 * 8.8 = **0** |
| Longueur | *7.4 mètres* | 0 | 8.4 | 0 * 8.4 = **0** |
| Nombre de Prescriptions sur contrôles majeurs dans les 5 dernières années | *5* | 2 |8.1 | 2 * 8.1 = **16.2**|
| Puissance Propulsive | *75 kw* | 0 | 6.6 | 0 * 6.6 = **0** | 
| Annee de Construction | *1987* | 1 | 3.3 | 1 * 3.3 = **3.3** |

La note du navire se fait maintenant en additionnant tous les résultats des paramètres : 

> **134.2 + 9.1 + 0 + 0 + 16.2 + 0 + 3.3 = 162.8**

Pour une comparaison plus lisible entre les navires la note est enuite normalisée entre **0** (note minimum) et **1** (note maximum).

Voici toutes les règles régissants chaque paramètre avec toutes les valeurs que la note peut prendre :

## Règles 

| Paramètre |	Valeurs  |  Terme Correspondant | Coefficient Multiplicateur |
| -------- | -------- | -------- | -------- | -------- | 
| [Genre de navigation](./analyse_securite.md#genre-de-navigation) |  Pêche au large | 12.2 :outbox_tray:| 11 |
| [Genre de navigation](./analyse_securite.md#genre-de-navigation) |  Pêche côtière | 7 :outbox_tray:| 11 | 
| [Genre de navigation](./analyse_securite.md#genre-de-navigation) |  Autre (Navigation côtière, Pêche côtière...) | 0 | 11 |
| **---** |  **---** | **---** | **---** |
| [Type de carburant](./analyse_securite.md#type-de-carburant) |  Essence | -1 :inbox_tray:| 9.1 |
| [Type de carburant](./analyse_securite.md#type-de-carburant) |  Gazole | 1 :outbox_tray:| 9.1 |
| [Type de carburant](./analyse_securite.md#type-de-carburant) |  Autre | 0 | 9.1 |
| **---** |  **---** | **---** | **---** |
| [Prescriptions sur les contrôles](./analyse_securite.md#prescriptions-sur-tous-les-controles) | 0 <= Nombre de Prescriptions <= 10 | -0.5 :inbox_tray:| 8.8 |
| [Prescriptions sur les contrôles](./analyse_securite.md#prescriptions-sur-tous-les-controles) | 10 < Nombre de Prescriptions <= 15 | 0 | 8.8 |
| [Prescriptions sur les contrôles](./analyse_securite.md#prescriptions-sur-tous-les-controles) | 15 < Nombre de Prescriptions <= 30 | 1.7 :outbox_tray: | 8.8 |
| [Prescriptions sur les contrôles](./analyse_securite.md#prescriptions-sur-tous-les-controles) | 30 < Nombre de Prescriptions | 3 :outbox_tray:| 8.8 |
| **---** |  **---** | **---** | **---** |
| [Longueur](./analyse_securite.md#longueur) |   0 <= Longueur < 12 | 0 | 8.4 |
| [Longueur](./analyse_securite.md#longueur) |   12 <= Longueur | 3 :outbox_tray: | 8.4 |
| **---** |  **---** | **---** | **---** |
| [Prescriptions sur les contrôles majeurs](./analyse_securite.md#prescriptions-sur-les-controles-majeurs) |   0 <= Nombre de Prescriptions sur contrôles majeurs <= 2 | -0.5 :inbox_tray:| 8.1 |
| [Prescriptions sur les contrôles majeurs](./analyse_securite.md#prescriptions-sur-les-controles-majeurs) |   2 < Nombre de Prescriptions sur contrôles majeurs <= 4 | 0 | 8.1 |
| [Prescriptions sur les contrôles majeurs](./analyse_securite.md#prescriptions-sur-les-controles-majeurs) |  4 < Nombre de Prescriptions sur contrôles majeurs | 2 :outbox_tray:| 8.1 | 
| **---** |  **---** | **---** | **---** |
| [Puissance Propulsive](./analyse_securite.md#puissance-propulsive) |   0 <= Puissance Propulsive < 100| 0 | 6.6 |
| [Puissance Propulsive](./analyse_securite.md#puissance-propulsive) |   100 <= Puissance Propulsive | 1 :outbox_tray:| 6.6 |
| **---** |  **---** | **---** | **---** |
| [Année de construction](./analyse_securite.md#annee-de-construction) |   Année de Construction <= 1990  | 1 :outbox_tray:| 3.3 |
| [Année de construction](./analyse_securite.md#annee-de-construction) |   1990 < Année de Construction < 2013 | 0 | 3.3 |
| [Année de construction](./analyse_securite.md#annee-de-construction) |   2013 <= Année de Construction  | -2.5 :inbox_tray:| 3.3 |
