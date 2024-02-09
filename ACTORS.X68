*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con el enemigo
*------------------------------------------------------------------------------

KONGPOSX        EQU     4*CHKSIZE
KONGPOSY        EQU     3*CHKSIZE+CHKSIZE/2

PRINPOSX        EQU     CHKSIZE/2
PRINPOSY        EQU     CHKSIZE+CHKSIZE/2
PRINMSG         DC.B    'SAVE ME!', 0
                DS.W    0

; -----------------------------------------------------------------------------
KONGPLOT
; Muestra el enemigo por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
                MOVEM.L     D2/D6/A0, -(A7)

                MOVE.W      #KONGPOSX, D6
                MOVE.W      #KONGPOSY, D2
                LEA         IMGKONG, A0
                JSR         IMGPLOT
                
                MOVEM.L     (A7)+, D2/D6/A0
                RTS

; -----------------------------------------------------------------------------
PRINPLOT
; Muestra la princesa por pantalla
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
        
                MOVEM.L     D0-D2/D6/A0-A1, -(A7)

                MOVE.B      #21, D0
                MOVE.L      #$00FFFFFF, D1
                MOVE.L      #$030C0000, D2
                TRAP        #15

                CLR.L       D2
                MOVE.W      #PRINPOSX, D6
                MOVE.W      #PRINPOSY, D2
                LEA         IMGPRIN2, A0
                JSR         IMGPLOT

                MOVE.B      #81, D0
                MOVE.L      #ROSECOL, D1
                TRAP        #15

                MOVE.B      #89, D0
                MOVE.W      #PRINPOSX, D1
                MOVE.W      #PRINPOSY, D2
                TRAP        #15
                
                MOVE.B      #81, D0
                MOVE.L      #BLAKCOL, D1
                TRAP        #15

                MOVE.B      #11, D0
                MOVE.W      #$0502, D1
                TRAP        #15

                MOVE.B      #14, D0
                LEA         PRINMSG, A1
                TRAP        #15


                MOVEM.L     (A7)+, D0-D2/D6/A0-A1
                RTS

*~Font name~Courier New~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~