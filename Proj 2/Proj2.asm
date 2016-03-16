;Sundar Sekar
;Assembly Project 2


section .bss
	BUFFLEN	equ 2048         ; Length of buffer
	Buff: 	resb BUFFLEN	; Text buffer itself

section .data
Msg1: db "Enter the Input: $"
Msg1Len: equ $-Msg1
Msg2: db "Sorting String: "
Msg2Len: equ $-Msg2

section .text
	global _start

_start:
	nop    
	     
Display:
	mov eax,4      ; 4 passed into eax register to specify sys_read call
	mov ebx,1      ; Specify File Descriptor 1: Standard Input
	mov ecx,Msg1   ; Pass offset of the message to read to
	mov edx,Msg1Len     ; Pass the length of the message
	int 80h  

; Read a buffer full of text from stdin:
read:
	mov eax,3		; Specify sys_read call
	mov ebx,0		; Specify File Descriptor 0: Standard Input
	mov ecx,Buff		; Pass offset of the buffer to read to
	mov edx,BUFFLEN		; Pass number of bytes to read at one pass
	int 80h			; Call sys_read to fill the buffer
	mov esi,eax		; Copy sys_read return value for safekeeping
	cmp eax,0		; If eax=0, sys_read reached EOF on stdin
	je Done			; Jump If Equal (to 0, from compare)


; Set up the registers for the process buffer step:
	mov ecx,esi		; Place the number of bytes read into ecx
	mov ebp,Buff		; Place address of buffer into ebp
	dec ebp			; Adjust count to offset

Scan:
	cmp byte [ebp+ecx],61h	; Test input char against lowercase 'a'
	jb Next			; If below 'a' in ASCII, not lowercase
	cmp byte [ebp+ecx],7Ah	; Test input char against lowercase 'z'
	ja Next			; If above 'z' in ASCII, not lowercase
				; At this point, we have a lowercase characters
	je Sort; jumpt to sort...

Next:	
	dec ecx			; Decrement counter
	jnz Scan		; If characters remain, loop back

; Selection Sort Method
Sort:
    DEC ECX        ; Decrement ECX
    MOV EBX,EDI    ; Save array pointer to EBX
    MOV EDX,ECX    ; Save number of compare to EDX

OuterLoop:
    MOV EDI,EBX    ; Restore array pointer     
    mov ESI,EDI
	inc ESI         ; 
    PUSH ECX        ; Save OuterLoop counter on stack
    MOV ECX,EDX     ; Initialize InnerLoop counter

InnerLoop: 
	;Compares byte at address EDI and ESI   
     ;CMPSB ; compare the first byte [EDI] with its neibourgh [ESI], advance EDI,ESI
	 MOV AL,BYTE [ESI] 
	CMP AL,BYTE [EDI]
	PUSHF
	 INC ESI
	 INC EDI 
	POPF
     JAE NoSwap
     CALL swap

NoSwap:
    LOOP InnerLoop
    POP ECX     ; Restore OuterLoop counter
    LOOP OuterLoop
	ret; go home

swap:
     MOV AL,byte[ESI-1]
     MOV AH,byte[EDI-1]
     MOV byte[ESI-1],AH
     MOV byte[EDI-1],AL
     ret; go home

; Write the buffer full of processed text to stdout
Write:
	mov eax,4		; Specify sys_write call
	mov ebx,1		; Specify File Descriptor 1: Standard output
	mov ecx,Buff		; Pass offset of the buffer
	mov edx,esi		; Pass the # of bytes of data in the buffer
	int 80h			; Make kernel call
	jmp Display		; jump to display

; Exit Call
Done:
	mov eax,1		; Code for Exit Syscall
	mov ebx,0		; Return a code of zero	
	int 80H			; Make kernel call