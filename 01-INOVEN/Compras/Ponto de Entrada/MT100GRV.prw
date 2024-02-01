#Include 'Protheus.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA							!
+-------------------------------------------------------------------------------+
!Programa		! MT100GRV - Ponto de Entrada na Entrada da Nota				!
+-------------+-----------------------------------------------------------------+
!Descricao		! Validar a entrada da nota								 		!
+-------------+-----------------------------------------------------------------+
!Autor			! GoOne Consultoria - Crele Cristina							!
+-------------------+-----------------------------------------------------------+
!Dt. Criacao   	! 15/01/2024													!
+-------------------+-----------------------------------------------------------+
*/

User Function MT100GRV()

Local aArea		:= GetArea()
Local lRet		:= .T.
Local _excluiNF := PARAMIXB[1]
Local _x, cLocRet := ""
Local lAtuEst 	:= .F.
Local cMsg		:= ""

if !_excluiNF
	
	For _x:= 1 to len(aCols)

		cD1TES := GDFIELDGET('D1_TES', _x)
		cD1IT  := GDFIELDGET('D1_ITEM', _x)
		cD1PRD := GDFIELDGET('D1_COD', _x)
		cD1LOCAL := GDFIELDGET('D1_LOCAL', _x)

		cLocRet := GDFIELDGET('D1_LOCAL', _x)

		SF4->(DbSetOrder(1))
		If SF4->(MsSeek(xFilial("SF4") + cD1TES))
			If SF4->F4_ESTOQUE == "S"
				lAtuEst	:= .T.
			Else
				lAtuEst	:= .F.
			EndIf
		EndIf

		SB1->(dbSetOrder(1))
		SB1->(msSeek(xFilial("SB1") + cD1PRD))

		If SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "N" .AND. SB1->B1_ORIGEM == "1" .And. cUfOrig == "EX" 
			cLocRet	:= '90'
		ELSEIF ( SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "N" .AND. SB1->B1_ORIGEM == "2" ) .Or. ( cUfOrig <> "EX" .And. lAtuEst .AND. substr(cTipo,1,1) == "N" )  
			cLocRet	:= '80'
		ELSEIF SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "D" 
			cLocRet	:= '04'
		ELSEIF SB1->B1_TIPO == "ME" .and. lAtuEst .AND. substr(cTipo,1,1) == "B"  .AND. cD1TES == '476' 
			cLocRet	:= '05'
		ELSEIF SB1->B1_TIPO == "MP" //.AND. cCdTes == '020' 
			cLocRet	:= '80'
		EndIf

		if substr(cTipo,1,1) == "C"	//Nota Complementar
			//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

			SD1->(dbSetOrder(1))
			if msSeek(xFilial('SD1') + GDFieldGet("D1_NFORI", _x) + GDFieldGet("D1_SERIORI", _x) + GDFieldGet("D1_FORNECE", _x) + GDFieldGet("D1_LOJA", _x) + cD1PRD + GDFieldGet("D1_ITEMORI", _x))
				cLocRet	:= SD1->D1_LOCAL
			endif
		endif

		if alltrim(cD1LOCAL) <> alltrim(cLocRet)
			cMsg += "Item/Produto " + cD1IT + "/" + cD1PRD + chr(13) + chr(10)
		endif
		
	next

	if !empty(cMsg)
		lRet := .F.
		Help(,, "PROBLEMA-"+ALLTRIM(ProcName())+"-MT100GRV", , "Essa nota possui locais de entrada incorretos! Confira os itens abaixo:" + chr(13) + chr(10) + cMsg, 1, 0 )		
	endif

Endif

RestArea(aArea)
Return( lRet )

