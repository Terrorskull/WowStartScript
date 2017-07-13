::-----------------------------------------------------------
:: Name:     StartScript.bat
:: Purpose:  Configure and start Burning Crusade WoW on specified server
:: Author:   terrorskull@terrorskull.com
:: Version:  1.0
:: Date:     12JUL2017
::
::           Create a copy of this file for each realm.
::
::           Fill in user defined settings with correct information.
::
::           Run the executable directly or create a shortcut on the
::           desktop (allows for changing the icon).
::-----------------------------------------------------------

@ECHO OFF

::-----------------------------------------------------------
:: User defined settings
::-----------------------------------------------------------

:: Wow.exe file path - the location storing the classic WoW.exe
SET DIR=C:\Program Files (x86)\Burning Crusade

:: Account name - generated on site for the server
SET NAME=myname

:: Realm name - the realm to log into, e.g., Felmyst (Horde), Felmyst (Alliance), Darrowshire, Medivh, Outland
SET REALM=Felmyst (Horde)

:: Logon server specified in realmlist.wtf file - provided by site hosting the server
SET LOGON=game.felmyst.com

::-----------------------------------------------------------
:: Automated commands - do not modify
::-----------------------------------------------------------
cls
ECHO.
ECHO Configuring Classic WoW located at %DIR%...

:: Clear WDB folder
ECHO.
ECHO Clearing WDB folder...
rd "%DIR%\Cache\WDB\" /s /q

:: Check for single quote in realm name
SET OREALM=%REALM%
if not x%REALM:'=%==x%REALM% (
	ECHO.
	SET REALM=%REALM:'=''%
	ECHO Fixed single quoted realm name %OREALM% ^=^> %REALM%
)

:: Set correct realm list
ECHO.
ECHO Setting realmlist.wtf file to %LOGON%...
powershell -Command "(Get-Content '%DIR%\realmlist.wtf') -replace '^set realmlist.+', 'set realmlist %LOGON%' | Set-Content '%DIR%\realmlist.wtf'"

:: Add custom account and realm to config.wtf
ECHO.
ECHO Updating config.wtf file values:
ECHO    SET accountName "%NAME%"
ECHO    SET realmName "%REALM%"
ECHO    SET realmList "%OREALM%"
powershell -Command "(Get-Content '%DIR%\WTF\Config.wtf') -replace '^SET accountName.+', 'SET accountName \"%NAME%\"' -replace '^SET realmName.+', 'SET realmName \"%REALM%\"' -replace '^SET realmList.+', 'SET realmList \"%LOGON%\"' | Set-Content '%DIR%\WTF\Config.wtf'"

:: Run Classic WoW
ECHO.
ECHO Starting Classic WoW on %OREALM%...
start "" "%DIR%\WoW.exe"
