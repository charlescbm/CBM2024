#include "protheus.ch"

// *********************************************************************** //
// SF1100I - Ponto de Entrada para atualizar status da NF-e Classifica     //
// @copyright (c) 2013-10-21 > Marcelo da Cunha > GDVIEW                   //
// *********************************************************************** //

User Function SF1100I()
	*********************
	LOCAL lRetu := .T.

	// Funcao para atualizar status do arquivo ZGN
	If (lRetu).and.ExistBlock("G050AtuStatus")
		u_G050AtuStatus(1) //1=NF-e Classificada
	Endif

Return lRetu
