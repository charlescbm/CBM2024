#Include 'Protheus.ch'
/*/{Protheus.doc} SD3250R

SD3250R - Ao encerrar uma ordem de produção

@author GoOne Consultoria - Crele Cristia
@since 29/11/2021
@version 1.0
/*/
User Function SD3250R()

Local oDlg
Local cGet		:= Space(45)
Local nOpcA 	:= 0

	If alltrim(cFilAnt) <> '0103'
		Return
	endif

	if SC2->C2_QUJE < SC2->C2_QUANT

		//Tela de leituea de etiquetas para excluir
		While .T.

			DEFINE MSDIALOG oDlg TITLE "Leitura de Etiquetas" FROM 000, 000  TO 100, 300 PIXEL
			@ 006, 005 SAY oSay PROMPT "Etiqueta para excluir:" SIZE 142, 007 OF oDlg PIXEL
			@ 018, 005 MSGET oGet VAR cGet SIZE 142, 010 PICTURE PesqPict( "ZZA", "ZZA_PALLET" ) OF oDlg PIXEL

			DEFINE SBUTTON oBtnOk FROM 034, 090 TYPE 01 OF oDlg ENABLE ACTION ( nOpcA := 1,oDlg:End() )
			DEFINE SBUTTON oBtnCanc FROM 034, 120 TYPE 02 OF oDlg ENABLE ACTION ( ( nOpcA := 0, oDlg:End()) )
			//DEFINE SBUTTON oBtnCanc FROM 034, 120 TYPE 02 OF oDlg ENABLE ACTION ( ( lRet:= .F., oDlg:End()) )
			
			ACTIVATE MSDIALOG oDlg CENTERED

			if nOpca == 1
				//alert('vou excluir etiqueta....')
				lRet := DelEtqSobra(cGet)
			else
				exit
			endif

		End

	endif

Return

/************************************************************************************/
/*/{Protheus.doc} DelEtqSobra

@description Deleta sobra 

@author Bernard M. Margrido
@since 13/06/2018
@version 1.0

@param cGet, characters, descricao
@type function
/*/
/************************************************************************************/
Static Function DelEtqSobra(cGet)
Local aArea		:= GetArea()

Local lRet		:= .T.

Local cCodBar	:= SubStr(cGet,1,13)
Local cProd		:= SubStr(cGet,14,4)
Local cDoc		:= SubStr(cGet,18,9)
Local cItem		:= SubStr(cGet,27,4)
Local cNumCx	:= SubStr(cGet,31,4)
Local cLote		:= SubStr(cGet,35,10)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()

cQuery := "	SELECT "
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA 
cQuery += "	FROM 
cQuery += "		" + RetSqlName("ZZA") + " ZZA" 
cQuery += "	WHERE 
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND 
cQuery += "		ZZA.ZZA_CODPRO = '" + cProd + "' AND 
cQuery += "		ZZA.ZZA_CODBAR = '" + cCodBar + "' AND 
cQuery += "		ZZA.ZZA_NUMNF = '" + cDoc + "'  AND 
cQuery += "		ZZA.ZZA_ITEMNF = '" + cItem + "'  AND
cQuery += "		ZZA.ZZA_NUMCX = '" + cNumCx + "' AND 
cQuery += "		ZZA.ZZA_NUMLOT = '" + cLote + "' AND 
cQuery += "		ZZA.D_E_L_E_T_ = '' 

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	MsgAlert("Etiqueta não encontrada.")
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
EndIf

//---------------------+
// Posicioana Registro | 
//---------------------+
dbSelectArea("ZZA")
ZZA->( dbSetOrder(1))
ZZA->( dbGoTop())
ZZA->( dbGoTo((cAlias)->RECNOZZA) )
//If ZZA->ZZA_BAIXA	== "2"
If ZZA->ZZA_BAIXA	$ "2/3"
	MsgAlert("Etiqueta já lida.")
	lRet := .F.
Else
	RecLock("ZZA",.F.)
	//	ZZA->ZZA_PERDA 	:= 1
	//	ZZA->ZZA_CONFER	:= .T.
	//	ZZA->ZZA_BAIXA	:= "1"
	ZZA->(dbDelete())
	ZZA->( MsUnLock() )
	
EndIf	

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return lRet
