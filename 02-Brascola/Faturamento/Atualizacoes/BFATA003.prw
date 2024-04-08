#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BFATA003  ºAutor  ³Microsiga           º Data ³  02/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao na digitacao de item de pedido de venda.         º±±
±±º          ³ Verifica se o produto necessita certificado da Policia     º±±
±±º          ³ Federal,e se o cliente tem o certificado e  se nao está    º±±
±±º          ³ vencido.                                                   º±±
±±º          ³ Esta validacao está no X3_VLDUSER dos campos:              º±±
±±º          ³ C6_PRODUTO, C6_QTDVEN, C6_QTDLIB                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BFATA003()
Local nPProduto    := aScan( aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPQtdLib     := aScan( aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB" })
Local cCertPF
Local dValPF       := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VALPF")
Local cCertificado := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI	,"A1_CERPF")
Local lRet := .t.

If Alltrim(ReadVar()) == "M->C6_PRODUTO"
	cCertPF      := Posicione("SB1",1,xFilial("SB1")+M->C6_PRODUTO,"B1_CERTPF")
Else
	cCertPF      := Posicione("SB1",1,xFilial("SB1")+acols[n,nPProduto],"B1_CERTPF")
EndIf

If CCertPF = "S"  //produto necessita certificado
	If Empty(cCertificado) //cliente não tem certificado
		MsgBox("Atualize o Certificado da Policia Federal.","Atencao","ALERT")
		If Alltrim(ReadVar()) == "M->C6_QTDVEN"
			If mv_par01 == 1
				aCols[n,nPQtdLib ] := 0  //não permite liberacao
			Endif
		EndIf
		lRet := .f.
	ElseIf dValPF < Date() .or. Empty(dValPF)  //se certificado está vencido ou se não tem data de validade
		MsgBox("Validade do Certificado da " + Chr(13) + Chr(10) + "Policia Federal está vencida (" + DTOC(dValPF) + ").","Atencao","ALERT")
		If Alltrim(ReadVar()) == "M->C6_QTDVEN"
			If mv_par01 == 1
				aCols[n,nPQtdLib ] := 0  //não permite liberacao
			Endif
		EndIf
		lRet := .f.
	ElseIf dValPF - Date() <= 5   //se validade estive prestes a vencer, emite aviso.
		MsgBox("Validade do Certificado da " + Chr(13) + Chr(10) + "Policia Federal vencerá em " + DTOC(dValPF) + ".","Atencao","ALERT")
		lRet := .t.
	EndIf
EndIf
Return(lRet)