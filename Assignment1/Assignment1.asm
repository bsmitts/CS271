TITLE Assignment1(Assignment1.asm)

; Author: Brian Smith
; Course / Project ID : Assignment1                Date: 04 / 06 / 15
; Description:  A MASM program that performs the following tasks :
; 1. Display your name and program title on the output screen.
; 2. Display instructions for the user.
; 3. Prompt the user to enter two numbers.
; 4. Calculate the sum, difference, product, (integer)quotient and remainder of the numbers.
; 5. Display a terminating message.

INCLUDE Irvine32.inc

.data
display			BYTE	"Elementary Arithmetic		Brian Smith", 0
instructions	BYTE	"Enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
messageOne		BYTE	"Enter number one: ", 0
messageTwo		BYTE	"Enter number two: ", 0
plus			BYTE	" + ", 0
minus			BYTE	" - ", 0
multiply		BYTE	" * ", 0
divide			BYTE	" / ", 0
remainderStr	BYTE	" remainder ", 0
equal			BYTE	" = ", 0
terminate		BYTE	"Impressed? Bye!", 0
numOne			DWORD	?
numTwo			DWORD	?
sum				DWORD	?
difference		DWORD	?
product			DWORD	?
quotient		DWORD	?
remainder		DWORD	?

.code
main PROC

;// Display name and program title.
mov		edx, OFFSET display
call	WriteString
call	CrLf

;// Display instructions.
mov		edx, OFFSET instructions
call	WriteString
call	CrLf

;// Prompt user to enter two nunbers.
mov		edx, OFFSET messageOne
call	WriteString
call	ReadInt
mov		numOne, eax
mov		edx, OFFSET messageTwo
call	WriteString
call	ReadInt
mov		numTwo, eax

;// Calculate the sum.
mov		eax, numOne
add		eax, numTwo
mov		sum, eax

;// Calculate the difference.
mov		eax, numOne
sub		eax, numTwo
mov		difference, eax

;// Calculate the product.
mov		eax, numOne
mov		ebx, numTwo
mul		ebx
mov		product, eax

;// Calculate the quotient and remainder.
mov edx, 0
mov eax, numOne
mov ebx, numTwo
div ebx
mov quotient, eax
mov remainder, edx

;// Display addition
mov		eax, numOne
call	WriteDec
mov		edx, OFFSET plus
call	WriteString
mov		eax, numTwo
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, sum
call	WriteDec
call	Crlf

;// Display subtraction
mov		eax, numOne
call	WriteDec
mov		edx, OFFSET minus
call	WriteString
mov		eax, numTwo
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, difference
call	WriteDec
call	Crlf

;// Display multiplication
mov		eax, numOne
call	WriteDec
mov		edx, OFFSET multiply
call	WriteString
mov		eax, numTwo
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, product
call	WriteDec
call	Crlf

;// Display division
mov		eax, numOne
call	WriteDec
mov		edx, OFFSET divide
call	WriteString
mov		eax, numTwo
call	WriteDec
mov		edx, OFFSET equal
call	WriteString
mov		eax, quotient
call	WriteDec

;// Display remainder
mov		edx, OFFSET remainderStr
call	WriteString
mov		eax, remainder
call	WriteDec
call	Crlf
call	Crlf

;// Display terminate
mov		edx, OFFSET terminate
call	WriteString
call	Crlf

exit; exit to operating system
main ENDP

END main




