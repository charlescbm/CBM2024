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
     
User Function MMENS031

Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usuário logado. 
Local cNomeUser := AllTrim(UsrFullName(RETCODUSR()))
Local cPedido	:= ""	
Local cCliente  := ""
Local cNomeCli  := ""
Local cLoja		:= ""
Local aDados	:= ParamIXB[1]
Local cMensagem := ParamIXB[2]

DbSelectArea("SC5") 

cPedido  := M->C5_NUM
cCliente := M->C5_CLIENTE 
cNomeCli := M->C5_NOMECLI
cLoja    := M->C5_LOJACLI


cMensagem := "O Pedido de Venda Número: "+cPedido+" " +chr(13)+chr(10)+;
"Cliente                 :"+cCliente+" - "+cNomeCli+""+chr(13)+chr(10)+;
"Loja                    : "+cLoja+""                 +chr(13)+chr(10)+;
"Foi excluído por        : "+cNomeUser+"."            +chr(13)+chr(10)+""

Return(cMensagem)