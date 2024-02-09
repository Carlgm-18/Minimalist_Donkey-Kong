*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con los banners que aparecen
* durante la partida
*------------------------------------------------------------------------------

LIVEMSG     DC.B    'LIVES: ', 0
OVERMSG     DC.B    'GAME OVER!', 0
TIMEMSG     DC.B    'TIME: ', 0
            DS.W    0



; -----------------------------------------------------------------------------
INFOPLOT
; Muestra el enemigo por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L     D0-D1/A1, -(A7)
 
            MOVE.B      #21, D0
            MOVE.L      #$00FFFFFF, D1
            MOVE.L      #$030C0000, D2
            TRAP        #15

            ; Fijamos color de fondo
            MOVE.B      #81, D0
            MOVE.L      #BLAKCOL, D1
            TRAP        #15

            ; Posicionamos y mostramos las vidas
            MOVE.B      #11, D0
            MOVE.W      #$2F02, D1
            TRAP        #15

            LEA         LIVEMSG, A1
            CLR.L       D1
            MOVE.B      (LIVES), D1
            MOVE.B      #17, D0
            TRAP        #15

            ; Posicionamos y mostramos el tiempo
            MOVE.B      #11, D0
            MOVE.W      #$2F04, D1
            TRAP        #15

            LEA         TIMEMSG, A1
            MOVE.L      (TIMEPASS), D1
            MOVE.B      #17, D0
            TRAP        #15

            ; Si la vidas llegan a 0 mostramos GAME OVER!
            TST.B       (LIVES)
            BNE         .NOOVER
            
            MOVE.B      #11, D0
            MOVE.W      #$1006, D1
            TRAP        #15

            MOVE.B      #14, D0
            LEA         OVERMSG, A1
            TRAP        #15

.NOOVER

            MOVEM.L     (A7)+, D0-D1/A1
            RTS