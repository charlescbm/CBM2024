/******************************************** VERIFICA CADASTRO DE PROMOCAO ***************************/ 
//Funcao para verificar no campo desconto
/*User Function BFATG003(cTipoRet) 
                    
Local cProd    := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" })]
Local cTab     := AllTrim(C5_TABELA)
Local cCli     := AllTrim(C5_CLIENTE)

DbSelectArea("SC6")

nPos1      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_TES"     }) // Posicao do Campo na Matriz
cTes       := AllTrim(aCols[n,nPos1])  //Grava na variavel

nPos2      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ENTREG"  }) // Posicao do Campo na Matriz
cEntrega   := aCols[n,nPos2] //Grava na variavel

nPos3      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCONT" }) // Posicao do Campo na Matriz
nDescon    := aCols[n,nPos3] //Grava na variavel

nPos4      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_COMIS1" }) // Posicao do Campo na Matriz
nComis     := aCols[n,nPos4] //Grava na variavel

nPos5      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" }) // Posicao do Campo na Matriz
nQuantVend := aCols[n,nPos5] //Grava na variavel
         
nPos6      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" }) // Posicao do Campo na Matriz
cProd      := AllTrim(aCols[n,nPos6]) //Grava na variavel 
cProdZ     := aCols[n,nPos6]//Grava na variavel   

nPos7      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" }) // Posicao do Campo na Matriz
nPrcVend   := aCols[n,nPos7] //Grava na variavel     

nPos8      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR" }) // Posicao do Campo na Matriz
nTotal     := aCols[n,nPos8] //Grava na variavel    

nPos9      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALDESC" }) // Posicao do Campo na Matriz
nValDesc   := aCols[n,nPos9] //Grava na variavel 

nPos10     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRUNIT" }) // Posicao do Campo na Matriz
nPrcUnit   := aCols[n,nPos10] //Grava na variavel

nQuantEnt  := C6_QTDENT 
cTabela	   := AllTrim(C5_TABELA) 
cCliente   := AllTrim(C5_CLIENTE)	   



dbSelectArea("DA1")
dbSetOrder(1)

If DA1->(dbSeek(xFilial("DA1")+cTabela+cProd))//posiciona na tabela de pre�o x produto
	nPrcTab := DA1->DA1_PRCVEN //captura o pre�o da tabela de pre�os
EndIf

dbSelectArea("SZ1")
dbSetOrder(2)

If (SZ1->(dbSeek(xFilial("SZ1")+cProdZ+cTabela))) .AND. (SZ1->Z1_ATIVO == "S")//verifica se o produto + tabela de pre�o est�o na SZ1
	//Verifica de qual campo a rotina foi chamada.
	If cCampo == "C6_PRODUTO"
		If MsgYesNo("Produto "+AllTrim(cProdZ)+" esta marcado como item promocional."+chr(10)+chr(13)+;
			"Confirmar para este item?")
			
			lRet   := .F.
			
			dbSeek(xFilial("SZ1")+cProdZ+cTabela)//posiciona o produto na tabela SZ1
			cCodigo := SZ1->Z1_CODIGO //captura o c�digo da promo��o
			cTitulo := SZ1->Z1_TITULO //captura o nome da promo��o
			cTabProm:= SZ1->Z1_TABELA  //captura a tabela de preco cadastrada no SZ1
			nDescMax:= SZ1->Z1_DESCONT //captura qual o desconto m�ximo que pode ser dado
			cDataDe := SZ1->Z1_DATADE //captura a data inicial da validade
			
			If cTabProm == cTabela //se tabela de preco posicionada na SZ1 for igual a Tabela de Pre�o posicionada na DA1
				cProduto := SZ1->Z1_PRODUTO //captura c�digo do produto da SZ1
				nDesPro  := SZ1->Z1_DESCPR //captura o desconto promocional na SZ1
				nUnit    := nPrcTab //guarda valor Unit�rio que estava no aCols
				nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o c�lculo do novo valor unit�rio
				nTotal   := (nUnitNov * nQuantVend) //faz o c�lculo do novo Total
				If nPrcTab == nUnit //se valor unit�rio na Tabela de Pre�o for igual ao Valor Unit�rio no aCols
					aCols[n,nPos3] := 0
					aCols[n,nPos7] := nUnitNov //preenche a coluna Preco de Venda com o novo valor unit�rio
					aCols[n,nPos10]:= nUnitNov//preenche a coluna Preco Unitario com o novo valor
					aCols[n,nPos8] := Round(nTotal,2) //preenche a coluna Valor Total com o novo Valor Total
					aCols[n,nPos9] := 0
					GETDREFRESH()
					SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
					oGetDad:Refresh()
				EndIf
			EndIf
		Else //se n�o confirma a promo��o
			
			lRet  := .T.
			
			nUnit  := nPrcTab //guarda valor Unit�rio que estava no aCols
			nUnitNov := nUnit - ((nUnit * nDescon)/100) //faz o c�lculo do novo valor unit�rio
			nTotal := (nUnitNov * nQuantVend) //faz o c�lculo do novo Total
			If nPrcTab == nUnit //se valor unit�rio na Tabela de Pre�o for igual ao Valor Unit�rio no aCols
				aCols[n,nPos3] := nDescon
				aCols[n,nPos7] := nUnitNov //preenche a coluna Preco de Venda com o anitgo valor unit�rio
				aCols[n,nPos8] := Round(nTotal,2) //preenche a coluna Valor Total com o novo Valor Total
				aCols[n,nPos10]:= nUnitNov//preenche a coluna Preco Unitario com o novo valor
				aCols[n,nPos9] := (nTotal * nDescon)/100
				GETDREFRESH()
				SetFocus(oGetDad:oBrowse:hWnd) // Atualizacao por linha
				oGetDad:Refresh()
			EndIf
		EndIf
	EndIf
Else
	Return lRet
EndIf

	 

If cTipoRet == "N"
   Return nUnitNov
Else
   Return lRet
EndIf       */