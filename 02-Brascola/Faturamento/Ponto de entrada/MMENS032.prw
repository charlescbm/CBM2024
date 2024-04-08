/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! MMENS+(C�digo do Evento)                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de Entrada Para Alterar Relat�rios do Messenger   !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/02/2012                                              !
+------------------+---------------------------------------------------------+
*/
     
User Function MMENS032 //C�digo 032 - Inclus�o de Clientes

Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usu�rio logado. 
Local cNomeUser := AllTrim(UsrFullName(RETCODUSR()))
Local cCodigo	:= ""	
Local cCliente  := ""
Local cLoja		:= ""
Local aDados	:= ParamIXB[1]
Local cMensagem := ParamIXB[2]

cCodigo  := aDados[1]
cCliente := aDados[3] 
cLoja    := aDados[2]

cMensagem := "Inclus�o de novo Cliente! "+chr(13)+chr(10)+chr(13)+chr(10)+;
"C�digo          : "+cCodigo+" "         +chr(13)+chr(10)+;
"Loja            : "+cLoja+""            +chr(13)+chr(10)+;
"Cliente         : "+cCliente+" "        +chr(13)+chr(10)+chr(13)+chr(10)+;
"Incluido por    : "+cNomeUser+"."       +chr(13)+chr(10)+""

Return(cMensagem)