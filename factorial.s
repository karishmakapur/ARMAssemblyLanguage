// Karishma Kapur
// fibSequence.s
// Lab 3 Program 1

//my Raspberry pi B 3
	.cpu cortex-a53
	.fpu neon-fp-armv8
	.syntax unified

//data section
.data
.balign 4
message: .asciz "Please enter a number and I will find the factorial: "

.balign 4
output: .asciz "The factorial of %d is %u\n"

.balign 4
pattern: .asciz "%d"

.balign 4
number: .word 0

.balign 4
link_ptr1: .word 0

.balign 4
link_ptr2: .word 0

.balign 4
originalProductValue: .word 1

.balign 4
overflowMessage: .asciz "Aritmetic Overflow. Number entered is too big.\n"

//program code
.text
.global factorial
.type factorial, %function

factorial:
	//storing link register
	LDR R1, addr_link_ptr2
	STR lr, [R1]
loop:
	//multiplying the current number by what is stored in R2
	//R0 * R2  gives you a 64 bit result
	//so the first 32 bits will go into R5,
	//and the next 32 bits go into R6
	UMULLS R5,R6,R2,R0

	//if there is anything in R6, this means there is an overflow.
	//that is why I am comparing R6 with #0, once it doesn't
	//contain 0, branch to label overflow
	CMP R6, #0
	BNE overflow

	//putting the result from R5 into R2 because R5 contains 
	//first 32 bits of the product
	MOV R2, R5

	//subtracting the current number by 1
	SUB R0, R0, #1

	CMP R0, #1 //comparing R0 with 1

	//if the current number is not equal to 1, continute loop
	BNE loop

	//put r0 value into R0 and return back to main function
	MOV R0, R2

	//restoring link register back to original
	LDR lr, addr_link_ptr2
	LDR lr, [lr]
	BX lr

overflow:
	//print message to screen that there is an overflow
	LDR R0, addr_overflowMessage
	BL printf

	//exit to terminal
	MOV R7, #1
	SWI 0

.global main
main:
	//storing link register
	LDR R1, addr_link_ptr1
	STR lr, [R1]

	//displaying message to screen.
	LDR R0, addr_message //using R0, to pass argument
	BL printf //branching to c function

	//getting input from user
	LDR R0, addr_pattern //using R0 to tell what kind of input
	LDR R1, addr_number //using R1, to get input
	BL scanf

	//going to factorial function
	LDR R0, addr_number //putting address into R0
	LDR R0, [R0] //dereferencing and getting value and putting into R0
	LDR R2, addr_originalProductValue //putting #1 into R1, so when we multiply the number for the first time by this, it will stay the same (3x1=3)
	LDR R2, [R2] //deferencing and getting value and putting into R2
	BL factorial

	//returning back from factorial function
	//and storing return value into a register
	MOV R2, R0
	//printing the factorial to user
	LDR R0, addr_output //passing argument using R0 register
	LDR R1, addr_number
	LDR R1, [R1]
	BL printf

	//restoring link register back to original
	LDR lr, addr_link_ptr1
	LDR lr, [lr]
	BX lr


//address of variables made in data section
addr_link_ptr1: .word link_ptr1
addr_link_ptr2: .word link_ptr2
addr_message: .word message
addr_pattern: .word pattern
addr_number: .word number
addr_output: .word output
addr_originalProductValue: .word originalProductValue
addr_overflowMessage: .word overflowMessage

//wanting to use these functions, so I have to declare them as global, which makes them accessible
.global printf
.global scanf
