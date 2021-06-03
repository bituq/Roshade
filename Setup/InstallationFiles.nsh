!include MUI2.nsh
!include LogicLib.nsh
!include FileFunc.nsh
!include DetailPrints.nsh
!insertmacro Locate
var switch_overwrite
!include MoveFileFolder.nsh

Var RobloxPath

!macro WriteRegKeys
    ReadRegStr $1 HKCU "${ROBLOXREGLOC}" "curPlayerVer"
    WriteRegStr HKCU "${SELFREGLOC}" "RobloxVersion" $1
    !insertmacro RegPrint "RobloxVersion" $1

    WriteRegStr HKCU "${SELFREGLOC}" "Version" "${VERSION}"
    !insertmacro RegPrint "Version" "${VERSION}"
    
    ReadRegStr $RobloxPath HKCU "${ROBLOXUNINSTALLREGLOC}" "InstallLocation"
    ${if} $RobloxPath == ""
        call RobloxNotFoundError
    ${EndIf}

    WriteRegStr HKCU "${SELFREGLOC}" "RobloxPath" $RobloxPath
    !insertmacro RegPrint "RobloxPath" $RobloxPath
!macroend

!macro PresetFiles SourcePath OutPath
    SectionGroup /e Preset
        Section "Ultra Quality" Ultra
            SectionIn 1
            SetOutPath "${OutPath}"
            File "${SourcePath}\RoShade Ultra.ini"
        SectionEnd
        Section "High Quality" High
            SectionIn 1
            File "${SourcePath}\RoShade High.ini"
        SectionEnd
        Section "Medium Quality" Medium
            SectionIn 1
            File "${SourcePath}\RoShade Medium.ini"
        SectionEnd
        Section "Low Quality" Low
            SectionIn 1
            File "${SourcePath}\RoShade Low.ini"
        SectionEnd
    SectionGroupEnd

    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${Ultra} "GPU: NVIDIA RTX 3060 / AMD RX 6700 XT$\nCPU: AMD Ryzen 5 3600x / Intel Core i7 10700k"
        !insertmacro MUI_DESCRIPTION_TEXT ${High} "GPU: NVIDIA RTX 2060 / AMD RX 5700 XT$\nCPU: AMD Ryzen 5 3600 / Intel Core i5 9600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Medium} "GPU: NVIDIA GTX 1050 Ti / AMD RX 570$\nCPU: AMD Ryzen 5 2600 / Intel Core i5 8600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Low} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
!macroend

!macro RequiredFiles SourcePath OutPath
    SectionGroup Required
        Section "Roshade"
            SectionIn 1 RO

            SetOutPath $INSTDIR

            !insertmacro WriteRegKeys

            WriteUninstaller "${UninstallerExe}"

            CreateDirectory "$PICTURES\Roshade"
        SectionEnd
        Section "Reshade" ReshadeSection
            SectionIn 1 RO

            SetOutPath "${OutPath}"

            File "${SourcePath}\dxgi.dll"
            File "${SourcePath}\Reshade.ini"
            File "${SourcePath}\FiraCode-VariableFont_wght.ttf"
            File "${SourcePath}\OpenSans-SemiBold.ttf"

            WriteINIStr "${OutPath}\Reshade.ini" "INPUT" "KeyEffects" $KeyEffects
            !insertmacro IniPrint "INPUT" "KeyEffects" $KeyEffects
            WriteINIStr "${OutPath}\Reshade.ini" "INPUT" "KeyOverlay" $KeyOverlay
            !insertmacro IniPrint "INPUT" "KeyOverlay" $KeyOverlay
            WriteINIStr "${OutPath}\Reshade.ini" "SCREENSHOT" "SavePath" "$PICTURES\Roshade"
            !insertmacro IniPrint "SCREENSHOT" "SavePath" "$PICTURES\Roshade"

            var /GLOBAL CancelQuestion

            var /GLOBAL TempDir
            StrCpy $TempDir "$TEMP\Zeal"
            CreateDirectory $TempDir

            var /GLOBAL ShaderDir
            StrCpy $ShaderDir "${OutPath}\reshade-shaders"
            CreateDirectory $ShaderDir

            StrCpy $switch_overwrite 0

            !insertmacro InstallToTemp "https://github.com/prod80/prod80-ReShade-Repository/archive/refs/heads/master.zip" "prod80-master.zip"
            !insertmacro InstallToTemp "https://github.com/crosire/reshade-shaders/archive/refs/heads/master.zip" "reshade-shaders-master.zip"
            !insertmacro InstallToTemp "https://github.com/martymcmodding/qUINT/archive/refs/heads/master.zip" "quint-master.zip"
            !insertmacro InstallToTemp "https://github.com/BlueSkyDefender/AstrayFX/archive/refs/heads/master.zip" "astrayfx-master.zip"
            !insertmacro InstallToTemp "https://github.com/JJXB/RS-Shaders/archive/refs/heads/master.zip" "rs-shaders-master.zip"
            !insertmacro InstallToTemp "https://github.com/luluco250/FXShaders/archive/refs/heads/master.zip" "FXShaders-master.zip"
            
            !insertmacro MoveShaderFiles "prod80-ReShade-Repository-master" $ShaderDir
            !insertmacro MoveShaderFiles "reshade-shaders-master" $ShaderDir
            !insertmacro MoveShaderFiles "quint-master" $ShaderDir
            !insertmacro MoveShaderFiles "astrayfx-master" $ShaderDir
            !insertmacro MoveShaderFiles "rs-shaders-master" $ShaderDir
            !insertmacro MoveShaderFiles "FXShaders-master" $ShaderDir

            RMDir /r $TempDir
        SectionEnd
    SectionGroupEnd
!macroend

!macro MoveShaderFiles SourceName Destination
    !insertmacro MoveFolder "$TempDir\${SourceName}\Shaders\" "${Destination}\Shaders" "*.fx"
    !insertmacro MoveFolder "$TempDir\${SourceName}\Shaders\" "${Destination}\Shaders" "*.fxh"
    !insertmacro MoveFolder "$TempDir\${SourceName}\Textures\" "${Destination}\Textures" "*"
!macroend

!macro InstallToTemp SourcePath ZipName
    !define ID ${__LINE__}
    SetOutPath $TEMP

    start_${ID}:
    StrCpy $CancelQuestion "Cancel installing ${ZipName}? This is not recommended."

    inetc::get /QUESTION $CancelQuestion ${SourcePath} ${ZipName}

    nsisunz::UnzipToLog ${ZipName} $TempDir

    Delete ${ZipName}

    Pop $0
    StrCmp $0 "success" end_${ID}
        DetailPrint $0
        MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION "$0: ${ZipName}" IDIGNORE end_${ID} IDRETRY start_${ID}
            Abort
    end_${ID}:
    !undef ID
!macroend