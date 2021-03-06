#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.14.2
	Author:         aparla

	Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <IE.au3>
AutoItSetOption ("MouseCoordMode", 0)
Global $url_vdi = "https://sfvdi.statefarm.com/vpn/index.html"
Global $aliasinfo
Global $passwordinput
Global $pininput


#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\adam.parla\desktop\scripts\vdiform.kxf
$Form1 = GUICreate("loginLauncher", 551, 451, 273, 149)
GUISetBkColor(0xB4B4B4)
$alias = GUICtrlCreateInput("", 184, 56, 193, 33)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$password = GUICtrlCreateInput("", 184, 112, 193, 33, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$pin = GUICtrlCreateInput("", 184, 168, 193, 33, BitOR($GUI_SS_DEFAULT_INPUT,$ES_PASSWORD))
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("password", 88, 128, 84, 24)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("alias", 128, 72, 44, 24)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("pin", 144, 184, 29, 24)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
$proxyButton = GUICtrlCreateButton("guest portal + citrix", 184, 224, 193, 49)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$vdiButton = GUICtrlCreateButton("citrix", 184, 288, 193, 49)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$vdiButton2 = GUICtrlCreateButton("quick citrix", 184, 352, 193, 49)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $proxyButton
			Global $aliasinput = GUICtrlRead ($alias)
			Global $passwordinput = GUICtrlRead ($password)
			Global $pininput = GUICtrlRead ($pin)
			Call ("Initiate")
		Case $vdiButton
			Global $aliasinput = GUICtrlRead ($alias)
			Global $passwordinput = GUICtrlRead ($password)
			Global $pininput = GUICtrlRead ($pin)
			Call ("CitrixLoginLong")
		Case $vdiButton2
			Global $aliasinput = GUICtrlRead ($alias)
			Global $passwordinput = GUICtrlRead ($password)
			Global $pininput = GUICtrlRead ($pin)
			Call ("CitrixLoginShort")

	EndSwitch
WEnd

Func Initiate()
Call("Launch")
Sleep (1000)
CitrixLoginLong()
;Call("VDSLogin")
;Call("MobilePass")
;Call("MFAPASS")
EndFunc

Func Launch()
Global $oIE = _IECreate("www.google.com")
sleep (4000)
;MouseClick ("primary", 1345,50,1,1)
;sleep (4000)
$title = _IEPropertyGet($oIE, "title")
	If $title = "Guest Portal" Then
		Call ("GstPrtlLogin")
	EndIf
	EndFunc

Func GstPrtlLogin()
	Call("MobilePass")
	WinActivate ($oIE)
	Local $username = _IEGetObjByName($oIE, "guestUser.name")
	Local $logOnBtn = _IEGetObjById($oIE, "loginpage.button.login")
	_IEFormElementSetValue($username, $aliasinput)
	Local $clipboard = ClipGet()
	Local $pass1 = _IEGetObjByName($oIE, "guestUser.password")
	_IEFormElementSetValue ($pass1,$clipboard&$pininput)
	_IEAction($logOnBtn,"click")
	;MouseClick ("primary", 890,525,1,1)
EndFunc

#cs----
Func VDSLogin()
	Global $oIE = _IECreate($url_vdi)
	Sleep(22000)
	Local $username = _IEGetObjByName($oIE, "login")
	Local $pass1 = _IEGetObjByName($oIE, "passwd1")
	_IEFormElementSetValue($username, $aliasinput)
	_IEFormElementSetValue($pass1, $passwordinput)
EndFunc
#ce--

Func CitrixLoginLong()
	Global $oIE = _IECreate($url_vdi)
	Sleep(22000)
	Local $username = _IEGetObjByName($oIE, "login")
	Local $pass1 = _IEGetObjByName($oIE, "passwd1")
	Local $logOnBtn = _IEGetObjById($oIE, "Log_On")
	_IEFormElementSetValue($username, $aliasinput)
	_IEFormElementSetValue($pass1, $passwordinput)
	Call ("MobilePASS")
	Call ("MFAPASS")
	_IEAction($logOnBtn,"click")
EndFunc

Func CitrixLoginShort()
	Global $oIE = _IECreate($url_vdi)
	Sleep(10000)
	Local $username = _IEGetObjByName($oIE, "login")
	Local $pass1 = _IEGetObjByName($oIE, "passwd1")
	Local $logOnBtn = _IEGetObjById($oIE, "Log_On")
	_IEFormElementSetValue($username, $aliasinput)
	_IEFormElementSetValue($pass1, $passwordinput)
	Call ("MobilePASS")
	Call ("MFAPASS")
	_IEAction($logOnBtn,"click");
EndFunc

Func MobilePASS()
	Global $mobilepass = "C:\Program Files (x86)\SafeNet\Authentication\MobilePASS\MobilePASS.exe"
	Run($mobilepass)
	WinWait ("MobilePASS")
	WinActivate ("MobilePASS")
	;ControlClick("MobilePASS", "", "[ID:1030]")
		;, button = "middle", clicks = 1)
	;MouseClick ("primary", 134,96,1,1)
	ControlClick("MobilePASS", "", "[CLASSNN:SysListView321]")
	Sleep (2000)
	ControlClick("MobilePASS", "", "[CLASSNN:Button7]")
	;MouseClick ("primary", 152,371,1,1)
	WinActivate ("MobilePASS")
	WinClose ("MobilePASS")
EndFunc

Func MFAPASS()
	WinActivate ("NetScaler Gateway - Internet Explorer")
	Local $clipboard = ClipGet()
	Local $pass2 = _IEGetObjByName($oIE, "passwd")
	_IEFormElementSetValue ($pass2,$clipboard&$pininput)
	;MouseClick ("primary", 885,486,1,1)
	EndFunc
