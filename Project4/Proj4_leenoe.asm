TITLE Arrays, Addressing, and Stack-Passed Parameters

; Author: Noelle Lee
; Last Modified: 5/25/24
; Course number/section:  CS271 Section 400
; Project Number: 4
; Description: Generates, sorts, and counts 200 random integers between 15 and 50 (inclusive)

INCLUDE Irvine32.inc

ARRAYSIZE = 200
LO = 15
HI = 50

.data

intro			BYTE	"Generating, Sorting, and Counting Random integers!	Programmed by Noelle",13,10,13,10
				BYTE	"This program generates 200 random integers between 15 and 50, inclusive.",13,10
				BYTE	"It then displays the original list, sorts the list, displays the median value of the list,",13,10
				BYTE	"displays the list sorted in ascending order, and finally displays the number of instances",13,10
				BYTE	"of each generated value, starting with the number of lowest.",13,10,13,10,0
unsorted		BYTE	"Your unsorted random numbers:",13,10,0
median			BYTE	"The median value of the array: ",0
sorted			BYTE	"Your sorted random numbers:",13,10,0
instance_list	BYTE	"Your list of instances of each generated number, starting with the smallest value:",13,10,0
goodbye			BYTE	"Goodbye, and thanks for using my program!",13,10,0
numArray		DWORD	ARRAYSIZE DUP(?)
counts			DWORD	ARRAYSIZE DUP(?)

.code
main PROC

	CALL	RANDOMIZE
	
	PUSH	OFFSET intro
	CALL	introduction

	PUSH	OFFSET numArray
	CALL	fillArray

	PUSH	OFFSET unsorted
	PUSH	OFFSET numArray
	CALL	displayList

	PUSH	OFFSET numArray
	CALL	sortList

	PUSH	OFFSET median
	PUSH	OFFSET numArray
	CALL	displayMedian

	PUSH	OFFSET sorted
	PUSH	OFFSET numArray
	CALL	displayList

	PUSH	OFFSET instance_list
	PUSH	OFFSET numArray
	PUSH	OFFSET counts
	CALL	countList

	PUSH	OFFSET goodbye
	CALL	farewell


	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce the program.
; preconditions: intro is a string that describe the program and rules.
; postconditions: EDX, EBP changed
; receives: address of intro prompt on system stack
; returns: title and instructions of program
introduction PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP+8]
	CALL	WriteString

	POP		EBP
	RET		4

introduction ENDP

; -- fillArray --
; Procedure to fill the array with random numbers.
; preconditions: ARRAYSIZE, HI, and LO constants defined
; postconditions: EDX, ECX, EDI, EAX, and EBP changed
; receives: address of array on system stack
; returns: array filled with random numbers
fillArray PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		ECX, ARRAYSIZE	; count in ECX
	MOV		EDI, [EBP+8]	; address of array in EDI
_generateNum:
	MOV		EAX, HI			
	SUB		EAX, LO
	ADD		EAX, 1

	CALL	RandomRange
	ADD		EAX, LO
	MOV		[EDI], EAX
	ADD		EDI, 4

	LOOP	_generateNum

	POP		EBP
	RET		4

fillArray ENDP

; -- sortList --
; Procedure to sort the array from lowest to highest.
; preconditions: ARRAYSIZE constant defined
; postconditions: EDX, EBX, ECX, EDI, EAX, and EBP changed
; receives: address of array on system stack
; returns: array with its numbers sorted from lowest to highest 
sortList PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDI, [EBP+8]
	MOV		ECX, ARRAYSIZE

	DEC		ECX

_outerLoop:
	MOV		EDI, [EBP+8]
	MOV		EBX, ECX

_innerLoop:
	MOV		EAX, [EDI]
	MOV		EDX, [EDI+4]
	CMP		EAX, EDX
	JLE		_noSwap

	; swap if current number is greater than the next number
	XCHG	EAX, EDX
	MOV		[EDI], EAX
	MOV		[EDI+4], EDX

_noSwap:
	ADD		EDI, 4
	DEC		EBX
	CMP		EBX, 0
	JNE		_innerLoop

	DEC		ECX
	CMP		ECX, 0
	JNE		_outerLoop

	POP		EBP
	RET		4

sortList ENDP

; -- displayMedian --
; Procedure to find the median of the sorted array.
; preconditions: ARRAYSIZE constant defined
; postconditions: EDX, ECX, EDI, EAX, and EBP changed
; receives: address of median variable and sorted array on system stack
; returns: median of the sorted array
displayMedian PROC
	PUSH	EBP
	MOV		EBP, ESP

	; display median prompt
	MOV		EDX, [EBP+12]
	CALL	WriteString

    ; calculate median
    MOV     EDI, [EBP+8]      
    MOV     ECX, ARRAYSIZE
    MOV     EAX, ECX
    MOV     EBX, 2
	MOV		EDX, 0
    DIV     EBX               

    CMP     EDX, 0             ; check if remainder is zero (even array size)
    JNE     odd_array          ; if remainder is not zero, array size is odd

    ; even array size: median is the average of the two middle elements
    MOV     ESI, EAX           
    DEC     ESI               
    ADD		ESI, ESI
	ADD		ESI, ESI		  
    MOV     EAX, [EDI + ESI]  
    ADD     ESI, 4             
    ADD     EAX, [EDI + ESI]   
    ADD     EAX, 1             
    MOV     EBX, 2
    DIV     EBX                
    JMP     display_median

odd_array:
    MOV     ESI, EAX 
	ADD		ESI, ESI
	ADD		ESI, ESI            
    MOV     EAX, [EDI + ESI]  

display_median:
    ; Display the median value
    CALL    WriteDec
    CALL    CrLf
	CALL	CrLf

    POP     EBP
    RET     12

displayMedian ENDP

; -- displayList --
; Procedure to display the unsorted and sorted array.
; preconditions: ARRAYSIZE constant defined
; postconditions: EDX, ECX, EDI, EAX, and EBP changed
; receives: address of unsorted prompt, sorted prompt, and array on system stack
; returns: unsorted array and sorted array
displayList PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP+12]
	CALL	WriteString

	POP		EBP

	PUSH	EBP
	MOV		EBP, ESP
	MOV		EBX, 20
	MOV		ECX, ARRAYSIZE
	MOV		EDI, [EBP+8]

_displayLoop:
	MOV		EAX, [EDI]
	CALL	WriteDec
	MOV     AL, ' '
	CALL    WriteChar

	ADD		EDI, 4
	DEC		ECX
	DEC		EBX

	CMP		ECX, 0
	JNE		_continueLine
	JMP		_endLoop

_continueLine:
	CMP		EBX, 0
	JNE		_displayLoop

	CALL	CrLf
	MOV		EBX, 20
	JMP	_displayLoop

_endLoop:
	CALL	CrLf
	CALL	CrLf
	POP		EBP
	RET

displayList ENDP

; -- countList --
; Procedure to count the instances of each number in the sorted array.
; preconditions: ARRAYSIZE, HI, and LO constants defined
; postconditions: EDX, ECX, ESI, EDI, EAX, and EBP changed
; receives: address of instance list prompt, array, and counts array on system stack
; returns: counts array defining the instance of each number in the sorted array
countList PROC
	PUSH	EBP
	MOV		EBP, ESP

	; display instance list prompt
	MOV		EDX, [EBP+16]
	CALL	WriteString

    ; allocate memory for counts array
    MOV     ECX, HI             
    SUB     ECX, LO             
    INC     ECX                  
    MOV     EBX, ECX             

    MOV     ESI, [EBP+8]            
    MOV     ECX, EBX             
    MOV     EAX, 0               

_instance_count:
    MOV     [ESI], EAX 
    ADD     ESI, 4               
    LOOP    _instance_count    

    ; iterate through numArray and count occurrences
    MOV     ECX, ARRAYSIZE       
    MOV     ESI, [EBP+12] 

_count_loop:
    MOV     EAX, [ESI]          
    SUB     EAX, LO   

	ADD		EAX, EAX
	ADD		EAX, EAX
	MOV		EDI, [EBP+8]
	ADD		DWORD PTR [EDI + EAX], 1
	
    ADD     ESI, 4		; move to next element
    LOOP    _count_loop          

    ; Display the counts array
    MOV     ESI, [EBP+8] 
    MOV     ECX, EBX             
    MOV     EBX, 20             

_display_counts_loop:
    MOV		EAX, [ESI]
    CALL    WriteDec             
	MOV     AL, ' '
	CALL    WriteChar
    DEC     EBX                 
    CMP     EBX, 0              
    JNE     _continue_line        
    CALL    CrLf                
    MOV     EBX, 20              

_continue_line:
    ADD     ESI, 4               
    LOOP    _display_counts_loop  

    CALL    CrLf
	CALL	CrLf
    POP     EBP
    RET     12

countList ENDP

; -- farewell --
; Procedure to say goodbye to the user and end the program.
; preconditions: none
; postconditions: EDX and EBP changed
; receives: address of goodbye prompt
; returns: goodbye message
farewell PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP+8]
	CALL	WriteString

	POP		EBP
	RET		4

farewell ENDP

END main
