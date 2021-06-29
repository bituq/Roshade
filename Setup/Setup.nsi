Unicode true

# Definitions
InstallDir "$LOCALAPPDATA\Roshade"

# Dependencies
!include Attributes.nsh
!include ModernUI.nsh
!include ErrorHandling.nsh
!include InstallationFiles.nsh
!insertmacro Locate 

# Uninstallation
Section Uninstall
    ReadRegStr $0 HKCU "${SELFREGLOC}" "RobloxPath"
    DeleteRegKey HKCU "${SELFREGLOC}"
    Delete "$INSTDIR\AppIcon.ico"
    Delete "$INSTDIR\Uninstall Roshade.exe"
    Delete "$0\dxgi.dll"
    Delete "$0\Reshade.ini"
    Delete "$0\FiraCode-VariableFont_wght.ttf"
    Delete "$0\OpenSans-SemiBold.ttf"
    RMDir /r "$0\reshade-shaders"
SectionEnd

Function un.onInit
    MessageBox MB_YESNO|MB_ICONQUESTION "This will uninstall Reshade from your Roblox directory. Are you sure you want to continue?" IDYES continue
        quit
    continue:
FunctionEnd

# Installation
!insertmacro RequiredFiles ${RESHADESOURCE} $RobloxPath
!insertmacro PresetFiles ${PRESETSOURCE} ${PRESETFOLDER}

Function .onInit
    StrCpy $1 "RobloxPlayerLauncher.exe"
    ${Locate} "$PROGRAMFILES\Roblox\Versions" "/L=F /M=$1" "RobloxInProgramFiles"

    ReadRegStr $RobloxPath HKCU "${ROBLOXUNINSTALLREGLOC}" "InstallLocation"
    ${IfNot} ${FileExists} "$RobloxPath\$1"
        call RobloxNotFoundError
    ${EndIf}

    nsProcess::_FindProcess "RobloxPlayerBeta.exe"
    pop $R0
    StrCmp $R0 0 0 +2
    Call RobloxRunningError

    SectionSetSize ${ReshadeSection} 36860
FunctionEnd

Function RobloxInProgramFiles
    StrCpy $0 StopLocate
    push $0
    push $R9
    call RobloxInProgramFilesError
FunctionEnd