#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "goldenview.ch"

#define GDV_IANOME  1
#define GDV_INUMFU  2
#define GDV_ITURNO  3
#define GDV_ITREIN  4
#define GDV_IABSEN  5
#define GDV_IHRABO  6
#define GDV_IHRATR  7
#define GDV_IHRFAL  8
#define GDV_IHRBHR  9
#define GDV_IHRPAG  10
#define GDV_IHREXT  11
#define GDV_IVLNOM  12
#define GDV_IVLPAG  13
#define GDV_IVLEXT  14

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GBRA860  ºAutor  ³ Marcelo da Cunha   º Data ³  19/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GDView Gestao Pessoal                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GBRA860()
*********************
PRIVATE oDlgGer, oMark, oGetPon, oScroll, oGraf1, oFolder
PRIVATE cCadastro := "GDView Gestao Pessoal", aTitle, aPage
PRIVATE a860Tabs  := {"CTT","SR6","SR8","SRA","SRC","SRD","SRJ","SRV","SP6","SP9","SPC","SPH","SPI","ZMP","RA0","RA1","RA4","RA5","RA7","RCF"}
PRIVATE c860Peri1 := Space(6), c860Peri2 := Space(6), c860ArqEmp := "", c860Marca, c860Categor
PRIVATE n860PonOrd := 0, n860GpeOrd := 0, bBlock, a860PonAno := {}, a860ConTre := {}
PRIVATE n860AClasse := 0, n860BClasse := 0, n860CClasse := 0, a860ConPon, a860ConExt, l860OrdCres := .T.
PRIVATE c860Pon1 := Space(8), c860Pon2 := Space(8), d860DtUltAtu := ctod("//"), c860HrUltAtu := ""
PRIVATE a860ArqTrb  := {}, a860CampEmp := {}, a860Filtro := {}, c860Filtro := "", c860ArqInd := ""
PRIVATE cPon1 := Substr(GetMV("MV_PONMES"),1,8), cPon2 := Substr(GetMV("MV_PONMES"),10,8)
PRIVATE lInverte := .F., nOpcm:=1, ni, nx, aSizeAut, aHeader, aCols, aButtons := {}, aButtxts := {}, nCol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao do historico de acessos (ZGY e ZGZ)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("GDVRDMENT") //Verifico rotina GDVRDMENT
	u_GDVRdmEnt() //Entrada na rotina
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza apenas nos modulo de Ponto/RH                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cModulo != "PON").and.(cModulo != "GPE")
	MsgInfo("> Utilizar esta rotina para modulo de PONTO!","ATENCAO")
	Return
Elseif (cNivel < 8)
	MsgInfo("> Voce nao tem acesso para utilizar esta rotina!","ATENCAO")
	Return
Endif                                                                                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico acesso na tabela SRD                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SRW->(dbSetOrder(1))
If !SRW->(dbSeek(xFilial("SRW")+Space(10)+"SRD"+Space(6)+__cUserID)).or.(Alltrim(SRW->RW_filbrow) != ".T.")
	MsgInfo(">> Voce nao tem acesso para utilizar esta rotina!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas utilizadas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Peri1 := Strzero(Year(dDatabase-360),4)+Strzero(Month(dDatabase-360),2)
c860Peri2 := Substr(dtos(LastDay(dDatabase)),1,6)
c860Pon1  := Substr(GetMV("MV_PONMES"),1,8)
c860Pon2  := Substr(GetMV("MV_PONMES"),10,8)
aRotina   := {{"","",0,1},{"","",0,2},{"","",0,3}}
aTitle := {"Funcionarios","Treinamentos","Banco Horas","Ponto Eletronico","Absenteismo","Folha Pagamento"}
aPage  := {"Funcionarios","Treinamentos","Banco Horas","Ponto Eletronico","Absenteismo","Folha Pagamento"}
aButtons:= {} ; aButtxts:= {}
aadd(aButtons,{"PMSEXCEL" ,{||GB860ExpExcel(@oGetPon:aHeader,@oGetPon:aCols)},"Excel","Excel"})
aadd(aButtons,{"PROCESSA" ,{||GB860AltPeri()    },"Periodo","Periodo"})
aadd(aButtons,{"AUTOM"    ,{||GB860Param1(.T.)  },"Parametr","Parametr"})
aadd(aButtons,{"DBG06"    ,{||GB860Atualiza()   },"Atualiza","Atualiza"})
aadd(aButtxts,{"Fechar","Fechar", {|| oDlgGer:End() } })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consultas disponiveis                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
a860ConFun := {}
aadd(a860ConFun,{"FIL","Filial"   , .T.})
aadd(a860ConFun,{"NIV","Nivel"    , .T.})
aadd(a860ConFun,{"CUS","C.Custo"  , .T.})
aadd(a860ConFun,{"FNC","Funcao"   , .T.})
aadd(a860ConFun,{"CAT","Categoria", .T.})
aadd(a860ConFun,{"FUN","Funcion." , .T.})
aadd(a860ConFun,{"TUR","Turno"    , .T.})
aadd(a860ConFun,{"SEX","Sexo"     , .T.})
a860ConTre := {}
aadd(a860ConTre,{"FIL","Filial"   , .T.})
aadd(a860ConTre,{"NIV","Nivel"    , .T.})
aadd(a860ConTre,{"CUS","C.Custo"  , .T.})
aadd(a860ConTre,{"FNC","Funcao"   , .T.})
aadd(a860ConTre,{"CAT","Categoria", .T.})
aadd(a860ConTre,{"FUN","Funcion." , .T.})
aadd(a860ConTre,{"INS","Instrutor", .T.})
aadd(a860ConTre,{"ENT","Entidade" , .T.})
aadd(a860ConTre,{"CUR","Curso"    , .T.})
aadd(a860ConTre,{"TUR","Turno"    , .T.})
aadd(a860ConTre,{"SEX","Sexo"     , .T.})
aadd(a860ConTre,{"DIA","Dia"      , .T.})
a860ConBan := {}
aadd(a860ConBan,{"FIL","Filial"   , .T.})
aadd(a860ConBan,{"NIV","Nivel"    , .T.})
aadd(a860ConBan,{"CUS","C.Custo"  , .T.})
aadd(a860ConBan,{"FNC","Funcao"   , .T.})
aadd(a860ConBan,{"CAT","Categoria", .T.})
aadd(a860ConBan,{"FUN","Funcion." , .T.})
aadd(a860ConBan,{"EVN","Evento"   , .T.})
aadd(a860ConBan,{"TUR","Turno"    , .T.})
aadd(a860ConBan,{"SEX","Sexo"     , .T.})
aadd(a860ConBan,{"DIA","Dia"      , .T.})
a860ConPon := {}
aadd(a860ConPon,{"FIL","Filial"  , .T.})
aadd(a860ConPon,{"NIV","Nivel"    , .T.})
aadd(a860ConPon,{"CUS","C.Custo"  , .T.})
aadd(a860ConPon,{"FNC","Funcao"   , .T.})
aadd(a860ConPon,{"CAT","Categoria", .T.})
aadd(a860ConPon,{"FUN","Funcion." , .T.})
aadd(a860ConPon,{"VER","Verba"    , .T.})
aadd(a860ConPon,{"ABO","Abono"    , .T.})
aadd(a860ConPon,{"TUR","Turno"    , .T.})
aadd(a860ConPon,{"SEX","Sexo"     , .T.})
aadd(a860ConPon,{"DIA","Dia"      , .T.})
a860ConAbs := {}
aadd(a860ConAbs,{"FIL","Filial"   , .T.})
aadd(a860ConAbs,{"NIV","Nivel"    , .T.})
aadd(a860ConAbs,{"CUS","C.Custo"  , .T.})
aadd(a860ConAbs,{"FNC","Funcao"   , .T.})
aadd(a860ConAbs,{"CAT","Categoria", .T.})
aadd(a860ConAbs,{"FUN","Funcion." , .T.})
aadd(a860ConAbs,{"VER","Verba"    , .T.})
aadd(a860ConAbs,{"TUR","Turno"    , .T.})
aadd(a860ConAbs,{"SEX","Sexo"     , .T.})
aadd(a860ConAbs,{"DIA","Dia"      , .T.})
a860ConGpe := {}
aadd(a860ConGpe,{"FIL","Filial"   , .T.})
aadd(a860ConGpe,{"NIV","Nivel"    , .T.})
aadd(a860ConGpe,{"CUS","C.Custo"  , .T.})
aadd(a860ConGpe,{"FNC","Funcao"   , .T.})
aadd(a860ConGpe,{"CAT","Categoria", .T.})
aadd(a860ConGpe,{"FUN","Funcion." , .T.})
aadd(a860ConGpe,{"VER","Verba"    , .T.})
aadd(a860ConGpe,{"TUR","Turno"    , .T.})
aadd(a860ConGpe,{"SEX","Sexo"     , .T.})
aadd(a860ConGpe,{"DIA","Dia"      , .T.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB860Param1(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco empresas disponiveis                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB860Empresas()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tela para Visao                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjects := {}
aSizeAut	:= MsAdvSize(,.F.,400)
AAdd(aObjects,{  0,  20, .T., .F. }) //GDVMyBar
AAdd(aObjects,{  0,  20, .T., .F. })
AAdd(aObjects,{  0,  60, .T., .F. })
AAdd(aObjects,{  0,  15, .T., .F. })
AAdd(aObjects,{  0, 180, .T., .T. })
AAdd(aObjects,{  0,  40, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)
DEFINE MSDIALOG oDlgGer FROM 0,0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[2,1]+2,aPosObj[2,2] SAY o860Gdview VAR "GDVIEW GESTAO PESSOAL" OF oDlgGer PIXEL SIZE 245,9 COLOR GDV_CORGDV FONT oBold
@ aPosObj[2,1]+2,aPosObj[2,2]+150 SAY o860Peri VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgGer PIXEL SIZE 140,9 FONT oBold
@ aPosObj[2,1]+2,aPosObj[2,2]+300 SAY o860UAtu VAR "ATUALIZADO: "+dtoc(d860DtUltAtu)+" - "+c860HrUltAtu OF oDlgGer PIXEL SIZE 140,9 FONT oBold
@ aPosObj[2,1]+14,aPosObj[2,2] TO aPosObj[2,1]+15,(aPosObj[2,4]-aPosObj[2,2]-180) LABEL "" OF oDlgGer PIXEL
@ (aPosObj[2,1]+18),(((aPosObj[2,4]-aPosObj[2,2])*2)-200) BTNBMP o860Logo RESOURCE GDV_LOGOGDVIEW SIZE 200,41 ACTION oDlgGer:End() MESSAGE "GoldenView" PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Markbrowse para selecao das empresas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMark := MsSelect():New("MEMP","M_OK",,a860CampEmp,@lInverte,@c860Marca,{aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4]},,,oDlgGer)
oMark:oBrowse:Refresh()
oButton1 := u_GDVButton(oDlgGer,"oButton1","Grafico Mensal",010,aPosObj[4,1],80,,{||GB860CompGraf()})
oButton2 := u_GDVButton(oDlgGer,"oButton2","Atualiza Cubo" ,090,aPosObj[4,1],80,,{||(u_WBRA860(),GB860Atualiza())})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco dados do Ponto/RH                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||GB860ProAno(@aHeader,@aCols)},cCadastro)
oGetPon := MsNewGetDados():New(aPosObj[5,1],aPosObj[5,2],aPosObj[5,3],aPosObj[5,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgGer,aHeader,aCols)
oGetPon:oBrowse:bLDblClick := { || GB860Coluna(oGetPon,oGetPon:oBrowse:nColPos) }
oGetPon:oBrowse:lUseDefaultColors := .F.
oGetPon:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto folder com as opcoes para consulta                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oFolder := TFolder():New(aPosObj[6,1],aPosObj[6,2],aTitle,aPage,oDlgGer,,,,.T.,.F.,aPosObj[6,4]-aPosObj[6,2],aPosObj[6,3]-aPosObj[6,1],)
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConFun)
	bBlock := &("{|| GB860AConFun('"+a860ConFun[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[1],"oButGer"+Alltrim(Str(ni,1)),a860ConFun[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConTre)
	bBlock := &("{|| GB860FConTre('"+a860ConTre[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[2],"oButGer"+Alltrim(Str(ni,1)),a860ConTre[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConBan)
	bBlock := &("{|| GB860BConBan('"+a860ConBan[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[3],"oButGer"+Alltrim(Str(ni,1)),a860ConBan[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConPon)
	bBlock := &("{|| GB860CConPon('"+a860ConPon[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[4],"oButGer"+Alltrim(Str(ni,1)),a860ConPon[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConAbs)
	bBlock := &("{|| GB860EConAbs('"+a860ConAbs[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[5],"oButGer"+Alltrim(Str(ni,1)),a860ConAbs[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni
nLin := 2 ; nCol := 2
For ni := 1 to Len(a860ConGpe)
	bBlock := &("{|| GB860DConGpe('"+a860ConGpe[ni,1]+"',oGetPon:aCols,oGetPon:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oFolder:aDialogs[6],"oButGer"+Alltrim(Str(ni,1)),a860ConGpe[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 2
		nLin += 12
	Endif
Next ni

ACTIVATE MSDIALOG oDlgGer ON INIT u_GDVMyBar(oDlgGer,,,aButtons,aButtxts)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecho arquivo temporario de empresas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB860FechaArqs()
If (Select("MEMP") <> 0)
	dbSelectArea("MEMP")
	dbCloseArea("MEMP")
	FErase(c860ArqEmp+GetDBExtension())
	FErase(c860ArqEmp+OrdBagExt())
Endif
If (Select("MIND") <> 0)
	dbSelectArea("MIND")
	dbCloseArea("MIND")
	FErase(c860ArqInd+GetDBExtension())
	FErase(c860ArqInd+OrdBagExt())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao do historico de acessos (ZGY e ZGZ)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("GDVRDMSAI") //Verifico rotina GDVRDMSAI
	u_GDVRdmSai() //Saida da rotina
Endif

Return

Static Function GB860Empresas()
****************************
LOCAL aStru := {}, aSM0 := SM0->(GetArea())

//Monto aheader do markbrose
////////////////////////////
c860Marca   := GetMark()
a860CampEmp := {}
aadd(a860CampEmp,{"M_OK"    ,""," "   })
aadd(a860CampEmp,{"M_CODEMP","","Empresa" , "@!" })
aadd(a860CampEmp,{"M_CODFIL","","Filial"  , "@!" })
aadd(a860CampEmp,{"M_NOME"  ,"","Nome"    , "@!" })
aadd(a860CampEmp,{"M_NUMFUN","","Funcionarios"   , "@E 999,999,999" })
aadd(a860CampEmp,{"M_HRSPAG","","Horas Pagas"    , "@E 999,999,999" })
aadd(a860CampEmp,{"M_HRSEXT","","Horas Extra"    , "@E 999,999,999" })
aadd(a860CampEmp,{"M_VALNOM","","Vlr Nominal"    , "@E 999,999,999" })
aadd(a860CampEmp,{"M_VALPAG","","Vlr Pago   "    , "@E 999,999,999" })
aadd(a860CampEmp,{"M_VALEXT","","Vlr HrExtra"    , "@E 999,999,999" })

//Monta estrutura do arquivo de trabalho
////////////////////////////////////////
aStru := {}
aadd(aStru,{"M_OK"    ,"C",02,0})
aadd(aStru,{"M_CODEMP","C",02,0})
aadd(aStru,{"M_CODFIL","C",02,0})
aadd(aStru,{"M_NOME"  ,"C",50,0})
aadd(aStru,{"M_NUMFUN","N",15,0})
aadd(aStru,{"M_HRSPAG","N",15,0})
aadd(aStru,{"M_HRSEXT","N",15,0})
aadd(aStru,{"M_VALNOM","N",15,0})
aadd(aStru,{"M_VALPAG","N",15,0})
aadd(aStru,{"M_VALEXT","N",15,0})
If (Select("MEMP") <> 0)
	dbSelectArea("MEMP")
	dbCloseArea("MEMP")
Endif
c860ArqEmp := CriaTrab(aStru,.t.)
dbUseArea(.T.,,c860ArqEmp,"MEMP",NIL,.F.)
dbSelectArea("SM0")
Procregua(SM0->(Reccount()))
dbGotop()
While !Eof()
	Incproc(">>> Abrindo empresa..."+SM0->M0_nome)
	If (SM0->M0_codigo+SM0->M0_codfil $ "0101")
		dbSelectArea("MEMP")
		Reclock("MEMP",.T.)
		MEMP->M_ok     := c860Marca
		MEMP->M_codemp := SM0->M0_codigo
		MEMP->M_codfil := SM0->M0_codfil
		MEMP->M_nome   := Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial)
		MsUnlock("MEMP")
		GB860ArqTrb(SM0->M0_codigo,SM0->M0_codfil)
	Endif
	dbSelectArea("SM0")
	dbSkip()
Enddo
MEMP->(dbGotop())

//Abro arquivos utilizados pela rotina
//////////////////////////////////////
GB860OpenArqs()

u_GDVRestArea({aSM0})  //GOLDENVIEW

Return

Static Function GB860ArqTrb(xEmp,xFil)
*********************************
LOCAL nx, cAlias1
If !Empty(xEmp)
	If (Select("MSX2") <> 0)
		dbSelectArea("MSX2")
		dbCloseArea()
	Endif
	dbUseArea(.T.,,"SX2"+xEmp+"0","MSX2",Nil,.F.)
	dbSetIndex("SX2"+xEmp+"0")
	For nx := 1 to Len(a860Tabs)
		If MSX2->(dbSeek(a860Tabs[nx]))
			cAlias1 := Alltrim(MSX2->X2_chave)
			If (cEmpAnt != xEmp)
				cAlias1 += xEmp
			Endif
			aadd(a860ArqTrb,{xEmp,MSX2->X2_chave,Alltrim(MSX2->X2_arquivo),MSX2->X2_modo,cAlias1})
		Endif
	Next nx
	If (Select("MSX2") <> 0)
		dbSelectArea("MSX2")
		dbCloseArea()
	Endif
Endif
Return

Static Function GB860OpenArqs()
***************************
LOCAL nx, nInd
For nx := 1 to Len(a860ArqTrb)
	If (Select(a860ArqTrb[nx,5]) == 0)
		dbUseArea(.T.,"TOPCONN",a860ArqTrb[nx,3],a860ArqTrb[nx,5],.T.,.F.)
		dbSelectArea("SIX")
		If dbSeek(a860ArqTrb[nx,2])
			While !Eof().and.(SIX->INDICE == a860ArqTrb[nx,2])
				dbSelectArea(a860ArqTrb[nx,5])
				nInd := Alltrim(a860ArqTrb[nx,3])+SIX->ORDEM
				MsOpenIdx(nInd,SIX->CHAVE,.F.,.F.,,a860ArqTrb[nx,3])
				dbSelectArea("SIX")
				dbSkip()
			Enddo
		Endif
	Endif
Next nx
Return

Static Function GB860FechaArqs()
***************************
LOCAL nx, cAlias1
For nx := 1 to Len(a860ArqTrb)
	cAlias1 := a860ArqTrb[nx,5]
	If (Len(cAlias1) == 5).and.(Substr(cAlias1,4,2) != cEmpAnt).and.(Select(cAlias1) <> 0)
		dbSelectArea(cAlias1)
		dbCloseArea()
	Endif
Next nx
Return

Static Function GB860RetArq(xAlias,xEmp)
***********************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a860ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := a860ArqTrb[nPos,3]
Endif
Return cRetu

Static Function GB860RetFil(xAlias,xEmp,xFil)
****************************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a860ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := iif(a860ArqTrb[nPos,4]=="C",Space(2),xFil)
Endif
Return cRetu

Static Function GB860RetAlias(xAlias,xEmp)
************************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a860ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := a860ArqTrb[nPos,5]
Endif
Return cRetu

Static Function GB860Cores(nx)
**************************
LOCAL aCores := {CLR_BLUE,CLR_GREEN,CLR_BROWN,CLR_HGRAY,CLR_LIGHTGRAY,CLR_RED,CLR_HCYAN,;
CLR_HGREEN,CLR_HRED,CLR_HMAGENTA,CLR_YELLOW,CLR_HBLUE,CLR_CYAN,CLR_BLACK,CLR_GRAY,CLR_MAGENTA}
If (nx < 0).or.(nx > 17)
	nx := 1
Endif
Return (aCores[nx++])

Static Function GB860Param1(xMostra)
*******************************
LOCAL aRegs := {}, cPerg := "CA860A", nx

//Cria grupo de perguntas
/////////////////////////
AADD(aRegs,{cPerg,"01","Percentual Classe A ?","mv_ch1","N",03,0,0,"G","","MV_PAR01","","30","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Percentual Classe B ?","mv_ch2","N",03,0,0,"G","","MV_PAR02","","40","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Percentual Classe C ?","mv_ch3","N",03,0,0,"G","","MV_PAR03","","30","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Categorias          ?","mv_ch4","C",12,0,0,"G","fCategoria","MV_PAR04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Ordenar Ponto por   ?","mv_ch5","N",01,0,0,"C","","MV_PAR05","Hrs Abono","","","Hrs Atraso","","","Hrs Falta","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Ordenar Folha por   ?","mv_ch6","N",01,0,0,"C","","MV_PAR06","Hrs Pagas","","","Hrs Extra","","","Vlr Nominal","","","Vlr Pago","","","Vlr HrExtra","",""})

u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW

If (xMostra)
	While (.T.)
		If Pergunte(cPerg,.T.)
			n860AClasse := mv_par01
			n860BClasse := mv_par02
			n860CClasse := mv_par03
			c860Categor := ""              
			n860PonOrd  := mv_par05
			n860GpeOrd  := mv_par06
			For nx := 1 to Len(mv_par04)
				If !Empty(Substr(mv_par04,nx,1)).and.(Substr(mv_par04,nx,1)!="*")
					c860Categor += "'"+Substr(mv_par04,nx,1)+"',"
				Endif
			Next nx
			c860Categor := Left(c860Categor,Len(c860Categor)-1)
			If (int(n860AClasse+n860BClasse+n860CClasse) != 100)
				MsgInfo(">>> A soma das classes ABC deve ser 100! Tente novamente.","ATENCAO")
				Loop
			Endif
			GB860Atualiza()
		Endif
		Exit
	Enddo
Else
	Pergunte(cPerg,.F.)
	n860AClasse := mv_par01
	n860BClasse := mv_par02
	n860CClasse := mv_par03
	c860Categor := ""
	n860PonOrd  := mv_par05
	n860GpeOrd  := mv_par06
	For nx := 1 to Len(mv_par04)
		If !Empty(Substr(mv_par04,nx,1)).and.(Substr(mv_par04,nx,1)!="*")
			c860Categor += "'"+Substr(mv_par04,nx,1)+"',"
		Endif
	Next nx
	c860Categor := Left(c860Categor,Len(c860Categor)-1)
Endif

Return

Static Function GB860AltPeri()
***************************
LOCAL oPeri := Nil, cPeri1 := Space(6), cPeri2 := Space(6), nOpcy := 0

//Monto tela para novo ano base
///////////////////////////////////////
cPeri1 := c860Peri1 ; cPeri2 := c860Peri2
DEFINE MSDIALOG oPeri TITLE "Altera Periodo" FROM 0,0 TO 80,260 OF oDlgGer PIXEL
@ 008,010 SAY "Periodo:" OF oPeri SIZE 30,10 PIXEL
@ 006,035 GET cPeri1 OF oPeri SIZE 30,10 VALID !Empty(cPeri1) PIXEL
@ 008,065 SAY "ate" OF oPeri SIZE 20,10 PIXEL
@ 006,075 GET cPeri2 OF oPeri SIZE 30,10 VALID !Empty(cPeri2) PIXEL
@ 025,010 BUTTON "Confirma" SIZE 50,10 OF oPeri PIXEL ACTION (nOpcy:=1,oPeri:End())
@ 025,060 BUTTON "Cancela" SIZE 50,10 OF oPeri PIXEL ACTION (nOpcy:=2,oPeri:End())
ACTIVATE MSDIALOG oPeri CENTER
If (nOpcy == 1)
	c860Peri1 := cPeri1
	c860Peri2 := cPeri2
	o860Peri:cCaption := "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2)
	o860Peri:Refresh()
	GB860Atualiza()
Endif
Return

Static Function GB860Atualiza()
***************************
Processa({||GB860ProcAtu()})
Return

Static Function GB860ProcAtu()
***************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo Ponto/RH                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||GB860ProAno(@aHeader,@aCols)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo getdados                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetPon != Nil)
	oGetPon:aCols := aClone(aCols)
	oGetPon:oBrowse:Refresh()
Endif

Return

Static Function GB860ProAno(aHeader,aCols)
************************************
LOCAL cQuery := "", cPeriodo := "", aTotal
LOCAL nHrsExt, nHrsPag, nValPag, nNumFun

//Busco o informacoes Ponto/RH por empresa
//////////////////////////////////////////
a860PonAno := {}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Visao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados do Ponto/RH
	///////////////////////////////////////////////////
	cQuery := "SELECT ZMP.* "
	cQuery += "FROM "+GB860RetArq("ZMP",MEMP->M_codemp)+" ZMP WHERE ZMP.D_E_L_E_T_ = '' "
	cQuery += "AND ZMP.ZMP_FILIAL = '"+GB860RetFil("ZMP",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND ZMP.ZMP_ANOMES BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	cQuery += "ORDER BY ZMP_ANOMES "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	TCSetField("MAR","ZMP_DTATUA","D",08,0)
	nHrsExt := 0 ; nHrsPag := 0 ; nValPag := 0 ; nNumFun := 0 ; nValExt := 0 ; nValNom := 0
	dbSelectArea("MAR")
	While !Eof()
		cAnoMes := MAR->ZMP_anomes+" - "+Upper(Substr(MesExtenso(Val(Substr(MAR->ZMP_anomes,5,2))),1,3))
		nPos := aScan(a860PonAno, {|x| x[1] == cAnoMes })
		If (nPos == 0)
			aadd(a860PonAno,{cAnoMes,0,0,0,0,0,0,0,0,0,0,0,0,0,0})
			nPos := Len(a860PonAno)
		Endif
		a860PonAno[nPos,GDV_INUMFU] += MAR->ZMP_numfun
		a860PonAno[nPos,GDV_ITURNO] += MAR->ZMP_turnov
		a860PonAno[nPos,GDV_ITREIN] += MAR->ZMP_hrtrfu
		a860PonAno[nPos,GDV_IABSEN] += MAR->ZMP_absent
		a860PonAno[nPos,GDV_IHRABO] += MAR->ZMP_hrsabo
		a860PonAno[nPos,GDV_IHRATR] += MAR->ZMP_hrsatr
		a860PonAno[nPos,GDV_IHRFAL] += MAR->ZMP_hrsfal
		a860PonAno[nPos,GDV_IHRBHR] += MAR->ZMP_hrsbhr
		a860PonAno[nPos,GDV_IHRPAG] += MAR->ZMP_hrspag
		a860PonAno[nPos,GDV_IHREXT] += MAR->ZMP_hrsext
		a860PonAno[nPos,GDV_IVLNOM] += MAR->ZMP_valnom
		a860PonAno[nPos,GDV_IVLPAG] += MAR->ZMP_valpag
		a860PonAno[nPos,GDV_IVLEXT] += MAR->ZMP_valext
		nNumFun := MAR->ZMP_numfun
		nHrsExt += MAR->ZMP_hrsext
		nHrsPag += MAR->ZMP_hrspag
		nValNom += MAR->ZMP_valnom
		nValPag += MAR->ZMP_valpag
		nValExt += MAR->ZMP_valext
		If Empty(d860DtUltAtu).or.(dtos(d860DtUltAtu)+c860HrUltAtu < dtos(MAR->ZMP_dtatua)+MAR->ZMP_hratua)
			d860DtUltAtu := MAR->ZMP_dtatua
			c860HrUltAtu := MAR->ZMP_hratua
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo
	
	dbSelectArea("MEMP")
	Reclock("MEMP",.F.)
	MEMP->M_NUMFUN := nNumFun
	MEMP->M_HRSEXT := nHrsExt
	MEMP->M_HRSPAG := nHrsPag
	MEMP->M_VALNOM := nValNom
	MEMP->M_VALPAG := nValPag
	MEMP->M_VALEXT := nValExt
	MsUnlock("MEMP")
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//Monto aHeader e aCols
///////////////////////
aHeader := {}
aadd(aHeader,{"Ano/Mes"     ,"M_MES"    ,"@!"              ,12,0,"","","C","",""})
aadd(aHeader,{"Funcion[FUN]","M_NUMFUN" ,"@E 999999"         ,06,0,"","","N","",""})
aadd(aHeader,{"% Turno[FUN]","M_TURNOV" ,"@E 999.99"         ,06,0,"","","N","",""})
aadd(aHeader,{"Hrs Trn[TRN]","M_TREINA" ,"@E 999.99"         ,06,0,"","","N","",""})
aadd(aHeader,{"% Absen[ABS]","M_ABSENT" ,"@E 999.99"         ,06,2,"","","N","",""})
aadd(aHeader,{"Hrs Abn[PON]","M_HRSABO" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Hrs Atr[PON]","M_HRSATR" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Hrs Flt[PON]","M_HRSFAL" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Bco Hrs[PON]","M_HRSBHR" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Hrs Pgs[FOL]","M_HRSPAG" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Hrs Ext[FOL]","M_HRSEXT" ,"@E 9,999,999.99"   ,11,2,"","","N","",""})
aadd(aHeader,{"Vlr Nom[FOL]","M_VALNOM" ,"@E 999,999,999.99" ,14,2,"","","N","",""})
aadd(aHeader,{"Vlr Pag[FOL]","M_VALPAG" ,"@E 999,999,999.99" ,14,2,"","","N","",""})
aadd(aHeader,{"Vlr HEx[FOL]","M_VALEXT" ,"@E 999,999,999.99" ,14,2,"","","N","",""})
If (oGetPon != Nil)
	oGetPon:aHeader := aClone(aHeader)
Endif
nTurno := 0 ; nTrein := 0 ; aCols := {} ; N := 1
aTotal := {0,0,0,0,0,0,0,0,0,0}
For ni := 1 to Len(a860PonAno)
	aadd(aCols,{a860PonAno[ni,GDV_IANOME],	a860PonAno[ni,GDV_INUMFU],a860PonAno[ni,GDV_ITURNO],a860PonAno[ni,GDV_ITREIN],a860PonAno[ni,GDV_IABSEN],u_GDVDecHora(a860PonAno[ni,GDV_IHRABO]),u_GDVDecHora(a860PonAno[ni,GDV_IHRATR]),;
	u_GDVDecHora(a860PonAno[ni,GDV_IHRFAL]),u_GDVDecHora(a860PonAno[ni,GDV_IHRBHR]),u_GDVDecHora(a860PonAno[ni,GDV_IHRPAG]),u_GDVDecHora(a860PonAno[ni,GDV_IHREXT]),a860PonAno[ni,GDV_IVLNOM],a860PonAno[ni,GDV_IVLPAG],a860PonAno[ni,GDV_IVLEXT],.F.})
	aTotal[1] := a860PonAno[ni,GDV_INUMFU] ; aTotal[2] += a860PonAno[ni,GDV_IHRABO]
	aTotal[3] += a860PonAno[ni,GDV_IHRATR] ; aTotal[4] += a860PonAno[ni,GDV_IHRFAL]
	aTotal[5] += a860PonAno[ni,GDV_IHRBHR] ; aTotal[6] += a860PonAno[ni,GDV_IHRPAG]
	aTotal[7] += a860PonAno[ni,GDV_IHREXT] ;	aTotal[8] += a860PonAno[ni,GDV_IVLNOM]
	aTotal[9] += a860PonAno[ni,GDV_IVLPAG] ; aTotal[10]+= a860PonAno[ni,GDV_IVLEXT]
	nTurno += a860PonAno[ni,GDV_ITURNO]
	nTrein += a860PonAno[ni,GDV_ITREIN]
Next ni
nAbsen := ((aTotal[3]+aTotal[4])/Max(aTotal[6],1))*100
nTurno := nTurno/Max(Len(a860PonAno),1)
nTrein := nTrein/Max(Len(a860PonAno),1)
aadd(aCols,{"TOTAL >>> ",aTotal[1],nTurno,nTrein,nAbsen,u_GDVDecHora(aTotal[2]),u_GDVDecHora(aTotal[3]),u_GDVDecHora(aTotal[4]),u_GDVDecHora(aTotal[5]),u_GDVDecHora(aTotal[6]),u_GDVDecHora(aTotal[7]),aTotal[8],aTotal[9],aTotal[10],.F.})

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//Monta estrura do arquivo de indicadores
/////////////////////////////////////////
aStru := {}
aadd(aStru,{"M_OK"    ,"C",02,0})
aadd(aStru,{"M_INDICA","C",02,0})
aadd(aStru,{"M_DESCRI","C",20,0})
If (Select("MIND") <> 0)
	dbSelectArea("MIND")
	dbCloseArea("MIND")
Endif
c860ArqInd := CriaTrab(aStru,.t.)
dbUseArea(.T.,,c860ArqInd,"MIND",NIL,.F.)
For ni := 2 to Len(aHeader)
	dbSelectArea("MIND")
	Reclock("MIND",.T.)
	MIND->M_indica := Strzero(ni,2)
	MIND->M_descri := Upper(aHeader[ni,1])
	MsUnlock("MIND")
Next ni
MIND->(dbGotop())

Return

Static Function GB860TpGraf()
*************************
LOCAL oDlgSer, oSer, cCbx := "Linha", nCbx := 1, nOpcg := 0, nSerie2, nCor := 1
LOCAL aCbx := {"Linha","Área","Pontos","Barras","Piramid","Cilindro","Barras Horizontal","Piramid Horizontal",;
"Cilindro Horizontal","Pizza","Forma","Linha rápida","Flexas","GANTT","Bolha"}
DEFINE MSDIALOG oDlgSer TITLE "Tipo do gráfico" FROM 0,0 TO 90,280 PIXEL OF oDlgGer
@ 008, 005 SAY "Escolha o tipo de série:" PIXEL OF oDlgSer
@ 008, 063 MSCOMBOBOX oSer VAR cCbx ITEMS aCbx SIZE 077, 120 OF oDlgSer PIXEL ON CHANGE nCbx := oSer:nAt
@ 028, 045 BUTTON "&Ok"   SIZE 30,12 OF oDlgSer PIXEL ACTION (nOpcg := 1,oDlgSer:End())
@ 028, 075 BUTTON "&Sair" SIZE 30,12 OF oDlgSer PIXEL ACTION (nOpcg := 2,oDlgSer:End())
ACTIVATE MSDIALOG oDlgSer CENTER
Return nCbx

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE FUNCIONARIOS /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860AConFun(xTipo,xCols,xAt)
****************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "GDView Gestao Pessoal - Drill-Down [Funcionarios]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If (Len(cChaveX) >= 5 .and. Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConFun, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConFun[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860ADrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,400)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ aPosObjX[1,1],aPosObjX[1,2] SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ aPosObjX[1,1],aPosObjX[1,2]+150 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ aPosObjX[1,1]+14,aPosObjX[1,2] TO aPosObjX[1,1]+15,(aPosObjX[1,4]-aPosObjX[1,2]) LABEL "" OF oDlgConX PIXEL
@ aPosObjX[2,1],010 SAY oClasseA VAR "CLASSE A: "+Alltrim(Transform(nClasseA,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ aPosObjX[2,1],100 SAY oClasseB VAR "CLASSE B: "+Alltrim(Transform(nClasseB,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ aPosObjX[2,1],190 SAY oClasseC VAR "CLASSE C: "+Alltrim(Transform(nClasseC,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oMatriz  := u_GDVButton(oDlgConX,"oMatriz","Qualificacao",aPosObjX[2,4]-210,aPosObjX[2,1],40,,{||GB860AMatriz(oGetConX:aCols,oGetConX:oBrowse:nAt,c860Filtro)})
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),aPosObjX[2,4]-250,aPosObjX[2,1],40,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"   ,aPosObjX[2,4]-210,aPosObjX[2,1],40,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Var.Regis.",aPosObjX[2,4]-170,aPosObjX[2,1],40,,{||GB860AVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Var.Part." ,aPosObjX[2,4]-130,aPosObjX[2,1],40,,{||GB860AVariac(2,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Var.Ativos",aPosObjX[2,4]-090,aPosObjX[2,1],40,,{||GB860AVariac(3,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Var.Trabah",aPosObjX[2,4]-050,aPosObjX[2,1],40,,{||GB860AVariac(4,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[3,1],aPosObjX[3,2],aPosObjX[3,3],aPosObjX[3,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConFun)
	If (a860ConFun[ni,3])
		bBlockX := &("{||GB860AConFun('"+a860ConFun[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConFun[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,aPosObjX[4,4]-130,aPosObjX[4,1],40,,{||GB860ExpExcel(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",aPosObjX[4,4]-090,aPosObjX[4,1],40,,{||GB860Imprime(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,aPosObjX[4,4]-050,aPosObjX[4,1],40,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConFun, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConFun[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860ADrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL nTotReg := 0, nTotAti := 0, nTotAfa := 0, nTotFer := 0, nTotAdm := 0, nTotDem := 0, nTotTra := 0
LOCAL nRegOut := 0, nAtiOut := 0, nAfaOut := 0, nFerOut := 0, nAdmOut := 0, nDemOut := 0
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY, cQuebra
LOCAL lImp, cPeriY, cChaveY, aDadosY := {}, nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"   , xValor, "SRA"})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"  , xValor, "CTT"})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"RA.RA_CC"       , xValor, "SRA"})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"  , xValor, "SRA"})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"  , xValor, "SRA"})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"RA.RA_MAT"      , xValor, "SRA"})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"  , xValor, "SRA"})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"     , xValor, "SRA"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

nTotReg := 0 ; nTotAti := 0 ; nTotAfa := 0 ; nTotTra := 0
nTotFer := 0 ; nTotAdm := 0 ; nTotDem := 0
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de funcionarios
	///////////////////////////////////////////////
	nPosY  := Len(a860Filtro)
	If ("RA_MAT"$a860Filtro[nPosY,2])
		cQuery := "SELECT "+a860Filtro[nPosY,2]+" M_QUEBRA,"
	Else
		cQuery := "SELECT RA_MAT,"+a860Filtro[nPosY,2]+" M_QUEBRA,"
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+Left(cPeriY,6)+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+Left(cPeriY,6)+"ZZ')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery += "AND ((A.R8_DATAINI BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ') OR (R8_DATAINI <= '"+Left(cPeriY,6)+"' AND (R8_DATAFIM >= '"+Left(cPeriY,6)+"' OR R8_DATAFIM = ''))) "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAFA, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO = 'F' "
		cQuery += "AND A.R8_DATAINI BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTFER, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) = '"+Left(cPeriY,6)+"') THEN 1 ELSE 0 END) M_TOTADM, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) = '"+Left(cPeriY,6)+"') THEN 1 ELSE 0 END) M_TOTDEM  "
	Else
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+c860Peri2+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+c860Peri2+"ZZ')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery += "AND ((A.R8_DATAINI BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') OR (R8_DATAINI <= '"+Left(c860Peri2,6)+"' AND (R8_DATAFIM >= '"+Left(c860Peri2,6)+"' OR R8_DATAFIM = ''))) "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAFA, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO = 'F' "
		cQuery += "AND A.R8_DATAINI BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTFER, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') THEN 1 ELSE 0 END) M_TOTADM, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') THEN 1 ELSE 0 END) M_TOTDEM "
	Endif
	cQuery += "FROM "+GB860RetArq("SRA",MEMP->M_codemp)+" RA,"+GB860RetArq("CTT",MEMP->M_codemp)+" CT "
	cQuery += "WHERE RA.D_E_L_E_T_ = '' AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.D_E_L_E_T_ = '' AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_CC = CT.CTT_CUSTO "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	If ("RA_MAT"$a860Filtro[nPosY,2])
		cQuery += "GROUP BY "+a860Filtro[nPosY,2]+" "
		cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	Else
		cQuery += "GROUP BY RA_MAT,"+a860Filtro[nPosY,2]+" "
		cQuery += "ORDER BY RA_MAT,"+a860Filtro[nPosY,2]+" "
	Endif
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()
		If ((MAR->M_totnor+MAR->M_totafa+MAR->M_totfer+MAR->M_totadm+MAR->M_totdem) > 0)
			nPosY := aScan(aDadosY, {|x| x[1] == MAR->M_quebra })
			If (nPosY == 0)
				aadd(aDadosY,{MAR->M_quebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0,0,0,0})
				nPosY := Len(aDadosY)
			Endif
			aDadosY[nPosY,4] += MAR->M_totnor
			aDadosY[nPosY,5] += MAR->M_totafa
			aDadosY[nPosY,6] += MAR->M_totnor-MAR->M_totafa
			aDadosY[nPosY,7] += MAR->M_totfer
			aDadosY[nPosY,8] += MAR->M_totnor-MAR->M_totafa-MAR->M_totfer
			aDadosY[nPosY,9] += MAR->M_totadm
			aDadosY[nPosY,10]+= MAR->M_totdem
			nTotReg += MAR->M_totnor
			nTotAfa += MAR->M_totafa
			nTotAti += MAR->M_totnor-MAR->M_totafa
			nTotFer += MAR->M_totfer
			nTotTra += MAR->M_totnor-MAR->M_totafa-MAR->M_totfer
			nTotAdm += MAR->M_totadm
			nTotDem += MAR->M_totdem
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno Matriz                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FUN")
	aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
Else
	aDadosY := aSort(aDadosY,,,{|x,y| x[4]>y[4]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"CTT_HIERAR" ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"CTT_DESC01" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"CTT_CUSTO"  ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"CTT_DESC01" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"RJ_FUNCAO"  ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RJ_DESC"    ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"RA_CATFUNC" ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RJ_DESC"    ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"ZM2_OPERA"  ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"RA_NOME"    ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TIP") //Visao por Tipo de Verba
	aadd(aHeader,{"Verba"       ,"RV_COD"     ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RV_DESC"    ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"R6_TURNO"   ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"R6_DESC"    ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"RA_SEXO"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RJ_DESC"    ,"@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Registrados","M_REGISTR" ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Afastados"  ,"M_AFASTAD" ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Ativos"     ,"M_ATIVOS"  ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Ferias"     ,"M_FERIAS"  ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Trabalhando","M_TRABALH" ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Admitidos"  ,"M_ADMITID" ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"Demitidos"  ,"M_DEMITID" ,"@E 99999999",9,0,"","","N","",""})
aadd(aHeader,{"% Turnover" ,"M_TURNOVE" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"       ,"M_RANK"    ,"@E 99999",5,0,"","","N","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*nTotReg
nClasseB := (n860BClasse/100)*nTotReg
nClasseC := (n860CClasse/100)*nTotReg
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,4]
	nTurnoY := 0
	If (aDadosY[ni,6] > 0)
		nTurnoY := (((aDadosY[ni,9]+aDadosY[ni,10])/2)/aDadosY[ni,6])*100
	Endif
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "NIV") //Visao por Nivel
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],aDadosY[ni,8],aDadosY[ni,9],aDadosY[ni,10],nTurnoY,ni,.F.})
	Endif
Next ni
If (nTotReg > 0).or.(nTotAti > 0).or.(nTotAfa > 0).or.(nTotTra > 0).or.;
	(nTotFer > 0).or.(nTotAdm > 0).or.(nTotDem > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_REGISTR")
			aCols[nPosY,ni] := nTotReg
		Elseif (Alltrim(aHeader[ni,2]) == "M_ATIVOS")
			aCols[nPosY,ni] := nTotAti
		Elseif (Alltrim(aHeader[ni,2]) == "M_AFASTAD")
			aCols[nPosY,ni] := nTotAfa
		Elseif (Alltrim(aHeader[ni,2]) == "M_FERIAS")
			aCols[nPosY,ni] := nTotFer
		Elseif (Alltrim(aHeader[ni,2]) == "M_TRABALH")
			aCols[nPosY,ni] := nTotTra
		Elseif (Alltrim(aHeader[ni,2]) == "M_ADMITID")
			aCols[nPosY,ni] := nTotAdm
		Elseif (Alltrim(aHeader[ni,2]) == "M_DEMITID")
			aCols[nPosY,ni] := nTotDem
		Elseif (Alltrim(aHeader[ni,2]) == "M_TURNOVE").and.(nTotAti > 0)
			aCols[nPosY,ni] := (((nTotAdm+nTotDem)/2)/nTotAti)*100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860AVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
//If Empty(cChaveZ).or.(Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860AVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 140, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Registrados" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ (aSizeGrfZ[4]-5), 250 SAY "% Participacao" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ (aSizeGrfZ[4]-5), 250 SAY "Ativos" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 4)
	@ (aSizeGrfZ[4]-5), 250 SAY "Afastados" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 5)
	@ (aSizeGrfZ[4]-5), 250 SAY "Ferias" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860AVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0,0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	For nx := 1 to Len(aVarPer)
		cQuery7 := "SELECT RA.RA_MAT,"
		cQuery7 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+aVarPer[nx,1]+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+aVarPer[nx,1]+"99')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery7 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery7 += "AND ((A.R8_DATAINI BETWEEN '"+aVarPer[nx,1]+"' AND '"+aVarPer[nx,1]+"99') OR (R8_DATAINI <= '"+aVarPer[nx,1]+"' AND (R8_DATAFIM >= '"+aVarPer[nx,1]+"' OR R8_DATAFIM = ''))) "
		cQuery7 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'99'))) M_TOTAFA, "
		cQuery7 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO = 'F' "
		cQuery7 += "AND A.R8_DATAINI BETWEEN '"+aVarPer[nx,1]+"' AND '"+aVarPer[nx,1]+"99' "
		cQuery7 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'99'))) M_TOTFER, "
		cQuery7 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) = '"+aVarPer[nx,1]+"') THEN 1 ELSE 0 END) M_TOTADM, "
		cQuery7 += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) = '"+aVarPer[nx,1]+"') THEN 1 ELSE 0 END) M_TOTDEM  "
		cQuery7 += "FROM "+GB860RetArq("SRA",MEMP->M_codemp)+" RA,"+GB860RetArq("CTT",MEMP->M_codemp)+" CT "
		cQuery7 += "WHERE RA.D_E_L_E_T_ = '' AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND CT.D_E_L_E_T_ = '' AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND RA.RA_CC = CT.CTT_CUSTO "
		If !Empty(c860Categor)
			cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
		Endif
		For ni := 1 to Len(a860Filtro)-1
			cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
		Next ni
		cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
		cQuery7 += "GROUP BY RA.RA_MAT "
		cQuery7 += "ORDER BY RA.RA_MAT "
		cQuery7 := ChangeQuery(cQuery7)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery7 NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !Eof()
			If ((MAR->M_totnor+MAR->M_totafa+MAR->M_totfer+MAR->M_totadm+MAR->M_totdem) > 0)
				aVarPer[nx,2] += MAR->M_totnor
				aVarPer[nx,3] += MAR->M_totafa
				aVarPer[nx,4] += MAR->M_totnor-MAR->M_totafa
				aVarPer[nx,5] += MAR->M_totfer
				aVarPer[nx,6] += MAR->M_totnor-MAR->M_totafa-MAR->M_totfer
				aVarPer[nx,7] += MAR->M_totadm
				aVarPer[nx,8] += MAR->M_totdem
				aTotal7[1] += MAR->M_totnor
				aTotal7[2] += MAR->M_totafa
				aTotal7[3] += MAR->M_totnor-MAR->M_totafa
				aTotal7[4] += MAR->M_totfer
				aTotal7[5] += MAR->M_totnor-MAR->M_totafa-MAR->M_totfer
				aTotal7[6] += MAR->M_totadm
				aTotal7[7] += MAR->M_totdem
			Endif
			dbSelectArea("MAR")
			dbSkip()
		Enddo
	Next nx
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "Registrados"
Elseif (xTipo == 2)
	aCols[1,1] := "% Participacao"
Elseif (xTipo == 3)
	aCols[1,1] := "Ativos"
Elseif (xTipo == 4)
	aCols[1,1] := "Trabalhando"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := 0
	If (xTipo == 1)
		nValor7 := aVarPer[ni,2]
	Elseif (xTipo == 2)
		nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
		If (nPos7 > 0).and.(a860PonAno[nPos7,GDV_INUMFU] > 0)
			nValor7 := (aVarPer[ni,2]/a860PonAno[nPos7,GDV_INUMFU])*100
		Else
			nValor7 := (aVarPer[ni,2]/a860PonAno[1,GDV_INUMFU])*100
		Endif
	Elseif (xTipo == 3) //Ativos
		nValor7 := aVarPer[ni,4]
	Elseif (xTipo == 4) //Trabalhando
		nValor7 := aVarPer[ni,6]
	Endif
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return               

Static Function GB860AMatriz(xCols,xAt,xFiltro)
*****************************************
LOCAL oDlgMatZ, oGetMatZ, oGetCurZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cMatPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Matriz de Qualificacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; aHCurso := {} ; aCCurso := {} ; N := 1
Processa({||GB860AMatDet(@aHeader,@aCols,@aHCurso,@aCCurso)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0, 100, .T., .T. })
AAdd(aObjectsZ,{  0,  80, .T., .F. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgMatZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "MATRIZ DE QUALIFICACAO: " OF oDlgMatZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgMatZ PIXEL
cMatPerZ := xFiltro
@ 010,110 SAY oMatPer VAR cMatPerZ OF oDlgMatZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta da Matriz de Qualificacao       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetMatZ := MsNewGetDados():New(aPosObjZ[2,1],aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgMatZ,aHeader,aCols)
oGetMatZ:oBrowse:bLDblClick := { || GB860Coluna(oGetMatZ,oGetMatZ:oBrowse:nColPos) }
oGetMatZ:oBrowse:lUseDefaultColors := .F.
oGetMatZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})
oButMat1 := u_GDVButton(oDlgMatZ,"oButMat1","Matriz Produtos" ,010,aPosObjZ[2,1]+15,110,,{||GB860AMatPro(oGetMatZ,oGetMatZ:oBrowse:nAt)})
oButMat2 := u_GDVButton(oDlgMatZ,"oButMat2","Matriz Maquinas" ,120,aPosObjZ[2,1]+15,110,,{||GB860AMatMaq(oGetMatZ,oGetMatZ:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta da Legenda dos Cursos           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetCurZ := MsNewGetDados():New(aPosObjZ[3,1],aPosObjZ[3,2],aPosObjZ[3,3]+10,aPosObjZ[3,4]/2,4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgMatZ,aHCurso,aCCurso)
oGetCurZ:oBrowse:bLDblClick := { || GB860AVerCurso(oGetCurZ,oGetCurZ:oBrowse:nAt) }
oGetCurZ:oBrowse:lUseDefaultColors := .F.
oGetCurZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

oVisuZ := u_GDVButton(oDlgMatZ,"oVisuZ" ,"Visualizar" ,(oDlgMatZ:nClientWidth-320),(oDlgMatZ:nClientHeight-60),,,{||GB860AVerCurso(oGetCurZ,oGetCurZ:oBrowse:nAt)})
oSoliZ := u_GDVButton(oDlgMatZ,"oSoliZ" ,"Solicitar"  ,(oDlgMatZ:nClientWidth-260),(oDlgMatZ:nClientHeight-60),,,{||GB860ASolCurso(oGetCurZ,oGetCurZ:oBrowse:nAt)})
oExceZ := u_GDVButton(oDlgMatZ,"oButExc","Excel"      ,(oDlgMatZ:nClientWidth-200),(oDlgMatZ:nClientHeight-60),,,{||GB860ExpExcel(@oGetMatZ:aHeader,@oGetMatZ:aCols)})
oImprZ := u_GDVButton(oDlgMatZ,"oButImp","Imprimir"   ,(oDlgMatZ:nClientWidth-140),(oDlgMatZ:nClientHeight-60),,,{||GB860Imprime(oGetMatZ:aHeader,oGetMatZ:aCols)})
oFechZ := u_GDVButton(oDlgMatZ,"oButFec","Fechar"     ,(oDlgMatZ:nClientWidth-080),(oDlgMatZ:nClientHeight-60),,,{||oDlgMatZ:End()})

ACTIVATE MSDIALOG oDlgMatZ CENTER

Return

Static Function GB860AMatDet(aHeader,aCols,aHCurso,aCCurso)
****************************************************
LOCAL cQuery8, cQueryX, nLin8, nPos8, aTreinam, aMatriz, cCurDe, cCurAt
LOCAL ni, nx, nMostr, aRegs := {}, cPerg := "GB860M"

//Cria grupo de perguntas
/////////////////////////
AADD(aRegs,{cPerg,"01","Mostrar    ?","mv_ch1","N",01,0,0,"C","","MV_PAR01","Todos","","","Realizados","","","Pendentes","","","Planejados","","","","",""})
AADD(aRegs,{cPerg,"02","Curso De   ?","mv_ch2","C",04,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","RA1"})
AADD(aRegs,{cPerg,"03","Curso Ate  ?","mv_ch3","C",04,0,0,"G","","MV_PAR03","","ZZZZ","","","","","","","","","","","","","RA1"})
AADD(aRegs,{cPerg,"04","Area De    ?","mv_ch4","C",03,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","R1"})
AADD(aRegs,{cPerg,"05","Area Ate   ?","mv_ch5","C",03,0,0,"G","","MV_PAR05","","ZZZ","","","","","","","","","","","","","R1"})
AADD(aRegs,{cPerg,"06","Tipo De    ?","mv_ch6","C",03,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SQX"})
AADD(aRegs,{cPerg,"07","Tipo Ate   ?","mv_ch7","C",03,0,0,"G","","MV_PAR07","","ZZZ","","","","","","","","","","","","","SQX"})
u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW
If !Pergunte(cPerg,.T.)
	Return
Endif
nMostr := mv_par01
cCurDe := mv_par02
cCurAt := mv_par03
cAreDe := mv_par04
cAreAt := mv_par05
cTipDe := mv_par06
cTipAt := mv_par07

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTreinam := {} ; aMatriz := {}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery8 := "SELECT RA.RA_MAT,RA.RA_NOME,RA.RA_ADMISSA,RA.RA_CC, "
	If (Left(cPeriY,5) != "TOTAL")
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+Left(cPeriY,6)+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+Left(cPeriY,6)+"ZZ')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery8 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery8 += "AND ((A.R8_DATAINI BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ') OR (R8_DATAINI <= '"+Left(cPeriY,6)+"' AND (R8_DATAFIM >= '"+Left(cPeriY,6)+"' OR R8_DATAFIM = ''))) "
		cQuery8 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAFA, "
		cQuery8 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO = 'F' "
		cQuery8 += "AND A.R8_DATAINI BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
		cQuery8 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTFER, "
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) = '"+Left(cPeriY,6)+"') THEN 1 ELSE 0 END) M_TOTADM, "
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) = '"+Left(cPeriY,6)+"') THEN 1 ELSE 0 END) M_TOTDEM  "
	Else
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+c860Peri2+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+c860Peri2+"ZZ')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery8 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery8 += "AND ((A.R8_DATAINI BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') OR (R8_DATAINI <= '"+Left(c860Peri2,6)+"' AND (R8_DATAFIM >= '"+Left(c860Peri2,6)+"' OR R8_DATAFIM = ''))) "
		cQuery8 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAFA, "
		cQuery8 += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+GB860RetArq("SR8",MEMP->M_codemp)+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+GB860RetFil("SR8",MEMP->M_codemp,MEMP->M_codfil)+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO = 'F' "
		cQuery8 += "AND A.R8_DATAINI BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
		cQuery8 += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTFER, "
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') THEN 1 ELSE 0 END) M_TOTADM, "
		cQuery8 += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ') THEN 1 ELSE 0 END) M_TOTDEM "
	Endif
	cQuery8 += "FROM "+GB860RetArq("SRA",MEMP->M_codemp)+" RA,"+GB860RetArq("CTT",MEMP->M_codemp)+" CT "
	cQuery8 += "WHERE RA.D_E_L_E_T_ = '' AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery8 += "AND CT.D_E_L_E_T_ = '' AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery8 += "AND RA.RA_CC = CT.CTT_CUSTO "
	If !Empty(c860Categor)
		cQuery8 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery8 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery8 += "GROUP BY RA.RA_MAT,RA.RA_NOME,RA.RA_ADMISSA,RA.RA_CC "
	cQuery8 += "ORDER BY RA.RA_MAT,RA.RA_NOME,RA.RA_ADMISSA,RA.RA_CC "
	cQuery8 := ChangeQuery(cQuery8)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery8 NEW ALIAS "MAR"
	TCSetField("MAR","RA_ADMISSA","D",08,0)
	dbSelectArea("MAR")
	While !MAR->(Eof())
	
		//Verifico se existem funcionarios no periodo
		/////////////////////////////////////////////
		If ((MAR->M_totnor+MAR->M_totafa+MAR->M_totfer+MAR->M_totadm+MAR->M_totdem) <= 0)
			MAR->(dbSkip())
			Loop
		Endif

		//Monto resumo dados Treinamentos Previstos
		////////////////////////////////////////////
		cQueryX := "SELECT RA5_CURSO,SUM(RA5_HORAS) RA5_HORAS "
		cQueryX += "FROM "+GB860RetArq("RA5",MEMP->M_codemp)+" RA5, "+GB860RetArq("RA1",MEMP->M_codemp)+" RA1, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA, "+GB860RetArq("SRJ",MEMP->M_codemp)+" RJ "
		cQueryX += "WHERE RA5.D_E_L_E_T_ = '' AND RA1.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND RJ.D_E_L_E_T_ = '' "
		cQueryX += "AND RA.RA_CODFUNC = RJ.RJ_FUNCAO AND RJ.RJ_CARGO = RA5.RA5_CARGO AND RA5.RA5_CURSO = RA1.RA1_CURSO "
		cQueryX += "AND RA5.RA5_FILIAL = '"+GB860RetFil("RA5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA1.RA1_FILIAL = '"+GB860RetFil("RA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RJ.RJ_FILIAL = '"+GB860RetFil("SRJ",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA.RA_MAT = '"+MAR->RA_MAT+"' AND RA5.RA5_CURSO BETWEEN '"+cCurDe+"' AND '"+cCurAt+"' "
		cQueryX += "AND RA1.RA1_AREA BETWEEN '"+cAreDe+"' AND '"+cAreAt+"' AND RA1.RA1_TIPOPP BETWEEN '"+cTipDe+"' AND '"+cTipAt+"' "
		cQueryX += "GROUP BY RA5_CURSO ORDER BY RA5_CURSO "
		cQueryX := ChangeQuery(cQueryX)
		If (Select("MTRN") <> 0)
			dbSelectArea("MTRN")
			dbCloseArea()
		Endif
		TCQuery cQueryX NEW ALIAS "MTRN"
		dbSelectArea("MTRN")
		While !MTRN->(Eof())
			If (aScan(aTreinam,MTRN->RA5_curso) == 0)
				aadd(aTreinam,MTRN->RA5_curso)
			Endif
			nPos8 := aScan(aMatriz, {|x| x[1]+x[5] == MAR->RA_MAT+MTRN->RA5_CURSO })
			If (nPos8 == 0)
				aadd(aMatriz,{MAR->RA_MAT,MAR->RA_NOME,MAR->RA_ADMISSA,MAR->RA_CC,MTRN->RA5_CURSO,0,Space(6)})
				nPos8 := Len(aMatriz)
			Endif
			aMatriz[nPos8,7] := " *PEN* "
			MTRN->(dbSkip())
		Enddo
	
		//Monto resumo dados Treinamentos Realizado
		///////////////////////////////////////////
		cQueryX := "SELECT RA4_CURSO,SUM(RA4_HORAS) RA4_HORAS "
		cQueryX += "FROM "+GB860RetArq("RA4",MEMP->M_codemp)+" RA4, "+GB860RetArq("RA1",MEMP->M_codemp)+" RA1, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
		cQueryX += "WHERE RA4.D_E_L_E_T_ = '' AND RA1.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND RA.RA_MAT = RA4.RA4_MAT AND RA4.RA4_CURSO = RA1.RA1_CURSO "
		cQueryX += "AND RA4.RA4_FILIAL = '"+GB860RetFil("RA4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA1.RA1_FILIAL = '"+GB860RetFil("RA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQueryX += "AND RA4.RA4_MAT = '"+MAR->RA_MAT+"' AND RA4.RA4_CURSO BETWEEN '"+cCurDe+"' AND '"+cCurAt+"' "
		cQueryX += "AND RA1.RA1_AREA BETWEEN '"+cAreDe+"' AND '"+cAreAt+"' AND RA1.RA1_TIPOPP BETWEEN '"+cTipDe+"' AND '"+cTipAt+"' "
		cQueryX += "GROUP BY RA4_CURSO ORDER BY RA4_CURSO "
		cQueryX := ChangeQuery(cQueryX)
		If (Select("MTRN") <> 0)
			dbSelectArea("MTRN")
			dbCloseArea()
		Endif
		TCQuery cQueryX NEW ALIAS "MTRN"
		dbSelectArea("MTRN")
		While !MTRN->(Eof())
			If (aScan(aTreinam,MTRN->RA4_curso) == 0)
				aadd(aTreinam,MTRN->RA4_curso)
			Endif
			nPos8 := aScan(aMatriz, {|x| x[1]+x[5] == MAR->RA_MAT+MTRN->RA4_CURSO })
			If (nPos8 == 0)
				aadd(aMatriz,{MAR->RA_MAT,MAR->RA_NOME,MAR->RA_ADMISSA,MAR->RA_CC,MTRN->RA4_CURSO,0,Space(6)})
				nPos8 := Len(aMatriz)
			Endif
			aMatriz[nPos8,6] += MTRN->RA4_HORAS
			aMatriz[nPos8,7] := " *REA* "
			MTRN->(dbSkip())
		Enddo
			
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo matriz de acordo com filtro                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTreinam := {}
For ni := 1 to Len(aMatriz)
	If ((nMostr == 2).and.(aMatriz[ni,7] != " *REA* ")).or.;
		((nMostr == 3).and.(aMatriz[ni,7] != " *PEN* ")).or.; 
		((nMostr == 4).and.(aMatriz[ni,7] != " *PLA* "))
		Loop
	Endif
	If (aScan(aTreinam,aMatriz[ni,5]) == 0)
		aadd(aTreinam,aMatriz[ni,5])
	Endif
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Matricula" ,"ZM2_OPERA" ,"@!",06,0,"","","C","",""})
aadd(aHeader,{"Nome"      ,"RA_NOME"   ,"@!",30,0,"","","C","",""})
aadd(aHeader,{"Admissao"  ,"M_ADMISSA" ,"@E",08,0,"","","D","",""})
aadd(aHeader,{"C.Custo"   ,"M_CUSTO"   ,"@!",09,0,"","","C","",""})
aadd(aHeader,{"Total Hrs" ,"M_TOTHOR"  ,"@E 999,999.99",11,2,"","","N","",""})
aSort(aTreinam)
For ni := 1 to Len(aTreinam)
	aadd(aHeader,{aTreinam[ni] ,"M_TRN"+Strzero(ni,3),"@!",06,0,"","","C","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMatriz := aSort(aMatriz,,,{|x,y| x[1]<y[1]})
aCols := {}
For ni := 1 to Len(aMatriz)
	If ((nMostr == 2).and.(aMatriz[ni,7] != " *REA* ")).or.;
		((nMostr == 3).and.(aMatriz[ni,7] != " *PEN* ")).or.; 
		((nMostr == 4).and.(aMatriz[ni,7] != " *PLA* "))
		Loop
	Endif
	nPos8 := aScan(aCols,{|x| x[1] == aMatriz[ni,1] })
	If (nPos8 == 0)
		aadd(aCols,Array(Len(aHeader)+1))
		nPos8 := Len(aCols)
		aCols[nPos8,5] := 0
		For nx := 6 to Len(aHeader)
			aCols[nPos8,nx] := Space(6)
		Next nx
		aCols[nPos8,Len(aHeader)+1] := .F.
	Endif
	aCols[nPos8,1] := aMatriz[ni,1]
	aCols[nPos8,2] := aMatriz[ni,2]
	aCols[nPos8,3] := aMatriz[ni,3]
	aCols[nPos8,4] := aMatriz[ni,4]
	aCols[nPos8,5] += aMatriz[ni,6]
	For nx := 1 to Len(aTreinam)	
		nLin8 := aScan(aTreinam,aMatriz[ni,5])
		If (nLin8 > 0)
			If (aMatriz[ni,6] > 0)
				aCols[nPos8,5+nLin8] := Transform(u_GDVDecHora(aMatriz[ni,6]),"@E 999.99")
			Elseif !Empty(aMatriz[ni,7])
				aCols[nPos8,5+nLin8] := aMatriz[ni,7]
			Endif
		Endif
	Next nx
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader e aCols dos Treinamentos                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHCurso := {} ; aCCurso := {}
aadd(aHCurso,{"Codigo"   ,"M_CODIGO" ,"@!",04,0,"","","C","",""})
aadd(aHCurso,{"Descricao","M_DESCRI" ,"@!",50,0,"","","C","",""})
RA1->(dbSetOrder(1))
For nx := 1 to Len(aTreinam)	
	If RA1->(dbSeek(xFilial("RA1")+aTreinam[nx]))
		aadd(aCCurso,{RA1->RA1_curso,RA1->RA1_desc,.F.})
	Endif
Next nx

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
If (Select("MTRN") <> 0)
	dbSelectArea("MTRN")
	dbCloseArea()
Endif

Return               

Static Function GB860AVerCurso(xObj,xCol)
************************************
If (xObj == Nil).or.(xCol <= 0)
	Return
Endif
RA1->(dbSetOrder(1))
If RA1->(dbSeek(xFilial("RA1")+xObj:aCols[xCol,1]))
	AxVisual("RA1",RA1->(Recno()),1,,,,)
Endif
Return

Static Function GB860ASolCurso(xObj,xCol)
************************************
If (xObj == Nil).or.(xCol <= 0)
	Return
Endif
RA1->(dbSetOrder(1))
If RA1->(dbSeek(xFilial("RA1")+xObj:aCols[xCol,1]))
	dbSelectArea("RA1")
	TRMM030() //Funcao Padrao
Endif
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE INFORMACOES DO BANCO DE HORAS ////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860BConBan(xTipo,xCols,xAt)
***************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "GDView Gestao Pessoal - Drill-Down [Banco de Horas]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If (Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConBan, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConBan[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860BDrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,430)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ 010,010 SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ 010,110 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ 019,aPosObjX[2,2] TO 020,(aPosObjX[2,4]-aPosObjX[2,2]) LABEL "" OF oDlgConX PIXEL
@ 021,010 SAY oClasseA VAR "CLASSE A: "+Transform(nClasseA,"@E 999,999,999.99")+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 028,010 SAY oClasseB VAR "CLASSE B: "+Transform(nClasseB,"@E 999,999,999.99")+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 035,010 SAY oClasseC VAR "CLASSE C: "+Transform(nClasseC,"@E 999,999,999.99")+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),(oDlgConX:nClientWidth-200),aPosObjX[2,1]+15,,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"    ,(oDlgConX:nClientWidth-140),aPosObjX[2,1]+15,,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Saldo Banco",(oDlgConX:nClientWidth-080),aPosObjX[2,1]+15,,,{||GB860BVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[2,1]+5,aPosObjX[2,2],aPosObjX[2,3],aPosObjX[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConBan)
	If (a860ConBan[ni,3])
		bBlockX := &("{||GB860BConBan('"+a860ConBan[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConBan[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,aPosObjX[4,4]-130,aPosObjX[4,1],40,,{||GB860ExpExcel(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",aPosObjX[4,4]-090,aPosObjX[4,1],40,,{||GB860Imprime(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,aPosObjX[4,4]-050,aPosObjX[4,1],40,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConBan, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConBan[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860BDrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL ni, nPosY, nTotal := 0
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY
LOCAL lImp, cPeriY, cChaveY, aDadosY := {}
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"   , xValor, "SRA", "RA.RA_FILIAL"})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"  , xValor, "CTT", "CT.CTT_HIERAR"})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"SP.PI_CC"       , xValor, "SPI", "SP.PI_CC"})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"  , xValor, "SRA", "RA.RA_CODFUNC"})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"  , xValor, "SRA", "RA.RA_CATFUNC"})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"SP.PI_MAT"      , xValor, "SPI", "SP.PI_MAT"})
Elseif (xTipo == "EVN") //Visao por Tipo de Verba
	aadd(a860Filtro,{"TIPO EVENTO" ,"SP.PI_PD"       , xValor, "SPI", "SP.PI_PD"})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"  , xValor, "SRA", "RA.RA_TNOTRAB"})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"     , xValor, "SRA", "RA.RA_SEXO"})
Elseif (xTipo == "DIA") //Visao por Sexo
	aadd(a860Filtro,{"DIA"        ,"SP.PI_DATA"      , xValor, "SPI", "SP.PI_DATA"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

aTotal := {0,0,0,0}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif

	//Monto resumo dados Banco de Horas
	///////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT P9_TIPOCOD M_TIPOCOD,"+a860Filtro[nPosY,2]+" M_QUEBRA,"
	cQuery += "SUM(FLOOR(PI_QUANT)+((PI_QUANT-FLOOR(PI_QUANT))/0.6)) M_SALDO "
	cQuery += "FROM "+GB860RetArq("SPI",MEMP->M_codemp)+" SP, "
	cQuery += GB860RetArq("SP9",MEMP->M_codemp)+" P9, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE SP.D_E_L_E_T_ = '' AND P9.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND SP.PI_PD = P9.P9_CODIGO AND SP.PI_MAT = RA.RA_MAT AND SP.PI_CC = CT.CTT_CUSTO "
	cQuery += "AND SP.PI_FILIAL = '"+GB860RetFil("SPI",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND P9.P9_FILIAL = '"+GB860RetFil("SP9",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' AND RA.RA_SITFOLH <> 'D' AND RA.RA_ACUMBH = 'S' "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND SP.PI_DATA BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND SP.PI_DATA BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY P9_TIPOCOD,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()
		nPosY := aScan(aDadosY, {|x| x[1] == MAR->M_quebra })
		If (nPosY == 0)
			aadd(aDadosY,{MAR->M_quebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
			nPosY := Len(aDadosY)
		Endif
		If (MAR->M_TIPOCOD $ "1/3")
			aDadosY[nPosY,6] += MAR->M_SALDO
			aTotal[3] += MAR->M_SALDO
		Else
			aDadosY[nPosY,5] += MAR->M_SALDO
			aTotal[2] += MAR->M_SALDO
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo

	//Saldo banco de horas anterior
	///////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT P9_TIPOCOD M_TIPOCOD,"+a860Filtro[nPosY,2]+" M_QUEBRA,"
	cQuery += "SUM(FLOOR(PI_QUANT)+((PI_QUANT-FLOOR(PI_QUANT))/0.6)) M_SALDO "
	cQuery += "FROM "+GB860RetArq("SPI",MEMP->M_codemp)+" SP, "
	cQuery += GB860RetArq("SP9",MEMP->M_codemp)+" P9, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE SP.D_E_L_E_T_ = '' AND P9.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND SP.PI_PD = P9.P9_CODIGO AND SP.PI_MAT = RA.RA_MAT AND SP.PI_CC = CT.CTT_CUSTO "
	cQuery += "AND SP.PI_FILIAL = '"+GB860RetFil("SPI",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND P9.P9_FILIAL = '"+GB860RetFil("SP9",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' AND RA.RA_SITFOLH <> 'D' AND RA.RA_ACUMBH = 'S' "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND SP.PI_DATA < '"+Left(cPeriY,6)+"' "
	Else
		cQuery += "AND SP.PI_DATA < '"+c860Peri2+"' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY P9_TIPOCOD,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()                           
		cQuebra := MAR->M_quebra
		If (xTipo == "DIA").and.(Len(aDadosY) > 0)
			cQuebra := aDadosY[1,1]
		Endif
		nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
		If (nPosY == 0)
			aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
			nPosY := Len(aDadosY)
		Endif
		If (MAR->M_TIPOCOD $ "1/3")
			aDadosY[nPosY,4] += MAR->M_SALDO
			aTotal[1] += MAR->M_SALDO
		Else
			aDadosY[nPosY,4] -= MAR->M_SALDO
			aTotal[1] -= MAR->M_SALDO
		Endif
		aDadosY[nPosY,7] := (aDadosY[nPosY,4]+aDadosY[nPosY,6]-aDadosY[nPosY,5])
		dbSelectArea("MAR")
		dbSkip()
	Enddo

	//Saldo banco de horas atual
	////////////////////////////
	If (xTipo == "DIA")
		aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
		For nPosY := 1 to Len(aDadosY)
			If (nPosY > 1)
				aDadosY[nPosY,4] := aDadosY[nPosY-1,7]
			Endif
			aDadosY[nPosY,7] := (aDadosY[nPosY,4]+aDadosY[nPosY,6]-aDadosY[nPosY,5])
			aTotal[4] := (aDadosY[nPosY,4]+aDadosY[nPosY,6]-aDadosY[nPosY,5])
		Next nPosY
	Else
		For nPosY := 1 to Len(aDadosY)
			aTotal[4] += (aDadosY[nPosY,4]+aDadosY[nPosY,6]-aDadosY[nPosY,5])
		Next nPosY
	Endif
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())
                 
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Ponto/RH                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo != "DIA")
	aDadosY := aSort(aDadosY,,,{|x,y| x[7]>y[7]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"B1_DESC"    ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "EVN") //Visao por Evento
	aadd(aHeader,{"Evento"      ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",20,0,"","","C","",""})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(aHeader,{"Data"        ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Sld Anter"   ,"M_SLDANT" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Debito"      ,"M_HRSDEB" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Credito"     ,"M_HRSCRE" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Sld Atual"   ,"M_SLDATU" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI"  ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"   ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE" ,"@!",1,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*aTotal[4]
nClasseB := (n860BClasse/100)*aTotal[4]
nClasseC := (n860CClasse/100)*aTotal[4]
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
nPartY := 0 ; nPartAcmY := 0 ; cClasseY := ""
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,7]
	nPartY  := (nDadosY/Max(aTotal[4],1))*100
	nPartAcmY += nPartY
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += nDadosY
		cClasseY := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += nDadosY
		cClasseY := "B"
	Else
		nTotalC += nDadosY
		cClasseY := "C"
	Endif
	aDadosY[ni,4] := u_GDVDecHora(aDadosY[ni,4])
	aDadosY[ni,5] := u_GDVDecHora(aDadosY[ni,5])
	aDadosY[ni,6] := u_GDVDecHora(aDadosY[ni,6])
	aDadosY[ni,7] := u_GDVDecHora(aDadosY[ni,7])
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "NIV") //Visao por Nivel
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,(cChaveY)->RA_cc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "EVN") //Visao por Evento
		cChaveY := GB860RetAlias("SP9",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SP9",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->P9_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "ABO") //Visao por Abono
		cChaveY := GB860RetAlias("SP6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SP6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],iif(!Empty(aDadosY[ni,1]),(cChaveY)->P6_desc,""),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "DIA") //Visao por Dia
		aadd(aCols,{aDadosY[ni,1],GB860Semana(stod(aDadosY[ni,1])),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Endif
Next ni
If (aTotal[1] > 0).or.(aTotal[2] > 0).or.(aTotal[3] > 0).or.(aTotal[4] > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_SLDANT")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[1])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSDEB")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[2])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSCRE")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[3])
		Elseif (Alltrim(aHeader[ni,2]) == "M_SLDATU")   
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[4])
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPosY,ni] := 100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860BVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860BVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 370, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Saldo Banco"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860BVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Saldo banco de horas Ponto/RH
	///////////////////////////////
	cQuery7 := "SELECT PI_DATA M_EMISSAO,P9_TIPOCOD M_TIPOCOD,"
	cQuery7 += "SUM(FLOOR(PI_QUANT)+((PI_QUANT-FLOOR(PI_QUANT))/0.6)) M_SALDO "
	cQuery7 += "FROM "+GB860RetArq("SPI",MEMP->M_codemp)+" SP, "
	cQuery7 += GB860RetArq("SP9",MEMP->M_codemp)+" P9, "
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery7 += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE SP.D_E_L_E_T_ = '' AND P9.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND SP.PI_PD = P9.P9_CODIGO AND SP.PI_MAT = RA.RA_MAT AND SP.PI_CC = CT.CTT_CUSTO "
	cQuery7 += "AND SP.PI_FILIAL = '"+GB860RetFil("SPI",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND P9.P9_FILIAL = '"+GB860RetFil("SP9",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' AND RA.RA_SITFOLH <> 'D' AND RA.RA_ACUMBH = 'S' "
	cQuery7 += "AND SP.PI_DATA < '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY PI_DATA,P9_TIPOCOD "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	nSaldoIni := 0
	dbSelectArea("MAR")
	While !Eof()                                        
		If (c860Peri1 > Left(MAR->M_emissao,6))
			If (MAR->M_TIPOCOD $ "1/3")
				nSaldoIni += MAR->M_SALDO
			Else
				nSaldoIni -= MAR->M_SALDO
			Endif
		Elseif (c860Peri1 <= Left(MAR->M_emissao,6))
			nPos7 := aScan(aVarPer,{|x| x[1] == Left(MAR->M_emissao,6) })
			If (nPos7 == 0)
				aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0})
				nPos7 := Len(aVarPer)
			Endif
			If (MAR->M_TIPOCOD $ "1/3")
				aVarPer[nPos7,2] += MAR->M_SALDO
			Else
				aVarPer[nPos7,2] -= MAR->M_SALDO
			Endif
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo

	//Calculo saldo por mes
	///////////////////////
	For nPos7 := 1 to Len(aVarPer)
		If (nPos7 == 1)
			aVarPer[nPos7,2] := aVarPer[nPos7,2]+nSaldoIni
		Else
			aVarPer[nPos7,2] := aVarPer[nPos7,2]+aVarPer[nPos7-1,2]
		Endif
	Next nPos7
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "Saldo Banco"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := aVarPer[ni,2]
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE INFORMACOES DO PONTO /////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860CConPon(xTipo,xCols,xAt)
***************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "GDView Gestao Pessoal - Drill-Down [Ponto Eletronico]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If (Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConPon, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConPon[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860CDrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,430)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ 010,010 SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ 010,110 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ 019,aPosObjX[2,2] TO 020,(aPosObjX[2,4]-aPosObjX[2,2]) LABEL "" OF oDlgConX PIXEL
@ 021,010 SAY oClasseA VAR "CLASSE A: "+Transform(nClasseA,"@E 999,999,999.99")+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 028,010 SAY oClasseB VAR "CLASSE B: "+Transform(nClasseB,"@E 999,999,999.99")+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 035,010 SAY oClasseC VAR "CLASSE C: "+Transform(nClasseC,"@E 999,999,999.99")+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),(oDlgConX:nClientWidth-320),aPosObjX[2,1]+15,,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"    ,(oDlgConX:nClientWidth-260),aPosObjX[2,1]+15,,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Abono" ,(oDlgConX:nClientWidth-200),aPosObjX[2,1]+15,,,{||GB860CVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Atraso",(oDlgConX:nClientWidth-140),aPosObjX[2,1]+15,,,{||GB860CVariac(2,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Falta" ,(oDlgConX:nClientWidth-080),aPosObjX[2,1]+15,,,{||GB860CVariac(3,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[2,1]+5,aPosObjX[2,2],aPosObjX[2,3],aPosObjX[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConPon)
	If (a860ConPon[ni,3])
		bBlockX := &("{||GB860CConPon('"+a860ConPon[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConPon[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,aPosObjX[4,4]-130,aPosObjX[4,1],40,,{||GB860ExpExcel(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",aPosObjX[4,4]-090,aPosObjX[4,1],40,,{||GB860Imprime(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,aPosObjX[4,4]-050,aPosObjX[4,1],40,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConPon, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConPon[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860CDrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL ni, nPosY, nTotal := 0
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY
LOCAL lImp, cPeriY, cChaveY, aDadosY := {}
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"   , xValor, "SRA" , "RA.RA_FILIAL"})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"  , xValor, "CTT" , "CT.CTT_HIERAR"})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"RD.RD_CC"       , xValor, "SRD" , "RD.RD_CC"})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"  , xValor, "SRA" , "RA.RA_CODFUNC"})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"  , xValor, "SRA" , "RA.RA_CATFUNC"})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"RD.RD_MAT"      , xValor, "SRD" , "RD.RD_MAT"})
Elseif (xTipo == "VER") //Visao por Tipo de Verba
	aadd(a860Filtro,{"TIPO VERBA"  ,"RD.RD_PD"       , xValor, "SRD" , "RD.RD_PD"})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"  , xValor, "SRA" , "RA.RA_TNOTRAB"})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"     , xValor, "SRA" , "RA.RA_SEXO"})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(a860Filtro,{"DIA"        ,"RD.RD_DATARQ"    , xValor, "SRD" , "RD.RD_DATARQ"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

aTotal := {0,0,0}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif

	//Monto resumo dados Horas Abono / Horas Atraso / Horas Falta
	/////////////////////////////////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT RV_GDOPER M_VGOPER,"+a860Filtro[nPosY,5]+" M_QUEBRA,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '3' THEN RD_HORAS ELSE 0 END) M_HRSATR,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '4' THEN RD_HORAS ELSE 0 END) M_HRSABO,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '5' THEN RD_HORAS ELSE 0 END) M_HRSFAL,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '6' THEN RD_HORAS ELSE 0 END) M_HRSDES "
	cQuery += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "+GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL= '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' AND RA.RA_FILIAL = RD.RD_FILIAL "
	cQuery += "AND RD.RD_MES <> '13' AND RV.RV_TIPO IN ('H','V','D') AND RV.RV_GDTIPO IN ('3','4','5','6') "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND RD_DATARQ BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND RD_DATARQ BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY RV_GDOPER,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()           
		If ((MAR->M_HRSABO+MAR->M_HRSATR+MAR->M_HRSFAL-MAR->M_HRSDES) != 0)
			nPosY := aScan(aDadosY, {|x| x[1] == MAR->M_quebra })
			If (nPosY == 0)
				aadd(aDadosY,{MAR->M_quebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0})
				nPosY := Len(aDadosY)
			Endif                      
			If (MAR->M_vgoper == "+")
				aDadosY[nPosY,4] += MAR->M_HRSABO
				aDadosY[nPosY,5] += MAR->M_HRSATR
				aDadosY[nPosY,6] += MAR->M_HRSFAL-MAR->M_HRSDES
				aTotal[1] += MAR->M_HRSABO
				aTotal[2] += MAR->M_HRSATR
				aTotal[3] += MAR->M_HRSFAL-MAR->M_HRSDES
			Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,4] -= MAR->M_HRSABO
				aDadosY[nPosY,5] -= MAR->M_HRSATR
				aDadosY[nPosY,6] -= MAR->M_HRSFAL-MAR->M_HRSDES
				aTotal[1] -= MAR->M_HRSABO
				aTotal[2] -= MAR->M_HRSATR
				aTotal[3] -= MAR->M_HRSFAL-MAR->M_HRSDES
			Endif
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Ponto/RH                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "DIA")
	aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
Elseif (n860PonOrd == 1)
	aDadosY := aSort(aDadosY,,,{|x,y| x[4]>y[4]})
Elseif (n860PonOrd == 2)
	aDadosY := aSort(aDadosY,,,{|x,y| x[5]>y[5]})
Elseif (n860PonOrd == 3)
	aDadosY := aSort(aDadosY,,,{|x,y| x[6]>y[6]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"B1_DESC"    ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "VER") //Visao por Verba
	aadd(aHeader,{"Verba"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "ABO") //Visao por Abono
	aadd(aHeader,{"Tipo Abono"  ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",20,0,"","","C","",""})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(aHeader,{"Data"        ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Hrs Abono"   ,"M_HRSABO" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Hrs Atraso"  ,"M_HRSATR" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Hrs Falta"   ,"M_HRSFAL" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI"  ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"   ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE" ,"@!",1,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*aTotal[3]
nClasseB := (n860BClasse/100)*aTotal[3]
nClasseC := (n860CClasse/100)*aTotal[3]
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
nPartY := 0 ; nPartAcmY := 0 ; cClasseY := ""
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,6]
	nPartY  := (nDadosY/Max(aTotal[3],1))*100
	nPartAcmY += nPartY
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += nDadosY
		cClasseY := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += nDadosY
		cClasseY := "B"
	Else
		nTotalC += nDadosY
		cClasseY := "C"
	Endif
	aDadosY[ni,4] := u_GDVDecHora(aDadosY[ni,4])
	aDadosY[ni,5] := u_GDVDecHora(aDadosY[ni,5])
	aDadosY[ni,6] := u_GDVDecHora(aDadosY[ni,6])
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "NIV") //Visao por Nivel
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,(cChaveY)->RA_cc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "VER") //Visao por Evento
		cChaveY := GB860RetAlias("SRV",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRV",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RV_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "ABO") //Visao por Abono
		cChaveY := GB860RetAlias("SP6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SP6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],iif(!Empty(aDadosY[ni,1]),(cChaveY)->P6_desc,""),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "DIA") //Visao por Dia
		aadd(aCols,{aDadosY[ni,1],GB860Semana(stod(aDadosY[ni,1])),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Endif
Next ni
If (aTotal[1] > 0).or.(aTotal[2] > 0).or.(aTotal[3] > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSABO")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[1])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSATR")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[2])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSFAL")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[3])
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPosY,ni] := 100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860CVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860CVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 370, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Abono"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Atraso" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Falta"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860CVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery7 := "SELECT RD_DATARQ M_EMISSAO,RV_GDOPER M_VGOPER,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '3' THEN RD_HORAS ELSE 0 END) M_HRSATR,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '4' THEN RD_HORAS ELSE 0 END) M_HRSABO,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '5' THEN RD_HORAS ELSE 0 END) M_HRSFAL,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '6' THEN RD_HORAS ELSE 0 END) M_HRSDES "
	cQuery7 += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "
	cQuery7 += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery7 += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery7 += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_TIPO IN ('H','V','D') AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RD.RD_MES <> '13' AND RA.RA_FILIAL = RD.RD_FILIAL AND RV.RV_GDTIPO IN ('3','4','5','6') "
	cQuery7 += "AND RD.RD_DATARQ BETWEEN '"+cPerIni7+"' AND '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY RD_DATARQ,RV_GDOPER "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()              
		If ((MAR->M_HRSABO+MAR->M_HRSATR+MAR->M_HRSFAL-MAR->M_HRSDES) != 0)
			nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
			If (nPos7 == 0)
				aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0})
				nPos7 := Len(aVarPer)
			Endif
			If (MAR->M_vgoper == "+")
				If (xTipo == 1) //Abono
					aVarPer[nPos7,2] += MAR->M_HRSABO
				Elseif (xTipo == 2) //Atraso
					aVarPer[nPos7,2] += MAR->M_HRSATR
				Elseif (xTipo == 3) //Falta
					aVarPer[nPos7,2] += MAR->M_HRSFAL-MAR->M_HRSDES
				Endif
			Elseif (MAR->M_vgoper == "-")
				If (xTipo == 1) //Abono
					aVarPer[nPos7,2] -= MAR->M_HRSABO
				Elseif (xTipo == 2) //Atraso
					aVarPer[nPos7,2] -= MAR->M_HRSATR
				Elseif (xTipo == 3) //Falta
					aVarPer[nPos7,2] -= MAR->M_HRSFAL-MAR->M_HRSDES
				Endif
			Endif
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "Horas Abono"
Elseif (xTipo == 2)
	aCols[1,1] := "Horas Atraso"
Elseif (xTipo == 3)
	aCols[1,1] := "Horas Falta"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := aVarPer[ni,2]
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE INFORMACOES ABSENTEISMO //////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860EConAbs(xTipo,xCols,xAt)
***************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "GDView Gestao Pessoal - Drill-Down [Absenteismo]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If (Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConAbs, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConAbs[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860EDrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,430)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ 010,010 SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ 010,110 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ 019,aPosObjX[2,2] TO 020,(aPosObjX[2,4]-aPosObjX[2,2]) LABEL "" OF oDlgConX PIXEL
@ 021,010 SAY oClasseA VAR "CLASSE A: "+Transform(nClasseA,"@E 999,999,999.99")+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 028,010 SAY oClasseB VAR "CLASSE B: "+Transform(nClasseB,"@E 999,999,999.99")+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 035,010 SAY oClasseC VAR "CLASSE C: "+Transform(nClasseC,"@E 999,999,999.99")+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),(oDlgConX:nClientWidth-200),aPosObjX[2,1]+15,,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"   ,(oDlgConX:nClientWidth-140),aPosObjX[2,1]+15,,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Absenteis" ,(oDlgConX:nClientWidth-080),aPosObjX[2,1]+15,,,{||GB860EVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[2,1]+5,aPosObjX[2,2],aPosObjX[2,3],aPosObjX[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConAbs)
	If (a860ConAbs[ni,3])
		bBlockX := &("{||GB860EConAbs('"+a860ConAbs[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConAbs[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,aPosObjX[4,4]-130,aPosObjX[4,1],40,,{||GB860ExpExcel(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",aPosObjX[4,4]-090,aPosObjX[4,1],40,,{||GB860Imprime(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,aPosObjX[4,4]-050,aPosObjX[4,1],40,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConAbs, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConAbs[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860EDrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL ni, nPosY, nTotal := 0
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY
LOCAL lImp, cPeriY, cChaveY, aDadosY := {}
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"   , xValor, "SRA" , "RA.RA_FILIAL"})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"  , xValor, "CTT" , "CT.CTT_HIERAR"})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"RD.RD_CC"       , xValor, "SRD" , "PC.PC_CC"})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"  , xValor, "SRA" , "RA.RA_CODFUNC"})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"  , xValor, "SRA" , "RA.RA_CATFUNC"})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"RD.RD_MAT"      , xValor, "SRD" , "PC.PC_MAT"})
Elseif (xTipo == "VER") //Visao por Tipo de Verba
	aadd(a860Filtro,{"TIPO VERBA"  ,"RV.RV_COD"      , xValor, "SRD" , "RV.RV_COD"})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"  , xValor, "SRA" , "RA.RA_TNOTRAB"})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"     , xValor, "SRA" , "RA.RA_SEXO"})
Elseif (xTipo == "DIA") //Visao por Sexo
	aadd(a860Filtro,{"DIA"         ,"RD.RD_DATARQ"   , xValor, "SRD" , "PC.PC_DATA"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

aTotal := {0,0,0,0}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif

	//Monto resumo dados Horas Falta/Atraso
	///////////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT RV_GDOPER M_VGOPER,"+a860Filtro[nPosY,2]+" M_QUEBRA,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '5' THEN RD_HORAS ELSE 0 END) M_HRSFAL,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '3' THEN RD_HORAS ELSE 0 END) M_HRSATR,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '6' THEN RD_HORAS ELSE 0 END) M_HRSDES "
	cQuery += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD,"+GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT,"+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL= '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_TIPO IN ('H','V','D') AND RV.RV_GDTIPO IN ('3','5','6') "
	cQuery += "AND RD.RD_MES <> '13' AND RA.RA_FILIAL = RD.RD_FILIAL "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND RD_DATARQ BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND RD_DATARQ BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY RV_GDOPER,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		cQuebra := MAR->M_quebra
		If (xTipo == "DIA")
			cQuebra := Alltrim(MAR->M_quebra)+"01"
		Endif
		If ((MAR->M_HRSFAL+MAR->M_HRSATR-MAR->M_HRSDES) != 0)
			nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
			If (nPosY == 0)
				aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
				nPosY := Len(aDadosY)
			Endif                      
			If (MAR->M_vgoper == "+")
				aDadosY[nPosY,4] += MAR->M_HRSFAL-MAR->M_HRSDES
				aDadosY[nPosY,5] += MAR->M_HRSATR
				aTotal[1] += MAR->M_HRSFAL-MAR->M_HRSDES
				aTotal[2] += MAR->M_HRSATR
			Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,4] -= MAR->M_HRSFAL-MAR->M_HRSDES
				aDadosY[nPosY,5] -= MAR->M_HRSATR
				aTotal[1] -= MAR->M_HRSFAL-MAR->M_HRSDES
				aTotal[2] -= MAR->M_HRSATR
			Endif 
		Endif
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT RD_PD M_PD,RV_GDTIPO M_VGTIPO,RV_GDOPER M_VGOPER,
	cQuery += a860Filtro[nPosY,2]+" M_QUEBRA,
	cQuery += "SUM(RD_HORAS) M_HORAS "
	cQuery += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "
	cQuery += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_TIPO IN ('H','V','D') AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RD.RD_MES <> '13' AND RA.RA_FILIAL = RD.RD_FILIAL AND RV.RV_GDTIPO IN ('1','2') "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND RD_DATARQ BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND RD_DATARQ BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY RD_PD,RV_GDTIPO,RV_GDOPER,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		cQuebra := MAR->M_quebra
		If (xTipo == "DIA")
			cQuebra := Alltrim(MAR->M_quebra)+"01"
		Endif
		nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
		If (nPosY == 0)
			aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
			nPosY := Len(aDadosY)
		Endif
		nHoras := MAR->M_horas
		If (MAR->M_PD $ "101") //Salario Mensalista/Saldo Salario
			nHoras := MAR->M_horas*7.33
		Endif
		If (MAR->M_PD != "700")
		   If (MAR->M_vgoper == "+")
				aDadosY[nPosY,6] += nHoras
				aTotal[3] += nHoras
		   Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,6] += nHoras
				aTotal[3] += nHoras
			Endif
			aDadosY[nPosY,7] := ((aDadosY[nPosY,4]+aDadosY[nPosY,5])/Max(aDadosY[nPosY,6],1))*100
			aTotal[4] := ((aTotal[1]+aTotal[2])/Max(aTotal[3],1))*100
		Endif
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	If (Left(cPeriY,6) >= Substr(cPon2,1,6))

		//Monto resumo dados Horas Falta/Atraso
		///////////////////////////////////////
		nPosY  := Len(a860Filtro)
		cQuery := "SELECT RV_GDOPER M_VGOPER,"+a860Filtro[nPosY,5]+" M_QUEBRA,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '5' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) M_HRSFAL,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '3' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) M_HRSATR,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '6' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) M_HRSDES "
		cQuery += "FROM "+GB860RetArq("SPC",MEMP->M_codemp)+" PC, "+GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
		cQuery += GB860RetArq("SP9",MEMP->M_codemp)+" P9, "+GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
		cQuery += "WHERE PC.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' AND P9.D_E_L_E_T_ = '' "
		cQuery += "AND PC.PC_PD = P9.P9_CODIGO AND P9.P9_CODFOL = RV.RV_COD AND RA.RA_MAT = PC.PC_MAT AND PC.PC_CC = CT.CTT_CUSTO "
		cQuery += "AND RV.RV_TIPO IN ('H','V','D') AND RA.RA_FILIAL = PC.PC_FILIAL AND RV.RV_GDTIPO IN ('3','5','6') "
		cQuery += "AND PC.PC_FILIAL = '"+GB860RetFil("SPC",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND P9.P9_FILIAL = '"+GB860RetFil("SP9",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND CT.CTT_FILIAL= '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
		If !Empty(c860Categor)
			cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
		Endif
		cQuery += "AND PC_DATA BETWEEN '"+Substr(cPon2,1,6)+"' AND '"+dtos(dDatabase-1)+"' "
		For ni := 1 to Len(a860Filtro)-1
			cQuery += "AND "+a860Filtro[ni,5]+" = '"+a860Filtro[ni+1,3]+"' "
		Next ni
		cQuery += "GROUP BY RV_GDOPER,"+a860Filtro[nPosY,5]+" "
		cQuery += "ORDER BY "+a860Filtro[nPosY,5]+" "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !Eof()
			cQuebra := MAR->M_quebra
			If ((MAR->M_HRSFAL+MAR->M_HRSATR-MAR->M_HRSDES) != 0)
				nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
				If (nPosY == 0)
					aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
					nPosY := Len(aDadosY)
				Endif                  
				If (MAR->M_vgoper == "+")
					aDadosY[nPosY,4] += MAR->M_HRSFAL-MAR->M_HRSDES
					aDadosY[nPosY,5] += MAR->M_HRSATR
					aTotal[1] += MAR->M_HRSFAL-MAR->M_HRSDES
					aTotal[2] += MAR->M_HRSATR
				Elseif (MAR->M_vgoper == "-")
					aDadosY[nPosY,4] += MAR->M_HRSFAL-MAR->M_HRSDES
					aDadosY[nPosY,5] += MAR->M_HRSATR
					aTotal[1] += MAR->M_HRSFAL-MAR->M_HRSDES
					aTotal[2] += MAR->M_HRSATR
				Endif
			Endif
			dbSelectArea("MAR")
			dbSkip()
		Enddo
	
		//Monto query para buscar dados de Ponto/RH
		///////////////////////////////////////////
		nPosY  := Len(a860Filtro)
		cQuery := "SELECT RV_COD M_PD,RV_GDTIPO M_VGTIPO,RV_GDOPER M_VGOPER,"+a860Filtro[nPosY,5]+" M_QUEBRA,
		cQuery += "SUM((FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6))) M_HORAS "
		cQuery += "FROM "+GB860RetArq("SPC",MEMP->M_codemp)+" PC, "
		cQuery += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "+GB860RetArq("SP9",MEMP->M_codemp)+" P9, "
		cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
		cQuery += "WHERE PC.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND P9.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
		cQuery += "AND PC.PC_PD = P9.P9_CODIGO AND P9.P9_CODFOL = RV.RV_COD AND RA.RA_MAT = PC.PC_MAT AND PC.PC_CC = CT.CTT_CUSTO "
		cQuery += "AND PC.PC_FILIAL = '"+GB860RetFil("SPC",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND P9.P9_FILIAL = '"+GB860RetFil("SP9",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND RV.RV_TIPO IN ('H','V','D') AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND RA.RA_FILIAL = PC.PC_FILIAL AND RV.RV_GDTIPO IN ('1','2') "
		If !Empty(c860Categor)
			cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
		Endif
		cQuery += "AND PC_DATA BETWEEN '"+Substr(cPon2,1,6)+"' AND '"+dtos(dDatabase-1)+"' "
		For ni := 1 to Len(a860Filtro)-1
			cQuery += "AND "+a860Filtro[ni,5]+" = '"+a860Filtro[ni+1,3]+"' "
		Next ni
		cQuery += "GROUP BY RV_COD,RV_GDTIPO,RV_GDOPER,"+a860Filtro[nPosY,5]+" "
		cQuery += "ORDER BY "+a860Filtro[nPosY,5]+" "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !Eof()
			cQuebra := MAR->M_quebra
			nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
			If (nPosY == 0)
				aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0})
				nPosY := Len(aDadosY)
			Endif                      
			nHoras := MAR->M_horas
			If (MAR->M_PD $ "101") //Salario Mensalista/Saldo Salario
				nHoras := MAR->M_horas*7.33
			Endif
			If (MAR->M_PD != "700")
				If (MAR->M_vgoper == "+")
					aDadosY[nPosY,6] += nHoras
					aTotal[3] += nHoras
				Elseif (MAR->M_vgoper == "-")
					aDadosY[nPosY,6] += nHoras
					aTotal[3] += nHoras
				Endif
				aDadosY[nPosY,7] := ((aDadosY[nPosY,4]+aDadosY[nPosY,5])/Max(aDadosY[nPosY,6],1))*100
				aTotal[4] := ((aTotal[1]+aTotal[2])/Max(aTotal[3],1))*100
			Endif
			dbSelectArea("MAR")
			dbSkip()
		Enddo

	Endif
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Ponto/RH                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "DIA")
	aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
Else
	aDadosY := aSort(aDadosY,,,{|x,y| x[6]>y[6]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"B1_DESC"    ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "VER") //Visao por Verba
	aadd(aHeader,{"Verba"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",20,0,"","","C","",""})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(aHeader,{"Data"        ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Hrs Falta"   ,"M_HRSFAL" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Hrs Atraso"  ,"M_HRSATR" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Hrs Pagas"   ,"M_HRSPAG" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Absent."   ,"M_ABSENT" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI"  ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"   ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE" ,"@!",1,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*aTotal[3]
nClasseB := (n860BClasse/100)*aTotal[3]
nClasseC := (n860CClasse/100)*aTotal[3]
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
nPartY := 0 ; nPartAcmY := 0 ; cClasseY := ""
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,6]
	nPartY  := (nDadosY/Max(aTotal[3],1))*100
	nPartAcmY += nPartY
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += nDadosY
		cClasseY := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += nDadosY
		cClasseY := "B"
	Else
		nTotalC += nDadosY
		cClasseY := "C"
	Endif
	aDadosY[ni,4] := u_GDVDecHora(aDadosY[ni,4])
	aDadosY[ni,5] := u_GDVDecHora(aDadosY[ni,5])
	aDadosY[ni,6] := u_GDVDecHora(aDadosY[ni,6])
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "NIV") //Visao por Nivel
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,(cChaveY)->RA_cc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "VER") //Visao por Verba
		cChaveY := GB860RetAlias("SRV",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRV",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RV_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "DIA") //Visao por Dia
		aadd(aCols,{aDadosY[ni,1],GB860Semana(stod(aDadosY[ni,1])),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Endif
Next ni
If (aTotal[1] > 0).or.(aTotal[2] > 0).or.(aTotal[3] > 0).or.(aTotal[4] > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSFAL")
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[1])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSATR")
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[2])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSPAG")
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[3])
		Elseif (Alltrim(aHeader[ni,2]) == "M_ABSENT")
			aCols[nPosY,ni] := aTotal[4]
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPosY,ni] := 100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860EVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860EVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 370, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Abono"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Atraso" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Falta"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860EVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery7 := "SELECT RV_GDOPER M_VGOPER,RD_DATARQ M_EMISSAO,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '5' THEN RD_HORAS ELSE 0 END) M_HRSFAL,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '3' THEN RD_HORAS ELSE 0 END) M_HRSATR,"
	cQuery7 += "SUM(CASE WHEN RV_GDTIPO = '6' THEN RD_HORAS ELSE 0 END) M_HRSDES "
	cQuery7 += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "+GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery7 += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_TIPO IN ('H','V','D') AND RD.RD_MES <> '13' AND RA.RA_FILIAL = RD.RD_FILIAL AND RV.RV_GDTIPO IN ('3','5','6') "
	cQuery7 += "AND RD.RD_DATARQ BETWEEN '"+cPerIni7+"' AND '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY RV_GDOPER,RD_DATARQ "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()
		nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If ((MAR->M_HRSFAL-MAR->M_HRSDES) != 0)
			If (nPos7 == 0)
				aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0,0,0})
				nPos7 := Len(aVarPer)
			Endif
			If (MAR->M_vgoper == "+")
				aVarPer[nPos7,4] += MAR->M_HRSFAL+MAR->M_HRSATR-MAR->M_HRSDES
			Elseif (MAR->M_vgoper == "-") 
				aVarPer[nPos7,4] -= MAR->M_HRSFAL+MAR->M_HRSATR-MAR->M_HRSDES
			Endif
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo

	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery7 := "SELECT RD_DATARQ M_EMISSAO,RD_PD M_PD,RV_GDTIPO M_VGTIPO,RV_GDOPER M_VGOPER,SUM(RD_HORAS) M_HORAS "
	cQuery7 += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "
	cQuery7 += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery7 += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery7 += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RD.RD_MES <> '13' AND RV.RV_TIPO IN ('H','V','D') AND RA.RA_FILIAL = RD.RD_FILIAL "
	cQuery7 += "AND RV.RV_GDTIPO IN ('1','2') AND RD.RD_DATARQ BETWEEN '"+cPerIni7+"' AND '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY RD_DATARQ,RD_PD,RV_GDTIPO,RV_GDOPER "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()
		nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If (nPos7 == 0)
			aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0,0,0})
			nPos7 := Len(aVarPer)
		Endif
		nHoras := MAR->M_horas
		If (MAR->M_PD $ "101") //Salario Mensalista/Saldo Salario
			nHoras := MAR->M_horas*7.33
		Endif
		If (MAR->M_PD != "700")
			If (MAR->M_vgoper == "+")
				aVarPer[nPos7,5] += nHoras
			Elseif (MAR->M_vgoper == "-")
				aVarPer[nPos7,5] -= nHoras
			Endif
			aVarPer[nPos7,2] := (aVarPer[nPos7,4]/Max(aVarPer[nPos7,5],1))*100
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo

	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "% Absenteismo"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := aVarPer[ni,2]
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE INFORMACOES DA FOLHA /////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860DConGpe(xTipo,xCols,xAt)
****************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "GDView Gestao Pessoal - Drill-Down [Gestao Pessoal]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If Empty(cChaveX).or.(Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConGpe, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConGpe[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860DDrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,400)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ aPosObjX[1,1],aPosObjX[1,2] SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ aPosObjX[1,1],aPosObjX[1,2]+150 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ aPosObjX[1,1]+14,aPosObjX[1,2] TO aPosObjX[1,1]+15,(aPosObjX[1,4]-aPosObjX[1,2]) LABEL "" OF oDlgConX PIXEL
@ aPosObjX[2,1],010 SAY oClasseA VAR "CLASSE A: "+Alltrim(Transform(nClasseA,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ aPosObjX[2,1],100 SAY oClasseB VAR "CLASSE B: "+Alltrim(Transform(nClasseB,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ aPosObjX[2,1],190 SAY oClasseC VAR "CLASSE C: "+Alltrim(Transform(nClasseC,"@E 999,999,999.99"))+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),aPosObjX[2,4]-290,aPosObjX[2,1],40,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"    ,aPosObjX[2,4]-250,aPosObjX[2,1],40,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Pagas"  ,aPosObjX[2,4]-210,aPosObjX[2,1],40,,{||GB860DVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Extra"  ,aPosObjX[2,4]-170,aPosObjX[2,1],40,,{||GB860DVariac(2,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Vlr Nominal",aPosObjX[2,4]-130,aPosObjX[2,1],40,,{||GB860DVariac(3,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Vlr Pago"   ,aPosObjX[2,4]-090,aPosObjX[2,1],40,,{||GB860DVariac(4,oGetConX:aCols,oGetConX:oBrowse:nAt)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Vlr Extra"  ,aPosObjX[2,4]-050,aPosObjX[2,1],40,,{||GB860DVariac(5,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[3,1],aPosObjX[3,2],aPosObjX[3,3],aPosObjX[3,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConFun)
	If (a860ConGpe[ni,3])
		bBlockX := &("{||GB860DConGpe('"+a860ConGpe[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConGpe[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,aPosObjX[4,4]-130,aPosObjX[4,1],40,,{||GB860ExpExcel(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",aPosObjX[4,4]-090,aPosObjX[4,1],40,,{||GB860Imprime(@oGetConX:aHeader,@oGetConX:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,aPosObjX[4,4]-050,aPosObjX[4,1],40,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConGpe, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConGpe[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860DDrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL ni, nPosY, nTotal := 0
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY
LOCAL lImp, cPeriY, cChaveY, aDadosY := {}
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"   , xValor, "SRA" , "RA.RA_FILIAL"})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"  , xValor, "CTT" , "CT.CTT_HIERAR"})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"RD.RD_CC"       , xValor, "SRD" , "PC.PC_CC"})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"  , xValor, "SRA" , "RA.RA_CODFUNC"})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"  , xValor, "SRA" , "RA.RA_CATFUNC"})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"RD.RD_MAT"      , xValor, "SRD" , "PC.PC_MAT"})
Elseif (xTipo == "VER") //Visao por Tipo de Verba
	aadd(a860Filtro,{"TIPO VERBA"  ,"RD.RD_PD"       , xValor, "SRD" , "RD.RD_PD"})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"  , xValor, "SRA" , "RA.RA_TNOTRAB"})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"     , xValor, "SRA" , "RA.RA_SEXO"})
Elseif (xTipo == "DIA") //Visao por Sexo
	aadd(a860Filtro,{"DIA"         ,"RD.RD_DATARQ"   , xValor, "SRD" , "PC.PC_DATA"})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

aTotal := {0,0,0,0,0}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT RD_PD M_PD,RV_GDTIPO M_VGTIPO,RV_GDOPER M_VGOPER,"+a860Filtro[nPosY,2]+" M_QUEBRA,SUM(RD_HORAS) M_HORAS,SUM(RD_VALOR) M_VALOR "
	cQuery += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "
	cQuery += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RD.RD_MES <> '13' AND RV.RV_TIPO IN ('H','V','D') AND RV.RV_GDTIPO IN ('1','2') "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND RD_DATARQ BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND RD_DATARQ BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY RD_PD,RV_GDTIPO,RV_GDOPER,"+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		cQuebra := MAR->M_quebra
		If (xTipo == "DIA")
			cQuebra := Alltrim(MAR->M_quebra)+"01"
		Endif
		nPosY := aScan(aDadosY, {|x| x[1] == cQuebra })
		If (nPosY == 0)
			aadd(aDadosY,{cQuebra,MEMP->M_codemp,MEMP->M_codfil,0,0,0,0,0})
			nPosY := Len(aDadosY)
		Endif
		nHoras := MAR->M_horas
		nValor := MAR->M_valor
		If (MAR->M_PD $ "101") //Salario Mensalista/Saldo Salario
			nHoras := MAR->M_horas*7.33
		Endif
		If (MAR->M_PD != "700")
			If (MAR->M_vgoper == "+")
				aDadosY[nPosY,4] += nHoras
				aTotal[1] += nHoras
				aDadosY[nPosY,6] += nValor
				aTotal[3] += nValor
			Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,4] -= nHoras
				aTotal[1] -= nHoras
				aDadosY[nPosY,6] -= nValor
				aTotal[3] -= nValor
			Endif
		Endif
		If (MAR->M_vgtipo == "2") //Hora Extra
			If (MAR->M_vgoper == "+")
				aDadosY[nPosY,5] += nHoras
				aTotal[2] += nHoras
				aDadosY[nPosY,7] += nValor
				aTotal[4] += nValor
			Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,5] -= nHoras
				aTotal[2] -= nHoras
				aDadosY[nPosY,7] -= nValor
				aTotal[4] -= nValor
			Endif
		Elseif (MAR->M_PD $ "700")
			If (MAR->M_vgoper == "+")
				aDadosY[nPosY,8] += nValor
				aTotal[5] += nValor
			Elseif (MAR->M_vgoper == "-")
				aDadosY[nPosY,8] -= nValor
				aTotal[5] -= nValor
			Endif
		Endif
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Ponto/RH                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "DIA")
	aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
Elseif (n860GpeOrd == 1)
	aDadosY := aSort(aDadosY,,,{|x,y| x[4]>y[4]})
Elseif (n860GpeOrd == 2)
	aDadosY := aSort(aDadosY,,,{|x,y| x[5]>y[5]})
Elseif (n860GpeOrd == 3)
	aDadosY := aSort(aDadosY,,,{|x,y| x[8]>y[8]})
Elseif (n860GpeOrd == 4)
	aDadosY := aSort(aDadosY,,,{|x,y| x[6]>y[6]})
Elseif (n860GpeOrd == 5)
	aDadosY := aSort(aDadosY,,,{|x,y| x[7]>y[7]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"B1_DESC"    ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "VER") //Visao por Tipo de Verba
	aadd(aHeader,{"Verba"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",20,0,"","","C","",""})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(aHeader,{"Data"        ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Hrs Pagas"   ,"M_HRSPAG" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Hrs Extra"   ,"M_HRSEXT" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Vlr Nominal" ,"M_VALNOM" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Vlr Pago"    ,"M_VALPAG" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"Vlr HrExtra" ,"M_VALEXT" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI"  ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"   ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE" ,"@!",1,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*aTotal[3]
nClasseB := (n860BClasse/100)*aTotal[3]
nClasseC := (n860CClasse/100)*aTotal[3]
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
nPartY := 0 ; nPartAcmY := 0 ; cClasseY := ""
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,6]
	nPartY  := (nDadosY/Max(aTotal[3],1))*100
	nPartAcmY += nPartY
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += nDadosY
		cClasseY := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += nDadosY
		cClasseY := "B"
	Else
		nTotalC += nDadosY
		cClasseY := "C"
	Endif
	aDadosY[ni,4] := u_GDVDecHora(aDadosY[ni,4])
	aDadosY[ni,5] := u_GDVDecHora(aDadosY[ni,5])
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "NIV") //Visao por Nivel
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,(cChaveY)->RA_cc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "VER") //Visao por Verba
		cChaveY := GB860RetAlias("SRV",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRV",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RV_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "DIA") //Visao por Dia
		aadd(aCols,{aDadosY[ni,1],GB860Semana(stod(aDadosY[ni,1])),aDadosY[ni,4],aDadosY[ni,5],aDadosY[ni,8],aDadosY[ni,6],aDadosY[ni,7],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Endif
Next ni
If (aTotal[1] > 0).or.(aTotal[2] > 0).or.(aTotal[3] > 0).or.(aTotal[4] > 0).or.(aTotal[5] > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSPAG") 
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[1])
		Elseif (Alltrim(aHeader[ni,2]) == "M_HRSEXT") 
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[2])
		Elseif (Alltrim(aHeader[ni,2]) == "M_VALPAG") 
			aCols[nPosY,ni] := aTotal[3]
		Elseif (Alltrim(aHeader[ni,2]) == "M_VALEXT") 
			aCols[nPosY,ni] := aTotal[4]
		Elseif (Alltrim(aHeader[ni,2]) == "M_VALNOM") 
			aCols[nPosY,ni] := aTotal[5]
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPosY,ni] := 100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860DVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860DVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 370, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Pagas"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Extras" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ (aSizeGrfZ[4]-5), 250 SAY "Vlr Nominal"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 4)
	@ (aSizeGrfZ[4]-5), 250 SAY "Vlr Pago"     OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 5)
	@ (aSizeGrfZ[4]-5), 250 SAY "Vlr HrExtra"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860DVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery7 := "SELECT RD.RD_DATARQ M_EMISSAO,RD.RD_PD M_PD,RV.RV_GDTIPO M_VGTIPO,"
	cQuery7 += "RV.RV_GDOPER M_VGOPER,SUM(RD_HORAS) M_HORAS,SUM(RD_VALOR) M_VALOR "
	cQuery7 += "FROM "+GB860RetArq("SRD",MEMP->M_codemp)+" RD, "
	cQuery7 += GB860RetArq("SRV",MEMP->M_codemp)+" RV, "
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "
	cQuery7 += GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE RD.D_E_L_E_T_ = '' AND RV.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND RD.RD_PD = RV.RV_COD AND RA.RA_MAT = RD.RD_MAT AND RD.RD_CC = CT.CTT_CUSTO "
	cQuery7 += "AND RD.RD_FILIAL = '"+GB860RetFil("SRD",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RV.RV_FILIAL = '"+GB860RetFil("SRV",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL = '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RD.RD_MES <> '13' AND RV.RV_TIPO IN ('H','V','D') AND RV.RV_GDTIPO IN ('1','2') "
	cQuery7 += "AND RD.RD_DATARQ BETWEEN '"+cPerIni7+"' AND '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY RD.RD_DATARQ,RD.RD_PD,RV.RV_GDTIPO,RV.RV_GDOPER "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !Eof()
		nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If (nPos7 == 0)
			aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0})
			nPos7 := Len(aVarPer)
		Endif
		nHoras := MAR->M_horas
		nValor := MAR->M_valor
		If (MAR->M_PD $ "101") //Salario Mensalista
			nHoras := MAR->M_horas*7.33
		Endif
		If (xTipo == 1) //Horas Pagas
			If (MAR->M_vgoper == "+")
				aVarPer[nPos7,2] += nHoras
				aTotal7[1] += nHoras
			Elseif (MAR->M_vgoper == "-")
				aVarPer[nPos7,2] -= nHoras
				aTotal7[1] -= nHoras
			Endif
		Elseif (xTipo == 2) //Horas Extra
			If (MAR->M_vgtipo == "2")
				If (MAR->M_vgoper == "+")
					aVarPer[nPos7,2] += nHoras
					aTotal7[1] += nHoras
				Elseif (MAR->M_vgoper == "-")
					aVarPer[nPos7,2] -= nHoras
					aTotal7[1] -= nHoras
				Endif
			Endif
		Elseif (xTipo == 3) //Valor Nominal
			If (MAR->M_PD $ "700")
				If (MAR->M_vgoper == "+")
					aVarPer[nPos7,2] += nValor
					aTotal7[1] += nValor
				Elseif (MAR->M_vgoper == "-")
					aVarPer[nPos7,2] -= nValor
					aTotal7[1] -= nValor
				Endif
			Endif
		Elseif (xTipo == 4) //Valor Pago
			If !(MAR->M_PD $ "700")
				If (MAR->M_vgoper == "+")
					aVarPer[nPos7,2] += nValor
					aTotal7[1] += nValor
				Elseif (MAR->M_vgoper == "-")
					aVarPer[nPos7,2] -= nValor
					aTotal7[1] -= nValor
				Endif				
			Endif
		Elseif (xTipo == 5) //Valor HrExtra
			If (MAR->M_vgtipo == "2")
				If (MAR->M_vgoper == "+")
					aVarPer[nPos7,2] += nValor
					aTotal7[1] += nValor
				Elseif (MAR->M_vgoper == "-")
					aVarPer[nPos7,2] -= nValor
					aTotal7[1] -= nValor
				Endif
			Endif
		Endif
		dbSelectArea("MAR")
		dbSkip()
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "Horas Pagas"
Elseif (xTipo == 2)
	aCols[1,1] := "Horas Extra"
Elseif (xTipo == 3)
	aCols[1,1] := "Vlr Nominal"
Elseif (xTipo == 4)
	aCols[1,1] := "Vlr Pago"
Elseif (xTipo == 5)
	aCols[1,1] := "Vlr HrExtra"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := aVarPer[ni,2]
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860ExpExcel(xHeader,xCols,xClasseA,xClasseB,xClasseC)
**************************************************************
LOCAL cDirDocs := MsDocPath() 
LOCAL aStru		:= aClone(xHeader)
LOCAL cArquivo := CriaTrab(,.F.)
LOCAL cPath		:= AllTrim(GetTempPath())
LOCAL cCrLf 	:= Chr(13) + Chr(10)
LOCAL oExcelApp, nHandle, nX, nY
ProcRegua(Len(xCols)+2)
nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".csv",0)
If (nHandle > 0)
	// Grava o cabecalho do arquivo
	IncProc("Aguarde! Gerando arquivo de integracao com Excel...")
	fWrite(nHandle,cCrLf) // Pula linha
	fWrite(nHandle,Upper(cCadastro)) // Titulo
	fWrite(nHandle,cCrLf+cCrLf) // Pula duas linhas
	fWrite(nHandle,":: PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2)+Space(10)+c860Filtro) // Titulo
	fWrite(nHandle,cCrLf+cCrLf) // Pula duas linhas
	If (xClasseA!=Nil).and.(xClasseB!=Nil).and.(xClasseC!=Nil)
		fWrite(nHandle,xClasseA+Space(8)+xClasseB+Space(8)+xClasseC)
		fWrite(nHandle,cCrLf+cCrLf) // Pula duas linhas
	Endif
	aEval(aStru,{|e,nX| fWrite(nHandle,e[1]+If(nX<Len(aStru),";",""))})
	fWrite(nHandle,cCrLf) // Pula linha
	For nX := 1 to Len(xCols)
		IncProc("Aguarde! Gerando arquivo de integracao com Excel...")
		For nY := 1 to Len(xHeader)
			fWrite(nHandle,Alltrim(Transform(xCols[nX,nY],xHeader[nY,3]))+";")
		Next nY
		fWrite(nHandle,cCrLf) // Pula linha
	Next nX
	IncProc("Aguarde! Abrindo o arquivo...")
	fClose(nHandle)
	CpyS2T(cDirDocs+"\"+cArquivo+".csv",cPath,.T.)
	If ! ApOleClient("MsExcel")
		MsgAlert("MsExcel nao instalado!")
		Return
	EndIf
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath+cArquivo+".csv") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()
Else
	MsgAlert("Falha na criacao do arquivo!")
Endif	
Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
// CONSULTA DE TREINAMENTOS /////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860FConTre(xTipo,xCols,xAt)
***************************************
LOCAL oDlgConX, oBoldX, oGetConX, oMSGraphicX, aInfoX, aPosObjX, aSizeGrfX
LOCAL cChaveX  := "", nColX := 0, nPosX := 0, nMesX, aObjectsX, bBlockX, oMenuX
LOCAL cTituloX := "Visao Gerencial Treinamentos - Drill-Down [Treinamentos]"
LOCAL oClasseA, oClasseB, oClasseC, nClasseA := 0, nClasseB := 0, nClasseC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldX NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveX := xCols[xAt,1]
Endif
If (Left(cChaveX,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConTre, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConTre[nPosX,3] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860FDrillDown(@aHeader,@aCols,xTipo,cChaveX,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenuX POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenuX:aItems)
	oMenuX:aItems[nx]:bAction := &("{|OMENUITEM|GB860Ordena("+Alltrim(Str(nx))+",oGetConX)}")
Next nx

//Monto Grafico
///////////////
aObjectsX := {}
aSizeGrfX := MsAdvSize(,.F.,430)
AAdd(aObjectsX,{  0,  20, .T., .F. })
AAdd(aObjectsX,{  0,  15, .T., .F. })
AAdd(aObjectsX,{  0, 200, .T., .T. })
AAdd(aObjectsX,{  0,  25, .T., .F. })
aInfoX   := {aSizeGrfX[1],aSizeGrfX[2],aSizeGrfX[3],aSizeGrfX[4],3,3}
aPosObjX := MsObjSize(aInfoX,aObjectsX)
DEFINE MSDIALOG oDlgConX FROM aSizeGrfX[7],0 TO aSizeGrfX[6],aSizeGrfX[5] TITLE cTituloX PIXEL
@ 010,010 SAY o860Ano VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldX
@ 010,110 SAY o860Filtro VAR c860Filtro OF oDlgConX PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldX
@ 019,aPosObjX[2,2] TO 020,(aPosObjX[2,4]-aPosObjX[2,2]) LABEL "" OF oDlgConX PIXEL
@ 021,010 SAY oClasseA VAR "CLASSE A: "+Transform(nClasseA,"@E 999,999,999.99")+" ["+Alltrim(Str(n860AClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 028,010 SAY oClasseB VAR "CLASSE B: "+Transform(nClasseB,"@E 999,999,999.99")+" ["+Alltrim(Str(n860BClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
@ 035,010 SAY oClasseC VAR "CLASSE C: "+Transform(nClasseC,"@E 999,999,999.99")+" ["+Alltrim(Str(n860CClasse))+"%]" OF oDlgConX PIXEL SIZE 245,9 COLOR CLR_BLUE
oVarCre  := u_GDVButton(oDlgConX,"oVarCre",iif(l860OrdCres,"Crescente","Decrescen"),(oDlgConX:nClientWidth-200),aPosObjX[2,1]+15,,,{||(l860OrdCres:=!l860OrdCres),(oVarCre:cCaption:=iif(l860OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
oVarOrd  := u_GDVButton(oDlgConX,"oVarOrd","Ordenar"    ,(oDlgConX:nClientWidth-140),aPosObjX[2,1]+15,,,{||oMenuX:Activate((oDlgConX:nClientWidth-210),(aPosObjX[2,1]+35),oDlgConX)})
oVarParX := u_GDVButton(oDlgConX,"oVarPar","Hrs Trein" ,(oDlgConX:nClientWidth-080),aPosObjX[2,1]+15,,,{||GB860FVariac(1,oGetConX:aCols,oGetConX:oBrowse:nAt)})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetConX := MsNewGetDados():New(aPosObjX[2,1]+5,aPosObjX[2,2],aPosObjX[2,3],aPosObjX[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgConX,aHeader,aCols)
oGetConX:oBrowse:bLDblClick := { || GB860Coluna(oGetConX,oGetConX:oBrowse:nColPos) }
oGetConX:oBrowse:lUseDefaultColors := .F.
oGetConX:oBrowse:SetBlkBackColor({||GB860CorCla(oGetConX:aHeader,oGetConX:aCols,oGetConX:nAt)})

nLinX := aPosObjX[4,1] ; nColX := 10
For ni := 1 to Len(a860ConTre)
	If (a860ConTre[ni,3])
		bBlockX := &("{||GB860FConTre('"+a860ConTre[ni,1]+"',oGetConX:aCols,oGetConX:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgConX,"oButCon"+Alltrim(Str(ni,1)),a860ConTre[ni,2],nColX,nLinX,40,,bBlockX)
		nColX += 40
		If (nColX > ((aSizeAut[5]/3)-50))
			nColX := 10
			nLinX += 20	
		Endif
	Endif
Next ni
oExceX  := u_GDVButton(oDlgConX,"oButExc","Excel"   ,(oDlgConX:nClientWidth-200),(oDlgConX:nClientHeight-60),,,{||GB860ExpExcel(oGetConX:aHeader,oGetConX:aCols,oClasseA:cCaption,oClasseB:cCaption,oClasseC:cCaption)})
oImprX  := u_GDVButton(oDlgConX,"oButImp","Imprimir",(oDlgConX:nClientWidth-140),(oDlgConX:nClientHeight-60),,,{||GB860Imprime(oGetConX:aHeader,oGetConX:aCols,oClasseA:cCaption,oClasseB:cCaption,oClasseC:cCaption)})
oFechX  := u_GDVButton(oDlgConX,"oButFec","Fechar"  ,(oDlgConX:nClientWidth-080),(oDlgConX:nClientHeight-60),,,{||oDlgConX:End()})

ACTIVATE MSDIALOG oDlgConX CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := aScan(a860ConTre, {|x| x[1] == xTipo })
If (nPosX > 0)
	a860ConTre[nPosX,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosX := Len(a860Filtro)
aDel(a860Filtro,nPosX)
aSize(a860Filtro,Len(a860Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
nMesX := 13
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	nMesX := oGetPon:oBrowse:nAt
	If (nMesX > 0).and.(nMesX <= 13)
		c860Filtro := iif(nMesX==13,"MES [TODOS] > ","MES ["+Upper(oGetPon:aCols[nMesX,1])+"] > ")
	Endif
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

Return

Static Function GB860FDrillDown(aHeader,aCols,xTipo,xValor,nClasseA,nClasseB,nClasseC)
*****************************************************************************
LOCAL ni, nPosY, nTotal := 0, lImp, cPeriY, cChaveY, aDadosY := {}
LOCAL nDadosY := 0, nRealY := 0, nPartY := 0, nPartAcmY := 0, cClasseY
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "FIL") //Visao por Filial
	aadd(a860Filtro,{"FILIAL"      ,"RA.RA_FILIAL"    , xValor, "SRA" })
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(a860Filtro,{"NIVEL"       ,"CT.CTT_HIERAR"   , xValor, "CTT" })
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(a860Filtro,{"C.CUSTO"     ,"RA.RA_CC"        , xValor, "SRA" })
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(a860Filtro,{"FUNCAO"      ,"RA.RA_CODFUNC"   , xValor, "SRA" })
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(a860Filtro,{"CATEGORIA"   ,"RA.RA_CATFUNC"   , xValor, "SRA" })
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(a860Filtro,{"FUNCIONARIO" ,"RA4.RA4_MAT"     , xValor, "RA4" })
Elseif (xTipo == "INS") //Visao por Instrutor
	aadd(a860Filtro,{"INSTRUTOR"   ,"RA4.RA4_INSTRU"  , xValor, "RA4" })
Elseif (xTipo == "ENT") //Visao por Entidade
	aadd(a860Filtro,{"ENTIDADE"    ,"RA4.RA4_ENTIDA"  , xValor, "RA4" })
Elseif (xTipo == "CUR") //Visao por Curso
	aadd(a860Filtro,{"CURSO"       ,"RA4.RA4_CURSO"   , xValor, "RA4" })
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(a860Filtro,{"TURNO"       ,"RA.RA_TNOTRAB"   , xValor, "SRA" })
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(a860Filtro,{"SEXO"        ,"RA.RA_SEXO"      , xValor, "SRA" })
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(a860Filtro,{"DIA"         ,"RA4.RA4_DATAFI"  , xValor, "RA4" })
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c860Filtro := ""
cPeriY := "TODOS"
If (oGetPon != Nil).and.(Len(oGetPon:aCols) > 0)
	cPeriY := oGetPon:aCols[oGetPon:oBrowse:nAt,1]
	c860Filtro := iif(Left(cPeriY,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeriY+"] > ")
Endif
If (Len(a860Filtro) == 1)
	c860Filtro += a860Filtro[1,1]
Else
	For ni := 1 to Len(a860Filtro)
		If (ni == Len(a860Filtro))
			c860Filtro += a860Filtro[ni,1]
		Else
			c860Filtro += a860Filtro[ni,1]+" ["+Alltrim(a860Filtro[ni+1,3])+"] > "
		Endif
	Next ni
Endif

aTotal := {0,0}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Drill-Down...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif

	//Monto resumo dados Treinamentos Realizado
	///////////////////////////////////////////
	nPosY  := Len(a860Filtro)
	cQuery := "SELECT "+a860Filtro[nPosY,2]+" M_QUEBRA,"
	cQuery += "COUNT(RA4_MAT) M_CONTA,SUM(RA4_HORAS) M_HORAS "
	cQuery += "FROM "+GB860RetArq("RA4",MEMP->M_codemp)+" RA4,"
	cQuery += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery += "WHERE RA4.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery += "AND RA.RA_MAT = RA4.RA4_MAT AND RA.RA_CC = CT.CTT_CUSTO "
	cQuery += "AND RA4.RA4_FILIAL = '"+GB860RetFil("RA4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND CT.CTT_FILIAL= '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	If !Empty(c860Categor)
		cQuery += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	If (Left(cPeriY,5) != "TOTAL")
		cQuery += "AND RA4_DATAFI BETWEEN '"+Left(cPeriY,6)+"' AND '"+Left(cPeriY,6)+"ZZ' "
	Else
		cQuery += "AND RA4_DATAFI BETWEEN '"+c860Peri1+"' AND '"+c860Peri2+"ZZ' "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery += "GROUP BY "+a860Filtro[nPosY,2]+" "
	cQuery += "ORDER BY "+a860Filtro[nPosY,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		nPosY := aScan(aDadosY, {|x| x[1] == MAR->M_quebra })
		If (nPosY == 0)
			aadd(aDadosY,{MAR->M_quebra,MEMP->M_codemp,MEMP->M_codfil,0,0})
			nPosY := Len(aDadosY)
		Endif                      
		aDadosY[nPosY,4] += MAR->M_CONTA
		aDadosY[nPosY,5] += MAR->M_HORAS
		aTotal[1] += MAR->M_CONTA
		aTotal[2] += MAR->M_HORAS
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Horas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "DIA")
	aDadosY := aSort(aDadosY,,,{|x,y| x[1]<y[1]})
Else
	aDadosY := aSort(aDadosY,,,{|x,y| x[5]>y[5]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"RA_FILIAL"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"RA_NOME"    ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "NIV") //Visao por Nivel
	aadd(aHeader,{"Nivel"       ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "CUS") //Visao por Centro Custo
	aadd(aHeader,{"C.Custo"     ,"B1_DESC"    ,"@!",09,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "FNC") //Visao por Funcao
	aadd(aHeader,{"Funcao"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CAT") //Visao por Categoria
	aadd(aHeader,{"Categoria"   ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FUN") //Visao por Funcionario
	aadd(aHeader,{"Matricula"   ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Centro Custo","B1_CC"      ,"@!",09,0,"","","C","",""})
Elseif (xTipo == "INS") //Visao por Instrutor
	aadd(aHeader,{"Codigo"      ,"B1_DESC"    ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "ENT") //Visao por Entidade
	aadd(aHeader,{"Entidade"    ,"B1_DESC"    ,"@!",04,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CUR") //Visao por Curso
	aadd(aHeader,{"Entidade"    ,"B1_DESC"    ,"@!",04,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TUR") //Visao por Turno
	aadd(aHeader,{"Turno"       ,"B1_DESC"    ,"@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEX") //Visao por Sexo
	aadd(aHeader,{"Sexo"        ,"B1_DESC"    ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",20,0,"","","C","",""})
Elseif (xTipo == "DIA") //Visao por Dia
	aadd(aHeader,{"Data"        ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Endif
aadd(aHeader,{"Trein Real"  ,"M_CONREA" ,"@E 999999",06,0,"","","N","",""})
aadd(aHeader,{"Horas Real"  ,"M_HORREA" ,"@E 999,999.99",11,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI"  ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"   ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE" ,"@!",1,0,"","","C","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nClasseA := (n860AClasse/100)*aTotal[2]
nClasseB := (n860BClasse/100)*aTotal[2]
nClasseC := (n860CClasse/100)*aTotal[2]
nTotalA  := nTotalB := nTotalC := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1
nPartY := 0 ; nPartAcmY := 0 ; cClasseY := ""
For ni := 1 to Len(aDadosY)
	nDadosY := aDadosY[ni,5]
	nPartY  := (nDadosY/Max(aTotal[2],1))*100
	nPartAcmY += nPartY
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += nDadosY
		cClasseY := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += nDadosY
		cClasseY := "B"
	Else
		nTotalC += nDadosY
		cClasseY := "C"
	Endif
	aDadosY[ni,5] := u_GDVDecHora(aDadosY[ni,5])
	If (xTipo == "FIL") //Visao por Filial
		nSM0 := SM0->(Recno())
		SM0->(dbSeek(cEmpAnt+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
		SM0->(dbGoto(nSM0))
	Elseif (xTipo == "NIV") //Visao por Nivel
		aadd(aCols,{aDadosY[ni,1],Tabela("ZH",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUS") //Visao por Centro de Custo
		cChaveY := GB860RetAlias("CTT",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("CTT",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->CTT_desc01,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FNC") //Visao por Funcao
		cChaveY := GB860RetAlias("SRJ",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SRJ",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RJ_desc,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CAT") //Visao por Categoria
		dbSelectArea("SX5")
		aadd(aCols,{aDadosY[ni,1],Tabela("28",aDadosY[ni,1],.F.),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "FUN") //Visao por Funcionario
		cChaveY := GB860RetAlias("SRA",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(13))
		(cChaveY)->(dbSeek(aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA_nome,(cChaveY)->RA_cc,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "INS") //Visao por Instrutor
		cChaveY := GB860RetAlias("RA7",aDadosY[ni,2])
		(cChaveY)->(dbSetOrder(1))
		(cChaveY)->(dbSeek(GB860RetFil("RA7",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],iif(!Empty(aDadosY[ni,1]),(cChaveY)->RA7_nome,""),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "ENT") //Visao por Entidade
		cChaveY := GB860RetAlias("RA0",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("RA0",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA0_desc,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "CUR") //Visao por Curso
		cChaveY := GB860RetAlias("RA1",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("RA1",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->RA1_desc,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "TUR") //Visao por Turno
		cChaveY := GB860RetAlias("SR6",aDadosY[ni,2])
		(cChaveY)->(dbSeek(GB860RetFil("SR6",aDadosY[ni,2],aDadosY[ni,3])+aDadosY[ni,1],.T.))
		aadd(aCols,{aDadosY[ni,1],(cChaveY)->R6_desc,aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "SEX") //Visao por Sexo
		aadd(aCols,{aDadosY[ni,1],iif(aDadosY[ni,1]=="M","MASCULINO","FEMININO"),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Elseif (xTipo == "DIA") //Visao por Dia
		aadd(aCols,{aDadosY[ni,1],GB860Semana(stod(aDadosY[ni,1])),aDadosY[ni,4],aDadosY[ni,5],nPartY,nPartAcmY,ni,cClasseY,.F.})
	Endif
Next ni
If (aTotal[1] > 0).or.(aTotal[2] > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPosY := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPosY,ni] := "TOTAL >>>"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_CONREA")  
			aCols[nPosY,ni] := aTotal[1]
		Elseif (Alltrim(aHeader[ni,2]) == "M_HORREA")  
			aCols[nPosY,ni] := u_GDVDecHora(aTotal[2])
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPosY,ni] := 100
		Elseif (aHeader[ni,8] == "C")
			aCols[nPosY,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPosY,ni] := 0
		Else
			aCols[nPosY,ni] := ""
		Endif
	Next ni
	aCols[nPosY,Len(aHeader)+1] := .F.
Endif

Return

Static Function GB860FVariac(xTipo,xCols,xAt)
****************************************
LOCAL oDlgVarZ, oGetVarZ, oBoldZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Variacao", aSizeGrfZ, aObjectsZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBoldZ NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChaveZ := xCols[xAt,1]
Endif
If (Len(cChaveZ) >= 5 .and. Left(cChaveZ,5) $ "TOTAL/OUTRO" .and. Len(a860Filtro) > 1)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB860FVarDet(@aHeader,@aCols,cChaveZ,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  20, .T., .F. })
AAdd(aObjectsZ,{  0,  40, .T., .F. })
AAdd(aObjectsZ,{  0, 370, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL
@ 010,010 SAY o860Ano7 VAR "PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2) OF oDlgVarZ PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBoldZ
@ 019,aPosObjZ[2,2] TO 020,(aPosObjZ[2,4]-aPosObjZ[2,2]) LABEL "" OF oDlgVarZ PIXEL
cVarPerZ := a860Filtro[Len(a860Filtro),1]+": "+cChaveZ
@ 010,110 SAY oVarPer VAR cVarPerZ OF oDlgVarZ PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBoldZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[2,1]-10,aPosObjZ[2,2],aPosObjZ[2,3],aPosObjZ[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[3,1],aPosObjZ[3,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3) OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0))
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[1,ni],oGetVarZ:aHeader[ni,1],GDV_DATREA)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[2,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA3)
Next ni
nSerieZ := oGrafZ:CreateSerie(1,,iif(xTipo==2,2,0),.T.)
For ni := 2 to Len(oGetVarZ:aHeader)
	oGrafZ:Add(nSerieZ,oGetVarZ:aCols[3,ni],oGetVarZ:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
If (xTipo == 1)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Abono"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Atraso" OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ (aSizeGrfZ[4]-5), 250 SAY "Horas Falta"  OF oDlgVarZ PIXEL COLOR GDV_DATREA SIZE 200,10 FONT oBold
Endif
@ (aSizeGrfZ[4]-5), 310 SAY "Media 3 Ult.Meses"  OF oDlgVarZ PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ (aSizeGrfZ[4]-5), 380 SAY "Media 12 Ult.Meses" OF oDlgVarZ PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860FVarDet(aHeader,aCols,xChave,xTipo)
*************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer, aTotal7 := {0,0,0,0}
LOCAL nLin7, nPos7, nValor7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Val(Substr(c860Peri1,1,4))-1,4)+Substr(c860Peri1,5,2)
cPerAux  := cPerIni7
While (cPerAux <= c860Peri2)
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !Eof()
	
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+">>> Montando Variacao...")
	
	If !IsMark("M_OK",c860Marca,lInverte)
		dbSelectArea("MEMP")
		dbSkip()
		Loop
	Endif
	
	//Monto query para buscar dados de Ponto/RH
	///////////////////////////////////////////
	cQuery7 := "SELECT RA4_DATAFI M_EMISSAO,"
	cQuery7 += "COUNT(RA4_MAT) M_CONTA,SUM(RA4_HORAS) M_HORAS,SUM(RA4_VALOR) M_VALOR "
	cQuery7 += "FROM "+GB860RetArq("RA4",MEMP->M_codemp)+" RA4,"
	cQuery7 += GB860RetArq("CTT",MEMP->M_codemp)+" CT, "+GB860RetArq("SRA",MEMP->M_codemp)+" RA "
	cQuery7 += "WHERE RA4.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
	cQuery7 += "AND RA.RA_MAT = RA4.RA4_MAT AND RA.RA_CC = CT.CTT_CUSTO "
	cQuery7 += "AND RA4.RA4_FILIAL = '"+GB860RetFil("RA4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND CT.CTT_FILIAL= '"+GB860RetFil("CTT",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RA.RA_FILIAL = '"+GB860RetFil("SRA",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND RA4.RA4_DATAFI BETWEEN '"+cPerIni7+"' AND '"+c860Peri2+"ZZ' "
	If !Empty(c860Categor)
		cQuery7 += "AND RA.RA_CATFUNC IN ("+c860Categor+") "
	Endif
	For ni := 1 to Len(a860Filtro)-1
		cQuery7 += "AND "+a860Filtro[ni,2]+" = '"+a860Filtro[ni+1,3]+"' "
	Next ni
	cQuery7 += "AND "+a860Filtro[Len(a860Filtro),2]+" = '"+xChave+"' "
	cQuery7 += "GROUP BY RA4_DATAFI "
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If (nPos7 == 0)
			aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0})
			nPos7 := Len(aVarPer)
		Endif
		aVarPer[nPos7,2] += MAR->M_HORAS
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo
	
	dbSelectArea("MEMP")
	dbSkip()
Enddo
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
aadd(aCols,Array(Len(aHeader)+1))
If (xTipo == 1)
	aCols[1,1] := "Hrs Treinam."
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := aVarPer[ni,2]
	aVarPer[ni,3] := nValor7
	nPos7 := aScan(a860PonAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,3]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif
Next ni
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB860Imprime(xHeader,xCols,xClasseA,xClasseB,xClasseC)
**************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3         := ""
LOCAL cPict          := ""
LOCAL titulo         := "GDView Gestao Pessoal"
LOCAL nLin           := 80
LOCAL Cabec1         := ""
LOCAL Cabec2         := ""
LOCAL imprime        := .T.
LOCAL aOrd           := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 220
PRIVATE tamanho      := "G"
PRIVATE nomeprog     := "GBRA860" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "GBRA860" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "ZMP"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se objeto esta criado                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(xCols) <= 0)
	MsgInfo(">>> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,@xHeader,@xCols,@xClasseA,@xClasseB,@xClasseC) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,xHeader,xCols,xClasseA,xClasseB,xClasseC)
************************************************************************************
LOCAL nPosH, nColH, cAuxH, nx, ny

Cabec1 := ":: PERIODO: "+Alltrim(c860Peri1)+" - "+Alltrim(c860Peri2)+Space(10)+c860Filtro
Cabec2 := ""
For ny := 1 to Len(xHeader)
	cAuxH  := Alltrim(xHeader[ny,1])
	nColH  := Max(xHeader[ny,4],Len(xHeader[ny,1]))+2
	Cabec2 += cAuxH+Space(nColH-Len(cAuxH))
Next ny

Setregua(Len(xCols))
For nx := 1 to Len(xCols)
	
	Incregua()
	
	If (lAbortPrint)
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If (nLin > 55)
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
		If (xClasseA != Nil).and.(xClasseB != Nil).and.(xClasseC != Nil)
			@nLin,000 PSAY xClasseA+Space(8)+xClasseB+Space(8)+xClasseC
			nLin+=2
		Endif
	Endif
	
	If (nx == Len(xCols))
		@nLin,000 PSAY __PrtThinLine()
		nLin++
	Endif
	
	nColH := 0
	For ny := 1 to Len(xHeader)
		If !Empty(xCols[nx,ny]).and.(xHeader[ny,8] == "C")
			@nLin,nColH PSAY Alltrim(Substr(xCols[nx,ny],1,xHeader[ny,4]))
		Elseif (xHeader[ny,8] == "N")
			@nLin,nColH PSAY Transform(xCols[nx,ny],xHeader[ny,3])
		Elseif (xHeader[ny,8] == "D")
			@nLin,nColH PSAY dtoc(xCols[nx,ny])
		Endif
		nColH += Max(xHeader[ny,4],Len(xHeader[ny,1]))+2
	Next ny
	nLin++
	
Next nx
If (nLin != 80)
	Roda(cbcont,cbtxt,tamanho)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (aReturn[5]==1)
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return

Static Function GB860Coluna(xObj,xCol,xLin,xTipo)
********************************************
LOCAL oCalcCol := Nil, nTotal := 0, nOpcy := 0, nY, nX, lFaz := .F.
LOCAL lProduto := .F., nContax := 0, nQuantx := 0, aSegx := GetArea()

//Monto tela para solicitar complemento
///////////////////////////////////////
If (xObj == Nil).or.(xCol <= 0)
	Return
Endif
DEFINE MSDIALOG oCalcCol TITLE "Calcula Coluna "+Alltrim(xObj:aHeader[xCol,2]) FROM 0,0 TO 123,195 PIXEL OF oDlgGer
xObj:oBrowse:nAt := 1 ; xObj:oBrowse:nRowPos := xObj:oBrowse:nAt
@ 008,010 BUTTON "Pesquisar" SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=0,u_GDVSeekCols(xObj,"Pesquisar...",@xObj:aHeader,@xObj:aCols,.F.),oCalcCol:End())
@ 020,010 BUTTON "Conta "+Alltrim(xObj:aHeader[xCol,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=1,oCalcCol:End())
@ 032,010 BUTTON "Soma "+Alltrim(xObj:aHeader[xCol,1])  SIZE 80,10 OF oCalcCol PIXEL WHEN (xObj:aHeader[xCol,8]=="N") ACTION (nOpcy:=2,oCalcCol:End())
@ 044,010 BUTTON "Media "+Alltrim(xObj:aHeader[xCol,1]) SIZE 80,10 OF oCalcCol PIXEL WHEN (xObj:aHeader[xCol,8]=="N") ACTION (nOpcy:=3,oCalcCol:End())
ACTIVATE MSDIALOG oCalcCol CENTER
If (nOpcy == 1)
	For nY := 1 to Len(xObj:aCols)
		If G100VerifCab(@xObj:aHeader,@xObj:aCols,nY)
			nContax++
		Endif
	Next nY
	MsgInfo("Conta: "+Alltrim(Str(nContax))+" linha(s).","ATENCAO")
Elseif (nOpcy == 2)
	For nY := 1 to Len(xObj:aCols)
		If G100VerifCab(@xObj:aHeader,@xObj:aCols,nY)
			nTotal += xObj:aCols[nY,xCol]
		Endif
	Next nY
	MsgInfo("Soma: "+Transform(nTotal,xObj:aHeader[xCol,3]),"ATENCAO")
Elseif (nOpcy == 3)
	For nY := 1 to Len(xObj:aCols)
		If G100VerifCab(@xObj:aHeader,@xObj:aCols,nY)
			nTotal += xObj:aCols[nY,xCol]
			nContax++
		Endif
	Next nY
	If (nTotal > 0).and.(nContax > 0)
		nTotal := nTotal/nContax
	Endif
	MsgInfo("Media: "+Transform(nTotal,xObj:aHeader[xCol,3]),"ATENCAO")
Endif

Return

Static Function GB860VerifCab(xHeader,xCols,xLin)
*******************************************
LOCAL lRetu := .T., nX
For nX := 1 to Len(xHeader)
	If (xHeader[nX,8] == "C").and.(xHeader[nX,4] >= 5).and.(Left(xCols[xLin,nX],5) $ "TOTAL/OUTRO")
		lRetu := .F.
		Exit
	Endif
Next nX
Return lRetu

Static Function GB860Semana(xData)
*****************************
LOCAL cRetu := ""
If (Dow(xData) == 1)
	cRetu := "DOMINGO"
Elseif (Dow(xData) == 2)
	cRetu := "SEGUNDA"
Elseif (Dow(xData) == 3)
	cRetu := "TERCA"
Elseif (Dow(xData) == 4)
	cRetu := "QUARTA"
Elseif (Dow(xData) == 5)
	cRetu := "QUINTA"
Elseif (Dow(xData) == 6)
	cRetu := "SEXTA"
Elseif (Dow(xData) == 7)
	cRetu := "SABADO"
Endif
Return cRetu

Static Function GB860CompGraf()
***************************
LOCAL oDlgVarZ, oGrafZ, aInfoZ, aPosObjZ, nSerieZ, cChaveZ, cVarPerZ, oMarkZ, aCamposZ, cMarcaZ
LOCAL cTituloZ := "GDView Gestao Pessoal - Compara Indicadores", cDescPer, aSizeGrfZ, aObjectsZ, ni, nPosZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Solicito quais indicadores devem ser mostrados               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMarcaZ := c860Marca
aCamposZ := {}
aadd(aCamposZ,{"M_OK"      ,""," "   })
aadd(aCamposZ,{"M_INDICA"  ,"","Indicador"  , "@!" })
aadd(aCamposZ,{"M_DESCRI"  ,"","Descricao"  , "@!" })
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO 320,300 TITLE cTituloZ PIXEL
MIND->(dbGotop())
oMarkZ := MsSelect():New("MIND","M_OK",,aCamposZ,@lInverte,@cMarcaZ,{005,005,140,147},,,oDlgVarZ)
oMarkZ:oBrowse:Refresh()
oConfirmz := u_GDVButton(oDlgVarZ,"oButCon","Confirmar",010,(oDlgVarZ:nClientHeight-60),,,{||oDlgVarZ:End()})
ACTIVATE MSDIALOG oDlgVarZ CENTER

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",20,0,"","","C","",""})
For ni := 1 to Len(a860PonAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a860PonAno[ni,GDV_IANOME],5,2))),1,3))+"/"+Substr(a860PonAno[ni,GDV_IANOME],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
dbSelectArea("MIND")
dbGotop()
While !Eof()
	If IsMark("M_OK",cMarcaZ,lInverte)
		aadd(aCols,Array(Len(aHeader)+1))
		nPosZ := Len(aCols)
		aCols[nPosZ,1] := MIND->M_indica+" - "+MIND->M_descri
		For ni := 1 to Len(oGetPon:aCols)
			aCols[nPosZ,ni+1] := oGetPon:aCols[ni,Val(MIND->M_indica)]
		Next ni
		aCols[nPosZ,Len(aHeader)+1] := .F.
	Endif
	dbSelectArea("MIND")
	dbSkip()
Enddo
If (Len(aCols) == 0)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto grafico para comparativos                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aObjectsZ := {}
aSizeGrfZ := MsAdvSize(,.F.,430)
AAdd(aObjectsZ,{  0,  35, .T., .F. })
AAdd(aObjectsZ,{  0, 395, .T., .T. })
aInfoZ   := {aSizeGrfZ[1],aSizeGrfZ[2],aSizeGrfZ[3],aSizeGrfZ[4],3,3}
aPosObjZ := MsObjSize(aInfoZ,aObjectsZ)
DEFINE MSDIALOG oDlgVarZ FROM 0,0 TO aSizeGrfZ[6],aSizeGrfZ[5] TITLE cTituloZ PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVarZ := MsNewGetDados():New(aPosObjZ[1,1]-10,aPosObjZ[1,2],aPosObjZ[1,3],aPosObjZ[1,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVarZ,aHeader,aCols)
oGetVarZ:oBrowse:bLDblClick := { || GB860Coluna(oGetVarZ,oGetVarZ:oBrowse:nColPos) }
oGetVarZ:oBrowse:lUseDefaultColors := .F.
oGetVarZ:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObjZ[2,1],aPosObjZ[2,2] MSGRAPHIC oGrafZ SIZE ((oDlgVarZ:nClientWidth/2)-10),(oDlgVarZ:nClientHeight/3)+30 OF oDlgVarZ
oGrafZ:SetMargins(2,2,2,2)
oGrafZ:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGrafZ:cCaption := cCadastro
oGrafZ:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGrafZ:SetTitle("",Alltrim(oGetVarZ:aCols[1,1]),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
For nPosZ := 1 to Len(oGetVarZ:aCols)
	nSerieZ := oGrafZ:CreateSerie(1,,iif(Left(oGetVarZ:aCols[nPosZ,1],2)$"04/10",2,0))
	For ni := 2 to Len(oGetVarZ:aHeader)
		oGrafZ:Add(nSerieZ,oGetVarZ:aCols[nPosZ,ni],oGetVarZ:aHeader[ni,1],GB860Cores(Val(Left(oGetVarZ:aCols[nPosZ,1],2))))
	Next ni
Next nPosZ
oGrafZ:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGrafZ:lShowHint := .T.
oGrafZ:l3D := .T.
oGrafZ:Refresh()
@ (aSizeGrfZ[4]-5), 008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION oDlgVarZ:End()
@ (aSizeGrfZ[4]-5), 048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION PmsGrafMail(oGrafZ,"GDView Gestao Pessoal",{"GDView Gestao Pessoal",cTituloZ},{},1) // E-Mail
@ (aSizeGrfZ[4]-5), 078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVarZ PIXEL ACTION GrafSavBmp(oGrafZ)
@ (aSizeGrfZ[4]-5), 108 BUTTON "&3D"            SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:l3D := !oGrafZ:l3D
@ (aSizeGrfZ[4]-5), 138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVarZ PIXEL ACTION oGrafZ:lAxisVisib := !oGrafZ:lAxisVisib
@ (aSizeGrfZ[4]-5), 168 BUTTON "+"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomIn()
@ (aSizeGrfZ[4]-5), 183 BUTTON "-"              SIZE 15,10 OF oDlgVarZ PIXEL ACTION oGrafZ:ZoomOut()
nLin := (oDlgVarZ:nClientHeight-75) ; nCol := (aSizeGrfZ[4]*2)-10
For nPosZ := 1 to Len(oGetVarZ:aCols)
	oSayCom := u_GDVSay(oDlgVarZ,"oSayCom"+Strzero(nPosZ,2),oGetVarZ:aCols[nPosZ,1],nCol,nLin,150,,GB860Cores(Val(Left(oGetVarZ:aCols[nPosZ,1],2))))
	nLin += 15
	If (nLin > (oDlgVarZ:nClientHeight-45))
		nLin := (oDlgVarZ:nClientHeight-75)
		nCol += 150
	Endif
Next nPosZ
ACTIVATE MSDIALOG oDlgVarZ CENTER

Return

Static Function GB860Ordena(xOpcx,xGetCon)
*************************************
LOCAL aCols1, aCols2, nAux
nAux := Len(xGetCon:aCols)
aCols1 := aClone(xGetCon:aCols[nAux])
aCols2 := aClone(xGetCon:aCols)
aDel(aCols2,nAux)
aSize(aCols2,nAux-1)
If (l860OrdCres)
	aSort(aCols2,,,{|x,y| x[xOpcx]<y[xOpcx]})
Else
	aSort(aCols2,,,{|x,y| x[xOpcx]>y[xOpcx]})
Endif
aadd(aCols2,aCols1)
xGetCon:aCols := aClone(aCols2)
xGetCon:oBrowse:Refresh()
Return

Static Function GB860CorCla(xHeader,xCols,xAt)
*****************************************
LOCAL nRetu := RGB(250,250,250)
LOCAL	nPCla := GDFieldPos("M_CLASSE",xHeader)
If (nPCla > 0)
	If (xCols[xAt,nPCla] == "A")
		nRetu := RGB(240,250,220) //Verde
	Elseif (xCols[xAt,nPCla] == "B")
		nRetu := RGB(230,240,250) //Azul
	Endif
Endif
Return nRetu