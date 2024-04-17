#Include "Protheus.ch" 

/*
臼浜様様様様用様様様様様僕様様様冤様様様様様様様様様曜様様様冤様様様様様様傘�
臼�Programa  � MTA450I   �Autor  �Microsiga          � Data �  09/11/12   艮�
臼麺様様様様謡様様様様様瞥様様様詫様様様様様様様様様擁様様様詫様様様様様様恒�
臼�Desc.     � APOS ATUALIZACAO DA LIBERACAO DO PEDIDO 
               Executado apos atualizacao da liberacao de pedido.
臼麺様様様様謡様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様恒�
臼�Uso       � AP                                                        艮�
臼藩様様様様溶様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様識�
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
