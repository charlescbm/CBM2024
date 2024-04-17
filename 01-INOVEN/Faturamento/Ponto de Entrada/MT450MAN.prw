#Include "Protheus.ch"
/*
+---------------------------------------------------------------------------+
| Programa   | MT450MAN                             | Data | 28/09/2021     |
|---------------------------------------------------------------------------|
| Descricao  | Ponto de entrada para validar a execucao da opcao de libera- |
|            | cao de credito do pedido de venda.                           |
|            |                                                              |
|------------|--------------------------------------------------------------|
| Autor      | GoOne Consultoria - Crele Cristina                           |
+---------------------------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN


User Function MT450MAN()
***********************

Local lRet 		:= .F.
Local pNumRA	:= space(len(SE1->E1_NUM))
Local cNumRA	:= space(len(SE1->E1_NUM))
Local _x

Private aParam	:= {}

if Type("cGoTitR") == 'U'
	_SetNamedPrvt( "cGoTitR" , "" , "MATA450" )
endif
//if Type("nGoTitR") == 'U'
//	_SetNamedPrvt( "nGoTitR" , 0 , "MATA450" )
//endif
if Type("aGoTitR") == 'U'
	_SetNamedPrvt( "aGoTitR" , {} , "MATA450" )
endif
if Type("cGoTitR") <> 'U'
	cGoTitR := space(len(SE1->E1_PREFIXO)) + space(len(SE1->E1_NUM))
endif
//if Type("nGoTitR") <> 'U'
//	nGoTitR := 0
//endif
if Type("aGoTitR") <> 'U'
	aGoTitR := {}
endif

SC5->(dbSetOrder(1))
if SC5->(msSeek(xFilial("SC5") + SC9->C9_PEDIDO))
	//Caso condicao de pagamento ANTECIPADO, solicitar numero do titulo de RA

	//if SC5->C5_CONDPAG == "003"
	if SC5->C5_CONDPAG $ GetNewPar("IN_CPADIAN", "003")

		//busca valor total do pedido
		nTotalPed := 0
		SC6->(dbSetOrder(1))
		SC6->(msSeek(FWxFilial('SC6') + SC5->C5_NUM, .T.))
		While !SC6->(EoF()) .And. SC6->C6_FILIAL == FWxFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM
			nTotalPed += SC6->C6_VALOR
			SC6->(DbSkip())
		EndDo
		nTotalPed += SC5->C5_FRETE + SC5->C5_SEGURO + SC5->C5_DESPESA

		aRecnoSE1	:= {}
		cNumPedido	:= SC5->C5_NUM
		cCodCli		:= SC5->C5_CLIENTE
		cCodLoja	:= SC5->C5_LOJACLI
		cTes		:= ""
		nItem		:= 0
		nMoedPed	:= SC5->C5_MOEDA
		aRecnoSE1 := FPEDADT("R", cNumPedido, nTotalPed, aRecnoSE1, cCodCli, cCodLoja, cTes, nItem, nMoedPed)	
		//alert(len(aRecnoSE1))

		for _x:= 1 to len(aRecnoSE1)
			//alert(aRecnoSE1[_x][1])	//pedido
			//alert(aRecnoSE1[_x][2])	//recno SE1
			//alert(aRecnoSE1[_x][3])	//valor
			aadd(aGoTitR, {aRecnoSE1[_x][1], aRecnoSE1[_x][2]})
			lRet := .T.
		next

		/*
		xMVPAR01 := MV_PAR01
		IF PARAMBOX( {	{1,"Nr.Titulo RA", pNumRA,"@!",".T.","","",30,.T.};
						}, "Titulo Pagto Antecipado", @aParam,,,,,,,,.F.,.T.)

			cNumRA := MV_PAR01
			cPrfRA := padr("RA", tamSx3("E1_PREFIXO")[1])

			//Confirma se titulo existe digitado
			lTemE1 := .F.
			SE1->(dbSetOrder(2))
			SE1->(msSeek(xFilial("SE1") + SC9->C9_CLIENTE + SC9->C9_LOJA + cPrfRA + cNumRA, .T.))
			While !SE1->(eof()) .and. SE1->E1_FILIAL == xFilial("SE1") .and. SE1->E1_CLIENTE + SE1->E1_LOJA + SE1->E1_PREFIXO + SE1->E1_NUM == SC9->C9_CLIENTE + SC9->C9_LOJA + cPrfRA + cNumRA

				if alltrim(SE1->E1_TIPO) == "RA" .and. SE1->E1_SALDO > 0
					lTemE1 := .T.
					lRet := .T.

					if Type("cGoTitR") <> 'U'
						cGoTitR := SE1->E1_PREFIXO + SE1->E1_NUM
					endif
					if Type("nGoTitR") <> 'U'
						nGoTitR := SE1->(recno())
					endif

					exit
				endif

				SE1->(dbSkip())
			End
			if !lTemE1
				MsgStop("O título digitado não existe ou já está totalmente baixado!","INOVEN - Avisos")
			endif

		Endif
		MV_PAR01 := xMVPAR01
		*/

	else
		lRet := .T.
	endif
endif

if !lRet
	MsgStop("Para liberar este pedido é preciso informar o numero do título referente ao pagamento antecipado (RA)." + chr(13) + chr(10) + "Liberação não autorizada!","INOVEN - Avisos")
endif

Return(lRet)
