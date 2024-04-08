#INCLUDE "RWMAKE.CH"         
#INCLUDE "TbiConn.ch"
/******************************************************************************************************************
** FONTE:     SALDO_PRODUTO.PRW																											  **
** FUNCAO:    MAPA02()																														  **
** DESCRICAO: SOLICITADO PELO RONALDO LIMA, FUNCAO MOSTRA NO EXCEL O RESULTADO DE UMA QUERY. O RESULTADO SAO OS  **
**            SALDOS EM ESTOQUE DOS PRODUTOS E LOCAIS SELECIONADOS NOS PARAMETROS DE USUARIO                     **
******************************************************************************************************************/
USER FUNCTION MAPA02()
LOCAL aRegs  := {}
Local cPerg  := U_CRIAPERG("MAPA02")

aAdd(aRegs,{"MAPA02","01","Do Produto ?","Do Produto ?","Do Produto ?","mv_ch1","C",15,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
aAdd(aRegs,{"MAPA02","02","Ate Produto?","Ate Produto?","Ate Produto?","mv_ch2","C",15,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
aAdd(aRegs,{"MAPA02","03","Armazens   ?","Armazens   ?","Armazens   ?","mv_ch3","C",40,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})

PERGUNTE(cPerg,.T.)               

lValidPerg(aRegs)  

MsgRun("Aguarde....","Processando",{ || CRIASALDO(.F.)})

RETURN(.T.)

/******************************************************************************************************************/

Static Function CRIASALDO(lSchedule)

Local cQuery := ""
Local cAlias := "TRB" 
Local cEst   := ""

Local cArqTmp		:= CriaTrab( Nil,.F.)
Local cNomArqDes 	:= ""
Local cDirDocs   	:= MsDocPath()

If !lSchedule
	cEst := STRTRAN(MV_PAR03,";",",")
	cEst := STRTRAN(cEst,",","','")
Else
	cEst	 	:= "40"
	mv_par01 := '               '
	mv_par02	:= "ZZZZZZZZZZZZZZZ"
EndIf

cQuery := " SELECT SB2.B2_COD PRODUTO, SB1.B1_DESC 'DESC' , SB1.B1_UM UM , SB2.B2_LOCAL LOCAL," 
cQuery += " SB1.B1_ESTSEG EST_SEG , CAST(SB1.B1_PESO AS NUMERIC (10,2)) PLIQUI,"
cQuery += " CAST(SB1.B1_LM AS NUMERIC (10,2)) LT_MIN ,CAST(SB2.B2_QATU AS NUMERIC (10,2)) SLD_ATU ,CAST(SB2.B2_QNPT AS NUMERIC (10,2)) SLD_PODER3,"
cQuery += " SB2.B2_FILIAL FILIAL"
cQuery += " FROM SB2020 SB2 , SB1020 SB1"
cQuery += " WHERE SB2.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' AND SB2.B2_LOCAL IN ('"+cEst+"')"
cQuery += " AND SB1.B1_COD = SB2.B2_COD AND SB1.B1_TIPO = 'PA' AND SB1.B1_COD BETWEEN '"+MV_PAR01+"' AND '"  
cQuery +=  MV_PAR02 + "' "// AND  B2_FILIAL = '" + XFILIAL("SB2") + "' "  
cQuery += " ORDER BY SB2.B2_FILIAL , SB2.B2_COD"

MemoWrite("\QUERYSYS\MAPA02.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)
	
TCSetField('TRB', "EST_SEG", "N",16,2)
TCSetField('TRB', "PLIQUI" , "N",16,2)
TCSetField('TRB', "LT_MIN" , "N",16,2)
TCSetField('TRB', "SLD_ATU", "N",16,2)

If !lSchedule
	u_ProcExcel(cAlias)
Else
	dbSelectArea('TRB')
	Copy To &(cDirDocs+"\"+cArqTmp+".XLS") VIA "DBFCDXADS"
	__CopyFile(cDirDocs+"\"+cArqTmp+".XLS", "\spool\saldoemestoque.xls")
//	cEmail    := "fabio.teodoro@brascola.com.br"
	cAssunto  := "Saldo em Estoque - " + Time()
	cMensagem := 'Segue o caminho do arquivo gerado pelo relatorio *Saldo em Estoque. \\server_erp\spool\saldoemestoque.xls'
	cAnexo	 := ""
	U_SendMail(cEmail,cAssunto,cMensagem,cAnexo,.t.)	
	Ferase(cDirDocs+"\"+cArqTmp+".XLS")
EndIf

If Select("TRB") > 0
	TRB->(DBClosearea())
EndIF
	
Return(.T.)


/******************************************************************************************************************
** FONTE :                                                                                                       **
** FUNCAO:                                                                                                       **
******************************************************************************************************************/
User Function MAPA02SC(lAuto)  

Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro	:= OemToAnsi("Envio do relatorio OrdensdeProducao")
Local nProcessa	:= 3
Local lAuto			:= If(lAuto == NIL,{.F.},lAuto)
Local lJob			:= .t.
//Local lJob			:= Iif(lAuto[1]==.T.,.T.,.F.)
Local cQuery	

RPCSetType(3)  // Nao usar Licensa             

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "04" FUNNAME "U_MAPA02SC" //TABLES "SC5"   			

CRIASALDO(lJob)

RESET ENVIRONMENT

RestArea(aAreaAtu)  
                
Return(Nil)