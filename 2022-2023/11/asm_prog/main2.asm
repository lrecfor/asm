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
file db "C:\asm\input.txt", 0

format db "%s",13,10,0
format_eax db "%d", 0Dh, 0Ah, 0
format_c db "%c", 0Dh, 0Ah, 0
format_r db "r", 0
format_w db "w", 0
format_a db "a", 0

array dw 1,2,3,4,5,6,7,8,9

.code

fopen proto c :dword, :dword
fread proto c :dword, :dword, :dword, :dword
fwrite proto c :dword, :dword, :dword, :dword
fclose proto c :dword
printf proto c :VARARG
malloc proto c :dword

print_array proc c arg:DWORD

    local i:DWORD

	mov [i], 0

    jmp while_cmp
    
while_body:
    mov ecx, [i]
    mov ebx, [arg]
    invoke crt_printf, addr format, dword ptr[ecx + ebx]

    add [i], 4
    
while_cmp:
    mov ecx, [i]
    mov ebx, [arg]
    cmp dword ptr [ebx + ecx], 0
    jne while_body

    ret
    
print_array endp

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

replace proc
	push ebp
	mov ebp, esp
	sub esp, 16

    invoke fopen, dword ptr[ebp+8], addr format_r
	test eax, eax
	jz replace_ret
	mov [ebp-4], eax	;;file1

	push 512
    call malloc
    add esp, 4
    mov ebx, eax
    mov [ebp-8], ebx

    invoke fread, ebx, 1, 512, dword ptr[ebp-4]	;;read from file1
	test eax, eax
	jz replace_ret

    push [ebp-4]
	push offset format
	call printf
	add esp, 8

replace_ret:
	mov esp, ebp
	pop ebp
	ret
replace endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
	mov eax, argv
    mov ecx, dword ptr[eax + 16]
	push dword ptr[ecx]
    mov eax, argv
	mov ecx, dword ptr[eax + 12]
	push dword ptr[ecx]
    mov eax, argv
	mov ecx, dword ptr[eax + 8]
	push dword ptr[ecx]
    mov eax, argv
	mov ecx, dword ptr[eax + 4]
	push dword ptr[ecx]
	call replace
	add esp, 12

	mov eax, 0
	ret

main endp


end
