.686
.model flat, c

.data
format db "%s",13,10,0
format_eax db "%d", 0Dh, 0Ah, 0
format_s db "%c", 0Dh, 0Ah, 0
string_1 db "hellopeople", 0

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

; void Replace (char *str, char c1, char c2);
; c1	что заменять
; c2	на что заменять
_replace:
	push ebp
    mov ebp, esp
    sub esp, 12
	
	push [ebp + 16]
	push offset format_s
	call printf
	add esp,8
	
    mov eax, [ebp + 8]
	mov [ebp-4], eax
	mov ebx, [ebp + 12]
	mov [ebp-8], ebx
	mov ecx, [ebp + 16]
	mov [ebp-12], ecx

replace_start:
	mov dl, byte ptr [eax]
	mov cl, byte ptr[ebp-8]

	cmp byte ptr [eax], 0
	jz replace_ret
	
	cmp dl, cl
	jz replace_found
	
	add dword ptr [ebp-4], 1
	mov eax, [ebp-4]
	jmp replace_start
	
replace_found:
	mov cl, byte ptr[ebp-12]
	mov eax, [ebp-4]
	mov byte ptr[eax], cl
	
	push eax
	push eax
	push offset format
	call printf
	add esp,8
	pop eax
	
	add dword ptr [ebp-4], 1
	mov eax, [ebp-4]
	jmp replace_start
    
replace_ret: 
    mov esp, ebp
    pop ebp
	ret
	
;char * strcat (char *dst, const char *src) 
;конкатенация, \0, возвращает указатель на dest
_strcat:
    push ebp
    mov ebp, esp
	sub esp, 8
	
	mov ebx, [ebp+8]
	mov [ebp-4], ebx
	mov ecx, [ebp+12]
	mov [ebp-8], ecx
		
strcat_cyc:  
	mov dl, byte ptr [ebx]
	
	cmp dl, 0
	je strcat_move
	
	add dword ptr[ebp-4], 1
	mov ebx, [ebp-4]
	jmp strcat_cyc
	
strcat_move:
	mov al, byte ptr[ecx]
	mov byte ptr[ebx], al
	
	cmp byte ptr[ecx], 0
	je strcat_ret
	
	add dword ptr[ebp-8], 1
	mov ecx, [ebp-8]
	add dword ptr[ebp-4], 1
	mov ebx, [ebp-4]
	jmp strcat_move

strcat_ret:
	mov eax, [ebp+8]
    mov esp, ebp
    pop ebp
    retn 8
	
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
	
	mov eax, dword ptr[ebp-12]
	mov ecx, dword ptr[eax]
	push dword ptr[ecx]
	mov eax, dword ptr[ebp-8]
	mov ecx, dword ptr[eax]
	push dword ptr[ecx]
	mov eax, dword ptr[ebp-4]
	push dword ptr[eax]
	call _replace
	add esp, 12
	
	mov eax, dword ptr[ebp-4]
	push dword ptr[eax]
	push offset format
	call printf
	add esp, 8
	
	; _strcat_:
    ; mov eax, dword ptr[ebp-8]
    ; push dword ptr [eax]
	; mov eax, dword ptr[ebp-4]
    ; push dword ptr [eax]
    ; call _strcat
    ; push eax
	; push offset format
	; call printf
	; add esp,8
	
_ret:
	mov esp, ebp
    pop ebp
	ret

main endp

end
