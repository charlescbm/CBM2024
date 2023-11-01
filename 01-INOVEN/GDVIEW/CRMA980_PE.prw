#include "TOTVS.ch"
#include "FWMVCDEF.ch"

// *********************************************************************** //
// CRMA980 - Ponto de entrada para rotina em MVC de clientes               //
// @copyright (c) 2021-06-30 > Marcelo da Cunha > GDView                   //
// *********************************************************************** //

User Function CRMA980()
    *******************
	LOCAL xRetu := .T., aParam := PARAMIXB //Parametros

    Local cConta                                              
    Local cContaSup := "1102001"
    Local oModelCTB
    Local nOpcAuto
    Local oCT1
    Local oCVD
    Local aLog
    Local cLog := ""
    Local nAtual

	///////////////////////////////
	If (aParam != Nil).and.(Len(aParam) >= 3).and.(Alltrim(aParam[2]) == "BUTTONBAR")
		xRetu := {{"Historico","OPEN",{|| openHistoric(aParam) }}}
	Elseif (aParam != Nil).and.(Len(aParam) >= 3).and.(Alltrim(aParam[2]) == "FORMCOMMITTTSPRE")
		If ExistBlock("GDVHCOMPARA")
			u_GDVHCompara("SA1")
		Endif
	Endif

	Private oModel   := FwModelActive()

	If aParam <> NIL
		oObj        := aParam[1]
    	cIDPonto    := aParam[2]
    	cIDModel    := aParam[3]
    	lIsGrid     := (Len(aParam) > 3)

		If cIdPonto == 'MODELCOMMITTTS'

			l980Inc := oObj:GetOperation() == MODEL_OPERATION_INSERT 

			if l980Inc
				//Monta a conta
				cConta := cContaSup + alltrim(oObj:GetValue("SA1MASTER","A1_COD")) + alltrim(oObj:GetValue("SA1MASTER","A1_LOJA"))

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
					oCT1:SetValue('CT1_DESC01',  Alltrim(oObj:GetValue("SA1MASTER","A1_NREDUZ")))
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
			endif

		endif

	endif

	///////////////////////////////
Return xRetu

Static Function openHistoric(xParam)
	********************************
	If ExistBlock("GDVHISTMAN") //Verifico rotina GDVHISTMAN
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1")+xParam[1]:GetValue("SA1MASTER","A1_COD")+xParam[1]:GetValue("SA1MASTER","A1_LOJA"),.T.))
		u_GDVHistMan("SA1")
	Endif
Return
