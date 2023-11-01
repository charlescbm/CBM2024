#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX210													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Scheduler de ajuste de % de comissao				 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 19/08/2022												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX210( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SD2","SF2","SA3"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Recalculo/Ajuste de Comissao - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_IFATM060(.T.)

RpcClearEnv()

Return
