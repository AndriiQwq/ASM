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

    flag db 0 ; Flag for controll a irrational values with dot

    ;0xa is 10('/n'), 0x9 is '/t'
    ;Operator $ read the current position of the diclaration and all next diclarations, 
    ;due to we declare it berfor the message

    h_argument db 'provided -h arg', 0xa  ; -h argument
    len_h_argument equ $ - h_argument ; Length of the -h argument

    r_argument db 'provided -r arg', 0xa ; -r argument
    len_r_argument equ $ - r_argument ; Length of the -r argument

    not_provided_correct_arguments db 'Not provided correct arguments', 0xa ; Message
    len_not_provided_correct_arguments equ $ - not_provided_correct_arguments ; Message length 

    comp_error_msg db 'Comp error occured', 0xa ;
    len_comp_error_msg equ $ - comp_error_msg

    help_msg dq 'Help:  informácie o programe a jeho použití: ', 0xa,'Hou to use: ', 0xa,  0x9, 'Input the file name nad press enter', 0xa,  'Arguments:',0xa,  0x9, '-h: help', 0xa,  0x9, '-r: recursive output', 0xa
    len_help_msg equ $ - help_msg

    ; numbers db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ; Array of numbers


section .bss ; segment of non-initialized data
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
    jne call_sxternal_function ; If not provided arguments, then go to single program execution

    cmp byte [rdi + 1], 'h' ; Check if the argument is -h(Help for user)
    je isHArgument

    ;CONTROL ANOTHER ARGUMENTS(-r)
    cmp byte [rdi + 1], 'r' ; Check if the argument is -r(Recursive output)
    je isRArgument
    jne no_arguments ; NOT PROVIDED CORRECT ARGUMENTS

    ;normal_exit

call_sxternal_function:
    call external_function  ; Call external function, which not provided correct argument

no_arguments:
    print_string not_provided_correct_arguments, len_not_provided_correct_arguments

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

    jmp read_loop


    close_file r15 ; Close the file 

    normal_exit

    ret

read_loop:
    read_string_from_the_file r15, buffer, BufferSize64
    cmp rax, 0
    jl comp_error ; Error during read
    ;je end_of_file ; End of file

    ;DO OPERATION WITH BUFFER, we use tow arays for readed input and output numbers
    mov r14, 0 ; Count of numbers
    mov r13, 0 ; iterator
    ; output_vector ; Is output vector for numbers
    mov r12, 0 ; Iterator for output vector

    ; Loop for counting numbers
    jmp count_numbers_loop
    ;IT NEED Return !!!, call 

    ; ; end_read:
    ; print_string r14, 5
    ; jmp read_loop

end_of_file:
    print_string output_vector, BufferSize64
    print_string r14, 5

    jmp normal_exit

do_white_space:
    ; Write space
    mov r9b, 0x20 ; Space
    mov byte [output_vector + r12], r9b 
    inc r12 ; Increment the ouput vector iterator

    ret

count_numbers_loop:
    ; Set dot flag to 0, this mean that dot was't found

    mov byte [flag], 0

    ; Check end of the buffer
    cmp r13, BufferSize64
    jge end_of_file ;ret 

    mov r8b, byte [buffer + r13]

    cmp r8b, '0'
    je found_number

    cmp r8b, '1'
    je found_number

    cmp r8b, '2'
    je found_number

    cmp r8b, '3'
    je found_number

    cmp r8b, '4'
    je found_number

    cmp r8b, '5'
    je found_number

    cmp r8b, '6'
    je found_number

    cmp r8b, '7'
    je found_number

    cmp r8b, '8'
    je found_number

    cmp r8b, '9'
    je found_number

    inc r13
    jmp count_numbers_loop

found_number:
    ; Write sign to the output vector
    mov r9b, byte [buffer + r13]
    mov byte [output_vector + r12], r9b 
    inc r12 ; Increment the ouput vector iterator
    ; End of writing in the output vector

    inc r13; Found the num, and inc the itrtator for input buffer
    mov r10b, byte [buffer + r13]; Check the next value 

    cmp r10b, '.'
    je found_dot

    ; mov byte [flag], 0 ;Its not dot

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

    jmp up_digit

found_dot: ; For example 1.2, we need to chendle sotuation when 6.. or 6.6.6 ot 6.gddfgdg
    ;Check if flag not correct, dot was found twice
    cmp byte [flag], 1
    je twice_dot_was_found ; Jump to the next iteration of finding the number
    ; Set dot flag
    mov byte [flag], 1

    inc r13; Found the num, and inc the itrtator for input buffer
    mov r10b, byte [buffer + r13]; Check the next value 

    cmp r10b, '.'
    je twice_dot_was_found

    cmp r10b, '0'
    je up_dot_and_digit

    cmp r10b, '1'
    je up_dot_and_digit

    cmp r10b, '2'
    je up_dot_and_digit

    cmp r10b, '3'
    je up_dot_and_digit

    cmp r10b, '4'
    je up_dot_and_digit

    cmp r10b, '5'
    je up_dot_and_digit

    cmp r10b, '6'
    je up_dot_and_digit

    cmp r10b, '7'
    je up_dot_and_digit

    cmp r10b, '8'
    je up_dot_and_digit

    cmp r10b, '9'
    je up_dot_and_digit

    ; If not found the number, this mean thhat it found the another symbol that 0-9
    ; Continue our finding the number with a new iteration

    jmp count_numbers_loop

twice_dot_was_found:
    inc r14        ; Increment number count
    mov byte [output_vector + r12], ' '
    inc r12

    jmp count_numbers_loop

up_digit:
    inc r14; Count of numbers

    ; Add the white space
    mov byte [output_vector + r12], 0x20 ; Space(0x20)
    inc r12 ; Increment the ouput vector iterator

    jmp count_numbers_loop

up_dot_and_digit: ; Provide to output vector the dot and number   
    ; Write sign to the output vector

    ; Write dot 
    mov r9b, '.'
    mov byte [output_vector + r12], r9b 
    inc r12 ; Increment the ouput vector iterator

    ; ; Write number
    ; mov r9b, byte [buffer + r13]
    ; mov byte [output_vector + r12], r9b 
    ; inc r12 ; Increment the ouput vector iterator

    ; Dont need code above, found_number will do it and continue the checking number

    jmp found_number

comp_error:
    error_exit comp_error_msg, len_comp_error_msg

isHArgument:
    ; Provided Instructions
    print_string h_argument, len_h_argument
    print_string help_msg, len_help_msg

    normal_exit            ; exit the program

isRArgument:
    print_string r_argument, len_r_argument

    normal_exit             ; exit the program
