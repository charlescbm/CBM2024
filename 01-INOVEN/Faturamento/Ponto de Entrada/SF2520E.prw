#INCLUDE 'PROTHEUS.CH'
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

/*********************************************************************************************/
/*/{Protheus.doc} SF2520E

@description Ponto de Entrada - Estorno da Nota

@author Bernard M. Margarido
@since 23/04/2018
@version 1.0

@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function SF2520E()
	
	Local aArea	:= GetArea()  

	Local cAlias := GetNextAlias() // Comando que retorna um nome de alias aleatório não usado, assim é seguro e não dá 
	                               // problema de "Alias already exists" e não precisa do Select() > 0 pra ver se já está aberta e fechar.

	///Busco Informacoes Financeiras
	///////////////////////////////

	cQuery := "SELECT D2_PEDIDO  "
	cQuery += "FROM "+RetSqlName("SD2")+" WHERE D_E_L_E_T_='' AND D2_FILIAL = '"+xFilial("SD2")+"' "
	cQuery += " AND D2_DOC = '"+Alltrim(SF2->F2_DOC)+"' AND D2_SERIE = '"+Alltrim(SF2->F2_SERIE)+"' "
	cQuery += " AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' AND D2_LOJA = '"+SF2->F2_LOJA+"' "
	cQuery += " GROUP BY D2_PEDIDO "
	cQuery := ChangeQuery(cQuery)
	
	MPSysOpenQuery(cQuery, cAlias) // Esse comando pega a query executa e abre com o alias passado, se fosse usar o Select() > 0 + dbCloseArea teria que ser antes de executar isso aqui.
	
	// Aqui a tabela já está aberta e no primeiro registros, não precisa de dbSelectArea nem dbGoTop()
	
	While !(cAlias)->( Eof() )
	
		u_DnyGrvSt((cAlias)->D2_PEDIDO, "000011")   
		
		(cAlias)->( DbSkip() )
	
	EndDo
	
	(cAlias)->( dbCloseArea() ) // Fecha a tabela depois de usar ela.
	
	MsgRun("Aguarde .... Estornando nota do romaneio.","INOVEN - Avisos", { || U_IFATM001("","",2)} )

	MsgRun("Aguarde .... Estornando apontamentos das etiquetas.","INOVEN - Avisos", { || TFatEtqDel()} )

	RestArea(aArea)	

Return .T.


/*********************************************************************************************/
/*/ TFatEtqDel

@description Realiza o estorno dos apontamentos da etiqueta 

@type function
/*/
/*********************************************************************************************/
Static Function TFatEtqDel()
Local aArea	:= GetArea()

Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZA.R_E_C_N_O_ RECNOZZA " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZA") + " ZZA " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZA.ZZA_FILIAL = '" + xFilial("ZZA") + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_NFSAID = '" + SF2->F2_DOC + "' AND " + CRLF 
cQuery += "		ZZA.ZZA_SERSAI = '" + SF2->F2_SERIE + "' AND " + CRLF 
cQuery += "		ZZA.D_E_L_E_T_ = ' ' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

(cAlias)->(dbGoTop())
While !(cAlias)->(eof())
	ZZA->( dbGoTo((cAlias)->RECNOZZA) )
	ZZA->(RecLock("ZZA",.F.))
	//ZZA->( dbDelete() )
	ZZA->ZZA_NFSAID := ''
	ZZA->ZZA_SERSAI	:= ''
	ZZA->ZZA_BAIXA	:= '1'
	ZZA->( MsUnLock() )	
	(cAlias)->(dbSkip())
End
RestArea(aArea)
Return .T.
