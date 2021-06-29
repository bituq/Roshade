!include LogicLib.nsh

Function AddPrint
    pop $0 # String representation of what to add to.
    pop $1 # Key
    pop $2 # Value
    StrCmp $2 "" 0 +2
    StrCpy $2 "*empty*"
    DetailPrint "Writing to $0: ($1) $2"
FunctionEnd

!macro RegStrPrint Location Key Value
    WriteRegStr HKCU ${Location} ${Key} ${Value}
    push ${Value}
    push ${Key}
    push "registry"
    Call AddPrint
!macroend

!macro IniPrint Location Section Entry Value
    WriteINIStr ${Location} ${Section} ${Entry} ${Value}
    push "${Entry}=${Value}"
    push ${Section}
    push ${Location}
    Call AddPrint
!macroend