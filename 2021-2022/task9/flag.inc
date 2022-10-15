_draw_line_xcycle proc near
    push bp
    mov bp, sp

    mov bx, word ptr [bp + arg1] ;start_x
    mov dx, word ptr [bp + arg2] ;start_y
	mov cx, word ptr [bp + arg3] ;len
	mov ax, word ptr [bp + arg4] ;color
	mov si, word ptr [bp + 12]
	
_draw_line_xcycle_cyc:
	push ax
	push dx
	mov ax, dx
	mov di, 320
	mul di
	add ax, bx
	mov dx, ax
	mov di, dx
	pop dx
	pop ax
	
	stosb
	inc bx
	dec cx
	
	cmp cx, 0
	jz _draw_line_xcycle_n
	cmp si, 0
	jz _draw_line_xcycle_ret
	
	jmp _draw_line_xcycle_cyc

_draw_line_xcycle_n:
	mov cx, word ptr [bp + arg3]
	dec si
	inc dx
	mov bx, word ptr [bp + arg1]
	jmp _draw_line_xcycle_cyc
    
_draw_line_xcycle_ret:
    mov sp, bp
    pop bp
    ret
_draw_line_xcycle endp  

_draw_island proc near
	mov dx, 15
	push dx
	mov dx, 1h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_xcycle
	add sp, 8
	mov dx, 15
	push dx
	mov dx, 1h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 90 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_xcycle
	add sp, 8
	mov dx, 15
	push dx
	mov dx, 1h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_xcycle
	add sp, 8
	mov dx, 5
	push dx
	mov dx, 1h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 120 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_xcycle
	add sp, 8
	
_draw_island_white:
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 95 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 50		;len
    push dx
    mov dx, 95 		;start_y
    push dx
    mov dx, 150 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 50		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 150 	;start_x
    push dx
    call _draw_line_x
	add sp, 8
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 140 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 150 	;start_x
    push dx
    call _draw_line_y
	add sp, 8
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 150 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	
	mov dx, 0Fh		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 140 	;start_x
    push dx
    call _draw_line_y
	add sp, 8
	
_draw_island_red:
	mov dx, 4h		;color
	push dx
    mov dx, 21		;len
    push dx
    mov dx, 96 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	
	mov dx, 4h		;color
	push dx
    mov dx, 21		;len
    push dx
    mov dx, 104 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8
	
	mov dx, 4h		;color
	push dx
    mov dx, 51		;len
    push dx
    mov dx, 96 		;start_y
    push dx
    mov dx, 149 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	
	mov dx, 4h		;color
	push dx
    mov dx, 51		;len
    push dx
    mov dx, 104 		;start_y
    push dx
    mov dx, 149 	;start_x
    push dx
    call _draw_line_x
	add sp, 8
	
	mov dx, 4h		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 141 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	
	mov dx, 4h		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 149 	;start_x
    push dx
    call _draw_line_y
	add sp, 8
	
	mov dx, 4h		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 149 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	
	mov dx, 4h		;color
	push dx
    mov dx, 20		;len
    push dx
    mov dx, 105 		;start_y
    push dx
    mov dx, 141 	;start_x
    push dx
    call _draw_line_y
	add sp, 8

_draw_flag_red:
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 97 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 98 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 99 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 100 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 101 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 102 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8
	mov dx, 4h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 103 		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_x
	add sp, 8	

	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 142 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 143 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 143 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 144 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 145 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 146 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 147 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	mov dx, 4h		;color
	push dx
    mov dx, 49		;len
    push dx
    mov dx, 76 		;start_y
    push dx
    mov dx, 148 	;start_x
    push dx
    call _draw_line_y
	add sp, 8	
	
	mov dx, 0h		;color
	push dx
    mov dx, 79		;len
    push dx
    mov dx, 125		;start_y
    push dx
    mov dx, 121 	;start_x
    push dx
    call _draw_line_xcycle
	add sp, 8

	ret
_draw_island endp