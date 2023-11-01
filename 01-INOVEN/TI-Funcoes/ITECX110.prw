#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX110													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio dos titulos vencidos aos clientes 		!
!					! Cobrança													!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 31/08/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX110( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SE1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Titulos Vencidos - Cobrança - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC110()

RpcClearEnv()

Return

User Function WFTEC110()

//Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
//Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
//Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
//Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
//Local lRet      := .T.
Local cTo		:= ''
Local cSubject	:= ''	//'Boleto Documento : ' + _xSer+'/'+_xDoc1 + ' - Data: ' + dtoc(dDataBase)
Local cCorpo	:= ''

Local _d
Local lTem := .F.

Private oServer, oMessage

if dow(dDataBase) == 7 .or. dow(dDataBase) == 1
	return .T.
endif

//If File("\workflow\wf_rec_vencidos.htm")

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"
		column E1_VENCREA as Date, E1_ZDTCOBR as Date

		SELECT DATEDIFF(DAY,SUBSTRING(E1_VENCREA,1,4)+'-'+SUBSTRING(E1_VENCREA,5,2)+'-'+SUBSTRING(E1_VENCREA,7,2),CONVERT(CHAR(10),GETDATE(),121)) DIASVV,
		E1_ZENVCOB,E1_ZDTCOBR,A1_ZENVCOB,E1.*, E1.R_E_C_N_O_ E1_NUMREC 
		FROM %table:SE1% E1
		INNER JOIN %table:SA1% A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA
		WHERE E1.%notdel% AND A1.%notdel%
		AND E1_SALDO > 0 AND E1_VENCREA < %exp:dtos(dDataBase)%
		AND E1_TIPO <> 'NCC' AND E1_TIPO <> 'RA '
		
		AND ((DATEDIFF(DAY,SUBSTRING(E1_VENCREA,1,4)+'-'+SUBSTRING(E1_VENCREA,5,2)+'-'+SUBSTRING(E1_VENCREA,7,2),CONVERT(CHAR(10),GETDATE(),121)) >= 4 AND E1_ZDTCOBR = ' ')
		OR (E1_ZDTCOBR <> ' ' AND E1_ZDTCOBR <> %exp:dtos(dDataBase)%))
		
		AND E1_ZENVCOB <> 'N' AND A1_ZENVCOB = 'S' AND E1_NUMBCO <> ' '
		ORDER BY E1_CLIENTE ASC, E1_LOJA ASC, E1_EMISSAO DESC		
	ENDSQL

	aStru := {}
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
	AADD(aStru,{"E1_CLIENTE","C", TamSx3("E1_CLIENTE")[1], TamSx3("E1_CLIENTE")[2] })
	AADD(aStru,{"E1_LOJA"	,"C", TamSx3("E1_LOJA")[1], TamSx3("E1_LOJA")[2] })

	If ( Select('TRB1') <> 0 )
		TRB1->(dbCloseArea())
	Endif
	oTMP1 := FWTemporaryTable():New( 'TRB1' )
	oTMP1:SetFields( aStru )
	oTMP1:Create()

	QRY->(dbGoTop())
	While !QRY->(EOF())

		if (empty(QRY->E1_ZDTCOBR) .or. (!empty(QRY->E1_ZDTCOBR) .and. (dDataBase - QRY->E1_ZDTCOBR) >= 11))

			TRB1->(recLock('TRB1', .T.))
			TRB1->E1_PREFIXO	:= QRY->E1_PREFIXO
			TRB1->E1_NUM		:= QRY->E1_NUM
			TRB1->E1_PARCELA	:= QRY->E1_PARCELA
			TRB1->E1_NUMBOR		:= QRY->E1_NUMBOR
			TRB1->E1_NUMBCO		:= QRY->E1_NUMBCO
			TRB1->E1_PORTADO	:= QRY->E1_PORTADO
			TRB1->E1_VENCREA	:= iif(!empty(QRY->E1_ZDTCOBR), QRY->E1_ZDTCOBR, QRY->E1_VENCREA)
			TRB1->E1_SALDO		:= QRY->E1_SALDO
			TRB1->E1_CLIENTE	:= QRY->E1_CLIENTE
			TRB1->E1_LOJA		:= QRY->E1_LOJA
			TRB1->E1_NUMREC		:= QRY->E1_NUMREC
			TRB1->(msUnlock())

			lTem := .T.

		EndIF

		QRY->(dbSkip())
	End

	cCab := ''
	cCab += '<html>'+;
			'<head>'+;
			'<meta http-equiv="Content-Language" content="pt-br">'+;
			'<style>'+;
			'body {background-color: transparent;font-family: helvetica;}'+;
			'.table-goone {border: 2px outset #002544;background-color: #EDE9D0;width: 90%;height: auto;}'+;
			'.table-goonefin {border: 2px solid #5F9EA0;background-color: #EDE9D0;width: 90%;height: auto;}'+;
			'</style>'+;
			'<title>Workflow Titulos Vencidos</title>'+;
			'</head><body>'+;
				'<div class="container">'+;
			'		<div align="center">'+;
			'			<img border="0" src="https://inoven.com.br/wp-content/uploads/2020/08/logo-inoven-colorida.png" width=10%></div>'+;
			'		</div>'+;
			'		</br>'+;
			'		<div align="left" style="width: 90%; margin-left:5%;">'

//			'			<p>Prezado Cliente,</br></p>'+;

	if lTem
		cCab2 := '			<p>Informamos que consta em aberto em nosso sistema débito(s) em seu nome. Pedimos que verifiquem o ocorrido e, se possível, efetivem a quitação do débito, onde agradecemos desde já.</br></p>'+;
				'			<p><b>IMPORTANTE: Caso tenham efetuado o pagamento, favor desconsiderar este aviso. Em caso de dúvida, faça contato através do e-mail contasareceber@inoven.com.br ou pelo telefone 47 4141-0017.</b></br></p>'+;
				'			<p>Gratos pela atenção.</br></p>'+;
				'		</div>'+;
				'		</br></br>'+;
				'		<div align="center" style="width: 90%; margin-left:5%; text-align: center; background-color: #002544; padding-bottom: 10px; padding-top: 10px; border-top-left-radius: 15px; border-top-right-radius: 15px;">'+;
				'			<h2 style="margin:0; color: #FFFFFF;">Relação de Títulos em ' + dtoc(dDataBase) + '</h2>'+;
				'		</div>'+;
				'		<div align="center">'+;
				'			<table class="table-goone" style="border-spacing: 0;">'+;
				'				<thead>'+;
				'					<tr>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Documento</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Série</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Parcela</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Vencimento</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;background-color: #B0C4DE;">Novo Vencto</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Linha Digitável</th>'+;
				'						<th align="right" style="border: 2px solid #002544; border-left: 0;">Valor&nbsp;</th>'+;
				'					</tr>'+;
				'				</thead><tbody>'
	else
		cCab2 := '			<p>Informamos que não constam títulos para cobrança nesta data!</p>'+;
				'		</div>'+;
				'		</br></br>'+;
				'		<div align="center" style="width: 90%; margin-left:5%; text-align: center; background-color: #002544; padding-bottom: 10px; padding-top: 10px; border-top-left-radius: 15px; border-top-right-radius: 15px;">'+;
				'			<h2 style="margin:0; color: #FFFFFF;">Relação de Títulos em ' + dtoc(dDataBase) + '</h2>'+;
				'		</div>'+;
				'		<div align="center">'+;
				'			<table class="table-goone" style="border-spacing: 0;">'+;
				'				<thead>'+;
				'					<tr>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Documento</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Série</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Parcela</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Vencimento</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;background-color: #B0C4DE;">Novo Vencto</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Linha Digitável</th>'+;
				'						<th align="right" style="border: 2px solid #002544; border-left: 0;">Valor&nbsp;</th>'+;
				'					</tr>'+;
				'				</thead><tbody>'
		
	endif
	
	cPara := ""
	cCli := ""
	TRB1->(dbGoTop())
	While !TRB1->(EOF())

		cCli := TRB1->E1_CLIENTE + TRB1->E1_LOJA

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + cCli))

		cPara := "<p>Prezado " + alltrim(SA1->A1_NOME) + ",</br></p>"

		//A1_XEMAILC
		if empty(SA1->A1_XEMAILC)
			TRB1->(dbSkip())
			Loop
		endif

		/*
		oProcess := TWFProcess():New("000001", OemToAnsi("Débito(s) em Aberto em " + dtoc(dDataBase)))
		oProcess:NewTask("000001", "\workflow\wf_rec_vencidos.htm")
		
		oProcess:cSubject 	:= "Débito(s) em Aberto em " + dtoc(dDataBase)
		oProcess:bTimeOut	:= {}
		oProcess:fDesc 		:= "Débito(s) em Aberto em " + dtoc(dDataBase)
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		oHTML:ValByName('ident', cCli)
		oHTML:ValByName('dtbase', dDataBase)
		*/

		goConnMail()

		cSubject	:= "INOVEN - Débito(s) em Aberto em " + dtoc(dDataBase) + " - CNPJ: " + alltrim(SA1->A1_CGC)
		cCorpo		:= ''
		cTo			:= SA1->A1_XEMAILC

		While !TRB1->(eof()) .and. cCli == TRB1->E1_CLIENTE + TRB1->E1_LOJA

			SE1->(dbSetOrder(1))
			SE1->(dbGoto(TRB1->E1_NUMREC))

			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial("SA6") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA))

			_xAjuste 	:= .T.
			_xVcto		:= dDataBase + 1
			
			do Case
				Case TRB1->E1_PORTADO == '341'

					cCarteira	:= "109"
					cNumBanco	:= AllTrim(SA6->A6_COD)
					cAgencia	:= Alltrim(SA6->A6_AGENCIA)
					cNumConta	:= Alltrim(SubStr(SA6->A6_NUMCON,1,5))
					cDigConta	:= Alltrim(SubStr(SA6->A6_NUMCON,6,1))

					cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
					nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					if _xAjuste
						_xVmulta := (nValorTit * 2)/100
						_xVmora  := (((nValorTit * 2)/100)/30)
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

					cNumBoleto	:= StrZero(Val(SE1->E1_NUMBCO),8)
					cDigitao	:= SubStr(cNumBoleto,Len(cNumBoleto),1)

					cDadosCta	:=	cAgencia + "/" + cNumConta + "-" + cDigConta          	
					xParDig		:= cNumBanco + "9" + cCarteira + SubStr(cNumBoleto,1,2)
					cDigblc1	:=	&("StaticCall(IFINB010, BRPDIG1, xParDig)")
					cBloco1		:=	Transform(cNumBanco + "9" + cCarteira + SubStr(cNumBoleto,1,2)+cDigblc1,"@R 99999.99999")
					xParDig		:= SubStr(cNumBoleto,3,8) + cDigitao + SubStr(cAgencia,1,3)
					cDigblc2	:=	&("StaticCall(IFINB010, BRPCALBLC2, xParDig)")
					cBloco2		:= 	Transform(SubStr(cNumBoleto,3,8) + cDigitao + SubStr(cAgencia,1,3) + cDigblc2,"@R 99999.999999")
					xParDig		:= SubStr(cAgencia,4,1) + cNumConta + cDigConta + "000"
					cDigblc3	:=	&("StaticCall(IFINB010, BRPDIG3, xParDig)")
					cBloco3		:=	Transform(SubStr(cAgencia,4,1) + cNumConta + cDigConta + "000" + cDigblc3,"@R 99999.999999")
					cBloco4		:=	cFatorVcto + cValorTit        
					xParDig		:= cNumBanco+"9"+cFatorVcto+cValorTit+cCarteira+cNumBoleto+cDigitao+cAgencia+cNumConta+cDigConta+"000"
					cDigCodBar	:=	&("StaticCall(IFINB010, BRPDVBAR, xParDig)")

					cCodBarras	:=	cBloco1 +"   "+ cBloco2 +"   "+ cBloco3 +"  "+ cDigCodBar +"   "+ cBloco4

					if TRB1->E1_PREFIXO <> 'CON'
						u_IFINB010(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., .F., "", .T., _xVcto)
						
						//oProcess:AttachFile('\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf")
						If oMessage:AttachFile( '\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf" ) < 0
							Alert( "Erro ao atachar o arquivo" )
							//Return .F.
						EndIf
					endif

				Case TRB1->E1_PORTADO == '033'

					cCarteira	:= "101"
					cNumBanco	:= AllTrim(SA6->A6_COD)
					cAgencia	:= Alltrim(SA6->A6_AGENCIA)
					cCodCed		:= AllTrim(SA6->A6_CODCED)

					cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
					nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					if _xAjuste
						_xVmulta := (nValorTit * 1.99)/100
						_xVmora  := (((nValorTit * 1.99)/100)/30)
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

					cNumBoleto := substr(SE1->E1_NUMBCO,1,len(alltrim(SE1->E1_NUMBCO))-1)
					cDigitao	  := right(alltrim(SE1->E1_NUMBCO),1)

					cNumBoleto := StrZero(Val(cNumBoleto),12)
					
					cDadosCta	:=	cAgencia +  " / " + cCodCed
					cDigCodBar	:=	Modulo11(cNumBanco + "9" + cFatorVcto + cValorTit + '9' + cCodCed + cNumBoleto + cDigitao + '0' + cCarteira )
					cDigCodBar	:= IIF(cDigCodBar $ "0|1|10","1",cDigCodBar)
					cDigblc1	:=	Modulo10(cNumBanco + "99" + SubStr(cCodCed,1,4))
					cBloco1		:=	Transform(cNumBanco + "99" + SubStr(cCodCed,1,4) + cDigblc1,"@R 99999.99999")
					cDigblc2	:=	Modulo10(SubStr(cCodCed,5,3) + SubStr(StrZero(val(cNumBoleto),12)+cDigitao,1,7))
					cBloco2		:= 	Transform(SubStr(cCodCed,5,3) + SubStr(StrZero(val(cNumBoleto),12)+cDigitao,1,7) + cDigblc2,"@R 99999.999999")
					cDigblc3	:=	Modulo10(SubStr(StrZero(val(cNumBoleto),12)+cDigitao,8,6) + '0' + cCarteira)
					cBloco3		:=	Transform(SubStr(StrZero(val(cNumBoleto),12)+cDigitao,8,6) + '0' + cCarteira + cDigblc3,"@R 99999.999999")
					cBloco4		:=	cFatorVcto + cValorTit
					cCodBarras	:=	cBloco1 + "   " + cBloco2 + "   " + cBloco3 + "  " + cDigCodBar + "   " + cBloco4

					if TRB1->E1_PREFIXO <> 'CON'
						u_IFINB050(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., .F., "", .T., _xVcto)
						
						//oProcess:AttachFile('\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf")
						If oMessage:AttachFile( '\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf" ) < 0
							Alert( "Erro ao atachar o arquivo" )
							//Return .F.
						EndIf
					endif

				Case TRB1->E1_PORTADO == '422'

					cCarteira	:= "01"
					cNumBanco	:= AllTrim(SA6->A6_COD)
					cAgencia	:= Alltrim(SA6->A6_AGENCIA)
					cNumConta	:= Alltrim(SA6->A6_NUMCON)

					cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
					nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					if _xAjuste
						_xVmulta := (nValorTit * 2)/100
						_xVmora  := (((nValorTit * 2)/100)/30)
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
					cDigBanco	:=	"7"

					//cNumBoleto := substr(SE1->E1_NUMBCO,1,9) 
					cNumBoleto := strzero(val(alltrim(SE1->E1_NUMBCO)),9)

					cDadosCta	:=	cAgencia + "/" + cNumConta
					xParDig		:= cNumBanco+"9"+cFatorVcto+cValorTit+"7"+cAgencia+cNumConta+cNumBoleto+"2"
					cDigCodBar	:=	&("StaticCall(IFINB040, BRPDVBAR, xParDig)")
					xParDig		:= cNumBanco + "97" + substr(cAgencia,1,4)
					cDigblc1	:=	&("StaticCall(IFINB040, BRPDIG1, xParDig)")	
					cBloco1		:=	Transform(cNumBanco + "97" + substr(cAgencia,1,4)+cDigblc1,"@R 99999.99999")
					xParDig		:= substr(cAgencia,5,1) + cNumConta
					cDigblc2	:=	&("StaticCall(IFINB040, BRPDIG1, xParDig)")
					cBloco2		:= 	Transform(substr(cAgencia,5,1) + cNumConta + cDigblc2,"@R 99999.999999")
					xParDig		:= cNumBoleto + "2"
					cDigblc3	:=	&("StaticCall(IFINB040, BRPDIG1, xParDig)")
					cBloco3		:=	Transform(cNumBoleto + "2" + cDigblc3,"@R 99999.999999")
					cBloco4		:=	cFatorVcto + cValorTit        
					cCodBarras	:=	cBloco1 +" "+ cBloco2 +" "+ cBloco3 +" "+ cDigCodBar +" "+ cBloco4

					if TRB1->E1_PREFIXO <> 'CON'
						u_IFINB040(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., .F., "", .T., _xVcto)
						
						//oProcess:AttachFile('\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf")
						If oMessage:AttachFile( '\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf" ) < 0
							Alert( "Erro ao atachar o arquivo" )
							//Return .F.
						EndIf
					endif

				Case TRB1->E1_PORTADO == '001'

					SEE->(DbSetOrder(1))
    				SEE->(DbSeek(xFilial("SEE")+SA6->A6_COD+SA6->A6_AGENCIA+SA6->A6_NUMCON+"001"))

					cCarteira		:= "17"
					cNumBanco		:= AllTrim(SA6->A6_COD)
					cConvenio		:= AllTrim(SEE->EE_CODEMP)

					cDtVencto  := iif(!_xAjuste,SE1->E1_VENCTO,_xVcto)
					nValAbate  := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA) 
					nValorTit  := SE1->E1_VALOR - nValAbate
					if _xAjuste
						_xVmulta := (nValorTit * 2)/100
						_xVmora  := (((nValorTit * 2)/100)/30)
						nValorTit += _xVmulta	//soma a multa
						for _d := 1 to (_xVcto - SE1->E1_VENCTO)
							nValorTit += _xVmora //aplica a mora por dia de atraso
						next
					endif
					cMoedCob	:=	"9" // Moeda de cobranca. 9 = Real

					cNossoN    := StrZero(Val(ALLTRIM(SE1->E1_NUMBCO)),10)
					cNumBoleto := ALLTRIM(SEE->EE_CODEMP)+StrZero(Val(Alltrim(SE1->E1_NUMBCO)),10) 
					_cConv     := SEE->EE_CODEMP 

				    cDadosCta := SUBSTR(SA6->A6_AGENCIA, 1, 4)+"-"+SUBSTR(SA6->A6_AGENCIA, 5, 5) + " / " + SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1) + "-" + SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)   
					aDadosBanco  := {SA6->A6_COD, SA6->A6_NREDUZ,;
									SUBSTR(SA6->A6_AGENCIA, 1, 4)+"-"+SUBSTR(SA6->A6_AGENCIA, 5, 5),; // [3]Agência
									SUBSTR(SA6->A6_NUMCON,1,Len(AllTrim(SA6->A6_NUMCON))-1),; 	     // [4]Conta Corrente
									SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)  ,;    	  // [5]Dígito da conta corrente
									"17-019"}
				    cNroDoc	:= Strzero(Val(Alltrim(SE1->E1_NUM)),6)+StrZERO(Val(Alltrim(SE1->E1_PARCELA)),2)
					cNroDoc	:= STRZERO(Val(cNroDoc),17)
	
					aCBarra  := &('StaticCall(IFINB030, Ret_cBarra, SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,'+;
											'Subs(aDadosBanco[1],1,3)	,aDadosBanco[3]	,aDadosBanco[4] ,aDadosBanco[5]	,'+;
											'cNroDoc,nValorTit	, "17"	,"9", cDtVencto	)')

					cCodBarras := aCBarra[2]

					if TRB1->E1_PREFIXO <> 'CON'
						u_IFINB030(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., .F., "", .T., _xVcto)
						
						//oProcess:AttachFile('\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf")
						If oMessage:AttachFile( '\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf" ) < 0
							Alert( "Erro ao atachar o arquivo" )
							//Return .F.
						EndIf
					endif

				Case TRB1->E1_PORTADO == '237'

					cCarteira	:= "09"
					cNumBanco	:= AllTrim(SA6->A6_COD)
					cAgencia	:= Alltrim(SA6->A6_AGENCIA)
					cDigAgen	:= Alltrim(SA6->A6_DVAGE)
					cNumConta	:= Alltrim(SubStr(SA6->A6_NUMCON,1,7))
					cDigConta	:= Alltrim(SA6->A6_DVCTA)	//Alltrim(SubStr(SA6->A6_NUMCON,6,1))

					cDtVencto := iif(!_xAjuste,SE1->E1_VENCREA,_xVcto)
					nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
					if _xAjuste
						_xVmulta := (nValorTit * 2)/100
						_xVmora  := (((nValorTit * 2)/100)/30)
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

					cNumBoleto	:= substr(SE1->E1_NUMBCO,1,11) 
					cDigitao	:= substr(SE1->E1_NUMBCO,12,1) 

					cDadosCta	:=	cAgencia + "-" + cDigAgen + "/" + cNumConta + "-" + cDigConta          	
					xParDig		:= cNumBanco+"9"+cFatorVcto+cValorTit+cAgencia+cCarteira+cNumBoleto+cNumConta+"0"
					cDigCodBar	:=	&("StaticCall(IFINB020, BRPDVBAR, xParDig)")
					xParDig		:= cNumBanco + "9" + cAgencia + substr(cCarteira,1,1)
					cDigblc1	:=	&("StaticCall(IFINB020, BRPDIG1, xParDig)")
					cBloco1		:=	Transform(cNumBanco + "9" + cAgencia + substr(cCarteira,1,1)+cDigblc1,"@R 99999.99999")
					xParDig		:= substr(cCarteira,2,1) + substr(cNumBoleto,1,9)
					cDigblc2	:=	&("StaticCall(IFINB020, BRPDIG1, xParDig)")
					cBloco2		:= 	Transform(substr(cCarteira,2,1) + substr(cNumBoleto,1,9) + cDigblc2,"@R 99999.999999")
					xParDig		:= substr(cNumBoleto,10,2) + cNumConta + "0"
					cDigblc3	:=	&("StaticCall(IFINB020, BRPDIG1, xParDig)")
					cBloco3		:=	Transform(substr(cNumBoleto,10,2) + cNumConta + "0" + cDigblc3,"@R 99999.999999")
					cBloco4		:=	cFatorVcto + cValorTit        

					cCodBarras	:=	cBloco1 +" "+ cBloco2 +" "+ cBloco3 +" "+ cDigCodBar +" "+ cBloco4

					if TRB1->E1_PREFIXO <> 'CON'
						u_IFINB020(TRB1->E1_NUM,TRB1->E1_NUM,TRB1->E1_PREFIXO, .F., .F., "", .T., _xVcto)
						
						//oProcess:AttachFile('\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf")
						If oMessage:AttachFile( '\boletos_spool\' + "boleto_inoven_"+Trim(TRB1->E1_NUM)+Trim(TRB1->E1_PARCELA)+DTOS(dDataBase)+".pdf" ) < 0
							//Alert( "Erro ao atachar o arquivo" )
							//Return .F.
						EndIf
					endif

			EndCase

			/*
			AAdd(oProcess:oHtml:ValByName('tit.doc')	, TRB1->E1_NUM)
			AAdd(oProcess:oHtml:ValByName('tit.serie')  , TRB1->E1_PREFIXO)
			AAdd(oProcess:oHtml:ValByName('tit.parc')	, TRB1->E1_PARCELA)
			AAdd(oProcess:oHtml:ValByName('tit.venc')   , dtoc(TRB1->E1_VENCREA))
			AAdd(oProcess:oHtml:ValByName('tit.newvenc'), dtoc(dDataBase + 1))
			AAdd(oProcess:oHtml:ValByName('tit.linha')  , cCodBarras)
			AAdd(oProcess:oHtml:ValByName('tit.valor')	, transform(nValorTit,"@E 999,999,999.99")+"&nbsp;")
			*/

			cCorpo += '<tr>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_NUM + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_PREFIXO + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_PARCELA + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + dtoc(TRB1->E1_VENCREA) + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;background-color: #B0C4DE;">' + dtoc(dDataBase + 1) + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + cCodBarras + '</td>'+;
						'<td align="right" style="border: 1px solid #002544; border-top: 0; border-left: 0; border-right: 0;">' + transform(nValorTit,"@E 999,999,999.99")+"&nbsp;" + '&nbsp;</td>'+;
					'</tr>'

			//Marca titulo como já enviado
			SE1->(dbSetOrder(1))
			SE1->(dbGoto(TRB1->E1_NUMREC))
			SE1->(recLock('SE1', .F.))
			SE1->E1_ZDTCOBR := dDataBase
			SE1->(msUnlock())

			TRB1->(dbSkip())
		End

		cCorpo += '</tbody>'+;
					'			</table>'+;
					'		</div>'+;
					'		<div align="right" style="margin-right:5%;">'+;
					'			<h5>[' + cCli + ']<br>Emitido em: ' + dtoc(dDataBase) + '<br>ENVIADO PELO PROTHEUS. Não responder esse e-mail</h5>'+;
					'		</div>'+;
					'	</div>'+;
					'</body>'+;
					'</html>'

		cCc := GetNewPar("IN_WFE1VEN", "crelec@gmail.com")
		//cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
		//cTo := "crelec@gmail.com"

		/*
		//oProcess:cTo := GetNewPar("IN_WFSLDPR", "crelec@gmail.com")			
		oProcess:cTo := "crelec@gmail.com"
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()	
		*/				

		//Popula com os dados de envio
		oMessage:cDate 				:= cValToChar( dDataBase )
		oMessage:cFrom              := cFrom
		oMessage:cTo                := cTo
		oMessage:cCc                := cCc
		//oMessage:cBcc               := ""
		oMessage:cSubject           := cSubject
		oMessage:cBody              := cCab + cPara + cCab2 + cCorpo

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

		Loop	

	End

	//Quando nao possui dados/titulos para enviar
	if !lTem
		goConnMail()

		cSubject	:= "INOVEN - Débito(s) em Aberto em " + dtoc(dDataBase)
		cCorpo		:= ''
		cTo			:= GetNewPar("IN_WFE1VEN", "crelec@gmail.com")

		cCorpo += '</tbody>'+;
					'			</table>'+;
					'		</div>'+;
					'		<div align="right" style="margin-right:5%;">'+;
					'			<h5>Emitido em: ' + dtoc(dDataBase) + '<br>ENVIADO PELO PROTHEUS. Não responder esse e-mail</h5>'+;
					'		</div>'+;
					'	</div>'+;
					'</body>'+;
					'</html>'

		//Popula com os dados de envio
		oMessage:cDate 				:= cValToChar( dDataBase )
		oMessage:cFrom              := cFrom
		oMessage:cTo                := cTo
		//oMessage:cCc                := cCc
		//oMessage:cBcc               := ""
		oMessage:cSubject           := cSubject
		oMessage:cBody              := cCab + cCab2 + cCorpo

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
	endif

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	If (Select("TRB1") <> 0)
		TRB1->(dbCloseArea())
	Endif


//Endif
Return

Static Function goConnMail()

Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)

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

return
