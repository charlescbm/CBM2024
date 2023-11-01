#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

//__________________________________________________________________________________________________
//|Go One - Marcelo   																			   |
//|Quando se referir aos complementos para geracao dos registros C110 e C113					   |
//|a tabela CDT também deve ser alimentada, pois ela que efetua o relacionamentos com as outras	   |
//|conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, C112 = Tab. CDC, C113 = Tab. CDD,          |
//|C114 = Tab. CDE e C115 = Tab. CDF 															   |
//|________________________________________________________________________________________________|
//DESENVOLVIDO POR INOVEN


User Function MATUCOMP()

	Local aAreaSD2 := SD2->( GetArea() )
//	Local aAreaSD1 := SD1->( GetArea() )
	Local aAreaSF2 := SF2->( GetArea() )
//	Local aAreaSF1 := SF1->( GetArea() )
	Local aAreaSFT := SFT->( GetArea() )
	Local aAreaSF3 := SF3->( GetArea() )
	Local aAreaSF4 := SF4->( GetArea() )
//	Local aAreaCDD := CDD->( GetArea() )
//	Local aAreaCDT := CDT->( GetArea() )
	Local aAreaCDG := CDG->( GetArea() )
	Local aAreaCCF := CCF->( GetArea() )

	//Local cIfComp  := ""

	Private cEntSai  := ParamIXB[1]
	Private cSerie   := ParamIXB[2]
	Private cDoc     := ParamIXB[3]
	Private cCliefor := ParamIXB[4]
	Private cLoja    := ParamIXB[5]

	If cEntSai == "S"

		dbSelectArea("SD2")
		SD2->(dbSetOrder(RetOrder(,"D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM")))
		If SD2->(dbSeek(xFilial("SD2") + cDoc + cSerie + cClieFor + cLoja)) .And. !(SD2->D2_TIPO $ "CTE/CTR")


			SF4->(DbSetOrder(1))

			While !SD2->( Eof() ) .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_DOC == cDoc .And. SD2->D2_SERIE == cSerie .And. ;
			SD2->D2_CLIENTE == cClieFor .And. SD2->D2_LOJA == cLoja


				SF4->(DbSeek(xFilial("SF4")+SD2->D2_TES))

				cPisCof	:= SF4->F4_PISCOF
				cPisCred:= SF4->F4_PISCRED
				cICM	:= SF4->F4_ICM
				cLICM	:= SF4->F4_LFICM


				If cPisCof == "3" .And. cPisCred == "2" .And. cICM == "S" .And. cLICM == "T"

					DbSelectArea("CDG")
					CDG->(DbSetOrder(3))	//CDG_FILIAL+CDG_TPMOV+CDG_DOC+CDG_SERIE+CDG_CLIFOR+CDG_LOJA+CDG_ITEM

					DbSelectArea("CCF")
					CCF->(DbSetOrder(1))	//CCF_FILIAL+CCF_NUMERO+CCF_TIPO+CCF_INDAUT+CCF_IDITEM

					CCF->(DbSeek(xFilial("CCF")))	//Pegar o 1º registro da filial corrente

					If ! CDG->(DbSeek(xFilial("CDG") + cEntSai + cDoc + cSerie + cClieFor + cLoja + SD2->D2_ITEM))

						RecLock("CDG", .T.)
					Else
						RecLock("CDG", .F.)
					EndIf

					CDG_FILIAL := xFilial("CDG")
					CDG_TPMOV  := "S"
					CDG_DOC    := cDoc
					CDG_SERIE  := cSerie
					CDG_CLIFOR := cClieFor
					CDG_LOJA   := cLoja
					CDG_IFCOMP := "ZZZC" 
					CDG_PROCES := CCF->CCF_NUMERO
					CDG_TPPROC := "1"
					CDG_CANC   := ""
					CDG_SDOC   := cSerie
					CDG_ITPROC := "00000001"
					CDG_VALOR  := SD2->D2_VALICM
					CDG_ITEM   := SD2->D2_ITEM

					CDG->(MsUnlock())

				EndIf

				SD2->( DbSkip() )

			EndDo

		EndIf

	Endif


	RestArea(aAreaSD2)
//	RestArea(aAreaSD1)
	RestArea(aAreaSF2)
//	RestArea(aAreaSF1)
	RestArea(aAreaSFT)
	RestArea(aAreaSF3)
	RestArea(aAreaSF4)
//	RestArea(aAreaCDD)
//	RestArea(aAreaCDT)
	RestArea(aAreaCDG)
	RestArea(aAreaCCF)

Return
