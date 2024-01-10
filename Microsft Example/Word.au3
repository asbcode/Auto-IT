#include <MsgBoxConstants.au3>
#include <Word.au3>
Local Const $wdLineStyleSingle = 1
Local Const $wdBorderBottom = -3        ;~ A bottom border.
Local Const $wdBorderDiagonalDown = -7  ;~ A diagonal border starting in the upper-left corner.
Local Const $wdBorderLeft = -2          ;~ A left border.
Local Const $wdBorderRight = -4         ;~ A right border.
Local Const $wdBorderTop = -1           ;~ A top border.
Local Const $wdGray25 = 16  ;~ Shade 125 of gray color.
; Create application object
Local $oWord = _Word_Create()
If @error Then Exit
Local $oDoc = _Word_DocAdd($oWord)
If @error Then Exit

Local $asArray[3][3] = [[1, 2, 3], ["a", "b", "c"], ["x", "y", "z"]]
Local $oRange = _Word_DocRangeSet($oDoc, -2)
Local $oTable = _Word_DocTableWrite($oRange, $asArray, 0)
If @error Then Exit
With $oTable
 ;Apply borders around table
 .Borders($wdBorderTop).LineStyle = $wdLineStyleSingle
 .Borders($wdBorderBottom).LineStyle = $wdLineStyleSingle
 .Borders($wdBorderLeft).LineStyle = $wdLineStyleSingle
 .Borders($wdBorderRight).LineStyle = $wdLineStyleSingle
 .Rows(1).Shading.BackgroundPatternColorIndex = $wdGray25
EndWith
;_Word_DocSaveAs($oDoc, @ScriptDir & "\Filename.docx", $WdFormatDocumentDefault)
;_Word_DocClose($oDoc)
;_Word_Quit($oWord)
