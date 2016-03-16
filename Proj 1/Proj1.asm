/*
Sundar Sekar
Assembly Project 1
*/

section .bss
	Buff resb 1

section .data
Msg1: db "Enter one char: $",10
Msg1Len: equ $-Msg1
Msg2: db "**********",10
Aster: db "*$"
result db CR, LF, "Here is the output: $" ;carriage return and line feed
 
section .text
	global _start

_start:
	nop             

Msg: 
Read:	
	mov eax,3      ; 3 passed into eax register to specify sys_read call
	mov ebx,0      ; Specify File Descriptor 0: Standard Input
	mov ecx,Msg1   ; Pass offset of the message to read to
	mov edx,Msg1Len      ; Pass the length of the message
	int 80h        ; Call sys_read

Uppercase:
	cmp eax,0	; Look at sys_read's return value in EAX
	je Exit		; Jump If Equal to 0 (0 means EOF) to Exit
			; or fall through to test for lowercase
	cmp byte [Buff],61h  ; Test input char against lowercase 'a'
	jb Write	; If below 'a' in ASCII chart, not lowercase
	cmp byte [Buff],7Ah  ; Test input char against lowercase 'z'
	ja Write	; If above 'z' in ASCII chart, not lowercase
			; At this point, we have a lowercase character
	sub byte [Buff],20h  ; Subtract 20h from lowercase to give uppercase...
			; ...and then write out the char to stdout

Lowercase:
	cmp eax,0	; Look at sys_read's return value in EAX
	je Exit		; Jump If Equal to 0 (0 means EOF) to Exit
			; or fall through to test for lowercase
	cmp byte [Buff],41h  ; Test input char against lowercase 'A'
	jb Write	; If below 'a' in ASCII chart, not lowercase
	cmp byte [Buff],5Ah  ; Test input char against lowercase 'Z'
	ja Write	; If above 'z' in ASCII chart, not lowercase
			; At this point, we have a lowercase character
	add byte [Buff],20h  ; add 20h from uppercase to give lowercase...
			; ...and then write out the char to stdout

Stars:
	mov edx, Msg1  
	mov eax, 9
	int 21h

	mov edx, Msg2
	mov eax, 0Ah        
	int 21h                    ; read number

	mov edx, result
	mov eax, 9
	int 21h   
	             
	mov edx, asterysk            ;  writes "*" into edx 
	mov eax, 9
	////incomplete/////

Write:  
	mov eax,4	; Specify sys_write call
	mov ebx,1	; Specify File Descriptor 1: Standard output
	mov ecx,Buff	; Pass address of the character to write
	mov edx,1	; Pass number of chars to write
	int 80h		; Call sys_write...
	jmp Read	; ...then go to the beginning to get another character

Exit:	
	mov eax,1	; Code for Exit Syscall
	mov ebx,0	; Return a code of zero to Linux
	int 80H		; Make kernel call to exit program
