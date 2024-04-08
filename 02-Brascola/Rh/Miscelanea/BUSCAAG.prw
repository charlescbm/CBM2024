#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function BUSCAAG()
************************

_cAgencia:=STRZERO(VAL(SUBSTR(SRA->RA_BCDEPSA,4,5)),5)

Return(_cAgencia)