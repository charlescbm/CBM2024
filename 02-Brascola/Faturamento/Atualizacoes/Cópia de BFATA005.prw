/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BFATA005                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! E-mail com a relação das comissões pagas ao vendedor    !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 13/02/2012                                              !
+------------------+---------------------------------------------------------+
*/

#include "protheus.ch"

User Function BFATA05()

Local cPerg := PADR("BFATA005",10)

fCriaPerg(cPerg)

If Pergunte(cPerg,.T.)
	
	Processa({ || fTotComis() },"[BFATA005] - AGUARDE")
	
	If MV_PAR06 == 1
		Processa({ || fMailComis() },"[BFATA005] - AGUARDE")
	EndIf
EndIf

Return

//========================================= ENVIA E-MAIL PARA RESPONSAVEL =========================================//
Static Function fTotComis()

Local cVend     := ""
Local cHtml     := ""
Local cServer   := GetMv("MV_RELSERV")
Local cAccount  := GetMv("MV_RELACNT")
Local cFrom     := GetMv("MV_RELACNT")
Local cTo       := MV_PAR05
Local cPassword := GetMv("MV_RELPSW")
Local cAssunto  := ""
Local cAlias := GetNextAlias()

Local nTotBase  := 0
Local nTotComis := 0

Local nCount := 0
/*
BeginSql alias cAlias
	SELECT	SE3.E3_VEND, SA3.A3_NOME, SUM(SE3.E3_BASE) AS BASE, SUM(SE3.E3_COMIS) AS COMIS
	FROM %table:SE3% SE3
	INNER JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
							  AND SA3.A3_COD = SE3.E3_VEND
							  AND SA3.%notDel%
	WHERE SE3.E3_FILIAL = %xfilial:SE3%
	AND SE3.E3_VEND BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SE3.E3_DATA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND SE3.%notDel%
	
	GROUP BY SE3.E3_VEND, SA3.A3_NOME
	ORDER BY SE3.E3_VEND
EndSql
*/

BeginSql alias cAlias
	SELECT	SE3.E3_VEND, SA3.A3_NOME, SUM(SE3.E3_BASE) AS BASE, SUM(SE3.E3_COMIS) AS COMIS
	FROM %table:SE3% SE3
	INNER JOIN %table:SA3% SA3 ON SA3.A3_COD = SE3.E3_VEND
							  AND SA3.%notDel%
	WHERE SE3.E3_VEND BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SE3.E3_DATA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
	AND SE3.%notDel%
	
	GROUP BY SE3.E3_VEND, SA3.A3_NOME
	ORDER BY SE3.E3_VEND
EndSql

COUNT TO nCount

cHtml := "<html>"
cHtml += "<head>"
cHtml += "<title>Comissão</title>"

cHtml += "<style>"

cHtml += "	body"
cHtml += "	{"
cHtml += "		font-family: 'Lucida Sans Unicode', 'Lucida Grande', 'Sans-Serif';"
cHtml += "		font-size: 14px;"	
cHtml += "	}"

cHtml += "	table"
cHtml += "	{"
cHtml += "		font-family: 'Lucida Sans Unicode', 'Lucida Grande', 'Sans-Serif';"
cHtml += "		font-size: 12px;"
cHtml += "		padding: 5px;"
cHtml += "		width: 100%;"
cHtml += "		text-align: left;"
cHtml += " 		border-collapse: collapse;"
cHtml += " 		border-bottom: 4px solid #ffc500;"
cHtml += "	}"

cHtml += "	table th"
cHtml += "	{"
cHtml += " 		font-size: 13px;"
cHtml += "		font-weight: normal;"
cHtml += " 		padding: 5px;"
cHtml += " 		background: #00963f;"
cHtml += "		border-top: 4px solid #ffc500;"
cHtml += "		border-bottom: 1px solid #fff;"
cHtml += " 		color: #fff;"
cHtml += "	}"

cHtml += "	table td"
cHtml += "	{"
cHtml += " 		padding: 5px;"
cHtml += " 		background: #02ff83; "
cHtml += " 		border-bottom: 1px solid #fff;"
cHtml += "		color: #000000;"
cHtml += " 		border-top: 1px solid transparent;"
cHtml += "	}"

cHtml += "	.foot"
cHtml += "	{"
cHtml += " 		font-size: 13px;"
cHtml += "		font-weight: bold;"
cHtml += " 		padding: 5px;"
cHtml += " 		background: #00963f;"
cHtml += "		border-top: 4px solid #ffc500;"
cHtml += "		border-bottom: 1px solid #fff;"
cHtml += " 		color: #fff;"
cHtml += "	}"

cHtml += "</style>"

cHtml += "</head>"
cHtml += "<body>"

cHtml += "<center>
cHtml += "<img alt='' src='http://mail.brascola.com.br/Logo%20Brascola%20vertical%202.jpg' width='306' height='215'/>"
cHtml += "<br>"

cAssunto := "Relação de Comissões"
cHtml += "<b>" + cAssunto + "</b>"

cHtml += "<br><br>"
cHtml += "</center>"			

cHtml += "<table>"
cHtml += "	<thead>"
cHtml += "		<tr>"
cHtml += "	   		<th scope='col' align='left'>Representante</th>"
cHtml += "	  		<th scope='col' align='right'>Vlr. Base (R$)</th>"
cHtml += "	  		<th scope='col' align='right'>Valor Comissão (R$)</th>"
cHtml += "		</tr>"
cHtml += "	</thead>"

dbSelectArea(cAlias)
dbGoTop()

If !(cAlias)->(Eof())

	nTotBase  := 0
	nTotComis := 0
	
	dbSelectArea(cAlias)
	dbGoTop()
	While !Eof()
	
		IncProc("Gerando e-mail para responsável...")
		
		cHtml += "	<tbody>"
		cHtml += "		<tr>"
		cHtml += "	   		<td align='left'>" + (cAlias)->E3_VEND + " - " + ALLTRIM((cAlias)->A3_NOME) + "</td>"
		cHtml += "	  		<td align='right'>" + TRANSFORM((cAlias)->BASE, "@E 9,999,999.99") + "</td>"
		cHtml += "	  		<td align='right'>" + TRANSFORM((cAlias)->COMIS, "@E 9,999,999.99") + "</td>"
		cHtml += "		</tr>"
		cHtml += "	</tbody>"		
		
		nTotBase  += (cAlias)->BASE
		nTotComis += (cAlias)->COMIS
		
		dbSelectArea(cAlias)
		(cAlias)->(dbSkip())
	EndDo
	
	cHtml += "	<tfoot>"
	cHtml += "		<tr"
	cHtml += "			<td class='foot' align='center'>Total geral..: </td>"
	cHtml += "	  		<td class='foot' align='right'>" + TRANSFORM(nTotBase, "@E 9,999,999.99") + "</td>"
	cHtml += "	  		<td class='foot' align='right'>" + TRANSFORM(nTotComis, "@E 9,999,999.99") + "</td>"
	cHtml += "		</tr>"
	cHtml += "	</tfoot>"
	
	cHtml += "</table>"		    
	cHtml += "</body>"
	cHtml += "</html>"
	
	//============================= Abre o servidor de e-mail =============================//
	oMail := tMailManager():New()
	nRet := 0           
	
	oMail:Init("", cServer, cAccount, cPassword)
	oMail:SetSMTPTimeout(60)
	
	nRet := oMail:SMTPConnect()
	
	If nRet != 0
		MsgStop(oMail:GetErrorString(nRet))
		Return
	Endif
	//======================================== Envia e-mail ========================================//
	nRet := oMail:SendMail(cFrom,cTo,cAssunto,cHtml,"",cFrom,{},0)
	
	If nRet != 0
		MsgStop(oMail:GetErrorString(nRet))
		oMail:SmtpDisconnect()
		Return
	Endif  
	//============================= Fecha o servidor de e-mail =============================//
	oMail:SmtpDisconnect()
EndIf

Return

//========================================= ENVIA E-MAIL PARA REPRESENTANTES =========================================//
Static Function fMailComis()

Local cVend     := ""
Local cHtml     := ""
Local cServer   := GetMv("MV_RELSERV")
Local cAccount  := GetMv("MV_RELACNT")
Local cFrom     := GetMv("MV_RELACNT")
Local cTo       := ""
Local cPassword := GetMv("MV_RELPSW")
Local cAssunto  := ""
Local cAlias    := ""

Local nTotBase  := 0
Local nTotComis := 0

//============================= Abre o servidor de e-mail =============================//
oMail := tMailManager():New()
nRet := 0           

oMail:Init("", cServer, cAccount, cPassword)
oMail:SetSMTPTimeout(60)

nRet := oMail:SMTPConnect()

If nRet != 0
	MsgStop(oMail:GetErrorString(nRet))
	Return
Endif

//============================= Monta HTML para envio =============================//
dbSelectArea("SA3")
ProcRegua(RecCount())
dbSetOrder(1)
dbGoTop()
dbSeek(xFilial("SA3")+MV_PAR01,.T.)
While !Eof() .And. SA3->A3_FILIAL == xFilial("SA3");
			 .And. SA3->A3_COD >= MV_PAR01;
			 .And. SA3->A3_COD <= MV_PAR02

	IncProc("Gerando e-mail para vendedores...")

	cVend := SA3->A3_COD
	cAlias := GetNextAlias()
	
	BeginSql alias cAlias
		SELECT	SE3.E3_EMISSAO, SE3.E3_CODCLI, SE3.E3_LOJA, SA1.A1_NOME,
				 SE3.E3_PEDIDO, SE3.E3_BASE, SE3.E3_PORC, SE3.E3_COMIS, SE3.E3_VENCTO
		FROM %table:SE3% SE3
		INNER JOIN %table:SA1% SA1 ON SA1.A1_COD = SE3.E3_CODCLI
								  AND SA1.A1_LOJA = SE3.E3_LOJA
								  AND SA1.%notDel%
		WHERE SE3.E3_VEND = %exp:cVend%
		AND SE3.E3_DATA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%
		AND SE3.%notDel%
		
		ORDER BY SE3.E3_VEND, SE3.E3_EMISSAO
	EndSql  
	
	aquery := getlastquery()

	If !(cAlias)->(Eof())
		cHtml := "<html>"
		cHtml += "<head>"
		cHtml += "<title>Comissão</title>"
		
		cHtml += "<style>"

		cHtml += "	body"
		cHtml += "	{"
		cHtml += "		font-family: 'Lucida Sans Unicode', 'Lucida Grande', 'Sans-Serif';"
		cHtml += "		font-size: 14px;"	
		cHtml += "	}"

		cHtml += "	table"
		cHtml += "	{"
		cHtml += "		font-family: 'Lucida Sans Unicode', 'Lucida Grande', 'Sans-Serif';"
		cHtml += "		font-size: 12px;"
		cHtml += "		padding: 5px;"
		cHtml += "		width: 100%;"
		cHtml += "		text-align: left;"
		cHtml += " 		border-collapse: collapse;"
		cHtml += " 		border-bottom: 4px solid #ffc500;"
		cHtml += "	}"

		cHtml += "	table th"
		cHtml += "	{"
		cHtml += " 		font-size: 13px;"
		cHtml += "		font-weight: normal;"
		cHtml += " 		padding: 5px;"
		cHtml += " 		background: #00963f;"
		cHtml += "		border-top: 4px solid #ffc500;"
		cHtml += "		border-bottom: 1px solid #fff;"
		cHtml += " 		color: #fff;"
		cHtml += "	}"

		cHtml += "	table td"
		cHtml += "	{"
		cHtml += " 		padding: 5px;"
		cHtml += " 		background: #02ff83; "
		cHtml += " 		border-bottom: 1px solid #fff;"
		cHtml += "		color: #000000;"
		cHtml += " 		border-top: 1px solid transparent;"
		cHtml += "	}"

		cHtml += "	.foot"
		cHtml += "	{"
		cHtml += " 		font-size: 13px;"
		cHtml += "		font-weight: bold;"
		cHtml += " 		padding: 5px;"
		cHtml += " 		background: #00963f;"
		cHtml += "		border-top: 4px solid #ffc500;"
		cHtml += "		border-bottom: 1px solid #fff;"
		cHtml += " 		color: #fff;"
		cHtml += "	}"

		cHtml += "</style>"
		
		cHtml += "</head>"
		cHtml += "<body>"
		
		cHtml += "<center>
		cHtml += "<img alt='' src='http://mail.brascola.com.br/Logo%20Brascola%20vertical%202.jpg' width='306' height='215'/>"
		cHtml += "<br>"

		cAssunto := "Relação de Comissões Ref. "
		cAssunto += SUBSTR(DTOS(MV_PAR03),5,2) + "/" + SUBSTR(DTOS(MV_PAR03),1,4)  //Mês de referência
		cAssunto += " - " + SA3->A3_COD + " - " + ALLTRIM(SA3->A3_NOME)

		cHtml += "<b>" + cAssunto + "</b>"
		
		cHtml += "<br><br>"
		cHtml += "</center>"			

		cHtml += "<table>"
		cHtml += "	<thead>"
		cHtml += "		<tr>"
		cHtml += "			<th scope='col' align='center'>Data</th>"
		cHtml += "	   		<th scope='col' align='left'>Cliente</th>"
		cHtml += "	  		<th scope='col' align='left'>Pedido</th>"
		cHtml += "	  		<th scope='col' align='right'>Vlr. Base (R$)</th>"
		cHtml += "	  		<th scope='col' align='right'>% Comissão</th>"
		cHtml += "	  		<th scope='col' align='right'>Valor Comissão (R$)</th>"
		cHtml += "	  		<th scope='col' align='center'>Vencimento</th>"
		cHtml += "		</tr>"
		cHtml += "	</thead>"
		
		nTotBase  := 0
		nTotComis := 0
		
		dbSelectArea(cAlias)
		dbGoTop()
		While !Eof()
	
			cHtml += "	<tbody>"
			cHtml += "		<tr>"
			cHtml += "			<td align='center'>" + DTOC(STOD((cAlias)->E3_EMISSAO)) + "</td>"
			cHtml += "	   		<td align='left'>" + (cAlias)->E3_CODCLI + "/" + (cAlias)->E3_LOJA + " - " + ALLTRIM((cAlias)->A1_NOME) + "</td>"
			cHtml += "	  		<td align='left'>" + (cAlias)->E3_PEDIDO + "</td>"
			cHtml += "	  		<td align='right'>" + TRANSFORM((cAlias)->E3_BASE, "@E 9,999,999.99") + "</td>"
			cHtml += "	  		<td align='right'>" + TRANSFORM((cAlias)->E3_PORC, "@R 999.99%") + "</td>"
			cHtml += "	  		<td align='right'>" + TRANSFORM((cAlias)->E3_COMIS, "@E 9,999,999.99") + "</td>"
			cHtml += "	  		<td align='center'>" + DTOC(STOD((cAlias)->E3_VENCTO)) + "</td>"
			cHtml += "		</tr>"
			cHtml += "	</tbody>"		
	
			nTotBase  += (cAlias)->E3_BASE
			nTotComis += (cAlias)->E3_COMIS
			
			dbSelectArea(cAlias)
			(cAlias)->(dbSkip())
		EndDo

		cHtml += "	<tfoot>"
		cHtml += "		<tr"
		cHtml += "			<td class='foot' colspan=3 align='center'>Total geral..:</td>"
		cHtml += "	  		<td class='foot' align='right'>" + TRANSFORM(nTotBase, "@E 9,999,999.99") + "</td>"
		cHtml += "	  		<td class='foot' align='right'>&nbsp;</td>"
		cHtml += "	  		<td class='foot' align='right'>" + TRANSFORM(nTotComis, "@E 9,999,999.99") + "</td>"
		cHtml += "	  		<td class='foot' align='center'>&nbsp;</td>"
		cHtml += "		</tr>"
		cHtml += "	</tfoot>"
		
		cHtml += "</table>"
		cHtml += "</body>"
		cHtml += "</html>"
	
		//======================================== Envia e-mail ========================================//
		cTo := SA3->A3_EMAIL
		nRet := oMail:SendMail(cFrom,cTo,cAssunto,cHtml,"",cFrom,{},0)
		
		If nRet != 0
			MsgStop(oMail:GetErrorString(nRet))
			oMail:SmtpDisconnect()
			Return
		Endif
	EndIf
	
	dbSelectArea("SA3")
	SA3->(dbSkip())
EndDo
//============================= Fecha o servidor de e-mail =============================//
oMail:SmtpDisconnect()

Return

//========================================= Cria Perguntas =========================================//
Static Function fCriaPerg(cPerg)

PutSX1(cPerg, "01", "Vendedor de"        , "", "", "mv_ch1", "C", TAMSX3("A3_COD")[1] , 0, 0, "G", "","SA3", "", "", "mv_par01", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "02", "Vendedor ate"       , "", "", "mv_ch2", "C", TAMSX3("A3_COD")[1] , 0, 0, "G", "","SA3", "", "", "mv_par02", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "03", "Pagamento de"       , "", "", "mv_ch3", "D", TAMSX3("D2_EMISSAO")[1] , 0, 0, "G", "", , "", "", "mv_par03", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "04", "Pagamento ate"      , "", "", "mv_ch4", "D", TAMSX3("D2_EMISSAO")[1] , 0, 0, "G", "", , "", "", "mv_par04", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "05", "E-mail responsavel" , "", "", "mv_ch5", "C", 99                      , 0, 0, "G", "", , "", "", "mv_par05", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "06", "Envia p/ Vend?"     , "", "", "mv_ch6", "N", 1                       , 0, 0, "C", "", , "", "", "mv_par06", "Sim","","","","Não","","","","","","","","","","","")

Return