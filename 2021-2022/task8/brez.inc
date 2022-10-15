_draw_bird proc near
;square
	mov dx, 3 ;color
	push dx
	mov dx, 25 ;end_y
	push dx
	mov dx, 155 ;end_x
	push dx
	mov dx, 25 ;start_y
	push dx
	mov dx, 25 ;start_x
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 115
	push dx
	mov dx, 155 
	push dx
	mov dx, 25
	push dx
	mov dx, 155 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 115 
	push dx
	mov dx, 25 
	push dx
	mov dx, 115 
	push dx
	mov dx, 155
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 25 
	push dx
	mov dx, 25
	push dx
	mov dx, 115 
	push dx
	mov dx, 25 
	push dx
	call _brez
	add sp, 10
	
;left eye
	mov dx, 3 
	push dx
	mov dx, 45
	push dx
	mov dx, 55 
	push dx
	mov dx, 75
	push dx
	mov dx, 35 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 75 
	push dx
	mov dx, 45 
	push dx
	mov dx, 55
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 35
	push dx
	mov dx, 75 
	push dx
	mov dx, 75 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 60
	push dx
	mov dx, 65 
	push dx
	mov dx, 60
	push dx
	mov dx, 45 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 55 
	push dx
	mov dx, 60 
	push dx
	mov dx, 65
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 60 
	push dx
	mov dx, 45
	push dx
	mov dx, 75 
	push dx
	mov dx, 55 
	push dx
	call _brez
	add sp, 10
	
;right eye
	mov dx, 3 
	push dx
	mov dx, 45
	push dx
	mov dx, 125 
	push dx
	mov dx, 75
	push dx
	mov dx, 105 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 145 
	push dx
	mov dx, 45 
	push dx
	mov dx, 125
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 105
	push dx
	mov dx, 75 
	push dx
	mov dx, 145 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 60
	push dx
	mov dx, 135 
	push dx
	mov dx, 60
	push dx
	mov dx, 115 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 75 
	push dx
	mov dx, 125 
	push dx
	mov dx, 60 
	push dx
	mov dx, 135
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 60 
	push dx
	mov dx, 115
	push dx
	mov dx, 75 
	push dx
	mov dx, 125 
	push dx
	call _brez
	add sp, 10

;mouth
	mov dx, 2 
	push dx
	mov dx, 85
	push dx
	mov dx, 90 
	push dx
	mov dx, 95
	push dx
	mov dx, 65 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 2 
	push dx
	mov dx, 95 
	push dx
	mov dx, 115 
	push dx
	mov dx, 85 
	push dx
	mov dx, 90
	push dx
	call _brez
	add sp, 10

	mov dx, 2 
	push dx
	mov dx, 105 
	push dx
	mov dx, 90
	push dx
	mov dx, 95 
	push dx
	mov dx, 115 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 2 
	push dx
	mov dx, 95 
	push dx
	mov dx, 65
	push dx
	mov dx, 105 
	push dx
	mov dx, 90 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 2 
	push dx
	mov dx, 95 
	push dx
	mov dx, 115
	push dx
	mov dx, 95 
	push dx
	mov dx, 65 
	push dx
	call _brez
	add sp, 10
	
;cravat
	mov dx, 1 
	push dx
	mov dx, 125
	push dx
	mov dx, 80 
	push dx
	mov dx, 115
	push dx
	mov dx, 65 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 1 
	push dx
	mov dx, 115 
	push dx
	mov dx, 90 
	push dx
	mov dx, 125 
	push dx
	mov dx, 80
	push dx
	call _brez
	add sp, 10

	mov dx, 1 
	push dx
	mov dx, 125 
	push dx
	mov dx, 100
	push dx
	mov dx, 115 
	push dx
	mov dx, 90 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 1
	push dx
	mov dx, 115 
	push dx
	mov dx, 115
	push dx
	mov dx, 125 
	push dx
	mov dx, 100 
	push dx
	call _brez
	add sp, 10
	
;hair
	mov dx, 3 
	push dx
	mov dx, 25
	push dx
	mov dx, 115 
	push dx
	mov dx, 25
	push dx
	mov dx, 90 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 5 
	push dx
	mov dx, 115 
	push dx
	mov dx, 25 
	push dx
	mov dx, 115
	push dx
	call _brez
	add sp, 10

	mov dx, 3 
	push dx
	mov dx, 25 
	push dx
	mov dx, 90
	push dx
	mov dx, 5 
	push dx
	mov dx, 115 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 5
	push dx
	mov dx, 95 
	push dx
	mov dx, 25
	push dx
	mov dx, 90 
	push dx
	call _brez
	add sp, 10
	
	mov dx, 3 
	push dx
	mov dx, 13 
	push dx
	mov dx, 105 
	push dx
	mov dx, 5 
	push dx
	mov dx, 95
	push dx
	call _brez
	add sp, 10

	ret
_draw_bird endp