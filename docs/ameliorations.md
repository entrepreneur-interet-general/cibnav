# Pistes d'évolutions

## A) Modèle

### Annualisation du jeu de données

### Modification de la définition de l'accentologie

La définition chiffrée de l'accidentologie, base du modèle CibNav est actuellement définit par : Somme des Sitrep + Somme des AT. Cette définition peut-être repensée.

*Problèmes :*
1) Cette valeur est trop artificielle pour en extraire du sens. (quand un utilisateur voit une note sur l'écran d'accueil, il ne peut pas comprendre ce qu'il y a derrière)
2) L'ajout des AT est **peut-être** une perturbation et nuit à la qualité du ciblage. Nous ne sommes pas encore sûr que les visites de sécurité ont un impact sur le nombre d'AT, alors que nous sommes sûrs qu'elles ont un imact sur les SITREP.

*Solution proposée :*
Enlever les AT de la définition de l'accidentologie (ils pourront toujours être utilisé comme paramètre d'entrée pour la prévision). 

*Risques Potentiels :*
Rater les accidents ayant lieux aux ports, qui sont très nombreux pour la flotte de commerce (cf étude IMP).

*Action à mener :*
Etudier l'impact des visites de sécurité sur les AT.

### Normaliser par la moyenne des prescriptions


### Paramètres à ajouter    
- type de pêche principal
- ...

### Temporalité en paramètre


### Test
Une fois que les améliorations portées au modèle auront été implémentées, il faudra passer à la deuxième phase de test : une utilisation réelle par un panel d'utilisateurs.
Les utilisateurs devront utiliser CibNav pour planifier leur visites. Ainsi nous pourrons mesurer l'impact de CibNav.
Idéaelement le panel d'utilisateur sera composé d'une trentaine d'agents. Peut-être un CSN entier pour voir l'impact sur une flottille ? Où ne se baser que sur une flottille ?

### Visites aléatoires
Quelque soit la méthode de ciblage, il va falloir prévoir un certain pourcentage de visites aléatoires pour créer un réferentiel de visites indépendantes du ciblage. Grâce à cela, nous pourrons mesurer l'impact du ciblage et se prémunir d'éventuels profils non détectés par le ciblage.


## B) Guide Utilisateur
La documentation, malgrès sa vocation première, n'est pas adaptée pour les utilisateurs car elle est trop technique.
Il faut donc rédiger un guide utilisateur.



## C) Redevabilité
### Contestation du modèle
La contestation est un élément phare de la redevabilité des algorithmes publiques (devoir de rendre compte). Pour en arriver à cette étape, il faut s'assurer que le modèle a été  expliqué de façon intelligible.
Il pourra prendre la forme d'un bouton surlequel l'inspecteur clique quand il pense qu'un navire est mal ciblé (trop ou pas assez)### Aide à la décision ?
CibNav est un outil d'aide à la décision. Il a été développé pour. Pour autant, le sujet revient souvent : comment réellement créer un outil d'aide à la décision ? Quel impact aura une visite proposée par un inspecteur et non par l'outil ?
Il faut poser la question !

## D) Interface
### Afficher évolution score


