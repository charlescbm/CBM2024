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
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! M410LIOK                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de Entrada Valida��o de Linha no Pedido de Vendas !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/02/2012                                              !
+------------------+---------------------------------------------------------+
*/
User Function M410LIOK()
************************

/********************************************** DECLARACAO DAS VARIAVEIS ******************************************/
Private cProduto	    := ""
Private cTes          := ""
Private cEntrega      := ""
Private cEmissao      := ""
Private cTipo		    := ""
Private cCliente	    := ""
Private cProd		    := ""
Private cProdZ		    := ""
Private cPedido		 := ""
Private cProduto      := "" 
Private cTabProm      := "" 
Private cUsuario      := AllTrim(USRRETNAME(RETCODUSR())) //Captura usu�rio logado.
Private cParam        := GETMV("BR_000001")//Usuario com permiss�o para usar TES que n�o atualiza estoque
Private nDesPerm      := GETMV("BR_000002")//Percentual m�ximo de desconto    
Private cUsrDesc      := GETMV("BR_000005")//Usu�rio com permiss�o para impor desconto maior que o percentual m�ximo 
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
Private nPos1		    := 0
Private nPos2		    := 0
Private nPos3		    := 0
Private nPos4		    := 0
Private nPos5		    := 0
Private nPos6		    := 0  
Private nPos7		    := 0 
Private nPos8		    := 0  
Private nPos9		    := 0  
Private nPos10		    := 0 
Private nPos11		    := 0 
Private nPos12		    := 0 
Private nPos13		    := 0 
Private nResto        := 0
Private lRet		    := .T.   
Private lPromo        := .F.
Private cEstoque      := 'S'
Private cCond         := M->C5_CONDPAG  

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
nPos11     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_LOCAL" })  // Posicao do Campo na Matriz
cLocal     := AllTrim(aCols[n,nPos11]) //Grava na variavel 
nPos12     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_CLASFIS" })  // Posicao do Campo na Matriz
cClasfis   := AllTrim(aCols[n,nPos12]) //Grava na variavel 
nPos13     := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_FCICOD" })  // Posicao do Campo na Matriz
If (nPos13 > 0)
	cFCICod := AllTrim(aCols[n,nPos13]) //Grava na variavel 
Else
	cFCICod := Space(TamSX3("C6_FCICOD")[1])
Endif

nQuantEnt  := GDFieldGet("C6_QTDENT")
cTabela	  := AllTrim(M->C5_TABELA) 
cCliente   := AllTrim(M->C5_CLIENTE)

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+cProd)

/******************************************** Valida se a Cond.Pag esta Ativa ***************************/
If lRet .And. SE4->E4_STATUS == 'I'
	Help("",1,"BRASCOLA",,OemToAnsi("Esta Cond.Pag est� INATIVA. Favor utilizar outra Condi��o de Pagamento!"),1,0) 
	lRet := .F.	 	
	Return(lRet)
EndIf

/******************************************** Valida Codigo FCI de acordo com classificacao *************/
If lRet .And. (SB1->B1_prodsbp == "C") .And. Empty(cFCICod) .And. ((cClasfis >= "300".and.cClasfis <= "390").or.(cClasfis >= "500".and.cClasfis <= "590").or.(cClasfis >= "800".and.cClasfis <= "890"))
	Help("",1,"BRASCOLA",,OemToAnsi("Para revenda e classifica��es fiscais 300-390, 500-590 e 800-890, o c�digo da FCI deve ser informado no pedido de venda!"),1,0) 
	lRet := .F.	 	
	Return(lRet)
EndIf

/******************************************** VALIDA��O DO PERCENTUAL DE DESCONTO ***************************/

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
	    nComis :=  nComisVend
	/*Case (nDescon >= nDesPerm) .AND. (!cUsuario $ cUsrDesc)//alterado Fernando
		MsgStop("Desconto n�o permitido! Deve ser menor que "+Alltrim(Str(nDesPerm))+"%")
		lRet := .F.
		Return(lRet)*/
EndCase

/******************************************** PROMO��O EXTRA FINAL DE DEZEMBRO 2012 **************************ADICIONADO POR CHARLES - 04/12/2012 */

If Alltrim(SB1-> B1_GRUPO) == '01'
	Do Case 
		Case M->C5_EMISSAO <= stod('20121215') .AND. cEntrega <= stod('20121225') .AND. !M->C5_VEND1 = 'V00066'
			nComis:= nComis+(nComis/4)
	Endcase
Endif
	
/******************************************** PROMO��O EXTRA FINAL DE DEZEMBRO 2012 ****************************************************************/ 

If cTipo == 'I' .OR. nComisVend == 0
	nComis := 0
EndIf

aCols[n,nPos4]:= nComis   


/******************************************** VALIDA��O DA TES QUANDO N�O ATUALIZA ESTOQUE ***************************/
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
		Help("",1,"BRASCOLA",,OemToAnsi("TES "+cTes+" n�o atualiza estoque. Usuario sem permissao para utiliza-la!"),1,0) 
		lRet := .F.
		Return(lRet)
	EndIf
EndIf


/******************************************** VALIDA��O DA DATA DE ENTREGA ***************************/
If Altera //verifica se no aRotina foi clicado no bot�o Alterar
	lRet := .T.
Else
	If FunName() == 'MATA416'	
		For nX := 1 to Len(aCols)
			If cEntrega < dDataBase
				aCols[nX,nPos2]:= dDataBase
			EndIf
		Next nX
	Else
		/*
		If (cEntrega == dDataBase)
		  SB2->(dbSetOrder(1))
		  If SB2->(dbSeek(xFilial("SB2")+cProdZ+cLocal)).and.(nQuantVend > (SB2->B2_qatu-SB2->B2_qemp))
				Help("",1,"BRASCOLA",,OemToAnsi("Produto nao possui saldo em estoque para atender este item Hoje ("+dtoc(dDataBase)+")."),1,0) 
				lRet := .F.
				Return(lRet)
		  Endif
		Elseif (cEntrega < dDataBase)
		*/
		If (cEntrega < dDataBase)
			Help("",1,"BRASCOLA",,OemToAnsi("Nao � permitido implantar Pedidos de Venda com Data de Entrega menor que a Data Atual"),1,0) 
			lRet := .F.
			Return(lRet)
		Else
			lRet := .T.
		EndIf
	EndIf
EndIf


/**********VALIDA��O SE JA CONSTA PRODUTO VENDIDO NO MES PARA O MESMO CLIENTE COM A MESMA QUANT.****************/
/*
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

aQuery:= GetLastQuery()//funcao que mostra todas as informa��es da query, util para visualizar na aba Comandos

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
		" j� foi incluso nos �ltimos 30 dias, nos Pedido Nr.: "+cPedido+;
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
*/
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
	Aviso("Produto promocional","N�o permitido mais descontos.",{"OK"})
Else
	lPromo  := .T.
EndIf   

Return lPromo  


