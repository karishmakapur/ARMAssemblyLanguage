//Karishma Kapur
// 2/28/19
// Problem 3

//define my raspberry pi
	.cpu cortex-a53
	.fpu neon-fp-armv8
	.syntax unified //modern syntax


.data
.balign 4
question: .asciz "Enter two positive numbers: "

.balign 4
message: .asciz "Prime numbers between %d and %d are: \n"

.balign 4
pattern: .asciz "%d"

.balign 4
printNum: .asciz " %d "

.balign 4
endLine: .asciz "\n"

.balign 4
number1: .word 0

.balign 4
number2: .word 0

.balign 4
link_pt: .word 0


//program code
	.text
	.align 2
	.global main
	.type main, %function

main: //non-leaf function
//prologue
	PUSH {fp, lr} //saving frame pointer and link register on stack
	ADD fp, sp, #0 //setting up the bottom of the stack frame
	SUB sp, sp, #32 //allocting some buffer on the stack

	//asking user for input "Enter two positive integers"
        LDR R0, addr_question
        BL printf

	//getting first number
        LDR R0, addr_pattern
        LDR R1, addr_number1
        BL scanf

	//getting second number
	LDR R0, addr_pattern
	LDR R1, addr_number2
	BL scanf

	//displaying prime numbers "Prime number between %d and %d are"
	LDR R0, addr_message
        LDR R1, addr_number1
        LDR R1, [R1] //R1 holds first number
	LDR R2, addr_number2
	LDR R2, [R2] //R2 holds second number
        BL printf

	LDR R4, addr_number1
	LDR R4, [R4]
	LDR R5, addr_number2
	LDR R5, [R5]
	//prepping for loop
//R4 = n1
//R5 = n2
//R6 = i
	ADD R6, R4, #0 //i = n1. R6 is i, R4 is n1
	B loop

loop:
	ADD R6, R6, #1 //++i
	CMP R6, R5 //comparing i and n2
	BHS end //if i =>  n2 then branch to end

	//if i < n2 then call checkPrimeNumber, written in C
	//and put return value into flag (R0)

//R0 is being passed as a parameter to the function, so R0 holds i
//at this moment
	MOV R0, R6
	BL checkPrimeNumber

	//MOV R0, R0 //return value from function will be placed into R0
	B ifstatement //branch to if statement

ifstatement:
//R0 = flag because after returning from the function, the return value
//is put into R0 register
	CMP R0, #1 //comparing flag and 1
	BNE loop //if they are not equal then loop again

	//if they are equal then print the number
	LDR R0, addr_printNum
	MOV R1, R6
	BL printf

	B loop //branch to loop

end:
	LDR R0, addr_endLine
	BL printf

	//MOV R0, #0 //setting return value
//epilogue
	SUB sp, fp, #0 //readjusting the stack pointer
	POP {fp, pc} //restoring frame pointer from stack and jumping
		    //to previously saved LR via direct load into PC


addr_link_pt:.word link_pt
addr_question: .word question
addr_message: .word message
addr_pattern: .word pattern
addr_number1: .word number1
addr_number2: .word number2
addr_printNum: .word printNum
addr_endLine: .word endLine
.global printf
.global scanf


