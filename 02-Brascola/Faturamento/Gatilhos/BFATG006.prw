#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"   

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Gatilho                                                 !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BFATG006                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Gatilho que verifica User x Tipo de Operacao Restrita   !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 12/09/2012                                              !
+------------------+---------------------------------------------------------+
*/

User Function BFATG006()

//Fernando
Local cUsrTpOp  := GETMV("BR_000010")//usuários com acesso para utilizar tipos de operação especiais 
Local cTpOp     := GETMV("BR_000011")//Tipo de Operações Restritas    
Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usuário logado. 
Local lRet      := .T.

/**************************VALIDAÇÃO USUÁRIO COM PERMISSAO DE USAR TIPO DE OPERAÇÃO RESTRITA ***************************/
DbSelectArea("SC6")
//dbGoTop()

//nPos1      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_OPER"}) // Posicao do Campo C6_OPER
//cOper      := AllTrim(aCols[n,nPos1])  //Grava na variavel o conteúdo   
cOper:= M->C6_OPER

If (cOper $ cTpOp)
	If (cUsuario $ cUsrTpOp)
		lRet := .T.
	Else   
		Aviso("Tipo de Operação Restrita","Usuário sem permissão para usar este Tipo de Operação!",{"OK"})
		lRet := .F.
	    Return(lRet)
	EndIf
EndIf

Return lRet