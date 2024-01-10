#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>

Opt("GuiOnEventMode", 1)
HotKeySet("{ESC}", "QuitApp")

If Not IsDeclared("WM_WINDOWPOSCHANGED") Then Assign("WM_WINDOWPOSCHANGED",0x0047)
Global $ahGUI[4]
Global $Last_hControl = -1

Global $Frame_Color = 0xff0000;0xFF0000
Global $Frame_Width = 2
Global $hCtrl
$Main_GUI = GuiCreate("Highlight Controls Demo")
GUISetOnEvent($GUI_EVENT_CLOSE, "QuitApp")
GUIRegisterMsg($WM_WINDOWPOSCHANGED, "WM_WINDOWPOSCHANGED")


GUICtrlCreateButton("Button", 20, 20)
GUICtrlCreateCheckbox("CheckBox", 20, 60)
GUICtrlCreateEdit("", 120, 60, 240, 150)


GUICtrlCreateLabel("Info: ", 20, 250)
GUICtrlSetFont(-1, 9, 800)
$Info_Label = GUICtrlCreateLabel("", 120, 270, 250, 80)

GUISetState()

While 1
    Sleep(100)

    $hCtrl = _ControlGetHovered()

    If $hCtrl <> 0 And $Last_hControl <> $hCtrl And Not IsHighLight_GUIs($hCtrl) Then
        if not _IsPressed("1") Then
            $Last_hControl = $hCtrl
            $aCtrlPos = WinGetPos($hCtrl)

            GUICtrlSetData($Info_Label, _
                    "X = " & $aCtrlPos[0] & @CRLF & _
                    "Y = " & $aCtrlPos[1] & @CRLF & _
                    "W = " & $aCtrlPos[2] & @CRLF & _
                    "H = " & $aCtrlPos[3] & @CRLF & _
                    "Control Data = " & ControlGetText($hCtrl, "", ""))

            GUISquareDelete()
            GUICreateSquare($aCtrlPos[0], $aCtrlPos[1], $aCtrlPos[2], $aCtrlPos[3])
        EndIf
    Else
        $aNewCtrlPos = WinGetPos($hCtrl)
        for $n = 0 to 3
            if $aCtrlPos[$n] <> $aNewCtrlPos[$n] Then
                GUISquareDelete()
                $hCtrl = 0
                $Last_hControl = 0
                ExitLoop
            EndIf
        Next
    EndIf
WEnd

Func GUICreateSquare($X, $Y, $W, $H)
    $X -= $Frame_Width
    $Y -= $Frame_Width
    $W += $Frame_Width
    $H += $Frame_Width
    $ahGUI[0] = GUICreate("", $W, $Frame_Width, $X, $Y, $WS_POPUP, $WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
    GUISetBkColor($Frame_Color)

    $ahGUI[1] = GUICreate("", $Frame_Width, $H, $X, $Y, $WS_POPUP, $WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
    GUISetBkColor($Frame_Color)

    $ahGUI[2] = GUICreate("", $Frame_Width, $H, $X+$W, $Y, $WS_POPUP, $WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
    GUISetBkColor($Frame_Color)

    $ahGUI[3] = GUICreate("", $W+$Frame_Width, $Frame_Width, $X, $Y+$H, $WS_POPUP, $WS_EX_TOPMOST+$WS_EX_TOOLWINDOW)
    GUISetBkColor($Frame_Color)

    For $i = 0 To 3
        GUISetState(@SW_SHOW, $ahGUI[$i])
    Next
EndFunc

Func GUISquareDelete()
    For $i = 0 To 3
        If IsHWnd($ahGUI[$i]) And $ahGUI[$i] <> $Main_GUI Then GUIDelete($ahGUI[$i])
    Next

    $ahGUI = ""
    Dim $ahGUI[4]
EndFunc

Func IsHighLight_GUIs($hCtrl)
    For $i = 0 To 3
        If $ahGUI[$i] = $hCtrl Then Return True
    Next
    Return False
EndFunc

Func _ControlGetHovered()
    Local $aRet = DllCall("user32.dll", "int", "WindowFromPoint", "long", MouseGetPos(0), "long", MouseGetPos(1))
    If Not IsArray($aRet) Then Return SetError(1, 0, 0)
    Return HWnd($aRet[0])
EndFunc


Func WM_WINDOWPOSCHANGED($hWndGUI, $MsgID, $WParam, $LParam)
    If $hWndGUI = $Main_GUI or $hWndGUI = $hCtrl Then
        GUISquareDelete()
        $Last_hControl = -1
    Else
        Return $GUI_RUNDEFMSG
    EndIf
EndFunc

Func QuitApp()
    Exit
EndFunc