#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"        
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "dbtree.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATA015 ºAutor  ³ Marcelo da Cunha   º Data ³  05/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de Separacao de Pedidos de Venda Brascola         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP11                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATA015()
**********************
PRIVATE oDlgFat, oGetFat, oGetNot, oBold, aCampos, aHdrFat, aHdrNot
PRIVATE n015Linha := 0, n015ValMin := GetMV("BR_VALMIN"), aCampos := {}
PRIVATE aTitle, aPage, nOpcm, cCadastro := "Separacao de Pedidos Brascola"
PRIVATE oVerde := LoadBitmap(GetResources(),"BR_VERDE")
PRIVATE oAmare := LoadBitmap(GetResources(),"BR_AMARELO")
PRIVATE oVerme := LoadBitmap(GetResources(),"BR_VERMELHO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BRASCOLA - PE para gravar informacoes de acesso              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_BCFGA002("BFATA015") //Grava detalhes da rotina usada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHdrFat := {}
aadd(aHdrFat,{""               ,"MM_STATUS"  ,"@BMP",2,00,,,"C",,"V"})
aadd(aHdrFat,{"Pedido"         ,"MM_PEDIDO"  ,"",06,0,"","","C","",""})
aadd(aHdrFat,{"Emissao"        ,"MM_EMISSAO" ,"@E",08,0,"","","D","",""})
aadd(aHdrFat,{"Cliente"        ,"MM_CLIENTE" ,"",08,0,"","","C","",""})
aadd(aHdrFat,{"Loja"           ,"MM_LOJACLI" ,"",04,0,"","","C","",""})
aadd(aHdrFat,{"Nome"           ,"MM_NOMECLI" ,"",40,0,"","","C","",""})
aadd(aHdrFat,{"Valor"          ,"MM_VLRPED"  ,"@E 999,999,999.99",14,2,"","","N","",""})
aadd(aHdrFat,{"Liberação"      ,"MM_DATLIB"  ,"@E",08,0,"","","D","",""})
aadd(aHdrFat,{"Transportadora" ,"MM_TRANSP"  ,"",06,0,"","","C","",""})
aadd(aHdrFat,{"Nome"           ,"MM_NOMETRA" ,"",40,0,"","","C","",""})
aHdrNot := {}
aadd(aHdrNot,{"Serie"          ,"MM_SERIE"   ,"",03,0,"","","C","",""})
aadd(aHdrNot,{"Nota"           ,"MM_NOTA"    ,"",09,0,"","","C","",""})
aadd(aHdrNot,{"Emissao"        ,"MM_EMISSAO" ,"@E",08,0,"","","D","",""})
aadd(aHdrNot,{"Cliente"        ,"MM_CLIENTE" ,"",08,0,"","","C","",""})
aadd(aHdrNot,{"Loja"           ,"MM_LOJACLI" ,"",04,0,"","","C","",""})
aadd(aHdrNot,{"Nome"           ,"MM_NOMECLI" ,"",40,0,"","","C","",""})
aadd(aHdrNot,{"Valor"          ,"MM_VLRBRU"  ,"@E 999,999,999.99",14,2,"","","N","",""})
aadd(aHdrNot,{"Transportadora" ,"MM_TRANSP"  ,"",06,0,"","","C","",""})
aadd(aHdrNot,{"Nome"           ,"MM_NOMETRA" ,"",40,0,"","","C","",""})
aadd(aHdrNot,{"Pedido"         ,"MM_PEDIDO"  ,"",80,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas pelo programa                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina := {{"","",0,1},{"","",0,2},{"","",0,3},{"","",0,4},{"","",0,5},{"","",0,6},{"","",0,7},,{"","",0,8}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Consulta                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0, 220, .T., .T. })
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0, 120, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgFat FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] SAY Upper(cCadastro)+": "+dtoc(dDataBase) OF oDlgFat PIXEL SIZE 245,9 FONT oBold
@ aPosObj[1,1]+14,aPosObj[1,2] TO aPosObj[1,1]+15,(aPosObj[1,4]-aPosObj[1,2]) LABEL "" OF oDlgFat PIXEL
oButAtu1 := B015Button(oDlgFat,"oButAtu1","ATUALIZA",010,aPosObj[2,1],,,{|| B015AtuDados() })
oButPed1 := B015Button(oDlgFat,"oButPed1","PEDIDO",070,aPosObj[2,1],,,{|| B015VerPedido() })
oButRel1 := B015Button(oDlgFat,"oButRel1","RELATORIO",130,aPosObj[2,1],,,{|| u_BFATA016() })
oButFat1 := B015Button(oDlgFat,"oButFat1","FATURAR",190,aPosObj[2,1],,,{|| B015FatPedido() })
oButBar1 := B015Button(oDlgFat,"oButBar1","LER CODBAR",250,aPosObj[2,1],,,{|| B015CodBarras() })
oButMon1 := B015Button(oDlgFat,"oButMon1","MONITOR",310,aPosObj[2,1],,,{|| SpedNFe6Mnt() })
oButFec1 := B015Button(oDlgFat,"oButFec1","FECHAR",370,aPosObj[2,1],,,{|| oDlgFat:End() })
aCols := {} ; B015ZeraCols(@aHdrFat,@aCols)
oGetFat := MsNewGetDados():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgFat,aHdrFat,aCols)
oGetFat:oBrowse:bChange := {|| B015ChgPed() }
oGetFat:oBrowse:lUseDefaultColors := .F.
oGetFat:oBrowse:SetBlkBackColor({||B015CorFat(oGetFat:aHeader,oGetFat:aCols,oGetFat:nAt)})
@ aPosObj[4,1],005 BITMAP oBmp RESNAME "BR_VERDE" OF oDlgFat SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],015 SAY "Pedido Em Aberto" SIZE 120,10 OF oDlgFat PIXEL
@ aPosObj[4,1],105 BITMAP oBmp RESNAME "BR_AMARELO" OF oDlgFat SIZE 20,10 PIXEL NOBORDER
@ aPosObj[4,1],115 SAY "Pedido Faturado Parcial" SIZE 120,10 OF oDlgFat PIXEL
aCols := {} ; B015ZeraCols(@aHdrNot,@aCols)
oGetNot := MsNewGetDados():New(aPosObj[5,1],aPosObj[5,2],aPosObj[5,3],aPosObj[5,4],0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgFat,aHdrNot,aCols)
oGetNot:oBrowse:lUseDefaultColors := .F.
oGetNot:oBrowse:SetBlkBackColor({||RGB(250,250,250)})
B015AtuDados() //Processamento Inicial
ACTIVATE MSDIALOG oDlgFat CENTERED

Return

Static Function B015AtuDados()
***************************
If (oGetFat != Nil)
	Processa({||B015PrAtuDad()})
Endif
Return

Static Function B015PrAtuDad()
***************************
LOCAL aCols1 := {}, cQuery1 := "", cPedidos1 := "", nLin1 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo aHeader dos pedidos de venda liberados              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(oGetFat:aHeader) ; aCols1 := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto query para enviar ao banco de dados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT C9_PEDIDO,C9_CLIENTE,C9_LOJA,C9_DATALIB,SUM(C9_QTDLIB*C9_PRCVEN) C9_TOTAL "
cQuery1 += "FROM "+RetSqlName("SC9")+" C9 WHERE C9.D_E_L_E_T_ = '' "
cQuery1 += "AND C9_FILIAL = '"+xFilial("SC9")+"' AND C9_BLEST = '' AND C9_BLCRED = '' "
cQuery1 += "GROUP BY C9_PEDIDO,C9_CLIENTE,C9_LOJA,C9_DATALIB "
cQuery1 += "ORDER BY C9_PEDIDO,C9_CLIENTE,C9_LOJA,C9_DATALIB "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","C9_DATALIB","D",08,0)
SC5->(dbSetOrder(1)) ; SA1->(dbSetOrder(1)) ; SA4->(dbSetOrder(1))
Procregua(1)
dbSelectArea("MAR")
While !MAR->(Eof())
	Incproc("> Buscando Pedidos: "+MAR->C9_pedido)
	SC5->(dbSeek(xFilial("SC5")+MAR->C9_pedido,.T.))
	aadd(aCols1,Array(Len(aHeader)+1))
	nLin1 := Len(aCols1)
	aCols1[nLin1,GDFieldPos("MM_STATUS")]  := B015Status(MAR->C9_pedido)
	aCols1[nLin1,GDFieldPos("MM_PEDIDO")]  := MAR->C9_pedido
	aCols1[nLin1,GDFieldPos("MM_EMISSAO")] := SC5->C5_emissao
	aCols1[nLin1,GDFieldPos("MM_CLIENTE")] := MAR->C9_cliente
	aCols1[nLin1,GDFieldPos("MM_LOJACLI")] := MAR->C9_loja
	If !Empty(MAR->C9_cliente+MAR->C9_loja)
		aCols1[nLin1,GDFieldPos("MM_NOMECLI")] := Posicione("SA1",1,xFilial("SA1")+MAR->C9_cliente+MAR->C9_loja,"A1_NOME")
	Else
		aCols1[nLin1,GDFieldPos("MM_NOMECLI")] := Space(40)
	Endif
	aCols1[nLin1,GDFieldPos("MM_VLRPED")]  := MAR->C9_total
	aCols1[nLin1,GDFieldPos("MM_DATLIB")]  := MAR->C9_datalib
	aCols1[nLin1,GDFieldPos("MM_TRANSP")]  := SC5->C5_transp
	If !Empty(SC5->C5_transp)
		aCols1[nLin1,GDFieldPos("MM_NOMETRA")] := Posicione("SA4",1,xFilial("SA4")+SC5->C5_transp,"A4_NOME")
	Else
		aCols1[nLin1,GDFieldPos("MM_NOMETRA")] := Space(40)
	Endif
	aCols1[nLin1,Len(aHeader)+1] := .F.
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando tela dos pedidos de venda liberados              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aCols1) == 0)
	B015ZeraCols(@aHeader,@aCols1)
Endif
oGetFat:aCols := aClone(aCols1)
oGetFat:oBrowse:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo aHeader das ultimas XX notas fiscais faturadas      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(oGetNot:aHeader) ; aCols1 := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto query para enviar ao banco de dados                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT TOP 30 F2_SERIE,F2_DOC,F2_CLIENTE,F2_LOJA,F2_EMISSAO,F2_VALBRUT,F2_TRANSP "
cQuery1 += "FROM "+RetSqlName("SF2")+" F2 WHERE F2.D_E_L_E_T_ = '' "
cQuery1 += "AND F2_FILIAL = '"+xFilial("SF2")+"' AND F2_EMISSAO >= '"+dtos(MsDate()-7)+"' "
cQuery1 += "ORDER BY R_E_C_N_O_ DESC "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","F2_EMISSAO","D",08,0)
SD2->(dbSetOrder(3)) ; SA1->(dbSetOrder(1)) ; SA4->(dbSetOrder(1))
Procregua(1)
dbSelectArea("MAR")
While !MAR->(Eof())
	Incproc("> Buscando Notas: "+MAR->F2_doc)
	aadd(aCols1,Array(Len(aHeader)+1))
	nLin1 := Len(aCols1)
	aCols1[nLin1,GDFieldPos("MM_SERIE")]   := MAR->F2_serie
	aCols1[nLin1,GDFieldPos("MM_NOTA")]    := MAR->F2_doc
	aCols1[nLin1,GDFieldPos("MM_EMISSAO")] := MAR->F2_emissao
	aCols1[nLin1,GDFieldPos("MM_CLIENTE")] := MAR->F2_cliente
	aCols1[nLin1,GDFieldPos("MM_LOJACLI")] := MAR->F2_loja
	If !Empty(MAR->F2_cliente+MAR->F2_loja)
		aCols1[nLin1,GDFieldPos("MM_NOMECLI")] := Posicione("SA1",1,xFilial("SA1")+MAR->F2_cliente+MAR->F2_loja,"A1_NOME")
	Else
		aCols1[nLin1,GDFieldPos("MM_NOMECLI")] := Space(40)
	Endif
	aCols1[nLin1,GDFieldPos("MM_VLRBRU")]  := MAR->F2_valbrut
	aCols1[nLin1,GDFieldPos("MM_TRANSP")]  := MAR->F2_transp
	If !Empty(MAR->F2_transp)
		aCols1[nLin1,GDFieldPos("MM_NOMETRA")] := Posicione("SA4",1,xFilial("SA4")+MAR->F2_transp,"A4_NOME")
	Else
		aCols1[nLin1,GDFieldPos("MM_NOMETRA")] := Space(40)
	Endif
	aCols1[nLin1,GDFieldPos("MM_PEDIDO")] := B015PedNota(MAR->F2_serie,MAR->F2_doc)
	aCols1[nLin1,Len(aHeader)+1] := .F.
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizando tela das notas fiscais faturadas                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aCols1) == 0)
	B015ZeraCols(@aHeader,@aCols1)
Endif
oGetNot:aCols := aClone(aCols1)
oGetNot:oBrowse:Refresh()

Return

Static Function B015PedNota(xSerie,xNota)
*************************************
LOCAL cRetu1 := ""
SD2->(dbSeek(xFilial("SD2")+xNota+xSerie,.T.))
While !SD2->(Eof()).and.(xFilial("SD2") == SD2->D2_filial).and.(SD2->D2_doc+SD2->D2_serie == xNota+xSerie)
	If Empty(cRetu1).or.!(SD2->D2_pedido $ cRetu1)
		cRetu1 += SD2->D2_pedido+","
	Endif
	SD2->(dbSkip())
Enddo
cRetu1 := Left(cRetu1,Len(cRetu1)-1)
Return cRetu1

Static Function B015ChgPed()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo variaveis de acordo com a linha                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0).and.(oGetFat:nAt > 0)
	n015Linha := oGetFat:nAt
	oGetFat:oBrowse:Refresh()
Endif

Return

Static Function B015Status(xPedido)
********************************
LOCAL oRetu := oVerde
SC9->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
SC9->(dbSeek(xFilial("SC9")+xPedido,.T.))
While !SC9->(Eof()).and.(xFilial("SC9") == SC9->C9_filial).and.(SC9->C9_pedido == xPedido)
	If SC6->(dbSeek(xFilial("SC6")+SC9->C9_pedido+SC9->C9_item)).and.(SC6->C6_qtdent > 0) 
		oRetu := oAmare
		Exit
	Endif
	SC9->(dbSkip())
Enddo
Return oRetu

Static Function B015VerPedido()
****************************
LOCAL nPPed := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico pedido de venda                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0).and.(oGetFat:nAt > 0)
	nPPed := GDFieldPos("MM_PEDIDO",oGetFat:aHeader)
	SC5->(dbSetOrder(1))
	If SC5->(dbSeek(xFilial("SC5")+oGetFat:aCols[oGetFat:nAt,nPPed]))
		A410Visual("SC5",SC5->(Recno()),2)
	Endif
Endif

Return

Static Function B015FatPedido()
****************************
LOCAL nPPed := 0, nPVlr := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico pedido de venda                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0).and.(oGetFat:nAt > 0)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Validacao valor minimo                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPVlr := GDFieldPos("MM_VLRPED",oGetFat:aHeader)
	If (oGetFat:aCols[oGetFat:nAt,nPVlr] < n015ValMin)
		Help("",1,"BRASCOLA",,OemToAnsi("Valor do pedido abaixo do valor minimo! Favor verificar."),1,0) 
		Return
	Endif   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamo rotina para faturar pedido                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nPPed := GDFieldPos("MM_PEDIDO",oGetFat:aHeader)
	If MsgYesNo("> Confirma Faturamento do Pedido "+oGetFat:aCols[oGetFat:nAt,nPPed]+" ? ")
		MsgRun("Faturando Pedido "+oGetFat:aCols[oGetFat:nAt,nPPed]+"...","Separacao Pedidos Brascola",{|| U_RFATM03A(oGetFat:aCols[oGetFat:nAt,nPPed]) })
		B015AtuDados() //Processamento Inicial
	Endif
	
Endif

Return

Static Function B015CodBarras()
****************************
PRIVATE oDlgBar, cCodBar := Space(6)
                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Codigo de Barras                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlgBar FROM 0,0 TO 100,380 TITLE OemToAnsi("Ler Código de Barras do Pedido de Venda:") Of oMainWnd PIXEL
oSayBar1 := B015Say(oDlgBar,"oSayBar1","Código de Barras:",010,020)
oSayBar1:oFont := oBold
oGetBar1 := B015Get(oDlgBar,"cCodBar","cCodBar",070,018,50,,{|| iif(B015ValCBar(),(B015FatCBar(),oDlgBar:End()),.F.) },"@E")
oButBar1 := B015Button(oDlgBar,"oButBar1","Faturar",120,018,,,{|| iif(B015ValCBar(),(B015FatCBar(),oDlgBar:End()),.F.) })
ACTIVATE MSDIALOG oDlgBar CENTERED

Return

Static Function B015ValCBar()
***************************
LOCAL lRetu := .T., cQueryn                                     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se pedido de venda existe                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SC5->(dbSetOrder(1))
If !SC5->(dbSeek(xFilial("SC5")+cCodBar))
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+cCodBar+" não foi encontrado! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif !Empty(SC5->C5_nota).or.(SC5->C5_liberok == "E").and.Empty(SC5->C5_blq)
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+cCodBar+" esta encerrado! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif !SC9->(dbSeek(xFilial("SC9")+cCodBar))
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+cCodBar+" não esta liberado! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Validar valor minimo no pedido de venda                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQueryn := "SELECT SUM(C92.C9_QTDLIB*C92.C9_PRCVEN) M_VALPED "
cQueryn += "FROM SC9010 C92 WHERE C92.D_E_L_E_T_ <> '*' "
cQueryn += "AND C92.C9_BLEST = '' AND C92.C9_BLCRED = '' "
cQueryn += "AND C92.C9_FILIAL = '01' AND C92.C9_NFISCAL = '' "
cQueryn += "AND C92.C9_PEDIDO = '"+cCodBar+"' "
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif
TCQuery cQueryn NEW ALIAS "MAR"
If (MAR->(Bof()).and.MAR->(Eof())).or.(MAR->M_VALPED == 0)
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+cCodBar+" não esta apto para faturar! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif (MAR->M_VALPED < n015ValMin)
	Help("",1,"BRASCOLA",,OemToAnsi("Valor do pedido "+cCodBar+" abaixo do valor minimo! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Endif

Return lRetu 

Static Function B015FatCBar()
***************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rotina para efetivar o faturamento do pedido informado       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MsgRun("Faturando Pedido "+cCodBar+"...","Separacao Pedidos Brascola",{|| U_RFATM03A(cCodBar) })
B015AtuDados() //Processamento Inicial

Return 

Static Function B015ZeraCols(xHeader,xCols)
**************************************
LOCAL _p, nCnt
xCols := {}
aAdd(xCols,Array(Len(xHeader)+1))
nCnt := Len(xCols)
For _p := 1 to Len(xHeader)
	If (xHeader[_p,8] == "C")
		xCols[nCnt,_p] := Space(xHeader[_p,4])
	Elseif (xHeader[_p,8] == "N")
		xCols[nCnt,_p] := 0
	Elseif (xHeader[_p,8] == "D")
		xCols[nCnt,_p] := ctod("//")
	Else
		xCols[nCnt,_p] := CriaVar(xHeader[_p,2])
	Endif
Next _p
xCols[nCnt,Len(xHeader)+1] := .F.
Return

Static Function B015Say(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xColor,xBackClr)
******************************************************************************
LOCAL oSay := Nil     
oSay := TSAY():New(xTop,xLeft,{|| xCaption},xObj,,,.F.,.F.,.F.,.T.,iif(xColor!=Nil,xColor,CLR_BLUE),iif(xBackClr!=Nil,xBackClr,Nil),iif(xWidth!=Nil,xWidth,80),iif(xHeight!=Nil,xHeight,10),.F.,.F.,.F.,.F.,.F.)
Return (oSay)       

Static Function B015Get(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xChange,xPicture,xF3)
***********************************************************************************
LOCAL oGet := Nil, bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oGet := TGET():New(xTop,xLeft,bSetGet,xObj,iif(xWidth!=Nil,xWidth,80),iif(xHeight!=Nil,xHeight,10),xPicture,,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,xChange,.F.,.F.,,xVariable,,,,)
oGet:cF3 := xF3
Return (oGet)

Static Function B015Button(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xAction)
*************************************************************************
LOCAL oButton := Nil
oButton := TBUTTON():New(xTop,xLeft,xCaption,xObj,xAction,iif(xWidth!=Nil,xWidth,60),iif(xHeight!=Nil,xHeight,11),,,,.T.)
Return (oButton)

Static Function B015Combo(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xItens,xChange)
*******************************************************************************
LOCAL oCombo := Nil, bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oCombo := TComboBox():Create(xObj,bSetGet,xTop,xLeft,xItens,xWidth,xHeight,,xChange,,,,.T.)
Return (oCombo)

Static Function B015CorFat(xHeader,xCols,xAt)
*****************************************
LOCAL nRetu := RGB(250,250,250)
If (n015Linha == xAt)
	nRetu := RGB(230,245,245) //Selecionado
Endif
Return nRetu