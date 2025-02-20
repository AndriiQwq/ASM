; Zadanie č. [7] 
; Autor - Andrii Dokaniev
; Text konkrétneho riešeného zadania:
    ;7. Vypísať zo vstupu všetky čísla (aj viacciferné) a ich počet. 
    ; Vypracovane bonusové úlohy:

; Termín odovzdávania: 3/23/2025
; 2 Ročník, 2024/2025, letný semester, FIIT

; Program with discription: 

;Constants, defines
BufferSize64 equ 5000  ; constant 64kb
O_RDONLY equ 0 ; Only reading file flag 
FILE_NAME_SIZE equ 128 ; Filename size
section .data
    ; filename db "input.txt", 0 ; File for reading, or insted you can provide it as an argument
    ;                            ; 0 in the end use for determine the end of the string

    flag db 0 ; Flag for controll a irrational values with dot
    flag_minus db 0 ; Flag for controll a values with minus

    r_argument_is_presented db 0 ; Flag for reverse output

    ;0xa is 10('/n'), 0x9 is '/t'
    ;Operator $ read the current position of the diclaration and all next diclarations, 
    ;due to we declare it berfor the message

    clear db 27,'[2J',27,'[H'
    len_clear equ $ - clear

    h_argument db 'provided -h arg', 0xa  ; -h argument
    len_h_argument equ $ - h_argument ; Length of the -h argument

    r_argument db 'provided -r arg', 0xa ; -r argument
    len_r_argument equ $ - r_argument ; Length of the -r argument

    p_argument db 'provided -p arg, press J or K', 0xa ; -p argument
    len_p_argument equ $ - p_argument ; Length of the -p argument

    not_provided_correct_arguments db 'Not provided correct arguments', 0xa ; Message
    len_not_provided_correct_arguments equ $ - not_provided_correct_arguments ; Message length

    not_provided_arguments db 'Not provided arguments', 0xa
    len_not_provided_arguments equ $ - not_provided_arguments

    comp_error_msg db 'Comp error occured', 0xa ;
    len_comp_error_msg equ $ - comp_error_msg

    end_of_file_msg db 0xa,'End of riading file', 0xa
    len_end_of_file_msg equ $ - end_of_file_msg

    end_of_riading_buffer_msg db 0xa, 'End of riading buffer', 0xa
    len_end_of_riading_buffer_msg equ $ - end_of_riading_buffer_msg

    help_msg dq 'Help:  informácie o programe a jeho použití: ', 0xa,'Hou to use: ', 0xa,  0x9, 'Input the file name nad press enter', 0xa,  'Arguments:',0xa,  0x9, '-h: help', 0xa,  0x9, '-r: recursive output', 0xa
    len_help_msg equ $ - help_msg

    reversed_output_msg db 'Reversed output:', 0xa
    len_reversed_output_msg equ $ - reversed_output_msg

    count_of_numbers_msg db 0xa, 'Count of numbers:', 0
    len_count_of_numbers_msg equ $ - count_of_numbers_msg

    count_of_files_msg db 0xa, 'Count of files:', 0xa
    len_count_of_files_msg equ $ - count_of_files_msg
    ; numbers db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ; Array of numbers


section .bss ; segment of non-initialized data
    buffer resb BufferSize64 ; Reserve 65kb for buffer
    output_vector resb BufferSize64 ; Output

    buffer_int64 resb 20  ; Buffer for the string (enough for a 64-bit integer)

    files resb FILE_NAME_SIZE*8 ; Max 8 files with 128 symbols in the name(128B per filename)
    count_of_files resb 8; Count of files
    filename resb FILE_NAME_SIZE ; File name
    file_iterator resb FILE_NAME_SIZE ; File iterator, 8 bytes for it 

    pages resb BufferSize64*24 ; Max 24 pages with 512 symbols in the name(512B per page)
    current_page resb 0; Current page

    file_offset resq 1  

    current_file resq FILE_NAME_SIZE; has 8 bytes

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





    ; CHECK ARGUMENTS 
    jmp check_next_argument







    
    pop rdi    ; argv[1] is second argument(for example: -h);
    
    ; CHECK FILE NAMES, THEY HAVE FLAG "-f" and body "filename.txt"
    ; FIRST CHECK IF IT IS A DOCKUMENTATION FLAG

    ; Check first argument
    cmp byte [rdi], '-'
    jne call_external_function ; If not provided arguments, then go to single program execution

    cmp byte [rdi + 1], 'h' ; Check if the argument is -h(Help for user)
    je isHArgument

    cmp byte [rdi + 1], 'f' ; Check if the argument is -r(Recursive output)
    je read_file_name

    ;CONTROL ANOTHER ARGUMENTS(-r)
    cmp byte [rdi + 1], 'r' ; Check if the argument is -r(Recursive output)
    je isRArgument

    cmp byte [rdi + 1], 'p' ; Check if the argument is -p(strankovanie)
    je ispArgument

    jne eror_exit_not_provided_correct_argument; NOT PROVIDED CORRECT ARGUMENTS

read_file_name:;Calculate offset for storing new file name
    ; push r11
    pop rdi; arg, file name 
    mov r11, 0; offset for current name 
    call write_file_name
    
    
    mov edx, [file_iterator]
    add edx, FILE_NAME_SIZE
    mov [file_iterator], edx
    inc byte [count_of_files]

    
    jmp check_next_argument ;Check next argument

write_file_name:

    cmp byte [rdi + r11], 0
    je return_from_write
    cmp byte [rdi + r11], ' '
    je return_from_write
    jmp write_char

return_from_write:
    ; inc byte [count_of_files]    ;Increment count of files

    ; mov edx, [file_iterator]
    ; add edx, FILE_NAME_SIZE; to increase offset 
    ; mov [file_iterator], edx

    ret

write_char:
    mov rdx, [file_iterator] ; todo offset, and work on current file space  
    add rdx, r11       ; file address is files + (offset + r11) ;rdx now is offset in vector + current file offset
    mov al, [rdi + r11]  ; rdi is filname address
    mov byte [files + rdx], al ;al current symbol
    inc r11
    jmp write_file_name

check_next_argument:
    pop rdi
    cmp rdi, 0
    je end_of_args ; Not arguments any more
            
    cmp byte [rdi], '-'
    jne call_external_function ;

    cmp byte [rdi + 1], 'h'
    je isHArgument

    cmp byte [rdi + 1], 'f'
    je read_file_name

    cmp byte [rdi + 1], 'r'
    je set_r_flag

    cmp byte [rdi + 1], 'p'
    je ispArgument

    jne eror_exit_not_provided_correct_argument; NOT PROVIDED CORRECT ARGUMENTS

set_r_flag:
    mov byte [r_argument_is_presented], 1
    jmp check_next_argument

end_of_args:; MAIN BODI AFTER READING THE ARGUMENTS
    ; Iterate over the files
    movzx rcx, byte [count_of_files];count of files

    convert_int_to_str buffer_int64, [count_of_files]
    mov rcx, buffer_int64


    xor rbx, rbx; offset in the filenames vector

    mov qword [current_file], 0
    jmp iterate_files

iterate_files:
    ; movzx rcx, byte [count_of_files]
    cmp rcx, '0' ;test if count of files for processing is 0
    jz success_read_files
    
    ; convert_int_to_str buffer_int64, [file_iterator]
    ; print_string buffer_int64, 20

    mov rbx, [current_file]
    add rbx, FILE_NAME_SIZE

    ; Debag Info, start and end of slize
    ; convert_int_to_str buffer_int64, [current_file]
    ; print_string buffer_int64, 20

    ; convert_int_to_str buffer_int64, rbx
    ; print_string buffer_int64, 20

    retrive_substring files, filename, [current_file], rbx
    ; print_string filename, FILE_NAME_SIZE 

    ; COUNT OF FILES 
    print_string count_of_files_msg, len_count_of_files_msg
    convert_int_to_str buffer_int64, [count_of_files]
    print_string buffer_int64, 20

    mov [current_file], rbx
    dec rcx

    call process_file


    jmp iterate_files

; read_current_filename:
;     mov 

process_file:
    open_file filename, O_RDONLY, 0644; Syscall return the result of the operation in the rax register, so we need check it for errors

    cmp rax, 0
    jl comp_error ; jamp less than 0, syscall open return error code then is less than 0
    mov r15, rax; Save file descriptor, for reading from the file, file need the file descriptor

    mov r14, 0 ; Count of numbers
    mov r13, 0 ; iterator
    mov r12, 0 ; Iterator for output vector

    call read_loop

success_read_files:
    normal_exit

eror_exit_not_provided_correct_argument:
    error_exit not_provided_correct_arguments, len_not_provided_correct_arguments

call_external_function:
    call external_function  ; Call external function, which not provided correct argument
    jmp normal_exit

no_arguments:
    print_string not_provided_arguments, len_not_provided_arguments

    open_file filename, O_RDONLY, 0644
    ; Syscall return the result of the operation in the rax register, so we need check it for errors
    cmp rax, 0
    jl comp_error ; jamp less than 0, syscall open return error code then is less than 0

    mov r15, rax; Save file descriptor, for reading from the file, file need the file descriptor
    ; file descriptor is a unsigned value for indication the open file in the system

    ;DO OPERATION WITH BUFFER, we use tow arays for readed input and output numbers
    mov r14, 0 ; Count of numbers
    mov r13, 0 ; iterator
    ; output_vector ; Is output vector for numbers
    mov r12, 0 ; Iterator for output vector

    call read_loop

    close_file r15 ; Close the file 
    normal_exit

    ret

read_loop:
    ; ; Set offset in the file 
    ; mov eax, [current_page]
    ; imul eax, BufferSize64
    ; mov [file_offset], rax

    ; set_file_offset r15, file_offset

    read_string_from_the_file r15, buffer, BufferSize64

    ; print_string buffer, BufferSize64
    
    cmp rax, 0
    jl comp_error ; Error during read
    je end_of_file    ; EOF reached

    ; jmp count_numbers_loop    ; Loop for counting numbers
    call count_numbers_loop ; OPERATION WITH BUFFER, WRITING PAGE

    ; WRITE PAGE TO THE MEMORY from output_vector

    ; mov rsi, output_vector
    ; lea rdi, [pages]
    
    ; call copy_vector_to_page

    ; call go_to_next_page ;GO TO NEXT PAGE

    jmp read_loop

end_of_riading_to_buffer: ; End of reading one part of the file to buffer 
    print_string end_of_riading_buffer_msg, len_end_of_riading_buffer_msg

end_of_file: ; End of reading file
    print_string end_of_file_msg, len_end_of_file_msg

    ;END OF READING FILE
    ; ; Convert the count of numbers to the string, and out it out 
    cmp byte [r_argument_is_presented], 1
    je process_reversed_output

    call print_count_of_numbers
    print_string output_vector, BufferSize64

    call clear_output_buffer

    jmp iterate_files

process_reversed_output:
    clear_screen; Clear the screen
    ; Do outoput reverse
    print_string reversed_output_msg, len_reversed_output_msg

    ; Out the reversed output
    reverse_string output_vector, BufferSize64, buffer
    print_string buffer, BufferSize64

    call print_count_of_numbers

    jmp iterate_files


clear_output_buffer:
    cmp r12, BufferSize64
    jge end_of_clear_output_buffer
    mov byte [output_vector + r12], 0x20
    inc r12
    jmp clear_output_buffer

end_of_clear_output_buffer:
    pop rdi
    pop rcx
    jmp iterate_files  
    

do_white_space:
    ; Write space
    
    mov r9b, 0x20 ; Space
    mov byte [output_vector + r12], r9b 
    inc r12 ; Increment the ouput vector iterator
    
    ret

count_numbers_loop:
    ; Set dot flag to 0, this mean that dot was't found

    mov byte [flag], 0
    mov byte [flag_minus], 0

    ; Check end of the buffer
    cmp r13, BufferSize64
    jge end_of_riading_to_buffer ;ret 

    mov r8b, byte [buffer + r13]

    cmp r8b, '-'
    je found_minus

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

found_minus: ; '-' alwase at begin of the string
    mov byte [flag_minus], 1
    inc r13 ;input iterator

    ;check if next symbol is number
    mov r10b, byte [buffer + r13]

    cmp r10b, '0'
    je up_minus_and_digit

    cmp r10b, '1'
    je up_minus_and_digit

    cmp r10b, '2'
    je up_minus_and_digit

    cmp r10b, '3'
    je up_minus_and_digit

    cmp r10b, '4'
    je up_minus_and_digit

    cmp r10b, '5'
    je up_minus_and_digit

    cmp r10b, '6'
    je up_minus_and_digit

    cmp r10b, '7'
    je up_minus_and_digit

    cmp r10b, '8'
    je up_minus_and_digit

    cmp r10b, '9'
    je up_minus_and_digit

    jmp count_numbers_loop ; We set iterator to the next symbol, 
    ;and we can return to the main loop of fainding the numbers


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

    ; if not found the num after the dot, do white space
    call do_white_space
    inc r14; Count of numbers, we read the number and read dot, but after dot was not number

    jmp count_numbers_loop ; so , this is not a number, go to finding the next number

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

up_minus_and_digit:
    mov byte [output_vector + r12], 0x2D ; minus has kod 96
    inc r12 ; Increment the ouput vector iterator

    jmp found_number

comp_error:
    error_exit comp_error_msg, len_comp_error_msg

isHArgument:
    ; Provided Instructions
    print_string h_argument, len_h_argument
    print_string help_msg, len_help_msg

    normal_exit            ; exit the program

ispArgument: ; Paging 
    print_string p_argument, len_p_argument
    ; add J and K pres handlers 

    ; add iterator for pages


    normal_exit            ; exit the program

isRArgument:
    print_string r_argument, len_r_argument

    
    open_file filename, O_RDONLY, 0644; Syscall return the result of the operation in the rax register, so we need check it for errors
    cmp rax, 0
    jl comp_error ; jamp less than 0, syscall open return error code then is less than 0
    mov r15, rax; Save file descriptor, for reading from the file, file need the file descriptor

    mov r14, 0 ; Count of numbers
    mov r13, 0 ; iterator
    mov r12, 0 ; Iterator for output vector

    call read_loop

    ; ; NOW WE HAVE READED THE NUMBERS FROM FILE AND COUNTED THEM
    ; print_string output_vector, BufferSize64
    ; print_string r14, 5
    ; normal_exit     ;NEED ADD Check if -r argument is presenteds

    clear_screen; Clear the screen
    ; Do outoput reverse
    print_string reversed_output_msg, len_reversed_output_msg

    ; Out the reversed output
    reverse_string output_vector, BufferSize64, buffer
    print_string buffer, BufferSize64

    call print_count_of_numbers
    
    ; close_file r15 ; Close the file 
    ret             ; exit the program

print_count_of_numbers:
    ; Convert the count of numbers to the string, and out it out 
    print_string count_of_numbers_msg, len_count_of_numbers_msg
    
    convert_int_to_str buffer_int64, r14
    print_string buffer_int64, 20
    ret