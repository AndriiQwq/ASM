section .data
    hello_msg db 'External, world!', 0xa
    hello_len equ $ - hello_msg

section .text
    global external_function    
    %include "macros.inc"  ; Include macros

external_function:
    push rbp ; Save the base pointer(BP)
    mov rbp, rsp ; Set BP to the current stack pointer

    print_string hello_msg, hello_len

    mov rsp, rbp ; Restore the stack pointer
    pop rbp ; Restore BP

    ret