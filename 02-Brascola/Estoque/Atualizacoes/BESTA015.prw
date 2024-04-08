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
±±ºPrograma  ³ BESTA015 ºAutor  ³ Marcelo da Cunha   º Data ³  24/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Planilha para Simulacao de Pedido de Venda                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BESTA015()
*********************
PRIVATE oDlgPla, aHdrSim, oGetGer, oLbCust, oLbProd, oBold, oFolder
PRIVATE aCampos, aHdrSim, aHdrGer, aCols, aButtons, c015LbCust, c015LbProd
PRIVATE n015QualCusto := 1, c015Planilha := Space(15), n015LinDet := 0, c015Tab, c015Cod
PRIVATE a015TamCus := TamSx3("B1_CUSTD"), c015PicCus := PesqPict("SB1","B1_CUSTD")
PRIVATE aTitle, aPage, aCampos, nOpcm, cCadastro := "Planilha para Simulacao de Pedido de Venda"
PRIVATE oOk := LoadBitmap( GetResources(), "LBOK" ), oNo := LoadBitmap( GetResources(), "LBNO" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Custo a ser considerado nos calculos                           ³
//³ 1 = STANDARD    2 = MEDIO     3 = MOEDA2     4 = MOEDA3        ³
//³ 5 = MOEDA4      6 = MOEDA5    7 = ULTPRECO   8 = PLANILHA      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nQualCusto := 1, cProg := "C010", cArqMemo := "STANDARD"
PRIVATE lDirecao := .T., lConsNeg := .T., nQtdTotais := 0, nMatPrima := 0
PRIVATE aArray := {}, aAuxCusto := {}, aFormulas := {}, aTotais := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
                                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BRASCOLA - PE para gravar informacoes de acesso              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_BCFGA002("BESTA015") //Grava detalhes da rotina usada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Veifico se usuario possui acesso na rotina                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(Alltrim(cUserName) $ GetMV("BR_000026"))
	Help("",1,"BRASCOLA",,OemToAnsi("Usuario sem acesso na rotina (BR_000026)!"),1,0) 
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas pelo programa                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina := {{"","",0,1},{"","",0,2},{"","",0,3}}
aButtons:= {} ; INCLUI := .F. ; ALTERA := .F.
c015LbCust := "CUSTO: "
c015LbProd := "PRODUTO: "
c015Tab  := Space(3)
c015Cod  := Space(15)
aadd(aButtons,{"AUTOM"    ,{|| B015Param1(.T.) },"Parametr","Parametr"})
aadd(aButtons,{"AUTOM"    ,{|| B015Param2(.T.) },"Markup","Markup"})
aadd(aButtons,{"LEGENDA"  ,{|| B015Legenda() },"Legenda","Legenda"})
aadd(aButtons,{"GRAF3D"   ,{|| B015ConKardex(@oGetGer,@oGetGer:aCols,oGetGer:nAt) },"Kardex p/Dia","Kardex"})
aadd(aButtons,{"S4WB005N" ,{|| B015ConView(@oGetGer,@oGetGer:aCols,oGetGer:nAt) }  ,"Consulta Produto","Produto"})
aadd(aButtons,{"PMSEXCEL" ,{|| B015ExpExcel() },"Excel","Excel"})
aadd(aButtons,{"OPEN"     ,{|| B015Historico(@oGetGer,@oGetGer:aCols,oGetGer:nAt,1) },"Historico","Historico"})
If VerSenha(107) //Permite consulta a Formacao de Precos
	aadd(aButtons,{"BUDGET",{|| B015ConForma(@oGetGer,@oGetGer:aCols,oGetGer:nAt) },"Formacao de Precos","Formacao"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo parametros                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
B015Param1(.F.)
B015Param2(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atalhos para consulta                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 TO B015Estoque()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores com as opcoes dos Folders                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTitle := {"Simulador de Pedido Venda","Detalhamento Custos, Despesas e Markup"}
aPage  := {"Simulador de Pedido Venda","Detalhamento Custos, Despesas e Markup"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aHdrSim := {} ; aHdrGer := {}
//SIMULACAO PEDIDO DE VENDA///////////////////////////////////////
aadd(aHdrSim,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrSim,{"Descricao"  ,"MM_DESC"  ,"",30,5,"","","C","",""})
aadd(aHdrSim,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
aadd(aHdrSim,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrSim,{"Quantidade" ,"MM_QTDADE",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Tabela" ,"MM_PRCTAB",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Total " ,"MM_PRCTOT",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"Prc.Simula" ,"MM_PRCSIM",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"% Desconto" ,"MM_PERDES","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrSim,{"Novo Preco" ,"MM_PRCNOV",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"Lucro Liqu" ,"MM_VALLUC",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrSim,{"% Lucro Liq","MM_PERLUC","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrSim,{"Pedido/Item","MM_PEDIDO","",10,0,"","","C","",""})
aadd(aHdrSim,{"Tabela"     ,"MM_TABELA","",03,0,"","","C","",""})
//DETALHAMENTO CUSTOS,DEPESAS E MARKUP////////////////////////////
aadd(aHdrGer,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrGer,{"Descricao"  ,"MM_DESC"  ,"",30,5,"","","C","",""})
aadd(aHdrGer,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
aadd(aHdrGer,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrGer,{"Custo Rev"  ,"MM_CUSTRE",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Custo MP"   ,"MM_CUSTMP",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Custo MOD"  ,"MM_CUSTMO",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Custo Ben"  ,"MM_CUSTBE",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Custo Emb"  ,"MM_CUSTEM",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Custo Fab"  ,"MM_CUSTFA",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Desp Adm" ,"MM_PERADM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Desp Adm"   ,"MM_VALADM",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Desp Mkt" ,"MM_PERMKT","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Desp Mkt"   ,"MM_VALMKT",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Desp Fin" ,"MM_PERFIN","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Desp Fin"   ,"MM_VALFIN",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Desp Com" ,"MM_PERCOM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Desp Com"   ,"MM_VALCOM",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Desp Fixa","MM_PERFIX","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Desp Fixa"  ,"MM_VALFIX",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Lucro Bru","MM_PERLUC","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Lucro Brut" ,"MM_VALLUC",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Margem"   ,"MM_PERMAR","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Margem Con" ,"MM_VALMAR",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Cofins"   ,"MM_PERCOF","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Confins"    ,"MM_VALCOF",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% PIS"      ,"MM_PERPIS","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"PIS"        ,"MM_VALPIS",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% ICMS"     ,"MM_PERICM","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"ICMS"       ,"MM_VALICM",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Impostos"   ,"MM_IMPOST",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Prc Liquid" ,"MM_PRCLIQ",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Comissao" ,"MM_PERCMS","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Comissao"   ,"MM_VALCMS",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"% Frete"    ,"MM_PERFRE","@E 999.9999",08,4,"","","N","",""})
aadd(aHdrGer,{"Frete"      ,"MM_VALFRE",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Despesas"   ,"MM_DESPES",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aadd(aHdrGer,{"Preco Venda","MM_PRCVEN",c015PicCus,a015TamCus[1],a015TamCus[2],"","","N","",""})
aCampos := {"MM_PERADM","MM_PERMKT","MM_PERFIN","MM_PERCOM","MM_PERLUC","MM_PERCOF","MM_PERPIS","MM_PERICM","MM_PERCMS","MM_PERFRE"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Consulta                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0, 180, .T., .T. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)        
DEFINE MSDIALOG oDlgPla FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] SAY "PLANILHA PARA SIMULACAO PEDIDO DE VENDA: "+dtoc(dDataBase) OF oDlgPla PIXEL SIZE 245,9 FONT oBold
@ aPosObj[1,1],aPosObj[1,2]+200 SAY oLbCust VAR c015LbCust OF oDlgPla PIXEL SIZE 100,9 COLOR CLR_GREEN FONT oBold
@ aPosObj[1,1],aPosObj[1,2]+280 SAY oLbProd VAR c015LbProd OF oDlgPla PIXEL SIZE 200,9 COLOR CLR_GREEN FONT oBold
@ aPosObj[1,1]+14,aPosObj[1,2] TO aPosObj[1,1]+15,(aPosObj[1,4]-aPosObj[1,2]) LABEL "" OF oDlgPla PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder Simulacao Pedido Venda                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitle,aPage,oDlgPla,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1],)
If !(Alltrim(cUserName) $ GetMV("BR_000027")) //Usuarios com acesso a pasta de detalhamento
	oFolder:aDialogs[2]:Disable()
Endif
aCols := {} ; B015ZeraCols(@aHdrSim,@aCols)
oSaySim1:= B015Say(oFolder:aDialogs[1],"oSaySim1","Tabela:",010,012)
oGetSim1:= B015Get(oFolder:aDialogs[1],"c015Tab","c015Tab",055,010,60,,{|| ExistCpo("DA0") },,"DA0")
oSaySim2:= B015Say(oFolder:aDialogs[1],"oSaySim2","Codigo:",145,012)
oGetSim2:= B015Get(oFolder:aDialogs[1],"c015Cod","c015Cod",190,010,120,,{|| .T. },,"SB1")
oButSim3:= B015Button(oFolder:aDialogs[1],"oButSim3","Adicionar",330,010,,,{|| Processa({||B015Adicionar()}) })
oButSim4:= B015Button(oFolder:aDialogs[1],"oButSim4","Limpar",410,010,,,{|| B015Limpar() })
oButSim5:= B015Button(oFolder:aDialogs[1],"oButSim5","Pedido",490,010,,,{|| B015Pedido() })
oButSim6:= B015Button(oFolder:aDialogs[1],"oButSim6","Abrir PV",570,010,,,{|| B015AbrirPv() })
oButSim7:= B015Button(oFolder:aDialogs[1],"oButSim7","Faturamento",650,010,,,{|| B015Faturam() })
oButSim8:= B015Button(oFolder:aDialogs[1],"oButSim8","Produto",730,010,,,{|| B015Produto() })
oGetSim := MsNewGetDados():New(020,000,(oFolder:aDialogs[1]:nClientHeight/2),(oFolder:aDialogs[1]:nClientWidth/2),GD_UPDATE,"AllwaysTrue","AllwaysTrue",,{"MM_QTDADE","MM_PRCSIM","MM_PERDES"},,,"u_B015ValCam(1)",,,oFolder:aDialogs[1],aHdrSim,aCols)
oGetSim:oBrowse:bChange := {|| B015AtuDados() }
oGetSim:oBrowse:lUseDefaultColors := .F.
oGetSim:oBrowse:SetBlkBackColor({||B015CorSim(oGetSim:aHeader,oGetSim:aCols,oGetSim:nAt)})
aCols := {} ; B015ZeraCols(@aHdrGer,@aCols)
oGetGer := MsNewGetDados():New(000,000,(oFolder:aDialogs[2]:nClientHeight/2),(oFolder:aDialogs[2]:nClientWidth/2),GD_UPDATE,"AllwaysTrue","AllwaysTrue",,aCampos,,,"u_B015ValCam(2)",,,oFolder:aDialogs[2],aHdrGer,aCols)
oGetGer:oBrowse:bChange := {|| (n015LinDet:=oGetGer:nAt,oGetGer:oBrowse:Refresh()) }
oGetGer:oBrowse:lUseDefaultColors := .F.
oGetGer:oBrowse:SetBlkBackColor({|| B015CorDet(oGetGer:aHeader,oGetGer:aCols,oGetGer:nAt) })

ACTIVATE MSDIALOG oDlgPla ON INIT EnchoiceBar(oDlgPla,{|| iif(B015Valid(),(nOpcm:=1,oDlgPla:End()),.F.) },{|| iif(B015Valid(),oDlgPla:End(),.F.) },,aButtons)

Return

User Function B015ValCam(xTipo)
****************************
LOCAL lRetu := .T., lAtuPrc := .F., aCols1
LOCAL nPos1, cCampo := Alltrim(Upper(ReadVar()))
If (cCampo == "M->MM_PERDES").and.(M->MM_PERDES > 100)
	Help("",1,"BRASCOLA",,OemToAnsi("% Desconto maximo é de 100%!"),1,0) 
	Return (lRetu := .F.)
Endif
If (xTipo == 1) //Simulacao
	nPos1 := GDFieldPos(Substr(cCampo,4),oGetSim:aHeader)
	If (oGetSim:nAt > 0).and.(nPos1 > 0)
		oGetSim:aCols[oGetSim:nAt,nPos1] := &(cCampo)
		aCols := aClone(oGetSim:aCols)
		B015CalcSim(@aCols,oGetSim:nAt,(cCampo=="M->MM_QTDADE")) //Calcula Valores
		oGetSim:aCols := aClone(aCols)
		oGetSim:oBrowse:Refresh()
	Endif
Elseif (xTipo == 2) //Detalhamento
	nPos1 := GDFieldPos(Substr(cCampo,4),oGetGer:aHeader)
	If (oGetGer:nAt > 0).and.(nPos1 > 0)
		oGetGer:aCols[oGetGer:nAt,nPos1] := &(cCampo)
		aCols := aClone(oGetGer:aCols)
		B015Calcula(@aCols,oGetGer:nAt) //Calcula Valores
		oGetGer:aCols := aClone(aCols)
		oGetGer:oBrowse:Refresh()
	Endif	
Endif
Return lRetu

Static Function B015Valid()
************************
LOCAL lRetu1 := .T.
Return lRetu1                           

Static Function B015Param1(xMostra)
*******************************
LOCAL aRegs := {}, cPerg := "BESTA0151", cArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","Usar Custo Produto  ?","mv_ch1","N",01,0,1,"C","","MV_PAR01","Standard","","","Medio","","","Ult.Preco","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Planilha de Custo   ?","mv_ch2","C",15,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs) //Brascola
If (xMostra)
	If Pergunte(cPerg,.T.)
		n015QualCusto := mv_par01
		If (n015QualCusto == 1) //Standard
			nQualCusto := 1
		Elseif (n015QualCusto == 2) //Medio
			nQualCusto := 2
		Elseif (n015QualCusto == 3) //Ultimo Preco
			nQualCusto := 7
		Endif
		If Empty(mv_par02)
			mv_par02 := GetMV("BR_000028") //Planilha Padrao
		Endif
		c015Planilha  := FileNoExt(Alltrim(mv_par02))
		cArqMemo := "STANDARD"		
		If !Empty(c015Planilha)
			cArq := c015Planilha+".PDV"
			If !File(cArq)
				Help("",1,"BRASCOLA",,OemToAnsi("Planilha "+c015Planilha+" nao encontrada! Favor verificar."),1,0) 
				c015Planilha := Space(15)
			Else
				cArqMemo := c015Planilha
			Endif
		Endif
	Endif
Else
	Pergunte(cPerg,.F.)
	n015QualCusto := mv_par01
	If (n015QualCusto == 1) //Standard
		nQualCusto := 1
	Elseif (n015QualCusto == 2) //Medio
		nQualCusto := 2
	Elseif (n015QualCusto == 3) //Ultimo Preco
		nQualCusto := 7
	Endif
	If Empty(mv_par02)
		mv_par02 := GetMV("BR_000028") //Planilha Padrao
	Endif
	c015Planilha  := FileNoExt(Alltrim(mv_par02))
	cArqMemo := "STANDARD"		
	If !Empty(c015Planilha)
		cArq := c015Planilha+".PDV"
		If !File(cArq)
			Help("",1,"BRASCOLA",,OemToAnsi("Planilha "+c015Planilha+" nao encontrada! Favor verificar."),1,0) 
			c015Planilha := Space(15)
		Else
			cArqMemo := c015Planilha
		Endif
	Endif
Endif

Return

Static Function B015Param2(xMostra)
*******************************
LOCAL aRegs := {}, cPerg := "BESTA0152", cArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","% Despesa Adm  ?" ,"mv_ch1","N",08,4,1,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","% Despesa Mkt  ?" ,"mv_ch2","N",08,4,1,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","% Despesa Fin  ?" ,"mv_ch3","N",08,4,1,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","% Despesa Com  ?" ,"mv_ch4","N",08,4,1,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","% Lucro        ?" ,"mv_ch5","N",08,4,1,"G","","MV_PAR05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","% Cofins       ?" ,"mv_ch6","N",08,4,1,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","% PIS          ?" ,"mv_ch7","N",08,4,1,"G","","MV_PAR07","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","% ICMS         ?" ,"mv_ch8","N",08,4,1,"G","","MV_PAR08","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","% Comissao     ?" ,"mv_ch9","N",08,4,1,"G","","MV_PAR09","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","% Frete        ?" ,"mv_chA","N",08,4,1,"G","","MV_PAR10","","","","","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs) //Brascola
If (xMostra)
	If Pergunte(cPerg,.T.)
		aHeader := aClone(oGetGer:aHeader)
		For nx := 1 to Len(oGetGer:aCols)-1             
			oGetGer:aCols[nx,GDFieldPos("MM_PERADM")] := mv_par01
			oGetGer:aCols[nx,GDFieldPos("MM_PERMKT")] := mv_par02
			oGetGer:aCols[nx,GDFieldPos("MM_PERFIN")] := mv_par03
			oGetGer:aCols[nx,GDFieldPos("MM_PERCOM")] := mv_par04
			oGetGer:aCols[nx,GDFieldPos("MM_PERLUC")] := mv_par05
			oGetGer:aCols[nx,GDFieldPos("MM_PERCOF")] := mv_par06
			oGetGer:aCols[nx,GDFieldPos("MM_PERPIS")] := mv_par07
			oGetGer:aCols[nx,GDFieldPos("MM_PERICM")] := mv_par08
			oGetGer:aCols[nx,GDFieldPos("MM_PERCMS")] := mv_par09
			oGetGer:aCols[nx,GDFieldPos("MM_PERFRE")] := mv_par10
		Next nx
		aCols := aClone(oGetGer:aCols)
		B015Calcula(@aCols) //Calcula Valores
		oGetGer:aCols := aClone(aCols)
		oGetGer:oBrowse:Refresh()
	Endif
Else
	Pergunte(cPerg,.F.)
Endif

Return


Static Function B015Adicionar(xQtdVen,xPrcVen,xDescon,xPedido,xItem)
*************************************************************
LOCAL cQuery1:="", cPesq1:="", aPlanilha := {}, nPos1, nPos2, nPosDet, nPosSim, aCSim, aCDet, lAtuPrc

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico valido informacoes                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(c015Tab)
	If (xPedido != Nil)
		Help("",1,"BRASCOLA",,OemToAnsi("Tabela de preco "+c015Tab+" do pedido "+xPedido+" nao foi informada!"),1,0) 
	Else
		Help("",1,"BRASCOLA",,OemToAnsi("Tabela de preco "+c015Tab+" nao foi informada!"),1,0) 
	Endif
	Return
Elseif Empty(c015Cod)
	Help("",1,"BRASCOLA",,OemToAnsi("Informar o codigo do produto!"),1,0) 
	Return
Elseif !ExistCpo("DA0",c015Tab)
	MsgInfo("Tabela de Preco: "+c015Tab)
	Return
Elseif !ExistCpo("SB1",c015Cod)
	MsgInfo("Produto: "+c015Cod)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionar na planilha custo detalhado                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosDet := 0
aPlanilha := B015FormPrc(SB1->B1_cod)
aCDet := aClone(oGetGer:aCols)
If (Len(aCDet) > 0)
	aDel(aCDet,Len(aCDet))
	aSize(aCDet,Len(aCDet)-1)
Endif
aHeader := aClone(oGetGer:aHeader)
If ((nPosDet := aScan(aCDet,{|x| x[GDFieldPos("MM_COD")] == c015Cod })) == 0)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+c015Cod))
		aPlanilha := B015FormPrc(SB1->B1_cod)
	Endif
	If SB1->(dbSeek(xFilial("SB1")+c015Cod)).and.(Len(aPlanilha) > 0)
		Incproc("> "+SB1->B1_cod)
		aadd(aCDet,Array(Len(oGetGer:aHeader)+1))
		nPosDet := Len(aCDet)
		aFill(aCDet[nPosDet],0)
		aHeader := aClone(oGetGer:aHeader)
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
		aCDet[nPosDet,Len(oGetGer:aHeader)+1]  := .F.
	Endif
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Totalizador Planilha                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aCDet) > 0).and.(aCDet[Len(aCDet),GDFieldPos("MM_DESC",oGetGer:aHeader)] != "> TOTAL >")
	aadd(aCDet,Array(Len(oGetGer:aHeader)+1))
	nPos1 := Len(aCDet)
	aFill(aCDet[nPos1],0)
	aCDet[nPos1,GDFieldPos("MM_COD",oGetGer:aHeader)]    := ""
	aCDet[nPos1,GDFieldPos("MM_DESC",oGetGer:aHeader)]   := "> TOTAL >"
	aCDet[nPos1,GDFieldPos("MM_UM",oGetGer:aHeader)]     := ""
	aCDet[nPos1,GDFieldPos("MM_TIPO",oGetGer:aHeader)]   := ""
	aCDet[nPos1,Len(oGetGer:aHeader)+1] := .F.
Endif
If (xPedido == Nil)
	B015Calcula(@aCDet) //Calcula Valores
Endif
oGetGer:aCols := aClone(aCDet)
If (xPedido == Nil)
	oGetGer:oBrowse:Refresh()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adicionar na Planilha Simulacao                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lAtuPrc := .T.
aCSim := aClone(oGetSim:aCols)
If (Len(aCSim) > 0)
	aDel(aCSim,Len(aCSim))
	aSize(aCSim,Len(aCSim)-1)
Endif
aadd(aCSim,Array(Len(oGetSim:aHeader)+1))
nPosSim := Len(aCSim)
aFill(aCSim[nPosSim],0)
aCSim[nPosSim,GDFieldPos("MM_COD",oGetSim:aHeader)]    := aCDet[nPosDet,GDFieldPos("MM_COD",oGetGer:aHeader)]
aCSim[nPosSim,GDFieldPos("MM_DESC",oGetSim:aHeader)]   := aCDet[nPosDet,GDFieldPos("MM_DESC",oGetGer:aHeader)]
aCSim[nPosSim,GDFieldPos("MM_UM",oGetSim:aHeader)]     := aCDet[nPosDet,GDFieldPos("MM_UM",oGetGer:aHeader)]
aCSim[nPosSim,GDFieldPos("MM_TIPO",oGetSim:aHeader)]   := aCDet[nPosDet,GDFieldPos("MM_TIPO",oGetGer:aHeader)]
aCSim[nPosSim,GDFieldPos("MM_PEDIDO",oGetSim:aHeader)] := "" //Pedido
aCSim[nPosSim,GDFieldPos("MM_TABELA",oGetSim:aHeader)] := c015Tab //Tabela
aCSim[nPosSim,GDFieldPos("MM_QTDADE",oGetSim:aHeader)] := iif(xQtdVen!=Nil,xQtdVen,1) //Quantidade
If (xQtdVen != Nil).and.(xPrcVen != Nil)
	aCSim[nPosSim,GDFieldPos("MM_PRCSIM",oGetSim:aHeader)] := (xQtdVen*xPrcVen)
	lAtuPrc := .F.
Endif                                      
If (xDescon != Nil)
	aCSim[nPosSim,GDFieldPos("MM_PERDES",oGetSim:aHeader)] := xDescon	
Endif
If (xPedido != Nil).and.(xItem != Nil)
	aCSim[nPosSim,GDFieldPos("MM_PEDIDO",oGetSim:aHeader)] := xPedido+"/"+xItem
Endif
aCSim[nPosSim,Len(oGetSim:aHeader)+1] := .F.
If (Len(aCSim) > 0).and.(aCSim[Len(aCSim),GDFieldPos("MM_DESC",oGetSim:aHeader)] != "> TOTAL >")
	aadd(aCSim,Array(Len(oGetSim:aHeader)+1))
	nPos1 := Len(aCSim)
	aFill(aCSim[nPos1],0)
	aCSim[nPos1,GDFieldPos("MM_COD",oGetSim:aHeader)]    := ""
	aCSim[nPos1,GDFieldPos("MM_DESC",oGetSim:aHeader)]   := "> TOTAL >"
	aCSim[nPos1,GDFieldPos("MM_UM",oGetSim:aHeader)]     := ""
	aCSim[nPos1,GDFieldPos("MM_TIPO",oGetSim:aHeader)]   := ""
	aCSim[nPos1,GDFieldPos("MM_PEDIDO",oGetSim:aHeader)] := "" //Pedido
	aCSim[nPos1,GDFieldPos("MM_TABELA",oGetSim:aHeader)] := "" //Tabela
	aCSim[nPos1,Len(oGetSim:aHeader)+1] := .F.
Endif
If (xPedido == Nil)
	B015CalcSim(@aCSim,,lAtuPrc)
Endif
oGetSim:aCols := aClone(aCSim)
If (xPedido == Nil)
	oGetSim:oBrowse:Refresh()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizar Cabecalho da Rotina                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xPedido == Nil)
	If (n015QualCusto == 1) //Standard
		c015LbCust := "CUSTO: STANDARD"
	Elseif (n015QualCusto == 2) //Medio
		c015LbCust := "CUSTO: MEDIO"
	Elseif (n015QualCusto == 3) //Ultimo Preco
		c015LbCust := "CUSTO: ULTIMO PRECO"
	Endif
	oLbCust:cCaption := c015LbCust
	oLbCust:Refresh()
	B015AtuDados() //Atualiza Dados
Endif

Return               
                                           
Static Function B015AtuDados()
***************************
LOCAL nPos1
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetSim != Nil).and.(Len(oGetSim:aCols) > 0).and.(oGetSim:nAt > 0)
	nPos1 := GDFieldPos("MM_COD",oGetSim:aHeader)
	c015LbProd := "PRODUTO: "
	If (nPos1 > 0).and.!Empty(oGetSim:aCols[oGetSim:nAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+oGetSim:aCols[oGetSim:nAt,nPos1]))
			c015LbProd := "PRODUTO: "+Alltrim(SB1->B1_cod)+" - "+Alltrim(SB1->B1_desc)
		Endif
	Endif
	oLbProd:cCaption := c015LbProd
	oLbProd:Refresh()
Endif

Return

Static Function B015Limpar()
*************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Limpar Browse                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {} ; B015ZeraCols(@oGetSim:aHeader,@aCols)
oGetSim:aCols := aClone(aCols)
oGetSim:oBrowse:Refresh()
aCols := {} ; B015ZeraCols(@oGetGer:aHeader,@aCols)
oGetGer:aCols := aClone(aCols)
oGetGer:oBrowse:Refresh()

Return

Static Function B015Pedido()
************************* 
LOCAL lRetu, nx, aCDet1, aCSim1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Limpar Browse                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lRetu := ConPad1(NIL,NIL,NIL,"SC5",NIL,NIL,.F.)
If (lRetu)
	B015Limpar()
	If !Empty(SC5->C5_tabela)
		c015Tab := SC5->C5_tabela
	Endif
	If Empty(c015Tab)
		Help("",1,"BRASCOLA",,OemToAnsi("Tabela de preco nao foi informada!"),1,0) 
		Return
	Endif	
	SC6->(dbSetOrder(1))
	SC6->(dbSeek(xFilial("SC6")+SC5->C5_num,.T.))
	While !SC6->(Eof()).and.(xFilial("SC6") == SC6->C6_filial).and.(SC6->C6_num == SC5->C5_num)
	   c015Cod := SC6->C6_produto
	   B015Adicionar(SC6->C6_qtdven,SC6->C6_prunit,SC6->C6_descont,SC6->C6_num,SC6->C6_item)
		SC6->(dbSkip())
	Enddo
	aCDet1 := aClone(oGetGer:aCols)
	B015Calcula(@aCDet1) //Calcula Valores
	oGetGer:aCols := aClone(aCDet1)
	oGetGer:oBrowse:Refresh()
	aCSim1 := aClone(oGetSim:aCols)
	B015CalcSim(@aCSim1,,.T.)
	oGetSim:aCols := aClone(aCSim1)
	oGetSim:oBrowse:Refresh()
Endif

Return
                                                                               
Static Function B015AbrirPv()
**************************
LOCAL nPos1, cPedido
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetSim != Nil).and.(Len(oGetSim:aCols) > 0).and.(oGetSim:nAt > 0)
	cPedido := Substr(oGetSim:aCols[oGetSim:nAt,GDFieldPos("MM_PEDIDO",oGetSim:aHeader)],1,6)
	If !Empty(cPedido)
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+cPedido))
			INCLUI := .F. ; ALTERA := .F.
			A410Visual("SC5",SC5->(Recno()),2)
		Endif
	Endif
Endif

Return

Static Function B015Faturamento()
************************* ****
LOCAL lRetu, nx, aRegs := {}, cPerg := "BESTA0153", cQuery := "", aCDet1, aCSim1
LOCAL cBrCfFat := u_BXLstCfTes("BR_CFFAT"), cBrCfNFat := u_BXLstCfTes("BR_CFNFAT")
LOCAL cBrTsFat := u_BXLstCfTes("BR_TSFAT"), cBrTsNFat := u_BXLstCfTes("BR_TSNFAT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","Periodo De    ?" ,"mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Periodo Ate   ?" ,"mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cliente De    ?" ,"mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"04","Cliente Ate   ?" ,"mv_ch4","C",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"05","Produto De    ?" ,"mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"06","Produto Ate   ?" ,"mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"07","Grupo De      ?" ,"mv_ch7","C",04,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"08","Grupo Ate     ?" ,"mv_ch8","C",04,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"09","Vendedor De   ?" ,"mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"10","Vendedor Ate  ?" ,"mv_chA","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"11","Grp.Clien De  ?" ,"mv_chB","C",06,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","ACY"})
AADD(aRegs,{cPerg,"12","Grp.Clien Ate ?" ,"mv_chC","C",06,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","ACY"})
AADD(aRegs,{cPerg,"13","Tab.Preco De  ?" ,"mv_chD","C",03,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","DA0"})
AADD(aRegs,{cPerg,"14","Tab.Preco Ate ?" ,"mv_chE","C",03,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","DA0"})
u_BXCriaPer(cPerg,aRegs) //Brascola
If Pergunte(cPerg,.T.).and.!Empty(mv_par01).and.!Empty(mv_par02)
	B015Limpar() //Limpar Dados

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monto Query para buscar dados de Faturamento   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	//27/08/13: Fernando (incluido D2_ITEMPV no select)
	cQuery := "SELECT D2_COD, D2_PEDIDO,D2_ITEMPV,SUM(D2_QUANT) D2_QUANT,SUM(D2_QUANT*D2_PRUNIT) D2_PRUNIT,SUM(D2_QUANT*D2_PRCVEN) D2_PRCVEN "
	cQuery += "FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF2")+" F2,"+RetSqlName("SF4")+" F4,"+RetSqlName("SA1")+" A1,"+RetSqlName("SC5")+" C5 "
	cQuery += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"' AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+xFilial("SF2")+"' "
	cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cQuery += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+xFilial("SC5")+"' AND D2.D2_PEDIDO = C5.C5_NUM "
	cQuery += "AND D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA "
	cQuery += "AND D2.D2_TES = F4.F4_CODIGO AND F4.F4_DUPLIC = 'S' AND D2.D2_TIPO = 'N' AND D2_CLIENTE = A1_COD AND D2_LOJA = A1_LOJA "
	If !Empty(cBrCfFat)
		cQuery += "AND D2.D2_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery += "AND D2.D2_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
	Endif	
	cQuery += "AND D2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
	If !Empty(mv_par03)
		cQuery += "AND D2.D2_CLIENTE >= '"+mv_par03+"' "
	Endif
	If !Empty(mv_par04)
		cQuery += "AND D2.D2_CLIENTE <= '"+mv_par04+"' "
	Endif
	If !Empty(mv_par05)
		cQuery += "AND D2.D2_COD >= '"+mv_par05+"' "
	Endif
	If !Empty(mv_par06)
		cQuery += "AND D2.D2_COD <= '"+mv_par06+"' "
	Endif
	If !Empty(mv_par07)
		cQuery += "AND D2.D2_GRUPO >= '"+mv_par07+"' "
	Endif
	If !Empty(mv_par08)
		cQuery += "AND D2.D2_GRUPO <= '"+mv_par08+"' "
	Endif
	If !Empty(mv_par09)
		cQuery += "AND F2.F2_VEND1 >= '"+mv_par09+"' "
	Endif
	If !Empty(mv_par10)
		cQuery += "AND F2.F2_VEND1 <= '"+mv_par10+"' "
	Endif
	If !Empty(mv_par11)
		cQuery += "AND A1.A1_GRPVEN >= '"+mv_par11+"' "
	Endif
	If !Empty(mv_par12)
		cQuery += "AND A1.A1_GRPVEN <= '"+mv_par12+"' "
	Endif
	If !Empty(mv_par13)
		cQuery += "AND C5.C5_TABELA >= '"+mv_par13+"' "
	Endif
	If !Empty(mv_par14)
		cQuery += "AND C5.C5_TABELA <= '"+mv_par14+"' "
	Endif
	cQuery += "GROUP BY D2_COD,D2_PEDIDO,D2_ITEMPV "
	cQuery += "ORDER BY D2_COD,D2_PEDIDO,D2_ITEMPV "	
	If (Select("MSD2") <> 0)
		dbSelectArea("MSD2")
		dbCloseArea()
	Endif                          
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery NEW ALIAS "MSD2"
	SC5->(dbSetOrder(1))
	dbSelectArea("MSD2")
	While !MSD2->(Eof())
	   SC5->(dbSeek(xFilial("SC5")+MSD2->D2_pedido,.T.))
	   SC6->(dbSeek(xFilial("SC6")+MSD2->D2_pedido+MSD2->D2_itempv,.T.))
	   c015Tab := SC5->C5_tabela
	   c015Cod := MSD2->D2_cod                           
	   nPreco := 0
	   If (MSD2->D2_quant > 0)
	  	   nPreco := MSD2->D2_prunit/MSD2->D2_quant
	  	Endif                                    
	  	nDesco := 0                               
	  	If (MSD2->D2_prunit > 0).and.(MSD2->D2_prunit != MSD2->D2_prcven)
	  		nDesco := (1-(MSD2->D2_prcven/MSD2->D2_prunit))*100
	  	Else
		  	nDesco := SC6->C6_descont
	  	Endif
	   B015Adicionar(MSD2->D2_quant,nPreco,nDesco,MSD2->D2_pedido,MSD2->D2_itempv)
		MSD2->(dbSkip())
	Enddo         
	aCDet1 := aClone(oGetGer:aCols)
	B015Calcula(@aCDet1) //Calcula Valores
	oGetGer:aCols := aClone(aCDet1)
	oGetGer:oBrowse:Refresh()
	aCSim1 := aClone(oGetSim:aCols)
	B015CalcSim(@aCSim1,,.T.)
	oGetSim:aCols := aClone(aCSim1)
	oGetSim:oBrowse:Refresh()
Endif
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif                          

Return

Static Function B015Produto()
*************************
LOCAL lRetu, nx, oDlgFil, aRegs := {}, cPerg := "BESTA0154"
LOCAL cQuery := "", aCDet1, aCSim1, nQuant1, aLista1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se a tabela de preco foi preenchida                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(c015Tab)
	Help("",1,"BRASCOLA",,OemToAnsi("Preencher a tabela de preço antes de continuar!"),1,0) 
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","Quantidade  ?" ,"mv_ch1","N",11,2,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Produto De  ?" ,"mv_ch2","C",15,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"03","Produto Ate ?" ,"mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"04","Grupo De    ?" ,"mv_ch4","C",04,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"05","Grupo Ate   ?" ,"mv_ch5","C",04,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"06","Tipo De     ?" ,"mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","02"})
AADD(aRegs,{cPerg,"07","Tipo Ate    ?" ,"mv_ch7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","02"})
u_BXCriaPer(cPerg,aRegs) //Brascola
If Pergunte(cPerg,.T.).and.(mv_par01 > 0)
	B015Limpar() //Limpar Dados

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monto Query para buscar dados de Produtos      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	cQuery := "SELECT B1_COD,B1_DESC,B1_GRUPO,B1_TIPO FROM "+RetSqlName("SB1")+" B1 "
	cQuery += "WHERE B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND B1.B1_MSBLQL <> '1' "
	If !Empty(mv_par02)
		cQuery += "AND B1.B1_COD >= '"+mv_par02+"' "
	Endif
	If !Empty(mv_par03)
		cQuery += "AND B1.B1_COD <= '"+mv_par03+"' "
	Endif
	If !Empty(mv_par04)
		cQuery += "AND B1.B1_GRUPO >= '"+mv_par04+"' "
	Endif
	If !Empty(mv_par05)
		cQuery += "AND B1.B1_GRUPO <= '"+mv_par05+"' "
	Endif
	If !Empty(mv_par06)
		cQuery += "AND B1.B1_TIPO >= '"+mv_par06+"' "
	Endif
	If !Empty(mv_par07)
		cQuery += "AND B1.B1_TIPO <= '"+mv_par07+"' "
	Endif
	cQuery += "ORDER BY B1_COD "	
	If (Select("MSB1") <> 0)
		dbSelectArea("MSB1")
		dbCloseArea()
	Endif                          
	cQuery := ChangeQuery(cQuery)
	TCQuery cQuery NEW ALIAS "MSB1"
	nQuant1 := mv_par01
	aLista1 := {}
	dbSelectArea("MSB1")
	While !MSB1->(Eof())
		aadd(aLista1,{oOk,MSB1->B1_cod,MSB1->B1_desc,MSB1->B1_grupo,MSB1->B1_tipo})
		MSB1->(dbSkip())
	Enddo         
	If (Len(aLista1) > 0)
		nOpcx := 0
		bTroca := {|| aLista1[oListBox:nAt,1] := iif(aLista1[oListBox:nAt,1]==oNo,oOk,oNo) }
		DEFINE MSDIALOG oDlgFil TITLE OemToAnsi("Selecao de Produtos") FROM 0,0 TO 400,600 OF oMainWnd PIXEL
		@ 005,005 LISTBOX oListBox VAR cVarQ FIELDS HEADER Space(2),"Produto","Descricao","Grupo","Tipo" SIZE 292,160 ON DBLCLICK Eval(bTroca) NOSCROLL PIXEL
		oListBox:SetArray(aLista1)
		oListBox:bLine:={ || {aLista1[oListBox:nAt,1],aLista1[oListBox:nAt,2],aLista1[oListBox:nAt,3],aLista1[oListBox:nAt,4],aLista1[oListBox:nAt,5]}}
		@ 175,010 BUTTON "Confirma" ACTION (nOpcx:=1,oDlgFil:End()) SIZE 060,012 PIXEL
		@ 175,070 BUTTON "Cancela" ACTION (nOpcx:=0,oDlgFil:End()) SIZE 060,012 PIXEL
		@ 175,130 BUTTON "Marcar Todas" ACTION aEval(aLista1,{|x| x[1]:=oOk }) SIZE 060,012 PIXEL
		@ 175,190 BUTTON "Desmarcar Todas" ACTION aEval(aLista1,{|x| x[1]:=oNo }) SIZE 060,012 PIXEL
		ACTIVATE MSDIALOG oDlgFil CENTERED
		If (nOpcx == 1)
			For nx := 1 to Len(aLista1)
				If (aLista1[nx,1] == oOk)
				   c015Cod := aLista1[nx,2]
				   B015Adicionar(nQuant1,NIL,NIL,NIL,NIL)
				Endif
			Next nx
			aCDet1 := aClone(oGetGer:aCols)
			B015Calcula(@aCDet1) //Calcula Valores
			oGetGer:aCols := aClone(aCDet1)
			oGetGer:oBrowse:Refresh()
			aCSim1 := aClone(oGetSim:aCols)
			B015CalcSim(@aCSim1,,.T.)
			oGetSim:aCols := aClone(aCSim1)
			oGetSim:oBrowse:Refresh()
		Endif
	Endif
Endif
If (Select("MSB1") <> 0)
	dbSelectArea("MSB1")
	dbCloseArea()
Endif                          

Return

Static Function B015Calcula(xCols,xLinha)
*************************************
LOCAL nx, nPos1 := 0, nIni := 1, nFim := Len(xCols)-1, aCRes := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realizo Calculo dos Totais e Markups                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xLinha != Nil)
	nIni := xLinha
	nFim := xLinha
Endif
aHeader := aClone(oGetGer:aHeader)
For nx := nIni to nFim
	B015CalcMark(@xCols,nx)
Next nx   
nPos1 := Len(xCols)
If (nPos1 > 0).and.Empty(xCols[nPos1,1])
	xCols[nPos1,GDFieldPos("MM_CUSTRE")] := 0 ; xCols[nPos1,GDFieldPos("MM_CUSTMP")] := 0
	xCols[nPos1,GDFieldPos("MM_CUSTMO")] := 0 ; xCols[nPos1,GDFieldPos("MM_CUSTBE")] := 0
	xCols[nPos1,GDFieldPos("MM_CUSTEM")] := 0 ; xCols[nPos1,GDFieldPos("MM_CUSTFA")] := 0
	xCols[nPos1,GDFieldPos("MM_PERADM")] := 0 ; xCols[nPos1,GDFieldPos("MM_PERMKT")] := 0
	xCols[nPos1,GDFieldPos("MM_PERFIN")] := 0 ; xCols[nPos1,GDFieldPos("MM_PERCOM")] := 0
	xCols[nPos1,GDFieldPos("MM_PERFIX")] := 0 ; xCols[nPos1,GDFieldPos("MM_PERLUC")] := 0
	xCols[nPos1,GDFieldPos("MM_PERCOF")] := 0 ; xCols[nPos1,GDFieldPos("MM_PERPIS")] := 0
	xCols[nPos1,GDFieldPos("MM_PERICM")] := 0 ; xCols[nPos1,GDFieldPos("MM_PERCMS")] := 0
	xCols[nPos1,GDFieldPos("MM_PERFRE")] := 0 
	For nx := 1 to (nPos1-1)
		xCols[nPos1,GDFieldPos("MM_CUSTRE")] += xCols[nx,GDFieldPos("MM_CUSTRE")]
		xCols[nPos1,GDFieldPos("MM_CUSTMP")] += xCols[nx,GDFieldPos("MM_CUSTMP")]
		xCols[nPos1,GDFieldPos("MM_CUSTMO")] += xCols[nx,GDFieldPos("MM_CUSTMO")]
		xCols[nPos1,GDFieldPos("MM_CUSTBE")] += xCols[nx,GDFieldPos("MM_CUSTBE")]
		xCols[nPos1,GDFieldPos("MM_CUSTEM")] += xCols[nx,GDFieldPos("MM_CUSTEM")]
		xCols[nPos1,GDFieldPos("MM_CUSTFA")] += xCols[nx,GDFieldPos("MM_CUSTFA")]
		xCols[nPos1,GDFieldPos("MM_PERADM")] += xCols[nx,GDFieldPos("MM_PERADM")]
		xCols[nPos1,GDFieldPos("MM_PERMKT")] += xCols[nx,GDFieldPos("MM_PERMKT")]
		xCols[nPos1,GDFieldPos("MM_PERFIN")] += xCols[nx,GDFieldPos("MM_PERFIN")]
		xCols[nPos1,GDFieldPos("MM_PERCOM")] += xCols[nx,GDFieldPos("MM_PERCOM")]
		xCols[nPos1,GDFieldPos("MM_PERFIX")] += xCols[nx,GDFieldPos("MM_PERFIX")]
		xCols[nPos1,GDFieldPos("MM_PERLUC")] += xCols[nx,GDFieldPos("MM_PERLUC")]
		xCols[nPos1,GDFieldPos("MM_PERCOF")] += xCols[nx,GDFieldPos("MM_PERCOF")]
		xCols[nPos1,GDFieldPos("MM_PERPIS")] += xCols[nx,GDFieldPos("MM_PERPIS")]
		xCols[nPos1,GDFieldPos("MM_PERICM")] += xCols[nx,GDFieldPos("MM_PERICM")]
		xCols[nPos1,GDFieldPos("MM_PERCMS")] += xCols[nx,GDFieldPos("MM_PERCMS")]
		xCols[nPos1,GDFieldPos("MM_PERFRE")] += xCols[nx,GDFieldPos("MM_PERFRE")]
	Next nx        
	If ((nPos1-1) > 0)
		xCols[nPos1,GDFieldPos("MM_PERADM")] := xCols[nPos1,GDFieldPos("MM_PERADM")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERMKT")] := xCols[nPos1,GDFieldPos("MM_PERMKT")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERFIN")] := xCols[nPos1,GDFieldPos("MM_PERFIN")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERCOM")] := xCols[nPos1,GDFieldPos("MM_PERCOM")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERFIX")] := xCols[nPos1,GDFieldPos("MM_PERFIX")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERLUC")] := xCols[nPos1,GDFieldPos("MM_PERLUC")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERCOF")] := xCols[nPos1,GDFieldPos("MM_PERCOF")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERPIS")] := xCols[nPos1,GDFieldPos("MM_PERPIS")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERICM")] := xCols[nPos1,GDFieldPos("MM_PERICM")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERCMS")] := xCols[nPos1,GDFieldPos("MM_PERCMS")]/(nPos1-1)
		xCols[nPos1,GDFieldPos("MM_PERFRE")] := xCols[nPos1,GDFieldPos("MM_PERFRE")]/(nPos1-1)
	Endif                    
	B015CalcMark(@xCols,nPos1)
Endif

Return                                   

Static Function B015CalcMark(xCols,xLinha)
*************************************
If (xLinha > 0).and.(xLinha <= Len(xCols))
	xCols[xLinha,GDFieldPos("MM_PERFIX")] := xCols[xLinha,GDFieldPos("MM_PERADM")]+xCols[xLinha,GDFieldPos("MM_PERMKT")]+xCols[xLinha,GDFieldPos("MM_PERFIN")]+xCols[xLinha,GDFieldPos("MM_PERCOM")]
	xCols[xLinha,GDFieldPos("MM_PRCLIQ")] := xCols[xLinha,GDFieldPos("MM_CUSTFA")]/(1-(xCols[xLinha,GDFieldPos("MM_PERFIX")]+xCols[xLinha,GDFieldPos("MM_PERLUC")])/100)
	xCols[xLinha,GDFieldPos("MM_VALLUC")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]*(xCols[xLinha,GDFieldPos("MM_PERLUC")]/100)
	xCols[xLinha,GDFieldPos("MM_VALADM")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]*(xCols[xLinha,GDFieldPos("MM_PERADM")]/100)
	xCols[xLinha,GDFieldPos("MM_VALMKT")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]*(xCols[xLinha,GDFieldPos("MM_PERMKT")]/100)
	xCols[xLinha,GDFieldPos("MM_VALFIN")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]*(xCols[xLinha,GDFieldPos("MM_PERFIN")]/100)
	xCols[xLinha,GDFieldPos("MM_VALCOM")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]*(xCols[xLinha,GDFieldPos("MM_PERCOM")]/100)
	xCols[xLinha,GDFieldPos("MM_VALFIX")] := xCols[xLinha,GDFieldPos("MM_VALADM")]+xCols[xLinha,GDFieldPos("MM_VALMKT")]+xCols[xLinha,GDFieldPos("MM_VALFIN")]+xCols[xLinha,GDFieldPos("MM_VALCOM")]
	xCols[xLinha,GDFieldPos("MM_PRCVEN")] := xCols[xLinha,GDFieldPos("MM_PRCLIQ")]/(1-(xCols[xLinha,GDFieldPos("MM_PERCMS")]+xCols[xLinha,GDFieldPos("MM_PERFRE")]+xCols[xLinha,GDFieldPos("MM_PERCOF")]+xCols[xLinha,GDFieldPos("MM_PERPIS")]+xCols[xLinha,GDFieldPos("MM_PERICM")])/100)
	xCols[xLinha,GDFieldPos("MM_VALCOF")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]*(xCols[xLinha,GDFieldPos("MM_PERCOF")]/100)
	xCols[xLinha,GDFieldPos("MM_VALPIS")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]*(xCols[xLinha,GDFieldPos("MM_PERPIS")]/100)
	xCols[xLinha,GDFieldPos("MM_VALICM")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]*(xCols[xLinha,GDFieldPos("MM_PERICM")]/100)
	xCols[xLinha,GDFieldPos("MM_IMPOST")] := xCols[xLinha,GDFieldPos("MM_VALCOF")]+xCols[xLinha,GDFieldPos("MM_VALPIS")]+xCols[xLinha,GDFieldPos("MM_VALICM")]
	xCols[xLinha,GDFieldPos("MM_VALCMS")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]*(xCols[xLinha,GDFieldPos("MM_PERCMS")]/100)
	xCols[xLinha,GDFieldPos("MM_VALFRE")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]*(xCols[xLinha,GDFieldPos("MM_PERFRE")]/100)
	xCols[xLinha,GDFieldPos("MM_DESPES")] := xCols[xLinha,GDFieldPos("MM_VALCMS")]+xCols[xLinha,GDFieldPos("MM_VALFRE")]
	xCols[xLinha,GDFieldPos("MM_VALMAR")] := xCols[xLinha,GDFieldPos("MM_PRCVEN")]-xCols[xLinha,GDFieldPos("MM_CUSTFA")]-xCols[xLinha,GDFieldPos("MM_IMPOST")]-xCols[xLinha,GDFieldPos("MM_DESPES")]
	If (xCols[xLinha,GDFieldPos("MM_PRCLIQ")] > 0)
		xCols[xLinha,GDFieldPos("MM_PERMAR")] := (xCols[xLinha,GDFieldPos("MM_VALMAR")]/xCols[xLinha,GDFieldPos("MM_PRCLIQ")])*100
	Endif
Endif
Return

Static Function B015CalcSim(xCols,xLinha,xAtuPrc)
********************************************
LOCAL nx, nPPro := 0, nPTot := 0, nTotRol := 0, nPos1 := 0, nIni := 1, nFim := Len(xCols)-1


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo da Simulacao Pedido de Venda                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xLinha != Nil)
	nIni := xLinha
	nFim := xLinha
Endif
aHeader := aClone(oGetSim:aHeader)
nPPro := GDFieldPos("MM_COD")
DA0->(dbSetOrder(1)) ; DA1->(dbSetOrder(1))
For nx := nIni to nFim
	If !Empty(xCols[nx,GDFieldPos("MM_TABELA")])
		c015Tab := xCols[nx,GDFieldPos("MM_TABELA")]
	Endif
	DA0->(dbSeek(xFilial("DA0")+c015Tab))
	If !Empty(xCols[nx,nPPro]).and.DA1->(dbSeek(xFilial("DA1")+c015Tab+xCols[nx,nPPro]))
		xCols[nx,GDFieldPos("MM_PRCTAB")] := DA1->DA1_prcven
		xCols[nx,GDFieldPos("MM_PRCTOT")] := xCols[nx,GDFieldPos("MM_QTDADE")]*xCols[nx,GDFieldPos("MM_PRCTAB")]
		If Empty(xCols[nx,GDFieldPos("MM_PRCSIM")]).or.(xAtuPrc)
			xCols[nx,GDFieldPos("MM_PRCSIM")] := xCols[nx,GDFieldPos("MM_PRCTOT")]
		Endif
		xCols[nx,GDFieldPos("MM_PRCNOV")] := xCols[nx,GDFieldPos("MM_PRCSIM")]-(xCols[nx,GDFieldPos("MM_PRCSIM")]*(xCols[nx,GDFieldPos("MM_PERDES")]/100))
		xCols[nx,GDFieldPos("MM_VALLUC")] := 0 ; xCols[nx,GDFieldPos("MM_PERLUC")] := 0
		nPos1 := GDFieldPos("MM_COD",oGetGer:aHeader)
		If (nPos1 > 0)
			nLin := aScan(oGetGer:aCols,{|x| x[nPos1]==xCols[nx,nPPro] }) 
			nValCms := xCols[nx,GDFieldPos("MM_PRCNOV")]*(oGetGer:aCols[nLin,GDFieldPos("MM_PERCMS",oGetGer:aHeader)]/100)
			nValFre := xCols[nx,GDFieldPos("MM_PRCNOV")]*(oGetGer:aCols[nLin,GDFieldPos("MM_PERFRE",oGetGer:aHeader)]/100)
			nValImp := xCols[nx,GDFieldPos("MM_PRCNOV")]*((DA0->DA0_pericm+DA0->DA0_percof+DA0->DA0_perpis)/100)
			nValRol := xCols[nx,GDFieldPos("MM_PRCNOV")]-nValCms-nValFre-nValImp
			nValDsp := nValRol*(oGetGer:aCols[nLin,GDFieldPos("MM_PERFIX",oGetGer:aHeader)]/100)
			xCols[nx,GDFieldPos("MM_VALLUC")]  := nValRol-nValDsp-(oGetGer:aCols[nLin,GDFieldPos("MM_CUSTFA",oGetGer:aHeader)]*xCols[nx,GDFieldPos("MM_QTDADE")])
			If (xCols[nx,GDFieldPos("MM_PRCNOV")] != 0)
				xCols[nx,GDFieldPos("MM_PERLUC")]  := (xCols[nx,GDFieldPos("MM_VALLUC")]/xCols[nx,GDFieldPos("MM_PRCNOV")])*100
			Endif                               
		Endif
	Endif
Next nx
nPTot := Len(xCols)
xCols[nPTot,GDFieldPos("MM_QTDADE")] := 0
xCols[nPTot,GDFieldPos("MM_PRCTOT")] := 0
xCols[nPTot,GDFieldPos("MM_PRCSIM")] := 0
xCols[nPTot,GDFieldPos("MM_PRCNOV")] := 0
xCols[nPTot,GDFieldPos("MM_VALLUC")] := 0  
xCols[nPTot,GDFieldPos("MM_PERLUC")] := 0
For nx := 1 to Len(xCols)-1
	xCols[nPTot,GDFieldPos("MM_QTDADE")] += xCols[nx,GDFieldPos("MM_QTDADE")]
	xCols[nPTot,GDFieldPos("MM_PRCTOT")] += xCols[nx,GDFieldPos("MM_PRCTOT")]
	xCols[nPTot,GDFieldPos("MM_PRCSIM")] += xCols[nx,GDFieldPos("MM_PRCSIM")]
	xCols[nPTot,GDFieldPos("MM_PRCNOV")] += xCols[nx,GDFieldPos("MM_PRCNOV")]
	xCols[nPTot,GDFieldPos("MM_VALLUC")] += xCols[nx,GDFieldPos("MM_VALLUC")]
Next nx                                 
If (xCols[nPTot,GDFieldPos("MM_PRCSIM")] != 0)
	xCols[nx,GDFieldPos("MM_PERDES")] := (1-(xCols[nPTot,GDFieldPos("MM_PRCNOV")]/xCols[nPTot,GDFieldPos("MM_PRCSIM")]))*100
Endif
If (xCols[nPTot,GDFieldPos("MM_PRCNOV")] != 0)
	xCols[nPTot,GDFieldPos("MM_PERLUC")] := (xCols[nPTot,GDFieldPos("MM_VALLUC")]/xCols[nPTot,GDFieldPos("MM_PRCNOV")])*100
Endif

Return

Static Function B015FormPrc(xProduto)
*********************************
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
		aArray := B015CalcTot(nMatPrima,nUltNivel,99)
	Endif
Endif
Return aArray
                                          
Static Function B015CalcTot(nMatPrima,nUltNivel,nOpcx)
*************************************************
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

Static Function B015ConKardex(xGet,xCols,xAt)
****************************************
LOCAL nPCam := 0

PRIVATE lCusUnif := IIf(FindFunction("A330CusFil"),A330CusFil(),GetNewPar("MV_CUSFIL",.F.))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta perguntas no SX1 a fim de preparar o relatorio p/     ³
//³ custo unificado por empresa                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCusUnif
	MTC030CUnf()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 TO
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	nPos1 := GDFieldPos("MM_COD",xGet:aHeader)
	If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCols[xAt,nPos1]))
			If Pergunte("MTC030",.T.)
				MC030Con()
				xGet:oBrowse:Refresh()
			EndIf
		Endif
	Endif
Endif
Set Key VK_F4 TO V433Estoque()

Return

Static Function B015ConView(xGet,xCols,xAt)
***************************************
LOCAL nPCam := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 TO
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	nPos1 := GDFieldPos("MM_COD",xGet:aHeader)
	If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCols[xAt,nPos1]))
			MaComView(SB1->B1_cod)
			xGet:oBrowse:Refresh()
		Endif
	Endif
Endif
Set Key VK_F4 TO V433Estoque()

Return                   

Static Function B015ConForma(xGet,xCols,xAt)
***************************************
LOCAL aSB1 := SB1->(GetArea()), nPos1 := 0, nPos2 := 0, nQtdPrv := 1
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	nPos1 := GDFieldPos("MM_COD",xGet:aHeader)
	nPos2 := GDFieldPos("MM_QTDPRV",oGetGer:aHeader)
	If (nPos2 > 0)
		nQtdPrv := xCols[xAt,nPos2]
	Endif
	If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCols[xAt,nPos1]))
			If Pergunte("MTC010",.T.)
				MC010Forma("SB1",SB1->(Recno()),98,nQtdPrv,2)
			Endif
		Endif
	Endif
Endif
RestArea(aSB1)
Return

Static Function B015Estoque()
**************************
LOCAL nPos1 := 0, nPCam := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 TO
If (oGetGer != Nil).and.(Len(oGetGer:aCols) > 0).and.(oGetGer:nAt > 0)
	nPos1 := GDFieldPos("MM_COD",oGetGer:aHeader)
	If (nPos1 > 0).and.!Empty(oGetGer:aCols[oGetGer:nAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+oGetGer:aCols[oGetGer:nAt,nPos1]))
			MaViewSB2(SB1->B1_COD)
			oGetGer:oBrowse:Refresh()
		Endif
	Endif
Endif
Set Key VK_F4 TO B015Estoque()

Return

Static Function B015Historico(xGet,xCols,xAt)
****************************************
LOCAL nPos1 := 0, nPCam := 0
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	nPos1 := GDFieldPos("MM_COD",xGet:aHeader)
	If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCols[xAt,nPos1]))
			If ExistBlock("GDVHISTMAN") //Verifico rotina GDVHISTMAN
				u_GDVHistMan("SB1",.T.)
			Endif
		Endif
	Endif
Endif
Return      

Static Function B015Say(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xColor)
*********************************************************************
LOCAL oSay := Nil
oSay := TSAY():Create(xObj)
oSay:cName := xName
oSay:cCaption := xCaption
oSay:nLeft := xLeft
oSay:nTop := xTop
oSay:nWidth := iif(xWidth!=Nil,xWidth,80)
oSay:nHeight := iif(xHeight!=Nil,xHeight,20)
oSay:lShowHint := .F.
oSay:lReadOnly := .F.
oSay:Align := 0
oSaY:lVisibleControl := .T.
oSay:lWordWrap := .F.
oSay:lTransparent := .F.
oSay:nClrText := iif(xColor!=Nil,xColor,CLR_BLUE)
Return (oSay)

Static Function B015Get(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xChange,xPicture,xF3)
**********************************************************************************
LOCAL oGet := Nil
oGet := TGET():Create(xObj)
oGet:cName := xName
oGet:nLeft := xLeft
oGet:nTop := xTop
oGet:nWidth := iif(xWidth!=Nil,xWidth,80)
oGet:nHeight := iif(xHeight!=Nil,xHeight,20)
oGet:lShowHint := .F.
oGet:lReadOnly := .F.
oGet:Align := 0
oGet:cVariable := xVariable
oGet:bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oGet:bChange := xChange
oGet:lVisibleControl := .T.
oGet:lPassword := .F.
oGet:lHasButton := .T.
oGet:Picture := xPicture
oGet:cF3 := xF3
Return (oGet)

Static Function B015Button(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xAction)
***********************************************************************
LOCAL oButton := Nil
oButton := TBUTTON():Create(xObj)
oButton:cName := xName
oButton:cCaption := xCaption
oButton:nLeft := xLeft
oButton:nTop := xTop
oButton:nWidth := iif(xWidth!=Nil,xWidth,80)
oButton:nHeight := iif(xHeight!=Nil,xHeight,20)
oButton:bAction := xAction
Return (oButton)

Static Function B015Combo(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xItens,xChange)
******************************************************************************
LOCAL oCombo := Nil
oCombo := TCOMBOBOX():Create(xObj)
oCombo:cName := xName
oCombo:nLeft := xLeft
oCombo:nTop := xTop
oCombo:nWidth := iif(xWidth!=Nil,xWidth,80)
oCombo:nHeight := iif(xHeight!=Nil,xHeight,20)
oCombo:lShowHint := .F.
oCombo:lReadOnly := .F.
oCombo:Align := 0
oCombo:cVariable := xVariable
oCombo:bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oCombo:lVisibleControl := .T.
oCombo:aItems := xItens
oCombo:nAt := 1
oCombo:bChange := xChange
Return (oCombo)

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

Static Function B015CorSim(xHeader,xCols,xAt)
*****************************************
LOCAL nRetu := RGB(250,250,250), nPos1, nPos2
nPos1 := GDFieldPos("MM_PERLUC",xHeader)
nPos2 := GDFieldPos("MM_PERDES",xHeader)
If (xCols[xAt,nPos2] >= 100)
	nRetu := RGB(255,50,255)
Elseif (xCols[xAt,nPos1] < 0)
	nRetu := RGB(250,190,190)
Elseif (xCols[xAt,nPos1] >= 0).and.(xCols[xAt,nPos1] < 20)
	nRetu := RGB(245,245,180)
Elseif (xCols[xAt,nPos1] >= 20).and.(xCols[xAt,nPos1] < 40)
	nRetu := RGB(150,245,190)
Elseif (xCols[xAt,nPos1] >= 40)
	nRetu := RGB(150,210,250)	
Endif
Return nRetu

Static Function B015Legenda()
**************************
LOCAL aLegenda := { {"DISABLE","% Lucro menor que 0%"},;
	{"BR_AMARELO","% Lucro maior que 0% e menor que 20%"},;
	{"BR_VERDE"  ,"% Lucro maior que 20% e menor que 40%"},;
	{"BR_AZUL"   ,"% Lucro maior que 40%"}}
BrwLegenda(cCadastro,"Legenda",aLegenda)
Return

      
Static Function B015CorDet(xHeader,xCols,xAt)
*****************************************
LOCAL nRetu := RGB(250,250,250)
If (xAt > 0).and.(n015LinDet == xAt)
	nRetu := RGB(230,245,245) //Selecionado
Endif
Return nRetu

Static Function B015ExpExcel()
***************************
LOCAL cDirDocs := MsDocPath() 
LOCAL cArquivo := CriaTrab(,.F.)
LOCAL cPath		:= AllTrim(GetTempPath())
LOCAL cCrLf 	:= Chr(13) + Chr(10)
LOCAL oExcelApp, nHandle, nX, nY, aStru
If (oFolder:nOption == 1) //Simulador
	xHeader := aClone(oGetSim:aHeader)
	xCols := aClone(oGetSim:aCols)  
Elseif (oFolder:nOption == 2) //Detalhamento
	xHeader := aClone(oGetGer:aHeader)
	xCols := aClone(oGetGer:aCols)  
Endif 
aStru := aClone(xHeader)
ProcRegua(Len(xCols)+2)     
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)
If (nHandle > 0)
	// Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integração com Excel...")
	fWrite(nHandle,cCrLf) // Pula linha
	fWrite(nHandle,Upper(cCadastro)) // Titulo
	fWrite(nHandle,cCrLf+cCrLf) // Pula duas linhas
	aEval(aStru,{|e,nX| fWrite(nHandle,e[1]+If(nX<Len(aStru),";",""))})
	fWrite(nHandle,cCrLf) // Pula linha
	For nX := 1 to Len(xCols)
		IncProc("Aguarde! Gerando arquivo de integração com Excel...")
		For nY := 1 to Len(xHeader)
			fWrite(nHandle,Transform(xCols[nX,nY],xHeader[nY,3])+";")
		Next nY
		fWrite(nHandle,cCrLf) // Pula linha
	Next nX
	IncProc("Aguarde! Abrindo o arquivo...")
	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )
	If !ApOleClient('MsExcel')
		MsgAlert('MsExcel nao instalado')
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Falha na criação do arquivo")
Endif	
Return