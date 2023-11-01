#INCLUDE 'PROTHEUS.CH'

#DEFINE CRLF CHR(13) + CHR(10)

/*********************************************************************************************/
/*/ IFATM001

@description Valida se nota pertence a uma romaneio
@param cStatus	, characters, descricao
@param nOpc		, numeric, descricao
@type function
/*/
/*********************************************************************************************/
//DESENVOLVIDO POR INOVEN

User Function IFATM001(cStatus,cCodRom,nOpcX)
Local aArea	:= GetArea()

//---------------------------+
// Valida se existe romaneio |
//---------------------------+
If nOpcX == 1 
	TFatM01Vld(@cStatus,@cCodRom)
//------------------+
// Estorna romaneio |
//------------------+
ElseIf nOpcX == 2
	TFatM01Del()
EndIf

RestArea(aArea)	
Return Nil 

/*********************************************************************************************/
/*/ TFatM01Vld

@description Valida se nota está em romaneio 

@type function
/*/
/*********************************************************************************************/
Static Function TFatM01Vld(cStatus,cCodRom)
Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZE.ZZE_STATUS, " + CRLF
cQuery += "		ZZE.ZZE_CODIGO " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZE") + " ZZE " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_NOTA = '" + SF2->F2_DOC + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_SERIE = '" + SF2->F2_SERIE + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_CODCLI = '" + SF2->F2_CLIENTE + "' AND " + CRLF
cQuery += "		ZZE.ZZE_LOJA = '" + SF2->F2_LOJA + "' AND " + CRLF
cQuery += "		ZZE.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

If (cAlias)->( Eof() )
	cStatus := "0"
	cCodRom	:= ""
Else
	cStatus := (cAlias)->ZZE_STATUS
	cCodRom	:= (cAlias)->ZZE_CODIGO
EndIf

(cAlias)->( dbCloseArea() )

Return .T.

/*********************************************************************************************/
/*/ TFatM01Del

@description Realiza o estorno da nota no romaneio 

@type function
/*/
/*********************************************************************************************/
Static Function TFatM01Del()
Local aArea	:= GetArea()

Local cAlias	:= GetNextAlias()
Local cQuery	:= ""

cQuery := "	SELECT " + CRLF 
cQuery += "		ZZE.R_E_C_N_O_ RECNOZZE " + CRLF
cQuery += "	FROM " + CRLF
cQuery += "		" + RetSqlName("ZZE") + " ZZE " + CRLF 
cQuery += "	WHERE " + CRLF
cQuery += "		ZZE.ZZE_FILIAL = '" + xFilial("ZZE") + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_NOTA = '" + SF2->F2_DOC + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_SERIE = '" + SF2->F2_SERIE + "' AND " + CRLF 
cQuery += "		ZZE.ZZE_CODCLI = '" + SF2->F2_CLIENTE + "' AND " + CRLF
cQuery += "		ZZE.ZZE_LOJA = '" + SF2->F2_LOJA + "' AND " + CRLF
cQuery += "		ZZE.D_E_L_E_T_ = '' "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

//------------------------------+
// Valida se nao foi encontrado |
//------------------------------+
If (cAlias)->( Eof() )
	(cAlias)->( dbCloseArea() )
	RestArea(aArea)
	Return .T.
EndIf

//-------------------------------------+
// Realiza estorno da nota no romaneio |
//-------------------------------------+
dbSelectArea("ZZE")
ZZE->( dbSetOrder(1) )
ZZE->( dbGoTo((cAlias)->RECNOZZE) )
RecLock("ZZE",.F.)
	ZZE->( dbDelete() )
ZZE->( MsUnLock() )	

RestArea(aArea)
Return .T.
