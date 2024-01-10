#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsConstants.au3>

Global $g_hToolbar, $g_idMemo, $g_idFileMenu
Global $g_iItem ; Command identifier of the button associated with the notification.
Global Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp, $e_idFileMenu

Example()

Func Example()
	Local $hGUI, $aSize

	; Create GUI
	$hGUI = GUICreate("Toolbar", 600, 400)
	$g_hToolbar = _GUICtrlToolbar_Create($hGUI)
	$aSize = _GUICtrlToolbar_GetMaxSize($g_hToolbar)

	$g_idMemo = GUICtrlCreateEdit("", 2, $aSize[1] + 20, 596, 396 - ($aSize[1] + 20), $WS_VSCROLL)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)
	GUIRegisterMsg($WM_NOTIFY, "_WM_NOTIFY")

	;Global Const $STD_PLAY = 12 ; Replace 3 with the appropriate constant value
	;Global Const $STD_PLAY = 5 ; Replace 3 with the appropriate constant value
	;Global Const $STD_PLAY = 5 ; Replace 3 with the appropriate constant value
	; Create File menu
	$g_idFileMenu = GUICtrlCreateMenu("File")
	GUICtrlCreateMenuItem("New", $g_idFileMenu, $e_idNew)
	GUICtrlCreateMenuItem("Open", $g_idFileMenu, $e_idOpen)
	GUICtrlCreateMenuItem("Save", $g_idFileMenu, $e_idSave)

	; Add standard system bitmaps
	_GUICtrlToolbar_AddBitmap($g_hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)

	; Add buttons
	_GUICtrlToolbar_AddButton($g_hToolbar, $e_idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($g_hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($g_hToolbar, $e_idSave, $STD_FILESAVE)

	_GUICtrlToolbar_AddButton($g_hToolbar, $e_idFileMenu, $STD_CUT) ; Use any toolbar icon you prefer for the menu

	_GUICtrlToolbar_AddButtonSep($g_hToolbar)  ; menu pemisah
	_GUICtrlToolbar_AddButton($g_hToolbar, $e_idHelp, $STD_HELP)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Write message to memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite

; WM_NOTIFY event handler
Func _WM_NOTIFY($hWndGUI, $iMsgID, $wParam, $lParam)
	#forceref $hWndGUI, $iMsgID, $wParam
	Local $tNMHDR, $hWndFrom, $iCode, $iNew, $iFlags, $iOld
	Local $tNMTBHOTITEM
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = DllStructGetData($tNMHDR, "hWndFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $g_hToolbar
			Switch $iCode
				Case $NM_LDOWN
					Switch $g_iItem
						Case $e_idFileMenu
							_GUICtrlToolbar_PressButton($g_hToolbar, $e_idFileMenu) ; Show menu
						Case 1000
							MsgBox(0, "", "You clicked NEW")
						Case 1001
							MsgBox(0, "", "You clicked OPEN")
						Case 1002
							MsgBox(0, "", "You clicked SAVE")
						Case 1003
							MsgBox(0, "", "You clicked HELP")
						Case Else
							MsgBox(0, "", "You clicked an unrecognized button")
					EndSwitch
				Case $TBN_HOTITEMCHANGE
					$tNMTBHOTITEM = DllStructCreate($tagNMTBHOTITEM, $lParam)
					$iNew = DllStructGetData($tNMTBHOTITEM, "idNew")
					$g_iItem = $iNew
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_NOTIFY
