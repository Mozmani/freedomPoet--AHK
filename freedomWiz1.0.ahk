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

WinGet, id, List, BlankTK
loop, %boxes% {
	WinSetTitle, % "ahk_id " id%A_Index%, , freedomPoet%A_Index%
	freedomPoet%a_index% := new _ClassMemory("freedomPoet"a_index, "", hProcessCopy)
}

game := new _ClassMemory("ahk_exe BloonsTk.exe")
BA := game.BaseAddress

statusCode:= 0x44724
statusCode1 := 0x144
diamondDustSleep := 29000

$f4::
	if (castSpells=1) {
		castSpells = 0
		castSpellsState = OFF
		return
	}
	if (castSpells=0) {
		castSpells = 1
		castSpellsState = ON
		return
	}
return

$f5::
	castVenom++
	if (castVenom > 1)
		castVenom = 0
	if castVenom = 0
		castVenomState = OFF
	if castScourgeAuto = 1
		castVenomState = AUTO (Casting!)
return

$+f12::
	inputbox, temp1, PARTY SLOT,,,150,140,,,,30,0
	inputbox, temp2, ON / OFF,,,150,140,,,,30,0
	diamondDust%temp1% := temp2
return

$^f4::
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
			meditateTimer%a_index% := a_tickcount - 1000000
			venomTimer%a_index% := a_tickcount - 1000000
			diamondDustTimer%a_index% := a_tickcount - 1000000
            thunderStormTimer%a_index% := a_tickCount - 1000000

			spellCount%a_index% = 0
			;			smartOverlay := smartOverlay"`nInvoke"a_index: %"invokeOverlay"a_index%
		}
	} ; full variable preset complete

	loop { ; infinity loop, start of the working bot
		%a_index%ping1 := A_TickCount ; start the stop watch ping timer
		loop % boxes {
			wizTemp := a_index ; cache the poet
			if (char%a_index% = 2) and (castSpells = 1) { ; full variable loop

				if ((a_tickcount-spellTicker%a_index%) >= 1000) { ; reset spell tickers
					spellCount%a_index% = 0
					spellTicker%a_index% := a_tickcount
				}

				;diamond dust start
				groupSize := freedomPoet%a_index%.read(groupBaseAddress, "UInt", groupSizeOffset)
				loop % groupSize {
					curMana%a_index% := freedomPoet%wizTemp%.read(groupBaseAddress, "UInt", (groupCurMana + ((groupOffsetMult * a_index) - groupOffsetMult)))
					maxMana%a_index% := freedomPoet%wizTemp%.read(groupBaseAddress, "UInt", (groupMaxMana + ((groupOffsetMult * a_index) - groupOffsetMult)))
					manaP%a_index% := ((100 / maxMana%a_index%) * curMana%a_index%)
					;					temp := a_index
					if (diamondDust%a_index% = 1) and (curMana > 6000) and (spellCount%wizTemp% < 3) 
                    and ((a_tickcount - diamondDustTimer%a_index%) > diamondDustAether) {
						targetUID := freedomPoet%wizTemp%.read(groupBaseAddress, "UInt", (groupUID + ((groupOffsetMult * a_index) - groupOffsetMult)))
						freedomPoet%wizTemp%.write(spellCastUID, targetUID, "Int")
						Controlsend,, {Blind}%diamondDustKey%, freedomPoet%wizTemp%
						sleep, 150
						Controlsend,, {Blind}{enter}, freedomPoet%wizTemp%
                        diamondDustTimer%a_index% := a_tickcount
						spellCount%wizTemp% ++
					}
				}

				;invoke	start
				; curMana := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x10C)
				; maxMana := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x110)
				; curManaP := ((100 / maxMana) * curMana)
				; if (curManaP < 75) {
				; 	if ((a_tickcount-invokeTimer%a_index%)>invokeAther) and (spellCount%a_index% < 3) {
				; 		if (curMana<invokeCost) {
				; 			Controlsend,, {Blind}u%wineKey%, freedomPoet%a_index%
				; 		}
				; 		Controlsend,, {Blind}%invokeKey%, freedomPoet%a_index%
				; 		sleep 150
				; 		Controlsend,, {Blind}%invokeKey%, freedomPoet%a_index%
				; 		sleep 150
				; 		curMana := maxMana
				; 		invokeTimer%a_index% := a_tickcount
				; 		spellCount%a_index% ++
				; 		recentInvoke = 1
				; 	}
				; }

				;overlayBuild := 
			} ; end full variable loop
		} ; end group loop
		ping2 := A_TickCount - %a_index%ping1 ; calculate ping
		ping3 := 100 - ping2 ; do we need to slow down?
		sleep % ping3 ; slow down
		;tooltip, Caster State: %castSpellsState% %smartOverlay% `n Scourge: %scourgeDisplay% `n Group Size: %groupSize% `n Spell Count: %spellCount%a_index%% `n ping: %ping2%, 0, 0 
		tooltip, freedomPoet: %castSpellsState% | castScourge: %castVenomState%, 0, 0 
	} ;end infinite loop
return

