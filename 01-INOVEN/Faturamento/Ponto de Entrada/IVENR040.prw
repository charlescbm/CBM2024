#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"
STATIC __cPrgNom

//DESENVOLVIDO POR INOVEN


User Function IVENR040()

__cPrgNom := Substr( ProcName() , 3 ) + '__'
//--Cria Pergunta
SX1->( dbSetorder(1) )
If ( !SX1->( MsSeek( __cPrgNom ) ) )
	FCriaPerg( __cPrgNom )
EndIf
If Pergunte( __cPrgNom , .T. )
	SC5->(DbSetorder(01))
	If SC5->(DbSeek(xFilial('SC5')+AvKey(MV_PAR01,'C5_NUM')))
		If !Empty(SC5->C5_LIBEROK)
			MsgAlert(OemToansi('Pedido : '+ SC5->C5_NUM + ' já está liberado' ))
		Else
			FsLibPed(SC5->C5_NUM)
		EndIf
	EndIf
EndIf

Return( Nil )

Static Function FCriaPerg(cPerg)

Local aRegs	 := {}
Local xI	 := 0
Local xJ	 := 0

dbSelectArea("SX1")
SX1->(dbSetOrder(1))
cPerg := PadR(cPerg,10)

AADD(aRegs,{cPerg,"01","Pedido"   ,"","","mv_ch1" ,"C",TamSX3("C5_NUM")[1],0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SC5TAG",""})

For xI := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[xI,2])
		If RecLock("SX1",.T.)
			For xJ := 1 To Len(aRegs[xI])
				FieldPut(xJ,aRegs[xI,xJ])
			Next xJ
			MsUnlock()
		EndIf
	EndIf
Next xI

Return(Nil)

User Function XF5SC5()

Local cFilSC5:=''


cFilSC5+="@#"
cFilSC5+="SC5->("
cFilSC5+="C5_FILIAL == '"+xFilial('SC5')+"' "
//cFilSC5+=".And."
//cFilSC5+="C5_LIBEROK == ' ' "
//	cFilSC5+=".And."
//	cFilSC5+="C5_BLQ == ' ' "
/*
SA3->(dbSetOrder(7))
If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
cFilSC5+=".And."
cFilSC5+="C5_VEND1 == '"+SA3->A3_COD+"' "
EndIf
*/
cFilSC5+=")"
cFilSC5+="@#"

Return(cFilSC5)

Static Function FsLibPed(cNumPed)

Local nLiberou	:= 0
Local lPode		:= .T.
Local nValItTot	:= 0   
LOCAL _TEMSC9	:=.F.
		
LOCAL aRegistros    := {}
Pergunte("MTA440",.F.)

Public lTransf:= MV_PAR01==1
Public lLiber := MV_PAR02==1
Public lSugere:= MV_PAR03==1

SC5->(DbSetorder(01))
SC5->(DbSeek(xFilial('SC5')+AvKey(cNumPed,'C5_NUM')))

If !Empty(SC5->C5_BLQ)
	MsgInfo('Necessario realizar liberação bloqueio de rentabilidade. Favor solicitar ao Gestor responsavel!!')
	Return()
EndIf

If fValCred(SC5->C5_NUM,SC5->C5_FILIAL)  .and. !EMPTY(SC5->C5_LIBEROK)
	ALERT("AGUARDE A LIBERAÇÃO DA ANALISE DE CRÉDITO!!!")
	RestArea(aArea)
	Return .T.
EndIf


//-- IR -- Necessário estornar a liberação do pedido antes de liberar novamente.
aEstLibPv(SC5->C5_FILIAL,SC5->C5_NUM)

dbSelectArea("SC6")
SC6->( DbSetOrder(1) )
SC6->( DbSeek(xFilial('SC5')+ cNumPed))
Do While (SC6->(!Eof()) .And. xFilial('SC5')+cNumPed == SC6->C6_FILIAL+SC6->C6_NUM)
	
	
	nValItTot += SC6->C6_VALOR
	//--Produto que controla Lote deve-se avaliar sem validar estoque
	
	//	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN		,.F.		,.F.		,.T.,.T.,lLiber,lTransf)
	//	MaLibDoFat(nRegSC6,      nQtdaLib               ,lCredito   ,lEstoque   ,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lGeraDCF,nVlrCred,nQtdalib2)
	
	IF SC6->C6_QTDVEN > SC6->C6_QTDENT  .and. !AllTrim(SC6->C6_BLQ) $ "SR"
		
		IF  SC5->C5_TIPLIB == '2'
			RecLock("SC6")
			SC6->C6_QTDLIB := SC6->C6_QTDVEN
			MsUnLock()
			aadd(aRegistros,SC6->(RecNo()))
		ELSEIF SC5->C5_TIPLIB == '1'
			nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,lLiber,lTransf)
		endif
		
	endif
	
	
	/*
	If Rastro(SC6->C6_PRODUTO)
	nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.T.,.F.,lLiber,lTransf)
	Else
	nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.F.,.T.,.T.,lLiber,lTransf)
	EndIf
	*/
	SC6->( dbSkip() )
EndDo

lLiber:=.F.
lTransf:=.f.


If ( Len(aRegistros) > 0 )
	Begin Transaction
	SC6->(MaAvLibPed(SC5->C5_NUM,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,Nil))
	End Transaction
EndIf


MSUnlockAll()

SC6->(MaLiberOk({SC5->C5_NUM},.T.))



If SC5->C5_TIPO == 'N'
	
	//--Posicionamento no cliente
	SA1->(DbSetOrder(01))
	SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	
	dbSelectArea("SC9")
	SC9->(dbGoTop())
	SC9->(DBSEEK(XFILIAL("SC5")+SC5->C5_NUM))
	Do While SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO
		If xFilial("SC5") == SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO
			//--Valida se teve bloqueio de credito
			_TEMSC9 := .T.
		
			If !Empty(SC9->C9_BLCRED)
				lPode := .F.
			EndIf
		EndIf
		SC9->(dbSkip())
	EndDo
	
	If !lPode
		ALERT(OemToAnsi("AGUARDE A LIBERAÇÃO DA ANALISE DE CRÉDITO!!!"))
		u_DnyGrvSt(SC5->C5_NUM, "000036") //Informa que pedido está em analise de crédito.
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
	    ENDIF

	Else
		MsgInfo('PEDIDO APTO A FATURAR!!')
		u_DnyGrvSt(SC5->C5_NUM, "000007")
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
	    ENDIF
	EndIf
EndIf//Fim validação tipo do pedido

Return( Nil )



//-- Valida se pedido está em analise de credito.
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

@description   Estorna a liberação do pedido de venda

@type   	   Function
@author		   ALFA ERP
@version   	   1.00
@since     	   10/02/2016

@param			cPedido		, Numero do Pedido de Venda gerado pelo e-Commerce

@return			lRet 		, Retorno da operação True 	- Sucesso False - Erro

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
			// Estorna Liberação Pedido |
			//--------------------------+
			a460Estorna(.T.,.F.)
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)

Return .T.

//-- IR -- VALIDA SE ULTIMO STATUS DO PEDIDO É LIBERADO PARA ESTOQUE
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





