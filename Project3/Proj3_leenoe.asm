TITLE Nested Loops and Procedures

; Author: Noelle Lee
; Last Modified: 5/9/24
; Course number/section:   CS271 Section 400
; Project Number: 3

INCLUDE Irvine32.inc

LOWER_LIMIT = 1
UPPER_LIMIT = 200

.data

val			SDWORD	?
intro		BYTE	"Prime Numbers Programmed by Noelle",13,10,13,10
			BYTE	"Enter the number of prime numbers you would like to see.",13,10
			BYTE	"I'll accept orders for up to 200 primes.",13,10,13,10,0
prompt		BYTE	"Enter the number of primes to display [1 ... 200]: ",0
send_error	BYTE	"No primes for you! Number out of range. Try again.",13,10,0
goodbye		BYTE	13,10,13,10,"Results certified by Noelle. Goodbye.",0
space		BYTE	"   ",0
current_val	SDWORD	?
divisor		SDWORD	?
increment	SDWORD	?
prime		SDWORD	?
printPrime	SDWORD	?
numPerLine	SDWORD	?

.code
main PROC
	CALL	introduction	
	CALL	getUserData		; obtain user input
	CALL	showPrimes
	CALL	farewell		
	
	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce the program.
; preconditions: intro is a string that describe the program and rules.
; postconditions: EDX changed
; receives: none
; returns: none
introduction PROC
	MOV		EDX, OFFSET intro
	CALL	WriteString
	RET
introduction ENDP

; -- getUserData --
; Gets a value from the user. Value must be between 1 and 200 (inclusive). 
; preconditions: prompt is a string, val exists
; postconditions: EAX, EDX changed
; receives: none
; returns: user input value for global variable val
getUserData PROC
	MOV		EDX, OFFSET prompt
	CALL	WriteString    
	CALL	ReadInt     
	MOV		val, EAX
	CALL	validate
	RET
getUserData ENDP

; -- validate --
; Check whether value is between 1 and 200 (inclusive). Display error message if not.
; preconditions: prompt is a string, val exists
; postconditions: EAX, EDX changed
; receives: user input value for global variable val
; returns: error message in global variable send_error if user input not in range
validate PROC
	CMP		EAX, LOWER_LIMIT	; check if our current value is less than our lower limit
	JL		_outsideRange
	CMP		EAX, UPPER_LIMIT	; check if our current value is greater than out upper limit
	JG		_outsideRange
	RET
	
_outsideRange:
	MOV		EDX, OFFSET send_error
	CALL	WriteString
	CALL	getUserData
	RET

validate ENDP

; -- showPrimes --
; Displays input number of prime numbers.
; preconditions: val exists, current_val, divisor, numPerLine, and prime are set as variables
; postconditions: EAX, ECX, EDX changed
; receives: user input value for global variable val
; returns: current_val if it is a prime number
showPrimes PROC
	MOV		current_val, 2	; start checking from the lowest prime	
	MOV		divisor, 2		; start divisor at 2
	MOV		prime, 1		; set prime as true for now
	MOV		numPerLine, 0	; counter, set prime numbers per line as 0 for now

	MOV		ECX, val		; set counter
_isPrime:
	CALL	isPrime
	CMP		prime, 1
	JE		_printPrime
	JMP		_notPrime
_printPrime:
	CMP		numPerLine, 10
	JGE		_nextLine
	JMP		_continuePrint
_nextLine:
	CALL	CrLf
	MOV		numPerLine, 0	; reset number of prime numbers per line counter
_continuePrint:
	MOV		EAX, current_val
	CALL	WriteDec
	MOV		EDX, OFFSET space
	CALL	WriteString
	INC		numPerLine
	JMP		_nextNum
_notPrime:
	INC		ECX				; don't let the loop decrement if current_val is not a prime
_nextNum:
	INC		current_val
	MOV		divisor, 2		; reset divisor to 2
	MOV		prime, 1		; reset prime as true for now
	LOOP	_isPrime

showPrimes ENDP

; -- isPrime --
; Validates whether vandidate value is prime or not prime
; preconditions: val exists, current_val, divisor, and prime are set as variables
; postconditions: EAX, EDX changed
; receives: current number being checked for primeness 
; returns: boolean 1 for prime or 0 for not prime
isPrime PROC

_checkPrime:
	MOV		EAX, current_val
	CMP		divisor, EAX	
	JGE		_nextVal
	MOV		EDX, 0
	MOV		EAX, current_val
	DIV		divisor
	CMP		EDX, 0	; number is not prime if there's no remainder 
	JE		_isNotPrime
	INC		divisor
	JMP		_checkPrime
	
_isNotPrime:
	MOV		prime, 0 ; set prime to false
	JMP		_nextVal

_nextVal:
	RET

isPrime ENDP

; -- farewell --
; Displays goodbye message to user once program is finished.
; preconditions: goodbye is a string that says goodbye to the user.
; postconditions: EDX changed
; receives: none
; returns: none
farewell PROC
	MOV		EDX, OFFSET goodbye
	CALL	WriteString
	RET
farewell ENDP

END main
