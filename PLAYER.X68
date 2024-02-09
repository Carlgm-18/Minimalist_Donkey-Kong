*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con el jugador
*------------------------------------------------------------------------------

GRAVITY     EQU     1
LIMLEFT     EQU     4*CHKSIZE+CHKSIZE/2
LIMUP       EQU     4*CHKSIZE
PLYVELX     EQU     3
INIPOSX     EQU     6*CHKSIZE
INIPOSY     EQU     SCRHEIGT-3*CHKSIZE/2

LIVES       DC.B    INILIVES
GROUND      DS.B    1
FLOOR       DS.B    1
BARCOL      DS.B    1
PLYDIR      DS.B    1
WIN         DS.B    1
            DS.W    0
IMGSPLY     DC.L    IMGPLYL, IMGPLYR

MAXJUMP     DS.W    1
PLYPOSX     DS.W    1
PLYPOSY     DS.W    1
PLYVELY     DS.W    1


; -----------------------------------------------------------------------------
PLYINIT
; Inicializa el estado del jugador
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVE.W      #INIPOSX, (PLYPOSX)
                MOVE.W      #INIPOSY, (PLYPOSY)
                CLR.W       (PLYVELY)
                CLR.B       (FLOOR)
                CLR.B       (BARCOL)
                CLR.B       (PLYDIR)
                CLR.B       (WIN)
                MOVE.W      #-11, (MAXJUMP)

                RTS

; -----------------------------------------------------------------------------
PLYUPDT
; Actualiza el estado del jugador
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVEM.W         D0-D6/A0, -(A7)

                MOVE.W          (PLYPOSX), D0
                MOVE.W          (PLYPOSY), D1
                MOVE.W          (PLYVELY), D5
                MOVE.B          (FLOOR), D6

                ; ¿Mover izquierda?
                BTST.B          #2, (KBDVAL)
                BEQ             .NO_LEFT
                SUBQ.W          #PLYVELX, D0
                MOVE.B          #0, (PLYDIR)

.NO_LEFT        
                ; ¿Mover derecha?
                BTST.B          #1, (KBDVAL)
                BEQ             .NO_RIGT
                ADDQ.W          #PLYVELX, D0
                MOVE.B          #1, (PLYDIR)

.NO_RIGT
                ; ¿Salto?
                TST.B           D6
                BEQ             .NO_JUMP
                BTST.B          #3, (KBDEDGE)
                BEQ             .NO_JUMP
                MOVE.W          (MAXJUMP), D5
                EXT.W           D6
                SUB.W           D6, D5

.NO_JUMP
                ; Combrobar colisión lado derecho
                ; de la pantalla
                CMP.W           #SCRWIDTH-CHKSIZE/2, D0
                BLT             .NORCOL
                MOVE.W          #SCRWIDTH-CHKSIZE/2, D0
                
.NORCOL
                ; Combrobar colisión lado izquierdo
                ; de la pantalla
                CMP.W           #LIMLEFT, D0
                BGT             .NOLCOL
                MOVE.W          #LIMLEFT, D0
                CMP.W           #LIMUP, D1
                BGT             .NOLCOL
                MOVE.B          #1, (WIN)

.NOLCOL       
                ; Comprobar posición Y del jugador
                ; si está por debajo del último CHUNK
                ; dejamos de comprobar el mapa
                CMP.W           #SCRHEIGT-CHKSIZE, D1
                BGT             .NOSCOL

                ; Si queremos saltar, no comprobamos el mapa
                ; y fijamos que no lo tocamos
                BTST.B          #3, (KBDEDGE)
                BEQ             .CHEKMAP
                MOVE.B          #0, (FLOOR)
                BRA             .NOSCOL

.CHEKMAP        
                ; Comprobamos colisión con el mapa
                MOVE.W          D0, D2
                MOVE.W          D1, D3
                ADDI.W          #CHKSIZE/2, D3
                DIVU            #CHKSIZE, D3
                ANDI.L          #$FFFF0000, D3
                BNE             .NOSCOL

                MOVE.W          D0, D2
                MOVE.W          D1, D3

                LSR.W           #5, D2
                LSR.W           #5, D3
                MOVE.W          D3, D4
                ADDQ.W          #1, D3

                MULU.W          #CHKWIDTH, D3
                ADD.W           D2, D3
                MOVEA.W         D3, A0
                MOVE.B          MAP(A0), (FLOOR)

.NOSCOL
                ; Comprobamos colisión con el barril
                TST.B           (BARCOL)
                BEQ             .NOBRCOL
                CLR.B           (BARCOL)
                SUB.B           #1, (LIVES)
                MOVE.W          #INIPOSX, D0
                MOVE.W          #INIPOSY, D1
                MOVEQ.L         #0, D5
                MOVE.B          #0, (FLOOR)
                BRA             .DONE
.NOBRCOL
                ; Actualizar velocidad y posiciones
                TST.B           (FLOOR)
                BNE             .NO_FLOR
                CMP.W           #1, D5
                BGE             .NO_FLOR
                ADDQ.W          #GRAVITY, D5

.NO_FLOR
                TST.B           (FLOOR)
                BEQ             .FALL
.NOT_FAL
                MOVEQ.L         #0, D5
.FALL           
                ADD.W           D5, D1

.DONE           
                MOVE.W          D0, (PLYPOSX)
                MOVE.W          D1, (PLYPOSY)
                MOVE.W          D5, (PLYVELY)

                MOVEM.W         (A7)+, D0-D6/A0

                RTS

; -----------------------------------------------------------------------------
PLYPLOT
; Muestra el jugador por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

                MOVEM.L     D0/D2/D6/A0-A1, -(A7)

                TST.B       (PLYDIR)
                BEQ         .IMGL
                LEA         IMGPLYR, A0
                BRA         .PRINT

.IMGL           LEA         IMGPLYL, A0


.PRINT          MOVE.W      (PLYPOSX), D6
                MOVE.W      (PLYPOSY), D2
                JSR         IMGPLOT

                MOVEM.L     (A7)+, D0/D2/D6/A0-A1
                
                RTS

*~Font name~Courier New~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
