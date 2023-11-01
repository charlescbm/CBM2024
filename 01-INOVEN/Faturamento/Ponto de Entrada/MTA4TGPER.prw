//#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA410OPERºAutor  ³Microsiga           º Data ³  08/24/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funçao para automatizar digitação de tipos de operações na º±±
±±º          ³ Cópia dos pedidos de venda                                 º±±
±±º          ³                                                            º±±
±±º          ³ Parämetro: nItem - Linha do acols que está posicionado     º±±
±±º          ³                                                            º±±
±±º          ³ Incluído na validação do campo C6_OPER                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P11                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		
			// Se está na linha do item que está sendo digitado, pula
			If nVezes == nItemOri
				Loop
			EndIf

			// Substituo o valor do item do aCols para atualizaçoes na função MaTesInt()
			n	:= nVezes

			// Se é um item válido
			If !aCols[nVezes][Len(aHeader)+1]

				// Sempre questiona o usuário se deseja substituir todos
				If !lTrocAll
            		If lFirst
	            		lTrocAll := IIf( nItemOri < Len(aCols), MsgYesNo("Deseja Substituir o Tp OPer"+cTpOpAtu+'?', "Tipo de Operacao"), .F. )
	            		lFirst	:= .F.
    				EndIf
				// Se não está preenchido ou solicitou trocar todos
				Else
					lAtualiz := .T.
					
				EndIf
			
				// Realiza atualização
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
				
				// Se já perguntou e não irá trocar os demais, sai do loop
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

