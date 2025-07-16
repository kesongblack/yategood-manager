@echo off
setlocal enabledelayedexpansion

:: Enable ANSI escape sequences for Windows 10+
for /f "tokens=2 delims=[]" %%i in ('ver') do set version=%%i
set version=%version:~0,2%
if %version% LSS 10 (
    echo Windows version may not support CMD colors.
) else (
    >nul 2>&1 reg add "HKCU\Console" /v VirtualTerminalLevel /t REG_DWORD /d 1 /f
)

:: ANSI color codes
set COLOR_RESET=[0m
set COLOR_GREEN=[32m
set COLOR_RED=[31m
set COLOR_YELLOW=[33m
set COLOR_CYAN=[36m

:MENU
cls
echo %COLOR_CYAN%======================================%COLOR_RESET%
echo %COLOR_CYAN% Yategood PoC ADB TOOL MENU v. 1.0.1  %COLOR_RESET%
echo %COLOR_CYAN% by: Kris O. [github.com/kesongblack] %COLOR_RESET%
echo %COLOR_CYAN%======================================%COLOR_RESET%
echo.
echo %COLOR_YELLOW%IMPORTANT NOTE:
echo %COLOR_YELLOW%Before running this program, please ensure 
echo %COLOR_YELLOW%that the device's Developer's Option is ON.
echo %COLOR_YELLOW%To turn it on, go to Settings -- About Radio
echo %COLOR_YELLOW%and click the Build Number SEVEN times
echo %COLOR_YELLOW%until it says "You are a developer!"
echo.
echo %COLOR_YELLOW%[1]%COLOR_RESET% Check if ADB is working
echo %COLOR_YELLOW%[2]%COLOR_RESET% Install APKs from "app" folder
echo %COLOR_YELLOW%[3]%COLOR_RESET% Send text input to Zello
echo %COLOR_YELLOW%[4]%COLOR_RESET% Auto-fill Zello login
echo %COLOR_YELLOW%[5]%COLOR_RESET% Exit
echo.
echo %COLOR_CYAN%======================================%COLOR_RESET%
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto CHECK_ADB
if "%choice%"=="2" goto INSTALL_APKS
if "%choice%"=="3" goto INPUT_TEXT
if "%choice%"=="4" goto INPUT_AUTOFILL
if "%choice%"=="5" exit

echo %COLOR_RED%Invalid choice. Press any key to try again...%COLOR_RESET%
pause >nul
goto MENU

:CHECK_ADB
cls
echo %COLOR_CYAN%Checking if ADB is working...%COLOR_RESET%
adb devices >nul 2>&1
if errorlevel 1 (
    echo %COLOR_RED%ADB is not recognized or not working.%COLOR_RESET%
) else (
    adb devices
    echo.
    echo %COLOR_GREEN%If you see a device listed above, ADB is working.%COLOR_RESET%
)
pause
goto MENU

:INSTALL_APKS
cls
echo %COLOR_RED%CURRENT KNOWN BUG: 
echo %COLOR_RED%- This program will terminate upon running this option regardless of success/failure.
echo %COLOR_RED%- Please re-run the program again after running this option.
if not exist "app\" (
    echo %COLOR_RED%Error: "app" folder not found in current directory.%COLOR_RESET%
    pause
    goto MENU
)

set failed=0
echo %COLOR_CYAN%Installing APKs from "app" folder...%COLOR_RESET%
for %%f in ("app\*.apk") do (
    echo.
    echo %COLOR_YELLOW%Installing %%~nxf...%COLOR_RESET%

    call adb install -r "%%f" >temp_adb_output.txt 2>&1
    findstr /C:"Failure" temp_adb_output.txt >nul
    if !errorlevel! == 0 (
        echo %COLOR_RED%Failed to install %%~nxf%COLOR_RESET%
        echo --------- ERROR MESSAGE ---------
        type temp_adb_output.txt
        echo ----------------------------------
        set /a failed+=1
    ) else (
        echo %COLOR_GREEN%Installed: %%~nxf%COLOR_RESET%
    )
    del /f /q temp_adb_output.txt >nul 2>&1
)

echo.
if %failed% GTR 0 (
    echo %COLOR_RED%Installation completed with %failed% failure(s).%COLOR_RESET%
) else (
    echo %COLOR_GREEN%All APKs installed successfully!%COLOR_RESET%
)

pause
goto MENU

:INPUT_TEXT
cls
echo %COLOR_CYAN%===============================%COLOR_RESET%
echo %COLOR_CYAN%   ADB TEXT INPUT TO Zello      %COLOR_RESET%
echo %COLOR_CYAN%===============================%COLOR_RESET%
echo.
echo %COLOR_YELLOW%Before proceeding:%COLOR_RESET%
echo Please use the device keyboard (arrow keys, tab, etc.)
echo to navigate Zello and place the cursor in the "Username" field.
echo Once you're ready, proceed to enter the text.
echo.
pause

cls
echo %COLOR_CYAN%Send Text to Zello%COLOR_RESET%
set /p text="Enter text to send (spaces become underscores): "
set text_input=%text: =_%

adb shell input text %text_input%
if errorlevel 1 (
    echo %COLOR_RED%Failed to send text.%COLOR_RESET%
) else (
    echo %COLOR_GREEN%Text sent: %text%%COLOR_RESET%
)

pause
goto MENU

:INPUT_AUTOFILL
cls
echo %COLOR_CYAN%===============================%COLOR_RESET%
echo %COLOR_CYAN%     ADB Zello AUTO LOGIN       %COLOR_RESET%
echo %COLOR_CYAN%===============================%COLOR_RESET%
echo.
echo %COLOR_YELLOW%Before proceeding:%COLOR_RESET%
echo - Make sure the Zello login screen is visible, and should only stop at the username field.
echo - Please make sure there's no keyboard showing.
echo - This program will automatically fill the Username, Password and Network fields,
echo - so DO NOT TOUCH RADIO AFTER FILLING UP THE DETAILS BELOW.
echo.
pause

echo.
:: Get inputs
set /p username="Enter username: "
set /p password="Enter password: "
set /p network="Enter network: "

:: Format (spaces to underscores)
set username_input=%username: =_%
set password_input=%password: =_%
set network_input=%network: =_%

:: Send all inputs with tab/enter
:: Check if a device is connected before proceeding
adb get-state 2>nul | findstr /i "device" >nul
if errorlevel 1 (
    echo %COLOR_RED%No device detected. Please connect a device and try again.%COLOR_RESET%
    pause
    goto MENU
)

adb shell input text %username_input%
adb shell input keyevent 20
adb shell input text %password_input%
adb shell input keyevent 20
adb shell input keyevent 20
adb shell input keyevent 21
adb shell input text %network_input%
adb shell input keyevent 19
adb shell input keyevent 19
adb shell input keyevent 19
adb shell input keyevent 19
adb shell input keyevent 19
adb shell input keyevent 19
adb shell input keyevent 22
adb shell input keyevent 66

echo.
echo %COLOR_GREEN%All inputs sent! This should login properly if the credentials are correct.%COLOR_RESET%
pause
goto MENU
