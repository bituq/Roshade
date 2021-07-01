!include LogicLib.nsh

var LauncherTransferID

!macro StopMessage Message
    MessageBox MB_OK|MB_ICONSTOP "${Message}"
    quit
!macroend

Function RobloxNotFoundError
    NScurl::http GET "https://www.roblox.com/download/client" "$PLUGINSDIR/RobloxPlayerLauncher.exe" /BACKGROUND /END
    pop $LauncherTransferID
FunctionEnd

Function RobloxInProgramFilesError
    MessageBox MB_YESNO|MB_ICONQUESTION "Roshade cannot be installed when Roblox is located in Program Files (x86). Would you like to reinstall Roblox automatically?" IDYES yes
        Abort
    yes:
    MessageBox MB_OKCANCEL|MB_ICONINFORMATION "Roblox will now be reinstalled." IDOK ok
        Abort
    ok:
    StrCpy $2 "$TEMP\RobloxPlayerLauncher.exe"
    pop $1
    Rename $1 $2
    RMDir /r "$PROGRAMFILES\Roblox"
    ExecWait $2
    delete $2
FunctionEnd

Function RobloxRunningError
    MessageBox MB_YESNOCANCEL|MB_ICONEXCLAMATION "It is recommended that you close Roblox when Reshade is already installed. Select 'yes' to close Roblox immediately." IDYES yes IDNO no
            Abort
        yes:
        MessageBox MB_OKCANCEL|MB_ICONINFORMATION "Roblox will now be closed." IDCANCEL no
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