;nasm -f elf32 <file>.asm
;gcc -m32 <file>.o -o <outputBinary>

section .data
    fileName: db "input.dat",0
    format: db "%d ", 0
    objSize: db 0xc8
    elements: db 0x31
    swap: db 0
    
section .text
    extern printf
    extern exit
    global main

;DO NOT MODIFY
loadArray:
    push ebp
    mov ebp, esp
    sub esp, 0x4                      ; stack space for file descriptor

    mov eax, 5                        ; open file command
    mov ebx, fileName                 ; file name
    mov ecx, 0                        ; read only mode
    mov edx, 0777                     ; permissions
    int 0x80                          ; execute command

    mov [esp], eax                    ; save the file descriptor

    mov eax, 3                        ; read the file
    mov ebx, [esp]                    ; the returned file descriptor
    lea ecx, [ebp+0x8]                ; top of the buffer
    mov edx, [objSize]                ; size of the buffer
    int 0x80                          ; execute command

    mov eax, 6                        ; close the file
    mov ebx, dword [esp]              ; file descriptor
    int 0x80                          ; execute command
    
    add esp, 0x4                      ; clean up
    pop ebp
    ret

; Outline code to be completed.
printArray:
    ;...missing code
    push ebp
    mov ebp, esp
    push edi
    push esi

    push dword [ebp + 0x8]          ;<the thing you want to print>
    push format                     ; don't change
    call printf                     ; don't change
    add esp, 0x8                    ; don't change
    ;...missing code
    pop esi
    pop edi
    pop ebp
    ret


;   Bubble sort
;   for (c = 0 ; c < n - 1; c++)
;   {
;     for (d = 0 ; d < n - c - 1; d++)
;     {
;       if (array[d] > array[d+1]) /* For decreasing order use '<' instead of '>' */
;       {
;         swap       = array[d];
;         array[d]   = array[d+1];
;         array[d+1] = swap;
;       }
;     }
;   }
sort:
    push ebp
    mov ebp, esp
    ; [ebp + 0x8] array
    lea edi, [ebp + 0x8]                ; Pointer to array at EDI
    mov edx, 0

.outer:
    xor ecx, ecx                        ; Accumulator variable
.compare:
    mov eax, [edi + 4*ecx]              ; Move first value off stack
    cmp eax, [edi + 4*ecx + 0x4]        ; Compare next value on stack
    jb .noswap

    ; Swap variables if it needs to
.swap:
    mov ebx, [edi + 4*ecx + 0x4]        ; Move second value into tmp
    mov [edi + 4*ecx + 0x4], eax        ; Move first value into second value
    mov [edi + 4*ecx], ebx              ; Move second value into 1 position

.noswap:
    inc ecx
    mov esi, [elements]
    sub esi, edx
    cmp ecx, esi
    jb .compare

    inc edx
    cmp edx, [elements]
    jbe .outer

    pop ebp
    ret


main:
    push ebp
    mov ebp, esp
    sub esp, [objSize]               ; stack space for numbers

    push dword [esp]
    call loadArray

    call sort

    ; Loop over array to get the values in it.
    xor ebx, ebx
.L0:
    push dword [esp + 4*ebx]
    call printArray
    add esp, 0x4
    inc ebx
    cmp ebx, [elements]
    jbe .L0

    add esp, [objSize]
    pop ebp
    call exit
