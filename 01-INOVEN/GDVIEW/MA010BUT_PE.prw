#include "rwmake.ch"

// *********************************************************************** //
// MA010BUT - Ponto de Entrada para Adicionar Botoes no MATA010            //
// @copyright (c) 2012-09-01 > Marcelo da Cunha > GDView               //
// *********************************************************************** //

User Function MA010BUT()
    *********************
    LOCAL aButtons := {}
    If ExistBlock("GDVHISTMAN") //Verifico rotina GDVHISTMAN
        aadd(aButtons,{"OPEN",{|| visHistorico() },"Historico","Historico"})
    Endif
Return aButtons

Static Function visHistorico()
    ***************************
    LOCAL lSB1 := .T.
    If (SB1->(Bof()).or.SB1->(Eof())).and.(Type("M->B1_COD") == "C")
        SB1->(dBSetOrder(1))
        lSB1 := SB1->(dbSeek(xFilial("SB1")+M->B1_COD))
    Endif
    If (lSB1)
        u_GDVHistMan("SB1")
    Endif
Return
