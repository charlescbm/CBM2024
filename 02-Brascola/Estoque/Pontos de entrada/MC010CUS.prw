#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MC010CUS  ºAutor  ³Evaldo V. Batista   º Data ³  21/08/2005 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Informa um Novo Custo para o produto                       º±±
±±º          ³ relativo a rotina de Planilha de Custo                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MC010CUS()     
*********************
LOCAL cCodPro 	 := ParamIxb[1]
LOCAL nOldCusto := ParamIxb[2]
LOCAL nRetCusto := nOldCusto

PUBLIC lDescPCof, nDescPCof

If (cArqMemo == "STD-DIGI")
	If SB1->(dbseek(xFilial("SB1")+cCodPro))
		nRetCusto := SB1->B1_custm
	Endif
Elseif (nQualCusto == 1) //Custo Standard
	SZ2->(dbSetOrder(1)) //Produto+Data
	If SZ2->(dbSeek(xFilial("SZ2")+cCodPro+dtos(dDatabase)))
		nRetCusto := SZ2->Z2_custd
	Else
		SZ2->(dbSeek(xFilial("SZ2")+cCodPro+dtos(dDatabase),.T.))
		SZ2->(dbSkip(-1))
		If (SZ2->Z2_produto == cCodPro)
			nRetCusto := SZ2->Z2_custd
		Endif
	Endif
Endif

Return (nRetCusto)