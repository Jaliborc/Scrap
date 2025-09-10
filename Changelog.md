## 11.2.3
* Fixed an issue preventing auto sell of junk at the merchant on the first visit (thanks to LorenzoRogai).

## 11.2.2
* Fixed bug in opening settings from the merchant button.

## 11.2.1
* Retail: Updated libraries.

## 11.2
* Retail: Updated for patch 11.2.
* Retail: Fixed issue with the "Sell Junk" keybinding.

### 11.1.10
* Last version was broken because dummass me forgot to package in CallbackHandler.

### 11.1.9
* Moved back to a full addon-based event handling, as Blizzard's event registry is prone to event loss (thank you to the dev community for all the suggestions).

### 11.1.8
* Duplicate soulbound/accountbound mounts, pets and toys will now be automatically marked as junk by default (feature made with help from fizzwidget).
* Hotfixed an issue in blizzard's event code.

### 11.1.7
* Fixed issue with Visualizer on Mists servers.
* Fixed bug with positioning of shines during tutorial.

### 11.1.6
* Now supports Mists of Pandaria servers.

### 11.1.5
* Updated with workaround to serious flaw within Blizzard's EventRegistry.
* Now takes advantage of the new delayed bag update event for slightly faster chain-selling at the merchant.

### 11.1.4
* TOC updated.
* WildAddon-1.1 updated.

### 11.1.3
* TOC update.

### 11.1.2
* Retail: Updated description to match the new addon list formatting.
* All: Updated dependencies.

### 11.1.1
* All: Updated WildAddon library.

### 11.1
* Retail: Updated for the "Undermined" game patch.
* Retail: Added support for the new addon list native grouping capabilities.

### 11.0.15
* All: Updated libraries.

### 11.0.14
* All: Fixed issues found and reported on the beta version.
* Cata: Fixed bug with spotlight.
* All: Tagging release.

### 11.0.13 (beta)
* All: Upgraded to WildAddon-1.1. Addon custom events now appear on the event tracing window.

### 11.0.12
* All: Updated TOC

### 11.0.11
* Retail: Fixed issue that prevented Spotlight from updating correctly on the combined bag frame.

### 11.0.10
* All: Fixed bug that could occur due to a delay in obtaining item hyperlinks.

### 11.0.9
* Cata, Retail: Improved uncollected appearance detection.
* Cata, Classic: Fixed issues with unusable and quest item detection.

### 11.0.8
* Classic, Cata: Updated C_Everywhere, which was causing an issue.

### 11.0.7
* Retail: Updated spotlight for the war within default bag interface.

### 11.0.6
* All: Added ability to detect new versions of the addon being available.

### 11.0.5
* Cata, Retail: Will no longer consider uncollected appearances junk by default.

### 11.0.4
* All: Changed how the item level threshold options are presented, for clarity of use.
* Warning! Item threshold settings have been reset as part of the update.

### 11.0.3
* All: Updated libraries that had bugs fixed during Bagnon's development.

### 11.0.2
* Retail: Hotfix for 11.0.2.

### 11.0.1
* Retail: Updated for WoW patch 11.0.2.
* Classic, Cata: Verified support.
* All: Updated TaintLess.

### 11.0.0
* Updated for The War Within.

#### 10.2.11
* Dragonflight: Updated toc.

#### 10.2.10
* Cata: Updated popups to support the worsened API, fixing multiple bugs.

#### 10.2.9
* Updated for Cataclysm servers!

#### 10.2.8
* All: Fixed issue with ColorPicker detected by the community.

#### 10.2.7
* All: Fixed a bug with tutorials on new installs.

#### 10.2.6
* Retail: Added support to the new native Addon Compartment functionality.
* All: Made the existence of keybinding options more obvious.

#### 10.2.5
* Now users can optionally configure the item level thresholds for an item to be considered too low level.
* Removed deprecated hidden tooltip.

#### 10.2.4
* Updated main artwork!

#### 10.2.3
* New Help menu!
  * Merchant Scrap button now has entry to redirect to the new Help menu, instead of the tutorial alone.
  * Small tweaks to the tutorial to fit within the new setup.
* Upgraded to Sushi-3.2:
  * Popup rework, with bugfixes and improved design.
  * Fixed dropdown issue that could create lag, improved design.
  * Function-chaining now possible.
  * Other minor optimizations.
* Now prevents Titan from causing errors by requesting non-existing tooltips.
* Now makes use of ExecuteFrameScript where sensible.
* Fixed a bug in all localizations.

#### 10.2.2
* Season of Discovery: Prevented strange usage of the tooltip APIs from causing errors.

#### 10.2.1
* Classic: Fixed positioning of Visualizer tab.

### 10.2
* Retail: TOC update.

#### 10.1.8
* Wrath: Updated for 3.4.3.

#### 10.1.7
* Classic: Fixed bug that caused away-from-vendor item prices to not account for the size of the stack.
* All: Tweaked some locales.

#### 10.1.6
* All: Added assets for the new recommended addon list format for plugins.
* All: Fixed bug in the new filters configuration panel that prevented changing settings.

#### 10.1.5
* All: Massive overall update to localizations.

#### 10.1.4
* Vanilla & Wrath: Fixed issues with loading config in modern option panels.
* All: Reorganized options.

#### 10.1.3
* All: Bound on equip items marked as gray quality by Blizzard are no longer considered junk by default. (cheers to Ketrel for initial draft)
* Vanilla: Updated to Vanilla now using C_Container that was causing errors on mousehover.

#### 10.1.2
* All: Added a "Forget Item" button to the Scrap merchant tab.
* Dragonflight: Fixed issue that caused merchant "undo arrow" to appear while on the Scrap merchant tab.

#### 10.1.1
* Dragonflight: Updated for new merchant stock UI.
* Dragonflight: Added support for the new addon logos API and multiple-TOC format. (no Compartiment support yet).
* Dragonflight: Cosmetic items are now not considered junk by default.
* Wrath: Updated TaintLess (previous version was causing issues on this version of the game).
* All: Marked multiple items to be not junk by default given community feedback.
* All: Fixed layout of the addon keybindings to fit both retail and classic.
* All: Merccd "C:\Users\Jaliborc\Documents\Documents\Work\Addons\upmod"node cli hant button tooltip now updates as expected when button is clicked.
* All: Removed need for 2 unused textures (smaller install size).

### 10.1
* Dragonflight: Updated for Embers of Neltharion.
* All: Added keybinding to destroy single least valuable junk item stack.
* All: Changed how default settings are handled, so new features that are meant to be enabled by default do so for existing users.
* Wrath: Fixed issue unintentionally turning the sell prices feature on.
* Vanilla: Fixed two bugs in the new vendor prices feature triggered on inventory items.

#### 10.0.11
* Vanilla: Now shows item sell price in tooltips even when not at the vendor.

#### 10.0.10
* Wrath: Fixed for blizzard server bugs introduced with Secrets of Ulduar.

#### 10.0.9
* Classic: Fixed bug with relic items comparison.
* All: Small optimization in equipment item comparison code.

#### 10.0.8
* Update addresses the majority of hang issues:
   * All: Now using ItemSearch-1.3 for tooltip queries.
   * All: Updated C_Everywhere for classic tooltip support.
   * All: Minor Unfit and CustomSearch optimizations.

#### 10.0.7
* All: Updated C_Everywhere
* All: Embedded TaintLess.

#### 10.0.6
* All: Fixed issue with automatic learning.

#### 10.0.5
* All: Reimplemented using C_Everywhere.
* All: Updated italian locales (thanks to simoflorence).

#### 10.0.4
* Dragonflight: Updated for WoW patch 10.0.2.
* Dragonflight: Added support for the new Evoker class.
* All: Updated socials.

#### 10.0.3
* Dragonflight: Added support for new reagents bag.
* Fixed "location.GetItemID" bug.
* Added italian locales.

#### 10.0.2
* Classic: Fixed issue with junk tagging on default bag UI.

#### 10.0.1
* Added pretty icons to merchant dropdown menu.
* Visualizer now displays items as it queries the client for more. This should help players with very long lists.
* Set "Baubleworms greys" as not junk by default.
* Tagging release.

### 10 (beta)
* Updated for the Dragonflight PTR.
* Updated design of Scrap's merchant tab.
* Improved display of junk items in inventory and bank.
* Optimized download size using texture RLE compression.

#### 9.2.1
* Improved ilevel threshold for low level equipment/consumables.
* Fixed bug and improved logic of the Usage Learning feature.

### 9.2
* Classic: Updated for Wrath of the Lich King.
* All: Fixed issue with closing vendor window.

#### 9.1.2
* Updated libraries to Shadowlands 9.1.5 which were mistakenly not updated last version.

#### 9.1.1
* Updated for Shadowlands 9.1.5

### 9.1
* Updated for Chains of Domination

#### 9.0.6
* Updated for the Burning Crusade

#### 9.0.5
* Updated for WoW patches 9.0.5 and 1.13.6.

#### 9.0.4
* Updated for WoW patch 9.0.3.

#### 9.0.3
* Fixed "unsafe auto sell" mode.

#### 9.0.2
* Largely improved low level equipment detection in Shadowlands.
* Fixed issue with marking junk in default bags.

#### 9.0.1
* Fixed issue with auto sell.
* Fixed issue with auto learning.
* Updated chinese locales.

### 9
* Updated for Shadowlands
* Fixed minor issue that could occur in plugins that load merchant API outside of merchant.

#### 8.3.3
* Added Dutch localization (thanks to Barrosy).
* Updated French localization (thanks to Nelfym).

#### 8.3.2
* Fixed bug with the visualizer's "set as useful" button.

#### 8.3.1
* Fixed issue with dropdown.

### 8.3.0
* Updated for Visions of Nzoth.

#### 8.2.3
* Fixed issue with `Sell Junk` keybinding.
* Fixed visual issue with `Character Specific Junk List` option.

#### 8.2.2
* Fixed another issue with `Usage Learning` feature.

#### 8.2.1
* Fixed issue starting `Usage Learning` feature.

### 8.2.0
* Changed when low level gray equipment is classified as junk by default.
* Added new items to default junk exclusion as requested by users.
* Added options to not destroy items with no sale value at the vendor.
* Added keybinding to destroy junk items.
* Complete internal rewrite of settings, variables and file internal structure.
   * `Scrap_Visualizer` is not part of `Scrap_Merchant`
   * Renamed `Scrap_Options` to `Scrap_Config`
   * Heavily reduced globals polution.
   * Now running on new libraries.

#### 13.19
* Fixed issue with auto repair in classic.

#### 13.18
* Fixed issue with patron list.

#### 13.17
* Now compatible with World of Warcraft Classic

#### 13.16
* Updated for World of Warcraft patch 8.2.0.

#### 13.15
* Hotfix

#### 13.14
* Fixed issue causing Visualizer tab button to display even if the module is disabled.
* Fixed issue with item comparison to current equipment.
* Item level detection is now faster (no longer requires internal tooltip scanning).

#### 13.13
* Updated for Tides of Vengeance.
* Improved how equipment item level is detected.
* Updated Russian localization.
* Fixed English localization error.

#### 13.12
* Minor internal modification.

#### 13.11
* Fixed issue with settings default reset.

#### 13.10
* Added patron list in the configuration options. See patreon.com/jaliborc to learn how to join the list.

#### 13.9
* Including unnecessary files because game client is now picky about missing files.

#### 13.8
* Now knows that Shamans cant use plate.

#### 13.7
* Updated for Battle for Azeroth.

#### 13.6
* Updated for Shadow of Argus.

#### 13.5
* Updated for Tomb of Sargeras.

#### 13.4
* Updated for Return to Kharazan.

#### 13.3
* Minor bugfix.

#### 13.2
* Tagging as release.

### 13.1 (beta)
* Updated for Legion.
* Merchant tooltip now counts the number of items, and not the number of slots being sold.

### 13
* Now you can choose between having character specific junk lists or a single shared list among your characters.

#### 12.25
* Made Eternium Rose not junk by default.

#### 12.24
* Updated for Fury of Hellfire

#### 12.23
* Updated for WoW patch 6.2.
* Big Crates of Salvage are now considered not junk by default.

#### 12.24
* Updated for WoW patch 6.1

#### 12.23
* Follower upgrade items should no longer be sold by default.
* Slight changes to inteligent learning behaviour.
* Fixed chatframe possible bug.

#### 12.22
* Keybindings are now in the Addons category

#### 12.21
* Options menu now loads properly on first try.

#### 12.20
* Selling soulbound unusable equipment is now optional.
* Minor changes for preventing bugs.

#### 12.19
* Updated chinese locale ^^(by scars377)^^

#### 12.18
* Fixed issue with Scrap keybinding on ElvUI.

#### 12.17
* Now "Low Consumables" option does not sell consumables with epic or rare quality.

#### 12.16
* Fixed issue with guild repair option.

#### 12.15
* Updated for The Iron Tide.

#### 12.14
* Guild masters can now prevent automatic guild repairs by writiing '[noautorepair]' in the guild information box.

#### 12.13
* Now the addon properly indicates it works in patch 5.4.

#### 12.12
* Fixed issue ocurring when printing messages in the chat frames.

#### 12.11
* Added dirty hack to prevent a Blizzard issue from causing dialog errors to pop up.

#### 12.10
* Added option to disable the usage of guild funds for repairs.

#### 12.9
* Hotfix.

#### 12.8
* Updated for Siege of Ogrimmar.

#### 12.7
* Updated Unfit-1.0.

#### 12.6
* Now translated for Korean clients! ^^(by 강남쌍칼)^^

#### 12.5
* Updated for patch 5.3: Escalation!
* Now the merchant button properly highlights whenever there is junk, not only when it has a value.
* Improvements to the merchant tooltip.

#### 12.4
* Updated for patch 5.2: The Thunder King.
* Pet stones are now considered not junk by default, even with the "Low Consumables" option enabled.

#### 12.3
* Now fully translated to German! Translations by Noxxana.

#### 12.2
* Low level consumables and equipment without sell value will no longer be considered junk by default, even with the corresponding options enabled.

#### 12.1
* Scrap now accepts items with no sell value in the list. These will be deleted when trying to sell the scrap to the vendor.
* Now properly detects wether an upgradable item is soulbound.
* Now displays a message in the money log when equipment is automatically repaired.
* Fixed issue possibly preventing players with unlimited permissions to use the guild bank for repairs.

### 12
* Scrap can now optionally repair all your armor when you visit a merchant! You can enable the new feature at the interface options.
* Battle pet bandages are no longer scrap by default.

#### 11.6
* Updated for patch 5.1: Landfall!

#### 11.5
* Scrap is now fully localized in french! (by Noaah)

#### 11.4
* Reduced the minimum required level for Scrap to sell gray-quality equipment.

#### 11.3
* Fixed bug causing merchant buttons to go out of place when guild withdraws are allowed.

#### 11.2
* Fixed bug causing Scrap Visualizer to display incorrectly.

#### 11.1
* Tagging as release.

#### 11.0 (beta)
* Added new options category: "Visuals". This includes options to configure Scrap Spotlight, Scrap Bagnon or Combuctor Scrap, which are now able to display visual icons besides glowing borders.
* Fixed minor bug in the options window.

#### 10.11
* Updated and tested for Mists of Pandaria.
* Added monk class filters.

#### 10.10
* Set guild cloaks and standards to "useful" by default
* Now tabards, shirts and fishing poles are never junk by default

#### 10.9
* Changed the tutorials positions
* Intelligent learning bug fixing

#### 10.8
* Tagging as release

#### 10.7 (beta)
* Started to build a list of items that are by default junk or useful, disregarding the item's characteristics.

#### 10.6 (beta)
* Largely improved reliability of toggle junk
* Filters now properly react to users with equipment sets disabled
* Bugfixes

#### 10.5 (beta)
* The scrap button tooltip now displays how many items of each quality will be sold
* Junk/Useful preferences are now recorded permanently even when the user resets an item to the default state

#### 10.4 (beta)
* Another hotfix

#### 10.3 (beta)
* Small hotfix

#### 10.2 (beta)
* All behaviour settings are now global, filter settings are saved per character
* Now truly fixed the bug causing "auto sell" and "safe mode" settings to reset on login
* Now the tutorials are only fired when at the merchant

#### 10.1 (beta)
* Fixed a bug causing "auto sell" and "safe mode" settings to reset on login

### 10 (beta)
* Intelligent Learning: this new feature now allows Scrap to learn from your actions and improve its filters.
* Introducing a brand new algorithm to compare items levels and value. This will allow for much more accurate filtering results independently of level.
* Now uses Poncho-1.0, Sushi-3.0 and CustomTutorials-2.1 to generate its options and tutorials. This should provide greater performance and stability.
* The options panel, drop-down, tutorials and default settings have been completely redesigned. Therefore, the tutorials will be displayed again, even for old time users.
* Fixed a bug causing items in the bank container to not be scanned properly.
* Generally improved Scrap filtering performance.

### 9
* Introducing Scrap Spotligh: this new optional feature will make your Scrap to glow in the default UI bags
* Updated for patch 4.3
* More on Portuguese translations (thanks to myself)
* Reduced download size by about 70%
* Internal changes
* Bug fixes

#### 8.6
* New attempt to fix the Baggins bank bug
* Centralized localization

#### 8.5
* Fix of bug affecting some Baggins users

#### 8.4
* Added russian translations for the advanced options and updated the spanish ones. Thank you LordKuper and Mitrax, respectively.

#### 8.3
* Added new french and german translations for the advanced options. Thank you Noeudtribal and blizzy78, respectively.

#### 8.2
* Corrected the tutorials position on the screen.

#### 8.1
* Added new translations for Scrap Visualizer. Once more, thank you to everyone who has helped to translate Scrap recently, as Resdulac, Althathwe and yunrong.
* The advanced options are ready to be translated. If you whish to help, feel free to use our [[http://wow.curseforge.com/addons/scrap/localization/|localization tool]].
* Removed Scrap Updater

### 8.0
* Items that are part of user-defined equipment sets are no longer considered junk by default
* Items which can be sold back for a full refund to the merchant are no longer considered junk by default
* Fixed a bug causing temporarly tradeable items to be considered junk in some situations
* Updated for patch 4.2

#### 7.6
* Fixed keybinding bugs

#### 7.5
* Added two new keybindings: one that sell all the junk (if at a merchant), and another that adds or removes any item you're hovering with your mouse cursor to the junk list
* Reduced download size by 20%

#### 7.4
* No longer considers items with no sell value junk when a "Sell Low Level" option is enabled
* Minor change to prevent Scrap from not loading properly due to a possible bug
* Updated Scrap Updater accordingly
* Advanced options improvements
* //Version 7.3 has been accidentally deleted from the records//

#### 7.3
* Fixed a small bug causing Unusable items to not be considered junk by default and probably other situations as well

#### 7.2
* Grammatical bugfixes
* Chat messages bugfix
* Other minor bugfixes

#### 7.1
* Introducing the new **Advanced Options Panel**. Acessible from the //Interface Options// and from the //Scrap button's// right-click dropdown as well.
* Made more clear that sell low equip/consumables will sell **any** low level item
* Pawn Scrap works with this version
* Added new **Safe Mode** option

### 7
* Uses a new, much more reliable and faster junk list caching system, designed for tomorrow's needs
* Faster detection and filtering of junk items

* Low level //gray// equipement is now only not considered junk for low level characters
* Altough Pawn Scrap is an experimental feature too, it does not work with this version yet
* //Sell Low Equip// is available in this version
** Now also works for enchanters

#### 6.4
* Due to disturbing occurrences, disabled **temporarily** the "Sell Low Equip" option. Please keep in mind that this feature **is still experimetal**.
* As a reminder, Pawn Scrap is also an **experimental feature**.

#### 6.3
* "Sell Low Equip" no longer considers fishing poles junk on all localization
* Pawn Scrap no longer considers fishing rods, tabards, trinkets and shirts junk

#### 6.2
* Now uses library "Unfit-1.0" for detecting unusable equipment. This library was created for an easier data sharing between Scrap and other projects I'm working on, such as Bagnon and Combuctor.

#### 6.1
* Updated for 4.1
* Now supports Bagnon Scrap

### 6
* Fixed incorrect proficiences
* Fixed a bug preventing "Sell Low Level Equipment" from actually working
* Several improvements to the low level equipment detection filters
* Fixed a bug causing anomalies in some clients when playing female characters ^^(this time is for real)^^

#### 5.9
* Made the unusable souldbound equipment features to work on any client language
* Fixed a bug causing class-specific items to be considered junk in some locales for female characters
* "Sell low consumables" should no longer sell items with no item level

#### 5.8
* Forgot to actually enable the new features announced last version: they are now listed in the options dropdown.
* //Pawn Scrap// support was enabled too.
* First steps to make the built-in feature "consider unusable soulbound equipment for non-enchanters junk by default" to work on all clients

#### 5.7
* Added new options: "Sell Low Level Equipment" and "Sell Low Level Consumables". These options are still experimental, if you find an useful item considered junk, please let us know. Feedback and suggestions are highly welcome.
* Added support for //Pawn Scrap//.

#### 5.6
* Made the Visualizer completely load on demand
* Finnaly added a description for the Visualizer
* New features are on testing stage and should be released very soon

#### 5.5
* Items can now be added/removed from the junk list by clicking on the item in your bags and then on the button ^^(just as you can move items in your bags too)^^
* Added a "Add to Junk List" and "Remove From Junk List" buttons to the Visualizer
* Made a more convenient API for toggling the items in the junk list
* Added a nice Visualizer picture to the site

#### 5.4
* Made Visualizer ready for localization
* Updated a Traditional Chinese translations
* Small tweak on the Visualizer

#### 5.3
* Added "Junk" and "Not Junk" tabs to the Visualizer window, so now you can also see which items you removed from the junk list
* Now, when the item list is not long enough to show the scrolling bar, the lists resizes to fill that space

#### 5.2
* Updated for the last //CustomTutorials// version
* Fixed a bug causing errors when printing chat messages in some situations
* Fixed the weirdest bug ever reported
* Small internal tweaks

#### 5.1
* Fixed a bug causing the "money pile" to be clickable when at the Visualizer tab
* Fixed a bug causing the Visualizer icon to not show properly in some merchants
* The Visualizer scrolling size is now more accurate

### 5
* I'm glad to present you __Scrap Visualizer__, a long waited and asked feature!
** Displays your junk list in a separate tab on the merchant window
** Almost complete, but expect improvements and bug fixes in the next few weeks
** You still can only see which items you added to the list, but you will be able to see which ones you removed in future versions
** Feel free to provide suggestions ^^(keep them coming)^^

#### 4.10
* Minor tweaks
* Updated CustomTutorials-2.0 //(otherwise, could crash with [[http://wow.curse.com/downloads/wow-addons/details/cornucopia.aspx|Cornucopia]])//
* Removed many unnecessary library files (making download size a bit smaller)

#### 4.9
* Starting level poor equipment is no longer considered Scrap by default (as it can be useful at those levels)

#### 4.8
* Small tweak to the configuration dropdown
* Updated CustomTutorials-2.0

#### 4.7
* Updated french translations (thank you //mius64//)

#### 4.6
* Minor tweaks

#### 4.5
* Fixed [[http://wow.curseforge.com/addons/scrap/tickets/19-cant-add-items-to-junk-list|recent bug]] with Scrap Launcher

#### 4.4
* Slight tutorial text improvement
* Updated addon/modules descriptions

#### 4.3
* Auto sell was bugging for some users, should be fixed now. If not, let me know** which addons are you using**.

#### 4.2
* Tutorials are back: cheer up for CustomTutorials-2.0

#### 4.1
* Improved the options menu look
* Disabled tutorials for now
* Hopefully made a bug fix
* Added compatibility to Scrap's new plugin: Scrap Cleaner!

### 4
* Updated for 4.0.1
* Scrap will no longer consider soulbound armor which your character will never use junk if you are an enchanter
* Tutorials are not working yet

#### 3.1
* Scrap will now consider soul-bound equipment items your character can't equip junk by default //(careful enchanters!)//
* Added Chinese and Spanish translations //(thanks to thwa and yllelder, respectively)//
* Other translation updates

### 3
* Tested on 3.3.3 patch
* Added German and updated Russian translations //(thanks to ckaotik and RustamIrzaev, respectively)//

#### 2.2
* Added some French translations //(thanks to laumacwow)//

#### 2.1
* Moved the tutorials to a more convenient position on the screen
* Added Russian translation //(thanks to p4tv)//

### 2
* Went back to the old options dropdown. Without the junk lists option, the window does not make much sense.
* Added new "blizzard-style" tutorials. Stop pressing F3!
* Small code changes to allow compatibility with Scrap Launcher

#### 1.2
* Fixed a bug breaking SpamSentry
* Fixed a bug causing lists to not be saved in some situations
* Permanently deleted the old profile data

#### 1.1
* Fixed a bug breaking Combuctor_Scrap and Baggins_Scrap

### 1
* New custom icon
* Junk lists are now saved per-character (old global profiles will be kept for now, so this change is reversible). If you wish to have profiles, use Reflux.
* New option window:
** Replaces the old options drop-down
** Was built using a new library (Sushi-2.0), so it may be unstable. Feedback is highly welcome
** As the junk lists are saved per-character, most of the window's space is empty. Ideas for new options are welcome.
* Now items with no sell value can be added to the junk lists
* No longer beta