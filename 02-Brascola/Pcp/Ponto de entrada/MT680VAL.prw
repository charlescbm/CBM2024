#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT680VAL ºAutor  ³ Marcelo da Cunha   º Data ³  09/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se OP foi liberada no CQ     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT680VAL()
*********************
LOCAL lRetu := .T., lAchei := .F., aSeg := GetArea()
LOCAL lValQual := SuperGetMV("BR_000048",.F.,.F.)

//Valido apontamento de producao
////////////////////////////////
If (INCLUI).and.(lValQual).and.!Empty(M->H6_op).and.((M->H6_qtdprod+M->H6_qtdperd) > 0)
	QPK->(dbSetOrder(1)) //OP
	QPK->(dbSeek(xFilial("QPK")+M->H6_op,.T.))
	While !QPK->(Eof()).and.(xFilial("QPK") == QPK->QPK_filial).and.(QPK->QPK_op == M->H6_op)
		If !Empty(QPK->QPK_laudo).and.(QPK->QPK_laudo$"ABC")
			lAchei := .T.
			Exit
		Endif
		QPK->(dbSkip())
	Enddo
	If (!lAchei)
		Help("",1,"BRASCOLA",,OemToAnsi("A OP "+Alltrim(M->H6_op)+" nao foi inspeciodada! Favor verificar com o CQ."),1,0) 
		lRetu := .F.
	Endif
	RestArea(aSeg)
Endif

Return (lRetu)