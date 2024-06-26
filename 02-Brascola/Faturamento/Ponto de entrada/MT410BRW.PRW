#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410BRW  �Autor  �Wanderley Goncalves � Data �  30/03/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina de filtro de pedido de venda por representante na    ���
���          �Abertura do Arquivo                                         ���
�������������������������������������������������������������������������͹��
���Alteracoes� Elias Reis - 04.04.2006 - Alteracao do filtro para o       ���
���			 �	             usuario IGSILVA, para que o mesmo possa ver   ���
���          �              todos os pedidos com a Cond.Pag = '010/009'   ���
���          �              alem dos pedidos de Amostra.                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT410BRW()
*********************
LOCAL aArea := GetArea(), aTmpSA3, aAmbSA3 := SA3->(GetArea()) 
LOCAL cFiltro := "(.F.)", cPerg := "FILPED", aRegs := {}

U_BCFGA002("MT410BRW")//Grava detalhes da rotina usada

//04/02/13 - Cria Grupo de Perguntas
////////////////////////////////////
aRegs := {}
aadd(aRegs,{cPerg,"01","Tipo de Pedido    ?","mv_ch1","N",01,0,1,"C","","MV_PAR01","Amostras","","","Normal","","","Ambos","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs)
      
//04/02/13 - Marcelo - Montagem do filtro para o Browse
///////////////////////////////////////////////////////
If (u_BXRepAdm()) //Parametro/Presidente/Diretor
	cFiltro := "" //Liberar para todos
Else
	cLista := u_BXRepLst("FIL") //Lista dos Representantes
	cFiltro := "AllTrim(C5_VEND1) $ '"+cLista+"' "
Endif

//30/01/13 - Marcelo - Efetivo Filtro
/////////////////////////////////////
If !Empty(cFiltro)
	If (Alltrim(cUserName) $ "mcunha")
		MSGSTOP(cFiltro)
	Endif
	SC5->(dbSetFilter({|| &cFiltro }, cFiltro))
EndIf

RestArea(aAmbSA3)
RestArea(aArea)

Return (.T.)