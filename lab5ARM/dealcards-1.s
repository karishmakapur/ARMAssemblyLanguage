.cpu cortex-a53 
.fpu neon-fp-armv8 

.data 
finp: .asciz "%d" 

.equ index0, 0 
.equ index1, 4 
.equ index2, 8
.equ index3, 12
.equ index4, 16
.equ index5, 20
.equ index6, 24

.extern fscanf 

.text 
.align 2 
.global dealcards 
.type dealcards, %function 
dealcards:
    push {fp, lr}
    add fp, sp, #4
    @fp stored in r0
    @p1cards in r1
    @p2cards in r2
    mov r4, r0 @fp
    mov r5, r1 @p1cards in r5
    mov r6, r2 @p2cards in r6

    sub sp, fp, #8 //moving to first empty position in stack

    mov r9, #0 //how many filled
    mov r8, #0 //r8 = index
loop:
   mov r7, #0 //r7 = number to fill with
   str r7, [r5, r8] //get value from player1array[index] = 0
//   cmp r9, #14 (0-13 = 14 values) //are 14 slots filled?
   add r8, r8, #4 //increase index
   add r9, r9, #1 //filled++
   cmp r9, #14 //(0 - 12 = 13 values) are 13 slots filled?
   blt loop

   mov r10, #4
   mov r9, #0 //how many filled

fillp1:
//player1
    mov r0, r4 //file pointer
    ldr r1, =finp
    mov r2, sp
    bl fscanf
    ldr r7, [sp] //get number from stack put into r7
    sub r7, r7, #1 //index based 0, so subtract 1
    mul r7, r7, r10 //offset
    ldr r8, [r5, r7] //r8 = array[index]
    add r8, r8, #1 //increasing value by 1
    str r8, [r5, r7] @r5[index] = r7 //array[index] = r8

    add r9, r9, #1 //filled++
    cmp r9, #7 //are 7 dealt?
    blt fillp1

    mov r9, #0 //how many filled

//player2
fillp2:
    mov r0, r4 //file pointer
    ldr r1, =finp
    mov r2, sp
    bl fscanf
    ldr r7, [sp] //get number from stack put into r7
    sub r7, r7, #1 //index based 0, so subtract 1
    mul r7, r7, r10 //offset
    ldr r8, [r6, r7] //r8 = array[index]
    add r8, r8, #1 //increasing value by 1
    str r8, [r6, r7] @r6[index] = r7 //array[index] = r8

    add r9, r9, #1 //filled++
    cmp r9, #7 //are 7 dealt?
    blt fillp2

end:
    add sp, sp, #4
    pop {fp, lr}
    bx lr
