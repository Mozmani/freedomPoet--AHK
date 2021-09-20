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
WinGet, id, List, BlankTK
loop, %boxes% {
	WinSetTitle, % "ahk_id " id%A_Index%, , freedomPoet%A_Index%
	freedomPoet%a_index% := new _ClassMemory("freedomPoet"a_index, "", hProcessCopy)
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
$+f6::
inputbox, followDistance, FOLLOWER, How close?,,150,140,,,,30,3
return

$f6::
if (autoFollow = 1) {
	autoFollow = 0
	autoFollowState = OFF
	return
}
if (autoFollow != 1) {
	autoFollow =  1
	autoFollowState = ON
	return
}
return ; if nothing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; MOVE ALL CHARS TO ACTIVE WINDOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$^f6::
; presets
autoFollow = 0
autoFollowState = OFF
loop {  ; infinite loop, can't use a_index here
	ping1 := A_TickCount ; start the stop watch ping timer
	loop % boxes { ; search for active window
		WinGetActiveTitle, activeWindow
		if (autoFollow=1) and (activeWindow = "freedomPoet"a_index) { ; turned on and leader is active
			loop % boxes { ; pull all current x/y coords and do some maths
				map%a_index% := freedomPoet%a_index%.readString(0x6FE204,,, 0xF8)
				
				x%a_index% := freedomPoet%a_index%.read(0x6FE238, "UInt", 0xFC)
				y%a_index% := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x100)
					if (activeWindow = "freedomPoet"a_index) { 
						xLeader := freedomPoet%a_index%.read(0x6FE238, "UInt", 0xFC)
						yLeader := freedomPoet%a_index%.read(0x6FE238, "UInt", 0x100)
						}
					if (xLeader > x%a_index%)
						2x%a_index% := xLeader - x%a_index%
					if (xLeader <= x%a_index%)
						2x%a_index% := x%a_index% - xLeader
					if (yLeader > y%a_index%)
						2y%a_index% := yLeader - y%a_index%
					if (yLeader <= y%a_index%)
						2y%a_index% := y%a_index% - yLeader
				3x%a_index% := xLeader - x%a_index%
				3y%a_index% := yLeader - y%a_index%
				;cache section for map follow
				}
			loop %boxes% { ; move all non-active windows to active window
				if ((2x%a_index% + 2y%a_index%) > followDistance) and (activeWindow != "freedomPoet"a_index) { ; too far away and not active window
					if (2x%a_index% > 2y%a_index%) and (3x%a_index% > 0) { ; right
						Controlsend,, {right 2}, freedomPoet%A_Index%
						random, rand1, 1, 3
							if rand1 = 1
								Controlsend,, {down 2}, freedomPoet%A_Index%
							if rand1 = 2
								Controlsend,, {up 2}, freedomPoet%A_Index%
							if rand1 = 3
								Controlsend,, {right 2}, freedomPoet%A_Index%
							if rand1 = 4
								Controlsend,, {left 2}, freedomPoet%A_Index%
					}
					if (2x%a_index% > 2y%a_index%) and (3x%a_index% < 0) { ; left
						Controlsend,, {left 2}, freedomPoet%A_Index%
						random, rand1, 1, 3
							if rand1 = 1
								Controlsend,, {up 2}, freedomPoet%A_Index%
							if rand1 = 2
								Controlsend,, {down 2}, freedomPoet%A_Index%
							if rand1 = 3
								Controlsend,, {left 2}, freedomPoet%A_Index%
							if rand1 = 4
								Controlsend,, {right 2}, freedomPoet%A_Index%
					}
					if (2x%a_index% <= 2y%a_index%) and (3y%a_index% > 0) { ; down
						Controlsend,, {down 2}, freedomPoet%A_Index%
						random, rand1, 1, 3
							if rand1 = 1
								Controlsend,, {left 2}, freedomPoet%A_Index%
							if rand1 = 2
								Controlsend,, {right 2}, freedomPoet%A_Index%
							if rand1 = 3
								Controlsend,, {down 2}, freedomPoet%A_Index%
							if rand1 = 4
								Controlsend,, {up 2}, freedomPoet%A_Index%
					}
					if (2x%a_index% <= 2y%a_index%) and (3y%a_index% < 0) { ;left
						Controlsend,, {up 2}, freedomPoet%A_Index%
						random, rand1, 1, 3
							if rand1 = 1
								Controlsend,, {right 2}, freedomPoet%A_Index%
							if rand1 = 2
								Controlsend,, {left 2}, freedomPoet%A_Index%
							if rand1 = 3
								Controlsend,, {up 2}, freedomPoet%A_Index%
							if rand1 = 4
								Controlsend,, {down 2}, freedomPoet%A_Index%
					}
				}
			} ; end move all chars
		} ; end bot loop
	} ; end search for active window
			tooltip, autoFollow: %autoFollowState%,0, 90
		sleep, 100	

}
return

