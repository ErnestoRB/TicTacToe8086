org 100h

seleccion: ; se encarga de escoger el simbolo
; con el que quiere jugar         
    call restablecer_gato 
    call clear_screen
    mov dx, offset select      
    mov ah, 9
    int 21h ; imprime cadena
    mov ah, 1 ; X = 1, O = 2
    int 21h
    cmp al, '1'
    je asignarX
    cmp al, '2'   
    je asignarO 
    cmp al, 'E'
    je salir
    ; en caso de no seleccionar una válida (1 o 2), entonces repetir 
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
    mov TIPO, 4Fh ; asignamos el O a la variable
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
    
insertar: ; esta parte se encarga de la selección de casilla por parte del usuario
    cmp TURNO, 1h ; verificar si el turno es del jugador
    jne bot ; en caso de ser turno del bot, no pedirlo, si no generarlo
    mov dx, offset saltoline ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    mov dx, offset filas      ; muestra mensaje de seleccion
    mov ah, 9  
    int 21h
    mov ah, 1
    int 21h  
    sub al, 48 ; convertir ascii a numero
    call es_casilla_libre ; comprobar que la casilla elegida sea libre
    je casilla ; en caso de que si lo sea, ir a insertarla
    jmp final ; en caso contrario, volver a preguntar
                                                     
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
    
casilla1: ; todas las subrutinas casilla"N" lo que hacen es colocar el cursor en
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
    call simbolo ; obtiene el simbolo a imprimirse según el turno
    call registrar_casilla ; registrar casilla para que no pueda ser sobreescrita
    mov cx, 1h
    mov ah, 9h
    MOV BX, 0Fh 
    int 10h                           ; imprimir caracter
    call comprobar_ganador ; comprobar si hubo ganador (o empate, en su defecto)
    call alternar_turno ; alternar el turno al que sigue
    jmp final ; se prepara para preguntar por otra casilla

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
    int 21h ; llamada al tiempo del sistema MS-DOS
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
    ; las cuatro lineas de arriba comprueban que sea una casilla valida (entre 1 y 9)
    PUSH BX
    mov BX, offset CASILLAS ; inicio del arreglo
    mov AH, 0
    mov SI, AX ; desplazamiento del arreglo
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
; a partir de aqui se consulta si alguno de los 8 patrones para ganar se cumplen para
; el jugador que tiro
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
    jmp tecla_para_continuar
    ganador_cpu: mov dx, offset perdiste ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    jmp tecla_para_continuar
empate:
    call clear_screen
    mov dx, offset empataste ; saca a pantalla el salto de linea
    mov ah, 9 ; escribir cadena 
    int 21h
    jmp tecla_para_continuar              
    
tecla_para_continuar:     
mov dx, offset saltoline 
mov ah, 9  
int 21h
mov dx, offset continuar 
int 21h
mov ah, 7
int 21h
je seleccion                  

restablecer_gato:
PUSH BX
mov BX, offset CASILLAS ; inicio del arreglo   
mov CX, 8
limpiar_casilla: mov SI, CX               ; cargar desplazamiento     
mov [BX + SI], 0
LOOP limpiar_casilla
MOV [BX], 0
POP BX       
MOV TIROS, 0
ret


sumar_coincidencia:
jne no_sumar
inc cx
no_sumar: ret     

salir: 
call clear_screen        
mov dx, offset agradecimientos
mov ah, 9
int 21h
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
agradecimientos db "Gracias!$"              
continuar db "Presiona una tecla para continuar$"                
select db "Simbolo a utilizar: X = 1, O = 2 (o Salir = E): $"