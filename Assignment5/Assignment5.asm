TITLE Assignment5						(Assignment5.asm)

; Description:
; Write and test a MASM program to perform the following tasks :
; 1. Introduce the program.
; 2. Get a user request in the range[min = 10 ..max = 200].
; 3. Generate request random integers in the range[lo = 100 ..hi = 999], storing them in consecutive elements of an array.
; 4. Display the list of integers before sorting, 10 numbers per line.
; 5. Sort the list in descending order(i.e., largest first).
; 6. Calculate and display the median value, rounded to the nearest integer.
; 7. Display the sorted list, 10 numbers per line.

; Revision date : 05 / 22 / 15

INCLUDE Irvine32.inc

;  Macros

; Stack frame macro.
frame macro
push ebp
mov ebp, esp
ENDM

;  Division macro.
divide macro num1, num2
mov  eax, num1
mov  ebx, num2
mov  edx, 0
div  ebx
ENDM

;  Constants
null = 0
min = 10
max = 200
lo = 100
hi = 999
me EQU <"Brian Smith">

.data

instruct1 BYTE "Assignment 5 	Programmed by ", me, 10, 13,
"This program generates random numbers in the range [", 0
instruct2 BYTE 	" - ", 0
instruct3 BYTE 	"],", 10, 13, "displays the unsorted list, sorts it, and calculates the",
10, 13, "median. Lastly, it displays the list in the sorted descending order.",
10, 13, 10, 13, 10, 13, 0
prompt1   BYTE 	"How many numbers would you like to generate? [", 0
prompt2   BYTE 	"]: ", 0
error1 	  BYTE 	10, 13, "Invalid input. Try again.", 10, 13, 0
error2    BYTE 	10, 13, "The program will now exit.", 10, 13, 0
unsorted  BYTE 	10, 13, 10, 13, "Unsorted list:", 10, 13, 10, 13, 0
sorted 	  BYTE 	10, 13, 10, 13, "Sorted list:", 10, 13, 10, 13, 0
mPrompt	  BYTE 	"Median: ", 0
spaces	  BYTE 	" 	", 0

num	      DWORD   null
arrayP    DWORD   ?
heap      DWORD   ?
flags     DWORD   HEAP_ZERO_MEMORY

.code
main PROC

	call Randomize

	push OFFSET instruct1
	push OFFSET instruct2
	push OFFSET instruct3
	call introduction

	push OFFSET prompt1
	push OFFSET instruct2
	push OFFSET prompt2
	push OFFSET error1
	push OFFSET num
	call getData

	mov eax, num
	mov ebx, 4
	mul ebx
	mov edx, eax

	INVOKE GetProcessHeap
	mov heap, eax

	INVOKE HeapAlloc, heap, flags, edx
	cmp eax, null
	je isNull
	mov arrayP, eax
	jmp continue

	isNull:
		call Clrscr
		mov edx, OFFSET error2
		call WriteString
		jmp finish

	continue:

		push OFFSET unsorted
		push OFFSET spaces
		push arrayP
		push num
		call arrayFill
		call listDisplay

		push arrayP
		push num
		call listSort

		push OFFSET mPrompt
		push arrayP
		push num
		call displayMedian

		push OFFSET sorted
		push OFFSET spaces
		push arrayP
		push num
		call listDisplay

		INVOKE 	HeapFree, heap, flags, arrayP

	finish:
		exit
main ENDP

introduction PROC

	frame

	mov edx, [ebp + 16]
	call WriteString
	mov eax, lo
	call WriteDec
	mov edx, [ebp + 12]
	call WriteString
	mov eax, hi
	call WriteDec
	mov edx, [ebp + 8]
	call WriteString
	pop  	ebp
	ret  12
introduction ENDP

getData PROC

	frame

	setup:

		mov edx, [ebp + 24]
		call WriteString
		mov eax, min
		call WriteDec
		mov edx, [ebp + 20]
		call WriteString
		mov eax, max
		call WriteDec
		mov edx, [ebp + 16]
		call WriteString

	read:

		call ReadInt

		cmp eax, min
		jl nval

		cmp eax, max
		jg nval

		mov ebx, [ebp + 8]
		mov [ebx], eax
		jmp finish

	nval:

		mov edx, [ebp + 12]
		call WriteString
		jmp setup

	finish:

		pop ebp
		ret 20
getData ENDP

arrayFill PROC

	frame

	mov eax, (hi - lo) + 1
	mov ecx, [ebp + 8]
	mov edx, 0
	mov esi, [ebp + 12]

	generate:

		call RandomRange
		add eax, lo
		mov[esi], eax
		add esi, 4
		loop generate

		pop ebp
		ret
arrayFill ENDP

listSort PROC
LOCAL numLoc: DWORD

	mov eax, [ebp + 8]
	mov numLoc, eax
	dec numLoc
	mov esi, [ebp + 12]
	mov ecx, numLoc

	outter:
		
		push ecx
		mov ecx, numLoc
		mov esi, [ebp + 12]

	inner:

		mov eax, [esi]
		cmp[esi + 4], eax
		jl lessThan
		push[esi + 4]
		push[esi]
		call swap
		pop[esi]
		pop[esi + 4]

	lessThan:
	
		add esi, 4
		loop inner
		pop ecx
		loop outter

	finish:
			
		ret 8
listSort ENDP

swap PROC

	frame

	mov eax, [ebp + 12]
	mov ebx, [ebp + 8]
	mov[ebp + 12], ebx
	mov[ebp + 8], eax
	pop ebp
	ret
swap ENDP

displayMedian PROC
LOCAL arraySize: DWORD, med: DWORD, loMed: DWORD, hiMed: DWORD, divisor: DWORD

	call Crlf
	call Crlf

	mov eax, [ebp + 8]
	mov esi, [ebp + 12]
	mov arraySize, eax
	mov divisor, 2
	divide arraySize, 2
	mov med, eax
	mov eax, med
	mov ebx, 4
	mul  ebx
	mov ecx, eax

	mov eax, [esi + ecx]
	mov hiMed, eax

	mov eax, [esi + ecx - 4]
	mov loMed, eax

	divide arraySize, 2
	cmp edx, 0
	jg print

	fild hiMed
	fiadd loMed
	fidiv divisor
	fistp hiMed

	print:
				
		mov edx, [ebp + 16]
		call WriteString
		mov eax, hiMed
		call WriteDec
		call Crlf

	finish:

		ret 12
displayMedian ENDP

listDisplay PROC

	frame

	mov edx, [ebp + 20]
	call WriteString

	mov ecx, [ebp + 8]
	mov edx, [ebp + 16]
	mov esi, [ebp + 12]
	mov ebx, 0

	display:

		mov eax, [esi]
		call WriteDec
		call WriteString

		add esi, 4
		cmp ebx, 10
		jne notTen
		mov ebx, 0
		inc ebx
		call Crlf

	notTen:

		loop display
		call Crlf
		call Crlf

		pop ebp
		ret 16
listDisplay ENDP

END main