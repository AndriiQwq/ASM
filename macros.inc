; Prevent redifinition of macros
%ifndef MACROS_INC
%define MACROS_INC

; Using commands like "push" and "pop" for storing their context on the stack, and up it from the stack
; Store and return registers, to avoid overwriting the registers and colisions
; Using movzx for move value to register and fill the rest of the register with zeros

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
    mov rsi, %1    ;string add 
    mov rcx, %2    ;length
    mov rdi, %3    ;dest add
    mov rdx, 0   ; counter

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
    print_string succsfull_exit, len_succsfull_exit
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

%macro read_key_from_keyboard 1 ; read(0)
    mov rax, 0  ; sys_read
    mov rdi, 0  ; file descriptor
    mov rsi, %1 ; output buffer
    mov rdx, 1 ; buffer size in bytes
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

%macro clear_buffer 2
    ; Parameters:
    ; %1: Buffer
    ; %2: Size to clear

    ; Use stosb for write from al register to rdi(64b) or edi(32b) or di(16b)
    ; It work only with this registers, rdi contain
    ; Provide math operation on rdi register, as inc or dec
    ; Using DF (Direction Flag)
    ; CLD (Clear Direction Flag) - rdi will be incremented
    ; STD (Set Direction Flag) - rdi will be decremented
    ; Rep with stosb using for repeat this operation
    ; Rep using rcx register and decrement if

    ; Stosw, Stosd, Stosq - for 2, 4, 8 bytes
    ; Stosb - for 1 byte

    push rdi
    push rcx

    mov rdi, %1
    mov rcx, %2
    xor al, al
    cld ; for increment rdi
    rep stosb ; Work only with rdi register

    pop rcx
    pop rdi
%endmacro

%macro copy_to 4 ; Copy x bytes from first buffer to second buffer with offset
    ; Parameters:
    ; %1: Input buffer
    ; %2: Output buffer
    ; %3: Number of bytes to copy
    ; %4: Offset in destination buffer
    
    push r8
    push r9
    push rdi
    push rsi
    push rcx
    push rdx

    mov rsi, %1
    mov rdi, %2
    mov rcx, %3
    mov rdx, %4
    xor r9, r9 ; Iterator for source buffer
    xor r8, r8 ; Iterator for output buffer

    %%copy_loop:
        cmp r9, rcx ; Check if copied all needed symbols
        jge %%break_loop

        mov al, [rsi + r9]; Load byte

        add r8, rdx ; Add offset
        mov [rdi + r8], al ; Store byte
        sub r8, rdx ; Subtract offset 

        ; Increment iterators
        inc r8
        inc r9
        jmp %%copy_loop

    %%break_loop:
    pop rdx
    pop rcx
    pop rsi
    pop rdi
    pop r9
    pop r8
%endmacro




%endif