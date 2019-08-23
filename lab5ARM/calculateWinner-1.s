.cpu cortex-a53
.fpu neon-fp-armv8

.text
.align 2
.global calculateWinner
.type calculateWinner, %function

calculateWinner:
	push {fp, lr}
	add fp, sp, #4

	@r0 holds p1pairs
	@r1 holds p2pairs
	mov r4, r0
	mov r5, r1

	cmp r4, r5
	bgt p1
	b p2
p1:
	mov r0, #1
	b end

p2:
	mov r0, #2
	b end

end:
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
