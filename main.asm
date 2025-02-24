; Zadanie č. [7] 
; Autor - Andrii Dokaniev
; Text konkrétneho riešeného zadania:
    ; 7. Vypísať zo vstupu všetky čísla (aj viacciferné) a ich počet. 
    ; Vypracovane bonusové úlohy(2 cast a bonusy):
        ; 1. Correct handling files above 64kb
        ; 2. Support for reading files from arguments, and support by default 8 files
        ; 3. Support for reverse output (-r)
        ; 4. Support for paging output, input files (-p)
        ; 5. Documentation in english
        ; 6. External function for function of the program
        ; 7. Using function for string instructions (MOVS, CMPS, STOS, ...) in macros
        ; 8. Sliding pages using "j" and "k" buttons

; Termín odovzdávania: 3/23/2025
; 2 Ročník, 2024/2025, letný semester, FIIT

; Program with discription: 
; For help use -h argument

section .text
    global _start ; Start of the program
    %include "macros.inc"  ; Include macros

    extern numcnt ; Include external function

_start:; Save arguments, befor runing the main program
    pop rdi; argc
    mov rsi, rsp; argv, copy pointer to the arguments

    call numcnt

; Zhodnotenie: 
; Program je funkčný, bol vypracovany v prostredi Linux(Ubuntu 24.04.1 LTS wsl)
; V programe osetrene chybove stavy, teda zlyganij pri spravnom pouziti nebolo najdene
; S prostried moznych vylepseni patri pridanie dinamickej alokacie pamate pri nacitanie suborov, 
; zmensenie vyuzitia .bss segmentu(t.j. pamat v bss segmente je alokovana staticky, co moze sposobit problemy s pamatou)
; vecse pouzivat stack a ine codove zlepsovia
; V programe pol pouzite lagoritmy na zistenie ci je v subore cislo, ak ano, tak dat ho do vystopu a vypisat pocet cisel v subore
; Poli pouzite makra na pracu s subormi, nacitani dat, pracu s retazcami, ako napriklad rozne sposoby copirovania retazcov, podretazcov.
; Taktiez bloli pouzite makra pre rozne vypisy, zmazanie obrazovky, konvertacia cisla na retazec a ukoncenia programu.
; Zdroje boli ukazane priamo v kode 
; Kratky popis programu:
; Na zacatku progamu som pridal logiku na scitanie argumentov(-h, -k, -p, -r) a spracovanie ich(zapis men suborov pre dalsie spracovenie)
; Dalej bola kontorla ci vsetky argumenty boli precitane a ci je zadane spravne subory, ak ano idem na spracovanie suborov, precitame meno prveho suboru, 
; a idem postpene po subru a pozerame sa na cisla v subore, ak nasli cifru, tak ju zapisem do vystupneho vektoru a pozerame sa na nasledujuci znak.
; Tiez sprocavame duble cisla(cisla s '.') a minusove cisla.
; Po spracovani subora, zapisem vystup suboru v prislusnu stranku a tak pokracujeme nad vykonanim spracovania kazdeho suboru.
; Po cas spracovanie jednotnych suborov treba natlacit na klavesu "Enter" pre prechod do sledujuceho suboru, pocas kazdeho prehodu, program vypise informacie o actualnem subore.
; Po spracovanie vsetkych suborov v programe bude mozne pozerat rozne vypise s roznych suborov pouzitim klaves "j" a " k", pre ukoncenie programu pouzite kombinaciu klaves "Ctrl + C".
; v bloky .bss sekcie som uchoval pamet pre rozne subory a stranky.
; Taktiez k programu bol prilinkovany subor, ktory obsahuje externe funkcie a hlavnu logiku vytvorenoho programu.
; Pre spustenie programu: 

; nasm -f elf64 lib.asm -o lib.o
; nasm -f elf64 -g -o main.o main.asm
; ld main.o lib.o -o main
; ./main 

; Example: 
; ./main -f input.txt -f input2.txt -{r, p, h}
; Parametre mozu byt zadane v lubovolnom poradi