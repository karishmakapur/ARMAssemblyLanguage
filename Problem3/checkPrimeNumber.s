//Karishma Kapur
// 2/27/19
// Lab 4 Question 3

//My Raspberry pi
	.cpu cortex-a53
	.fpu neon-fp-armv8
	.syntax unified //modern syntax

//Program Code
	.text
	.align 2
	.global checkPrimeNumber
	.type checkPrimeNumber, %function


checkPrimeNumber: //leaf function
//prologue
	PUSH {R4, R5, R6, R7, FP} //pushing frame pointer (r11) onto stack
	ADD FP, SP, #0 //setting up the bottom of the stack frame

//allocating space on stack frame for variables
	//local variables onto stack
	SUB SP, SP, #12 //12 bytes allocated

//storing variables onto stack (pushing them)
	//R0 for n
	//R4 for j
	//R5 for flag
	STR R0, [FP, #-12] //putting the argument passed into R4 (r4 is n)
	MOV R4, #1 //putting start loop value of 1 into R5. (r5  is j)
	STR R4, [FP, #-8]  //putting j onto stack
	MOV R5, #1 //putting flag value of 1 into (r6 is flag)
	STR R5, [FP, #-4] //putting flag onto stack

//all the following is in the for loop
loopCheckStatement:

	ADD R4, R4, #1 //j++ is here because I primed loop to start
		       //with j = 1

//for loop condition (j <= n / 2)
        MOV R6, #2 //holds value to divide by
        UDIV R7, R0, R6 // result = n / 2
        CMP R4, R7 //comparing j and result
        BLS ifStatementCondition //if j <=  n / 2 then go to loop

	B end //if its not, then branch to end

ifStatementCondition:
//if statement condition (n%j == 0)
	UDIV R7, R0, R4 //unsigned division (result = n / j)
	MUL R7, R7, R4  //computing remainder (result = result * j)
	SUB R7, R0, R7 //remainder (n - result)

	CMP R7, 0 //comparing the modulus result and 0 (result == 0)
	BEQ ifstatementBody //if the modulus result = 0, then step
			//inside if statement

	B loopCheckStatement //else if not equal to 0 then loop again.

ifstatementBody:
	MOV R5, #0 //setting flag to 0
	B end //break loop and branch to end label

end:
//epilogue

	MOV R0, R5
	ADD sp, fp, #0 //readjusting stack pointer
	POP {R4, R5, R6, R7, FP} //restoring frame pointer
	BX lr //jumping back to main


