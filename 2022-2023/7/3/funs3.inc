.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac

str_list struct
	str_ptr				dd ?
	next_ptr	dd ?
str_list ends

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
free proto c
rand proto c


init proc c plst:ptr str_list, string:dword
	mov ebx, [plst]
	mov [ebx].str_list.next_ptr, 0
	mov eax, [string]
	mov [ebx].str_list.str_ptr, eax

	ret
init endp


push_node proc c uses ebx ecx plst:ptr str_list, pchar:ptr byte
	local pnd:ptr str_list

	invoke malloc, 4
	mov [pnd], eax

	mov eax, [pchar]
	mov ebx, [pnd]
	mov [ebx].str_list.str_ptr, eax

	mov [ebx].str_list.next_ptr, 0

	mov ebx, [pnd]
	lea ebx, [ebx]
	mov ecx, [plst]
	mov ecx, [ecx]
	.while [ecx].str_list.next_ptr != 0
		mov ecx, [ecx].str_list.next_ptr
	.endw
	mov [ecx].str_list.next_ptr, ebx

	ret
push_node endp


gen_str proc
	push ebp
	mov ebp, esp
	sub esp, 16

	push 10
	call malloc
	add esp, 4
	mov ebx, eax
	mov [ebp-4], ebx

	mov ecx, 0
	mov edi, 60

	.while ecx != 10
		push ecx
		invoke rand
		pop ecx
		mov edx, 0
		div edi
		add edx, 32
		mov byte ptr[ebx], dl
		inc ebx
		inc ecx
	.endw

	mov byte ptr[ebx], 0
	mov eax, [ebp-4]

	mov esp, ebp
	pop ebp
	ret
gen_str endp


gen_str_list proc c plst:ptr str_list, count:dword
	.while 1
		invoke gen_str
		invoke push_node, addr plst, eax
		dec [count]
		.break .if [count] == 0
	.endw

	ret
gen_str_list endp


;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
str_cmp proc c uses ebx ecx edi esi pstr1:dword, pstr2:dword
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


sort_str_list proc c plst:ptr str_list
	mov ebx, [plst]
	.while 1
		mov ecx, [plst]
			.while 1
				mov eax, [ecx].str_list.next_ptr
				invoke str_cmp, [ecx].str_list.str_ptr, [eax].str_list.str_ptr

				cmp eax, 1
				jz replace
				jmp next

				replace:
				mov eax, [ecx].str_list.next_ptr
				mov edx, [eax].str_list.str_ptr
				xchg [ecx].str_list.str_ptr, edx
				mov [eax].str_list.str_ptr, edx

				next:
				mov ecx, [ecx].str_list.next_ptr
				mov eax, [ecx].str_list.next_ptr
				.break .if eax == 0
			.endw
			mov ebx, [ebx].str_list.next_ptr
			.break .if ebx == 0
	.endw

	ret
sort_str_list endp


print_str_list proc c plst:ptr str_list
	mov ebx, [plst]
	.while 1
		invoke printf, offset format_s, [ebx].str_list.str_ptr
		mov ebx, [ebx].str_list.next_ptr
		.break .if ebx == 0
	.endw

	ret
print_str_list endp