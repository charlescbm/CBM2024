#INCLUDE "protheus.ch"
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! TK260ROT													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Ponto de entrada para inclusão de novas rotinas na tela	! 
!					! de Prospects												!
!					! Converter: TK260CCL										!
!					! Converte prospect para cliente							! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 18/10/2021 												!
+-------------------+-----------------------------------------------------------+
*/
User Function TK260ROT()
	Local aRotina	:= {} 
	
	aadd(aRotina,{"Converter*","U_TK260CCL()" , 0 , 4})

Return aRotina

/*
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para conversão de Prospect em Cliente				! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 18/10/2021 												!
+-------------------+-----------------------------------------------------------+
*/
USER FUNCTION TK260CCL()

	//Valida o usuario que pode executar a opcao
	If !(AllTrim(__cUserId) $ SuperGetMv("IN_USRCVPR",,""))
		MsgInfo("Usuário sem permissão para utilizar esta opção!")
		Return
	endif


	// VERIFICA SE O PROSPECT PODE SER CONVERTIDO
	If Empty(SUS->US_CODCLI) .AND. Empty(SUS->US_LOJACLI)
		IF APMSGYESNO("Tem certeza que deseja converter o prospect "+ALLTRIM(SUS->US_NOME)+" ("+SUS->US_COD+"/"+SUS->US_LOJA+") em cliente?","CONFIRMAÇÃO-"+ALLTRIM(ProcName())+"-TK260ROT")

			dbSelectArea('SA1');dbSetorder(1)
			dbSelectArea('SA3');dbSetorder(1)
			dbSelectArea('CC2');dbSetorder(1)

			IF U_TMKVA1(SUS->US_COD,SUS->US_LOJA)
				If !Empty(SUS->US_CODCLI) .AND. !Empty(SUS->US_LOJACLI)

					// ENVIA EMAIL PARA SETOR DE CADASTRO E PARA O VENDEDOR
					_cEmail 	:= ALLTRIM(GetNewPar("IN_INOVWF5", "crelec@gmail.com"))

					//Verifica o vendedor do prospect
					SA3->(dbSetOrder(1))
					if !empty(SUS->US_VEND) .and. SA3->(msSeek(xFilial('SA3') + SUS->US_VEND))

						cSuper := SA3->A3_SUPER
						cAuxA3 := SA3->A3_USRAUX

						if !empty(cSuper) .and. SA3->(msSeek(xFilial('SA3') + cSuper))
							if !empty(SA3->A3_EMAIL)
								_cEmail += iif(!empty(_cEmail), ';', '')
								_cEmail += alltrim(SA3->A3_EMAIL)
							endif
						endif
						if !empty(cAuxA3)
							if !empty(UsrRetMail(cAuxA3))
								_cEmail += iif(!empty(_cEmail), ';', '')
								_cEmail += alltrim(UsrRetMail(cAuxA3))
							endif							
						endif

					endif
					
					_cTitulo	:= "Cadastro de Prospect (" + SUS->US_COD + ") - Conversão de Cliente - " + dtoc(dDatabase)
					_cMsg	:= "O usuário "+ALLTRIM(CUSERNAME)+" acaba de converter o prospect "+ALLTRIM(SUS->US_NOME)+" ("+SUS->US_COD+"/"+SUS->US_LOJA+") em cliente ("+SUS->US_CODCLI+"/"+SUS->US_LOJACLI+"). "
					//_cMsg	+= "<hr>Observações: "+ALLTRIM(SUS->US_OBSCONV)
					//_cMsg	+= "<br>Limite de Crédito: R$ "+ALLTRIM(TRANSFORM(SA1->A1_LC,PESQPICT("SA1","A1_LC")))+" (venc.: "+DTOC(SA1->A1_VENCLC)+")"
					//_cMsg	+= "<br>Risco: "+SA1->A1_RISCO//+" - Classe: "+SA1->A1_CLASSE
					//U_WFGERAL(_cEmail,_cTitulo,_cMsg)
					goSendMail(_cEmail,_cTitulo,_cMsg)
				ELSE
					APMSGALERT("Houve algum erro interno ao tentar converter este prospect para cliente."+CHR(10)+CHR(13)+"Por gentileza, abra um chamado para o TI.","ERRO INTERNO-"+ALLTRIM(ProcName())+"-TK260ROT")
				ENDIF
			ENDIF
		ENDIF
	ELSE
		APMSGALERT("Este prospect já foi convertido anteriormente para o cliente "+SUS->US_CODCLI+"/"+SUS->US_LOJACLI+".","PROSPECT INVÁLIDO-"+ALLTRIM(ProcName())+"-TK260ROT")
	ENDIF
Return


Static Function goSendMail(_cEmail,_cTitulo,_cMsg)


Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
//Local lRet      := .T.
Local cTo		:= ''
Local cSubject	:= ''	//'Boleto Documento : ' + _xSer+'/'+_xDoc1 + ' - Data: ' + dtoc(dDataBase)
Local cCorpo	:= ''

cCorpo := ''
cCorpo += '<html>'+;
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
	'			<img border="0" src="https://inoven.com.br/wp-content/uploads/2020/08/logo-inoven-colorida.png" width=10%>'+;
	'		</div>'+;
	'		</br>'+;
	'		<div align="left" style="width: 50%; margin-left:30%;">'+;
	'			<p>' + _cMsg + '</p>'+;
	'		</div>'+;
	'		</br></br>'+;
	'		<div align="right" style="margin-right:30%;">'+;
	'			<h5>Emitido em: ' + dtoc(dDataBase) + '<br>ENVIADO PELO PROTHEUS. Não responder esse e-mail</h5>'+;
	'		</div>'+;
	'	</div>'+;
	'</body>'+;
	'</html>'


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

cSubject	:= _cTitulo
cTo			:= _cEmail

//cCc := GetNewPar("IN_WFE1VEN", "crelec@gmail.com")

//Popula com os dados de envio
oMessage:cDate 				:= cValToChar( dDataBase )
oMessage:cFrom              := cFrom
oMessage:cTo                := cTo
//oMessage:cCc                := cCc
//oMessage:cBcc               := ""
oMessage:cSubject           := cSubject
oMessage:cBody              := cCorpo

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

Return
