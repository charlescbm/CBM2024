#include "protheus.ch"

// *********************************************************************** //
// MTA103MNU - Ponto de Entrada para adicionar botao para receber XML      //
// @copyright (c) 18/11/13 > Marcelo da Cunha > GDVIEW                     //
// *********************************************************************** //

User Function MTA103MNU()
	**********************
	LOCAL bConsulta
	If ExistBlock("G050RecebPre") //Verifico rotina G050RecebPre
		bConsulta := "MsgRun('GDVIEW XML > Gerando Documento... ','',{ || u_G050RecebPre() })"
		aadd(aRotina,{"GDVIEW XML",bConsulta,0,3,0,nil})
	Endif
Return
