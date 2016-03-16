; Sundar Sekar
; Proj 3

extern  fprintf, fgets, atoi, strlen, strcpy

%define     MAX_NAME    9
%define     MAX_ID      2
%define     MAX_INPUTS  5
%define SYSCALL_WRITE 4
%define STDOUT 1
%define SYSCALL_EXIT 1
%define STDIN 1 

SECTION .data
ID        db      "Please enter ID : ", 0
Name      db      "Please enter Name : ", 0
Info      db      "ID: %2d, Name: %s", 10, 0 
fmtchar     db      "%c", 0

SECTION .bss
ArrayID     resd    5
ArrayName   resd    5
TempBuf     resb    MAX_NAME

SECTION .text
main:
        mov     dword [STDIN],eax          
        add     eax,  32
        mov     dword [STDOUT],eax     
   
    mov     ebx, 1
    xor     edi, edi

.GetInput:          
    push    ebx
    push    ID
    push    dword [STDOUT]
    call    fprintf                         ; Display ID Prompt
    add     esp, 4 * 3

    push    dword [STDIN]
    push    MAX_ID
    push    TempBuf
    call    fgets                           ; Get ID
    add     esp, 4 * 3
       
    push    TempBuf
    call    atoi                            ; Convert to Number
    add     esp, 4 * 1

    mov     dword [ArrayID + 4 * edi], eax  ; move to our ID Array

    push    ebx
    push    Name
    push    dword [STDOUT]
    call    fprintf                         ; Display Name Prompt
    add     esp, 4 * 3

    push    dword [STDIN]
    push    MAX_NAME - 1
    push    TempBuf
    call    fgets                           ; Get Name
    add     esp, 4 * 3
       
    push    TempBuf
    call    strlen                          ; Len of name
    add     esp, 4 * 1
    dec     eax
    push    eax
    mov     byte [TempBuf + eax], 0         ; replace NL with NULL
 
    
    add     esp, 4 * 1
    mov     dword [ArrayName + 4 * edi], eax ; save pointer to our array
    
    push    TempBuf
    push    eax
    call    strcpy                          ; copy string to our Array
    add     esp, 4 * 2 
   
    inc     edi
    inc     ebx
    cmp     edi, MAX_INPUTS                 ; repeat 5 times
    jne     .GetInput
    
    call    PrintValues

   
PrintValues:

    push    10
    push    fmtchar
    push    dword [STDOUT]
    call    fprintf                         ; Print Newline
    add     esp, 4 * 3
    
    xor     edi, edi

.Display:
    push    dword [ArrayName + 4 * edi]
    push    dword [ArrayID + 4 * edi]
    push    Info
    push    dword [STDOUT]
    call    fprintf                         ; Display info
    add     esp, 4 * 4
    
    inc     edi
    cmp     edi, MAX_INPUTS                 ; repeat 5 times
    jne     .Display
    ret    
    
   

