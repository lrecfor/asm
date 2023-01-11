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
format_s db "%s",13,10,0
format_d db "%d", 0Dh, 0Ah, 0
format_c db "%c", 0Dh, 0Ah, 0
format_r db "r", 0
format_w db "w", 0
format_a db "a", 0

.code

printf proto c :dword, :vararg
malloc proto c :dword
free proto c:dword
rand proto c

;;функции работы со строками с использованием строковых инструкций
;;////////////////////////////////////////////////////////////////


;;char * strstr (const char *str, const char *strSearch);
;;поиск первого вхождение строки strSearch в строке str, возвращает 0 если нет вхождений, 
;;иначе указатель на первое вхождение, если strSearch нулевой длины, то возвращ указ на начало строки str
str_str proc c uses ecx pstr:dword, pstrSearch:dword
	invoke crt_strlen, [pstrSearch]
	;.if eax = 0
	;	mov eax, [pstrSearch]
	;	ret
	;.endif

	cmp eax, 0
	jz str_str_null
	str_str_null:
		mov eax, [pstrSearch]
		ret


	invoke crt_strlen, [pstr]
	
	cld
	mov ecx, eax
	mov edi, [pstr]
	mov esi, [pstrSearch]
	mov al, byte ptr[esi]
	repne scasb
	jz str_str_ret

	mov eax, 0
	ret

	str_str_ret:
		mov eax, edi
		dec eax	;;

	ret
str_str endp


;;char * strcpy (char *dst, const char *src`, int count) 
;;копирует строку src в строку dest, копирование вместе с \0, возвращает указатель на dest
str_cpy proc c uses ecx pdst:dword, psrc:dword

	invoke crt_strlen, [psrc]
	cld 
	lea ecx,[eax + 1]	
	mov esi, [psrc]		
	mov edi, [pdst]	
	rep movsb

	mov eax, [pdst]
	ret

str_cpy endp


;;int strlen(const char *str)
;;находит длинну строки (до завершающего нуля), адрес которой является аргументом
str_len proc c uses ecx pstr:dword

	cld
	
	mov edi, [pstr]
	mov ecx, 0FFFFFFFFh
	mov al,0
	repne scasb
	mov eax, 0FFFFFFFFh - 1
	sub eax, ecx
	
	ret

str_len endp


;;char * strcat (char *dst, const char *src) 
;;конкатенация, возвращает указатель на dest
str_cat proc c uses ebx ecx pdst:dword, papp:dword
	mov ebx, [pdst]
	invoke crt_strlen, [pdst]
	add [pdst], eax

	invoke crt_strlen, [papp]

	cld 
	lea ecx,[eax + 1]
	mov esi, [papp]
	mov edi, [pdst]	
	rep movsb

	mov eax, ebx
	ret

str_cat endp


;int strcmp (const char *string1, const char *string2) 
;сравнение строк, возвращает <0 string1<string2, =0 string1=string2, >0 string1>string2
str_cmp proc c uses ecx pstr1:dword, pstr2:dword
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


;char * strchr (const char *str, int c) 
;поиск первого вхождения символа с в строку str, возвращает указатель на символ, если не найден 0
str_chr proc c uses ecx pstr:dword, symbol:dword
	invoke crt_strlen, [pstr]
	
	cld
	mov ecx, eax
	mov edi, [pstr]
	mov al, byte ptr[symbol]
	repne scasb
	jz str_chr_ret

	str_chr_ret:
		mov eax, edi
		dec eax	;;
	ret
str_chr endp


;;char * strncpy (char *dst, const char *src`, int maxlen) 
;;копирует maxlen элементов из src в строку dest, возвращает указатель на dest
;;если maxlen > длины строки, заполняет разницу 0
str_n_cpy proc c uses ebx ecx pdst:dword, psrc:dword, maxlen:dword
	invoke crt_strlen, [psrc]
	lea ebx, [eax+1]

	cld 
	mov ecx, [maxlen]
	mov esi, [psrc]		
	mov edi, [pdst]	
	rep movsb

	.if ebx < [maxlen]
		mov ecx, [maxlen]
		sub ecx, ebx
		cld
		xor eax, eax
		mov al, 0
		rep stosb
	.endif

	mov eax, [pdst]
	ret

str_n_cpy endp


;char * strnlen (char *str, int maxlen)
;возвращает длину строки, если длина строки меньше maxlen, или maxlen, 
;если в строке str среди первых символов до maxlen не встретится символ '\0' 
str_n_len proc c uses ecx pstr:dword, maxlen:dword

	cld
	
	mov edi, [pstr]
	mov ecx, [maxlen]
	mov al,0
	repne scasb
	sub ecx, [maxlen]
	neg ecx
	mov eax, ecx

	ret
str_n_len endp


;;char * strncat (char *dst, const char *src, int maxlen) 
;;конкатенирует maxlen символов из src, возвращает указатель на dest
str_n_cat proc c uses ebx ecx pdst:dword, papp:dword, maxlen:dword
	mov ebx, [pdst]
	invoke crt_strlen, [pdst]
	add [pdst], eax

	cld 
	mov ecx, [maxlen]
	mov esi, [papp]
	mov edi, [pdst]	
	rep movsb

	mov ecx, [maxlen]
	add [pdst], ecx
	mov ecx, [pdst]
	mov dword ptr[ecx], 0
	mov eax, ebx
	ret

str_n_cat endp


;char * strncmp (char *str1, const char *str2, int maxlen)
str_n_cmp proc c uses ecx pstr1:dword, pstr2:dword, maxlen:dword
	cld
	mov ecx, [maxlen]
	mov esi, [pstr1]
	mov edi, [pstr2]
	repe cmpsb
	jg greater
	jl less

	mov eax, 0
	ret

	greater:
		mov eax, 1
		ret
	less:
		mov eax, -1
		ret
str_n_cmp endp
;;////////////////////////////////////////////////////////////////
