.cpu cortex-a53 
.fpu neon-fp-armv8 
.data 
.text 
.align 2 
.global modulo 
.type modulo, %function 
modulo:
    push {lr}
    udiv r2, r0, r1
    mul r2, r2, r1
    sub r0, r0, r2
    pop {pc}
