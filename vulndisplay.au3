#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <ProgressConstants.au3>
#include <Reduct.au3>
#Include <Array.au3>
#include <String.au3>
#Include <file.au3>
#Include <Date.au3>
Global $ver, $hCombo, $hCVE, $rMore
$hGUI = GUICreate("Wordpress vulnerabilities", 500, 500, 223, 202, $WS_BORDER)
$idEXIT = GUICtrlCreateButton("Exit", 20, 435, 75, 25)
$search = GUICtrlCreateButton("Search", 10, 20, 75, 25)
$hCombo = GUICtrlCreateCombo("Vulnerabilities", 10, 50, 480, Default)
$ver = GUICtrlCreateInput("", 90, 22, 45, 22)
$hCVE = GUICtrlCreateCombo("CVE", 10, 75, 480, Default)
$rMore = GUICtrlCreateButton("Read More", Default, 150)
$bCheck = GUICtrlCreateButton("Check", 10, 175)
$site = GUICtrlCreateInput("", 10, 200, 175, 25)

GUICtrlSetData("", "")


	; Made by Conscious, not to be resold in any way, free to share with credits given!


    GUISetState(@SW_SHOW, $hGUI)

    While 1
        Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idEXIT
				Exit
			Case $GUI_EVENT_CLOSE, $search
				Call(Search)
				Case $hCombo
					$sComboRead = GUICtrlRead($hCombo)
						ShellExecute("https://wpvulndb.com/search?utf8=%E2%9C%93&text="& $sComboRead, 0, $hGUI)
				Case $hCVE
					Call(CVE)
			Case $rMore
			$rMoRead = GUICtrlRead($hCVE)
	ShellExecute("http://cve.circl.lu/cve/CVE-" & $rMoRead)
			Case $bCheck
				Call(checker)
					EndSwitch
	WEnd
Func Search()

$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "https://wpvulndb.com/api/v2/wordpresses/" & GUICtrlRead($ver), False)
$oHTTP.SetRequestHeader("Host", "wpvulndb.com")
$oHTTP.SetRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.52 YaBrowser/15.12.2490.3614 (beta) Yowser/2.5 Safari/537.36")
$oHTTP.SetRequestHeader("Referer", "https://wpvulndb.com/api")
$oHTTP.Send()
$oReceived = $oHTTP.ResponseText
$oStatusCode = $oHTTP.Status
	; Made by Conscious, not to be resold in any way, free to share with credits given!

If $oStatusCode <> 200 then
 MsgBox(4096, "Response code", $oStatusCode)
EndIf

$read = $oReceived
Local $newreadamount
$Datastring = ('title":"')
$newreadamount = _StringBetween($read,$Datastring, '","')
For $i = 1 to UBound($newreadamount) -1
$newreadamount[0] = StringReplace($newreadamount[0], '"', "")
GUICtrlSetData($hCombo, $newreadamount[$i])
Next
$read2 = $oReceived
Local $newreadamount2
$Datastring2 = ('ve":["')
$newreadamount2 = _StringBetween($read2,$Datastring2, '"]}')
For $o = 1 to UBound($newreadamount2) -1
$newreadamount2[0] = StringReplace($newreadamount2[0], '"', "")
GUICtrlSetData($hCVE, $newreadamount2[$o])
Next
Return
	EndFunc

Func CVE()
$hCVEread = GUICtrlRead($hCVE)
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "http://cve.circl.lu/api/cve/CVE-" & $hCVEread, False)
$oHTTP.SetRequestHeader("Host", "cve.circl.lu")
$oHTTP.SetRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.52 YaBrowser/15.12.2490.3614 (beta) Yowser/2.5 Safari/537.36")

$oHTTP.Send()

$CVEreceive = $oHTTP.ResponseText

$CVEread = $CVEreceive
Local $newreadamount3
$Datastring3 = ('"summary": "')
$newreadamount3 = _StringBetween($CVEread,$Datastring3, '",')
If @error then Return SetError(1,0,0)
$newreadamount3[0] = StringReplace($newreadamount3[0], '"', "")
GUICtrlCreateLabel($newreadamount3[0], Default, 100, 480, 50)

EndFunc

Func Checker()
	$sP = '_ajax_nonce=e1f99bfad8&action=get_result&dataType=json&q=' & GUICtrlRead($site)
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "http://www.isitwp.com/wp-admin/admin-ajax.php", False) ; Post url
$oHTTP.SetRequestHeader("Host", "www.isitwp.com")
$oHTTP.SetRequestHeader("Accept", "*/*")
$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.52 YaBrowser/15.12.2490.3614 (beta) Yowser/2.5 Safari/537.36")
$oHTTP.SetRequestHeader("Referer", "http://www.isitwp.com/")
$oHTTP.SetRequestHeader("X-Requested-With", "XMLHttpRequest")
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")


$oHTTP.Send($sP)

$oCheck = $oHTTP.ResponseText
$Checkread = $oCheck
Local $newreadamount4
$Datastring4 = ('success":')
$newreadamount4 = _StringBetween($Checkread,$Datastring4, ',"data')
If @error then Return SetError(1,0,0)
$newreadamount4[0] = StringReplace($newreadamount4[0], '"', "")
GUICtrlCreateLabel("Using Wordpress: " & $newreadamount4[0], 50, 179)
EndFunc

; Made by Conscious, not to be resold in any way, free to share with credits given!

