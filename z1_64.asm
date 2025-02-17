; Zadanie č. [7] 
; Autor - Andrii Dokaniev
; Text konkrétneho riešeného zadania:
    ;7. Vypísať zo vstupu všetky čísla (aj viacciferné) a ich počet. 
    ; Vypracovane bonusové úlohy:

; Termín odovzdávania: 3/23/2025
; 2 Ročník, 2024/2025, letný semester, FIIT

; Program with discription: 

;Constants, defines
STDIN equ 0
STDOUT equ 1


section .data
    filename db "input.txt", 0 ; File for reading, or insted you can provide it as an argument
                               ; 0 in the end use for determine the end of the string

    msg db 'Hello, world!', 0xa ;Text (0xa is 10('/n'))
    len equ $ - msg ;Length of the text
    
    h_argument db 'provided -h', 0xa, 0x9, 'New'  ; -h argument
    k_argument db 'provided -k', 0xa ; -k argument

    len_h_argument equ $ - h_argument ; Length of the -h argument
    len_k_argument equ $ - k_argument ; Length of the -k argument

    ; numbers db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ; Array of numbers


section .bss ; segment of non-initialized data
    ; num resb 5 ; Allocating 5 bytes for the num variable
    buffer resb 65456 ; Reserve 65kb for buffer


section .text
    global _start ; Start of the program
    %include "macros.inc"  ; Include macros

    extern external_function  ; Include external function

_start:
    pop rax         ; argc
    dec rax         ; Decrement argc, for determine the count of arguments

    cmp rax, 0
    je .no_arguments ; If not provided arguments, then go to single program execution

    pop rbx         ; argv[0] is first argument(file name)

    
    pop rdi         ; argv[1] is second argument(for example: -h); pop rsi; argv[2] is third argument(for example: -k)

    ; Потом нужно будет добавить проверку, если аргументов предоставляется 2 сразу, без учета названия файла

    ; Check first argument
    cmp byte [rdi], '-'
    jne .no_arguments ; If not provided arguments, then go to single program execution
    cmp byte [rdi + 1], 'h'
    je .isHArgument

    ; cmp byte [rdi + 1], 'k'
    ; je .isHArgument

    ; CheckSecondArgument:; cmp byte [rsi], '-'


    call external_function  ; Call external function
    jmp .exit

.no_arguments:
    ; Print message
    mov rax, 1            ; system call (sys_write)
    mov rdi, 1            ; stdout
    mov rsi, msg          ; message to write
    mov rdx, len          ; message length
    syscall               ; call kernel
    jmp .exit             ; exit the program

.isHArgument:
    ; Print message
    mov rax, 1            ; system call (sys_write)
    mov rdi, 1            ; stdout
    mov rsi, h_argument   ; message to write
    mov rdx, len_h_argument ; message length
    syscall               ; call kernel
    jmp .exit             ; exit the program

.isKArgument:
    ; Print message
    mov rax, 1            ; system call (sys_write)
    mov rdi, 1            ; stdout
    mov rsi, k_argument   ; message to write
    mov rdx, len_k_argument ; message length
    syscall               ; call kernel
    jmp .exit             ; exit the program

.exit:
    ; Corrected stopping the program
    mov rax, 60           ; system call (sys_exit)
    xor rdi, rdi          ; Code of return status (0) added to rdi register

    syscall               ; call kernel
