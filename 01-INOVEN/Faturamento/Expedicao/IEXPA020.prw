#INCLUDE "FWBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE MAXGETDAD 99999
#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE CLR_CINZA RGB(230,230,230)

/**********************************************************************************************/
/*/{Protheus.doc} IEXPA020

@description Expedição de Mercadas

@author Bernard M. Margarido
@since 18/04/2018
@version 1.0

@type function
/*/
/**********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPA020()
Local aArea			:= GetArea() 

Local cPerg			:= "TFATA03   "

//-----------------+
// Cria Parametros | 
//-----------------+
CreateSX1(cPerg)

//--------------------+
// Tela de parametros |
//--------------------+
If Pergunte(cPerg,.T.)
	 FWMsgRun(, {|| TFatA03Exp() }, "INOVEN - Expedição", "Aguarde carregando romaneios..." )
EndIf

RestArea(aArea)	
Return Nil

/**********************************************************************************************/
/*/{Protheus.doc} TFatA03Exp

@description Carrega Romaneios

@author Bernard M. Margarido
@since 19/08/2018
@version 1.0

@type function
/*/
/**********************************************************************************************/
Static Function TFatA03Exp()
//Local aArea			:= GetArea()
Local aSize 		:= MsAdvSize()
//Local aObjects 		:= {}
//Local aPosObj  		:= {}
//Local aPosGet		:= {}
//Local aButtons		:= {}
//Local aCpos			:= {}

Local cCadastro 	:= "INOVEN - Expedição"

//Local nOpcA			:= 0
			
Local oDlg			:= Nil
Local oFwLayer		:= Nil
Local oBtnOk		:= Nil
Local oBtnCa		:= Nil

Private aExped		:= {}
Private aSeek		:= {}

Private _nRecno		:= 0

Private oGridExp	:= Nil
Private oPnlBtn		:= Nil
Private oPnlExp		:= Nil
Private oSay		:= Nil

//------------+
// Cria aCols |
//------------+
IEXPA20Arr()

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL STYLE DS_MODALFRAME

	oDlg:lMaximized := .T.
	oDlg:lEscClose	:= .F.
	
	//--------------+
	// Painel Layer |
	//--------------+
	oFwLayer := FwLayer():New()
	oFwLayer:Init(oDlg,.F.)
	
	//--------------------+
	// 1o. Painel FwLayer |   
	//--------------------+
	oFWLayer:addLine("CABEXP",100, .T.)
	oFWLayer:addCollumn( "COLEXP",100, .T. , "CABEXP")
	oFWLayer:addWindow( "COLEXP", "WINENT", "", 094, .F., .F., , "CABEXP") 
	oPnlExp:= oFWLayer:GetWinPanel("COLEXP","WINENT","CABEXP")

	//-------------------+
	// Array de pesquisa | 
	//-------------------+
	aAdd( 	aSeek, 	{ AllTrim("Romaneio")				,{{"","C",TamSx3("ZZD_CODIGO")[1],0,"Romaneio"		,"@!"}},1})
	
	//---------------------------------+
	// Cria Grid contendo os romaneios |
	//---------------------------------+
	DEFINE FWBROWSE oGridExp DATA ARRAY ARRAY aExped NO SEEK NO CONFIG NO REPORT NO LOCATE Of oPnlExp
		oGridExp:SetSeek(,aSeek)
		
		ADD LEGEND DATA { || aExped[oGridExp:At(),1] == '1' } COLOR "GREEN"		TITLE "Em Aberto" 		OF oGridExp
		ADD LEGEND DATA { || aExped[oGridExp:At(),1] == '2' } COLOR "YELLOW" 	TITLE "Em Conferencia" 	OF oGridExp
		ADD LEGEND DATA { || aExped[oGridExp:At(),1] == '3' } COLOR "RED" 		TITLE "Encerrado" 		OF oGridExp
		
		ADD COLUMN oColumn DATA { || aExped[oGridExp:At(),2] }	Title "Romaneio"		PICTURE PesqPict("ZZD","ZZD_CODIGO")	DOUBLECLICK { || TFatExpTOk(oGridExp:At()) } SIZE TamSx3("ZZD_CODIGO")[1]	Of oGridExp
		ADD COLUMN oColumn DATA { || aExped[oGridExp:At(),3] }	Title "Transportado"    PICTURE PesqPict("ZZD","ZZD_TRANSP")   	DOUBLECLICK { || TFatExpTOk(oGridExp:At()) } SIZE TamSx3("ZZD_TRANSP")[1]	Of oGridExp
		ADD COLUMN oColumn DATA { || aExped[oGridExp:At(),4] }	Title "Desc. Transp"   	PICTURE PesqPict("ZZD","ZZD_DESTRP")    DOUBLECLICK { || TFatExpTOk(oGridExp:At()) } SIZE TamSx3("ZZD_DESTRP")[1] 	Of oGridExp
	
	ACTIVATE FWBrowse oGridExp
	
	//-----------------------+
	// Painel para os Botoes | 
	//-----------------------+
	oPnlBtn := TPanel():New(000,000,"",oDlg,Nil,.T.,.F.,Nil,CLR_CINZA,000,022,.T.,.F.)
	oPnlBtn:Align := CONTROL_ALIGN_BOTTOM
				
	oBtnOk	:= TButton():New(002,530,OemToAnsi("Confirma")	,oPnlBtn,{|| TFatExpTOk(oGridExp:At()) } ,45,18,,,,.T.)
	oBtnPrt	:= TButton():New(002,580,OemToAnsi("Imprimir")	,oPnlBtn,{|| TFatPrtTOk(oGridExp:At()) } ,45,18,,,,.T.)
	oBtnCa	:= TButton():New(002,630,OemToAnsi("Sair")		,oPnlBtn,{|| oDlg:End() },45,18,,,,.T.) 
		
ACTIVATE MSDIALOG oDlg CENTERED		
 
Return .T.

/**********************************************************************************************/
/*/{Protheus.doc} TFatPrtTOk

@description Rotina de Reimpressão de Volumes

@author Bernard M. Margarido
@since 24/08/2018
@version 1.0

@param nLin	, numeric, descricao
@type function
/*/
/**********************************************************************************************/
Static Function TFatPrtTOk(nLin)
Local _nRecno	:= 0

//-------------------------+
// Recno Registro Romaneio | 
//-------------------------+
_nRecno	:= aExped[nLin][5]

U_IEXPA050(_nRecno)

oGridExp:Refresh()

Return 

/**********************************************************************************************/
/*/{Protheus.doc} TFatExpTOk

@description Valida Romaneio e inicia expedição

@author Bernard M. Margarido
@since 19/08/2018
@version 1.0

@type function
/*/
/**********************************************************************************************/
Static Function TFatExpTOk(nLin)

Local _nRecno	:= 0

//-------------------------+
// Recno Registro Romaneio | 
//-------------------------+
_nRecno	:= aExped[nLin][5]

U_IEXPA040(_nRecno)

oGridExp:Refresh()

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
/*/{Protheus.doc} TFat03LiOk

@description Valida linha digitada no Acols 

@author Bernard M. Margarido
@since 17/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
User Function TFat03LiOk()
Local lRet		:= .T.
 
Return lRet


/*******************************************************************************************/
/*/{Protheus.doc} TFat03TdOk

@description Realiza a validação dos itens

@author Bernard M. Margarido
@since 17/04/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
User Function TFat03TdOk()
Local aArea		:= GetArea()

Local cMsg		:= ""
Local cMsgCab	:= ""

Local lRet		:= .T.

Local nX		:= 0
Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})

//--------------------------------+
// Dados do cabeçalho do Romaneio | 
//--------------------------------+
/*
cMsgCab += IIF(Empty(M->ZZD_CONFE)	,"Campo: "  + RetTitle("ZZD_CONFE"),"")
cMsgCab += IIF(Empty(M->ZZD_PLACA)	,"Campo: "  + RetTitle("ZZD_PLACA"),"")
cMsgCab += IIF(Empty(M->ZZD_DTENTR)	,"Campo: " 	+ RetTitle("ZZD_DTENTR"),"")
cMsgCab += IIF(Empty(M->ZZD_HRENTR)	,"Campo: "  + RetTitle("ZZD_HRENTR"),"")
cMsgCab += IIF(Empty(M->ZZD_DTSAID)	,"Campo: "  + RetTitle("ZZD_DTSAID"),"")
cMsgCab += IIF(Empty(M->ZZD_HRSAID)	,"Campo: "  + RetTitle("ZZD_HRSAID"),"")
*/

//-------------------+
// Notas de Romaneio |
//-------------------+
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )

//------------------------------------------------------+
// Valida se todas as notas do romaneio foram conferida |
//------------------------------------------------------+
For nX := 1 To Len(oGetDad:aCols)

	//----------------+
	// Posiciona Nota | 
	//----------------+
	ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO + oGetDad:aCols[nX][nPNota] + oGetDad:aCols[nX][nPSerie] ) )
	
	//----------------------+
	// Notas nao conferidas |
	//----------------------+
	If ZZE->ZZE_STATUS <> "3"
		cMsg += "Nota " + oGetDad:aCols[nX][nPNota] + " Serie " + oGetDad:aCols[nX][nPSerie] + " " + CRLF
	EndIf
	
Next nX

//----------------------------------+
// Valida se tem nota nao conferida |
//----------------------------------+
If !Empty(cMsg)
	MsgInfo("Nao foi possivel encerrar romaneio, existem notas não conferidas " + CRLF + cMsg,"INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf
	
cMsgCab += IIF(Empty(M->ZZD_CNH)	,"Campo: "  + RetTitle("ZZD_CNH"),"")
cMsgCab += IIF(Empty(M->ZZD_DESCMO)	,"Campo: "  + RetTitle("ZZD_DESCMO"),"")

//------------------------+
// Valida dados cabeçalho |
//------------------------+
If !Empty(cMsgCab)
	MsgInfo("Nao foi possivel encerrar romaneio, existem campos nao preenchidos " + CRLF + cMsg,"INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

RestArea(aArea)
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
/*/{Protheus.doc} IEXPA050Re

@description Encia a reimpressao de etiquetas volumes

@author berna
@since 05/07/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function IEXPA050Re()
Local nEtq	:= 0

For nEtq := 1 To Len(aNFRom)
	If aNFRom[nEtq][1]
		U_IEXPR030(aNFRom[nEtq][2],aNFRom[nEtq][3],aNFRom[nEtq][8],aNFRom[nEtq][9])
	EndIf
Next nEtq

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA050Head

@description Cria Header reimpressao

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function IEXPA050Gr()

DEFINE FWBROWSE oGrid DATA ARRAY ARRAY aNFRom NO SEEK NO CONFIG NO REPORT NO LOCATE Of oPCenter

ADD MARKCOLUMN oColumn DATA { || IIf( aNFRom[oGrid:At(),1],'LBOK','LBNO') } 	DOUBLECLICK { || IEXPA050Mark(oGrid:At()) } Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),2] } 	Title "Nota"        	PICTURE PesqPict("ZZE","ZZE_NOTA")    /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("ZZE_NOTA")[1]  	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),3] } 	Title "Serie"    		PICTURE PesqPict("ZZE","ZZE_SERIE")   /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("ZZE_SERIE")[1] 	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),4] } 	Title "Cliente"   		PICTURE PesqPict("ZZE","ZZE_CODCLI")  /*DOUBLECLICK { || TAL01Etq() }*/ 	SIZE TamSx3("ZZE_CODCLI")[1] 	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),5] }		Title "Loja"  			PICTURE PesqPict("ZZE","ZZE_LOJA")    /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("ZZE_LOJA")[1] 		Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),6] } 	Title "Nome" 	    	PICTURE PesqPict("ZZE","ZZE_NOMCLI")  /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("ZZE_NOMCLI")[1] 	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),7] } 	Title "Voume Total"    	PICTURE PesqPict("SF2","F2_VOLUME1")  /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("F2_VOLUME1")[1] 	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),8] } 	Title "Volume De"    	PICTURE PesqPict("SF2","F2_VOLUME1")  /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("F2_VOLUME1")[1] 	Of oGrid
ADD COLUMN oColumn DATA { || aNFRom[oGrid:At(),9] } 	Title "Volume Ate"    	PICTURE PesqPict("SF2","F2_VOLUME1")  /*DOUBLECLICK { || TAL01Etq() }*/		SIZE TamSx3("F2_VOLUME1")[1] 	Of oGrid

//------------------------------------------------+
// Força o nome na coluna que tem a opção do Mark |
//------------------------------------------------+
oGrid:aColumns[01]:cTitle := " "

oGrid:SetBlkBackColor( { || Iif( aNFRom[ oGrid:At() ][1] .And. aNFRom[ oGrid:At() ][1], CLR_HGRAY, Nil ) } )
oGrid:SetBlkColor( { || Iif( aNFRom[ oGrid:At() ][1] .And. aNFRom[ oGrid:At() ][1], CLR_BLACK, Nil ) } )

ACTIVATE FWBrowse oGrid

Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA050It

@description Notas pertencentes ao romaneio

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@type function
/*/
/*******************************************************************************************/
Static Function IEXPA050It()
Local aArea	:= GetArea()
Local aItem	:= {}

//-----------------------+
// Posiciona Nota Fiscal |
//-----------------------+
dbSelectArea("SF2")
SF2->( dbSetOrder(1) )

//-----------------------------+
// Posiciona Itens do Romaneio |
//-----------------------------+
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
If ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO) )
	While ZZE->( !Eof() .And. xFilial("ZZE") + ZZD->ZZD_CODIGO == ZZE->( ZZE_FILIAL + ZZE_CODIGO) )
		aItem := {}
		//-----------------------------------+
		// Adiciona somente notas conferidas |
		//-----------------------------------+
		If ZZE->ZZE_STATUS == "3"
			
			//----------------------+
			// Posiciona Nota Saida |
			//----------------------+ 
			SF2->( dbSeek(xFilial("SF2") + ZZE->ZZE_NOTA + ZZE->ZZE_SERIE + ZZE->ZZE_CODCLI + ZZE->ZZE_LOJA))
			
			aAdd( aItem, .F.				)
			aAdd( aItem, ZZE->ZZE_NOTA		)
			aAdd( aItem, ZZE->ZZE_SERIE		)
			aAdd( aItem, ZZE->ZZE_CODCLI	)
			aAdd( aItem, ZZE->ZZE_LOJA		)
			aAdd( aItem, ZZE->ZZE_NOMCLI	)
			aAdd( aItem, SF2->F2_VOLUME1	)
			aAdd( aItem, 0					)
			aAdd( aItem, 0					)
			aAdd(aNFRom,aItem)
		EndIf	
		ZZE->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)
Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA050Mark

@description Marca nota a ser impressa 

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0

@param nLin	, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function IEXPA050Mark(nLin)
If aNFRom[nLin][1]
	aNFRom[nLin][1] := .F.
Else
	aNFRom[nLin][1] := .T.
EndIf

//------------------------------------------------+
// Informa a quantidade de volumes a ser impresso |
//------------------------------------------------+
TFatA03VolP(aNFRom[nLin][1],nLin)
	
oGrid:Refresh()
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA03VolP

@description Informa a quantidade de etiquetas 

@author Bernard M. Margarido
@since 24/08/2018
@version 1.0

@param lMarca	, logical, descricao
@param nLin		, numeric, descricao
@type function
/*/
/*******************************************************************************************/
Static Function TFatA03VolP(lMarca,nLin)
Local aArea		:= GetArea()

Local nOpcA		:= 0
Local nGetDe	:= 0	
Local nGetAte	:= 0

Local oSay1		:= Nil
Local oSay2		:= Nil
Local oGet1		:= Nil
Local oGet2		:= Nil
Local oBtnOk	:= Nil
Local oBtnCanc	:= Nil
	
If lMarca

	nGetDe  := aNFRom[nLin][8] + 1
	nGetAte := aNFRom[nLin][7] 
	
	//-------------------------------------------------------------------
	// Monta dialog para inserção do valor
	//-------------------------------------------------------------------
	DEFINE MSDIALOG oDlg TITLE "Etiqueta Volumes" FROM 000, 000  TO 140, 310 PIXEL
			
	    @ 006, 005 SAY oSay1 PROMPT "Volume De?" SIZE 142, 007 OF oDlg PIXEL
    	@ 016, 005 MSGET oGet1 VAR nGetDe SIZE 142, 010 PICTURE PesqPict( "SF2", "F2_VOLUME1" ) OF oDlg PIXEL
    	
    	@ 030, 005 SAY oSay2 PROMPT "Volume Ate?" SIZE 142, 007 OF oDlg PIXEL
    	@ 040, 005 MSGET oGet2 VAR nGetAte SIZE 142, 010 PICTURE PesqPict( "SF2", "F2_VOLUME1" ) OF oDlg PIXEL
	
	
		DEFINE SBUTTON oBtnOk FROM 054, 090 TYPE 01 OF oDlg ENABLE ACTION ( nOpcA := 1,oDlg:End() )
		DEFINE SBUTTON oBtnCanc FROM 054, 120 TYPE 02 OF oDlg ENABLE ACTION (  oDlg:End() )
    
  	ACTIVATE MSDIALOG oDlg CENTERED
  	
  	If nOpcA == 1
  		aNFRom[nLin][8] := nGetDe 
  		aNFRom[nLin][9] := nGetAte
  	EndIf
Else
	aNFRom[nLin][8] := 0
	aNFRom[nLin][9] := 0
EndIf  	

RestArea(aArea)
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

/*****************************************************************************************/
/*/{Protheus.doc} IEXPA20Arr                  

@description Carrega Array com os Romaneios

@author Bernard M. Margarido
@since 19/08/2018
@version 1.0

@type function
/*/
/*****************************************************************************************/
Static Function IEXPA20Arr()
Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

Local aItem		:= {}

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZD.ZZD_STATUS, " + CRLF
cQuery += "		ZZD.ZZD_CODIGO, " + CRLF 
cQuery += "		ZZD.ZZD_TRANSP, " + CRLF
cQuery += "		ZZD.R_E_C_N_O_ RECNOZZD, " + CRLF
cQuery += "		A4.A4_NOME ZZD_DESTRP " + CRLF
cQuery += "FROM " + CRLF
cQuery += "		" + RetSqlName("ZZD") + " ZZD " + CRLF 
cQuery += "		INNER JOIN " + RetSqlName("SA4") + " A4 ON A4.A4_FILIAL = '" + xFilial("SA4") + "' AND A4.A4_COD = ZZD.ZZD_TRANSP AND A4.D_E_L_E_T_ = '' " + CRLF
cQuery += "	WHERE " + CRLF
cQuery += "		ZZD.ZZD_FILIAL = '" + xFilial("ZZD") + "' AND " + CRLF 
cQuery += "		ZZD.ZZD_CODIGO BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' AND " + CRLF
If mv_par03 <> 1 
	cQuery += "		ZZD.ZZD_STATUS IN('1','2') AND " + CRLF
EndIf 
cQuery += "		ZZD.D_E_L_E_T_ = '' " + CRLF
cQuery += "	ORDER BY ZZD.ZZD_CODIGO "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	Return .F.
EndIf

While (cAlias)->( !Eof() )
	
	aItem	:= {}
	
	aAdd(aItem,	(cAlias)->ZZD_STATUS 	)
	aAdd(aItem,	(cAlias)->ZZD_CODIGO 	)
	aAdd(aItem,	(cAlias)->ZZD_TRANSP 	)
	aAdd(aItem,	(cAlias)->ZZD_DESTRP 	)
	aAdd(aItem,	(cAlias)->RECNOZZD		)
	
	aAdd( aExped, aItem )
	
	(cAlias)->( dbSkip() )
EndDo

Return .T.

/*****************************************************************************************/
/*/{Protheus.doc} CreateSX1

@description Cria parametros Expedição

@author Bernard M. Margarido
@since 19/08/2018
@version 1.0

@param cPerg, characters, descricao

@type function
/*/
/*****************************************************************************************/
Static Function CreateSX1( cPerg )

Local aPerg := {}
Local aArea := GetArea()
Local i

aAdd(aPerg, {cPerg, "01", "Romaneio De?"	, "MV_CH1", "C", TamSX3("ZZD_CODIGO")[1], 0, "G"	, "MV_PAR01", "ZZD","","","",""})
aAdd(aPerg, {cPerg, "02", "Romaneio Ate?"	, "MV_CH2", "C", TamSX3("ZZD_CODIGO")[1], 0, "G"	, "MV_PAR02", "ZZD","","","",""})
aAdd(aPerg, {cPerg, "03", "Tipo Romaneio"	, "MV_CH3", "C", TamSX3("ZZD_STATUS")[1], 0, "C"	, "MV_PAR03", ""   ,"1-Todos","2-Abertos","",""})

For i := 1 To Len(aPerg)
	
	If  !SX1->( dbSeek(aPerg[i,1] + aPerg[i,2]) )	
		
		RecLock("SX1",.T.)
		
		Replace X1_GRUPO   with aPerg[i,01]
		Replace X1_ORDEM   with aPerg[i,02]
		Replace X1_PERGUNT with aPerg[i,03]
		Replace X1_VARIAVL with aPerg[i,04]
		Replace X1_TIPO	   with aPerg[i,05]
		Replace X1_TAMANHO with aPerg[i,06]
		Replace X1_PRESEL  with aPerg[i,07]
		Replace X1_GSC	   with aPerg[i,08]
		Replace X1_VAR01   with aPerg[i,09]
		Replace X1_F3	   with aPerg[i,10]
		Replace X1_DEF01   with aPerg[i,11]
		Replace X1_DEF02   with aPerg[i,12]
		Replace X1_DEF03   with aPerg[i,13]
		Replace X1_DEF04   with aPerg[i,14]
	
		SX1->( MsUnlock() )
		
	EndIf	
	
Next i

RestArea( aArea )

Return
