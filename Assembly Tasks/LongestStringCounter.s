/* Program that counts consecutive 1s,alternating 1s and 0s as well as consecutive 0s */

          .text                   // executable code follows
          .global _start                  
_start:                             
          MOV     R3, #TEST_NUM   // load the data word ...
		  MOV     R5, #0          //R5 will hold the result for consecutive ones
		  MOV     R7, #0		  //R7 will hold the result for consecutive alternates
		  MOV     R6, #0		  //R6 will hold the result for consecutive zeros
		  MOV     R8,#ALTERNATING_NUMS1             
		  LDR     R8, [R8]           				//R8 will hold an alternating number starting with 1
		  MOV     R9,#ALTERNATING_NUMS2 			
		  LDR     R9, [R9]                                           //R9 will hold an alternating number starting with 0
		  
		  
LOOP:     LDR     R1, [R3]        //Loads data into R1. R3 is used to access a new word
		  CMP     R1,#0
		  BEQ     END
		  MOV     R0, #0		     // R0 will hold the result
		  BL      ONES
		  CMP     R0,R5              //Checks if return value from loop s greater than the current longest chain of 1s     
		  BLE     SKIP0               //R5 retains value if R0 is smaller      	
          MOV     R5,R0			     //Else R5 is now equal to the value held by R0
SKIP0:	  LDR     R1, [R3] 			//Reloads intial value into R1
		  MOV     R0, #0		     // R0 will hold the result
		  BL      ZEROS
		  CMP     R0,R6        		//Checks if return value from loop s greater than the current longest chain of 0s
		  BLE     SKIP1				//R6 retains value if R0 is smaller
		  MOV     R6,R0				//Else R6 is now equal to the value held by R0
SKIP1:	  LDR     R1, [R3] 			//Reloads intial value into R1	
		  MOV     R0, #0		     // R0 will hold the result
		  BL      ALTERNATES
          ADD     R3,#4	  			//Increments R3 by 4 to access the data in the next word
		  B       LOOP
		  
		  
END:      B 	  DISPLAY
		  		

/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY: 	LDR 	R8, =0xFF200020 	// base address of HEX3-HEX0
			MOV 	R0, R5 			// display R5 on HEX1-0
			BL 		DIVIDE 			// ones digit will be in R0; tens digit in R1												
			MOV 	R9, R1 			// save the tens digit
			BL 		SEG7_CODE
			MOV 	R4, R0 			// save bit code
			MOV 	R0, R9 			// retrieve the tens digit, get bit code
			BL 		SEG7_CODE
			LSL 	R0, #8         //SHIFT by 8 to go to the next byte
			ORR 	R4, R0
			MOV 	R0, R6 			// display R6 on HEX3-2
			BL 		DIVIDE 			// ones digit will be in R0; tens digit in R1												
			MOV 	R9, R1 			// save the tens digit
			BL 		SEG7_CODE
			LSL     R0, #16          //SHIFT by 16 to access the byte belonging to HEX2
			ORR 	R4, R0 			// save bit code
			MOV 	R0, R9 			// retrieve the tens digit, get bit code
			BL 		SEG7_CODE
			LSL 	R0, #24         //SHIFT by 24 to access the byte belonging to HEX3
			ORR 	R4, R0
			STR 	R4, [R8] 		// display the numbers from R6 and R5
			LDR 	R8, =0xFF200030 	// base address of HEX5-HEX4
			MOV 	R0, R7 			// display R7 on HEX5-4
			BL 		DIVIDE 			// ones digit will be in R0; tens digit in R1												
			MOV 	R9, R1 			// save the tens digit
			BL 		SEG7_CODE
			MOV 	R4, R0 			// save bit code
			MOV 	R0, R9 			// retrieve the tens digit, get bit code
			BL 		SEG7_CODE
			LSL 	R0, #8         //SHIFT by 8 to go to the next byte
			ORR 	R4, R0
			STR 	R4, [R8] 		// display the number from R7
			B       END
  

DIVIDE:     MOV	    R2,#0
CONT:		CMP     R0,#10
			BLT     DIV_END
			SUB     R0,#10
			ADD     R2,#1
			B       CONT
DIV_END:    MOV     R1,R2	//Remainder in R0, quotient in R1
			MOV     PC,LR
			
			
/*Subroutine to find consecutive ones*/
ONES:     CMP     R1, #0          // loop until the data contains no more 1's
          BEQ     ENDONES             
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2      
          ADD     R0, #1          // count the string length so far
          B       ONES            

ENDONES:      MOV     PC,LR           //Returns back to main function             

/*Subroutine to find consecutive zeros*/
ZEROS:   MOV  R4,#0xffffffff
		 EOR  R1,R4,R1            //Produces the complement of R1
		 B ONES 			      //Use ones subroutine to find consecutive ones in the conmplemented number

		 
/*Subroutine to find alternates*/
ALTERNATES:   MOV   R10,LR         //Stores link register value in R10 so subroutine can return to main
			  EOR   R1,R8,R1       //XOR with alternating 1s and 0s to get alternates as consecutive ones
			  BL    ONES
			  CMP   R0,R7        	//Checks if return value from loop s greater than the current longest chain of alternates
		      BLE   SKIP2			//R7 retains value if R0 is smaller
		      MOV   R7,R0			//Else R7 is now equal to the value held by R0
SKIP2:	      LDR   R1,[R3]        //Reloads value into R1
			  EOR   R1,R9,R1       //XOR with alternating 1s and 0s to get alternates as consecutive ones
			  BL    ONES
			  CMP   R0,R7           //Checks if return value from loop s greater than the current longest chain of alternates
		      BLE   SKIP3			//R7 retains value if R0 is smaller
		      MOV   R7,R0			//Else R7 is now equal to the value held by R0
SKIP3:        MOV   LR,R10  			  
			  MOV   PC,LR           //Returns back to main function

			  

/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
* Parameters: R0 = the decimal value of the digit to be displayed
* Returns: R0 = bit patterm to be written to the HEX display
*/
SEG7_CODE: MOV R1, #BIT_CODES
ADD R1, R0 // index into the BIT_CODES "array"
LDRB R0, [R1] // load the bit pattern (to be returned)
MOV PC, LR
			  
			  
TEST_NUM: .word   0x103fe00f  
		  .word   0x112ce0ab  
		  .word   0xeee123
		  .word   0x9ffe5d     //contains 12 1's in a row
		  .word   0x108ed78
		  .word   0x5545
		  .word   0x200001       //Contains   20 0's in a row
		  .word   0xa434fa
		  .word   0x2555      //contains  15 alternates in a row
		  .word   0x13fffe5   //Contains 17 1's in a row
		  .word   0x038       //Contains   26 zeros in a row
		  .word   0x45f7abde
		  .word   0x0
          

ALTERNATING_NUMS1: .word 0xaaaaaaaa

ALTERNATING_NUMS2: .word 0x55555555
				   
				   
BIT_CODES: .byte 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
           .byte 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111  
		   .end	   
