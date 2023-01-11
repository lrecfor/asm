.686
.model flat, c

.data
format db "%s",13,10,0
format_eax db "%d", 0Dh, 0Ah, 0

.code

printf proto c :dword, :vararg
malloc proto c :dword


; int strlen(const char *str)
; находит длинну строки (до завершающего нуля), адрес которой является аргументом
_strlen:
    push ebp
    mov ebp, esp
    sub esp, 8
	
    mov eax, [ebp + 8]
	mov [ebp-4], eax
    mov dword ptr[ebp-8], 0 ; счётчик ax 

strlen_cycle:   
    cmp byte ptr [eax], 0
    je strlen_ret
    add dword ptr[ebp-8], 1
    add dword ptr[ebp-4], 1
	mov eax, [ebp-4]
    jmp strlen_cycle
    
strlen_ret:   
    mov eax, [ebp-8]
    mov esp, ebp
    pop ebp
	ret

;char * strstr (const char *str, const char *strSearch);
;поиск первого вхождение строки strSearch в строке str, возвращает 0 если нет вхождений, 
;иначе указатель на первое вхождение, если strSearch нулевой длины, то возвращ указ на начало строки str
_strstr:	
    push ebp
    mov ebp, esp
	sub esp, 16

    push [ebp+8]
    call _strlen
	add esp, 4
    cmp eax, 0
    jz strstr_null_str

	mov eax, [ebp+8]
    mov [ebp-4], eax
	mov ecx, [ebp+12]
    mov [ebp-8], ecx

    mov dword ptr[ebp-16], 0
    
strstr_start: 
    mov dl, byte ptr[eax]
    mov bl, byte ptr[ecx]

    cmp dl, 0
    je strstr_end1

    cmp bl, 0
    je ststr_found

    cmp dl, bl
    je strstr_count
	jne strstr_stop

	@:
    inc dword ptr[ebp-4]
	mov eax, dword ptr[ebp-4]

    jmp strstr_start

strstr_count:
    inc dword ptr[ebp-4]
	mov eax, dword ptr[ebp-4]
	inc dword ptr[ebp-8]
    mov ecx, dword ptr[ebp-8]
	inc dword ptr[ebp-16]
    jmp strstr_start

strstr_end1:
    cmp bl, 0
    je ststr_found
    jmp strstr_no

strstr_stop:
	cmp byte ptr[ebp-16], 0
	jz @

	mov dword ptr[ebp-16], 0
	dec dword ptr[ebp-8]
    mov ecx, dword ptr[ebp-8]
	jmp strstr_start

ststr_found:
	mov eax, [ebp-4]
    sub eax, dword ptr[ebp-16]
    jmp strstr_ret

strstr_null_str:
    mov eax, [ebp+8]
    jz strstr_ret

strstr_no:
    mov eax, 0
	
strstr_ret:	
    mov esp, ebp
    pop ebp
	ret

; char * ReplaceStr (const char *text, const char *pattern, const char *rep);
; text		где заменять
; pattern		что заменять
; rep			на что заменять
_replaceStr:
	push ebp
    mov ebp, esp
    sub esp, 28
	
    mov edx, [ebp+8]
	mov [ebp-4], edx
	mov ebx, [ebp+12]
	mov [ebp-8], ebx
	mov eax, [ebp+16]
	mov [ebp-12], eax

	push [ebp-4]
	
replaceStr_find_size:
    push [ebp-8]
    call _strlen
	add sp, 4
	mov [ebp-16], eax

	push [ebp-12]
    call _strlen
	add sp, 4
	mov [ebp-20], eax

	mov dword ptr[ebp-24], 0
	_loop:	
    push dword ptr [ebp-8]
    push dword ptr [ebp-4]
    call _strstr
	add esp, 8

	cmp eax, 0
	jz replaceStr_allocate_memory

    sub eax, dword ptr[ebp-4]
	cmp eax, 0
	jne @@@
	
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	jmp @@@@

	@@@:
	add dword ptr[ebp-4], eax
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax

	@@@@:
	cmp byte ptr[ebp-4], 0
	jz replaceStr_allocate_memory
	inc dword ptr[ebp-24]
	jmp _loop

replaceStr_allocate_memory:
	pop [ebp-4]

	push [ebp-4]
    call _strlen
	add sp, 4

	mov ecx, [ebp-16]
	mov ebx, [ebp-24]
	imul ecx, ebx
	sub eax, ecx
	mov ecx, [ebp-20]
	imul ecx, ebx
	add eax, ecx
	
	push eax
	call malloc
	add esp, 4
	test eax, eax
	jz replaceStr_ret
	
	mov ebx, eax
	mov [ebp-28], ebx
	mov ecx, 0
	push [ebp-12]
	
replaceStr_start:
	push ebx
	push dword ptr [ebp-8]
    push dword ptr [ebp-4]
    call _strstr
	add esp, 8
	pop ebx

	sub eax, dword ptr[ebp-4]
	pop [ebp-12]
	push eax
	push [ebp-12]
	jmp _loop1

	_loop1:
	push [ebp-4]
	push offset format
	call printf
	add esp, 8
	
	cmp byte ptr[ebp-4], 0
	jz l2

	cmp eax, 0
	jz l2

	mov edx, [ebp-4]
	mov al, byte ptr[edx]
	mov byte ptr[ebx], al
	
	inc ebx
	inc dword ptr[ebp-4]
	dec eax
	
	jmp _loop1

	l2:
	pop eax
	add dword ptr[ebp-4], eax
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	
	_loop2:
	mov edx, [ebp-12]
	mov al, byte ptr[edx]
	mov byte ptr[ebx], al
	
	cmp byte ptr[edx], 0
	jz replaceStr_start
	
	inc ebx
	inc dword ptr[ebp-12]
	
	jmp _loop2
	
replaceStr_ret: 
	mov byte ptr[ebx+1], 0 
	mov eax, [ebp-28]
    mov esp, ebp
    pop ebp
	ret

main proc
	push ebp
    mov ebp, esp
    sub esp, 20

	mov eax, [ebp+12]
	mov dword ptr [ebp-4], eax
	add dword ptr[ebp-4], 4
	
	mov eax, [ebp+12]
	mov dword ptr[ebp-8], eax
	add dword ptr[ebp-8], 8
	
	mov eax, [ebp+12]
	mov dword ptr[ebp-12], eax
	add dword ptr[ebp-12], 12
	
	; mov eax, dword ptr[ebp-12]
	; mov ecx, dword ptr[eax]
	; push ecx
	; mov eax, dword ptr[ebp-8]
	; mov ecx, dword ptr[eax]
	; push ecx
	; mov eax, dword ptr[ebp-4]
	; mov ecx, dword ptr[eax]
	; push ecx
	; call _replace
	; add sp, 12
	
	; mov eax, dword ptr[ebp-4]
	; push dword ptr [eax]
	; push offset format
	; call printf
	; add esp,8
	
	mov eax, dword ptr[ebp-12]
	push dword ptr[eax]
	mov eax, dword ptr[ebp-8]
	push dword ptr[eax]
	mov eax, dword ptr[ebp-4]
	push dword ptr[eax]
	call _replaceStr
	add esp, 12
	
	push eax
	push offset format
	call printf
	add esp, 8
	
_ret:
	mov esp, ebp
    pop ebp
	ret

main endp

end
