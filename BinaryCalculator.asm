.model small
.stack 100h
.data
 
menu db 0dh,0ah,"*********-----------SIMPLE CALCULATOR CO&AL PROJECT----------********",0dh,0ah
     db 0ah,"   Group Members: YASHA AKMAL-049, NAILA SHAHEEN-015, ALIZA SHAKEEL-27",0dh,0ah
     db " FATIMA JINNAH WOMEN UNIVERSITY, COAL",0dh,0ah
     db "",0dh,0ah
     db "**********************************************************************",0dh,0ah
     db "",0dh,0ah
     db "1-Add",0dh,0ah,"2-Multiply",0dh,0ah,"3-Subtract",0dh,0ah,"4-Divide",0dh,0ah
     db "5-Exponent",0dh,0ah,"6-Factorial",0dh,0ah
     db "7-AND",0dh,0ah,"8-OR",0dh,0ah,"9-NOT",0dh,0ah
     db "A-1's Complement",0dh,0ah,"B-2's Complement",0dh,0ah,"0-Exit",0dh,0ah,'$'
 
choice_message  db 0dh,0ah,"Enter your Choice: $"
fno_message     db 0dh,0ah,"Enter First Binary Number (max 4 bits): $"
sno_message     db 0dh,0ah,"Enter Second Binary Number (max 4 bits): $"
sinno_message   db 0dh,0ah,"Enter Binary Number (max 4 bits): $"
result_message  db 0dh,0ah,"ANSWER: ",'$'
error_message   db 0dh,0ah,"Error: Invalid Input",0dh,0ah,'$'
display_magain  db 0dh,0ah,"Press any key to display the menu...",0dh,0ah,'$'
exit_message    db 0dh,0ah,"Good Bye! Thanks for using our calculator.",0dh,0ah,'$'
 
choice db ?
no1    db ?
no2    db ?
result db ?
binary_buffer db '00000000$',0
 
.code
main proc
    mov ax, @data
    mov ds, ax
 
Start:
    call display_menu
 
    lea dx, choice_message
    mov ah, 09h
    int 21h
 
    mov ah, 01h
    int 21h
    mov choice, al
 
    cmp choice, '1'
    je  Addition
    cmp choice, '2'
    je  Multiply
    cmp choice, '3'
    je  Subtraction
    cmp choice, '4'
    je  Divide
    cmp choice, '5'
    je  Exponent
    cmp choice, '6'
    je  Factorial
    cmp choice, '7'
    je  AND_Operation
    cmp choice, '8'
    je  OR_Operation
    cmp choice, '9'
    je  NOT_Operation
    cmp choice, 'A'
    je  OnesComplement
    cmp choice, 'B'
    je  TwosComplement
    cmp choice, '0'
    je  Exit
 
InvalidChoice:
    lea dx, error_message
    mov ah, 09h
    int 21h
    mov ah, 0
    int 16h
    jmp Start
 
;--------------------Operations-----------------------
 
Addition:
    call two_input
    mov al, no1
    mov bl, no2
    add al, bl
    mov result, al
    call display_binary_result
    jmp Start
 
Subtraction:
    call two_input
    mov al, no1
    mov bl, no2
    sub al, bl
    mov result, al
    call display_binary_result
    jmp Start
 
Multiply:
    call two_input
    mov al, no1
    mov bl, no2
    mul bl
    mov result, al
    call display_binary_result
    jmp Start
 
Divide:
    call two_input
    mov al, no1
    mov bl, no2
    cmp bl, 0
    je  DivisionError
    mov ah, 0
    div bl
    mov result, al
    call display_binary_result
    jmp Start
 
DivisionError:
    lea dx, error_message
    mov ah, 09h
    int 21h
    jmp Start
 
Exponent:
    call two_input
    mov al, no1
    mov bl, no2
    mov cl, bl
    dec cl
    mov bl, al
 
ExponentLoop:
    cmp cl, 0
    je  ExponentDone
    mul bl
    dec cl
    jmp ExponentLoop
 
ExponentDone:
    mov result, al
    call display_binary_result
    jmp Start
 
Factorial:
    call one_input
    mov al, no1
    cmp al, 0
    je  FactorialIsOne
    mov bl, al
    dec bl
    mov cl, bl
    mov bl, al
 
FactorialLoop:
    cmp cl, 1
    jl  FactorialDone
    mul cl
    dec cl
    jmp FactorialLoop
 
FactorialDone:
    mov result, al
    call display_binary_result
    jmp Start
 
FactorialIsOne:
    mov result, 1
    call display_binary_result
    jmp Start
 
;------------------Binary Logic Operations-------------------
 
AND_Operation:
    call two_input
    mov al, no1
    mov bl, no2
    and al, bl
    mov result, al
    call display_binary_result
    jmp Start
 
OR_Operation:
    call two_input
    mov al, no1
    mov bl, no2
    or  al, bl
    mov result, al
    call display_binary_result
    jmp Start
 
NOT_Operation:
    call one_input
    mov al, no1
    not al
    and al, 0Fh        ; Mask to 4 bits only
    mov result, al
    call display_binary_result
    jmp Start
 
;------------------1's Complement-------------------
 
OnesComplement:
    call one_input
    mov al, no1
    not al             ; Flip all bits
    and al, 0Fh        ; Mask to 4 bits
    mov result, al
    call display_binary_result
    jmp Start
 
;------------------2's Complement-------------------
 
TwosComplement:
    call one_input
    mov al, no1
    not al             ; 1's complement
    add al, 1          ; Add 1 -> 2's complement
    and al, 0Fh        ; Mask to 4 bits
    mov result, al
    call display_binary_result
    jmp Start
 
Exit:
    call goodbye
    mov ah, 4ch
    int 21h
 
;--------------------Procedures-----------------------
 
display_menu proc
    lea dx, display_magain
    mov ah, 09h
    int 21h
    mov ah, 0
    int 16h
    lea dx, menu
    mov ah, 09h
    int 21h
    ret
display_menu endp
 
;-----------------Input Procedures-------------------
 
ReadBinary proc
    xor al, al         ; Clear AL (final number)
    xor bl, bl         ; Temp accumulator
    mov cl, 0          ; Bit counter
 
ReadLoop:
    mov ah, 01h
    int 21h
    cmp al, 13         ; Enter ends input
    je  ReadDone
    sub al, '0'
    cmp al, 0
    jl  InvalidChoice
    cmp al, 1
    jg  InvalidChoice
    shl bl, 1
    or  bl, al
    inc cl
    cmp cl, 4
    je  ReadDone
    jmp ReadLoop
 
ReadDone:
    mov al, bl
    ret
ReadBinary endp
 
one_input proc
    lea dx, sinno_message
    mov ah, 09h
    int 21h
    call ReadBinary
    mov no1, al
    ret
one_input endp
 
two_input proc
    lea dx, fno_message
    mov ah, 09h
    int 21h
    call ReadBinary
    mov no1, al
 
    lea dx, sno_message
    mov ah, 09h
    int 21h
    call ReadBinary
    mov no2, al
    ret
two_input endp
 
;-----------------Output Procedure-------------------
 
display_binary_result proc
    lea dx, result_message
    mov ah, 09h
    int 21h
 
    mov al, result
    lea di, binary_buffer+7
    mov bl, 8
 
ConvertLoop:
    mov dl, al
    and dl, 1
    add dl, '0'
    mov [di], dl
    shr al, 1
    dec di
    dec bl
    jnz ConvertLoop
 
    lea dx, binary_buffer
    mov ah, 09h
    int 21h
    ret
display_binary_result endp
 
goodbye proc
    lea dx, exit_message
    mov ah, 09h
    int 21h
    ret
goodbye endp
 
end main