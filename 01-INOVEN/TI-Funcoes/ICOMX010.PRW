#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 	!
+-------------------------------------------------------------------------------+
!Programa          	! ICOMX010													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para pagamento de boleto com linha digitavel 		!
!					! e codigo de barras										!
+-------------------+-----------------------------------------------------------+
!Autor         		! actvs		 												!
+-------------------+-----------------------------------------------------------+
!Data de Criacao  	! 08/19/08								                	!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function ICOMX010()

	// RCO (31/08/10) - data anterior a qual não obrigará que a forma pgto seja Boleto/Convenio
	//Local cDtCorte	:= "01/07/19"
	Private	cCodBar
	Private aItems		:= {"MANUAL","LEITORA"}
	Private cNumero  := Space(44)	// 47
	Private cNumAux  := Space(48)	// 47
	Private cCodMan := Space(44)	// 47
	Private oCodMan := Nil
	Private cCodDig := Space(48)	// 47
	Private oCodDig := Nil

	// RCO (31/08/10)
	// Somente permite a leitura se o campo FormaPgto for boleto ou convênio
/*	IF !SE2->E2_FORPAG$"BO|CO"
		IF SE2->E2_EMISSAO>=CTOD(cDtCorte)
			APMSGALERT("A customização para realizar a leitura do código de barras/digitação da linha digitável somente está liberada para títulos definidos com [Forma Pagamento] igual a 'boleto' ou 'convênio'.","TITULO INVÁLIDO-"+ALLTRIM(ProcName())+"-ICOMX010-"+SE2->E2_FORPAG)
			Return .F.
		ENDIF
*/
	IF SE2->E2_SALDO==0
		APMSGALERT("A customização para realizar a leitura do código de barras/digitação da linha digitável somente está liberada para títulos com saldo.","TITULO INVÁLIDO-"+ALLTRIM(ProcName())+"-ICOMX010")
		Return .F.
	ENDIF

	If !empty(SE2->E2_CODBAR)
	    If SE2->E2_TPBAR == "L"
	       cCodBar  := "LEITORA"
	    ElseIf SE2->E2_TPBAR == "M"
	       cCodBar  := "MANUAL"
	    End
	ElseIf empty(SE2->E2_CODBAR)
	   cCodBar := "LEITORA"
	EndIf

	@ 96,042 TO 323,635 DIALOG oDlg4 TITLE "Atualiza Contas a Pagar"
	@ 08,010 TO 84,290

	@ 15,020 SAY "TITULO: "
	@ 15,070 SAY ALLTRIM(SE2->E2_TIPO)+" "+SE2->E2_PREFIXO+"/"+SE2->E2_NUM+"-"+SE2->E2_PARCELA+", fornecedor: "+ALLTRIM(SE2->E2_NOMFOR)+", valor: R$"+ALLTRIM(TRANSFORM(SE2->E2_VALOR,"@E 999,999,999,999.99"))+", vcto: "+DTOC(SE2->E2_VENCTO) COLOR CLR_HBLUE

	@ 30,020 SAY "TIPO DE DADO:"
	@ 30,070 COMBOBOX cCodBar ITEMS aItems SIZE 50,50 object oCodBar
	oCodBar:Bchange := {||A833Muda()}

	@ 30,150 SAY "TIPO DE TITULO:"
	@ 30,200 SAY IIF(SE2->E2_FORPAG=="BO","Boleto",IIF(SE2->E2_FORPAG=="CO","Convênio","")) COLOR CLR_GREEN

	@ 50,020 SAY "Linha Digitável:"  SIZE 200,7
	// Linha digitavel de convenio
	IF SE2->E2_FORPAG=="CO"
	    @ 50,070 Get cCodDig PICT "@R 99999999999.9 99999999999.9 99999999999.9 99999999999.9" Size 200,50 Object oCodDig VALID PCI095C()
	// Linha digitavel de boleto
	ELSE
	    @ 50,070 Get cCodDig PICT "@R 99999.99999 99999.999999 99999.999999 9 99999999999999" Size 200,50 Object oCodDig VALID PCI095C()
	ENDIF

	@ 65,020 SAY "Código de Barras:"  SIZE 200,7
	@ 65,070 Get cCodMan PICT "@!" Size 200,50 Object oCodMan VALID PCI095C()

	//@ 70,020 SAY "Cód. Barras PADRAO:"  SIZE 200,7
	//@ 70,070 Get cCodPad PICT "@!" Size 200,50 Object oCodPad WHEN .F.

	A833Muda()
	@ 91,200 BMPBUTTON TYPE 1 ACTION OkProc()
	@ 91,250 BMPBUTTON TYPE 2 ACTION Close(oDlg4)
	ACTIVATE DIALOG oDlg4 CENTER

RETURN NIL

/*
+-------------------+-----------------------------------------------------------+
!Descricao			!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 	actvs													!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	08/19/08	                                       		!
+-------------------+-----------------------------------------------------------+
*/
STATIC FUNCTION PCI095C()

	Local lRet	:= .T.

	lRet	:= CalcCodBar()
	IF !lRet
	   	If cCodBar == "MANUAL"
			APMSGALERT("LINHA DIGITÁVEL INVÁLIDA. Favor tentar novamente.","LINHA INVÁLIDA-"+ALLTRIM(ProcName())+"-ICOMX010")
		ELSE
			APMSGALERT("CÓDIGO BARRAS INVÁLIDO. Favor tentar novamente.","CÓDIGO BARRAS-"+ALLTRIM(ProcName())+"-ICOMX010")
		ENDIF
	ENDIF

Return lRet

/*
+-------------------+-----------------------------------------------------------+
!Descricao			!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	08/19/08	                                       		!
+-------------------+-----------------------------------------------------------+
*/
Static Function OkProc()
   	//Processa( {|| pCobBar() }, "Gravando Codigo de Barras" ,OemToAnsi(""),.F.)
   	CalcCodBar()
	GravaSE2V()

	Close(oDlg4)
Return .T.

/*
+-------------------+-----------------------------------------------------------+
!Descricao			!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	08/19/08	                                       		!
+-------------------+-----------------------------------------------------------+
*/
Static Function CalcCodBar()

	Local aCodPad	:=	{}
	Local lRet	:= .T.

	If cCodBar == "MANUAL"
		aCodPad	:= U_CodBar2(cCodDig)
	ELSE
		aCodPad	:= U_CodBar2(cCodMan)
	ENDIF
	lRet	:= aCodPad[2]

	IF lRet
		// RCO (31/08/10)
		// Se for convênio...
		IF SE2->E2_FORPAG=="CO"
		    If cCodBar == "LEITORA"
			   cNumero := alltrim(cCodMan)
			   cNumAux	:=  Substr(cNumero,1,11) + ;    // CAMPO1
			   				Mod10(Substr(cNumero,1,11)) + ;
		      				Substr(cNumero,12,11) + ;   // CAMPO2
			   				Mod10(Substr(cNumero,12,11)) + ;
		      				Substr(cNumero,23,11) + ;	// CAMPO3
			   				Mod10(Substr(cNumero,23,11)) + ;
		      				Substr(cNumero,34,11) + ;	// CAMPO4
			   				Mod10(Substr(cNumero,34,11))
			ElseIf cCodBar == "MANUAL"
			   cNumAux := 	ALLTRIM(cCodDig)
		 	   cNumero := 	Substr(cNumero,1,11) + ;    // CAMPO1
		      				Substr(cNumero,13,11) + ;   // CAMPO2
		      				Substr(cNumero,25,11) + ;	// CAMPO3
		      				Substr(cNumero,37,11)		// CAMPO4
			ENDIF
		// Se for boleto...
		ELSE
		    If cCodBar == "LEITORA"
			   cNumero := alltrim(cCodMan)
			   cNumAux	:=  Substr(cNumero,1,4) + ;             // BANCO + MOEDA
		      				Substr(cNumero,33,1) + ;                      // DV GERAL
		      				StrZero(Val(Alltrim(Substr(cNumero,34,14))),14) + ; // VALOR
		      				Substr(cNumero,5,5) + ;                              // CAMPO LIVRE
		      				Substr(cNumero,11,10) + ;
		      				Substr(cNumero,22,10)
			ElseIf cCodBar == "MANUAL"
			   cCodMan := ALLTRIM(cCodDig)	//alltrim(cCampo1)+alltrim(cCampo2)+alltrim(cCampo3)+alltrim(cCampo4)+alltrim(cCampo5)+alltrim(cCampo6)+alltrim(cCampo7)+alltrim(cCampo8)
			   cNumAux := cCodMan
			   cSubVal := AllTrim(SubStr(cCodMan,34,14))
			   cValor  := SUBSTR(cSubVal,1,4)+Strzero(Val(SUBSTR(cSubVal,5,10)),10)
		 	   cNumero := AllTrim(SubStr(cCodMan,1,3))   +;   //Banco
			              AllTrim(SubStr(cCodMan,4,1))   +;   // Moeda
			              AllTrim(SubStr(cCodMan,33,1))  +;   // Dac
			              cValor						 +;   // Valor
			              AllTrim(SubStr(cCodMan,5,5))   +;   // Campo Livre
			              AllTrim(SubStr(cCodMan,11,10)) +;   // Campo Livre
			              AllTrim(SubStr(cCodMan,22,10))   // Campo Livre
			EndIf
		ENDIF

		cCodDig	:= cNumAux
		cCodMan	:= cNumero
		oCodDig:Refresh()
		oCodMan:Refresh()
	ENDIF

Return lRet

/*
+-------------------+-----------------------------------------------------------+
!Descricao			!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	19/08/2008                                       		!
+-------------------+-----------------------------------------------------------+
*/
Static Function GravaSE2()

	DbSelectArea("SE2")
	Reclock("SE2",.F.)
	   If cCodBar == "LEITORA"
		  SE2->E2_TPBAR := "L"
	   ElseIf cCodBar == "MANUAL"
	      SE2->E2_TPBAR := "M"
	   EndIf
	   SE2->E2_CODBAR := cNumero
	   SE2->E2_AUXBAR := cNumAux
	msUnlock("SE2")

Return

/*
+-------------------+-----------------------------------------------------------+
!Descricao			!															!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	08/19/08	                                       		!
+-------------------+-----------------------------------------------------------+
*/
Static Function A833Muda()

	If empty(SE2->E2_CODBAR)
	  cCodDig	:= SPACE(48)	//SPACE(47)
      cCodMan 	:= space(44)
	Else
	   cCodMan 	:= ALLTRIM(SE2->E2_CODBAR)
	   cCodDig	:= ALLTRIM(SE2->E2_AUXBAR)
	Endif

   If cCodBar == "LEITORA"
      oCodDig:Disable()
      oCodDig:Refresh()
      oCodMan:Enable()
      oCodMan:Refresh()
   ElseIf cCodBar == "MANUAL"
      oCodMan:Disable()
      oCodMan:Refresh()
      oCodDig:Enable()
      oCodDig:Refresh()
   EndIf

Return Nil

/*
+-------------------+-----------------------------------------------------------+
!Descricao			! Calcula o digito verificador de uma sequencia de numeros	!
!					! baseando-se no modulo 10. Utilizado para verificar o digit!
!					! em linhas digitaveis e codigo de barras de concessionarias!
!					! de servicos publicos										!
+-------------------+-----------------------------------------------------------+
!Autor             	! Claudio D. de Souza										!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	!	14/12/2001                                       		!
+-------------------+-----------------------------------------------------------+
*/
Static Function Mod10( cNum )
	Local nFor    := 0,;
	      nTot    := 0,;
	      cNumAux

	// Verifico o numero de digitos e impar
	// Caso seja, adiciono um caracter
	If Len(cNum)%2 #0
		cNum := "0"+cNum
	EndIf

	   For nFor := 1 To Len(cNum)
	      If nFor%2 == 0
	         cNumAux := StrZero(2 * Val(SubStr(cNum,nFor,1)), 2)
	      Else
	         cNumAux := StrZero(Val(SubStr(cNum,nFor,1))    , 2)
	      Endif
	      nTot += ( Val(LEFT(cNumAux,1)) + Val(Right(cNumAux,1)) )
	   Next

	   nTot := nTot % 10
	   nTot := If( nTot#0, 10-nTot, nTot )

Return StrZero(nTot,1)
