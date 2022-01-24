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
    !define PRODUCT "appleJuice JavaGUI"
    !define PRODUCT_SHORT "JavaGUI"
    !define EXE_NAME "AJCoreGUI"
    !define REG_URL_NAME "${COMPANY}.URI.${PRODUCT_SHORT}"
    !define REG_EXT_NAME "${COMPANY}.EXT.${PRODUCT_SHORT}"
    !define INSTALLSIZE 124500

    InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "InstallLocation"
    InstallDir "$PROGRAMFILES64\${COMPANY}\${PRODUCT_SHORT}"
    Name "${PRODUCT}"
    OutFile "build/AJCoreGUI.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

;--------------------------------
;Links    
    !define LINK_GUI "https://github.com/applejuicenetz/gui-java/releases/latest/download/AJCoreGUI.zip"
    !define LINK_JRE_X64 "https://api.adoptium.net/v3/binary/latest/11/ga/windows/x64/jre/hotspot/normal/eclipse?project=jdk"
    !define LINK_JRE_X86 "https://api.adoptium.net/v3/binary/latest/11/ga/windows/x86/jre/hotspot/normal/eclipse?project=jdk"
    
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
    INetC::get /NOCANCEL "${LINK_GUI}" "GUI.zip" /END
    Pop $0
    DetailPrint $0
    
    ${IfNot} $0 == "OK"
        MessageBox MB_ICONSTOP "download failed"
        Abort
    ${endif}
    
    DetailPrint "extract GUI"
    nsisunz::UnzipToLog "GUI.zip" "$INSTDIR"
    Pop $0
    DetailPrint $0

    Delete "GUI.zip"

    ${IfNot} ${FileExists} "$INSTDIR\Java\*.*"
        ${If} ${RunningX64}
            DetailPrint "download Java (x64)"
            INetC::get /NOCANCEL "${LINK_JRE_X64}" "Java.zip" /END
        ${else}
            DetailPrint "download Java (x)"
             INetC::get /NOCANCEL "${LINK_JRE_X86}" "Java.zip" /END
        ${endif}
        
        Pop $0
        DetailPrint $0
        
        DetailPrint "extract Java"
        nsisunz::UnzipToLog "Java.zip" "$INSTDIR"
        Pop $0
        DetailPrint $0
        
        Delete "Java.zip"
        
        FindFirst $0 $1 "jdk-*-jre"
        FindClose $0
        Rename /REBOOTOK "$1" "Java"
    ${EndIf}
    
    WriteUninstaller "uninstaller.exe"
 
    CreateShortcut "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk" "$INSTDIR\${EXE_NAME}.exe"
    CreateShortcut "$desktop\${PRODUCT}.lnk" "$INSTDIR\${EXE_NAME}.exe"
    
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

    # create ajfsp protocol
    WriteRegStr HKCR "ajfsp" "" "URL: ajfsp Protocol"
    WriteRegStr HKCR "ajfsp" "URL Protocol" ""

    # create ajl file type
    WriteRegStr HKCR ".ajl" "" "appleJuice Linkliste"
    WriteRegStr HKCR ".ajl" "Content Typ" "application/text"
    WriteRegStr HKCR ".ajl" "PerceivedTyp" "text"

    # create unique ajfsp capabilities
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationName" "${PRODUCT_SHORT}"
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationIcon" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities" "ApplicationDescription" "appleJuice GUI"
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities\URLAssociations" "ajfsp" "${REG_URL_NAME}"
    WriteRegStr HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities\FileAssociations" ".ajl" "${REG_EXT_NAME}"
    WriteRegStr HKLM "SOFTWARE\RegisteredApplications" "${PRODUCT_SHORT}" "Software\\${COMPANY}\\${PRODUCT_SHORT}\\Capabilities"
    
    # create unique ajfsp classes
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}" "" "URL:ajfsp"
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}" "URL Protocol" ""
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}\DefaultIcon" "" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_URL_NAME}\shell\open\command" "" '"$INSTDIR\${EXE_NAME}.exe" "%1"'

    # create unique ajl classes
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_EXT_NAME}" "" "appleJuice Linkliste"
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_EXT_NAME}\DefaultIcon" "" '"$INSTDIR\${EXE_NAME}.exe",0'
    WriteRegStr HKLM "SOFTWARE\Classes\${REG_EXT_NAME}\shell\open\command" "" '"$INSTDIR\${EXE_NAME}.exe" "%1"'

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
    DeleteRegKey HKLM "SOFTWARE\${COMPANY}\${PRODUCT_SHORT}\Capabilities"
    DeleteRegKey HKCR "${REG_URL_NAME}"
    DeleteRegKey HKCR "${REG_EXT_NAME}"
    Delete "$desktop\${PRODUCT}.lnk"
    Delete "$SMPROGRAMS\${COMPANY}\${PRODUCT}.lnk"
    RMDir /r /REBOOTOK $INSTDIR
SectionEnd
