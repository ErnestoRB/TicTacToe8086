org 100h

TIPO db 0
VUELTAS dw 2h

 
seleccion: 

    mov ah, 1 ; X = 1, 0 = 2
    int 21h
       
    cmp al, '1'
    je asignarX

    cmp al, '2'
    je asignarO
    
    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h

jmp seleccion

    asignarX:
        mov TIPO, 58h
        mov dh, 2h
        
        jmp tablero
        
    asignarO:
        mov TIPO, 4Fh
        mov dh, 2h
        
        jmp tablero
    
          

select db "Simbolo a utilizar: X = 1, O = 2:  $"


tablero:
    mov al, 0 
    mov bl, 1111b
    mov bh, 0
    
    
    mov dl, 25h
    mov ah, 2h
    int 10h 

    mov al, 186
    mov cx, 1h
    mov ah, 9h
    int 10h
    
    mov dl, 28h
    mov ah, 2h
    int 10h
    
    mov al, 186
    mov cx, 1h
    mov ah, 9h
    int 10h 
    
    inc dh ; columna
    
    mov dl, 23h ; filas
    mov ah, 2h
    int 10h
    
    mov al, 205
    mov cx, 2h
    mov ah, 9h
    int 10h
    
    add dl, 2h
    mov ah, 2h
    int 10h
    
    mov al, 206
    mov cx, 1h
    mov ah, 9h
    int 10h
    
    add dl, 1h ; incrementar posicion del cursor
    mov ah, 2h
    int 10h
    
    mov al, 205
    mov cx, 2h
    mov ah, 9h
    int 10h
    
    add dl, 2h
    mov ah, 2h
    int 10h 
    
    mov al, 206
    mov cx, 1h
    mov ah, 9h
    int 10h
    
    add dl, 1h
    mov ah, 2h
    int 10h
    
    mov al, 205
    mov cx, 2h
    mov ah, 9h
    int 10h
    
    inc dh 
    
    dec VUELTAS
    
    cmp VUELTAS, 0
    jne tablero 
   
    
    mov dl, 25h
    mov ah, 2h
    int 10h 

    mov al, 186
    mov cx, 1h
    mov ah, 9h
    int 10h
    
    mov dl, 28h
    mov ah, 2h
    int 10h
    
    mov al, 186
    mov cx, 1h
    mov ah, 9h
    int 10h
    
    
insertar:

    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    
    mov dx, offset filas      
    mov ah, 9
    int 21h

    mov ah, 1
    int 21h
     
    jmp casilla 
               
               
               
               
casilla:
    cmp al, '1'
    je cambio1
    
        
    cmp al, '2'
    je cambio2
    
    cmp al, '3'
    je cambio3
    
    final:
        mov dh, 6h
        mov dl, 0h
        mov ah, 2h
        int 10h  
        
    jmp insertar
    
    
cambio1: 
        mov dh, 2h
        mov dl, 23h
        mov ah, 2h
        int 10h 

        mov al, TIPO
        mov cx, 1h
        mov ah, 9h
        int 10h
        jmp final  
        
        
        
        
cambio2:
        mov dh, 2h
        mov dl, 26h
        mov ah, 2h
        int 10h 

        mov al, TIPO
        mov cx, 1h
        mov ah, 9h
        int 10h
        jmp final
        
cambio3:
        mov dh, 2h
        mov dl, 29h
        mov ah, 2h
        int 10h 

        mov al, TIPO
        mov cx, 1h
        mov ah, 9h
        int 10h
        jmp final
        
        
saltoline db 0Dh,0Ah, "$"
filas db "Inserta la casilla: $"   
    

int 20h 