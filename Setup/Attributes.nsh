!define VERSION "1.2.1"
!define MANUFACTURER "Zeal"
!define NAME "Roshade"
!define ROBLOXREGLOC "SOFTWARE\ROBLOX Corporation\Environments\roblox-player"
!define ROBLOXUNINSTALLREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\roblox-player"
!define SELFREGLOC "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${NAME}"
!define UninstallerExe "Uninstall Roshade.exe"
!define HELPLINK "https://discord.gg/sjSDVrCjFG"
!define ABOUTLINK "https://Roshade.com/"
!define UPDATELINK "https://github.com/bituq/Roshade/releases"


Name "${NAME}"
Caption "$(^Name) Installation"
; Outfile "..\Roshade ${VERSION} setup.exe"
Outfile "..\RoshadeSetup.exe"
BrandingText ${MANUFACTURER}
CRCCHECK force
RequestExecutionLevel user