﻿;--------------------------------
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

    !define COLLECTOR_LINK "https://github.com/applejuicenetz/collector/releases/latest/download/AJCollector.setup.exe"
    !define COLLECTOR_NAME "AJCollector.setup.exe"
    !define COLLECTOR_SIZE 128280

;--------------------------------
;Interface Settings
    !define MUI_ICON "resources\applejuice.ico"
    !define MUI_UNICON "resources\applejuice.ico"
    !define MUI_ABORTWARNING

;--------------------------------
;Installer Settings
    !insertmacro MUI_PAGE_COMPONENTS
    !insertmacro MUI_PAGE_INSTFILES
    !insertmacro MUI_LANGUAGE "German"

;--------------------------------
;Section Options
Section /o "Silent"
    DetailPrint "silent install"

    StrCpy $ARGUMENTS " /S"
SectionEnd

;--------------------------------
;Sections appleJuice
SectionGroup /e "appleJuice"
    ;--------------------------------
    ;appleJuice Core x86
    Section "Core (x86)" CORE_X86
        Addsize ${CORE_X86_SIZE}

        DetailPrint "download ${CORE_X86_NAME}"
        INetC::get "${CORE_X86_LINK}" "${CORE_X86_NAME}" /END
        ExecWait '"${CORE_X86_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Core x64
    Section "Core (x64)" CORE_X64
        Addsize ${CORE_X64_SIZE}

        DetailPrint "download ${CORE_X64_NAME}"
        INetC::get "${CORE_X64_LINK}" "${CORE_X64_NAME}" /END
        ExecWait '"${CORE_X64_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Java GUI
    Section "Java GUI"
        Addsize ${GUI_JAVA_SIZE}

        DetailPrint "download ${GUI_JAVA_NAME}"
        INetC::get "${GUI_JAVA_LINK}" "${GUI_JAVA_NAME}" /END
        ExecWait '"${GUI_JAVA_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice Collector
    Section /o "Collector"
        Addsize ${COLLECTOR_SIZE}

        DetailPrint "download ${COLLECTOR_NAME}"
        INetC::get "${COLLECTOR_LINK}" "${COLLECTOR_NAME}" /END
        ExecWait '"${COLLECTOR_NAME}"$ARGUMENTS'
    SectionEnd

SectionGroupEnd

;--------------------------------
;Sections Andere
SectionGroup /e "Andere"
    ;--------------------------------
    ;appleJuice Apfelmus GUI
    Section /o "Apfelmus GUI"
        Addsize ${GUI_APFELMUS_SIZE}

        DetailPrint "download ${GUI_APFELMUS_NAME}"
        INetC::get "${GUI_APFELMUS_LINK}" "${GUI_APFELMUS_NAME}" /END
        ExecWait '"${GUI_APFELMUS_NAME}"$ARGUMENTS'
    SectionEnd

    ;--------------------------------
    ;appleJuice ApplePulp GUI
    Section /o "ApplePulp GUI"
        Addsize ${GUI_APPLEPULP_SIZE}

        DetailPrint "download ${GUI_APPLEPULP_NAME}"
        INetC::get "${GUI_APPLEPULP_LINK}" "${GUI_APPLEPULP_NAME}" /END
        ExecWait '"${GUI_APPLEPULP_NAME}"$ARGUMENTS'
    SectionEnd

SectionGroupEnd

Function .onInit
  ${If} ${RunningX64}
    SectionSetFlags ${CORE_X86} 0
  ${else}
    IntOp $0 0 | ${SF_RO}
    SectionSetFlags ${CORE_X64} $0
  ${endif}
FunctionEnd