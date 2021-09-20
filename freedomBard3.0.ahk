
;;;;; NEEDED TO RUN ;;;;;
#Include <classMemory>
#include botLauncherConfigBARD.ini
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
            if (_ClassMemory.__Class != "_ClassMemory")
            {
                msgbox class memory not correctly installed. Or the (global class) variable "_ClassMemory" has been overwritten
                ExitApp
            }
WinGet, id, List, BlankTK
loop, %boxes% {
	WinSetTitle, % "ahk_id " id%A_Index%, , freedomPoet%A_Index%
	freedomPoet%a_index% := new _ClassMemory("freedomPoet"a_index, "", hProcessCopy)
}

game := new _ClassMemory("ahk_exe BloonsTk.exe")
BA := game.BaseAddress

statusCode:= 0x44724
statusCode1 := 0x144
scSleep := 10000
songSleep := 4000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; ON THE GO SCRIPT MAINTENANCE  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
~!^y::Suspend
~!p::Reload
~!^q::exitApp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; TOGGLE BOT  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$+f12::
inputbox, temp1, PARTY SLOT,,,150,140,,,,30,0
inputbox, temp2, ON / OFF,,,150,140,,,,30,0
inspire%temp1% := temp2
return

$f12::
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
$f8::
castScourge ++
if (castScourge > 1)
	castScourge = 0
if castScourge=0
	castScourgeState = OFF
if castScourge=1
	castScourgeState = SMART
if castScourge=2
	castScourgeState = MED
if castScourge=3
	castScourgeState = HIGH
return

$f10::
castScourge = 0
castScourgeAuto++
if (castScourgeAuto > 1)
	castScourgeAuto = 0
if castScourgeAuto = 0
	castScourgeState = OFF
if castScourgeAuto = 1
	castScourgeState = AUTO (Casting!)
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; RESET PLAYER  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$!f12::
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
$^f12::
;build regular variables
	uidCounter = 0
	matchSC = 0
	castSpells = 0
	castSpellsState = OFF
	castScourge = 0
	castScourgeAuto = 0
	castScourgeState = OFF
	recentInvoke = 0
	loop, 20 { ; needs to be set to maximum possible group size to ensure full group asv capability
		asvTimer%a_index% := a_tickcount - 1000000
		shieldTimer%a_index% := a_tickcount - 1000000
		inspire%a_index% := 0
		waitToHeal%a_index% = 0
	}
	loop, 100 { ; build the SC scanner variable tables;
		tempUIDTimer%a_index% := a_tickcount - 1000000
		tempUID%a_index% := 0
	}
				
;build full variable preset
	loop % boxes {
		if (char%a_index% = 1) {
			spellTicker%a_index% := a_tickcount
			invokeTimer%a_index% := a_tickcount - 1000000
			restoreTimer%a_index% := a_tickcount - 1000000
			scTimer%a_index% := a_tickcount - 1000000
			songTimer%a_index% := a_tickcount - 1000000
			spellCount%a_index% = 0
;			smartOverlay := smartOverlay"`nInvoke"a_index: %"invokeOverlay"a_index%
		}
	} ; full variable preset complete

	loop { ; infinity loop, start of the working bot
		%a_index%ping1 := A_TickCount ; start the stop watch ping timer
		loop % boxes {
			poetTemp := a_index ; cache the poet
			if (char%a_index% = 1) and (castSpells = 1) { ; full variable loop

				if ((a_tickcount-spellTicker%a_index%) >= 1000) { ; reset spell tickers
					spellCount%a_index% = 0
					spellTicker%a_index% := a_tickcount
				}

				;inspire start
				groupSize := freedomPoet%a_index%.read(groupBaseAddress, "UInt", groupSizeOffset)
				loop % groupSize {
					curMana%a_index% := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupCurMana + ((groupOffsetMult * a_index) - groupOffsetMult)))
					maxMana%a_index% := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupMaxMana + ((groupOffsetMult * a_index) - groupOffsetMult)))
					manaP%a_index% := ((100 / maxMana%a_index%) * curMana%a_index%)
;					temp := a_index
						if (inspire%a_index% = 1) and (90 > manaP%a_index%) and (spellCount%poetTemp% < 3) and ((a_tickcount-invokeTimer%poetTemp%)>invokeAther) {
							targetUID := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * a_index) - groupOffsetMult)))
							freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
							Controlsend,, {Blind}%inspireKey%, freedomPoet%poetTemp%
							sleep, 10
							Controlsend,, {Blind}{enter}, freedomPoet%poetTemp%
							spellCount%poetTemp% ++
						}
				}

				;invoke	start
				curMana := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x10C)
				maxMana := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x110)
				curManaP := ((100 / maxMana) * curMana)
					if (curManaP < 75) {
						if ((a_tickcount-invokeTimer%a_index%)>invokeAther) and (spellCount%a_index% < 3) {
							if (curMana<invokeCost) {
								Controlsend,, {Blind}u%wineKey%, freedomPoet%a_index%
							}
							Controlsend,, {Blind}%invokeKey%, freedomPoet%a_index%
							curMana := maxMana
							invokeTimer%a_index% := a_tickcount
							spellCount%a_index% ++
							recentInvoke = 1
						}
					}

					;heal start
					groupSize := freedomPoet%a_index%.read(groupBaseAddress, "UInt", groupSizeOffset)
					loop % groupSize {
						curVita%a_index% := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupCurVita + ((groupOffsetMult * a_index) - groupOffsetMult)))
						maxVita%a_index% := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupMaxVita + ((groupOffsetMult * a_index) - groupOffsetMult)))
						vitaP%a_index% := ((100 / maxVita%a_index%) * curVita%a_index%)
						temp := a_index 
							; Restore
							if (35 > vitaP%a_index%)  and (spellCount%a_index% < 3) and (curMana>(restoreCost+30)) and ((a_tickcount-restoreTimer%poetTemp%)>restoreAther) {
								freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
								Controlsend,, {Blind}%restoreKey%{enter}, freedomPoet%poetTemp%
								spellCount%poetTemp% ++
								curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
							}
						
							if (90 < vitaP%a_index%)
								waitToHeal%a_index% = 0
							if (90 > vitaP%a_index%) and (waitToHeal%a_index% = 0) {
								waitToHeal%a_index% = 1
								healMeTimer%a_index% := a_tickcount
								}
							if ((a_tickcount-healMeTimer%a_index%) > 5000) and (waitToHeal%a_index% = 1) and (spellCount%poetTemp% < 3) and (curMana>(healCost+30)) {
								targetUID := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * temp) - groupOffsetMult)))
								freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
								Controlsend,, {Blind}%healKey%{enter}, freedomPoet%poetTemp%
								spellCount%poetTemp% ++
								curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
							}
								
							if (90 > vitaP%a_index%) and (spellCount%a_index% < 3) and (curMana>(healCost+30)) {
								targetUID := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * temp) - groupOffsetMult)))
								freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
								Controlsend,, {Blind}%healKey%{enter}, freedomPoet%poetTemp%
								spellCount%poetTemp% ++
								curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
							}
					}

					;asv

					
						if ((a_tickcount-asvTimer%a_index%)>asvAther) and ((a_tickcount - songTimer%a_index%) > songSleep) and (spellCount%poetTemp% = 0) and (curMana>(asvCost+30)) { 
							targetUID := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * a_index) - groupOffsetMult)))
							freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
							Controlsend,, {Blind}%asvKey%, freedomPoet%poetTemp%
							asvTimer%a_index% := a_tickcount
							songTimer%a_index% := a_tickcount
							spellCount%poetTemp% ++
							curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
						}
						
					;shield set up -- every 7 sec :)
					
						if(( a_tickcount-shieldTimer%a_index%)>shieldAther) and ((a_tickcount - songTimer%a_index%) > songSleep) and (spellCount%poetTemp% = 0) and (curMana>(shieldCost+30)) {
							targetUID := freedomPoet%poetTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * a_index) - groupOffsetMult)))
							freedomPoet%poetTemp%.write(spellCastUID, targetUID, "Int")
							Controlsend,, {Blind}%shieldKey%, freedomPoet%poetTemp%
							shieldTimer%a_index% := a_tickcount
							songTimer%a_index% := a_tickcount
							spellCount%poetTemp% ++
							curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
						
						}
					

					;harden body
					curVita := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x104)
						if (curVita<cacheVita%poetTemp%) and (curMana>(hardenBodyCost+30)) and (spellCount%poetTemp% < 3) and (recentInvoke != 1) { 
							Controlsend,, {Blind}%hardenBodyKey%, freedomPoet%poetTemp%
							Controlsend,, {Blind}%hardenBodyKey%, freedomPoet%poetTemp%
							spellCount%poetTemp% ++
							curMana := freedomPoet%poetTemp%.read(0x6FE238, "UInt", 0x10C)
						} 
					cacheVita%poetTemp% := curVita
					recentInvoke=0
					
					;SC START
                    if (castScourge > 0) and (spellCount%poetTemp% < 3) and (curMana>(scourgeCost+30)) {
						
						status := freedomPoet%poetTemp%.read(BA + statusCode, "int", statusCode1)
						Controlsend,, {Blind}%scourgeKey%, freedomPoet%poetTemp%
						spellCount%poetTemp% ++
						
									; debug box, can remove semi colon on msgbox to decode mem values!
									; MsgBox, 0,, %status%
						; status check for not sc cast is commented out, current is no target or aethers 1-9
						if ( status = 1701278305) or  (status >= 1931489568 and status <= 1931491360 ) {
						; if (status != 1953718627) {
							castScourge = 0
							castScourgeState = OFF
										
						}       
							
							
                    }


					if (castScourgeAuto > 0) and (a_tickcount - scTimer%a_index% > scSleep) and (spellCount%poetTemp% < 3) and (curMana>(scourgeCost+30)) {
						
						castScourgeState = AUTO (Casting!)
						Controlsend,, {Blind}%scourgeKey%, freedomPoet%poetTemp%
						spellCount%poetTemp% ++
						
						status := freedomPoet%poetTemp%.read(BA + statusCode, "int", statusCode1)
						; calc := a_tickcount - scTimer%a_index%
						
									; debug box, can remove semi colon on msgbox to decode mem values!
									; MsgBox, 0,,  calc =  %calc%  SCSLEEP %scSleep% 
						
						if ( status = 1701278305) or  (status >= 1931489568 and status <= 1931491360 ) {
						;if (status != 1953718627) {
							scTimer%a_index% := a_tickcount
							castScourgeState = AUTO (Waiting to scan!)
										
						}       
							
							
                    }

					; end cast scourge
					
				;invoke timer
				invokeOverlay%a_index% := a_tickcount - invokeTimer%a_index%
				invokeOverlay%a_index% := invokeOverlay%a_index% * 0.001
				invokeOverlay%a_index% := 24 - invokeOverlay%a_index%
				setformat, float, 0
				if invokeOverlay%a_index% <= 0
				invokeOverlay%a_index% = Ready
				
				;restore timer
				restoreOverlay%a_index% := a_tickcount - restoreTimer%a_index%
				restoreOverlay%a_index% := restoreOverlay%a_index% * 0.001
				restoreOverlay%a_index% := 11 - restoreOverlay%a_index%
				setformat, float, 0
				if restoreOverlay%a_index% <= 0
				restoreOverlay%a_index% = Ready

				;overlayBuild := 
			} ; end full variable loop
		} ; end group loop
		ping2 := A_TickCount - %a_index%ping1 ; calculate ping
		ping3 := 100 - ping2 ; do we need to slow down?
		sleep % ping3 ; slow down
		;tooltip, Caster State: %castSpellsState% %smartOverlay% `n Scourge: %scourgeDisplay% `n Group Size: %groupSize% `n Spell Count: %spellCount%a_index%% `n ping: %ping2%, 0, 0 
		tooltip, freedomBard: %castSpellsState% | castScourge: %castScourgeState%, 0, 0
	} ;end infinite loop
return
