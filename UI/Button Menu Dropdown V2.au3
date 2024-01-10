#include <GUIConstantsEx.au3>

$hGUI = GUICreate("Example Button Context Menu", 623, 449, 192, 114)

$hBtnClick = GUICtrlCreateButton("Click", 64, 80, 80, 30)
$hBtnArrow = GUICtrlCreateLabel("", 0, 0)
$hBtnArrowContext = GUICtrlCreateContextMenu($hBtnArrow)
$MenuItem4 = GUICtrlCreateMenuItem("Open your mind", $hBtnArrowContext)
$MenuItem3 = GUICtrlCreateMenuItem("Close your eyes", $hBtnArrowContext)
$idItem3 = GUICtrlCreateMenu("Mouse", $hBtnArrowContext)
$MenuItem32 = GUICtrlCreateMenuItem("Yes show mouse", $idItem3)
$MenuItem2 = GUICtrlCreateMenuItem("", $hBtnArrowContext)
$MenuItem1 = GUICtrlCreateMenuItem("Get out of here!", $hBtnArrowContext)

$hBtnClick2 = GUICtrlCreateButton("Click2", 64, 150, 80, 30)
$hBtnArrow2 = GUICtrlCreateLabel("", 0, 0)
$hBtnArrowContext2 = GUICtrlCreateContextMenu($hBtnArrow2)
$MenuItem42 = GUICtrlCreateMenuItem("Open your mind", $hBtnArrowContext2)
$MenuItem32 = GUICtrlCreateMenuItem("Close your eyes", $hBtnArrowContext2)
$idItem3 = GUICtrlCreateMenu("Mouse", $hBtnArrowContext2)


GUISetState(@SW_SHOW)

While 1
    Sleep(10)
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE, $MenuItem1
            Exit
        Case $hBtnClick
            ShowMenu($hGUI, $hBtnClick, $hBtnArrowContext)
		Case $hBtnClick2
            ShowMenu($hGUI, $hBtnClick2, $hBtnArrowContext2)
        Case $MenuItem4
            MsgBox(0, "", "For what?")
        Case $MenuItem3
            MsgBox(0, "", "Now count to three!")
		Case $MenuItem42
            MsgBox(0, "", "For what?")
        Case $MenuItem32
            MsgBox(0, "", "Now count to three!")
    EndSwitch
WEnd


Func ShowMenu($hWnd, $hCtrl, $nContextID)
    Local $arPos, $x, $y
    Local $hMenu = GUICtrlGetHandle($nContextID)

    $arPos = ControlGetPos($hWnd, "", $hCtrl)

    $x = $arPos[0] + $arPos[2]
    $y = $arPos[1]

    ClientToScreen($hWnd, $x, $y)
    TrackPopupMenu($hWnd, $hMenu, $x, $y)
EndFunc   ;==>ShowMenu

Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
    Local $stPoint = DllStructCreate("int;int")

    DllStructSetData($stPoint, 1, $x)
    DllStructSetData($stPoint, 2, $y)

    DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

    $x = DllStructGetData($stPoint, 1)
    $y = DllStructGetData($stPoint, 2)
    $stPoint = 0
EndFunc   ;==>ClientToScreen

Func TrackPopupMenu($hWnd, $hMenu, $x, $y)
    DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $x, "int", $y, "hwnd", $hWnd, "ptr", 0)
EndFunc   ;==>TrackPopupMenu
