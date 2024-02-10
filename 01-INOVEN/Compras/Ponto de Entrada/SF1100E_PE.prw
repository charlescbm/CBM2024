#include "protheus.ch"

// *********************************************************************** //
// SF1100E - Ponto de Entrada para atualizar status da NF-e Classifica     //
// @copyright (c) 2013-10-21 > Marcelo da Cunha > GDVIEW                   //
// *********************************************************************** //

User Function SF1100E()
	*********************
	LOCAL lRetu := .T.

	// Funcao para atualizar status do arquivo ZGN
	If ExistBlock("G050AtuStatus")
		u_G050AtuStatus(2) //2=NF-e Excluida ou Estorno Classificacao
	Endif

Return lRetu
