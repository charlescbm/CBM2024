#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)
/*
#DEFINE  P_CLICK  01
#DEFINE  P_DESC    02
#DEFINE  P_COD     03
#DEFINE  P_PRCVEN  04
#DEFINE  P_POSEST  05
#DEFINE  P_SALPEDI 06
#DEFINE  P_FABRIC  07
#DEFINE  P_POSIPI  08
#DEFINE  P_POSPRO1 09
*/

#DEFINE  P_CLICK   01
#DEFINE  P_DESC    02
#DEFINE  P_COD     03
#DEFINE  P_POSEST  04
#DEFINE  P_SALPEDI 05
#DEFINE  P_PRCVEN  06
#DEFINE  P_POSPRO1 07
#DEFINE  P_POSPRO2 08
#DEFINE  P_POSPRO3 09
#DEFINE  P_FABRIC  10
#DEFINE  P_POSIPI  11

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ITECX040 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de Produto              นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
//DESENVOLVIDO POR INOVEN

*--------------------*
User Function ITECX040
*--------------------*  

Private oOK   := LoadBitmap(GetResources(), "LBOK")
Private oNo   := LoadBitmap(GetResources(), "LBNO")
// Variaveis Private da Funcao
Private _oDlg	// Dialog Principal
                    
// Privates das ListBoxes
//Private aListBKPr := {}
Private oListBox1  
Private _oMldDlg
Private _oBotDlg
Private aButtons := {}
Private _cQry    := ""
Private _cMldSel := Space(20)
Private aCboBx1  := {'Descri็ใo','C๓digo','Fabricante','Pos.Ipi/Ncm'}
Private cCboBx1    
Private cSomaEst := SUPERGETMV("HL_SOMAEST" , .T., "N",)
Private _oContExpr
Private _lContExpr := .T.

Private aListBox1 := {}

//aadd(aButtons,{"BMPTABLE" , {|| XFLTAB6F3(aListBox1) },"Filtro"})
MsgRun("Aguarde Carregando Produtos...",,{||LeDadosPro()}) //wap.o

//Aadd(aListBox1,{.F.,Space(80),'',0,0,0,'',''}) 
Aadd(aListBox1,{.F.,Space(80),'',0,0,0,0,0,0,'',''})

DEFINE MSDIALOG _oDlg TITLE "Cadastro de Produtos - [ Ativo ]" FROM C(068),C(181) TO C(406),C(885) PIXEL
   
      oListBox1 := TCBrowse():New( 32 , 02, 449, 160,,;
                              {'','Descri็ใo','C๓digo','Estoque','Prev.Entr','Pre็o Venda','Promo Tab1','Promo Tab2','Promo Tab3','Pos. Ipi/Ncm','Fabricante'},;
                              {40,150,50,40,40},;
                              _oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	xSetBrws()                         	

@ 200, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1))
//_cMldSel := iIF( cCboBx1==cCboBx1[1], Space(TAMSX3("AB7_NUMOS")[1]+TAMSX3("AB7_ITEM")[1]), Space(20)) 
@ 200, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' Size 070,010 Of _oDlg Pixel
@ 200, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel) ) Of _oDlg Pixel

@ 200, 190 CheckBox _oContExpr Var _lContExpr Prompt "Cont้m a Expressใo" Size C(060),C(008) PIXEL OF _oDlg //on Click(iIF(cCboBx1<>aCboBx1[1],_lContExpr:=.F.,_lContExpr:=_lContExpr))

@ 200, 265 Button _oBotDlg  Prompt 'Produtos em promo็ใo' Size 060,010 Action( FSOrdProm (@aListBox1) ) Of _oDlg Pixel

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1, xSB1(aListBox1) ,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XFILAB9 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  15/08/11     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro                                                      นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Magiccomp                                                    บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*-----------------------*
Static Function xSetBrws
*-----------------------*
// Seta vetor para a browse                            
oListBox1:SetArray(aListBox1) 
	
IF LEN(aListBox1) == 1
	aListBox1[1,1] := .T.		
ENDIF


If Len(oListBox1:aColumns) == 0
	oListBox1:AddColumn(TCColumn():New(" "  			,{||If( aListBox1[oListBox1:nAt,P_CLICK] ,oOK,oNo)},,,,"LEFT",,.T.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Descri็ใo"  	,{||aListBox1[oListBox1:nAt,P_DESC]	},,,,"LEFT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("C๓digo"  		,{||aListBox1[oListBox1:nAt,P_COD]	},,,,"LEFT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Estoque"		,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_POSEST],TM(aListBox1[oListBox1:nAt,P_POSEST],TamSX3("B2_QATU")[1],TamSX3("B2_QATU")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))	
	oListBox1:AddColumn(TCColumn():New("Prev.Entr"		,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_SALPEDI],TM(aListBox1[oListBox1:nAt,P_SALPEDI],TamSX3("B2_SALPEDI")[1],TamSX3("B2_QATU")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))	
	oListBox1:AddColumn(TCColumn():New("Pre็o Venda" 	,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_PRCVEN],TM(aListBox1[oListBox1:nAt,P_PRCVEN],TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Promo Tab1" 	,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_POSPRO1],TM(aListBox1[oListBox1:nAt,P_POSPRO1],TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Promo Tab2" 	,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_POSPRO2],TM(aListBox1[oListBox1:nAt,P_POSPRO2],TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Promo Tab3" 	,{||AllTrim(TransForm(aListBox1[oListBox1:nAt,P_POSPRO3],TM(aListBox1[oListBox1:nAt,P_POSPRO3],TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]))) },,,,"RIGHT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Fabricante"  	,{||aListBox1[oListBox1:nAt,P_FABRIC]	},,,,"LEFT",,.F.,.F.,,,,.F.,))
	oListBox1:AddColumn(TCColumn():New("Pos. Ipi/Ncm"	,{||aListBox1[oListBox1:nAt,P_POSIPI]	},,,,"LEFT",,.F.,.F.,,,,.F.,))	
EndIf

// Evento de duplo click na celula
// Renato Bandeira em 24/11/14 - Ao clicar ja seleciona e confirma
oListBox1:bLDblClick   := {|| xLimpBox(aListBox1),;
                              aListBox1[oListBox1:nAt,P_CLICK]:=.T. ,;
                              oListBox1:Refresh(),nOpcA:=1, xSB1(aListBox1) ,_oDlg:End() }  


If Len(aListBox1)>0
	//oListBox1:SetBlkBackColor( {|| IIF(aListBox1[oListBox1:nAt,P_POSEST] > 0,CLR_WHITE,CLR_YELLOW )})	
	oListBox1:SetBlkBackColor( {|| IIF((aListBox1[oListBox1:nAt,P_POSPRO1] > 0 .Or. aListBox1[oListBox1:nAt,P_POSPRO2] > 0 .Or. aListBox1[oListBox1:nAt,P_POSPRO3] > 0) .And. aListBox1[oListBox1:nAt,P_POSEST] > 0;
	,CLR_HGREEN,IIF(aListBox1[oListBox1:nAt,P_POSEST] > 0,CLR_WHITE,CLR_YELLOW ))})
EndIf                                                                  

oListBox1:Refresh()
_oDlg:Refresh()

Return                   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XFILAB9 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  15/08/11     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro                                                      นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Magiccomp                                                    บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*-------------------------------------------*
Static Function _xFilTela(cCboBx1,_cMldSel,_nOpc)
*-------------------------------------------* 
Local _nPos := 0                         
Local _aOrcAux	:=	{}
Local nCtt:= 0

Default _nOpc := 0
Default cCboBx1 := aCboBx1[1]

//If aListBox1[1][4] == 0 .AND. aListBox1[1][5] == 0 .AND. Alltrim(aListBox1[1][2]) == ''
If aListBox1[1][4] == 0 .AND. aListBox1[1][8] == 0 .AND. Alltrim(aListBox1[1][2]) == ''
	MsgRun("Aguarde Carregando Produtos...",,{||LeDadosPro()}) //wap.n
EndIf

// Se Contem expressao nao selecionado e nao tiver nada informado na busca, retorna o array original
IF !_lContExpr	.and. Empty(_cMldSel) .and. Len(aListBox1) < Len(aListBKPr)
	aListBox1	 := aClone( aListBKPr  )
	xSetBrws()
	return
Endif

IF cCboBx1 == aCboBx1[1]
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_DESC] < y[P_DESC] })
		// Atualiza o Bkp com a ordem atual
		aListBKPr := aClone( aListBox1 )
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_DESC],01,LEN(AllTrim(_cMldSel))) }) 
		Else
			//_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_DESC]) })
			// Renato Bandeira em 21/12/14 - Vai tratar contem expressao - se nao selecionado, usarแ completo
			_nPos 			:= 1	// marca a primeira posicao
			For nCtt	:=	1	to	Len(aListBox1)
				_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_DESC]) }, _nPos)
				If _nPos >	0
					Aadd(_aOrcAux, aListBox1[_nPos] )
					++_nPos
				Else
					Exit
				Endif
			Next			
			_nOpc := 1
			_nPos 			:= 1	// marca a primeira posicao
		ENDIF
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF
	
ElseIF cCboBx1 == aCboBx1[2]
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_COD] < y[P_COD] })
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_COD],01,LEN(AllTrim(_cMldSel))) }) 
		Else			
			_nPos 			:= 1	// marca a primeira posicao
			For nCtt	:=	1	to	Len(aListBox1)
				_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_COD]) }, _nPos)
				If _nPos >	0
					Aadd(_aOrcAux, aListBox1[_nPos] )
					++_nPos
				Else
					Exit
				Endif
			Next			
			_nOpc := 1
			_nPos 			:= 1	// marca a primeira posicao
		ENDIF
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF                                                                                                             ADMIN

ElseIF cCboBx1 == aCboBx1[3]
	IF _nOpc == 1
		_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_FABRIC] < y[P_FABRIC] })
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_FABRIC],01,LEN(AllTrim(_cMldSel))) }) 
		Else
			_nPos 			:= 1	// marca a primeira posicao
			For nCtt	:=	1	to	Len(aListBox1)
				_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_FABRIC]) }, _nPos)
				If _nPos >	0
					Aadd(_aOrcAux, aListBox1[_nPos] )
					++_nPos
				Else
					Exit
				Endif
			Next			
			_nOpc := 1
			_nPos 			:= 1	// marca a primeira posicao
		EndIf
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF
Else                 
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_POSIPI] < y[P_POSIPI] })
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_POSIPI],01,LEN(AllTrim(_cMldSel))) }) 
		Else
			_nPos 			:= 1	// marca a primeira posicao
			For nCtt	:=	1	to	Len(aListBox1)
				_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_POSIPI]) }, _nPos)
				If _nPos >	0
					Aadd(_aOrcAux, aListBox1[_nPos] )
					++_nPos
				Else
					Exit
				Endif
			Next			
			_nOpc := 1
			_nPos 			:= 1	// marca a primeira posicao
		ENDIF
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF

ENDIF

IF _nOpc == 1		
	aListBox1 := Aclone(_aOrcAux)	
	If Len(aListBox1) == 0
		//Aadd(aListBox1,{.F.,Space(80),'',0,0,0,'',''}) 
		Aadd(aListBox1,{.F.,Space(80),'',0,0,0,0,0,0,'',''})
	EndIf	
	xSetBrws()	
ENDIF

If Left(cCboBx1,1) $ 'D'
	aSort(aListBox1,,, { |x, y| x[P_DESC] < y[P_DESC] })
ElseIf Left(cCboBx1,1) $ 'C'
	aSort(aListBox1,,, { |x, y| x[P_COD] < y[P_COD] })
ElseIf Left(cCboBx1,1) $ 'F'
	aSort(aListBox1,,, { |x, y| x[P_FABRIC] < y[P_FABRIC] })
ElseIf Left(cCboBx1,1) $ 'P'
	aSort(aListBox1,,, { |x, y| x[P_POSIPI] < y[P_POSIPI] })
EndIf


_oContExpr:Refresh()

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XFILAB9 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  15/08/11     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro                                                      นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Magiccomp                                                    บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*----------------------------------*
Static Function xLimpBox(aListBox1)                                                                                            
*----------------------------------*
//IF LEN(aListBox1) > 0
//	For _nA:=1 TO LEN(aListBox1)
//		aListBox1[_nA][1] := .F.
//	Next _nA 
//ENDIF      
AEval(aListBox1,{|X| X[1]:=.F.}) 

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XFILAB9 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  15/08/11     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro                                                      นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Magiccomp                                                    บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                                
*---------------------------------*
Static Function xSB1(aListBox1)
*---------------------------------*
gCod_produto := Space(TamSX3("B1_COD")[1]) 

IF LEN(aListBox1) > 0
	
	IF (_nB := aScan(aListBox1,{|_x| _x[1] == .T. })) > 0	
	//For _nB:=1 TO LEN(aListBox1)
		IF aListBox1[_nB][P_CLICK]
            DbSelectArea('SB1')
            SUA->(DbSetORder(1))
            IF SB1->(DbSeek(xFilial('SB1')+aListBox1[_nB][P_COD]))
         	   gCod_produto := SB1->B1_COD
            ENDIF
            //Exit
		ENDIF
	//Next _nB
	ENDIF 
ENDIF
Return

// Renato Bandeira - Leitura dos dados
Static Function LeDadosPro()

//Local cCodTab:= cCodTabSA1->A1_TABELA
//Local cSitPro:= ""  
//Local nEstoque:=0
Local cCampoTab:= ''

//--HS .iNi Define qual campo ira buscar
If cCodTab == '001'
	cCampoTab:= 'Z2_PROTAB1'
ElseIf cCodTab == '002'
	cCampoTab:= 'Z2_PROTAB2'
ElseIf cCodTab == '003'
	cCampoTab:= 'Z2_PROTAB3'
ElseIf cCodTab == '004'
	cCampoTab:= 'Z2_PROTAB4'
ElseIf cCodTab == '005'
	cCampoTab:= 'Z2_PROTAB5'
ElseIf cCodTab == '006'
	cCampoTab:= 'Z2_PROTAB6'
ElseIf cCodTab == '007'
	cCampoTab:= 'Z2_PROTAB7'
ElseIf cCodTab == '008'
	cCampoTab:= 'Z2_PROTAB8'
EndIf

//--Zera array
aListBox1:={}
aListBKPr:={}

chkFile('SZ2')

//If !Empty(_cMldSel)	
	
   //	cSitPro:= GetNewPar("JP_SITPRO","000001;000008")

	_cQry := " SELECT B1_COD COD, B1_DESC xDESC, B1_GRUPO GRUPO, B1_POSIPI POSIPI, B1_ZFABRIC FABRIC, DA1_PRCVEN PRCVEN,ISNULL(SALD,0)SALD,ISNULL(ENTR,0)ENTR "+ENTER
	
	//--PrJeto Promo็๕es - Incluido coluna de desconto 
	_cQry += " ,ISNULL(PROMO1,0) PROMO1, ISNULL(PROMO2,0) PROMO2, ISNULL(PROMO3,0) PROMO3 "+ENTER
	
	_cQry += " FROM "+ RetSqlName('SB1') +" SB1  "+ENTER
	_cQry += " LEFT OUTER JOIN "+ RetSqlName('DA1') +" DA1  "+ENTER
	_cQry += 	" ON  SB1.D_E_L_E_T_ <> '*' "+ENTER
	_cQry += 	" AND DA1.D_E_L_E_T_ <> '*' "+ENTER
	_cQry += 	" AND SB1.B1_FILIAL = '"+ xFilial('SB1') +"' "+ENTER
	_cQry += 	" AND DA1.DA1_FILIAL = '"+ xFilial('DA1') +"' "+ENTER
	_cQry += 	" AND DA1.DA1_CODTAB = '"+cCodTab+"' "+ENTER
	_cQry += 	" AND DA1.DA1_CODPRO = SB1.B1_COD "+ENTER
	_cQry += 	"LEFT JOIN (SELECT B2_COD,B2_LOCAL,SUM(B2_QATU+B2_SALPEDI-B2_QPEDVEN-B2_RESERVA) SALD,SUM(B2_SALPEDI) ENTR FROM "+RetSqlName('SB2')+" WHERE "+RetSqlName('SB2')+".D_E_L_E_T_ = '' AND B2_LOCAL IN ('01') GROUP BY B2_COD,B2_LOCAL)SB21 "+ENTER 
	_cQry += 	"ON SB21.B2_COD = B1_COD "+ENTER
	
	//--Inclusao das promo็oes
	_cQry +=    "LEFT JOIN (SELECT Z2_PROTAB1 AS PROMO1, Z2_PROTAB2 AS PROMO2, Z2_PROTAB3 AS PROMO3, Z2_PRODUTO FROM "+RetSqlName('SZ2')+" WHERE D_E_L_E_T_ = '' AND Z2_TIPO = '1' AND (Z2_DTIVIGE <= '"+Dtos(DDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(DDataBase)+"') ) SZ2 "
	//_cQry +=    "AND Z2_TABELAS LIKE '%"+cCodTab+"%') SZ2 " 
	_cQry += "ON SZ2.Z2_PRODUTO = B1_COD"
	//--Fim inclusao das promo็๕es
	 
	_cQry += " WHERE SB1.B1_MSBLQL <> '1' "+ENTER
	IF !EMPTY(cCboBx1)
   		If Left(cCboBx1,1) $ 'D'
			_cQry +=   " AND UPPER(SB1.B1_DESC) LIKE '%"+UPPER(AllTrim(_cMldSel))+"%' " +ENTER
		ElseIf Left(cCboBx1,1) $ 'C'
			_cQry +=   " AND UPPER(SB1.B1_COD) LIKE '%"+UPPER(AllTrim(_cMldSel))+"%' " +ENTER
		ElseIf Left(cCboBx1,1) $ 'F'
			_cQry +=   " AND UPPER(SB1.B1_ZFABRIC) LIKE '%"+UPPER(AllTrim(_cMldSel))+"%' " +ENTER
		ElseIf Left(cCboBx1,1) $ 'P'
			_cQry +=   " AND UPPER(SB1.B1_POSIPI) LIKE '%"+UPPER(AllTrim(_cMldSel))+"%' " +ENTER 
 		EndIf
	endif
	
	_cQry +=   " AND SB1.B1_DESC<>'' AND B1_TIPO = 'ME' " +ENTER
	//_cQry +=   " AND (SB1.B1_XSITPRO=' ' OR SB1.B1_XSITPRO IN "+ FormatIn(AllTrim(cSitPro),";") + ")" +ENTER
	_cQry += " ORDER BY SB1.B1_DESC "+ENTER
	
	If Select("_PRD") > 0   	
		_PRD->(DbCloseArea())
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_PRD",.F.,.T.)
	DbSelectArea("_PRD")
	_PRD->(DbGotop()) 
	
	Do While !_PRD->(EOF()) 

		//Aadd(aListBox1,{.F.,SUBSTR(_PRD->xDESC,1,60), _PRD->COD, _PRD->PRCVEN, IIF(_PRD->SALD>=0,_PRD->SALD,0),IIF(_PRD->ENTR>=0,_PRD->ENTR,0),AllTrim(_PRD->FABRIC), _PRD->POSIPI })
		Aadd(aListBox1,{.F.,SUBSTR(_PRD->xDESC,1,60), _PRD->COD,IIF(_PRD->SALD>=0,_PRD->SALD,0),IIF(_PRD->ENTR>=0,_PRD->ENTR,0), _PRD->PRCVEN, _PRD->PROMO1, _PRD->PROMO2, _PRD->PROMO3,AllTrim(_PRD->FABRIC), _PRD->POSIPI })
		_PRD->(DbSkip())
	EndDo

//EndIf	

IF LEN(aListBox1) <= 0
	//Aadd(aListBox1,{.F.,Space(80),'',0,0,0,'',''}) 
	Aadd(aListBox1,{.F.,Space(80),'',0,0,0,0,0,0,'',''})
	Return
ENDIF

aListBKPr := aClone( aListBox1 ) 

//Endif	//If Len( aListBKPr) > 0

Return
                             
Static Function fBuscaEst(cCodProd)
Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
//Local aViewB2	:= {}
//Local aStruSB2  := {}
//Local nSaldoSB2 := 0
Local nHdl      := GetFocus()      
Local nQuantEst := 0     
Local cAliasQry   := GetNextAlias()

//ณ Verifica a filial de pesquisa do saldo 
_nRecSM0 := SM0->(Recno())
_cEmpSM0 := SM0->M0_CODIGO
DbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(DbgoTop())
While SM0->(!Eof())
	
	//Valida Empresa logada	
	IF _cEmpSM0 <> SM0->M0_CODIGO
		SM0->(DbSkip())
		Loop
	EndIf
	
	//ณ Posiciona o cadastro de produtos 
	dbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	If SB1->(MsSeek(xFilial('SB1')+cCodProd))				
		
		cQuery := " SELECT B2_FILIAL,B2_QATU,B2_QPEDVEN,B2_RESERVA, B2_SALPEDI	" 
		cQuery += " FROM "+RetSqlName("SB2")+" SB2 							"
		cQuery += " WHERE SB2.D_E_L_E_T_ <> '*' 							"
		cQuery += " AND B2_FILIAL       = '"+ AllTrim(SM0->M0_CODFIL) +"' 	"
		cQuery += " AND B2_COD          = '"+cCodProd+"' 					"
		cQuery += " AND B2_STATUS      <> '2' 								"
		 
		cQuery := ChangeQuery(cQuery)	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
				
		DbSelectArea(cAliasQry)
		Do While (cAliasQry)->(!Eof())
			nQuantEst := ((cAliasQry)->B2_QATU + (cAliasQry)->B2_QATU) - (cAliasQry)->B2_QPEDVEN - (cAliasQry)->B2_RESERVA
			(cAliasQry)->(DbSkip())
		EndDo
		(cAliasQry)->( dbCloseArea() )                        
	EndIf

	SM0->(DbSkip())
EndDo
DbSelectArea("SM0")
SM0->(DbGoTo(_nRecSM0))

RestArea(aAreaSM0)
RestArea(aAreaSB2)
RestArea(aArea)
SetFocus(nHdl)

Return(nQuantEst)
Static Function fBuscaEsf(cCodProd)
Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
//Local aAreaSM0	:= SM0->(GetArea())
//Local aViewB2	:= {}
//Local aStruSB2  := {}
//Local nSaldoSB2 := 0
Local nHdl      := GetFocus()      
Local nQuantEst := 0     
Local cAliasQry   := GetNextAlias()

		
		cQuery := " SELECT B2_FILIAL,B2_QATU,B2_QPEDVEN,B2_RESERVA, B2_SALPEDI	" 
		cQuery += " FROM "+RetSqlName("SB2")+" SB2 							"
		cQuery += " WHERE SB2.D_E_L_E_T_ <> '*' 								"
		cQuery += " AND B2_COD          = '"+cCodProd+"' 					"
		cQuery += " AND B2_STATUS      <> '2' and B2_LOCAL = '01'			"
		 
		cQuery := ChangeQuery(cQuery)	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)
				
		DbSelectArea(cAliasQry)
		Do While (cAliasQry)->(!Eof())		    
				nQuantEst := ((cAliasQry)->B2_QATU +  (cAliasQry)->B2_SALPEDI) - (cAliasQry)->B2_QPEDVEN - (cAliasQry)->B2_RESERVA            
			(cAliasQry)->(DbSkip())
		EndDo                                                                                                        
		(cAliasQry)->( dbCloseArea() )                        
	
RestArea(aAreaSB2)
RestArea(aArea)
SetFocus(nHdl)

Return(nQuantEst)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSOrdProm
Fun็ใo ordena produtos em promo็ใo
       
@author		.iNi Sistemas
@since     	04/01/18
@version  	P.12              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Altera็๕es Realizadas desde a Estrutura็ใo Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSOrdProm (aListBox1)
	//--Ordena array
	aSort(aListBox1,,, { |x, y| x[P_POSPRO1] > y[P_POSPRO1] .OR.  x[P_POSPRO2] > y[P_POSPRO2] .OR.  x[P_POSPRO3] > y[P_POSPRO3]  })

Return( Nil )
