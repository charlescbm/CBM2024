#include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA200POS  ºAutor  ³Microsiga           º Data ³  30/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada no processamento de retorno de cnab de contas±
±±º          ³a receber para posicionar o titulo corretamente.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Brascola                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FA200Pos()

Local aArea		:= GetArea()
Local aArSe1	:= SE1->(GetArea())
Local aOrdSe1	:= {}
Local cLinha	:= PARAMIXB[1][16]
Local cConPart	:= Substr(cLinha,38,23)		// Numero de controle do participantes
Local lAchou	:= .F.
Local cIdCnab	:= space(10)
Local nTamNN  	:= TamSx3("E1_NUMBCO")[1]
Local cNewTit	:= space(11)
Local nTamTit	:= TamSx3("E1_PREFIXO")[1]+TamSx3("E1_NUM")[1]+TamSx3("E1_PARCELA")[1]+TamSx3("E1_TIPO")[1]

//Local cFilOri  := cFilant     // Armazena a Filial Corrente

//cFilant        := Substr(cNumemp,3,2)

//MSGSTOP("Passei Aqui")

//	Variavel cNumTit
// Sera obtido atraves das posicoes de 038 a 062 - controle do participante
//	Ate o dia  29/08/05 foi enviado ao banco a chave: SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
// Do dia 30/08/05 em diante, foi enviado o E1_IDCNAB+E1_FILIAL
                                            
//se for rejeitado e somente para o banco SOFISA
If cOcorr == "03 " .and. mv_par06 =='637'  
	cRej := Substr(paramixb[1,16],378,2)
	If cRej $ "CG/BG"
		cOcorr	:= "02" //entrada confirmada
	EndIf
EndIf



SE1->(dbSetOrder(16)) // Filial+IdCnab
if SE1->(MsSeek(xFilial("SE1")+Substr(cNumTit,1,10)))
	lAchou	:= .T.
Else                  
	lAchou	:= .F.
EndIf


// Primeira busca: identificar se na posicao 038 a 062 tem o IdCnab e tentar localizar o titulo.
If Len(Alltrim(cNumTit)) == 12		// e1_idcnab + e1_filial
	DbSelectArea("SE1")
	DbSetOrder(16)  		// indice por E1_IDCNAB
	If MsSeek(xFilial("SE1")+Substr(cNumTit,1,10)) // Alterar pelo digitos 11 e 12 do IDCNAB do arquivo a filial
		lAchou	:= .T.
		cNumTit	:= SE1->E1_IDCNAB
	Else
		lAchou	:= .F.
	EndIf
EndIf

// Segunda tentativa: pode ser que a posicao 038 a 062 tenha o numero completo do titulo
If !lAchou
	DbSelectArea("SE1")
	DbSetOrder(1)
	If MsSeek(xfilial("SE1")+Padr(cNumTit,nTamTit))
		lAchou	:= .t.
		If Empty(SE1->E1_IDCNAB)
			cNumTit	:= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) 		// o tipo sera composto pela especie      
			cEspecie	:= SE1->E1_TIPO
		Else
			cNumTit	:= SE1->E1_IDCNAB
		EndIf
	Else
		lAchou	:= .f.
	EndIf
EndIf

// terceira tentativa: tentar pela numeracao constante das posicoes 117 a 129, que era a chave do Magnus.
If !lAchou
	If Substr(cLinha,117,2)	== "DM"		// trata-se de titulo do Magnus
		//          Pref Numero                 Parcela              Tipo
		cNewTit	:= "1  "+Substr(cLinha, 119,6) + Substr(cLinha,125,2)+"DM "
		// localiza o titulo para obter o IdCnab
		DbSelectArea("SE1")
		DbSetOrder(1)
		If MsSeek(xfilial("SE1")+cNewTit)
			lAchou	:= .t.
			If Empty(SE1->E1_IDCNAB)                                                                                                                    
				cNumTit	:= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) 		// o tipo sera composto pela especie        
				cEspecie	:= SE1->E1_TIPO
			Else
				cNumTit	:= SE1->E1_IDCNAB
			EndIf
		Else
			lAchou	:= .f.
		EndIf
	EndIf
EndIf

// Ultima tentativa: localizar pelo numero bancario, banco, agencia e conta
// nao foi implementado, pois identifiquei numero bancario duplicado para o mesmo banco.
/*
If !lAchou
	If !Empty(cNsNum)
		DbSelectArea("SE1")
		DbOrderNickName("NUMBCO")
		If MsSeek(xFilial("SE1")+Padr(cNsNum,nTamNN)+cBanco+cAgencia+cConta)
			lAchou	:= .t.
			If Empty(SE1->E1_IDCNAB)
				cNumTit	:= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA) 		// o tipo sera composto pela especie      
				cEspecie	:= SE1->E1_TIPO
			Else
				cNumTit	:= SE1->E1_IDCNAB
			EndIf
		Else
			lAchou	:= .f.
		EndIf
	EndIf
EndIf
*/

If !lAchou
	If Substr(cLinha,117,2)	== "DM"		// trata-se de titulo do Magnus
		//          Pref Numero                 Parcela              Tipo
		cNumTit	:= "1  "+SubStr(cLinha, 119,6) + Substr(cLinha,125,2)
	Else
		cNumTit	:= Substr(cLinha,117,10)   // chave antiga
	EndIf
EndIf	

//cFilAnt  := cFilori

RestArea(aArSe1)
RestArea(aArea)

Return()
