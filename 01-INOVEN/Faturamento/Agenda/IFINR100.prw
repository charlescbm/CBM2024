#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)


/*****************************************************************************/
/*/{Protheus.doc} IFINR100

@description Relatorio de Agendas

@author Crele Cristina - GoOne Consultoria
@since 21/03/2023
@version 1.0

@type function
/*/
/*****************************************************************************/
User Function IFINR100()
Local oReport

	oReport	:= ReportDef()
	oReport:PrintDialog()
	
Return Nil

Static Function ReportDef()

Local oReport	:= Nil

Local cReport	:=	"IFINR100"								// Nome do Relatorio

Local cPerg  	:= "IFINR100"								// Nome do grupo de perguntas
Local cTitulo	:= "Relação de Agendas"		// "Listagem do Cadastro de C Custo"

//Local aOrd	 	:= {"Vendedor",;							// "Vendedor"
//					"Nome"}									// "Nome"

Local cDesc		:= "Este programa ira imprimir a Relaçao de Agendas" + ;
				   "Sera impresso de acordo com os parametros solicitados pelo" + ;
				   "usuario."

//---------------------------+
// Cria parametros relatorio |
//---------------------------+                                                                    
AjustaSx1( cPerg )
Pergunte(cPerg, .f.)

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
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| TFINR10Prt(oReport)}, cDesc )

//oAgendas := TRSection():New( oReport, "Relação de Agendas " , {"SA1","SA3","SF2","SD2","SD1","SB1","SF4","SE1"}, aOrd )
oAgendas := TRSection():New( oReport, "Relação de Agendas " , {"SA1","SA3","ZAF","SC5"}, {} )
//oAgendas:SetTotalInLine(.T.) 
//oAgendas:SetHeaderSection(.F.)
//oAgendas:SetHeaderBreak(.F.)

TRCell():New(oAgendas,"VENDEDOR"	,"   ","Vendedor"			,PesqPict("SA3","A3_COD")		,TamSx3("A3_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"NOME_VEND"	,"   ","Nome"				,PesqPict("SA3","A3_NOME")		,TamSx3("A3_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)  
TRCell():New(oAgendas,"CLIENTE"		,"   ","Cliente"			,PesqPict("ZAF","ZAF_CLIENT")	,TamSx3("ZAF_CLIENT")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"LOJA"		,"   ","Loja"				,PesqPict("ZAF","ZAF_LOJA")		,TamSx3("ZAF_LOJA")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"NOME_CLI"	,"   ","Nome/Razao"			,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"DATA_INC"	,"   ","Dt. Inclusao"		,PesqPict("ZAF","ZAF_DATINC")	,TamSx3("ZAF_DATINC")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"HORA_INC"	,"   ","Hr. Inclusao"		,PesqPict("ZAF","ZAF_HORINC")	,TamSx3("ZAF_HORINC")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"DATA_AGE"	,"   ","Agendamento"		,PesqPict("ZAF","ZAF_DTAGEN")	,TamSx3("ZAF_DTAGEN")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"DATA_RET"	,"   ","Dt. Retorno"		,PesqPict("ZAF","ZAF_DTARET")	,TamSx3("ZAF_DTARET")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"HORA_RET"	,"   ","Hr. Retorno"		,PesqPict("ZAF","ZAF_HORRET")	,TamSx3("ZAF_HORRET")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"ORCAM"		,"   ","Orcamento"			,PesqPict("ZAF","ZAF_NUMORC")	,TamSx3("ZAF_NUMORC")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oAgendas,"PEDIDO"		,"   ","Pedido"				,PesqPict("SC5","C5_NUM")		,TamSx3("C5_NUM")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)

//oBreak := TRBreak():New(oAgendas,oAgendas:Cell("VENDEDOR"),"",.T.)
//TRFunction():New(oAgendas:Cell("VALORCO"),NIL,"SUM",oBreak,"TOTAL COMISSAO",,/*uFormula*/,.F.,.T.,.F.) 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

Return oReport

Static Function TFINR10Prt( oReport )
Private oProcess	:= Nil

oProcess:= MsNewProcess():New( {|lEnd| TFinR10Ana(oReport)},"Aguarde...","Imprimindo agendas." )
oProcess:Activate()
 
Return oReport

Static Function TFinR10Ana(oReport)
Local _cAlias		:= GetNextAlias()

Local _cCodVend		:= ""
Local _cNomeVend	:= ""

Local _nTotReg		:= 0

Local _oSecao01 	:= oReport:Section(1)
//Local _oSecao02		:= oReport:Section(2)

//--------------------------+
// Query consulta comissoes |
// conforme parametros      |
//--------------------------+ 
If !TFinR10Qry(_cAlias,@_nTotReg)
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
	//_cNomeVend	:= (_cAlias)->NOME_VEND
	
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
	
	//-------------------------------+
	// Inicia regua de processamento |
	//-------------------------------+
	oProcess:SetRegua2(_nTotReg)
	While (_cAlias)->( !Eof() .And. _cCodVend == (_cAlias)->VENDEDOR )
		
		//--------------------------------+
		// Regua de processamento process | 
		//--------------------------------+
		//oProcess:IncRegua2("Nota/Serie " + RTrim((_cAlias)->NOTA) + "/" + RTrim((_cAlias)->SERIE) )
		oProcess:IncRegua2("Cliente " + RTrim((_cAlias)->CLIENTE) + "/" + RTrim((_cAlias)->LOJA) )
		
		_oSecao01:Cell("VENDEDOR"):SetBlock({|| RTrim((_cAlias)->VENDEDOR) })
		_oSecao01:Cell("NOME_VEND"):SetBlock({|| RTrim((_cAlias)->NOME_VEND) })
		_oSecao01:Cell("CLIENTE"):SetBlock({|| RTrim((_cAlias)->CLIENTE) })
		_oSecao01:Cell("LOJA"):SetBlock({|| RTrim((_cAlias)->LOJA) })
		_oSecao01:Cell("NOME_CLI"):SetBlock({|| RTrim((_cAlias)->NOME_CLI)  })
		_oSecao01:Cell("DATA_INC"):SetBlock({|| dToc(sTod((_cAlias)->DATA_INC)) })
		_oSecao01:Cell("HORA_INC"):SetBlock({|| RTrim((_cAlias)->HORA_INC) })
		_oSecao01:Cell("DATA_AGE"):SetBlock({|| dToc(sTod((_cAlias)->DATA_AGE)) })
		_oSecao01:Cell("DATA_RET"):SetBlock({|| dToc(sTod((_cAlias)->DATA_RET)) })
		_oSecao01:Cell("HORA_RET"):SetBlock({|| RTrim((_cAlias)->HORA_RET)  })
		_oSecao01:Cell("ORCAM"):SetBlock({|| (_cAlias)->ORCAM })
		_oSecao01:Cell("PEDIDO"):SetBlock({|| (_cAlias)->PEDIDO })
		
		_oSecao01:PrintLine()
		//_oSecao01:SetHeaderSection(.T.)
		//_oSecao01:SetHeaderBreak(.T.)
		
		(_cAlias)->( dbSkip() )
		
	EndDo
	
	//--------------------------+
	// Imprime linha horizontal |
	//--------------------------+
	//oReport:ThinLine()
	//oReport:SkipLine()
	
	//-----------------+
	// Encerra Section |
	//-----------------+
	//_oSecao01:Finish()
	//_oSecao02:Finish()
	//oReport:EndPage()
		 
EndDo

//-----------------+
// Encerra Section |
//-----------------+
_oSecao01:Finish()
oReport:EndPage()

//--------------------+
// Encerra temporario | 
//--------------------+
(_cAlias)->( dbCloseArea() )

Return oReport

Static Function TFinR10Qry(_cAlias,_nTotReg)
Local aArea			:= GetArea()
Local _cQuery		:= ""

_cQuery := " SELECT A3_COD VENDEDOR, A3_NOME NOME_VEND, ZAF_CLIENT CLIENTE, ZAF_LOJA LOJA, A1_NOME NOME_CLI, " + CRLF
_cQuery += " ZAF_DATINC DATA_INC, ZAF_HORINC HORA_INC, ZAF_DTAGEN DATA_AGE, ZAF_DTARET DATA_RET, ZAF_HORRET HORA_RET, " + CRLF
_cQuery += " ZAF_NUMORC ORCAM, UA_NUMSC5 PEDIDO " + CRLF
_cQuery += " FROM ZAF010 ZAF " + CRLF
_cQuery += " INNER JOIN SA1010 A1 ON ZAF_CLIENT = A1_COD AND ZAF_LOJA = A1_LOJA " + CRLF
_cQuery += " INNER JOIN SA3010 A3 ON A1_VEND = A3_COD " + CRLF
_cQuery += " LEFT JOIN SUA010 SUA ON SUA.D_E_L_E_T_ = ' 'AND UA_FILIAL = ZAF_FILIAL AND UA_NUM = ZAF_NUMORC " + CRLF
_cQuery += " WHERE ZAF.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' " + CRLF
_cQuery += " AND A3_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' " + CRLF
_cQuery += " AND ZAF_CLIENT BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' " + CRLF
_cQuery += " AND ZAF_DTAGEN BETWEEN '" + dtos(mv_par05) + "' AND '" + dtos(mv_par06) + "' " + CRLF
_cQuery += " AND ZAF_DTARET BETWEEN '" + dtos(mv_par07) + "' AND '" + dtos(mv_par08) + "' " + CRLF
_cQuery += " ORDER BY VENDEDOR,CLIENTE,LOJA "

//MemoWrite("data\comissao_vendedores_itens_analitico.txt",_cQuery)

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
aAdd(aPerg, {cPerg, "03", "Cliente de ?"    , "MV_CH3" , "C", TamSX3("A1_COD")[1]		, 0, "G", "MV_PAR03", "CLI","",""	,"",""})
aAdd(aPerg, {cPerg, "04", "Cliente ate?"    , "MV_CH4" , "C", TamSX3("A1_COD")[1]		, 0, "G", "MV_PAR04", "CLI","",""	,"",""})
aAdd(aPerg, {cPerg, "05", "Dt.Agendamento de ?", "MV_CH5" , "D", TamSX3("ZAF_DTAGEN")[1]	, 0, "G", "MV_PAR05", ""   ,"",""	,"",""})
aAdd(aPerg, {cPerg, "06", "Dt.Agendamento ate?", "MV_CH6" , "D", TamSX3("ZAF_DTAGEN")[1]	, 0, "G", "MV_PAR06", ""   ,"",""	,"",""})
aAdd(aPerg, {cPerg, "07", "Dt.Retorno de ?" , "MV_CH7" , "D", TamSX3("ZAF_DTAGEN")[1]	, 0, "G", "MV_PAR07", ""   ,"",""	,"",""})
aAdd(aPerg, {cPerg, "08", "Dt.Retorno ate?" , "MV_CH8" , "D", TamSX3("ZAF_DTAGEN")[1]	, 0, "G", "MV_PAR08", ""   ,"",""	,"",""})
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

Return
