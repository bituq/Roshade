!include LogicLib.nsh
!include FileFunc.nsh
!include DetailPrints.nsh
!insertmacro Locate 
!include "Util\MoveFileFolder.nsh"

var LauncherTransferID

!macro StopMessage Message
    MessageBox MB_OK|MB_ICONSTOP "${Message}"
    DetailPrint "Setup quit: ${Message}"
    quit
!macroend

!macro ToLog File Type String
    LogEx::Write "[${Type}]$\t${String}"
!macroend

Function SettingsExistingError
    pop $R0 # Effects key
    pop $R1 # Overlay key
    MessageBox MB_YESNO|MB_ICONEXCLAMATION "Existing Reshade settings have been found. Would you like to overwrite those keybinds?" IDNO no
        !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyEffects" $KeyEffects
        !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyOverlay" $KeyOverlay
        !insertmacro ToLog $LOGFILE "Output" "Settings have been overwritten."
        GoTo skip
    no:
        !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyEffects" $R0
        !insertmacro IniPrint "${RESHADEINI}" "INPUT" "KeyOverlay" $R1
        !insertmacro ToLog $LOGFILE "Output" "Settings have not been overwritten."
    skip:
FunctionEnd

Function RobloxNotFoundError
    !insertmacro ToLog $LOGFILE "Error" "Roblox was not found."
    NScurl::http GET "https://www.roblox.com/download/client" "$PLUGINSDIR\RobloxPlayerLauncher.exe" /BACKGROUND /END
    pop $LauncherTransferID
FunctionEnd

Function RobloxRunningError
    !insertmacro ToLog $LOGFILE "Error" "Active Roblox process found."
    MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION "It is recommended that you close Roblox when Reshade is already installed. Select 'yes' to close Roblox immediately." IDYES yes IDNO no
            Abort
        yes:
        MessageBox MB_OKCANCEL|MB_ICONINFORMATION "Roblox will now be closed." IDCANCEL no
            nsProcess::_KillProcess "RobloxPlayerBeta.exe"
            pop $R0
            !insertmacro ToLog $LOGFILE "nsProcess" "KillProcess RobloxPlayerBeta.exe with code: $R0"
            ${switch} $R0
                ${case} 0
                    goto no
                ${case} 601
                    !insertmacro StopMessage "No permission to close Roblox."
                    ${break}
                ${case} 603
                    MessageBox MB_OK|MB_ICONEXCLAMATION "Roblox is not currently running."
                    ${break}
                ${case} 605
                    !insertmacro StopMessage "Could not close Roblox. Unsupported operating system."
                    ${break}
                ${case} 606
                    !insertmacro StopMessage "Could not close Roblox. Unable to load NTDLL.DLL. Please try again."
                    ${break}
                ${case} 609
                    !insertmacro StopMessage "Could not close Roblox. Unable to load KERNEL32.DLL. Please try again."
                    ${break}
                ${caseelse}
                    !insertmacro StopMessage "Unable to close Roblox. Please close it manually and try again."
            ${endswitch}
        no:
FunctionEnd