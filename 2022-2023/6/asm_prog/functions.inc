.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac

.data


.data?

.const
format db "%s",13,10,0
format_eax db "%d", 0Dh, 0Ah, 0
format_c db "%c", 0Dh, 0Ah, 0
format_num_val db "%d - %s", 0Dh, 0Ah, 0
null_ db 0, 0
string db "------------------------------------------------",0

.code

printf proto c :dword, :vararg
malloc proto c :dword
free proto c:dword
rand proto c 

GenStr proc
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

	loop_:
	push ecx
	invoke rand
	pop ecx
	mov edx, 0
	div edi
	add edx, 32
	mov byte ptr[ebx], dl
	inc ebx
	inc ecx

	cmp ecx, 10
	jl loop_

GenStr_ret:
	mov byte ptr[ebx], 0
	mov eax, [ebp-4]

	mov esp, ebp
	pop ebp
	ret
GenStr endp


GenStrings proc c arg:DWORD, count:dword
	local i:dword
	
	mov [i], 0

	m2:
		call GenStr
		mov ecx, [i]
		mov ebx, [arg]
		mov dword ptr[ecx + ebx], eax
		
		add [i], 4
		dec count

		cmp count, 0
		jne m2

		ret
GenStrings endp

SortStrings proc c arg:DWORD, count:dword
	local i:dword
	local j:dword
	local count2:dword
	mov eax, [count]
	mov [count2], eax
	sub [count2], 1
	
	mov [i], 0
	mov [j], 0
	
	_loop1:
		_loop2:
		mov ecx, [i]
		mov eax, [arg]
		push dword ptr [eax + ecx + 4]
		push dword ptr [eax + ecx]
		call _strcmp
		add esp, 8

		cmp eax, 1
		jz replace
		jmp next

		replace:
		mov ecx, [i]
		mov eax, [arg]
		mov ebx, dword ptr[eax+ecx+4]
		xchg dword ptr[eax+ecx], ebx
		mov dword ptr[eax+ecx+4], ebx

		next:
		add [i], 4
		inc [j]
		mov eax, [count2]
		cmp [j], eax
		jne _loop2
	
	mov [i], 0
	mov [j], 0
	dec count
	cmp count, 0
	jg _loop1

	ret

SortStrings endp

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

;char * strcpy (char *dst, const char *src`, int count) 
;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest 
strcpy:
    push ebp
    mov ebp, esp
	sub esp, 16
	
	mov ebx, [ebp+8]
	mov [ebp-4], ebx
	mov ecx, [ebp+12]
	mov [ebp-8], ecx
	mov eax, [ebp+16]
	mov [ebp-16], eax
	
_strcpy_cyc:    
	mov	dl, byte ptr[ecx]
	mov byte ptr[ebx], dl

	cmp	dword ptr[ebp-16], 1
	je _strcpy_ret

	add dword ptr[ebp-4], 1
	mov ebx, [ebp-4]
	add dword ptr[ebp-8], 1
	mov ecx, [ebp-8]
	dec dword ptr[ebp-16]
	jmp	_strcpy_cyc
	
_strcpy_ret:
	mov byte ptr[ebx+1], 0
	mov eax, [ebp-4]
    mov esp, ebp
    pop ebp
    ret

;char * strcpy (char *dst, const char *src) 
;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest 
_strcpy:
    push ebp
    mov ebp, esp
	sub esp, 8
	
	mov ebx, [ebp+8]
	mov [ebp-4], ebx
	mov ecx, [ebp+12]
	mov [ebp-8], ecx
	
strcpy_cyc:    
	mov	dl, byte ptr[ecx]
	mov byte ptr[ebx], dl
	
	cmp	byte ptr[ecx], 0
	je strcpy_ret
	
	add dword ptr[ebp-4], 1
	mov ebx, [ebp-4]
	add dword ptr[ebp-8], 1
	mov ecx, [ebp-8]
	jmp	strcpy_cyc
	
strcpy_ret:
	mov eax, [ebp-4]
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
	mov eax, [ebp-4]
    mov esp, ebp
    pop ebp
    ret

; Генерация массива случайных чисел
GenerateRandomBuf proc buf:dword, bufSize:dword
    local i:dword

    mov [i], 0

    jmp while_cmp_generate

    while_body_generate:
        invoke crt_rand, 100000
        mov ecx, [i]
		mov ebx, [buf]
        mov dword ptr[ecx + ebx], eax

		add [i], 4
		dec bufSize
    
	while_cmp_generate:
		mov ecx, [i]
		mov ebx, [buf]
		cmp [bufSize], 0
		jne while_body_generate
    
    ret

GenerateRandomBuf endp



; Вывод массива чисел
PrintBuf proc buf:dword, bufSize:dword
    local i:dword

    mov [i], 0

    jmp while_cmp_PrintBuf

    while_body_PrintBuf:
		mov ecx, [i]
		mov ebx, [buf]
		
		invoke printf, offset format_eax, dword ptr[ecx + ebx]

		add [i], 4
		dec bufSize
    
	while_cmp_PrintBuf:
		mov ecx, [i]
		mov ebx, [buf]
		cmp [bufSize], 0
		jne while_body_PrintBuf

    ret
    
PrintBuf endp

;Вывод массива указателей на строки
PrintStringArray proc c array:dword
	local i:dword
	mov [i], 0
	.while 1
        mov ecx, [i]
        mov ebx, [array]
        
        invoke printf, offset format, dword ptr[ecx + ebx]
		add [i], 4
        
        mov ecx, [i]
        mov ebx, [array]
        .break .if !dword ptr [ecx + ebx]
    .endw
	ret
PrintStringArray endp

;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
_strcmp proc c string1:dword, string2:dword
	local i:dword
	
	mov [i], 0
	
strcmp_cyc:    
	mov ebx, [string1]
	mov ecx, [string2]
	mov eax, [i]

	mov dl, byte ptr [ebx+eax]
	mov dh, byte ptr [ecx+eax]
	
	cmp dl, 0
	je equal
	
	add [i], 4
	
	cmp dl, dh
	je strcmp_cyc 
	jl string1_string2
	jg string2_string1
	
string1_string2:
	mov eax, -1
	jmp strcmp_ret
	
equal:
	cmp dh, 0
    jne string1_string2
	mov eax, 0
	jmp strcmp_ret
	
string2_string1:
	mov eax, 1
    jmp strcmp_ret
	
strcmp_ret:
    ret

_strcmp endp



;char * strstr (const char *str, const char *strSearch);
;поиск первого вхождение строки strSearch в строке str, возвращает 0 если нет вхождений, 
;иначе указатель на первое вхождение, если strSearch нулевой длины, то возвращ указ на начало строки str
_strstr:
    push ebp
    mov ebp, esp
	sub esp, 16

    push [ebp+8]
    call _strlen
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

    add dword ptr[ebp-4], 1
	mov eax, [ebp-4]

    jmp strstr_start

strstr_count:
    add dword ptr[ebp-4], 1
	mov eax, [ebp-4]
	add dword ptr[ebp-8], 1
	mov ecx, [ebp-8]
    add dword ptr[ebp-16], 1
    jmp strstr_start

strstr_end1:
    cmp bl, 0
    je ststr_found
    jmp strstr_no

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