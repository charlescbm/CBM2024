#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � MTA097   �Autor  � Marcelo da Cunha   � Data �  26/08/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para gerar titulo financeiro tipo PRA     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MTA097()
********************
LOCAL nx, nOpc, cQuery1, cNumTit, cObserv, lGera1, lRetu1 := .T.
LOCAL aTitulos := {}, aSegSC7 := SC7->(GetArea()), aAuto := {}

//Gerar titulo de previsao de pagamento (PRA)
/////////////////////////////////////////////
If (SCR->CR_tipo == "PC")
	SC7->(dbSetOrder(1))
	If SC7->(dbSeek(xFilial("SC7")+Alltrim(SCR->CR_num))).and.(SC7->C7_cond $ SuperGetMV("BR_000034",.F.,""))
		cQuery1 := "SELECT C7_DTPGTO,SUM(C7_TOTAL+C7_VALIPI) C7_TOTAL FROM "+RetSqlName("SC7")+" (NOLOCK) "
		cQuery1 += "WHERE D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SC7")+"' AND C7_NUM = '"+SC7->C7_num+"' AND C7_DTPGTO <> '' "
		cQuery1 += "GROUP BY C7_DTPGTO ORDER BY C7_DTPGTO "
		cQuery1 := ChangeQuery(cQuery1)
		If (Select("MSC7") <> 0) 
			dbSelectArea("MSC7")
			dbCloseArea()
		Endif
		TCQuery cQuery1 NEW ALIAS "MSC7"
		TCSetField("MSC7","C7_DTPGTO","D",8,0)
		dbSelectArea("MSC7")
		While !MSC7->(Eof())
			aVencs := Condicao(MSC7->C7_total,SC7->C7_cond,,dDatabase)
			If (Len(aVencs) >= 1)
				aadd(aTitulos,{MSC7->C7_dtpgto,aVencs[1,2]})
			Else
				aadd(aTitulos,{MSC7->C7_dtpgto,MSC7->C7_total})
			Endif
			MSC7->(dbSkip())
		Enddo
		If (Select("MSC7") <> 0) 
			dbSelectArea("MSC7")
			dbCloseArea()
		Endif
		SA2->(dbSetOrder(1)) ; SE2->(dbSetOrder(1))
		SA2->(dbSeek(xFilial("SA2")+SC7->C7_fornece+SC7->C7_loja,.T.))
		For nx := 1 to Len(aTitulos)
			cNumTit := Alltrim(SC7->C7_num)      
			cItemPed := Alltrim(SC7->C7_Item)  // charles
			cNumTit := cNumTit+Space(9-Len(cNumTit))
			cObserv := "BANCO:"+Alltrim(SA2->A2_BANCOPA)+" / AGENCIA:"+Alltrim(SA2->A2_AGPA)+" / CC:"+Alltrim(SA2->A2_CCPA)+" / CNPJ/RG:"+Alltrim(SA2->A2_CGCPA)
			nOpc := 3 ; lGera1 := .T.
			If SE2->(dbSeek(xFilial("SE2")+"COM"+cNumTit+Strzero(nx,2)+"PR "+SC7->C7_fornece+SC7->C7_loja))
	 			nOpc := 4
	 			If (SE2->E2_valor != SE2->E2_saldo)
		 			lGera1 := .F.
		 		Endif
			Endif
			If (lGera1)
				aAuto := {{"E2_PREFIXO" ,"COM"         ,Nil},;  //Prefixo
  				  	   	{"E2_NUM"     ,cNumTit         ,Nil},;  //Numero
				  	    	{"E2_PARCELA" ,Strzero(nx,2)   ,Nil},;  //Parcela
		  	   		   {"E2_TIPO"    ,"PR "           ,Nil},;  //Tipo
		  	   		   {"E2_NATUREZ" ,iif(!Empty(SA2->A2_naturez),SA2->A2_naturez,"22001"),Nil},;  //Natureza
		  	   		   {"E2_FORNECE" ,SC7->C7_fornece ,Nil},;  //Fornecedor
		  	   		   {"E2_LOJA"    ,SC7->C7_loja    ,Nil},;  //Loja
			   	  	 	{"E2_EMISSAO" ,dDatabase       ,Nil},;  //Data Base
		   		      {"E2_VENCTO"  ,aTitulos[nx,1]  ,Nil},;  //Data Pagamento
				  		 	{"E2_VENCREA" ,DataValida(aTitulos[nx,1]) ,Nil},;  //Data Pagamento
 			  	   	   {"E2_MOEDA"   ,SC7->C7_moeda    ,Nil},;  //Moeda
 			  	   	   {"E2_TXMOEDA" ,SC7->C7_txmoeda  ,Nil},;  //Taxa Moeda
 				  	 		{"E2_VALOR"   ,aTitulos[nx,2]  ,Nil},;  //Valor
 			   	  		{"E2_HIST"    ,cObserv         ,Nil},;   //Observacao
 			   	  		{"E2_OBSERV"  ,"PEDIDO: "+cNumTit+" ITEM:"+cItemPed 	,Nil}}   //Historico -----charles
				lMsErroAuto := .F.
				MSExecAuto({|x,y,z|FINA050(x,y,z)},aAuto,Nil,nOpc)
				If (lMsErroAuto)
					MostraErro()
				Endif
			Endif
		Next nx
		RestArea(aSegSC7)
	Endif
Endif

Return (lRetu1 := .T.)