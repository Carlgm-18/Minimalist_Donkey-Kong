*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con la pantalla
* de fin de partida
*------------------------------------------------------------------------------

WINMSG      DC.B    'YOU WIN!', 0
LOSTMSG     DC.B    'YOU LOSS!', 0
TMSG        DC.B    'YOUR TIME: ', 0
ATMSG       DC.B    'LAST TIME: ', 0
FILE        DC.B    'LASTTIME', 0
            DS.W    0
DEFVALUE    DC.L    0
LASTIME     DS.L    1

; -----------------------------------------------------------------------------
LOSTPLOT
; Muestra el enemigo por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L     D0-D2/A1, -(A7)

            MOVE.B      #21, D0
            MOVE.L      #$00FFFFFF, D1
            MOVE.L      #$03360000, D2
            TRAP        #15
            
            MOVE.B      #11, D0
            MOVE.W      #$0305, D1
            TRAP        #15

            LEA         LOSTMSG, A1
            MOVE.B      #14, D0
            TRAP        #15

            MOVEM.L     (A7)+, D0-D2/A1
            RTS


; -----------------------------------------------------------------------------
WINPLOT
; Muestra el enemigo por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L     D0-D2/A1, -(A7)
            
            ; ARCHIVOS
            MOVE.B      #51, D0
            LEA         FILE, A1
            TRAP        #15

            CMP.B       #2, D0
            BNE         .CONT
            MOVE.B      #52, D0
            TRAP        #15

            MOVE.B      #54, D0
            LEA         DEFVALUE, A1
            MOVE.L      #4, D2
            TRAP        #15

            MOVE.B      #50, D0
            TRAP        #15

            MOVE.B      #51, D0
            LEA         FILE, A1
            TRAP        #15
.CONT
            MOVE.B      #53, D0
            LEA         LASTIME, A1
            MOVE.L      #4, D2
            TRAP        #15

            MOVE.B      #54, D0
            LEA         TIMEPASS, A1
            MOVE.L      #4, D2
            TRAP        #15

            MOVE.B      #50, D0
            TRAP        #15

            ; Felicitacion
            MOVE.B      #21, D0
            MOVE.L      #$00FFFFFF, D1
            MOVE.L      #$03360000, D2
            TRAP        #15
            
            MOVE.B      #11, D0
            MOVE.W      #$0304, D1
            TRAP        #15

            LEA         WINMSG, A1
            MOVE.B      #14, D0
            TRAP        #15

            ; Info partida
            MOVE.B      #21, D0
            MOVE.L      #$00FFFFFF, D1
            MOVE.L      #$03240000, D2
            TRAP        #15
            
            MOVE.B      #11, D0
            MOVE.W      #$040C, D1
            TRAP        #15

            LEA         TMSG, A1
            MOVE.L      (TIMEPASS), D1
            MOVE.B      #17, D0
            TRAP        #15
            
            MOVE.B      #11, D0
            MOVE.W      #$040F, D1
            TRAP        #15

            LEA         ATMSG, A1
            MOVE.L      (LASTIME), D1
            MOVE.B      #17, D0
            TRAP        #15
            
            MOVEM.L     (A7)+, D0-D2/A1
            RTS

*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
