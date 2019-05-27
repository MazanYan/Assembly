%include "io.inc"

;extern fopen
;extern fprintf


%macro PRINT_LONG 2                 ; length, dword long_number
    mov ebp, %1
    mov ecx, 0
    %%print:
        dec ebp
        PRINT_HEX 4, [%2 + ecx*4]
        PRINT_STRING " "
        inc ecx
        cmp ebp, 0
        jnz %%print
        
%endmacro


%macro CREATE_FILE 2      ; full file address, permissions
    mov  eax, 8
    mov  ebx, %1
    mov  ecx, %2          ; move permissions
    int  0x80             ; call kernel
%endmacro
    

section .bss
    array : resd 4
    res_array: resd 4
    
section .data
    file_name db "/home/yan/Desktop/4 семестр/Assembly/lab 9/teste.txt", 0
    ;permission db "w"
    ;content db "Renji Abarai is the best character of all times and nations!"
    ;file_buffer dq 0
    factorial_to_count dd 3
section .text
global CMAIN
CMAIN:
    ;write your code here
    xor eax, eax
    
    CREATE_FILE file_name, 0777
    
    ;mov  eax, 8
    ;mov  ebx, file_name
    ;mov  ecx, 0777        ;read, write and execute by all
    ;int  0x80             ;call kernel
    
    ;push permission
    ;push file_name
    ;call fopen
    ;add esp, 8
    
    ;push 1
    ;push content
    ;push file_buffer
    ;call fprintf
    ;add esp, 12
    
    push 4
    push factorial_to_count
    push array
    call Factorial
    
    PRINT_LONG 4, array
    
    ret

MulN_x_32:                                  ; size, A, B 32 bit, res
    push ebp
    mov ebp, esp
    
    mov esi, dword [ebp + 20]               ; size
    mov edi, dword [ebp + 16]               ; A
    mov ebx, dword [ebp + 12]               ; B 32 bit
    mov ecx, dword [ebp + 8]                ; res
    dec esi
    
    @mulN_x_32:
        mov eax, dword [edi + 4*esi]
        mul dword [ebx]
        add dword [ecx + 4*esi + 4], eax
        add dword [ecx + 4*esi], edx
        
        dec esi
        cmp esi, 0
        jge @mulN_x_32
    leave
    ret 16

Factorial:                                  ; size, number which factorial we must count, res
    push ebp
    mov ebp, esp
    
    mov esi, dword [ebp + 16]               ; size
    mov ebx, dword [ebp + 12]               ; factorial of number to count
    mov ecx, dword [ebp + 8]                ; res
    
    mov ebx, dword [ebx]
    dec esi                                 ; esi points at the end of array
    
    ;mov eax, esi                            ; create local buffer for temporary result
    ;mov edx, 4
    ;mul edx
    ;sub esp, eax                            ; sub esp, esi*4
    
    mov dword [ecx + 4*esi], 1              ; move initial number on the last position into ecx
    ;mov ebx, 1                              ; multiply on ebx on eact step
    
    mov edx, 0
    @mulCycle:
        mov eax, dword [ecx + 4*esi]
        mul ebx
        add dword [ecx + 4*esi], eax
        adc dword [ecx + 4*esi - 4], edx
        pushf
        mov edi, esi
        @addCarryFlag:
            popf
            adc dword [ecx + 4*edi - 4], 0
            pushf
            dec edi
            cmp edi, 0
            jge @addCarryFlag
        ;mov edx, dword [esp + 8]
        ;mov dword [ecx + 8], edx
    leave
    ret 12