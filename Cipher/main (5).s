.cpu cortex-a53 
.fpu neon-fp-armv8 
.data 
promptStr: .asciz "Enter a word:"
inpStr: .asciz "%s" 
promptNum: .asciz "Enter a number to cipher by:"
pattern: .asciz "%d"
inpNum: .word 0

.text 
.align 2 
.global main 
.type main, %function 
main:
    push {fp, lr}
    add fp, sp, #4

    mov r0, #100
    bl malloc
    mov r4, r0

    ldr r0, =promptStr
    bl printf

    ldr r0, =inpStr
    mov r1, r4
    bl scanf

    ldr r0, =promptNum
    bl printf

    ldr r0, =pattern
    ldr r1, =inpNum
    bl scanf

    @ call cipher to cipher the word
    mov r0, r4
    ldr r1, =inpNum
    ldr r1, [r1]
    bl cipher

    mov r5, r0

    mov r0, #0
    sub fp, sp, #4
    pop {fp, pc}
