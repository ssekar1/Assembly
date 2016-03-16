

;Sundar Sekar
;Project 4



SECTION .data
 
Msg1: db "Enter a number between 0 and 255: ", 0
Msg2: db "Enter a base between 2 and 9: ", 0
Msg3: db 'The entered value is %d', 10, 0
Msg4: db 'The base of the value is %d', 10, 0
Msg5: db '8d', 10, 0

numFormat db '%d', 0 
stringFormat db '%s', 0
WriteCode   db 'w',0
OpenCode    db 'r',0	
WriteBase   db 'Line #%d: %s',10,0	
NewFilename db 'output.txt',0			

 
SECTION .bss
LineCount   resd 1		; Reserve integer to hold line count
IntVal resd 1
BaseVal resd 1
ans resd 9
i resd 1
n resd 1
j resd 1


SECTION .text

  ;puts macro
%macro PUTS 1
    push %1
    call puts 
    add esp, 4
%endmacro
 
; Save macro to store
%macro SAVE 0
    push eax
    push ecx
    push edx
%endmacro
 
; restore macro
%macro RESTORE 0
    pop edx
    pop ecx
    pop eax
%endmacro
 

; scanf macro
%macro SCANF 2
    push %1
    push %2 
    call scanf
    add esp, 8 
%endmacro
 
 ;print1 macro
%macro PRINTF1 1
    push %1        
    call printf
    add esp, 4
%endmacro
 
 ;print2 macro
%macro PRINTF2 2
    push %1         
    push %2       
    call printf
    add esp, 8 
%endmacro

global _start
; ------------------------------------------------------------------------
; MAIN PROGRAM BEGINS HERE
;-------------------------------------------------------------------------
_start:
	nop  
	  
extern puts 
extern scanf
extern printf 
extern fopen
extern fclose
extern fprintf 

 
main:
 ; set up stack for debuging
    push ebp    
    mov ebp, esp
    push ebx
    push esi
    push edi
   
  ; check value if in range 
Value:
    PRINTF1 Msg1
 
    push IntVal
    push numFormat
    call scanf
    add esp, 8
    SCANF IntVal, numFormat
	mov eax, dword[IntVal]
	
	;check the value if =0
    mov ebx, dword 0                
    cmp eax, ebx
    jb Value
    mov eax, dword[IntVal]

	;check the value if =255
    mov ebx, dword 255          
    cmp eax , ebx
    ja Value
    ;VALID INTEGER 


Base:
    PRINTF1 Msg2

    SCANF BaseVal, numFormat
 
    mov eax, dword[BaseVal]
    mov ebx, dword 0
    cmp eax, ebx
    jb Base
    mov eax, dword[BaseVal]
    mov ebx, dword 9
    cmp eax, ebx
    ja Base
 
;END BASE 

    
    mov eax, dword[IntVal]
    mov [n], eax    
    PRINTF2 eax, Msg3
    mov eax, dword 0
    mov [i], eax 
    mov eax, dword[BaseVal]
    PRINTF2 eax, Msg4

Division:
   
    xor edx, edx 
    mov eax, dword[n]
    mov ebx, dword[BaseVal]
    div ebx     
    mov [n], eax ;quotient

    PRINTF2 eax, Msg3 
    
    push edx   
    mov [n], eax 
 
    mov ebx, dword[i]
    inc ebx
    mov [i], ebx ;i++
 
    mov eax, [i]
    mov ecx, dword 8
    cmp ebx, ecx
    jb Division 

;END DIVISION

;; author write to file
;; write to file
;; Now we create a file to fill with the text we have:	
genfile:
	push WriteCode		; Push pointer to file write/create code ('w')
	push NewFilename	; Push pointer to new file name
	call fopen		; Create/open file
	add esp,8		; Clean up the stack
	mov ebx,eax		; eax contains the file handle; save in ebx

	;; File is open.  Now let's fill it with text:	
	mov edi,[LineCount]	; The number of lines to be filled is in edi

	push esi		; esi is the pointer to the line of text
	push 1			; The first line number
	push WriteBase		; Push address of the base string
	push ebx		; Push the file handle of the open file
	
writeline:
	cmp dword edi,0		; Has the line count gone to 0?
	je donewrite		; If so, go down & clean up stack
	call fprintf		; Write the text line to the file
	dec edi			; Decrement the count of lines to be written
	add dword [esp+8],1	; Update the line number on the stack
	jmp writeline		; Loop back and do it again
donewrite:		
	add esp,16		; Clean up stack after call to fprintf
	
	;; We're done writing text; now let's close the file:
closeit:	
	push ebx		; Push the handle of the file to be closed
	call fclose		; Closes the file whose handle is on the stack
	add esp,4
	

; end
end:
 
    pop edi
    pop esi
    pop ebx
    mov esp, ebp
    pop ebp
    ret