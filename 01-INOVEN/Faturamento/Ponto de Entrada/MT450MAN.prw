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

Private aParam	:= {}

if Type("cGoTitR") == 'U'
	_SetNamedPrvt( "cGoTitR" , "" , "MATA450" )
endif
if Type("nGoTitR") == 'U'
	_SetNamedPrvt( "nGoTitR" , 0 , "MATA450" )
endif
if Type("cGoTitR") <> 'U'
	cGoTitR := space(len(SE1->E1_PREFIXO)) + space(len(SE1->E1_NUM))
endif
if Type("nGoTitR") <> 'U'
	nGoTitR := 0
endif

SC5->(dbSetOrder(1))
if SC5->(msSeek(xFilial("SC5") + SC9->C9_PEDIDO))
	//Caso condicao de pagamento ANTECIPADO, solicitar numero do titulo de RA
	if SC5->C5_CONDPAG == "003"	

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
				MsgStop("O t�tulo digitado n�o existe ou j� est� totalmente baixado!","INOVEN - Avisos")
			endif

		Endif
		MV_PAR01 := xMVPAR01

	else
		lRet := .T.
	endif
endif

if !lRet
	MsgStop("Para liberar este pedido � preciso informar o numero do t�tulo referente ao pagamento antecipado (RA)." + chr(13) + chr(10) + "Libera��o n�o autorizada!","INOVEN - Avisos")
endif

Return(lRet)
