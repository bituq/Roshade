# Important
InstallDir "$LOCALAPPDATA\Roshade"

# Attributes
!define VERSION "1.2.7"
!define MANUFACTURER "Zeal"
!define NAME "Roshade"
!define ROBLOXREGLOC "SOFTWARE\ROBLOX Corporation\Environments\roblox-player"
!define ROBLOXUNINSTALLREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\roblox-player"
!define SELFREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
!define UninstallerExe "Uninstall Roshade.exe"
!define HELPLINK "https://discord.gg/sjSDVrCjFG"
!define ABOUTLINK "https://Roshade.com/"
!define UPDATELINK "https://github.com/bituq/Roshade/releases"
!define RENDERAPI "opengl32.dll"

# Directories
!define PRESETFOLDER "$INSTDIR\presets"
!define RESHADESOURCE "..\Files\Reshade"
!define PRESETSOURCE "..\Files\Preset"
!define PRESETTEMPFOLDER "$TEMP\Presets"
!define TEMPFOLDER "$TEMP\Zeal"

# Files
!define SPLASHICON "$PLUGINSDIR\Roshade.gif"
!define SHADERSINI "$PLUGINSDIR\Shaders.ini"
!define RESHADEINI "$PLUGINSDIR\Reshade.ini"
!define APPICON "$INSTDIR\AppIcon.ico"

Var Techniques
Var Repositories
Var RobloxPath
Var ShaderDir

VIProductVersion "${VERSION}.0"
VIAddVersionKey "ProductName" "${NAME}"
VIAddVersionKey "CompanyName" "${MANUFACTURER}"
VIAddVersionKey "LegalCopyright" "Copyright (C) 2021 Zeal"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIAddVersionKey "FileVersion" "${VERSION}"

Name "${NAME}"
Caption "$(^Name) Installation"
Outfile "..\RoshadeSetup.exe"
BrandingText "${MANUFACTURER}"
CRCCHECK force
RequestExecutionLevel user