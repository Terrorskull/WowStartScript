::-----------------------------------------------------------
:: Name:     StartScript.bat
:: Purpose:  Configure and start Classic WoW on specified server
:: Author:   terrorskull@terrorskull.com
:: Version:  1.3
:: Date:     05JUL2017
::
::           Create a copy of this file for each realm.
::
::           Fill in user defined settings with correct information.
::
::           Run the executable directly or create a shortcut on the
::           desktop (allows for changing the icon).
:: Modified: 05JUL2017 - 1.3
::           - Removed merged realms of Kronos II and Zeth'Kur from suggested list
:: Modified: 20JAN2017 - 1.2
::			 - Fixed issue with realm names containing a single quote (')
::			 - Added new Elysium realm of Zeth'Kur to examples
:: Modified: 16JAN2017 - 1.1
::			 - Changed Elysium realm names to match removal of Nostalrius data
::			 - Added realm names for Crestfall
::-----------------------------------------------------------

@ECHO OFF

::-----------------------------------------------------------
:: User defined settings
::-----------------------------------------------------------

:: Wow.exe file path - the location storing the classic WoW.exe
SET DIR=C:\Program Files (x86)\World of Warcraft Classic

:: Account name - generated on site for the server
SET NAME=myname

:: Realm name - the realm to log into, e.g., Kronos, Anathema, Darrowshire, Elysium, Kul Tiras PvP, Zul'Dare PvE
SET REALM=Elysium

:: Logon server specified in realmlist.wtf file - provided by site hosting the server
SET LOGON=logon.elysium-project.org

::-----------------------------------------------------------
:: Automated commands - do not modify
::-----------------------------------------------------------
cls
ECHO.
ECHO Configuring Classic WoW located at %DIR%...

:: Clear WDB folder
ECHO.
ECHO Clearing WDB folder...
del /F /Q "%DIR%\WDB"

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
