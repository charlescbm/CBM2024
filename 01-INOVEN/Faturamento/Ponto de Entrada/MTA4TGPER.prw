//#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410OPER�Autor  �Microsiga           � Data �  08/24/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun�ao para automatizar digita��o de tipos de opera��es na ���
���          � C�pia dos pedidos de venda                                 ���
���          �                                                            ���
���          � Par�metro: nItem - Linha do acols que est� posicionado     ���
���          �                                                            ���
���          � Inclu�do na valida��o do campo C6_OPER                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � P11                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//DESENVOLVIDO POR INOVEN

User Function MTA4TGPER(nItem)

Local nPosOpe	:= 0
Local nPosTes	:= 0
Local nPosCod	:= 0
Local nVezes	:= 0
Local cTpOpAtu	:= M->C6_OPER
Local lTrocAll	:= .F.
Local lAtualiz	:= .F.
Local lFirst	:= .T.
Local nItemOri	:= nItem
Local aArea		:= GetArea()
Local aAreaSB1	:= SB1->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())

Default nItem	:= 0

If INCLUI .and. nItem >= 1

	If nItem < Len(aCols) .and. ( nPosOpe:= aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'C6_OPER'}) ) > 0
    	cTpOpAtu	:= M->C6_OPER
		nPosTes:= aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'C6_TES'})
		nPosCod:= aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'C6_PRODUTO'})
		nPosCla:= aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'C6_CLASFIS'})
		nPosLan:= aScan(aHeader, { |x| AllTrim(Upper(x[2])) == 'C6_CODLAN'})
	
		For nVezes	:= nItem to Len(aCols)
		
			// Se est� na linha do item que est� sendo digitado, pula
			If nVezes == nItemOri
				Loop
			EndIf

			// Substituo o valor do item do aCols para atualiza�oes na fun��o MaTesInt()
			n	:= nVezes

			// Se � um item v�lido
			If !aCols[nVezes][Len(aHeader)+1]

				// Sempre questiona o usu�rio se deseja substituir todos
				If !lTrocAll
            		If lFirst
	            		lTrocAll := IIf( nItemOri < Len(aCols), MsgYesNo("Deseja Substituir o Tp OPer"+cTpOpAtu+'?', "Tipo de Operacao"), .F. )
	            		lFirst	:= .F.
    				EndIf
				// Se n�o est� preenchido ou solicitou trocar todos
				Else
					lAtualiz := .T.
					
				EndIf
			
				// Realiza atualiza��o
				If lAtualiz	.or. lTrocAll
					
					aCols[nVezes][nPosOpe]	:= cTpOpAtu
					If SB1->B1_COD # aCols[nVezes][nPosCod]
						SB1->(dbSetOrder(1))
						SB1->(MsSeek(xFilial('SB1')+aCols[nVezes][nPosCod]))
					EndIf
								
					aCols[nVezes][nPosTes]	:= MaTesInt(2,aCols[nVezes][nPosOpe],M->C5_CLIENT,M->C5_LOJAENT,If(M->C5_TIPO$'DB',"F","C"),aCols[nVezes][nPosCod],"C6_TES")  
		   			
					If nPosCla > 0
						aCols[nVezes][nPosCla]	:= CodSitTri()
					EndIf
			
					If nPosLan > 0
			   			If SF4->F4_CODIGO # aCols[nVezes][nPosTes]
							SF4->(dbSetOrder(1))
							SF4->(MsSeek(xFilial('SF4')+aCols[nVezes][nPosTes]))
						EndIf
						aCols[nVezes][nPosLan]	:= SF4->F4_CODLAN
					EndIf

					lAtualiz := .F.
				EndIf
				
				// Se j� perguntou e n�o ir� trocar os demais, sai do loop
           		If !lFirst .and. !lTrocAll
           			Exit
           		EndIf
			
			EndIf

		Next
	
	EndIf

EndIf

n	:= nItemOri
 
RestArea(aAreaSB1)
RestArea(aAreaSF4)
RestArea(aArea)

Return(.T.)   

