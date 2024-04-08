User Function TstMrkOpcoes()	//Inclua a chamada desta funcao no Menu Para Testar

	CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	OpcMotAbo()		//Chamada a Static Function para Carregas as Opcoes de Motivo de Abono para Selecao

	//CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	//OpcFunc()		//Chamada a Static Function para Carregas as Opcoes de Funcionarios para Selecao

	/*CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	OpcCadVerbas()	//Chamada a Static Function para Carregas as Opcoes de Verbas para Selecao

	CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	OpcRegraApo()	//Chamada a Static Function para Carregas as Opcoes de Regra de Apontamento 
	
	CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	OpcEventos()	//Chamada a Static Function para Carregas as Opcoes de Eventos do Ponto
	
	CursorWait()	//Altera o Ponteiro do Cursor do Mouse para estado de espera
	OpcIdPonto()*/	//Chamada a Static Function para Carregas as Opcoes de Identificadores do Ponto a Partir do SX5

Return( NIL )

//Modelo de chamada da U_MrkOpcoes para o Alias SP6
Static Function OpcMotAbo()
Return( U_MrkOpcoes( "QAA" , "QAA_MAT" , "QAA_NOME" , .F. ) )

//Modelo de chamada da U_MrkOpcoes para o Alias SRA
Static Function OpcFunc()
Return( U_MrkOpcoes( "SRA" , "RA_MAT" , "RA_NOME" , .F. ) )

//Modelo de chamada da U_MrkOpcoes para o Alias SRV
Static Function OpcCadVerbas()
Return( U_MrkOpcoes( "SRV" , "RV_COD" , "RV_DESC" , .F. ) )

//Modelo de chamada da U_MrkOpcoes para o Alias SPA
Static Function OpcRegraApo()
Return( U_MrkOpcoes( "SPA" , "PA_CODIGO" , "PA_DESC" , .F. ) )

//Modelo de chamada da U_MrkOpcoes para o Alias SP9
Static Function OpcEventos()
Return( U_MrkOpcoes( "SP9" , "P9_CODIGO" , "P9_DESC" , .F. ) )

//Modelo de chamada da U_MrkOpcoes para o Alias SX5 para os Identificadores do Ponto
Static Function OpcIdPonto()

Local cFilter	:= "X5_FILIAL=='"+xFilial( "SX5" )+"' .and. X5_TABELA=='20'"

Return( U_MrkOpcoes( "SX5" , "X5_CHAVE" , "X5Descri()" , .F. , NIL , cFilter ) )