; Prevent redifinition of macros
%ifndef MACROS_INC
%define MACROS_INC

; Using commands like "push" and "pop" for storing their context on the stack, and up it from the stack
; Store and return registers, to avoid overwriting the registers and colisions

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

%macro reverse_string 3
    mov rsi, %1;string add 
    mov rcx, %2;length
    mov rdi, %3;dest add
    mov rdx, 0 ; counter

    %%reverse:
        mov al, [rsi + rcx - 1] ; Copy the least sign to al register
        mov [rdi + rdx], al ; Copy the last sign in al to the dest regoster 
        inc rdx 
        loop %%reverse
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

%macro set_file_offset 2 ;Set offset in the file 
    push rax
    push rdi
    push rsi
    push rdx

    mov rax, 8; sys_lseek
    mov rdi, %1 ; file descriptor
    mov rsi, qword [%2] ; offset
    xor rdx, rdx; SEEK_SET = 0
    syscall

    pop rdx
    pop rsi
    pop rdi
    pop rax
%endmacro

%macro close_file 1; close(3)
    mov rax, 3
    mov rdi, %1
    syscall
%endmacro

%macro clear_screen 0
    print_string clear, len_clear
%endmacro

%macro retrive_substring 4
    ; Parameters
    push r8 ; iterator 
    push rdi ; Output buffer it
    push rsi ; Input buffer it
    push rcx ; From
    push rdx ; To

    xor r8, r8  ; iterator for output buffer
    mov rsi, %1 ; Input buffer it
    mov rdi, %2 ; Output buffer it
    mov rcx, %3 ; From
    mov rdx, %4 ; To

    %%copy_loop:
        cmp rcx, rdx ;If copy all nedeed symbols, then break
        jge %%break_loop 



        mov al, [rsi + rcx]

        ; cmp al, 0
        ; je %%break_loop
        ; cmp al, 10
        ; je %%break_loop
        ; cmp al, ' '
        ; je %%break_loop

        mov [rdi + r8], al
        inc rcx
        inc r8
        jmp %%copy_loop

    %%break_loop:
    pop rdx
    pop rcx
    pop rsi
    pop rdi
    pop r8
  
%endmacro

; 
%macro convert_int_to_str 2
    ; Parametrs: buffer for output, number
    push rax
    push rcx
    push rdx
    push rsi
    push rdi

    mov rdi, %2
    lea rsi, [%1+19]
    mov byte [rsi], 0

    %%convert_loop:
        xor rdx, rdx
        mov rax, rdi
        mov rcx, 10
        div rcx
        add dl, '0'
        dec rsi
        mov [rsi], dl
        mov rdi, rax
        test rax, rax
        jnz %%convert_loop

    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rax
%endmacro

%macro clear_buffer 2 ; Buffer and his maximal size
    push r12
    xor r12, r12

    %%clear_buffer: 
    cmp r12, %2
    jge %%end_of_clear_buffer
    mov byte [%1 + r12], 0
    inc r12
    jmp %%clear_buffer

    %%end_of_clear_buffer:
    pop r12
%endmacro


%endif
