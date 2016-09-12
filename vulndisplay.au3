#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <ProgressConstants.au3>
#Include <Array.au3>
#include <String.au3>
#Include <file.au3>
#Include <Date.au3>
#Region ### START Koda GUI section ### Form=
Global $ver, $hCombo, $hCVE, $rMore, $site, $search, $wpGui, $cveGui, $iCVE
$hGUI = GUICreate("Diagnose Web/IP sources", 501, 251, 364, 158)
$idEXIT = GUICtrlCreateButton("Exit", 5, 219, 75, 25)
$Button1 = GUICtrlCreateButton("Wordpress", 40, 72, 75, 49)
$Button2 = GUICtrlCreateButton("WHOIS", 128, 72, 75, 49)
$Button3 = GUICtrlCreateButton("CVE SEARCH", 216, 72, 75, 49)
$Button4 = GUICtrlCreateButton("Resolver", 304, 72, 75, 49)
$Button5 = GUICtrlCreateButton("Misc...", 392, 72, 75, 49)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $idEXIT
				Exit
		Case $Button1
				Call(wordpress)
		Case $Button2
			Call(WHOIS)
		Case $Button3
			Call(cvebutton)
EndSwitch
WEnd


; WORDPRESS START


Func wordpress()
$wpGui = GUICreate("Wordpress vulnerabilities", 500, 250, 223, 202, $WS_BORDER)
$iexi = GUICtrlCreateButton("Close", 5, 185)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseWP")
$search = GUICtrlCreateButton("Search", 10, 20, 75, 25)
$hCombo = GUICtrlCreateCombo("Vulnerabilities", 10, 50, 480, Default)
$ver = GUICtrlCreateInput("", 85, 21, 45, 22)
$hCVE = GUICtrlCreateCombo("CVE", 10, 75, 480, Default)
$rMore = GUICtrlCreateButton("Read More", 5, 150)
$bCheck = GUICtrlCreateButton("Check", 135, 20, 75, 25)
$site = GUICtrlCreateInput("", 210, 21, 100, 22)

GUICtrlSetData("", "")


	; Made by Conscious, not to be resold in any way, free to share with credits given!


    GUISetState(@SW_SHOW, $wpGui)

    While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $iexi
				Call(CloseWP)
				Return
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
EndFunc


; WORDPRESS END <<


; WHOIS START  >>


Func WHOIS()
$whoisurl = InputBox("WHOIS URL", "", "")
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "http://ip-api.com/json/" & $whoisurl, False)
$oHTTP.SetRequestHeader("Host", "api.hackertarget.com")
$oHTTP.SetRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.52 YaBrowser/15.12.2490.3614 (beta) Yowser/2.5 Safari/537.36")
$oHTTP.Send()
$oReceived = $oHTTP.ResponseText
$oStatusCode = $oHTTP.Status
	; Made by Conscious, not to be resold in any way, free to share with credits given!

If $oStatusCode <> 200 then
 MsgBox(4096, "Response code", $oStatusCode)
EndIf
; Saves the body response regardless of the Response code
	$file = FileOpen("Received.txt", 2) ; The value of 2 overwrites the file if it already exists
	FileWrite($file, $oReceived)
	FileClose($file)
_ReplaceStringInFile("Received.txt" ,'":"', "" & @CRLF)
_ReplaceStringInFile("Received.txt" ,'","', "" & @CRLF)
_ReplaceStringInFile("Received.txt" ,'"}', "")
_ReplaceStringInFile("Received.txt" ,'{"as', "")
_ReplaceStringInFile("Received.txt" ,'query', "IP")


EndFunc


; WHOIS END <<


; CVEBUTTON START >>

Func cvebutton()

$cveGui = GUICreate("Wordpress vulnerabilities", 500, 250, 223, 202, $WS_BORDER)
$exit = GUICtrlCreateButton("Close", 5, 185)
GUISetOnEvent($GUI_EVENT_CLOSE, "CloseCVE")
$search1 = GUICtrlCreateButton("Search", 10, 20, 75, 25)
$iCVE = GUICtrlCreateInput("", 85, 21, 100, 22)
$rMore1 = GUICtrlCreateButton("Read More", 5, 150)

GUICtrlSetData("", "")


	; Made by Conscious, not to be resold in any way, free to share with credits given!


    GUISetState(@SW_SHOW, $cveGui)

    While 1
		Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $exit
				Call(CloseCVE)
				Return
				Case $search1
					Call(CVEbu)
			Case $rMore1
			$rMRead = GUICtrlRead($iCVE)
	ShellExecute("http://cve.circl.lu/cve/CVE-" & $rMRead)
				Return
EndSwitch
	WEnd

EndFunc

Func CVEbu()
$thecve = GUICtrlRead($iCVE)
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("GET", "http://cve.circl.lu/api/cve/CVE-" & $thecve, False)
$oHTTP.SetRequestHeader("Host", "cve.circl.lu")
$oHTTP.SetRequestHeader("Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8")
$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.52 YaBrowser/15.12.2490.3614 (beta) Yowser/2.5 Safari/537.36")

$oHTTP.Send()

$CVErec = $oHTTP.ResponseText

$CVEr = $CVErec
Local $newreadamount4
$Datastring4 = ('"summary": "')
$newreadamount4 = _StringBetween($CVEr,$Datastring4, '",')
If @error then Return SetError(1,0,0)
$newreadamount4[0] = StringReplace($newreadamount4[0], '"', "")
GUICtrlCreateLabel($newreadamount4[0], Default, 60, 480, 50)
EndFunc

; CVE BUTTON END <<


; SEARCH START >>

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

; SEARCH END <<


; CVE START >>

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

; CVE END <<


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

Func CloseWP()
GUIDelete($wpGui)

EndFunc

Func CloseCVE()
GUIDelete($cveGui)
EndFunc
