#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RFINR02  ³ Relatorio de impostos a recolher.                            º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³ 11.10.05 ³Luiz (contas a pagar)                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 11.10.05 ³ Andreza Favero                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ 99.99.99 - Consultor - Descrição da alteração                           º±±
±±º             ³                                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFINR02()

Local cDesc1  		:= "Este programa tem por finalidade fazer a impressão do relatório"
Local cDesc2  		:= "de Impostos a Recolher de um determinado período conforme"
Local cDesc3  		:= "parâmetros definidos pelo usuário."

Local lEnd			:= .F.											// Controla o cancelamento do relatório
Local lDic			:= .F.											// Habilita/Desabilita Dicionario
Local lComp			:= .F.											// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro		:= .F.											// Habilita/Desabilita o Filtro
Local aRegs			:= {}											// Array com as perguntas do SX1
Local aDadImp		:= {}											// Array com os dados a imprimir
Local wnrel	    	:= "RFINR02"									// Nome do Arquivo utilizado no Spool

Private cTipos			:= " "
Private cString 	:= "SE2"										// Alias principal
Private Tamanho  	:= "G"											// Tamanho do relatório P/M/G
Private Limite   	:= 220											// Tamanho das colunas 80/132/220
Private NomeProg 	:= "RFINR02"									// Nome do programa
Private nLastKey 	:= 0											// Controla o cancelamento da SetPrint e SetDefault
Private Titulo   	:= "Listagem de impostos a recolher"										// Título do Relatório
Private cPerg    	:= U_CriaPerg("RFIR02")							// Alias da pergunta do relatorio
Private nTipo    	:= 0											// Caracter de compactação
Private cbCont   	:= 0											// Tamanho do rodapé
Private cbTxt    	:= ""											// Texto do rodapé
Private Li	    	:= 80											// Contador de linhas
Private M_PAG    	:= 1											// Contador de páginas
Private aOrd     	:= {}			// Ordem do relatório
Private Cabec1   	:= ""											// Primeiro cabeçalho
Private Cabec2   	:= ""											// Segundo cabeçalho
Private aReturn		:= {	"Branco",;								//[1] Reservado para Formulario
1,;										//[2] Reservado para N§ de Vias
"Financeiro",;								//[3] Destinatario
1,;										//[4] Formato => 1-Comprimido 2-Normal
2,;										//[5] Midia   => 1-Disco 2-Impressora
1,;										//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
"",;									//[7] Expressao do Filtro
1 }										//[8] Ordem a ser selecionada
//[9]..[10]..[n] Campos a Processar (se houver)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros do relatorio                                             ³
//³ mv_par01 - Vencimento de                                            ³
//³ mv_par02 - Vencimento ate                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta array com as perguntas
aAdd(aRegs,{	cPerg,;											// Grupo de perguntas
"01",;											// Sequencia
"Vencimento de   ?",;							// Nome da pergunta
"",;											// Nome da pergunta em espanhol
"",;							// Nome da pergunta em ingles
"mv_ch1",;										// Variável
"D",;											// Tipo do campo
08,;											// Tamanho do campo
0,;												// Decimal do campo
0,;												// Pré-selecionado quando for choice
"G",;											// Tipo de seleção (Get ou Choice)
"",;											// Validação do campo
"MV_PAR01",;									// 1a. Variável disponível no programa
"",;		  									// 1a. Definição da variável - quando choice
"",;											// 1a. Definição variável em espanhol - quando choice
"",;											// 1a. Definição variável em ingles - quando choice
"",; 											// 1o. Conteúdo variável
"",;											// 2a. Variável disponível no programa
"",;											// 2a. Definição da variável
"",;											// 2a. Definição variável em espanhol
"",;											// 2a. Definição variável em ingles
"",;											// 2o. Conteúdo variável
"",;											// 3a. Variável disponível no programa
"",;											// 3a. Definição da variável
"",;											// 3a. Definição variável em espanhol
"",;											// 3a. Definição variável em ingles
"",;											// 3o. Conteúdo variável
"",;											// 4a. Variável disponível no programa
"",;											// 4a. Definição da variável
"",;											// 4a. Definição variável em espanhol
"",;											// 4a. Definição variável em ingles
"",;											// 4o. Conteúdo variável
"",;											// 5a. Variável disponível no programa
"",;											// 5a. Definição da variável
"",;											// 5a. Definição variável em espanhol
"",;											// 5a. Definição variável em ingles
"",;											// 5o. Conteúdo variável
"",;											// F3 para o campo
"",;											// Identificador do PYME
"",;											// Grupo do SXG
"",;											// Help do campo
"" })											// Picture do campo
aAdd(aRegs,{cPerg,"02","Vencimento ate ?",			"",	"",			"mv_ch2","D",08,0,0,"G","","MV_PAR02","",			"","",				" ",				"","",				"","",				"","","",			"","",				"","","",			"","",				"","","",			"","",				"","",	"","","","" })
//aAdd(aRegs,{cPerg,"03","Qual imposto 	 ?",	 		"",	"",	 		"mv_ch3","C",01,0,0,"G","U_QUALIMP(@cTipo)","MV_PAR03","",	"","",	"",					"","",		"","",	"","","",	"","",	"","","",	"","",	"","","",	"","",	"","",		"","","","" })

U_CriaSx1(aRegs)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Solicita ao usuario a parametrizacao do relatorio.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,lDic,aOrd,lComp,Tamanho,lFiltro,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se teclar ESC, sair³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nLastKey = 27
	dbClearFilter()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Estabelece os padroes para impressao, conforme escolha do usuario³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetDefault(aReturn,cString)
If nLastKey = 27
	dbClearFilter()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verificar se sera reduzido ou normal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := Iif(aReturn[4] == 1, 15, 18)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama funcao que processa os dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

U_QUALIMP(@cTipos)

Processa( {|lEnd| CallData(@lEnd)}, "Aguarde", "Acumulando registros", .T. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Chama funcao que imprime os dados ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !lEnd
	DbSelectArea("E2TMP")
	If E2TMP->(RECCOUNT()) > 0
		RptStatus( {|lEnd| RunReport(@lEnd, wnrel, cString) }, Titulo, "Imprimindo registros", .T. )
	Else
		Aviso(	Titulo,;
		"Nao existem dados a imprimir.",;
		{"&Ok"},,;
		"Atencao" )
	EndIf
EndIf


//fecha os temporarios
If Select("E2TMP") > 0
	dbSelectArea("E2TMP")
	dbCloseArea()
EndIf


Return(Nil)


******************************************************************************************************
Static Function CallData(lEnd)
******************************************************************************************************

Local cQuery	:= ""
Local cCount	:= "SELECT COUNT(*) AS TOTREG "
Local cSelect	:= "SELECT "
Local cFrom		:= "FROM "
Local cWhere	:= "WHERE "
Local cGroup	:= "GROUP BY "
Local cOrder	:= "ORDER BY "
Local nTotReg	:= 0
Local nQuant	:= 0
Local nValor	:= 0
Local cForTX	:= GetMv("MV_UNIAO")
Local cForIss	:= GetMv("MV_MUNIC")
Local cForIns	:= GetMv("MV_FORINSS")
Local cNatISS	:= GetMv("MV_ISS")
Local cNatIrf	:= GetMv("MV_IRF")
Local cNatIns	:= GetMv("MV_INSS")
Local cNatPis 	:= GetMv("MV_PISNAT")
Local cNatCof	:= GetMv("MV_COFINS")
Local cNatCsll	:= GetMv("MV_CSLL")
Local aStrSE2	:= {}
Local cInd1		:= " "

Aadd(aStrSE2,{"E2_FILIAL",	"C",02,0})
Aadd(aStrSE2,{"E2_PREFIXO","C",03,0})
Aadd(aStrSE2,{"E2_NUM",		"C",09,0})
Aadd(aStrSE2,{"E2_PARCELA","C",02,0})
Aadd(aStrSE2,{"E2_TIPO",	"C",03,0})
Aadd(aStrSE2,{"E2_NATUREZ","C",10,0})
Aadd(aStrSE2,{"E2_VENCREA","D",08,0})
Aadd(aStrSE2,{"E2_VALOR",	"N",14,2})
Aadd(aStrSE2,{"E2_CODRET",	"C",04,0})
Aadd(aStrSE2,{"E2_DIRF",	"C",01,0})
Aadd(aStrSE2,{"E2_NUMTIT","C",25,0})
Aadd(aStrSE2,{"TPIMP" 	 ,"C",03,0})
Aadd(aStrSE2,{"E2_FORNECE","C",06,0})
Aadd(aStrSE2,{"E2_LOJA" 	 ,"C",02,0})
Aadd(aStrSE2,{"E2_TITPAI","C",50,0})
Aadd(aStrSE2,{"E2_EMISSAO","D",08,0})

cTmpSE2	:= CriaTrab(aStrSE2,.T.)
DbUseArea(.T.,,cTmpSE2,"E2TMP",.F.)
cInd1	:= CRIATRAB(NIL,.F.)
IndRegua("E2TMP",cInd1,"E2_FILIAL+TPIMP+E2_CODRET+E2_PREFIXO+E2_NUM+E2_PARCELA",,,"Criando indice temporario")
DbSelectArea("E2TMP")
dbGoTop()

cNatIrf	:= StrTran(cNatIrf,'"',"")
cNatIns	:= StrTran(cNatIns,'"',"")
cNatIss	:= StrTran(cNatIss,'"',"")
cNatPis	:= StrTran(cNatPis,'"',"")
cNatCof	:= StrTran(cNatCof,'"',"")
cNatCsll	:= StrTran(cNatCsll,'"',"")

// checar se o arquivo SE2 e exclusivo ou compartilhado
If xFilial("SE2") <> " "
	cSelect	+= " E2.E2_FILIAL AS FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA, E2.E2_NATUREZ, E2.E2_FORNECE,E2.E2_LOJA,E2.E2_EMISSAO,E2.E2_TITPAI "
	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
Else
	cSelect	+= " E2.E2_MSFIL AS FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA, E2.E2_NATUREZ, E2.E2_FORNECE,E2.E2_LOJA,E2.E2_EMISSAO,E2.E2_TITPAI "
	cOrder	+= " E2_MSFIL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
EndIf


If "IRF"$cTipos
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'TX' "
	cWhere	+= " AND E2.E2_NATUREZ = '"+cNatIrf+"' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando IRRF")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR	:= TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP		:= "IRF"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
EndIf

If "INS"$cTipos
	cFrom		:= "FROM "
	cWhere	:= "WHERE "
	cGroup	:= "GROUP BY "
	
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA. E2.E2_EMISSAO "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'INS' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando INSS")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR  	:= TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP    	:= "INS"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
Endif

If "ISS"$cTipos
	cFrom		:= "FROM "
	cWhere	:= "WHERE "
	cGroup	:= "GROUP BY "
	
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'ISS' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando ISS")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR	    := TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP	    := "ISS"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
Endif

If "PIS"$cTipos
	cFrom		:= "FROM "
	cWhere	:= "WHERE "
	cGroup	:= "GROUP BY "
	
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'TX' "
	cWhere	+= " AND E2.E2_NATUREZ = '"+cNatPis+"' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando PIS ")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR	    := TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP     	:= "PIS"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
EndIf
If "COF"$cTipos
	cFrom		:= "FROM "
	cWhere	:= "WHERE "
	cGroup	:= "GROUP BY "
	
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'TX' "
	cWhere	+= " AND E2.E2_NATUREZ = '"+cNatCof+"' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando COFINS ")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR  	:= TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP     	:= "COF"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
Endif
If "CSL"$cTipos
	cFrom		:= "FROM "
	cWhere	:= "WHERE "
	cGroup	:= "GROUP BY "
	
	//	cSelect	+= " E2.E2_FILIAL,E2.E2_PREFIXO,E2.E2_NUM,E2.E2_PARCELA,E2.E2_TIPO,E2.E2_VALOR,E2.E2_CODRET,E2.E2_DIRF, E2.E2_NUMTIT, E2.E2_VENCREA "
	cFrom		+= " "+RetSqlName("SE2")+" E2 "
	//	cWhere	+= " E2.E2_FILIAL = '"+xFilial("SE2")+"'"
	cWhere	+= " E2.E2_VENCREA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
	cWhere	+= " AND E2.E2_TIPO = 'TX' "
	cWhere	+= " AND E2.E2_NATUREZ = '"+cNatCsll+"' "
	cWhere	+= " AND E2.D_E_L_E_T_ <> '*'"
	//	cOrder	+= " E2_FILIAL,E2_TIPO,E2_CODRET,E2_PREFIXO,E2_NUM,E2_PARCELA"
	
	CursorWait()
	// Define a quantidade de registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cCount+cFrom+cWhere NEW ALIAS "TMPSE2"
	nTotReg	:= TMPSE2->TOTREG
	
	// Define os registros a processar
	If Select("TMPSE2") > 0
		dbSelectArea("TMPSE2")
		dbCloseArea()
	EndIf
	TCQUERY cSelect+cFrom+cWhere NEW ALIAS "TMPSE2"
	
	// Ajusta campos numéricos e data
	aEval(SE2->(dbStruct()), {|x| If(x[2] <> "C" .And. FieldPos(x[1]) > 0, TcSetField("TMPSE2",x[1],x[2],x[3],x[4]),Nil)})
	CursorArrow()
	
	// Acumula array com os dados a imprimir
	dbSelectArea("TMPSE2")
	dbgoTop()
	ProcRegua(nTotReg)
	While !Eof() .And. !lEnd
		// Atualiza a regua de processamento
		IncProc("Processando CSLL ")
		// Verifica se abortou a roptina
		If lEnd
			@ Li,000 PSAY "Cancelado pelo operador"
			Exit
		EndIf
		
		DbSelectArea("E2TMP")
		DbSetOrder(1)
		RecLock("E2TMP",.T.)
		E2TMP->E2_FILIAL 	:= TMPSE2->FILIAL
		E2TMP->E2_PREFIXO	:= TMPSE2->E2_PREFIXO
		E2TMP->E2_NUM		:= TMPSE2->E2_NUM
		E2TMP->E2_PARCELA	:= TMPSE2->E2_PARCELA
		E2TMP->E2_TIPO		:= TMPSE2->E2_TIPO
		E2TMP->E2_NATUREZ	:= TMPSE2->E2_NATUREZ
		E2TMP->E2_VENCREA	:= TMPSE2->E2_VENCREA
		E2TMP->E2_VALOR 	:= TMPSE2->E2_VALOR
		E2TMP->E2_CODRET	:= TMPSE2->E2_CODRET
		E2TMP->E2_DIRF		:= TMPSE2->E2_DIRF
		E2TMP->E2_NUMTIT	:= TMPSE2->E2_NUMTIT
		E2TMP->TPIMP    	:= "CSL"
		E2TMP->E2_FORNECE	:= TMPSE2->E2_FORNECE
		E2TMP->E2_LOJA		:= TMPSE2->E2_LOJA
		E2TMP->E2_EMISSAO	:= TMPSE2->E2_EMISSAO
		E2TMP->E2_TITPAI	:= TMPSE2->E2_TITPAI
		MsUnlock()
		// Volta para o arquivo original e passa para o próximo registro
		dbSelectArea("TMPSE2")
		dbSkip()
	EndDo
EndIf

Return(Nil)


******************************************************************************************************
Static Function RunReport(lEnd, wnrel, cString)
******************************************************************************************************

Local Cabec0     	:= AllTrim(Titulo)
Local cFilAtu   	:= " "
Local nTotCod   	:= 0
Local nTotFil   	:= 0
Local nTotGer   	:= 0
Local cQuebra1  	:= " "
Local cQuebra2  	:= " "
Local aRetPai   	:= {}
Local	nTotCod 	:= 0
Local	nTotTrib	:= 0
Local nTotCodFil	:= 0
Local	nTotTribFil	:= 0
Local nTotCodGer	:= 0
Local	nTotTribGer	:= 0
Local aTotGer		:= {}
Local aTotFil		:= {}
Local Ix			:= 0
Local nElem			:= 0
Local nElem1		:= 0

//         10        20        30        40        50        60        70        80        90        100       110       120       130      140       150       160       170       180       190       200       210       220
//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//XXXXXX-XX  XXXXXXXXXXXXXXXXXXXX  XXX  XXX-XXXXXX-XX  DD/MM/AA  DD/MM/AA      999,999,999.99  999,999,999.99    999,99        XXXX  XXX
Cabec1	:= "Fornec      Nome Reduz.           Tipo Documento      Fato Ger. Recolhim.  Rendim.Tributavel         Imposto  Aliquota  Cod.Reten.  Recolhe?"
Cabec2	:= ""

DbSelectArea("E2TMP")
DbGoTop()
SetRegua(RecCount())

While !Eof()
	
	cQuebra1	:= E2TMP->E2_FILIAL
	
	// Movimenta regua de processamento
	IncRegua("Processando filial "+cQuebra1)
	
	If Li > 52
		Cabec(Cabec0,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	li++
	@li,000 Psay Replicate("-",limite)
	li++
	@ li,000 Psay "Filial "+E2TMP->E2_FILIAL+"  -  "+Posicione("SM0",1,SM0->M0_CODIGO+E2TMP->E2_FILIAL,"M0_FILIAL")
	li+=2
	
	While !eof() .and. E2TMP->E2_FILIAL == cQuebra1
		
		cquebra2	:= E2TMP->E2_FILIAL+E2TMP->TPIMP+E2TMP->E2_CODRET
		
		If Li > 52
			Cabec(Cabec0,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		EndIf
		
		While !eof() .and. E2TMP->(E2_FILIAL+TPIMP+E2_CODRET) == cQuebra2
			// Busca dados do titulo gerador do imposto
			aRetPai	:= BuscaPai(E2TMP->E2_TIPO,E2TMP->E2_NATUREZ)
			
			If Li > 52
				Cabec(Cabec0,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
			
			// Imprime os dados
			@ Li,000 PSAY aRetPai[1]+" "+aRetPai[2]
			@ Li,011 PSAY aRetPai[3]
			@ Li,033 PSAY E2TMP->TPIMP
			@ Li,038 PSAY E2TMP->E2_PREFIXO
			@ Li,042 PSAY RTRIM(E2TMP->E2_NUM)
			@ Li,049 PSAY E2TMP->E2_PARCELA
			@ Li,053 PSAY E2TMP->E2_EMISSAO
			@ Li,063 PSAY E2TMP->E2_VENCREA
			@ Li,077 PSAY aRetPai[4] Picture "@E 999,999,999.99"
			@ Li,093 PSAY E2TMP->E2_VALOR Picture "@E 999,999,999.99"
			@ Li,111 PSAY Round((E2TMP->E2_VALOR/aRetPai[4]*100),2) Picture "@E 999.99%"
			@ Li,125 PSAY E2TMP->E2_CODRET
			@ Li,131 PSAY IIf(E2TMP->E2_DIRF=="2","Nao","Sim")
			Li++
			
			nTotCod 	+= E2TMP->E2_VALOR
			nTotTrib	+= aRetPai[4]
			
			nElem := Ascan(aTotFil,{|x|x[1]==E2TMP->TPIMP})
			If nElem == 0
				Aadd(aTotFil,{E2TMP->TPIMP,aRetPai[4],E2TMP->E2_VALOR})
			Else
				aTotFil[nElem,2]+= aRetPai[4]
				aTotFil[nElem,3]+= E2TMP->E2_VALOR
			EndIf
			
			DbSelectArea("E2TMP")
			DbSkip()
		EndDo
		
		// Imprime total por filial+imposto+codigo de retencao
		//		li++
		@ Li,055 Psay "Valor a recolher: "
		@ Li,077 Psay nTotTrib Picture 	"@E 999,999,999.99"
		@ Li,093 Psay nTotCod  Picture "@E 999,999,999.99"
		Li++
		@ Li,056 Psay "Total do codigo: "
		@ Li,077 Psay nTotTrib Picture 	"@E 999,999,999.99"
		@ Li,093 Psay nTotCod  Picture 	"@E 999,999,999.99"
		Li+=2
		
		nTotCodFil	+= nTotCod
		nTotTribFil	+= nTotTrib
		nTotCod 	:= 0
		nTotTrib	:= 0
		
		DbSelectArea("E2TMP")
	EndDo
	
	If Li > 52
		Cabec(Cabec0,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	EndIf
	
	// Imprime total da filial
	/*
	li++
	@ li,000 Psay Replicate("-",limite)
	Li++
	*/
	@Li,055 Psay "Resumo da filial:"
	li++
	If Len(aTotFil) > 0
		For ix:= 1 to Len(aTotFil)
			@Li,069 Psay aTotFil[ix][1]
			@Li,077 Psay aTotFil[ix][2] Picture 	"@E 999,999,999.99"
			@Li,093 Psay aTotFil[ix][3] Picture 	"@E 999,999,999.99"
			Li++
			nElem1 := Ascan(aTotGer,{|x|x[1]==aTotFil[ix][1]})
			If nElem1 == 0
				Aadd(aTotGer,{aTotFil[ix][1],aTotFil[ix][2],aTotFil[ix][3]})
			Else
				aTotGer[nElem1,2]+= aTotFil[ix][2]
				aTotGer[nElem1,3]+= aTotFil[ix][3]
			EndIf
		Next
	EndIf
	
	aTotFil	:= {}
	Li++
	@ Li,067 Psay "Total:"
	@ Li,077 Psay nTotTribFil 	Picture 	"@E 999,999,999.99"
	@ Li,093 Psay nTotCodFil	Picture 	"@E 999,999,999.99"
	Li++
	
	nTotCodGer	+= nTotCodFil
	nTotTribGer	+= nTotTribFil
	
	nTotCodFil	:= 0
	nTotTribFil	:= 0
	
	DbSelectArea("E2TMP")
EndDo

If Li > 52
	Cabec(Cabec0,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
EndIf

// Imprime total geral da empresa
li+=2
@ li,000 Psay Replicate("-",limite)
Li++
@Li,056 Psay "Resumo empresa:"
li++
If Len(aTotGer)>0
	For iY:= 1 to Len(aTotGer)
		@ Li, 069 Psay aTotGer[iY][1]
		@ Li, 077 Psay aTotGer[iY][2] Picture 	"@E 999,999,999.99"
		@ Li, 093 Psay aTotGer[iY][3] Picture 	"@E 999,999,999.99"
		Li++
	Next
EndIf
li+=2
aTotGer	:= {}
@ Li,067 Psay "Total:"
@ Li,077 Psay nTotTribGer Picture 	"@E 999,999,999.99"
@ Li,093 Psay nTotCodGer	Picture 	"@E 999,999,999.99"
Li++

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o rodape do relatorio                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Roda(cbCont,cbTxt,Tamanho)

If aReturn[5] == 1
	Set Printer TO
	dbCommitAll()
	Ourspool(wnrel)
EndIf

Ms_Flush()

Return(Nil)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QualIMP   ³ Autor ³ Andreza Favero        ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Abre tela com tipos de titulos.                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function QualIMP(cTipos)

LOCAL cCapital
LOCAL nX
LOCAL cCad  := "Tipos de Titulos"
LOCAL cAlias:= Alias()
LOCAL oOk := LoadBitmap( GetResources(), "LBOK" )
LOCAL oNo := LoadBitmap( GetResources(), "LBNO" )
LOCAL oQual
LOCAL cVar := "  "
LOCAL nOpca
LOCAL oDlg
LOCAL aTipoBack:={}
LOCAL aTipos:={}
Local lRunDblClick := .T.

Aadd(aTipos,{.T.,"COFINS","Contrib. de Integracao Social ","COF"})
Aadd(aTipos,{.T.,"CSLL  ","Contrib.Social s/Lucro Liquido","CSL"})
Aadd(aTipos,{.T.,"INSS  ","Imposto N. Securidade Social  ","INS"})
Aadd(aTipos,{.T.,"IRRF  ","Imposto de Renda              ","IRF"})
Aadd(aTipos,{.T.,"ISS   ","Imposto sobre Servicos        ","ISS"})
Aadd(aTipos,{.T.,"PIS   ","Programa de Integracao Social ","PIS"})

aTipoBack := aClone(aTipos)
nOpca := 0
DEFINE MSDIALOG oDlg TITLE cCad From 9,0 To 35,50 OF oMainWnd

@0.5,  0.3 TO 13.6, 20.0 LABEL cCad OF oDlg
@2.3,3 Say OemToAnsi("  ")
@ 1.0,.7 LISTBOX oQual VAR cVar Fields HEADER "",OemToAnsi("Código"),OemToAnsi("Descrição")  SIZE 150,170 ON DBLCLICK (aTipoBack:=FA060Troca(oQual:nAt,aTipoBack),oQual:Refresh()) NOSCROLL  //"Tipos de T¡tulos"

oQual:SetArray(aTipoBack)
oQual:bLine := { || {if(aTipoBack[oQual:nAt,1],oOk,oNo),aTipoBack[oQual:nAt,2],aTipoBack[oQual:nAt,3]}}
oQual:bHeaderClick := {|oObj,nCol| If(lRunDblClick .And. nCol==1, aEval(aTipoBack, {|e| e[1] := !e[1]}),Nil), lRunDblClick := !lRunDblClick, oQual:Refresh()}

DEFINE SBUTTON FROM 10  ,166  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON FROM 22.5,166  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg

IF nOpca == 1
	aTipos := Aclone(aTipoBack)
EndIF
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a string de tipos para filtrar o arquivo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTipos :=""
For nX := 1 To Len(aTipos)
	If aTipos[nX,1]
		cTipos += aTipos[nX,4]+"/"
	End
Next nX

DeleteObject(oOk)
DeleteObject(oNo)

dbSelectArea(cAlias)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaPai  ºAutor  ³Microsiga           º Data ³  10/15/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Busca o titulo que originou o imposto                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BuscaPai(cTipo,cNatureza)

Local aRet	:= {}		// 1 elemento: CGC	- 2 elemento: Nome
Local aArea	:= GetArea()
Local aArSe2:= SE2->(GetArea())
Local aArSA2:= SA2->(GetArea())
Local cQuery:= " "
Local cTitImp	:= " "
Local cForTX	:= GetMv("MV_UNIAO")
Local cForIss	:= GetMv("MV_MUNIC")
Local cForIns	:= GetMv("MV_FORINSS")
Local cNatISS	:= GetMv("MV_ISS")
Local cNatIrf	:= GetMv("MV_IRF")
Local cNatIns	:= GetMv("MV_INSS")
Local cNatPis 	:= GetMv("MV_PISNAT")
Local cNatCof	:= GetMv("MV_COFINS")
Local cNatCsll	:= GetMv("MV_CSLL")
Local nVlrTrib	:= 0
Local	cFornec	:= " "
Local	cLoja		:= " "
Local	cNomRed	:= " "


cNatIrf	:= StrTran(cNatIrf,'"',"")
cNatIns	:= StrTran(cNatIns,'"',"")
cNatIss	:= StrTran(cNatIss,'"',"")
cNatPis	:= StrTran(cNatPis,'"',"")
cNatCof	:= StrTran(cNatCof,'"',"")
cNatCsll	:= StrTran(cNatCsll,'"',"")

If Empty(E2TMP->E2_NUMTIT)
	// Procura o titulo de origem do ISS
	If cTipo ==  "ISS"
		cQryISS	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
		cQryISS	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
		cQryISS	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
		//cQryISS	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
		//cQryISS	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
		cQryISS	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
		cQryISS	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
		//cQryISS	+= " AND SE2.E2_PARCISS = '"+E2TMP->E2_PARCELA+"' "
		cQryISS	+= " AND SA2.D_E_L_E_T_ <> '*' "
		cQryISS	+= " AND SE2.D_E_L_E_T_ <> '*' "
		cQryISS	+= " AND (E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) LIKE '%"+alltrim(E2TMP->E2_TITPAI)+"%'
		
		If Select("TMPISS") > 0
			DbSelectArea("TMPISS")
			DbCloseArea("TMPISS")
		EndIf
		
		TcQuery cQryISS NEW ALIAS "TMPISS"
		
		DbSelectArea("TMPISS")
		DbGoTop()
		While !Eof()
			aRet	:= {TMPISS->E2_FORNECE,TMPISS->E2_LOJA,TMPISS->A2_NREDUZ, TMPISS->E2_VALOR}
			DbSelectArea("TMPISS")
			DbSkip()
		EndDo
		
	ElseIf cTipo == "INS"
		
		cQryINS	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
		cQryINS	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
		cQryINS	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
		//cQryINS	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
		//cQryINS	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
		cQryINS	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
		cQryINS	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
		//cQryINS	+= " AND SE2.E2_PARCINS = '"+E2TMP->E2_PARCELA+"' "
		cQryINS	+= " AND SA2.D_E_L_E_T_ <> '*' "
		cQryINS	+= " AND SE2.D_E_L_E_T_ <> '*' "
		cQryINS	+= " AND (E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) LIKE '%"+alltrim(E2TMP->E2_TITPAI)+"%'
		
		If Select("TMPINS") > 0
			DbSelectArea("TMPINS")
			DbCloseArea("TMPINS")
		EndIf
		
		TcQuery cQryINS NEW ALIAS "TMPINS"
		
		DbSelectArea("TMPINS")
		DbGoTop()
		While !Eof()
			aRet	:= {TMPINS->E2_FORNECE,TMPINS->E2_LOJA,TMPINS->A2_NREDUZ,TMPINS->E2_VALOR}
			DbSelectArea("TMPINS")
			DbSkip()
		EndDo
		
	ElseIf Alltrim(cTipo) == "TX"
		
		// o TX envolve os titulos de IRRF, PIS, Cofins e CSLL. A diferenciacao sera pela natureza
		
		If Alltrim(cNatureza) == Alltrim(cNatIRF)		// trata-se do IRRF
			cQryIRF	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
			cQryIRF	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
			cQryIRF	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
			cQryIRF	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
			cQryIRF	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
			cQryIRF	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
			cQryIRF	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
			cQryIRF	+= " AND SE2.E2_PARCIR = '"+E2TMP->E2_PARCELA+"' "
			cQryIRF	+= " AND SA2.D_E_L_E_T_ <> '*' "
			cQryIRF	+= " AND SE2.D_E_L_E_T_ <> '*' "
			
			If Select("TMPIRF") > 0
				DbSelectArea("TMPIRF")
				DbCloseArea("TMPIRF")
			EndIf
			
			TcQuery cQryIRF NEW ALIAS "TMPIRF"
			
			DbSelectArea("TMPIRF")
			DbGoTop()
			While !Eof()
				aRet	:= {TMPIRF->E2_FORNECE,TMPIRF->E2_LOJA,TMPIRF->A2_NREDUZ,TMPIRF->E2_VALOR}
				DbSelectArea("TMPIRF")
				DbSkip()
			EndDo
			
		ElseIf Alltrim(cNatureza)  == Alltrim(cNatPis)		// trata-se de PIS
			cQryPIS	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
			cQryPIS	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
			cQryPIS	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
			//cQryPIS	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
			//cQryPIS	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
			cQryPIS	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
			cQryPIS	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
			//	cQryPIS	+= " AND SE2.E2_PARCPIS = '"+E2TMP->E2_PARCELA+"' "
			cQryPIS	+= " AND SA2.D_E_L_E_T_ <> '*' "
			cQryPIS	+= " AND SE2.D_E_L_E_T_ <> '*' "
			cQryPIS	+= " AND (E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) LIKE '%"+alltrim(E2TMP->E2_TITPAI)+"%'
			
			If Select("TMPPIS") > 0
				DbSelectArea("TMPPIS")
				DbCloseArea("TMPPIS")
			EndIf
			
			TcQuery cQryPIS NEW ALIAS "TMPPIS"
			
			DbSelectArea("TMPPIS")
			DbGoTop()
			While !Eof()
				aRet	:= {TMPPIS->E2_FORNECE,TMPPIS->E2_LOJA,TMPPIS->A2_NREDUZ,TMPPIS->E2_VALOR}
				DbSelectArea("TMPPIS")
				DbSkip()
			EndDo
			
		ElseIf Alltrim(cNatureza)  == Alltrim(cNatCof)		// trata-se de Cofins
			cQryCOF	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
			cQryCOF	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
			cQryCOF	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
			//cQryCOF	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
			//cQryCOF	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
			cQryCOF	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
			cQryCOF	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
			//cQryCOF	+= " AND SE2.E2_PARCCOF = '"+E2TMP->E2_PARCELA+"' "
			cQryCOF	+= " AND SA2.D_E_L_E_T_ <> '*' "
			cQryCOF	+= " AND SE2.D_E_L_E_T_ <> '*' "
			cQryCOF	+= " AND (E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) LIKE '%"+alltrim(E2TMP->E2_TITPAI)+"%'
			
			If Select("TMPCOF") > 0
				DbSelectArea("TMPCOF")
				DbCloseArea("TMPCOF")
			EndIf
			
			TcQuery cQryCOF NEW ALIAS "TMPCOF"
			
			DbSelectArea("TMPCOF")
			DbGoTop()
			While !Eof()
				aRet	:= {TMPCOF->E2_FORNECE,TMPCOF->E2_LOJA,TMPCOF->A2_NREDUZ,TMPCOF->E2_VALOR}
				DbSelectArea("TMPCOF")
				DbSkip()
			EndDo
			
		ElseIf Alltrim(cNatureza)  == Alltrim(cNatCSLL)		// trata-se de CSLL
			cQryCSL	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
			cQryCSL	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
			cQryCSL	+= " AND SE2.E2_FILIAL = '"+E2TMP->E2_FILIAL+"' "
			//cQryCSL	+= " AND SE2.E2_PREFIXO = '"+E2TMP->E2_PREFIXO+"' "
			//cQryCSL	+= " AND SE2.E2_NUM	= '"+E2TMP->E2_NUM+"' "
			cQryCSL	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
			cQryCSL	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
			//cQryCSL	+= " AND SE2.E2_PARCSLL = '"+E2TMP->E2_PARCELA+"' "
			cQryCSL	+= " AND SA2.D_E_L_E_T_ <> '*' "
			cQryCSL	+= " AND SE2.D_E_L_E_T_ <> '*' "
			cQryCSL	+= " AND (E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA) LIKE '%"+alltrim(E2TMP->E2_TITPAI)+"%'
			
			If Select("TMPCSL") > 0
				DbSelectArea("TMPCSL")
				DbCloseArea("TMPCSL")
			EndIf
			
			TcQuery cQryCSL NEW ALIAS "TMPCSL"
			
			DbSelectArea("TMPCSL")
			DbGoTop()
			While !Eof()
				aRet	:= {TMPCSL->E2_FORNECE,TMPCSL->E2_LOJA,TMPCSL->A2_NREDUZ,TMPCSL->E2_VALOR}
				DbSelectArea("TMPCSL")
				DbSkip()
			EndDo
		EndIf
	EndIf
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Nesta situacao, o titulo de imposto foi gerado atraves³
	//³da rotina de Apuracao de Impostos (FINA375)           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//	cTitIMP	:= SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	cTitIMP	:= E2TMP->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	
	cQryAgl	:= " SELECT (E2_VALOR+E2_ISS+E2_IRRF+E2_INSS+E2_VRETPIS+E2_VRETCOF+E2_VRETCSL) AS E2_VALOR,E2_FORNECE,E2_LOJA,A2_NOME,A2_NREDUZ FROM "+RetSqlName("SA2")+ " SA2 ,"+RetSqlName("SE2") + " SE2 "
	cQryAgl	+= " WHERE A2_FILIAL = '"+xFilial("SA2")+"' "
	cQryAgl	+= " AND SA2.A2_COD = SE2.E2_FORNECE  "
	cQryAgl	+= " AND SA2.A2_LOJA = SE2.E2_LOJA "
	cQryAgl	+= " AND SE2.E2_NUMTIT LIKE '"+ctitImp+" ' "
	cQryAgl	+= " AND SA2.D_E_L_E_T_ <> '*' "
	cQryAgl	+= " AND SE2.D_E_L_E_T_ <> '*' "
	
	If Select("TMPAGL") > 0
		DbSelectArea("TMPAGL")
		DbCloseArea("TMPAGL")
	EndIf
	
	TcQuery cQryAGL NEW ALIAS "TMPAGL"
	
	DbSelectArea("TMPAGL")
	DbGoTop()
	While !Eof()
		nVlrTrib    += TMPAGL->E2_VALOR
		cFornec 	:= TMPAGL->E2_FORNECE
		cLoja		:= TMPAGL->E2_LOJA
		cNomRed 	:= TMPAGL->A2_NREDUZ
		//		aRet	:= {TMPAGL->E2_FORNECE,TMPAGL->E2_LOJA,TMPAGL->A2_NREDUZ}
		DbSelectArea("TMPAGL")
		DbSkip()
	EndDo
	aRet	:= {cFornec,cLoja,cNomRed,nVlrTrib}
EndIf

If Len(aRet) == 0
	aRet	:= {" "," "," ",0}
EndIf

RestArea(aArSe2)
RestArea(aArSA2)
RestArea(aArea)

Return(aRet)
