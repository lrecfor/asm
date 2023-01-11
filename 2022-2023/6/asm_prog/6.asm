;
; Модуль main.asm.
;
; Пример обращения к аргументам функции main.
;
; Маткин Илья Александрович 18.09.2013
;

.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include functions.inc

.data


.data?

.const

.code

ArrayCpy proc c dest:dword, src:dword, count:dword
	local i:dword
	mov [i], 0
ArrayCpy_cyc:    
	mov ecx, [i]
	mov ebx, [src]
	mov eax, [dest]

	mov	edx, dword ptr[ebx+ecx]
	xchg dword ptr[eax+ecx], edx
	
	cmp	[count], 0
	je ArrayCpy_ret
	
	add [i], 4
	dec count
	jmp	ArrayCpy_cyc
	
ArrayCpy_ret:
	mov eax, [dest]
	ret
ArrayCpy endp

;Реализовать функцию слияния двух отсортированных массивов указателей 
;на строки в новый отсортированный массив. Реализовать генерацию случайных 
;массивов указателей на строки. Воспользоваться функцией сортировки массива 
;указателей на строки из предыдущего задания.
ArrayCat proc c first:dword, second:dword
	local i:dword 
	local j:dword

	local count:dword
	local size_:dword
	local res:dword
	local offset_:dword

	local size1:dword
	local size2:dword

	mov [size1], 5
	mov [size2], 5

	mov [size_], 100	;;

	invoke malloc, [size_]
	test eax, eax
	jz ArrayCat_ret
	mov [res], eax

	mov [count], 10	
	mov [i], 0
	mov [j], 0
	mov [offset_], 0

	;; % ) : 0 7 8 I O O S

	.while [j] < 20 && [i] < 20
		mov ecx, [first]
		mov edx, [second]
		mov eax, [i]
		mov ebx, [j]

		invoke _strcmp, dword ptr[ecx+eax], dword ptr[edx+ebx]

		.if eax == -1 
			mov ebx, [res]
			mov edx, [offset_]
			mov ecx, [first]
			mov eax, [i]
			mov edi, dword ptr[ecx+eax]
			mov dword ptr[ebx+edx], edi
			add [i], 4
			add [offset_], 4
		.else 
			mov ecx, [res]
			mov eax, [offset_]
			mov edx, [second]
			mov ebx, [j]
			mov edi, dword ptr[edx+ebx]
			mov dword ptr[ecx+eax], edi
			add [j], 4
			add [offset_], 4
		.endif
	.endw

	.if [i] < 20
		.while [i] < 20
			mov ebx, [res]
			mov edx, [offset_]
			mov ecx, [first]
			mov eax, [i]
			mov edi, dword ptr[ecx+eax]
			mov dword ptr[ebx+edx], edi
			add [i], 4
			add [offset_], 4
		.endw
	.elseif [j] < 20
		.while [j] < 20
			mov ecx, [res]
			mov eax, [offset_]
			mov edx, [second]
			mov ebx, [j]
			mov edi, dword ptr[edx+ebx]
			mov dword ptr[ecx+eax], edi
			add [j], 4
			add [offset_], 4
		.endw
	.endif

	mov ebx, [res]
	mov edx, [offset_]
	mov dword ptr[ebx+edx], 0

	ArrayCat_ret:
	mov eax, [res]
    ret
ArrayCat endp

main proc c argc:DWORD, argv:DWORD, envp:DWORD
    local buf1:dword
	local buf2:dword
	local buffer:dword

	local i:dword
	local num:dword

	invoke malloc, 20
	test eax, eax
	jz main_ret
	mov [buf1], eax

	invoke malloc, 20
	test eax, eax
	jz main_ret
	mov [buf2], eax

	invoke GenStrings, [buf1], 5
	invoke GenStrings, [buf2], 5

	invoke SortStrings, [buf1], 5
	invoke SortStrings, [buf2], 5

	;;arraycat
	invoke ArrayCat, [buf1], [buf2]
	mov [buffer], eax

	;;print
	invoke PrintStringArray, [buffer]

main_ret:
	mov eax, 0
	ret

main endp


end
