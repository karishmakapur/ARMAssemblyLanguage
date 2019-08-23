.cpu cortex-a53 
.fpu neon-fp-armv8 
.data 
prompt1: .asciz "%c"
prompt2: .asciz "The cipher word is %s\n" 
.text 
.align 2 
.global cipher 
.type cipher, %function 
cipher:
    push {fp, lr}
    add fp, sp, #4
    mov r7, r1 @ r7 contains the number to cipher by

    @ The input string is in r0
    mov r5, r0 @ r5 contains original string
    bl strlen
    mov r6, r0 @ r6 contains the string length

    //mov r7, r1 @ r7 contains the number to cipher by

    @ clear the buffer
    ldr r0, =prompt1
    sub r1, sp, #4
    bl scanf

    mov r0, #100
    bl malloc

    mov r8, r0 @r8 will contain the cipher word

    mov r10, #-1 @ r10 holds loop counter

loop:
    add r10, r10, #1 @ adding 1 to loop counter
    cmp r10, r6 @seeing if I am at end of string
    beq done @ if yes, then done

    add r2, r5, r10
    ldrb r9, [r2]
    b increment

increment:
   add r2, r9, r7
   cmp r2, #122
   ble store

   sub r2, r2, r7
   add r2, r2, #97
   sub r2, r2, #1
   b store

store:
//   add r3, r8, r10
//   strb r9, [r2]
   strb r2, [r5, r10]

   b loop 

done:
 //  add r3, r5, r10
  // ldrb r9, [r3]

  // add r3, r8, r10
  // strb r9, [r3]

   mov r1, r5
   ldr r0, =prompt2
   bl printf

   mov r0, r8

   sub fp, sp, #4
   pop {fp, pc}
