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
BufferSize64 equ 65536 ; constant 64kb
O_RDONLY equ 0 ; Only reading file flag 

section .data
    filename db "input.txt", 0 ; File for reading, or insted you can provide it as an argument
                               ; 0 in the end use for determine the end of the string

    flag db 0

    ;0xa is 10('/n')
    ;Operator $ read the current position of the diclaration and all next diclarations, 
    ;due to we declare it berfor the message

    h_argument db 'provided -h arg', 0xa  ; -h argument
    len_h_argument equ $ - h_argument ; Length of the -h argument

    k_argument db 'provided -k arg', 0xa ; -k argument
    len_k_argument equ $ - k_argument ; Length of the -k argument

    not_provided_arguments db 'Not provided arguments', 0xa ; Message
    len_not_provided_arguments equ $ - not_provided_arguments ; Message length 

    comp_error_msg db 'Comp error occured', 0xa ;
    len_comp_error_msg equ $ - comp_error_msg

    ; numbers db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ; Array of numbers


section .bss ; segment of non-initialized dataф
    ; num resb 5 ; Allocating 5 bytes for the num variable
    buffer resb BufferSize64 ; Reserve 65kb for buffer
    output_vector resb BufferSize64 ; Output

section .text
    global _start ; Start of the program
    %include "macros.inc"  ; Include macros

    extern external_function  ; Include external function

_start:
    pop rax     ; argc
    dec rax     ; Decrement argc, for determine the count of arguments

    cmp rax, 0
    je no_arguments ; If not provided arguments, then go to single program execution

    ; Else get the arguments
    pop rbx    ; argv[0] is first argument(file name), skip it

    
    pop rdi    ; argv[1] is second argument(for example: -h); pop rsi; argv[2] is third argument(for example: -k)

    ; Потом нужно будет добавить проверку, если аргументов предоставляется 2 сразу, без учета названия файла

    ; Check first argument
    cmp byte [rdi], '-'
    jne no_arguments ; If not provided arguments, then go to single program execution

    cmp byte [rdi + 1], 'h' ; Check if the argument is -h(Help for user)
    je isHArgument

    ; cmp byte [rdi + 1], 'k' ; Check if first argument is another argument then -h
    ; je .isKArgument

    call external_function  ; Call external function

    normal_exit

no_arguments:
    print_string not_provided_arguments, len_not_provided_arguments

    open_file filename, O_RDONLY, 0644
    ; Syscall return the result of the operation in the rax register, so we need check it for errors
    cmp rax, 0
    jl comp_error ; jamp less than 0, syscall open return error code then is less than 0

    mov r15, rax; Save file descriptor, for reading from the file, file need the file descriptor
    ; file descriptor is a unsigned value for indication the open file in the system

    ; read_string_from_the_file r15, buffer, BufferSize64
    ; cmp rax, 0
    ; jl comp_error ; Check result of operation

    ; print_string buffer, BufferSize64


    call read_loop


    close_file r15 ; Close the file 

    normal_exit

read_loop:
    read_string_from_the_file r15, buffer, BufferSize64
    cmp rax, 0
    jle normal_exit; End of file or error 

    ;DO OPERATION WITH BUFFER
    mov r14, 0 ; Count of numbers
    mov r13, 0 ; iterator

    ; Loop for counting numbers
    jmp count_numbers_loop




    ; end_read:
    print_string r14, 5

    jmp read_loop


count_numbers_loop:
    ; flag if 0

    mov r8b, byte [buffer + r13]

    cmp r8b, 0
    je found_number

    cmp r8b, 1
    je found_number

    cmp r8b, 2
    je found_number

    cmp r8b, 3
    je found_number

    cmp r8b, 4
    je found_number

    cmp r8b, 5
    je found_number

    cmp r8b, 6
    je found_number

    cmp r8b, 7
    je found_number

    cmp r8b, 8
    je found_number

    cmp r8b, 9
    je found_number

    inc r13
    jmp count_numbers_loop

found_number:
    inc r13
    mov r10b, byte [buffer + r13]

    cmp r10b, '0'
    je found_number

    cmp r10b, '1'
    je found_number

    cmp r10b, '2'
    je found_number

    cmp r10b, '3'
    je found_number

    cmp r10b, '4'
    je found_number

    cmp r10b, '5'
    je found_number

    cmp r10b, '6'
    je found_number

    cmp r10b, '7'
    je found_number

    cmp r10b, '8'
    je found_number

    cmp r10b, '9'
    je found_number

    jmp found_digit

found_digit:
    inc r14
    jmp count_numbers_loop

comp_error:
    error_exit comp_error_msg, len_comp_error_msg

isHArgument:
    ; Provided Instructions

    print_string h_argument, len_h_argument

    normal_exit            ; exit the program

isKArgument:
    print_string k_argument, len_k_argument

    normal_exit             ; exit the program
