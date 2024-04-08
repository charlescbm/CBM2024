#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BFATPE004  ºAutor  ³Microsiga           º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao na digitacao de item de pedido de venda.         º±±
±±º          ³ Verifica se o produto necessita certificado da Policia     º±±
±±º          ³ Federal,e se o cliente tem o certificado e  se nao está    º±±
±±º          ³ vencido.                                                   º±±
±±º          ³ Esta validacao está no ponto de entrada MT440LIB (Liberacao º±±
±±º          ³ de pedido de venda, opcao "Automatica" -MATA440).          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT440LIB()
Local cCertPF
Local dValPF       := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_VALPF")
Local cCertificado := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI	,"A1_CERPF")
Local nqtLib := paramixb
Local cCertPF   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_CERTPF")
Local cDescB1   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_DESC")
Local cCliente  := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI	,"A1_NOME")

If CCertPF = "S"     //produto necessita certificado
	If Empty(cCertificado)    //cliente não tem certificado
		MsgBox("O produto necessita certificado da Policia Federal. "+ Chr(13) + Chr(10) +;
		       "O cliente não tem certificado cadastrado. "+ Chr(13) + Chr(10) +;
		       "O item não será liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
		       "Pedido : " + SC5->C5_NUM + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Produto: " + SC6->C6_PRODUTO + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Cliente: " + SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
		       ,"Atencao","ALERT")

		nqtLib := 0    //não permite liberacao
	ElseIf dValPF < Date() .or. Empty(dValPF)    //se certificado está vencido ou se não tem data de validade
		MsgBox("A validade do Certificado da Policia Federal está vencida (" + DTOC(dValPF) + ")." + Chr(13) + Chr(10) +;
		       "O item não será liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
   		       "Pedido : " + SC5->C5_NUM + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Produto: " + SC6->C6_PRODUTO + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Cliente: " + SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
		       ,"Atencao","ALERT")
		nqtLib := 0    //não permite liberacao
	EndIf
EndIf
Return(nqtLib)