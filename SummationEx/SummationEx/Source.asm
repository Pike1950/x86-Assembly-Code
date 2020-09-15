includelib libcmt.lib
includelib libvcruntime.lib
includelib libucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

num		QWORD 3

main PROC
	;establish stack frame
	sub rsp, 120
	push rbp
	mov rbp, rsp
	push num
	call summation
	;restore old stack frame
	add rsp, 8

	mov rcx, 5
	mov rdx, 6
	call addTwo

	pop rbp
	add rsp, 120
	ret
main ENDP

summation PROC
	push rbp
	mov rbp, rsp
	sub rsp, 64
	push rax
	push rbx

	mov rax, [rbp + 16]
	cmp rax, 0
	je endFunc
	mov rbx, rax
	dec rax
	push rax
	call summation
	add rax, rbx
	add rsp, 8

endFunc:
	pop rbx
	add rsp, 64
	pop rbp
	ret
summation ENDP

addTwo PROC
	push rbp

addTwo ENDP