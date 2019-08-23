.cpu cortex-a53
.fpu neon-fp-armv8

.data
.balign 4
gofish: .asciz "\nPlayer 2 Go Fish\n"

.balign 4
player1gofish: .asciz "You say: Go Fish\n"

.balign 4
drawmess: .asciz "Computer draws a card\n"

.balign 4
player1yes: .asciz "You say: Yes, I do. Player1 hands computer them.\n"

.balign 4
finp: .asciz "%d"

.balign 4
compask: .asciz "Computer asks: Do you have a %d\n"

.text
.align 2
.global askcards_auto
.type askcards_auto, %function

askcards_auto:
    push {fp, lr}
    add fp, sp, #4

    @r0contains file pointer
    @r1 contains p2array
    @r2 contains p1array
    @r3 contains gamelog pointer
    mov r4, r0
    mov r5, r1
    mov r6, r2
    mov r7, r3

    sub sp, sp, #4

    mov r0, #0
    bl time
    bl srand

getrandom:
        bl rand //generate a random number. return random number in r0
        mov r9, r0 //put random number in r9, to not lose value
//        bl modulo //get the remainder of 0 - 13
//modulus
	mov r8, #13 //13 is the number to divide by
	udiv r10, r9, r8 //r10 = r9 / r8
	mul r10, r10, r8 //r10 = r10 * r8
	sub r9, r9, r10 //r9 = r9 - r10 -> remainder in r9

	cmp r9, #0 //if the random number = 0, generate a new random number
	beq getrandom

index:
	sub r9, r9, #1 //decrease by 1 for index (r9 = number - 1);
        mov r8, #4
        mul r9, r8, r9 //getting offset r9 holds the value

checking:
	ldr r10, [r6, r9] //get amount of number in r10
	cmp r10, #0
	beq getrandom //generate a new random number

//computer asks message to file
	udiv r9, r9, r8
	add r9, r9, #1

        mov r0, r7
        ldr r1, compask_addr
        mov r2, r9
        bl fprintf

	sub r9, r9, #1
	mul r9, r9, r8

	b getnumber

getnumber:
	ldr r10, [r5, r9] //r10 = p1array[index]
	cmp r10, #0
	beq draw

getcard:
//player 1 has card message to file
	mov r0, r7
	ldr r1, player1yes_addr
	bl fprintf

	//else if r9 > 0, then transfer card to player1 array
	ldr r10, [r5, r9] //r10 = p1array[index]
	ldr r0, [r6, r9] //r0 = p2array[index]
	add r10, r10, r0 //add both numbers
	str r10, [r6, r9] //store in player2 array (p2array[index] = r10)
	mov r10, #0
	str r10, [r5, r9] //make 0 in player 1 array (p1array[index] = 0)

	b end

draw:
    ldr r0, gofish_addr
    bl printf

//gofish printed to file
    mov r0, r7
    ldr r1, player1gofish_addr
    bl fprintf

    mov r0, r4 //file pointer
    ldr r1, finp_addr
    mov r2, sp
    bl fscanf

//computer draws a card printed to file
    mov r0, r7
    ldr r1, drawmess_addr
    bl fprintf

    mov r10, #4
    ldr r7, [sp] //get number from stack put into r7
    sub r7, r7, #1 //index based 0, so subtract 1
    mul r7, r7, r10 //offset

    ldr r8, [r6, r7] //r8 = p2array[index]
    add r8, r8, #1 //increasing value by 1
    str r8, [r6, r7] @r6[index] = r7 //p2array[index] = r8

end:
    sub sp, fp, #4
    pop {fp, lr}
    bx lr

gofish_addr: .word gofish
finp_addr: .word finp
player1gofish_addr: .word player1gofish
drawmess_addr: .word drawmess
player1yes_addr: .word player1yes
compask_addr: .word compask
