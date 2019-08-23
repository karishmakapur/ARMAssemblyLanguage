.cpu cortex-a53
.fpu neon-fp-armv8

.data
.balign 4
pairs: .asciz "You have a pair of %d's\n"

.text
.align 2
.global laydowncards
.type laydowncards, %function

laydowncards:
	push {fp, lr}
	add fp, sp, #4

	@r0 holds filepointer
	@r1 holds array
	@r2 holds gamelog file pointer
	mov r4, r0
	mov r5, r1
	mov r9, r2 

	mov r6, #0 //number of pairs = 0 at start
	sub sp, sp, #4

//	mov r9, #0 //number of indexes looped through
	mov r10,#0 //offset

loopArray:
	ldr r8, [r5, r10] //r8 = array[index]
	cmp r8, #2
	bge pair
	b nopair
nopair:
	//else if the number is less then 2, then there are no pairs
	add r10, r10, #4//increase index

	cmp r10, #48 //compare with 13
	ble loopArray //less than or equal to 13
	b end //greater than

pair:
	sub r8, r8, #2 // r8 = r8 - 2
	mov r0, #4
	udiv r10, r10, r0
	add r7, r10, #1 //#ofindexs + 1 = number (r7 holds number)
	mul r10, r10, r0

	ldr r0, pairs_addr
	mov r1, r7 //put value into r1 to pass as argument
	bl printf //print number

	mov r0, r9
	ldr r1, pairs_addr
	mov r2, r7
	bl fprintf

	add r6, r6, #1 //increase amount of pairs

	cmp r8, #2
	beq pair

	add r10, r10, #4//increase index

	cmp r10, #48 //compare with 13
        ble loopArray //less than or equal to 13
        b end //greater than


end:
	mov r0, r6 //return number of pairs
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
pairs_addr: .word pairs
