/***************************************************************************************
** Rotina para gravar o numero do lote antes do report da O.P., respeitando o lote da **
** O.P. filha ou do saldo dispon�vel no estoque                             		     **
** Autor: Wanderley Goncalves Jr                                                      **
** Data: 04/04/05                                                                     **
** Cliente: Brascola Ltda                                                             **
***************************************************************************************/

#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"

User Function GeraLote(OPDe,OPAte)
******************************
Local cOP, cOPNum
Local lLote := .F.
Local lCrieiLote := .F.
Local aTipo := {}
Local aTipoPA:= {}
Local cLote
Local dDtVal

DbSelectArea("SC2")
DbSetOrder(1)
DbSeek(xFilial("SC2")+OPDe,.T.)  // De acordo com a selecao da impressao
Do While !Eof() .and. SC2->C2_NUM <= OPAte
	cOPNum := SC2->C2_NUM
	Do while cOPNum == SC2->C2_NUM
		If empty(C2_LOTECTL)                   // Op est� sem numero de lote
			aTipo := RetTipo(SC2->C2_PRODUTO)  // Retorna {Tipo(C), meses de validade(N)}
			aTipoPA := aClone(aTipo)    			// Retorna {Tipo(C), meses de validade(N)}
			If aTipo[1] == "3"
				cOP := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
				DbSelectArea("SD4")							// Verifico retorno lote do PI empenhado.
				DbSetOrder(2)
				If DbSeek(xFilial("SD4")+cOP)
					Do While AllTrim(cOP) == AllTrim(SD4->D4_OP)
						aTipo := RetTipo(SD4->D4_COD) // Retorna {Tipo(C), meses de validade(N)}
						If  aTipo[1] == "4"
							If !empty(SD4->D4_LOTECTL)
								cLote := SD4->D4_LOTECTL
								dDtVal := SD4->D4_DTVALID
							Else
								cLote := U_ProxLoteOP(SC2->C2_produto,SC2->C2_num,SC2->C2_sequen)
								dDtVal := dDataBase+(aTipoPA[2]*30)
								lCrieiLote := .T.
							EndIf
							DbSelectArea("SC2")
							RecLock("SC2",.F.) //Gravo o lote na OP
							C2_LOTECTL := cLote
							C2_DTVALID := dDtVal
							MsUnlock()
							
							DbSelectArea("QPK")
							DbSetOrder(1) //Filial + OP
							IF DbSeek(xFilial("QPK")+cOPNum+SC2->C2_ITEM+SC2->C2_SEQUEN)
								RecLock("QPK",.F.)
								//QPK_LOTE := cLote
								QPK->QPK_LOTE := SC2->C2_LOTECTL
								MsUnlock()
							ENDIF
							Exit
						EndIf
						DbSelectArea("SD4")
						DbSkip()
					EndDo
				EndIf
			Else  //SE O TIPO DO PRODUTO OR DIFERENTE DE PA
				If !lCrieiLote
					//	lCrieiLote := .F.
					//	Else
					cLote := U_ProxLoteOP(SC2->C2_produto,SC2->C2_num,SC2->C2_sequen)
					dDtVal := dDataBase+(aTipo[2]*30)
				EndIf
				RecLock("SC2",.F.) //Gravo o lote na OP
				C2_LOTECTL := cLote
				C2_DTVALID := dDtVal
				MsUnlock()
				
				DbSelectArea("QPK")
				DbSetOrder(1) //Filial + OP
				IF dbseek(xFilial("QPK")+cOPNum+SC2->C2_ITEM+SC2->C2_SEQUEN)
					RecLock("QPK",.F.)
					QPK->QPK_LOTE := cLote
					MsUnlock()
				endif
			EndIf
			DbSelectArea("SC2")
			If empty(C2_LOTECTL) // Se OP chegou ate aqui e ainda continua sem   // ZANARDO
				aTipo := RetTipo(SC2->C2_PRODUTO)    //numero de lote, crio um.
				cLote := U_ProxLoteOP(SC2->C2_produto,SC2->C2_num,SC2->C2_sequen)
				dDtVal := dDataBase+(aTipo[2]*30)
				RecLock("SC2",.F.) //Gravo o lote na OP
				C2_LOTECTL := cLote
				C2_DTVALID := dDtVal
				MsUnlock()
			EndIf
		EndIf
		DbSelectArea("SC2")
		DbSkip()
	EndDo
	lCrieiLote := .F.
EndDo

//���������������������������������������������������������������������������Ŀ
//�Este codigo verifica se aconteceu alguma duplicidade no lote. Se ocorreu,  �
//|eu mando gerar um lote novamente.                                          �
//�����������������������������������������������������������������������������
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+OPDe,.T.)
While !Eof() .And. SC2->C2_NUM <= OPAte
	cQuery := " SELECT ISNULL(COUNT(*),0) VALOR "
	cQuery += " FROM "+RetSQLName("SC2")+" SC2 "
	cQuery += " WHERE C2_LOTECTL = '"+SC2->C2_LOTECTL+"' "
	cQuery += " AND SC2.D_E_L_E_T_=' ' "
	cQuery += " AND SC2.C2_NUM <> '"+SC2->C2_NUM+"' "
	If Select("TRB")>0
		TRB->(dbCloseArea())
	EndIf
	TCQUERY cQuery NEW ALIAS "TRB"
	If TRB->VALOR <> 0
		//		aTipo := RetTipo(SC2->C2_PRODUTO)    //numero de lote, crio um.
		//		cLote := U_ProxLoteOP(SC2->C2_produto,SC2->C2_num,SC2->C2_sequen)
		//		dDtVal := dDataBase+(aTipo[2]*30)
		//		RecLock("SC2",.F.) //Gravo o lote na OP
		//		C2_LOTECTL := cLote
		//		C2_DTVALID := dDtVal
		//		MsUnlock()
		Aviso(	"Gera��o de Lote para OP's",;
		"Ocorreu duplicidade de Lote para esta OP! ",;	//"Ocorreu duplicidade de Lote para esta OP citada! O N�mero foi corrigido!",;
		{"&Continua"},,;
		"Nro OP: "+SC2->(C2_NUM+C2_ITEM+C2_SEQUEN))
		
	EndIf
	dbSelectArea("SC2")
	dbSkip()
EndDo

Return

Static Function RetTipo(cProd)
***************************
// Retorna o tipo do produto

Local aArea   := GetArea()
Local cTipo   := "  "
Local nQtdMes := 0

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial()+cProd)
	cTipo :=   B1_TIPO
	nQtdMes := (B1_PRVALID/30)
EndIf
RestArea(aArea)

Return({cTipo, nQtdMes})