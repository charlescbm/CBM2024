#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TKGRPED  �Autor  �Thiago S. Joaquim   � Data �  05/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para verificar e exibir uma tela com os itens com ���
���          � estoque menor que a quantidade solicitada durante o pedido ���
���          � pelo Modulo Call Center. Durante a inclusao do Pedido o    ���
���          � usuario pode optar por incluir o pedido para ser Faturado  ���
���          � Parcialmente. 											  ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*�������������������������������������������������������������������������Ŀ
�   TKGRPED() Quando acionado por Schedule.                    			    �
� U_TKGRPED() Caso for executar a rotina por usuario. 					    �
���������������������������������������������������������������������������*/
//DESENVOLVIDO POR INOVEN


USER FUNCTION IVENA090(cTPOper)

Local nI       := 0
Local aProPar  := {}
//Local oListBox
//Local cItens
Local lRet	   := .T.
Local nQtdVenF := 0
Local lBloqPed := GetMv('DENBLPED',.F.,.F.) 
DBSELECTAREA("SB2")
SB2->(DBSETORDER(2))
SB2->(DBGOTOP())

/*�������������������������������������������������������������������������Ŀ
� Bloco de codigo responsavel por varrer o aCols comparando a quantidade    �
� do produto solicitada para o pedido atual com a quantidade disponivel em  �
� estoque. Se for maior o Array aProPar responsavel por montar a tela com   �
� os itens sem estoque, vai ser	alimentado com as informacoes do Produto.   �
���������������������������������������������������������������������������*/

IF lBloqPed  
	MSGAlert("Esta Bloqueado a digita��o de pedidos, Permitido somente orcamento!!")
	RETURN .F.
ENDIF


FOR nI := 1 to Len(oOrcamento:aCols)
	
	If oOrcamento:aCols[nI][Len(oOrcamento:aHeader)+1]
		Loop
	EndIf

	DbSelectArea("SB2")
	SB2->(DbSetOrder(2))  
	//--1 Busca saldo da filial
		nQtdVenF:= SB2->B2_QATU - (SB2->B2_RESERVA + SB2->B2_QPEDVEN)			
	If cTPOper == '02'

		DbSelectArea("SB2")
		SB2->(DbSetOrder(2))		
		// sempre armaz�m 01-disponivel e da filial corrente
		//DbSeek(xFilial("SB2") + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] )
		IF SB2->(DbSeek(xFilial('SB2')+"02" + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] ))
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] ))
					
			IF ( oOrcamento:aCols[nI, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] > ( (SB2->B2_QATU + SB2->B2_SALPEDI) - (SB2->B2_QPEDVEN + SB2->B2_RESERVA)) .OR. ((SB2->B2_QATU + SB2->B2_SALPEDI) - (SB2->B2_QPEDVEN + SB2->B2_RESERVA) ) < 0 )			
				//CODIGO - DESCRICAO - QUANTIDADE DO PEDIDO - QUANTIDADE EM ESTOQUE
				AADD(aProPar,{ 	oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)],;
				SB1->B1_DESC,;
				CVALTOCHAR(oOrcamento:aCols[nI, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]),;
				((SB2->B2_QATU + SB2->B2_SALPEDI) - (SB2->B2_QPEDVEN+SB2->B2_RESERVA) ),;
				SB2->B2_RESERVA })
			ENDIF  
		ELSE
			MSGalert("Produto "+ALLTRIM(oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)])+" n�o tem saldo disponivel em estoque. Verifique !!")	
			Return .F.
		ENDIF
	
	Else
	
		DbSelectArea("SB2")
		SB2->(DbSetOrder(2))		
		IF SB2->(DbSeek(xFilial('SB2')+ "01" + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] ))
			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			SB1->(DbSeek(xFilial("SB1") + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] ))
			
			IF ( oOrcamento:aCols[nI, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] > ((SB2->B2_QATU + SB2->B2_SALPEDI)-(SB2->B2_QPEDVEN+SB2->B2_RESERVA)) .OR. ((SB2->B2_QATU + SB2->B2_SALPEDI) - (SB2->B2_QPEDVEN+SB2->B2_RESERVA) ) < 0 )
				//CODIGO - DESCRICAO - QUANTIDADE DO PEDIDO - QUANTIDADE EM ESTOQUE
				AADD(aProPar,{ 	oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)],;
				SB1->B1_DESC,;
				CVALTOCHAR(oOrcamento:aCols[nI, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]),;
				IIF((SB2->B2_QATU + SB2->B2_SALPEDI)-(SB2->B2_QPEDVEN+SB2->B2_RESERVA)<=0,0,(SB2->B2_QATU + SB2->B2_SALPEDI) - (SB2->B2_QPEDVEN+SB2->B2_RESERVA)),;
				SB2->B2_RESERVA})
			EndIf  
		Else
			MSGalert("Produto "+ALLTRIM(oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)])+" n�o tem saldo disponivel em estoque. Verifique !!")	
			AADD(aProPar,{ 	oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)],;
				SB1->B1_DESC,;
				CVALTOCHAR(oOrcamento:aCols[nI, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]),;
				,0,0,;
				0})
			//Return .F.
		EndIf
	EndIf
    
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1") + oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)] ))
	if ALLTRIM(SB1->B1_MRP) == 'S' 
		MSGalert("Produto "+ALLTRIM(oOrcamento:aCols[nI, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)])+" BLOQUEADO PARA INVENTARIO. Verifique com a Diretoria !!")	
		Return .F.
	ENDIF
		
NEXT nI

/*�������������������������������������������������������������������������Ŀ
� Verifica se existem produtos a serem faturados parcialmente E se a        �
� operacao e igual a "1" Faturamento.										�
� 																			�
� +Se SIM:																	�
� �																			�
� �Pergunta ao usuario se deseja Faturar o Pedido Parcialmente.			 	�
� �																			�
� �	+Se SIM:																�
� �	� 																		�
� �	�Monta a tela com os itens que possuem estoque menor que o solicitado e	�
� �	�Insere o pedido no Sistema para ser Faturado Parcialmente.				�
� �	� 																		�
� �	+Se NAO:																�
� �	� 																		�
� �	�Nao insere o Pedido no Sistema.										�
� �																			�
� +Se NAO:																	�
� �																			�
� �Monta a tela com os itens que possuem estoque menor que o solicitado e	�
� �Insere o Orcamento / no Sistema.											�
���������������������������������������������������������������������������*/

IF Len( aProPar ) > 0
	lRet := u_fMTelaPar(aProPar)
	//lRet := .T.
ENDIF

RETURN lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fMTelaPar�Autor  �Thiago S. Joaquim   � Data �  05/28/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Responsavel por montar a Tela que contem os Produtos com   ���
���          � estoque menor que a quantidade solicitada durante o pedido ���
���          � pelo Modulo Call Center. 								  ���
�������������������������������������������������������������������������͹��
���Uso       � Generico /                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*�������������������������������������������������������������������������Ŀ
�   fMTelaPar(Parametro1) Quando acionado por Schedule.           		    �
� U_fMTelaPar(Parametro1) Caso for executar a rotina por usuario. 		    �
���������������������������������������������������������������������������*/

USER /*STATIC*/ FUNCTION fMTelaPar(aProPar, lMostraBotao)
//Local lMostraBotao	:=	IIF( lMostraBotao==NIL , .T., lMostraBotao) 
Local _lRet    := .F.
Local oFontSay := TFONT():New( , , -13, , .T., , , , .F., .F.)
Local oSayTit
Local oDlgPar

oFontSay := TFONT():New( , , -13, , .T., , , , .F., .F.)

/*�������������������������������������������������������������������������Ŀ
� Define o tamanho da nova Janela e insere os Produtos a serem com saldo    �
� abaixo do solicitado para o Pedido atual.									�
���������������������������������������������������������������������������*/

DEFINE MSDIALOG oDlgPar TITLE "Atencao aos Itens abaixo" FROM 178,181 TO 488,717 PIXEL

oSayTit := TSAY():New(015,040,{||"Relacao de Produtos com estoque abaixo do solicitado."},oDlgPar, , oFontSay, , , , .T., , , 230, 008, , , , , )

@ 030,020 LISTBOX oListBox FIELDS HEADER ;
"Codigo", "Descricao", "Quantidade do Pedido", "Quantidade Disp Estoque","Quantidade Reservada Estoque" SIZE 230,95 OF oDlgPar PIXEL
oListBox:SetArray( aProPar )
oListBox:bLine := {|| {aProPar[oListBox:nAt][1],;
aProPar[oListBox:nAt][2],;
aProPar[oListBox:nAt][3],;
aProPar[oListBox:nAt][4],;
aProPar[oListBox:nAt][5]}}

//IF lMostraBotao .AND. GetMV('LI_PVESNEG',.F.,.F.)
IF GetMV('LI_PVESNEG',.F.,.F.)
	//Renato Bandeira em 09/10/14 - Tratamento para estoque parcial ou sem estoque
	@ 135,020 Button "&Gravar"   Size 037,012 PIXEL OF oDlgPar ACTION(_lRet:=_lSemEst:=.T., oDlgPar:End())
ENDIF
@ 135,213 Button "&Cancelar" Size 037,012 PIXEL OF oDlgPar ACTION(_lRet:=.F., oDlgPar:End())

ACTIVATE MSDIALOG oDlgPar CENTERED

RETURN(_lRet)



// Renato Bandeira em 18/12/14
// CHAMADA :
//	@ C(139),C(108) MSGET 	oQtde 			VAR 	nQtde  			PICTURE "@e 9,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID (u_VldForaLin(gCod_produto,nQtde),DnyCarTot(),DnyCarOrc(@oDlgVendas, @oFolder))  PIXEL

User Function VldForaLin(__Codprod,__nQtde)
lRetorno	:=	.T.

IF .F. //SB1->B1_XSITPRO	== "000001"
	IF ! SB2->(DbSeek("0501" + __Codprod + "01" ))
		lRetorno	:=	.F.
	ELSE
		IF __nQtde > (SB2->B2_QATU-SB2->B2_QPEDVEN)
			MSGalert("Produto fora de linha sem saldo para atender a quantidade digitada. Verifique !!")
			lRetorno	:=	.F.
		Endif
	ENDIF
ENDIF
RETURN( lRetorno)
