local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'nlNL')
if not L then return end

-- general
L.Add = 'Als rommel instellen'
L.DestroyCheapest = 'Goedkoopste Rommel Vernietigen'
L.DestroyJunk = 'Rommel vernietigen'
L.Forget = 'Vergeet'
L.Junk = 'Rommel'
L.JunkList = 'Rommel Lijst'
L.NotJunk = 'Nuttig'
L.SellJunk = 'Verkoop rommel'
L.Remove = 'Als nuttig instellen'
L.ToggleMousehover = 'Schakel Item Onder Muis'

-- chat
L.Added = 'Als rommel instellen: %s'
L.Destroyed = 'Je hebt vernietigd: %s x %s'
L.Forgotten = 'Junk-status van: %s vergeten'
L.GuildRepaired = 'Je gilde heeft je uitrusting gerepareerd voor %s'
L.SoldJunk = 'Rommel is verkocht voor %s'
L.Repaired = 'Uitrusting is gerepareerd voor %s'
L.Removed = 'Als nuttig instellen: %s'

-- dialogs
L.ConfirmDelete = 'Is het zeker dat al deze items vernietigd moeten worden? Deze actie kan niet ongedaan worden.'

-- options
L.GeneralDescription = 'Dit zijn algemene functies die kunnen worden in- of uitgeschakeld op basis van je voorkeuren. De rommel zal niet voorbijgaan!' -- modified
L.ListDescription = 'Deze opties staan toe om Scrap nog verder in te stellen.'

L.Behaviour = 'Gedrag'
L.AutoSell = 'Automatische Verkoop'
L.AutoSellTip = 'Scrap zal automatisch alle rommel verkopen wanneer een handelaar wordt bezocht, in het geval dit is ingesteld.'
L.AutoRepair = 'Automatische Reparatie'
L.AutoRepairTip = 'Scrap zal automatisch uitrusting repareren wanneer een handelaar wordt bezocht, in het geval dit is ingesteld.'
L.DestroyWorthless = 'Waardeloos Vernietigen'
L.DestroyWorthlessTip = 'Scrap zal items zonder verkoopwaarde automatisch vernietigen, in het geval dit is ingesteld.'
L.GuildRepair = 'Gebruik Gilde Fonds'
L.GuildRepairTip = 'Scrap zal in plaats van eigen geld, eerst gilde fonds automatisch gebruiken voor reparaties, in het geval dit is ingesteld.'
L.SafeMode = 'Veilige Modus'
L.SafeModeTip = 'Scrap zal niet meer dan 12 items in één keer verkopen, zodat deze altijd nog terug gekocht kunnen worden, in het geval dit is ingesteld.'

L.Visuals = 'Visueel'
L.Glow = 'Gloeiende Randen'
L.GlowTip = '|cffBBBBBBgrijze|r Gloeiende randen zullen zichtbaar zijn op Scrap items, in het geval dit is ingesteld.'
L.Icons = 'Munt Pictogrammen'
L.IconsTip = 'Kleine muntjes zullen zichtbaar zijn op Scrap items, in het geval dit is ingesteld.'
L.SellPrices = 'Tooltip Prijzen'
L.SellPricesTip = 'Als dit is ingeschakeld, worden itemverkoopprijzen getoond in tooltips, zelfs als je niet bij een handelaar bent.'

L.CharSpecific = 'Karakter Specifieke Rommel Lijst'
L.Learning = 'Leren Gebruiken'
L.LearningTip = 'Scrap zal leren welke items normaal gesproken verkocht worden aan de handelaar en |cffff2020automatisch|r deze als rommel beschouwen, in het geval dit is ingesteld.'
L.LowConsumable = 'Lage Verbruiksgoederen'
L.LowConsumableTip = 'Scrap zal |cffff2020elke|r verbruiksgoederen die te laag voor het niveau zijn, automatisch verkopen, in het geval dit is ingesteld.'
L.LowEquip = 'Lage Uitrusting'
L.LowEquipTip = 'Scrap zal |cffff2020elke|r zielsverbonden uitrusting met een veel lagere waarde dan het gedragen uitrusting verkopen, in het geval dit is ingesteld.'
L.Unusable = 'Onbruikbare Uitrusting'
L.UnusableTip = 'Scrap zal |cffff2020elke|r zielsverbonden uitrusting wat nooit gedragen zou kunnen worden door het karakter verkopen, in het geval dit is ingesteld.'
L.iLevelTreshold = 'Itemniveau Drempelwaarde'
L.EquipLevelTip = 'Bepaalt het itemniveau waaronder items als rommel worden beschouwd, gebaseerd op een percentage van je huidige uitrustingsniveau.|n|nBijvoorbeeld: bij 100% is elk item onder je gedragen niveau rommel; bij 50% alleen items onder de helft van dat niveau.'
L.ConsumableLevelTip = 'Bepaalt het itemniveau waaronder verbruiksgoederen als rommel worden beschouwd, berekend als een percentage van je karakterniveau.'

-- help
L.PatronsDescription = 'Scrap wordt gratis gedistribueerd en ondersteund via donaties. Een enorme dank aan alle supporters op Patreon en Paypal die de ontwikkeling in leven houden. Je kunt ook een patron worden op |cFFF96854patreon.com/jaliborc|r.'
L.HelpDescription = 'Hier bieden we antwoorden op de meest gestelde vragen. We raden ook aan om de in-game tutorial te volgen. Als geen van beide je probleem oplost, kun je overwegen om hulp te vragen op de Scrap-gebruikerscommunity op Discord.'

L.FAQ = {
	'Hoe voeg ik een item toe aan of verwijder ik een item van de rommellijst?',
	'Er zijn meerdere manieren:|n1) De eenvoudigste is om het item naar de Scrap-knop te slepen terwijl je bij een handelaar bent (naast de knoppen voor het repareren van bepantsering).|n2) Je kunt een sneltoets instellen onder Spelmenu -> Sneltoetsen -> Scrap -> "Schakel Item Onder Muis". Beweeg de muis over items in je inventaris en druk op je sneltoets om ze als rommel in of uit te schakelen.|n3) Je kunt de items die je hebt toegevoegd of verwijderd beheren op het Scrap-tabblad onderaan het handelarenpaneel (naast het Terugkopen-tabblad).',
	'Het Scrap-icoon wordt niet weergegeven op items in Bagnon!',
	'Die functionaliteit maakt geen deel uit van het basis Scrap-addon, maar van een aparte plugin. Probeer |cffffd200Bagnon Scrap Support|r te installeren of bij te werken.'
}

-- tutorials
L.Tutorial_Welcome = 'Welkom bij |cffffd200Scrap|r, het intelligente rommel verkoop oplossing door |cffffd200Jaliborc|r (vertaling door |cffffd200Barrosy|r). Deze korte handleiding zal je helpen om te beginnen met het verkopen van rommel. |n|nHet zal je tijd besparen en je zakken zullen het waarderen. Zullen wij beginnen?'
L.Tutorial_Button = 'Scrap zal, wanneer een handelaar wordt bezocht, al uw rommel automatisch verkopen. U kunt het ook handmatig verkopen: simpelweg |cffffd200Links-Klik|r op de Scrap knop.|n|n|cffffd200Rechts-Klik|r op de knop om extra opties te krijgen.'
L.Tutorial_Drag = 'Wat nou als u Scrap wilt vertellen welke items wel en niet verkocht moeten worden? U kunt het dan simpelweg van uw tassen naar de Scrap knop|cffffd200slepen|r.|n|nAls alternatief kunt u een |cffffd200Sneltoets|r instellen in het spel opties menu. Druk het wanneer de muis boven het item zweeft.'
L.Tutorial_Visualizer = 'Om te zien welke items u als rommel heeft gespecificeerd, open de |cffffd200Scrap Visualizer|r tab.|n|nLet erop dat dit alleen door u |cffffd200gespecificeerde|r items zal tonen, dus niet elke mogelijke item in-game.'
L.Tutorial_Bye = 'Veel succes met je reizen en moge de |cffb400ffEpics|r met u zijn. De rommel zal niet voorbijgaan!'
