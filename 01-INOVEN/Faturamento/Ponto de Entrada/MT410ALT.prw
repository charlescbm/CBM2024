#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ?MT410ACE ºAutor  ?IR			     ?Data ? 		      º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Valida se houve bloqueio após alteração do pedido.      	  º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                          º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
*/
//DESENVOLVIDO POR INOVEN

User Function MT410ALT()
        

Local _cArea:=GetArea() 

//-- IR -- Valida bloqueio de crédito
//If !fValBlqCr(SC5->C5_NUM)
//	ALERT("PEDIDO COM BLOQUEIO DE CRÉDITO. SOLICITE A LIBERAÇÃO!!!")
//	u_DnyGrvSt(SC5->C5_NUM, "000036") //Informa que pedido est?em analise de crédito./
//	RETURN	
//EndIf
//--Atualiza saldo SB2 sempre que acontece uma alteração
//FsAtuaSql(SC5->C5_FILIAL,SC5->C5_NUM)

u_DnyGrvSt(SC5->C5_NUM, "000049") 

//soma dos volumes
nTotVol := 0
SC6->(dbGoTop())
SC6->(dbSetOrder(1))
SC6->(msSeek(xFilial('SC6') + SC5->C5_NUM, .T.))
While !SC6->(eof()) .and. SC6->C6_FILIAL == xFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM
	nTotVol += SC6->C6_QTDVEN
	SC6->(dbSkip())
End

SC5->(recLock('SC5', .F.))
SC5->C5_ESPECI1 := 'VOLUMES'
SC5->C5_VOLUME1 := nTotVol
SC5->(msUnlock())


RestArea(_cArea)

Return()

//-- Valida se existe bloqueio de crédito para o pedido.
Static Function fValBlqCr(cNumPedPar)
            
Local cAliBlq := getNextAlias() //-- Cria um Alias Temporário
Local cQuery  := ""	
Local lRet	  := .T.

cQuery +=  "	SELECT 1 "
cQuery +=  "	FROM "+RetSqlName("SC9")+ " C9 (NOLOCK) "
cQuery +=  "	WHERE C9.D_E_L_E_T_ <> '*' "
cQuery +=  "		AND C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery +=  "		AND C9_PEDIDO = '"+cNumPedPar+"' "
cQuery +=  "		AND C9_BLCRED <> '' "
	
cQuery:=ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliBlq,.F.,.T.)

If !(cAliBlq)->(Eof())
	lRet := .F.
EndIf

(cAliBlq)->(dbCloseArea())

Return(lRet)                                                        

//--------------------------------------------------------------------------------------
/*/{Protheus.doc} FsAtuaSql
Função atualiza as informações na tabela de saldo
Faz-se necessario por conta da falha do sistema

@author		.iNi Sistemas
@since     	28/09/17
@version  	P.12              
@param		Nenhum		
@return 	Nenhum
@Obs:       Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//--------------------------------------------------------------------------------------  
Static Function FsAtuaSql(cFilPed, cPedido)

	Local cPrd	 := ''
	Local cCodArm:= ''
	Local cSql	 := ''
	
	SC6->(DbSetOrder(01))	
	SC6->( dbSeek(cFilPed + cPedido ) )
	Do While SC6->( !Eof() .And. cFilPed + cPedido == SC6->( C6_FILIAL + C6_NUM ) )
		cPrd+=AllTrim(SC6->C6_PRODUTO)+'|'
		cCodArm:= SC6->C6_LOCAL
	SC6->(DbSkip())
	EndDo
	//--Retira a ultimo caracter
	cPrd:= SubStr(cPrd,1,Len(cPrd)-1)
		
	cSql += "UPDATE "+RetSqlName('SB2')+" SET B2_RESERVA=(SELECT ISNULL(SUM(C9_QTDLIB),0) " 
	cSql += "FROM "+RetSqlName('SC9')+" C91 with (nolock) "
	cSql += "WHERE C9_FILIAL=B2_FILIAL AND C9_NFISCAL='' AND C9_PRODUTO=B2_COD AND C9_BLEST='  ' AND C9_BLCRED = '' AND C9_LOCAL = B2_LOCAL AND C91.D_E_L_E_T_='') "
	cSql += "FROM "+RetSqlName('SB2')+" "
	cSql += "WHERE B2_FILIAL ='"+cFilPed+"'  AND B2_LOCAL='"+cCodArm+"' "
	cSql += "AND B2_COD IN "+FormatIn(cPrd,"|")+" "
	cSql += "AND "+RetSqlName('SB2')+".D_E_L_E_T_='' "
		
	If TCSQLExec( cSql ) <> 0
		MsgAlert(OemToAnsi('Falha ao atualizar saldo dos produtos [B2_RESERVA]!'))
		Return(.T.)
	EndIf
	
	cSql:=''	
	
	cSql +="UPDATE "+RetSqlName('SB2')+" SET B2_QPEDVEN =(SELECT ISNULL(SUM(C6_QTDVEN-C6_QTDENT),0) " 
	cSql +="	 FROM "+RetSqlName('SC6')+" C61 with (nolock)      "
	cSql +="LEFT JOIN "+RetSqlName('SC9')+" C91 with (nolock) ON	C9_PRODUTO = C6_PRODUTO  AND   "
	cSql +="					C6_FILIAL = C9_FILIAL AND    "
	cSql +="					C9_LOCAL = C6_LOCAL AND    "
	cSql +="					C9_PEDIDO = C6_NUM AND     "
	cSql +="					C6_ITEM = C9_ITEM AND      "
	cSql +="					C91.D_E_L_E_T_ = ''    "
	cSql +="WHERE                               "
	cSql +="C6_NOTA = '' AND                    "
	cSql +="ISNULL(C9_BLEST,'XX') NOT IN ('','10') AND   "
	cSql +="C6_FILIAL=B2_FILIAL  AND C6_PRODUTO=B2_COD  AND B2_LOCAL = C6_LOCAL AND C6_BLQ <> 'R' AND C6_QTDVEN > C6_QTDENT  "
	cSql +="AND C61.D_E_L_E_T_ = ''  "
	cSql +=")                    "
	cSql += "FROM "+RetSqlName('SB2')+" with (nolock) "
	cSql += "WHERE B2_FILIAL ='"+cFilPed+"' AND B2_LOCAL='"+cCodArm+"' " 
	cSql += "AND B2_COD IN "+FormatIn(cPrd,"|")+" "
	cSql += "AND "+RetSqlName('SB2')+".D_E_L_E_T_='' "
	
	
	/*
	If cFilPed == '0501'
		cSql += "UPDATE "+RetSqlName('SB2')+" SET B2_QPEDVEN=(SELECT ISNULL(SUM(C6_QTDVEN),0) " 
		cSql += "FROM "+RetSqlName('SC6')+" C61 with (nolock) "
		cSql += "WHERE C6_FILIAL=B2_FILIAL AND C6_PRODUTO=B2_COD AND C6_LOCAL = B2_LOCAL AND C61.D_E_L_E_T_='' "
		cSql += "AND NOT EXISTS (SELECT * FROM "+RetSqlName('SC9')+" WHERE C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C6_PRODUTO = C9_PRODUTO " 
		cSql += "AND C9_ITEM = C6_ITEM AND D_E_L_E_T_ = '') ) "
		cSql += "FROM "+RetSqlName('SB2')+" "
		cSql += "WHERE B2_FILIAL ='"+cFilPed+"' AND B2_LOCAL='"+cCodArm+"' " 
		cSql += "AND B2_COD IN "+FormatIn(cPrd,"|")+" "
		cSql += "AND "+RetSqlName('SB2')+".D_E_L_E_T_='' "
	Else			
		cSql += "UPDATE "+RetSqlName('SB2')+" SET B2_QPEDVEN=(SELECT ISNULL(SUM(C6_QTDVEN),0) " 
		cSql += "FROM SC6050 C61 with (nolock) "
		cSql += "WHERE C6_FILIAL=B2_FILIAL AND C6_PRODUTO=B2_COD AND C6_LOCAL = B2_LOCAL AND C61.D_E_L_E_T_='' AND C6_NOTA = '') "
		cSql += "FROM "+RetSqlName('SB2')+" "
		cSql += "WHERE B2_FILIAL ='"+cFilPed+"' AND B2_LOCAL='"+cCodArm+"' " 
		cSql += "AND B2_COD IN "+FormatIn(cPrd,"|")+" "
		cSql += "AND "+RetSqlName('SB2')+".D_E_L_E_T_='' "
	EndIf	
	
	
	*/		
	If TCSQLExec( cSql ) <> 0
		MsgAlert(OemToAnsi('Falha ao atualizar saldo dos produtos [B2_QPEDVEN]!'))
	EndIf
	
Return(Nil)
