#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

//DESENVOLVIDO POR INOVEN


User Function M410STTS()

**********************
//Local cCli,cLoja,cFat,LRet,cTransp,cProd,cTipo
Local nPos1,nPos2,nPos3,nQuantVen,nQuantLib
LOCAL nMargemPv	:= {}	//0
Local nOpc := PARAMIXB[1]

nPos1	:= nPos2 := nPos3 := nQuantVen	:= nQuantLib:= 0
LRet    := lRet2 := .T.

If ((Inclui) .or. (Altera)) .and. SC5->C5_TIPO == 'N'

	/*if (Altera)

		nTotTab := 0
		SC6->(msSeek(FWxFilial('SC6') + SC5->C5_NUM, .T.))
		While !SC6->(EoF()) .And. SC6->C6_FILIAL == FWxFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM
			//nTotTab += SC6->C6_QTDVEN * iif(empty(SC6->C6_PRUNIT),SC6->C6_PRCVEN,SC6->C6_PRUNIT)
			nTotTab += SC6->C6_QTDVEN * SC6->C6_PRCVEN
			SC6->(DbSkip())
		EndDo
		nTotDD := nTotTab - SC5->C5_ZDESITE	//valor total com desconto

		//Atualiza campo pre�o especifico
		SC6->(msSeek(FWxFilial('SC6') + SC5->C5_NUM, .T.))
		While !SC6->(EoF()) .And. SC6->C6_FILIAL == FWxFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM

			nInd := iif(empty(SC6->C6_PRUNIT),SC6->C6_PRCVEN,SC6->C6_PRUNIT) / nTotTab
			//nInd := iif(empty(SC6->C6_XTABPRC),SC6->C6_PRCVEN,SC6->C6_XTABPRC) / nTotTab
			nPrcDD := iif(!empty(SC5->C5_ZDESITE),Round(nTotDD * nInd, 2), 0)

			SC6->(recLock('SC6', .F.))
			//if empty(SC5->C5_ZDESITE) .or. empty(SC6->C6_PRUNIT)
				SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
			//endif
			//SC6->C6_PRUNIT	:= SC6->C6_PRCVEN
			SC6->C6_XTABPRC := iif(empty(SC6->C6_XTABPRC),SC6->C6_PRCVEN,SC6->C6_XTABPRC)
			SC6->C6_PRCVEN	:= iif(SC6->C6_PRCVEN <> nPrcDD .and.!empty(SC5->C5_ZDESITE), nPrcDD, SC6->C6_PRCVEN)
			SC6->C6_VALOR	:= Round(SC6->C6_QTDVEN * SC6->C6_PRCVEN, 2)
			SC6->(msUnlock())

			SC6->(DbSkip())
		EndDo

		SC5->(RECLOCK("SC5", .F.))
		SC5->C5_ZVALBRU := nTotTab
		SC5->C5_ZVALTOT := nTotDD
		SC5->(MSUNLOCK())
	endif*/

	U_IRENT020(SC5->C5_NUM, @nMargemPV)
	/*If nMargemPV[1] < GetMv('TG_MARGEM',.F.,40)

		//dbselectarea("SC5")
		RECLOCK("SC5", .F.)
		SC5->C5_XMOTBLQ := '01'
		SC5->C5_BLQ     := '1'
		SC5->(MSUNLOCK())
		//Grava status no pedido
		u_DnyGrvSt(SC5->C5_NUM, "000045")
		MsgAlert(OemToAnsi('Pedido bloqueado por rentabilidade. Favor solicitar analise da gerencia'))
	EndIf*/
	If Select("QRYZM1") <> 0
		QRYZM1->(dbCloseArea())
	EndIf

	BeginSQL Alias "QRYZM1"
	SELECT
		ZM1_COR, ZM1_BLQ
	FROM 
		%Table:ZM1% ZM1
	WHERE
		ZM1.%NotDel%
		AND %exp:nMargemPV[1]% >= ZM1_MARGI 
		AND %exp:nMargemPV[1]% < ZM1_MARGF
	EndSql
	if QRYZM1->ZM1_BLQ == 'S' .or. nMargemPV[1] < 0
		SC5->(RECLOCK("SC5", .F.))
		SC5->C5_XMOTBLQ := '01'
		SC5->C5_BLQ     := '1'
		SC5->(MSUNLOCK())
		//Grava status no pedido
		u_DnyGrvSt(SC5->C5_NUM, "000045")
		MsgAlert(OemToAnsi('Pedido bloqueado por rentabilidade. Favor solicitar analise da gerencia'))
	endif

Endif 

If (nOpc == 4 .Or. nOpc == 5) .And. !Empty(SC5->C5_XPEDPGT)
    //--Envia e-mail 
    FEnvEmail()
	RecLock('SC5',.F.)
		Replace SC5->C5_XPEDPGT With ''
        Replace SC5->C5_XLINKPG With ''
        Replace SC5->C5_XSTSCAR With ''
    SC5->(MsUnLock())
    MsgAlert(OemToAnsi('Necessario reenviar o link!!'))
EndIf

Return(lRet)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FEnvEmail
Função envia email

@author		.iNi Sistemas
@since     	10/10/2020
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterções Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Moti                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FEnvEmail()

Local cServer     := AllTrim(GetMv("MV_RELSERV"))
Local cAccount    := AllTrim(GetMv("MV_RELACNT"))
Local cPassword   := AllTrim(GetMv("MV_RELPSW"))
Local cTo		  := GetMv("TG_EMLINK",.F.,"")
Local cSubject	  := ""
Local cBody		  := ""
Local cAttachment := ""
Local lConnect    := .F.
Local lEnviou     := .F.
Local lRet        := .T.         

cSubject := "Cancelamento de link de pegamento "
cBody    := "Necessario cancelar o link de pagamento referente ao pedido:  "+SC5->C5_XPEDPGT + Chr(13)+Chr(10)
cBody    += "Link = "+ SC5->C5_XLINKPG
	
If ! Empty(cServer) .And. ! Empty(cAccount) .And. ! Empty(cTo)

   //Realiza conexao com o Servidor
   CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect

	If lConnect
	   // Se existe autenticacao para envio valida pela funcao MAILAUTH
	   lRet := Mailauth(cAccount,cPassword) 
	      
	   If lConnect //Se conseguiu Conexao ao Servidor SMTP
	      SEND MAIL FROM cAccount TO cTo SUBJECT cSubject BODY cBody RESULT lEnviou ATTACHMENT cAttachment      
	      If !lEnviou //Se conseguiu Enviar o e-Mail
	         lRet:=.f.
	      EndIf
	   Else
	      lRet:=.f.   
	   EndIf      
	EndIf
	   
   If lRet
      DISCONNECT SMTP SERVER
   EndIf
EndIf

Return()
