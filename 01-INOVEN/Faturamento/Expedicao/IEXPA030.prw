#INCLUDE 'PROTHEUS.CH'
#INCLUDE "TOTVS.CH"

#DEFINE MAXGETDAD 99999
#DEFINE CRLF CHR(13) + CHR(10)

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA030

@description Realiza a conferncia da nota para Expedição

@author Bernard M. Margarido
@since 20/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPA030(cRomaneio,cNota,cSerie,cCliente,cLoja)
Local aArea			:= GetArea()
Local aSize 		:= MsAdvSize()
Local aObjects 		:= {}
Local aPosObj  		:= {}
Local aPosGet		:= {}

Local cEtiqueta		:= Space(50)
Local cArqLock		:= cRomaneio + "_" + cNota + "_" + RTrim(cSerie) + ".lck"
Local nOpcA			:= 0

Local bColorList	:= &("{|| TFatACorBrw(@aCorRgb) }")
//Local bLinOk		:= {|| u_TFat3ALiOk()}
//Local bTudoOk		:= {|| u_TFat3ATdOk()}
Local bValdGet		:= {|| IIF(!Empty(cEtiqueta),(TFatA03Etq(cEtiqueta),cEtiqueta := Space(50),oGetEtq:SetFocus()),(.T.))}

//Local oSize     	:= FWDefSize():New( .T. )
Local oFwLayer    	:= FWLayer():New()		
Local oDlg			:= Nil
Local oPanel1		:= Nil
Local oPanel2		:= Nil
Local oBmpC1		:= Nil
Local oBmpC2		:= Nil
Local oSayC1 		:= Nil
Local oSayC2 		:= Nil
Local oTBtnOk		:= Nil
Local oTBtnExit		:= Nil

Local oFont1  		:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)

Private nHdlLock	:= 0

Private oGetEtq		:= Nil
Private oGetNF		:= Nil
Private	oGetItConf	:= Nil

Private aHeadNF		:= {}
Private aColsNF		:= {}
Private aAlterNF	:= {}
Private	aCpoEnc		:= {}
Private aHeadConf	:= {}
Private aColsConf	:= {} 

Private _oBmpInfo	:= Nil 
Private _oSayInfo	:= Nil
Private _oChkExbEr	:= Nil

Private _lExibErro	:= .F.

//----------------+
// Posiciona Nota |
//----------------+
dbSelectArea("SF2")
SF2->( dbSetOrder(1) )
If !SF2->( dbSeek(xFilial("SF2") + cNota + cSerie + cCliente + cLoja ) )
	MsgInfo("Nota não encontrada","INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

//------------------+
// Cria arquivo LCK |
//------------------+
If !IEXPA030Lck(cArqLock,1)
	RestArea(aArea)
	Return .F.
EndIf	

//-----------------------+
// Cria Teclas de Atalho |
//-----------------------+
SetKey( VK_F12 , { || Eval(bIniConf) } )

//------------+
// Cria aCols |
//------------+
TFatA03NF(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

//------------------------+
// Cria aCols Conferencia |
//------------------------+
TFatA03CF(SF2->F2_DOC,SF2->F2_SERIE,SF2->F2_CLIENTE,SF2->F2_LOJA)

//-----------------------------------------+
// Coordenadas da Tela, conforme resolução |
//-----------------------------------------+ 
aAdd( aObjects, { 100, 100, .T., .T. } )
aAdd( aObjects, { 315,  70, .T., .T. } )

aInfo	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects, .F. )

aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{ 	{1.4,45,310.4}			,;	// Itens do Romaneio - MsGetDados
												{3.8,0.5,5.2}			,;	// Legendas Clientes	
												{53,10,48}				,;	// Descrição Legendas
												{60,80,48}				,;	// Botão de Ação	
												{3.8,18,5.2}			,;	// Imagem do Erro
												{60,150,48}				})	// Mensagem 
												

//Begin Transaction 
	DEFINE MSDIALOG oDlg TITLE "INOVEN - Expedição Nota " + Alltrim(SF2->F2_DOC) + " Serie " + Alltrim(SF2->F2_SERIE) FROM aSize[7],0 to aSize[6],aSize[5] - 300 OF oMainWnd PIXEL STYLE DS_MODALFRAME
	
	//-----------------------------------------+
	// Nao permite fechar tela teclando no ESC |
	//-----------------------------------------+
	oDlg:lEscClose := .F.
	
	//--------------+
	// Painel Layer |
	//--------------+
	oFwLayer := FwLayer():New()
	oFwLayer:Init(oDlg,.F.)
	
	//------------+
	// 1o. Painel |   
	//------------+
	oFWLayer:AddLine("DADOSNOTA",045, .T.)
	oFWLayer:AddLine("DADOSCONF",055, .T.)
	
	oFWLayer:AddCollumn( "COLDADNF"	,100, .T. , "DADOSNOTA")
	oFWLayer:AddCollumn( "COLDADCO"	,100, .T. , "DADOSCONF")
	
	oFWLayer:AddWindow( "COLDADNF", "WINENT", "Itens Nota Fiscal", 100, .F., .F., , "DADOSNOTA") 
	oFWLayer:AddWindow( "COLDADCO", "WINENT", "Itens Conferidos", 098, .F., .F., , "DADOSCONF")
	
	oPanel1 := oFWLayer:GetWinPanel("COLDADNF","WINENT","DADOSNOTA")
	oPanel2 := oFWLayer:GetWinPanel("COLDADCO","WINENT","DADOSCONF")
	
	//----------------------------------+
	// Criacao da GetDados Itens Pedido |
	//----------------------------------+
	oGetNF 		:= MsNewGetDados():New(aPosGet[1,1] - 2 ,aPosGet[1,1] - 2,aPosGet[1,2] + 10 ,aPosGet[1,3] + 5 , GD_UPDATE, /*bLinOk*/, /*bTudoOk*/, /*cIniCpos*/, aAlterNF,/*nFreeze*/,MAXGETDAD,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oPanel1,aHeadNF,aColsNF)
	oGetNF:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
	oGetNF:oBrowse:SetBlkBackColor(bColorList)
	
	//--------------------------------------+
	// Criacao da GetDados Itens Conferidos |
	//--------------------------------------+
	oGetItConf 	:= MsNewGetDados():New(aPosGet[1,1] - 2 ,aPosGet[1,1] - 2,aPosGet[1,2] + 08 ,aPosGet[1,3] - 147 , GD_INSERT + GD_UPDATE, /*bLiOkNf*/, /*bTudoOk*/, /*cIniCpos*/, aAlterNF,/*nFreeze*/,MAXGETDAD,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oPanel2,aHeadConf,aColsConf)
	
	//----------------------+
	// Cria objetos na tela |
	//----------------------+
	oGetEtq	:= TGet():New( aPosGet[1,2] + 10, 001	, {|u| IIF(PCount() > 0, cEtiqueta := u, cEtiqueta	)} 	, oPanel2, 200, 010,"@!",bValdGet,,,,,,.T.,,,,,,,.F.,,,"cEtiqueta",,,,.T.,,,"Etiqueta ",2)
	oGetEtq:SetFocus()
	
	//---------+
	// Legenda |
	//---------+
	oBmpC1		:= TBitmap():New( aPosGet[2,1] + 1.1, aPosGet[2,2], 015, 015, "PMSTASK4.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
	oSayC1 		:= TSay():New( aPosGet[3,1] + 15, aPosGet[3,2], {|| "Conferido" } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )
	
	oBmpC2		:= TBitmap():New( aPosGet[2,1] + 1.1, aPosGet[2,2] + 6, 015, 015, "PMSTASK2.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
	oSayC2 		:= TSay():New( aPosGet[3,1] + 15, aPosGet[3,2] + 050, {|| "Divergencia" } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )
	
	oTBtnOk 	:= TButton():New( aPosGet[4,1] - 06, aPosGet[4,2] 		, "Confirma",oPanel2,{|| IIF(u_TFat3ATdOk(),( nOpcA := 1,oDlg:End()),oGetEtq:SetFocus()) }	, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTBtnExit  	:= TButton():New( aPosGet[4,1] - 06, aPosGet[4,2] + 50	, "Cancelar",oPanel2,{|| IIF(TFat3ASair(), oDlg:End(),nOpcA := 0 ) } ,40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	_oChkExbEr  :=  TCheckBox():New(aPosGet[1,2] + 10,aPosGet[4,2] + 60 ,'Parar Operação com Mensagem' ,{|u|If(Pcount()==0,_lExibErro,_lExibErro:=u)},oPanel2,100,210,,,,,,,,.T.,,,)
	_oBmpInfo   :=  TBitmap():New(aPosGet[5,1],aPosGet[5,2], 30, 30, "", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, .T., /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
	_oSayInfo	:=  TSay():New(aPosGet[6,1],aPosGet[6,2] + 12, {|| "" } ,oPanel2 ,,oFont1,,,, .T. ,,, 250,012 )
	_oBmpInfo:LVISIBLE := .F.  
	
	//->> Caso esteja posicionado em algum controle que não seja a entrada da barra, ou visualização dos browses, reposicionar pelo focus o campo da barras.                  
	oTimer := TTimer():New(10, {|| (oTimer:LACTIVE := .F.,If(GetFocus() == oGetEtq:HWND .Or. GetFocus() == oGetNF:OBROWSE:HWND .Or. GetFocus() == oGetItConf:OBROWSE:HWND,.T.,oGetEtq:SetFocus()),oTimer:LACTIVE := .T.) }, oDlg )
	oTimer:Activate()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
//--------------------------------+
// Realiza a gravação do Romaneio | 
//--------------------------------+
If nOpcA == 1
	FWMsgRun(, {|| IEXPA030Grv(cRomaneio,cNota,cSerie) }, "Processando", "Encerrando Expedição...." )		
//Else
//	DisarmTransaction()
EndIf	
//End Transaction 
    
If nOpcA == 1
	If MsgYesNo("Deseja imprimir etiquetas de volume?")
		U_IEXPR030(cNota,cSerie)
	EndIf		
EndIf

//--------------------+
// Exclui arquivo LCK |
//--------------------+
IEXPA030Lck(cArqLock,2)

//-----------------------------------------+
// Retorna o Backup das Teclas de Funcoes  |
//-----------------------------------------+
SetKey(VK_F12,{|| Nil})

RestArea(aArea)	
Return

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA030Grv

@description Realiza a atualizacao do status do romaneio

@author Bernard M. Margarido
@since 08/05/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function IEXPA030Grv(cRomaneio,cNota,cSerie)
Local aArea	:= GetArea()

//Local nPItem		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "ITECONF"})
Local nPProd		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PRDCONF"})
//Local nPDesc		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "DESCONF"})
//Local nPQtd			:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "QTDCONF"})
Local nPCaixa		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "NCXCONF"})
Local nPPallet		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PALCONF"})
Local nPLote		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "LOTCONF"})

Local _lMotorista	:= .F.
Local nEtq

//---------------------+
// Posiciona Etiquetas |
//---------------------+
dbSelectArea("ZZA")
ZZA->( dbSetOrder(1) )

//----------------------------+
// Marca etiquetas como lidas |
//----------------------------+
For nEtq := 1 To Len(oGetItConf:aCols)

	//-----------------------+
	// Baixa etiqueta Pallet |
	//-----------------------+
	If Empty(oGetItConf:aCols[nEtq][nPCaixa])
		IEXPA040xPl(oGetItConf:aCols[nEtq][nPProd],oGetItConf:aCols[nEtq][nPCaixa],oGetItConf:aCols[nEtq][nPLote],oGetItConf:aCols[nEtq][nPPallet],cNota,cSerie)
	//----------------------+
	// Baixa etiqueta caixa |
	//----------------------+	
	Else
		IEXPA040xCx(oGetItConf:aCols[nEtq][nPProd],oGetItConf:aCols[nEtq][nPCaixa],oGetItConf:aCols[nEtq][nPLote],oGetItConf:aCols[nEtq][nPPallet],cNota,cSerie)
	EndIf
	
Next nEtq 

//----------------------------+
// Posiciona Item do Romaneio |
//----------------------------+
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
If ZZE->( dbSeek(xFilial("ZZE") + cRomaneio + cNota + cSerie ) )
	RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS := "3"
	ZZE->( MsUnLock() )
EndIf

//---------------------------+
// Valida dados do motorista |
//---------------------------+
If Empty(M->ZZD_MOTORI) .And. ( !Empty(M->ZZD_DESCMO) .Or. !Empty(M->ZZD_CNH) ) 
	If MsgNoYes("Foram informado dados do motorista no romaneio. Deseja cadastra-los ? ","INOVEN - Avisos")
		_lMotorista := .T.
	EndIf
EndIf

//------------------------------+	
// Valida cadastro de motorista | 
//------------------------------+
If _lMotorista
	u_TFatA02Mot(@_cCodMot)
	If !Empty(_cCodMot)
		RecLock("ZZD",.F.)
			ZZD->ZZD_MOTORI := _cCodMot
		ZZD->( MsUnLock() )
	EndIf
EndIf

RestArea(aArea)
Return .T. 

/*******************************************************************************************/
/*/{Protheus.doc} TFat3ALiOk

@description Valida linha do aCols

@author Bernard M. Margarido
@since 20/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
User Function TFat3ALiOk()

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat3ALiOk

@description Valida aCols

@author Bernard M. Margarido
@since 20/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
User Function TFat3ATdOk()
Local lRet		:= .T.

Local cMsg		:= ""

Local nCols		:= 1
//Local nPItemNf	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2ITEM" })
Local nPCodPrd	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2PROD" })
Local nPQtdNf	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2QTDV" })
Local nPQtdConf	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2QTDC" })
//Local nPStatus	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2STAT" })

//---------------------------------------------------+
// Valida se todos os itens da nota foram conferidos |
//---------------------------------------------------+

For nCols := 1 To Len(oGetNf:aCols)
	//------------------------------------------+
	// Não pode ter linha deletada no romaneio  |
	//------------------------------------------+
	If oGetNf:aCols[nCols][Len(oGetNf:aHeader) + 1]
		cMsg := "Não é permitido deletar produtos na expedição"
	Else
		If oGetNf:aCols[nCols][nPQtdNf] <> oGetNf:aCols[nCols][nPQtdConf]
			//cMsg += "Não é permitido encerrar conferencia. Item " +  Alltrim(oGetNf:aCols[nCols][nPItemNf]) + " Produto " + Alltrim(oGetNf:aCols[nCols][nPCodPrd]) + " divergente." + CRLF
			cMsg += "Não é permitido encerrar conferencia.  Produto " + Alltrim(oGetNf:aCols[nCols][nPCodPrd]) + " divergente." + CRLF
		EndIf
	EndIf
Next nCols

If !Empty(cMsg)
	MsgInfo(cMsg,"INOVEN - Avisos")
	lRet := .F.
EndIf

If Len(oGetNf:aCols)==0
	lRet := .F.
EndIf

Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFat3ASair

@description Valida botão cancelar

@author Bernard M. Margarido
@since 12/07/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFat3ASair()
Local lRet	:= .T.

//-----------------------+
// Reseta campo etiqueta |
//-----------------------+
cEtiqueta := Space(50)

If !MsgYesNo("Reamente deseja cancelar expedição?")
	lRet := .F.
	If ValType(oGetEtq) == "O"
		oGetEtq:SetFocus()
	EndIf	
EndIf

Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Etq

@description Realiza a leitura da Eitqueta 

@author Bernard M. Margarido
@since 20/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Etq(cEtiqueta)
Local aArea			:= GetArea()

Local lContinua		:= .T.
Local lPallet		:= .T.
Local lCaixa		:= .T.

cEtiqueta := alltrim(cEtiqueta)

//--------------------+
// Valida se é Pallet |
//--------------------+
If !TFatA03Pal(cEtiqueta,@lContinua,@lPallet)
	//------------------+
	// Valida se é Lote |
	//------------------+
	If lContinua
		TFatA03Lot(cEtiqueta,@lContinua,@lCaixa)
	EndIf	
EndIf	

If !lPallet .And. !lCaixa
	If _lExibErro
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.	
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		MsgAlert("Etiqueta não encontrada.","INOVEN - Avisos")
	Else	
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText("Etiqueta não encontrada.")
		_oSayInfo:CtrlRefresh()
	EndIf	
Else
	_oBmpInfo:cResname := ""
	_oBmpInfo:LVISIBLE := .F.
	_oBmpInfo:Refresh()		
	_oSayInfo:SetText("")
	_oSayInfo:CtrlRefresh()	
EndIf

RestArea(aArea)
Return lContinua

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Pal

@description Realiza a leitura da Etiqueta Pallet 

@author Bernard M. Margarido
@since 08/05/2018
@version 1.0

@param cCodEtq	, characters, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Pal(cEtiqueta,lContinua,lPallet)
Local aArea			:= GetArea()

Local cCodPallet	:= ""
Local cCodProd		:= ""
Local cNFEtq		:= ""
Local cItemNf		:= ""
Local cAlias		:= GetNextAlias()
//Local cQuery 		:= ""

//Local nPItem		:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2ITEM" })
//Local nPCodPrd		:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2PROD" })
//Local nPQtdNf		:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2QTDV" })
//Local nPQtdConf		:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2QTDC" })
//Local nLin			:= 0
Local nTotPalt		:= 0


//-----------------+
// Etiqueta Antiga | 
//-----------------+
If SubStr(cEtiqueta,14,2) == "00"
	cCodPallet	:= SubStr(cEtiqueta,1,13)
	cCodProd	:= SubStr(cEtiqueta,16,4)
	cNFEtq		:= SubStr(cEtiqueta,21,6)
	cItemNf		:= SubStr(cEtiqueta,27,3)
//---------------+
// Etiqueta Nova |
//---------------+
Else
	cCodPallet	:= SubStr(cEtiqueta,1,13)
	cCodProd	:= SubStr(cEtiqueta,14,4)
	cNFEtq		:= SubStr(cEtiqueta,18,9)
	cItemNf		:= SubStr(cEtiqueta,27,4)
EndIf	

//----------------------+
// Retorna Total Pallet |
//----------------------+
If !TFat03TPlt(cAlias,cCodPallet,cCodProd,cNFEtq,cItemNf,@nTotPalt,@lContinua)
	(cAlias)->( dbCloseArea() )
	lPallet := .F.
	RestArea(aArea)
	Return .F.
EndIf

//--------------------------------+
// Valida se pallet já foi aberto |
//--------------------------------+
If nTotPalt <> (cAlias)->B5_XPALLET
	If _lExibErro		
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		MsgAlert("Pallet já aberto.","INOVEN - Avisos")
	Else	
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText("Pallet já aberto.")
		_oSayInfo:CtrlRefresh()
	EndIf	
	
	lContinua := .F.
	
	//--------------------+
	// Encerra temporario |
	//--------------------+
	(cAlias)->( dbCloseArea() )
	
	RestArea(aArea)
	Return .F.
Else
	_oBmpInfo:cResname := ""
	_oBmpInfo:LVISIBLE := .F.
	_oBmpInfo:Refresh()	
	_oSayInfo:SetText("")
	_oSayInfo:CtrlRefresh()
EndIf

//------------------------+
// Conferencia por Pallet |
//------------------------+
While (cAlias)->( !Eof() )

	//--------------------------------+
	// Valida se etiqueta já foi lida |
	//--------------------------------+
	If TFat03ItLido((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,"",(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->B5_XPALLET,(cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
		
		//----------------------+
		// Valida linha da nota |
		//----------------------+
		If TFat03ItNF((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,"",(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->B5_XPALLET,(cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
		
			//---------------------------------------+
			// Adiciona linha acols Itens conferidos |
			//---------------------------------------+
			TFat03ItConf((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,"",(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->B5_XPALLET,(cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
		EndIf	
				
	EndIf
	
	(cAlias)->( dbSkip() )
EndDo

//--------------------+
// Encerra temporario |
//--------------------+
(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T. 

/*******************************************************************************************/
/*/{Protheus.doc} TFat03TPlt

@description Retorna total de Itens por pallet

@author Bernard M. Margarido
@since 04/07/2018
@version 1.0

@param nTotPalt, numeric, descricao

@type function
/*/
/*******************************************************************************************/
Static Function TFat03TPlt(cAlias,cCodPallet,cCodProd,cNFEtq,cItemNf,nTotPalt,lContinua)
Local cQuery 	:= ""

nTotPalt 		:= 0
lContinua		:= .F.

cQuery := "	SELECT " + CRLF
cQuery += "		ZZA.ZZA_CODPRO, " + CRLF
cQuery += "		B1.B1_DESC, " + CRLF
cQuery += "		ZZA.ZZA_PALLET, " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT, " + CRLF
cQuery += "		B5.B5_XPALLET, " + CRLF
cQuery += "		ZZA.ZZA_BAIXA, " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF, " + CRLF
cQuery += "		ZZA.ZZA_NUMNF, " + CRLF
cQuery += "		SUM(ZZA_QUANT) QTDPALLET " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF  
cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = ZZA.ZZA_CODPRO AND B1.D_E_L_E_T_ = '' " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SB5") + " B5 ON B5.B5_FILIAL = '" + xFilial("SB5") + "' AND B5.B5_COD = ZZA.ZZA_CODPRO AND B5.D_E_L_E_T_ = '' " + CRLF
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL  = '" + xFilial("ZZA") + "' AND " + CRLF  
cQuery += "		ZZA.ZZA_PALLET = '" + cCodPallet + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_NUMNF = '" + cNFEtq + "' AND " + CRLF
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_BAIXA = '1' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY ZZA.ZZA_CODPRO,B1.B1_DESC,ZZA.ZZA_PALLET,ZZA.ZZA_NUMLOT,B5.B5_XPALLET,ZZA.ZZA_BAIXA,ZZA.ZZA_ITEMNF,ZZA.ZZA_NUMNF"

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//-----------------------+
// Pallet não encontrado | 
//-----------------------+
If (cAlias)->( Eof() )
	lContinua	:= .T.
	Return .F.
EndIf

nTotPalt := (cAlias)->QTDPALLET

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Lot

@description Realiza busca por lote 

@author Bernard M. Margarido
@since 08/05/2018
@version 1.0

@param cCodEtq	, characters, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Lot(cEtiqueta,lContinua,lCaixa)
Local aArea			:= GetArea()

Local cCodBar		:= ""
Local cCodProd		:= ""
Local cNFEtq		:= ""
Local cItemNf		:= ""
Local cNumCx		:= ""
Local cLote			:= ""
Local cQuery 		:= ""
Local cAlias		:= GetNextAlias()

//Local lContinua 	:= .T.	
Local lEtqAnt		:= .F.
Local lEtqBaixa		:= .F.

//-----------------+
// Etiqueta Antiga | 
//-----------------+
If SubStr(cEtiqueta,14,2) == "00"
	lEtqAnt		:= .T.
	cCodBar		:= SubStr(cEtiqueta,1,13)
	cCodProd	:= SubStr(cEtiqueta,16,4)
	cNFEtq		:= Alltrim(Str(Val(SubStr(cEtiqueta,20,6))))
	cItemNf		:= Alltrim(Str(Val(SubStr(cEtiqueta,27,3))))
	cNumCx		:= Alltrim(Str(Val(SubStr(cEtiqueta,30,5))))
	cLote		:= StrTran(SubStr(cEtiqueta,35),"+","")
Else
	cCodBar		:= SubStr(cEtiqueta,1,13)
	cCodProd	:= SubStr(cEtiqueta,14,4)
	cNFEtq		:= SubStr(cEtiqueta,18,9)
	cItemNf		:= SubStr(cEtiqueta,27,4)
	cNumCx		:= SubStr(cEtiqueta,31,4)
	cLote		:= SubStr(cEtiqueta,35)
EndIf	

//----------------------------------------------+
// Valida se lote pertence a algum item da nota | 
//----------------------------------------------+
If !TFat03VLote(cCodProd,cLote)
	//-----------+
	// Emiti som | 
	//-----------+
	Tone()
	
	If _lExibErro               
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
	Else                       
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText("Lote nao pertence a nota.")
		_oSayInfo:CtrlRefresh()	
	EndIf
	
	MsgAlert("Lote nao pertence a nota.","INOVEN - Avisos")
	
	RestArea(aArea)
	Return .F.
EndIf

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO, " + CRLF
cQuery += "		B1.B1_DESC, " + CRLF
cQuery += "		ZZA.ZZA_PALLET, " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT, " + CRLF
cQuery += "		ZZA.ZZA_QUANT, " + CRLF
cQuery += "		ZZA.ZZA_PALLET, " + CRLF
cQuery += "		ZZA.ZZA_BAIXA, " + CRLF 
cQuery += "		ZZA.ZZA_NUMCX, " + CRLF
cQuery += "		ZZA.ZZA_NUMNF, " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF  
cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = ZZA.ZZA_CODPRO AND B1.D_E_L_E_T_ = '' " + CRLF
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL  = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODBAR = '" + cCodBar + "' AND " + CRLF
If !lEtqAnt
	cQuery += "		ZZA.ZZA_NUMNF = '" + cNFEtq + "' AND " + CRLF
EndIf	
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMCX = '" + cNumCx + "' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//-----------------------+
// Pallet não encontrado | 
//-----------------------+
If (cAlias)->( Eof() )
	//--------------------+
	// Encerra temporario |
	//--------------------+
	(cAlias)->( dbCloseArea() )
	lCaixa := .F.	
	RestArea(aArea)
	Return .F.
EndIf

//------------------------+
// Conferencia por Pallet |
//------------------------+
While (cAlias)->( !Eof() )
	
	/*
	If lEtqAnt
		lContinua := .F. 
		If At( RTrim((cAlias)->ZZA_NUMNF), cEtiqueta) > 0
			lContinua := .T.
		EndIf
	Else
		lContinua := .T.
	EndIf
	*/
	If (cAlias)->ZZA_BAIXA == "1" .And. lContinua
		//---------------------------------------+
		// Adiciona linha acols Itens conferidos |
		//---------------------------------------+
		If TFat03ItLido((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMCX,(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->ZZA_QUANT,(cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
			
			//----------------------+
			// Valida linha da nota |
			//----------------------+
			If TFat03ItNF((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMCX,(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->ZZA_QUANT, (cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
				//---------------------------------------+
				// Adiciona linha acols Itens conferidos |
				//---------------------------------------+
				TFat03ItConf((cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMCX,(cAlias)->ZZA_PALLET,(cAlias)->ZZA_NUMLOT,(cAlias)->ZZA_QUANT,(cAlias)->ZZA_ITEMNF,(cAlias)->ZZA_NUMNF)
			EndIf	
		EndIf
		lContinua 	:= .F.
		lEtqBaixa	:= .F.
	ElseIf (cAlias)->ZZA_BAIXA == "2" .And. lContinua
		lEtqBaixa	:= .T.
		lContinua	:= .T.
	EndIf
		
	(cAlias)->( dbSkip() )
EndDo

//----------------------------------+
// Valida se etique ja esta baixada | 
//----------------------------------+
If lEtqBaixa
	//-----------+
	// Emiti som | 
	//-----------+
	Tone()
	
	If _lExibErro               
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		MsgAlert("Etiqueta já baixada.","INOVEN - Avisos")
	Else                       
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText("Etiqueta já baixada.")
		_oSayInfo:CtrlRefresh()	
	EndIf
		
	//--------------------+
	// Encerra temporario |
	//--------------------+
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
Else
	_oBmpInfo:cResname := ""
	_oBmpInfo:LVISIBLE := .F.
	_oBmpInfo:Refresh()	
	_oSayInfo:SetText("")
	_oSayInfo:CtrlRefresh()
EndIf

//--------------------+
// Encerra temporario |
//--------------------+
(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat03ItConf

@description Insere itens conferidos

@author Bernard M. Margarido
@since 04/07/2018
@version 1.0

@param cCodPro		, characters, descricao
@param cDescPrd		, characters, descricao
@param cNumCx		, characters, descricao
@param cCodPallet	, characters, descricao
@param cNumLote		, characters, descricao
@param nQtdConf		, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFat03ItConf(cCodPro,cDescPrd,cNumCx,cCodPallet,cNumLote,nQtdConf,cItemNF,cNFEtq)
Local aArea		:= GetArea()

Local nPItem	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "ITECONF"})
Local nPProd	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PRDCONF"})
Local nPDesc	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "DESCONF"})
Local nPQtd		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "QTDCONF"})
Local nPCaixa	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "NCXCONF"})
Local nPPallet	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PALCONF"})
Local nPLote	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "LOTCONF"})
Local nPItemNf	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "ITNCONF"})
Local nPNFEtq	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "NFECONF"})

//---------------+
// Primeiro Item |
//---------------+
If Len(oGetItConf:aCols) <= 1 .And. Empty(oGetItConf:aCols[1][nPProd])

	oGetItConf:aCols[Len(oGetItConf:aCols)][nPItem]				:= "0001"
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPProd]				:= cCodPro
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPDesc]				:= cDescPrd
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPQtd]				:= nQtdConf
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPCaixa]			:= cNumCx
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPPallet]			:= cCodPallet
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPLote]				:= cNumLote
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPItemNf]			:= cItemNF
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPNFEtq]			:= cNFEtq
	
Else
	aAdd(oGetItConf:aCols,Array(Len(oGetItConf:aHeader)+1)) 
	
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPItem]				:= StrZero(Len(oGetItConf:aCols),4)
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPProd]				:= cCodPro
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPDesc]				:= cDescPrd
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPQtd]				:= nQtdConf
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPCaixa]			:= cNumCx
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPPallet]			:= cCodPallet
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPLote]				:= cNumLote
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPItemNf]			:= cItemNF
	oGetItConf:aCols[Len(oGetItConf:aCols)][nPNFEtq]			:= cNFEtq
	
	oGetItConf:aCols[Len(oGetItConf:aCols)][Len(oGetItConf:aHeader)+1]	:= .F.
EndIf

//-----------------+
// Ordena Por item | 
//-----------------+
aColsConf := {}	
aColsConf := aClone(oGetItConf:aCols)

oGetItConf:GoBottom()
oGetItConf:Refresh()

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat03ItNF

@description Atualiza Linhas da Nota Fiscal 

@author Bernard M. Margarido
@since 04/07/2018
@version 1.0

@param cCodPro		, characters, descricao
@param cDescPrd		, characters, descricao
@param cNumCx		, characters, descricao
@param cCodPallet	, characters, descricao
@param cNumLote		, characters, descricao
@param nQtdConf		, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFat03ItNF(cCodPro,cDescPrd,cNumCx,cCodPallet,cNumLote,nQtdConf,cItemNF)
Local aArea		:= GetArea()

Local cMsg		:= ""

//Local nPItem	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2ITEM"})
Local nPProd	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2PROD"})
//Local nPDesc	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2DESC"})
Local nPQtd		:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2QTDV"})
Local nPQtdConf	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2QTDC"})
Local nPLote	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2LOTE"})
Local nPStatus	:= aScan(oGetNF:aHeader,{|x| Alltrim(x[2]) == "D2STAT"})	
Local nLin		:= 0
Local nTotIt	:= 0

Local lRet		:= .T.
Local lColor	:= .F.
Local lMsgConf	:= .F.

//---------------+
// Primeiro Item |
//---------------+
nLin := aScan(oGetNF:aCols,{|x| x[nPProd] + x[nPLote] == cCodPro + cNumLote})
If nLin > 0
	
	nTotIt	:= oGetNF:aCols[nLin][nPQtdConf] + nQtdConf
	
	If nTotIt > oGetNF:aCols[nLin][nPQtd]
		cMsg := "Item já conferido."
		lMsgConf	:= .T.
		lRet 		:= .F.
	ElseIf nTotIt == oGetNF:aCols[nLin][nPQtd]
		oGetNF:aCols[nLin][nPQtdConf]		:= nTotIt
		oGetNF:aCols[nLin][nPStatus]		:= "2"
		lColor								:= .T.
	ElseIf nTotIt < oGetNF:aCols[nLin][nPQtd]	
		oGetNF:aCols[nLin][nPQtdConf] := nTotIt
	EndIf
Else
	cMsg := "Item não pertence a nota."
	lRet := .F.
EndIf

If !Empty(cMsg)
	//-----------+
	// Emiti som | 
	//-----------+
	Tone()       
	If _lExibErro
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		ApMsgAlert(cMsg,"INOVEN - Avisos")
		
		//----------------------------------------+
		// Exibe a mensagem para itens conferidos | 
		//----------------------------------------+
	ElseIf !_lExibErro .And. lMsgConf
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		_nClick := 0
		While _nClick < 5
			_nOpcA := Aviso("INOVEN - Avisos",cMsg,{"Ok"})
			If _nOpcA == 1
				_nClick++
			EndIf
		EndDo		
		//ApMsgAlert(cMsg,"INOVEN - Avisos")
		//Aviso("INOVEN - Avisos",cMsg,{"Ok"},,"Item conferido a maior", /*nRotAutDefault*/,/*cBitmap*/,/*lEdit*/,1000,1)
		
	ElseIF !_lExibErro .And. !lMsgConf
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText(cMsg)
		_oSayInfo:CtrlRefresh()	
	EndIf		
Else
	_oBmpInfo:cResname := ""
	_oBmpInfo:LVISIBLE := .F.
	_oBmpInfo:Refresh()	 
	_oSayInfo:SetText("")
	_oSayInfo:CtrlRefresh()	
EndIf

aColsNF := aClone(oGetNF:aCols)
oGetNF:Refresh()

If lColor
	TFatA03Color()
EndIf

RestArea(aArea)
Return lRet 

/*******************************************************************************************/
/*/{Protheus.doc} TFat03ItLido

@description Valida se etiqueta já foi lida

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@param cCodPro		, characters, descricao
@param cDescPrd		, characters, descricao
@param cNumCx		, characters, descricao
@param cCodPallet	, characters, descricao
@param cNumLote		, characters, descricao
@param nQtdConf		, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFat03ItLido(cCodPro,cDescPrd,cNumCx,cCodPallet,cNumLote,nQtdConf,cItemNF,cNFEtq)
Local aArea		:= GetArea()

Local cMsg		:= ""

//Local nPItem	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "ITECONF"})
Local nPProd	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PRDCONF"})
//Local nPDesc	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "DESCONF"})
//Local nPQtd		:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "QTDCONF"})
Local nPCaixa	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "NCXCONF"})
Local nPPallet	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "PALCONF"})
//Local nPLote	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "LOTCONF"})
Local nPItemNf	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "ITNCONF"})
Local nPNFEtq	:= aScan(oGetItConf:aHeader,{|x| Alltrim(x[2]) == "NFECONF"})
Local nLin		:= 0

Local lRet		:= .T.

//------------------------------------+
// Valida se etiqueta Pallet foi lida |
//------------------------------------+
If Empty(cNumCx)
	
	nLin := aScan(oGetItConf:aCols,{|x| x[nPProd] + x[nPPallet] == cCodPro + cCodPallet})
	If nLin > 0
		If Empty(oGetItConf:aCols[nLin][nPCaixa])
			cMsg := "Etiqueta Pallet já lida."
		Else
			cMsg := "Pallet desmontado."
		EndIf	
		lRet := .F.
	EndIf
//-----------------------------------+
// Valida se etiqueta Caixa foi lida |
//-----------------------------------+
Else
	//-------------------------------------------------+
	// Valida se etiqueta pertence a um pallet já lido |
	//-------------------------------------------------+
	If aScan(oGetItConf:aCols,{|x| x[nPProd] + Padr(x[nPCaixa],TamSx3("ZZA_NUMCX")[1]) + x[nPPallet] + x[nPItemNf] + x[nPNFEtq] == cCodPro + Padr("",TamSx3("ZZA_NUMCX")[1]) + cCodPallet + cItemNF + cNFEtq}) > 0
		cMsg := "Etiqueta pertence a etiqueta pallet já lida."
		lRet := .F.
	EndIf
	
	//-----------------------------------+
	// Valida se etiqueta Caixa foi lida |
	//-----------------------------------+
	If aScan(oGetItConf:aCols,{|x| x[nPProd] + x[nPCaixa] + x[nPPallet] + x[nPItemNf] + x[nPNFEtq] == cCodPro + cNumCx + cCodPallet + cItemNF + cNFEtq }) > 0
		cMsg := "Etiqueta Caixa já lida."
		lRet := .F.
	EndIf
EndIf

If !Empty(cMsg)
	//-----------+
	// Emiti som | 
	//-----------+
	Tone()	
	If _lExibErro
		_oBmpInfo:cResname := ""
		_oBmpInfo:LVISIBLE := .F.
		_oBmpInfo:Refresh()	 
		_oSayInfo:SetText("")
		_oSayInfo:CtrlRefresh()	
		ApMsgAlert(cMsg,"INOVEN - Avisos")
	Else
		_oBmpInfo:cResname := "UPDERROR"
		_oBmpInfo:LVISIBLE := .T.
		_oBmpInfo:Refresh()		
		_oSayInfo:SetText(cMsg)
		_oSayInfo:CtrlRefresh()	
	EndIf
EndIf

RestArea(aArea)
Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03NF

@description Cria aCols com os Itens da Nota

@author Bernard M. Margarido
@since 19/04/2018
@version 1.0
@param cNota	, characters, descricao
@param cSerie	, characters, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatA03NF(cNota,cSerie,cCliente,cLoja)
Local aArea		:= GetArea()

Local _nPProd	:= 0
Local nX

//------------------+
// Reseta variaveis |
//------------------+
aHeadNF		:= {}
aColsNF		:= {}
aAlterNF	:= {}

//aAdd(aHeadNF,{"Item"			,"D2ITEM"	,PesqPict("SD2","D2_ITEM")		,TamSx3("D2_ITEM")[1]	, 0							,".T."			,"û","C",""," ","","",".F." } )
aAdd(aHeadNF,{"Produto"			,"D2PROD"	,PesqPict("SD2","D2_COD")		,TamSx3("D2_COD")[1]	, 0							,".T."			,"û","C",""," ","","",".F." } )
aAdd(aHeadNF,{"Descricao"		,"D2DESC"	,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	, 0							,".T."			,"û","C",""," ","","",".F." } )
aAdd(aHeadNF,{"Quantidade"		,"D2QTDV"	,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT")[1]	, TamSx3("D2_QUANT")[2]		,".T."			,"û","N",""," ","","",".F." } )
aAdd(aHeadNF,{"Qtd. Conf."		,"D2QTDC"	,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT")[1]	, TamSx3("D2_QUANT")[2]		,".T."			,"û","N",""," ","","",".F." } )
aAdd(aHeadNF,{"Lote"			,"D2LOTE"	,PesqPict("SD2","D2_LOTECTL")	,TamSx3("D2_LOTECTL")[1], TamSx3("D2_LOTECTL")[2]	,".T."			,"û","C",""," ","","",".F." } )
aAdd(aHeadNF,{"Status"			,"D2STAT"	,PesqPict("SD2","D2_COD")		,TamSx3("D2_TIPO")[1]	, TamSx3("D2_TIPO")[2]		,".T."			,"û","C",""," ","1=Nao Conferido;2=Conferido","1",".F."} )

aAdd(aAlterNF,"D2QTDC")

dbSelectArea("SD2")
SD2->( dbSetOrder(3) )
If SD2->(dbSeek(xFilial("SD2") + cNota + cSerie + cCliente + cLoja) )
	While SD2->( !Eof() .And. xFilial("SD2") + cNota + cSerie + cCliente + cLoja == SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA )
		
		_nPProd := aScan(aColsNF,{|x| RTrim(x[1]) + RTrim(x[5]) == RTrim(SD2->D2_COD) + RTrim(SD2->D2_LOTECTL)})
		If _nPProd == 0
			aAdd(aColsNF,Array(Len(aHeadNF)+1))
			 
			//aColsNF[Len(aColsNF)][1] := SD2->D2_ITEM
			aColsNF[Len(aColsNF)][1] := SD2->D2_COD
			aColsNF[Len(aColsNF)][2] := Posicione("SB1",1,xFilial("SB1") + SD2->D2_COD,"B1_DESC")
			aColsNF[Len(aColsNF)][3] := SD2->D2_QUANT
			aColsNF[Len(aColsNF)][4] := 0
			aColsNF[Len(aColsNF)][5] := SD2->D2_LOTECTL	
			aColsNF[Len(aColsNF)][6] := "1"
			aColsNF[Len(aColsNF)][Len(aHeadNF)+1]:= .F.
		Else
			aColsNF[_nPProd][3] += SD2->D2_QUANT
		EndIf
		SD2->( dbSkip() )
	EndDo
EndIf

If Len(aColsNF) <= 0
	aAdd(aColsNF,Array(Len(aHeadNF)+1)) 
	For nX:= 1 To Len(aHeadNF)
		aColsNF[1][nX]:= CriaVar(aHeadNF[nX][2],.T.)
	Next nX
	aColsNF[1][Len(aHeadNF)+1]:= .F.
EndIf

//------------------+
// Ordena por Itens |
//------------------+
aSort(aColsNF,,,{|x,y| x[1] < y[1]})

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03CF

@description Cria aCols com os Itens Conferidos

@author Bernard M. Margarido
@since 19/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03CF(cNota,cSerie,cCliente,cLoja)
Local aArea	:= GetArea()

//------------------+
// Reseta variaveis |
//------------------+
aHeadConf	:= {}
aColsConf	:= {} 

aAdd(aHeadConf,{"Item"			,"ITECONF"	,PesqPict("SD1","D1_ITEM")		,TamSx3("D1_ITEM")[1]	, 0							,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Produto"		,"PRDCONF"	,PesqPict("SD2","D2_COD")		,TamSx3("D2_COD")[1]	, 0							,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Descricao"		,"DESCONF"	,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	, 0							,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Qtd.Lida"		,"QTDCONF"	,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT")[1]	, TamSx3("D2_QUANT")[2]		,".T."			,"û","N",""," ","","" } )
aAdd(aHeadConf,{"Num. Caixa"	,"NCXCONF"	,PesqPict("ZZA","ZZA_NUMCX")	,TamSx3("ZZA_NUMCX")[1]	, TamSx3("ZZA_NUMCX")[2]	,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Num. Pallet"	,"PALCONF"	,PesqPict("ZZA","ZZA_PALLET")	,TamSx3("ZZA_PALLET")[1], TamSx3("ZZA_PALLET")[2]	,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Lote"			,"LOTCONF"	,PesqPict("SD2","D2_LOTECTL")	,TamSx3("D2_LOTECTL")[1], TamSx3("D2_LOTECTL")[2]	,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Item NF"		,"ITNCONF"	,PesqPict("SD1","D1_ITEM")		,TamSx3("D1_ITEM")[1]	, TamSx3("D1_ITEM")[2]		,".T."			,"û","C",""," ","","" } )
aAdd(aHeadConf,{"Nota Etq."		,"NFECONF"	,PesqPict("SD1","D1_DOC")		,TamSx3("D1_DOC")[1]	, 0							,".T."			,"û","C",""," ","","" } )

//----------------------------+
// Valida se nota já foi lida |
//----------------------------+
TFatA03Conf(cNota,cSerie,cCliente,cLoja,@aColsConf)

If Len(aColsConf) <= 0
	aAdd(aColsConf,Array(Len(aHeadConf)+1)) 
	aColsConf[Len(aColsConf)][1]				:= "0001"
	aColsConf[Len(aColsConf)][2]				:= ""
	aColsConf[Len(aColsConf)][3]				:= ""
	aColsConf[Len(aColsConf)][4]				:= 0
	aColsConf[Len(aColsConf)][5]				:= ""
	aColsConf[Len(aColsConf)][6]				:= ""
	aColsConf[Len(aColsConf)][7]				:= ""
	aColsConf[Len(aColsConf)][8]				:= ""
	aColsConf[Len(aColsConf)][9]				:= ""
	aColsConf[Len(aColsConf)][Len(aHeadConf)+1]	:= .F.
EndIf

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Conf

@description Valida se já existem itens conferidos 

@author Bernard M. Margarido
@since 10/08/2018
@version 1.0

@param aColsConf	, array, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Conf(cNota,cSerie,cCliente,cLoja,aColsConf)
Local aArea	:= GetArea()

Local nItem	:= 1

Local nPQtdV:= aScan(aHeadNF,{|x| Alltrim(x[2]) == Alltrim("D2QTDV") })
Local nPQtdC:= aScan(aHeadNF,{|x| Alltrim(x[2]) == Alltrim("D2QTDC") })
Local nPProd:= aScan(aHeadNF,{|x| Alltrim(x[2]) == Alltrim("D2PROD") })
Local nPLote:= aScan(aHeadNF,{|x| Alltrim(x[2]) == Alltrim("D2LOTE") })
Local nPStat:= aScan(aHeadNF,{|x| Alltrim(x[2]) == Alltrim("D2STAT") })

//-------------------------+
// Posiciona Itens da Nota |
//-------------------------+
dbSelectArea("SD2")
SD2->( dbSetOrder(3) )
If SD2->( dbSeek(xFilial("SD2") + cNota + cSerie + cCliente + cLoja ) )
	//--------------------+
	// Posiciona Etiqueta | 
	//--------------------+
	dbSelectArea("ZZA")
	ZZA->( dbSetOrder(3) )
	
	While SD2->( !Eof() .And. xFilial("SD2") + cNota + cSerie + cCliente + cLoja == SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA ) )
		If ZZA->( dbSeek(xFilial("ZZA") + SD2->D2_COD + SD2->D2_LOTECTL + SD2->D2_DOC + SD2->D2_SERIE) )
			While ZZA->( !Eof() .And. xFilial("ZZA") + SD2->D2_COD + SD2->D2_LOTECTL + SD2->D2_DOC + SD2->D2_SERIE == ZZA->(ZZA_FILIAL + ZZA_CODPRO + ZZA_NUMLOT + ZZA_NFSAID + ZZA_SERSAI) )
				
				nPosNf := aScan(aColsNF,{|x| Alltrim(x[nPProd]) + Alltrim(x[nPLote]) == AllTrim(ZZA->ZZA_CODPRO) + Alltrim(ZZA->ZZA_NUMLOT) })
				 
				aAdd(aColsConf,Array(Len(aHeadConf)+1)) 
				aColsConf[Len(aColsConf)][1]				:= StrZero(nItem,4)
				aColsConf[Len(aColsConf)][2]				:= ZZA->ZZA_CODPRO
				aColsConf[Len(aColsConf)][3]				:= Posicione("SB1",1,xFilial("SB1") + ZZA->ZZA_CODPRO,"B1_DESC")
				aColsConf[Len(aColsConf)][4]				:= 1
				aColsConf[Len(aColsConf)][5]				:= PadL(ZZA->ZZA_NUMCX,4,"0")
				aColsConf[Len(aColsConf)][6]				:= ZZA->ZZA_PALLET
				aColsConf[Len(aColsConf)][7]				:= ZZA->ZZA_NUMLOT
				aColsConf[Len(aColsConf)][8]				:= ZZA->ZZA_ITEMNF
				aColsConf[Len(aColsConf)][9]				:= ZZA->ZZA_NUMNF
				aColsConf[Len(aColsConf)][Len(aHeadConf)+1]	:= .F.

				If nPosNf > 0
					aColsNF[nPosNf][nPQtdC] := aColsNF[nPosNf][nPQtdC] + 1
					If aColsNF[nPosNf][nPQtdC] == aColsNF[nPosNf][nPQtdV]
						aColsNF[nPosNf][nPStat] := "2"
					EndIf  
				EndIf

				nItem++
				
				ZZA->( dbSkip() )
			EndDo
		EndIf
		SD2->( dbSkip() )
	EndDo
	
	//-----------------------------+
	// Atualiza Grid Itens da Nota |
	//-----------------------------+
	If ValType(oGetNF) == "O" 	
		oGetNF:Refresh()
		TFatA03Color()
	EndIf	
	
EndIf

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA040xPl

@description Realiza a baixa da Etiqueta Pallet

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@param cCodProd		, characters, descricao
@param cCodPallet	, characters, descricao

@type function
/*/
/*******************************************************************************************/
Static Function IEXPA040xPl(cCodProd,cNumCx,cLote,cPallet,cNota,cSerie)
Local aArea	:= GetArea()

Local cAlias:= GetNextAlias()
Local cQuery:= ""

cQuery := "	SELECT " + CRLF
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF  
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL  = '" + xFilial("ZZA") + "' AND " + CRLF  
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.ZZA_PALLET = '" + cPallet + "' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' " 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea("ZZA")
ZZA->( dbSetOrder(1) )
While (cAlias)->(!Eof() )
	ZZA->( dbGoTo((cAlias)->RECNOZZA) )
	RecLock("ZZA",.F.)
		ZZA->ZZA_BAIXA := "2"
		ZZA->ZZA_NFSAID:= cNota
		ZZA->ZZA_SERSAI:= cSerie
	ZZA->( MsUnLock() )	
	(cAlias)->( dbSkip() )
EndDo

(cAlias)->( dbCloseArea() )

RestArea(aArea)	
Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA040xCx

@description Realiza a baixa das etiquetas

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@param cNota	, characters, descricao
@param cSerie	, characters, descricao
@param cCodProd	, characters, descricao
@param cNumCx	, characters, descricao
@type function
/*/
/*******************************************************************************************/
Static Function IEXPA040xCx(cCodProd,cNumCx,cLote,cPallet,cNota,cSerie)
Local aArea	:= GetArea()

Local cAlias:= GetNextAlias()
Local cQuery:= ""

cQuery := "	SELECT " + CRLF
cQuery += "		MIN(ZZA.ZZA_ITEMNF) ZZA_ITEMNF, " + CRLF
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF  
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL  = '" + xFilial("ZZA") + "' AND " + CRLF  
cQuery += "		ZZA.ZZA_NUMCX = '" + cNumCx + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.ZZA_PALLET = '" + cPallet + "' AND " + CRLF
cQuery += "		ZZA.ZZA_BAIXA = '1' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY ZZA.R_E_C_N_O_ "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

dbSelectArea("ZZA")
ZZA->( dbSetOrder(1) )

If (cAlias)->( !Eof() )
//While (cAlias)->( !Eof() )
	ZZA->( dbGoTo((cAlias)->RECNOZZA) )
	RecLock("ZZA",.F.)
		ZZA->ZZA_BAIXA := "2"
		ZZA->ZZA_NFSAID:= cNota
		ZZA->ZZA_SERSAI:= cSerie
	ZZA->( MsUnLock() )	
//	(cAlias)->( dbSkip() )
//EndDo
EndIf

(cAlias)->( dbCloseArea() )

RestArea(aArea)	
Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Color

@description Valida linha conferida 

@author Bernard M. Margarido
@since 07/05/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Color()

Local bColorList	:= &("{|| TFatACorBrw(@aCorRgb) }") 

oGetNF:oBrowse:SetBlkBackColor(bColorList)
oGetNF:GoTop()
oGetNF:Refresh()

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatACorBrw

@description Altera a Cor da Linha do Browser

@author Bernard M. Margarido
@since 13/04/2018
@version 1.0

@param aCorGrd	, array, descricao
@param nOrig	, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatACorBrw(aCorRgb)
Local nPStatus	:= aScan(aHeadNF,{|x| Alltrim(x[2]) == "D2STAT" })
Local nLin		:= oGetNF:nAt

If oGetNF:aCols[nLin][Len(oGetNF:aHeader) + 1]
	//-----------------------+
	// Cinza quando Deletado |
	//-----------------------+
	Return(Rgb(181,181,181))
ElseIf oGetNF:aCols[nLin][nPStatus] == "2"
	//----------------+
	// Item Conferido |
	//---------------=+
	Return aCorRgb[3,1] 
EndIf

Return aCorRgb[2,1]

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA030Siz

@description Retorna coordernada para objeto em tela

@author Bernard M. Margarido
@since 29/06/2018
@version 1.0

@param nPerc	, numeric, descricao
@param oBj		, object, descricao
@type function
/*/
/*******************************************************************************************/
Static Function IEXPA030Siz(nPerc,oBj,nTipo)
Local aDimensao	:= FWGetDialogSize(oBj)
Local nSIze		:= 0
//-------+
// Linha |
//-------+
If nTipo == 1
	nSize := (aDimensao[3] * nPerc) /200
//--------+
// Coluna |
//--------+	
Else
	nSize := (aDimensao[4] * nPerc) /200
EndIf	
Return INT(nSize)

/*******************************************************************************************/
/*/{Protheus.doc} TFat03VLote(cLote)
	@description valida se lote pertence a nota 
	@type  Static Function
	@author Bernard M. Margarido
	@since 28/06/2020
/*/
/*******************************************************************************************/
Static Function TFat03VLote(cCodProd,cLote)
Local _lRet		:= .T.

Local _nPProd	:= aScan(oGetNF:aHeader,{|x| RTrim(x[2]) == "D2PROD"})
Local _nPLote	:= aScan(oGetNF:aHeader,{|x| RTrim(x[2]) == "D2LOTE"})

If aScan(oGetNF:aCols,{|x| RTrim(x[_nPProd]) + RTrim(x[_nPLote]) == RTrim(cCodProd) + RTrim(cLote)}) == 0
	_lRet	:= .F.
EndIf

Return _lRet

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA030Lck

@description Cria arquivo semaforo

@author Bernard M. Margarido
@since 19/08/2018
@version 1.0

@param cArqLock	, characters, descricao
@param nTpArq	, numeric	, descricao
@type function
/*/
/*******************************************************************************************/
Static Function IEXPA030Lck(cArqLock,nTpArq)
Local lRet		:= .T.
Local cDir		:= GetPathSemaforo()
Local cUserArq	:= ""
Local cCompArq	:= ""

	If nTpArq == 1
		//--------------+
		// Cria Arquivo |
		//--------------+
		If File(cDir + cArqLock)
			//-------------------------------+
			// Criar Buffer para ler arquivo |
			//-------------------------------+
			xBuffer := Space(200)
			nHdlLock := FOpen(cDir + cArqLock,16)
			If nHdlLock > 0 
				FRead(nHdlLock,@xBuffer,Len(xBuffer))
				//----------------------------------------+	
				// Usuário e Computador que orifinou LOCK |
				//----------------------------------------+
				cUserArq := SubStr(xBuffer,1,At("|",xBuffer) - 1)	
				cCompArq := SubStr(xBuffer,At("|",xBuffer) + 1)
				//----------------------------------------------------+
				// Valida se usuário e computador são os mesmos       |		
				// caso ocorra queda do sistema o arquivo fica locado |
				//----------------------------------------------------+
				If Alltrim(cUserName) == Alltrim(cUserArq) .And. Alltrim(cCompArq) == Alltrim(GetComputerName())
					lRet := .T.
					//----------------+
					// Deleta Arquivo | 
					//----------------+
					Fclose(nHdlLock)
					Ferase(cDir + cArqLock)
					//--------------+
					// Cria arquivo |
					//--------------+
					IEXPA030Lck(cArqLock,1)
				Else
					MsgAlert("Nota esta em conferencia pelo Operador " + cUserArq + " Computador " + cCompArq)
					Fclose(nHdlLock)
					Return .F.
				EndIf	
			EndIf	
		Else
			nHdlLock := fCreate(cDir + cArqLock)
			FWrite(nHdlLock,cUserName + "|" + GetComputerName() )
			Fclose(nHdlLock)
		EndIf	
	Else
		If File(cDir + cArqLock)
			Fclose(nHdlLock)
			Ferase(cDir + cArqLock)
		EndIf	
	EndIf	
Return lRet
