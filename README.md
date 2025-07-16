# yategood-manager [![](https://img.shields.io/github/v/release/kesongblack/yategood-manager?label=)](https://github.com/kesongblack/yategood-manager/releases/latest)

A simple batch script to manage the YateGood service.

This project aims to centralize the tools in configuring the Yategood Push-to-talk to Cellular (PoC) radios without tinkering too much ADBs.

This program focuses on the Zello application, but revisions for other applications are welcome.


## ⚠️Disclaimer⚠️

Debugging and modifying devices using ADB tools can potentially void warranties, cause data loss, or render devices unusable if not done correctly. Use this script and ADB commands at your own risk. Always ensure you have proper backups and understand the implications of each action. The author is not responsible for any damage or issues resulting from the use of this tool.

## Requirements

- Windows 10/11 
- [Android Platform Tools (ADB)](https://developer.android.com/tools/releases/platform-tools) 
- ...and of course, a Yategood PoC radio.

## Usage
### 1. Activate Developer Tools in your Yategood PoC Radio:
  - Go to Settings > About Radio/Device
  - Find Build Number by pressing down
  - Click the Build Number SEVEN (7) times or until "You are a developer!" will show

### 2. Prepare the ADB Tools in your Computer/Laptop
- Please download the latest zip file here:
    [![Download Latest Release](https://img.shields.io/badge/Download%20Latest%20Release-blue?logo=github)](https://github.com/kesongblack/yategood-manager/releases/download/1.0.1/yategood-manager.zip)
- Extract the zip file inside the **📁platform-tools** folder
- Open **🤖yategood-manager.bat**

## Available Options

The batch script provides the following interactive menu options:

1. **CHECK IF ADB IS WORKING**
   - Verifies if Android Debug Bridge (ADB) is installed and accessible. Lists connected devices if successful, or shows an error if ADB is not recognized.

2. **INSTALL APKS FROM "APP" FOLDER**
   - Installs all APK files found in the `app` directory (included in the zip file) to the connected device using ADB.
   
   **KNOWN BUG:** The script will terminate after running this option, so it needs to be opened once again after installing. 

3. **SEND TEXT INPUT TO ZELLO**
   - Prompts the user to enter text, which is then sent to the Zello app on the device using ADB. Spaces in the input are replaced with underscores. The user should manually place the cursor in the desired field in Zello before running this option.

4. **AUTO-FILL ZELLO LOGIN**
   - Guides the user to the Zello login screen, then prompts for username, password, and network. Automatically fills these fields in the app using ADB commands and attempts to log in. Spaces are replaced with underscores.

5. **EXIT**
   - Exits the script.
