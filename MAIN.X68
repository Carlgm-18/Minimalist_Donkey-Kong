*------------------------------------------------------------------------------
* Title      : DONKEY KONG Minimalista
* Written by : Carlos Galvez Mena
*------------------------------------------------------------------------------

    		ORG    $1000

			INCLUDE		'CONSTS.X68'
			INCLUDE		'SYSTEM.X68'
			INCLUDE		'SYSVARS.X68'
			INCLUDE		'PLAYER.X68'
			INCLUDE 	'MAP.X68'
			INCLUDE 	'BARREL.X68'
			INCLUDE 	'IMAGES.X68'
			INCLUDE 	'ACTORS.X68'
			INCLUDE 	'GAME.X68'
			INCLUDE 	'INFO.X68'
			INCLUDE 	'MENU.X68'
			INCLUDE 	'GAMEOVER.X68'

START:                  

			JSR 	SYSINIT
			
			JSR 	GAMEINIT
			JSR 	MENUINIT

.LOOP

			; Comprobar estado de los periféricos
			TRAP    #1
			TRAP 	#2

			; Actualizar estado del juego
			TST.B 	(CLIKPLAY)
			BEQ 	.MUPD
			JSR 	GAMEUPDT
			BRA 	.PLOT

.MUPD 		JSR 	MENUPDT

.PLOT		; Mostrar por pantalla los elementos del juego
			TST.B 	(CLIKPLAY)
			BEQ 	.MPLT
			JSR 	GAMEPLOT
			BRA 	.CONT

.MPLT		JSR 	MENUPLOT

.CONT
			TRAP 	#0

			TST.B 	(LIVES)
			BEQ 	LOSTGAME
			TST.B 	(CLIKEXIT)
			BNE 	ENDGAME
			TST.B 	(WIN)
			BNE 	WINGAME

			BRA 	.LOOP

LOSTGAME 	JSR 	LOSTPLOT
			TRAP  	#0
			BRA 	ENDGAME

WINGAME		JSR 	WINPLOT
			TRAP 	#0

ENDGAME		SIMHALT             


    		END    START
       






*~Font name~Courier New~
*~Font size~18~
*~Tab type~1~
*~Tab size~4~
