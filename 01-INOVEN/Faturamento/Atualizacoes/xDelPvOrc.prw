#INCLUDE "PROTHEUS.CH"
#INCLUDE 'TBICONN.CH'
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE 'TOTVS.CH'   
#include 'TBICODE.CH' 
#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma  ³ xDelPvOrc  ºAutor  ³ Meliora/Gustavo   º Data ³  21/01/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada - Exclusao do pedido de venda e Orçamento  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico                                                 º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
//DESENVOLVIDO POR INOVEN

*---------------------*
User Function xDelPvOrc
*---------------------*                                                      
Local _aCabec    := {}
Local _aLinhas   := {}
Local _aAux1     := {}
Local _lDelOrc   := .F.
Local _aRecno    := {}       
//Local _lContinua := .T.
//Local cFilIN     :=SC5->C5_FILIAL 
//Local cPedIN     :=SC5->C5_NUM
//Local cTipoPV	 :=SC5->C5_TIPO
Local lRetTran	 := .T.
Local _nDel

//-- IR -- Valida permissão para exclusão.
If !fValUsuEx()
	Return()
EndIf

IF !MsgYesNo(	'         -= Atenção =-'+ENTER+ENTER+;
				'Pedido ['+ SC5->C5_NUM +'].'+ENTER+;
				'Deseja efetuar a exclusão ?')
	Return
ENDIF

//.iNi HS Valida exclusao de pedido x vendedor
//--Verifica se usuario é vendedor, caso seja somente poderá excluir pedidos se o mesmo estiver com status 000004|000006|000007|000036|000042

//SA3->(dbSetOrder(7))
//If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
//	If !__cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000'
//		//--Verifica se status é diferente dos permitidos
//		If !(AllTrim(SC5->C5_XSTATUS) $ '000002')
//			Alert(OemToAnsi('Usuário sem pemissão para excluir pedido com status atual !'))
//			Return()
//		EndIf
//	EndIf	
//EndIf

// Alimenta os dados do cabecalho do pedido
aAdd(_aCabec,{"C5_NUM"   	,SC5->C5_NUM   				,Nil})
aAdd(_aCabec,{"C5_TIPO"   	,SC5->C5_TIPO				,Nil})
aAdd(_aCabec,{"C5_CLIENTE"	,SC5->C5_CLIENTE			,Nil})
aAdd(_aCabec,{"C5_LOJACLI"	,SC5->C5_LOJACLI			,Nil})
aAdd(_aCabec,{"C5_TIPOCLI"	,SC5->C5_TIPOCLI			,Nil})
aAdd(_aCabec,{"C5_CONDPAG"	,SC5->C5_CONDPAG	  		,Nil})
aAdd(_aCabec,{"C5_TABELA"	,SC5->C5_TABELA				,Nil})
aAdd(_aCabec,{"C5_EMISSAO"	,SC5->C5_EMISSAO			,Nil})
aAdd(_aCabec,{"C5_TPFRETE"	,SC5->C5_TPFRETE			,Nil})
aAdd(_aCabec,{"C5_DESCONT"	,SC5->C5_DESCONT			,Nil})
                                              
//Adiciona Recno para delecao
Aadd(_aRecno, {'SC5',SC5->(Recno())})		  

// Alimenta os dados dos itens do pedido ja gravado
DbSelectArea("SC6")
SC6->(DbSetOrder(1))
SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))

While SC6->(!Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
	_aAux1 := {}
	
	IF !Empty(SC6->C6_NOTA)
		MsgInfo("Exclusão não permitada!"+ENTER+ENTER+"Pedio de venda já possui Nota Fiscal ["+ SC6->C6_NOTA+"/"+SC6->C6_SERIE +"].","Processo Cancelado")
		Return
	ENDIF
					
	aAdd(_aAux1,{"C6_ITEM"   ,SC6->C6_ITEM      ,Nil})
	aAdd(_aAux1,{"C6_PRODUTO",SC6->C6_PRODUTO	,Nil})
	aAdd(_aAux1,{"C6_QTDVEN" ,SC6->C6_QTDVEN	,Nil})
	aAdd(_aAux1,{"C6_PRUNIT" ,SC6->C6_PRUNIT	,Nil})
	aAdd(_aAux1,{"C6_PRCVEN" ,SC6->C6_PRCVEN	,Nil})
	aAdd(_aAux1,{"C6_DESCONT",SC6->C6_DESCONT	,NiL})
	aAdd(_aAux1,{"C6_TES"    ,SC6->C6_TES 		,Nil})
	aAdd(_aAux1,{"C6_LOCAL"  ,SC6->C6_LOCAL		,Nil})
	aAdd(_aAux1,{"C6_ENTREG" ,SC6->C6_ENTREG	,Nil})
	aAdd(_aAux1,{"C6_LOTECTL",SC6->C6_LOTECTL	,Nil})
	aAdd(_aAux1,{"C6_DTVALID",SC6->C6_DTVALID	,Nil})
	//aAdd(_aAux1,{"C6_QTDLIB" ,0 				,Nil})
	aAdd(_aAux1,{"C6_PEDCLI" ,SC6->C6_PEDCLI	,Nil})

	AAdd(_aLinhas, _aAux1)

	//Adiciona Recno para delecao
	Aadd(_aRecno, {'SC6',SC6->(Recno())})		  
		
	SC6->(dbSkip())
EndDo

DbSelectArea('SUA')
SUA->(DbSetOrder(8)) 
SUA->(DbGoTop())

DbSelectArea('SUB')
SUB->(DbSetOrder(1))
SUB->(DbGoTop())                            

//--Transação irá validar todo o processo
Begin Transaction

cNumOrc := ''
IF SUA->(DbSeek(xFilial('SUA')+SC5->C5_NUM))
	cNumOrc := SUA->UA_NUM
	IF (_lDelOrc := MsgYesNo(	'              -= Atenção =-'+ENTER+ENTER+;
							'Existe Orçamento ['+ SUA->UA_NUM +'] vinculado ao Pedido ['+ SC5->C5_NUM +'].'+ENTER+;
							'Deseja efetuar a exclusão ?'))
		 
		//Adiciona Recno para delecao
		Aadd(_aRecno, {'SUA',SUA->(Recno())})	 
			  							
	 	SUB->(DbSeek(xFilial('SUB')+SUA->UA_NUM))
	 	While SUB->(!EOF()) .And. xFilial('SUA')+SUA->UA_NUM == xFilial('SUB')+SUB->UB_NUM
			//Adiciona Recno para delecao
			Aadd(_aRecno, {'SUB',SUB->(Recno())})		  								 		
	 		SUB->(DbSkip())
	 	EndDo
	 	
		//--Deleta a condição negociada
	 	cSQL := " DELETE FROM "+RetSqlName("SZ1")+" "
		cSQL += " WHERE Z1_ORCAMEN = '"+AllTrim(SUA->UA_NUM)+"' "
	Else 		
		If 	RecLock('SUA',.F.)
				Replace SUA->UA_NUMSC5 With Space(TamSX3('UA_NUMSC5')[1])
			SUA->(MsUnLock())
		EndIF
		
		//--Apaga o numero do pedido na condição negociada	
		cSQL := " UPDATE "+RetSqlName("SZ1")+" "
		cSql += " SET Z1_PEDIDO = '"+Space(TamSX3("Z1_PEDIDO")[1])+"'"		
		cSQL += " WHERE Z1_ORCAMEN = '"+AllTrim(SUA->UA_NUM)+"'"
	EndIF
	
	If TCSqlExec(cSql) <> 0
		Aviso("Condição Negociada","Não foi possivel apagar a condição negociada.",{"OK"})
	EndIf
EndIF
	
lMsHelpAuto := .T.
lMsErroAuto := .F.
dbSelectArea("SA1")
dbSelectArea("SB1")

//-- IR -- Necessário estornar a liberação do pedido antes de liberar novamente.
aEstLibPv(SC5->C5_FILIAL,SC5->C5_NUM)
							
FWMsgRun(, {|| MSExecAuto({|x,y,z| Mata410(x,y,z)},_aCabec,_aLinhas,5) }, "Aguarde...", "Excluindo o pedido "+SC5->C5_NUM)
 
If lMsErroAuto    
	
	MostraErro()
	lRetTran:= .F.
	Else    

		if !empty(cNumOrc)
			//Desvincular Orçamento da agenda
			ZAF->(dbSetOrder(2))
			ZAF->(msSeek(xFilial('ZAF') + cNumOrc, .T.))
			While ZAF->(!eof()) .and. ZAF->ZAF_FILIAL + ZAF->ZAF_NUMORC == xFilial('ZAF') + cNumOrc
				ZAF->(recLock('ZAF', .F.))
				ZAF->ZAF_NUMORC := ''
				ZAF->(msUnlock())
				ZAF->(msSeek(xFilial('ZAF') + cNumOrc, .T.))
			End
		endif

		For _nDel:=1 To Len(_aRecno)                    
			DbSelectArea(_aRecno[_nDel][01])
			(_aRecno[_nDel][01])->(DbGoTo(_aRecno[_nDel][02]))
			IF (_aRecno[_nDel][01])->(RECNO()) == (_aRecno[_nDel][02])
				   IF 	RecLock((_aRecno[_nDel][01]),.F.)	   
						(_aRecno[_nDel][01])->(DbDelete())
					(_aRecno[_nDel][01])->(MsUnLock())
			   ENDIF
			EndIF
		Next _nDel	
EndIf

If lRetTran
	MsgInfo("Exclusão concluida com sucesso!.","Processo Finalizado")
	if FieldPos("UA_XNUMPC5") > 0
			//U_PC5UpdSt("L", xFilial("SUA") + SUA->UA_XNUMPC5)
	endif
	If !lRetTran
		DisarmTransaction()
	EndIf
Else
	MsgInfo("Erro ao realizar exclusão de PV!.","Processo Finalizado")
EndIf                                      

End Transaction
//--Exibir msg apos transação

Return(Nil)

//-- IR -- Função para validar exclusão de pedido.
Static Function fValUsuEx()

Local lRet := .T.
Local aDadosUsu := {}
Local cGrpAprv := GetMv("FS_GRPGPED",,"000000")


If fValProg(SC5->C5_NUM,SC5->C5_FILIAL)
	lRet := .F.
	aDadosUsu := U_FSLogin("<b>Pedido já foi programado! Será necessário solicitar</n>aprovação do gerente para acesso a esta rotina.</b>", .F.)
	If(aDadosUsu != Nil)//Achou o usuário
		If (aDadosUsu[1] == .F. .or. !(aDadosUsu[3] $ cGrpAprv))   //Se o usuário for valido ainda deverá estar dentro do grupo de aprovadores
			Alert("O usuário é inválido ou não pertence ao grupo de gerentes!!!")
		Else
			lRet := .T.
		EndIf	
	EndIF
EndIf
 
Return(lRet)

//-- Valida se pedido já foi programado e não permite fazer nova liberação.
Static Function fValProg(cPedido,cFilZ05)

Local cQuery := ""

cQuery := " SELECT 1 "
cQuery += " FROM "+RetSqlName("Z05")+" Z05 "
cQuery += " WHERE Z05_PEDIDO = '"+cPedido+"'"
cQuery += " AND Z05_FILIAL = '"+cFilZ05+"'"
cQuery += " AND Z05_STATUS = '000007' "
cQuery += " AND D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
dbGoTop()
If !Eof()
	Return(.T.)
EndIf

Return(.F.)


//DbSelectArea('SUA')
//SUA->(DbSetOrder(8))
//IF SUA->(DbSeek(xFilial('SUA')+SUA->UA_NUMSC5))
//   RecLock("SZA",.F.)
//   	  SUA->UA_NUMSC5  := Space(6)
//   MsUnLock()
//EndIf
		
/*
	Begin Transaction
		For _nDel:=1 To Len(_aRecno)                    
			DbSelectArea(_aRecno[_nDel][01])
			(_aRecno[_nDel][01])->(DbGoTo(_aRecno[_nDel][02]))
			IF (_aRecno[_nDel][01])->(RECNO()) == (_aRecno[_nDel][02])
			
			   // Atualiza B2_QPEDVEN
   		       If _aRecno[_nDel,1] == 'SC6'
			      If !SC6->(EoF()) .And. SB2->(DbSeek(xFilial('SB2')+SC6->C6_PRODUTO+SC6->C6_LOCAL))    

					    RecLock('SB2', .F.)
					    //Replace SB2->B2_QPEDVEN With SB2->B2_QPEDVEN - SC6->C6_QTDVEN
					    If SB2->B2_QPEDVEN < 0
	   				       Replace SB2->B2_QPEDVEN With 0
					    EndIf
					    SB2->(MsUnlock())   
				     			      
						If Alltrim(cFIlAnt)=="0502"								
							DBSELECTAREA("SB2")
							SB2->(DBSETORDER(1))
							IF SB2->(DBSEEK("0501"+SC6->C6_PRODUTO+SC6->C6_LOCAL))								
								SB2->(RECLOCK("SB2",.F.))
								SB2->B2_QPEDVEN := SB2->B2_QPEDVEN-SC6->C6_QTDVEN 
								SB2->(MSUNLOCK())
							ENDIF                                  
						
						EndIf                                       

											      
		          EndIf								
		       EndIf   
		       
			   IF 	RecLock((_aRecno[_nDel][01]),.F.)	   
						(_aRecno[_nDel][01])->(DbDelete())
					(_aRecno[_nDel][01])->(MsUnLock())
			   ENDIF
			EndIF
		Next _nDel
	End Transaction

dbSelectArea("SC9")
SC9->(dbGoTop())
SC9->(DBSEEK(XFILIAL("SC9")+SC5->C5_NUM))
WHILE SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO							                     
     If XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO      
   //A460Estorna eh uma funcao padrao do siga que estorna a SC9 que esta
   //posicionada, desta forma ele jah arruma os saldos da SB2 e libera a SC5/SC6
   //para exclusao, alem de outras coisas internas do siga.
		SC9->(A460Estorna())
   		SC9->(DbSkip())
    EndIf											 
	SC9->(dbSkip())
EndDo  	   
/*
SC5->(RECLOCK("SC5",.F.))
SC5->C5_LIBEROK:="  "
SC5->(MSUNLOCK())

dbSelectArea("SC9")
SC9->(dbGoTop())
SC9->(DBSEEK(XFILIAL("SC9")+SC5->C5_NUM))
WHILE SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO							                     
     If XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO      
			SC9->(RECLOCK("SC9",.F.))
			SC9->(DbDelete())
			SC9->(MSUNLOCK())
    EndIf											 
	SC9->(dbSkip())
EndDo  	
*/

	*/
	//MsgInfo("Exclusão concluida com sucesso!.","Processo Finalizado")
	//MsgInfo("Ocorreu um erro ao tentar excluir o pedido!. Tentar excluir novamente.","Processo Finalizado")
	//MostraErro()
	
	
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
			If Rastro(SC9->C9_PRODUTO)
				a460Estorna(.T.,.T.)
			Else
				a460Estorna(.T.,.F.)
			EndIf	
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)    

Return .T.
