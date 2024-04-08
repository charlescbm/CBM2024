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
Local cUsrTpOp  := GETMV("BR_000010")//usu�rios com acesso para utilizar tipos de opera��o especiais 
Local cTpOp     := GETMV("BR_000011")//Tipo de Opera��es Restritas    
Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usu�rio logado. 
Local lRet      := .T.

/**************************VALIDA��O USU�RIO COM PERMISSAO DE USAR TIPO DE OPERA��O RESTRITA ***************************/
DbSelectArea("SC6")
//dbGoTop()

//nPos1      := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_OPER"}) // Posicao do Campo C6_OPER
//cOper      := AllTrim(aCols[n,nPos1])  //Grava na variavel o conte�do   
cOper:= M->C6_OPER

If (cOper $ cTpOp)
	If (cUsuario $ cUsrTpOp)
		lRet := .T.
	Else   
		Aviso("Tipo de Opera��o Restrita","Usu�rio sem permiss�o para usar este Tipo de Opera��o!",{"OK"})
		lRet := .F.
	    Return(lRet)
	EndIf
EndIf

Return lRet