#include "rwmake.ch"
#include "topconn.ch"

#define MBF_INBOX	 	 "\inbox"
#define MBF_ARCHIVE	 "\archive"
#define MBF_IGNORED	 "\ignored"

STATIC __lBlind := IsBlind()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATJ011 ºAutor  ³ Marcelo da Cunha   º Data ³  28/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job para execucao do retorno dos e-mails enviados para con º±±
±±º          ³ ta padrao da Brascola.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATJ011()
**********************
LOCAL oMail, oMsg, aArqs, lArqOk, __nn, cNomArq, cMailBx, cDir, aInfoEmail
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abro arquivos necessarios                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
conout("=======================================================")
conout("> BFATJ011 - Download e processamento de e-mails: "+dtoc(MsDate())+" "+Time())
If (Type("oMainWnd") == "U")
	RpcSetType(3)
	RPCSetEnv("01","01","","","COM","",{"SB1","SC7","SCR","CTT"})
Endif
cMailBx := GetMV("MV_WFMLBOX") //Nome da Caixa do Workflow

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Baixo os e-mails para caixa de entrada para processar                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMail := TWFMail():New()
oMailBox := oMail:GetMailBox(cMailBx)
oMailBox:Receive() //Baixar E-mails
cDir := "\"+dtos(MsDate())
oInboxFolder := oMailBox:GetFolder(MBF_INBOX)
oArchFolder  := oMailBox:NewFolder(MBF_ARCHIVE+cDir)
oIgnoFolder  := oMailBox:NewFolder(MBF_IGNORED+cDir)
aArqs := oInboxFolder:GetFiles("*.eml")
For __nn := 1 to Len(aArqs)
	lArqOk := .F.
	cNomArq := aArqs[__nn,1]
	If oInboxFolder:FileExists(cNomArq)
		conout("> BFATJ011 - Processando arquivo: "+cNomArq)
		lError := .F.
		bLastError := ErrorBlock( { |e| lError:=.T. } )
		BEGIN SEQUENCE
		oMsg := TMailMessage():New()
		oInboxFolder:LoadFile(cNomArq,@oMsg)
		aInfoEmail := {"",Space(4),Space(6)}
		If BGetInfoMail(oMsg,@aInfoEmail)
			lArqOk := !Empty(aInfoEmail[1]).and.!Empty(aInfoEmail[3]).and.BConfPedido(aInfoEmail)   
		Endif
		If (lArqOk)
			oInboxFolder:MoveFiles(cNomArq,oArchFolder) //Arquivo Arquivo
			conout("> BFATJ011 - Arquivo processado e arquivado com sucesso: "+cNomArq)
		Else
			oInboxFolder:MoveFiles(cNomArq,oIgnoFolder) //Arquivos Ignorados
			conout("> BFATJ011 - Arquivo ignorado: "+cNomArq)
		Endif
		END SEQUENCE
		ErrorBlock(bLastError)
	Endif
Next __nn

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finalizo processamento                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
conout("> BFATJ011 - Fim do processo de e-mails: "+dtoc(MsDate())+" "+Time())
conout("=======================================================")

Return
                                
Static Function BConfPedido(xInfoEmail)
***********************************
LOCAL lRetu := .F., __nx, cSegEmp := cEmpAnt, cSegFil := cFilAnt, lJaConf := .F., lNaoAut := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro arquivos da empresa que precisa ser atualizada     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(xInfoEmail[2])
	BChgEmpFil(Substr(xInfoEmail[2],1,2),Substr(xInfoEmail[2],3,2))
Endif
                                                                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se email do cliente pode confirmar pedido           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SC5->(dbSetOrder(1)) ; SA1->(dbSetOrder(1))
If SC5->(dbSeek(xFilial("SC5")+xInfoEmail[3]))
	SA1->(dbSeek(xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,.T.))
	If !(xInfoEmail[1] $ lower(SA1->A1_email))
		lNaoAut := .T.
	Elseif !Empty(SC5->C5_dthrcon)
		lJaConf := .T.
	Elseif (xInfoEmail[1] $ lower(SA1->A1_email))
		Reclock("SC5",.F.)
		SC5->C5_dthrcon := dtos(MsDate())+StrTran(Time(),":","")
		MsUnlock("SC5")
		lRetu := .T.	
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envio e-mail com status do processamento                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (lRetu)
	cTitulo := "CONFIRMAÇÃO - Pedido de Venda "+xInfoEmail[3]+" confirmado com sucesso"
	cTexto  := "CONFIRMAÇÃO - Pedido de Venda "+xInfoEmail[3]+" confirmado com sucesso."
	cEmail  := xInfoEmail[1] //Email para devolver
	u_GDVWFAviso("AVIPED","100001",cTitulo,cTexto,cEmail)	
Elseif (lNaoAut)
	cTitulo := "ATENÇÃO - Não autorizado a confirmar o Pedido de Venda "+xInfoEmail[3]
	cTexto  := "ATENÇÃO - Não autorizado a confirmar o Pedido de Venda "+xInfoEmail[3]+"."
	cEmail  := xInfoEmail[1] //Email para devolver
	u_GDVWFAviso("AVIPED","100002",cTitulo,cTexto,cEmail)	
Elseif (lJaConf)
	cTitulo := "ATENÇÃO - Pedido de Venda "+xInfoEmail[3]+" já foi confirmado anteriormente"
	cTexto  := "ATENÇÃO - Pedido de Venda "+xInfoEmail[3]+" já foi confirmado anteriormente."
	cEmail  := xInfoEmail[1] //Email para devolver
	u_GDVWFAviso("AVIPED","100002",cTitulo,cTexto,cEmail)	
Else
	cTitulo := "ATENÇÃO - Pedido de Venda "+xInfoEmail[3]+" não foi confirmado"
	cTexto  := "ATENÇÃO - Pedido de Venda "+xInfoEmail[3]+" não foi confirmado."
	cEmail  := xInfoEmail[1] //Email para devolver
	u_GDVWFAviso("AVIPED","100002",cTitulo,cTexto,cEmail)	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restauro variaveis compartilhadas antes de retornar          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
BChgEmpFil(cSegEmp,cSegFil)

Return lRetu

Static Function BGetInfoMail(oMsg,xInfoEmail)
****************************************
LOCAL lRetu := .F., na, nb, nPos, cAux
LOCAL cAttach := "", cAssunto := "", cDestino := ""
LOCAL aToken := {"#confirmacao","#confirmado"} //Token de Confirmacao
If (oMsg != nil)
	xInfoEmail[1] := BFormatEmail(oMsg:cFrom) //E-mail origem
	nPos := AT("EMPFIL",oMsg:cSubject)
	If (nPos > 0)
		xInfoEmail[2] := Substr(oMsg:cSubject,nPos+6,4) //Empresa+Filial
	Endif
	nPos := AT("PEDVEN",oMsg:cSubject)
	If (nPos > 0)
		xInfoEmail[3] := Substr(oMsg:cSubject,nPos+6,6) //Pedido de Compra
	Endif	
	If (oMsg:GetAttachCount() == 0)
		cRetu := oMsg:cBody
	Else
		For na := 1 to oMsg:GetAttachCount()
			If ("octet-stream" $ Lower(oMsg:GetAttachInfo(na)[2]))
				cAttach := oMsg:GetAttach(na)
				BFormatText(@cAttach,@cDestino)
				If !Empty(cAttach)
					For nb := 1 to Len(aToken) 
						If ((nPos := AT(aToken[nb],cAttach)) > 0)
							lRetu := .T.
							Exit
						Endif
					Next nb
				Endif
			Endif
			If (lRetu)
				Exit
			Endif			
		Next na
	Endif
	If (!lRetu)
		cAssunto := Alltrim(lower(oMsg:cSubject))
		If !Empty(xInfoEmail[1]).and.!Empty(xInfoEmail[2]).and.!Empty(xInfoEmail[3])
			cTitulo := "ATENÇÃO - Confirmação Pedido de Venda: "+xInfoEmail[3]
			cTexto := "Sua resposta não foi reconhecida pelo sistema. Favor confirmar novamente."
			cEmail := xInfoEmail[1] //Email para devolver
			u_GDVWFAviso("AVIPED","100004",cTitulo,cTexto,cEmail)
		Elseif ("undeliverable" $ cAssunto) //Email nao entregue
			cTitulo := "ATENÇÃO - E-mail não entregue: "
			cTexto := "E-mail não foi entrege para o destinatário <b>"+cDestino+"</b>"
			cEmail := GetMV("BR_000049") //E-mail que ira receber os retornos com e-mails nao entregues
			u_GDVWFAviso("AVIPED","100005",cTitulo,cTexto,cEmail)
		Endif
	Endif
Endif
Return lRetu                   

Static Function BChgEmpFil(xCodEmp,xCodFil)
***************************************
If !Empty(xCodEmp).and.(xCodEmp != cEmpAnt) //Trocar Empresa
	dbCloseAll()                        
	cArqTab := ""
	cEmpAnt := xCodEmp
	cFilAnt := xCodFil
	OpenSM0(cEmpAnt+cFilAnt)
	OpenFile(cEmpAnt+cFilAnt)
Elseif !Empty(xCodFil).and.(xCodFil != cFilAnt) //Trocar Filial
	cEmpAnt := xCodEmp
	cFilAnt := xCodFil
	OpenSM0(cEmpAnt+cFilAnt)
Endif
Return

Static Function BFormatEmail(xEmail)
*********************************
LOCAL nn, nPos := 0, cRetu := Alltrim(Lower(xEmail))
For nn := Len(cRetu) to 1 step -1
	If Empty(Substr(cRetu,nn,1)).or.(Substr(cRetu,nn,1) == "<")
		nPos := nn
		Exit
	Endif
Next nn
If (nPos > 0)
	cRetu := Alltrim(Substr(cRetu,nPos+1))
	cRetu := StrTran(cRetu,"<","") 
	cRetu := StrTran(cRetu,">","")
Endif
Return cRetu

Static Function BFormatText(xConteudo,xDestino)
*******************************************
LOCAL nn, nPos := 0, cAux := Alltrim(Lower(xConteudo))
LOCAL aSepara := {"<blockquote","<q>","--- mensagem original ---"}
If ((nPos := AT("<html",cAux)) > 0)
	For nn := 1 to Len(aSepara)
		If ((nPos := AT(aSepara[nn],cAux)) > 0)
			cAux := Substr(cAux,1,nPos-1)
			Exit
		Endif
	Next nn
	xConteudo := cAux
	If Empty(xDestino)
		If ((nPos := AT("to:",xConteudo)) > 0)
			xDestino := Substr(xConteudo,nPos,50)
			xDestino := StrTran(xDestino,"<","") 
			xDestino := StrTran(xDestino,">","")
		Endif
	Endif
Endif
Return