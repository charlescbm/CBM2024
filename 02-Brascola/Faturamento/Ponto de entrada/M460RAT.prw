#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "Font.ch"
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � M460RAT  � Ponto de entrada na gera��o da nota fiscal para ajustar o    ���
���             �          � valor do frete pois o rateio padr�o considera todos os       ���
���             �          � pedidos que est�o no SC9 (sejam liberados ou bloqueados)     ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � ??.08.05 � Levantamento                                                 ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 13.09.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o da altera��o                           ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function M460RAT()    


Local aAreaAtu	:= GetArea()
Local aRatFrt	:= PARAMIXB				// 1o. N�mero do Pedido
												// 2o. Item do Pedido
												// 3o. Sequencia de Libera��o
												// 4o. Valor do Frete
												// 5o. Valor do Seguro
												// 6o. Valor das Despesas
												// 7o. Valor do Frete Aut�nomo
												// 8o. Valor do Desconto
												// 9o. Array com os pre�os dos itens
												// 10o.Percentual de Desconto
Local nLoop		:= 0
Local nVlrFrt	:= 0
Local cQry		:= ""   


Local aArray := {}
Local _nPos  := 0
Local aFrtXArray  := {}




For nLoop := 1 To Len(aRatFrt)

	//������������������������������������������������������������Ŀ
	//�Este bloco verifica se existe valores de FRETE e SEGURO nos �
	//�pedidos, para chegar num percentual e ratea-lo no pedido    �
	//�que tiver sendo faturado.                                   �
	//��������������������������������������������������������������
	aFRTXArray  := PercXFrete(aRatFrt[nLoop,1])

	//cQry	:= " SELECT SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB)*(SA1.A1_PERCFRE/100)) AS FRETITE"
	cQry	:= " SELECT SUM(SC9.C9_PRCVEN*SC9.C9_QTDLIB) TOTAL, "

	cQry  += " SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB) * "+if(aFRTXArray[3]>0,"0",If(aFRTXArray[1]>0,Str(aFRTXArray[1]),"(SA1.A1_PERCFRE/100)"	))+")	AS FRETITE, "
	cQry  += " SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB))* "+If(aFRTXArray[2]>0,Str(aFRTXArray[2]),"0"                     	)+" 	AS SEGUITE  "
	
	//cQry  += " SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB) * "+If(aFRTXArray[1]>0,Str(aFRTXArray[1]),"(SA1.A1_PERCFRE/100)"	)+")	AS FRETITE, "
	//cQry  += " SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB))* "+If(aFRTXArray[2]>0,Str(aFRTXArray[2]),"0"                     	)+" 	AS SEGUITE  "

	
	
	
	//cQry  += " SUM((SC9.C9_PRCVEN*SC9.C9_QTDLIB) * (SA1.A1_PERCFRE/100))	AS FRETITE "

	cQry	+= " FROM "+RetSqlName("SC9")+" SC9,"+RetSqlName("SC5")+" SC5,"
	cQry	+= RetSqlName("SA1")+" SA1,"+RetSqlName("SC6")+" SC6,"+RetSqlName("SF4")+" SF4"
	cQry	+= " WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"'"
	cQry	+= " AND SC9.C9_PEDIDO = '"+aRatFrt[nLoop,1]+"'"
	cQry	+= " AND SC9.C9_ITEM = '"+aRatFrt[nLoop,2]+"'"
	cQry	+= " AND SC9.C9_SEQUEN = '"+aRatFrt[nLoop,3]+"'"
	cQry	+= " AND SC9.D_E_L_E_T_ <> '*'"
	cQry	+= " AND SC5.C5_FILIAL = SC9.C9_FILIAL"
	cQry	+= " AND SC5.C5_NUM = SC9.C9_PEDIDO"
	cQry	+= " AND SC5.C5_TRANSP <> '099999'"							// h� outros fontes tratando desta forma - rever no futuro
	cQry	+= " AND SC5.D_E_L_E_T_ <> '*'"
	cQry	+= " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
	cQry	+= " AND SA1.A1_COD = SC9.C9_CLIENTE"
	cQry	+= " AND SA1.A1_LOJA = SC9.C9_LOJA"
	cQry	+= " AND SA1.D_E_L_E_T_ <> '*'"
	cQry	+= " AND SA1.A1_PERCFRE > 0  "
	cQry	+= " AND SC6.C6_FILIAL = SC9.C9_FILIAL"
	cQry	+= " AND SC6.C6_NUM = SC9.C9_PEDIDO"
	cQry	+= " AND SC6.C6_ITEM = SC9.C9_ITEM"
	cQry	+= " AND SC6.D_E_L_E_T_ <> '*'"
	cQry	+= " AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
	cQry	+= " AND SF4.F4_CODIGO = SC6.C6_TES"
   //	cQry	+= " AND SF4.F4_CALCFRE IN ('1','S')"
	cQry	+= " AND SF4.D_E_L_E_T_ <> '*'"

	If Select("M460RATTRB") > 0
		dbSelectArea("460RATTRB")
		dbCloseArea()
	EndIf

 //	MemoWrite("\QUERYSYS\M460RAT.SQL",cQry)
	TCQUERY cQry NEW ALIAS "M460RATTRB"
	TCSETFIELD("M460RATTRB", "FRETITE", "N", 14,02)

	dbSelectArea("M460RATTRB")
	nVlrFrt	:= M460RATTRB->FRETITE
	
	// Atualiza o valor do frete
	aRatFrt[nLoop,4]	:= round(nVlrFrt,2)   

	// Atualiza o valor do seguro
	aRatFrt[nLoop,5]	:= M460RATTRB->SEGUITE	

	//������������������������������������������������������������Ŀ
	//�Este bloco faz um novo rateio para os pedidos de baixo valor�
	//�A bonifica��o do frete vale apenas para pedidos na Matriz   �
	//��������������������������������������������������������������
 //	If xFilial("SC5")=='01'
 //		nVlrFrt := CalcFrt(M460RATTRB->TOTAL,aRatFrt[nLoop,1])
//		aRatFrt[nLoop,4]:= If(nVlrFrt>0,nVlrFrt,aRatFrt[nLoop,4])
//	EndIf
	
	M460RATTRB->(dbCloseArea())
	
Next aRatFrt

RestArea(aAreaAtu)

Return(aRatFrt)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �M460RAT   �Autor  �Microsiga           � Data �  11/30/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao verifica se o pedido atende alguns requisitos  ���
���          � de estado/valor, para bonificar a cobranca do frete        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function CalcFrT(_nTotal,_cPedido)
                                         
Local cQuery := ""
Local aArray := {}
Local cDados := AllTrim(GetMV("BR_000013"))  
Local nRet	 := 0

//�������������������������������������������������������������������������������Ŀ
//�Estas linhas transformam o conteudo do parametro BR_000013 em conteudo de Array� 
//���������������������������������������������������������������������������������     
cDados := If(Subs(cDados,len(cDados)-1,1)="/",cDados,cDados+"/")
While Len(cDados)>1 
	nPos     := AT('/',cDados)
	cDados1  := Subs(cDados,1,nPos-1)
	cDados11 := Subs(cDados1,1,2)
	cDados1  := Subs(cDados1,4,Len(cDados1))
	cDados12 := Val(Subs(cDados1,1,AT("-",cDados1)-1))
	cDados1  := Subs(cDados1,AT("-",cDados1)+1,Len(cDados1))
	aAdd(aArray,{cDados11,cDados12,cDados1})
	cDados  := Subs(cDados,nPos+1,Len(cDados))
	
	//esta trava impede que seja feita uma manutencao mal feita no parametro
	//e ferre com a rotina, gerando um array gigantesco e derrubando o server
	If Len(aArray) > 100
		Alert("Conteudo problem�tico no parametro BR_000013")
		Return(nRet) 
	EndIf
EndDo

//�������������������������������������������������������������Ŀ
//�Busca informacoes do pedido para o qual esta sendo gerado SF2�
//���������������������������������������������������������������
cQuery := " SELECT A1_EST EST, SUM(TOTPED) TOTPED, SUM(TOTFAT) TOTFAT "
cQuery += " FROM ( "
cQuery += " SELECT 	A1_EST, 0 TOTPED, ISNULL(SUM(SC9.C9_PRCVEN*SC9.C9_QTDLIB),0) TOTFAT "
cQuery += " FROM "+RetSQLName("SC9")+" SC9,"+RetSQLName("SC5")+" SC5,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SF4")+" SF4 "
cQuery += " WHERE "
cQuery += "     SC9.C9_FILIAL 	= '"+xFilial("SC9")+"'"
cQuery += " AND SC9.C9_PEDIDO 	= '"+_cPedido+"'"
cQuery += " AND C9_BLEST 			= '  ' "
cQuery += " AND C9_BLCRED 			= '  ' "
cQuery += " AND C9_NFISCAL			= '         ' "
cQuery += " AND SC9.D_E_L_E_T_ 	<> '*' "
cQuery += " AND SC5.C5_FILIAL 	= SC9.C9_FILIAL "
cQuery += " AND SC5.C5_NUM 		= SC9.C9_PEDIDO "
cQuery += " AND SC5.C5_TRANSP 	<> '099999' "
cQuery += " AND SC5.D_E_L_E_T_ 	<> '*' "
cQuery += " AND SA1.A1_FILIAL 	= '  ' "
cQuery += " AND SA1.A1_COD 		= SC9.C9_CLIENTE "
cQuery += " AND SA1.A1_LOJA 		= SC9.C9_LOJA "
cQuery += " AND SA1.D_E_L_E_T_ 	<> '*' "
cQuery += " AND SC6.C6_FILIAL 	= SC9.C9_FILIAL "
cQuery += " AND SC6.C6_NUM 		= SC9.C9_PEDIDO "
cQuery += " AND SC6.C6_ITEM 		= SC9.C9_ITEM "
cQuery += " AND SC6.D_E_L_E_T_ 	<> '*' "
cQuery += " AND SF4.F4_FILIAL 	= '  ' "
cQuery += " AND SF4.F4_CODIGO 	= SC6.C6_TES "
cQuery += " AND SF4.F4_CALCFRE 	IN ('1','S') "
cQuery += " AND SF4.D_E_L_E_T_ 	<> '*' "
cQuery += " GROUP BY A1_EST "
cQuery += " UNION ALL "
cQuery += " SELECT 	A1_EST, "
cQuery += " 	ISNULL(SUM(C6_QTDVEN * C6_PRCVEN),0) AS TOTPED, "
cQuery += " 	0 TOTFAT "
cQuery += " FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SF4")+" SF4,"+RetSQLName("SA1")+" SA1 "
cQuery += " WHERE C5_FILIAL 		= '"+xFilial("SC9")+"'"
cQuery += " AND C5_NUM 				= '"+_cPedido+"'"
cQuery += " AND C5_TRANSP 			<> '099999'  "
cQuery += " AND SC5.D_E_L_E_T_ 	= ' '  "
cQuery += " AND C6_FILIAL 			= C5_FILIAL  "
cQuery += " AND C6_NUM 				= C5_NUM  "
cQuery += " AND SC6.D_E_L_E_T_ 	= ' '  "
cQuery += " AND F4_CODIGO 			= C6_TES  "
cQuery += " AND F4_CALCFRE 		IN ('1','S')   "
cQuery += " AND SF4.D_E_L_E_T_ 	= ' ' "
cQuery += " AND A1_COD				= C5_CLIENTE "
cQuery += " AND A1_LOJA				= C5_LOJACLI "
cQuery += " AND SA1.D_E_L_E_T_ 	= ' ' "
cQuery += " GROUP BY A1_EST "
cQuery += " ) AGRUPA1 "
cQuery += " GROUP BY A1_EST "

If Select("M460RAT1")>0
	M460RAT1->(dbCloseArea())
EndIf
MemoWrite("\QUERYSYS\M460RAT1.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "M460RAT1"
TCSETFIELD("M460RAT1","TOTPED","N",14,02)
TCSETFIELD("M460RAT1","TOTFAT","N",14,02)


//�������������������������������������������������������������Ŀ
//�Verifica se o estado do cliente possui o beneficio           �
//���������������������������������������������������������������
_nPos  := aScan(aArray,{|x| AllTrim(x[1])==M460RAT1->EST})
If _nPos == 0
	Return(nRet)
EndIf 


//�������������������������������������������������������������Ŀ
//�Verifica se o total do pedido recebe a bonificacao           �
//���������������������������������������������������������������
If M460RAT1->TOTPED > aArray[_nPos,2] 
	Return(nRet)   
EndIf

nRet := 	_nTotal; 			//Total do item
			/;						//Dividido
			M460RAT1->TOTPED;	//pelo total do pedido
			*;		  				//multiplicado 
			Val(aArray[_nPos,3])	//pelo valor do frete parametrizado 
			

M460RAT1->(dbCloseArea())			
		
Return(nRet)
                                                                                             

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PercXFrete�Autor  �Microsiga           � Data �  11/30/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao retorna o percentual do valor cobrado a titulo ���
���          � de frete sobre o total do pedido                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function PercXFrete(cPedido)
Local nTotal   := 0
Local nPercFre := 0
Local nPercSeg := 0
Local cQuery 	:= ""   
Local aRet     := {}

aAdd(aRet,"0")
aAdd(aRet,"0")
aAdd(aRet,"0")
/*
cQuery := " SELECT 	CASE WHEN C5_FRETE  > 0 THEN C5_FRETE /  TOTAL  ELSE 0 END FRETE,   "
cQuery += " 			CASE WHEN C5_SEGURO > 0 THEN C5_SEGURO / TOTAL  ELSE 0 END SEGURO "
cQuery += " FROM (  " 
cQuery += " 	SELECT C5_FRETE, C5_SEGURO, SUM(C6_QTDVEN * C6_PRCVEN) TOTAL " 
cQuery += " 	FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SF4")+" SF4
cQuery += " 	WHERE      C5_FILIAL='"+xFilial("SC5")+"'"
cQuery += " 	AND C5_NUM='"+cPedido+"'"
cQuery += " 	AND SC5.D_E_L_E_T_=''   "
cQuery += " 	AND C6_FILIAL=C5_FILIAL   "
cQuery += " 	AND C6_NUM = C5_NUM   "
cQuery += " 	AND SC6.D_E_L_E_T_='' "
cQuery += " 	AND F4_CODIGO = C6_TES "
cQuery += " 	AND F4_CALCFRE IN ('1','S') "
cQuery += " 	AND SF4.D_E_L_E_T_='' "
cQuery += " 	GROUP BY C5_FRETE, C5_SEGURO   "
cQuery += " ) AGRUPA1 "
*/

//     RODOLFO 12/02
cQuery := " SELECT 	CASE WHEN C5_FRETE  > 0 THEN C5_FRETE /  TOTAL  ELSE 0 END FRETE,A1_EST, TOTAL,C5_FILIAL,A1_GRPVEN,C5_EMISSAO,A1_MUN,C5_VEND1,  "
cQuery += " 			CASE WHEN C5_SEGURO > 0 THEN C5_SEGURO / TOTAL  ELSE 0 END SEGURO ,C5_TPFRETE,A1_PERCFRE  "
cQuery += " FROM (  " 
cQuery += " 	SELECT C5_FRETE, C5_SEGURO, SUM(C6_QTDVEN * C6_PRCVEN) TOTAL,A1_EST,C5_FILIAL,A1_GRPVEN,A1_MUN,C5_VEND1,C5_EMISSAO ,C5_TPFRETE,A1_PERCFRE " 
cQuery += " 	FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SF4")+" SF4,"+RetSQLName("SA1")+" SA1 "
cQuery += " 	WHERE      C5_FILIAL='"+xFilial("SC5")+"'"
cQuery += " 	AND C5_NUM='"+cPedido+"'"
cQuery += " 	AND SC5.D_E_L_E_T_=''   "
cQuery += " 	AND C6_FILIAL=C5_FILIAL   "
cQuery += " 	AND C6_NUM = C5_NUM   "
cQuery += " 	AND C5_CLIENTE = A1_COD   "
cQuery += " 	AND A1_PERCFRE  > 0  "
cQuery += " 	AND SC6.D_E_L_E_T_='' "
cQuery += " 	AND F4_CODIGO = C6_TES "
cQuery += " 	AND SF4.D_E_L_E_T_='' "
cQuery += " 	GROUP BY C5_FRETE, C5_SEGURO ,A1_EST,C5_FILIAL,A1_GRPVEN,A1_MUN,C5_VEND1,C5_EMISSAO,C5_TPFRETE,A1_PERCFRE  "
cQuery += " ) AGRUPA1 "


//MemoWrite("\QUERYSYS\TESTE.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TRBX"


//A1_PERCFRE/100
//_VFRE:=GETMV("BR_000061") 

_VCP:=GETMV("BR_000013")

    //(CE/RN/BA/PE/SE/PB/AL/MA/PI)
IF TRBX->A1_EST $  getmv("BR_000012")  .AND. (TRBX->TOTAL >= _VCP)// .AND. TRBX->TOTAL<=1000) //.AND. TRBX->C5_FILIAL == '04' .AND. TRBX->A1_GRPVEN <> '000012' .AND. UPPER(SUBSTR(TRBX->A1_MUN,1,5)) <> 'JOINV' .AND. TRBX->C5_EMISSAO > '20090301' .AND. TRBX->C5_TPFRETE <> 'F'
   //aRet[1] := _VFRE/TRBX->TOTAL 
   //aRet[2] := TRBX->SEGURO
   aRet[1] := 0
   aRet[2] := 0
   aRet[3] := 1
ELSEif TRBX->A1_EST $  getmv("BR_000012")  .AND. (TRBX->TOTAL < _VCP)//TRBX->C5_VEND1 $  getmv("BR_000065")  .AND.  (TRBX->TOTAL >= 2000) .and. !TRBX->A1_EST $ 'AC-AM-AP-RO-RR'    //('002002*000386*000596*000493*000601*000641') 
   aRet[1] := (TRBX->A1_PERCFRE)/100
   aRet[2] := 0
   aRet[3] := 0
else
   aRet[1] := TRBX->FRETE
   aRet[2] := TRBX->SEGURO
   aRet[3] := 0
ENDIF
TRBX->(dbCloseArea())

Return(aRet)