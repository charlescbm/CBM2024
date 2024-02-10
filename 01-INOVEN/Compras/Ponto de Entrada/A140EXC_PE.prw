#include "protheus.ch"

// *********************************************************************** //
// A140EXC - Ponto de Entrada para retirar marcacao de Pré-nota Gerada     //
// @copyright (c) 2013-10-21 > Marcelo da Cunha > GDVIEW                   //
// *********************************************************************** //

User Function A140EXC()
	*********************
	LOCAL lRetu := .T.

	// Funcao para atualizar status do arquivo ZGN
	If ExistBlock("G050AtuStatus")
		u_G050AtuStatus(3) //3=Pré-nota Excluida
	Endif

Return lRetu
