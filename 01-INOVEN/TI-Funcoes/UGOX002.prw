#include 'protheus.ch'
#DEFINE  ENTER CHR(13)+CHR(10)


/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 		!
+-------------------------------------------------------------------------------+
!Programa			! UGOX002 - Atualizar Cta Contabil Clientes					! 
+-------------------+-----------------------------------------------------------+
!Descricao			! Atualizar Cta Contabil Clientes							!
+-------------------+-----------------------------------------------------------+
!Autor        	 	! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 31/10/2022							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UGOX002()

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"S!1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Ajuste Cta Contabil - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
OKGOX02()
MsgAlert('Acabou....', 'Ajuste Cta Contabil')

RpcClearEnv()

Return

Static Function OKGOX02()

Local cConta                                              
Local cContaSup := "1102001"
Local oModelCTB
Local nOpcAuto
Local oCT1
Local oCVD
Local aLog
Local cLog := ""

Local nAtual

_cQry := " SELECT A1_COD, A1_LOJA "+ENTER
_cQry += "   FROM "+ RetSqlName('SA1') +" SA1  "+ENTER
_cQry += "     WHERE SA1.D_E_L_E_T_ <> '*' "+ENTER
_cQry += "       AND A1_FILIAL = '"+ xFilial('SA1') +"' "+ENTER
_cQry += "       AND A1_CONTA = ' ' "+ENTER
_cQry += "       AND A1_CGC <> '99999999999999' "+ENTER
                                                     
If Select("_TRP") > 0
	_TRP->(DbCloseArea())
EndIf

DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TRP",.F.,.T.)

_TRP->(dbGoTop())
While !_TRP->(eof())

	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + _TRP->A1_COD + _TRP->A1_LOJA))

	//Monta a conta
	cConta := cContaSup + alltrim(SA1->A1_COD) + alltrim(SA1->A1_LOJA)

	CT1->(DbSetOrder(1))
	
	//Se nao conseguir posicionar no Plano de Contas, sera incluida
	If !CT1->(DbSeek(FWxFilial("CT1") + cConta))

		//Faz o carregamento do modelo
		If oModelCTB == Nil
			oModelCTB := FWLoadModel('CTBA020')
		EndIf
				
		//Setando a operação como Inclusão e ativando o modelo
		nOpcAuto:=3
		oModelCTB:SetOperation(nOpcAuto)
		oModelCTB:Activate()
				
		//Setando os valores da CT1 (Plano de Contas)
		oCT1 := oModelCTB:GetModel('CT1MASTER') 
		oCT1:SetValue('CT1_CONTA',   cConta)
		oCT1:SetValue('CT1_DESC01',  Alltrim(SA1->A1_NREDUZ))
		oCT1:SetValue('CT1_CLASSE', '2')
		oCT1:SetValue('CT1_NORMAL', '1')
		oCT1:SetValue('CT1_NTSPED', '01')
		oCT1:SetValue('CT1_NATCTA', '01')
		oCT1:SetValue('CT1_INDNAT', '1')
					
		//Setando os dados da CVD (Plano de Contas Referencial)
		oCVD := oModelCTB:GetModel('CVDDETAIL')
		oCVD:SetValue('CVD_FILIAL', FWxFilial('CVD'))
		oCVD:SetValue('CVD_ENTREF', "10")
		oCVD:SetValue('CVD_CODPLA', "000001")
		oCVD:SetValue('CVD_VERSAO', "0001")
		oCVD:SetValue('CVD_CTAREF', "1.01.02.02.01")
		oCVD:SetValue('CVD_CUSTO' , "")
		oCVD:SetValue('CVD_CLASSE', "2")
		oCVD:SetValue('CVD_TPUTIL', "A")
		oCVD:SetValue('CVD_NATCTA', "01")
		oCVD:SetValue('CVD_CTASUP', "1.01.02.02")
					
		//Se tiver tudo ok, confirma a gravação
		If oModelCTB:VldData()
			oModelCTB:CommitData()
			
			//Grava a conta contábil no Fornecedor
			SA1->(RecLock("SA1", .F.))
				SA1->A1_CONTA := cConta
			SA1->(MsUnlock())    
	
		Else
			
			//Pega o Log completo
			aLog := oModelCTB:GetErrorMessage()
	
			//Percore todas as linhas do Log
			For nAtual := 1 to Len(aLog)
				
				//Se tiver log, incrementa variável
				If ! Empty(aLog[nAtual])
					cLog  += Alltrim(aLog[nAtual]) + Chr(13) + Chr(10)
				EndIf
			Next nAtual
			
			//Mostra o erro na tela
			lMsErroAuto := .T.
			AutoGRLog(cLog)
			MostraErro()
	
		EndIf
					
		//Desativa o modelo de dados
		oModelCTB:DeActivate()

	endif

	_TRP->(dbSkip())
End

return
