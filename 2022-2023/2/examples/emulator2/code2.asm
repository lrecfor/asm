mov r0, 0x0A414141
push 0x0000fa0
add r0, 11122211
pop r0
hlt

push r7
mov r7, r8
sub r8, 4

mov r0, r7
add r0, 8
mov r9, [r0]
mov r0, r7
sub r0, 4
mov byte ptr[r0], 0
  
cmp byte ptr [r9], 0
je 0x00000ff8
add byte ptr[r7-4], 1
inc r9
jmp 0x00000ff8
    
mov r9, [r7-4]
mov r8, r7
pop r7
retn 4