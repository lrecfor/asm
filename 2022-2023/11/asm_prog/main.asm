.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac

.data

f1 dd 0.0001

d1 dd 10000
d2 dd 1

f6 dq 1000000.0
f5 dq 30.0
f dq 10.0

f2 dq 0.2
f3 dq 4.0
f4 dq 478.0987
ff dd ?

.data?

.const

.code


x2 proc ;x:QWORD
	;fld x
	fmul st, st(0)

	ret
x2 endp


IntSum proc a:DWORD, b:DWORD, fun:DWORD
	local i:DWORD
	local sum:QWORD
	local elem:QWORD

	fldz
	fst sum
	fstp st(0)

	fld i
	fild a
	fild b
	fsub st, st(1)
	fimul d1

	fcomp st(2)
	fstsw ax
    sahf
	jg @
	ret

	@:
		fld f1
		fmul st, st(2)
		faddp st(1), st
		call [fun]
		fld f1
		fmulp st(1), st
		fadd sum
		fst sum
		fstp st(0)
		fld1
		faddp st(1), st

		fild a
		fild b
		fsub st, st(1)
		fimul d1
		fcomp st(2)
		fstsw ax
		sahf
		jg @

	invoke crt_printf, $CTA0("%f"), [sum]

	ret
IntSum endp


print_f proc num:QWORD
	local symb:DWORD
	finit
	fld f
	fld num
	@:
	fprem
	fstcw word ptr [d2]
	or [d2], 0400h
	fldcw word ptr [d2]
	frndint

	ftst
    fstsw ax
    sahf
	jz @@_

	fistp symb
	add [symb], 30h
	invoke crt_printf, $CTA0("%c"), [symb]

	ftst
    fstsw ax
    sahf
	jz @@_

	fld num
	fdiv st, st(1)
	fst num
	jmp @

	@@_:
	ret
print_f endp


transform_f proc x:QWORD
	local i:DWORD
	local a:DWORD
	local res:DWORD
	local num1:QWORD
	
	;;обработка целой части
	fld x
	fld st(0)
	fstcw word ptr [d2]
	or [d2], 0400h
	fldcw word ptr [d2]
	frndint
	fsub st(1), st
	fstp a
	finit

	fld f
	fld f
	fld a

	mov [i], 0
	
	@:	
	fprem
	fstcw word ptr [d2]
	or [d2], 0400h
	fldcw word ptr [d2]
	frndint

	ftst
    fstsw ax
    sahf
	jz @@_

	.if [i] > 0
		fld num1 
		fmul st, st(2)
		faddp st(1), st
	.endif

 	fstp num1
	fld a
	fdiv st, st(2)
	fst a

	inc [i]
	jmp @

	@@_:
	invoke print_f, [num1]

	;;точка
	invoke crt_printf, $CTA0(".")

	;;обработка дробной части

	finit
	fld x
	fld st(0)
	fstcw word ptr [d2]
	or [d2], 0400h
	fldcw word ptr [d2]
	frndint
	fsubp st(1), st
	fld1
	
	mov [i], 0

	@@@:
	fld f
	fmulp st(2), st
	fld st(1)
	fprem
	fsub st(2), st
	fxch st(2)
	
	inc [i]
	.if [i] == 6
		je @@@_
	.endif

	fistp res
	add [res], 30h
	invoke crt_printf, $CTA0("%c"), [res]
	jmp @@@

	@@@_:
	finit
	ret
transform_f endp


pow_x proc x:QWORD, y:QWORD
	local res:QWORD
	fld y
	fld x
	fyl2x
	fld st(0)
	frndint
	fsubr st(0), st(1)
	f2xm1
	fld1
	faddp
	fscale
	fst st(0)
	fstp res
	finit
	
	invoke crt_printf, $CTA0("%f"), res
	ret
pow_x endp


main proc c argc:DWORD, argv:DWORD, envp:DWORD

	invoke crt_printf, $CTA0("IntSum: ")
    invoke IntSum, 1, 10, x2
	;invoke crt_printf, $CTA0("sum = %d"), eax

	invoke crt_printf, $CTA0("\ntransform_f: ")
	invoke transform_f, f4

	invoke crt_printf, $CTA0("\npow_x: ")
	invoke pow_x, f2, f3
	;invoke crt_printf, $CTA0("result = %d"), eax

	mov eax, 0
	ret

main endp


end
