#include <GUIConstantsEx.au3>

$hGUI = GUICreate("Example Button Context Menu", 623, 449, 192, 114)
$hBtnClick = GUICtrlCreateButton("Click", 64, 80, 75, 25)
$hBtnArrow = GUICtrlCreateButton("6", 136, 80, 30, 25)
GUICtrlSetFont(-1, 12, 800, 0, "Webdings")
$hBtnArrowContext = GUICtrlCreateContextMenu($hBtnArrow)
$MenuItem4 = GUICtrlCreateMenuItem("Open your mind", $hBtnArrowContext)
$MenuItem3 = GUICtrlCreateMenuItem("Close your eyes", $hBtnArrowContext)
$MenuItem2 = GUICtrlCreateMenuItem("", $hBtnArrowContext)
$MenuItem1 = GUICtrlCreateMenuItem("Get out of here!", $hBtnArrowContext)
GUISetState(@SW_SHOW)

While 1
    Sleep(10)
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE, $MenuItem1
            Exit
        Case $hBtnClick, $hBtnArrow
            ShowMenu($hGUI, $nMsg, $hBtnArrowContext)
        Case $MenuItem4
            MsgBox(0,"","For what?")
        Case $MenuItem3
            MsgBox(0,"","Now count to three!")
    EndSwitch
WEnd

Func ShowMenu($hWnd, $CtrlID, $nContextID)
    Local $arPos, $x, $y
    Local $hMenu = GUICtrlGetHandle($nContextID)

    $arPos = ControlGetPos($hWnd, "", $CtrlID)

    $x = $arPos[0]
    $y = $arPos[1] + $arPos[3]

    ClientToScreen($hWnd, $x, $y)
    TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu


; Convert the client (GUI) coordinates to screen (desktop) coordinates
Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
    Local $stPoint = DllStructCreate("int;int")

    DllStructSetData($stPoint, 1, $x)
    DllStructSetData($stPoint, 2, $y)

    DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

    $x = DllStructGetData($stPoint, 1)
    $y = DllStructGetData($stPoint, 2)
    ; release Struct not really needed as it is a local
    $stPoint = 0
EndFunc   ;==>ClientToScreen


; Show at the given coordinates (x, y) the popup menu (hMenu) which belongs to a given GUI window (hWnd)
Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
    DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu