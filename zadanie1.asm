; ; Zadanie č. [123] 
; ; Autor - Andrii Dokaniev
; ; Text konkrétneho riešeného zadania ...   
;     ;uvedú sa aj riešené bonusové úlohy:
;     ; Bonusové úlohy:
;         ;

; ; Termín odovzdávania 


; ; Ročník, ak. rok, semester, odbor 

; ; 2 Ročník, 2024/2025, letný semester, FIIT 



; ; sem umiestnite okomentovaný program: 

; ; https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

; ; 32b arch. %eax use for system calls, some calls need to use arguments, folowing registers provide place for arguments:
;     ; arg0 (%ebx)	
;     ; arg1 (%ecx)	       
;     ; arg2 (%edx)
;     ; arg3 (%esi)	
;     ; arg4 (%edi)	
;     ; arg5 (%ebp)

; global _start

; section .data
    
;     msg db 'Hello, world!', 0xa ;Text (0xa is 10('/n'))
;     len equ $ -msg ;Length of the text
    
;     h_argument db 'Was provided -h', 0xa ; -l argument
;     k_argument db 'Was provided -k', 0xa ; -h argument

;     len_h_argument equ $ - h_argument ; Length of the -l argument
;     len_k_argument equ $ - k_argument ; Length of the -h argument


; section .bss        ; segment of non-initialized data,
;     num resb 5      ; Allocating 5 bytes for the num variable

; section .text
; _start:
;     pop eax            ; argc
;     pop ebx            ; argv[0] is first argument(file name)
;     pop edi            ; argv[1] is second argument(for example: -h)
;     pop esi            ; argv[2] is third argument(for example: -k)


;     ; Потом нужно будет добаить проверку если аргументов предоставляется 2 сразу, без учета названия файла

;     ; Check first argument
;     cmp byte [edi], '-'
;     jne .exit
;     cmp byte [edi + 1], 'h'
;     je .isHArgument
;     cmp byte [edi + 1], 'k'
;     je .isKArgument

;     ; Check second argument
;     cmp byte [esi], '-'
;     jne .exit
;     cmp byte [esi + 1], 'h'
;     je .isHArgument
;     cmp byte [esi + 1], 'k'
;     je .isKArgument
    
;     jmp .exit


; .isHArgument:
;     ; Print message
;     mov eax, 4      ; system call (sys_write)
;     mov ebx, 1      ; stdout
;     mov ecx, h_argument    ; message to write
;     mov edx, len_h_argument ; message length
;     int 0x80        ; call kernel
;     jmp .exit       ; exit the program

; .isKArgument:
;     ; Print message
;     mov eax, 4      ; system call (sys_write)
;     mov ebx, 1      ; stdout
;     mov ecx, h_argument    ; message to write
;     mov edx, len_h_argument ; message length
;     int 0x80        ; call kernel
;     jmp .exit       ; exit the program

; .exit:
;     ; Corrected stoping the program
;     mov eax, 1      ; system call (sys_exit)
;     xor ebx, ebx    ; Code of return status (0) added to ebx register, 
;                     ; ebx register is used to store the return status code, 
;                     ; is one of 6 registers that are used to pass arguments to the kernel

;     int 0x80        ; call kernel



; ; Zhodnotenie: 