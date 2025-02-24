; Prevent redifinition of macros
%ifndef MACROS_INC
%define MACROS_INC

%macro print_string 2
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 1      ; sys_write(1)
    mov rdi, 1      ; 0 - stdin 1- stdout, 2- stderr
    mov rsi, %1     ; string address
    mov rdx, %2     ; string length
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

%macro exit 1 ; stopping the program
    mov rax, 60     ; system call (sys_exit(60))
    mov rdi, %1     ; exit code
    syscall
%endmacro

%macro normal_exit 0
    exit 0
%endmacro

%macro error_exit 2
    print_string %1, %2
    exit 1
%endmacro

%macro clear_screen 0
    print_string clear, len_clear
%endmacro

%endif