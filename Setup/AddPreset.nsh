!include "Util\ConfigRead.nsh"
!include "Util\ConfigWrite.nsh"
!include "Util\Explode.nsh"

!macro AddPreset SourcePath OutPath FileName Priority
    StrCpy $2 "${PRESETFOLDER}\${FileName}"

    SectionIn 1
    SetOutPath "${OutPath}"
    File "${SourcePath}\${FileName}"

    WriteINIStr "${OutPath}\${FileName}" "AspectRatioSuite.fx" "AspectRatio" "9.000000,16.000000"
    WriteINIStr "${OutPath}\${FileName}" "AspectRatioSuite.fx" "Mode" "1"
    WriteINIStr "${OutPath}\${FileName}" "Overlay.fx" "fOpacity" "1.000000"
    WriteINIStr "${OutPath}\${FileName}" "Overlay.fx" "AspectRatio" "9.000000,16.000000"
    WriteINIStr "${OutPath}\${FileName}" "Overlay.fx" "bKeepAspectRatio" "1"
    ${ConfigRead} "${OutPath}\${FileName}" "PreprocessorDefinitions=" $3
    ${ConfigWrite} "${OutPath}\${FileName}" "PreprocessorDefinitions=" "$3,OVERLAY_WIDTH=BUFFER_WIDTH/0.5625" $3

    !insertmacro ToLog $LOGFILE "Output" "Added preset ${FileName} with Priority ${Priority}."
    StrCmp $PresetPriority "" 0 +2
    StrCpy $PresetPriority ${Priority}
    IntCmp ${Priority} $PresetPriority 0 0 +4
    !insertmacro ToLog $LOGFILE "Output" "Setting default preset path to ${FileName}."
    !insertmacro IniPrint "${RESHADEINI}" "GENERAL" "PresetPath" $2
    StrCpy $PresetPriority ${Priority}
!macroend