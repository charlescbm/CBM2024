#Include "FWBROWSE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE 'FWMVCDEF.CH'

#DEFINE CRLF CHR(13) + CHR(10)

#DEFINE CSSBOTAO 	"QPushButton{ background-color: #58D3F7;";
			   	+=	"color: #A9E2F3 ";
			   	+= 	"font-size: 9px; ";
			   	+= 	"border: 1px solid #BEBEBE; } ";
          		+=	"QPushButton:Focus{ background-color: #FFFAFA; } ";
              	+= 	"QPushButton:Hover{ background-color: #FFFAFA; ";
             	+=	"color: #000000; ";
              	+=  "border: 1px solid #BEBEBE; } "


#DEFINE ITEM		1 
#DEFINE PRODUTO		2
#DEFINE DESCPRO		3
#DEFINE ARMAZEM 	4
#DEFINE QUANT		5
#DEFINE SALDOLT		6
#DEFINE DTALOTE		7
#DEFINE COLVAZIO	8

/*********************************************************************************************/
/*/{Protheus.doc} ICOMA040

@description Rotina para gerar e excluir etiquetas de entrada

@author Crele Cristina - GoOne Consultria
@since 04/07/2023
@version 1.0

@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN - 11/02/2024

User Function ICOMA040(cAlias,nReg,nOpc)

Local cUserAut		:= GetNewPar("TG_CONFUSR","000000")

Private cNFiscal    := Space( TamSX3("F1_DOC")[1] )
Private cSerie      := Space( TamSX3("F1_SERIE")[1] )
Private cCodForn   	:= Space( TamSX3("F1_FORNECE")[1] )
Private cLojForn	:= Space( TamSX3("F1_LOJA")[1] )
Private cChvNFE		:= Space( TamSX3("F1_CHVNFE")[1] )
Private cDescForn	:= Space( TamSX3("A1_NOME")[1] )
Private cCadastro	:= "ETIQUETAS - Conferência de Recebimento" 
Private cSeqCaixa	:= "0001" 

Private oPCenter    := Nil
Private oGrid       := Nil
Private oGetForn	:= Nil
Private oGetLoja	:= Nil

Private aItensNF    := {}

Private lMsErroAuto := .F.
Private lDevolucao	:= .F.
Private lNacional	:= .F.

//---------------------------------------------+
// Valida a alteração de romaneio já encerrado |
//---------------------------------------------+
If !Alltrim(__cUserID) $ Alltrim(cUserAut)
	MsgStop("Usuário não autorizado a utilizar conferencia.","INOVEN - Avisos")
	Return .F.
EndIf

//-------------------+
// Nota de Devolução |
//-------------------+
//If SF1->F1_TIPO == "D" -- alterado pelo Charles para considerar notas de devolução e beneficiamento
If SF1->F1_TIPO $ "D,B"
	lDevolucao := .T.
EndIf	

//--------------------------------------+
// Valida nota produtos mercado interno |
//--------------------------------------+
TgCom01NfNac(@lNacional)

//Begin Transaction

	TAL01Tela(cAlias,nReg,nOpc)

	//------------------+
	// Limpa os setKeys |
	//------------------+
	SetKey( VK_F4, { || } )
	SetKey( VK_F5, { || } )
	SetKey( VK_F6, { || } )
	
//End Transaction

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Tela
Monta a Tela
@author  Victor Andrade
@since   04/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Tela(cAlias,nReg,nOpc)

Local oSize     := FWDefSize():New( .T. )
Local oLayer    := FWLayer():New()
Local aCoors    := FWGetDialogSize( oMainWnd )

Local oPSup		:= Nil
Local oGetNF    := Nil
//Local oBtnEtq   := Nil
//Local oBtnSobr  := Nil
//Local oBtnFalta := Nil
//Local oBtnPalle := Nil
//Local oBtnCanc  := Nil
//Local oBtnFilt	:= Nil

Local aButtons	:= {}

Local _nOpcA	:= 0

oSize:AddObject( "DLG", 100, 100, .T., .T.)
oSize:SetWindowSize(aCoors)
oSize:lProp     := .T.
oSize:lLateral 	:= .T.
oSize:Process()

DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] Title "ETIQUETAS - Conferência Recebimento" OF oMainWnd PIXEL

oLayer:Init( oDlg, .F. )
oLayer:AddLine( "LINE01", 20 )
oLayer:AddLine( "LINE02", 75 )

oLayer:AddCollumn( "DADOSNF", 100,, "LINE01" )
oLayer:AddCollumn( "ITEMS"  , 100,, "LINE02" )

oLayer:AddWindow( "DADOSNF" , "WNDDADOSNF"  , "Dados Nota Fiscal"   , 100 ,.F. ,,,"LINE01" )
oLayer:AddWindow( "ITEMS"   , "WNDITEMS"    , "Itens Nota Fiscal"   , 90  ,.F. ,,,"LINE02" )

oPSup    := oLayer:GetWinPanel( "DADOSNF"   , "WNDDADOSNF"  , "LINE01" )
oPCenter := oLayer:GetWinPanel( "ITEMS"     , "WNDITEMS"    , "LINE02" )

cChvNFE := SF1->F1_CHVNFE
TSay():New( 02, 005, {||"Chave NF"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
TGet():New( 10, 005, {|u|Iif( PCount()==0, cChvNFE, cChvNFE := u) }, oPSup, 150, 009, PesqPict("SF1", "F1_CHVNFE"),/*{ || TAL01Chv() }*/, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cChvNFE" ,,,,.T.)

cNFiscal := SF1->F1_DOC
TSay():New( 02, 175, {||"Nota Fiscal"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
oGetNF := TGet():New( 10, 175, {|u|Iif( PCount() == 0, cNFiscal, cNFiscal := u ) },;
				 oPSup, 045, 009, PesqPict("SF1", "F1_DOC"),, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cNFiscal" ,,,,.T.)
//oGetNF:cF3 := "SF1VEI"

cSerie := SF1->F1_SERIE
TSay():New( 02, 235, {||"Série"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
TGet():New( 10, 235, {|u|Iif( PCount()==0, cSerie, cSerie := u) }, oPSup, 025, 009, PesqPict("SF1", "F1_SERIE"),, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cSerie" ,,,,.T.)

cCodForn := SF1->F1_FORNECE
TSay():New( 02, 295, {||"Fornecedor"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
oGetForn := TGet():New( 10, 295, {|u| Iif( PCount()==0, cCodForn, cCodForn := u) }, oPSup, 035, 009, "@!",/*{ || TAL01Forn() }*/, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cCodForn" ,,,,.T.)
//oGetForn:cF3 := "SA2"

cLojForn := SF1->F1_LOJA
TSay():New( 02, 355, {||"Loja"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
oGetLoja := TGet():New( 10, 355, {|u| Iif( PCount()==0, cLojForn, cLojForn := u) }, oPSup, 020, 009, "@!", /*{ || TAL01Forn() }*/, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cLojForn" ,,,,.T.)

cDescForn := GetADVFVal( "SA2", "A2_NOME", xFilial( "SA2" ) + SF1->F1_FORNECE + SF1->F1_LOJA, 1 )
TSay():New( 02, 415, {||"Descrição"},oPSup,,,,,,.T.,,,400,300,,,,,,.F.)
TGet():New( 10, 415, {|u| cDescForn }, oPSup, 100, 009, "@!",, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .T., .F. ,,"cDescForn" ,,,,.T.)

//---------------+
// Itens da Nota |
//---------------+
TAL01Grid()

//-------------------+
// Cria Linhas aCols |
//-------------------+
TAL01Filter()


//aAdd(aButtons, {"NOTE", { || TAL01Mark( oGrid:At() ) }, "(F4) Efetuar Conferência", "(F4) Efetuar Conferência" } )
aAdd(aButtons, {"NOTE", { || TAL40Etq() }, "Impressão", "Impressão" } )

//SetKey( VK_F4, { || TAL01Mark( oGrid:At() ) } )
//SetKey( VK_F5, { || TAL01Etq() } )

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , { || _nOpcA := 1, oDlg:End() } , { || oDlg:End() } , , aButtons ) CENTERED

/*If _nOpcA == 1
	
	FWMsgRun(, {|| TAL01TOK() }, "Processando", "Gravando dados..." )
	
EndIf*/

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Grid
Monta a estrutura da GRID
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Grid()
Local nI

DEFINE FWBROWSE oGrid DATA ARRAY ARRAY aItensNF NO SEEK NO CONFIG NO REPORT NO LOCATE Of oPCenter

oGrid:AddStatusColumns( { || BrwStatus() }, { || BrwLegend() } )

ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),1] } 	Title "Item"        PICTURE PesqPict("ZZA","ZZA_ITEMNF") SIZE 8  Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),2] } 	Title "Produto"     PICTURE PesqPict("ZZA","ZZA_CODPRO") SIZE 12 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),3] } 	Title "Descrição"   PICTURE PesqPict("SB1","B1_DESC")    SIZE 35 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),4] }	Title "Quantidade"  PICTURE PesqPict("SD1","D1_QUANT")   SIZE 11 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),5] } 	Title "Valor" 	    PICTURE PesqPict("ZZA","ZZA_VLRUNI") SIZE 10 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),6] } 	Title "Lote" 	    PICTURE PesqPict("ZZA","ZZA_NUMLOT") SIZE 10 Of oGrid
//ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),7] } 	Title "Falta" 	    PICTURE PesqPict("ZZA","ZZA_PERDA")  SIZE 12 Of oGrid
//ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),8] } 	Title "Sobra" 	    PICTURE PesqPict("ZZA","ZZA_SOBRA")  SIZE 12 Of oGrid
ADD MARKCOLUMN oColumn DATA { || IIf( aItensNF[oGrid:At(),7],'LBOK','LBNO') } DOUBLECLICK { || TAL01Mark(oGrid:At()) } Of oGrid

//------------------------------------------------+
// Força o nome na coluna que tem a opção do Mark |
//------------------------------------------------+
oGrid:aColumns[8]:cTitle := "Ação"

//oGrid:SetBlkBackColor( { || Iif( aItensNF[ oGrid:At() ][9] .And. aItensNF[ oGrid:At() ][10], CLR_HGRAY, Nil ) } )
//oGrid:SetBlkColor( { || Iif( aItensNF[ oGrid:At() ][9] .And. aItensNF[ oGrid:At() ][10], CLR_BLACK, Nil ) } )
//oGrid:SetBlkBackColor( { || Iif( aItensNF[ oGrid:At() ][9], CLR_HGRAY, Nil ) } )
//oGrid:SetBlkColor( { || Iif( aItensNF[ oGrid:At() ][9], CLR_BLACK, Nil ) } )

//oGrid:AddLegend( "aItensNF[oGrid:At(),8] == .T.", "GREEN",  "Registro do Tipo 1" )
//oGrid:AddLegend( "aItensNF[oGrid:At(),8] == .F.", "RED",    "Registro do Tipo 2" )

ACTIVATE FWBrowse oGrid

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Mark
Inverte a Marcação da linha
@author  Victor Andrade
@since   05/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Mark( nLinha )

Local lMark 		:= aItensNF[ nLinha, 7 ]
//Local lMark 		:= aItensNF[ nLinha, 8 ]
Local lPerSob		:= .F.
Local nPerSob		:= 0
Local nQtdPerSob	:= 0
Local nPosTela		:= 0
Local cDescr		:= ""

//--------------------------------------+
// Verifica se o pallet já está fechado |
//--------------------------------------+
//If !lMark
		
	nPerSob := TAFAviso( "Atenção", "Define a ação a ser feita com as etiquetas", { "GERAR", "EXCLUIR", "Cancelar" }, 2 )
	If nPerSob == 1 
		if aItensNF[ nLinha, 8 ]
			MsgStop("ATENÇÃO! Etiqueta já existe. Geração Inválida","Inoven - Avisos")
		else
			If MsgYesNo("Confirma a geração de novas etiquetas para este item [ITEM " + aItensNF[ nLinha, 1 ] + "] ?")
				
    			FWMsgRun(, {|oSay| fIncZZA(oSay, nLinha) }, "Gerando...", "Gerando novas etiquetas...")
     				
			endif
		endif
			
	ElseIf nPerSob == 2	//Exclir etiquetas
	
		if !aItensNF[ nLinha, 9 ]
			MsgStop("ATENÇÃO! Etiqueta já expedida ou não existe. Exclusão Inválida","Inoven - Avisos")
		else
			If MsgYesNo("Confirma a exclusão das etiquetas deste item [ITEM " + aItensNF[ nLinha, 1 ] + "] ?")
				
    			FWMsgRun(, {|oSay| fDelZZA(oSay, nLinha) }, "Excluindo...", "Excluindo etiquetas...")
     				
			endif

		endif

	EndIf

oGrid:Refresh()

Return(.T.)


//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Filter
Filtra a ZZA de acordo com a nota informada e apresenta a GRID
@author  Victor Andrade
@since   05/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Filter()

Local aArea 		:= GetArea()
//Local cNextAlias 	:= ""
Local aItemNF		:= {}

//--------------+
// Reseta Array |
//--------------+
aItensNF			:= {}

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
		aItemNF	:= {}
		
		//------------------------------+
		// Somente itens não conferidos |
		//------------------------------+
		//If SD1->D1_XSTATUS == "2"
		//	SD1->( dbSkip() )
		//	Loop
		//EndIf
		
		//-------------------+
		// Posiciona Produto |
		//-------------------+
		SB1->( dbSeek(xFilial("SB1") + SD1->D1_COD) )
		
		//--------------------+
		// Posiciona Etiqueta | 
		//--------------------+
		lExclui := .F.
		lEtq := .F.
		if ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SD1->D1_ITEM) )
			lEtq := .T.
			lExclui := iif(!empty(ZZA->ZZA_NFSAID), .F., .T.)
		endif
		
		aAdd( aItemNF, 	SD1->D1_ITEM 										)
		aAdd( aItemNF, 	SD1->D1_COD 										) 
		aAdd( aItemNF, 	SB1->B1_DESC 										) 
		aAdd( aItemNF, 	SD1->D1_QUANT 										)
		aAdd( aItemNF, 	SD1->D1_VUNIT 										)
		aAdd( aItemNF, 	SD1->D1_LOTECTL 									)
		//aAdd( aItemNF, 	Iif( ZZA->ZZA_CONFER , ZZA->ZZA_PERDA, 0) 			)
		//aAdd( aItemNF, 	Iif( ZZA->ZZA_CONFER , ZZA->ZZA_SOBRA, 0)	 		)
		//aAdd( aItemNF, 	ZZA->ZZA_CONFER										)
		aAdd( aItemNF, 	.F.										)
		aAdd( aItemNF, 	lEtq										)
		aAdd( aItemNF, 	lExclui										)
		aAdd( aItemNF, 	iif(lEtq,ZZA->( Recno() ),0) 									)
			
		aAdd( aItensNF, aItemNF )
		
		SD1->( dbSkip() )
		
	EndDo
Else
	MsgAlert( "Não foram encontrados registros com os parâmetros informados.", "Atenção" )
EndIf

//---------------+
// Atualiza GRID |
//---------------+
If ValType(oGrid) == "O"
	oGrid:SetArray( aItensNF )
	oGrid:GoTop()
	oGrid:Refresh()
	oPCenter:Refresh()
EndIf

RestArea( aArea )
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} fIncZZA
GERACAO DAS ETIQUETAS
@author  Crele Cristina - GoOne Consultoria
@since   05/07/2023
@version 1
/*/
//-------------------------------------------------------------------
Static Function fIncZZA(oSay, nLinha)

Local cSeq		:= "001"

	SD1->( dbSetOrder( 1 ) )
	if SD1->( DbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + aItensNF[ nLinha, 2 ] + aItensNF[ nLinha, 1 ] ) ) )

        //------------------------------------------+
        // Valida a quantidade de caixas por Pallet |
        //------------------------------------------+
        nVolPallet := 0
        If SB5->( dbSeek(xFilial("SB5") + SD1->D1_COD) )
        	nVolPallet := SB5->B5_XPALLET
        EndIf
        
        lGerou 		:= .T.        
        nCount 		:= 1
        nPallet		:= 1
        nQtdPallet	:= Int(SD1->D1_QUANT/nVolPallet)
        cNPallet	:= ""
        If nQtdPallet > 0
        	cNPallet	:= StrZero(Val(SF1->F1_DOC),7) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
        EndIf	
                
        While SD1->D1_QUANT >= nCount 

            RecLock( "ZZA", .T. )
                ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
                ZZA->ZZA_CODPRO	:= SD1->D1_COD
                ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + SD1->D1_COD, 1 )
                ZZA->ZZA_QUANT  := 1
                ZZA->ZZA_VLRUNI := SD1->D1_VUNIT
                ZZA->ZZA_NUMNF  := SF1->F1_DOC
                ZZA->ZZA_SERIE  := SF1->F1_SERIE
                ZZA->ZZA_FORNEC := SF1->F1_FORNECE
                ZZA->ZZA_LOJA   := SF1->F1_LOJA
                ZZA->ZZA_NUMCX  := StrZero(nCount,4)
                ZZA->ZZA_NUMLOT := SD1->D1_LOTECTL
                ZZA->ZZA_ITEMNF := SD1->D1_ITEM
                ZZA->ZZA_LOCENT := SD1->D1_LOCAL
                ZZA->ZZA_PALLET	:= cNPallet	
                ZZA->ZZA_BAIXA	:= "1"
                ZZA->ZZA_CONFER	:= .F.
            ZZA->( MsUnlock() )
            
			oSay:SetText("Caixa " + ZZA->ZZA_NUMCX)

            //------------------------------+
            // Valida se preencheu o Pallet |
            //------------------------------+
            If nPallet == nVolPallet .And. nQtdPallet <> 0
            	nPallet 	:= 0
            	cSeq		:= Soma1(cSeq)
            	cNPallet	:= StrZero(Val(SF1->F1_DOC),7) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
            	nQtdPallet--
            ElseIf nQtdPallet == 0
            	cNPallet	:= ""
            EndIf	
            
            //-----------------+
            // Contador Rotina |
            //-----------------+
            nCount++
            nPallet++
                        
        EndDo

		aItensNF[ nLinha, 8 ] := .T.
		aItensNF[ nLinha, 9 ] := .T.
		MsgStop("Etiquetas Geradas com Sucesso!","Inoven - Avisos")
	endif

RETURN

//-------------------------------------------------------------------
/*/{Protheus.doc} fDelZZA
EXCLUSAO DAS ETIQUETAS
@author  Crele Cristina - GoOne Consultoria
@since   05/07/2023
@version 1
/*/
//-------------------------------------------------------------------
Static Function fDelZZA(oSay, nLinha)

	ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + aItensNF[ nLinha, 1 ]) )
	While !ZZA->(eof()) .and. ZZA->ZZA_FILIAL == xFilial('ZZA') .and. ZZA->ZZA_NUMNF + ZZA->ZZA_SERIE + ZZA->ZZA_FORNEC + ZZA->ZZA_LOJA + ZZA->ZZA_ITEMNF == SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + aItensNF[ nLinha, 1 ]
		oSay:SetText("Caixa " + ZZA->ZZA_NUMCX)
		ZZA->(reclock('ZZA', .F.))
		ZZA->(dbDelete())
		ZZA->(msUnlock())
		ZZA->(dbSkip())
	end
	aItensNF[ nLinha, 8 ] := .F.
	aItensNF[ nLinha, 9 ] := .F.
	MsgStop("Etiquetas Excluídas!","Inoven - Avisos")

RETURN


/************************************************************************************/
/*/{Protheus.doc} TgCom01NfNac
@description Valida se nota contem produtos adquiridos no mercado interno 
@author Bernard M. Margarido
@since 07/06/2020
@version 1.0
@param lNacional, logical, descricao
@type function
/*/
/************************************************************************************/
Static Function TgCom01NfNac(lNacional)
Local _aArea	:= GetArea()

//---------------------------------+
// Valida se fornecedor é nacional | 
//---------------------------------+
If SF1->F1_EST <> "EX"
	lNacional := .T.
EndIf

RestArea(_aArea)
Return Nil

//Static Function ValidMark()
//Local lRet := .F.

//----------------------------------------------------------
Static Function BrwStatus()
//Return Iif(ValidMark(),"BR_VERDE","BR_VERMELHO")
Return Iif(aItensNF[oGrid:At(),8],"BR_VERDE","BR_VERMELHO")

Static Function BrwLegend()
Local oLegend := FWLegend():New()

oLegend:Add("","BR_VERDE" , "Etq. Gerada" ) 
oLegend:Add("","BR_VERMELHO", "Etq. Não Gerada" ) 
oLegend:Activate()
oLegend:View()
oLegend:DeActivate()

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} 

Monta a tela de perguntas ...
@author  Victor Andrade
@since   09/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL40Input( cDescr, nQuant, nPosTela )

Local oDlg		:= Nil	
Local oBtnOk	:= Nil
Local oBtnCanc	:= Nil
Local oGet		:= Nil
Local oSay		:= Nil

Local cGet		:= Space(45)

Local nGet		:= 0
Local nOpcA		:= 0

Local lRet		:= .T.

Default nQuant	:= 0
Default nPosTela:= 0
	
	//-------------------------------------------------------------------
	// Monta dialog para inserção do valor
	//-------------------------------------------------------------------
	DEFINE MSDIALOG oDlg TITLE "TOTVS" FROM 000, 000  TO 100, 300 PIXEL
	nGet := nQuant
    @ 006, 005 SAY oSay PROMPT cDescr SIZE 142, 007 OF oDlg PIXEL
    If nPosTela == 7
    	@ 018, 005 MSGET oGet VAR cGet SIZE 142, 010 PICTURE PesqPict( "ZZA", "ZZA_PALLET" ) OF oDlg PIXEL
    Else
    	@ 018, 005 MSGET oGet VAR nGet SIZE 142, 010 PICTURE PesqPict( "ZZA", "ZZA_PERDA" ) OF oDlg PIXEL
    EndIf	

	DEFINE SBUTTON oBtnOk FROM 034, 090 TYPE 01 OF oDlg ENABLE ACTION ( nOpcA := 1,oDlg:End() )
	DEFINE SBUTTON oBtnCanc FROM 034, 120 TYPE 02 OF oDlg ENABLE ACTION ( IIF( nPosTela == 7,( lRet:= .F., oDlg:End()),oDlg:End()) )
	//DEFINE SBUTTON oBtnCanc FROM 034, 120 TYPE 02 OF oDlg ENABLE ACTION ( ( lRet:= .F., oDlg:End()) )
    
  	ACTIVATE MSDIALOG oDlg CENTERED
  	
  	If nOpcA == 1 .And. nPosTela == 7
  		//---------------------------+
  		// Leitura de Etiqueta sobra | 
  		//---------------------------+
  		lRet := DelEtqSobra(cGet)
  	ElseIf nOpcA == 1 .And. nPosTela == 8
  		//----------------------------------+
  		// Gerar etiqueta????               |
  		//----------------------------------+
  		//lRet := GerEtqFalt(nGet)
  		lRet := .T.
  	ElseIf nOpcA == 0
  		nGet := 0
  		lRet := .F.	
  	EndIf
  	
Return( IIF( nPosTela == 7,lRet,nGet) )

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL40Etq
Efetua a chamada da rotina de impressão de etiquetas
@author  Crele Cristina
@since   09/02/2024
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL40Etq()

Local nQtdPrint 	:= 0
Local cImpressora	:= Space( TamSX3("CB5_CODIGO")[1] )
Local nAt			:= oGrid:nAt

Default nQtdFlt		:= 0

//---------------------------------+
// Chamar a impressão de etiquetas |
//---------------------------------+
If aItensNF[nAt,8]

	nQtdPrint := TAL40Input( "Informe a baixo a quantidade de etiquetas que deseja Imprimir",IIF(nQtdFlt == 0,aItensNF[nAt][4],nQtdFlt), ,.T., cImpressora )

	If nQtdPrint <= 0
		MsgAlert( "Quantidade informada deve ser maior que zero.", "Atenção" ) 
	ElseIf nQtdPrint > aItensNF[ nAt, 4 ]
		MsgAlert( "Quantidade informada é maior que a quantidade da nota fiscal.", "Atenção" ) 
	Else
		//----------------------------------------+
		// Chama rotina de impressão de etiquetas |
		//----------------------------------------+
		FWMsgRun(, {|| U_ICOMR010( aItensNF[nAt], SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, nQtdPrint ) }, "Processando", "Imprimindo Etiquetas..." )
		
	EndIf

Else
	MsgAlert( "Etiqueta ainda não gerada!", "Atenção" )
EndIf

Return
