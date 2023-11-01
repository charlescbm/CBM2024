#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10) 

/*****************************************************************************/
/*/{Protheus.doc} TFINR003
@description Relatorio - Comissão vendedor - financeiro
@type function
/*/
/*****************************************************************************/
User Function TFINR003()
Local oReport
Local aTipo := {"Relatório", "Excel"}

Private cPerg  	:= "TFINR03"								// Nome do grupo de perguntas
Private aParam	:= {}
Private oProc

If ParamBox({;
				{3, "Tipo de Visualização: ", 1, aTipo, 100, "", .T.}	;
			}, "Rel.Desc.Comissao-TFINR003", aParam)
	
	
	if mv_par01 == 1	//Se relatorio

		oReport	:= ReportDef()
		oReport:PrintDialog()

	else	//Se Excel

		//---------------------------+
		// Cria parametros relatorio |
		//---------------------------+                                                                    
		AjustaSx1( cPerg )

		Pergunte(cPerg, .T.)
		oProc := MsNewProcess():New({|| OKExcel()}, "Aguarde...", "Gerando Planilha Excel...")
		oProc:Activate()
		
	endif

EndIf


Return Nil

/*****************************************************************************/
/*/{Protheus.doc} ReportDef
@description Definicao do objeto do relatorio personalizavel e das secoes que serao utilizadas
@type function
/*/
/*****************************************************************************/
Static Function ReportDef()

Local oReport	:= Nil

Local cReport	:=	"TFINR003"								// Nome do Relatorio

//Local cPerg  	:= "TFINR03"								// Nome do grupo de perguntas
Local cTitulo	:= "Comissão Vendedores - Financeiro"		// "Listagem do Cadastro de C Custo"

Local aOrd	 	:= { "Vendedor",;							// "Vendedor"
					 "Nome"}								// "Nome"

Local cDesc		:= "Este programa ira imprimir a Comissao dos Vendedores" + ;
				   "Sera impresso de acordo com os parametros solicitados pelo" + ;
				   "usuario."

//---------------------------+
// Cria parametros relatorio |
//---------------------------+                                                                    
AjustaSx1( cPerg )
Pergunte( cPerg, .F.)

//-------------------------------------------------------------------------+
// Criacao do componente de impressao                                      |
//                                                                         |
// TReport():New                                                           |
// ExpC1 : Nome do relatorio                                               |
// ExpC2 : Titulo                                                          |
// ExpC3 : Pergunte                                                        |
// ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  |
// ExpC5 : Descricao                                                       |
//                                                                         |
//-------------------------------------------------------------------------+
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| TFINR03Prt(oReport)}, cDesc )

//---------------------+
// Relatorio analitico |
//---------------------+
oVendAnal := TRSection():New( oReport, "Vendedores" , {"SA3"}, aOrd )
TRCell():New(oVendAnal,"VENDEDOR"		,"   ","Vendedor"			,PesqPict("SA3","A3_COD")	,TamSx3("A3_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oVendAnal,"NOME_VEND"		,"   ","Nome"				,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
oVendAnal:SetHeaderSection(.T.)
oVendAnal:SetHeaderBreak(.T.)

//------------------------------------------------------------+
// Seção - Comissões a descontar dentro do mes de faturamento |
//------------------------------------------------------------+
oNotas := TRSection():New( oReport, "Comissão Vendedor " , {"SA1","SA3","SF2","SD2","SF4","SE1"}, aOrd )
oNotas:SetTotalInLine(.T.) 
oNotas:SetHeaderSection(.T.)
oNotas:SetHeaderBreak(.F.)
  
TRCell():New(oNotas,"ID"			,"   ","ID"					,PesqPict("SF2","F2_DOC")		,1							,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNotas,"NOTA"			,"   ","Nota"				,PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"SERIE"			,"   ","Serie"				,PesqPict("SF2","F2_SERIE")		,TamSx3("F2_SERIE")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"CLIENTE"		,"   ","Cliente"			,PesqPict("SF2","F2_CLIENTE")	,TamSx3("F2_CLIENTE")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"LOJA"			,"   ","Loja"				,PesqPict("SF2","F2_LOJA")		,TamSx3("F2_LOJA")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"NOME_CLI"		,"   ","Nome/Razao"			,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"PARCELA"		,"   ","Parcela"			,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"DATA_VENCTO"	,"   ","Dta. Vencto"		,PesqPict("SE1","E1_VENCREA")	,TamSx3("E1_VENCREA")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"DATA_BAIXA"	,"   ","Dta. Baixa"			,PesqPict("SE1","E1_BAIXA")		,TamSx3("E1_BAIXA")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORNF"	,"   ","Total Nota"				,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORCO"	,"   ","Valor Comissao"			,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oVendAnal,oVendAnal:Cell("VENDEDOR"),"",.T.)
TRFunction():New(oNotas:Cell("VALORCO"),NIL,"SUM",oBreak,"TOTAL COMISSAO",,/*uFormula*/,.F.,.T.,.F.) 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFINR03Prt

@description Realiza a impressao do relatorio de comissoes 
@type function
/*/
/*****************************************************************************/
Static Function TFINR03Prt( oReport )
Private oProcess	:= Nil

oProcess:= MsNewProcess():New( {|lEnd| TFinR03Ana(oReport)},"Aguarde...","Imprimindo comissões." )
oProcess:Activate()
 
Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinR03Ana
@description Realiza a impressão do relatorio analitico

/*/
/*****************************************************************************/
Static Function TFinR03Ana(oReport)
Local _cAlias		:= GetNextAlias()

Local _cCodVend		:= ""
Local _cNomeVend	:= ""

Local _nTotReg		:= 0

Local _oSecao01 	:= oReport:Section(1)
Local _oSecao02		:= oReport:Section(2)


//--------------------------+
// Query consulta comissoes |
// conforme parametros      |
//--------------------------+ 
If !TFinr03Qry(_cAlias,@_nTotReg)
	MsgStop("Não existem dados para serem impressos.Favor verificar parametros informados.","INOVEN - Avisos")
	Return oReport
EndIf

//--------------------+
// Total de registros |
//--------------------+
oReport:SetMeter( _nTotReg )
oProcess:SetRegua1(-1)

While (_cAlias)->( !Eof() )
	
	//-----------------------------------+	
	// Incrementa regra de processamento |
	//-----------------------------------+
	oReport:IncMeter()
	
	//--------------------------------------------+
	// Valida se houve cancelamento pelo ususario |
	//--------------------------------------------+
	If oReport:Cancel()
		Exit
	EndIf
	
	//-----------------------+
	// Guarda vendedor atual | 
	//-----------------------+
	_cCodVend	:= (_cAlias)->VENDEDOR
	_cNomeVend	:= (_cAlias)->NOME_VEND
	
	//--------------------------------+
	// Regua de processamento process | 
	//--------------------------------+
	oProcess:IncRegua1("Vendedor " + Rtrim(_cCodVend) + " - " + RTrim(_cNomeVend))
	
	//------------------+
	// Inicia Impressao |
	//------------------+
	oReport:StartPage()
	
	_oSecao01:Init()
	_oSecao02:Init()
		
	_oSecao01:Cell("VENDEDOR"):SetBlock({|| _cCodVend })
	_oSecao01:Cell("NOME_VEND"):SetBlock({|| _cNomeVend })
		
	_oSecao01:PrintLine()

	
	oProcess:SetRegua2(_nTotReg)
	While (_cAlias)->( !Eof() .And. _cCodVend == (_cAlias)->VENDEDOR )
		
		oProcess:IncRegua2("Numero / Prefixo " + RTrim((_cAlias)->NOTA) + "/" + RTrim((_cAlias)->SERIE))
		
		_oSecao02:Cell("ID"):SetBlock({|| (_cAlias)->ID })
		_oSecao02:Cell("NOTA"):SetBlock({||  (_cAlias)->NOTA })
		_oSecao02:Cell("SERIE"):SetBlock({|| (_cAlias)->SERIE })
		_oSecao02:Cell("CLIENTE"):SetBlock({|| (_cAlias)->CLIENTE })
		_oSecao02:Cell("LOJA"):SetBlock({|| (_cAlias)->LOJA })
		_oSecao02:Cell("NOME_CLI"):SetBlock({|| (_cAlias)->NOME_CLI })
		_oSecao02:Cell("PARCELA"):SetBlock({|| (_cAlias)->PARCELA })
		_oSecao02:Cell("DATA_VENCTO"):SetBlock({|| dToc(sTod((_cAlias)->DATA_VENCTO)) })
		_oSecao02:Cell("DATA_BAIXA"):SetBlock({|| dToc(sTod((_cAlias)->DATA_BAIXA)) })
		_oSecao02:Cell("VALORNF"):SetBlock({|| (_cAlias)->VALOR_NF })
		_oSecao02:Cell("VALORCO"):SetBlock({|| (_cAlias)->VALOR_COMISSAO })
		_oSecao02:PrintLine()
		_oSecao02:SetHeaderSection(.F.)
		_oSecao02:SetHeaderBreak(.T.)
	
		(_cAlias)->( dbSkip() )
		
	EndDo
	//--------------------------+
	// Imprime linha horizontal |
	//--------------------------+
	oReport:ThinLine()
	oReport:SkipLine()
	
	//-----------------+
	// Encerra Section |
	//-----------------+
	_oSecao01:Finish()
	_oSecao02:Finish()
	oReport:EndPage()

EndDo

//--------------------+
// Encerra temporario | 
//--------------------+
(_cAlias)->( dbCloseArea() )

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinr03Qry

@description Realiza consulta das comissoes 

*/
/*****************************************************************************/
Static Function TFinr03Qry(_cAlias,_nTotReg)
Local aArea			:= GetArea()
Local _cQuery		:= ""

Local _cVendDe		:= mv_par01
Local _cVendAte		:= mv_par02

Local _dDtaDe		:= TFinR01Dta(mv_par03,1)
Local _dDtaAte		:= TFinR01Dta(mv_par04,2)
Local _dDtaVencto	:= TFinR01Dta(mv_par03,3)
//Local _dDtBaixa		:= TFinR01Dta(mv_par04,4)
Local _dDtBaixa		:= DaySum( LastDate(mv_par04), 3 )

Local _nPComis		:= GetNewPar("IN_ALICOMI",2)

_cQuery :=	" SELECT " + CRLF
_cQuery	+= " 	ID, " + CRLF
_cQuery	+= " 	VENDEDOR, " + CRLF
_cQuery	+= " 	NOME_VEND, " + CRLF
_cQuery	+= " 	NOTA, " + CRLF
_cQuery	+= " 	SERIE, " + CRLF
_cQuery	+= " 	CLIENTE, " + CRLF
_cQuery	+= " 	LOJA, " + CRLF
_cQuery	+= " 	NOME_CLI, " + CRLF
_cQuery	+= "	PARCELA," + CRLF
_cQuery	+= "	DATA_VENCTO," + CRLF
_cQuery	+= "	DATA_BAIXA," + CRLF
_cQuery	+= " 	VALOR_NF, " + CRLF
_cQuery	+= " 	VALOR_COMISSAO " + CRLF
_cQuery	+= " FROM ( " + CRLF
//---------------------------------------------+
// COMISSAO NAO PAGA NO PERIODO DE FATURAMENTO |
//---------------------------------------------+
_cQuery	+= "		SELECT " + CRLF
_cQuery	+= "			2 ID, " + CRLF
_cQuery	+= "			VENDEDOR, " + CRLF
_cQuery	+= " 			NOME_VEND, " + CRLF
_cQuery	+= "			NOTA, " + CRLF
_cQuery	+= "			SERIE, " + CRLF
_cQuery	+= "			CLIENTE, " + CRLF
_cQuery	+= "			LOJA, " + CRLF
_cQuery	+= "			NOME_CLI, " + CRLF
_cQuery	+= "			PARCELA," + CRLF
_cQuery	+= "			DATA_VENCTO," + CRLF
_cQuery	+= "			DATA_BAIXA," + CRLF
_cQuery	+= "			VALOR_NF, " + CRLF
_cQuery	+= "			( VALOR_NF * ( PER_COMIS / 100 ) ) * -1 VALOR_COMISSAO " + CRLF
_cQuery	+= "		FROM ( " + CRLF
_cQuery	+= "				SELECT " + CRLF
_cQuery	+= "					F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery	+= "					A3.A3_NOME NOME_VEND, " + CRLF
_cQuery	+= "					F2.F2_DOC NOTA, " + CRLF
_cQuery	+= "					F2.F2_SERIE SERIE, " + CRLF
_cQuery	+= "					F2.F2_CLIENTE CLIENTE, " + CRLF
_cQuery	+= "					F2.F2_LOJA LOJA, " + CRLF
_cQuery	+= "					A1.A1_NOME NOME_CLI, " + CRLF
_cQuery	+= "					E1.E1_PARCELA PARCELA," + CRLF
_cQuery	+= "					E1.E1_VENCREA DATA_VENCTO," + CRLF
_cQuery	+= "					E1.E1_BAIXA DATA_BAIXA," + CRLF
_cQuery	+= "				CASE " + CRLF
_cQuery	+= "					WHEN E1.E1_COMIS1 > 0 THEN " + CRLF 
_cQuery	+= "						E1.E1_COMIS1 " + CRLF
_cQuery	+= "					ELSE " + CRLF
_cQuery	+= "						" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery	+= "					END PER_COMIS, " + CRLF  
_cQuery	+= "					SUM(E1.E1_VALOR) VALOR_NF " + CRLF
_cQuery	+= "				FROM " + CRLF
_cQuery	+= "					" + RetSqlName("SE1") + " E1 " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SF2") + " 	F2 ON F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_SERIE AND F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "				WHERE " + CRLF
//_cQuery	+= "					( E1.E1_BAIXA = '' OR ( E1.E1_BAIXA > '" + _dDtBaixa + "' AND E1.E1_VENCTO <= '" + _dDtaAte + "' ) ) AND " + CRLF
//_cQuery	+= "					( E1.E1_BAIXA = '' OR ( E1.E1_BAIXA > '" + _dDtBaixa + "') ) AND " + CRLF	
//_cQuery	+= " 					E1.E1_VENCREA BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF
//_cQuery	+= "					E1.E1_BAIXA = '' AND " + CRLF	
//_cQuery	+= " 					E1.E1_VENCREA BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par05) + "' AND " + CRLF
_cQuery	+= "					( E1.E1_BAIXA = '' OR ( E1.E1_BAIXA > '" + dtos(_dDtBaixa) + "' ) ) AND " + CRLF
_cQuery	+= " 					E1.E1_VENCREA BETWEEN '" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "' AND " + CRLF
_cQuery	+= "					E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND " + CRLF  
_cQuery	+= " 					E1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "				GROUP BY F2.F2_VEND1,A3.A3_NOME,E1.E1_PARCELA,E1.E1_VENCREA,E1.E1_BAIXA,F2.F2_DOC,F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA,A1.A1_NOME,E1.E1_COMIS1 " + CRLF
_cQuery	+= "		) COMISSAO_DESCONTAR_EMISSAO" + CRLF

_cQuery	+= "		UNION ALL " + CRLF

_cQuery	+= "		SELECT " + CRLF
_cQuery	+= "			3 ID, " + CRLF
_cQuery	+= "			VENDEDOR, " + CRLF
_cQuery	+= "			NOME_VEND, " + CRLF
_cQuery	+= "			NOTA, " + CRLF
_cQuery	+= "			SERIE, " + CRLF
_cQuery	+= "			CLIENTE, " + CRLF
_cQuery	+= "			LOJA, " + CRLF
_cQuery	+= "			NOME_CLI, " + CRLF
_cQuery	+= "			PARCELA," + CRLF
_cQuery	+= "			DATA_VENCTO," + CRLF
_cQuery	+= "			DATA_BAIXA," + CRLF
_cQuery	+= "			VALOR_NF," + CRLF
_cQuery	+= "			( VALOR_NF * ( PER_COMIS / 100 ) ) VALOR_COMISSAO" + CRLF
_cQuery	+= "		FROM ( " + CRLF
_cQuery	+= "				SELECT " + CRLF
_cQuery	+= "					F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery	+= "					A3.A3_NOME NOME_VEND, " + CRLF
_cQuery	+= "					F2.F2_DOC NOTA, " + CRLF
_cQuery	+= "					F2.F2_SERIE SERIE, " + CRLF
_cQuery	+= "					F2.F2_CLIENTE CLIENTE, " + CRLF
_cQuery	+= "					F2.F2_LOJA LOJA, " + CRLF
_cQuery	+= "					A1.A1_NOME NOME_CLI, " + CRLF
_cQuery	+= "					E1.E1_PARCELA PARCELA," + CRLF
_cQuery	+= "					E1.E1_VENCREA DATA_VENCTO," + CRLF
_cQuery	+= "					E1.E1_BAIXA DATA_BAIXA," + CRLF
_cQuery	+= "					CASE " + CRLF
_cQuery	+= "						WHEN E1.E1_COMIS1 > 0 THEN " + CRLF 
_cQuery	+= "							E1.E1_COMIS1 " + CRLF
_cQuery	+= "					ELSE " + CRLF
_cQuery	+= "						" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery	+= "					END PER_COMIS, " + CRLF  
_cQuery	+= "					SUM( E1.E1_VALOR - E1.E1_SALDO ) VALOR_NF " + CRLF
_cQuery	+= "				FROM " + CRLF
_cQuery	+= "					" + RetSqlName("SE1") + " E1 " + CRLF 
_cQuery	+= "					INNER JOIN " + RetSqlName("SF2") + " F2 ON  F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_PREFIXO AND F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = ''  " + CRLF  
_cQuery	+= "					INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2')  AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "				WHERE " + CRLF
//_cQuery	+= "					E1.E1_VENCREA < '" + _dDtaVencto + "' AND " + CRLF 
//_cQuery	+= "					E1.E1_VENCREA < '" + dtos(mv_par05) + "' AND " + CRLF 
_cQuery	+= " 					E1.E1_VENCREA BETWEEN '20220101' AND '" + dtos(mv_par03) + "' AND " + CRLF
//_cQuery	+= "					E1.E1_BAIXA BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery	+= "					E1.E1_BAIXA > '" + dtos(DaySum( FirstDate(mv_par03), 2 )) + "' AND " + CRLF 
_cQuery	+= "					E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND " + CRLF
_cQuery	+= "					E1.D_E_L_E_T_ = '' AND E1.E1_TIPOLIQ <> 'LIQ' AND  " + CRLF
_cQuery	+= "					E1.E1_FILORIG+E1.E1_PREFIXO+E1.E1_NUM+E1.E1_PARCELA+E1.E1_TIPO IN ( " + CRLF
_cQuery	+= "					SELECT E5.E5_FILORIG+E5.E5_PREFIXO+E5.E5_NUMERO+E5.E5_PARCELA+E5.E5_TIPO FROM " + RetSqlName("SE5") + " E5 " + CRLF
_cQuery	+= "					WHERE E5.D_E_L_E_T_= ' ' AND E5.E5_RECPAG = 'R' " + CRLF
_cQuery	+= "					AND E5.E5_MOTBX <> 'CMP') " + CRLF
_cQuery	+= "				GROUP BY F2.F2_VEND1,A3.A3_NOME,E1.E1_PARCELA,E1.E1_VENCREA,E1.E1_BAIXA,F2.F2_DOC,F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA,A1.A1_NOME,E1.E1_COMIS1 " + CRLF
_cQuery	+= "		) COMISSAO_PAGAR_ATRASO
_cQuery	+= "	) COMISSAO " + CRLF
_cQuery	+= " ORDER BY VENDEDOR,ID "

MemoWrite("data\TFIMR003_financeiro_analitico.txt",_cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)
Count To _nTotReg

dbSelectArea(_cAlias)
(_cAlias)->( dbGoTop() )

//---------------------------------+
// Não foram encontrados registros |
//---------------------------------+
If (_cAlias)->( Eof() )
	RestArea(aArea)
	(_cAlias)->( dbCloseArea() )
	Return .F.
EndIf

RestArea(aArea)
Return .T.

/*****************************************************************************/
/*/{Protheus.doc} TFinR01Dta

@description Valida data parametros  
@type function
/*/
/*****************************************************************************/
Static Function TFinR01Dta(_dDta,_nTipo)
Local _nMonth	:= 0 
Local _nYear	:= 0
Local _nDay		:= 0
Local _nDayVenc	:= 0
Local _cSemana	:= ""

If _nTipo == 1

	_nDay	:= 0
	_dDta 	:= DaySum( FirstDate(_dDta), _nDay)
	_dDta	:= DataValida(_dDta)
	
ElseIf _nTipo == 2

	_nDay	:= 0
	_dDta 	:= DaySum( LastDate(_dDta), _nDay )
	_nMonth := Month(_dDta)
	_cSemana:= DiaSemana(_dDta)
	_dDta	:= DataValida(_dDta)
	
	If Month(DataValida(_dDta)) <> _nMonth
		If Rtrim(_cSemana) == "Sabado"
			_nDay	:= 2
		ElseIf Rtrim(_cSemana) == "Domingo"
			_nDay	:= 3
		EndIf
		_dDta	:= DaySub( _dDta, _nDay )
	Else
		_dDta	:= DataValida(_dDta)
	EndIf
	
ElseIf _nTipo == 3
	//----------------------------------+
	// Tratamamento para Mes de Janeiro |
	//----------------------------------+

	_nMonth := Month(_dDta)
	
	If _nMonth == 1
		_nDay := 4
		_dDta := DaySub( FirstDate(_dDta), _nDay ) 
	Else
		_nDay	:= 0
		_dDta 	:= DaySub( FirstDate(_dDta), _nDay )  
	EndIf
//------------------------------------------------+	
// Tratamento para data de vencimento dos titulos |
//------------------------------------------------+
ElseIf _nTipo == 4

	_nDayVenc	:= GetNewPar("IN_DAYVENC",2)
	_dDta 		:= DaySum(_dDta, _nDayVenc)
	_dDta 		:= DataValida(_dDta)
	
EndIf

Return dTos(_dDta)

/*****************************************************************************/
/*/{Protheus.doc} AjustaSx1

@description Cria/atualiza parametros relatorio 
/*/
/*****************************************************************************/
Static Function AjustaSx1( cPerg )
Local aArea 	:= GetArea()
Local aPerg 	:= {}

Local _nX		:= 0
Local nTPerg    := Len( SX1->X1_GRUPO )
Local nTSeq     := Len( SX1->X1_ORDEM )

SX1->( dbSetOrder(1) )

aAdd(aPerg, {cPerg, "01", "Vendedor de ?"   , "MV_CH1" , "C", TamSX3("A3_COD")[1]		, 0, "G", "MV_PAR01", "SA3","",""	,"",""})
aAdd(aPerg, {cPerg, "02", "Vendedor ate?"   , "MV_CH2" , "C", TamSX3("A3_COD")[1]		, 0, "G", "MV_PAR02", "SA3","",""	,"",""})
aAdd(aPerg, {cPerg, "03", "Data de ?"    	, "MV_CH3" , "D", TamSX3("F2_EMISSAO")[1]	, 0, "G", "MV_PAR03", ""   ,"",""	,"",""})
aAdd(aPerg, {cPerg, "04", "Data ate?"  		, "MV_CH4" , "D", TamSX3("F2_EMISSAO")[1]	, 0, "G", "MV_PAR04", ""   ,"",""	,"",""})
//aAdd(aPerg, {cPerg, "05", "Data Fechamento"	, "MV_CH5" , "D", TamSX3("F2_EMISSAO")[1]	, 0, "G", "MV_PAR05", ""   ,"",""	,"",""})
//aAdd(aPerg, {cPerg, "05", "Tipo Relatorio"  , "MV_CH5" , "C", TamSX3("F2_EMISSAO")[1]	, 0, "C", "MV_PAR05", ""   ,"Sintetico","Analitico"	,"",""})

For _nX := 1 To Len(aPerg)
	
	If  !SX1->( dbSeek(  PadR(aPerg[_nX][1], nTPerg) + PadR(aPerg[_nX][2],nTSeq) ) )		
		RecLock("SX1",.T.)
			Replace X1_GRUPO   with aPerg[_nX][01]
			Replace X1_ORDEM   with aPerg[_nX][02]
			Replace X1_PERGUNT with aPerg[_nX][03]
			Replace X1_VARIAVL with aPerg[_nX][04]
			Replace X1_TIPO	   with aPerg[_nX][05]
			Replace X1_TAMANHO with aPerg[_nX][06]
			Replace X1_PRESEL  with aPerg[_nX][07]
			Replace X1_GSC	   with aPerg[_nX][08]
			Replace X1_VAR01   with aPerg[_nX][09]
			Replace X1_F3	   with aPerg[_nX][10]
			Replace X1_DEF01   with aPerg[_nX][11]
			Replace X1_DEF02   with aPerg[_nX][12]
			Replace X1_DEF03   with aPerg[_nX][13]
			Replace X1_DEF04   with aPerg[_nX][14]
	
		SX1->( MsUnlock() )
	EndIf
Next _nX

RestArea( aArea )

Return Nil


//Funcao para gerar o Excel
Static Function OKExcel()
Local _cAlias		:= GetNextAlias()
Local _nTotReg		:= 0

	oProc:SetRegua1(2)
	
	oProc:IncRegua1("Carregando Dados")
	
	oProc:SetRegua2(2)
	
	oProc:IncRegua2("Executando Query")

	//--------------------------+
	// Query consulta comissoes |
	// conforme parametros      |
	//--------------------------+ 
	If !TFinr03Qry(_cAlias,@_nTotReg)
		MsgStop("Não existem dados para serem impressos.Favor verificar parametros informados.","INOVEN - Avisos")
		Return oReport
	EndIf

	cTitle := cEmpAnt + '-' + cFilAnt + ' - ' + "Comissão Vendedores"

	cFileEx := GetTempPath() + 'TFINR003' + '.xml'
    oExcel  := FWMsExcelEx():New()
	
	oExcel:AddworkSheet(cTitle)
	cSubTit := "Comissão Vendedores"
	oExcel:AddTable(cTitle,cSubTit)

	oExcel:SetCelBold(.F.)
	oExcel:AddColumn(cTitle,cSubTit,"ID",2)
	oExcel:AddColumn(cTitle,cSubTit,"Nota",1)
	oExcel:AddColumn(cTitle,cSubTit,"Serie",1)
	oExcel:AddColumn(cTitle,cSubTit,"Cliente",1)
	oExcel:AddColumn(cTitle,cSubTit,"Loja",1)
	oExcel:AddColumn(cTitle,cSubTit,"Nome/Razao",1)
	oExcel:AddColumn(cTitle,cSubTit,"Parcela",1)
	oExcel:AddColumn(cTitle,cSubTit,"Dta. Vencto",1)
	oExcel:AddColumn(cTitle,cSubTit,"Dta. Baixa",1)
	oExcel:AddColumn(cTitle,cSubTit,"Total Nota",3)
	oExcel:AddColumn(cTitle,cSubTit,"Valor Comissao",3)
	lPri := .T.

	nTotRel := 0
	While (_cAlias)->( !Eof() )
		
		//-----------------------+
		// Guarda vendedor atual | 
		//-----------------------+
		_cCodVend	:= (_cAlias)->VENDEDOR
		_cNomeVend	:= (_cAlias)->NOME_VEND
		
		//--------------------------------+
		// Regua de processamento process | 
		//--------------------------------+
		oProc:IncRegua1("Vendedor " + Rtrim(_cCodVend) + " - " + RTrim(_cNomeVend))

		//cSubTit := "Vendedor " + Rtrim(_cCodVend) + " - " + RTrim(_cNomeVend)
		//oExcel:AddTable(cTitle,cSubTit)

		if !lPri
			oExcel:SetCelBold(.T.)
			oExcel:SetCelFrColor("#FFFFFF")
			oExcel:SetCelBgColor("#4F81BD")
			oExcel:AddRow(cTitle,cSubTit,{"ID","Nota","Serie","Cliente","Loja","Nome/Razao","Parcela","Dta. Vencto","Dta. Baixa","Total Nota","Valor Comissao"},{1,2,3,4,5,6,7,8,9,10,11})
		endif

		oExcel:SetCelBold(.T.)
		oExcel:SetCelFrColor("#000000")
		oExcel:SetCelBgColor("#DDEBF7")
		oExcel:AddRow(cTitle,cSubTit,{"Vendedor: " + Rtrim(_cCodVend), "Nome: "+RTrim(_cNomeVend),,,,,,,,,},{1,2,3,4,5,6,7,8,9,10,11})
		lPri := .F.

		lFull	:= .T.
		nTotID := 0
		nTotGer := 0
		cID := (_cAlias)->ID
		While (_cAlias)->( !Eof() .And. _cCodVend == (_cAlias)->VENDEDOR )
			
			oProc:IncRegua2("Numero / Prefixo " + RTrim((_cAlias)->NOTA) + "/" + RTrim((_cAlias)->SERIE))
			
			if nTotID <> 0 .and. cID <> (_cAlias)->ID
				oExcel:SetCelBold(.T.)
				oExcel:SetCelBgColor("#B8CCE4")
				oExcel:AddRow(cTitle,cSubTit,{"TOTAL ID " + alltrim(str(cID)),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),Transform(nTotID, PesqPict("SE1","E1_VALOR"))},{1,2,3,4,5,6,7,8,9,10,11})
				nTotID := 0
				cID := (_cAlias)->ID
			endif

			oExcel:SetCelBold(.F.)
			if lFull
				oExcel:SetCelBgColor("#B8CCE4")
				lFull := .F.
			else
				oExcel:SetCelBgColor("#DDEBF7")
				lFull := .T.
			endif
			if (_cAlias)->ID == 2
				oExcel:SetCelFrColor("#FF0000")
			else
				oExcel:SetCelFrColor("#000000")
			endif
			oExcel:AddRow(cTitle,cSubTit,{(_cAlias)->ID,;
										  (_cAlias)->NOTA,;
										  (_cAlias)->SERIE,;
										  (_cAlias)->CLIENTE,;
										  (_cAlias)->LOJA,;
										  (_cAlias)->NOME_CLI,;
										  (_cAlias)->PARCELA,;
										  sTod((_cAlias)->DATA_VENCTO),;
										  sTod((_cAlias)->DATA_BAIXA),;
										  Transform((_cAlias)->VALOR_NF, PesqPict("SF2","F2_VALBRUT")),;
										  Transform((_cAlias)->VALOR_COMISSAO, PesqPict("SE1","E1_VALOR"));
			 },{1,2,3,4,5,6,7,8,9,10,11})
			 nTotID += (_cAlias)->VALOR_COMISSAO
			 nTotGer += (_cAlias)->VALOR_COMISSAO
			 nTotRel += (_cAlias)->VALOR_COMISSAO

			(_cAlias)->( dbSkip() )
			
		EndDo
		oExcel:SetCelBold(.T.)
		oExcel:SetCelBgColor("#B8CCE4")
		oExcel:AddRow(cTitle,cSubTit,{"TOTAL ID " + alltrim(str(cID)),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),Transform(nTotID, PesqPict("SE1","E1_VALOR"))},{1,2,3,4,5,6,7,8,9,10,11})
		oExcel:SetCelBold(.T.)
		oExcel:SetCelBgColor("#F2F2F2")
		oExcel:AddRow(cTitle,cSubTit,{"TOTAL GERAL ",space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),Transform(nTotGer, PesqPict("SE1","E1_VALOR"))},{1,2,3,4,5,6,7,8,9,10,11})
		
		oExcel:SetCelBgColor("#FFFFFF")
		oExcel:AddRow(cTitle,cSubTit,{space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1)},{1,2,3,4,5,6,7,8,9,10,11})
	EndDo
	oExcel:SetCelBold(.T.)
	oExcel:SetCelFrColor("#FFFFFF")
	oExcel:SetCelBgColor("#4F81BD")
	oExcel:AddRow(cTitle,cSubTit,{"TOTAL FINAL ",space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),space(1),Transform(nTotRel, PesqPict("SE1","E1_VALOR"))},{1,2,3,4,5,6,7,8,9,10,11})

	//--------------------+
	// Encerra temporario | 
	//--------------------+
	(_cAlias)->( dbCloseArea() )

	oExcel:Activate()
	oExcel:GetXMLFile(cFileEx)

	oExcel := MsExcel():New()
	oExcel:WorkBooks:Open(cFileEx)
	oExcel:SetVisible(.T.)
	oExcel:Destroy()

Return
