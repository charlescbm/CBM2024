#Include "Protheus.Ch"
#Include "TopConn.Ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"
#include 'TBICONN.CH'

#DEFINE TAM_A4 9 // A4 - 210mm x 297mm - 620 x 876

/*/{Protheus.doc} IFINB050
Função para o processo de geração de boletos do Banco Santander.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param cDocx, caracter, Número do título para gerar o boleto junto com o DANFE.
@param cSeriex, caracter, Número da série para gerar o boleto junto com o DANFE.
@param cEnvBol, caracter, Indica se o boleto será enviado por e-mail. (1 = Sim, 2 = Não).
/*/
//DESENVOLVIDO POR INOVEN

User Function IFINB050(_xNum1,_xNum2,_xPrefixo,_lBanco,_xMail, _xMsgMail,_xAjuste,_xVcto)

	//Local cPerg	:= 'BOL001'
	//Local aRegs	:= {}
	//Local aTemp	:= {}
	Local cV12		:= GetRpoRelease()

	Default _xMail		:= .F.
	Default _xMsgMail	:= ''
	Default _xAjuste	:= .F.
	Default _xVcto		:= ctod('')

	Private lV12		:= SubStr(cV12,1,2) == "12"
	Private cNumBoleto	:= ""
	Private cComplemen	:= ""
	Private cNumBol		:= ""
	Private cNossoNum	:= ""
	Private cDVNossoNum	:= ""
	Private cJuros		:= ""
	Private cMensBol1	:= "Após vencimento cobrar "
	Private cMensBol2	:= ""
	Private cMensBol3	:= "Protestar após 3 dias corridos do vencimento."
	Private cMensBol4	:= ""
	Private lAuto		:= .F.
	Private lReimp		:= .F.
	Private aInfMail	:= {}
	Private lPreview	:= .F.
    Private lPergu      := .T.
	Private lBanco		:= _lBanco

If !Trim(FunName()) == 'SPEDNFE' .and. !IsInCallStack("U_PRTNFESEF") .and. !IsInCallStack("U_IFINB005")

   if !_xMail
		lPergu := .T.
		Processa( {|lEnd| SYVALIDIMP(_xNum1,_xNum2,_xPrefixo,.F.,"",_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)
	else
	    lPergu := .F.
		Processa( {|lEnd| SYVALIDIMP(_xNum1,_xNum2,_xPrefixo,_xMail,_xMsgMail,_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)
	endif
Else 
    lPergu := .F.
	Processa( {|lEnd| SYVALIDIMP(_xNum1,_xNum2,_xPrefixo,.F.,"",_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)

Endif

Return()



/*/{Protheus.doc} SYVALIDIMP
Efetua as regras e validações necessárias antes de imprimir o boleto.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param aCols, array, Array com as informações a serem impressas.
/*/
Static Function SYVALIDIMP(_xDoc1,_xDoc2,_xSer,_xMail,_xMsgMail,_xAjuste,_xVcto)
	//Local nX					:= 0
	Local oPrint				:= Nil
	Local lAdjustToLegacy	:= .F.
	Local lDisableSetup		:= .T.
	Local cDirClient			:= iif(!IsInCallStack("U_ITECX110"), GetTempPath(), "")
	//Local cFile				:= "boleto_inoven_"+Trim(SE1->E1_NUM)+Trim(SE1->E1_PARCELA)+DTOS(dDataBase)+Replace(Time(),':','')+".pdf"
	Local cFile					:= "" 
	Local cDirExp				:= "\spool\"
	//Local cConout				:= ""
    Private lImpri              := .F.                 
	Private _xBCOdia        	:= Padr(Getmv("MV_BCODIA"),3)
	Private _xAGEdia        	:= Padr(Getmv("MV_AGEDIA"),5)
	Private _xCONdia        	:= Padr(Getmv("MV_CONDIA"),10)

	Private cMail 				:= ""

    If lPergu .and. !_xAjuste
    
       If Select("TRB1") > 0
	      TRB1->(DbCloseArea())
       EndIf
	   cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
	   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_PORTADO     = '033' " + CRLF 
	   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
	   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' " + CRLF
	   cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
       TcQuery cQuery New Alias "TRB1"
    Elseif !_xAjuste
       If Select("TRB1") > 0
	      TRB1->(DbCloseArea())
       EndIf
	   cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
	   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	   cQuery += " INNER JOIN "+RetSqlName("SF2")+" F2 ON F2_FILIAL = '" +xFilial("SF2")+ "' AND F2_DUPL = E1_NUM AND F2_PREFIXO = E1_PREFIXO AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA " + CRLF
	   cQuery += " INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_FILIAL = ' ' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
	   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' " + CRLF
	   cQuery += "	 AND F2_FIMP <> 'D' " + CRLF
	   cQuery += "UNION ALL " + CRLF
	   cQuery += "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC " + CRLF
 	   cQuery += "FROM "+RetSqlName("SE1")+" SE1 " + CRLF 
 	   cQuery += "INNER JOIN "+RetSqlName("SA1")+" A1 ON A1_FILIAL = ' ' AND A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF 
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
	   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' " + CRLF 
	   cQuery += "   AND E1_NUM + E1_PREFIXO + E1_CLIENTE + E1_LOJA NOT IN (SELECT F2_DUPL + F2_PREFIXO + F2_CLIENTE + F2_LOJA " + CRLF
	   cQuery += "   FROM "+RetSqlName("SF2")+" F2 " + CRLF 
	   cQuery += "   WHERE F2_FILIAL = '" +xFilial("SF2")+ "' AND F2_DUPL = E1_NUM AND F2_PREFIXO = E1_PREFIXO " + CRLF 
	   cQuery += "   AND F2_CLIENTE = E1_CLIENTE AND F2_LOJA = E1_LOJA " + CRLF
	   cQuery += "   AND F2.D_E_L_E_T_ = ' ' AND F2_FIMP <> 'D' ) " + CRLF
	   cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
       TcQuery cQuery New Alias "TRB1"
    Endif   

	if !lPergu 
		cFile := iif(_xMail,"mail","") + "boleto_inoven_"+Trim(_xDoc1)+"99"+DTOS(dDataBase)+Replace(Time(),':','')+".pdf"
	else
		cFile := "boleto_inoven_"+Trim(_xDoc1)+"99"+DTOS(dDataBase)+Replace(Time(),':','')+".pdf"
	endif
	if IsInCallStack("U_ITECX110")
		cFile := "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf"
	endif

	//+-------------------------------------------------+
	//|Instancia objeto a ser utilizado para impressao. |
	//+-------------------------------------------------+
	if !IsInCallStack("U_ITECX110")
		oPrint:=FWMSPrinter():New(cFile, IMP_PDF, lAdjustToLegacy,cDirExp, lDisableSetup,,,, .T.,, .F.)      
		oPrint:CPATHPDF := cDirClient
		oPrint:setResolution(78)
		oPrint:SetPortrait()
		oPrint:setPaperSize(TAM_A4)
		oPrint:SetMargin(60,60,60,60)

		if _xMail
			oPrint:cPrinter := 'PDF'
		endif
	else
		oPrint := FWMSPrinter():New( cFile, IMP_PDF, .F.,,.T. )
		oPrint:lInJob := .T.
		oPrint:cPathPDF := '\boletos_spool\'
		oPrint:lServer := .T.
	endif


    dbSelectArea("TRB1")
    if !_xAjuste
		dbGoTop()
		cCond := '!Eof()'
	else
		nPosTrb1 := TRB1->(recno())
		cCond := 'TRB1->(recno()) == nPosTrb1'
	endif
	ProcRegua(LastRec())
  	Do While &(cCond)	//!Eof()
		
		//->> Marcelo Celi - Alfa - 21/08/2018 
		//->> Setando a private lImpri como falso, que é o inicializador de situação.
		//->> Caso ele não sofra essa declaração, ele pode estar setado de maneira errada
		//->> e não gerar o nosso numero conforme as regras de boletos.		
		lImpri := .F.
		
		IncProc("Titulo " + TRB1->E1_NUM + " Parcela " + TRB1->E1_PARCELA)	
	
		//+--------------------------------------------------------+
		//|Posiciona no registro atraves do recno filtrado na query|
		//+--------------------------------------------------------+
        SE1->(DbGoTo(TRB1->E1_NUMREC))
		SA1->( DbSetOrder(1) )
		dbSelectArea("SA1")
		DbSetOrder(1)
		DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)

		if lBanco .and. !empty(SA1->A1_BCO1)
           dbSelectArea("TRB1")
	       dbSkip()
	       Loop
		Endif

	    If Alltrim(SE1->E1_XFORMA) = "DP" 
	   	   u_IFINR010(SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_VALOR,SE1->E1_NUM,SE1->E1_EMISSAO,Alltrim(SA1->A1_NOME)) 
           dbSelectArea("TRB1")
	       dbSkip()
	       Loop
	    Endif

		if _xMail
			cMail := alltrim(SA1->A1_EMAIL)
			lPergu := .T.
		endif

		If !Empty(SA1->A1_BCO1)
			_xBCOdia := SA1->A1_BCO1 
			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial("SA6") + _xBCOdia))
			While SA6->(!eof()) .and. SA6->A6_COD == _xBCOdia
				SEE->(DbSetOrder(1))
				if SEE->(DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001"))
					_xAGEdia := SA6->A6_AGENCIA
					_xCONdia := SA6->A6_NUMCON
					exit
				endif
				SA6->(dbSkip())
			end
		Else 
			_xBCOdia        := Padr(Getmv("MV_BCODIA"),3)
			_xAGEdia        := Padr(Getmv("MV_AGEDIA"),5)
			_xCONdia        := Padr(Getmv("MV_CONDIA"),10)
		Endif

        If lPergu 
		   DbSelectArea("SA6")
		   DbSetOrder(1)
		   DbSeek(xFilial("SA6") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA)
		Else
		   DbSelectArea("SA6")
		   dbSeek(xFilial("SA6")+_xBCOdia+_xAGEdia+_xCONdia)
		Endif   
		If !Empty(TRB1->E1_NUMBCO)
		   
		   //->> Marcelo Celi - Alfa - 21/08/2018
		   //->> Vai deixar de perguntar se deseja reimprimir, considerando que se o usuario chegou ate aqui
		   //->> ele realmente deseja reimprimir o documento.
		   
		   /*
		   MsgAlert("Atenção Esse Título Já Foi IMPRESSO !!! " + AllTrim(TRB1->E1_PREFIXO)+AllTrim(TRB1->E1_NUM),"Atenção")
           If MsgYesNo('Imprimir Novamente ?') 
              lImpri := .T.
           Else
              dbSelectArea("TRB1")
	          dbSkip()
              Loop
           EndIf  
           */
		   DbSelectArea("SA6")
		   DbSetOrder(1)
		   DbSeek(xFilial("SA6") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA)
           lImpri := .T.
           
		Endif
        If lPergu
		   If !( AllTrim(SA6->A6_COD) $ "033" )
			  MsgAlert("A impressão de boletos não é valida para o banco " + AllTrim(SA6->A6_COD),"Atenção")
		   Endif
		Endif   
		//+---------------------------+
		//|Chama funcao para impressao|
		//+---------------------------+
		SYIMPBOL(oPrint,_xAjuste,_xVcto)

        dbSelectArea("TRB1")
	    dbSkip()
	Enddo

	If lPreview .and. !_xMail .and. !IsInCallStack("U_ITECX110")
		oPrint:Preview()
	else
		oPrint:SetViewPDF(.F.)
		oPrint:Print(.F.)
		sleep(1000)
	EndIf

	if !IsInCallStack("U_ITECX110")
		//Copiar o PDF para uma pasta do servidor
		if CpyT2S( cDirClient+"\"+cFile, "\boletos_spool", .F., .T. )	//Se copiou
		
			//Enviar email
			if _xMail
				//sleep(500)
				//Somente envia email caso o cliente possua o campo preenchido
				if !empty(cMail)
					goSentMail(_xDoc1,_xSer,cMail,"\boletos_spool\"+cFile,_xMsgMail)
				endif
			endif

		endif
	endif

	if _xAjuste
		TRB1->(dbGoto(nPosTrb1))
	endif

Return()


/*/{Protheus.doc} SYIMPBOL
Gera o layout do boleto já com as informações.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param oPrint, objeto, Objeto de impressão a ser utilizado.
/*/
Static Function SYIMPBOL(oPrint,_xAjuste,_xVcto)
	Local cCarteira		:= "101"
	Local cValorTit		:= ""
	Local cFatorVcto	:= ""
	Local cNumBanco		:= AllTrim(SA6->A6_COD)
	Local cAgencia		:= Alltrim(SA6->A6_AGENCIA)
	//Local cNumConta		:= Alltrim(SA6->A6_NUMCON)
	//Local cDigConta		:= Alltrim(SA6->A6_DVCTA)
	//Local cDigAgenc		:= Alltrim(SA6->A6_DVAGE)
	Local cCodCed		:= AllTrim(SA6->A6_CODCED)
	Local cDtVencto		:= Ctod("")
	Local cBitMapBanco	:= GetSrvProfString("Startpath","")+"\logo_sant.bmp"
	//Local cNumTit		:= Iif(!Empty(SE1->E1_NUM), Alltrim(SE1->E1_NUM), StrZero(Val(SE1->E1_NUM),6))
	Local cNumTit		:= Iif(!Empty(SE1->E1_NUM), Alltrim(SE1->E1_NUM), StrZero(Val(SE1->E1_NUM),9))
	Local cParcela		:= IIF(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)
	Local oFont6  		:= TFont():New("Arial", 9, 06, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8  		:= TFont():New("Arial", 9, 08, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8B  		:= TFont():New("Arial", 9, 08, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont10 		:= TFont():New("Arial", 9, 10, .T., .T., 5, .T., 5, .T., .F.)
	//Local oFont12 		:= TFont():New("Arial", 9, 12, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont11 		:= TFont():New("Arial", 9, 11, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont16 		:= TFont():New("Arial", 9, 16, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont14N		:= TFont():New("Arial", 9, 14, .T., .F., 5, .T., 5, .T., .F.)
	//Local oFont22 		:= TFont():New("Arial", 9, 22, .T., .T., 5, .T., 5, .T., .F.)
	Local nValorTit		:= 0
	Local _d

	// +----------------------------------------------------------+
	// | Indica que foi gerado boleto para pelo menos uma parcela |
	// +----------------------------------------------------------+
	lPreview := .T.
	cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
	nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	if _xAjuste
		_xVmulta := (nValorTit * 1.99)/100
		//_xVmora  := (((nValorTit * 1.99)/100)/30)
		_xVmora  := (((nValorTit * 1)/100)/30)
		nValorTit += _xVmulta	//soma a multa
		for _d := 1 to (_xVcto - SE1->E1_VENCREA)
			nValorTit += _xVmora //aplica a mora por dia de atraso
		next
	endif
	cFatorVcto := StrZero(cDtVencto - Ctod("07/10/1997"),4)
	cValorTit  := Right(StrZero(nValorTit * 100,17,0),10)
	IF nValorTit > 99999999.99
		cFatorVcto:= ""
		cValorTit := Substr(StrZero(nValorTit * 100,17,2),1,14)
	EndIF
    //+--------------------------------------------------+
	//| Prepara o nosso numero com as devidas validacoes |
	//+--------------------------------------------------+
    If !lImpri
	   DbSelectArea("SEE")
       DbSetOrder(1)
       DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001")
       cNumBoleto := StrZero(Val(ALLTRIM(SEE->EE_DIRPAG)),12)
	   cDigitao	  := IIF(lReimp,SubStr(cNumBoleto,Len(cNumBoleto),1),BRPDIG2( StrZero(Val(cNumBoleto),12),cNumBoleto ))
         Reclock("SEE",.F.)
           SEE->EE_DIRPAG := StrZero(Val(cNumBoleto)+1,12)
         MsUnlock()
	     DbSelectArea("SE1")
	     RecLock("SE1",.F.)
	       SE1->E1_NUMBCO  := StrZero(Val(ALLTRIM(cNumBoleto+cDigitao)),11)	//StrZero(Val(ALLTRIM(cNumBoleto)),10)
	       SE1->E1_PORTADO := SA6->A6_COD
	       SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	       SE1->E1_CONTA   := SA6->A6_NUMCON   
	     MsUnlock()
	Else
	   //cNumBoleto := StrZero(Val(ALLTRIM(SE1->E1_NUMBCO)),12) 
	   //cDigitao	  := IIF(lReimp,SubStr(cNumBoleto,Len(cNumBoleto),1),BRPDIG2( cAgencia + cNumConta + cCarteira + StrZero(Val(cNumBoleto),8),cNumBoleto ))
	   cNumBoleto := substr(SE1->E1_NUMBCO,1,len(alltrim(SE1->E1_NUMBCO))-1)
	   cDigitao	  := right(alltrim(SE1->E1_NUMBCO),1)
	Endif
	                        
	//->> Marcelo Celi - Alfa - 24/09/2018
	cNumBoleto := StrZero(Val(cNumBoleto),12)
	
	cDadosCta	:=	cAgencia +  " / " + cCodCed
	cDigCodBar	:=	Modulo11(cNumBanco + "9" + cFatorVcto + cValorTit + '9' + cCodCed + cNumBoleto + cDigitao + '0' + cCarteira )
	cDigCodBar	:= IIF(cDigCodBar $ "0|1|10","1",cDigCodBar)
  	cCodBar	    := cNumBanco + "9" + cDigCodBar + cFatorVcto + cValorTit + '9' + cCodCed + cNumBoleto + cDigitao + '0' + cCarteira 
	cDigblc1	:=	Modulo10(cNumBanco + "99" + SubStr(cCodCed,1,4))
	cBloco1		:=	Transform(cNumBanco + "99" + SubStr(cCodCed,1,4) + cDigblc1,"@R 99999.99999")
	cDigblc2	:=	Modulo10(SubStr(cCodCed,5,3) + SubStr(StrZero(val(cNumBoleto),12)+cDigitao,1,7))
	cBloco2		:= 	Transform(SubStr(cCodCed,5,3) + SubStr(StrZero(val(cNumBoleto),12)+cDigitao,1,7) + cDigblc2,"@R 99999.999999")
	cDigblc3	:=	Modulo10(SubStr(StrZero(val(cNumBoleto),12)+cDigitao,8,6) + '0' + cCarteira)
	cBloco3		:=	Transform(SubStr(StrZero(val(cNumBoleto),12)+cDigitao,8,6) + '0' + cCarteira + cDigblc3,"@R 99999.999999")
	cBloco4		:=	cFatorVcto + cValorTit
	cLinDigi	:=	cBloco1 + "   " + cBloco2 + "   " + cBloco3 + "  " + cDigCodBar + "   " + cBloco4

	//+---------------------+
	//| Inicia nova pagina. |
	//+---------------------+
	oPrint:StartPage()

	//+--------------------------+
	//|Layout - Recibo do Sacado |
	//+--------------------------+
	oPrint:Line(80, 240, 100, 240) // Linha do codigo do banco
	oPrint:Line(80, 285, 100, 285) // Linha do codigo do banco
	oPrint:Box(100, 025, 128, 390) // Local de pagamento
	oPrint:Box(100, 390, 128, 550) // Vencimento
	oPrint:Box(128, 025, 148, 390) // Cedente
	oPrint:Box(128, 390, 148, 550) // Ag. / Cod. Cedente
	oPrint:Box(148, 025, 168, 088) // Data Documento
	oPrint:Box(148, 088, 168, 190) // No. Documento
	oPrint:Box(148, 190, 168, 233) // Esp. Doc.
	oPrint:Box(148, 233, 168, 285) // Aceite
	oPrint:Box(148, 285, 168, 390) // Data Processamento
	oPrint:Box(148, 390, 168, 550) // Nosso Num
	oPrint:Box(168, 025, 188, 088) // Uso do Banco
	oPrint:Box(168, 088, 188, 152) // Carteira
	oPrint:Box(168, 152, 188, 190) // Especie
	oPrint:Box(168, 190, 188, 285) // Quantidade
	oPrint:Box(168, 285, 188, 390) // Valor
	oPrint:Box(168, 390, 188, 550) // (=) Valor documento
	oPrint:Box(188, 025, 288, 390) // Instrucoes
	oPrint:Box(188, 390, 208, 550) // (-) Desconto
	oPrint:Box(208, 390, 228, 550) // (-) Abatimento
	oPrint:Box(228, 390, 248, 550) // (+) Mora
	oPrint:Box(248, 390, 268, 550) // (+) Outros Acrescimos
	oPrint:Box(268, 390, 288, 550) // (=) Valor Cobrado
	oPrint:Box(288, 025, 330, 550) // Sacado

	//+-----------------------------+
	//|Layout - Ficha de Compensacao|
	//+-----------------------------+
	oPrint:Line(444, 145, 464, 145) // Linha do codigo do banco
	oPrint:Line(444, 190, 464, 190) // Linha do codigo do banco
	oPrint:Box(464, 025, 490, 390) // Local de Pagamento
	oPrint:Box(464, 390, 490, 550) // Vencimento
	oPrint:Box(490, 025, 510, 390) // Cedente
	oPrint:Box(490, 390, 510, 550) // Ag. / Cod. Cedente
	oPrint:Box(510, 025, 530, 088) // Data Documento
	oPrint:Box(510, 088, 530, 190) // No. Documento
	oPrint:Box(510, 190, 530, 233) // Esp. Doc.
	oPrint:Box(510, 233, 530, 285) // Aceite
	oPrint:Box(510, 285, 530, 390) // Data Processamento
	oPrint:Box(510, 390, 530, 550) // Nosso Num
	oPrint:Box(530, 025, 550, 088) // Uso do Banco
	oPrint:Box(530, 088, 550, 152) // Carteira
	oPrint:Box(530, 152, 550, 190) // Especie
	oPrint:Box(530, 190, 550, 285) // Quantidade
	oPrint:Box(530, 285, 550, 390) // Valor
	oPrint:Box(530, 390, 550, 550) // (=) Valor documento
	oPrint:Box(550, 025, 650, 390) // Instrucoes
	oPrint:Box(550, 390, 570, 550) // (-) Desconto
	oPrint:Box(570, 390, 590, 550) // (-) Abatimento
	oPrint:Box(590, 390, 610, 550) // (+) Mora
	oPrint:Box(610, 390, 630, 550) // (+) Outros Acrescimos
	oPrint:Box(630, 390, 650, 550) // (=) Valor Cobrado
	oPrint:Box(650, 025, 693, 550) // Sacado

	//+--------------------------+
	//|Layout - Recibo do Sacado |
	//+--------------------------+
	_M0NOME := "INOVEN COMERCIO INTERNACIONAL LTDA"
	_M0CGC  := "07826504000104"	//"07826504000295"

	If File(cBitMapBanco)
		oPrint:SayBitmap(070, 020, cBitMapBanco, 120, 028 )
	Else
		oPrint:Say(096, 027, AllTrim(SA6->A6_NOME), oFont14N)
	EndIf

	oPrint:Say(096, 245, cNumBanco + "-7", oFont16)
	oPrint:Say(096, 450, "RECIBO DO SACADO", oFont8B ,100)
	oPrint:Say(107, 027, "Local de Pagamento",ofont8,100)
	oPrint:Say(116, 027, "Até o vencimento, preferencialmente nas agências do SANTANDER",oFont10,100)
	oPrint:Say(107, 392, "Vencimento",ofont8,100)
	oPrint:Say(120, 400, DTOC(cDtVencto),ofont10,400,,,1) //Vencimento
	oPrint:Say(135, 027, "Cedente",ofont8,100)
	oPrint:Say(135, 392, "Agência/Código Cedente",ofont8,100)
	oPrint:Say(145, 030, Upper(Alltrim(_M0NOME))+Space(15)+"CNPJ "+Transform(_M0CGC,"@R 99.999.999/9999-99") ,ofont10,100)
	oPrint:Say(145, 400, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oPrint:Say(155, 027, "Data Documento",ofont8,100)
	oPrint:Say(155, 092, "No. do Documento",ofont8,100)
	oPrint:Say(155, 195, "Esp. Doc.",ofont8,100)
	oPrint:Say(155, 238, "Aceite",ofont8,100)
	oPrint:Say(155, 290, "Data Processamento",ofont8,100)
	oPrint:Say(155, 392, "Nosso Número",ofont8,100)
	oPrint:Say(164, 027, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oPrint:Say(164, 094, cNumTit+"/"+cParcela,ofont10,100)    //Numero do Documento
	oPrint:Say(164, 195, "DM",ofont10,100)
	oPrint:Say(164, 238, "N",ofont10,100)
	oPrint:Say(164, 290, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oPrint:Say(164, 400, cNumBoleto+cDigitao) //TransForm(cNossoNum,"@R " + Replicate('9',Len(cNossoNum)-1)+"-9"),ofont10,100,,,1)
	oPrint:Say(175, 027, "Uso do Banco",ofont8,100)
	oPrint:Say(175, 093, "Carteira",ofont8,100)
	oPrint:Say(175, 157, "Espécie",ofont8,100)
	oPrint:Say(175, 195, "Quantidade",ofont8,100)
	oPrint:Say(175, 293, "Valor",ofont8,100)
	oPrint:Say(175, 392, "(=) Valor do Documento",ofont8,100)
	oPrint:Say(185, 093, cCarteira,ofont10,100) // carteira
	oPrint:Say(185, 157, "R$",ofont10,100)
	oPrint:Say(185, 450, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1) //Valor
	oPrint:Say(195, 027, "Instruções de responsabilidade do Beneficiário. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO.",ofont6,100)
	oPrint:Say(195,392,"(-) Desconto",ofont8,100)
	oPrint:Say(215,392,"(-) Abatimento",ofont8,100)
	oPrint:Say(235,392,"(+) Mora",ofont8,100)
	oPrint:Say(255,392,"(+) Outros Acréscimos",ofont8,100)
	oPrint:Say(275,392,"(=) Valor Cobrado",ofont8,100)
    oPrint:Say  (205,027 ,"PAGAR SOMENTE COM BOLETO." ,oFont10)
    //oPrint:Say  (215,027 ,"Protestar no quinto dia util apos o vencimento." ,oFont10)
    oPrint:Say  (215,027 ,"" ,oFont10)
	if !_xAjuste
		_xVmulta := (nValorTit * 1.99)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
	endif
	oPrint:Say  (225, 027, "APOS VENCIMENTO, MULTA DE R$ "+TransForm(_xVmulta, "@E 99,999.99")+"  MORA/DIA R$ "+TransForm(_xVmora, "@E 99,999.99"), oFont10)
	oPrint:Say  (235, 027, cMensBol4, oFont10)

	oPrint:Say(294, 027, "Sacado", ofont8, 100)
	oPrint:Say(294, 392, "Autenticação Mecânica", ofont8, 100)
	oPrint:Say(302, 027, AllTrim(SA1->A1_NOME)+'  -  ' + SA1->A1_COD, ofont8B, 100)
    If Len(Alltrim(SA1->A1_CGC)) == 14
	oPrint:Say(302, 370, "CNPJ "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	oPrint:Say(302, 370, "CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
	Endif
	oPrint:Say(311, 027, AllTrim(SA1->A1_END) + IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:Say(320, 027, Alltrim(Transform(SA1->A1_CEP,"@R 99999-999"))+'   -   '+ AllTrim(SA1->A1_MUN)+'   -   '+SA1->A1_EST, oFont8B, 100 )
	oPrint:Say(328, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(328, 392, 'Cód. Baixa', ofont8, 100)

	oPrint:Say(395, 000, Replicate("-",1800), ofont8, 100)

	//+-----------------------------+
	//|Layout - Ficha de Compensacao|
	//+-----------------------------+
	If File(cBitMapBanco)
		oPrint:SayBitmap(435, 020, cBitMapBanco, 120, 028 )
	Else
		oPrint:Say(461, 027, SubStr(AllTrim(SA6->A6_NOME),1,18), ofont11, 100)
	EndIf
	oPrint:Say(461, 150, cNumBanco + "-7", oFont16, 100)
	oPrint:Say(461, 193, cLinDigi, oFont14N, 100 )
	oPrint:Say(471, 027, "Local de Pagamento",ofont8,100)
	oPrint:Say(471, 392, "Vencimento",ofont8,100)
	oPrint:Say(480, 027, "Até o vencimento, preferencialmente nas agências do SANTANDER",ofont10,100)
	oPrint:Say(480, 400, DTOC(cDtVencto), ofont10, 100,,,1)
	oPrint:Say(497, 027, "Cedente",ofont8,100)
	oPrint:Say(497, 392, "Agência/Código Cedente",ofont8,100)
	oPrint:Say(507, 030, Upper(Alltrim(_M0NOME))+Space(15)+"CNPJ "+Transform(_M0CGC,"@R 99.999.999/9999-99"),ofont10,100)
	oPrint:Say(507, 400, cDadosCta,ofont10,116,,,1) //Agencia/Codigo do Cedente
	oPrint:Say(518, 027, "Data Documento",ofont8,100)
	oPrint:Say(518, 092, "No. do Documento",ofont8,100)
	oPrint:Say(518, 195, "Esp. Doc.",ofont8,100)
	oPrint:Say(518, 238, "Aceite",ofont8,100)
	oPrint:Say(518, 290, "Data Processamento",ofont8,100)
	oPrint:Say(518, 392, "Nosso Número",ofont8,100)
	oPrint:Say(527, 027, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oPrint:Say(527, 093, cNumTit+"/"+cParcela,ofont10,100)    //Numero do Documento
	oPrint:Say(527, 195, "DM",ofont10,100)
	oPrint:Say(527, 238, "N",ofont10,100)
	oPrint:Say(527, 290, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oPrint:Say(527, 400, cNumBoleto+cDigitao)           //TransForm(cNossoNum,"@R " + Replicate('9',Len(cNossoNum)-1)+"-9"),ofont10,100,,,1)
	oPrint:Say(538, 027, "Uso do Banco",ofont8,100)
	oPrint:Say(538, 093, "Carteira",ofont8,100)
	oPrint:Say(538, 157, "Espécie",ofont8,100)
	oPrint:Say(538, 195, "Quantidade",ofont8,100)
	oPrint:Say(538, 290, "Valor",ofont8,100)
	oPrint:Say(538, 392, "(=) Valor do Documento",ofont8,100)
	oPrint:Say(548, 093, cCarteira,ofont10,100) // carteira
	oPrint:Say(548, 157, "R$",ofont10,100)
	oPrint:Say(548, 450, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1)           //Valor
	oPrint:Say(558, 027, "Instruções de responsabilidade do Beneficiário. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO.",ofont6,100)
	oPrint:Say(558, 392, "(-) Desconto",ofont8,100)
	oPrint:Say(578, 392, "(-) Abatimento",ofont8,100)
	oPrint:Say(598, 392, "(+) Mora",ofont8,100)
	oPrint:Say(618, 392, "(+) Outros Acréscimos",ofont8,100)
	oPrint:Say(638, 392, "(=) Valor Cobrado",ofont8,100)

    oPrint:Say  (568,027 ,"PAGAR SOMENTE COM BOLETO." ,oFont10)
    //oPrint:Say  (578,027 ,"Protestar no quinto dia util apos o vencimento." ,oFont10)
    oPrint:Say  (578,027 ,"" ,oFont10)
	if !_xAjuste
		_xVmulta := (nValorTit * 1.99)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
	endif
	oPrint:Say  (588, 027, "APOS VENCIMENTO, MULTA DE R$ "+TransForm(_xVmulta, "@E 99,999.99")+"  MORA/DIA R$ "+TransForm(_xVmora, "@E 99,999.99"), oFont10)
	oPrint:Say  (598, 027, cMensBol4, oFont10)

	oPrint:Say(657, 027, "Sacado", ofont8, 100)
	oPrint:Say(657, 392, "Autenticação Mecânica", ofont8, 100)
	oPrint:Say(665, 027, AllTrim(SA1->A1_NOME)+'  -  ' + SA1->A1_COD, ofont8B, 100)
	If Len(Alltrim(SA1->A1_CGC)) == 14
	oPrint:Say(665, 370, "CNPJ "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	oPrint:Say(665, 370, "CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
	Endif
	oPrint:Say(674, 027, AllTrim(SA1->A1_END) + IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:Say(683, 027, Alltrim(Transform(SA1->A1_CEP,"@R 99999-999"))+'   -   '+ AllTrim(SA1->A1_MUN)+'   -   '+ SA1->A1_EST, oFont8B, 100 )
	oPrint:Say(690, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(690, 392, 'Cód. Baixa', ofont8, 100)
	oPrint:Say(702, 375, 'Autenticação Mecânica - Ficha de Compensação', ofont8, 100)

	//+-------------------------------+
	//|Impressão do  codigo de barras |
	//+-------------------------------+
	oPrint:FWMSBAR("INT25" ,62 ,3 ,cCodBar ,oPrint,.F.,,.T.,0.025,1.2,,,,.F.,,,)

 	oPrint:EndPage()
	
	aAdd(aInfMail,cNumTit) // Numero do titulo utilizado no boleto
	aAdd(aInfMail,SE1->E1_PREFIXO) // Serie do titulo
	aAdd(aInfMail,cParcela) // Parcela que foi impressa
	aAdd(aInfMail,_M0NOME) // Nome da Beneficiario
Return()

/*/{Protheus.doc} SyGetNN
Prepara o Nosso Numero verificando se o numero a ser utilizado ja existe.
@author Douglas Telles
@since 25/05/2016
@version 1.0
/*/
Static Function SyGetNN()
	cNumBoleto		:= SYRETSEQ() // Numero sequencial de acordo com a SEE
//	cDVNossoNum	:= AllTrim(Modulo11(cNumBoleto)) // Digito de Verificacao do nosso numero

	If !lReimp
//		While ValFaixa(cNumBoleto + cDVNossoNum,SE1->E1_AGEDEP,SE1->E1_CONTA)
		While ValFaixa(cNumBoleto ,SE1->E1_AGEDEP,SE1->E1_CONTA)
			cNumBoleto		:= Soma1(cNumBoleto)
//			cDVNossoNum	:= AllTrim(Modulo11(cNumBoleto))
		EndDo

		DbSelectArea("SEE")
		RecLock("SEE",.F.)
			SEE->EE_DIRPAG := StrZero(Val(cNumBoleto) + 1,7)
		MsUnlock()

		DbSelectArea("SE1")
		RecLock("SE1",.F.)
			SE1->E1_NUMBCO := StrZero(Val(cNumBoleto) + 1,7)  //+ cDVNossoNum
		MsUnlock()
	EndIf

	cNossoNum	:= StrZero(Val(cNumBoleto),13) //+ cDVNossoNum // Nosso numero. (Numero do boleto)
Return

/*/{Protheus.doc} SYRETSEQ
Captura o numero do boleto.
@author Douglas Telles
@since 01/06/2016
@version 1.0
@return cNumero, Numero do boleto a ser utilizado.
/*/
Static Function SYRETSEQ()
	Local cNumero

	If lReimp
		cNumero := StrZero(Val(cNumBol),7)
	Else
		cNumero := StrZero(Val(SEE->EE_DIRPAG),7)
	EndIf
Return(cNumero)

/*/{Protheus.doc} SYCALCJU
Calcula o valor do juros a ser cobrado.
@author Douglas Telles
@since 01/06/2016
@version 1.0
@param nValorTit, numérico, Valor do título.
@return cRet, Valor do juros ja com a picture.
/*/
Static Function SYCALCJU(nValorTit)
	Local nPrcDia	:= SE1->E1_PORCJUR
	Local nResult	:= 0
	Local cRet		:= ''

	nResult	:= (nPrcDia * nValorTit) / 100
	cRet		:= Alltrim(Transform(nResult,"@E 999,999,999.99"))
Return(cRet)

/*/{Protheus.doc} ValFaixa
Valida a faixa da tabela de parametros de banco.
@author Douglas Telles
@since 25/05/2016
@version 1.0
@param cNum, caracter, Numero a ser validado
@return lExist, Indica se o codigo ja existe
/*/
Static Function ValFaixa(cNum,cAgencia,cConta)
	//Local aBkpArea	:= GetArea()
	Local lExist		:= .F.
	Local cQry			:= ""

	cQry := "SELECT COUNT(E1_NUM) QTD" + CRLF
	cQry += "FROM " + RetSqlName("SE1") + " SE1" + CRLF
	cQry += "WHERE E1_FILIAL = '" + xFilial("SE1") + "' AND" + CRLF
	If lV12
		cQry += "	E1_NUMBCO LIKE '" + AllTrim(cNum) + "'"+ CRLF
	Else
		cQry += "	'" + AllTrim(cNum) + "' IN(CASE WHEN E1_NUMBCO = ' '"+ CRLF
		cQry += "	THEN"+ CRLF
		cQry += "		E1_NBOLETO"+ CRLF
		cQry += "	ELSE"+ CRLF
		cQry += "		E1_NUMBCO"+ CRLF
		cQry += "	END)"+ CRLF
	EndIf
	cQry += "	AND E1_PORTADO = '033' " + CRLF
	cQry += "	AND E1_AGEDEP = '" + cAgencia + "' " + CRLF
	cQry += "	AND E1_CONTA = '" + cConta + "' " + CRLF
	cQry += "	AND SE1.D_E_L_E_T_ = ' '" + CRLF

	//+---------------------------------+
	//|Verifica se o arquivo esta em uso|
	//+---------------------------------+
	If Select("TRB2") > 0
		TRB2->(DbCloseArea())
	EndIf

	//+--------------------------+
	//|Cria instancia de trabalho|
	//+--------------------------+
	TcQuery cQry New Alias "TRB2"

	If TRB2->QTD > 0
		lExist := .T.
	EndIf

	TRB2->(DbCloseArea())
Return (lExist)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRPIMPBOL ºAutor  ³     SYMM           º Data ³  06/22/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
Static Function BRPDIG2(cNossoNum,cNumero)
	Local aDados1	:=	{}
	Local aPesos	:=	{2,3,4,5,6,7,8,9,2,3,4,5}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0

	//For nX:= 1 To Len(cNossoNum)
	For nX := Len(Alltrim(cNossoNum)) To 1 Step -1
		aAdd(aDados1,Val(SubStr(cNossoNum,nX,1)))
	Next nX

	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX

	//For nX:= 1 To Len(aResult)
	//	If Len(Alltrim(Str(aResult[nX]))) > 1
	//		aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
	//	EndIf
	//Next

	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX

	nResult2	:= Mod(nResult1,11)
	nResult3	:= iif(!empty(nResult2) .and. nResult2<>1,11 - nResult2,0)

Return(Iif(Alltrim(Str(nResult3)) == "10","1",Alltrim(Str(nResult3))))


Static Function goSentMail(_xDoc1,_xSer,cMail,xFile,xMsgMail)
	
	Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
	Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
	Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
   	Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
	Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
	//Local lConnect  := .F.
	//Local lEnviou   := .F.
	Local lRet      := .T.
	//Local cError	:= ''
	Local cTo		:= ''
	Local cSubject	:= 'Boleto Documento : ' + _xSer+'/'+_xDoc1 + ' - Data: ' + dtoc(dDataBase)
	Local cCorpo	:= ''
	//Local cAnexos	:= '\boletos_spool\' + xFile	
	
	//--Limpa variavel
	cCorpo:=''
	//Atualiza variavel
	cBody:= 'Sr. cliente, em anexo segue boleto referente a nota fiscal: ' + _xSer+'/'+_xDoc1
	if !empty(xMsgMail)
		cBody += '<br><br>Mensagem INOVEN: <br>' + xMsgMail
	endif
	cTo:= cMail

	//Cria a conexão com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	oServer:Init( "", cServer, cAccount, cPassword, 0, 25 )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		Alert( "Falha ao setar o time out" )
		Return .F.
	EndIf

	//realiza a conexão SMTP
	If oServer:SmtpConnect() != 0
		Alert( "Falha ao conectar" )
		Return .F.
	EndIf

	if lRelauth
		nRet := oServer:SMTPAuth( cAccount, cPassword )
		If nRet != 0
			alert("nao autenticou...." + oServer:GetErrorString( nRet ))
			Return .F.
		endif
	endif

	//Apos a conexão, cria o objeto da mensagem
	oMessage := TMailMessage():New()

	//Limpa o objeto
	oMessage:Clear()

	//Popula com os dados de envio
	oMessage:cFrom              := cFrom
	oMessage:cTo                := cTo
	//oMessage:cCc                := ""
	//oMessage:cBcc               := ""
	oMessage:cSubject           := cSubject
	oMessage:cBody              := cBody

	//Adiciona um attach
	//If oMessage:AttachFile( cAnexos ) < 0
	If oMessage:AttachFile( xFile ) < 0
		Alert( "Erro ao atachar o arquivo" )
		Return .F.
	//Else
		//adiciona uma tag informando que é um attach e o nome do arq
	//	oMessage:AddAtthTag( 'Content-Disposition: attachment; filename=testeboleto.pdf')
	EndIf
	

	//Envia o e-mail
	If oMessage:Send( oServer ) != 0
		Alert( "Erro ao enviar o e-mail" )
		Return .F.
	EndIf

	//Desconecta do servidor
	If oServer:SmtpDisconnect() != 0
		Alert( "Erro ao disconectar do servidor SMTP" )
		Return .F.
	EndIf

	/*If lRet
		//--Mensagem de envio
		MsgAlert("Email com boleto(s) enviado com sucesso","Reimpressao de Boletos")
	EndIf	*/

Return(lRet)
