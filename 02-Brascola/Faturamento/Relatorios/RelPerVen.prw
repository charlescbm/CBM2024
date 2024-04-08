#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
  
/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ RELPERVEN ≥ Autor ≥ Thiago (Onsten)      ≥ Data ≥ 28/04/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Envia email p/ Adm.Vendas da Performance de Vendas         ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Especifico Brascola                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function RELPERVEN()  //para chamar via schedule
*************************

Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Performance de Vendas"
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(3)  // Nao usar Licensa
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "U_RELPERVEN()"  TABLES "SC5","SC6","SF2","SD2","SA3","SA1"

Processa({ ||U_ProcPerVen(.t.)}, "Performance de Vendas",,.t.)

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)



User Function RPERVEN()	// para chamar via menu
***********************
Local cPerg := "RPERVE   " //U_CriaPerg("RPERVE")
Local aRegs := {}

//          Grupo/Ordem/Pergunta/                  Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03              /Cnt03/Var04/Def04             /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture /IDFil
aAdd(aRegs,{cPerg,"01" ,"Email para envio:" ,"","","mv_ch1","C" ,40     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""     ,""})

lValidPerg(aRegs)

If Pergunte(cPerg,.T.)
	Processa({ ||U_ProcPerVen(.f.)}, "Performance de Vendas",,.t.)
EndIf

Return
 

 
User Function ProcPerVen(lSchedAx)
*********************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

Private lSchedAux:= lSchedAx

ProcRegua(4) 
IncProc("Processando Segmentos... ", "Aguarde...") 

dDataDe  := FirstDay(dDataBase)
dDataAte := dDataBase
dDataDe4M:= dDataDe-120

// *************************************
//        GERA QUERY POR SEGMENTOS 
// *************************************

cQuery:= "SELECT SEGMTO," 
cQuery+= "SUM(TOTVALPED) TTVALPED," 
cQuery+= "SUM(TOTVALBRU) TTVALBRU," 
cQuery+= "SUM(TOTVALLIQ) TTVALLIQ,"  
cQuery+= "SUM(TOTQTDPED) TTQTDPED," 
cQuery+= "SUM(TOTFAT) TTFAT," 
cQuery+= "SUM(TOTPEDABE) TTPEDABE," 
cQuery+= "SUM(TOTBONIF) TTBONIF," 
cQuery+= "SUM(TOTDEVOL) TTDEVOL," 
cQuery+= "SUM(TOTICMS) TTICMS," 
cQuery+= "SUM(TOTCPV) TTCPV," 
cQuery+= "SUM(TOTCPV2) TTCPV2," 
cQuery+= "SUM(TOTCLICAD) TTCLICAD," 
cQuery+= "SUM(TOTCLIFAT) TTCLIFAT," 
cQuery+= "SUM(TOTCLICR) TTCLICR," 
cQuery+= "SUM(TOTCLIATI) TTCLIATI," 
cQuery+= "SUM(TOTPEDIDO) TTPEDIDO," 
cQuery+= "SUM(TOTPEDFAT) TTPEDFAT," 
cQuery+= "SUM(TOTITENS) TTITENS FROM ("  

//Entrada de pedidos                                         
//PRIVATE LABEL
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000005') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "RIGHT JOIN SA3010 SA3 ON A3_COD=C5_VEND1 AND SA3.D_E_L_E_T_=' ' "
cQuery+= "RIGHT JOIN SA1010 SA1 ON A1_COD=C5_CLIENTE AND A1_LOJA=C5_LOJACLI AND SA1.D_E_L_E_T_=' ' "
cQuery+= "RIGHT JOIN ACY010 ACY ON ACY_GRPVEN=A1_GRPVEN AND ACY.D_E_L_E_T_=' ',SC6010 SC6,SF4010 SF4 "
cQuery+= "WHERE C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " AND C5_TIPO NOT IN ('D','B')"
cQuery+= " AND C6_FILIAL=C5_FILIAL"
cQuery+= " AND C6_NUM=C5_NUM"
cQuery+= " AND C6_CLI=C5_CLIENTE" 
cQuery+= " AND C6_LOJA=C5_LOJACLI" 
cQuery+= " AND (C6_BLQ<>'R' OR C6_QTDENT>0)"
cQuery+= " AND F4_CODIGO=C6_TES"
cQuery+= " AND F4_ESTOQUE='S'"
cQuery+= " AND F4_DUPLIC='S'"
cQuery+= " AND SF4.D_E_L_E_T_=' '" 
cQuery+= " AND SC6.D_E_L_E_T_=' '"
cQuery+= " AND SC5.D_E_L_E_T_=' '"
cQuery+= " AND SA3.A3_MSBLQL<>'1' "
cQuery+= "GROUP BY A1_GRPVEN " 

cQuery+= "UNION ALL " 

// Faturados / Desconto Medio
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "SUM(D2_QUANT*D2_PRUNIT) TOTVALBRU,"  
cQuery+= "SUM(D2_QUANT*D2_PRCVEN) TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "SUM(D2_VALBRUT) TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "SUM(D2_ICMSRET) TOTICMS," 
cQuery+= "SUM(D2_CUSTO1) TOTCPV," 
cQuery+= "SUM(D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6+D2_VALFRE) TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
//cQuery+= "FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4, "+RetSQLName("SB1")+" SB1 " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2010 SF2 ON D2_DOC=F2_DOC AND D2_SERIE=F2_SERIE AND D2_FILIAL=F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3010 SA3 ON F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND D2_TP='3'"
cQuery+= " AND D2_TIPO NOT IN ('B','D')"
cQuery+= " AND SD2.D_E_L_E_T_=''"
cQuery+= " AND A3_MSBLQL<>'1'"

/*
cQuery+= "LEFT JOIN SA3020 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_=''"
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''" //AND SA3.D_E_L_E_T_='' 
cQuery+= " AND F2_CLIENTE=A1_COD" 
cQuery+= " AND F2_LOJA=A1_LOJA" 
//cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF4.F4_DUPLIC='S'" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SF2.F2_TIPO NOT IN ('D','B')"
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SD2.D2_TP='PA'"
cQuery+= " AND SB1.B1_COD=SD2.D2_COD"
*/
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Pedidos em Aberto
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) TOTPEDABE,"
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
cQuery+= " AND C5_FILIAL=C6_FILIAL" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND C5_VEND1=SA3.A3_COD"     
cQuery+= " AND C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= " AND C6_ENTREG BETWEEN '"+DtoS(dDataDe+1)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"'"
cQuery+= " AND C5_TIPO='N'"
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND C6_TES=F4_CODIGO"
cQuery+= " AND F4_DUPLIC='S'"
cQuery+= " AND A3_MSBLQL<>'1'"

cQuery+= " GROUP BY A1_GRPVEN" 

cQuery+= " UNION ALL " 

//BonificaÁıes

cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "SUM(D2_TOTAL) TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2,"+RetSQLName("SF2")+" SF2,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SD2.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= " AND F2_CLIENTE=SA1.A1_COD" 
cQuery+= " AND F2_LOJA=SA1.A1_LOJA" 
cQuery+= " AND F2_VEND1=SA3.A3_COD" 
cQuery+= " AND F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND D2_DOC=SF2.F2_DOC"
cQuery+= " AND D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SUBSTRING(F4_CF,2,3)='910'"   //TES de BonificaÁıes
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN" 

//DevoluÁıes
cQuery+= " UNION ALL " 
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED, "  
cQuery+= "0 TOTVALBRU, "  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED, " 
cQuery+= "0 TOTFAT, " 
cQuery+= "0 TOTPEDABE, " 
cQuery+= "0 TOTBONIF, " 
cQuery+= "SUM((D1_TOTAL+(CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END)+D1_VALIPI+D1_VALFRE-D1_VALDESC+D1_DESPESA)) TOTDEVOL," 
//_cQuery += "    	SUM((D1_TOTAL + (CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END) + D1_VALIPI + D1_VALFRE - D1_VALDESC + D1_DESPESA) * (-1)) TOTAL "
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
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
//cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN" 



cQuery+= " UNION ALL " 

//Clientes Cadastrados


cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "COUNT(DISTINCT(A1_COD+A1_LOJA)) TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
cQuery+= "FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados com Faturamento
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "COUNT(DISTINCT(A1_COD+A1_LOJA)) TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' "                 
cQuery+= " AND A1_VEND = A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 



cQuery+= "UNION ALL " 

//Carteira Clientes Cadastrados = TOTAL
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "COUNT(DISTINCT(A1_COD+A1_LOJA)) TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_GRPVEN<>'000000'"
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Carteira Clientes 4 meses Cadastrados = ATIVOS
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "COUNT(DISTINCT(A1_COD+A1_LOJA)) TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe4M)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_GRPVEN<>'000000'"
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 

cQuery+= "UNION ALL "  

//Num pedidos (Entrada)
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "COUNT(DISTINCT(C5_NUM)) TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "COUNT(C6_NUM) TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA"         
cQuery+= " AND SC5.C5_VEND1=A3_COD" 
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 


/*
cQuery+= "UNION ALL " 


//Num pedidos (via Palm)
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000023','000014','000056') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND C5_VEND1=A3_COD"       
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND C5_USRIMPL='MOST'" 
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 
 */
cQuery+= "UNION ALL " 

//Num pedidos (Faturados)
cQuery+= "SELECT (CASE WHEN A1_GRPVEN IN ('000003') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000002' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000006' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN='000007' THEN '3-CONSUMIDOR FINAL' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000001') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000004') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN A1_GRPVEN IN ('000006') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "COUNT(DISTINCT(C5_NUM)) TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND C5_VEND1=A3_COD" 
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND C6_NOTA<>' '" 
cQuery+= " AND C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A3_MSBLQL<>'1'"
cQuery+= " GROUP BY A1_GRPVEN " 

cQuery+=") AGRUPA" 

cQuery+= " GROUP BY SEGMTO"
cQuery+= " ORDER BY SEGMTO"

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()


// ****************************************************************
//                     GERA QUERY SUPERVISORES
// ****************************************************************

IncProc("Processando Supervisores... ", "Aguarde...") 

cQuery:= "SELECT SUPERV, " 
cQuery+= "SUM(TOTVALPED) TTVALPED," 
cQuery+= "SUM(TOTVALBRU) TTVALBRU," 
cQuery+= "SUM(TOTVALLIQ) TTVALLIQ,"  
cQuery+= "SUM(TOTQTDPED) TTQTDPED," 
cQuery+= "SUM(TOTFAT) TTFAT," 
cQuery+= "SUM(TOTPEDABE) TTPEDABE," 
cQuery+= "SUM(TOTBONIF) TTBONIF," 
cQuery+= "SUM(TOTDEVOL) TTDEVOL," 
cQuery+= "SUM(TOTICMS) TTICMS," 
cQuery+= "SUM(TOTCPV) TTCPV," 
cQuery+= "SUM(TOTCPV2) TTCPV2," 
cQuery+= "SUM(TOTCLICAD) TTCLICAD," 
cQuery+= "SUM(TOTCLIFAT) TTCLIFAT," 
cQuery+= "SUM(TOTCLICR) TTCLICR," 
cQuery+= "SUM(TOTCLIATI) TTCLIATI," 
cQuery+= "SUM(TOTPEDIDO) TTPEDIDO," 
cQuery+= "SUM(TOTPEDFAT) TTPEDFAT," 
cQuery+= "SUM(TOTITENS) TTITENS FROM (" 

//Entrada de Pedidos 
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
//cQuery+= "SUM(SC6.C6_QTDVEN*SC6.C6_PRCVEN) TOTVALPED,"  
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 

cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery+= "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery+= "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4020 SF4 "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' 
cQuery+= "  AND SC5.C5_TIPO NOT IN ('D','B') "
cQuery+= "  AND SC6.C6_FILIAL = SC5.C5_FILIAL "
cQuery+= "  AND SC6.C6_NUM = SC5.C5_NUM   "
cQuery+= "  AND SC6.C6_CLI = SC5.C5_CLIENTE" 
cQuery+= "  AND SC6.C6_LOJA = SC5.C5_LOJACLI" 
cQuery+= "  AND (SC6.C6_BLQ<>'R ' OR SC6.C6_QTDENT > 0) "
cQuery+= "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery+= "  AND SF4.F4_ESTOQUE = 'S' "
cQuery+= "  AND SF4.F4_DUPLIC = 'S' "
cQuery+= "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "  AND SC6.D_E_L_E_T_ = ' ' "
cQuery+= "  AND SC5.D_E_L_E_T_ = ' ' "
/*
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 " 
cQuery+= "RIGHT JOIN SA3020 SA3 ON SA3.A3_COD=SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SA1020 SA1 ON SA1.A1_COD=SC5.C5_CLIENTE AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SE4020 SE4 ON SE4.E4_CODIGO=SC5.C5_CONDPAG AND SE4.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN ACY020 ACY ON ACY.ACY_GRPVEN=SA1.A1_GRPVEN AND ACY.D_E_L_E_T_='' ,SC6020 SC6 ,SF4020 SF4 "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= "  AND SC5.C5_TIPO='N'" 
cQuery+= "  AND SC6.C6_FILIAL=SC5.C5_FILIAL"
cQuery+= "  AND SC5.C5_CANCELA<>'S'"
cQuery+= "  AND SUBSTRING(SC5.C5_NOTA,1,6) <>'XXXXXX'" 
cQuery+= "  AND SC5.C5_SERIE<>'XXX'"
cQuery+= "  AND SC6.C6_NUM=SC5.C5_NUM"
cQuery+= "  AND SC6.C6_CLI=SC5.C5_CLIENTE"
cQuery+= "  AND SC6.C6_LOJA=SC5.C5_LOJACLI" 
cQuery+= "  AND SF4.F4_CODIGO=SC6.C6_TES"
cQuery+= "  AND SF4.F4_ESTOQUE='S'"
cQuery+= "  AND SF4.F4_DUPLIC='S'"
cQuery+= "  AND SF4.D_E_L_E_T_=''" 
cQuery+= "  AND SC6.D_E_L_E_T_=''"
*/
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

// Faturados / Desconto Medio
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       SUM(SD2.D2_QUANT*SD2.D2_PRUNIT) TOTVALBRU, "  
cQuery+= "       SUM(SD2.D2_QUANT*SD2.D2_PRCVEN) TOTVALLIQ, "  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       SUM(SD2.D2_VALBRUT) TOTFAT," 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       SUM(D2_ICMSRET) TOTICMS," 
cQuery+= "       SUM(SD2.D2_CUSTO1) TOTCPV, " 
cQuery+= "       SUM(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 + SD2.D2_VALFRE) TOTCPV2," 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2010 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= "  AND D2_TP='3'"
cQuery+= "  AND D2_TIPO NOT IN ('B','D')"
cQuery+= "  AND SD2.D_E_L_E_T_=''"
/*
cQuery+= "FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4, "+RetSQLName("SB1")+" SB1 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''" 
cQuery+= " AND F2_CLIENTE=A1_COD" 
cQuery+= " AND F2_LOJA=A1_LOJA" 
cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF4.F4_DUPLIC='S'" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SF2.F2_TIPO NOT IN ('D','B')"
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SD2.D2_TP='PA'"
cQuery+= " AND SB1.B1_COD=SD2.D2_COD"
*/
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

//Pedidos em Aberto
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= " WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= "   AND C5_FILIAL=C6_FILIAL " 
cQuery+= "   AND C5_NUM=C6_NUM" 
cQuery+= "   AND C5_CLIENTE=A1_COD" 
cQuery+= "   AND C5_LOJACLI=A1_LOJA" 
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= "   AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= "   AND SF4.F4_DUPLIC = 'S' "      
cQuery+= "   AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= "   AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe+1)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"' "
cQuery+= "   AND SC5.C5_TIPO='N' "
cQuery+= "   AND C6_BLQ<>'R'" 
cQuery+= "   AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= "   AND SF4.F4_DUPLIC = 'S' "      
cQuery+= " GROUP BY SA3.A3_SUPER " 
cQuery+= "UNION ALL " 

//BonificaÁıes
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       SUM(SD2.D2_TOTAL) TOTBONIF," 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2,"+RetSQLName("SF2")+" SF2,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SD2.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= " AND F2_CLIENTE=A1_COD" 
cQuery+= " AND F2_LOJA=A1_LOJA" 
cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SUBSTRING(SF4.F4_CF,2,3) = '910'"   //TES de BonificaÁıes
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= " UNION ALL " 

//DevoluÁıes
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       SUM((D1_TOTAL + (CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END) + D1_VALIPI + D1_VALFRE - D1_VALDESC + D1_DESPESA) ) TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS "            
cQuery+= " FROM "+RetSQLName("SF1")+" SF1, "+RetSQLName("SD1")+" SD1, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 , "+RetSQLName("SF4")+" SF4 " 
cQuery+= " WHERE SF1.D_E_L_E_T_	= ''  AND SA1.D_E_L_E_T_ = ''  AND SA3.D_E_L_E_T_ = ''  AND SD1.D_E_L_E_T_ = ''  AND SF4.D_E_L_E_T_ = '' " 
cQuery+= "   AND F1_DTDIGIT BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "                                                                  
cQuery+= "   AND F1_TIPO = 'D'  " 
cQuery+= "   AND D1_FILIAL = F1_FILIAL  " 
cQuery+= "   AND D1_DOC = F1_DOC " 
cQuery+= "   AND D1_SERIE = F1_SERIE " 
cQuery+= "   AND D1_FORNECE = F1_FORNECE " 
cQuery+= "   AND D1_TES = F4_CODIGO  " 
cQuery+= "   AND F4_DUPLIC = 'S' " 
cQuery+= "   AND A1_COD	= F1_FORNECE  " 
cQuery+= "   AND A1_LOJA = F1_LOJA  " 
cQuery+= "   AND A1_VEND = A3_COD  " 
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
cQuery+= "FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados com Faturamento
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' "                 
cQuery+= " AND A1_VEND = A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

//Carteira Clientes Cadastrados = TOTAL
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= " 0 TOTVALPED,"  
cQuery+= " 0 TOTVALBRU,"  
cQuery+= " 0 TOTVALLIQ,"  
cQuery+= " 0 TOTQTDPED," 
cQuery+= " 0 TOTFAT," 
cQuery+= " 0 TOTPEDABE," 
cQuery+= " 0 TOTBONIF," 
cQuery+= " 0 TOTDEVOL," 
cQuery+= " 0 TOTICMS," 
cQuery+= " 0 TOTCPV," 
cQuery+= " 0 TOTCPV2," 
cQuery+= " 0 TOTCLICAD," 
cQuery+= " 0 TOTCLIFAT," 
cQuery+= " COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICR," 
cQuery+= " 0 TOTCLIATI," 
cQuery+= " 0 TOTPEDIDO," 
cQuery+= " 0 TOTPEDFAT," 
cQuery+= " 0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND A1_VEND=A3_COD " 
cQuery+= " AND A1_GRPVEN<>'000000' "
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL " 

//Carteira Clientes 4 meses Cadastrados = ATIVOS
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe4M)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_GRPVEN<>'000000' "
cQuery+= " GROUP BY SA3.A3_SUPER " 

cQuery+= "UNION ALL "  

//Num pedidos (Entrada)
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       COUNT(SC6.C6_NUM) TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3  ,"+RetSQLName("SF4")+" SF4 "  
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' '  AND SC6.D_E_L_E_T_ = ' '  AND SA1.D_E_L_E_T_ = ' '  AND SA3.D_E_L_E_T_ = ' ' " 
cQuery+= "   AND C5_NUM = C6_NUM " 
cQuery+= "   AND C5_CLIENTE = A1_COD " 
cQuery+= "   AND C5_LOJACLI = A1_LOJA "         
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD " 
cQuery+= "   AND C6_BLQ <> 'R' " 
cQuery += "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery += "  AND SF4.F4_ESTOQUE = 'S' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' "
cQuery += "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "   AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= " GROUP BY SA3.A3_SUPER " 

/*

cQuery+= "UNION ALL " 

//Num pedidos (via Palm)
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDPALM, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' '  AND SC6.D_E_L_E_T_ = ' '  AND SA1.D_E_L_E_T_ = ' '  AND SA3.D_E_L_E_T_ = ' ' " 
cQuery+= "   AND C5_NUM = C6_NUM " 
cQuery+= "   AND C5_CLIENTE = A1_COD " 
cQuery+= "   AND C5_LOJACLI = A1_LOJA " 
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD "       
cQuery+= "   AND C6_BLQ <> 'R' " 
cQuery+= "   AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= "   AND SC5.C5_USRIMPL = 'MOST' " 
cQuery+= " GROUP BY SA3.A3_SUPER " 

*/
cQuery+= "UNION ALL " 

//Num pedidos (Faturados)
cQuery+= "SELECT SA3.A3_SUPER SUPERV,"
cQuery+= "    0 TOTVALPED,"  
cQuery+= "    0 TOTVALBRU,"  
cQuery+= "    0 TOTVALLIQ,"  
cQuery+= "    0 TOTQTDPED," 
cQuery+= "    0 TOTFAT," 
cQuery+= "    0 TOTPEDABE," 
cQuery+= "    0 TOTBONIF," 
cQuery+= "    0 TOTDEVOL," 
cQuery+= "    0 TOTICMS," 
cQuery+= "    0 TOTCPV," 
cQuery+= "    0 TOTCPV2," 
cQuery+= "    0 TOTCLICAD," 
cQuery+= "    0 TOTCLIFAT," 
cQuery+= "    0 TOTCLICR," 
cQuery+= "    0 TOTCLIATI," 
cQuery+= "    0 TOTPEDIDO," 
cQuery+= "    COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDFAT," 
cQuery+= "    0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 "
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= "     AND C5_NUM=C6_NUM" 
cQuery+= "     AND C5_CLIENTE=A1_COD" 
cQuery+= "     AND C5_LOJACLI=A1_LOJA" 
cQuery+= "     AND SC5.C5_VEND1=SA3.A3_COD" 
cQuery+= "     AND C6_BLQ<>'R'" 
cQuery += "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery += "  AND SF4.F4_ESTOQUE = 'S' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' "
cQuery += "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "     AND C6_NOTA<>' '" 
cQuery+= "     AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= "GROUP BY SA3.A3_SUPER " 

cQuery+=" ) AGRUPA " 

cQuery+= " GROUP BY SUPERV "
cQuery+= " ORDER BY SUPERV "

If Select("TRAB2") > 0 
	TRAB2->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB2"

dbSelectArea("TRAB2")
dbGotop()



// ****************************************************************
//                     GERA QUERY POR ESTADO
// ****************************************************************

IncProc("Processando Estados... ", "Aguarde...") 

cQuery:= "SELECT ESTADO, " 
cQuery+= "SUM(TOTVALPED) TTVALPED," 
cQuery+= "SUM(TOTVALBRU) TTVALBRU," 
cQuery+= "SUM(TOTVALLIQ) TTVALLIQ,"  
cQuery+= "SUM(TOTQTDPED) TTQTDPED," 
cQuery+= "SUM(TOTFAT) TTFAT," 
cQuery+= "SUM(TOTPEDABE) TTPEDABE," 
cQuery+= "SUM(TOTBONIF) TTBONIF," 
cQuery+= "SUM(TOTDEVOL) TTDEVOL," 
cQuery+= "SUM(TOTICMS) TTICMS," 
cQuery+= "SUM(TOTCPV) TTCPV," 
cQuery+= "SUM(TOTCPV2) TTCPV2," 
cQuery+= "SUM(TOTCLICAD) TTCLICAD," 
cQuery+= "SUM(TOTCLIFAT) TTCLIFAT," 
cQuery+= "SUM(TOTCLICR) TTCLICR," 
cQuery+= "SUM(TOTCLIATI) TTCLIATI," 
cQuery+= "SUM(TOTPEDIDO) TTPEDIDO," 
cQuery+= "SUM(TOTPEDFAT) TTPEDFAT," 
cQuery+= "SUM(TOTITENS) TTITENS FROM (" 

//Entrada de Pedidos 
cQuery+= "SELECT SA1.A1_EST ESTADO,"
//cQuery+= "SUM(SC6.C6_QTDVEN*SC6.C6_PRCVEN) TOTVALPED,"  
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 

cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
cQuery+= "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
cQuery+= "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' 
cQuery+= "  AND SC5.C5_TIPO NOT IN ('D','B') "
cQuery+= "  AND SC6.C6_FILIAL = SC5.C5_FILIAL "
cQuery+= "  AND SC6.C6_NUM = SC5.C5_NUM   "
cQuery+= "  AND SC6.C6_CLI = SC5.C5_CLIENTE" 
cQuery+= "  AND SC6.C6_LOJA = SC5.C5_LOJACLI" 
cQuery+= "  AND (SC6.C6_BLQ<>'R ' OR SC6.C6_QTDENT > 0) "
cQuery+= "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery+= "  AND SF4.F4_ESTOQUE = 'S' "
cQuery+= "  AND SF4.F4_DUPLIC = 'S' "
cQuery+= "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "  AND SC6.D_E_L_E_T_ = ' ' "
cQuery+= "  AND SC5.D_E_L_E_T_ = ' ' "
/*
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 " 
cQuery+= "RIGHT JOIN SA3020 SA3 ON SA3.A3_COD=SC5.C5_VEND1 AND SA3.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SA1020 SA1 ON SA1.A1_COD=SC5.C5_CLIENTE AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN SE4020 SE4 ON SE4.E4_CODIGO=SC5.C5_CONDPAG AND SE4.D_E_L_E_T_='' "
cQuery+= "RIGHT JOIN ACY020 ACY ON ACY.ACY_GRPVEN=SA1.A1_GRPVEN AND ACY.D_E_L_E_T_='' ,SC6020 SC6 ,SF4020 SF4 "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= "  AND SC5.C5_TIPO='N'" 
cQuery+= "  AND SC6.C6_FILIAL=SC5.C5_FILIAL"
cQuery+= "  AND SC5.C5_CANCELA<>'S'"
cQuery+= "  AND SUBSTRING(SC5.C5_NOTA,1,6) <>'XXXXXX'" 
cQuery+= "  AND SC5.C5_SERIE<>'XXX'"
cQuery+= "  AND SC6.C6_NUM=SC5.C5_NUM"
cQuery+= "  AND SC6.C6_CLI=SC5.C5_CLIENTE"
cQuery+= "  AND SC6.C6_LOJA=SC5.C5_LOJACLI" 
cQuery+= "  AND SF4.F4_CODIGO=SC6.C6_TES"
cQuery+= "  AND SF4.F4_ESTOQUE='S'"
cQuery+= "  AND SF4.F4_DUPLIC='S'"
cQuery+= "  AND SF4.D_E_L_E_T_=''" 
cQuery+= "  AND SC6.D_E_L_E_T_=''"
*/
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

// Faturados / Desconto Medio
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       SUM(SD2.D2_QUANT*SD2.D2_PRUNIT) TOTVALBRU, "  
cQuery+= "       SUM(SD2.D2_QUANT*SD2.D2_PRCVEN) TOTVALLIQ, "  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       SUM(SD2.D2_VALBRUT) TOTFAT," 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       SUM(D2_ICMSRET) TOTICMS," 
cQuery+= "       SUM(SD2.D2_CUSTO1) TOTCPV, " 
cQuery+= "       SUM(SD2.D2_TOTAL - SD2.D2_VALICM - SD2.D2_VALIMP5 - SD2.D2_VALIMP6 + SD2.D2_VALFRE) TOTCPV2," 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2010 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4010 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1010 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= "  AND D2_TP='3'"
cQuery+= "  AND D2_TIPO NOT IN ('B','D')"
cQuery+= "  AND SD2.D_E_L_E_T_=''"
/*
cQuery+= "FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4, "+RetSQLName("SB1")+" SB1 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''" 
cQuery+= " AND F2_CLIENTE=A1_COD" 
cQuery+= " AND F2_LOJA=A1_LOJA" 
cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF4.F4_DUPLIC='S'" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SF2.F2_TIPO NOT IN ('D','B')"
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SD2.D2_TP='PA'"
cQuery+= " AND SB1.B1_COD=SD2.D2_COD"
*/
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

//Pedidos em Aberto
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= " WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= "   AND C5_FILIAL=C6_FILIAL " 
cQuery+= "   AND C5_NUM=C6_NUM" 
cQuery+= "   AND C5_CLIENTE=A1_COD" 
cQuery+= "   AND C5_LOJACLI=A1_LOJA" 
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= "   AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= "   AND SF4.F4_DUPLIC = 'S' "      
cQuery+= "   AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= "   AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe+1)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"' "
cQuery+= "   AND SC5.C5_TIPO='N' "
cQuery+= "   AND C6_BLQ<>'R'" 
cQuery+= "   AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= "   AND SF4.F4_DUPLIC = 'S' "      
cQuery+= " GROUP BY SA1.A1_EST " 
cQuery+= "UNION ALL " 

//BonificaÁıes
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       SUM(SD2.D2_TOTAL) TOTBONIF," 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2,"+RetSQLName("SF2")+" SF2,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SD2.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_=''" 
cQuery+= " AND F2_CLIENTE=A1_COD" 
cQuery+= " AND F2_LOJA=A1_LOJA" 
cQuery+= " AND SF2.F2_VEND1=SA3.A3_COD" 
cQuery+= " AND SF4.F4_CODIGO=SD2.D2_TES" 
cQuery+= " AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SD2.D2_FILIAL=SF2.F2_FILIAL"
cQuery+= " AND SD2.D2_DOC=SF2.F2_DOC"
cQuery+= " AND SD2.D2_SERIE=SF2.F2_SERIE"
cQuery+= " AND SUBSTRING(SF4.F4_CF,2,3) = '910'"   //TES de BonificaÁıes
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= " UNION ALL " 

//DevoluÁıes
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       SUM((D1_TOTAL + (CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END) + D1_VALIPI + D1_VALFRE - D1_VALDESC + D1_DESPESA) ) TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS "            
cQuery+= " FROM "+RetSQLName("SF1")+" SF1, "+RetSQLName("SD1")+" SD1, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 , "+RetSQLName("SF4")+" SF4 " 
cQuery+= " WHERE SF1.D_E_L_E_T_	= ''  AND SA1.D_E_L_E_T_ = ''  AND SA3.D_E_L_E_T_ = ''  AND SD1.D_E_L_E_T_ = ''  AND SF4.D_E_L_E_T_ = '' " 
cQuery+= "   AND F1_DTDIGIT BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "                                                                  
cQuery+= "   AND F1_TIPO = 'D'  " 
cQuery+= "   AND D1_FILIAL = F1_FILIAL  " 
cQuery+= "   AND D1_DOC = F1_DOC " 
cQuery+= "   AND D1_SERIE = F1_SERIE " 
cQuery+= "   AND D1_FORNECE = F1_FORNECE " 
cQuery+= "   AND D1_TES = F4_CODIGO  " 
cQuery+= "   AND F4_DUPLIC = 'S' " 
cQuery+= "   AND A1_COD	= F1_FORNECE  " 
cQuery+= "   AND A1_LOJA = F1_LOJA  " 
cQuery+= "   AND A1_VEND = A3_COD  " 
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
cQuery+= "FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados com Faturamento
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' "                 
cQuery+= " AND A1_VEND = A3_COD" 
cQuery+= " AND A1_DTNASC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

//Carteira Clientes Cadastrados = TOTAL
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= " 0 TOTVALPED,"  
cQuery+= " 0 TOTVALBRU,"  
cQuery+= " 0 TOTVALLIQ,"  
cQuery+= " 0 TOTQTDPED," 
cQuery+= " 0 TOTFAT," 
cQuery+= " 0 TOTPEDABE," 
cQuery+= " 0 TOTBONIF," 
cQuery+= " 0 TOTDEVOL," 
cQuery+= " 0 TOTICMS," 
cQuery+= " 0 TOTCPV," 
cQuery+= " 0 TOTCPV2," 
cQuery+= " 0 TOTCLICAD," 
cQuery+= " 0 TOTCLIFAT," 
cQuery+= " COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICR," 
cQuery+= " 0 TOTCLIATI," 
cQuery+= " 0 TOTPEDIDO," 
cQuery+= " 0 TOTPEDFAT," 
cQuery+= " 0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND A1_VEND=A3_COD " 
cQuery+= " AND A1_GRPVEN<>'000000' "
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL " 

//Carteira Clientes 4 meses Cadastrados = ATIVOS
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe4M)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_GRPVEN<>'000000' "
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+= "UNION ALL "  

//Num pedidos (Entrada)
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDIDO, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       COUNT(SC6.C6_NUM) TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3  ,"+RetSQLName("SF4")+" SF4 "  
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' '  AND SC6.D_E_L_E_T_ = ' '  AND SA1.D_E_L_E_T_ = ' '  AND SA3.D_E_L_E_T_ = ' ' " 
cQuery+= "   AND C5_NUM = C6_NUM " 
cQuery+= "   AND C5_CLIENTE = A1_COD " 
cQuery+= "   AND C5_LOJACLI = A1_LOJA "         
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD " 
cQuery+= "   AND C6_BLQ <> 'R' " 
cQuery += "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery += "  AND SF4.F4_ESTOQUE = 'S' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' "
cQuery += "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "   AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= " GROUP BY SA1.A1_EST " 

/*
cQuery+= "UNION ALL " 


//Num pedidos (via Palm)
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "       0 TOTVALPED, "  
cQuery+= "       0 TOTVALBRU, "  
cQuery+= "       0 TOTVALLIQ,"  
cQuery+= "       0 TOTQTDPED, " 
cQuery+= "       0 TOTFAT, " 
cQuery+= "       0 TOTPEDABE, " 
cQuery+= "       0 TOTBONIF, " 
cQuery+= "       0 TOTDEVOL, " 
cQuery+= "       0 TOTICMS," 
cQuery+= "       0 TOTCPV, " 
cQuery+= "       0 TOTCPV2, " 
cQuery+= "       0 TOTCLICAD, " 
cQuery+= "       0 TOTCLIFAT, " 
cQuery+= "       0 TOTCLICR, " 
cQuery+= "       0 TOTCLIATI, " 
cQuery+= "       0 TOTPEDIDO, " 
cQuery+= "       COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDPALM, " 
cQuery+= "       0 TOTPEDFAT, " 
cQuery+= "       0 TOTITENS " 
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' '  AND SC6.D_E_L_E_T_ = ' '  AND SA1.D_E_L_E_T_ = ' '  AND SA3.D_E_L_E_T_ = ' ' " 
cQuery+= "   AND C5_NUM = C6_NUM " 
cQuery+= "   AND C5_CLIENTE = A1_COD " 
cQuery+= "   AND C5_LOJACLI = A1_LOJA " 
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD "       
cQuery+= "   AND C6_BLQ <> 'R' " 
cQuery+= "   AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= "   AND SC5.C5_USRIMPL = 'MOST' " 
cQuery+= " GROUP BY SA1.A1_EST " 
*/
cQuery+= "UNION ALL " 

//Num pedidos (Faturados)
cQuery+= "SELECT SA1.A1_EST ESTADO,"
cQuery+= "    0 TOTVALPED,"  
cQuery+= "    0 TOTVALBRU,"  
cQuery+= "    0 TOTVALLIQ,"  
cQuery+= "    0 TOTQTDPED," 
cQuery+= "    0 TOTFAT," 
cQuery+= "    0 TOTPEDABE," 
cQuery+= "    0 TOTBONIF," 
cQuery+= "    0 TOTDEVOL," 
cQuery+= "    0 TOTICMS," 
cQuery+= "    0 TOTCPV," 
cQuery+= "    0 TOTCPV2," 
cQuery+= "    0 TOTCLICAD," 
cQuery+= "    0 TOTCLIFAT," 
cQuery+= "    0 TOTCLICR," 
cQuery+= "    0 TOTCLIATI," 
cQuery+= "    0 TOTPEDIDO," 
cQuery+= "    COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDFAT," 
cQuery+= "    0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 "
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= "     AND C5_NUM=C6_NUM" 
cQuery+= "     AND C5_CLIENTE=A1_COD" 
cQuery+= "     AND C5_LOJACLI=A1_LOJA" 
cQuery+= "     AND SC5.C5_VEND1=SA3.A3_COD" 
cQuery+= "     AND C6_BLQ<>'R'" 
cQuery += "  AND SF4.F4_CODIGO = SC6.C6_TES "
cQuery += "  AND SF4.F4_ESTOQUE = 'S' "
cQuery += "  AND SF4.F4_DUPLIC = 'S' "
cQuery += "  AND SF4.D_E_L_E_T_ = ' ' 
cQuery+= "     AND C6_NOTA<>' '" 
cQuery+= "     AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " GROUP BY SA1.A1_EST " 

cQuery+=" ) AGRUPA " 

cQuery+= " GROUP BY ESTADO "
cQuery+= " ORDER BY ESTADO "

If Select("TRAB3") > 0 
	TRAB3->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB3"

dbSelectArea("TRAB3")
dbGotop()

IncProc("Gerando relatÛrio... ", "Aguarde...") 

EnvMailPerf() 


dbSelectArea("TRAB")
dbCloseArea()

dbSelectArea("TRAB2")
dbCloseArea()

dbSelectArea("TRAB3")
dbCloseArea()

Return(.T.)


 
Static Function EnvMailPerf() //aDadosAx)
****************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""
Local cEmail  := ""
Local cPLin   := Chr(13)+Chr(10)
Local cMesAux := {"Janeiro","Fevereiro","MarÁo","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

_cBody := "<html>"
_cBody += "<head>"
_cBody += '<meta http-equiv="Content-Language" content="pt-br">'
_cBody += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
_cBody += "<title>Nova pagina 1</title>"
_cBody += "</head>"
_cBody += "<body>"

_cBody += '<p align="center"><font face="Tahoma" size="2"><b>PERFORMANCE DE VENDAS - '+cMesAux[Month(dDataDe)]+'/'+Alltrim(Str(Year(dDataDe)))+'</b></font></p>'
_cBody += '<p align="center"><font face="Tahoma" size="2">PerÌodo: '+DtoC(dDataDe)+' atÈ '+DtoC(dDataAte)+'</font></p>                    '

_cBody += '<table border="1" width="100%">                                                                    '
_cBody += '	<tr>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="7%"><b><font face="Tahoma" size="1">Segmento</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="5%" align="center"><b><font face="Tahoma" size="1">Entrada de Pedidos</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Meta</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Subs. Tribut·ria</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="5%" align="center"><b><font face="Tahoma" size="1">Pedidos em Aberto</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Desc. MÈdio</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">Bonificados</font></b></td> '
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">DevoluÁıes</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="3%" align="center"><b><font face="Tahoma" size="1">CPV</font></b></td>'
_cBody += '		<td rowspan="2" bgcolor="#ccffcc" width="5%" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. MÍs</font></b></td>'
_cBody += '		<td rowspan="2" colspan="2" bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. c/ Fat.</font></b></td>'
_cBody += '		<td width="12%" colspan="3" bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Carteira de Clientes</b> '+Chr(13)+Chr(10)+'(4meses)</font></td>'
_cBody += '		<td width="8%" colspan="4" bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">N∫ Pedidos Venda</font></b></td>'
_cBody += '		<td width="4%" rowspan="2" bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">MÈdia Itens P/ Pedido</font></b></td>'
_cBody += '		<td width="4%" rowspan="2" bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Val.MÈdio Pedidos</font></b></td>'
_cBody += '	</tr>'
_cBody += '	<tr>'
_cBody += '		<td width="4%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Ativos</font></b></td>   '
_cBody += '		<td width="4%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Inativos</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>    '
_cBody += '		<td width="3%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Entrada</font></b></td>  '
_cBody += '		<td width="3%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Via Palm</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '		<td width="3%"  bgcolor="#ccffcc" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>'
_cBody += '	</tr>'

_TOTFAT    := 0
_TOTPEDABE := 0
_TOTVALPED := 0
_TOTVALBRU := 0
_TOTVALLIQ := 0
_TOTBONIF  := 0
_TOTDEVOL  := 0
_TOTICMS   := 0
_TOTCPV    := 0
_TOTCPV2   := 0
_TOTCLICAD := 0
_TOTCLIFAT := 0
_TOTCLIATI := 0
_TOTCLICR  := 0
_TOTPEDIDO := 0
_TOTPEDPALM:= 0
_TOTPEDFAT := 0
_TOTITENS  := 0
_TOTQTDPED := 0
_TOTMETA   := 0
nContMeta  := 0

DbSelectArea("TRAB")
DbGoTop()

While !Eof()
	nMetaSeg:= BuscaMeta(Val(SubStr(TRAB->SEGMTO,1,1)))
	
	_cBody += '	<tr>'
	_cBody += '	<td width="7%"><font face="Tahoma" size="1">'+SubStr(TRAB->SEGMTO,3,13)+'</font></td> '                                                                      //SEGMENTO
	_cBody += '	<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTVALPED ,"@E 99,999,999"))+'</font></td>'                  //ENTR.PEDIDOS
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFAT ,"@E 99,999,999"))+'</font></td>'                     //FATURADO
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMetaSeg ,"@E 99,999,999"))+'</font></td>'                        //META
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTICMS ,"@E 99,999,999"))+'</font></td>'                    //SUBS TRIBUTARIA
	_cBody += '	<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDABE ,"@E 99,999,999"))+'</font></td>'                  //PEDIDOS EM ABERTO
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((100-(TRAB->TTVALLIQ/TRAB->TTVALBRU)*100),"@R 999%"))+'</font></td>' //DESC.MEDIO
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTBONIF ,"@E 99,999,999"))+'</font></td>'                   //BONIFICA«OES
	_cBody += '	<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB->TTBONIF*100)/TRAB->TTFAT  ,"@R 999%"))+'</font></td>'      //% BONIF
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTDEVOL  ,"@E 99,999,999"))+'</font></td>'                  //DEVOLU«’ES
	_cBody += '	<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB->TTDEVOL*100)/TRAB->TTFAT  ,"@R 999%"))+'</font></td> '     //% DEVOL.
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB->TTCPV/TRAB->TTCPV2)*100  ,"@R 999%"))+'</font></td> '      //CPV
	_cBody += '	<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLICAD ,"@E 99,999"))+'</font></td>   '                   //CLIENTES CADASTRADOS
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLIFAT  ,"@E 99,999"))+'</font></td>  '                   //CLIENTES CAD. C/ FAT.
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB->TTCLIFAT*100)/TRAB->TTCLICAD  ,"@R 999%"))+'</font></td> ' //% CLI CAD C/ FAT
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLIATI  ,"@E 99,999"))+'</font></td> '                    //CLIENTES ATIVOS
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLICR-TRAB->TTCLIATI  ,"@E 99,999"))+'</font></td>  '     //CLIENTES INATIVOS
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTCLICR  ,"@E 99,999"))+'</font></td>  '                    //TOTAL CLIENTES
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDIDO  ,"@E 99,999"))+'</font></td>  '                   //QTD ENTRADA PEDIDOS
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(0,"@E 99,999"))+'</font></td>  '                   //QTD ENTR. PED VIA PALM
 	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDFAT  ,"@E 99,999"))+'</font></td>  '                   //QTD PED. FATURADOS
	_cBody += '	<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB->TTPEDFAT*100)/TRAB->TTPEDIDO ,"@R 999%"))+'</font></td> '  //TOTAL QTD PEDIDOS
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTITENS/TRAB->TTPEDIDO  ,"@E 999.99"))+'</font></td>     '  //MEDIA ITENS P/ PEDIDO
	_cBody += '	<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTVALPED/TRAB->TTPEDIDO ,"@E 999,999"))+'</font></td>    '  //VALOR MEDIO DOS PEDIDOS
	_cBody += '	</tr> '

	DbSelectArea("TRAB")

	_TOTFAT    += TRAB->TTFAT
	_TOTPEDABE += TRAB->TTPEDABE
	_TOTVALPED += TRAB->TTVALPED
	_TOTVALBRU += TRAB->TTVALBRU
	_TOTVALLIQ += TRAB->TTVALLIQ
	_TOTBONIF  += TRAB->TTBONIF
	_TOTDEVOL  += TRAB->TTDEVOL
	_TOTICMS   += TRAB->TTICMS
	_TOTCPV    += TRAB->TTCPV
	_TOTCPV2   += TRAB->TTCPV2
	_TOTCLICAD += TRAB->TTCLICAD
	_TOTCLIFAT += TRAB->TTCLIFAT
	_TOTCLIATI += TRAB->TTCLIATI
	_TOTCLICR  += TRAB->TTCLICR
	_TOTPEDIDO += TRAB->TTPEDIDO
	_TOTPEDPALM+= 0//TRAB->TTPEDPALM
	_TOTPEDFAT += TRAB->TTPEDFAT
	_TOTITENS  += TRAB->TTITENS
	_TOTQTDPED += TRAB->TTQTDPED
	_TOTMETA   += nMetaSeg
	
	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="7%" bgcolor="#cccccc" ><b><font face="Tahoma" size="1">T O T A L</font></b></td> '  
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED ,"@E 99,999,999"))+'</font></b></td>' //ENTR.PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTFAT ,"@E 99,999,999"))+'</font></b></td>'    //FATURADO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTMETA,"@E 99,999,999"))+'</font></b></td>'  //META
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTICMS,"@E 99,999,999"))+'</font></b></td>'  //SUBS TRIBUTARIA
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDABE ,"@E 99,999,999"))+'</font></b></td>' //PEDIDOS EM ABERTO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((100-(_TOTVALLIQ/_TOTVALBRU)*100)  ,"@R 999%"))+'</font></b></td>' //DESC.MEDIO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTBONIF ,"@E 99,999,999"))+'</font></b></td>' //BONIFICA«OES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTBONIF*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>'  //% BONIF
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTDEVOL  ,"@E 99,999,999"))+'</font></b></td>' //DEVOLU«’ES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTDEVOL*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>' //% DEVOL.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCPV/_TOTCPV2)*100  ,"@R 999%"))+'</font></b></td>      ' //CPV
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICAD ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CADASTRADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIFAT  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CAD. C/ FAT.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCLIFAT*100)/_TOTCLICAD  ,"@R 999%"))+'</font></b></td>         '  //% CLI CAD C/ FAT
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES ATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR-_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES INATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR  ,"@E 99,999"))+'</font></b></td>  ' //TOTAL CLIENTES
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDIDO  ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTRADA PEDIDOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDPALM ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTR. PED VIA PALM
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDFAT  ,"@E 99,999"))+'</font></b></td>  ' //QTD PED. FATURADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTPEDFAT*100)/_TOTPEDIDO ,"@R 999%"))+'</font></b></td>       ' //TOTAL QTD PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTITENS/_TOTPEDIDO  ,"@E 999.99"))+'</font></b></td>       ' //MEDIA ITENS P/ PEDIDO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED/_TOTPEDIDO ,"@E 999,999"))+'</font></b></td>   ' //VALOR MEDIO DOS PEDIDOS
_cBody += '	</tr> '
_cBody += '</table>'

_cBody += '<p align="center"><font face="Tahoma" size="3"> </font></p> '
_cBody += '<p><font face="Tahoma" size="1">Performance por Supervisor:</font></p> '

_cBody += '<table border="1" width="100%"> '
_cBody += '<tr>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="3%"><b><font face="Tahoma" size="1">Cod.</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="10%"><b><font face="Tahoma" size="1">Supervisor</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Entrada Pedidos</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Meta</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Subs. Tribut·ria</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="5%" align="center"><b><font face="Tahoma" size="1">Pedidos em Aberto</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="4%" align="center"><b><font face="Tahoma" size="1">Desc. MÈdio</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">Bonificados</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">DevoluÁıes</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="3%" align="center"><b><font face="Tahoma" size="1">CPV</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#ffffcc" width="5%" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. MÍs</font></b></td>'
_cBody += '	<td colspan="2" rowspan="2" bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. c/ Fat.</font></b></td>'
_cBody += '	<td width="12%" colspan="3" bgcolor="#ffffcc" align="center"><font face="Tahoma" size="1"><b>Carteira de Clientes</b> '+Chr(13)+Chr(10)+'(4meses)</font></td>'
_cBody += '	<td width="8%" bgcolor="#ffffcc" colspan="4" align="center"><b><font face="Tahoma" size="1">N∫ Pedidos Venda</font></b></td>'
_cBody += '	<td width="4%" bgcolor="#ffffcc" rowspan="2" align="center"><b><font face="Tahoma" size="1">MÈdia Itens P/ Pedido</font></b></td>'
_cBody += '	<td width="4%" bgcolor="#ffffcc" rowspan="2" align="center"><b><font face="Tahoma" size="1">Val.MÈdio Pedidos</font></b></td>'
_cBody += '</tr>
_cBody += '	<tr>'
_cBody += '		<td width="4%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Ativos</font></b></td>   '
_cBody += '		<td width="4%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Inativos</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>    '
_cBody += '		<td width="3%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Entrada</font></b></td>  '
_cBody += '		<td width="3%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Via Palm</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '		<td width="3%"  bgcolor="#ffffcc" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>'
_cBody += '	</tr>'

_TOTFAT    := 0
_TOTPEDABE := 0
_TOTVALPED := 0
_TOTVALBRU := 0
_TOTVALLIQ := 0
_TOTBONIF  := 0
_TOTDEVOL  := 0
_TOTICMS   := 0
_TOTCPV    := 0
_TOTCPV2   := 0
_TOTCLICAD := 0
_TOTCLIFAT := 0
_TOTCLIATI := 0
_TOTCLICR  := 0
_TOTPEDIDO := 0
_TOTPEDPALM:= 0
_TOTPEDFAT := 0
_TOTITENS  := 0
_TOTQTDPED := 0
_TOTMETA   := 0
nContMeta  := 0

DbSelectArea("TRAB2")
DbGoTop()

While !Eof()
	nMetaSeg:= 0 //BuscaMeta(++nContMeta)
	
	_cBody += '	<tr>'
	_cBody += '		<td width="3%"><font face="Tahoma" size="1">'+TRAB2->SUPERV+'</font></td>'
	_cBody += '		<td width="10%"><font face="Tahoma" size="1">'+SubStr(AllTrim(Posicione("SA3",1,xFilial("SA3")+TRAB2->SUPERV,"A3_NOME")),1,15)+'</font></td> '  //SUPERVISOR
	DbSelectArea("TRAB2")
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTVALPED ,"@E 99,999,999"))+'</font></td>' //ENTR.PEDIDOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTFAT ,"@E 99,999,999"))+'</font></td>'    //FATURADO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMetaSeg ,"@E 99,999,999"))+'</font></td>'  //META
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTICMS ,"@E 99,999,999"))+'</font></td>'  //SUBS TRIBUTARIA
	_cBody += '		<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTPEDABE ,"@E 99,999,999"))+'</font></td>' //PEDIDOS EM ABERTO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((100-(TRAB2->TTVALLIQ/TRAB2->TTVALBRU)*100)  ,"@R 999%"))+'</font></td>' //DESC.MEDIO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTBONIF ,"@E 99,999,999"))+'</font></td>' //BONIFICA«OES
	_cBody += '		<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB2->TTBONIF*100)/TRAB2->TTFAT  ,"@R 999%"))+'</font></td>'  //% BONIF
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTDEVOL  ,"@E 99,999,999"))+'</font></td>' //DEVOLU«’ES
	_cBody += '		<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB2->TTDEVOL*100)/TRAB2->TTFAT  ,"@R 999%"))+'</font></td>' //% DEVOL.
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB2->TTCPV/TRAB2->TTCPV2)*100  ,"@R 999%"))+'</font></td>      ' //CPV
	_cBody += '		<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTCLICAD ,"@E 99,999"))+'</font></td>       ' //CLIENTES CADASTRADOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTCLIFAT  ,"@E 99,999"))+'</font></td>       ' //CLIENTES CAD. C/ FAT.
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB2->TTCLIFAT*100)/TRAB2->TTCLICAD  ,"@R 999%"))+'</font></td>         '  //% CLI CAD C/ FAT
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTCLIATI  ,"@E 99,999"))+'</font></td>       ' //CLIENTES ATIVOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTCLICR-TRAB2->TTCLIATI  ,"@E 99,999"))+'</font></td>       ' //CLIENTES INATIVOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTCLICR  ,"@E 99,999"))+'</font></td>  ' //TOTAL CLIENTES
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTPEDIDO  ,"@E 99,999"))+'</font></td>  ' //QTD ENTRADA PEDIDOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(0 ,"@E 99,999"))+'</font></td>  ' //QTD ENTR. PED VIA PALM
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTPEDFAT  ,"@E 99,999"))+'</font></td>  ' //QTD PED. FATURADOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB2->TTPEDFAT*100)/TRAB2->TTPEDIDO ,"@R 999%"))+'</font></td>       ' //TOTAL QTD PEDIDOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTITENS/TRAB2->TTPEDIDO  ,"@E 999.99"))+'</font></td>       ' //MEDIA ITENS P/ PEDIDO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB2->TTVALPED/TRAB2->TTPEDIDO ,"@E 999,999"))+'</font></td>   ' //VALOR MEDIO DOS PEDIDOS
	_cBody += '	</tr> '

	_TOTVALPED += TRAB2->TTVALPED
	_TOTFAT    += TRAB2->TTFAT
	_TOTPEDABE += TRAB2->TTPEDABE
	_TOTVALBRU += TRAB2->TTVALBRU
	_TOTVALLIQ += TRAB2->TTVALLIQ
	_TOTBONIF  += TRAB2->TTBONIF
	_TOTDEVOL  += TRAB2->TTDEVOL
	_TOTICMS   += TRAB2->TTICMS
	_TOTCPV    += TRAB2->TTCPV
	_TOTCPV2   += TRAB2->TTCPV2
	_TOTCLICAD += TRAB2->TTCLICAD
	_TOTCLIFAT += TRAB2->TTCLIFAT
	_TOTCLIATI += TRAB2->TTCLIATI
	_TOTCLICR  += TRAB2->TTCLICR
	_TOTPEDIDO += TRAB2->TTPEDIDO
	_TOTPEDPALM+= 0//TRAB2->TTPEDPALM
	_TOTPEDFAT += TRAB2->TTPEDFAT
	_TOTITENS  += TRAB2->TTITENS
	_TOTQTDPED += TRAB2->TTQTDPED
	_TOTMETA   += nMetaSeg

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="3%" bgcolor="#cccccc" ><font face="Tahoma" size="1"></font></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="1">T O T A L</font></b></td> '  //SUPERVISOR
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED ,"@E 99,999,999"))+'</font></b></td>' //ENTR.PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTFAT ,"@E 99,999,999"))+'</font></b></td>'    //FATURADO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTMETA,"@E 99,999,999"))+'</font></b></td>'  //META
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTICMS,"@E 99,999,999"))+'</font></b></td>'  //SUBS TRIBUTARIA
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDABE ,"@E 99,999,999"))+'</font></b></td>' //PEDIDOS EM ABERTO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((100-(_TOTVALLIQ/_TOTVALBRU)*100)  ,"@R 999%"))+'</font></b></td>' //DESC.MEDIO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTBONIF ,"@E 99,999,999"))+'</font></b></td>' //BONIFICA«OES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTBONIF*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>'  //% BONIF
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTDEVOL  ,"@E 99,999,999"))+'</font></b></td>' //DEVOLU«’ES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTDEVOL*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>' //% DEVOL.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCPV/_TOTCPV2)*100  ,"@R 999%"))+'</font></b></td>      ' //CPV
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICAD ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CADASTRADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIFAT  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CAD. C/ FAT.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCLIFAT*100)/_TOTCLICAD  ,"@R 999%"))+'</font></b></td>         '  //% CLI CAD C/ FAT
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES ATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR-_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES INATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR  ,"@E 99,999"))+'</font></b></td>  ' //TOTAL CLIENTES
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDIDO  ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTRADA PEDIDOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(0 ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTR. PED VIA PALM
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDFAT  ,"@E 99,999"))+'</font></b></td>  ' //QTD PED. FATURADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTPEDFAT*100)/_TOTPEDIDO ,"@R 999%"))+'</font></b></td>       ' //TOTAL QTD PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTITENS/_TOTPEDIDO  ,"@E 999.99"))+'</font></b></td>       ' //MEDIA ITENS P/ PEDIDO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED/_TOTPEDIDO ,"@E 999,999"))+'</font></b></td>   ' //VALOR MEDIO DOS PEDIDOS
_cBody += '	</tr> '
_cBody += '</table>'


//POR ESTADO


aEstados:= {{'AC','ACRE'},{'AM','AMAZONAS'},{'AP','AMAP¡'},{'PA','PAR¡'},{'RO','ROND‘NIA'},{'RR','RORAIMA'},{'TO','TOCANTINS'},;
			{'AL','ALAGOAS'},{'BA','BAHIA'},{'CE','CEARA'},{'MA','MARANH√O'},{'PB','PARAÕBA'},{'PE','PERNAMBUCO'},{'PI','PIAUÕ'},{'RN','RIO GRANDE DO NORTE'},{'SE','SERGIPE'},;
			{'DF','DISTRITO FEDERAL'},{'GO','GOI¡S'},{'MS','MATO GROSSO DO SUL'},{'MT','MATO GROSSO'},;
			{'ES','ESPÕRITO SANTO'},{'MG','MINAS GERAIS'},{'RJ','RIO DE JANEIRO'},{'SP','S√O PAULO'},;
			{'PR','PARAN¡'},{'RS','RIO GRANDE DO SUL'},{'SC','SANTA CATARINA'},{'EX','EXPORTA«√O'}}

_cBody += '<p align="center"><font face="Tahoma" size="3"> </font></p> '
_cBody += '<p><font face="Tahoma" size="1">Performance por Estado:</font></p> '

_cBody += '<table border="1" width="100%"> '
_cBody += '<tr>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="13%"><b><font face="Tahoma" size="1">Estado</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="4%" align="center"><b><font face="Tahoma" size="1">Entrada Pedidos</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="4%" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="4%" align="center"><b><font face="Tahoma" size="1">Meta</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="4%" align="center"><b><font face="Tahoma" size="1">Subs. Tribut·ria</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="5%" align="center"><b><font face="Tahoma" size="1">Pedidos em Aberto</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="4%" align="center"><b><font face="Tahoma" size="1">Desc. MÈdio</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">Bonificados</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="7%" align="center" colspan="2"><b><font face="Tahoma" size="1">DevoluÁıes</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="3%" align="center"><b><font face="Tahoma" size="1">CPV</font></b></td>'
_cBody += '	<td rowspan="2" bgcolor="#d2e9ff" width="5%" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. MÍs</font></b></td>'
_cBody += '	<td colspan="2" rowspan="2" bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Cli. Novos Cad. c/ Fat.</font></b></td>'
_cBody += '	<td width="12%" colspan="3" bgcolor="#d2e9ff" align="center"><font face="Tahoma" size="1"><b>Carteira de Clientes</b> '+Chr(13)+Chr(10)+'(4meses)</font></td>'
_cBody += '	<td width="8%" bgcolor="#d2e9ff" colspan="4" align="center"><b><font face="Tahoma" size="1">N∫ Pedidos Venda</font></b></td>'
_cBody += '	<td width="4%" bgcolor="#d2e9ff" rowspan="2" align="center"><b><font face="Tahoma" size="1">MÈdia Itens P/ Pedido</font></b></td>'
_cBody += '	<td width="4%" bgcolor="#d2e9ff" rowspan="2" align="center"><b><font face="Tahoma" size="1">Val.MÈdio Pedidos</font></b></td>'
_cBody += '</tr> '
_cBody += '	<tr>'
_cBody += '		<td width="4%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Ativos</font></b></td>   '
_cBody += '		<td width="4%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Inativos</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>    '
_cBody += '		<td width="3%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Entrada</font></b></td>  '
_cBody += '		<td width="3%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Via Palm</font></b></td> '
_cBody += '		<td width="4%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Faturado</font></b></td>'
_cBody += '		<td width="3%"  bgcolor="#d2e9ff" align="center"><b><font face="Tahoma" size="1">Total</font></b></td>'
_cBody += '	</tr>'

_TOTFAT    := 0
_TOTPEDABE := 0
_TOTVALPED := 0
_TOTVALBRU := 0
_TOTVALLIQ := 0
_TOTBONIF  := 0
_TOTDEVOL  := 0
_TOTICMS   := 0
_TOTCPV    := 0
_TOTCPV2   := 0
_TOTCLICAD := 0
_TOTCLIFAT := 0
_TOTCLIATI := 0
_TOTCLICR  := 0
_TOTPEDIDO := 0
_TOTPEDFAT := 0
_TOTITENS  := 0
_TOTQTDPED := 0
_TOTMETA   := 0
nContMeta  := 0

DbSelectArea("TRAB3")
DbGoTop()

While !Eof()
	nMetaSeg:= 0 //BuscaMeta(++nContMeta)
	cEstDesc:= ""
	
	nPosEst := aScan(aEstados,{|m| m[1]==AllTrim(TRAB3->ESTADO)})
	If nPosEst>0
		cEstDesc:= aEstados[nPosEst][2]
	EndIf	
	
	_cBody += '	<tr>'
	_cBody += '		<td width="13%"><font face="Tahoma" size="1">'+cEstDesc+'</font></td>'
	DbSelectArea("TRAB3")
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTVALPED ,"@E 99,999,999"))+'</font></td>' //ENTR.PEDIDOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTFAT ,"@E 99,999,999"))+'</font></td>'    //FATURADO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMetaSeg ,"@E 99,999,999"))+'</font></td>'  //META
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTICMS ,"@E 99,999,999"))+'</font></td>'  //SUBS TRIBUTARIA
	_cBody += '		<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTPEDABE ,"@E 99,999,999"))+'</font></td>' //PEDIDOS EM ABERTO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((100-(TRAB3->TTVALLIQ/TRAB3->TTVALBRU)*100)  ,"@R 999%"))+'</font></td>' //DESC.MEDIO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTBONIF ,"@E 99,999,999"))+'</font></td>' //BONIFICA«OES
	_cBody += '		<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB3->TTBONIF*100)/TRAB3->TTFAT  ,"@R 999%"))+'</font></td>'  //% BONIF
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTDEVOL  ,"@E 99,999,999"))+'</font></td>' //DEVOLU«’ES
	_cBody += '		<td width="2%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB3->TTDEVOL*100)/TRAB3->TTFAT  ,"@R 999%"))+'</font></td>' //% DEVOL.
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB3->TTCPV/TRAB3->TTCPV2)*100  ,"@R 999%"))+'</font></td>      ' //CPV
	_cBody += '		<td width="5%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTCLICAD ,"@E 99,999"))+'</font></td>       ' //CLIENTES CADASTRADOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTCLIFAT  ,"@E 99,999"))+'</font></td>       ' //CLIENTES CAD. C/ FAT.
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB3->TTCLIFAT*100)/TRAB3->TTCLICAD  ,"@R 999%"))+'</font></td>         '  //% CLI CAD C/ FAT
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTCLIATI  ,"@E 99,999"))+'</font></td>       ' //CLIENTES ATIVOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTCLICR-TRAB3->TTCLIATI  ,"@E 99,999"))+'</font></td>       ' //CLIENTES INATIVOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTCLICR  ,"@E 99,999"))+'</font></td>  ' //TOTAL CLIENTES
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTPEDIDO  ,"@E 99,999"))+'</font></td>  ' //QTD ENTRADA PEDIDOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(0 ,"@E 99,999"))+'</font></td>  ' //QTD ENTR. PED VIA PALM
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTPEDFAT  ,"@E 99,999"))+'</font></td>  ' //QTD PED. FATURADOS
	_cBody += '		<td width="3%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform((TRAB3->TTPEDFAT*100)/TRAB3->TTPEDIDO ,"@R 999%"))+'</font></td>       ' //TOTAL QTD PEDIDOS
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTITENS/TRAB3->TTPEDIDO  ,"@E 999.99"))+'</font></td>       ' //MEDIA ITENS P/ PEDIDO
	_cBody += '		<td width="4%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB3->TTVALPED/TRAB3->TTPEDIDO ,"@E 999,999"))+'</font></td>   ' //VALOR MEDIO DOS PEDIDOS
	_cBody += '	</tr> '

	_TOTVALPED += TRAB3->TTVALPED
	_TOTFAT    += TRAB3->TTFAT
	_TOTPEDABE += TRAB3->TTPEDABE
	_TOTVALBRU += TRAB3->TTVALBRU
	_TOTVALLIQ += TRAB3->TTVALLIQ
	_TOTBONIF  += TRAB3->TTBONIF
	_TOTDEVOL  += TRAB3->TTDEVOL
	_TOTICMS   += TRAB3->TTICMS
	_TOTCPV    += TRAB3->TTCPV
	_TOTCPV2   += TRAB3->TTCPV2
	_TOTCLICAD += TRAB3->TTCLICAD
	_TOTCLIFAT += TRAB3->TTCLIFAT
	_TOTCLIATI += TRAB3->TTCLIATI
	_TOTCLICR  += TRAB3->TTCLICR
	_TOTPEDIDO += TRAB3->TTPEDIDO
	_TOTPEDFAT += TRAB3->TTPEDFAT
	_TOTITENS  += TRAB3->TTITENS
	_TOTQTDPED += TRAB3->TTQTDPED
	_TOTMETA   += nMetaSeg

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="13%" bgcolor="#cccccc" ><b><font face="Tahoma" size="1">T O T A L</font></b></td> '  //Estado
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED ,"@E 99,999,999"))+'</font></b></td>' //ENTR.PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTFAT ,"@E 99,999,999"))+'</font></b></td>'    //FATURADO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTMETA,"@E 99,999,999"))+'</font></b></td>'  //META
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTICMS,"@E 99,999,999"))+'</font></b></td>'  //SUBS TRIBUTARIA
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDABE ,"@E 99,999,999"))+'</font></b></td>' //PEDIDOS EM ABERTO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((100-(_TOTVALLIQ/_TOTVALBRU)*100)  ,"@R 999%"))+'</font></b></td>' //DESC.MEDIO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTBONIF ,"@E 99,999,999"))+'</font></b></td>' //BONIFICA«OES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTBONIF*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>'  //% BONIF
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTDEVOL  ,"@E 99,999,999"))+'</font></b></td>' //DEVOLU«’ES
_cBody += '		<td width="2%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTDEVOL*100)/_TOTFAT  ,"@R 999%"))+'</font></b></td>' //% DEVOL.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCPV/_TOTCPV2)*100  ,"@R 999%"))+'</font></b></td>      ' //CPV
_cBody += '		<td width="5%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICAD ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CADASTRADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIFAT  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES CAD. C/ FAT.
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTCLIFAT*100)/_TOTCLICAD  ,"@R 999%"))+'</font></b></td>         '  //% CLI CAD C/ FAT
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES ATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR-_TOTCLIATI  ,"@E 99,999"))+'</font></b></td>       ' //CLIENTES INATIVOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTCLICR  ,"@E 99,999"))+'</font></b></td>  ' //TOTAL CLIENTES
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDIDO  ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTRADA PEDIDOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(0 ,"@E 99,999"))+'</font></b></td>  ' //QTD ENTR. PED VIA PALM
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDFAT  ,"@E 99,999"))+'</font></b></td>  ' //QTD PED. FATURADOS
_cBody += '		<td width="3%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform((_TOTPEDFAT*100)/_TOTPEDIDO ,"@R 999%"))+'</font></b></td>       ' //TOTAL QTD PEDIDOS
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTITENS/_TOTPEDIDO  ,"@E 999.99"))+'</font></b></td>       ' //MEDIA ITENS P/ PEDIDO
_cBody += '		<td width="4%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTVALPED/_TOTPEDIDO ,"@E 999,999"))+'</font></b></td>   ' //VALOR MEDIO DOS PEDIDOS
_cBody += '	</tr> '
_cBody += '</table>'

_cBody += '<p><font face="Tahoma" size="2"><i>*Nos valores ref. a pedidos em aberto est„o sendo considerados os pedidos bloqueados na regra comercial e an·lise de crÈdito.</i></font></p>'
_cBody += '<p><font face="Tahoma" size="1"> </font></p>'
_cBody += '<p><font face="Tahoma" size="2"><i>Metas n„o informadas. Aguardando informaÁıes de vendedor por segmento/supervisor.</i></font></p>'
_cBody += '<p><font face="Tahoma" size="1"> </font></p>'
_cBody += '<p><font face="Tahoma" size="1">'+DtoC(Date())+' - '+Time()+'</font></p>'
_cBody += '</body> '
_cBody += '</html>'
 
cAssunto:= "Performance de Vendas - "+DtoC(dDataBase) 

/*
cTipMail:= "000010"
cQuery  := ""
cQuery  += "SELECT ZG.ZG_EMAIL "
cQuery  += "FROM "+RetSqlName("SZI")+" ZI (NOLOCK), "
cQuery  +=         RetSqlName("SZG")+" ZG (NOLOCK) "
cQuery  += "WHERE ZI.ZI_FILIAL = '"+xFilial("SZI")+"' AND ZI.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZI.ZI_TIPO = '"+cTipMail+"' AND ZI.ZI_RESPONS = ZG.ZG_CODIGO "
cQuery  += "  AND ZG.ZG_FILIAL = '"+xFilial("SZG")+"' AND ZG.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZG.ZG_ATIVO = 'S' "
cQuery  := ChangeQuery(cQuery)
TCQuery cQuery NEW ALIAS "SZGS" 

dbSelectArea("SZGS")
dbGoTop()
While !EOF()
	cEmail += Alltrim(SZGS->ZG_EMAIL)+";"
	dbSkip()
Enddo

*/
cEmail:= 'rodolfogaboardi@yahoo.vom.br'//SubStr(cEmail,1,Len(cEmail)-1) //tira o ultimo ';'

If !lSchedAux
	cEmail:= Iif(!Empty(mv_par01),AllTrim(mv_par01),cEmail)
EndIf

If !Empty(cEmail)
	//Envio do email
	U_SendMail(cEmail,cAssunto,_cBody,"",.f.)
EndIf	

//dbSelectArea("SZGS")
//dbCloseArea()

Return



Static Function BuscaMeta(nTipoMeta)
************************************
Local aAreaAtu:= GetArea()
Local nRet    := 0

/*
DbSelectArea("SZR")
DbSetOrder(1)
MsSeek(xFilial("SZR")+StrZero(Year(dDataDe),4)+StrZero(Month(dDataDe),2)+StrZero(nTipoMeta,6))
If Found()
	nRet:= SZR->ZR_VALMETA
EndIf	
/*
If nTipoMeta==1 //PROVISORIO!  QDO FOR VAREJO, SOMA A META DA INDUSTRIA
	MsSeek(xFilial("SZR")+StrZero(Year(dDataDe),4)+StrZero(Month(dDataDe),2)+"000004")
	If Found()
		nRet+= SZR->ZR_VALMETA
	EndIf	
EndIf	
*/
RestArea(aAreaAtu)
Return(nRet)


/*   ok  com alias



// *************************************
//        GERA QUERY POR SEGMENTOS 
// *************************************

cQuery:= "SELECT SEGMTO," 
cQuery+= "SUM(TOTVALPED) TTVALPED," 
cQuery+= "SUM(TOTVALBRU) TTVALBRU," 
cQuery+= "SUM(TOTVALLIQ) TTVALLIQ,"  
cQuery+= "SUM(TOTQTDPED) TTQTDPED," 
cQuery+= "SUM(TOTFAT) TTFAT," 
cQuery+= "SUM(TOTPEDABE) TTPEDABE," 
cQuery+= "SUM(TOTBONIF) TTBONIF," 
cQuery+= "SUM(TOTDEVOL) TTDEVOL," 
cQuery+= "SUM(TOTICMS) TTICMS," 
cQuery+= "SUM(TOTCPV) TTCPV," 
cQuery+= "SUM(TOTCPV2) TTCPV2," 
cQuery+= "SUM(TOTCLICAD) TTCLICAD," 
cQuery+= "SUM(TOTCLIFAT) TTCLIFAT," 
cQuery+= "SUM(TOTCLICR) TTCLICR," 
cQuery+= "SUM(TOTCLIATI) TTCLIATI," 
cQuery+= "SUM(TOTPEDIDO) TTPEDIDO," 
cQuery+= "SUM(TOTPEDPALM) TTPEDPALM,"  
cQuery+= "SUM(TOTPEDFAT) TTPEDFAT," 
cQuery+= "SUM(TOTITENS) TTITENS FROM (" 

//Entrada de pedidos 
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "SUM(SC6.C6_VALOR) TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "SUM(SC6.C6_QTDVEN) TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= "RIGHT JOIN SA3020 SA3 ON SA3.A3_COD=SC5.C5_VEND1 AND SA3.D_E_L_E_T_=' ' "
cQuery+= "RIGHT JOIN SA1020 SA1 ON SA1.A1_COD=SC5.C5_CLIENTE AND SA1.A1_LOJA=SC5.C5_LOJACLI AND SA1.D_E_L_E_T_=' ' "
cQuery+= "RIGHT JOIN ACY020 ACY ON ACY.ACY_GRPVEN=SA1.A1_GRPVEN AND ACY.D_E_L_E_T_=' ',SC6020 SC6,SF4020 SF4 "
cQuery+= "WHERE SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " AND SC5.C5_TIPO NOT IN ('D','B')"
cQuery+= " AND SC6.C6_FILIAL=SC5.C5_FILIAL"
cQuery+= " AND SC6.C6_NUM=SC5.C5_NUM"
cQuery+= " AND SC6.C6_CLI=SC5.C5_CLIENTE" 
cQuery+= " AND SC6.C6_LOJA=SC5.C5_LOJACLI" 
cQuery+= " AND (SC6.C6_BLQ<>'R' OR SC6.C6_QTDENT>0)"
cQuery+= " AND SF4.F4_CODIGO=SC6.C6_TES"
cQuery+= " AND SF4.F4_ESTOQUE='S'"
cQuery+= " AND SF4.F4_DUPLIC='S'"
cQuery+= " AND SF4.D_E_L_E_T_=' '" 
cQuery+= " AND SC6.D_E_L_E_T_=' '"
cQuery+= " AND SC5.D_E_L_E_T_=' '"
cQuery+= " AND SA3.A3_MSBLQL<>'1' "
cQuery+= "GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

// Faturados / Desconto Medio
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "SUM(SD2.D2_QUANT*SD2.D2_PRUNIT) TOTVALBRU,"  
cQuery+= "SUM(SD2.D2_QUANT*SD2.D2_PRCVEN) TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "SUM(SD2.D2_VALBRUT) TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "SUM(SD2.D2_ICMSRET) TOTICMS," 
cQuery+= "SUM(SD2.D2_CUSTO1) TOTCPV," 
cQuery+= "SUM(SD2.D2_TOTAL-SD2.D2_VALICM-SD2.D2_VALIMP5-SD2.D2_VALIMP6+SD2.D2_VALFRE) TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
//cQuery+= "FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4, "+RetSQLName("SB1")+" SB1 " 
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= "INNER JOIN SF2020 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SF4020 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= "INNER JOIN SA1020 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= "LEFT JOIN SA3020 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND D2_TP='PA'"
cQuery+= " AND D2_TIPO NOT IN ('B','D')"
cQuery+= " AND SD2.D_E_L_E_T_=''"
cQuery+= " AND SA3.A3_MSBLQL<>'1'"

cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Pedidos em Aberto
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE,"
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
cQuery+= " AND C5_FILIAL=C6_FILIAL" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= " AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= " AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe+1)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"'"
cQuery+= " AND SC5.C5_TIPO='N'"
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC6.C6_TES=SF4.F4_CODIGO"
cQuery+= " AND SF4.F4_DUPLIC='S'"
cQuery+= " AND SA3.A3_MSBLQL<>'1'"

cQuery+= " GROUP BY SA1.A1_GRPVEN" 

cQuery+= " UNION ALL " 

//BonificaÁıes
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "SUM(SD2.D2_TOTAL) TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
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
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN" 

//DevoluÁıes
cQuery+= " UNION ALL " 
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED, "  
cQuery+= "0 TOTVALBRU, "  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED, " 
cQuery+= "0 TOTFAT, " 
cQuery+= "0 TOTPEDABE, " 
cQuery+= "0 TOTBONIF, " 
cQuery+= "SUM((D1_TOTAL+(CASE WHEN F4_INCSOL='S' THEN D1_ICMSRET ELSE 0 END)+D1_VALIPI+D1_VALFRE-D1_VALDESC+D1_DESPESA)) TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
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
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN" 

cQuery+= " UNION ALL " 

//Clientes Cadastrados
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS "            
cQuery+= "FROM "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_X_DINC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'"
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Clientes Cadastrados com Faturamento
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' "                 
cQuery+= " AND A1_VEND = A3_COD" 
cQuery+= " AND A1_X_DINC BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Carteira Clientes Cadastrados = TOTAL
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM,"         
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_GRPVEN<>'000000'"
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Carteira Clientes 4 meses Cadastrados = ATIVOS
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "COUNT(DISTINCT(SA1.A1_COD+SA1.A1_LOJA)) TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND A1_VEND=A3_COD" 
cQuery+= " AND A1_ULTCOM BETWEEN '"+DtoS(dDataDe4M)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND A1_GRPVEN<>'000000'"
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL "  

//Num pedidos (Entrada)
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "COUNT(SC6.C6_NUM) TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA"         
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD" 
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Num pedidos (via Palm)
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDPALM," 
cQuery+= "0 TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' " 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD"       
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SC5.C5_USRIMPL='MOST'" 
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+= "UNION ALL " 

//Num pedidos (Faturados)
cQuery+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000010' THEN '2-COM. ATACADO' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000012' THEN '7-HOME' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN='000030' THEN '3-PRIVATE LABEL' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000023','000014') THEN '5-CALCADOS' ELSE"
cQuery+= "(CASE WHEN SA1.A1_GRPVEN IN ('000040','000050') THEN '6-EXPORTACAO' ELSE '1-COM. VAREJO' END)END)END)END)END)END)END) SEGMTO,"
cQuery+= "0 TOTVALPED,"  
cQuery+= "0 TOTVALBRU,"  
cQuery+= "0 TOTVALLIQ,"  
cQuery+= "0 TOTQTDPED," 
cQuery+= "0 TOTFAT," 
cQuery+= "0 TOTPEDABE," 
cQuery+= "0 TOTBONIF," 
cQuery+= "0 TOTDEVOL," 
cQuery+= "0 TOTICMS," 
cQuery+= "0 TOTCPV," 
cQuery+= "0 TOTCPV2," 
cQuery+= "0 TOTCLICAD," 
cQuery+= "0 TOTCLIFAT," 
cQuery+= "0 TOTCLICR," 
cQuery+= "0 TOTCLIATI," 
cQuery+= "0 TOTPEDIDO," 
cQuery+= "0 TOTPEDPALM," 
cQuery+= "COUNT(DISTINCT(SC5.C5_NUM)) TOTPEDFAT," 
cQuery+= "0 TOTITENS " 
cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD" 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD" 
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND C6_NOTA<>' '" 
cQuery+= " AND SC5.C5_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
cQuery+= " AND SA3.A3_MSBLQL<>'1'"
cQuery+= " GROUP BY SA1.A1_GRPVEN " 

cQuery+=") AGRUPA" 

cQuery+= " GROUP BY SEGMTO"
cQuery+= " ORDER BY SEGMTO"

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

*/
