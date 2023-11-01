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
         
            // VERIFICA SE OMODEL NÃO ESTÁ NULO
            If oModel <> NIL
             
				cB1_FILIAL	:= oModel:GetModel("SB1MASTER"):GetValue("B1_FILIAL")
				cB1_COD		:= oModel:GetModel("SB1MASTER"):GetValue("B1_COD")
				cB1_TIPO	:= oModel:GetModel("SB1MASTER"):GetValue("B1_TIPO")
				cB1_RASTRO	:= oModel:GetModel("SB1MASTER"):GetValue("B1_RASTRO")
				nB1_PESO	:= oModel:GetModel("SB1MASTER"):GetValue("B1_PESO")
				nB1_PESBRU	:= oModel:GetModel("SB1MASTER"):GetValue("B1_PESBRU")
				cB1_IMPORT	:= oModel:GetModel("SB1MASTER"):GetValue("B1_IMPORT")
				cB1_XDTVALI:= oModel:GetModel("SB1MASTER"):GetValue("B1_XDTVALI")

				cB5_CONVDIP	:= oModel:GetModel("SB5DETAIL"):GetValue("B5_CONVDIP")
				cB5_UMDIPI	:= oModel:GetModel("SB5DETAIL"):GetValue("B5_UMDIPI")
						
						
				if alltrim(cB1_TIPO) == 'ME' .and. (empty(cB1_RASTRO) .or. cB1_RASTRO <> "L")
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo RASTRO como L.", 1, 0)
					Return .F.
				endif
				if alltrim(cB1_TIPO) == 'ME' .and. empty(nB1_PESO)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo PESO LIQUIDO.", 1, 0)
					Return .F.
				endif
				if alltrim(cB1_TIPO) == 'ME' .and. empty(nB1_PESBRU)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo PESO BRUTO.", 1, 0)
					Return .F.
				endif
				if alltrim(cB1_TIPO) == 'ME' .and. empty(cB1_IMPORT)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo IMPORTADO.", 1, 0)
					Return .F.
				endif
				if alltrim(cB1_TIPO) == 'ME' .and. empty(cB1_XDTVALI)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo MESES DE VALIDADE.", 1, 0)
					Return .F.
				endif

				//SB5
				if alltrim(cB1_TIPO) == 'ME' .and. empty(cB5_CONVDIP)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo CONV. DIPI, na parte de Complemento de Produtos.", 1, 0)
					Return .F.
				endif
				if alltrim(cB1_TIPO) == 'ME' .and. empty(cB5_UMDIPI)
					Help( ,, 'Criação de Produtos',, "Para produtos do tipo ME, é necessário preencher o campo UM DIPI, na parte de Complemento de Produtos.", 1, 0)
					Return .F.
				endif

				/*			
				IF l010Inc
				
				elseif l010Alt

				Elseif l010Del

				Endif
				*/
                 
            EndIf
             
        elseIf cIdPonto == "MODELPOS"
        
	    EndIf
 
    EndIf
    
Return xRet

