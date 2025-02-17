section .data
    filename db "text.txt", 0
    fd     dd 0
    prompt db "Введите данные: ", 0
    prompt_len equ $ - prompt
    error_msg db "Ошибка: файл не найден или недоступен!", 0xA
    error_len equ $ - error_msg

section .bss
    buffer resb 100     ; Reserve 100 bytes of uninitialized memory
    
section .text
    global _start

_start:
    ; Получаем аргументы командной строки
    pop eax             ; argc (количество аргументов)
    pop ebx             ; argv[0] (имя программы)
    pop ebx             ; argv[1] (первый аргумент)

    ; Проверяем, есть ли аргумент '-k'
    cmp byte [ebx], '-' ; Проверяем, начинается ли аргумент с '-'
    jne .open_file      ; Если нет, переходим к открытию файла
    cmp byte [ebx + 1], 'k' ; Проверяем, это '-k'?
    jne .open_file      ; Если нет, переходим к открытию файла

    ; Если аргумент '-k', читаем данные с клавиатуры
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, prompt     ; сообщение "Введите данные: "
    mov edx, prompt_len ; длина сообщения
    int 0x80            ; вызов ядра

    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin (клавиатура)
    mov ecx, buffer     ; буфер для чтения
    mov edx, 100        ; количество байт для чтения
    int 0x80            ; вызов ядра
    jmp .print_data     ; Переходим к выводу данных

.open_file:
    ; Открываем файл
    mov eax, 5          ; sys_open
    mov ebx, filename    ; имя файла
    mov ecx, 0          ; флаги (O_RDONLY)
    int 0x80            ; вызов ядра
    cmp eax, 0          ; проверяем результат
    jl .error           ; если ошибка, переходим к метке .error
    mov [fd], eax       ; сохраняем дескриптор файла

    ; Читаем данные из файла
    mov eax, 3          ; sys_read (номер 3)
    mov ebx, [fd]       ; файловый дескриптор
    mov ecx, buffer     ; буфер для чтения
    mov edx, 100        ; количество байт для чтения
    int 0x80            ; вызов ядра
    cmp eax, 0          ; проверяем результат
    jl .error           ; если ошибка, переходим к метке .error
    mov edx, eax        ; сохраняем количество прочитанных байт

.print_data:
    ; Выводим прочитанные данные
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, buffer     ; буфер с данными
    ; edx уже содержит количество прочитанных байт
    int 0x80            ; вызов ядра

    ; Закрываем файл (если он был открыт)
    cmp dword [fd], 0
    je .exit            ; Если файл не открывался, пропускаем закрытие
    mov eax, 6          ; sys_close
    mov ebx, [fd]       ; файловый дескриптор
    int 0x80            ; вызов ядра

.exit:
    ; Завершаем программу
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; код возврата 0
    int 0x80            ; вызов ядра

.error:
    ; Выводим сообщение об ошибке
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, error_msg  ; сообщение об ошибке
    mov edx, error_len  ; длина сообщения
    int 0x80            ; вызов ядра

    ; Завершаем программу с кодом ошибки
    mov eax, 1          ; sys_exit
    mov ebx, 1          ; код возврата 1
    int 0x80            ; вызов ядра