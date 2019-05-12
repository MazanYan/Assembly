section .bss
    partial_division : resb 1000
    convert_residue : resb 1
    ;number_size : resb 1
    less_than_ten : resd 1
    
section .text
global Div10

Div10:                              ; division by bits groups
    push ebp
    mov ebp, esp
    
    mov edx, dword [ebp + 20]       ; size
    mov ebx, dword [ebp + 16]       ; divided number
    mov edi, dword [ebp + 12]       ; partial result
    mov ecx, dword [ebp + 8]        ; residue
    
    push ebx                        ; ebx (bl) serves as divisor
    
    mov esi, 0
    and ax, 0xff
    @division10Cycle:
        pop ebx
        mov al, byte [ebx + esi]
        push ebx
        mov bl, 10
        div bl
        ;mov cl, ah
        mov byte [edi + esi], al
        
        inc esi
        cmp esi, edx
        jne @division10Cycle
    pop ebx
    mov dl, ah
    ;pop ecx
    ;mov byte [residue_buffer], dl
    ;mov ecx, dword [ebp + 8]
    mov byte [ecx], dl
    leave 
    ret 16

StrDec:
    push ebp
    mov ebp, esp
    ;sub esp, 16
    
    
    mov eax, dword [ebp + 16]           ; number
    mov edi, dword [ebp + 12]           ; text buffer
    mov ecx, dword [ebp + 8]            ; number size
    
    mov esi, 0
    push esi
    @convertCycle:
        ;push edi
        ;push ecx
        
        ;mov ecx, dword [ebp + 8]
        push ecx
        push dword [ebp + 16]
        push partial_division
        push convert_residue
        call Div10
        
        
        ;pop ecx
        ;pop edi
        ;mov ecx, dword [ebp + 8]
        mov edi, dword [ebp + 12]
        mov dl, byte [convert_residue]
        add dl, 48
        
        pop esi
        mov byte [edi + esi], dl
        inc esi
        push esi
        
        mov dword [less_than_ten], 1                          ; dword [less_than_ten] == 1 => partial_division < 10
        mov esi, dword [ebp + 8]
        dec esi
        cmp byte [partial_division + esi], 10
        jge @greaterThanTen
        
        @swapCycle1:
        mov dl, byte [partial_division + esi]
        mov ebx, dword [ebp + 16]
        mov byte [ebx + esi], dl
        dec esi
        ;jmp @end
        @swapCycle:
            mov dl, byte [partial_division + esi]
            mov ebx, dword [ebp + 16]
            mov byte [ebx + esi], dl
            
            cmp dl, 0
            jz @zeroByte
            mov dword [less_than_ten], 0
            @zeroByte:
                dec esi
                cmp esi, 0
                jge @swapCycle
                
        ;push ebp
        ;push ecx     
        ;PRINT_BYTES_HEX 3, partial_division
        ;pop ecx
        ;pop ebp
        ;NEWLINE
        
        mov edi, dword [ebp + 12]           ; text buffer
        mov ecx, dword [ebp + 8]            ; number size

        cmp dword [less_than_ten], 0
        jz @convertCycle
        jmp @end
        @greaterThanTen:
            mov dword [less_than_ten], 0
            jmp @swapCycle1
        
    @end:
        mov esi, dword [ebp + 8]
        dec esi
        mov al, byte [partial_division + esi]

        pop esi
        add al, 48
        mov byte [edi + esi], al
        
        leave
        ret 12

