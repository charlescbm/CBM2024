#Include "Protheus.ch"
#include 'TBICONN.CH'

//-------------------------------------------------------------------
/*/{Protheus.doc} ICOMA030
Envia e-mail para faturamento notificando a "perda" de mercadoria
@author  Victor Andrade
@since   11/04/2018
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function ICOMA030( aItens, cNotaFis, cSerie, cCodForn, cLoja, cNomeForn )

Local aArea         := GetArea()
//Local oMail         := TMailManager():New()
//Local oMessage      := Nil
//Local nErro         := 0
Local lRelAuth 	    := SuperGetMv("MV_RELAUTH",, .F.)
Local cFrom			:= GetNewPar( "MV_RELFROM" )
Local cSMTPServer   := GetNewPar( "MV_RELSERV" )
Local cSMTPUser 	:= GetNewPar( "MV_RELACNT" )
Local cSMTPPass 	:= GetNewPar( "MV_RELPSW"  )
//Local nSMTPPort		:= GetNewPar( "MV_SMTPPOR" )
Local cTo           := GetNewPar( "MV_MAILTO" )
Local cMailError    := ""
Local cMensagem     := TAL02Html( aItens, cNotaFis, cSerie, cCodForn, cLoja, cNomeForn )
Local lRet          := .T.
Local lConnect      := .F.
Local lEnviou       := .F.

/*
oMail:Init( '', cSMTPServer , cSMTPUser, cSMTPPass, 0, nSMTPPort  )
oMail:SetSmtpTimeOut( 500 )		
nErro := oMail:SmtpConnect()

If lRelAuth
	nErro := oMail:SmtpAuth(cSMTPUser ,cSMTPPass)
	
	If nErro <> 0
		// Recupera erro ...
		cMailError := oMail:GetErrorString(nErro)
		DEFAULT cMailError := '***UNKNOW***'
		lRet := .F.
	Endif

EndIf

If nErro <> 0
	// Recupera erro
	cMailError := oMail:GetErrorString(nErro)
	DEFAULT cMailError := '***UNKNOW***'
	oMail:SMTPDisconnect()
	lRet := .F.
Endif

If lRet
    oMessage := TMailMessage():New()
    oMessage:Clear()      
    oMessage:cFrom		:= cFrom
    oMessage:cTo		:= cTo
    oMessage:cSubject	:= "Notificação de Perda de Compras"
    oMessage:cBody		:= cMensagem
    oMessage:MsgBodyType( "text/html" )

    nErro := oMessage:Send( oMail )
		
    If nErro <> 0
        Alert( oMail:GetErrorString(nErro) )
        lRet := .F.
    Endif

    oMail:SMTPDisconnect()

EndIf
*/
cSubject	:= "Notificação de Perda de Compras"
If !Empty(cSMTPServer) .And. !Empty(cSMTPUser) .And. !Empty(cTo)
		//Realiza conexao com o Servidor
		CONNECT SMTP SERVER cSMTPServer ACCOUNT cSMTPUser PASSWORD cSMTPPass RESULT lConnect
		//--Verifica se existe autenticação
		If lRelauth
			lRet := Mailauth(cSMTPUser,cSMTPPass)        
		EndIf
		//--Se conseguiu Conexao ao Servidor SMTP	
		If lConnect 
			SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cMensagem ATTACHMENT '' RESULT lEnviou													
			If !lEnviou //Se conseguiu Enviar o e-Mail
				lRet:=.F.
				//Erro no envio do email
				GET MAIL ERROR cMailError
				ConOut("Erro de autenticação","Verifique a conta e a senha para envio",cMailError)
			EndIf
		Else
			lRet:=.F.
			GET MAIL ERROR cMailError
			ConOut("Erro de autenticação","Verifique a conta e a senha para envio ",cMailError)
		EndIf      	   
		If lRet
			DISCONNECT SMTP SERVER
		EndIf

Endif

RestArea( aArea )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL02Html
Monta a estrutura do HTML
@author  Victor Andrade
@since   11/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL02Html( aItens, cNotaFis, cSerie, cCodForn, cLoja, cNomeForn )

Local cEstruHtml := ""
Local cCss       := TAL02Css()
Local cLogoEmp   := GetNewPar( "ES_LOGOEMP" )
Local nX         := 0

cEstruHtml :='<html> '
cEstruHtml +='	<head> '
cEstruHtml +='		<title> Notificação de Perda de Compras </title> '
cEstruHtml +='		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> '
cEstruHtml +='      <style type="text/css">  '
cEstruHtml +=		cCss
cEstruHtml +=' 		</style> '
cEstruHtml +='	</head> '
cEstruHtml +=' 	<body>  '
cEstruHtml +='   	<div id="divLog"> '
cEstruHtml +=' 			<img src="' + cLogoEmp + '"> '
cEstruHtml +='		</div> '
cEstruHtml +='		<div id="divH1"> '
cEstruHtml +='			<h1>  C O M U N I C A D O -  Perda de Compras </h1> '
cEstruHtml +='		</div> '
cEstruHtml +='		<br> <br>'
cEstruHtml +='		<p> Prezados,  </p> '
cEstruHtml +='		<p> Houve perda de compras refente a Nota Fiscal: <strong>' + cNotaFis + '</strong> - Série: <strong>' + cSerie + '</strong>'
cEstruHtml +=' do Fornecedor <strong>' + cCodForn + '/' + cLoja + '</strong> - <strong>' + cNomeForn + '</strong> </p>'
cEstruHtml +='      <p>Abaixo dados indicando as quantidades de perda</p>    '
cEstruHtml +='		<table align="center" id="tabPrin"> '
cEstruHtml +='			<tbody> '
cEstruHtml +='			<tr> '
cEstruHtml +='		        <td> <strong>Cod. Produto     </strong> </td> '
cEstruHtml +='		   	    <td> <strong>Descrição        </strong> </td> '
cEstruHtml +='		   	    <td> <strong>Quantidade NF    </strong> </td> '
cEstruHtml +='		   	    <td> <strong>Quantidade Perda </strong> </td> ' 
cEstruHtml +='          </tr> '

For nX := 1 To Len( aItens )
    cEstruHtml += '<tr>'
    cEstruHtml += '   <td>' + AllTrim(aItens[nX][2]) + '</td>'
    cEstruHtml += '   <td>' + AllTrim(aItens[nX][3]) + '</td>'
    cEstruHtml += '   <td>' + cValToChar(aItens[nX][4]) + '</td>'
    //cEstruHtml += '   <td>' + cValToChar(aItens[nX][8]) + '</td>'
    cEstruHtml += '   <td>' + cValToChar(aItens[nX][7]) + '</td>'
    cEstruHtml += '</tr>'
Next nX

cEstruHtml += '			</tbody> '
cEstruHtml += '		</table> '
cEstruHtml += ' 	<br> <br> '			
cEstruHtml += '	<h4> Inoven Workflow – Por favor não responda este email. <br> '
cEstruHtml += '	</body>'
cEstruHtml += '</html>'

Return( cEstruHtml )

//-------------------------------------------------------------------
/*/{Protheus.doc} TAL02Css
Retorna o CSS a ser utilizado no envio da notificação
@author  Victor Andrade
@since   11/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TAL02Css()

Local cCss := ""

cCss := '#divH1{ '
cCss +=	'	font-family: Verdana, Arial, Sans-serif; '
cCss +=	'	font-size: 10px; '
cCss +=	'	color: #555; '
cCss +=	'	background-color: #fff; '
cCss +=	'	text-align: center; '
cCss +=	'	border-radius: 1px; '
cCss +=	'	border-style: solid; '
cCss +=	'	border-color: #555; '
cCss +=	'	border-width: 2px 2px 2px 2px; '
cCss +=	'	height: 50; '
cCss +=	'	width: 600; '
cCss +=	'	position: relative; '
cCss +=	'	left: 380px; '
cCss +=	'	top: 30px; '
cCss +=	'	background-color:#f2f2f2; '
cCss +=	'} '

cCss +=	' body{ '
cCss +=	'	position: relative; '
cCss +=	'	background-color:#e2e2e2; '
cCss +=	'	text-align: center; '
cCss +=	'	top: 5px; '
cCss +=	' } '

cCss +=	' td{ '
cCss +=	'	background-color:#efeFef; '
cCss +=	'	border-bottom:1px solid #cbcbcb; '
cCss +=	' } '

cCss +=	'h1{ '
cCss +=	'	position: relative; '
cCss +=	' } '

cCss +=	' h4{ '
cCss +=	'	font-family: Verdana, Arial, Sans-serif; '
cCss +=	'	font-size: 10px; '
cCss +=	'	color: #555; '
cCss +=	'	background-color: #fff; '
cCss +=	'	text-align: center; '
cCss +=	'	border-radius: 1px; '
cCss +=	'	border-style: solid; '
cCss +=	'	border-color: #555; '
cCss +=	'	border-width: 2px 2px 2px 2px; '
cCss +=	'	height: 50; '
cCss +=	'	width: 600; '
cCss +=	'	position: relative; '
cCss +=	'	left: 380px; '
cCss +=	'	top: 27px; '
cCss +=	'	background-color:#f2f2f2; '
cCss +=	' } '

Return( cCss )
