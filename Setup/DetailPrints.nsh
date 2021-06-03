!include LogicLib.nsh

!macro RegPrint Key Value
    ${if} ${Value} == ""
        DetailPrint "Adding to registry: (${key}) *empty*"
    ${else}
        DetailPrint "Adding to registry: (${key}) ${Value}"
    ${endif}
!macroend

!macro RegDelPrint Key
    DetailPrint "Removing from registry: (${key})"
!macroend

!macro IniPrint Section Entry Value
    ${if} ${Value} == ""
        DetailPrint "Writing to INI: [${Section}] ${Entry}"
    ${else}
        DetailPrint "Writing to INI: [${Section}] ${Entry}=${Value}"
    ${endif}
!macroend