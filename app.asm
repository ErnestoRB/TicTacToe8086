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
    
    cmp TURNO, 1h ; verificar si el turno es del jugador
    jne bot

    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    
    mov dx, offset filas      
    mov ah, 9  
    int 21h

    mov ah, 1
    int 21h  
    sub al, 48 ; convertir ascii a numero
    call es_casilla_libre
    je casilla ; 
    jmp final 
                                                     
casilla:

    cmp al, 1
    je casilla1
       
    cmp al, 2
    je casilla2
    
    cmp al, 3
    je casilla3
    
    cmp al, 4
    je casilla4
    
    cmp al, 5
    je casilla5
    
    cmp al, 6
    je casilla6
    
    cmp al, 7
    je casilla7
    
    cmp al, 8
    je casilla8
    
    cmp al, 9
    je casilla9     
    
                 
    
alternar_turno:
        cmp TURNO, 1
        jne  TURNO_BOT
        MOV TURNO, 0  
        ret
turno_bot: MOV TURNO, 1
        ret
    
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
    jmp imprimir
                  
casilla2: 

    mov dh, 2h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    jmp imprimir  
                
casilla3:
           
    mov dh, 2h
    mov dl, 29h
    mov ah, 2h
    int 10h 
    jmp imprimir  
        
casilla4:

    mov dh, 4h
    mov dl, 23h
    mov ah, 2h
    int 10h 
    jmp imprimir  
                   
casilla5:

    mov dh, 4h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    jmp imprimir 
               
casilla6:

    mov dh, 4h
    mov dl, 29h
    mov ah, 2h
    int 10h 
    jmp imprimir  
    
casilla7: 

    mov dh, 6h
    mov dl, 23h
    mov ah, 2h
    int 10h 
    jmp imprimir  
                   
casilla8:

    mov dh, 6h
    mov dl, 26h
    mov ah, 2h
    int 10h 
    jmp imprimir  
               
casilla9:

    mov dh, 6h
    mov dl, 29h
    mov ah, 2h
    int 10h      
    jmp imprimir  
               
imprimir: ; no debe llamarse sin comprobar que sea casilla libre
    call simbolo
    call registrar_casilla      
    mov cx, 1h
    mov ah, 9h
    MOV BX, 0Fh 
    int 10h                           
    call comprobar_ganador
    call alternar_turno
    jmp final

simbolo: ;alterna el símbolo a imprimir en función al turno
    
    cmp TURNO, 0    
    mov AH, AL
    je turno_cpu
        mov al, TIPO
        ret
    turno_cpu:
        mov al, TIPO_CPU
        ret 

bot: 
    
    call random
    jmp insertar


random: ;toma los milisegundos de la hora y hace ajustes de ascii
    
    mov ah, 2Ch
    int 21h
    xor ax, ax
    mov dh, 00h
    add ax, dx
    aaa ; hace un ajuste a decimal del digito aleatorio              
    call es_casilla_libre
    jne random
    mov ah, 00h ; se descarta el digito mas alto al hacer una conversion a decimal
    jmp casilla
    ret
    
       
clear_screen: ; Limpia la pantalla
    push ax
    mov ah, 0fh
    int 10h   
    mov ah, 0
    int 10h     
    pop ax
    ret              

es_casilla_libre:
    ; se asume que el numero de casilla esta en AL
    CMP AL, 1
    JB no_es_libre
    CMP AL, 9
    JA no_es_libre
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
no_es_libre:ret ; debe seguir instrucción de salto
    
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
    PUSH CX
    MOV CL, TIROS                         
    INC CL
    MOV TIROS, CL
    POP CX
    ret

comprobar_ganador:                                   ; simbolo en AL         
push cx                                                                   
mov cx, 0    
cmp casillas[0], al                     ;1
    call sumar_coincidencia
     cmp casillas[1], al  
     call sumar_coincidencia
     cmp casillas[2], al  
     call sumar_coincidencia
     cmp cx, 3
     JE ganador       
     mov cx, 0
cmp casillas[3], al                   ;2
    call sumar_coincidencia
     cmp casillas[4], al  
     call sumar_coincidencia
     cmp casillas[5], al
     call sumar_coincidencia
     cmp cx, 3
     JE ganador 
     mov cx, 0
cmp casillas[6], al                 ;3
    call sumar_coincidencia
     cmp casillas[7], al  
     call sumar_coincidencia
     cmp casillas[8], al
     call sumar_coincidencia
     cmp cx, 3
     JE ganador    
     mov cx, 0
cmp casillas[0], al              ; 4
    call sumar_coincidencia
     cmp casillas[3], al  
     call sumar_coincidencia
     cmp casillas[6], al
     call sumar_coincidencia
     cmp cx, 3
     JE ganador   
     mov cx, 0
cmp casillas[1], al            ;5
    call sumar_coincidencia
     cmp casillas[4], al  
     call sumar_coincidencia
     cmp casillas[7], al    
     call sumar_coincidencia
     cmp cx, 3
     JE ganador   
     mov cx, 0
cmp casillas[2], al          ;6
    call sumar_coincidencia
     cmp casillas[5], al  
     call sumar_coincidencia
     cmp casillas[8], al    
     call sumar_coincidencia
     cmp cx, 3
     JE ganador        
     mov cx, 0
cmp casillas[0], al       ; 7
    call sumar_coincidencia
     cmp casillas[4], al  
     call sumar_coincidencia
     cmp casillas[8], al    
     call sumar_coincidencia
     cmp cx, 3
     JE ganador    
     mov cx, 0
cmp casillas[2], al    ;8
    call sumar_coincidencia
     cmp casillas[4], al  
     call sumar_coincidencia
     cmp casillas[6], al    
     call sumar_coincidencia
     cmp cx, 3
     JE ganador        
    CMP TIROS, 9
    JE empate   
pop CX
ret
ganador:              
    call clear_screen                     
    cmp al, tipo
    jne ganador_cpu  
    mov dx, offset ganaste ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h          
    int 20h
    ganador_cpu: mov dx, offset perdiste ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    int 20h
empate:
    call clear_screen
    mov dx, offset empataste ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    int 20h

sumar_coincidencia:
jne no_sumar
inc cx
no_sumar: ret     

int 20h    
 ; variables
TIPO db 0h ;aqui se guardara el simbolo a jugar O o X
TIPO_CPU db 0h                                       
TIROS db 0h
PONER db 0h
VUELTAS dw 2h
TURNO db 1h 
CASILLAS db 9 DUP(0) ; 0 significa libre    
saltoline db 0Dh,0Ah, "$"
filas db "Inserta la casilla: (1-9) $"     
ganaste db "Ganaste!$"      
perdiste db "Perdiste ):$"
empataste db "Empate!$"                                    
select db "Simbolo a utilizar: X = 1, O = 2: $"