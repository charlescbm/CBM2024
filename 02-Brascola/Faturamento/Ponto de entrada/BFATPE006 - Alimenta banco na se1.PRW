#include "rwmake.ch"

User Function M040SE1

If SF2->F2_DOC <> ""

RecLock("SE1",.F.)
SE1->E1_PORTADO := SC5->C5_BANCO
SE1->(MsUnlock())

Endif

Return



