#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)
               
#DEFINE  TB_COD   01
#DEFINE  TB_DESC  02
#DEFINE  TB_UM    03 
#DEFINE  TB_NCM   04
#DEFINE  TB_SALDO 05

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ITECX030 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  06/01/14     บฑฑ     e
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de Produto              นฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
//DESENVOLVIDO POR INOVEN

*--------------------*
User Function ITECX030
*--------------------*  
        
Private oOK   := LoadBitmap(GetResources(), "LBOK")
Private oNo   := LoadBitmap(GetResources(), "LBNO")
Private _oDlg				// Dialog Principal
                    
// Privates das ListBoxes
Private aListBox1 := {}
Private aListBK   := {}
Private oListBox1  
Private _oMldDlg
Private _oBotDlg
Private aButtons := {}
Private _cQuery  := "" 
Private _cQry    := ""
Private _cFilter := "" 
Private _cCodRet := '' 
Private _lEntrou := .F. 
//Private _cMldSel := Space(TAMSX3("AB7_NUMOS")[1]+TAMSX3("AB7_ITEM")[1])
Private _cMldSel := Space(20)
Private aCboBx1  := {'Descri็ใo','C๓digo'}
Private cCboBx1    

Private _oContExpr
Private _lContExpr := .F.

Private _aSize    := MsAdvSize()
Private _aCols    := {}
Private _aLstCols := {}
Private _aBrowse  :={} 
Private _cPerg    := 'xF3DA0_2'

SX1->( dbSetorder(1) )
If ( !SX1->( MsSeek( _cPerg ) ) )
	FCriaPerg( _cPerg )
EndIf

IF !Pergunte(_cPerg,.T.)
	Return
EndIF
Private _cTabDe   := MV_PAR01
Private _cTabAte  := MV_PAR02
Private _cProdDe  := MV_PAR03
Private _cProdAte := MV_PAR04

MontaQry(@aListBox1, @_aCols, @_aLstCols)

aadd(aButtons,{"BMPTABLE" , {|| u_xF3DA0_i(_aCols,aListBox1) },"Imprimir"})

aListBK := aClone(aListBox1) 

DEFINE MSDIALOG _oDlg TITLE "Produto x Estoque x Tabela de Pre็o" FROM 00,00 TO 563,1302 PIXEL
 	   
oListBox1 := TCBrowse():New( 35 , 02, 600, 250,,_aCols,{40,120,20,30,40},_oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
    
//xSetBrws(_aCols)                         	
xSetBrws()                         	

@ 255, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1,_aCols))

@ 255, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' Size 070,010 Of _oDlg Pixel
@ 255, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel,0,_aCols) ) Of _oDlg Pixel

@ 256, 260 CheckBox _oContExpr Var _lContExpr Prompt "Cont้m a Expressใo" Size C(060),C(008) PIXEL OF _oDlg //on Click(iIF(cCboBx1<>aCboBx1[1],_lContExpr:=.F.,_lContExpr:=_lContExpr))

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3DA0_2 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  06/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de Produto              นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*------------------------*
Static Function xSetBrws()
*------------------------*
// Seta vetor para a browse                            
oListBox1:SetArray(aListBox1) 
	
IF Len(aListBox1[Len(aListBox1)]) == 4
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 5
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 6
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 7
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 8
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 9
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08],aListBox1[oListBox1:nAt,09]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 10
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08],aListBox1[oListBox1:nAt,09],aListBox1[oListBox1:nAt,10]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 11
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08],aListBox1[oListBox1:nAt,09],aListBox1[oListBox1:nAt,10],aListBox1[oListBox1:nAt,11]}}  
ElseIF Len(aListBox1[Len(aListBox1)]) == 12
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08],aListBox1[oListBox1:nAt,09],aListBox1[oListBox1:nAt,10],aListBox1[oListBox1:nAt,11],aListBox1[oListBox1:nAt,12]}}  
Else
	oListBox1:bLine := {||{	aListBox1[oListBox1:nAt,01],aListBox1[oListBox1:nAt,02],aListBox1[oListBox1:nAt,03],aListBox1[oListBox1:nAt,04],aListBox1[oListBox1:nAt,05],aListBox1[oListBox1:nAt,06],aListBox1[oListBox1:nAt,07],aListBox1[oListBox1:nAt,08],aListBox1[oListBox1:nAt,09],aListBox1[oListBox1:nAt,10],aListBox1[oListBox1:nAt,11],aListBox1[oListBox1:nAt,12],aListBox1[oListBox1:nAt,13]}}  
EndIF

//For _nBrw:=1 To Len(_aCols) 
//	aADD(_aBrowse, aListBox1[oListBox1:nAt,_nBrw] )
//Next _nBrw 
//oListBox1:bLine := {|| _aBrowse }  

oListBox1:Refresh()
_oDlg:Refresh()     

Return                   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3DA0_2 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  06/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de Produto              นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*-------------------------------------------*
Static Function _xFilTela(cCboBx1,_cMldSel,_nOpc,_aCols)
*-------------------------------------------* 
Local _nPos := 0                         

Default _nOpc := 0

IF cCboBx1 == aCboBx1[1]
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[TB_DESC] < y[TB_DESC] })
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[TB_DESC],01,LEN(AllTrim(_cMldSel))) }) 
		Else
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[TB_DESC]) })
		ENDIF
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF
	
ElseIF cCboBx1 == aCboBx1[2]
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[TB_COD] < y[TB_COD] })
	Else
		IF !_lContExpr
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[TB_COD],01,LEN(AllTrim(_cMldSel))) })
		Else
			_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[TB_COD]) })
		ENDIF
		
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF

ENDIF

IF _nOpc == 1	
	aListBox1 := Aclone(_aOrcAux)
	//xSetBrws(_aCols)
	xSetBrws()
ENDIF

//_oContExplr:Refresh()

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ xF3DA0_2 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  06/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de Produto              นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*--------------------------------------------*
Static Function MontaQry(aListBox1, _aCols, _aLstCols)
*--------------------------------------------*
Local _cFilCase  := ''
Local _cFilInner := ''
Local _nLis

aADD(_aLstCols,'_PRD->CODIGO')
aADD(_aLstCols,'_PRD->DESCRICAO')
aADD(_aLstCols,'_PRD->UM')
aADD(_aLstCols,'_PRD->NCM')     
aADD(_aLstCols,'_PRD->SALDOSB2')

aADD(_aCols,'CำDIGO')
aADD(_aCols,'DESCRIวรO')
aADD(_aCols,'U.M.')
aADD(_aCols,'POS.IPI/NCM')
aADD(_aCols,'ESTOQUE')

_cFilTab := " SELECT DA0_CODTAB CODTAB, DA0_DESCRI DESCRI "+ENTER
_cFilTab += " FROM "+ RetSqlName('DA0') +" DA0  "+ENTER
_cFilTab += " WHERE DA0.D_E_L_E_T_ <> '*'  "+ENTER
_cFilTab += " AND DA0_FILIAL = '"+ xFilial('DA0') +"' "+ENTER
_cFilTab += " AND DA0_CODTAB BETWEEN '"+ _cTabDe +"' AND '"+ _cTabAte +"' "+ENTER
_cFilTab += " ORDER BY DA0_CODTAB "
If Select("_TAB") > 0   	
   _TAB->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cFilTab),"_TAB",.F.,.T.)

DbSelectArea("_TAB")
_TAB->(DbGotop()) 
While !_TAB->(EOF())

      _cFilCase  += " CASE WHEN SUM(DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_PRCVEN) IS NULL THEN 0 ELSE SUM(DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_PRCVEN+(DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_PRCVEN*(B1_IPI/100))) END 'TAB_"+ AllTrim(_TAB->CODTAB) +"',"+ENTER
      _cFilInner += " LEFT JOIN "+ RetSqlName('DA1') +" DA1_"+ AllTrim(_TAB->CODTAB) +" ON DA1_"+ AllTrim(_TAB->CODTAB) +".D_E_L_E_T_ <> '*' AND DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_FILIAL = '"+ xFilial('DA1') +"' AND DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_CODPRO=B1_COD AND DA1_"+ AllTrim(_TAB->CODTAB) +".DA1_CODTAB = '"+ AllTrim(_TAB->CODTAB) +"'"+ENTER
            
      aADD(_aLstCols,'_PRD->TAB_'+AllTrim(_TAB->CODTAB)) 
      aADD(_aCols,AllTrim(_TAB->CODTAB)+' - '+PadR(_TAB->DESCRI,25))

      _TAB->(DbSkip())
EndDo

IF !Empty(_cFilCase)
	_cFilCase := SubStr(_cFilCase,01,Len(_cFilCase)-3)
EndIF
               
_cQry := " SELECT	B1_COD CODIGO, B1_DESC DESCRICAO, B1_UM UM, B1_POSIPI NCM, "+ENTER
_cQry += " CASE WHEN SUM(B2_QATU - B2_RESERVA - B2_QACLASS - B2_QEMPSA - B2_QTNP - B2_QEMPN + B2_QNPT - B2_QPEDVEN) IS NULL THEN 0 ELSE SUM(B2_QATU - B2_RESERVA - B2_QACLASS - B2_QEMPSA - B2_QTNP - B2_QEMPN + B2_QNPT - B2_QPEDVEN) END SALDOSB2 "+ENTER
_cQry += iIF(!Empty(_cFilCase), ','+_cFilCase, _cFilCase)+ENTER
_cQry += "  FROM "+ RetSqlName('SB1') +" SB1 "+ENTER
If MV_PAR05 == 1
	_cQry += "INNER JOIN "+RetSqlName('SZ2')+" SZ2 ON (SZ2.D_E_L_E_T_ =  '' AND B1_COD = Z2_PRODUTO AND Z2_TIPO = '1' "+ENTER 
	_cQry += "AND Z2_DTIVIGE <= '"+Dtos(DDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(DDataBase)+"' )  "+ENTER
EndIf           	
_cQry += "    LEFT JOIN "+ RetSqlName('SB2') +" SB2 ON SB2.D_E_L_E_T_='' AND SB2.B2_FILIAL='"+ xFilial('SB2') +"' AND SB2.B2_COD=SB1.B1_COD  AND B2_LOCAL = '01' "+ENTER
_cQry += _cFilInner+ENTER
_cQry += "      WHERE SB1.D_E_L_E_T_ <> '*'  "+ENTER
_cQry += "        AND B1_FILIAL = '"+ xFilial('SB1') +"' "+ENTER
_cQry += "        AND B1_MSBLQL <> '1' "+ENTER 
_cQry += "        AND B1_COD BetWeen '"+ _cProdDe +"' AND '"+ _cProdAte +"' "+ENTER
_cQry += " GROUP BY B1_COD, B1_DESC, B1_UM, B1_POSIPI "+ENTER
_cQry += " ORDER BY B1_DESC "

If Select("_PRD") > 0   	
	_PRD->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_PRD",.F.,.T.)
DbSelectArea("_PRD")
_PRD->(DbGotop()) 

While !_PRD->(EOF())
      Aadd(aListBox1,Array(Len(_aLstCols)))

      For _nLis:=1 To Len(_aLstCols)                                 
          _xDados := &(_aLstCols[_nLis])
          IF     _nLis == TB_NCM
                 aListBox1[Len(aListBox1)][_nLis] := TransForm(_xDados,'@R 9999.99.99')
          ElseIF _nLis == TB_SALDO                                                                   
                 DbSelectArea('SB2') 
                 SB2->(DbSetOrder(1))
                 SB2->(DbSeek(xFilial("SB2") + _PRD->CODIGO + "01" ))
                 aListBox1[Len(aListBox1)][_nLis] := (SaldoSB2()-SB2->B2_QPEDVEN)
          ElseIF _nLis > TB_SALDO
                 aListBox1[Len(aListBox1)][_nLis] := TransForm(_xDados,PesqPict('DA1','DA1_PRCVEN'))
          Else
                 aListBox1[Len(aListBox1)][_nLis] := _xDados
          ENDIF
      Next _nLis

      _PRD->(DbSkip())
EndDo                                                        

IF LEN(aListBox1) <= 0
	Aadd(aListBox1,Array(Len(_aLstCols))) 
	Return
ENDIF

Return






User Function xF3DA0_I(aCols,aListBox1)
************************
Local oFwMsEx    := NIL
Local cArq       := ""
//Local cDir       := GetSrvProfString("Startpath","")
Local cWorkSheet := ""
Local cTable     := ""
Local cDirTmp    := GetTempPath()
Local xI, nI

cWorkSheet := "Tab Pre็o"
cCadastro  := "Produto x Estoque x Tabela de Pre็o"
cTable     := "Produto x Estoque x Tabela de Pre็o"
oFwMsEx    := FWMsExcel():New()

oFwMsEx:AddWorkSheet( cWorkSheet )
oFwMsEx:AddTable( cWorkSheet, cTable )

For xI := 1 To Len(_aCols)
    IF xI >= 4
       oFwMsEx:AddColumn( cWorkSheet, cTable , aCols[xI]    , 3,2)
    Else
       oFwMsEx:AddColumn( cWorkSheet, cTable , aCols[xI]    , 1,1)
    Endif
Next xI

ProcRegua(0)
For nI := 1 TO Len(aListBox1) 

    IncProc()

    If     Len(aListBox1[Len(aListBox1)]) == 4
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 5
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 6
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 7
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 8
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07], aListBox1[nI][08]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 9
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07], aListBox1[nI][08], aListBox1[nI][09]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 10
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07], aListBox1[nI][08], aListBox1[nI][09], aListBox1[nI][10]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 11
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07], aListBox1[nI][08], aListBox1[nI][09], aListBox1[nI][10], aListBox1[nI][11]})
    ElseIf Len(aListBox1[Len(aListBox1)]) == 12
           oFwMsEx:AddRow(cWorkSheet,cTable, { aListBox1[nI][01], aListBox1[nI][02], aListBox1[nI][03], aListBox1[nI][04], aListBox1[nI][05], aListBox1[nI][06], aListBox1[nI][07], aListBox1[nI][08], aListBox1[nI][09], aListBox1[nI][10], aListBox1[nI][11], aListBox1[nI][12]})
    Endif       

End

oFwMsEx:Activate()

cArq := CriaTrab( NIL, .F. ) + ".xml"

LjMsgRun( "Gerando o arquivo Produto x Estoque x Tabela de Pre็o, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )

If __CopyFile( cArq, cDirTmp + cArq )
   oExcelApp := MsExcel():New()
   oExcelApp:WorkBooks:Open( cDirTmp + cArq )
   oExcelApp:SetVisible(.T.)
Else
   MsgInfo( "Arquivo nใo copiado para o diret๓rio dos arquivos temporแrios do usuแrio." )
Endif

Return

//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FCriaPerg
Fun็ใo utilizada para criar parametros

@author		Dental Sorria [.iNi Sistemas]
@since     	17/04/18
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
Static Function FCriaPerg(cPerg)
	
	Local aRegs	 := {}
	Local xI	 := 0
	Local xJ	 := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg,10)

	AADD(aRegs,{cPerg,"01","Tab. de Pre็o De"	,"","","mv_ch1" ,"C",TamSX3("DA0_CODTAB")[1],0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
	AADD(aRegs,{cPerg,"02","Tab. de Pre็o Ate"	,"","","mv_ch2" ,"C",TamSX3("DA0_CODTAB")[1],0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})	
	AADD(aRegs,{cPerg,"03","Produto De"			,"","","mv_ch3" ,"C",TamSX3("B1_COD")[1],0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})	
	AADD(aRegs,{cPerg,"04","Produto Ate"		,"","","mv_ch4" ,"C",TamSX3("B1_COD")[1],0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})	
	AADD(aRegs,{cPerg,"05","Prod Promocao?"		,"","","mv_ch5" ,"N",1,0,0,"C","","MV_PAR05","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
	//AADD(aRegs,{cPerg,"05","Status"	 		    ,"","","mv_ch7" ,"N",1,0,0,"C","","MV_PAR01","Pendente","","","","","Encerrado","","","","","","","","","","","","","","","","","","","",""})	
	For xI := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[xI,2])
			If RecLock("SX1",.T.)
				For xJ := 1 To Len(aRegs[xI])
					FieldPut(xJ,aRegs[xI,xJ])
				Next xJ
				MsUnlock()
			EndIf
		EndIf
	Next xI

Return(Nil)
