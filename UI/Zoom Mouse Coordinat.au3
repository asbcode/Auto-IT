#include <Constants.au3>

#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>

#include <GuiConstantsEx.au3>
#include <GUIConstants.au3>
#include <Misc.au3>

Opt("MustDeclareVars", 1)
Local $Pos ; Declare $Pos here

Global $GPos = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_LAYERED + $WS_EX_TOPMOST)
WinSetTrans($GPos, "", 10) ; Set transparency
Global $ID = GUICtrlCreateEdit("", 0, 0, @DesktopWidth - 1, @DesktopHeight - 1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUICtrlSetCursor(-1, 3)
GUISetState()

HotKeySet("{ESC}", "_exit")

Global $hBMP, $imgGUI, $hBitmap, $hGraphic1, $mousepos

$imgGUI = GUICreate("Zoom", 250, 250, 0, 0, BitOR($WS_POPUP, $WS_BORDER))

GUISetState(@SW_SHOW, $imgGUI)

Global $CoordXY = ""

While 1
    $mousepos = MouseGetPos()
    $hBMP = _ScreenCapture_Capture("", $mousepos[0] - 50, $mousepos[1] - 50, $mousepos[0] + 50, $mousepos[1] + 50)

    ; Initialize GDI+ library and load image
    _GDIPlus_Startup()
    $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)

    ; Draw 150x150 around the mouse pointer
    $hGraphic1 = _GDIPlus_GraphicsCreateFromHWND($imgGUI)
    _GDIPlus_GraphicsDrawImageRect($hGraphic1, $hBitmap, 0, 0, 250, 250)

    _GDIPlus_GraphicsDispose($hGraphic1)
    _GDIPlus_ImageDispose($hBitmap)
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_Shutdown()

    ; Pindahkan GUI ke pojok kiri bawah jika mouse berada di setengah kiri atas, dan sebaliknya
    If $mousepos[0] < @DesktopWidth / 2 Then
        ; Mouse berada di setengah kiri layar
        If $mousepos[1] < @DesktopHeight / 2 Then
            ; Mouse berada di setengah kiri atas
            WinMove($imgGUI, "", 0, @DesktopHeight - 250)
        Else
            ; Mouse berada di setengah kiri bawah
            WinMove($imgGUI, "", 0, 0)
        EndIf
    Else
        ; Mouse berada di setengah kanan layar
        If $mousepos[1] < @DesktopHeight / 2 Then
            ; Mouse berada di setengah kanan atas
            WinMove($imgGUI, "", @DesktopWidth - 250, @DesktopHeight - 250)
        Else
            ; Mouse berada di setengah kanan bawah
            WinMove($imgGUI, "", @DesktopWidth - 250, 0)
        EndIf
    EndIf

    $Pos = MouseGetPos()
    If _IsPressed(01) Then
        GUICtrlSetData($ID, "")
        $CoordXY &= "(" & $Pos[0] & ", " & $Pos[1] & ") "
        ConsoleWrite("Koordinat yang Disimpan: " & $CoordXY & @CRLF)
        Exit
    EndIf
    Sleep(50)
WEnd

Func _exit()
    ConsoleWrite("Koordinat yang Disimpan: " & $CoordXY & @CRLF)
    Exit
EndFunc
