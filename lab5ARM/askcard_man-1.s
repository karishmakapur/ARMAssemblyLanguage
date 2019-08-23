.cpu cortex-a53
.fpu neon-fp-armv8

.data
.balign 4
prompt: .asciz "What number do you want to ask player 2 for? (You have to have that card): "

.balign 4
youask: .asciz "You asked: Do you have a %d\n"

.balign 4
computergofish: .asciz "Computer says: Go Fish\n"

.balign 4
drawmess: .asciz "You draw a card\n"

.balign 4
computeryes: .asciz "Computer Says: Yes, I do. Computer hands you them.\n"

.balign 4
finp: .asciz "%d"

.balign 4
pattern: .asciz "%d"

.balign 4
number: .asciz "%d"

.balign 4
gofish: .asciz "\nPlayer 1 Go Fish\n"

.balign 4
numberagain: .asciz "You need to enter a number between 1 - 13, and you have to have the number. Enter a new number: "

.text
.align 2
.global askcard_man
.type askcard_man, %function

askcard_man:
	push {fp, lr}
	add fp, sp, #4

	@r0 holds filepointer
	@r1 holds player1array
	@r2 holds player2array
	@r3 holds gamelog file pointer
	mov r4, r0
	mov r5, r1
	mov r6, r2
	mov r7, r3

	sub sp, sp, #4

//print prompt to screen
	ldr r0, prompt_addr
	bl printf

getnumber:
//getting number from user
	ldr r0, pattern_addr
	ldr r1, number_addr
	bl scanf

	ldr r8, number_addr
	ldr r8, [r8]
	cmp r8, #0
	beq getnumberAgain
	cmp r8, #13
	bgt getnumberAgain

	b continue

getnumberAgain:
	ldr r0, numberagain_addr
	bl printf

	ldr r0, pattern_addr
	ldr r1, number_addr
	bl scanf

	ldr r8, number_addr
        ldr r8, [r8]
        cmp r8, #0
        beq getnumberAgain
        cmp r8, #13
        bgt getnumberAgain

	b continue

continue:
//print "you ask:" to file
	mov r0, r7
        ldr r1, youask_addr
        ldr r2, number_addr
	ldr r2, [r2]
        bl fprintf

//offset & index
        ldr r8, number_addr //r8 = address of number
        ldr r8, [r8] //r8 = number
	sub r8, r8, #1 //decrease by 1 for index (r8 = number - 1);
	mov r9, #4
	mul r8, r8, r9 //get offset

//search array of player 2
	ldr r9, [r6, r8] //r9 = p2array[index]
	cmp r9, #0 //if r9 <= 0
	ble draw //go to draw

//print the computer does have number to file
	mov r0, r7
    	ldr r1, computeryes_addr
    	bl fprintf

	//else if r9 > 0, then transfer card to player1 array
	ldr r9, [r6, r8] //r9 = p2array[index]
	ldr r10, [r5, r8]//r10 = p1array[index]
	add r9, r9, r10 //add both numbers
	str r9, [r5, r8] //store in player 1 (p1array[index] = r9)
	mov r9, #0
        str r9, [r6, r8] //make 0 in player 2 (p2array[index] = 0)

	b end
draw:
//print go fish to screen
    ldr r0, gofish_addr
    bl printf

//print gofish to file
    mov r0, r7
    ldr r1, computergofish_addr
    bl fprintf

    mov r0, r4 //file pointer
    ldr r1, finp_addr
    mov r2, sp
    bl fscanf

//printing you draw a card to file
    mov r0, r7
    ldr r1, drawmess_addr
    bl fprintf

    mov r10, #4
    ldr r7, [sp] //get number from stack put into r7
    sub r7, r7, #1 //index based 0, so subtract 1
    mul r7, r7, r10 //offset
    ldr r8, [r5, r7] //r8 = array[index]
    add r8, r8, #1 //increasing value by 1
    str r8, [r5, r7] @r5[index] = r7 //array[index] = r8

end:
	sub sp, fp, #4
	pop {fp, lr}
	bx lr

prompt_addr: .word prompt
pattern_addr: .word pattern
number_addr: .word number
finp_addr: .word finp
gofish_addr: .word gofish
youask_addr: .word youask
computergofish_addr: .word computergofish
drawmess_addr: .word drawmess
computeryes_addr: .word computeryes
numberagain_addr: .word numberagain
