Unicode true

!include Attributes.nsh
!include LogicLib.nsh
!include ModernUI.nsh
!include ErrorHandling.nsh
!include FileFunc.nsh
!insertmacro Locate
!include InstallationFiles.nsh
!addplugindir "Plugins" 
InstallDir "$LOCALAPPDATA\Roshade"

!define PRESETFOLDER "$INSTDIR\presets"

!insertmacro RequiredFiles "..\Files\Reshade" $RobloxPath
!insertmacro PresetFiles "..\Files\Preset" ${PRESETFOLDER}

var LauncherPath

Section "Uninstall"
    var /GLOBAL RobloxDir
    ReadRegStr $RobloxDir HKCU "${SELFREGLOC}" "RobloxPath"

    RMDir /r $INSTDIR
    DeleteRegKey HKCU "${SELFREGLOC}"
    !insertmacro RegDelPrint ${SELFREGLOC}

    Delete "$RobloxDir\RoShade High.ini"
    Delete "$RobloxDir\RoShade Medium.ini"
    Delete "$RobloxDir\RoShade Low.ini"

    Delete "$RobloxDir\dxgi.dll"
    Delete "$RobloxDir\Reshade.ini"
    Delete "$RobloxDir\FiraCode-VariableFont_wght.ttf"
    Delete "$RobloxDir\OpenSans-SemiBold.ttf"

    RMDir /r "$RobloxDir\reshade-shaders"
SectionEnd

Function un.onInit
    MessageBox MB_YESNO|MB_ICONQUESTION "This will uninstall Reshade and the Roshade preset. Are you sure you want to continue?" IDYES continue
        quit
    continue:
FunctionEnd

Function .onInit
    ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=RobloxPlayerLauncher.exe" "RobloxInProgramFiles"
    ${if} ${Errors}
        ReadRegStr $0 HKCU "${ROBLOXREGLOC}" ""
        ${ifnot} ${FileExists} $0
            call RobloxNotFoundError
        ${endif}
    ${else}
        push $LauncherPath
        call RobloxInProgramFilesError
    ${endif}
    ReadRegStr $0 HKCU "${SELFREGLOC}" "RobloxPath"
    nsProcess::_FindProcess "RobloxPlayerBeta.exe"
    pop $R0
    ${if} $R0 == 0
    ${andifnot} $0 == ""
        Call RobloxRunningError
    ${endif}

    SectionSetSize ${ReshadeSection} 36860
FunctionEnd

Function "RobloxInProgramFiles"
    StrCpy $RobloxPath $R8
    StrCpy $LauncherPath $R9
    StrCpy $0 StopLocate
    Push $0
FunctionEnd