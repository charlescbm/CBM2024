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
nPDesc      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })//seta a posição da coluna do Desconto
nPValDesc   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" })//seta a posição da coluna do Valor de Desconto
nPValor     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"   })//seta a posição da coluna do Valor
nPPrUnit    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"  })//seta a posição da coluna do Valor Unitario

nValDesc :=  aCols[n,nPValDesc] 
cTabela	   := AllTrim(C5_TABELA) //Fernando
cCliente   := AllTrim(C5_CLIENTE)

//Verifica de qual campo a rotina foi chamada.
If cCampo == "C6_QTDVEN"
	nQtdVen := M->C6_QTDVEN //seta o valor constante na memória
Else
	nQtdVen := aCols[n,nPQtdVen]
EndIf 

dbSelectArea("SA1")
dbSetOrder(1)
If SA1->(dbSeek(xFilial("SA1")+cCliente))//posiciona no Cliente selecionado no pedido 
	cGrpCli:= SA1->A1_GRPVEN
	If SA1->A1_PROMOCA == '1'
		lCliProm := .T. //verifica se o cliente esta incluso na promocao
	Else
		lCliProm := .F.
	EndIf
EndIf

dbSelectArea("DA1")
dbSetOrder(1)
If dbSeek( XFILIAL("DA1") + M->C5_TABELA + cProduto)
	nPrcTab := DA1->DA1_PRCVEN
EndIf

//Fernando***************************************** 
dbSelectArea("SZ1")
dbSetOrder(2)

dbSeek(xFilial("SZ1")+cProduto+cTabela)//posiciona o produto na tabela SZ1
//cCodigo := SZ1->Z1_CODIGO //captura o código da promoção
//cTitulo := SZ1->Z1_TITULO //captura o nome da promoção
cTabProm:= SZ1->Z1_TABELA  //captura a tabela de preco cadastrada no SZ1
nDescMax:= SZ1->Z1_DESCONT //captura qual o desconto máximo que pode ser dado
cDataDe := SZ1->Z1_DATADE //captura a data inicial da validade
nDesPro  := SZ1->Z1_DESCPR  
cGrpProm:= SZ1->Z1_GRUPO//grupo de clientes

IF l410auto <> .T.
	
	If !Empty(M->C5_CONDPAG)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		
		If dbSeek(xFilial("SE4")+M->C5_CONDPAG)
			nInflato := SE4->E4_INFLATO
		EndIf	
		
		If (SZ1->(dbSeek(xFilial("SZ1")+cProduto+cTabela))) .AND. (SZ1->Z1_ATIVO == "S") .AND. (cGrpCli == cGrpProm);
		.AND. (aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PROMOCA" })] <> "")//verifica se o produto + tabela de preço estão na SZ1
			//Caso o produto esteja na promoçao........
			nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o cálculo do novo valor unitário
			If nInflato < 0
				nInflato := (100 - (nInflato * -1)) / 100
				nPrcTab := nUnitNov * nInflato
		  	Else
				nInflato := (nUnitNov * nInflato) / 100
				nPrcTab  := nUnitNov + nInflato
			EndIf 
		Else
			If nInflato < 0
				nInflato := (100 - (nInflato * -1)) / 100
				nPrcTab := nPrcTab * nInflato
			Else
				nInflato := (nPrcTab * nInflato) / 100
				nPrcTab  := nPrcTab + nInflato
			EndIf
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
		If (SZ1->(dbSeek(xFilial("SZ1")+cProduto+cTabela))) .AND. (SZ1->Z1_ATIVO == "S")
			//Caso o produto esteja na promoçao........
			nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o cálculo do novo valor unitário
			If nInflato < 0
				nInflato := (100 - (nInflato * -1)) / 100
				nPrcTab := nUnitNov * nInflato
			Else
				nInflato := (nUnitNov * nInflato) / 100
				nPrcTab  := nUnitNov + nInflato
			EndIf
		Else
			If nInflato < 0
				nInflato := (100 - (nInflato * -1)) / 100
				nPrcTab := nPrcTab * nInflato
			Else
				nInflato := (nPrcTab * nInflato) / 100
				nPrcTab  := nPrcTab + nInflato
			EndIf
		EndIf
		
	ENDIF
	
ENDIF

If (aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PROMOCA" })] <> "")
	nPrcTab            := nPrcTab
	aCols[n,nPQtdVen]  := nQtdVen
	aCols[n,nPPrcVen]  := nPrcTab
	aCols[n,nPPrUnit]  := nPrcTab   //Preco de Tabela
	aCols[n,nPDesc]    := 0
	aCols[n,nPValor]   := Round(aCols[n,nPPrcVen] * nQtdVen,2)
	aCols[n,nPValDesc] := 0
	
Else
	nPrcTab            := nPrcTab
	aCols[n,nPQtdVen]  := nQtdVen
	aCols[n,nPPrcVen]  := nPrcTab
	aCols[n,nPPrUnit]  := nPrcTab   //Preco de Tabela
	aCols[n,nPDesc]    := aCols[n,nPDesc] 
	aCols[n,nPValor]   := Round(aCols[n,nPPrcVen] * nQtdVen,2)
	aCols[n,nPValDesc] := aCols[n,nPValDesc]
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurando Integridade. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAmbSE4)
RestArea(aAmbDA1)
RestArea(aArea)
Return(lRet)
