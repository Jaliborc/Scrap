local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'itIT')
if not L then return end

-- general
L.Add = 'Imposta come Cianfrusaglia'
L.DestroyCheapest = 'Distruggi l\'oggetto Cianfrusaglia più Economico'
L.DestroyJunk = 'Distruggi Cianfrusaglie'
L.Forget = 'Dimentica'
L.Junk = 'Cianfrusaglia'
L.JunkList = 'Lista Rifiuti'
L.NotJunk = 'Utile'
L.SellJunk = 'Vendi Cianfrusaglie'
L.Remove = 'Imposta come Utile'
L.ToggleMousehover = 'Attiva/Disattiva Oggetto Sotto il Cursore'

-- chat
L.Added = 'Imposta come Cianfrusaglia: %s'
L.Destroyed = 'Hai distrutto: %s x %s'
L.Forgotten = 'Hai dimenticato lo stato di cianfrusaglia di: %s'
L.GuildRepaired = 'La tua gilda ha riparato la tua armatura per %s.'
L.SoldJunk = 'Hai venduto le tue Cianfrusaglie per %s'
L.Repaired = 'Hai riparato il tuo equipaggiamento per %s'
L.Removed = 'Imposta come Utile: %s'

-- dialogs
L.ConfirmDelete = 'Sei sicuro di voler distruggere tutte le tue cianfrusaglie? Non puoi cancellare questa azione.'

-- options
L.GeneralDescription = 'Queste opzioni ti permettono di configurare Scrap sempre più accuratamente. Le cianfrusaglie non passeranno!'
L.ListDescription = 'Queste opzioni ti permettono di configurare ulteriormente la tua lista di cianfrusaglie e il rilevamento automatico di cianfrusaglie.'

L.Behaviour = 'Comportamento'
L.AutoSell = 'Vendi Automaticamente'
L.AutoSellTip = 'Se abilitato, Scrap venderà automaticamente tutte le tue cianfrusaglie quando visiti un mercante.'
L.AutoRepair = 'Ripara Automaticamente'
L.AutoRepairTip = 'Se abilitato, Scrap riparerà automaticamente tutto il tuo equipaggiamento quando visiti un mercante.'
L.DestroyWorthless = 'Distruggi Senza Valore'
L.DestroyWorthlessTip = 'Se abilitato, Scrap distruggerà tutte le cianfrusaglie senza un valore di vendita.'
L.GuildRepair = 'Usa Fondi di Gilda'
L.GuildRepairTip = 'Se abilitato, Scrap userà per riparare i fondi di gilda disponibili prima di usare i tuoi.'
L.SafeMode = 'Modalità di Sicurezza'
L.SafeModeTip = 'Se abilitato, Scrap non venderà più di 12 oggetti alla volta, così puoi deciderli di riacquistarli se cambi idea.'

L.Visuals = 'Aspetto'
L.Glow = 'Bordi Luccicanti'
L.GlowTip = 'Se abilitato, appariranno bordi |cffBBBBBBgrigi|r sugli oggetti che Scrap considera cianfrusaglie.'
L.Icons = 'Icona Moneta'
L.IconsTip = 'Se abilitato, appariranno piccole monete dorate sugli oggetti che Scrap considera cianfrusaglie.'
L.SellPrices = 'Prezzi sul Tooltip'
L.SellPricesTip = 'Se abilitato, i prezzi di vendita degli oggetti saranno mostrati nei tooltip anche quando non si è presso un mercante.'

L.CharSpecific = 'Lista Specifica del Personaggio di Cianfrusaglie'
L.Learning = 'Auto Apprendimento'
L.LearningTip = 'Se abilitato, Scrap autoapprenderà quali oggetti vendi generalmente ad un mercante e li considererà |cffff2020automaticamente|r come cianfrusaglie.'
L.LowConsumable = 'Consumabili Minori'
L.LowConsumableTip = 'Se abilitato, Scrap venderà |cffff2020qualsiasi|r oggetto consumabile che è molto inferiore rispetto al tuo livello.'
L.LowEquip = 'Equipaggiamento Inferiore'
L.LowEquipTip = 'Se abilitato, Scrap venderà |cffff2020qualsiasi|r equipaggiamento vincolato che ha un valore di vendita molto inferiore a quello che stai indossando.'
L.Unusable = 'Equipaggiamento Non Utilizzabile'
L.UnusableTip = 'Se abilitato, Scrap venderà |cffff2020qualsiasi|r equipaggiamento vincolato che non potrà mai essere usato dal tuo personaggio.'
L.iLevelTreshold = 'Soglia Livello Oggetto'
L.EquipLevelTip = 'Controlla il livello dell\'oggetto al di sotto del quale gli oggetti sono considerati cianfrusaglie, in base a una percentuale del livello del tuo equipaggiamento attuale.|n|nAd esempio: al 100%, qualsiasi oggetto inferiore al tuo livello equipaggiato è cianfrusaglia; al 50%, solo gli oggetti sotto la metà di quel livello lo sono.'
L.ConsumableLevelTip = 'Controlla il livello dell\'oggetto al di sotto del quale i consumabili sono cianfrusaglie, calcolato come percentuale del livello del tuo personaggio.'

-- help
L.PatronsDescription = 'Scrap è distribuito gratuitamente e supportato tramite donazioni. Un grandissimo ringraziamento a tutti i sostenitori su Patreon e PayPal che mantengono vivo lo sviluppo. Puoi diventare un patron anche tu su |cFFF96854patreon.com/jaliborc|r.'
L.HelpDescription = 'Qui forniamo risposte alle domande più frequenti. Raccomandiamo inoltre di seguire il tutorial di gioco. Se nessuno dei due risolve il tuo problema, puoi chiedere aiuto alla community di utenti di Scrap su Discord.'

L.FAQ = {
	'Come aggiungere/rimuovere un oggetto dalla lista delle cianfrusaglie?',
	'Ci sono diversi modi:|n1) Il più semplice è trascinare l\'oggetto sul pulsante Scrap mentre sei da un mercante (accanto ai pulsanti di riparazione dell\'armatura).|n2) Puoi impostare una combinazione di tasti in Menu di Gioco -> Assegnazione Tasti -> Scrap -> "Attiva/Disattiva Oggetto Sotto il Cursore". Quindi posiziona il cursore sugli oggetti nell\'inventario e premi il tasto per attivare/disattivare il loro stato.|n3) Puoi gestire gli oggetti che hai aggiunto o rimosso nella scheda Scrap in fondo al pannello del mercante (accanto alla scheda del Riacquisto).',
	'L\'icona di Scrap non viene mostrata sopra gli oggetti in Bagnon!',
	'Questa funzionalità non fa parte del nucleo di Scrap, fa parte di un plugin separato. Prova a installare o aggiornare |cffffd200Bagnon Scrap Support|r.'
}

-- tutorials
L.Tutorial_Welcome = 'Benvenuti in |cffffd200Scrap|r, la soluzione intelligente di vendita automatica di cianfrusaglie di |cffffd200Jaliborc|r. Questa breve guida vi aiuterà ad iniziare a vendere le vostre cianfrusaglie.|n|nSarà un prezioso salvatempo, e le vostre tasche apprezzeranno. Iniziamo?'
L.Tutorial_Button = 'Scrap venderà automaticamente tutte le tue cianfrusaglie nel tuo inventario quando visiti un mercante. Ma puoi anche venderli tu manualmente: fai semplicemente |cffffd200Clic Sinistro|r sul pulsante di Scrap.|n|n|cffffd200Clic Destro|r sul pulsante per visualizzare altre opzioni.'
L.Tutorial_Drag = 'Cosa fare per dire a Scrap di vendere o meno i vari oggetti? Semplicemente |cffffd200trascinali|r dalle tue borse sul pulsante di Scrap.|n|nAlternativamente, puoi impostare un |cffffd200Assegnazione|r tra le opzioni del |cffffd200Menù di Gioco|r.'
L.Tutorial_Visualizer = 'Per vedere quali oggetti hai impostato come cianfrusaglie oppure no, apri la scheda |cffffd200Scrap Visualizer|r.|n|nRicorda che verranno mostrati solo gli oggetti che |cffffd200tu hai specificato|r, e non qualsiasi oggetto del gioco.'
L.Tutorial_Bye = 'Buona fortuna nei tuoi viaggi, e che gli |cffb400ffepici|r siano con te. La spazzatura non prevarrà!'
