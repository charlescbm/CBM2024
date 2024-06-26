#include "rwmake.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BFATPE003 �Autor  �Microsiga           � Data �  01/03/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Validacao na digitacao de item de pedido de venda.         ���
���          � Verifica se o produto necessita certificado da Policia     ���
���          � Federal,e se o cliente tem o certificado e  se nao est�    ���
���          � vencido.                                                   ���
���          � Esta validacao est� no ponto de entrada MT440GR (Liberacao ���
���          � de pedido de venda, opcao "Libera" -MATA440).              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT440GR()
Local cCertPF
Local nPProduto    := aScan( aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPQtdLib     := aScan( aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB" })
Local dValPF       := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VALPF")
Local cCertificado := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI	,"A1_CERPF")
Local cCliente     := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI	,"A1_NOME")
Local nOpc := paramixb[1]
Local nx

For nX := 1 to Len(aCols)
	cCertPF      := Posicione("SB1",1,xFilial("SB1")+aCols[nx,nPProduto],"B1_CERTPF")
	cDescB1       := Posicione("SB1",1,xFilial("SB1")+aCols[nx,nPProduto],"B1_DESC")
	
	If CCertPF = "S"    //produto necessita certificado
		If Empty(cCertificado) //cliente n�o tem certificado
			//avisar que o item xxx n�o foi liberado
			MsgBox("O produto necessita certificado da Policia Federal. "+ Chr(13) + Chr(10) +;
			       "O cliente n�o tem certificado cadastrado. "+ Chr(13) + Chr(10) +;
			       "O item n�o ser� liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
			       "Produto: " + aCols[nx,nPProduto] + "-"  + cDescB1 + Chr(13) + Chr(10) +;
			       "Cliente: " + M->C5_CLIENTE + "/" + M->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
			       ,"Atencao","ALERT")

			aCols[nx,nPQtdLib ] := 0 //n�o permite liberacao
		ElseIf dValPF < Date() .or. Empty(dValPF) //se certificado est� vencido ou se n�o tem data de validade
			MsgBox("A validade do Certificado da Policia Federal est� vencida (" + DTOC(dValPF) + ")." + Chr(13) + Chr(10) +;
			       "O item n�o ser� liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
			       "Produto: " + aCols[nx,nPProduto] + "-"  + cDescB1 + Chr(13) + Chr(10) +;
			       "Cliente: " + M->C5_CLIENTE + "/" + M->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
			       ,"Atencao","ALERT")
			aCols[nx,nPQtdLib ] := 0  //n�o permite liberacao
		EndIf
	EndIf
Next
Return(.t.)
