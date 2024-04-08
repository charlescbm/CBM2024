#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ M410AGRV ºAutor  ³ Marcelo da Cunha   º Data ³  25/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gravar bloqueio de alcada no pedido  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function M410AGRV()
*********************
LOCAL nOpcx := paramixb[1] //[1]Inclusao/[2]Alteracao/[3]Exclusao
LOCAL nDescAtu := 0, nDescPro := 0, nDescMax := 0, nPosL := 0, nPosB := 0, nPosF := 0
LOCAL lNovaAlc := SuperGetMv("BR_ALNOVA",.F.,.F.) //Parametro para ativar Alcada
LOCAL cFlagAlc := SuperGetMv("BR_ALFLAG",.F.,"") //Parametro para alterar flag para bloqueio
                   
//Verifico se rotina nova esta ativa
////////////////////////////////////
If (lNovaAlc).and.(nOpcx != 3).and.!(Alltrim(cUserName) $ SuperGetMv("BR_ALUSERM",.F.,""))
	dbSelectArea("SA3")
	SA3->(dbSetOrder(7)) //UserID
	If SA3->(dbSeek(xFilial("SA3")+__cUserID))
		nDescMax := 0
		If (SA3->A3_tipocad == "1") //Presidencia
			nDescMax := SuperGetMv("BR_ALDESCP",.F.,55)
		Elseif (SA3->A3_tipocad == "2") //Diretoria
			nDescMax := SuperGetMv("BR_ALDESCD",.F.,30)
		Elseif (SA3->A3_tipocad == "3") //Gerencial
			nDescMax := SuperGetMv("BR_ALDESCG",.F.,22)
		Elseif (SA3->A3_tipocad == "4") //Supervisao
			nDescMax := SuperGetMv("BR_ALDESCS",.F.,18)
		Elseif (SA3->A3_tipocad == "5") //Representante
			nDescMax := SuperGetMv("BR_ALDESCR",.F.,15)
		Endif
	Endif
	nPosL := GDFieldPos("C6_QTDLIB")
	nPosB := GDFieldPos("C6_X_BLDSC")
	nPosF := GDFieldPos("C6_FLAGLUC")
	If (nPosL > 0).and.(nPosB > 0)
		For nn := 1 to Len(aCols)
			If !GDDeleted(nn)
				nDescPro := 0
				SZ3->(dbSetOrder(1))                                                     
				If SZ3->(dbSeek(xFilial("SZ3")+M->C5_num+GDFieldGet("C6_ITEM",nn))).and.!Empty(SZ3->Z3_datapro)
					nDescPro := SZ3->Z3_descpro
				Endif
				nDescAtu := GDFieldGet("C6_DESCONT",nn)
				If ((nDescPro == 0).or.(nDescAtu > nDescPro)).and.((nDescAtu > nDescMax).or.(!Empty(cFlagAlc).and.(GDFieldGet("C6_FLAGLUC",nn) $ cFlagAlc)))
					aCols[nn,nPosL] := 0 //Qtde Liberada
					aCols[nn,nPosB] := "B" //Bloqueado
				Else
					aCols[nn,nPosB] := "L" //Liberado
				Endif
			Else
				SZ3->(dbSetOrder(1))
				If SZ3->(dbSeek(xFilial("SZ3")+M->C5_num+GDFieldGet("C6_ITEM",nn)))
					Reclock("SZ3",.F.)
					SZ3->(dbDelete())
					MsUnlock("SZ3")
				Endif
			Endif   
		Next nn
	Endif
Endif

Return