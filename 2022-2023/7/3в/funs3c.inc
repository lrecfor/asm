.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac


item struct
    key_ptr     dd ?
    value_ptr   dd ?
	next_ptr    dd ?
item ends

hash_table struct
	items_ptr	dd ?
    _size_		dd ?
    count		dd ?
hash_table ends


.data


.data?

.const
format_s db "%s",13,10,0
format_d db "%d", 0Dh, 0Ah, 0
format_c db "%c", 0Dh, 0Ah, 0
format_r db "r", 0
format_w db "w", 0
format_a db "a", 0

.code

printf proto c :dword, :vararg
malloc proto c :dword
calloc proto c :dword, :dword
free proto c
rand proto c


;;char * strcpy (char *dst, const char *src`, int count) 
;;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest
str_cpy proc pdst:dword, psrc:dword

	invoke crt_strlen, [psrc]
	cld 
	lea ecx, [eax + 1]	
	mov esi, [psrc]		
	mov edi, [pdst]	
	rep movsb

	mov eax, [pdst]
	ret

str_cpy endp


;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
str_cmp proc c uses ebx ecx pstr1:dword, pstr2:dword
	invoke crt_strlen, [pstr1]
	
	cld
	mov ecx, eax
	mov esi, [pstr1]
	mov edi, [pstr2]
	repe cmpsb
	jg greater
	jl less

	;Если строки разной длины, то возвращается положительное число, если строка str1 длиннее строки str2, 
	;или отрицательное число, если строка str2 длиннее строки str1. 

	mov eax, 0
	ret

	greater:
		mov eax, 1
		ret
	less:
		mov eax, -1
		ret
str_cmp endp

