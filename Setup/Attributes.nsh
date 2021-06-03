!define VERSION "1.0.1"
!define MANUFACTURER "Zeal"


Name "Roshade"
Caption "$(^Name) Installation"
; Outfile "..\Build\Roshade ${VERSION} setup.exe"
Outfile "..\Build\RoshadeSetup.exe"
BrandingText ${MANUFACTURER}
CRCCHECK force
RequestExecutionLevel user