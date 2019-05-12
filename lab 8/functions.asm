section .text
global myFunction

; correct
myFunction:                     ; A array size, A, X, result buffer
    push ebp
    mov ebp, esp
    
    mov eax, dword [ebp + 20]   ; size
    mov ebx, dword [ebp + 16]   ; A
    mov ecx, dword [ebp + 12]   ; X
    mov edx, dword [ebp + 8]    ; result
    
    dec eax
    cmp eax, 0                  ; res = A[0] if A is one-element array
    jz @oneElement
    fld dword [ebx + 4*eax]
    @calculationCycle:
        fmul dword [ecx]
        dec eax
        fadd dword [ebx + 4*eax]
        cmp eax, 0
        jnz @calculationCycle
        fstp dword [edx]
        jmp @end
    @oneElement:
        mov esi, dword [ebx]
        mov dword[edx], esi
    @end:
        leave
        ret 16
