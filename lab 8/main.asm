%include "io.inc"
%include "functions.asm"

section .bss
    res : resd 1
    text_res : resb 10
    text_res2 : resb 20
section .data
    a dd 0.0, 2.0, 1.0, 1.0, 2.1
    x dd 2.0
    
    test_convert dd -12.24
    
global CMAIN
CMAIN:
    ;write your code here
    xor eax, eax
    
    push 5
    push a
    push x
    push res
    call myFunction         ; result = 49.6
    
    
    PRINT_STRING "Результат обчислення функції у стандарті IEE-754: "
    PRINT_HEX 4, res
    NEWLINE
    
    push res
    push text_res
    call floatToDec
    
    NEWLINE
    PRINT_STRING "Результат обчислення функції у десятковому форматі: "
    PRINT_STRING text_res
    NEWLINE
    
    push test_convert
    push text_res2
    call floatToDec
    
    NEWLINE
    PRINT_STRING "Тестове конвертування числа test_convert: "
    PRINT_STRING text_res2
    
    ret



