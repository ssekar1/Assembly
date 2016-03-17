

;Sundar Sekar
;Project 1
;convert.asm
;nasm -f elf64 convert.asm
;gcc -m64 -o convert  convert.o
;./convert                  # ./ needed if '.' not first in PATH

; Convert Decimal to Binary


extern printf
                
section .data		; preset constants, writeable
dec1:    db      '1','2','4','.','3','7','5',0
bin1:    dd      01010110110101B
m:       db      2
i:       dq      1000.0


                            
; print format
fmt1:      db      "-----------Conversion between bases:-----------",10,0
fmt2:      db      "The integer part of the decimal to binary is: %ld%ld%ld%ld%ld%ld",0
fmt3:      db      "The fraction part of the decimal to binary is:  .%ld%ld%ld",10,0
fmt4:      db      "The integer part of the binary to decimal is:   %ld",10, 0
fmt5:      db      "The fraction part of the binary to decimal is: NOT WORKING  .%ld",10,0
fmt6:      db      "%ld",10,0

        
section .bss                    ;uninitialized spaces                                                          
 ; stores dec->bin conversion
s1:            resq    1
s2:            resq    10


                
section .text           ; instruction, code segment                                      
	global main             ;for gcc standard linking                                                                                                       
main:        ;; converting the integer part                                           
	  push rbp                ;save rbp                                    
      mov rdi, fmt1
      mov rax, 0
      mov al, [dec1]         ;move first index of dec1                               
	  sub rax, 48             ;convert ASCII code to decimal                          
	  imul rax,100            ;multiply by its place value                            
	  mov [s1], rax
;-----
;		mov     rax,0		; accumulate value here
;        mov     al,[dec1]	; get first ASCII digit
;        sub     al,48      	; convert ASCII digit to binary
;        mov     rdi,1      	; subscript initialization
;		loop1: mov     rbx,0       	; clear register (upper part)
;        mov     bl,[dec1+rdi] 	; get next ASCII digit
;        cmp     bl,'.'          ; compare to decimal point
;        je      save           ; exit loop on decimal point
;        sub     bl,48           ; convert ASCII digit to binary
;        imul    rax,10          ; ignore rdx
;        add     rax,rbx         ; increment accumulator
;        inc     rdi             ; increment subscript
;        jmp     loop1
;---	  
	  
;parse and convert integer portion of dec->bin  
      mov rax, 0	      ; accumulate value here
      mov al,[dec1+1]        ;move second index to the register                       
	  sub rax, 48		; convert ASCII digit to binary
      imul rax, 10		; ignore rdx
      add rax, [s1]		; increment 
      mov [s1], rax
      mov rax, 0
      mov al, [dec1+2]       ;move the third index to the register                    
	  sub rax, 48
      add rax, [s1]            ;the decimal value of the number     
;   	 mov     rdx,0           ; must clear upper dividend
;        idiv    qword [ten]     ; quotient in rax
;        mov     rbx,0           ; clear register (upper part)
;        mov     bl,[dec1+rcx]	; get previous ASCII digit;
;		 cmp	bl, '.'		; if we're back at the dec
;		 je 	save2		; jmp to finish loop 
;        sub     bl,48           ; convert ASCII digit to binary
;        shl     rbx,32          ; move binary point 32-bits
;        add     rax,rbx         ; increment accumulator
;	  
	  mov [s1], rax
      mov rdx, 0			; subscript initialization
      mov rcx, 2
      div rcx
      mov [s1], rax
      mov rsi, rdx			; move array index into count
      mov rax, 0
      call printf            ;print the first line of the output                      
	  mov r8, 0*8             ;count                                                                                                                                                              

loop1:
      mov rax, 0
      mov rax, [s1]            ;load b to register                                                                                                                                                 
      mov rdx, 0
      mov rcx, 2              ;load 2 to the register rcx                                                                                                                                         
      div rcx                 ;divide by 2                                                                                                                                                        
;     
		;mov	rcx,rdi		; move array index into count
        ;add     rcx,3           ; loop iteration count initialization
        ;mov     rax,0           ; accumulate value here
        ;mov     al,[dec1+rcx]   ; get last ASCII digit
        ;sub     al,48           ; convert ASCII digit to binary
        ;shl     rax,32          ; move binary point
;

	 mov qword[s2+r8],rdx     ;save the reminder in the array c                                                                                                                                   
      mov [s1], rax
      add r8,8                ;increament the count                                                                                                                                               
      cmp r8, 5*8             ;compare if it is less than or equal                                                                                                                                
      jle loop1               ;jump instruction                                                                                                                                                   
	  mov rdi, fmt2           ;format to print out the converted binary number                                                                                                                    
      mov rsi, qword[s2+5*8]
      mov rdx, qword[s2+4*8]
      mov rcx, qword[s2+3*8]
	  mov r8, qword[s2+2*8]
      mov r9, qword[s2+1*8]
      mov r10, qword[s2+0*8]
      mov rax, 0				; clear accumulator
      call printf

      mov rdi, fmt6           ;format to printout the last remainder                                                                                                                              
      mov rsi, 0
      mov rax, 0		; clear accumulator
      call printf
;
		;mov     rdx,0           ; must clear upper dividend
        ;idiv    qword [ten]     ; quotient in rax
        ;mov     rbx,0           ; clear register (upper part)
        ;mov     bl,[dec1+rcx]	; get previous ASCII digit
		;cmp	bl, '.'		; if we're back at the dec
		;je 	save2		; jmp to finish loop 
       ;
        ;; converting the fraction part of decimal number                                                                                                                                                   
      mov rax, 0			; clear accumulator
      mov al, [dec1+4]       ;load the fourth index                                                                                                                                              
      sub rax, 48             ;change to decimal number                                                                                                                                           
      imul rax, 100           ;multiply it with the place value                                                                                                                                   
      mov [s1], rax
      mov rax, 0				; clear accumulator
      mov al,[dec1+5]         ;load the fifth index of the integer                                                                                                                               
      sub rax, 48              ;convert to the decimal number                                                                                                                                     
      imul rax, 10
      add rax, [s1]
      mov [s1], rax
      mov rax, 0		; clear accumulator
      mov al, [dec1+6]                                                                                                                                       
      ;
	   ;sub     bl,48           ; convert ASCII digit to binary
        ;shl     rbx,32          ; move binary point 32-bits
        ;add     rax,rbx         ; increment accumulator
	  ;
	  
	  sub rax, 48             ;convert to decimal                                                                                                                                                 
      add rax, [s1]
      mov [s1], rax
      mov rax, 0			; clear accumulator
      mov rcx, 0		; clear accumulator


loop2:
      mov rax, [s1]                                                                                                                                       
      imul rax, 2
      cmp rax, 1000                                                                                                                                   
      mov rdx, 0
      mov [s2+8], rdx                                                                                                                             
      add rcx, 1                                                                                                                                                               
      jle loop2       ;if rax is less than 1000 jump loop2                                                                                                                                        
      jg loop3        ;if rax is greater than 1000 jump to loop3                                                                                                                                  
;
	;push	rcx	; store rcx (loop counter and base)
	;push 	rax	; store rax (divisor)
	;mov	al, 1 	; dividen
	;pop 	rcx	; restore divisor for use
	;push	rcx	; save it again for rax
	;push 	rdx 	; idiv will destroy rdx
	;mov 	rdx, 0	; set quotient
;
loop3:          
	  mov rdx, 1      ; if rax is grater than rax store 1 in the array [s2]                                                                                                                        
      mov [s2+1*8], rdx
      add rcx, 1
      sub rax, 1000                                                                                                                         
      imul rax, 2                                                                                                                                                                
      cmp rax, 1000  ; compare 1000 with rax
      je loop4

loop4:         
	  mov rdx, 1
      mov [s2+3*8], rdx
      mov rax, 0			; clear accumulator
      mov rdi, fmt3
      mov rax, [s2]
      mov rsi, rax				; register (upper part)
      mov rdx, [s2+8]
      mov rcx, [s2+2*8]
      call printf
;
       ; mov     byte [abits+7],'.' ; end of dec. portion string
       ; mov     byte [abits+8],0   ; end of "C" string
       ; push    qword abits     ; string to print
       ; push    qword fmts      ; "%s"
;
	  mov rax, 0			; clear accumulator
	  mov rdi, fmt4
      mov rdx, [bin1]
      shld ax, dx, 11
      mov rsi, rax
      mov rax, 0			; clear accumulator
      call printf
;
	;	mov     rdx,0           ; clear rdx ready for a bit
    ;    shld    rdx,rax,1       ; top bit of rax into rdx
   ;     add     rdx,48          ; make it ASCII
  ;      mov     [abits+rcx-1],dl ; store character
 ;       ror     rax,1           ; next bit into top of rax
;        loop    loop4          ; decrement rcx, jump non zero

;
	  mov rax, 0			; clear accumulator
      mov rdx, 0
      mov rdx, [bin1]
      shl rdx, 11
      shld bx, dx, 5
      mov rdx, 0
	  ;
	  
        ;mov     byte [abits+3],10 ; end of "C" string at 3 places
        ;mov     byte [abits+4],0 ; end of "C" string
        ;push    qword abits     ; string to print
        ;push    qword fmts      ; "%s"
	  ;
      mov al, 1
      shl bx, 3
      mov ch, 0

loop5:
      cmp ch,4
      je loop6
      mov cl, 2
      mov bh, 0
	  ;
		;mov 	rbx, 0
		;mov 	rdx, [bin1]
		;shl 	rdx, 11
		;shld	bx, dx, 5	; shift fractional portion into bl 
		;mov 	rdx, 0	; accumulator
		;mov 	al, 1	; quotient
		;shl	bx, 3	; place 5 digits at end of bl
		;mov	ch, 0	; our count
	  ;
      imul cl
      shl bx, 1		; shift
      inc ch
      cmp bh, 1		, compare 1
      jne loop5
      push rcx				;store
      push rax
      mov al, 1
      pop rcx
      push rcx
      push rdx
      mov rdx, 0
;
;loop5: 	
;	cmp	ch, 4	; check to see that we've done all 5 digits
	;je 	save3	; finished 
;	mov 	cl, 2	; base to convert from1
;	mov	bh, 0	; clear bh
;	imul  	cl 	; multiply to get divisor in (1/32, 1/16,1/8,etc)
;	shl     bx, 1 	; place single digit in bh 
;	cmp 	bh, 1 	; if if fractional digit is a 1 accumlate value	
;	jne 	loop5
	
;

loop6:
      mov rdi, fmt5
      mov rsi, rdx
      mov rax, 0				; clear accumulator
      call printf
	  
	  pop rbp
      mov rax, 0				; clear accumulator
      ret

