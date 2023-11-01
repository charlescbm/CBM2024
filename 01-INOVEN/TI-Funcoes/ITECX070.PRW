#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

#DEFINE  P_CLICK  01
#DEFINE  P_DESC   02
#DEFINE  P_COD    03
#DEFINE  P_CGC    04
#DEFINE  P_NOME   05 
#DEFINE  P_MUN    06
#DEFINE  P_END    07
#DEFINE  P_UF     08
#DEFINE  P_CEP    09

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ ITECX070 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  08/01/14     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ  Filtro - Consulta Padrao - Cadastro de cliente...           นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                     
//DESENVOLVIDO POR INOVEN

*-------------------*
User Function ITECX070
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

//aadd(aButtons,{"BMPTABLE" , {|| XFLTAB6F3(aListBox1) },"Filtro"})


_cQry := " SELECT A4_COD COD, A4_NOME NOME, A4_CGC CGC, A4_NREDUZ XNFANTA, A4_MUN MUN,A4_EST UF,A4_CEP CEP ,A4_END ENDER"+ENTER
_cQry += "   FROM "+ RetSqlName('SA4') +" SA4  "+ENTER
_cQry += "     WHERE SA4.D_E_L_E_T_ <> '*' AND A4_XMATRIZ = '1' and A4_MSBLQL <> '1' "+ENTER
_cQry += "       AND A4_FILIAL = '"+ xFilial('SA4') +"' "+ENTER
_cQry += " ORDER BY A4_NOME "
                                                     
If Select("_TRP") > 0
	_TRP->(DbCloseArea())
EndIf


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TRP",.F.,.T.)

DbSelectArea("_TRP")
_TRP->(DbGotop()) 

While !_TRP->(EOF())
      Aadd(aListBox1,{.F., _TRP->NOME, _TRP->COD,TransForm(_TRP->CGC,"@R 99.999.999/9999-99"), _TRP->XNFANTA, _TRP->MUN, _TRP->ENDER,_TRP->UF,TransForm(_TRP->CEP,"@R 99999-999" )})
      _TRP->(DbSkip())
EndDo

IF LEN(aListBox1) <= 0
   Aadd(aListBox1,{.F.,'','','','','','','',''}) 	
ENDIF

aListBK := aClone( aListBox1 ) 
                                   
DEFINE MSDIALOG _oDlg TITLE "Cadastro de Transportador [Ativo]" FROM C(198),C(181) TO C(466),C(885) PIXEL
                              
//oListBox1 := TCBrowse():New( 02 , 02, 449, 140,,;  //p11
oListBox1 := TCBrowse():New( 32 , 02, 449, 110,,;   //p12
                              {'','Razใo Social','C๓digo','Cnpj','Nome Fantasia','Municipio','Endereco','UF',"CEP"},;
                              {40,130,40,30,40,100,40,130,30,50},;
                              _oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
xSetBrws()                         	

@ 147, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1))
@ 147, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' Size 070,010 Of _oDlg Pixel
@ 147, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel) ) Of _oDlg Pixel
	
@ 147, 260 CheckBox _oContExpr Var _lContExpr Prompt "Cont้m a Expressใo" Size C(060),C(008) PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1, xSA4(aListBox1) ,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

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
                            aListBox1[oListBox1:nAt,P_CGC]				,;
                            aListBox1[oListBox1:nAt,P_NOME]				,;
							aListBox1[oListBox1:nAt,P_MUN]				,;
							aListBox1[oListBox1:nAt,P_END]				,;
							aListBox1[oListBox1:nAt,P_UF]				,;
							aListBox1[oListBox1:nAt,P_CEP]			    }}  

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
ElseIF cCboBx1 == aCboBx1[3]
       IF     Len(Alltrim(_cMldSel)) <= 2
              _cMldSel := Transform(Alltrim(_cMldSel),"@R 99")
       ElseIF Len(Alltrim(_cMldSel)) <= 5
              _cMldSel := Transform(Alltrim(_cMldSel),"@R 99.999")
       ElseIF Len(Alltrim(_cMldSel)) <= 8
              _cMldSel := Transform(Alltrim(_cMldSel),"@R 99.999.999")
       ElseIF Len(Alltrim(_cMldSel)) <= 12
              _cMldSel := Transform(Alltrim(_cMldSel),"@R 99.999.999/9999")
       ElseIF Len(Alltrim(_cMldSel)) <= 14
              _cMldSel := Transform(Alltrim(_cMldSel),"@R 99.999.999/9999-99")
       Endif
       _oMldDlg:Refresh()
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_CGC] < y[P_CGC] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_CGC],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_CGC]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF
ElseIF cCboBx1 == aCboBx1[4]
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_NOME] < y[P_NOME] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_NOME],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_NOME]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF
Elseif cCboBx1 == aCboBx1[5]	
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_MUN] < y[P_MUN] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_MUN],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_MUN]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF	
Elseif cCboBx1 == aCboBx1[6]	
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_END] < y[P_END] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_END],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_END]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF
Elseif cCboBx1 == aCboBx1[7]	
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_UF] < y[P_UF] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_UF],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_UF]) })
          ENDIF
          oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
       ENDIF 
Elseif cCboBx1 == aCboBx1[8]	
       IF _nOpc == 1
          _aOrcAux := aSort(aListBox1,,, { |x, y| x[P_CEP] < y[P_CEP] })
       Else
          IF !_lContExpr
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[P_CEP],01,LEN(AllTrim(_cMldSel))) }) 
          Else
             _nPos := aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ AllTrim(_x[P_CEP]) })
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
Static Function xSA4(aListBox1)
*---------------------------------*
cod_cli := Space(TamSX3("A4_COD")[1]) 

IF LEN(aListBox1) > 0	
	IF (_nB := aScan(aListBox1,{|_x| _x[1] == .T. })) > 0	
	//For _nB:=1 TO LEN(aListBox1)
		IF aListBox1[_nB][P_CLICK]
            DbSelectArea('SA4')
            SA1->(DbSetORder(1))
            IF SA4->(DbSeek(xFilial('SA4')+aListBox1[_nB][P_COD]))
         	   cod_cli := SA4->A4_COD
            ENDIF
		ENDIF
	//Next _nB
	ENDIF 
ENDIF
Return