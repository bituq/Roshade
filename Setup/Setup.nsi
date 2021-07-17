Unicode true

!include Attributes.nsh
!include ModernUI.nsh
!include InstallationFiles.nsh
!include "DefaultSections.nsh"

# Uninstallation
Section Uninstall
    ReadRegStr $0 HKCU "${SELFREGLOC}" "RobloxPath"
    DeleteRegKey HKCU "${SELFREGLOC}"
    Delete "$INSTDIR\AppIcon.ico"
    Delete "$INSTDIR\Uninstall Roshade.exe"
    Delete "$0\${RENDERAPI}"
    Delete "$0\Reshade.ini"
    RMDir /r "$0\reshade-shaders"
    RMDir /r "$0\roshade"
SectionEnd

Function un.onInit
    MessageBox MB_YESNO|MB_ICONQUESTION "This will uninstall Reshade from your Roblox directory. Are you sure you want to continue?" IDYES continue
        quit
    continue:
FunctionEnd

# Installation
!insertmacro PresetFiles ${PRESETSOURCE} ${PRESETFOLDER}
!insertmacro RequiredFiles ${RESHADESOURCE} $RobloxPath

Function .onInit
    InitPluginsDir
    SetOutPath $PLUGINSDIR
    File "Graphics\Roshade.gif"
    File "Shaders.ini"
    File "${RESHADESOURCE}\Reshade.ini"

    CreateDirectory ${PRESETTEMPFOLDER}
    newadvsplash::show /NOUNLOAD 1000 300 0 -2 /PASSIVE /BANNER /NOCANCEL ${SPLASHICON}

    !define searchKey "RobloxPlayerLauncher.exe"
    ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=${searchKey}" "RobloxInProgramFiles"

    ReadRegStr $RobloxPath HKCU "${ROBLOXUNINSTALLREGLOC}" "InstallLocation"
    ${IfNot} ${FileExists} "$RobloxPath\${searchKey}"
        call RobloxNotFoundError
    ${EndIf}

    ReadRegStr $R0 HKCU ${SELFREGLOC} "Version"
    ${GetSectionNames} ${SHADERSINI} DefineRepositories

    StrCpy $Techniques ""
    FindFirst $0 $1 "${PRESETTEMPFOLDER}\*.ini"
    !define PRESETID ${__LINE__}
    loop_${PRESETID}:
        StrCmp $1 "" done_${PRESETID}
        ${ConfigRead} $1 "techniques" $2
        StrCpy $Techniques "$Techniques$2,"
        Delete "${PRESETFOLDER}\$1"
        Rename "${PRESETTEMPFOLDER}\$1" "${PRESETFOLDER}\$1" 
        FindNext $0 $1
        GoTo loop_${PRESETID}
    done_${PRESETID}:
    !undef PRESETID
    FindClose $0

    nsProcess::_FindProcess "RobloxPlayerBeta.exe"
    pop $R0
    StrCmp $R0 0 0 +2
    Call RobloxRunningError
    SectionSetSize ${ReshadeSection} 36860
    newadvsplash::stop /WAIT
FunctionEnd

Function RobloxInProgramFiles
    StrCpy $0 StopLocate
    push $0
    push $R9
    call RobloxInProgramFilesError
FunctionEnd

Function DefineRepositories
    ReadINIStr $R1 $0 $9 "repo"
    StrCmp $R1 "" skip 0
    StrCpy $R7 "$TEMP\$9-techniques.json"
    ${If} ${FileExists} $R7
    ${AndIf} $R0 == ${VERSION}
        Goto installed
    ${EndIf}

    ReadINIStr $R2 $0 $9 "search"
    NScurl::http GET "https://api.github.com/repos/$R1/contents/Shaders/$R2" $R7 /END
    pop $R2
    StrCmp $R2 "403 $\"Forbidden$\"" 0 +3
    WriteINIStr $0 $9 "alwaysinstall" "true"
    GoTo loopend
    StrCmp $R2 "OK" 0 skip

    installed:
    nsJSON::Set /tree $R1 /file $R7
    nsJSON::Get /tree $R1 /count /end
    pop $R2
    StrCpy $R3 -1
    StrCpy $R4 ""
    StrCpy $R5 ""
    loop:
        StrCmp $R3 $R2 loopend
        nsJSON::Get /tree $R1 /index $R3 "name"
        pop $R4
        StrCmp $R4 "" loop
        StrCpy $R5 "$R5$R4,"
        IntOp $R3 $R3 + 1
        Goto loop
    loopend:
    ReadINIStr $R6 $0 $9 "alwaysinstall"
    StrCmp $R6 "true" +2
    WriteINIStr $0 $9 "techniques" $R5
    StrCpy $Repositories "$Repositories$9@$R1,"
    skip:
    Push $0
FunctionEnd