#include 'protheus.ch'
#include 'rwmake.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	               		!
+-------------------------------------------------------------------------------+
!Programa			! UFINR020 - Relatorio por Natureza - XML               	! 
+-------------------+-----------------------------------------------------------+
!Autor         	    ! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 30/08/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UFINR020()

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

if mv_par06 == 2

    If !(AllTrim(__cUserId) $ SuperGetMv("IN_USRMANR",,"000000"))
        MsgInfo("Usuário sem permissão para utilizar esta opção, apenas gerar o RELATORIO!")
        Return
    endif

endif

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
    //if mv_par07 == 1    //filtra por filial
    //	AADD(aStruSQL,{"FILIAL"		,"C", TamSx3("E5_FILORIG")[1], TamSx3("E5_FILORIG")[2] })
    //endif
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
	AADD(aStruSQL,{"EDITADO"	,"C", 01, 0 })
    //if mv_par07 == 1    //filtra por filial
    //	AADD(aStruSQL,{"FILIAL"		,"C", TamSx3("E5_FILORIG")[1], TamSx3("E5_FILORIG")[2] })
    //endif
	AADD(aStruSQL,{"E5_NATUREZ"	,"C", TamSx3("E5_NATUREZ")[1], TamSx3("E5_NATUREZ")[2] })
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
	AADD(aStruSQL,{"BENEF"		,"C", TamSx3("E5_BENEF")[1], TamSx3("E5_BENEF")[2] })
	AADD(aStruSQL,{"DATAB"		,"D", TamSx3("E5_DATA")[1], TamSx3("E5_DATA")[2] })
	AADD(aStruSQL,{"VALOR"  	,"N", TamSx3("E5_VALOR")[1] , TamSx3("E5_VALOR")[2] })
	AADD(aStruSQL,{"EXRECNO"  	,"N", 12 , 0 })

    //Detalhamento
	oTRBD := FwTemporaryTable():New("TRBD")
	oTRBD:SetFields(aStruSQL)
    //if mv_par07 == 1    //filtra por filial
    //    //oTRBD:AddIndex("01", {"ED_PAI", "FILIAL", "E5_NATUREZ", "PREFIXO", "NUMERO", "PARCELA"} )
    //    oTRBD:AddIndex("01", {"FILIAL", "ED_PAI", "E5_NATUREZ", "PREFIXO", "NUMERO", "PARCELA"} )
    //else
        oTRBD:AddIndex("01", {"ED_PAI", "E5_NATUREZ", "PREFIXO", "NUMERO", "PARCELA"} )
    //endif
	//Criação da tabela temporaria
	oTRBD:Create()

	//Realiza a busca dos dados
	ProcQryTab(oProcpln)

    //Se processa o relatorio
    if mv_par06 == 1

        //Gerar o Excel
        MsAguarde({|lEnd| goBuildExcel()},"Aguarde...","Preparando dados para a planilha...",.T.)

    //Se processa a manutencao dos dados, monta HEADER do browse
    else

        Private aHeader := {}
        Aadd(aHeader, {"  "             , "EDITADO", "", 01, 0, "", "", "C", "", ""})
        //if mv_par07 == 1    //filtra por filial
        //    Aadd(aHeader, {"Filial"         , "FILIAL", "", tamSx3('E5_FILORIG')[1], tamSx3('E5_FILORIG')[2], "", "", "C", "", ""})
        //endif
        Aadd(aHeader, {"Codigo"         , "E5_NATUREZ", "", tamSx3('E5_NATUREZ')[1], tamSx3('E5_NATUREZ')[2], "u_FINV1020(1)", "", "C", "", ""})
        Aadd(aHeader, {"Natureza"       , "NOME", "", tamSx3('ED_DESCRIC')[1], tamSx3('ED_DESCRIC')[2], "", "", "C", "", ""})
        Aadd(aHeader, {"Beneficiário"   , "BENEF", "@!", tamSx3('E5_BENEF')[1], tamSx3('E5_BENEF')[2], "u_FINV1020(2)", "", "C", "", ""})
        Aadd(aHeader, {"Data"           , "DATAB", "", tamSx3('E5_DATA')[1], tamSx3('E5_DATA')[2], "", "", "D", "", ""})
        Aadd(aHeader, {"Prefixo"        , "PREFIXO", "", tamSx3('E5_PREFIXO')[1], tamSx3('E5_PREFIXO')[2], "", "", "C", "", ""})
        Aadd(aHeader, {"Numero"         , "NUMERO", "", tamSx3('E5_NUMERO')[1], tamSx3('E5_NUMERO')[2], "", "", "C", "", ""})
        Aadd(aHeader, {"Parcela"        , "PARCELA", "", tamSx3('E5_PARCELA')[1], tamSx3('E5_PARCELA')[2], "", "", "C", "", ""})
        Aadd(aHeader, {"Histórico"      , "HISTOR", "@!", tamSx3('E5_HISTOR')[1], tamSx3('E5_HISTOR')[2], "u_FINV1020(3)", "", "C", "", ""})
        Aadd(aHeader, {"Valor"          , "VALOR", PesqPict("SE5","E5_VALOR"), tamSx3('E5_VALOR')[1], tamSx3('E5_VALOR')[2], "", "", "N", "", ""})

        goBuildWin()

    endif

	
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

        //QUADRO RESUMO
        cQuery := ""
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //else
        //    cQuery += "select e5_filorig filial, ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //endif
        cQuery += "from "+RetSqlName("SE5")+" e5 "
        cQuery += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQuery += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQuery += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "

        if mv_par04 == 1    //se a receber
            cQuery += "and e5_recpag = 'R' "
        elseif mv_par04 == 2    //se a pagar
            cQuery += "and e5_recpag = 'P' "
        endif
        if mv_par05 == 1    //somente conciliados
            cQuery += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQuery += "and e5_reconc = ' ' "
        endif

        if mv_par07 == 1
            cQuery += "and e5_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif

        cQuery += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQuery += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' "
        cQuery += "and e5_tipodoc <> 'E2' "
        cQuery += "and e5_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //else
        //    cQuery += "group by e5_filorig,ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //endif
        cQuery += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //else
        //    cQuery += "select e5_filorig filial,ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //endif
        cQuery += "from "+RetSqlName("SE5")+" e5 "
        cQuery += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQuery += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQuery += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQuery += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "

        if mv_par04 == 1    //se a receber
            cQuery += "and e5_recpag = 'R' "
        elseif mv_par04 == 2    //se a pagar
            cQuery += "and e5_recpag = 'P' "
        endif
        if mv_par05 == 1    //somente conciliados
            cQuery += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQuery += "and e5_reconc = ' ' "
        endif

        if mv_par07 == 1
            cQuery += "and e5_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif

        cQuery += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQuery += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' "
        cQuery += "and e5_tipodoc <> 'E2' "
        cQuery += "and e5_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //else
        //    cQuery += "group by e5_filorig,ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //endif
        cQuery += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //else
        //    cQuery += "select e5_filorig filial,ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e5_valor) e5_valor "
        //endif
        cQuery += "from "+RetSqlName("SE5")+" e5 "
        cQuery += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e5_naturez "
        cQuery += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cQuery += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cQuery += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cQuery += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed4.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "

        if mv_par04 == 1    //se a receber
            cQuery += "and e5_recpag = 'R' "
        elseif mv_par04 == 2    //se a pagar
            cQuery += "and e5_recpag = 'P' "
        endif
        if mv_par05 == 1    //somente conciliados
            cQuery += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQuery += "and e5_reconc = ' ' "
        endif

        if mv_par07 == 1
            cQuery += "and e5_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif

        cQuery += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQuery += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' "
        cQuery += "and e5_tipodoc <> 'E2' "
        cQuery += "and e5_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
            cQuery += "order by e5_naturez, ed_descric, ed_pai"
        //else
        //    cQuery += "group by e5_filorig,ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //    cQuery += "order by e5_filorig,e5_naturez, ed_descric, ed_pai"
        //endif

        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY')

        MemoWrite('\temp\query_resumo_natureza.txt', cQuery)

        //DETALHAMENTO
        cQuery := ""
        //if mv_par07 == 2    //nao filtra por filial
            cQuery += "select e5_naturez, ed_descric, ed_pai, e5_tipodoc, e5_motbx, e5_recpag, e5_clifor, e5_loja, "
        //else
        //    cQuery += "select e5_filorig filial,e5_naturez, ed_descric, ed_pai, e5_tipodoc, e5_motbx, e5_recpag, e5_clifor, e5_loja, "
        //endif
        cQuery += "e5_prefixo, e5_numero, e5_parcela, e5_histor, e5_data, e5_benef, e5_valor, e5.r_e_c_n_o_ e5recno "
        cQuery += "from "+RetSqlName("SE5")+" e5 "
        cQuery += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e5_naturez "
        cQuery += "where e5.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "

        if mv_par04 == 1    //se a receber
            cQuery += "and e5_recpag = 'R' "
        elseif mv_par04 == 2    //se a pagar
            cQuery += "and e5_recpag = 'P' "
        endif
        if mv_par05 == 1    //somente conciliados
            cQuery += "and e5_reconc = 'x' "
        elseif mv_par05 == 2    //desconsidera conciliados
            cQuery += "and e5_reconc = ' ' "
        endif

        if mv_par07 == 1
            cQuery += "and e5_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif

        cQuery += "and e5_data between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        cQuery += "and e5_situaca <> 'C' and e5_dtcanbx = ' ' "
        cQuery += "and e5_tipodoc <> 'E2' "
        cQuery += "and e5_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        
        //if mv_par07 == 1
        //    cQuery += "order by e5_filorig, e5_naturez,ed_pai, e5_data "
        //endif

        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRYD')
        TCSetField("QRYD","E5_DATA"   ,"D",8,0)

        MemoWrite('\temp\query_detalhamento_natureza.txt', cQuery)

    else    //Em Aberto

        //if mv_par07 == 2    //nao filtra por filial
            cReceber := "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //else
        //    cReceber := "select e1_filorig filial, ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //endif
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cReceber += "and e1_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cReceber += "and e1_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cReceber += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //else
        //    cReceber += "group by e1_filorig,ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //endif
        cReceber += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cReceber += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //else
        //    cReceber += "select e1_filorig filial, ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //endif
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cReceber += "and e1_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cReceber += "and e1_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cReceber += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //else
        //    cReceber += "group by e1_filorig,ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //endif
        cReceber += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cReceber += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //else
        //    cReceber += "select e1_filorig filial, ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e1_saldo) e5_valor "
        //endif
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e1_naturez "
        cReceber += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cReceber += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cReceber += "and ed4.d_e_l_e_t_ = ' ' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cReceber += "and e1_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cReceber += "and e5_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cReceber += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //else
        //    cReceber += "group by e1_filorig,ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //endif

        //if mv_par07 == 2    //nao filtra por filial
            cPagar := "select ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //else
        //    cPagar := "select e2_filorig filial, ed.ed_pai e5_naturez, ed2.ed_descric ed_descric, ed2.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //endif
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cPagar += "and e2_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cPagar += "and e2_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cPagar += "group by ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //else
        //    cPagar += "group by e2_filorig,ed.ed_pai,ed2.ed_descric, ed2.ed_pai "
        //endif
        cPagar += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cPagar += "select ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //else
        //    cPagar += "select e2_filorig filial, ed2.ed_pai e5_naturez, ed3.ed_descric ed_descric, ed3.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //endif
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cPagar += "and e2_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cPagar += "and e2_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cPagar += "group by ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //else
        //    cPagar += "group by e2_filorig,ed2.ed_pai,ed3.ed_descric, ed3.ed_pai "
        //endif
        cPagar += "union all "
        //if mv_par07 == 2    //nao filtra por filial
            cPagar += "select ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //else
        //    cPagar += "select e2_filorig filial, ed3.ed_pai e5_naturez, ed4.ed_descric ed_descric, ed4.ed_pai ed_pai, sum(e2_saldo) e5_valor "
        //endif
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed.ed_codigo = e2_naturez "
        cPagar += "inner join "+RetSqlName("SED")+" ed2 on ed2.ed_codigo = ed.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed3 on ed3.ed_codigo = ed2.ed_pai "
        cPagar += "inner join "+RetSqlName("SED")+" ed4 on ed4.ed_codigo = ed3.ed_pai "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed2.d_e_l_e_t_ = ' ' and ed3.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cPagar += "and ed4.d_e_l_e_t_ = ' ' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cPagar += "and e2_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cPagar += "and e2_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "
        //if mv_par07 == 2    //nao filtra por filial
            cPagar += "group by ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //else
        //    cPagar += "group by e2_filorig,ed3.ed_pai,ed4.ed_descric, ed4.ed_pai "
        //endif

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cReceber
            //if mv_par07 == 2    //nao filtra por filial
                cQuery += "order by e5_naturez, ed_descric, ed_pai"       
            //else
            //    cQuery += "order by filial, e5_naturez, ed_descric, ed_pai"       
            //endif

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cPagar
            //if mv_par07 == 2    //nao filtra por filial
                cQuery += "order by e5_naturez, ed_descric, ed_pai"       
            //else
            //    cQuery += "order by filial, e5_naturez, ed_descric, ed_pai"       
            //endif

        else    //se AMBOS
            
            cQuery := cReceber
            cQuery += "union all "
            cQuery += cPagar
            //if mv_par07 == 2    //nao filtra por filial
                cQuery += "order by e5_naturez, ed_descric, ed_pai"       
            //else
            //    cQuery += "order by filial, e5_naturez, ed_descric, ed_pai"       
            //endif

        endif
        cQuery := ChangeQuery(cQuery)
        dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY')
        
        MemoWrite('\temp\query_resumo_natureza.txt', cQuery)


        //DETALHAMENTO
        //if mv_par07 == 2    //nao filtra por filial
            cReceber := "select e1_naturez e5_naturez, ed_descric, ed_pai, e1_tipo e5_tipodoc, '' e5_motbx, 'R' e5_recpag, e1_cliente e5_clifor, e1_loja e5_loja, "
        //else
        //    cReceber := "select e1_filorig filial, e1_naturez e5_naturez, ed_descric, ed_pai, e1_tipo e5_tipodoc, '' e5_motbx, 'R' e5_recpag, e1_cliente e5_clifor, e1_loja e5_loja, "
        //endif
        cReceber += "e1_prefixo e5_prefixo, e1_num e5_numero, e1_parcela e5_parcela, e1_hist e5_histor, e1_vencto e5_data, e1_saldo e5_valor, "
        cReceber += "e1.r_e_c_n_o_ e5recno "
        cReceber += "from "+RetSqlName("SE1")+" e1 "
        cReceber += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e1_naturez "
        cReceber += "where e1.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cReceber += "and e1_saldo > 0 "
        cReceber += "and e1_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cReceber += "and e1_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cReceber += "and e1_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "

        //if mv_par07 == 2    //nao filtra por filial
            cPagar := "select e2_naturez e5_naturez, ed_descric, ed_pai, e2_tipo e5_tipodoc, '' e5_motbx, 'P' e5_recpag, e2_fornece e5_clifor, e2_loja e5_loja, "
        //else
        //    cPagar := "select e2_filorig filial, e2_naturez e5_naturez, ed_descric, ed_pai, e2_tipo e5_tipodoc, '' e5_motbx, 'P' e5_recpag, e2_fornece e5_clifor, e2_loja e5_loja, "
        //endif
        cPagar += "e2_prefixo e5_prefixo, e2_num e5_numero, e2_parcela e5_parcela, e2_hist e5_histor, e2_vencto e5_data, e2_saldo e5_valor, "
        cPagar += "e2.r_e_c_n_o_ e5recno "
        cPagar += "from "+RetSqlName("SE2")+" e2 "
        cPagar += "inner join "+RetSqlName("SED")+" ed on ed_codigo = e2_naturez "
        cPagar += "where e2.d_e_l_e_t_ = ' ' and ed.d_e_l_e_t_ = ' ' and ed.ed_xreldre <> 'N' "
        cPagar += "and e2_saldo > 0 "
        cPagar += "and e2_vencto between '" + dtos(mv_par01) + "' and '" + dtos(mv_par02) + "' "
        if mv_par07 == 1
            cPagar += "and e2_filorig between '" + mv_par08 + "' and '" + mv_par09 + "' "
        endif
        cPagar += "and e2_naturez between '" + mv_par10 + "' and '" + mv_par11 + "' "

        if mv_par04 == 1    //Somente a RECEBER

            cQuery := cReceber

        elseif mv_par04 == 2    //Somente a PAGAR

            cQuery := cPagar

        else    //se AMBOS
            
            cQuery := cReceber
            cQuery += "union all "
            cQuery += cPagar

        endif

        //if mv_par07 == 1
        //    cQuery += "order by filial, e5_naturez,ed_pai "
        //endif
        
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
        //if mv_par07 == 1
        //    TRBG->FILIAL := QRY->FILIAL
        //endif
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
        //if mv_par07 == 1
        //    TRBD->FILIAL := QRYD->FILIAL
        //endif
        TRBD->E5_NATUREZ:= QRYD->E5_NATUREZ
        TRBD->NOME      := QRYD->ED_DESCRIC
        TRBD->ED_PAI    := iif(mv_par06 == 1, QRYD->ED_PAI, repli("X",tamSx3("E5_NATUREZ")[1]))
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
        TRBD->BENEF     := iif(mv_par03 == 1, QRYD->E5_BENEF, cPessoa)
        TRBD->DATAB     := QRYD->E5_DATA
        TRBD->VALOR     := QRYD->E5_VALOR
        TRBD->EXRECNO   := QRYD->E5RECNO
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
    //if mv_par07 == 1
    //	AADD(aHeadGrupo,{ "Filial","FILIAL"	,"C", tamSx3('E5_FILORIG')[1], tamSx3('E5_FILORIG')[2],  "" } )
    //endif
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
            //if mv_par07 == 1
            //    oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4})
            //else
                oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
            //endif
        elseif len(alltrim(TRBG->ED_PAI)) == 1
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#8EA9DB")
            //if mv_par07 == 1
            //    oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4})
            //else
                oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
            //endif
        else
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#D9E1F2")
            //if mv_par07 == 1
            //    oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4})
            //else
                oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
            //endif
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
    //if mv_par07 == 1
    //	AADD(aHeadDet,{ "Filial","FILIAL"	,"C", tamSx3('E5_FILORIG')[1], tamSx3('E5_FILORIG')[2],  "" } )
    //endif
	AADD(aHeadDet,{ "Classificação" ,"E5_NATUREZ","C", tamSx3('E5_NATUREZ')[1], tamSx3('E5_NATUREZ')[2],  "" } )
	AADD(aHeadDet,{ "Descrição"     ,"NOME"	    ,"C", tamSx3('ED_DESCRIC')[1], tamSx3('ED_DESCRIC')[2],  "" } )
	//AADD(aHeadDet,{ "Pessoa"        ,"PESSOA"   ,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
	AADD(aHeadDet,{ "Pessoa"        ,"BENEF"    ,"C", tamSx3('A1_NOME')[1], tamSx3('A1_NOME')[2],  "" } )
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

        cCondic := ""
        //if mv_par07 == 1
        //    //cCondic := "TRBD->ED_PAI + TRBD->FILIAL == TRBG->CODIGO + TRBG->FILIAL"
        //    cCondic := "TRBD->FILIAL + TRBD->ED_PAI == TRBG->FILIAL + TRBG->CODIGO"
        //    oExcel:AddRow(@cWrkSht,@cTabTitle,{TRBG->FILIAL,TRBG->CODIGO, TRBG->NOME,"","","","",'R$ ' + AllTrim(Transform(TRBG->VALOR,"@E 999,999,999,999.99"))},{1,2,3,4,5,6,7,8})
        //else
            cCondic := "TRBD->ED_PAI == TRBG->CODIGO"
            oExcel:AddRow(@cWrkSht,@cTabTitle,{TRBG->CODIGO, TRBG->NOME,"","","","",'R$ ' + AllTrim(Transform(TRBG->VALOR,"@E 999,999,999,999.99"))},{1,2,3,4,5,6,7})
        //endif

        //if mv_par07 == 1
        //    TRBD->(msSeek(TRBG->FILIAL + TRBG->CODIGO, .T.))
        //else
            TRBD->(msSeek(TRBG->CODIGO, .T.))
        //endif
        //While TRBD->(!eof()) .and. TRBD->ED_PAI == TRBG->CODIGO
        While TRBD->(!eof()) .and. &(cCondic)
            
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
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#FFFFFF")
            //if mv_par07 == 1
            //    oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7,8})
            //else
                oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7})
            //endif

            TRBD->(dbSkip())
            
        EndDo

        TRBG->(dbSkip())
        
    EndDo

    //OUTROS
    lTemO := .F.
    TRBD->(msSeek(padR("",tamSx3("E5_NATUREZ")[1]), .T.))
    lTemO := iif(alltrim(TRBD->ED_PAI) == alltrim(padR("",tamSx3("E5_NATUREZ")[1])), .T., .F.)
    if lTemO
        //if mv_par07 == 1
        //    oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","","",""},{1,2,3,4,5,6,7,8})
        //    oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","","",""},{1,2,3,4,5,6,7,8})
        //    oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","","",""},{1,2,3,4,5,6,7,8})
        //    oExcel:SetCelBold(.T.)
        //    oExcel:SetCelFrColor("#FFFFFF")
        //    oExcel:SetCelBgColor("#203764")
        //    oExcel:AddRow(@cWrkSht,@cTabTitle,{"","", "OUTROS","","","","",""},{1,2,3,4,5,6,7,8})
        //else
            oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
            oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
            oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "","","","","",""},{1,2,3,4,5,6,7})
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#FFFFFF")
            oExcel:SetCelBgColor("#203764")
            oExcel:AddRow(@cWrkSht,@cTabTitle,{"", "OUTROS","","","","",""},{1,2,3,4,5,6,7})
        //endif

        TRBD->(msSeek(padR("",tamSx3("E5_NATUREZ")[1]), .T.))
        While TRBD->(!eof()) .and. TRBD->ED_PAI == padR("",tamSx3("E5_NATUREZ")[1])
            
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
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#FFFFFF")
            //if mv_par07 == 1
            //    oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7,8})
            //else
                oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3,4,5,6,7})
            //endif

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


Static Function goBuildWin()

	Local oDlgMain
    Local lOkMan := .F.

    Private dFil001 := ctod(''), oGetF001
    Private nFil002 := 0, oGetF002

	Private aRotina := {{ "aRotina Falso", "AxPesq",	0, 1 },;
						{ "aRotina Falso", "AxVisual",	0, 2 },;
						{ "aRotina Falso", "AxInclui",	0, 3 },;
						{ "aRotina Falso", "AxAltera",	0, 4 }}

	Private aSize      := MsAdvSize(.F., .F.)
	Private aObjects   := {{ 100, 100 , .T., .T. }} 
	Private aInfo      := {aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], -3, -13}
	Private aPosObj    := MsObjSize( aInfo, aObjects)

    aAlts := iif(mv_par03 == 1, {"E5_NATUREZ","BENEF","HISTOR"}, {"E5_NATUREZ","HISTOR"})

	//DEFINE MSDIALOG oDlgMain FROM aSize[7], 0 TO aSize[6]/1.3, aSize[5]/1.3 TITLE 'RELATORIO DE NATUREZAS' OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE, WS_POPUP) PIXEL
	DEFINE MSDIALOG oDlgMain FROM aSize[7], 0 TO aSize[6], aSize[5] TITLE 'RELATORIO DE NATUREZAS' OF oMainWnd COLOR "W+/W" PIXEL

		//oDlgMain:lEscClose := .F.

		oLayerXML := FWLayer():New()
		oLayerXML:Init(oDlgMain, .F.)

		oLayerXML:AddLine('MAIN', 90, .F.)
		
			oLayerXML:AddCollumn('COL_MAIN', 100, .T., 'MAIN')
			
			oLayerXML:AddWindow('COL_MAIN', 'WIN_COL_MAIN', "MANUTENCAO DOS DADOS", 100, .F., .T., , 'MAIN',)

			//oBrwXML := MsGetDB():New(05, 05, 145, 195, 3, "AlwaysTrue", "AlwaysTrue", , .T., {"QTDEU","C6_ZMOTRES"},, .F., 999, cAliXML, , , .F., oLayerXML:GetWinPanel('COL_MAIN', 'WIN_COL_MAIN', 'MAIN'), , , "AlwaysTrue",)
			oBrwXML := MsGetDB():New(05, 05, 145, 195, 3, "AlwaysTrue", "AlwaysTrue", , .T., aAlts,, .F., 999, "TRBD", , , .F., oLayerXML:GetWinPanel('COL_MAIN', 'WIN_COL_MAIN', 'MAIN'), , , "AlwaysTrue",)
			oBrwXML:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

			oBrwXML:oBrowse:bAdd := {|| }
			//oBrwXML:oBrowse:bLDblClick := {|nRow, nCol| U_SENX8CLK(nRow, nCol)}


		oLayerXML:AddLine('BUTTON', 10, .F.)
			
			oLayerXML:AddCollumn('COL_BUTTON', 100, .T., 'BUTTON')

			oPanelBot := tPanel():New(0, 0, "", oLayerXML:GetColPanel('COL_BUTTON', 'BUTTON'), , , , , RGB(239, 243, 247), 000, 015)
			oPanelBot:Align	:= CONTROL_ALIGN_ALLCLIENT

            @ 005, 010 SAY "DATA" Size 086, 010 Of oPanelBot COLORS 0, 16777215 Pixel 
            @ 015, 010 SAY "VALOR" Size 086, 010 Of oPanelBot COLORS 0, 16777215 Pixel 

            @ 003, 032 MsGet oGetF001  var dFil001 Picture '@!' Size 070,010 Of oPanelBot Pixel
            @ 015, 032 MsGet oGetF002  var nFil002 Picture '@E 999,999,999.99' Size 070,010 Of oPanelBot Pixel

            @ 015, 120 Button oBtnFil  Prompt 'Filtrar' Size 030,010 Action( goFazFiltro() ) Of oPanelBot Pixel
            @ 015, 152 Button oBtnClr  Prompt 'Limpar Filtro' Size 030,010 Action( goClrFiltro() ) Of oPanelBot Pixel

			oQuit := THButton():New(0, 0, "&CANCELAR", oPanelBot, {|| (lOkMan := .F.,oDlgMain:End()) }, , , )
			oQuit:nWidth  := 80
			oQuit:nHeight := 10
			oQuit:Align   := CONTROL_ALIGN_RIGHT
			oQuit:SetColor(RGB(002, 070, 112), )
			
			oBtOk := THButton():New(0, 0, "&GRAVAR", oPanelBot, {|| (lOkMan := .T.,oDlgMain:End()) }, , , )
			oBtOk:nWidth  := 80
			oBtOk:nHeight := 10
			oBtOk:Align   := CONTROL_ALIGN_RIGHT
			oBtOk:SetColor(RGB(002, 070, 112), )
	
	ACTIVATE MSDIALOG oDlgMain CENTERED on INIT oBrwXML:oBrowse:goTop(.T.)

    if lOkMan
        
        MsAguarde({|lEnd| goGrvMan()},"Aguarde...","Gravando as aletrações realizadas...",.T.)

    endif

Return

User Function FINV1020( nOpcao )

    if nOpcao == 1
        SED->(dbSetOrder(1))
        SED->(msSeek(xFilial("SED") + M->E5_NATUREZ))

        TRBD->(recLock("TRBD", .F.))
        TRBD->EDITADO := "*"
        TRBD->NOME := SED->ED_DESCRIC
        TRBD->(msUnlock())
    else
        TRBD->(recLock("TRBD", .F.))
        TRBD->EDITADO := "*"
        TRBD->(msUnlock())
    endif

Return( .T. )


Static Function goGrvMan()

    TRBD->( dbClearFilter() )   //Limpa qualquer filtro que exista
    TRBD->( dbSetFilter(&('{|| TRBD->EDITADO == "*"}'), 'TRBD->EDITADO == "*"') )
    TRBD->(dbGoTop())
    While !TRBD->(eof())

    	MsProcTxt("Efetivando as alteracoes...")

        if TRBD->EDITADO == '*'
            if mv_par03 == 1    //Se baixados
            
                SE5->(dbGoTo(TRBD->EXRECNO))
                SE5->(recLock("SE5", .F.))
                SE5->E5_NATUREZ := TRBD->E5_NATUREZ
                SE5->E5_HISTOR  := TRBD->HISTOR
                SE5->E5_BENEF   := TRBD->BENEF
                SE5->(msUnlock())
                
            else

                if TRBD->RECPAG == 'R'
                    SE1->(dbGoto(TRBD->EXRECNO))
                    SE1->(recLock("SE1", .F.))
                    SE1->E1_NATUREZ := TRBD->E5_NATUREZ
                    SE1->E1_HIST    := TRBD->HISTOR
                    SE1->(msUnlock())
                else
                    SE2->(dbGoto(TRBD->EXRECNO))
                    SE2->(recLock("SE2", .F.))
                    SE2->E2_NATUREZ := TRBD->E5_NATUREZ
                    SE2->E2_HIST    := TRBD->HISTOR
                    SE2->(msUnlock())
                endif

            endif 
        endif

        TRBD->(dbSkip())
    End

Return


//TRBD->( dbSetFilter(&('{|| TRBD->DATAB == "20210714"}'), 'TRBD->DATAB == "20210714"') )
//SN5->( dbClearFilter() )

Static Function goFazFiltro()
    TRBD->( dbClearFilter() )
    
    Do Case
        Case !empty(dFil001) .and. empty(nFil002)
            TRBD->( dbSetFilter(&('{|| dtos(TRBD->DATAB) == "'+dtos(dFil001)+'"}'), 'dtos(TRBD->DATAB) == "'+dtos(dFil001)+'"') )
        Case empty(dFil001) .and. !empty(nFil002)
            TRBD->( dbSetFilter(&('{|| TRBD->VALOR == '+str(nFil002)+'}'), 'TRBD->VALOR == '+str(nFil002)) )
        Case !empty(dFil001) .and. !empty(nFil002)
            TRBD->( dbSetFilter(&('{|| dtos(TRBD->DATAB) == "'+dtos(dFil001)+'" .and. TRBD->VALOR == '+str(nFil002)+'}'), 'dtos(TRBD->DATAB) == "'+dtos(dFil001)+'" .and. TRBD->VALOR == '+str(nFil002)) )
    EndCase

    oBrwXML:oBrowse:goTop(.T.)
Return

Static Function goClrFiltro()

dFil001 := ctod('')
nFil002 := 0

oGetF001:Refresh()
oGetF002:Refresh()

TRBD->( dbClearFilter() )
oBrwXML:oBrowse:goTop(.T.)

Return
