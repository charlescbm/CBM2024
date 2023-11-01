#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX420													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Ajuste do valor do frete vindos do CTE			 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 27/08/2023												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX420( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SD2","GWM"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Ajuste do valor do frete CTE - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_XFTEC420()

RpcClearEnv()

Return

User Function XFTEC420()

If (Select("QRYNF") <> 0)
	QRYNF->(dbCloseArea())
Endif
BEGINSQL ALIAS "QRYNF"
	SELECT GWM_VLFRET,GWM_NRDOC,D2_DOC,D2_SERIE,D2_ITEM,D2_COD,
	D2_ZPRVFRE,D2.R_E_C_N_O_ D2RECNO
	FROM %table:SD2% D2
	INNER JOIN %table:GWM% GWM ON GWM_FILIAL = D2_FILIAL
	AND GWM_NRDC = D2_DOC
	AND GWM_SERDC = D2_SERIE
	AND GWM_SEQGW8 = D2_ITEM
	AND GWM_ITEM = D2_COD
	WHERE D2.%notdel% AND D2_ZTPFRE = 'P'
	AND D2_ZPRVFRE <> 0
	AND GWM.%notdel% AND GWM_TPDOC = '2'
ENDSQL

QRYNF->(dbGoTop())
While !QRYNF->(EOF())

	SD2->(dbGoTo(QRYNF->D2RECNO))
	SD2->(recLock('SD2',.F.))
	SD2->D2_ZPRVFRE := QRYNF->GWM_VLFRET
	SD2->D2_ZTPFRE	:= "R"
	SD2->(msUnlock())

	QRYNF->(dbSkip())
End

Return

