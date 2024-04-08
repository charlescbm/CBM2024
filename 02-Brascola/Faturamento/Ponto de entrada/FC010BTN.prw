#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FC010BTN �Autor  � Marcelo da Cunha   � Data �  04/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para adicionar botoes na consulta finan.  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FC010BTN()
*********************
LOCAL xRetu, nParam := paramixb[1],cCadSeg,cModSeg
If (nParam == 1)
	xRetu := "Alt.Cadastro"
Elseif (nParam == 2)
	xRetu := "Alteracao Cadastro"
Elseif (nParam == 3)
	dbSelectArea("SA1")                        
	aMemos := {{"A1_CODMARC","A1_VM_MARC"},{"A1_OBS","A1_VM_OBS"}}
	aRotAuto   := Nil
	aCpoAltSA1 := {} 
	lCGCValido := .F.
	cCadSeg := cCadastro 
	cModSeg := cModulo
	INCLUI  := .F. ; ALTERA := .T.
	cCadastro := "Alteracao de Clientes"
	A030Altera("SA1",SA1->(Recno()),4)                             
	cCadastro := cCadSeg
	cModulo := cModSeg
Endif
Return xRetu