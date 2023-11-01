#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10) 

/*****************************************************************************/
/*/{Protheus.doc} IFINR001

@description Relatorio - Comissão vendedor

@author Bernard M. Margarido
@since 17/02/2019
@version 1.0

@type function
/*/
/*****************************************************************************/
User Function IFINR001()
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

Local cReport	:=	"IFINR001"					// Nome do Relatorio

Local cPerg  	:= "TFINR01"					// Nome do grupo de perguntas
Local cTitulo	:= "Comissão Vendedores"		// "Listagem do Cadastro de C Custo"

Local aOrd	 	:= { "Vendedor",;				// "Vendedor"
					 "Nome"}					// "Nome"

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
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| TFINR01Prt(oReport)}, cDesc )

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
  
TRCell():New(oNotas,"ID"		,"   ","ID"					,PesqPict("SF2","F2_DOC")		,1							,/*lPixel*/,/*{|| code-block de impressao }*/) 
TRCell():New(oNotas,"NOTA"		,"   ","Nota"				,PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"SERIE"		,"   ","Serie"				,PesqPict("SF2","F2_SERIE")		,TamSx3("F2_SERIE")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"CLIENTE"	,"   ","Cliente"			,PesqPict("SF2","F2_CLIENTE")	,TamSx3("F2_CLIENTE")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"LOJA"		,"   ","Loja"				,PesqPict("SF2","F2_LOJA")		,TamSx3("F2_LOJA")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"NOME_CLI"	,"   ","Nome/Razao"			,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORNF"	,"   ","Total Nota"			,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT")[1]	,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oNotas,"VALORCO"	,"   ","Valor Comissao"		,PesqPict("SE1","E1_VALOR")		,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/)

oBreak := TRBreak():New(oVendAnal,oVendAnal:Cell("VENDEDOR"),"",.T.)
TRFunction():New(oNotas:Cell("VALORCO"),NIL,"SUM",oBreak,"TOTAL COMISSAO",,/*uFormula*/,.F.,.T.,.F.) 

oReport:SetLandscape()
oReport:SetTotalInLine(.F.)

//--------------------+
// Relatorio Sinteico |
//--------------------+ 
oVendSint := TRSection():New( oReport, "Vendedores" , {"SA3"}, aOrd )
TRCell():New(oVendSint,"VENDEDOR"		,"   ","Vendedor"									,PesqPict("SA3","A3_COD")	,TamSx3("A3_COD")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.F.)
TRCell():New(oVendSint,"NOME_VEND"		,"   ","Nome"										,PesqPict("SA3","A3_NOME")	,TamSx3("A3_NOME")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.F.)
TRCell():New(oVendSint,"ID1"			,"   ","Comissão a Pagar (Mês)"						,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.F.)
TRCell():New(oVendSint,"ID2"			,"   ","Comissão a Descontar"						,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.F.)
TRCell():New(oVendSint,"ID3"			,"   ","Comissão a Pagar (descontos anteriores)"	,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.F.)
TRCell():New(oVendSint,"TOTAL"			,"   ","TOTAL"										,PesqPict("SE1","E1_VALOR")	,TamSx3("E1_VALOR")[1]		,/*lPixel*/,/*{|| code-block de impressao }*/,"LEFT",,,,,,,,.T.)
oVendSint:SetHeaderSection(.T.)
oVendSint:SetHeaderBreak(.T.)

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFINR01Prt

@description Realiza a impressao do relatorio de comissoes 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0

@type function
/*/
/*****************************************************************************/
Static Function TFINR01Prt( oReport )
Private _lAnalitico := IIF(mv_par05 == 1,.F.,.T.)
Private oProcess	:= Nil

//---------------------+
// Relatorio Analitico |
//---------------------+
If _lAnalitico
	TFinR01Ana(oReport)
//-----------+
// Sintetico |
//-----------+
Else
	TFinR01Sint(oReport)
EndIf
 
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
Static Function TFinR01Ana(oReport)
Local _cAlias		:= GetNextAlias()

Local _nTotReg		:= 0

Local _aComiss		:= {}

//--------------------------+
// Query consulta comissoes |
// conforme parametros      |
//--------------------------+ 
If !TFinr01QAn(_cAlias,@_nTotReg)
	MsgStop("Não existem dados para serem impressos.Favor verificar parametros informados.","INOVEN - Avisos")
	Return oReport
EndIf

//--------------------+
// Total de registros |
//--------------------+
oReport:SetMeter( _nTotReg )

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
	
	//-----------------------------+
	// Cria Array com as comissoes |
	//-----------------------------+
	_nPosVend := aScan(_aComiss,{|x| Rtrim(x[1]) == RTrim((_cAlias)->VENDEDOR)})
	If  _nPosVend == 0
		aAdd(_aComiss,{		(_cAlias)->VENDEDOR			,;	// 01. Codigo Vendedor
							(_cAlias)->NOME_VEND		,;	// 02. Nome Vendedor
							{}							}) 	// 03. Array contendo as notas do vendedor
								
		//----------------------------+						
		// Adiciona notas do vendedor |
		//----------------------------+						
		aAdd(_aComiss[Len(_aComiss)][3],{	(_cAlias)->ID				,;	// 01. ID
											(_cAlias)->NOTA				,;	// 02. Nota 
											(_cAlias)->SERIE 			,;	// 03. Serie
											(_cAlias)->CLIENTE			,;	// 04. Cliente
											(_cAlias)->LOJA				,;	// 05. Loja
											(_cAlias)->NOME_CLI			,;	// 06. Nome Cliente
											(_cAlias)->VALOR_NF			,;	// 07. Valor Nota
											(_cAlias)->VALOR_COMISSAO	})	// 08. Valor Comissao
							
	Else 
		//----------------------------+						
		// Adiciona notas do vendedor |
		//----------------------------+
		aAdd(_aComiss[_nPosVend][3],{	(_cAlias)->ID				,;	// 01. ID
										(_cAlias)->NOTA				,;	// 02. Nota 
										(_cAlias)->SERIE 			,;	// 03. Serie
										(_cAlias)->CLIENTE			,;	// 04. Cliente
										(_cAlias)->LOJA				,;	// 05. Loja
										(_cAlias)->NOME_CLI			,;	// 06. Nome Cliente
										(_cAlias)->VALOR_NF			,;	// 07. Valor Nota
										(_cAlias)->VALOR_COMISSAO	})	// 08. Valor Comissao
	EndIF					
	
	(_cAlias)->( dbSkip() ) 
EndDo

//--------------------+
// Encerra temporario | 
//--------------------+
(_cAlias)->( dbCloseArea() )

//----------------------------------+
// Realiza a impressao do relatorio | 
//----------------------------------+
If Len(_aComiss) > 0 
	oProcess:= MsNewProcess():New( {|lEnd| TFinR01PVend(oReport,_aComiss)},"Aguarde...","Imprimindo comissões." )
	oProcess:Activate()
EndIf	

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinR01PVend

@description Realiza a impressao das comissoes agrupadas

@author Bernard M. Margarido
@since 20/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinR01PVend(oReport,_aComiss)
Local _oSecao01 	:= oReport:Section(1)
Local _oSecao02		:= oReport:Section(2)

Local _nX			:= 0
Local _nY			:= 0

oProcess:SetRegua1(Len(_aComiss))
For _nX := 1 To Len(_aComiss)
	
	//------------------+
	// Inicia Impressao |
	//------------------+
	oReport:StartPage()
	_oSecao01:Init()
	_oSecao02:Init()
	
	
	_oSecao01:Cell("VENDEDOR"):SetBlock({|| _aComiss[_nX][1] })
	_oSecao01:Cell("NOME_VEND"):SetBlock({|| _aComiss[_nX][2] })
		
	_oSecao01:PrintLine()
	
	oProcess:IncRegua1("Vendedor " + Rtrim(_aComiss[_nX][1]) + " - " + RTrim(_aComiss[_nX][2]) )
	
	oProcess:SetRegua2( Len(_aComiss[_nX][3]) )
	For _nY := 1 To Len(_aComiss[_nX][3])
		
		oProcess:IncRegua2("Nota/Serie " + RTrim(_aComiss[_nX][3][_nY][2]) + "/" + _aComiss[_nX][3][_nY][3] )
		
		_oSecao02:Cell("ID"):SetBlock({|| _aComiss[_nX][3][_nY][1] })
		_oSecao02:Cell("NOTA"):SetBlock({|| _aComiss[_nX][3][_nY][2] })
		_oSecao02:Cell("SERIE"):SetBlock({|| _aComiss[_nX][3][_nY][3] })
		_oSecao02:Cell("CLIENTE"):SetBlock({|| _aComiss[_nX][3][_nY][4] })
		_oSecao02:Cell("LOJA"):SetBlock({|| _aComiss[_nX][3][_nY][5] })
		_oSecao02:Cell("NOME_CLI"):SetBlock({|| _aComiss[_nX][3][_nY][6] })
		_oSecao02:Cell("VALORNF"):SetBlock({|| _aComiss[_nX][3][_nY][7] })
		_oSecao02:Cell("VALORCO"):SetBlock({|| _aComiss[_nX][3][_nY][8] })
		_oSecao02:PrintLine()
		_oSecao02:SetHeaderSection(.F.)
		_oSecao02:SetHeaderBreak(.T.)
	Next _nY
	
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
	
Next _nX


Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinR01Sint

@description Realiza a impressao do relatorio Sintetico

@author Bernard M. Margarido
@since 27/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinR01Sint(oReport)
Local _cAlias		:= GetNextAlias()

Local _nTotReg		:= 0
Local _nTotal		:= 0
Local _nTotID1		:= 0
Local _nTotID2		:= 0
Local _nTotID3		:= 0

Local _oSecao03		:= oReport:Section(3)

//--------------------------+
// Query consulta comissoes |
// conforme parametros      |
//--------------------------+ 
If !TFinr01QSi(_cAlias,@_nTotReg)
	MsgStop("Não existem dados para serem impressos.Favor verificar parametros informados.","INOVEN - Avisos")
	Return oReport
EndIf

//------------------+
// Inicia Impressao |
//------------------+
oReport:StartPage()

//--------------------+
// Total de registros |
//--------------------+
oReport:SetMeter( _nTotReg )

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
	
	//---------------------------+
	// Inicia impressao da seção |
	//---------------------------+
	_oSecao03:Init()
				
	_cCodVend 	:= (_cAlias)->VENDEDOR
	_cNomeVend	:= (_cAlias)->NOME_VEND
	
	_oSecao03:Cell("VENDEDOR"):SetBlock({|| _cCodVend })
	_oSecao03:Cell("NOME_VEND"):SetBlock({|| _cNomeVend })
	
	_nTotal 	:= 0
	_nTotID1	:= 0
	_nTotID2	:= 0
	_nTotID3	:= 0
	
	While (_cAlias)->( !Eof()  .And. _cCodVend == (_cAlias)->VENDEDOR )	
		//-----------------------------------------+
		// Comissoes a Pagar dentro do faturamento |
		//-----------------------------------------+
		If (_cAlias)->ID == 1
			_nTotID1 += (_cAlias)->VALOR_COMISSAO
		//-----------------------+
		// Comissoes a descontar |
		//-----------------------+
		ElseIf (_cAlias)->ID == 2
			_nTotID2 += (_cAlias)->VALOR_COMISSAO
		//------------------------------------+
		// Comissoes a Pagar fora faturamento |
		//------------------------------------+
		ElseIf (_cAlias)->ID == 3
			_nTotID3 += (_cAlias)->VALOR_COMISSAO
		EndIf
		
		_nTotal	+= (_cAlias)->VALOR_COMISSAO
			
		(_cAlias)->( dbSkip() )
	
	EndDo

	_oSecao03:Cell("ID1"):SetBlock({|| _nTotID1 })
	_oSecao03:Cell("ID2"):SetBlock({|| _nTotID2 })
	_oSecao03:Cell("ID3"):SetBlock({|| _nTotID3 })
	_oSecao03:Cell("TOTAL"):SetBlock({|| _nTotal })
	
	//-----------------+
	// Imprime a linha |
	//-----------------+
	_oSecao03:PrintLine()
	
	//--------------------------+
	// Imprime linha horizontal |
	//--------------------------+
	oReport:ThinLine()
	oReport:SkipLine()
	
	//-----------------+
	// Encerra Section |
	//-----------------+
	_oSecao03:Finish()
			 
EndDo

//-----------------+
// Finaliza pagina |
//-----------------+
oReport:EndPage()

//--------------------+
// Encerra temporario | 
//--------------------+
(_cAlias)->( dbCloseArea() )

Return oReport

/*****************************************************************************/
/*/{Protheus.doc} TFinr01Qry

@description Realiza consulta das comissoes 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinr01QAn(_cAlias,_nTotReg)
Local aArea			:= GetArea()
Local _cQuery		:= ""

Local _cVendDe		:= mv_par01
Local _cVendAte		:= mv_par02

Local _dDtaDe		:= TFinR01Dta(mv_par03,1)
Local _dDtaAte		:= TFinR01Dta(mv_par04,2)
Local _dDtaVencto	:= TFinR01Dta(mv_par03,3)
Local _dDtBaixa		:= TFinR01Dta(mv_par04,4)

Local _nPComis		:= GetNewPar("TG_ALICOMI",2)

_cQuery :=	" SELECT " + CRLF
_cQuery	+= " 	ID, " + CRLF
_cQuery	+= " 	VENDEDOR, " + CRLF
_cQuery	+= " 	NOME_VEND, " + CRLF
_cQuery	+= " 	NOTA, " + CRLF
_cQuery	+= " 	SERIE, " + CRLF
_cQuery	+= " 	CLIENTE, " + CRLF
_cQuery	+= " 	LOJA, " + CRLF
_cQuery	+= " 	NOME_CLI, " + CRLF
_cQuery	+= " 	VALOR_NF, " + CRLF
_cQuery	+= " 	VALOR_COMISSAO " + CRLF
_cQuery	+= " FROM ( " + CRLF
//------------------------+
// COMISSAO PAGA AGRUPADO |
//------------------------+
_cQuery	+= "		SELECT " + CRLF
_cQuery	+= "			1 ID, " + CRLF
_cQuery	+= "			VENDEDOR, " + CRLF
_cQuery	+= " 			NOME_VEND, " + CRLF
_cQuery	+= "			NOTA, " + CRLF
_cQuery	+= "			SERIE, " + CRLF
_cQuery	+= "			CLIENTE, " + CRLF
_cQuery	+= "			LOJA, " + CRLF
_cQuery	+= "			NOME_CLI, " + CRLF
_cQuery	+= "			VALOR_NF," + CRLF
_cQuery	+= "			( VALOR_NF * ( PER_COMIS / 100 ) ) VALOR_COMISSAO " + CRLF
_cQuery	+= "		FROM ( " + CRLF
_cQuery	+= " 				SELECT " + CRLF
_cQuery	+= " 					F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery	+= " 					A3.A3_NOME NOME_VEND, " + CRLF
_cQuery	+= "					F2.F2_DOC NOTA, " + CRLF
_cQuery	+= "					F2.F2_SERIE SERIE, " + CRLF
_cQuery	+= "					F2.F2_CLIENTE CLIENTE, " + CRLF
_cQuery	+= "					F2.F2_LOJA LOJA, " + CRLF
_cQuery	+= "					A1.A1_NOME NOME_CLI, " + CRLF
_cQuery	+= "					D2.D2_COMIS1 PER_COMIS, " + CRLF 
_cQuery	+= " 					SUM(D2.D2_TOTAL) VALOR_NF " + CRLF
_cQuery	+= " 				FROM " + CRLF
_cQuery	+= " 					" + RetSqlName("SD2") + " D2 " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SF2") + " 	F2 ON 	F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF
_cQuery	+= " 															F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.F2_TIPO = 'N' AND F2.F2_DUPL <> '' AND "  + CRLF
_cQuery	+= "															F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF 
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 				WHERE " + CRLF
_cQuery	+= "					D2.D2_TIPO = 'N' AND " + CRLF	
_cQuery	+= " 					D2.D2_EMISSAO BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery	+= " 					D2.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 				GROUP BY F2.F2_VEND1,A3.A3_NOME,F2.F2_DOC,F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA,A1.A1_NOME,D2.D2_COMIS1 " + CRLF

_cQuery	+= "				UNION ALL " + CRLF

_cQuery	+= " 				SELECT " + CRLF
_cQuery	+= " 					F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery	+= " 					A3.A3_NOME NOME_VEND, " + CRLF
_cQuery	+= "					D1.D1_DOC NOTA, " + CRLF
_cQuery	+= "					D1.D1_SERIE SERIE, " + CRLF
_cQuery	+= "					D1.D1_FORNECE CLIENTE, " + CRLF
_cQuery	+= "					D1.D1_LOJA LOJA, " + CRLF
_cQuery	+= "					A1.A1_NOME NOME_CLI, " + CRLF
_cQuery	+= "					D2.D2_COMIS1 PER_COMIS, " + CRLF 
_cQuery	+= " 					SUM(D1.D1_TOTAL) * -1 VALOR_NF " + CRLF
_cQuery	+= " 				FROM " + CRLF
_cQuery	+= " 					" + RetSqlName("SD1") + " D1 " + CRLF
_cQuery	+= "					INNER JOIN " + RetSqlName("Sd2") + " D2 ON	D2.D2_FILIAL = D1.D1_FILIAL AND D2.D2_DOC = D1.D1_NFORI AND  D2.D2_SERIE = D1.D1_SERIORI AND " + CRLF 
_cQuery	+= "																D2.D2_ITEM = D1.D1_ITEMORI AND D2.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SF2") + " 	F2 ON 	F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF
_cQuery	+= " 															F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.F2_TIPO = 'N' AND F2.F2_DUPL <> '' AND "  + CRLF
_cQuery	+= "															F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND F2.D_E_L_E_T_ = '' " + CRLF 
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 				WHERE " + CRLF
_cQuery	+= "					D1.D1_NFORI <> '' AND " + CRLF	
_cQuery	+= " 					D1.D1_DTDIGIT BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery	+= " 					D1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 				GROUP BY F2.F2_VEND1,A3.A3_NOME,D1.D1_DOC,D1.D1_SERIE,D1.D1_FORNECE,D1.D1_LOJA,A1.A1_NOME,D2.D2_COMIS1 " + CRLF
_cQuery	+= "		) COMISSAO_PAGAR " + CRLF
//---------------------------------------------+
// COMISSAO NAO PAGA NO PERIODO DE FATURAMENTO |
//---------------------------------------------+
_cQuery	+= " 		UNION ALL " + CRLF

_cQuery	+= "		SELECT " + CRLF
_cQuery	+= "			2 ID, " + CRLF
_cQuery	+= "			VENDEDOR, " + CRLF
_cQuery	+= " 			NOME_VEND, " + CRLF
_cQuery	+= "			NOTA, " + CRLF
_cQuery	+= "			SERIE, " + CRLF
_cQuery	+= "			CLIENTE, " + CRLF
_cQuery	+= "			LOJA, " + CRLF
_cQuery	+= "			NOME_CLI, " + CRLF
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
_cQuery	+= "				CASE " + CRLF
_cQuery	+= "					WHEN E1.E1_COMIS1 > 0 THEN " + CRLF 
_cQuery	+= "						E1.E1_COMIS1 " + CRLF
_cQuery	+= "					ELSE " + CRLF
_cQuery	+= "						" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery	+= "					END PER_COMIS, " + CRLF  
_cQuery	+= "					SUM(E1.E1_VALOR) VALOR_NF " + CRLF
_cQuery	+= "				FROM " + CRLF
_cQuery	+= "					" + RetSqlName("SE1") + " E1 " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SF2") + " 	F2 ON F2.F2_FILIAL = E1.E1_FILIAL AND F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_SERIE AND  " + CRLF
_cQuery	+= "															F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 					INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "				WHERE " + CRLF
_cQuery	+= "					( E1.E1_BAIXA = '' OR ( E1.E1_BAIXA > '" + _dDtBaixa + "' AND E1.E1_VENCTO <= '" + _dDtaAte + "' ) ) AND " + CRLF	
_cQuery	+= " 					E1.E1_VENCTO BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF
_cQuery	+= "					E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND " + CRLF
_cQuery	+= "					E1.E1_NUM <> '000144787' AND " + CRLF  
_cQuery	+= " 					E1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "				GROUP BY F2.F2_VEND1,A3.A3_NOME,F2.F2_DOC,F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA,A1.A1_NOME,E1.E1_COMIS1 " + CRLF
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
_cQuery	+= "			VALOR_NF," + CRLF
_cQuery	+= "			( VALOR_NF * ( PER_COMIS / 100 ) ) VALOR_COMISSAO" + CRLF
_cQuery	+= "		FROM ( " + CRLF
_cQuery	+= "			SELECT " + CRLF
_cQuery	+= "				F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery	+= "				A3.A3_NOME NOME_VEND, " + CRLF
_cQuery	+= "				F2.F2_DOC NOTA, " + CRLF
_cQuery	+= "				F2.F2_SERIE SERIE, " + CRLF
_cQuery	+= "				F2.F2_CLIENTE CLIENTE, " + CRLF
_cQuery	+= "				F2.F2_LOJA LOJA, " + CRLF
_cQuery	+= "				A1.A1_NOME NOME_CLI, " + CRLF
_cQuery	+= "				CASE " + CRLF
_cQuery	+= "					WHEN E1.E1_COMIS1 > 0 THEN " + CRLF 
_cQuery	+= "						E1.E1_COMIS1 " + CRLF
_cQuery	+= "				ELSE " + CRLF
_cQuery	+= "					" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery	+= "				END PER_COMIS, " + CRLF  
_cQuery	+= "				SUM( E1.E1_VALOR - E1.E1_SALDO ) VALOR_NF " + CRLF
_cQuery	+= "			FROM " + CRLF
_cQuery	+= "				" + RetSqlName("SE1") + " E1 " + CRLF 
_cQuery	+= "				INNER JOIN " + RetSqlName("SF2") + "  F2 ON F2.F2_FILIAL = E1.E1_FILIAL AND F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_PREFIXO AND  " + CRLF 
_cQuery	+= "															F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = ''  " + CRLF  
_cQuery	+= "				INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= " 				INNER JOIN " + RetSqlName("SA1") + " A1 ON	A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
_cQuery	+= "			WHERE " + CRLF
_cQuery	+= "				E1.E1_VENCTO < '" + _dDtaVencto + "' AND " + CRLF 
_cQuery	+= "				E1.E1_BAIXA BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery	+= "				E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte + "' AND " + CRLF
_cQuery	+= "				E1.E1_NUM <> '000144787' AND " + CRLF
_cQuery	+= "				E1.D_E_L_E_T_ = ''   " + CRLF
_cQuery	+= "			GROUP BY F2.F2_VEND1,A3.A3_NOME,F2.F2_DOC,F2.F2_SERIE,F2.F2_CLIENTE,F2.F2_LOJA,A1.A1_NOME,E1.E1_COMIS1 " + CRLF
_cQuery	+= "		) COMISSAO_PAGAR_ATRASO
_cQuery	+= "	) COMISSAO " + CRLF
_cQuery	+= " ORDER BY VENDEDOR,ID "

MemoWrite("data\comissao_vendedores_analitico.txt",_cQuery)

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
/*/{Protheus.doc} TFinr01QSi

@description Realiza consulta das comissoes 

@author Bernard M. Margarido
@since 18/02/2019
@version 1.0
@type function
/*/
/*****************************************************************************/
Static Function TFinr01QSi(_cAlias,_nTotReg)
Local aArea			:= GetArea()
Local _cQuery		:= ""

Local _cVendDe		:= mv_par01
Local _cVendAte		:= mv_par02

Local _dDtaDe		:= TFinR01Dta(mv_par03,1)
Local _dDtaAte		:= TFinR01Dta(mv_par04,2)
Local _dDtaVencto	:= TFinR01Dta(mv_par03,3)
Local _dDtBaixa		:= TFinR01Dta(mv_par04,4)

Local _nPComis	:= GetNewPar("TG_ALICOMI",2)

_cQuery :=	" SELECT " + CRLF
_cQuery +=	"	ID," + CRLF
_cQuery +=	"	VENDEDOR," + CRLF
_cQuery +=	"	NOME_VEND," + CRLF
_cQuery +=	"	VALOR_COMISSAO" + CRLF
_cQuery +=	" FROM " + CRLF
_cQuery +=	" (" + CRLF
_cQuery +=	"	SELECT" + CRLF
_cQuery +=	"		1 ID," + CRLF
_cQuery +=	"		VENDEDOR," + CRLF
_cQuery +=	"		NOME_VEND," + CRLF
_cQuery +=	"		SUM(TOTAL_EMISSAO) BASE_CALCULO," + CRLF
_cQuery +=	"		SUM(TOTAL_EMISSAO * (PER_COMIS/ 100 ) ) VALOR_COMISSAO" + CRLF
_cQuery +=	"	FROM (" + CRLF
_cQuery +=	"			SELECT " + CRLF 
_cQuery +=	" 				F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery +=	" 				A3.A3_NOME NOME_VEND," + CRLF
_cQuery +=	"				D2.D2_COMIS1 PER_COMIS, " + CRLF
_cQuery +=	" 				SUM( D2.D2_TOTAL) TOTAL_EMISSAO" + CRLF
_cQuery +=	"			FROM " + CRLF
_cQuery +=	" 				" + RetSqlName("SD2") + " D2 " + CRLF 
_cQuery +=	"				INNER JOIN " + RetSqlName("SF2") + " F2 ON 	F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF 
_cQuery +=	"															F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte +"' AND " + CRLF
_cQuery +=	"															F2.F2_DUPL <> '' AND F2.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	" 				INNER JOIN " + RetSqlName("SA3") + " A3 ON A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
_cQuery +=	"			WHERE " + CRLF
_cQuery +=	"				D2.D2_TIPO = 'N' AND " + CRLF 
_cQuery +=	"				D2.D2_EMISSAO BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery +=	"				D2.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	"			GROUP BY F2.F2_VEND1,A3.A3_NOME,D2.D2_COMIS1 " + CRLF
_cQuery +=	"			UNION ALL " + CRLF
_cQuery +=	"			SELECT " + CRLF
_cQuery +=	"				F2.F2_VEND1 VENDEDOR, " + CRLF 
_cQuery +=	"				A3.A3_NOME NOME_VEND, " + CRLF
_cQuery +=	"				D2.D2_COMIS1 PER_COMIS, " + CRLF
_cQuery +=	"				SUM(D1.D1_TOTAL) * -1 VALOR_NF " + CRLF
_cQuery +=	"			FROM " + CRLF
_cQuery +=	"				" + RetSqlName("SD1") + " D1 " + CRLF 
_cQuery +=	"				INNER JOIN " + RetSqlName("SD2") + " D2 ON	D2.D2_FILIAL = D1.D1_FILIAL AND D2.D2_DOC = D1.D1_NFORI AND  D2.D2_SERIE = D1.D1_SERIORI AND " + CRLF 
_cQuery +=	"															D2.D2_ITEM = D1.D1_ITEMORI AND D2.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	"	 			INNER JOIN " + RetSqlName("SF2") + " 	F2 ON 	F2.F2_FILIAL = D2.D2_FILIAL AND F2.F2_DOC = D2.D2_DOC AND F2.F2_SERIE = D2.D2_SERIE AND " + CRLF  
_cQuery +=	"																F2.F2_CLIENTE = D2.D2_CLIENTE AND F2.F2_LOJA = D2.D2_LOJA AND F2.F2_TIPO = 'N' AND F2.F2_DUPL <> '' AND " + CRLF 
_cQuery +=	"																F2.F2_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte +"' AND F2.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	"	 			INNER JOIN " + RetSqlName("SA3") + " A3 ON 	A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
_cQuery +=	"			WHERE " + CRLF
_cQuery +=	"				D1.D1_NFORI <> '' AND " + CRLF 
_cQuery +=	"	 			D1.D1_DTDIGIT BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery +=	"	 			D1.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	"			GROUP BY F2.F2_VEND1,A3.A3_NOME,D2.D2_COMIS1 " + CRLF
_cQuery +=	"		) COMISSAO_EMISSAO " + CRLF
_cQuery +=	"		GROUP BY VENDEDOR,NOME_VEND " + CRLF

_cQuery +=	"		UNION ALL " + CRLF
 
_cQuery +=	"		SELECT " + CRLF
_cQuery +=	"			2 ID, " + CRLF
_cQuery +=	"			VENDEDOR," + CRLF
_cQuery +=	"			NOME_VEND," + CRLF
_cQuery +=	"			SUM(TOTAL_EMISSAO) BASE_CALCULO, " + CRLF
_cQuery +=	"			SUM(TOTAL_EMISSAO * (PER_COMIS/ 100 ) ) VALOR_COMISSAO " + CRLF
_cQuery +=	"		FROM (" + CRLF
_cQuery +=	"			SELECT " + CRLF
_cQuery +=	" 				F2.F2_VEND1 VENDEDOR," + CRLF 
_cQuery +=	" 				A3.A3_NOME NOME_VEND," + CRLF
_cQuery +=	" 				CASE " + CRLF
_cQuery +=	" 					WHEN E1.E1_COMIS1 > 0 THEN " + CRLF
_cQuery +=	" 						E1.E1_COMIS1 " + CRLF
_cQuery +=	" 				ELSE " + CRLF
_cQuery +=	" 					" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery +=	" 				END PER_COMIS, " + CRLF
_cQuery +=	" 				SUM( E1.E1_VALOR ) * -1 TOTAL_EMISSAO " + CRLF
_cQuery +=	"			FROM " + CRLF
_cQuery +=	"				" + RetSqlName("SE1") + " E1 " + CRLF
_cQuery +=	"				INNER JOIN " + RetSqlName("SF2") + " F2 ON 	F2.F2_FILIAL = E1.E1_FILIAL AND F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_PREFIXO AND " + CRLF 
_cQuery +=	"															F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	" 				INNER JOIN " + RetSqlName("SA3") + " A3 ON A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF 
_cQuery +=	"			WHERE " + CRLF
_cQuery +=	"				E1.E1_VENCTO BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF
_cQuery	+= "					( E1.E1_BAIXA = '' OR ( E1.E1_BAIXA > '" + _dDtBaixa + "' AND E1.E1_VENCTO <= '" + _cVendAte + "' ) AND " + CRLF
_cQuery +=	"				E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte +"' AND " + CRLF 
_cQuery +=	"				E1.E1_NUM <> '000144787' AND " + CRLF
_cQuery +=	"				E1.D_E_L_E_T_ = '' " + CRLF  
_cQuery +=	"			GROUP BY F2.F2_VEND1,A3.A3_NOME,E1.E1_COMIS1 " + CRLF 
_cQuery +=	"		) COMISSAO_DESCONTAR_EMISSAO " + CRLF
_cQuery +=	"		GROUP BY VENDEDOR,NOME_VEND " + CRLF
_cQuery +=	"		UNION ALL " + CRLF
_cQuery +=	"		SELECT " + CRLF
_cQuery +=	"			3 ID, " + CRLF
_cQuery +=	"			VENDEDOR," + CRLF
_cQuery +=	"			NOME_VEND," + CRLF
_cQuery +=	"			SUM(TOTAL_EMISSAO) BASE_CALCULO, " + CRLF
_cQuery +=	"			SUM(TOTAL_EMISSAO * (PER_COMIS/ 100 ) ) VALOR_COMISSAO " + CRLF
_cQuery +=	"		FROM (" + CRLF
_cQuery +=	"			SELECT " + CRLF
_cQuery +=	" 				F2.F2_VEND1 VENDEDOR, " + CRLF
_cQuery +=	" 				A3.A3_NOME NOME_VEND, " + CRLF
_cQuery +=	"				CASE " + CRLF
_cQuery +=	"					WHEN E1.E1_COMIS1 > 0 THEN " + CRLF
_cQuery +=	"						E1.E1_COMIS1 " + CRLF
_cQuery +=	"				ELSE " + CRLF
_cQuery +=	"					" + Alltrim(Str(_nPComis)) + " " + CRLF
_cQuery +=	"				END PER_COMIS, " + CRLF
_cQuery +=	" 				SUM( E1.E1_VALOR - E1.E1_SALDO ) TOTAL_EMISSAO" + CRLF
_cQuery +=	"			FROM " + CRLF
_cQuery +=	"				" + RetSqlName("SE1") + " E1 " + CRLF 
_cQuery +=	"				INNER JOIN " + RetSqlName("SF2") + " F2 ON F2.F2_FILIAL = E1.E1_FILIAL AND F2.F2_DOC = E1.E1_NUM AND F2.F2_SERIE = E1.E1_PREFIXO AND " + CRLF 
_cQuery +=	"															F2.F2_VEND1 = E1.E1_VEND1 AND F2.D_E_L_E_T_ = '' " + CRLF 
_cQuery +=	" 				INNER JOIN " + RetSqlName("SA3") + " A3 ON A3.A3_FILIAL = '" + xFilial("SA3") + "' AND A3.A3_COD = F2.F2_VEND1 AND A3.A3_MSBLQL IN('','2') AND A3.D_E_L_E_T_ = '' " + CRLF
_cQuery +=	"			WHERE " + CRLF
_cQuery +=	"				E1.E1_VENCTO < '" + _dDtaVencto + "' AND " + CRLF
_cQuery +=	"				E1.E1_BAIXA BETWEEN '" + _dDtaDe + "' AND '" + _dDtaAte + "' AND " + CRLF 
_cQuery +=	"				E1.E1_VEND1 BETWEEN '" + _cVendDe + "' AND '" + _cVendAte +"' AND " + CRLF
_cQuery +=	"				E1.E1_NUM <> '000144787' AND " + CRLF
_cQuery +=	"				E1.D_E_L_E_T_ = ''  " + CRLF 				 	
_cQuery +=	"			GROUP BY F2.F2_VEND1,A3.A3_NOME,E1.E1_COMIS1  " + CRLF
_cQuery +=	"		) COMISSAO_PAGAR_ATRASO " + CRLF
_cQuery +=	"		GROUP BY VENDEDOR,NOME_VEND " + CRLF
_cQuery +=	")COMISSAO_TOTAL " + CRLF
_cQuery +=	"GROUP BY ID,VENDEDOR,NOME_VEND,VALOR_COMISSAO " + CRLF
_cQuery +=	"ORDER BY VENDEDOR "

MemoWrite("data\comissao_vendedores_sintetico.txt",_cQuery)

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
aAdd(aPerg, {cPerg, "05", "Tipo Relatorio"  , "MV_CH5" , "C", TamSX3("F2_EMISSAO")[1]	, 0, "C", "MV_PAR05", ""   ,"Sintetico","Analitico"	,"",""})

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
