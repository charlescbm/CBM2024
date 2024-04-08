# INCLUDE "RWMAKE.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ EFATA08  ³ Autor ³                       ³ Data ³   /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula Acrescimo de Acordo com a Condicao de Pagamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function EFATA08(cCampo)

Local nPos1     := 0
Local nPPrcVen  := 0
Local nPValDesc := 0
Local nPValor   := 0
Local nPPrUnit  := 0
Local nPQtdVen  := 0
Local nDescont  := 0
Local cProduto  := cTabPrc := ""
Local nPrcTab   := 0
Local Inflato   := 0
Local nQtdVen   := 0
Local lRet      := .T.
Local aArea     := GetArea()
Local aAmbSE4   := SE4->( GetArea() )
Local aAmbDA1   := DA1->( GetArea() )
Private nInflato:= 0

nPos1       := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"  })//seta a posição da coluna do Produto
cProduto    := aCols[n,nPos1]//seta o produto digitado
nPPrcVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"  })//seta a posição da coluna do Preco de Venda
nPQtdVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"  })//seta a posição da coluna da Quantidade
nPValDesc   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" })//seta a posição da coluna do Valor de Desconto
nPValor     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"   })//seta a posição da coluna do Valor
nPPrUnit    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"  })//seta a posição da coluna do Valor Unitario

nValDesc :=  aCols[n,nPValDesc] 

//Verifica de qual campo a rotina foi chamada.
If cCampo == "C6_QTDVEN"
	nQtdVen := M->C6_QTDVEN //seta o valor constante na memória
Else
	nQtdVen := aCols[n,nPQtdVen]
EndIf

dbSelectArea("DA1")
dbSetOrder(1)
If dbSeek( XFILIAL("DA1") + M->C5_TABELA + cProduto)
	nPrcTab := DA1->DA1_PRCVEN
EndIf

IF l410auto <> .T.
	
	If !Empty(M->C5_CONDPAG)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+M->C5_CONDPAG)
			nInflato := SE4->E4_INFLATO
		EndIf
		
		If nInflato < 0
			nInflato := (100 - (nInflato * -1)) / 100
			nPrcTab := nPrcTab * nInflato
		Else
			nInflato := (nPrcTab * nInflato) / 100
			nPrcTab  := nPrcTab + nInflato
		EndIf
		
	Else
		MsgStop(OemToAnsi("Condição de Pagamento não encontrada !"))
		MsgBox(OemToAnsi("Solução : Aperte (ESC) e digite a Condição de Pagamento!"))
		lret := .F.
	EndIf
	
ELSE
	
	If !Empty(M->C5_CONDPAG)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+M->C5_CONDPAG)
			nInflato := SE4->E4_INFLATO
		EndIf
		
		//verifica situação do campo Inflator
		If nInflato < 0
			nInflato := (100 - (nInflato * -1)) / 100
			nPrcTab  := nPrcTab * nInflato
		Else
			nInflato := (nPrcTab * nInflato) / 100
			nPrcTab  := nPrcTab + nInflato
		EndIf
	ENDIF
	
ENDIF

nPrcTab            := Round(nPrcTab,2)
aCols[n,nPQtdVen]  := nQtdVen
aCols[n,nPPrcVen]  := nPrcTab
aCols[n,nPPrUnit]  := nPrcTab   //Preco de Tabela
aCols[n,nPValor]   := aCols[n,nPPrcVen] * nQtdVen
aCols[n,nPValDesc] := (aCols[n,nPPrUnit] - aCols[n,nPPrcVen]) * nQtdVen

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurando Integridade. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAmbSE4)
RestArea(aAmbDA1)
RestArea(aArea)
Return(lRet)
