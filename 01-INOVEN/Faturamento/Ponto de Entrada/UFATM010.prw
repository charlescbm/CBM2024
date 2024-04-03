#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

User Function ITEM()
    
    Local aParam   := PARAMIXB
    Local oObj     := ""
    Local cIdPonto := ""
    Local cIdModel := ""
    Local lIsGrid  := .F.
    Local xRet     :=  .T.
     
    Private oModel   := FwModelActive()
         
    // VERIFICA SE APARAM NÃO ESTÁ NULO
    If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)
        
		l010Inc := oObj:GetOperation() == MODEL_OPERATION_INSERT        
		l010Alt := oObj:GetOperation() == MODEL_OPERATION_UPDATE        
		l010Del := oObj:GetOperation() == MODEL_OPERATION_DELETE        
         
        //  VERIFICA SE O PONTO EM QUESTÃO É O FORMPOS
        If cIdPonto == "FORMPOS" .And. cIdModel == "SB1MASTER"
             
        elseIf cIdPonto == "MODELPOS"

        elseIf cIdPonto == "MODELCOMMITTTS"

            If oModel <> NIL

				cB1_COD		:= oModel:GetModel("SB1MASTER"):GetValue("B1_COD")

				SB5->(dbSetOrder(1))	// B5_FILIAL, B5_COD, R_E_C_N_O_, D_E_L_E_T_
				IF SB5->(dbSeek(xFilial('SB5') + cB1_COD))
					SB5->(RecLock("SB5",.F.))
					SB5->B5_ALTURA	:= M->B1_XALTURA
					SB5->B5_LARG	:= M->B1_XLARG
					SB5->B5_COMPR	:= M->B1_XCOMPR
					SB5->(MsUnLock())
				ENDIF
                 
            EndIf

	    EndIf
 
    EndIf
    
Return xRet


