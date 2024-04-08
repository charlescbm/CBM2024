#INCLUDE "RWMAKE.CH"         
#INCLUDE "TbiConn.ch"

/******************************************************************************************************************
** FONTE:     ORDERM_PROD.PRW																												  **
** FUNCAO:    MAPA03()																														  **
** DESCRICAO: SOLICITADO PELO RONALDO LIMA, FUNCAO MOSTRA NO EXCEL O RESULTADO DE UMA QUERY. O RESULTADO SAO AS  **
**            AS OPS IMPLANTADAS E REPORTADAS NO SISTEMA                                                         **
******************************************************************************************************************/

USER FUNCTION MAPA03()
LOCAL aRegs  := {} 
Local cPerg  := U_CRIAPERG("MAPA03")

AADD(aRegs,{"MAPA03","01","Da Data ?","Da Data ?","Da Data ?","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{"MAPA03","02","Ate Data ?","Ate Data ?","Ate Data ?","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

lValidPerg(aRegs)  

PERGUNTE(cPerg,.T.)

MSGRUN("Aguarde....","Processando",{ || MAPOP(.F.)})
	
RETURN(.T.)	

/******************************************************************************************************************
** FONTE :                                                                                                       **
** FUNCAO:                                                                                                       **
******************************************************************************************************************/
STATIC FUNCTION MAPOP(lSchedule)

LOCAL cQuery := ""
LOCAL cAlias := "TRB" 

cQuery := "SELECT SC2.C2_PRODUTO PRODUTO, SB1.B1_DESC DESCRI, SBM.BM_DESC GRP_ESTE ,"
cQuery += " SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN NR_OP , SC2.C2_EMISSAO EMISSAO ,"
cQuery += " SC2.C2_OBS , SC2.C2_TPOP TIPO ,"
cQuery += " (SELECT CAST(SUM(SB1B.B1_PESO ) AS NUMERIC (10,2)) FROM " + RETSQLNAME("SB1") + " SB1B WHERE SB1B.B1_COD = SC2.C2_PRODUTO ) 'PLIQUI'," 
cQuery += " CAST(SC2.C2_QUANT AS NUMERIC (10,2)) PROGR, ISNULL(CAST(SUM(SD3.D3_QUANT) AS NUMERIC (10,2)),0) REPORTA,"
cQuery += " SC2.C2_DATPRF PREV_ENT , "
cQuery += " SC2.C2_DATRF DT_REFIM"
cQuery += " FROM "+ RETSQLNAME("SC2") + " SC2 INNER JOIN "+ RETSQLNAME("SB1") + " SB1 ON SB1.B1_TIPO = '3' AND SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SC2.C2_PRODUTO"
cQuery += " INNER JOIN " + RETSQLNAME("SBM") + " SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ''"
cQuery += " LEFT JOIN " + RETSQLNAME("SD3") + " SD3 ON SD3.D_E_L_E_T_ = '' AND SD3.D3_OP = SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN AND "
cQuery += " SD3.D3_COD = SC2.C2_PRODUTO "
cQuery += " WHERE SC2.D_E_L_E_T_ = '' "      

If !lSchedule
	cQuery += " AND C2_EMISSAO >= '" + dtos(mv_par01) + "'"
	cQuery += " AND C2_EMISSAO <= '" + dtos(mv_par02) + "'"
Else
	cQuery += " AND C2_EMISSAO >= '20010101' "
	cQuery += " AND C2_EMISSAO <= '20201231' "
EndIf	

cQuery += " GROUP BY SC2.C2_PRODUTO , SB1.B1_DESC , SBM.BM_DESC , SC2.C2_DATPRF ,"
cQuery += " SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN , SC2.C2_OBS , SC2.C2_TPOP , SC2.C2_QUANT, SC2.C2_QUANT , SC2.C2_EMISSAO , SC2.C2_DATRF"
cQuery += " ORDER BY SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN , SC2.C2_EMISSAO"

MemoWrite("\QUERYSYS\MAPA03.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
TCSetField('TRB', "EMISSAO" , "D",08,0)
TCSetField('TRB', "PLIQUI"  , "N",16,2)
TCSetField('TRB', "PROGR"   , "N",16,2)
TCSetField('TRB', "REPORTA" , "N",16,2)
TCSetField('TRB', "PREV_ENT", "D",08,0)
TCSetField('TRB', "DT_REFIM", "D",08,0)
	
If !lSchedule
	u_ProcExcel(cAlias)
Else
	dbSelectArea('TRB')
	cDirDocs := MsDocPath()
	cArqTmp		:= CriaTrab( Nil,.F.)
	
	Copy To &(cDirDocs+"\"+cArqTmp+".XLS") VIA "DBFCDXADS"
	__CopyFile(cDirDocs+"\"+cArqTmp+".XLS", "\spool\ordensdeproducao.xls")
//	cEmail    := "fabio.teodoro@brascola.com.br"
	cAssunto  := "Ordens de Produção - " + Time()
	cMensagem := 'Segue o caminho do arquivo gerado pelo relatorio *Saldo em Estoque. \\server_erp\spool\ordensdeproducao.xls'
	cAnexo	 := ""
	U_SendMail(cEmail,cAssunto,cMensagem,cAnexo,.t.)	
	Ferase(cDirDocs+"\"+cArqTmp+".XLS")
EndIf
	
If Select("TRB") > 0
	TRB->(DBClosearea())
EndIF
	
RETURN(.T.)

/******************************************************************************************************************
** FONTE :                                                                                                       **
** FUNCAO:                                                                                                       **
******************************************************************************************************************/
User Function MAPA03SC(lAuto)  
Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro	:= OemToAnsi("Envio do relatorio OrdensdeProducao")
Local nProcessa	:= 3
Local lAuto			:= If(lAuto == NIL,{.F.},lAuto)
Local lJob			:= .t.
//Local lJob			:= Iif(lAuto[1]==.T.,.T.,.F.)
Local cQuery	

RPCSetType(3)  // Nao usar Licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "U_MAPA03SC" //TABLES "SC5"

MAPOP(.t.)        				

RESET ENVIRONMENT

RestArea(aAreaAtu)  
                
Return(Nil)  