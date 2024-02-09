*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con barriles
*------------------------------------------------------------------------------

NBARS           EQU     4       ; Número de barriles
BRVEL           EQU     3

; Rango de actuación
LLIM            EQU     4*CHKSIZE+CHKSIZE/2
RLIM            EQU     SCRWIDTH-CHKSIZE/2

; Posiciones iniciales
BRSINITX        DC.W    RLIM, LLIM, RLIM, LLIM

BRSINITY        DC.W    10*CHKSIZE-CHKSIZE/2, 14*CHKSIZE-CHKSIZE/2
                DC.W    18*CHKSIZE-CHKSIZE/2, 22*CHKSIZE-CHKSIZE/2

BRSPOSX         DS.W    NBARS
BRSPOSY         DS.W    NBARS
BRSVEL          DC.W    -BRVEL, BRVEL, -BRVEL, BRVEL
BARSCOL         DS.W    NBARS
                DS.W    0
; -----------------------------------------------------------------------------
BRINIT
; Inicializa el estado del barril
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVEM.L     D0/A0, -(A7) 
                
                MOVE.W      #NBARS-1, D0
                MOVEA       #0, A0

.LOOP           MOVE.W      BRSINITX(A0), BRSPOSX(A0)
                MOVE.W      BRSINITY(A0), BRSPOSY(A0)
                CLR.W       BARSCOL(A0)
                ADDQ.L      #2, A0
                DBRA        D0, .LOOP

                MOVEM.L     (A7)+, D0/A0

                RTS

; -----------------------------------------------------------------------------
BRUPDT
; Actualiza el estado del barril
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVEM.W     D0-D7/A0, -(A7)

                MOVE.W      #NBARS-1, D5
                MOVEA       #0, A0

.LOOP           MOVE.W      BRSPOSX(A0), D0
                MOVE.W      BRSPOSY(A0), D1
                MOVE.W      BARSCOL(A0), D6
                ADD.W       BRSVEL(A0), D0

                ; Combrobar que están dentro de rango, si no lo está
                ; reiniciamos el recorrido
                CMP.W       #RLIM, D0
                BGT         .NORANGE
                CMP.W       #LLIM, D0
                BLT         .NORANGE
                BRA         .INRANGE
.NORANGE
                MOVE.W      BRSINITX(A0), D0

.INRANGE
            ; Colisión con el jugador
            ; Seguimos el siguiente esquema de condiciones
            ; If( PLYPOSX - CHKSIZE/2 > BRPOSX + CHKSIZE/2 ) -> No colisión
            ; If( PLYPOSX + CHKSIZE/2 < BRPOSX - CHKSIZE/2 ) -> No colisión
            ; If( PLYPOSY - CHKSIZE/2 > BRPOSY + CHKSIZE/2 ) -> No colisión
            ; If( PLYPOSY + CHKSIZE/2 < BRPOSY - CHKSIZE/2 ) -> No colisión
            ; Else -> Colisión
                MOVE.W      D0, D2
                MOVE.W      D1, D7
                MOVE.W      (PLYPOSX), D3
                MOVE.W      (PLYPOSY), D4

                ADD.W       #CHKSIZE/2, D2
                SUB.W       #CHKSIZE/2, D3
                CMP.W       D2, D3
                BGT         .NOPLCOL

                SUB.W       #CHKSIZE, D2
                ADD.W       #CHKSIZE, D3
                CMP.W       D2, D3
                BLT         .NOPLCOL

                SUB.W       #CHKSIZE/2, D4
                ADD.W       #CHKSIZE/2, D7
                CMP.W       D7, D4
                BGT         .NOPLCOL

                ADD.W       #CHKSIZE, D4
                SUB.W       #CHKSIZE, D7
                CMP.W       D7, D4
                BLT         .NOPLCOL

                MOVE.W      #1, D6      ; Hay colisión
                BRA         .DONE
.NOPLCOL
                MOVE.W      #0, D6      ; No hay colisión

.DONE
                MOVE.W      D0, BRSPOSX(A0)
                MOVE.W      D1, BRSPOSY(A0)
                MOVE.W      D6, BARSCOL(A0)
                OR.B        D6, (BARCOL)
                ADDQ.L      #2, A0
                DBRA        D5, .LOOP

                MOVEM.W     (A7)+, D0-D7/A0
                RTS

; -----------------------------------------------------------------------------
BRPLOT
; muestra el barril por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVEM.L     D0-D5, -(A7)

                CLR.L       D0
                CLR.L       D1
                CLR.L       D2
                CLR.L       D3
                CLR.L       D4

                ; SET PEN COLOR
                MOVE.B      #80, D0
                MOVE.L      #$00004080, D1
                TRAP        #15
                ; SET FILL COLOR
                MOVE.B      #81, D0
                MOVE.L      #$00004080, D1
                TRAP        #15

                MOVEA       #0, A0
                MOVE.W      #NBARS-1, D5
                MOVE.B      #88, D0

.LOOP           MOVE.W      BRSPOSX(A0), D1
                MOVE.W      BRSPOSY(A0), D2

                SUB.W       #CHKSIZE/2, D1
                SUB.W       #CHKSIZE/2, D2

                MOVE.W      D1, D3
                MOVE.W      D2, D4

                ADDI.W      #CHKSIZE, D3
                ADDI.W      #CHKSIZE, D4

                TRAP        #15

                ADDQ.L      #2, A0
                DBRA        D5, .LOOP

                MOVEM.L     (A7)+, D0-D5

                RTS