#include 'protheus.ch'
#include 'rwmake.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	               		!
+-------------------------------------------------------------------------------+
!Programa			! UFINR025 - Relatorio por Natureza - XML               	! 
+-------------------+-----------------------------------------------------------+
!Autor         	    ! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 30/08/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UFINR025()

	Private cPerg    := "UFINR020"
	
	Pergunte(cPerg, .T.)
	
	@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Relatório Financeiro por Natureza - XML"
	@ 8,10 TO 84,222

	@ 91,139 BMPBUTTON TYPE 5 ACTION PERGUNTE(cPerg,.T.)
	@ 91,168 BMPBUTTON TYPE 1 ACTION OKRun()  
	@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

	@ 23,14 SAY "Esta rotina ira gerar uma planilha com os valores financeiros por natureza"
	@ 33,14 SAY "conforme os parametros informados."

	ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function OKRun()

oProcpln := MsNewProcess():New({|| ProcIni(oProcpln)}, "Aguarde...", "Processando dados...")
oProcpln:Activate()

Return

/*/{Protheus.doc} ProcIni
Função de processamento da rotina
@type function
@author Crele Cristina da Costa
@since 19/03/2015
@version 1.0
@param oProcess, objeto, Objeto de processamento
/*/Static Function ProcIni(oProcpln)	
Local aStruSQL := {}

	If ( Select('TRBG') <> 0 )
		TRBG->(dbCloseArea())
	Endif
	If ( Select('TRBD') <> 0 )
		TRBD->(dbCloseArea())
	Endif

	//Montando estrutura do arquivo geral temporario
	aStruSQL := {}
	AADD(aStruSQL,{"CODIGO"		,"C", TamSx3("ED_CODIGO")[1], TamSx3("ED_CODIGO")[2] })
	AADD(aStruSQL,{"NOME"		,"C", TamSx3("ED_DESCRIC")[1], TamSx3("ED_DESCRIC")[2] })
	AADD(aStruSQL,{"VALOR"  	,"N", TamSx3("E5_VALOR")[1] , TamSx3("E5_VALOR")[2] })
	AADD(aStruSQL,{"ED_PAI"		,"C", TamSx3("ED_CODIGO")[1], TamSx3("ED_CODIGO")[2] })

	//Resumo
    oTRBG := FwTemporaryTable():New("TRBG")
	oTRBG:SetFields(aStruSQL)
	//Criação da tabela temporaria
	oTRBG:Create()

	aStruSQL := {}
	AADD(aStruSQL,{"CODIGO"		,"C", TamSx3("ED_CODIGO")[1], TamSx3("ED_CODIGO")[2] })
	AADD(aStruSQL,{"NOME"		,"C", TamSx3("ED_DESCRIC")[1], TamSx3("ED_DESCRIC")[2] })
	AADD(aStruSQL,{"ED_PAI"		,"C", TamSx3("ED_CODIGO")[1], TamSx3("ED_CODIGO")[2] })
	AADD(aStruSQL,{"TIPODOC"	,"C", TamSx3("E5_TIPODOC")[1], TamSx3("E5_TIPODOC")[2] })
	AADD(aStruSQL,{"MOTBX"		,"C", TamSx3("E5_MOTBX")[1], TamSx3("E5_MOTBX")[2] })
	AADD(aStruSQL,{"RECPAG"		,"C", TamSx3("E5_RECPAG")[1], TamSx3("E5_RECPAG")[2] })
	AADD(aStruSQL,{"CLIFOR"		,"C", TamSx3("E5_CLIFOR")[1], TamSx3("E5_CLIFOR")[2] })
	AADD(aStruSQL,{"LOJA"		,"C", TamSx3("E5_LOJA")[1], TamSx3("E5_LOJA")[2] })
	AADD(aStruSQL,{"PESSOA"		,"C", TamSx3("A1_NOME")[1], TamSx3("A1_NOME")[2] })
	AADD(aStruSQL,{"PREFIXO"	,"C", TamSx3("E5_PREFIXO")[1], TamSx3("E5_PREFIXO")[2] })
	AADD(aStruSQL,{"NUMERO"		,"C", TamSx3("E5_NUMERO")[1], TamSx3("E5_NUMERO")[2] })
	AADD(aStruSQL,{"PARCELA"	,"C", TamSx3("E5_PARCELA")[1], TamSx3("E5_PARCELA")[2] })
	AADD(aStruSQL,{"HISTOR"		,"C", TamSx3("E5_HISTOR")[1], TamSx3("E5_HISTOR")[2] })
	AADD(aStruSQL,{"DATAB"		,"D", TamSx3("E5_DATA")[1], TamSx3("E5_DATA")[2] })
	AADD(aStruSQL,{"VALOR"  	,"N", TamSx3("E5_VALOR")[1] , TamSx3("E5_VALOR")[2] })

    //Detalhamento
	oTRBD := FwTemporaryTable():New("TRBD")
	oTRBD:SetFields(aStruSQL)
    oTRBD:AddIndex("01", {"ED_PAI", "CODIGO", "PREFIXO", "NUMERO", "PARCELA"} )
	//Criação da tabela temporaria
	oTRBD:Create()

	//Realiza a busca dos dados
	ProcQryTab(oProcpln)

    //Gerar o Excel
    MsAguarde({|lEnd| goBuildExcel()},"Aguarde...","Preparando dados para a planilha...",.T.)
	
Return


Static Function ProcQryTab(oProcpln)

	oProcpln:IncRegua1("Montando QUADRO RESUMO...")
	SysRefresh()
	
	pergunte(cPerg, .F.)

	If ( Select('QRY') <> 0 )
		QRY->(dbCloseArea())
	Endif

	If ( Select('QRYD') <> 0 )
		QRYD->(dbCloseArea())
	Endif

//mv_par03 = 1 -> baixados  2 -> em aberto

    if mv_par03 == 1    //Se Baixados

        //QUADRO RESUMO - RECEBER
        cQueryR := ""
        cQueryR += "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, "
        cQueryR += "sum(case when e5_recpag = 'R' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryR += "from "+RetSqlName("SE5")+" e5 "
        cQueryR += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryR += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryR += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryR += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryR += "and e5_reconc = ' ' "
        endif

        cQueryR += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryR += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'R' "
        cQueryR += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        cQueryR += "union all "
        cQueryR += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, "
        cQueryR += "sum(case when e5_recpag = 'R' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryR += "from "+RetSqlName("SE5")+" e5 "
        cQueryR += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryR += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryR += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQueryR += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryR += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryR += "and e5_reconc = ' ' "
        endif

        cQueryR += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryR += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'R' "
        cQueryR += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        cQueryR += "union all "
        cQueryR += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, "
        cQueryR += "sum(case when e5_recpag = 'R' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryR += "from "+RetSqlName("SE5")+" e5 "
        cQueryR += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryR += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryR += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQueryR += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cQueryR += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed4.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryR += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryR += "and e5_reconc = ' ' "
        endif

        cQueryR += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryR += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'R' "
        cQueryR += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //cQueryR += "order by e5_naturez, ed_descric, ed_pai"

        //QUADRO RESUMO - PAGAR
        cQueryP := ""
        cQueryP += "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, "
        cQueryP += "sum(case when e5_recpag = 'P' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryP += "from "+RetSqlName("SE5")+" e5 "
        cQueryP += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryP += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryP += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryP += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryP += "and e5_reconc = ' ' "
        endif

        cQueryP += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryP += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'D' "
        cQueryP += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        cQueryP += "union all "
        cQueryP += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, "
        cQueryP += "sum(case when e5_recpag = 'P' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryP += "from "+RetSqlName("SE5")+" e5 "
        cQueryP += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryP += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryP += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQueryP += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryP += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryP += "and e5_reconc = ' ' "
        endif

        cQueryP += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryP += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'D' "
        cQueryP += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        cQueryP += "union all "
        cQueryP += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, "
        cQueryP += "sum(case when e5_recpag = 'P' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryP += "from "+RetSqlName("SE5")+" e5 "
        cQueryP += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQueryP += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQueryP += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQueryP += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cQueryP += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed4.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryP += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryP += "and e5_reconc = ' ' "
        endif

        cQueryP += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryP += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'D' "
        cQueryP += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //cQueryP += "order by e5_naturez, ed_descric, ed_pai"

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cQueryR
            cQuery += "order by e5_naturez, ed_descric, ed_pai"

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cQueryP
            cQuery += "order by e5_naturez, ed_descric, ed_pai"       

        else    //se AMBOS
            
            cQuery := cQueryR
            cQuery += "union all "
            cQuery += cQueryP
            cQuery += "order by e5_naturez, ed_descric, ed_pai"       

        endif

        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY')

        MemoWrite('\temp\query_resumo_natureza.txt', cQuery)

        //DETALHAMENTO - RECEBER
        cQueryR := ""
        cQueryR += "select e5_naturez, ed_descric, ed_pai, e5_tipodoc, e5_motbx, e5_recpag, e5_clifor, e5_loja, "
        cQueryR += "e5_prefixo, e5_numero, e5_parcela, e5_histor, e5_data, (case when e5_recpag = 'R' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryR += "from "+RetSqlName("SE5")+" e5 "
        cQueryR += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e5_naturez "
        cQueryR += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryR += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryR += "and e5_reconc = ' ' "
        endif

        cQueryR += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryR += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'R' "

        //DETALHAMENTO - PAGAR
        cQueryP := ""
        cQueryP += "select e5_naturez, ed_descric, ed_pai, e5_tipodoc, e5_motbx, e5_recpag, e5_clifor, e5_loja, "
        cQueryP += "e5_prefixo, e5_numero, e5_parcela, e5_histor, e5_data, (case when e5_recpag = 'P' then e5_valor else e5_valor*(-1) end) e5_valor "
        cQueryP += "from "+RetSqlName("SE5")+" e5 "
        cQueryP += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e5_naturez "
        cQueryP += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' "

        if mv_par05 == 1    //somente conciliados
            cQueryP += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQueryP += "and e5_reconc = ' ' "
        endif

        cQueryP += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQueryP += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' and ed.ed_cond = 'D' "

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cQueryR

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cQueryP

        else    //se AMBOS
            
            cQuery := cQueryR
            cQuery += "union all "
            cQuery += cQueryP

        endif

        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRYD')
        TCSetField("QRYD","E5_DATA"   ,"D",8,0)

        MemoWrite('\temp\query_detalhamento_natureza.txt', cQuery)

    else    //Em Aberto

        cReceber := "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cReceber += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        cReceber += "union all "
        cReceber += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cReceber += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        cReceber += "union all "
        cReceber += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "
        cReceber += "and ed4.d_e_l_e_t_ = ' ' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cReceber += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "

        cPagar := "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cPagar += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        cPagar += "union all "
        cPagar += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cPagar += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        cPagar += "union all "
        cPagar += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' "
        cPagar += "and ed4.d_e_l_e_t_ = ' ' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cPagar += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cReceber
            cQuery += "order by e5_naturez, ed_descric, ed_pai"       

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cPagar
            cQuery += "order by e5_naturez, ed_descric, ed_pai"       

        else    //se AMBOS
            
            cQuery := cReceber
            cQuery += "union all "
            cQuery += cPagar
            cQuery += "order by e5_naturez, ed_descric, ed_pai"       

        endif
        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY')
        
        MemoWrite('\temp\query_resumo_natureza.txt', cQuery)


        //DETALHAMENTO
        cReceber := "select e1_naturez e5_naturez, ed_descric, ed_pai, e1_tipo e5_tipodoc, '' e5_motbx, 'R' e5_recpag, e1_cliente e5_clifor, e1_loja e5_loja, "
        cReceber += "e1_prefixo e5_prefixo, e1_num e5_numero, e1_parcela e5_parcela, e1_hist e5_histor, e1_vencto e5_data, e1_saldo e5_valor "
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e1_naturez "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "

        cPagar := "select e2_naturez e5_naturez, ed_descric, ed_pai, e2_tipo e5_tipodoc, '' e5_motbx, 'P' e5_recpag, e2_fornece e5_clifor, e2_loja e5_loja, "
        cPagar += "e2_prefixo e5_prefixo, e2_num e5_numero, e2_parcela e5_parcela, e2_hist e5_histor, e2_vencto e5_data, e2_saldo e5_valor "
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e2_naturez "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cReceber

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cPagar

        else    //se AMBOS
            
            cQuery := cReceber
            cQuery += "union all "
            cQuery += cPagar

        endif
        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRYD')
        TCSetField("QRYD","E5_DATA"   ,"D",8,0)

        MemoWrite('\temp\query_detalhamento_natureza.txt', cQuery)

    endif
    
    nCount := 0
	dbEval( {|x| nCount++ },,{|| QRY->(!EOF()) })
	
	QRY->(dbGotop())
	oProcpln:SetRegua2(nCount)
	SysRefresh()
	
	While QRY->(!eof())
	
		oProcpln:IncRegua2('Alimentando temporario....')
		SysRefresh()
		
		TRBG->(reclock('TRBG', .T.))
        TRBG->CODIGO    := QRY->E5_NATUREZ
        TRBG->NOME      := QRY->ED_DESCRIC
        TRBG->VALOR     := QRY->E5_VALOR
        TRBG->ED_PAI    := QRY->ED_PAI
		TRBG->(msUnlock())
		
		QRY->(dbSkip())
	End
	QRY->(dbCloseArea())


	oProcpln:IncRegua1("Montando DETALHAMENTO...")
	SysRefresh()

    nCount := 0
	dbEval( {|x| nCount++ },,{|| QRYD->(!EOF()) })
	
	QRYD->(dbGotop())
	oProcpln:SetRegua2(nCount)
	SysRefresh()
	
	While QRYD->(!eof())
	
		oProcpln:IncRegua2('Alimentando temporario....')
		SysRefresh()

		cPessoa := ""
        if !empty(QRYD->E5_CLIFOR)
            if QRYD->E5_RECPAG == 'R'
                SA1->(dbSetOrder(1))
                SA1->(msSeek(xFilial('SA1') + QRYD->E5_CLIFOR + QRYD->E5_LOJA))
                cPessoa := SA1->A1_NOME
            else
                SA2->(dbSetOrder(1))
                SA2->(msSeek(xFilial('SA2') + QRYD->E5_CLIFOR + QRYD->E5_LOJA))
                cPessoa := SA2->A2_NOME
            endif
        endif

        TRBD->(reclock('TRBD', .T.))
        TRBD->CODIGO    := QRYD->E5_NATUREZ
        TRBD->NOME      := QRYD->ED_DESCRIC
        TRBD->ED_PAI    := QRYD->ED_PAI
        TRBD->TIPODOC   := QRYD->E5_TIPODOC
        TRBD->MOTBX     := QRYD->E5_MOTBX
        TRBD->RECPAG    := QRYD->E5_RECPAG
        TRBD->CLIFOR    := QRYD->E5_CLIFOR
        TRBD->LOJA      := QRYD->E5_LOJA
        TRBD->PESSOA    := cPessoa
        TRBD->PREFIXO   := QRYD->E5_PREFIXO
        TRBD->NUMERO    := QRYD->E5_NUMERO
        TRBD->PARCELA   := QRYD->E5_PARCELA
        TRBD->HISTOR    := QRYD->E5_HISTOR
        TRBD->DATAB     := QRYD->E5_DATA
        TRBD->VALOR     := QRYD->E5_VALOR
		TRBD->(msUnlock())
		
		QRYD->(dbSkip())
	End
	QRYD->(dbCloseArea())

Return

Static Function goBuildExcel( )

//Local oExcel		:= FWMSEXCEL():New()
Local oExcel		:= FWMsExcelEx():New()

Local cWrkSht       := ""
Local cTabTitle     := ""

Local lTotalize		:= .F.

Local nField

BEGIN SEQUENCE
	
	MsProcTxt("Criando a estrutura da Planilha...")

    aHeadGrupo	:= {}
	AADD(aHeadGrupo,{ "Classificação","CODIGO"	,"C", tamSx3('ED_CODIGO')[1], tamSx3('ED_CODIGO')[2],  "" } )
	AADD(aHeadGrupo,{ "Descrição"  	,"NOME"	    ,"C", tamSx3('ED_DESCRIC')[1], tamSx3('ED_DESCRIC')[2],  "" } )
	AADD(aHeadGrupo,{ "Valor"	    ,"VALOR"	,"N", tamSx3('E5_VALOR')[1], tamSx3('E5_VALOR')[2],  PesqPict("SE5","E5_VALOR") } )
	//AADD(aHeadGrupo,{ "Pai"         ,"ED_PAI"	,"C", tamSx3('ED_CODIGO')[1], tamSx3('ED_CODIGO')[2],  "" } )

    cTabTitle   := "QUADRO RESUMO - " + dtoc(mv_par01) + ' ATE ' + dtoc(mv_par02)
    
    //cWrkSht    := 'VALORES POR NATUREZA DE: ' + dtoc(mv_par01) + ' ATE ' + dtoc(mv_par02)
    cWrkSht    := 'RESUMO - '
    if mv_par04 == 1
        cWrkSht += 'A RECEBER'
    elseif mv_par04 == 2
        cWrkSht += 'A PAGAR'
    else
        cWrkSht += 'A RECEBER E A PAGAR'
    endif
    if mv_par03 == 1
        cWrkSht += ' - BAIXADOS'
    else
        cWrkSht += ' - EM ABERTO'
    endif
    
    
    //Primeira planilha
    oExcel:AddworkSheet(cWrkSht)
    oExcel:AddTable(cWrkSht, cTabTitle)

    //Cria as colunas 
    nFields := Len( aHeadGrupo )
    For nField := 1 To nFields
        
        //If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
            cType := aHeadGrupo[nField][3]	//__AHEADER_TYPE__
            nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
            nFormat := IF(cType=="D",4,IF(cType=="N",2,1)) 
            cColumn := aHeadGrupo[nField][1]	//__AHEADER_TITLE__
            lTotal := ( lTotalize .and. cType == "N" )
            oExcel:AddColumn(@cWrkSht,@cTabTitle,@cColumn,@nAlign,@nFormat,@lTotal)
        //EndIf
        
    Next nField
    
    //Popula a planilha
    aCells := Array(nFields)
    
    MsProcTxt("Populando a planilha com os valores...")

    TRBG->(dbGotop())
    While TRBG->(!eof())
        
        For nField := 1 To nFields
            
            //If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
                uCell := &('TRBG->' + aHeadGrupo[nField][2])
                cPicture := aHeadGrupo[nField][6]	//__AHEADER_PICTURE__
                IF ValType(uCell) # "N" .And. !( Empty(cPicture) )
                    uCell := Transform(uCell,cPicture)
                ElseIf ValType(uCell) == "N"
                    uCell := 'R$ ' + AllTrim(Transform(uCell,"@E 999,999,999,999.99"))
                EndIF
                aCells[nField] := uCell
            //EndIf
            
        Next
        
        if empty(TRBG->ED_PAI)
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#FFFFFF")
            oExcel:SetCelBgColor("#203764")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        elseif len(alltrim(TRBG->ED_PAI)) == 1
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#8EA9DB")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        else
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#D9E1F2")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        endif

        TRBG->(dbSkip())
        
    EndDo

    //DETALHAMENTO
    cTabTitle   := "DETALHAMENTO - " + dtoc(mv_par01) + ' ATE ' + dtoc(mv_par02)

    cWrkSht    := 'DETALHES - '
    if mv_par04 == 1
        cWrkSht += 'A RECEBER'
    elseif mv_par04 == 2
        cWrkSht += 'A PAGAR'
    else
        cWrkSht += 'A RECEBER E A PAGAR'
    endif
    if mv_par03 == 1
        cWrkSht += ' - BAIXADOS'
    else
        cWrkSht += ' - EM ABERTO'
    endif

    //Segunda planilha
    oExcel:AddworkSheet(cWrkSht)
    oExcel:AddTable(cWrkSht, cTabTitle)

    aHeadDet	:= {}
	AADD(aHeadDet,{ "Classificação" ,"CODIGO"	,"C", tamSx3('ED_CODIGO')[1], tamSx3('ED_CODIGO')[2],  "" } )
	AADD(aHeadDet,{ "Descrição"     ,"NOME"	    ,"C", tamSx3('ED_DESCRIC')[1], tamSx3('ED_DESCRIC')[2],  "" } )
	AADD(aHeadDet,{ "Pessoa"        ,"PESSOA"   ,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHeadDet,{ "Documento"     ,"DOCUMENTO","C", 20, 0,  "" } )
	AADD(aHeadDet,{ "Observação"    ,"HISTOR"   ,"C", tamSx3('E5_HISTOR')[1], tamSx3('E5_HISTOR')[2],  "" } )
	AADD(aHeadDet,{ "Data"          ,"DATAB"    ,"D", tamSx3('E5_DATA')[1], tamSx3('E5_DATA')[2],  "" } )
	AADD(aHeadDet,{ "Valor"	        ,"VALOR"	,"N", tamSx3('E5_VALOR')[1], tamSx3('E5_VALOR')[2],  PesqPict("SE5","E5_VALOR") } )

    //Cria as colunas 
    nFields := Len( aHeadDet )
    For nField := 1 To nFields
        
        //If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
            cType := aHeadDet[nField][3]	//__AHEADER_TYPE__
            nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
            nFormat := IF(cType=="D",4,IF(cType=="N",2,1)) 
            cColumn := aHeadDet[nField][1]	//__AHEADER_TITLE__
            lTotal := ( lTotalize .and. cType == "N" )
            oExcel:AddColumn(@cWrkSht,@cTabTitle,@cColumn,@nAlign,@nFormat,@lTotal)
        //EndIf
        
    Next nField

    //Popula a planilha
    aCells := Array(nFields)
    
    MsProcTxt("Populando a planilha com os valores...")

    TRBG->(dbGotop())
    While TRBG->(!eof())

        if empty(TRBG->ED_PAI)
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#FFFFFF")
            oExcel:SetCelBgColor("#203764")
        elseif len(alltrim(TRBG->ED_PAI)) == 1
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#8EA9DB")
        else
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#D9E1F2")
        endif
        oExcel:AddRow(@cWrkSht,@cTabTitle,{TRBG->CODIGO, TRBG->NOME,"","","","",'R$ ' + AllTrim(Transform(TRBG->VALOR,"@E 999,999,999,999.99"))},{1,2,3,4,5,6,7})

        TRBD->(msSeek(TRBG->CODIGO, .T.))
        While TRBD->(!eof()) .and. TRBD->ED_PAI == TRBG->CODIGO
            
            For nField := 1 To nFields
                
                if aHeadDet[nField][2] <> 'DOCUMENTO'
                    uCell := &('TRBD->' + aHeadDet[nField][2])
                    cPicture := aHeadDet[nField][6]	//__AHEADER_PICTURE__
                    IF ValType(uCell) # "N" .And. !( Empty(cPicture) )
                        uCell := Transform(uCell,cPicture)
                    ElseIf ValType(uCell) == "N"
                        uCell := 'R$ ' + AllTrim(Transform(uCell,"@E 999,999,999,999.99"))
                    EndIF
                    aCells[nField] := uCell
                else
                    aCells[nField] := TRBD->PREFIXO + ' - ' + TRBD->NUMERO  + ' - ' + TRBD->PARCELA
                EndIf
                
            Next
            
            oExcel:SetCelBold(.F.)
            if TRBD->VALOR > 0
                oExcel:SetCelFrColor("#000000")
            else 
                oExcel:SetCelFrColor("#FF0000")
            endif
            oExcel:SetCelBgColor("#FFFFFF")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7})

            TRBD->(dbSkip())
            
        EndDo

        TRBG->(dbSkip())
        
    EndDo

    //OUTROS
    lTemO := .F.
    TRBD->(msSeek(padR("",tamSx3("ED_CODIGO")[1]), .T.))
    lTemO := iif(alltrim(TRBD->ED_PAI) == alltrim(padR("",tamSx3("ED_CODIGO")[1])), .T., .F.)
    if lTemO
        oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
        oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
        oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
        oExcel:SetCelBold(.T.)
        oExcel:SetCelFrColor("#FFFFFF")
        oExcel:SetCelBgColor("#203764")
        oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "OUTROS","","","","",""},{1,2,3,4,5,6,7})

        TRBD->(msSeek(padR("",tamSx3("ED_CODIGO")[1]), .T.))
        While TRBD->(!eof()) .and. TRBD->ED_PAI == padR("",tamSx3("ED_CODIGO")[1])
            
            For nField := 1 To nFields
                
                if aHeadDet[nField][2] <> 'DOCUMENTO'
                    uCell := &('TRBD->' + aHeadDet[nField][2])
                    cPicture := aHeadDet[nField][6]	//__AHEADER_PICTURE__
                    IF ValType(uCell) # "N" .And. !( Empty(cPicture) )
                        uCell := Transform(uCell,cPicture)
                    ElseIf ValType(uCell) == "N"
                        uCell := 'R$ ' + AllTrim(Transform(uCell,"@E 999,999,999,999.99"))
                    EndIF
                    aCells[nField] := uCell
                else
                    aCells[nField] := TRBD->PREFIXO + ' - ' + TRBD->NUMERO  + ' - ' + TRBD->PARCELA
                EndIf
                
            Next
            
            oExcel:SetCelBold(.F.)
            if TRBD->VALOR > 0
                oExcel:SetCelFrColor("#000000")
            else 
                oExcel:SetCelFrColor("#FF0000")
            endif
            oExcel:SetCelBgColor("#FFFFFF")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7})

            TRBD->(dbSkip())
            
        EndDo
    endif

	oExcel:Activate()
	
	MsProcTxt("Criando a planilha para visualização...")
	
	//Nome do Arquivo
	cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	
	While File( cFile )
		cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	End While
	
	oExcel:GetXMLFile( cFile )
	
	oExcel:DeActivate()
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	cFileTMP := ( GetTempPath() + cFile )
	IF .NOT.( __CopyFile( cFile , cFileTMP ) )
		alert('nao deu de copiar')
		fErase( cFile )
		cFile := ""
		BREAK
	EndIF

	fErase( cFile )
	
	cFile := cFileTMP
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	IF .NOT.( ApOleClient("MsExcel") )
		alert('nao sera possivel abrir excel')
		BREAK
	EndIF
	
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open( cFile )
	oMsExcel:SetVisible( .T. )
	oMsExcel := oMsExcel:Destroy()

END SEQUENCE

oExcel := FreeObj( oExcel )

Return
