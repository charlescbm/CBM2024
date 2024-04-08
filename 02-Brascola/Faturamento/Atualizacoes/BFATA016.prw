#include "rwmake.ch"
#include "topconn.ch"
#include "font.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATA016 ºAutor  ³ Marcelo da Cunha   º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de Separacao de Pedidos de Venda Brascola        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATA016()
**********************
LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3         := "Transferencia de Produto para Transportadora"
LOCAL cPict          := ""
LOCAL titulo         := "SEPARACAO DE PEDIDOS"
LOCAL Cabec1         := ""
LOCAL Cabec2         := ""
LOCAL imprime        := .T.
LOCAL aOrd 			   := {}

PRIVATE Lin          := 0
PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 80
PRIVATE tamanho      := "M"
PRIVATE nomeprog     := "SEPPED" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
PRIVATE nLastKey     := 0
PRIVATE cPerg        := "BFATA016"
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "SEPPED" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE aRegs    	   := {}
PRIVATE cString      := "SF2"
PRIVATE nlargura	   := 80
PRIVATE xStr		   := 40
PRIVATE nrecuo		   := 10
PRIVATE nVolTot      := 0
PRIVATE oFont16, oFont14, oFont18, oFont12, oFont10, oFont09
PUBLIC oPrint
                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRegs := {}
AADD(aRegs,{cPerg,"01","Mostrar Pedido Venda ?","mv_ch1","N",01,0,0,"C","","MV_PAR01","Atual","","","Conforme Parametro","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Numero do Pedido De  ?","mv_ch2","C",06,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","SC5"})
AADD(aRegs,{cPerg,"03","Numero do Pedido Ate ?","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SC5"})
u_BXCriaPer(cPerg,aRegs) //Brascola
If !Pergunte(cPerg,.T.)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nLastKey == 27)
	Return
Endif

oPrint:= TMSPrinter():New("SEPARAÇÃO DE PEDIDOS")
oPrint:SetPortrait()

MsgRun("Gerando Visualizacao, Aguarde...","",{|| CursorWait(), RunReport(oPrint) ,CursorArrow()})

oPrint:Preview()  // Visualiza antes de imprimir

Return Nil

Static Function RunReport()
*************************
LOCAL nOrdem, cQuery1 := "", nValMin := GetMV("BR_VALMIN")

oFont09	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont09n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont11	:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
oFont12	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont14	:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16	:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont18	:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)
                      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validar valor minimo no pedido de venda                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (mv_par01 == 1).and.(oGetFat != Nil) //Atual
	cQueryn := "SELECT SUM(C92.C9_QTDLIB*C92.C9_PRCVEN) M_VALPED "
	cQueryn += "FROM SC9010 C92 WHERE C92.D_E_L_E_T_ <> '*' "
	cQueryn += "AND C92.C9_BLEST = '' AND C92.C9_BLCRED = '' AND C92.C9_FILIAL = '01' AND C92.C9_NFISCAL = '' "
	cQueryn += "AND C92.C9_PEDIDO = '"+oGetFat:aCols[oGetFat:nAt,GDFieldPos("MM_PEDIDO",oGetFat:aHeader)]+"' "
	If (Select("MAR") > 0)
		dbSelectArea("MAR")
		MAR->(dbCloseArea())        
	Endif
	TCQuery cQueryn NEW ALIAS "MAR"
	If (MAR->(Bof()).and.MAR->(Eof())).or.(MAR->M_VALPED == 0)
		Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+oGetFat:aCols[oGetFat:nAt,GDFieldPos("MM_PEDIDO",oGetFat:aHeader)]+" não esta apto para faturar! Favor verificar."),1,0) 
		Return
	Elseif (MAR->M_VALPED < n015ValMin)
		Help("",1,"BRASCOLA",,OemToAnsi("Valor do pedido "+oGetFat:aCols[oGetFat:nAt,GDFieldPos("MM_PEDIDO",oGetFat:aHeader)]+" abaixo do valor minimo! Favor verificar."),1,0) 
		Return
	Endif
Endif
              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do relatorio de separacao dos pedidos para faturamento    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO "
cQuery1 += "FROM "+RetSqlName("SC9")+" C9, "+RetSqlName("SC5")+" C5 "
cQuery1 += "WHERE C9.D_E_L_E_T_ = '' AND C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery1 += "AND C5.D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery1 += "AND C9_BLEST = '' AND C9_BLCRED = '' AND C9_PEDIDO = C5_NUM "
If (mv_par01 == 1).and.(oGetFat != Nil) //Atual
	cQuery1 += "AND C9_PEDIDO = '"+oGetFat:aCols[oGetFat:nAt,GDFieldPos("MM_PEDIDO",oGetFat:aHeader)]+"' "
Else //Conforme Parametro
	cQuery1 += "AND C9_PEDIDO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "
Endif
cQuery1 += "AND (C5.C5_CONDPAG IN ('000','001','060') OR "
cQuery1 += "		(SELECT SUM((C92.C9_QTDLIB*C92.C9_PRCVEN)) "
cQuery1 += "		 FROM SC9010 C92 WHERE C92.D_E_L_E_T_ = '' "
cQuery1 += "		 AND C92.C9_FILIAL = '"+xFilial("SC9")+"' "
cQuery1 += "		 AND C92.C9_BLEST = '' AND C92.C9_BLCRED = '' "
cQuery1 += "		 AND C92.C9_NFISCAL = '' AND C92.C9_PEDIDO = C9.C9_PEDIDO "
cQuery1 += "		 GROUP BY C92.C9_PEDIDO) >= "+Alltrim(Str(nValMin))+") "
cQuery1 += "ORDER BY C9_PEDIDO,C9_ITEM,C9_SEQUEN "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1)) ; SC9->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())
             
	//Posiciono no cabecalho do pedido de venda
	///////////////////////////////////////////
	If !SC5->(dbSeek(xFilial("SC5")+MAR->C9_pedido))
		MAR->(dbSkip())
		Loop
	Endif
		
   //Impressao do cabecalho
   ////////////////////////
	ImpCab()		

	//Impressao dos itens do pedido
	///////////////////////////////		
	_cCtrlIt := _nQuant := 0   
	_cPedido := MAR->C9_pedido
	While !MAR->(Eof()).and.(MAR->C9_pedido == _cPedido) 
		If !SC6->(dbSeek(xFilial("SC6")+MAR->C9_pedido+MAR->C9_item))
			MAR->(dbSkip())
			Loop
		Endif
		If !SC9->(dbSeek(xFilial("SC9")+MAR->C9_pedido+MAR->C9_item+MAR->C9_sequen+MAR->C9_produto)).or.!Empty(SC9->C9_blcred).or.!Empty(SC9->C9_blest)
			MAR->(dbSkip())
			Loop
		Endif
		_cLOCAL	  := SC9->C9_local
		_cCod		  := SC9->C9_produto
		_cLoteCtl  := SC9->C9_lotectl
		_cUm		  := SC6->C6_um
		_nQuant	  += SC9->C9_qtdlib
		_cChavLote := SC9->C9_pedido+SC9->C9_produto+SC9->C9_lotectl
				
		lin += 100
		oPrint:Say(lin,0005,_cLOCAL,oFont11)
					
		dbSelectArea("SB1")
		dbSetOrder(1)
		If dbSeek(XFILIAL("SB1")+_cCod)
			oPrint:Say(lin,0120,SB1->B1_TIPO,oFont11)
		Endif
					
		oPrint:Say(lin,0220,ALLTRIM(_cCod),oFont11)
		oPrint:Say(lin,0420,ALLTRIM(SUBSTR(SB1->B1_DESC,1,50)),oFont11)
		oPrint:Say(lin,1500,_cLoteCtl,oFont11)      //1300
		oPrint:Say(lin,1740,ALLTRIM(_cUM),oFont11)
		oPrint:Say(lin,1900,STR(_nQuant,9,2),oFont11)
		oPrint:Say(lin,2100,"______________",oFont11)
					
		_nQuant := 0
		_cCtrlIt++
		If _cCtrlIt>15
			oPrint:EndPage()	// Finaliza a pagina
			ImpCab()
			_cCtrlIt:=0
		Endif

		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo
			
	lin += 5
	oPrint:Say(lin,0000,Replicate("_",80),oFont16)
	lin += 80
	oPrint:Say(lin,0005,"Descricao dos Volumes: " + ALLTRIM(STR(SC5->C5_VOLUME1)) + " " + SC5->C5_ESPECI1,oFont11)    
	lin += 100
	oPrint:Say(lin,0005,"Peso Liquido: " +  ALLTRIM(STR(SC5->C5_PESOL)) ,oFont11)
	oPrint:Say(lin,1200,"Peso Bruto: " + ALLTRIM(STR(SC5->C5_PBRUTO)) ,oFont11)
	lin += 100
	oPrint:Say(lin,0005,"Separado Por: ______________________________",oFont11)
	oPrint:Say(lin,1200,"Conferido Por: _____________________________",oFont11)
			
	cSuframa:= Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_SUFRAMA")
	If !Empty(cSuframa)
		lin += 80
		oPrint:Say(lin,0005,"Aguardando Geracao de P I N ______________________________",oFont14)
	Endif
			
	oPrint:EndPage() 		// Finaliza a pagina
		
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

Static Function ImpCab()
**********************
oPrint:StartPage() // Inicia uma nova pagina
lin := 045
oPrint:SayBitmap(lin,0005,"LGRL01.BMP",237,58)
oPrint:SayBitmap(lin,2050,"LOGO.BMP"    ,237,58)
oPrint:Say(lin,0800,"SEPARAÇÃO DE PEDIDOS" ,oFont16)
lin += 048
oPrint:Say(lin,0005,"Empresa: "+SM0->M0_NOME,oFont14)
oPrint:Say(lin,2000,"Data: "+DtoC(Date())/*SM0->M0_NOME*/,oFont14)
lin += 020
oPrint:Say(lin,0000,REPLICATE("_",80),oFont16)
dbSelectArea("SA4")
dbSetOrder(1)
IF dbSeek(XFILIAL("SA4")+ALLTRIM(SC5->C5_TRANSP))
	lin += 100
	oPrint:Say(lin,1000,"TRANSPORTADORA: " + SA4->A4_COD + '--> ' + SA4->A4_NREDUZ,oFont16)
Endif
IF !Empty(SC5->C5_REDESP)
	IF dbSeek(XFILIAL("SA4")+ALLTRIM(SC5->C5_REDESP))
		lin += 070
		oPrint:Say(lin,1000,"REDESPACHO: " + SA4->A4_COD + '--> ' + SA4->A4_NREDUZ,oFont14)
	Endif
Endif
Lin += 050
MSBAR("CODE3_9",3.6,15,SC5->C5_NUM,oPrint,.F.,,,0.025,0.9,,,"E",.F.)
lin += 100
oPrint:Say(lin,0005,"Pedido: " + RTRIM(SC5->C5_NUM),oFont11)
oPrint:Say(lin,1200,"Despachar em: " + DTOC(SC5->C5_EMISSAO),oFont11)
dbSelectArea("SA3")
dbSetOrder(1)
IF dbSeek(XFILIAL("SA3")+SC5->C5_VEND1)
	lin += 70
	oPrint:Say(lin,0005,"Representante: " + SC5->C5_VEND1 + " " + SA3->A3_NREDUZ,oFont11)
Endif
dbSelectArea("SA1")
dbSetOrder(1)
IF dbSeek(XFILIAL("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
	lin += 70
	oPrint:Say(lin,0005,"Cliente: " + SA1->A1_COD + " " + SA1->A1_LOJA + " " + Substr(SA1->A1_NOME,1,52),oFont11)  
	oPrint:Say(lin,1200,"Telefone: " + TRANSFORM(SA1->A1_TEL,"@R 9999-9999"),oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Endereço: " + SUBSTR(SA1->A1_END,1,50),oFont11)
	oPrint:Say(lin,1200,"Bairro: " + SA1->A1_BAIRRO,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Cidade: " + SUBSTR(SA1->A1_MUN,1,50),oFont11)
	oPrint:Say(lin,1200,"Estado: " + SA1->A1_EST ,oFont11)
	oPrint:Say(lin,1600,"CEP: " + SA1->A1_CEP ,oFont11)
	oPrint:Say(lin,2000,"País: " ,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"CNPJ / CGC: " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont11)
	oPrint:Say(lin,1200, "Insc. Est.: " + SA1->A1_INSCR,oFont11)
Endif
dbSelectArea("SA4")
dbSetOrder(1)
IF dbSeek(XFILIAL("SA4")+ALLTRIM(SC5->C5_TRANSP))
	lin += 100
	oPrint:Say(lin,0005,"Nome: " + SA4->A4_COD + "-"+SA4->A4_NREDUZ,oFont11)
	oPrint:Say(lin,1200,"Telefone: " + TRANSFORM(SA4->A4_TEL,"@R 9999-9999"),oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Endereço: " + SUBSTR(SA4->A4_END,1,50),oFont11)
	oPrint:Say(lin,1200,"Bairro: " + SA4->A4_BAIRRO,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Cidade: " + SA4->A4_MUN,oFont11)
	oPrint:Say(lin,1200,"Estado: " + SA4->A4_EST,oFont11)
	oPrint:Say(lin,1600,"CEP: " + SA4->A4_CEP,oFont11)
	oPrint:Say(lin,2000,"País: ",oFont11)
	lin += 70
	oPrint:Say(lin,0005,"CNPJ / CPF: " + Transform(SA4->A4_CGC,"@R 99.999.999/9999-99"),oFont11)
	oPrint:Say(lin,1200,"Ins. Est.: " + SA4->A4_INSEST,oFont11)
Endif
lin += 5
oPrint:Say(lin,0000,REPLICATE("_",80),oFont16)
lin += 80
oPrint:Say(lin,0005,"DEP  TIPO  ITEM        DESCRIÇÃO                                                                               LOTE       UN QTD ALOCADA QTD SEPARADA",oFont11)
lin += 25
oPrint:Say(lin,0005,"____  ____  _____      _______________________________________ ____________________  __ _____________  ______________",oFont11)
Return