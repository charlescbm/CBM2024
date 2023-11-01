#Include "Protheus.ch"
#INCLUDE "MSMGADD.CH"
#include "rwmake.ch"

/*/{Protheus.doc} UFINA060
Monitor de Clientes Inativos
@type function
@author Crele Cristina da Costa
@since 21/11/2018
@version 1.0
/*/User Function UFINA060()

	Private cPerg    := "UFINA060"
	Private cRegioes := space(99)
	Private cVendedores := space(99)
	
	//Pergunte(cPerg, .T.)
	
	@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Monitor Clientes para Inativação"
	@ 8,10 TO 84,222

	//@ 91,139 BMPBUTTON TYPE 5 ACTION PERGUNTE(cPerg,.T.)
	@ 91,168 BMPBUTTON TYPE 1 ACTION OKRun()  
	@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

	@ 23,14 SAY "Esta rotina ira mostrar os clientes sem comprar dentro de determinados"
	@ 33,14 SAY "periodo, possibilitando a sua Inativação dentro do sistema."

	ACTIVATE DIALOG oDlg1 CENTER
	
	
Return

Static Function OKRun()

oProcpln := MsNewProcess():New({|| ProcIni(oProcpln)}, "Aguarde...", "Processando dados...")
oProcpln:Activate()

Return

/*/{Protheus.doc} ProcIni
Função de processamento da rotina
@type function
@author Crele Cristina da Costa
@since 19/03/2015
@version 1.0
@param oProcess, objeto, Objeto de processamento
/*/Static Function ProcIni(oProcpln)	
	
	Local oLayer
	local oTRB1
	local oTRB2
	local oTRB3
	local oTRB4
	local oTRBOK
	
	
	
	If ( Select('QRY') <> 0 )
		QRY->(dbCloseArea())
	Endif
	
	//Montando estrutura do arquivo geral temporario
	aStruSQL := {}
	AADD(aStruSQL,{"OK"			,"C", 02, 0 })
	AADD(aStruSQL,{"CDCLI"		,"C", TamSx3("A1_COD")[1], TamSx3("A1_COD")[2] })
	AADD(aStruSQL,{"LJCLI"		,"C", TamSx3("A1_LOJA")[1], TamSx3("A1_LOJA")[2] })
	AADD(aStruSQL,{"NMCLI"		,"C", TamSx3("A1_NOME")[1], TamSx3("A1_NOME")[2] })
	AADD(aStruSQL,{"RDCLI"		,"C", TamSx3("A1_NREDUZ")[1], TamSx3("A1_NREDUZ")[2] })
	AADD(aStruSQL,{"DDD"		,"C", TamSx3("A1_DDD")[1], TamSx3("A1_DDD")[2] })
	AADD(aStruSQL,{"FONE"		,"C", TamSx3("A1_TEL")[1], TamSx3("A1_TEL")[2] })
	AADD(aStruSQL,{"CNPJ"		,"C", TamSx3("A1_CGC")[1], TamSx3("A1_CGC")[2] })
	AADD(aStruSQL,{"MUNI"		,"C", TamSx3("A1_MUN")[1] , TamSx3("A1_MUN")[2] })
	AADD(aStruSQL,{"EST"		,"C", TamSx3("A1_EST")[1] , TamSx3("A1_EST")[2] })
	AADD(aStruSQL,{"ULTCOM"		,"D", TamSx3("A1_ULTCOM")[1] , TamSx3("A1_ULTCOM")[2] })
	AADD(aStruSQL,{"DATCAD"		,"D", TamSx3("A1_DTCAD")[1] , TamSx3("A1_DTCAD")[2] })
	AADD(aStruSQL,{"VEND"		,"C", TamSx3("A1_VEND")[1] , TamSx3("A1_VEND")[2] })
	AADD(aStruSQL,{"REGIAO"		,"C", TamSx3("A3_GEREN")[1] , TamSx3("A3_GEREN")[2] })
	AADD(aStruSQL,{"TIPO"		,"C", 20 , 0 })
	AADD(aStruSQL,{"FOLDER"		,"C", 01 , 0 })

	
	If ( Select('TRB1') <> 0 )
		TRB1->(dbCloseArea())
		if valType(oTRB1) <> 'U'
			oTRB1:Delete()
		endif
	Endif
	
	oTRB1 := U_LGTab(aStruSQL, 'TRB1', {{"CDCLI","LJCLI"}})
	
	If ( Select('TRB2') <> 0 )
		TRB2->(dbCloseArea())
		if valType(oTRB2) <> 'U'
			oTRB2:Delete()
		endif
	Endif
	
	oTRB2 := U_LGTab(aStruSQL, 'TRB2', {{"CDCLI","LJCLI"}})
	
	If ( Select('TRB3') <> 0 )
		TRB3->(dbCloseArea())
		if valType(oTRB3) <> 'U'
			oTRB3:Delete()
		endif
	Endif
	
	oTRB3 := U_LGTab(aStruSQL, 'TRB3', {{"CDCLI","LJCLI"}})
	
	If ( Select('TRB4') <> 0 )
		TRB4->(dbCloseArea())
		if valType(oTRB4) <> 'U'
			oTRB4:Delete()
		endif
	Endif
	oTRB4 := U_LGTab(aStruSQL, 'TRB4', {{"CDCLI","LJCLI"}})
	
	If ( Select('TRBOK') <> 0 )
		TRBOK->(dbCloseArea())
		if valType(oTRBOK) <> 'U'
			oTRBOK:Delete()
		endif
	Endif
	
	oTRBOK := U_LGTab(aStruSQL, 'TRBOK', {{"CDCLI","LJCLI"}})

	//Realiza a busca dos dados
	ProcQryTab(oProcpln)
	
	//Cabeçalho do Browse - 3 meses (90 dias)
	aHead01 := {}
	AADD(aHead01,{ "Código"			,"CDCLI"	,"C", tamSx3('A1_COD')[1], tamSx3('A1_COD')[2],  "" } )
	AADD(aHead01,{ "Loja"			,"LJCLI"	,"C", tamSx3('A1_LOJA')[1], tamSx3('A1_LOJA')[2],  "" } )
	AADD(aHead01,{ "Razão Social"	,"NMCLI"	,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHead01,{ "Fantasia"		,"RDCLI"	,"C", tamSx3('A1_NREDUZ')[1], tamSx3('A1_NREDUZ')[2],  "" } )
	AADD(aHead01,{ "DDD"			,"DDD"		,"C", tamSx3('A1_DDD')[1], tamSx3('A1_DDD')[2],  "" } )
	AADD(aHead01,{ "Telefone"		,"FONE"		,"C", tamSx3('A1_TEL')[1], tamSx3('A1_TEL')[2],  "" } )
	AADD(aHead01,{ "CNPJ"			,"CNPJ"		,"C", tamSx3('A1_CGC')[1], tamSx3('A1_CGC')[2],  "" } )
	AADD(aHead01,{ "Cidade"			,"MUNI"		,"C", tamSx3('A1_MUN')[1], tamSx3('A1_MUN')[2],  "" } )
	AADD(aHead01,{ "UF"				,"EST"		,"C", tamSx3('A1_EST')[1], tamSx3('A1_EST')[2],  "" } )
	AADD(aHead01,{ "Ult.Compra"		,"ULTCOM"	,"D", tamSx3('A1_ULTCOM')[1], tamSx3('A1_ULTCOM')[2],  "" } )
	AADD(aHead01,{ "Dt.Cadastro"	,"DATCAD"	,"D", tamSx3('A1_DTCAD')[1], tamSx3('A1_DTCAD')[2],  "" } )
	AADD(aHead01,{ "Vendedor"		,"VEND"		,"C", tamSx3('A1_VEND')[1], tamSx3('A1_VEND')[2],  "" } )
	AADD(aHead01,{ "Regiao"			,"REGIAO"	,"C", tamSx3('A3_GEREN')[1], tamSx3('A3_GEREN')[2],  "" } )
	AADD(aHead01,{ "Tipo"			,"TIPO"		,"C", 20, 0,  "" } )
	
	//Cabeçalho do Browse - 6 meses (180 dias)
	aHead02 := {}
	AADD(aHead02,{ "Código"			,"CDCLI"	,"C", tamSx3('A1_COD')[1], tamSx3('A1_COD')[2],  "" } )
	AADD(aHead02,{ "Loja"			,"LJCLI"	,"C", tamSx3('A1_LOJA')[1], tamSx3('A1_LOJA')[2],  "" } )
	AADD(aHead02,{ "Razão Social"	,"NMCLI"	,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHead02,{ "Fantasia"		,"RDCLI"	,"C", tamSx3('A1_NREDUZ')[1], tamSx3('A1_NREDUZ')[2],  "" } )
	AADD(aHead02,{ "DDD"			,"DDD"		,"C", tamSx3('A1_DDD')[1], tamSx3('A1_DDD')[2],  "" } )
	AADD(aHead02,{ "Telefone"		,"FONE"		,"C", tamSx3('A1_TEL')[1], tamSx3('A1_TEL')[2],  "" } )
	AADD(aHead02,{ "CNPJ"			,"CNPJ"		,"C", tamSx3('A1_CGC')[1], tamSx3('A1_CGC')[2],  "" } )
	AADD(aHead02,{ "Cidade"			,"MUNI"		,"C", tamSx3('A1_MUN')[1], tamSx3('A1_MUN')[2],  "" } )
	AADD(aHead02,{ "UF"				,"EST"		,"C", tamSx3('A1_EST')[1], tamSx3('A1_EST')[2],  "" } )
	AADD(aHead02,{ "Ult.Compra"		,"ULTCOM"	,"D", tamSx3('A1_ULTCOM')[1], tamSx3('A1_ULTCOM')[2],  "" } )
	AADD(aHead02,{ "Dt.Cadastro"	,"DATCAD"	,"D", tamSx3('A1_DTCAD')[1], tamSx3('A1_DTCAD')[2],  "" } )
	AADD(aHead02,{ "Vendedor"		,"VEND"		,"C", tamSx3('A1_VEND')[1], tamSx3('A1_VEND')[2],  "" } )
	AADD(aHead02,{ "Regiao"			,"REGIAO"	,"C", tamSx3('A3_GEREN')[1], tamSx3('A3_GEREN')[2],  "" } )
	AADD(aHead02,{ "Tipo"			,"TIPO"		,"C", 20, 0,  "" } )
	
	//Cabeçalho do Browse - 12 meses (360 dias)
	aHead03 := {}
	AADD(aHead03,{ "Código"			,"CDCLI"	,"C", tamSx3('A1_COD')[1], tamSx3('A1_COD')[2],  "" } )
	AADD(aHead03,{ "Loja"			,"LJCLI"	,"C", tamSx3('A1_LOJA')[1], tamSx3('A1_LOJA')[2],  "" } )
	AADD(aHead03,{ "Razão Social"	,"NMCLI"	,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHead03,{ "Fantasia"		,"RDCLI"	,"C", tamSx3('A1_NREDUZ')[1], tamSx3('A1_NREDUZ')[2],  "" } )
	AADD(aHead03,{ "DDD"			,"DDD"		,"C", tamSx3('A1_DDD')[1], tamSx3('A1_DDD')[2],  "" } )
	AADD(aHead03,{ "Telefone"		,"FONE"		,"C", tamSx3('A1_TEL')[1], tamSx3('A1_TEL')[2],  "" } )
	AADD(aHead03,{ "CNPJ"			,"CNPJ"		,"C", tamSx3('A1_CGC')[1], tamSx3('A1_CGC')[2],  "" } )
	AADD(aHead03,{ "Cidade"			,"MUNI"		,"C", tamSx3('A1_MUN')[1], tamSx3('A1_MUN')[2],  "" } )
	AADD(aHead03,{ "UF"				,"EST"		,"C", tamSx3('A1_EST')[1], tamSx3('A1_EST')[2],  "" } )
	AADD(aHead03,{ "Ult.Compra"		,"ULTCOM"	,"D", tamSx3('A1_ULTCOM')[1], tamSx3('A1_ULTCOM')[2],  "" } )
	AADD(aHead03,{ "Dt.Cadastro"	,"DATCAD"	,"D", tamSx3('A1_DTCAD')[1], tamSx3('A1_DTCAD')[2],  "" } )
	AADD(aHead03,{ "Vendedor"		,"VEND"		,"C", tamSx3('A1_VEND')[1], tamSx3('A1_VEND')[2],  "" } )
	AADD(aHead03,{ "Regiao"			,"REGIAO"	,"C", tamSx3('A3_GEREN')[1], tamSx3('A3_GEREN')[2],  "" } )
	AADD(aHead03,{ "Tipo"			,"TIPO"		,"C", 20, 0,  "" } )
	
	//Cabeçalho do Browse - Novos sem movimento
	/*aHead04 := {}
	AADD(aHead04,{ "Código"			,"CDCLI"	,"C", tamSx3('A1_COD')[1], tamSx3('A1_COD')[2],  "" } )
	AADD(aHead04,{ "Loja"			,"LJCLI"	,"C", tamSx3('A1_LOJA')[1], tamSx3('A1_LOJA')[2],  "" } )
	AADD(aHead04,{ "Razão Social"	,"NMCLI"	,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHead04,{ "Fantasia"		,"RDCLI"	,"C", tamSx3('A1_NREDUZ')[1], tamSx3('A1_NREDUZ')[2],  "" } )
	AADD(aHead04,{ "DDD"			,"DDD"		,"C", tamSx3('A1_DDD')[1], tamSx3('A1_DDD')[2],  "" } )
	AADD(aHead04,{ "Telefone"		,"FONE"		,"C", tamSx3('A1_TEL')[1], tamSx3('A1_TEL')[2],  "" } )
	AADD(aHead04,{ "CNPJ"			,"CNPJ"		,"C", tamSx3('A1_CGC')[1], tamSx3('A1_CGC')[2],  "" } )
	AADD(aHead04,{ "Cidade"			,"MUNI"		,"C", tamSx3('A1_MUN')[1], tamSx3('A1_MUN')[2],  "" } )
	AADD(aHead04,{ "UF"				,"EST"		,"C", tamSx3('A1_EST')[1], tamSx3('A1_EST')[2],  "" } )
	AADD(aHead04,{ "Ult.Compra"		,"ULTCOM"	,"D", tamSx3('A1_ULTCOM')[1], tamSx3('A1_ULTCOM')[2],  "" } )
	AADD(aHead04,{ "Dt.Cadastro"	,"DATCAD"	,"D", tamSx3('A1_DTCAD')[1], tamSx3('A1_DTCAD')[2],  "" } )
	AADD(aHead04,{ "Vendedor"		,"VEND"		,"C", tamSx3('A1_VEND')[1], tamSx3('A1_VEND')[2],  "" } )
	AADD(aHead04,{ "Regiao"			,"REGIAO"	,"C", tamSx3('A3_GEREN')[1], tamSx3('A3_GEREN')[2],  "" } )
	AADD(aHead04,{ "Tipo"			,"TIPO"		,"C", 20, 0,  "" } )*/

	//Cabeçalho do Browse - Clientes Inativados
	aHeadOk := {}
	AADD(aHeadOk,{ "CDCLI"	,,"Código"			,"@!"} )
	AADD(aHeadOk,{ "LJCLI"	,,"Loja"			,"@!"} )
	AADD(aHeadOk,{ "NMCLI"	,,"Razão Social"	,"@!"} )
	AADD(aHeadOk,{ "CNPJ"	,,"CNPJ"			,"@!"} )
	AADD(aHeadOk,{ "VEND"	,,"Vendedor"		,"@!"} )
	AADD(aHeadOk,{ "REGIAO"	,,"Regiao"			,"@!"} )

	//Campos que irão compor a tela de filtro
	aFieFilter := {}
	Aadd(aFieFilter,{"CDCLI"	, "Código"   	 , "C", tamSx3('A1_COD')[1], tamSx3('A1_COD')[1],"@!"})
	Aadd(aFieFilter,{"LJCLI"	, "Loja"		 , "C", tamSx3('A1_LOJA')[1], tamSx3('A1_LOJA')[1],"@!"})
	Aadd(aFieFilter,{"NMCLI"	, "Razão Social" , "C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[1],"@!"})	
	Aadd(aFieFilter,{"RDCLI"	, "Fantasia" 	 , "C", tamSx3('A1_NREDUZ')[1], tamSx3('A1_NREDUZ')[1],"@!"})	
	Aadd(aFieFilter,{"CNPJ"		, "CNPJ" 		 , "C", tamSx3('A1_CGC')[1], tamSx3('A1_CGC')[1],"@!"})	
	Aadd(aFieFilter,{"VEND"		, "Vendedor" 	 , "C", tamSx3('A1_VEND')[1], tamSx3('A1_VEND')[1],"@!"})	
	Aadd(aFieFilter,{"REGIAO"	, "Região" 	 	 , "C", tamSx3('A3_GEREN')[1], tamSx3('A3_GEREN')[1],"@!"})	
	
	//Periodo para Inativacao
	//cPerInat  := alltrim(SUPERGETMV("MU_PERINAT",, "180"))
	//cPerInat  := iif(mv_par03==1, "90", iif(mv_par03==2, "180", iif(mv_par03==3, "360", "NOVOS")))
	cPerInat  := "180"
	lMarca90  := .f.
	lMarca180 := .f.
	lMarca360 := .f.
	lMarcaNew := .f.
	nPasta    := iif(cPerInat == '90', 1, iif(cPerInat == '180', 2, iif(cPerInat == '360', 3, 4)))
	
	//oProcpln:IncRegua1("Reunindo todos os dados para montar visualização")
	//SysRefresh()
	
	//Resolucao de Tela 
	aSize		:= MsAdvSize( .F. )
	aObjects := {} 
	AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
	AAdd( aObjects, { 100, 100 , .t., .t. } )
	AAdd( aObjects, { 100, 50 , .t., .f. } )
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
	aPosObj  := MsObjSize( aInfo, aObjects) 
	
	//Private aTitles   := {"3 Meses (90 Dias)", "6 Meses (180 Dias)", "12 Meses (360 Dias)","Novos sem Movimento"}
	Private aTitles   := {"3 Meses (90 Dias)", "6 Meses (180 Dias)", "12 Meses (360 Dias)"}
	
	DEFINE MSDIALOG oDlgPln TITLE "MONITOR DE CLIENTES - INATIVAÇÃO" PIXEL FROM If( FlatMode(), 0, aSize[7] ),0 TO aSize[6],aSize[5]  //STYLE nOR(WS_VISIBLE,WS_POPUP)
		
		oLayer := FWLayer():New()
		oLayer:Init(oDlgPln, .F.)
			
			oLayer:AddLine('LING', 100, .F.)
				
				oLayer:AddCollumn('LING_COLG', 100, .T., 'LING')
					
					oFolder := TFolder():New(000,000, aTitles,{},oLayer:GetColPanel('LING_COLG', 'LING'),,,, .T., .F.,aPosObj[1,3]+7,aPosObj[3,3])
					//oFolder:bChange	:= {|| stCnsFld(oFolder:nOption)}
					oFolder:Align := CONTROL_ALIGN_ALLCLIENT
					
					dbSelectArea('TRB1')
					TRB1->( dbGotop() )
					
					if cPerInat <> '90'
						oWinBrw:=FWMBrowse():New()
					else
						oWinBrw:=FWMarkBrowse():New()
						lMarca90 := .T.
					endif
					
					oWinBrw:SetOwner(oFolder:aDialogs[1])
					oWinBrw:SetDescription("TELA1")
					oWinBrw:SetAlias('TRB1')
					oWinBrw:SetTemporary(.T.) 
					oWinBrw:SetFields(aHead01)
					
					if cPerInat == '90'
						oWinBrw:SetFieldMark("OK")
						oWinBrw:SetAllMark({|| MkLstTrbTd('TRB1', oWinBrw)})                  // Marca / Desmarca todos
					endif
					
					//oWinBrw:bLDblClick := {|| stClickBrw("2") }
					oWinBrw:DisableDetails()
					oWinBrw:SetMenudef( '' )
					oWinBrw:AddButton("Exportar Excel",{|| MsAguarde({|lEnd| goBuildExcel('TRB1', aHead01)},"Aguarde...","Preparando dados para a planilha...",.T.) },,4,,.F.)
					//oWinBrw:AddButton("Selecionar Todos",{|| stMarkAll() },,4,,.F.)
					//oWinBrw:AddButton("Integrar Selecionados",{|| stProcEnviaAll() },,4,,.F.)

					//if cPerInat == '90'
					//	oWinBrw:AddButton("REALIZAR INATIVAÇÃO",{|| MsAguarde({|lEnd| goOKInat('TRB1', oWinBrw)},"Aguarde...","Processando Inativação dos clientes marcados...",.T.) },,4,,.F.)
					//endif
					
					oWinBrw:AddButton("Sair",{|| oDlgPln:End() },,4,,.F.)
					oWinBrw:SetProfileID("1")
					oWinBrw:SetAmbiente(.F.)
					oWinBrw:SetWalkthru(.F.)		
					oWinBrw:SetFixedBrowse(.T.)		
					oWinBrw:DisableConfig(.T.)		
					oWinBrw:DisableReport(.T.)
					
					//Usa o Filtro no Browse
					if cPerInat <> '90'
						oWinBrw:SetUseFilter(.T.)	
						oWinBrw:SetDBFFilter(.T.)
						oWinBrw:SetFilterDefault( "" )
						oWinBrw:SetFieldFilter(aFieFilter)
					else
						oWinBrw:oBrowse:SetDBFFilter(.T.)
						oWinBrw:oBrowse:SetUseFilter(.T.)	
						oWinBrw:oBrowse:SetFilterDefault( "" )
						oWinBrw:oBrowse:SetFieldFilter(aFieFilter)
					endif

					oWinBrw:Activate()
					
					dbSelectArea('TRB2')
					TRB2->( dbGotop() )
					
					if cPerInat <> '180'
						oWinBrw2:=FWMBrowse():New()
					else
						oWinBrw2:=FWMarkBrowse():New()
						lMarca180 := .T.
					endif
					
					oWinBrw2:SetOwner(oFolder:aDialogs[2])
					oWinBrw2:SetDescription("TELA 2")
					oWinBrw2:SetAlias('TRB2')
					oWinBrw2:SetTemporary(.T.) 
					oWinBrw2:SetFields(aHead02)
					
					if cPerInat == '180'
						oWinBrw2:SetFieldMark("OK")
						oWinBrw2:SetAllMark({|| MkLstTrbTd('TRB2', oWinBrw2)})                  // Marca / Desmarca todos
					endif
					
					//oWinBrw:bLDblClick := {|| stClickBrw("2") }
					oWinBrw2:DisableDetails()
					oWinBrw2:SetMenudef( '' )
					oWinBrw2:AddButton("Exportar Excel",{|| MsAguarde({|lEnd| goBuildExcel('TRB2', aHead02)},"Aguarde...","Preparando dados para a planilha...",.T.) },,4,,.F.)

					//if cPerInat == '180'
					//	oWinBrw2:AddButton("REALIZAR INATIVAÇÃO",{|| MsAguarde({|lEnd| goOKInat('TRB2', oWinBrw2)},"Aguarde...","Processando Inativação dos clientes marcados...",.T.) },,4,,.F.)
					//endif
					
					oWinBrw2:AddButton("Sair",{|| oDlgPln:End() },,4,,.F.)
					oWinBrw2:SetProfileID("2")
					oWinBrw2:SetAmbiente(.F.)
					oWinBrw2:SetWalkthru(.F.)		
					oWinBrw2:SetFixedBrowse(.T.)		
					oWinBrw2:DisableConfig(.T.)		
					oWinBrw2:DisableReport(.T.)
					
					//Usa o Filtro no Browse
					if cPerInat <> '180'
						oWinBrw2:SetUseFilter(.T.)	
						oWinBrw2:SetDBFFilter(.T.)
						oWinBrw2:SetFilterDefault( "" )
						oWinBrw2:SetFieldFilter(aFieFilter)
					else
						oWinBrw2:oBrowse:SetDBFFilter(.T.)
						oWinBrw2:oBrowse:SetUseFilter(.T.)	
						oWinBrw2:oBrowse:SetFilterDefault( "" )
						oWinBrw2:oBrowse:SetFieldFilter(aFieFilter)
					endif

					oWinBrw2:Activate()
						
					dbSelectArea('TRB3')
					TRB3->( dbGotop() )
					
					if cPerInat <> '360'
						oWinBrw3:=FWMBrowse():New()
					else
						oWinBrw3:=FWMarkBrowse():New()
						lMarca360 := .T.
					endif
					
					oWinBrw3:SetOwner(oFolder:aDialogs[3])
					oWinBrw3:SetDescription("TELA 3")
					oWinBrw3:SetAlias('TRB3')
					oWinBrw3:SetTemporary(.T.) 
					oWinBrw3:SetFields(aHead03)
					
					if cPerInat == '360'
						oWinBrw3:SetFieldMark("OK")
						oWinBrw3:SetAllMark({|| MkLstTrbTd('TRB3', oWinBrw3)})                  // Marca / Desmarca todos
					endif
					
					//oWinBrw:bLDblClick := {|| stClickBrw("2") }
					oWinBrw3:DisableDetails()
					oWinBrw3:SetMenudef( '' )
					oWinBrw3:AddButton("Exportar Excel",{|| MsAguarde({|lEnd| goBuildExcel('TRB3', aHead03)},"Aguarde...","Preparando dados para a planilha...",.T.) },,4,,.F.)
					//oWinBrw:AddButton("Selecionar Todos",{|| stMarkAll() },,4,,.F.)
					//oWinBrw:AddButton("Integrar Selecionados",{|| stProcEnviaAll() },,4,,.F.)

					//if cPerInat == '360'
					//	oWinBrw3:AddButton("REALIZAR INATIVAÇÃO",{|| MsAguarde({|lEnd| goOKInat('TRB3', oWinBrw3)},"Aguarde...","Processando Inativação dos clientes marcados...",.T.) },,4,,.F.)
					//endif
					
					oWinBrw3:AddButton("Sair",{|| oDlgPln:End() },,4,,.F.)
					oWinBrw3:SetProfileID("3")
					oWinBrw3:SetAmbiente(.F.)
					oWinBrw3:SetWalkthru(.F.)		
					oWinBrw3:SetFixedBrowse(.T.)		
					oWinBrw3:DisableConfig(.T.)		
					oWinBrw3:DisableReport(.T.)
					
					//Usa o Filtro no Browse
					if cPerInat <> '360'
						oWinBrw3:SetUseFilter(.T.)	
						oWinBrw3:SetDBFFilter(.T.)
						oWinBrw3:SetFilterDefault( "" )
						oWinBrw3:SetFieldFilter(aFieFilter)
					else
						oWinBrw3:oBrowse:SetDBFFilter(.T.)
						oWinBrw3:oBrowse:SetUseFilter(.T.)	
						oWinBrw3:oBrowse:SetFilterDefault( "" )
						oWinBrw3:oBrowse:SetFieldFilter(aFieFilter)
					endif

					oWinBrw3:Activate()
						
					/*
					dbSelectArea('TRB4')
					TRB4->( dbGotop() )

					if cPerInat <> 'NOVOS'
						oWinBrw4:=FWMBrowse():New()
					else
						oWinBrw4:=FWMarkBrowse():New()
						lMarcaNew := .T.
					endif

					oWinBrw4:SetOwner(oFolder:aDialogs[4])
					oWinBrw4:SetDescription("TELA 4")
					oWinBrw4:SetAlias('TRB4')
					oWinBrw4:SetTemporary(.T.) 
					oWinBrw4:SetFields(aHead04)
					
					if cPerInat == 'NOVOS'
						oWinBrw4:SetFieldMark("OK")
						oWinBrw4:SetAllMark({|| MkLstTrbTd('TRB4', oWinBrw4)})                  // Marca / Desmarca todos
					endif
					
					oWinBrw4:DisableDetails()
					oWinBrw4:SetMenudef( '' )
					oWinBrw4:AddButton("Exportar Excel",{|| MsAguarde({|lEnd| goBuildExcel('TRB4', aHead04)},"Aguarde...","Preparando dados para a planilha...",.T.) },,4,,.F.)

					if cPerInat == 'NOVOS'
						oWinBrw4:AddButton("REALIZAR INATIVAÇÃO",{|| MsAguarde({|lEnd| goOKInat('TRB4', oWinBrw4)},"Aguarde...","Processando Inativação dos clientes marcados...",.T.) },,4,,.F.)
					endif
					
					oWinBrw4:AddButton("Sair",{|| oDlgPln:End() },,4,,.F.)
					oWinBrw4:SetProfileID("34")
					oWinBrw4:SetAmbiente(.F.)
					oWinBrw4:SetWalkthru(.F.)		
					oWinBrw4:SetFixedBrowse(.T.)		
					oWinBrw4:DisableConfig(.T.)		
					oWinBrw4:DisableReport(.T.)

					//Usa o Filtro no Browse
					if cPerInat <> 'NOVOS'
						oWinBrw4:SetUseFilter(.T.)	
						oWinBrw4:SetDBFFilter(.T.)
						oWinBrw4:SetFilterDefault( "" )
						oWinBrw4:SetFieldFilter(aFieFilter)
					else
						oWinBrw4:oBrowse:SetDBFFilter(.T.)
						oWinBrw4:oBrowse:SetUseFilter(.T.)	
						oWinBrw4:oBrowse:SetFilterDefault( "" )
						oWinBrw4:oBrowse:SetFieldFilter(aFieFilter)
					endif

					oWinBrw4:Activate()
					*/

					//U_UEST60CC()
					
	ACTIVATE DIALOG oDlgPln CENTERED on Init oFolder:ShowPage(nPasta)
	
Return



Static Function goBuildExcel( _cAlias, _aHead999 )

Local oExcel		:= FWMSEXCEL():New()

Local cWrkSht       := ""
Local cTabTitle     := ""

Local lTotalize		:= .F.

Local nField

BEGIN SEQUENCE
	
	MsProcTxt("Criando a estrutura da Planilha...")

	//For nI := 1 To Len(aFil)
		
	cWrkSht   := "Clientes"
		
	//cTabTitle := 'CLIENTES PARA INATIVAÇÃO - DATA BASE: ' + DToC(dDataBase)
	cTabTitle := 'CLIENTES PARA INATIVAÇÃO'
	if _cAlias == 'TRB1'
		cTabTitle += ' - PERIODO: 90 DIAS'
	elseif _cAlias == 'TRB2'
		cTabTitle += ' - PERIODO: 180 DIAS'
	elseif _cAlias == 'TRB3'
		cTabTitle += ' - PERIODO: 360 DIAS'
	elseif _cAlias == 'TRB4'
		cTabTitle += ' - NOVOS SEM MOVIMENTO'
	endif
	cTabTitle += ' - DATA BASE: ' + DToC(dDataBase)
		
	//Primeira planilha
	oExcel:AddworkSheet(cWrkSht)
		
	oExcel:AddTable(cWrkSht, cTabTitle)
		
	//Cria as colunas 
	nFields := Len( _aHead999 )
	For nField := 1 To nFields
		
		//If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
			cType := _aHead999[nField][3]	//__AHEADER_TYPE__
			nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
			nFormat := IF(cType=="D",4,IF(cType=="N",2,1)) 
			cColumn := _aHead999[nField][1]	//__AHEADER_TITLE__
			lTotal := ( lTotalize .and. cType == "N" )
			oExcel:AddColumn(@cWrkSht,@cTabTitle,@cColumn,@nAlign,@nFormat,@lTotal)
		//EndIf
		
	Next nField
		
	//Popula a planilha
	aCells := Array(nFields)
		
	MsProcTxt("Populando a planilha com os valores...")
		
	(_cAlias)->(dbGotop())
	While (_cAlias)->(!eof())
		
		/*if empty(TRB1->CDPRD)
			oExcel:SetLineBold(.T.)
		else
			oExcel:SetLineBold(.F.)
		endif*/
	
		For nField := 1 To nFields
			
			//If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
				uCell := &(_cAlias + '->' + _aHead999[nField][2])
				cPicture := _aHead999[nField][6]	//__AHEADER_PICTURE__
				IF ValType(uCell) # "N" .And. !( Empty(cPicture) )
					uCell := Transform(uCell,cPicture)
				ElseIf ValType(uCell) == "N"
					uCell := AllTrim(Transform(uCell,"@E 999,999,999,999.99"))
				EndIF
				aCells[nField] := uCell
			//EndIf
			
		Next
		
		oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells))
		
		(_cAlias)->(dbSkip())
		
	EndDo
		
	//Next nI
	
	oExcel:Activate()
	
	MsProcTxt("Criando a planilha para visualização...")
	
	//Nome do Arquivo
	cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	
	While File( cFile )
		cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	End While
	
	oExcel:GetXMLFile( cFile )
	
	oExcel:DeActivate()
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	cFileTMP := ( GetTempPath() + cFile )
	IF .NOT.( __CopyFile( cFile , cFileTMP ) )
		alert('nao deu de copiar')
		fErase( cFile )
		cFile := ""
		BREAK
	EndIF

	fErase( cFile )
	
	cFile := cFileTMP
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	IF .NOT.( ApOleClient("MsExcel") )
		alert('nao sera possivel abrir excel')
		BREAK
	EndIF
	
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open( cFile )
	oMsExcel:SetVisible( .T. )
	oMsExcel := oMsExcel:Destroy()

END SEQUENCE

oExcel := FreeObj( oExcel )

Return


Static Function goOKInat( _cAlias, _oMKObj )

Local aAreaAli := (_cAlias)->( GetArea() )

if !APMsgYESNO("Confirma a INATIVAÇÃO dos clientes marcados?","UFINA060")
	Return
endif

BEGIN SEQUENCE

	lOk := .F.
	(_cAlias)->(dbGotop())
	While !(_cAlias)->(eof())

		if (_cAlias)->OK == _oMKObj:Mark()
		
			MsProcTxt("Inativando cliente: " + (_cAlias)->CDCLI + '/' + (_cAlias)->LJCLI + ' - ' + alltrim((_cAlias)->NMCLI))
			
			SA1->(dbSetOrder(1))
			if SA1->(dbSeek(xFilial('SA1') + (_cAlias)->CDCLI + (_cAlias)->LJCLI))
				
				SA1->(recLock('SA1', .F.))
				SA1->A1_MSBLQL	:= '1' 
				SA1->A1_RISCO	:= 'E'
				SA1->A1_VENCLC	:= ctod('')
				SA1->(msUnlock())
				
				
				SA3->(dbSetOrder(1))
				SA3->(dbSeek(xFilial('SA3') + SA1->A1_VEND))

				TRBOK->(reclock('TRBOK', .T.))
					TRBOK->CDCLI	:= SA1->A1_COD
					TRBOK->LJCLI	:= SA1->A1_LOJA
					TRBOK->NMCLI	:= SA1->A1_NOME
					TRBOK->RDCLI	:= SA1->A1_NREDUZ
					TRBOK->CNPJ		:= SA1->A1_CGC
					TRBOK->VEND		:= SA1->A1_VEND
					TRBOK->REGIAO	:= SA3->A3_GEREN
				TRBOK->(msUnlock())
				
				(_cAlias)->(recLock(_cAlias, .F.))
				(_cAlias)->(dbDelete())
				(_cAlias)->(msUnlock())
				
				lOk := .T.
			endif
			
		endif

		(_cAlias)->(dbSkip())
	End

END SEQUENCE

RestArea(aAreaAli)	
//_oMKObj:Refresh()
_oMKObj:oBrowse:UpdateBrowse()


if lOk
	DEFINE MSDIALOG oInat FROM	09,0 TO 30,110 TITLE "Relação de Clientes Inativados" OF oMainWnd STYLE DS_MODALFRAME STATUS
	
	dbSelectArea('TRBOK');dbGotop()
	oMarkOK := MsSelect():New("TRBOK",,"",aHeadOK,,,{3.5, 5, 140, 435},,,oInat,,)
	
	@ 143,170 BUTTON oBut02 PROMPT "Imprimir"	SIZE 60,12 ACTION goUFINR060() 		OF oInat PIXEL
	@ 143,235 BUTTON oBut03 PROMPT "Fechar"  	SIZE 60,12 ACTION oInat:End() 	OF oInat PIXEL
	
	ACTIVATE MSDIALOG oInat CENTERED
endif

Return

Static Function ProcQryTab(oProcpln)
//Local _x
	
	oProcpln:IncRegua1("Filtrando os Clientes na Base...")
	SysRefresh()
	
	//pergunte(cPerg, .F.)
	
	//Se informou a selecao de região
	/*cFilGer := '%'
	if !empty(mv_par01)
		cFilGer += "and a3_geren IN ('"
		aRet := STRTOKARR(mv_par01, ';')
		For _x:= 1 to len(aRet)
			if !empty(aRet[_x])
				cFilGer += iif(_x > 1, "','", "")
				cFilGer += aRet[_x]
			endif 
		next
		cFilGer += "')"
	else
		cFilGer += 'and 1=1'
	endif
	cFilGer += '%'*/

	//Se informou a selecao de vendedor
	/*cFilVen := '%'
	if !empty(mv_par02)
		cFilVen += "and a1_vend IN ('"
		aRet := STRTOKARR(mv_par02, ';')
		For _x:= 1 to len(aRet)
			if !empty(aRet[_x])
				cFilVen += iif(_x > 1, "','", "")
				cFilVen += aRet[_x]
			endif 
		next
		cFilVen += "')"
	else
		cFilVen += 'and 1=1'
	endif
	cFilVen += '%'*/
	
//		  when a1_ultcom = ' ' and ((a1_dtcad != ' ' and round(SYSDATE - to_date(a1_dtcad,'YYYYMMDD')) > 30) or a1_dtcad = ' ')
//      		then 'DNEW'
//		%exp:cFilGer%
//		%exp:cFilVen%
//		and A1_INSCRUR = ' '
//		and substr(a1_cgc,1,8) <> '84432111'
	BeginSql alias "QRY"
		COLUMN A1_ULTCOM AS DATE, A1_DTCAD AS DATE
		
		%noParser%
		
		SELECT 
		
		CASE 
		  WHEN A1_ULTCOM != ' ' AND A1_ULTCOM <= CONVERT(NCHAR(8),GETDATE()-360,112)
			THEN 'D360'
		  WHEN A1_ULTCOM != ' ' AND A1_ULTCOM <= CONVERT(NCHAR(8),GETDATE()-180,112)
			THEN 'D180'
		  WHEN A1_ULTCOM != ' ' AND A1_ULTCOM <= CONVERT(NCHAR(8),GETDATE()-90,112)
			THEN 'D90'
		  ELSE ''
		END SEMCOMP,
		A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_DDD, A1_TEL, A1_CGC, A1_MUN, A1_EST, A1_TIPO, 
		A1_VEND, A1_ULTCOM, A1_DTCAD, A3_GEREN
		FROM %TABLE:SA1% A1
	    LEFT JOIN %TABLE:SA3% A3 ON A3_COD = A1_VEND AND A3.%NOTDEL%
		WHERE A1.%NOTDEL%
		AND A1_MSBLQL <> '1'
		AND A1_PESSOA = 'J'

		//Pedidos em carteira
          //and round(SYSDATE - to_date(c5_emissao,'YYYYMMDD')) <= 180
	    AND NOT EXISTS (    
	      SELECT C6_CLI, C6_LOJA
	      FROM %TABLE:SC6% C6
		  INNER JOIN %TABLE:SC5% C5 ON C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM
	      WHERE C6.%NOTDEL% AND C5.%NOTDEL%
	      AND C6_QTDENT < C6_QTDVEN
	      AND C6_BLQ <> 'R'       
	      AND A1.A1_COD = C6.C6_CLI AND A1.A1_LOJA = C6.C6_LOJA
          AND C5_EMISSAO >= '20150101'
		  AND DATEDIFF(DAY,CONVERT(DATE,C5_EMISSAO),GETDATE()) <= 180
	    )
		
		ORDER BY A1_NOME
	EndSql
	
	nCount := 0
	
	dbEval( {|x| nCount++ },,{|| QRY->(!EOF()) })
	
	QRY->(dbGotop())
	oProcpln:SetRegua2(nCount)
	SysRefresh()
	
	While QRY->(!eof())
	
		oProcpln:IncRegua2('Alimentando temporario....')
		SysRefresh()
		
		if empty(QRY->SEMCOMP)
			QRY->(dbSkip())
			Loop
		endif
		
		//Se cliente é um representante
		SA3->(dbSetOrder(3))
		if SA3->(dbSeek(xFilial('SA3') + QRY->A1_CGC))
			QRY->(dbSkip())
			Loop
		endif
		
		//if alltrim(QRY->SEMCOMP) == 'DNEW'
		//	_cAlias := 'TRB4'
		//	_cFolder := '4'
		//else
			_cAlias  := iif(alltrim(QRY->SEMCOMP) == 'D90', 'TRB1', iif(alltrim(QRY->SEMCOMP) == 'D180', 'TRB2', 'TRB3'))
			_cFolder := iif(alltrim(QRY->SEMCOMP) == 'D90', '1', iif(alltrim(QRY->SEMCOMP) == '2', '2', '3'))
		//endif
		
		_cTipo := ''
		Do Case
			Case QRY->A1_TIPO == 'F'
				_cTipo := 'Consumidor Final'
			Case QRY->A1_TIPO == 'L'
				_cTipo := 'Produtor Rural'
			Case QRY->A1_TIPO == 'R'
				_cTipo := 'Revendedor'
			Case QRY->A1_TIPO == 'S'
				_cTipo := 'Solidario'
			Otherwise
				_cTipo := 'Exportacao'
		EndCase
		
		(_cAlias)->(reclock(_cAlias, .T.))
			(_cAlias)->CDCLI	:= QRY->A1_COD
			(_cAlias)->LJCLI	:= QRY->A1_LOJA
			(_cAlias)->NMCLI	:= QRY->A1_NOME
			(_cAlias)->RDCLI	:= QRY->A1_NREDUZ
			(_cAlias)->DDD		:= QRY->A1_DDD
			(_cAlias)->FONE		:= QRY->A1_TEL
			(_cAlias)->CNPJ		:= QRY->A1_CGC
			(_cAlias)->MUNI		:= QRY->A1_MUN
			(_cAlias)->EST		:= QRY->A1_EST
			(_cAlias)->ULTCOM	:= QRY->A1_ULTCOM
			(_cAlias)->DATCAD	:= QRY->A1_DTCAD
			(_cAlias)->TIPO		:= _cTipo
			(_cAlias)->FOLDER	:= _cFolder
			(_cAlias)->VEND		:= QRY->A1_VEND
			(_cAlias)->REGIAO	:= QRY->A3_GEREN
		(_cAlias)->(msUnlock())
		
		
		QRY->(dbSkip())
	End
	QRY->(dbCloseArea())
	
	
Return

/*Static Function ArrayToCBox(aFil)
	
	Local cRet := ""
	Local nI
	
	For nI := 1 To Len(aFil)
		
		If nI > 1
			
			cRet += ";"
			
		EndIf
		
		cRet += aFil[nI] + "=" + AllTrim(FWFilialName(cEmpAnt, aFil[nI]))
		
	Next nI
	
Return cRet*/

//Marca TUDO
Static Function MkLstTrbTd( _cAlias, _oMKObj )

	Local aAreaAli := (_cAlias)->( GetArea() )
	
	(_cAlias)->( dbGoTop() )
	While (_cAlias)->( !Eof() )
	
		Begin Sequence
		
			(_cAlias)->(RecLock(_cAlias, .F.))
				if (_cAlias)->OK == _oMKObj:Mark()
					(_cAlias)->OK := space(02)
				else
					(_cAlias)->OK := _oMKObj:Mark()
				endif
			(_cAlias)->( MsUnlock() )
			
		End Sequence
		
		(_cAlias)->( dbSkip() )
		
	EndDo

	RestArea(aAreaAli)	
	_oMKObj:Refresh()
	
Return


/*/{Protheus.doc} goUFINR060
Função para imprimir a relação dos clientes inativados
@type function
@author Crele Cristina da Costa
@since 13/01/2016
@version 1.0
@param cEmpPro, character, Código da empresa no Protheus
@return character, Código da empresa no sistema Senior
/*/Static Function goUFINR060()

	oReport := goRelWSOK()
	oReport:PrintDialog()

Return

/* Relatorio dos Clientes Inativados */
Static Function goRelWSOK()
*************************
Local oReport
Local oSection1

oReport := TReport():New("UFINA060","Inativação de Clientes em: " + dtoc(dDataBase),NIL,{|oReport| goPrtWSOK(oReport)},"Relatorio dos Clientes Inativados")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"OKInativacao",{"TRBOK"})
TRCell():New(oSection1,"CDCLI"		,"","Cliente"       ,,,,{|| TRBOK->CDCLI })
TRCell():New(oSection1,"LJCLI"		,"","Loja"      	,,,,{|| TRBOK->LJCLI })
TRCell():New(oSection1,"NMCLI"		,"","Nome"      	,,,,{|| TRBOK->NMCLI })
TRCell():New(oSection1,"CNPJ"		,"","CNPJ"        	,,,,{|| TRBOK->CNPJ })
TRCell():New(oSection1,"VEND"		,"","Vendedor"		,,,,{|| TRBOK->VEND })
TRCell():New(oSection1,"REGIAO"		,"","Regiao"		,,,,{|| TRBOK->REGIAO })

oSection1:Cell("CDCLI"):SetSize(6)
oSection1:Cell("LJCLI"):SetSize(6)
oSection1:Cell("NMCLI"):SetSize(45)
oSection1:Cell("CNPJ"):SetSize(20)
oSection1:Cell("VEND"):SetSize(6)
oSection1:Cell("REGIAO"):SetSize(6)

oSection1:SetHeaderPage()
oSection1:SetTotalInLine(.F.)   //Imprime o total em linha

Return oReport

Static Function goPrtWSOK(oReport)
**********************************
Local oSection1 := oReport:Section(1)

//oReport:SetTotalText({|| "TOTAL GERAL ---> "})

//oBreak := TRBreak():New(oSection1,{|| TRBOK->CODEMP + TRBOK->CODFIL},{|| "Total Filial --> " + AllTrim(cNomFil)})
//oBreak:lPageBreak := .T.	//Quebrar pagina
//oBreak:OnBreak({|x| (nRTRB := TRBOK->(recno()), TRBOK->(dbSkip(-1)), cNomFil := Capital(FwFilialName(,TRBOK->CODFIL)), TRBOK->(dbGoto(nRTRB))) })
/*
TRFunction():New(oSection1:Cell("VLRBRU"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("SALLIQ"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("BSINSS"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("VLINSS"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("BSIRRF"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("VLIRRF"),"","SUM",oBreak,,,,.F.,.T.)
TRFunction():New(oSection1:Cell("VLRSES"),"","SUM",oBreak,,,,.F.,.T.)
*/

//Impressao do Relatorio
////////////////////////
oReport:SetMeter(TRBOK->(reccount()))
oSection1:Init()

//TRBOK->(dbSetOrder(2))
TRBOK->(dbGotop())
While TRBOK->(!eof()) .and. !oReport:Cancel()
	oReport:IncMeter()
	oSection1:PrintLine()
	
	TRBOK->(dbSkip())		
EndDo
oSection1:Finish()

//TRBOK->(dbSetOrder(1))
TRBOK->(dbGotop())
oMarkOK:oBrowse:Refresh(.T.)

Return
