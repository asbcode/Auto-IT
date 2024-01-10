#include <Excel.au3>

; Inisialisasi Excel
Local $oExcel = _Excel_Open()

If @error Then
    MsgBox(0, "Error", "Tidak dapat membuka Excel.")
    Exit
EndIf

; Membuat spreadsheet baru
Local $oWorkbook = _Excel_BookNew($oExcel)

; Menulis data ke sel A1
_Excel_RangeWrite($oWorkbook, Default, "Hello, this is data written using UDF.", "B5")

; Menunggu beberapa detik
Sleep(2000)

; Menutup Excel
;_Excel_Close($oExcel)

Exit
