#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATR019 º Autor ³ Marcelo da Cunha   º Data ³  06/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Comissao por Representante                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 e MP11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BFATR019()
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1  := OemToAnsi( "Este relatorio ir  emitir a Previs„o das" )
LOCAL cDesc2  := OemToAnsi( "Comiss”es a Serem pagas." )
LOCAL cDesc3  := "Relatorio de Previsao de Comissao por Representante"
LOCAL titulo  := "Relatorio de Previsao de Comissao por Representante"
LOCAL cPict   := ""
LOCAL nLin    := 80
LOCAL Cabec1  := "PRF TITULO       P   CODIGO/LJ       NOME                                       DATA DE    DATA               VALOR        COMISSAO    VALOR BASE %COMIS   VALOR TOTAL P/C"
LOCAL Cabec2  := "    PEDIDO           CLIENTE                                                    EMISSAO    VENCTO            TITULO         P/BAIXA      P/ BAIXA  TOTAL   DA COMISSAO    "
LOCAL imprime := .T.
LOCAL aOrd    := {}
LOCAL aRegs   := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 220
PRIVATE tamanho      := "G"
PRIVATE nomeprog     := "BFATR019" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "BFATR019" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "SE1"
PRIVATE cPerg        := "BFATR019"
PRIVATE cRepres      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRegs := {}
AADD(aRegs,{cPerg,"01","Vencimento De  ?","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Vencimento Ate ?","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Vendedor De    ?","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"04","Vendedor Ate   ?","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"05","Cliente De     ?","mv_ch5","C",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"06","Cliente Ate    ?","mv_ch6","C",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"07","Loja De        ?","mv_ch7","C",04,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Loja Ate  e    ?","mv_ch8","C",04,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","% Aliquota IR  ?","mv_ch9","N",06,2,0,"G","","MV_PAR09","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Tipo Comissao  ?","mv_chA","N",01,0,1,"C","","MV_PAR10","Pendentes","","","Confirmadas","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs) //Brascola
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDEFAULT(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***********************************************
LOCAL CbTxt,CbCont
LOCAL tamanho :="G"
LOCAL aCampos :={}
LOCAL cVendAnt:=Space(6)
LOCAL nComissao:=0.00
LOCAL nValTit :=0.00
LOCAL nComEnt :=0.00
LOCAL nComVen :=0.00
LOCAL nValBas :=0.00
LOCAL nPorc   :=0.00
LOCAL nVendComis :=0.00
LOCAL nTotTit :=0.00
LOCAL nTotEnt :=0.00
LOCAL nTotVen :=0.00
LOCAL nTotBas :=0.00
LOCAL nTotComis :=0.00
LOCAL lFirst:=.T.
LOCAL aParcelas := {}	// Array das comissoes (geral)
LOCAL aParcItem := {}	// Array das comissoes (item)
LOCAL nVendSC5 := 0		// Codigo do vendedor no pedido
LOCAL nComiSC5 := 0		// Percentual Comissao no pedido
LOCAL nComiSC6 := 0		// Percentual comissao no item do pedido
LOCAL nPerComE := 0		// Percentual comissao na emissao vendedor
LOCAL nPerComB	:= 0		// Percentual comissao na Baixa vendedor
LOCAL nRegSC6	:= 0		// Registro do item de pedido
LOCAL nQtdItem := 0		// Quantidade de produtos nao entregues
LOCAL nPercItem:= 0		// Percentual a ser usado (pedido ou item)
LOCAL nVlTotPed:= 0		// Valor total do pedido nao entregue
LOCAL nIrEnt	:= 0		// Ir na Emissao
LOCAL nIrVen	:= 0		// Ir na Baixa
LOCAL nVendIr	:= 0		// total de Ir do vendedor
LOCAL nTotIrE	:= 0		// Total geral de IR na emissao
LOCAL nTotIrB	:= 0		// Total geral de IR na Baixa
LOCAL nTotIrVen:= 0		// Total geral de IR do relatorio
LOCAL nTotPorc := 0		// Percentual medio de comissoes do relatorio
LOCAL nTotCount:= 0
LOCAL nCount	:= 0
LOCAL nTotAbat := 0
LOCAL aTam		:= {}
LOCAL aColu		:= {}
LOCAL nValMinRet := 0   // Valor minimo para retencao do IR
LOCAL nMoedaBco :=1, dDataConv
LOCAL cTipo
LOCAL cParcela
LOCAL cPrefixo
LOCAL cNum
LOCAL cTipoFat
LOCAL nBaseCom
LOCAL nValorFat
LOCAL nCond
LOCAL JX
LOCAL nIrrItem := 0
LOCAL nInsItem := 0
LOCAL nPisItem := 0
LOCAL nCofItem := 0
LOCAL nCslItem := 0
LOCAL nIcmItem := 0
LOCAL nIssItem := 0
LOCAL nSolItem := 0
LOCAL nRecOri	:= 0
LOCAL nItem		:= 0
LOCAL nTotImp	:= 0
LOCAL nVendTit
LOCAL aVendedor
LOCAL nRecPrinc, nx1, ny1
LOCAL cChaveSE5, cIndexSE5

// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
LOCAL lComiLiq := SuperGetMv("MV_COMILIQ",,"1") == "2"

PRIVATE nDecs := MsDecimais(1)
PRIVATE nIndexSE5

// criação do indice temporario pra busca do numero da fatura
//***************************************
cChaveSE5  := "E5_FILIAL + E5_FATURA"
dbSelectArea("SE5")
cIndexSE5 := CriaTrab(nil,.f.)
IndRegua("SE5",cIndexSE5,cChaveSE5,,,OemToAnsi("Selecionando Registros..."))
nIndexSE5 := RetIndex("SE5")
dbSelectArea("SE5")
#IFNDEF TOP
	dbSetIndex(cIndexSE5+OrdBagExt())
#ENDIF
dbSetOrder(nIndexSE5+1)
dbGoTop()
//***************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define array para arquivo de trabalho                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("E1_VEND1")
AADD(aCampos,{ "CODIGO"   ,"C",aTam[1],aTam[2] } )
AADD(aCampos,{ "CHAVE"    ,"C",10,0 } )
AADD(aCampos,{ "NVEND"    ,"N",01,0 } )
AADD(aCampos,{ "TIPO"     ,"C",03,0 } )
AADD(aCampos,{ "CHVFAT"   ,"N",10,0 } )
AADD(aCampos,{ "RECPRINC" ,"N",10,0 } )
aTam := TamSX3("E1_CLIENTE")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq := CriaTrab(aCampos)
dbUseArea( .T.,, cNomArq, "Trb", if(.F. .OR. .F., !.F., NIL), .F. )
IndRegua("TRB",cNomArq,"CODIGO+CHAVE",,,OemToAnsi("Selecionando Registros..."))

dbSelectarea("TRB")
dbSetOrder(1)
dbGoTop()

dbSelectarea("SE1")
dbsetOrder(7)

SetRegua(Reccount())

If (mv_par10 == 1) //Pendentes
	Fr610ProcP(lEnd)
Elseif (mv_par10 == 2) //Confirmadas
	Fr610ProcC(lEnd)                
Endif

dbSelectarea("TRB")
TRB->(dbGotop())
SetRegua(TRB->(RecCount()))
While !TRB->(Eof())
	
	lFirst  := .T.
	cVendAnt:= CODIGO
	nCount	:= 0
	While !TRB->(Eof()) .and. cVendAnt == CODIGO
		IF lEnd
			@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		Endif
		IncRegua()
		nComissao := 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a previsao sera calculada por titulo ja gerado   ³
		//³ ou pedido de vendas.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (TRB->TIPO == "PEN") //Pendentes
			dbSelectArea("SE1")
			dbSetOrder(1)
			If TRB->CHVFAT > 0
				dbGOTO(TRB->CHVFAT)
			Else
				dbGoTo(Val(TRB->CHAVE))
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calculo Bases, valores e percentuais de comissao.            ³
			//³ Constituicao de aBases{} retornada por FA440COMIS()          ³
			//³ Coluna 01    Vendedor        	       		                 ³
			//³ Coluna 02    Valor do Titulo    		                       ³
			//³ Coluna 03    Base Comissao Emissao			                    ³
			//³ Coluna 04    Base Comissao Baixa	                          ³
			//³ Coluna 05    Comissao Emissao										  ³
			//³ Coluna 06    Comissao Baixa                                  ³
			//³ Coluna 07    % Total da comissao                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			aBases := Fa440Comis(SE1->(Recno()),.F.,.T.,,,TRB->RECPRINC)
			nBases := aScan(aBases,{|x| x[1] == TRB->CODIGO })
			
			SE3->( dbSetOrder(3) )
			If TRB->CHVFAT > 0 .And. aBases[nBases][7] == 0 .And.;	// Existe mais de um percentual de comissao (comissao por produto)
				!SE3->(MsSeek( xFilial("SE3")+aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM))) // Nao eh comissao realizada
				// Recalcula bases pelo total da nota de saida, sem considerar parcelas geradas.
				aBases := Fa440Comis(SE1->(Recno()),.F.,.T.,,.F./*Nao calcula por parcelas*/)
			EndIf
			
			If TRB->CHVFAT > 0
				dbGoTo(Val(TRB->CHAVE))
			Endif
			If nBases = 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso vendedor n„o seja encontrado...           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("TRB")
				dbSkip()
				LOOP
			Endif
			aBases[nBases][2] := SE1->E1_VLCRUZ
			If TRB->CHVFAT > 0
				aBases[nBases][4] := SE1->E1_VALOR
				If aBases[nBases][7] > 0
					aBases[nBases][6] := SE1->E1_VALOR * (aBases[nBases][7]/100)
				EndIf
			Endif
			cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
			cTipo 	 := SE1->E1_TIPO
			cParcela	 := SE1->E1_PARCELA
			nBaseCom	 := SE1->&("E1_BASCOM"+Str(TRB->NVEND,1)) // Utilizado para estornar a base de comissao do titulo
			nComissao := (SE1->&("E1_COMIS"+Str(TRB->NVEND,1))/100)*nBaseCom // Utilizado para estornar o valor da comissao do titulo
			If !Empty(SE1->E1_FATURA) .And. AllTrim(SE1->E1_FATURA) != "NOTFAT"
				cTipoFat := SE1->E1_TIPOFAT
				// LOCALiza o titulo de fatura, pois no SE3 eh gerado o titulo de fatura
				// para verificar as comissoes que ja foram pagas.
				SE1->(MsSeek(xFilial("SE1")+E1_FATPREF+E1_FATURA)) // LOCALiza o titulo de fatura
				cPrefixo := SE1->E1_PREFIXO
				cNum	   := SE1->E1_NUM
				// Processar todas as parcelas da fatura gerada e verificar se a comissao
				// para a parcela nao foi paga.
				While (xFilial("SE1")+SE1->(E1_PREFIXO+E1_NUM) == xFilial("SE1")+cPrefixo+cNum).and.(SE1->(!Eof()))
					If SE1->E1_TIPO == cTipoFat
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verificar comissoes ja pagas                                 ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						cChaveSE3 := aBases[nBases,1]+SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)
						cTipo 	 := SE1->E1_TIPO
						cParcela	 := SE1->E1_PARCELA
						nValorFat := SE1->E1_VLCRUZ
						FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,nValorFat,nBaseCom,nComissao)
					Endif
					SE1->(DbSkip())
				Enddo
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbGOTO(Val(TRB->CHAVE))
			Else
				FA610ComPg(@aBases,cChaveSE3,nBases,cTipo,cParcela,SE1->E1_VLCRUZ,nBaseCom,nComissao)
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Caso percentual de comissao seja retornado == a zero, devo   ³
			//³ calcular a media (Faturamento com comissao no item <> percen-³
			//³ tual do vendedor)                                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aBases[nBases,7] == 0
				aBases[nBases,7] := (((aBases[nBases,5]+aBases[nBases,6])*100)/aBases[nBases,2])
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica tamanho do campo E1_CLIENTE para posicionamento das ³
			//³ colunas do relatorio                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aColu := {000,004,017,021,037,037,080,091,102,118,132,146,153,168}
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o Vendedor caso possa imprimir Comiss„o Zero ou      ³
			//³ exista alguma comiss„o para o Vendedor                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If aBases[nBases,6] != 0 .Or. aBases[nBases,5] != 0
				IF li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
				EndIF
				If lFirst
					Li++
					@li,  0 PSAY "CODIGO : " + TRB->CODIGO
					@li, 20 PSAY "NOME : " + Posicione("SA3",1,xFilial("SA3")+TRB->CODIGO,"A3_NOME")
					dbSelectArea("TRB")
					Li+=2
					lFirst := .F.
				Endif
				dbSelectArea("SE1")
				dbSetOrder(1)
				dbGoto(Val(TRB->CHAVE))
				
				If cPaisLoc == "BRA"
					nMoedaBco := 1
					dDataConv := dDataBase
				Else
					//nMoedaBco := SE1->E1_MOEDA
					dDataConv := SE1->E1_EMISSAO
				EndIf
				
				nComissao := xMoeda(aBases[nBases,5] + aBases[nBases,6],nMoedaBco,1,dDataConv,nDecs+1)
				aBases[nBases,2] := xMoeda(aBases[nBases,2],nMoedaBco,1,dDataConv,nDecs+1)
				aBases[nBases,4] := xMoeda(aBases[nBases,4],nMoedaBco,1,dDataConv,nDecs+1)
				aBases[nBases,5] := xMoeda(aBases[nBases,5],nMoedaBco,1,dDataConv,nDecs+1)
				aBases[nBases,6] := xMoeda(aBases[nBases,6],nMoedaBco,1,dDataConv,nDecs+1)
				
				@li, aColu[1] PSAY E1_PREFIXO
				@li, aColu[2] PSAY E1_NUM
				@li, aColu[3] PSAY E1_PARCELA
				@li, aColu[4] PSAY E1_CLIENTE+"/"+E1_LOJA
				dbSelectArea("SA1")
				dbSeek(cFilial+SE1->E1_CLIENTE+SE1->E1_LOJA)
				@li, aColu[6] PSAY Substr(SA1->A1_NOME,1,32)
				dbSelectArea("SE1")
				@li, aColu[7] PSAY E1_EMISSAO
				@li, aColu[8] PSAY E1_VENCREA
				@li, aColu[9]  PSAY aBases[nBases,2]	Picture tm(aBases[nBases,2],13,nDecs)
				@li, aColu[10] PSAY aBases[nBases,6]	Picture tm(aBases[nBases,6],13,nDecs)
				@li, aColu[11] PSAY aBases[nBases,4]	Picture tm(aBases[nBases,4],13,nDecs)
				@li, aColu[12] PSAY aBases[nBases,7]	Picture "999.99"
				@li, aColu[13] PSAY nComissao			Picture tm(nComissao,13,nDecs)
				@li, aColu[14] PSAY "PEN"
				li++
				nValMinRet := GetMv( "MV_VLRETIR" )
				nValTit		+= aBases[nBases,2]
				nComEnt		+= aBases[nBases,5]
				nIrEnt		+= If(aBases[nBases,2] > nValMinRet,aBases[nBases,5] * (mv_par09/100),0)
				nComVen		+= aBases[nBases,6]
				nIrVen		+= If(aBases[nBases,2] > nValMinRet, aBases[nBases,6] * (mv_par09/100),0)
				nValBas		+= aBases[nBases,4]
				nPorc			+= aBases[nBases,7]
				nVendComis	+= nComissao
				nVendIr		+= If(aBases[nBases,2] > nValMinRet,(aBases[nBases,5]+aBases[nBases,6])* (mv_par09/100),0)
				nCount++
			EndIf
		Elseif (TRB->TIPO == "CON") //Confirmadas

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica tamanho do campo E3_CODCLI para posicionamento das  ³
			//³ colunas do relatorio                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aColu := {000,004,017,021,037,037,080,091,102,118,132,146,153,168}

			dbSelectArea("SE3")
			SE3->(dbGoto(TRB->RECPRINC))
			SE1->(dbSetOrder(1))
			SE1->(dbSeek(xFilial("SE1")+SE3->E3_prefixo+SE3->E3_num+SE3->E3_parcela+SE3->E3_tipo,.T.))
			
			IF li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
			EndIF
			If lFirst
				Li++
				@li,  0 PSAY "CODIGO : " + TRB->CODIGO
				@li, 20 PSAY "NOME : " + Posicione("SA3",1,xFilial("SA3")+TRB->CODIGO,"A3_NOME")
				dbSelectArea("TRB")
				Li+=2
				lFirst := .F.
			Endif

			dbSelectArea("SE3")
			@li, aColu[01] PSAY SE3->E3_PREFIXO
			@li, aColu[02] PSAY SE3->E3_NUM
			@li, aColu[03] PSAY SE3->E3_PARCELA
			@li, aColu[04] PSAY SE3->E3_CODCLI+"/"+SE3->E3_loja
			dbSelectArea("SA1")
			dbSeek(cFilial+SE3->E3_CODCLI+SE3->E3_LOJA)
			@li, aColu[06] PSAY Substr(SA1->A1_NOME,1,32)
			dbSelectArea("SE3")
			@li, aColu[07] PSAY SE3->E3_emissao
			@li, aColu[08] PSAY SE3->E3_vencto              
			@li, aColu[09] PSAY SE1->E1_valor	Picture Tm(SE1->E1_valor,13,nDecs)
			@li, aColu[10] PSAY SE3->E3_base   	Picture Tm(SE3->E3_base,13,nDecs)
			@li, aColu[11] PSAY SE3->E3_base   	Picture Tm(SE3->E3_base,13,nDecs)
			@li, aColu[12] PSAY SE3->E3_porc   	Picture "999.99"
			@li, aColu[13] PSAY SE3->E3_comis	Picture Tm(SE3->E3_comis,13,nDecs)
			@li, aColu[14] PSAY "CON"
			li++
			nValTit		+= SE1->E1_valor
			nComVen		+= SE3->E3_base
			nIrVen		+= SE3->E3_comis * (mv_par09/100)
			nValBas		+= SE3->E3_base
			nPorc			+= SE3->E3_porc
			nVendComis	+= SE3->E3_comis
			nVendIr		+= SE3->E3_comis * (mv_par09/100)
			nCount++
		
		Endif
		dbSelectArea("TRB")
		dbSkip()
	Enddo
	nTotTit  +=nValTit
	nTotEnt  +=nComEnt
	nTotIrE  +=nIrEnt
	nTotVen  +=nComVen
	nTotIrB  +=nIrVen
	nTotBas  +=nValBas
	nTotComis+=nVendComis
	nTotIrVen+=nVendIr
	nTotPorc += nPorc
	nTotCount+= nCount
	If (nVendComis <> 0 .or. nTotCount > 0)
		ImpSub610(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,nIrVen,nVendIr,nCount,aColu,Cabec1,Cabec2,Titulo,nLin)
	Endif
	nValTit		:= 0.00
	nComEnt		:= 0.00
	nIrEnt		:= 0.00
	nComVen		:= 0.00
	nIrVen		:= 0.00
	nValBas		:= 0.00
	nPorc 		:= 0
	nVendComis 	:= 0.00
	nVendIr		:= 0.00
Enddo
If (nTotComis != 0)
	ImpTot610(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,nTotIrB,nTotIrVen,nTotPorc,nTotCount,aColu,Cabec1,Cabec2,Titulo,nLin)
Endif
If (li != 80)
	li++
	Roda(cbcont,cbtxt,"G")
Endif

dbSelectarea("TRB")
dbCloseArea( )
Ferase(cNomArq+GetDBExtension())
Ferase(cNomArq+OrdBagExt())

dbSelectArea("SE3")
dbSetOrder(1)
dbSelectarea("SE1")
dbsetOrder(1)
dbClearFilter()
Set Device To Screen

If (aReturn[5] == 1)
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()

Return

Static Function GravaCom(nX,nChvFat,cVend,nRecPrinc)
***********************************************
LOCAL cAlias := Alias()

DEFAULT nChvFat := 0
DEFAULT cVend   := ""
DEFAULT nRecPrinc := 0

dbSelectarea("TRB")
If (nX != Nil)
	If Empty(cVend)
		cVend := "SE1->E1_VEND"+nX
		cVend := &cVend
	Endif
Endif

nChave := AllTrim(Str(&(cAlias+"->(RECNO())")))

If TRB->(!DbSeek(cVend+nChave))
	RecLock("TRB",.T.)
	Replace CODIGO With cVend
	Replace CHAVE  With AllTrim(Str(&(cAlias+"->(RECNO())")))
	If (nX != Nil)
		Replace NVEND  With VAL(nX)
	Endif
	Replace RECPRINC With nRecPrinc
	If (mv_par10 == 1) //Pendentes
		Replace TIPO With "PEN"
	Elseif (mv_par10 == 2) //Confirmadas
		Replace TIPO With "CON"
	Endif	
	If (nChvFat != Nil).and.(nChvFat > 0)
		Replace CHVFAT With nChvFat
	Endif
	MsUnlock()
Endif
DbSelectarea(cAlias)

Return .T.

Static Function ImpSub610(nValTit,nComEnt,nComVen,nValBas,nPorc,nVendComis,nIrEnt,nIrVen,nVendIr,nCount,aColu,Cabec1,Cabec2,Titulo,nLin)
***************************************************************************************************************************
LOCAL nValMinRet := GetMv( "MV_VLRETIR" )
If (mv_par09 > 0).and.(nVendIr > nValMinRet)  // Aliquota IRRF
	Li++
	If (li > 55)
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
	Endif
	@li, aColu[01] PSAY "SUBTOTAL DO VENDEDOR --->"
	@li, aColu[09] PSAY nValTit			Picture tm(nValTit,13,nDecs)
	@li, aColu[10] PSAY nComVen			Picture tm(nComVen,13,nDecs)
	@li, aColu[11] PSAY nValBas		   Picture tm(nValBas,13,nDecs)
	If (nValBas > 0)
		@li, aColu[12] PSAY (nVendComis/nValBas)*100 Picture "999.99"
	Endif
	@li, aColu[13] PSAY nVendComis		PicTure tm(nVendComis,13,nDecs)
	Li++
	@li, aColu[1]  PSAY "TOTAL IR VENDEDOR    --->"
	@li, aColu[10] PSAY nIrVen				Picture tm(nIrVen,13,nDecs)
	@li, aColu[12] PSAY mv_par09   		Picture "999.99"
	@li, aColu[13] PSAY nVendIr			PicTure tm(nVendIr,13,nDecs)
Endif
Li++
IF (li > 55)
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
EndIF
@li, aColu[1]  PSAY "TOTAL DO VENDEDOR    --->"
@li, aColu[9]  PSAY nValTit          	Picture tm(nValTit,13,nDecs)
@li, aColu[10] PSAY nComVen          	Picture tm(nComVen,13,nDecs)
@li, aColu[11] PSAY nValBas				Picture tm(nValBas,13,nDecs)
If (nValBas > 0)
	@li, aColu[12] PSAY (nVendComis/nValBas)*100 Picture "999.99"
Endif
@li, aColu[13] PSAY nVendComis       	PicTure tm(nVendComis,13,nDecs)
Li++
Return .T.

Static Function ImpTot610(nTotTit,nTotEnt,nTotVen,nTotBas,nTotComis,nTotIrE,nTotIrB,nTotIrVen,nTotPorc,nTotCount,aColu,Cabec1,Cabec2,Titulo,nLin)
***********************************************************************************************************************************
LOCAL nValMinRet := GetMv( "MV_VLRETIR" )
Li++
IF (li > 55)
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
EndIF
If (mv_par09 > 0).and.(nTotIrVen > nValMinRet)  // Aliquota IRRF
	Li++
	@li, aColu[1]  PSAY "SUBTOTAL GERAL       --->"
	@li, aColu[9]  PSAY nTotTit			Picture tm(nTotTit,13,nDecs)
	@li, aColu[10] PSAY nTotVen    	   Picture tm(nTotVen,13,nDecs)
	@li, aColu[11] PSAY nTotBas		   picture tm(nTotBas,13,nDecs)
	If (nTotBas > 0)
		@li, aColu[12] PSAY (nTotComis/nTotBas)*100 Picture "999.99"
	Endif
	@li, aColu[13] PSAY nTotComis			PicTure tm(nTotComis,13,nDecs)
	Li++
	@li, aColu[1]  PSAY "TOTAL GERAL IR       --->"
	@li, aColu[10] PSAY nTotIrB			Picture tm(nTotIrB,13,nDecs)
	@li, aColu[12] PSAY mv_par09   		Picture "999.99"
	@li, aColu[13] PSAY nTotIrVen			PicTure tm(nTotIrVen,13,nDecs)
Endif
Li++
If (li > 55)
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,IIF(aReturn[4]==1,15,18))
Endif
@li, aColu[1]  PSAY "TOTAL  GERAL         --->"
@li, aColu[9]  PSAY nTotTit          	Picture tm(nTotTit,13,nDecs)
@li, aColu[10] PSAY nTotVen          	Picture tm(nTotVen,13,nDecs)
@li, aColu[11] PSAY nTotBas		    	Picture tm(nTotBas,13,nDecs)
If (nTotBas > 0)
	@li, aColu[12] PSAY (nTotComis/nTotBas)*100 Picture "999.99"
Endif
@li, aColu[13] PSAY nTotComis        	PicTure tm(nTotComis,13,nDecs)
Li++
Return .T.

Static Function FA610ComPg(aBases,cChaveSE3,nBases,cTipo,cParcela,nValorFat,nBaseCom,nComissao)
**************************************************************************************
LOCAL nPercBase := 0
LOCAL nPercEst

DEFAULT cTipo    := SE1->E1_TIPO
DEFAULT cParcela := SE1->E1_PARCELA
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso percentual de comissao seja retornado == a zero, devo   ³
//³ calcular a media (Faturamento com comissao no item <> percen-³
//³ tual do vendedor)                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aBases[nBases,7] == 0
	aBases[nBases,7] := (((aBases[nBases,5]+aBases[nBases,6])*100)/aBases[nBases,2])
Endif

dbSelectArea("SE3")
dbSetOrder(3)
If dbSeek(xFilial("SE3")+cChaveSE3)
	While !Eof() .and. xFilial("SE3")== E3_FILIAL .and.;
		E3_VEND+E3_CODCLI+E3_LOJA+E3_PREFIXO+E3_NUM == cChaveSE3
		If !Empty(E3_DATA) .or. E3_COMIS < 0
			nPercEst	:= Abs(SE3->E3_BASE / nValorFat)
			If E3_BAIEMI == "E"
				If E3_COMIS < 0
					aBases[nBases,3] += E3_BASE
					aBases[nBases,5] += E3_COMIS
				Else
					If aBases[nBases,3] > 0 .and. E3_BASE <> aBases[nBases,3]
						nPercBase:= Round(NoRound((aBases[nBases,3] * 100) / E3_BASE, 3),2)
					Else
						nPercBase:= 100
					Endif
					aBases[nBases,3] -= Round(NoRound(E3_BASE * (nPercBase/100) ,3),2)
					aBases[nBases,5] -= Round(NoRound(E3_COMIS * (nPercBase/100) ,3),2)
				Endif
			Else
				If E3_BAIEMI == "B" .and. cTIPO+cPARCELA == SE3->E3_TIPO+SE3->E3_PARCELA .and. E3_COMIS > 0
					aBases[nBases,4] -= (nBaseCom*nPercEst)
					aBases[nBases,6] -= (nComissao*nPercEst)
				ElseIf E3_BAIEMI == "B" .and. cTIPO+cPARCELA == SE3->E3_TIPO+SE3->E3_PARCELA .and. E3_COMIS < 0
					aBases[nBases,4] += (nBaseCom*nPercEst)
					aBases[nBases,6] += (nComissao*nPercEst)
				Endif
			Endif
		EndIf
		dbSkip()
	EndDo
EndIf
Return

Static Function Vendedor610(cAliasSe1,nIndexSE5)
*******************************************
LOCAL aAreaSe1 := GetArea()
LOCAL aVend610	:= {{},{},{},{}}
TitPrinc(xFilial(cAliasSe1),(cAliasSe1)->e1_PREFIXO,(cAliasSe1)->e1_NUM,(cAliasSe1)->e1_PARCELA,(cAliasSe1)->e1_TIPO,"SE1",@aVend610,nIndexSE5)
RestArea(aAreaSe1)
Return aVend610

Static Function Fr610ProcP(lEnd)
*****************************
LOCAL JX, nVendTit, nRecPrinc, nx1, ny1
// Se a comissão será definida na liquidação ou na baixa (1 = Liq, 2 = Baixa)
LOCAL lComiLiq := SuperGetMv("MV_COMILIQ",,"1") == "2"

DEFAULT lEnd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco lista de representantes                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRepres := u_BXRepLst("SQL") //Lista dos Representantes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Informacoes para Impressao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT R_E_C_N_O_ MRECNO FROM "+RetSqlName("SE1")+" E1 "
cQuery += "WHERE E1.D_E_L_E_T_ = '' AND E1.E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += "AND E1.E1_VENCREA BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery += "AND E1.E1_VEND1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += "AND E1.E1_CLIENTE BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += "AND E1.E1_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cQuery += "AND E1.E1_VEND1 IN ("+cRepres+") "
Endif
cQuery := ChangeQuery(cQuery)
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MSE1"

dbSelectArea("MSE1")
While !MSE1->(Eof())
	
	dbSelectArea("SE1")
	SE1->(dbGoto(MSE1->MRECNO))
	
	// chamado pelo r3
	IF lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	IncRegua()
	
	If E1_TIPO $ MVABATIM
		MSE1->(dbSkip())
		Loop
	Endif
	
	If (E1_SALDO == 0  .and. Empty(SE1->E1_FATURA) .and. Empty(SE1->E1_NUMLIQ))
		MSE1->(dbSkip())
		Loop
	Endif
	
	nRecSe1 := SE1->(Recno())
	aArea := GetArea()
	If Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. E1_SALDO > 0
		dbSelectArea("SE5")
		dbSetOrder(10)
		If dbSeek(xFilial("SE5")+SE1->E1_NUMLIQ)
			dbSelectArea("SE1")
			dbSetOrder(1)
			If ! dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
				SE1->(dbGoto(nRecSe1))
			Endif
		Endif
	Endif
	dbSelectArea("SE1")
	nRecSe1Pr	:= SE1->(Recno())
	
	SE1->(dbGoto(nRecSe1Pr))
	If "NOTFAT" $ SE1->E1_FATURA .And. Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. SE1->E1_SALDO == 0
		cQuery := "SELECT * FROM " + RetSqlName("SE5") + " WHERE E5_FILIAL = '" + SE1->E1_FILIAL + "' AND "
		cQuery += "E5_FATURA = '" + SE1->E1_NUM + "' AND "
		cQuery += "D_E_L_E_T_=' ' "
		cQuery := ChangeQuery(cQuery)
		dbSelectArea("SE5")
		dbCloseArea()
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"SE5",.F., .T.)
		
		dbSelectArea("SE1")
		dbSetOrder(1)
		If (!Empty(SE5->E5_FATURA) .And. !("NOTFAT" $ SE5->E5_FATURA)) .And. dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
			nRecSe1Pr := Recno()
		Else
			nRecSe1Pr := nRecSe1
		Endif
		
		dbSelectArea("SE5")
		dbCloseArea()
		ChKFile("SE5")
		dbSelectArea("SE5")
		dbSetOrder(1)
	ElseIf !Empty(SE1->E1_FATURA) .And. Empty(Alltrim((E1_VEND1+E1_VEND2+E1_VEND3+E1_VEND4+E1_VEND5))) .And. SE1->E1_SALDO == 0
		
		dbSelectArea("SE3")
		dbSetOrder(1)
		If dbSeek(xFilial("SE3")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
			dbSelectArea("SE1")
			RestArea(aArea)
			MSE1->(dbSkip())
			Loop
		Endif
		
		dbSelectArea("SE5")
		dbSetOrder(10)
		If dbSeek(xFilial("SE5")+SE1->E1_NUMLIQ)
			dbSelectarea("SE1")
			dbSetOrder(1)
			If ! dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)
				SE1->(dbGoto(nRecSe1))
			Endif
		Endif
		dbSelectArea("SE1")
		nRecSe1Pr	:= SE1->(Recno())
	Endif
	
	RestArea(aArea)
	
	For JX:=1 TO 5
		nx := Str(JX,1)
		dbSelectArea("SE1")
		SE1->(dbGoto(nRecSe1Pr))
		IF !EMPTY(E1_VEND&nx.)
			If E1_VEND&nx. >= mv_par03 .and. E1_VEND&nx. <= mv_par04
				cVend    := E1_VEND&nx
				RestArea(aArea)
				
				If !Empty(SE1->E1_FATURA) .And. (AllTrim(SE1->E1_FATURA) <> "NOTFAT")
					aAreaSE1 := GetArea()
					cCliente := E1_CLIENTE  //Declarar variaveis
					cLoja    := E1_LOJA
					cFatura  := E1_FATURA
					cFatPref := E1_FATPREF
					cLiquid  := "/"
					nChvFat  := SE1->(Recno())
					SE1->(dbSetOrder(1))
					SE1->(dbGotop())
					cChaveSE1 := xFilial("SE1") + cFatPref + cFatura
					SE1->(dbSeek(cChaveSE1))
					While((cChaveSE1 == xFilial("SE1") + E1_PREFIXO + E1_NUM))
						If SE1->E1_VENCREA >= mv_par03 .And. SE1->E1_VENCREA <= mv_par04
							If AllTrim(E1_FATURA) == "NOTFAT" .And. E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.))
								GravaCom(nX,nChvFat,cVend,nRecSe1Pr)
							ElseIf AllTrim(E1_FATURA) == "NOTFAT" .And. E1_SALDO == 0 .And. !Empty(SE1->E1_TIPOLIQ)
								dbSelectArea("SE5")
								dbSetOrder(7)
								If dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE)
									nRegSE1 := SE1->(Recno())
									dbSelectarea("SE1")
									dbSetOrder(15)
									dbSeek(xFilial("SE1")+SE5->E5_DOCUMEN)
									cChaveLiq := SE1->E1_FILIAL+SE1->E1_NUMLIQ
									Do While cChaveLiq == SE1->E1_FILIAL+SE1->E1_NUMLIQ .And. !Eof()
										If SE1->E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.))
											GravaCom(nX,nChvFat,cVend,nRecSe1Pr)
										Endif
										dbSkip()
									Enddo
									SE1->(dbGoto(nRegSE1))
									dbSetOrder(1)
								Endif
								dbSelectArea("SE1")
								
							Endif
						Endif
						DbSkip()
					EndDo
					RestArea(aAreaSE1)
				Else
					If SE1->E1_SALDO > 0 .And. (If(!lComiLiq,If(Empty(E1_NUMLIQ),.T.,.F.),.T.))
						GravaCom(nX,,cVend,nRecSe1Pr)
					Endif
				Endif
			Endif
		Endif
	Next
	RestArea(aArea)
	MSE1->(dbSkip())
Enddo
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif

Return

Static Function Fr610ProcC(lEnd)
*****************************

DEFAULT lEnd := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco lista de representantes                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cRepres := u_BXRepLst("SQL") //Lista dos Representantes

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Informacoes para Impressao                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := "SELECT R_E_C_N_O_ MRECNO FROM "+RetSqlName("SE3")+" E3 "
cQuery += "WHERE E3.D_E_L_E_T_ = '' AND E3.E3_FILIAL = '"+xFilial("SE3")+"' "
cQuery += "AND E3.E3_VENCTO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery += "AND E3.E3_VEND BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
cQuery += "AND E3.E3_CODCLI BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery += "AND E3.E3_LOJA BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cQuery += "AND E3.E3_VEND IN ("+cRepres+") "
Endif
cQuery := ChangeQuery(cQuery)
If (Select("MSE3") <> 0)
	dbSelectArea("MSE3")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MSE3"

dbSelectArea("MSE3")
While !MSE3->(Eof())
	dbSelectArea("SE3")
	SE3->(dbGoto(MSE3->MRECNO))
	IF lEnd
		@PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif
	IncRegua()
	dbSelectArea("SE3")
	GravaCom(NIL,NIL,SE3->E3_vend,MSE3->MRECNO)
	MSE3->(dbSkip())
Enddo
If (Select("MSE3") <> 0)
	dbSelectArea("MSE3")
	dbCloseArea()
Endif

Return