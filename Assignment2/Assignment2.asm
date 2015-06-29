TITLE Assignment2		(Assignment2.asm)

;//  Author:  Brian Smith

;//  Revision date:  04/15/15

;// Description: 
;// 1) The programmer’s name and the user’s name appear in the output.
;// 2) The loop that implements data validation is implemented as a 
;// post - test loop.
;// 3) The loop that calculates the Fibonacci terms is implemented 
;// using the MASM loop instruction.
;// 4) The main procedure is modularized in the following 
;// sections:
;// a.introduction
;// b.userInstructions
;// c.getUserData
;// d.displayFibs
;// e.farewell
;// 6) The upper limit is defined and used as a constant.

INCLUDE Irvine32.inc

upper	EQU		46

.data

intro1		BYTE	"Fibonacci Numbers", 0
intro2		BYTE	"Programmed by Brian Smith", 0
prompt1		BYTE	" What is your name? ", 0
prompt2		BYTE	"Nice to meet you, ", 0
prompt3		BYTE	" Please enter a number: ", 0
error1		BYTE	"The number you entered is out of range.",0
error2		BYTE	" You must enter a number between 1 - 46.", 0
period		BYTE	".", 0
spaces		BYTE	"    ", 0
instruct1	BYTE	"Enter the number of fibonacci terms you would like to display.", 0
instruct2	BYTE	" You must enter a number between 1 - 46.", 0
farewell	BYTE	"Impressed?  Good bye.", 0
userName	DWORD	30 DUP(0)
num1		DWORD	?
num2		DWORD	?
total		DWORD	?
column		DWORD	?

.code

main PROC

;//  Introduction.
	mov edx, OFFSET intro1
	call WriteString
	call Crlf
	mov edx, OFFSET intro2
	call WriteString
	call Crlf

;//  User instructions.
	mov edx, OFFSET instruct1
	call WriteString
	mov edx, OFFSET instruct2
    call WriteString

;//  Get user data.
	mov edx, OFFSET prompt1
	call WriteString
	mov edx, OFFSET userName
	mov ecx, SIZEOF userName
	call ReadString
	mov edx, OFFSET prompt2
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	mov edx, OFFSET period
	call Writestring
	call Crlf
	
	;//  Post-test loop to validate data.
	prompt:

		mov edx, OFFSET prompt3
		call WriteString
		call ReadInt
		cmp eax, 1
		jl error
		cmp eax, upper
		jg error
		jmp finished

	error:

		mov edx, OFFSET error1
		call WriteString
		mov edx, OFFSET error2
		call WriteString
		jmp prompt

	finished:
	
		call Crlf
		mov num1, eax

;//  Calculate and display Fibonacci terms.
	mov	eax, 1
	call WriteDec
	mov	edx, OFFSET spaces
	call WriteString
	mov	eax, 0
	mov	ebx, 1
	mov	num2, 0
	mov	ecx, num1
	dec	ecx
	mov	column, 2

	fibonacci:
		mov	eax, ebx
		add	eax, num2
		mov	num2, ebx
		mov	ebx, eax
		call WriteDec
		mov	edx, OFFSET spaces
		call WriteString
		cmp	column, 5
		jge	trueCon
		mov	edx, column
		inc	edx
		mov	column, edx
		jmp	falseCon

	trueCon:
		call CrLf
		mov	column, 1
	
	falseCon:
		loop fibonacci

;//  Farewell message.
call Crlf
mov edx, OFFSET farewell
call WriteString
call Crlf

	exit
main ENDP

END main