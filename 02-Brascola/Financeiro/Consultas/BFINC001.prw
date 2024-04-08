#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"        
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "dbtree.ch"

#define MTAMTOT 12
#define MSALATU 1
#define MARECEB 2
#define MAPAGAR 3
#define MPRPAAN 4
#define MFOMENT 5
#define MSALFIN 6
#define MFATDIA 7
#define MPEDPEN 8
#define MEMPROC 9
#define MPRPERD 10                                            
#define MPAGATR 11
#define MSLDREA 12

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFINC001 ºAutor  ³ Marcelo da Cunha   º Data ³  26/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta Financeira Brascola                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFINC001()
*********************
PRIVATE oDlgFin, oGetFin, oBold, oFolder, aCampos, aHeader, aCols, aButtons, dData
PRIVATE c002CliDe, c002CliAt, c002CloDe, c002CloAt, c002ForDe, c002ForAt, c002FloDe, c002FloAt
PRIVATE d002Data, d002DtFim, a002TpPed, c002TpPed, c002Simb1
PRIVATE aTitle, aPage, aCampos, nOpcm, cCadastro := "Consulta Financeira Brascola"
PRIVATE oOk := LoadBitmap( GetResources(), "LBOK" ), oNo := LoadBitmap( GetResources(), "LBNO" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
                                             
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BRASCOLA - PE para gravar informacoes de acesso              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
u_BCFGA002("BFINC001") //Grava detalhes da rotina usada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas pelo programa                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRotina := {{"","",0,1},{"","",0,2},{"","",0,3}}
aButtons:= {} ; INCLUI := .F. ; ALTERA := .F.
d002Data := dDatabase
c002CliDe := Space(TamSX3("A1_COD")[1])
c002CliAt := Replicate("z",TamSX3("A1_COD")[1])
c002CloDe := Space(TamSX3("A1_LOJA")[1])
c002CloAt := Replicate("z",TamSX3("A1_LOJA")[1])
c002ForDe := Space(TamSX3("A2_COD")[1])
c002ForAt := Replicate("z",TamSX3("A2_COD")[1])
c002FloDe := Space(TamSX3("A2_LOJA")[1])
c002FloAt := Replicate("z",TamSX3("A2_LOJA")[1])
a002TpPed := {"1=Liberados","2=Bloqueados","3=Ambos"}
c002TpPed := a002TpPed[1]
c002Simb1 := GetMV("MV_SIMB1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializo aHeader                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{" " ,"MM_TIPO" ,"",30,0,"","","C","",""})
d002DtFim := d002Data
For nx := 1 to 20
	aadd(aHeader,{dtoc(d002DtFim),"MM_"+Substr(dtos(d002DtFim),3,8),"@E 999,999,999.99",14,2,"","","N","",""})
	d002DtFim := d002DtFim+1
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Consulta                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0,  45, .T., .F. })
AAdd(aObjects,{  0, 220, .T., .T. })
AAdd(aObjects,{  0,  75, .T., .F. })
AAdd(aObjects,{  0,  22, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgFin FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[1,1],aPosObj[1,2] SAY Upper(cCadastro)+": "+dtoc(dDataBase) OF oDlgFin PIXEL SIZE 245,9 FONT oBold
@ aPosObj[1,1]+14,aPosObj[1,2] TO aPosObj[1,1]+15,(aPosObj[1,4]-aPosObj[1,2]) LABEL "" OF oDlgFin PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtros da consulta                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGrpFil := tGroup():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],"Filtros",oDlgFin,NIL,,.T.)
oGrpFil:oFont := oBold
oSayFin1 := B002Say(oDlgFin,"oSayFin1","A Partir De:",010,aPosObj[2,1]+12)
oGetFin1 := B002Get(oDlgFin,"d002Data","d002Data",045,aPosObj[2,1]+10,50,,{|| .T. },"@E")
oGetFin1:bValid := {|| d002Data>=dDatabase }
oSayFin2 := B002Say(oDlgFin,"oSayFin2","Cliente De:",115,aPosObj[2,1]+12)
oGetFin21:= B002Get(oDlgFin,"c002CliDe","c002CliDe",145,aPosObj[2,1]+10,050,,{|| .T. },,"SA1")
oGetFin22:= B002Get(oDlgFin,"c002CloDe","c002CloDe",195,aPosObj[2,1]+10,030,,{|| .T. })
oSayFin3 := B002Say(oDlgFin,"oSayFin3","Cliente Ate:",240,aPosObj[2,1]+12)
oGetFin31:= B002Get(oDlgFin,"c002CliAt","c002CliAt",270,aPosObj[2,1]+10,060,,{|| .T. },,"SA1")
oGetFin32:= B002Get(oDlgFin,"c002CloAt","c002CloAt",330,aPosObj[2,1]+10,030,,{|| .T. })
oSayFin4 := B002Say(oDlgFin,"oSayFin4","Pedidos:",010,aPosObj[2,1]+28)
oComFin4 := B002Combo(oDlgFin,"c002TpPed","c002TpPed",045,aPosObj[2,1]+26,60,,a002TpPed,{|| .T. })
oSayFin5 := B002Say(oDlgFin,"oSayFin5","Fornec.De:",115,aPosObj[2,1]+28)
oGetFin51:= B002Get(oDlgFin,"c002ForDe","c002ForDe",145,aPosObj[2,1]+26,050,,{|| .T. },,"SA2")
oGetFin52:= B002Get(oDlgFin,"c002FloDe","c002FloDe",195,aPosObj[2,1]+26,030,,{|| .T. })
oSayFin6 := B002Say(oDlgFin,"oSayFin6","Fornec.Ate:",240,aPosObj[2,1]+28)
oGetFin61:= B002Get(oDlgFin,"c002ForAt","c002ForAt",270,aPosObj[2,1]+26,060,,{|| .T. },,"SA2")
oGetFin62:= B002Get(oDlgFin,"c002FloAt","c002FloAt",330,aPosObj[2,1]+26,030,,{|| .T. })
oButAtu1 := B002Button(oDlgFin,"oButAtu1","Mapa Operacional",370,aPosObj[2,1]+10,70,24,{|| u_BFATC001() })
oButAtu2 := B002Button(oDlgFin,"oButAtu2","ATUALIZA",450,aPosObj[2,1]+10,50,24,{|| B002AtuDados() })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Browse com Fluxo de Caixa                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {} ; B002ZeraCols(@aHeader,@aCols)
oGetFin := MsNewGetDados():New(aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4],0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgFin,aHeader,aCols)
oGetFin:oBrowse:Default()
oGetFin:oBrowse:bLDblClick := {||B002DetFluxo(oGetFin:nAt,oGetFin:oBrowse:nColPos)}
oGetFin:oBrowse:lUseDefaultColors := .F.
oGetFin:oBrowse:SetBlkBackColor({||B002CorFin(oGetFin:aHeader,oGetFin:aCols,oGetFin:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indicadores da Consulta                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGrpPag := tGroup():New(aPosObj[4,1],aPosObj[4,2],aPosObj[4,3],aPosObj[4,4]/2-5,"Detalhes Contas a Pagar",oDlgFin,NIL,,.T.)
oGrpPag:oFont := oBold
oSayPag1 := B002Say(oDlgFin,"oSayPag1","Pagamento Antecipado:",aPosObj[4,2]+10,aPosObj[4,1]+12,70)
oSayPag1v:= B002Say(oDlgFin,"oSayPag1v","",aPosObj[4,2]+80,aPosObj[4,1]+12,150)
oSayPag2 := B002Say(oDlgFin,"oSayPag2","Provisão:",aPosObj[4,2]+10,aPosObj[4,1]+22,70)
oSayPag2v:= B002Say(oDlgFin,"oSayPag2v","",aPosObj[4,2]+80,aPosObj[4,1]+22,150)
oSayPag3 := B002Say(oDlgFin,"oSayPag3","Notas:",aPosObj[4,2]+10,aPosObj[4,1]+32,70)
oSayPag3v:= B002Say(oDlgFin,"oSayPag3v","",aPosObj[4,2]+80,aPosObj[4,1]+32,150)
oSayPag4 := B002Say(oDlgFin,"oSayPag4","Impostos:",aPosObj[4,2]+10,aPosObj[4,1]+42,70)
oSayPag4v:= B002Say(oDlgFin,"oSayPag4v","",aPosObj[4,2]+80,aPosObj[4,1]+42,150)
oSayPag5 := B002Say(oDlgFin,"oSayPag5","Parcelamento:",aPosObj[4,2]+10,aPosObj[4,1]+52,70)
oSayPag5v:= B002Say(oDlgFin,"oSayPag5v","",aPosObj[4,2]+80,aPosObj[4,1]+52,150)
oSayPag6 := B002Say(oDlgFin,"oSayPag6","Divida Ativa:",aPosObj[4,2]+10,aPosObj[4,1]+62,70)
oSayPag6v:= B002Say(oDlgFin,"oSayPag6v",":",aPosObj[4,2]+80,aPosObj[4,1]+62,150)
oSayPag7 := B002Say(oDlgFin,"oSayPag7","Despesas com Folha:",aPosObj[4,2]+150,aPosObj[4,1]+12,70)
oSayPag7v:= B002Say(oDlgFin,"oSayPag7v","",aPosObj[4,2]+210,aPosObj[4,1]+12,150)
oSayPag8 := B002Say(oDlgFin,"oSayPag8","Emprestimos:",aPosObj[4,2]+150,aPosObj[4,1]+22,70)
oSayPag8v:= B002Say(oDlgFin,"oSayPag8v","",aPosObj[4,2]+210,aPosObj[4,1]+22,150)
oSayPag9 := B002Say(oDlgFin,"oSayPag9","Nota Debito Fornec.:",aPosObj[4,2]+150,aPosObj[4,1]+32,70)
oSayPag9v:= B002Say(oDlgFin,"oSayPag9v","",aPosObj[4,2]+210,aPosObj[4,1]+32,150)
oSayPagA := B002Say(oDlgFin,"oSayPagA","Outros:",aPosObj[4,2]+150,aPosObj[4,1]+42,70)
oSayPagAv:= B002Say(oDlgFin,"oSayPagAv","",aPosObj[4,2]+210,aPosObj[4,1]+42,150)
oSayPagB := B002Say(oDlgFin,"oSayPagB","Rec.Judicial:",aPosObj[4,2]+150,aPosObj[4,1]+52,70)
oSayPagBv:= B002Say(oDlgFin,"oSayPagBv","",aPosObj[4,2]+210,aPosObj[4,1]+52,150)
oSayPagC := B002Say(oDlgFin,"oSayPagC","Total Geral:",aPosObj[4,2]+150,aPosObj[4,1]+62,70)
oSayPagCv:= B002Say(oDlgFin,"oSayPagCv","",aPosObj[4,2]+210,aPosObj[4,1]+62,150)
oGrpRec := tGroup():New(aPosObj[4,1],aPosObj[4,4]/2+5,aPosObj[4,3],aPosObj[4,4],"Detalhes Contas a Receber",oDlgFin,NIL,,.T.)
oGrpRec:oFont := oBold
oSayRec1 := B002Say(oDlgFin,"oSayRec1","NF Carteira:",aPosObj[4,4]/2+15,aPosObj[4,1]+12,70)
oSayRec1v:= B002Say(oDlgFin,"oSayRec1v","",aPosObj[4,4]/2+85,aPosObj[4,1]+12,150)
oSayRec2 := B002Say(oDlgFin,"oSayRec2","NF Cobrança Simples:",aPosObj[4,4]/2+15,aPosObj[4,1]+22,70)
oSayRec2v:= B002Say(oDlgFin,"oSayRec2v","",aPosObj[4,4]/2+85,aPosObj[4,1]+22,150)
oSayRec3 := B002Say(oDlgFin,"oSayRec3","NF Cobrança Registrada:",aPosObj[4,4]/2+15,aPosObj[4,1]+32,70)
oSayRec3v:= B002Say(oDlgFin,"oSayRec3v","",aPosObj[4,4]/2+85,aPosObj[4,1]+32,150)
oSayRec4 := B002Say(oDlgFin,"oSayRec4","NF Desconto:",aPosObj[4,4]/2+15,aPosObj[4,1]+42,70)
oSayRec4v:= B002Say(oDlgFin,"oSayRec4v","",aPosObj[4,4]/2+85,aPosObj[4,1]+42,150)
oSayRec5 := B002Say(oDlgFin,"oSayRec5","NF Caucionada:",aPosObj[4,4]/2+15,aPosObj[4,1]+52,70)
oSayRec5v:= B002Say(oDlgFin,"oSayRec5v","",aPosObj[4,4]/2+85,aPosObj[4,1]+52,150)
oSayRec6 := B002Say(oDlgFin,"oSayRec6","NF Protesto:",aPosObj[4,4]/2+15,aPosObj[4,1]+62,70)
oSayRec6v:= B002Say(oDlgFin,"oSayRec6v","",aPosObj[4,4]/2+85,aPosObj[4,1]+62,150)
oSayRec7 := B002Say(oDlgFin,"oSayRec7","NF Cartório:",aPosObj[4,4]/2+147,aPosObj[4,1]+12,70)
oSayRec7v:= B002Say(oDlgFin,"oSayRec7v","",aPosObj[4,4]/2+207,aPosObj[4,1]+12,150)
oSayRec8 := B002Say(oDlgFin,"oSayRec8","Titulos em Negociação:",aPosObj[4,4]/2+147,aPosObj[4,1]+22,70)
oSayRec8v:= B002Say(oDlgFin,"oSayRec8v","",aPosObj[4,4]/2+207,aPosObj[4,1]+22,150)
oSayRec9 := B002Say(oDlgFin,"oSayRec9","NCC:",aPosObj[4,4]/2+147,aPosObj[4,1]+32,70)
oSayRec9v:= B002Say(oDlgFin,"oSayRec9v","",aPosObj[4,4]/2+207,aPosObj[4,1]+32,150)
oSayRecA := B002Say(oDlgFin,"oSayRecA","RA:",aPosObj[4,4]/2+147,aPosObj[4,1]+42,70)
oSayRecAv:= B002Say(oDlgFin,"oSayRecAv","",aPosObj[4,4]/2+207,aPosObj[4,1]+42,150)
oSayRecB := B002Say(oDlgFin,"oSayRecB","Prov.Perdas Receb.:",aPosObj[4,4]/2+147,aPosObj[4,1]+52,70)
oSayRecBv:= B002Say(oDlgFin,"oSayRecBv","",aPosObj[4,4]/2+207,aPosObj[4,1]+52,150)
oSayRecC := B002Say(oDlgFin,"oSayRecC","Total Geral:",aPosObj[4,4]/2+147,aPosObj[4,1]+62,70)
oSayRecCv:= B002Say(oDlgFin,"oSayRecCv","",aPosObj[4,4]/2+207,aPosObj[4,1]+62,150)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botoes de Consulta                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oButFin1 := B002Button(oDlgFin,"oButFin1","Maiores Devedores"      ,010,aPosObj[5,1],70,,{|| FINR300() })
oButFin2 := B002Button(oDlgFin,"oButFin2","Maiores Credores"       ,080,aPosObj[5,1],70,,{|| FINR330() })
oButFin3 := B002Button(oDlgFin,"oButFin3","Posição Cliente"        ,150,aPosObj[5,1],70,,{|| FINR340() })
oButFin4 := B002Button(oDlgFin,"oButFin4","Posição Fornecedores"   ,220,aPosObj[5,1],70,,{|| FINR350() })
oButFin5 := B002Button(oDlgFin,"oButFin5","Posição Geral Cobrança" ,290,aPosObj[5,1],70,,{|| FINR320() })
oButFin6 := B002Button(oDlgFin,"oButFin6","Relação Cheques"        ,360,aPosObj[5,1],70,,{|| FINR400() })
oButFin7 := B002Button(oDlgFin,"oButFin7","Eficiência Cobrança"    ,430,aPosObj[5,1],70,,{|| FINR750() })
oButFin8 := B002Button(oDlgFin,"oButFin8","Eficiência C.Pagar"     ,010,aPosObj[5,1]+12,70,,{|| FINR760() })
oButFin9 := B002Button(oDlgFin,"oButFin9","Títulos a Receber"      ,080,aPosObj[5,1]+12,70,,{|| FINR130() })
oButFinA := B002Button(oDlgFin,"oButFinA","Títulos a Pagar"        ,150,aPosObj[5,1]+12,70,,{|| FINR150() })
oButFinB := B002Button(oDlgFin,"oButFinB","Movim. Mês a Mês"       ,220,aPosObj[5,1]+12,70,,{|| FINR801() })
oButFinC := B002Button(oDlgFin,"oButFinC","Extrato Bancário"       ,290,aPosObj[5,1]+12,70,,{|| FINR470() })
oButFinD := B002Button(oDlgFin,"oButFinD","Relação de Baixas"      ,360,aPosObj[5,1]+12,70,,{|| FINR190() })
oButFinE := B002Button(oDlgFin,"oButFinE","Mapa Rateio CC"         ,430,aPosObj[5,1]+12,70,,{|| FINR195() })
oButFec1 := B002Button(oDlgFin,"oButFec1","FECHAR",510,aPosObj[5,1],50,24,{|| oDlgFin:End() })

ACTIVATE MSDIALOG oDlgFin CENTERED //ON INIT EnchoiceBar(oDlgFin,{|| (nOpcm:=1,oDlgFin:End()) },{|| (nOpcm:=0,oDlgFin:End()) },,aButtons)

Return

Static Function B002AtuDados()
***************************
LOCAL nx, cQuery1 := {}, aCols1 := {}, nLin1 := 0, nMoeda1, dData1, nValRePerda := 0
LOCAL nValPagAnt := 0, nValPrevis := 0, nValNotas := 0, nValImpost := 0, nValComis := 0
LOCAL nValFolha := 0, nValCheque := 0, nValEmpres := 0, nValNFCarte := 0, nValReGeral := 0
LOCAL nValNFSimp := 0, nValNFCobr := 0, nValNFDesc := 0, nValNFCauc := 0, nValNFProt := 0
LOCAL nValNFCarto := 0, nValPgOutr := 0, nValRecNCC := 0, nValRecRA := 0, nValParcel := 0
LOCAL nValDivAti := 0, nValNDFFor := 0, nValRecJur := 0, nValPgGeral := 0, nValTitNeg := 0
LOCAL cBrCfFat := u_BXLstCfTes("BR_CFFAT"), cBrCfNFat := u_BXLstCfTes("BR_CFNFAT")
LOCAL cBrTsFat := u_BXLstCfTes("BR_TSFAT"), cBrTsNFat := u_BXLstCfTes("BR_TSNFAT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo aHeader de acordo com a data                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
d002DtFim := d002Data
aHeader := aClone(oGetFin:aHeader)
For nx := 2 to Len(oGetFin:oBrowse:aColumns)
	aHeader[nx,1] := dtoc(d002DtFim)
	aHeader[nx,2] := "MM_"+Substr(dtos(d002DtFim),3,8)
	oGetFin:oBrowse:aColumns[nx]:cHeading := aHeader[nx,1]
	If (nx == 1)
		oGetFin:oBrowse:aColumns[nx]:BackColor := CLR_GREEN
	Endif
	d002DtFim := d002DtFim+1
Next nx
oGetFin:aHeader := aClone(aHeader)
oGetFin:ForceRefresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Variavel aCols                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols1 := {}
For nx := 1 to MTAMTOT
	aadd(aCols1,Array(Len(oGetFin:aHeader)+1))
	nLin1 := Len(aCols1)
	aFill(aCols1[nLin1],0)
	aCols1[nLin1,1] := Space(20)
	aCols1[nLin1,Len(oGetFin:aHeader)+1] := .F.
Next nx
aCols1[MSALATU,1] := "Saldo Atual"
aCols1[MARECEB,1] := "A Receber  "
aCols1[MAPAGAR,1] := "A Pagar    "
aCols1[MPRPAAN,1] := "Provisao de Pagamento"
aCols1[MFOMENT,1] := "Fomento"
aCols1[MSALFIN,1] := "Saldo Final"
aCols1[MFATDIA,1] := "Faturamento do Dia"
aCols1[MPEDPEN,1] := "Pedidos Pendentes"
aCols1[MEMPROC,1] := "Em Processo Cobrança"
aCols1[MPRPERD,1] := "Provisao de Perda Recebiveis"
aCols1[MPAGATR,1] := "Pagamentos em Atraso"
aCols1[MSLDREA,1] := "Saldo Final Real"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes de Bancos                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos1 := B002PosCol(d002Data)
If (nPos1 > 0)
	cQuery1 := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_MOEDA,A6_SALATU FROM "+RetSqlName("SA6")+" A6 "
	cQuery1 += "WHERE A6.D_E_L_E_T_ = '' AND A6.A6_FILIAL = '"+xFilial("SA6")+"' "
	cQuery1 += "AND A6_FLUXCAI = 'S' AND A6_MSBLQL <> '1' AND A6_SALATU <> 0 "
	cQuery1 += "ORDER BY A6_COD,A6_AGENCIA,A6_NUMCON "
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	SE8->(dbSetOrder(1))
	dbSelectArea("MAR")
	While !MAR->(Eof())
		nMoeda1 := Max(MAR->A6_moeda,1)
		aCols1[MSALATU,nPos1] += Round(xMoeda(MAR->A6_salatu,nMoeda1,1,dDatabase),2)
		MAR->(dbSkip())
	Enddo
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif 
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes do Contas a Receber                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT E1_TIPO,E1_SITUACA,E1_PORTADO,E1_VENCREA,E1_MOEDA,SUM(E1_SALDO) E1_SALDO FROM "+RetSqlName("SE1")+" E1 "
cQuery1 += "WHERE E1.D_E_L_E_T_ = '' AND E1_SALDO > 0 "
cQuery1 += "AND E1_CLIENTE BETWEEN '"+c002CliDe+"' AND '"+c002CliAt+"' "
cQuery1 += "AND E1_LOJA BETWEEN '"+c002CloDe+"' AND '"+c002CloAt+"' "
cQuery1 += "GROUP BY E1_TIPO,E1_SITUACA,E1_PORTADO,E1_VENCREA,E1_MOEDA "
cQuery1 += "ORDER BY E1_TIPO,E1_SITUACA,E1_PORTADO,E1_VENCREA "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","E1_VENCREA","D",08,0)
dbSelectArea("MAR")
While !MAR->(Eof())
	nMoeda1 := Max(MAR->E1_moeda,1)
	If (MAR->E1_portado == "981") //Provisao Perda Recebiveis
		nPos1 := B002PosCol(d002Data)
		If (nPos1 > 0)
			aCols1[MPRPERD,nPos1] += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,d002Data),2)
		Endif
		nValRePerda += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,d002Data),2)
	Else	
		If (MAR->E1_vencrea < d002Data)
			nPos1 := B002PosCol(d002Data)
			If (nPos1 > 0).and.(Alltrim(MAR->E1_tipo) == "NF")
				aCols1[MEMPROC,nPos1] += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,d002Data),2)
			Endif
		Else
			nPos1 := B002PosCol(MAR->E1_vencrea)
			If (nPos1 > 0).and.(MAR->E1_situaca != "2") //Nao Considerar Cobranca Descontada
				aCols1[MARECEB,nPos1] += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			Endif
		Endif
	Endif
	If (MAR->E1_portado == "999") //Titulos Em Negociacao 
		nValTitNeg += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)*iif(MAR->E1_tipo$"NCC/RA ",-1,1)
		nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)*iif(MAR->E1_tipo$"NCC/RA ",-1,1)
	Elseif !(MAR->E1_portado $ "980/981") //Exceto Tiulos para Cancelamento
		If (MAR->E1_tipo == "NCC")
			nValRecNCC += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_tipo == "RA ")
			nValRecRA  += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca $ "0 ") //Carteira
			nValNFCarte+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "1") //Cobranca Simples
			nValNFSimp += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "2") //Cobranca Descontada
			nValNFDesc += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "3") //Cobranca Caucionada
			nValNFCauc += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "7") //Cobranca Caucao Descontada
			nValNFCobr += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "F") //Cobranca Carteira Protesto
			nValNFProt += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Elseif (MAR->E1_situaca == "H") //Cobranca Cartorio
			nValNFCarto+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Else 
			nValRcOutr += Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
			nValReGeral+= Round(xMoeda(MAR->E1_saldo,nMoeda1,1,MAR->E1_vencrea),2)
		Endif
	Endif
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes do Contas a Pagar                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT E2_PREFIXO,E2_TIPO,E2_NATUREZ,E2_VENCREA,E2_MOEDA,E2_TXMOEDA,"
cQuery1 += "SUM(E2_VALOR) E2_VALOR,SUM(E2_SALDO) E2_SALDO,SUM(E2_ACRESC) E2_ACRESC,SUM(E2_DECRESC) E2_DECRESC "
cQuery1 += "FROM "+RetSqlName("SE2")+" E2 WHERE E2.D_E_L_E_T_ = '' AND E2_SALDO > 0 "
cQuery1 += "AND E2_FORNECE BETWEEN '"+c002ForDe+"' AND '"+c002ForAt+"' AND E2_LOJA BETWEEN '"+c002FloDe+"' AND '"+c002FloAt+"' "
cQuery1 += "GROUP BY E2_PREFIXO,E2_TIPO,E2_NATUREZ,E2_VENCREA,E2_MOEDA,E2_TXMOEDA ORDER BY E2_PREFIXO,E2_TIPO,E2_NATUREZ,E2_VENCREA "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","E2_VENCREA","D",08,0)
dbSelectArea("MAR")
While !MAR->(Eof())
	nMoeda1 := Max(MAR->E2_moeda,1)
	dData1 := MAR->E2_vencrea
	//If (dData1 < d002Data)
	//	dData1 := d002Data
	//Endif
	nVal1 := Round(xMoeda(MAR->E2_saldo,nMoeda1,1,dData1),2)
	If (nVal1 == 0).and.(nMoeda1 != 1).and.(MAR->E2_txmoeda > 0)
		nVal1 := Round(MAR->E2_saldo*MAR->E2_txmoeda,2)
	Endif
	If (dData1 < d002Data).and.!(MAR->E2_tipo $ "PA /PR ") 
		nPos1 := B002PosCol(d002Data)    
		If (nPos1 > 0)
			aCols1[MPAGATR,nPos1] += nVal1
		Endif
	Else
		nPos1 := B002PosCol(dData1)
		If (nPos1 > 0).and.!(MAR->E2_tipo $ "PA /PR ")
			aCols1[MAPAGAR,nPos1] += nVal1
		Endif
	Endif
	If (Alltrim(MAR->E2_naturez) >= "24001").and.(Alltrim(MAR->E2_naturez) <=  "24100").and.!(MAR->E2_tipo $ "PA /PI /PR /RJ ") //Folha
		nValFolha  += nVal1
		nValPgGeral+= nVal1
	Elseif (Alltrim(MAR->E2_naturez) >= "41001").and.(Alltrim(MAR->E2_naturez) <=  "43100").and.!(MAR->E2_tipo $ "DA /PI /PRO") //Impostos e Taxas
		nValImpost += nVal1*iif(MAR->E2_tipo=="NDF",-1,1)
		nValPgGeral+= nVal1*iif(MAR->E2_tipo=="NDF",-1,1)
	Elseif (MAR->E2_tipo == "PA ") //Pagamento Antecipado
		nValPagAnt += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo == "PR ")
		If (MAR->E2_vencrea < d002Data)
			nPos1 := B002PosCol(d002Data)
			If (nPos1 > 0)
				If (MAR->E2_prefixo == "COM") //Previsao Fomento
					aCols1[MFOMENT,nPos1] += nVal1
				Else //Provisao Pagamento Antecipado
					aCols1[MPRPAAN,nPos1] += nVal1
				Endif
			Endif
		Else
			nPos1 := B002PosCol(MAR->E2_vencrea)
			If (nPos1 > 0)
				If (MAR->E2_prefixo == "COM") //Previsao Fomento
					aCols1[MFOMENT,nPos1] += nVal1
				Else //Provisao Pagamento Antecipado
					aCols1[MPRPAAN,nPos1] += nVal1
				Endif
			Endif
		Endif
		nValPrevis += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo == "NF ") //Notas Fiscais
		nValNotas  += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo $ "PI /PRO") //Parcelamento de Impostos
		nValParcel += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo == "DA ") //Divida Ativa
		nValDivAti += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo $ "EMP") //Emprestimos
		nValEmpres += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo $ "NDF") //Nota Debito Fornecedor
		nValNDFFor += nVal1
		nValPgGeral+= nVal1
	Elseif (MAR->E2_tipo $ "RJ ") //Recuperacao Judicial
		nValRecJur += MAR->E2_valor-MAR->E2_decresc+MAR->E2_acresc
		nValPgGeral+= MAR->E2_valor-MAR->E2_decresc+MAR->E2_acresc
	Else //Outros
		nValPgOutr += nVal1
		nValPgGeral+= nVal1
	Endif
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes do Faturamento do Dia                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos1 := B002PosCol(d002Data)
If (nPos1 > 0)
	cQuery1 := "SELECT SUM(D2.D2_VALBRUT) D2_VALBRUT "
	cQuery1 += "FROM "+RetSqlName("SD2")+" D2 INNER JOIN "+RetSqlName("SF4")+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery1 += "WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND NOT D2.D2_TIPO IN ('B','D') "
	cQuery1 += "AND D2.D2_EMISSAO = '"+dtos(d002Data)+"' AND F4.F4_DUPLIC = 'S' "
	cQuery1 += "AND D2.D2_CLIENTE BETWEEN '"+c002CliDe+"' AND '"+c002CliAt+"' "
	cQuery1 += "AND D2.D2_LOJA BETWEEN '"+c002CloDe+"' AND '"+c002CloAt+"' "
	If !Empty(cBrCfFat)
		cQuery1 += "AND D2.D2_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery1 += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery1 += "AND D2.D2_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery1 += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
	Endif
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	If !MAR->(Eof())
		aCols1[MFATDIA,nPos1] += MAR->D2_valbrut
	Endif
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes dos Pedidos Pendentes                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT C6_NUM,C6_ITEM,C6_ENTREG,C5_MOEDA,SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) C6_VALOR "
cQuery1 += "FROM "+RetSqlName("SC5")+" C5,"+RetSqlName("SC6")+" C6,"+RetSqlName("SF4")+" F4 "
cQuery1 += "WHERE C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery1 += "AND C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+xFilial("SC6")+"' AND C5_NUM = C6_NUM "
cQuery1 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' AND C6_TES = F4_CODIGO "
cQuery1 += "AND C6_QTDVEN > C6_QTDENT AND C6_BLQ = '' AND C6_ENTREG <= '"+dtos(d002DtFim)+"' "
cQuery1 += "AND C6.C6_CLI BETWEEN '"+c002CliDe+"' AND '"+c002CliAt+"' AND F4_DUPLIC = 'S' "
cQuery1 += "AND C6.C6_LOJA BETWEEN '"+c002CloDe+"' AND '"+c002CloAt+"' "
If (Left(c002TpPed,1) == "1")
	cQuery1 += "AND (SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SC9")+" C9 WHERE C9.D_E_L_E_T_ = '' AND "
	cQuery1 += "     C9.C9_FILIAL = '"+xFilial("SC9")+"' AND C9.C9_PEDIDO = C6.C6_NUM AND "
	cQuery1 += "     C9.C9_ITEM = C6.C6_ITEM AND C9.C9_BLEST = '' AND C9.C9_BLCRED = '') > 0 "
Elseif (Left(c002TpPed,1) == "2") 
	cQuery1 += "AND (SELECT COUNT(*) M_CONTA FROM "+RetSqlName("SC9")+" C9 WHERE C9.D_E_L_E_T_ = '' AND "
	cQuery1 += "     C9.C9_FILIAL = '"+xFilial("SC9")+"' AND C9.C9_PEDIDO = C6.C6_NUM AND "
	cQuery1 += "     C9.C9_ITEM = C6.C6_ITEM AND C9.C9_BLEST = '' AND C9.C9_BLCRED = '') = 0 "
Endif
cQuery1 += "GROUP BY C6_NUM,C6_ITEM,C6_ENTREG,C5_MOEDA ORDER BY C6_NUM,C6_ITEM,C6_ENTREG "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","C6_ENTREG","D",08,0)
dbSelectArea("MAR")
While !MAR->(Eof())
	nMoeda1 := Max(MAR->C5_moeda,1)
	dData1 := MAR->C6_entreg
	If (dData1 < d002Data)
		dData1 := d002Data
	Endif
	nPos1 := B002PosCol(dData1)
	If (nPos1 > 0)
		aCols1[MPEDPEN,nPos1] += Round(xMoeda(MAR->C6_valor,nMoeda1,1,dData1),2)
	Endif
	MAR->(dbSkip())
Enddo
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Fluxo de Caixa                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 2 to Len(oGetFin:aHeader)
	If (nx > 2)
		aCols1[MSALATU,nx] := aCols1[MSALFIN,nx-1]
	Endif
	aCols1[MSALFIN,nx] := aCols1[MSALATU,nx]+aCols1[MARECEB,nx]-aCols1[MAPAGAR,nx]-aCols1[MPRPAAN,nx]-aCols1[MFOMENT,nx]
	aCols1[MSLDREA,nx] := aCols1[MSALFIN,nx]+aCols1[MFATDIA,nx]+aCols1[MPEDPEN,nx]+aCols1[MEMPROC,nx]-aCols1[MPAGATR,nx]
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo oGetDados                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetFin:aCols := aClone(aCols1)
oGetFin:oBrowse:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Indicadores                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSayPag1v:cCaption := c002Simb1+" "+Transform(nValPagAnt ,"@E 999,999,999.99") ; oSayPag1v:Refresh()
oSayPag2v:cCaption := c002Simb1+" "+Transform(nValPrevis ,"@E 999,999,999.99") ; oSayPag2v:Refresh()
oSayPag3v:cCaption := c002Simb1+" "+Transform(nValNotas  ,"@E 999,999,999.99") ; oSayPag3v:Refresh()
oSayPag4v:cCaption := c002Simb1+" "+Transform(nValImpost ,"@E 999,999,999.99") ; oSayPag4v:Refresh()
oSayPag5v:cCaption := c002Simb1+" "+Transform(nValParcel ,"@E 999,999,999.99") ; oSayPag5v:Refresh()
oSayPag6v:cCaption := c002Simb1+" "+Transform(nValDivAti ,"@E 999,999,999.99") ; oSayPag6v:Refresh()
oSayPag7v:cCaption := c002Simb1+" "+Transform(nValFolha  ,"@E 999,999,999.99") ; oSayPag7v:Refresh()
oSayPag8v:cCaption := c002Simb1+" "+Transform(nValEmpres ,"@E 999,999,999.99") ; oSayPag8v:Refresh()
oSayPag9v:cCaption := c002Simb1+" "+Transform(nValNDFFor ,"@E 999,999,999.99") ; oSayPag9v:Refresh()
oSayPagAv:cCaption := c002Simb1+" "+Transform(nValPgOutr ,"@E 999,999,999.99") ; oSayPagAv:Refresh()
oSayPagBv:cCaption := c002Simb1+" "+Transform(nValRecJur ,"@E 999,999,999.99") ; oSayPagBv:Refresh()
oSayPagCv:cCaption := c002Simb1+" "+Transform(nValPgGeral,"@E 999,999,999.99") ; oSayPagCv:Refresh()
oSayRec1v:cCaption := c002Simb1+" "+Transform(nValNFCarte,"@E 999,999,999.99") ; oSayRec1v:Refresh()
oSayRec2v:cCaption := c002Simb1+" "+Transform(nValNFSimp ,"@E 999,999,999.99") ; oSayRec2v:Refresh()
oSayRec3v:cCaption := c002Simb1+" "+Transform(nValNFCobr ,"@E 999,999,999.99") ; oSayRec3v:Refresh()
oSayRec4v:cCaption := c002Simb1+" "+Transform(nValNFDesc ,"@E 999,999,999.99") ; oSayRec4v:Refresh()
oSayRec5v:cCaption := c002Simb1+" "+Transform(nValNFCauc ,"@E 999,999,999.99") ; oSayRec5v:Refresh()
oSayRec6v:cCaption := c002Simb1+" "+Transform(nValNFProt ,"@E 999,999,999.99") ; oSayRec6v:Refresh()
oSayRec7v:cCaption := c002Simb1+" "+Transform(nValNFCarto,"@E 999,999,999.99") ; oSayRec7v:Refresh()
oSayRec8v:cCaption := c002Simb1+" "+Transform(nValTitNeg ,"@E 999,999,999.99") ; oSayRec8v:Refresh()
oSayRec9v:cCaption := c002Simb1+" "+Transform(nValRecNCC ,"@E 999,999,999.99") ; oSayRec9v:Refresh()
oSayRecAv:cCaption := c002Simb1+" "+Transform(nValRecRA  ,"@E 999,999,999.99") ; oSayRecAv:Refresh()
oSayRecBv:cCaption := c002Simb1+" "+Transform(nValRePerda,"@E 999,999,999.99") ; oSayRecBv:Refresh()
oSayRecCv:cCaption := c002Simb1+" "+Transform(nValReGeral,"@E 999,999,999.99") ; oSayRecCv:Refresh()

Return
               
Static Function B002PosCol(xData)
******************************
LOCAL nRetu := 0, cColuna := "MM_"+Substr(dtos(xData),3,8)
nRetu := aScan(oGetFin:aHeader,{|x| Alltrim(x[2]) == cColuna })
Return nRetu
                                          
  
Static Function B002DetFluxo(xLinha,xColuna)
***************************************
LOCAL oDlgBco := Nil, oGetBco := Nil
LOCAL dDataIni := d002Data, dDataFim := d002DtFim
LOCAL aHeader2 := {}, aCols2 := {}, cQuery2 := ""
If (xColuna != 1)
	dDataIni := ctod(oGetFin:aHeader[xColuna,1])
	dDataFim := ctod(oGetFin:aHeader[xColuna,1])
Endif
If (xLinha == MSALATU).and.(xColuna == 2)
	cQuery2 := "SELECT A6_COD,A6_AGENCIA,A6_NUMCON,A6_MOEDA,A6_NOME,A6_SALATU FROM "+RetSqlName("SA6")+" A6 "
	cQuery2 += "WHERE A6.D_E_L_E_T_ = '' AND A6.A6_FILIAL = '"+xFilial("SA6")+"' "
	cQuery2 += "AND A6_FLUXCAI = 'S' AND A6_MSBLQL <> '1' AND A6_SALATU <> 0 "
	cQuery2 += "ORDER BY A6_COD,A6_AGENCIA,A6_NUMCON "
	cQuery2 := ChangeQuery(cQuery2)
	If (Select("MSA6") <> 0)
		dbSelectArea("MSA6")
		dbCloseArea()
	Endif
	TCQuery cQuery2 NEW ALIAS "MSA6"
	dbSelectArea("MSA6")
	While !MSA6->(Eof())
		nMoeda2 := Max(MSA6->A6_moeda,1)
		aadd(aCols2,{MSA6->A6_cod,MSA6->A6_agencia,MSA6->A6_numcon,MSA6->A6_moeda,MSA6->A6_nome,Round(xMoeda(MSA6->A6_salatu,nMoeda2,1,dDatabase),2),.F.})
		MSA6->(dbSkip())
	Enddo
	If (Select("MSA6") <> 0)
		dbSelectArea("MSA6")
		dbCloseArea()
	Endif 
	If (Len(aCols2) > 0)
		aHeader2 := {}
		aadd(aHeader2,{"Banco"    ,"MM_BANCO"   ,"",03,0,"","","C","",""})
		aadd(aHeader2,{"Agencia"  ,"MM_AGENCIA" ,"",08,0,"","","C","",""})
		aadd(aHeader2,{"Conta"    ,"MM_CONTA"   ,"",12,0,"","","C","",""})
		aadd(aHeader2,{"Moeda"    ,"MM_MOEDA"   ,"",01,0,"","","N","",""})
		aadd(aHeader2,{"Nome"     ,"MM_NOME"    ,"",40,0,"","","C","",""})
		aadd(aHeader2,{"Sld.Atual","MM_SLDATU"  ,"@E 999,999,999.99",14,2,"","","N","",""})
		DEFINE MSDIALOG oDlgBco FROM 0,0 TO 400,800 TITLE OemToAnsi("Saldo Bancario") Of oMainWnd PIXEL
		oGetBco := MsNewGetDados():New(005,005,175,395,0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgBco,aHeader2,aCols2)
		oButFec2 := B002Button(oDlgBco,"oButFec2","Fechar",010,180,50,,{|| oDlgBco:End() })
		ACTIVATE MSDIALOG oDlgBco CENTERED	
	Endif
Elseif (xLinha == MARECEB).and.ExistBlock("GDVA100",.F.,.F.)
	u_GDVA100("FINANC",dDataIni,dDataFim,1) //Receber
Elseif (xLinha == MAPAGAR).and.ExistBlock("GDVA100",.F.,.F.) 
	u_GDVA100("FINANC",dDataIni,dDataFim,2) //Pagar
Elseif (xLinha == MFOMENT).and.ExistBlock("GDVA100",.F.,.F.) 
	dDataIni := iif(d002Data==dDataIni,NIL,dDataIni)
	u_GDVA100("FINANC",dDataIni,dDataFim,3) //Fomento
Elseif (xLinha == MPRPAAN).and.ExistBlock("GDVA100",.F.,.F.) 
	dDataIni := iif(d002Data==dDataIni,NIL,dDataIni)
	u_GDVA100("FINANC",dDataIni,dDataFim,4) //Provisao
Elseif (xLinha == MPAGATR).and.ExistBlock("GDVA100",.F.,.F.) 
	dDataIni := B002DtPagAtr()
	u_GDVA100("FINANC",dDataIni,dDataFim,5) //Pagamento Em Atraso
Endif
Return

Static Function B002ZeraCols(xHeader,xCols)
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

Static Function B002CorFin(xHeader,xCols,xAt)
*****************************************
LOCAL nRetu := RGB(250,250,250), nPos1 := 0
Return nRetu

Static Function B002Legenda()
**************************
LOCAL aLegenda := { {"DISABLE","% Lucro menor que 0%"},;
	{"BR_AMARELO","% Lucro maior que 0% e menor que 20%"},;
	{"BR_VERDE"  ,"% Lucro maior que 20% e menor que 40%"},;
	{"BR_AZUL"   ,"% Lucro maior que 40%"}}
BrwLegenda(cCadastro,"Legenda",aLegenda)
Return

Static Function B002ExpExcel()
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

Static Function B002Say(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xColor,xBackClr)
******************************************************************************
LOCAL oSay := Nil     
oSay := TSAY():New(xTop,xLeft,{|| xCaption},xObj,,,.F.,.F.,.F.,.T.,iif(xColor!=Nil,xColor,CLR_BLUE),iif(xBackClr!=Nil,xBackClr,Nil),iif(xWidth!=Nil,xWidth,80),iif(xHeight!=Nil,xHeight,10),.F.,.F.,.F.,.F.,.F.)
Return (oSay)       

Static Function B002Get(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xChange,xPicture,xF3)
***********************************************************************************
LOCAL oGet := Nil, bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oGet := TGET():New(xTop,xLeft,bSetGet,xObj,iif(xWidth!=Nil,xWidth,80),iif(xHeight!=Nil,xHeight,10),xPicture,,,,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,xChange,.F.,.F.,,xVariable,,,,)
oGet:cF3 := xF3
Return (oGet)

Static Function B002Button(xObj,xName,xCaption,xLeft,xTop,xWidth,xHeight,xAction)
*************************************************************************
LOCAL oButton := Nil
oButton := TBUTTON():New(xTop,xLeft,xCaption,xObj,xAction,iif(xWidth!=Nil,xWidth,60),iif(xHeight!=Nil,xHeight,11),,,,.T.)
Return (oButton)

Static Function B002Combo(xObj,xName,xVariable,xLeft,xTop,xWidth,xHeight,xItens,xChange)
*******************************************************************************
LOCAL oCombo := Nil, bSetGet := &("{|u| If(PCount()>0,"+xName+":=u,"+xName+") }")
oCombo := TComboBox():Create(xObj,bSetGet,xTop,xLeft,xItens,xWidth,xHeight,,xChange,,,,.T.)
Return (oCombo)

Static Function B002DtPagAtr()
***************************
LOCAL dRetu2 := ctod("//"), cQuery2 := ""
cQuery2 := "SELECT MIN(E2_VENCREA) E2_VENCREA FROM "+RetSqlName("SE2")+" E2 "
cQuery2 += "WHERE E2.D_E_L_E_T_ = '' AND E2.E2_VENCREA < '"+dtos(d002Data)+"' "
cQuery2 += "AND E2.E2_SALDO > 0 AND E2.E2_TIPO NOT IN ('PR','PA') " 
cQuery2 := ChangeQuery(cQuery2)
If (Select("MSE2") <> 0)
	dbSelectArea("MSE2")
	dbCloseArea()
Endif
TCQuery cQuery2 NEW ALIAS "MSE2"
TCSetField("MSE2","E2_VENCREA","D",08,0)
dbSelectArea("MSE2")
If !MSE2->(Eof()).and.!Empty(MSE2->E2_VENCREA)
	dRetu2 := MSE2->E2_VENCREA
Endif
If (Select("MSE2") <> 0)
	dbSelectArea("MSE2")
	dbCloseArea()
Endif
Return dRetu2