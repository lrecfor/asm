; void Replace (char *str, char c1, char c2);
; c1	что заменять
; c2	на что заменять
_replace:
	push ebp
    mov ebp, esp
    sub esp, 12
	
    mov eax, [ebp + 8]
	mov [ebp-4], eax
	mov ebx, [ebp + 12]
	mov [ebp-8], ebx
	mov ecx, [ebp + 16]
	mov [ebp-12], ecx
	
replace_start:
	mov dl, byte ptr [ebp+8]
	mov dh, [ebp-8]

	cmp byte ptr [ebp+8], 0
	jz replace_ret
	
	cmp dl, dh
	jz replace_found
	
	inc dword ptr [ebp+8]
	mov eax, [ebp+8]
	jmp replace_start
	
replace_found:
	mov cl, [ebp-12]
	mov byte ptr[ebp+8], cl
	
	inc dword ptr [ebp+8]
	mov eax, [ebp+8]
	jmp replace_start
    
replace_ret:
    mov esp, ebp
    pop ebp
	ret
	
;;malloc
_replaceStr:
	push ebp
    mov ebp, esp
    sub esp, 16
	
    mov edx, [ebp+8]
	mov [ebp-4], edx
	mov ebx, [ebp+12]
	mov [ebp-8], ebx
	mov eax, [ebp+16]
	mov [ebp-12], eax
	
replaceStr_find_size:
	mov dword ptr[ebp-16], 0
	mov ebx, dword ptr[ebp-8]
	_loop:	
    push dword ptr [ebx]
	mov eax, dword ptr[ebp-4]
    push dword ptr [eax]
    call _strstr
	add esp, 8
	
	cmp byte ptr[ebx], 0
	jz replaceStr_allocate_memory
	
	mov ebx, eax
	inc dword ptr[ebp-16]
	;jmp _loop

replaceStr_allocate_memory:
	; mov eax, dword ptr[ebp-4]
    ; push dword ptr [eax]
    ; call _strlen
	; add esp, 4

	;push 16
	;call malloc
	;add esp, 4
	;test eax, eax
	;jz replaceStr_ret
	
	;mov ebx, eax
	
replaceStr_start:
	mov ecx, [ebp-16]
	mov byte ptr[ebx], 'A'
	;mov byte ptr[ebx+1], "R"
	;mov byte ptr[ebx+2], 0
	
    
replaceStr_ret:   
    mov esp, ebp
    pop ebp
	ret
	;;;;;;;;;;;;;;;;;;;;
	push eax
	call malloc
	add esp, 4
	test eax, eax
	jz replaceStr_ret
	
	mov ebx, eax
	
	mov al, byte ptr[ebp-12]
	mov byte ptr[ebx], al
	mov ecx, 1
	mov byte ptr[ebx+ecx], 'P'
	mov ecx, 2
	mov byte ptr[ebx+ecx], 'T'
	mov ecx, 3
	mov byte ptr[ebx+ecx], 0
	;;;;;;;;;;;;;;;;;;;
	

	"adfkasddkjadfkdaqwed"
	"ad"
	"12345"
	"12345fkasddkj12345fkdaqwed"
	
	push [ebp-20]
	push offset format_eax
	call printf
	add esp,8
	
	
	
_replaceStr:
	push ebp
    mov ebp, esp
    sub esp, 24
	
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

replaceStr_start:
	push dword ptr [ebp-8]
    push dword ptr [ebp-4]
    call _strstr
	add esp, 8

	sub eax, dword ptr[ebp-4]
	push eax
	cmp eax, 0
	jne _loop1
	
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	push [ebp-16]
	
	_loop2:
	mov al, byte ptr[ebp-16]
	mov byte ptr[ebx], al
	
	cmp byte ptr[ebp-16], 0
	jz _tmp
	
	inc ebx
	inc dword ptr[ebp-16]
	jmp _loop2
	
	_tmp:
	pop [ebp-16]
	jmp replaceStr_start
	
	_loop1:
	cmp byte ptr[ebp-4], 0
	jz l2

	cmp eax, 0
	jz l2

	mov al, byte ptr[ebp-4]
	mov byte ptr[ebx], al
	
	inc ebx
	dec eax
	cmp eax, 0
	jne _loop1

	jmp replaceStr_start

	l2:
	add dword ptr[ebp-4], eax
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	
	push [ebp-4]
	push offset format
	call printf
	add esp,8

replaceStr_ret: 
	mov eax, ebx  
    mov esp, ebp
    pop ebp
	ret
	
	
	mov byte ptr[ebx+1], 0 
	mov eax, [ebp-28]
	push eax
	push offset format
	call printf
	add esp, 8
	;;;;;
	replaceStr_start:
	push ebx
	push dword ptr [ebp-8]
    push dword ptr [ebp-4]
    call _strstr
	add esp, 8
	pop ebx

	sub eax, dword ptr[ebp-4]
	push eax
	cmp eax, 0
	jne _loop1
	
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	push [ebp-12]
	
	_loop2:
	mov edx, [ebp-12]
	mov al, byte ptr[edx]
	mov byte ptr[ebx], al
	
	cmp byte ptr[edx], 0
	jz _tmp
	
	inc ebx
	inc dword ptr[ebp-12]
	jmp _loop2
	
	_tmp:
	pop [ebp-12]
	jmp replaceStr_start
	
	_loop1:
	cmp byte ptr[ebp-4], 0
	jz l2

	cmp eax, 0
	jz l2

	mov edx, [ebp-4]
	mov al, byte ptr[edx]
	mov byte ptr[ebx], al
	
	inc ebx
	dec eax
	jmp _loop1

	l2:
	pop eax
	add dword ptr[ebp-4], eax
	mov eax, [ebp-16]
	add dword ptr[ebp-4], eax
	jmp _loop2
	
	;;jmp replaceStr_start
	
	; push ebx
	; push dword ptr [ebp-8]
    ; push dword ptr [ebp-4]
    ; call _strstr
	; add esp, 8
	; pop ebx

	; mov edx, [ebp-12]
	; mov al, byte ptr[edx]
	; mov byte ptr[ebx], al
	