#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BFATPE003 ºAutor  ³Microsiga           º Data ³  01/03/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validacao na digitacao de item de pedido de venda.         º±±
±±º          ³ Verifica se o produto necessita certificado da Policia     º±±
±±º          ³ Federal,e se o cliente tem o certificado e  se nao está    º±±
±±º          ³ vencido.                                                   º±±
±±º          ³ Esta validacao está no ponto de entrada MT440GR (Liberacao º±±
±±º          ³ de pedido de venda, opcao "Libera" -MATA440).              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
		If Empty(cCertificado) //cliente não tem certificado
			//avisar que o item xxx não foi liberado
			MsgBox("O produto necessita certificado da Policia Federal. "+ Chr(13) + Chr(10) +;
			       "O cliente não tem certificado cadastrado. "+ Chr(13) + Chr(10) +;
			       "O item não será liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
			       "Produto: " + aCols[nx,nPProduto] + "-"  + cDescB1 + Chr(13) + Chr(10) +;
			       "Cliente: " + M->C5_CLIENTE + "/" + M->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
			       ,"Atencao","ALERT")

			aCols[nx,nPQtdLib ] := 0 //não permite liberacao
		ElseIf dValPF < Date() .or. Empty(dValPF) //se certificado está vencido ou se não tem data de validade
			MsgBox("A validade do Certificado da Policia Federal está vencida (" + DTOC(dValPF) + ")." + Chr(13) + Chr(10) +;
			       "O item não será liberado." + Chr(13) + Chr(10) + Chr(13) + Chr(10) +;
			       "Produto: " + aCols[nx,nPProduto] + "-"  + cDescB1 + Chr(13) + Chr(10) +;
			       "Cliente: " + M->C5_CLIENTE + "/" + M->C5_LOJACLI + " - " + cCliente + Chr(13) + Chr(10) ;
			       ,"Atencao","ALERT")
			aCols[nx,nPQtdLib ] := 0  //não permite liberacao
		EndIf
	EndIf
Next
Return(.t.)
