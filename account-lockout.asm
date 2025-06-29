include 'emu8086.inc'
JMP START

DATA SEGMENT 
    TOTAL        DW 20
    IDS1         DW 0000H,0001H,0002H,0003H,0004H,0005H,0006H,0007H,0008H,0009H
    IDS2         DW 000AH,000BH,000CH,000DH,000EH,000FH,0010H,0011H,0012H,0013H 
    PASSWORDS1   DB   00H,  01H,  02H,  03H,  04H,  05H,  06H,  07H,  08H,  09H
    PASSWORDS2   DB   0AH,  0BH,  0CH,  0DH,  0EH,  0FH,  01H,  02H,  03H,  04H
    DATA1        DB '******WELCOME*******',0
    DATA2        DB 0DH,0AH,'ENTER YOUR ID: ',0
    DATA3        DB 0DH,0AH,'ENTER YOUR PASSWORD: ',0 
    DATA4        DB 0DH,0AH,'DENIED 0  ',0  
    DATA5        DB 0DH,0AH,'ALLOWED 1 ',0 
    DATA6        DB '******WELCOME BACK*******',0
    DATA7        DB 0DH,0AH,'Account is locked temporarily',0
    IDINPUT      DW 1 DUP(?)
    PASSINPUT    DB 1 DUP(?)
    ATTEMPTS     DB ?
DATA ENDS

CODE SEGMENT

START:
      MOV AX, DATA
      MOV DS, AX  

DEFINE_SCAN_NUM           
DEFINE_PRINT_STRING 
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS 

AGAIN:
      LEA  SI, DATA1
      CALL PRINT_STRING
      LEA  SI, DATA2
      CALL PRINT_STRING
      MOV SI, -1

      CALL SCAN_NUM
      MOV IDINPUT, CX
      MOV AX, CX
      MOV CX, 0 

L1:   INC CX
      CMP CX, TOTAL
      JE ERROR
      INC SI
      MOV DX, SI
      CMP IDS1[SI], AX
      JE PASS1
      CMP IDS2[SI], AX
      JE PASS2
      JMP L1

;-------------------------
; PASSWORD CHECK FOR IDS1
;-------------------------
PASS1:
      MOV ATTEMPTS, 3
PASS1_LOOP:
      LEA SI, DATA3
      CALL PRINT_STRING        
      CALL SCAN_NUM
      MOV PASSINPUT, CL

      MOV AX, DX 
      MOV DX, 2
      DIV DL 
      MOV SI, AX 
      MOV AL, CL
      MOV AH, 0
      CMP PASSWORDS1[SI], AL
      JE DONE

      ; Wrong password
      DEC ATTEMPTS
      CMP ATTEMPTS, 0
      JE LOCKED
      JMP PASS1_LOOP

;-------------------------
; PASSWORD CHECK FOR IDS2
;-------------------------
PASS2:
      MOV ATTEMPTS, 3
PASS2_LOOP:
      LEA SI, DATA3
      CALL PRINT_STRING        
      CALL SCAN_NUM
      MOV PASSINPUT, CL

      MOV AX, DX 
      MOV DX, 2
      DIV DL 
      MOV SI, AX 
      MOV AL, CL
      MOV AH, 0
      CMP PASSWORDS2[SI], AL
      JE DONE

      ; Wrong password
      DEC ATTEMPTS
      CMP ATTEMPTS, 0
      JE LOCKED
      JMP PASS2_LOOP

;-------------------------
; LOCKOUT DISPLAY
;-------------------------
LOCKED:
      LEA SI, DATA7
      CALL PRINT_STRING
      JMP AGAIN

;-------------------------
; IF WRONG ID
;-------------------------
ERROR:
      LEA SI, DATA4
      CALL PRINT_STRING 
      PRINT 0AH      
      PRINT 0DH
      JMP AGAIN 

;-------------------------
; IF SUCCESS
;-------------------------
DONE:
      LEA SI, DATA5
      CALL PRINT_STRING
      PRINT 0AH      
      PRINT 0DH 
      LEA SI, DATA6
      CALL PRINT_STRING 
      JMP AGAIN

CODE ENDS

END START
