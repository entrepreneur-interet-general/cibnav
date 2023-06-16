(window.webpackJsonp=window.webpackJsonp||[]).push([[22],{304:function(e,i,t){"use strict";t.r(i);var s=t(14),n=Object(s.a)({},(function(){var e=this,i=e._self._c;return i("ContentSlotsDistributor",{attrs:{"slot-key":e.$parent.slotKey}},[i("h1",{attrs:{id:"presentation-generale"}},[i("a",{staticClass:"header-anchor",attrs:{href:"#presentation-generale"}},[e._v("#")]),e._v(" Présentation générale")]),e._v(" "),i("div",{staticClass:"custom-block tip"},[i("p",{staticClass:"custom-block-title"},[e._v("Nouvelle version de CibNav")]),e._v(" "),i("p",[e._v("CibNav a évolué vers CibNav V4.")]),e._v(" "),i("p",[e._v("Vous pouvez voir un résumé des modifications apportées et des motivations de CibNav V4 en cliquant "),i("RouterLink",{attrs:{to:"/evolution_cibnav_v2.html#"}},[e._v("ici")])],1)]),e._v(" "),i("p",[e._v("Le logiciel CibNav est un outil d'aide à la décision pour la réalisation des visites de sécurité dites ciblées,\n(effectuées en application du décret n°84-810 modifié), via une identification des navires présentant la plus grande probabilité d'écart à la réglementation.")]),e._v(" "),i("p",[e._v("Cibnav est un logiciel basé sur des algorithmes alimentés par les données issues des visites de sécurité enregistrées sous la base de données Gina.")]),e._v(" "),i("p",[e._v("Son livrable est un tableau de bord pour les ISN listant les navires en fonction de leur priorité à réaliser une visite de sécurité.")]),e._v(" "),i("p",[e._v("Cette priorisation se fait à l'aide d'un modèle d'apprentissage statistique.\nLe principe d'un tel modèle est d'établir une règle de décision qui pourrait se traduire en termes simples de la sorte pour le fonctionnement de Cibnav :")]),e._v(" "),i("blockquote",[i("p",[e._v("« Combien de prescriptions majeures y aurait-il si l'on réalisait une visite de sécurité un an après la précédente ? ».")])]),e._v(" "),i("p",[e._v("Un rang de priorité est donné pour chaque navire, obtenu en calculant\nl'estimation de ce nombre de prescriptions majeures (appelé « score »), avec\ncomme hypothèse sous-jacente qu'un navire pour lequel on s'attendrait à un\nplus grand nombre de prescriptions majeures serait prioritaire. Pour éviter\nque des navires récemment visités n'apparaissent comme prioritaire, ce rang\nest donc transformé en fréquence de visite recommandée plus ou moins élevée.")]),e._v(" "),i("p",[e._v("Cette règle au cœur du fonctionnement de l’algorithme a ainsi été choisie parce qu’elle permet de correspondre\nle mieux avec la définition d’un critère le plus commun avec l’approche généralement constatée lors de l’exercice\ndu jugement professionnel des ISNPRPM quant au niveau de sécurité de nature à limiter les titres de sécurité.")]),e._v(" "),i("p",[e._v("Bien entendu, le modèle fonctionne à partir d’éléments connus, analysés à\npartir d'exemples antérieurs.\nAinsi, à l'aide de l'historique des données, notamment celles des prescriptions réalisées et enregistrées sous Gina depuis 2016,\nla meilleure règle de prédiction permettant de décider de  classification des prochaines visites a été recherchée,\ntout en veillant à se rapprocher de celle généralement mise en œuvre par un ISNPRPM.")]),e._v(" "),i("p",[e._v("Pour plus d'informations sur l'usage de CibNav au quotidien, se référer à la page "),i("RouterLink",{attrs:{to:"/usage-cibnav.html"}},[e._v("usage de CibNav pour les visites de sécurité")])],1),e._v(" "),i("p",[e._v("Si le sujet de l'apprentissage statistique vous intéresse, vous pouvez retrouver ce super article de vulgarisation à ce sujet sur le "),i("a",{attrs:{href:"https://www.lemonde.fr/blog/binaire/2017/10/20/jouez-avec-les-neurones-de-la-machine/",target:"_blank",rel:"noopener noreferrer"}},[e._v("blog binaire"),i("OutboundLink")],1),e._v(".")]),e._v(" "),i("p",[e._v("Voici les deux éléments importants dans le cadre de notre classification :")]),e._v(" "),i("ol",[i("li",[i("p",[i("RouterLink",{attrs:{to:"/donnees2.html"}},[e._v("Les données")]),e._v(" : les données utilisées dans le cadre de CibNav.")],1)]),e._v(" "),i("li",[i("p",[i("RouterLink",{attrs:{to:"/algorithme2.html"}},[e._v("Création du modèle")]),e._v(" : Comment avons nous aboutit au modèle considéré.")],1)])])])}),[],!1,null,null,null);i.default=n.exports}}]);