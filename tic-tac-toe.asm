org 100h

TIPO dw 0 

;llenar casillas con espacio vacio para despues poner las X o O
mov cx, 09h
mov bx, 200h

llenado:
    mov [bx], 20h ;20h es el espacio en la tabla ASCII
    inc bx
    loop llenado
    
;escoger entre O o X

escoger:
    mov dx, offset msj1 ; saca a pantalla el msj1
    mov ah, 9 ; escribir cadena 
    int 21h

    mov ah, 1 ;entrada estandar de caracter
    int 21h

    cmp al, '1'
    je asignarO

    cmp al, '2'
    je asignarX 
    
    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    
    jmp escoger

asignarO:
    mov TIPO, 04Fh ; O en hex es 4F
    jmp impresion

asignarX: 
    mov TIPO, 058h ; X en hex es 58 
    jmp impresion  

msj1 db "Deseas jugar con O o con X? O=1, X=2:  $"; $ denota que es en base 16


impresion: 
    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
      
    mov dx, 0
    mov bx, 1FFh ;una posicion antes de la tabla de O/X
    mov cx, 2h
    LINE dw 0
    
    llenado_gato:
    
    ;imprime gato con sus respectivas casillas
    
    mov dx, offset saltoline
    mov ah, 9
    int 21h
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    
    mov dx, 7Ch ; simbolo |
    mov ah, 2
    int 21h
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    
    mov dx, 7Ch
    mov ah, 2
    int 21h 
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    
    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    
    mov LINE, 0h  ; imprime las lineas horizontales
    lineas:
        mov dx, 2Dh ; caracter '-' en hex
        mov ah, 2
        int 21h
        inc LINE
        cmp LINE, 5h
        jne lineas
        
    loop llenado_gato
    
    mov dx, offset saltoline
    mov ah, 9  
    int 21h
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    
    mov dx, 7Ch
    mov ah, 2
    int 21h
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    
    mov dx, 7Ch
    mov ah, 2
    int 21h 
    
    inc bx
    mov dx, [bx]
    mov ah, 2
    int 21h
    

mov bx, 0
mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h

mov dx, offset insertar ; saca a pantalla el msj1
mov ah, 9 ; escribir cadena 
int 21h 
  
mov ah, 1 ;entrada estandar de caracter
int 21h



mov ah, 0h   
sub al, 30h



mov bx, ax
 
mov [200h+bx],offset TIPO ; arreglar error, no imprime la casilla 

jmp impresion




insertar db "Numero de casilla a insertar simbolo:  $"    
saltoline db 0Dh,0Ah, "$" 

int 20h  
