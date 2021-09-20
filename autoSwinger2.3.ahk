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
WinGet, id, List, BlankTk
loop, %boxes% {
	WinSetTitle, % "ahk_id " id%A_Index%, , freedomPoet%A_Index%
	freedomPoet%a_index% := new _ClassMemory("TKReborn"a_index, "", hProcessCopy)
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
$f10::
if (swing = 1) {
	swing = 0
	swing_state = OFF
	return
}
if (swing = 0) {
	swing =  1
	swing_state = ON
	return
}
return

$^f10::
swing = 0
swing_state = OFF
loop { ; infinite loop
	if (swing = 1) {
		loop %boxes% {
			if (autoSwing%a_index% = 1)
				Controlsend,, {space}, % "ahk_id " id%A_Index%
		}
	}
	sleep, 50
	tooltip, Swinger: %swing_state%, 0, 60
}
return