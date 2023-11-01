#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//DESENVOLVIDO POR INOVEN


User Function FA60FIL()
Local aBanco	:= { "Sim","Nao" }
Local cRet      := '.T.'
Local xParBor   := PARAMIXB[1]

Private aParam	:= {}

xBkpPar01 := mv_par01

IF PARAMBOX( { 	{3,"Filtra o Banco",1,aBanco,120,"",.T.}	;
                }, "CRIACAO BORDERO", @aParam,,,,,,,,.F.,.T.)

    //Se filtra por banco
    if mv_par01 == 1
        cRet := "SE1->E1_PORTADO == '" + xParBor + "'"
        cRet += ".AND. alltrim(SE1->E1_XFORMA) == 'BOL' .and. !empty(SE1->E1_NUMBCO)"
    endif

ENDIF

mv_par01 := xBkpPar01

Return(cRet)
