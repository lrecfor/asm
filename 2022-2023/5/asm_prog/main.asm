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
file1 db "C:\asm\file1.txt", 0
file2 db "C:\asm\file2.txt", 0
string db "--------------------after sorting--------------------", 0

format db "%s",13,10,0
format_eax db "%d", 0Dh, 0Ah, 0
format_c db "%c", 0Dh, 0Ah, 0
format_r db "r", 0
format_w db "w", 0
format_a db "a", 0

.code

fopen proto c :dword, :dword
fread proto c :dword, :dword, :dword, :dword
fwrite proto c :dword, :dword, :dword, :dword
fclose proto c :dword
printf proto c :VARARG
malloc proto c :dword
rand proto c 
srand proto c:dword

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

;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
_strcmp proc
	push ebp
    mov ebp, esp
	sub esp, 8
	
	mov ebx, [ebp+8]
	mov [ebp-4], ebx
	mov ecx, [ebp+12]
	mov [ebp-8], ecx
	
strcmp_cyc:    
	mov dl, byte ptr [ebx]
	mov dh, byte ptr [ecx]
	
	cmp dl, 0
	je equal
	
	add dword ptr[ebp-4], 1
	mov ebx, [ebp-4]
	add dword ptr[ebp-8], 1
	mov ecx, [ebp-8]
	
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
	mov esp, ebp
    pop ebp	
    ret

_strcmp endp

;void CopyFile (const char * dstFileName, const char * srcFileName)
Copy proc
	push ebp
	mov ebp, esp
	sub esp, 16

	invoke fopen, dword ptr[ebp+8], addr format_r;offset file1, addr format_r
	test eax, eax
	jz Copy_ret
	mov [ebp-4], eax	;;file1

	invoke fopen, dword ptr[ebp+12], addr format_w ;offset file2, addr format_w
	test eax, eax
	jz Copy_ret
	mov [ebp-12], eax	;;file2

	push 1
	call malloc
	add esp, 4
	test eax, eax
	jz Copy_ret
	mov ebx, eax
	mov [ebp-8], ebx	;;start of buffer

Copy_loop:	;;copying
	invoke fread, ebx, 1, 1, dword ptr[ebp-4]	;;read 1 byte from file1
	test eax, eax
	jz Copy_ret

	mov ebx, dword ptr[ebp-8]
	invoke fwrite, ebx, 1, 1, dword ptr[ebp-12]	;;write 1 byte in file2
	test eax, eax
	jz Copy_ret

	jmp Copy_loop

Copy_ret:
	invoke fclose, [ebp-4]
	invoke fclose, [ebp-12]
	mov esp, ebp
	pop ebp
	ret
Copy endp

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

	;invoke printf, offset format, dword ptr[ebp-4]

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
		;mov edi, dword ptr[eax]
		mov dword ptr[ecx + ebx], eax;edi
		;invoke printf, offset format, eax

		add [i], 4
		dec count

		cmp count, 0
		jne m2

		ret
GenStrings endp

SortStrings proc c arg:DWORD, count:dword
	;mov eax, [buf]
	;invoke printf, offset format, dword ptr[eax+4]
	;mov ecx, [i]
	;mov ebx, [arg]
	;mov dword ptr[ecx + ebx], eax

	local i:dword
	local j:dword
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
		mov eax, [count]
		cmp [j], eax
		jl _loop2
	
	mov [i], 0
	mov [j], 0
	dec count
	cmp count, 0
	jg _loop1

	ret

SortStrings endp

AddNumber proc
	push ebp
	mov ebp, esp

	mov eax, [ebp+8]
	add eax, 1

AddNumber_ret:
	mov esp, ebp
	pop ebp
	ret
AddNumber endp

;void Map (int *buf, int size, int (*funPtr) (int))
Map proc c arg:DWORD, size_:DWORD, fun:DWORD
	local i:DWORD
	
	mov [i], 0

    jmp while_cmp_
    
while_body_:
    mov ecx, [i]
    mov ebx, [arg]

	push dword ptr[ecx + ebx]
	call fun
	add esp, 4
    mov dword ptr[ecx + ebx], eax

    add [i], 4
	dec size_
    
while_cmp_: 
    mov ecx, [i]
    mov ebx, [arg]
    cmp size_, 0
    jne while_body_

Map_ret:
	ret
Map endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
	local buf:dword
	local buffer[10]:dword
	local er:dword
	local i:dword

	invoke srand, 15

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;mov ebx, [buffer]
	;mov ecx, 10

	;m1:
	;mov dword ptr[ebx], ecx
	;add ebx, 4
	;dec ecx
	;cmp ecx, 0
	;jne m1

	;push AddNumber
	;push 10
	;push [buffer]
	;call Map
	;add esp, 12

	push 10
	call malloc
	add esp, 4
	test eax, eax
	jz main_ret
	mov [buf], eax
	mov ebx, 10
	mov [i], 0

	m1:
	mov ecx, [i]
	mov eax, [buf]
	mov dword ptr[ecx + eax], ebx
	add [i], 4
	dec ebx
	cmp ebx, 0
	jne m1

	push AddNumber
	push 10
	mov eax, [buf]
	push eax
	call Map
	add esp, 12

	mov [i], 0
	mov [er], 0
	lll:
	mov ecx, [i]
    mov ebx, [buf]
	invoke printf, offset format_eax, dword ptr[ecx + ebx]
	add [i], 4
	inc [er]
	cmp [er], 10
	jl lll

main_ret:
	mov eax, 0
	ret

main endp


end
