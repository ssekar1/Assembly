
;Sundar Sekar
;Project 2
;list_64.asm
; compile: 	nasm -g -f elf64 -l list_64.lst  list_64.asm	
; link:         gcc -g3 -m64 -o test_list_64 test_list_64.c  list_64.o
; run:		./test_list_64 > test_list_64.out
;		cat test_list_64.out


; list_part_64.asm  a partial coding of  list_64.c, rename list_64.asm
;	           (list_64.c included as comments)
;                  remove debug printout in final submitted version
; Just Part! This enters, prints parameters, the exits
;              standard function entry and exit used, not optimized

; list_64.c  these are the functions to implement in  list_64.asm
; #include <stdio.h>           ; extern printf   in list_64.asm
	extern	printf

; static char heap[20000] 	; space to store strings, do not reuse or free
; static char *hp = heap;	; pointer to next available heap space         
; static long int  list[1000];	; space to store list block (2 index+ pointer) 
; static long int  lp=1; 	; index to next available list space
; static char *q;    		; a variable pointer
; static long int i;  		; a variable index
	section .bss
heap:	resb	20000		; could be gigabytes
list:	resq	1000		; could be millions
q:	resq	1		; may be just in  rsi
i:	resq	1		; may be just in  rdi
		
	section	.data
hp:	dq	heap		; [hp] is pointer to next free heap
lp:	dq	1		; index of next available list item
fmt1:	db	"%s",10,0  ; "%s\n" for printf
fmt2:	db	10,0	   ; "\n" 
fmt_clear: db	"in clear, address of callers L is:  %lX", 10, 0
fmt_print:	db	"in print, address of callers L is:   %lX", 10, 0
fmt_push_front:	db	"in push_front, address of callers L is:   %lX *s is:   %s", 10, 0
fmt_push_back:	db	"in push_back, address of callers L is:   %lX *s is:   %s", 10, 0
fmt_pop_front:	db	"in pop_front, address of callers L is:   %lX", 10, 0
fmt_pop_back:	db	"in pop_back, address of callers L is:   %lX", 10, 0

;        +-----------------+   +-----------------+   +-----------------+
; L[0]-> |  index to next----->|  index to next----->|  0              |
;        |  0              |<-----index to prev  |<-----index to prev  |<-L[1]
;        | ptr to heap str |   | ptr to heap str |   | ptr to heap str |
;        +-----------------+   +-----------------+   +-----------------+
; The pointers to heap strings are character pointers to terminated strings.
; The "index" values could be pointers rather than indices.

; void clear(int *L)       ; initialize front and back pointers to zero 
; {
        section .text
	global clear
clear:
        push	rbp		; save rbp, no registers need saving

;   L[0]=0; ; later, will be index into "front" of list 
;   L[1]=0; ; later, will be index into "back" of list 
				; address of callers L is in rdi
	mov	rax,0
	mov	[rdi],rax	; L[0]=0
	mov	[rdi+8],rax	; L[1]=0
	mov	rax,rdi		; address of L, print it
	mov	rdi,fmt_clear
	mov	rsi,rax
	mov	rax,0
	call	printf

	pop	rbp
        ret			; return
; } // end clear

	
; void print(int *L)
; {
	global	print

print:
        push    rbp             ; save rbp                                      
        push    rbx             ; save registers                                
        push    rdi
        push    rsi
;   i=L[0]; ; index into front of 'list'
;   while(i)  ; keep looping until i==0, meaning end of list 
;   {
;     q=(char *)list[i+2]; 	; get this list items pointer to string
;     printf("%s\n",q);   	; print this list item's string 
;     i=list[i];              	; move to next list item 
;   }
;   printf("\n");             	; blank line after items 
;     i=L[0]; ; index into front of 'list'                                    
        mov rax, [rdi]          ; i in rax                                      
        mov [i], rax            ; save i                                        

;     while(i)  ; keep looping until i==0, meaning end of list                
;     {                                                                       
loop2:
        mov rax, [i]
        cmp rax, 0                                                   
        je  print1

;       q=(char *)list[i+2];          
;       printf("%s\n",q);     ; print list                
        mov     rax, [i]
        mov     rbx, [list+8*rax+16] ; q*                                       
        mov     rdi, fmt1
        mov     rsi, rbx        ; q*                                            
        mov     rax, 0          ; no float                                      
        call    printf

;       i=list[i];              ; move to next list item                      
;     }                                                                       
        mov rax, [i]
        mov rax, [list+8*rax]   ; rax = list[i]                                 
        mov [i], rax            ; save i=list[i]                                
        cmp rax, 0				; compare rax to 0
        je print1
        jne loop2
print1:
;                mov     rdi,fmt2
 ;               mov     rax, 0
  ;              call    printf
				mov	rax,rdi		; address of L, print it
				mov	rdi,fmt_print
				mov	rsi,rax
				mov	rax, 0
				call	printf
				
                pop     rsi     ; restore registers                                                                                                                                                         
                pop     rdi     ; in reverse order                                                                                                                                                          
                pop     rbx
                pop     rbp
                ret

;   } // end print                                                                                                                                                                                        

;   void push_front(int *L, char *s)                                                                                                                                                                      
;   {                                                                                                                                                                                                     
        global  push_front
push_front:
                push    rbp     ; save rbp                                                                                                                                                                  
                push    rbx     ; save registers                                                                                                                                                            
                push    rdi
                push    rsi

;   if(L[0]==0)           	; list is empty 
;   {
;     L[0]=lp;   		; front index 
;     L[1]=lp;   		; back index 
;     list[lp]=0;   		; new next index is end 
;   }
;   else
;   {
;     i=L[0];             	; save index to old front
;     L[0]=lp;  		; new front index
;     list[lp]=i;		; new next index is old front
;     list[lp+1]=0;		; new prev index is end
;      				; old front next is unchanged 
;     list[i+1]=lp;		; old front prev is now new front
;   }
;   list[lp+2]=(int)hp;		; list pointer to string on heap
;   lp=lp+3;    		; update to next free space in list
;   q=s;
;   while(*q)        		; copy string s to heap 
;   {
;     *hp=*q;      		; could be written *hp++=*q++;
;     hp++;
;     q++;
;   }
;   *hp=0;  			; save the final null and update heap pointer
;   hp++;   			; we should do range checking, but won't 				
				
;     if(L[0]==0)             ; list is empty                                                                                                                                                             

                        mov rax,[rdi]                   ; L[0] in rax                                                                                                                                       
                        cmp rax,0 ; test if equal to 0                                                                                                                                                                
                        jne f2 ; jump to f2                                                                                                                                                 


                        mov  rcx, [lp]
                        mov  [rdi],rcx
                        mov  [rdi+8],rcx
                        mov qword [list+8*rcx],0
                        mov qword [list+8*rcx+8],0
                        jmp end1

;     }                                                                                                                                                                                                   
;     else                                                                                                                                                                                                
;     {                                                                                                                                                                                                   
f2:

;       i=L[0];               ; save index to old front                                                                                                                                                   

                mov rcx, [rdi]
                mov qword [i], rcx


;       L[0]=lp;              ; new front index                                                                                                                                                           

                mov qword rcx,[lp]
                mov qword [rdi],rcx

;       list[lp]=i;           ; new next index is old front                                                                                                                                               
                mov rax, [lp]
                mov qword rcx, [i]
                mov qword [list+8*rax],rcx


;       list[lp+1]=0;         ; new prev index is end                         

                mov rax, [lp]
                mov qword [list+8*rax+8],0

;       old front next is unchanged            
;       list[i+1]=lp;         ; old front prev is now new front               

        mov qword [list+8*rcx+8], rax
;     }                             
end1:

;     list[lp+2]=(int)hp;             ; list pointer to string on heap        
;     lp=lp+3;                ; update to next free space in list             

                mov rbx,[lp]
                mov rax,[hp]
                mov [list+8*rbx+16], rax
                add rbx,3
                mov qword[lp], rbx


;     q=s;                                                                    
;     while(*q)                       ; copy string s to heap                 
;     {                                                                       
;       *hp=*q;               ; could be written *hp++=*q++;                  
;       hp++;                                                                 
;       q++;                                                                  
pf1:        mov     rcx,[hp]
                mov     rdx,0                       
                mov     dl,[rsi]                                   
                cmp     dl,0
                je      pf2
                mov     [rcx],dl
                inc     rcx
                mov     [hp],rcx
                inc     rsi
                jmp     pf1


;     }                                                                       
;     *hp=0;                          ; save the final null and update heap pointer                                                                          
;     hp++;                           ; we should do range checking, but won't                                                                               


pf2:
               ; mov     rdx,0
                ;mov     [rcx],dl
               ; inc     rcx
                ;mov     [hp],rcx
			mov	rax,rdi		; address of L, print it
			mov	rbx,rsi		; address of string, print it
			mov	rdi,fmt_push_front
			mov	rsi,rax
			mov	rdx,rbx
			mov	rax, 0
			call	printf
			
                pop     rsi     ; restore registers                             
                pop     rdi     ; in reverse order                              
                pop     rbx
                pop     rbp
                ret

;   } // end push_front                                                       


;   void push_back(int *L, char *s)                                           
;   {                                    

    global  push_back
push_back:
                push    rbp     ; save rbp                                      
                push    rbx     ; save registers                                
                push    rdi
                push    rsi

;     if(L[0]==0)               ; list is empty                             
                mov rax,[rdi]   ; L[0] in rax                                   
                cmp rax,0       ; test ==0                                      
                jne falseb      ; jump to false part                            



;     {                                                                     
;       L[0]=lp;                ; front index                               
;       L[1]=lp;                ; back index                                
;       list[lp]=0;             ; new next index is end                     
;       list[lp+1]=0;           ; new prev index is end                     
                mov  rcx, [lp]
                mov  [rdi],rcx
                mov  [rdi+8],rcx
                mov qword [list+8*rcx],0
                mov qword [list+8*rcx+8],0
				jmp endifb
;     }                                                                     

;     else                                                                  
;     {                                                                     
falseb:
;   else
;   {
;     i=L[1];             ; save index to old back 
;     L[1]=lp;            ; new back index
;     list[lp]=0;         ; new next is end
;     list[lp+1]=i;       ; new prev index is old back
;     list[i]=lp;         ; old back next is new back
;                         ; old back prev is unchanged 
;   }


;       i=L[1];             ; save index to old back                        
                mov rcx, [rdi+8]
                mov qword [i], rcx

;       L[1]=lp;            ; new back index                                
                mov qword rcx,[lp]
                mov qword [rdi+8],rcx

;       list[lp]=0;         ; new next is end                               
                mov rax, [lp]
                mov qword [list+8*rax],0

;       list[lp+1]=i;       ; new prev index is old back                    
                mov qword rcx, [i]
                mov qword [list+8*rax+8],rcx

;       list[i]=lp;         ; old back next is new back                     
                mov qword [list+8*rcx], rax

;                           ; old back prev is unchanged                    
;     }                                      

endifb:
;   list[lp+2]=(long int)hp;   ; list pointer to string on heap
;   lp=lp+3;              ; update to next free space in list

;   q=s;	; s is in rsi, do not need q
;   while(*q)             ; copy string s to heap 
;   {
;     *hp=*q;             ; could be written *hp++=*q++;
;     hp++;
;     q++;
;   }


;     list[lp+2]=(long int)hp;   ; list pointer to string on heap           
;     lp=lp+3;              ; update to next free space in list             
                mov rbx,[lp]
                mov rax,[hp]
                mov [list+8*rbx+16], rax
                add rbx,3
                mov qword[lp], rbx

;     q=s;      ; address s in rsi, q not needed                            

;     while(*q)             ; copy string s to heap                         
;     {                                                                     
;       *hp=*q;             ; could be written *hp++=*q++;                  
;       hp++;                                                               
;       q++;                                                                
pb3lab:        
				mov     rcx,[hp]
                mov     rdx,0   ; clear before loading byte                     
                mov     dl,[rsi] ; byte in rdx                                  
                cmp     dl,0
                je      pb4lab
                mov     [rcx],dl
                inc     rcx
                mov     [hp],rcx
                inc     rsi
                jmp     pb3lab
;     }                                                                     
;     *hp=0;                ; save the final null and update heap pointer   
;     hp++;                                                                 


pb4lab:
                mov     rdx,0
                mov     [rcx],dl
                inc     rcx
                mov     [hp],rcx

				mov	rax,rdi		; address of L, print it
				mov	rbx,rsi		; address of string, print it
				mov	rdi,fmt_push_back
				mov	rsi,rax
				mov	rdx,rbx
				mov	rax, 0
				call	printf
				
                pop     rsi     ; restore registers                             
                pop     rdi     ; in reverse order                              
                pop     rbx
                pop     rbp
                ret

;   } // end push_back                                                        


;   void pop_front(int *L)                                                    
;   {                                                                         
        global  pop_front
pop_front:
                push    rbp     ; save rbp                                      
                push    rbx     ; save registers                                
                push    rdi
                push    rsi
				
;   if(L[0]==0) return;  	; list is already empty
;   if(L[1]==L[0])       	; only one item on list 
;   {
;     L[0]=0;            	; delete one item, same as clear 
;     L[1]=0;
;     return;
;   }
;   i=L[0];              	; get index of old front 
;   i=list[i];           ; get next from old front
;   L[0]=i;              	; L[0] is new front
;                        	; new next is unchanged 
;   list[i+1]=0;         	; new prev is now end    

;     if(L[0]==0) return;     ; list is already empty                         
        mov rax, [rdi]
        cmp rax, 0
        je  last

;     if(L[1]==L[0])          ; only one item on list                         
;     {                                                                       
        mov rax, [rdi]
        mov rcx, [rdi+8]
        cmp rax, rcx
        jne pop
               mov     rax, 0
               mov     [rdi], rax ; L[0]=0                                      
               mov     [rdi+8], rax ; L[1]=0                                    
               jmp last
;       L[0]=0;               ; delete one item, same as clear                
;       L[1]=0;                                                               
;       return;                                                               
;     }                                                                       

pop:
;     i=L[0];                 ; get index of old front                        
        mov rcx, [rdi]
        mov qword[i], rcx
;     i=list[i];                                                              
                        ; get next from old front                               
        mov rcx, [i]
        mov rax, [list+8*rcx]
        mov qword[i],rax

;     L[0]=i;                 ; L[0] is new front                             
        mov [rdi],rax
        mov qword [list+8*rax+8],0
;     list[i+1]=0;            ; new prev is now end  

                                                        
last:
			mov	rax,rdi		; address of L, print it
			mov	rdi,fmt_pop_front
			mov	rsi,rax
			mov	rax, 0
			call	printf

                pop     rsi     ; restore registers                             
                pop     rdi     ; in reverse order                              
                pop     rbx
                pop     rbp
                ret             ; return                                        
;   } // end pop_front                                                        

;   void pop_back(int *L)                                                     
;   {                                                                         
        global  pop_back
pop_back:
                push    rbp     ; save rbp                                      
                push    rbx     ; save registers                                
                push    rdi
                push    rsi

				;   if(L[1]==0) return;  	; list already empty 
;   if(L[1]==L[0])		; only one item on list 
;   {
;     L[0]=0; 			; delete one item, same as clear 
;     L[1]=0;
;     return;
;   }
;   i=L[1];			; get index of back 
;   i=list[i+1]; 		; get index of prev to back
;   L[1]=i;  			; L[1] is new back
;   list[i]=0; 			; new next is now end
;  

;     if(L[1]==0) return;     ; list already empty                            
        mov rcx, [rdi+8]
        cmp rcx, 0
        je last2
;     if(L[1]==L[0])          ; only one item on list                         
;     {                                                                       
        mov rcx, [rdi]
        mov rax, [rdi+8]
        cmp rcx,rax
        jne  pop2

               mov     rax, 0
                mov     [rdi], rax ; L[0]=0                                     
                mov     [rdi+8], rax ; L[1]=0                                   
        jmp last2
pop2:
;       L[0]=0;                       ; delete one item, same as clear        
;       L[1]=0;                                                               
;       return;                                                               
;     }                                                                       
;     i=L[1];                 ; get index of back                             
        mov rcx, [rdi+8]

;     i=list[i+1];            ; get index of prev to back                     
        mov rax, [list+8*rcx+8]
        mov qword[i],rax
;     L[1]=i;                         ; L[1] is new back                      
        mov rax, [i]
        mov [rdi], rax
;     list[i]=0;                      ; new next is now end                   
        mov qword[list+8*rax],0
;                            new prev is unchanged                          

last2:

			mov	rax,rdi		; address of L, print it
			mov	rdi,fmt_pop_back
			mov	rsi,rax
			mov	rax, 0
			call	printf

                pop     rsi     ; restore registers                             
                pop     rdi     ; in reverse order                              
                pop     rbx
                pop     rbp
                ret             ;return    

				
; } // end pop_back
; end list_part_64.asm file 