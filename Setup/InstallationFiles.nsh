# Dependencies
!include MUI2.nsh
!include LogicLib.nsh
!include FileFunc.nsh
!include ErrorHandling.nsh
!include "Util\GetSectionNames.nsh"
!include "Util\Explode.nsh"
!include "Util\ConfigRead.nsh"
!include "Util\StrContains.nsh"
!insertmacro Locate

!macro RequiredFiles SourcePath OutPath
    SectionGroup Required
        Section "Roshade"
            SectionIn 1 RO

            CreateDirectory "${OutPath}\roshade"

            SetOutPath $INSTDIR
            CreateDirectory ${PRESETFOLDER}
            File "Graphics\AppIcon.ico"
            WriteUninstaller "${UninstallerExe}"

            CreateDirectory "$SMPROGRAMS\${NAME}"
            CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall ${NAME}.lnk" "$INSTDIR\${UninstallerExe}" "" "${APPICON}"

            CreateDirectory "$PICTURES\${NAME}"

            ReadRegStr $1 HKCU "${ROBLOXREGLOC}" "curPlayerVer"
            !insertmacro RegStrPrint "${SELFREGLOC}" "RobloxVersion" $1
            !insertmacro RegStrPrint "${SELFREGLOC}" "Version" "${VERSION}"
            !insertmacro RegStrPrint "${SELFREGLOC}" "RobloxPath" $RobloxPath
            !insertmacro RegStrPrint "${SELFREGLOC}" "DisplayName" '"${NAME} - ${MANUFACTURER}"'
            !insertmacro RegStrPrint "${SELFREGLOC}" "UninstallString" '"$INSTDIR\${UninstallerExe}"'
            !insertmacro RegStrPrint "${SELFREGLOC}" "DisplayIcon" '"${APPICON}"'
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

            delete "$RobloxPath\opengl32.dll"
            delete "$RobloxPath\d3d9.dll"
            delete "$RobloxPath\dxgi.dll"

            SetOutPath "${OutPath}"
            File "${SourcePath}\reshade.dll"
            Rename "$RobloxPath\reshade.dll" "$RobloxPath\${RENDERAPI}"

            CreateDirectory ${TEMPFOLDER}

            StrCpy $ShaderDir "${OutPath}reshade-shaders"
            CreateDirectory $ShaderDir
            SetOutPath $TEMP
            ${Explode} $2 "," $Repositories
            ${For} $3 1 $2
                pop $0
                ${Explode} $0 "@" $0
                Call InstallShadersAsync
            ${Next}
            StrCmp $LauncherTransferID "" +3
            NScurl::wait /ID $LauncherTransferID /END
            ExecWait "$PLUGINSDIR\RobloxPlayerLauncher.exe"
            NScurl::wait /TAG "Shader" /END
            FindFirst $0 $1 "${TEMPFOLDER}\*.zip"
            !define SHADERID ${__LINE__}
            loop_${SHADERID}:
                StrCmp $1 "" done_${SHADERID}
                !insertmacro Unzip $1
                FindNext $0 $1
                GoTo loop_${SHADERID}
            done_${SHADERID}:
            !undef SHADERID
            FindClose $0

            RMDir /r ${TEMPFOLDER}
            RMDir /r ${PRESETTEMPFOLDER}

            SetOutPath "${OutPath}\roshade"
            File /r "..\Files\Roshade\*"

            ${If} ${FileExists} "$RobloxPath\Reshade.ini"
                ReadINIStr $0 "$RobloxPath\Reshade.ini" "INPUT" "KeyEffects"
                ReadINIStr $1 "$RobloxPath\Reshade.ini" "INPUT" "KeyOverlay"
                ${IfNot} $0 == $KeyEffects
                ${OrIfNot} $1 == $KeyOverlay
                push $1
                push $0
                Call SettingsExistingError
                ${EndIf}
            ${EndIf}
            
            !insertmacro IniPrint "${RESHADEINI}" "SCREENSHOT" "SavePath" "$PICTURES\${NAME}"

            !insertmacro MoveFile "$PLUGINSDIR\Reshade.ini" "$RobloxPath\Reshade.ini"
        SectionEnd
    SectionGroupEnd
!macroend

!macro MoveShaderFiles SourceName Destination Search
    !insertmacro MoveFolder "${TEMPFOLDER}\${SourceName}\Shaders\${Search}" "${Destination}\Shaders" "*.fx"
    !insertmacro MoveFolder "${TEMPFOLDER}\${SourceName}\Shaders\${Search}" "${Destination}\Shaders" "*.fxh"
    !insertmacro MoveFolder "${TEMPFOLDER}\${SourceName}\Textures\${Search}" "${Destination}\Textures" "*"
!macroend

!macro InstallToTemp SourcePath ZipName
    SetOutPath $TEMP
!macroend

!macro Unzip ZipName
    !define ID ${__LINE__}
    start_${ID}:
    nsisunz::UnzipToStack "${TEMPFOLDER}\${ZipName}" ${TEMPFOLDER}
    Pop $R0
    StrCmp $R0 "success" +5
    StrCpy $R2 "$R0: ${ZipName}"
    DetailPrint $R2
    MessageBox MB_ABORTRETRYIGNORE|MB_ICONEXCLAMATION $R2 IDIGNORE end_${ID} IDRETRY start_${ID}
        Abort

    Pop $R1
    ${Explode} $R1 "\" $R1
    pop $R1
    ${Explode} $R2 "." ${ZipName}
    pop $R2
    ReadINIStr $R3 ${SHADERSINI} $R2 "search"
    !insertmacro MoveShaderFiles $R1 $ShaderDir $R3
    end_${ID}:
    Delete "${TEMPFOLDER}\${ZipName}"
    !undef ID
!macroend

Function InstallShadersAsync
    pop $R7
    pop $R1
    ReadINIStr $R0 ${SHADERSINI} $R7 "alwaysinstall"
    StrCmp $R0 "" 0 install
    ReadINIStr $R0 ${SHADERSINI} $R7 "techniques"
    ${Explode} $R2 "," $R0
    StrCpy $R6 ""
    ${For} $R3 1 $R2
        pop $R4
        ${StrContains} $R5 $R4 $Techniques
        StrCmp $R5 "" +2
        StrCpy $R6 $R5
    ${Next}
    StrCmp $R6 "" skip
    install:
    ReadINIStr $R0 ${SHADERSINI} $R7 "branch"
    StrCmp $R0 "" 0 +2
    StrCpy $R0 "master"
    NScurl::http GET "https://github.com/$R1/archive/refs/heads/$R0.zip" "${TEMPFOLDER}/$R7.zip" /BACKGROUND /TAG "Shader" /END
    DetailPrint "Installing $R7.zip"
    pop $R2
    skip:
FunctionEnd