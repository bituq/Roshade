
!include LogicLib.nsh

!macro StopMessage Message
    MessageBox MB_OK|MB_ICONSTOP "${Message}"
    quit
!macroend

Function RobloxNotFoundError
    MessageBox MB_OK|MB_ICONSTOP "Roblox has not been found on your PC. Would you like to install Roblox?" IDNO NoInstall
        ExecShell open "https://www.roblox.com/download"
    NoInstall:
        Abort
FunctionEnd

Function RobloxRunningError
    MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION "It is recommended that you close Roblox when Reshade is already installed. Select 'yes' to close Roblox immediately." IDYES yes IDNO no
            Abort
        yes:
        MessageBox MB_OKCANCEL|MB_ICONEXCLAMATION "Roblox will now be closed..." IDCANCEL no
            nsProcess::_KillProcess "RobloxPlayerBeta.exe"
            pop $R0
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