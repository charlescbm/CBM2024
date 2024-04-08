#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTSLDLOT ºAutor  ³ Marcelo da Cunha   º Data ³  04/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para bloquear lotes para estados nordeste º±±
±±º          ³ quanto o vencimento for menor que 180 dias.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTSLDLOT()
*********************
LOCAL lRetu1 := .T., aSeg1 := GetArea(), cQuery1 := ""
LOCAL cProdu := paramixb[1], cLocal := paramixb[2], cNLote := paramixb[3]
LOCAL nDias := SuperGetMV("BR_000037",.F.,180) //6 Meses

If (Type("__lBRBlqEstNor") == "L").and.(__lBRBlqEstNor).and.(nDias > 0)
	cQuery1 := "SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SB8")+" B8 "
	cQuery1 += "WHERE B8.D_E_L_E_T_ = '' AND B8_FILIAL = '"+xFilial("SB8")+"' AND B8_SALDO > 0 "
	cQuery1 += "AND B8_PRODUTO = '"+cProdu+"' AND B8_LOCAL = '"+cLocal+"' AND B8_LOTECTL = '"+cNLote+"' "
	cQuery1 += "AND B8_DTVALID >= '"+dtos(dDatabase+nDias)+"' "
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MSB8") <> 0)	
		dbSelectArea("MSB8")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MSB8"
	If !MSB8->(Eof()).and.(MSB8->M_CONTA == 0)
		Help("",1,"BRASCOLA",,OemToAnsi("Lote "+Alltrim(cNLote)+" do produto "+Alltrim(cProdu)+" irá vencer em menos de "+Alltrim(Str(nDias))+" e não será utilizado."),1,0) 
		lRetu1 := .F.
	Endif
	If (Select("MSB8") <> 0)
		dbSelectArea("MSB8")
		dbCloseArea()
	Endif
	RestArea(aSeg1)
Endif
																
Return lRetu1