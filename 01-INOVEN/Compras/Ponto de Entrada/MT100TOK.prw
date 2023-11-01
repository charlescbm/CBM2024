#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! MT100TOK - Valida inclusão da NF saida					!
+-------------------+-----------------------------------------------------------+
!Descricao			! VALIDA INCLUSAO DA NF SAIDA            					!
!					! Este P.E. e chamado na funcao A920Tudok(); Pode ser usado !
!					! para validar a inclusao da NF.							!
!					! Valida informacoes para proceguir com Inclusao			!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 09/11/2021					                          	!
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function MT100TOK()

Local nX 

	if substr(cTipo,1,1) == "C"	//Nota Complementar
		//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM

		nPosPrd 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD"})
		nPosIte 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEM"})
		nPosNfO 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"})
		nPosSrO 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_SERIORI"})
		nPosItO 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMORI"})
		nPosFor 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_FORNECE"})
		nPosLoj 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOJA"})
		nPosLoc 	:= aScan(aHeader,{|x| AllTrim(x[2])=="D1_LOCAL"})

		For nX:=1 to len(aCols)
		
			SD1->(dbSetOrder(1))
			if msSeek(xFilial('SD1') + aCols[nX][nPosNfO] + aCols[nX][nPosSrO] + aCols[nX][nPosFor] + aCols[nX][nPosLoj] + aCols[nX][nPosPrd] + aCols[nX][nPosItO])
				if aCols[_x][nPosLoc] <> SD1->D1_LOCAL
					Help(,, "PROBLEMA-"+ALLTRIM(ProcName())+"-MT100TOK", , "Local diferente da nota de origem. Inclusão não será realizada. Item " + aCols[_x][nPosIte], 1, 0 )
					Return .F.
				endif
			endif
		
		Next

	endif

Return( .T. )
