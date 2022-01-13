# Dependencies
!include MUI2.nsh
!include LogicLib.nsh
!include FileFunc.nsh
!include ErrorHandling.nsh
!include "Util\GetSectionNames.nsh"
!include "Util\StrContains.nsh"
!include "Util\DumpLog.nsh"
!insertmacro Locate

!macro RequiredFiles SourcePath OutPath
    SectionGroup "-Required"
        Section "-Roshade"
            SectionIn 1 RO

            SetOutPath $INSTDIR
            CreateDirectory ${PRESETFOLDER}
            File "Graphics\AppIcon.ico"
            WriteUninstaller "${UninstallerExe}"

            CreateDirectory "$SMPROGRAMS\${NAME}"
            CreateShortCut "$SMPROGRAMS\${NAME}\Uninstall ${NAME}.lnk" "$INSTDIR\${UninstallerExe}" "" "${APPICON}"

            CreateDirectory "$PICTURES\${NAME}"
        SectionEnd
        Section "-Reshade" ReshadeSection
            SectionIn 1 RO

            CreateDirectory ${TEMPFOLDER}

            SetOutPath $TEMP
            ${Explode} $2 "," $Repositories
            ${For} $3 1 $2
                pop $0
                ${Explode} $0 "@" $0
                Call InstallShadersAsync
            ${Next}

            StrCmp $LauncherTransferID "" +4
            NScurl::wait /ID $LauncherTransferID /END
            !insertmacro ToLog $LOGFILE "NScurl" "Transfer with ID $LauncherTransferID has completed. Executing RobloxPlayerLauncher.exe."
            ExecWait "$PLUGINSDIR\RobloxPlayerLauncher.exe"

            StrCpy $ShaderDir "$RobloxPath\reshade-shaders"
            CreateDirectory $ShaderDir

            FindFirst $0 $1 "${PRESETTEMPFOLDER}\*.ini"
            !define PRESETID ${__LINE__}
            loop_${PRESETID}:
                StrCmp $1 "" done_${PRESETID}
                Delete "${PRESETFOLDER}\$1"
                Rename "${PRESETTEMPFOLDER}\$1" "${PRESETFOLDER}\$1"
                !insertmacro ToLog $LOGFILE "Output" "Moving $1 to ${PRESETFOLDER}."
                FindNext $0 $1
                GoTo loop_${PRESETID}
            done_${PRESETID}:
            !undef PRESETID
            FindClose $0
            RMDir /r ${PRESETTEMPFOLDER}
            RMDir /r "$RobloxPath\roshade"

            CreateDirectory "$RobloxPath\roshade"
            SetOutPath "$RobloxPath\roshade"
            File /r "..\Files\Roshade\*"

            delete "$RobloxPath\opengl32.dll"
            delete "$RobloxPath\d3d9.dll"
            delete "$RobloxPath\dxgi.dll"

            SetOutPath $RobloxPath
            File "${SourcePath}\reshade.dll"
            !insertmacro ToLog $LOGFILE "Output" "Rendering API: ${RENDERAPI}."
            Rename "$RobloxPath\reshade.dll" "$RobloxPath\${RENDERAPI}"

            ${If} ${FileExists} "$RobloxPath\Reshade.ini"
                !insertmacro ToLog $LOGFILE "Output" "Existing Reshade settings have been found."
                ReadINIStr $0 "$RobloxPath\Reshade.ini" "INPUT" "KeyEffects"
                ReadINIStr $1 "$RobloxPath\Reshade.ini" "INPUT" "KeyOverlay"
                ${IfNot} $0 == $KeyEffects
                ${OrIfNot} $1 == $KeyOverlay
                push $1
                push $0
                Call SettingsExistingError
                ${Else}
                !insertmacro ToLog $LOGFILE "Output" "Existing settings match the chosen settings."
                ${EndIf}
            ${Else}
                !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyEffects" $KeyEffects
                !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyOverlay" $KeyOverlay
            ${EndIf}
            
            !insertmacro IniPrint "${RESHADEINI}" "SCREENSHOT" "SavePath" "$PICTURES\${NAME}"
            !insertmacro ToLog $LOGFILE "Output" "Screenshot path set to $PICTURES\${NAME}."

            Delete "$RobloxPath\Reshade.ini"

            !insertmacro MoveFile "$PLUGINSDIR\Reshade.ini" "$RobloxPath\Reshade.ini"

            AccessControl::GrantOnFile "$RobloxPath\Reshade.ini" "Everyone" "FullAccess"
            AccessControl::GrantOnFile "$RobloxPath\Reshade.ini" "SYSTEM" "FullAccess"
            AccessControl::GrantOnFile "$RobloxPath\Reshade.ini" "Users" "FullAccess"

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

            SetOutPath "$RobloxPath\reshade-shaders\Textures"
            File /r "..\Files\Textures\*"
        SectionEnd
    SectionGroupEnd
!macroend

!macro MoveShaderFiles SourceName Destination Search
    !insertmacro ToLog $LOGFILE "Output" "Moving contents of ${TEMPFOLDER}\${SourceName} to ${Destination}"
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
    StrCpy $R2 "$R0: ${ZipName}"
    !insertmacro ToLog $LOGFILE "nsisunz" "Unzipping ${ZipName} with response: $R0."
    StrCmp $R0 "success" +3
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
    StrCpy $Techniques ""
    StrCpy $R6 ""
    FindFirst $R8 $R9 "${PRESETTEMPFOLDER}\*.ini"
    !define PRESETID ${__LINE__}
    loop_${PRESETID}:
        StrCmp $R9 "" done_${PRESETID}
        ${ConfigRead} "${PRESETTEMPFOLDER}\$R9" "Techniques=" $Techniques
        ${Explode} $R2 "," $Techniques
        ${For} $R3 1 $R2
            pop $R4
            ${Explode} $R5 "@" $R4
            IntCmp $R5 2 0 +7
            pop $R4
            pop $R4
            StrCpy $R5 ""
            ${StrContains} $R5 $R4 $R0
            StrCmp $R5 "" +4
            StrCmp $R6 "" 0 +3
            StrCpy $R6 $R5
            !insertmacro ToLog $LOGFILE "Output" "$R6 ($R7) found in $R9."
        ${Next}
        FindNext $R8 $R9
        GoTo loop_${PRESETID}
    done_${PRESETID}:
    !undef PRESETID
    FindClose $R8
    StrCmp $R6 "" skip
    install:
    ReadINIStr $R0 ${SHADERSINI} $R7 "branch"
    StrCmp $R0 "" 0 +2
    StrCpy $R0 "master"
    NScurl::http GET "https://github.com/$R1/archive/refs/heads/$R0.zip" "${TEMPFOLDER}/$R7.zip" /BACKGROUND /TAG "Shader" /END
    pop $R2
    !insertmacro ToLog $LOGFILE "NScurl" "Adding installation of $R1 to a background thread. ($R2)"
    DetailPrint "$R1 GET"
    skip:
FunctionEnd