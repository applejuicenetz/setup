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
    Name "appleJuice"
    OutFile "build/appleJuice.setup.exe"
    SetCompressor lzma
    RequestExecutionLevel admin
    ShowInstDetails show

    Var ARGUMENTS

;--------------------------------
;Links
    !define CORE_X86_LINK "https://github.com/applejuicenetz/core/releases/latest/download/AJCore.x86.setup.exe"
    !define CORE_X86_NAME "AJCore.x86.setup.exe"
    !define CORE_X86_SIZE 108800

    !define CORE_X64_LINK "https://github.com/applejuicenetz/core/releases/latest/download/AJCore.x64.setup.exe"
    !define CORE_X64_NAME "AJCore.x64.setup.exe"
    !define CORE_X64_SIZE 108800

    !define GUI_JAVA_LINK "https://github.com/applejuicenetz/gui-java/releases/latest/download/AJCoreGUI.setup.exe"
    !define GUI_JAVA_NAME "AJCoreGUI.setup.exe"
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

    !define COLLECTOR_LINK "https://github.com/applejuicenetz/collector/releases/latest/download/AJCollector.setup.exe"
    !define COLLECTOR_NAME "AJCollector.setup.exe"
    !define COLLECTOR_SIZE 128280

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
SectionEnd

;--------------------------------
;Sections appleJuice
SectionGroup /e "appleJuice" SECTION_GROUP_APPLEJUICE
    ;--------------------------------
    ;appleJuice Core x86
    Section "Core (x86)" SECTION_CORE_X86
        Addsize ${CORE_X86_SIZE}

        DetailPrint "download ${CORE_X86_NAME}"
        INetC::get "${CORE_X86_LINK}" "${CORE_X86_NAME}" /END
        ExecWait '"${CORE_X86_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Core x64
    Section "Core (x64)" SECTION_CORE_X64
        Addsize ${CORE_X64_SIZE}

        DetailPrint "download ${CORE_X64_NAME}"
        INetC::get "${CORE_X64_LINK}" "${CORE_X64_NAME}" /END
        ExecWait '"${CORE_X64_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Java GUI
    Section "Java GUI" SECTION_GUI_JAVA
        Addsize ${GUI_JAVA_SIZE}

        DetailPrint "download ${GUI_JAVA_NAME}"
        INetC::get "${GUI_JAVA_LINK}" "${GUI_JAVA_NAME}" /END
        ExecWait '"${GUI_JAVA_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Collector
    Section /o "Collector" SECTION_COLLECTOR
        Addsize ${COLLECTOR_SIZE}

        DetailPrint "download ${COLLECTOR_NAME}"
        INetC::get "${COLLECTOR_LINK}" "${COLLECTOR_NAME}" /END
        ExecWait '"${COLLECTOR_NAME}"$ARGUMENTS'
    SectionEnd

SectionGroupEnd

;--------------------------------
;Sections Andere
SectionGroup /e "Andere" SECTION_GROUP_ANDERE
    ;--------------------------------
    ;appleJuice Apfelmus GUI
    Section /o "Apfelmus GUI" SECTION_GUI_APFELMUS
        Addsize ${GUI_APFELMUS_SIZE}

        DetailPrint "download ${GUI_APFELMUS_NAME}"
        INetC::get "${GUI_APFELMUS_LINK}" "${GUI_APFELMUS_NAME}" /END
        ExecWait '"${GUI_APFELMUS_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice ApplePulp GUI
    Section /o "ApplePulp GUI" SECTION_GUI_APPLEPULP
        Addsize ${GUI_APPLEPULP_SIZE}

        DetailPrint "download ${GUI_APPLEPULP_NAME}"
        INetC::get "${GUI_APPLEPULP_LINK}" "${GUI_APPLEPULP_NAME}" /END
        ExecWait '"${GUI_APPLEPULP_NAME}"$ARGUMENTS'
    SectionEnd
    ;--------------------------------
    ;appleJuice Juicer GUI
    Section /o "Juicer GUI" SECTION_GUI_JUICER
        Addsize ${GUI_JUICER_SIZE}

        DetailPrint "download ${GUI_JUICER_NAME}"
        INetC::get "${GUI_JUICER_LINK}" "${GUI_JUICER_NAME}" /END
        ExecWait '"${GUI_JUICER_NAME}"$ARGUMENTS'
    SectionEnd

SectionGroupEnd

;--------------------------------
; Section Descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_SILENT} "unbeaufsichtigten Installation aller ausgewählten Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GROUP_APPLEJUICE} "appleJuiceNETZ Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_CORE_X86} "32bit Core"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_CORE_X64} "64bit Core"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_JAVA} "offizielles JavaGUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_COLLECTOR} "Informationen Sammler"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GROUP_ANDERE} "optionale Komponenten"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_APFELMUS} "Community GUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_APPLEPULP} "Community GUI"
!insertmacro MUI_DESCRIPTION_TEXT ${SECTION_GUI_JUICER} "Community GUI"
!insertmacro MUI_FUNCTION_DESCRIPTION_END
!insertmacro MUI_LANGUAGE "German"

Function .onInit
  ${If} ${RunningX64}
    SectionSetFlags ${SECTION_CORE_X86} 0
  ${else}
    IntOp $0 0 | ${SF_RO}
    SectionSetFlags ${SECTION_CORE_X64} $0
  ${endif}
FunctionEnd
