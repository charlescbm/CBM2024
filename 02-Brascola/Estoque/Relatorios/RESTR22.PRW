user function restr22()
**********************
Local aRegs	:= {}
Local cPerg 			:= U_CriaPerg('ESP4301')

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
    
    
    _tabela :=mv_par02  

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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetProd   �Autor  �Evaldo V. Batista   � Data �  26/07/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa para obter lista de Produtos para a geracao do     ���
���          � relatorio                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
oDlg:cCaption := "Sele��o de Produtos"
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
oDlg:cCaption := "Sele��o de Produtos"
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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunFormPrc�Autor  �Evaldo V. Batista   � Data �  26/07/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ajusta os parametros do relatorio para permitir a sele��o de���
���          � produtos pela sele��o manual                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function RunFormPrc()
Local cPerg			:= 'MTR430' 

Private aPar			:= Array(20)
Private aParC010		:= Array(20)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Produto inicial                              �
//� mv_par02     // Produto final                                �
//� mv_par03     // Nome da planilha utilizada                   �
//� mv_par04     // Imprime estrutura : Sim / Nao                �
//� mv_par05     // Moeda Secundaria  : 1 2 3 4 5                �
//� mv_par06     // Nivel de detalhamento da estrutura           �
//� mv_par07     // Qual a Quantidade Basica                     �
//� mv_par08     // Considera Qtde Neg na estrutura: Sim/Nao     �
//� mv_par09     // Considera Estrutura / Pre Estrutura          �
//����������������������������������������������������������������
pergunte(cPerg,.F.)
//Salvar variaveis existentes
For ni := 1 to 20
	aPar[ni] := &("mv_par"+StrZero(ni,2))
Next ni
//Fixa o conteudo da pergunta para nao imprimir a estrutura
//aPar[6] := '02'

Processa( { || E430Imp() }, 'Calculando...', 'Aguarde...' ) 
Return Nil

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �C430Imp   �Autor  �Evaldo V. Batista   � Data �  26/07/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
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
PRIVATE cArqMemo := "BRAS2013"
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
		      	
	lConsNeg := apar[08] = 1     // Esta variavel ser� usada na fun��o MC010Forma
	
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
			
			IF SB1->B1_TIPO <> '3'
			 SB1->( dbSkip() ) 
				Loop
			EndIf  
			
			IF SB1->B1_MSBLQL <> '2'
			 SB1->( dbSkip() ) 
				Loop
			EndIf  
			
	//		if !DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
	//		    SB1->( dbSkip() ) 
	//			Loop
	//		EndIf  
			
			
			IncProc()
			nReg := SB1->( Recno() ) 
			dbSelectArea( 'SB1' ) 
			aArray := MC010Forma('SB1',nReg,99,aPar[07])
			a430I(aArray[1],aArray[2],aArray[3])
			SB1->( dbGoTo(nReg) ) 
			SB1->( dbSkip() ) 
		EndDo
	EndIf

if select ('TRAC') > 0
  u_ProcExcel("TRAC")
  DBSELECTAREA("TRAC")
  DBCLOSEAREA()

ENDIF



ferase(_cArqTmp)
	
return
	
*******************************************************	
static function a430i(cCusto,aArray,nPosForm)

LOCAL REVEN    		:= 0
LOCAL CUSTO_MP   	:= 0
LOCAL CUSTO_MOD  	:= 0
LOCAL BENEF    		:= 0
LOCAL CUSTO_EM  	:= 0
LOCAL CUSTO_FAB  	:= 0   
LOCAL DESPADM    	:= 0
LOCAL DESPADMV   	:= 0  
LOCAL DESPMKT    	:= 0
LOCAL DESPMKTV   	:= 0
LOCAL DESPFIN    	:= 0
LOCAL DESPFINV   	:= 0
LOCAL DESPCOM    	:= 0
LOCAL DESPCOMV   	:= 0 
LOCAL DESPFIXA   	:= 0
LOCAL DESPFIXAV  	:= 0
LOCAL LUCRO  		:= 0
LOCAL LUCROV  		:= 0  
LOCAL MARGCONT  	:= 0
LOCAL MARGCONTV  	:= 0
LOCAL COFINS  		:= 0
LOCAL COFINSV  		:= 0
LOCAL PIS  			:= 0
LOCAL PISV  		:= 0
LOCAL ICMS  		:= 0
LOCAL ICMSV  		:= 0
LOCAL IMPVAR  		:= 0
LOCAL PRC_LIQ  		:= 0
LOCAL COMISSAO  	:= 0
LOCAL COMISSAOV  	:= 0
LOCAL FRETE  		:= 0
LOCAL FRETEV  		:= 0
LOCAL DESPV  		:= 0
LOCAL MED_FAT  		:= 0
LOCAL PRC_VENDA  	:= 0

	
	For nX := 1 To Len(aArray)
	   If    'Total Revenda' $ aArray[nX][03]
			REVEN:= aArray[nX][06] 
		ElseIf 'Total Materia Prima' $ aArray[nX][03]
			CUSTO_MP:=aArray[nX][06] 
		ElseIf 'Total M.O.D.' $ aArray[nX][03]
			CUSTO_MOD:=aArray[nX][06] 
		ElseIf 'Total de Beneficiamento' 		$ aArray[nX][03]
			BENEF:=aArray[nX][06] 
		ElseIf 'Total de Embalagem' $ (aArray[nX][03])
			CUSTO_EM:=aArray[nX][06] 
	  	ELSEIF 'TOTAL CUSTOS FABRICACAO' $ Upper(aArray[nX][03]) 
	   		CUSTO_FAB:=aArray[nX][06] 
	  	ELSEIF 'Despesa Adm. (%)' $ aArray[nX][03]
	  		DESPADM:=aArray[nX][06]           	  		
	  	ELSEIF 'Despesa Adm. - Valor' $ aArray[nX][03]
	  		DESPADMV:=aArray[nX][06] 
	  	ELSEIF 'Despesa Mkt. (%)' $ aArray[nX][03]
	  		DESPMKT:=aArray[nX][06]           	  		
	  	ELSEIF 'Despesa Mkt - Valor' $ aArray[nX][03]
	  		DESPMKTV:=aArray[nX][06] 
	  	ELSEIF 'Despesa Financ. (%)' $ aArray[nX][03]
	  		DESPFIN:=aArray[nX][06]           
	  	ELSEIF 'Despesa Financ. - Valor' $ aArray[nX][03]
	  		DESPFINV:=aArray[nX][06] 	  			     
	  	ELSEIF 'Despesa Coml. (%)' $ aArray[nX][03]
	  		DESPCOM:=aArray[nX][06]           
	  	ELSEIF 'Despesa Coml - Valor' $ aArray[nX][03]
	  		DESPCOMV:=aArray[nX][06] 	  		
	  	ELSEIF 'TOTAL DESPESAS FIXAS (%)' $ aArray[nX][03]
	  		DESPFIXA:=aArray[nX][06]           
	  	ELSEIF 'TOTAL DESPESAS FIXAS - Valor' $ aArray[nX][03]
	  		DESPFIXAV:=aArray[nX][06] 	  			 
	  	ELSEIF 'LUCRO (%)' $ Upper(aArray[nX][03])
	  		LUCRO:=aArray[nX][06]           
	  	ELSEIF 'LUCRO - VALOR' $ Upper(aArray[nX][03])
	  		LUCROV:=aArray[nX][06] 	  
	  	ELSEIF 'MARGEM DE CONTRIBUICAO (%)' $ aArray[nX][03]
	  		MARGCONT:=aArray[nX][06]           
	  	ELSEIF 'MARGEM DE CONTRIBUICAO - Valor' $ aArray[nX][03]
	  		MARGCONTV:=aArray[nX][06] 	  	  		
	  	ELSEIF 'Cofins (%)' $ aArray[nX][03]
	  		COFINS:=aArray[nX][06]           
	  	ELSEIF 'Cofins - Valor' $ aArray[nX][03]
	  		COFINSV:=aArray[nX][06] 	  
	  	ELSEIF 'Pis (%)' $ aArray[nX][03]
	  		PIS:=aArray[nX][06]           
	  	ELSEIF 'Pis - Valor' $ aArray[nX][03]
	  		PISV:=aArray[nX][06] 	  
	  	ELSEIF 'Icms (%)' $ aArray[nX][03]
	  		ICMS:=aArray[nX][06]           
	  	ELSEIF 'Icms - Valor' $ aArray[nX][03]
	  		ICMSV:=aArray[nX][06] 
	  	ELSEIF 'TOTAL IMPOSTOS VARIAVEIS' $ Upper(aArray[nX][03]) 
	   		IMPVAR:=aArray[nX][06]      
	  	ELSEIF 'PRECO VENDA LIQUIDO ( ROL )' $ Upper(aArray[nX][03]) 
	   		PRC_LIQ:=aArray[nX][06]      
	  	ELSEIF 'Comissao (%)' $ aArray[nX][03]
	  		COMISSAO:=aArray[nX][06]           
	  	ELSEIF 'Comissao - Valor' $ aArray[nX][03]
	  		COMISSAOV:=aArray[nX][06]
	  	ELSEIF 'Frete Venda (%)' $ aArray[nX][03]
	  		FRETE:=aArray[nX][06]           
	  	ELSEIF 'Frete Venda - Valor' $ aArray[nX][03]
	  		FRETEV:=aArray[nX][06] 
	  	ELSEIF 'TOTAL DESPESAS VARIAVEIS' $ aArray[nX][03]
	  		DESPV:=aArray[nX][06]          
	  	ELSEIF 'PRECO MEDIO FATURADO' $ Upper(aArray[nX][03]) 
	   		MED_FAT:=aArray[nX][06]       
	  	ELSEIF '#PRECO DE VENDA' $ Upper(aArray[nX][03]) 
	   		PRC_VENDA:=aArray[nX][06]       
 
		EndIf
	NEXT 
	
	
IF LFIRST = .T.	
	

	Aadd(_aCampos,{"CODIGO    " 	,"C",15,0})
    Aadd(_aCampos,{"DESCR     " 	,"C",30,0})
	Aadd(_aCampos,{"REVEN 		"	,"N",14,4})
    Aadd(_aCampos,{"CUSTO_MP "		,"N",14,4}) 
	Aadd(_aCampos,{"CUSTO_MOD" 		,"N",14,4})
    Aadd(_aCampos,{"BENEF" 			,"N",14,4})
    Aadd(_aCampos,{"CUSTO_EM "		,"N",14,4}) 
	Aadd(_aCampos,{"CUSTO_FAB"     	,"N",14,4})
    Aadd(_aCampos,{"DESPADM"   		,"N",14,4})
    Aadd(_aCampos,{"DESPADMV"    	,"N",14,4})   
    Aadd(_aCampos,{"DESPMKT"   		,"N",14,4})
    Aadd(_aCampos,{"DESPMKTV"    	,"N",14,4})
    Aadd(_aCampos,{"DESPFIN"   		,"N",14,4})
    Aadd(_aCampos,{"DESPFINV"    	,"N",14,4})
    Aadd(_aCampos,{"DESPCOM"    	,"N",14,4})
    Aadd(_aCampos,{"DESPCOMV"    	,"N",14,4})
    Aadd(_aCampos,{"DESPFIXA"    	,"N",14,4})
    Aadd(_aCampos,{"DESPFIXAV"    	,"N",14,4})
    Aadd(_aCampos,{"LUCRO" 			,"N",14,4})
    Aadd(_aCampos,{"LUCROV" 		,"N",14,4})
    Aadd(_aCampos,{"MARGCONT" 		,"N",14,4})
    Aadd(_aCampos,{"MARGCONTV" 		,"N",14,4})
    Aadd(_aCampos,{"COFINS" 		,"N",14,4})
    Aadd(_aCampos,{"COFINSV" 		,"N",14,4})
    Aadd(_aCampos,{"PIS" 			,"N",14,4})
	Aadd(_aCampos,{"PISV" 			,"N",14,4})
    Aadd(_aCampos,{"ICMS" 			,"N",14,4}) 
    Aadd(_aCampos,{"ICMSV" 			,"N",14,4}) 
    Aadd(_aCampos,{"IMPVAR" 		,"N",14,4})
    Aadd(_aCampos,{"PRC_LIQ" 		,"N",14,4}) 
    Aadd(_aCampos,{"COMISSAO" 		,"N",14,4})  
    Aadd(_aCampos,{"COMISSAOV" 		,"N",14,4})  
    Aadd(_aCampos,{"FRETE" 			,"N",14,4})  
    Aadd(_aCampos,{"FRETEV" 		,"N",14,4})  
    Aadd(_aCampos,{"DESPV" 			,"N",14,4})  
    Aadd(_aCampos,{"MED_FAT" 		,"N",14,4})
    Aadd(_aCampos,{"PRC_VENDA" 		,"N",14,4})
    
    If Select("TRAC") > 0
	    TRAC->(DBCLOSEAREA())
    Endif

   _cArqTmp := CriaTrab(_aCampos,.T.)
     dbUseArea( .T.,,_cArqTmp, "TRAC", .F., .F. )
    _cOrdem := "CODIGO"
    IndRegua ( "TRAC",_cArqTmp,_cOrdem,,,"Selecionando Registros...")   
   

   DBSELECTAREA("TRAC")
   DBGOTOP()
   RECLOCK("TRAC",.T.)
   TRAC->CODIGO			:= SB1->B1_COD
   TRAC->DESCR			:= SB1->B1_DESC
   TRAC->REVEN 			:= REVEN
   TRAC->CUSTO_MP  		:= CUSTO_MP 
   TRAC->CUSTO_MOD  	:= CUSTO_MOD 
   TRAC->BENEF 			:= BENEF
   TRAC->CUSTO_EM 		:= CUSTO_EM
   TRAC->CUSTO_FAB  	:= CUSTO_FAB 
   TRAC->DESPADM    	:= DESPADM   
   TRAC->DESPADMV   	:= DESPADMV  
   TRAC->DESPMKT    	:= DESPMKT   
   TRAC->DESPMKTV   	:= DESPMKTV  
   TRAC->DESPFIN    	:= DESPFIN   
   TRAC->DESPFINV   	:= DESPFINV  
   TRAC->DESPCOM    	:= DESPCOM   
   TRAC->DESPCOMV   	:= DESPCOMV  
   TRAC->DESPFIXA   	:= DESPFIXA  
   TRAC->DESPFIXAV  	:= DESPFIXAV 
   TRAC->LUCRO  		:= LUCRO 
   TRAC->LUCROV  		:= LUCROV 
   TRAC->MARGCONT  		:= MARGCONT 
   TRAC->MARGCONTV  	:= MARGCONTV 
   TRAC->COFINS  		:= COFINS 
   TRAC->COFINSV  		:= COFINSV 
   TRAC->PIS  			:= PIS 
   TRAC->PISV  			:= PISV 
   TRAC->ICMS  			:= ICMS 
   TRAC->ICMSV  		:= ICMSV 
   TRAC->IMPVAR  		:= IMPVAR 
   TRAC->PRC_LIQ  		:= PRC_LIQ 
   TRAC->COMISSAO  		:= COMISSAO 
   TRAC->COMISSAOV  	:= COMISSAOV 
   TRAC->FRETE  		:= FRETE 
   TRAC->FRETEV  		:= FRETEV 
   TRAC->DESPV  		:= DESPV 
   TRAC->MED_FAT  		:= MED_FAT 
   TRAC->PRC_VENDA  	:= PRC_VENDA 

/*    
   IF TRAC->CUSTOT = 0
      TRAC->CUSTOT := SB1->B1_CUSTDM
   ENDIF
  
   DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
   TRAC->TAB_PRECO:=DA1->DA1_PRCVEN
 */  
  TRAC->(MSUNLOCK())  
LFIRST := .f.    
ELSE
   DBSELECTAREA("TRAC")
   while .not. reclock("TRAC",.T.)
	enddo
   TRAC->CODIGO			:= SB1->B1_COD
   TRAC->DESCR			:= SB1->B1_DESC
   TRAC->REVEN 			:= REVEN
   TRAC->CUSTO_MP  		:= CUSTO_MP 
   TRAC->CUSTO_MOD  	:= CUSTO_MOD 
   TRAC->BENEF 			:= BENEF
   TRAC->CUSTO_EM 		:= CUSTO_EM
   TRAC->CUSTO_FAB  	:= CUSTO_FAB 
   TRAC->DESPADM    	:= DESPADM   
   TRAC->DESPADMV   	:= DESPADMV  
   TRAC->DESPMKT    	:= DESPMKT   
   TRAC->DESPMKTV   	:= DESPMKTV  
   TRAC->DESPFIN    	:= DESPFIN   
   TRAC->DESPFINV   	:= DESPFINV  
   TRAC->DESPCOM    	:= DESPCOM   
   TRAC->DESPCOMV   	:= DESPCOMV  
   TRAC->DESPFIXA   	:= DESPFIXA  
   TRAC->DESPFIXAV  	:= DESPFIXAV 
   TRAC->LUCRO  		:= LUCRO 
   TRAC->LUCROV  		:= LUCROV 
   TRAC->MARGCONT  		:= MARGCONT 
   TRAC->MARGCONTV  	:= MARGCONTV 
   TRAC->COFINS  		:= COFINS 
   TRAC->COFINSV  		:= COFINSV 
   TRAC->PIS  			:= PIS 
   TRAC->PISV  			:= PISV 
   TRAC->ICMS  			:= ICMS 
   TRAC->ICMSV  		:= ICMSV 
   TRAC->IMPVAR  		:= IMPVAR 
   TRAC->PRC_LIQ  		:= PRC_LIQ 
   TRAC->COMISSAO  		:= COMISSAO 
   TRAC->COMISSAOV  	:= COMISSAOV 
   TRAC->FRETE  		:= FRETE 
   TRAC->FRETEV  		:= FRETEV 
   TRAC->DESPV  		:= DESPV 
   TRAC->MED_FAT  		:= MED_FAT 
   TRAC->PRC_VENDA  	:= PRC_VENDA
 /*   
   IF TRAC->CUSTOT = 0
      TRAC->CUSTOT := SB1->B1_CUSTDM
   ENDIF
   
   DA1->(DBSEEK(XFILIAL("DA1")+alltrim(_tabela)+SB1->B1_COD))
   TRAC->TAB_PRECO:=DA1->DA1_PRCVEN
 */
TRAC->(MSUNLOCK())
ENDIF




RETURN  
