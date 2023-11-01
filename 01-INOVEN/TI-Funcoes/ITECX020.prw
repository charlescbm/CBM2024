#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)

#DEFINE  P_CLICK  01
#DEFINE  P_DESC   02
#DEFINE  P_COD    03
#DEFINE  P_LOJA   04
#DEFINE  P_CGC    05
#DEFINE  P_NOME   06 
#DEFINE  P_MUN    07
#DEFINE  P_END    08
#DEFINE  P_UF    09
#DEFINE  P_CEP    10

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ ITECX020 º Autor ³ 	Meliora/Gustavo	 º Data ³  08/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro - Consulta Padrao - Cadastro de cliente...           ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                     
//DESENVOLVIDO POR INOVEN

*-------------------*
User Function ITECX020
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
Private aCboBx1  := iif(!IsInCallStack("U_IVENA020"),{'Razão Social','Código','Cnpj','Nome Fantasia','Municipio','Endereço','UF','CEP'},{'Cnpj','Razão Social'})
Private cCboBx1  := iif(!IsInCallStack("U_IVENA020"),'Razão Social','Cnpj')

Private _oContExpr
Private _lContExpr := .F.

Private cUsrTop	   := SuperGetMV("TG_USERTOP",.F.,"")

//aadd(aButtons,{"BMPTABLE" , {|| XFLTAB6F3(aListBox1) },"Filtro"})

lFiltra := iif(!(alltrim(__cUserID) $ (cUsrTop)), .T., .F.)

//DbSelectArea('SA3')
//SA3->(dbSetOrder(7))
//lVendUsu := SA3->(dbSeek(xFilial("SA3")+__cUserID))
//--.iNi Verifica se vendedor é um representante
//If lVendUsu
//	lVendRep := IIF(SA3->A3_TIPO == 'E',.T.,.F.)
//EndIf

cCodA3 := ''
if lFiltra
   If (Select("QRYA3") <> 0)
      QRYA3->(dbCloseArea())
   Endif
   BEGINSQL ALIAS "QRYA3"
      SELECT A3_COD 
      FROM %table:SA3% A3 
      WHERE A3.A3_FILIAL = %xfilial:SA3%
      AND   (A3.A3_CODUSR = %exp:__cUserID% OR A3.A3_USRAUX = %exp:__cUserID% OR A3.A3_GEREN = %exp:__cUserID% OR A3.A3_SUPER = %exp:__cUserID%)
      AND   A3.%notdel%
   ENDSQL
   cCodA3 := QRYA3->A3_COD
endif

_cQry := " SELECT A1_COD COD, A1_LOJA LOJA, A1_NOME NOME, A1_PESSOA PESSOA,A1_CGC CGC, A1_NREDUZ XNFANTA, A1_MUN MUN,A1_EST UF,A1_CEP CEP ,A1_END ENDER"+ENTER
_cQry += "   FROM "+ RetSqlName('SA1') +" SA1  "+ENTER
_cQry += "     WHERE SA1.D_E_L_E_T_ <> '*' "+ENTER
_cQry += "       AND A1_FILIAL = '"+ xFilial('SA1') +"' "+ENTER
_cQry += "       AND A1_MSBLQL <> '1' "+ENTER
/*//Renato Bandeira em 29/10/14 - tratamento para segundo vendedor
If lVendUSU
	//--.iNi Caso seja um representante, irá mostrar somente a carteira dele e o clientes inativos
	//_cQry += " AND ( A1_VEND = '"+SA3->A3_COD+"' OR A1_VEND IN ('1000','2000') ) "
	If lVendRep 
		_cQry += " AND ( A1_VEND = '"+SA3->A3_COD+"' ) " 
	EndIf		
Endif*/
if lFiltra
   _cQry += " AND ( A1_VEND = '"+cCodA3+"' ) " 
endif
_cQry += " ORDER BY " + iif(!IsInCallStack("U_IVENA020"), "A1_NOME ", "A1_CGC ")
                                                     
If Select("_TRP") > 0
	_TRP->(DbCloseArea())
EndIf


DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TRP",.F.,.T.)

DbSelectArea("_TRP")
_TRP->(DbGotop()) 

While !_TRP->(EOF())
      Aadd(aListBox1,{.F., _TRP->NOME, _TRP->COD, _TRP->LOJA, TransForm(_TRP->CGC,iIF(_TRP->PESSOA=='F',"@R 999.999.999-99","@R 99.999.999/9999-99")), _TRP->XNFANTA, _TRP->MUN, _TRP->ENDER,_TRP->UF,TransForm(_TRP->CEP,"@R 99999-999" )})
      _TRP->(DbSkip())
EndDo

IF LEN(aListBox1) <= 0
   Aadd(aListBox1,{.F.,'','','','','','','',''}) 	
ENDIF

aListBK := aClone( aListBox1 ) 
                                   
DEFINE MSDIALOG _oDlg TITLE "Cadastro de Cliente [Ativo]" FROM C(198),C(181) TO C(466),C(885) PIXEL
                              
//oListBox1 := TCBrowse():New( 02 , 02, 449, 140,,;  //p11
oListBox1 := TCBrowse():New( 32 , 02, 449, 110,,;   //p12
                              {'','Razão Social','Código','Loja','Cnpj','Nome Fantasia','Municipio','Endereco','UF',"CEP"},;
                              {40,130,40,30,40,100,40,130,30,50},;
                              _oDlg,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )
xSetBrws()                         	

@ 147, 002 ComboBox cCboBx1 Items aCboBx1 Size 086, 010 Of _oDlg Pixel On Change(_xFilTela(cCboBx1,_cMldSel,1))
@ 147, 088 MsGet _oMldDlg  var _cMldSel Picture '@!' valid goCheckdig(_cMldSel,cCboBx1) Size 070,010 Of _oDlg Pixel
@ 147, 160 Button _oBotDlg  Prompt 'Filtrar' Size 020,010 Action( _xFilTela(cCboBx1,_cMldSel) ) Of _oDlg Pixel
	
@ 147, 260 CheckBox _oContExpr Var _lContExpr Prompt "Contém a Expressão" Size C(060),C(008) PIXEL OF _oDlg

ACTIVATE MSDIALOG _oDlg CENTERED ON INIT EnchoiceBar(_oDlg,{||(( nOpcA:=1, xSA1(aListBox1) ,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 

Return(.T.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xF3SB1 º Autor ³ 	Meliora/Gustavo	 º Data ³  08/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro - Consulta Padrao - Cadastro de PRODUTO...           ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                  º±±
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
oListBox1:bLine := {||{	If( aListBox1[oListBox1:nAt,P_CLICK] ,oOK,oNO)	,;
	   						aListBox1[oListBox1:nAt,P_DESC]				,;
                            aListBox1[oListBox1:nAt,P_COD]				,;
                            aListBox1[oListBox1:nAt,P_LOJA]				,;
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
±±ºPrograma  ³ xF3SB1 º Autor ³ 	Meliora/Gustavo	 º Data ³  08/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro - Consulta Padrao - Cadastro de PRODUTO...           ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                      
*-------------------------------------------*
Static Function _xFilTela(cCboBx1,_cMldSel,_nOpc)
*-------------------------------------------* 
Local _nPos := 0                         

Default _nOpc := 0

if !IsInCallStack("U_IVENA020")
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
else
   IF cCboBx1 == aCboBx1[1]
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
   elseIF cCboBx1 == aCboBx1[2]
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
   endif
endif

IF _nOpc == 1	
   aListBox1 := Aclone(_aOrcAux)
   xSetBrws()
ENDIF

_oContExpr:Refresh()

Return    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xF3SB1 º Autor ³ 	Meliora/Gustavo	 º Data ³  08/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro - Consulta Padrao - Cadastro de PRODUTO...           ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                     
*----------------------------------*
Static Function xLimpBox(aListBox1)                                                                                            
*----------------------------------*
AEval(aListBox1,{|X| X[1]:=.F.}) 

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xF3SB1 º Autor ³ 	Meliora/Gustavo	 º Data ³  08/01/14     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³  Filtro - Consulta Padrao - Cadastro de PRODUTO...           ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/                     
*---------------------------------*
Static Function xSA1(aListBox1)
*---------------------------------*
//cod_cli := Space(TamSX3("A1_COD")[1]) 
//coja_cli := Space(TamSX3("A1_LOJA")[1]) 
cod_cnpj := Space(TamSX3("A1_CGC")[1]) 

if IsInCallStack("U_IVENA020") .and. cCboBx1 == aCboBx1[2]
   MSGALERT("ATENÇÃO!!! É IMPORTANTE CONFIRMAR O CNPJ/CPF!")
endif

IF LEN(aListBox1) > 0	
	IF (_nB := aScan(aListBox1,{|_x| _x[1] == .T. })) > 0	
	//For _nB:=1 TO LEN(aListBox1)
		IF aListBox1[_nB][P_CLICK]
            DbSelectArea('SA1')
            SA1->(DbSetORder(1))
            IF SA1->(DbSeek(xFilial('SA1')+aListBox1[_nB][P_COD]+aListBox1[_nB][P_LOJA]))
         	   //cod_cli := SA1->A1_COD
         	   //coja_cli := SA1->A1_LOJA
         	   cod_cnpj := SA1->A1_CGC
            ENDIF
		ENDIF
	//Next _nB
	ENDIF 
ENDIF
Return

//validar o CNPJ/CPF digitado
Static Function goCheckdig(_cMldSel,cCboBx1)
Local lRet := .T.

if IsInCallStack("U_IVENA020") .and. cCboBx1 == aCboBx1[1]
   if len(alltrim(_cMldSel)) < 11
      MSGALERT("Atenção!!! Digite todo o conteúdo do campo para pesquisa!")
      lRet := .F.
   elseif len(alltrim(_cMldSel)) > 11 .and. len(alltrim(_cMldSel)) < 14
      MSGALERT("Atenção!!! Digite todo o conteúdo do campo para pesquisa!")
      lRet := .F.
   endif
endif

Return( lRet )
