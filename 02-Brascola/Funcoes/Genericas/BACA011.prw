#include "rwmake.ch"
#include "topconn.ch"

User Function BACA011()
*********************
If (Alltrim(cUserName) == "mcunha").and.MsgYesNo("> Rotina para atualizar empenhos?","ATENCAO")
	Processa({|| B011Proc() })
Endif
Return

Static Function B011Proc()
***********************
LOCAL cQuery1 := "", nQtdSD4 := 0, nQtdSB8 := 0, cLocal1 := "11"

//Zero campo de PickList SB8 e SD4
//////////////////////////////////
cQuery1 := "UPDATE SB8010 SET B8_PICKLST = 0 WHERE D_E_L_E_T_='' AND B8_FILIAL='"+xFilial("SB8")+"' AND B8_SALDO > 0 AND B8_PICKLST > 0 "
TCSQLExec(cQuery1)
cQuery1 := "UPDATE SD4010 SET D4_PICKLST = 0 WHERE D_E_L_E_T_='' AND D4_FILIAL='"+xFilial("SD4")+"' AND D4_QUANT > 0 AND D4_PICKLST > 0 "
TCSQLExec(cQuery1)

//Adualizo Empenhos de Acordo com Lotes
///////////////////////////////////////
cQuery1 := "SELECT R_E_C_N_O_ MRECSD4 FROM "+RetSqlName("SD4")+" "
cQuery1 += "WHERE D_E_L_E_T_ = '' AND D4_FILIAL = '"+xFilial("SD4")+"' "
cQuery1 += "AND D4_QUANT > 0 ORDER BY D4_DATA,D4_OP,D4_COD,D4_LOCAL "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSD4") <> 0)
	dbSelectArea("MSD4")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSD4"
SD4->(dbSetOrder(1)) ; SB8->(dbSetOrder(1))
dbSelectArea("MSD4")
While !MSD4->(Eof())
	SD4->(dbGoto(MSD4->(MRECSD4)))
	If (SD4->D4_quant > 0)
	   nQtdSD4 := SD4->D4_quant
		SB8->(dbSeek(xFilial("SB8")+SD4->D4_cod+cLocal1,.T.))
		While !SB8->(Eof()).and.(xFilial("SB8") == SB8->B8_filial).and.(SB8->B8_produto+SB8->B8_local == SD4->D4_cod+cLocal1)
			nQtdSB8 := (SB8->B8_saldo-SB8->B8_picklst)
			If (nQtdSD4 > 0).and.(nQtdSB8 > 0).and.(SB8->B8_dtvalid >= MsDate())
				If (nQtdSB8 >= nQtdSD4)
					//SB8/////////////
					RecLock("SB8",.F.)
					SB8->B8_picklst += nQtdSD4
					MsUnlock("SB8")
					//SD4/////////////
					RecLock("SD4",.F.)
					SD4->D4_picklst += nQtdSD4
					MsUnlock("SD4")
					//////////////////
					nQtdSD4 := 0
				Elseif (nQtdSB8 < nQtdSD4)
					//SB8/////////////
					RecLock("SB8",.F.)
					SB8->B8_picklst += nQtdSB8
					MsUnlock("SB8")
					//SD4/////////////
					RecLock("SD4",.F.)
					SD4->D4_picklst += nQtdSB8
					MsUnlock("SD4")
					//////////////////
					nQtdSD4 -= nQtdSB8
				Endif
			EndIf
			If (nQtdSD4 <= 0)
				Exit
			Endif				
			SB8->( dbSkip() )
		Enddo
	Endif
	MSD4->(dbSkip())
Enddo
If (Select("MSD4") <> 0)
	dbSelectArea("MSD4")
	dbCloseArea()
Endif

Return