.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include funs2.inc

.data


.data?

.const
str1 db "<destination>",0
str2 db "<source>",0
str3 db "nation", 0

.code


main proc c argc:DWORD, argv:DWORD, envp:DWORD
	local buf:dword
	invoke malloc, 160
	mov [buf], eax

	invoke str_len, offset str1
	invoke printf, offset format_d, eax	;;print
	invoke str_cpy, [buf], offset str2
	invoke printf, offset format_s, eax	;;print
	invoke str_cat, [buf], offset str1
	invoke printf, offset format_s, eax	;;print
	invoke str_cmp, [buf], offset str2
	invoke printf, offset format_d, eax	;;print
	invoke str_chr, [buf], 100
	invoke printf, offset format_s, eax	;;print
	invoke str_str, [buf], offset str3
	invoke printf, offset format_s, eax	;;print

	invoke str_n_len, [buf], 20
	invoke printf, offset format_d, eax	;;print
	invoke str_n_cpy, [buf], offset str1, 13
	invoke printf, offset format_s, eax	;;print
	invoke str_n_cat, [buf], offset str2, 4
	invoke printf, offset format_s, eax	;;print
	invoke str_cmp, [buf], offset str2
	invoke printf, offset format_d, eax	;;prints

main_ret:
	mov eax, 0
	ret

main endp


end
