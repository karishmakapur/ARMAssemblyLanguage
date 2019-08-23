// Karishma Kapur
// fibSequence.s
// Lab 3 Program 1

//Define my RaspberyPi 3 B
	.cpu cortex-a53
	.fpu neon-fp-armv8
	.syntax unified

//data section
.data
.balign 4
output_message: .asciz "Arithmetic Overflow. The nth term is %u\n"

//Program Code
	.text
	.align 2
	.global main

main:
	MOV R1, #0 //putting value 0 into r1

	MOV R2, #1 //putting value 1 into r2

	ADD R3, R1, R2 //adding r1 + r2 and putting into r3.

loop:

	MOV R1, R2 //putting R2 value into R1
	MOV R2, R3 //putting R3 value into R2

	ADDS R3, R1, R2 //adding r1 + r2 and putting into r3. Using ADDS so it sets the flag


	BCC loop //looping again if the carry flag has not been set

	MOV R1, R2 //putting fib number into R1

	//printing to console output message
	LDR R0, addr_output_message
	BL printf

end:
	//exiting to terminal
	MOV R7, #1
	SWI 0

//address of varaible declared in data section
addr_output_message: .word  output_message

//wanting to use C function, so I have to make it accessible to be by saying .global
.global printf
