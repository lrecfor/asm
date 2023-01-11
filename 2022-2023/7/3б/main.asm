.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\msvcrt.inc
include c:\masm32\include\kernel32.inc
include c:\masm32\include\user32.inc

include Strings.mac
include funs3b.inc

binary_node_tree struct
    left_ptr    dd ?
    right_ptr   dd ?
    key_ptr     dd ?
    value_ptr   dd ?
binary_node_tree ends

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

.code


find_value_by_key proc c uses ebx ecx proot:ptr binary_node_tree, pkey:ptr byte
    local bnt:ptr binary_node_tree

    invoke find_node_by_key, [proot], [pkey]
    mov [bnt], eax

    .if [bnt] == 0
        mov eax, 0
        ret
    .endif

    mov eax, [bnt]
    mov eax, [eax].binary_node_tree.value_ptr
    ret
find_value_by_key endp


main proc c argc:DWORD, argv:DWORD, envp:DWORD
	local head:ptr binary_node_tree
	
	invoke create_binary_node_tree, offset key2, offset value2
    mov [head], eax
    invoke insert_value_by_key, [head], offset key1, offset value1
    invoke insert_value_by_key, [head], offset key3, offset value3
    invoke insert_value_by_key, [head], offset key4, offset value4

    ;;итоговое дерево:
    ;;      2
    ;;  1      3
    ;;            4

    invoke find_node_by_key, [head], offset key4
    invoke find_node_by_key, [head], offset key9    ;;возвращает ноль, т.к. такого ключа в дереве нет
    invoke find_value_by_key, [head], offset key3


	mov eax, 0
	ret

main endp


end
