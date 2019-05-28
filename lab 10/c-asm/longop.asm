section .bss
    i : resd 1
    j : resd 1
    partial_division : resb 1000
    convert_residue : resb 1
    less_than_ten : resd 1

section .text
global mulN_x_N
global addLongop
global subLongop
global strDec

addLongop:
    push ebp
    mov ebp, esp

    ;push esi
    ;push edx
    push ebx
    ;push ecx

    mov esi, dword [ebp+20]             ; length
    mov edx, dword [ebp+16]             ; A
    mov ebx, dword [ebp+12]             ; B
    mov ecx, dword [ebp+8]              ; C
    
    clc
    pushf
    dec esi
    @addCycle:
        popf
        mov eax, dword [edx + esi*4]
        adc eax, dword [ebx + esi*4]
        pushf
        mov dword [ecx+esi*4+4], eax
        dec esi
        cmp esi, 0
        jge @addCycle
        xor eax, eax
        popf                            ; забираємо наш прапор переносу зі стеку для того, щоби при наступному додаванні його використати
        adc eax, 0                      ; запис прапору переносу в eax
        mov dword [ecx], eax
    
    ;pop ecx
    pop ebx
    ;pop edx
    ;pop esi

    leave
    ret					; add esp, 16

subLongop:
    push ebp
    mov ebp, esp

    ;push esi
    ;push edx
    push ebx
    ;push ecx
    ;push eax

    mov esi, dword [ebp+20]             ; length
    mov edx, dword [ebp+16]             ; A
    mov ebx, dword [ebp+12]             ; B
    mov ecx, dword [ebp+8]              ; C

    clc
    pushf
    dec esi
    @subCycle:
        popf
        mov eax, dword [edx + esi*4]
        sbb eax, dword [ebx + esi*4]
        pushf
        mov dword [ecx+esi*4], eax
        dec esi
        cmp esi, 0
        jge @subCycle
        popf
    
    ;pop eax
    ;pop ecx
    pop ebx
    ;pop edx
    ;pop esi

    leave
    ret					; add esp, 16

mulN_x_N:                                   ; size, A, B, res
    push ebp
    mov ebp, esp
    
    ;push esi
    push ebx
    ;push edi
    ;push ecx
    ;push eax

    mov esi, dword [ebp + 20]               ; size
    dec esi                                 ; Making pointer to point on start of
    push esi                                ; save pointer on the last element
    mov dword [i], esi                      ; i - iterates over A's dwords
    mov dword [j], esi                      ; j - iterates over B's dwords
                                            ; base pointer: edi = i + j
    mov esi, dword [ebp + 16]               ; A
    mov ebx, dword [ebp + 12]               ; B
    mov edi, dword [ebp + 8]                ; result
    
    @outerCycle:
        pop dword [j]
        push dword [j]
        @innerCycle:
            mov ecx, dword [i]
            mov eax, dword [esi + 4*ecx]    ; eax = dword [A + i]
            mov ecx, dword [j]
            mul dword [ebx + 4*ecx]         ; eax *= dword [B + j]
            add ecx, dword [i]
            add dword [edi + 4*ecx + 4], eax; res = dword [edi + i + j + 4], eax
            adc dword [edi + 4*ecx], edx    ; res = dword [edi + i + j], edx
            push ecx
            pushf
            @addcarryflag:                  ; spread carry flag over all other digit numbers
                popf
                adc dword [edi + 4*ecx - 4], 0
                pushf
                dec ecx
                cmp ecx, 0
                jge @addcarryflag
            popf
            pop ecx
            mov eax, dword [j]
            dec eax
            mov dword [j], eax
            cmp eax, 0
            jge @innerCycle
        mov eax, dword [i]
        dec eax
        mov dword [i], eax
        cmp eax, 0
        jge @outerCycle

    pop esi
    ;pop eax
    ;pop ecx
    ;pop edi
    pop ebx
    ;pop esi

    leave
    ret					; add esp, 16

div10:                              ; division by bits groups
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
        mov byte [edi + esi], al
        
        inc esi
        cmp esi, edx
        jne @division10Cycle
    pop ebx
    mov dl, ah
    mov byte [ecx], dl
    leave 
    ret					; add esp, 16

strDec:
    push ebp
    mov ebp, esp
    
    push ebx
    push eax

    mov eax, dword [ebp + 16]           ; number
    mov edi, dword [ebp + 12]           ; text buffer
    mov ecx, dword [ebp + 8]            ; number size
    
    mov esi, 0
    push esi
    @convertCycle:
	;push ecx
        ;push dword [ebp + 16]
        ;push partial_division
        ;push convert_residue
        ;call div10
        ;add esp, 16
        
        mov edi, dword [ebp + 12]
        mov dl, byte [convert_residue]
        add dl, 48
        
        pop esi
        mov byte [edi + esi], dl
        inc esi
        push esi
        
        mov dword [less_than_ten], 1	   ; dword [less_than_ten] == 1 => partial_division < 10
        mov esi, dword [ebp + 8]
        dec esi
        cmp byte [partial_division + esi], 10
        jge @greaterThanTen
        
        @swapCycle1:
        mov dl, byte [partial_division + esi]
        mov ebx, dword [ebp + 16]
        mov byte [ebx + esi], dl
        dec esi
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
        
        mov edi, dword [ebp + 12]           ; text buffer
        mov ecx, dword [ebp + 8]            ; number size

        cmp dword [less_than_ten], 0
        jz @convertCycle
        jmp @end
        @greaterThanTen:
            mov dword [less_than_ten], 0
            jmp @swapCycle1
        
    @end:
        ;mov esi, dword [ebp + 8]
        ;dec esi
        ;mov al, byte [partial_division + esi]

        pop esi
        ;add al, 48
        ;mov byte [edi + esi], al
        
	pop eax
	pop ebx

        leave
        ret						; add esp, 12

