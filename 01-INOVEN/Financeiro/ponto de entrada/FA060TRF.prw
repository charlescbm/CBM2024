#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//DESENVOLVIDO POR INOVEN


User Function FA060TRF()

//Se chamada pela leitura do retorno do banco
if IsInCallStack("FINA200") .or. IsInCallStack("U_GOOKTRANS")
    //mv_par04 - baixa titulos descontados - 1=Sim, 2=Nao

    SX1->(dbSetOrder(1))
    if SX1->(dbSeek(Padr("FIN060",len(SX1->X1_GRUPO))+"04"))
        //alert(SX1->X1_PRESEL)
        SX1->(recLock("SX1", .F.))
        SX1->X1_PRESEL := 2
        SX1->(msUnlock())
    endif
    Pergunte("FIN060",.F.)

endif

Return(.T.)
