#include "rwmake.ch"
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! M020INC													!
+-------------------+-----------------------------------------------------------+
!Descricao			! LOCALIZAÇÃO Function FAvalSA2 - Função de Gravações 	!
!					! adicionais do Fornecedor, após sua inclusão.				!
!					! EM QUE PONTO: Após incluir o Fornecedor, deve ser 		!
!					! utilizado para gravar arquivos/campos do usuário,	 		!
!					! complementando a inclusão.								!
!					! Ponto de Entrada para complementar a inclusão no cadastro !
!					! do Fornecedor.											!
!					! Ponto de entrada para validacao de cadastro de Fornecedor	! 
!					! Efetua integracao com o Gestum - Urbano Textil			!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 17/07/2022					                          	!
+-------------------+-----------------------------------------------------------+
*/
User Function M020INC()

    Local aArea  := GetArea()
    Local lRet   := .T.

    Local cConta                                              
    Local cContaSup := "2103001"
    Local oModelCTB
    Local nOpcAuto
    Local oCT1
    Local oCVD
    Local aLog
    Local cLog := ""
    Local nAtual


    //Monta a conta
	IF SA2->A2_EST <> "EX"
	    cConta := cContaSup + alltrim(SA2->A2_COD) + alltrim(SA2->A2_LOJA)
	else
	    cConta := cContaSup + "99" + substr(alltrim(SA2->A2_COD),3,6) + "0000"
	ENDIF

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
        oCT1:SetValue('CT1_DESC01',  Alltrim(SA2->A2_NREDUZ))
        oCT1:SetValue('CT1_CLASSE', '2')
        oCT1:SetValue('CT1_NORMAL', '2')
        oCT1:SetValue('CT1_NTSPED', '02')
        oCT1:SetValue('CT1_NATCTA', '02')
        oCT1:SetValue('CT1_INDNAT', '2')
         
        //Setando os dados da CVD (Plano de Contas Referencial)
        oCVD := oModelCTB:GetModel('CVDDETAIL')
        oCVD:SetValue('CVD_FILIAL', FWxFilial('CVD'))
        oCVD:SetValue('CVD_ENTREF', "10")
        oCVD:SetValue('CVD_CODPLA', "000001")
        oCVD:SetValue('CVD_VERSAO', "0001")
        oCVD:SetValue('CVD_CTAREF', "2.01.01.03.01")
        oCVD:SetValue('CVD_CUSTO' , "")
        oCVD:SetValue('CVD_CLASSE', "2")
        oCVD:SetValue('CVD_TPUTIL', "A")
        oCVD:SetValue('CVD_NATCTA', "02")
        oCVD:SetValue('CVD_CTASUP', "2.01.01.03")
         
        //Se tiver tudo ok, confirma a gravação
        If oModelCTB:VldData()
            oModelCTB:CommitData()
             
            //Grava a conta contábil no Fornecedor
            RecLock("SA2", .F.)
                SA2->A2_CONTA := cConta
            SA2->(MsUnlock())    
     
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

    RestArea(aArea)
Return lRet

