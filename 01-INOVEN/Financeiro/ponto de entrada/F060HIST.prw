#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//DESENVOLVIDO POR INOVEN


User Function F060HIST()
Local cArqRet := ''
Local cHistDes := "Tit.p/desconto "

//Se chamada pela leitura do retorno do banco
if IsInCallStack("FINA200")

    if Type("cGoVal200") <> 'U'
        cGoVal200 := strTran(cGoVal200,'\','/')
		aName := Separa(cGoVal200,'/',.t.)
		if !empty(len(aName))
            cArqRet := aName[len(aName)]
		endif
        if empty(cArqRet)
            aName := Separa(cGoVal200,'\',.t.)
            if !empty(len(aName))
                cArqRet := aName[len(aName)]
            endif
        endif
        cHistDes += cArqRet
    endif

endif

if IsInCallStack("U_GOOKTRANS")
    cNatureza := cNatu005
    cHistDes := cHist005
endif

Return(cHistDes)
