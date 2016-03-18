
;Sundar Sekar
;  plot.asm
; compile using   nasm -g -f elf64 plot.asm
;                 ld -o plot  plot.o        # not  gcc
;                 ./plot  >  plot.out
;                 cat  plot.out

	global _start

	section .data 	; Data section, initialized variables
;;;;;;;;;;;;;;;;;;;;;;;;;;
;#define ncol 41
;#define nrow 21
;int main(int argc, char *srgv[])
;{
;  char points[nrow][ncol]; // char == byte
;  char point = '*';
;  char space = ' ';

;;;;;;;;;;;;;;;;;;;;;;;;;;
numRow:	   	dq      21		; 21 rows
numCol:	  	dq      41		; 41 columns
star:	   	db      '*'		; one character '*'
len:	   	equ    	1		
a:	      	dq      1
b:	      	dq      10
Y:	      	dq      0.0
k:	      	dq      0

;;;;;;;;;;;;;;;;;;;;;;;;;;

;  long int i, j, k, rcx;
;  double af[] = {0.0, 1.0, 0.0, -0.166667,
;                 0.0, 0.00833, 0.0, -0.000198};
;  long int N = 7;
;  double x, y;
;  double dx = 0.15708; // 6.2832/40.0
;;;;;;;;;;;;;;;;;;;;;;;;;;
space:	    db      ' '     	; space
af:	     	dq      0.0, 1.0, 0.0, -0.166667, 0.0, 0.00833, 0.0, -0.000198   ; coefficients of polynomial, a_0 first
bF:	     	dq      0.0
N:	      	dq      7			; computed
l:	      	dq      1.0			; computed
xy:	     	dq      -10.0		; computed		; start XF
xyz:	    dq      20.0
Xaxix:	    dq      -3.14159
Yaxix:	    dq      0.15708			; increment for XF  ncol-1  times
one:   		dq      1.0
nten:   	dq      -10.0
twenty  	dq      20.0

;;;;;;;;;;;;;;;;;

;These 3 lines of "C" code become many lines of assembly
;   // clear points to space ' '
;   for(i=0; i<nrow; i++)
;     for(j=0; j<ncol; j++)
;       points[i][j] = space;

;;;;;;;;;;;;;;;;;
 	section .bss			; ncol=7, nrow=5 for demo

a2:	     resq    21*41 	; two dimensional array of bytes
c:	      resq  41
i:	      resq    1      	; row subscript
j:	      resq    1      	; col subscript

     section .text 	; Code section.

_start:	 			; the program label for the entry point

	;  clear a2 to space
	mov 	rax,0		; i=0 for(i=0;
	mov	[i],rax
	
loopi:
	
	mov	rax,[i]		; reload i, rax may be used
	mov rbx,0		; j=0
	mov	[j],rbx
	
loopj:
	
	mov		rax,[i]			; reload i, rax may be used
	mov		rbx,[j]			; reload j, rax may be used
	imul 	rax,[numCol]	; i*numCol
	add  	rax, rbx	; i*numCol + j
	mov 	dl, [space]	; need just character, byte
	mov 	[a2+rax],dl	; store space

	mov		rbx,[j]
	inc 	rbx		; j++
	mov	[j],rbx
	cmp 	rbx,[numCol]      ; j<numCol
	jne 	loopj

	mov		rax,[i]
	inc 	rax		; i++
	mov	[i],rax
	cmp		rax,[numRow]	; i<numCol
	jne 	loopi
	;;  end clear a2 to space
		; j = 0;
        ; xf = X0;
		
	mov	rax, 0
	mov	[j], rax
	fld	qword [Xaxix]
	fstp	qword [bF]	; initialize bF
	mov rdx, 0

loopj2:
	
	mov     rcx,[N]		; loop iteration count initialization, n
	fld     qword [af+8*rcx] ; accumulate value here, get coefficient a_n

h5loop:	

	fmul    qword [bF] ; * bF
	fadd    qword [af+8*rcx-8] ; + aa_n-i
	loop    h5loop		; decrement rcx, jump on non zero
	fstp    qword [Y]    	; store Y
    fld		qword [Y] ; moving the y value to floating point stack
	fadd	qword [l] ; add 1.0
    fmul	qword [xy] ; multiply by -10.0
    fadd	qword [xyz] ; add 20.0
    fistp	qword [k] ; k as integer
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	 ; k = 20.0 *(Y+1.0)*(-10.0)  fistp qword [k]
        ; rax  gets  k * ncol + j
        ; put "*" in dl, then dl into [a2+rax]

        ; XF = XF + DX0;
        ; j = j+1;
        ; if(j != ncol) go to sin

        ; copy clear a2 to space
        ; in jloop renamed, use  syscall print from hellos_64.asm
        ; add rax,a2   replaces  dl stuff
        ; mov rsi, rax (moved up) replaces  mov rsi, msg
        ; replace any  len  with  1 

        ; after jloop insert line feed  lf: db  10
        ; mov rsi, lf  in lpace of mov  rsi, rax

        ; use  exit code from  hellos_64.asm
        ; no push or pop  rbx
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; rax  gets  k * ncol + j
        ; put "*" in dl, then dl into [a2+rax]
	mov	rbx, [j]
    mov	rax,[k]
    imul	rax, [numCol]
    add	rax, rbx
	    ; XF = XF + DX0;
        ; j = j+1;
        ; if(j != ncol) go to sin
	mov 	[c+rdx*8], rax
	mov 	[a], rax
	mov	dl, [star]
    mov	[a2+rax], dl
		; copy clear a2 to space
        ; in jloop renamed, use  syscall print from hellos_64.asm
        ; add rax,a2   replaces  dl stuff
        ; mov rsi, rax (moved up) replaces  mov rsi, msg
        ; replace any  len  with  1 
	fld	qword [bF]	; next bF
	fadd	qword [Yaxix]
	fstp	qword [bF]
	add	rbx, 1
	 ; after jloop insert line feed  lf: db  10
        ; mov rsi, lf  in lpace of mov  rsi, rax
				; increment [j]
	mov	[j], rbx
	cmp	rbx, [numCol]
	jne	loopj2

;;;;;;;;;;;;;;;;;;;;;
; int main(int argc, char *srgv[])
; {
  ; char points[nrow][ncol]; // char == byte
  ; char point = '*';
  ; char space = ' ';
  ; long int i, j, k, rcx;
  ; double af[] = {0.0, 1.0, 0.0, -0.166667,
                 ; 0.0, 0.00833, 0.0, -0.000198};
  ; long int N = 7;
  ; double x, y;
  ; double dx = 0.15708; // 6.2832/40.0

  ; // clear points to space ' '
  ; for(i=0; i<nrow; i++)
    ; for(j=0; j<ncol; j++)
      ; points[i][j] = space;

  ; // compute points
  ; x = -3.14159;
  ; for(j=0; j<ncol; j++)
  ; {
    ; y = af[N]*x + af[N-1]; // horners h5loop
    ; for(rcx=N-2; rcx>=0; rcx--) y = y*x + af[rcx];
    ; k = (20.0 - (y+1.0)*10.0); // scale 1.0 to -1.0, 0 to 20
    ; points[k][j] = point;
    ; x = x + dx;
  ; }
;;;;;;;;;;;;;;;;;;;;;

	;  print
	mov 	rax,0		; i=0  for(i=0;
	mov	[i],rax
	
loopi3:
	mov	rax,[i]		; reload i, rax may be used
	mov 	rbx,0		; j=0  for(j=0;
	mov	[j],rbx
	
loopj3:

;;;;;;;;;;;;
 ;// print points
 ; for(i=0; i<nrow; i++)
 ; {
 ;   for(j=0; j<ncol; j++)
 ;     printf("%c", points[i][j]);
 ;   printf("\n");
 ; }
 ; return 0;
;;;;;;;;;;;;

	mov	rax,[i]		; reload i, rax may be used
	mov	rbx,[j]		; reload j, rax may be used
	mov 	dl, [space]		; need just character, byte

	imul 	rax,[numCol]  ; i*ncol
	add  	rax, rbx		; i*ncol + j
	add     rax,a2
	
	mov	rsi, rax
	mov	rax, 1		; system call 1 is write
	mov	rdi, 1		; file handle 1 is stdout
	
 ; // clear points to space ' '
  ; for(i=0; i<nrow; i++)
    ; for(j=0; j<ncol; j++)
      ; points[i][j] = space;
	  
	mov	rdx, 1
	; invoke operating system to do the write
	syscall		;library function that invokes the system call

	mov	rbx,[j]
	inc 	rbx		; j++
	mov	[j],rbx
	cmp 	rbx,[numCol]      ; j<numCol
	jne 	loopj3

	;;  write(1, msg, 13)         equivalent system command
	mov	rax, 1		; system call 1 is write
	mov	rdi, 1		; file handle 1 is stdout
	mov	rsi, b
	mov	rbx, 1
	; invoke operating system to do the write
	syscall 	;library function that invokes the system call
	

	mov	rax,[i]
	inc 	rax		; i++
	mov	[i],rax
	cmp	rax,[numRow]	; i<numCol
	jne 	loopi3
		
	;;  exit(0)                   equivalent system command
	mov     eax, 60			 ;system call 60 is exit
	xor     rdi, rdi		; exit code 0
	; invoke operating system to do the write
	syscall		;library function that invokes the system call
	

















	