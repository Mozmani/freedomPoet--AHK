#SingleInstance force
#Persistent
if not A_IsAdmin
Run *RunAs "%A_ScriptFullPath%"
Tooltip, Insert Wizard here by right clicking on his client, 150, 150
KeyWait, RButton, D
WinGet, Wizard, ID, A
ToolTip, , 150, 150
Sleep 500




Pause, Toggle
Loop
{
SetKeyDelay, 250, 250
ControlSend,,63{enter}, ahk_id %Wizard%
sleep, 300

SetKeyDelay, 350, 150
ControlSend,,64{enter}, ahk_id %Wizard%
sleep, 250

SetKeyDelay, 150, 150
ControlSend,,6, ahk_id %Wizard%
sleep, 150

SetKeyDelay, 150, 150
ControlSend,,68{enter}, ahk_id %Wizard%
sleep, 150

SetKeyDelay, 150, 150
ControlSend,,69{enter}, ahk_id %Wizard%
sleep, 250

setkeydelay, 300, 300
ControlSend,,{Enter}, ahk_id %Wizard%
sleep, 250

setkeydelay, 150, 150
ControlSend,,677, ahk_id %Wizard%
sleep, 150


setkeydelay, 150, 150
ControlSend,,677, ahk_id %Wizard%
sleep, 250

SetKeyDelay, 150, 150
ControlSend,,6, ahk_id %Wizard%
sleep, 250

setkeydelay, 100, 100
ControlSend,,6777777, ahk_id %Wizard%
sleep, 150

setkeydelay, 250, 250
ControlSend,,6777777, ahk_id %Wizard%
sleep, 250


}





\:: Pause
]:: Suspend
