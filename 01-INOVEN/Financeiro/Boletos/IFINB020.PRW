#Include "Protheus.Ch"
#Include "TopConn.Ch"                                           
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"

#DEFINE	 TAM_A4 9			//A4     	210mm x 297mm  620 x 876

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBOLBRAD   บAutor  ณGoOne COnsultoria   บ Data ณ  07/06/2021 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Modelo de Boleto Padrใo                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//DESENVOLVIDO POR INOVEN

User Function IFINB020(_xNum1,_xNum2,_xPrefixo,_lBanco,_xMail, _xMsgMail,_xAjuste,_xVcto)
	Local cV12			:= GetRpoRelease()

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
	Private cJuros		:= ""
	Private cMensBol1	:= "SUJEITO A PROTESTO CASO NAO PAGO NO VENCIMENTO."
	Private cMensBol2	:= "APOS O VENCIMENTO COBRAR JUROS DE.....R$ "
	Private cMensBol3	:= ""
	Private cMensBol4	:= ""        
	Private lAuto		:= .F.                                              
	Private aInfMail	:= {}
	Private lReimp		:= .F.
	Private cNumBol		:= ""
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPRIMEบAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                            
Static Function BRPIMPRIME(_xDoc1,_xDoc2,_xSer,_xMail,_xMsgMail,_xAjuste,_xVcto)
	//Local nX					:= 0
	Local oPrint				:= Nil
	Local lAdjustToLegacy		:= .F.
	Local lDisableSetup			:= .T.
	Local cDirClient			:= iif(!IsInCallStack("U_ITECX110"), GetTempPath(), "")
	Local cFile					:= ""	//"Boleto_Inoven"+Trim(SE1->E1_NUM)+Trim(SE1->E1_PARCELA)+DTOS(dDataBase)+Replace(Time(),':','')+".PDF" 
	Local cDirExp				:= "\spool\" // GetTempPath()
	//Local cConout				:= ""
    Private lImpri              := .F.    
	Private _xBCOdia        	:= Padr(Getmv("MV_BCODIA"),3)
	Private _xAGEdia        	:= Padr(Getmv("MV_AGEDIA"),5)
	Private _xCONdia        	:= Padr(Getmv("MV_CONDIA"),10)
    
    If lPergu .and. !_xAjuste
       If Select("TRB1") > 0
	      TRB1->(DbCloseArea())
       EndIf
	   cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
	   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO      = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_PORTADO     = '237' " + CRLF 
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

	if !IsInCallStack("U_ITECX110")
		oPrint:=FWMSPrinter():New(cFile, IMP_PDF, lAdjustToLegacy,cDirExp, lDisableSetup, , , , .T., , .F., )      
		oprint:CPATHPDF := cDirClient
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
		//->> Setando a private lImpri como falso, que ้ o inicializador de situa็ใo.
		//->> Caso ele nใo sofra essa declara็ใo, ele pode estar setado de maneira errada
		//->> e nใo gerar o nosso numero conforme as regras de boletos.		
		lImpri := .F.
  	   
  	   IncProc("Titulo " + TRB1->E1_NUM + " Parcela " + TRB1->E1_PARCELA)
		//+--------------------------------------------------------+
		//|Posiciona no registro atraves do recno filtrado na query|
		//+--------------------------------------------------------+
		SE1->( DbGoTo(TRB1->E1_NUMREC))
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
		If lPergu 
		   If !( AllTrim(SA6->A6_COD) $ "237" )
		      MsgAlert("A impressใo de boletos nใo ้ valida para o banco "+AllTrim(SA6->A6_COD),"Aten็ใo")
		   Endif
		Endif
		If !Empty(TRB1->E1_NUMBCO)		   
		   //->> Marcelo Celi - Alfa - 21/08/2018
		   //->> Vai deixar de perguntar se deseja reimprimir, considerando que se o usuario chegou ate aqui
		   //->> ele realmente deseja reimprimir o documento.
		   /*
		   MsgAlert("Aten็ใo Esse Tํtulo Jแ Foi IMPRESSO !!! " + AllTrim(TRB1->E1_PREFIXO)+AllTrim(TRB1->E1_NUM),"Aten็ใo")
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณSYMM                บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPBOLIMP(oPrint,_xAjuste,_xVcto)
	Local cCarteira		:= "09"
	Local cValorTit		:= ""
	Local cFatorVcto	:= ""
	Local cNumBanco		:= AllTrim(SA6->A6_COD)
	Local cAgencia		:= Alltrim(SA6->A6_AGENCIA)
	Local cDigAgen		:= Alltrim(SA6->A6_DVAGE)
	Local cNumConta		:= Alltrim(SubStr(SA6->A6_NUMCON,1,7))
	Local cDigConta		:= Alltrim(SA6->A6_DVCTA)	//Alltrim(SubStr(SA6->A6_NUMCON,6,1))
	Local cDtVencto		:= Ctod("")
	Local cBitMapBanco	:= GetSrvProfString("Startpath","")+"\logo_bradesco.bmp"
	//Local cNumTit			:= Iif(!Empty(SE1->E1_NFELETR), Alltrim(SE1->E1_NFELETR), StrZero(Val(SE1->E1_NUM),6))
	Local cNumTit			:= Iif(!Empty(SE1->E1_NFELETR), Alltrim(SE1->E1_NFELETR), StrZero(Val(SE1->E1_NUM),9))
	Local cParcela		:= IIF(Empty(SE1->E1_PARCELA),"0",SE1->E1_PARCELA)
	Local oFont6  		:= TFont():New("Arial", 9, 06, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8  		:= TFont():New("Arial", 9, 08, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont8B  		:= TFont():New("Arial", 9, 08, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont10 		:= TFont():New("Arial", 9, 10, .T., .T., 5, .T., 5, .T., .F.)
	//Local oFont12 		:= TFont():New("Arial", 9, 12, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont11 		:= TFont():New("Arial", 9, 11, .T., .T., 5, .T., 5, .T., .F.)
	Local oFont14N		:= TFont():New("Arial", 9, 14, .T., .F., 5, .T., 5, .T., .F.)
	Local oFont22 		:= TFont():New("Arial", 9, 22, .T., .T., 5, .T., 5, .T., .F.)
	Local nValorTit		:= 0
	Local _d

	// +----------------------------------------------------------+
	// | Indica que foi gerado boleto para pelo menos uma parcela |
	// +----------------------------------------------------------+
	lPreview := .T.
	cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
	nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	if _xAjuste
		_xVmulta := (nValorTit * 2)/100
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
	cDigBanco	:=	"2"
    //+--------------------------------------------------+
	//| Prepara o nosso numero com as devidas validacoes |
	//+--------------------------------------------------+
    If !lImpri
	   DbSelectArea("SEE")
       DbSetOrder(1)
       DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001")
       cNumBoleto := StrZero(Val(Alltrim(SEE->EE_DIRPAG)),11)
	   //cDigitao	  := IIF(lReimp,SubStr(cNumBoleto,Len(cNumBoleto),1),BRPDIG2( "090" + StrZero(Val(cNumBoleto),10),cNumBoleto ))
	   cDigitao	  := BRPDIG2( "09" + StrZero(Val(cNumBoleto),11),cNumBoleto )
       Reclock("SEE",.F.)
         SEE->EE_DIRPAG := StrZero(Val(cNumBoleto)+1,11)
       MsUnlock()
	   DbSelectArea("SE1")
	   RecLock("SE1",.F.)
	     SE1->E1_NUMBCO  := StrZero(Val(ALLTRIM(cNumBoleto)),11) + cDigitao
	     SE1->E1_PORTADO := SA6->A6_COD
	     SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	     SE1->E1_CONTA   := SA6->A6_NUMCON   
	   MsUnlock()
	Else
	   cNumBoleto := substr(SE1->E1_NUMBCO,1,11) 
	   cDigitao	  := substr(SE1->E1_NUMBCO,12,1) 
	Endif

	cDadosCta	:=	cAgencia + "-" + cDigAgen + "/" + cNumConta + "-" + cDigConta          	

	cDigCodBar	:=	BRPDVBAR(cNumBanco+"9"+cFatorVcto+cValorTit+cAgencia+cCarteira+cNumBoleto+cNumConta+"0")
	cCodBar2	:= cNumBanco + "9" + cDigCodBar + cFatorVcto + StrZero(Int(SE1->E1_VALOR*100),10)+; 
                   cAgencia + cCarteira + cNumBoleto + cNumConta + "0"

	cDigblc1	:=	BRPDIG1(cNumBanco + "9" + cAgencia + substr(cCarteira,1,1) )
	cBloco1		:=	Transform(cNumBanco + "9" + cAgencia + substr(cCarteira,1,1)+cDigblc1,"@R 99999.99999")
	cDigblc2	:=	BRPDIG1(substr(cCarteira,2,1) + substr(cNumBoleto,1,9))
	cBloco2		:= 	Transform(substr(cCarteira,2,1) + substr(cNumBoleto,1,9) + cDigblc2,"@R 99999.999999")
	cDigblc3	:=	BRPDIG1(substr(cNumBoleto,10,2) + cNumConta + "0")
	cBloco3		:=	Transform(substr(cNumBoleto,10,2) + cNumConta + "0" + cDigblc3,"@R 99999.999999")
	cBloco4		:=	cFatorVcto + cValorTit        
	cCodBarras	:=	cBloco1 +" "+ cBloco2 +" "+ cBloco3 +" "+ cDigCodBar +" "+ cBloco4

	//+---------------------+
	//| Inicia nova pagina. |
	//+---------------------+
	oPrint:StartPage()

	//+--------------------------+
	//|Layout - Recibo do Pagador|
	//+--------------------------+
	oPrint:Box(100, 025, 128 ,390) 
	oPrint:Box(100, 390, 128, 550) 
	oPrint:box(128, 025, 148, 390)
	oPrint:box(128, 390, 148, 550)
	oPrint:box(148, 025, 168, 088)
	oPrint:box(148, 088, 168, 175)
	oPrint:box(148, 175, 168, 213)
	oPrint:box(148, 213, 168, 265)
	oPrint:box(148, 265, 168, 390)
	oPrint:box(148, 390, 168, 550)
	oPrint:box(168, 025, 188, 088)
	oPrint:box(168, 088, 188, 125)
	oPrint:box(168, 125, 188, 163)
	oPrint:box(168, 163, 188, 265)
	oPrint:box(168, 265, 188, 390)
	oPrint:box(168, 390, 188, 550)
	oPrint:box(188, 390, 208, 550)
	oPrint:box(188, 025, 288, 390)
	oPrint:box(208, 390, 228, 550)
	oPrint:box(228, 390, 248, 550)
	oPrint:box(248, 390, 268, 550)
	oPrint:box(268, 390, 288, 550)
	oPrint:box(288, 025, 330, 550)

	//+----------------+
	//|Layout - Boleto |
	//+----------------+
	//oPrint:Box(364, 025, 390, 390)
	//oPrint:Box(364, 390, 390, 550)
	//oprint:box(390, 025, 410, 390)
	//oprint:box(390, 390, 410, 550)
	oPrint:Box(364, 025, 383, 390)
	oPrint:Box(364, 390, 383, 550)
	oprint:box(383, 025, 410, 390)
	oprint:box(383, 390, 410, 550)

	oprint:box(410, 025, 430, 088)
	oprint:box(410, 088, 430, 175)
	oprint:box(410, 175, 430, 213)
	oprint:box(410, 213, 430, 265)
	oprint:box(410, 265, 430, 390)
	oprint:box(410, 390, 430, 550)
	oprint:box(430, 025, 450, 088)
	oprint:box(430, 088, 450, 125)
	oprint:box(430, 125, 450, 163)
	oprint:box(430, 163, 450, 265)
	oprint:box(430, 265, 450, 390)
	oprint:box(430, 390, 450, 550)
	oprint:box(450, 390, 470, 550)
	oprint:box(450, 025, 550, 390)
	oprint:box(470, 390, 490, 550)
	oprint:box(490, 390, 510, 550)
	oprint:box(510, 390, 530, 550)
	oprint:box(530, 390, 550, 550)
	oprint:box(550, 025, 593, 550)
	
	//+-----------------------------------+
	//|Inicio Informacoes Primeira Sessao |
	//+-----------------------------------+
	_M0NOME := "INOVEN COMERCIO INTERNACIONAL LTDA"
	_M0CGC  := "07826504000104"		//"07826504000295"    
	_M0END  := "RUA JOAO THOMAZ PINTO, 1570"
	_M0BAI  := "CANHANDUBA"
	_M0CID  := "ITAJAI"
	_M0EST  := "SC"
	_M0CEP  := "88313045"

	If File(cBitMapBanco)
		oPrint:SayBitmap(067, 020, cBitMapBanco, 120, 028 )
	Else
		oPrint:Say(095, 030, SA6->A6_NOME, oFont11)
	EndIf                    
	oPrint:Say(095, 145, cNumBanco + "-" + cDigBanco, oFont22)
	oPrint:Say(095, 450, "RECIBO DO PAGADOR", oFont10 ,100)    
	oprint:say(107, 027, "Beneficiario",ofont8,100)
	If Len(Alltrim(SM0->M0_CGC)) == 14 
   	oPrint:Say(116, 027, _M0NOME + ' CNPJ: ' + TransForm(_M0CGC, "@R 99.999.999/9999-99"),oFont10,100)
    Else
   	oPrint:Say(116, 027, _M0NOME + ' CPF.: ' + TransForm(_M0CGC, "@R 999.999.999-99"),oFont10,100)
    Endif
	oprint:say(107, 392, "Vencimento",ofont8,100)
	oprint:say(120, 485, DTOC(cDtVencto),ofont10,400,,,1)                     //Vencimento
	oprint:say(135, 027, "Endere็o Beneficiario\Sacador Avalista",ofont8,100)
	oprint:say(135, 392, "Ag๊cia/C๓digo Beneficiario",ofont8,100)
	oprint:say(145, 030, Upper(Alltrim(_M0END) + " " + Alltrim(_M0BAI) + " " + Alltrim(_M0CID) + " - " + Alltrim(_M0EST) + " " + Alltrim(Transform(_M0CEP,"@R 99999-999"))) ,ofont10,100) //Endere? Beneficiario...
	oprint:say(145, 480, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oprint:say(155, 027, "Data Documento",ofont8,100)
	oprint:say(155, 093, "N๚mero do Documento",ofont8,100)
	oprint:say(155, 180, "Esp.Doc.",ofont8,100)
	oprint:say(155, 218, "Aceite",ofont8,100)
	oprint:say(155, 270, "Data Processamento",ofont8,100)
	oprint:say(155, 392, "Carteira/Nosso N๚mero",ofont8,100)
	oprint:say(164, 027, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 093, cNumTit+"-"+cParcela,ofont10,100)    //Numero do Documento
	oprint:say(164, 180, "DM",ofont10,100)
	oprint:say(164, 215, "N",ofont10,100)
	oprint:say(164, 273, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 475, cCarteira + "/" + cNumBoleto + "-" + cDigitao,ofont10,100,,,1)
	oprint:say(175, 027, "Uso do Banco",ofont8,100)
	oprint:say(175, 093, "Carteira",ofont8,100)
	oprint:say(175, 130, "Esp้cie",ofont8,100)
	oprint:say(175, 168, "Quantidade",ofont8,100)
	oprint:say(175, 273, "Valor",ofont8,100)
	oprint:say(175, 392, "(=) Valor do Documento",ofont8,100)
	oprint:say(185, 093, cCarteira,ofont10,100)                              // carteira
	oprint:say(185, 130, "R$",ofont10,100)                                                                                                                 
	oprint:say(185, 485, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1)           //Valor
	oprint:say(195, 027, "Instru็๕es de responsabilidade do Beneficiแrio. Qualquer d๚vida sobre este boleto, contate o BENEFICIมRIO.",ofont6,100)
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
	oPrint:say(293, 027, "Pagador", ofont8, 100)
	oPrint:say(300, 027, AllTrim(SA1->A1_NOME)+'  -  ' + SA1->A1_COD, ofont8B, 100)
	If Len(Alltrim(SA1->A1_CGC)) == 14
	oPrint:say(300, 375, 'CNPJ:' + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	oPrint:say(300, 375, 'CPF.:' + Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
    Endif
	oPrint:say(310, 027, SA1->A1_END+IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:say(320, 027, Alltrim( Transform( SA1->A1_CEP ,"@R 99999-999" ) ) + '   -   ' + Alltrim(SA1->A1_MUN) + '   -   ' + Alltrim(SA1->A1_EST), oFont8B, 100 )
	oPrint:Say(328, 027, 'Sacador/Avalista'+" " + SM0->M0_NOMECOM,ofont8,500)
    If Len(Alltrim(SM0->M0_CGC)) == 14
	oPrint:Say(328, 375, 'CNPJ: '+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), ofont8, 100)
	Else
	oPrint:Say(328, 375, 'CPF.: '+ Transform(SM0->M0_CGC,"@R 999.999.999-99"), ofont8, 100)
	Endif
	oPrint:Say(337, 375, 'Autentica็ใo Mecโnica', ofont8, 100) 

	oPrint:say(345, 000, Replicate("-",1800), ofont8, 100)

	//+----------------------------------+
	//|Inicio Informacoes Segunda Sessao |
	//+----------------------------------+
	If File(cBitMapBanco)
		oPrint:SayBitmap(345, 030, cBitMapItau, 018, 018 )
	Else
	    oPrint:say(360, 030, SA6->A6_NOME, ofont11, 100)
	EndIf                    
	oPrint:say(360, 137, cNumBanco + "-" + cDigBanco, ofont22, 100)
	oPrint:Say(360, 190, cCodBarras, oFont14N, 100 )                     
	oPrint:say(370, 027, "Local de Pagamento",ofont8,100)
	oPrint:say(370, 392, "Vencimento",ofont8,100)
	//oPrint:say(383, 027, "Pagแvel preferencialmente na Rede Bradesco ou Bradesco Expresso",ofont10,100)
	oPrint:say(380, 027, "Pagแvel preferencialmente na Rede Bradesco ou Bradesco Expresso",ofont10,100)
	//oPrint:say(385, 490, Dtoc(SE1->E1_VENCTO), ofont10, 100,,,1)                 
	oPrint:say(380, 490, Dtoc(cDtVencto), ofont10, 100,,,1)                 
	//oPrint:say(397, 027, "Beneficiแrio",ofont8,100)
	//oPrint:say(397, 392, "Ag๊ncia/C๓digo Beneficiแrio",ofont8,100)
	oPrint:say(390, 027, "Beneficiแrio",ofont8,100)
	oPrint:say(390, 392, "Ag๊ncia/C๓digo Beneficiแrio",ofont8,100)

	If Len(Alltrim(SM0->M0_CGC)) == 14 
   		oPrint:Say(398, 030, _M0NOME + ' - CNPJ: ' + TransForm(_M0CGC, "@R 99.999.999/9999-99"),oFont10,100)
    Else
   		oPrint:Say(398, 030, _M0NOME + ' - CPF.: ' + TransForm(_M0CGC, "@R 999.999.999-99"),oFont10,100)
    Endif

	oprint:say(407, 030, Upper(Alltrim(_M0END) + " " + Alltrim(_M0BAI) + " " + Alltrim(_M0CID) + " - " + Alltrim(_M0EST) + " " + Alltrim(Transform(_M0CEP,"@R 99999-999"))) ,ofont8B,100) //Endere? Beneficiario...
	oprint:say(407, 480, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oPrint:say(418, 027, "Data Documento",ofont8,100)
	oPrint:say(418, 093, "N๚mero do Documento",ofont8,100)
	oPrint:say(418, 180, "Esp.Doc.",ofont8,100)
	oPrint:say(418, 218, "Aceite",ofont8,100)
	oPrint:say(418, 270, "Data Processamento",ofont8,100)
	oPrint:say(418, 392, "Carteira/Nosso N๚mero",ofont8,100)
	oPrint:say(427, 027, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(427, 093, cNumTit+"-"+cParcela,ofont10,100)    //Numero do Documento
	oPrint:say(427, 180, "DM",ofont10,100)
	oPrint:say(427, 218, "N",ofont10,100)
	oPrint:say(427, 270, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(427, 475, cCarteira + "/" + cNumBoleto + "-" + cDigitao,ofont10,100,,,1)
	oPrint:say(438, 027, "Uso do Banco",ofont8,100)
	oPrint:say(438, 093, "Carteira",ofont8,100)
	oPrint:say(438, 130, "Esp้cie",ofont8,100)
	oPrint:say(438, 168, "Quantidade",ofont8,100)
	oPrint:say(438, 270, "Valor",ofont8,100)
	oPrint:say(438, 392, "(=) Valor do Documento",ofont8,100)
	oPrint:say(448, 093, cCARTEIRA,ofont10,100)                              // carteira
	oPrint:say(448, 130, "R$",ofont10,100)
	oPrint:say(448, 490, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1)           //Valor
	oPrint:Say(458, 392, "(-) Abatimento",ofont8,100)
	oPrint:Say(478, 392, "(-) Desconto",ofont8,100)
	oPrint:Say(498, 392, "(+) Mora/Multa/Outros Recebimentos",ofont8,100)
	oPrint:Say(518, 392, "(+) Juros",ofont8,100)
	oPrint:Say(538, 392, "(=) Valor Cobrado",ofont8,100)
	oprint:say(458, 027, "Instru็๕es de responsabilidade do Beneficiแrio. Qualquer d๚vida sobre este boleto, contate o BENEFICIมRIO.",ofont6,100) 
	oPrint:Say  (468, 027, "PAGAR SOMENTE COM O BOLETO.", oFont10)
	oPrint:Say  (478, 027, "Protestar no quinto dia util apos o vencimento."   , oFont10)
	if !_xAjuste
		_xVmulta := (nValorTit * 2)/100
		_xVmora  := (((nValorTit * 1)/100)/30)
	endif
	oPrint:Say  (488, 027, "APOS VENCIMENTO, MULTA DE R$ "+TransForm(_xVmulta, "@E 99,999.99")+"  MORA/DIA R$ "+TransForm(_xVmora, "@E 99,999.99"), oFont10)
	oPrint:Say  (498, 027, cMensBol4, oFont10)
	oPrint:say(556, 027, "Pagador", ofont8, 100)
	oPrint:say(563, 027, AllTrim(SA1->A1_NOME)+'  -  ' + SA1->A1_COD, ofont8B, 100)
	If Len(Alltrim(SA1->A1_CGC)) == 14
	oPrint:say(563, 375, 'CNPJ:' + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),ofont8B, 100)
	Else
	oPrint:say(563, 375, 'CPF.:' + Transform(SA1->A1_CGC,"@R 999.999.999-99"),ofont8B, 100)
	Endif
	oPrint:say(573, 027, SA1->A1_END+IIF(!EMPTY(SA1->A1_BAIRRO),'   -   ' + AllTrim(SA1->A1_BAIRRO),' '), ofont8B, 100)
	oPrint:say(583, 027, Alltrim( Transform( SA1->A1_CEP ,"@R 99999-999" ) ) + '   -   ' + Alltrim(SA1->A1_MUN) + '   -   ' + Alltrim(SA1->A1_EST), oFont8B, 100 )
	oPrint:Say(590, 027, 'Sacador/Avalista'+" " + _M0NOME,ofont8,500)
    If Len(Alltrim(_M0CGC)) == 14
	oPrint:Say(590, 375, 'CNPJ: '+ Transform(_M0CGC,"@R 99.999.999/9999-99"), ofont8, 100)
	Else
	oPrint:Say(590, 375, 'CPF.: '+ Transform(_M0CGC,"@R 999.999.999-99"), ofont8, 100)
	Endif
	oPrint:Say(602, 375, 'Autentica็ใo Mecโnica - Ficha de Compensa็ใo', ofont8, 100)                                           

	//+------------------------------+
	//|Impressao do codigo de barras |
	//+------------------------------+
	oPrint:FWMSBAR("INT25" ,52 ,3 ,cCodBar2 ,oPrint,.F.,,.T.,0.025,1.2,,,,.F.,,,)

	oPrint:EndPage()

	// Douglas Telles - 11.05.2016 - Preenche informacoes para email
	aAdd(aInfMail,cNumTit) // Numero do titulo utilizado no boleto
	aAdd(aInfMail,SE1->E1_PREFIXO) // Serie do titulo
	aAdd(aInfMail,cParcela) // Parcela que foi impressa
	aAdd(aInfMail,_M0NOME) // Nome da Beneficiario
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDIG1(cDadCont)
	Local aPesos	:= 	{2,1,2,1,2,1,2,1,2,1,2,1,2}
	Local nX		:= 	0
	Local nResult1	:=	0
	//Local nResult2	:=	0
	Local nResult3	:=	0
	Local aDadCont	:= 	{}
	Local aResult	:= 	{}
	
	//For nX	:= 1 To Len(Alltrim(cDadCont))
	For nX := Len(Alltrim(cDadCont)) To 1 Step -1
		aAdd(aDadCont,Val(SubStr(Alltrim(cDadCont),nX,1)))
	Next nX                                          
	
	For nX:= 1 To Len(aPesos)
		if nX <= len(cDadCont)
			aAdd(aResult,aPesos[nX]*aDadCont[nX])		
		endif
	Next nX                    
	
	For nX:= 1 To Len(aResult)
		If Len(Alltrim(Str(aResult[nX]))) > 1
			aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
		EndIf
	Next                 
	
	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX
			
	//nResult2	:= Mod(nResult1,10)
	//nResult3	:= 10 - nResult2
    if mod(nResult1,10) <> 0
		if nResult1 < 10
			nDezena := 10
		else
			cValor :=AllTrim(STR(nResult1,12))
			nDezena:=VAL(ALLTRIM(STR(VAL(SUBSTR(cvalor,1,1))+1,12))+"0")
		endif
	else
		nDezena := nResult1
	endif
	nResult3   := nDezena - nResult1

//Return(Alltrim(Str(nResult3)))
Return(substr(Alltrim(Str(nResult3)),1,1))
//Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                      
Static Function BRPDIG2(cNossoNum,cNumero)
	Local aDados1	:=	{}
	//Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
	Local aPesos	:=	{2,7,6,5,4,3,2,7,6,5,4,3,2,7,6,5,4,3,2,7}
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

	//For nX:= 1 To Len(aResult)
	//	If Len(Alltrim(Str(aResult[nX]))) > 1
	//		aResult[nX]	:= Val(SubStr(Alltrim(Str(aResult[nX])),1,1)) + Val(SubStr(Alltrim(Str(aResult[nX])),2,1))
	//	EndIf
	//Next

	For nX:= 1 To Len(aResult)
		nResult1	+= aResult[nX]
	Next nX

	nResult2	:= Mod(nResult1,11)
	nResult3	:= iif(!empty(nResult2),11 - nResult2,0)

Return(Iif(Alltrim(Str(nResult3)) == "10","P",Alltrim(Str(nResult3))))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPCALBLC2(cBloco2)
	
	Local aDados1	:=	{}
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2}
	Local aResult	:=	{}
	Local nResult1	:=	0
	Local nResult2	:=	0
	Local nResult3	:=	0
	Local nX		:=	0
	
	For nX:= 1 To Len(cBloco2)
		aAdd(aDados1,Val(SubStr(cBloco2,nX,1)))
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDIG3(cNossoNum)
	
	Local aPesos	:=	{1,2,1,2,1,2,1,2,1,2}
	Local aDados1	:=	{}
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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBRPIMPBOL บAutor  ณ     SYMM           บ Data ณ  06/22/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function BRPDVBAR(cCodBar)
	Local i := 0
	Local nCont := 0
	Local cPeso := 2
	Local Resto := 0
	Local Result := 0
	Local nDV_BARRA := 0

	For i := 43 To 1 Step -1
		nCont := nCont + ( Val( SUBSTR( cCodBar,i,1 )) * cPeso )
		cPeso := cPeso + 1
		If cPeso >  9
			cPeso := 2
		Endif
	Next

	Resto  := ( nCont % 11 )
	Result := ( 11 - Resto )

	If Result >= 10 .or. Result == 0 .or. Result == 1
		nDV_BARRA := "1"
	Else
		nDV_BARRA := Str(Result,1)
	Endif
Return (nDV_BARRA)


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

	//Cria a conexใo com o server STMP ( Envio de e-mail )
	oServer := TMailManager():New()
	oServer:Init( "", cServer, cAccount, cPassword, 0, 25 )

	//seta um tempo de time out com servidor de 1min
	If oServer:SetSmtpTimeOut( 60 ) != 0
		Alert( "Falha ao setar o time out" )
		Return .F.
	EndIf

	//realiza a conexใo SMTP
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

	//Apos a conexใo, cria o objeto da mensagem
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
		//adiciona uma tag informando que ้ um attach e o nome do arq
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
