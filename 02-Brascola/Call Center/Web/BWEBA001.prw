#include "APWEBEX.CH"
#include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BWEBA001 ºAutor  ³Microsiga           º Data ³  25/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao Web para registro da Pesquisa de Satisfacao         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BWEBA001()
**********************
LOCAL cHtml := "", cFAph
                           
RpcSetType(3)
RPCSetEnv("01","01","","","TMK","",{"SUC"})

WEB EXTENDED INIT cHtml 

If (HttpGet->cCodigo != Nil).and.(HttpGet->cChave != Nil)
	HttpSession->__c001Codigo := HttpGet->cCodigo
	HttpSession->__c001Chave  := HttpGet->cChave
	HttpSession->__c001Mensg  := ""
	If !Empty(HttpSession->__c001Codigo).and.!Empty(HttpSession->__c001Chave)
		SUC->(dbSetOrder(1))
		If SUC->(dbSeek(xFilial("SUC")+HttpSession->__c001Codigo)).and.(Alltrim(SUC->UC_chvpesq) == Alltrim(HttpSession->__c001Chave))
			If !Empty(SUC->UC_pesaten).or.!Empty(SUC->UC_pestemp).or.!Empty(SUC->UC_pesqual)
				HttpSession->__c001Mensg  := "Pesquisa já foi respondida!"
		  	Endif
			cFAph := "BWEBA001"
			cHtml := ExecInPage(cFAph)
		Endif
	Endif
Endif
             
WEB EXTENDED END

Return cHtml 

User Function BWA001ATU()     
***********************
LOCAL cHtml := "", cFAph

RpcSetType(3)
RPCSetEnv("01","01","","","TMK","",{"SUC"})

WEB EXTENDED INIT cHtml 

If (HttpPost->cCodigo != Nil).and.(HttpPost->cChave != Nil).and.(HttpSession->__c001Codigo != Nil).and.(HttpSession->__c001Chave != Nil)
	If (HttpPost->cCodigo == HttpSession->__c001Codigo).and.(HttpPost->cChave == HttpSession->__c001Chave)
		SUC->(dbSetOrder(1))
		If SUC->(dbSeek(xFilial("SUC")+HttpSession->__c001Codigo)).and.(Alltrim(SUC->UC_chvpesq) == Alltrim(HttpSession->__c001Chave))
			If Empty(SUC->UC_pesaten).and.Empty(SUC->UC_pestemp).and.Empty(SUC->UC_pesqual)
				Reclock("SUC",.F.)
				If (HttpPost->cOpcao1 == "SIM")
					SUC->UC_pesaten := "S"
				Elseif (HttpPost->cOpcao1 == "NAO")
					SUC->UC_pesaten := "N"
				Endif
				If (HttpPost->cOpcao2 == "SIM")
					SUC->UC_pestemp := "S"
				Elseif (HttpPost->cOpcao2 == "NAO")
					SUC->UC_pestemp := "N"
				Endif
				If (HttpPost->cOpcao3 == "REGULAR")
					SUC->UC_pesqual := "R"
				Elseif (HttpPost->cOpcao3 == "BOM")
					SUC->UC_pesqual := "B"
				Elseif (HttpPost->cOpcao3 == "OTIMO")
					SUC->UC_pesqual := "O"
				Endif
				MsUnlock("SUC")
				HttpSession->__c001Mensg := "Resposta confirmada com sucesso!"
			Else
				HttpSession->__c001Mensg := "Pesquisa já foi respondida!"
			Endif
			HttpSession->__c001Codigo := Space(6)
			HttpSession->__c001Chave  := Space(32)
			cFAph := "BWEBA001"
			cHtml := ExecInPage(cFAph)
		Endif
	Endif
Endif

WEB EXTENDED END

Return cHtml 