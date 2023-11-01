#Include "Protheus.ch"

/*/{Protheus.doc} IFATR002
Relatório Para Qualidade - Clientes x Notas x Produtos x Lote ( data de Fabricação e Vencimento )
@type function
@author Charles Medeiros
@since 07/11/2018
/*/User Function IFATR002()

	Local oReport
	
	Private cPerg := "IFATR002"

	SX1->( dbSetorder(1) )
	If ( !SX1->( MsSeek( cPerg ) ) )
		AjustaSx1(cPerg)
	EndIf	
	
	Pergunte(cPerg, .T.)
	
	oReport:= ReportDef()
	oReport:PrintDialog()

Return

/*/{Protheus.doc} ReportDef
Efetua a criação do objeto TReport
@type function
@author Charles Medeiros
@since 07/11/2018
/*/Static Function ReportDef()

	Local oBreak
	Local oReport
	Local oSection1
	Local cTitulo    := "Relatorio de Lote/Produtos/Notas por Cliente/Periodo"
	Local cDescricao := "Este programa irá emitir relação de Lote/Produtos/Notas por Cliente/Periodo."
	Local cAliasTmp  := GetNextAlias()
	
	oReport:= TReport():New(cPerg, cTitulo, cPerg, {|oReport| ReportPrint(oReport, cAliasTmp)}, cDescricao)
	oReport:SetLandscape()
	
	oSection1:= TRSection():New(oReport,"Empresas", cAliasTmp)

	TRCell():New(oSection1, "D2_CLIENTE"   , cAliasTmp, "Cliente"   , /*Picture*/                 , 12, /*lPixel*/, {|| (cAliasTmp)->D2_CLIENTE                 })
	TRCell():New(oSection1, "D2_LOJA"   , cAliasTmp, "Loja"   , /*Picture*/                 , 12, /*lPixel*/, {|| (cAliasTmp)->D2_LOJA                 })
	TRCell():New(oSection1, "A1_NOME"   , cAliasTmp, "Nome"   , /*Picture*/                 , 40, /*lPixel*/, {|| (cAliasTmp)->A1_NOME               })
	TRCell():New(oSection1, "D2_COD"    , cAliasTmp, "Codigo"   , /*Picture*/                 , 15, /*lPixel*/, {|| (cAliasTmp)->D2_COD               })
	TRCell():New(oSection1, "B1_DESC"   , cAliasTmp, "Descricao"   , /*Picture*/                 , 40, /*lPixel*/, {|| (cAliasTmp)->B1_DESC               })
	TRCell():New(oSection1, "D2_DOC"	, cAliasTmp, "Documento" , /*Picture*/                 , 15, /*lPixel*/, {|| (cAliasTmp)->D2_DOC                  })
	TRCell():New(oSection1, "D2_SERIE"	, cAliasTmp, "Serie"     , /*Picture*/                 , 6, /*lPixel*/, {|| (cAliasTmp)->D2_SERIE                })
	TRCell():New(oSection1, "D2_QUANT"	, cAliasTmp, "Quant"     , PesqPict("SD2", "D2_QUANT") , 15, /*lPixel*/, {|| (cAliasTmp)->D2_QUANT          })
	TRCell():New(oSection1, "D2_LOTECTL", cAliasTmp, "Lote"   , /*Picture*/                 , 10, /*lPixel*/, {|| (cAliasTmp)->D2_LOTECTL               })
	TRCell():New(oSection1, "B8_DFABRIC", cAliasTmp, "Dt.Fabricacao"   , /*Picture*/                 , 15, /*lPixel*/, {|| (cAliasTmp)->B8_DFABRIC               })
	TRCell():New(oSection1, "B8_DTVALID", cAliasTmp, "Dt.Validade"   , /*Picture*/                 , 15, /*lPixel*/, {|| (cAliasTmp)->B8_DTVALID               })
	TRCell():New(oSection1, "A1_TEL"   , cAliasTmp, "Telefone"   , /*Picture*/                 , 20, /*lPixel*/, {|| (cAliasTmp)->A1_TEL               })
	TRCell():New(oSection1, "A1_EST"   , cAliasTmp, "Estado"   , /*Picture*/                 , 3, /*lPixel*/, {|| (cAliasTmp)->A1_EST               })
	TRCell():New(oSection1, "A1_MUN"   , cAliasTmp, "Cidade"   , /*Picture*/                 , 20, /*lPixel*/, {|| (cAliasTmp)->A1_MUN               })
	TRCell():New(oSection1, "A1_END"   , cAliasTmp, "Endereço"   , /*Picture*/                 , 40, /*lPixel*/, {|| (cAliasTmp)->A1_END               })
	
	
Return oReport

/*/{Protheus.doc} ReportPrint
Efetua a impressão do relatório
@type function
@author Charles Medeiros
@since 07/11/2018 to, Objeto TReport previamente instanciado
@param _cAlias, character, Alias temporário de consulta
/*/Static Function ReportPrint(oReport, _cAlias)

	Local cQuery := ""
	
	CQUERY	+=	"SELECT D2_CLIENTE, D2_LOJA, A1_NOME, D2_COD, B1_DESC, D2_DOC, D2_SERIE, D2_QUANT, D2_LOTECTL, B8_DFABRIC, B8_DTVALID, (A1_DDD+' - '+A1_TEL)A1_TEL, A1_EST, A1_MUN, A1_END "
	CQUERY	+=	"FROM "+RETSQLNAME("SD2")+" D2 "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SA1")+" A1 ON D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SB1")+" B1 ON D2_COD = B1_COD "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SB8")+" B8 ON D2_COD = B8_PRODUTO AND D2_LOTECTL = B8_LOTECTL AND D2_FILIAL = B8_FILIAL AND B8.D_E_L_E_T_ <> '*' AND D2_LOCAL = B8_LOCAL "
	CQUERY	+=	"WHERE D2.D_E_L_E_T_ = ' ' AND D2_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'   "
	CQUERY	+=	" AND D2_CLIENTE BETWEEN '"+ALLTRIM(MV_PAR03)+"' AND '"+ALLTRIM(MV_PAR05)+"'   "
	CQUERY	+=	" AND D2_LOJA BETWEEN '"+ALLTRIM(MV_PAR04)+"' AND '"+ALLTRIM(MV_PAR06)+"'   "
	CQUERY	+=	" AND D2_COD BETWEEN '"+ALLTRIM(MV_PAR07)+"' AND '"+ALLTRIM(MV_PAR08)+"'   "
	CQUERY  +=  "ORDER BY 1 "


	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery), _cAlias,.T.,.T.)
	
	//Ajusta os campos do tipo data e tipo numérico
	TCSetField(_cAlias, "B8_DFABRIC","D",08,0)
	TCSetField(_cAlias, "B8_DTVALID","D",08,0)
	TCSetField(_cAlias, "D2_QUANT"   ,"N", TamSx3("D2_QUANT")[1], TamSx3("D2_QUANT")[2])
	
	oReport:Section(1):Print()

Return

/*/{Protheus.doc} AjustaSx1
Efetua o ajuste no dicionário de Dados SX1
@type function
@author Charles Medeiros
@since 07/11/2018
@param cPerg, character, Grupo de perguntas SX1
/*/Static Function AjustaSx1(cPerg)

	Local aRegs	 := {}
	Local aParam := {}
	Local cParam := ""
	Local xI	 := 0
	Local xJ	 := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg,10)
	
	aTamSX3	:= TAMSX3( "D2_EMISSAO" )
	AADD(aRegs,{cPerg,	"01","Data De"            ,"¿De Emision ?"   ,"From Issue Date ?" ,"mv_ch1", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR01",                "",               "",            "","01/08/18" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	AADD(aRegs,{cPerg,	"02","Data Ate"           ,"¿A Emision ?"    ,"To Issue Date ?"   ,"mv_ch2", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR02",                "",               "",            "","31/12/40" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	
	aTamSX3	:= TAMSX3( "A1_COD" )
	AADD(aRegs,{cPerg,	"03","Do Cliente ?"       ,"¿De Proveedor ?" ,"From Supplier ?"   ,"mv_ch3", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR03" ,               "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",           "","","SA1","S","001" ,          "","","" })
	
	aTamSX3	:= TAMSX3( "A1_LOJA" )
	AADD(aRegs,{cPerg,	"04","Da Loja ?"          ,"¿De Tienda ?"	 ,"From Unit ?"       ,"mv_ch4", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR04"  ,              "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })
	
	aTamSX3	:= TAMSX3( "A1_COD" )
	AADD(aRegs,{cPerg,	"05","Ate Cliente ?"      ,"¿A Proveedor ?"  ,"To Supplier ?"     ,"mv_ch5", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR05",                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","","SA1","S","001" ,          "","","" })
	
	aTamSX3	:= TAMSX3( "A1_LOJA" )
	AADD(aRegs,{cPerg,	"06","Ate Loja ?"         ,"¿De Tienda ?"    ,"From Unit ?"       ,"mv_ch6", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR06"  ,              "",               "",            "","ZZZZ"     ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S","002" ,          "","","" })
	
	aTamSX3	:= TAMSX3( "B1_COD" )
	AADD(aRegs,{cPerg,	"07","Do Produto ?"       ,"¿De Proveedor ?" ,"From Supplier ?"   ,"mv_ch7", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR07" ,               "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",           "","","SB1","S","001" ,          "","","" })
	AADD(aRegs,{cPerg,	"08","Ate Produto ?"      ,"¿A Proveedor ?"  ,"To Supplier ?"     ,"mv_ch8", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR08",                "",               "",            "","ZZZZZZ"   ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",           "","","SB1","S","001" ,          "","","" })
		
	//AADD(aRegs,{cPerg,"01","Data De"	   	,"","","mv_ch1" ,"D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	//AADD(aRegs,{cPerg,"02","Data Ate"		,"","","mv_ch2" ,"D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	//Aadd(aRegs,{cPerg,"03","Cliente de?"	,"","","mv_ch3"	,"C",06,0,0,"G","" ,"MV_PAR05","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	//Aadd(aRegs,{cPerg,"04","Loja de?"		,"","","mv_ch4"	,"C",06,0,0,"G","" ,"MV_PAR06","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	//Aadd(aRegs,{cPerg,"05","Cliente até?"	,"","","mv_ch5"	,"C",06,0,0,"G","" ,"MV_PAR05","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	//Aadd(aRegs,{cPerg,"06","loja até?"	,"","","mv_ch6"	,"C",06,0,0,"G","" ,"MV_PAR06","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	//Aadd(aRegs,{cPerg,"05","Produto de?"	,"","","mv_ch7"	,"C",06,0,0,"G","" ,"MV_PAR05","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	//Aadd(aRegs,{cPerg,"06","Produto até?"	,"","","mv_ch8"	,"C",06,0,0,"G","" ,"MV_PAR06","","" ,"","","","","" ,"" ,"","","","","","","","","","","","","","","","","SA2","","",""})
	
	For xI := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[xI,2])
			If RecLock("SX1",.T.)
				For xJ := 1 To Len(aRegs[xI])
					FieldPut(xJ,aRegs[xI,xJ])
				Next xJ
				MsUnlock()
			EndIf
		EndIf
	Next xI

Return(Nil)
