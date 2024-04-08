#Include "Rwmake.ch"
#Include "Topconn.ch"
#Include "Colors.ch"
#Include "Protheus.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! M410LIOK                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de Entrada Validação de Linha no Pedido de Vendas !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/02/2012                                              !
+------------------+---------------------------------------------------------+
*/
User Function M410LIOK()
************************

/********************************************** DECLARACAO DAS VARIAVEIS ******************************************/
Private cProduto	  := ""
Private cTes          := ""
Private cEntrega      := ""
Private cEmissao      := ""
Private cTipo		  := ""
Private cCliente	  := ""
Private cProd		  := ""
Private cProdZ		  := ""
Private cPedido		  := ""
Private cProduto      := "" 
Private cTabProm      := "" 
Private cUsuario      := AllTrim(USRRETNAME(RETCODUSR())) //Captura usuário logado.
Private cParam        := GETMV("BR_000001")//Usuario com permissão para usar TES que não atualiza estoque
Private nDesPerm      := GETMV("BR_000002")//Percentual máximo de desconto
Private nDescon       := 0
Private nComis        := 0
Private nComisVend    := 0
Private nQuantVend    := 0
Private nQuantEnt     := 0  
Private nPrcVend      := 0.0
Private nPrcUnit      := 0.0
Private nDesPro       := 0
Private nUnitNov      := 0.0
Private nUnit         := 0.0 
Private nTotal        := 0.0  
Private nDescMax      := 0.0 
Private nValDesc      := 0.0
Private nDescC6       := 0.0
Private nPos1		  := 0
Private nPos2		  := 0
Private nPos3		  := 0
Private nPos4		  := 0
Private nPos5		  := 0
Private nPos6		  := 0  
Private nPos7		  := 0 
Private nPos8		  := 0  
Private nPos9		  := 0  
Private nPos10		  := 0 
Private nResto        := 0
Private lRet		  := .T.   
Private lPromo        := .F.
Private cEstoque      := 'S' 


DbSelectArea("SC6")
//dbGoTop()

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


/******************************************** VERIFICA CADASTRO DE PROMOCAO ***************************/ 

dbSelectArea("SA1")
dbSetOrder(1)
//dbGoTop()  
If SA1->(dbSeek(xFilial("SA1")+cCliente))//posiciona no Cliente selecionado no pedido 
	cGrpCli:= SA1->A1_GRPVEN
	If SA1->A1_PROMOCA == '1'
		lCliProm := .T. //verifica se o cliente esta incluso na promocao
	Else
		lCliProm := .F.
	EndIf
EndIf

dbSelectArea("SZ1")
dbSetOrder(2)
//dbGoTop()     

SZ1->(dbSeek(xFilial("SZ1")+cProdZ+cTabela))
cGrpProm:= SZ1->Z1_GRUPO

If (SZ1->(dbSeek(xFilial("SZ1")+cProdZ+cTabela))) .AND. (lCliProm == .T.) .AND. (SZ1->Z1_ATIVO == "S") .AND. (cGrpCli == cGrpProm)//verifica se o produto + tabela de preço estão na SZ1

	dbSeek(xFilial("SZ1")+cProdZ+cTabela)//posiciona o produto na tabela SZ1
	cTabProm:= SZ1->Z1_TABELA  //captura a tabela de preco cadastrada no SZ1
	nDescMax:= SZ1->Z1_DESCONT //captura qual o desconto máximo que pode ser dado
	cDataDe := SZ1->Z1_DATADE //captura a data inicial da validade
	
	dbSelectArea("DA1")
	dbSetOrder(1) 
	//dbGoTop()
	If DA1->(dbSeek(xFilial("DA1")+cTabela+cProd))//posiciona na tabela de preço x produto
		nPrcTab := DA1->DA1_PRCVEN //captura o preço da tabela de preços
	EndIf     

	If cTabProm == cTabela //se tabela de preco posicionada na SZ1 for igual a Tabela de Preço posicionada na DA1
		cProduto := SZ1->Z1_PRODUTO //captura código do produto da SZ1
		nDesPro  := SZ1->Z1_DESCPR //captura o desconto promocional na SZ1
		nUnit    := nPrcTab //guarda valor Unitário que estava no aCols
		nUnitNov := nPrcTab - ((nPrcTab * nDesPro)/100) //faz o cálculo do novo valor unitário
		nTotal   := nUnitNov * nQuantVend //faz o cálculo do novo Total
		If nPrcTab == nUnit //se valor unitário na Tabela de Preço for igual ao Valor Unitário no aCols
			aCols[n,nPos7] := nUnitNov //preenche a coluna Preco de Venda com o novo valor unitário
			aCols[n,nPos8] := nTotal //preenche a coluna Valor Total com o novo Valor Total
			aCols[n,nPos10]:= nUnitNov//preenche a coluna Preco Unitario com o novo valor
		EndIf
	EndIf
EndIf     


/******************************************** VALIDAÇÃO DO PERCENTUAL DE DESCONTO ***************************/

DbSelectArea("SC5")
dbGoTop()
nComisVend := M->C5_COMIS1
cTipo      := AllTrim(M->C5_TIPO)
cEmissao   := dtos(M->C5_EMISSAO)
cCliente   := AllTrim(M->C5_CLIENTE)

Do Case
	Case (nDescon >= 0 .AND. nDescon <= 5)
		nComis :=  nComisVend + 2
	Case (nDescon > 5 .AND. nDescon <= 10)
		nComis :=  nComisVend + 1
	Case (nDescon > 10 .AND. nDescon < nDesPerm)
		nComis :=  nComisVend
	Case (nDescon >= nDesPerm)
		MsgStop("Desconto não permitido! Deve ser menor que "+Alltrim(Str(nDesPerm))+"%")
		lRet := .F.
		Return(lRet)
EndCase

If cTipo == 'I' .OR. nComisVend == 0
	nComis := 0
EndIf

aCols[n,nPos4]:= nComis   


/******************************************** VALIDAÇÃO DA TES QUANDO NÃO ATUALIZA ESTOQUE ***************************/
DbSelectArea("SF4")
DbSetOrder(1)
If DbSeek(XFILIAL("SF4")+cTes)
	cEstoque := F4_ESTOQUE
EndIf

If cEstoque == 'S'
	lRet := .T.
Else
	If cUsuario $ cParam
		lRet := .T.
	Else
		MsgBox("TES " + cTes + " não atualiza estoque. Usuário sem permissão para utilizá-la!" )
		lRet := .F.
		Return(lRet)
	EndIf
EndIf


/******************************************** VALIDAÇÃO DA DATA DE ENTREGA ***************************/
If Altera //verifica se no aRotina foi clicado no botão Alterar
	lRet := .T.
Else
	If FunName() == 'MATA416'	
		For nX := 1 to Len(aCols)
			If cEntrega < (dDataBase + 5)
				aCols[nX,nPos2]:= (dDataBase + 5)
			EndIf
		Next nX
	Else
		If cEntrega < (dDataBase + 5)
			MsgBox("Não é permitido implantar Pedidos de Venda com Data de Entrega";
			+chr(13)+chr(10)+"menor que 5 (cinco) dias considerando a Data Atual" )
			lRet := .F.
			Return(lRet)
		Else
			lRet := .T.
		EndIf
	EndIf
EndIf


/**********VALIDAÇÃO SE JA CONSTA PRODUTO VENDIDO NO MES PARA O MESMO CLIENTE COM A MESMA QUANT.****************/

cAlias:= GetNextAlias()

BeginSql alias cAlias
	COLUMN C5_EMISSAO AS DATE
	SELECT C5_NUM
	FROM %table:SC5% C5, %table:SC6% C6
	WHERE C6_FILIAL  = %xfilial:SC6%
	AND C5_NUM = C6_NUM
	AND C5_FILIAL = C6_FILIAL
	AND C5_CLIENTE = C6_CLI
	AND C5.%notDel%
	AND C6.%notDel%
	AND C5_CLIENTE = %exp:cCliente%
	AND (C5_EMISSAO >= GETDATE() - 30) AND (C5_EMISSAO <= GETDATE())
	AND C6_PRODUTO = %exp:cProd%
	AND C6_QTDVEN  = %exp:AllTrim(Str(nQuantVend))%
EndSql

aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos

dbSelectArea(cAlias)
dbGotop()

aPedidos:= {}

While (cAlias)->(!Eof())
	aADD(aPedidos,(cAlias)->C5_NUM)//adiciona no array todos os pedidos localizados
	DbSkip()
End

cPedido:= ""

For i:= 1 to len(aPedidos)
	cPedido+= aPedidos[i] + "," //alimenta a variavel com todos os Pedidos pesquisados
Next i

cPedido:= Substr(cPedido,1,len(cPedido)-1) //tira a ultima virgula no final da string

If cPedido <> ''
	If MsgYesNo("Produto: "+cProd+" com quantidade: "+AllTrim(Str(nQuantVend))+;
		" para o Cliente: "+cCliente+;
		" já foi incluso nos últimos 30 dias, nos Pedido Nr.: "+cPedido+;
		". Deseja continuar?")
		lRet:= .T.
	Else
		lRet:= .F.
		Return(lRet)
	EndIf
Else
	lRet:= .T.	
EndIf


dbSelectArea((cAlias))
//dbCloseArea()  

Return(lRet)   


//Funcao usada no gatilho do campo C6_DESCONT para verificar se o produto esta em promocao
//******************************************************************************************************************
User Function DescPro()   

dbSelectArea("SA1")
dbSetOrder(1) 
dbGoTop()

cProd  := aCols[n,Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" })]
cTab   := AllTrim(C5_TABELA)
cCli   := AllTrim(C5_CLIENTE)
lPromo := .T.

If SA1->(dbSeek(xFilial("SA1")+cCli))//posiciona no Cliente selecionado no pedido
	If SA1->A1_PROMOCA == '1'
		lCliProm := .T. //captura se o cliente esta incluso na promocao
	Else
		lCliProm := .F.
	EndIf
EndIf

dbSelectArea("SZ1")
dbSetOrder(2) 

If (SZ1->(dbSeek(xFilial("SZ1")+cProd+cTab))) .AND. (lCliProm == .T.)
	lPromo  := .F.
	Aviso("Produto promocional","Não permitido mais descontos.",{"OK"})
Else
	lPromo  := .T.
EndIf   

Return lPromo                