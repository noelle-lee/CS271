TITLE Project 1 - Basic Logic and Arithmetic Program     (Proj1_leenoe.asm)

; Author: Noelle Lee
; Last Modified: 4/12/2024
; OSU email address: leenoe@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 1               Due Date: 4/21/2024
; Description: This program performs basic arithmetic tasks, such as addition and subtraction of positive integers. 

INCLUDE Irvine32.inc

.data

number_A DWORD ? 
number_B DWORD ?  
number_C DWORD ?  
A_B_sum DWORD ? 
A_B_diff DWORD ?
A_C_sum DWORD ? 
A_C_diff DWORD ?
B_C_sum DWORD ? 
B_C_diff DWORD ?
A_B_C_sum DWORD ?
B_A_diff DWORD ?
C_A_diff DWORD ?
C_B_diff DWORD ?
C_B_A_diff DWORD ?
A_B_quotient DWORD ?
A_B_remainder DWORD ?
A_C_quotient DWORD ?
A_C_remainder DWORD ?
B_C_quotient DWORD ?
B_C_remainder DWORD ?
plusSign BYTE " + ", 0
minusSign BYTE " - ", 0
divideSign BYTE " / ", 0
equalsSign BYTE " = ", 0
remainderSign BYTE " R", 0
programTitle BYTE "Elementary Arithmetic, by Noelle Lee", 0
intro_1 BYTE "Enter 3 numbers A > B > C, and I'll show you the sums and differences.", 0 
prompt_A BYTE "First number: ", 0
prompt_B BYTE "Second number: ", 0
prompt_C BYTE "Third number: ", 0
goodbye BYTE "Thanks for using Elementary Arithmetic! Goodbye!", 0
extra_3 BYTE "**EC 3: Program handles negative results and computes B-A, C-A, C-B, and C-B-A.", 0
extra_4 BYTE "**EC 4: Program calculates and displays the quotients A/B, A/C, B/C.", 0

.code
main PROC
; --------------------------
; Introduction
; Displays the program title as well instructions for the user to follow. 
; --------------------------
   mov EDX, OFFSET programTitle
   call WriteString
   call CrLf
   mov	EDX, OFFSET extra_3
   call	WriteString
   call	CrLf 
   mov EDX, OFFSET extra_4
   call WriteString
   call CrLf
   call CrLf

   mov	EDX, OFFSET intro_1
   call	WriteString
   call	CrLf 

; --------------------------
; User Input
; Requests the user to input 3 numbers for the variables A, B, and C in descending order. 
; --------------------------
   mov	EDX, OFFSET prompt_A
   call	WriteString
   call ReadDec
   mov number_A, EAX

   mov	EDX, OFFSET prompt_B
   call	WriteString
   call ReadDec
   mov number_B, EAX

   mov	EDX, OFFSET prompt_C
   call	WriteString
   call ReadDec
   mov number_C, EAX
   call	CrLf 

; --------------------------
; Calculations
; The numbers stored in variables A, B, C are added and subtracted in this section. 
; --------------------------
   mov	EAX, number_A	; A + B 
   mov	EBX, number_B
   add	EAX, EBX
   mov	A_B_sum, EAX

   mov	EAX, number_A	; A - B
   sub	EAX, number_B
   mov	A_B_diff, EAX

   mov	EAX, number_A	; A + C
   mov	EBX, number_C
   add	EAX, EBX
   mov	A_C_sum, EAX

   mov	EAX, number_A	; A - C
   sub	EAX, number_C
   mov	A_C_diff, EAX

   mov	EAX, number_B	; B + C
   mov	EBX, number_C
   add	EAX, EBX
   mov	B_C_sum, EAX

   mov	EAX, number_B	; B - C
   sub	EAX, number_C
   mov	B_C_diff, EAX

   mov EAX, A_B_sum		; A + B + C
   mov EBX, number_C
   add EAX, EBX
   mov A_B_C_sum, EAX

   mov EAX, number_B	; EC #3: B - A
   sub EAX, number_A
   mov B_A_diff, EAX

   mov EAX, number_C	; EC #3: C - A
   sub EAX, number_A
   mov C_A_diff, EAX

   mov EAX, number_C	; EC #3: C - B
   sub EAX, number_B
   mov C_B_diff, EAX

   mov EAX, number_C	; EC #3: C - B - A
   sub EAX, number_B
   sub EAX, number_A
   mov C_B_A_diff, EAX

   mov EAX, number_A	; EC #4: A / B
   mov EDX, 0
   mov EBX, number_B
   div EBX
   mov A_B_quotient, EAX
   mov A_B_remainder, EDX

   mov EAX, number_A	; EC #4: A / C
   mov EDX, 0
   mov EBX, number_C
   div EBX
   mov A_C_quotient, EAX
   mov A_C_remainder, EDX

   mov EAX, number_B	; EC #4: B / C
   mov EDX, 0
   mov EBX, number_C
   div EBX
   mov B_C_quotient, EAX
   mov B_C_remainder, EDX

; --------------------------
; Output Results
; The sum and differences of A, B, and C are outputted to the user here.
; --------------------------
   mov	EAX, number_A	; output result of A + B
   call	WriteDec
   mov	EDX, OFFSET plusSign
   call	WriteString
   mov	EAX, number_B
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, A_B_sum
   call	WriteDec
   call CrLf

   mov	EAX, number_A	; output result of A - B
   call	WriteDec
   mov	EDX, OFFSET minusSign
   call	WriteString
   mov	EAX, number_B
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, A_B_diff
   call	WriteDec
   call CrLf

   mov	EAX, number_A	; output result of A + C
   call	WriteDec
   mov	EDX, OFFSET plusSign
   call	WriteString
   mov	EAX, number_C
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, A_C_sum
   call	WriteDec
   call CrLf

   mov	EAX, number_A	; output result of A - C
   call	WriteDec
   mov	EDX, OFFSET minusSign
   call	WriteString
   mov	EAX, number_C
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, A_C_diff
   call	WriteDec
   call CrLf

   mov	EAX, number_B	; output result of B + C
   call	WriteDec
   mov	EDX, OFFSET plusSign
   call	WriteString
   mov	EAX, number_C
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, B_C_sum
   call	WriteDec
   call CrLf

   mov	EAX, number_B	; output result of B - C
   call	WriteDec
   mov	EDX, OFFSET minusSign
   call	WriteString
   mov	EAX, number_C
   call	WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, B_C_diff
   call	WriteDec
   call CrLf

   mov	EAX, number_A	; output result of A + B + C
   call	WriteDec
   mov	EDX, OFFSET plusSign
   call	WriteString
   mov	EAX, number_B
   call	WriteDec
   mov EDX, OFFSET plusSign
   call WriteString
   mov EAX, number_C
   call WriteDec
   mov	EDX, OFFSET equalsSign
   call	WriteString
   mov	EAX, A_B_C_sum
   call	WriteDec
   call CrLf

   mov EAX, number_B	; EC #3: output result of B - A
   call WriteDec
   mov EDX, OFFSET minusSign
   call WriteString
   mov EAX, number_A
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, B_A_diff
   call WriteInt
   call CrLf

   mov EAX, number_C	; EC #3: output result of C - A
   call WriteDec
   mov EDX, OFFSET minusSign
   call WriteString
   mov EAX, number_A
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, C_A_diff
   call WriteInt
   call CrLf

   mov EAX, number_C	; EC #3: output result of C - B
   call WriteDec
   mov EDX, OFFSET minusSign
   call WriteString
   mov EAX, number_B
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, C_B_diff
   call WriteInt
   call CrLf

   mov EAX, number_C	; EC #3: output result of C - B - A
   call WriteDec
   mov EDX, OFFSET minusSign
   call WriteString
   mov EAX, number_B
   call WriteDec
   mov EDX, OFFSET minusSign
   call WriteString
   mov EAX, number_A
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, C_B_A_diff
   call WriteInt
   call CrLf

   mov EAX, number_A	; EC #4: output result of A / B
   call WriteDec
   mov EDX, OFFSET divideSign
   call WriteString
   mov EAX, number_B
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, A_B_quotient
   call WriteDec
   mov EDX, OFFSET remainderSign
   call WriteString
   mov EAX, A_B_remainder
   call WriteDec
   call CrLf

   mov EAX, number_A	; EC #4: output result of A / C
   call WriteDec
   mov EDX, OFFSET divideSign
   call WriteString
   mov EAX, number_C
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, A_C_quotient
   call WriteDec
   mov EDX, OFFSET remainderSign
   call WriteString
   mov EAX, A_C_remainder
   call WriteDec
   call CrLf

   mov EAX, number_B	; EC #4: output result of B / C
   call WriteDec
   mov EDX, OFFSET divideSign
   call WriteString
   mov EAX, number_C
   call WriteDec
   mov EDX, OFFSET equalsSign
   call WriteString
   mov EAX, B_C_quotient
   call WriteDec
   mov EDX, OFFSET remainderSign
   call WriteString
   mov EAX, B_C_remainder
   call WriteDec
   call CrLf

; --------------------------
; Goodbye
; A goodbye message is displayed to the user to indicate the end of the program.
; --------------------------
   call CrLf
   mov	EDX, OFFSET goodbye
   call	WriteString
   call CrLf

	Invoke ExitProcess,0	
main ENDP

END main
