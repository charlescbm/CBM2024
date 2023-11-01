#include "protheus.ch"

// *********************************************************************** //
// A010TOK - Ponto de entrada para validar informacoes do produto          //
// @copyright (c) 2018-07-14 > Marcelo da Cunha > GDView                   //
// *********************************************************************** //

User Function A010TOK()
    *******************
    LOCAL lRetu := .T.

    // Gravo historico
    If (lRetu).and.ExistBlock("GDVHCOMPARA")
        If (ALTERA).and.(SB1->(Eof())).and.!Empty(M->B1_cod)
            SB1->(dbSeek(xFilial("SB1")+M->B1_cod,.T.))
        Endif
        u_GDVHCompara("SB1")
    Endif

Return lRetu