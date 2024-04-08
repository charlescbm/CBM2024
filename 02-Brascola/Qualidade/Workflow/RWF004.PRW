#INCLUDE "QIER200.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "RWMAKE.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RWF004   ºAutor  ³ JEFFERSON SIMAO    º Data ³  12/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ E-mail da inspecao de entrada                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function RWF004(cNota,cSerie,cFornece,cLoja)
Local aPerg   := {}
Local nX     
Local aAreaSD11	:= SD1->(GETAREA())
Local aAreaSF11	:= SF1->(GETAREA())
	

Private cTamanho   := "M"
Private nPagina    := 1
Private nRecno     := QEK->(Recno())
Private nomeprog   := "QIER200"
Private nTipo      := 0
Private Cabec1     := ""
Private Cabec2     := ""
Private CbTxt  := 0
Private cbCont := 0
Private lWeb   := .T. 
Private cEmail		:= U_RWF003("WF004")
Private nConta		:= 0
Private lEnsaio		:= .F.
Private cBrChave	:= ""
Private Li	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Vari veis utilizadas pela fun‡„o SetDefault    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn    := {STR0004, 1,STR0005,  1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private nLastKey   := 0
Private cPerg      := U_CriaPerg("QER200")


   //051236010050021        2008062604208005607     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						 ³
//³ mv_par01 = Fornecedor			?				 			 ³
//³ mv_par02 = Loja Fornecedor		?    		 				 ³
//³ mv_par03 = Produto				?			 				 ³
//³ mv_par04 = Da Data de Entrada 	?			 				 ³
//³ mv_par05 = Do Lote				?			 				 ³
//³ mv_par06 = Do Laborat¢rio 	    ?				     		 ³
//³ mv_par07 = At‚ Laborat¢rio      ?					 		 ³
//³ mv_par08 = Considera Entrada    ? 1)-Normal		 	 		 ³
//³  							  	  2)-Beneficiamento 	 	 ³
//³  							  	  3)-Devolucoes     	 	 ³
//³ mv_par09 = Considera Lote	    ? 1)-Sim	 		 	 	 ³
//³ 							  	  2)-Nao 			 		 ³
//³ mv_par10 = Skip-Teste           ? 1)- Todos    		 		 ³
//³ 								  2)- A Inspecionar	 		 ³
//³ mv_par11 = Linhas para Medicoes ? 							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

IF EMPTY(Alltrim(cEmail))
	Return
EndIf     

nRecSD1 := SD1->(Recno())

DBSELECTAREA("SB1") 
SB1->(DbsetOrder(1))


DBSELECTAREA("SD1") 
SD1->(DbsetOrder(1))
//SD1->(dbseek(xfilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA,.T.))
SD1->(dbseek(xfilial("SD1")+cNota+cSerie+cFornece+cLoja,.T.))
lEnviaNota := .F.
WHILE xfilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == xfilial("SD1")+cNota+cSerie+cFornece+cLoja
	cBrChave	:=cFornece+cLoja+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_ITEM
	dbSelectArea("QEK")  
	QEK->(dbSetOrder(10))
	if QEK->(dbSeek(xFilial("QEK")+cBrChave))
		mv_par01 := cFornece
		mv_par02 := cLoja
		mv_par03 := SD1->D1_COD
		mv_par04 := SD1->D1_DTDIGIT
		mv_par05 := QEK->QEK_LOTE
		mv_par06 := "  "
		mv_par07 := "ZZ"
		mv_par08 := 1 
		mv_par09 := 2 
		mv_par10 := 1
		mv_par11 := 1
		RunReport()
	Else
		If SB1->(Dbseek(xFilial("SB1")+SD1->D1_COD))
			IF SB1->B1_TIPOCQ = 'Q'
				lEnviaNota := .T.
			ENDIF	
		ENDIF
	Endif
	SD1->(dbSkip())
ENDDO

dbGoto(nRecSD1)	

IF lEnviaNota
	U_RWF005(cNota,cSerie,cFornece,cLoja)
ENDIF	


RestArea(aAreaSD11)
RestArea(aAreaSF11)
//dbGoto(RecNo())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ A200Imp	³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03.03.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rela‡„o de Ensaios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ A200Imp(lEnd,wnRel,cString)								  ³±±
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
Static Function RunReport()
Local lRet 

PRIVATE oProcess:= Nil 
                       


lAbreProc := .F.      

//Inicia processo de envio do e-mail
cProcess := OemToAnsi("001010") // Numero do Processo
cStatus  := OemToAnsi("001011")
	
oProcess := TWFProcess():New(cProcess,OemToAnsi("Roteiro de Inspecao"))
oProcess:NewTask(cStatus,"\workflow\qiermail.htm")
oProcess:cSubject := OemToAnsi("Roteiro de Inspecao")
	
// Busca os responsaveis
cEmail := u_BXFormatEmail(cEmail)
oProcess:cTo := cEmail
oProcess:oHtml:ValByName("h_produto","Brascola")	
oProcess:oHtml:ValByName("Titulo","Roteiro de Inspecao")	

u_qier01mail()

oProcess:Start()
oProcess:Finish()



Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ A200IFic ³ Autor ³ Vera Lucia S. Simoes  ³ Data ³23/02/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime a Ficha do Produto com os dados da Entrada posicio-³±±
±±³			 ³ nada. 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 -		A‡Æo do CodeBlock 							  ³±±
±±³			 ³ ExpC1 - Origem do prg: Menu relatorio ou cad./imp. entreg. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ A200Imp(QIER200.PRW) e A210Imp(QIER210.PRW)				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function qier01mail()
Local cLaborat
Local cUnimed
Local cLaudo
Local cSkipLote
Local cDescLab
Local cChaveQEK1
Local cChaveQEK2
Local cChaveQEK3
Local cDescEns 	:= Space(40)
Local aEntrada 	:= {}
Local aEnsaios 	:= {}
Local nRecQEK
Local nRecTRB
Local lImp		:= .T.
Local cFor
Local cLojFor
Local CGrupo
Local cSkTes    := "   "
Local lFirst
Local cTipoEns	:= ''
Local aLabEns   := {}
Local cUM       := ""
Local lSkpLot   := .F.
Local cAmIns    := " " 
Local nColEns := 0

Private aCampos := {}
Private cArqTrb
Private cProduto
dbSelectArea("QEK")                         

nRecQEK    := Recno()
cChaveQEK1 := QEK->QEK_PRODUT+Inverte(QEK->QEK_REVI)
cFor	   := QEK_FORNEC
cLojFor	   := QEK_LOJFOR
                   
//Numero de linhas padrao para Impressao das colunas de medicoes
mv_par11 := If(mv_par11==0,1,mv_par11)

dbSelectArea("QE6")
dbSetOrder(1)
dbSeek(xFilial("QE6")+cChaveQEK1)
IF !Found() .Or. !lImp
	Set Device to Screen
	//Help(" ",1,"QE_NAOPRRV",,QEK->QEK_PRODUT+" / "+QEK->QEK_REVI,2,1) // "Produto/Revisao nao cadastrados:
	dbSelectArea("QEK")
	dbSetOrder(1)
	Return(.F.)
EndIf

cProduto := QE6->QE6_PRODUT+QE6->QE6_REVI

dbSelectArea("QE7")
dbSetOrder(1)
dbSeek(xFilial("QE7")+cProduto)
dbSelectArea("QE8")
dbSetOrder(1)
dbSeek(xFilial("QE8")+cProduto)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho. 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("QEK_PRODUTO")
AADD(aCampos,{"PRODUTO",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QEK_REVI")
AADD(aCampos,{"REVI",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_ENSAIO")
AADD(aCampos,{"ENSAIO", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_METODO")
AADD(aCampos,{"METODO", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_ACESSO")
AADD(aCampos,{"ACESSO",   "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_UNIMED")
AADD(aCampos,{"UNIMED", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_NOMINA")
AADD(aCampos,{"NOMINA", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LIE")
AADD(aCampos,{"LIE", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LSE")
AADD(aCampos,{"LSE","C",aTam[1],aTam[2]})
aTam:=TamSX3("QF4_PLAMO")
AADD(aCampos,{"PLAMO",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_NIVEL")
AADD(aCampos,{"NIVEL", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_AM_INS")
AADD(aCampos,{"AM_INS", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_LABOR")
AADD(aCampos,{"LABOR",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_SEQLAB")
AADD(aCampos,{"SEQLAB", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE7_MINMAX")
AADD(aCampos,{"MINMAX", "C",aTam[1],aTam[2]})
aTam:=TamSX3("QE8_TEXTO")
AADD(aCampos,{"TEXTO",  "C",aTam[1],aTam[2]})
aTam:=TamSX3("QEK_VERIFI")
AADD(aCampos,{"Ok","C",aTam[1],aTam[2]})

cArqTrb := CriaTrab(aCampos)
If Select("TRB")>0
	TRB->(dbCloseArea())
EndIf
dbUseArea( .T.,, cArqTrb, "TRB", .F., .F. )
dbSelectArea("QE7")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrab()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Identifica o Grupo do Produto								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QEA->(dbSetOrder(2))
QEA->(dbSeek(xFilial("QEA")+QEK->QEK_PRODUT))
cGrupo := QEA->QEA_GRUPO
QEA->(dbSetOrder(1))

dbSelectArea("TRB")
IndRegua("TRB",cArqTrb,"LABOR+SEQLAB",,,STR0006)      //"Selecionando Registros..."
TRB->(dbGoTop())

If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
	TRB->(dbCloseArea())
	
	Ferase(cArqTrb+GetDBExtension())
	Ferase(cArqTrb+OrdBagExt())
	dbSelectArea("QEA")
	Return(.F.)
Endif

//SetRegua(RecCount())

While TRB->(!EOF())
  //	IncRegua()
	lEnsaio 	:= .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Flag Verifica se j  foi impresso o laboratorio 				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If TRB->OK == "S"
		dbSelectArea("TRB")
		dbSkip()
		Loop
	EndIf

	If	!Empty(mv_par06) .And. TRB->LABOR < mv_par06 .or.;
		!Empty(mv_par07) .And. TRB->LABOR > mv_par07
		dbSelectArea("TRB")
		dbSkip()
		Loop                   
	EndIf	
	
	If TRB->LABOR != cLaborat
		cLaborat := TRB->LABOR
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Descricao do Laboratorio									  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(TRB->LABOR)
		cDescLab := Tabela("Q2",TRB->LABOR)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ ARMAZENA NO ARRAY AS ULTIMAS ENTRADAS 				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QEK")
	dbSetOrder(2) 
	dbGoto(nRecQEK)
	nCont   := 0
	lSkpLot := .F.
	While QEK_FILIAL+QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUTO == ;
		xFilial("QEK")+cFor+cLojFor+Substr(cProduto,1,15) .and. nCont < 4     
		
		cSkipLote := Iif (QEK_VERIFI <> 2 , STR0019, STR0020) //"NAO"###"SIM"
		cChaveQEL := QEK_FORNEC+QEK_LOJFOR+QEK_PRODUTO+DTOS(QEK_DTENTR)+QEK_LOTE+;
		Space(TamSX3("QEL_LABOR")[1])
		
		dbSelectArea("QEL")
		QEL->(dbSetOrder(1))
		If dbSeek(xFilial("QEL")+cChaveQEL)
			QED->(dbSetOrder(1))
			QED->(dbSeek(xFilial("QED")+QEL->QEL_LAUDO))
			cLaudo := QED->QED_DESCPO
		Else
			cLaudo := Space(TamSX3("QED_DESCPO")[1])
		EndIf
		
		dbSelectArea("QEK")
		AADD(aEntrada,{QEK_DTENTR,QEK_LOTE,Upper(cSkipLote),cLaudo,QEK_DOCENT})
		nCont++

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Entrada atual esta em regime de Skip-Lote		  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nCont == 1
			If QEK->QEK_VERIFI == 2
				lSkpLot := .T.
			EndIf
		EndIf
		
		dbSkip()
	Enddo
	dbSelectArea("QEK")
	dbGoTo(nRecQEK)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados dos ensaios 						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aEnsaios := {}
	aLabEns  := {}
	dbSelectArea("TRB")
	nRecTRB := Recno()
	While !EOF() .and. cLaborat == TRB->LABOR
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica o skip-teste										 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cSkTes := "   "
		// Verifica se tem skip-teste definido
		QEH->(dbSetOrder(1))
		If QEH->(dbSeek(xFilial("QEH")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
			QEK->QEK_PRODUT+TRB->ENSAIO))
			cSkTes := "CER"
			// Verifica o historico skip-teste individual
			QEY->(dbSetOrder(1))
			If QEY->(dbSeek(xFilial("QEY")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				QEK->QEK_PRODUT+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO))
				cSkTes := "INS"
			EndIf
		Else
			cSkTes := "N/A"   // indica que nao foi definido
		EndIf			
		If Empty(cSkTes) .Or. cSkTes == "N/A"
			// Verifica o historico skip-teste por grupo
			QEZ->(dbSetOrder(1))
			If QEZ->(dbSeek(xFilial("QEZ")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
				cGrupo+DTOS(QEK->QEK_DTENTR)+QEK->QEK_LOTE+TRB->ENSAIO))
				cSkTes := "INS"
			Else
				// Verifica se tem skip-teste definido
				QEI->(dbSetOrder(1))
				If QEI->(dbSeek(xFilial("QEI")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+;
						cGrupo+TRB->ENSAIO))
					cSkTes := "CER"
				Else
					cSkTes := "N/A" //indica que nao foi definido
				EndIf
			EndIf
		EndIf      

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se os Ensaios a Inspecionar serao impressos na Fi-  ³
		//³ do Produto conforme selecao do parametro.				     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par10 == 2
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Quando a Entrada atual estiver em regime de Skip-Lote, somen-³
			//³ te serao impressos os ensaios em Skip-Teste.				 ³ 
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lSkpLot 
				If cSkTes # "INS" 
					RecLock("TRB",.F.)
					TRB->OK	 := "S"
					MsUnLock()
					TRB->(dbSkip())
					Loop
				EndIf	
			Else	
				If (cSkTes # "N/A") .And. (cSkTes # "INS") 
					RecLock("TRB",.F.)
					TRB->OK	 := "S"
					MsUnLock()
					TRB->(dbSkip())
					Loop
				EndIf	
			EndIf
		EndIf
		
		RecLock("TRB",.F.)
		TRB->OK	 := "S"
		MsUnLock()
		dbSelectArea("QE1")
		dbSetOrder(1)
		IF dbSeek(xFilial("QE1")+TRB->ENSAIO)
			cDescEns := Substr(QE1_DESCPO,1,40)
			cTipoEns := QE1_CARTA
		Endif
		
		dbSelectArea("TRB")
		AADD(aEnsaios,{ENSAIO,cTipoEns})

		If cTipoEns <> "TXT"
			SAH->(dbSetOrder(1))
			If SAH->(dbSeek(xFilial("SAH")+TRB->UNIMED))
				cUM := SAH->AH_UMRES
			Else
				cUM := " "
			EndIf
		EndIf       

		If (AM_INS == "1" )
			cAmIns := "AMO"
		ElseIf (AM_INS == "2")
			cAmIns := "INS"
		ElseIf (AM_INS == "3")
			cAmIns := "A/I"
		Else 
			cAmIns := " "	
		EndIf
		Aadd(aLabEns,{ENSAIO+" "+cDescEns,SubStr(METODO,1,13),ACESSO,cTipoEns,cUM,NOMINA,;
			MINMAX,LIE,LSE,	Left(TEXTO,34),Subs(TEXTO,35,34),Subs(TEXTO,69),;
			PLAMO,NIVEL,cAmIns,	cSkTes})		
		dbSelectArea("TRB")
		dbSkip()
		
	Enddo
	dbGoTo(nRecTRB)                             
	
	If Len(aLabEns) == 0
		TRB->(dbSkip())
		Loop
	EndIf
	IF ( lEnd )
		Return(.T.)
	EndIf
	oProcess:oHtml:ValByName("h_prdrevdesc",QE6->QE6_PRODUT + "/" + QE6->QE6_REVI+" - "+QE6->QE6_DESCPO)
	oProcess:oHtml:ValByName("h_dtatuvig",DTOC(QE6->QE6_DTCAD)+ " / " +DTOC(QE6->QE6_DTINI))

	oProcess:oHtml:ValByName("h_docobrig", Iif(QE6->QE6_DOCOBR=="S","Sim","Nao") )
	oProcess:oHtml:ValByName("h_laboratorio", "LABORATORIO ==> " + TRB->LABOR + " - " + cDescLab )
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime os Ensaios associados ao Laboratorio				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to Len(aLabEns)
		cBrEnsaio 		:= ""
		cBrMetodo 		:= ""
		cBrAcessorio 	:= ""
		cBrUM		 	:= ""
		cBrNominal	 	:= ""
		cBrLIE		 	:= ""
		cBrLSE 			:= ""

		cBrEnsaio	:= aLabEns[nX,1]
		cBrMetodo	:= aLabEns[nX,2]
		cBrAcessorio	:= aLabEns[nX,3]
		If aLabEns[nX,4] <> "TXT"
			cBrUM	:= aLabEns[nX,5]
			cBrNominal	:= aLabEns[nX,6]
			If aLabEns[nX,7] == "1"
				cBrLIE	:= aLabEns[nX,8]
				cBrLSE	:= aLabEns[nX,9]
			ElseIf aLabEns[nX,7] == "2"
				cBrLIE	:= aLabEns[nX,8]
				cBrLSE	:= ">>>"
			ElseIf aLabEns[nX,7] == "3"
				cBrLIE	:= "<<<"
				cBrLSE	:= aLabEns[nX,9]
			EndIf                           
		Else 
			cBrUM	:=	aLabEns[nX,10]
		EndIf			
		If aLabEns[nX,4] == "TXT"
			If !Empty (aLabEns[nX,11])
				cBrUM	+=	" "+aLabEns[nX,11]
			Endif
			If !Empty (aLabEns[nX,12])
				cBrUM	+=	" "+aLabEns[nX,12]
 			Endif
 		Endif

		Aadd(oProcess:oHtml:ValByName("it.ensaio")		,cBrEnsaio)
		Aadd(oProcess:oHtml:ValByName("it.metodo")		,cBrMetodo)
		Aadd(oProcess:oHtml:ValByName("it.acessorio")	,cBrAcessorio)
		Aadd(oProcess:oHtml:ValByName("it.um")			,cBrUM)
		Aadd(oProcess:oHtml:ValByName("it.nominal")		,cBrNominal)
		Aadd(oProcess:oHtml:ValByName("it.lie")			,cBrLIE)
		Aadd(oProcess:oHtml:ValByName("it.lse")			,cBrLSE)
	
	Next nX
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ IMPRIME MENSAGEM DE NOVAS ESPECIFICACOES 	         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nC:= 1 to Len(aEntrada)
		Aadd(oProcess:oHtml:ValByName("it2.ueemissao"),aEntrada[nC,1])
		Aadd(oProcess:oHtml:ValByName("it2.uelote"),SUBSTR(aEntrada[nC,2],1,LEN(alltrim(aEntrada[nC,2])) - 6) + "/" + SUBSTR(aEntrada[nC,2],LEN(alltrim(aEntrada[nC,2])) - 5,6))
		Aadd(oProcess:oHtml:ValByName("it2.ueskiplote"),aEntrada[nC,3])
		Aadd(oProcess:oHtml:ValByName("it2.uelaudo"),aEntrada[nC,4])
		Aadd(oProcess:oHtml:ValByName("it2.uedoc"),aEntrada[nC,5])
	Next nC
	aEntrada:={}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona em registros de outros Arquivos p/dados Fornecedor  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA5")
	dbSetOrder(2)
	dbSeek(xFilial("SA5")+QEK->QEK_PRODUTO+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
	dbSelectArea("QEG")
	dbSetOrder(1)
	dbSeek(xFilial("QEG")+SA5->A5_SITU)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Dados do Fornecedor/Cliente           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(mv_par08 = 2 .or. mv_par08 = 3)	
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek(xFilial("SA2")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
		oProcess:oHtml:ValByName("h_detforn", QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA2->A2_NREDUZ) 
		oProcess:oHtml:ValByName("h_detstatus", QEG->QEG_NIVEL  )		
	Else
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+QEK->QEK_FORNEC+QEK->QEK_LOJFOR)
		oProcess:oHtml:ValByName("h_detforn", QEK->QEK_FORNEC+"/"+QEK->QEK_LOJFOR+" - "+SA1->A1_NREDUZ)		
		oProcess:oHtml:ValByName("h_detstatus", QEG->QEG_NIVEL)						
	EndIf
	
	oProcess:oHtml:ValByName("h_detcodprodforn", SA5->A5_CODPRF)
	//oProcess:oHtml:ValByName("h_detlote", SUBSTR(ALLTRIM(QEK->QEK_LOTE),1,LEN(ALLTRIM(QEK->QEK_LOTE)) - 6))
	oProcess:oHtml:ValByName("h_detlote", SUBSTR(ALLTRIM(QEK->QEK_LOTE),1,6))
	oProcess:oHtml:ValByName("h_detsublote", SUBSTR(ALLTRIM(QEK->QEK_LOTE),LEN(ALLTRIM(QEK->QEK_LOTE)) - 5,6))	
	oProcess:oHtml:ValByName("h_detnf", QEK->QEK_NTFISC)
	SAH->(dbSetOrder(1))
	SAH->(dbSeek(xFilial("SAH")+QEK->QEK_UNIMED))
	oProcess:oHtml:ValByName("h_dettamlote", QEK->QEK_TAMLOT + "  " + SAH->AH_UMRES)
	oProcess:oHtml:ValByName("h_detdatanf", dtoc(QEK->QEK_DTNFIS))
	oProcess:oHtml:ValByName("h_detdataentr", dtoc(QEK->QEK_DTENTR))	
	oProcess:oHtml:ValByName("h_detnumped", QEK->QEK_PEDIDO)		
	oProcess:oHtml:ValByName("h_detdocentr", QEK->QEK_DOCENT)
	
	oProcess:oHtml:ValByName("h_detcertforn", QEK->QEK_CERFOR)	
	Li++
	cUniMed:= Iif ( QEK->QEK_UNIMED == QE6->QE6_UNMED1 ,;
	QE6->QE6_UNAMO1 , ;
	Iif (QEK->QEK_UNIMED == QE6->QE6_UNMED2, QE6->QE6_UNAMO2, Space(6) ))
	
	If !Empty(cUniMed)
		SAH->(dbSetOrder(1))
		SAH->(dbSeek(xFilial("SAH")+cUniMed))
		cUniMed := SAH->AH_UMRES
	EndIf
	oProcess:oHtml:ValByName("h_detloteamost", QEK->QEK_TAMAMO + "  " + AllTrim(cUnimed))	
	DBSELECTAREA("SD1")
	DBSETORDER(12)
	IF DBSEEK( XFILIAL("SD1") + QEK->QEK_CERFOR )
		oProcess:oHtml:ValByName("h_detdatavalid", DTOC(SD1->D1_DTVALID))
	ENDIF	
	        
	lFirst := .T.
	QF5->(dbSetOrder(1))
	QF5->(dbSeek(xFilial("QF5")+QEK->QEK_CHAVE))
	If QF5->(!Eof())
		While QF5->(!Eof()) .And. QEK->QEK_CHAVE == QF5->QF5_CHAVE 
			If Ascan(aEnsaios,{|x|x[1]==QF5->QF5_ENSAIO}) >  0
				If QF5->QF5_TAMA1 > 0            
					QF4->(dbSetOrder(1))
					If QF4->(dbSeek(xFilial("QF4")+QF5->QF5_FORNEC+QF5->QF5_LOJFOR+;
						QF5->QF5_PRODUT+QF5->QF5_REVI+QF5->QF5_ENSAIO))
						Aadd(oProcess:oHtml:ValByName("it3.eensaio"), QF4->QF4_ENSAIO)
						Aadd(oProcess:oHtml:ValByName("it3.eplano"), QF4->QF4_PLAMO)
						Aadd(oProcess:oHtml:ValByName("it3.eamostragem"),QF5->QF5_TAMA1)
						Aadd(oProcess:oHtml:ValByName("it3.eum"), cUnimed)
						Aadd(oProcess:oHtml:ValByName("it3.eaceite"), QF5->QF5_ACEI1)
						Aadd(oProcess:oHtml:ValByName("it3.erejeite"), QF5->QF5_REJEI1)
						lEnsaio := .T.
					EndIf	
				Endif
			EndIf
			QF5->(dbSkip())
		EndDo
	EndIf	
	If lEnsaio == .F.
		Aadd(oProcess:oHtml:ValByName("it3.eensaio"), " ")
		Aadd(oProcess:oHtml:ValByName("it3.eplano"), " ")
		Aadd(oProcess:oHtml:ValByName("it3.eamostragem")," ")
		Aadd(oProcess:oHtml:ValByName("it3.eum"), " ")
		Aadd(oProcess:oHtml:ValByName("it3.eaceite"), " ")
		Aadd(oProcess:oHtml:ValByName("it3.erejeite"), " ")
	EndIf
	
	For nCont := 1 to Len(aEnsaios)
		For nColEns := 1 to mv_par11 
				Aadd(oProcess:oHtml:ValByName("it4.apontensaio"), aEnsaios[nCont,1] )
		Next nColEns
	Next nCont
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Converte a chave passada como param. p/ chave do texto		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cChave := QE6->QE6_CHAVE
	cEspeci:="QIEA010 "
	dbSelectArea("QA2")
	QA2->(dbSetOrder(1))
	dbSeek(xFilial("QA2")+cEspeci+cChave)
	Do While !EOF() .and. QA2->QA2_FILIAL+QA2->QA2_ESPEC+QA2->QA2_CHAVE ==;
		xFilial("QA2")+cEspeci+cChave
		Li++
		dbSkip()
	Enddo

	dbSelectArea("TRB")
	dbSkip()
	Li:=80
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Entrada foi importada e marca que já imprimiu a Ficha ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QEP")
QEP->(dbSetOrder(1))
If dbSeek(xFilial("QEP")+"1"+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
	DtoS(QEK->QEK_DTENTR)+QEK->QEK_LOTE)
	RecLock("QEP",.F.)
	QEP->QEP_IMPFIC := "S"
	MsUnLock()
EndIf

dbSelectArea("TRB")
dbCloseArea()

Ferase(cArqTrb+GetDBExtension())
Ferase(cArqTrb+OrdBagExt())

Return(.T.)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³GeraTrab	³ Autor ³ Marcelo Pimentel 	  ³ Data ³ 11.03.98   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ GeraTrab()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static FuncTion GeraTrab()

While !Eof() .And. xFilial("QE7")==QE7_FILIAL .And. QE7_PRODUTO+QE7_REVI == cProduto
	RecLock("TRB",.T.)
	TRB->PRODUTO	:= QEK->QEK_PRODUTO
	TRB->REVI		:= QEK->QEK_REVI
	TRB->ENSAIO 	:= QE7->QE7_ENSAIO
	TRB->METODO 	:= QE7->QE7_METODO
//	TRB->TIPO		:= QE7->QE7_TIPO
	TRB->ACESSO     := QE7->QE7_ACESSO
	TRB->UNIMED 	:= QE7->QE7_UNIMED
	TRB->NOMINA 	:= QE7->QE7_NOMINA
	TRB->LIE 		:= QE7->QE7_LIE
	TRB->LSE 		:= QE7->QE7_LSE
	TRB->PLAMO		:= QE7->QE7_PLAMO
	TRB->NIVEL  	:= QE7->QE7_NIVEL
	TRB->AM_INS 	:= QE7->QE7_AM_INS
	TRB->LABOR		:= QE7->QE7_LABOR
	TRB->SEQLAB 	:= QE7->QE7_SEQLAB
	TRB->MINMAX 	:= QE7->QE7_MINMAX
	MsUnlock()
	dbSelectArea("QE7")
	dbSkip()
Enddo

dbSelectArea("QE8")
While !Eof() .And. xFilial("QE8")==QE8_FILIAL .And. QE8_PRODUTO+QE8_REVI == cProduto
	RecLock("TRB",.T.)
	TRB->PRODUTO := QEK->QEK_PRODUTO
	TRB->REVI    := QEK->QEK_REVI
	TRB->ENSAIO  := QE8->QE8_ENSAIO
	TRB->METODO  := QE8->QE8_METODO
//	TRB->TIPO    := QE8->QE8_TIPO
//	TRB->ACESSO  := QE8->QE8_ACESSO
	TRB->TEXTO   := QE8->QE8_TEXTO
	TRB->PLAMO   := QE8->QE8_PLAMO
	TRB->NIVEL   := QE8->QE8_NIVEL
	TRB->AM_INS  := QE8->QE8_AM_INS
	TRB->LABOR   := QE8->QE8_LABOR
	TRB->SEQLAB  := QE8->QE8_SEQLAB
	MsUnlock()
	dbSelectArea("QE8")
	dbSkip()
Enddo
Return .T.