#INCLUDE "rwmake.ch"
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! F460VAL													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Ponto de entrada forcar a natureza dos titulos gerados	! 
!					! pela liquidacao											!
+-------------------+-----------------------------------------------------------+
!					!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne - Crele Cristina									!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 20/10/2022					                          	!
+-------------------+-----------------------------------------------------------+
*/
User Function F460VAL()

	Local _aComple := PARAMIXB

	SE1->(recLock("SE1"), .F.)
	SE1->E1_VEND1	:= _aComple[1][2]
	SE1->E1_VEND2	:= _aComple[2][2]
	//SE1->E1_BASCOM1 := SE1->E1_VALOR
	SE1->E1_COMIS1  := _aComple[3][2]
	SE1->E1_COMIS2  := _aComple[4][2]
	SE1->E1_VALCOM1 := Round(SE1->E1_VALOR * (SE1->E1_COMIS1/100), 2)
	SE1->E1_VALCOM2 := Round(SE1->E1_VALOR * (SE1->E1_COMIS2/100), 2)
	SE1->(msUnlock())
	//conout(se1->e1_prefixo+' - '+se1->e1_num+' - '+str(se1->e1_comis1))
	
Return
