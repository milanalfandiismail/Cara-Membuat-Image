@echo off
setlocal EnableExtensions

:: Set log file
set "LogFile=%~dp0script_log.txt"
echo [%DATE% %TIME%] Starting script execution >> "%LogFile%"

:: Check if the script is running with administrator privileges
echo [%DATE% %TIME%] Checking for administrator privileges >> "%LogFile%"
net session >nul 2>&1
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Running with administrator privileges >> "%LogFile%"
    echo Running with administrator privileges.
) else (
    echo [%DATE% %TIME%] ERROR: Script requires administrator privileges >> "%LogFile%"
    echo This script requires administrator privileges.
    pause
    exit /b
)

:: Modify the registry to allow unsigned PNP files with Secure Boot
echo [%DATE% %TIME%] Modifying registry to allow unsigned PNP files >> "%LogFile%"
reg add "HKLM\SYSTEM\ControlSet001\Control\CI\Policy" /v "SkuPolicyRequired" /t REG_DWORD /d 0 /f
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully set SkuPolicyRequired to 0 >> "%LogFile%"
    echo Successfully set SkuPolicyRequired to 0
) else (
    echo [%DATE% %TIME%] ERROR: Failed to set SkuPolicyRequired. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to set SkuPolicyRequired.
    pause
    goto :eof
)

reg add "HKLM\SYSTEM\ControlSet001\Control\CI\Policy" /v "UpgradedSystem" /t REG_DWORD /d 1 /f
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully set UpgradedSystem to 1 >> "%LogFile%"
    echo Successfully set UpgradedSystem to 1
) else (
    echo [%DATE% %TIME%] ERROR: Failed to set UpgradedSystem. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to set UpgradedSystem.
    pause
    goto :eof
)

:: Define registry path for network adapter (adjust subkey '0000' if needed)
set "RegPath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}"
echo [%DATE% %TIME%] Registry path for network adapter: %RegPath% >> "%LogFile%"

:: Add UpperFilters with iSharePnp
echo [%DATE% %TIME%] Adding UpperFilters with value 'iSharePnp' >> "%LogFile%"
reg add "%RegPath%" /v UpperFilters /t REG_MULTI_SZ /d iSharePnp /f
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully added UpperFilters >> "%LogFile%"
    echo Successfully added UpperFilters
) else (
    echo [%DATE% %TIME%] ERROR: Failed to add UpperFilters. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to add UpperFilters. Ensure the subkey is correct.
    pause
    goto :eof
)

:: Add LowerFilters with CCBootPNPX
echo [%DATE% %TIME%] Adding LowerFilters with value 'CCBootPNPX' >> "%LogFile%"
reg add "%RegPath%" /v LowerFilters /t REG_MULTI_SZ /d CCBootPNPX /f
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully added LowerFilters >> "%LogFile%"
    echo Successfully added LowerFilters
) else (
    echo [%DATE% %TIME%] ERROR: Failed to add LowerFilters. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to add LowerFilters. Ensure the subkey is correct.
    pause
    goto :eof
)

:: Change to script's directory
cd /d "%~dp0"
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Changed to script directory: %~dp0 >> "%LogFile%"
) else (
    echo [%DATE% %TIME%] ERROR: Failed to change to script directory. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to change to script directory.
    pause
    goto :eof
)

:: Check if source file exists
set "SourceFile=Driver\iSharePP.sys"
set "SourceFile1=Driver\CCBootPNPX.sys"
set "SourceFile2=Driver\CCacheX.sys"

if exist "%SourceFile%" (
    echo [%DATE% %TIME%] Source file exists: %SourceFile% >> "%LogFile%"
) else (
    echo [%DATE% %TIME%] ERROR: Source file not found: %SourceFile% >> "%LogFile%"
    echo ERROR: Source file not found: %SourceFile%
    pause
    goto :eof
)

:: Copy file using xcopy
echo [%DATE% %TIME%] Copying %SourceFile% to C:\Windows\System32\drivers >> "%LogFile%"
xcopy "%SourceFile%" "C:\Windows\System32\drivers\" /V /Q /Y
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully copied %SourceFile% to C:\Windows\System32\drivers >> "%LogFile%"
    echo Berhasil di copy
) else (
    echo [%DATE% %TIME%] ERROR: Failed to copy %SourceFile%. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to copy %SourceFile%.
    pause
    goto :eof
)




if exist "%SourceFile1%" (
    echo [%DATE% %TIME%] Source file exists: %SourceFile1% >> "%LogFile%"
) else (
    echo [%DATE% %TIME%] ERROR: Source file not found: %SourceFile1% >> "%LogFile%"
    echo ERROR: Source file not found: %SourceFile1%
    pause
    goto :eof
)

:: Copy file using xcopy
echo [%DATE% %TIME%] Copying %SourceFile1% to C:\Windows\System32\drivers >> "%LogFile%"
xcopy "%SourceFile1%" "C:\Windows\System32\drivers\" /V /Q /Y
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully copied %SourceFile% to C:\Windows\System32\drivers >> "%LogFile%"
    echo Berhasil di copy
) else (
    echo [%DATE% %TIME%] ERROR: Failed to copy %SourceFile1%. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to copy %SourceFile1%.
    pause
    goto :eof
)

:: Copy file using xcopy
echo [%DATE% %TIME%] Copying %SourceFile2% to C:\Windows\System32\drivers >> "%LogFile%"
xcopy "%SourceFile2%" "C:\Windows\System32\drivers\" /V /Q /Y
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Successfully copied %SourceFile% to C:\Windows\System32\drivers >> "%LogFile%"
    echo Berhasil di copy
) else (
    echo [%DATE% %TIME%] ERROR: Failed to copy %SourceFile2%. Error code: %ERRORLEVEL% >> "%LogFile%"
    echo ERROR: Failed to copy %SourceFile2%.
    pause
    goto :eof
)






if exist "%SourceFile2%" (
    echo [%DATE% %TIME%] Source file exists: %SourceFile2% >> "%LogFile%"
) else (
    echo [%DATE% %TIME%] ERROR: Source file not found: %SourceFile2% >> "%LogFile%"
    echo ERROR: Source file not found: %SourceFile2%
    pause
    goto :eof
)



:: Copy File iShareDiskClient
echo [%DATE% %TIME%] Copying Folder iShareDiskClient >> "%LogFile%"
xcopy "appdata\iShareDiskClient" "%appdata%\iShareDiskClient" /E /H /C /I /V /Q /Y
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Berhasil di copy
) else (
    echo [%DATE% %TIME%] Error
    pause
    goto :eof
)




:: Copy File CCBOOT
echo [%DATE% %TIME%] Copying Folder CCBoot to C:\CCBootClient >> "%LogFile%"
xcopy "CCBootClient" "C:\CCBootClient" /E /H /C /I /V /Q /Y
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Berhasil di copy
) else (
    echo [%DATE% %TIME%] Error
    pause
    goto :eof
)

:: Regedit CCBoot Startup
echo [%DATE% %TIME%] Creating startup for CCBoot >> "%LogFile%"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v CCBootClient /t REG_SZ /d "\"C:\CCBootClient\CCBootClient.exe\" -startup" /f
if %ERRORLEVEL%==0 (
    echo [%DATE% %TIME%] Berhasil di copy
) else (
    echo [%DATE% %TIME%] Gagal di copy
    pause
    goto :eof
)


:: Import Semua Reg
echo [%DATE% %TIME%] Mengimport semua regedit >> "%LogFile%"
reg import "regedit\CCBoot-Service.reg"
reg import "regedit\CCBoot-Service1.reg"
reg import "regedit\CCBoot-Service2.reg"
reg import "regedit\iSharePnp-Service.reg"
reg import "regedit\iSharePnp-System.reg"
if %ERRORLEVEL==0 (
    echo [%DATE% %TIME%] Berhasil mengimport semua regedit
) else (
    echo [%DATE% %TIME%] Gagal Mengimport regedit
    pause
    goto :eof
)



:: Final message
echo [%DATE% %TIME%] Script completed successfully. Please reboot your computer to apply changes. >> "%LogFile%"
echo Registry keys updated and file copied successfully.
echo Please reboot your computer to apply changes.

pause
endlocal
goto :eof
