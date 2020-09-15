; Brad Ward x86 Final Programming Project
; Combination/Permutation calculator
; Created on 12/05/18

includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib
EXTERN	printf:PROC
EXTERN	scanf:PROC

.DATA
menu		BYTE	"Please choose from one of the following menu selection", 13, 10, 0
menu1		BYTE	"1. Factorial", 13, 10, 0
menu2		BYTE	"2. Combination ", 13, 10, 0
menu3		BYTE	"3. Permutation ", 13, 10, 0, 0
factMenu	BYTE	"Please enter a number to find the factorial: ", 13, 10, 0
subMenu1	BYTE	"Please enter a value for N: ", 13, 10, 0
subMenu2	BYTE	"Please enter a value for R: ", 13, 10, 0
prompt		BYTE	"Enter a number: ", 13, 10, 0
prompt2		BYTE	"Enter a string: ", 13, 10, 0
prompt3		BYTE	"That input is not valid, please enter another: ", 13, 10, 0
prompt4		BYTE	"Do you want to run this program again (type yes to continue): ", 13, 10, 0
inFmt		BYTE	"%llu", 0
inFmt2		BYTE	"%s", 0
outFmtC		BYTE	"The number of possible combinations is %llu", 13, 10, 0
outFmtP		BYTE	"The number of possible permutations is %llu", 13, 10, 0
outFmt		BYTE	"The number is %llu", 13, 10, 0

num			QWORD	?
comNum1		QWORD	?
comNum2		QWORD	?
permNum1	QWORD	?
permNum2	QWORD	?
tempVal1	QWORD	?
continue	QWORD	?
factValue	QWORD	?
tryStr		BYTE	10 DUP (?)

.CODE
main PROC
AskInput:
	sub rsp, 120

	; printf(menu);
	lea rcx, menu
	call printf

	; printf(menu1);
	lea rcx, menu1
	call printf

	; printf(menu2);
	lea rcx, menu2
	call printf

	; printf(menu3);
	lea rcx, menu3
	call printf

	; printf(prompt);
	lea rcx, prompt
	call printf

	; read a number with scanf(inFmt, &num);
	lea rcx, inFmt
	lea rdx, num
	call scanf

CheckInput:
	; check which function needs to be called via user input
	cmp num, 1
	je CallFunc1 
	
	cmp num, 2
	je CallFunc2
	
	cmp num, 3
	je CallFunc3

	
	jmp IncorrectInput1	; if none, go to the incorrect input section
	
CallFunc1:
	; printf(factMenu);
	lea rcx, factMenu
	call printf

	; read a number with scanf(inFmt, &factValue);
	lea rcx, inFmt
	lea rdx, factValue
	call scanf

	push factValue		; store value
	call FactorialFunc	; get factorial of value
	mov factValue, rax	; store factorial in factValue
	pop rax				; clear stack of value

	; printf(outFmt, num);
	lea rcx, outFmt
	mov rdx, factValue
	call printf

	jmp TryAgain		; go to try again section

CallFunc2:
	call CombinationFunc	; run combination subroutine
	jmp TryAgain

CallFunc3:
	call PermutationFunc	; run permutation subroutine
	jmp TryAgain

IncorrectInput1:
	; printf(prompt3);
	lea rcx, prompt3
	call printf

	; read a number with scanf(inFmt, &num);
	lea rcx, inFmt
	lea rdx, num
	call scanf

	jmp CheckInput ; go back to check input

TryAgain:
	; printf(prompt3);
	lea rcx, prompt4
	call printf

	; read a number with scanf(inFmt, &tryStr);
	lea rcx, inFmt2
	lea rdx, tryStr
	call scanf

	; check the first character
	lea rdx, tryStr
	mov rax, [rdx]
	and rax, 255
	mov rcx, 121
	cmp rcx, rax
	jne EndOfProgram

	; check the second character
	mov rax, [rdx+1]
	and rax, 255
	mov rcx, 101
	cmp rcx, rax
	jne EndOfProgram

	; check the third character
	mov rax, [rdx+2]
	and rax, 255
	mov rcx, 115
	cmp rcx, rax
	jne EndOfProgram

	; check to see if user was being cheeky (you know who you are)
	mov rax, [rdx+3]
	and rax, 255
	mov rcx, 0
	cmp rcx, rax
	jne EndOfProgram

	; restore stack frame
	add rsp, 120

	jmp main

EndOfProgram:
	;restore stack frame 
	add rsp, 120
	ret
main ENDP

CombinationFunc PROC ; this subroutine will use the formula n!/r!(n-r)!
	; establish stack frame
	push rbp
	mov rbp, rsp
	sub rsp, 64

	; printf(subMenu1);
	lea rcx, subMenu1
	call printf

	; read a number with scanf(inFmt, &comValue1);
	lea rcx, inFmt
	lea rdx, comNum1
	call scanf

	;printf(subMenu2);
	lea rcx, subMenu2
	call printf

	;read a number with scanf(inFmt, &comValue2);
	lea rcx, inFmt
	lea rdx, comNum2
	call scanf

	; subtract (n-r) and store result in tempVal1
	mov rax, comNum1
	mov tempVal1, rax
	mov rax, comNum2
	sub tempVal1, rax

	; find n!
	push comNum1
	call FactorialFunc
	mov comNum1, rax
	pop rax

	; find r!
	push comNum2
	call FactorialFunc
	mov comNum2, rax
	pop rax

	; find (n-r)!
	push tempVal1
	call FactorialFunc
	mov tempVal1, rax
	pop rax

	; multiply r! * (n-r)!
	mov rax, comNum2
	mov rbx, tempVal1
	mul rbx

	; divide n! by the product of r! * (n-r)!
	mov rbx, rax
	mov rax, comNum1
	div rbx

	; get result from rax and store it
	mov comNum1, rax

	; printf(outFmtC, comNum1);
	lea rcx, outFmtC
	mov rdx, comNum1
	call printf

	; restore stack frame and leave subroutine
	add rsp, 64
	pop rbp

	ret
CombinationFunc ENDP

PermutationFunc PROC ; this subroutine will use the formula n!/(n-r)!
	; establish stack frame
	push rbp
	mov rbp, rsp
	sub rsp, 64

	; printf(subMenu1);
	lea rcx, subMenu1
	call printf

	; read a number with scanf(inFmt, &permNum1);
	lea rcx, inFmt
	lea rdx, permNum1
	call scanf

	; printf(subMenu2);
	lea rcx, subMenu2
	call printf

	; read a number with scanf(inFmt, &permNum2);
	lea rcx, inFmt
	lea rdx, permNum2
	call scanf

	; subtract n by r to get value for (n-r)!
	mov rax, permNum1
	mov tempVal1, rax
	mov rax, permNum2
	sub tempVal1, rax

	; get n!
	push permNum1
	call FactorialFunc
	mov permNum1, rax
	pop rax

	; get (n-r)!
	push tempVal1
	call FactorialFunc
	mov tempVal1, rax
	pop rax

	; divide n! by (n-r)!
	mov rbx, tempVal1
	mov rax, permNum1
	div rbx

	; store result in permNum1
	mov permNum1, rax

	; printf(outFmtC, permNum1);
	lea rcx, outFmtP
	mov rdx, permNum1
	call printf

	; restore stack frame
	add rsp, 64
	pop rbp

	ret
PermutationFunc ENDP

FactorialFunc PROC
	; establish stack frame
	push rbp
	mov rbp, rsp
	sub rsp, 64
	push rbx

	mov rax, [rbp + 16] ; get size of variable passed
	cmp rax, 0	; check if zero
	je endFunc	; if so, get out of recursive loop
	mov rbx, rax ; set rbx to current value of rax
	dec rax ; decrement eventually to zero
	push rax ; store current value of rax on stack for later usage in recursive loop
	call FactorialFunc ; RECURSION

	cmp rax, 0 ; see if current value of rax equals 0
	je SetValue

	mul rbx ; multiply current recursive value by old value stored in rbx
	jmp SkipSet ; skip the set value since we don't need it anymore

SetValue:
	mov rax, rbx ; if so, set rax to rbx which is 1 otherwise we start multiplying by zero

SkipSet:
	add rsp, 8 ; clear portion of stack pointer

endFunc:
	; restore stack frame and continue through recursion if needed
	pop rbx
	add rsp, 64
	pop rbp
	ret

FactorialFunc ENDP
END