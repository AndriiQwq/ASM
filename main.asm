; Zadanie č. [7] 
; Autor - Andrii Dokaniev
; Text konkrétneho riešeného zadania:
    ; 7. Vypísať zo vstupu všetky čísla (aj viacciferné) a ich počet. 
    ; Vypracovane bonusové úlohy:
        ; 1. Correct handling files above 64kb
        ; 2. Support for reading files from arguments, and support by default 8 files
        ; 3. Support for reverse output (-r)
        ; 4. Support for paging output (-p)
        ; 5. Quality of the documentation
        ; 6. External function for function of the program
        ; 7. Using function for string instructions (MOVS, CMPS, STOS, ...)
        ; 8. Suport paging for input files (-p)
        ; 9. Sliding pages using "j" and "k" buttons

; Termín odovzdávania: 3/23/2025
; 2 Ročník, 2024/2025, letný semester, FIIT

; Program with discription: 
; For help use -h argument


section .text
    global _start ; Start of the program
    %include "macros.inc"  ; Include macros

    extern numcnt ; Include external function

_start:
    ; Save arguments
    pop rdi; argc
    mov rsi, rsp; argv, copy pointer to the arguments

    call numcnt