.global _start
_start:

.equ HEX3_0_BASE, 0xFF200020      
.equ SW_BASE,     0xFF200040      
.equ KEY_BASE,    0xFF200050      
.equ TIMER_START, 400000        

_start:
    LDR SP, =0xFFFFFF00
    MOV R0, #0
    MOV R1, #0
    LDR R6, =TIMER_START
    MOV R7, #0
    BL UPDATE_DISPLAY_SUB

MAIN_LOOP:
    LDR R3, =KEY_BASE
    LDR R4, [R3]
    AND R4, R4, #1
    CMP R4, #1                      //Edge Detection
    BNE UPDATE_LAST_STATE
    CMP R7, #0              
    BNE UPDATE_LAST_STATE
    EOR R1, R1, #1                  //Rising Edge: Toggle State
    
UPDATE_LAST_STATE:
    MOV R7, R4

    LDR R3, =KEY_BASE               //Reset Button
    LDR R5, [R3]
    TST R5, #2              
    BEQ CHECK_SW            
    MOV R0, #0
    BL UPDATE_DISPLAY_SUB

CHECK_SW:
    LDR R3, =SW_BASE                //Direction Switch
    LDR R4, [R3]
    AND R2, R4, #1
 
    CMP R1, #0                      //Timer Logic
    BEQ MAIN_LOOP
          
    SUBS R6, R6, #1
    BNE MAIN_LOOP
           
    LDR R6, =TIMER_START            //Reset to TIMER_START value

    CMP R2, #0                      //Counting Logic
    BNE COUNT_DOWN
    
COUNT_UP:
    ADD R0, R0, #1
    CMP R0, #60
    BLT DISPLAY_AND_LOOP
    MOV R0, #0              
    B DISPLAY_AND_LOOP

COUNT_DOWN:
    SUBS R0, R0, #1
    BGE DISPLAY_AND_LOOP
    MOV R0, #59             
    
DISPLAY_AND_LOOP:
    BL UPDATE_DISPLAY_SUB
    B MAIN_LOOP

UPDATE_DISPLAY_SUB:                 //Display Subroutine
    PUSH {R3-R5, R8-R10, LR}
    
    MOV R3, R0              
    MOV R4, #0              
    
DIV_LOOP:                           //Division by Repeated Subtraction
    CMP R3, #10
    BLT DIV_DONE
    SUB R3, R3, #10
    ADD R4, R4, #1
    B DIV_LOOP
    
DIV_DONE:                           
    MOV R5, R3              
    LDR R8, =SEG_PATTERNS
    
    LDR R9, [R8, R4, LSL #2]        //Lookup
    LSL R9, R9, #8            
    
    LDR R10, [R8, R5, LSL #2] 
    
    ORR R9, R9, R10           
    LDR R3, =HEX3_0_BASE
    STR R9, [R3]
    
    POP {R3-R5, R8-R10, PC}

.align 2
SEG_PATTERNS:                       //The Dictionary
    .word 0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F