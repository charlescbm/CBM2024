#include "rwmake.ch"

// *********************************************************************** //
// MT010BRW - Ponto de Entrada para Adicionar Botoes no MATA010            //
// @copyright (c) 2012-09-01 > Marcelo da Cunha > GDView               //
// *********************************************************************** //

User Function MT010BRW()
	*********************
	LOCAL aRetu := {}, bConsulta
	If ExistBlock("GDVA010") //Verifico rotina GDVA010
		bConsulta := "MsgRun('GDView Produto. Aguarde... ','',{ || u_GDVA010() })"
		aadd(aRetu,{"GDView Produto",bConsulta,0,2,0,nil})
	Endif
	If ExistBlock("GDVA011") //Verifico rotina GDVA011
		bConsulta := "MsgRun('GDView Estoque. Aguarde... ','',{ || u_GDVA011() })"
		aadd(aRetu,{"GDView Estoque",bConsulta,0,2,0,nil})
	Endif
Return aRetu