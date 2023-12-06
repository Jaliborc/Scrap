local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'esES') or LibStub('AceLocale-3.0'):NewLocale('Scrap', 'esMX')
if not L then return end

-- main
L.Add = 'Añadir a la Lista de Basura'
L.DestroyCheapest = 'Destruir Basura Más Barata'
L.DestroyJunk = 'Destruir Basura'
L.Forget = 'Olvidar'
L.Junk = 'Basura'
L.JunkList = 'Lista de Basura'
L.NotJunk = 'Útil'
L.SellJunk = 'Vender Basura'
L.Remove = 'Retirar de la Lista de Basura'
L.ToggleMousehover = 'Alternar Artículo Bajo el Cursor'

-- chat
L.Added = 'Añadido a la lista de basura: %s'
L.Destroyed = 'Has destruido: %s x %s'
L.Forgotten = 'Definición se es basura olvidada: %s'
L.SoldJunk = 'Has vendido basura por un valor de: %s'
L.Repaired = 'Has reparado tu armadura por un valor de: %s'
L.Removed = 'Has retirado de la lista de basura: %s'

-- dialogs
L.ConfirmDelete = '¿Estás seguro de que quieres destruir todos tus items basura? ¡No puedes deshacer esta acción!.'

-- options
L.GeneralDescription = 'Estas opciones te permiten configurar Scrap aún más. ¡La basura no dominará tus bolsas!'
L.ListDescription = 'Estas opciones te permiten configurar tu lista de basura y detección de basura automática más a fondo.'

L.AutoSell = 'Vender automáticamente'
L.AutoSellTip = 'Si está activado, Scrap venderá automáticamente tu basura cuando visites a un mercader.'
L.AutoRepair = 'Reparar automáticamente'
L.AutoRepairTip = 'Si está activado, Scrap reparará automáticamente tu armadura cuando visites a un mercader.'
L.CharSpecific = 'Lista de basura específica del personaje'
L.DestroyWorthless = 'Destruir objetos sin valor'
L.DestroyWorthlessTip = 'Si está activado, Scrap destruirá los items basura sin valor de venta.'
L.GuildRepair = 'Usar fondos de la hermandad'
L.GuildRepairTip = 'Si está activado, Scrap utilizará los fondos de la hermandad disponibles para reparaciones antes que tu propio oro.'
L.Glow = 'Bordes brillantes'
L.GlowTip = 'Si está activado, aparecerán bordes brillantes en tus items basura.'
L.Icons = 'Icono de moneda'
L.IconsTip = 'Si está activado, aparecerá un pequeño icono de moneda de oro en tus items basura.'
L.SellPrices = 'Precio de venta en los tooltips'
L.SellPricesTip = 'Si está activado, el precio de venta de los items se mostrará en los tooltips incluso cuando no estés en un mercader.'
L.Learning = 'Aprendizaje de uso'
L.LearningTip = 'Si está activado, Scrap sabrá qué items le vendes habitualmente al mercader y automáticamente los considerará basura.'
L.LowConsume = 'Consumibles de bajo nivel'
L.LowConsumeTip = 'Si está activado, Scrap venderá los consumibles que son demasiado bajos para tu nivel.'
L.LowEquip = 'Equipo de bajo nivel'
L.LowEquipTip = 'Si está activado, Scrap venderá el equipo ligado al alma que tiene un nivel mucho menor que el que estás usando .'
L.SafeMode = 'Modo seguro'
L.SafeModeTip = 'Si está activado, Scrap no venderá más de 12 items a la vez, por lo que siempre podrás recuperarlos.'
L.Unusable = 'Equipo inutilizable'
L.UnusableTip = 'Si está activado, Scrap venderá el equipo ligado al alma, que nunca podría ser usado por tu personaje.'

-- tutorials
L.Tutorial_Welcome = 'Bienvenido a |cffffd200Scrap|r, la solución inteligente de venta de basura de |cffffd200Jaliborc|r. Este breve tutorial te ayudará a comenzar a vender tus items basura.|n|nLo que te ahorrará tiempo y tus bolsillos sin duda lo agradecerán. ¿Empezamos?'
L.Tutorial_Button = 'Scrap venderá automáticamente toda tu basura cada vez que visites a un mercader. Pero puedes venderla manualmente, es muy simple: |cffffd200Click|r en el botón Scrap.|n|n|cffffd200Click derecho|r en el botón para ver opciones adicionales.'
L.Tutorial_Drag = '¿Qué pasa si quieres decirle a Scrap cuales items vender o no? es muy simple: |cffffd200Arrastra|r los items de tus bolsas al botón Scrap.|n|nAlternativamente, puedes establecer un |cffffd200Keybinding|r en las opciones de |cffffd200Menú de juego|r. Presiónalo mientras colocas el item.'
L.Tutorial_Visualizer = 'Para ver qué items has especificado como basura o no, abre el visualizador en la pestaña |cffffd200Scrap|r.|n|nTen en cuenta que solo mostrará los items que tienes |cffffd200especificados|r, no todos los items del juego.'