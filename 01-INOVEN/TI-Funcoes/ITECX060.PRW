#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

#DEFINE  P_CLICK  01
#DEFINE  P_DESC   02
#DEFINE  P_COD    03
#DEFINE  P_COND    04

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ITECX060 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de cliente...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
//DESENVOLVIDO POR INOVEN

*-------------------*
User Function ITECX060
*-------------------*  
Local _cQry    := ""
Private oOK   := LoadBitmap(GetResources(), "LBOK")
Private oNo   := LoadBitmap(GetResources(), "LBNO")
// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal.
                    
// Privates das ListBoxes
Private aListBox1 := {}
Private aListBK   := {}
Private oListBox1  
Private _oMldDlg
Private _oBotDlg
Private aButtons := {}
Private _cQuery  := "" 
//Private _cQry    := ""
Private _cFilter := "" 
Private _cCodRet := '' 
Private _lEntrou := .F. 
//Private _cMldSel := Space(TAMSX3("AB7_NUMOS")[1]+TAMSX3("AB7_ITEM")[1])
Private _cMldSel := Space(20)
Private aCboBx1  := {'Razใo Social','C๓digo','Cnpj','Nome Fantasia','Municipio','Endere็o','UF','CEP'}
Private cCboBx1  := 'Razใo Social'  

Private _oContExpr
Private _lContExpr := .F.

If Trim(FunName()) == 'MATA410'
	Private cCTpOper := '51'
Endif

//aadd(aButtons,{"BMPTABLE" , {|| XFLTAB6F3(aListBox1) },"Filtro"})

If cCTpOper == '51'
	_cQry := " SELECT * "+ENTER
	_cQry += "   FROM "+ RetSqlName('SE4') +" SE4  "+ENTER
	_cQry += "     WHERE SE4.D_E_L_E_T_ <> '*' AND E4_MSBLQL <> '1' AND E4_TPOPER IN ( '', '1', '4') "+ENTER
	_cQry += "       AND E4_FILIAL = '"+ xFilial('SE4') +"' "+ENTER
	_cQry += " ORDER BY E4_DESCRI "
Elseif cCTpOper == '87'
	_cQry := " SELECT * "+ENTER
	_cQry += "   FROM "+ RetSqlName('SE4') +" SE4  "+ENTER
	_cQry += "     WHERE SE4.D_E_L_E_T_ <> '*' AND E4_MSBLQL <> '1' AND E4_TPOPER IN ('3') "+ENTER
	_cQry += "       AND E4_FILIAL = '"+ xFilial('SE4') +"' "+ENTER
	_cQry += " ORDER BY E4_DESCRI "
Else
	_cQry := " SELECT * "+ENTER
	_cQry += "   FROM "+ RetSqlName('SE4') +" SE4  "+ENTER
	_cQry += "     WHERE SE4.D_E_L_E_T_ <> '*' AND E4_MSBLQL <> '1' AND E4_TPOPER IN ( '', '1', '4','03') "+ENTER
	_cQry += "       AND E4_FILIAL = '"+ xFilial('SE4') +"' "+ENTER
	_cQry += " ORDER BY E4_DESCRI "
Endif
                                                     
If Select("_TRCD") > 0
	_TRCD->(DbCloseArea())
EndIf


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TRCD",.F.,.T.)

DbSelectArea("_TRCD")
_TRCD->(DbGotop()) 

// ORDENAR COLUNAS
While !_TRCD->(EOF())
      Aadd(aListBox1,{.F., _TRCD->E4_DESCRI, _TRCD->E4_CODIGO,_TRCD->E4_COND})
      _TRCD->(DbSkip())
EndDo

IF LEN(aListBox1) <= 0
   Aadd(aListBox1,{.F.,'','','',''}) 	
ENDIF

aListBK := aClone( aListBox1 ) 
                                   
DEFINE MSDIALOG _oDlg TITLE "Cadastro de Cond.Pagamento [Vendas]" FROM C(198),C(181) TO C(466),C(885) PIXEL
                              
//oListBox1 := TCBrowse():New( 02 , 02, 449, 140,,;  //p11
oListBox1 := TCBrowse():New( 32 , 02, 449, 110,,;   //p12
                              {'','Descri็ao','C๓digo','Condicao'},;
                              {40,130,40,40},;
                              _oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
xSetBrws()                         	

@ 147, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1))
@ 147, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' Size 070,010 Of _oDlg Pixel
@ 147, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel) ) Of _oDlg Pixel
	
@ 147, 260 CheckBox _oContExpr Var _lContExpr Prompt "Cont้m a Expressใo" Size C(060),C(008) PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1, xSE4(aListBox1) ,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3SB1 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de PRODUTO...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
*-----------------------*
Static Function xSetBrws
*-----------------------*
// Seta vetor para a browse                            
oListBox1:SetArray(aListBox1) 
	
IF LEN(aListBox1) == 1
	aListBox1[1,1] := .T.		
ENDIF

// Monta a linha a ser exibina no Browse
oListBox1:bLine := {||{	If( aListBox1[oListBox1:nAt,P_CLICK] ,oOK,oNO)	,;
	   						aListBox1[oListBox1:nAt,P_DESC]				,;
                            aListBox1[oListBox1:nAt,P_COD]				,;
                            aListBox1[oListBox1:nAt,P_COND]			    }}  

// Evento de duplo click na celula
oListBox1:bLDblClick   := {|| xLimpBox(aListBox1),;
                              aListBox1[oListBox1:nAt,P_CLICK]:=.T. ,;
                              oListBox1:Refresh() }                


oListBox1:Refresh()
_oDlg:Refresh()

Return                   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3SB1 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de PRODUTO...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                      
*-------------------------------------------*
Static Function _xFilTela(cCboBx1,_cMldSel,_nOpc)
*-------------------------------------------* 
Local _nPos := 0                         

Default _nOpc := 0

IF     cCboBx1 == aCboBx1[1]
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_DESC] < y[P_DESC] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_DESC],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_DESC]) })
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
             _nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_COD]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF	
ENDIF

IF _nOpc == 1	
   aListBox1 := Aclone(_aOrcAux)
   xSetBrws()
ENDIF

_oContExpr:Refresh()

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3SB1 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de PRODUTO...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                 บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
*----------------------------------*
Static Function xLimpBox(aListBox1)                                                                                            
*----------------------------------*
AEval(aListBox1,{|X| X[1]:=.F.}) 

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3SB1 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de PRODUTO...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
*---------------------------------*
Static Function xSE4(aListBox1)
*---------------------------------*
cod_cli := SPACE(3)
IF LEN(aListBox1) > 0	
	IF (_nB := aScan(aListBox1,{|_x| _x[1] == .T. })) > 0	
	//For _nB:=1 TO LEN(aListBox1)
		IF aListBox1[_nB][P_CLICK]
            DbSelectArea('SE4')
            SE4->(DbSetORder(1))
            IF SE4->(DbSeek(xFilial('SE4')+aListBox1[_nB][P_COD]))
         	   cod_cli := SE4->E4_CODIGO
            ENDIF
		ENDIF
	//Next _nB
	ENDIF 
ENDIF
Return