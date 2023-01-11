.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include funs3c.inc


item struct
    key_ptr     dd ?
    value_ptr   dd ?
	next_ptr    dd ?
item ends

hash_table struct
	items_ptr	dd ?
    _size_		dd ?
    count		dd ?
hash_table ends


.data

.data?

.const
key1 db "111111",0
key2 db "222222",0
key3 db "333333",0
key4 db "444444",0
key9 db "999999",0
value1 db "value1",0
value2 db "value2",0
value3 db "value3",0
value4 db "value4",0
value9 db "value9",0

key11 db "rgijfekpofkkop",0
key22 db "rgipofkjfekkop",0
key33 db "rgikopjfekpofk",0
key44 db "fekrgijpofkkop",0
key55 db "kkrgiekjfpofop",0
value11 db "value11",0
value22 db "value22",0
value33 db "value33",0
value44 db "value44",0
value55 db "value55",0

.code


hash_function proc c uses ebx ecx edx pchar:ptr byte
	local i:byte
	mov [i], 0
	mov ebx, [pchar]
	.while byte ptr[ebx] != 0
		mov al, byte ptr[ebx]
		add [i], al
		inc ebx
	.endw
	mov al, [i]
	cbw
	cwde
	mov ebx, 500
	mov edx, 0
	div ebx
	mov eax, edx
	ret
hash_function endp


create_item proc c uses ebx ecx pkey:ptr byte, pvl:ptr byte
	local it:ptr item
	invoke malloc, sizeof(item)
	test eax, eax
	jz create_item_ret
	mov [it], eax
	mov ebx, [it]

	invoke crt_strlen, [pkey]
    inc eax
    invoke malloc, eax
    mov [ebx].item.key_ptr, eax
    invoke str_cpy, [ebx].item.key_ptr, [pkey]

    invoke crt_strlen, [pvl]
    inc eax
    invoke malloc, eax
    mov [ebx].item.value_ptr, eax
    invoke str_cpy, [ebx].item.value_ptr, [pvl]
	
	mov [ebx].item.next_ptr, 0

create_item_ret:
	mov eax, [it]
	ret
create_item endp


create_table proc c uses ebx ecx size_:dword
	local table:ptr hash_table

	invoke malloc, sizeof(hash_table)
	mov [table], eax
	mov ebx, [table]

	mov eax, [size_]
	mov [ebx].hash_table._size_, eax
	mov [ebx].hash_table.count, 0


	invoke calloc, [size_], 4
	mov [ebx].hash_table.items_ptr, eax

	mov eax, [table]
	ret
create_table endp


insert_item proc c uses ebx ecx ptbl:ptr hash_table, pkey:ptr byte, pvl:ptr byte
	local index:dword
	local it:ptr item
	local current_it:ptr item

	invoke create_item, [pkey], [pvl]
	mov [it], eax
	invoke hash_function, [pkey]
	mov [index], eax

	mov ebx, [ptbl]
	mov ebx, [ebx].hash_table.items_ptr
	add ebx, eax
	mov [current_it], ebx
	mov ecx, [ebx]

	.if ecx == 0
		mov ecx, [it]
		mov ebx, [ptbl]
		mov ebx, [ebx].hash_table.items_ptr
		add ebx, eax
		mov [ebx], ecx
	.else 
		invoke str_cmp, [ecx].item.key_ptr, [pkey]
		.if eax == 0
			mov ebx, [ptbl]
			mov ebx, [ebx].hash_table.items_ptr
			add ebx, [index]
			mov ecx, ebx
			mov ecx, [ecx]
			invoke str_cpy, [ecx].item.value_ptr, [pvl]
			ret
		.else	;;
			mov edx, ecx
			.while [ecx].item.next_ptr != 0
				mov ecx, [ecx].item.next_ptr
			.endw
			mov eax, [it]
			mov [ecx].item.next_ptr, eax
		.endif
	.endif
	mov ebx, [ptbl]
	inc [ebx].hash_table.count
	ret
insert_item endp


find_item_by_key proc c uses ebx ecx ptbl:ptr hash_table, pkey:ptr byte
	local index:dword
	local it:ptr item
	invoke hash_function, [pkey]
	mov [index], eax

	mov ebx, [ptbl]
	mov ebx, [ebx].hash_table.items_ptr
	add ebx, eax
	mov ecx, ebx

	mov [it], ecx
	mov ecx, [ecx]
	.if ecx != 0
		.while ecx != 0	;;
				invoke str_cmp, [ecx].item.key_ptr, [pkey]
				.if eax == 0
					mov eax, [ecx].item.value_ptr
					ret
				.endif
				mov ecx, [ecx].item.next_ptr
		.endw
	.endif

	mov eax, 0
	ret
find_item_by_key endp


find_item_by_value proc c uses ebx ecx ptbl:ptr hash_table, pkey:ptr byte
	local index:dword
	local it:ptr item
	invoke hash_function, [pkey]
	mov [index], eax

	mov ebx, [ptbl]
	mov ebx, [ebx].hash_table.items_ptr
	add ebx, eax
	mov ecx, ebx

	mov [it], ecx
	mov ecx, [ecx]
	.if ecx != 0
		.while ecx != 0
				invoke str_cmp, [ecx].item.key_ptr, [pkey]
				.if eax == 0
					mov eax, [ecx].item.value_ptr
					ret
				.endif
				mov ecx, [ecx].item.next_ptr
		.endw
	.endif

	mov eax, 0
	ret
find_item_by_value endp


main proc c argc:DWORD, argv:DWORD, envp:DWORD
	local tbl:ptr hash_table
	local i:dword

	invoke create_table, 150
	mov [tbl], eax
	invoke insert_item, [tbl], offset key2, offset value2
	invoke insert_item, [tbl], offset key3, offset value3
	invoke insert_item, [tbl], offset key1, offset value1
	;invoke find_item_by_key, [tbl], offset key2
	;invoke find_item_by_key, [tbl], offset key3
	;invoke find_item_by_key, [tbl], offset key4 ;;eax = 0 т.к. значение с таким ключом отсутствует

	;invoke insert_item, [tbl], offset key3, offset value9 ;;т.к. хэш совпадёт, значение заменится на value9
	
	invoke insert_item, [tbl], offset key11, offset value11
	invoke insert_item, [tbl], offset key22, offset value22
	invoke insert_item, [tbl], offset key33, offset value33
	invoke insert_item, [tbl], offset key44, offset value44
	invoke insert_item, [tbl], offset key55, offset value55

	invoke find_item_by_key, [tbl], offset key44

	mov eax, 0
	ret

main endp


end
