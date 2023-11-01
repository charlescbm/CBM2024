#INCLUDE "FWBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE MAXGETDAD 99999
#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE CLR_CINZA RGB(230,230,230)

/*******************************************************************************************/
/*/{Protheus.doc} IEXPA050

@description Rotina de reimpressao de etiqueta de volume

@author Bernard M. Margarido
@since 05/07/2018
@version 1.0
@type function
/*/
/*******************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPA050(_nRecno)
Local aArea			:= GetArea()

Local oSize     	:= FWDefSize():New( .T. )
Local oLayer    	:= FWLayer():New()
Local oDlg			:= Nil
Local oTBtnPrint	:= Nil
Local oTBtnExit 	:= Nil

Local aCoors    	:= FWGetDialogSize( oMainWnd )

Private oPCenter    := Nil
Private oGrid       := Nil

Private aNFRom    	:= {}

//--------------------+
// Posiciona Registro |
//--------------------+
dbSelectArea("ZZD")
ZZD->( dbGoTo(_nRecno) )

oSize:AddObject( "DLG", 100, 100, .T., .T.)
oSize:SetWindowSize(aCoors)
oSize:lProp     := .T.
oSize:lLateral 	:= .T.
oSize:Process()

//-----------------------+
// Carrega Itens da Nota |
//-----------------------+
IEXPA050It()

//----------------------------------+
// Valida se contem notas expedidas |
//----------------------------------+
If Len(aNFRom) <= 0
	MsgStop("Não há notas conferidas para o Romaneio " + ZZD->ZZD_CODIGO + " .")
	RestArea(aArea)
	Return .T.
EndIf

DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3] - 100, oSize:aWindSize[4] - 300 Title "Reimpressão Etiquetas" OF oMainWnd PIXEL

	oLayer:Init( oDlg, .F. )
	oLayer:AddLine( "LINE01", 100 )
	oLayer:AddCollumn( "INFO"  	, 100,, "LINE01" )
	oLayer:AddWindow( "INFO"	, "FWINFO"  , "Notas Romaneio"   	, 90 	,.F. ,,,"LINE01" )
	oPCenter := oLayer:GetWinPanel( "INFO"  , "FWINFO"		, "LINE01" )
		
	//-------------------+
	// Cria Header Itens |
	//-------------------+
	IEXPA050Gr()	
	
	//-----------------------+
	// Painel para os Botoes | 
	//-----------------------+
	oPnlBtn := TPanel():New(000,000,"",oDlg,Nil,.T.,.F.,Nil,CLR_CINZA,000,022,.T.,.F.)
	oPnlBtn:Align := CONTROL_ALIGN_BOTTOM
				
	oTBtnPrint := TButton():New( 003, 480, "Imprimir",oPnlBtn,{|| IEXPA050Re(),oDlg:End() }	, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )
	oTBtnExit  := TButton():New( 003, 530, "Cancelar",oPnlBtn,{|| oDlg:End() }				, 40,15,,,.F.,.T.,.F.,,.F.,,,.F. )

ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

Return .T.

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
