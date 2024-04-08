#INCLUDE "RWMAKE.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"                      
#INCLUDE "Font.ch"
  
/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥FunáÖo    ≥ RELATEND ≥ Autor ≥ Thiago (Onsten)       ≥ Data ≥ 09/06/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Rel. de Atendimento Especial enviado por email             ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Especifico Brascola                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function RELATEND()
************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Atendimento Especial"
Local lJob		:= .t.

Private aRegs   := {}
Private cPerg   := U_CriaPerg("ATEESP")

ValPergunte(cPerg)

If !(Pergunte(cPerg,.t.)) .Or. LastKey()==27 
	Return .F. 
Endif 

Processa({ ||U_ProcAtend()}, "Atendimento Especial",,.t.)

RestArea(aAreaAtu)

Return(Nil)


 
User Function ProcAtend()
*************************
Local cQry1   := ""           
Local cQry2   := ""
Local cQry3   := ""           
Local cQry4   := ""
Local cQry5   := ""           
Local cQry6   := ""
Local cQry6V  := ""
Local cQry7   := ""           
Local cQry7V  := ""           
Local cQry8   := ""
Local cQry9   := ""           
Local cQryA   := ""
Local cQryB   := ""           
Local dDataDe := mv_par01
Local dDataAte:= mv_par02

ProcRegua(11) 

//**************************************************************************************************************************************************************
//1 - TOTAL ||||

_cBody += '<table border="1" width="40%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="60%" align="center"><b><font face="Tahoma" size="2">TOTAL GERAL</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="25%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

_cBody += '	<tr> '
_cBody += '		<td width="60%"><font face="Tahoma" size="2">Chamados Fechados </font></td> '                                         
_cBody += '		<td width="25%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAF ,"@E 99,999,999"))+'</font></td>' 
_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((_TOTALAF*100)/(_TOTALAF+_TOTALAP) ,"@R 9999%"))+'</font></td>' 
_cBody += '	</tr> '
_cBody += '	<tr> '
_cBody += '		<td width="60%"><font face="Tahoma" size="2">Chamados Pendentes </font></td> '                                         
_cBody += '		<td width="25%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAP ,"@E 99,999,999"))+'</font></td>' 
_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((_TOTALAP*100)/(_TOTALAF+_TOTALAP) ,"@R 9999%"))+'</font></td>' 
_cBody += '	</tr> '

_cBody += '	<tr>'
_cBody += '		<td width="60%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="25%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAF+_TOTALAP ,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '	</tr> '

_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



_cBody += '<p><font color="#FFFFFF">.</font></p> '
_cBody += '<p><font face="Tahoma" size="1">'+DtoC(Date())+' - '+Time()+'</font></p>'
_cBody += '</body> '
_cBody += '</html>'
 
cAssunto:= "Atendimento Especial - "+cMesAux[Month(mv_par01)]+'/'+Alltrim(Str(Year(mv_par01)))


cTipMail:= "000013"
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//2 - MOTIVO DE ABERTURA CHAMADO |||||    

IncProc("Processando Atendimentos... 1", "Aguarde...") 

cQry1:= "SELECT QI2.QI2_CODEFE AS COD_EFE, QI0.QI0_DESC AS DESCEFE, COUNT(*) AS TOTAL "
cQry1+= " FROM "+RetSQLName("QI2")+" QI2 ,"+RetSQLName("QI0")+" QI0 "
cQry1+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQry1+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry1+= "   AND QI2_CODEFE<>'' "
cQry1+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry1+= "   AND QI2_STATUS='3' "
cQry1+= "   AND QI0_TIPO='2' "
cQry1+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry1+= " GROUP BY QI2_CODEFE, QI0_DESC "
cQry1+= " ORDER BY TOTAL DESC "
If Select("TRB1") > 0 
	TRB1->(dbCloseArea())
EndIf      
TCQUERY cQry1 NEW ALIAS "TRB1"
dbSelectArea("TRB1")
dbGotop() 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//3 - DEPARTAMENTO |||||

IncProc("Processando Atendimentos... 10", "Aguarde...") 

cQryA:= "SELECT DEPTO, "
cQryA+= " SUM(TOTAL) AS TOTAL, "
cQryA+= " SUM(PENDENTE) AS PENDENTE, "
cQryA+= " SUM(FECHADOS) AS FECHADOS "
cQryA+= " FROM ( "
cQryA+= "       SELECT QI2.QI2_X_DEPT AS DEPTO, "
cQryA+= "          COUNT(*) AS TOTAL, "
cQryA+= "          0 AS PENDENTE, "
cQryA+= "          0 AS FECHADOS "
cQryA+= "       FROM QI2020 QI2 ,QI0020 QI0 "
cQryA+= "       WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQryA+= "         AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryA+= "         AND QI2_CODEFE<>'' "
cQryA+= "         AND QI2_CODEFE=QI0_CODIGO "
cQryA+= "         AND QI0_TIPO='2' "
cQryA+= "         AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryA+= "         AND QI2_STATUS='3' " 
cQryA+= "       GROUP BY QI2.QI2_X_DEPT "

cQryA+= "      UNION ALL "

cQryA+= "       SELECT QI2.QI2_X_DEPT AS DEPTO, "
cQryA+= "          0 AS TOTAL, "
cQryA+= "          COUNT(*) AS PENDENTE, "
cQryA+= "          0 AS FECHADOS "
cQryA+= "       FROM QI2020 QI2 ,QI0020 QI0 "
cQryA+= "       WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQryA+= "         AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryA+= "         AND QI2_CODEFE<>'' "
cQryA+= "         AND QI2_CODEFE=QI0_CODIGO "
cQryA+= "         AND QI0_TIPO='2' "
cQryA+= "         AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryA+= "         AND QI2_STATUS='3' " 
cQryA+= "         AND QI2_CONREA='' " //Pendente
cQryA+= "       GROUP BY QI2.QI2_X_DEPT "

cQryA+= "      UNION ALL "

cQryA+= "       SELECT QI2.QI2_X_DEPT AS DEPTO, "
cQryA+= "          0 AS TOTAL, "
cQryA+= "          0 AS PENDENTE, "
cQryA+= "          COUNT(*) AS FECHADOS "
cQryA+= "       FROM QI2020 QI2 ,QI0020 QI0 "
cQryA+= "       WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQryA+= "         AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryA+= "         AND QI2_CODEFE<>'' "
cQryA+= "         AND QI2_CODEFE=QI0_CODIGO "
cQryA+= "         AND QI0_TIPO='2' "
cQryA+= "         AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryA+= "         AND QI2_STATUS='3' " 
cQryA+= "         AND QI2_CONREA<>'' " //Fechados
cQryA+= "       GROUP BY QI2.QI2_X_DEPT "

cQryA+= "       ) AGRUPA "  
cQryA+= " GROUP BY DEPTO "
cQryA+= " ORDER BY TOTAL DESC " //" ORDER BY DEPTO "
If Select("TRBA") > 0 
	TRBA->(dbCloseArea())
EndIf      
TCQUERY cQryA NEW ALIAS "TRBA"

dbSelectArea("TRBA")
dbGotop()


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//4 - MOTIVO DE ABERTURA CHAAMDO - ATRASO |||||//TRB1 ||||
 
_cBody += '<table border="1" width="50%">                                                                    '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Motivo de Abertura do Chamado</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB1")
DbGoTop()
While !Eof()
	_TOTAL1+= TRB1->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRB1->DESCEFE+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB1->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRB1->TOTAL*100)/_TOTAL1 ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL1 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//5 - MOTIVO ENCERRAMENTO  |||||

IncProc("Processando Atendimentos... 9", "Aguarde...") 

cQry9:= "SELECT SUC.UC_CODENCE AS COD_ENCER, SUN.UN_DESC AS DESCENC, COUNT(*) AS TOTAL "
cQry9+= " FROM "+RetSQLName("QI2")+" QI2, "
cQry9+= "      "+RetSQLName("QI0")+" QI0, "
cQry9+= "      "+RetSQLName("SUD")+" SUD, "
cQry9+= "      "+RetSQLName("SUC")+" SUC, "
cQry9+= "      "+RetSQLName("SUN")+" SUN "
cQry9+= " WHERE QI2.D_E_L_E_T_='' "
cQry9+= "   AND QI0.D_E_L_E_T_='' "
cQry9+= "   AND SUD.D_E_L_E_T_='' "
cQry9+= "   AND SUC.D_E_L_E_T_='' "
cQry9+= "   AND SUN.D_E_L_E_T_='' "
cQry9+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry9+= "   AND QI2_CODEFE<>'' "
cQry9+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry9+= "   AND QI2_FNC=SUD.UD_CODFNC "
cQry9+= "   AND SUD.UD_CODIGO=SUC.UC_CODIGO "
cQry9+= "   AND SUD.UD_CODIGO=SUC.UC_CODIGO "
cQry9+= "   AND SUC.UC_CODENCE=SUN.UN_ENCERR "
cQry9+= "   AND QI2_STATUS='3' "
cQry9+= "   AND QI0_TIPO='2' "
cQry9+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry9+= " GROUP BY SUC.UC_CODENCE, SUN.UN_DESC "
cQry9+= " ORDER BY TOTAL DESC "
If Select("TRB9") > 0 
	TRB9->(dbCloseArea())
EndIf      
TCQUERY cQry9 NEW ALIAS "TRB9"

dbSelectArea("TRB9")
dbGotop()  

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//6 - CAUSA DOS PEDIDOS EM DESACORDO |||||

cQryC:= "SELECT QI2.QI2_CODCAU AS COD_CAU, QI0.QI0_DESC AS DESCCAU, COUNT(*) AS TOTAL "
cQryC+= " FROM "+RetSQLName("QI2")+" QI2 ,"+RetSQLName("QI0")+" QI0 "
cQryC+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQryC+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryC+= "   AND QI2_CODEFE='008' " // pedido em desacordo com o solicitante
cQryC+= "   AND QI2_CODCAU=QI0_CODIGO "
cQryC+= "   AND QI2_STATUS='3' "
cQryC+= "   AND QI0_TIPO='1' "
cQryC+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryC+= " GROUP BY QI2_CODCAU, QI0_DESC "
cQryC+= " ORDER BY TOTAL DESC "
If Select("TRBC") > 0 
	TRBC->(dbCloseArea())
EndIf      
TCQUERY cQryC NEW ALIAS "TRBC"
dbSelectArea("TRBC")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//7 - ATRASO NA ENTREGA |||||

IncProc("Processando Atendimentos... 2", "Aguarde...") 

cQry2:= "SELECT QI2.QI2_X_TRAN AS COD_TRANSP, SA4.A4_NOME AS NOMETRANSP, COUNT(*) AS TOTAL"
cQry2+= " FROM QI2020 QI2, SA4020 SA4"
cQry2+= " WHERE QI2.D_E_L_E_T_='' AND SA4.D_E_L_E_T_='' "
cQry2+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
//cQry2+= "   AND QI2_CODEFE='001' "
cQry2+= "   AND QI2_CODEFE IN ('001','027','028') "
cQry2+= "   AND QI2_X_TRAN*=SA4.A4_COD "
cQry2+= "   AND QI2_STATUS='3' "
cQry2+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry2+= " GROUP BY QI2_X_TRAN, SA4.A4_NOME "
cQry2+= " ORDER BY TOTAL DESC "
If Select("TRB2") > 0 
	TRB2->(dbCloseArea())
EndIf      
TCQUERY cQry2 NEW ALIAS "TRB2"

dbSelectArea("TRB2")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//8 - ATRASO ENTREGA POR REGIAO |||||

IncProc("Processando Atendimentos... 3", "Aguarde...") 

cQry3:= "SELECT SA1.A1_EST AS ESTADO, COUNT(*) AS TOTAL"
cQry3+= " FROM QI2020 QI2, SA1020 SA1"
cQry3+= " WHERE QI2.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' "
cQry3+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
//cQry3+= "   AND QI2_CODEFE='001' "
cQry3+= "   AND QI2_CODEFE IN ('001','027','028') "
cQry3+= "   AND QI2_CODCLI=SA1.A1_COD "
cQry3+= "   AND QI2_LOJCLI=SA1.A1_LOJA "
cQry3+= "   AND QI2_STATUS='3' "
cQry3+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry3+= " GROUP BY A1_EST "
cQry3+= " ORDER BY TOTAL DESC "
If Select("TRB3") > 0 
	TRB3->(dbCloseArea())
EndIf      
TCQUERY cQry3 NEW ALIAS "TRB3"

dbSelectArea("TRB3")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//9 - FAMILIA - PRODUTO FORA ESPECIFICADO |||||

IncProc("Processando Atendimentos... 5", "Aguarde...") 
 
cQry5:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry5+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry5+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD,"
cQry5+= "       QI2.QI2_LOTE AS LOTE, "
cQry5+= "       QI2.QI2_X_LVLD AS DTVLOTE, "
cQry5+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry5+= "       COUNT(*) AS TOTAL "
cQry5+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry5+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry5+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry5+= "   AND QI2_CODEFE<>'' "
cQry5+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry5+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry5+= "   AND QI2_STATUS='3' "
cQry5+= "   AND QI0_TIPO='2' "
cQry5+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry5+= "   AND QI2_CODEFE = '020' " //PRODUTO FORA DAS ESPECIFICACOES 
cQry5+= "  GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
cQry5+= "  ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "

If Select("TRB5") > 0 
	TRB5->(dbCloseArea())
EndIf      
TCQUERY cQry5 NEW ALIAS "TRB5"

dbSelectArea("TRB5")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//10 - FAMILIA - EMBALAGEM COM VAZAMENTO ||||| 

IncProc("Processando Atendimentos... 6", "Aguarde...") 

cQry6:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry6+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry6+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD, "
cQry6+= "       QI2.QI2_LOTE AS LOTE, "
cQry6+= "       QI2.QI2_X_LVLD AS DTVLOTE, "
cQry6+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry6+= "       COUNT(*) AS TOTAL "
cQry6+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry6+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry6+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry6+= "   AND QI2_CODEFE<>'' "
cQry6+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry6+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry6+= "   AND QI0_TIPO='2' "
cQry6+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry6+= "   AND QI2_CODEFE = '011' " //EMBALAGEM COM VAZAMENTO 
cQry6+= "   AND QI2_STATUS='3' "
cQry6+= "   AND QI2_X_DEPT<>'PRODUCAO PLANTA VERD' "
cQry6+= "  GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
cQry6+= "  ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "

If Select("TRB6") > 0 
	TRB6->(dbCloseArea())
EndIf      
TCQUERY cQry6 NEW ALIAS "TRB6"

dbSelectArea("TRB6")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//11 - FAMILIA - EMBALAGEM COM VAZAMENTO PLANTA VERDE |||||

cQry6V:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry6V+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry6V+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD, "
cQry6V+= "       QI2.QI2_LOTE AS LOTE, "
cQry6V+= "       QI2.QI2_X_LVLD AS DTVLOTE, "
cQry6V+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry6V+= "       COUNT(*) AS TOTAL "
cQry6V+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry6V+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry6V+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry6V+= "   AND QI2_CODEFE<>'' "
cQry6V+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry6V+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry6V+= "   AND QI0_TIPO='2' "
cQry6V+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry6V+= "   AND QI2_CODEFE = '011' " //EMBALAGEM COM VAZAMENTO 
cQry6V+= "   AND QI2_STATUS='3' "
cQry6V+= "   AND QI2_X_DEPT='PRODUCAO PLANTA VERD' "
cQry6V+= "  GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
cQry6V+= "  ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
If Select("TRB6V") > 0 
	TRB6V->(dbCloseArea())
EndIf      
TCQUERY cQry6V NEW ALIAS "TRB6V"

dbSelectArea("TRB6V")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//12 - FAMILIA - FALTA UNIDADE NA EMBALAGEM PLANTA VERDE|||||

cQry7V:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry7V+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry7V+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD,"
cQry7V+= "       QI2.QI2_LOTE AS LOTE, "
cQry7V+= "       QI2.QI2_X_LVLD AS DTVLOTE, "
cQry7V+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry7V+= "       COUNT(*) AS TOTAL "
cQry7V+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry7V+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry7V+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry7V+= "   AND QI2_CODEFE<>'' "
cQry7V+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry7V+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry7V+= "   AND QI0_TIPO='2' "
cQry7V+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry7V+= "   AND QI2_CODEFE = '004' " //FALTA UNIDADE DENTRO DA EMBALAGEM
cQry7V+= "   AND QI2_STATUS='3' "
cQry7V+= "   AND QI2_X_DEPT='PRODUCAO PLANTA VERD' "
cQry7V+= "  GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
cQry7V+= "  ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
If Select("TRB7V") > 0 
	TRB7V->(dbCloseArea())
EndIf      
TCQUERY cQry7V NEW ALIAS "TRB7V"

dbSelectArea("TRB7V")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//13 - FAMILIA - EMBALAGEM COM AVARIA |||||

IncProc("Processando Atendimentos... 8", "Aguarde...") 

cQry8:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry8+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry8+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD,"
cQry8+= "       QI2.QI2_X_NTOR AS NFORI, "
cQry8+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry8+= "       COUNT(*) AS TOTAL "
cQry8+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry8+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry8+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry8+= "   AND QI2_CODEFE<>'' "
cQry8+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry8+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry8+= "   AND QI0_TIPO='2' "
cQry8+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry8+= "   AND QI2_CODEFE = '023' " // EMBALAGEM COM AVARIA
cQry8+= "   AND QI2_STATUS='3' "
cQry8+= " GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_X_NTOR "
cQry8+= " ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_X_NTOR "
If Select("TRB8") > 0 
	TRB8->(dbCloseArea())
EndIf      
TCQUERY cQry8 NEW ALIAS "TRB8"

dbSelectArea("TRB8")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//14 - USUARIO |||||    

IncProc("Processando Atendimentos... 11", "Aguarde...") 

cQryB:= "SELECT USUARIO, NOME,  "
cQryB+= " SUM(TOTAL) AS TOTAL, "
cQryB+= " SUM(PENDENTE) AS PENDENTE "
cQryB+= " FROM ( "
cQryB+= "        SELECT QAA.QAA_MAT AS USUARIO, "
cQryB+= "           QAA.QAA_NOME AS NOME, "
cQryB+= "           COUNT(*) AS TOTAL, "
cQryB+= "           0 AS PENDENTE "
cQryB+= "        FROM QAA020 QAA ,QI5020 QI5, QI2020 QI2 "
cQryB+= "        WHERE QAA.D_E_L_E_T_='' AND QI5.D_E_L_E_T_='' AND QI2.D_E_L_E_T_=''  "
cQryB+= "          AND QAA.QAA_FILIAL = QI5.QI5_FILMAT "
cQryB+= "          AND QAA.QAA_MAT = QI5.QI5_MAT "
cQryB+= "          AND QI5_CODIGO = QI2_CODACA "
cQryB+= "          AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryB+= "          AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryB+= "        GROUP BY QAA.QAA_MAT, QAA.QAA_NOME "
cQryB+= "      UNION ALL "
cQryB+= "        SELECT QAA.QAA_MAT AS USUARIO, "
cQryB+= "           QAA.QAA_NOME AS NOME, "
cQryB+= "           0 AS TOTAL, "
cQryB+= "           COUNT(*) AS PENDENTE "
cQryB+= "        FROM QAA020 QAA ,QI5020 QI5, QI2020 QI2 "
cQryB+= "        WHERE QAA.D_E_L_E_T_='' AND QI5.D_E_L_E_T_=''  AND QI2.D_E_L_E_T_=''"
cQryB+= "          AND QAA.QAA_FILIAL = QI5.QI5_FILMAT "
cQryB+= "          AND QAA.QAA_MAT = QI5.QI5_MAT "
cQryB+= "          AND QI5_STATUS BETWEEN '1' AND '3' " //PENDENTES (MAIOR QUE 0% E MENOR QUE 100%)
cQryB+= "          AND QI5_CODIGO = QI2_CODACA "
cQryB+= "          AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryB+= "          AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryB+= "        GROUP BY QAA.QAA_MAT, QAA.QAA_NOME "
cQryB+= "      ) AGRUPA "  
cQryB+= " GROUP BY USUARIO, NOME  "
cQryB+= " ORDER BY TOTAL DESC " //" ORDER BY DEPTO "

If Select("TRBB") > 0 
	TRBB->(dbCloseArea())
EndIf      
TCQUERY cQryB NEW ALIAS "TRBB"

dbSelectArea("TRBB")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//15 - FAMILIA - FALTA DE UNIDADE NA EMBALAGEM |||||

IncProc("Processando Atendimentos... 7", "Aguarde...") 

cQry7:= "SELECT SB1.B1_XFAMCOM AS FAMILIA, "
cQry7+= "       QI2.QI2_X_MT AS MOTIVO, "
cQry7+= "       (CASE WHEN QI2_CODPRO = '' THEN 'NAO INFORMADO' ELSE QI2_CODPRO END) AS CODPROD,"
cQry7+= "       QI2.QI2_LOTE AS LOTE, "
cQry7+= "       QI2.QI2_X_LVLD AS DTVLOTE, "
cQry7+= "       SUM(QI2_X_QTDV) AS QTDDEV, "
cQry7+= "       COUNT(*) AS TOTAL "
cQry7+= " FROM QI2020 QI2 ,QI0020 QI0, SB1020 SB1 "
cQry7+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' AND SB1.D_E_L_E_T_='' "
cQry7+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry7+= "   AND QI2_CODEFE<>'' "
cQry7+= "   AND QI2_CODEFE=QI0_CODIGO "
cQry7+= "   AND QI2_CODPRO=SB1.B1_COD "
cQry7+= "   AND QI0_TIPO='2' "
cQry7+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry7+= "   AND QI2_CODEFE = '004' " //FALTA UNIDADE DENTRO DA EMBALAGEM
cQry7+= "   AND QI2_STATUS='3' "
cQry7+= "   AND QI2_X_DEPT<>'PRODUCAO PLANTA VERD' "
cQry7+= "  GROUP BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
cQry7+= "  ORDER BY SB1.B1_XFAMCOM, QI2.QI2_X_MT, QI2_CODPRO, QI2.QI2_LOTE, QI2.QI2_X_LVLD "
If Select("TRB7") > 0 
	TRB7->(dbCloseArea())
EndIf      
TCQUERY cQry7 NEW ALIAS "TRB7"

dbSelectArea("TRB7")
dbGotop()

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//POR PRODUTO

//IncProc("Processando Atendimentos... 4", "Aguarde...") 
/*
cQry4:= "SELECT CODPROD, DESCPROD, SUM(QTDDEV) AS QTDDEV, SUM(QTDEMB) AS QTDEMB, SUM(TOTAL) AS TOTAL  "
cQry4+= "FROM ( "
cQry4+= "SELECT QI2.QI2_CODPRO AS CODPROD, SB1.B1_DESC AS DESCPROD, SUM(QI2_X_QTDV) AS QTDDEV, 0 AS QTDEMB, COUNT(*) AS TOTAL  "
cQry4+= " FROM QI2020 QI2, SB1020 SB1  "
cQry4+= " WHERE QI2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''  "
cQry4+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry4+= "   AND QI2_CODPRO<>''  "
cQry4+= "   AND QI2_CODPRO=SB1.B1_COD   "
cQry4+= "   AND QI2_STATUS='3' "
cQry4+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry4+= " GROUP BY QI2_CODPRO, B1_DESC "
cQry4+= "UNION ALL "
cQry4+= "SELECT QI2.QI2_CODPRO AS CODPROD, SB1.B1_DESC AS DESCPROD,  0 AS QTDDEV, COUNT(*) AS QTDEMB, 0 AS TOTAL  "
cQry4+= " FROM QI2020 QI2, SB1020 SB1  "
cQry4+= " WHERE QI2.D_E_L_E_T_='' AND SB1.D_E_L_E_T_=''  "
cQry4+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQry4+= "   AND QI2_CODPRO<>''  "
cQry4+= "   AND QI2_CODPRO=SB1.B1_COD   "
cQry4+= "   AND QI2_STATUS='3' "
cQry4+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQry4+= "   AND QI2_CODEFE IN ('011','023') " //SOMENTE CHAMADOS DE EMBALAGEM
cQry4+= " GROUP BY QI2_CODPRO, B1_DESC "
cQry4+= ") AGRUPA "
cQry4+= " GROUP BY CODPROD, DESCPROD "
cQry4+= " ORDER BY TOTAL DESC"

If Select("TRB4") > 0 
	TRB4->(dbCloseArea())
EndIf      
TCQUERY cQry4 NEW ALIAS "TRB4"

dbSelectArea("TRB4")
dbGotop()
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//ATRASO NA ENTREGA / SAIDA _OK

cQryD:= "SELECT QI2.QI2_CODEFE AS COD_EFE, QI0.QI0_DESC AS DESCEFE, COUNT(*) AS TOTAL "
cQryD+= " FROM "+RetSQLName("QI2")+" QI2 ,"+RetSQLName("QI0")+" QI0 "
cQryD+= " WHERE QI2.D_E_L_E_T_='' AND QI0.D_E_L_E_T_='' "
cQryD+= "   AND QI2_OCORRE BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' "
cQryD+= "   AND QI2_CODEFE IN ('001','027','028') " //atraso na entrega
cQryD+= "   AND QI2_CODEFE=QI0_CODIGO "
cQryD+= "   AND QI2_STATUS='3' "
cQryD+= "   AND QI0_TIPO='2' "
cQryD+= "   AND QI2_FILIAL='"+xFilial("QI2")+"' "
cQryD+= " GROUP BY QI2_CODEFE, QI0_DESC "
cQryD+= " ORDER BY TOTAL DESC "
If Select("TRBD") > 0 
	TRBD->(dbCloseArea())
EndIf      
TCQUERY cQryD NEW ALIAS "TRBD"
dbSelectArea("TRBD")
dbGotop()



EnvMailAtend() 

dbSelectArea("TRB1"); dbCloseArea()
dbSelectArea("TRB2"); dbCloseArea()
dbSelectArea("TRB3"); dbCloseArea()
//dbSelectArea("TRB4"); dbCloseArea()
dbSelectArea("TRB5"); dbCloseArea()
dbSelectArea("TRB6"); dbCloseArea()
dbSelectArea("TRB6V"); dbCloseArea()
dbSelectArea("TRB7"); dbCloseArea()
dbSelectArea("TRB7V"); dbCloseArea()
dbSelectArea("TRB8"); dbCloseArea()
dbSelectArea("TRB9"); dbCloseArea()
dbSelectArea("TRBA"); dbCloseArea()
dbSelectArea("TRBB"); dbCloseArea()
dbSelectArea("TRBC"); dbCloseArea()
dbSelectArea("TRBD"); dbCloseArea()

Return(.T.)


 
Static Function EnvMailAtend()
******************************
Local _Total1 := 0
Local _Total2 := 0
Local _Total3 := 0
Local _Total41:= 0
Local _Total42:= 0
Local _Total43:= 0
Local _Total44:= 0
Local _Total5 := 0
Local _Total5D:= 0
Local _Total6 := 0
Local _Total6D:= 0
Local _Total7 := 0
Local _Total7D:= 0
Local _Total8 := 0
Local _Total8D:= 0
Local _Total9 := 0
Local _Total9D:= 0
Local _TOTALA := 0
Local _TOTALAP:= 0
Local _TOTALB := 0
Local _TOTALC := 0
Local _TOTALD := 0
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""
Local cEmail  := ""
Local cMesAux := {"Janeiro","Fevereiro","MarÁo","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}

_cBody := "<html>"
_cBody += "<head>"
_cBody += '<meta http-equiv="Content-Language" content="pt-br">'
_cBody += '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
_cBody += "<title>Nova pagina 1</title>"
_cBody += "</head>"
_cBody += "<body>"
_cBody += '<p align="left"><font face="Tahoma" size="3"><b>ATENDIMENTO ESPECIAL - '+cMesAux[Month(mv_par01)]+'/'+Alltrim(Str(Year(mv_par01)))+'</b></font></p>'

//**************************************************************************************************************************************************************
//TRB1 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 
_cBody += '<table border="1" width="50%">                                                                    '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Motivo de Abertura do Chamado</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB1")
DbGoTop()
While !Eof()
	_TOTAL1+= TRB1->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRB1->DESCEFE+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB1->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRB1->TOTAL*100)/_TOTAL1 ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL1 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '

//**************************************************************************************************************************************************************
//TRB9 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
 
_cBody += '<table border="1" width="50%">                                                                    '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Motivo de Encerramento de Chamado</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB9")
DbGoTop()
While !Eof()
	_TOTAL9+= TRB9->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRB9->DESCENC+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB9->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRB9->TOTAL*100)/_TOTAL9 ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL9 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '

//**************************************************************************************************************************************************************
//TRB2 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Atraso na Entrega por Transportadora</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB2")

DbGoTop()
While !Eof()
	_TOTAL2+= TRB2->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	If Empty(TRB2->COD_TRANSP)
		_cBody += '		<td width="70%"><font face="Tahoma" size="2" color="#FF0000">COD.TRANSP.EM BRANCO</font></td> '                                         
	ElseIf !Empty(TRB2->COD_TRANSP).And.Empty(TRB2->NOMETRANSP)
		_cBody += '		<td width="70%"><font face="Tahoma" size="2" color="#FF0000">COD.TRANSP.NAO CADASTRADO ('+Alltrim(TRB2->COD_TRANSP)+') </font></td> '                                         
    Else
		_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRB2->NOMETRANSP+'</font></td> '                                         
    EndIf

	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB2->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRB2->TOTAL*100)/_TOTAL2 ,"@R 99999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL2 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



//**************************************************************************************************************************************************************
//TRBC |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Causas dos Pedidos em Desacordo</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRBC")

DbGoTop()
While !Eof()
	_TOTALC+= TRBC->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRBC->DESCCAU+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBC->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBC->TOTAL*100)/_TOTALC ,"@R 99999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALC ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '




//**************************************************************************************************************************************************************
//TRBD |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Motivo de Abertura do Chamado - Atraso na Entrega</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRBD")

DbGoTop()
While !Eof()
	_TOTALD+= TRBD->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr>'
	_cBody += '		<td width="70%"><font face="Tahoma" size="2">'+TRBD->DESCEFE+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBD->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBD->TOTAL*100)/_TOTALD ,"@R 99999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALD ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '


//**************************************************************************************************************************************************************
//TRB3 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="70%" align="center"><b><font face="Tahoma" size="2">Atraso na Entrega por Regi„o</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB3")
DbGoTop()
While !Eof()
	_TOTAL3+= TRB3->TOTAL
	DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="70%" align="center"><font face="Tahoma" size="2">'+TRB3->ESTADO+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB3->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRB3->TOTAL*100)/_TOTAL3 ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="70%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL3 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+' '+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '

//**************************************************************************************************************************************************************
//TRB4 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
/*
_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="60%" align="center"><b><font face="Tahoma" size="2">Produto</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="1">Qtde Dev.</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="1">Cham. Emb.</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="1">Cham. Outros</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB4")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="60%"><font face="Tahoma" size="1">'+SubStr(TRB4->CODPROD,1,10)+' - '+SubStr(TRB4->DESCPROD,1,40)+'</font></td> '                                         
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRB4->QTDDEV,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRB4->QTDEMB,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="1">'+Alltrim(Transform(TRB4->TOTAL-TRB4->QTDEMB,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRB4->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '	</tr> '
	_TOTAL41+= TRB4->QTDDEV
	_TOTAL42+= TRB4->QTDEMB
	_TOTAL43+= TRB4->TOTAL-TRB4->QTDEMB
	_TOTAL44+= TRB4->TOTAL

	DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="60%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL41 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL42 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL43 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL44 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '
*/


//**************************************************************************************************************************************************************
//TRB5 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Produtos Fora das EspecificaÁıes</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Lotes/Validade</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB5")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB5->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cMotivoAx:= ""
	cMotAux  := "'"
	cChaveAx5:= TRB5->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cLotesAux:= ""
	cProdsAux:= ""
	cProdAux5:= ""
	
	While !Eof() .And. cChaveAx5==TRB5->FAMILIA
		
		If cProdAux5<>TRB5->CODPROD
			If Alltrim(TRB5->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB5->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB5->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux5:= TRB5->CODPROD
		EndIf	

		cLotesAux+= TRB5->LOTE + Iif(!Empty(TRB5->DTVLOTE), " - "+DtoC(StoD(TRB5->DTVLOTE))," ")+ "<br>"

		If cMotAux<>TRB5->MOTIVO
			cMotivoAx+= AllTrim(TRB5->MOTIVO)+" <br>"
			cMotAux  := TRB5->MOTIVO
		EndIf	
		
		nTQtdAux += TRB5->QTDDEV
		nTTotAux += TRB5->TOTAL
		_TOTAL5D += TRB5->QTDDEV
		_TOTAL5  += TRB5->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cLotesAux:= SubStr(cLotesAux,1,Len(cLotesAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cLotesAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"></font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL5D,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL5 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(10)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '

//**************************************************************************************************************************************************************
//TRB6 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Embalagem com Vazamento</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Lotes/Validade</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB6")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB6->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cChaveAx6:= TRB6->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cLotesAux:= ""
	cProdsAux:= ""
	cProdAux6:= ""
	cMotivoAx:= ""
	cMotAux  := "'"
	
	While !Eof() .And. cChaveAx6==TRB6->FAMILIA
		
		If cProdAux6<>TRB6->CODPROD
			If Alltrim(TRB6->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB6->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB6->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux6:= TRB6->CODPROD
		EndIf	

		cLotesAux+= TRB6->LOTE + Iif(!Empty(TRB6->DTVLOTE), " - "+DtoC(StoD(TRB6->DTVLOTE))," ")+ "<br>"

		If cMotAux<>TRB6->MOTIVO
			cMotivoAx+= AllTrim(TRB6->MOTIVO)+" <br>"
			cMotAux  := TRB6->MOTIVO
		EndIf	
		
		nTQtdAux += TRB6->QTDDEV
		nTTotAux += TRB6->TOTAL
		_TOTAL6D += TRB6->QTDDEV
		_TOTAL6  += TRB6->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cLotesAux:= SubStr(cLotesAux,1,Len(cLotesAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cLotesAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"> </font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL6D ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL6 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(10)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



//**************************************************************************************************************************************************************
//TRB6V ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Embalagem com Vazamento (Planta Verde)</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Lotes/Validade</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

_TOTAL6D := 0
_TOTAL6  := 0

DbSelectArea("TRB6V")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB6V->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cMotivoAx:= ""
	cMotAux  := "'"
	cChaveAx6:= TRB6V->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cLotesAux:= ""
	cProdsAux:= ""
	cProdAux6:= ""
	
	While !Eof() .And. cChaveAx6==TRB6V->FAMILIA
		
		If cProdAux6<>TRB6V->CODPROD
			If Alltrim(TRB6V->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB6V->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB6V->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux6:= TRB6V->CODPROD
		EndIf	

		cLotesAux+= TRB6V->LOTE + Iif(!Empty(TRB6V->DTVLOTE), " - "+DtoC(StoD(TRB6V->DTVLOTE))," ")+ "<br>"

		If cMotAux<>TRB6V->MOTIVO
			cMotivoAx+= AllTrim(TRB6V->MOTIVO)+" <br>"
			cMotAux  := TRB6V->MOTIVO
		EndIf	
		
		nTQtdAux += TRB6V->QTDDEV
		nTTotAux += TRB6V->TOTAL
		_TOTAL6D += TRB6V->QTDDEV
		_TOTAL6  += TRB6V->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cLotesAux:= SubStr(cLotesAux,1,Len(cLotesAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cLotesAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"> </font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL6D ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL6 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(10)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '


//**************************************************************************************************************************************************************
//TRB7 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Falta de Unidade na Embalagem</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Lotes/Validade</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB7")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB7->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cMotivoAx:= ""
	cMotAux  := "'"
	cChaveAx7:= TRB7->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cLotesAux:= ""
	cProdsAux:= ""
	cProdAux7:= ""
	
	While !Eof() .And. cChaveAx7==TRB7->FAMILIA
		
		If cProdAux7<>TRB7->CODPROD
			If Alltrim(TRB7->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB7->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB7->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux7:= TRB7->CODPROD
		EndIf	

		cLotesAux+= TRB7->LOTE + Iif(!Empty(TRB7->DTVLOTE), " - "+DtoC(StoD(TRB7->DTVLOTE))," ")+ "<br>"

		If cMotAux<>TRB7->MOTIVO
			cMotivoAx+= AllTrim(TRB7->MOTIVO)+" <br>"
			cMotAux  := TRB7->MOTIVO
		EndIf	

		nTQtdAux += TRB7->QTDDEV
		nTTotAux += TRB7->TOTAL
		_TOTAL7D += TRB7->QTDDEV
		_TOTAL7  += TRB7->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cLotesAux:= SubStr(cLotesAux,1,Len(cLotesAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cLotesAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"> </font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL7D,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL7 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(20)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



//**************************************************************************************************************************************************************
//TRB7V ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Falta de Unidade na Embalagem (Planta Verde)</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Lotes/Validade</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

_TOTAL7D := 0
_TOTAL7  := 0

DbSelectArea("TRB7V")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB7V->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cMotivoAx:= ""
	cMotAux  := "'"
	cChaveAx7:= TRB7V->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cLotesAux:= ""
	cProdsAux:= ""
	cProdAux7:= ""
	
	While !Eof() .And. cChaveAx7==TRB7V->FAMILIA
		
		If cProdAux7<>TRB7V->CODPROD
			If Alltrim(TRB7V->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB7V->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB7V->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux7:= TRB7V->CODPROD
		EndIf	

		cLotesAux+= TRB7V->LOTE + Iif(!Empty(TRB7V->DTVLOTE), " - "+DtoC(StoD(TRB7V->DTVLOTE))," ")+ "<br>"

		If cMotAux<>TRB7V->MOTIVO
			cMotivoAx+= AllTrim(TRB7V->MOTIVO)+" <br>"
			cMotAux  := TRB7V->MOTIVO
		EndIf	

		nTQtdAux += TRB7V->QTDDEV
		nTTotAux += TRB7V->TOTAL
		_TOTAL7D += TRB7V->QTDDEV
		_TOTAL7  += TRB7V->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cLotesAux:= SubStr(cLotesAux,1,Len(cLotesAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cLotesAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"> </font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL7D,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL7 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(20)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '


//**************************************************************************************************************************************************************
//TRB8 |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="80%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">FamÌlia</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="35%" align="center"><b><font face="Tahoma" size="2">Embalagem com Avaria</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Unidades</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">Chamados</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">NF</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Motivo</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRB8")
DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '	    <td width="10%"><font face="Tahoma" size="1"> '+ Alltrim(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRB8->FAMILIA,"X5_DESCRI"))+' </font></td> '
	                   
	cMotivoAx:= ""
	cMotAux  := "'"
	cChaveAx8:= TRB8->FAMILIA
	nTQtdAux := 0
	nTTotAux := 0
	cNFAux   := ""
	cProdsAux:= ""
	cProdAux8:= ""
	
	While !Eof() .And. cChaveAx8==TRB8->FAMILIA
		
		If cProdAux8<>TRB8->CODPROD
			If Alltrim(TRB8->CODPROD)=="NAO INFORMADO"
				cProdsAux+=  "COD.PRODUTO EM BRANCO"+"<br>"
			Else
				cProdsAux+=  SubStr(TRB8->CODPROD,1,10)+' - '+AllTrim(SubStr(Posicione("SB1",1,xFilial("SB1")+TRB8->CODPROD,"B1_DESC"),1,40))+"<br>"
			EndIf	
			cProdAux8:= TRB8->CODPROD
		EndIf	

		cNFAux  += TRB8->NFORI + "<br>"

		If cMotAux<>TRB8->MOTIVO
			cMotivoAx+= AllTrim(TRB8->MOTIVO)+" <br>"
			cMotAux  := TRB8->MOTIVO
		EndIf	
		
		nTQtdAux += TRB8->QTDDEV
		nTTotAux += TRB8->TOTAL
		_TOTAL8D += TRB8->QTDDEV
		_TOTAL8  += TRB8->TOTAL
		
	    DbSkip()
	EndDo
	
	cProdsAux:= SubStr(cProdsAux,1,Len(cProdsAux)-4) //tira o ultimo '<br>'
	cNFAux   := SubStr(cNFAux,1,Len(cNFAux)-4) //tira o ultimo '<br>'
	cMotivoAx:= SubStr(cMotivoAx,1,Len(cMotivoAx)-4) //tira o ultimo '<br>'

	_cBody += '		<td width="35%" align="left"><font face="Tahoma" size="1">'+ cProdsAux +'</font></td>'
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTQtdAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(nTTotAux,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="15%" align="left"><font face="Tahoma" size="1">'+ cNFAux +'</font></td>'
	_cBody += '		<td width="20%"><font face="Tahoma" size="1">'+cMotivoAx+'</font></td> '
	_cBody += '	</tr> '
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="10%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="35%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2"> </font></b></td> '  
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL8D,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTAL8 ,"@E 99,999,999"))+'</font></b></td>'
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+" "+'</font></b></td>'
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Space(20)+'</font></b></td>'
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '


//**************************************************************************************************************************************************************
//TRBB |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="60%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="50%" align="center"><b><font face="Tahoma" size="2">Usu·rio</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">Pendente</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRBB")
DbGoTop()

_TOTALB  := 0
_TOTALBP := 0
While !Eof()
	_TOTALB += TRBB->TOTAL
	_TOTALBP+= TRBB->PENDENTE
    DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="50%"><font face="Tahoma" size="2">'+Alltrim(TRBB->USUARIO)+' - '+Alltrim(TRBB->NOME)+'</font></td> '                                         
	_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBB->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBB->TOTAL*100)/_TOTALB ,"@R 9999%"))+'</font></td>' 
	_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBB->PENDENTE ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBB->PENDENTE*100)/_TOTALBP ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '
    DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="50%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALB ,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALBP,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



//**************************************************************************************************************************************************************
//TRBA |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="50%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="40%" align="center"><b><font face="Tahoma" size="2">Departamento</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="20%" align="center"><b><font face="Tahoma" size="2">Pendente</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="10%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

DbSelectArea("TRBA")
DbGoTop()

_TOTALA  := 0
_TOTALAP := 0
_TOTALAF := 0
While !Eof()
	_TOTALA += TRBA->TOTAL
	_TOTALAP+= TRBA->PENDENTE
	_TOTALAF+= TRBA->FECHADOS
    DbSkip()
EndDo

DbGoTop()
While !Eof()
	_cBody += '	<tr> '
	_cBody += '		<td width="40%"><font face="Tahoma" size="2">'+Iif(Empty(TRBA->DEPTO),"OUTROS",TRBA->DEPTO)+'</font></td> '                                         
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBA->TOTAL ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBA->TOTAL*100)/_TOTALA ,"@R 9999%"))+'</font></td>' 
	_cBody += '		<td width="20%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(TRBA->PENDENTE ,"@E 99,999,999"))+'</font></td>' 
	_cBody += '		<td width="10%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((TRBA->PENDENTE*100)/_TOTALAP ,"@R 9999%"))+'</font></td>' 
	_cBody += '	</tr> '
    DbSkip()
EndDo

_cBody += '	<tr>'
_cBody += '		<td width="40%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALA ,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '		<td width="20%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAP,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="10%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '	</tr> '
_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '




//**************************************************************************************************************************************************************
//TOTAL ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

_cBody += '<table border="1" width="40%"> '
_cBody += '	<tr>'
_cBody += '		<td bgcolor="#ccffcc" width="60%" align="center"><b><font face="Tahoma" size="2">TOTAL GERAL</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="25%" align="center"><b><font face="Tahoma" size="2">Total</font></b></td>'
_cBody += '		<td bgcolor="#ccffcc" width="15%" align="center"><b><font face="Tahoma" size="2">%</font></b></td>'
_cBody += '	</tr>'

_cBody += '	<tr> '
_cBody += '		<td width="60%"><font face="Tahoma" size="2">Chamados Fechados </font></td> '                                         
_cBody += '		<td width="25%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAF ,"@E 99,999,999"))+'</font></td>' 
_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((_TOTALAF*100)/(_TOTALAF+_TOTALAP) ,"@R 9999%"))+'</font></td>' 
_cBody += '	</tr> '
_cBody += '	<tr> '
_cBody += '		<td width="60%"><font face="Tahoma" size="2">Chamados Pendentes </font></td> '                                         
_cBody += '		<td width="25%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAP ,"@E 99,999,999"))+'</font></td>' 
_cBody += '		<td width="15%" align="right"><font face="Tahoma" size="2">'+Alltrim(Transform((_TOTALAP*100)/(_TOTALAF+_TOTALAP) ,"@R 9999%"))+'</font></td>' 
_cBody += '	</tr> '

_cBody += '	<tr>'
_cBody += '		<td width="60%" bgcolor="#cccccc" ><b><font face="Tahoma" size="2">T O T A L</font></b></td> '  
_cBody += '		<td width="25%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2">'+Alltrim(Transform(_TOTALAF+_TOTALAP ,"@E 99,999,999"))+'</font></b></td>' 
_cBody += '		<td width="15%" bgcolor="#cccccc" align="right"><b><font face="Tahoma" size="2"> </font></b></td>' 
_cBody += '	</tr> '

_cBody += '</table>'
_cBody += '<p><font color="#FFFFFF">.</font></p> '



_cBody += '<p><font color="#FFFFFF">.</font></p> '
_cBody += '<p><font face="Tahoma" size="1">'+DtoC(Date())+' - '+Time()+'</font></p>'
_cBody += '</body> '
_cBody += '</html>'
 
cAssunto:= "Atendimento Especial - "+cMesAux[Month(mv_par01)]+'/'+Alltrim(Str(Year(mv_par01)))


cTipMail:= "000013"
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



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//cEmail:= "thiago.moyses@brascola.com.br"
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



If !Empty(cEmail)
	//Envio do email
	U_SendMail(cEmail,cAssunto,_cBody,"",.f.)
EndIf	

//dbSelectArea("SZGS")
//dbCloseArea()

Return
      


Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)
 
aRegs:= {}
//          Grupo/Ordem/Pergunta/                   Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture
aAdd(aRegs,{cPerg,"01" ,"Data De? "          ,"","","mv_ch1","D" ,8      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""})
aAdd(aRegs,{cPerg,"02" ,"Data Ate?"          ,"","","mv_ch2","D" ,8      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,""   ,""    ,""     ,""   ,""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return