# Dependencies
!include MUI2.nsh
!include LogicLib.nsh
!include FileFunc.nsh
!include DetailPrints.nsh
!include "Util\MoveFileFolder.nsh"
!include "Util\GetSectionNames.nsh"
!include "Util\Explode.nsh"
!insertmacro Locate

# Definitions
var RobloxPath
var ShaderDir

!macro PresetFiles SourcePath OutPath
    var FileName
    SectionGroup /e Preset
        Section "High Quality" High
            StrCpy $FileName "RoShade High.ini"
            StrCpy $2 "${OutPath}\$FileName"

            SectionIn 1
            SetOutPath "${OutPath}"
            File "${SourcePath}\RoShade High.ini"

            !insertmacro IniPrint "$RobloxPath\Reshade.ini" "GENERAL" "PresetPath" $2
        SectionEnd
        Section "Low Quality" Low
            StrCpy $FileName "RoShade Low.ini"
            StrCpy $2 "${OutPath}\$FileName"

            SectionIn 1
            SetOutPath "${OutPath}"
            File "${SourcePath}\RoShade Low.ini"

            !insertmacro IniPrint "$RobloxPath\Reshade.ini" "GENERAL" "PresetPath" $2
        SectionEnd
        Section "Medium Quality" Medium
            StrCpy $FileName "RoShade Medium.ini"
            StrCpy $2 "${OutPath}\$FileName"

            SectionIn 1
            SetOutPath "${OutPath}"
            File "${SourcePath}\RoShade Medium.ini"

            !insertmacro IniPrint "$RobloxPath\Reshade.ini" "GENERAL" "PresetPath" $2
        SectionEnd
    SectionGroupEnd

    !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${High} "GPU: NVIDIA RTX 2070 / AMD RX 5700 XT$\nCPU: AMD Ryzen 5 3600 / Intel Core i5 9600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Medium} "GPU: NVIDIA GTX 1050 Ti / AMD RX 570$\nCPU: AMD Ryzen 5 2600 / Intel Core i5 8600k"
        !insertmacro MUI_DESCRIPTION_TEXT ${Low} "GPU: NVIDIA GTX 970 / AMD 390$\nCPU: AMD Ryzen 5 1600 / Intel Core i7-4770k"
    !insertmacro MUI_FUNCTION_DESCRIPTION_END
!macroend

!macro RequiredFiles SourcePath OutPath
    SectionGroup Required
        Section "Roshade"
            SectionIn 1 RO

            CreateDirectory "${OutPath}\roshade"

            SetOutPath $INSTDIR
            CreateDirectory "$INSTDIR\presets"
            File "Graphics\AppIcon.ico"
            WriteUninstaller "${UninstallerExe}"

            CreateDirectory "$SMPROGRAMS\${NAME}"
            CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall ${NAME}.lnk" "$INSTDIR\${UninstallerExe}" "" "$INSTDIR\AppIcon.ico"

            CreateDirectory "$PICTURES\${NAME}"

            ReadRegStr $1 HKCU "${ROBLOXREGLOC}" "curPlayerVer"
            !insertmacro RegStrPrint "${SELFREGLOC}" "RobloxVersion" $1
            !insertmacro RegStrPrint "${SELFREGLOC}" "Version" "${VERSION}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "RobloxPath" $RobloxPath
            !insertmacro RegStrPrint "${SELFREGLOC}" "DisplayName" '"${NAME} - ${MANUFACTURER}"'
            !insertmacro RegStrPrint "${SELFREGLOC}" "UninstallString" '"$INSTDIR\${UninstallerExe}"'
            !insertmacro RegStrPrint "${SELFREGLOC}" "DisplayIcon" '"$INSTDIR\$0"'
            !insertmacro RegStrPrint "${SELFREGLOC}" "Publisher" "${MANUFACTURER}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "HelpLink" "${HELPLINK}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "URLInfoAbout" "${ABOUTLINK}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "URLUpdateInfo" "${UPDATELINK}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "DisplayVersion" "${VERSION}"
            WriteRegDWORD HKCU "${SELFREGLOC}" "NoModify" 1
            WriteRegDWORD HKCU "${SELFREGLOC}" "NoRepair" 1
        SectionEnd
        Section "Reshade" ReshadeSection
            SectionIn 1 RO

            SetOutPath "${OutPath}"
            File /r "${SourcePath}\*"

            !insertmacro IniPrint "${OutPath}\Reshade.ini" "INPUT" "KeyEffects" $KeyEffects
            !insertmacro IniPrint "${OutPath}\Reshade.ini" "INPUT" "KeyOverlay" $KeyOverlay
            !insertmacro IniPrint "${OutPath}\Reshade.ini" "SCREENSHOT" "SavePath" "$PICTURES\Roshade"

            CreateDirectory "$TEMP\Zeal"

            StrCpy $ShaderDir "${OutPath}reshade-shaders"
            CreateDirectory $ShaderDir

            SetOutPath $TEMP

            ${GetSectionNames} "$PLUGINSDIR\Shaders.ini" InstallShadersAsync
            StrCmp $LauncherTransferID "" +3
            NScurl::wait /ID $LauncherTransferID /END
            ExecWait "$PLUGINSDIR\RobloxPlayerLauncher.exe"
            NScurl::wait /TAG "Shader" /END
            FindFirst $0 $1 "$TEMP\Zeal\*.zip"
            loop:
                StrCmp $1 "" done
                !insertmacro Unzip $1
                FindNext $0 $1
                GoTo loop
            done:
            FindClose $0

            RMDir /r "$TEMP\Zeal"

            SetOutPath "${OutPath}\roshade"
            File /r "..\Files\Roshade\*"

            delete "$RobloxPath\opengl32.dll"
            delete "$RobloxPath\d3d9.dll"


        SectionEnd
    SectionGroupEnd
!macroend

!macro MoveShaderFiles SourceName Destination
    !insertmacro MoveFolder "$TEMP\Zeal\${SourceName}\Shaders" "${Destination}\Shaders" "*.fx"
    !insertmacro MoveFolder "$TEMP\Zeal\${SourceName}\Shaders" "${Destination}\Shaders" "*.fxh"
    !insertmacro MoveFolder "$TEMP\Zeal\${SourceName}\Textures" "${Destination}\Textures" "*"
!macroend

!macro InstallToTemp SourcePath ZipName
    SetOutPath $TEMP
!macroend

!macro Unzip ZipName
    !define ID {__LINE__}
    start_${ID}:
    nsisunz::UnzipToStack "$TEMP\Zeal\${ZipName}" "$TEMP\Zeal"
    Pop $R0
    StrCmp $R0 "success" +5
    StrCpy $R2 "$R0: ${ZipName}"
    DetailPrint $R2
    MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION $R2 IDIGNORE end_${ID} IDRETRY start_${ID}
        Abort

    Pop $R1
    ${Explode} $R1 "\" $R1
    pop $R1
    !insertmacro MoveShaderFiles $R1 $ShaderDir
    end_${ID}:
    Delete "$TEMP\Zeal\${ZipName}"
    !undef ID
!macroend

Function InstallShadersAsync
    ReadINIStr $R1 $0 $9 "repo"
    StrCmp $R1 "" +2 0
    NScurl::http GET "https://github.com/$R1/archive/refs/heads/master.zip" "$TEMP/Zeal/$9.zip" /BACKGROUND /TAG "Shader" /END
FunctionEnd