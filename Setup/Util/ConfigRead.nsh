Function ConfigRead
	!define ConfigRead `!insertmacro ConfigReadCall`
 
	!macro ConfigReadCall _FILE _ENTRY _RESULT
		Push `${_FILE}`
		Push `${_ENTRY}`
		Call ConfigRead
		Pop ${_RESULT}
	!macroend
 
	Exch $1
	Exch
	Exch $0
	Exch
	Push $2
	Push $3
	Push $4
	ClearErrors
 
	FileOpen $2 $0 r
	IfErrors error
	StrLen $0 $1
	StrCmp $0 0 error
 
	readnext:
	FileRead $2 $3
	IfErrors error
	StrCpy $4 $3 $0
	StrCmp $4 $1 0 readnext
	StrCpy $0 $3 '' $0
	StrCpy $4 $0 1 -1
	StrCmp $4 '$\r' +2
	StrCmp $4 '$\n' 0 close
	StrCpy $0 $0 -1
	goto -4
 
	error:
	SetErrors
	StrCpy $0 ''
 
	close:
	FileClose $2
 
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Exch $0
FunctionEnd