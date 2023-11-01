#INCLUDE "FWBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE MAXGETDAD 99999
#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE CLR_CINZA RGB(230,230,230)

/**********************************************************************************************/
/*/{Protheus.doc} IEXPA040

@description Monta Tela de conferencia 

@author Bernard M. Margarido
@since 18/04/2018
@version 1.0

@type function
/*/
/**********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPA040(_nRecno)
Local aArea			:= GetArea()
Local aSize 		:= MsAdvSize()
Local aObjects 		:= {}
Local aPosObj  		:= {}
Local aPosGet		:= {}
Local aButtons		:= {}
Local aCpos			:= {}

Local cCadastro 	:= "INOVEN - Expedição"

Local nOpcA			:= 0

Local bColorList	:= &("{|| TFatACorBrw(@aCorRgb,1) }")
Local bLinOk		:= {|| u_TFat03ALOk()}
Local bPrint		:= {|| IIF(oGetDad:aCols[oGetDad:nAt][12] == "3",u_IEXPR030(oGetDad:aCols[oGetDad:nAt][1],oGetDad:aCols[oGetDad:nAt][2]),MsgInfo("Imprimir somente notas já expedidas.","INOVEN - Avisos"))}
			
Local oDlg			:= Nil
Local oFwLayer		:= Nil
Local oPanel1		:= Nil
Local oPanel2		:= Nil
Local oBmpC1		:= Nil
Local oSayC1 		:= Nil
Local oBmpC2		:= Nil
Local oSayC2 		:= Nil
Local oBmpC3		:= Nil
Local oSayC3 		:= Nil
Local oEncRom		:= Nil

Private bConf		:= {|| TFatA03Conf()}

Private oGrpDest 	:= Nil

Private oGetDad		:= Nil

Private aHeader		:= {}
Private aCols		:= {}
Private aCorRgb		:= {{ Rgb(255,99,71)	, Nil , 'Tomato'	} 	,; 
						{ Rgb(255,250,250)	, Nil , 'Snow' 		} 	,;
						{ Rgb(152,251,152)	, Nil , 'PaleGreen'	}	,;
						{ Rgb(255,255,0)	, Nil , 'Yellow'	} }

Private aTela[0][0]
Private aGets[0]

//-----------------------------------------+
// Coordenadas da Tela, conforme resolução |
//-----------------------------------------+ 
aAdd( aObjects, { 100, 100, .T., .T. } )
aAdd( aObjects, { 315,  70, .T., .T. } )

aInfo	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects, .F. )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{ 	{1.4,45,310.4}			,;	// Itens do Romaneio - MsGetDados
												{3.5,0.5,5.2}			,;	// Legendas Clientes	
												{48.3,10,48}			})	// Descrição Legendas

//------------------+
// Campos editaveis |
//------------------+
aAdd(aCpos,"ZZD_MOTORI")
aAdd(aCpos,"ZZD_CNH")
aAdd(aCpos,"ZZD_DESCMO")
aAdd(aCpos,"ZZD_CONFE")
aAdd(aCpos,"ZZD_PLACA")
aAdd(aCpos,"ZZD_DTENTR")
aAdd(aCpos,"ZZD_HRENTR")
aAdd(aCpos,"ZZD_DTSAID")
aAdd(aCpos,"ZZD_HRSAID")

//-----------------------------+
// Carrega Tela de Conferencia | 
//-----------------------------+
aAdd(aButtons,{	''	,{|| Eval(bConf) }		, "Conf. Nota Fiscal [F5]"} )
aAdd(aButtons,{	''	,{|| Eval(bPrint) }		, "Reimprime Etiqueta Volumes [F6]"} )

//-----------------------+
// Cria Teclas de Atalho |
//-----------------------+
SetKey( VK_F5 , bConf )
SetKey( VK_F6 , bPrint )

//--------------------+
// Posiciona Romaneio |
//--------------------+
dbSelectArea("ZZD")
ZZD->( dbGoTo(_nRecno) )

//---------------------------------------+
// Valida se romaneio nao está encerrado |
//---------------------------------------+
If ZZD->ZZD_STATUS == "3"
	MsgAlert(" Romaneio " + ZZD->ZZD_CODIGO +  " encerrado.","INOVEN - Avisos")
	Return .T.
EndIf

//------------+
// Cria aCols |
//------------+
TFatA03Head()

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL STYLE DS_MODALFRAME //STYLE nOr(WS_VISIBLE,WS_POPUP)

oDlg:lMaximized := .T.

//---------------------------------+
// Carrega as variaveis em Memória |
//---------------------------------+
RegToMemory("ZZD", .F. )
M->ZZD_CONFE := cUserName

//--------------+
// Painel Layer |
//--------------+
oFwLayer := FwLayer():New()
oFwLayer:Init(oDlg,.F.)

//------------+
// 1o. Painel |   
//------------+
oFWLayer:addLine("CABECOPV",045, .T.)
oFWLayer:addCollumn( "COLCABPV",100, .T. , "CABECOPV")
oFWLayer:addWindow( "COLCABPV", "WINENT", "Romaneio Saida", 100, .F., .F., , "CABECOPV") 
oPanel1 := oFWLayer:GetWinPanel("COLCABPV","WINENT","CABECOPV")

//-------------------+
// Dados do Romaneio |
//-------------------+
oEncRom := 	MsMGet():New("ZZD", ZZD->( Recno() ), 4 , , , , , {aPosObj[1,2],aPosObj[1,2],aPosObj[1,3] - 55,aPosObj[1,4] - 8}, aCpos, , , , , oPanel1,,.T.,,,,,,,,,,.T.)

//----------------+
// Dados Romaneio |
//----------------+
//TFatA03MsGet(_nRecno,aPosObj,oPanel1)

//------------+
// 2o. Painel |   
//------------+
oFWLayer:addLine("ITPVECO",045, .T.)
oFWLayer:addCollumn( "COLITPVECO",100, .T. , "ITPVECO")
oFWLayer:addWindow( "COLITPVECO", "WINENT", "Notas Fiscais", 100, .F., .F., , "ITPVECO") 
oPanel2 := oFWLayer:GetWinPanel("COLITPVECO","WINENT","ITPVECO")

//----------------------------------+
// Criacao da GetDados Itens Pedido |
//----------------------------------+
oGetDad 	:= MsNewGetDados():New(aPosGet[1,1] - 2 ,aPosGet[1,1] - 2,aPosGet[1,2] ,aPosGet[1,3] + 5 ,0,bLinOk,/*bTudoOk*/,/*cIniCpos*/,/*aAlterGda*/,/*nFreeze*/,MAXGETDAD,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oPanel2,aHeader,aCols)
oGetDad:oBrowse:SetBlkBackColor(bColorList)

//---------+
// Legenda |
//---------+
oBmpC1		:= TBitmap():New( aPosGet[2,1], aPosGet[2,2], 015, 015, "PMSTASK4.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
oSayC1 		:= TSay():New( aPosGet[3,1], aPosGet[3,2], {|| "Conferido" } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )

oBmpC2		:= TBitmap():New( aPosGet[2,1], aPosGet[2,2] + 6, 015, 015, "PMSTASK2.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
oSayC2 		:= TSay():New( aPosGet[3,1], aPosGet[3,2] + 050, {|| "Em Conferencia" } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )

oBmpC3		:= TBitmap():New( aPosGet[2,1], aPosGet[2,2] + 15, 015, 015, "PMSTASK1.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
oSayC3 		:= TSay():New( aPosGet[3,1], aPosGet[3,2] + 120, {|| "Não Conferido" } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )

	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {||nOpca := 1,IIF(u_TFat03TdOk(),(nOpcA := 1,oDlg:End()),nOpcA := 0) } , {|| oDlg:End() },,aButtons )

//--------------------------------+
// Realiza a gravação do Romaneio | 
//--------------------------------+
If nOpcA == 1
	TFatA03Grv()
EndIf

//-----------------------------------------+
// Retorna o Backup das Teclas de Funcoes  |
//-----------------------------------------+
SetKey(VK_F5,{|| Nil })
SetKey(VK_F6,{|| Nil })

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Grv

@description Realiza o encerramento do romaneio

@author Bernard M. Margarido
@since 08/05/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Grv()
Local aArea := GetArea()

Local nX	:= 1

//-------------------------+
// Atualiza dados Enchoice |
//-------------------------+
dbSelectArea("ZZD")
RecLock("ZZD",.F.)
	For nX := 1 To fCount()
		IF FieldName(nX) # 'ZZD_FILIAL/ZZD_STATUS/ZZD_DTSAID/ZZD_HRSAID'
			FieldPut(nX, &('M->' + FieldName(nX)))
		EndIF
	Next nX
	ZZD->ZZD_FILIAL := xFilial("ZZD")
	ZZD->ZZD_STATUS	:= "3"
	ZZD->ZZD_HRSAID	:= Time()
	ZZD->ZZD_DTSAID	:= Date()
ZZD->( MsUnLock() )

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat03ALOk

@description Valida linha digitada no Acols 

@author Bernard M. Margarido
@since 17/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
User Function TFat03ALOk()
Local lRet		:= .T.
 
Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Conf

@description Chama rotina de Expedição

@author Bernard M. Margarido
@since 20/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Conf()
Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPLoja	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
//Local nPNCli	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOMCLI"})
//Local nPVlrNf	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLFNF"})
Local nPStatus	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_STATUS"})
Local nLin		:= oGetDad:nAt

Local cNota		:= oGetDad:aCols[nLin][nPNota]
Local cSerie	:= oGetDad:aCols[nLin][nPSerie]
Local cCliente	:= oGetDad:aCols[nLin][nPCliente]
Local cLoja		:= oGetDad:aCols[nLin][nPLoja]

//--------------------------------+
// Marca nota como em conferencia |
//--------------------------------+ 
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO + cNota + cSerie ) )

//---------------------------------+
// Valida se nota já foi conferida |
//---------------------------------+
If oGetDad:aCols[nLin][nPStatus] == "3" .Or. ZZE->ZZE_STATUS == "3" 
	MsgAlert("Nota " + cNota + " Serie " + cSerie + " já conferida.")
	Return .T.
EndIf

//--------------------------------+
// Marca nota como em conferencia |
//--------------------------------+
If ZZE->ZZE_STATUS <> "3"
	RecLock("ZZE",.F.)
		ZZE->ZZE_STATUS := "2"
	ZZE->( MsUnLock() )
EndIf	

//-----------------------------------------+
// Retorna o Backup das Teclas de Funcoes  |
//-----------------------------------------+
SetKey(VK_F5,{|| Nil })

//-------------------+
// Tela de Expedição |
//-------------------+
u_IEXPA030(ZZD->ZZD_CODIGO,cNota,cSerie,cCliente,cLoja)

//------------------------+
// Atualiza dados Browser |
//------------------------+
oGetDad:aCols[nLin][nPStatus]	:= ZZE->ZZE_STATUS
M->ZZE_STATUS := ZZE->ZZE_STATUS
oGetDad:oBrowse:SetBlkBackColor({|| TFatACorBrw(aCorRgb,1)})
oGetDad:Refresh()

//-----------------------+
// Cria Teclas de Atalho |
//-----------------------+
SetKey( VK_F5 , bConf )

Return .T.


/*******************************************************************************************/
/*/{Protheus.doc} TFatA03Head

@description Monta aHeader e aCols das Notas de Saida 

@author Bernard M. Margarido
@since 13/04/2018
@version 1.0


@type function
/*/
/*******************************************************************************************/
Static Function TFatA03Head()
Local aArea	:= GetArea()
Local nX

//---------------------+
// Grava aHeader Itens |   
//---------------------+
dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
If SX3->( dbSeek("ZZE") )
	While SX3->( !Eof() .And. SX3->X3_ARQUIVO == "ZZE" )
		If X3USO(X3_USADO)
			AAdd(aHeader,{	AllTrim(	X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT;
							})
			EndIf
			SX3->(dbSkip())
		EndDo	
	EndIf

	dbSelectArea("ZZE")
	ZZE->( dbSetOrder(1) )
	If ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO) )
		While ZZE->( !Eof() .And. xFilial("ZZE") + ZZD->ZZD_CODIGO == ZZE->( ZZE_FILIAL + ZZE_CODIGO) )
			aAdd(aCols,Array(Len(aHeader)+1)) 
			For nX:= 1 To Len(aHeader)
				aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
			Next nX
			aCols[Len(aCols)][Len(aHeader)+1]:= .F.
			ZZE->( dbSkip() )
		EndDo
	EndIf

	If Len(aCols) <= 0
		aAdd(aCols,Array(Len(aHeader)+1)) 
		For nX:= 1 To Len(aHeader)
			aCols[1][nX]:= CriaVar(aHeader[nX][2],.T.)
		Next nX
		aCols[1][Len(aHeader)+1]:= .F.
	EndIf

RestArea(aArea)
Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03MsGet

@description Monta MSGET 

@author Bernard M. Margarido
@since 18/08/2018
@version 1.0

@param _nRecnoZZD	, numeric	, descricao
@param aPosObj		, array		, descricao
@param oPanel1		, object	, descricao

@type function
/*/
/*******************************************************************************************/
Static Function TFatA03MsGet(_nRecnoZZD,aPosObj,oPanel1)
 
	oGrpDest 	:= TScrollBox():New(oPanel1,aPosObj[1,2] - 2 ,aPosObj[1,2] - 2 ,aPosObj[1,3] - 58,aPosObj[1,4] - 8,.T.,.T.,.T.)

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
Static Function TFatACorBrw(aCorRgb,nOrig)
Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
//Local nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
//Local nPLoja	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})

dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO + oGetDad:aCols[oGetDad:nAt][nPNota] + oGetDad:aCols[oGetDad:nAt][nPSerie] ) )

//----------------------------+
// Cores da Lista de Produtos |
//----------------------------+
If oGetDad:aCols[oGetDad:nAt][Len(oGetDad:aHeader)+1]
	//-----------------------+
	// Cinza quando Deletado |
	//-----------------------+
	Return(Rgb(181,181,181))
ElseIf ZZE->ZZE_STATUS == "1"
	//---------------+
	// Nao Conferido |
	//---------------+
	Return aCorRgb[1,1] 
ElseIf ZZE->ZZE_STATUS == "2"
	//----------------+
	// Em Conferencia |
	//----------------+
	Return aCorRgb[4,1]
ElseIf ZZE->ZZE_STATUS == "3"
	//-----------+
	// Conferido |
	//-----------+
	Return aCorRgb[3,1]	
ElseIf nOrig == 2
	//-----------+
	// Conferido |
	//-----------+
	Return aCorRgb[4,1]
EndIf

Return aCorRgb[2,1]
