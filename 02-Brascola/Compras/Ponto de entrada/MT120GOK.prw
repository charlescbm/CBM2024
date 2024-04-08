#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT120GOK ºAutor  ³ Marcelo da Cunha   º Data ³  26/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para gerar titulo financeiro tipo PRA     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT120GOK()
**********************
LOCAL nx, nOpc, aTitulos := {}, aAuto := {}, cNumPed := paramixb[1], aSegSC7 := SC7->(GetArea())
LOCAL cQuery1, lInclui := paramixb[2], lAltera := paramixb[3], lExclui := paramixb[4], cNumTit, lAchei1

//Gerar titulo de previsao de pagamento (PRA)
/////////////////////////////////////////////
nOpc := 0
If (lInclui)
	nOpc := 3
Elseif (lAltera)
	nOpc := 4
Elseif (lExclui)
	nOpc := 5
Endif
If (nOpc != 0).and.(SC7->C7_cond == "500")
	cQuery1 := "SELECT C7_DTPGTO,SUM(C7_TOTAL) C7_TOTAL "
	cQuery1 += "FROM "+RetSqlName("SC7")+" (NOLOCK) "
	If (nOpc != 5) //Exclusao
		cQuery1 += "WHERE D_E_L_E_T_ = '' AND C7_FILIAL = '"+xFilial("SC7")+"' "
	Else
		cQuery1 += "WHERE D_E_L_E_T_ = '*' AND C7_FILIAL = '"+xFilial("SC7")+"' "
	Endif
	cQuery1 += "AND C7_NUM = '"+cNumPed+"' AND C7_DTPGTO <> '' "
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
		aadd(aTitulos,{MSC7->C7_dtpgto,MSC7->C7_total})
		MSC7->(dbSkip())
	Enddo
	If (Select("MSC7") <> 0) 
		dbSelectArea("MSC7")
		dbCloseArea()
	Endif
	SA2->(dbSetOrder(1)) ; SE2->(dbSetOrder(1))
	SA2->(dbSeek(xFilial("SA2")+SC7->C7_fornece+SC7->C7_loja,.T.))
	For nx := 1 to Len(aTitulos)
		cNumTit := Alltrim(cNumPed)
		cNumTit := cNumTit+Space(9-Len(cNumTit))
		lAchei1 := .T.
		If (nOpc != 3)
			lAchei1 := SE2->(dbSeek(xFilial("SE2")+"COM"+cNumTit+Strzero(nx,2)+"PRA"+SC7->C7_fornece+SC7->C7_loja))
		Endif
		If (lAchei1)
			aAuto := {{"E2_PREFIXO" ,"COM"           ,Nil},;  //Prefixo
  			  	   	 {"E2_NUM"     ,cNumTit         ,Nil},;  //Numero
			  			 {"E2_PARCELA" ,Strzero(nx,2)   ,Nil},;  //Parcela
	  	   		    {"E2_TIPO"    ,"PRA"           ,Nil},;  //Tipo
	  	   		    {"E2_NATUREZ" ,iif(!Empty(SA2->A2_naturez),SA2->A2_naturez,"22001"),Nil},;  //Natureza
	  	   		    {"E2_FORNECE" ,SC7->C7_fornece ,Nil},;  //Fornecedor
	  	   		    {"E2_LOJA"    ,SC7->C7_loja    ,Nil},;  //Loja
		   	  	 	 {"E2_EMISSAO" ,dDatabase       ,Nil},;  //Data Base
		   		    {"E2_VENCTO"  ,aTitulos[nx,1]  ,Nil},;  //Data Pagamento
		  		 	    {"E2_VENCREA" ,DataValida(aTitulos[nx,1]) ,Nil},;  //Data Pagamento
 		  	 		  	 {"E2_VALOR"   ,aTitulos[nx,2]  ,Nil},;  //Valor
 		   	  		 {"E2_HIST"    ,"PEDIDO COMPRA: "+cNumTit  ,Nil}}   //Historico
			lMsErroAuto := .F.
			MSExecAuto({|x,y,z|FINA050(x,y,z)},aAuto,Nil,nOpc)
			If (lMsErroAuto)
				MostraErro()
			Endif
		Endif
	Next nx
	RestArea(aSegSC7)
Endif

Return