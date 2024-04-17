#Include "Protheus.Ch"
#Include "TopConn.Ch"                                           
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"

#DEFINE	 TAM_A4 9			//A4     	210mm x 297mm  620 x 876
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLBB     ºAutor  ³Wheber Bogdanaviciusº Data ³  01/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Modelo de Boleto Banco do Brasil                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Maurano                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function IFINB030(_xNum1,_xNum2,_xPrefixo,_lBanco,_xMail, _xMsgMail,_xAjuste,_xVcto)

	//Local cPerg	:= 'BOL001'
	//Local aRegs	:= {}
	//Local aTemp	:= {}
	Local cV12	:= GetRpoRelease()

	Default _xMail 		:= .F.
	Default _xMsgMail 	:= ''
	Default _xAjuste	:= .F.
	Default _xVcto		:= ctod('')

	Private lV12		:= SubStr(cV12,1,2) == "12"
	Private oBrowse		:= Nil
	Private lOrdem1		:= .T.
	Private oOK			:= LoadBitmap(GetResources(),'WFCHK')
	Private oNO			:= LoadBitmap(GetResources(),'WFUNCHK')
	Private cNumBoleto	:= ""
	Private cComplemen	:= ""
	Private cNumBol		:= ""
	Private cNossoNum	:= ""
	Private cDVNossoNum	:= ""
	Private cJuros		:= ""
	Private cMensBol1	:= ""
	Private cMensBol2	:= ""
	Private cMensBol3	:= "APOS VENCIMENTO, MULTA DE R$ 7.24 + MORA/DIA R$ 1.20"
	Private cMensBol4	:= ""  
	Private lAuto		:= .F.
	Private lReimp		:= .F.
	Private aInfMail	:= {}
	Private _cTitulo	:= ' '
	Private lPreview	:= .F.
    Private lPergu      := .T.
	Private lBanco		:= _lBanco

If !Trim(FunName()) == 'SPEDNFE' .and. !IsInCallStack("U_PRTNFESEF") .and. !IsInCallStack("U_IFINB005")
 
   if !_xMail
		lPergu := .T.
		Processa( {|lEnd| BRPIMPRIME(_xNum1,_xNum2,_xPrefixo,.F.,"",_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)
	else
	    lPergu := .F.
		Processa( {|lEnd| BRPIMPRIME(_xNum1,_xNum2,_xPrefixo,_xMail,_xMsgMail,_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)
	endif

Else 
    lPergu := .F.
	Processa( {|lEnd| BRPIMPRIME(_xNum1,_xNum2,_xPrefixo,.F.,"",_xAjuste,_xVcto) }, "Aguarde...","Gerando Boletos...",.T.)
Endif

Return()                                                                        


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
Static Function BRPIMPRIME(_xDoc1,_xDoc2,_xSer,_xMail,_xMsgMail,_xAjuste,_xVcto)

	//Local nX				:= 0
	Local oPrint			:= Nil
	Local lAdjustToLegacy	:= .F.
	Local lDisableSetup		:= .T.
	Local cDirClient		:= iif(!IsInCallStack("U_ITECX110"), GetTempPath(), "")
	Local cFile				:= ""	//"Boleto_Inoven_"+DTOS(dDataBase)+Replace(Time(),':','')+".PDF" 
	Local cDirExp			:= "C:\spool\"
	//Local cConout			:= ""
	Private lImpri          := .F.
	Private _xBCOdia        := Padr(Getmv("MV_BCODIA"),3)
	Private _xAGEdia        := Padr(Getmv("MV_AGEDIA"),5)
	Private _xCONdia        := Padr(Getmv("MV_CONDIA"),10)

    If lPergu .and. !_xAjuste 
          
       If Select("TRB1") > 0
	      TRB1->(DbCloseArea())
       EndIf
	   cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
	   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_PORTADO     = '001' " + CRLF 
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
	   cQuery += " AND F2.D_E_L_E_T_ = ' ' " + CRLF
	   cQuery += "WHERE E1_FILIAL       = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP')" + CRLF 
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
        
	if !IsInCallStack("U_ITECX110")
		oPrint:=FWMSPrinter():New(cFile, IMP_PDF, lAdjustToLegacy,cDirExp, lDisableSetup, , , , .T., , .F., )      
		oprint:CPATHPDF:=cDirClient
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
  	
  	   IncProc( "Titulo " + TRB1->E1_NUM + " Parcela " + TRB1->E1_PARCELA )
	   //+--------------------------------------------------------+
	   //|Posiciona no registro atraves do recno filtrado na query|
	   //+--------------------------------------------------------+
		SE1->(DbGoTo(TRB1->E1_NUMREC))  
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
		   If !( AllTrim(SA6->A6_COD) $ "001" )
		      MsgAlert("A impressão de boletos não é valida para o banco " + AllTrim(SA6->A6_COD),"Atenção")
		   Endif
		Endif   
	   //+---------------------------+
	   //|Chama funcao para impressao|
	   //+---------------------------+
	   BRPBOLIMP(oPrint,_xAjuste,_xVcto)

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BRPIMPBOL ºAutor  ³SYMM                º Data ³  06/22/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function BRPBOLIMP(oPrint,_xAjuste,_xVcto)

	Local cCarteira		:= "17"
	//Local cValorTit		:= ""
	//Local cFatorVcto	:= ""
	Local cNumBanco		:= AllTrim(SA6->A6_COD)
	//Local cAgencia		:= StrTran(Alltrim(SA6->A6_AGENCIA),'-','')
	//Local cNumConta		:= StrTran(Alltrim(SA6->A6_NUMCON),'-','')
	//Local cDigConta		:= IIF(Empty(SA6->A6_DVCTA),Alltrim(SubStr(SA6->A6_NUMCON,At("-",SA6->A6_NUMCON) + 1)),Alltrim(SA6->A6_DVCTA))
	//Local cDigAgenc		:= IIF(Empty(SA6->A6_DVAGE),Alltrim(SubStr(SA6->A6_AGENCIA,At("-",SA6->A6_AGENCIA) + 1)),Alltrim(SA6->A6_DVAGE))
	Local cConvenio		:= AllTrim(SEE->EE_CODEMP)
	Local cDtVencto		:= Ctod("")
	Local cBitMapBanco	:= GetSrvProfString("Startpath","")+"\logo_bb.bmp"//png"
	//Local cNumTit		:= Iif(!Empty(SE1->E1_NFELETR), Alltrim(SE1->E1_NFELETR), StrZero(Val(SE1->E1_NUM),6))
	Local cNumTit		:= Iif(!Empty(SE1->E1_NFELETR), Alltrim(SE1->E1_NFELETR), StrZero(Val(SE1->E1_NUM),9))
	Local cParcela		:= IIF(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)	
	Local oFont6  		:= TFont():New("Arial", 9, 06, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8  		:= TFont():New("Arial", 9, 08, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8B  		:= TFont():New("Arial", 9, 08, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont10 		:= TFont():New("Arial", 9, 10, .T., .T., 5, .T., 5, .T., .F.)
	//Local oFont12 		:= TFont():New("Arial", 9, 12, .T., .T., 5, .T., 5, .T., .F.)
	//Local oFont11 		:= TFont():New("Arial", 9, 11, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont16 		:= TFont():New("Arial", 9, 16, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont14N		:= TFont():New("Arial", 9, 14, .T., .F., 5, .T., 5, .T., .F.)
	//Local oFont22 		:= TFont():New("Arial", 9, 22, .T., .T., 5, .T., 5, .T., .F.)
	Local nValorTit		:= 0
	Local _d
	//Local nPx			:= 4
	//Local nPy			:= 3.9 
	Private _cConv
	Private cNossoN

	// +----------------------------------------------------------+
	// | Indica que foi gerado boleto para pelo menos uma parcela |
	// +----------------------------------------------------------+
	lPreview   := .T.
	cDtVencto  := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
	nValAbate  := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA) 
	nValorTit  := SE1->E1_VALOR - nValAbate
	if _xAjuste
		_xVmulta := (nValorTit * 2)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
		nValorTit += _xVmulta	//soma a multa
		for _d := 1 to (_xVcto - SE1->E1_VENCREA)
			nValorTit += _xVmora //aplica a mora por dia de atraso
		next
	endif
 	cMoedCob	:=	"9" // Moeda de cobranca. 9 = Real
  	
	//+--------------------------------------------------+
	//| Prepara o nosso numero com as devidas validacoes |
	//+--------------------------------------------------+
	DbSelectArea("SEE")
    DbSetOrder(1)
    DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001")
    If !lImpri
       cNossoN    := StrZero(Val(ALLTRIM(SEE->EE_DIRPAG)),10)
       cConvenio  := SEE->EE_CODEMP 
       cNumBoleto := ALLTRIM(SEE->EE_CODEMP)+StrZero(Val(ALLTRIM(SEE->EE_DIRPAG)),10)
        Reclock("SEE",.F.)
          SEE->EE_DIRPAG := StrZero(Val(cNossoN)+1,12)
        MsUnlock()
	    DbSelectArea("SE1")
	    RecLock("SE1",.F.)
	      SE1->E1_NUMBCO  := StrZero(Val(ALLTRIM(cNossoN)),10)
	      SE1->E1_PORTADO := SA6->A6_COD
	      SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	      SE1->E1_CONTA   := SA6->A6_NUMCON   
	    MsUnlock()
	Else
       cNossoN    := StrZero(Val(ALLTRIM(SE1->E1_NUMBCO)),10)
	   cNumBoleto := ALLTRIM(SEE->EE_CODEMP)+StrZero(Val(Alltrim(SE1->E1_NUMBCO)),10) 
       _cConv     := SEE->EE_CODEMP 
	Endif
    cDadosCta := SUBSTR(SA6->A6_AGENCIA, 1, 4)+"-"+SUBSTR(SA6->A6_AGENCIA, 5, 5) + " / " + SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1) + "-" + SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)   
    aDadosBanco  := {SA6->A6_COD, SA6->A6_NREDUZ,;
	                 SUBSTR(SA6->A6_AGENCIA, 1, 4)+"-"+SUBSTR(SA6->A6_AGENCIA, 5, 5),; // [3]Agência
                     SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	     // [4]Conta Corrente
                     SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,;    	  // [5]Dígito da conta corrente
                     "17-019"}
    cNroDoc	:= Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
	cNroDoc	:= STRZERO(Val(cNroDoc),17)
	
    aCBarra  := Ret_cBarra( SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,;
						       Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,;
						       cNroDoc,nValorTit	, "17"	,"9", cDtVencto	)
			
	//+---------------------+
	//| Inicia nova pagina. |
	//+---------------------+
	oPrint:StartPage()

	//+--------------------------+
	//|Layout - Recibo do Sacado |
	//+--------------------------+
	oPrint:Line(80, 265, 100, 265)
	oPrint:Line(80, 310, 100, 310)
	oPrint:Box(100, 025, 128 ,390) 
	oPrint:Box(100, 390, 128, 550) 
	oPrint:Box(128, 025, 148, 390)
	oPrint:Box(128, 390, 148, 550)
	oPrint:Box(148, 025, 168, 088)
	oPrint:Box(148, 088, 168, 175)
	oPrint:Box(148, 175, 168, 213)
	oPrint:Box(148, 213, 168, 265)
	oPrint:Box(148, 265, 168, 390)
	oPrint:Box(148, 390, 168, 550)
	oPrint:Box(168, 025, 188, 088)
	oPrint:Box(168, 088, 188, 125)
	oPrint:Box(168, 125, 188, 163)
	oPrint:Box(168, 163, 188, 265)
	oPrint:Box(168, 265, 188, 390)
	oPrint:Box(168, 390, 188, 550)
	oPrint:Box(188, 390, 208, 550)
	oPrint:Box(188, 025, 288, 390)
	oPrint:Box(208, 390, 228, 550)
	oPrint:Box(228, 390, 248, 550)
	oPrint:Box(248, 390, 268, 550)
	oPrint:Box(268, 390, 288, 550)
	oPrint:Box(288, 025, 330, 550)

	//+-----------------------------+
	//|Layout - Ficha de Compensacao|
	//+-----------------------------+
	oPrint:Line(444, 142, 464, 142)
	oPrint:Line(444, 187, 464, 187)
	oPrint:Box(464, 025, 490, 390)
	oPrint:Box(464, 390, 490, 550)
	oprint:Box(490, 025, 510, 390)
	oprint:Box(490, 390, 510, 550)
	oprint:Box(510, 025, 530, 088)
	oprint:Box(510, 088, 530, 175)
	oprint:Box(510, 175, 530, 213)
	oprint:Box(510, 213, 530, 265)
	oprint:Box(510, 265, 530, 390)
	oprint:Box(510, 390, 530, 550)
	oprint:Box(530, 025, 550, 088)
	oprint:Box(530, 088, 550, 125)
	oprint:Box(530, 125, 550, 163)
	oprint:Box(530, 163, 550, 265)
	oprint:Box(530, 265, 550, 390)
	oprint:Box(530, 390, 550, 550)
	oprint:Box(550, 390, 570, 550)
	oprint:Box(550, 025, 650, 390)
	oprint:Box(570, 390, 590, 550)
	oprint:Box(590, 390, 610, 550)
	oprint:Box(610, 390, 630, 550)
	oprint:Box(630, 390, 650, 550)
	oprint:Box(650, 025, 693, 550)

	//+-----------------------------------+
	//|Inicio Informacoes Primeira Sessao |
	//+-----------------------------------+  
	_M0NOME := "INOVEN COMERCIO INTERNACIONAL LTDA"
	_M0CGC  := "07826504000104"	//"07826504000295"
	
	If File(cBitMapBanco)
		oPrint:SayBitmap(065, 024, cBitMapBanco, 120, 028 )
	Else
		oPrint:Say(096, 027, AllTrim(SA6->A6_NOME), oFont14N)
	EndIf

	oPrint:Say(099, 270, cNumBanco + "-" + cMoedCob, oFont16)
	oPrint:Say(096, 450, "RECIBO DO SACADO", oFont8B ,100)
	oprint:say(107, 027, "Local de Pagamento",ofont8,100)
	//oPrint:Say(116, 027, 'ATÉ O VENCIMENTO, PREFERENCIALMENTE NO BANCO DO BRASIL.',oFont10,100)
	//oPrint:Say(123, 027, 'Após vencimento, somente no Banco do Brasil',oFont8b,100)
	oPrint:Say(123, 027, 'PAGÁVEL EM QUALQUER BANCO',oFont10,100)
	oprint:say(107, 392, "Vencimento",ofont8,100)
	oprint:say(120, 400, DTOC(cDtVencto),ofont10,400,,,1) //Vencimento
	oprint:say(135, 027, "Beneficiário",ofont8,100)
	oprint:say(135, 392, "Agência/Código Beneficiario",ofont8,100)
	oprint:say(145, 030, Upper(Alltrim(_M0NOME))+Space(20)+"CNPJ "+Transform(_M0CGC,"@R 99.999.999/9999-99") ,ofont10,100)
	oprint:say(145, 400, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oprint:say(155, 027, "Data Documento",ofont8,100)
	oprint:say(155, 092, "Número do Documento",ofont8,100)
	oprint:say(155, 180, "Esp.Doc.",ofont8,100)
	oprint:say(155, 218, "Aceite",ofont8,100)
	oprint:say(155, 270, "Data Processamento",ofont8,100)
	oprint:say(155, 392, "Nosso Número",ofont8,100)
	oprint:say(164, 027, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 094, cNumTit+"/"+cParcela,ofont10,100)    //Numero do Documento
	oprint:say(164, 182, "DM",ofont10,100)
	oprint:say(164, 217, "N",ofont10,100)
	oprint:say(164, 273, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 400, cNumBoleto,ofont10,100,,,1)
	oprint:say(175, 027, "N.da Conta/Resp.",ofont8,100)
	oprint:say(175, 093, "Carteira",ofont8,100)
	oprint:say(175, 130, "Espécie",ofont8,100)
	oprint:say(175, 168, "Quantidade",ofont8,100)
	oprint:say(175, 273, "Valor",ofont8,100)
	oprint:say(175, 392, "(=) Valor do Documento",ofont8,100)
	oprint:say(185, 093, cCarteira+"-019",ofont10,100) // carteira
	oprint:say(185, 130, "R$",ofont10,100)                                                                                                                 
	oprint:say(185, 450, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1) //Valor
	oprint:say(195, 027, "Instruções de responsabilidade do Beneficiário. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO.",ofont6,100)
	oPrint:Say(195,392,"(-) Abatimento",ofont8,100)
	oPrint:Say(215,392,"(-) Desconto",ofont8,100)
	oPrint:Say(235,392,"(+) Mora/Multa/Outros Recebimentos",ofont8,100)
	oPrint:Say(255,392,"(+) Juros",ofont8,100)
	oPrint:Say(275,392,"(=) Valor Cobrado",ofont8,100)
	oPrint:Say  (205, 027, "PAGAR SOMENTE COM O BOLETO.", oFont10)
	oPrint:Say  (215, 027, "Protestar no quinto dia util apos o vencimento.", oFont10)  
	if !_xAjuste
		_xVmulta := (nValorTit * 2)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
	endif
	oPrint:Say  (225, 027, "APOS VENCIMENTO, MULTA DE R$ "+TransForm(_xVmulta, "@E 99,999.99")+"  MORA/DIA R$ "+TransForm(_xVmora, "@E 99,999.99"), oFont10)
	oPrint:Say  (235, 027, cMensBol4, oFont10)
	oPrint:say(294, 027, "Sacado", ofont8, 100)

	cCGC := ''
	If Len(Alltrim(SA1->A1_CGC)) == 14
	   cCGC := "    Cnpj "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
	Else
	   cCGC := "    CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99")
	Endif

	oPrint:say(302, 027, AllTrim(SA1->A1_NOME)+'  -  ' + Alltrim(SA1->A1_COD) + cCGC, ofont8B, 100)
	oPrint:say(294, 376, "Autenticação Mecânica", ofont8, 100)    
	/*If Len(Alltrim(SA1->A1_CGC)) == 14
	   oPrint:say(302, 300, "Cnpj "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	   oPrint:say(302, 300, "CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
	Endif*/  
	oPrint:say(311, 027, Alltrim(SA1->A1_END) + IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:say(320, 027, Alltrim( Transform( SA1->A1_CEP ,"@R 99999-999" ) ) + '   -   ' + Alltrim(SA1->A1_MUN) + '   -   ' + Alltrim(SA1->A1_EST), oFont8B, 100 )
	oPrint:Say(328, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(328, 375, 'Cód. Baixa', ofont8, 100)
	oPrint:say(395, 000, Replicate("-",1800), ofont8, 100)

	//+----------------------------------+
	//|Inicio Informacoes Segunda Sessao |
	//+----------------------------------+
	If File(cBitMapBanco)
		oPrint:SayBitmap(429, 024, cBitMapBanco, 120, 028 )
	Else
		oPrint:Say(461, 027, AllTrim(SA6->A6_NOME), oFont14N)
	EndIf
	oPrint:say(463, 147, cNumBanco + "-" + cMoedCob, oFont16, 100)
	oPrint:Say(461, 190, aCBarra[2], oFont14N, 100 )                     
	oPrint:say(471, 027, "Local de Pagamento",ofont8,100)
	oPrint:say(471, 392, "Vencimento",ofont8,100)
	//oPrint:say(480, 027, "ATÉ O VENCIMENTO, PREFERENCIALMENTE NO BANCO DO BRASIL.",ofont10,100)
	//oPrint:say(488, 027, "Após vencimento, somente no Banco do Brasil",ofont8b,100)
	oPrint:say(488, 027, "PAGÁVEL EM QUALQUER BANCO",ofont8b,100)
	oPrint:say(480, 400, Dtoc(cDtVencto), ofont10, 100,,,1)
	oPrint:say(497, 027, "Beneficiário",ofont8,100)
	oPrint:say(497, 392, "Agência/Código Beneficiário",ofont8,100)
	oprint:say(507, 030, Upper(Alltrim(_M0NOME))+Space(20)+"CNPJ "+Transform(_M0CGC,"@R 99.999.999/9999-99") ,ofont10,100)
	oprint:say(507, 400, cDadosCta,ofont10,116,,,1) //Agencia/Codigo do Cedente
	oPrint:say(518, 027, "Data Documento",ofont8,100)
	oPrint:say(518, 092, "Número do Documento",ofont8,100)
	oPrint:say(518, 179, "Esp.Doc.",ofont8,100)
	oPrint:say(518, 218, "Aceite",ofont8,100)
	oPrint:say(518, 270, "Data Processamento",ofont8,100)
	oPrint:say(518, 392, "Nosso Número",ofont8,100)
	oPrint:say(527, 027, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(527, 093, cNumTit+"/"+cParcela,ofont10,100)    //Numero do Documento
	oPrint:say(527, 180, "DM",ofont10,100)
	oPrint:say(527, 218, "N",ofont10,100)
	oPrint:say(527, 270, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(527, 400, cNumBoleto,ofont10,100,,,1)
	oPrint:say(538, 027, "N. da Conta/Resp.",ofont8,100)
	oPrint:say(538, 093, "Carteira",ofont8,100)
	oPrint:say(538, 130, "Espécie",ofont8,100)
	oPrint:say(538, 168, "Quantidade",ofont8,100)
	oPrint:say(538, 270, "Valor",ofont8,100)
	oPrint:say(538, 392, "(=) Valor do Documento",ofont8,100)
	oPrint:say(548, 093, cCarteira+"-019",ofont10,100) // carteira
	oPrint:say(548, 130, "R$",ofont10,100)
	oPrint:say(548, 450, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1)           //Valor
	oPrint:Say(558, 392, "(-) Abatimento",ofont8,100)
	oPrint:Say(578, 392, "(-) Desconto",ofont8,100)
	oPrint:Say(598, 392, "(+) Mora/Multa/Outros Recebimentos",ofont8,100)
	oPrint:Say(618, 392, "(+) Juros",ofont8,100)
	oPrint:Say(638, 392, "(=) Valor Cobrado",ofont8,100)
	oprint:say(558, 027, "Instruções de responsabilidade do Beneficiário. Qualquer dúvida sobre este boleto, contate o BENEFICIÁRIO.",ofont6,100) 
	oPrint:Say  (568, 027, "PAGAR SOMENTE COM O BOLETO.", oFont10)
	oPrint:Say  (578, 027, "Protestar no quinto dia util apos o vencimento.", oFont10)
	if !_xAjuste
		_xVmulta := (nValorTit * 2)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
	endif
	oPrint:Say  (588, 027, "APOS VENCIMENTO, MULTA DE R$ "+TransForm(_xVmulta, "@E 99,999.99")+"  MORA/DIA R$ "+TransForm(_xVmora, "@E 99,999.99"), oFont10)
	oPrint:Say  (598, 027, cMensBol4, oFont10)
	oPrint:say(657, 027, "Sacado", ofont8, 100)

	cCGC := ''
	If Len(Alltrim(SA1->A1_CGC)) == 14
	   cCGC := "    Cnpj "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
	Else
	   cCGC := "    CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99")
	Endif

	oPrint:say(665, 027, AllTrim(SA1->A1_NOME)+'  -  ' + SA1->A1_COD + cCGC, ofont8B, 100)
	oPrint:say(657, 376, "Autenticação Mecânica", ofont8, 100)
	/*If Len(Alltrim(SA1->A1_CGC)) == 14
	   oPrint:say(665, 300, "Cnpj "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	   oPrint:say(665, 300, "CPF. "+Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
	Endif*/
    oPrint:say(674, 027, Alltrim(SA1->A1_END)+IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:say(683, 027, Alltrim( Transform( SA1->A1_CEP ,"@R 99999-999" ) ) + '   -   ' + Alltrim(SA1->A1_MUN) + '   -   ' + Alltrim(SA1->A1_EST), oFont8B, 100 )
	oPrint:Say(690, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(690, 375, 'Cód. Baixa', ofont8, 100)
	oPrint:Say(702, 375, 'Autenticação Mecânica - Ficha de Compensação', ofont8, 100)
	//+-------------------------------+
	//|Impressão do  codigo de barras |
	//+-------------------------------+
	oPrint:FWMSBAR("INT25" ,62 ,3 ,aCBarra[1] ,oPrint,.F.,,.T.,0.025,1.2,,,,.F.,,,)
	oPrint:EndPage()

	aAdd(aInfMail,cNumTit) // Numero do titulo utilizado no boleto
	aAdd(aInfMail,SE1->E1_PREFIXO) // Serie do titulo
	aAdd(aInfMail,cParcela) // Parcela que foi impressa
	aAdd(aInfMail,_M0NOME) // Nome da Beneficiario
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³CALC_Dp   ºAutor  ³Microsiga           º Data ³  02/13/04   º±±      
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do digito do nosso numero do                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CALC_li(cVariavel)
//Local Auxi := 0, sumdig := 0
Local aBasecalc := { 4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2,9,8,7,6,5,4,3,2}
Local nMult     := 0
Local nD        := 0      
Local nE        := 0      
Local aMult     := {}
Local nDigbar   := 0
Local nSoma     := 0
cbase           := cVariavel

For nD := 1 To Len(cbase)
		nMult := Val(Subs(cbase,nD,1) ) * aBasecalc[nD]
		Aadd(aMult,StrZero(nMult,2) )
next nD   
	
nSoma := 0 
nAlgarism1 := 0 
nAlgarism2 := 0 
For nE := 1 To Len(aMult)                         
    	nAlgarism1 := Val(aMult[nE])
		nSoma      := nSoma + nAlgarism1 // + nAlgarism2
Next nC
nDigbar := 11 - Mod(nSoma,11)

IF nDigbar == 0  .or. nDigbar == 1 .or. nDigbar == 10 .or. nDigbar == 11   
   nDigbar := 1 
Endif
  
  
Return(str(nDigbar,1,0))         



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³DIGIT0001  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para calculo da linha digitavel do Banco do Brasil          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function DIGIT01(cVariavel,nOp)

//Local Auxi := 0, sumdig := 0Local _aArea     := GetArea()
local aMultiplic := {}  // Resultado das Multiplicacoes de cada algarismo
//local _cRet      := " "
local aBaseNum   := {}
local cDigVer    := 0 
local nB         := 0  
local nC         := 0 
local nSum       := 0 
//local _cNossoNum := ""
//local _cCalcdig  := ""
cbase  := cVariavel 
IF nOp == 1 
  aBaseNum   := { 2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
ELSE
  aBaseNum   := { 1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1}
ENDIF

For nB := 1 To Len(cbase)
		
		nMultiplic := Val(Subs(cbase,nB,1) ) * aBaseNum[nB]
		Aadd(aMultiplic,StrZero(nMultiplic,2) )
		
next nB
For nC := 1 To Len(aMultiplic)
		nAlgarism1 := Val(Subs(aMultiplic[nC],1,1) )
		nAlgarism2 := Val(Subs(aMultiplic[nC],2,1) )
		nSum       := nSum + nAlgarism1 + nAlgarism2
Next nC

cDigVer := 10 - Mod(nSum,10)

IF cDigVer == 10 
   cDigVer := 0 
Endif

Return(str(cDigVer,1,0))               


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³FATOR		ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Calculo do FATOR1  de vencimento para linha digitavel.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function FatorA(cDtVencto)
If Len(ALLTRIM(SUBSTR(DTOC(cDtVencto),7,4))) = 4
	cData := SUBSTR(DTOC(cDtVencto),7,4)+SUBSTR(DTOC(cDtVencto),4,2)+SUBSTR(DTOC(cDtVencto),1,2)
Else
	cData := "20"+SUBSTR(DTOC(cDtVencto),7,2)+SUBSTR(DTOC(cDtVencto),4,2)+SUBSTR(DTOC(cDtVencto),1,2)
EndIf
cFator := STR(1000+(STOD(cData)-STOD("20000703")),4)
//cFator := STR(1000+(SE1->E1_VENCREA-STOD("20000703")),4)
Return(cFator)
                                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³RetDados  ºAutor  ³Microsiga           º Data ³  02/13/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera SE1                        					          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLETOS                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Ret_cBarra(	cPrefixo	,cNumero	,cParcela	,cTipo	,;
						cBanco		,cAgencia	,cConta		,cDacCC	,;
						cNroDoc		,nValor		,cCart		,cMoeda, cDtVencto	)


Local cNosso		:= ""
//Local cDigNosso	    := ""
Local NNUM			:= ""
Local cCampoL		:= ""
Local cFatorValor	:= ""
Local cLivre		:= ""
Local cDigBarra     := ""
Local cBarra		:= ""
Local cParte1		:= ""
Local cDig1			:= ""
Local cParte2		:= ""
Local cDig2			:= ""
Local cParte3		:= ""
Local cDig3			:= ""
Local cParte4		:= ""
Local cParte5		:= ""
Local cDigital		:= ""
Local aRet			:= {}

cAgencia:=STRZERO(Val(cAgencia),4)
cCart := "17"		
cNosso := ""
nNumeBol  := cNossoN
cConvenio := Alltrim(SEE->EE_CODEMP) 

   nNum   := ALLTRIM(SEE->EE_CODEMP)+ALLTRIM(nNumeBol)
   cNosso := ALLTRIM(SEE->EE_CODEMP)+ALLTRIM(nNumeBol)

If nValor > 0
	cFatorValor  := u_fatorA(cDtVencto)+Strzero(nValor*100,10)
Else
	cFatorValor  := u_fatorA(cDtVencto)+strzero(SE1->E1_VALOR*100,10)
EndIf
                          
DO CASE 
  CASE LEN(ALLTRIM(cConvenio)) == 6
     cCampoL := cConvenio+alltrim(NNUM)+"21"
  CASE LEN(ALLTRIM(cConvenio)) == 7
     cCampoL := "000000"+alltrim(NNUM)+cCart   
ENDCASE
  
cLivre := cBanco+cMoeda+cFatorValor+cCampoL

// campo do codigo de barra
cDigBarra := U_CALC_LI( cLivre )

cBarra    := Substr(cLivre,1,4)+cDigBarra+cFatorValor+Substr(cCampoL,1,25)

// composicao da linha digitavel
cParte1  := cBanco+cMoeda
cParte1  += SUBSTR(cBarra,20,5) //SUBSTR(cCampoL,20,5) //SUBSTR(cCampoL,1,5)
cDig1    := U_DIGIT01( cParte1,1 )
cParte2  := SUBSTR(cBarra,25,10 ) //SUBSTR(cCampoL,6,10)
cDig2    := U_DIGIT01( cParte2,2 )
cParte3  := SUBSTR(cBarra,35,10) //SUBSTR(cCampoL,6,29)//10
cDig3    := U_DIGIT01( cParte3,2 )
cParte4  := cDigBarra //" "+cDigBarra+" "
cParte5  := cFatorValor

cDigital := substr(cParte1,1,5)+"."+substr(cparte1,6,4)+cDig1+" "+;
			substr(cParte2,1,5)+"."+substr(cparte2,6,5)+cDig2+" "+;
			substr(cParte3,1,5)+"."+substr(cparte3,6,5)+cDig3+" "+;
			cParte4+" "+;                                              
			cParte5


Aadd(aRet,cBarra)
Aadd(aRet,cDigital)
Aadd(aRet,cNosso)		

Return aRet   


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
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0

	For nX:= 1 To Len(cNossoNum)
		aAdd(aDados1,Val(SubStr(cNossoNum,nX,1)))
	Next nX

	For nX:= 1 To Len(aDados1)
		aAdd(aResult,aPesos[nX]*aDados1[nX])	
	Next nX

	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next

	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX

	nResult2	:= Mod(nResult1,10)
	nResult3	:= 10 - nResult2

Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

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
