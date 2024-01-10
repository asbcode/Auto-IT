#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>

GUICreate("List View dengan Dua Kolom", 400, 300)
$btnEdit = GUICtrlCreateButton("Edit", 10, 250, 70, 30)
$btnAdd = GUICtrlCreateButton("Adds", 90, 250, 70, 30)

$hListView = GUICtrlCreateListView("Kolom 1|Jenis", 10, 10, 380, 230)
_GUICtrlListView_SetColumnWidth($hListView, 0, 180)
_GUICtrlListView_SetColumnWidth($hListView, 1, 180)

; Menambahkan item ke dalam List View (kolom pertama)
_GUICtrlListView_AddItem($hListView, "Item 1")
_GUICtrlListView_AddItem($hListView, "Item 2")
_GUICtrlListView_AddItem($hListView, "Item 3")

; Menambahkan item ke dalam List View (kolom kedua)
_GUICtrlListView_AddSubItem($hListView, 0, "Tap", 1)
_GUICtrlListView_AddSubItem($hListView, 1, "Keyboard", 1)
_GUICtrlListView_AddSubItem($hListView, 2, "Mouse", 1)

GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            ExitLoop
        Case $btnEdit
            EditListViewItem()
        Case $btnAdd
            AddListViewItem()
    EndSwitch
WEnd

GUIDelete()

Func EditListViewItem()
    Local $iIndex = _GUICtrlListView_GetSelectedIndices($hListView, True)
    If IsArray($iIndex) And UBound($iIndex) > 1 Then
        Local $sJenis = _GetSelectedItemJenis($iIndex[1])
        Select
            Case $sJenis = "Mouse"
                AddListViewItem("Edit", $iIndex[1])
            Case Else
                MsgBox(16, "Peringatan", "Jenis pengenalan tidak dikenali.")
        EndSelect
    Else
        MsgBox(16, "Peringatan", "Pilih item yang akan diedit terlebih dahulu.")
    EndIf
EndFunc   ;==>EditListViewItem

Func _GetSelectedItemJenis($iIndex)
    Return _GUICtrlListView_GetItemText($hListView, $iIndex, 1)
EndFunc   ;==>_GetSelectedItemJenis

Func AddListViewItem($mode = "Add", $editIndex = -1) ; GUI Pop Up Add & Edit mode
    Global $popUpsGUI = GUICreate("Add New Item", 300, 120)
    GUICtrlCreateLabel("Masukkan nilai baru untuk Item:", 10, 10, 280, 20)
    Global $Input = GUICtrlCreateInput("", 10, 40, 280, 20)
    Local $btnActionText = ($mode = "Add") ? "Add" : "Edit" ; Menentukan teks tombol berdasarkan mode
    Local $btnAction = GUICtrlCreateButton($btnActionText, 90, 80, 60, 30)
    Local $btnCancel = GUICtrlCreateButton("Cancel", 160, 80, 60, 30)

    If $mode = "Edit" Then ; Menentukan data yang ditampilkan pada Edit mode
        GUICtrlSetData($Input, _GUICtrlListView_GetItemText($hListView, $editIndex, 0))
    EndIf

    GUISetState(@SW_SHOW, $popUpsGUI)

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $btnCancel
                GUIDelete($popUpsGUI)
                ExitLoop
            Case $btnAction
                If $mode = "Add" Then
                    AddListViewItemToGUI()
                Else
                    EditListViewItemInGUI($editIndex)
                EndIf
                ExitLoop
        EndSwitch
        Sleep(10)
    WEnd
EndFunc   ;==>AddListViewItem

Func AddListViewItemToGUI()
    Local $sNewItem = GUICtrlRead($Input)
    If $sNewItem <> "" Then
        _GUICtrlListView_AddItem($hListView, $sNewItem)
        _GUICtrlListView_AddSubItem($hListView, _GUICtrlListView_GetItemCount($hListView) - 1, "Mouse", 1)
    EndIf
    GUIDelete($popUpsGUI)
EndFunc   ;==>AddListViewItemToGUI

Func EditListViewItemInGUI($editIndex)
    Local $sNewItem = GUICtrlRead($Input)
    If $sNewItem <> "" Then
        _GUICtrlListView_SetItemText($hListView, $editIndex, $sNewItem, 0)
    EndIf
    GUIDelete($popUpsGUI)
EndFunc   ;==>EditListViewItemInGUI


Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)

    Local $hwndFrom = DllStructGetData($tNMHDR, "hwndFrom")
    Local $idFrom = DllStructGetData($tNMHDR, "idFrom")
    Local $code = DllStructGetData($tNMHDR, "code")

    Switch $code
        Case $NM_DBLCLK
            Local $hWndListView = GUICtrlGetHandle($hListView)

            If $hwndFrom = $hWndListView Then
                EditListViewItem()
            EndIf
    EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
