; Prevent redifinition of macros
%ifndef MACROS_INC
%define MACROS_INC

%macro print_string 2
    mov rax, 1      ; sys_write
    mov rdi, 1      ; 0 - stdin 1- stdout, 2- stderr
    mov rsi, %1     ; string address
    mov rdx, %2     ; string length
    syscall
%endmacro

%macro exit 1
    mov rax, 60     ; sys_exit
    mov rdi, %1     ; exit code
    syscall
%endmacro


%endif
