#Include "Protheus.ch"
#Include "TopConn.ch"                        
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOTVS.CH'   
#include 'RWMAKE.CH'
#include 'PROTHEUS.CH'
#include 'TBICONN.CH'
#include 'TBICODE.CH' 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA450R  ºAutor  ³ Fabio Luiz Gesser  º Dat ³  24/07/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para gravacao do status e historico quando o pedido for º±±
±±º          ³ rejeitado                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA450                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN


User Function MTA450R()
***********************
Local aArea	  := GetArea()
Local oHisTit, oHisDes, oHisDth, oHisHor, oHisDta, oHisUsr, oHisRep, oHisRaz, oHisCon, oHisFor, oHisHis, oDlgHInc, oHisCel, oHisNce
Local cTitulo := SPACE(06)
Local cDescric:= SPACE(40)
Local dDtHist := dDatabase
Local cHora   := Time()
Local dDtAgen := dDatabase
Local cUser   := cUserName
Local cRepres := SA1->A1_VEND
Local cNomRep := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME")
Local cContato:= SPACE(30)
Local cForma  := SPACE(30)
Local cHistor := SPACE(900)
Local cCelula := SA1->A1_CELULA
Local cNomCel :=''//Posicione("Z01",1,xFilial("Z01")+SA1->A1_CELULA,"Z01_REGIA")

cQuery := "SELECT COUNT(*) TEMREJ "
cQuery += "FROM "+RetSqlName("Z05")+" Z05 "
cQuery += "WHERE Z05.Z05_FILIAL = '"+xFilial("Z05")+"' "
cQuery += "AND   Z05.Z05_PEDIDO = '"+SC9->C9_PEDIDO+"' "
cQuery += "AND   Z05.Z05_DATA   = '"+Dtos(dDatabase)+"' "
cQuery += "AND   Z05.Z05_STATUS = '000042' "
cQuery += "AND   Z05.D_E_L_E_T_ <> '*' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

//IF TRB->TEMREJ > 0

//   RestArea(aArea)

//   Return()
//Endif

//If Select("TRB") > 0
//   dbSelectArea("TRB")
//   dbCloseArea()
//EndIf


u_DnyGrvSt(SC9->C9_PEDIDO, "000042")  // Grava Status do pedido rejeitado



DEFINE MSDIALOG oDlgHInc TITLE "Histórico da Rejeição" FROM C(000),C(000)  TO C(350),C(900) COLORS 0, 16777215 PIXEL

@ C(007),C(005) SAY oSayHis01 PROMPT "Titulo:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(022),C(005) SAY oSayHis02 PROMPT "Data Histórico:"           SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(022),C(200) SAY oSayHis03 PROMPT "Hora:"                     SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(022),C(320) SAY oSayHis04 PROMPT "Usuario:"                  SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(037),C(005) SAY oSayHis05 PROMPT "Data Agendamento:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(037),C(200) SAY oSayHis06 PROMPT "Representante:"            SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(052),C(005) SAY oSayHis07 PROMPT "Contato Empresa:"          SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(052),C(200) SAY oSayHis08 PROMPT "Forma de Contato:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(067),C(005) SAY oSayHis09 PROMPT "Histórico"                 SIZE C(105),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(067),C(200) SAY oSayHis10 PROMPT "Celula:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(007),C(055) MSGET oHisTit  VAR cTitulo  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SZC" VALID VldTit(cTitulo,@cDescric)
@ C(007),C(100) MSGET oHisDes  VAR cDescric                      SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(022),C(055) MSGET oHisDth  VAR dDtHist  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
@ C(022),C(250) MSGET oHisHor  VAR cHora    PICTURE '99:99'      SIZE C(030),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
@ C(022),C(360) MSGET oHisUsr  VAR cUser    PICTURE '@!'         SIZE C(085),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(037),C(055) MSGET oHisDta  VAR dDtAgen  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
@ C(037),C(250) MSGET oHisRep  VAR cRepres  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SA3" WHEN .F.
@ C(037),C(295) MSGET oHisRaz  VAR cNomRep  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(052),C(055) MSGET oHisCon  VAR cContato PICTURE '@!'         SIZE C(140),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(052),C(250) MSGET oHisFor  VAR cForma   PICTURE '@!'         SIZE C(195),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(067),C(250) MSGET oHisCel  VAR cCelula  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "Z01" WHEN .F.
@ C(067),C(295) MSGET oHisNCe  VAR cNomCel  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

@ C(080),C(005) GET   oHisHis  VAR cHistor MEMO 	             SIZE C(440),C(063) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(147),C(280) BUTTON oButton1 PROMPT "&Confirma"               SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=1,oDlgHInc:End()) PIXEL
@ C(147),C(360) BUTTON oButton1 PROMPT "&Sair"                   SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=0,oDlgHInc:End()) PIXEL

ACTIVATE MSDIALOG oDlgHInc CENTERED

IF nOpca == 1
	RecLock("SZB",.T.)
	SZB->ZB_FILIAL  := xFilial("SZB")
	SZB->ZB_CLIENTE := SC9->C9_CLIENTE
	SZB->ZB_LOJA    := SC9->C9_LOJA
	SZB->ZB_TITULO  := cTitulo
	SZB->ZB_DTHIST  := dDtHist
	SZB->ZB_HORA    := cHora
	SZB->ZB_DTAGEN  := dDtAgen
	SZB->ZB_USER    := cUser
	SZB->ZB_RESPRES := cRepres
	SZB->ZB_CONTATO := cContato
	SZB->ZB_FORMA   := cForma
	SZB->ZB_HISTOR  := cHistor
	SZB->ZB_CELULA  := cCelula
	MsUnLock()
	
	DBSELECTAREA("SC9")
	DBSETORDER(1)
	Dbseek(xfilial("SC9")+SC9->C9_PEDIDO)
	cPedido:=SC9->C9_PEDIDO
	
	While ( !SC9->(Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cPedido )
	    
	    DBSELECTAREA("SC9")
		RecLock("SC9",.F.)
		SC9->C9_BLCRED := "09"
		MsUnlock()	
		//SC9->(MsGoto(SC9->(RECNO())))
		//a450Grava(2,.T.,.F.)
		SC9->(DBSKIP())
	ENDDO
	
	
	//aEstLibPv(SC9->C9_FILIAL,SC9->C9_PEDIDO)
		_cQuery1 := " UPDATE "+RetSqlName("Z05")
		   				_cQuery1 += " SET Z05_DESC = convert(varbinary(max),'"+AllTrim(cHistor)+"')"
						_cQuery1 += " FROM "+RetSqlName("Z05")+" Z05 "
						_cQuery1 += " WHERE  Z05.D_E_L_E_T_ <> '*' "
						_cQuery1 += "    AND Z05.Z05_PEDIDO = '" +SC5->C5_NUM+ "' AND  Z05.Z05_STATUS = '000042' and Z05_FILIAL = '"+xFilial("Z05")+"'"
					
						//cQuery := "insert "+RetSqlName("Z05")+"	(Z05_STATUS,Z05_DESC,							Z05_PEDIDO,			Z05_DATA,			Z05_HORA,	Z05_NOMUSU)"
					//cQuery += "						values	('000048',convert(varbinary(max),'"+AllTrim(cJustif)+"'),'"+SC5->C5_NUM+"','"+dtos(dDataBase)+"','"+substr(Time(),1,5)+"','"+UsrRetName(__cUserID)+"')"
					TcSqlExec(_cQuery1)			
	

		FSEmail(SC5->C5_NUM,cHistor)



ENDIF

IF nOpca <> 1

	DBSELECTAREA("SC9")
	DBSETORDER(1)
	Dbseek(xfilial("SC9")+SC9->C9_PEDIDO)
	cPedido:=SC9->C9_PEDIDO
	
	While ( !SC9->(Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cPedido )
		
		IF SC9->C9_BLCRED == '09'
			DBSELECTAREA("SC9")
			RecLock( "SC9", .F. )
			SC9->C9_BLCRED:= '01'
			SC9->(MSUNLOCK())
		ENDIF
		SC9->(DBSKIP())
	
	ENDDO
	
	
	//aEstLibPv(SC9->C9_FILIAL,SC9->C9_PEDIDO)
	
	
ENDIF



RestArea(aArea)

Return()

Static Function VldTit(cTitulo,cDescric)
*****************************************
cDescric := SPACE(40)

SELECT SZC
DBSETORDER(1)
DBSEEK(xFilial("SZC")+cTitulo)
IF cTitulo <> SPACE(6)
	IF EOF()
		MsgAlert("Titulo não Cadastrado!")
		Return .F.
	ELSE
		cDescric := SZC->ZC_DESCRIC
		Return .T.
	ENDIF
ENDIF
Return


/**************************************************************************************************/
/*/{Protheus.doc} aEcEstLibPv

@description   Estorna a liberação do pedido de venda

@type   	   Function
@author		   ALFA ERP
@version   	   1.00
@since     	   10/02/2016

@param			cPedido		, Numero do Pedido de Venda gerado pelo e-Commerce

@return			lRet 		, Retorno da operação True 	- Sucesso False - Erro

/*/
/**************************************************************************************************/
Static Function aEstLibPv(cFilPed,cPedido)

Local aArea	:= GetArea()

//------------------+
// Posiciona Pedido |
//------------------+
dbSelectArea("SC9")
SC9->( dbSetOrder(1) )
If SC9->( dbSeek(cFilPed + cPedido ) )
	While SC9->( !Eof() .And. cFilPed + cPedido == SC9->( C9_FILIAL + C9_PEDIDO ) )
		If Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_SERIENF)
			//--------------------------+
			// Estorna Liberação Pedido |
			//--------------------------+
			a460Estorna(.T.,.F.)
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)

Return .T.

Static Function FSEmail(_PEDIDO,_HIST)
	
	Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
	Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
	Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
   	Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
   	Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
	Local lConnect  := .F.
	Local lEnviou   := .F.
	Local lRet      := .T.
	Local cError	:= ''
	//Local cEmailTi	:= ''         
	Local cTo		:= ''
	Local cSubject	:= 'PEDIDO REJEITADO CREDITO'
	Local cCorpo	:= ''
	//Local cEmail	:= ''
	//Local nPosPrd	:= 0
	Local cAnexos	:= ''	
	//Local lRet		:= .F.
	//--Limpa variavel
	cCorpo:=''
	//Atualiza variavel
	cBody:= 'PEDIDO: ' + SC5->C5_NUM + ' REJEITADO POR CREDITO E MOTIVO: ' +_HIST
	
	//--Valida se retornou email
	cTo:= Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_XEMADM')
   	//cTo:= 'charlesbattisti@gmail.com'
 	//--Enviando Email(s)
	If !Empty(cServer) .And. !Empty(cAccount) .And. !Empty(cTo)
		//Realiza conexao com o Servidor
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
		//--Verifica se existe autenticação
		If lRelauth
			lRet := Mailauth(cAccount,cPassword)        
		EndIf
		//--Se conseguiu Conexao ao Servidor SMTP	
		If lConnect 
			SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAnexos RESULT lEnviou													
			If !lEnviou //Se conseguiu Enviar o e-Mail
				lRet:=.F.
				//Erro no envio do email
				GET MAIL ERROR cError
				ConOut("Erro de autenticação","Verifique a conta e a senha para envio",cError)
			EndIf
		Else
			lRet:=.F.
			GET MAIL ERROR cError
			ConOut("Erro de autenticação","Verifique a conta e a senha para envio ",cError)
		EndIf      	   
		If lRet
			DISCONNECT SMTP SERVER
		EndIf
	EndIf
	
	If lRet
		//--Mensagem de envio
		MsgBox("Email(s) enviado(s) com sucesso","","INFO")
	EndIf	

Return(lRet)
