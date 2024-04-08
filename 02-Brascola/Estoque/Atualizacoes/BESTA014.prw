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
±±ºPrograma  ³ BESTA014 ºAutor  ³ Marcelo da Cunha   º Data ³  27/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Planilha para Gestao de Custos de Producao                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BESTA014()
*********************
PRIVATE oDlgGer, oFldGer, oGetGer, oGetDet, oGetCus, oGetStd, oGetMed, oLbOp, oLbProd, oBold, oScrGrf, oChart
PRIVATE aCampos, aHdrGer, aHdrDet, aHdrCus, aHdrStd, aHdrMed, a014StdPer, a014MedPer, aCols, aButtons, dMesAno, cMesAno
PRIVATE c014LbCust, c014LbOp, c014LbProd, c014Cod, c014NumOp, d014EmiDe, d014EmiAt, d014EncDe
PRIVATE c014StdPro, c014StdTip, c014MedPro, c014MedTip, d014EncAt, n014POp, n014PPro, n014PerAnaCus := 0
PRIVATE c014Ordem, a014Ordem, n014QualCusto := 1, n014MostraOps := 1, n014PercVaria := 0, n014StdAnaCus := 1
PRIVATE c014Prods, c014Planilha := Space(15), n014OpsEncerr := 1, n014Linha := 0, n014StdLin := 0, n014MedLin := 0
PRIVATE aTitle, aPage, nOpcm, cCadastro := "Planilha para Gestao de Custos de Producao"
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
u_BCFGA002("BESTA014") //Grava detalhes da rotina usada
                                      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Veifico se usuario possui acesso na rotina                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(Alltrim(cUserName) $ GetMV("BR_000023")).and.!(Alltrim(cUserName) $ GetMV("BR_000024"))
	Help("",1,"BRASCOLA",,OemToAnsi("Usuario sem acesso na rotina (BR_000023/BR_000024)!"),1,0) 
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas pelo programa                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina := {{"","",0,1},{"","",0,2},{"","",0,3}}
aButtons:= {} ; INCLUI := .F. ; ALTERA := .F.
c014LbCust := "CUSTO: "
c014LbOp   := "OP: "
c014LbProd := "PRODUTO: "
a014Ordem  := {"1=Produto+OP"}
c014Ordem  := a014Ordem[1]
c014Cod    := Space(15)
c014NumOp  := Space(13)
d014EmiDe  := FirstDay(dDataBase-180)
d014EmiAt  := LastDay(dDataBase)
d014EncDe  := FirstDay(dDataBase)
d014EncAt  := LastDay(dDataBase)
c014StdPro := Space(15)
c014StdTip := Space(2)
a014StdPer := {ctod("//"),ctod("//")}
c014MedPro := Space(15)
c014MedTip := Space(2)
a014MedPer := {ctod("//"),ctod("//")}
c014ReqOp1 := Space(13)
c014ReqOp2 := Space(13)
c014ReqPr1 := Space(15)
c014ReqPr2 := Space(15)
d014ReqEm1 := d014EmiDe
d014ReqEm2 := d014EmiAt
aadd(aButtons,{"AUTOM"    ,{||B014Param1(.T.) },"Parametr","Parametr"})
aadd(aButtons,{"GRAF3D"   ,{||B014ConKardex(@oGetGer,@oGetGer:aCols,oGetGer:nAt)},"Kardex p/Dia","Kardex"})
aadd(aButtons,{"S4WB005N" ,{||B014ConView(@oGetGer,@oGetGer:aCols,oGetGer:nAt)}  ,"Consulta Produto","Produto"})
aadd(aButtons,{"PMSEXCEL" ,{||B014ExpExcel()},"Excel","Excel"})
aadd(aButtons,{"OPEN"     ,{||B014Historico(@oGetGer,@oGetGer:aCols,oGetGer:nAt,1)},"Historico","Historico"})
If VerSenha(107) //Permite consulta a Formacao de Precos
	aadd(aButtons,{"BUDGET",{||B014ConForma(@oGetGer,@oGetGer:aCols,oGetGer:nAt)},"Formacao de Precos","Formacao"})
Endif
aadd(aButtons,{"DBG06"    ,{|| Processa({|| B014Atualiza() })},"Atualiza","Atualiza"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo parametros                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
B014Param1(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atalhos para consulta                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Set Key VK_F4 TO B014Estoque()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores com as opcoes dos Folders                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTitle := {"Gestao Custos por OP","Detalhamento de Requisicoes da OP","Analise de Margem por Produto","Variacao Custo Standard","Variacao Custo Medio"}
aPage  := {"Gestao Custos por OP","Detalhamento de Requisicoes da OP","Analise de Margem por Produto","Variacao Custo Standard","Variacao Custo Medio"}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aHdrGer := {} ; aHdrDet := {} ; aHdrCus := {} ; aHdrStd := {} ; aHdrMed := {}
aadd(aHdrGer,{"OP"         ,"MM_OP"    ,"",13,0,"","","C","",""})
aadd(aHdrGer,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrGer,{"Descricao"  ,"MM_DESC"  ,"",30,5,"","","C","",""})
aadd(aHdrGer,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
aadd(aHdrGer,{"Qtde Prv"   ,"MM_QTDPRV","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrGer,{"Qtde Rea"   ,"MM_QTDREA","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrGer,{"Custo Prv"  ,"MM_CUSPRV","@E 99,999,999.99",14,2,"","","N","",""})
aadd(aHdrGer,{"Custo Rea"  ,"MM_CUSREA","@E 99,999,999.99",14,2,"","","N","",""})
aadd(aHdrGer,{"Medio Prv"  ,"MM_MEDPRV","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrGer,{"Medio Rea"  ,"MM_MEDREA","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrGer,{"Diferenca"  ,"MM_DIFERE","@E 999,999.9999",12,4,"","","N","",""})
aadd(aHdrGer,{"An.Horizo." ,"MM_ANAHOR","@E 999,999.99",10,2,"","","N","",""})
aadd(aHdrGer,{"An.Vertic." ,"MM_ANAVER","@E 999,999.99",10,2,"","","N","",""})
aadd(aHdrGer,{"Encerram"   ,"MM_DATRF" ,"@E",08,0,"","","D","",""})
aadd(aHdrGer,{"Usuario"    ,"MM_USUARI","",15,0,"","","C","",""})
aadd(aHdrGer,{"Obser.Custo","MM_OBSCUS","",200,0,"","","C","",""})
n014POp := GDFieldPos("MM_OP",aHdrGer)
n014PPro:= GDFieldPos("MM_COD",aHdrGer)
aadd(aHdrDet,{"OP"         ,"DD_OP"    ,"",13,0,"","","C","",""}) //01
aadd(aHdrDet,{"Prod.Pai"   ,"DD_CODPAI","",15,0,"","","C","",""}) //02
aadd(aHdrDet,{"Prod.Requi" ,"DD_CODREQ","",15,0,"","","C","",""}) //03
aadd(aHdrDet,{"Descricao"  ,"DD_DESC"  ,"",30,5,"","","C","",""}) //04
aadd(aHdrDet,{"UM"         ,"DD_UM"    ,"",02,0,"","","C","",""}) //05
aadd(aHdrDet,{"Qtde Est"   ,"DD_QTDEST","@E 999,999.9999",12,4,"","","N","",""}) //06
aadd(aHdrDet,{"Qtde Emp"   ,"DD_QTDEMP","@E 999,999.9999",12,4,"","","N","",""}) //07
aadd(aHdrDet,{"Qtde Rea"   ,"DD_QTDREA","@E 999,999.9999",12,4,"","","N","",""}) //08
aadd(aHdrDet,{"Custo Est"  ,"DD_CUSEST","@E 99,999,999.99",14,2,"","","N","",""}) //09
aadd(aHdrDet,{"Custo Emp"  ,"DD_CUSEMP","@E 99,999,999.99",14,2,"","","N","",""}) //10
aadd(aHdrDet,{"Custo Rea"  ,"DD_CUSREA","@E 99,999,999.99",14,2,"","","N","",""}) //11
aadd(aHdrDet,{"Medio Unit" ,"DD_MEDUNI","@E 999,999.9999",12,4,"","","N","",""}) //12
aadd(aHdrDet,{"% Variacao" ,"DD_VARIAC","@E 999,999.99",10,2,"","","N","",""}) //13
aadd(aHdrDet,{"Lista OPs"  ,"DD_LISTOP","",200,0,"","","C","",""}) //14
aadd(aHdrCus,{"Produto"    ,"CC_COD"   ,"",15,0,"","","C","",""}) //15
aadd(aHdrCus,{"Tipo"       ,"CC_TIPO"  ,"",15,0,"","","C","",""}) //16
dMesAno := LastDay(dDatabase)+1
dMesAno := ctod(Substr(dtoc(dMesAno),1,6)+Strzero(Year(dMesAno)-1,4))
For nx := 1 to 12
	cMesAno := Substr(MesExtenso(Month(dMesAno)),1,3)+"/"+Strzero(Year(dMesAno),4)
	aadd(aHdrCus,{cMesAno ,"CC_"+Left(dtos(dMesAno),6),"@E 999,999.9999",12,4,"","","N","",""})
	dMesAno := LastDay(dMesAno)+1
Next nx
aadd(aHdrStd,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrStd,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrStd,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
If (n014StdAnaCus == 1) //Diario
	dMesAno := dDatabase
	For nx := 1 to n014PerAnaCus
		dMesAno := dMesAno-1
		While (dMesAno != DataValida(dMesAno))
			dMesAno := dMesAno-1
		Enddo
	Next nx            
	a014StdPer[1] := dMesAno+1
	For nx := 1 to n014PerAnaCus
		cMesAno := dtoc(dMesAno)
		aadd(aHdrStd,{cMesAno,"ST_"+Substr(dtos(dMesAno),3),"@E 999,999.9999",12,4,"","","N","",""})
		dMesAno := DataValida(dMesAno+1)
		a014StdPer[2] := dMesAno
	Next nx
Elseif (n014StdAnaCus == 2) //Semanal
	dMesAno := dDatabase-1
	For nx := 1 to n014PerAnaCus-1
		dMesAno := dMesAno-7
	Next nx
	a014StdPer[1] := dMesAno
	For nx := 1 to n014PerAnaCus
		cSemana := StrTran(RetSem(dMesAno),"/","_")
		aadd(aHdrStd,{"Sem "+RetSem(dMesAno),"ST_"+cSemana,"@E 999,999.9999",12,4,"","","N","",""})
		dMesAno := dMesAno+7
		a014StdPer[2] := dMesAno
	Next nx
Elseif (n014StdAnaCus == 3) //Quinzenal

Elseif (n014StdAnaCus == 4) //Mensal
	dMesAno := dDatabase-1
	For nx := 1 to n014PerAnaCus-1
		dMesAno := FirstDay(dMesAno)-1
	Next nx
	a014StdPer[1] := dMesAno+1
	For nx := 1 to n014PerAnaCus
		cMesAno := Substr(MesExtenso(Month(dMesAno)),1,3)+"/"+Strzero(Year(dMesAno),4)
		aadd(aHdrStd,{cMesAno,"ST_"+Left(dtos(dMesAno),6),"@E 999,999.9999",12,4,"","","N","",""})
		dMesAno := LastDay(dMesAno)+1
		a014StdPer[2] := dMesAno
	Next nx
Endif		
a014StdPer[1] := FirstDay(a014StdPer[1])
a014StdPer[2] := LastDay(a014StdPer[2])
aadd(aHdrMed,{"Produto"    ,"MM_COD"   ,"",15,0,"","","C","",""})
aadd(aHdrMed,{"Tipo"       ,"MM_TIPO"  ,"",02,0,"","","C","",""})
aadd(aHdrMed,{"UM"         ,"MM_UM"    ,"",02,0,"","","C","",""})
dMesAno := FirstDay(dDatabase)-1
For nx := 1 to 11
	dMesAno := FirstDay(dMesAno)-1
Next nx
a014MedPer[1] := dMesAno+1
For nx := 1 to 12
	cMesAno := Substr(MesExtenso(Month(dMesAno)),1,3)+"/"+Strzero(Year(dMesAno),4)
	aadd(aHdrMed,{cMesAno,"MD_"+Left(dtos(dMesAno),6),"@E 999,999.9999",12,4,"","","N","",""})
	dMesAno := LastDay(dMesAno)+1
	a014MedPer[2] := dMesAno
Next nx
aadd(aHdrMed,{"Atual","MD_ATUAL","@E 999,999.9999",12,4,"","","N","",""})
a014MedPer[1] := FirstDay(a014MedPer[1])
a014MedPer[2] := LastDay(a014MedPer[2])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Consulta                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0, 180, .T., .T. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)        
DEFINE MSDIALOG oDlgGer FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] SAY "PLANILHA PARA GESTAO DO CUSTO DE PRODUCAO: "+dtoc(dDataBase) OF oDlgGer PIXEL SIZE 245,9 FONT oBold
@ aPosObj[1,1],aPosObj[1,2]+200 SAY oLbCust VAR c014LbCust OF oDlgGer PIXEL SIZE 100,9 COLOR CLR_GREEN FONT oBold
@ aPosObj[1,1],aPosObj[1,2]+280 SAY oLbOp   VAR c014LbOp   OF oDlgGer PIXEL SIZE 100,9 COLOR CLR_GREEN FONT oBold
@ aPosObj[1,1],aPosObj[1,2]+360 SAY oLbProd VAR c014LbProd OF oDlgGer PIXEL SIZE 200,9 COLOR CLR_GREEN FONT oBold
@ aPosObj[1,1]+14,aPosObj[1,2] TO aPosObj[1,1]+15,(aPosObj[1,4]-aPosObj[1,2]) LABEL "" OF oDlgGer PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Folder Gestao de Custos por OP                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFldGer := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitle,aPage,oDlgGer,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1],)
oFldGer:bSetOption := {|nAtu|B014ChgFld(nAtu,oFldGer:nOption,oDlgGer,oFldGer)}
oSayOrd1:= B014Say(oFldGer:aDialogs[1],"oSayOrd1","Ordem:",010,012)
oComOrd1:= B014Combo(oFldGer:aDialogs[1],"c014Ordem","c014Ordem",050,010,100,,a014Ordem,{|| .T. })
oSayCod2:= B014Say(oFldGer:aDialogs[1],"oSayCod2","Codigo:",180,012)
oGetCod2:= B014Get(oFldGer:aDialogs[1],"c014Cod","c014Cod",225,010,90,,{|| .T. },,"SB1")
oSayNum3:= B014Say(oFldGer:aDialogs[1],"oSayOp3","Num. OP:",180,032)
oGetNum3:= B014Get(oFldGer:aDialogs[1],"c014NumOp","c014NumOp",225,030,120,,{|| .T. },,"SC2")
oSayEmi4:= B014Say(oFldGer:aDialogs[1],"oSayEmi4","Emissao:",370,012)
oGetEmi4:= B014Get(oFldGer:aDialogs[1],"d014EmiDe","d014EmiDe",425,010,60,,{|| .T. })
oGetEmi5:= B014Get(oFldGer:aDialogs[1],"d014EmiAt","d014EmiAt",510,010,60,,{|| .T. })
oSayEnc6:= B014Say(oFldGer:aDialogs[1],"oSayEnc6","Encerram:",370,032)
oGetEnc6:= B014Get(oFldGer:aDialogs[1],"d014EncDe","d014EncDe",425,030,60,,{|| .T. })
oGetEnc7:= B014Get(oFldGer:aDialogs[1],"d014encAt","d014EncAt",510,030,60,,{|| .T. })
oButAtu1:= B014Button(oFldGer:aDialogs[1],"oButAtu1","Atualiza",610,010,,,{|| Processa({|| B014Atualiza() })})
aCols := {} ; B014ZeraCols(@aHdrGer,@aCols)
oGetGer := MsNewGetDados():New(030,005,(oFldGer:aDialogs[1]:nClientHeight/2)-5,(oFldGer:aDialogs[1]:nClientWidth/2)-5,GD_UPDATE,"AllwaysTrue","AllwaysTrue",,{"MM_OBSCUS"},,,"u_B014ValCam",,,oFldGer:aDialogs[1],aHdrGer,aCols)
oGetGer:oBrowse:bChange := {|| B014AtuOpProd() }
oGetGer:oBrowse:lUseDefaultColors := .F.
oGetGer:oBrowse:SetBlkBackColor({||B014CorDados(oGetGer:aHeader,oGetGer:aCols,oGetGer:nAt)})
oButAtu2:= B014Button(oFldGer:aDialogs[2],"oButAtu2","Atualiza",010,010,,,{|| Processa({|| B014AtuDetalh(oGetGer:aCols[oGetGer:nAt,n014POp],.T.) })})
aCols := {} ; B014ZeraCols(@aHdrDet,@aCols)
oGetDet := MsNewGetDados():New(020,000,(oFldGer:aDialogs[2]:nClientHeight/2),(oFldGer:aDialogs[2]:nClientWidth/2),0,"AllwaysTrue","AllwaysTrue",,{},,,,,,oFldGer:aDialogs[2],aHdrDet,aCols)
oGetDet:oBrowse:lUseDefaultColors := .F.
oGetDet:oBrowse:SetBlkBackColor({||RGB(250,250,250)})
oGetDet:oBrowse:bLDblClick := {|| B014Produto(@oGetDet,@oGetDet:aCols,oGetDet:nAt) } 
aCols := {} ; B014ZeraCols(@aHdrCus,@aCols)
oGetCus := MsNewGetDados():New(000,000,060,(oFldGer:aDialogs[3]:nClientWidth/2),0,"AllwaysTrue","AllwaysTrue",,{},,,,,,oFldGer:aDialogs[3],aHdrCus,aCols)
oGetCus:oBrowse:lUseDefaultColors := .F.
oGetCus:oBrowse:SetBlkBackColor({||RGB(250,250,250)})
oScrGrf := TScrollBox():Create(oFldGer:aDialogs[3],065,000,(oFldGer:aDialogs[3]:nClientHeight/2)-65,(oFldGer:aDialogs[3]:nClientWidth/2),.T.,.T.,.F.)
oSayStd1:= B014Say(oFldGer:aDialogs[4],"oSayStd1","Codigo:",010,012)
oGetStd1:= B014Get(oFldGer:aDialogs[4],"c014StdPro","c014StdPro",055,010,90,,{|| Processa({||B014AtuaStd()}) },,"SB1")
oSayStd2:= B014Say(oFldGer:aDialogs[4],"oSayStd2","Tipo:",180,012)
oGetStd2:= B014Get(oFldGer:aDialogs[4],"c014StdTip","c014StdTip",210,010,50,,{|| Processa({||B014AtuaStd()}) },,"02")
oButStd3:= B014Button(oFldGer:aDialogs[4],"oButStd3","Kardex",310,010,,,{||B014ConKardex(@oGetStd,@oGetStd:aCols,oGetStd:nAt)})
oButStd4:= B014Button(oFldGer:aDialogs[4],"oButStd4","Produto",390,010,,,{||B014ConView(@oGetStd,@oGetStd:aCols,oGetStd:nAt)})
oButStd5:= B014Button(oFldGer:aDialogs[4],"oButStd5","Excel",470,010,,,{||B014ExpExcel()})
oButStd6:= B014Button(oFldGer:aDialogs[4],"oButStd6","Historico",550,010,,,{||B014Historico(@oGetStd,@oGetStd:aCols,oGetStd:nAt,2)})
If VerSenha(107) //Permite consulta a Formacao de Precos
	oButStd7:= B014Button(oFldGer:aDialogs[4],"oButStd7","Formacao",630,010,,,{||B014ConForma(@oGetStd,@oGetStd:aCols,oGetStd:nAt)})
Endif
If ExistBlock("GDVA010")
	oButStd8:= B014Button(oFldGer:aDialogs[4],"oButStd8","GDView Produto",710,010,090,,{||B014Produto(@oGetStd,@oGetStd:aCols,oGetStd:nAt)})
Endif
aCols := {} ; B014ZeraCols(@aHdrStd,@aCols)
oGetStd := MsNewGetDados():New(020,000,(oFldGer:aDialogs[4]:nClientHeight/2),(oFldGer:aDialogs[4]:nClientWidth/2),0,"AllwaysTrue","AllwaysTrue",,{},,,,,,oFldGer:aDialogs[4],aHdrStd,aCols)
oGetStd:oBrowse:bChange := {|| (n014StdLin:=oGetStd:nAt,oGetStd:oBrowse:Refresh()) }
oGetStd:oBrowse:lUseDefaultColors := .F.
oGetStd:oBrowse:SetBlkBackColor({||B014CorDdStd(oGetStd:aHeader,oGetStd:aCols,oGetStd:nAt)})
oSayMed1:= B014Say(oFldGer:aDialogs[5],"oSayMed1","Codigo:",010,012)
oGetMed1:= B014Get(oFldGer:aDialogs[5],"c014MedPro","c014MedPro",055,010,90,,{|| Processa({||B014AtuaMed()}) },,"SB1")
oSayMed2:= B014Say(oFldGer:aDialogs[5],"oSayMed2","Tipo:",180,012)
oGetMed2:= B014Get(oFldGer:aDialogs[5],"c014MedTip","c014MedTip",210,010,50,,{|| Processa({||B014AtuaMed()}) },,"02")
oButMed3:= B014Button(oFldGer:aDialogs[5],"oButMed3","Kardex",310,010,,,{||B014ConKardex(@oGetMed,@oGetMed:aCols,oGetMed:nAt)})
oButMed4:= B014Button(oFldGer:aDialogs[5],"oButMed4","Produto",390,010,,,{||B014ConView(@oGetMed,@oGetMed:aCols,oGetMed:nAt)})
oButMed5:= B014Button(oFldGer:aDialogs[5],"oButMed5","Excel",470,010,,,{||B014ExpExcel()})
oButMed6:= B014Button(oFldGer:aDialogs[5],"oButMed6","Historico",550,010,,,{||B014Historico(@oGetMed,@oGetMed:aCols,oGetMed:nAt,2)})
If VerSenha(107) //Permite consulta a Formacao de Precos
	oButMed7:= B014Button(oFldGer:aDialogs[5],"oButMed7","Formacao",630,010,,,{||B014ConForma(@oGetMed,@oGetMed:aCols,oGetMed:nAt)})
Endif
If ExistBlock("GDVA010")
	oButMed8:= B014Button(oFldGer:aDialogs[5],"oButMed8","GDView Produto",710,010,090,,{||B014Produto(@oGetMed,@oGetMed:aCols,oGetMed:nAt)})
Endif
aCols := {} ; B014ZeraCols(@aHdrMed,@aCols)
oGetMed := MsNewGetDados():New(020,000,(oFldGer:aDialogs[5]:nClientHeight/2),(oFldGer:aDialogs[5]:nClientWidth/2),0,"AllwaysTrue","AllwaysTrue",,{},,,,,,oFldGer:aDialogs[5],aHdrMed,aCols)
oGetMed:oBrowse:bChange := {|| (n014MedLin:=oGetMed:nAt,oGetMed:oBrowse:Refresh()) }
oGetMed:oBrowse:lUseDefaultColors := .F.
oGetMed:oBrowse:SetBlkBackColor({||B014CorDdMed(oGetMed:aHeader,oGetMed:aCols,oGetMed:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Liberar apenas a pasta de Variacao do Custo                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(Alltrim(cUserName) $ GetMV("BR_000024"))
	oFldGer:SetOption(4)
	For nx := 1 to Len(oFldGer:aDialogs)
		If (nx != 4)
			oFldGer:aEnable(nx,.F.)
		Endif
	Next nx
	oFldGer:Refresh()
Endif

ACTIVATE MSDIALOG oDlgGer ON INIT EnchoiceBar(oDlgGer,{|| iif(B014Valid(),(nOpcm:=1,oDlgGer:End()),.F.) },{|| iif(B014Valid(),oDlgGer:End(),.F.) },,aButtons)

Return

User Function B014ValCam()
***********************
LOCAL lRetu := .T., cCampo := Alltrim(ReadVar()), nPos1
If (oGetGer != Nil).and.(Len(oGetGer:aCols) > 0).and.(oGetGer:nAt > 0)
	If (cCampo == "M->MM_OBSCUS")
		nPos1 := GDFieldPos("MM_OP",oGetGer:aHeader)
		If (nPos1 > 0)
			SC2->(dbSetOrder(1))
			If SC2->(dbSeek(xFilial("SC2")+oGetGer:aCols[oGetGer:nAt,nPos1]))
				Reclock("SC2",.F.)
				SC2->C2_obscust := M->MM_obscus
				MsUnlock("SC2")
			Endif
		Endif
	Endif
Endif
Return lRetu 

Static Function B014Valid()
************************
LOCAL lRetu1 := .T.
Return lRetu1

Static Function B014ChgFld(nIndo,nEstou,oDlg,oFld)
*********************************************
oFld:nOption := nIndo 
If (oGetGer != Nil).and.(Len(oGetGer:aCols) > 0).and.(oGetGer:nAt > 0)
	/////////////////////////////////////////////
	If (oFld:nOption == 2).and.(n014POp > 0) //Detalhamento da OP
		c014Prods := ""
		Processa({||B014AtuDetalh(oGetGer:aCols[oGetGer:nAt,n014POp])})
	Elseif (oFld:nOption == 3).and.(n014PPro > 0) //Analise de Custos do Produto
		Processa({||B014AtuCusPr(oGetGer:aCols[oGetGer:nAt,n014PPro])})                           
	Elseif (oFld:nOption == 4) //Analise de Custos do Standard
		Processa({||B014AtuaStd()})
	Elseif (oFld:nOption == 5) //Analise de Custos Medio
		Processa({||B014AtuaMed()})
	Endif
	//////////////////////////////////////////////
Endif
oFld:Refresh(.T.)
oDlgGer:Refresh()
nEstou := nIndo
Return

Static Function B014Param1(xMostra)
*******************************
LOCAL aRegs := {}, cPerg := "BESTA0141", cArq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","Usar Custo Produto  ?","mv_ch1","N",01,0,1,"C","","MV_PAR01","Standard","","","Medio","","","Ult.Preco","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Mostrar Ordens Prod ?","mv_ch2","N",01,0,1,"C","","MV_PAR02","Todas","","","Real>Previsto","","","Previsto>Real","","","","","","","",""})
AADD(aRegs,{cPerg,"03","% Variacao Custo >  ?","mv_ch3","N",02,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Planilha de Custo   ?","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Mostrar OP's Abertas?","mv_ch5","N",01,0,1,"C","","MV_PAR05","Sim","","","Nao","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Analise Custo Stand ?","mv_ch6","N",01,0,1,"C","","MV_PAR06","Diario","","","Semanal","","","Quinzenal","","","Mensal","","","","",""})
AADD(aRegs,{cPerg,"07","Numero Period.Analis?","mv_ch7","N",02,0,0,"G","","MV_PAR07","","30","","","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs) //Brascola
If (xMostra)
	If Pergunte(cPerg,.T.)
		n014QualCusto := mv_par01
		If (n014QualCusto == 1) //Standard
			nQualCusto := 1
		Elseif (n014QualCusto == 2) //Medio
			nQualCusto := 2
		Elseif (n014QualCusto == 3) //Ultimo Preco
			nQualCusto := 7
		Endif
		n014MostraOps := mv_par02
		n014PercVaria := mv_par03
		If Empty(mv_par04)
			mv_par04 := GetMV("BR_000028") //Planilha Padrao
		Endif
		c014Planilha  := FileNoExt(Alltrim(mv_par04))
		n014OpsEncerr := mv_par05
		n014StdAnaCus := mv_par06
		n014PerAnaCus := mv_par07
		cArqMemo := "STANDARD"		
		If !Empty(c014Planilha)
			cArq := c014Planilha+".PDV"
			If !File(cArq)
				Help("",1,"BRASCOLA",,OemToAnsi("Planilha "+c014Planilha+" nao encontrada! Favor verificar."),1,0) 
				c014Planilha := Space(15)
			Else
				cArqMemo := c014Planilha
			Endif
		Endif
		If (oFldGer != Nil).and.(oFldGer:nOption == 1)
			B014Atualiza()
		Endif
	Endif
Else
	Pergunte(cPerg,.F.)
	n014QualCusto := mv_par01
	If (n014QualCusto == 1) //Standard
		nQualCusto := 1
	Elseif (n014QualCusto == 2) //Medio
		nQualCusto := 2
	Elseif (n014QualCusto == 3) //Ultimo Preco
		nQualCusto := 7
	Endif
	n014MostraOps := mv_par02
	n014PercVaria := mv_par03
	If Empty(mv_par04)
		mv_par04 := GetMV("BR_000028") //Planilha Padrao
	Endif
	c014Planilha  := FileNoExt(Alltrim(mv_par04))
	n014OpsEncerr := mv_par05
	n014StdAnaCus := mv_par06
	n014PerAnaCus := mv_par07
	cArqMemo := "STANDARD"		
	If !Empty(c014Planilha)
		cArq := c014Planilha+".PDV"
		If !File(cArq)
			Help("",1,"BRASCOLA",,OemToAnsi("Planilha "+c014Planilha+" nao encontrada! Favor verificar."),1,0) 
			c014Planilha := Space(15)
		Else
			cArqMemo := c014Planilha
		Endif
	Endif
Endif

Return

Static Function B014Param2()
*************************
LOCAL aRegs := {}, cPerg := "BESTA0142", lRetu1 := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aRegs,{cPerg,"01","Numero OP Pai De    ?","mv_ch1","C",13,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","SC2"})
AADD(aRegs,{cPerg,"02","Numero OP Pai Ate   ?","mv_ch2","C",13,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","SC2"})
AADD(aRegs,{cPerg,"03","Produto Pai De      ?","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"04","Produto Pai Ate     ?","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"05","Produto Requis. De  ?","mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"06","Produto Requis. Ate ?","mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"07","Data Requisicao De  ?","mv_ch7","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Data Requisicao Ate ?","mv_ch8","D",08,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","",""})
u_BXCriaPer(cPerg,aRegs) //Brascola
If !Pergunte(cPerg,.T.)
	lRetu1 := .F.
Endif

Return lRetu1

Static Function B014Atualiza()
**************************
LOCAL cQuery1:="", cPesq1:="", cProdAnt:="", aCols1:={}
LOCAL dDatabkp := dDatabase, nCustoP, nCustoR, nAnaHor, nAnaVer

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se foi informado algum dos parametros               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(c014Cod).and.Empty(c014NumOp).and.Empty(d014EmiDe).and.Empty(d014EmiAt)
	oGetGer:aCols := aClone(aCols1)
	oGetGer:oBrowse:Refresh()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT D3_OP,D3_COD,B1_DESC,D3_UM,SUM(D3_QUANT) D3_QUANT "
cQuery1 += "FROM "+RetSqlName("SD3")+" D3,"+RetSqlName("SB1")+" B1,"+RetSqlName("SC2")+" C2 "
cQuery1 += "WHERE D3.D_E_L_E_T_ = '' AND D3.D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery1 += "AND C2.D_E_L_E_T_ = '' AND C2.C2_FILIAL = '"+xFilial("SC2")+"' "
cQuery1 += "AND D3.D3_CF = 'PR0' AND D3.D3_ESTORNO <> 'S' AND D3.D3_COD = B1.B1_COD "
cQuery1 += "AND D3.D3_OP = C2.C2_NUM+C2.C2_ITEM+C2.C2_SEQUEN "
If !Empty(c014Cod)
	cPesq1 := Alltrim(c014Cod)
	If (Right(cPesq1,1) == "*")           
		cPesq1 := Left(cPesq1,Len(cPesq1)-1)
		cQuery1 += "AND D3_COD LIKE '"+cPesq1+"%' "
	Else
		cQuery1 += "AND D3_COD = '"+cPesq1+"' "
	Endif
Endif
If !Empty(c014NumOp)
	cPesq1 := Alltrim(c014NumOp)
	If (Right(cPesq1,1) == "*")           
		cPesq1 := Left(cPesq1,Len(cPesq1)-1)
		cQuery1 += "AND D3_OP LIKE '"+cPesq1+"%' "
	Else
		cQuery1 += "AND D3_OP = '"+cPesq1+"' "
	Endif
Endif
If !Empty(d014EmiDe)
	cQuery1 += "AND D3_EMISSAO >= '"+dtos(d014EmiDe)+"' "
Endif
If !Empty(d014EmiAt)
	cQuery1 += "AND D3_EMISSAO <= '"+dtos(d014EmiAt)+"' "
Endif
If (n014OpsEncerr == 1)
	cQuery1 += "AND C2_DATRF = '' "
Elseif (n014OpsEncerr == 2)
	cQuery1 += "AND C2_DATRF <> '' "
	If !Empty(d014EncDe)
		cQuery1 += "AND C2_DATRF >= '"+dtos(d014EncDe)+"' "
	Endif
	If !Empty(d014EncAt)
		cQuery1 += "AND C2_DATRF <= '"+dtos(d014EncAt)+"' "
	Endif
Endif
cQuery1 += "GROUP BY D3_OP,D3_COD,B1_DESC,D3_UM "
cQuery1 += "ORDER BY D3_OP,D3_COD "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
SB1->(dbSetOrder(1))
SC2->(dbSetOrder(1))
dbSelectArea("MAR")
Procregua(1)
While !MAR->(Eof())
	Incproc("> "+MAR->D3_cod)
   SB1->(dbSeek(xFilial("SB1")+MAR->D3_cod,.T.))
   SC2->(dbSeek(xFilial("SC2")+MAR->D3_op,.T.))
	dDatabase := iif(!Empty(SC2->C2_datrf),SC2->C2_datrf,dDatabkp)
   nCustoP := B014FormPrc(NIL,MAR->D3_cod,.F.)
   nCustoR := B014CustoReal(MAR->D3_op,MAR->D3_cod,MAR->D3_quant)
   If (n014MostraOps == 1).or.((n014MostraOps == 2).and.(nCustoR > nCustoP)).or.((n014MostraOps == 3).and.(nCustoP > nCustoR))
	   nAnaHor := 0
	   If (nCustoP != 0)
	   	nAnaHor := ((nCustoR/nCustoP)-1)*100
	   Endif
	   If (n014PercVaria == 0).or.(Abs(nAnaHor) >= n014PercVaria)
			nAnaVer := 0
		   If (cProdAnt == MAR->D3_cod).and.(Len(aCols1) > 0)
		   	If (aCols1[Len(aCols1),10] != 0)
					nAnaVer := ((nCustoR/aCols1[Len(aCols1),10])-1)*100
				Endif
		   Endif
		   aadd(aCols1,{MAR->D3_op,MAR->D3_cod,MAR->B1_desc,MAR->D3_um,SC2->C2_quant,MAR->D3_quant,SC2->C2_quant*nCustoP,MAR->D3_quant*nCustoR,nCustoP,nCustoR,(nCustoR-nCustoP),nAnaHor,nAnaVer,SC2->C2_datrf,SC2->C2_usuario,SC2->C2_obscust,.F.})
		Endif
	Endif
   cProdAnt := MAR->D3_cod
   If (Len(aCols1) > 500)
   	Exit
   Endif
   MAR->(dbSkip())
Enddo
dDatabase := dDatabkp
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Totalizador                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTotal := Array(4)	
aFill(aTotal,0)
For nx := 1 to Len(aCols1)
	aTotal[1] += aCols1[nx,5]
	aTotal[2] += aCols1[nx,6]
	aTotal[3] += aCols1[nx,7]
	aTotal[4] += aCols1[nx,8]
Next nx
aadd(aCols1,Array(Len(oGetGer:aHeader)+1))
nPos1 := Len(aCols1)
aFill(aCols1[nPos1],0)
aCols1[nPos1,1] := ""
aCols1[nPos1,2] := ""
aCols1[nPos1,3] := "TOTAL >"
aCols1[nPos1,4] := ""
aCols1[nPos1,5] := aTotal[1]
aCols1[nPos1,6] := aTotal[2]
aCols1[nPos1,7] := aTotal[3]
aCols1[nPos1,8] := aTotal[4]
If (aTotal[1] != 0)
	aCols1[nPos1,9] := aTotal[3]/aTotal[1]
Endif
If (aTotal[2] != 0)
	aCols1[nPos1,10]:= aTotal[4]/aTotal[2]
Endif
aCols1[nPos1,11] := (aCols1[nPos1,10]-aCols1[nPos1,9])
If (aCols1[nPos1,9] != 0)                   
	aCols1[nPos1,12] := ((aCols1[nPos1,10]/aCols1[nPos1,9])-1)*100
Endif
aCols1[nPos1,14] := ctod("//")
aCols1[nPos1,15] := ""
aCols1[nPos1,16] := ""
aCols1[nPos1,Len(oGetGer:aHeader)+1] := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Browse                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetGer:aCols := aClone(aCols1)
oGetGer:oBrowse:Refresh()
If (n014QualCusto == 1) //Standard
	c014LbCust := "CUSTO: STANDARD"
Elseif (n014QualCusto == 2) //Medio
	c014LbCust := "CUSTO: MEDIO"
Elseif (n014QualCusto == 3) //Ultimo Preco
	c014LbCust := "CUSTO: ULTIMO PRECO"
Endif
oLbCust:cCaption := c014LbCust
oLbCust:Refresh()
B014AtuOpProd() 
Eval(oFldGer:bSetOption)

Return

Static Function B014AtuOpProd()
****************************
LOCAL nPPro := 0, nPCam := 0, nLin1 := 0, _p, aCols1 := {}
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico produto do browse principal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetGer != Nil).and.(Len(oGetGer:aCols) > 0).and.(oGetGer:nAt > 0)
	nPos1 := GDFieldPos("MM_OP",oGetGer:aHeader)
	c014LbOp := "OP: "
	If (nPos1 > 0).and.!Empty(oGetGer:aCols[oGetGer:nAt,nPos1])
		c014LbOp := "OP: "+oGetGer:aCols[oGetGer:nAt,nPos1]
	Endif
	oLbOp:cCaption := c014LbOp
	oLbOp:Refresh()
	nPos1 := GDFieldPos("MM_COD",oGetGer:aHeader)
	c014LbProd := "PRODUTO: "
	If (nPos1 > 0).and.!Empty(oGetGer:aCols[oGetGer:nAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+oGetGer:aCols[oGetGer:nAt,nPos1]))
			c014LbProd := "PRODUTO: "+Alltrim(SB1->B1_cod)+" - "+Alltrim(SB1->B1_desc)
		Endif
	Endif
	oLbProd:cCaption := c014LbProd
	oLbProd:Refresh()
	n014Linha := oGetGer:nAt
	oGetGer:oBrowse:Refresh()
Endif

Return

Static Function B014AtuDetalh(xOp,xAtual)
*************************************
LOCAL cQuery1:="", cPesq1:="", cOps1:="",cRevAtu, dDatabkp:=dDatabase
LOCAL nOp, ny, nPos1, nPerda, nQuantE, nQuantP, nCusto, aCols1:={}, aOps1:={}
LOCAL cOpPai1 := Space(13), cOpPai2 := Space(13), cPrPai1 := Space(15)
LOCAL	cPrPai2 := Space(15), cPrReq1 := Space(15), cPrReq2 := Space(15)
LOCAL	dEmReq1 := ctod("//"), dEmReq2 := ctod("//")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Solicito parametros para filtrar informacoes                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(c014Prods).and.(xAtual != Nil)
	If !B014Param2()
		Return
	Endif
	cOpPai1 := mv_par01
	cOpPai2 := mv_par02
	cPrPai1 := mv_par03
	cPrPai2 := mv_par04
	cPrReq1 := mv_par05
	cPrReq2 := mv_par06
	dEmReq1 := mv_par07
	dEmReq2 := mv_par08
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes SD3                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(xOp)
	If !Empty(c014Prods).and.(xAtual != Nil)
		cQuery1 := "SELECT D3_OP,C2_PRODUTO,D3_COD,B1_DESC,D3_UM,"
	Else
		cQuery1 := "SELECT C2_PRODUTO,D3_COD,B1_DESC,D3_UM,D3_OP,"
	Endif
	cQuery1 += "SUM(CASE WHEN D3_TM>500 THEN D3_QUANT ELSE D3_QUANT*-1 END) D3_QUANT "
	cQuery1 += "FROM "+RetSqlName("SD3")+" D3,"+RetSqlName("SB1")+" B1,"+RetSqlName("SC2")+" C2 "
	cQuery1 += "WHERE D3.D_E_L_E_T_ = '' AND D3.D3_FILIAL = '"+xFilial("SD3")+"' "
	cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND D3.D3_COD = B1.B1_COD "
	cQuery1 += "AND C2.D_E_L_E_T_ = '' AND C2.C2_FILIAL = '"+xFilial("SC2")+"' AND D3.D3_OP = C2.C2_NUM+C2.C2_ITEM+C2.C2_SEQUEN "
	If !Empty(c014Prods).and.(xAtual != Nil)
		cQuery1 += "AND D3.D3_COD IN "+FormatIn(c014Prods,",")+" "
		If !Empty(cOpPai1)
			cQuery1 += "AND D3.D3_OP >= '"+cOpPai1+"' "
		Endif
		If !Empty(cOpPai1)
			cQuery1 += "AND D3.D3_OP <= '"+cOpPai2+"' "
		Endif
		If !Empty(cPrPai1)
			cQuery1 += "AND C2.C2_PRODUTO >= '"+cPrPai1+"' "
		Endif
		If !Empty(cPrPai2)
			cQuery1 += "AND C2.C2_PRODUTO <= '"+cPrPai2+"' "
		Endif
		If !Empty(cPrReq1)
			cQuery1 += "AND D3.D3_COD >= '"+cPrReq1+"' "
		Endif
		If !Empty(cPrReq2)
			cQuery1 += "AND D3.D3_COD <= '"+cPrReq2+"' "
		Endif
		If !Empty(dEmReq1)
			cQuery1 += "AND D3.D3_EMISSAO >= '"+dtos(dEmReq1)+"' "
		Endif
		If !Empty(dEmReq2)
			cQuery1 += "AND D3.D3_EMISSAO <= '"+dtos(dEmReq2)+"' "
		Endif
	Else
		//cQuery1 += "AND D3.D3_OP LIKE '"+Left(xOp,6)+"%' "
		cQuery1 += "AND D3.D3_OP = '"+xOp+"' "
	Endif
	cQuery1 += "AND D3.D3_ESTORNO <> 'S' AND D3.D3_TIPO NOT IN ('3','4') "
	cQuery1 += "AND D3.D3_CF NOT IN ('PR0','RE4','RE6','DE4','DE6') "
	If !Empty(c014Prods).and.(xAtual != Nil)
		cQuery1 += "GROUP BY D3_OP,C2_PRODUTO,D3_COD,B1_DESC,D3_UM "
		cQuery1 += "ORDER BY D3_OP,C2_PRODUTO,D3_COD "
	Else
		cQuery1 += "GROUP BY C2_PRODUTO,D3_COD,B1_DESC,D3_UM,D3_OP "
		cQuery1 += "ORDER BY C2_PRODUTO,D3_COD,D3_OP "
	Endif
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	Procregua(1)
	While !MAR->(Eof())
		Incproc("SD3 > "+MAR->D3_cod)
		nPos1 := aScan(aCols1,{|x| x[1]+x[3] == MAR->D3_op+MAR->D3_cod })
		If (nPos1 == 0)
	   	aadd(aCols1,{MAR->D3_op,MAR->C2_produto,MAR->D3_cod,MAR->B1_desc,MAR->D3_um,0,0,0,0,0,0,0,0,"",.F.})
	   	nPos1 := Len(aCols1)
	 	Endif
		dbSelectArea("SB1")
	   nCusto := QualCusto(MAR->D3_cod)
	 	aCols1[nPos1,8] += MAR->D3_quant
	 	aCols1[nPos1,11]+= MAR->D3_quant*nCusto
	 	If (aCols1[nPos1,8] != 0)
		 	aCols1[nPos1,12] := aCols1[nPos1,11]/aCols1[nPos1,8]
		Endif
	 	If (aCols1[nPos1,9] != 0)
	 		aCols1[nPos1,13] := ((aCols1[nPos1,11]/aCols1[nPos1,9])-1)*100
	 	Endif
	 	If !(Alltrim(MAR->D3_op) $ aCols1[nPos1,14])
		 	aCols1[nPos1,14] += Alltrim(MAR->D3_op)+"/"
		 	cOps1 += Alltrim(MAR->D3_op)+","
		Endif
	 	If (aScan(aOps1,MAR->D3_op) == 0)
	 		aadd(aOps1,MAR->D3_op)
	 	Endif
	   If (Len(aCols1) > 500)
	   	Exit
	   Endif
	   MAR->(dbSkip())
	Enddo
	cOps1 := Left(cOps1,Len(cOps1)-1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes SD4                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(xOp)
	If !Empty(c014Prods).and.!Empty(cOps1).and.(xAtual != Nil)
		cQuery1 := "SELECT D4_OP,C2_PRODUTO,D4_COD,B1_DESC,B1_UM,SUM(D4_QTDEORI) D4_QTDEORI "
	Else
		cQuery1 := "SELECT C2_PRODUTO,D4_COD,B1_DESC,B1_UM,D4_OP,SUM(D4_QTDEORI) D4_QTDEORI "
	Endif
	cQuery1 += "FROM "+RetSqlName("SD4")+" D4,"+RetSqlName("SB1")+" B1,"+RetSqlName("SC2")+" C2 "
	cQuery1 += "WHERE D4.D_E_L_E_T_ = '' AND D4.D4_FILIAL = '"+xFilial("SD4")+"' "
	cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND D4.D4_COD = B1.B1_COD AND B1.B1_TIPO NOT IN ('3','4') "
	cQuery1 += "AND C2.D_E_L_E_T_ = '' AND C2.C2_FILIAL = '"+xFilial("SC2")+"' AND D4.D4_OP = C2.C2_NUM+C2_ITEM+C2_SEQUEN "
	If !Empty(c014Prods).and.!Empty(cOps1).and.(xAtual != Nil)
		cQuery1 += "AND D4.D4_COD IN "+FormatIn(c014Prods,",")+" "
		cQuery1 += "AND D4.D4_OP IN "+FormatIn(cOps1,",")+" "
		If !Empty(cOpPai1)
			cQuery1 += "AND D4.D4_OP >= '"+cOpPai1+"' "
		Endif
		If !Empty(cOpPai2)
			cQuery1 += "AND D4.D4_OP <= '"+cOpPai2+"' "
		Endif
		If !Empty(cPrPai1)
			cQuery1 += "AND C2.C2_PRODUTO >= '"+cPrPai1+"' "
		Endif
		If !Empty(cPrPai2)
			cQuery1 += "AND C2.C2_PRODUTO <= '"+cPrPai2+"' "
		Endif
		If !Empty(cPrReq1)
			cQuery1 += "AND D4.D4_COD >= '"+cPrReq1+"' "
		Endif
		If !Empty(cPrReq2)
			cQuery1 += "AND D4.D4_COD <= '"+cPrReq2+"' "
		Endif
	Else
		//cQuery1 += "AND D4.D4_OP LIKE '"+Left(xOp,6)+"%' "
		cQuery1 += "AND D4.D4_OP = '"+xOp+"' "
	Endif
	If !Empty(c014Prods).and.!Empty(cOps1).and.(xAtual != Nil)
		cQuery1 += "GROUP BY D4_OP,C2_PRODUTO,D4_COD,B1_DESC,B1_UM "
		cQuery1 += "ORDER BY D4_OP,C2_PRODUTO,D4_COD "
	Else
		cQuery1 += "GROUP BY C2_PRODUTO,D4_COD,B1_DESC,B1_UM,D4_OP "
		cQuery1 += "ORDER BY C2_PRODUTO,D4_COD,D4_OP "
	Endif
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	Procregua(1)
	While !MAR->(Eof())
		Incproc("SD4 > "+MAR->D4_cod)
		nPos1 := aScan(aCols1,{|x| x[1]+x[3] == MAR->D4_op+MAR->D4_cod })
		If (nPos1 == 0)
	   	aadd(aCols1,{MAR->D4_op,MAR->C2_produto,MAR->D4_cod,MAR->B1_desc,MAR->B1_um,0,0,0,0,0,0,0,0,"",.F.})
	   	nPos1 := Len(aCols1)
	 	Endif
		dbSelectArea("SB1")
	   nCusto := QualCusto(MAR->D4_cod)
	 	aCols1[nPos1,7]  += MAR->D4_qtdeori
	 	aCols1[nPos1,10] += (MAR->D4_qtdeori*nCusto)
	 	If !(Alltrim(MAR->D4_op) $ aCols1[nPos1,14])
		 	aCols1[nPos1,14] += Alltrim(MAR->D4_op)+"/"
		Endif
	 	If (aScan(aOps1,MAR->D4_op) == 0)
	 		aadd(aOps1,MAR->D4_op)
	 	Endif
	   If (Len(aCols1) > 500)
	   	Exit
	   Endif
	   MAR->(dbSkip())
	Enddo
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes SG1                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Procregua(Len(aOps1))
For nOp := 1 to Len(aOps1)

	SC2->(dbSetOrder(1)) 
	If SC2->(dbSeek(xFilial("SC2")+aOps1[nOp]))
		Incproc("SC2 > "+SC2->C2_produto)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monto Planilha para detalhar o custo                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDatabase := iif(!Empty(SC2->C2_datrf),SC2->C2_datrf,dDatabkp)
		dbSelectArea("SB1")
		SB1->(dbSeek(xFilial("SB1")+SC2->C2_produto,.T.))
		Pergunte("MTC010",.F.) 
		nQc := nQualCusto
		aArray := MC010Forma("SB1",SB1->(Recno()),99,SC2->C2_quant)
		nQualCusto := nQc
		nMatPrima := aArray[3]
		aArray := aClone(aArray[2])
		If (Len(aArray) > 0)
			nUltNivel := CalcUltNiv()
			cNivEstr := aArray[nMatPrima-2][2]
			For nX := nMatPrima-2 To 1 Step -1
				If (Val(aArray[nX][2]) == 2)
					If !Empty(c014Prods).and.(xAtual != Nil)
						If !(Alltrim(aArray[nX,4]) $ c014Prods)
							Loop
						Elseif (!Empty(cPrReq1).and.(cPrReq1 < aArray[nX,4])).or.;
						       (!Empty(cPrReq2).and.(cPrReq2 > aArray[nX,4]))
							Loop
						Endif
					Endif
					If !SB1->(dbSeek(xFilial("SB1")+aArray[nX,4])).or.!(Left(SB1->B1_tipo,1) $ "34")
						Loop
					Endif
					nPos1 := aScan(aCols1,{|x| x[1]+x[3] == aOps1[nOp]+aArray[nX,4] })
					If (nPos1 == 0)
			   		aadd(aCols1,{aOps1[nOp],SC2->C2_produto,aArray[nX,4],SB1->B1_desc,SB1->B1_um,0,0,0,0,0,0,0,0,"",.F.})
	   				nPos1 := Len(aCols1)
				 	Endif                       
				 	aCols1[nPos1,6] += aArray[nX,5]
	 				aCols1[nPos1,9] += aArray[nX,6]
				 	If (aCols1[nPos1,9] != 0)
				 		aCols1[nPos1,13] := ((aCols1[nPos1,11]/aCols1[nPos1,9])-1)*100
			 		Endif
				 	If !(Alltrim(SC2->C2_num+SC2->C2_item+SC2->C2_sequen) $ aCols1[nPos1,14])
					 	aCols1[nPos1,14] += Alltrim(SC2->C2_num+SC2->C2_item+SC2->C2_sequen)+"/"
					Endif
			 	Endif
	   	Next nX
	   Endif      
	   
	Endif
	
Next nOp
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordenado aCols pela OP + Produto                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols1 := aSort(aCols1,,,{ |x,y| x[1]+x[3]<y[1]+y[3] })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Totalizador                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTotal := Array(6)	
aFill(aTotal,0)
For nx := 1 to Len(aCols1)
	aTotal[1] += aCols1[nx,6]
	aTotal[2] += aCols1[nx,7]
	aTotal[3] += aCols1[nx,8]
	aTotal[4] += aCols1[nx,9]
	aTotal[5] += aCols1[nx,10]
	aTotal[6] += aCols1[nx,11]
Next nx
aadd(aCols1,Array(Len(oGetDet:aHeader)+1))
nPos1 := Len(aCols1)
aFill(aCols1[nPos1],0)
aCols1[nPos1,1] := ""
aCols1[nPos1,2] := ""
aCols1[nPos1,3] := ""
aCols1[nPos1,4] := "TOTAL >"
aCols1[nPos1,5] := ""
aCols1[nPos1,6] := aTotal[1]
aCols1[nPos1,7] := aTotal[2]
aCols1[nPos1,8] := aTotal[3]
aCols1[nPos1,9] := aTotal[4]
aCols1[nPos1,10]:= aTotal[5]
aCols1[nPos1,11]:= aTotal[6]
If (aTotal[1] != 0)
	aCols1[nPos1,12] := aTotal[4]/aTotal[1]
Endif
If (aTotal[4] != 0)
	aCols1[nPos1,13] := ((aTotal[6]/aTotal[4])-1)*100
Endif
aCols1[nPos1,Len(oGetDet:aHeader)] := ""
aCols1[nPos1,Len(oGetDet:aHeader)+1] := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Browse                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetDet:aCols := aClone(aCols1)
oGetDet:oBrowse:Refresh()
dDatabase:=dDatabkp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico os produtos que devem ser filtrados                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xAtual == Nil)
	For nx := 1 to Len(oGetDet:aCols)
		If !Empty(oGetDet:aCols[nx,3])
			c014Prods += Alltrim(oGetDet:aCols[nx,3])+","
		Endif
	Next nx
	c014Prods := Left(c014Prods,Len(c014Prods)-1)
Endif

Return

Static Function B014AtuCusPr(xProduto)
*********************************
LOCAL cQuery1:="",aCols1:={},aSeries:={},dDatabkp:=dDatabase,nPos1,nPos2,nPPro,dData

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes de Custo                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetGer != Nil).and.(Len(oGetGer:aCols) > 0).and.(oGetGer:nAt > 0)
	nPPro := GDFieldPos("MM_COD",oGetGer:aHeader)
	//PRECO VENDA////////////////////////////////
	aadd(aCols1,Array(Len(oGetCus:aHeader)+1))
	nPos1 := Len(aCols1)
	aFill(aCols1[nPos1],0)
	aCols1[nPos1,1] := oGetGer:aCols[oGetGer:nAt,nPPro]
	aCols1[nPos1,2] := "PRECO LIQUIDO"
	aadd(aSeries,{})
	nPos2 := Len(aSeries)
	For nx := 3 to Len(oGetCus:aHeader)
		dData := LastDay(stod(Substr(oGetCus:aHeader[nx,2],4,6)+"01"))
		aCols1[nPos1,nx] := B014PrcLiqu(oGetGer:aCols[oGetGer:nAt,nPPro],dData)
		aadd(aSeries[nPos2],{dData,aCols1[nPos1,nx]})
	Next nx
	aCols1[nPos1,Len(oGetCus:aHeader)+1] := .F.
	//CUSTO//////////////////////////////////////
	aadd(aCols1,Array(Len(oGetCus:aHeader)+1))
	nPos1 := Len(aCols1)
	aFill(aCols1[nPos1],0)
	aCols1[nPos1,1] := Space(15)
	If (n014QualCusto == 1) //Standard
		aCols1[nPos1,2] := "CUSTO STANDARD"
	Elseif (n014QualCusto == 2) //Medio
		aCols1[nPos1,2] := "CUSTO MEDIO"
	Elseif (n014QualCusto == 3) //Ultimo Preco
		aCols1[nPos1,2] := "ULTIMO PRECO"
	Endif	
	aadd(aSeries,{})
	nPos2 := Len(aSeries)
	For nx := 3 to Len(oGetCus:aHeader)
		dData := LastDay(stod(Substr(oGetCus:aHeader[nx,2],4,6)+"01"))
		dDatabase := dData
		dbSelectArea("SB1")
		aCols1[nPos1,nx] := B014FormPrc(NIL,oGetGer:aCols[oGetGer:nAt,nPPro],.T.)
		aadd(aSeries[nPos2],{dData,aCols1[nPos1,nx]})
	Next nx
	aCols1[nPos1,Len(oGetCus:aHeader)+1] := .F.
	//MARGEM LIQUIDA//////////////////////////////////
	aadd(aCols1,Array(Len(oGetCus:aHeader)+1))
	nPos1 := Len(aCols1)
	aFill(aCols1[nPos1],0)
	aCols1[nPos1,1] := Space(15)
	aCols1[nPos1,2] := "MARGEM LIQUIDA"
	aadd(aSeries,{})
	nPos2 := Len(aSeries)
	For nx := 3 to Len(oGetCus:aHeader)
		dData := LastDay(stod(Substr(oGetCus:aHeader[nx,2],4,6)+"01"))
		aCols1[nPos1,nx] := aCols1[1,nx]-aCols1[2,nx]
		aadd(aSeries[nPos2],{dData,aCols1[nPos1,nx]})
	Next nx
	aCols1[nPos1,Len(oGetCus:aHeader)+1] := .F.
	//% MARGEM LIQUIDA////////////////////////////////
	aadd(aCols1,Array(Len(oGetCus:aHeader)+1))
	nPos1 := Len(aCols1)
	aFill(aCols1[nPos1],0)
	aCols1[nPos1,1] := Space(15)
	aCols1[nPos1,2] := "% MARGEM LIQUIDA"
	aadd(aSeries,{})
	nPos2 := Len(aSeries)
	For nx := 3 to Len(oGetCus:aHeader)
		dData := LastDay(stod(Substr(oGetCus:aHeader[nx,2],4,6)+"01"))
		If (aCols1[1,nx] != 0)
			aCols1[nPos1,nx] := ((aCols1[1,nx]-aCols1[2,nx])/aCols1[1,nx])*100
		Endif
		aadd(aSeries[nPos2],{dData,aCols1[nPos1,nx]})
	Next nx
	aCols1[nPos1,Len(oGetCus:aHeader)+1] := .F.
	/////////////////////////////////////////////
	If (Valtype(oChart) == "O")
		FreeObj(@oChart)
	Endif
	oChart := FWChartFactory():New()
	oChart := oChart:getInstance( LINECHART )
	oChart:init( oScrGrf )
	oChart:SetLegend( CONTROL_ALIGN_RIGHT )
	oChart:SetMask( "R$ *@*")
	oChart:SetPicture("@E 999,999,999,999.99")
	oChart:SetTitle(aTitle[3],CONTROL_ALIGN_ALLCLIENT)
	For nx := 1 to Len(aCols1)-1
		oChart:addSerie(aCols1[nx,2],aSeries[nx])
	Next nx
	oChart:Build()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Browse                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetCus:aCols := aClone(aCols1)
oGetCus:oBrowse:Refresh()
dDatabase:=dDatabkp

Return            

Static Function B014AtuaStd()
**************************
LOCAL cQuery1:="", cPesq1:="", aCols1:={}, nPos1, nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se foi informado algum dos parametros               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(c014StdPro).and.Empty(c014StdTip)
	oGetStd:aCols := aClone(aCols1)
	oGetStd:oBrowse:Refresh()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT Z2_PRODUTO,B1_DESC,B1_TIPO,B1_UM,Z2_DATA,Z2_CUSTD "
cQuery1 += "FROM "+RetSqlName("SZ2")+" Z2,"+RetSqlName("SB1")+" B1 "
cQuery1 += "WHERE Z2.D_E_L_E_T_ = '' AND Z2.Z2_FILIAL = '"+xFilial("SZ2")+"' "
cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery1 += "AND Z2.Z2_PRODUTO = B1.B1_COD "
If !Empty(c014StdPro)
	cPesq1 := Alltrim(c014StdPro)
	If (Right(cPesq1,1) == "*")           
		cPesq1 := Left(cPesq1,Len(cPesq1)-1)
		cQuery1 += "AND Z2.Z2_PRODUTO LIKE '"+cPesq1+"%' "
	Else
		cQuery1 += "AND Z2.Z2_PRODUTO = '"+cPesq1+"' "
	Endif
Endif
If !Empty(c014StdTip)
	cQuery1 += "AND B1.B1_TIPO = '"+c014StdTip+"' "
Endif
cQuery1 += "AND Z2.Z2_DATA BETWEEN '"+dtos(a014StdPer[1])+"' AND '"+dtos(a014StdPer[2])+"' "
cQuery1 += "ORDER BY Z2.Z2_PRODUTO,Z2.Z2_DATA "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","Z2_DATA","D",08,0)
dbSelectArea("MAR")
Procregua(1)
While !MAR->(Eof())
	Incproc("> "+MAR->Z2_produto)
	nPos1 := aScan(aCols1,{|x| x[1] == MAR->Z2_produto }) 
	If (nPos1 == 0)
		aadd(aCols1,Array(Len(oGetStd:aHeader)+1))
		nPos1 := Len(aCols1)
		aFill(aCols1[nPos1],0)
		aCols1[nPos1,1] := MAR->Z2_produto
		aCols1[nPos1,2] := MAR->B1_tipo
		aCols1[nPos1,3] := MAR->B1_um
		aCols1[nPos1,Len(oGetStd:aHeader)+1] := .F.
	Endif
	nPos2 := 0
	If (n014StdAnaCus == 1) //Diaria
		nPos2 := aScan(oGetStd:aHeader,{|x| Alltrim(Substr(x[2],4,6)) == Alltrim(Substr(dtos(MAR->Z2_data),3,6)) }) 
	Elseif (n014StdAnaCus == 2) //Semanal           
		cSemana := StrTran(RetSem(MAR->Z2_data),"/","_")
		nPos2 := aScan(oGetStd:aHeader,{|x| Alltrim(Substr(x[2],4,6)) == Alltrim(cSemana) }) 
	Elseif (n014StdAnaCus == 3) //Quinzenal
	
	Elseif (n014StdAnaCus == 4) //Mensal
		nPos2 := aScan(oGetStd:aHeader,{|x| Alltrim(Substr(x[2],4,6)) == Alltrim(Left(dtos(MAR->Z2_data),6)) }) 
	Endif
	If (nPos1 > 0).and.(nPos2 > 0)
		aCols1[nPos1,nPos2] := MAR->Z2_custd
	Endif
   MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Browse                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aCols1) > 0)
	aCols1 := aSort(aCols1,,,{ |x,y| x[1]<y[1] })
Endif
oGetStd:aCols := aClone(aCols1)
oGetStd:oBrowse:Refresh()

Return

Static Function B014AtuaMed()
**************************
LOCAL cQuery1:="", cPesq1:="", aCols1:={}, nPos1, nPos2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se foi informado algum dos parametros               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(c014MedPro).and.Empty(c014MedTip)
	oGetMed:aCols := aClone(aCols1)
	oGetMed:oBrowse:Refresh()
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Query para Buscar Informacoes                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT B9_COD,B9_LOCAL,B1_DESC,B1_TIPO,B1_UM,B9_DATA,B9_CM1 "
cQuery1 += "FROM "+RetSqlName("SB9")+" B9,"+RetSqlName("SB1")+" B1 "
cQuery1 += "WHERE B9.D_E_L_E_T_ = '' AND B9.B9_FILIAL = '"+xFilial("SB9")+"' "
cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery1 += "AND B9.B9_COD = B1.B1_COD AND B9.B9_LOCAL = B1.B1_LOCPAD "
If !Empty(c014MedPro)
	cPesq1 := Alltrim(c014MedPro)
	If (Right(cPesq1,1) == "*")           
		cPesq1 := Left(cPesq1,Len(cPesq1)-1)
		cQuery1 += "AND B9.B9_COD LIKE '"+cPesq1+"%' "
	Else
		cQuery1 += "AND B9.B9_COD = '"+cPesq1+"' "
	Endif
Endif
If !Empty(c014MedTip)
	cQuery1 += "AND B1.B1_TIPO = '"+c014MedTip+"' "
Endif
cQuery1 += "AND B9.B9_DATA BETWEEN '"+dtos(a014MedPer[1])+"' AND '"+dtos(a014MedPer[2])+"' "
cQuery1 += "ORDER BY B9.B9_COD,B9_LOCAL,B9.B9_DATA "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","B9_DATA","D",08,0)
SB2->(dbSetOrder(1))
dbSelectArea("MAR")
Procregua(1)
While !MAR->(Eof())
	Incproc("> "+MAR->B9_cod)
	nPos1 := aScan(aCols1,{|x| x[1] == MAR->B9_cod }) 
	If (nPos1 == 0)
		aadd(aCols1,Array(Len(oGetMed:aHeader)+1))
		nPos1 := Len(aCols1)
		aFill(aCols1[nPos1],0)
		aCols1[nPos1,1] := MAR->B9_cod
		aCols1[nPos1,2] := MAR->B1_tipo          
		aCols1[nPos1,3] := MAR->B1_um
		aCols1[nPos1,Len(oGetMed:aHeader)+1] := .F.
	Endif
	nPos2 := aScan(oGetMed:aHeader,{|x| Substr(x[2],4,6) == Left(dtos(MAR->B9_data),6) }) 
	If (nPos2 > 0)
		aCols1[nPos1,nPos2] := MAR->B9_cm1
	Endif                 
	nPos2 := GDFieldPos("MD_ATUAL",oGetMed:aHeader)
	If (nPos2 > 0)
		If SB2->(dbSeek(xFilial("SB2")+MAR->B9_cod+MAR->B9_local))
			aCols1[nPos1,nPos2] := SB2->B2_cm1
		Endif
	Endif
   MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Browse                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(aCols1) > 0)
	aCols1 := aSort(aCols1,,,{ |x,y| x[1]<y[1] })
Endif
oGetMed:aCols := aClone(aCols1)
oGetMed:oBrowse:Refresh()

Return

Static Function B014PrcLiqu(xProduto,xData)
**************************************
LOCAL nRetu := 0, cQuery1 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Custo de Venda medio do Mes                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT SUM(D2_QUANT) D2_QUANT,SUM(D2_TOTAL-D2_VALICM-D2_VALIMP5-D2_VALIMP6) D2_TOTAL FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF4")+" F4 "
cQuery1 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"' AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery1 += "AND D2_TES=F4_CODIGO AND F4_DUPLIC='S' AND D2_COD='"+xProduto+"' AND D2_EMISSAO BETWEEN '"+dtos(FirstDay(xData))+"' AND '"+dtos(LastDay(xData))+"' "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSD2"
dbSelectArea("MSD2")
If !MSD2->(Eof()).and.(MSD2->D2_quant > 0)
	nRetu := Round(MSD2->D2_total/MSD2->D2_quant,4)
Endif
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif

Return nRetu
      
Static Function B014FormPrc(xCols,xProduto,xPrcVen)
*********************************************
LOCAL nRetu := 0, nPos1 := 0, nPCmp, nx
If !Empty(xProduto)
	If (xCols != Nil)
		nPos1 := aScan(xCols,{|x| x[2] == xProduto })
		If (nPos1 > 0)
			nPCmp := GDFieldPos("MM_MEDPRV",oGetGer:aHeader)
			If (nPCmp > 0)
				nRetu := xCols[nPos1,nPCmp]
			Endif
		Endif
	Endif
	If (nRetu == 0)
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
			nRetu := B014CalcTot(nMatPrima,nUltNivel,99)
		Endif
	Endif
Endif
Return nRetu
                                          
Static Function B014CalcTot(nMatPrima,nUltNivel,nOpcx)
************************************************
LOCAL nX := 0, nY := 0, nCusto := 0, nTotal := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula Custos totalizando niveis                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(dbSetOrder(1))
For nX := nMatPrima-2 To 1 Step -1
	If (Val(aArray[nX,2]) != 1)
		If SB1->(dbSeek(xFilial("SB1")+aArray[nX,4])).and.!(Left(SB1->B1_tipo,1) $ "3/4")
			nCusto := QualCusto(aArray[nX,4])
			nTotal += aArray[nX,5]*nCusto
		Endif
	Endif
Next nX

Return nTotal
                          
Static Function B014CustoReal(xOp,xProduto,xQuant)
********************************************
LOCAL nRetu := 0, nCusto := 0, cQuery1 := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco Custo Real                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT D3_OP,D3_COD,B1_DESC,D3_UM,"
cQuery1 += "SUM(CASE WHEN D3_TM>500 THEN D3_QUANT ELSE D3_QUANT*-1 END) D3_QUANT "
cQuery1 += "FROM "+RetSqlName("SD3")+" D3,"+RetSqlName("SB1")+" B1 "
cQuery1 += "WHERE D3.D_E_L_E_T_ = '' AND D3.D3_FILIAL = '"+xFilial("SD3")+"' "
cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' AND D3.D3_COD = B1.B1_COD "
cQuery1 += "AND D3.D3_OP = '"+xOp+"' AND D3.D3_ESTORNO <> 'S' AND D3.D3_CF NOT IN ('PR0','RE4','RE6','DE4','DE6') "
cQuery1 += "GROUP BY D3_OP,D3_COD,B1_DESC,D3_UM "
cQuery1 += "ORDER BY D3_OP,D3_COD "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MSD3") <> 0)
	dbSelectArea("MSD3")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MSD3"
dbSelectArea("MSD3")
Procregua(1)
While !MSD3->(Eof())
	dbSelectArea("SB1")
   nCusto := QualCusto(MSD3->D3_cod)
	nRetu += MSD3->D3_quant*nCusto
	MSD3->(dbSkip())
Enddo
If (xQuant != 0)
	nRetu := nRetu/xQuant
Endif
If (Select("MSD3") <> 0)
	dbSelectArea("MSD3")
	dbCloseArea()
Endif

Return nRetu

Static Function B014ConKardex(xGet,xCols,xAt)
****************************************
LOCAL nPPro := 0, nPCam := 0

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

Static Function B014ConView(xGet,xCols,xAt)
***************************************
LOCAL nPPro := 0, nPCam := 0

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

Static Function B014ConForma(xGet,xCols,xAt)
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

Static Function B014Estoque()
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
Set Key VK_F4 TO B014Estoque()

Return

Static Function B014Historico(xGet,xCols,xAt,xTipo)
**********************************************
LOCAL nPos1 := 0, nPCam := 0
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	If (xTipo == 1) //OP
		nPos1 := GDFieldPos("MM_OP",xGet:aHeader)
		If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
			SC2->(dbSetOrder(1))
			If SC2->(dbSeek(xFilial("SC2")+xCols[xAt,nPos1]))
				If ExistBlock("GDVHISTMAN") //Verifico rotina GDVHISTMAN
					u_GDVHistMan("SC2",.T.)
				Endif
			Endif
		Endif
	Elseif (xTipo == 2) //Produto
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
Endif
Return      

Static Function B014Produto(xGet,xCols,xAt)
***************************************
LOCAL nPos1 := 0, nPCam := 0, aCampos := {"MM_COD","DD_COD","CC_COD"}
If (xGet != Nil).and.(Len(xCols) > 0).and.(xAt > 0)
	For nn := 1 to Len(aCampos)
		nPos1 := GDFieldPos(aCampos[nn],xGet:aHeader)
		If (nPos1 > 0)
			Exit
		Endif
	NExt nn
	If (nPos1 > 0).and.!Empty(xCols[xAt,nPos1])
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+xCols[xAt,nPos1]))
			If ExistBlock("GDVA010") //Verifico rotina GDView Produto
				MsgRun('GDView Produto. Aguarde... ','',{ || u_GDVA010() })
			Endif
		Endif
	Endif
Endif
Return      

Static Function B014Say(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xColor)
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

Static Function B014Get(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xChange,xPicture,xF3)
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

Static Function B014Button(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xAction)
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

Static Function B014Combo(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xItens,xChange)
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

Static Function B014ZeraCols(xHeader,xCols)
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

Static Function B014CorDados(xHeader,xCols,xAt)
******************************************
LOCAL nRetu := RGB(250,250,250)
LOCAL nPCmp := GDFieldPos("MM_MEDPRV",xHeader)
LOCAL nPCmr := GDFieldPos("MM_MEDREA",xHeader)
If (xAt > 0)
	If (xCols[xAt,Len(xHeader)+1])
		nRetu := RGB(128,128,128) //Inativo
	Elseif (n014Linha == xAt)
		nRetu := RGB(230,245,245) //Selecionado
	Elseif (xCols[xAt,nPCmp]>0).and.(xCols[xAt,nPCmr]>0).and.(xCols[xAt,nPCmr]>xCols[xAt,nPCmp])
		nRetu := RGB(255,225,195) 
	Endif
Endif
Return nRetu

Static Function B014CorDdStd(xHeader,xCols,xAt)
******************************************
LOCAL nRetu := RGB(250,250,250)
If (xAt > 0).and.(n014StdLin == xAt)
	nRetu := RGB(230,245,245) //Selecionado
Endif
Return nRetu

Static Function B014CorDdMed(xHeader,xCols,xAt)
******************************************
LOCAL nRetu := RGB(250,250,250)
If (xAt > 0).and.(n014MedLin == xAt)
	nRetu := RGB(230,245,245) //Selecionado
Endif
Return nRetu

Static Function B014ExpExcel()
***************************
LOCAL cDirDocs := MsDocPath() 
LOCAL cArquivo := CriaTrab(,.F.)
LOCAL cPath		:= AllTrim(GetTempPath())
LOCAL cCrLf 	:= Chr(13) + Chr(10)
LOCAL aStru, oExcelApp, nHandle, nX, nY
xHeader := aClone(oGetGer:aHeader)
xCols := aClone(oGetGer:aCols)  
If (oFldGer:nOption == 2) //Detalhamento da OP
	xHeader := aClone(oGetDet:aHeader)
	xCols := aClone(oGetDet:aCols)  
Elseif (oFldGer:nOption == 3) //Analise de Custos do Produto
	xHeader := aClone(oGetCus:aHeader)
	xCols := aClone(oGetCus:aCols)  
Elseif (oFldGer:nOption == 4) //Analise de Custos do Standard
	xHeader := aClone(oGetStd:aHeader)
	xCols := aClone(oGetStd:aCols)  
Elseif (oFldGer:nOption == 5) //Analise de Custos Medio
	xHeader := aClone(oGetMed:aHeader)
	xCols := aClone(oGetMed:aCols)  
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
	If ! ApOleClient('MsExcel')
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