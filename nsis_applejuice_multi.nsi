;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"

;--------------------------------
;General
    Unicode True
    !define COMPANY "appleJuiceNET"
    !define PRODUCT "appleJuice"
    !define INSTALLATIONNAME "${COMPANY}-${PRODUCT}"

    InstallDirRegKey HKLM "SOFTWARE\${COMPANY}\${PRODUCT}" "installdir"
    InstallDir $PROGRAMFILES\${COMPANY}\${PRODUCT}
    Name "${PRODUCT}"
    OutFile "${PRODUCT}-setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\applejuice.ico"
    !define MUI_UNICON "resources\applejuice.ico"
    !define MUI_ABORTWARNING

;--------------------------------
;Installer Pages
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "resources\Lizenz.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES

;--------------------------------
;Uninstaller Pages
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Default Section
Section ""
    WriteUninstaller "$INSTDIR\uninstaller.exe"

    # delete old ajnetmask.dll if still exists
    Delete "$WINDIR\system32\ajnetmask.dll"

    SetOutPath "$INSTDIR"
    File "resources\applejuice.ico"
    File "resources\Lizenz.txt"

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\uninstaller.lnk" "$INSTDIR\uninstaller.exe"

    CreateDirectory "$SMPROGRAMS\${COMPANY}\${PRODUCT}"

    # uninstaller keys
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "DisplayName" "${PRODUCT}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "UninstallString" '"$INSTDIR\uninstaller.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "InstallLocation" '"$INSTDIR"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "DisplayIcon" '"$INSTDIR\applejuice.ico"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "Publisher" "${COMPANY}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "UrlInfoAbout" "https://applejuicenet.cc"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}" "NoRepair" 1
SectionEnd

;--------------------------------
;appleJuice Core (x86)
Section "appleJuice Core (x86)" SectionCoreX86
    SetOutPath "$INSTDIR\Core"
    File "build\ajcore.jar"

    SetOutPath "$INSTDIR\Core\x86"

    File /r starter\x86\*
    File /r build\x86\*

    CreateShortcut "$desktop\appleJuice Core (x86).lnk" "$INSTDIR\Core\x86\ajcore.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x86).lnk" "$INSTDIR\Core\x86\ajcore.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x86, nogui).lnk" "$INSTDIR\Core\x86\ajcore_nogui.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x86, noprofile).lnk" "$INSTDIR\Core\x86\ajcore_noprofile.exe"
SectionEnd

;--------------------------------
;appleJuice Core (x64)
Section "appleJuice Core (x64)" SectionCoreX64
    SetOutPath "$INSTDIR\Core"
    File "build\ajcore.jar"

    SetOutPath "$INSTDIR\Core\x64"

    File /r starter\x64\*
    File /r build\x64\*

    CreateShortcut "$desktop\appleJuice Core (x64).lnk" "$INSTDIR\Core\x64\ajcore_nogui.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x64).lnk" "$INSTDIR\Core\x64\ajcore.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x64, nogui).lnk" "$INSTDIR\Core\x64\ajcore_nogui.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice Core (x64, noprofile).lnk" "$INSTDIR\Core\x64\ajcore_noprofile.exe"
SectionEnd

;--------------------------------
;appleJuice GUI
Section "appleJuice GUI" SectionGUI
    SetOutPath "$INSTDIR\GUI"

    File /r build\GUI\*

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}\appleJuice GUI.lnk" "$INSTDIR\GUI\AJCoreGUI.exe"
    CreateShortcut "$desktop\appleJuice GUI.lnk" "$INSTDIR\GUI\AJCoreGUI.exe"

    # ajfsp protocol
    WriteRegStr HKCR "ajfsp" "" "URL: ajfsp Protocol"
    WriteRegStr HKCR "ajfsp" "URL Protocol" ""
    WriteRegStr HKCR "ajfsp\shell\open\command" "" '"$INSTDIR\GUI\AJCoreGUI.exe" -link=%1'
SectionEnd

;--------------------------------
; Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SectionCoreX86} "32bit Client"
!insertmacro MUI_DESCRIPTION_TEXT ${SectionCoreX64} "64bit Client"
!insertmacro MUI_DESCRIPTION_TEXT ${SectionGUI} "Userinterface"
!insertmacro MUI_FUNCTION_DESCRIPTION_END
!insertmacro MUI_LANGUAGE "German"

;--------------------------------
; Uninstaller
Section "Uninstall"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${INSTALLATIONNAME}"
    Delete "$desktop\appleJuice GUI.lnk"
    Delete "$desktop\appleJuice Core (x86).lnk"
    Delete "$desktop\appleJuice Core (x64).lnk"
    RMDir /r $INSTDIR
    RMDir /r $SMPROGRAMS\${COMPANY}
SectionEnd
