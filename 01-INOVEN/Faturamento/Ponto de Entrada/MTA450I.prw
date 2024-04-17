#Include "Protheus.ch" 

/*
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MTA450I   บAutor  ณMicrosiga          บ Data ณ  09/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ APOS ATUALIZACAO DA LIBERACAO DO PEDIDO 
               Executado apos atualizacao da liberacao de pedido.
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/
//DESENVOLVIDO POR INOVEN

User Function MTA450I()
Local nOpc	:= ParamIXB[1]
Local aArea	:= GetArea()
Local _x

If nOpc == 1 .Or. nOpc == 4 

	/*if Type("cGoTitR") <> 'U' .and. !empty(cGoTitR)
		SC5->(dbSetOrder(1))
		if SC5->(msSeek(xFilial("SC5") + SC9->C9_PEDIDO))
			SC5->(recLock("SC5", .F.))
			SC5->C5_ZFINANT := cGoTitR
			SC5->(msUnlock())
		endif

		if Type("nGoTitR") <> 'U' .and. !empty(nGoTitR)
			SE1->(dbGoto(nGoTitR))
			SE1->(recLock("SE1", .F.))
			SE1->E1_PEDIDO := SC5->C5_NUM
			SE1->(msUnlock())
		endif
	endif*/
	if Type("aGoTitR") <> 'U' .and. !empty(len(aGoTitR))
		For _x := 1 to len(aGoTitR)
			SE1->(dbGoto(aGoTitR[_x][2]))
			SE1->(recLock("SE1", .F.))
			SE1->E1_PEDIDO := aGoTitR[_x][1]
			SE1->(msUnlock())
		next
	endif

	u_DnyGrvSt(SC9->C9_PEDIDO, "000006")
  	RestArea(aArea)
EndIf

Return()
