#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza��o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! Ponto Eletronico                                        !
+------------------+---------------------------------------------------------+
!Nome              ! PNM010CPOS                                              !
+------------------+---------------------------------------------------------+
!Descricao         ! PON - Adicionar campos do SRA para a forma��o da Query  !
!				   ! do Cadastro do Funcion�rio que ser� utilizado           !
!				   ! na Rotina de Apontamento das Marca��es                  !
+------------------+---------------------------------------------------------+
!Autor             ! FERNANDO SIMOES DA MAIA                                 !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 11/09/2013                                              !
+------------------+---------------------------------------------------------+
*/      
//http://tdn.totvs.com/display/public/mp/PNM010CP+-+Adiciona+campos++--+10428
User Function PNM010CPOS()
Local aCampos:= ParamIXB

Aadd(aCampos, "RA_NASC")
Aadd(aCampos, "RA_ACUMBH")

Return aCampos
