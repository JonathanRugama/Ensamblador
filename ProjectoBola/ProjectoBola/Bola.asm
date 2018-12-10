; UNIVERSIDAD DE COSTA RICA - SEDE GUANACASTE
; IF-4000 ARQUITECTURA DE COMPUTADORES
; JUEGO BALL CON DOS RAQUETAS.
; POR: Ing. Alejandro Delgado Castro, M.Sc.
; FECHA: 19/12/2014

INCLUDE c:\Irvine\Irvine32.inc
INCLUDELIB c:\Irvine\Irvine32.lib

		.data		;Directiva de Inicio de Variables.

TBox	db			"Ball Game",0	;Título de Ventana.
TgoJA	byte		"Game Over - Gana Jugador A",0
TgoJB	byte		"Game Over - Gana Jugador B",0
TgoVJ	byte		"¿Desea volver a jugar?",0
Ball	byte		'0'


Col		byte		117		;Columna de Bola.
Fil		byte		0		;Fila de Bola.



Maxc	byte		0		;Columna Máxima.
Maxf	byte		0		;Fila Máxima.
Dcol	byte		0		;Dirección Columna. (0 = Derecha, 1 = Izquierda).
Dfil	byte		0		;Dirección Fila. (0 = Abajo, 1 = Arriba).
Raf		byte		10		;Fila de Raqueta A.
Rac		byte		0		;Columna Raqueta A.
Rbf		byte		10		;Fila de Raqueta B.
Rbc		byte		0		;Columna Raqueta B.
choca	byte		0
hayDosBolas	byte	0		;Pregunta si hay una bola
TgoE	byte		"Entra"

DcolB	byte		0		;Dirección Columna. (0 = Derecha, 1 = Izquierda).
DfilB	byte		0		;Dirección Fila. (0 = Abajo, 1 = Arriba).


;PILA DE VARIABLES para dibujar la pelota
pelota_parte1	byte	" .. "           ,0		
pelota_parte2	byte    "::::"          ,0
pelota_parte3	byte	" '' "    ,0	;FORMA DE LA BOLA

;PILA DE VARIABLES para borrar la pelota
Bpelota_parte1	byte	"    "           ,0		
Bpelota_parte2	byte    "    "          ,0
Bpelota_parte3	byte	"    "    ,0	;FORMA DE LA BOLA

pelota_fila      byte    10	
pelota_columna   byte    1 
Fila_maxima byte 0					;Fila maxima para la creacion de la pelota
Columna_max byte 0					;columna maxima para la creacion de la pelota

		.code

;*************************************************************************************************
; FUNCIÓN MAIN                                                                                   *
;*************************************************************************************************

main	PROC

Inicio: call		GetMaxXY	;Toma el Tamaño Actual de la Ventana de Consola.
		mov			Maxc,dl
		mov			Rbc,dl
		mov			Maxf,21
		sub			Maxc,2
		sub			Rbc,1
		mov			dh,0		;Escribe Línea Superior.
		mov			dl,0
		call		WLin
		mov			dh,24		;Escribe Línea Inferior.
		mov			dl,0
		call		WLin
		call		Wjuga		;Escribe Identificadores para Jugadores.
		mov			edx,0		;Vuelve Cursos al Inicio.
		call		Gotoxy
	

Ciclo:		
		call		DibujarPelota
		mov			dh,Raf		;Escribe Raqueta A.
		mov			dl,Rac
		call		WRaq
		mov			dh,Rbf		;Escribe Raqueta B.
		mov			dl,Rbc
		call		WRaq
		mov			eax,30	;Espera de 200 ms (0.2 s).
		call		Delay
		call		Borra_pelota
		;call		CicloB
		call		ReadKey		;Revisa el Teclado.
		jz			Ccol		;Si no hay tecla, salto a Control Columna.
		jz			CcolB		;Si no hay tecla, salto a Control Columna................................................
		jnz			Tecla		;Si hay tecla.

CicloB:
		call		Wball		;Crea una nueva bola
		mov			dh,Raf		;Escribe Raqueta A.
		mov			dl,Rac
		call		WRaq
		mov			dh,Rbf		;Escribe Raqueta B.
		mov			dl,Rbc
		call		WRaq
		mov			eax,50    ;Espera de 200 ms (0.2 s).
		call		Delay		;Detiene la ejecución del programa durante un intervalo especifi cado de n milisegundos
		call		CBall		;Borra la Bola.

		call		ReadKey		;Revisa el Teclado.
		jz			Ccol		;Si no hay tecla, salto a Control Columna.
		jz			CcolB		;Si no hay tecla, salto a Control Columna..........................................................
		jnz			Tecla		;Si hay tecla.


Tecla:	cmp			al,'a'		;Si Tecla es 'a' --> Raqueta 1 Arriba.
		je			RaUp
		cmp			al,'z'		;Si Tecla es 'z' --> Raqueta 1 Abajo.
		je			RaDw
		cmp			al,'k'		;Si Tecla es 'k' --> Raqueta 2 Arriba.
		je			RbUp
		cmp			al,'m'		;Si Tecla es 'm' --> Raqueta 2 Abajo.
		je			RbDw
		jmp			Ccol		;Si es otra Tecla salto a Control Columna.

RaUp:	mov			dh,Raf		;Borro Raqueta A posición Actual.
		mov			dl,Rac
		call		CRaq
		cmp			Raf,1		;Comparo Fila de Raqueta A con 0.
		je			Ccol		;Si son iguales, no subo más y voy a Coltrol Columna.
		dec			Raf			;Subo la Raqueta A una fila.
		jmp			Ccol		;Salto a Control Columna.

RaDw:	mov			dh,Raf		;Borro Raqueta A posición Actual.
		mov			dl,Rac
		call		CRaq
		cmp			Raf,20		;Comparo Fila de Raqueta A con 24 - 3.
		je			Ccol		;Si son iguales, no bajo más y voy a Coltrol Columna.
		inc			Raf			;Bajo la Raqueta A una fila.
		jmp			Ccol		;Salto a Control Columna.

RbUp:	mov			dh,Rbf		;Borro Raqueta B posición Actual.
		mov			dl,Rbc
		call		CRaq
		cmp			Rbf,1		;Comparo Fila de Raqueta B con 0.
		je			Ccol		;Si son iguales, no subo más y voy a Coltrol Columna.
		dec			Rbf			;Subo la Raqueta B una fila.
		jmp			Ccol		;Salto a Control Columna.

RbDw:	mov			dh,Rbf		;Borro Raqueta B posición Actual.
		mov			dl,Rbc
		call		CRaq
		cmp			Rbf,20		;Comparo Fila de Raqueta B con 24 - 3.
		je			Ccol		;Si son iguales, no bajo más y voy a Coltrol Columna.
		inc			Rbf			;Bajo la Raqueta B una fila.
		jmp			Ccol		;Salto a Control Columna.

Ccol:	cmp			Dcol,0		;Reviso Dirección Movimiento de Columna.
		jne			Cup

CcolB:	cmp			Dcol,0		;Reviso Dirección Movimiento de Columna.
		jne			Cup


Cdown:	
		mov			al,pelota_columna		;Columna se Incrementa
		add			al,3
		cmp			al,Maxc
		jnl			CDcol1
		inc			pelota_columna
		jmp			Cfil



Cup:	cmp			pelota_columna,1
		jng			CDcol2
		dec			pelota_columna
		jmp			Cfil



CDcol1:	mov			al,Rbf		;Reviso si hay choque con Raqueta B.
		cmp			al,pelota_fila
		jg			GameO1		;Salto a Game Over.
		add			al,3
		cmp			al,pelota_fila
	    ;sub			al,2  ;Le resto dos a al
		mov			Fil,al ;Sirve para hacer que la bola aparezca en el centro de la raqueta
		jl			GameO1		;Salto a Game Over.
		mov			Dcol,1		;Cambia Dirección de Movimiento en Columna.
		
		
		mov			al,hayDosBolas
		.IF hayDosBolas == 0 ;Si es igual a 0 se crea una nueva bola
			
		cmp		al,hayDosBolas  ;Compara si es igual a 0
		
		jmp			CicloB		
		jmp			Cfil
		
		.ELSE			;En caso contrario no se crea
		jmp			Cfil
		.ENDIF

CDcol2:	mov			al,Raf		;Reviso si hay choque con Raqueta A.
		cmp			al,pelota_fila
		jg			GameO2		;Salto a Game Over.
		add			al,3
		cmp			al,pelota_fila
		jl			GameO2		;Salto a Game Over.
		mov			Dcol,0		;Vuelve cursor a inicio de fila.
		jmp			Cfil

Cfil:	cmp			Dfil,0		;Reviso Dirección de Movimiento en Fila.
		;cmp			DfilB,1
		jne			Fup
		

Fdown:	mov			al,pelota_fila		;Columna se Incrementa
		cmp			al,Maxf
		jnl			CDfil1
		inc			pelota_fila
		call		Ciclo
		call		CicloB

Fup:	cmp			pelota_fila,1
		;cmp		Fil,117
		jng			CDfil2
		dec			pelota_fila
		;dec		Fil
		call		Ciclo
		call		CicloB


CDfil1:	mov			Dfil,1		;Cambia Dirección de Movimiento en Fila.
		mov		DfilB,0
		call		Ciclo
		call		CicloB

CDfil2:	mov			Dfil,0		;Vuelve cursor a inicio de fila.
	    mov			DfilB,1
		call		Ciclo
		call		CicloB



GameO1: call		Borra_pelota		;Borro la Bola. (Pierde Raqueta B).
		mov			dh,Rbf		;Escribe Raqueta B.
		mov			dl,Rbc
		call		WRaq
		inc			Col
		inc			pelota_columna			;Incrementando Columna.
		mov			al,Dfil		;Reviso Dirección de Movimiento de la Bola.
		cmp			al,0
		jne			Posf1
		add			Fil,2
		add			pelota_fila,2		;Ajuste de Fila para Mostrar Final de Bola.
Posf1:	sub			pelota_fila,1
		sub			Fil,1
		call		Wball
		call		DibujarPelota
		mov			edx,OFFSET TgoJA
		jmp			Final
		
GameO2: call		Borra_pelota		;Borro la Bola. (Pierde Raqueta A).
		mov			dh,Raf		;Escribe Raqueta A.
		mov			dl,Rac
		call		WRaq
		dec			pelota_columna			;Decrementando Columna.
		mov			al,Dfil		;Reviso Dirección de Movimiento de la Bola.
		cmp			al,0
		jne			Posf2
		add			Fil,2
		add			pelota_fila,2		;Ajuste de Fila para Mostrar Final de Bola.
Posf2:	sub			pelota_fila,1
		sub			Fil,1
		call		Wball
		call		DibujarPelota
		mov			edx,OFFSET TgoJB
		jmp			Final
		
Final:	mov			ebx,OFFSET TBox	 ;Muestra Ventaja de Game Over.
		call		MsgBox
		mov			edx,OFFSET TgoVJ ;Muestra Ventana de Volver a Jugar.
		call		MsgBoxAsk
		cmp			eax,6			 ;Si valor retornado en EAX no es 6,
		jne			Fout			 ;se sale del juego.
		call		CRaq
		call		Borra_pelota			 ;Borra Bola de Posición Actual.
		mov			dh,Raf			 ;Borro Raqueta A posición Actual.
		mov			dl,Rac
		call		CRaq
		mov			dh,Rbf			 ;Borro Raqueta B posición Actual.
		mov			dl,Rbc
		call		CRaq
		call		Inivar			 ;Preparando nuevo juego. Inicializar Variables.
		jmp			Inicio			 ;Salta a juego nuevo.

Fout:	exit


		
main	ENDP

;*************************************************************************************************
; PROCEDIMIENTO INIVAR - Inicializa Variables.
;*************************************************************************************************

Inivar	PROC

		mov			pelota_columna,1		;Inicializa Columna de Bola.
		mov			pelota_fila,10		;Inicializa Fila de Bola.
		mov			Dcol,0		;Inicializa Dirección Avance Columna de Bola.
		mov			Dfil,0		;Inicializa Dirección Avance Fila de Bola.
		mov			DcolB,1	;Dirección Columna. (0 = Derecha, 1 = Izquierda).
		mov      	DfilB,1	;Dirección Fsila. (0 = Abajo, 1 = Arriba).
	
		mov			Raf,10		;Inicializa Fila de Raqueta A.
		mov			Rac,0		;Inicializa Columna de Raqueta A.
		mov			Rbf,10		;Inicializa Fila de Raqueta B.
		mov			Rbc,0		;Inicializa Columna de Raqueta B.
		mov			hayDosBolas,0 ;Inicializa la variable	
		RET						;Retorno de Procedimiento.

Inivar	ENDP

;*************************************************************************************************
; PROCEDIMIENTO WJUGA - Escribe Identificadores para Jugadores A y B
;*************************************************************************************************

Wjuga	PROC

		mov			eax,yellow + (black *16)
		call		SetTextColor
		mov			dh,0
		mov			dl,4
		call		Gotoxy
		mov			al,'A'
		call		WriteChar
		mov			dl,Maxc
		sub			dl,3
		call		Gotoxy
		mov			al,'B'
		call		WriteChar
		mov			eax,white + (black *16)
		call		SetTextColor
	
		RET						;Retorno de Procedimiento.

Wjuga	ENDP


;*************************************************************************************************
; PROCEDIMIENTO WRAQ - Escribe Raqueta (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************

WRaq	PROC
		
		mov			ebx,4		;Contador.
		mov			al,'X'		;Caracter.
WRaqc:	call		Gotoxy		;Posicionar Cursor.
		call		WriteChar	;Escribir Caracter.
		inc			dh			;Incrementar Columna.
		dec			ebx			;Decrementar Contador.
		jnz			Wraqc		;Si no es cero, salto a ciclo de raqueta.
		
		RET						;Retorno de Procedimiento.

Wraq	ENDP






;*************************************************************************************************
; PROCEDIMIENTO CRAQ - Borra Raqueta (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************

Craq	PROC

		mov			ebx,4		;Contador.
		mov			al,' '		;Caracter.
CRaqc:	call		Gotoxy		;Posicionar Cursor.
		call		WriteChar	;Escribir Caracter.
		inc			dh			;Incrementar Columna.
		dec			ebx			;Decrementar Contador.
		jnz			Craqc		;Si no es cero, salto a ciclo de raqueta.
		
		RET						;Retorno de Procedimiento.

Craq	ENDP

;*************************************************************************************************
; PROCEDIMIENTO WLIN - Escribe Línea de Caracteres (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************

WLin	PROC
		
		mov			eax,green + (black * 16)
		call		SetTextColor
		mov			ebx,0		;Contador en 32 bis.
		mov			bl,Maxc
		add			bl,2
		mov			al,'*'		;Caracter.
WLinc:	call		Gotoxy		;Posicionar Cursor.
		call		WriteChar	;Escribir Caracter.
		inc			dl			;Incrementar Columna.
		dec			ebx			;Decrementar Contador.
		jnz			WLinc		;Si no es cero, salto a ciclo de linea.
		mov			eax,white + (black * 16)
		call		SetTextColor
		
		RET						;Retorno de Procedimiento.

WLin	ENDP



;*************************************************************************************************
; PROCEDIMIENTO Borrar_pelota - Escribe Línea de Caracteres (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************
   
Borra_pelota PROC
        mov     eax,white + (black * 16)
        call    SetTextColor
        mov     dh,pelota_fila                       ;Se pasa la Fila
        mov     dl,pelota_columna                    ;Se pasa la Columna
        call    GotoXY                              ;Posiciona cursor en (Auto1_fila,Auto1_columna)
        mov     ecx,OFFSET Bpelota_parte1             ;Dibujar Auto1 (por segmentos)
        call    Dibujar_pelotaXpartes
        RET
Borra_pelota ENDP



;*************************************************************************************************
; PROCEDIMIENTO Dibujar_pelota - Escribe Línea de Caracteres (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************
   
   
DibujarPelota PROC
        mov     eax,yellow + (black * 16)
        call    SetTextColor
        mov     dh,pelota_fila                       ;Se pasa la Fila
        mov     dl,pelota_columna                    ;Se pasa la Columna
        call    GotoXY                              ;Posiciona cursor en (Auto1_fila,Auto1_columna)
        mov     ecx,OFFSET pelota_parte1             ;Dibujar Auto1 (por segmentos)
        call    Dibujar_PelotaXpartes
        RET
DibujarPelota ENDP

;*************************************************************************************************
; PROCEDIMIENTO Dibujar_pelotaXpartes - Escribe Línea de Caracteres (Parámetros: Dh --> Fila y Dl --> Columna)
;*************************************************************************************************
 

Dibujar_PelotaXpartes PROC
        mov     eax,white + (black * 16)
        call    SetTextColor
        mov     pelota_fila,dh                           ;Guarda cordenadas seleccionadas
        mov     pelota_columna,dl
        call    GetMaxXY                                ;Toma tamaño de la consola
        mov     Fila_maxima,al
        mov     Columna_max,dl
        cmp     al,pelota_fila                           ;se compara si coordenadas son calidas
        jl			GoOut
        cmp     dl,pelota_columna
        jl      GoOut
        mov     dh,pelota_fila                           ;Posicion inicial del cursor
        mov     dl,pelota_columna

        call    GotoXY                                  ;Posicionando el cursor
        push    edx                                     ;guarda edxen la pila
        mov     edx,ecx                                 ;Escribiendo linea 1 del auto1
        call    writeString
        pop     edx                                     ;Sacando edx de la pila

        inc			dh									; Ajustando Fila y Reposicionando.    ;esto mismo en los siguientes
		add			ecx,5								; Paso a Siguiente Fila.
		call		GotoXY
		push		edx									; Guardando EDX en la Pila.
		mov			edx, ecx							; Escribiendo Línea.
		call		WriteString
		pop			edx									; Sacando EDX de la Pila.


        inc			dh									
		add			ecx,5								
		call		GotoXY
		push		edx									
		mov			edx, ecx							
		call		WriteString
		pop			edx									


GoOut:	nop							; No operación.

    RET
Dibujar_PelotaXpartes ENDP



;*************************************************************************************************
; PROCEDIMIENTO WBALL - Escribe la Bola
;*************************************************************************************************

Wball	PROC

		mov			hayDosBolas,1 ;Asigna uno para que solo se cree una bola
		mov			eax,red + (black * 16)
		call		SetTextColor
		mov			dh,Fil		;Se pasa la Fila.
		mov			dl,Col		;Se pasa la Columna.
		call		Gotoxy		;Posiciona Cursor en (FilB,ColB).
		mov			al,Ball		;Escribe un '0'.
		call		WriteChar
	
	
		
		RET						;Retorno de Procedimiento.

Wball	ENDP

;*************************************************************************************************
; PROCEDIMIENTO CBALL - Borra la Bola
;*************************************************************************************************

Cball	PROC

		mov			dh,Fil		;Se pasa la Fila.
		mov			dl,Col		;Se pasa la Columna.
		call		Gotoxy		;Posiciona Cursor en (FilB,ColB).
		mov			al,' '		;Escribe un ' '.
		call		WriteChar
		
		RET						;Retorno de Procedimiento.

Cball	ENDP


		END
