InstType full

!include MUI2.nsh
!include "CustomDlg\ReshadeSettings.nsdinc"

/* General Settings */
!define MUI_ICON "Graphics\AppIcon.ico"
!define MUI_UNICON "Graphics\AppIcon.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Graphics\wizardImage.bmp"

/* Welcome Page */
!define MUI_WELCOMEPAGE_TITLE "Roshade Installation"
!define MUI_WELCOMEPAGE_TEXT "This will install Reshade and the Roshade preset on your computer.$\n$\nThe shaders will automatically be download from github during installation.$\n$\nClick Next to continue."
!insertmacro MUI_PAGE_WELCOME

/* License Page */
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"

/* Reshade Settings Page */
Page custom fnc_ReshadeSettings_Show

/* Components Page */
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_COMPONENTSPAGE_TEXT_DESCRIPTION_TITLE "Recommended Requirements"
!insertmacro MUI_PAGE_COMPONENTS

/* Installation Page */
Function showInstFiles
    titprog::Start
    w7tbp::Start
FunctionEnd
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_PAGE_CUSTOMFUNCTION_SHOW showInstFiles
!insertmacro MUI_PAGE_INSTFILES

/* Finish Page */
!define MUI_FINISHPAGE_TEXT "Roshade has been installed on your computer.$\n$\nThe changes will be in effect next time you launch Roblox.$\n$\nClick Finish to close Setup."
!define MUI_FINISHPAGE_LINK "Join the Discord server"
!define MUI_FINISHPAGE_LINK_LOCATION "https://discord.gg/sjSDVrCjFG"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Subscribe to Zeal"
!define MUI_FINISHPAGE_SHOWREADME "https://www.youtube.com/channel/UCfN0Oe5XU6Z8m266xj2jS7Q?sub_confirmation=1"
!insertmacro MUI_PAGE_FINISH

/* Uninstall Files Page */
!insertmacro MUI_UNPAGE_INSTFILES

/* Uninstall Finish Page */

!insertmacro MUI_UNPAGE_FINISH

/* Language */
!insertmacro MUI_LANGUAGE "English"