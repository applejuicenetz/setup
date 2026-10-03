;--------------------------------
;Include Modern UI
    !include "MUI2.nsh"
    !include "x64.nsh"
    !include "Sections.nsh"
    !include "LogicLib.nsh"

;--------------------------------
; add plugins folder
   !addplugindir /x86-ansi "plugins/x86-ansi"
   !addplugindir /x86-unicode "plugins/x86-unicode"

;--------------------------------
;General
    !ifndef SETUP_ARCH
        !define SETUP_ARCH "amd64"
    !endif
    !if "${SETUP_ARCH}" == "amd64"
        !define SETUP_ARCH_LABEL "AMD64"
    !else if "${SETUP_ARCH}" == "aarch64"
        !define SETUP_ARCH_LABEL "ARM64"
    !else
        !error "SETUP_ARCH must be amd64 or aarch64"
    !endif
    Unicode true
    Name "appleJuice (${SETUP_ARCH_LABEL})"
    OutFile "build/appleJuice-windows-${SETUP_ARCH}.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

    Var ARGUMENTS
    Var JPACKAGE_ARGUMENTS

;--------------------------------
;Links
    !ifdef CORE_VERSION
        !define CORE_LINK "https://github.com/applejuicenetz/core/releases/download/${CORE_VERSION}/AJCore-windows-${SETUP_ARCH}.exe"
    !else
        !define CORE_LINK "https://github.com/applejuicenetz/core/releases/latest/download/AJCore-windows-${SETUP_ARCH}.exe"
    !endif
    !define CORE_NAME "AJCore-windows-${SETUP_ARCH}.exe"
    !define CORE_X64_SIZE 108800

    !define GUI_JAVA_LINK "https://github.com/applejuicenetz/gui-java/releases/latest/download/AJCoreGUI-windows-${SETUP_ARCH}.exe"
    !define GUI_JAVA_NAME "AJCoreGUI-windows-${SETUP_ARCH}.exe"
    !define GUI_JAVA_SIZE 124500

    !define GUI_APFELMUS_LINK "https://github.com/applejuicenetz/gui-apfelmus/releases/latest/download/Apfelmus.setup.exe"
    !define GUI_APFELMUS_NAME "Apfelmus.setup.exe"
    !define GUI_APFELMUS_SIZE 1680

    !define GUI_APPLEPULP_LINK "https://github.com/applejuicenetz/gui-applepulp/releases/latest/download/ApplePulp.setup.exe"
    !define GUI_APPLEPULP_NAME "ApplePulp.setup.exe"
    !define GUI_APPLEPULP_SIZE 1852

    !define GUI_JUICER_LINK "https://github.com/applejuicenetz/gui-juicer/releases/latest/download/Juicer.setup.exe"
    !define GUI_JUICER_NAME "Juicer.setup.exe"
    !define GUI_JUICER_SIZE 13775

    !define COLLECTOR_LINK "https://github.com/applejuicenetz/collector/releases/latest/download/AJCollector-windows-${SETUP_ARCH}.exe"
    !define COLLECTOR_NAME "AJCollector-windows-${SETUP_ARCH}.exe"
    !define COLLECTOR_SIZE 128280

!macro InstallComponent LINK NAME OPTIONS
    DetailPrint "Download: ${NAME}"
    INetC::get /SILENT "${LINK}" "$PLUGINSDIR\${NAME}" /END
    Pop $0
    ${If} $0 != "OK"
        DetailPrint "Download fehlgeschlagen: ${NAME} ($0)"
        Delete "$PLUGINSDIR\${NAME}"
        SetErrorLevel 1
        Abort "Download fehlgeschlagen: ${NAME} ($0)"
    ${EndIf}
    ClearErrors
    ExecWait '"$PLUGINSDIR\${NAME}"${OPTIONS}' $0
    ${If} ${Errors}
        Delete "$PLUGINSDIR\${NAME}"
        SetErrorLevel 1
        Abort "Installer konnte nicht gestartet werden: ${NAME}"
    ${EndIf}
    Delete "$PLUGINSDIR\${NAME}"
    ${If} $0 == 3010
    ${OrIf} $0 == 1641
        SetRebootFlag true
        DetailPrint "Neustart erforderlich: ${NAME}"
    ${ElseIf} $0 != 0
        DetailPrint "Installation fehlgeschlagen: ${NAME} (Exit-Code $0)"
        SetErrorLevel $0
        Abort "Installation fehlgeschlagen: ${NAME} (Exit-Code $0)"
    ${EndIf}
!macroend

!macro CheckLegacyProduct SECTION_ID DISPLAY PRODUCT
    ${If} ${SectionIsSelected} ${SECTION_ID}
        !insertmacro CheckLegacyView 32 "${DISPLAY}" "${PRODUCT}"
        !insertmacro CheckLegacyView 64 "${DISPLAY}" "${PRODUCT}"
    ${EndIf}
!macroend

!macro CheckLegacyView VIEW DISPLAY PRODUCT
    SetRegView ${VIEW}
    ReadRegStr $0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT}" "UninstallString"
    SetRegView 32
    ${If} $0 != ""
        DetailPrint "Alte Installation gefunden: ${PRODUCT}"
        MessageBox MB_OK|MB_ICONSTOP "Alte Installation von ${DISPLAY} gefunden.$\r$\nBitte zuerst das alte Setup deinstallieren und danach dieses Setup erneut starten.$\r$\nDie Installation wird abgebrochen." /SD IDOK
        SetErrorLevel 1
        Abort "Alte Installation von ${DISPLAY} gefunden"
    ${EndIf}
!macroend

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\appleJuice.ico"
    !define MUI_UNICON "resources\appleJuice.ico"
    !define MUI_ABORTWARNING
    !define MUI_FINISHPAGE_NOAUTOCLOSE

;--------------------------------
;Installer Settings
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_PAGE_FINISH

;--------------------------------
;Section Options
Section "Silent" SECTION_SILENT
    DetailPrint "silent install"

    StrCpy $ARGUMENTS " /S"
    StrCpy $JPACKAGE_ARGUMENTS " /qn /norestart"
SectionEnd

Section "-Altlasten"
    Call CheckLegacyInstallations
SectionEnd

;--------------------------------
;Sections appleJuice
SectionGroup /e "appleJuice" SECTION_GROUP_APPLEJUICE
    ;--------------------------------
    ;appleJuice Core x64
    Section "Core" SECTION_CORE_X64
        Addsize ${CORE_X64_SIZE}

        !insertmacro InstallComponent "${CORE_LINK}" "${CORE_NAME}" "$JPACKAGE_ARGUMENTS"
    SectionEnd

    ;--------------------------------
    ;appleJuice Java GUI
    Section "Java GUI" SECTION_GUI_JAVA
        Addsize ${GUI_JAVA_SIZE}

        !insertmacro InstallComponent "${GUI_JAVA_LINK}" "${GUI_JAVA_NAME}" "$JPACKAGE_ARGUMENTS"
    SectionEnd

    ;--------------------------------
    ;appleJuice Collector
    Section /o "Collector" SECTION_COLLECTOR
        Addsize ${COLLECTOR_SIZE}

        !insertmacro InstallComponent "${COLLECTOR_LINK}" "${COLLECTOR_NAME}" "$JPACKAGE_ARGUMENTS"
    SectionEnd

SectionGroupEnd

;--------------------------------
;Sections Andere
SectionGroup /e "Andere" SECTION_GROUP_ANDERE
    ;--------------------------------
    ;appleJuice Apfelmus GUI
    Section /o "Apfelmus GUI" SECTION_GUI_APFELMUS
        Addsize ${GUI_APFELMUS_SIZE}

        !insertmacro InstallComponent "${GUI_APFELMUS_LINK}" "${GUI_APFELMUS_NAME}" "$ARGUMENTS"
    SectionEnd

    ;--------------------------------
    ;appleJuice ApplePulp GUI
    Section /o "ApplePulp GUI" SECTION_GUI_APPLEPULP
        Addsize ${GUI_APPLEPULP_SIZE}

        !insertmacro InstallComponent "${GUI_APPLEPULP_LINK}" "${GUI_APPLEPULP_NAME}" "$ARGUMENTS"
    SectionEnd
    ;--------------------------------
    ;appleJuice Juicer GUI
    Section /o "Juicer GUI" SECTION_GUI_JUICER
        Addsize ${GUI_JUICER_SIZE}

        !insertmacro InstallComponent "${GUI_JUICER_LINK}" "${GUI_JUICER_NAME}" "$ARGUMENTS"
    SectionEnd

SectionGroupEnd

Section -Finish
    ${If} ${RebootFlag}
        SetErrorLevel 3010
    ${EndIf}
SectionEnd

;--------------------------------
; Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_SILENT} "unbeaufsichtigten Installation aller ausgewählten Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GROUP_APPLEJUICE} "appleJuiceNETZ Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_CORE_X64} "appleJuice Core"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_JAVA} "offizielles JavaGUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_COLLECTOR} "Informationen Sammler"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GROUP_ANDERE} "optionale Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_APFELMUS} "Community GUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_APPLEPULP} "Community GUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_JUICER} "Community GUI"
!insertmacro MUI_FUNCTION_DESCRIPTION_END
!insertmacro MUI_LANGUAGE "German"

Function .onInit
!if "${SETUP_ARCH}" == "aarch64"
  ${IfNot} ${IsNativeARM64}
!else
  ${IfNot} ${IsNativeAMD64}
!endif
    MessageBox MB_OK|MB_ICONSTOP "Dieses Setup benötigt Windows auf ${SETUP_ARCH_LABEL}. Bitte das passende Multi-Setup verwenden." /SD IDOK
    SetErrorLevel 1
    Abort
  ${EndIf}
  InitPluginsDir
  SetOutPath "$PLUGINSDIR"
  StrCpy $ARGUMENTS ""
  StrCpy $JPACKAGE_ARGUMENTS " /norestart"
FunctionEnd

Function CheckLegacyInstallations
    !insertmacro CheckLegacyProduct ${SECTION_CORE_X64} "appleJuice Core" "appleJuice Core (x86)"
    !insertmacro CheckLegacyProduct ${SECTION_CORE_X64} "appleJuice Core" "appleJuice Core (x64)"
    !insertmacro CheckLegacyProduct ${SECTION_CORE_X64} "appleJuice Core" "appleJuice Core (Beta)"
    !insertmacro CheckLegacyProduct ${SECTION_GUI_JAVA} "appleJuice JavaGUI" "appleJuice JavaGUI"
    !insertmacro CheckLegacyProduct ${SECTION_COLLECTOR} "appleJuice Collector" "appleJuice Collector"
FunctionEnd
