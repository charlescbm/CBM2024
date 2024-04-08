#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "RWMAKE.CH"

#DEFINE FRETE	4	// Valor total do frete

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Rdmake    ³ EFATA08  ³ Autor ³ Marcelo/Fernando      ³ Data ³ 22/10/13  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula Acrescimo de Acordo com a Condicao de Pagamento     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EFATA08(cCampo,cOrigem)
**********************************
LOCAL nPos1     := 0
LOCAL nPPrcVen  := 0
LOCAL nPValDesc := 0
LOCAL nPValor   := 0
LOCAL nPPrUnit  := 0
LOCAL nPQtdVen  := 0
LOCAL nDescont  := 0 
LOCAL nNota     := 0
LOCAL cProduto  := ""
LOCAL lRet      := .T.
LOCAL cEstNor   := Alltrim(GetMV("BR_000012")) //Estados Nordeste
LOCAL nValMinF  := GetMV("BR_000013") //Valor Minimo para Frete
LOCAL nValMinP := GetMV("BR_000022") //Valor Minimo para Pedido 
LOCAL aArea     := GetArea()
LOCAL aAmbSE4   := SE4->( GetArea() )
LOCAL aAmbDA1   := DA1->( GetArea() )

PRIVATE nInflato:= 0
PRIVATE nPrcTab := 0
PRIVATE lrpromo := .F.
PRIVATE lpromo  := .F.
PRIVATE Inflato := 0
PRIVATE nQtdVen := 0
PRIVATE L410AUTO:= .F.

If (cOrigem == "TMK") //Marcelo
	nPos1       := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_PRODUTO"  })//seta a posição da coluna do Produto
	cProduto    := aCols[n,nPos1]//seta o produto digitado
	nPPrcVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_VRUNIT"  })//seta a posição da coluna do Preco de Venda
	nPQtdVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_QUANT"   })//seta a posição da coluna da Quantidade
	nPDesc      := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_DESC"    })//seta a posição da coluna do Desconto
	nPValDesc   := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_VALDESC" })//seta a posição da coluna do Valor de Desconto
	nPValor     := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_VLRITEM" })//seta a posição da coluna do Valor
	nPPrUnit    := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_PRCTAB"  })//seta a posição da coluna do Valor Unitario 
   //nNota       := Ascan(aHeader,{|m| Alltrim(m[2]) == "UB_NOTA"    })//seta a posição da coluna da Nota
Else
	nPos1       := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"  })//seta a posição da coluna do Produto
	cProduto    := aCols[n,nPos1]//seta o produto digitado
	nPPrcVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"  })//seta a posição da coluna do Preco de Venda
	nPQtdVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"  })//seta a posição da coluna da Quantidade
	nPDesc      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })//seta a posição da coluna do Desconto
	nPValDesc   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" })//seta a posição da coluna do Valor de Desconto
	nPValor     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"   })//seta a posição da coluna do Valor
	nPPrUnit    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"  })//seta a posição da coluna do Valor Unitario
	//nNota       := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_NOTA"    })//seta a posição da coluna da Nota
Endif

nValDesc :=  aCols[n,nPValDesc]
If (cOrigem == "TMK") //Marcelo
	cCondPg := AllTrim(M->UA_CONDPG) //Marcelo
	cTabela	:= AllTrim(M->UA_TABELA) //Marcelo
Else
	cCondPg := AllTrim(M->C5_CONDPAG) //Fernando
	cTabela	:= AllTrim(M->C5_TABELA) //Fernando
Endif

//Verifica de qual campo a rotina foi chamada.
If (cCampo != Nil).and.(cCampo == "UB_PRODUTO")
	cProduto := M->UB_PRODUTO
	nQtdVen := aCols[n,nPQtdVen]
Elseif (cCampo != Nil).and.(cCampo == "C6_QTDVEN")
	nQtdVen := M->C6_QTDVEN //seta o valor constante na memória
Elseif (cCampo != Nil).and.(cCampo == "UB_QUANT")
	nQtdVen := M->UB_QUANT //seta o valor constante na memória
Else
	nQtdVen := aCols[n,nPQtdVen]
Endif

dbSelectArea("DA1")
dbSetOrder(1)
If dbSeek( XFILIAL("DA1") + cTabela + cProduto)
	nPrcTab := DA1->DA1_PRCVEN
Endif

IF l410auto <> .T.
	If !Empty(cCondPg)
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+cCondPg)
			nInflato := SE4->E4_INFLATO
		Endif
		If nInflato < 0
			nInflato := (100 - (nInflato * -1)) / 100
			nPrcTab := nPrcTab * nInflato
		Else
			nInflato := (nPrcTab * nInflato) / 100
			nPrcTab  := nPrcTab + nInflato
		Endif
	Else
		MsgStop(OemToAnsi("Condição de Pagamento não encontrada !"))
		MsgBox(OemToAnsi("Solução : Aperte (ESC) e digite a Condição de Pagamento!"))
		lret := .F.
	Endif
Else
	If !Empty(cCondPg)
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+cCondPg)
			nInflato := SE4->E4_INFLATO
		Endif
		If nInflato < 0
			nInflato := (100 - (nInflato * -1)) / 100
			nPrcTab := nPrcTab * nInflato
		Else
			nInflato := (nPrcTab * nInflato) / 100
			nPrcTab  := nPrcTab + nInflato
		Endif
	Endif
Endif
                
aCols[n,nPQtdVen]  := nQtdVen
aCols[n,nPPrcVen]  := nPrcTab
aCols[n,nPPrUnit]  := nPrcTab //Preco de Tabela
//Fernando: 13/03/14: evita zerar o conteúdo do desconto e valor de itens já faturados. Chamado 6392
//If  Empty(aCols[n,nNota])
	//aCols[n,nPDesc]    := 0 //Fernando: 03/07/13
	//aCols[n,nPValor]   := NoRound(aCols[n,nPPrcVen] * nQtdVen)
   	//aCols[n,nPValDesc] := NoRound((aCols[n,nPPrUnit] - aCols[n,nPPrcVen]) * nQtdVen)
//EndIf
aCols[n,nPValor]   := NoRound(aCols[n,nPPrcVen] * nQtdVen)
aCols[n,nPValDesc] := NoRound((aCols[n,nPPrUnit] - aCols[n,nPPrcVen]) * nQtdVen)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Atualizo variaveis Fiscais                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cOrigem == "TMK") //Marcelo
	M->UB_PRODUTO := cProduto
	MAFISREF("IT_PRODUTO","TK273",M->UB_PRODUTO)
	M->UB_VRUNIT := aCols[n,nPPrUnit]
	TK273Calcula("UB_VRUNIT")
	M->UB_VLRITEM := aCols[n,nPValor]
	MAFISREF("IT_VALMERC","TK273",M->UB_VLRITEM)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Calculo frete no pedido                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cOrigem == "TMK") //Marcelo
	cEstNor  := Alltrim(GetMV("BR_000012")) //Estados Nordeste
	nValMinF := GetMV("BR_000013") //Valor Minimo para Frete
	nValMinP := GetMV("BR_000022") //Valor Minimo para Pedido 
	aValores[FRETE] := 0
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->UA_cliente+M->UA_loja))
	 	nTotMerc := 0
	 	For nx := 1 to Len(aCols)
	 		If !(aCols[nx,Len(aCols[nx])])
	 			nTotMerc += aCols[nx,nPValor]
	 		Endif
	 	Next nx
		If (SA1->A1_est $ cEstNor).and.(nTotMerc > 0).and.(nTotMerc >= nValMinP).and.(nTotMerc <= nValMinF).and.(SA1->A1_percfre > 0)
			nTotFre := (nTotMerc*(SA1->A1_percfre/100))                 
			aValores[FRETE] := nTotFre
		Endif
	Endif
	Tk273RodImposto("NF_FRETE",aValores[FRETE])
	aObj[FRETE]:Refresh()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaurando Integridade. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAmbSE4)
RestArea(aAmbDA1)
RestArea(aArea)
Return(lRet)