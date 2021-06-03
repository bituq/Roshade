Unicode true

!include Attributes.nsh
!include LogicLib.nsh
!include ModernUI.nsh
!include ErrorHandling.nsh
!include InstallationFiles.nsh
InstallDir "$PROGRAMFILES\Roshade"

!define ROBLOXREGLOC "SOFTWARE\ROBLOX Corporation\Environments\roblox-player"
!define ROBLOXUNINSTALLREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\roblox-player"
!define SELFREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Roshade"
!define UninstallerExe "Uninstall Roshade.exe"

!insertmacro RequiredFiles "..\Files\Reshade" $RobloxPath
!insertmacro PresetFiles "..\Files\Preset" $RobloxPath

Section "Uninstall"
    var /GLOBAL RobloxDir
    ReadRegStr $RobloxDir HKCU "${SELFREGLOC}" "RobloxPath"

    RMDir /r $INSTDIR
    DeleteRegKey HKCU "${SELFREGLOC}"
    !insertmacro RegDelPrint ${SELFREGLOC}

    Delete "$RobloxDir\RoShade High.ini"
    Delete "$RobloxDir\RoShade Medium.ini"
    Delete "$RobloxDir\RoShade Low.ini"
    Delete "$RobloxDir\RoShade Ultra.ini"

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
    ReadRegStr $0 HKCU "${ROBLOXREGLOC}" ""
    ${ifnot} ${FileExists} $0
        call RobloxNotFoundError
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