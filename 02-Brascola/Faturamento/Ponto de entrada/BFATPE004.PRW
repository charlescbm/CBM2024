#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BFATPE004  �Autor  �Microsiga           � Data �  01/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao na digitacao de item de pedido de venda.         ���
���          � Verifica se o produto necessita certificado da Policia     ���
���          � Federal,e se o cliente tem o certificado e  se nao est�    ���
���          � vencido.                                                   ���
���          � Esta validacao est� no ponto de entrada MT440LIB (Liberacao ���
���          � de pedido de venda, opcao "Automatica" -MATA440).          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	If Empty(cCertificado)    //cliente n�o tem certificado
		MsgBox("O produto necessita certificado da Policia Federal. "+ Chr(13) + Chr(10) +;
		       "O cliente n�o tem certificado cadastrado. "+ Chr(13) + Chr(10) +;
		       "O item n�o ser� liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
		       "Pedido : " + SC5->C5_NUM + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Produto: " + SC6->C6_PRODUTO + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Cliente: " + SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
		       ,"Atencao","ALERT")

		nqtLib := 0    //n�o permite liberacao
	ElseIf dValPF < Date() .or. Empty(dValPF)    //se certificado est� vencido ou se n�o tem data de validade
		MsgBox("A validade do Certificado da Policia Federal est� vencida (" + DTOC(dValPF) + ")." + Chr(13) + Chr(10) +;
		       "O item n�o ser� liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
   		       "Pedido : " + SC5->C5_NUM + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Produto: " + SC6->C6_PRODUTO + "-"  + cDescB1 + Chr(13) + Chr(10) +;
		       "Cliente: " + SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
		       ,"Atencao","ALERT")
		nqtLib := 0    //n�o permite liberacao
	EndIf
EndIf
Return(nqtLib)