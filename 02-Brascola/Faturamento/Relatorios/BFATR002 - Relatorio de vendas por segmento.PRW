#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BFATR002         AUTOR:                        DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Relatorio de faturamento por segmento de mercado. Este relatorio
é enviado diretamente no email informado no parametro, nao gerando na tela.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFATR002() //para ser chamado via schedule para filial Joinvile
*************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Faturamento Bruto por Segmento"
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(3)  // Nao usar Licensa
PREPARE ENVIRONMENT EMPRESA "02" FILIAL "01" FUNNAME "U_RELFATBRU()"  TABLES "SC5","SC6","SF2","SD2","SA3","SA1"

Processa({ ||U_ProcFatBru(.t.)}, "Faturamento Bruto por Segmento",,.t.)

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)



User Function RFATBRU() //para ser chamado via menu
***********************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Faturamento Bruto por Segmento"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cPerg     := U_CriaPerg("FATBRU")
Local aRegs     := {}

//          Grupo/Ordem/Pergunta/                  Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03              /Cnt03/Var04/Def04             /Cnt04/Var05/Def05    /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture
aAdd(aRegs,{cPerg,"01" ,"Email para envio:" ,"","","mv_ch1","C" ,40     ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""         ,"","" ,""   ,""   ,""          ,"","" ,""   ,""   ,"","","" ,""    ,""   ,""    ,""     ,""   ,""})
 
lValidPerg(aRegs)

If Pergunte(cPerg,.T.)
	Processa({ ||U_ProcFatBru(.f.)}, "Faturamento Bruto por Segmento",,.t.)
EndIf

RestArea(aAreaAtu)

Return(Nil)


 
User Function ProcFatBru(lSchedAx)
**********************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

Private lSchedAux:= lSchedAx

ProcRegua(2) 

dDataDe    := FirstDay(dDataBase)//+1  //D+1
dDataAte   := dDataBase
dDataDeAno := CtoD("01/01/"+StrZero(Year(dDatabase),4))+1  //D+1
dDataAteAno:= dDataBase
dDataFimAno:= CtoD("31/12/"+StrZero(Year(dDatabase),4))+1  //D+1

// *************************************
//        GERA QUERY POR SEGMENTOS 
// *************************************

_cSql:= "SELECT SEGMTO," 
_cSql+= " SUM(TOTFAT) TTFAT ," 
_cSql+= " SUM(TOTPEDABE) TTPEDABE, " 
_cSql+= " SUM(TOTABEACU) TTABEACU, "
_cSql+= " SUM(TOTFATACU) TTFATACU FROM (" 




// Faturado Mes Actual
_cSql+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029')          THEN '1-COM. VAREJO  ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000010'                                 THEN '2-COM. ATACADO ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000012'                                 THEN '7-HOME '         ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000030'                                 THEN '3-PRIVATE LABEL' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA    ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000023','000014','000056')                   THEN '5-CALCADOS     ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000040','000050')                   THEN '6-EXPORTACAO   ' ELSE '1-COM. VAREJO  ' END) END) END) END) END)END)END) SEGMTO, "
_cSql+= "       SUM(SD2.D2_VALBRUT) TOTFAT, " 
_cSql+= "       0 TOTPEDABE, "
_cSql+= "       0 TOTABEACU, "
_cSql+= "       0 TOTFATACU "

_cSql+= "FROM "+RetSQLName("SD2")+" SD2 "
_cSql+= "INNER JOIN SF2020 SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
_cSql+= "INNER JOIN SF4020 SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
_cSql+= "INNER JOIN SA1020 SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
_cSql+= "LEFT JOIN SA3020 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
_cSql+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"'" 
_cSql+= "  AND D2_TP='PA'"
_cSql+= "  AND D2_TIPO NOT IN ('B','D')"
_cSql+= "  AND SD2.D_E_L_E_T_=''"
_cSql+= " GROUP BY SA1.A1_GRPVEN " 

_cSql+= "UNION ALL " 

//Pedidos em Aberto
_cSql+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO  ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000010'                                 THEN '2-COM. ATACADO ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000012'                                 THEN '7-HOME '         ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000030'                                 THEN '3-PRIVATE LABEL' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA    ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000023','000014','000056')                   THEN '5-CALCADOS     ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000040','000050')                   THEN '6-EXPORTACAO   ' ELSE '1-COM. VAREJO  ' END) END) END) END) END) END )END) SEGMTO, "
_cSql+= "       0 TOTFAT," 
_cSql+= "       SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTPEDABE, "
_cSql+= "       0 TOTABEACU, "
_cSql+= "       0 TOTFATACU "
_cSql+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 , "+RetSQLName("SF4")+" SF4  " 
_cSql+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' " 
_cSql+= "  AND C5_FILIAL=C6_FILIAL " 
_cSql+= "  AND C5_NUM=C6_NUM " 
_cSql+= "  AND C5_CLIENTE=A1_COD " 
_cSql+= "  AND C5_LOJACLI=A1_LOJA " 
_cSql+= "  AND SC5.C5_VEND1=SA3.A3_COD "     
_cSql+= "  AND SC6.C6_QTDVEN>SC6.C6_QTDENT " 
_cSql+= "  AND SC6.C6_ENTREG BETWEEN '20090101' AND '"+DtoS(LastDay(dDataAte)+1)+"' "
//_cSql+= "  AND SC6.C6_ENTREG BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(LastDay(dDataAte)+1)+"' "
_cSql+= "  AND SC5.C5_TIPO='N' "
_cSql+= "  AND C6_BLQ<>'R' " 
_cSql+= "  AND SC6.C6_TES = SF4.F4_CODIGO "     
_cSql+= "  AND SF4.F4_DUPLIC = 'S' " 
_cSql+= "GROUP BY SA1.A1_GRPVEN " 
_cSql+= "UNION ALL " 

//Faturamento Acumulado (Anual)
_cSql+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO  ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000010'                                 THEN '2-COM. ATACADO ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000012'                                 THEN '7-HOME '         ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000030'                                 THEN '3-PRIVATE LABEL' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA    ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000023','000014','000056')                   THEN '5-CALCADOS     ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000040','000050')                   THEN '6-EXPORTACAO   ' ELSE '1-COM. VAREJO  ' END) END) END) END) END)END)END) SEGMTO, "
_cSql+= "       0 TOTFAT, " 
_cSql+= "       0 TOTPEDABE, "
_cSql+= "       0 TOTABEACU, "
_cSql+= "       SUM(SD2.D2_VALBRUT) TOTFATACU "
_cSql+= "FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3,"+RetSQLName("SF4")+" SF4, "+RetSQLName("SB1")+" SB1 " 
_cSql+= "WHERE SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SD2.D_E_L_E_T_='' AND SF4.D_E_L_E_T_='' AND SF2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''" 
_cSql+= "  AND F2_CLIENTE=A1_COD" 
_cSql+= "  AND F2_LOJA=A1_LOJA" 
_cSql+= "  AND SF2.F2_VEND1=SA3.A3_COD" 
_cSql+= "  AND SF4.F4_CODIGO=SD2.D2_TES" 
_cSql+= "  AND SF4.F4_DUPLIC='S'" 
_cSql+= "  AND SF2.F2_EMISSAO BETWEEN '"+DtoS(dDataDeAno)+"' AND '"+DtoS(dDataAteAno)+"'" 
_cSql+= "  AND SF2.F2_TIPO NOT IN ('D','B') "
_cSql+= "  AND SD2.D2_FILIAL=SF2.F2_FILIAL "
_cSql+= "  AND SD2.D2_DOC=SF2.F2_DOC "
_cSql+= "  AND SD2.D2_SERIE=SF2.F2_SERIE "
_cSql+= "  AND SD2.D2_TP='PA' "
_cSql+= "  AND SB1.B1_COD=SD2.D2_COD "
_cSql+= "GROUP BY SA1.A1_GRPVEN " 

_cSql+= "UNION ALL " 

//Pedidos em Aberto Acumulado
_cSql+= "SELECT (CASE WHEN SA1.A1_GRPVEN IN ('000011','000013','000029') THEN '1-COM. VAREJO  ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000010'                                 THEN '2-COM. ATACADO ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000012'                                 THEN '7-HOME '         ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN='000030'                                 THEN '3-PRIVATE LABEL' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000015','000020','000021','000022','000024','000025','000026','000027','000028','000052','000053') THEN '4-INDUSTRIA    ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000023','000014','000056')                   THEN '5-CALCADOS     ' ELSE"
_cSql+= "       (CASE WHEN SA1.A1_GRPVEN IN ('000040','000050')                   THEN '6-EXPORTACAO   ' ELSE '1-COM. VAREJO  ' END) END) END) END) END)END)END) SEGMTO, "
_cSql+= "       0 TOTFAT," 
_cSql+= "       0 TOTPEDABE, "
_cSql+= "       SUM((SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN) TOTABEACU, "
_cSql+= "       0 TOTFATACU "
_cSql+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 " 
_cSql+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_=''" 
_cSql+= "  AND C5_FILIAL=C6_FILIAL " 
_cSql+= "  AND C5_NUM=C6_NUM " 
_cSql+= "  AND C5_CLIENTE=A1_COD " 
_cSql+= "  AND C5_LOJACLI=A1_LOJA " 
_cSql+= "  AND SC5.C5_VEND1=SA3.A3_COD "     
_cSql+= "  AND SC6.C6_QTDVEN>SC6.C6_QTDENT " 

_cSql+= "  AND SC6.C6_ENTREG BETWEEN '20060101' AND '20491231' "      // pega tudo em aberto no ano da database'"+DtoS(dDataDeAno)+"'
//_cSql+= "  AND SC6.C6_ENTREG BETWEEN '2000101' AND '20491231' " //pega somente mes da database'"+DtoS(LastDay(dDataAte)+1)+"' 

_cSql+= "  AND SC5.C5_TIPO='N' "
_cSql+= "  AND C6_BLQ<>'R' " 
_cSql+= "GROUP BY SA1.A1_GRPVEN " 

_cSql+=") AGRUPA "  
_cSql+= "GROUP BY SEGMTO "
_cSql+= "ORDER BY SEGMTO "

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQuery _cSql NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

If !Eof()
	EnvMailFatB() 
EndIf	

dbSelectArea("TRAB")
dbCloseArea()


Return(.T.)


 
Static Function EnvMailFatB() 
*****************************
Local _cBody     := ""
Local cAssunto   := ""
Local cAnexo     := ""
Local cEmail     := ""
Local _TOTPREV   := 0
Local _TOTFAT    := 0
Local _TOTPEDABE := 0
Local _TOTPOTENC := 0
Local _TOTSALDO  := 0
Local _TOTAPREV  := 0
Local _TOTAFAT   := 0
Local _TOTAPEDABE:= 0
Local _TOTAPOTENC:= 0
Local _TOTASALDO := 0
Local nContMeta  := 0
Local cPLin      := Chr(13)+Chr(10)
Local cMesAux    := {"Janeiro","Fevereiro","Março","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

_cBody := "<html>"
_cBody += "<head>"
_cBody += '<meta http-equiv="Content-Language" content="pt-br">'
_cBody += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
_cBody += "<title>Nova pagina 1</title>"
_cBody += "</head>"
_cBody += "<body>"
_cBody += '<p align="center"><font face="Tahoma" size="2"><b>FATURAMENTO BRUTO POR SEGMENTO - '+cMesAux[Month(dDataDe)]+'/'+Alltrim(Str(Year(dDataDe)))+'</b></font></p>'
_cBody += '<p align="center"><font face="Tahoma" size="2">Referência: '+DtoC(dDataAte)+'</font></p> '

_cBody += '<table border="1" width="100%">  '
_cBody += '	<tr>'
_cBody += '		<td rowspan="2" bgcolor="#CCFFCC"><p align="center"><b><font face="Tahoma" size="1">Segmento</font></b></td> '
_cBody += '		<td colspan="5" bgcolor="#FFFF99"><p align="center"><b><font face="Tahoma" size="1">'+Upper(cMesAux[Month(dDataDe)])+'/'+Alltrim(Str(Year(dDataDe)))+'</font></b></td>  '
_cBody += '		<td colspan="5" bgcolor="#FFFF99"><p align="center"><b><font face="Tahoma" size="1">ACUMULADO '+Alltrim(Str(Year(dDataDe)))+'</font></b></td>'
_cBody += '	</tr>'
_cBody += '	<tr> '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Previsto </b>(a)</font></td>   '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Realizado </b>(b)</font></td>  '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Em Aberto </b>(c)</font></td>  '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Potencial </b>(b+c)</font></td>'
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Saldo </b>((b+c)-a)</font></td>'
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Previsto </b>(a)</font></td>   '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Realizado </b>(b)</font></td>  '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Em Aberto </b>(c)</font></td>  '
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Potencial </b>(b+c)</font></td>'
_cBody += '		<td bgcolor="#FFFFCC"><p align="center"><font face="Tahoma" size="1"><b>Saldo </b>((b+c)-a)</font></td>'
_cBody += '	</tr> '

DbSelectArea("TRAB")
DbGoTop()

While !Eof()
	If nContMeta==2 //pula 3- PRIVATE LABEL  Industria !PROVISORIO!!!
		nContMeta++
	EndIf
	
	nMetaSeg  := BuscaMeta(1,++nContMeta)
	nMetaSegAc:= BuscaMeta(2,nContMeta)
	
	_cBody += '	<tr>'
	_cBody += '		<td><font face="Tahoma" size="1">'+SubStr(TRAB->SEGMTO,3,13)+'</font></td>'
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMetaSeg                      ,"@E 999,999,999"))+'</font></td>' //PREVISTO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFAT                   ,"@E 999,999,999"))+'</font></td>' //REALIZADO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTPEDABE                ,"@E 999,999,999"))+'</font></td>' //EM ABERTO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFAT+TRAB->TTPEDABE    ,"@E 999,999,999"))+'</font></td>' //POTENCIAL
	_cBody += '		<td align="right"><font face="Tahoma" size="1"'+Iif(((TRAB->TTFAT+TRAB->TTPEDABE)-nMetaSeg)<0,' color="#FF0000"','')+'>'+Alltrim(Transform((TRAB->TTFAT+TRAB->TTPEDABE)-nMetaSeg ,"@E 999,999,999"))+'</font></td>' //SALDO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(nMetaSegAc                    ,"@E 999,999,999"))+'</font></td>' //PREVISTO ACUMULADO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFATACU                ,"@E 999,999,999"))+'</font></td>' //REALIZADO ACUMULADO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTABEACU                ,"@E 999,999,999"))+'</font></td>' //EM ABERTO ACUMULADO
	_cBody += '		<td align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRAB->TTFATACU+TRAB->TTABEACU ,"@E 999,999,999"))+'</font></td>' //POTENCIAL ACUMULADO
	_cBody += '		<td align="right"><font face="Tahoma" size="1"'+Iif(((TRAB->TTFATACU+TRAB->TTABEACU)-nMetaSegAc)<0,' color="#FF0000"','')+'>'+Alltrim(Transform((TRAB->TTFATACU+TRAB->TTABEACU)-nMetaSegAc ,"@E 999,999,999"))+'</font></td>' //SALDO ACUMULADO
	_cBody += '	</tr> '

	_TOTPREV   += nMetaSeg
	_TOTFAT    += TRAB->TTFAT
	_TOTPEDABE += TRAB->TTPEDABE
	_TOTPOTENC += TRAB->TTFAT+TRAB->TTPEDABE
	_TOTSALDO  += (TRAB->TTFAT+TRAB->TTPEDABE)-nMetaSeg
	_TOTAPREV  += nMetaSegAc
	_TOTAFAT   += TRAB->TTFATACU
	_TOTAPEDABE+= TRAB->TTABEACU
	_TOTAPOTENC+= TRAB->TTFATACU+TRAB->TTABEACU
	_TOTASALDO += (TRAB->TTFATACU+TRAB->TTABEACU)-nMetaSegAc

	DbSelectArea("TRAB")
	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">Total Global</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPREV   ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTFAT    ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPEDABE ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTPOTENC ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1"'+Iif(_TOTSALDO<0,' color="#FF0000"','')+'>'+Alltrim(Transform(_TOTSALDO  ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTAPREV  ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTAFAT   ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTAPEDABE,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1">'+Alltrim(Transform(_TOTAPOTENC,"@E 999,999,999"))+'</font></b></td>'
_cBody += '		<td align="right" bgcolor="#CCCCCC"><b><font face="Tahoma" size="1"'+Iif(_TOTASALDO<0,' color="#FF0000"','')+'>'+Alltrim(Transform(_TOTASALDO ,"@E 999,999,999"))+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><i><font face="Tahoma" size="1">* Nos valores ref. a pedidos em aberto (c) estão sendo considerados os pedidos bloqueados na regra comercial e análise de crédito.</font></i></p>'
_cBody += '<p>&nbsp;</p>'
_cBody += '<p><font face="Tahoma" size="1">Gerado pelo sistema Microsiga Protheus - Atualizado em '+DtoC(dDataBase)+' - '+SubStr(Time(),1,5)+'</font></p>'
_cBody += '</body>
_cBody += '</html>'
 
cAssunto:= "Faturamento Bruto por Segmento - "+DtoC(dDataBase) 

cTipMail:= "000011"
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

cEmail:= SubStr(cEmail,1,Len(cEmail)-1) //tira o ultimo ';'

If !lSchedAux
	cEmail:= Iif(!Empty(mv_par01),AllTrim(mv_par01),cEmail)
EndIf	

If !Empty(cEmail)
	//Envio do email
	U_SendMail(cEmail,cAssunto,_cBody,"",.f.)
EndIf	

dbSelectArea("SZGS")
dbCloseArea()

Return



Static Function BuscaMeta(nTipoBusca,nTipoMeta)
**********************************************
Local aAreaAtu:= GetArea()
Local cQry1   := ""
Local nRet    := 0

cQry1 := " SELECT SUM(ZR_VALMETA) AS VRMETA "
cQry1 += " FROM "+RetSQLName("SZR")+" SZR "
cQry1 += " WHERE SZR.D_E_L_E_T_ = '' "
cQry1 += " AND ZR_FILIAL = '"+xFilial("SZR")+"' "

//cQry1 += " AND ZR_CODSEG = '"+StrZero(nTipoMeta,6)+"' "
//If nTipoMeta==1 //provisorio
//	cQry1 += " AND ZR_CODSEG IN ('000001','000004') "
//Else
	cQry1 += " AND ZR_CODSEG = '"+StrZero(nTipoMeta,6)+"' "
//EndIf
	
cQry1 += " AND ZR_ANO = '"+StrZero(Year(dDataDe),4)+"' "
If nTipoBusca==1
	cQry1 += " AND ZR_MES = '"+StrZero(Month(dDataDe),2)+"' "  //mes atual
Else
	cQry1 += " AND ZR_MES <= '"+StrZero(Month(dDataDe),2)+"' " //acumulado ate o mes atual
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry1),"TRB1",.F.,.T.)
dbSelectArea("TRB1")
dbGoTop()
nRet:= TRB1->VRMETA

dbCloseArea()
RestArea(aAreaAtu)

Return(nRet)