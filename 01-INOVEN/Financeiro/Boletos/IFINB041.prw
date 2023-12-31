#Include "Protheus.Ch"
#Include "TopConn.Ch"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "totvs.ch"

#DEFINE TAM_A4 9 // A4 - 210mm x 297mm - 620 x 876

/*/{Protheus.doc} IFINB050
Fun��o para o processo de gera��o de boletos do Banco Santander.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param cDocx, caracter, N�mero do t�tulo para gerar o boleto junto com o DANFE.
@param cSeriex, caracter, N�mero da s�rie para gerar o boleto junto com o DANFE.
@param cEnvBol, caracter, Indica se o boleto ser� enviado por e-mail. (1 = Sim, 2 = N�o).
/*/
//DESENVOLVIDO POR INOVEN

User Function IFINB041(_xNum1,_xNum2,_xPrefixo)

	//Local cPerg	:= 'BOL001'
	//Local aRegs	:= {}
	//Local aTemp	:= {}
	Local cV12		:= GetRpoRelease()

	Private lV12		:= SubStr(cV12,1,2) == "12"
	Private cNumBoleto	:= ""
	Private cComplemen	:= ""
	Private cNumBol		:= ""
	Private cNossoNum	:= ""
	Private cDVNossoNum	:= ""
	Private cJuros		:= ""
	Private cMensBol1	:= "Ap�s vencimento cobrar "
	Private cMensBol2	:= ""
	Private cMensBol3	:= "Protestar ap�s 3 dias corridos do vencimento."
	Private cMensBol4	:= ""
	Private lAuto		:= .F.
	Private lReimp		:= .F.
	Private aInfMail	:= {}
	Private lPreview	:= .F.
    Private lPergu      := .T.


	Processa( {|lEnd| SYVALID001(_xNum1,_xNum2,_xPrefixo) }, "Aguarde...","Gerando Boletos...",.T.)

Return()



/*/{Protheus.doc} SYVALIDIMP
Efetua as regras e valida��es necess�rias antes de imprimir o boleto.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param aCols, array, Array com as informa��es a serem impressas.
/*/
Static Function SYVALID001(_xDoc1,_xDoc2,_xSer)
	//Local nX					:= 0
	Local oPrint				:= Nil
	Local lAdjustToLegacy	:= .F.
	Local lDisableSetup		:= .T.
	Local cDirClient			:= GetTempPath()
	Local cFile				:= "Boleto"+Trim(SE1->E1_NUM)+Trim(SE1->E1_PARCELA)+DTOS(dDataBase)+Replace(Time(),':','')+".PDF"
	Local cDirExp				:= "\spool\"
	//Local cConout				:= ""
    Private lImpri              := .F.
	Private _xBCOdia        := Getmv("MV_BCODIA")

      If Select("TRB1") > 0
	      TRB1->(DbCloseArea())
       EndIf
	   cQuery := "SELECT E1_NUM,E1_PREFIXO,E1_PARCELA,E1_NUMBOR,E1_NUMBCO,E1_XFORMA,SE1.R_E_C_N_O_ AS E1_NUMREC" + CRLF
	   cQuery += " FROM "+RetSqlName("SE1")+" SE1 " + CRLF
	   cQuery += "WHERE E1_FILIAL      = '"+xFilial("SE1")+"' " + CRLF
	   cQuery += "	 AND E1_PREFIXO     = '"+_xSer+"' AND E1_NUM BETWEEN '"+_xDoc1+"' AND '"+_xDoc2+"' " + CRLF
	   cQuery += "	 AND E1_XFORMA      IN ('BOL','DP') " + CRLF 
	   cQuery += "	 AND SE1.D_E_L_E_T_ = ' ' " + CRLF
	   cQuery += "ORDER BY E1_NUM,E1_PREFIXO,E1_PARCELA"
       TcQuery cQuery New Alias "TRB1"
   	
	//+-------------------------------------------------+
	//|Instancia objeto a ser utilizado para impressao. |
	//+-------------------------------------------------+
    oPrint:=FWMSPrinter():New(cFile, IMP_PDF, lAdjustToLegacy,cDirExp, lDisableSetup, , , , .T., , .F., )      
	oPrint:CPATHPDF := cDirClient
	oPrint:setResolution(78)
	oPrint:SetPortrait()
	oPrint:setPaperSize(TAM_A4)
	oPrint:SetMargin(60,60,60,60)

    dbSelectArea("TRB1")
    dbGoTop()
	ProcRegua(LastRec())
  	Do While !Eof()
		
		//->> Marcelo Celi - Alfa - 21/08/2018
		//->> Setando a private lImpri como falso, que � o inicializador de situa��o.
		//->> Caso ele n�o sofra essa declara��o, ele pode estar setado de maneira errada
		//->> e n�o gerar o nosso numero conforme as regras de boletos.		
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
        _xBCOdia := SA1->A1_BCO1 
        //_xCAGEdia := "3872 "
        //_xCCONdia := "130022190 "
        _xCAGEdia := "06700"		             
        _xCCONdia := "005808367 "		             
		DbSelectArea("SA6")
		dbSeek(xFilial("SA6")+_xBCOdia+_xCAGEdia+_xCCONdia)

		If !Empty(TRB1->E1_NUMBCO)
		   
		   //->> Marcelo Celi - Alfa - 21/08/2018
		   //->> Vai deixar de perguntar se deseja reimprimir, considerando que se o usuario chegou ate aqui
		   //->> ele realmente deseja reimprimir o documento.
		   
		   /*
		   MsgAlert("Aten��o Esse T�tulo J� Foi IMPRESSO !!! " + AllTrim(TRB1->E1_PREFIXO)+AllTrim(TRB1->E1_NUM),"Aten��o")
           If MsgYesNo('Imprimir Novamente ?') 
              lImpri := .T.
           Else
              dbSelectArea("TRB1")
	          dbSkip()
              Loop
           EndIf  
           */
           
           lImpri := .T.
           
		Endif

		//+---------------------------+
		//|Chama funcao para impressao|
		//+---------------------------+
		SYIMPBO01(oPrint)

        dbSelectArea("TRB1")
	    dbSkip()
	Enddo

	If lPreview
		oPrint:Preview()
	EndIf
                                     

Return()


/*/{Protheus.doc} SYIMPBOL
Gera o layout do boleto j� com as informa��es.
@author Douglas Telles
@since 30/05/2016
@version 1.0
@param oPrint, objeto, Objeto de impress�o a ser utilizado.
/*/
Static Function SYIMPBO01(oPrint)
	Local cCarteira		:= "01"
	Local cValorTit		:= ""
	Local cFatorVcto	:= ""
	Local cNumBanco		:= AllTrim(SA6->A6_COD)
	Local cAgencia		:= Alltrim(SA6->A6_AGENCIA)
	Local cNumConta		:= Alltrim(SA6->A6_NUMCON)
	//Local cDigConta		:= Alltrim(SA6->A6_DVCTA)	//Alltrim(SubStr(SA6->A6_NUMCON,6,1))
	Local cDtVencto		:= Ctod("")
	Local cBitMapBanco	:= GetSrvProfString("Startpath","")+"\logo_safra.bmp"
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

	// +----------------------------------------------------------+
	// | Indica que foi gerado boleto para pelo menos uma parcela |
	// +----------------------------------------------------------+
	lPreview := .T.
	cDtVencto := SE1->E1_VENCREA
	nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
	cFatorVcto := StrZero(cDtVencto - Ctod("07/10/1997"),4)
	cValorTit  := Right(StrZero(nValorTit * 100,17,0),10)
	IF nValorTit > 99999999.99
		cFatorVcto:= ""
		cValorTit := Substr(StrZero(nValorTit * 100,17,2),1,14)
	EndIF
	cDigBanco	:=	"7"
    //+--------------------------------------------------+
	//| Prepara o nosso numero com as devidas validacoes |
	//+--------------------------------------------------+
    If !lImpri
	   DbSelectArea("SEE")
       DbSetOrder(1)
       DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001")
       cNumBoleto := StrZero(Val(Alltrim(SEE->EE_DIRPAG)),9)
	   //cDigitao	  := BRPDIG2( "090" + StrZero(Val(cNumBoleto),10),cNumBoleto )
       Reclock("SEE",.F.)
         SEE->EE_DIRPAG := StrZero(Val(cNumBoleto)+1,9)
       MsUnlock()
	   DbSelectArea("SE1")
	   RecLock("SE1",.F.)
	     SE1->E1_NUMBCO  := StrZero(Val(ALLTRIM(cNumBoleto)),9)
	     SE1->E1_PORTADO := SA6->A6_COD
	     SE1->E1_AGEDEP  := SA6->A6_AGENCIA
	     SE1->E1_CONTA   := SA6->A6_NUMCON   
	   MsUnlock()
	Else
	   cNumBoleto := substr(SE1->E1_NUMBCO,1,9) 
	   //cDigitao	  := substr(SE1->E1_NUMBCO,11,1) 
	Endif

	cDadosCta	:=	cAgencia + "/" + cNumConta

	cDigCodBar	:=	BRPDVBAR(cNumBanco+"9"+cFatorVcto+cValorTit+"7"+cAgencia+cNumConta+cNumBoleto+"2")
	cCodBar2	:= cNumBanco + "9" + cDigCodBar + cFatorVcto + StrZero(Int(SE1->E1_VALOR*100),10)+; 
                   "7" + cAgencia + cNumConta + cNumBoleto + "2"

	cDigblc1	:=	BRPDIG1(cNumBanco + "97" + substr(cAgencia,1,4) )	
	cBloco1		:=	Transform(cNumBanco + "97" + substr(cAgencia,1,4)+cDigblc1,"@R 99999.99999")
	cDigblc2	:=	BRPDIG1(substr(cAgencia,5,1) + cNumConta)
	cBloco2		:= 	Transform(substr(cAgencia,5,1) + cNumConta + cDigblc2,"@R 99999.999999")
	cDigblc3	:=	BRPDIG1(cNumBoleto + "2")
	cBloco3		:=	Transform(cNumBoleto + "2" + cDigblc3,"@R 99999.999999")
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
	_M0CGC  := "07826504000104"	//"07826504000295"    
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
	oprint:say(135, 027, "Endere�o Beneficiario\Sacador Avalista",ofont8,100)
	oprint:say(135, 392, "Ag�cia/C�digo Beneficiario",ofont8,100)
	oprint:say(145, 030, Upper(Alltrim(_M0END) + " " + Alltrim(_M0BAI) + " " + Alltrim(_M0CID) + " - " + Alltrim(_M0EST) + " " + Alltrim(Transform(_M0CEP,"@R 99999-999"))) ,ofont10,100) //Endere? Beneficiario...
	oprint:say(145, 475, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oprint:say(155, 027, "Data Documento",ofont8,100)
	oprint:say(155, 093, "N�mero do Documento",ofont8,100)
	oprint:say(155, 180, "Esp.Doc.",ofont8,100)
	oprint:say(155, 218, "Aceite",ofont8,100)
	oprint:say(155, 270, "Data Processamento",ofont8,100)
	oprint:say(155, 392, "Carteira/Nosso N�mero",ofont8,100)
	oprint:say(164, 027, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 093, cNumTit+"-"+cParcela,ofont10,100)    //Numero do Documento
	oprint:say(164, 180, "DM",ofont10,100)
	oprint:say(164, 215, "NAO",ofont10,100)
	oprint:say(164, 273, DTOC(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(164, 485, cNumBoleto,ofont10,100,,,1)
	oprint:say(175, 027, "Uso do Banco",ofont8,100)
	oprint:say(175, 093, "Carteira",ofont8,100)
	oprint:say(175, 130, "Esp�cie",ofont8,100)
	oprint:say(175, 168, "Quantidade",ofont8,100)
	oprint:say(175, 273, "Valor",ofont8,100)
	oprint:say(175, 392, "(=) Valor do Documento",ofont8,100)
	oprint:say(185, 093, cCarteira,ofont10,100)                              // carteira
	oprint:say(185, 130, "R$",ofont10,100)                                                                                                                 
	oprint:say(185, 485, AllTrim(TransForm(nValorTit, "@E 999,999,999.99")),ofont10,100,,,1)           //Valor
	oprint:say(195, 027, "Instru��es de responsabilidade do Benefici�rio. Qualquer d�vida sobre este boleto, contate o BENEFICI�RIO.",ofont6,100)
	oPrint:Say(195,392,"(-) Abatimento",ofont8,100)
	oPrint:Say(215,392,"(-) Desconto",ofont8,100)
	oPrint:Say(235,392,"(+) Mora/Multa/Outros Recebimentos",ofont8,100)
	oPrint:Say(255,392,"(+) Juros",ofont8,100)
	oPrint:Say(275,392,"(=) Valor Cobrado",ofont8,100)
	oPrint:Say  (205, 027, "PAGAR SOMENTE COM O BOLETO.", oFont10)
	oPrint:Say  (215, 027, "Protestar no quinto dia util apos o vencimento.", oFont10)
	_xVmulta := (nValorTit * 2)/100
	_xVmora  := (((nValorTit * 1)/100)/30)
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
	oPrint:Say(328, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(337, 375, 'Autentica��o Mec�nica', ofont8, 100) 

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
	//oPrint:say(383, 027, "Pag�vel em qualquer Banco do sistema de compensa��o",ofont10,100)
	oPrint:say(380, 027, "Pag�vel em qualquer Banco do sistema de compensa��o",ofont10,100)
	//oPrint:say(385, 490, Dtoc(SE1->E1_VENCTO), ofont10, 100,,,1)                 
	oPrint:say(380, 490, Dtoc(SE1->E1_VENCREA), ofont10, 100,,,1)                 
	//oPrint:say(397, 027, "Benefici�rio",ofont8,100)
	//oPrint:say(397, 392, "Ag�ncia/C�digo Benefici�rio",ofont8,100)
	oPrint:say(390, 027, "Benefici�rio",ofont8,100)
	oPrint:say(390, 392, "Ag�ncia/C�digo Benefici�rio",ofont8,100)

	If Len(Alltrim(SM0->M0_CGC)) == 14 
   		oPrint:Say(398, 030, _M0NOME + ' - CNPJ: ' + TransForm(_M0CGC, "@R 99.999.999/9999-99"),oFont10,100)
    Else
   		oPrint:Say(398, 030, _M0NOME + ' - CPF.: ' + TransForm(_M0CGC, "@R 999.999.999-99"),oFont10,100)
    Endif

	oprint:say(407, 030, Upper(Alltrim(_M0END) + " " + Alltrim(_M0BAI) + " " + Alltrim(_M0CID) + " - " + Alltrim(_M0EST) + " " + Alltrim(Transform(_M0CEP,"@R 99999-999"))) ,ofont8B,100) //Endere? Beneficiario...
	oprint:say(407, 475, cDadosCta,ofont10,116,,,1)          //Agencia/Codigo do Cedente
	oPrint:say(418, 027, "Data Documento",ofont8,100)
	oPrint:say(418, 093, "N�mero do Documento",ofont8,100)
	oPrint:say(418, 180, "Esp.Doc.",ofont8,100)
	oPrint:say(418, 218, "Aceite",ofont8,100)
	oPrint:say(418, 270, "Data Processamento",ofont8,100)
	oPrint:say(418, 392, "Carteira/Nosso N�mero",ofont8,100)
	oPrint:say(427, 027, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(427, 093, cNumTit+"-"+cParcela,ofont10,100)    //Numero do Documento
	oPrint:say(427, 180, "DM",ofont10,100)
	oPrint:say(427, 218, "NAO",ofont10,100)
	oPrint:say(427, 270, dtoc(SE1->E1_EMISSAO),ofont10,100)
	oprint:say(427, 485, cNumBoleto,ofont10,100,,,1)
	oPrint:say(438, 027, "Uso do Banco",ofont8,100)
	oPrint:say(438, 093, "Carteira",ofont8,100)
	oPrint:say(438, 130, "Esp�cie",ofont8,100)
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
	oprint:say(458, 027, "Instru��es de responsabilidade do Benefici�rio. Qualquer d�vida sobre este boleto, contate o BENEFICI�RIO.",ofont6,100) 
	oPrint:Say  (468, 027, "PAGAR SOMENTE COM O BOLETO.", oFont10)
	oPrint:Say  (478, 027, "Protestar no quinto dia util apos o vencimento."   , oFont10)
	_xVmulta := (nValorTit * 2)/100
	_xVmora  := (((nValorTit * 1)/100)/30)
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
	oPrint:Say(590, 027, 'Sacador/Avalista',ofont8,500)
	oPrint:Say(602, 375, 'Autentica��o Mec�nica - Ficha de Compensa��o', ofont8, 100)                                           

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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BRPIMPBOL �Autor  �     SYMM           � Data �  06/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BRPDIG1(cDadCont)
	Local aPesos	:= 	{2,1,2,1,2,1,2,1,2}
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
		aAdd(aResult,aPesos[nX]*aDadCont[nX])		
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BRPIMPBOL �Autor  �     SYMM           � Data �  06/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	nResult3	:= 11 - nResult2

Return(Iif(Alltrim(Str(nResult3)) == "10","P",Alltrim(Str(nResult3))))

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BRPIMPBOL �Autor  �     SYMM           � Data �  06/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BRPIMPBOL �Autor  �     SYMM           � Data �  06/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BRPIMPBOL �Autor  �     SYMM           � Data �  06/22/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BRPDVBAR(cCodBar)
	//Local aPesos	:= 	{2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2}
	Local aPesos	:= 	{2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,9,2,3,4,5,6,7,8,9,2,3,4}
	Local nX		:= 	0
	Local nResult1	:=	0
	//Local nResult2	:=	0
	Local nResult3	:=	0
	Local aDadCont	:= 	{}
	Local aResult	:= 	{}
	
	//For nX	:= 1 To Len(Alltrim(cCodBar))
	For nX := Len(Alltrim(cCodBar)) To 1 Step -1
		aAdd(aDadCont,Val(SubStr(Alltrim(cCodBar),nX,1)))
	Next nX                                          
	
	For nX:= 1 To Len(aPesos)
		aAdd(aResult,aPesos[nX]*aDadCont[nX])		
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
	nResult3	:= 11 - nResult2
	nResult3	:= iif(nResult3==0 .or. nResult3==1 .or. nResult3==10,1,nResult3)

//Return(Iif(Alltrim(Str(nResult3)) == "10","0",Alltrim(Str(nResult3))))
Return(Alltrim(Str(nResult3)))


