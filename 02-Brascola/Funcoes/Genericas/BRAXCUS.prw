#include "rwmake.ch"
#include "topconn.ch"
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BRAXCUS  ºAutor  ³ Marcelo da Cunha   º Data ³  10/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para calcular custo e indicadores do produto        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BRAXCUS(xTabela,xProdutos,xRetCampo,xRetCSim,xRetCDet)
*************************************************************
LOCAL nRetu := 0, nSegN := 0, na, nPos1, nPos2, nPosDet, nPosSim
LOCAL aPlanilha := {}, aCSim := {}, aCDet := {}, aSegHdr := {}, aSegCol := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Custo a ser considerado nos calculos                           ³
//³ 1 = STANDARD    2 = MEDIO     3 = MOEDA2     4 = MOEDA3        ³
//³ 5 = MOEDA4      6 = MOEDA5    7 = ULTPRECO   8 = PLANILHA      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nQualCusto := 1, cProg := "C010", cArqMemo := "STANDARD"
PRIVATE lDirecao := .T., lConsNeg := .T., nQtdTotais := 0, nMatPrima := 0
PRIVATE aArray := {}, aAuxCusto := {}, aFormulas := {}, aTotais := {}
PRIVATE cPlanilha := Space(10), aHdrSim := {}, aHdrDet := {}
PRIVATE aTamCus := TamSx3("B1_CUSTD"), cPicCus := PesqPict("SB1","B1_CUSTD")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico tabela de preco informada                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(xTabela)
	Help("",1,"BRASCOLA",,OemToAnsi("Informar a tabela de preco "+Alltrim(xTabela)+" nao foi informada!"),1,0) 
	Return nRetu
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo variaveis utilizadas para o calculo               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPlanilha := GetMV("BR_000028") //Planilha Padrao
cPlanilha := FileNoExt(Alltrim(cPlanilha))
cArqMemo := "STANDARD"
If !Empty(cPlanilha)
	cArqMemo := cPlanilha
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Type("aHeader") != "U") 
	aSegHdr := aClone(aHeader)
Endif
If (Type("aCols") != "U") 
	aSegCol := aClone(aCols)
Endif
If (Type("N") != "U")
	nSegN := N
Endif
aHdrSim := {} ; aHdrDet := {} ; aHeader := {} ; aCols := {}
//SIMULACAO PEDIDO DE VENDA///////////////////////////////////////
aadd(aHdrSim,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrSim,{"Descricao"  ,"MM_DESC"  ,"",30,5,"","","C","",""})
aadd(aHdrSim,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
aadd(aHdrSim,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrSim,{"Quantidade" ,"MM_QTDADE",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Tabela" ,"MM_PRCTAB",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Total " ,"MM_PRCTOT",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Simula" ,"MM_PRCSIM",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"% Desconto" ,"MM_PERDES","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrSim,{"Novo Preco" ,"MM_PRCNOV",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"Lucro Liqu" ,"MM_VALLUC",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrSim,{"% Lucro Liq","MM_PERLUC","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrSim,{"Tabela"     ,"MM_TABELA","",03,0,"","","C","",""})
//DETALHAMENTO CUSTOS,DEPESAS E MARKUP////////////////////////////
aadd(aHdrDet,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrDet,{"Descricao"  ,"MM_DESC"  ,"",30,5,"","","C","",""})
aadd(aHdrDet,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
aadd(aHdrDet,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrDet,{"Custo Rev"  ,"MM_CUSTRE",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Custo MP"   ,"MM_CUSTMP",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Custo MOD"  ,"MM_CUSTMO",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Custo Ben"  ,"MM_CUSTBE",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Custo Emb"  ,"MM_CUSTEM",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Custo Fab"  ,"MM_CUSTFA",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Desp Adm" ,"MM_PERADM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Desp Adm"   ,"MM_VALADM",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Desp Mkt" ,"MM_PERMKT","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Desp Mkt"   ,"MM_VALMKT",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Desp Fin" ,"MM_PERFIN","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Desp Fin"   ,"MM_VALFIN",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Desp Com" ,"MM_PERCOM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Desp Com"   ,"MM_VALCOM",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Desp Fixa","MM_PERFIX","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Desp Fixa"  ,"MM_VALFIX",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Lucro Bru","MM_PERLUC","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Lucro Brut" ,"MM_VALLUC",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Margem"   ,"MM_PERMAR","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Margem Con" ,"MM_VALMAR",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Cofins"   ,"MM_PERCOF","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Confins"    ,"MM_VALCOF",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% PIS"      ,"MM_PERPIS","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"PIS"        ,"MM_VALPIS",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% ICMS"     ,"MM_PERICM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"ICMS"       ,"MM_VALICM",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Impostos"   ,"MM_IMPOST",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Prc Liquid" ,"MM_PRCLIQ",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Comissao" ,"MM_PERCMS","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Comissao"   ,"MM_VALCMS",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"% Frete"    ,"MM_PERFRE","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrDet,{"Frete"      ,"MM_VALFRE",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Despesas"   ,"MM_DESPES",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
aadd(aHdrDet,{"Preco Venda","MM_PRCVEN",cPicCus,aTamCus[1],aTamCus[2],"","","N","",""})
//////////////////////////////////////////////////////////////////

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionar na Planilha de Detalhes                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCDet := {} ; aCSim := {}
SB1->(dbSetOrder(1))
For na := 1 to Len(xProdutos)
	If Empty(xProdutos[na,1]).or.!SB1->(dbSeek(xFilial("SB1")+xProdutos[na,1]))
		Help("",1,"BRASCOLA",,OemToAnsi("Produto "+Alltrim(xProdutos[na,1])+" nao foi encontrado!"),1,0) 
		Loop
	Endif
	nMatPrima := 0
	aPlanilha := BCFormPrc(SB1->B1_cod)
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+xProdutos[na,1],.T.))
	//PLANILHA DETALHADA//////////////////////////////////
	aadd(aCDet,Array(Len(aHdrDet)+1))
	nPosDet := Len(aCDet)
	aFill(aCDet[nPosDet],0)
	aHeader := aClone(aHdrDet)
	aCDet[nPosDet,GDFieldPos("MM_COD")]  := SB1->B1_cod
	aCDet[nPosDet,GDFieldPos("MM_DESC")] := SB1->B1_desc
	aCDet[nPosDet,GDFieldPos("MM_UM")]   := SB1->B1_um
	aCDet[nPosDet,GDFieldPos("MM_TIPO")] := SB1->B1_tipo              
	//CUSTO FABRICACAO////////////////////////////////////
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "TOTAL REVENDA" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_CUSTRE")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "TOTAL MATERIA PRIMA" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_CUSTMP")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "TOTAL M.O.D." })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_CUSTMO")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "TOTAL DE BENEFICIAMENTO" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_CUSTBE")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "TOTAL DE EMBALAGEM" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_CUSTEM")] := aPlanilha[nPos2,6]
	Endif
	aCDet[nPosDet,GDFieldPos("MM_CUSTFA")] := aCDet[nPosDet,GDFieldPos("MM_CUSTRE")]+aCDet[nPosDet,GDFieldPos("MM_CUSTMP")]+aCDet[nPosDet,GDFieldPos("MM_CUSTMO")]+aCDet[nPosDet,GDFieldPos("MM_CUSTBE")]+aCDet[nPosDet,GDFieldPos("MM_CUSTEM")]	
	//DESPESAS FIXAS////////////////////////////////////////
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "DESPESA ADM. (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERADM")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "DESPESA MKT. (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERMKT")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "DESPESA FINANC. (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERFIN")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "DESPESA COML. (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERCOM")] := aPlanilha[nPos2,6]
	Endif	                                   
	aCDet[nPosDet,GDFieldPos("MM_PERFIX")] := aCDet[nPosDet,GDFieldPos("MM_PERADM")]+aCDet[nPosDet,GDFieldPos("MM_PERMKT")]+aCDet[nPosDet,GDFieldPos("MM_PERFIN")]+aCDet[nPosDet,GDFieldPos("MM_PERCOM")]
	//LUCRO/////////////////////////////////////////////////
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "LUCRO BRUTO (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERLUC")] := aPlanilha[nPos2,6]
	Endif	                                   
	//IMPOSTOS//////////////////////////////////////////////
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "COFINS (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERCOF")] := aPlanilha[nPos2,6]
	Endif	                                   
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "PIS (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERPIS")] := aPlanilha[nPos2,6]
	Endif	                                   
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "ICMS (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERICM")] := aPlanilha[nPos2,6]
	Endif	                                   
	//DESPESAS VARIAVEIS////////////////////////////////////
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "COMISSAO (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERCMS")] := aPlanilha[nPos2,6]
	Endif
	If ((nPos2 := aScan(aPlanilha,{|x| Alltrim(Upper(x[3])) == "FRETE VENDA (%)" })) > 0).and.(nPos2 >= nMatPrima)
		aCDet[nPosDet,GDFieldPos("MM_PERFRE")] := aPlanilha[nPos2,6]
	Endif
	////////////////////////////////////////////////////////
	aCDet[nPosDet,Len(aHdrDet)+1]  := .F.
	//PLANILHA SIMULACAO////////////////////////////////////
	aadd(aCSim,Array(Len(aHdrSim)+1))
	nPosSim := Len(aCSim)
	aFill(aCSim[nPosSim],0)
	aCSim[nPosSim,GDFieldPos("MM_COD",aHdrSim)]    := aCDet[nPosDet,GDFieldPos("MM_COD",aHdrDet)]
	aCSim[nPosSim,GDFieldPos("MM_DESC",aHdrSim)]   := aCDet[nPosDet,GDFieldPos("MM_DESC",aHdrDet)]
	aCSim[nPosSim,GDFieldPos("MM_UM",aHdrSim)]     := aCDet[nPosDet,GDFieldPos("MM_UM",aHdrDet)]
	aCSim[nPosSim,GDFieldPos("MM_TIPO",aHdrSim)]   := aCDet[nPosDet,GDFieldPos("MM_TIPO",aHdrDet)]
	aCSim[nPosSim,GDFieldPos("MM_TABELA",aHdrSim)] := xTabela //Tabela
	aCSim[nPosSim,GDFieldPos("MM_QTDADE",aHdrSim)] := iif(xProdutos[na,2]!=Nil,xProdutos[na,2],1) //Quantidade
	If (xProdutos[na,2] != Nil).and.(xProdutos[na,3] != Nil)
		aCSim[nPosSim,GDFieldPos("MM_PRCSIM",aHdrSim)] := (xProdutos[na,2]*xProdutos[na,3])
	Endif                                      
	If (xProdutos[na,4] != Nil)
		aCSim[nPosSim,GDFieldPos("MM_PERDES",aHdrSim)] := xProdutos[na,4]
	Endif
	aCSim[nPosSim,Len(aHdrSim)+1] := .F.
	////////////////////////////////////////////////////////
Next na
BCCalcDet(@aCDet) //Calcula Valores
BCCalcSim(@aCSim,@aCDet,xTabela)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno definido no campo xRetCampo                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xRetCampo != Nil)
	nPos1 := aScan(aHdrSim,{|x| Alltrim(x[2])==xRetCampo }) 
	If (nPos1 > 0).and.(nPosSim > 0)
		nRetu := aCSim[nPosSim,nPos1]
	Else
		nPos1 := aScan(aHdrDet,{|x| Alltrim(x[2])==xRetCampo }) 
		If (nPos1 > 0).and.(nPosDet > 0)
			nRetu := aCDet[nPosDet,nPos1]
		Endif
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno planilhas calculadas                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xRetCSim != Nil)
	xRetCSim := {aClone(aHdrSim),aClone(aCSim)}
Endif
If (xRetCDet != Nil)
	xRetCDet := {aClone(aHdrDet),aClone(aCDet)}
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorno aCols, aHeader e N originais                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(aSegHdr)
aCols := aClone(aSegCol)
N := nSegN

Return nRetu

Static Function BCCalcDet(xCDet,xLinha)
************************************
LOCAL nx, nPosx := 0, nIni := 1, nFim := Len(xCDet), aCRes := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realizo Calculo dos Totais e Markups                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xLinha != Nil)
	nIni := xLinha
	nFim := xLinha
Endif
aHeader := aClone(aHdrDet)
For nx := nIni to nFim
	xCDet[nx,GDFieldPos("MM_PERFIX")] := xCDet[nx,GDFieldPos("MM_PERADM")]+xCDet[nx,GDFieldPos("MM_PERMKT")]+xCDet[nx,GDFieldPos("MM_PERFIN")]+xCDet[nx,GDFieldPos("MM_PERCOM")]
	xCDet[nx,GDFieldPos("MM_PRCLIQ")] := xCDet[nx,GDFieldPos("MM_CUSTFA")]/(1-(xCDet[nx,GDFieldPos("MM_PERFIX")]+xCDet[nx,GDFieldPos("MM_PERLUC")])/100)
	xCDet[nx,GDFieldPos("MM_VALLUC")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]*(xCDet[nx,GDFieldPos("MM_PERLUC")]/100)
	xCDet[nx,GDFieldPos("MM_VALADM")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]*(xCDet[nx,GDFieldPos("MM_PERADM")]/100)
	xCDet[nx,GDFieldPos("MM_VALMKT")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]*(xCDet[nx,GDFieldPos("MM_PERMKT")]/100)
	xCDet[nx,GDFieldPos("MM_VALFIN")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]*(xCDet[nx,GDFieldPos("MM_PERFIN")]/100)
	xCDet[nx,GDFieldPos("MM_VALCOM")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]*(xCDet[nx,GDFieldPos("MM_PERCOM")]/100)
	xCDet[nx,GDFieldPos("MM_VALFIX")] := xCDet[nx,GDFieldPos("MM_VALADM")]+xCDet[nx,GDFieldPos("MM_VALMKT")]+xCDet[nx,GDFieldPos("MM_VALFIN")]+xCDet[nx,GDFieldPos("MM_VALCOM")]
	xCDet[nx,GDFieldPos("MM_PRCVEN")] := xCDet[nx,GDFieldPos("MM_PRCLIQ")]/(1-(xCDet[nx,GDFieldPos("MM_PERCMS")]+xCDet[nx,GDFieldPos("MM_PERFRE")]+xCDet[nx,GDFieldPos("MM_PERCOF")]+xCDet[nx,GDFieldPos("MM_PERPIS")]+xCDet[nx,GDFieldPos("MM_PERICM")])/100)
	xCDet[nx,GDFieldPos("MM_VALCOF")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]*(xCDet[nx,GDFieldPos("MM_PERCOF")]/100)
	xCDet[nx,GDFieldPos("MM_VALPIS")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]*(xCDet[nx,GDFieldPos("MM_PERPIS")]/100)
	xCDet[nx,GDFieldPos("MM_VALICM")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]*(xCDet[nx,GDFieldPos("MM_PERICM")]/100)
	xCDet[nx,GDFieldPos("MM_IMPOST")] := xCDet[nx,GDFieldPos("MM_VALCOF")]+xCDet[nx,GDFieldPos("MM_VALPIS")]+xCDet[nx,GDFieldPos("MM_VALICM")]
	xCDet[nx,GDFieldPos("MM_VALCMS")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]*(xCDet[nx,GDFieldPos("MM_PERCMS")]/100)
	xCDet[nx,GDFieldPos("MM_VALFRE")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]*(xCDet[nx,GDFieldPos("MM_PERFRE")]/100)
	xCDet[nx,GDFieldPos("MM_DESPES")] := xCDet[nx,GDFieldPos("MM_VALCMS")]+xCDet[nx,GDFieldPos("MM_VALFRE")]
	xCDet[nx,GDFieldPos("MM_VALMAR")] := xCDet[nx,GDFieldPos("MM_PRCVEN")]-xCDet[nx,GDFieldPos("MM_CUSTFA")]-xCDet[nx,GDFieldPos("MM_IMPOST")]-xCDet[nx,GDFieldPos("MM_DESPES")]
	If (xCDet[nx,GDFieldPos("MM_PRCLIQ")] > 0)
		xCDet[nx,GDFieldPos("MM_PERMAR")] := (xCDet[nx,GDFieldPos("MM_VALMAR")]/xCDet[nx,GDFieldPos("MM_PRCLIQ")])*100
	Endif
Next nx   

Return                                   

Static Function BCCalcSim(xCSim,xCDet,xTabela,xLinha)
************************************************
LOCAL nx, nPPro := 0, nPTot := 0, nTotRol := 0, nPosx := 0, nIni := 1, nFim := Len(xCSim)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo da Simulacao Pedido de Venda                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xLinha != Nil)
	nIni := xLinha
	nFim := xLinha
Endif
aHeader := aClone(aHdrSim)
nPPro := GDFieldPos("MM_COD")
DA0->(dbSetOrder(1)) ; DA1->(dbSetOrder(1))
For nx := nIni to nFim
	DA0->(dbSeek(xFilial("DA0")+xTabela))
	If !Empty(xCSim[nx,nPPro]).and.DA1->(dbSeek(xFilial("DA1")+xTabela+xCSim[nx,nPPro]))
		xCSim[nx,GDFieldPos("MM_PRCTAB")] := DA1->DA1_prcven
		xCSim[nx,GDFieldPos("MM_PRCTOT")] := xCSim[nx,GDFieldPos("MM_QTDADE")]*xCSim[nx,GDFieldPos("MM_PRCTAB")]
		If Empty(xCSim[nx,GDFieldPos("MM_PRCSIM")])
			xCSim[nx,GDFieldPos("MM_PRCSIM")] := xCSim[nx,GDFieldPos("MM_PRCTOT")]
		Endif
		xCSim[nx,GDFieldPos("MM_PRCNOV")] := xCSim[nx,GDFieldPos("MM_PRCSIM")]-(xCSim[nx,GDFieldPos("MM_PRCSIM")]*(xCSim[nx,GDFieldPos("MM_PERDES")]/100))
		xCSim[nx,GDFieldPos("MM_VALLUC")] := 0 ; xCSim[nx,GDFieldPos("MM_PERLUC")] := 0
		nPosx := GDFieldPos("MM_COD",aHdrDet)
		If (nPosx > 0)
			nLin := aScan(xCDet,{|x| x[nPosx]==xCSim[nx,nPPro] }) 
			nValCms := xCSim[nx,GDFieldPos("MM_PRCNOV")]*(xCDet[nLin,GDFieldPos("MM_PERCMS",aHdrDet)]/100)
			nValFre := xCSim[nx,GDFieldPos("MM_PRCNOV")]*(xCDet[nLin,GDFieldPos("MM_PERFRE",aHdrDet)]/100)
			nValImp := xCSim[nx,GDFieldPos("MM_PRCNOV")]*((DA0->DA0_pericm+DA0->DA0_percof+DA0->DA0_perpis)/100)
			nValRol := xCSim[nx,GDFieldPos("MM_PRCNOV")]-nValCms-nValFre-nValImp
			nValDsp := nValRol*(xCDet[nLin,GDFieldPos("MM_PERFIX",aHdrDet)]/100)
			xCSim[nx,GDFieldPos("MM_VALLUC")]  := nValRol-nValDsp-(xCDet[nLin,GDFieldPos("MM_CUSTFA",aHdrDet)]*xCSim[nx,GDFieldPos("MM_QTDADE")])
			If (xCSim[nx,GDFieldPos("MM_PRCNOV")] != 0)
				xCSim[nx,GDFieldPos("MM_PERLUC")]  := (xCSim[nx,GDFieldPos("MM_VALLUC")]/xCSim[nx,GDFieldPos("MM_PRCNOV")])*100
			Endif                               
		Endif
	Endif
Next nx

Return

Static Function BCFormPrc(xProduto)
*******************************
LOCAL nPos1 := 0, nx
If !Empty(xProduto)
	dbSelectArea("SB1")
	SB1->(dbSeek(xFilial("SB1")+xProduto,.T.))
	Pergunte("MTC010",.F.) 
	nQc := nQualCusto
	aArray := MC010Forma("SB1",SB1->(Recno()),99,1)
	nQualCusto := nQc
	nMatPrima := aArray[3]
	aArray := aClone(aArray[2])
	If (Len(aArray) > 0)
		nUltNivel := CalcUltNiv()
		aArray := BCCalcTot(nMatPrima,nUltNivel,99)
	Endif
Endif
Return aArray
                                          
Static Function BCCalcTot(nMatPrima,nUltNivel,nOpcx)
***********************************************
LOCAL aTot[nUltNivel],nX,nY,cNivEstr,nCusto,aTamSX3:={},nQc:=nQualCusto
LOCAL aCampos:={"B1_CUSTD","B2_CM1","B2_CM2","B2_CM3","B2_CM4","B2_CM5","B1_UPRC","B1_CUSTD"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula Custos totalizando niveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFill(aTot,0)
cNivEstr := aArray[nMatPrima-2][2]
For nX := nMatPrima-2 To 1 Step -1
	If cNivEstr == aArray[nX][2]
		If nQc != 8
			nCusto := QualCusto(aArray[nX][4])
			aArray[nX][6] := aArray[nX][5] * nCusto
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Este vetor (aAuxCusto) deve ser declarado somente no MATR430 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOpcx==99
			aAuxCusto[nx] := aArray[nx][6]
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Arredonda de acordo com o custo selecionado:             ³
		//³ 1 = STANDARD  2 = MEDIO      3 = MOEDA2      4 = MOEDA3  ³
		//³ 5 = MOEDA4    6 = MOEDA5     7 = ULTPRECO    8 = PLANILHA³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aTamSX3:=TamSX3(aCampos[nQualCusto])
		If mv_par02 == 1
			aArray[nx][6]:=Round(aArray[nX][6],aTamSX3[2])
		Else
			aArray[nx][6]:=NoRound(aArray[nX][6],aTamSX3[2])
		EndIf
		For nY := 1 To Val(cNivEstr)
			aTot[nY] := aTot[nY] + aArray[nX][6]
		Next nY
	Else
		If Val(cNivEstr) > Val(aArray[nX][2])
			aArray[nX][6] := aTot[Val(cNivEstr)]
			For nY := Val(cNivEstr) To Len(aTot)
				aTot[nY] := 0
			Next nY
			cNivEstr := aArray[nX][2]
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Este vetor (aAuxCusto) deve ser declarado somente no MATR430 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nOpcx==99
				aAuxCusto[nx] := aArray[nx][6]
			EndIf
		Else
			cNivEstr := aArray[nX][2]
			For nY := Val(cNivEstr) To Len(aTot)
				aTot[nY] := 0
			Next nY
			If nQc != 8
				nCusto := QualCusto(aArray[nX][4])
				aArray[nX][6] := aArray[nX][5] * nCusto
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Este vetor (aAuxCusto) deve ser declarado somente no MATR430 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nOpcx==99
				aAuxCusto[nx] := aArray[nx][6]
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Arredonda de acordo com o custo selecionado:             ³
			//³ 1 = STANDARD  2 = MEDIO      3 = MOEDA2      4 = MOEDA3  ³
			//³ 5 = MOEDA4 	  6 = MOEDA5	 7 = ULTPRECO	 8 = PLANILHA³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aTamSX3:=TamSX3(aCampos[nQualCusto])
			If mv_par02 == 1
				aArray[nx][6]:=Round(aArray[nX][6],aTamSX3[2])
			Else
				aArray[nx][6]:=NoRound(aArray[nX][6],aTamSX3[2])
			EndIf
			For nY := 1 To Val(cNivEstr)
				aTot[nY] := aTot[nY] + aArray[nX][6]
			Next nY
		EndIf
	EndIf
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia para funcao que recalcula os totais da planilha    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RecalcTot(nMatPrima)

Return aArray