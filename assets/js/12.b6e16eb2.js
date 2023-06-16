(window.webpackJsonp=window.webpackJsonp||[]).push([[12],{293:function(e,s,n){"use strict";n.r(s);var i=n(14),t=Object(i.a)({},(function(){var e=this,s=e._self._c;return s("ContentSlotsDistributor",{attrs:{"slot-key":e.$parent.slotKey}},[s("h1",{attrs:{id:"le-modele"}},[s("a",{staticClass:"header-anchor",attrs:{href:"#le-modele"}},[e._v("#")]),e._v(" Le modèle")]),e._v(" "),s("h2",{attrs:{id:"comment-choisir-un-modele"}},[s("a",{staticClass:"header-anchor",attrs:{href:"#comment-choisir-un-modele"}},[e._v("#")]),e._v(" Comment choisir un modèle")]),e._v(" "),s("p",[e._v("Nous choisissons d'essayer d'estimer le nombre futur de "),s("em",[e._v("prescriptions\nmajeures")]),e._v(", comme proxy à la priorité à donner à la visite d'un navire plutôt\nqu'un autre. Il s'agit d'un problème de régression, car l'estimation est une estimation\nnumérique.")]),e._v(" "),s("p",[e._v("La question qui se pose légitimement est de savoir comment avons-nous fait\npour sélectionner un algorithme parmi la multitude de choix possible ?")]),e._v(" "),s("p",[e._v("Ici nous avons séparé notre base de données en deux : les visites de l'années\n2021 et les autres visites antérieures. Nous avons entrainé plusieurs modèles\nsur les visites de 2015 à 2020. Nous avons ensuite essayé de prédire les\nvisites de de l'année 2021 et nous avons comparé avec ce qui s'est\neffectivement produit en 2021.")]),e._v(" "),s("p",[e._v("La mesure de la pertinence du modèle s'est faite selon deux critères :")]),e._v(" "),s("ul",[s("li",[e._v("une métrique d'évaluation qui mesure l'écart des prédictions aux\nobservations.")]),e._v(" "),s("li",[e._v("la capacité du modèle à fournir des éléments d'explication fiables quant à\nsa prédiction (selon notre apprèciation personnelle).")])]),e._v(" "),s("h2",{attrs:{id:"le-modele-de-prediction-utilise-la-regression-de-poisson"}},[s("a",{staticClass:"header-anchor",attrs:{href:"#le-modele-de-prediction-utilise-la-regression-de-poisson"}},[e._v("#")]),e._v(" Le modèle de prédiction utilisé : la régression de Poisson")]),e._v(" "),s("p",[e._v("L'algorithme ici considéré est issu de la famille des modèles linéaires\ngénéralisés, modèles statistiques couramment utilisés.")]),e._v(" "),s("p",[e._v("Plus précisément, c'est une régression de Poisson que nous réalison, modèle\nadapté aux prédictions de comptages. Le modèle négatif binomial pourra être\nconsidéré dans le futur comme une alternative intéressante.")]),e._v(" "),s("p",[e._v("Ces modèles sont additifs, c'est-à-dire que les contributions individuelles de\nchaque facteur à la prévision finale ne dépend pas des autres facteurs. Cela\npermet une grande transparence du fonctionnement du modèle.")])])}),[],!1,null,null,null);s.default=t.exports}}]);