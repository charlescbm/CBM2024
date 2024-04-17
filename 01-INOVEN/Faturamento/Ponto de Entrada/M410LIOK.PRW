#INCLUDE "rwmake.ch"
/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! M410LIOK - Validação de linha de pedido					!
+-------------------+-----------------------------------------------------------+
!Descricao			! VALIDAÇÃO DE LINHA DO PEDIDO VENDA						! 
!					! Validação de linha no pedido de venda.					! 
!					! Busca informacoes nas tabelas SC5, SA3, SB1, DAI, SF4.	!	!
+-------------------+-----------------------------------------------------------+
!Autor             	! 															!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 07/07/2019								                !
+-------------------+-----------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function M410LIOK()
	Local lRet 		:= .T.
	//Local cTabela	:= M->C5_TABELA
	//Local cVend		:= M->C5_VEND1	//M->C5_REPRES
	//Local nPosProd 	:= ASCAN(aHeader,{|x| ALLTRIM(x[2])=="C6_PRODUTO"})
	Local nPosTES 	:= ASCAN(aHeader,{|x| ALLTRIM(x[2])=="C6_TES"})
	//Local nPosQtd 	:= ASCAN(aHeader,{|x| ALLTRIM(x[2])=="C6_QTDVEN"})
	//Local nPosVlr 	:= ASCAN(aHeader,{|x| ALLTRIM(x[2])=="C6_PRCVEN"})
	//Local nPosTab 	:= ASCAN(aHeader,{|x| ALLTRIM(x[2])=="C6_PRUNIT"})
	//Local nPosBlq 	:= ASCAN(aHeader,{|x| AllTrim(x[2])=="C6_BLOQUEI"})
	//Local nPQtdVen	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
	//Local nPLoteCtl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOTECTL"})
	//Local nPNumLote := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NUMLOTE"})
	//Local nPosItem 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
	//Local nPFreteUn := aScan(aHeader,{|x| AllTrim(x[2])=="C6_FRETEUN"})
	Local nPLocal 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
	//Local nPProdFil := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODFIL"})
	//Local nPCtaTrf 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ZCTATRF"})
	//Local nPCCTrf 	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_CCTRF"})
	//Local nPosSit   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})
	Local nPosCfop  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
	//Local nPosNori  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
	//Local nPosSori  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
	//Local nPosIori  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
	Local nPosOper  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_OPER"})
	
	//Local nDesc		:= 0
	//Local nDescAc	:= 0
	//Local nQtdeAc	:= 0
	//Local nItem		:= N
	//Local _cMsg		:= ""
	//Local _cTit		:= ""
	
	Local aArea		:= GetArea()

	
	If ALLTRIM(aCols[N,nPLocal]) $ '02' // ARMAZEM DE PERDAS
		If !ALLTRIM(aCols[N,nPosOper]) $ '96'// .or. !ALLTRIM(aCols[N,nPosTES]) $ '802'
		   	msgalert("Para local 02 somente tipo de op. 96", "M410LIOK")
		   	RestArea(aArea)
		    Return .F.
		Endif
	
	ElseIf ALLTRIM(aCols[N,nPLocal]) $ '03' // ARMAZEM VENDA - TRANFERIDO
		If !ALLTRIM(aCols[N,nPosTES]) $ '506|507|508|509|510|512|513|514|515|516|517|519|521|522|523|524|525|526|527|529|533|535|536|537|540|541|542|543|544|545|546|547|548|549|556|561|582|583|584|585|586|587|588|589|611|612|613|614|615|616|620|621|622|623|624|625|626|628|629|630|631|632|633|634|635|636|637|711|712|713|714|715|716|720|721|722|723|724|725|726|728|729|730|731|732|733|734|735|736|737|738|740|743|762|766|769|768|770|771|772|773|774|775|778|782|787|791|792|793|794|796|802|814|817|819|820|821'
			msgalert("Local 03 somente para venda S/ Benef. ou amostras/Bonificação!", "M410LIOK")
			RestArea(aArea)
			Return .F.
		Endif

	ElseIf ALLTRIM(aCols[N,nPLocal]) $ '06' // ARMAZEM VENDA - TRANFERIDO
		If !ALLTRIM(aCols[N,nPosTES]) $ '819|821|822|795|797'
			msgalert("Local 06 somente para Transferencia entre filiais!", "M410LIOK")
			RestArea(aArea)
			Return .F.
		Endif
	
	ElseIf ALLTRIM(aCols[N,nPLocal]) $ '05' // ARMAZEM Controle devolução Terceiros		
		//If !ALLTRIM(aCols[N,nPosOper]) $ '53' .or. !ALLTRIM(aCols[N,nPosTES]) $ '547'
		If !ALLTRIM(aCols[N,nPosCfop]) $ '6114|5114'
		   	msgalert("Para local 05 somente tipo de op. 53/58 ou TES 754/764/774/780/789/", "M410LIOK")
		   	RestArea(aArea)
		    Return .F.
		Endif
	
	ElseIf ALLTRIM(aCols[N,nPosCfop]) $ '6114|5114' .and. !ALLTRIM(aCols[N,nPLocal]) $ '05' // CFOP VENDA CONSIGNADO SOMENTE ARMAZEM 05	
		msgalert("Para Operação com CFOP 6114 e 5114 somente armazem 05", "M410LIOK")
		RestArea(aArea)
		Return .F.
	
	//ElseIf ALLTRIM(aCols[N,nPLocal]) $ '01|04' // ARMAZEM VENDA	
	ElseIf ALLTRIM(aCols[N,nPLocal]) $ '01' // RETIRADO ARMAZEM 04 DA LIBERAÇÃO PARA VENDA (chamado 2164)
		If ALLTRIM(aCols[N,nPosTES]) $ '547'
		   	msgalert("Para essa Operação venda de Cons. não é permitido esse Armazem!", "M410LIOK")
		   	RestArea(aArea)
		    Return .F.
		Endif 
	ElseIf ALLTRIM(aCols[N,nPLocal]) $ '04'  // ARMAZEM 04 SOMENTE PARA DEVOLUÇÃO )
		If !ALLTRIM(aCols[N,nPosCfop]) $ '6202|5202|6949|5949'
		   	msgalert("Para Armazem 04 somente Op. tipo devolução!", "M410LIOK")
		   	RestArea(aArea)
		    Return .F.
		Endif
	Else 
	   	msgalert("Local informado não reconhecido", "M410LIOK")
	   	RestArea(aArea)
	   	Return .F.
	Endif

	RestArea(aArea)
	
Return lRet
