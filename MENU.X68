*------------------------------------------------------------------------------
* Este archivo contiene todo lo relacionado con el menú
* de selección
*------------------------------------------------------------------------------

TITLE1      DC.B    'DONQUIN', 0
TITLE2      DC.B    'CON', 0
PLAYMSG     DC.B    'PLAY', 0
EXITMSG     DC.B    'EXIT', 0
CLIKPLAY    DS.B    1
CLIKEXIT    DS.B    1
            DS.W    0

BTWIDT      EQU     7*CHKSIZE
BTHEIG      EQU     4*CHKSIZE
BTPOSX      EQU     13*CHKSIZE/2
PLBTPOSY    EQU     14*CHKSIZE
EXBTPOSY    EQU     21*CHKSIZE

; -----------------------------------------------------------------------------
MENUINIT:
; Inicialiaz el menú
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            CLR.W   (CLIKPLAY)

            RTS

; -----------------------------------------------------------------------------
MENUPDT:
; actualiza el menú
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L     D0-D4, -(A7)

            MOVE.L      #16, D4
            MOVE.L      (MOUSPOS), D1
            MOVE.W      D1, D0
            LSR.L       D4, D1

            ; Clickando botón?
            ; Colisión con el botón
            ; Seguimos el siguiente esquema de condiciones
            ; If( MOUSPOSX > BTPOSX + BTWIDTH ) -> No colisión
            ; If( MOUSPOSX < BRPOSX ) -> No colisión
            ; If( MOUSPOSY > BRPOSY + BTHEIGHT ) -> No colisión
            ; If( MOUSPOSY < BRPOSY ) -> No colisión
            ; Else -> Colisión

            MOVE.W      #BTPOSX, D2
            MOVE.W      #PLBTPOSY, D3

            CMP.W       D2, D0
            BLT         .NOPLCOL

            ADD.W       #BTWIDT, D2
            CMP.W       D2, D0
            BGT         .NOPLCOL

            CMP.W       D3, D1
            BLT         .NOPLCOL

            ADD.W       #BTHEIG, D3
            CMP.W       D3, D1
            BGT         .NOPLCOL

            BTST.B      #0, (MOUSVAL)   ; Hay colisión
            BEQ         .NOPLCOL
            MOVE.B      #1, (CLIKPLAY)  ; Ha hecho click
            BRA         .DONEPL
.NOPLCOL
            MOVE.B      #0, (CLIKPLAY)  ; No hay colisión o click
.DONEPL

            MOVE.W      #BTPOSX, D2
            MOVE.W      #EXBTPOSY, D3

            CMP.W       D2, D0
            BLT         .NOEXCOL

            ADD.W       #BTWIDT, D2
            CMP.W       D2, D0
            BGT         .NOEXCOL

            CMP.W       D3, D1
            BLT         .NOEXCOL

            ADD.W       #BTHEIG, D3
            CMP.W       D3, D1
            BGT         .NOEXCOL

            BTST.B      #0, (MOUSVAL)   ; Hay colisión
            BEQ         .NOEXCOL
            MOVE.B      #1, (CLIKEXIT)  ; Ha hecho click
            BRA         .DONEEX
.NOEXCOL
            MOVE.B      #0, (CLIKEXIT)  ; No hay colisión o click
.DONEEX

            MOVEM.L     (A7)+, D0-D4
            RTS

; -----------------------------------------------------------------------------
MENUPLOT:
; Muestra el menú por pantalla 
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            MOVEM.L     D0-D4, -(A7)
            ; Pintar cuadrados
            MOVE.B      #80, D0
            MOVE.L      #$00FFFFFF, D1
            TRAP        #15

            MOVE.B      #81, D0
            MOVE.L      #0, D1
            TRAP        #15

            MOVE.B      #93, D0
            MOVE.B      #CHKSIZE/4, D1
            TRAP        #15

            MOVE.B      #87, D0
            MOVE.W      #BTPOSX, D1
            MOVE.W      #PLBTPOSY, D2
            MOVE.W      D1, D3
            MOVE.W      D2, D4
            ADD.W       #BTWIDT, D3
            ADD.W       #BTHEIG, D4
            TRAP        #15

            MOVE.W      #EXBTPOSY, D2
            MOVE.W      D2, D4
            ADD.W       #BTHEIG, D4
            TRAP        #15

            ; Mostrar título
            MOVE.B      #21, D0
            MOVE.L      #$00FFFFFF, D1
            MOVE.L      #$03360000, D2
            TRAP        #15

            MOVE.B      #11, D0
            MOVE.W      #$0402, D1
            TRAP        #15

            LEA         TITLE1, A1
            MOVE.B      #14, D0
            TRAP        #15

            MOVE.B      #11, D0
            MOVE.W      #$0603, D1
            TRAP        #15

            LEA         TITLE2, A1
            MOVE.B      #14, D0
            TRAP        #15


            ; Mostrar botón de jugar
            MOVE.B      #11, D0
            MOVE.W      #$0506, D1
            TRAP        #15

            LEA         PLAYMSG, A1
            MOVE.B      #14, D0
            TRAP        #15
            ; Mostrar botón de salir
            MOVE.B      #11, D0
            MOVE.W      #$0509, D1
            TRAP        #15

            LEA         EXITMSG, A1
            MOVE.B      #14, D0
            TRAP        #15

            MOVEM.L       (A7)+, D0-D4
            RTS

*~Font name~Courier New~
*~Font size~16~
*~Tab type~1~
*~Tab size~4~
