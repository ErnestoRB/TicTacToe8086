org 100h


 
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
    mov TIPO, 'X' ; jugador escogió 'X' como su simbolo
    mov TIPO_CPU, 'O' ; por lo tanto el bot es 'O'
    mov dh, 2h    ; posicionamos el cursor en la columna correspondiente
    call    clear_screen
    
    jmp tablero
    
asignarO:
    mov TIPO, 4Fh ; asignamos el O a la directiva
    mov TIPO_CPU, 58h
    mov dh, 2h
    call    clear_screen 
    
    jmp tablero
        

  
tablero: ;se despliega el tablero para jugar (separadores)

    ;dh mueve el cursor por filas (horizontal) en la int 10h
    ;dl mueve el cursor por columnas (vertical) en la int 10h
    
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
    
    inc dh ; cambiar fila (vertical)
    
    mov dl, 23h ; columna
    mov ah, 2h
    int 10h
    
    mov al, 205
    mov cx, 2h
    mov ah, 9h
    int 10h
    
    add dl, 2h ; cambiar columna
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
    
    inc dh ; cambiar fila
    
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
    sub al, 48 ; ajuste ASCII -> binario posicional
    call es_casilla_libre
    je imprimir
    jmp final  
                  
casilla2: 

    mov dh, 2h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
                
casilla3:
           
    mov dh, 2h
    mov dl, 29h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
        
casilla4:

    mov dh, 4h
    mov dl, 23h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
                   
casilla5:

    mov dh, 4h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
               
casilla6:

    mov dh, 4h
    mov dl, 29h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
    
casilla7: 

    mov dh, 6h
    mov dl, 23h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
                   
casilla8:

    mov dh, 6h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
               
casilla9:

    mov dh, 6h
    mov dl, 29h
    mov ah, 2h
    int 10h      
    sub al, 48
    call es_casilla_libre
    je imprimir
    jmp final  
               
imprimir:
    call simbolo
    call registrar_casilla      
    mov cx, 1h
    mov ah, 9h
    MOV BX, 0Fh 
    int 10h
    jmp final

simbolo: ;alterna el símbolo a imprimir en función al turno
    
    cmp TURNO, 0    
    mov AH, AL
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
    add ax, dx
    aaa ;hace un ajuste decimal del digito aleatorio              
    call es_casilla_libre
    jne random
    mov ah, 00h ; se descarta el digito mas alto al hacer una conversion a decimal
    add al, 30h ; ajuste ascii del byte mas significativo
    jmp casilla
    ret
    
       
clear_screen: ; Limpia la pantalla
       
    mov ah, 0fh
    int 10h   
    mov ah, 0
    int 10h
    ret              

es_casilla_libre:
    ; se asume que el numero de casilla esta en AL
    PUSH BX
    mov BX, offset CASILLAS ; inicio del arreglo
    mov AH, 0
    mov SI, AX
    DEC SI ; el usuario usa (1-9) pero para desplazamiento es (0-8)         
    PUSH DX
    mov DL, 0
    cmp [BX + SI], DL   ; si en el arreglo hay un 0 entonces si est� libre   
    POP DX                                          
    POP BX
    ret ; debe seguir instrucción de salto
    
registrar_casilla:
    ; se asume que el numero de casilla esta en AH y el simbolo en AL    
    PUSH BX
    mov BX, offset CASILLAS ; inicio del arreglo
    PUSH AX ; guardar valores originales    
    XCHG AH, AL
    mov AH, 0      
    mov SI, AX               ; cargar desplazamiento     
    DEC SI ; el usuario usa (1-9) pero para desplazamiento es (0-8)
    POP AX
    mov [BX + SI], AL ;registrar
    POP BX
    ret
     

int 20h    
 ; variables
TIPO db 0h ;aqui se guardara el simbolo a jugar O o X
TIPO_CPU db 0h
PONER db 0h
VUELTAS dw 2h
TURNO db 1h 
CASILLAS db 9 DUP(0) ; 0 significa libre    
saltoline db 0Dh,0Ah, "$"
filas db "Inserta la casilla: (1-9) $"     
select db "Simbolo a utilizar: X = 1, O = 2: $"