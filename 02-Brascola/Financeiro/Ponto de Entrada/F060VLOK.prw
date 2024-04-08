#include "rwmake.ch"


User Function F060VLOK()
Local cNumBor := paramixb[1]
Local cPort060 := paramixb[2]
Local cAgen060 := paramixb[3]
Local cConta060 := paramixb[4]
Local cSituacao       
local aArea:= GetArea() 
private cconta:='11220011'



nCusto 	:= 0     
Vbanco := SPACE(3)
vCodigo := Space(30)
vSair 	:= .f.
Aviso	:= Space(50)
nMes    := 0   
 VDESC :=SPACE(30)


IF MsgYesNo("Carteira descontada?")

	While vSair == .f.
	
		@ 3,1 TO 250,350 DIALOG oDlg1 TITLE "Digitar Banco desconto"
	
		@ 80,010 BUTTON "_Gravar"           SIZE 60,10 ACTION Gravar()// Substituido pelo assistente de conversao do AP6 IDE em 18/10/02 ==>    @ 102,015 BUTTON "_Imprimir"      SIZE 30,20 ACTION Execute(Impetiq)
		@ 80,090 BUTTON "_Sair"               SIZE 30,10 ACTION sair()// Substituido pelo assistente de conversao do AP6 IDE em 18/10/02 ==>    @ 102,158 BUTTON "_Sair"          SIZE 30,20 ACTION Execute(sair)
	
	//@ 05,003 To 30,350
   
		@ 14,005 Say "Banco:"
		@ 14,035 Get  Vbanco                    SIZE 50,20 Pict "@!"  F3("SA6") Valid Verif_BANCO(Vbanco )
	
		@ 30,005 Say "Des:"
		@ 30,035 Get  VDESC                     SIZE 120,20 Pict "@!"  when .f.
	
		ACTIVATE DIALOG oDlg1 CENTERED
	end
endif
RestArea(aArea)

RETURN .t.


****************************************************************************
Static Function Gravar()

local aArea:= GetArea() 


DBSELECTAREA("SA6")
DBSETORDER(1)
DBSEEK(XFILIAL("SA6")+Vbanco)

_CCONTA:= SA6->A6_X_CTDES
 

dbSelectArea("SX6")
dbSeek(xFilial("SX6")+"BR_000080")
if found()
	cDoc  := substr(X6_CONTEUD,1,10)
	cDoc1 := Substr(soma1(substr(X6_CONTEUD,1,10)),1,10)
	if RecLock("SX6",.f.)	
		replace X6_CONTEUD with _CCONTA
		MSUnlock()
	endif
else
	cDoc:=_CCONTA
	if RecLock("SX6",.T.)	
		replace X6_VAR with "BR_000080"
		replace X6_TIPO with "C"
		replace X6_CONTEUD with cDoc
		MSUnlock()
	endif
endif


Close(oDlg1)
vSair := .t.

//msgalert("entrei") 

RestArea(aArea)
RETURN .T.                                    






static function Verif_BANCO(Vbanco)

dbselectarea("SA6")
DBSETORDER(1)
DBSEEK(XFILIAL("SA6")+Vbanco)

VDESC:= SA6->A6_NOME

RETURN
                           


Static Function Sair()
Close(oDlg1)
vSair := .t.
Return




Return