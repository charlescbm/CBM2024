#INCLUDE "Protheus.ch"    
#Include "TopConn.ch"

#DEFINE NMAXPAGE 50

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SA1FILTRO�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SA1					                              ���
���          � 		Verifica se usu�rio do sistema � representante e 	  ���
���          �  	o cadastro de clientes de acordo com a celula a que   ���
���          �  	pertence											  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//DESENVOLVIDO POR INOVEN

User Function SA1FILTRO()
Local aArea 		:= GetArea()
Local aAreaSA3		:= SA3->(GetArea())
//Local cCondSA1		:= ""
//Local cFiltroSA1	:= ""
//Local lret			:= .T.
                      
dbSelectArea("SA3")    
dbSetOrder(7)  
lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

//If lVendUSU .and. SA3->A3_TPART == "R"
/*	
	dbSelectArea("Z02")    
	dbSetOrder(1)  

	If Z02->(dbSeek(xFilial("Z02") + SA3->A3_COD))
	
		While Z02->(!EOF()) .and. xFilial("Z02") == Z02->Z02_FILIAL .and. Z02->Z02_PART == SA3->A3_COD

			cCondSA1 += Z02->Z02_COD + "/"

			Z02->(dbSKIP())
			
		End

		If !Empty(cCondSA1)

			cFiltroSA1 :=  "SA1->A1_CELULA $'" + cCondSA1 + "'"

			SA1->(DBCLEARFILTER())
            SA1->(DbSetFilter({|| SA1->A1_CELULA $ cCondSA1 }, "SA1->A1_CELULA $ '"+ cCondSA1 +"'" ))

    	Endif

    Endif
*/
//Endif

RestArea(aAreaSA3)
RestArea(aArea)

Return (.T.) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SUSFILTRO�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SUS					                              ���
���          � 		Verifica se usu�rio do sistema � representante e 	  ���
���          �  	o cadastro de clientes de acordo com a celula a que   ���
���          �  	pertence											  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function SUSFILTRO()
Local aArea 		:= GetArea()
Local aAreaSA3		:= SA3->(GetArea())
//Local cCondSUS		:= ""
//Local cFiltroSUS	:= ""
//Local lret			:= .T.
                      
dbSelectArea("SA3")    
dbSetOrder(7)  
lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

/*If lVendUSU .and. SA3->A3_TPART == "R"
	
	dbSelectArea("Z02")    
	dbSetOrder(1)  

	If Z02->(dbSeek(xFilial("Z02") + SA3->A3_COD))
	
		While Z02->(!EOF()) .and. xFilial("Z02") == Z02->Z02_FILIAL .and. Z02->Z02_PART == SA3->A3_COD

			cCondSUS += Z02->Z02_COD + "/"

			Z02->(dbSKIP())
			
		End

		If !Empty(cCondSUS)

			cFiltroSUS :=  "SUS->US_CELULA $'" + cCondSUS + "'"

			SUS->(DBCLEARFILTER())
            SUS->(DbSetFilter({|| SUS->US_CELULA $ cCondSUS }, "SUS->US_CELULA $ '"+ cCondSUS +"'" ))

    	Endif

    Endif

Endif
*/
RestArea(aAreaSA3)
RestArea(aArea)

Return (.T.) 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410BRW�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SA1					                              ���
���          � 		Ponto de Entrada que Endereca a funcao Browse de 	  ���
���          �  	pedidos de vendas									  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//User Function MT410BRW()


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT410BRW�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SA1					                              ���
���          � 		Ponto de Entrada que Endereca a funcao Browse de 	  ���
���          �  	pedidos de vendas									  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function DNYSC5FILTRO()
Local aArea 		:= GetArea()
Local aAreaSA3		:= SA3->(GetArea())
Local cCond			:= ""                      

dbSelectArea("SA3")    
dbSetOrder(7)  
lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

If lVendUSU .and. SA3->A3_TIPO == "E"
	cCond := "SC5->C5_VEND1 == '"+SA3->A3_COD+"'"
	SC5->(DBCLEARFILTER())
	SC5->(DbSetFilter({|| &(cCond)} ,cCond))
Else	
	SC5->(DBCLEARFILTER())
Endif                                                     	

RestArea(aAreaSA3)
RestArea(aArea)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QRYFILTRO�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SA1					                              ���
���          � 		Verifica se usu�rio do sistema � representante e 	  ���
���          �  	o cadastro de clientes de acordo com a celula a que   ���
���          �  	pertence, selecionando os codigos dos clientes		  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function QRYFILTRO()

Local aArea 		:= GetArea()
Local aAreaSA3		:= SA3->(GetArea())
Local cCondSA1		:= ""
//Local cCondSA2		:= ""
//Local cFiltroSA1	:= ""
                      
dbSelectArea("SA3")    
dbSetOrder(7)  
lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

If lVendUSU
	
	cCondSA1 := SA3->A3_COD
/*
	dbSelectArea("Z02")    
	dbSetOrder(1)  

	If Z02->(dbSeek(xFilial("Z02") + SA3->A3_COD))
	
		While Z02->(!EOF()) .and. xFilial("Z02") == Z02->Z02_FILIAL .and. Z02->Z02_PART == SA3->A3_COD

			cCondSA1 += Z02->Z02_COD + "/"

			Z02->(dbSKIP())
			
		End
    Endif
*/
Else
	cCondSA1 := Space(TamSX3("A1_VEND") [1])   
Endif                                                     	

RestArea(aAreaSA3)
RestArea(aArea)

Return (cCondSA1) 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QRYSA1FILTRO�Autor  �Microsiga           � Data � 19/01/11 	  ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro SA1					                              ���
���          � 		Verifica se usu�rio do sistema � representante e 	  ���
���          �  	o cadastro de clientes de acordo com a celula a que   ���
���          �  	pertence, selecionando os codigos dos clientes		  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function QRYSA1FILTRO()
Local cFiltroSA1	:=  ""
                      
SA3->(dbSetOrder(7))
lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

If lVendUSU .and. SA3->A3_TIPO == "E"

	cFiltroSA1 :=  "SA1->A1_VEND == '"+ SA3->A3_COD +"'"
	SA1->(DbSetFilter({|| &(cFiltroSA1)} ,cFiltroSA1))

Else	
	SA1->(DBCLEARFILTER())
	cFiltroSA1 :=  ".T."
Endif                                                     	

Return (&cFiltroSA1)
