//#include 'FormCusto.Ch'      
#INCLUDE "rwmake.ch" 
#INCLUDE "PROTHEUS.CH"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFormCusto บAutor  ณEvaldo V. Batista   บ Data ณ  26/07/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma Impressao e geracao de custo de produtos por       บฑฑ
ฑฑบ          ณ estrutura                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FormCusto()
*************************
Local aRegs	:= {}
Local cPerg 			:= U_CRIAPERG('FORCTO')

Private cPerg2			:= U_CRIAPERG('MTR430')
Private nOpcSel 		:= 0
Private nOpcRel 		:= 0
Private oGetd      
Private aHeader		:= {}
Private aCols			:= {}
Private nOpca			:= 3                              
Private INCLUI			:= .T.
Private lCont 			:= .T.
Private lest            := 0
Public lDescPCof		:= .F.
Public nDescPCof		:= 0

Aadd( aRegs, { cPerg,"01","Selecao de Produtos ?"    ,"Selecao de Produtos ?"   ,"Selecao de Produtos ?"   ,"mv_ch1","N",1,0,0,"C","",""        ,"Selecao","","","","","Produto De Ate","","","","","","","","","","","","","","","","","","","","","","",""} )
Aadd( aRegs, { cPerg,"02","Relatorio ?"              ,"Relatorio ?"             ,"Relatorio ?"             ,"mv_ch2","N",1,0,0,"C","","MV_PAR02","Form. Precos","Form. Precos","Form. Precos","","","Plan. Tempos","Plan. Tempos","Plan. Tempos","","","Custo Unitario","Custo Unitario","Custo Unitario","","","","","","","","","","","","","","","",""} ) 
Aadd( aRegs, { cPerg,"03","Efetua Desconto ?"        ,"Efetua Desconto ?"       ,"Efetua Desconto ?"       ,"mv_ch3","N",1,0,0,"C","","MV_PAR03","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","","","","","","","","","","",""})
Aadd( aRegs, { cPerg,"04","Percentual a Descontar ?" ,"Percentual a Descontar ?","Percentual a Descontar ?","mv_ch4","N",6,2,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd( aRegs, { cPerg,"05","Lista Estrutura ?"        ,"Listar Estrutura ?"      ,"Lista estrutura ?"       ,"mv_ch5","C",1,0,0,"C","","MV_PAR05","SIM","SIM","SIM","","","NAO","NAO","NAO","","","","","","","","","","","","","","","","","","","","",""})
lValidPerg(aRegs)
 

If Pergunte( cPerg, .T. )
	lDescPCof	:= If( Mv_Par03==1, .T., .F. )
	nDescPCof	:= Mv_Par04
	nOpcSel := Mv_Par01
	nOpcRel := Mv_Par02
	lest    :=MV_PAR05
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
                                     
//Aadd( aCols, { Space(15), Space(40), .F. } )

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

aMatOk := {"B5_COD"}

//oGetd := MsGetDados():New(12,7,125,282       ,nOpcA,"AllWaysTrue()","AllWaysTrue()","",.t.  ,,1  ,,,,,,"AllWaysTrue()",,.T.)		

oGetd:= MsNewGetDados():New(12,7,125,282  ,nOpcA,"AllWaysTrue"  ,"AllWaysTrue"  ,"",aMatOk  ,0,999,   "AllwaysTrue","AllwaysTrue","AllwaysTrue" , ,aHeader , aCols)


oDlg:Activate()

Return(lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValProd   บAutor  ณEvaldo V. Batista   บ Data ณ  26/07/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o Cadastro do Produto                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ValProd()
Local nPosDes	:= 2
Local lRet 		:= .T.
Local cCodPro 	:= M->B5_COD
Local aAreaSb1	:= GetArea("SB1")

SB1->( dbSetOrder( 1 ) ) // B1_FILIAL + B1_COD
If SB1->( dbSeek( xFilial('SB1')+cCodPro, .F.) ) 
	aCols[n, nPosDes] := SB1->B1_DESC
Else
	aCols[n, nPosDes] := Space(TamSx3('B1_DESC')[1]) 
	MsgAlert( "O C๓digo do produto informado nใo existe no cadastro de produtos !", "PRODUTO NรO EXISTE..." ) 
	lRet := .F.
EndIf

RestArea( aAreaSb1 ) 
Return( lRet ) 

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

Local cPerg			:= U_CRIAPERG('MTR430')

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

Processa( { || C430Imp() }, 'Calculando...', 'Aguarde...' ) 
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
Static Function C430Imp(lEnd)

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

If nOpcRel == 1 
	Aadd( aStru, {'CEL',			'N', 3, 0} )
	Aadd( aStru, {'NIV1',		'C', 1, 0} )
	Aadd( aStru, {'NIV2',		'C', 1, 0} )
	Aadd( aStru, {'NIV3',		'C', 1, 0} )
	Aadd( aStru, {'CODIGO',		'C', 15, 0} )
	Aadd( aStru, {'DESCRI',		'C', 40, 0} )
	Aadd( aStru, {'UM',			'C', 2, 0} )
	Aadd( aStru, {'QTD',			'N', TamSx3("G1_QUANT")[1], TamSx3("G1_QUANT")[2]} )
	Aadd( aStru, {'VAL_UNIT',	'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'VAL_TOT',	'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'PART',		'N', 19, 3} )
	Aadd( aStru, {'ULT_COMP',	'D', 8, 0} )
	Aadd( aStru, {'LOTE    ',	'N', TamSx3("G1_QUANT")[1], TamSx3("G1_QUANT")[2]} )
	Aadd( aStru, {'TIPO'    ,	'C', 1, 0} )
ElseIf nOpcRel == 3
	Aadd( aStru, {'CODIGO',		'C', 15, 0} )
	Aadd( aStru, {'DESCRI',		'C', 40, 0} )
	Aadd( aStru, {'QTD',			'N', TamSx3("G1_QUANT")[1], TamSx3("G1_QUANT")[2]} )
	Aadd( aStru, {'UM',			'C', 2, 0} )
	Aadd( aStru, {'MP',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'EMB',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'MOD',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'GGF',			'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
	Aadd( aStru, {'TOTAL',		'N', TamSx3("B1_CUSTD")[1], TamSx3("B1_CUSTD")[2]} )
EndIf

If nOpcRel <> 2
	cArqTmp := CriaTrab( aStru, .T. ) 
	dbUseArea( .T.,, cArqTmp, cArqTmp, .F., .F. )
EndIf

lRet:=u_MR430PlanU(.T.)

dbSelectArea( 'SB1' ) 

If lRet .and. nOpcSel == 1
	If nOpcRel == 1 .OR. nOpcRel == 3 
		For _nA := 1 To Len(oGetd:aCols) 
			SB1->( dbSetOrder( 1 ) ) 
			If SB1->( dbSeek( xFilial('SB1') + oGetd:aCols[_nA,1], .F. ) ) 
				nReg := Recno()
				Incproc()
				dbSelectArea( 'SB1' ) 
				aArray := MC010Forma('SB1',nReg,99,aPar[07])
				R430Impr(aArray[1],aArray[2],aArray[3], cArqTmp)
				SB1->( dbGoTo(nReg) ) 
			EndIf
		Next _nA
	ElseIf nOpcRel == 2 
		cArqTmp:=GPlanTemp()
	EndIf
Else
	If nOpcRel == 1  .OR. nOpcRel == 3 
		cProdFim:=apar[02]
		SB1->( dbSetOrder(1) ) 
		If !SB1->( dbSeek( xFilial("SB1") + aPar[01], .F. ) ) 
			SB1->( dbGoTop() )
		EndIf
		While !SB1->(EOF()) .And. SB1->B1_FILIAL+SB1->B1_COD <= xFilial()+cProdFim .And. lRet
			If SB1->B1_COD < aPar[01] .or. SB1->B1_COD > cProdFim
				SB1->( dbSkip() ) 
				Loop
			EndIf
			IncProc()
			nReg := SB1->( Recno() ) 
			dbSelectArea( 'SB1' ) 
			aArray := MC010Forma('SB1',nReg,99,aPar[07])
			R430Impr(aArray[1],aArray[2],aArray[3],cArqTmp)
			SB1->( dbGoTo(nReg) ) 
			SB1->( dbSkip() ) 
		EndDo
	ElseIf nOpcRel == 2 
		cArqTmp:=GPlanTemp()
	EndIf
EndIf

If lCont 
	u_ProcExcel(cArqTmp)
	(cArqTmp)->(dbCloseArea()) 
	fErase( cArqTmp+'.DBF' ) 
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณ R430Impr ณ Autor ณ Eveli Morasco         ณ Data ณ 30/03/93 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Imprime os dados ja' calculados                            ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณSintaxe   ณ  R430Impr(ExpC1,ExpA1,ExpN1)                               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณ ExpC1 = Titulo do custo utilizado                          ณฑฑ
ฑฑณ          ณ ExpA1 = Array com os dados ja' calculados                  ณฑฑ
ฑฑณ          ณ ExpN1 = Numero do elemento inicial a imprimir              ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATR430                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function R430Impr(cCusto,aArray,nPosForm, cAlias)
LOCAL nX

LOCAL nCotacao,nValUnit,nValUnit2
LOCAL cPicQuant:=PesqPictQt("G1_QUANT",13)
LOCAL cPicUnit :=PesqPict("SB1","B1_CUSTD",18)
LOCAL cPicTot	:=PesqPict("SB1","B1_CUSTD",19)
LOCAL cMoeda1,cMoeda2
Local nDecimal :=0
LOCAL nI       :=0
LOCAL lIncRec	:= .F.
Local lTotaliza:= .F.

cCusto := If(cCusto=Nil,'',AllTrim(Upper(cCusto)))
If cCusto == 'ULT PRECO'
	nDecimal := TamSX3('B1_UPRC')[2]
ElseIf 'MEDIO' $ cCusto
	nDecimal := TamSX3('B2_CM1')[2]
Else
	nDecimal := TamSX3('B1_CUSTD')[2]
EndIf

If Str(nQualCusto,1) $ "3/4/5/6"
	nCotacao:=ConvMoeda(dDataBase,,1,Str(nQualCusto-1,1))
	cMoeda1:=GetMV("MV_MOEDA"+Str(nQualCusto-1,1,0))
Else
	nCotacao:=1
	cMoeda1:=GetMV("MV_MOEDA1")
EndIf
cMoeda1:=PADC(Alltrim(cMoeda1),15)

cMoeda2:=PADC(Alltrim(GetMV("MV_MOEDA"+Str(apar[05],1,0))),38)

For nX := 1 To Len(aArray)
   _xTXT := 0
	If apar[04] == 1
		If Val(apar[06]) != 0
			If Val(aArray[nX,2]) > Val(apar[06])  
				Loop                    
			Endif
		Endif
	Endif

	If If( (Len(aArray[ nX ])==12),aArray[nX,12],.T. )
		If nOpcRel == 1 .or. nOpcRel == 3
			If nOpcRel == 1
				RecLock( cAlias, .T. ) 
				If nX < nPosForm-1
					If mv_par02 == 1
						nValUnit := Round(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					Else
						nValUnit := NoRound(aAuxCusto[nX]/aArray[nX][05], nDecimal)
					EndIf
					nValUnit2:= Round(ConvMoeda(dDataBase,,nValUnit/nCotacao,Str(apar[05],1)), nDecimal)
				EndIf

				If (Len(AllTrim(aArray[nX][02]))>1 .or. Val(AllTrim(aArray[nX][02]))<=2)
					_lLstEstr := .T.
				Else
				
					//Se o usuแrio consta neste parametro
					// o sistema permite que o mesmo visualize os dados da estrutura do produto
					
				   //If  AllTrim(Upper(cUsername)) $ Upper(GetMv("BR_000004"))  
				   //		_lLstEstr := .T.				
				   //	Else
				   //		_lLstEstr := .F.				
				   //	EndIf

				   IF lest == 1
				     _lLstEstr := .T. 
				   ELSE
				     _lLstEstr := .F.  
				   ENDIF
				   
				EndIf
                 
				If nOpcRel == 1
					(cAlias)->( FieldPut(1, aArray[nX][01] ) )                 
					(cAlias)->( FieldPut(2, Substr( aArray[nX][02], 1, 1 )  ) ) 
					(cAlias)->( FieldPut(3, Substr( aArray[nX][02], 2, 1 )  ) ) 
					(cAlias)->( FieldPut(4, Substr( aArray[nX][02], 3, 1 )  ) ) 
					If _lLstEstr
						(cAlias)->( FieldPut(5, aArray[nX][04] ) ) 
						(cAlias)->( FieldPut(6, Left(aArray[nX][03],30) ) ) 
					Else
						(cAlias)->( FieldPut(5, "" ) ) 
						(cAlias)->( FieldPut(6, "" ) ) 
					EndIf
				Else
					(cAlias)->( FieldPut(5, aArray[1][04] ) ) 
					(cAlias)->( FieldPut(6, Left(aArray[nX][03],30) ) ) 
				EndIf
				If aArray[nX][04] != Replicate("-",15)
					If nX < nPosForm-1
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Posiciona na UM correta do produto ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						cOldAlias:=Alias()
						dbSelectArea("SB1")
						nOrder:=IndexOrd()
						nRecno:=Recno()
						SB1->( dbSetOrder(1) )
						SB1->( dbSeek(xFilial()+aArray[nX][04]) ) 
						If _lLstEstr
							(cAlias)->( FieldPut(7, SB1->B1_UM ) ) 
						Else
							(cAlias)->( FieldPut(7, "" ) ) 						
						Endif
						
						dUltCompra := SB1->B1_UCOM
						If SB1->B1_TIPO $ 'PA/PI'
							_lote := SB1->B1_LM 
						Else
						 	_lote := 0
						EndIf
						
						SB1->( dbSetOrder(nOrder) )            
						SB1->( dbGoTo(nRecno) ) 
						dbSelectArea(cOldAlias)
						If _lLstEstr
							(cAlias)->( FieldPut(8, aArray[nX][05] ) )
							(cAlias)->( FieldPut(9, nValUnit  ) ) 
						Else
							(cAlias)->( FieldPut(8, 0 ) )
							(cAlias)->( FieldPut(9, 0  ) ) 
						Endif
						(cAlias)->( FieldPut(12, dUltCompra ) ) 
						(cAlias)->( FieldPut(13, _lote      ) ) 
					EndIf          
					If _lLstEstr                                  
						(cAlias)->( FieldPut(10, aArray[nX][06] ) ) 
						(cAlias)->( FieldPut(11, aArray[nX][07] ) ) 
					Else
						(cAlias)->( FieldPut(10, 0 ) ) 
						(cAlias)->( FieldPut(11, 0 ) ) 
					EndIf
				EndIf
				
				(cAlias)->( FieldPut(14, aArray[nX][13] ) ) 
				
			ElseIf nOpcRel == 3 .And. Substr( aArray[nX][02], 1, 1 ) == '-'
				If !lIncRec
					lIncRec	:= .T.
					RecLock( cAlias, .T. ) 
					(cAlias)->( FieldPut(1, aArray[1][04] ) ) 
					(cAlias)->( FieldPut(2, Left(aArray[1][03],30) ) ) 
				EndIf
				If 'TOTAL DE MATERIA PRIMA' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('MP') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE EMBALAGEM' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('EMB') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE MAO DE OBRA' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('MOD') ), aArray[nX][06] ) ) 
				ElseIf 'TOTAL DE GASTOS GERAIS' $ Upper(aArray[nX][03]) 
					lTotaliza:= .T.
					(cAlias)->( FieldPut( FieldPos( AllTrim('GGF') ), aArray[nX][06] ) ) 
				EndIf
				If lTotaliza
					lTotaliza:= .F.
					(cAlias)->( FieldPut( FieldPos( AllTrim('TOTAL')  ), FieldGet( FieldPos( 'TOTAL')  )+aArray[nX][06] ) ) 
				EndIf 
				If Nx == Len(aArray)
					(cAlias)->(MsUnLock())
				EndIf
			EndIf
		EndIf
		If nX == 1 .And. apar[04] == 2
			nX += (nPosForm-3)
		EndIf
		(cAlias)->( MsUnLock() ) 
	EndIf
Next nX
If nOpcRel <> 3
	RecLock( cAlias, .T. ) 
	(cAlias)->( MsUnLock() ) 
	RecLock( cAlias, .T. ) 
	(cAlias)->( MsUnLock() ) 
EndIf
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPlanTemp บAutor  ณEvaldo V. Batista   บ Data ณ  05/08/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa uma query para geracao de relatorio de Produto e   บฑฑ
ฑฑบ          ณtempo por Centro de Custo.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 / Brascola / Estoque                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GPlanTemp()
Local cQuery 	:= ''
Local cAlias 	:= 'TMPCC'
Local cAliTmp	:= 'TMPCCDBF'
Local cArqTmp	:= ''
Local cGrpCc	:= ""
Local cProds	:= ""
Local aJustCpo	:= {}
Local nDecimal := 6
Local aStruTmp	:= {}
Local aStruProd:= {}
Local cListProd:= ''

If nOpcSel == 1 
	aEval( oGetd:aCols, {|x| cProds += x[1]+"','" } ) 
	cProds := Substr( cProds, 1, Len( cProds ) - 3 ) 
Else
	cQuery := " SELECT B1_COD, B1_DESC "
	cQuery += " 	FROM "+RetSqlName('SB1')+" SB1 "
	cQuery += " 	WHERE SB1.D_E_L_E_T_ <> '*' "
	cQuery += " 		AND SB1.B1_COD BETWEEN '"+Mv_Par01+"' AND '"+Mv_Par02+"' "
	If Select(cAlias)>0
		dbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
	EndIf
	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 
	(cAlias)->( dbGoTop() ) 
	While !(cAlias)->( Eof() ) 
		Aadd( oGetd:aCols, {(cAlias)->B1_COD,(cAlias)->B1_DESC, .F.} ) 
		(cAlias)->( dbSkip() )
	EndDo
	(cAlias)->( dbCloseArea() ) 
EndIf

cQuery := " SELECT DISTINCT H1_CCUSTO "
cQuery += " 	FROM "+RetSqlName('SH1')+" SH1 "
cQuery += " 	WHERE SH1.D_E_L_E_T_ <> '*' "
cQuery += " 		AND SH1.H1_CODIGO IN (SELECT DISTINCT G2_RECURSO "
cQuery += " 										FROM "+RetSqlName('SG2')+" SG2 "
cQuery += " 										WHERE SG2.D_E_L_E_T_ <> '*' "
cQuery += ")"

//cQuery := ChangeQuery( cQuery ) 
If Select(cAlias)>0
		dbSelectArea(cAlias)
		(cAlias)->(dbCloseArea())
EndIf
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 

(cAlias)->( dbGoTop() )
While !(cAlias)->( Eof() ) 
	Aadd( aJustCpo, {(cAlias)->H1_CCUSTO, "CC_"+AllTrim((cAlias)->H1_CCUSTO)} )
	(cAlias)->( dbSkip() ) 
EndDo
(cAlias)->( dbCloseArea() ) 

Aadd( aStruTmp, {'PRODUTO', 	'C', TamSx3('B1_COD')[1], TamSx3('B1_COD')[2] } ) 
Aadd( aStruTmp, {'DESCRI', 	'C', TamSx3('B1_DESC')[1], TamSx3('B1_DESC')[2] } ) 

For _nK := 1 To Len( aJustCpo ) 
	Aadd( aStruTmp, {aJustCpo[_nK,2],'N', 16, 6} )
Next _nK 

ProcRegua( Len(oGetd:aCols) ) 

cArqTmp := CriaTrab(aStruTmp, .T.)
If File( cArqTmp+'.DTC' )
	dbUseArea( .T.,, cArqTmp, cAliTmp, .T., .F. )
	
	For _nK := 1 To Len(oGetd:aCols) 
		IncProc( 'Processando Produto: ' + oGetd:aCols[_nK,1] ) 
		aStruProd := {}
		Aadd( aStruProd, {oGetd:aCols[_nK,1],1} )
		lWhile := .T.
		While lWhile
			lWhile := .F.
			cListProd := "'"
			aEval( aStruProd, {|x| cListProd += AllTrim(x[1]) + "','" } ) 
			cListProd := Substr( cListProd, 1, Len(cListProd) - 2 ) 

			cQuery := " SELECT G1_COMP, G1_QUANT "
			cQuery += " 	FROM "+RetSqlName('SG1')+" SG1 "
			cQuery += " 	Where SG1.D_E_L_E_T_ <> '*' "
			cQuery += "   		AND SG1.G1_COD IN ("+cListProd+") "
			cQuery += " 		AND SG1.G1_COMP NOT IN ("+cListProd+") "
			//cQuery := ChangeQuery( cQuery ) 
			If Select(cAlias)>0
				dbSelectArea(cAlias)
				(cAlias)->(dbCloseArea())
			EndIf
			dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 

			While !(cAlias)->( Eof() ) 
				If aScan( aStruProd, {|x| AllTrim(x[1]) == AllTrim((cAlias)->G1_COMP) } ) == 0
					lWhile := .T.
					Aadd( aStruProd, {(cAlias)->G1_COMP, (cAlias)->G1_QUANT} ) 
				EndIf
				(cAlias)->( dbSkip() ) 
			EndDo
		   (cAlias)->( dbCloseArea() ) 
	   EndDo
		cListProd := "'"
		aEval( aStruProd, {|x| cListProd += AllTrim(x[1]) + "','" } ) 
		cListProd := Substr( cListProd, 1, Len(cListProd) - 2 ) 

		cQuery := " SELECT  SG2.G2_PRODUTO AS 'PRODUTO', SH1.H1_CCUSTO, " 
		cQuery += " 		CAST( SUM( (SG2.G2_TEMPAD*SG2.G2_MAOOBRA)/SG2.G2_LOTEPAD ) AS NUMERIC(16,6) ) AS 'TEMPO', "
		cQuery += " 	ISNULL( (SELECT SG1.G1_QUANT FROM "+RetSqlName('SG1')+" SG1 WHERE SG1.D_E_L_E_T_ <> '*' "
		cQuery += " 							AND SG1.G1_COD IN ("+cListProd+") "
		cQuery += " 							AND SG1.G1_COMP = SG2.G2_PRODUTO AND SG1.G1_FILIAL = '"+xFilial("SG1")+"'), 1 ) AS 'G1_QUANT' "
		cQuery += " 	  		FROM "+RetSqlName("SG2")+" SG2 INNER JOIN "+RetSqlName("SH1")+" SH1 ON SH1.D_E_L_E_T_ <> '*' "
		cQuery += " 								AND SH1.H1_CODIGO = SG2.G2_RECURSO "
		cQuery += " 	  		WHERE SG2.D_E_L_E_T_ <> '*' "
		cQuery += " 				AND SG2.G2_PRODUTO IN ("+cListProd+") "
		cQuery += " 				AND SG2.G2_LOTEPAD <> 0 "
		cQuery += " 		GROUP BY SG2.G2_PRODUTO, SH1.H1_CCUSTO "

		//cQuery := ChangeQuery( cQuery ) 
		MemoWrite("\QUERYSYS\FORMCUSTO.SQL", cQuery)
		If Select(cAlias)>0
			dbSelectArea(cAlias)
			(cAlias)->(dbCloseArea())
		EndIf
		dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .F. ) 
		TcSetField( cAlias, 'TEMPO','N', 16, nDecimal )
		
		(cAlias)->( dbGoTop() )
		If !(cAlias)->( Eof() ) 
			RecLock(cAliTmp, .T. ) 
			(cAliTmp)->PRODUTO := aStruProd[1,1]
			(cAliTmp)->DESCRI  := Posicione( 'SB1',1,xFilial('SB1')+aStruProd[1,1], 'B1_DESC' ) 
			While !(cAlias)->( Eof() ) 
				//(cAliTmp)->( FieldPut(FieldPos('CC_'+AllTrim((cAlias)->H1_CCUSTO)), FieldGet( FieldPos('CC_'+AllTrim((cAlias)->H1_CCUSTO)) ) +(cAlias)->( G1_QUANT * TEMPO ) ) )
				(cAliTmp)->( FieldPut(FieldPos('CC_'+AllTrim((cAlias)->H1_CCUSTO)), FieldGet( FieldPos('CC_'+AllTrim((cAlias)->H1_CCUSTO)) ) + IIF((cAlias)->( G1_QUANT)= 1, (cAlias)->(TEMPO),(cAlias)->(TEMPO)/100 ) ) )
				
				(cAlias)->( dbSkip() ) 
			EndDo
			(cAliTmp)->( MsUnLock() ) 
		EndIf
		(cAlias)->( dbCloseArea() ) 
	Next _nK	
Else
	MsgAlert( 'Nใo foi possํvel criar o arquivo temporแrio', 'Arquivo Temporแrio ' )
EndIf
Return( cAliTmp )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณMR430Plan ณ Autor ณ Eveli Morasco         ณ Data ณ 30/03/93 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณ Verifica se a Planilha escolhida existe                    ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ MATR430                                                    ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MR430PlanU(lGravado)
Local cArq := ""
DEFAULT lGravado:=.F.
cArq:=AllTrim(If(lGravado,apar[03],&(ReadVar())))+".PDV"
If !File(cArq)
	Help(" ",1,"MR430NOPLA")
	Return .F.
EndIf
Return .T.