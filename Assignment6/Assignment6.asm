TITLE	Assignment6		(Assignment6.asm)

; Author: Brian Smith
; Course / Project ID : CS271 / Assignment6                Date : 6/3/15
; Description: 
; Implement and test your own ReadVal and WriteVal procedures for unsigned integers.
; Implement macros getString and displayString.  The macros may use Irvine’s ReadString to get input from the user, and WriteString to display output.
; getString should display a prompt, then get the user’s keyboard input into a memory location
; displayString should the string stored in a specified memory location.
; readVal should invoke the getString macro to get the user’s string of digits.It should then convert the digit string to numeric, while validating the user’s input.
; writeVal should convert a numeric value to a string of digits, and invoke the displayString macro to produce the output.
; Write a small test program that gets 10 valid integers from the user and stores the numeric values in an array.The program then displays the integers, their sum, and their average.

INCLUDE Irvine32.inc

; MACRO Definitions

displayString MACRO displayAddress
push 	edx
mov 	edx, displayAddress
call 	writestring
pop 	edx
endm

getString MACRO prompt1, stringAddress
push	edx
push 	ecx
push	eax

mov		edx, prompt1
call	WriteString

mov 	edx, stringAddress
mov 	ecx, MAX_SIZE
call 	ReadString

pop		eax
pop 	ecx
pop		edx
endm

; Constant Definitions
MAX_SIZE = 100; Represents the max size of string to be entered
INPUT_NUM = 10; Number of integers the user needs to input 0

.data
intro1		    BYTE	"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures", 0
intro2			BYTE	"Written by: Brian Smith", 0
instruct1	    BYTE	"Please provide 10 unsigned decimal integers.", 0
instruct2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.", 0
instruct3		BYTE	"After you have finished inputting the raw numbers I will display a list", 0
instruct4		BYTE	"of the integers, their sum, and their average value.", 0
prompt1			BYTE	"Please enter an unsigned number: ", 0
prompt2			BYTE	"Please try again: ", 0
arrayDelimiter	BYTE 	", ", 0
arrayPrompt		BYTE	"You entered the following numbers: ", 0
goodBye			BYTE	"Thanks for playing!", 0
inputError		BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0
sum_arr_msg		BYTE	"The sum of these numbers is: ", 0
avg_arr_msg		BYTE	"The average is: ", 0

unsortedArray	DWORD	INPUT_NUM DUP(0)
input1			BYTE 	MAX_SIZE + 1 DUP(? )
input2			BYTE 	MAX_SIZE + 1 DUP(? )
inputLength		DWORD	LENGTHOF input1
inputSize		DWORD	TYPE input1
result			DWORD	0
recursiveHolder	BYTE 	2 DUP(? )
arraySum		DWORD 	0

.code
main PROC
; Introduction
push 	OFFSET intro1
push 	OFFSET intro2
call	introduction

push 	OFFSET instruct1
push 	OFFSET instruct2
push 	OFFSET instruct3
push 	OFFSET instruct4
call	instructions

;  Get User Data
push	OFFSET result
push	OFFSET input2
push	OFFSET input1
push	inputSize
push	inputLength
push	OFFSET inputError
push	OFFSET prompt2
push	OFFSET prompt1
push	INPUT_NUM
push 	OFFSET unsortedArray
call	getUserInputArray

; Display Array
call 	CrLf
displayString OFFSET arrayPrompt
call 	CrLf

push	OFFSET recursiveHolder
push	INPUT_NUM
push 	OFFSET unsortedArray
call 	displayArray

; Calculate and Display Sum of Array
push	OFFSET sum_arr_msg
push	OFFSET recursiveHolder
push	OFFSET arraySum
push	INPUT_NUM
push 	OFFSET unsortedArray
call 	displaySum

; Calculate and Display Average of Array
push	OFFSET avg_arr_msg
push	OFFSET recursiveHolder
push	arraySum
push	INPUT_NUM
call 	displayAverage

; Farewell
push 	OFFSET goodBye
call	farewell

exit
main ENDP

;  This procedure displays the program title and programmer's name
introduction PROC
pushad
mov 	ebp, esp

displayString[ebp + 40]
call	CrLf

displayString[ebp + 36]
call	CrLf

popad
ret 8
introduction ENDP

;  This procedure displays the program instructions
instructions PROC
pushad
mov		ebp, esp

call	CrLf
displayString[ebp + 48]
call	CrLf
displayString[ebp + 44]
call	CrLf
displayString[ebp + 40]
call	CrLf
displayString[ebp + 36]
call	CrLf
call	CrLf
call	CrLf

popad
ret 16
instructions ENDP

; This procedure gets the user input
getUserInputArray PROC
pushad
mov ebp, esp
mov ecx, [ebp + 40]
mov esi, [ebp + 36]

NumInput:

	push[ebp + 44]
	push[ebp + 48]
	push[ebp + 52]
	push[ebp + 56]
	push[ebp + 60]
	push[ebp + 64]
	push[ebp + 68]
	push[ebp + 72]
	call	readVal

	mov 	ebx, result
	mov[esi], ebx
	add 	esi, 4

	mov		eax, 0
	mov		result, eax

	loop NumInput

popad
ret	40
getUserInputArray ENDP


; This procedure gets the user string input and converts it to a number
readVal PROC
push	eax
push	ebx
push	ecx
push	edx
push	esp
push	esi
push	edi
push	ebp

mov		ebp, esp
sub 	esp, 8

mov		eax, [ebp + 52]
mov		DWORD PTR[ebp - 8], eax
mov		eax, 0

getString[ebp + 64], [ebp + 44]
jmp		read

invalid:

	mov ecx, 0
	mov	edx, 0
	mov	eax, 0
	mov	ebx, 0

	push[ebp + 48]
	push[ebp - 8]
	push[ebp + 44]
	call clearElements

	push[ebp + 48]
	push[ebp - 8]
	push[ebp + 40]
	call clearElements

	displayString[ebp + 56]
	call CrLf
	getString[ebp + 60], [ebp + 44]

read:

	mov esi, [ebp + 44]
	mov edi, [ebp + 40]
	mov ecx, [ebp + 52]
	mov edx, 0

	cld

valLoop : LODSB

	cmp	al, 0
	je valLoopDone

	sub al, 48
	cmp	al, 0
	jl invalid
	cmp	al, 9
	jg	invalid

	inc edx
	STOSB

	loop valLoop

valLoopDone:
				
	cmp edx, 0
	je  invalid

	mov ecx, 0

	dec edx
	mov	DWORD PTR[ebp - 4], edx
	mov esi, [ebp + 40]
	mov edi, [ebp + 36]
	mov	eax, 0
	cld
							  
stringToInt: LODSB
														   
	mov ebx, 10
	mov ecx, edx

	mov DWORD PTR[ebp - 4], edx

	cmp	ecx, 0
	je store

multiply:
						
	mul ebx
	jo  invalid
	loop multiply

store:

	mov	ebx, [edi]
	add eax, ebx
	mov[edi], eax

	jc  invalid

	mov edx, [ebp - 4]

	cmp		edx, 0
	je finish

	dec edx
	mov eax, 0
	loop stringToInt

finish:

	mov	esp, ebp
	pop ebp
	pop	edi
	pop esi
	pop esp
	pop edx
	pop ecx
	pop ebx
	pop eax

	ret 32
readVal ENDP

clearElements PROC
pushad
mov ebp, esp
mov esi, [ebp + 36]
mov ecx, [ebp + 40]
mov ebx, [ebp + 44]
mov eax, 0
								
cmp ecx, 0
jle	finish

								  
start:
						
	mov[esi], eax
	add esi, ebx
	loop 	start

finish:

	popad
	ret 12
clearElements ENDP

; This procedure displays the given array
displayArray PROC
pushad
mov ebp, esp
mov ecx, [ebp + 40]
mov esi, [ebp + 36]

next:

	push[ebp + 44]
	push[esi]
	call writeVal

	add esi, 4

	mov ebx, 1
	cmp ebx, ecx
	je skipLast

	mov	edx, OFFSET arrayDelimiter
	call writestring

skipLast:
	
	loop next

	call CrLf

	popad
	ret 12
displayArray ENDP
 
;  This procedure displays the given integer
writeVal PROC
pushad
mov ebp, esp

mov eax, [ebp + 36]
mov ebx, 10

;  Recursive Definition
cdq
div ebx
cmp eax, 0
jne recursion
jmp baseCase

recursion:

	push[ebp + 40]
	push eax
	call writeVal

baseCase:

	add dl, 48
	mov edi, [ebp + 40]
	mov[edi], dl
	displayString[ebp + 40]

	popad
	ret 8
writeVal ENDP

;  This procedure displays the sum of all the elements in a given integer array
displaySum PROC
pushad

mov ebp, esp
mov eax, 0
mov ecx, [ebp + 40]
mov esi, [ebp + 36]
mov edi, [ebp + 44]

displayNextElement :

	add eax, [esi]
	add esi, 4
	loop displayNextElement
	mov[edi], eax

	displayString[ebp + 52]

	push[ebp + 48]
	push[edi]
	call writeVal
	call CrLf

	popad
	ret 20
displaySum ENDP

;  This procedure displays the average of all the elements in a given integer array.
displayAverage PROC
	pushad

	mov ebp, esp
	mov eax, 0
	mov ebx, [ebp + 36]
	mov eax, [ebp + 40]

	cdq
	div ebx

	displayString[ebp + 48]

	push[ebp + 44]
	push eax
	call writeVal
	call CrLf

	popad
	ret 16
displayAverage ENDP

;  Procedure outputs the end of program messages
farewell PROC
	pushad
	mov ebp, esp

	call CrLf
	call CrLf
	displayString[ebp + 36]
	call CrLf

	popad
	ret 4
farewell ENDP
END main