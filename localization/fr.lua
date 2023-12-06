local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'frFR')
if not L then return end

-- main
L.Add = "Ajouter à la liste de camelote"
L.DestroyCheapest = "Détruire l'objet de camelote le moins cher"
L.DestroyJunk = 'Détruire la camelote'
L.Forget = 'Oublier'
L.Junk = 'Camelote'
L.JunkList = 'Liste de Camelote'
L.NotJunk = 'Utile'
L.SellJunk = "Vendre la camelote"
L.Remove = "Enlever de la liste de camelote"
L.ToggleMousehover = 'Considère les objets sous le curseur comme indésirables'

-- chat
L.Added = 'Ajouté à la liste de camelote: %s'
L.Destroyed = 'Vous avez détruit : %s x %s'
L.Forgotten = 'Oublié le statut camelote de : %s'
L.SoldJunk = 'Camelote vendue pour %s'
L.Repaired = 'Vous avez réparé votre équipement pour %s'
L.Removed = 'Enlevé de la liste de camelote: %s'

-- dialogs
L.ConfirmDelete = 'Voulez-vous vraiment supprimer toute votre camelote ? Cette action ne peut pas être annulée.'

-- options
L.GeneralDescription = 'Ces options vous permettent de configurer Scrap encore mieux. La camelote ne passera pas !'
L.ListDescription = 'Ces options vous permettent de configurer votre liste de camelote et la détection automatique de camelote encore plus loin.'

L.AutoSell = 'Vente Automatique'
L.AutoSellTip = 'Si cette option est activée, Scrap vendra automatiquement toute votre camelote lors d\'une visite chez un marchand.'
L.AutoRepair = 'Réparer Automatiquement'
L.AutoRepairTip = 'Si cette option est activée, Scrap réparera automatiquement votre armure lorsque vous parlerez à un marchand.'
L.CharSpecific = 'Liste de Camelote Spécifique au Personnage'
L.DestroyWorthless = 'Détruire les invendables'
L.DestroyWorthlessTip = 'Si cette option est activée, Scrap détruira la camelotte qui ne peut pas être vendue.'
L.GuildRepair = 'Réparer avec l\'argent de la guilde'
L.GuildRepairTip = 'Si cette option est activée, Scrap utilisera l\'argent de la guilde pour réparer avant d\'utiliser votre monnaie.'
L.Glow = 'Bordures éclatantes'
L.GlowTip = 'Si cette option est activée, des bordures |cffBBBBBBgrises|r apparaîtront sur les icônes de votre camelote.'
L.Icons = 'Icônes des Monnaies'
L.IconsTip = 'Si cette option est activée, des petites icônes de monnaie apparaîtront sur les icônes de votre camelote.'
L.SellPrices = 'Prix de vente dans les info-bulles'
L.SellPricesTip = 'Si cette option est activée, les prix de vente des objets seront affichés dans les info-bulles même lorsque vous n\'êtes pas chez un marchand.'
L.Learning = 'Apprentissage Intelligent'
L.LearningTip = 'Si cette option est activée, Scrap apprendra de lui-même quels articles vous vendez généralement aux marchands et les considérera automatiquement comme de la camelote.'
L.LowConsume = 'Vendre les consommables de faible niveau'
L.LowConsumeTip = 'Si cette option est activée, Scrap vendra |cffff2020tous|r les objets consommables qui sont trop faibles pour votre niveau.'
L.LowEquip = 'Vendre l\'équipement de faible niveau'
L.LowEquipTip = 'Si cette option est activée, Scrap vendra |cffff2020tout|r l\'équipement lié ayant un niveau beaucoup plus bas que celui que vous portez.'
L.SafeMode = 'Mode Sécurisé'
L.SafeModeTip = 'Si cette option est activée, Scrap ne vendra pas plus de 12 objets à la fois, de façon à ce que vous puissiez les racheter.'
L.Unusable = 'Équipement Inutilisable'
L.UnusableTip = 'Si cette option est activée, Scrap vendra |cffff2020tout|r équipement inutilisable par votre personnage.'

-- tutorials
L.Tutorial_Welcome = 'Bienvenue dans |cffffd200Scrap|r, la solution de vente intelligente par |cffffd200Jaliborc|r. Ce court tutoriel vous aidera à commencer à vendre votre camelote.|n|nCelà vous fera gagner un temps fou, et vos poches apprécieront grandement.|nOn commence ?'
L.Tutorial_Button = 'Scrap vend automatiquement toute votre camelote à chaque visite chez un marchand. Mais vous pouvez le faire manuellement : faites simplement un |cffffd200clic-gauche|r sur le bouton de Scrap.|n|n|cffffd200Clic-droit|r sur le bouton pour afficher les options avancées.'
L.Tutorial_Drag = 'Que faire si vous voulez dire à Scrap quels articles il doit vendre ou pas ? Il suffit simplement de |cffffd200glisser-déposer|r vos objets de vos sacs sur le bouton Scrap.|n|nVous pouvez également définir un |cffffd200raccourci clavier|r dans les options du |cffffd200menu du jeu|r. Appuyez dessus tout en survolant l\'élément.'
L.Tutorial_Visualizer = 'Pour voir les articles que vous avez spécifié comme indésirables ou non, ouvrez l\'onglet |cffffd200Scrap Visualizer|r.|n|nRemarquez qu\'il n\'affichera que les articles que vous aurez |cffffd200spécifié|r indésirables, et non pas chaque élément unique dans le jeu.'
L.Tutorial_Bye = 'Bonne chance dans vos aventures et puissent les |cffb400ffobjets épiques|r être avec vous.|nLes déchets ne passeront pas !'