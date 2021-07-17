!macro AddPreset SourcePath OutPath FileName
    StrCpy $2 "${PRESETFOLDER}\${FileName}"

    SectionIn 1
    SetOutPath "${OutPath}"
    File "${SourcePath}\${FileName}"

    ${ConfigRead} "${OutPath}\${FileName}" "techniques=" $0
    StrCpy $Techniques "$Techniques$0,"

    !insertmacro IniPrint "$PLUGINSDIR\Reshade.ini" "GENERAL" "PresetPath" $2
!macroend