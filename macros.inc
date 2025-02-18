; Prevent redifinition of macros
%ifndef MACROS_INC
%define MACROS_INC

%macro print_string 2
    mov rax, 1      ; sys_write(1)
    mov rdi, 1      ; 0 - stdin 1- stdout, 2- stderr
    mov rsi, %1     ; string address
    mov rdx, %2     ; string length
    syscall
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

; ######### OPERATIONS UNDER THE FILE #########

;  File flags https://linux.die.net/man/3/open
; O_RDONLY: Open for reading only.
; O_WRONLY: Open for writing only.
; O_RDWR: Open for reading and writing.
; O_CREAT: Create if it does not exist.


%macro open_file 3 ; open(2)
    mov rax, 2   ; sys_open
    mov rdi, %1  ; file name, example: "file.txt"
    mov rsi, %2  ; flags for access, example: O_RDONLY
    mov rdx, %3  ; chmode: example: 0644
    syscall
%endmacro

%macro read_string_from_the_file 3 ; read(0)
    mov rax, 0  ; sys_read
    mov rdi, %1 ; file descriptor
    mov rsi, %2 ; buffer address
    mov rdx, %3 ; buffer size
    syscall
%endmacro

%macro close_file 1; close(3)
    mov rax, 3
    mov rdi, %1
    syscall
%endmacro





%endif
