/* Program that converts a binary number to decimal */
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
            BL     DIVIDE
			STRB   R6, [R5,#3]  //Thousands digit is now in R6
			STRB   R7, [R5,#2]  //Hundreds digit is now in R6
            STRB   R1, [R5, #1] // Tens digit is now in R1
            STRB   R0, [R5]     // Ones digit is in R0
END:        B      END

/* Subroutine to perform the integer division R0 / 10.
 * Returns: quotient in R1, and remainder in R0
*/
DIVIDE:     MOV    R2, #0
			MOV     R3, #1000  //Needs to divide by 1000 first for 4 digits
CONT:       CMP    R0, R3
            BLT    SET_DIVISOR  //Everytime time R0 becomes less the divisor, it needs to divided by 10
            SUB    R0, R3
            ADD    R2, #1
            B      CONT

SET_DIVISOR: 		CMP R3,#1000  
					BGE SET_HUNDRED
					CMP R3,#100
					BGE SET_TEN
					CMP R3,#10   //END OF LOOP
					BGE DIV_END
					
SET_HUNDRED:    MOV R3,#100
				MOV R6,R2     //R6 holds the 1000th digit
				MOV R2,#0     //resets R2
				B  CONT
				
SET_TEN:    MOV R3,#10
			MOV R7,R2         //R7 holds the 100th digit
			MOV R2,#0     //resets R2
			B  CONT
			
			
DIV_END:    MOV    R1, R2     // quotient in R1 (remainder in R0)
            MOV    PC, LR

N:          .word  9876         // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
