#INCLUDE 'PROTHEUS.CH'

#DEFINE MAXGETDAD 99999

/**********************************************************************************************/
/*/{Protheus.doc} IEXPA010
	@description Cadastro / Manutenção de Romaneio

/*/
/**********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IEXPA010()
Local pFiltro    	:= { "Em Aberto","Fechados", "Todos" }
Local aParam		:= {}
Local nFiltro       := 0

Private oBrowse	:= Nil
Private aRotina	:= MenuDef()

IF PARAMBOX( {	{3,"Filtrar Romaneios",1,pFiltro,60,"",.T.};
                }, "Defina os parametros para o Filtro", @aParam,,,,,,,,.F.,.T.)

	nFiltro := mv_par01
else
	nFiltro := 3	//Todos
Endif

//---------------------------------+
// Instanciamento da Classe Browse |
//---------------------------------+
oBrowse := FWMBrowse():New()

//------------------+
// Tabela utilizado |
//------------------+
oBrowse:SetAlias("ZZD")

//-------------------+
// Adiciona Legendas |
//-------------------+
oBrowse:AddLegend("ZZD_STATUS == '1' "		,"GREEN"				,"Em Aberto")
oBrowse:AddLegend("ZZD_STATUS == '2' "		,"YELLOW"				,"Em Conferencia")
oBrowse:AddLegend("ZZD_STATUS == '3' "		,"RED"					,"Encerrado")

//------------------+
// Titulo do Browse |
//------------------+
oBrowse:SetDescription('Romaneios de Saida')

//Filtrando os dados
if nFiltro <> 3	//Caso filtre algum romaneio
	Do Case
		Case nFiltro == 1; oBrowse:SetFilterDefault("ZZD->ZZD_STATUS $ '1|2'")
		Case nFiltro == 2; oBrowse:SetFilterDefault("ZZD->ZZD_STATUS == '3'")
	EndCase
endif

//--------------------+
// Ativação do Browse |
//--------------------+
oBrowse:Activate()		
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFATA02A
	@description Manutenção de Romaneio de Saída
/*/
/*******************************************************************************************/
User Function TFATA02A(cAlias,nReg,nOpc)
Local aArea			:= GetArea()
Local aSize 		:= MsAdvSize()
Local aObjects 		:= {}
Local aPosObj  		:= {}
Local aPosGet		:= {}

Local cCadastro 	:= "INOVEN - Romaneio"
Local cUserAut		:= GetNewPar("TG_ROMUSR","000000")

Local nOpcA			:= 0

Local bColorList	:= &("{|| TFatACorBrw(@aCorRgb,1) }")
Local bLinOk		:= {|| u_TFat02LiOk()}
Local bTudoOk		:= {|| u_TFat02TdOk(nOpc)}
		
Local oDlg			:= Nil
Local oFwLayer		:= Nil
Local oPanel1		:= Nil
Local oPanel2		:= Nil
Local oBmpCl		:= Nil
Local oSayCl		:= Nil

Private oGetDad		:= Nil
Private oEncRom		:= Nil

Private aHeader		:= {}
Private aCols		:= {}
Private aCorRgb		:= { { Rgb(255,165,0)	, Nil , 'Orange' },{ Rgb(255,250,250) , Nil , 'Snow' }}

Private aTela[0][0]
Private aGets[0]

Private _lMotorista	:= .F.

//---------------------------------------------+
// Valida a alteração de romaneio já encerrado |
//---------------------------------------------+
If nOpc == 4 .And. ! Alltrim(__cUserID) $ Alltrim(cUserAut) .And. ZZD->ZZD_STATUS == "3"
	MsgStop("Usuário não autorizado a alterar romaneio.","INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

//-------------------------------------------------------------+
// Valida a Exclusao de Romaneio em conferencia ou ja COnferido|
//-------------------------------------------------------------+
If nOpc == 5 .And. ZZD->ZZD_STATUS $ "3|2"
	MsgStop("Não é possivel excluir Romaneio conferido ou em Conferencia.","INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

//-----------------------------------------+
// Coordenadas da Tela, conforme resolução |
//-----------------------------------------+ 
aAdd( aObjects, { 100, 100, .T., .T. } )
aAdd( aObjects, { 315,  70, .T., .T. } )

aInfo	:= { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj	:= MsObjSize( aInfo, aObjects, .F. )
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{ 	{1.4,45,310.4}			,;	// Itens do Romaneio - MsGetDados
												{3.5,0.5,5.2}			,;	// Legendas Clientes	
												{48.3,10,48}			})	// Descrição Legendas
	
//---------------------------------+
// Carrega as variaveis em Memória |
//---------------------------------+
RegToMemory("ZZD", IIF(nOpc == 3,.T.,.F.) )

//------------+
// Cria aCols |
//------------+
TFatA02Head()

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //STYLE nOr(WS_VISIBLE,WS_POPUP)

oDlg:lMaximized := .T.

//--------------+
// Painel Layer |
//--------------+
oFwLayer := FwLayer():New()
oFwLayer:Init(oDlg,.F.)

//------------+
// 1o. Painel |   
//------------+
oFWLayer:addLine("CABECOPV",045, .T.)
oFWLayer:addCollumn( "COLCABPV",100, .T. , "CABECOPV")
oFWLayer:addWindow( "COLCABPV", "WINENT", "Romaneio Saida", 100, .F., .F., , "CABECOPV") 
oPanel1 := oFWLayer:GetWinPanel("COLCABPV","WINENT","CABECOPV")

//-------------------+
// Dados do Romaneio |
//-------------------+
oEncRom := 	MsMGet():New("ZZD", nReg, nOpc	, , , , , {aPosObj[1,2],aPosObj[1,2],aPosObj[1,3] - 55,aPosObj[1,4] - 8}, , , , , , oPanel1,,,,,,,,,,,,.T.)

//------------+
// 2o. Painel |   
//------------+
oFWLayer:addLine("ITPVECO",045, .T.)
oFWLayer:addCollumn( "COLITPVECO",100, .T. , "ITPVECO")
oFWLayer:addWindow( "COLITPVECO", "WINENT", "Notas Fiscais", 100, .F., .F., , "ITPVECO") 
oPanel2 := oFWLayer:GetWinPanel("COLITPVECO","WINENT","ITPVECO")

//----------------------------------+
// Criacao da GetDados Itens Pedido |
//----------------------------------+
oGetDad 	:= MsNewGetDados():New(aPosGet[1,1] - 2 ,aPosGet[1,1] - 2,aPosGet[1,2] ,aPosGet[1,3] + 5 ,GD_INSERT+GD_UPDATE+GD_DELETE,bLinOk,bTudoOk,/*cIniCpos*/,/*aAlterGda*/,/*nFreeze*/,MAXGETDAD,/*cFieldOk*/,/*cSuperDel*/,/*cDelOk*/,oPanel2,aHeader,aCols)
oGetDad:oBrowse:SetBlkBackColor(bColorList)

//---------+
// Legenda |
//---------+
oBmpCl		:= TBitmap():New( aPosGet[2,1], aPosGet[2,2], 015, 015, "PMSTASK5.PNG", /*cBmpFile*/, /*lNoBorder*/, oPanel2, /*bLClicked*/, /*bRClicked*/, /*lScroll*/, /*lStretch*/, /*oCursor*/, /*uParam14*/, /*uParam15*/, /*bWhen*/, /*lPixel*/, /*bValid*/, /*uParam19*/, /*uParam20*/, /*uParam21*/ )
oSayCl 		:= TSay():New( aPosGet[3,1], aPosGet[3,2], {|| "Cliente com Agendamento " } ,oPanel2 ,, /*oFont2*/ ,,,, .T. ,,, 080,008 )

	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg , {||nOpca := 1,IIF(Obrigatorio(aGets,aTela) .And. u_TFat02TdOk(nOpc) ,oDlg:End(),nOpcA := 0) } , {|| oDlg:End() } )

//--------------------------------+
// Realiza a gravação do Romaneio | 
//--------------------------------+
If nOpcA == 1
	Begin Transaction 
		MsgRun("Aguarde .... Gravando dados do Romaneio.","INOVEN - Avisos", { || TFatA02Grv(nOpc)} )
	End Transaction 
EndIf

RestArea(aArea)
Return .T. 
/*********************************************************************************************/
/*/{Protheus.doc} TFatA02Grv
	@description Realiza a gravação manutenção dos romaneios 
/*/
/*********************************************************************************************/
Static Function TFatA02Grv(nOpc)
Local aArea		:= GetArea()

Local _cCodMot	:= ""

Local nX 		:= 0
Local nItem		:= 0
Local nHead		:= 0
Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPStatus	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_STATUS"})

Local lInclui	:= IIF(nOpc == 3,.T.,.F.)
Local lAltera	:= IIF(nOpc == 4,.T.,.F.)
Local lExclui	:= IIF(nOpc == 5,.T.,.F.)
Local lVisual	:= IIF(nOpc == 2,.T.,.F.)
Local lGrava	:= IIF(nOpc == 3,.T.,.F.)

//----------------------+
// Somente visualização |
//----------------------+
If lVisual
	RestArea(aArea)
	Return .T.
EndIf

//------------------+
// Grava / Atualiza |
//------------------+
If lInclui .Or. lAltera

	//-------------------------+
	// Atualiza dados Enchoice |
	//-------------------------+
	dbSelectArea("ZZD")
	RecLock("ZZD",lGrava)
		For nX := 1 To fCount()
			IF FieldName(nX) # 'ZZD_FILIAL/ZZD_STATUS'
				FieldPut(nX, &('M->' + FieldName(nX)))
			EndIF
		Next nX
		ZZD->ZZD_FILIAL := xFilial("ZZD")
		If lInclui  
			ZZD->ZZD_STATUS	:= "1"
		EndIf	
	ZZD->( MsUnLock() )
	
	//-----------------+
	// Posiciona Itens |
	//-----------------+
	dbSelectArea("ZZE")
	ZZE->( dbSetOrder(1) )
			
	//-------------------------+
	// Atualiza dados do Acols |
	//-------------------------+
	For nItem := 1 To Len(oGetDad:aCols)
	
		//-------------------------------+
		// Valida se linha está deletada | 
		//-------------------------------+
		If oGetDad:aCols[nItem][Len(oGetDad:aHeader) + 1]
		
			//---------------------------+
			// Deleta registro existente |
			//---------------------------+
			If ZZE->( dbSeek(xFilial("ZZE") + M->ZZD_CODIGO + oGetDad:aCols[nItem][nPNota] + oGetDad:aCols[nItem][nPSerie]  ) )
				RecLock("ZZE",.F.)
					ZZE->( dbDelete() )
				ZZE->( MsUnLock() )	
				
				//----------------------+
				// Atualiza Nota/Pedido |
				//----------------------+
				//TFatA02NfPed(oGetDad:aCols[nItem][nPNota],oGetDad:aCols[nItem][nPSerie],oGetDad:aCols[nItem][nPCliente],oGetDad:aCols[nItem][nPLoja],oGetDad:aCols[nItem][nPFrete],2)
			Else
				Loop
			EndIf
		Else
			//------------------+
			// Valida resgistro |
			//------------------+
			lGrava	:= .T.
			If ZZE->( dbSeek(xFilial("ZZE") + M->ZZD_CODIGO + oGetDad:aCols[nItem][nPNota] + oGetDad:aCols[nItem][nPSerie]  ) )
				lGrava := .F.
			EndIf
			
			//-------------------------------+
			// Efetua a Gravação/Atualização |
			//-------------------------------+
			RecLock("ZZE",lGrava)
			
				For nHead:= 1 To Len(oGetDad:aHeader)
					If !Alltrim(oGetDad:aHeader[nHead][2]) $ "ZZE_FILIAL/ZZE_CODIGO/ZZE_STATUS"
						ZZE->( FieldPut(FieldPos(Alltrim(oGetDad:aHeader[nHead][2])),oGetDad:aCols[nItem][nHead]))
					EndIf	
				Next nHead
				
				ZZE->ZZE_FILIAL := xFilial("ZZE")
				ZZE->ZZE_CODIGO := M->ZZD_CODIGO
				ZZE->ZZE_STATUS := oGetDad:aCols[nItem][nPStatus]
				
			ZZE->( MsUnLock() )
			
			//----------------------+
			// Atualiza Nota/Pedido |
			//----------------------+
			//TFatA02NfPed(oGetDad:aCols[nItem][nPNota],oGetDad:aCols[nItem][nPSerie],oGetDad:aCols[nItem][nPCliente],oGetDad:aCols[nItem][nPLoja],oGetDad:aCols[nItem][nPFrete],1)
			
		EndIf
	Next nItem

	//------------------------------+	
	// Valida cadastro de motorista | 
	//------------------------------+
	If _lMotorista
		u_TFatA02Mot(@_cCodMot)
		If !Empty(_cCodMot)
			RecLock("ZZD",.F.)
				ZZD->ZZD_MOTORI := _cCodMot
			ZZD->( MsUnLock() )
		EndIf
	EndIf

//----------------------------------------+
// Caso seja somente exlcusão de registro |
//----------------------------------------+	
ElseIf lExclui

	//-------------------------+
	// Delete Itens do Romaneio|
	//-------------------------+
	For nItem := 1 To Len(oGetDad:aCols)
		If ZZE->( dbSeek(xFilial("ZZE") + M->ZZD_CODIGO + oGetDad:aCols[nItem][nPNota] + oGetDad:aCols[nItem][nPSerie]  ) )
			RecLock("ZZE",.F.)
				ZZE->( dbDelete() )
			ZZE->( MsUnLock() )
			//----------------------+
			// Atualiza Nota/Pedido |
			//----------------------+
			//TFatA02NfPed(oGetDad:aCols[nItem][nPNota],oGetDad:aCols[nItem][nPSerie],oGetDad:aCols[nItem][nPCliente],oGetDad:aCols[nItem][nPLoja],oGetDad:aCols[nItem][nPFrete],2)
		EndIf	
	Next nItem
	
	//-----------------+
	// Deleta Romaneio |
	//-----------------+
	dbSelectArea("ZZD")
	ZZD->( dbSetOrder(1) )
	ZZD->( dbSeek(xFilial("ZZD") + M->ZZD_CODIGO) )
	RecLock("ZZD",.F.)
		ZZD->( dbDelete() )
	ZZD->( MsUnLock() )

EndIf

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatA02NfPed
	@description Realiza a Gravação / Estorno - Da Transportadora e Frete
/*/
/*******************************************************************************************/
Static Function TFatA02NfPed(cNota,cSerie,cCliente,cLoja,nVlrFrete,nOpcX)
Local aArea		:= GetArea()

Local cPedVen	:= ""

//-------------+
// Nota Fiscal | 
//-------------+
dbSelectArea("SF2")
SF2->( dbSetOrder(1) )

//-----------------+
// Pedido de Venda |
//-----------------+
dbSelectArea("SC5")
SC5->( dbSetOrder(1) )

//-------------------------------+
// Atualiza dados da Nota Fiscal |
//-------------------------------+
If !SF2->( dbSeek(xFilial("SF2") + cNota + cSerie + cCliente + cLoja) )
	MsgInfo("Nota não encontrada.","INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

//-------------------------+
// Retorna Pedido de venda |
//-------------------------+
TFatAPedV(cNota,cSerie,cCliente,cLoja,@cPedVen)

//-------------------------+
// Atuliza dados do Pedido |
//-------------------------+
If !SC5->( dbSeek(xFilial("SC5") + cPedVen) )
	MsgInfo("Pedido não encontrado.","INOVEN - Avisos")
	RestArea(aArea)
	Return .F.
EndIf

//-----------------------+
// Realiza a atualização |
//-----------------------+
If nOpcX == 1
	//---------------+
	// Nota de Saida | 
	//---------------+
	RecLock("SF2",.F.)
		SF2->F2_FRETE	:= nVlrFrete
	SF2->( MsUnLock() )	
	
	//--------------------------+
	// Atualiza Pedido de Venda |
	//--------------------------+
	RecLock("SC5",.F.)
		SC5->C5_FRETE	:= nVlrFrete
	SC5->( MsUnLock() ) 
	
//-------------------+
// Realiza a Estorno |
//-------------------+
ElseIf nOpcX == 2
	
	//---------------+
	// Nota de Saida | 
	//---------------+
	RecLock("SF2",.F.)
		SF2->F2_FRETE	:= 0
	SF2->( MsUnLock() )	
	
	//--------------------------+
	// Atualiza Pedido de Venda |
	//--------------------------+
	RecLock("SC5",.F.)
		SC5->C5_FRETE	:= 0
	SC5->( MsUnLock() ) 
	
EndIf

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatAPedV
	@description Retorna numero do pedido de venda
/*/
/*******************************************************************************************/
Static Function TFatAPedV(cNota,cSerie,cCliente,cLoja,cPedVen)
Local aArea	:= GetArea()

//-------------------------------+
// Posiciona Itens Nota de Saida |
//-------------------------------+
dbSelectArea("SD2")
SD2->( dbSetOrder(3) )
If SD2->( dbSeek(xFilial("SD2") + cNota + cSerie + cCliente + cLoja) )
	cPedVen := SD2->D2_PEDIDO
EndIf

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat02LiOk
	@description Valida linha digitada no Acols 
/*/
/*******************************************************************************************/
User Function TFat02LiOk()
Local lRet		:= .T.

Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPLoja	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
Local nPStatus	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_STATUS"})
Local nLin		:= oGetDad:nAt

Local cNota		:= oGetDad:aCols[nLin][nPNota]
Local cSerie	:= oGetDad:aCols[nLin][nPSerie]
Local cCliente	:= oGetDad:aCols[nLin][nPCliente]
Local cLoja		:= oGetDad:aCols[nLin][nPLoja]
Local cCodRom	:= ""

//----------------+
// Linha Deletada |
//----------------+ 
If oGetDad:aCols[nLin][Len(aHeader) + 1 ]
	If oGetDad:aCols[nLin][nPStatus] == "3"
		MsgInfo("Não é permitido deletar notas já conferidas.","INOVEN - Avisos")
		Return .F.
	Endif
EndIf

//--------------------+
// Valida duplicidade |
//--------------------+
If TFatLiOkDupli(cNota,cSerie,cCliente,cLoja,nLin)
	MsgInfo("Nota já informada","INOVEN - Avisos")
	Return .F. 
EndIf

//---------------------------------------------+
// Valida se Nota já pertence a outro romaneio | 
//---------------------------------------------+
If TFatLiOkRom(cNota,cSerie,cCliente,cLoja,@cCodRom)
	MsgInfo("Nota pertencente ao romaneio " + cCodRom + ". Não será possivel utiliza-lá neste romaneio.","INOVEN - Avisos")
	Return .F. 
EndIf

//------------------------------------------+
// Valida se nota fiscal movimenta estoque  |
//------------------------------------------+
If !TFatLiOkEst(cNota,cSerie,cCliente,cLoja)
	MsgInfo("Não é permitido inserir notas que não movimentam estoque.","INOVEN - Avisos")
	Return .F. 
EndIf

//---------------+
// Soma Total NF |
//---------------+
TFatLiOkTNf()
 
Return lRet 

/*******************************************************************************************/
/*/{Protheus.doc} TFatLiOkDupli
	@description Valida duplicidade de Itens
/*/
/*******************************************************************************************/
Static Function TFatLiOkDupli(cNota,cSerie,cCliente,cLoja,nLin)
Local lRet		:= .F.

Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPLoja	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
Local nX		:= 0

For nX := 1 To Len(oGetDad:aCols)
	If nLin <> nX
		If cNota + cSerie + cCliente + cLoja == oGetDad:aCols[nX][nPNota] + oGetDad:aCols[nX][nPSerie] + oGetDad:aCols[nX][nPCliente] + oGetDad:aCols[nX][nPLoja]
			lRet := .T.
			Exit
		EndIf
	EndIf
Next nX

Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFatLiOkRom
	@description Valida se nota pertence a outro romaneio 
/*/
/*******************************************************************************************/
Static Function TFatLiOkRom(cNota,cSerie,cCliente,cLoja,cCodRom)
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZE.ZZE_CODIGO " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZE") + " ZZE " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_NOTA = '" + cNota + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_SERIE = '" + cSerie + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_CODCLI = '" + cCliente + "' AND " + CRLF
cQuery += "		ZZE.ZZE_LOJA = '" + cLoja + "' AND " + CRLF
cQuery += "		ZZE.ZZE_CODIGO <> '" + M->ZZD_CODIGO + "' AND " + CRLF
cQuery += "		ZZE.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .F.
EndIf

cCodRom := (cAlias)->ZZE_CODIGO

(cAlias)->( dbCloseArea() )

RestArea(aArea)
Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatLiOkEst
	@description  Valida se nota movimenta estoque 
/*/
/*******************************************************************************************/
Static Function TFatLiOkEst(cNota,cSerie,cCliente,cLoja)
Local cAliasD2	:= GetNextAlias()
Local cQuery	:= ""

cQuery := "	SELECT " + CRLF 
cQuery += "		D2.D2_DOC, " + CRLF
cQuery += "		D2.D2_SERIE, " + CRLF
cQuery += "		D2.D2_CLIENTE, " + CRLF
cQuery += "		D2.D2_LOJA " + CRLF	
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("SD2") + " D2 " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SF4") + " F4 ON F4.F4_FILIAL = '" + xFilial("SF4") + "' AND F4.F4_CODIGO = D2.D2_TES AND F4.F4_ESTOQUE ='S' AND F4.D_E_L_E_T_ = '' " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		D2.D2_FILIAL = '" + xFilial("SD2") + "' AND " + CRLF 
cQuery += "		D2.D2_DOC = '" + cNota + "' AND " + CRLF
cQuery += "		D2.D2_SERIE = '" + cSerie + "' AND " + CRLF
cQuery += "		D2.D2_CLIENTE = '" + cCliente + "' AND " + CRLF
cQuery += "		D2.D2_LOJA = '" + cLoja + "' AND " + CRLF
cQuery += "		D2.D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY D2.D2_DOC,	D2.D2_SERIE, D2.D2_CLIENTE, D2.D2_LOJA "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasD2,.T.,.T.)

If (cAliasD2)->( Eof() )
	(cAliasD2)->( dbCloseArea() )
	Return .F.
EndIf

(cAliasD2)->( dbCloseArea() )

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFatLiOkTNf
	@description Soma total das NF
	@author  M. Margarido
	@since 17/04/ 2021
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
Static Function TFatLiOkTNf(nLin)
Local nPVlrNf	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLFNF"})
Local nPFrete	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLRFRT"})
Local nPFrtCom	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_FRTCOM"})
Local nX		:= 0

Local nTotNF	:= 0
Local nTotFrt	:= 0
Local nTotFrtC	:= 0

For nX := 1 To Len(oGetDad:aCols)
	If oGetDad:aCols[nX][Len(oGetDad:aHeader) + 1]
		Loop
	EndIf 
	nTotNF 	+= oGetDad:aCols[nX][nPVlrNf]
	nTotFrt	+= oGetDad:aCols[nX][nPFrete]
	nTotFrtC+= oGetDad:aCols[nX][nPFrtCom]
Next nX

//-------------------------------+
// Atualiza dados no valor da NF |
//-------------------------------+
M->ZZD_VLRNF  := nTotNF
M->ZZD_VLRFRT := nTotFrt
M->ZZD_VLRFRC := nTotFrtC

oEncRom:Refresh()

Return .T.

/*******************************************************************************************/
/*/{Protheus.doc} TFat02TdOk
	@description Realiza a validação dos itens
	@author INOVEN
	@since 17/04/ 2021
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
User Function TFat02TdOk(nOpc)
Local lRet		:= .T.

Local nPNota	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPLoja	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
Local nPStatus	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_STATUS"})
Local nLin		:= 0

Local cCodRom	:= ""

If nOpc == 2
	Return .T.	
EndIf

//---------------------------+
// Valida dados do motorista |
//---------------------------+
If Empty(M->ZZD_MOTORI) .And. ( !Empty(M->ZZD_DESCMO) .Or. !Empty(M->ZZD_CNH) ) 
	If MsgNoYes("Foram informado dados do motorista no romaneio. Deseja cadastra-los ? ","INOVEN - Avisos")
		_lMotorista := .T.
	EndIf
EndIf

//--------------------------+
// Valida itens do Romaneio |
//--------------------------+
For nLin := 1 To Len(oGetDad:aCols)
	
	//----------------+
	// Linha Deletada |
	//----------------+
	If oGetDad:aCols[nLin][Len(oGetDad:aHeader) + 1 ]
		If oGetDad:aCols[nLin][nPStatus] == "3"
			MsgInfo("Não é permitido deletar notas já conferidas.","INOVEN - Avisos")
			Return .F.
		Else	
			Loop
		EndIf	
	EndIf
	
	cNota		:= oGetDad:aCols[nLin][nPNota]
	cSerie		:= oGetDad:aCols[nLin][nPSerie]
	cCliente	:= oGetDad:aCols[nLin][nPCliente]
	cLoja		:= oGetDad:aCols[nLin][nPLoja]
	
	//--------------------+
	// Valida duplicidade |
	//--------------------+
	If TFatLiOkDupli(cNota,cSerie,cCliente,cLoja,nLin)
		MsgInfo("Nota já informada","INOVEN - Avisos")
		Return .F. 
	EndIf
	
	//---------------------------------------------+
	// Valida se Nota já pertence a outro romaneio | 
	//---------------------------------------------+
	If TFatLiOkRom(cNota,cSerie,cCliente,cLoja,@cCodRom)
		MsgInfo("Nota pertencente ao romaneio " + cCodRom + ". Não será possivel utiliza-lá neste romaneio.","INOVEN - Avisos")
		Return .F. 
	EndIf
	
Next nLin	

//---------------+
// Soma Total NF |
//---------------+
TFatLiOkTNf()

Return lRet 

/*******************************************************************************************/
/*/{Protheus.doc} TFat02Fret
	@description Calcula frete informado 
	@author INOVEN
	@since 18/04/ 2021
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
User Function TFat02Fret()
Local lRet		:= .T.

Local nPVlrNF	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLFNF"})
Local nPPerFrt	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_PFRETE"})
Local nPFrete	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLRFRT"})
Local nPFrtCom	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_FRTCOM"})
Local nTotFrt	:= 0
Local nTotFrete	:= 0
Local nPerFrt	:= 0
Local nVlrFrete	:= 0 
Local nVlrFrtCo	:= 0
Local nTotComp	:= 0
Local nX		:= 0
Local nLin		:= oGetDad:nAt

//--------------------------------+
// Grava valor de frete informado |
//--------------------------------+
If ReadVar() == "M->ZZE_VLRFRT"
	nVlrFrete	:= M->ZZE_VLRFRT
	nVlrFrtCo	:= oGetDad:aCols[nLin][nPFrtCom]
	nTotFrt 	+= M->ZZE_VLRFRT
	nTotComp	+= oGetDad:aCols[nLin][nPFrtCom]
ElseIf ReadVar() == "M->ZZE_FRTCOM"	
	nVlrFrtCo	:= M->ZZE_FRTCOM
	nVlrFrete	:= oGetDad:aCols[nLin][nPFrete]
	nTotComp	+= M->ZZE_FRTCOM
	nTotFrt		+= oGetDad:aCols[nLin][nPFrete]
EndIf	

//-------------------+
// Calcula os fretes |
//-------------------+
For nX := 1 To Len(oGetDad:aCols)
	If nX <> nLin
		nTotFrt += oGetDad:aCols[nX][nPFrete]
		nTotComp+= oGetDad:aCols[nX][nPFrtCom]
	EndIf	
Next nX

//-------------------------+
// Total do Frete Enchoice |
//-------------------------+
M->ZZD_VLRFRT 	:= nTotFrt
M->ZZD_VLRFRC	:= nTotComp

//-------------------------------------------+
// Poercetual do frete sobre o total da Nota |
//-------------------------------------------+
nTotFrete 	:= nVlrFrete
nPerFrt		:= Round( ( nTotFrete / oGetDad:aCols[nLin][nPVlrNF] ) * 100,2)

oGetDad:aCols[nLin][nPPerFrt] :=  nPerFrt
M->ZZE_PFRETE	:= nPerFrt

//-------------------+
// Realiza o Refresh |  
//-------------------+
If ValType(oGetDad) == "O"
	oGetDad:Refresh()
EndIf	

If ValType(oEncRom) == "O"
	oEncRom:Refresh()
EndIf	
	
Return lRet

/*******************************************************************************************/
/*/{Protheus.doc} TFatA02Head
	@description Monta aHeader e aCols das Notas de Saida 
	@author INOVEN
	@since / / 
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
Static Function TFatA02Head()
Local aArea	:= GetArea()

Local nX	:= 0

//---------------------+
// Grava aHeader Itens |   
//---------------------+
dbSelectArea("SX3")
SX3->( dbSetOrder(1) )
If SX3->( dbSeek("ZZE") )
	While SX3->( !Eof() .And. SX3->X3_ARQUIVO == "ZZE" )
		If X3USO(X3_USADO) .and. alltrim(SX3->X3_CAMPO) <> "ZZE_CODIGO"
			AAdd(aHeader,{	AllTrim(	X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT;
							})
			EndIf
			SX3->(dbSkip())
		EndDo	
	EndIf
	
	If !INCLUI
		dbSelectArea("ZZE")
		ZZE->( dbSetOrder(1) )
		If ZZE->(dbSeek(xFilial("ZZE") + ZZD->ZZD_CODIGO) )
			While ZZE->( !Eof() .And. xFilial("ZZE") + ZZD->ZZD_CODIGO == ZZE->( ZZE_FILIAL + ZZE_CODIGO) )
				aAdd(aCols,Array(Len(aHeader)+1)) 
				For nX:= 1 To Len(aHeader)
					aCols[Len(aCols)][nX] := FieldGet(FieldPos(aHeader[nX][2]))
				Next nX
				aCols[Len(aCols)][Len(aHeader)+1]:= .F.
				ZZE->( dbSkip() )
			EndDo
		EndIf
	EndIf	

	If Len(aCols) <= 0
		aAdd(aCols,Array(Len(aHeader)+1)) 
		For nX:= 1 To Len(aHeader)
			aCols[1][nX]:= CriaVar(aHeader[nX][2],.T.)
		Next nX
		aCols[1][Len(aHeader)+1]:= .F.
	EndIf

RestArea(aArea)
Return Nil

/*******************************************************************************************/
/*/{Protheus.doc} TGFAT01G
	@description Gatilha informações na linha do acols
	@author INOVEN
	@since 17/04/ 2021
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
User Function TGFAT01G(cNota,cSerie)
Local lRet		:= .T.

Local nPNota	:= 0
Local nPSerie	:= 0
Local nPCliente	:= 0
Local nPLoja	:= 0
Local nPNCli	:= 0
Local nPVlrNf	:= 0
Local nLin		:= 0

//-------------------------------+
// Valida se Acols ja foi criado |
//-------------------------------+
If ValType(oGetDad) <> "O"
	Return .T.
EndIf

//---------------------------+
// Posiciona coluna do acols |
//---------------------------+
nPNota		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
nPSerie		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
nPCliente	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
nPLoja		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
nPNCli		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOMCLI"})
nPVlrNf		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLFNF"})
nLin		:= oGetDad:nAt

//-----------------------+
// Posiciona Nota Fiscal |
//-----------------------+
dbSelectArea("SF2")
SF2->( dbSetOrder(1) )
If !SF2->( dbSeek(xFilial("SF2") + oGetDad:aCols[nLin][nPNota] + cSerie))
	MsgInfo("Nota/Serie " + oGetDad:aCols[nLin][nPNota] + "/" + cSerie + " não encontrada","INOVEN - Avisos" )
	Return .F.
EndIf

//-------------------+
// Posiciona Cliente | 
//-------------------+
dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA)  )

//------------------------------------+
// Grava informaçao na linha do Acols |
//------------------------------------+
oGetDad:aCols[nLin][nPCliente]	:= SF2->F2_CLIENTE
oGetDad:aCols[nLin][nPLoja]		:= SF2->F2_LOJA
oGetDad:aCols[nLin][nPNCli]		:= SA1->A1_NOME
oGetDad:aCols[nLin][nPVlrNf]	:= SF2->F2_VALBRUT

If SA1->A1_XAGENDA == "S"
	oGetDad:oBrowse:SetBlkBackColor({|| TFatACorBrw(aCorRgb,1)})
EndIf

oGetDad:Refresh()

Return lRet 

/*******************************************************************************************/
/*/{Protheus.doc} TFatACorBrw
	@description Altera a Cor da Linha do Browser
	@author INOVEN
	@since / / 
	@version 1.0
	@type function
/*/
/*******************************************************************************************/
Static Function TFatACorBrw(aCorRgb,nOrig)

Local nPosCli	:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPosLjCli := aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})

//-------------------+
// Posiciona Cliente |
//-------------------+
dbSelectArea("SA1")
SA1->( dbSetOrder(1) )
SA1->( dbSeek(xFilial("SA1") + oGetDad:aCols[oGetDad:nAt][nPosCli] + oGetDad:aCols[oGetDad:nAt][nPosLjCli] ) )

//----------------------------+
// Cores da Lista de Produtos |
//----------------------------+
If oGetDad:aCols[oGetDad:nAt,Len(oGetDad:aHeader)+1]
	//-----------------------+
	// Cinza quando Deletado |
	//-----------------------+
	Return(Rgb(181,181,181))
ElseIf Empty(oGetDad:aCols[oGetDad:nAt][1])
	//-----------------------+
	// Cinza quando Deletado |
	//-----------------------+
	Return aCorRgb[1,2] 
ElseIf SA1->A1_XAGENDA == "S"
	Return aCorRgb[1,1]
EndIf

Return aCorRgb[1,2]

/************************************************************************************/
/*/{Protheus.doc} TFATA02R
	@description Gera os romaneios para as notas emitidas no dia
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
User Function TFATA02R()

//-----------------------------------------+
// Consulta Notas e Transportadoras do dia | 
//-----------------------------------------+
MsAguarde({|lEnd| TFatA02RCria()},"INOVEN - Avisos","Aguarde gerando romaneios do dia.")

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02RCria
	@description Realiza a geração do Romaneio 
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
Static Function TFatA02RCria()
Local aArea		:= GetArea()

Local cAlias	:= GetNextAlias()
Local cRomaneio	:= ""
Local cCodTransp:= ""

Local nTotFat	:= 0
 
//--------------------------+
// Consulta as nota dos dia |
//--------------------------+
If !TFatA02RQry(cAlias)
	MsgStop("Nao existem dados para serem processados.")
	RestArea(aArea)
	Return .T.
EndIf

//--------------------------------+
// Abre tabela de transportadoras |
//--------------------------------+
dbSelectArea("SA4")
SA4->( dbSetOrder(1) )

//-------------------------+
// Abre tabela de romaneio | 
//-------------------------+
dbSelectArea("ZZD")

//-------------------------------+
// Abre tabela itens de romaneio | 
//-------------------------------+
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )

//----------------------------------------+
// Inicia processo de geração de Romaneio |
//----------------------------------------+
While (cAlias)->( !Eof() )
	
	//-----------------------+
	// Variaveis do Romaneio | 
	//-----------------------+
	cRomaneio 	:= u_TFatA02NumR()
	cCodTransp	:= (cAlias)->F2_TRANSP
	nTotFat		:= 0
	
	//--------------------------+
	// Posicioba Transportadora |
	//--------------------------+
	SA4->( dbSeek(xFilial("SA4") + cCodTransp) )
	
	//-----------------------------------------------------------------------+
	// Valida se ja existe romaneio para a transportadora com a data de hoje |
	//-----------------------------------------------------------------------+
	// ### COMENTADO PELO CHARLES PARA PERMITIR MAIS DE UM ROMANEIO PARA TRANSP POR DIA. ####
	
	//ZZD->( dbSetOrder(2) )
	//If ZZD->( dbSeek(xFilial("ZZD") + cCodTransp + dTos( Date() ) ) )
	//	(cAlias)->( dbSkip() )
	//	Loop
	//EndIf	
	
	//-----------------------------------------+
	// Inicia a gravação das notas no romaneio | 
	//-----------------------------------------+
	While (cAlias)->( !Eof() .And. cCodTransp == (cAlias)->F2_TRANSP )
	
		//--------------------+
		// Mensagem progresso |
		//--------------------+
		MsProcTxt(" Gerando Romaneio Transportadora " + Alltrim(SA4->A4_NOME) )
		
		//------------------------+
		// Gera Itens do Romaneio | 
		//------------------------+
		nTotFat+= (cAlias)->F2_VALBRUT
		TFatA02Item(	cRomaneio,(cAlias)->F2_DOC,(cAlias)->F2_SERIE,;
						(cAlias)->F2_CLIENTE,(cAlias)->F2_LOJA,;
						(cAlias)->A1_NOME,(cAlias)->F2_VALBRUT)
		
		(cAlias)->( dbSkip() )
		
	EndDo
	
	//-------------------------+
	// Gera cabeçalho Romaneio |
	//-------------------------+
	TFatA02Cab(cRomaneio,cCodTransp,nTotFat)

EndDo

//--------------------+
// Encerra temporario |
//--------------------+
(cAlias)->( dbCloseArea() )


//PROCESSAMENTO PARA CLIENTE RETIRA
//----------------------------------------+
// Inicia processo de geração de Romaneio |
//----------------------------------------+
While RETIRA->( !Eof() )
	
	//-----------------------+
	// Variaveis do Romaneio | 
	//-----------------------+
	cRomaneio 	:= u_TFatA02NumR()
	cCodTransp	:= RETIRA->F2_TRANSP
	cCodClient	:= RETIRA->F2_CLIENTE
	cLojaCli	:= RETIRA->F2_LOJA
	nTotFat		:= 0
	
	//--------------------------+
	// Posicioba Cliente        |
	//--------------------------+
	SA1->( dbSeek(xFilial("SA1") + cCodClient + cLojaCli) )
	
	//-----------------------------------------+
	// Inicia a gravação das notas no romaneio | 
	//-----------------------------------------+
	While RETIRA->( !Eof() .And. cCodClient + cLojaCli == RETIRA->F2_CLIENTE + RETIRA->F2_LOJA )
	
		//--------------------+
		// Mensagem progresso |
		//--------------------+
		MsProcTxt(" Gerando Romaneio Cliente " + Alltrim(SA1->A1_NOME) )
		
		//------------------------+
		// Gera Itens do Romaneio | 
		//------------------------+
		nTotFat+= RETIRA->F2_VALBRUT
		TFatA02Item(	cRomaneio,RETIRA->F2_DOC,RETIRA->F2_SERIE,;
						RETIRA->F2_CLIENTE,RETIRA->F2_LOJA,;
						RETIRA->A1_NOME,RETIRA->F2_VALBRUT)
		
		RETIRA->( dbSkip() )
		
	EndDo
	
	//-------------------------+
	// Gera cabeçalho Romaneio |
	//-------------------------+
	TFatA02Cab(cRomaneio,cCodTransp,nTotFat)

EndDo

//--------------------+
// Encerra temporario |
//--------------------+
RETIRA->( dbCloseArea() )


RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02Item
	@description Grava Itens do Romaneio 
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
Static Function TFatA02Item(cRomaneio,cDoc,cSerie,cCliente,cLoja,cNome,nVlrFat)

RecLock("ZZE",.T.)
	ZZE->ZZE_FILIAL := xFilial("ZZE")
	ZZE->ZZE_CODIGO	:= cRomaneio
	ZZE->ZZE_NOTA  	:= cDoc
	ZZE->ZZE_SERIE 	:= cSerie
	ZZE->ZZE_CODCLI	:= cCliente
	ZZE->ZZE_LOJA  	:= cLoja
	ZZE->ZZE_NOMCLI	:= cNome
	ZZE->ZZE_VLFNF 	:= nVlrFat
	ZZE->ZZE_VLRFRT	:= 0
	ZZE->ZZE_PFRETE	:= 0
	ZZE->ZZE_FRTCOM	:= 0
	ZZE->ZZE_DTENTR	:= Date()
	ZZE->ZZE_HRENTR	:= Time()
	ZZE->ZZE_STATUS	:= "1"
	ZZE->ZZE_PALLET	:= 0
	ZZE->ZZE_CAIXAS	:= 0
ZZE->( MsUnLock() )	

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02GrvCb
	@description Realiza a gravação do cabeçalho
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
/*/
/************************************************************************************/
Static Function TFatA02Cab(cRomaneio,cCodTransp,nTotFat)

RecLock("ZZD",.T.)
	ZZD->ZZD_FILIAL	:= xFilial("ZZD")
	ZZD->ZZD_CODIGO	:= cRomaneio
	ZZD->ZZD_TRANSP	:= cCodTransp
	ZZD->ZZD_MOTORI	:= ""
	ZZD->ZZD_CNH   	:= ""
	ZZD->ZZD_CONFE 	:= ""
	ZZD->ZZD_PLACA 	:= ""
	ZZD->ZZD_DTENTR	:= Date()
	ZZD->ZZD_HRENTR	:= Time()
	ZZD->ZZD_DTSAID	:= cTod("  /  /    ")
	ZZD->ZZD_HRSAID	:= ""	
	ZZD->ZZD_DESPE 	:= 0
	ZZD->ZZD_VLRNF 	:= nTotFat
	ZZD->ZZD_VLRFRT	:= 0
	ZZD->ZZD_QTDCX 	:= 0
	ZZD->ZZD_CUBAG 	:= 0
	ZZD->ZZD_STATUS	:= "1"
	ZZD->ZZD_EMISSA	:= Date()
ZZD->( MsUnLock() )

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02RQry
	@description Consulta notas emitidas para romaneio 
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
Static Function TFatA02RQry(cAlias,lTela)
Local cQuery 	:= "", cQueryR := ""
Local pTransDe  := padR("",tamSx3("F2_TRANSP")[1])
Local pTransAte := repli("Z",tamSx3("F2_TRANSP")[1])
Local pEmisDe   := dDataBase
Local pEmisAte  := dDataBase
Local pCliente  := padR("",tamSx3("F2_CLIENTE")[1])
Local pLoja     := padR("",tamSx3("F2_LOJA")[1])
Local aParam	:= {}

Local cTransDe	:= ''
Local cTransAte	:= ''
Local dEmisDe	:= ctod('')
Local dEmisAte	:= ctod('')
Local cCliente  := ''
Local cLoja		:= ''
Local lParam	:= .F.



Default lTela	:= .F.

if !lTela
	IF PARAMBOX( {	{1,"Emissao De", pEmisDe,"",".T.","","",60,.T.},;
					{1,"Emissao Ate", pEmisAte,"",".T.","","",60,.T.},;
					{1,"Transportadora De", pTransDe,"@!",".T.","SA4","",30,.F.},;
					{1,"Transportadora Ate", pTransAte,"@!",".T.","SA4","",30,.F.},;
					{1,"Cliente", pCliente,"@!",".T.","SA1","",60,.F.},;
					{1,"Loja", pLoja,"@!",".T.","","",30,.F.};
				}, "Defina os parametros para o Filtro", @aParam,,,,,,,,.T.,.T.)
		lParam := .T.

		dEmisDe		:= mv_par01
		dEmisAte	:= mv_par02
		cTransDe	:= mv_par03
		cTransAte	:= mv_par04
		cCliente	:= mv_par05
		cLoja		:= mv_par06

	endif

	if !lParam
		MsgStop("Os parametros não foram informados.","INOVEN - Avisos")
	endif
endif

if !lTela .and. !lParam
	Return .F.
endif

cQuery := "	SELECT " + CRLF 
cQuery += "		F2.F2_TRANSP, " + CRLF
cQuery += "		F2.F2_DOC, " + CRLF
cQuery += "		F2.F2_SERIE, " + CRLF
cQuery += "		F2.F2_CLIENTE, " + CRLF
cQuery += "		F2.F2_LOJA, " + CRLF
cQuery += "		A1.A1_NOME, " + CRLF
cQuery += "		F2.F2_VALBRUT " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("SF2") + " F2 " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SA1") + " A1 ON A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
cQuery += "		INNER JOIN " + RetSqlName("SD2") + " D2 ON D2.D2_FILIAL = '" + xFilial("SD2") + "' AND D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CF <> '5927' AND D2.D_E_L_E_T_ = '' " + CRLF 
cQuery += "		INNER JOIN " + RetSqlName("SF4") + " F4 ON F4.F4_FILIAL = '" + xFilial("SF4") + "' AND F4.F4_CODIGO = D2.D2_TES AND F4.F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_ = '' " + CRLF
cQuery += "	WHERE " + CRLF
/*
cQuery += "	NOT EXISTS (	SELECT " + CRLF 
cQuery += "						ZZE.* " + CRLF
cQuery += "					FROM " + CRLF
cQuery += "						" + RetSqlName("ZZE") + " ZZE " + CRLF  
cQuery += "						INNER JOIN " + RetSqlName("ZZD") + " ZZD ON ZZD.ZZD_FILIAL = '" + xFilial("ZZD") + "' AND ZZD.ZZD_TRANSP = F2.F2_TRANSP AND ZZD.D_E_L_E_T_ = '' " + CRLF
cQuery += "					WHERE " + CRLF 
cQuery += "						ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF 
cQuery += "						ZZE.ZZE_CODIGO = ZZD.ZZD_CODIGO AND " + CRLF
cQuery += "						ZZE.ZZE_NOTA = F2.F2_DOC AND " + CRLF
cQuery += "						ZZE.ZZE_SERIE = F2.F2_SERIE AND " + CRLF
cQuery += "						ZZE.D_E_L_E_T_ = '' " + CRLF
cQuery += "				) AND " + CRLF
*/
cQuery += "		F2.F2_FILIAL = '" + xFilial("SF2") + "' AND " + CRLF
//---------------------------+ 
// Consulta a transportadora |
//---------------------------+
If lTela
	cQuery += "		F2.F2_TRANSP = '" + M->ZZD_TRANSP + "' AND " + CRLF
Else
	cQuery += "		F2.F2_TRANSP <> '' AND " + CRLF

	if lParam
		cQuery += "		F2.F2_TRANSP BETWEEN '" + cTransDe + "' AND '" + cTransAte + "' AND " + CRLF
		cQuery += "		F2.F2_EMISSAO BETWEEN '" + dtos(dEmisDe) + "' AND '" + dtos(dEmisAte) + "' AND F2.F2_EMISSAO > '20210801' AND " + CRLF
		
		If !Empty(cCliente)
			cQuery += "		F2.F2_CLIENTE = '" + cCliente + "' AND F2.F2_LOJA = '" + cLoja + "' AND " + CRLF
		Endif

	endif
EndIf
cQuery += "		F2.F2_TRANSP <> '900000' AND " + CRLF	//DESCONSIDERAR CLIENTE RETIRA
cQuery += "		F2.F2_DOC + F2.F2_SERIE NOT IN ( SELECT " + CRLF
cQuery += "											ZZE.ZZE_NOTA + ZZE.ZZE_SERIE " + CRLF
cQuery += "	                                     FROM " + CRLF
cQuery += "											" + RetSqlName("ZZE") + " ZZE " + CRLF
cQuery += "										 WHERE " + CRLF
cQuery += "											ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF
cQuery += "											ZZE.ZZE_NOTA = F2.F2_DOC AND " + CRLF
cQuery += "											ZZE.ZZE_SERIE = F2.F2_SERIE AND " + CRLF
cQuery += "											ZZE.D_E_L_E_T_ = '' " + CRLF
cQuery += "										) AND " + CRLF
cQuery += "		F2.D_E_L_E_T_ = '' " + CRLF
cQuery += "	GROUP BY F2.F2_TRANSP, F2.F2_DOC, F2.F2_SERIE, F2.F2_CLIENTE, F2.F2_LOJA, A1.A1_NOME, F2.F2_VALBRUT " + CRLF 	
cQuery += "	ORDER BY F2.F2_TRANSP,F2.F2_DOC,F2.F2_SERIE "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//Tratar TRANSPORTADORA CLIENTE RETIRA
lRetira := .F.
If !lTela
	cQueryR := "	SELECT " + CRLF 
	cQueryR += "		F2.F2_TRANSP, " + CRLF
	cQueryR += "		F2.F2_DOC, " + CRLF
	cQueryR += "		F2.F2_SERIE, " + CRLF
	cQueryR += "		F2.F2_CLIENTE, " + CRLF
	cQueryR += "		F2.F2_LOJA, " + CRLF
	cQueryR += "		A1.A1_NOME, " + CRLF
	cQueryR += "		F2.F2_VALBRUT " + CRLF
	cQueryR += "	FROM " + CRLF
	cQueryR += "		" + RetSqlName("SF2") + " F2 " + CRLF
	cQueryR += "		INNER JOIN " + RetSqlName("SA1") + " A1 ON A1.A1_FILIAL = '" + xFilial("SA1") + "' AND A1.A1_COD = F2.F2_CLIENTE AND A1.A1_LOJA = F2.F2_LOJA AND A1.D_E_L_E_T_ = '' " + CRLF
	cQueryR += "		INNER JOIN " + RetSqlName("SD2") + " D2 ON D2.D2_FILIAL = '" + xFilial("SD2") + "' AND D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CF <> '5927' AND D2.D_E_L_E_T_ = '' " + CRLF 
	cQueryR += "		INNER JOIN " + RetSqlName("SF4") + " F4 ON F4.F4_FILIAL = '" + xFilial("SF4") + "' AND F4.F4_CODIGO = D2.D2_TES AND F4.F4_ESTOQUE = 'S' AND F4.D_E_L_E_T_ = '' " + CRLF
	cQueryR += "	WHERE " + CRLF
	cQueryR += "		F2.F2_FILIAL = '" + xFilial("SF2") + "' AND " + CRLF
	//---------------------------+ 
	// Consulta a transportadora |
	//---------------------------+
	cQueryR += "		F2.F2_TRANSP <> '' AND " + CRLF

	if lParam
		cQueryR += "		F2.F2_TRANSP BETWEEN '" + cTransDe + "' AND '" + cTransAte + "' AND " + CRLF
		cQueryR += "		F2.F2_EMISSAO BETWEEN '" + dtos(dEmisDe) + "' AND '" + dtos(dEmisAte) + "' AND F2.F2_EMISSAO > '20210801' AND " + CRLF
		
		If !Empty(cCliente)
			cQueryR += "		F2.F2_CLIENTE = '" + cCliente + "' AND F2.F2_LOJA = '" + cLoja + "' AND " + CRLF
		Endif

	endif
	cQueryR += "		F2.F2_TRANSP = '900000' AND " + CRLF	//DESCONSIDERAR CLIENTE RETIRA
	cQueryR += "		F2.F2_DOC + F2.F2_SERIE NOT IN ( SELECT " + CRLF
	cQueryR += "											ZZE.ZZE_NOTA + ZZE.ZZE_SERIE " + CRLF
	cQueryR += "	                                     FROM " + CRLF
	cQueryR += "											" + RetSqlName("ZZE") + " ZZE " + CRLF
	cQueryR += "										 WHERE " + CRLF
	cQueryR += "											ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF
	cQueryR += "											ZZE.ZZE_NOTA = F2.F2_DOC AND " + CRLF
	cQueryR += "											ZZE.ZZE_SERIE = F2.F2_SERIE AND " + CRLF
	cQueryR += "											ZZE.D_E_L_E_T_ = '' " + CRLF
	cQueryR += "										) AND " + CRLF
	cQueryR += "		F2.D_E_L_E_T_ = '' " + CRLF
	cQueryR += "	GROUP BY F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_DOC, F2.F2_SERIE, A1.A1_NOME, F2.F2_VALBRUT, F2.F2_TRANSP " + CRLF 	
	cQueryR += "	ORDER BY F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_DOC,F2.F2_SERIE "

	If (Select("RETIRA") <> 0)
		dbSelectArea("RETIRA")
		dbCloseArea()
	Endif

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryR),"RETIRA",.T.,.T.)
	lRetira := .T.

	If RETIRA->( Eof() )
	//	RETIRA->( dbCloseArea() )
		lRetira := .F.
	EndIf
ENDIF

If (cAlias)->( Eof() ) .and. !lRetira
	(cAlias)->( dbCloseArea() )
	Return .F.
EndIf

Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02Tr
	@description Carrega notas da transportados no aCols
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
User Function TFatA02Tr()
Local aArea		:= GetArea()

Local cAlias 	:= GetNextAlias()

Local nPNota		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOTA"})
Local nPSerie		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_SERIE"})
Local nPCliente		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_CODCLI"})
Local nPLoja		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_LOJA"})
Local nPNCli		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_NOMCLI"})
Local nPVlrNf		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLFNF"})
Local nPVlrFrt		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_VLRFRT"})
Local nPPerFrt		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_PFRETE"})
Local nPFrtCom		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_FRTCOM"})
Local nPDtaEnt		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_DTENTR"})
Local nPHrEnt		:= aScan(oGetDad:aHeader,{|x| Alltrim(x[2]) == "ZZE_HRENTR"})

//--------------+
// Reseta Array |
//--------------+ 
aCols := {}

//--------------------------------------------+
// Consulta notas referentes a Transportadora |
//--------------------------------------------+
If !TFatA02RQry(cAlias,.T.)
	MsgInfo("Nao foram encontradas notas para a transportadora.","INOVEN - Avisos")
	RestArea(aArea)
	Return .T.
EndIf

While (cAlias)->( !Eof() )
	
	aAdd(aCols,Array(Len(aHeader)+1)) 
	aCols[Len(aCols)][nPNota] 		:= (cAlias)->F2_DOC
	aCols[Len(aCols)][nPSerie] 		:= (cAlias)->F2_SERIE
	aCols[Len(aCols)][nPCliente] 	:= (cAlias)->F2_CLIENTE
	aCols[Len(aCols)][nPLoja] 		:= (cAlias)->F2_LOJA
	aCols[Len(aCols)][nPNCli] 		:= (cAlias)->A1_NOME
	aCols[Len(aCols)][nPVlrNf] 		:= (cAlias)->F2_VALBRUT
	aCols[Len(aCols)][nPVlrFrt] 	:= 0
	aCols[Len(aCols)][nPPerFrt] 	:= 0
	aCols[Len(aCols)][nPFrtCom] 	:= 0
	aCols[Len(aCols)][nPDtaEnt] 	:= Date()
	aCols[Len(aCols)][nPHrEnt] 		:= Time()
	aCols[Len(aCols)][Len(aHeader)+1]:= .F.
	
	(cAlias)->( dbSkip() )
EndDo

//--------------------+
// Encerra temporario |
//--------------------+
(cAlias)->( dbCloseArea() )

//---------------+
// Atualiza Grid |
//---------------+
If ValType(oGetDad) == "O"
	oGetDad:aCols := aClone(aCols)
	oGetDad:Refresh()
EndIf

RestArea(aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFatA02NumR
	@description Retorna numero do romaneio 
	@author INOVEN
	@since 11/05/ 2021
	@version 1.0
	@type function
/*/
/************************************************************************************/
//Static Function TFatA02NumR()
User Function TFatA02NumR()
Local aArea		:= GetArea()
Local cNextNum	:= ""

//-------------------------+
// Abre tabela de romaneio | 
//-------------------------+
dbSelectArea("ZZD")
ZZD->( dbSetOrder(1) )

cNextNum := GetSxeNum("ZZD","ZZD_CODIGO")
While ZZD->( dbSeek(xFilial("ZZD") + cNextNum) )
	ConfirmSx8()
	cNextNum := GetSxeNum("ZZD","ZZD_CODIGO","",1)
EndDo

RestArea(aArea)
Return cNextNum

/************************************************************************************/
/*/{Protheus.doc} TFatA02Mot
	@description Cadastra motorista somente com nome e CNH
	@type  Static Function
	@author INOVEN
	@since 01/09/2020
/*/
/************************************************************************************/
User Function TFatA02Mot(_cCodMot)
Local _aArea		:= GetArea()

Local _nRecnoZZC	:= 0

Local _lAtualiza 	:= .F.

//----------------------------------+
// Tenta localizar dados existentes | 
//----------------------------------+
If TFatA02MQry(@_nRecnoZZC)
	_lAtualiza := .T.
EndIf

/*
dbSelectArea("ZZC")
ZZC->( dbSetOrder(1) )

If _lAtualiza
	//---------------------+
	// Posiciona Motorista |
	//---------------------+
	ZZC->( dbGoTo((_cAlias)->RECNOZZC) )
	_cCodMot	:= ZZC->ZZC_CODIGO	
	RecLock("ZZC",.F.)
		ZZC->ZZC_NOME	:= M->ZZD_DESCMO
		ZZC->ZZC_CNH	:= M->ZZD_CNH
	ZZC->( MsUnLock() )
Else

	_cCodMot	:= GetSxeNum("ZZC","ZZC_CODIGO")
	While ZZC->( dbSeek(xFilial("ZZC") + _cCodMot) )
		ConfirmSx8()
		_cCodMot	:= GetSxeNum("ZZC","ZZC_CODIGO")
	EndDo

	RecLock("ZZC",.T.)
		ZZC->ZZC_CODIGO	:= _cCodMot
		ZZC->ZZC_NOME	:= M->ZZD_DESCMO
		ZZC->ZZC_CNH	:= M->ZZD_CNH
	ZZC->( MsUnLock() )

EndIf
*/
dbSelectArea("DA4")
DA4->( dbSetOrder(1) )

If _lAtualiza
	//---------------------+
	// Posiciona Motorista |
	//---------------------+
	DA4->( dbGoTo((_cAlias)->RECNOZZC) )
	_cCodMot	:= DA4->DA4_COD	
	RecLock("DA4",.F.)
		DA4->DA4_NOME	:= M->ZZD_DESCMO
		DA4->DA4_NREDUZ	:= M->ZZD_DESCMO
		DA4->DA4_NUMCNH	:= M->ZZD_CNH
	DA4->( MsUnLock() )
Else

	_cCodMot	:= GetSxeNum("DA4","DA4_COD")
	While DA4->( dbSeek(xFilial("DA4") + _cCodMot) )
		ConfirmSx8()
		_cCodMot	:= GetSxeNum("DA4","DA4_COD")
	EndDo

	RecLock("DA4",.T.)
		DA4->DA4_COD	:= _cCodMot
		DA4->DA4_NOME	:= M->ZZD_DESCMO
		DA4->DA4_NREDUZ	:= M->ZZD_DESCMO
		DA4->DA4_NUMCNH	:= M->ZZD_CNH
	DA4->( MsUnLock() )

EndIf

RestArea(_aArea)
Return .T.

/************************************************************************************/
/*/{Protheus.doc} TFATA02G
	@description Gatilho retorna codigo e nome do motorista
	@type  Function
	@author INOVEN
	@since 21/10/2020
/*/
/************************************************************************************/
User Function TFATA02G(_cCpo,_nTipo)
Local _xRet		:= Nil

Local _cQuery 	:= ""
Local _cAlias	:= ""

_cQuery := " SELECT " + CRLF
_cQuery += "	ZZC_CODIGO, " + CRLF
_cQuery += "	ZZC_NOME " + CRLF
_cQuery += " FROM " + CRLF 
_cQuery += "	" + RetSqlName("ZZC") + " " + CRLF
_cQuery += " WHERE " + CRLF
_cQuery += "	ZZC_FILIAL = '" + xFilial("ZZC") + "' AND " + CRLF
_cQuery += "	ZZC_CNH = '" + _cCpo + "' AND " + CRLF
_cQuery += "	D_E_L_E_T_ = '' "

_cAlias := MPSysOpenQuery(_cQuery)

//------+
// Nome |
//------+
If _nTipo == 1 //.And. Empty(M->ZZD_DESCMO)
	_xRet := IIF(Empty((_cAlias)->ZZC_NOME),CriaVar("ZZC_NOME",.F.),(_cAlias)->ZZC_NOME)
//--------+
// Codigo | 
//--------+
ElseIf _nTipo == 2 //.And. Empty(M->ZZD_MOTORI)
	_xRet := IIF(Empty((_cAlias)->ZZC_CODIGO),"",(_cAlias)->ZZC_CODIGO)
EndIf

Return _xRet

/************************************************************************************/
/*/{Protheus.doc} MenuDef
	@description Menu padrao para manutencao do cadastro
	@author Tiago Bandeira
	@since 10/08/2017
	@version undefined
	@type function
/*/
/************************************************************************************/
Static Function MenuDef()
Local aRetMenu := {}

	aAdd(aRetMenu,{"Pesquisar"				,"PesqBrw"   		, 0, 1, 0, .F. })
	aAdd(aRetMenu,{"Visualizar"				,"U_TFATA02A"		, 0, 2, 0, .F. })
	aAdd(aRetMenu,{"Incluir"				,"U_TFATA02A"		, 0, 3, 0, .F. })
	aAdd(aRetMenu,{"Alterar"				,"U_TFATA02A"		, 0, 4, 0, .F. })
	aAdd(aRetMenu,{"Excluir"				,"U_TFATA02A"		, 0, 5, 0, .F. })
	aAdd(aRetMenu,{"Gera Romaneio"			,"U_TFATA02R"		, 0, 3, 0, .F. })
	aAdd(aRetMenu,{"Imprimir Romaneio"		,"U_IEXPR010"		, 0, 6, 0, .F. })
	aAdd(aRetMenu,{"Clientes Agendamento"	,"U_IEXPR020"		, 0, 6, 0, .F. })
			
Return aRetMenu
