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
    !define LINK_ABOUT "https://applejuicenetz.github.io"
    !define LINK_HELP "https://applejuicenetz.github.io/faq/"
    !define PRODUCT "appleJuice Core (Beta)"
    !define PRODUCT_SHORT "Core-Beta"
    !define INSTALLSIZE 108800

    InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation"
    InstallDir "$PROGRAMFILES64\${COMPANY}\${PRODUCT_SHORT}"
    Name "${PRODUCT}"
    OutFile "build/AJCore.beta.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

;--------------------------------
;Links
    !define LINK_SNAPSHOT "http://www.applejuicenet.cc/snapshot.php"
    !define LINK_JRE_21 "https://api.adoptium.net/v3/binary/latest/21/ga/windows/x64/jre/hotspot/normal/eclipse?project=jdk"

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\appleJuice.ico"
    !define MUI_UNICON "resources\appleJuice.ico"
    !define MUI_ABORTWARNING
    !define MUI_FINISHPAGE_NOAUTOCLOSE

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

    WriteUninstaller "uninstaller.exe"

    # uninstaller keys
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayName" "${PRODUCT}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString" '"$INSTDIR\uninstaller.exe"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation" '"$INSTDIR"'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "DisplayIcon" '"$INSTDIR\uninstaller.exe",0'
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "Publisher" "${COMPANY}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "HelpLink" "${LINK_HELP}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UrlInfoAbout" "${LINK_ABOUT}"
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "EstimatedSize" ${INSTALLSIZE}
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoModify" 1
    WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "NoRepair" 1

    File /r starter\${ARCH}\*_beta.exe

    DetailPrint "download ajcore.jar"
    INetC::get /NOCANCEL "${LINK_SNAPSHOT}" "$INSTDIR\ajcore.jar" /END
    Pop $0
    DetailPrint $0

    ${IfNot} ${FileExists} "$INSTDIR\Java\*.*"
        DetailPrint "download JRE 21"
        INetC::get /NOCANCEL "${LINK_JRE_21}" "Java.zip" /END
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
    ${else}
        DetailPrint "existing Java folder found, skip download"
    ${EndIf}

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk" "$INSTDIR\ajcore_beta.exe"
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT} (nogui).lnk" "$INSTDIR\ajcore_nogui_beta.exe"
    CreateShortcut "$desktop\${PRODUCT}.lnk" "$INSTDIR\ajcore_beta.exe"
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
