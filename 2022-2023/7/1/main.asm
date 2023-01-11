.686
.model flat, stdcall
option casemap:none

include Strings.mac
include funs1.inc

string struct
	str_length	dd ?
	str_ptr		dd ?
string ends

.data


.data?

.const

.code

;
; ��������� ��������� �� ��������� � ������ ���������� ������.
;
str_init proc pstr:ptr string, count:dword
	mov ebx, [pstr]

	invoke malloc, [count]
	mov [ebx].string.str_ptr, eax
	mov eax, [ebx].string.str_ptr
	add eax, [count]
	mov dword ptr[eax], 0

	mov eax, [count]
	mov [ebx].string.str_length, eax

	ret
str_init endp


; ��������� ��������� �� ��������� � ��������� �� ������, ������������� �����.
; ��������� ������ ��������� ������ ��������� �� ����� ���������� ������.
str_init_by_str proc c pstr:ptr string, pchar:ptr byte
	local buf:dword
	invoke crt_strlen, [pchar]

	mov ebx, [pstr]
	mov [ebx].string.str_length, eax

	invoke malloc, eax

	mov [buf], eax

	invoke _strcpy, eax, [pchar]
	mov eax, [buf]
	mov ebx, [pstr]
	mov [ebx].string.str_ptr, eax

	ret
str_init_by_str endp


;
; ����������� ����������� ���������� ������.
;
str_free proc pstr:ptr string
	mov ebx, [pstr]
	mov [ebx].string.str_length, 0
	mov ebx, [ebx].string.str_ptr
	invoke free, ebx

	ret
str_free endp


main proc c uses ebx argc:DWORD, argv:DWORD, envp:DWORD
	local str1:string
	local str2:string
	local str3:string
	local str4:string
	
	mov ebx, [argv]
	
	add ebx, 4
	invoke str_init_by_str, addr str1, dword ptr [ebx]
	add ebx, 4
	invoke str_init_by_str, addr str2, dword ptr [ebx]
	
	invoke str_init, addr str3, 20
	invoke str_init, addr str4, 2

	invoke str_cpy, addr str3, addr str2
	invoke str_n_cpy, addr str3, addr str1, 2
	invoke str_n_cpy, addr str4, addr str1, 10
	invoke str_cat, addr str3, addr str2
	invoke str_n_cat, addr str1, addr str2, 3
	invoke str_len, addr str3
	invoke str_n_len, addr str3, 10
	invoke str_cmp, addr str1, addr str3
	invoke str_n_cmp, addr str4, addr str3, 4
	invoke str_chr, addr str1, 100
	invoke str_str, addr str3, addr str2
	
	mov eax, 0
	ret

main endp

end


