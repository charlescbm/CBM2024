#include "protheus.ch"

// *********************************************************************** //
// MT140CPO - Ponto de entrada para adicionar campos na prenota            //
// @copyright (c) 2014-04-07 > Marcelo da Cunha > GDVIEW                   //
// *********************************************************************** //

User Function MT140CPO()
	*********************
	LOCAL aRetu := {}
	aadd(aRetu,"D1_ICMSRET")
	aadd(aRetu,"D1_VALFRE")
	aadd(aRetu,"D1_SEGURO")
	aadd(aRetu,"D1_DESPESA")
	aadd(aRetu,"D1_FCICOD")
	If (SD1->(FieldPos("D1_GDVITEM")) > 0)
		aadd(aRetu,"D1_GDVITEM")
	Endif
Return aRetu
