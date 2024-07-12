TITLE String Primitives and Macros

; Author: Noelle Lee
; Last Modified: 6/7/2024
; Course number/section:   CS271 Section 400
; Project Number: 6 
; Description: Takes 10 signed numbers from the user input, displays those numbers, sums the numbers, and finds the average.

INCLUDE Irvine32.inc

ARRAYSIZE = 10
MAX_INPUT_LENGTH = 11

mGetString MACRO buffer, maxStrLen, strLen
	PUSH	ECX
	PUSH	EDX
	PUSH	EAX

	MOV		EDX, buffer
	MOV		ECX, maxStrLen
	CALL	ReadString
	MOV		strLen, EAX

	POP		EAX
	POP		EDX
	POP		ECX

ENDM

mDisplayString MACRO buffer
	PUSH	EDX
	MOV		EDX, buffer
	CALL	WriteString
	POP		EDX
	
ENDM

.data

intro		BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures",13,10
			BYTE	"Written by: Noelle Lee",13,10,13,10,0
directions	BYTE	"Please provide 10 signed decimal integers.",13,10
			BYTE	"Each number needs to be small enough to fit inside a 32 bit register. After you have ",13,10
			BYTE	"finished inputting the raw numbers I will display a list of the integers, their sum, ",13,10
			BYTE	"and their average values.",13,10,13,10,0
prompt		BYTE	"Please enter a signed number: ",0
error		BYTE	"ERROR: You did not enter a signed number or your number was too big.",13,10
			BYTE	"Please try again: ",0
valid_num	BYTE	"You entered the following numbers: ",13,10,0
valid_sum	BYTE	"The sum of these numbers is: ",0
average		BYTE	"The truncated average is: ",0
goodbye		BYTE	"Thank you for playing!",13,10,0
numList		SDWORD	ARRAYSIZE DUP(?)
numLen		DWORD	?
inString	BYTE	21 DUP(?)
outNum		SDWORD	21 DUP(?)
maxInput	DWORD	ARRAYSIZE
comma		BYTE	", ",0
inNum		SDWORD	21 DUP(?)
outStr		BYTE	21 DUP(?)
bufferEnd	BYTE	?
totalSum	SDWORD	? 

.code
main PROC

	mDisplayString OFFSET intro
	mDisplayString OFFSET directions

	; get user input of 10 numbers
	MOV		ECX, ARRAYSIZE
	MOV		EDI, OFFSET numList

	_inputVal:
	PUSH	OFFSET prompt		; EBP + 36
	PUSH	OFFSET error		; EBP + 32
	PUSH	OFFSET outNum		; EBP + 28
	PUSH	OFFSET inString		; EBP + 24
	PUSH	SIZEOF inString		; EBP + 20
	PUSH	OFFSET numLen		; EBP + 16
	PUSH	ECX					; EBP + 12
	PUSH	EDI					; EBP + 8
	CALL	ReadVal
	
	_storeVal:
	POP		EDI
	MOV		[EDI], EAX
	ADD		EDI, 4
	POP		ECX
	LOOP	_inputVal

	; Display 10 valid numbers from the user
	CALL	CrLf
	mDisplayString OFFSET valid_num

	MOV		ECX, ARRAYSIZE
	MOV		EDI, OFFSET numList

	_outputVal:
	MOV		EAX, [EDI]
	MOV		inNum, EAX

	PUSH	OFFSET outStr	; EBP + 20
	PUSH	OFFSET inNum	; EBP + 16
	PUSH	EDI				; EBP + 12
	PUSH	ECX				; EBP + 8
	CALL	WriteVal
	
	POP		ECX

	CMP		ECX, 1
	JA		_nextNum
	JMP		_lastNum

	_nextNum:
	mDisplayString OFFSET comma

	_lastNum:
	POP		EDI
	POP		inNum
	ADD		EDI, 4
	MOV		EDX, 0

	LOOP	_outputVal

	; display the sum of the 10 numbers
	CALL	CrLf
	mDisplayString OFFSET valid_sum

	MOV		ECX, ARRAYSIZE
	MOV		EDI, OFFSET numList
	MOV		EAX, 0

	_calculateSum:
	MOV		EBX, [EDI]
	ADD		EAX, EBX
	ADD		EDI, 4
	LOOP	_calculateSum
	MOV		totalSum, EAX
	CALL	WriteVal

	; display the average of the 10 numbers
	CALL	CrLf
	mDisplayString OFFSET average
	MOV		EAX, totalSum
	MOV		EDX, 0
	MOV		EBX, ARRAYSIZE
	DIV		EBX
	CALL	WriteVal

	CALL	CrLf
	CALL	CrLf
	mDisplayString OFFSET goodbye
	

	Invoke ExitProcess,0		; exit to operating system
main ENDP

; -- ReadVal --
; Procedure to convert a string of ASCII digits to its numeric value representation (SDWORD) 
; preconditions: empty array must exist 
; postconditions: EAX, EBP changed
; receives: address of prompt string, errror string, a string of ASCII digits, and an empty array to be filled with numbers
; returns: a numeric SDWORD value
ReadVal PROC
	PUSH	EBP
	MOV		EBP, ESP

	MOV		ECX, MAX_INPUT_LENGTH
	PUSH	ECX

	_prompt:
	mDisplayString [EBP+36]

	_inputNum:
	mGetString [EBP+24], [EBP+20], [EBP+16]

	; set up loop counter and indices
	MOV		ECX, [EBP+16]
	MOV		ESI, [EBP+24]
	MOV		EDI, [EBP+28]
	CLD

	_checkNumLen:
	CMP		ECX, MAX_INPUT_LENGTH
	JG		_tooLong

	; check if each character is valid
	_checkChar:	
	MOV		EAX, [EDI]
	MOV		EBX, 10
	MUL		EBX
	MOV		[EDI], EAX
	MOV		EAX, 0			; clear EAX variable
	LODSB					; puts byte in AL
	
	CMP		ECX, [EBP+16]	; check the first character to see if there's a '+' or '-'
	JNE		_processDigits

	; check for sign in the beginning
	_checkSign:
	CMP		AL, '-'
	JE		_setNegative

	CMP		AL, '+'
	JE		_setPositive
	JMP		_noSign

	_setNegative:
	MOV		EBX, 1			; set negative flag
	PUSH	EBX
	CMP		ECX, 1
	JE		_invalid
	LOOP	_checkChar

	_setPositive:
	MOV		EBX, 0			; set positive flag
	PUSH	EBX
	CMP		ECX, 1
	JE		_invalid
	LOOP	_checkChar

	_noSign:
	MOV		EBX, 0			; assume lack of flag means a positive number
	PUSH	EBX

	_processDigits:
	CMP		AL, 48
	JL		_invalid
	CMP		AL, 57
	JG		_invalid

	SUB		AL, 48
	ADD		[EDI], AL
	LOOP	_checkChar
	JMP		_setSign

	_tooLong:
	PUSH	EAX				; return error if number length is too long
	MOV		EAX, 0
	MOV		[EDI], EAX
	POP		EAX
	mDisplayString [EBP+32]
	JMP		_inputNum

	_invalid:
	PUSH	EAX				; return error if there are non-numeric characters in the input 
	MOV		EAX, 0
	MOV		[EDI], EAX
	POP		EAX
	POP		EBX
	mDisplayString [EBP+32]
	JMP		_inputNum

	_setSign:
	MOV		EAX, [EDI]
	POP		EBX
	CMP		EBX, 1
	JNE		_nextNum
	NEG		EAX

	; clear output array
	_nextNum:
	MOV		EBX, 0
	MOV		[EDI], EBX
	POP		ECX
	POP		EBP
	RET		

ReadVal ENDP

; -- WriteVal --
; Procedure to convert a numeric SDWORD value to a string of ASCII digits
; preconditions: filled array of valid numbers must exist 
; postconditions: EDX, EBP changed
; receives: address of prompt strings, input SDWORD numeric value
; returns: a string of ASCII digits 
WriteVal PROC
    PUSH    EBP
    MOV     EBP, ESP

    ; get the output buffer pointer
    MOV     EDI, [EBP+20]            ; output buffer (outStr)
    
    ; initialize buffer pointer to the end of the buffer
    ADD     EDI, 21 - 1
    MOV     BYTE PTR [EDI], 0        ; null-terminate the buffer
    
    ; check if the number is negative
    MOV     ECX, 0                  
    CMP     EAX, 0
    JGE     PositiveNumber
    NEG     EAX                     
    MOV     CL, '-'              

PositiveNumber:
    ; convert number to ASCII digits
    MOV     EBX, 10                 
ConvertLoop:
    XOR     EDX, EDX                
    DIV     EBX                   
    ADD     EDX, '0'                
    DEC     EDI
    MOV     [EDI], DL                
    
    TEST    EAX, EAX
    JNZ     ConvertLoop             

    ; if the number was negative, add the minus sign
    CMP     ECX, 0
    JE      OutputResult
    DEC     EDI
    MOV     [EDI], CL

OutputResult:
    MOV     EDX, EDI
    CALL    WriteString         
    

    POP     EBP
    RET

WriteVal ENDP

END main
