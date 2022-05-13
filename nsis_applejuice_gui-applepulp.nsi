;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"

;--------------------------------
; add plugins folder
   !addplugindir /x86-ansi "plugins/x86-ansi"
   !addplugindir /x86-unicode "plugins/x86-unicode"

;--------------------------------
;General
    Unicode true
    !define COMPANY "appleJuiceNETZ"
    !define LINK_ABOUT "https://applejuicenetz.github.io"
    !define LINK_HELP "https://applejuicenetz.github.io/faq/"
    !define PRODUCT "appleJuice ApplePulp GUI"
    !define PRODUCT_SHORT "ApplePulp"
    !define EXE_NAME "ApplePulp"
    !define REG_URL_NAME "${COMPANY}.URI.${PRODUCT_SHORT}"
    !define INSTALLSIZE 1852

    InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation"
    InstallDir "$PROGRAMFILES\${COMPANY}\${PRODUCT_SHORT}"
    Name "${PRODUCT}"
    OutFile "build/${PRODUCT_SHORT}.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

;--------------------------------
;Links
    !define LINK_GUI "https://github.com/applejuicenetz/gui-applepulp/releases/latest/download/ApplePulp.zip"

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\${PRODUCT_SHORT}.ico"
    !define MUI_UNICON "resources\${PRODUCT_SHORT}.ico"
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
;Install Section
Section ""
    AddSize ${INSTALLSIZE}

    SetOutPath "$INSTDIR"

    DetailPrint "download ${PRODUCT}"
    INetC::get /NOCANCEL "${LINK_GUI}" "${PRODUCT_SHORT}.zip" /END
    Pop $0
    DetailPrint $0

    ${IfNot} $0 == "OK"
        MessageBox MB_ICONSTOP "download failed"
        Abort
    ${endif}

    DetailPrint "extract ${PRODUCT_SHORT}"
    nsisunz::UnzipToLog "${PRODUCT_SHORT}.zip" "$INSTDIR"
    Pop $0
    DetailPrint $0

    Delete "${PRODUCT_SHORT}.zip"

    WriteUninstaller "uninstaller.exe"

    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk" "$INSTDIR\${EXE_NAME}.exe"
    CreateShortcut "$desktop\${PRODUCT}.lnk" "$INSTDIR\${EXE_NAME}.exe"

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

    # create ajfsp protocol (legacy)
    WriteRegStr HKCR "ajfsp" "" "URL: ajfsp Protocol"
    WriteRegStr HKCR "ajfsp" "URL Protocol" ""

    # create unique ajfsp capabilities
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationName" "${PRODUCT_SHORT}"
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationIcon" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationDescription" "appleJuice GUI"
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities\URLAssociations" "ajfsp" "${REG_URL_NAME}"
    WriteRegStr HKLM "SOFTWARE\RegisteredApplications" "${PRODUCT_SHORT}" "Software\\${COMPANY}\\${PRODUCT_SHORT}\\Capabilities"

    # create unique ajfsp classes
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}" "" "URL:ajfsp"
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}" "URL Protocol" ""
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}\DefaultIcon" "" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}\shell\open\command" "" '"$INSTDIR\${EXE_NAME}.exe" "%1"'

    # create unique ajfsp handler
    WriteRegStr HKCR "${REG_URL_NAME}" "" "URL:ajfsp"
    WriteRegStr HKCR "${REG_URL_NAME}" "URL Protocol" ""
    WriteRegStr HKCR "${REG_URL_NAME}\DefaultIcon" "" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKCR "${REG_URL_NAME}\shell\open\command" "" '"$INSTDIR\${EXE_NAME}.exe" "%1"'
SectionEnd

;--------------------------------
; Uninstaller
Section "Uninstall"
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}"
    DeleteRegKey HKLM "SOFTWARE\Classes\${REG_URL_NAME}"
    DeleteRegKey HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}"
    DeleteRegKey HKCR "${REG_URL_NAME}"
    Delete "$desktop\${PRODUCT}.lnk"
    Delete "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk"
    RMDir /r /REBOOTOK $INSTDIR
SectionEnd
