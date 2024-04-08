# INCLUDE "RWMAKE.CH"

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � EFATA08  � Autor �                       � Data �   /  /    ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula Acrescimo de Acordo com a Condicao de Pagamento     ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
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

nPos1       := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO"  })//seta a posi��o da coluna do Produto
cProduto    := aCols[n,nPos1]//seta o produto digitado
nPPrcVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN"  })//seta a posi��o da coluna do Preco de Venda
nPQtdVen    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN"  })//seta a posi��o da coluna da Quantidade 
nPDesc      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" })//seta a posi��o da coluna do Desconto
nPValDesc   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" })//seta a posi��o da coluna do Valor de Desconto
nPValor     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR"   })//seta a posi��o da coluna do Valor
nPPrUnit    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT"  })//seta a posi��o da coluna do Valor Unitario

nValDesc :=  aCols[n,nPValDesc] 
cTabela	   := AllTrim(C5_TABELA) //Fernando
cCliente   := AllTrim(C5_CLIENTE)

//Verifica de qual campo a rotina foi chamada.
If cCampo == "C6_QTDVEN"
	nQtdVen := M->C6_QTDVEN //seta o valor constante na mem�ria
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
//cCodigo := SZ1->Z1_CODIGO //captura o c�digo da promo��o
//cTitulo := SZ1->Z1_TITULO //captura o nome da promo��o
cTabProm:= SZ1->Z1_TABELA  //captura a tabela de preco cadastrada no SZ1
nDescMax:= SZ1->Z1_DESCONT //captura qual o desconto m�ximo que pode ser dado
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
		.AND. (aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PROMOCA" })] <> "")//verifica se o produto + tabela de pre�o est�o na SZ1
			//Caso o produto esteja na promo�ao........
			nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o c�lculo do novo valor unit�rio
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
		MsgStop(OemToAnsi("Condi��o de Pagamento n�o encontrada !"))
		MsgBox(OemToAnsi("Solu��o : Aperte (ESC) e digite a Condi��o de Pagamento!"))
		lret := .F.
	EndIf
	
ELSE
	
	If !Empty(M->C5_CONDPAG)
		
		dbSelectArea("SE4")
		dbSetOrder(1)
		If dbSeek(xFilial("SE4")+M->C5_CONDPAG)
			nInflato := SE4->E4_INFLATO
		EndIf
		
		//verifica situa��o do campo Inflator
		If (SZ1->(dbSeek(xFilial("SZ1")+cProduto+cTabela))) .AND. (SZ1->Z1_ATIVO == "S")
			//Caso o produto esteja na promo�ao........
			nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o c�lculo do novo valor unit�rio
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


//��������������������������Ŀ
//� Restaurando Integridade. �
//����������������������������
RestArea(aAmbSE4)
RestArea(aAmbDA1)
RestArea(aArea)
Return(lRet)
