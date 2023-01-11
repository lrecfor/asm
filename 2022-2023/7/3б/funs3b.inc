.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac

binary_node_tree struct
    left_ptr    dd ?
    right_ptr   dd ?
    key_ptr     dd ?
    value_ptr   dd ?
binary_node_tree ends

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


;;char * strcpy (char *dst, const char *src`, int count) 
;;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest
str_cpy proc pdst:dword, psrc:dword

	invoke crt_strlen, [psrc]
	cld 
	lea ecx,[eax + 1]	
	mov esi, [psrc]		
	mov edi, [pdst]	
	rep movsb

	mov eax, [pdst]
	ret

str_cpy endp


;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
str_cmp proc c pstr1:dword, pstr2:dword
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


create_binary_node_tree proc c uses ebx ecx pkey:ptr byte, pvl:ptr byte 
    local bnt:ptr binary_node_tree
    local key:dword

    invoke malloc, sizeof(binary_node_tree)
    test eax, eax
    jz @
	mov [bnt], eax
    mov ebx, [bnt]

    invoke crt_strlen, [pkey]
    inc eax
    invoke malloc, eax
    mov [ebx].binary_node_tree.key_ptr, eax
    invoke str_cpy, [ebx].binary_node_tree.key_ptr, [pkey]

    invoke crt_strlen, [pvl]
    inc eax
    invoke malloc, eax
    mov [ebx].binary_node_tree.value_ptr, eax
    invoke str_cpy, [ebx].binary_node_tree.value_ptr, [pvl]

    mov [ebx].binary_node_tree.left_ptr, 0
    mov [ebx].binary_node_tree.right_ptr, 0

    @:
    mov eax, [bnt]
    ret
create_binary_node_tree endp


insert_value_by_key proc c uses ebx ecx proot:ptr binary_node_tree, pkey:ptr byte, pvl:ptr byte
    mov ebx, [proot]
    invoke str_cmp, [ebx].binary_node_tree.key_ptr, [pkey]
     .if eax == 1
        .if [ebx].binary_node_tree.left_ptr != 0
            invoke insert_value_by_key, [ebx].binary_node_tree.left_ptr, [pkey], [pvl]
        .else
            invoke create_binary_node_tree, [pkey], [pvl]
            mov [ebx].binary_node_tree.left_ptr, eax
        .endif
    .else
        .if [ebx].binary_node_tree.right_ptr != 0
            invoke insert_value_by_key, [ebx].binary_node_tree.right_ptr, [pkey], [pvl]
        .else
            invoke create_binary_node_tree, [pkey], [pvl]
            mov [ebx].binary_node_tree.right_ptr, eax
        .endif
    .endif


    ret
insert_value_by_key endp


find_node_by_key proc c uses ebx ecx proot:ptr binary_node_tree, pkey:ptr byte
    local current_node:ptr binary_node_tree
    mov eax, [proot]
    mov [current_node], eax

    .while 1
        .if [current_node] == 0
            mov eax, 0
            ret
        .endif
        mov ebx, [current_node]
        invoke str_cmp, [pkey], [ebx].binary_node_tree.key_ptr
        .if eax == 0
            mov eax, [current_node]
            ret
        .endif
        .if eax < 0 
            mov ebx, [current_node]
            mov eax, [ebx].binary_node_tree.left_ptr
            mov [current_node], eax
        .else
            mov ebx, [current_node]
            mov eax, [ebx].binary_node_tree.right_ptr
            mov [current_node], eax
        .endif
    .endw

    ret
find_node_by_key endp


