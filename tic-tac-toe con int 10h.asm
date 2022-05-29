org 100h

TIPO db 0h ;aqui se guardara el simbolo a jugar O o X
TIPO_CPU db 0h
PONER db 0h
VUELTAS dw 2h
TURNO db 1h 
 
seleccion:

    mov dx, offset select      
    mov ah, 9
    int 21h
   
    mov ah, 1 ; X = 1, O = 2
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
        mov TIPO, 58h ;asignamos la X a la directiva
        mov TIPO_CPU, 4Fh
        mov dh, 2h    ; posicionamos el cursor en la columna correspondiente
        call    clear_screen
        
        jmp tablero
        
    asignarO:
        mov TIPO, 4Fh ;asignamos el O a la directiva
        mov TIPO_CPU, 58h
        mov dh, 2h
        call    clear_screen 
        
        jmp tablero
        
select db "Simbolo a utilizar: X = 1, O = 2: $"
  
tablero: ;se despliega el tablero para jugar

    ;dh mueve el cursor por columnas en la int 10h
    ;dl mueve el cursor por filas en la int 10h
    
    mov al, 0 
    mov bl, 1111b
    mov bh, 0
    
    mov dl, 25h
    mov ah, 2h
    int 10h 

    mov al, 186 ;caracteres ascii en decimal del tablero del gato
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
    
    inc dl ; incrementar posicion del cursor
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
    
    dec VUELTAS ;El gato imprime un patron dos veces para ahorrar lineas de codigo
    
    cmp VUELTAS, 0
    jne tablero 
   
    mov dl, 25h ;imprime la parte restante del tablero
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

    cmp TURNO, 1h
    jne bot

    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    
    mov dx, offset filas      
    mov ah, 9  
    int 21h

    mov ah, 1
    int 21h
    
    mov TURNO, 0 ;el siguiente turno sera del cpu
     
    jmp casilla ;cambiar a validacion de ganador, por ahora es solo un bucle infinito 
                                                     
casilla:

    cmp al, '1'
    je casilla1
       
    cmp al, '2'
    je casilla2
    
    cmp al, '3'
    je casilla3
    
    cmp al, '4'
    je casilla4
    
    cmp al, '5'
    je casilla5
    
    cmp al, '6'
    je casilla6
    
    cmp al, '7'
    je casilla7
    
    cmp al, '8'
    je casilla8
    
    cmp al, '9'
    je casilla9
    
    final: ;se reposiciona el cursor para volver a preguntar por el numero de casilla a insertar
        mov dh, 6h
        mov dl, 0h
        mov ah, 2h
        int 10h 
            
    jmp insertar
    
;cada casilla tiene una coordenada diferente
;"call simbolo" identifica si el siguiente simbolo a colocar es del cpu o del jugador 
    
casilla1:
     
    mov dh, 2h
    mov dl, 23h
    mov ah, 2h
    int 10h
    
    call simbolo
       
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final  
                  
casilla2: 

    mov dh, 2h
    mov dl, 26h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
                
casilla3:
           
    mov dh, 2h
    mov dl, 29h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
        
casilla4:

    mov dh, 4h
    mov dl, 23h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final  
                   
casilla5:

    mov dh, 4h
    mov dl, 26h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
               
casilla6:

    mov dh, 4h
    mov dl, 29h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
    
casilla7: 

    mov dh, 6h
    mov dl, 23h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final  
                   
casilla8:

    mov dh, 6h
    mov dl, 26h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
               
casilla9:

    mov dh, 6h
    mov dl, 29h
    mov ah, 2h
    int 10h 

    call simbolo
    
    mov cx, 1h
    mov ah, 9h
    int 10h
    jmp final
               
saltoline db 0Dh,0Ah, "$"
filas db "Inserta la casilla: $"

simbolo: ;alterna entre jugador y cpu en base al turno
    
    cmp TURNO, 0
    je turno_cpu
        mov al, TIPO_CPU
        ret
    
    turno_cpu:
        mov al, TIPO
        ret 

bot: 
    
    mov TURNO, 1 ;el siguiente turno sera del jugador
    call random
    jmp insertar


random: ;toma el los milisegundos de la hora y toma el primer digito
    
    mov ah, 2Ch
    int 21h
    xor ax, ax
    mov dh, 00h
    shr dl, 4h
    mov al, dl
    add al, 30h
    jmp casilla
    ret
    
       
clear_screen: ; Limpia la pantalla
       
    mov ah, 0fh
    int 10h   
    mov ah, 0
    int 10h
    ret              

int 20h 