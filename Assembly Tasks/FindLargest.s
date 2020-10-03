/* Program that finds the largest number in a list of integers	*/

            .text                   // executable code follows
            .global _start                  
_start:                             
            MOV     R4, #RESULT     // R4 points to result location
            LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
            MOV     R1, #NUMBERS    // R1 points to the start of the list
            BL      LARGE           
            STR     R0, [R4]        // R0 holds the subroutine return value

END:        B       END             

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the lisst
 *             R1 has the address of the start of the list
 * Returns: R0 returns the largest item in the list
 */
LARGE:      LDR  R2,[R1]  //R2 holds the largest value so far  
CHECK:      SUBS R0,#1    //Subtract one each time the loop runs so that it doesn't exceed the number of elements
			BEQ  DONE
			ADD  R1,#4	  //Increments the address
			LDR  R3,[R1]  //Gets the next number
			CMP  R2,R3  //Compares the values
			BGE  CHECK
			LDR  R2,[R1]    //Moves value from address in R1 to R2 if it is larger
			B    CHECK
			
			
DONE:  		MOV  R0,R2   //Moves highest value from R2 to R0.
			MOV  PC,LR   //Moves program counter to the value in the link counter so that program goes back to the main routine
			

RESULT:     .word   0           
N:          .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
            .word   1, 8, 2                 

            .end                            

