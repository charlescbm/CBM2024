#Include "QIPR041.CH"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QIPR040	³ Autor ³ Marcelo Pimentel      ³ Data ³ 21.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio de Produtos - Uso        			       		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ QIPR040()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Siga Quality - Celerina                            		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Piment³26/09/01³------³ Melhoria de Performance-Implementado   ³±±
±±³              ³        ³      ³ TCQUERY.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                          

User Function QIPR041()
// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o SetPrint () ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel 	:="QIPR041"
LOCAL cString	:="QPK"
LOCAL cDesc1	:=OemToAnsi(STR0001) //"Neste relat¢rio ser„o relacionados os ensaios a serem realizados em ca-"
LOCAL cDesc2	:=OemToAnsi(STR0002) //"da laborat¢rio, para a valida‡„o da producao."
LOCAL cDesc3	:=""
Local cProg,cOrdProd,cLote,cNumSer
Local aArray   := {}
If Alltrim(FunName()) == "MATA650"
	aArray := ParamIXB
Endif

If Len(aArray) > 0
	cProg    := aArray[1]
	cOrdProd := aArray[2]
	cLote    := ""
	cNumSer  := ""
Else
	cProg    := ""
	cOrdProd := ""
Endif

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// ³ Par„metros para a fun‡„o Cabec()  ³
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cTitulo    := OemToAnsi("Roteiro de Inspeção")
PRIVATE cRelatorio := "QIPR041"
PRIVATE nTamanho   := "M"
PRIVATE nPagina    := 1
PRIVATE nRecnoQPK	 := QPK->(Recno())
PRIVATE lExisAlEsp := Iif(QP6->(FieldPos("QP6_ALTESP")) > 0,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault () ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn	:= {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nLastKey := 0
PRIVATE cPerg := U_CRIAPERG("QPR040")
PRIVATE cArqTRB	:= ''

cLote   := If(cLote==NIL .Or. Len(cLote)==0,CriaVar("QPK_LOTE"),cLote) 
cNumSer := If(cNumSer==NIL .Or.Len(cNumSer)==0,CriaVar("QPK_NUMSER"),cNumSer)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					  	 ³
//³ mv_par01			  // Da Ordem de Produ‡Æo     ?    		 ³
//³ mv_par02			  // Do Lote   			   	  ?    		 ³
//³ mv_par03			  // Do Numero de Serie	      ?    		 ³
//³ mv_par04			  // Ate' Ordem de Produ‡Æo   ?       	 ³
//³ mv_par05			  // Ate Lote  			      ?    		 ³
//³ mv_par06			  // Ate Numero de Serie      ?    		 ³
//³ mv_par07			  // Da Operacao      			?		 ³
//³ mv_par08			  // Ate Operacao      			?		 ³
//³ mv_par09			  // Apenas a Ult. Operacao 	? 		 ³
//³ mv_par10			  // Cliente 	? 		                 ³
//³ mv_par11			  // Loja 	? 		                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg,.F.)
If cProg == "MATA650"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obs.: Na funcao QPR040FIC ‚ atualizado o mv_par com o valor  ³
	//³  dos registros correntes.                					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cPerg := ""
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT 						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@ctitulo,cDesc1,cDesc2,cDesc3,.F.,"",.T.,nTamanho)

If nLastKey <> 27
	SetDefault(aReturn,cString)
	
	If nLastKey <> 27
		If cProg == "MATA650"
			dbGoTo(nRecnoQPK)
		Endif
		RptStatus({|lEnd| R040Imp(@lEnd,wnRel,cString,cProg,cOrdProd,cLote,cNumSer)},cTitulo)
	EndIf
EndIf

Return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ R040Imp	³ Autor ³ Marcelo Pimentel      ³ Data ³ 21.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Ensaios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ R040Imp(lEnd,wnRel,cString)								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd		-	A‡Æo do CodeBlock 							  ³±±
±±³			 ³ wnRel 	-	T¡tulo do relat¢rio							  ³±±
±±³			 ³ cString	-	Mensagem 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R040Imp(lEnd,wnRel,cString,cProg,cOrdProd,cLote,cNumser)
Local CbCont
Local cOperac	:= ''
Local cDescEns := Space(30)
Local nContLi	:= 0  
Local nY       := 0
Local aTexto	:= {}
Local aEnsaios := {}
Local lFirst	:= .T.
Local cTipoEns	:=	''
Local cOp		:=	''
Local cProduto	:=	''
Local cRoteiro	:=	''
Local cUnimed	:= ''
Local cTamAmo	:= ''
Local cFatCon	:= ''
Local cTipCon	:= ''
Local cSkTes	:= ''
Local cGrupo	:= ''
Local lProximo	:= .F.
Local aImpPl	:= {}
Local nCount	:= 0
Local aAreaQPK	:= GetArea()
Local cMemo		:= ''
Local nMCount	:= ''
Local nLoop		:= 0
Local cLinha	:= ""
Local cALTESP	:= ""        
Local nC        := 0
Local nCont     := 0
Local cCarta    := "" 
Local cTexObs   := ""
Local aTexObs   := ""

Private Titulo	:= cTitulo
Private Cabec1	:= ""
Private Cabec2	:= ""
Private nomeprog:= "QIPR041"
Private cTamanho:= "M"
Private nTipo	:= 0
Private cLoteSc2 := ""

If cProg == "MATA650"
	cPerg := U_CRIAPERG("QPR040")
	Pergunte(cPerg,.F.)
	mv_par01 := cOrdProd
	mv_par02 := cLote   
	mv_par03 := cNumSer  
	mv_par04 := cOrdProd
	mv_par05 := cLote    
	mv_par06 := cNumSer 
	mv_par07 := '  '
	mv_par08 := 'ZZ'
	mv_par09 := 2
	mv_par10 := Space(6)
	mv_par11 := Space(2)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li 		:= 80
m_pag 	:= 1
cbTxt		:= Space(10)
cbCont	:= 00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se deve comprimir ou nao                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho		     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
R040GTrab()
dbSelectArea("TRB")
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
	dbSelectArea("TRB")
	dbCloseArea()
	Ferase(cArqTRB+GetDBExtension())
	dbSelectArea("QPK")
	Ferase(cArqTRB+OrdBagExt())
	dbSetOrder( 1 )
	Return .T.
Else
	IndRegua("TRB",cArqTRB,"OP+PRODUT+REVI+ROTEIRO+OPERAC+LABOR+SEQLAB",,,STR0006)      //"Selecionando Registros..."
Endif

TRB->(dbGoTop())
SetRegua(RecCount())
While TRB->(!EOF())
	IncRegua()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ‚ nova pagina 							   	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Li > 54
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif

	IF ( lEnd )
		@Prow()+1,001 PSAY OemToAnsi(STR0007)	//"CANCELADO PELO OPERADOR"
		Exit
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona no grupo de produtos 								  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cGrupo := Posicione("QPA",2,xFilial("QPA")+TRB->PRODUT,"QPA_GRUPO")
	
	If TRB->OPERAC	!= cOperac
		cOperac := TRB->OPERAC
	EndIf
	
	If lFirst .Or. cOp != TRB->OP+TRB->LOTE+TRB->NUMSER
		 cOP := TRB->OP+TRB->LOTE+TRB->NUMSER

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define o Fator Conversao, se nao estiver definido             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TRB->UNMED1 == TRB->C2UNIMED
			cFatCon := TRB->FATCO1
			cTipCon := TRB->TIPCO1
		ElseIf TRB->UNMED2 == TRB->C2UNIMED
			cFatCon := TRB->FATCO2
			cTipCon := TRB->TIPCO2
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula o Tamanho da Amostra                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		If Superval(cFatCon) <> 0
			cFatCon := StrTran(cFatcon,",",".")
			If cTipCon == "D"
				cTamAmo := Str(TRB->QUANT / Superval(cFatCon))
			Else
				cTamAmo := Str(TRB->QUANT * Superval(cFatCon))
			EndIf                 
		Else
			cTamAmo := Str(TRB->QUANT)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO PRODUTO 											 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		@ Li, 001 PSAY AllTrim(TitSX3("QPK_OP")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_OP")[1])))+":"
		@ Li, 044 PSAY TRB->OP 
		
		If !Empty(TRB->LOTE)
			cLoteSc2 := TRB->LOTE 
		ELSE
			DBSELECTAREA("SC2")
			DBSETORDER(1)
			IF DBSEEK( XFILIAL("SC2") + SUBSTR(cOp,1,11))
				cLoteSc2 := SC2->C2_LOTECTL
			ENDIF	
		EndIf
		
		IF LEN(ALLTRIM(cLoteSc2)) == 0
				cLoteSc2 := "IMPRIMIR A OP P/GERAR O LOTE"
		ENDIF			

		@ Li, 064 PSAY STR0045 
		@ Li, 070 PSAY cLoteSc2

		If !Empty(TRB->NUMSER)
			@ Li, 094 PSAY STR0046
			@ Li, 112 PSAY TRB->NUMSER 
		EndIF
		
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QPK_TAMLOT")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QPK_TAMLOT")[1])))+":"
		@ Li, 044 PSAY AllTrim(Str(TRB->QUANT))
		Li++
		@ Li, 001 PSAY STR0036+REPLICATE(".",41-Len(STR0036))+':'		//'Tam.Amostr'
		@ Li, 044 PSAY AllTrim(Str(Int(Val(cTamAmo))))
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_PRODUT")[1])+" - "+AllTrim(TitSX3("QP6_REVI")[1])+Replicate(".",38-(len(Alltrim(TitSx3("QP6_PRODUT")[1]))+len(Alltrim(TitSx3("QP6_REVI")[1]))))+":"
		@ Li, 044 PSAY TRB->PRODUT + " - " + TRB->REVI
		Li++
		
		If !Empty(mv_par10)
			@ li,168 PSAY mv_par10 + " / " + mv_par11 + " - " + Posicione( "SA1", 1, xFilial("SA1")+mv_par10+mv_par11, "A1_NOME" )
		EndIf
		
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_DESCPO")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_DESCPO")[1])))+":"
		@ Li, 044 PSAY TRB->DESCPO
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_DTCAD")[1])+"/"+AllTrim(TitSX3("QP6_DTDES")[1])+"/"+AllTrim(TitSX3("QP6_RVDES")[1])+"...:"
		@ Li, 044 PSAY TRB->DTCAD
		@ Li, 057 PSAY TRB->DTDES
		@ Li, 070 PSAY TRB->RVDES
		Li++
		@ Li, 001 PSAY AllTrim(TitSX3("QP6_DTINI")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_DTINI")[1])))+":"
		@ Li, 044 PSAY TRB->DTINI
		If !Empty(TRB->DOCOBR)
			Li++
			@ Li, 001 PSAY AllTrim(TitSX3("QP6_DOCOBR")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_DOCOBR")[1])))+":"
			@ Li, 044 PSAY Iif(TRB->DOCOBR=="S",OemToAnsi(STR0009),;   // "Sim"
				OemToAnsi(STR0010))	// "Nao"
		EndIf
		Li++
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exibe Historico do Produto	 ( campo memo )       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMemo	:= MSMM(TRB->HISTOR)
		nMCount	:= MlCount( cMemo, 80 )
				
		If !Empty(nMCount)
			@ Li, 001 PSAY AllTrim(TitSX3("QP6_HISTOR")[1])+REPLICATE(".",41-Len(AllTrim(TitSX3("QP6_HISTOR")[1])))+":"
			For nLoop := 1 To nMCount
				cLinha := MemoLine( cMemo, 80, nLoop )
				@li,044 PSAY StrTran( cLinha, Chr(13)+Chr(10), "" )
				li++
			Next nLoop 
		EndIf
	
		@ Li, 001 PSAY STR0011+ TRB->ROTEIRO		//"ROTEIRO  ==> "
		Li++
		lFirst := .F.
	EndIf
	@ Li, 001 PSAY STR0012 + TRB->OPERAC + " - " + TRB->DESCRI	//"OPERACAO ==> "
	Li++
	@li,000 PSAY __PrtThinLine()
	Li++
	
/*
Ensaio                                             Metodo           Acessorios           Un. Med.  Nominal  L.I.E.   L.S.E.
------------------------------------------------------------------------------------------------------------------------------------
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxx xxxxxxxxxxxxxxxxxxxx xxxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
          1         2         3         4         5         6         7         8         9        10        11        12        13
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*/

	@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
	@ Li, 051 PSAY TitSX3("QP7_METODO")[1]
	@ Li, 068 PSAY TitSX3("QP7_ACESSO")[1]
	@ Li, 089 PSAY STR0014	//"Un. Med."
	@ Li, 099 PSAY STR0015	//"Nominal"
	@ Li, 108 PSAY STR0016	//"L.I.E."
	@ Li, 117 PSAY STR0017	//"L.S.E."
	Li++
	@li,000 PSAY __PrtThinLine()

	If lExisAlEsp	
		cALTESP	:= TRB->ALTESP
	Endif
	
	cChave	:=TRB->CHAVE
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados dos ensaios 						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEnsaios := {}
	dbSelectArea("TRB")
	While !EOF() .And. cOperac == TRB->OPERAC .And. cOp == TRB->OP+TRB->LOTE+TRB->NUMSER
		QP1->(dbSetOrder(1))
		IF QP1->(dbSeek(xFilial("QP1")+TRB->ENSAIO))
			cDescEns := QP1->QP1_DESCPO
			cTipoEns := QP1->QP1_TPCART
		Endif
		
		cProduto	:= TRB->PRODUT
		cRoteiro	:= TRB->ROTEIRO
		cOperac  := TRB->OPERAC
		cUnimed  := TRB->C2UNIMED
		
		AADD(aEnsaios,{TRB->ENSAIO,cTipoEns,TRB->PLAMO,TRB->DESPLA,cProduto,TRB->REVI,cRoteiro,cOperac,cTamAmo})
		Li++
		@ Li, 000 PSAY Iif(TRB->ENSOBR=="S","* ","  ") + TRB->ENSAIO + " " + cDescEns
		@ Li, 051 PSAY TRB->METODO
		@ Li, 068 PSAY TRB->ACESSORI
		
		If cTipoEns == "X"		//Se o tipo da carta for igual a "TXT"
			aTexto := {}
			Aadd(aTexto,Substr(TRB->TEXTO,1,34))
			Aadd(aTexto,Substr(TRB->TEXTO,35,35))
			Aadd(aTexto,Substr(TRB->TEXTO,70,31))
			@ Li, 089 PSAY aTexto[1]
		Else
			@ Li, 089 PSAY Posicione("SAH",1,xFilial("SAH")+TRB->UNIMED,"AH_UMRES")
			@ Li, 099 PSAY AllTrim(TRB->NOMINA)
			
			If TRB->MINMAX == "1"
				@ Li, 108 PSAY AllTrim(TRB->LIE)
				@ Li, 117 PSAY AllTrim(TRB->LSE)
			ElseIf TRB->MINMAX == "2"
				@ Li, 108 PSAY AllTrim(TRB->LIE)
				@ Li, 118 PSAY ">>>"
			ElseIf TRB->MINMAX == "3"
				@ Li, 109 PSAY "<<<"
				@ Li, 117 PSAY AllTrim(TRB->LSE)
			EndIf
		EndIf

		QQ1->(dbSetOrder(1))
		QQ1->(dbSeek(xFilial("QQ1")+TRB->PRODUT+TRB->REVI+TRB->OPERAC+TRB->ENSAIO))
		While  QQ1->(!Eof()) .And. xFilial("QQ1")==QQ1->QQ1_FILIAL 	.And.;
			QQ1->QQ1_PRODUT == TRB->PRODUT	.And.;
			QQ1->QQ1_REVI	== TRB->REVI	.And.;
			QQ1->QQ1_OPERAC == TRB->OPERAC	.And.;
			QQ1->QQ1_ENSAIO == TRB->ENSAIO
			If lProximo
				Li++
			EndIf
			
			If	cTipoEns == "X"	//Se o Tipo da Carta for igual a "TXT"
				nContLi++
				If !Empty(aTexto[2]) .And. nContLi==2
					@ Li,059 PSAY aTexto[2]
				ElseIf !Empty(aTexto[3]) .And. nContLi==3
					@ Li,059 PSAY aTexto[3]
				EndIf
			EndIf

			lProximo := .T.
			QQ1->(dbSkip())
		EndDo
		lProximo := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime restante do aTexto 									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cTipoEns == "X"
			If nContLi < 2
				If !Empty (aTexto[2])
					Li++
					@ Li, 089 PSAY aTexto[2]
				EndIf
			EndIf

			If nContLi < 3
				If !Empty (aTexto[3])
					Li++
					@ Li, 089 PSAY aTexto[3]
				Endif
			EndIf
			aTexto 	:= {}
			nContLi	:= 0
		EndIf
        
		Li++
		@li,000 PSAY __PrtThinLine()
		
		If Li > 54
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			@li,000 PSAY __PrtThinLine()
			Li++
			@ Li, 000 PSAY TitSX3("QP7_ENSAIO")[1]
			@ Li, 051 PSAY TitSX3("QP7_METODO")[1]
			@ Li, 068 PSAY TitSX3("QP7_ACESSO")[1]
			@ Li, 089 PSAY STR0014	//"Un. Med."
			@ Li, 099 PSAY STR0015	//"Nominal"
			@ Li, 108 PSAY STR0016	//"L.I.E."
			@ Li, 117 PSAY STR0017	//"L.S.E."
			Li++
			@li,000 PSAY __PrtThinLine()
		Endif
		
		dbSelectArea("TRB")
		dbSkip()
	Enddo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ CABECALHO DO PLANO DE AMOSTRAGEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aEnsaios) > 0	
		Li+=2             
		
		@ Li, 000 PSAY AllTrim(TitSX3("QP7_ENSAIO")[1])
		@ Li, 009 PSAY STR0037 //"Aceite"
		@ Li, 018 PSAY STR0038 //"Rejeite"
		@ Li, 027 PSAY STR0043 //"Tam. Amostra"
		@ Li, 040 PSAY STR0032	//'Plano de Amostragem'
		Li++
		@li,000 PSAY __PrtThinLine()
		Li++
		If Li > 54
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif

		For nC := 1 To Len(aEnsaios)     
		
			cCarta := QPCarta(aEnsaios[nC,1])
			QQH->(dbSetOrder(1))
			If QQH->(dbSeek(xFilial('QQH')+aEnsaios[nC,5]+aEnsaios[nC,6]+aEnsaios[nC,7]+aEnsaios[nC,8]+aEnsaios[nC,1]))
				cAmost  := QQH->QQH_AMOST
				aImpPl  := QEP_RetAmostra(aEnsaios[nC,3],QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(aEnsaios[nC,9])),8),"QPK_TAMLOT",.F.)
		
				If aEnsaios[nC,3]=="I"
					For nCount := 1 To Len(aImpPl)
						@ Li,000 PSAY aEnsaios[nC,1]
						@ Li,009 PSAY aImpPl[nCount,1]
						@ Li,018 PSAY aImpPl[nCount,2]
						@ Li,027 PSAY aImpPl[nCount,3]
						@ Li,040 PSAY aEnsaios[nC,3]
  			 			@ Li,042 PSAY Alltrim(aEnsaios[nC,4])+STR0045+aImpPl[nCount,7] //"  Tipo : "
						Li++
					Next nCount 
				Else 
					@ Li,000 PSAY aEnsaios[nC,1]	
					@ Li,009 PSAY aImpPl[2]            	
					@ Li,018 PSAY aImpPl[3]
					@ Li,027 PSAY aImpPl[1]
					@ Li,040 PSAY aEnsaios[nC,3]
   					@ Li,042 PSAY Substr(aEnsaios[nC,4],1,90)
					Li++
				EndIF	
			EndIF			
				
			If Li > 54
				Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			Endif
		Next
		@li,000 PSAY __PrtThinLine()
		Li++
	EndIf
	
	If Li > 54
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif
	Li+=2
	@ Li,001 PSAY STR0022	// "Data        ____ /____ /____"
	@ Li,062 PSAY STR0023 //"Lote        ____________________________"
	Li+=2
	@ Li,001 PSAY STR0024	//"Equipamento _________________________"
	Li+=2
	
	If Li > 50
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME MENSAGEM DE NOVAS ESPECIFICACOES 	         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lExisAlEsp
		If cALTESP == "S"
			Li+=2
			@ Li, 45 PSAY STR0044 //"*** ORDEM DE PRODUCAO COM NOVAS ESPECIFICACOES ***"
			Li+=2
		EndIf
	EndIf
	
	@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
	Li++
	@ Li, 01 PSAY "|                | "+Left(TitSX3("QPT_INSTR")[1],9)+"  |"+STR0025+"|"+STR0026+"|"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
	Li++
	@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
	Li++
	
	If Li > 52
		Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
	Endif
	
	For nCont := 1 to Len(aEnsaios)
		If aEnsaios[nCont,2] <> "X"
			@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |               |               |               |               |               |"
			Li++
			@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			Li++
		Else
			@ Li, 01 PSAY "| " + aEnsaios[nCont,1] + "       |            |                   |                                                                               |"
			Li++
			@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
			Li++
		Endif
		If Li > 54 .And. Len(aEnsaios) > nCont
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
			@ Li, 01 PSAY "|---------------------------------------------------------------------------------------------------------------------------------|"
			Li++
			@ Li, 01 PSAY "|                | "+Left(TitSX3("QPT_INSTR")[1],9)+"  |"+STR0025+"|"+STR0026+"|"                                                         //"     Ensaiador     "###"                                     M E D I C O E S                           "
			Li++
			@ Li, 01 PSAY "|----------------+------------+-------------------+---------------+---------------+---------------+---------------+---------------|"
			Li++
		Endif
	Next
	aEnsaios:={}
	Li++
	@ Li, 01 PSAY STR0027+"_______________________"      //"Laudo : "
	Li++
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Converte a chave passada como param. p/ chave do texto		  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTexObs:= QA_Rectxt(cChave,"QIPA010 ")
	aTexObs := JustificaTXT(cTexObs,130)
	For nY:=1 to Len(aTexObs)
		Li++
		If Li > 52
			Cabec(cTitulo,Cabec1,Cabec2,nomeprog,cTamanho,nTipo)
		Endif
		@ Li, 01 PSAY aTexObs[nY]
	Next nY

	Li:=60
EndDo

If Li != 80
	roda(CbCont,cbtxt,nTamanho)
EnDif

QPZ->(dbSetOrder(1))
QPI->(dbSetOrder(1))
dbSelectArea("TRB")
dbCloseArea()

Ferase(cArqTRB+GetDBExtension())
dbSelectArea("QPK")
Ferase(cArqTRB+OrdBagExt())
dbSetOrder( 1 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura o registro QPK         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea(aAreaQPK)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Encerra a impressao desta ficha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Device To Screen

If aReturn[5] == 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()
Return
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³R040GTrab	³ Autor ³ Marcelo Pimentel 	  	³ Data ³ 11.03.98³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho 									  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ R040GTrab()											            	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function R040GTrab()

#IFDEF TOP
	Local cQuery		:= ''
#ELSE
	Local cProdRev		:= ''
	Local nRecQQK		:= 0
	Local cChaveQPK		:= ''
	Local cRoteiro		:= ''
	Local cCond			:= ''
	Local cRevi			:= ''
#ENDIF
	
Local aTam			:= {}
Local aCampos	    := {}      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho  									 		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("QQK_CODIGO")	;AADD(aCampos,{"ROTEIRO"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_OPERAC")	;AADD(aCampos,{"OPERAC"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_CHAVE" ) ;AADD(aCampos,{"CHAVE"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_DESCRI")	;AADD(aCampos,{"DESCRI"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QQK_OPERGR")	;AADD(aCampos,{"OPERGRP"  ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_PRODUT")	;AADD(aCampos,{"PRODUT"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_REVI"  )	;AADD(aCampos,{"REVI"     ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_OP"    )	;AADD(aCampos,{"OP"       ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_LOTE"  )	;AADD(aCampos,{"LOTE"     ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_NUMSER")	;AADD(aCampos,{"NUMSER"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO1")	;AADD(aCampos,{"FATCO1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_TIPCO1")	;AADD(aCampos,{"TIPCO1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO2")	;AADD(aCampos,{"FATCO2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_FATCO2")	;AADD(aCampos,{"TIPCO2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DESCPO")	;AADD(aCampos,{"DESCPO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTCAD" )	;AADD(aCampos,{"DTCAD"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTDES" )	;AADD(aCampos,{"DTDES"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_RVDES" )	;AADD(aCampos,{"RVDES"    ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DTINI" )	;AADD(aCampos,{"DTINI"    ,"D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_DOCOBR")	;AADD(aCampos,{"DOCOBR"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_UNMED1")	;AADD(aCampos,{"UNMED1"   ,"C",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_UNMED2")	;AADD(aCampos,{"UNMED2"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_ENSAIO")	;AADD(aCampos,{"ENSAIO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_ENSOBR")	;AADD(aCampos,{"ENSOBR"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_UNIMED")	;AADD(aCampos,{"UNIMED"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_NOMINA")	;AADD(aCampos,{"NOMINA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LIE"   )	;AADD(aCampos,{"LIE"      ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LSE"   )	;AADD(aCampos,{"LSE"      ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_ACESSO")	;AADD(aCampos,{"ACESSORI" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_PLAMO" )	;AADD(aCampos,{"PLAMO"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_DESPLA")	;AADD(aCampos,{"DESPLA"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_NIVEL" )	;AADD(aCampos,{"NIVEL"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_LABOR" )	;AADD(aCampos,{"LABOR"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_SEQLAB")	;AADD(aCampos,{"SEQLAB"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_MINMAX")	;AADD(aCampos,{"MINMAX"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP7_METODO")	;AADD(aCampos,{"METODO"   ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QP8_TEXTO" )	;AADD(aCampos,{"TEXTO"    ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_TAMLOT")	;AADD(aCampos,{"QUANT"    ,"N",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_UM"    )	;AADD(aCampos,{"C2UNIMED" ,"C",aTam[1],aTam[2]})
aTam:=TamSX3("QPK_EMISSA")	;AADD(aCampos,{"C2EMISSAO","D",aTam[1],aTam[2]})
aTam:=TamSx3("QP6_HISTOR")	;AADD(aCampos,{"HISTOR"   ,"C",aTam[1],aTam[2]})
If lExisAlEsp
	aTam:=TamSx3("QP6_ALTESP")	;AADD(aCampos,{"ALTESP"   ,"C",aTam[1],aTam[2]})
EndIf


cArqTRB := CriaTrab(aCampos)
	//Elias 30.01.07
	If Select("TRB")>0
		TRB->(dbCloseArea())
	EndIf


dbUseArea( .T.,, cArqTRB, "TRB", .F., .F. )

dbSelectArea("QPK")
dbSetOrder(1)
#IFDEF TOP
	If TcSrvType() != "AS/400"
		cQuery := "SELECT "  
		cQuery += " QPK.QPK_OP OP, QPK.QPK_LOTE LOTE, QPK.QPK_NUMSER NUMSER," 
		cQuery += " QPK.QPK_PRODUT PRODUT,QPK.QPK_REVI REVI,SC2.C2_ROTEIRO ROTEIRO," 
		cQuery += " QPK.QPK_TAMLOT QUANT,QPK.QPK_UM C2UNIMED,QPK.QPK_EMISSA C2EMISSAO" 
		cQuery += " FROM " 
		cQuery += "	" + RetSQLName("QPK") + " QPK ,"                       
		cQuery += "	" + RetSQLName("SC2") + " SC2 ,"                       
		cQuery += "	" + RetSQLName("QP6") + " QP6 "                       
		
		cQuery += "WHERE "
		cQuery += " QPK.QPK_FILIAL = '" + xFilial("QPK") + "'"  
		cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") + "'" 
		 
		cQuery += " AND QPK.QPK_PRODUT = QP6.QP6_PRODUT"  
		cQuery += " AND QPK.QPK_REVI = QP6.QP6_REVI"
		cQuery += " AND Substring(QPK.QPK_OP,1,6)  = SC2.C2_NUM"
    	cQuery += " AND Substring(QPK.QPK_OP,7,2)  = SC2.C2_ITEM"
		cQuery += " AND Substring(QPK.QPK_OP,9,3)  = SC2.C2_SEQUEN"
		cQuery += " AND Substring(QPK.QPK_OP,12,2) = SC2.C2_ITEMGRD"
		
		cQuery += " AND QPK.QPK_OP >='"	   +mv_par01 + "'"  
		cQuery += " AND QPK.QPK_LOTE >='"	+mv_par02 + "'"  
		cQuery += " AND QPK.QPK_NUMSER >='"	+mv_par03 + "'"  
	
		cQuery += " AND QPK.QPK_OP <='"	    +mv_par04 + "'"  
		cQuery += " AND QPK.QPK_LOTE <='"	+mv_par05 + "'"  
		cQuery += " AND QPK.QPK_NUMSER <='"	+mv_par06 + "'"  

		//FILTRA OS ITENS DELETADOS DA TABELA SC2020
		cQuery += " AND SC2.D_E_L_E_T_ = ' ' " 


		cQuery += " AND QPK.D_E_L_E_T_ <> '*' "  
		cQuery += " ORDER BY " + SqlOrder(QPK->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		
		MemoWrite("\QUERYSYS\TRBQPK.SQL",cQuery)
		
		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"TRBQPK", .F., .T.)
		aTam := TamSx3("QPK_TAMLOT")
		TcSetField( "TRBQPK", "QUANT"	,"N",aTam[1],aTam[2])
		TcSetField( "TRBQPK", "C2EMISSAO"	,"D")
	EndIf
	
	While !Eof()                                                                                                 
	    cKey   := "QP6_PRODUT+QP6_REVI+QP7_CODREC+QP7_OPERAC+QP7_LABOR+QP7_SEQLAB"
		cQuery := "SELECT "  
		cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP7.QP7_CODREC CODREC, "		 
		cQuery += " QP7.QP7_OPERAC OPERAC, QP7.QP7_LABOR LABOR, QP7.QP7_SEQLAB SEQLAB, "	 
		cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, "	 
		cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, "	 
		cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "		 
		cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, "	 
		cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "		 
		cQuery += " QP7.QP7_ENSAIO ENSAIO, QP7.QP7_ENSOBR ENSOBR, QP7.QP7_UNIMED UNIMED, "	 
		cQuery += " QP7.QP7_NOMINA NOMINA, QP7.QP7_LIE LIE, QP7.QP7_NIVEL NIVEL, QP7.QP7_METODO METODO, "
		cQuery += " QP7.QP7_ACESSO ACESSORI, "
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " QQ7.QQ7_CLIENT CLIENT,QQ7.QQ7_LOJA LOJA, SA1.A1_NOME DESCLI, "		 
		EndIf
		
		cQuery += " QP6.QP6_HISTOR HISTOR,"  
		If lExisAlEsp
			cQuery += " QP6.QP6_ALTESP ALTESP,"  
		EndIf
		
		cQuery += " QP7.QP7_LSE LSE, QP7.QP7_PLAMO PLAMO, QP7.QP7_DESPLA DESPLA, "  
		cQuery += " QP7.QP7_MINMAX MINMAX "  


		cQuery += "FROM "  
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += "	" + RetSQLName("QQ7") + " QQ7, "   
			cQuery += "	" + RetSQLName("SA1") + " SA1, "   
		EndIf
		cQuery += "	" + RetSQLName("QPK") + " QPK, "  
		cQuery += "	" + RetSQLName("QP6") + " QP6, "  
		cQuery += "	" + RetSQLName("QQK") + " QQK, "  
		cQuery += "	" + RetSQLName("QP7") + " QP7 "  

		cQuery += "WHERE "  
		cQuery += " QPK.QPK_OP>='"			+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE>='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER>='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QPK.QPK_OP<='"		+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE<='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER<='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'"	 
		cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'"	 
		cQuery += " AND QP7.QP7_FILIAL = '" + xFilial("QP7") +"'"	 
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND QQ7.QQ7_FILIAL = '" + xFilial("QQ7") +"'"	 
		EndIf

		cQuery += " AND QP6.QP6_PRODUT = '" + TRBQPK->PRODUT +"'"	 
		cQuery += " AND QP6.QP6_REVI = '" + TRBQPK->REVI +"'"	 
		cQuery += " AND QQK.QQK_PRODUT ='" + TRBQPK->PRODUT +"'"  
		cQuery += " AND QQK.QQK_CODIGO ='" + TRBQPK->ROTEIRO +"'"  
		cQuery += " AND QQK.QQK_OPERAC Between '" + mv_par07	+ "' and '" + mv_par08 + "'"  
		cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"		 
		cQuery += " AND QP7.QP7_PRODUT = QP6.QP6_PRODUT "	 
		cQuery += " AND QP7.QP7_REVI = QPK.QPK_REVI " 		 
		cQuery += " AND QP7.QP7_CODREC = QQK.QQK_CODIGO "	 
		cQuery += " AND QP7.QP7_OPERAC = QQK.QQK_OPERAC "	 
		
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND SA1.A1_COD = '"+ mv_par10 +"'"	 
			cQuery += " AND SA1.A1_LOJA = '" + mv_par11 + "'"	 
			cQuery += " AND QQ7.QQ7_PRODUT = QP7.QP7_PRODUT "	 
			cQuery += " AND QQ7.QQ7_ENSAIO = QP7.QP7_ENSAIO "	 
			cQuery += " AND QQ7.QQ7_LABOR = QP7.QP7_LABOR "		 
			cQuery += " AND QQ7.QQ7_CODREC = QP7.QP7_CODREC "	 
			cQuery += " AND QQ7.QQ7_OPERAC = QP7.QP7_OPERAC " 	 
			cQuery += " AND QQ7.QQ7_CLIENT = '"+ mv_par10 +"'"	 
			cQuery += " AND QQ7.QQ7_LOJA = '" + mv_par11 + "'"	 
		EndIf
		
		cQuery += " AND QPK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP6.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QQK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP7.D_E_L_E_T_ <> '*'"  

		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND QQ7.D_E_L_E_T_ <> '*'"  
		EndIf

		cQuery += " ORDER BY " + SqlOrder(cKey)

//		cQuery := ChangeQuery(cQuery)


		MemoWrite("\QUERYSYS\TRBQPKTR1.SQL",cQuery)
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TR1')

		TcSetField( "TR1", "DTCAD"	,"D")
		TcSetField( "TR1", "DTDES"	,"D")
		TcSetField( "TR1", "DTINI"	,"D")


		QQK->(DbSetOrder(1))
		
		While !Eof()
			If	mv_par09 == 1	 //Imprime somente a ultima operacao
				If 	QQK->(dbSeek(xFilial("QQK")+TR1->PRODUT+TR1->REVI+If(Empty(TR1->CODREC),;
					"01", TR1->CODREC)))
					dbSelectArea("QQK")
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==TR1->PRODUT+TR1->REVI+If(Empty(TR1->CODREC),;
						"01", TR1->CODREC)
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
					dbSelectArea("TR1")
					If TR1->OPERAC <> QQK->QQK_OPERAC
						DbSkip()
						Loop
					Endif
				Endif
			EndIf
			RecLock("TRB",.T.)
			TRB->OP  		:= TRBQPK->OP  
			
//			IF LEN(ALLTRIM(TRBQPK->LOTE)) == 0
//				DBSELECTAREA("SC2")			
//				DBSETORDER(1)
//				IF DBSEEK(XFILIAL("SC1") + SUBSTR(TRBQPK->OP,1,6) + SUBSTR(TRBQPK->OP,7,2) + SUBSTR(TRBQPK->OP,9,3))
//				IF DBSEEK(XFILIAL("SC1") + TRBQPK->OP )
//					TRB->LOTE := SC2->C2_LOTECTL
//				ENDIF	
//			ELSE	
				TRB->LOTE      := TRBQPK->LOTE 
//			ENDIF	
//			DBSELECTAREA("TRB")
			TRB->NUMSER    := TRBQPK->NUMSER
			TRB->QUANT		:= TRBQPK->QUANT
			TRB->C2UNIMED	:= TRBQPK->C2UNIMED
			TRB->C2EMISSAO	:= TRBQPK->C2EMISSAO
			TRB->ROTEIRO	:= TR1->CODREC
			TRB->OPERAC		:= TR1->OPERAC
			TRB->CHAVE		:= TR1->CHAVE
			TRB->DESCRI		:= TR1->DESCRI
			TRB->OPERGRP	:= TR1->OPERGRP
			TRB->PRODUT		:= TR1->PRODUT
			TRB->REVI		:= TR1->REVI
			TRB->FATCO1		:= TR1->FATCO1
			TRB->TIPCO1		:= TR1->TIPCO1
			TRB->FATCO2		:= TR1->FATCO2
			TRB->TIPCO2		:= TR1->TIPCO2
			TRB->DESCPO		:= TR1->DESCPO
			TRB->DTCAD		:= TR1->DTCAD
			TRB->DTDES		:= TR1->DTDES
			TRB->RVDES		:= TR1->RVDES
			TRB->DTINI		:= TR1->DTINI
			TRB->DOCOBR		:= TR1->DOCOBR
			TRB->UNMED1		:= TR1->UNMED1
			TRB->UNMED2		:= TR1->UNMED2
			TRB->ENSAIO 	:= TR1->ENSAIO
			TRB->ENSOBR		:= TR1->ENSOBR
			TRB->UNIMED 	:= TR1->UNIMED
			TRB->NOMINA 	:= TR1->NOMINA
			TRB->LIE 		:= TR1->LIE
			TRB->LSE 		:= TR1->LSE
			TRB->PLAMO		:= TR1->PLAMO
			TRB->DESPLA		:= TR1->DESPLA
			TRB->NIVEL 	   := TR1->NIVEL
			TRB->LABOR		:= TR1->LABOR
			TRB->SEQLAB 	:= TR1->SEQLAB
			TRB->MINMAX 	:= TR1->MINMAX
			TRB->METODO 	:= TR1->METODO
			TRB->HISTOR		:= TR1->HISTOR
			TRB->ACESSORI  := TR1->ACESSORI
			If lExisAlEsp
				TRB->ALTESP	:= TR1->ALTESP
			EndIf
			
			MsUnlock()
			dbSelectArea("TR1")
			dbSkip()
		Enddo
		dbSelectArea("TR1")
		dbCloseArea()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Texto 														 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cKey   := "QP6_PRODUT+QP6_REVI+QP8_CODREC+QP8_OPERAC+QP8_LABOR+QP8_SEQLAB"
		cQuery := "SELECT "  
		cQuery += " QP6.QP6_PRODUT PRODUT,QP6.QP6_REVI REVI,QP8.QP8_CODREC CODREC, "	 
		cQuery += " QP8.QP8_OPERAC OPERAC, QP8.QP8_LABOR LABOR, QP8.QP8_SEQLAB SEQLAB, " 
		cQuery += " QP6.QP6_FATCO1 FATCO1, QP6.QP6_TIPCO1 TIPCO1, QP6.QP6_FATCO2 FATCO2, " 
		cQuery += " QP6.QP6_TIPCO2 TIPCO2, QP6.QP6_DESCPO DESCPO, QP6.QP6_DTCAD DTCAD, " 
		cQuery += " QP6.QP6_DTDES DTDES, QP6.QP6_RVDES RVDES, QP6.QP6_DTINI DTINI, "	 
		cQuery += " QP6.QP6_DOCOBR DOCOBR, QP6.QP6_UNMED1 UNMED1, QP6.QP6_UNMED2 UNMED2, " 
		cQuery += " QQK.QQK_CHAVE CHAVE, QQK.QQK_DESCRI DESCRI, QQK.QQK_OPERGR OPERGRP, "	 
		cQuery += " QP8.QP8_ENSAIO ENSAIO, QP8.QP8_ENSOBR ENSOBR, QP8.QP8_TEXTO TEXTO, QP8.QP8_METODO METODO, "	 
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " QQ7.QQ7_CLIENT CLIENT,QQ7.QQ7_LOJA LOJA, SA1.A1_NOME DESCLI, "	 
		EndIf
		
		cQuery += " QP6.QP6_HISTOR HISTOR, " 
		If lExisAlEsp
			cQuery += " QP6.QP6_ALTESP ALTESP, " 
		EndIf
		
		cQuery += " QP8.QP8_PLAMO PLAMO, QP8.QP8_DESPLA DESPLA, QP8.QP8_NIVEL NIVEL "  

		cQuery += " FROM "  
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += "	" + RetSQLName("QQ7") + " QQ7, "  
			cQuery += "	" + RetSQLName("SA1") + " SA1, "  
		EndIf
		cQuery += "	" + RetSQLName("QPK") + " QPK, "  
		cQuery += "	" + RetSQLName("QP6") + " QP6, "  
		cQuery += "	" + RetSQLName("QQK") + " QQK, "  
		cQuery += "	" + RetSQLName("QP8") + " QP8 "  

		cQuery += "WHERE "  
 
		cQuery += " QPK.QPK_OP>='"			+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE>='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER>='"	+TRBQPK->NUMSER + "'"	 
		
		cQuery += " AND QPK.QPK_OP<='"		+TRBQPK->OP + "'"		 
		cQuery += " AND QPK.QPK_LOTE<='"	+TRBQPK->LOTE + "'"		 
		cQuery += " AND QPK.QPK_NUMSER<='"	+TRBQPK->NUMSER + "'"	 
	
		cQuery += " AND QP6.QP6_FILIAL = '" + xFilial("QP6") +"'" 
		cQuery += " AND QQK.QQK_FILIAL  = '" + xFilial("QQK") +"'" 
		cQuery += " AND QP8.QP8_FILIAL = '" + xFilial("QP8") +"'" 
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND QQ7.QQ7_FILIAL = '" + xFilial("QQ7") +"'" 
		EndIf
		cQuery += " AND QP6.QP6_PRODUT = '"	+ TRBQPK->PRODUT	+"'" 
		cQuery += " AND QP6.QP6_REVI = '" 	+ TRBQPK->REVI		+"'" 
		cQuery += " AND QQK.QQK_PRODUT ='" 	+ TRBQPK->PRODUT	+"'" 
		cQuery += " AND QQK.QQK_CODIGO ='"  + TRBQPK->ROTEIRO   +"'"  
		cQuery += " AND QQK.QQK_OPERAC Between '" + mv_par07	+ "' and '" + mv_par08 + "'"  
		cQuery += " AND QQK.QQK_REVIPR = QPK.QPK_REVI"			 
		cQuery += " AND QP8.QP8_PRODUT = QP6.QP6_PRODUT "		 
		cQuery += " AND QP8.QP8_REVI = QPK.QPK_REVI "			 
		cQuery += " AND QP8.QP8_CODREC = QQK.QQK_CODIGO "		 
		cQuery += " AND QP8.QP8_OPERAC = QQK.QQK_OPERAC "		 
		
		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND SA1.A1_COD = '"+ mv_par10 +"'"	 
			cQuery += " AND SA1.A1_LOJA = '" + mv_par11 + "'" 
			cQuery += " AND QQ7.QQ7_PRODUT = QP8.QP8_PRODUT " 
			cQuery += " AND QQ7.QQ7_ENSAIO = QP8.QP8_ENSAIO " 
			cQuery += " AND QQ7.QQ7_LABOR = QP8.QP8_LABOR "	 
			cQuery += " AND QQ7.QQ7_CODREC = QP8.QP8_CODREC " 
			cQuery += " AND QQ7.QQ7_OPERAC = QP8.QP8_OPERAC "  
			cQuery += " AND QQ7.QQ7_CLIENT = '"+ mv_par10 +"'" 
			cQuery += " AND QQ7.QQ7_LOJA = '" + mv_par11 + "'" 
		EndIf
		
		cQuery += " AND QPK.D_E_L_E_T_ <> '*'" 
		cQuery += " AND QP6.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QQK.D_E_L_E_T_ <> '*'"  
		cQuery += " AND QP8.D_E_L_E_T_ <> '*'" 

		If !Empty(mv_par10) .And. !Empty(mv_par11)
			cQuery += " AND QQ7.D_E_L_E_T_ <> '*'"  
		EndIf
		cQuery += " ORDER BY " + SqlOrder(cKey)
//		cQuery := ChangeQuery(cQuery)

		MemoWrite("\QUERYSYS\TRBTR2.SQL",cQuery)
		dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), 'TR2')


		TcSetField( "TR2", "DTCAD"	,"D")
		TcSetField( "TR2", "DTDES"	,"D")
		TcSetField( "TR2", "DTINI"	,"D")
		
		QQK->(DbSetOrder(1))
		While !Eof()
			If	mv_par09 == 1	 //Imprime somente a ultima operacao
				If 	QQK->(dbSeek(xFilial("QQK")+TR2->PRODUT+TR2->REVI+If(Empty(TR2->CODREC),;
					"01", TR2->CODREC)))
					dbSelectArea("QQK")
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==TR2->PRODUT+TR2->REVI+If(Empty(TR2->CODREC),;
						"01", TR2->CODREC)
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
					dbSelectArea("TR2")
					If TR2->OPERAC <> QQK->QQK_OPERAC
						DbSkip()
						Loop
					Endif
				Endif
			EndIf
				
			RecLock("TRB",.T.)
			TRB->OP		   := TRBQPK->OP
//			IF LEN(ALLTRIM(TRBQPK->LOTE)) == 0
//				DBSELECTAREA("SC2")			
//				DBSETORDER(1)
//				IF DBSEEK(XFILIAL("SC1") + SUBSTR(TRBQPK->OP,1,6) + SUBSTR(TRBQPK->OP,7,2) + SUBSTR(TRBQPK->OP,9,3))
//				IF DBSEEK( XFILIAL("SC2") + TRBQPK->OP)
//					TRB->LOTE := SC2->C2_LOTECTL
//				ENDIF	
//			ELSE	
				TRB->LOTE      := TRBQPK->LOTE 
//			ENDIF				
//			DBSELECTAREA("TRB")
//			TRB->LOTE      := TRBQPK->LOTE 
			TRB->NUMSER    := TRBQPK->NUMSER
			TRB->QUANT		:= TRBQPK->QUANT
			TRB->C2UNIMED	:= TRBQPK->C2UNIMED
			TRB->C2EMISSAO	:= TRBQPK->C2EMISSAO
			TRB->ROTEIRO	:= TR2->CODREC
			TRB->OPERAC		:= TR2->OPERAC
			TRB->CHAVE		:= TR2->CHAVE
			TRB->DESCRI		:= TR2->DESCRI
			TRB->OPERGRP	:= TR2->OPERGRP
			TRB->PRODUT		:= TR2->PRODUT
			TRB->REVI		:= TR2->REVI
			TRB->FATCO1		:= TR2->FATCO1
			TRB->TIPCO1		:= TR2->TIPCO1
			TRB->FATCO2		:= TR2->FATCO2
			TRB->TIPCO2		:= TR2->TIPCO2
			TRB->DESCPO		:= TR2->DESCPO
			TRB->DTCAD		:= TR2->DTCAD
			TRB->DTDES		:= TR2->DTDES
			TRB->RVDES		:= TR2->RVDES
			TRB->DTINI		:= TR2->DTINI
			TRB->DOCOBR		:= TR2->DOCOBR
			TRB->UNMED1		:= TR2->UNMED1
			TRB->UNMED2		:= TR2->UNMED2
			TRB->ENSAIO 	:= TR2->ENSAIO
			TRB->ENSOBR		:= TR2->ENSOBR
			TRB->TEXTO		:= TR2->TEXTO
			TRB->PLAMO		:= TR2->PLAMO
			TRB->DESPLA		:= TR2->DESPLA
			TRB->NIVEL   	:= TR2->NIVEL
			TRB->LABOR		:= TR2->LABOR
			TRB->SEQLAB 	:= TR2->SEQLAB
			TRB->METODO 	:= TR2->METODO
			TRB->HISTOR		:= TR2->HISTOR
			If lExisAlEsp
				TRB->ALTESP	:= TR2->ALTESP
			EndIf

			MsUnlock()
			dbSelectArea("TR2")
			dbSkip()
		Enddo
		dbSelectArea("TR2")
		dbCloseArea()

		dbSelectArea("TRBQPK")
		dbSkip()
	EndDo
	dbSelectArea("TRBQPK")
	dbCloseArea()

#ELSE
	dbSeek(xFilial("QPK")+mv_par01,.T.)
	cCond	:= '!Eof() .And. QPK_FILIAL == "'+xFilial("QPK")+'".And.'+;
				'QPK_OP >= "'+mv_par01+'".And. '+;
				'QPK_LOTE >= "'+mv_par02+'".And. '+;
				'QPK_NUMSER >= "'+mv_par03+'".And. '+;
				'QPK_OP <= "'+mv_par04+'".And. '+;
				'QPK_LOTE <= "'+mv_par05+'".And. '+;
				'QPK_NUMSER <= "'+mv_par06+'"'

	While &cCond
		cRevi		:= Iif(Empty(QPK_REVI),QA_UltRevEsp(QPK_PRODUT,,,,"QIP"),QPK_REVI)
		cRoteiro	:= Posicione("SC2",1,xFilial("SC2")+QPK->QPK_OP,"C2_ROTEIRO")
		cChaveQPK	:= QPK_PRODUT+Inverte(cRevi)
		dbSelectArea("QP6")
		If !dbSeek(xFilial("QP6")+cChaveQPK)
			MsgAlert(STR0028+QPK->QPK_PRODUT+STR0029+cRevi+STR0030,STR0031)		//"O produto :"###"  / Revisao :"###" Nao esta cadastrado. Informe no cadastro de especificacoes."###"Atencao"
			dbSelectArea("QPK")
			dbSetOrder(1)
			dbSkip()
			Loop
		EndIf
		cProdRev := QP6->QP6_PRODUT+QP6->QP6_REVI
		
		dbSelectArea("QQK")
		dbSetOrder(1)
		If dbSeek(xFilial("QQK")+QPK->QPK_PRODUT+QP6->QP6_REVI+cRoteiro)
			While !Eof().And. xFilial("QQK"	) == QQK_FILIAL		.And.;
				QQK_PRODUT+QQK_REVIPR+QQK_CODIGO==QPK->QPK_PRODUT+cRevi+cRoteiro	.And.;
				QQK_OPERAC >= mv_par07 .And. QQK_OPERAC <= mv_par08
				If QQK_REVIPR <> cRevi
					dbSkip()
					Loop
				EndIf
				If	mv_par09 == 1	 //Imprime somente a ultima operacao
					nRecQQK := Recno()
					While !Eof().And. xFilial("QQK")	==	QQK_FILIAL	.And.;
						QQK_PRODUTO+QQK_REVIPR+QQK_CODIGO==QPK->QPK_PRODUT+cRevi+cRoteiro
						nRecQQK := Recno()
						dbSkip()
					EndDo
					dbGoTo(nRecQQK)
				EndIf
				
				//Checar se existe ensaios associados.
				dbSelectArea("QP7")
				dbSetOrder(1)
				If dbSeek(xFilial("QP7")+cProdRev+QQK->QQK_CODIGO+QQK->QQK_OPERAC)
					While !Eof() .And. xFilial("QP7")	 == QP7_FILIAL	;
						.And. QP7_PRODUTO+QP7_REVI ==QPK->QPK_PRODUT+QP6->QP6_REVI;	//cProdRev ;
						.And. QP7_CODREC+QP7_OPERAC==QQK->QQK_CODIGO+QQK->QQK_OPERAC
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(mv_par10)
							QQ7->(dbSetOrder(1))
							If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + mv_par10 + mv_par11 + ;
								QP7->QP7_LABOR + QP7->QP7_ENSAIO + QQK->QQK_CODIGO + QQK->QQK_OPERAC))
								dbSelectArea("QP7")
								dbSkip()
								Loop
							EndIf
						EndIf
						
						RecLock("TRB",.T.)
						TRB->ROTEIRO	:=	QQK->QQK_CODIGO
						TRB->OPERAC		:=	QQK->QQK_OPERAC
						TRB->CHAVE		:=	QQK->QQK_CHAVE
						TRB->DESCRI		:=	QQK->QQK_DESCRI
						TRB->OPERGRP	:=	QQK->QQK_OPERGRP
						TRB->PRODUT 	:=	QPK->QPK_PRODUT
						TRB->OP	   	:=	QPK->QPK_OP
//						IF LEN(ALLTRIM(QPK->QPK_LOTE)) == 0
//							DBSELECTAREA("SC2")
//							DBSETORDER(1)
//							IF DBSEEK( XFILIAL("SC2") + SUBSTR(QPK->QPK_OP,1,6) + SUBSTR(QPK->QPK_OP,7,2) + SUBSTR(QPK->QPK_OP,9,3)
//							IF DBSEEK(XFILIAL("SC2") + QPK->QPK_OP
//								TRB->LOTE	   :=	SC2->C2_LOTECTL
 //							ENDIF
	//					ELSE		
	  						TRB->LOTE	   :=	QPK->QPK_LOTE
		 //				ENDIF	
			//			DBSELECTAREA("TRB")
						TRB->NUMSER	   :=	QPK->QPK_NUMSER
						TRB->REVI		:=	cRevi

						TRB->FATCO1		:= QP6->QP6_FATCO1 
						TRB->TIPCO1		:= QP6->QP6_TIPCO1
						TRB->FATCO2		:= QP6->QP6_FATCO2
						TRB->TIPCO2		:= QP6->QP6_TIPCO2
						TRB->DESCPO		:= QP6->QP6_DESCPO
						TRB->DTCAD		:= QP6->QP6_DTCAD
						TRB->DTDES		:= QP6->QP6_DTDES
						TRB->RVDES		:= QP6->QP6_RVDES
						TRB->DTINI		:= QP6->QP6_DTINI
						TRB->DOCOBR		:= QP6->QP6_DOCOBR
						TRB->UNMED1		:= QP6->QP6_UNMED1
						TRB->UNMED2		:= QP6->QP6_UNMED2

						TRB->ENSAIO 	:= QP7->QP7_ENSAIO
						TRB->ENSOBR		:= QP7->QP7_ENSOBR
						TRB->UNIMED 	:= QP7->QP7_UNIMED
						TRB->NOMINA 	:= QP7->QP7_NOMINA
						TRB->LIE 		:= QP7->QP7_LIE
						TRB->LSE 		:= QP7->QP7_LSE
						TRB->PLAMO		:= QP7->QP7_PLAMO
						TRB->DESPLA		:= QP7->QP7_DESPLA
						TRB->NIVEL   	:= QP7->QP7_NIVEL
						TRB->LABOR		:= QP7->QP7_LABOR
						TRB->SEQLAB 	:= QP7->QP7_SEQLAB
						TRB->MINMAX 	:= QP7->QP7_MINMAX
						TRB->METODO 	:= QP7->QP7_METODO
						TRB->ACESSORI  := QP7->QP7_ACESSO
						TRB->QUANT		:= QPK->QPK_TAMLOT
						TRB->C2UNIMED	:= QPK->QPK_UM
						TRB->C2EMISSAO	:= QPK->QPK_EMISSA
						TRB->HISTOR		:= QP6->QP6_HISTOR
						If lExisAlEsp
							TRB->ALTESP	:= QP6->QP6_ALTESP
						EndIf
						MsUnlock()
						dbSelectArea("QP7")
						dbSkip()
					Enddo
				EndIf

				//Checar os ensaios associados - TXT
				dbSelectArea("QP8")
				dbSetOrder(1)
				If dbSeek(xFilial("QP8")+cProdRev+QQK->QQK_CODIGO+QQK->QQK_OPERAC)
					While !Eof() .And. xFilial("QP8")		  == QP8_FILIAL ;
						.And. QP8_PRODUTO+QP8_REVI  == QPK->QPK_PRODUT+QP6->QP6_REVI;	//cProdRev ;
						.And. QP8_CODREC+QP8_OPERAC == QQK->QQK_CODIGO+QQK->QQK_OPERAC

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(mv_par10)
							QQ7->(dbSetOrder(1))
							If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + mv_par10 + mv_par11 + ;
								QP8->QP8_LABOR + QP8->QP8_ENSAIO + QQK->QQK_CODIGO + QQK->QQK_OPERAC))
								dbSelectArea("QP8")
								dbSkip()
								Loop
							EndIf
						EndIf

						RecLock("TRB",.T.)
						TRB->ROTEIRO	:= QQK->QQK_CODIGO
						TRB->OPERAC		:= QQK->QQK_OPERAC
						TRB->CHAVE		:= QQK->QQK_CHAVE
						TRB->DESCRI		:= QQK->QQK_DESCRI
						TRB->OPERGRP	:= QQK->QQK_OPERGR
						TRB->PRODUT		:= QPK->QPK_PRODUT
						TRB->OP	   	    := QPK->QPK_OP  
//						IF LEN(ALLTRIM(QPK->QPK_LOTE)) == 0
//							DBSELECTAREA("SC2")
//							DBSETORDER(1)
//							IF DBSEEK( XFILIAL("SC2") + SUBSTR(QPK->QPK_OP,1,6) + SUBSTR(QPK->QPK_OP,7,2) + SUBSTR(QPK->QPK_OP,9,3)
//							IF DBSEEK( XFILIAL("SC2") + QPK->QPK_OP
//								TRB->LOTE	   :=	SC2->C2_LOTECTL
//							ENDIF
 //						ELSE		
							TRB->LOTE	   :=	QPK->QPK_LOTE
//						ENDIF							
 //						DBSELECTAREA("TRB")
//						TRB->LOTE	    := QPK->QPK_LOTE
						TRB->NUMSER	    := QPK->QPK_NUMSER
						TRB->REVI		:= cRevi

						TRB->FATCO1		:= QP6->QP6_FATCO1 
						TRB->TIPCO1		:= QP6->QP6_TIPCO1
						TRB->FATCO2		:= QP6->QP6_FATCO2
						TRB->TIPCO2		:= QP6->QP6_TIPCO2
						TRB->DESCPO		:= QP6->QP6_DESCPO
						TRB->DTCAD		:= QP6->QP6_DTCAD
						TRB->DTDES		:= QP6->QP6_DTDES
						TRB->RVDES		:= QP6->QP6_RVDES
						TRB->DTINI		:= QP6->QP6_DTINI
						TRB->DOCOBR		:= QP6->QP6_DOCOBR
						TRB->UNMED1		:= QP6->QP6_UNMED1
						TRB->UNMED2		:= QP6->QP6_UNMED2

						TRB->ENSAIO 	:= QP8->QP8_ENSAIO
						TRB->ENSOBR		:= QP8->QP8_ENSOBR
						TRB->TEXTO		:= QP8->QP8_TEXTO
						TRB->PLAMO		:= QP8->QP8_PLAMO
						TRB->DESPLA		:= QP8->QP8_DESPLA
						TRB->NIVEL   	:= QP8->QP8_NIVEL
						TRB->LABOR		:= QP8->QP8_LABOR
						TRB->SEQLAB 	:= QP8->QP8_SEQLAB
						TRB->METODO 	:= QP8->QP8_METODO
						TRB->QUANT		:= QPK->QPK_TAMLOT
						TRB->C2UNIMED	:= QPK->QPK_UM
						TRB->C2EMISSAO	:= QPK->QPK_EMISSA
						TRB->HISTOR		:= QP6->QP6_HISTOR
						If lExisAlEsp
							TRB->ALTESP	:= QP6->QP6_ALTESP
						EndIf

						MsUnlock()
						dbSelectArea("QP8")
						dbSkip()
					Enddo
				EndIf                             
				dbSelectArea("QQK")
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("QPK")
		dbSkip()
	EndDo
#ENDIF

Return .T.