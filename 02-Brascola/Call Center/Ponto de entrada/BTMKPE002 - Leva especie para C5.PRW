#include "rwmake.ch"

User Function TMKVFIM

If SUA->UA_OPER <> ""
	
	RecLock("SC5",.F.)
	SC5->C5_ESPECI1 := SUA->UA_ESPECIE
	SC5->C5_NOMECLI := Posicione("SA1",1,XFILIAL("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_NOME")
	SC5->(MsUnlock())
	
	
Endif

Return
