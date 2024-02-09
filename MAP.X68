*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con el mapa
*------------------------------------------------------------------------------

SJUMPX      DC.W    15*CHKSIZE, 5*CHKSIZE, 15*CHKSIZE, 5*CHKSIZE, 15*CHKSIZE
SJUMPY      DC.W    10*CHKSIZE, 14*CHKSIZE, 18*CHKSIZE, 22*CHKSIZE, 26*CHKSIZE
SJHEIGT     EQU     CHKSIZE
SJWIDTH     EQU     4*CHKSIZE

MAP
            DC.B    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    0, 0, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 6, 6, 6, 6, 1
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 1, 6, 6, 6, 6, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 6, 6, 6, 6, 1
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 1, 6, 6, 6, 6, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
            DC.B    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 6, 6, 1
            DS.W    0


; -----------------------------------------------------------------------------
MAPPLOT
; Dibuja el mapa mediante un vector de valores
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------

            MOVEM.L     D0-D7/A0, -(A7)
            
            MOVE.B      #93, D0
            MOVE.B      #1, D1
            TRAP        #15

            CLR.L       D2
            MOVE.W      #CHKSIZE, D4
            MOVE.W      #CHKHEIGT-1, D6

            LEA         MAP, A0

.RLOOP      CLR.L       D1
            MOVE.W      #CHKSIZE, D3
            MOVE.W      #CHKWIDTH-1, D5

.CLOOP      TST.B       (A0)+
            BEQ         .NOTPLOT

            MOVE.W      D1, D7

            ; Pintar cuadrado exterior
            MOVE.B      #80, D0
            MOVE.L      #REDCOL, D1
            TRAP        #15

            MOVE.B      #81, D0
            TRAP        #15

            MOVE.W      D7, D1

            MOVE.B      #87, D0
            TRAP        #15

            ; Pintar cuadrado interior
            MOVE.W      D1, D7
            MOVE.B      #80, D0
            MOVE.L      #SREDCOL, D1
            TRAP        #15

            MOVE.B      #81, D0
            TRAP        #15

            MOVE.B      #87, D0
            MOVE.W      D7, D1

            ADDQ.W      #5, D1
            ADDQ.W      #5, D2
            SUBQ.W      #5, D3
            SUBQ.W      #5, D4

            TRAP        #15

            SUBQ.W      #5, D1
            SUBQ.W      #5, D2
            ADDQ.W      #5, D3
            ADDQ.W      #5, D4

.NOTPLOT    MOVE.W      D3, D1
            ADDI.W      #CHKSIZE, D3
            DBRA        D5, .CLOOP

            MOVE.W      D4, D2
            ADDI.W      #CHKSIZE, D4
            DBRA        D6, .RLOOP

            ; Pintar zonas de supersalto
            MOVE.B      #80, D0
            MOVE.L      #BLUECOL, D1
            TRAP        #15

            MOVE.B      #81, D0
            TRAP        #15

            MOVE.B      #87, D0
            MOVEA       #0, A0
            MOVE.W      #4, D5

.LOOP       MOVE.W      SJUMPX(A0), D1
            MOVE.W      SJUMPY(A0), D2
            MOVE.W      D1, D3
            MOVE.W      D2, D4

            ADD.W       #SJWIDTH, D3
            ADD.W       #SJHEIGT, D4
            TRAP        #15

            ADDQ.L      #2, A0
            DBRA        D5, .LOOP

            MOVEM.L     (A7)+, D0-D7/A0

            RTS

*~Font name~Courier New~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~