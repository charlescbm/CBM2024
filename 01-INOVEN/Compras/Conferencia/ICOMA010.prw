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
/*/{Protheus.doc} TALCOM01

@description Conferencia Recebimento

/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function ICOMA010()

Local cFiltro	:= ""
Local pFiltro    	:= { "Nao Conferidas","Conferidas", "Conferidas Parcial", "Todas" }
Local aParam		:= {}
Local nFiltro       := 4

Private oBrowse	:= Nil
Private aRotina	:= MenuDef()

Private aRecFalt:= {}
Private aRecSobr:= {}	

Public	lSobra	:= .F.

IF PARAMBOX( {	{3,"Filtrar Notas",1,pFiltro,80,"",.T.};
                }, "Defina os parametros para o Filtro", @aParam,,,,,,,,.F.,.T.)

	nFiltro := mv_par01
else
	nFiltro := 4	//Todos
Endif


//-----------------------------+
// Consulta por transportadora |
//-----------------------------+
SetKey( VK_F6,	{|| U_ICOMA020() } )

//--------+
// Filtro |
//--------+ 
//cFiltro := "(SF1->F1_XSTATUS $ '1/2' .And. SF1->F1_TIPO == 'N' .And. SF1->F1_EST = 'EX') .Or. (SF1->F1_XSTATUS $ '1/2' .And. SF1->F1_TIPO == 'D') "
Do Case
Case nFiltro == 1; cFiltro := "SF1->F1_XSTATUS == '1' .And. SF1->F1_CHVNFE <> ' ' .And. SF1->F1_TIPO $ 'N/D/B'"
	Case nFiltro == 2; cFiltro := "SF1->F1_XSTATUS == '2' .And. SF1->F1_CHVNFE <> ' ' .And. SF1->F1_TIPO $ 'N/D/B'"
	Case nFiltro == 3; cFiltro := "SF1->F1_XSTATUS == '3' .And. SF1->F1_CHVNFE <> ' ' .And. SF1->F1_TIPO $ 'N/D/B'"
	Case nFiltro == 4; cFiltro := "SF1->F1_XSTATUS $ '1/2/3'.And. SF1->F1_CHVNFE <> ' ' .And. SF1->F1_TIPO $ 'N/D/B'"
EndCase

//---------------------------------+
// Instanciamento da Classe Browse |
//---------------------------------+
oBrowse := FWMBrowse():New()

//------------------+
// Tabela utilizado |
//------------------+
oBrowse:SetAlias("SF1")

//-------------------+
// Adiciona Legendas |
//-------------------+
oBrowse:AddLegend("F1_XSTATUS == '1'"	,"RED"					,"Não Conferida")
oBrowse:AddLegend("F1_XSTATUS == '2'"	,"GREEN"				,"Conferida")
oBrowse:AddLegend("F1_XSTATUS == '3'"	,"YELLOW"				,"Conferida Parcial")

//------------------+
// Titulo do Browse |
//------------------+
oBrowse:SetDescription('Conferencia Recebimento')

//----------------+
// Filtro Browser |
//----------------+
oBrowse:SetFilterDefault( cFiltro )

//--------------------+
// Ativação do Browse |
//--------------------+
oBrowse:Activate()	

//------------------+
// Limpa os setKeys |
//------------------+
SetKey( VK_F6, { || } )

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} TALCOM01
Tela de Conferência de Recebimentos
@author  Victor Andrade
@since   04/04/2018
@version 1
/*/
//-------------------------------------------------------------------
User Function TGCOMA01(cAlias,nReg,nOpc)

Local cUserAut		:= GetNewPar("TG_CONFUSR","000000")

Private cNFiscal    := Space( TamSX3("F1_DOC")[1] )
Private cSerie      := Space( TamSX3("F1_SERIE")[1] )
Private cCodForn   	:= Space( TamSX3("F1_FORNECE")[1] )
Private cLojForn	:= Space( TamSX3("F1_LOJA")[1] )
Private cChvNFE		:= Space( TamSX3("F1_CHVNFE")[1] )
Private cDescForn	:= Space( TamSX3("A1_NOME")[1] )
Private cCadastro	:= "Conferência de Recebimento" 
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

//------------------------------+
// Somente notas nao conferidas |
//------------------------------+
If SF1->F1_XSTATUS == "2"
	MsgAlert("Nota já conferida.")
	Return .T.
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

Begin Transaction

	TAL01Tela(cAlias,nReg,nOpc)

	//------------------+
	// Limpa os setKeys |
	//------------------+
	SetKey( VK_F4, { || } )
	SetKey( VK_F5, { || } )
	SetKey( VK_F6, { || } )
	
End Transaction

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

DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] Title "Conferência Recebimento" OF oMainWnd PIXEL

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

aAdd(aButtons, {"NOTE", { || TAL01Mark( oGrid:At() ) }, "(F4) Efetuar Conferência", "(F4) Efetuar Conferência" } )
aAdd(aButtons, {"NOTE", { || TAL01Etq(cNFiscal,cSerie,cCodForn,cLojForn) }, "(F5) Impressão Etiquetas", "(F5) Impressão Etiquetas" } )
aAdd(aButtons, {"NOTE", { || TAL01Lote(cNFiscal,cSerie,cCodForn,cLojForn) }, "(F6) Ajusta Lote/Validade", "(F6) Ajusta Lote/Validade" } )

SetKey( VK_F4, { || TAL01Mark( oGrid:At() ) } )
SetKey( VK_F5, { || TAL01Etq() } )
SetKey( VK_F6, { || TAL01Lote(cNFiscal,cSerie,cCodForn,cLojForn) } )

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , { || _nOpcA := 1, oDlg:End() } , { || oDlg:End() } , , aButtons ) CENTERED

If _nOpcA == 1
	//Begin Transaction
		FWMsgRun(, {|| TAL01TOK() }, "Processando", "Gravando dados..." )
	//End Transaction 
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Grid
Monta a estrutura da GRID
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Grid()

DEFINE FWBROWSE oGrid DATA ARRAY ARRAY aItensNF NO SEEK NO CONFIG NO REPORT NO LOCATE Of oPCenter

ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),1] } 	Title "Item"        PICTURE PesqPict("ZZA","ZZA_ITEMNF")    /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 8  Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),2] } 	Title "Produto"     PICTURE PesqPict("ZZA","ZZA_CODPRO")   	/*DOUBLECLICK { || TAL01Etq() }*/ SIZE 12 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),3] } 	Title "Descrição"   PICTURE PesqPict("SB1","B1_DESC")       /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 35 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),4] }	Title "Quantidade"  PICTURE PesqPict("SD1","D1_QUANT")     /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 11 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),5] } 	Title "Valor" 	    PICTURE PesqPict("ZZA","ZZA_VLRUNI")  	/*DOUBLECLICK { || TAL01Etq() }*/ SIZE 10 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),6] } 	Title "Lote" 	    PICTURE PesqPict("ZZA","ZZA_NUMLOT")  	/*DOUBLECLICK { || TAL01Etq() }*/ SIZE 10 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),7] } 	Title "Falta" 	    PICTURE PesqPict("ZZA","ZZA_PERDA")     /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 12 Of oGrid
ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),8] } 	Title "Sobra" 	    PICTURE PesqPict("ZZA","ZZA_SOBRA")     /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 12 Of oGrid
//ADD COLUMN oColumn DATA { || aItensNF[oGrid:At(),9] } 	Title "Troca" 	    PICTURE PesqPict("ZZA","ZZA_SOBRA")     /*DOUBLECLICK { || TAL01Etq() }*/ SIZE 12 Of oGrid
ADD MARKCOLUMN oColumn DATA { || IIf( aItensNF[oGrid:At(),9],'LBOK','LBNO') } DOUBLECLICK { || TAL01Mark(oGrid:At()) } Of oGrid
//ADD MARKCOLUMN oColumn DATA { || IIf( aItensNF[oGrid:At(),8],'LBOK','LBNO') } DOUBLECLICK { || TAL01Mark(oGrid:At()) } Of oGrid

//------------------------------------------------+
// Força o nome na coluna que tem a opção do Mark |
//------------------------------------------------+
oGrid:aColumns[09]:cTitle := "Conferido?"
//oGrid:aColumns[08]:cTitle := "Conferido?"

oGrid:SetBlkBackColor( { || Iif( aItensNF[ oGrid:At() ][09] .And. aItensNF[ oGrid:At() ][10], CLR_HGRAY, Nil ) } )
oGrid:SetBlkColor( { || Iif( aItensNF[ oGrid:At() ][09] .And. aItensNF[ oGrid:At() ][10], CLR_BLACK, Nil ) } )
//oGrid:SetBlkBackColor( { || Iif( aItensNF[ oGrid:At() ][8] .And. aItensNF[ oGrid:At() ][9], CLR_HGRAY, Nil ) } )
//oGrid:SetBlkColor( { || Iif( aItensNF[ oGrid:At() ][8] .And. aItensNF[ oGrid:At() ][9], CLR_BLACK, Nil ) } )

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

Local lMark 		:= aItensNF[ nLinha, 9 ]
//Local lMark 		:= aItensNF[ nLinha, 8 ]
Local lPerSob		:= .F.
Local nPerSob		:= 0
Local nQtdPerSob	:= 0
Local nPosTela		:= 0
Local cDescr		:= ""

//--------------------------------------+
// Verifica se o pallet já está fechado |
//--------------------------------------+
If !lMark
		
	//nPerSob := TAFAviso( "Atenção", "Houve Falta/Sobra de Produto?", { "Sobra", "Falta", "Nenhum", "Cancelar" }, 2 )
	//nPerSob := TAFAviso( "Atenção", "Houve Falta de Produto?", { "Falta", "Nenhum", "Cancelar" }, 2 )
	nPerSob := TAFAviso( "Atenção", "Houve Falta de Produto?", { "Falta", "Sobra", "Nenhum", "Cancelar" }, 2 )
	If nPerSob == 1 
		nPosTela 	:= 7
		//cDescr		:= "Leitura Etiquetas de Sobra"
		//If MsgYesNo("Deseja efetuar a leitura das etiquetas de sobra?")
		cDescr	:= "Quantidade Etiquetas Faltantes "
		If MsgYesNo("Deseja efetuar a leitura das etiquetas dos produtos faltantes?")
			lRet 		:= .T.
			lSobra		:= .T.
			nQtdPerSob	:= 0
			While lRet
				lRet := TAL01Input( cDescr,,nPosTela )
				nQtdPerSob += IIF(lRet,1,0)
			EndDo
			aItensNF[ nLinha, 7 ]	:= nQtdPerSob			
			//aItensNF[ nLinha, 8 ] 	:= .T.
			aItensNF[ nLinha, 9 ] 	:= .T.
		EndIf	
		
	ElseIf nPerSob == 2	//nPerSob == 9	
	
		nPosTela := 8
		//nPosTela 	:= 7
		cDescr	:= "Produtos Sobrando "
		
		nQtdPerSob := TAL01Input( cDescr,,nPosTela )
		
		if !empty(nQtdPerSob)
			aItensNF[ nLinha, 8 ]	:= nQtdPerSob
			aItensNF[ nLinha, 9 ] 	:= .T.
		endif
		//aItensNF[ nLinha, 7 ]	:= nQtdPerSob
		//aItensNF[ nLinha, 8 ] 	:= .T.
														
	ElseIf nPerSob == 3	//nPerSob == 2
		//aItensNF[ nLinha, 8 ] := .T.
		aItensNF[ nLinha, 9 ] := .T.
	EndIf
Else
	If MsgYesNo( "Registro já conferido, deseja estornar? ", "Atenção" )
		//------------------------------------------+	
		// Verifica se já foi informado algum valor |
		//------------------------------------------+
		//If ( aItensNF[ nLinha, 7 ] > 0 ) .Or. ( aItensNF[ nLinha, 8 ] )
		If ( aItensNF[ nLinha, 7 ] > 0 ) .Or. ( aItensNF[ nLinha, 9 ] )
			//------------------------------------------+
			// Verifica se o valor informado é de sobra |
			//------------------------------------------+
			//If ( aItensNF[ nLinha, 7 ] > 0 )
			//	lPerSob := .T.
			//EndIf
			//If MsgYesNo( "Já foram informados quantidade de " + Iif( lPerSob, "sobra", "falta" ) + " de mercadoria. " + Chr(10) + Chr(13) +;
			If MsgYesNo( "Já foram informados quantidade de falta de mercadoria. " + Chr(10) + Chr(13) +;
						 "Ao estornar, os valores serão zerados. " + Chr(10) + Chr(13) + "Deseja Continuar?" , "Atenção" )
				
				//----------------+
				// Estorna sobras | 
				//----------------+
				//If lPerSob
					TgComDelS()
				//----------------+
				// Estorna faltas |
				//----------------+	
				//Else
				//	TgComDelF()
				//EndIf
				
				aItensNF[ nLinha, 7 ] := 0
				//aItensNF[ nLinha, 8 ] := 0
				aItensNF[ nLinha, 9 ] := .F.
				//aItensNF[ nLinha, 8 ] := .F.

			EndIf
		Else
			aItensNF[ nLinha, 9 ] := .F.
			//aItensNF[ nLinha, 8 ] := .F.
		EndIf
	EndIf
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
		If SD1->D1_XSTATUS == "2"
			SD1->( dbSkip() )
			Loop
		EndIf
		
		//-------------------+
		// Posiciona Produto |
		//-------------------+
		SB1->( dbSeek(xFilial("SB1") + SD1->D1_COD) )
		
		//--------------------+
		// Posiciona Etiqueta | 
		//--------------------+
		ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SD1->D1_ITEM) )
		
		aAdd( aItemNF, 	SD1->D1_ITEM 										)
		aAdd( aItemNF, 	SD1->D1_COD 										) 
		aAdd( aItemNF, 	SB1->B1_DESC 										) 
		aAdd( aItemNF, 	SD1->D1_QUANT 										)
		aAdd( aItemNF, 	SD1->D1_VUNIT 										)
		aAdd( aItemNF, 	SD1->D1_LOTECTL 									)
		aAdd( aItemNF, 	Iif( ZZA->ZZA_CONFER , ZZA->ZZA_PERDA, 0) 			)
		aAdd( aItemNF, 	Iif( ZZA->ZZA_CONFER , ZZA->ZZA_SOBRA, 0)	 		)
		//aAdd( aItemNF, 	Iif( !empty(SD1->D1_PRODTRO) , 1, 0)		 		)
		aAdd( aItemNF, 	ZZA->ZZA_CONFER										)
		aAdd( aItemNF, 	ZZA->( Recno() ) 									)
			
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
/*/{Protheus.doc} 

Monta a tela de perguntas ...
@author  Victor Andrade
@since   09/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Input( cDescr, nQuant, nPosTela )

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
  		lRet := GerEtqFalt(nGet)
  	ElseIf nOpcA == 0
  		nGet := 0
  		lRet := .F.	
  	EndIf
  	
Return( IIF( nPosTela == 7,lRet,nGet) )
//Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Etq
Efetua a chamada da rotina de impressão de etiquetas
@author  Victor Andrade
@since   06/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Etq(cNFiscal,cSerie,cCodForn,cLojForn,nQtdFlt)

Local nQtdPrint 	:= 0
Local cImpressora	:= Space( TamSX3("CB5_CODIGO")[1] )
Local nAt			:= oGrid:nAt

Default nQtdFlt		:= 0

//---------------------------------+
// Chamar a impressão de etiquetas |
//---------------------------------+
If !aItensNF[nAt][09]
//If !aItensNF[nAt][8]

	nQtdPrint := TAL01Input( "Informe a baixo a quantidade de etiquetas que deseja Imprimir",IIF(nQtdFlt == 0,aItensNF[nAt][4],nQtdFlt), ,.T., cImpressora )

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
	MsgAlert( "Registro já conferido!", "Atenção" )
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Forn
Atualiza o GET read-only com o nome do fornecedor
@author  Victor Andrade
@since   09/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Forn()

Local aArea 	:= GetArea()
Local lRet		:= .F.

DbSelectArea( "SA2" )
SA2->( DbSetOrder( 1 ) )

If !Empty( cCodForn ) .And. !Empty( cLojForn )
	
	If SA2->( DbSeek( xFilial( "SA2" ) + cCodForn + cLojForn, .T. ) )
		lRet	  := .T.
		cDescForn := SA2->A2_NOME
	Else
		cLojForn := Space( TamSX3("A1_LOJA")[1] )
	EndIf

ElseIf !Empty( cCodForn )
	
	If SA2->( DbSeek( xFilial( "SA2" ) + cCodForn, .T. ) )
		lRet	  := .T.
		cDescForn := SA2->A2_NOME
	Else
		cCodForn := Space( TamSX3("A1_COD")[1] )
	EndIf

Else
	lRet := .T.
EndIf

If !lRet
	Alert( "Fornecedor não encontrado.", "Atenção" )
	oGetForn:Refresh()
	oGetLoja:Refresh()
	oGetForn:SetFocus()
EndIf

RestArea( aArea )

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01TOK
Executa as gravações ao confirmar a tela
@author  Victor Andrade
@since   09/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01TOK()

Local aArea 	:= GetArea()
Local nI		:= 0
Local aSobra	:= {}
Local aPerda	:= {}
Local aVenda	:= {}
Local aItemNFN	:= {}

Local lContinua	:= .T.
Local lParcial	:= .F.
Local _lDiff	:= .F.

//---------------------------------------------------+
// Valida se todos os itens da nota foram conferidos | 
//---------------------------------------------------+
FWMsgRun(, {|| Tal01TVldLi(@lParcial) }, "Processando", "Validando se todos os itens foram conferidos." )

//-----------------------------------------------------------------------+
// Rotina aglutina produtos e lotes iguais para realizar a transferencia |
//-----------------------------------------------------------------------+
FWMsgRun(, {|| Tal01TAglu(@aItemNFN) }, "Processando", "Validando itens da nota." )

lWf := .F.
For nI := 1 To Len( aItemNFN )
	
	_lDiff	:= .F.
	
	//-------------------------------------------------------------------------------------------------------------+
	// Desconsidera os registros que já foram processados e só considera os que foram informado o código do PALLET |
	//-------------------------------------------------------------------------------------------------------------+
	If aItemNFN[nI][09]
	//If aItemNFN[nI][8]

		//----------------------------------------------+
		// utilizado para transferir ao amazém de venda |
		//----------------------------------------------+
		aAdd( aVenda, aItemNFN[nI] )
		
		//-----------+
		// Sobra ... |
		//-----------+	
		If aItemNFN[nI][8] > 0 .And. aItemNFN[nI][09] 
			_lDiff	:= .T.
			aAdd( aSobra, aItemNFN[nI] )
		//-----------+	
		// Falta ... |
		//-----------+	
		ElseIf aItemNFN[nI][7] > 0 .And. aItemNFN[nI][09]	
		//ElseIf aItemNFN[nI][7] > 0 .And. aItemNFN[nI][8]	
		//If aItemNFN[nI][7] > 0 .And. aItemNFN[nI][8]	
		 	_lDiff	:= .T.
			aAdd( aPerda, aItemNFN[nI] )
		EndIf
		
		//-----------------+
		// Grava diferença |
		//-----------------+
		If _lDiff	
			TgCom01Dif(aItemNFN[nI])

			if !lWf

				If File("\workflow\divergencia_conf.htm")
					lWf := .T.

					oProcess := TWFProcess():New("000001", OemToAnsi("Divergencias Conferencia Nota"))
					oProcess:NewTask("000001", "\workflow\divergencia_conf.htm")
					
					oProcess:cSubject 	:= "Divergencias Conferencia Nota " + SF1->F1_SERIE + "/" + SF1->F1_DOC
					oProcess:bTimeOut	:= {}
					oProcess:fDesc 		:= "Divergencias Conferencia Nota " + SF1->F1_SERIE + "/" + SF1->F1_DOC
					oProcess:ClientName(cUserName)
					oHTML := oProcess:oHTML

					cNome := ''
					if !(SF1->F1_TIPO $ "D|B")
						SA2->(dbSetOrder(1))
						SA2->(msSeek(xFilial('SA2') + SF1->F1_FORNECE + SF1->F1_LOJA))
						cNome := alltrim(SA2->A2_NOME)
					else
						SA1->(dbSetOrder(1))
						SA1->(msSeek(xFilial('SA1') + SF1->F1_FORNECE + SF1->F1_LOJA))
						cNome := alltrim(SA1->A1_NOME)
					ENDIF

					oHTML:ValByName('divdoc', SF1->F1_SERIE + "/" + SF1->F1_DOC)
					oHTML:ValByName('divtipo', SF1->F1_TIPO)
					oHTML:ValByName('divcodigo', SF1->F1_FORNECE + " - " + SF1->F1_LOJA)
					oHTML:ValByName('divforne', cNome)
					oHTML:ValByName('divemis', SF1->F1_DTDIGIT)
					oHTML:ValByName('dtbase', dDataBase)

				endif

			endif

			if lWf
				SB1->(dbSetOrder(1))
				SB1->(msSeek(xFilial('SB1') + aItemNFN[nI][2]))

				AAdd(oProcess:oHtml:ValByName('it.item'), aItemNFN[nI][1])
				AAdd(oProcess:oHtml:ValByName('it.produto'), "&nbsp;" + alltrim(aItemNFN[nI][2]) + alltrim(SB1->B1_DESC))
				AAdd(oProcess:oHtml:ValByName('it.valor'), 'R$ ' + transform(aItemNFN[nI][5],"@E 999,999,999.99")+"&nbsp;")
				AAdd(oProcess:oHtml:ValByName('it.qtnota'), transform(aItemNFN[nI][4],PesqPict("SD1","D1_QUANT")))
				AAdd(oProcess:oHtml:ValByName('it.falta'), iif(aItemNFN[nI][7] > 0, transform(aItemNFN[nI][7],PesqPict("SD1","D1_QUANT")), 0))
				AAdd(oProcess:oHtml:ValByName('it.sobra'), iif(aItemNFN[nI][7] <= 0, transform(aItemNFN[nI][8],PesqPict("SD1","D1_QUANT")), 0))
			endif

		EndIf
		
	EndIf

Next nI

if lWf
	oProcess:cTo := GetNewPar("IN_WFDIVNF", "charlesbattisti@gmail.com")			
	//oProcess:cTo := "crelec@gmail.com"
			
	// Inicia o processo
	oProcess:Start()
	// Finaliza o processo
	oProcess:Finish()					
endif

//--------+
// Vendas |
//--------+
If Len( aVenda ) > 0 .And. lContinua
	FWMsgRun(, {|| lContinua := TAL01Venda( aVenda ) }, "Processando", "Transferindo Mercadoria para armazém de vendas" )
EndIf

//--------+
// Sobras |
//--------+	
If Len( aSobra ) > 0 .And. lContinua
	FWMsgRun(, {|| lContinua := TAL01Sobra( aSobra ) }, "Processando", "Apontando Sobras de Mercadoria..." )
EndIf

//--------+
// Perdas |
//--------+
If Len( aPerda ) > 0 .And. lContinua
	FWMsgRun(, {|| lContinua := TAL01Perda( aPerda ) }, "Processando", "Apontando Perdas de Mercadoria..." )
EndIf

//--------------------+
// Atualiza Etiquetas |
//--------------------+
If lContinua
	
	//-------------------------+
	// Atualiza Status da Nota | 
	//-------------------------+
	dbSelectArea("SF1")
	SF1->( dbSetOrder(1) )
	SF1->( dbSeek(xFilial("SF1") + cNFiscal + cSerie + cCodForn + cLojForn) )
	RecLock("SF1",.F.)
		//SF1->F1_XSTATUS := IIF(lParcial,"1","2")
		SF1->F1_XSTATUS := IIF(lParcial,"3","2")
	SF1->( MsUnLock() )
	
	//--------------------+
	// Posiciona Etiqueta | 
	//--------------------+
	dbSelectArea("ZZA")
	ZZA->( dbSetOrder(1) )
	ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	While ZZA->( !Eof() .And. xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == ZZA->ZZA_FILIAL + ZZA->ZZA_NUMNF + ZZA->ZZA_SERIE + ZZA->ZZA_FORNEC + ZZA->ZZA_LOJA)
		RecLock("ZZA",.F.)
			ZZA->ZZA_CONFER := IIF(lParcial,.F.,.T.)
		ZZA->( MsUnLock() )
		ZZA->( dbSkip() )
	EndDo	
	
EndIf

RestArea( aArea )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Perda
Transfere a perda para seu devido armazém
@author  Victor Andrade
@since   09/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Perda( aItens )

Local cArmazem		:= GetNewPar( "ES_ARMPERD","02", )
Local cArmTran		:= GetNewPar( "ES_ARMTRAN","90", )
//Local cArmTNac		:= GetNewPar( "ES_ARMTNAC")
Local cArmDev		:= GetNewPar( "ES_ARMDEV","04", )
Local cArmPNac		:= GetNewPar( "ES_ARMPNAC","02",)
Local cArmTrf		:= ""
Local cArmDest		:= ""
Local cDocumento	:= GetSxeNum( "SD3","D3_DOC", 1 )
Local aAuto			:= {}
Local aItem			:= {}
Local aArea			:= GetArea()
Local nI			:= 0
//Local lTransf		:= .F.
Local lRet			:= .T.

aAdd( aAuto, { cDocumento, dDataBase } )

//-------------------+
// Posiciona Armazem |
//-------------------+
dbSelectArea( "SB2" )
SB2->( dbSetOrder( 1 ) )

//-------------------+
// Posiciona Produto |
//-------------------+
dbSelectArea("SB1")
SB1->( dbSetOrder(1) )

//----------------+
// Posiciona Lote | 
//----------------+
dbSelectArea("SB8")
SB8->( dbSetOrder(3) )

//---------------------+
// Valida Tipo de Nota |
//---------------------+
If lDevolucao
	cArmTrf	:= cArmDev
Else
	cArmTrf	:= cArmTran
EndIf

If lNacional 
	cArmDest := cArmPNac
Else
	cArmDest := cArmazem
EndIf

For nI := 1 To Len( aItens )
	
	//--------------------------+
	// Valida se existe armazem |
	//--------------------------+
	If !SB2->( dbSeek( xFilial( "SB2" ) + aItens[nI][2] + cArmDest ) )
		CriaSB2( aItens[nI][2], cArmDest )
	EndIf
	
	//-------------------+
	// Posiciona Produto |
	//-------------------+
	SB1->( dbSeek(xFilial("SB1") + aItens[nI][2] ) )
	
	//----------------+
	// Posiciona Lote |
	//----------------+
	If SB8->( dbSeek(xFilial("SB8") + aItens[nI][2] + cArmTrf + aItens[nI][6]) )
		dDtaValid := SB8->B8_DTVALID	
	Else
		dDtaValid := MonthSum( dDataBase, SB1->B1_XDTVALI)
	EndIf
	
	//-----------------------+
	// Limpa a cada iteração |
	//-----------------------+
	aItem := {} 

	aAdd( aItem, aItens[nI][2]		) 	// 01. Codigo Produto 
	aAdd( aItem, SB1->B1_DESC		) 	// 02. Desrição Produto 
	aAdd( aItem, SB1->B1_UM			)	// 03. Unidade Medida 
	aAdd( aItem, cArmTrf			) 	// 04. Armazem de Origem
	aAdd( aItem, ""					)	// 05. Localização  
	aAdd( aItem, aItens[nI][2]		) 	// 06. Codigo do Produto	
	aAdd( aItem, SB1->B1_DESC		)  	// 07. Descrição do Produto
	aAdd( aItem, SB1->B1_UM			) 	// 08. Unidade de Medida
	aAdd( aItem, cArmDest			)	// 09. Armazem de Destino
	aAdd( aItem, ""					) 	// 10. Endereco de Destino 
	aAdd( aItem, ""					)	// 11. Numero de Serie 
	aAdd( aItem, aItens[nI][6]		)	// 12. Lote
	aAdd( aItem, ""					)	// 13. SubLote
	aAdd( aItem, dDtaValid      	) 	// 14. Data de Validade Lote
	aAdd( aItem, 0					) 	// 15. Potencia do Lote	
	aAdd( aItem, aItens[nI][7]		) 	// 16. Quantidade Transferida
	aAdd( aItem, 0					) 	// 17. Quantidade Segunda Unidade de Medida
	aAdd( aItem, ""					) 	// 18. Estorno
	aAdd( aItem, ""					) 	// 19. Numero Sequencia Documento
	aAdd( aItem, ""					) 	// 20. Lote Destino 
	aAdd( aItem, dDtaValid			) 	// 21. Data de Validade do Lote Destino 
	//aAdd( aItem, ""					) 	// 22. Numero do Lote Destino
	aAdd( aItem, ""					) 	// 23. Item Grade
	aAdd( aItem, ""					) 	// 24. Observacao

	aAdd( aAuto, aItem )

Next nI

lMsErroAuto := .F.

MSExecAuto( { |x,y| MATA261( x,y ) }, aAuto, 3 )

If lMsErroAuto
	RollBackSXE()
	MostraErro()
	DisarmTransaction()
	lRet := .F.
Else
	lRet := .T.
	ConfirmSX8()
	//----------------------------------+
	// Envia e-mail comunicando a Perda |
	//----------------------------------+
	U_ICOMA030( aItens, cNFiscal, cSerie, cCodForn, cLojForn, cDescForn )
EndIf

RestArea( aArea )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Sobra
Gera a movimentação interna adicionando a quantidade de sobra em seu devido armazém
@author  Victor Andrade
@since   11/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Sobra( aSobra )

Local aArea 	:= GetArea()
Local aCab		:= {}
Local aItem		:= {}
Local aItens	:= {}

Local cNumDoc	:= GetSxeNum( "SD3", "D3_DOC", Nil )
Local cTM		:= GetNewPar( "ES_TM" )
//Local cArmSobra	:= GetNewPar( "ES_ARMSOBR" )
Local cArmPerda	:= GetNewPar( "ES_ARMPERD" )
Local cArmazem	:= GetNewPar( "ES_ARMVEND")
Local cArmTNac	:= GetNewPar( "ES_ARMTNAC")
//Local cArmSobNac:= GetNewPar( "ES_ARMSNAC")

Local nX		:= 0

Local lRet		:= .T.

//---------------------+
// Valida Tipo de Nota |
//---------------------+
If lDevolucao
	cArmTrf	:= cArmPerda
Else
	If lNacional
		cArmTrf	:= cArmTNac
	Else
		cArmTrf	:= cArmazem
	EndIf 
EndIf

//-------------------+
// Posiciona Armazem |
//-------------------+
dbSelectArea( "SB2" )
SB2->( dbSetOrder( 1 ) )

//-------------------+
// Posiciona Produto |
//-------------------+
dbSelectArea("SB1")
SB1->( dbSetOrder(1) )

aCab := {	{ "D3_FILIAL"	, xFilial( "SD3" ) 	,	Nil},;
            { "D3_DOC" 		, cNumDoc			,	Nil},;
            { "D3_TM" 		, cTM 				,	Nil},;
			{ "D3_EMISSAO"	, dDataBase 		,	Nil},;
			{ "D3_CC"       , ""      			,	Nil} }

For nX := 1 To Len( aSobra )
	
	//--------------------------+
	// Valida se existe armazem |
	//--------------------------+
	If !SB2->( DbSeek( xFilial( "SB2" ) + aSobra[nX][2] + cArmTrf ) )
		CriaSB2( aSobra[nX][2], cArmTrf )
	EndIf
	
	//--------------------+
	// Posiciona Produto  |
	//--------------------+
	SB1->( dbSeek(xFilial("SB1") + aSobra[nX][2]) )
		
	aAdd( aItem,	{ "D3_COD"		,	aSobra[nX][2] 			,	Nil } )
	aAdd( aItem,	{ "D3_QUANT"	,	aSobra[nX][8]  			,	Nil } )
	aAdd( aItem,	{ "D3_UM"		,	SB1->B1_UM				,	Nil } )
	aAdd( aItem,	{ "D3_TIPO"		,	SB1->B1_TIPO	  		,	Nil } )
	aAdd( aItem,	{ "D3_LOCAL"	,	cArmTrf 				,	Nil } )
	aAdd( aItem,	{ "D3_GRUPO"	,	SB1->B1_GRUPO 			,	Nil	} )
	aAdd( aItem,	{ "D3_IDENT"	,	ProxNum()				,	Nil	} )
	aAdd( aItem,	{ "D3_NUMSEQ"	,	ProxNum()				,	Nil	} ) 
	aAdd( aItem,	{ "D3_USUARIO"	,	SubStr(cUsuario,7,10) 	,	Nil } )
	aAdd( aItem,	{ "D3_XMOTIVO"	, '000014'				 	,	Nil } )
	aAdd( aItem,	{ "D3_LOTECTL"	,	aSobra[nX][6]		 	,	Nil } )
	aAdd( aItens, aItem )

Next nX

lMsErroAuto := .F.

MSExecAuto( {| x,y,z | MATA241( x, y, z ) }, aCab, aItens, 3 )    

If lMsErroAuto
	RollBackSXE()
	MostraErro()
	DisarmTransaction()
	lRet := .F. 
Else
	lRet := .T.
	ConfirmSX8()
EndIf

RestArea( aArea )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Venda
Transfere a mercadoria do Armazém intermediário para o armazém de venda
@author  Victor Andrade
@since   18/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Venda( aItens )

Local aArea			:= GetArea()
Local aAuto			:= {}
Local aItem			:= {}

Local cArmazem		:= GetNewPar( "ES_ARMVEND",, )
Local cArmTran		:= GetNewPar( "ES_ARMTRAN","90", )
Local cArmDev		:= GetNewPar( "ES_ARMDEV","04", )
Local cArmNac		:= GetNewPar( "ES_ARMVNAC","04", )
Local cArmTNac		:= GetNewPar( "ES_ARMTNAC")
Local cArmTrf		:= ""
Local cArmDest		:= ""
Local cDocumento	:= GetSxeNum( "SD3", "D3_DOC", 1 )

Local nI			:= 0
Local nQtdTransf	:= 0

//Local lTransf		:= .F.
Local lRet			:= .T.

aAdd( aAuto, { cDocumento, dDataBase } )

//-------------------+
// Posiciona Armazem |
//-------------------+
dbSelectArea( "SB2" )
SB2->( dbSetOrder( 1 ) )

//-------------------+
// Posiciona Produto |
//-------------------+
dbSelectArea("SB1")
SB1->( dbSetOrder(1) )

//----------------+
// Posiciona Lote | 
//----------------+
dbSelectArea("SB8")
SB8->( dbSetOrder(3) )

//---------------------+
// Valida Tipo de Nota |
//---------------------+

//-------------------+
// Armazem de Origem | 
//-------------------+
If lDevolucao
	cArmTrf	:= cArmDev
ElseIf lNacional 
	cArmTrf	:= cArmTNac
Else
	cArmTrf	:= cArmTran
EndIf

//--------------------+
// Armazem de destino |
//--------------------+
If lNacional 
	cArmDest := cArmNac
Else
	cArmDest := cArmazem
EndIf
xArmDest := cArmDest	//guarda o armazem destino que foi definido

For nI := 1 To Len( aItens )

	//-------------------------+
	// Busca armazem de origem | 
	//-------------------------+
	If lDevolucao
		TgCom01Ori(aItens[nI][1],aItens[nI][2],@cArmDest)
		xArmDest := cArmDest	//guarda o armazem destino que foi definido
	EndIf 

	//--------------------+
	// Posiciona Produto  |
	//--------------------+
	SB1->( dbSeek(xFilial("SB1") + aItens[nI][2]) )

	if alltrim(SB1->B1_TIPO) $ "MP|PI"
		cArmDest := GetNewPar( "IN_ARMINSU","06", )
	else
		cArmDest := xArmDest
	endif

	//--------------------------+
	// Valida se existe armazem |
	//--------------------------+
	If !SB2->( DbSeek( xFilial( "SB2" ) + aItens[nI][2] + cArmDest ) )
		CriaSB2( aItens[nI][2], cArmDest )
	EndIf
	
	//----------------+
	// Posiciona Lote |
	//----------------+
	If SB8->( dbSeek(xFilial("SB8") + aItens[nI][2] + cArmTrf + aItens[nI][6]) )
		dDtaValid := SB8->B8_DTVALID	
	Else
		dDtaValid := MonthSum( dDataBase, SB1->B1_XDTVALI)
	EndIf
	
	//-----------------------+
	// Limpa a cada iteração |
	//-----------------------+
	aItem 		:= {} 
	nQtdTransf	:= aItens[nI][4] - aItens[nI][7]

	IF nQtdTransf > 0 
	
		aAdd( aItem, aItens[nI][2]		) 	// 01. Codigo Produto 
		aAdd( aItem, SB1->B1_DESC		) 	// 02. Desrição Produto 
		aAdd( aItem, SB1->B1_UM			)	// 03. Unidade Medida 
		aAdd( aItem, cArmTrf			) 	// 04. Armazem de Origem
		aAdd( aItem, ""					)	// 05. Localização  
		aAdd( aItem, aItens[nI][2]		) 	// 06. Codigo do Produto	
		aAdd( aItem, SB1->B1_DESC		)  	// 07. Descrição do Produto
		aAdd( aItem, SB1->B1_UM			) 	// 08. Unidade de Medida
		aAdd( aItem, cArmDest			)	// 09. Armazem de Destino
		aAdd( aItem, ""					) 	// 10. Endereco de Destino 
		aAdd( aItem, ""					)	// 11. Numero de Serie 
		aAdd( aItem, aItens[nI][6]		)	// 12. Lote
		aAdd( aItem, ""					)	// 13. SubLote
		aAdd( aItem, dDtaValid      	) 	// 14. Data de Validade Lote
		aAdd( aItem, 0					) 	// 15. Potencia do Lote	
		aAdd( aItem, nQtdTransf			)	// 16. Quantidade Transferida
		aAdd( aItem, 0					) 	// 17. Quantidade Segunda Unidade de Medida
		aAdd( aItem, ""					) 	// 18. Estorno
		aAdd( aItem, ""					) 	// 19. Numero Sequencia Documento
		aAdd( aItem, ""					) 	// 20. Lote Destino 
		aAdd( aItem, dDtaValid			) 	// 21. Data de Validade do Lote Destino 
		//aAdd( aItem, ""					) 	// 22. Numero do Lote Destino
		aAdd( aItem, ""					) 	// 23. Item Grade
		aAdd( aItem, ""					) 	// 24. Observacao
	
		aAdd( aAuto, aItem )
	ENDIF

Next nI

lMsErroAuto := .F.

If Len(aAuto) >= 2
	If Len(aAuto[2]) > 0
		MSExecAuto( { |x,y| MATA261( x,y ) }, aAuto, 3 )
		
		If lMsErroAuto
			RollBackSXE()
			MostraErro()
			DisarmTransaction()
			lRet := .F.
		Else
			lRet := .T.
			ConfirmSX8()
		EndIf
	EndIf
EndIf

RestArea( aArea )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL01Chv
Valida a chave da Nota Fiscal
@author  Victor Andrade
@since   18/02/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL01Chv()

Local aArea := GetArea()
Local lRet	:= .F.

If !Empty( cChvNFE )
	SF1->( DbSetOrder( 8 ) )
	If SF1->( DbSeek( xFilial( "SF1" ) + cChvNFE ) )
		lRet		:= .T.
		cNFiscal    := SF1->F1_DOC
		cSerie      := SF1->F1_SERIE
		cCodForn   	:= SF1->F1_FORNECE
		cLojForn	:= SF1->F1_LOJA
		cDescForn	:= GetADVFVal( "SF1", "A1_NOME", xFilial( "SF1" ) + SF1->( F1_FORNECE + F1_LOJA ), 1, "" )
	Else
		MsgAlert( "Registro não encontrado." )
	EndIf
EndIf

RestArea( aArea )

Return( lRet )

/************************************************************************************/
/*/{Protheus.doc} DelEtqSobra

@description Deleta sobra 

@author Bernard M. Margrido
@since 13/06/2018
@version 1.0

@param cGet, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function DelEtqSobra(cGet)
Local aArea		:= GetArea()

Local lRet		:= .T.

Local cCodBar	:= SubStr(cGet,1,13)
Local cProd		:= SubStr(cGet,14,4)
Local cDoc		:= SubStr(cGet,18,9)
Local cItem		:= SubStr(cGet,27,4)
Local cNumCx	:= SubStr(cGet,31,4)
Local cLote		:= SubStr(cGet,35,10)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT "
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA 
cQuery += "	FROM 
cQuery += "		" + RetSqlName("ZZA") + " ZZA" 
cQuery += "	WHERE 
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND 
cQuery += "		ZZA.ZZA_CODPRO = '" + cProd + "' AND 
cQuery += "		ZZA.ZZA_CODBAR = '" + cCodBar + "' AND 
cQuery += "		ZZA.ZZA_NUMNF = '" + cDoc + "'  AND 
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItem + "'  AND
cQuery += "		ZZA.ZZA_NUMCX = '" + cNumCx + "' AND 
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND 
cQuery += "		ZZA.D_E_L_E_T_ = '' 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	MsgAlert("Etiqueta não encontrada.")
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
EndIf

//---------------------+
// Posicioana Registro | 
//---------------------+
dbSelectArea("ZZA")
ZZA->( dbSetOrder(1))
ZZA->( dbGoTop())
ZZA->( dbGoTo((cAlias)->RECNOZZA) )
If ZZA->ZZA_BAIXA	== "2"
	MsgAlert("Etiqueta já lida.")
	lRet := .F.
Else
	RecLock("ZZA",.F.)
		ZZA->ZZA_PERDA 	:= 1
		ZZA->ZZA_CONFER	:= .T.
		ZZA->ZZA_BAIXA	:= "1"
	ZZA->( MsUnLock() )
	
	aAdd(aRecSobr,ZZA->(Recno()))
	
	//MsgAlert("Etiqueta lida com sucesso.")
	
EndIf	

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return lRet

/**********************************************************************************************/
/*/{Protheus.doc} GerEtqFalt

@description Gera etiquetas que faltaram

@author Bernard M. Margarido
@since 26/06/2018
@version 1.0

@param nGet	, numeric, descricao

@type function
/*/
/**********************************************************************************************/
Static Function GerEtqFalt(nGet)
Local aArea		:= GetArea()

Local cNumCx	:= ""
Local cSeq		:= ""
Local cNPallet	:= ""
Local cArmTran	:= GetNewPar( "ES_ARMTRAN","90", )
Local cArmDev	:= GetNewPar( "ES_ARMDEV","04", )
Local cArmTrf	:= ""

Local nLinPrd	:= oGrid:At()
Local nEtqSem	:= 0
Local nTotEtq	:= 0
Local nPallet	:= 0
Local nVolPallet:= 0	
Local nQtdPallet:= 0
Local nX		:= 0

Local lRet		:= .T.

//---------------------+
// Valida Tipo de Nota |
//---------------------+
If lDevolucao
	cArmTrf	:= cArmDev
Else
	cArmTrf	:= cArmTran
EndIf

//--------------+
// Reseta array | 
//--------------+
aRecFalt	:= {}

//-----------------------------------+
// Valida se tem etiqueta sem pallet |
//-----------------------------------+
TgEtqSPl(aItensNF[nLinPrd][1],aItensNF[nLinPrd][2],aItensNF[nLinPrd][6],@nEtqSem)

//-----------------------------------+
// Valida se tem etiqueta sem pallet |
//-----------------------------------+
TgEtqPlt(aItensNF[nLinPrd][1],aItensNF[nLinPrd][2],aItensNF[nLinPrd][6],@cSeq)

//-------------------------------+
// Valida ultimo numero da Caixa |
//-------------------------------+
TgEtqCaixa(aItensNF[nLinPrd][1],aItensNF[nLinPrd][2],aItensNF[nLinPrd][6],@cNumCx)

//------------------------------------------+
// Valida a quantidade de caixas por Pallet |
//------------------------------------------+
nVolPallet := 0
If SB5->( dbSeek(xFilial("SB5") + aItensNF[nLinPrd][2]) )
	nVolPallet := SB5->B5_XPALLET
EndIf

nVolPallet	:= nVolPallet

nTotEtq		:= IIF(lDevolucao, nGet ,nGet + nEtqSem)         
nQtdPallet	:= Int(nTotEtq / nVolPallet)
If nQtdPallet > 0 
	nPallet		:= 1	
	cNPallet	:= PadL(Alltrim(cNFiscal),7,"0") + PadL(Alltrim(cSerie),3,"0") + cSeq
EndIf	

For nX := 1 To nGet
		
	 RecLock( "ZZA", .T. )
        ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
        ZZA->ZZA_CODPRO	:= aItensNF[nLinPrd][2]
        ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + aItensNF[nLinPrd][2], 1 )
        ZZA->ZZA_QUANT  := 1
        ZZA->ZZA_VLRUNI := aItensNF[nLinPrd][5]
        ZZA->ZZA_NUMNF  := cNFiscal
        ZZA->ZZA_SERIE  := cSerie
        ZZA->ZZA_FORNEC := cCodForn
        ZZA->ZZA_LOJA   := cLojForn
        ZZA->ZZA_NUMCX  := cNumCx
        ZZA->ZZA_NUMLOT := aItensNF[nLinPrd][6]
        ZZA->ZZA_ITEMNF := aItensNF[nLinPrd][1]
        ZZA->ZZA_LOCENT := cArmTrf
        ZZA->ZZA_PALLET	:= cNPallet
        ZZA->ZZA_BAIXA	:= "1"	
        ZZA->ZZA_CONFER	:= .F.
    ZZA->( MsUnlock() )
    
    //-------------------------+
    // Adiciona Recno Etiqueta |
    //-------------------------+
    aAdd(aRecFalt,ZZA->(Recno()))
        
    //------------------------------+
    // Valida se preencheu o Pallet |
    //------------------------------+
    If nPallet == nVolPallet .And. nQtdPallet <> 0
    	nPallet 	:= 1
    	cSeq		:= Soma1(cSeq)
    	cNPallet	:= PadL(Alltrim(cNFiscal),7,"0") + PadL(Alltrim(cSerie),3,"0") + cSeq
    	nQtdPallet--
    ElseIf nQtdPallet == 0
    	cNPallet	:= ""
    EndIf	
    
    //----------+
    // Contator |
    //----------+
	nPallet++
	cNumCx := Soma1( RTrim(cNumCx) )
	
Next nX

//-----------------------------------+
// Realiza a impressão das etiquetas |
//-----------------------------------+
If MsgYesNo("Deseja Imprimir etiquetas?")
	U_ICOMR030(cNFiscal,cSerie,cCodForn,cLojForn,nGet,aRecFalt)
EndIf

RestArea(aArea)
Return lRet

/************************************************************************************/
/*/{Protheus.doc} RetUtlCx

@description Retorna ultimo numero da Caixa

@author Bernard M. Margarido
@since 13/06/2018
@version 1.0

@param cItem	, characters, descricao
@param cProduto	, characters, descricao
@param cLote	, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function TgEtqCaixa(cItem,cProduto,cLote,cNumCx)
Local aArea		:= GetArea()

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT " + CRLF
cQuery += "		MAX(ZZA.ZZA_NUMCX) ZZA_NUMCX " + CRLF 
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cProduto + "' AND " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItem + "'  AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .T.
EndIf

//---------------------+
// Posicioana Registro | 
//---------------------+
cNumCx := Soma1( RTrim((cAlias)->ZZA_NUMCX) ) 

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T. 

/************************************************************************************/
/*/{Protheus.doc} TgEtqPlt

@description Retorna ultima sequencia pallet

@author Bernard M. Margarido
@since 26/06/2018
@version 1.0

@param cItem		, characters, descricao
@param cProduto		, characters, descricao
@param cLote		, characters, descricao
@param cSeq			, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function TgEtqPlt(cItem,cProduto,cLote,cSeq)
Local aArea		:= GetArea()

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT " + CRLF
cQuery += "		MAX(ZZA.ZZA_PALLET) ZZA_PALLET " + CRLF 
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cProduto + "' AND " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItem + "'  AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.ZZA_PALLET <> '' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .T.
EndIf

//---------------------+
// Posicioana Registro | 
//---------------------+
cSeq := Soma1(SubStr((cAlias)->ZZA_PALLET,11,3)) 

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgEtqSPl

@description Valida etiquetas sem pallet

@author Bernard M. Margarido
@since 26/06/2018
@version 1.0

@param cItem	, characters, descricao
@param cProduto	, characters, descricao
@param cLote	, characters, descricao
@param nPallet	, numeric, descricao
@type function
/*/
/************************************************************************************/
Static Function TgEtqSPl(cItem,cProduto,cLote,nEtqSem)
Local aArea		:= GetArea()

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT " + CRLF
cQuery += "		COUNT(ZZA.ZZA_PALLET) ZZA_PALLET " + CRLF 
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_CODPRO = '" + cProduto + "' AND " + CRLF
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItem + "'  AND " + CRLF
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND " + CRLF
cQuery += "		ZZA.ZZA_PALLET = '' AND " + CRLF
cQuery += "		ZZA.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .T.
EndIf

//---------------------+
// Posicioana Registro | 
//---------------------+
nEtqSem := (cAlias)->ZZA_PALLET 

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgComDelS

@description Estorna as sobras

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgComDelS()
Local aArea		:= GetArea()
Local nX 		:= 0

For nX := 1 To Len(aRecSobr)
	ZZA->( dbGoTo(aRecSobr[nX]) )
	RecLock("ZZA",.F.)
		ZZA->ZZA_PERDA 	:= 0
		ZZA->ZZA_CONFER	:= .F.
		ZZA->ZZA_BAIXA	:= "1"
	ZZA->( MsUnLock() )
Next nX 

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgComDelF

@description Estorna etiquetas de falta

@author Bernard M. Margarido
@since 11/07/2018
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgComDelF()
Local aArea		:= GetArea()
Local nX 		:= 0

For nX := 1 To Len(aRecFalt)
	ZZA->( dbGoTo(aRecFalt[nX]) )
	RecLock("ZZA",.F.)
		ZZA->( dbDelete() )
	ZZA->( MsUnLock() )
Next nX 

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} Tal01TAglu

@description Valida itens duplicados no Array

@author Bernard M. Margarido
@since 17/09/2018
@version 1.0
@param aItensNF	, array, descricao
@type function
/*/
/************************************************************************************/
Static Function Tal01TAglu(aItemNFN)
Local nDupl	:= 0
Local nX	:= 0

For nX := 1 To Len(aItensNF)
	nDupl := aScan(aItemNFN,{|x| RTrim(x[2]) + RTrim(x[6]) == RTrim(aItensNF[nX][2]) + RTrim(aItensNF[nX][6]) })
	If nDupl > 0 
		aItemNFN[nDupl][4] += aItensNF[nX][4]	// Quantidade de Itens
		aItemNFN[nDupl][7] += aItensNF[nX][7]	// Quantidade de Perdas	//Sobras
		//aItemNFN[nDupl][8] += aItensNF[nX][8]	// Quantidade de Perdas
	Else
		/*aAdd( aItemNFN,{	aItensNF[nX][1]	,;	// Item da Nota
							aItensNF[nX][2]	,;	// Produto
							aItensNF[nX][3]	,;	// Descricao Produto
							aItensNF[nX][4] ,;	// Quantidade
							aItensNF[nX][5] ,;	// Valor Unitario
							aItensNF[nX][6]	,;	// Lote
							aItensNF[nX][7]	,;	// Sobra
							aItensNF[nX][8]	,;	// Perda
							aItensNF[nX][9]	,;	// Conferido
							aItensNF[nX][10]})	// Recno */
		aAdd( aItemNFN,{	aItensNF[nX][1]	,;	// Item da Nota
							aItensNF[nX][2]	,;	// Produto
							aItensNF[nX][3]	,;	// Descricao Produto
							aItensNF[nX][4] ,;	// Quantidade
							aItensNF[nX][5] ,;	// Valor Unitario
							aItensNF[nX][6]	,;	// Lote
							aItensNF[nX][7]	,;	// Perda
							aItensNF[nX][8]	,;	// Sobra
							aItensNF[nX][9]	,;	// Conferido
							aItensNF[nX][10]})	// Recno
	EndIf 
Next nX

Return .T.

/************************************************************************************/
/*/{Protheus.doc} Tal01TVldLi

@description Valida se todos os itens foram conferidos

@author Bernard M. Margarido
@since 15/01/2019
@version 1.0
@type function
/*/
/************************************************************************************/
Static Function Tal01TVldLi(lParcial)
Local _nX := 1

//-------------------------+
// Atualiza Status da Nota | 
//-------------------------+
dbSelectArea("SD1")
SD1->( dbSetOrder(1) )

For _nX := 1 To Len(aItensNF)

	If !aItensNF[_nX][09]
	//If !aItensNF[_nX][8]
	  	lParcial := .T.
	EndIf
	
	If SD1->( dbSeek(xFilial("SF1") + cNFiscal + cSerie + cCodForn + cLojForn + aItensNF[_nX][2] + aItensNF[_nX][1]) )
		RecLock("SD1",.F.)
			SD1->D1_XSTATUS := IIF(aItensNF[_nX][09],"2","1")
			//SD1->D1_XSTATUS := IIF(aItensNF[_nX][8],"2","1")
		SD1->( MsUnLock() )
	EndIf 
	 
Next _nX

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TAL01Lote

@description Rotina - realiza a alteração do lote de data de validade 

@author Bernard M. Margarido
@since 11/07/2019
@version 1.0
@type function
/*/
/************************************************************************************/
Static Function TAL01Lote(cNFiscal,cSerie,cCodForn,cLojForn)
Local _aArea		:= GetArea()
Local _aCoors   	:= FWGetDialogSize( oMainWnd )
//Local _aButtons		:= {}

Local _cTitulo  	:= "Acerto - Lote / Data"
Local _cUsrLote		:= GetNewPar("TG_USRLOTE","000000")

Local _nOpcA		:= 0

Local _oSize    	:= FWDefSize():New( .T. )
Local _oLayer   	:= FWLayer():New()
Local _oDlg     	:= Nil
//Local _oFolder		:= Nil
Local _oPCab		:= Nil
Local _oPItem		:= Nil

Private aHeadD1		:= {}
Private aColsD1		:= {}
Private aAlterD1	:= {}
Private aEnchoice	:= {}
Private _aLoteAlt	:= {}

Private _oMsGetLot	:= Nil	

If !__cUserID $ _cUsrLote
	MsgStop("Usuário sem acesso.","Inoven - Avisos")
	RestArea(_aArea)
	Return .T.
EndIf

//--------------------------+
// Header Lotes X Etiquetas | 
//--------------------------+
TGC01Head(cNFiscal,cSerie,cCodForn,cLojForn)

//-----------------+
// Dados Cabeçalho |
//-----------------+
aEnchoice	:= {"NOUSER","F1_DOC","F1_SERIE","F1_FORNECE","F1_LOJA",;
				"F1_EMISSAO","F1_DTDIGIT"}

//-------------------------------------------------------+
// Inicializa as coordenadas de tela conforme resolução  |
//-------------------------------------------------------+
_oSize:AddObject( "DLG", 100, 100, .T., .T.)
_oSize:SetWindowSize(_aCoors)
_oSize:lProp         := .T.
_oSize:lLateral 	:= .T.
_oSize:Process()

//------------------------+
// Monta Dialog principal |
//------------------------+
_oDlg := MsDialog():New(_oSize:aWindSize[1], _oSize:aWindSize[2],_oSize:aWindSize[3] - 050, _oSize:aWindSize[4] - 500,_cTitulo,,,,,,,,,.T.)
	
	//--------------------+
    // Layer da estrutura |
    //--------------------+
    _oLayer:Init( _oDlg, .F. )
    _oLayer:AddLine( "LINE01", 030 )
    _oLayer:AddLine( "LINE02", 065 )
    
    _oLayer:AddCollumn( "COLLL01"  , 100,, "LINE01" )
    _oLayer:AddWindow( "COLLL01" , "WNDCABEC"  , ""     , 100 ,.F. ,,,"LINE01" )
    _oPCab  := _oLayer:GetWinPanel( "COLLL01"   , "WNDCABEC"  , "LINE01" )
    
    //------------------------+
	// Cabeçalho visualização |   
	//------------------------+
	_oEncEco := 	MsMGet():New("SF1", , 2, , , , aEnchoice	, {000,000,000,000}, , , , , , _oPCab,,,,,,,,,,,,.T.)
	_oEncEco:oBox:Align := CONTROL_ALIGN_ALLCLIENT	
    
    _oLayer:AddCollumn( "COLLL02"  , 100,, "LINE02" )
    _oLayer:AddWindow( "COLLL02" , "WNDITENS"  , "Itens - Nota Fiscal"   , 090 ,.F. ,,,"LINE02" )
    _oPItem  := _oLayer:GetWinPanel( "COLLL02"   , "WNDITENS"  , "LINE02" )
            
    //-------------------+
	// Lotes X Etiquetas |
	//-------------------+
	_oMsGetLot 	:= MsNewGetDados():New(000,000,000,000,GD_UPDATE,"AllwaysTrue","AllwaysTrue",/*cIniCpos*/,aAlterD1,/*nFreeze*/,/*nMax*/,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,_oPItem,aHeadD1,aColsD1)
	_oMsGetLot:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT	
		
	//---------------+
    // Enchoice Tela |
    //---------------+
    _oDlg:bInit := {|| EnchoiceBar(_oDlg,{|| IIF(TgCVldLt(),(_nOpcA := 1,_oDlg:End()),_nOpcA := 0) },{|| _oDlg:End()} )}
    

_oDlg:Activate(,,,.T.,,,)

If _nOpcA == 1
	FWMsgRun(, {|| TgCGrvLote() }, "Processando", "Alterando dados do lote..." )
	FWMsgRun(, {|| TgRefresh() }, "Processando", "Alterando dados do lote..." )
EndIf

RestArea(_aArea)
Return Nil

/************************************************************************************/
/*/{Protheus.doc} TgCGrvLote

@description Realiza a gravação dos lotes e datas alterados 
@author Bernard M. Margarido
@since 28/10/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCGrvLote()
Local _aArea	:= GetArea()
Local _nX

If Len(_aLoteAlt) > 0
	
	Begin Transaction
	
		For _nX := 1 To Len(_aLoteAlt)
			
			//--------------------+
			// Altera lote na SD5 |
			//--------------------+
			TgCom01SD5(_aLoteAlt[_nX][2],_aLoteAlt[_nX][3],_aLoteAlt[_nX][4],_aLoteAlt[_nX][5])
			
			//--------------------+
			// Altera lote na SB8 |
			//--------------------+
			TgCom01SB8(_aLoteAlt[_nX][2],_aLoteAlt[_nX][3],_aLoteAlt[_nX][4],_aLoteAlt[_nX][5])
			
			//--------------------+
			// Altera lote na SD1 |
			//--------------------+
			TgCom01SD1(_aLoteAlt[_nX][2],_aLoteAlt[_nX][3],_aLoteAlt[_nX][4],_aLoteAlt[_nX][5])
						
			//--------------------+
			// Altera lote na ZZA |
			//--------------------+
			TgCom01ZZa(_aLoteAlt[_nX][2],_aLoteAlt[_nX][3],_aLoteAlt[_nX][4],_aLoteAlt[_nX][5])
		Next _nX
	
	End Transaction 
EndIf

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgRefresh
@description Atualiza dados a GRID 
@author Bernard M. Margarido
@since 29/10/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgRefresh()
Local _aArea	:= GetArea()

//----------------+
// Atualiza array |
//----------------+
TAL01Filter()

If ValType(oGrid) == "O"
	oGrid:SetArray( aItensNF )
	oGrid:GoTop()
	oGrid:Refresh()
	oPCenter:Refresh()
EndIf

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCVldLt

@description Valida itens alterados 

@author Bernard M. Margarido
@since 11/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCVldLt()
Local _aArea	:= GetArea()

//Local _lRet		:= .T.

//Local _nX		:= 0 

//---------------------------------------------------+
// Somente permiti alterar para notas nao conferidas |
//---------------------------------------------------+
If SF1->F1_XSTATUS == "2"
	MsgAlert("Não é permitido alterar lote/data de validade para notas já conferidas.")
	RestArea(_aArea)
	Return .F.
EndIf

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCom01SD5

@description Atualiza lote / data de vencimento 

@author Bernard M. Margarido
@since 29/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCom01SD5(_cProduto,_cLocal,_cNewLote,_dNewDta)
Local _aArea	:= GetArea()

Local _cAlias	:= GetNextAlias()
Local _cDoc		:= SF1->F1_DOC
Local _cSerie	:= SF1->F1_SERIE
Local _cClifor	:= SF1->F1_FORNECE
Local _cLoja 	:= SF1->F1_LOJA
Local _cQuery	:= ""

Local _nRecno	:= 0 

_cQuery	:= " SELECT " + CRLF
_cQuery	+= " 	D5.R_E_C_N_O_ RECNOSD5 " + CRLF
_cQuery	+= " FROM " + CRLF
_cQuery	+= "	" + RetSqlName("SD5") + " D5 " + CRLF 
_cQuery	+= " WHERE " + CRLF
_cQuery	+= "	D5.D5_FILIAL = '" + xFilial("SD5") + "' AND " + CRLF 
_cQuery	+= "	D5.D5_DOC = '" + _cDoc + "' AND " + CRLF
_cQuery	+= "	D5.D5_SERIE = '" + _cSerie + "' AND " + CRLF
_cQuery	+= "	D5.D5_PRODUTO = '" + _cProduto + "' AND " + CRLF
_cQuery	+= "	D5.D5_LOCAL = '" + _cLocal + "' AND " + CRLF
_cQuery	+= "	D5.D5_CLIFOR = '" + _cClifor + "' AND 
_cQuery	+= "	D5.D5_LOJA = '" + _cLoja + "' AND 
_cQuery	+= "	D5.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

If (_cAlias)->( Eof() )
	(_cAlias)->( dbCloseArea() )
	RestArea(_aArea)
	Return .T.
EndIf 

dbSelectArea("SD5")
SD5->( dbSetOrder(1) )

While (_cAlias)->( !Eof() )

	_nRecno := (_cAlias)->RECNOSD5
	SD5->( dbGoTo(_nRecno))
	RecLock("SD5",.F.)
		SD5->D5_LOTECTL	:= _cNewLote
		SD5->D5_DTVALID	:= _dNewDta
	SD5->( MsUnLock() )
	
	(_cAlias)->( dbSkip() )
EndDo

(_cAlias)->( dbCloseArea() )

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCom01SB8

@description Atualiza lote / data de vencimento 

@author Bernard M. Margarido
@since 29/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCom01SB8(_cProduto,_cLocal,_cNewLote,_dNewDta)
Local _aArea	:= GetArea()

Local _cAlias	:= GetNextAlias()
Local _cDoc		:= SF1->F1_DOC
Local _cSerie	:= SF1->F1_SERIE
Local _cClifor	:= SF1->F1_FORNECE
Local _cLoja 	:= SF1->F1_LOJA
Local _cQuery	:= ""

Local _nRecno	:= 0 

_cQuery	:= " SELECT " + CRLF
_cQuery	+= " 	B8.R_E_C_N_O_ RECNOSB8 " + CRLF
_cQuery	+= " FROM " + CRLF
_cQuery	+= "	" + RetSqlName("SB8") + " B8 " + CRLF
_cQuery	+= " WHERE " + CRLF
_cQuery	+= "	B8.B8_FILIAL = '" + xFilial("SD5") + "' AND " + CRLF
_cQuery	+= "	B8.B8_DOC = '" + _cDoc + "' AND " + CRLF
_cQuery	+= "	B8.B8_SERIE = '" + _cSerie + "' AND " + CRLF
_cQuery	+= "	B8.B8_PRODUTO = '" + _cProduto + "' AND " + CRLF
_cQuery	+= "	B8.B8_LOCAL = '" + _cLocal + "' AND " + CRLF
_cQuery	+= "	B8.B8_CLIFOR = '" + _cClifor + "' AND 
_cQuery	+= "	B8.B8_LOJA = '" + _cLoja + "' AND 
_cQuery	+= "	B8.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

If (_cAlias)->( Eof() )
	(_cAlias)->( dbCloseArea() )
	RestArea(_aArea)
	Return .T.
EndIf 

dbSelectArea("SB8")
SB8->( dbSetOrder(1) )

While (_cAlias)->( !Eof() )

	_nRecno := (_cAlias)->RECNOSB8
	SB8->( dbGoTo(_nRecno))
	RecLock("SB8",.F.)
		SB8->B8_LOTECTL	:= _cNewLote
		SB8->B8_DTVALID	:= _dNewDta
	SB8->( MsUnLock() )
	
	(_cAlias)->( dbSkip() )
EndDo

(_cAlias)->( dbCloseArea() )

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCom01SD1
@description Atualiza lote / data de vencimento 

@author Bernard M. Margarido
@since 29/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCom01SD1(_cProduto,_cLocal,_cNewLote,_dNewDta)
Local _aArea	:= GetArea()

Local _cAlias	:= GetNextAlias()
Local _cDoc		:= SF1->F1_DOC
Local _cSerie	:= SF1->F1_SERIE
Local _cClifor	:= SF1->F1_FORNECE
Local _cLoja 	:= SF1->F1_LOJA

Local _cQuery	:= ""

Local _nRecno	:= 0 

_cQuery	:= " SELECT " + CRLF
_cQuery	+= " 	D1.R_E_C_N_O_ RECNOSD1 " + CRLF
_cQuery	+= " FROM " + CRLF
_cQuery	+= "	" + RetSqlName("SD1") + " D1 " + CRLF 
_cQuery	+= " WHERE " + CRLF
_cQuery	+= "	D1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + CRLF 
_cQuery	+= "	D1.D1_DOC = '" + _cDoc + "' AND " + CRLF
_cQuery	+= "	D1.D1_SERIE = '" + _cSerie + "' AND " + CRLF
_cQuery	+= "	D1.D1_COD = '" + _cProduto + "' AND " + CRLF
_cQuery	+= "	D1.D1_LOCAL = '" + _cLocal + "' AND " + CRLF
_cQuery	+= "	D1.D1_FORNECE = '" + _cClifor + "' AND 
_cQuery	+= "	D1.D1_LOJA = '" + _cLoja + "' AND 
_cQuery	+= "	D1.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

If (_cAlias)->( Eof() )
	(_cAlias)->( dbCloseArea() )
	RestArea(_aArea)
	Return .T.
EndIf 

dbSelectArea("SD1")
SD1->( dbSetOrder(1) )

While (_cAlias)->( !Eof() )

	_nRecno := (_cAlias)->RECNOSD1
	SD1->( dbGoTo(_nRecno))
	RecLock("SD1",.F.)
		SD1->D1_LOTECTL	:= _cNewLote
		SD1->D1_DTVALID	:= _dNewDta
	SD1->( MsUnLock() )
	
	(_cAlias)->( dbSkip() )
EndDo

(_cAlias)->( dbCloseArea() )

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCom01ZZa
@description Atualiza lote / data de vencimento 

@author Bernard M. Margarido
@since 29/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TgCom01ZZa(_cProduto,_cLocal,_cNewLote,_dNewDta)
Local _aArea	:= GetArea()
Local _cAlias	:= GetNextAlias()
Local _cDoc		:= SF1->F1_DOC
Local _cSerie	:= SF1->F1_SERIE
Local _cClifor	:= SF1->F1_FORNECE
Local _cLoja 	:= SF1->F1_LOJA

Local _cQuery	:= ""

Local _nRecno	:= 0 

_cQuery	:= " SELECT " + CRLF
_cQuery	+= " 	ZZA.R_E_C_N_O_ RECNOZZA " + CRLF
_cQuery	+= " FROM " + CRLF
_cQuery	+= "	" + RetSqlName("ZZA") + " ZZA " + CRLF 
_cQuery	+= " WHERE " + CRLF
_cQuery	+= "	ZZA.ZZA_FILIAL = '" + xFilial("SD1") + "' AND " + CRLF 
_cQuery	+= "	ZZA.ZZA_NUMNF = '" + _cDoc + "' AND " + CRLF
_cQuery	+= "	ZZA.ZZA_SERIE = '" + _cSerie + "' AND " + CRLF
_cQuery	+= "	ZZA.ZZA_CODPRO = '" + _cProduto + "' AND " + CRLF
_cQuery	+= "	ZZA.ZZA_LOCENT = '" + _cLocal + "' AND " + CRLF
_cQuery	+= "	ZZA.ZZA_FORNEC = '" + _cClifor + "' AND 
_cQuery	+= "	ZZA.ZZA_LOCENT = '" + _cLoja + "' AND 
_cQuery	+= "	ZZA.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAlias,.T.,.T.)

If (_cAlias)->( Eof() )
	(_cAlias)->( dbCloseArea() )
	RestArea(_aArea)
	Return .T.
EndIf 

dbSelectArea("ZZA")
ZZA->( dbSetOrder(1) )

While (_cAlias)->( !Eof() )

	_nRecno := (_cAlias)->RECNOZZA
	ZZA->( dbGoTo(_nRecno))
	RecLock("ZZA",.F.)
		ZZA->ZZA_NUMLOT	:= _cNewLote
	ZZA->( MsUnLock() )
	
	(_cAlias)->( dbSkip() )
EndDo

(_cAlias)->( dbCloseArea() )

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TgCo01LT

@description Cria array com as linhas alteradas

@author Bernard M. Margarido
@since 29/07/2019
@version 1.0
@type function
/*/
/************************************************************************************/
User Function TgCo01LT(_nCol)
Local _nPosLT	:= 0
Local _nLin		:= _oMsGetLot:nAt
Local _nPItem	:= aScan(aHeadD1,{|x| RTrim(x[2]) == "D1ITEM"})
Local _nPProd	:= aScan(aHeadD1,{|x| RTrim(x[2]) == "D1PRODUTO"})
Local _nPLocal	:= aScan(aHeadD1,{|x| RTrim(x[2]) == "D1LOCAL"})
Local _nPLote	:= aScan(aHeadD1,{|x| RTrim(x[2]) == "D1LOTECTL"})
Local _nPDtLote	:= aScan(aHeadD1,{|x| RTrim(x[2]) == "D1DATALOT"})

Local _cCodLote	:= IIF(_nCol == 1,M->D1LOTECTL,_oMsGetLot:aCols[_nLin][_nPLote])
Local _dDtaLote	:= IIF(_nCol == 2,M->D1DATALOT,_oMsGetLot:aCols[_nLin][_nPDtLote])

_nPosLT := aScan(_aLoteAlt,{|x| Rtrim(x[1]) + Rtrim(x[2]) + Rtrim(x[3]) + Rtrim(x[4])  == _oMsGetLot:aCols[_nLin][_nPItem] + _oMsGetLot:aCols[_nLin][_nPProd] + _oMsGetLot:aCols[_nLin][_nPLocal] +  _cCodLote })
If _nPosLT > 0
	_oMsGetLot:aCols[_nLin][_nPItem] 	:= _aLoteAlt[_nPosLT][1]
	_oMsGetLot:aCols[_nLin][_nPProd] 	:= _aLoteAlt[_nPosLT][2]
	_oMsGetLot:aCols[_nLin][_nPLocal] 	:= _aLoteAlt[_nPosLT][3]
	_oMsGetLot:aCols[_nLin][_nPLote] 	:= _cCodLote
	_oMsGetLot:aCols[_nLin][_nPDtLote]	:= _dDtaLote
Else
	aAdd(_aLoteAlt,{	_oMsGetLot:aCols[_nLin][_nPItem]	,; 	// 1. Item
						_oMsGetLot:aCols[_nLin][_nPProd]	,;	// 2. Produto
						_oMsGetLot:aCols[_nLin][_nPLocal]	,;	// 3. local 
						_cCodLote							,;	// 4. Lote
						_dDtaLote							})	// 5. Data Lote 
EndIf

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TGC01Head

@description Cria aHeader e aCols dos itens da nota de entrada 

@author Bernard M. Margarido
@since 11/07/2019
@version 1.0

@type function
/*/
/************************************************************************************/
Static Function TGC01Head(cNFiscal,cSerie,cCodForn,cLojForn)

aHeadD1		:= {}
aColsD1		:= {}
aAlterD1	:= {}

//-------------------+
// Lotes X Etiquetas | 
//-------------------+
aAdd(aHeadD1,{"Item"			,"D1ITEM"		,PesqPict("SD1","D1_ITEM")		,TamSx3("D1_ITEM")[1]	, 0							,".T."				,"û","C",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Produto"			,"D1PRODUTO"	,PesqPict("SD1","D1_COD")		,TamSx3("D1_COD")[1]	, 0							,".T."				,"û","C",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Descricao"		,"D1DESCRI"		,PesqPict("SB1","B1_DESC")		,TamSx3("B1_DESC")[1]	, 0							,".T."				,"û","C",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Local "			,"D1LOCAL"		,PesqPict("SD1","D1_LOCAL")		,TamSx3("D1_LOCAL")[1]	, 0							,".T."				,"û","C",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Saldo Lote"		,"D1QUANT"		,PesqPict("SD1","D1_QUANT")		,TamSx3("D1_QUANT")[1]	, TamSx3("D1_QUANT")[2]		,".T."				,"û","N",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Lote Atual"		,"D1LOTECTL"	,PesqPict("SD1","D1_LOTECTL")	,TamSx3("D1_LOTECTL")[1], TamSx3("D1_LOTECTL")[2]	,"U_TgCo01LT(1)"	,"û","C",""," "		,"","",".T." } )
aAdd(aHeadD1,{"Data Lote"		,"D1DATALOT"	,PesqPict("SD1","D1_DTVALID")	,TamSx3("D1_DTVALID")[1], TamSx3("D1_DTVALID")[2]	,"U_TgCo01LT(2)"	,"û","D",""," "		,"","",".T." } )
aAdd(aHeadD1,{""				,"D1VAZIO"		,""								,01						, 0							,".T."				,"û","C",""," "		,"","",".T." } )

aAdd(aAlterD1,"D1LOTECTL")
aAdd(aAlterD1,"D1DATALOT")

dbSelectArea("SD1")
SD1->( dbSetOrder(1) )
If SD1->( dbSeek(xFilial("SD1") + cNFiscal + cSerie + cCodForn + cLojForn) )
	While SD1->( !Eof() .And. xFilial("SD1") + cNFiscal + cSerie + cCodForn + cLojForn == SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA )
		aAdd(aColsD1,Array(Len(aHeadD1)+1)) 
		aColsD1[Len(aColsD1)][ITEM] 	:= SD1->D1_ITEM
		aColsD1[Len(aColsD1)][PRODUTO] 	:= SD1->D1_COD
		aColsD1[Len(aColsD1)][DESCPRO] 	:= Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1_DESC")
		aColsD1[Len(aColsD1)][ARMAZEM] 	:= SD1->D1_LOCAL
		aColsD1[Len(aColsD1)][QUANT] 	:= SD1->D1_QUANT
		aColsD1[Len(aColsD1)][SALDOLT] 	:= SD1->D1_LOTECTL
		aColsD1[Len(aColsD1)][DTALOTE] 	:= SD1->D1_DTVALID
		aColsD1[Len(aColsD1)][COLVAZIO]	:= ""
		aColsD1[Len(aColsD1)][Len(aHeadD1)+1]:= .F.
		SD1->( dbSkip() )
	EndDo
EndIf


Return Nil


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

/************************************************************************************/
/*/{Protheus.doc} TgCom01Dif
@description Grava divergencias da nota fiscal 
@author Bernard M. margarido
@since 08/06/2020
@version 1.0
@type function
/*/
/************************************************************************************/
Static Function TgCom01Dif(aItem)
Local _aArea	:= GetArea()

Local _lGrava 	:= .T.

//-------------------------------------+
// Divergencias Conferencia de entrada | 
//-------------------------------------+
dbSelectArea("ZZG")
ZZG->( dbSetOrder(1) )
If ZZG->( dbSeek(xFilial("ZZG") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_TIPO + aItem[1] + aItem[2] ))
	_lGrava := .F.
EndIf

RecLock("ZZG",_lGrava)
	ZZG->ZZG_FILIAL := xFilial("ZZG")
	ZZG->ZZG_DOC	:= SF1->F1_DOC
	ZZG->ZZG_SERIE	:= SF1->F1_SERIE 
	ZZG->ZZG_FORNEC	:= SF1->F1_FORNECE
	ZZG->ZZG_LOJA	:= SF1->F1_LOJA
	ZZG->ZZG_TIPO	:= SF1->F1_TIPO
	ZZG->ZZG_DTEMIS	:= SF1->F1_DTDIGIT
	ZZG->ZZG_ITEM	:= aItem[1] 
	ZZG->ZZG_PRODUT	:= aItem[2]
	ZZG->ZZG_VRUNIT	:= aItem[5]
	ZZG->ZZG_QTDNF	:= aItem[4]
	ZZG->ZZG_QTDCON	:= IIF(aItem[7] > 0, aItem[7], aItem[8])
ZZG->( MsUnLock() )

RestArea(_aArea)
Return Nil 

/********************************************************************************************/
/*/{Protheus.doc} nomeStaticFunction
	@description Retorna armazem de origem 
	@type  Static Function
	@author Bernard M. Margarido
	@since 01/07/2020
/*/
/********************************************************************************************/
Static Function TgCom01Ori(_cItem,_cProd,cArmDest)
Local _aArea	:= GetArea()

Local _cQuery	:= ""
Local _cAliasO	:= ""
//Local _cDocOri	:= ""
//Local _cSerOri	:= ""
//Local _cItemOri	:= ""

//------------------------------------+ 
// Query - Localiza armazem de origem |
//------------------------------------+ 
_cQuery := " SELECT " + CRLF
_cQuery += "	D2.D2_COD, " + CRLF
_cQuery += "	D2.D2_LOCAL " + CRLF
_cQuery += " FROM  " + CRLF
_cQuery += "	" + RetSqlName("SD1") + " D1 " + CRLF
_cQuery += "	INNER JOIN " + RetSqlName("SD2") + " D2 ON D2.D2_FILIAL = D1.D1_FILIAL AND D2.D2_DOC = D1.D1_NFORI AND D2.D2_SERIE = D1.D1_SERIORI AND D2.D2_ITEM = D1.D1_ITEMORI AND D2.D2_COD = D1.D1_COD AND D2.D_E_L_E_T_ = '' " + CRLF
_cQuery += " WHERE " + CRLF
_cQuery += "	D1.D1_FILIAL = '" + xFilial("SD1") + "' AND " + CRLF
_cQuery += "	D1.D1_DOC = '" + SF1->F1_DOC + "' AND " + CRLF
_cQuery += "	D1.D1_SERIE = '" + SF1->F1_SERIE + "' AND " + CRLF
_cQuery += "	D1.D1_FORNECE = '" + SF1->F1_FORNECE + "' AND " + CRLF
_cQuery += "	D1.D1_LOJA = '" + SF1->F1_LOJA + "' AND " + CRLF
_cQuery += "	D1.D1_ITEM = '" + _cItem + "' AND " + CRLF
_cQuery += "	D1.D1_COD = '" + _cProd + "' AND " + CRLF
_cQuery += "	D1.D1_TIPO = 'D' AND " + CRLF
_cQuery += "	D1.D_E_L_E_T_ = '' "

memowrite('query_conferencia_nf_'+SF1->F1_DOC+'.txt', _cQuery)

_cAliasO := MPSysOpenQuery(_cQuery)

dbSelectArea(_cAliasO)
(_cAliasO)->( dbGoTop() )

If (_cAliasO)->( Eof() )
    (_cAliasO)->( dbCloseArea() )
    Return .F.
EndIf 

cArmDest := (_cAliasO)->D2_LOCAL

(_cAliasO)->( dbCloseArea() )

RestArea(_aArea)
Return Nil

/************************************************************************************/
/*/{Protheus.doc} MenuDef

@description Menu padrao para manutencao do cadastro

@author Bernard M. Margarido

@since 10/08/2017
@version undefined

@type function
/*/
/************************************************************************************/
Static Function MenuDef()
Local aRetMenu := {}

	aAdd(aRetMenu,{"Pesquisar"				,"PesqBrw"   		, 0, 1, 0, .F. })
	aAdd(aRetMenu,{"Visualizar"				,"U_TGCOMA01"		, 0, 2, 0, .F. })
	aAdd(aRetMenu,{"Conferencia"			,"U_TGCOMA01"		, 0, 4, 0, .F. })
	aAdd(aRetMenu,{"Reimpressao"			,"U_ICOMA020"		, 0, 4, 0, .F. })
	aAdd(aRetMenu,{"Etiquetas"				,"U_ICOMA040"		, 0, 4, 0, .F. })
				
Return aRetMenu
