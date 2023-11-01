#INCLUDE "RWMAKE.CH"
#Include "Protheus.Ch"
#Include "TopConn.Ch"                                           
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SCR0001  º Autor ³ Eduardo Clemente   º Data ³  14/05/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Compensação de PA´s
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function IFINB000()

Local aCores       := {}
Local aCampos      := {}

Private aRotina    := {}
Private cCadastro  := "Impressão de Boletos"
Private bFiltraBrw := { || FilBrowse( "SE1" , @aIndex , @cFiltro ) }

aCampos := { {"Prefixo"   ,"E1_PREFIXO"} ,{"No. Titulo","E1_NUM"    }   ,{"Parcela"    ,"E1_PARCELA"} ,{"Tipo"           ,"E1_TIPO"}  ,;
             {"Natureza"  ,"E1_NATUREZ"} ,{"Fornecedor","E1_CLIENTE"}   ,{"Loja"       ,"E1_LOJA"   } ,{"Nome Fornecedor","E1_NOMCLI"},;
             {"Dt Emissao","E1_EMISSAO"} ,{"Vencimento","E1_VENCTO" }   ,{"Vencto Real","E1_VENCREA"} ,{"Vlr Titulo"     ,"E1_VALOR"} ,;
             {"Dt Baixa"  ,"E1_BAIXA"  } ,{"Historico" ,"E1_HIST"   } } 
                    
Aadd(aRotina,{"Pesquisar          "	,"PesqBrw   "	,0,1 })
Aadd(aRotina,{"Visualisar         "	,"AxVisual  "	,0,1 })
Aadd(aRotina,{"Impressão Boleto        "	,"U_IMPBOL "	,0,2 }) 
//Aadd(aRotina,{"Parametros         "	,"U_BOLPARA "	,0,2 })

Aadd( aCores,{"EMPTY(E1_BAIXA) " , "BR_VERDE" 	} )

DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()

mBrowse(6,1,22,75,"SE1",aCampos,,,,,aCores)

Return(.T.)  


/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BOLPara ³ Autor ³ Eduardo Clemente        ³ Data ³ 14.05.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela de parametros do filtro                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BOLPara()

Private cPerg 	 := PadR("BOLX001",10)

ValidPerg()
If !Pergunte(cPerg,.T.)
	Return .F.
EndIf

Return()


//*************************
// Validacao da Pergunta //
//*************************
Static Function ValidPerg(cPerg)

Local _aArea := GetArea()
Local _aPerg := {}, i

Aadd(_aPerg, {cPerg, "01", "De Titulo                  ?", "MV_CH1", "C", 09, 0, "G", "MV_PAR01", ""	, ""	, ""	, ""	, ""	,""})
Aadd(_aPerg, {cPerg, "02", "Ate Titulo                 ?", "MV_CH2", "C", 09, 0, "G", "MV_PAR02", ""	, ""	, ""	, ""	, ""	,""})
Aadd(_aPerg, {cPerg, "03", "De Prefixo                 ?", "MV_CH3", "C", 03, 0, "G", "MV_PAR03", ""	, ""	, ""	, ""	, ""	,""})
Aadd(_aPerg, {cPerg, "04", "Ate Prefixo                ?", "MV_CH4", "C", 03, 0, "G", "MV_PAR04", ""	, ""	, ""	, ""	, ""	,""})
Aadd(_aPerg, {cPerg, "05", "Envia por Email            ?", "MV_CH5", "N", 01, 2, "C", "MV_PAR05", ""	, "Sim"	, "Nao"	, ""	, ""	,""})
Aadd(_aPerg, {cPerg, "06", "Msg para Email             ?", "MV_CH6", "C", 99, 0, "G", "MV_PAR06", ""	, ""	, ""	, ""	, ""	,""})

DbSelectArea("SX1")
DbSetOrder(1)
For i := 1 To Len(_aPerg)
	IF  !DbSeek(_aPerg[i,1]+_aPerg[i,2])
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIF
	Replace X1_GRUPO   with _aPerg[i,01]
	Replace X1_ORDEM   with _aPerg[i,02]
	Replace X1_PERGUNT with _aPerg[i,03]
	Replace X1_VARIAVL with _aPerg[i,04]
	Replace X1_TIPO    with _aPerg[i,05]
	Replace X1_TAMANHO with _aPerg[i,06]
	Replace X1_PRESEL  with _aPerg[i,07]
	Replace X1_GSC     with _aPerg[i,08]
	Replace X1_VAR01   with _aPerg[i,09]
	Replace X1_F3	   with _aPerg[i,10]
	Replace X1_DEF01   with _aPerg[i,11]
	Replace X1_DEF02   with _aPerg[i,12]
	Replace X1_DEF03   with _aPerg[i,13]
	Replace X1_DEF04   with _aPerg[i,14]
	Replace X1_DEF05   with _aPerg[i,15]
	MsUnlock()
Next i
RestArea(_aArea)

Return(.T.)  


/*
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³BOLPara ³ Autor ³ Eduardo Clemente        ³ Data ³ 14.05.18 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cria uma janela de parametros do filtro                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function IMPBOL()

	 Local cPerg 	:= PadR("BOLX001",10)
	 Local lMail	:= .F., lAjuste := .F.

	 Private cMarca   := GetMark()
	 Private oFontBold := TFont():New("Arial",,-14,,.T.,,,,,,,,,,)

	 ValidPerg(cPerg)
	 If !(Pergunte(cPerg,.T.))
		Return()
	 EndIf
  
	 lMail		:= iif(mv_par05 == 1, .T., .F.)
	 lAjuste	:= iif(mv_par07 == 1, .T., .F.)
	 //cTrbAlias := iif(mv_par05 == 2, 'TRB1', 'TRB0')
	 cTrbAlias := 'TRB0'

     If Select(cTrbAlias) > 0
	    (cTrbAlias)->(DbCloseArea())
     EndIf
	 /*if !lMail
		cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,E1_PORTADO,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
		cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
		cQuery += "WHERE E1_FILIAL          = '"+xFilial("SE1")+"' " + CRLF
		cQuery += "	 AND E1_PREFIXO BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CRLF
		cQuery += "     AND E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF
		cQuery += "	 AND E1_NUMBCO      <> '   ' " + CRLF 
		cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
		cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
	 else*/
	 if !lAjuste
		cQuery := "SELECT DISTINCT E1_NUM,E1_PREFIXO,E1_PORTADO" + CRLF
		cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
		cQuery += "WHERE E1_FILIAL          = '"+xFilial("SE1")+"' " + CRLF
		cQuery += "	 AND E1_PREFIXO BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CRLF
		cQuery += "     AND E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF
		cQuery += "	 AND E1_NUMBCO      <> '   ' " + CRLF 
		cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
		cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "ORDER BY E1_NUM,E1_PREFIXO"
	 //endif
     	TcQuery cQuery New Alias (cTrbAlias)

		(cTrbAlias)->(dbGoTop())
		Do While !(cTrbAlias)->(Eof())
			If (cTrbAlias)->E1_PORTADO == "001"             
			u_IFINB030((cTrbAlias)->E1_NUM,(cTrbAlias)->E1_NUM,(cTrbAlias)->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, mv_par08)
			ElseIf (cTrbAlias)->E1_PORTADO == "033"
			u_IFINB050((cTrbAlias)->E1_NUM,(cTrbAlias)->E1_NUM,(cTrbAlias)->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, mv_par08)     
			ElseIf (cTrbAlias)->E1_PORTADO == "341"
			u_IFINB010((cTrbAlias)->E1_NUM,(cTrbAlias)->E1_NUM,(cTrbAlias)->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, mv_par08)
			ElseIf (cTrbAlias)->E1_PORTADO == "237"
			u_IFINB020((cTrbAlias)->E1_NUM,(cTrbAlias)->E1_NUM,(cTrbAlias)->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, mv_par08)
			ElseIf (cTrbAlias)->E1_PORTADO == "422"
			u_IFINB040((cTrbAlias)->E1_NUM,(cTrbAlias)->E1_NUM,(cTrbAlias)->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, mv_par08)
			Endif 
			(cTrbAlias)->(dbSkip())
		Enddo
	 
	 else

		aStru := {}
		AADD(aStru,{"OK"		,"C", 02, 0 })
		AADD(aStru,{"E1_PREFIXO","C", TamSx3("E1_PREFIXO")[1], TamSx3("E1_PREFIXO")[2] })
		AADD(aStru,{"E1_NUM"	,"C", TamSx3("E1_NUM")[1], TamSx3("E1_NUM")[2] })
		AADD(aStru,{"E1_PARCELA","C", TamSx3("E1_PARCELA")[1], TamSx3("E1_PARCELA")[2] })
		AADD(aStru,{"E1_NUMBOR"	,"C", TamSx3("E1_NUMBOR")[1], TamSx3("E1_NUMBOR")[2] })
		AADD(aStru,{"E1_NUMBCO"	,"C", TamSx3("E1_NUMBCO")[1], TamSx3("E1_NUMBCO")[2] })
		AADD(aStru,{"E1_PORTADO","C", TamSx3("E1_PORTADO")[1], TamSx3("E1_PORTADO")[2] })
		AADD(aStru,{"E1_VENCREA","D", TamSx3("E1_VENCREA")[1], TamSx3("E1_VENCREA")[2] })
		AADD(aStru,{"NEWVEN"	,"D", TamSx3("E1_VENCREA")[1], TamSx3("E1_VENCREA")[2] })
		AADD(aStru,{"E1_SALDO"	,"N", TamSx3("E1_SALDO")[1], TamSx3("E1_SALDO")[2] })
		AADD(aStru,{"E1_NUMREC"	,"N", 12, 0 })

		If ( Select('TRB1') <> 0 )
			TRB1->(dbCloseArea())
		Endif
		oTMP1 := FWTemporaryTable():New( 'TRB1' )
		oTMP1:SetFields( aStru )
		oTMP1:Create()

		aCmpC01 := {}
		AADD(aCmpC01, {"OK"			, Nil, "", ""})
		AADD(aCmpC01, {"E1_PREFIXO"	, Nil, "Prefixo", ""})
		AADD(aCmpC01, {"E1_NUM"		, Nil, "Numero", ""})
		AADD(aCmpC01, {"E1_PARCELA"	, Nil, "Parcela", ""})
		AADD(aCmpC01, {"E1_VENCREA"	, Nil, "Vencto", ""})
		AADD(aCmpC01, {"NEWVEN"		, Nil, "Novo Vencto", ""})
		AADD(aCmpC01, {"E1_NUMBOR"	, Nil, "Borderô", ""})
		AADD(aCmpC01, {"E1_NUMBCO"	, Nil, "Nosso Nr.", ""})
		AADD(aCmpC01, {"E1_PORTADO"	, Nil, "Banco", ""})
		AADD(aCmpC01, {"E1_SALDO"	, Nil, "Valor", PesqPict("SE1","E1_SALDO")})

		cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,E1_PORTADO,E1_VENCREA,E1_SALDO,SE1.R_E_C_N_O_ AS REGSE1" + CRLF
		cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
		cQuery += "WHERE E1_FILIAL          = '"+xFilial("SE1")+"' " + CRLF
		cQuery += "	 AND E1_PREFIXO BETWEEN  '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + CRLF
		cQuery += "     AND E1_NUM BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' " + CRLF
		cQuery += "	 AND E1_NUMBCO      <> '   ' " + CRLF 
		cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
		cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
     	TcQuery cQuery New Alias "TRBE1"
		TCSetField("TRBE1","E1_VENCREA","D",08,0)

		lTit := .F.
		TRBE1->(dbGoTop())
		While !TRBE1->(Eof())

			TRB1->(recLock('TRB1', .T.))
			TRB1->E1_PREFIXO	:= TRBE1->E1_PREFIXO
			TRB1->E1_NUM		:= TRBE1->E1_NUM
			TRB1->E1_PARCELA	:= TRBE1->E1_PARCELA
			TRB1->E1_NUMBOR		:= TRBE1->E1_NUMBOR
			TRB1->E1_NUMBCO		:= TRBE1->E1_NUMBCO
			TRB1->E1_PORTADO	:= TRBE1->E1_PORTADO
			TRB1->E1_VENCREA	:= TRBE1->E1_VENCREA
			TRB1->E1_SALDO		:= TRBE1->E1_SALDO
			TRB1->E1_NUMREC		:= TRBE1->REGSE1
			TRB1->(msUnlock())
			lTit := .T.

			TRBE1->(dbSkip())
		Enddo

		//Mostra a tela com os titulos
		if lTit
			SetKey(VK_F4, {||goGetNDT()})

			@ 001,001 TO 400,700 DIALOG oDlg TITLE "Seleção de Titulos"
		
			TRB1->(dbGoTop())
			oBrwTit := MsSelect():New('TRB1', "OK",,aCmpC01,, @cMarca, {01, 01, 170, 350},,, oDlg)
			oBrwTit:oBrowse:bAllMark := { || goChkTit('A') }
			oBrwTit:oBrowse:bLDblClick := {|| goChkTit('U')}
		
			@ 182,30 SAY "F4 -> NOVO VENCIMENTO" SIZE 100,20 FONT oFontBold COLOR CLR_BLUE OF oDlg PIXEL

			@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
			@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
		
			ACTIVATE DIALOG oDlg CENTERED

			SetKey(VK_F4,Nil)

			if lExec
				TRB1->(dbGoTop())
				While !TRB1->(eof())
					if TRB1->(Marked("OK"))

						If TRB1->E1_PORTADO == "001"             
							u_IFINB030(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, TRB1->NEWVEN)
						ElseIf TRB1->E1_PORTADO == "033"
							u_IFINB050(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, TRB1->NEWVEN)     
						ElseIf TRB1->E1_PORTADO == "341"
							u_IFINB010(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, TRB1->NEWVEN)
						ElseIf TRB1->E1_PORTADO == "237"
							u_IFINB020(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, TRB1->NEWVEN)
						ElseIf TRB1->E1_PORTADO == "422"
							u_IFINB040(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., lMail, mv_par06, lAjuste, TRB1->NEWVEN)
						Endif 

					endif
					TRB1->(dbSkip())
				End
			endif

		Endif

	 endif
 	 MsgAlert("Programa finalizado!!!","Reimpressao de Boletos")

Return()


Static Function goChkTit(cPar)

if cPar == 'U'
	if !empty(TRB1->OK)
		TRB1->(recLock("TRB1", .F.))
		TRB1->OK := space(2)
		TRB1->(msUnlock())
	else
		if empty(TRB1->NEWVEN)
			MsgAlert("NOVA DATA DE VENCIMENTO NÃO FOI INFORMADA!!!","Reimpressao de Boletos")
			Return
		endif
		if dtos(TRB1->NEWVEN) == dtos(TRB1->E1_VENCREA)
			MsgAlert("NOVA DATA DE VENCIMENTO IGUAL AO VENCIMENTO ANTERIOR!!!","Reimpressao de Boletos")
			Return
		endif

		TRB1->(recLock("TRB1", .F.))
		TRB1->OK := cMarca
		TRB1->(msUnlock())
	
	endif
else
	TRB1->(dbGotop())
	While !TRB1->(eof())

		if !empty(TRB1->OK)
			TRB1->(recLock("TRB1", .F.))
			TRB1->OK := space(2)
			TRB1->(msUnlock())
		else
			if !empty(TRB1->NEWVEN) .and. dtos(TRB1->NEWVEN) <> dtos(TRB1->E1_VENCREA)
				TRB1->(recLock("TRB1", .F.))
				TRB1->OK := cMarca
				TRB1->(msUnlock())
			endif
		endif
	
		TRB1->(dbSkip())
	End
	TRB1->(dbGotop())
endif
oBrwTit:oBrowse:Refresh()
	
Return

//Nova data de vencimento
Static Function goGetNDT()
Local pDtMov    := TRB1->NEWVEN
Local aParam	:= {}

	IF PARAMBOX( {	{1,"Nova Dt.Vencimento", pDtMov,"@!",".T.","","",60,.T.};
				}, "Reimpressão de Boletos", @aParam,,,,,,,,.F.,.T.)

		if dtos(mv_par01) > dtos(TRB1->E1_VENCREA)
			TRB1->(recLock('TRB1', .F.))
			TRB1->NEWVEN := mv_par01
			TRB1->(msUnlock())
		else
			MsgAlert("NOVA DATA DE VENCIMENTO MENOR QUE VENCIMENTO ANTERIOR!!!","Reimpressao de Boletos")
		endif		
	Endif

Return
