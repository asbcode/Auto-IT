#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Misc.au3>

Opt("GUICloseOnESC", 0)

HotKeySet("{ESC}", "On_Exit")

Global $hMag_Win, $hMag_GUI, $hMagDC, $hDeskDC, $hPen, $iLast_Mouse_X = 0, $iLast_Mouse_Y = 0

CreateMagnifier()

While 1
    ; Check if cursor has moved
    $aMouse_Pos = MouseGetPos()
    If $aMouse_Pos[0] <> $iLast_Mouse_X Or $aMouse_Pos[1] <> $iLast_Mouse_Y Then
        ; Redraw Mag GUI
        Loupe($aMouse_Pos)
        ; Reset position
        $iLast_Mouse_X = $aMouse_Pos[0]
        $iLast_Mouse_Y = $aMouse_Pos[1]
    EndIf
WEnd

Func CreateMagnifier()
    ; Create GUI with border
    $hMag_Win = GUICreate("MAG", 124, 124, 0, 0, BitOr($WS_POPUP, $WS_BORDER))
    GUISetState(@SW_SHOW, $hMag_Win)
    $hMag_GUI = WinGetHandle("MAG")

    ; Get device context for Mag GUI
    $hMagDC = _WinAPI_GetDC($hMag_GUI)
    If @error Then Exit MsgBox(16, "Error", "Failed to get device context for Mag GUI")

    ; Get device context for desktop
    $hDeskDC = _WinAPI_GetDC(0)
    If @error Then
        _WinAPI_ReleaseDC($hMag_GUI, $hMagDC)
        Exit MsgBox(16, "Error", "Failed to get device context for desktop")
    EndIf

    ; Create pen
    $hPen = _WinAPI_CreatePen($PS_SOLID, 5, 0x7E7E7E)
    _WinAPI_SelectObject($hMagDC, $hPen)
EndFunc   ;==>CreateMagnifier

Func On_Exit()
    ; Clear up Mag GUI
    _WinAPI_SelectObject($hMagDC, $hPen)
    _WinAPI_DeleteObject($hPen)
    _WinAPI_ReleaseDC(0, $hDeskDC)
    _WinAPI_ReleaseDC($hMag_GUI, $hMagDC)
    GUIDelete($hMag_GUI)

    Exit
EndFunc   ;==>On_Exit

Func Loupe($aMouse_Pos)
    Local $iX, $iY

    ; Fill Mag GUI with 5x expanded contents of desktop area (10 pixels around mouse)
    _WinAPI_StretchBlt($hMagDC, 0, 0, 124, 124, $hDeskDC, $aMouse_Pos[0] - 10, $aMouse_Pos[1] - 10, 25, 25, $SRCCOPY)

    ; Keep Mag GUI on screen
    $iX = ($aMouse_Pos[0] < (@DesktopWidth - 134)) ? $aMouse_Pos[0] + 20 : $aMouse_Pos[0] - 134
    $iY = ($aMouse_Pos[1] < (@DesktopHeight - 164)) ? $aMouse_Pos[1] + 20 : $aMouse_Pos[1] - 134
    WinMove($hMag_GUI, "", $iX, $iY, 124, 124)
EndFunc   ;==>Loupe
