#include "rwmake.ch"
#include "topconn.ch"

#define FRETE	4	// Valor total do frete

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � TKEVALI  �Autor  � Marcelo da Cunha   � Data �  25/10/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para validar Call Center                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TKEVALI()
********************
LOCAL lRetu := .T., nTotMerc := 0, nTotFre := 0
LOCAL cEstNor  := Alltrim(GetMV("BR_000012")) //Estados Nordeste
LOCAL nValMinF := GetMV("BR_000013") //Valor Minimo para Frete
LOCAL nValMinP := GetMV("BR_000022") //Valor Minimo para Pedido 
LOCAL	nPValor  := GDFieldPos("UB_VLRITEM",aHeader) //Valor do Item
                                 
//Valores de Frete na confirmacao do Pedido
///////////////////////////////////////////
If (Type("aValores") == "A").and.(nPValor > 0)
	aValores[FRETE] := 0
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+M->UA_cliente+M->UA_loja))
 		nTotMerc := 0
	 	For nx := 1 to Len(aCols)
 			If !(aCols[nx,Len(aCols[nx])])
	 			nTotMerc += aCols[nx,nPValor]
 			Endif
	 	Next nx
		If (SA1->A1_est $ cEstNor).and.(nTotMerc > 0).and.(nTotMerc >= nValMinP).and.(nTotMerc <= nValMinF).and.(SA1->A1_percfre > 0)
			nTotFre := (nTotMerc*(SA1->A1_percfre/100))                 
			aValores[FRETE] := nTotFre
		Endif
	Endif
	Tk273RodImposto("NF_FRETE",aValores[FRETE])
	If (Type("aObj") == "A")
		aObj[FRETE]:Refresh()
	Endif
Endif

Return lRetu