#INCLUDE 'FWBROWSE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE CLR_CINZA RGB(230,230,230)

/************************************************************************************/
/*/

@description Realiza a reimpressão das etiquetas

@author Bernard M. Margarido
@since 27/06/2018
@version 1.0

@param cAlias	, characters, descricao
@param nReg		, numeric	, descricao
@param nOpc		, numeric	, descricao
@type function
/*/
/************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function ICOMA020(cAlias,nReg,nOpc)
Local aArea			:= GetArea()

Local _cUsrReimp	:= GetNewPar("TG_URSRIMP","000000")

Local oSize     	:= FWDefSize():New( .T. )
Local oLayer    	:= FWLayer():New()
Local oDlg			:= Nil
Local oTBtnPrint	:= Nil
Local oTBtnExit 	:= Nil

Local aCoors    	:= FWGetDialogSize( oMainWnd )

Private	oGrp01 		:= Nil
Private	oGrp02 		:= Nil
Private	oGet01		:= Nil
Private oGet02		:= Nil
Private oGet03		:= Nil
Private oPSup		:= Nil
Private oPCenter    := Nil
Private oGrid       := Nil
Private oGetForn	:= Nil
Private oGetLoja	:= Nil
Private oGet04		:= Nil
Private oSay04		:= Nil
Private oSay05		:= Nil
Private oGet05		:= Nil
Private oGet06		:= Nil
Private oGet07		:= Nil
Private oCBox1		:= Nil

Private	cNumCx		:= Space(TamSx3("ZZA_NUMCX")[1])
Private	cPallet		:= Space(TamSx3("ZZA_PALLET")[1])
Private	cLote		:= Space(TamSx3("ZZA_NUMCX")[1])
Private cImpressora	:= Space(6)
Private	cDescPrint	:= Space(30)
Private	cNumCxDe	:= Space(TamSx3("ZZA_NUMCX")[1])
Private	cNumCxAte	:= Space(TamSx3("ZZA_NUMCX")[1])
Private	cCodPallet	:= Space(TamSx3("ZZA_PALLET")[1])

Private lPrtPallet	:= .F.
Private lConferida	:= IIF(SF1->F1_XSTATUS == "1",.F.,.T.)
Private lDevolucao	:= IIF(SF1->F1_TIPO == "D",.T.,.F.)

Private aItensNF    := {}
Private aHeadNF		:= {}

//-----------------------------------+
// Valida se usuário tem autorização | 
//-----------------------------------+
If !__cUserID $ _cUsrReimp
	Aviso("INOVEN - Avisos","Usuário " + RTrim(LogUserName()) + " sem acesso para reimpressão.",{"Sair"})
	RestArea(aArea)
	Return .F.
EndIf

U_ITECX010("IEXPR030","Reimpressão das Etiquetas")//Grava detalhes da rotina usada

oSize:AddObject( "DLG", 100, 100, .T., .T.)
oSize:SetWindowSize(aCoors)
oSize:lProp     := .T.
oSize:lLateral 	:= .T.
oSize:Process()

//-------------------+
// Cria Header Itens |
//-------------------+
IEXPR030Head()

//-----------------------+
// Carrega Itens da Nota |
//-----------------------+
IEXPR030It()

DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3] - 100, oSize:aWindSize[4] - 300 Title "Reimpressão Etiquetas" OF oMainWnd PIXEL

	oLayer:Init( oDlg, .F. )
	oLayer:AddLine( "LINE01", 60 )
	oLayer:AddLine( "LINE02", 40 )
	
	oLayer:AddCollumn( "ITEMS"	, 100,, "LINE01" )
	oLayer:AddCollumn( "INFO"  	, 100,, "LINE02" )
	
	oLayer:AddWindow( "ITEMS"	, "FWITEMS"	, "Itens Reimpressão"   	, 100  	,.F. ,,,"LINE01" )
	oLayer:AddWindow( "INFO"	, "FWINFO"  , "Informações Etiqueta"   	, 080 	,.F. ,,,"LINE02" )
	
	oPSup    := oLayer:GetWinPanel( "ITEMS"	, "FWITEMS"  	, "LINE01" )
	oPCenter := oLayer:GetWinPanel( "INFO"  , "FWINFO"		, "LINE02" )
	
	//---------------+
	// Itens da Nota |
	//---------------+
	IEXPR030Grid()	
	
	//-------------------+
	// Dados da Etiqueta |
	//-------------------+
	IEXPR030Etq()
	
	//-----------------------+
	// Painel para os Botoes | 
	//-----------------------+
	oPnlBtn := TPanel():New(000,000,"",oDlg,Nil,.T.,.F.,Nil,CLR_CINZA,000,022,.T.,.F.)
	oPnlBtn:Align := CONTROL_ALIGN_BOTTOM
		
	oTBtnPrint := TButton():New( 005, 500, "Imprimir",oPnlBtn,{|| IIF(TgVldEt(),IEXPR030Prt(),.F.) }	, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTBtnExit  := TButton():New( 005, 555, "Cancelar",oPnlBtn,{|| oDlg:End() }							, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)
Return Nil

/************************************************************************************/
/*/{Protheus.doc} IEXPR030It

@description Cria Array com os itens da Nota

@author Bernard M. Margarido
@since 27/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR030It()
Local aArea 		:= GetArea()

//-------------------+
// Posiciona Produto |
//-------------------+
dbSelectArea("SB1")
SB1->( dbSetOrder(1) )

//--------------------+
// Posiciona Etiqueta |
//--------------------+
dbSelectArea("ZZA")
ZZA->( dbSetOrder(1) )

//-------------------------+
// Posiciona itens da Nota |
//-------------------------+
dbSelectArea("SD1")
SD1->( dbSetOrder(1) )
 
If SD1->( dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	While SD1->( !Eof() .And. xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) )
	
		//-------------------+
	 	// Reseta Array Item |
	 	//-------------------+
		aAdd(aItensNF,Array(Len(aHeadNF)+1))
		
		//-------------------+
		// Posiciona Produto |
		//-------------------+
		SB1->( dbSeek(xFilial("SB1") + SD1->D1_COD) )
		
		//--------------------+
		// Posiciona Etiqueta | 
		//--------------------+
		ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SD1->D1_ITEM) )
		
		aItensNF[Len(aItensNF)][01] := SD1->D1_ITEM
		aItensNF[Len(aItensNF)][02] := SD1->D1_COD  
		aItensNF[Len(aItensNF)][03] := SB1->B1_DESC 
		aItensNF[Len(aItensNF)][04] := SD1->D1_QUANT
		aItensNF[Len(aItensNF)][05] := SD1->D1_LOTECTL
		
		aItensNF[Len(aItensNF)][Len(aHeadNF) + 1] := IIF(SD1->D1_XSTATUS == "2",.F.,.T.)			
			
		SD1->( dbSkip() )
		
	EndDo
	
	//------------------+
	// Ordena pelo Item |
	//------------------+ 
	aSort(aItensNF,,,{|x,y| x[1] < y[1]})
	
Else
	MsgAlert( "Não foram encontrados registros com os parâmetros informados.", "Atenção" )
	RestArea( aArea )
	Return Nil
EndIf

//---------------+
// Atualiza GRID |
//---------------+
If ValType(oGrid) == "O"
	oGrid:Refresh()
	oPSup:Refresh()
EndIf	

RestArea( aArea )
Return Nil

/************************************************************************************/
/*/{Protheus.doc} IEXPR030Head

@description Cria Header Itens da Nota

@author Bernard M. Margarido
@since 28/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR030Head()

aHeadNF := {}
aAdd(aHeadNF,{RetTitle("D1_ITEM")			,"ITEMNF"		,PesqPict("SD1","D1_ITEM")			,TamSx3("D1_ITEM")[1]		,TamSx3("D1_ITEM")[2]			,"AllWaysTrue()","û","C","",""	} )	
aAdd(aHeadNF,{RetTitle("D1_COD")			,"CODPRD"		,PesqPict("SD1","D1_COD")			,TamSx3("D1_COD")[1]		,TamSx3("D1_COD")[2]			,"AllWaysTrue()","û","C","",""	} )
aAdd(aHeadNF,{RetTitle("B1_DESC")			,"DESCPR"		,PesqPict("SB1","B1_DESC")			,TamSx3("B1_DESC")[1]		,TamSx3("B1_DESC")[2]			,"AllWaysTrue()","û","C","",""	} )
aAdd(aHeadNF,{RetTitle("D1_QUANT")			,"QTDNF"		,PesqPict("SD1","D1_QUANT")			,TamSx3("D1_QUANT")[1]		,TamSx3("D1_QUANT")[2]			,"AllWaysTrue()","û","N","",""	} )
aAdd(aHeadNF,{RetTitle("D1_LOTECTL")		,"LOTENF"		,PesqPict("SD1","D1_LOTECTL")		,TamSx3("D1_LOTECTL")[1]	,TamSx3("D1_LOTECTL")[2]		,"AllWaysTrue()","û","C","",""	} )

Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030Grid
Monta a estrutura da GRID
@author  Victor Andrade
@since   04/04/2018
@version 1
/*/
/************************************************************************************/
Static Function IEXPR030Grid()
		
	oGrid := MsNewGetDados():New(000,000,000,000,0,/*cLinOk*/,/*cTudoOk1*/,/*cIniCpos*/,/*aAlterCpo*/,/*nFreeze*/,9999,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oPSup,aHeadNF,aItensNF)
	oGrid:oBrowse:Align:= CONTROL_ALIGN_ALLCLIENT
	
	oGrid:bChange := {|| IEXPR030TEtq(aItensNF[oGrid:nAt,2],SF1->F1_DOC,SF1->F1_SERIE,aItensNF[oGrid:nAt,5],aItensNF[oGrid:nAt,1],@cNumCx),;
						 IEXPR030TPal(aItensNF[oGrid:nAt,2],SF1->F1_DOC,SF1->F1_SERIE,aItensNF[oGrid:nAt,5],aItensNF[oGrid:nAt,1],@cPallet),;
						 IEXPR030TLot(aItensNF[oGrid:nAt,5],@cLote)}
	oGrid:Refresh()
	
Return Nil

/************************************************************************************/
/*/{Protheus.doc} IEXPR030Etq

@description Atualiza dados da etiqueta

@author Bernard M. Margarido
@since 27/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR030Etq()
Local aArea		:= GetArea()

Local bWhenGet1	:= {|| IEXPR030TEtq(aItensNF[oGrid:nAt,2],SF1->F1_DOC,SF1->F1_SERIE,aItensNF[oGrid:nAt,5],aItensNF[oGrid:nAt,1],@cNumCx)}
Local bWhenGet2	:= {|| IEXPR030TPal(aItensNF[oGrid:nAt,2],SF1->F1_DOC,SF1->F1_SERIE,aItensNF[oGrid:nAt,5],aItensNF[oGrid:nAt,1],@cPallet)}
Local bWhenGet3	:= {|| IEXPR030TLot(aItensNF[oGrid:nAt,5],@cLote)}
Local bWhenGet4	:= {|| cDescPrint := Posicione("CB5",1,xFilial("CB5") + cImpressora,"CB5_DESCRI"),oGet04:Refresh(),oSay04:Refresh()}

//---------------+
// Group Cliente |
//---------------+
oGrp01 	:= TGroup():New(001,001,005,200,"Totais Etiqueta",oPCenter,,,.T.)
oGrp01:Align := CONTROL_ALIGN_LEFT
//----------------+
// Dados Etiqueta | 
//----------------+
oGet01	:= TGet():New( 009, 007	, {|u| IIF(PCount() > 0, cNumCx := u, cNumCx	)} 	, oPCenter, 040, 010,PesqPict("ZZA","ZZA_NUMCX"	),,,,,,,.T.,,,bWhenGet1,,,,.T.,,,"cNumCx",,,,.T.,,,"Total Caixas",1)
oGet02	:= TGet():New( 009, 050	, {|u| IIF(PCount() > 0, cPallet := u, cPallet	)} 	, oPCenter, 040, 010,PesqPict("ZZA","ZZA_PALLET"),,,,,,,.T.,,,bWhenGet2,,,,.T.,,,"cPallet",,,,.T.,,,"Total Pallets",1)
oGet03	:= TGet():New( 029, 007	, {|u| IIF(PCount() > 0, cLote := u, cLote	)} 		, oPCenter, 090, 010,PesqPict("SD1","D1_LOTECTL"),,,,,,,.T.,,,bWhenGet3,,,,.T.,,,"cLote",,,,.T.,,,"Lote",1)

//---------------+
// Group Cliente |
//---------------+
oGrp02 	:= TGroup():New(001,001,005,400,"Imprimir",oPCenter,,,.T.)
oGrp02:Align := CONTROL_ALIGN_RIGHT

cImpressora	:= "000001"
oGet04	:= TGet():New( 009, 207	, {|u| IIF(PCount() > 0, cImpressora := u, cImpressora	)} 	, oPCenter, 050, 010,"@!",,,,,,,.T.,,,bWhenGet4,,,,.F.,,"CB5","cImpressora",,,,.T.,,,"Impressora",1)
oSay04	:= TSay():New( 019, 260 , {|| cDescPrint } ,oPCenter ,, /*oFont10N*/ ,,,, .T. ,CLR_BLUE,, 100,010 )

cNumCxDe:= "0001"
oGet05	:= TGet():New( 029, 207	, {|u| IIF(PCount() > 0, cNumCxDe := u, cNumCxDe		)} 	, oPCenter, 040, 010,PesqPict("ZZA","ZZA_NUMCX"	),,,,,,,.T.,,,,,,,.F.,,,"cNumCxDe",,,,.T.,,,"Num Caixa De",1)

cNumCxAte:= "9999"
oGet06	:= TGet():New( 029, 250	, {|u| IIF(PCount() > 0, cNumCxAte := u, cNumCxAte		)} 	, oPCenter, 040, 010,PesqPict("ZZA","ZZA_NUMCX"),,,,,,,.T.,,,,,,,.F.,,,"cNumCxDe",,,,.T.,,,"Num Caixa Ate",1)

oSay05	:= TSay():New( 039, 295 , {|| "ou" } ,oPCenter ,, /*oFont10N*/ ,,,, .T. ,,, 010,010 )

oGet07	:= TGet():New( 029, 310	, {|u| IIF(PCount() > 0, cCodPallet := u, cCodPallet	)} 	, oPCenter, 090, 010,PesqPict("ZZA","ZZA_PALLET"),,,,,,,.T.,,,,,,,.F.,,,"cCodPallet",,,,.T.,,,"Pallet",1)

oCBox1	:= TCheckBox():New(055, 207, "Imprime Etiqueta Pallet ?" ,{|u| If( PCount() > 0 , lPrtPallet:=u, lPrtPallet )},oPCenter,080,010,,,,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

RestArea(aArea)
Return Nil

/************************************************************************************/
/*/{Protheus.doc} IEXPR030TEtq

@description Retorna Numero de Caixas por produto.

@author berna
@since 28/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR030TEtq(cCodProd,cNFiscal,cSerie,cNumLote,cItemNf,cNumCx)
Local aArea		:= GetArea()

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT " + CRLF
cQuery += "		COUNT(ZZA_NUMCX) ZZA_NUMCX " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " " + CRLF	
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF 
cQuery += "		ZZA_NUMNF = '" + cNFiscal + "' AND " + CRLF 
cQuery += "		ZZA_SERIE = '" + cSerie + "' AND " + CRLF
cQuery += "		ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
cQuery += "		ZZA_NUMLOT = '" + cNumLote + "' AND " + CRLF
cQuery += "		D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return cNumCx
EndIf

cNumCx := StrZero((cAlias)->ZZA_NUMCX,5)

//--------------+
// Atualiza Get |
//--------------+
If ValType(oGet01) == "O"
	oGet01:Refresh()
	oPCenter:Refresh()
EndIf	

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030TPal

@description Consulta Total de Pallets Por Produto

@author Bernard M. Margarido
@since 28/06/2018
@version 1.0

@param cCodProd	, characters, descricao
@param cNFiscal	, characters, descricao
@param cSerie	, characters, descricao
@param cNumLote	, characters, descricao
@param cPallet	, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function IEXPR030TPal(cCodProd,cNFiscal,cSerie,cNumLote,cItemNf,cPallet)
Local aArea		:= GetArea()

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

Local nTotPall	:= 0

cQuery := "	SELECT " + CRLF
cQuery += "		ZZA_PALLET " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " " + CRLF	
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF 
cQuery += "		ZZA_NUMNF = '" + cNFiscal + "' AND " + CRLF 
cQuery += "		ZZA_SERIE = '" + cSerie + "' AND " + CRLF
cQuery += "		ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
cQuery += "		ZZA_NUMLOT = '" + cNumLote + "' AND " + CRLF
cQuery += "		ZZA_PALLET <> '' AND " + CRLF
cQuery += "		D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY ZZA_PALLET "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return cPallet
EndIf

While (cAlias)->( !Eof() )
	nTotPall++
	(cAlias)->( dbSkip() )
EndDo

cPallet := StrZero(nTotPall,5)

//--------------+
// Atualiza Get |
//--------------+
If ValType(oGet02) == "O"
	oGet02:Refresh()
	oPCenter:Refresh()
EndIf	

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030TLot

@description Carrega Lote atual na Get

@author Bernard M. Margarido
@since 28/06/2018
@version 1.0

@param cNumLote	, characters, descricao
@param cLote	, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function IEXPR030TLot(cNumLote,cLote)

cLote := cNumLote

//--------------+
// Atualiza Get |
//--------------+
If ValType(oGet03) == "O"
	oGet03:Refresh()
	oPCenter:Refresh()
EndIf	

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgVldEt

@author berna
@since 29/06/2018
@version 1.0


@type function
/*/
/************************************************************************************/
Static Function TgVldEt()
Local aArea	:= GetArea()

//-------------------+
// Valida Impressora |
//-------------------+
If Empty(cImpressora)
	MsgAlert("Impressora nao informada. Favor selecionar uma impressora","INOVEN - Avisos")
	Return .F.
EndIf

//---------------+
// Valida Caixas |
//---------------+
If !Empty(cNumCxDe) .And. !Empty(cNumCxAte) .And. cNumCxDe > cNumCxAte
	MsgAlert("Divergencia no numero da Caixa.","INOVEN - Avisos")
	Return .F.
EndIf

If Empty(cNumCxDe) .And. Empty(cNumCxAte) .And. Empty(cCodPallet)
	MsgAlert("Numero da Caixa ou Codigo de Pallet nao informado. ","INOVEN - Avisos")
	Return .F.
EndIf

//---------------------------------+
// Valida se item já foi conferido |
//---------------------------------+
If oGrid:aCols[oGrid:nAt][Len(oGrid:aHeader) + 1]
	MsgAlert("Não é permitido imprimir etiquetas para itens não conferidos.","INOVEN - Avisos")
	Return .F.
EndIf

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030Prt

@description Realiza impressao de etiquetas 

@author Bernard M. Margarido
@since 29/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function  IEXPR030Prt()
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cPallet	:= ""	
Local cDescPrd	:= ""
//Local cTotEtq	:= ""	
Local cLoteEtq	:= ""
Local cCodProd	:= ""

Local dData		:= ""
Local dDtValid	:= ""

Local cEtq			:= ""

//--------------------+
// Consulta Etiquetas | 
//--------------------+
If !IEXPR030Qry(cAlias)
		
	MsgAlert("Não foram encontradas etiquetas para serem impressas.","INOVEN - Avisos")
	
	//--------------------+
	// Encerra temporario | 
	//--------------------+
	(cAlias)->( dbCloseArea() )
	
	RestArea(aArea)
	Return .T.
EndIf

Private nGridEtq := 0

//-------------------+
// Valida impressora |
//-------------------+
If CB5SetImp( cImpressora )
	
	//---------------+	
	// Posiciona ZZA |
	//---------------+	
	dbSelectArea("ZZA")
	ZZA->( dbSetOrder(1) )
	
	//---------------------+
	// Caso imprime Pallet |
	//---------------------+
	If lPrtPallet

		//----------------------------------+
		// Realiza a impressao de etiquetas | 
		//----------------------------------+
		While (cAlias)->( !Eof() )
			
			cCodProd 	:= (cAlias)->ZZA_CODPRO
			cPallet		:= (cAlias)->ZZA_PALLET
			
			While (cALias)->( !Eof() .And. cCodProd + cPallet == (cAlias)->ZZA_CODPRO + (cAlias)->ZZA_PALLET)
			
				//------------------------+
			    // Monta codigo de Barras |
			    //------------------------+
			    
				cCodBar 	:= Alltrim((cAlias)->ZZA_CODBAR) 				//Código de barras
				cCodBar 	+= Alltrim((cAlias)->ZZA_CODPRO)				//Código do produto
				cCodBar 	+= PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")	   	//Número da NF de Entrada
				cCodBar 	+= Alltrim((cAlias)->ZZA_ITEMNF)				//Item NF
				cCodBar 	+= Alltrim((cAlias)->ZZA_NUMCX)					//Numero da Caixa
				
				cLoteEtq 	:= Alltrim((cAlias)->ZZA_NUMLOT) 				//Lote de Compras
		 		cPallet		:= (cAlias)->ZZA_PALLET
		 		cDescPrd	:= (cAlias)->B1_DESC
		 		dData		:= sTod((cAlias)->DTALT)
		 		dDtValid	:= sTod((cAlias)->DTALTVENC)
		 		

				if empty(nGridEtq)
					cEtq := 'CT~~CD,~CC^~CT~' + CRLF
					//cEtq += '^XA~TA000~JSN^LT-20^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
					cEtq += '^XA~TA000~JSN^LT-20^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
					cEtq += '^XA' + CRLF
					cEtq += '^MMT' + CRLF
					cEtq += '^PW863' + CRLF
					cEtq += '^LL224' + CRLF
					cEtq += '^LS15' + CRLF
				endif
				nGridEtq++
				cDsQrCode := PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")  		//Número da NF de Entrada
				cDsQrCode += Alltrim((cAlias)->ZZA_ITEMNF)					//Item NF
				cDsQrCode += Alltrim((cAlias)->ZZA_NUMCX)					//Numero da Caixa
				cEtq += U_ICOMR040(1,(cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,"","",dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
				if nGridEtq==3
					nGridEtq := 0
					cEtq += '^PQ1,0,1,Y' + CRLF
					cEtq += '^XZ'
					//faz a impressao

					//salvar arquivo texto
					//MemoWrite("\temp\etiqueta_qrcode_pallet.txt",cEtq)

					//-------------------------------------+
					// Inicializa a montagem da impressora |
					//-------------------------------------+
					MscbBegin(1,6)
					MSCBWrite(cEtq)
					//---------------------------------+
					// Finaliza a Imagem da Impressora |
					//---------------------------------+
					MscbEnd()

					cEtq := ""
				endif
			    /*
				//-------------------------------------+
				// Inicializa a montagem da impressora |
				//-------------------------------------+
				MscbBegin(1,6) 
				
		        cEtq := U_ICOMR040(1,(cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,"","",dData,dDtValid,cCodBar)
		              
		        cTotEtq += cEtq + CRLF
		        
		        MSCBWrite(cEtq)
		        		        
		        //---------------------------------+
				// Finaliza a Imagem da Impressora |
				//---------------------------------+
				MscbEnd()
				*/
				
				//-------------------+
				// Posicona registro | 
				//-------------------+
				ZZA->( dbGoTo((cAlias)->RECNOZZA) )
				If ZZA->( FieldPos("ZZA_QTDIMP") ) > 0
					RecLock("ZZA",.F.)
						ZZA->ZZA_QTDIMP := ZZA->ZZA_QTDIMP + 1
						ZZA->ZZA_USER	:= LogUserName()
					ZZA->( MsUnLock() )	 
				EndIf		
				
				(cAlias)->( dbSkip() )
			
			EndDo
			
			//--------------------------------------+
			// Encerra comunicação com a impressora |
			//--------------------------------------+
			//MSCBClosePrinter()
			
			//----------------------------+
			// Imprime etiqueta de Pallet |
			//----------------------------+
			If ( !Empty(cPallet) .And. !Empty(cCodPallet) ) .Or. lPrtPallet
				IEXPR030EPl(cPallet,cDescPrd,dData,dDtValid,@nGridEtq,@cEtq)
			EndIf
			
		EndDo

		if nGridEtq<3
			nGridEtq := 0
			cEtq += '^PQ1,0,1,Y' + CRLF
			cEtq += '^XZ'
			//faz a impressao

			//salvar arquivo texto
			//MemoWrite("\temp\etiqueta_qrcode_pallet.txt",cEtq)

			//-------------------------------------+
			// Inicializa a montagem da impressora |
			//-------------------------------------+
			MscbBegin(1,6)
			MSCBWrite(cEtq)
			//---------------------------------+
			// Finaliza a Imagem da Impressora |
			//---------------------------------+
			MscbEnd()
		endif

		//--------------------------------------+
		// Encerra comunicação com a impressora |
		//--------------------------------------+
		MSCBClosePrinter()

	Else
		
		//----------------------------------+
		// Realiza a impressao de etiquetas | 
		//----------------------------------+
		While (cAlias)->( !Eof() )
			//------------------------+
		    // Monta codigo de Barras |
		    //------------------------+
			cCodBar 	:= Alltrim((cAlias)->ZZA_CODBAR) 				//Código de barras
			cCodBar 	+= Alltrim((cAlias)->ZZA_CODPRO)				//Código do produto
			cCodBar 	+= PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")	   	//Número da NF de Entrada
			cCodBar 	+= Alltrim((cAlias)->ZZA_ITEMNF)				//Item NF
			cCodBar 	+= Alltrim((cAlias)->ZZA_NUMCX)					//Numero da Caixa
			cLoteEtq 	:= Alltrim((cAlias)->ZZA_NUMLOT) 				//Lote de Compras
	 		cPallet		:= (cAlias)->ZZA_PALLET
	 		cDescPrd	:= (cAlias)->B1_DESC
	 		dData		:= sTod((cAlias)->DTALT)
	 		dDtValid	:= sTod((cAlias)->DTALTVENC)
	 		

			if empty(nGridEtq)
				cEtq := 'CT~~CD,~CC^~CT~' + CRLF
				//cEtq += '^XA~TA000~JSN^LT-20^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
				cEtq += '^XA~TA000~JSN^LT-20^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
				cEtq += '^XA' + CRLF
				cEtq += '^MMT' + CRLF
				cEtq += '^PW863' + CRLF
				cEtq += '^LL224' + CRLF
				cEtq += '^LS15' + CRLF
			endif
			nGridEtq++
			cDsQrCode := PadL(Alltrim((cAlias)->ZZA_NUMNF),9,"0")  		//Número da NF de Entrada
			cDsQrCode += Alltrim((cAlias)->ZZA_ITEMNF)					//Item NF
			cDsQrCode += Alltrim((cAlias)->ZZA_NUMCX)					//Numero da Caixa
			cEtq += U_ICOMR040(1,(cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,"","",dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
			if nGridEtq==3
				nGridEtq := 0
				cEtq += '^PQ1,0,1,Y' + CRLF
				cEtq += '^XZ'
				//faz a impressao

				//salvar arquivo texto
				//MemoWrite("\temp\etiqueta_qrcode.txt",cEtq)

				//-------------------------------------+
				// Inicializa a montagem da impressora |
				//-------------------------------------+
				MscbBegin(1,6)
				MSCBWrite(cEtq)
				//---------------------------------+
				// Finaliza a Imagem da Impressora |
				//---------------------------------+
				MscbEnd()

				cEtq := ""
			endif

		    /*
			//-------------------------------------+
			// Inicializa a montagem da impressora |
			//-------------------------------------+
			MscbBegin(1,6) 
			
	        cEtq := U_ICOMR040(1,(cAlias)->ZZA_CODPRO,(cAlias)->B1_DESC,(cAlias)->ZZA_NUMLOT,"","",dData,dDtValid,cCodBar)
	              
	        cTotEtq += cEtq + CRLF
	        
	        MSCBWrite(cEtq)
	        		        
	        //---------------------------------+
			// Finaliza a Imagem da Impressora |
			//---------------------------------+
			MscbEnd()
			*/
			
			//-------------------+
			// Posicona registro | 
			//-------------------+
			ZZA->( dbGoTo((cAlias)->RECNOZZA) )
			If ZZA->( FieldPos("ZZA_QTDIMP") ) > 0
				RecLock("ZZA",.F.)
					ZZA->ZZA_QTDIMP := ZZA->ZZA_QTDIMP + 1
					ZZA->ZZA_USER	:= LogUserName()
				ZZA->( MsUnLock() )	 
			EndIf		
				
			(cAlias)->( dbSkip() )
	
		EndDo
		
		//--------------------------------------+
		// Encerra comunicação com a impressora |
		//--------------------------------------+
		//MSCBClosePrinter()
		
		//----------------------------+
		// Imprime etiqueta de Pallet |
		//----------------------------+
		If ( !Empty(cPallet) .And. !Empty(cCodPallet) )
			IEXPR030EPl(cCodPallet,cDescPrd,dData,dDtValid,@nGridEtq,@cEtq)
		EndIf

		if nGridEtq<3
			nGridEtq := 0
			cEtq += '^PQ1,0,1,Y' + CRLF
			cEtq += '^XZ'
			//faz a impressao

			//salvar arquivo texto
			//MemoWrite("\temp\etiqueta_qrcode.txt",cEtq)

			//-------------------------------------+
			// Inicializa a montagem da impressora |
			//-------------------------------------+
			MscbBegin(1,6)
			MSCBWrite(cEtq)
			//---------------------------------+
			// Finaliza a Imagem da Impressora |
			//---------------------------------+
			MscbEnd()
		endif

		//--------------------------------------+
		// Encerra comunicação com a impressora |
		//--------------------------------------+
		MSCBClosePrinter()

	EndIf
		
	//--------------------+
	// Encerra temporario | 
	//--------------------+
	(cAlias)->( dbCloseArea() )
		
Else
	MsgAlert( "Erro ao comunicar-se com a impressora" )
EndIf	

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030EPl

@description Reimpressao etiqueta Pallet

@author Bernard M. Margarido
@since 29/06/2018
@version 1.0

@param cCodPallet	, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function IEXPR030EPl(cCodPallet,cDescPrd,dData,dDtValid,nGridEtq,cEtq)
Local cCodProd	:= aItensNf[oGrid:nAt][2]
Local cNFiscal	:= SF1->F1_DOC
Local cItemNf	:= aItensNf[oGrid:nAt][1]

//If CB5SetImp( cImpressora )
	
	//------------------------+
	// Monta codigo de Barras |
	//------------------------+
	cCodBar	:= Alltrim(cCodPallet)					// Pallet	
	cCodBar += Alltrim(cCodProd)					// Código do produto
	cCodBar += PadL(Alltrim(cNFiscal),9,"0")	    // Número da NF de Entrada
	cCodBar += Alltrim(cItemNf)						// Item NF
	cCodBar += "00000"			 					// Numero da Caixa
	cCodBar += PadL(Alltrim(cNFiscal),10,"0")		// Número da NF de Entrada   
	
	
	if empty(nGridEtq)
		cEtq := 'CT~~CD,~CC^~CT~' + CRLF
		//cEtq += '^XA~TA000~JSN^LT-20^MNW^MTD^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
		cEtq += '^XA~TA000~JSN^LT-20^MNW^MTT^PON^PMN^LH0,0^JMA^PR4,4~SD15^JUS^LRN^CI27^PA0,1,1,0^XZ' + CRLF
		cEtq += '^XA' + CRLF
		cEtq += '^MMT' + CRLF
		cEtq += '^PW863' + CRLF
		cEtq += '^LL224' + CRLF
		cEtq += '^LS15' + CRLF
	endif
	nGridEtq++
	cDsQrCode := 'PALLET: ' + cCodPallet
	cEtq += U_ICOMR040(2,cCodProd,cDescPrd,"",cCodPallet,cNumCx,dData,dDtValid,cCodBar,cDsQrCode,nGridEtq)
	if nGridEtq==3
		nGridEtq := 0
		cEtq += '^PQ1,0,1,Y' + CRLF
		cEtq += '^XZ'
		//faz a impressao

		//-------------------------------------+
		// Inicializa a montagem da impressora |
		//-------------------------------------+
		MscbBegin(1,6)
		MSCBWrite(cEtq)
		//---------------------------------+
		// Finaliza a Imagem da Impressora |
		//---------------------------------+
		MscbEnd()

		cEtq := ""

	endif
	
	//cEtq := U_ICOMR040(2,cCodProd,cDescPrd,"",cCodPallet,cNumCx,dData,dDtValid,cCodBar)
	
	//cTotEtq += cEtq + CRLF
	
	//Aviso('',cTotEtq,{"Ok"})
				
	/*
	//-------------------------------------+
	// Inicializa a montagem da impressora |
	//-------------------------------------+
	MscbBegin(1,6) 
	
    MSCBWrite(cEtq)
    
    //---------------------------------+
	// Finaliza a Imagem da Impressora |
	//---------------------------------+
	MscbEnd()
    
    //--------------------------------------+
	// Encerra comunicação com a impressora |
	//--------------------------------------+        
    MSCBClosePrinter()
	*/
            
/*    
Else
    MsgAlert( "Erro ao comunicar-se com a impressora" )
EndIf
*/
Return .T.

/************************************************************************************/
/*/{Protheus.doc} IEXPR030Qry

@description Consulta etiquetas a srem reimpressas 

@author Bernard M. Margarido
@since 29/06/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function IEXPR030Qry(cAlias)
Local cQuery 	:= ""
Local cItemNf	:= aItensNF[oGrid:nAt][1]
Local cCodProd	:= aItensNF[oGrid:nAt][2]
Local cNFiscal	:= SF1->F1_DOC
Local cSerie	:= SF1->F1_SERIE

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZA.ZZA_CODBAR, " + CRLF
cQuery += "		ZZA.ZZA_CODPRO, " + CRLF
cQuery += "		ZZA.ZZA_NUMNF, " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF, " + CRLF
cQuery += "		ZZA.ZZA_NUMCX, " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT, " + CRLF
cQuery += "		ZZA.ZZA_PALLET, " + CRLF
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA, " + CRLF
cQuery += "		B1.B1_DESC, " + CRLF
If lConferida .And. !lDevolucao
	//cQuery += "		B8.B8_DATA DTALT, " + CRLF
	//cQuery += "		B8.B8_DTVALID DTALTVENC " + CRLF
	cQuery += "		LOTEB8.DTLOTE DTALT, " + CRLF
	cQuery += "		LOTEB8.DTVALID DTALTVENC " + CRLF
Else
	cQuery += "		D5.D5_DATA DTALT, " + CRLF
	cQuery += "		D5.D5_DTVALID DTALTVENC " + CRLF
EndIf	
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SB1") + " B1 ON B1.B1_FILIAL = '" + xFilial("SB1") + "' AND B1.B1_COD = ZZA.ZZA_CODPRO AND B1.D_E_L_E_T_ = '' " + CRLF
If lConferida .And. !lDevolucao 
	cQuery += " CROSS APPLY( " + CRLF
	cQuery += "				SELECT " + CRLF
	cQuery += "					TOP 1 " + CRLF
	cQuery += "					B8.B8_DATA DTLOTE, " + CRLF
	cQuery += "					B8.B8_DTVALID DTVALID " + CRLF
	cQuery += "				 FROM " + CRLF
	cQuery += "					" + RetSqlName("SB8") + " B8 " + CRLF
	cQuery += "				 WHERE " + CRLF
	cQuery += "					B8.B8_FILIAL = '" + xFilial("SB8") + "' AND " + CRLF
	cQuery += "					B8.B8_PRODUTO = ZZA.ZZA_CODPRO AND " + CRLF
	cQuery += "					B8.B8_LOTECTL = ZZA.ZZA_NUMLOT AND " + CRLF
	cQuery += "					B8_LOCAL IN('90','80','01','03') AND " + CRLF
	cQuery += "					B8.D_E_L_E_T_ = '' " + CRLF	
	cQuery += "				)LOTEB8	
	//cQuery += "		INNER JOIN " + RetSqlName("SB8") + " B8 ON B8.B8_FILIAL = '" + xFilial("SB8") + "' AND B8.B8_PRODUTO = ZZA.ZZA_CODPRO AND B8.B8_LOTECTL = ZZA.ZZA_NUMLOT AND B8_LOCAL IN ('90','80','01','03') AND B8.D_E_L_E_T_ = '' " + CRLF
Else	 
	cQuery += "		INNER JOIN " + RetSqlName("SD5") + " D5 ON D5.D5_FILIAL = '" + xFilial("SD5") + "' AND D5.D5_PRODUTO = ZZA.ZZA_CODPRO AND D5.D5_LOTECTL = ZZA.ZZA_NUMLOT AND " + CRLF
	cQuery += "												D5.D5_DOC = ZZA.ZZA_NUMNF AND D5.D5_SERIE = ZZA.ZZA_SERIE AND " + CRLF
	cQuery += "												D5.D5_QUANT = ( SELECT " + CRLF 
	cQuery += "																	COUNT(ZZA_B.ZZA_CODPRO) TOTAL " + CRLF 
	cQuery += "																FROM " + CRLF
	cQuery += "																	ZZA010 ZZA_B " + CRLF 
	cQuery += "																WHERE " + CRLF
	cQuery += "																	ZZA_B.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF  
	cQuery += "																	ZZA_B.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
	cQuery += "																	ZZA_B.ZZA_NUMNF = '" + cNFiscal + "' AND " + CRLF
	cQuery += "																	ZZA_B.ZZA_SERIE = '" + cSerie + "' AND " + CRLF
	cQuery += "																	ZZA_B.ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
	cQuery += "																	ZZA_B.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
	cQuery += "																	ZZA_B.D_E_L_E_T_ = '' " + CRLF
	cQuery += "																GROUP BY ZZA_B.ZZA_FILIAL,ZZA_B.ZZA_CODPRO,ZZA_B.ZZA_NUMNF,ZZA_B.ZZA_SERIE,ZZA_B.ZZA_ITEMNF,ZZA_B.ZZA_NUMLOT ) AND " + CRLF  
	cQuery += "												D5.D_E_L_E_T_ = '' " + CRLF
EndIf	
cQuery += "	WHERE " + CRLF 
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cCodProd + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMNF = '" + cNFiscal + "' AND " + CRLF
cQuery += "		ZZA.ZZA_SERIE = '" + cSerie + "' AND " + CRLF
If Empty(cCodPallet)
	cQuery += "		ZZA.ZZA_NUMCX BETWEEN '" + cNumCxDe + "' AND '" + cNumCxAte + "' AND " + CRLF
Else	 
	cQuery += "		ZZA.ZZA_PALLET = '" + cCodPallet + "' AND " + CRLF
EndIF	
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItemNf + "' AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' " + CRLF
If lConferida .And. !lDevolucao	
	//cQuery += "	GROUP BY ZZA.ZZA_CODBAR, ZZA.ZZA_CODPRO, ZZA.ZZA_NUMNF, ZZA.ZZA_ITEMNF, ZZA.ZZA_NUMCX, ZZA.ZZA_NUMLOT, ZZA.ZZA_PALLET,ZZA.R_E_C_N_O_, B1.B1_DESC, B8.B8_DATA, B8.B8_DTVALID " + CRLF
	cQuery += "	GROUP BY ZZA.ZZA_CODBAR, ZZA.ZZA_CODPRO, ZZA.ZZA_NUMNF, ZZA.ZZA_ITEMNF, ZZA.ZZA_NUMCX, ZZA.ZZA_NUMLOT, ZZA.ZZA_PALLET,ZZA.R_E_C_N_O_, B1.B1_DESC, LOTEB8.DTLOTE, LOTEB8.DTVALID " + CRLF
Else
	cQuery += "	GROUP BY ZZA.ZZA_CODBAR, ZZA.ZZA_CODPRO, ZZA.ZZA_NUMNF, ZZA.ZZA_ITEMNF, ZZA.ZZA_NUMCX, ZZA.ZZA_NUMLOT, ZZA.ZZA_PALLET,ZZA.R_E_C_N_O_, B1.B1_DESC, D5.D5_DATA, D5.D5_DTVALID " + CRLF
EndIf	
cQuery += "	ORDER BY ZZA.ZZA_NUMCX "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	Return .F.
EndIf

Return .T.
