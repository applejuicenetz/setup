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
    !define COMPANY "appleJuiceNETZ"
    !define PRODUCT "appleJuice Collector"
    !define PRODUCT_SHORT "Collector"
    !define INSTALLSIZE 128280

    InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation"
    InstallDir "$PROGRAMFILES64\${COMPANY}\${PRODUCT_SHORT}"
    Name "${PRODUCT}"
    OutFile "build/AJCollector.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

;--------------------------------
;Links
    !define LINK_COLLECTOR "https://github.com/applejuicenetz/collector/releases/latest/download/AJCollector.exe"
    !define LINK_JRE_X64 "https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jre/hotspot/normal/eclipse?project=jdk"
    !define LINK_JRE_X86 "https://api.adoptium.net/v3/binary/latest/17/ga/windows/x86/jre/hotspot/normal/eclipse?project=jdk"

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\${PRODUCT_SHORT}.ico"
    !define MUI_UNICON "resources\${PRODUCT_SHORT}.ico"
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
;Install Section
Section ""
    AddSize ${INSTALLSIZE}

    SetOutPath "$INSTDIR"

    DetailPrint "download ${PRODUCT}"
    INetC::get /NOCANCEL "${LINK_COLLECTOR}" "AJCollector.exe" /END
    Pop $0
    DetailPrint $0

    ${IfNot} $0 == "OK"
        MessageBox MB_ICONSTOP "download failed"
        Abort
    ${endif}

    ${IfNot} ${FileExists} "$INSTDIR\Java\*.*"
        ${If} ${RunningX64}
            DetailPrint "download Java (x64)"
            INetC::get /NOCANCEL "${LINK_JRE_X64}" "Java.zip" /END
        ${else}
            DetailPrint "download Java (x)"
             INetC::get /NOCANCEL "${LINK_JRE_X86}" "Java.zip" /END
        ${endif}

        DetailPrint "extract Java"
        nsisunz::UnzipToLog "Java.zip" "$INSTDIR"
        Pop $0
        DetailPrint $0

        Delete "Java.zip"

        FindFirst $0 $1 "jdk-*-jre"
        FindClose $0
        Rename /REBOOTOK "$1" "Java"
    ${EndIf}

    WriteUninstaller "$INSTDIR\uninstaller.exe"

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk" "$INSTDIR\AJCollector.exe"
    CreateShortcut "$desktop\${PRODUCT}.lnk" "$INSTDIR\AJCollector.exe"
 
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
SectionEnd

;--------------------------------
; Uninstaller
Section "Uninstall"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
    Delete "$desktop\${PRODUCT}.lnk"
    Delete "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk"
    RMDir /r /REBOOTOK $INSTDIR
SectionEnd
