#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE 'TOTVS.CH'   
#include 'RWMAKE.CH'
#include 'PROTHEUS.CH'
#include 'TBICONN.CH'
#include 'TBICODE.CH' 
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} IFATM030
Função avalia bloqueios do pedido de vendas

@author		.iNi Sistemas
@since     	24/11/17
@version  	P.12              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function IFATM030

//Local _lLib 	:= Nil
Local lBlqVisa 	:= .F.   
Local nRetVisa 	:= 0    
Local cJustif	:= ''   
//Local cCont		:= 0
Local _nI

oFontBol12	:= TFont():New("Arial",,-12,,.T.,,,,,,,,,,)
oFontBold	:= TFont():New("Arial",,-14,,.T.,,,,,,,,,,)

If Empty(SC5->C5_XMOTBLQ)
  // MsgBox('Não existe bloqueio de pedido para o usuário ativo.','Aviso')
  Return .F.
EndIf

_cMotivos := SC5->C5_XMOTBLQ
_aMotivos := {}                       
_cMotNew  := ''

Do While !Empty(_cMotivos)
   If Left(_cMotivos,1) $ '.,/#;'
      _cMotivos := Substr(_cMotivos, 2)
   EndIf                             
   If Empty(_cMotivos)
      Exit
   EndIf  
   
   _cMotBlq := Left(_cMotivos,2)      
   _cMotivos := Substr(_cMotivos,3)      
   //If PA2->(DbSeek(xFilial('PA2')+_cMotBlq+__cUserID)) 
   //   If PA2->PA2_APROVA == __cUserID
   //      aAdd(_aMotivos, {PA2->PA2_CODIGO, PA2->PA2_APROVA})
   //   Else 
   //      _cMotNew += PA2->PA2_CODIGO+','
   //   EndIf 
   //Else
   //   _cMotNew += _cMotBlq+','
   //EndIf
   aAdd(_aMotivos, {"01", "BLOQUEIO RENTABILIDADE"})

EndDo 

If !Empty(_cMotNew)
	_cMotNew := SubStr(_cMotNew,01,Len(_cMotNew)-1)
EndIf    



If Empty(_aMotivos)
   MsgBox('Não existe bloqueio de pedido para o usuário ativo','Aviso')
   Return .F.
EndIf

_cMsgBlq := ''
For _nI := 1 To Len(_aMotivos) 
    If "01" $ alltrim(_aMotivos[_nI, 1])
	    lBlqVisa := .T.                     
    Endif

    //PA2->(DbSeek(xFilial('PA2')+_aMotivos[_nI, 1]))
    //_cMsgBlq +='Motivo de bloqueio: '+PA2->PA2_CODIGO+'-'+PA2->PA2_DESC+Chr(13)+Chr(10)       
    _cMsgBlq +='Motivo de bloqueio: '+_aMotivos[_nI, 1]+'-'+_aMotivos[_nI, 2]+Chr(13)+Chr(10)       
Next _nI

SA1->(dbSetOrder(1))
SA1->(dbSeek(XFILIAL('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
cNomCli	:= ALLTRIM(SA1->A1_NOME)+" ("+SA1->A1_COD+"/"+SA1->A1_LOJA+")"


//_nRet := Aviso("Liberação","Deseja liberar o pedido "+SC5->C5_NUM+" para dar continuidade ao fluxo comercial?"+Chr(13)+Chr(10)+_cMsgBlq,{"Libera","Rejeita","Abandona"}) 

DEFINE MSDIALOG oDlgAltPed TITLE "Liberação de Pedido de Venda" FROM 0,0 TO 200,380 PIXEL	// 260	520
@ 006,005 SAY "Filial: " 	Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
@ 006,025 SAY SC5->C5_FILIAL	SIZE 50,07 PIXEL OF oDlgAltPed
@ 006,060 SAY "Pedido: " 	Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
@ 006,090 SAY SC5->C5_NUM		SIZE 50,07 PIXEL OF oDlgAltPed
//@ 014,005 SAY "Lote: " 		Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
//@ 014,025 SAY (_cSC5Del)->C5_LOTEPED	SIZE 50,07 PIXEL OF oDlgAltPed
@ 014,060 SAY "Emissão: " 	Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
@ 014,090 SAY DTOC(SC5->C5_EMISSAO)	SIZE 50,07 PIXEL OF oDlgAltPed
@ 022,005 SAY "Cliente: " 	Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
@ 022,030 SAY cNomCli 		SIZE 100,07 PIXEL OF oDlgAltPed
@ 033,005 SAY "Coloque em poucas palavras a justificativa para liberação/rejeição do pedido." 	Font oFontBol12 SIZE 250,07 PIXEL OF oDlgAltPed
//@ 033,030 COMBOBOX oSelMot VAR cSelMot ITEMS aSelMot SIZE 160,07 PIXEL OF oDlgAltPed
@ 044,005 SAY "Justificativa: " 	Font oFontBol12 SIZE 50,07 PIXEL OF oDlgAltPed
@ 4,0.7 GET oMemo1 VAR cJustif OF oDlgAltPed MEMO size 180,10 FONT oDlgAltPed:oFont COLOR CLR_BLACK,CLR_HGRAY WHEN .T.

//@ 084,050 BUTTON oButton1 PROMPT "CONFIRMAR" 	  	SIZE 032,012 PIXEL OF oDlgAltPed ACTION (IIF(ValExcPed(),{_lRet:=.T.,oDlgAltPed:End()},NIL))
@ 084,045 BUTTON oButton1 PROMPT "LIBERAR" 	  	SIZE 032,012 PIXEL OF oDlgAltPed ACTION (iif(goVldJus(cJustif),{_nRet := 1, oDlgAltPed:End()},NIL))
@ 084,085 BUTTON oButton2 PROMPT "REJEITAR" 	SIZE 032,012 PIXEL OF oDlgAltPed ACTION (iif(goVldJus(cJustif),{_nRet := 2, oDlgAltPed:End()},NIL))
@ 084,125 BUTTON oButton3 PROMPT "CANCELAR" 	SIZE 032,012 PIXEL OF oDlgAltPed ACTION oDlgAltPed:End()

ACTIVATE MSDIALOG oDlgAltPed CENTERED

If _nRet == 1   
	//verifica se foi solicitado para liberar status 08
	If lBlqVisa                               
			
		//nRetVisa:= Aviso(	"Liberação Rentabilidade",;
		//						"Deseja liberar o pedido "+SC5->C5_NUM+" com bloqueio de rentabilidade? "+Chr(13)+Chr(10)+;			 				 	
		//	 				 	"Antes de efetuar a liberação verifique possível exceções que este pedido pode se enquadar."+Chr(13)+Chr(10)+Chr(13)+Chr(10),;
		//						{"Liberar","Mantem Bloqueio"},3)
															
		//se liberou mesmo assim					
		//If nRetVisa == 1        
			//Colocar o Motivo
			//Do While Empty(cJustif)
			//	cJustif := FWInputBox("Coloque em poucas palavras a justificativa para liberação do pedido "+SC5->C5_NUM,"")					
			
			//	If  !Empty(cJustif) 
						DBSELECTAREA("Z05")
   						DBSETORDER(2)
   						IF !DBSEEK(XFILIAL("Z05")+SC5->C5_NUM+'000047')
   							u_DnyGrvSt(SC5->C5_NUM, "000047")
   						ENDIF
   
						
						_cQuery1 := " UPDATE "+RetSqlName("Z05")
		   				_cQuery1 += " SET Z05_DESC = convert(varbinary(max),'"+AllTrim(cJustif)+"')"
						_cQuery1 += " FROM "+RetSqlName("Z05")+" Z05 "
						_cQuery1 += " WHERE  Z05.D_E_L_E_T_ <> '*' "
						_cQuery1 += "    AND Z05.Z05_PEDIDO = '" +SC5->C5_NUM+ "' AND  Z05.Z05_STATUS = '000047' and Z05_FILIAL = '"+xFilial("Z05")+"'"
					
						//cQuery := "insert "+RetSqlName("Z05")+"	(Z05_STATUS,Z05_DESC,							Z05_PEDIDO,			Z05_DATA,			Z05_HORA,	Z05_NOMUSU)"
					//cQuery += "						values	('000048',convert(varbinary(max),'"+AllTrim(cJustif)+"'),'"+SC5->C5_NUM+"','"+dtos(dDataBase)+"','"+substr(Time(),1,5)+"','"+UsrRetName(__cUserID)+"')"
					TcSqlExec(_cQuery1)						
				//Endif                 
			
				   //	cQuery := "insert "+RetSqlName("Z05")+"	(Z05_STATUS,Z05_DESC,							Z05_PEDIDO,			Z05_DATA,			Z05_HORA,	Z05_NOMUSU)"
					//cQuery += "						values	('000047',convert(varbinary(max),'"+AllTrim(cJustif)+"'),'"+SC5->C5_NUM+"','"+dtos(dDataBase)+"','"+substr(Time(),1,5)+"','"+UsrRetName(__cUserID)+"')"
			//		TcSqlExec(cQuery)						
				//cCont++

				//se cancelou 3x, sai do loop e cancela processo de liberação.
				//If cCont == 3
				//	Exit
				//EndIf
			//Enddo
			If Empty(cJustif)  
				nRetVisa := 0
			Endif				
		/*Else
			//--Envia Email para o vendedor
			FSEmail(SC5->C5_NUM,"")
		EndIf*/		
	EndIf 

	//If !lBlqVisa .OR. (lBlqVisa .AND. nRetVisa == 1)
		RecLock('SC5',.F.)
			//--Se ocorreu liberação 
			Replace SC5->C5_XMOTBLQ With ''			
		MsUnlock() 
	//Else
	//	Msginfo("Favor verificar a liberação por rentabilidade.")	
	//EndIf	   
ElseIf _nRet == 2
   RecLock('SC5',.F.)  
   Replace SC5->C5_BLQ With '2' 
   Replace SC5->C5_MSBLQL With '1'
   MsUnlock()
   
   DBSELECTAREA("Z05")
   DBSETORDER(2)
   IF !DBSEEK(XFILIAL("Z05")+SC5->C5_NUM+'000048')
   	u_DnyGrvSt(SC5->C5_NUM, "000048")
   ENDIF
   //Colocar o Motivo
			//Do While Empty(cJustif)
			//	cJustif := FWInputBox("Coloque em poucas palavras a justificativa para rejeição do pedido "+SC5->C5_NUM,"")					
			//	If  !Empty(cJustif) 
						_cQuery1 := " UPDATE "+RetSqlName("Z05")
		   				_cQuery1 += " SET Z05_DESC = convert(varbinary(max),'"+AllTrim(cJustif)+"')"
						_cQuery1 += " FROM "+RetSqlName("Z05")+" Z05 "
						_cQuery1 += " WHERE  Z05.D_E_L_E_T_ <> '*' "
						_cQuery1 += "    AND Z05.Z05_PEDIDO = '" +SC5->C5_NUM+ "' AND  Z05.Z05_STATUS = '000048' and Z05_FILIAL = '"+xFilial("Z05")+"'"
					
						//cQuery := "insert "+RetSqlName("Z05")+"	(Z05_STATUS,Z05_DESC,							Z05_PEDIDO,			Z05_DATA,			Z05_HORA,	Z05_NOMUSU)"
					//cQuery += "						values	('000048',convert(varbinary(max),'"+AllTrim(cJustif)+"'),'"+SC5->C5_NUM+"','"+dtos(dDataBase)+"','"+substr(Time(),1,5)+"','"+UsrRetName(__cUserID)+"')"
					TcSqlExec(_cQuery1)						
			//	Endif                 
			//	cCont++

				//se cancelou 3x, sai do loop e cancela processo de liberação.
			//	If cCont == 3
			//		Exit
			//	EndIf
			//Enddo
			
   //--Envia Email para o vendedor
   FSEmail(SC5->C5_NUM,cJustif)
EndIf                                     

Return(.T.)


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
	Local cSubject	:= 'REJEIÇÃO POR RENTABILIDADE'
	Local cCorpo	:= ''
	//Local cEmail	:= ''
	//Local nPosPrd	:= 0
	Local cAnexos	:= ''	
	//Local lRet		:= .F.
	//--Limpa variavel
	cCorpo:=''
	//Atualiza variavel
  //?	cBody:= 'PEDIDO: ' + SC5->C5_NUM + ' REJEITADO POR RENTABILIDADE'
	cBody:= 'PEDIDO: ' + _PEDIDO + ' REJEITADO POR RENTABILIDADE: ' +_HIST
	//--Valida se retornou email
	//cTo:= Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_EMAIL')
	cTo:= Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_XEMADM')
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


Static Function goVldJus(cJustif)
Local lRet := .T.
if empty(cJustif)

	MsgBox("É necessário informar algo na JUSTIFICATIVA!","","INFO")
	lRet := .F.

endif
Return( lRet)
