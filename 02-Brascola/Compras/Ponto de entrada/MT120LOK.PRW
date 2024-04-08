#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100TOK ³ Autor ³ Fernando Maia         ³ Data ³ 23/05/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE que faz a verificacao por linha nos itens               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function  MT120LOK()   
***********************
Local lRetu := .T., cQuery1, nConta1
LOCAL nPos1 := Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_PRODUTO" })
LOCAL nPos2	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_DTPGTO"  })
LOCAL nPos3	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_ITEM"    })
LOCAL nPos4	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_DTPGTO"  })
LOCAL nPos5	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_CONTA"   })
LOCAL nPos6	:= Ascan(aHeader,{|m| Alltrim(m[2]) == "C7_CC"      })
LOCAL cProd := AllTrim(aCols[n,nPos1]) //Grava na variavel   
        
//Valido cadastro de especificacao na qualidade
///////////////////////////////////////////////  
If !(aCols[N,Len(aCols[N])])

	SB1->(dbSetOrder(1)) ; SC7->(dbSetOrder(1)) ; SE2->(dbSetOrder(1))

	If (cCondicao == "500" .OR. cCondicao == "605" .OR. cCondicao == "604")
		If Empty(aCols[N,nPos2])
			Help("",1,"BRASCOLA",,OemToAnsi("Favor informar DT. Pgto na linha do item."),1,0)
			Return (lRetu := .F.)
		Elseif !(ALTERA).and.(aCols[N,nPos2] < dDatabase)
			Help("",1,"BRASCOLA",,OemToAnsi("A Data de Pgto deve ser maior ou igual a data de hoje."),1,0)
			Return (lRetu := .F.)
		Elseif (ALTERA).and.SC7->(dbSeek(xFilial("SC7")+cA120Num+aCols[N,nPos3])).and.(SC7->C7_dtpgto != aCols[N,nPos4])
			cQuery1 := "SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SE2")+" SE2 "
			cQuery1 += "WHERE SE2.D_E_L_E_T_ = '' AND SE2.E2_FILIAL = '"+xFilial("SE2")+"' AND SE2.E2_VALOR <> SE2.E2_SALDO "
			cQuery1 += "AND SE2.E2_PREFIXO = 'COM' AND SE2.E2_NUM = '"+cA120Num+"' AND SE2.E2_TIPO = 'PRA' "
			cQuery1 += "AND SE2.E2_FORNECE = '"+SC7->C7_fornece+"' AND SE2.E2_LOJA = '"+SC7->C7_loja+"' "
			cQuery1 := ChangeQuery(cQuery1)
			If (Select("MSE2") <> 0)
				dbSelectArea("MSE2")
				dbCloseArea()
			Endif
			TCQuery cQuery1 NEW ALIAS "MSE2"
			nConta1 := 0
			If !MSE2->(Eof()).and.(MSE2->M_conta > 0)
				nConta1 := MSE2->M_conta
			Endif
			If (Select("MSE2") <> 0)
				dbSelectArea("MSE2")
				dbCloseArea()
			Endif
			If (nConta1 > 0)
				Help("",1,"BRASCOLA",,OemToAnsi("Título já foi baixado. NÃO é possível alterar a data de pagamento!"),1,0)
				Return (lRetu := .F.)
			Endif
		Endif
	Endif 
		
	If Empty(aCols[N,nPos5])
		Help("",1,"BRASCOLA",,OemToAnsi("Conta contábil deve ser informada!"),1,0)
		Return (lRetu := .F.)
	Else
		CT1->(dbSetOrder(1))
		If CT1->(dbSeek(xFilial("CT1")+aCols[N,nPos5]))
			If CT1->CT1_CCOBRG == "1" .AND. Empty(aCols[N,nPos6])
				Help("",1,"BRASCOLA",,OemToAnsi("Conta "+AllTrim(aCols[N,nPos5])+" definida na regra de contabilização exige a digitação do centro de custo ou rateio de centro de custo!"),1,0)
				Return (lRetu := .F.)
			Endif
		Endif
	Endif
	
	If !Empty(aCols[N,nPos6])
		CTT->(dbSetOrder(1))
		If !CTT->(dbSeek(xFilial("CTT")+aCols[N,nPos6]))
			Help("",1,"BRASCOLA",,OemToAnsi("O centro de custo "+Alltrim(aCols[N,nPos6])+" informado nao existe!"),1,0)
			Return (lRetu := .F.)
		Else
			If CTT->CTT_CLASSE == "1"
				Help("",1,"BRASCOLA",,OemToAnsi("O centro de custo informado é sintético. Escolha um centro de custo analítico."),1,0)
				Return (lRetu := .F.)
			EndIf
			If CTT->CTT_BLOQ == "1"
				Help("",1,"BRASCOLA",,OemToAnsi("O centro de custo informado está bloqueado e, portanto, não pode ser usado."),1,0)
				Return (lRetu := .F.)
			EndIf	
		EndIf
	EndIf

	If (SB1->B1_TIPOCQ == "Q")
		SA5->(dbSetOrder(1))   
		If !SA5->(dbSeek(xFilial("SA5")+ca120forn+ca120loj+cProd))
			Help("",1,"BRASCOLA",,OemToAnsi("Amarração Produto x Fornecedor nao foi encontrada. Verificar com área responsável!"),1,0)
			Return (lRetu := .F.)
		Elseif Empty(SA5->A5_SITU).or.Empty(SA5->A5_TEMPLIM).or.Empty(SA5->A5_FABREV).or.Empty(SA5->A5_TIPATU)
			Help("",1,"BRASCOLA",,OemToAnsi("Verificar Amarração Produto x Fornecedor. Cadastro esta incompleto!"),1,0)
			Return (lRetu := .F.)
		Endif
	Endif
	
Endif

Return(lRetu)