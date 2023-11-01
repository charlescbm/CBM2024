#Include 'Protheus.ch'
#include 'TBICONN.CH'

/*/{Protheus.doc} IFATM060
Calculo e ajuste do % de comissão
@type function
@author Crele Cristina da Costa
@since 15/08/2022
@version 1.0
/*/User Function IFATM060( lAuto )

	Local bProcess := {|oProcess| ProcIni(oProcess, lAuto) }                                       
	Local aAcoes   := {}
	Local cRotina  := "IFATM60" //Precisa ser 7 caracteres
	Local cPerg    := ""
	Local cTitulo  := "Cálculo/Ajuste do % de Comissão"
	Local cDescri  := "Este programa tem como objetivo ajustar os % de comissões com base no faturamento."
	Local cTitAux  := "Processando dados..."                                                                                          

	Default lAuto := .F.

	Private oProcess

	if !lAuto
		//AjustaSX1(cPerg)

		tNewProcess():New(	cRotina   ,; //Nome da rotina utilizada
							cTitulo   ,; //Título da Rotina
							bProcess  ,; //Processamento a ser executado
							cDescri   ,; //Descrição da rotina
							cPerg     ,; //Grupo de perguntas para os parâmetros
							aAcoes    ,; //Acoes adicionais
							.T.       ,; //Apresenta o painel auxiliar
							005       ,; //Tamanho do painel auxiliar
							cTitAux   ,; //Mensagem do painel auxiliar
							.T.        ) //Apresenta régua de processamento
	else
		//Executa quando chamada pelo Scheduler
		ProcIni(oProcess, lAuto)
	endif

Return

/*/{Protheus.doc} ProcIni
Função de processamento da rotina
@type function
@author Crele Cristina
@since 15/08/2022
@version 1.0
@param oProcess, objeto, Objeto de processamento
/*/Static Function ProcIni(oProcess, lAuto)
Local aParam := {}, lOkPar := .F., _x

Private dDataI := FirstDate(dDataBase)
Private dDataF := dDataBase

mv_par01 := dDataI
mv_par02 := dDataF

cFilTipo := GetNewPar("IN_RECCOMI", "S")
cExpFil  := '%' + iif(cFilTipo == 'S', "A3_TIPO = 'I'", '1=1') + '%'

if !lAuto
	While .T.
		IF PARAMBOX( { {1,"Data De", dDataI,"","","","",50,.F.},;
					   {1,"Data Ate", dDataF,"","","","",50,.F.};
						},"Informe o periodo",@aParam,,,,,,,,.F.,.F.)

			if empty(mv_par01) .or. empty(mv_par02)
				APMSGALERT("UM PERIODO INICIAL E FINAL DEVEM SER INFORMADOS.","PARAMETROS")
				loop
			else
				dDataI	:= mv_par01
				dDataF	:= mv_par02
				lOkPar	:= .T.
				exit
			endif
		Else
			exit
		Endif
	End
	if !lOkPar
		RETURN
	endif
endif
	
if !lAuto
	oProcess:SetRegua1(2)
	oProcess:IncRegua1("Filtro dos Dados Faturamento - VENDEDOR...")

	oProcess:SaveLog("Inicio processamento - filtro dos dados faturamento - vendedor")
	//query e processamento
endif

//TIPO VENDEDOR
aVendedor := {}
If Select("QRYV") > 0
	QRYV->(dbCloseArea())
EndIf
BEGINSQL ALIAS "QRYV"
	/*
	SELECT D2_FILIAL, SUBSTRING(D2_EMISSAO,1,4) AS ANO, SUBSTRING(D2_EMISSAO,5,2) AS MES, F2_VEND1, A3_TIPO, SUM(D2_TOTAL) D2_TOTAL
	FROM %table:SD2% D2
	INNER JOIN %table:SF2% F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE
	AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
	INNER JOIN %table:SA3% A3 ON A3_COD = F2_VEND1
	WHERE D2.%notdel% AND F2.%notdel% AND A3.%notdel%
	AND D2_FILIAL = %xFilial:SD2% AND A3_FILIAL = %xFilial:SA3%
	AND D2_EMISSAO BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
	AND %exp:cExpFil%
	GROUP BY D2_FILIAL, SUBSTRING(D2_EMISSAO,1,4), SUBSTRING(D2_EMISSAO,5,2), F2_VEND1, A3_TIPO
	*/
	SELECT SUBSTRING(D2_EMISSAO,1,4) AS ANO, SUBSTRING(D2_EMISSAO,5,2) AS MES, F2_VEND1, A3_TIPO, A3_XVAUX, SUM(D2_TOTAL) D2_TOTAL
	FROM %table:SD2% D2
	INNER JOIN %table:SF2% F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE
	AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
	INNER JOIN %table:SA3% A3 ON A3_COD = F2_VEND1
	WHERE D2.%notdel% AND F2.%notdel% AND A3.%notdel%
	AND D2_EMISSAO BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
	AND %exp:cExpFil%
	AND F2_VEND1 NOT IN (SELECT A3_XVAUX FROM %table:SA3% A3X WHERE A3X.%notdel% AND F2_VEND1 = A3_XVAUX)
	GROUP BY SUBSTRING(D2_EMISSAO,1,4), SUBSTRING(D2_EMISSAO,5,2), F2_VEND1, A3_TIPO, A3_XVAUX
ENDSQL

nCount := 0
QRYV->(dbGotop())
QRYV->(dbEval({|| nCount++}))

if !lAuto
	oProcess:SetRegua2(nCount)
endif


QRYV->(dbGotop())
While QRYV->(!eof())

	aadd(aVendedor,{QRYV->ANO,QRYV->MES,QRYV->F2_VEND1, QRYV->A3_XVAUX, QRYV->D2_TOTAL, 0})

	QRYV->(dbSkip())
ENDDO

//Acrescentar as vendas dos auxiliares
For _x:= 1 to len(aVendedor)

	if !empty(aVendedor[_x][4])
		If Select("QRYV") > 0
			QRYV->(dbCloseArea())
		EndIf
		BEGINSQL ALIAS "QRYV"
			SELECT SUBSTRING(D2_EMISSAO,1,4) AS ANO, SUBSTRING(D2_EMISSAO,5,2) AS MES, F2_VEND1, A3_TIPO, SUM(D2_TOTAL) D2_TOTAL
			FROM %table:SD2% D2
			INNER JOIN %table:SF2% F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE
			AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
			INNER JOIN %table:SA3% A3 ON A3_COD = F2_VEND1
			WHERE D2.%notdel% AND F2.%notdel% AND A3.%notdel%
			AND D2_EMISSAO BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
			AND F2_VEND1 = %exp:aVendedor[_x][4]%
			GROUP BY SUBSTRING(D2_EMISSAO,1,4), SUBSTRING(D2_EMISSAO,5,2), F2_VEND1, A3_TIPO
		ENDSQL
		if !empty(QRYV->D2_TOTAL)
			aVendedor[_x][5] := aVendedor[_x][5] + QRYV->D2_TOTAL
		endif
	endif

Next


cMsg := "Recalculo/Ajuste de Comissoes processado para "
lFezR := .F.

//QRYV->(dbGotop())
//While QRYV->(!eof())
For _x:= 1 to len(aVendedor)

	if !lAuto
		oProcess:IncRegua2("Processando valores...")
		SysRefresh()
	endif

	lTem := .F.

	//Valores Devolucoes
	If (Select("QRYDEV") <> 0)
		QRYDEV->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRYDEV"
		SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEVOLU 
		FROM %table:SD1% SD1
		INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD1.D1_NFORI 
		AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA) 
		INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD1.D1_TES) 
		WHERE SD1.%notdel% AND SF2.%notdel% AND SF4.%notdel%
		AND SD1.D1_DTDIGIT BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
		AND SF4.F4_DUPLIC='S' 
		AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411')
		AND SD1.D1_FILIAL = %xfilial:SD1% 
		//AND SF2.F2_VEND1 = %exp:QRYV->F2_VEND1%
		AND SF2.F2_VEND1 = %exp:aVendedor[_x][3]%
	ENDSQL

	/*
	Z93->(dbSetOrder(1))
	Z93->(msSeek(QRYV->D2_FILIAL + QRYV->ANO + QRYV->MES + 'V' + QRYV->F2_VEND1, .T.))
	if !(Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == QRYV->D2_FILIAL + QRYV->ANO + QRYV->MES + 'V' + QRYV->F2_VEND1)
		Z93->(msSeek(QRYV->D2_FILIAL + QRYV->ANO + QRYV->MES + 'V' + space(tamSx3('Z93_VEND')[1]), .T.))
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == QRYV->D2_FILIAL + QRYV->ANO + QRYV->MES + 'V' + space(tamSx3('Z93_VEND')[1])"
	else
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == QRYV->D2_FILIAL + QRYV->ANO + QRYV->MES + 'V' + QRYV->F2_VEND1"
	endif
	*/
	Z93->(dbSetOrder(1))
	Z93->(msSeek(xFilial('Z93') + aVendedor[_x][1] + aVendedor[_x][2] + 'V' + aVendedor[_x][3], .T.))
	if !(Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + aVendedor[_x][1] + aVendedor[_x][2] + 'V' + aVendedor[_x][3])
		Z93->(msSeek(xFilial('Z93') + aVendedor[_x][1] + aVendedor[_x][2] + 'V' + space(tamSx3('Z93_VEND')[1]), .T.))
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + aVendedor[_x][1] + aVendedor[_x][2] + 'V' + space(tamSx3('Z93_VEND')[1])"
	else
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + aVendedor[_x][1] + aVendedor[_x][2] + 'V' + aVendedor[_x][3]"
	endif

	While Z93->(!eof()) .and. &(cCond)

		//cCondFx := '(QRYV->D2_TOTAL - QRYDEV->DEVOLU) >= Z93->Z93_FAIXA1'
		//cCondFx += iif(!empty(Z93->Z93_FAIXA2), '.AND. (QRYV->D2_TOTAL - QRYDEV->DEVOLU) <= Z93->Z93_FAIXA2', '')
		cCondFx := '(aVendedor[_x][5] - QRYDEV->DEVOLU) >= Z93->Z93_FAIXA1'
		cCondFx += iif(!empty(Z93->Z93_FAIXA2), '.AND. (aVendedor[_x][5] - QRYDEV->DEVOLU) <= Z93->Z93_FAIXA2', '')

		if &(cCondFx)
			nPerCom := Z93->Z93_COMIS
			lTem := .T.
			exit
		endif

		Z93->(dbSkip())
	End

	if lTem		//caso tenha registro de faixas
		cQryUpd := "UPDATE SD2 SET SD2.D2_COMIS1 = " + alltrim(str(nPerCom)) + ", SD2.D2_ZVCOMIS = ROUND(D2_TOTAL * " + alltrim(str(nPerCom / 100 ))+", 2)  "
		cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
		cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
		cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
		cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
		cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
		//cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND F2.F2_VEND1 = '" + QRYV->F2_VEND1 + "' "
		cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND F2.F2_VEND1 = '" + aVendedor[_x][3] + "' "

		TCSqlExec(cQryUpd)
		lFezR := .T.

		if !empty(aVendedor[_x][4])
			//Ajusta do auxiliar
			cQryUpd := "UPDATE SD2 SET SD2.D2_COMIS1 = " + alltrim(str(nPerCom)) + ", SD2.D2_ZVCOMIS = ROUND(D2_TOTAL * " + alltrim(str(nPerCom / 100 ))+", 2)  "
			cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
			cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
			cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
			cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
			cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
			cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
			cQryUpd += "AND F2.F2_VEND1 = '" + aVendedor[_x][4] + "' "

			TCSqlExec(cQryUpd)
		endif

	else
		cQryUpd := "UPDATE SD2 SET SD2.D2_ZVCOMIS = ROUND(D2_TOTAL * (D2_COMIS1/100), 2)  "
		cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
		cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
		cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
		cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
		cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
		//cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND F2.F2_VEND1 = '" + QRYV->F2_VEND1 + "' "
		cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND F2.F2_VEND1 = '" + aVendedor[_x][3] + "' "
		cQryUpd += "AND D2_ZVCOMIS = 0"

		TCSqlExec(cQryUpd)
		lFezR := .T.

		if !empty(aVendedor[_x][4])
			//Ajusta do auxiliar
			cQryUpd := "UPDATE SD2 SET SD2.D2_ZVCOMIS = ROUND(D2_TOTAL * (D2_COMIS1/100), 2)  "
			cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
			cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
			cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
			cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
			cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
			cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
			cQryUpd += "AND F2.F2_VEND1 = '" + aVendedor[_x][4] + "' "
			cQryUpd += "AND D2_ZVCOMIS = 0"

			TCSqlExec(cQryUpd)
		endif
	endif
	//alert(QRYV->F2_VEND1 + ' - ' + str(nPercom))

//	QRYV->(dbSkip())

Next
//End

if !lAuto
	//TIPO SUPERVISOR
	oProcess:IncRegua1("Filtro dos Dados Faturamento - SUPERVISOR...")

	oProcess:SaveLog("Inicio processamento - filtro dos dados faturamento - supervisor")
	//query e processamento
else 
	cMsg += iif(lFezR, "Vendedores ", "")
endif

If Select("QRYV") > 0
	QRYV->(dbCloseArea())
EndIf
BEGINSQL ALIAS "QRYV"
	SELECT D2_FILIAL, SUBSTRING(D2_EMISSAO,1,4) AS ANO, SUBSTRING(D2_EMISSAO,5,2) AS MES, A3_SUPER, SUM(D2_TOTAL) D2_TOTAL
	FROM %table:SD2% D2
	INNER JOIN %table:SF2% F2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE
	AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA
	INNER JOIN %table:SA3% A3 ON A3_COD = F2_VEND1
	WHERE D2.%notdel% AND F2.%notdel% AND A3.%notdel%
	AND D2_FILIAL = %xFilial:SD2% AND A3_FILIAL = %xFilial:SA3%
	AND D2_EMISSAO BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
	AND %exp:cExpFil%
	GROUP BY D2_FILIAL, SUBSTRING(D2_EMISSAO,1,4), SUBSTRING(D2_EMISSAO,5,2), A3_SUPER
ENDSQL

nCount := 0
QRYV->(dbGotop())
QRYV->(dbEval({|| nCount++}))

if !lAuto
	oProcess:SetRegua2(nCount)
endif

lFezR := .F.

QRYV->(dbGotop())
While QRYV->(!eof())

	if !lAuto
		oProcess:IncRegua2("Processando valores...")
		SysRefresh()
	endif

	lTem := .F.

	//Valores Devolucoes
	If (Select("QRYDEV") <> 0)
		QRYDEV->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRYDEV"
		SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEVOLU 
		FROM %table:SD1% SD1
		INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD1.D1_NFORI 
		AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA) 
		INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD1.D1_TES) 
		WHERE SD1.%notdel% AND SF2.%notdel% AND SF4.%notdel%
		AND SD1.D1_DTDIGIT BETWEEN %exp:dtos(mv_par01)% AND %exp:dtos(mv_par02)%
		AND SF4.F4_DUPLIC='S' 
		AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411')
		AND SD1.D1_FILIAL = %xfilial:SD1% 
		AND SF2.F2_VEND2 = %exp:QRYV->A3_SUPER%
	ENDSQL

	Z93->(dbSetOrder(1))
	Z93->(msSeek(xFilial('Z93') + QRYV->ANO + QRYV->MES + 'S' + QRYV->A3_SUPER, .T.))
	if !(Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + QRYV->ANO + QRYV->MES + 'S' + QRYV->A3_SUPER)
		Z93->(msSeek(xFilial('Z93') + QRYV->ANO + QRYV->MES + 'S' + space(tamSx3('Z93_VEND')[1]), .T.))
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + QRYV->ANO + QRYV->MES + 'S' + space(tamSx3('Z93_VEND')[1])"
	else
		cCond := "Z93->Z93_FILIAL+Z93->Z93_ANO+Z93->Z93_MES+Z93->Z93_TIPO+Z93->Z93_VEND == xFilial('Z93') + QRYV->ANO + QRYV->MES + 'S' + QRYV->A3_SUPER"
	endif

	While Z93->(!eof()) .and. &(cCond)

		cCondFx := '(QRYV->D2_TOTAL - QRYDEV->DEVOLU) >= Z93->Z93_FAIXA1'
		cCondFx += iif(!empty(Z93->Z93_FAIXA2), '.AND. (QRYV->D2_TOTAL - QRYDEV->DEVOLU) <= Z93->Z93_FAIXA2', '')

		if &(cCondFx)
			nPerCom := Z93->Z93_COMIS
			lTem := .T.
			exit
		endif

		Z93->(dbSkip())
	End

	if lTem		//caso tenha registro de faixas
		cQryUpd := "UPDATE SD2 SET SD2.D2_COMIS2 = " + alltrim(str(nPerCom)) + ", D2_ZVCOMSS = ROUND(D2_TOTAL * " + alltrim(str(nPerCom / 100 ))+", 2)  "
		cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
		cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
		cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
		cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
		cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
		cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND A3.A3_SUPER = '" + QRYV->A3_SUPER + "' "

		TCSqlExec(cQryUpd)
		lFezR := .T.
	else
		cQryUpd := "UPDATE SD2 SET SD2.D2_ZVCOMSS = ROUND(D2_TOTAL * (D2_COMIS2/100), 2)  "
		cQryUpd += "FROM "+RetSqlname("SD2")+" SD2 "
		cQryUpd += "INNER JOIN "+RetSqlname("SF2")+" F2 ON F2.F2_FILIAL = SD2.D2_FILIAL AND F2.F2_DOC = SD2.D2_DOC AND F2.F2_SERIE = SD2.D2_SERIE "
		cQryUpd += "AND F2.F2_CLIENTE = SD2.D2_CLIENTE AND F2.F2_LOJA = SD2.D2_LOJA "
		cQryUpd += "INNER JOIN "+RetSqlname("SA3")+" A3 ON A3.A3_COD = F2.F2_VEND1 "
		cQryUpd += "WHERE SD2.D_E_L_E_T_ = ' ' AND F2.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQryUpd += "AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
		cQryUpd += "AND " + iif(cFilTipo == 'S', "A3.A3_TIPO = 'I'", '1=1') + " AND A3.A3_SUPER = '" + QRYV->A3_SUPER + "' "
		cQryUpd += "AND D2_ZVCOMSS = 0"

		TCSqlExec(cQryUpd)
		lFezR := .T.
	endif
	//alert(QRYV->F2_VEND1 + ' - ' + str(nPercom))

	QRYV->(dbSkip())

End

if !lAuto
	APMSGALERT("PROCESSO FINALIZADO COM SUCESSO.","PARAMETROS")
else
	cMsg += iif(lFezR, "e Supervisores", "")

	goEmail(cMsg)
endif

Return	

Static Function goEmail(cCorpo)
	
	Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
	Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
	Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
   	Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
   	Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
	Local lConnect  := .F.
	Local lEnviou   := .F.
	//Local lRet      := .T.
	Local cError	:= ''
	Local cTo		:= ''
	Local cSubject	:= 'RECALCULO/AJUSTE DE COMISSAO'
	Local cAnexos	:= ''	
	
	//--Valida se retornou email
   	cTo:= 'charlesbattisti@gmail.com'
 	//--Enviando Email(s)
	If !Empty(cServer) .And. !Empty(cAccount) .And. !Empty(cTo)
		//Realiza conexao com o Servidor
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
		//--Verifica se existe autenticação
		If lRelauth
			lRet := Mailauth(cAccount,cPassword)        
		EndIf
		//--Se conseguiu Conexao ao Servidor SMTP	
		If lConnect 
			SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cCorpo ATTACHMENT cAnexos RESULT lEnviou													
			If !lEnviou //Se conseguiu Enviar o e-Mail
				lRet:=.F.
				//Erro no envio do email
				GET MAIL ERROR cError
				ConOut("Erro de autenticação","Verifique a conta e a senha para envio",cError)
			EndIf
		Else
			lRet:=.F.
			GET MAIL ERROR cError
			ConOut("Erro de autenticação","Verifique a conta e a senha para envio ",cError)
		EndIf      	   
		If lRet
			DISCONNECT SMTP SERVER
		EndIf
	EndIf
	
	//If lRet
	//	//--Mensagem de envio
	//	MsgBox("Email(s) enviado(s) com sucesso","","INFO")
	//EndIf	

Return()


