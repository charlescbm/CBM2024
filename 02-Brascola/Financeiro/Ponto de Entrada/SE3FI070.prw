#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SE3FI070 ºAutor  ³ Marcelo da Cunha   º Data ³  14/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para avisar sobre baixas a pagar sem      º±±
±±º          ³ geracao de comissao.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SE3FI070()
**********************
LOCAL cTitulo, cTexto, cEmail, cQuery, aSeg := GetArea()

If !Empty(SE1->E1_VEND1)
	SA3->(dbSetOrder(1))
	If SA3->(dbSeek(xFilial("SA3")+SE1->E1_VEND1))
		SE3->(dbSetOrder(3)) //E3_FILIAL,E3_VEND,E3_CODCLI,E3_LOJA,E3_PREFIXO,E3_NUM,E3_PARCELA,E3_TIPO
		If (SA3->A3_tipo == "E").and.!SE3->(dbSeek(xFilial("SE3")+SE1->E1_vend1+SE1->E1_cliente+SE1->E1_loja+SE1->E1_prefixo+SE1->E1_num+SE1->E1_parcela+SE1->E1_tipo))
			cTitulo := "[SE3FI070] Baixa sem Comissão: "+SE1->E1_prefixo+SE1->E1_num+SE1->E1_parcela+SE1->E1_tipo
			cTexto  := "O Título "+SE1->E1_prefixo+SE1->E1_num+SE1->E1_parcela+SE1->E1_tipo+", do representante "
			cTexto  += SE1->E1_vend1+", foi baixado, porém não gerou comissão no SE3. Favor verificar."
			cEmail  := "charlesm@brascola.com.br;marcelo@goldenview.com.br;fmaia@brascola.com.br"
			u_GDVWFAviso("BXACOM","100001",cTitulo,cTexto,cEmail)
		Endif
	Endif
	RestArea(aSeg)
Endif

Return