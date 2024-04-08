#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

User Function BUSCAP74()
************************

_cPos74:=SRA->RA_FILIAL+;
STRZERO(DAY(DATE()),2)+;
STRZERO(MONTH(DATE()),2)+;
SUBSTR(STRZERO(YEAR(DATE()),4),3,2)+;
SUBSTR(TIME(),1,2)+;
SUBSTR(TIME(),4,2)+;
STRZERO(VAL(SRA->RA_MAT),4)+;
STRZERO(VAL(SRA->RA_MAT),4)
Return(_cPos74)
return