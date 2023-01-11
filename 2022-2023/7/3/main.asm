.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include funs3.inc

str_list struct
	str_ptr		dd ?
	next_ptr	dd ?
str_list ends

.data

.data?

.const

.code

printf proto c :dword, :vararg
malloc proto c :dword
free proto c
rand proto c


main proc c argc:DWORD, argv:DWORD, envp:DWORD
	local head:str_list

	invoke gen_str
	invoke init, addr head, eax
	invoke gen_str_list, addr head, 100
	invoke sort_str_list, addr head
	invoke print_str_list, addr head
	
	mov eax, 0
	ret

main endp


end
