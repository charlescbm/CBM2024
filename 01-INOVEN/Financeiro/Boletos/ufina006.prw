#Include 'Protheus.ch'

//DESENVOLVIDO POR INOVEN


User Function ufina006( cPrf, cNum, cParc, cCli, cLoja, cTipo)
		
	Local aArea		:= GetArea()
	Local nTotal	:= 0
	
	If (Select("QRYE5") <> 0)
		QRYE5->(dbCloseArea())
	Endif
	
	BEGINSQL ALIAS "QRYE5"
		column FI2_DTOCOR as Date
		select e5_data, e5_valor, e5_tipodoc, e5_motbx 
		from %table:FI2% FI2
		inner join %table:SE5% e5 on e5_filial = fi2_filial 
		and e5_prefixo = fi2_prefix and e5_numero = fi2_titulo and e5_parcela = fi2_parcel
		and e5_tipo = fi2_tipo and e5_clifor = fi2_codcli and e5_loja = fi2_lojcli
		where FI2.%notdel% and e5.%notdel%
		and FI2_GERADO = '2'
		and FI2_DTOCOR between %exp:MV_PAR13% AND %exp:MV_PAR14%
		and fi2_filial = %xFilial:FI2%
		and fi2_prefix = %exp:cPrf%
		and fi2_titulo = %exp:cNum%
		and fi2_parcel = %exp:cParc%
		and fi2_codcli = %exp:cCli%
		and fi2_lojcli = %exp:cLoja%
		and fi2_tipo = %exp:cTipo%
		and e5_motbx = 'CMP'
		and e5_data = fi2_dtocor
	ENDSQL
	
	While !QRYE5->(eof())
		if alltrim(QRYE5->E5_TIPODOC) <> 'ES'
			nTotal += QRYE5->E5_VALOR
		else
			nTotal -= QRYE5->E5_VALOR
		endif
		QRYE5->(dbSkip())
	End 
	
	If (Select("QRYE5") <> 0)
		QRYE5->(dbCloseArea())
	Endif
	
	
	//Baixas - Parciais
	BEGINSQL ALIAS "QRYF"
		column FI2_DTOCOR as Date
		select e5_data, e5_valor, e5_tipodoc, e5_motbx 
		from %table:FI2% FI2
		inner join %table:SE5% e5 on e5_filial = fi2_filial 
		and e5_prefixo = fi2_prefix and e5_numero = fi2_titulo and e5_parcela = fi2_parcel
		and e5_tipo = fi2_tipo and e5_clifor = fi2_codcli and e5_loja = fi2_lojcli
		where FI2.%notdel% and e5.%notdel%
		and FI2_GERADO = '2'
		and FI2_DTOCOR between %exp:MV_PAR13% AND %exp:MV_PAR14%
		and fi2_filial = %xFilial:FI2%
		and fi2_prefix = %exp:cPrf%
		and fi2_titulo = %exp:cNum%
		and fi2_parcel = %exp:cParc%
		and fi2_codcli = %exp:cCli%
		and fi2_lojcli = %exp:cLoja%
		and fi2_tipo = %exp:cTipo%
		and e5_motbx = 'NOR'
		and e5_data = fi2_dtocor
	ENDSQL
	While !QRYF->(eof())
	
		if alltrim(QRYF->E5_TIPODOC) <> 'ES'
			nTotal += QRYF->E5_VALOR
		else
			nTotal -= QRYF->E5_VALOR
		endif
		QRYF->(dbSkip())
	End 
	
	If (Select("QRYF") <> 0)
		QRYF->(dbCloseArea())
	Endif
	
	
	RestArea(aArea)

Return( nTotal )
