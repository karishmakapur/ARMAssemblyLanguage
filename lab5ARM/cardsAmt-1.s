.cpu cortex-a53 
.fpu neon-fp-armv8 
.data 
.text 
.align 2 
.global cardsAmt 
.type cardsAmt, %function 

cardsAmt:
    push {fp, lr}
    add fp, sp, #4

    @r0 has p1 array
    mov r5, r0

    mov r4, #0 //number of cards used
    mov r7, #0 //offset
    mov r10, #0 //number of indexes looped through

loopArray1:
   ldr r8, [r5, r7]
   add r4, r4, r8 //hold amount of cards
   add r7, r7, #4 //offset incremement
   add r10, r10, #1 //number of indexes looped through
   cmp r10, #13 //less than 14 indexes, loop agian
   blt loopArray1
   b end

end:
    mov r0, r4 //update cards used

    sub sp, fp, #4
    pop {fp, pc}
    bx lr
