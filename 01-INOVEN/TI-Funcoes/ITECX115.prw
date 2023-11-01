#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX115													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio dos titulos vencidos aos clientes 		!
!					! Cobrança, por vendedor									!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 22/12/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX115( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SE1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Titulos Vencidos - Cobrança por Vendedor - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC115()

RpcClearEnv()

Return

User Function WFTEC115()

//Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
//Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
//Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
//Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
//Local lRet      := .T.
Local cTo		:= ''
Local cSubject	:= ''	//'Boleto Documento : ' + _xSer+'/'+_xDoc1 + ' - Data: ' + dtoc(dDataBase)
Local cCorpo	:= ''

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

		SELECT A1_VEND,DATEDIFF(DAY,SUBSTRING(E1_VENCREA,1,4)+'-'+SUBSTRING(E1_VENCREA,5,2)+'-'+SUBSTRING(E1_VENCREA,7,2),CONVERT(CHAR(10),GETDATE(),121)) DIASVV,
		E1_ZENVCOB,E1_ZDTCOBR,A1_ZENVCOB,E1.*, E1.R_E_C_N_O_ E1_NUMREC 
		FROM %table:SE1% E1
		INNER JOIN %table:SA1% A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA
		WHERE E1.%notdel% AND A1.%notdel%
		AND E1_SALDO > 0 AND E1_VENCREA < %exp:dtos(dDataBase)%
		AND E1_TIPO <> 'NCC' AND E1_TIPO <> 'RA '
		
		AND ((DATEDIFF(DAY,SUBSTRING(E1_VENCREA,1,4)+'-'+SUBSTRING(E1_VENCREA,5,2)+'-'+SUBSTRING(E1_VENCREA,7,2),CONVERT(CHAR(10),GETDATE(),121)) >= 4 AND E1_ZDTCOBR = ' ')
		OR (E1_ZDTCOBR <> ' ' AND E1_ZDTCOBR <> %exp:dtos(dDataBase)%))
		
		AND E1_ZENVCOB <> 'N' AND A1_ZENVCOB = 'S' AND E1_NUMBCO <> ' '
		ORDER BY A1_VEND,E1_CLIENTE ASC, E1_LOJA ASC, E1_EMISSAO DESC		
	ENDSQL

	aStru := {}
	AADD(aStru,{"A1_VEND"	,"C", TamSx3("A1_VEND")[1], TamSx3("A1_VEND")[2] })
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
			TRB1->A1_VEND		:= QRY->A1_VEND
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
		cCab2 := '			<p>Segue a relação de títulos em aberto de sua carteira:</p>'+;
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
				'						<th style="border: 2px solid #002544; border-left: 0;">Cliente</th>'+;
				'						<th style="border: 2px solid #002544; border-left: 0;">Vencimento</th>'+;
				'						<th align="right" style="border: 2px solid #002544; border-left: 0;">Valor&nbsp;</th>'+;
				'					</tr>'+;
				'				</thead><tbody>'
	endif
	
	cPara := ""
	cVend := ""
	TRB1->(dbGoTop())
	While !TRB1->(EOF())

		cVend := TRB1->A1_VEND
		SA3->(dbSetOrder(1))
		SA3->(msSeek(xFilial('SA3') + cVend))

		if empty(SA3->A3_EMAIL)
			TRB1->(dbSkip())
			Loop
		endif

		cPara := "<p>Prezado(a) " + alltrim(SA3->A3_NOME) + ",</br></p>"

		goConnMail()

		cSubject	:= "INOVEN - Relação de clientes com débito(s) em Aberto em " + dtoc(dDataBase)
		cCorpo		:= ''
		cTo			:= SA3->A3_EMAIL

		While !TRB1->(eof()) .and. cVend == TRB1->A1_VEND

			SA1->(dbSetOrder(1))
			SA1->(msSeek(xFilial('SA1') + TRB1->E1_CLIENTE + TRB1->E1_LOJA))

			SE1->(dbSetOrder(1))
			SE1->(dbGoto(TRB1->E1_NUMREC))

			SA6->(DbSetOrder(1))
			SA6->(DbSeek(xFilial("SA6") + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA))

			nValorTit := SE1->E1_SALDO - SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)
			
			cCorpo += '<tr>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_NUM + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_PREFIXO + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + TRB1->E1_PARCELA + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + alltrim(SA1->A1_NOME) + '</td>'+;
						'<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + dtoc(TRB1->E1_VENCREA) + '</td>'+;
						'<td align="right" style="border: 1px solid #002544; border-top: 0; border-left: 0; border-right: 0;">' + transform(nValorTit,"@E 999,999,999.99")+"&nbsp;" + '&nbsp;</td>'+;
					'</tr>'

			TRB1->(dbSkip())
		End

		cCorpo += '</tbody>'+;
					'			</table>'+;
					'		</div>'+;
					'		<div align="right" style="margin-right:5%;">'+;
					'			<h5>Emitido em: ' + dtoc(dDataBase) + '<br>ENVIADO PELO PROTHEUS. Não responder esse e-mail</h5>'+;
					'		</div>'+;
					'	</div>'+;
					'</body>'+;
					'</html>'

		cCc := GetNewPar("IN_WFE1REP", "charlesbattisti@gmail.com")

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
