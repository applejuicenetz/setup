#!/usr/bin/env bash

set -ex

CURL_OPTS="--fail --silent --location"

AJCORE_JAR="https://github.com/applejuicenet/core/releases/latest/download/ajcore.jar"
AJGUI_ZIP="https://github.com/applejuicenet/gui-java/releases/latest/download/AJCoreGUI.zip"

AJNETMASK_x86="https://github.com/applejuicenet/ajnetmask/releases/latest/download/ajnetmask-i386.dll"
AJNETMASK_x64="https://github.com/applejuicenet/ajnetmask/releases/latest/download/ajnetmask-x86_64.dll"

TRAYICON_x86="https://github.com/applejuicenet/core-trayicon/releases/download/1.0.0/TrayIcon12_x86.dll"
TRAYICON_x64="https://github.com/applejuicenet/core-trayicon/releases/download/1.0.0/TrayIcon12_x64.dll"

# Core
curl ${CURL_OPTS} -o ./build/ajcore.jar ${AJCORE_JAR}

# Core x86
mkdir -p ./build/x86/
curl ${CURL_OPTS} -o ./build/x86/ajnetmask.dll ${AJNETMASK_x86}
curl ${CURL_OPTS} -o ./build/x86/TrayIcon12.dll ${TRAYICON_x86}

# Core x64
mkdir -p ./build/x64/
curl ${CURL_OPTS} -o ./build/x64/ajnetmask.dll ${AJNETMASK_x64}
curl ${CURL_OPTS} -o ./build/x64/TrayIcon12.dll ${TRAYICON_x64}

# GUI
curl ${CURL_OPTS} -o ./build/AJCoreGUI.zip ${AJGUI_ZIP}
rm -rf /build/GUI/
mkdir -p ./build/GUI/
unzip -o ./build/AJCoreGUI.zip -d ./build/GUI/
rm ./build/AJCoreGUI.zip

makensis nsis_applejuice_multi.nsi

shasum -a 256 appleJuice-setup.exe > appleJuice-setup.exe.sha256.txt
