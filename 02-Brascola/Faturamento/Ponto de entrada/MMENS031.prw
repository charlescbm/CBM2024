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
     
User Function MMENS031

Local cUsuario  := AllTrim(USRRETNAME(RETCODUSR())) //Captura usu�rio logado. 
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


cMensagem := "O Pedido de Venda N�mero: "+cPedido+" " +chr(13)+chr(10)+;
"Cliente                 :"+cCliente+" - "+cNomeCli+""+chr(13)+chr(10)+;
"Loja                    : "+cLoja+""                 +chr(13)+chr(10)+;
"Foi exclu�do por        : "+cNomeUser+"."            +chr(13)+chr(10)+""

Return(cMensagem)