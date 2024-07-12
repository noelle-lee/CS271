TITLE Data Validation, Looping, and Constants

; Author: Noelle Lee
; Last Modified: 04/28/2024
; Course number/section:   CS271 Section 400
; Project Number: 2 
; Description: Program asks user to pick several values between -200 and -100 or -50 or -1
;	until user enters a non-negative integer.
;	Program logs how many valid numbers were input.
;	Program finds the minimum and maximum values of valid inputs.
;	Program calculates the sum and rounded average of valid inputs. 

INCLUDE Irvine32.inc

LOWER_LIMIT_1 = -200
UPPER_LIMIT_1 = -100
LOWER_LIMIT_2 = -50
UPPER_LIMIT_2 = -1

.data
	intro				BYTE	"Welcome to the Integer Accumulator by Noelle Lee",13,10,"We will be accumulating user-input negative integers between the specified bounds, then displaying statistics of the input values including minimum, maximum, and average values, total sum, and total number of valid inputs.",13,10,0
	get_name			BYTE	"What is your name? ",0
	userName			BYTE	33 DUP(0) ; string is length 33 and is filled with 0's, string to be entered by user
	greeting			BYTE	"Hello there, ", 0
	instructions		BYTE	"Please enter numbers in [-200, -100] or [-50, -1].",13,10,"Enter a non-negative number when you are finished, and input stats will be shown.",13,10,0
	prompt				BYTE	") Enter number: ",0
	invalid_guess		BYTE	"This is not a number we're looking for (Invalid Input)!",13,10,0
	userVal				SDWORD	? ; User's guess
	lineNum				DWORD	1
	counter				DWORD	0 ; Count of valid numbers
	counter_prompt_1	BYTE	"You entered ",0
	counter_prompt_2	BYTE	" valid numbers.",13,10,0
	minimum				SDWORD	-1
	maximum				SDWORD	-200
	validSum			SDWORD	0
	divisor				DWORD	100
	EC_divisor			DWORD	10000
	roundedAverage		SDWORD	?
	EC_average			SDWORD	?
	remainder			SDWORD	?
	EC_remainder		SDWORD	?
	EC_float			DWORD	?
	no_remainder		BYTE	"00",0
	decimalPoint		BYTE	".",0
	max_prompt			BYTE	"The maximum valid number is ",0
	min_prompt			BYTE	"The minimum valid number is ",0
	sum_prompt			BYTE	"The sum of your valid numbers is ",0
	average_prompt		BYTE	"The rounded average is ",0
	EC_prompt			BYTE	"The rounded average to the nearest .01 is ",0
	goodbye				BYTE	"We have to stop meeting like this. Farewell, ",0
	no_input			BYTE	"Next time, please input a valid number.",0
	extra_1				BYTE	"**EC 1: Number the lines during user input. Increment the line number only for valid number entries.", 0
	extra_2				BYTE	"**EC 2: Calculate and display the average as a decimal-point number , rounded to the nearest .01.", 0



.code
main PROC
	; --------------------------
	; Introduction
	; Displays the program title as well instructions for the user to follow. 
	; --------------------------

	; Display the program title and programmer's name
	MOV		EDX, OFFSET intro
	CALL	WriteString
	MOV		EDX, OFFSET extra_1
	CALL	WriteString
	CALL	CrLf 
	MOV		EDX, OFFSET extra_2
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf
	
	; Get the user's name 
	MOV		EDX, OFFSET get_name
	CALL	WriteString
	MOV		EDX, OFFSET userName
	MOV		ECX, 32
	CALL	ReadString
	
	; Greet the user
	MOV		EDX, OFFSET greeting
	CALL	WriteString
	MOV		EDX, OFFSET userName
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

	; Display instructions for the user
	MOV		EDX, OFFSET instructions
	CALL	WriteString

_startLoop:
	; --------------------------
	; Receive input
	; Repeatedly prompt the user the enter a number, verifying if guess is within limits.
	; --------------------------

	; Prompt for user input
	MOV		EAX, lineNum
	CALL	WriteDec
	MOV		EDX, OFFSET prompt
	CALL	WriteString

	CALL	ReadInt
	MOV		userVal, EAX

	CMP		EAX, 0
	JGE		_BreakOut

	; Increment counter and line number for number of valid inputs
	INC		counter
	INC		lineNum

	; Check if the input is valid
	CMP		EAX, LOWER_LIMIT_1 
	JL		_Invalid
	CMP		EAX, UPPER_LIMIT_2
	JG		_Invalid

	CMP		EAX, UPPER_LIMIT_1
	JLE		_checkMin
	CMP		EAX, LOWER_LIMIT_2
	JGE		_checkMin

	JMP		_Invalid


_checkMin:
	; Calculate smallest value input
	CMP		EAX, minimum
	JL		_Minimum
	JMP		_checkMax

_Minimum:
	MOV		minimum, EAX

_checkMax:
	; Calculate largest value input
	CMP		EAX, maximum
	JG		_Maximum
	JMP		_Valid

_Maximum:
	MOV		maximum, EAX

_Valid:
	ADD		validSum, EAX
	JMP		_startLoop
	
_Invalid:
	MOV		EDX, OFFSET invalid_guess
	CALL	WriteString
	DEC		counter
	DEC		lineNum
	JMP		_startLoop

_BreakOut:
	; --------------------------
	; Calculate statistics
	; Calculate the rounded average of inputs
	; --------------------------

	; If user didn't input any valid integers, skip to special goodbye message
	CMP		counter, 0
	JE		_goodBye_noInput

	; Get the whole integer quotient 
	MOV		EAX, validSum
	IMUL	EAX, 100
	CDQ		
	IDIV	counter

	CDQ		
	IDIV	divisor
	MOV		roundedAverage, EAX
	MOV		remainder, EDX

	; Determine if floating point would round the number up or down
	CMP		remainder, -50
	JL		_roundDown
	JMP		_outputAnswer

_roundDown:
	SUB		roundedAverage, 1

_outputAnswer:
	; Display number of valid inputs
	MOV		EDX, OFFSET counter_prompt_1
	CALL	WriteString
	MOV		EAX, counter
	CALL	WriteDec
	MOV		EDX, OFFSET counter_prompt_2
	CALL	WriteString

	; Display maximum of valid inputs
	MOV		EDX, OFFSET max_prompt
	CALL	WriteString
	MOV		EAX, maximum
	CALL	WriteInt
	CALL	CrLf

	; Display minimum of valid inputs
	MOV		EDX, OFFSET min_prompt
	CALL	WriteString
	MOV		EAX, minimum
	CALL	WriteInt
	CALL	CrLf

	; Display sum of valid inputs
	MOV		EDX, OFFSET sum_prompt
	CALL	WriteString
	MOV		EAX, validSum
	CALL	WriteInt
	CALL	CrLf

	; Display rounded average of valid inputs
	MOV		EDX, OFFSET average_prompt
	CALL	WriteString
	MOV		EAX, roundedAverage
	CALL	WriteInt
	CALL	CrLf

_extraCredit_2:
	; --------------------------
	; Receive input
	; Repeatedly prompt the user the enter a number, verifying if guess is within limits.
	; --------------------------
	; Get the whole integer quotient 
	MOV		EAX, validSum
	CDQ		
	IDIV	counter
	MOV		EC_average, EAX
	MOV		EC_remainder, EDX

	CMP		EC_remainder, 0
	JE		_noRemainder

	; Determine if floating point would round the number up or down
	MOV		EAX, validSum
	IMUL	EAX, 1000
	CDQ		
	IDIV	counter

	CDQ		
	IDIV	divisor
	MOV		EC_remainder, EDX

	CMP		EC_remainder, -50
	JL		_extra_roundDown
	JMP		_getRemainder

_extra_roundDown:
	SUB		remainder, 1

_getRemainder:
	MOV		EAX, remainder
	IMUL	EAX, -1
	MOV		EC_float, EAX

_outputEC:
	; Output rounded average up to .01 decimal places
	MOV		EDX, OFFSET EC_prompt
	CALL	WriteString
	MOV		EAX, EC_average
	CALL	WriteInt
	MOV		EDX, OFFSET decimalPoint
	CALL	WriteString
	MOV		EAX, EC_float
	CALL	WriteDec
	JMP		_goodBye

_noRemainder:
	; If the average didn't need to be rounded, append .00 to the whole number average
	MOV		EDX, OFFSET EC_prompt
	CALL	WriteString
	MOV		EAX, EC_average
	CALL	WriteInt
	MOV		EDX, OFFSET decimalPoint
	CALL	WriteString
	MOV		EDX, OFFSET no_remainder
	CALL	WriteString

_goodBye:
	; Say goodbye to user
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, OFFSET goodbye
	CALL	WriteString
	MOV		EDX, OFFSET userName
	CALL	WriteString
	JMP		_endProgram

_goodBye_noInput:
	; Special message to user if they didn't enter any valid inputs
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, OFFSET no_input
	CALL	WriteString
	CALL	CrLf
	MOV		EDX, OFFSET goodbye
	CALL	WriteString
	MOV		EDX, OFFSET userName
	CALL	WriteString

_endProgram:

	Invoke ExitProcess,0	
main ENDP

END main
