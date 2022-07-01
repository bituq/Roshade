Function ConfigWrite
	!define ConfigWrite `!insertmacro ConfigWriteCall`
 
	!macro ConfigWriteCall _FILE _ENTRY _VALUE _RESULT
		Push `${_FILE}`
		Push `${_ENTRY}`
		Push `${_VALUE}`
		Call ConfigWrite
		Pop ${_RESULT}
	!macroend
 
	Exch $2
	Exch
	Exch $1
	Exch
	Exch 2
	Exch $0
	Exch 2
	Push $3
	Push $4
	Push $5
	Push $6
	ClearErrors
 
	IfFileExists $0 0 error
	FileOpen $3 $0 a
	IfErrors error
 
	StrLen $0 $1
	StrCmp $0 0 0 readnext
	StrCpy $0 ''
	goto close
 
	readnext:
	FileRead $3 $4
	IfErrors add
	StrCpy $5 $4 $0
	StrCmp $5 $1 0 readnext
 
	StrCpy $5 0
	IntOp $5 $5 - 1
	StrCpy $6 $4 1 $5
	StrCmp $6 '$\r' -2
	StrCmp $6 '$\n' -3
	StrCpy $6 $4
	StrCmp $5 -1 +3
	IntOp $5 $5 + 1
	StrCpy $6 $4 $5
 
	StrCmp $2 '' change
	StrCmp $6 '$1$2' 0 change
	StrCpy $0 SAME
	goto close
 
	change:
	FileSeek $3 0 CUR $5
	StrLen $4 $4
	IntOp $4 $5 - $4
	FileSeek $3 0 END $6
	IntOp $6 $6 - $5
 
	System::Alloc /NOUNLOAD $6
	Pop $0
	FileSeek $3 $5 SET
	System::Call /NOUNLOAD 'kernel32::ReadFile(i r3, i r0, i $6, t.,)'
	FileSeek $3 $4 SET
	StrCmp $2 '' +2
	FileWrite $3 '$1$2$\r$\n'
	System::Call /NOUNLOAD 'kernel32::WriteFile(i r3, i r0, i $6, t.,)'
	System::Call /NOUNLOAD 'kernel32::SetEndOfFile(i r3)'
	System::Free $0
	StrCmp $2 '' +3
	StrCpy $0 CHANGED
	goto close
	StrCpy $0 DELETED
	goto close
 
	add:
	StrCmp $2 '' 0 +3
	StrCpy $0 SAME
	goto close
	FileSeek $3 -1 END
	FileRead $3 $4
	IfErrors +4
	StrCmp $4 '$\r' +3
	StrCmp $4 '$\n' +2
	FileWrite $3 '$\r$\n'
	FileWrite $3 '$1$2$\r$\n'
	StrCpy $0 ADDED
 
	close:
	FileClose $3
	goto end
 
	error:
	SetErrors
	StrCpy $0 ''
 
	end:
	Pop $6
	Pop $5
	Pop $4
	Pop $3
	Pop $2
	Pop $1
	Exch $0
FunctionEnd