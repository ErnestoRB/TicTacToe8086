## Interrupciones usadas

- INT 10H

  - AH = 02 (Establece la posición del cursor)
    - Registros usados: (DH = fila, DL = columna, BH = pagina)
  - AH = 09 (Escribe caracter con atributo en posicion de cursor)
    - Registros usados (AL = caracter ASCII, BH = pagina, BL = atributo, CX = cuantas veces escribir caracter)

- INT 21H
  - AH = 9 (Escribe cadena con terminación '$')
    - Registros usados (DS:DX = Cadena a imprimir)
