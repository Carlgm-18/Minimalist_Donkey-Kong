*------------------------------------------------------------------------------
* En este archivo estarán todas las funciones relacionadas con el sistema:
* Como el teclado, el ratón y la pantalla
*------------------------------------------------------------------------------

; TECLAS PULSADAS
KBDVAL		DS.B 	1 	; ESTADO
KBDEDGE 	DS.B 	1
			DS.W 	0
; CLICKS Y POSICIÓN DEL RATÓN
MOUSVAL     DS.B    1   ; ESTADO
            DS.W    0
MOUSPOS     DS.L    1   ; POSICIÓN

; -----------------------------------------------------------------------------
SYSINIT:
; Inicializa el sistema
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
		JSR		SCRINIT
        JSR     KBDINIT
        JSR     MOUSINIT

		; Avtivamos los traps	($80 + TRAP * 4)
		MOVE.L	#SCRUPD, ($80)		; Trap #0 Refresca la pantalla
        MOVE.L	#KBDUPD, ($80 + 4)	; Trap #1 Actualiza los datos del teclado
        MOVE.L	#MOUSUPD,($80 + 8)	; Trap #2 Actualiza los datos del ratón

		MOVE.W  SR,-(A7)
		ANDI.W  #$D8FF,(A7)
		RTE
; -----------------------------------------------------------------------------
SCRINIT:
; Inicializa la pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
		MOVEM.L	D0/D1, -(A7)
		; Resolución de pantalla
		MOVE.B	#33, D0
		MOVE.L	#SCRWIDTH<<16|SCRHEIGT, D1
		TRAP	#15

		; Modo ventana
		MOVE.L  #1,D1
		TRAP    #15

		; Limpiar pantalla
		MOVE.B  #11,D0
		MOVE.W  #$FF00,D1
		TRAP    #15
		
		; Activamos doble-buffer
		MOVE.B  #92,D0
		MOVE.B  #17,D1
		TRAP    #15

		MOVEM.L	(A7)+, D0/D1
		RTS

; -----------------------------------------------------------------------------
SCRUPD:
; Cambia el buffer activo que se muestra en la pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
		MOVEM.L	D0/D1, -(A7)

		; Permute the buffers
		MOVE.B	#94,D0
		TRAP	#15

		; Clear hidden buffer
		MOVE.B  #11,D0
		MOVE.W  #$FF00,D1
		TRAP    #15

		MOVEM.L	(A7)+, D0/D1
		RTE

; -----------------------------------------------------------------------------
KBDINIT
; Inicializa la interacción con el teclado
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        CLR.B 	(KBDVAL)
        CLR.B 	(KBDEDGE)
        RTS

; -----------------------------------------------------------------------------
KBDUPD
; Lee las teclas pulsadas
; 3 -> SPACE
; 2 -> A
; 1 -> S
; 0 -> ESC
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
		
        MOVEM.L 	D0-D3, -(A7)
		CLR.L 		D2
		
		; Leemos las teclas
		MOVE.B 		#19, D0
		MOVE.L 		#KEYSPACE<<24|KEYA<<16|KEYD<<8|KEYS, D1
		TRAP 		#15

		; Simplificamos la informacion
		JSR 		.PACK
        
		; Actualizamos KBDEDGE
		MOVE.B 		(KBDVAL), D0
		NOT.B 		D0
		AND.B 		D2, D0
		MOVE.B 		D0, (KBDEDGE)

		; Actualizamos KBDVAL
		MOVE.B 		D2, (KBDVAL)

        MOVEM.L 	(A7)+, D0-D3
        RTE

.PACK
		MOVE.W  	#3, D3
.LOOP   LSL.L   	#8, D1
        ROXL.B  	#1, D2
        DBRA.W  	D3, .LOOP
		RTS

; -----------------------------------------------------------------------------
MOUSINIT
; Inicializa la interacción con el ratón
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        CLR.B 	(MOUSVAL)
        CLR.L   (MOUSPOS)
        RTS

; -----------------------------------------------------------------------------
MOUSUPD
; Lee los valores del ratón
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

        MOVEM.L D0-D1, -(A7)

        MOVE.B  #61, D0
        MOVE.B  #0, D1
        TRAP    #15

        MOVE.B  D0, (MOUSVAL)
        MOVE.L  D1, (MOUSPOS)

        MOVEM.L (A7)+, D0-D1
        RTE

; -----------------------------------------------------------------------------
IMGPLOT
; Muestra un sprite por pantalla
; INPUT    - A0: Dirección del array que representa el sprite
; 			 D6.W: Coordenada X del objeto
; 			 D2.W: Coordenada Y del objeto 	
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

		        MOVEM.L     D0-D6, -(A7)
				
                MOVE.L      #0, D3
                ADDI.W      #CHKSIZE/2, D6
                SUBI.W      #CHKSIZE/2, D2

                MOVEQ.L     #CHKSIZE-1, D5

.RLOOP          
                MOVEQ.L     #CHKSIZE-1, D4
                SUBI.W      #CHKSIZE, D6

.CLOOP          
                MOVE.L      (A0)+, D1
                TST.L       D1
                BEQ         .NOTPLOT       
                CMP.L       D3, D1
                BEQ         .NOCHCOL
                MOVE.B      #80, D0
                TRAP        #15
                MOVE.L      D1, D3

.NOCHCOL
                MOVE.B      #82, D0
                MOVE.W      D6, D1
                TRAP        #15
.NOTPLOT        
                ADDQ.W      #1, D6
                DBRA        D4, .CLOOP

                ADDQ.W      #1, D2
                DBRA        D5, .RLOOP

                MOVEM.L     (A7)+, D0-D6
                
                RTS

*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
