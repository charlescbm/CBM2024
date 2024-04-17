/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! MT440FIL                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! P.E. para filtrar pedidos na Libera��o Autom�tica       !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/02/2012                                              !
+------------------+---------------------------------------------------------+
*/

#include "protheus.ch"

User Function MT440FIL()

Local aArea   := GetArea()
Local cFiltro := ""
local _cfobon :=GetMV("BR_CFBON")

dbSelectArea("SA1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
	If SA1->A1_EST $ mv_par11
		cFiltro := "C6_ITEM != '" + SC6->C6_ITEM + "' "
	EndIf
EndIf

If MV_PAR12 == 1 //Venda
	dbSelectArea("SF4")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(xFilial("SF4")+SC6->C6_TES)
	   //	If (SF4->F4_DUPLIC == 'N').or.!((SC6->C6_CF $ _CfoBon).and.!Empty(SC6->C6_x_regra))
	   If ((SF4->F4_DUPLIC == 'N').and.Empty(SC6->C6_x_regra))
			cFiltro := "C6_ITEM != '" + SC6->C6_ITEM + "' " 
		EndIf
	EndIf
Else //Bonifica��o
	if !(alltrim(SC6->C6_CF) $ _cfobon)
		//cFiltro := "C6_CF !$ '"+_cfobon+"' "
		cFiltro := "C6_ITEM != '" + SC6->C6_ITEM + "' "
	ENDIF
	//cFiltro := "C6_TIPOOP !$ '04/7' "//'5910/5911/6910/6911
EndIf

RestArea(aArea)

Return cFiltro