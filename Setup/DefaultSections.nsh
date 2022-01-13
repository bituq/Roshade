!include AddPreset.nsh

!macro PresetFiles SourcePath OutPath
    SectionGroup /e "Base Presets"
        Section "High Quality" High
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade High.ini" 2
        SectionEnd
        Section "Low Quality" Low
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade Low.ini" 1
        SectionEnd
        Section "Medium Quality" Medium
            !insertmacro AddPreset ${SourcePath} ${OutPath} "RoShade Medium.ini" 0
        SectionEnd
    SectionGroupEnd
    SectionGroup /e "Zeal's Reshade Presets (old)"
        Section "Ultra" OldUltra
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Zeal's ReShade-Preset Ultra.ini" 6
        SectionEnd
        Section "High" OldHigh
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Zeal's ReShade-Preset High.ini" 7
        SectionEnd
        Section "Medium" OldMedium
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Zeal's ReShade-Preset Medium.ini" 8
        SectionEnd
        Section "Low" OldLow
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Zeal's ReShade-Preset Low.ini" 9
        SectionEnd
    SectionGroupEnd
    SectionGroup /e "Reflection Presets"
        Section "Glossy" Glossy
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Glossy.ini" 3
        SectionEnd
        Section "Very Glossy" VeryGlossy
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Very Glossy.ini" 4
        SectionEnd
    SectionGroupEnd
    SectionGroup /e "Weather Presets"
        Section "Snow" Snow
            !insertmacro AddPreset ${SourcePath} ${OutPath} "Snow.ini" 5
        SectionEnd
    SectionGroupEnd

    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${High} "GPU: NVIDIA RTX 2070 / AMD RX 5700 XT$\nCPU: AMD Ryzen 5 3600 / Intel Core i5 9600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Medium} "GPU: NVIDIA GTX 1050 Ti / AMD RX 570$\nCPU: AMD Ryzen 5 2600 / Intel Core i5 8600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Low} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Glossy} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
        !insertmacro MUI_DESCRIPTION_TEXT ${VeryGlossy} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Snow} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
!macroend