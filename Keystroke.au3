#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <Misc.au3>

Global $hListView, $hGUI, $btnRecord

$hGUI = GUICreate("ListView Key Press", 400, 300)
$hListView = GUICtrlCreateListView("Key Press", 10, 10, 380, 230)
$btnRecord = GUICtrlCreateButton("Rec", 10, 250, 75, 25)
GUISetState(@SW_SHOW)

Global $bRecording = False ; Default state

While 1
    $iMsg = GUIGetMsg()
    Switch $iMsg
        Case $GUI_EVENT_CLOSE
            ExitLoop
        Case $btnRecord
            $bRecording = Not $bRecording ; Toggle recording state
            GUICtrlSetData($btnRecord, $bRecording ? "Stop" : "Rec")
            If $bRecording Then
                ; Clear the ListView when starting a new recording
                _GUICtrlListView_DeleteAllItems($hListView)
                ; Set focus to the main window of the script
                WinActivate($hGUI)
            EndIf
    EndSwitch

    If $bRecording Then
        CheckKeyPress()
        CheckKeyPressSpecial()
    EndIf
WEnd

Func CheckKeyPress()
    Local $sKey
    ; Deteksi tombol huruf (A-Z)
    For $i = 65 To 90 ; ASCII values for A to Z
        If _IsPressed(Hex($i, 2)) Then
            $sKey = Chr($i)
            AddKeyPressToListView($sKey)
            Sleep(100)
        EndIf
    Next

    ; Deteksi tombol angka (0-9)
    For $i = 48 To 57 ; ASCII values for 0 to 9
        If _IsPressed(Hex($i, 2)) Then
            $sKey = Chr($i)
            AddKeyPressToListView($sKey)
            Sleep(100)
        EndIf
    Next

    ; Deteksi tombol F1-F12
    For $i = 1 To 12
        If _IsPressed(Hex(0x6F + $i, 2)) Then ; Hex values for F1-F12
            $sKey = "(F" & $i & "}"
            AddKeyPressToListView($sKey)
            Sleep(100)
        EndIf
    Next
EndFunc

Func CheckKeyPressSpecial()
    Local $aKeys = ["{UP}", "{DOWN}", "{LEFT}", "{RIGHT}", "{ENTER}", "{SPACE}", "{TAB}", "{ESC}", "{BACKSPACE}", "{DELETE}", "{HOME}", "{END}", "{PGUP}", "{PGDN}", "{INS}", "{CAPSLOCK}", "{NUMLOCK}", "{SCROLLLOCK}", "{PRTSC}", "-", "=", ".", "/", ",", "'", ";", "\", "]", "[", "`", "*"]
    Local $aKeysHex = ["0x26", "0x28", "0x25", "0x27", "0x0D", "0x20", "0x09", "0x1B", "0x08", "0x2E", "0x24", "0x23", "0x21", "0x22", "0x2D", "0x14", "0x90", "0x91", "0x2A", "0xBD", "0xBB", "0xBE", "0xBF", "0xBC", "0xDE", "0xBA", "0xDC", "0xDD", "0xDB", "0xC0", "0x6A"]
    Local $sKey

    For $i = 0 To UBound($aKeysHex) - 1
        If _IsPressed(Hex($aKeysHex[$i])) Then
            $sKey = $aKeys[$i]
            AddKeyPressToListView($sKey)
            Sleep(100)
        EndIf
    Next
EndFunc

Func AddKeyPressToListView($sKey)
    GUICtrlCreateListViewItem($sKey, $hListView)
EndFunc
