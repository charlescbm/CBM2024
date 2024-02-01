#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX200													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio dos valores de faturamento		 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 20/07/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX200( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SD2","SD1","SF2","SF1","SF4","SE4"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Valores de Faturamento - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC200(.T.)

RpcClearEnv()

Return

User Function WFTEC200( lBat )

//Local dDataPro := dDataBase
//Local dDataPro := ctod('31/10/2023') // habilitar essa linha quando quiser rodar manual, compilar e executar no programa inicial 
Local dDataPro := ctod('')
Local _x, _f
Local aParam := {}
Local xData := LastDate(dDataBase)
Local lParam := .F.

Default lBat := .F.

if lBat 
	dDataPro := dDataBase
	//dDataPro := ctod('31/10/2023') // habilitar essa linha quando quiser rodar manual, compilar e executar no programa inicial 
	lParam := .T.
else
	IF PARAMBOX( {	{1,"Processar Fat.Data", xData,"",".T.","","",60,.T.};
				}, "Defina data de faturamento", @aParam,,,,,,,,.T.,.T.)
		lParam := .T.

		dDataPro	:= mv_par01

	endif
ENDIF

//If File("\workflow\quadro_fat.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1
If File("\workflow\quadro_fat_filial.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1 .and. lParam

	oProcess := TWFProcess():New("000001", OemToAnsi("Valores de Faturamento"))
	//oProcess:NewTask("000001", "\workflow\quadro_fat.htm")
	oProcess:NewTask("000001", "\workflow\quadro_fat_filial.htm")
	
	oProcess:cSubject 	:= "Valores de Faturamento em " + dtoc(dDataPro)
	oProcess:bTimeOut	:= {}
	oProcess:fDesc 		:= "Valores de Faturamento em " + dtoc(dDataPro)
	oProcess:ClientName(cUserName)
	oHTML := oProcess:oHTML

	For _f := 1 to 2
		
		cStrFil := iif(_f==1,"%SD2.D2_FILIAL IN ('0101','0102')%", "%SD2.D2_FILIAL IN ('0103','0104')%")
		//Valores do DIA - Faturamento
		If (Select("QRYFDIA") <> 0)
			QRYFDIA->(dbCloseArea())
		Endif
		//	SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6) VLRLIQ, 
		BEGINSQL ALIAS "QRYFDIA"
			SELECT SUM(SD2.D2_VALBRUT) AS FATURA,
			SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_ZVCOMIS-SD2.D2_ZVCOMSS) VLRLIQ, 
			SUM(CASE WHEN D2_ZVALICM > 0 THEN D2_ZVALICM ELSE D2_VALICM END) ZVLRICM,
			SUM(SD2.D2_CUSTO1) CUSTOM,
			SUM(CASE WHEN E4_FORMA = 'BOL' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATBOL,
			SUM(CASE WHEN E4_CODIGO = '003' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATAVI 
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SD2.D2_EMISSAO = %exp:dTos(dDataPro)%
			AND SF4.F4_DUPLIC='S' 
			AND SD2.D2_CF NOT IN (5551) 
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND %exp:cStrFil%
		ENDSQL

		//Valores do MES - Faturamento
		If (Select("QRYFMES") <> 0)
			QRYFMES->(dbCloseArea())
		Endif
		//	SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6) VLRLIQ, 
		BEGINSQL ALIAS "QRYFMES"
			SELECT SUM(SD2.D2_VALBRUT) AS FATURA,
			SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_ZPRVFRE-SD2.D2_ZVCOMIS-SD2.D2_ZVCOMSS) VLRLIQ, 
			SUM(CASE WHEN D2_ZVALICM > 0 THEN D2_ZVALICM ELSE D2_VALICM END) ZVLRICM,
			SUM(SD2.D2_CUSTO1) CUSTOM,
			SUM(CASE WHEN E4_FORMA = 'BOL' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATBOL,
			SUM(CASE WHEN E4_CODIGO = '003' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATAVI 
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SUBSTRING(SD2.D2_EMISSAO,1,6) = %exp:substr(dTos(dDataPro),1,6)% 
			AND SF4.F4_DUPLIC='S' 
			AND SD2.D2_CF NOT IN (5551) 
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND %exp:cStrFil%
		ENDSQL

		//Valores do DIA - PERDAS
		If (Select("QRYFDIAP") <> 0)
			QRYFDIA->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYFDIAP"
			SELECT SUM(SD2.D2_VALBRUT) AS PERDAS
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SD2.D2_EMISSAO = %exp:dTos(dDataPro)%
			AND SD2.D2_CF NOT IN (5551) 
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND SD2.D2_LOCAL = '02'
			AND %exp:cStrFil%
		ENDSQL

		//Valores do MES - PERDAS
		If (Select("QRYFMESP") <> 0)
			QRYFMES->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYFMESP"
			SELECT SUM(SD2.D2_VALBRUT) AS PERDAS
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SUBSTRING(SD2.D2_EMISSAO,1,6) = %exp:substr(dTos(dDataPro),1,6)% 
			AND SD2.D2_CF NOT IN (5551) 
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND SD2.D2_LOCAL = '02'
			AND %exp:cStrFil%
		ENDSQL

		//Valores do DIA - BRINDES/AMOSTRAS
		cCFOPB := SuperGetMv("IN_CFBRAMO",, '5910;5911;6910;6911')
		cExpCfo := "%D2_CF IN ('"
		aAux := StrTokArr( cCFOPB , ";" )
		for _x := 1 to len(aAux)
			cExpCfo += iif(_x > 1, ",'", "")
			cExpCfo += aAux[_x] + "'"
		NEXT
		cExpCfo += ")%"

		If (Select("QRYFDIABA") <> 0)
			QRYFDIA->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYFDIABA"
			SELECT SUM(SD2.D2_VALBRUT) AS BRIAMO
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SD2.D2_EMISSAO = %exp:dTos(dDataPro)%
			AND %exp:cExpCfo%
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND %exp:cStrFil%
		ENDSQL

		//Valores do MES - BRINDES/AMOSTRAS
		If (Select("QRYFMESBA") <> 0)
			QRYFMES->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYFMESBA"
			SELECT SUM(SD2.D2_VALBRUT) AS BRIAMO
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SE4% E4 ON E4.E4_FILIAL = %xfilial:SE4% AND E4_CODIGO = F2_COND
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND E4.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SUBSTRING(SD2.D2_EMISSAO,1,6) = %exp:substr(dTos(dDataPro),1,6)% 
			AND %exp:cExpCfo%
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND %exp:cStrFil%
		ENDSQL

		cStrFil := iif(_f==1,"%SD1.D1_FILIAL IN ('0101','0102')%", "%SD1.D1_FILIAL IN ('0103','0104')%")
		//Valores do DIA - Devolucoes
		If (Select("QRYDDEV") <> 0)
			QRYDDEV->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYDDEV"
			SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEVOLU 
			FROM %table:SD1% SD1
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD1.D1_NFORI 
			AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD1.D1_TES) 
			WHERE SD1.%notdel% AND SF2.%notdel% AND SF4.%notdel%
			AND SD1.D1_DTDIGIT = %exp:dTos(dDataPro)%
			AND SF4.F4_DUPLIC='S' 
			AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411')
			//AND SD1.D1_FILIAL = %xfilial:SD1% 
			AND %exp:cStrFil%
		ENDSQL

		//Valores do MES - Devolucoes
		If (Select("QRYMDEV") <> 0)
			QRYMDEV->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYMDEV"
			SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEVOLU 
			FROM %table:SD1% SD1
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = %xfilial:SF2% AND SF2.F2_DOC = SD1.D1_NFORI 
			AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD1.D1_TES) 
			WHERE SD1.%notdel% AND SF2.%notdel% AND SF4.%notdel%
			AND SUBSTRING(SD1.D1_DTDIGIT,1,6) = %exp:substr(dTos(dDataPro),1,6)%
			AND SF4.F4_DUPLIC='S' 
			AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411')
			//AND SD1.D1_FILIAL = %xfilial:SD1% 
			AND %exp:cStrFil%
		ENDSQL

		cStrFilCli := iif(_f==1,"%SD2.D2_FILIAL IN ('0101','0102')%", "%SD2.D2_FILIAL IN ('0103','0104')%")
		//Faturamento do DIA por Cliente
		If (Select("QRYFCLI") <> 0)
			QRYFCLI->(dbCloseArea())
		Endif
		//	SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6) VLRLIQ, 
		//	SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6) VLRLIQ, 
		BEGINSQL ALIAS "QRYFCLI"
			SELECT D2_CLIENTE, D2_LOJA, A1_NOME, SUM(SD2.D2_VALBRUT) AS FATURA,
			SUM(SD2.D2_TOTAL-SD2.D2_VALIMP5-SD2.D2_VALIMP6-SD2.D2_ZVCOMIS-SD2.D2_ZVCOMSS) VLRLIQ, 
			SUM(CASE WHEN D2_ZVALICM > 0 THEN D2_ZVALICM ELSE D2_VALICM END) ZVLRICM,
			SUM(SD2.D2_CUSTO1) CUSTOM
			FROM %table:SD2% SD2 
			INNER JOIN %table:SF2% SF2 ON (SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA) 
			INNER JOIN %table:SF4% SF4 ON (SF4.F4_FILIAL = %xfilial:SF4% AND SF4.F4_CODIGO = SD2.D2_TES) 
			INNER JOIN %table:SA1% A1 ON A1_FILIAL = %xfilial:SA1% AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA
			WHERE  SD2.%notdel% AND SF2.%notdel% AND SF4.%notdel% AND A1.%notdel%
			AND SD2.D2_TIPO NOT IN ('B','D') 
			AND SD2.D2_EMISSAO = %exp:dTos(dDataPro)%
			AND SF4.F4_DUPLIC='S' 
			AND SD2.D2_CF NOT IN (5551) 
			//AND SD2.D2_FILIAL = %xfilial:SD2% 
			AND %exp:cStrFilCli%
			GROUP BY D2_CLIENTE, D2_LOJA, A1_NOME
			ORDER BY FATURA DESC
		ENDSQL

		cMes := mesExtenso(dDataPro)
		oHTML:ValByName('diafat', dDataPro)
		oHTML:ValByName('fatclidia', dDataPro)
		oHTML:ValByName('mesfat', cMes + "/" + strzero(year(dDataPro),4))

		nMargem := Round(iif(!empty(QRYFDIA->VLRLIQ - QRYFDIA->ZVLRICM), ((QRYFDIA->VLRLIQ - QRYFDIA->ZVLRICM - QRYFDIA->CUSTOM) / (QRYFDIA->VLRLIQ - QRYFDIA->ZVLRICM)) * 100, 0), 2)
		oHTML:ValByName('fatdia' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFDIA->FATURA,"@E 999,999,999.99") + ' (' + alltrim(transform(nMargem,"@E 999,999.99")) + '%)')
		//oHTML:ValByName('margdia', transform(nMargem,"@E 999,999.99") + '%')
		oHTML:ValByName('fatboldia' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFDIA->FATBOL,"@E 999,999,999.99"))
		oHTML:ValByName('fatavidia' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFDIA->FATAVI,"@E 999,999,999.99"))
		nMargem := Round(iif(!empty(QRYFMES->VLRLIQ - QRYFMES->ZVLRICM), ((QRYFMES->VLRLIQ - QRYFMES->ZVLRICM - QRYFMES->CUSTOM) / (QRYFMES->VLRLIQ - QRYFMES->ZVLRICM)) * 100, 0), 2)
		oHTML:ValByName('fatmes' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFMES->FATURA,"@E 999,999,999.99") + ' (' + alltrim(transform(nMargem,"@E 999,999.99")) + '%)')
		//oHTML:ValByName('margmes', transform(nMargem,"@E 999,999.99") + '%')
		oHTML:ValByName('fatbolmes' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFMES->FATBOL,"@E 999,999,999.99"))
		oHTML:ValByName('fatavimes' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFMES->FATAVI,"@E 999,999,999.99"))
		oHTML:ValByName('devdia' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYDDEV->DEVOLU,"@E 999,999,999.99"))
		oHTML:ValByName('devmes' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYMDEV->DEVOLU,"@E 999,999,999.99"))
		oHTML:ValByName('fatperdasd' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFDIAP->PERDAS,"@E 999,999,999.99"))
		oHTML:ValByName('fatperdasm' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFMESP->PERDAS,"@E 999,999,999.99"))
		oHTML:ValByName('fatbriamod' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFDIABA->BRIAMO,"@E 999,999,999.99"))
		oHTML:ValByName('fatbriamom' + iif(_f==1,'1','2'), 'R$ ' + transform(QRYFMESBA->BRIAMO,"@E 999,999,999.99"))


		oHTML:ValByName('dtbase', dDataPro)

		cBody := ''
		QRYFCLI->(dbGoTop())
		While !QRYFCLI->(EOF())
			
			cBody += '<tr>'
			cBody += '<td style="border: 1px solid #002544; border-top: 0; border-left: 0;">' + QRYFCLI->D2_CLIENTE + '/' + QRYFCLI->D2_LOJA + ' - ' + QRYFCLI->A1_NOME + '</td>'
			cBody += '<td align="right" style="border: 1px solid #002544; border-top: 0; border-left: 0;">R$ ' + transform(QRYFCLI->FATURA,"@E 999,999,999.99")+ '&nbsp;</td>'

			//% margem por cliente
			nMargem := Round(iif(!empty(QRYFCLI->VLRLIQ - QRYFCLI->ZVLRICM), ((QRYFCLI->VLRLIQ - QRYFCLI->ZVLRICM - QRYFCLI->CUSTOM) / (QRYFCLI->VLRLIQ - QRYFCLI->ZVLRICM)) * 100, 0), 2)
			cBody += '<td align="right" style="border: 1px solid #002544; border-top: 0; border-left: 0; border-right: 0;' + iif(nMargem < 0, ' color: red;', '') + '">' + transform(nMargem,"@E 999,999.99")+ '&nbsp;</td>'

			cBody += '</tr>'
			//AAdd(oProcess:oHtml:ValByName('fat.cliente'), QRYFCLI->D2_CLIENTE + '/' + QRYFCLI->D2_LOJA + ' - ' + QRYFCLI->A1_NOME)
			//AAdd(oProcess:oHtml:ValByName('fat.valor'), 'R$ ' + transform(QRYFCLI->FATURA,"@E 999,999,999.99")+"&nbsp;")

			QRYFCLI->(dbSkip())
		End
		if empty(cBody)
			cBody += '<tr>'
			cBody += '<td align="center" colspan="3" style="border: 1px solid #002544; border-top: 0; border-left: 0;">*** SEM CLIENTES PARA RELACIONAR ***</td>'
			cBody += '</tr>'
		endif
		oHTML:ValByName('clibody' + iif(_f==1,'1','2'), cBody)

		If (Select("QRYFDIA") <> 0)
			QRYFDIA->(dbCloseArea())
		Endif
		If (Select("QRYFMES") <> 0)
			QRYFMES->(dbCloseArea())
		Endif
		If (Select("QRYDDEV") <> 0)
			QRYDDEV->(dbCloseArea())
		Endif
		If (Select("QRYMDEV") <> 0)
			QRYMDEV->(dbCloseArea())
		Endif
		If (Select("QRYFCLI") <> 0)
			QRYFCLI->(dbCloseArea())
		Endif
		If (Select("QRYFDIAP") <> 0)
			QRYFDIAP->(dbCloseArea())
		Endif
		If (Select("QRYFMESP") <> 0)
			QRYFMESP->(dbCloseArea())
		Endif
		If (Select("QRYFDIABA") <> 0)
			QRYFDIABA->(dbCloseArea())
		Endif
		If (Select("QRYFMESBA") <> 0)
			QRYFMESBA->(dbCloseArea())
		Endif
	Next

	oProcess:cTo := GetNewPar("IN_WFVLFAT", "crelec@gmail.com")			
	//oProcess:cTo := "crelec@gmail.com"
	//Envio de copia oculta
	if !Empty(GetNewPar("IN_WFVLFAX", ""))
		oProcess:cBcc := GetNewPar("IN_WFVLFAX", "")
	endif
			
	// Inicia o processo
	oProcess:Start()
	// Finaliza o processo
	oProcess:Finish()					

Endif
Return

