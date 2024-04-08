#INCLUDE "MATR680.CH"
#INCLUDE "PROTHEUS.CH"

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o	 Ё MATR680R3Ё Autor Ё Alexandre Inacio LemesЁ Data Ё 15.03.01 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Relacao de Pedidos nao entregues							        Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso		 Ё Generico 												              Ё╠╠
╠╠цддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL. 					     Ё╠╠
╠╠цддддддддддддддбддддддддбддддддбдддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё PROGRAMADOR  Ё DATA   Ё BOPS Ё	MOTIVO DA ALTERACAO					     Ё╠╠
╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function RFATR23()

LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL cDesc1    := OemToAnsi(STR0002)	//"Este programa ira emitir a relacao dos Pedidos Pendentes,"
LOCAL cDesc2    := OemToAnsi(STR0003)	//"imprimindo o numero do Pedido, Cliente, Data da Entrega, "
LOCAL cDesc3    := OemToAnsi(STR0004)	//"Qtde pedida, Qtde ja entregue,Saldo do Produto e atraso."
LOCAL cString   := "SC6"
LOCAL tamanho   := "G"
LOCAL wnrel     := "MATR680"

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "", 1 }      //"Zebrado"###"Administracao"
PRIVATE nTamRef := Val(Substr(GetMv("MV_MASCGRD"),1,2))
PRIVATE nomeprog:= "RFATR23"
PRIVATE cPerg	:= U_CriaPerg("MTR680BR")
PRIVATE cArqTrab:= ""
PRIVATE cFilTrab:= ""
PRIVATE nLastKey:= 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas 				    	     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//AjustaSX1()
pergunte(cPerg,.F.)
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros		    			 Ё
//Ё mv_par01				// Do Pedido	                     Ё
//Ё mv_par02				// Ate o Pedido	                     Ё
//Ё mv_par03				// Do Produto				         Ё
//Ё mv_par04				// Ate o Produto					 Ё
//Ё mv_par05				// Do Cliente						 Ё
//Ё mv_par06				// Ate o cliente					 Ё
//Ё mv_par07				// Da data de entrega	    		 Ё
//Ё mv_par08				// Ate a data de entrega			 Ё
//Ё mv_par09				// Em Aberto , Todos 				 Ё
//Ё mv_par10				// C/Fatur.,S/Fatur.,Todos 			 Ё
//Ё mv_par11				// Mascara							 Ё
//Ё mv_par12				// Aglutina itens grade 			 Ё
//Ё mv_par13				// Considera Residuos (Sim/Nao)		 Ё
//Ё mv_par14				// Lista Tot.Faturados(Sim/Nao)		 Ё
//Ё mv_par15				// Salta pagina na Quebra(Sim/Nao)	     Ё
//Ё mv_par16				// Do vendedor                 		 Ё
//Ё mv_par17				// Ate o vendedor                    |
//Ё mv_par18				// Qual a moeda                      |
//Ё As proximas pertencem ao grupo MR680A que eh so para         |
//Ё Localizacoes...                                     	     Ё
//Ё mv_par18				// Movimenta stock    (Sim/Nao)	     Ё
//Ё mv_par19		 // Gen. Doc (Factura/Remito/Ent. Fut/Todos) Ё
//Ё mv_par20		        // Lista Bonificados (Sim/Nao)       Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT 					        Ё
//| aOrd = Ordems Por Pedido/Produto/Cliente/Dt.Entrega/Vendedor |
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aOrd :={"Pedido","Produto","Cliente","Dt.Entrega","Vendedor"}
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C680Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o	 Ё C680IMP	Ё Autor Ё Alexandre Incaio LemesЁ Data Ё 15.03.01 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Chamada do Relatorio 									  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso		 Ё MATR680													  Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function C680Imp(lEnd,WnRel,cString)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis   										     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL titulo    := OemToAnsi(STR0001)	//"Relacao de Pedidos nao entregues"
LOCAL dData     := CtoD("  /  /  ")
LOCAL cTotPed   := "NUM = cNum"
LOCAL CbTxt     := ""
LOCAL cabec1    := ""
LOCAL cabec2    := ""
LOCAL tamanho   := "G"
LOCAL cNumPed   := ""
LOCAL cNumCli   := ""
LOCAL limite    := 220
LOCAL CbCont    := 0
LOCAL nOrdem    := 0
LOCAL nTotVen   := 0
LOCAL nTotEnt   := 0
LOCAL nTotSal   := 0
LOCAL nTotItem  := 0
LOCAL nFirst    := 0
LOCAL nSaldo    := 0
LOCAL nValor    := 0
LOCAL nCont     := 0
LOCAL lImpTot   := .F.
LOCAL lContinua := .T.
LOCAL nMoeda    := IIF(cPaisLoc == "BRA",MV_PAR18,1)
LOCAL nTVGeral  := 0
LOCAL nTEGeral  := 0
LOCAL nTSGeral  := 0
LOCAL nTIGeral  := 0

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para Impressao do Cabecalho e Rodape	 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cbtxt   := SPACE(10)
cbcont  := 0
m_pag   := 1
li 	    := 80

nTipo   := IIF(aReturn[4]==1,15,18)
nOrdem  := aReturn[8]

Processa({|lEnd| C680Trb(@lEnd,wnRel,"TRB")},Titulo)

//                   999999 99/99/9999 999999xxxxxxxxxxxxxx/XXXXXXXX XX XXXXXXXXXXXXXXX XXXXXXXXXXXXXXX 99/99/9999 999999999999 999999999999 999999999999
//                             1         2         3         4         5         6         7         8         9        10        11        12        13
//                   012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
dbSelectArea("TRB")

Do Case
	Case nOrdem = 1
		cQuebra := "NUM = cNum"
		titulo  := titulo +" - "+ STR0007//"Por Pedido"
		cabec1  := "NUMERO  DATA DE   CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                    DATA DE        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   NUM               DATA         "
		cabec2  := "PEDIDO  EMISSAO                                                         PRODUTO         MATERIAL                        ENTREGA        PEDIDA       ENTREGUE     PENDENTE        DO ITEM.      NOTA FISCAL       EMISSAO NOTA "    
	Case nOrdem = 2
		cQuebra := "PRODUTO = cProduto"
		titulo  := titulo + " - "+STR0008 //"Por Produto"
		cabec1  := "CODIGO DO       DESCRICAO DO                   NUMERO IT DATA DE      DATA DE      CODIGO LOJA /NOME DO CLIENTE                        QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   NUM               DATA         "
		cabec2  := "PRODUTO         MATERIAL                       PEDIDO    EMISSAO      ENTREGA                                                          PEDIDA       ENTREGUE     PENDENTE        DO ITEM.      NOTA FISCAL       EMISSAO NOTA "
	Case nOrdem = 3
		cQuebra := "CLIENTE+LOJA = cCli"
		titulo  := titulo + " - "+STR0009 //"Por Cliente"
		cabec1  := "CODIGO-LOJA/NOME DO CLIENTE                        NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE      QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   NUM               DATA         "
		cabec2  := "                                                   PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA      PEDIDA       ENTREGUE     PENDENTE        DO ITEM.      NOTA FISCAL       EMISSAO NOTA "
	Case nOrdem = 4
		cQuebra := "DATENTR = dEntreg"
		titulo  := titulo + STR0018 //" - Por Data de Entrega"
		cabec1  := " DATA DE      NUMERO DATA DE      CODIGO LOJA /NOME DO CLIENTE                       IT CODIGO DO       DESCRICAO DO                   QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL   NUM               DATA         "
		cabec2  := " ENTREGA      PEDIDO EMISSAO                                                            PRODUTO         MATERIAL                       PEDIDA       ENTREGUE     PENDENTE        DO ITEM.      NOTA FISCAL       EMISSAO NOTA " 
		
	Case nOrdem = 5
		cQuebra := "VENDEDOR = cVde"
		titulo  := titulo + STR0022 //" - Por Vendedor"
		cabec1  := "CODIGO VENDEDOR                                 NUMERO IT  DATA DE      CODIGO DO       DESCRICAO DO                   DATA DE         QUANTIDADE   QUANTIDADE   QUANTIDADE      VALOR TOTAL  NUM                DATA         "
		cabec2  := "                                                PEDIDO     EMISSAO      PRODUTO         MATERIAL                       ENTREGA         PEDIDA       ENTREGUE     PENDENTE        DO ITEM.     NOTA FISCAL        EMISSAO NOTA "
EndCase

titulo += " - " + GetMv("MV_MOEDA"+STR(nMoeda,1))		//" MOEDA "
dbSelectArea("TRB")
dbGoTop()
SetRegua(RecCount())                    	// TOTAL DE ELEMENTOS DA REGUA

nFirst := 0

While !Eof() .And. lContinua
	
	IF lEnd
		@PROW()+1,001 Psay STR0021        //    "CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	IF li > 58 .Or.( MV_PAR15 = 1 .And.!&cQuebra)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Verifica campo para quebra									 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cNum	:= NUM
	cProduto:= PRODUTO
	cCli	:= CLIENTE+LOJA
	dEntreg := DATENTR
	cVde    := VENDEDOR
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Variaveis Totalizadoras     		    					 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	nSaldo  := QUANTIDADE-ENTREGUE
	nTotSal += nSaldo
	nTotVen += QUANTIDADE
	nTotEnt += ENTREGUE
    nValor  := xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
    
	If !(TRB->GRADE == "S" .And. MV_PAR12 == 1)
       nTotItem+= nValor
       nTIGeral+= nValor
    EndIf	
    
	If nTotVen > QUANTIDADE .Or. nTotEnt > ENTREGUE
		lImpTot := .T.
	Else
		lImpTot := .F.
	EndIf
	
	IF (nFirst = 0 .And. nOrdem != 4).Or. nOrdem == 4
		
		li++
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Imprime o cabecalho da linha		    					 Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		Do Case
			Case nOrdem = 1
				@li,  0 Psay NUM
				@li,  7 Psay TRB->EMISSAO
				@li, 18 Psay Left(CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI, 50)
			Case nOrdem = 2
				@li,  0 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
				@li, 16 Psay Left(TRB->DESCRICAO, 30)
			Case nOrdem = 3
				@li,  0 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
			Case nOrdem = 4
				If cNumPed+cNumCli+DtoS(dData) != NUM+CLIENTE+DtoS(DATENTR)
					@li,  1 Psay DATENTR
					@li, 14 Psay NUM
					@li, 21 Psay EMISSAO
					@li, 34 Psay Left(CLIENTE+"-"+LOJA+"/"+NOMECLI, 50)
					cNumPed := NUM
					cNumCli := CLIENTE
				Else
					li--
				EndIf
				dData := DATENTR
			Case nOrdem = 5
				@li,  0 Psay Left(TRB->VENDEDOR+" "+NOMEVEN, 47)
		EndCase
		
		IF nFirst = 0 .And. nOrdem != 4
			nFirst := 1
		Endif
		
	EndIf
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Agrutina os produtos da grade conforme o parametro MV_PAR12  |
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	IF TRB->GRADE == "S" .And. MV_PAR12 == 1
		
		cProdRef:= Substr(TRB->PRODUTO,1,nTamRef)
		
		If nOrdem = 2
			cAgrutina := "cProdRef == Substr(PRODUTO,1,nTamRef)"
		Else
			cAgrutina := cQuebra
		Endif
		
		nSaldo  := 0
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
        nValor  := 0
		nReg    := 0
		
		While !Eof() .And.xFilial("SC6") == TRB->FILIAL .And. cProdRef == Substr(PRODUTO,1,nTamRef);
			.And. TRB->GRADE == "S" .And. &cAgrutina .And. cNum == NUM
			
			nReg	 := Recno()
			
			nTotVen += QUANTIDADE
			nTotEnt += ENTREGUE
			nSaldo  += QUANTIDADE-ENTREGUE
    	    nValor  += xMoeda(VALOR,MOEDA,nMoeda,EMISSAO)
			
			dbSelectArea("TRB")
			IncRegua()
			dbSkip()
			
			lImpTot := .T.
			
		End
		
		nTotSal += nSaldo
        nTotItem+= nValor
		nTIGeral+= nValor
		If nReg > 0
			dbGoto(nReg)
			nReg :=0
		Endif
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime a linha Conforme a ordem selecionada na setprint	 Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Do Case
		Case nOrdem = 1
			@li, 69 Psay ITEM
			@li, 72 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO, 30)
			@li,119 Psay DATENTR
		Case nOrdem = 2
			@li, 47 Psay NUM
			@li, 54 Psay ITEM
			@li, 57 Psay EMISSAO
			@li, 70 Psay DATENTR
			@li, 83 Psay Left(TRB->CLIENTE+"-"+LOJA+"/"+TRB->NOMECLI,50)
		Case nOrdem = 3
			@li, 51 Psay NUM
			@li, 58 Psay ITEM
			@li, 61 Psay EMISSAO
			@li, 74 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 91 Psay Left(TRB->DESCRICAO,30)
			@li,122 Psay DATENTR
		Case nOrdem = 4
			@li, 85 Psay ITEM
			@li, 88 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamRef),PRODUTO)
			@li,104 Psay Left(TRB->DESCRICAO, 30)
		OtherWise
			@li, 48 Psay NUM
			@li, 55 Psay ITEM
			@li, 59 Psay EMISSAO
			@li, 72 Psay IIF(GRADE == "S" .And. MV_PAR12 == 1,Substr(PRODUTO,1,nTamref),PRODUTO)
			@li, 88 Psay Left(TRB->DESCRICAO,30)
			@li,119 Psay DATENTR
	EndCase
	
	@li,136 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotVen,QUANTIDADE)	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,149 Psay IIF(GRADE=="S" .And. MV_PAR12 == 1,nTotEnt,ENTREGUE)	PICTURE PesqPictQt("C6_QTDENT",12)
	@li,162 Psay nSaldo	PICTURE PesqPictQt("C6_QTDVEN",12)
	@li,176 Psay nValor	PICTURE PesqPict("SC6","C6_VALOR",12)
	@li,195 Psay NOTA	//PICTURE PesqPict("SC6","C6_VALOR",12)
	@li,210 Psay DATFAT	//PICTURE PesqPict("SC6","C6_VALOR",12)
	
	nCont++
	li++
	
	dbSelectArea("TRB")
	IncRegua()
	dbSkip()
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime o Total do Pedido                                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
    If !&cTotPed
       If nOrdem = 1 .Or. nOrdem = 3 .Or.  nOrdem = 4 .Or. (nOrdem == 5 .And. !&cQuebra)
           @Li,000 Psay STR0025
           @Li,173 Psay nTotItem PICTURE PesqPict("SC6","C6_VALOR",15)
           If nOrdem = 3 
              li+=2
           Else
              li++
           ENdif
	       nTotitem:= 0	
       EndIf
    EndIf
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Imprime o Total ou linha divisora conforme a quebra		     Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If !&cQuebra
		
		If (MV_PAR15 = 1 .And. nOrdem = 2) .Or. MV_PAR15 = 2
			
			If nOrdem = 2
				@Li,000 Psay STR0025
				@Li,136 Psay nTotVen PICTURE PesqPictQt("C6_QTDVEN",12)
				@Li,149 Psay nTotEnt PICTURE PesqPictQt("C6_QTDENT",12)
				@Li,162 Psay nTotSal PICTURE PesqPictQt("C6_QTDVEN",12)
				li++
			Endif
			
			If nTotVen > 0 .And. nOrdem != 1
				@li,  0 Psay __PrtThinLine()
				li++
			Endif
			
		Endif

		nTVGeral += nTotVen
		nTEGeral += nTotEnt
		nTSGeral += nTotSal
				
		nTotVen := 0
		nTotEnt := 0
		nTotSal := 0
		nCont   := 0
		nFirst  := 0
		
	Endif
	
End

If nTIGeral > 0        
	If li >= 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	li++
	@Li,000 Psay STR0026
	@Li,136 Psay nTVGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,149 Psay nTEGeral PICTURE PesqPictQt("C6_QTDENT",12)
	@Li,162 Psay nTSGeral PICTURE PesqPictQt("C6_QTDVEN",12)
	@Li,173 Psay nTIGeral PICTURE PesqPict("SC6","C6_VALOR",15)
EndIf

If li != 80
	Roda(cbcont,cbtxt)
Endif

dbSelectArea("TRB")
dbCloseArea()

//зддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Deleta arquivos de trabalho.                      Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддды
Ferase(cArqTrab+GetDBExtension())
Ferase(cArqTrab+OrdBagExt())
Ferase(cFilTrab+OrdBagExt())

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o	 Ё C680TRB	Ё Autor Ё Alexandre Inacio LemesЁ Data Ё 15.03.01 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё Cria Arquivo de Trabalho                             	  Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё Uso		 Ё MATR660													  Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/

Static Function C680TRB(nOrdem)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL aCampos   := {}
LOCAL aTam      := ""
LOCAL cKey      := ""
LOCAL cCondicao := ""
LOCAL cVend     := ""
LOCAL cVendedor := ""
LOCAL cAliasSC6 := "SC6"
LOCAL cPedIni   := MV_PAR01
LOCAL cPedFim   := MV_PAR02
LOCAL cProIni   := MV_PAR03
LOCAL cProFim   := MV_PAR04
LOCAL cCliIni   := MV_PAR05
LOCAL cCliFim   := MV_PAR06
LOCAL cDatIni   := MV_PAR07
LOCAL cDatFim   := MV_PAR08
LOCAL nTipVal   := IIF(cPaisLoc=="BRA",MV_PAR19,MV_PAR19)
LOCAL nSaldo    := 0
LOCAL nX        := 0
LOCAL nQtdVend  := FA440CntVen() // Retorna a quantidade maxima de Vendedores
LOCAL nValor	:= 0
LOCAL cQueryAdd := ""
Local cCodRep	:= ''

DbSelectArea("SA3")
DbSetOrder(7)

If DbSeek( xFilial("SA3") + __cUserId, .f. )
	While !Eof() .And. ( AllTrim( __cUserId ) == AllTrim( A3_CODUSR ) )
		If A3_TIPO <> 'I'
			cCodRep+= A3_COD + "','"
		EndIf	
		DbSkip()
	EndDo	
	cCodRep:= Subst( cCodRep, 1, Len ( cCodRep ) - 3 ) 
EndIf

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define array para arquivo de trabalho                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aTam:=TamSX3("C6_FILIAL")
AADD(aCampos,{ "FILIAL"    ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NUM")
AADD(aCampos,{ "NUM"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_EMISSAO")
AADD(aCampos,{ "EMISSAO"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_CLI")
AADD(aCampos,{ "CLIENTE"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A1_NOME")
AADD(aCampos,{ "NOMECLI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_LOJA")
AADD(aCampos,{ "LOJA"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_VEND1")
AADD(aCampos,{ "VENDEDOR"  ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("A3_NOME")
AADD(aCampos,{ "NOMEVEN"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ENTREG")
AADD(aCampos,{ "DATENTR"   ,"D",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEM")
AADD(aCampos,{ "ITEM"      ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_PRODUTO")
AADD(aCampos,{ "PRODUTO"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_DESCRI")
AADD(aCampos,{ "DESCRICAO" ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDVEN")
AADD(aCampos,{ "QUANTIDADE","N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_QTDENT")
AADD(aCampos,{ "ENTREGUE"  ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_GRADE")
AADD(aCampos,{ "GRADE"     ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_ITEMGRD")
AADD(aCampos,{ "ITEMGRD"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_TES")
AADD(aCampos,{ "TES"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLQ")
AADD(aCampos,{ "BLQ"       ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_BLOQUEI")
AADD(aCampos,{ "BLOQUEI"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_VALOR")
AADD(aCampos,{ "VALOR"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C5_MOEDA")
AADD(aCampos,{ "MOEDA"   ,"N",aTam[1],aTam[2] } )
aTam:=TamSX3("C6_NOTA")
AADD(aCampos,{ "NOTA"   ,"C",aTam[1],aTam[2] } )  
aTam:=TamSX3("C6_DATFAT")
AADD(aCampos,{ "DATFAT"   ,"D",aTam[1],aTam[2] } )  

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria arquivo de Trabalho                                     Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cArqTrab := CriaTrab(aCampos,.T.)
dbUseArea(.T.,,cArqTrab,"TRB",.T.,.F.)

nOrdem  := aReturn[8]

dbSelectArea("TRB")
Do Case
	Case nOrdem = 1
		IndRegua("TRB",cArqTrab,"FILIAL+NUM+ITEM+PRODUTO",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 2
		IndRegua("TRB",cArqTrab,"FILIAL+PRODUTO+NUM+ITEM",,,STR0015)       //"Selecionando Registros..."
	Case nOrdem = 3
		IndRegua("TRB",cArqTrab,"FILIAL+CLIENTE+LOJA+NUM+ITEM",,,STR0015)  //"Selecionando Registros..."
	Case nOrdem = 4
		IndRegua("TRB",cArqTrab,"FILIAL+DTOC(DATENTR)+NUM+ITEM",,,STR0015) //"Selecionando Registros..."
	Case nOrdem = 5
		IndRegua("TRB",cArqTrab,"FILIAL+VENDEDOR+NUM+ITEM",,,STR0015)      //"Selecionando Registros..."
EndCase

dbSelectArea("TRB")
dbSetOrder(1)
dbGoTop()

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica o Filtro                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SC6")
dbSetOrder(1)
	
cAliasSC6 := "MR680Trab"
aStruSC6  := SC6->(dbStruct())

cQuery    := "SELECT A3_SUPER, A3_NOME, C5_VEND1, C5_TIPO, C5_EMISSAO, C5_MOEDA, A1_NOME, C6_FILIAL, C6_NUM, C6_ITEM, C6_CLI, C6_LOJA, C6_TES, C6_PRODUTO, C6_BLQ, C6_QTDVEN, C6_QTDENT, C6_ENTREG, C6_DESCRI, C6_GRADE, C6_ITEMGRD, C6_BLOQUEI, C6_NOTA, C6_DATFAT, C6_VALOR, C6_PRCVEN "
cQuery    += "FROM SC6010 SC6 "
cQuery    += "INNER JOIN SC5010 SC5 ON SC6.C6_NUM=SC5.C5_NUM AND SC6.C6_FILIAL=SC5.C5_FILIAL AND SC5.D_E_L_E_T_='' "
cQuery    += "INNER JOIN SF4010 SF4 ON SC6.C6_TES=F4_CODIGO "+Iif(mv_par10==1,"AND F4_DUPLIC='S'",Iif(mv_par10==2,"AND F4_DUPLIC='N'",""))+" AND SF4.D_E_L_E_T_='' "
cQuery    += "INNER JOIN SA1010 SA1 ON SC6.C6_CLI=A1_COD AND SC6.C6_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery    += "LEFT  JOIN SA3010 SA3 ON SC5.C5_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery    += "WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery    += "  AND SC6.C6_NUM BETWEEN '"+cPedIni+"' AND '"+cPedFim+"' "
cQuery    += "  AND SC6.C6_PRODUTO BETWEEN '"+cProIni+"' AND '"+cProFim+"' "
cQuery    += "  AND SC6.C6_CLI BETWEEN '"+cCliIni+"' AND '"+cCliFim+"' "
cQuery    += "  AND SC6.C6_ENTREG BETWEEN '"+DtoS(cDatIni)+"' AND '"+DtoS(cDatFim)+"' "
If mv_par13 == 3
	cQuery    += "  AND SC6.C6_BLQ = 'R ' "
EndIf
If mv_par09 == 1
	cQuery    += "  AND SC6.C6_QTDENT < SC6.C6_QTDVEN "
EndIf
cQuery    += "  AND SC6.D_E_L_E_T_ = ' ' "
cQuery    += "  AND SC5.C5_TIPO NOT IN ('D','B') "

If !Empty( cCodRep )
	cQuery+= " AND SC5.C5_VEND1 IN ('" + cCodRep + "')"
Else
	cQuery+= " AND SC5.C5_VEND1 BETWEEN '"+mv_par16+"' AND '"+mv_par17+"' "	
EndIf	

cQuery	  += " AND SA3.A3_SUPER BETWEEN '"+mv_par20+"' AND '"+mv_par21+"' "

//Ponto de entrada para tratamento do filtro do usuario.
If ExistBlock("F680QRY")
	cQueryAdd := ExecBlock("F680QRY", .F., .F., {aReturn[7]})
	If ValType(cQueryAdd) == "C"
		cQuery += " AND ( " + cQueryAdd + ")"
	EndIf
EndIf

cQuery += "ORDER BY "+SqlOrder(IndexKey())
cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC6,.T.,.T.)

For nX := 1 To Len(aStruSC6)
	If ( aStruSC6[nX][2] <> "C" )
		TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
	EndIf
Next nX

dbSelectArea(cAliasSC6)

ProcRegua(RecCount())                                         // Total de Elementos da Regua

dbGoTop()

While !Eof() 
	
	If (Empty(aReturn[7]) .Or. &(aReturn[7]))
		
		//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё Verifica se esta dentro dos parametros						 Ё
		//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		lRet:=ValidMasc((cAliasSC6)->C6_PRODUTO,MV_PAR11)
		
		If Alltrim((cAliasSC6)->C6_BLQ) == "R" .and. mv_par13 == 2 // Se Foi Eliminado Residuos
			nSaldo  := 0
		Else
			nSaldo  := C6_QTDVEN-C6_QTDENT
		Endif
		
		If ((nSaldo==0 .And. MV_PAR14==1 .And. Alltrim((cAliasSC6)->C6_BLQ)<>"R").Or. nSaldo <> 0) .And. lRet
			If nOrdem = 5
				If !EMPTY((cAliasSC6)->C5_VEND1) 
					
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE VENDEDOR   WITH (cAliasSC6)->C5_VEND1
					REPLACE NOMEVEN    WITH (cAliasSC6)->A3_NOME
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH Iif(!Empty((cAliasSC6)->C5_EMISSAO),StoD((cAliasSC6)->C5_EMISSAO),CtoD("  /  /  "))  
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH (cAliasSC6)->A1_NOME
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI 
					REPLACE NOTA       WITH (cAliasSC6)->C6_NOTA
					REPLACE DATFAT     WITH (cAliasSC6)->C6_DATFAT
					
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR						
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf							
					REPLACE VALOR      WITH nValor
					REPLACE MOEDA      WITH (cAliasSC6)->C5_MOEDA
					MsUnLock()
					
				Endif
			
			Else

				If !EMPTY((cAliasSC6)->C5_VEND1) 
				
					dbSelectArea("TRB")
					RecLock("TRB",.T.)
					
					REPLACE FILIAL     WITH (cAliasSC6)->C6_FILIAL
					REPLACE NUM        WITH (cAliasSC6)->C6_NUM
					REPLACE EMISSAO    WITH Iif(!Empty((cAliasSC6)->C5_EMISSAO),StoD((cAliasSC6)->C5_EMISSAO),CtoD("  /  /  "))  
					REPLACE CLIENTE    WITH (cAliasSC6)->C6_CLI
					REPLACE NOMECLI    WITH (cAliasSC6)->A1_NOME
					REPLACE LOJA       WITH (cAliasSC6)->C6_LOJA
					REPLACE DATENTR    WITH (cAliasSC6)->C6_ENTREG
					REPLACE ITEM       WITH (cAliasSC6)->C6_ITEM
					REPLACE PRODUTO    WITH (cAliasSC6)->C6_PRODUTO
					REPLACE DESCRICAO  WITH (cAliasSC6)->C6_DESCRI
					REPLACE QUANTIDADE WITH (cAliasSC6)->C6_QTDVEN
					REPLACE ENTREGUE   WITH (cAliasSC6)->C6_QTDENT
					REPLACE GRADE      WITH (cAliasSC6)->C6_GRADE
					REPLACE ITEMGRD    WITH (cAliasSC6)->C6_ITEMGRD
					REPLACE TES        WITH (cAliasSC6)->C6_TES
					REPLACE BLQ        WITH (cAliasSC6)->C6_BLQ
					REPLACE BLOQUEI    WITH (cAliasSC6)->C6_BLOQUEI
					REPLACE NOTA       WITH (cAliasSC6)->C6_NOTA
					REPLACE DATFAT     WITH (cAliasSC6)->C6_DATFAT
					
					If nTipVal == 1 //--  Imprime Valor Total do Item
						nValor:=(cAliasSC6)->C6_VALOR						
					Else
						//--  Imprime Saldo
						If TRB->QUANTIDADE==0
							nValor:=(cAliasSC6)->C6_VALOR
						Else
							nValor := (TRB->QUANTIDADE - TRB->ENTREGUE) * (cAliasSC6)->C6_PRCVEN
							nValor := If(nValor<0,0,nValor)
						EndIf
					EndIf						
					REPLACE VALOR      WITH nValor
					REPLACE MOEDA      WITH (cAliasSC6)->C5_MOEDA
					MsUnLock()
					
				EndIf
			EndIf
		EndIf
	EndIf
	
	dbSelectArea(cAliasSC6)
	IncProc()
	dbSkip()
EndDo

#IFDEF TOP
	dbSelectArea(cAliasSC6)
	dbClosearea()
	dbSelectArea("SC6")
#ELSE
	dbSelectArea("SC6")
	RetIndex("SC6")
#ENDIF

Return