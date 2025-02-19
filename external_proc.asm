section .data
    hello_msg db 'External, world!', 0xa
    hello_len equ $ - hello_msg

section .text
    global external_function    

external_function:
    push rbp ; Save the base pointer(BP)
    mov rbp, rsp ; Set BP to the current stack pointer

    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, hello_msg    ; pointer to string
    mov rdx, hello_len    ; length
    syscall

    mov rsp, rbp ; Restore the stack pointer
    pop rbp ; Restore BP

    ret