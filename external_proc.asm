

section .text
    global external_function    

section .data
    hello_msg db 'Hello, world!', 0xa
    hello_len equ $ - hello_msg


; TODO
external_function:
    push rbp           ; Save old base pointer
    mov rbp, rsp      ; Set up new stack frame
    

    ; Print message
    mov rax, 1 ; syscall: sys_write
    mov rdi, 1
    mov rsi, hello_msg ; message
    mov rdx, hello_len ; length
    syscall ; call kernel

    mov rsp, rbp      ; Restore stack pointer
    pop rbp           ; Restore base pointer

    ret ; return from function
