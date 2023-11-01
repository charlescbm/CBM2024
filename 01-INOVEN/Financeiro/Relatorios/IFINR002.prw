#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)


/*****************************************************************************/
/*/{Protheus.doc} IFINR001

@description Relatorio - Comissão vendedor itens nota fiscal

@author Bernard M. Margarido
@since 02/07/2019
@version 1.0

@type function
/*/
/*****************************************************************************/
User Function IFINR002()
Local oReport

	oReport	:= ReportDef()
	oReport:PrintDialog()
	
Return Nil

/*****************************************************************************/
/*/{Protheus.doc} ReportDef

@description Definicao do objeto do relatorio personalizavel e das secoes que serao utilizadas

@author Bernard M. Margarido
@since 17/02/2019
@version 1.0

@type function
/*/
/*****************************************************************************/
Static Function ReportDef()
Local aArea		:= GetArea()

Local oReport	:= Nil
Local oSecao_01	:= Nil
Local oSecao_02	:= Nil
Local oSecao_03	:= Nil

Local cReport	:=	"IFINR002"								// Nome do Relatorio

Local cPerg  	:= "IFINR02"								// Nome do grupo de perguntas
Local cTitulo	:= "Comissão Vendedores - Itens Nota"		// "Listagem do Cadastro de C Custo"

Local aOrd	 	:= {"Vendedor",;							// "Vendedor"
					"Nome"}									// "Nome"

Local cDesc		:= "Este programa ira imprimir a Comissao dos Vendedores" + ;
				   "Sera impresso de acordo com os parametros solicitados pelo" + ;
				   "usuario."

//---------------------------+
// Cria parametros relatorio |
//---------------------------+                                                                    
AjustaSx1( cPerg )

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
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| TFINR02Prt(oReport)}, cDesc )

//---------------------+
// Relatorio analitico |
//---------------------+

//oVendAnal := TRSection():New( oReport, "Vendedores" , {"SA3"}, aOrd )
//TRCell():New(oVendAnal,"VENDEDOR"		,"   ","Vendedor"			,PesqPict("SA3","A3_COD")	,TamSx3("A3_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
//TRCell():New(oVendAnal,"NOME_VEND"		,"   ","Nome"				,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
//oVendAnal:SetHeaderSection(.T.)
//oVendAnal:SetHeaderBreak(.T.)

//------------------------------------------------------------+
// Seção - Comissões a descontar dentro do mes de faturamento |
//------------------------------------------------------------+
oNotas := TRSection():New( oReport, "Comissão Vendedor - Itens Nota Fiscal " , {"SA1","SA3","SF2","SD2","SD1","SB1","SF4","SE1"}, aOrd )
oNotas:SetTotalInLine(.T.) 
oNotas:SetHeaderSection(.T.)
oNotas:SetHeaderBreak(.F.)

TRCell():New(oNotas,"VENDEDOR"	,"   ","Vendedor"			,PesqPict("SA3","A3_COD")		,TamSx3("A3_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"NOME_VEND"	,"   ","Nome"				,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oNotas,"NOTA"		,"   ","Nota"				,PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"SERIE"		,"   ","Serie"				,PesqPict("SF2","F2_SERIE")		,TamSx3("F2_SERIE")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"DATA_NF"	,"   ","Dt. Emissao"		,PesqPict("SF2","F2_EMISSAO")	,TamSx3("F2_EMISSAO")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"CLIENTE"	,"   ","Cliente"			,PesqPict("SF2","F2_CLIENTE")	,TamSx3("F2_CLIENTE")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"LOJA"		,"   ","Loja"				,PesqPict("SF2","F2_LOJA")		,TamSx3("F2_LOJA")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"NOME_CLI"	,"   ","Nome/Razao"			,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"PRODUTO"	,"   ","Produto"			,PesqPict("SB1","B1_COD")		,TamSx3("B1_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"DESC_PROD"	,"   ","Desc. Prod."		,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"QTD_NF"	,"   ","Quantidade"			,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VLR_UN"	,"   ","Valor Unit."		,PesqPict("SD2","D2_PRCVEN")	,TamSx3("D2_PRCVEN")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"PER_COMIS"	,"   ","% Comissao"			,PesqPict("SD2","D2_COMIS1")	,TamSx3("D2_COMIS1")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORNF"	,"   ","Valor Item"			,PesqPict("SD2","D2_TOTAL")		,TamSx3("D2_TOTAL")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORCO"	,"   ","Valor Comissao"		,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)

//oBreak := TRBreak():New(oNotas,oNotas:Cell("VENDEDOR"),"",.T.)
//TRFunction():New(oNotas:Cell("VALORCO"),NIL,"SUM",oBreak,"TOTAL COMISSAO",,/*uFormula*/,.F.,.T.,.F.) 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFINR02Prt

@description Realiza a impressao do relatorio de comissoes 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0

@type function
/*/
/*****************************************************************************/
Static Function TFINR02Prt( oReport )
Private oProcess	:= Nil

oProcess:= MsNewProcess():New( {|lEnd| TFinR02Ana(oReport)},"Aguarde...","Imprimindo comissões." )
oProcess:Activate()
 
Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinR01Ana

@description Realiza a impressão do relatorio analitico

@author Bernard M. Margarido
@since 27/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinR02Ana(oReport)
Local _cAlias		:= GetNextAlias()

Local _cCodVend		:= ""
Local _cNomeVend	:= ""

Local _nTotReg		:= 0

Local _aComiss		:= {}

Local _oSecao01 	:= oReport:Section(1)
//Local _oSecao02		:= oReport:Section(2)

//--------------------------+
// Query consulta comissoes |
// conforme parametros      |
//--------------------------+ 
If !TFinR02Qry(_cAlias,@_nTotReg)
	MsgStop("Não existem dados para serem impressos.Favor verificar parametros informados.","INOVEN - Avisos")
	Return oReport
EndIf

//--------------------+
// Total de registros |
//--------------------+
oReport:SetMeter( _nTotReg )

//-------------------------------+
// Inicia regua de processamento |
//-------------------------------+
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
	//_oSecao02:Init()
	
	
	//_oSecao01:Cell("VENDEDOR"):SetBlock({|| _cCodVend })
	//_oSecao01:Cell("NOME_VEND"):SetBlock({|| _cNomeVend })
	//_oSecao01:PrintLine()	
		
	//-------------------------------+
	// Inicia regua de processamento |
	//-------------------------------+
	oProcess:SetRegua2(_nTotReg)
	While (_cAlias)->( !Eof() .And. _cCodVend == (_cAlias)->VENDEDOR )
		
		//--------------------------------+
		// Regua de processamento process | 
		//--------------------------------+
		oProcess:IncRegua2("Nota/Serie " + RTrim((_cAlias)->NOTA) + "/" + RTrim((_cAlias)->SERIE) )
		
		_oSecao01:Cell("VENDEDOR"):SetBlock({|| _cCodVend })
		_oSecao01:Cell("NOME_VEND"):SetBlock({|| _cNomeVend })
		_oSecao01:Cell("NOTA"):SetBlock({|| RTrim((_cAlias)->NOTA) })
		_oSecao01:Cell("SERIE"):SetBlock({|| RTrim((_cAlias)->SERIE) })
		_oSecao01:Cell("DATA_NF"):SetBlock({|| dToc(sTod((_cAlias)->DATA_NOTA)) })
		_oSecao01:Cell("CLIENTE"):SetBlock({|| RTrim((_cAlias)->CLIENTE) })
		_oSecao01:Cell("LOJA"):SetBlock({|| RTrim((_cAlias)->LOJA) })
		_oSecao01:Cell("NOME_CLI"):SetBlock({|| RTrim((_cAlias)->NOME_CLI)  })
		_oSecao01:Cell("PRODUTO"):SetBlock({|| RTrim((_cAlias)->PRODUTO) })
		_oSecao01:Cell("DESC_PROD"):SetBlock({|| RTrim((_cAlias)->DESC_PROD)  })
		_oSecao01:Cell("QTD_NF"):SetBlock({|| (_cAlias)->QUANTIDADE })
		_oSecao01:Cell("VLR_UN"):SetBlock({|| (_cAlias)->VLR_UNIT })
		_oSecao01:Cell("PER_COMIS"):SetBlock({|| (_cAlias)->PER_COMIS  })
		_oSecao01:Cell("VALORNF"):SetBlock({|| (_cAlias)->VALOR_ITEM })
		_oSecao01:Cell("VALORCO"):SetBlock({|| (_cAlias)->VALOR_COMIS })
		
		_oSecao01:PrintLine()
		_oSecao01:SetHeaderSection(.F.)
		//_oSecao01:SetHeaderBreak(.T.)
		
		(_cAlias)->( dbSkip() )
		
	EndDo
	
	//--------------------------+
	// Imprime linha horizontal |
	//--------------------------+
	oReport:ThinLine()
	//oReport:SkipLine()
	
	//-----------------+
	// Encerra Section |
	//-----------------+
	_oSecao01:Finish()
	//_oSecao02:Finish()
	oReport:EndPage()
		 
EndDo

//--------------------+
// Encerra temporario | 
//--------------------+
(_cAlias)->( dbCloseArea() )

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinr01QSi

@description Realiza consulta das comissoes 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinR02Qry(_cAlias,_nTotReg)
Local aArea			:= GetArea()
Local _cQuery		:= ""

Local _cVendDe		:= mv_par01
Local _cVendAte		:= mv_par02

Local _dDtaDe		:= TFinR01Dta(mv_par03,1)
Local _dDtaAte		:= TFinR01Dta(mv_par04,2)
Local _dDtaVencto	:= TFinR01Dta(mv_par03,3)
Local _dDtBaixa		:= TFinR01Dta(mv_par04,4)

Local _nPComis	:= GetNewPar("TG_ALICOMI",2)

_cQuery := " SELECT " + CRLF
_cQuery += " 	ID, " + CRLF
_cQuery += "	VENDEDOR, " + CRLF
_cQuery += " 	NOME_VEND, " + CRLF
_cQuery += "	NOTA, " + CRLF
_cQuery += "	SERIE, " + CRLF
_cQuery += "	DATA_NOTA," + CRLF
_cQuery += "	CLIENTE, " + CRLF
_cQuery += "	LOJA, " + CRLF
_cQuery += "	NOME_CLI, " + CRLF
_cQuery += "	PRODUTO," + CRLF
_cQuery += "	DESC_PROD," + CRLF
_cQuery += "	QUANTIDADE," + CRLF
_cQuery += "	VLR_UNIT," + CRLF
_cQuery += "	PER_COMIS, " + CRLF
_cQuery += " 	VALOR_ITEM," + CRLF
_cQuery += "	(VALOR_ITEM * (PER_COMIS / 100) ) VALOR_COMIS " + CRLF
_cQuery += " FROM " + CRLF
_cQuery += " ( " + CRLF
_cQuery += "	SELECT " + CRLF
_cQuery += "		1 ID, " + CRLF
if mv_par05 == 1	//vendedor
	_cQuery += " 		F2.F2_VEND1 VENDEDOR, " + CRLF 
else
	_cQuery += " 		F2.F2_VEND2 VENDEDOR, " + CRLF 
endif
_cQuery += " 		A3.A3_NOME NOME_VEND, " + CRLF
_cQuery += "		F2.F2_DOC NOTA, " + CRLF
_cQuery += "		F2.F2_SERIE SERIE, " + CRLF
_cQuery += "		F2.F2_EMISSAO DATA_NOTA, " + CRLF
_cQuery += "		F2.F2_CLIENTE CLIENTE, " + CRLF
_cQuery += "		F2.F2_LOJA LOJA, " + CRLF
_cQuery += "		A1.A1_NOME NOME_CLI, " + CRLF
_cQuery += "		D2.D2_COD PRODUTO," + CRLF
_cQuery += "		B1.B1_DESC DESC_PROD," + CRLF
_cQuery += "		D2.D2_QUANT QUANTIDADE," + CRLF
_cQuery += "		D2.D2_PRCVEN VLR_UNIT," + CRLF
if mv_par05 == 1	//vendedor
	_cQuery += "		D2.D2_COMIS1 PER_COMIS, " + CRLF
else
	_cQuery += "		D2.D2_COMIS2 PER_COMIS, " + CRLF
endif
_cQuery += " 		D2.D2_TOTAL VALOR_ITEM " + CRLF
_cQuery += "	FROM " + CRLF
_cQuery += " 		" + RetSqlName("SD2") + " D2 " + CRLF 
_cQuery += " 		INNER JOIN " + RetSqlName("SF2") + " 	F2 ON 	F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF 
_cQuery += "									F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.F2_TIPO = 'N' AND F2.F2_DUPL <> '' AND " + CRLF 
if mv_par05 == 1	//vendedor
	_cQuery += "									F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 		INNER JOIN " + RetSqlName("SA3") + " A3 ON A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
else
	_cQuery += "									F2.F2_VEND2 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 		INNER JOIN " + RetSqlName("SA3") + " A3 ON A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND2 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
endif
_cQuery += " 		INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = D2.D2_COD AND B1.D_E_L_E_T_ = '' " + CRLF
_cQuery += "	WHERE " + CRLF
_cQuery += "		D2.D2_TIPO = 'N' AND " + CRLF	 					
_cQuery += "		D2.D2_EMISSAO BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery += " 		D2.D_E_L_E_T_ = '' " + CRLF
_cQuery += "	UNION ALL " + CRLF
_cQuery += "	SELECT " + CRLF 
_cQuery += "		2 ID, " + CRLF
if mv_par05 == 1	//vendedor
	_cQuery += "		F2.F2_VEND1 VENDEDOR, " + CRLF 
else
	_cQuery += "		F2.F2_VEND2 VENDEDOR, " + CRLF 
endif
_cQuery += "		A3.A3_NOME NOME_VEND, " + CRLF
_cQuery += "		D1.D1_DOC NOTA, " + CRLF
_cQuery += "		D1.D1_SERIE SERIE, " + CRLF 
_cQuery += "		D1.D1_DTDIGIT DATA_NOTA, " + CRLF
_cQuery += "		D1.D1_FORNECE CLIENTE, " + CRLF
_cQuery += "		D1.D1_LOJA LOJA, " + CRLF
_cQuery += "		A1.A1_NOME NOME_CLI, " + CRLF
_cQuery += "		D1.D1_COD PRODUTO, " + CRLF
_cQuery += "		B1.B1_DESC DESC_PROD, " + CRLF
_cQuery += "		D1.D1_QUANT QUANTIDADE, " + CRLF
_cQuery += "		D1.D1_VUNIT VLR_UNIT, " + CRLF
if mv_par05 == 1	//vendedor
	_cQuery += "		D2.D2_COMIS1 PER_COMIS, " + CRLF
else
	_cQuery += "		D2.D2_COMIS2 PER_COMIS, " + CRLF
endif
_cQuery += "		(D1.D1_TOTAL * -1) VALOR_ITEM " + CRLF
_cQuery += "	FROM " + CRLF
_cQuery += "		" + RetSqlName("SD1") + " D1 " + CRLF
_cQuery += "		INNER JOIN " + RetSqlName("SD2") + " D2 ON	D2.D2_FILIAL = D1.D1_FILIAL AND D2.D2_DOC = D1.D1_NFORI AND  D2.D2_SERIE = D1.D1_SERIORI AND " + CRLF 
_cQuery += "								D2.D2_ITEM = D1.D1_ITEMORI AND D2.D_E_L_E_T_ = '' " + CRLF
_cQuery += " 		INNER JOIN " + RetSqlName("SF2") + " 	F2 ON F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF  
_cQuery += "								F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.F2_TIPO = 'N' AND F2.F2_DUPL <> '' AND " + CRLF 
if mv_par05 == 1	//vendedor
	_cQuery += "								F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 		INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
else
	_cQuery += "								F2.F2_VEND2 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF
	_cQuery += " 		INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND2 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
endif
_cQuery += " 		INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = D1.D1_COD AND B1.D_E_L_E_T_ = '' " + CRLF
_cQuery += "	WHERE " + CRLF
_cQuery += "		D1.D1_NFORI <> '' AND " + CRLF 
_cQuery += " 		D1.D1_DTDIGIT BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery += " 		D1.D_E_L_E_T_ = '' " + CRLF
_cQuery += " ) COMISSAO_ITEM_NF " + CRLF
_cQuery += " ORDER BY VENDEDOR,ID,NOTA,SERIE "

MemoWrite("data\comissao_vendedores_itens_analitico.txt",_cQuery)

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

@author Bernard M. Margarido
@since 19/03/2019
@version 1.0

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

	_nDayVenc	:= GetNewPar("TG_DAYVENC",3)
	_dDta 		:= DaySum(_dDta, _nDayVenc)
	_dDta 		:= DataValida(_dDta)
	
EndIf

Return dTos(_dDta)

/*****************************************************************************/
/*/{Protheus.doc} AjustaSx1

@description Cria/atualiza parametros relatorio 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0
@type function
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
//aAdd(aPerg, {cPerg, "05", "Tipo Relatorio"  , "MV_CH5" , "C", TamSX3("F2_EMISSAO")[1]	, 0, "C", "MV_PAR05", ""   ,"Sintetico","Analitico"	,"",""})
aAdd(aPerg, {cPerg, "05", "Relatorio para"  , "MV_CH5" , "N", 01	                    , 0, "C", "MV_PAR05", ""   ,"Vendedor","Supervisor"	,"",""})

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

Return
