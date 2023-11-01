#Include "Protheus.ch"

/*/{Protheus.doc} IFATR001
Relatório Vendas - Relação de orçamentos/pedidos de venda
@type function
@author Charles Medeiros
@since 07/12/2018
/*/User Function IFATR001()

	Local oReport
	
	Private cPerg := "IFATR001"

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
@since 07/12/2018
/*/Static Function ReportDef()

	Local oBreak
	Local oReport
	Local oSection1
	Local cTitulo    := "Relatório Vendas"
	Local cDescricao := "Relação de orçamentos/pedidos de venda."
	Local cAliasTmp  := GetNextAlias()
	
	oReport:= TReport():New(cPerg, cTitulo, cPerg, {|oReport| ReportPrint(oReport, cAliasTmp)}, cDescricao)
	oReport:SetLandscape()
	
	oSection1:= TRSection():New(oReport,"Empresas", cAliasTmp)

	TRCell():New(oSection1, "A3_NOME"    , cAliasTmp, "Nom.Vend."     , /*Picture*/                   , 8, /*lPixel*/, {|| (cAliasTmp)->A3_NOME              })
	TRCell():New(oSection1, "UA_NUM"     , cAliasTmp, "Num.Orc."     , /*Picture*/                   , 8, /*lPixel*/, {|| (cAliasTmp)->UA_NUM              })
	TRCell():New(oSection1,"TOTAL"		,/*Tabela*/,RetTitle("UB_VLRITEM")	,PesqPict("SUB","UB_VLRITEM"		),TamSx3("UB_VLRITEM"	)[2],/*lPixel*/,{|| TOTAL				},,,"RIGHT")	// Quantidade Liberada	
	TRCell():New(oSection1, "UA_EMISSAO" , cAliasTmp, "Dt.Emis.Orc"  , /*Picture*/                   , 15, /*lPixel*/, {|| (cAliasTmp)->UA_EMISSAO  })
	TRCell():New(oSection1, "UA_NUMSC5"  , cAliasTmp, "Num.Pedido."  , /*Picture*/                   , 8, /*lPixel*/, {|| (cAliasTmp)->UA_NUMSC5      })	
	TRCell():New(oSection1, "C5_ZVALTOT" , cAliasTmp, "Vl.Pedido"     , PesqPict("SC5", "C5_ZVALTOT") , 15, /*lPixel*/, {|| (cAliasTmp)->C5_ZVALTOT })
	TRCell():New(oSection1, "C5_EMISSAO" , cAliasTmp, "Dt.Emis.Ped"  , /*Picture*/                   , 15, /*lPixel*/, {|| (cAliasTmp)->C5_EMISSAO  })
	TRCell():New(oSection1, "C5_NOTA"	 , cAliasTmp, "Documento"    , /*Picture*/                   , 15, /*lPixel*/, {|| (cAliasTmp)->C5_NOTA         })
	TRCell():New(oSection1, "F2_EMISSAO" , cAliasTmp, "Dt.Emis.NF"   , /*Picture*/                   , 15, /*lPixel*/, {|| (cAliasTmp)->F2_EMISSAO   })
	TRCell():New(oSection1, "F2_VALBRUT" , cAliasTmp, "Vl.Bruto"     , PesqPict("SF2", "F2_VALBRUT") , 15, /*lPixel*/, {|| (cAliasTmp)->F2_VALBRUT })
	TRCell():New(oSection1, "C5_FECENT"  , cAliasTmp, "Dt.Entrega"   , /*Picture*/                   , 15, /*lPixel*/, {|| (cAliasTmp)->C5_FECENT    })

	
	
Return oReport

/*/{Protheus.doc} ReportPrint
Efetua a impressão do relatório
@type function
@author Charles Medeiros

/*/Static Function ReportPrint(oReport, _cAlias)

	Local cQuery := ""
	
	CQUERY	+=	"SELECT A3_NOME,UA_NUM,SUM(UB_VLRITEM)TOTAL, UA_EMISSAO,UA_NUMSC5,C5_ZVALTOT,C5_EMISSAO,C5_NOTA,F2_EMISSAO,F2_VALBRUT,C5_FECENT "
	CQUERY	+=	"FROM "+RETSQLNAME("SUA")+" UA "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SUB")+" UB	ON UB.D_E_L_E_T_ <> '*' AND UB_NUM = UA_NUM AND UA_FILIAL = UB_FILIAL "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SA3")+" A3 ON A3.D_E_L_E_T_ <> '*' AND UA_VEND = A3_COD  "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SC5")+" C5	ON C5.D_E_L_E_T_ <> '*' AND C5_NUM = UA_NUMSC5 AND UA_CLIENTE = C5_CLIENTE AND UA_LOJA = C5_LOJACLI AND UA_FILIAL = C5_FILIAL AND  C5_EMISSAO BETWEEN '"+Dtos(MV_PAR04)+"' AND '"+Dtos(MV_PAR05)+"'  "
	CQUERY	+=	"LEFT JOIN "+RETSQLNAME("SF2")+" F2 ON F2.D_E_L_E_T_ <> '*' AND C5_NOTA = F2_DOC AND F2_FILIAL = C5_FILIAL AND C5_CLIENTE = F2_CLIENTE  "
	CQUERY	+=	"WHERE UA.D_E_L_E_T_ = ' ' AND UA_EMISSAO BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"'   "
	CQUERY	+=	" AND UA_VEND = '"+ALLTRIM(MV_PAR03)+"'"
	CQUERY  +=  " GROUP BY A3_NOME,UA_NUM, UA_EMISSAO,UA_NUMSC5,C5_ZVALTOT,C5_EMISSAO,C5_NOTA,F2_EMISSAO,F2_VALBRUT,C5_FECENT
	CQUERY  +=  " ORDER BY 2,1 "


	DbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery), _cAlias,.T.,.T.)
	
	//Ajusta os campos do tipo data e tipo numérico
	TCSetField(_cAlias, "C5_EMISSAO","D",08,0)
	TCSetField(_cAlias, "F2_EMISSAO","D",08,0)
	TCSetField(_cAlias, "UA_EMISSAO","D",08,0)	
	TCSetField(_cAlias, "C5_FECENT","D",08,0)	
	TCSetField(_cAlias, "F2_VALBRUT"   ,"N", TamSx3("F2_VALBRUT")[1], TamSx3("F2_VALBRUT")[2])
	TCSetField(_cAlias, "C5_ZVALTOT"   ,"N", TamSx3("C5_ZVALTOT")[1], TamSx3("C5_ZVALTOT")[2])
	
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
	AADD(aRegs,{cPerg,	"01","Data De Orc."            ,"¿De Emision ?"   ,"From Issue Date ?" ,"mv_ch1", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR01",                "",               "",            "","01/08/18" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	AADD(aRegs,{cPerg,	"02","Data Ate Orc."           ,"¿A Emision ?"    ,"To Issue Date ?"   ,"mv_ch2", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR02",                "",               "",            "","31/12/40" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	
	aTamSX3	:= TAMSX3( "A3_COD" )
	AADD(aRegs,{cPerg,	"03","Vendedor ?"       ,"¿De Proveedor ?" ,"From Supplier ?"   ,"mv_ch3", aTamSX3[3],aTamSx3[1],	aTamSX3[2],        			 0,"G" ,"","MV_PAR03" ,               "",               "",            "",""         ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",           "","","SA3","S","001" ,          "","","" })
	
	aTamSX3	:= TAMSX3( "C5_EMISSAO" )
	AADD(aRegs,{cPerg,	"04","Data De Ped."            ,"¿De Emision ?"   ,"From Issue Date ?" ,"mv_ch4", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR04",                "",               "",            "","01/08/18" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	AADD(aRegs,{cPerg,	"05","Data Ate Ped."           ,"¿A Emision ?"    ,"To Issue Date ?"   ,"mv_ch5", aTamSX3[3],aTamSx3[1],	aTamSX3[2],         0,"G" ,"","MV_PAR05",                "",               "",            "","31/12/40" ,"",              "",                "",              "","","",         "",          "",            "","","",         "",          "",            "","","",         "",          "",            "","",   "","S",    "",          "","","" })
	
	aAdd(aRegs,{cPerg,	"06","Formato    ?"		,"Formato    ?"		,"Formato    ?"  	,"mv_ch6","N",1,0,0,"C","","mv_par06","Sintético","","","","","Analitico"	,"","","","",""		,"","","","","","","","","","","","","","","","","",""})
	
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
