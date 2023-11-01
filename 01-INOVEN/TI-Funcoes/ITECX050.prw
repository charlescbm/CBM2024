#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

#DEFINE  P_CLICK 01
#DEFINE  P_ORCAM 02
#DEFINE  P_CLIEN 03
#DEFINE  P_LOJA  04
#DEFINE  P_NOME  05
#DEFINE  P_EMIS  06
#DEFINE  P_PEDI  07

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ITECX050 º Autor ³ 	Meliora/Gustavo	 º Data ³  11/12/13     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro                                                      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                     
//DESENVOLVIDO POR INOVEN

*--------------------*
User Function ITECX050
*--------------------*  

Private oOK   := LoadBitmap(GetResources(), "LBOK")
Private oNo   := LoadBitmap(GetResources(), "LBNO")
//Private oOK   := LoadBitmap( GetResources(), "CHECKED"     )
//Private oNo   := LoadBitmap( GetResources(), "UNCHECKED"   )
// Variaveis Private da Funcao
Private _oDlg				// Dialog Principal     
                    
// Privates das ListBoxes
Private aListBox1 := {}
Private aListBK   := {}
Private oListBox1  
Private _oMldDlg
Private _oBotDlg
Private aButtons := {}
//Private _cQuery  := ""
//Private _cFilter := "" 
//Private _cCodRet := '' 
//Private _lEntrou := .F. 
//Private _cMldSel := Space(TAMSX3("AB7_NUMOS")[1]+TAMSX3("AB7_ITEM")[1])
Private _cQry    := ""
Private _cMldSel := Space(20)
Private aCboBx1  := {'Orçamento','Código Cliente','Nome Cliente'}
Private cCboBx1
Private lAltOrc := .F.
Private  cTPVEN:= ''

lAltOrc := Alltrim(UsrRetName( RetCodUsr() )) $ GetMv("LI_ALTORC",.F.,"ana.fernandes;orlando.ramalho;Administrador;admin")

SA3->(dbSetOrder(7))
If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
   cTPVEN:= SA3->A3_TIPO
EndIf



//aadd(aButtons,{"BMPTABLE" , {|| XFLTAB6F3(aListBox1) },"Filtro"})

_cQry := "  SELECT UA_NUM NUM, UA_CLIENTE CLIENTE, UA_LOJA LOJA, A1_NOME NOME, UA_EMISSAO EMISSAO, UA_NUMSC5 PEDIDO "+ENTER 
_cQry += "   FROM "+ RetSqlName('SUA') +" SUA  "+ENTER
_cQry += "   LEFT JOIN "+ RetSqlName('SA1') +" SA1 ON SA1.D_E_L_E_T_ <> '*' AND A1_FILIAL = '"+ xFilial('SA1') +"' AND A1_COD = UA_CLIENTE AND A1_LOJA = UA_LOJA "
_cQry += "    WHERE SUA.D_E_L_E_T_ <> '*' "+ENTER
_cQry += "      AND UA_FILIAL  = '"+ xFilial('SUA') +"' "+ENTER
// Renato Bandeira em 28/10/14 - Permitir editar orçamento que ja virou PV
//_cQry += "      AND UA_NUMSC5  = ' ' "+ENTER       
If !(__cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000' .or. lAltOrc .OR.  cTPVEN <> "E"  )
	_cQry += "      AND UA_OPERADO = '"+ TKOPERADOR() +"' "+ENTER
EndIf
_cQry += "  ORDER BY UA_NUM "

If Select("_ORC") > 0   	
	_ORC->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_ORC",.F.,.T.)
DbSelectArea("_ORC")
_ORC->(DbGotop()) 

Do While !_ORC->(EOF())
		Aadd(aListBox1,{.F.,_ORC->NUM, _ORC->CLIENTE, _ORC->LOJA, _ORC->NOME, DtoC(StoD(_ORC->EMISSAO)), _ORC->PEDIDO })
	_ORC->(DbSkip())
EndDo

IF LEN(aListBox1) <= 0
	Aadd(aListBox1,{.F.,'','','','','',''}) 
	Alert('Não foi localizado Orçamento. Operador[ '+ TKOPERADOR() +' ]')
	Return
ENDIF

aListBK := aClone( aListBox1 ) 

DEFINE MSDIALOG _oDlg TITLE "Orçamentos Disponiveis - [ "+ AllTrim(TKOPERADOR()) +" ]" FROM C(068),C(181) TO C(406),C(885) PIXEL
   
    oListBox1 := TCBrowse():New( 32 , 02, 449, 160,,;
                              {'','Orçamento','Cliente','Loja','Nome','Emissão','Pedido'},;
                              {40,40,40,30,100,30,10},;
                              _oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
	xSetBrws()                         	

@ 200, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1))
//_cMldSel := iIF( cCboBx1==cCboBx1[1], Space(TAMSX3("AB7_NUMOS")[1]+TAMSX3("AB7_ITEM")[1]), Space(20)) 
@ 200, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' Size 070,010 Of _oDlg Pixel
@ 200, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel) ) Of _oDlg Pixel

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1, ABAxTEC(aListBox1) ,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ XFILAB9 º Autor ³ 	Meliora/Gustavo	 º Data ³  15/08/11     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro                                                      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Magiccomp                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-----------------------*
Static Function xSetBrws
*-----------------------*
// Seta vetor para a browse                            
oListBox1:SetArray(aListBox1) 
	
IF LEN(aListBox1) == 1
	aListBox1[1,1] := .T.		
ENDIF
	
// Monta a linha a ser exibina no Browse
oListBox1:bLine := {||{	If( aListBox1[oListBox1:nAt,P_CLICK] ,oOK,oNo),;
	   						aListBox1[oListBox1:nAt,P_ORCAM],;
                            aListBox1[oListBox1:nAt,P_CLIEN],;
                            aListBox1[oListBox1:nAt,P_LOJA],;
                            aListBox1[oListBox1:nAt,P_NOME],;
                            aListBox1[oListBox1:nAt,P_EMIS],;
                            aListBox1[oListBox1:nAt,P_PEDI] }}  

// Evento de duplo click na celula
/*/
oListBox1:bLDblClick   := {|| xLimpBox(aListBox1),;
                              aListBox1[oListBox1:nAt,P_CLICK]:=.T. ,;
                              oListBox1:Refresh() }                
/*/
oListBox1:bLDblClick   := {|| xLimpBox(aListBox1),;
                              aListBox1[oListBox1:nAt,P_CLICK]:=.T. ,;
                              oListBox1:Refresh(), nOpcA:=1, ABAxTEC(aListBox1) ,_oDlg:End() }                


oListBox1:Refresh()
_oDlg:Refresh()
                              
Return                   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ XFILAB9 º Autor ³ 	Meliora/Gustavo	 º Data ³  15/08/11     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro                                                      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Magiccomp                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*-------------------------------------------*
Static Function _xFilTela(cCboBx1,_cMldSel,_nOpc)
*-------------------------------------------* 
Local _nPos := 0                         

Default _nOpc := 0

IF cCboBx1 == aCboBx1[1]
	IF _nOpc == 1
	 	_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_ORCAM] < y[P_ORCAM] })
	Else
		_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[2],01,LEN(AllTrim(_cMldSel))) })
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF
ELSEIF cCboBx1 == aCboBx1[2] 
	IF _nOpc == 1
		_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_CLIEN]+x[P_LOJA]+x[P_ORCAM] < y[P_CLIEN]+y[P_LOJA]+y[P_ORCAM] })
	Else
		_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $  SubStr((_x[3]+_x[4]),01,LEN(AllTrim(_cMldSel))) })
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1)                       
	ENDIF
Else
	IF _nOpc == 1
		_aOrcAux := aSort(aListBox1,,, { |x, y| x[P_NOME]+x[P_ORCAM] < y[P_NOME]+y[P_ORCAM] })
	Else
		_nPos 			:= aScan(aListBox1,{|_x| AllTrim(_cMldSel) $ SubStr(_x[5],01,LEN(AllTrim(_cMldSel))) })
		oListBox1:nAt 	:= If(_nPos>0,_nPos,1) 	
	ENDIF
ENDIF

IF _nOpc == 1	
	aListBox1 := Aclone(_aOrcAux)
	xSetBrws()
ENDIF

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ XFILAB9 º Autor ³ 	Meliora/Gustavo	 º Data ³  15/08/11     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro                                                      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Magiccomp                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
*----------------------------------*
Static Function xLimpBox(aListBox1)                                                                                            
*----------------------------------*
	Local _nA:= 0
	If Len(aListBox1) > 0
		For _nA:=1 TO LEN(aListBox1)
			aListBox1[_nA][1] := .F.
		Next _nA 
	EndIf
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ XFILAB9 º Autor ³ 	Meliora/Gustavo	 º Data ³  15/08/11     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro                                                      ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Magiccomp                                                    º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                                
*---------------------------------*
Static Function ABAxTEC(aListBox1)
*---------------------------------*
	Local _nB:= 0 
	cum_orc := Space(TamSX3("UA_NUM")[1])
	If Len(aListBox1) > 0
		For _nB:=1 TO LEN(aListBox1)
			If aListBox1[_nB][P_CLICK]
	            DbSelectArea('SUA')
	            SUA->(DbSetORder(1))
	            If SUA->(DbSeek(xFilial('SUA')+aListBox1[_nB][P_ORCAM]))
	         	   cum_orc := SUA->UA_NUM		                            
	            EndIf
	            Exit
			EndIf
		Next _nB 
	EndIf
Return()