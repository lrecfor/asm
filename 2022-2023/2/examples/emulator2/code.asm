mov r0, 0x00abcdef
push r0

push r7
mov r7, r8
sub r8, 4

mov r1, r7
add r1, 8
mov r9, [r1]
mov r1, r7
sub r1, 4
mov r1, 0
  
cmp r9, 0
jz 0x00000ff8
add [r0], 1
add r9, 1
jmp 0x00000ff8
    
mov r9, [r0]
mov r8, r7
pop r7
ret