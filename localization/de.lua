local L = LibStub('AceLocale-3.0'):NewLocale('Scrap', 'deDE')
if not L then return end

-- main
L.Add = 'Zur Müll-Liste hinzufügen'
L.DestroyCheapest = 'Günstigsten Müllgegenstand zerstören'
L.DestroyJunk = 'Müll zerstören'
L.Forget = 'Vergessen'
L.Junk = 'Müll'
L.JunkList = 'Müll Liste'
L.NotJunk = 'Kein Müll'
L.SellJunk = 'Müll verkaufen'
L.Remove = 'Von der Müll-Liste entfernen'
L.ToggleMousehover = 'Müllstatus für den Gegenstand unterm Mauszeiger ändern'

-- chat
L.Added = 'Zur Müll-Liste hinzugefügt: %s'
L.Destroyed = 'Du hast zerstört: %s x %s'
L.Forgotten = 'Müllstatus vergessen von: %s'
L.SoldJunk = 'Du hast deinen Müll für %s verkauft'
L.Repaired = 'Du hast deine Ausrüstung für %s repariert'
L.Removed = 'Von der Müll-Liste entfernt: %s'

-- dialogs
L.ConfirmDelete = 'Bist Du sicher, dass Du alle Deine Müllgegenstände zerstören möchtest? Du kannst dies nicht rückgängig machen.'

-- options
L.GeneralDescription = 'Diese Optionen gestatten dir, Scrap noch weiter anzupassen. Auf das kein Müll durchkomme!'
L.ListDescription = 'Diese Optionen gestatten dir, deine Müll-Liste und die automatische Müll-Erkennung weiter anzupassen.'

L.AutoSell = 'Automatisch verkaufen'
L.AutoSellTip = 'Wenn aktiviert, wird Scrap deinen Müll automatisch beim Händler verkaufen.'
L.AutoRepair = 'Automatisch reparieren'
L.AutoRepairTip = 'Wenn aktiviert, wird Scrap automatisch deine Ausrüstung reparieren, sobald du einen Händler besuchst.'
L.CharSpecific = 'Charakterspezifisch'
L.DestroyWorthless = 'Wertlosen Müll zerstören'
L.DestroyWorthlessTip = 'Wenn aktiviert, wird Scrap Müllgegenstände zerstören, die keinen Verkaufswert haben.'
L.GuildRepair = 'Mit Gildenkasse reparieren'
L.GuildRepairTip = 'Wenn aktiviert, wird Scrap verfügbare Gildenmittel für Reparaturen vor deinem eigenen Geld verwenden.'
L.Glow = 'Leuchtende Rahmen'
L.GlowTip = 'Wenn aktiviert, werden |cffBBBBBBgrau|r leuchtende Rahmen deine Müll-Gegenstände umgeben.'
L.Icons = 'Münz-Symbole'
L.IconsTip = 'Wenn aktiviert, werden kleine Goldmünzen an deinen Müll-Gegenständen angezeigt.'
L.SellPrices = 'Verkaufspreise im Tooltip anzeigen'
L.SellPricesTip = 'Wenn aktiviert, werden Verkaufspreise der Gegenstände im Tooltip angezeigt, auch wenn du nicht bei einem Händler bist.'
L.Learning = 'Intelligentes Lernen'
L.LearningTip = 'Wenn aktiviert, wird Scrap lernen, welche Gegenstände du normalerweise beim Händler verkaufst und sie automatisch als Müll einstufen.'
L.LowConsume = 'Niedrigstufige Verbrauchsgüter'
L.LowConsumeTip = 'Wenn aktiviert, wird Scrap |cffff2020alle|r Verbrauchsgüter verkaufen, die für deine Stufe zu niedrig sind.'
L.LowEquip = 'Niedrigstufige Ausrüstung'
L.LowEquipTip = 'Wenn aktiviert, wird Scrap |cffff2020alle|r seelengebundene Ausrüstung verkaufen, die im Wert weit unter deiner angelegten liegt.'
L.SafeMode = 'Sicherheitsmodus'
L.SafeModeTip = 'Wenn eingeschaltet, wird Scrap nicht mehr als 12 Gegenstände verkaufen, damit sie zurückgekauft werden können.'
L.Unusable = 'Unbenutzbare Ausrüstung'
L.UnusableTip = 'Wenn aktiviert, wird Scrap |cffff2020alle|r seelengebundene Ausrüstung verkaufen, die von deinem Charakter nie genutzt werden könnte.'

-- tutorials
L.Tutorial_Welcome = 'Willkommen bei |cffffd200Scrap|r, der intelligenten Müllverkaufslösung von |cffffd200Jaliborc|r. Diese kurze Anleitung wird dir helfen, mit dem Verkauf deiner Müllgegenstände zu beginnen.|n|nEs wird dir Zeit sparen und deine Taschen werden es dir sicherlich danken. Sollen wir beginnen?'
L.Tutorial_Button = 'Scrap wird automatisch all deinen Müll verkaufen, wann immer du einen Händler besuchst. Aber Du kannst ihn auch manuell verkaufen: mit einem einfachen |cffffd200Links-Klick|r auf die Scrap-Schaltfläche.|n|n|cffffd200Rechts-Klick|r führt dich zu weiteren Optionen.'
L.Tutorial_Drag = 'Was, wenn du Scrap sagen willst, welche Gegenstände verkauft werden sollen und welche nicht? |cffffd200Zieh|r sie einfach aus deinen Taschen auf die Scrap-Schaltfläche.|n|nAlternativ dazu kannst du eine |cffffd200Tastaturbelegung|r im |cffffd200Spielmenü|r erstellen. Nutze diese, während sich der Mauszeiger über dem Gegenstand befindet.'
L.Tutorial_Visualizer = 'Um zu sehen, welche Gegenstände du als Müll bzw. kein Müll festgelegt hast, öffne den |cffffd200Scrap Visualizer|r Reiter.|n|nBeachte dabei, daß nur die Gegenstände angezeigt werden, die du |cffffd200festgelegt|r hast, nicht jeder einzelne Gegenstand im Spiel.'
L.Tutorial_Bye = 'Viel Glück auf deinen Reisen, und mögen |cffb400ffdie Epics|r mit dir sein. Auf das kein Müll durchkomme!'
