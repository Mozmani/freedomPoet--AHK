;;;;; NEEDED TO RUN ;;;;;
#Include <classMemory>
#include botLauncherConfig.ini
;;;;; OPTOMIZE SORCERY ;;;;;
#singleinstance force
#NoEnv
SetBatchLines -1
ListLines Off
;;;;; OTHER GOODIES ;;;;;
coordmode, mouse, client 
coordmode, pixel, screen 
coordmode, tooltip, screen
#InstallMouseHook
SetKeyDelay, 0, 0
;;;;; SET THE WINDOW ID/NAMES ;;;;;
WinGet, id, List, TKReborn
loop, %boxes% {
	WinSetTitle, % "ahk_id " id%A_Index%, , TKReborn%A_Index%
	TKReborn%a_index% := new _ClassMemory("TKReborn"a_index, "", hProcessCopy)
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; ON THE GO SCRIPT MAINTENANCE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
~$`::Suspend
~!r::Reload
~!^q::exitApp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; TOGGLE BOT  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$f11::
if (castSpells=1) {
	castSpells = 0
	castSpellsState = OFF
	return
}
if (castSpells=0) {
	castSpells =  1
	castSpellsState = ON
	return
}
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; RESET PLAYER  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$+f11::
inputbox, asvReset, poet, ASV reset?,,150,140,,,,30,0
asvTimer%asvReset% := asvTimer%asvReset% - 1000000
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; #####  #   #  #####     #####    ###   ##### ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;   #    #   #  #         #    #  #   #    #   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;   #    #####  #####     #####   #   #    #   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;   #    #   #  #         #    #  #   #    #   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;   #    #   #  #####     #####    ###     #   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$^f11::
;build regular variables
	castSpells = 0
	castSpellsState = OFF
;build full variable preset
	loop % boxes {
		if (char%a_index% = 2) {
			buffTemp := a_index
			spellCount%a_index% := 0
			spellTicker%a_index% := a_tickcount
			loop % %a_index%buffs { ; build the buff timers
				%buffTemp%buffTimer%a_index% := a_tickcount - 1000000
			}
		}
	} ; full variable preset complete

	loop { ; infinity loop, start of the working bot
		ping1 := A_TickCount ; start the stop watch ping timer
		loop % boxes {
			buffTemp := a_index ; cache the poet
			if (char%a_index% = 2) and (castSpells = 1) { ; full variable loop

				if ((a_tickcount-spellTicker%buffTemp%) > 2000) { ; reset spell tickers
					spellCount%buffTemp% := 0
					spellTicker%buffTemp% := a_tickcount 
				}
				loop % %buffTemp%buffs { ; start checking buffs
					curMana := TKReborn%buffTemp%.read(0x6FE238, "UInt", 0x10C)
						if ((a_tickcount-%buffTemp%buffTimer%a_index%)>%buffTemp%buffAther%a_index%) and (spellCount%buffTemp% < 2) {
						
						if (curMana < %buffTemp%buffCost%a_index%)
								Controlsend,, u%wineKey%, TKReborn%buffTemp%
							tempKey := %buffTemp%buffKey%a_index%
							Controlsend,, %tempKey%, TKReborn%buffTemp%

			%buffTemp%buffTimer%a_index% := a_tickcount
							spellCount%buffTemp% ++
			}
					
					}
				;overlayBuild := 
			} ; end full variable loop
		} ; end group loop
		ping2 := A_TickCount - ping1 ; calculate ping
		ping3 := 200 - ping2 ; do we need to slow down?
		sleep % ping3 ; slow down
tooltip, autoBuff: %castSpellsState%, 0, 30
	} ;end infinite loop
return
