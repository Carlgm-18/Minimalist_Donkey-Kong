*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con el desarrollo
* de una partida
*------------------------------------------------------------------------------

TIMEINIT    DS.L    1
TIMEPASS    DS.L    1

; -----------------------------------------------------------------------------
GAMEINIT
; Inicializa la partida
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L      D0-D1, -(A7)
            
            JSR		    PLYINIT
		    JSR 	    BRINIT
            
            CLR.L       (TIMEPASS)
            
            MOVE.B      #8, D0
            TRAP        #15
            MOVE.L      D1, (TIMEINIT)

            MOVEM.L     (A7)+, D0-D1
            RTS

; -----------------------------------------------------------------------------
GAMEUPDT
; Inicializa la partida
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L      D0-D1, -(A7)
            
            JSR		    BRUPDT
		    JSR 	    PLYUPDT
            
            MOVE.B      #8, D0
            TRAP        #15
            SUB.L       (TIMEINIT), D1
            DIVU        #100, D1
            ANDI.L      #$0000FFFF, D1 
            MOVE.L      D1, (TIMEPASS)

            MOVEM.L     (A7)+, D0-D1
            RTS

; -----------------------------------------------------------------------------
GAMEPLOT
; Inicializa la partida
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR 	    MAPPLOT
            JSR		    PLYPLOT
            JSR 	    BRPLOT
            JSR 	    KONGPLOT
            JSR 	    PRINPLOT
            JSR 	    INFOPLOT
            
            RTS



*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~