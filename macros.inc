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

%macro reverse_string 3
    mov rsi, %1;string add 
    mov rcx, %2;length
    mov rdi, %3;dest add
    mov rdx, 0 ; counter

    reverse:
        mov al, [rsi + rcx - 1] ; Copy the least sign to al register
        mov [rdi + rdx], al ; Copy the last sign in al to the dest regoster 
        inc rdx 
        loop reverse
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

%macro clear_screen 0
    section .data
        clear db 27,'[2J',27,'[H'
        len_clear equ $ - clear
    section .text
        print_string clear, len_clear
%endmacro

%macro print_number 0
    

%endmacro


%endif
