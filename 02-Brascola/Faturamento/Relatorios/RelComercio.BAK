#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
  
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ RELCOMERC ≥ Autor ≥ Thiago (Onsten)      ≥ Data ≥ 28/07/10 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Rel. Indicadores Gestores Regionais                        ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Especifico Brascola                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function SRELCOMERC() //para ser chamado via schedule para filial Matriz
*************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Rel. Indicadores Gestores Regionais"
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(2)  // 2=Usa Licensa - 3=Nao usar licensa

RPCSetEnv("02","01") // Seta job para empresa filial desejadas

U_ProcRCOML(.t.)

RpcClearEnv()

RestArea(aAreaAtu)

Return(Nil)



User Function RELCOMERC() //para ser chamado via menu
************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Rel. Indicadores Gestores Regionais"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cPerg     := U_CriaPerg("RINDGES")
Local aRegs     := {}

//          Grupo/Ordem/Pergunta/                  Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03              /Cnt03/Var04/Def04             /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme  /GrpSXG /Help /Picture /IDFIL 
aAdd(aRegs,{cPerg,"01" ,"Email para envio:" ,"","","mv_ch1","C" ,60     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""      ,""   })
aAdd(aRegs,{cPerg,"02" ,"Supervisor De:   " ,"","","mv_ch2","C" ,6      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SA3",""    ,""     ,""   ,""      ,""   })
aAdd(aRegs,{cPerg,"03" ,"Supervisor Ate:  " ,"","","mv_ch3","C" ,6      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"SA3",""    ,""     ,""   ,""      ,""   })
aAdd(aRegs,{cPerg,"04" ,"Data De:         " ,"","","mv_ch4","D" ,8      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"   ",""    ,""     ,""   ,""      ,""   })
aAdd(aRegs,{cPerg,"05" ,"Datar Ate:       " ,"","","mv_ch5","D" ,8      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,"   ",""    ,""     ,""   ,""      ,""   })
 
lValidPerg(aRegs)

If Pergunte(cPerg,.T.)
	Processa({ ||U_ProcRCOML(.f.)}, "Rel. Indicadores Gestores Regionais",,.t.)
EndIf

RestArea(aAreaAtu)

Return(Nil)
 

User Function ProcRCOML(lSchedAx)
**********************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

Private lSchedAux:= lSchedAx

ProcRegua(15) 

If !lSchedAux //VIA MENU
	cSupervDe  := mv_par02
	cSupervAte := mv_par03
	dDataDe    := mv_par04
	dDataAte   := mv_par05
Else
	cSupervDe  := Space(6)
	cSupervAte := "ZZZZZZ"
	dDataDe    := FirstDay(dDataBase)
	dDataAte   := dDataBase
EndIf	


//Gera query com agrupamento por supervisor+representante
cQuery:= "SELECT SUPERV," 
cQuery+= "REPRES," 
cQuery+= "SUM(TOTPREV) TTPREV,"           //PREVISTO
cQuery+= "SUM(TOTVALPED) TTVALPED,"       //VAL PED COLOCADOS
cQuery+= "SUM(TOTQTDPED) TTQTDPED,"       //QTD PED COLOCADOS
cQuery+= "SUM(TOTVALPF) TTVALPF,"       //VAL PED COLOCADOS fora mes
cQuery+= "SUM(TOTQTDPF) TTQTDPF,"       //QTD PED COLOCADOS fora mes
cQuery+= "SUM(TOTFAT) TTFAT,"             //REALIZADO
cQuery+= "SUM(TOTVBRU) TTVALBRU,"         //DESC MEDIO
cQuery+= "SUM(TOTVLIQ) TTVALLIQ,"         //DESC MEDIO
cQuery+= "SUM(TOTPEDABE) TTPEDABE,"       //CARTEIRA
cQuery+= "SUM(TOTPEDFUT) TTPEDFUT,"       //CARTEIRA FUTURA
cQuery+= "SUM(TOTAMOST) TTAMOST,"         //AMOSTRAS
cQuery+= "SUM(TOTBONIF) TTBONIF,"         //BONIFICACOES
cQuery+= "SUM(TOTDEVOL) TTDEVOL,"         //DEVOLUCOES
cQuery+= "SUM(TOTDESC) TTDESC,"           //VAL LIQ
cQuery+= "SUM(TOTCUST) TTCUST,"           //CUSTO
cQuery+= "SUM(TOTPEDIDO) TTPEDIDO,"       //MEDIA ITENS P/PEDIDO
cQuery+= "SUM(TOTITENS) TTITENS, "        //MEDIA ITENS P/PEDIDO
cQuery+= "SUM(TOTCLICAD) TTCLICAD FROM (" //TOTAL CLIENTES CADASTRADOS

//Previsao
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "SUM(SCT.CT_VALOR) TOTPREV,"  
cQuery+= "0 TOTVALPED,"
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT,"    
cQuery+= "0 TOTVBRU," 
cQuery+= "0 TOTVLIQ," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SCT")+" SCT "
cQuery+= "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SCT.CT_VEND AND SA3.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SCT.CT_DATA BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(LastDay(dDataAte))+"' 
cQuery+= " AND SCT.D_E_L_E_T_ = ' ' "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') " //V00002 - Gefferson Landarini
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= "UNION ALL " 

//Entrada de pedidos 
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
//cQuery+= "SUM(SC6.C6_QTDVEN*SC6.C6_PRCVEN) TOTVALPED,"  
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPED,"  
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT,"    
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "INNER JOIN SC6010 SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND (SC6.C6_BLQ<>'R ' OR SC6.C6_QTDENT > 0)  AND SC6.D_E_L_E_T_ = ' ' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SC6.C6_TES  AND F4_DUPLIC='S' AND F4_ESTOQUE='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
//cQuery+= "RIGHT JOIN SA1020 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
//cQuery+= "RIGHT JOIN SE4020 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
//cQuery+= "RIGHT JOIN ACY020 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' 
cQuery+= " AND SC5.C5_TIPO NOT IN ('D','B')"
//cQuery+= "  AND SC5.C5_CANCELA <> 'S' "
//cQuery+= "  AND SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' "
//cQuery+= "  AND SC5.C5_SERIE <> 'XXX' "
cQuery+= " AND SC5.D_E_L_E_T_ = '' "
//cQuery+= " AND SC5.C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+= " AND SC5.C5_PEDJOIN='' "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= "UNION ALL " 

//Entrada de pedidos Tranferencia
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPF,"
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPF," 
cQuery+= "0 TOTFAT,"    
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "INNER JOIN SC6010 SC6 ON SC6.C6_FILIAL = SC5.C5_FILIAL AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND (SC6.C6_BLQ<>'R ' OR SC6.C6_QTDENT > 0)  AND SC6.D_E_L_E_T_ = ' ' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SC6.C6_TES  AND F4_DUPLIC='S' AND F4_ESTOQUE='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '20120101' AND '20121231' 
cQuery+= " AND SC5.C5_TIPO NOT IN ('D','B')"
cQuery+= " AND SC5.D_E_L_E_T_ = '' "
cQuery+= " AND SC5.C5_PEDJOIN<>'' "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= "UNION ALL " 

// Faturados / Desconto Medio
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "SUM(SD2.D2_VALBRUT) TOTFAT," 
cQuery+= "SUM(SD2.D2_QUANT*SD2.D2_PRUNIT) TOTVBRU,"  
cQuery+= "SUM(SD2.D2_QUANT*SD2.D2_PRCVEN) TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "SUM(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6) TOTDESC," 
cQuery+= "SUM(SD2.D2_QUANT*SB1.B1_CUSTD) TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2010 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SB1010 SB1 ON SD2.D2_COD=B1_COD AND SB1.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= "  AND D2_TP='3'"
cQuery+= "  AND D2_TIPO NOT IN ('B','D')"
cQuery+= "  AND SD2.D_E_L_E_T_=''"
//cQuery+= "  AND SD2.D2_FILIAL='"+xFilial("SD2")+"' "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= "UNION ALL " 

//Carteira
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE,"
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_ = '' " 
cQuery+= " AND C5_FILIAL=C6_FILIAL " 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD " 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= " AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
//cQuery+= " AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(LastDay(dDataAte))+"' "
cQuery+= " AND SC6.C6_ENTREG BETWEEN '20090101' AND '"+DtoS(LastDay(dDataAte)+1)+"' 
cQuery+= " AND SC5.C5_TIPO='N' "
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= " AND SF4.F4_DUPLIC = 'S'  "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001')"
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
//cQuery+= " AND SC5.C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+= " AND SC5.C5_PEDJOIN='' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= " UNION ALL " 

//Carteira Futura
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDFUT,"
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_ = '' " 
cQuery+= " AND C5_FILIAL=C6_FILIAL " 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD " 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= " AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= " AND SC6.C6_ENTREG BETWEEN '"+DtoS(LastDay(dDataAte)+1)+"' AND '"+SubStr(DtoS(dDataAte),1,4)+"1231"+"' "
cQuery+= " AND SC5.C5_TIPO='N' "
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= " AND SF4.F4_DUPLIC = 'S'  "
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
//cQuery+= " AND SC5.C5_FILIAL='"+xFilial("SC5")+"' "
cQuery+= " AND SC5.C5_PEDJOIN='' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= " UNION ALL " 

// Amostras   
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "SUM(SD2.D2_VALBRUT) TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2010 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SC5010 SC5 ON D2_PEDIDO=C5_NUM AND SC5.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= "  AND D2_TP='3'"
cQuery+= "  AND D2_TIPO NOT IN ('B','D')"
cQuery+= "  AND SD2.D_E_L_E_T_=''"
//cQuery+= "  AND C5_AMOSTRA='1' "
cQuery+= "  AND SC5.C5_PEDJOIN='' "
cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " 	AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " 	AND SA3.A3_MSBLQL <> '1' "
cQuery+= "  AND SD2.D2_FILIAL='"+xFilial("SD2")+"' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= "UNION ALL " 

//BonificaÁıes
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "SUM(SD2.D2_VALBRUT) TOTBONIF," 
cQuery+= "0 TOTDEVOL,"  
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO,"  
cQuery+= "0 TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2,"+RetSQLName("SF2")+" SF2,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SD2.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= " AND SF2.F2_CLIENTE=SA1.A1_COD" 
cQuery+= " AND SF2.F2_LOJA=SA1.A1_LOJA" 
cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SUBSTRING(SF4.F4_CF,2,3) = '910'"   //TES de BonificaÁıes
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'"
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001')" 
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " AND SD2.D2_FILIAL='"+xFilial("SD2")+"' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= " UNION ALL " 

//DevoluÁıes
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "SUM((D1_TOTAL+(CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END)+D1_VALIPI+D1_VALFRE-D1_VALDESC+D1_DESPESA)) TOTDEVOL," 
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTITENS, "            
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SF1")+" SF1,"+RetSQLName("SD1")+" SD1,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SF1.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SD1.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= " AND F1_DTDIGIT BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " AND F1_TIPO='D'" 
cQuery+= " AND D1_FILIAL=F1_FILIAL" 
cQuery+= " AND D1_DOC=F1_DOC" 
cQuery+= " AND D1_SERIE=F1_SERIE" 
cQuery+= " AND D1_FORNECE=F1_FORNECE" 
cQuery+= " AND D1_TES=F4_CODIGO" 
cQuery+= " AND F4_DUPLIC='S'" 
cQuery+= " AND A1_COD=F1_FORNECE" 
cQuery+= " AND A1_LOJA=F1_LOJA" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
//cQuery+= " AND SF1.F1_FILIAL='"+xFilial("SF1")+"' "
//cQuery+= " AND SD1.D1_FILIAL='"+xFilial("SD1")+"' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= " UNION ALL " 
     
//Num pedidos/itens 
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDIDO," 
cQuery+= "COUNT(SC6.C6_NUM) TOTITENS, " 
cQuery+= "0 TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND C5_FILIAL=C6_FILIAL "
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA"         
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD" 
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'" 
//cQuery+= " AND SC5.C5_FILIAL='"+xFilial("SC5")+"' " 
cQuery+= " AND SC5.C5_PEDJOIN='' "
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') "
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 
cQuery+= " UNION ALL " 

//Clientes Cadastrados
cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "   
cQuery+= "SA3.A3_COD AS REPRES, "   
cQuery+= "0 TOTPREV,"  
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTVALPF,"
cQuery+= "0 TOTQTDPF," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTVBRU,"  
cQuery+= "0 TOTVLIQ,"  
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTPEDFUT," 
cQuery+= "0 TOTAMOST,"  
cQuery+= "0 TOTBONIF,"  
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTDESC," 
cQuery+= "0 TOTCUST," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTITENS, " 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICAD " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
//cQuery+= " AND A1_X_DINC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= " AND SA3.A3_SUPER BETWEEN '"+cSupervDe+"' AND '"+cSupervAte+"'"
cQuery+= " AND SA3.A3_SUPER NOT IN ('V00001') " 
//cQuery+= " AND SA3.A3_MSBLQL <> '1' "
cQuery+= " AND SA3.A3_FILIAL='"+xFilial("SA3")+"' "
cQuery+= " GROUP BY SA3.A3_SUPER,SA3.A3_COD " 

cQuery+= ") AGRUPA" 
cQuery+= " GROUP BY SUPERV, REPRES"
cQuery+= " ORDER BY SUPERV, REPRES"

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

If !Eof()
	EnvMailComl() 
EndIf	

dbSelectArea("TRAB")
dbCloseArea()

Return(.T.)


 
Static Function EnvMailComl() 
*****************************
Local _cBody     := ""
Local cAssunto   := ""
Local cAnexo     := ""
Local cEmail     := ""
Local cMesAux    := {"Janeiro","Fevereiro","MarÁo","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
Local _TotPREV   := 0
Local _TotFAT    := 0
Local _TotPEDABE := 0
Local _TotPEDFUT := 0
Local _TotVALPED := 0
Local _TotQTDPED := 0
Local _TotVALPF  := 0
Local _TotCLICAD := 0
Local _TotAMOST  := 0
Local _TotBONIF  := 0
Local _TotDEVOL  := 0
Local _TotDESPE  := 0
Local _TotVALLIQ := 0
Local _TotVALBRU := 0
Local _TotDESC   := 0
Local _TotCUST   := 0
Local _TotITENS  := 0
Local _TotPEDIDO := 0

DbSelectArea("TRAB")
DbGoTop()

While !Eof()
	_TotPREV   := _TotFAT    := _TotPEDABE := _TotVALPED := _TotVALPF  := _TotQTDPED := _TotCLICAD := _TotAMOST  := _TotBONIF  :=  0
	_TotDEVOL  := _TotDESPE  := _TotVALLIQ := _TotVALBRU := _TotDESC   := _TotCUST   := _TotITENS  := _TotPEDIDO := _TotPEDFUT :=  0

	cSupervAux := TRAB->SUPERV
	cNomSupAux := AllTrim(Posicione("SA3",1,xFilial("SA3")+TRAB->SUPERV,"A3_NOME"))

	IncProc("Processando supervisor "+cSupervAux+"...")
    //Html
	_cBody := "<html>"
	_cBody += "<head>"
	_cBody += '<meta http-equiv="Content-Language" content="pt-br">'
	_cBody += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
	_cBody += "<title>Nova pagina 1</title>"
	_cBody += "</head>"
	_cBody += "<body>"
	_cBody += '<p align="center"><font face="Tahoma" size="3"><b>INDICADORES GESTORES REGIONAIS - '+cMesAux[Month(dDataDe)]+'/'+Alltrim(Str(Year(dDataDe)))+'</b></font></p>'
	_cBody += '<p align="center"><font face="Tahoma" size="3">ReferÍncia: '+DtoC(dDataAte)+'</font></p> '
	_cBody += '<p>&nbsp;</p>'
	_cBody += '<p align="left"><font face="Tahoma" size="2">Supervisor: '+cSupervAux+' - <b>'+cNomSupAux+'</b></font></p> '

	_cBody += '<table border="1" width="100%">  '
	_cBody += '<tr> '
	_cBody += ' <td rowspan="2" bgcolor="#3366FF"><p align="left">  <font face="Tahoma" size="1" color="#FFFFFF"><b>Representante</b></font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Previsto</b></font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Realizado</b></font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Carteira MÍs</b></font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Carteira Futura</b></font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Ped.Colocados</b> (Valor)</font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Ped.Colocados</b> (Qtde)</font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Ped.Implantados</b> (Valor)</font></td> '
	_cBody += '	<td rowspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Clientes Novos</b></font></td> '
	_cBody += '	<td colspan="4" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Custos</b></font></td> '
	_cBody += '	<td colspan="2" bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Rentabilidade</b></font></td> '
	_cBody += '	<td bgcolor="#3366FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Mix</b></font></td> '
	_cBody += '</tr> '
	_cBody += '<tr> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Amostras</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>BonificaÁıes</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>DevoluÁıes</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Despesas CC</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Desc.Medio</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>MB</b></font></td> '
	_cBody += '	<td bgcolor="#6699FF"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Media Itens</b></font></td> '
	_cBody += '</tr> '
	 
	While !Eof() .And. cSupervAux==TRAB->SUPERV
		cReprAux := TRAB->REPRES+' - '+AllTrim(Posicione("SA3",1,xFilial("SA3")+TRAB->REPRES,"A3_NOME"))
		nDescAux := 100-((TRAB->TTVALLIQ/TRAB->TTVALBRU)*100)
		
		nVLAux   := TRAB->TTDESC
		nVFAux   := (TRAB->TTDESC * 7.4)/100
		nVCAux   := TRAB->TTCUST
		nVRAux   := nVLAux - nVFAux - nVCAux
		nMBAux   := (nVRAux/nVLAux) * 100

		nMedItAux:= TRAB->TTITENS/TRAB->TTPEDIDO
	
		_cBody += '<tr>'
		_cBody += '	<td align="left" ><font face="Tahoma" size="1">'+cReprAux+'</font></td>'                                                      //REPRESENTATE
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPREV           ,"@E 999,999,999"))+'</font></td>'  //PREVISTO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFAT            ,"@E 999,999,999"))+'</font></td>'  //REALIZADO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDABE         ,"@E 999,999,999"))+'</font></td>'  //EM ABERTO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDFUT         ,"@E 999,999,999"))+'</font></td>'  //EM ABERTO FUTURA
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTVALPED         ,"@E 999,999,999"))+'</font></td>'  //PED COLOCADOS VALOR
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDIDO         ,"@E 999,999,999"))+'</font></td>'  //QTDE DE PED COLOCADOS
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTVALPF          ,"@E 999,999,999"))+'</font></td>'  //PED COLOCADOS IMPLANTADOS VALOR
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLICAD         ,"@E 999,999,999"))+'</font></td>'  //QTDE DE CLIENTES NOVOS COLOCADOS
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTAMOST          ,"@E 999,999,999"))+'</font></td>'  //AMOSTRAS
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTBONIF          ,"@E 999,999,999"))+'</font></td>'  //BONIFIC
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTDEVOL          ,"@E 999,999,999"))+'</font></td>'  //DEVOLUCOES
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(0  /*TRAB->TTDESPE*/   ,"@E 999,999,999"))+'</font></td>'  //DESPESAS CC (?)
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(Iif(nDescAux==100,0,nDescAux),"@R 9999%"))+'</font></td>'  //DESC MEDIO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Iif(lSchedAux,"-    ",Alltrim(Transform(nMBAux,"@R 9999%")))+'</font></td>'  //MB
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMedItAux                   ,"@E 999.99"))+'</font></td> ' //MEDIA ITENS
		_cBody += '</tr> '
	
		_TotPREV   += TRAB->TTPREV
		_TotFAT    += TRAB->TTFAT
		_TotPEDABE += TRAB->TTPEDABE
		_TotPEDFUT += TRAB->TTPEDFUT
		_TotVALPED += TRAB->TTVALPED
		_TotQTDPED += TRAB->TTPEDIDO
		_TotVALPF  += TRAB->TTVALPF
		_TotCLICAD += TRAB->TTCLICAD
		_TotAMOST  += TRAB->TTAMOST
		_TotBONIF  += TRAB->TTBONIF
		_TotDEVOL  += TRAB->TTDEVOL
		_TotDESPE  += 0//TRAB->TTDESPE
		_TotVALLIQ += TRAB->TTVALLIQ
		_TotVALBRU += TRAB->TTVALBRU
		_TotDESC   += TRAB->TTDESC
		_TotCUST   += TRAB->TTCUST
		_TotITENS  += TRAB->TTITENS
		_TotPEDIDO += TRAB->TTPEDIDO

		DbSelectArea("TRAB")
		DbSkip()
	EndDo

	dDtDespDe := FirstDay(dDataDe-1)
	dDtDespAte:= LastDay(dDtDespDe)
	
	//Gera query para valor das despesas do supervisor
	cQueryC:= ""
	cQueryC+= "SELECT SUM(VALOR) VALOR, "
	cQueryC+= "       SUPER "
	cQueryC+= "FROM ( "
	cQueryC+= "	SELECT SUM(CT2_VALOR) VALOR,  "
	cQueryC+= "        SUBSTRING(X5_DESCRI,1,6) SUPER  "
	cQueryC+= "	FROM  CT2010 CT2 "
	cQueryC+= "	INNER JOIN  SX5010 X5 ON CT2_CCD = X5.X5_CHAVE  " 
	cQueryC+= "                      AND X5.X5_FILIAL = '04'  "
	cQueryC+= "                      AND SUBSTRING(X5.X5_DESCRI,1,6) = '"+AllTrim(cSupervAux)+"'  "
	cQueryC+= "			             AND X5. X5_TABELA = 'ZU' "
	cQueryC+= "                      AND X5.D_E_L_E_T_ = ''  "
	cQueryC+= "	WHERE CT2_TPSALD IN('1') "
	cQueryC+= "	  AND CT2_DATA BETWEEN  '"+DtoS(dDtDespDe)+"' AND '"+DtoS(dDtDespAte)+"'" 
	cQueryC+= "	  AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQueryC+= "	  AND CT2.D_E_L_E_T_ = '' "
	cQueryC+= "	  AND SUBSTRING(CT2_DEBITO,1,1) IN ('5','6') "
	cQueryC+= "	GROUP BY SUBSTRING(X5_DESCRI,1,6) "
	cQueryC+= "	UNION ALL "
	cQueryC+= "	SELECT SUM(CT2_VALOR)*(-1) VALOR, "
	cQueryC+= "        SUBSTRING(X5_DESCRI,1,6) SUPER  "
	cQueryC+= "	FROM  CT2010 CT2 "
	cQueryC+= "	INNER JOIN  SX5010 X5 ON CT2_CCC = X5.X5_CHAVE  " 
	cQueryC+= "                      AND X5.X5_FILIAL = '04'  "
	cQueryC+= "                      AND SUBSTRING(X5.X5_DESCRI,1,6) = '"+AllTrim(cSupervAux)+"'  "
	cQueryC+= "		                 AND X5. X5_TABELA = 'ZU' "
	cQueryC+= "                      AND X5.D_E_L_E_T_ = ''  "
	cQueryC+= "	WHERE CT2_TPSALD IN('1') "
	cQueryC+= "	  AND CT2_DATA BETWEEN '"+DtoS(dDtDespDe)+"' AND '"+DtoS(dDtDespAte)+"'" 
	cQueryC+= "	  AND CT2_LOTE NOT IN ('777777','888888','5000','6000') "
	cQueryC+= "	  AND CT2.D_E_L_E_T_ = '' "
	cQueryC+= "	  AND SUBSTRING(CT2_CREDIT,1,1) IN ('5','6') "
	cQueryC+= "	GROUP BY SUBSTRING(X5_DESCRI,1,6) "
	cQueryC+= ")AGRUPA1 "
	cQueryC+= "GROUP BY SUPER "          
	cQueryC+= "ORDER BY SUPER "
	
	If Select("TRABC") > 0 
		TRABC->(dbCloseArea())
	EndIf      
	TCQUERY cQueryC NEW ALIAS "TRABC"
	
	DbSelectArea("TRABC")
	DbGoTop()
		
	_TotDESPE:= TRABC->VALOR
	
	dbCloseArea()

	DbSelectArea("TRAB")
	
	nTVLAux:= _TotDESC
	nTVFAux:= (_TotDESC * 7.4)/100
	nTVCAux:= _TotCUST
	nTVRAux:= nTVLAux - nTVFAux - nTVCAux
	nTMBAux:= (nTVRAux/nTVLAux) * 100
	
	_cBody += '<tr>'
	_cBody += '	<td bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">TOTAL SUPERVISOR '+cSupervAux+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotPREV   ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotFAT    ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotPEDABE ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotPEDFUT ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotVALPED ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotQTDPED ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotVALPF  ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotCLICAD ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotAMOST  ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotBONIF  ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotDEVOL  ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotDESPE  ,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(100-((_TotVALLIQ/_TotVALBRU)*100),"@R 999%"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTMBAux                          ,"@R 999%"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TotITENS/_TotPEDIDO           ,"@E 999.99"))+'</font></b></td> '
	_cBody += '</tr> '
	_cBody += '</table>'
	_cBody += '<p>&nbsp;</p>'

	//Gera query por familia
	cQueryF:= ""
	cQueryF:= "SELECT SUPERV,"                      //SUPERVISOR
	cQueryF+= "FAMILIA,"                            //FAMILIA
	cQueryF+= "SUM(TOTPREV) TTPREV,"                //PREVISTO
	cQueryF+= "SUM(TOTFAT) TTFAT,"                  //REALIZADO
	cQueryF+= "SUM(TOTPEDABE) TTPEDABE,  "          //CARTEIRA
	cQueryF+= "SUM(TOTPEDFUT) TTPEDFUT,  "          //CARTEIRA FUTURA
	cQueryF+= "SUM(TOTDESC) TTDESC, " 
	cQueryF+= "SUM(TOTCUST) TTCUST FROM (" 
	
	//Previsao
	cQueryF+= "SELECT SZY.ZY_SUPER AS SUPERV, "   
	cQueryF+= "SZY.ZY_FAMILIA AS FAMILIA, "   
	cQueryF+= "SUM(SZY.ZY_VALPREV) TOTPREV, "  
	cQueryF+= "0 TOTFAT, "    
	cQueryF+= "0 TOTPEDABE, " 
	cQueryF+= "0 TOTPEDFUT, "
	cQueryF+= "0 TOTDESC, "
	cQueryF+= "0 TOTCUST "
	cQueryF+= "FROM "+RetSQLName("SZY")+" SZY "
	cQueryF+= "WHERE SZY.ZY_DATA BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(LastDay(dDataAte))+"' "
	cQueryF+= "  AND SZY.D_E_L_E_T_ = ' ' "
	cQueryF+= "  AND SZY.ZY_SUPER = '"+AllTrim(cSupervAux)+"' "
	cQueryF+= " GROUP BY SZY.ZY_SUPER,SZY.ZY_FAMILIA " 
	
	cQueryF+= "UNION ALL " 
	
	// Realizado 
	cQueryF+= "SELECT SA3.A3_SUPER AS SUPERV, "   
	cQueryF+= "SB1.B1_XFAMCOM AS FAMILIA, "   
	cQueryF+= "0 TOTPREV,"  
	cQueryF+= "SUM(SD2.D2_VALBRUT) TOTFAT," 
	cQueryF+= "0 TOTPEDABE, " 
	cQueryF+= "0 TOTPEDFUT, "
	cQueryF+= "SUM(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6) TOTDESC," 
	cQueryF+= "SUM(SD2.D2_QUANT*SB1.B1_CUSTD) TOTCUST " 
	cQueryF+= "FROM "+RetSQLName("SD2")+" SD2 "
	cQueryF+= "INNER JOIN SF2010 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
	cQueryF+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
	cQueryF+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
	cQueryF+= "LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
	cQueryF+= "LEFT JOIN SB1010 SB1 ON SD2.D2_COD=B1_COD AND SB1.D_E_L_E_T_='' "
	cQueryF+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
	cQueryF+= "  AND D2_TP='3'"
	cQueryF+= "  AND D2_TIPO NOT IN ('B','D')"
	cQueryF+= "  AND SD2.D_E_L_E_T_=''"
	cQueryF+= "  AND SA3.A3_SUPER = '"+AllTrim(cSupervAux)+"' "
	cQueryF+= " GROUP BY SA3.A3_SUPER,SB1.B1_XFAMCOM " 
	
	cQueryF+= "UNION ALL " 
	
	//Carteira
	cQueryF+= "SELECT SA3.A3_SUPER AS SUPERV, "   
	cQueryF+= "SB1.B1_XFAMCOM AS FAMILIA, "   
	cQueryF+= "0 TOTPREV, "  
	cQueryF+= "0 TOTFAT, " 
	cQueryF+= "SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE, "
	cQueryF+= "0 TOTPEDFUT, "
	cQueryF+= "0 TOTDESC, "
	cQueryF+= "0 TOTCUST "
	cQueryF+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 ,"+RetSQLName("SB1")+" SB1 " 
	cQueryF+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = ''" 
	cQueryF+= "  AND C5_FILIAL=C6_FILIAL " 
	cQueryF+= "  AND C5_NUM=C6_NUM" 
	cQueryF+= "  AND C5_CLIENTE=A1_COD " 
	cQueryF+= "  AND C5_LOJACLI=A1_LOJA" 
	cQueryF+= "  AND SC5.C5_VEND1=SA3.A3_COD"     
	cQueryF+= "  AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
	cQueryF+= "  AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(LastDay(dDataAte))+"' "
	cQueryF+= "  AND SC5.C5_TIPO='N' "
	cQueryF+= "  AND C6_BLQ<>'R'" 
	cQueryF+= "  AND SC6.C6_TES = SF4.F4_CODIGO "
	cQueryF+= "  AND SF4.F4_DUPLIC = 'S'  "
	cQueryF+= "  AND SC6.C6_PRODUTO = B1_COD "
	cQueryF+= "  AND SA3.A3_SUPER = '"+AllTrim(cSupervAux)+"' "
	cQueryF+= " GROUP BY SA3.A3_SUPER,SB1.B1_XFAMCOM " 
	
	cQueryF+= "UNION ALL " 
	
	//Carteira Futura
	cQueryF+= "SELECT SA3.A3_SUPER AS SUPERV, "   
	cQueryF+= "SB1.B1_XFAMCOM AS FAMILIA, "   
	cQueryF+= "0 TOTPREV, "  
	cQueryF+= "0 TOTFAT, " 
	cQueryF+= "0 TOTPEDABE, "
	cQueryF+= "SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDFUT, "
	cQueryF+= "0 TOTDESC, "
	cQueryF+= "0 TOTCUST "
	cQueryF+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 ,"+RetSQLName("SB1")+" SB1 " 
	cQueryF+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = ''" 
	cQueryF+= "  AND C5_FILIAL=C6_FILIAL " 
	cQueryF+= "  AND C5_NUM=C6_NUM" 
	cQueryF+= "  AND C5_CLIENTE=A1_COD " 
	cQueryF+= "  AND C5_LOJACLI=A1_LOJA" 
	cQueryF+= "  AND SC5.C5_VEND1=SA3.A3_COD"     
	cQueryF+= "  AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
    cQueryF+= " AND SC6.C6_ENTREG BETWEEN '"+DtoS(LastDay(dDataAte)+1)+"' AND '"+SubStr(DtoS(dDataAte),1,4)+"1231"+"' "
	cQueryF+= "  AND SC5.C5_TIPO='N' "
	cQueryF+= "  AND C6_BLQ<>'R'" 
	cQueryF+= "  AND SC6.C6_TES = SF4.F4_CODIGO "
	cQueryF+= "  AND SF4.F4_DUPLIC = 'S'  "
	cQueryF+= "  AND SC6.C6_PRODUTO = B1_COD "
	cQueryF+= "  AND SA3.A3_SUPER = '"+AllTrim(cSupervAux)+"' "
	cQueryF+= " GROUP BY SA3.A3_SUPER,SB1.B1_XFAMCOM " 
	
	cQueryF+=") AGRUPA " 
	cQueryF+= " GROUP BY SUPERV, FAMILIA"
	cQueryF+= " ORDER BY SUPERV, FAMILIA"
	
	If Select("TRABF") > 0 
		TRABF->(dbCloseArea())
	EndIf      
	TCQUERY cQueryF NEW ALIAS "TRABF"
	
	//Objetivos FamÌlias Produtos
	_cBody += '<p align="left"><font face="Tahoma" size="2"><b>Objetivos FamÌlias Produtos</b></font></p> '
	_cBody += '<table border="1" width="70%">  '
	_cBody += '<tr> '         
	_cBody += '	<td bgcolor="#00CC66"><p align="left"  ><font face="Tahoma" size="1" color="#FFFFFF"><b>FamÌlia</b></font></td> '
	_cBody += '	<td bgcolor="#00CC66"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Previsto</b></font></td> '
	_cBody += '	<td bgcolor="#00CC66"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Realizado</b></font></td> '
	_cBody += '	<td bgcolor="#00CC66"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Carteira MÍs</b></font></td> '
	_cBody += '	<td bgcolor="#00CC66"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>Carteira Futura</b></font></td> '
	If !lSchedAux
		_cBody += '	<td bgcolor="#00CC66"><p align="center"><font face="Tahoma" size="1" color="#FFFFFF"><b>MB</b></font></td> '
	EndIf
	_cBody += '</tr> '
	
	nTotPrevAx:= nTotRealAx:= 0
	nTotAberAx:= nTotFutuAx:= 0
	nTotDESCAx:= nTotCUSTAx:= 0
	
	DbSelectArea("TRABF")
	DbGoTop()
	
	While !Eof() 
		cFamAux := TRABF->FAMILIA+' - '+AllTrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRABF->FAMILIA,"X5_DESCRI"))
	
		nVLAux   := TRABF->TTDESC
		nVFAux   := (TRABF->TTDESC * 7.4)/100
		nVCAux   := TRABF->TTCUST
		nVRAux   := nVLAux - nVFAux - nVCAux
		nMBAux   := (nVRAux/nVLAux) * 100
	
		_cBody += '<tr> '                                                                                 
		_cBody += '	<td align="left" ><font face="Tahoma" size="1">'+cFamAux+'</font></td>'                                              //FAMILIA
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRABF->TTPREV  ,"@E 999,999,999"))+'</font></td>' //PREVISTO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRABF->TTFAT   ,"@E 999,999,999"))+'</font></td>' //REALIZADO
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRABF->TTPEDABE,"@E 999,999,999"))+'</font></td>' //CARTEIRA
		_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRABF->TTPEDFUT,"@E 999,999,999"))+'</font></td>' //CARTEIRA FUTURA
		If !lSchedAux
			_cBody += '	<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMBAux,"@R 9999%"))+'</font></td> ' //MB
		EndIf	
		_cBody += '</tr> '
	
		nTotPrevAx+= TRABF->TTPREV
		nTotRealAx+= TRABF->TTFAT
		nTotAberAx+= TRABF->TTPEDABE
		nTotFutuAx+= TRABF->TTPEDFUT
		nTotDESCAx+= TRABF->TTDESC
		nTotCUSTAx+= TRABF->TTCUST
	
		DbSelectArea("TRABF")
		DbSkip()
	EndDo
	
	DbSelectArea("TRABF")
	DbCloseArea()
	
	nTVLAux:= nTotDESCAx
	nTVFAux:= (nTotDESCAx * 7.4)/100
	nTVCAux:= nTotCUSTAx
	nTVRAux:= nTVLAux - nTVFAux - nTVCAux
	nTMBAux:= (nTVRAux/nTVLAux) * 100
	
	_cBody += '<tr> '
	_cBody += '	<td bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">T O T A L</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTotPrevAx,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTotRealAx,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTotAberAx,"@E 999,999,999"))+'</font></b></td>'
	_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTotFutuAx,"@E 999,999,999"))+'</font></b></td>'
	If !lSchedAux
		_cBody += '	<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(nTMBAux          ,"@R 999%"))+'</font></b></td>'
	EndIf	
	_cBody += '</tr> '
	_cBody += '</table>'
	_cBody += '<p>&nbsp;</p>'
	_cBody += '<p><font face="Tahoma" size="1">Gerado pelo sistema Microsiga Protheus - Atualizado em '+DtoC(dDataBase)+' - '+SubStr(Time(),1,5)+'</font></p>'
	_cBody += '</body>'
	_cBody += '</html>'
	 
	cAssunto:= "Indicadores Gestores Regionais - "+DtoC(dDataBase)+" - "+cNomSupAux 
	
	If !lSchedAux
		cEmail:= Iif(!Empty(mv_par01),AllTrim(mv_par01),cEmail)
    Else
	   	cEmail:= AllTrim(Posicione("SA3",1,xFilial("SA3")+AllTrim(cSupervAux),"A3_EMAIL"))
		If SA3->A3_MSBLQL<>"2"
			cEmail:= ""
			cAssunto+= " (bloqueado)"
		EndIf	
		
		 //cEmail+= Iif(!Empty(cEmail),"; ","")+"peterson.faria@brascola.com.br;alfredo.mann@brascola.com.br" 
		 cEmail+= Iif(!Empty(cEmail),"; ","")//+"fmaia@brascola.com.br"
	EndIf	
	
	If !Empty(cEmail)
		//Envio do email
		U_SendMail(cEmail,cAssunto,_cBody,"",.f.)
	EndIf	

	DbSelectArea("TRAB")
EndDo


Return