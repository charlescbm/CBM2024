/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! MMENS+(Código do Evento)                                               !
+------------------+---------------------------------------------------------+
!Descricao         ! Ponto de Entrada Para Alterar Relatórios do Messenger   !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA		                         !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 09/02/2012                                              !
+------------------+---------------------------------------------------------+
*/
     
User Function MMENS032 //Código 032 - Inclusão de Clientes

Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usuário logado. 
Local cNomeUser := AllTrim(UsrFullName(RETCODUSR()))
Local cCodigo	:= ""	
Local cCliente  := ""
Local cLoja		:= ""
Local aDados	:= ParamIXB[1]
Local cMensagem := ParamIXB[2]

cCodigo  := aDados[1]
cCliente := aDados[3] 
cLoja    := aDados[2]

cMensagem := "Inclusão de novo Cliente! "+chr(13)+chr(10)+chr(13)+chr(10)+;
"Código          : "+cCodigo+" "         +chr(13)+chr(10)+;
"Loja            : "+cLoja+""            +chr(13)+chr(10)+;
"Cliente         : "+cCliente+" "        +chr(13)+chr(10)+chr(13)+chr(10)+;
"Incluido por    : "+cNomeUser+"."       +chr(13)+chr(10)+""

Return(cMensagem)