; Brad Ward x86 Assembly Fibonacci Sequence Program
.586
.MODEL FLAT
.STACK 4096

.DATA
count		DWORD 0 ; variable for storing current count
nthValue	DWORD 7 ; hard coded variable for nth fibonacci number
tempValue	DWORD 0 ; temporary variable for storing offset memory addresses
fibArr		DWORD ? ; address of array holding fibonacci numbers

.CODE
main PROC

	mov eax, 0
	mov ecx, nthValue ; load hard coded number into register
	mov esi, 0

StartFibo:
	mov esi, count ; get the current count

	cmp esi, nthValue ; compare if current count is at hard coded value
	je SetFinalValue

	cmp esi, 0 ; check if count is at 1st value
	je SetFirstValue
	cmp esi, 1 ; check if count is at 2nd value
	je SetSecondValue
	cmp esi, 1 ; check if count is above 2nd value
	ja SetFiboValues
	
SetFirstValue:
	mov fibArr[4*esi], 1 ; if first value, set to 1
	inc count ; increment
	jmp StartFibo ; go back to main loop

SetSecondValue:
	mov fibArr[4*esi], 1 ; if second value, set to 1
	inc count ; increment
	jmp StartFibo ; go back to main loop

SetFiboValues:
	mov ebx, count ; store count in temp value using register
	mov tempValue, ebx 

	sub tempValue, 1 ; decrement temp count
	mov esi, tempValue 
	mov ebx, fibArr[4*esi] ; find previous value in array

	sub tempValue, 1 ; decrement temp count again
	mov esi, tempValue 
	mov ecx, fibArr[4*esi] ; find previous value in array

	add ebx, ecx ; add two previous values together

	mov esi, count ; get current count number
	mov fibArr[4*esi], ebx ; store result of addition
	inc count ; increment count
	jmp StartFibo ; go back to main loop

SetFinalValue:
	sub esi, 1 ; decrement because of counter increment because of main loop
	mov eax, fibArr[4*esi] ; store result of fibonacci number in eax
	ret

main ENDP

END main