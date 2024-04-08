user function restr12()
**********************
Local aRegs	:= {}
Local cPerg 			:= U_CriaPerg('ESP430')

Private cPerg2			:= U_CriaPerg('MTR430')
Private nOpcSel 		:= 0
Private nOpcRel 		:= 0
Private aHeader		    := {}
Private oGetd 
Private aCols			:= {} 
Private acols2          :={}
Private nOpca			:= 3                              
Private INCLUI			:= .T.
Private lCont 			:= .T.
Private lest            := 0
PRIVATE LFIRST          := .T.
Private _aCampos 	:= {}
Private _cArqTmp 	:= "" 
private _nfrete    :=0
private _ncomissao := 0
private _ndescoml := 0
private _mark := 0
private _tabela :=space(3)
Public lDescPCof		:= .F.
Public nDescPCof		:= 0

 

If Pergunte( cPerg, .T. )
	nOpcSel := Mv_Par01
    
    _nfrete    :=mv_par02/100
    
    
    _ncomissao := mv_par03/100
    //_ndescoml := 0
    
    _tabela :=mv_par04  

    _ndescoml := mv_par05/100
    _mark := mv_par06   //--/100	
	
	
	
	If Mv_Par01 == 1
		lCont := GetProd()					//Obtem os produtos a serem controlados
		If lCont 
			RunFormPrc()
		EndIf
	Else
		If Pergunte( cPerg2, .t. )
			RunFormPrc()
		EndIf
	EndIf
EndIf
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetProd   บAutor  ณEvaldo V. Batista   บ Data ณ  26/07/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para obter lista de Produtos para a geracao do     บฑฑ
ฑฑบ          ณ relatorio                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GetProd()


Local oDlg,oGrp1,oSBtn2,oSBtn3,oSBtn4
Local lRet := .T.

PRIVATE aRotina := {{ OemToAnsi("Produtos"),	"",	0,	3},;
					{ OemToAnsi("Produtos"),	"",	0,	3},;
					{ OemToAnsi("Produtos"),	"",	0,	3}}   
				
CriaVar("B5_COD") 

SX3->( dbSetOrder( 2 ) ) 
SX3->( dbSeek( 'B5_COD' ) )
Aadd( aHeader,{ SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, "U_ValProd()", SX3->X3_RESERV, SX3->X3_TIPO, "SB1", "R" }	)
SX3->( dbSeek( 'DA1_DESCRI' ) )
Aadd( aHeader,{ SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_RESERV, SX3->X3_TIPO, "", "V"} )
                                     
//Aadd( oGetd:aCols, { Space(15), Space(40), .F. } )

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Sele็ใo de Produtos"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 586
oDlg:nHeight := 349
oDlg:lShowHint := .F.
oDlg:lCentered := .T.
                    
oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Produtos:"
oGrp1:nLeft := 9
oGrp1:nTop := 6
oGrp1:nWidth := 561
oGrp1:nHeight := 255
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtn2 := SBUTTON():Create(oDlg)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "OK"
oSBtn2:nLeft := 500
oSBtn2:nTop := 280
oSBtn2:nWidth := 60
oSBtn2:nHeight := 22
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 1
//oSBtn2:bAction := {|| lRet := .T.,acols2:=oGetd:aCols,oDlg:End() }   
oSBtn2:bAction := {|| lRet := .T., oDlg:End() }

oSBtn3 := SBUTTON():Create(oDlg)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 430
oSBtn3:nTop := 280
oSBtn3:nWidth := 60
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 2
oSBtn3:bAction := {|| lRet := .F., oDlg:End() }

oSBtn4 := SBUTTON():Create(oDlg)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "oSBtn4"
oSBtn4:nLeft := 360
oSBtn4:nTop := 280
oSBtn4:nWidth := 60
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 5
oSBtn4:bAction := {|| Pergunte(cPerg2, .T.) }

aMatOk := {"B5_COD"}

//oGetd := MsGetDados():New(12,7,125,282       ,nOpcA,"AllWaysTrue()","AllWaysTrue()","",.t.  ,,1  ,,,,,,"AllWaysTrue()",,.T.)		

//oGetd:= MsNewGetDados():New(12,7,125,282  ,nOpcA,"AllWaysTrue"  ,"AllWaysTrue"  ,"",aMatOk  ,0,999,   "AllwaysTrue","AllwaysTrue","AllwaysTrue" , ,aHeader , aCols)
oGetd:= MsNewGetDados():New(12,7,125,282  ,nOpcA,"AllWaysTrue"  ,"AllWaysTrue"  ,"",aMatOk  ,0,999,   "AllwaysTrue","AllwaysTrue","AllwaysTrue" , ,aHeader , aCols)

oDlg:Activate()

Return(lRet)





/*


Local oDlg,oGrp1,oSBtn2,oSBtn3,oSBtn4
Local lRet := .T.

PRIVATE aRotina := { { OemToAnsi("Produtos"),	"",	0,	3},;
							{ OemToAnsi("Produtos"),	"",	0,	3},;
							{ OemToAnsi("Produtos"),	"",	0,	3}}

CriaVar("B5_COD") 

SX3->( dbSetOrder( 2 ) ) 
SX3->( dbSeek( 'B5_COD' ) )
Aadd( aHeader,{ SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, "U_ValProd()", SX3->X3_RESERV, SX3->X3_TIPO, "XB1", "R" }	)
SX3->( dbSeek( 'DA1_DESCRI' ) )
Aadd( aHeader,{ SX3->X3_TITULO, SX3->X3_CAMPO, SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID, SX3->X3_RESERV, SX3->X3_TIPO, "", "V"} )

Aadd( aCols, { Space(15), Space(40), .F. } )

oDlg := MSDIALOG():Create()
oDlg:cName := "oDlg"
oDlg:cCaption := "Sele็ใo de Produtos"
oDlg:nLeft := 0
oDlg:nTop := 0
oDlg:nWidth := 586
oDlg:nHeight := 349
oDlg:lShowHint := .F.
oDlg:lCentered := .T.

oGrp1 := TGROUP():Create(oDlg)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := "Produtos:"
oGrp1:nLeft := 9
oGrp1:nTop := 6
oGrp1:nWidth := 561
oGrp1:nHeight := 255
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oSBtn2 := SBUTTON():Create(oDlg)
oSBtn2:cName := "oSBtn2"
oSBtn2:cCaption := "OK"
oSBtn2:nLeft := 500
oSBtn2:nTop := 280
oSBtn2:nWidth := 60
oSBtn2:nHeight := 22
oSBtn2:lShowHint := .F.
oSBtn2:lReadOnly := .F.
oSBtn2:Align := 0
oSBtn2:lVisibleControl := .T.
oSBtn2:nType := 1
oSBtn2:bAction := {|| lRet := .T., oDlg:End() }

oSBtn3 := SBUTTON():Create(oDlg)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "oSBtn3"
oSBtn3:nLeft := 430
oSBtn3:nTop := 280
oSBtn3:nWidth := 60
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 2
oSBtn3:bAction := {|| lRet := .F., oDlg:End() }

oSBtn4 := SBUTTON():Create(oDlg)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "oSBtn4"
oSBtn4:nLeft := 360
oSBtn4:nTop := 280
oSBtn4:nWidth := 60
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 5
oSBtn4:bAction := {|| Pergunte(cPerg2, .T.) }

oGetd := MsGetDados():New(12,7,125,282,nOpcA,"AllWaysTrue()","AllWaysTrue()",,.T.,,1,,,,,,"AllWaysTrue()",,.T.)		

oDlg:Activate()

Return(lRet)
                  
*/ 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunFormPrcบAutor  ณEvaldo V. Batista   บ Data ณ  26/07/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAjusta os parametros do relatorio para permitir a sele็ใo deบฑฑ
ฑฑบ          ณ produtos pela sele็ใo manual                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunFormPrc()
Local cPerg			:= 'MTR430' 

Private aPar			:= Array(20)
Private aParC010		:= Array(20)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifica as perguntas selecionadas                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros                         ณ
//ณ mv_par01     // Produto inicial                              ณ
//ณ mv_par02     // Produto final                                ณ
//ณ mv_par03     // Nome da planilha utilizada                   ณ
//ณ mv_par04     // Imprime estrutura : Sim / Nao                ณ
//ณ mv_par05     // Moeda Secundaria  : 1 2 3 4 5                ณ
//ณ mv_par06     // Nivel de detalhamento da estrutura           ณ
//ณ mv_par07     // Qual a Quantidade Basica                     ณ
//ณ mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     ณ
//ณ mv_par09     // Considera Estrutura / Pre Estrutura          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
pergunte(cPerg,.F.)
//Salvar variaveis existentes
For ni := 1 to 20
	aPar[ni] := &("mv_par"+StrZero(ni,2))
Next ni
//Fixa o conteudo da pergunta para nao imprimir a estrutura
//aPar[6] := '02'

Processa( { || E430Imp() }, 'Calculando...', 'Aguarde...' ) 
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณC430Imp   บAutor  ณEvaldo V. Batista   บ Data ณ  26/07/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function E430Imp(lEnd)
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0,nReg
LOCAL aArray   := {}
LOCAL cCondFiltr
LOCAL lRet
LOCAL nI       := 0
LOCAL cProdFim :=""
Local aStru		:= {}

PRIVATE cProg:="R430"
PRIVATE nQualCusto := 1
PRIVATE aAuxCusto
PRIVATE cArqMemo := "STANDARD"
PRIVATE lDirecao := .T.

If nOpcRel <> 2
	MTC010SX1()
	PERGUNTE("MTC010", .F.)

	For ni := 1 to 20
		aParC010[ni] := &("mv_par"+StrZero(ni,2))
	Next ni
	
	//Forca mesmo valor do relatorio na pergunta 09
	mv_par09     := aPar[09]
	aParC010[09] := aPar[09]
		      	
	lConsNeg := apar[08] = 1     // Esta variavel serแ usada na fun็ใo MC010Forma
	
	DbSelectArea("SB1")
	cArqMemo := apar[03]

EndIf


dbSelectArea("SB1")
If nOpcSel == 1
	ProcRegua( Len(oGetd:aCols) ) 
Else
	ProcRegua(LastRec())
EndIf

If  nOpcSel == 1

		For _nA := 1 To Len(oGetd:aCols) //Len( aCols ) 
			SB1->( dbSetOrder( 1 ) ) 
			If SB1->( dbSeek( xFilial('SB1') + oGetd:aCols[_nA,1], .F. ) ) 
				nReg := Recno()
				Incproc()
				dbSelectArea( 'SB1' ) 
				aArray := MC010Forma('SB1',nReg,99,aPar[07])
				a430I(aArray[1],aArray[2],aArray[3])
				SB1->( dbGoTo(nReg) ) 
			EndIf
		Next _nA

Else
      // dbSelectArea("SB1")

     //  Set SoftSeek On
      // dbSeek(xFilial("SB1")+apar[01])
     //  Set SoftSeek Off

		cProdFim:=apar[02]
		SB1->( dbSetOrder(1) ) 
		If !SB1->( dbSeek( xFilial("SB1") + aPar[01], .F. ) ) 
			SB1->( dbGoTop() )
		EndIf
		While !SB1->(EOF()) .And. SB1->B1_FILIAL+SB1->B1_COD <= xFilial("SB1")+cProdFim //.And. lRet
			If SB1->B1_COD < aPar[01] .or. SB1->B1_COD > cProdFim
				SB1->( dbSkip() ) 
				Loop
			EndIf  
			
			IF SB1->B1_TIPO <> 'PA'
			 SB1->( dbSkip() ) 
				Loop
			EndIf  
			
			IF SB1->B1_MSBLQL <> '2'
			 SB1->( dbSkip() ) 
				Loop
			EndIf  
			
			if !DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
			    SB1->( dbSkip() ) 
				Loop
			EndIf  
			
			
			IncProc()
			nReg := SB1->( Recno() ) 
			dbSelectArea( 'SB1' ) 
			aArray := MC010Forma('SB1',nReg,99,aPar[07])
			a430I(aArray[1],aArray[2],aArray[3])
			SB1->( dbGoTo(nReg) ) 
			SB1->( dbSkip() ) 
		EndDo
	EndIf

if select ('TRB') > 0
  u_ProcExcel("TRB")
  DBSELECTAREA("TRB")
  DBCLOSEAREA()

ENDIF



ferase(_cArqTmp)
	
return
	
*******************************************************	
static function a430i(cCusto,aArray,nPosForm)


local	_CSTMP  := 0
local	_CSTEM  := 0
local	_CSTMO  := 0
local   _CSTPRO := 0 
LOCAL   _CSTSV  := 0
	
	For nX := 1 To Len(aArray)
	   If 'TOTAL DE MATERIA PRIMA' $ Upper(aArray[nX][03])
			_CSTMP:= aArray[nX][06] 
		ElseIf 'TOTAL DE EMBALAGEM' $ Upper(aArray[nX][03])
			_CSTEM:=aArray[nX][06] 
		ElseIf 'TOTAL DE MAO DE OBRA' $ Upper(aArray[nX][03])
			_CSTMO:=aArray[nX][06] 
		ElseIf 'TOTAL DE BENEFICIAMENTO' $ Upper(aArray[nX][03])
			_CSTSV:=aArray[nX][06] 
		ELSEIF 'PRECO DE VENDA SUGERIDO' $ Upper(aArray[nX][03])
		    _CSTPRO:=aArray[nX][06]
		EndIf
	NEXT 
	
	
IF LFIRST = .T.	
	
	Aadd(_aCampos,{"CODIGO    " ,"C",15,0})
    Aadd(_aCampos,{"DESCR     " ,"C",30,0})
    Aadd(_aCampos,{"FAMCOML   " ,"C",30,0})
    Aadd(_aCampos,{"TAB_PRECO " ,"N",14,4})
    Aadd(_aCampos,{"DESC_COML " ,"N",6,2})
    Aadd(_aCampos,{"TAB_DESC  " ,"N",14,4})
    Aadd(_aCampos,{"IMPOSTOS  " ,"N",14,4})
    Aadd(_aCampos,{"LIQUIDO   " ,"N",14,4})
    Aadd(_aCampos,{"CUSTO_MP " ,"N",14,4})
    Aadd(_aCampos,{"CUSTO_EM "	,"N",14,4})
    Aadd(_aCampos,{"CUSTO_MOD" ,"N",14,4})
    Aadd(_aCampos,{"CUSTO_SERV","N",14,4})
    Aadd(_aCampos,{"CUSTOT"     ,"N",14,4})
    Aadd(_aCampos,{"COMISSAO"  ,"N",14,4})
    Aadd(_aCampos,{"FRETE   "  ,"N",14,4})
    Aadd(_aCampos,{"MARG_BRUTA" ,"N",14,4})
    Aadd(_aCampos,{"MARGEM   " ,"N",6,2})
    Aadd(_aCampos,{"PRC_IDEAL" ,"N",14,4})
    Aadd(_aCampos,{"NC_AJUS"   ,"N",6,2})
    If Select("TRB") > 0
	    TRB->(DBCLOSEAREA())
    Endif

   _cArqTmp := CriaTrab(_aCampos,.T.)
     dbUseArea( .T.,,_cArqTmp, "TRB", .F., .F. )
    _cOrdem := "CODIGO"
    IndRegua ( "TRB",_cArqTmp,_cOrdem,,,"Selecionando Registros...")   
   

   DBSELECTAREA("TRB")
   DBGOTOP()
   RECLOCK("TRB",.T.)
   TRB->CODIGO:=SB1->B1_COD
   TRB->DESCR:= SB1->B1_DESC
   TRB->FAMCOML := POSICIONE("SX5",1,XFILIAL("SX5")+"Z2"+SB1->B1_XFAMCOM,"X5_DESCRI")
   DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
   TRB->TAB_PRECO:=DA1->DA1_PRCVEN
   TRB->DESC_COML:=_ndescoml
   TRB->TAB_DESC:=DA1->DA1_PRCVEN*(1-_ndescoml)
   TRB->IMPOSTOS:=TRB->TAB_DESC*0.2125     
   TRB->LIQUIDO:=TRB->TAB_DESC - TRB->IMPOSTOS
   TRB->CUSTO_MP:=_CSTMP
   TRB->CUSTO_EM:=_CSTEM
   TRB->CUSTO_MOD:=_CSTMO
   TRB->CUSTO_SERV:= _CSTSV
   
   TRB->CUSTOT:= TRB->CUSTO_MP+TRB->CUSTO_EM+TRB->CUSTO_MOD+TRB->CUSTO_SERV
   
   IF TRB->CUSTOT = 0
      TRB->CUSTOT := SB1->B1_CUSTDM
   ENDIF
   
   TRB->COMISSAO := _ncomissao//0.03
   TRB->FRETE:=  _nfrete//0.05
   
   //TRB->MARG_BRUTA:=TRB->LIQUIDO - TRB->CUSTO_MP - TRB->CUSTO_EM - TRB->CUSTO_MOD - (TRB->COMISSAO*TRB->LIQUIDO) - (TRB->FRETE*TRB->LIQUIDO) 
   
   TRB->MARG_BRUTA:=TRB->LIQUIDO - TRB->CUSTOT - (TRB->COMISSAO*TRB->LIQUIDO) - (TRB->FRETE*TRB->LIQUIDO) 
   
   TRB->MARGEM :=(TRB->MARG_BRUTA/TRB->LIQUIDO)*100
   
   //if _CSTPRO == 0 .AND. SB1->B1_CUSTDM <> 0
   //    TRB->PRC_IDEAL := SB1->B1_CUSTDM*_mark
   //elseIF _CSTPRO <> 0
   //  TRB->PRC_IDEAL := _CSTPRO*_mark
   //ELSE
   //  TRB->PRC_IDEAL := 0
   //endif  
    
   TRB->PRC_IDEAL := TRB->CUSTOT*_mark
   
   IF TRB->PRC_IDEAL <> 0
   	TRB->NC_AJUS:=  (((TRB->PRC_IDEAL/TRB->TAB_PRECO)-1))*100//100-((TRB->PRC_IDEAL/TRB->TAB_PRECO)*100)
    ELSE
    TRB->NC_AJUS:=0
    ENDIF
    
LFIRST := .f.    
ELSE
   DBSELECTAREA("TRB")
   DBGOTOP()
   RECLOCK("TRB",.T.)
   TRB->CODIGO:=SB1->B1_COD
   TRB->DESCR:= SB1->B1_DESC
   TRB->FAMCOML := POSICIONE("SX5",1,XFILIAL("SX5")+"Z2"+SB1->B1_XFAMCOM,"X5_DESCRI")
   DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
   TRB->TAB_PRECO:=DA1->DA1_PRCVEN
   TRB->DESC_COML:=_ndescoml
   TRB->TAB_DESC:=DA1->DA1_PRCVEN*(1-_ndescoml)
   TRB->IMPOSTOS:=TRB->TAB_DESC*0.2125     
   TRB->LIQUIDO:=TRB->TAB_DESC - TRB->IMPOSTOS
   TRB->CUSTO_MP:=_CSTMP
   TRB->CUSTO_EM:=_CSTEM
   TRB->CUSTO_MOD:=_CSTMO
   TRB->CUSTO_SERV:= _CSTSV
   
   TRB->CUSTOT:= TRB->CUSTO_MP+TRB->CUSTO_EM+TRB->CUSTO_MOD+TRB->CUSTO_SERV
   
   IF TRB->CUSTOT = 0
      TRB->CUSTOT := SB1->B1_CUSTDM
   ENDIF
   
   TRB->COMISSAO := _ncomissao//0.03
   TRB->FRETE:=  _nfrete//0.05
   
   //TRB->MARG_BRUTA:=TRB->LIQUIDO - TRB->CUSTO_MP - TRB->CUSTO_EM - TRB->CUSTO_MOD - (TRB->COMISSAO*TRB->LIQUIDO) - (TRB->FRETE*TRB->LIQUIDO) 
   
   TRB->MARG_BRUTA:=TRB->LIQUIDO - TRB->CUSTOT - (TRB->COMISSAO*TRB->LIQUIDO) - (TRB->FRETE*TRB->LIQUIDO) 
   
   TRB->MARGEM :=(TRB->MARG_BRUTA/TRB->LIQUIDO)*100
   
   //if _CSTPRO == 0 .AND. SB1->B1_CUSTDM <> 0
   //    TRB->PRC_IDEAL := SB1->B1_CUSTDM*_mark
   //elseIF _CSTPRO <> 0
   //  TRB->PRC_IDEAL := _CSTPRO*_mark
   //ELSE
   //  TRB->PRC_IDEAL := 0
   //endif  
    
   TRB->PRC_IDEAL := TRB->CUSTOT*_mark
   
   IF TRB->PRC_IDEAL <> 0
   	TRB->NC_AJUS:=  (((TRB->PRC_IDEAL/TRB->TAB_PRECO)-1))*100//100-((TRB->PRC_IDEAL/TRB->TAB_PRECO)*100)
    ELSE
    TRB->NC_AJUS:=0
    ENDIF
  
   
/*   TRB->CODIGO:=SB1->B1_COD
   TRB->DESCR:= SB1->B1_DESC
   DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
   TRB->TAB_PRECO:=DA1->DA1_PRCVEN
   TRB->DESC_COML:=0.13
   TRB->TAB_DESC:=DA1->DA1_PRCVEN*(1-0.13)
   TRB->IMPOSTOS:=TRB->TAB_DESC*0.2125     
   TRB->LIQUIDO:=TRB->TAB_DESC - TRB->IMPOSTOS
   TRB->CUSTO_MP:=_CSTMP
   TRB->CUSTO_EM:=_CSTEM
   TRB->CUSTO_MOD:=_CSTMO
   TRB->CUSTO_SERV:= 0
   TRB->COMISSAO := _ncomissao//0.03
   TRB->FRETE:=_nfrete//0.05
   TRB->MARG_BRUTA:=TRB->LIQUIDO - TRB->CUSTO_MP - TRB->CUSTO_MOD - TRB->CUSTO_MOD - (TRB->COMISSAO*TRB->LIQUIDO) - (TRB->FRETE*TRB->LIQUIDO)
   TRB->MARGEM :=(TRB->MARG_BRUTA/TRB->LIQUIDO)*100
   TRB->PRC_IDEAL :=_CSTPRO
   TRB->NC_AJUS:= 100-((TRB->PRC_IDEAL/TRB->TAB_PRECO)*100)
*/
ENDIF




RETURN  
    