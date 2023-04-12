sidebar = [
  {
    title: "Sécurité Maritime",
    collapsable: false,
    children: [
      'general2',
      'usage-cibnav',
      'donnees2',
      'algorithme2'
    ]
  },
  {
    title: "Annexes",
    collapsable: false,
    children: [
      'faq',
      'modeles_donnees',
      'controles_securite',
    ]
  },
]

module.exports = {
  theme: 'gouv-fr',
  base: '/cibnav/',
  title: 'Documentation CibNav V3',
  description: "Ciblage des contrôles pour navires professionnels",
  head: [
    ['meta', { name: 'theme-color', content: '#0053b3' }],
  ],
  themeConfig: {
    useMarianne: true,
    variation: 'white',
    sidebar: sidebar,
    sidebarDepth: 1,
    docsDir: ".",
    editLinks: false,
    editLinkText: 'Modifier cette page',
    nav: [
      { text: 'Application', link: 'http://data-cibnav.csam.e2.rie.gouv.fr/'},
      { text: 'Intranet Sécurité maritime', link: 'http://intra.secumar.metier.i2/' },
      { text: 'Projet CibNav sur EIG', link: 'https://entrepreneur-interet-general.etalab.gouv.fr/defis/2019/cibnav.html' },
    ]
  },
 
}
