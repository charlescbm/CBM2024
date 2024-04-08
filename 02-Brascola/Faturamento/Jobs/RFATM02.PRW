#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATM02  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 16/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Job para Liberacao de Estoque                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATM02(lAuto)
*************************
Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro   := OemToAnsi("Liberacao de Estoque")
Local nProcessa   := 3
Local lAuto       := If(lAuto == NIL,{.F.},lAuto)
Local lJob        := .T.
Local cQuery

RPCSetType(3)
RpcSetEnv("01","01","","","FAT","",{"SA1","SB2","SB8","SC5","SC6","SC9"})

ConOut("----------------------------------------")
ConOut(" Inicio de Liberacao de Pedidos "+Time())
ConOut("----------------------------------------")

U_RFATM02A() //Job Liberacao de Estoque
//U_RFATM03B() //Job para Eliminar residuos e enviar e-mail com aviso
//U_RFATM02B() //Job Estorno Liberacao Clientes Devedores

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³ RFATM02A º Autor ³ Marcos Eduardo Rocha º Data ³  16/06/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.    ³ Processa liberacao                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATM02A()
*********************
Local nOpca    := 0
Local aSays    := {}
Local aButtons := {}
Local cPerg    := U_CriaPerg("LIBAT2")
Local cAlias   := "SC9"
Local cMvAvalEst

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza arquivo de liberados para geracao na nota            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Pedido de          ?                                 ³
//³ mv_par02 Pedido ate         ?                                 ³
//³ mv_par03 Cliente de         ?                                 ³
//³ mv_par04 Cliente ate        ?                                 ³
//³ mv_par05 Dta Liberacao de   ?                                 ³
//³ mv_par06 Dta Liberacao ate  ?                                 ³
//³ mv_par07 Quanto ao Estoque  ? Estoque/WMS  WMS                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
                      
mv_par01 := Space(6)
mv_par02 := "ZZZZZZ"
mv_par03 := Space(8)
mv_par04 := "ZZZZZZZZ"
mv_par05 := ctod("01/01/13") //dDataBase - 5
mv_par06 := (dDataBase)
mv_par07 := 1

If dDataBase==DataValida(dDataBase)
	ConOut("> U_RFATM02A: Inicio de Liberacao de Pedidos "+Time())
	PutMV("MV_AVALEST",1)
	lMSErroAuto := .F. ; lMSHelpAuto := .T. ; lEnd := .F. ; lEmp := .F.
	Processa({|lEnd| Ma450Processa(cAlias,.F.,.T.,@lEnd,@lEmp,MV_PAR07==2)},,,.T.)
	PutMV("MV_AVALEST",3) 
 	
	cEmail    := "charles.medeiros@brascola.com.br;vviana@brascola.com.br"
	cAssunto  := "Liberacao de Estoque em Joinville realizado as "+Time()
	cTexto    := "Liberacao de Estoque em Joinville ( filial 01 ) realizado as "+Time()	

	/*	
		If U_SendMail(cEmail,cAssunto,cTexto,"",.T.)
			ConOut("--------------------------------------------------")
			ConOut("  Enviado e-mail - Liberacao de Estoque ")
			ConOut("--------------------------------------------------")
		Else
			ConOut("-----------------------------------------------------")
			ConOut("  Problema no envio de e-mail - Liberacao de Estoque ")
			ConOut("-----------------------------------------------------")
		EndIf
	*/  
	
	U_RFATM03B() //Job para Eliminar residuos e enviar e-mail com aviso
	U_RFATM02B() //Job Estorno Liberacao Clientes Devedores

	ConOut("> U_RFATM02A: Final de Liberacao de Pedidos "+Time())

Endif
  
Return
                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATM02B ºAutor  ³ Marcelo da Cunha   º Data ³  03/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job Estorno Liberacao Clientes Devedores                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATM02B()
*********************
PRIVATE cQueryn := "", aResumo := {}, nPos1, lCredOk 
                  
//Se nao for data valida, nao processa
//////////////////////////////////////                    
If (dDataBase != DataValida(dDataBase))
	Return
Endif
                     
//Monto Query para enviar ao banco de dados
///////////////////////////////////////////
cQueryn := 	" SELECT C9.R_E_C_N_O_ RECSC9,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_CLIENTE,C9_LOJA,C9_PRODUTO "+;
				" FROM SC9010 C9 WHERE C9.D_E_L_E_T_ <> '*' AND C9.C9_BLEST = '' AND C9.C9_BLCRED = '' AND C9.C9_FILIAL = '01' "+;
				" GROUP BY C9.R_E_C_N_O_,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_CLIENTE,C9_LOJA,C9_PRODUTO "+;
				" ORDER BY C9.C9_PEDIDO, C9.C9_ITEM "
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())
Endif
TCQuery cQueryn NEW ALIAS "MAR"

SC5->(dbSetOrder(1))
SC6->(dbSetOrder(1))
SC9->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())
  
  	//Verifico se cliente possui titulos em atraso
  	//////////////////////////////////////////////
	lCredOk := RM02ValCred(MAR->C9_cliente,MAR->C9_loja)

	//Estorno liberacao para devolver saldo para o estoque
	//////////////////////////////////////////////////////
	If (!lCredOk)
	 	SC9->(dbGoto(MAR->RECSC9))
	 	aadd(aResumo,Array(5))
		nPos1 := Len(aResumo)
		aResumo[nPos1,1] := MAR->C9_pedido+"/"+MAR->C9_item
		aResumo[nPos1,2] := Substr(Posicione("SA1",1,xFilial("SA1")+MAR->C9_cliente+MAR->C9_loja,"A1_NOME"),1,20)
		aResumo[nPos1,3] := Alltrim(SC9->C9_produto)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+SC9->C9_produto,"B1_DESC"))
		aResumo[nPos1,4] := SC9->C9_qtdlib
		aResumo[nPos1,5] := (SC9->C9_qtdlib*SC9->C9_prcven)
	 	Begin Transaction
			dbSelectArea("SC9")
		 	SC9->(a460Estorna()) //Estorno Liberacao
		End Transaction  
	Endif
	
	MAR->(dbSkip())
Enddo
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif

//Enviar aviso para setor financeiro com resumo
///////////////////////////////////////////////
If (Len(aResumo) > 0)
	WFAvResCre(@aResumo)
Endif

Return

Static Function RM02ValCred(xCliente,xLoja)
**************************************
PRIVATE lRetu := .T., cQuerym := ""

//Monto Query para enviar ao banco de dados
///////////////////////////////////////////
cQuerym := "SELECT COUNT(*) M_CONTA "
cQuerym += "FROM "+RetSqlName("SE1")+" WHERE D_E_L_E_T_='' AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQuerym += "AND E1_CLIENTE = '"+xCliente+"' AND E1_LOJA = '"+xLoja+"' AND E1_TIPO='NF' AND E1_VEND1<>''  "
cQuerym += "AND E1_VENCREA<'"+dtos(dDatabase)+"' AND E1_SALDO>0 AND E1_EMISSAO >= '20120101' "
cQuerym := ChangeQuery(cQuerym)
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif
TCQuery cQuerym NEW ALIAS "MSE1"
If !MSE1->(Eof()).and.(MSE1->M_conta > 0)
	lRetu := .F.
Endif
If (Select("MSE1") <> 0)
	dbSelectArea("MSE1")
	dbCloseArea()
Endif

Return lRetu

Static Function WFAvResCre(xResumo)
*******************************
LOCAL cCodProc 	:= "Resumo Pedidos Estornados por Pendencia Financeira", nPos1 := 0
LOCAL cDescProc	:= "Resumo Pedidos Estornados por Pendencia Financeira"
LOCAL cHTMLModelo	:= "\workflow\wfavrescre.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Resumo Pedidos Estornados por Pendencia Financeira | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPos1 := 1 to Len(xResumo)
	AAdd( oProcess:oHtml:ValByName("Item.ped") , xResumo[nPos1,1] )
	AAdd( oProcess:oHtml:ValByName("Item.cli") , xResumo[nPos1,2] )
	AAdd( oProcess:oHtml:ValByName("Item.pro") , xResumo[nPos1,3] )
	AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(xResumo[nPos1,4],PesqPict("SC6","C6_QTDVEN")) )
	AAdd( oProcess:oHtml:ValByName("Item.val") , Transform(xResumo[nPos1,5],PesqPict("SC6","C6_VALOR")) )
Next nPos1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
cEmail1 := Alltrim(GetMV("BR_000099"))
cEmail1 := u_BXFormatEmail(cEmail1)
oProcess:cTo := cEmail1
If Empty(oProcess:cTo)
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATM03B ºAutor  ³ Marcelo da Cunha   º Data ³  03/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job para Eliminar residuos e enviar e-mail com aviso       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RFATM03B()
***********************
PRIVATE cQueryn := "", aResumo := {}, aInfo := {0,0}
PRIVATE nValMin := GetMV("BR_VALMIN") //Valor Minimo
                  
//Se nao for data valida, nao processa
//////////////////////////////////////                    
If (dDataBase != DataValida(dDataBase))
	Return
Endif
                     
//Monto Query para enviar ao banco de dados
///////////////////////////////////////////
cQueryn := 	" SELECT C9.R_E_C_N_O_ RECSC9,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO,C5_TIPLIB "+;
				" FROM SC9010 C9, SC6010 C6, SC5010 C5 WHERE C9.D_E_L_E_T_ <> '*' "+;
				" AND C6.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' "+;
				" AND C9.C9_BLCRED = '' AND C9.C9_FILIAL = '01' "+; 
				" AND C9.C9_FILIAL = C6.C6_FILIAL AND C5.C5_FILIAL = C6.C6_FILIAL "+;
				" AND C9.C9_PEDIDO = C6.C6_NUM AND C5.C5_NUM  = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM "+;
				" AND C9.C9_CLIENTE = C6.C6_CLI AND C9.C9_LOJA = C6.C6_LOJA AND C9_PRODUTO = C6.C6_PRODUTO "+;   
				" AND C5_CONDPAG NOT IN ('001','000','060') AND C6_TES NOT IN ('572','573','755','756') "+;  
				" AND ( SELECT SUM(C92.C9_QTDLIB*C92.C9_PRCVEN) "+;  
				"			FROM SC9010 C92 WHERE C92.D_E_L_E_T_ <> '*' "+;   
				"			AND C92.C9_BLCRED = '' AND C92.C9_FILIAL = '01' AND C92.C9_NFISCAL = '' "+; 
				"			AND C92.C9_PEDIDO = C9.C9_PEDIDO ) < "+Alltrim(Str(nValMin))+" "+;           
				" GROUP BY C9.R_E_C_N_O_,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO,C5_TIPLIB "+; 
				" ORDER BY C9.C9_PEDIDO, C9.C9_ITEM "  
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif
TCQuery cQueryn NEW ALIAS "MAR"

SC5->(dbSetOrder(1))
SC6->(dbSetOrder(1))
SC9->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())

	//Se liberacao por Pedido, verifico se todos foram liberados
	////////////////////////////////////////////////////////////
	If (MAR->C5_tiplib == "2").and.!BVerLibPed(MAR->C9_pedido) //Por Pedido
		MAR->(dbSkip())
		Loop
	Endif
                                     
	//Estorno liberacao para devolver saldo para o estoque
	//////////////////////////////////////////////////////
 	SC9->(dbGoto(MAR->RECSC9))
 	aInfo[1] := SC9->C9_qtdlib
 	aInfo[2] := (SC9->C9_qtdlib*SC9->C9_prcven)
 	Begin Transaction
		dbSelectArea("SC9")
	 	SC9->(a460Estorna()) //Estorno Liberacao
	End Transaction  
	
	//Eliminar pedido/item por residuo
	//////////////////////////////////
	SC5->(dbSeek(xFilial("SC5")+MAR->C9_pedido,.T.))
	If SC6->(dbSeek(xFilial("SC6")+MAR->C9_pedido+MAR->C9_item))
		If Empty(SC5->C5_pedexp).and.	Empty(SC6->C6_reserva).and.!(SC6->C6_blq$"R #S ")
			MaResDoFat(,.T.,.T.)
			WFAvResRep(@aInfo,@aResumo,nValMin) //Enviar aviso para representante sobre pedido eliminado
		Endif
	Endif
	                                                        
	MAR->(dbSkip())
Enddo
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif

//Enviar aviso para setor de vendas com resumo
//////////////////////////////////////////////
If (Len(aResumo) > 0)
	WFAvResRes(@aResumo,nValMin)
Endif

Return

Static Function BVerLibPed(xPedido)
*******************************
LOCAL lRetu1 := .T., cQuery1
cQuery1 := "SELECT COUNT(*) M_CONTA FROM SC9010 SC9 WHERE SC9.D_E_L_E_T_ = '' AND SC9.C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery1 += "AND SC9.C9_PEDIDO = '"+xPedido+"' AND ( SC9.C9_BLEST NOT IN ('','10') OR SC9.C9_BLCRED NOT IN ('','10') ) "
If (Select("MSC9") <> 0)
	dbSelectArea("MSC9")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSC9"
dbSelectArea("MSC9")
If !MSC9->(Eof()).and.(MSC9->M_conta > 0)
	lRetu1 := .F.
Endif
If (Select("MSC9") <> 0)
	dbSelectArea("MSC9")
	dbCloseArea()
Endif
Return lRetu1

Static Function WFAvResRep(xInfo,xResumo,xValMin)
*******************************************
LOCAL cCodProc 	:= "Pedido Eliminado por Residuo", nPos1 := 0, cEmail1 := ""
LOCAL cDescProc	:= "Item "+MAR->C9_item+" do Pedido "+MAR->C9_pedido+" foi Eliminado por Residuo"
LOCAL cHTMLModelo	:= "\workflow\wfavresrep.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Item "+MAR->C9_item+" do Pedido "+MAR->C9_pedido+" foi Eliminado por Residuo | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Motivo","Item eliminado por resíduo por não atingir o valor mínimo para faturamento de R$"+Transform(xValMin,"@E 999,999,999.99"))
cEmail1 := ""
SA3->(dbSetOrder(1))
If SA3->(dbSeek(xFilial("SA3")+SC5->C5_vend1))
	cEmail1 := Alltrim(SA3->A3_email)
	oProcess:oHtml:ValByName("Vend",Alltrim(SA3->A3_cod)+"-"+Alltrim(SA3->A3_nome))
Else
	oProcess:oHtml:ValByName("Vend","&nbsp;")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(xResumo,Array(5))
nPos1 := Len(xResumo)
xResumo[nPos1,1] := MAR->C9_pedido+"/"+MAR->C9_item
xResumo[nPos1,2] := Substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,"A1_NOME"),1,20)
xResumo[nPos1,3] := Alltrim(SC6->C6_produto)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_produto,"B1_DESC"))
xResumo[nPos1,4] := xInfo[1]
xResumo[nPos1,5] := xInfo[2]
AAdd( oProcess:oHtml:ValByName("Item.ped") , xResumo[nPos1,1] )
AAdd( oProcess:oHtml:ValByName("Item.cli") , xResumo[nPos1,2] )
AAdd( oProcess:oHtml:ValByName("Item.pro") , xResumo[nPos1,3] )
AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(xResumo[nPos1,4],PesqPict("SC6","C6_QTDVEN")) )
AAdd( oProcess:oHtml:ValByName("Item.val") , Transform(xResumo[nPos1,5],PesqPict("SC6","C6_VALOR")) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
cEmail1 := u_BXFormatEmail(cEmail1)
If !Empty(cEmail1)
	oProcess:cTo := cEmail1
Else
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return

Static Function WFAvResRes(xResumo,xValMin)
**************************************
LOCAL cCodProc 	:= "Resumo Pedidos Eliminados por Residuo", nPos1 := 0
LOCAL cDescProc	:= "Resumo Pedidos Eliminados por Residuo"
LOCAL cHTMLModelo	:= "\workflow\wfavresres.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Resumo dos Pedidos Eliminados por Residuo | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("ValMin","R$"+Transform(xValMin,"@E 999,999,999.99"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPos1 := 1 to Len(xResumo)
	AAdd( oProcess:oHtml:ValByName("Item.ped") , xResumo[nPos1,1] )
	AAdd( oProcess:oHtml:ValByName("Item.cli") , xResumo[nPos1,2] )
	AAdd( oProcess:oHtml:ValByName("Item.pro") , xResumo[nPos1,3] )
	AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(xResumo[nPos1,4],PesqPict("SC6","C6_QTDVEN")) )
	AAdd( oProcess:oHtml:ValByName("Item.val") , Transform(xResumo[nPos1,5],PesqPict("SC6","C6_VALOR")) )
Next nPos1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
oProcess:cTo := Alltrim(GetMV("BR_000097"))
If Empty(oProcess:cTo)
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return