#Include 'Protheus.ch'
/*/{Protheus.doc} MTA650E

MTA650E - Ao gravar a ordem de produção

@author GoOne Consultoria - Crele Cristia
@since 16/11/2021
@version 1.0
/*/
User Function MTA650E()

If alltrim(cFilAnt) <> '0103'
	Return
endif


	//Apagando etiquetas da OP
	ZZA->(dbSetOrder(1))
	ZZA->(msSeek(xFilial('ZZA') + "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM))
	While !ZZA->(eof()) .and. ZZA->ZZA_FILIAL == xFilial('ZZA') .and. ZZA->ZZA_NUMNF + ZZA->ZZA_SERIE + ZZA->ZZA_FORNEC + ZZA->ZZA_LOJA + ZZA->ZZA_ITEMNF == "000" + SC2->C2_NUM + SC2->C2_SEQUEN + "ORDEMPRO" + space(tamSx3("ZZA_LOJA")[1]) + "00" + SC2->C2_ITEM
		ZZA->(recLock('ZZA', .F.))
		ZZA->(dbDelete())
		ZZA->(dbSkip())
	End


Return
