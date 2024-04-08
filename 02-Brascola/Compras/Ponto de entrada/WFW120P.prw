#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ WFW120P  ºAutor  ³ Marcelo da Cunha   º Data ³  13/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para liberar/bloquear o pedido de compra  º±±
±±º          ³ de acordo com alcada de compras CC                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFW120P()
********************
LOCAL cPed := Substr(paramixb,3,6), cQuery := ""
LOCAL lAlcCom := SuperGetMv("BR_ALCOMP",.F.,.F.)
If (lAlcCom)
	u_BCA002AvalPC(cPed)
	u_BCA002ExcEmp(cPed)
Endif

//Verifico se titulo existe e excluir
/////////////////////////////////////
If (!INCLUI)
	cQuery := "SELECT E2.R_E_C_N_O_ MRECSE2 FROM "+RetSqlName("SE2")+" E2 "
	cQuery += "WHERE E2.D_E_L_E_T_ = '' AND E2_FILIAL = '"+xFilial("SE2")+"' "
	cQuery += "AND E2_NUM = '"+SC7->C7_num+"' AND E2_PREFIXO = 'COM' AND E2_TIPO = 'PR' "
	cQuery += "AND E2_FORNECE = '"+SC7->C7_fornece+"' AND E2_LOJA = '"+SC7->C7_loja+"' AND E2_SALDO > 0 "
	cQuery := ChangeQuery(cQuery)
	If (Select("MSE2") <> 0)
		dbSelectArea("MSE2")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MSE2"
	SE2->(dbSetOrder(1))
	dbSelectArea("MSE2")
	While !MSE2->(Eof())
		SE2->(dbGoto(MSE2->MRECSE2))
		aAuto := {{"E2_PREFIXO" ,SE2->E2_prefixo   ,Nil},;  //Prefixo
			  	   	{"E2_NUM"     ,SE2->E2_num     ,Nil},;  //Numero
			  	    	{"E2_PARCELA" ,SE2->E2_parcela ,Nil},;  //Parcela
	  	   		   {"E2_TIPO"    ,SE2->E2_TIPO    ,Nil},;  //Tipo
	  	   		   {"E2_FORNECE" ,SE2->E2_fornece ,Nil},;  //Fornecedor
	  	   		   {"E2_LOJA"    ,SE2->E2_loja    ,Nil},;  //Loja
		   	  	 	{"E2_EMISSAO" ,SE2->E2_emissao ,Nil},;  //Data Base
			  	 		{"E2_VALOR"   ,SE2->E2_valor   ,Nil}}   //Valor
		lMsErroAuto := .F.
		MSExecAuto({|x,y,z|FINA050(x,y,z)},aAuto,Nil,5)
		If (lMsErroAuto)
			MostraErro()
		Endif
		MSE2->(dbSkip())
	Enddo	
	If (Select("MSE2") <> 0)
		dbSelectArea("MSE2")
		dbCloseArea()
	Endif
Endif

Return