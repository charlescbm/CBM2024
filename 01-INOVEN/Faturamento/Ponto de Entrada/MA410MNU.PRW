#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

/**********************************************************************************************/
/*/{Protheus.doc} MA410MNU
	@description Ponto de Entrada Pedidos De Venda - MENU
	@author 
	@since 11/05/2021
	@version 1.0
	@type function
/*/
/**********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function MA410MNU
//Local cVendUsu		:= ""
//Local cAliasTRB		:= GetNextAlias()
Local aRotina5 		:= { {'Enviar Pedido'			,"U_TAG05C22(1)",0,6},;
						 {'Consultar Link'			,"U_TAG05C22(2)",0,6},;
						 {'Reenviar Link'			,"U_TAG05C22(3)",0,6},;
						 {'Atualizar Pedidos'		,"U_TAG05C22(4)",0,6}}

Public bFiltraBrw 	:= {|| Nil}
Public lAltTpOper 	:= .T.

//Verifica as perguntas selecionada                    ?
Pergunte("MTA440",.F.)

//Transfere locais para a liberacao                    ?
Public lTransf:=MV_PAR01==1

//Libera Parcial pedidos de vendas                     ?
Public lLiber :=MV_PAR02==1

//Sugere quantidade liberada                           ?
Public lSugere:=MV_PAR03==1

Aadd(aRotina, {'00-Revisa Pedido'    ,"U_TFATA008"   ,0,0,0 ,NIL} )
AADD(aRotina, {"01-Status"           ,"U_ICADA040"      ,0,6,0 ,.F.})
AADD(aRotina, {"03-Mensagem NF"      ,"U_IFATM020()"     ,0,6,0 ,.F.})
AADD(aRotina, {"10-Impressao Ped."		 ,"U_IVENR020()"	,0,6,0 ,Nil})

AADD(aRotina, {"04-Liberar Pedido"     ,"U_fLibEst01"		  ,0,2,0, NIL})
AADD(aRotina, {"05-Exclui (PV/ORC)"    ,"U_xDelPvOrc"   	  ,0,2,0,.F.})


If __cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000'
	AADD(aRotina, {"14-Imprimir Gerente"   ,"U_IVENR020(1,'G')"    ,0,6,0,.F.})
EndIf
//AADD(aRotina, {"16-Pgto_Link" 		,aRotina5    	   ,0,6,0 ,.F.})


Return .T.

User Function fLibEst01()

//Local lCred:=.F.
Local lPode := .T.
//Local aSaldos := {}
Local aArea:= Getarea()

//Local cFilAux		:= cFilAnt
//Local cMsgErro		:= ""

//Local lCredito  	:= .T.
//Local lEstoque		:= .T.

Local lTransf   	:= .F.
//Local lRet			:= .F.

Local nLiberou		:= 0
//Local nQtdLiber		:= 0

//Local nVlrCred 	:= 0
Local lLiber:=.F.
//Local lTransf:=.f.
//Local lCredito  := .T.
//Local lEstoque  := .T.
//Local lAvalCred := .F.
//Local lAvalEst  := .F. //Voltei para o valor anterior
//Local lLibPar   := .F.
//Local lTrfLocal := .F.
//Local lRet		:= .T.
//local lLCVenci	:= .F.
//Local nLiberado	:= 0

//-- IR -- Variaveis com dados para analise de cr閝ito cliente.
//Local nVatrazo := 0.0
//Local nLCrdT := 0.0
//Local nLCrd := 0.0
Local nValItTot := 0

//- Por Anderson Goncalves
//- Inclus鉶 de dados do cartao de credito
//Local aCombo1 		:= {"","C=Cielo","G=GetNet"}//,"R=Rede","A=Amex","G=GetNet"}
//Local cCombo1 		:= ""
//Local oCombo1		:= Nil
//Local cBande		:= Space(02)
//Local cNsu			:= Space(12)
//Local cAutor		:= Space(12)
//Local oBande		:= Nil
//Local oNsu			:= Nil
//Local oAutor		:= Nil
//Local _oDlg	 		:= Nil
//Local cLabBand		:= ""
//Local oLabBand		:= Nil
//Local dDataCar		:= ctod("  /  /  ")
//Local oDataCar 		:= Nil
//Local cCondCartao	:= GetMv("ES_CONDPG",,"121/122/123/124/125/126")
//Local nOpcA			:= 0
LOCAL aRegistros    := {}
Local _TEMSC9		:=.F.
		
//--Valida睲es so deve ocorrer quando pedido for do tipo Normal
If SC5->C5_TIPO == 'N'
	
	If SC5->C5_CONDPAG $ GetMv('FS_CONDBON',.F.,'')
		If ! ( __cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000' )
			MsgInfo('Bonifica睲es somente podem ser liberadas pelo Gerente!!')
			Return()
		EndIf
	EndIf
	
	If !Empty(SC5->C5_BLQ)
		MsgInfo('Necessario realizar liberacao bloqueio de rentabilidade. Favor solicitar ao Gestor responsavel!!')
		Return()
	EndIf
	
	//Verifica se a condicao eh pagamento com cartao e se o numero da NSU esta preenchido?
	
	//-- Verifica se ultimo status do pedido foi libera玢o de cr閝ito, se foi, somente coloca como programado.

	If fValCred(SC5->C5_NUM,SC5->C5_FILIAL)  .and. !EMPTY(SC5->C5_LIBEROK)
		MsgAlert(OEMToAnsi("AGUARDE A LIBERACAO DA ANALISE DE CREDITO!!!"))
		RestArea(aArea)
		Return .T.
	EndIf
	
	//-- Verifica se pedido j?foi programado.
	If fValProg(SC5->C5_NUM,SC5->C5_FILIAL) .AND. !EMPTY(SC5->C5_LIBEROK)
		ALERT("Pedido j� liberado! N�o ser� possivel solicitar nova libera��o.")
		RestArea(aArea)
		Return .T.
	EndIf
	
EndIf


//-- IR -- Necess醨io estornar a libera玢o do pedido antes de liberar novamente.
aEstLibPv(SC5->C5_FILIAL,SC5->C5_NUM)

dbSelectArea("SC6")
SC6->( dbSetOrder(1) )
SC6->( dbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
Do While (SC6->(!Eof()) .And. SC5->C5_FILIAL+SC5->C5_NUM == SC6->(C6_FILIAL+C6_NUM))
	
	nValItTot += SC6->C6_VALOR
	//--Produto que controla Lote deve-se avaliar sem validar estoque
	
 	  	IF SC6->C6_QTDVEN > SC6->C6_QTDENT  .and. !AllTrim(SC6->C6_BLQ) $ "SR" 
 	  	
 	  		IF  SC5->C5_TIPLIB == '2'
 				RecLock("SC6")
				SC6->C6_QTDLIB := SC6->C6_QTDVEN
				MsUnLock()
				aadd(aRegistros,SC6->(RecNo()))
			ELSEIF SC5->C5_TIPLIB == '1' 
 		           nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,lLiber,lTransf)
			 //
 			 //	If Rastro(SC6->C6_PRODUTO)
			 //		nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.T.,.F.,lLiber,lTransf)
			 //	Else	
			 //		nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.F.,.T.,.T.,lLiber,lTransf)
			 //	EndIf	 
			endif	
 		
 		endif							
 
	SC6->( dbSkip() )
EndDo

If ( Len(aRegistros) > 0 )
	Begin Transaction
		SC6->(MaAvLibPed(SC5->C5_NUM,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,Nil))
	End Transaction
EndIf

MSUnlockAll()

SC6->(MaLiberOk({SC5->C5_NUM},.T.))//atualiza C5_LIBEROK


If SC5->C5_TIPO == 'N'
	//-- IR -- Busca as informa睲es para analise de cr閝ito do cliente.
	//fAnaCred(@nVatrazo,@nLCrdT,@nLCrd)
	//--Posicionamento no cliente
	SA1->(DbSetOrder(01))
	SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	//--Avalia vencimento do credito
	//lLCVenci:= SA1->A1_VENCLC < dDataBase
	dbSelectArea("SC9")
	SC9->(dbGoTop())
	SC9->(DBSEEK(XFILIAL("SC5")+SC5->C5_NUM))
	Do While SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO
		If XFILIAL("SC5")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO			
			//--Valida se teve bloqueio de credito
			_TEMSC9:=.T.
			If !Empty(SC9->C9_BLCRED) 
				lPode := .F.
			EndIf
		EndIf
		SC9->(dbSkip())
	EndDo
	
	If !lPode                                         
		ALERT("AGUARDE A LIBERA敲O DA ANALISE DE CR蒝ITO!!!")
		u_DnyGrvSt(SC5->C5_NUM, "000036") //Informa que pedido est?em analise de cr閝ito.
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
	    ENDIF
	Else
		MsgInfo('PEDIDO APTO A FATURAR!!')
		u_DnyGrvSt(SC5->C5_NUM, "000007")
		//-- Grava pedido como pendente de transfer阯cia se for filial e transferido se for matriz.
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
	    ENDIF
	EndIf
EndIf//Fim valida玢o tipo do pedido
RestArea(aArea)
Return

//-- IR -- Fun玢o para avaliar o cr閝ito do cliente.
Static Function fAnaCred(nVatrazo,nLCrdT,nLCrd)

Local cQuery := ""

// Duplicatas de atraso
cQuery := "SELECT SUM(SE1.E1_SALDO) AS E1SALDO, COUNT(*) AS E1QTDDUP "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+SC5->C5_LOJACLI+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase - 4)+"' "
cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
If Select("TRCL") > 0
	dbSelectArea("TRCL")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRCL"
TCSetField("TRCL", "E1ATRZ" , "D",08,0)

dbSelectArea("TRCL")
DBGOTOP()
IF !Eof()
	IF TRCL->E1QTDDUP > 0
		nVatrazo := TRCL->E1SALDO
	ENDIF
ENDIF

SA1->(dbSetOrder(1))
If SA1->(dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	nLCrdT := SA1->A1_LC
EndIf

// Duplicatas em aberto
cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+SC5->C5_CLIENTE+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+SC5->C5_LOJACLI+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
If Select("TRCL") > 0
	dbSelectArea("TRCL")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRCL"

dbSelectArea("TRCL")
DBGOTOP()
IF !Eof()
	nLCrd := nLCrdT-TRCL->E1SALDO
ENDIF

Return()

//-- Valida se pedido j?foi programado e n鉶 permite fazer nova libera玢o.
Static Function fValProg(cPedido,cFilZ05)

Local cQuery := ""

cQuery := " SELECT 1 "
cQuery += " FROM "+RetSqlName("Z05")+" Z05 "
cQuery += " WHERE Z05_PEDIDO = '"+cPedido+"'"
cQuery += " AND Z05_FILIAL = '"+xFilial('Z05')+"'"
//cQuery += " AND Z05_FILIAL = '"+cFilZ05+"'"
cQuery += " AND Z05_STATUS = '000007' "
cQuery += " AND D_E_L_E_T_ <> '*' "
If Select("TZ05") > 0
	dbSelectArea("TZ05")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TZ05"

dbSelectArea("TZ05")
DBGOTOP()
IF !Eof()
	Return(.T.)
ENDIF

Return(.F.)


//-- Valida se pedido est?em analise de credito.
Static Function fValCred(cPedido,cFilZ05)

Local cQuery := ""

cQuery := " SELECT Z05_DATA, Z05_HORA, Z05_STATUS "
cQuery += " FROM "+RetSqlName("Z05")+" Z05 "
cQuery += " WHERE Z05_PEDIDO = '"+cPedido+"'"
cQuery += " AND Z05_FILIAL = '"+xFilial('Z05')+"'"
//cQuery += " AND Z05_FILIAL = '"+cFilZ05+"'"
cQuery += " AND D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY Z05_DATA+Z05_HORA DESC"

If Select("TZ05") > 0
	dbSelectArea("TZ05")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TZ05"

dbSelectArea("TZ05")
DBGOTOP()
IF !Eof()
	If TZ05->Z05_STATUS = '000036'
		Return(.T.)
	EndIf
ENDIF

Return(.F.)

/**************************************************************************************************/
/*/{Protheus.doc} aEcEstLibPv

@description   Estorna a libera玢o do pedido de venda

@type   	   Function
@author		   ALFA ERP
@version   	   1.00
@since     	   10/02/2016

@param			cPedido		, Numero do Pedido de Venda gerado pelo e-Commerce

@return			lRet 		, Retorno da opera玢o True 	- Sucesso False - Erro

/*/
/**************************************************************************************************/
Static Function aEstLibPv(cFilPed,cPedido)

Local aArea	:= GetArea()

//------------------+
// Posiciona Pedido |
//------------------+
dbSelectArea("SC9")
SC9->( dbSetOrder(1) )
If SC9->( dbSeek(cFilPed + cPedido ) )
	While SC9->( !Eof() .And. cFilPed + cPedido == SC9->( C9_FILIAL + C9_PEDIDO ) )
		If Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_SERIENF)
			//--------------------------+
			// Estorna Libera玢o Pedido |
			//--------------------------+
			a460Estorna(.T.,.F.)
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)

Return .T.

//-- IR -- VALIDA SE ULTIMO STATUS DO PEDIDO ?LIBERADO PARA ESTOQUE
Static Function fValLibC(cPedido,cFilZ05)

Local cQuery := ""

cQuery := " SELECT Z05_DATA, Z05_HORA, Z05_STATUS "
cQuery += " FROM "+RetSqlName("Z05")+" Z05 "
cQuery += " WHERE Z05_PEDIDO = '"+cPedido+"'"
cQuery += " AND D_E_L_E_T_ <> '*' "
//cQuery += " AND Z05_FILIAL = '"+cFilZ05+"'"
cQuery += " AND Z05_FILIAL = '"+xFilial('Z05')+"'"
cQuery += " ORDER BY Z05_DATA+Z05_HORA DESC"

If Select("TZ05") > 0
	dbSelectArea("TZ05")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TZ05"

dbSelectArea("TZ05")
DBGOTOP()
IF !Eof()
	If TZ05->Z05_STATUS = '000006'
		Return(.T.)
	EndIf
ENDIF

Return(.F.)       


