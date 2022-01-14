;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"
    !include "x64.nsh"

;--------------------------------
; add plugins folder
   !addplugindir /x86-ansi "plugins/x86-ansi"
   !addplugindir /x86-unicode "plugins/x86-unicode"

;--------------------------------
;General
    Unicode true
    !define ARCH "x64"
    !define COMPANY "appleJuiceNETZ"
    !define PRODUCT "appleJuice Core (${ARCH})"
    !define PRODUCT_SHORT "Core"
    !define INSTALLSIZE 108800

    InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation"
    InstallDir "$PROGRAMFILES64\${COMPANY}\${PRODUCT_SHORT}"
    Name "${PRODUCT}"
    OutFile "build/AJCore.${ARCH}.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

;--------------------------------
;Links
    !define LINK_CORE "https://github.com/applejuicenetz/core/releases/latest/download/ajcore.jar"
    !define LINK_AJNETMASK "https://github.com/applejuicenetz/ajnetmask/releases/latest/download/ajnetmask-x86_64.dll"
    !define LINK_TRAYICON "https://github.com/applejuicenetz/core-trayicon/releases/latest/download/TrayIcon12_x64.dll"
    !define LINK_JRE_7 "https://github.com/applejuicenetz/zulu-jre7/releases/latest/download/jre7.x64.zip"

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\applejuice.ico"
    !define MUI_UNICON "resources\applejuice.ico"
    !define MUI_ABORTWARNING

;--------------------------------
;Installer Settings
    !insertmacro MUI_PAGE_WELCOME
    !insertmacro MUI_PAGE_DIRECTORY
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

;--------------------------------
;Uninstaller Settings
    !insertmacro MUI_UNPAGE_CONFIRM
    !insertmacro MUI_UNPAGE_INSTFILES
    !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
; Section Descriptions
    !insertmacro MUI_LANGUAGE "German"

;--------------------------------
;Default Section
Section ""
    AddSize ${INSTALLSIZE}

    SetOutPath "$INSTDIR"

    WriteUninstaller "$INSTDIR\uninstaller.exe"

    # delete old ajnetmask.dll if still exists
    Delete "$WINDIR\system32\ajnetmask.dll"

    # uninstaller keys
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" '"$INSTDIR\uninstaller.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation" '"$INSTDIR"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayIcon" '"$INSTDIR\uninstaller.exe",0'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "Publisher" "${COMPANY}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UrlInfoAbout" "https://applejuicenet.cc"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "EstimatedSize" ${INSTALLSIZE}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoRepair" 1

    File /r starter\${ARCH}\*

    DetailPrint "download ajcore.jar"
    INetC::get /NOCANCEL "${LINK_CORE}" "$INSTDIR\ajcore.jar" /END
    Pop $0
    DetailPrint $0

    DetailPrint "download ajnetmask.dll"
    INetC::get /NOCANCEL "${LINK_AJNETMASK}" "$INSTDIR\ajnetmask.dll" /END
    Pop $0
    DetailPrint $0

    DetailPrint "download TrayIcon12.dll"
    INetC::get /NOCANCEL "${LINK_TRAYICON}" "$INSTDIR\TrayIcon12.dll" /END
    Pop $0
    DetailPrint $0

    ${IfNot} ${FileExists} "$INSTDIR\Java\*.*"
        DetailPrint "download Java"
        INetC::get /NOCANCEL "${LINK_JRE_7}" "Java.zip" /END
        Pop $0
        DetailPrint $0

        RMDir /REBOOTOK /r "Java"

        DetailPrint "extract Java"
        nsisunz::UnzipToLog "Java.zip" "$INSTDIR"
        Pop $0
        DetailPrint $0

        Delete "Java.zip"

        FindFirst $0 $1 "jdk-*-jre"
        FindClose $0
        Rename /REBOOTOK "$1" "Java"
    ${EndIf}

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk" "$INSTDIR\ajcore.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT} (nogui).lnk" "$INSTDIR\ajcore_nogui.exe"
    CreateShortcut "$desktop\${PRODUCT}.lnk" "$INSTDIR\ajcore.exe"
SectionEnd

;--------------------------------
; Uninstaller
Section "Uninstall"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
    Delete "$desktop\${PRODUCT}.lnk"
    Delete "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk"
    Delete "$SMPROGRAMS\${COMPANY}\${PRODUCT} (nogui).lnk"
    RMDir /r /REBOOTOK $INSTDIR
SectionEnd

Function .onInit
    ${IfNot} ${RunningX64}
        MessageBox MB_ICONSTOP "64bit OS required"
        Abort
    ${EndIf}
 FunctionEnd
