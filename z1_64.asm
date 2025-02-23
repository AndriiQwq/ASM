; Zadanie č. [7] 
; Autor - Andrii Dokaniev
; Text konkrétneho riešeného zadania:
    ; 7. Vypísať zo vstupu všetky čísla (aj viacciferné) a ich počet. 
    ; Vypracovane bonusové úlohy:
        ; 1. Correct handling files above 64kb
        ; 2. Support for reading files from arguments, and support by default 8 files
        ; 3. Support for reverse output (-r)
        ; 4. Support for paging output (-p)
        ; 5. Quality of the documentation
        ; 6. External function for function of the program
        ; 7. Using function for string instructions (MOVS, CMPS, STOS, ...)
        ; 8. Suport paging for input files (-p)
        ; 9. Sliding pages using "j" and "k" buttons

; Termín odovzdávania: 3/23/2025
; 2 Ročník, 2024/2025, letný semester, FIIT

; Program with discription: 
; For help use -h argument

;Constants, defines
BufferSize64 equ 65536 ; constant 64kb
O_RDONLY equ 0 ; Only reading file flag 
FILE_NAME_SIZE equ 128 ; Filename size
NUMBER_SIZE equ 20 ; Number size
section .data
    flag db 0 ; Flag for controll a irrational values with dot
    flag_minus db 0 ; Flag for controll a values with minus

    r_argument_is_presented db 0 ; Flag for reverse output
    p_argument_is_presented db 0 ; Flag for paging output

    ;0 determine the end of the string
    ;0xa is 10('/n'), 0x9 is '/t'
    ;Operator $ read the current position of the diclaration and all next diclarations, 
    ;due to we declare it berfor the message

    clear db 27,'[2J',27,'[H'
    len_clear equ $ - clear

    succsfull_exit db 'Succesfull exit, exit code: 0', 0xa
    len_succsfull_exit equ $ - succsfull_exit

    r_argument db 'provided -r arg.', 0xa ; -r argument
    len_r_argument equ $ - r_argument ; Length of the -r argument

    p_argument db 'provided -p arg, press J or K.', 0 ; -p argument
    len_p_argument equ $ - p_argument ; Length of the -p argument

    not_provided_correct_arguments db 0xa, 'Not provided correct arguments.', 0xa ; Message
    len_not_provided_correct_arguments equ $ - not_provided_correct_arguments ; Message length

    not_provided_arguments db 'Not provided arguments.', 0xa
    len_not_provided_arguments equ $ - not_provided_arguments

    see_documentation_help_msg db 'See documentation for help(-h)', 0xa
    len_see_documentation_help_msg equ $ - see_documentation_help_msg

    comp_error_msg db 'Error occured.', 0xa, 'Exit code: 1', 0xa
    len_comp_error_msg equ $ - comp_error_msg

    filename_msg db 0xa, 'Filename:'
    len_print_filename_msg equ $ - filename_msg

    end_of_file_msg db 0xa,'End of reading file.', 0xa
    len_end_of_file_msg equ $ - end_of_file_msg

    screen_separator db 0xa, '-----------------------------------', 0xa
    len_screen_separator equ $ - screen_separator

    string_separator db '|', 0
    len_string_separator equ $ - string_separator

    slesh_separator db '/', 0
    len_slesh_separator equ $ - slesh_separator

    persent_separator db '%', 0
    len_persent_separator equ $ - persent_separator

    data_not_presented_msg db 'Data not presented.', 0
    len_data_not_presented_msg equ $ - data_not_presented_msg

    end_of_reading_buffer_msg db 0xa, 'End of reading buffer.', 0
    len_end_of_reading_buffer_msg equ $ - end_of_reading_buffer_msg

    reach_reange_msg db 'You reach the the boundary of sliding pages. ', 0xa, 'Press "j" for next page, and "k" for previous page.', 0
    len_reach_reange_msg equ $ - reach_reange_msg

    help_msg0 db 'Help:', 0x0
    len_help_msg0 equ $ - help_msg0 

    help_msg1 dq 'Information about program and his using:', 0xa, 0x9, 'This program suport file above 64kb, and can read the files from arguments', 0xa, 0x9,'By default program suport 8 files from arguments', 0xa
    len_help_msg1 equ $ - help_msg1

    help_msg2 dq 'Hou to use: ', 0xa,  0x9, 'Input the file name nad press enter. ', 0xa, 0x9,'The prgramm read the files from the arguments, and the you can see it by pressing Enter button.', 0xa, 0x9,'If you using the -p argument you, after this you can slide the pages using "j" and "k" buttons, and presing Enter button. Press "q" for exit.', 0xa
    len_help_msg2 equ $ - help_msg2

    help_msg3 dq 'Exemple:', 0xa, 0x9, 'program_name -f file1.txt -f file2.txt -r -p', 0xa, 'Arguments:',0xa,  0x9, '-h: help', 0xa,  0x9, '-r: recursive output', 0xa, 0x9, '-p: paged output', 0xa,  0x9, '-f: file name', 0xa
    len_help_msg3 equ $ - help_msg3
    
    reversed_output_msg db 'Reversed output:', 0xa
    len_reversed_output_msg equ $ - reversed_output_msg

    single_output_msg db 'Output:', 0xa
    len_single_output_msg equ $ - single_output_msg

    count_of_numbers_msg db 0xa, 'Count of numbers:', 0
    len_count_of_numbers_msg equ $ - count_of_numbers_msg

    count_of_files_msg db 'Count of files:', 0
    len_count_of_files_msg equ $ - count_of_files_msg

    all_files_readed_msg db 'All files readed', 0xa
    len_all_files_readed_msg equ $ - all_files_readed_msg

    out_of_range_by_minus db 'Out of range by minus', 0xa
    len_out_of_range_by_minus equ $ - out_of_range_by_minus

    out_of_range_by_plus db 'Out of range by plus', 0xa
    len_out_of_range_by_plus equ $ - out_of_range_by_plus

section .bss ; segment of non-initialized data
    buffer resb BufferSize64 ; Reserve 65kb for buffer
    output_vector resb BufferSize64 ; Output

    buffer_int64 resb 20  ; Buffer for the string (enough for a 64-bit integer)

    files resb FILE_NAME_SIZE*8 ; Max 8 files with 128 symbols in the name(128B per filename)
    count_of_files resb 8; Count of files
    filename resb FILE_NAME_SIZE ; File name
    file_iterator resb FILE_NAME_SIZE ; File iterator, 8 bytes for it 
    current_file resq FILE_NAME_SIZE; Lower bound for the current file in the files vector

    input_key resb 1

    pages resq BufferSize64 * 8; Pages for the files, 8 pages for 8 files
    current_page_offset resq BufferSize64 * 8; Current page, resq is 8 bytes

    current_page resq BufferSize64 * 8 ; Current page
    page_to_display resq BufferSize64 ; Page to display

    results_INT64 resq 20 * 8
    current_result_offset resq 20 * 8
    current_result resq 20 ;current result, count of numbers

    result_to_display resq 20 ; Result to display

section .text
    global _start ; Start of the program
    %include "macros.inc"  ; Include macros

    extern external_function  ; Include external function

_start:
    mov qword [current_page_offset], 0
    mov qword [current_page], 0

    mov qword [current_result_offset], 0

    pop rax     ; argc
    dec rax     ; Decrement argc, for determine the count of arguments

    cmp rax, 0
    je no_arguments ; If not provided arguments, then go to single program execution

    ; Else get the arguments
    pop rbx    ; argv[0] is first argument(file name), skip it

    ; CHECK ARGUMENTS 
    jmp check_next_argument

    jne eror_exit_not_provided_correct_argument; NOT PROVIDED CORRECT ARGUMENTS

separate_output:
    print_string screen_separator, len_screen_separator
    ret

read_file_name:;Calculate offset for storing new file name
    ; pop rdi; arg, file name 
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
    ret

write_char:
    mov rdx, [file_iterator] ; todo offset, and work on current file space  
    add rdx, r11       ; file address is files + (offset + r11) ;rdx now is offset in vector + current file offset
    mov al, [rdi + r11]  ; rdi is filname address
    mov byte [files + rdx], al ;al current symbol
    inc r11
    jmp write_file_name

isRArgument: 
    pop rdi ; arg, file name 
    cmp rdi, 1 ; Check if the argument exist
    jl eror_exit_not_provided_correct_argument

    jmp read_file_name

check_next_argument:
    pop rdi
    cmp rdi, 0
    je end_of_args ; Not arguments any more
            
    cmp byte [rdi], '-'
    jne isHArgument ;
    
    ; FIRST CHECK IF IT IS A DOCKUMENTATION FLAG
    cmp byte [rdi + 1], 'h'
    je isHArgument

    ; CHECK FILE NAMES, THEY HAVE FLAG "-f" and body "filename.txt"
    cmp byte [rdi + 1], 'f'
    je isRArgument

    ; Set the -r flag
    cmp byte [rdi + 1], 'r'
    je set_r_flag

    cmp byte [rdi + 1], 'p'
    je set_p_flag

    jne eror_exit_not_provided_correct_argument; NOT PROVIDED CORRECT ARGUMENTS

set_r_flag:
    mov byte [r_argument_is_presented], 1
    jmp check_next_argument

set_p_flag:
    mov byte [p_argument_is_presented], 1

    print_string p_argument, len_p_argument
    jmp check_next_argument

end_of_args:; MAIN BODI AFTER READING THE ARGUMENTS

    xor rbx, rbx; offset in the filenames vector

    mov byte [current_file], 0
    jmp iterate_files

    ; ; cmp byte [p_argument_is_presented], 1
    ; call wait_for_press_enter
wait_for_press_enter:
    read_key_from_keyboard input_key ; Read key from keyboard
    cmp byte [input_key], 0x0D   ; (enter)
    je wait_for_press_enter
    ret

iterate_files:
    cmp byte [count_of_files], 0 ;test if count of files for processing is 0
    jz success_read_files

    ; ; cmp byte [p_argument_is_presented], 1
    call wait_for_press_enter

    mov rbx, [current_file]
    add rbx, FILE_NAME_SIZE ; rbx is FILE OFFSET + 128 bytes for filename by iteration

    ; For separete the files output
    call separate_output

    ; COUNT OF FILES 
    print_string count_of_files_msg, len_count_of_files_msg
    convert_int_to_str buffer_int64, [count_of_files]
    print_string buffer_int64, 20

    ; Get the filename, and print it 
    retrive_substring files, filename, [current_file], rbx
    print_string filename_msg, len_print_filename_msg
    print_string filename, FILE_NAME_SIZE 

    ; Set current file 
    mov [current_file], rbx
    ; Update the count of files
    dec byte [count_of_files]

    ; MAIN LOGIC FOR PROCESSING THE FILE
    call process_file

    jmp iterate_files

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
    ; For separete the files output
    call separate_output
    ; All files readed message
    print_string all_files_readed_msg, len_all_files_readed_msg

    cmp byte [p_argument_is_presented], 1
    je pre_slide_pages

    normal_exit

eror_exit_not_provided_correct_argument:
    print_string not_provided_correct_arguments, len_not_provided_correct_arguments
    print_string see_documentation_help_msg, len_see_documentation_help_msg
    error_exit comp_error_msg, len_comp_error_msg

no_arguments:
    print_string not_provided_arguments, len_not_provided_arguments
    print_string see_documentation_help_msg, len_see_documentation_help_msg
    jmp comp_error

read_loop:
    read_string_from_the_file r15, buffer, BufferSize64
    
    cmp rax, 0
    jl comp_error ; Error during read
    je end_of_file    ; EOF reached

    ; Loop for counting numbers and writing them to the output vector
    call count_numbers_loop

    jmp read_loop

end_of_reading_to_buffer: ; End of reading one part of the file to buffer 
    print_string end_of_reading_buffer_msg, len_end_of_reading_buffer_msg
    ret


end_of_file: ;END OF READING FILE
    ; Check if -r argument is presented
    print_string end_of_file_msg, len_end_of_file_msg

    cmp byte [r_argument_is_presented], 1
    je process_reversed_output

    print_string single_output_msg, len_single_output_msg
     ; OUTPUT THE RESULT
    print_string output_vector, BufferSize64
    call print_count_of_numbers

    cmp byte [p_argument_is_presented], 1
    je process_paged_output

    ; CLEAR OLL BUFFERS TO EVOID THE ERRORS WITH OWERITING THE DATA
    call clean_buffers

    jmp iterate_files

process_reversed_output:
    ; Do outoput reverse
    print_string reversed_output_msg, len_reversed_output_msg

    ; Out the reversed output
    reverse_string output_vector, BufferSize64, buffer
    print_string buffer, BufferSize64 ; OUTPUT THE RESULT
    call print_count_of_numbers ; Out the number of the finded numbers
    
    cmp byte [p_argument_is_presented], 1
    je process_reversed_paged_output

    ; CLEAR OLL BUFFERS TO EVOID THE ERRORS WITH OWERITING THE DATA
    call clean_buffers

    jmp iterate_files

clean_buffers:
    clear_buffer output_vector, BufferSize64
    clear_buffer buffer, BufferSize64
    clear_buffer buffer_int64, 20
    ret

process_paged_output:
    ; output_vector had output data 
    copy_to output_vector, pages, BufferSize64, [current_page_offset]
    add qword [current_page_offset], BufferSize64

    copy_to buffer_int64, results_INT64, NUMBER_SIZE, [current_result_offset]
    add qword [current_result_offset], 20

    call clean_buffers
    jmp iterate_files

process_reversed_paged_output:
 
    copy_to buffer, pages, BufferSize64, [current_page_offset]
    add qword [current_page_offset], BufferSize64

    copy_to buffer_int64, results_INT64, NUMBER_SIZE, [current_result_offset]
    add qword [current_result_offset], 20

    call clean_buffers
    jmp iterate_files

pre_slide_pages:
    ; call clear_screen
    print_string p_argument, len_p_argument
    jmp slide_pages

slide_pages:
    call clean_buffers
    read_key_from_keyboard input_key ; Read key from keyboard
    
    cmp byte [input_key], 0x6A   ; j
    je next_page

    cmp byte [input_key], 0x6B   ; k
    je previous_page

    jmp slide_pages

next_page:
    ; eror handling
    cmp qword [current_page], BufferSize64*8 - BufferSize64
    je clean_and_return_to_slide_pages

    add qword [current_page], BufferSize64
    add qword [current_result], NUMBER_SIZE
    clear_screen
    call show_page

    jmp slide_pages

previous_page:
    ; eror handling
    cmp qword [current_page], 0
    je clean_and_return_to_slide_pages

    sub qword [current_page], BufferSize64
    sub qword [current_result], NUMBER_SIZE
    clear_screen
    call show_page

    jmp slide_pages

clean_and_return_to_slide_pages:
    clear_screen

    call separate_output

    convert_int_to_str buffer_int64, [current_page]
    print_string buffer_int64, 20

    call print_string_separator

    clear_buffer buffer_int64, 20
    call calculate_current_position_count

    call print_string_separator

    clear_buffer buffer_int64, 20
    call calculate_position_in_persent

    call print_string_separator

    call separate_output

    print_string reach_reange_msg, len_reach_reange_msg
    call separate_output

    jmp slide_pages

show_page:
    push r12
    xor r12, r12
    mov r12, [current_page]
    add r12, BufferSize64
    retrive_substring pages, page_to_display, [current_page], r12
    pop r12
    clear_screen

    call separate_output

    convert_int_to_str buffer_int64, [current_page]
    print_string buffer_int64, 20
    
    call print_string_separator

    clear_buffer buffer_int64, 20
    call calculate_current_position_count

    call print_string_separator

    clear_buffer buffer_int64, 20
    call calculate_position_in_persent

    call print_string_separator

    call separate_output

    push r12
    ; Retrive the count of numbers
    xor r12, r12
    mov r12, [current_result]
    add r12, NUMBER_SIZE
    call clear_buffer result_to_display, NUMBER_SIZE
    retrive_substring results_INT64, result_to_display, [current_result], r12
    pop r12
    ; Check if count of numbers is null
    call pre_check_number_is_presented

    ; Print the numbers
    print_string page_to_display, BufferSize64

    call separate_output

    ;Print the count of numbers
    print_string result_to_display, NUMBER_SIZE

    call separate_output

    ret

pre_check_number_is_presented:
    xor r13, r13
    xor r12, r12
    xor r10, r10
    jmp check_number_is_presented

check_number_is_presented:
    cmp r13, NUMBER_SIZE
    jge data_not_presented ;ret 

    mov r10b, byte [result_to_display + r13]

    cmp r10b, '0'
    je number_is_presented

    cmp r10b, '1'
    je number_is_presented

    cmp r10b, '2'
    je number_is_presented

    cmp r10b, '3'
    je number_is_presented

    cmp r10b, '4'
    je number_is_presented

    cmp r10b, '5'
    je number_is_presented

    cmp r10b, '6'
    je number_is_presented

    cmp r10b, '7'
    je number_is_presented

    cmp r10b, '8'
    je number_is_presented

    cmp r10b, '9'
    je number_is_presented

    inc r13

    jmp check_number_is_presented

number_is_presented:
    ret
data_not_presented:
    print_string data_not_presented_msg, len_data_not_presented_msg
    call separate_output
    jmp slide_pages

calculate_current_position_count:
    mov rax, [current_page_offset] ; dividend
    xor rdx, rdx ;
    mov rcx, BufferSize64 ; divisor
    div rcx  ; rax = rax / rcx, rdx = rax % rcx
    mov r12, rax ;result

    mov rax, [current_page]
    xor rdx, rdx
    mov rcx, BufferSize64
    div rcx
    mov r13, rax

    convert_int_to_str buffer_int64, r13
    print_string buffer_int64, 20
    clear_buffer buffer_int64, 20

    print_string slesh_separator, 1

    convert_int_to_str buffer_int64, r12
    print_string buffer_int64, 20
    ret

calculate_position_in_persent:
    ; (current_page * 100) / current_page_offset
    mov rax, [current_page]
    mov rbx, 100
    mul rbx ; rax = current_page * 100

    mov rcx, [current_page_offset]
    cmp rcx, 0 ; devision by zerp
    je devision_by_zero 

    xor rdx, rdx
    div rcx ; result 
    
    convert_int_to_str buffer_int64, rax ;Out the result in persent
    print_string buffer_int64, 20
    print_string persent_separator, len_persent_separator
    ret

print_string_separator:
    print_string string_separator, len_string_separator
    ret

devision_by_zero: 
    mov rbx, 0
    convert_int_to_str buffer_int64, rbx
    print_string buffer_int64, 20
    print_string persent_separator, len_persent_separator
    ret

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
    jge end_of_reading_to_buffer ;ret 

    mov r10b, byte [buffer + r13]

    cmp r10b, '-'
    je found_minus

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
    ; Dont need Write number, found_number will do it and continue the checking number

    jmp found_number

up_minus_and_digit:
    mov byte [output_vector + r12], 0x2D ; minus has kod 96
    inc r12 ; Increment the ouput vector iterator

    jmp found_number

comp_error:
    error_exit comp_error_msg, len_comp_error_msg

isHArgument:
    ; Provided Instructions
    clear_screen
    print_string help_msg0, len_help_msg0
    call separate_output
    print_string help_msg1, len_help_msg1
    print_string help_msg2, len_help_msg2
    print_string help_msg3, len_help_msg3

    normal_exit ; exit the program

print_count_of_numbers:
    ; Convert the count of numbers to the string, and out it out 
    print_string count_of_numbers_msg, len_count_of_numbers_msg
    
    convert_int_to_str buffer_int64, r14
    print_string buffer_int64, 20
    ret