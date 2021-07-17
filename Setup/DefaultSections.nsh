!include AddPreset.nsh

!macro PresetFiles SourcePath OutPath
    SectionGroup /e Preset
        Section "High Quality" High
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade High.ini"
        SectionEnd
        Section "Low Quality" Low
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade Low.ini"
        SectionEnd
        Section "Medium Quality" Medium
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade Medium.ini"
        SectionEnd
    SectionGroupEnd

    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${High} "GPU: NVIDIA RTX 2070 / AMD RX 5700 XT$\nCPU: AMD Ryzen 5 3600 / Intel Core i5 9600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Medium} "GPU: NVIDIA GTX 1050 Ti / AMD RX 570$\nCPU: AMD Ryzen 5 2600 / Intel Core i5 8600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Low} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
!macroend