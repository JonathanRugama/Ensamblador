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
Col		byte		1		;Columna de Bola.
Fil		byte		10		;Fila de Bola.
Maxc	byte		0		;Columna Máxima.
Maxf	byte		0		;Fila Máxima.
Dcol	byte		0		;Dirección Columna. (0 = Derecha, 1 = Izquierda).
Dfil	byte		0		;Dirección Fila. (0 = Abajo, 1 = Arriba).
Raf		byte		10		;Fila de Raqueta A.
Rac		byte		0		;Columna Raqueta A.
Rbf		byte		10		;Fila de Raqueta B.
Rbc		byte		0		;Columna Raqueta B.

		.code

;*************************************************************************************************
; FUNCIÓN MAIN                                                                                   *
;*************************************************************************************************

main	PROC

Inicio: call		GetMaxXY	;Toma el Tamaño Actual de la Ventana de Consola.
		mov			Maxc,dl
		mov			Rbc,dl
		mov			Maxf,23
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

Ciclo:	call		Wball		;Escribe la Bola.
		mov			dh,Raf		;Escribe Raqueta A.
		mov			dl,Rac
		call		WRaq
		mov			dh,Rbf		;Escribe Raqueta B.
		mov			dl,Rbc
		call		WRaq
		mov			eax,10	;Espera de 200 ms (0.2 s).      
		call		Delay
		call		CBall		;Borra la Bola.
		
		
		call		ReadKey		;Revisa el Teclado.
		jz			Ccol		;Si no hay tecla, salto a Control Columna.
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

Cdown:	mov			al,Col		;Columna se Incrementa
		cmp			al,Maxc
		jnl			CDcol1
		inc			Col
		jmp			Cfil

Cup:	cmp			Col,1
		jng			CDcol2
		dec			Col
		jmp			Cfil

CDcol1:	mov			al,Rbf		;Reviso si hay choque con Raqueta B.
		cmp			al,Fil 
	
		
		add			al,3
		cmp			al,Fil
		
		mov			Dcol,1		;Cambia Dirección de Movimiento en Columna.
		jmp			Cfil

CDcol2:	mov			al,Raf		;Reviso si hay choque con Raqueta A.
		cmp			al,Fil 
		
		
		add			al,3
		cmp			al,Fil
	
		mov			Dcol,0		;Vuelve cursor a inicio de fila.
	    
		jmp			Cfil

Cfil:	cmp			Dfil,0		;Reviso Dirección de Movimiento en Fila.
        
		jne			Fup

Fdown:	mov			al,Fil		;Columna se Incrementa
		cmp			al,Maxf
		jnl			CDfil1
		inc			Fil
		jmp			Ciclo

Aball:  sub         eax,20  
		jmp			Ciclo
         
Fup:	cmp			Fil,1
		jng			CDfil2
		dec			Fil
		jmp			Ciclo

CDfil1:	mov			Dfil,1		;Cambia Dirección de Movimiento en Fila.
		jmp			Ciclo

CDfil2:	mov			Dfil,0		;Vuelve cursor a inicio de fila.
		jmp			Ciclo

GameO1: call		CBall		;Borro la Bola. (Pierde Raqueta B).
		mov			dh,Rbf		;Escribe Raqueta B.
		mov			dl,Rbc
		call		WRaq
		inc			Col			;Incrementando Columna.
		mov			al,Dfil		;Reviso Dirección de Movimiento de la Bola.
		cmp			al,0
		jne			Posf1
		add			Fil,2		;Ajuste de Fila para Mostrar Final de Bola.
Posf1:	sub			Fil,1
		call		WBall
		mov			edx,OFFSET TgoJA
		jmp			Final
		
GameO2: call		CBall		;Borro la Bola. (Pierde Raqueta A).
		mov			dh,Raf		;Escribe Raqueta A.
		mov			dl,Rac
		call		WRaq
		dec			Col			;Decrementando Columna.
		mov			al,Dfil		;Reviso Dirección de Movimiento de la Bola.
		cmp			al,0
		jne			Posf2
		add			Fil,2		;Ajuste de Fila para Mostrar Final de Bola.
Posf2:	sub			Fil,1
		call		WBall
		mov			edx,OFFSET TgoJB
		jmp			Final
		
Final:	mov			ebx,OFFSET TBox	 ;Muestra Ventaja de Game Over.
		call		MsgBox
		mov			edx,OFFSET TgoVJ ;Muestra Ventana de Volver a Jugar.
		call		MsgBoxAsk
		cmp			eax,6			 ;Si valor retornado en EAX no es 6,
		jne			Fout			 ;se sale del juego.
		call		CBall			 ;Borra Bola de Posición Actual.
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

		mov			Col,1		;Inicializa Columna de Bola.
		mov			Fil,10		;Inicializa Fila de Bola.
		mov			Dcol,0		;Inicializa Dirección Avance Columna de Bola.
		mov			Dfil,0		;Inicializa Dirección Avance Fila de Bola.
		mov			Raf,10		;Inicializa Fila de Raqueta A.
		mov			Rac,0		;Inicializa Columna de Raqueta A.
		mov			Rbf,10		;Inicializa Fila de Raqueta B.
		mov			Rbc,0		;Inicializa Columna de Raqueta B.
	
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
; PROCEDIMIENTO WBALL - Escribe la Bola
;*************************************************************************************************

Wball	PROC

		mov			eax,yellow + (black * 16)
		call		SetTextColor
		mov			dh,Fil		;Se pasa la Fila.
		mov			dl,Col		;Se pasa la Columna.
		call		Gotoxy		;Posiciona Cursor en (Fil,Col).
		mov			al,Ball		;Escribe un '0'.
		call		WriteChar
		mov			eax,white + (black * 16)
		call		SetTextColor
		
		RET						;Retorno de Procedimiento.

Wball	ENDP

;*************************************************************************************************
;PROCEDMIENTO ABALL- Acelera la bola
;*************************************************************************************************

Aball   PROC

        sub			eax,20	;Espera de 200 ms (0.2 s).      
	
		
		
		RET

Aball	ENDP
;*************************************************************************************************
; PROCEDIMIENTO CBALL - Borra la Bola
;*************************************************************************************************

Cball	PROC

		mov			dh,Fil		;Se pasa la Fila.
		mov			dl,Col		;Se pasa la Columna.
		call		Gotoxy		;Posiciona Cursor en (Fil,Col).
		mov			al,' '		;Escribe un ' '.
		call		WriteChar
		
		RET						;Retorno de Procedimiento.

Cball	ENDP

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


		END