#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX300													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio de notas nao autorizadas		 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 26/07/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX300( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SF2","SE1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Relação de notas - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC300()

RpcClearEnv()

Return

User Function WFTEC300()

If File("\workflow\notas_valida.htm") .and. File("\workflow\notas_valida_sem.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"
		column F2_EMISSAO as Date
		SELECT 'SAI' DOC, F2_FIMP, F2_SERIE, F2_DOC, F2_EMISSAO, F2_TIPO, F2_CLIENTE, F2_LOJA, A1_NOME
		FROM %table:SF2% F2
		INNER JOIN %table:SA1% A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
		WHERE F2.%notdel% AND F2_SERIE = '2' AND F2_ESPECIE <> 'OCC' AND F2_EMISSAO > '20210801' AND F2_FIMP IN (' ','N','D')
		AND F2_FILIAL = %xfilial:SF2% AND A1.%notdel%
		UNION ALL
		SELECT 'ENT' DOC, F1_FIMP, F1_SERIE, F1_DOC, F1_EMISSAO, F1_TIPO, F1_FORNECE, F1_LOJA, A2_NOME
		FROM %table:SF1% F1
		INNER JOIN %table:SA2% A2 ON A2_COD = F1_FORNECE AND A2_LOJA = F1_LOJA
		WHERE F1.%notdel% AND F1_SERIE IN ('1','2') AND F1_DTDIGIT > '20210801' AND F1_FORMUL = 'S' AND F1_FIMP IN (' ','N','D')
		AND F1_FILIAL = %xfilial:SF1% AND A2.%notdel%
		ORDER BY DOC, F2_EMISSAO DESC, F2_DOC
	ENDSQL

	oProcess := TWFProcess():New("000001", OemToAnsi("Relacao de Notas com **Pendencias**"))
	//oProcess:NewTask("000001", "\workflow\notas_valida.htm")
	oProcess:NewTask("000001", "\workflow\notas_valida_sem.htm")
	
	oProcess:cSubject 	:= "Relacao de Notas com **Pendencias** em " + dtoc(dDatabase)
	oProcess:bTimeOut	:= {}
	oProcess:fDesc 		:= "Relacao de Notas com **Pendencias** " + dtoc(dDatabase)
	oProcess:ClientName(cUserName)
	oHTML := oProcess:oHTML

	oHTML:ValByName('dtbase', dDataBase)

	cBody := ""
	QRY->(dbGoTop())
	While !QRY->(EOF())

		cAuto := ""
		do Case
			Case QRY->F2_FIMP == 'N'; cAuto := "NAO AUTORIZADA"
			Case QRY->F2_FIMP == ' '; cAuto := "NAO TRANSMITIDA"
			Case QRY->F2_FIMP == 'D'; cAuto := "DENEGADA"
		EndCase

		cBody += '<tr>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + iif(QRY->DOC == 'ENT', 'ENTRADA', 'SAÍDA') + '</td>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + QRY->F2_SERIE + '</td>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + QRY->F2_DOC + '</td>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + dtoc(QRY->F2_EMISSAO) + '</td>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + QRY->F2_TIPO + '</td>'
		cBody += '<td style="border: 1px solid #002544; border-top: 0; border-left: 0;">&nbsp;' + QRY->F2_CLIENTE + '/' + QRY->F2_LOJA + ' - ' + QRY->A1_NOME + '</td>'
		cBody += '<td align="center" style="border: 1px solid #002544; border-top: 0; border-left: 0; border-right: 0;">' + cAuto + '</td>'
		cBody += '</tr>'

		/*
		AAdd(oProcess:oHtml:ValByName('nf.tpdoc')	, iif(QRY->DOC == 'ENT', 'ENTRADA', 'SAÍDA'))
		AAdd(oProcess:oHtml:ValByName('nf.serie')	, QRY->F2_SERIE)
		AAdd(oProcess:oHtml:ValByName('nf.doc')		, QRY->F2_DOC)
		AAdd(oProcess:oHtml:ValByName('nf.emissao')	, dtoc(QRY->F2_EMISSAO))
		AAdd(oProcess:oHtml:ValByName('nf.tipo')	, QRY->F2_TIPO)
		AAdd(oProcess:oHtml:ValByName('nf.cliente')	, QRY->F2_CLIENTE + '/' + QRY->F2_LOJA + ' - ' + QRY->A1_NOME)
		AAdd(oProcess:oHtml:ValByName('nf.auto')	, cAuto)
		*/

		QRY->(dbSkip())
	End
	if empty(cBody)
		cBody += '<tr>'
		cBody += '<td align="center" colspan="7" style="border: 1px solid #002544; border-top: 0; border-left: 0;">*** SEM NOTAS PARA RELACIONAR ***</td>'
		cBody += '</tr>'
	endif
	oHTML:ValByName('nfbody', cBody)

	//Grade das notas sem romaneio
	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"
		column F2_EMISSAO as Date
		SELECT F2_SERIE, F2_DOC, F2_EMISSAO, F2_TIPO, F2_CLIENTE, F2_LOJA, A1_NOME
		FROM %table:SF2% F2
		INNER JOIN %table:SA1% A1 ON A1_COD = F2_CLIENTE AND F2_LOJA = A1_LOJA
		WHERE F2.%notdel% AND A1.%notdel% AND F2_FILIAL = %xfilial:SF2% AND F2_TRANSP <> '' AND F2_EMISSAO > '20210801' AND F2_FIMP IN (' ','N','D')
		AND F2_FILIAL+F2_SERIE+F2_DOC NOT IN (SELECT ZZE_FILIAL+ZZE_SERIE+ZZE_NOTA FROM %table:ZZE% ZZE
		WHERE ZZE.%notdel% AND ZZE_FILIAL = F2_FILIAL AND ZZE_SERIE = F2_SERIE AND ZZE_NOTA = F2_DOC)
		ORDER BY F2_EMISSAO DESC, F2_DOC

	ENDSQL

	cBody := ""
	QRY->(dbGoTop())
	While !QRY->(EOF())

		cBody += '<tr>'
		cBody += '<td align="center" style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">' + QRY->F2_SERIE + '</td>'
		cBody += '<td align="center" style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">' + QRY->F2_DOC + '</td>'
		cBody += '<td align="center" style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">' + dtoc(QRY->F2_EMISSAO) + '</td>'
		cBody += '<td align="center" style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">' + QRY->F2_TIPO + '</td>'
		cBody += '<td style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">&nbsp;' + QRY->F2_CLIENTE + '/' + QRY->F2_LOJA + ' - ' + QRY->A1_NOME + '</td>'
		cBody += '</tr>'

		QRY->(dbSkip())
	End
	if empty(cBody)
		cBody += '<tr>'
		cBody += '<td align="center" colspan="5" style="border: 1px solid #CD853F; border-top: 0; border-left: 0;">*** SEM NOTAS PARA RELACIONAR ***</td>'
		cBody += '</tr>'
	endif
	oHTML:ValByName('rombody', cBody)

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif


	//Grade do Financeiro
	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"
		column F2_EMISSAO as Date
		SELECT DISTINCT F2_SERIE, F2_DOC, F2_EMISSAO, F2_TIPO, F2_CLIENTE, F2_LOJA, A1_NOME, F2_DUPL,F2_PREFIXO,E1_NUMBCO
		FROM %table:SF2% F2
		INNER JOIN %table:SA1% A1 ON A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA
		INNER JOIN %table:SE1% E1 ON E1_FILIAL =' ' AND F2_PREFIXO = E1_PREFIXO AND F2_DUPL = E1_NUM AND F2_FIMP IN (' ','N','D')
		WHERE F2.%notdel% AND F2_SERIE = '2' AND E1_NUMBCO = ' ' AND E1_XFORMA = 'BOL'
		AND F2_FILIAL = %xfilial:SF2% AND E1_TIPO not in ('RA ', 'NCC')
		AND A1.%notdel% AND E1.%notdel%
		ORDER BY F2_EMISSAO DESC, F2_DOC
	ENDSQL

	cBody := ""
	QRY->(dbGoTop())
	While !QRY->(EOF())

		cFina := ""
		do Case
			Case empty(QRY->F2_DUPL); cFina := "SEM FINANCEIRO"
			Case !empty(QRY->F2_DUPL) .and. empty(QRY->E1_NUMBCO); cFina := "NAO"
			Case !empty(QRY->F2_DUPL) .and. !empty(QRY->E1_NUMBCO); cFina := "SIM"
		EndCase

		cBody += '<tr>'
		cBody += '<td align="center" style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0;">' + QRY->F2_SERIE + '</td>'
		cBody += '<td align="center" style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0;">' + QRY->F2_DOC + '</td>'
		cBody += '<td align="center" style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0;">' + dtoc(QRY->F2_EMISSAO) + '</td>'
		cBody += '<td align="center" style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0;">' + QRY->F2_TIPO + '</td>'
		cBody += '<td style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0;">&nbsp;' + QRY->F2_CLIENTE + '/' + QRY->F2_LOJA + ' - ' + QRY->A1_NOME + '</td>'
		cBody += '<td align="center" style="border: 1px solid #5F9EA0; border-top: 0; border-left: 0; border-right: 0;">' + cFina + '</td>'
		cBody += '</tr>'

		/*
		AAdd(oProcess:oHtml:ValByName('fin.serie')	, QRY->F2_SERIE)
		AAdd(oProcess:oHtml:ValByName('fin.doc')	, QRY->F2_DOC)
		AAdd(oProcess:oHtml:ValByName('fin.emissao'), dtoc(QRY->F2_EMISSAO))
		AAdd(oProcess:oHtml:ValByName('fin.tipo')	, QRY->F2_TIPO)
		AAdd(oProcess:oHtml:ValByName('fin.cliente'), QRY->F2_CLIENTE + '/' + QRY->F2_LOJA + ' - ' + QRY->A1_NOME)
		AAdd(oProcess:oHtml:ValByName('fin.fin')	, cFina)
		*/

		QRY->(dbSkip())
	End
	if empty(cBody)
		cBody += '<tr>'
		cBody += '<td align="center" colspan="6" style="border: 1px solid #002544; border-top: 0; border-left: 0;">*** SEM NOTAS PARA RELACIONAR ***</td>'
		cBody += '</tr>'
	endif
	oHTML:ValByName('finbody', cBody)

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif

	oProcess:cTo := GetNewPar("IN_WFNFAUT", "charlesbattisti@gmail.com")			
	//oProcess:cTo := "charlesbattisti@gmail.com"
	//oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
			
	// Inicia o processo
	oProcess:Start()
	// Finaliza o processo
	oProcess:Finish()					

Endif
Return
