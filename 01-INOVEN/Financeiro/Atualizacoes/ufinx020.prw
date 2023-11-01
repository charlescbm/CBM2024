#include 'protheus.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	               		!
+-------------------------------------------------------------------------------+
!Programa			! UFINX020 - Inicializador Padrao - E5_HISTOR              	! 
+-------------------+-----------------------------------------------------------+
!Autor         	    ! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 05/10/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UFINX020()

Local cHist := ''

//if IsInCallStack("FINA750")
if IsInCallStack("FINA750") .or. IsInCallStack("U_GDVA060")

    cHist := SE2->E2_HIST
    
endif

Return( cHist )
