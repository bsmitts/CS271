TITLE Assignment3(Assignment3.asm)

;// Author:  Brian Smith
;// Course / Project ID:  CS271/Assignment3                   Date:  04/28/15
;// Description:
;//  1. Display the program title and programmer’s name.
;//  2. Get the user’s name, and greet the user.
;//  3. Display instructions for the user.
;//  4. Repeatedly prompt the user to enter a number.  Validate the user input to be 
;//  in[-100, -1](inclusive).  Count and accumulate the valid user numbers until a 
;//  non - negative number is entered. (The non - negative number is discarded.)
;//  5. Calculate the (rounded integer) average of the negative numbers.
;//  6. Display:
;//    i.the number of negative numbers entered (Note : if no negative numbers were 
;//    entered, display a special message and skip to iv.)
;//    ii.the sum of negative numbers entered
;//    iii.the average, rounded to the nearest integer (e.g. - 20.5 rounds to - 20)
;//    iv.a parting message (with the user’s name)

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data

	title1			BYTE	"Programming Assignment #3", 0
	title2			BYTE	"by Brian Smith", 0
	greet1			BYTE	"Please enter your name:", 0
	greet2			BYTE	"Nice to meet you ", 0
	instruct1		BYTE	"Enter a number between -100 to -1. ", 0
	instruct2		BYTE	"When you are finished, enter a non-negative number.", 0
	period			BYTE	".", 0
	countPrompt1	BYTE	"You have entered ", 0
	countPrompt2	BYTE	" numbers", 0
	numPrompt		BYTE	"Please enter a number :", 0
	errorPrompt		BYTE	"Invalid.  Please enter  a number between -100 to -1.", 0
	totalPrompt		BYTE	"The total is ", 0
	averagePrompt	BYTE	"The average is ", 0
	endPrompt		BYTE	"Thank you ", 0

	userName		SDWORD	30 DUP(0)
	number			SDWORD	?
	count			SDWORD	?
	total			SDWORD	?
	average			SDWORD	?

.code
main PROC

	;//  Display program title and programmer's name.
	mov edx, OFFSET title1
	call WriteString
	call Crlf
	mov edx, OFFSET title2
	call WriteString
	call Crlf

	;//  2. Get the user’s name, and greet the user.
	mov edx, OFFSET greet1
	call WriteString
	mov edx, OFFSET userName
	mov ecx, SIZEOF userName
	call ReadString
	mov edx, OFFSET greet2
	call WriteString
	mov edx, OFFSET userName
	call WriteString
	mov edx, OFFSET period
	call WriteString
	call Crlf
	call Crlf

	;//  3. Display instructions for the user.
	mov edx, OFFSET instruct1
	call WriteString
	mov edx, OFFSET instruct2
	call WriteString
	call Crlf
	call Crlf

	;//  4. Repeatedly prompt the user to enter a number.  Validate the user input to be 
	;//  in[-100, -1](inclusive).  Count and accumulate the valid user numbers until a 
	;//  non - negative number is entered. (The non - negative number is discarded.)
	
	inputNum:
		mov	edx, OFFSET	numPrompt
		call WriteString
		call ReadInt
		cmp	eax, -100
		jl error
		cmp	eax, -1
		jg finish
		jmp	calculate

	error:
		mov	edx, OFFSET	errorPrompt
		call WriteString
		call CrLf
		jmp	inputNum

	calculate:
		mov	number, eax
		mov	eax, total
		add	eax, number
		mov	total, eax
		inc	count
		jmp	inputNum

	finish:
		;//  6i.the number of negative numbers entered (Note : if no negative numbers 
		;//  were entered, display a special message and skip to iv.)
		call CrLf
		mov	edx, OFFSET	countPrompt1
		call WriteString
		mov	eax, count
		call WriteDec
		mov	edx, OFFSET	countPrompt2
		call WriteString
		call CrLF
		;//  6ii.the sum of negative numbers entered
		mov	edx, OFFSET	totalPrompt
		call WriteString
		mov	eax, total
		call WriteInt
		call CrLf
		;//  5. Calculate the (rounded integer) average of the negative numbers.
		mov	eax, total
		cdq
		idiv count
		;//  6iii.the average, rounded to the nearest integer (e.g. - 20.5 rounds to 
		;//  -20)
		mov	edx, OFFSET	averagePrompt
		call WriteString
		mov	average, eax
		call WriteInt
		call CrLf
		;//  6iv.a parting message (with the user’s name)
		mov	edx, OFFSET	endPrompt
		call WriteString
		mov	edx, OFFSET	userName
		call WriteString
		mov	edx, OFFSET	period
		call WriteString
		call CrLf

	exit

main ENDP

; (insert additional procedures here)

END main