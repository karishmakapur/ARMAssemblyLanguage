.cpu cortex-a53 
.fpu neon-fp-armv8 
.data 
.text 
.align 2 
.global gameover 
.type gameover, %function 

gameover:
    push {fp, lr}
    add fp, sp, #4

    @r0 has p1 array
    mov r5, r0

    mov r4, #0 //done = 0 if no players have all 4's of cards on hand
    mov r7, #0 //offset
    mov r10, #0 //number of indexes looped through

loopArray:
   ldr r8, [r5, r7]

   cmp r8, #0
   beq keeplooping

   cmp r8, #1
   beq notDoneGame

   cmp r8, #2
   beq notDoneGame

   cmp r8, #3
   beq notDoneGame

   cmp r8, #4
   beq keeplooping


   beq loopArray

//not done game as long as player does not have all 4 cards of that value
notDoneGame:
   mov r4, #0
   b end

//check next index to see if the player has 0 or 4 cards of the next value
keeplooping:
   add r7, r7, #4

   cmp r7, #48
   beq done2

   b loopArray

done2:
   mov r4, #1
   b end

end:
    mov r0, r4 //update done

    sub sp, fp, #4
    pop {fp, pc}
    bx lr
