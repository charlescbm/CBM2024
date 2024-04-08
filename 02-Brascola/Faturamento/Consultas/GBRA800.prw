#include "rwmake.ch"
#include "topconn.ch"
#include "folder.ch"        
#include "font.ch"
#include "colors.ch"
#include "msgraphi.ch"
#include "protheus.ch"
#include "goldenview.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GBRA800  ºAutor  ³ Marcelo da Cunha   º Data ³  01/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ GDView Faturamento                                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GBRA800(xExterno)
***************************
PRIVATE oDlgGer, oMark, oGetFat, oScroll, oGraf1, oBold, oFiltro
PRIVATE cCadastro := "GDView Faturamento", a800Consul := {}
PRIVATE a800Tabs  := {"SA1","SA3","SA4","SB1","SBM","SC4","SC5","SC6","SD1","SE4","SF1","SD2","SF2","SF4","SCT","SYA","ACY","ACA"}
PRIVATE d800Peri1 := ctod("//"), d800Peri2 := ctod("//"), c800ArqEmp := "", c800Marca, bBlock
PRIVATE n800ConsFin := 1, n800ConsEst := 1, n800ConsCli := 1, n800ConsIPI := 1, n800GrafMes := 1, n800ConsLoj := 1
PRIVATE n800ConsCon := 1, n800AClasse := 0, n800BClasse := 0, n800CClasse := 0, d800DtSdDe := ctod("//"), d800DtSdAte := ctod("//")
PRIVATE n800NumMax  := 0, n800NumMes  := 6, n800ConsDev := 2, n800ConsCar := 2, l800OrdCres := .T., n800ConsCli := 1
PRIVATE n800DiasRec := 0, c800BrCfFat := "", c800BrCfNFat := "", c800BrTsFat := "", c800BrTsNFat := ""
PRIVATE a800FatAno := {}, a800ArqTrb := {}, a800CampEmp := {}, a800Filtro := {}, c800Filtro := "", c800DesFil := ""
PRIVATE lInverte := .F., nOpcm:=1, ni, aSizeAut, aHeader, aCols, aButtons := {}, aButtxts := {}, nCol
PRIVATE lExterno := iif(xExterno!=Nil,xExterno,.F.), d800UltDtMoeda := u_GDVUltDtMoeda()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE FONT oFiltro NAME "Arial" SIZE 0, -9
                                        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao do historico de acessos (ZGY e ZGZ)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("GDVRDMENT") //Verifico rotina GDVRDMENT
	u_GDVRdmEnt() //Entrada na rotina
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ BRASCOLA - PE para gravar informacoes de acesso              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("BCFGA002")
	u_BCFGA002("GBRA800") //Grava detalhes da rotina usada
Endif
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza apenas nos modulos COM/PCP/FAT/EST                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cModulo != "FAT")
	MsgInfo("> Utilizar esta rotina para modulo de Faturamento!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !GB800Par1()
	Return
Endif
If (n800ConsCon == 1) //Quantidade/Faturamento
	cCadastro += " - Quantidade/Faturamento"
Elseif (n800ConsCon == 2) //Quantidade/Meta
	cCadastro += " - Quantidade/Meta"
Elseif (n800ConsCon == 3) //Faturamento/Meta
	cCadastro += " - Faturamento/Meta"
Endif
GB800Par2(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas utilizadas                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ             
If ExistBlock("BXLstCfTes")
	c800BrCfFat  := u_BXLstCfTes("BR_CFFAT")
	c800BrCfNFat := u_BXLstCfTes("BR_CFNFAT")
	c800BrTsFat  := u_BXLstCfTes("BR_TSFAT")
	c800BrTsNFat := u_BXLstCfTes("BR_TSNFAT")
Endif
d800Peri1 := dDatabase
For ni := 1 to (n800NumMes-1)
	d800Peri1 := d800Peri1-30
Next ni
d800Peri1 := ctod("01/"+Substr(dtoc(d800Peri1),4))
d800Peri2 := LastDay(dDatabase)
aButtons:= {} ; aButtxts:= {} ; aRotina := {{"","",0,1},{"","",0,2},{"","",0,3}}
aadd(aButtons,{"PMSEXCEL" ,{|| GB800ExpExcel(@oGetFat:aHeader,@oGetFat:aCols)},"Excel","Excel"})
aadd(aButtons,{"PROCESSA" ,{|| GB800AltPeri()    },"Periodo" ,"Periodo"})
aadd(aButtons,{"AUTOM"    ,{|| GB800Par2(.T.)    },"Parametr","Parametr"})
aadd(aButtons,{"DBG06"    ,{|| GB800Atualiza()   },"Atualiza","Atualiza"})
aadd(aButtons,{"EDITABLE" ,{|| GB800Carteira()   },"Carteira","Carteira"})               
If ExistBlock("GDVA030")
	aadd(aButtons,{"BMPUSER"  ,{|| u_GDVA030()    },"GDView CRM","GDView CRM"})
Endif
aadd(aButtxts,{"Fechar","Fechar", {|| oDlgGer:End() } })
aadd(a800Consul,{"FIL","Filial"      , .T.})
aadd(a800Consul,{"PAI","Pais"        , .T.})
aadd(a800Consul,{"EST","Estado"      , .T.})
aadd(a800Consul,{"MUN","Municipio"   , .T.})
aadd(a800Consul,{"CLI","Cliente"     , .T.})
aadd(a800Consul,{"REG","Regiao"      , .T.})
aadd(a800Consul,{"MER","Grp.Cliente" , .T.})
aadd(a800Consul,{"GRE","Grp.Represe" , .T.})
aadd(a800Consul,{"SUP","Supervisor"  , .T.})
aadd(a800Consul,{"VEN","Representan" , .T.})
aadd(a800Consul,{"PRO","Produto"     , .T.})
aadd(a800Consul,{"TIP","Tipo"        , .T.})
aadd(a800Consul,{"GRU","Grupo"       , .T.})
aadd(a800Consul,{"SEG","Segmento"    , .T.})
aadd(a800Consul,{"CFO","CFOP"        , .T.})
aadd(a800Consul,{"PAG","Cond.Pagto"  , .T.})
aadd(a800Consul,{"TPF","Tipo Frete"  , .T.})
aadd(a800Consul,{"TRA","Transpor."   , .T.})
aadd(a800Consul,{"EMI","Emissao"     , .T.})
aadd(a800Consul,{"SAI","Data Saida"  , .T.})
aadd(a800Consul,{"NOT","Nota"        , .T.})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco empresas disponiveis                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB800Empresas()

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
AAdd(aObjects,{  0,  25, .T., .F. })
aInfo := {aSizeAut[1],aSizeAut[2],aSizeAut[3],aSizeAut[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects)        
DEFINE MSDIALOG oDlgGer FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] TITLE OemToAnsi(cCadastro) Of oMainWnd PIXEL
@ aPosObj[2,1]+2,aPosObj[2,2] SAY o800Gdview VAR "GDVIEW FATURAMENTO" OF oDlgGer PIXEL SIZE 245,9 COLOR GDV_CORGDV FONT oBold
@ aPosObj[2,1]+2,aPosObj[2,2]+150 SAY o800Peri VAR "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2) OF oDlgGer PIXEL SIZE 245,9 FONT oBold
@ aPosObj[2,1]+14,aPosObj[2,2] TO aPosObj[2,1]+15,(aPosObj[2,4]-aPosObj[2,2]-180) LABEL "" OF oDlgGer PIXEL
@ (aPosObj[2,1]+18),(((aPosObj[2,4]-aPosObj[2,2])*2)-200) BTNBMP o800Logo RESOURCE GDV_LOGOGDVIEW SIZE 200,41 ACTION oDlgGer:End() MESSAGE "GoldenView" PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Markbrowse para selecao das empresas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oMark := MsSelect():New("MEMP","M_OK",,a800CampEmp,@lInverte,@c800Marca,{aPosObj[3,1],aPosObj[3,2],aPosObj[3,3],aPosObj[3,4]},,,oDlgGer)
oMark:oBrowse:Refresh()
oButton0 := u_GDVButton(oDlgGer,"oButton0","GDView CRM",010,aPosObj[4,1],,,{|| u_GDVA030() })
If (n800ConsCon == 1)
	oButton1 := u_GDVButton(oDlgGer,"oButton1","Faturamento/Empresa",070,aPosObj[4,1],,,{||GB800GrafEmp(1)})
	oButton2 := u_GDVButton(oDlgGer,"oButton2","Quantidade/Empresa",130,aPosObj[4,1],,,{||GB800GrafEmp(2)})
	oButton3 := u_GDVButton(oDlgGer,"oButton3","Faturamento Periodo",190,aPosObj[4,1],,,{||GB800GrafPer(1)})
	oButton4 := u_GDVButton(oDlgGer,"oButton4","Quantidade Periodo",250,aPosObj[4,1],,,{||GB800GrafPer(2)})
	oButton5 := u_GDVButton(oDlgGer,"oButton5","Prazo Medio Periodo",310,aPosObj[4,1],,,{||GB800GrafPer(3)})
	oButton6 := u_GDVButton(oDlgGer,"oButton6","Comparativo",370,aPosObj[4,1],,,{||GB800Comparativo()})
	oButton7 := u_GDVButton(oDlgGer,"oButton7","Amostras/Bonificacao",430,aPosObj[4,1],,,{||u_BFATR017()})
	oButton8 := u_GDVButton(oDlgGer,"oButton8","1a Compra/Reativados",490,aPosObj[4,1],,,{||u_BFATR018()})
Elseif (n800ConsCon == 2)
	oButton2 := u_GDVButton(oDlgGer,"oButton2","Quantidade/Empresa",070,aPosObj[4,1],,,{||GB800GrafEmp(2)})
	oButton4 := u_GDVButton(oDlgGer,"oButton4","Quantidade Periodo",130,aPosObj[4,1],,,{||GB800GrafPer(2)})
	oButton5 := u_GDVButton(oDlgGer,"oButton5","Comparativo",190,aPosObj[4,1],,,{||GB800Comparativo()})
Elseif (n800ConsCon == 3)
	oButton1 := u_GDVButton(oDlgGer,"oButton1","Faturamento/Empresa",070,aPosObj[4,1],,,{||GB800GrafEmp(1)})
	oButton3 := u_GDVButton(oDlgGer,"oButton3","Faturamento Periodo",130,aPosObj[4,1],,,{||GB800GrafPer(1)})
	oButton5 := u_GDVButton(oDlgGer,"oButton5","Comparativo",190,aPosObj[4,1],,,{||GB800Comparativo()})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco dados de faturamento 12 meses                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||GB800FatAno(@aHeader,@aCols)},cCadastro)
oGetFat := MsNewGetDados():New(aPosObj[5,1],aPosObj[5,2],aPosObj[5,3],(aPosObj[5,4]/3),4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgGer,aHeader,aCols)
oGetFat:oBrowse:bLDblClick := { || GB800Coluna(oGetFat,oGetFat:oBrowse:nColPos) }
oGetFat:oBrowse:lUseDefaultColors := .F.
oGetFat:oBrowse:SetBlkBackColor({||RGB(250,250,250)})
nLin := aPosObj[6,1] ; nCol := 10
For ni := 1 to Len(a800Consul)
	bBlock := &("{|| GB800Consulta('"+a800Consul[ni,1]+"',oGetFat:aCols,oGetFat:oBrowse:nAt) }")
	oButton9 := u_GDVButton(oDlgGer,"oButGer"+Alltrim(Str(ni,1)),a800Consul[ni,2],nCol,nLin,40,,bBlock)
	nCol += 40                                 
	If (nCol > ((aSizeAut[5]/3)-50))
		nCol := 10
		nLin += 12
	Endif
Next ni

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto grafico em barras para mostrar o faturamento 12 meses³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oScroll := TScrollBox():Create(oDlgGer,aPosObj[5,1],(aPosObj[5,4]/3),(aPosObj[5,3]-aPosObj[5,1]),(aPosObj[5,4]-(aPosObj[5,4]/3)),.T.,.T.,.T.)
GB800DoGraph(@aHeader,@aCols)

ACTIVATE MSDIALOG oDlgGer ON INIT u_GDVMyBar(oDlgGer,,,aButtons,aButtxts)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecho arquivo temporario de empresas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB800FechaArqs()
If (Select("MEMP") <> 0)
	dbSelectArea("MEMP")
   dbCloseArea("MEMP")
   FErase(c800ArqEmp+GetDBExtension())
   FErase(c800ArqEmp+OrdBagExt())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gravacao do historico de acessos (ZGY e ZGZ)                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("GDVRDMSAI") //Verifico rotina GDVRDMSAI
	u_GDVRdmSai() //Saida da rotina
Endif

Return

Static Function GB800Empresas()
**************************
LOCAL aStru := {}, nMeta := 0, aSM0 := SM0->(GetArea())

//Monto aheader do markbrose
////////////////////////////    
c800Marca   := GetMark()
a800CampEmp := {}
aadd(a800CampEmp,{"M_OK"    ,""," "   })
aadd(a800CampEmp,{"M_CODEMP","","Empresa" , "@!" })
aadd(a800CampEmp,{"M_CODFIL","","Filial"  , "@!" })
aadd(a800CampEmp,{"M_NOME"  ,"","Nome"    , "@!" })
If (n800ConsCon == 1) //Quantidade/Faturamento
	aadd(a800CampEmp,{"M_PEDID" ,"","Pedidos"      , "@E 999,999" })
	aadd(a800CampEmp,{"M_PESO"  ,"","Peso KG"      , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_QUANT" ,"","Quantidade"   , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_FATUR" ,"","Faturamento"  , "@E 999,999,999.99" })
Elseif (n800ConsCon == 2) //Quantidade/Meta
	aadd(a800CampEmp,{"M_PEDID" ,"","Pedidos"      , "@E 999,999" })
	aadd(a800CampEmp,{"M_PESO"  ,"","Peso KG"      , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_QUANT" ,"","Quantidade"   , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_META"  ,"","Meta"         , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_REAL"  ,"","% Realizado"  , "@E 999999.9999" })
Elseif (n800ConsCon == 3) //Faturamento/Meta
	aadd(a800CampEmp,{"M_PEDID" ,"","Pedidos"      , "@E 999,999" })
	aadd(a800CampEmp,{"M_PESO"  ,"","Peso KG"      , "@E 999,999,999" })
	aadd(a800CampEmp,{"M_FATUR" ,"","Faturamento"  , "@E 999,999,999.99" })
	aadd(a800CampEmp,{"M_META"  ,"","Meta"         , "@E 999,999,999.99" })
	aadd(a800CampEmp,{"M_REAL"  ,"","% Realizado"  , "@E 999999.9999" })
Endif
aadd(a800CampEmp,{"M_PDESC" ,"","% Desconto"   , "@E 999.99" })
aadd(a800CampEmp,{"M_VLDSC" ,"","Vlr.Descon"   , "@E 999,999,999.99" })

//Monta estrutura do arquivp de trabalho
////////////////////////////////////////
aadd(aStru,{"M_OK"    ,"C",02,0})
aadd(aStru,{"M_CODEMP","C",02,0})
aadd(aStru,{"M_CODFIL","C",02,0})
aadd(aStru,{"M_NOME"  ,"C",50,0})
aadd(aStru,{"M_PEDID" ,"N",07,0})
aadd(aStru,{"M_PESO"  ,"N",17,2})
aadd(aStru,{"M_QUANT" ,"N",17,2})
aadd(aStru,{"M_FATUR" ,"N",17,2})
aadd(aStru,{"M_META"  ,"N",17,2})
aadd(aStru,{"M_REAL"  ,"N",11,4})
aadd(aStru,{"M_PDESC" ,"N",06,2})
aadd(aStru,{"M_VLDSC" ,"N",17,2})
If (Select("MEMP") <> 0)
	dbSelectArea("MEMP")
   dbCloseArea("MEMP")
Endif
c800ArqEmp := CriaTrab(aStru,.t.)
dbUseArea(.T.,,c800ArqEmp,"MEMP",NIL,.F.)
dbSelectArea("SM0")
Procregua(SM0->(Reccount()))
dbGotop()
While !SM0->(Eof())
	Incproc("> Abrindo empresa..."+SM0->M0_nome)
	If (("10"$cVersao).and.(SM0->M0_codigo $ "02")).or.(("11"$cVersao).and.(SM0->M0_codigo $ "01"))
		dbSelectArea("MEMP")
		Reclock("MEMP",.T.)
		MEMP->M_ok     := c800Marca
		MEMP->M_codemp := SM0->M0_codigo
		MEMP->M_codfil := SM0->M0_codfil
		MEMP->M_nome   := Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial)
		MsUnlock("MEMP")
		GB800ArqTrb(SM0->M0_codigo,SM0->M0_codfil)
   Endif
	dbSelectArea("SM0")
 	SM0->(dbSkip())
Enddo
MEMP->(dbGotop())            
              
//Abro arquivos utilizados pela rotina
//////////////////////////////////////
GB800OpenArqs()

u_GDVRestArea({aSM0})  //GOLDENVIEW

Return

Static Function GB800ArqTrb(xEmp,xFil)
*********************************
LOCAL nx, cAlias1
If !Empty(xEmp)
	If (Select("MSX2") <> 0)
		dbSelectArea("MSX2")
	   dbCloseArea()
	Endif
	dbUseArea(.T.,,"SX2"+xEmp+"0","MSX2",Nil,.F.)
   dbSetIndex("SX2"+xEmp+"0")
   For nx := 1 to Len(a800Tabs)
      If MSX2->(dbSeek(a800Tabs[nx]))
	      cAlias1 := Alltrim(MSX2->X2_chave)
      	If (cEmpAnt != xEmp)
      		cAlias1 += xEmp
      	Endif
			aadd(a800ArqTrb,{xEmp,MSX2->X2_chave,Alltrim(MSX2->X2_arquivo),MSX2->X2_modo,cAlias1})
		Endif   
   Next nx   
	If (Select("MSX2") <> 0)
		dbSelectArea("MSX2")
	   dbCloseArea()
	Endif
Endif
Return

Static Function GB800OpenArqs()
***************************
LOCAL nx, nInd
For nx := 1 to Len(a800ArqTrb)
	If (Select(a800ArqTrb[nx,5]) == 0)
		dbUseArea(.T.,"TOPCONN",a800ArqTrb[nx,3],a800ArqTrb[nx,5],.T.,.F.)
		dbSelectArea("SIX")
		If dbSeek(a800ArqTrb[nx,2])
			While !SIX->(Eof()).and.(SIX->INDICE == a800ArqTrb[nx,2])
				dbSelectArea(a800ArqTrb[nx,5])
				nInd := Alltrim(a800ArqTrb[nx,3])+SIX->ORDEM
				MsOpenIdx(nInd,SIX->CHAVE,.F.,.F.,,a800ArqTrb[nx,3])
				dbSelectArea("SIX")
				SIX->(dbSkip())
			Enddo
		Endif
	Endif
Next nx
Return

Static Function GB800FechaArqs()
***************************
LOCAL nx, cAlias1
For nx := 1 to Len(a800ArqTrb)
	cAlias1 := a800ArqTrb[nx,5]
	If (Len(cAlias1) == 5).and.(Substr(cAlias1,4,2) != cEmpAnt).and.(Select(cAlias1) <> 0)
		dbSelectArea(cAlias1)
   	dbCloseArea()
	Endif
Next nx
Return

Static Function GB800RetArq(xAlias,xEmp)
***********************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a800ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := a800ArqTrb[nPos,3]
Endif
Return cRetu

Static Function GB800RetFil(xAlias,xEmp,xFil)
****************************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a800ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := iif(a800ArqTrb[nPos,4]=="C",Space(2),xFil)
Endif
Return cRetu

Static Function GB800RetAlias(xAlias,xEmp)
************************************
LOCAL nPos := 0, cRetu := ""
nPos := aScan(a800ArqTrb, {|x| x[1]+x[2] == xEmp+xAlias })
If (nPos > 0)
	cRetu := a800ArqTrb[nPos,5]
Endif
Return cRetu

Static Function GB800Cores(nx)
**************************
LOCAL aCores := {CLR_HBLUE,CLR_HGREEN,CLR_HCYAN,CLR_HRED,CLR_HMAGENTA,CLR_YELLOW,CLR_WHITE,CLR_BLUE,;
		CLR_GREEN,CLR_CYAN,CLR_RED,CLR_GRAY,CLR_MAGENTA,CLR_BROWN,CLR_HGRAY,CLR_LIGHTGRAY,CLR_BLACK}
If (nx < 0).or.(nx > 17)
	nx := 1
Endif	
Return (aCores[nx++])

Static Function GB800Par1()
************************
LOCAL aRegs := {}, cPerg := "GB800A", lRetu := .F.
                                
//Cria grupo de perguntas
/////////////////////////
AADD(aRegs,{cPerg,"01","Tipo Visao Gerencial   ?","mv_ch1","N",01,0,0,"C","","MV_PAR01","Quantid/Faturam","","","Quantid/Meta","","","Faturam/Meta","","","","","","","",""})
u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW
If Pergunte(cPerg,.T.)
	n800ConsCon := mv_par01
	lRetu := .T.
Endif

Return lRetu

Static Function GB800Par2(xMostra)
******************************
LOCAL aRegs := {}, cPerg := "GB800B"

//Cria grupo de perguntas
/////////////////////////
AADD(aRegs,{cPerg,"01","Considera Financeiro     ?","mv_ch1","N",01,0,1,"C","","MV_PAR01","Sim","","","Nao","","","Ambos","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Considera Estoque        ?","mv_ch2","N",01,0,3,"C","","MV_PAR02","Sim","","","Nao","","","Ambos","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Considera Loja Cliente   ?","mv_ch3","N",01,0,2,"C","","MV_PAR03","Sim","","","Nao","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Considera Receita Liquida?","mv_ch4","N",01,0,2,"C","","MV_PAR04","Sim","","","Nao","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Considera Devolucao      ?","mv_ch5","N",01,0,2,"C","","MV_PAR05","Sim","","","Nao","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Tipo Grafico 12 Meses    ?","mv_ch6","N",01,0,3,"C","","MV_PAR06","Barras","","","Pizza","","","Linha","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Percentual Classe A      ?","mv_ch7","N",03,0,0,"G","","MV_PAR07","","30","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"08","Percentual Classe B      ?","mv_ch8","N",03,0,0,"G","","MV_PAR08","","40","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"09","Percentual Classe C      ?","mv_ch9","N",03,0,0,"G","","MV_PAR09","","30","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"10","Maximo Linhas Drill-Down?","mv_chA","N",05,0,0,"G","","MV_PAR10","","20000","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"11","Numero Meses Inicial     ?","mv_chB","N",02,0,0,"G","","MV_PAR11","","6","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"12","Considera Clientes       ?","mv_chC","N",01,0,1,"C","","MV_PAR12","Todos","","","1a Compra","","","Recuperados","","","","","","","",""})
AADD(aRegs,{cPerg,"13","Ult.Compra Menor (dias)  ?","mv_chD","N",03,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"14","Data de Saída De         ?","mv_chE","D",08,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Data de Saída Ate        ?","mv_chF","D",08,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","",""})
u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW         
If (xMostra)
	While (.T.)
		If Pergunte(cPerg,.T.)
			n800ConsFin := mv_par01
			n800ConsEst := mv_par02
			n800ConsLoj := mv_par03
			n800ConsIPI := mv_par04
			n800ConsDev := mv_par05
			n800GrafMes := mv_par06
			n800AClasse := mv_par07
			n800BClasse := mv_par08
			n800CClasse := mv_par09
			n800NumMax  := mv_par10
			n800NumMes  := mv_par11
			n800ConsCli := mv_par12
			n800DiasRec := mv_par13
			d800DtSdDe  := mv_par14
			d800DtSdAte := mv_par15
			If (int(n800AClasse+n800BClasse+n800CClasse) != 100)
				MsgInfo("> A soma das classes ABC deve ser 100! Tente novamente.","ATENCAO")
				Loop
			Endif
			GB800Atualiza()
		Endif
		Exit
	Enddo
Else
	Pergunte(cPerg,.F.)
	n800ConsFin := mv_par01
	n800ConsEst := mv_par02
	n800ConsLoj := mv_par03
	n800ConsIPI := mv_par04
	n800ConsDev := mv_par05
	n800GrafMes := mv_par06
	n800AClasse := mv_par07
	n800BClasse := mv_par08
	n800CClasse := mv_par09
	n800NumMax  := mv_par10
	n800NumMes  := mv_par11
	n800ConsCli := mv_par12
	n800DiasRec := mv_par13
	d800DtSdDe  := mv_par14
	d800DtSdAte := mv_par15
Endif

Return

Static Function GB800Par3(xMostra,xOpca)
************************************
LOCAL aRegs := {}, cPerg := "GB800C"+xOpca, lRetu := .F.
                                
//Cria grupo de perguntas
/////////////////////////
AADD(aRegs,{cPerg,"01","Codigo Cliente De     ?","mv_ch1","C",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"02","Codigo Cliente Ate    ?","mv_ch2","C",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"03","Loja Cliente De       ?","mv_ch3","C",04,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Loja Cliente Ate      ?","mv_ch4","C",04,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Codigo Produto De     ?","mv_ch5","C",15,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"06","Codigo Produto Ate    ?","mv_ch6","C",15,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"07","Grupo de Produtos De  ?","mv_ch7","C",04,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"08","Grupo de Produtos Ate ?","mv_ch8","C",04,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SBM"})
AADD(aRegs,{cPerg,"09","Segmento De           ?","mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","T3"})
AADD(aRegs,{cPerg,"10","Segmento Ate          ?","mv_chA","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","T3"})
AADD(aRegs,{cPerg,"11","Tipo de Produto De    ?","mv_chB","C",02,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","02"})
AADD(aRegs,{cPerg,"12","Tipo de Produto Ate   ?","mv_chC","C",02,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","02"})
AADD(aRegs,{cPerg,"13","Vendedor De           ?","mv_chD","C",06,0,0,"G","","MV_PAR13","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"14","Vendedor Ate          ?","mv_chE","C",06,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"15","Supervisor De         ?","mv_chF","C",06,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"16","Supervisor Ate        ?","mv_chG","C",06,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"17","Estado De             ?","mv_chH","C",02,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","12"})
AADD(aRegs,{cPerg,"18","Estado Ate            ?","mv_chI","C",02,0,0,"G","","MV_PAR18","","","","","","","","","","","","","","","12"})
u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW
lRetu := Pergunte(cPerg,xMostra)

Return lRetu

Static Function GB800AltPeri()
***************************
LOCAL oPeri:=Nil,dPeri1:=ctod("//"),dPeri2:=ctod("//"),nOpcy:=0

//Monto tela para novo ano base
///////////////////////////////////////
dPeri1 := d800Peri1 ; dPeri2 := d800Peri2
DEFINE MSDIALOG oPeri TITLE "Altera Periodo" FROM 0,0 TO 80,300 OF oDlgGer PIXEL 
@ 008,010 SAY "Periodo:" OF oPeri SIZE 30,10 PIXEL 
@ 006,035 GET dPeri1 OF oPeri SIZE 45,10 VALID !Empty(dPeri1) PIXEL
@ 008,085 SAY "ate" OF oPeri SIZE 20,10 PIXEL 
@ 006,098 GET dPeri2 OF oPeri SIZE 45,10 VALID !Empty(dPeri2) PIXEL
@ 025,010 BUTTON "Confirma" SIZE 50,10 OF oPeri PIXEL ACTION (nOpcy:=1,oPeri:End())
@ 025,060 BUTTON "Cancela" SIZE 50,10 OF oPeri PIXEL ACTION (nOpcy:=2,oPeri:End())
ACTIVATE MSDIALOG oPeri CENTER
If (nOpcy == 1)
	d800Peri1 := dPeri1
	d800Peri2 := dPeri2
	o800Peri:cCaption := "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2)
	o800Peri:Refresh()	
	GB800Atualiza()
Endif
Return
                                           
Static Function GB800Carteira()
***************************
If (n800ConsCar == 1) //Sim
	If MsgYesNo("> Retirar Carteira da Visao?","ATENCAO")
		n800ConsCar := 2
		GB800Atualiza()  
	Endif
Elseif (n800ConsCar == 2) //Nao
	If MsgYesNo("> Incluir Carteira da Visao?","ATENCAO")
		n800ConsCar := 1
		GB800Atualiza()  
	Endif
Endif		
Return

Static Function GB800Atualiza()
***************************
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo faturamento                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||GB800FatAno(@aHeader,@aCols)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo getdados                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (oGetFat != Nil)
	oGetFat:aCols := aClone(aCols)
	oGetFat:oBrowse:Refresh()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo grafico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GB800DoGraph(@aHeader,@aCols)

Return

Static Function GB800FatAno(aHeader,aCols)
************************************
LOCAL cQuery := "", cAnoMes := "", nMetEmp := 0, nDesEmp := 0, nValor := 0
LOCAL nPos := 0, nMeta := 0, nReal := 0, nTotMeta := 0, nPartAcm := 0, nPartic := 0, nPedid := 0
LOCAL nPeso := 0, nQuant := 0, nDescon := 0, nTotal := 0, nPesEmp := 0, nQtdEmp := 0, nTotEmp := 0, nPedEmp := 0

//Busco o faturamento geral por empresa
///////////////////////////////////////
a800FatAno := {}
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !MEMP->(Eof())
                            
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+" > Montando Visao...")

	If !IsMark("M_OK",c800Marca,lInverte)
		dbSelectArea("MEMP")
		MEMP->(dbSkip())
	   Loop
	Endif  

	//Monto query para buscar dados de faturamento ano base
	///////////////////////////////////////////////////////
	If (n800ConsCli == 1) //Todos
		cQuery := "SELECT D2.D2_EMISSAO M_EMISSAO,"
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery := "SELECT D2.D2_EMISSAO M_EMISSAO,D2.D2_CLIENTE M_CLIENTE,D2.D2_LOJA M_LOJA,"
	Endif
	cQuery += "COUNT(DISTINCT D2.D2_PEDIDO) M_PEDID,SUM(D2.D2_QUANT*B1.B1_PESO) M_PESO,SUM(D2.D2_QUANT) M_QUANT,SUM(D2.D2_DESCON) M_VLDSC,"
	If (n800ConsIPI == 1) //Sim 
		cQuery += "SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6) M_TOTAL "
	Elseif (n800ConsIPI == 2) //Nao
		cQuery += "SUM(D2.D2_VALBRUT) M_TOTAL "
	Endif
	cQuery += "FROM "+GB800RetArq("SD2",MEMP->M_codemp)+" D2 "
	cQuery += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
	cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D2.D2_COD = B1.B1_COD) "
	cQuery += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+GB800RetFil("SD2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND D2.D2_TIPO NOT IN ('B','D') "
	If (n800ConsFin == 1)
		cQuery += "AND F4.F4_DUPLIC = 'S' "
	Elseif (n800ConsFin == 2)
		cQuery += "AND F4.F4_DUPLIC = 'N' "
	Endif
	If (n800ConsEst == 1)
		cQuery += "AND F4.F4_ESTOQUE = 'S' "
	Elseif (n800ConsEst == 2)
		cQuery += "AND F4.F4_ESTOQUE = 'N' "
	Endif
	If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery += "AND F2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery += "AND F2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	If !Empty(c800BrCfFat)
		cQuery += "AND D2.D2_CF IN ("+c800BrCfFat+") "
	Endif
	If !Empty(c800BrCfNFat)
		cQuery += "AND D2.D2_CF NOT IN ("+c800BrCfNFat+") "
	Endif
	If !Empty(c800BrTsFat)
		cQuery += "AND D2.D2_TES IN ("+c800BrTsFat+") "
	Endif
	If !Empty(c800BrTsNFat)
		cQuery += "AND D2.D2_TES NOT IN ("+c800BrTsNFat+") "
	Endif
	cQuery += "AND D2.D2_EMISSAO BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
	If !Empty(d800DtSdDe)
		cQuery += "AND F2.F2_DTSAIDA >= '"+dtos(d800DtSdDe)+"' "
	Endif
	If !Empty(d800DtSdAte)
		cQuery += "AND F2.F2_DTSAIDA <= '"+dtos(d800DtSdAte)+"' "
	Endif
	If (n800ConsCli == 1) //Todos
		cQuery += "GROUP BY D2.D2_EMISSAO "
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery += "GROUP BY D2.D2_EMISSAO,D2.D2_CLIENTE,D2.D2_LOJA "
	Endif
	cQuery += "ORDER BY M_EMISSAO "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	TCSetField("MAR","M_PESO"  ,"N",14,3)
	TCSetField("MAR","M_QUANT" ,"N",14,3)
	TCSetField("MAR","M_VLDSC" ,"N",17,2)
	TCSetField("MAR","M_TOTAL" ,"N",17,2)
	nPedEmp := 0 ; nPesEmp := 0 ; nQtdEmp := 0 ; nTotEmp := 0 ; nMetEmp := 0 ; nDesEmp := 0
	dbSelectArea("MAR")
	While !MAR->(Eof())
		cAnoMes := Substr(MAR->M_emissao,1,6)                                              
		If (n800ConsCli != 1)
			aNota := GB800Nota(MAR->M_cliente,MAR->M_loja,cAnoMes)
			If !(((n800ConsCli == 2).and.Empty(aNota[1])).or.((n800ConsCli == 3).and.!Empty(aNota[1]).and.(aNota[1] <= (FirstDay(stod(MAR->M_emissao))-n800DiasRec))))
				dbSelectArea("MAR")
				MAR->(dbSkip())
				Loop
			Endif
		Endif
		nPos := aScan(a800FatAno, {|x| x[1] == cAnoMes })
		If (nPos == 0)
			nTotMeta := GB800MetaSCT(MEMP->M_codemp,MEMP->M_codfil,,stod(MAR->M_emissao))
			nMetEmp  += nTotMeta
			aadd(a800FatAno,{cAnoMes,0,0,0,nTotMeta,0,0})
			nPos := Len(a800FatAno)
		Endif
		a800FatAno[nPos,2] += MAR->M_peso
		a800FatAno[nPos,3] += MAR->M_quant
		a800FatAno[nPos,4] += MAR->M_total
		a800FatAno[nPos,6] += MAR->M_vldsc
		a800FatAno[nPos,7] += MAR->M_pedid
		nPedid += MAR->M_pedid
		nPeso  += MAR->M_peso
		nQuant += MAR->M_quant
		nDescon+= MAR->M_vldsc
		nTotal += MAR->M_total
		nPedEmp+= MAR->M_pedid
		nPesEmp+= MAR->M_peso
		nQtdEmp+= MAR->M_quant
		nDesEmp+= MAR->M_vldsc
		nTotEmp+= MAR->M_total
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de devolucao ano base
	/////////////////////////////////////////////////////
	If (n800ConsDev == 1)
		cQuery := "SELECT D1.D1_DTDIGIT M_EMISSAO,"
		cQuery += "SUM(D1.D1_QUANT*B1.B1_PESO) M_PESO,SUM(D1.D1_QUANT) M_QUANT,SUM(D1.D1_VALDESC) M_VLDSC,"
		If (n800ConsIPI == 1) //Sim 
			cQuery += "SUM(D1.D1_TOTAL-D1.D1_VALICM-D1.D1_VALIMP5-D1.D1_VALIMP6-D1.D1_VALDESC) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery += "SUM(D1.D1_TOTAL+D1.D1_VALIPI+D1.D1_ICMSRET-D1.D1_VALDESC+D1.D1_VALFRE) M_TOTAL "
		Endif
		cQuery += "FROM "+GB800RetArq("SD1",MEMP->M_codemp)+" D1 "
		cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
		cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D1.D1_COD = B1.B1_COD) "
		cQuery += "INNER JOIN "+GB800RetArq("SF1",MEMP->M_codemp)+" F1 ON (D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA) "
		cQuery += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D1.D1_NFORI = F2.F2_DOC AND D1.D1_SERIORI = F2.F2_SERIE AND D1.D1_FORNECE = F2.F2_CLIENTE AND D1.D1_LOJA = F2.F2_LOJA) "
		cQuery += "WHERE D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+GB800RetFil("SD1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND D1.D1_TIPO = 'D' "
		If (n800ConsFin == 1)
			cQuery += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery += "AND F2.F2_VEND1 IN ("+cCodRep+") "
			Else
				cQuery += "AND F2.F2_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		cQuery += "AND D1.D1_DTDIGIT BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
		cQuery += "GROUP BY D1.D1_DTDIGIT "
		cQuery += "ORDER BY M_EMISSAO "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		TCSetField("MAR","M_PESO"  ,"N",14,3)
		TCSetField("MAR","M_QUANT" ,"N",14,3)
		TCSetField("MAR","M_VLDSC" ,"N",17,2)
		TCSetField("MAR","M_TOTAL" ,"N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			cAnoMes := Substr(MAR->M_emissao,1,6)
			nPos := aScan(a800FatAno, {|x| x[1] == cAnoMes })
			If (nPos == 0)
				aadd(a800FatAno,{cAnoMes,0,0,0,0,0,0})
				nPos := Len(a800FatAno)
			Endif
			a800FatAno[nPos,2] -= MAR->M_peso
			a800FatAno[nPos,3] -= MAR->M_quant
			a800FatAno[nPos,4] -= MAR->M_total
			a800FatAno[nPos,6] -= MAR->M_vldsc
			nPeso  -= MAR->M_peso 
			nQuant -= MAR->M_quant
			nDescon-= MAR->M_vldsc
			nTotal -= MAR->M_total
			nPesEmp-= MAR->M_peso 
			nQtdEmp-= MAR->M_quant
			nDesEmp-= MAR->M_vldsc
			nTotEmp-= MAR->M_total
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	//Monto query para buscar dados de carteira ano base
	////////////////////////////////////////////////////
	If (n800ConsCar == 1)
		cQuery := "SELECT C6.C6_ENTREG M_EMISSAO,C5.C5_MOEDA M_MOEDA,"
		cQuery += "COUNT(DISTINCT C5_NUM) M_PEDID,SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*B1_PESO) M_PESO,SUM(C6.C6_QTDVEN-C6.C6_QTDENT) M_QUANT,SUM(C6.C6_VALDESC) M_VLDSC,"
		If (n800ConsIPI == 1) //Sim 
			cQuery += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCLIQ) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCVEN) M_TOTAL "
		Endif
		cQuery += "FROM "+GB800RetArq("SC6",MEMP->M_codemp)+" C6 "
		cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
		cQuery += "INNER JOIN "+GB800RetArq("SC5",MEMP->M_codemp)+" C5 ON (C6.C6_NUM = C5.C5_NUM) "
		cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
		cQuery += "WHERE C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+GB800RetFil("SC6",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+GB800RetFil("SC5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND C5.C5_TIPO = 'N' AND C6.C6_QTDVEN > C6.C6_QTDENT AND C6.C6_BLQ <> 'R' "
		cQuery += "AND C6.C6_ENTREG < '"+dtos(d800Peri2)+"' "
		If (n800ConsFin == 1)
			cQuery += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery += "AND C5.C5_VEND1 IN ("+cCodRep+") "
			Else
				cQuery += "AND C5.C5_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		If !Empty(c800BrCfFat)
			cQuery += "AND C6.C6_CF IN ("+c800BrCfFat+") "
		Endif
		If !Empty(c800BrCfNFat)
			cQuery += "AND C6.C6_CF NOT IN ("+c800BrCfNFat+") "
		Endif
		If !Empty(c800BrTsFat)
			cQuery += "AND C6.C6_TES IN ("+c800BrTsFat+") "
		Endif
		If !Empty(c800BrTsNFat)
			cQuery += "AND C6.C6_TES NOT IN ("+c800BrTsNFat+") "
		Endif
		cQuery += "GROUP BY C6.C6_ENTREG,C5.C5_MOEDA "
		cQuery += "ORDER BY M_EMISSAO "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		TCSetField("MAR","M_PESO"   ,"N",14,3)
		TCSetField("MAR","M_QUANT"  ,"N",14,3)
		TCSetField("MAR","M_VLDSC"  ,"N",17,2)
		TCSetField("MAR","M_TOTAL"  ,"N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			cAnoMes := Substr(MAR->M_Emissao,1,6)
			If (cAnoMes < Substr(dtos(dDatabase),1,6))
				cAnoMes := Substr(dtos(dDatabase),1,6)
			Endif
			nPos := aScan(a800FatAno, {|x| x[1] == cAnoMes })
			If (nPos == 0)
				aadd(a800FatAno,{cAnoMes,0,0,0,0,0,0})
				nPos := Len(a800FatAno)
			Endif
			nValor := xMoeda(MAR->M_total,MAR->M_moeda,1,d800UltDtMoeda)
			nVlDsc := xMoeda(MAR->M_vldsc,MAR->M_moeda,1,d800UltDtMoeda)
			a800FatAno[nPos,2] += MAR->M_peso
			a800FatAno[nPos,3] += MAR->M_quant
			a800FatAno[nPos,4] += nValor
			a800FatAno[nPos,6] += nVlDsc
			a800FatAno[nPos,7] += MAR->M_pedid
			nPedid += MAR->M_pedid
			nPeso  += MAR->M_peso
			nQuant += MAR->M_quant
			nDescon+= nVlDsc
			nTotal += nValor
			nPedEmp+= MAR->M_pedid
			nPesEmp+= MAR->M_peso
			nQtdEmp+= MAR->M_quant
			nDesEmp+= nVlDsc
			nTotEmp+= nValor
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif
	
	dbSelectArea("MEMP")
	Reclock("MEMP",.F.)
	MEMP->M_PEDID := nPedEmp
	MEMP->M_PESO  := nPesEmp
	MEMP->M_QUANT := nQtdEmp
	MEMP->M_FATUR := nTotEmp
	MEMP->M_VLDSC := nDesEmp
	MEMP->M_META  := nMetEmp
	MEMP->M_REAL  := 0
	If (MEMP->M_META > 0)
		If (n800ConsCon == 1).or.(n800ConsCon == 3) //Quantidade/Faturamento
			MEMP->M_REAL := (MEMP->M_FATUR/MEMP->M_META)*100
		Else
			MEMP->M_REAL := (MEMP->M_QUANT/MEMP->M_META)*100
		Endif
	Endif
	MEMP->M_PDESC := 0
	If ((MEMP->M_FATUR+MEMP->M_VLDSC) > 0)
		MEMP->M_PDESC := (MEMP->M_VLDSC/(MEMP->M_FATUR+MEMP->M_VLDSC))*100
	Endif
	MsUnlock("MEMP")
	
	dbSelectArea("MEMP")
	MEMP->(dbSkip())
Enddo 
MEMP->(dbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Ano/Mes faturamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
a800FatAno := aSort(a800FatAno,,,{|x,y| x[1]<y[1]})

//Monto aHeader e aCols
///////////////////////
aHeader := {}
aadd(aHeader,{"Mes"         ,"M_MES"   ,"@!",12,0,"","","C","",""})
If (n800ConsCon == 1) //Quantidade/Faturamento
	aadd(aHeader,{"Pedidos"     ,"M_PEDID" ,"@E 999,999",07,0,"","","N","",""})
	aadd(aHeader,{"Peso KG"     ,"M_PESO"  ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Quantidade"  ,"M_QUANT" ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Faturamento" ,"M_FATUR" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"% Desconto"  ,"M_PDESC" ,"@E 999.99",6,2,"","","N","",""})
	aadd(aHeader,{"Vlr.Descon"  ,"M_VLDSC" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"Prazo Medio" ,"M_PRZMED","@E 999,999.99",11,2,"","","N","",""})
Elseif (n800ConsCon == 2) //Quantidade/Meta
	aadd(aHeader,{"Pedidos"     ,"M_PEDID" ,"@E 999,999",07,0,"","","N","",""})
	aadd(aHeader,{"Peso KG"     ,"M_PESO"  ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Quantidade"  ,"M_QUANT" ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"% Desconto"  ,"M_PDESC" ,"@E 999.99",6,2,"","","N","",""})
	aadd(aHeader,{"Vlr.Descon"  ,"M_VLDSC" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"Meta"        ,"M_META"  ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"% Realizado" ,"M_REAL"  ,"@E 999.99",6,2,"","","N","",""})
Elseif (n800ConsCon == 3) //Faturamento/Meta
	aadd(aHeader,{"Pedidos"     ,"M_PEDID" ,"@E 999,999",07,0,"","","N","",""})
	aadd(aHeader,{"Peso KG"     ,"M_PESO"  ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Faturamento" ,"M_FATUR" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"% Desconto"  ,"M_PDESC" ,"@E 999.99",6,2,"","","N","",""})
	aadd(aHeader,{"Vlr.Descon"  ,"M_VLDSC" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"Meta"        ,"M_META"  ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"% Realizado" ,"M_REAL"  ,"@E 999.99",6,2,"","","N","",""})
Endif
If (oGetFat != Nil)
	oGetFat:aHeader := aClone(aHeader)
Endif
aCols := {} ; N := 1 ; nTotMeta := 0 ; nPartic := 0 ; nPartAcm := 0
For ni := 1 to Len(a800FatAno)
	cAnoMes := a800FatAno[ni,1]+" - "+Upper(Substr(MesExtenso(Val(Substr(a800FatAno[ni,1],5,2))),1,3))
	nPDesc := 0
	If ((a800FatAno[ni,4]+a800FatAno[ni,6]) != 0)
		nPDesc := (a800FatAno[ni,6]/(a800FatAno[ni,4]+a800FatAno[ni,6]))*100
	Endif
	If (n800ConsCon == 1) //Quantidade/Faturamento
		nPrazo := G800PrazoMedio(a800FatAno[ni,1])
		aadd(aCols,{cAnoMes,a800FatAno[ni,7],a800FatAno[ni,2],a800FatAno[ni,3],a800FatAno[ni,4],nPDesc,a800FatAno[ni,6],nPrazo,.F.})
	Elseif (n800ConsCon == 2) //Quantidade/Meta
		nMeta := a800FatAno[ni,5]
		nReal := 0
		If (nMeta > 0)
			nReal := (a800FatAno[ni,3]/nMeta)*100
		Endif
		nTotMeta += nMeta
		aadd(aCols,{cAnoMes,a800FatAno[ni,7],a800FatAno[ni,2],a800FatAno[ni,3],nPDesc,a800FatAno[ni,6],nMeta,nReal,.F.})
	Elseif (n800ConsCon == 3) //Faturamento/Meta
		nMeta := a800FatAno[ni,5]
		nReal := 0
		If (nMeta > 0)
			nReal := (a800FatAno[ni,4]/nMeta)*100
		Endif
		nTotMeta += nMeta
		aadd(aCols,{cAnoMes,a800FatAno[ni,7],a800FatAno[ni,2],a800FatAno[ni,4],nPDesc,a800FatAno[ni,6],nMeta,nReal,.F.})
	Endif
Next ni
nPDesc := 0
If ((nTotal+nDescon) != 0)
	nPDesc := (nDescon/(nTotal+nDescon))*100
Endif
If (n800ConsCon == 1) //Quantidade/Faturamento
	aadd(aCols,{"TOTAL > ",nPedid,nPeso,nQuant,nTotal,nPDesc,nDescon,0,.F.})
Elseif (n800ConsCon == 2) //Quantidade/Meta
	nReal := 0
	If (nTotMeta > 0)
		nReal := (nQuant/nTotMeta)*100
	Endif
	aadd(aCols,{"TOTAL > ",nPedid,nPeso,nQuant,nPDesc,nDescon,nTotMeta,nReal,.F.})
Elseif (n800ConsCon == 3) //Faturamento/Meta
	nReal := 0
	If (nTotMeta > 0)
		nReal := (nTotal/nTotMeta)*100
	Endif
	aadd(aCols,{"TOTAL > ",nPedid,nPeso,nTotal,nPDesc,nDescon,nTotMeta,nReal,.F.})
Endif

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

Static Function GB800TpGraf()
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

Static Function GB800GrafEmp(xTipo)
******************************
LOCAL oDlgGra, oMSGraphic, aInfo2, aPosObj2, aEmp2 := {}, aSerie2 := {}, aSizeGrf2, aObjects2
LOCAL cTitulo  := "", cTitle1 := "", cTitle2 := "", cTitulo := "Grafico Gerencial Faturamento"
LOCAL nOpcb, nCbx := 1, nSerie2, nSerie3, nSerie4, nCor := 1, ni

//Busco dados das empresas
//////////////////////////
dbSelectArea("MEMP")
dbGotop()
While !MEMP->(Eof())
	If IsMark("M_OK",c800Marca,lInverte)
		aadd(aEmp2,{Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial),iif(xTipo==2,int(MEMP->M_QUANT),int(MEMP->M_FATUR)),int(MEMP->M_META)})
	Endif
	dbSelectArea("MEMP")
   MEMP->(dbSkip())
Enddo
MEMP->(dbGotop())

//Busco tipo do grafico
///////////////////////
nCbx := GB800TpGraf()

//Monto Grafico
///////////////
aObjects2 := {}
aSizeGrf2 := MsAdvSize(,.F.,400)
AAdd(aObjects2,{  0, 400, .T., .T. })
aInfo2   := {aSizeGrf2[1],aSizeGrf2[2],aSizeGrf2[3],aSizeGrf2[4],3,3}
aPosObj2 := MsObjSize(aInfo2,aObjects2)
DEFINE MSDIALOG oDlgGra FROM 0,0 TO aSizeGrf2[6],aSizeGrf2[5] TITLE cTitulo PIXEL 
@ 005, 005 MSGRAPHIC oMSGraphic SIZE (aPosObj2[1,4]-aPosObj2[1,2]-5),(aPosObj2[1,3]-aPosObj2[1,1]-20) OF oDlgGra
oMSGraphic:SetMargins(2,2,2,2)                      
oMSGraphic:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oMSGraphic:SetTitle("Empresa","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
If (n800ConsCon == 1) //Quantidade/Faturamento
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	For ni := 1 to Len(aEmp2)
	  	oMSGraphic:Add(nSerie2,aEmp2[ni,2],aEmp2[ni,1],GB800Cores(@nCor))
	Next ni
	If (xTipo == 2)
		oMSGraphic:SetTitle("","Quantidade",GDV_QUANT,A_LEFTJUST,GRP_TITLE)
	Else
		oMSGraphic:SetTitle("","Faturamento",GDV_FATUR,A_LEFTJUST,GRP_TITLE)
	Endif
Else
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	nSerie3 := oMSGraphic:CreateSerie(nCbx)
	For ni := 1 to Len(aEmp2)
	  	oMSGraphic:Add(nSerie2,aEmp2[ni,2],aEmp2[ni,1],iif(xTipo==2,GDV_QUANT,GDV_FATUR))
	  	oMSGraphic:Add(nSerie3,aEmp2[ni,3],aEmp2[ni,1],GDV_META)
	Next ni
	If (xTipo == 2)
		oMSGraphic:SetTitle("","Quantidade",GDV_QUANT,A_LEFTJUST,GRP_TITLE)
	Else
		oMSGraphic:SetTitle("","Faturamento",GDV_FATUR,A_LEFTJUST,GRP_TITLE)
	Endif
Endif
oMSGraphic:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,(nCbx==10))
oMSGraphic:cCaption := cTitulo
oMSGraphic:lShowHint := .T.
oMSGraphic:l3D := .T.    
oMSGraphic:Refresh()
@ aSizeGrf2[4]-25,008 BUTTON "Fechar"         SIZE 30,10 OF oDlgGra PIXEL ACTION oDlgGra:End()
@ aSizeGrf2[4]-25,048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgGra PIXEL ACTION PmsGrafMail(oMSGraphic,"GDView Faturamento",{"GDView Faturamento",cTitulo},{},1) // E-Mail
@ aSizeGrf2[4]-25,078 BUTTON "Salvar"         SIZE 30,10 OF oDlgGra PIXEL ACTION GrafSavBmp(oMSGraphic)
@ aSizeGrf2[4]-25,108 BUTTON "&3D"            SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:l3D := !oMSGraphic:l3D
@ aSizeGrf2[4]-25,138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:lAxisVisib := !oMSGraphic:lAxisVisib
@ aSizeGrf2[4]-25,168 BUTTON "+"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomIn()
@ aSizeGrf2[4]-25,183 BUTTON "-"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomOut()
If (n800ConsCon == 1) //Quantidade/Faturamento
	@ aSizeGrf2[4]-25,250 SAY iif(xTipo==2,"Quantidade","Faturamento") OF oDlgGra PIXEL COLOR iif(xTipo==2,GDV_QUANT,GDV_FATUR) SIZE 50,10 FONT oBold
Else
	@ aSizeGrf2[4]-25,250 SAY iif(xTipo==2,"Quantidade","Faturamento") OF oDlgGra PIXEL COLOR iif(xTipo==2,GDV_QUANT,GDV_FATUR) SIZE 50,10 FONT oBold
	@ aSizeGrf2[4]-25,350 SAY "Meta" OF oDlgGra PIXEL COLOR GDV_META SIZE 50,10
Endif
ACTIVATE MSDIALOG oDlgGra CENTER

Return

Static Function GB800GrafPer(xTipo)
******************************
LOCAL oDlgGra, oMSGraphic, aInfo2, aPosObj2, aSerie2 := {}, aSizeGrf2, aObjects2
LOCAL cTitulo  := "", cTitle1 := "", cTitle2 := "", cTitulo := "Grafico Gerencial Faturamento"
LOCAL nOpcb, nCbx := 1, nSerie2, nSerie3, nSerie4, nCor := 1, ni

//Busco tipo do grafico
///////////////////////
nCbx := GB800TpGraf()

//Monto Grafico
///////////////
aObjects2 := {}
aSizeGrf2 := MsAdvSize(,.F.,400)
AAdd(aObjects2,{  0, 400, .T., .T. })
aInfo2   := {aSizeGrf2[1],aSizeGrf2[2],aSizeGrf2[3],aSizeGrf2[4],3,3}
aPosObj2 := MsObjSize(aInfo2,aObjects2)
DEFINE MSDIALOG oDlgGra FROM 0,0 TO aSizeGrf2[6],aSizeGrf2[5] TITLE cTitulo PIXEL 
@ 005, 005 MSGRAPHIC oMSGraphic SIZE (aPosObj2[1,4]-aPosObj2[1,2]-5),(aPosObj2[1,3]-aPosObj2[1,1]-20) OF oDlgGra
oMSGraphic:SetMargins(2,2,2,2)                      
oMSGraphic:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oMSGraphic:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
If (n800ConsCon == 1) //Quantidade/Faturamento
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	For ni := 1 to Len(oGetFat:aCols)-1
		cDescMes := Upper(Substr(MesExtenso(Val(Substr(oGetFat:aCols[ni,1],5,2))),1,3))+"/"+Substr(oGetFat:aCols[ni,1],3,2)
		If (xTipo == 1)
	  		oMSGraphic:Add(nSerie2,int(oGetFat:aCols[ni,5]),cDescMes,GDV_FATUR)
		Elseif (xTipo == 2)
	  		oMSGraphic:Add(nSerie2,int(oGetFat:aCols[ni,4]),cDescMes,GDV_QUANT)
		Elseif (xTipo == 3)
	  		oMSGraphic:Add(nSerie2,int(oGetFat:aCols[ni,8]),cDescMes,GDV_PRZMED)
		Endif
	Next ni
	If (xTipo == 1)
		oMSGraphic:SetTitle("","Faturamento",GDV_FATUR,A_LEFTJUST,GRP_TITLE)
	Elseif (xTipo == 2)
		oMSGraphic:SetTitle("","Quantidade",GDV_QUANT,A_LEFTJUST,GRP_TITLE)
	Elseif (xTipo == 3)
		oMSGraphic:SetTitle("","Prazo Medio (dias)",GDV_PRZMED,A_LEFTJUST,GRP_TITLE)
	Endif
Else
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	nSerie3 := oMSGraphic:CreateSerie(nCbx)
	For ni := 1 to Len(oGetFat:aCols)-1
		cDescMes := Upper(Substr(MesExtenso(Val(Substr(oGetFat:aCols[ni,1],5,2))),1,3))+"/"+Substr(oGetFat:aCols[ni,1],3,2)
	  	oMSGraphic:Add(nSerie2,int(oGetFat:aCols[ni,3]),cDescMes,iif(xTipo==2,GDV_QUANT,GDV_FATUR))
	  	oMSGraphic:Add(nSerie3,int(oGetFat:aCols[ni,4]),cDescMes,GDV_META)
	Next ni
	If (xTipo == 2)
		oMSGraphic:SetTitle("","Quantidade",GDV_QUANT,A_LEFTJUST,GRP_TITLE)
	Else
		oMSGraphic:SetTitle("","Faturamento",GDV_FATUR,A_LEFTJUST,GRP_TITLE)
	Endif
Endif
oMSGraphic:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,(nCbx==10))
oMSGraphic:cCaption := cTitulo
oMSGraphic:lShowHint := .T.
oMSGraphic:l3D := .T.
oMSGraphic:Refresh()
@ aSizeGrf2[4]-25,008 BUTTON "Fechar"         SIZE 30,10 OF oDlgGra PIXEL ACTION oDlgGra:End()
@ aSizeGrf2[4]-25,048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgGra PIXEL ACTION PmsGrafMail(oMSGraphic,"GDView Faturamento",{"GDView Faturamento",cTitulo},{},1) // E-Mail
@ aSizeGrf2[4]-25,078 BUTTON "Salvar"         SIZE 30,10 OF oDlgGra PIXEL ACTION GrafSavBmp(oMSGraphic)
@ aSizeGrf2[4]-25,108 BUTTON "&3D"            SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:l3D := !oMSGraphic:l3D
@ aSizeGrf2[4]-25,138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:lAxisVisib := !oMSGraphic:lAxisVisib
@ aSizeGrf2[4]-25,168 BUTTON "+"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomIn()
@ aSizeGrf2[4]-25,183 BUTTON "-"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomOut()
If (n800ConsCon == 1) //Quantidade/Faturamento
	If (xTipo == 1)
		@ aSizeGrf2[4]-25,250 SAY "Faturamento" OF oDlgGra PIXEL COLOR GDV_FATUR SIZE 50,10 FONT oBold
	Elseif (xTipo == 2)
		@ aSizeGrf2[4]-25,250 SAY "Quantidade" OF oDlgGra PIXEL COLOR GDV_QUANT SIZE 50,10 FONT oBold
	Elseif (xTipo == 2)
		@ aSizeGrf2[4]-25,250 SAY "Prazo Medio (dias)" OF oDlgGra PIXEL COLOR GDV_PRZMED SIZE 50,10 FONT oBold
	Endif
Else
	@ aSizeGrf2[4]-25,310 SAY iif(xTipo==2,"Quantidade","Faturamento") OF oDlgGra PIXEL COLOR iif(xTipo==2,GDV_QUANT,GDV_FATUR) SIZE 50,10 FONT oBold
	@ aSizeGrf2[4]-25,370 SAY "Meta" OF oDlgGra PIXEL COLOR GDV_META SIZE 50,10
Endif
ACTIVATE MSDIALOG oDlgGra CENTER 

Return

Static Function GB800GrafDrill(xHeader,xCols)
***************************************
LOCAL oDlgGra, oMSGraphic, aInfo2, aPosObj2, aSerie2 := {}, aSizeGrf2, aObjects2
LOCAL cTitulo  := "", cTitle1 := "", cTitle2 := "", cTitulo := "Grafico Gerencial Faturamento"
LOCAL nOpcb, nCbx := 1, nSerie2, nSerie3, nSerie4, nCor := 1, ni, nPos1, nPos2

//Busco tipo do grafico
///////////////////////
nCbx := GB800TpGraf()

//Monto Grafico
///////////////
aObjects2 := {}
aSizeGrf2 := MsAdvSize(,.F.,400)
AAdd(aObjects2,{  0, 400, .T., .T. })
aInfo2   := {aSizeGrf2[1],aSizeGrf2[2],aSizeGrf2[3],aSizeGrf2[4],3,3}
aPosObj2 := MsObjSize(aInfo2,aObjects2)
DEFINE MSDIALOG oDlgGra FROM 0,0 TO aSizeGrf2[6],aSizeGrf2[5] TITLE cTitulo PIXEL 
@ 005, 005 MSGRAPHIC oMSGraphic SIZE (aPosObj2[1,4]-aPosObj2[1,2]-5),(aPosObj2[1,3]-aPosObj2[1,1]-20) OF oDlgGra
oMSGraphic:SetMargins(2,2,2,2)
oMSGraphic:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oMSGraphic:SetTitle(xHeader[1,1],"",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
If (n800ConsCon == 1) //Quantidade/Faturamento
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	nSerie3 := oMSGraphic:CreateSerie(nCbx)
	nPos1 := GDFieldPos("M_QUANT",xHeader)
	nPos2 := GDFieldPos("M_FATUR",xHeader)
	For ni := 1 to Len(xCols)
		If GB800VerifCab(@xHeader,@xCols,ni)
		  	oMSGraphic:Add(nSerie2,int(xCols[ni,nPos1]),xCols[ni,1],GDV_QUANT)
		  	oMSGraphic:Add(nSerie3,int(xCols[ni,nPos2]),xCols[ni,1],GDV_FATUR)
		Endif
	Next ni
	oMSGraphic:SetTitle("","Fatur/Quant",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Elseif (n800ConsCon == 2) //Quantidade/Meta
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	nSerie3 := oMSGraphic:CreateSerie(nCbx)
	nPos1 := GDFieldPos("M_QUANT",xHeader)
	nPos2 := GDFieldPos("M_META",xHeader)
	For ni := 1 to Len(xCols)
		If GB800VerifCab(@xHeader,@xCols,ni)
		  	oMSGraphic:Add(nSerie2,int(xCols[ni,nPos1]),xCols[ni,1],GDV_QUANT)
		  	oMSGraphic:Add(nSerie3,int(xCols[ni,nPos2]),xCols[ni,1],GDV_META)
		Endif
	Next ni
	oMSGraphic:SetTitle("","Quant/Meta",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Elseif (n800ConsCon == 3) //Faturamento/Meta
	nSerie2 := oMSGraphic:CreateSerie(nCbx)
	nSerie3 := oMSGraphic:CreateSerie(nCbx)
	nPos1 := GDFieldPos("M_FATUR",xHeader)
	nPos2 := GDFieldPos("M_META",xHeader)
	For ni := 1 to Len(xCols)
		If GB800VerifCab(@xHeader,@xCols,ni)
		  	oMSGraphic:Add(nSerie2,int(xCols[ni,nPos1]),xCols[ni,1],GDV_FATUR)
		  	oMSGraphic:Add(nSerie3,int(xCols[ni,nPos2]),xCols[ni,1],GDV_META)
		Endif
	Next ni
	oMSGraphic:SetTitle("","Fatur/Meta",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Endif
oMSGraphic:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,(nCbx==10))
oMSGraphic:cCaption := cTitulo
oMSGraphic:lShowHint := .T.
oMSGraphic:l3D := .T.
oMSGraphic:Refresh()
@ aSizeGrf2[4]-25,008 BUTTON "Fechar"         SIZE 30,10 OF oDlgGra PIXEL ACTION oDlgGra:End()
@ aSizeGrf2[4]-25,048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgGra PIXEL ACTION PmsGrafMail(oMSGraphic,"GDView Faturamento",{"GDView Faturamento",cTitulo},{},1) // E-Mail
@ aSizeGrf2[4]-25,078 BUTTON "Salvar"         SIZE 30,10 OF oDlgGra PIXEL ACTION GrafSavBmp(oMSGraphic)
@ aSizeGrf2[4]-25,108 BUTTON "&3D"            SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:l3D := !oMSGraphic:l3D
@ aSizeGrf2[4]-25,138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:lAxisVisib := !oMSGraphic:lAxisVisib
@ aSizeGrf2[4]-25,168 BUTTON "+"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomIn()
@ aSizeGrf2[4]-25,183 BUTTON "-"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomOut()
If (n800ConsCon == 1) //Quantidade/Faturamento
	@ aSizeGrf2[4]-25,250 SAY "Quantidade" OF oDlgGra PIXEL COLOR GDV_QUANT SIZE 50,10 FONT oBold
	@ aSizeGrf2[4]-25,350 SAY "Faturamento" OF oDlgGra PIXEL COLOR GDV_FATUR SIZE 50,10 FONT oBold
Elseif (n800ConsCon == 2) //Quantidade/Meta
	@ aSizeGrf2[4]-25,250 SAY "Quantidade" OF oDlgGra PIXEL COLOR GDV_QUANT SIZE 50,10 FONT oBold
	@ aSizeGrf2[4]-25,350 SAY "Meta" OF oDlgGra PIXEL COLOR GDV_META SIZE 50,10 FONT oBold
Elseif (n800ConsCon == 3) //Faturamento/Meta
	@ aSizeGrf2[4]-25,250 SAY "Faturamento" OF oDlgGra PIXEL COLOR GDV_FATUR SIZE 50,10 FONT oBold
	@ aSizeGrf2[4]-25,350 SAY "Meta" OF oDlgGra PIXEL COLOR GDV_META SIZE 50,10 FONT oBold
Endif
ACTIVATE MSDIALOG oDlgGra CENTER 

Return

Static Function GB800GrafCom(xTipo,xCols1,xCols2)
*******************************************
LOCAL oDlgGra, oMSGraphic, aInfo2, aPosObj2, aSerie2 := {}, aSizeGrf2, aObjects2
LOCAL cTitulo  := "", cTitle1 := "", cTitle2 := "", cTitulo := "Grafico Gerencial Faturamento"
LOCAL nOpcb, nCbx := 1, nSerie2, nSerie3, nSerie4, nCor := 1, ni, nTam

//Busco tipo do grafico
///////////////////////
nCbx := GB800TpGraf()

//Monto Grafico
///////////////
aObjects2 := {}
aSizeGrf2 := MsAdvSize(,.F.,400)
AAdd(aObjects2,{  0, 400, .T., .T. })
aInfo2 := {aSizeGrf2[1],aSizeGrf2[2],aSizeGrf2[3],aSizeGrf2[4],3,3}
aPosObj2 := MsObjSize(aInfo2,aObjects2)
DEFINE MSDIALOG oDlgGra FROM 0,0 TO aSizeGrf2[6],aSizeGrf2[5] TITLE cTitulo PIXEL 
@ 005, 005 MSGRAPHIC oMSGraphic SIZE (aPosObj2[1,4]-aPosObj2[1,2]-5),(aPosObj2[1,3]-aPosObj2[1,1]-20) OF oDlgGra
oMSGraphic:SetMargins(2,2,2,2)                      
oMSGraphic:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
cTitulo1 := "PERIODO 1 ["+dtoc(dCOM1DtIni)+" "+dtoc(dCOM1DtFim)+"]"+Space(5)+"PERIODO 2 ["+dtoc(dCOM2DtIni)+" "+dtoc(dCOM2DtFim)+"]"
//oMSGraphic:SetTitle(cTitulo1,"",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
If (n800ConsCon == 1) //Quantidade/Faturamento
	nPosQtd := 2
	nPosFat := 3
	nPosPar := 4
Elseif (n800ConsCon == 2) //Quantidade/Meta
	nPosQtd := 2
	nPosPar := 3
Elseif (n800ConsCon == 3) //Faturamento/Meta
	nPosFat := 2
	nPosPar := 3
Endif
nSerie2 := oMSGraphic:CreateSerie(nCbx,,iif(xTipo==3,2,0))
nSerie3 := oMSGraphic:CreateSerie(nCbx,,iif(xTipo==3,2,0))
nTam := Max(Len(xCols1),Len(xCols2))
For ni := 1 to nTam
	If (ni <= (Len(xCols1)-1))
		If (xTipo == 1)
	  		nVal := xCols1[ni,nPosFat]
		Elseif (xTipo == 2)
	  		nVal := xCols1[ni,nPosQtd]
		Elseif (xTipo == 3)
	  		nVal := xCols1[ni,nPosPar]
		Endif
		cDescMes := Upper(Substr(MesExtenso(Val(Substr(xCols1[ni,1],5,2))),1,3))
	  	oMSGraphic:Add(nSerie2,nVal,cDescMes,GDV_FATUR)
	Endif
	If (ni <= (Len(xCols2)-1))
		If (xTipo == 1)
	  		nVal := xCols2[ni,nPosFat]
		Elseif (xTipo == 2)
	  		nVal := xCols2[ni,nPosQtd]
		Elseif (xTipo == 3)
	  		nVal := xCols2[ni,nPosPar]
		Endif
		cDescMes := Upper(Substr(MesExtenso(Val(Substr(xCols2[ni,1],5,2))),1,3))
	  	oMSGraphic:Add(nSerie3,nVal,cDescMes,GDV_QUANT)
	Endif
Next ni
If (xTipo == 1)
	oMSGraphic:SetTitle("","Faturamento",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Elseif (xTipo == 2)
	oMSGraphic:SetTitle("","Quantidade",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Elseif (xTipo == 3)
	oMSGraphic:SetTitle("","% Participacao",CLR_BLUE,A_LEFTJUST,GRP_TITLE)
Endif
oMSGraphic:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,(nCbx==10))
oMSGraphic:cCaption := cTitulo
oMSGraphic:lShowHint := .T.
oMSGraphic:l3D := .T.
oMSGraphic:Refresh()
@ aSizeGrf2[4]-25,005 BUTTON "Fechar"         SIZE 30,10 OF oDlgGra PIXEL ACTION oDlgGra:End()
@ aSizeGrf2[4]-25,048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgGra PIXEL ACTION PmsGrafMail(oMSGraphic,"GDView Faturamento",{"GDView Faturamento",cTitulo},{},1) // E-Mail
@ aSizeGrf2[4]-25,078 BUTTON "Salvar"         SIZE 30,10 OF oDlgGra PIXEL ACTION GrafSavBmp(oMSGraphic)
@ aSizeGrf2[4]-25,108 BUTTON "&3D"            SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:l3D := !oMSGraphic:l3D
@ aSizeGrf2[4]-25,138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgGra PIXEL ACTION oMSGraphic:lAxisVisib := !oMSGraphic:lAxisVisib
@ aSizeGrf2[4]-25,168 BUTTON "+"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomIn()
@ aSizeGrf2[4]-25,183 BUTTON "-"              SIZE 15,10 OF oDlgGra PIXEL ACTION oMSGraphic:ZoomOut()
@ aSizeGrf2[4]-25,250 SAY "Periodo 1 ["+dtoc(dCOM1DtIni)+" "+dtoc(dCOM1DtFim)+"]" OF oDlgGra PIXEL COLOR GDV_FATUR SIZE 100,10 FONT oBold
@ aSizeGrf2[4]-25,370 SAY "Periodo 2 ["+dtoc(dCOM2DtIni)+" "+dtoc(dCOM2DtFim)+"]" OF oDlgGra PIXEL COLOR GDV_QUANT SIZE 100,10 FONT oBold
ACTIVATE MSDIALOG oDlgGra CENTER 

Return
      
Static Function GB800DoGraph(aHeader,aCols)
*************************************
LOCAL ni := 0, aSeries := {}
oFWChart := FWChartFactory():New()
If (n800GrafMes == 2) //Pizza
	oFWChart := oFWChart:GetInstance(PIECHART)
Elseif (n800GrafMes == 3) //Linha
	oFWChart := oFWChart:GetInstance(LINECHART)
Else //Barras
	oFWChart := oFWChart:GetInstance(BARCHART)
Endif
oFWChart:INIT(oScroll,.T.)
oFWChart:setTitle(cCadastro,CONTROL_ALIGN_CENTER)
oFWChart:setLegend(CONTROL_ALIGN_LEFT)
oFWChart:setMask("R$ *@*")
oFWChart:setPicture(PesqPict("SD2","D2_TOTAL"))
oFWChart:aSeries := {}
If (n800ConsCon == 1) //Quantidade/Faturamento
	For ni := 1 to Len(oGetFat:aCols)-1
		If (n800GrafMes == 1).or.(n800GrafMes == 2)
			oFWChart:addSerie(oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,5]))
		Elseif (n800GrafMes == 3)
			aadd(aSeries,{oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,5])})	
		Endif
	Next ni  
	If (n800GrafMes == 3)
		oFWChart:addSerie("Faturamento",aSeries)
	Endif
Elseif (n800ConsCon == 2) //Quantidade/Meta
	For ni := 1 to Len(oGetFat:aCols)-1
		If (n800GrafMes == 1).or.(n800GrafMes == 2)
			oFWChart:addSerie(oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,4]))
		Elseif (n800GrafMes == 3)
			aadd(aSeries,{oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,4])})	
		Endif
	Next ni  
	If (n800GrafMes == 3)
		oFWChart:addSerie("Quantidade",aSeries)
	Endif
Elseif (n800ConsCon == 3) //Faturamento/Meta
	For ni := 1 to Len(oGetFat:aCols)-1
		If (n800GrafMes == 1).or.(n800GrafMes == 2)
			oFWChart:addSerie(oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,5]))
		Elseif (n800GrafMes == 3)
			aadd(aSeries,{oGetFat:aCols[ni,1],int(oGetFat:aCols[ni,5])})	
		Endif
	Next ni  
	If (n800GrafMes == 3)
		oFWChart:addSerie("Faturamento",aSeries)
	Endif
Endif
oFWChart:Build()
Return

Static Function GB800Consulta(xTipo,xCols,xAt)
****************************************
LOCAL oDlgCon, oBold3, oGetCon, oMSGraphic, oClasseA, oClasseB, oClasseC, oMenu
LOCAL aInfo3, aPosObj3, aSizeGrf3, aObjects3, bBlock, nCol3 := 0, nPos3 := 0, nMes4
LOCAL cTitulo := "GDView Faturamento - Drill-Down", cChave := "", cDescri := ""
LOCAL nClasseA := 0, nClasseB := 0, nClasseC := 0, cSimb1 := GetMV("MV_SIMB1")
                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold3 NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChave := xCols[xAt,1]
	If (Len(xCols[xAt]) >= 2).and.(ValType(xCols[xAt,2]) == "C")
		cDescri := xCols[xAt,2]
	Endif
Endif    
If (Left(cChave,5) $ "TOTAL/OUTRO" .and. Len(a800Filtro) > 1)
	MsgInfo("> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro visao de acordo com o tipo                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos3 := aScan(a800Consul, {|x| x[1] == xTipo })
If (nPos3 > 0)
	a800Consul[nPos3,3] := .F.
Endif                                                                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB800DrillDown(@aHeader,@aCols,xTipo,cChave,cDescri,@nClasseA,@nClasseB,@nClasseC)},cCadastro)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Menu para ordenar colunas                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MENU oMenu POPUP             
For nx := 1 to Len(aHeader)                                         
	MENUITEM "Ordenar por "+Alltrim(aHeader[nx,1]) ACTION {||.T.}
Next nx
ENDMENU
For nx := 1 to Len(oMenu:aItems)
	oMenu:aItems[nx]:bAction := &("{|oMenuItem|GB800Ordena("+Alltrim(Str(nx))+",oGetCon)}")
Next nx

//Monto Grafico
///////////////
aObjects3 := {}
aSizeGrf3 := MsAdvSize(,.F.,400)
AAdd(aObjects3,{  0,  38, .T., .F. })
AAdd(aObjects3,{  0,  15, .T., .F. })
AAdd(aObjects3,{  0, 200, .T., .T. })
AAdd(aObjects3,{  0,  25, .T., .F. })
aInfo3   := {aSizeGrf3[1],aSizeGrf3[2],aSizeGrf3[3],aSizeGrf3[4],3,3}
aPosObj3 := MsObjSize(aInfo3,aObjects3)
DEFINE MSDIALOG oDlgCon FROM aSizeGrf3[7],0 TO aSizeGrf3[6],aSizeGrf3[5] TITLE cTitulo PIXEL
@ aPosObj3[1,1],aPosObj3[1,2] SAY o800Ano3 VAR "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2) OF oDlgCon PIXEL SIZE 180,9 COLOR CLR_GREEN FONT oBold3
@ aPosObj3[1,1],aPosObj3[1,2]+150 SAY o800Filtro VAR c800Filtro OF oDlgCon PIXEL SIZE 400,9 COLOR CLR_GREEN FONT oBold3
@ aPosObj3[1,1]+10,aPosObj3[1,2]+150 SAY o800DesFil VAR c800DesFil OF oDlgCon PIXEL SIZE 400,30 COLOR CLR_GREEN FONT oFiltro
@ aPosObj3[1,1]+34,aPosObj3[1,2] TO aPosObj3[1,1]+35,(aPosObj3[1,4]-aPosObj3[1,2]) LABEL "" OF oDlgCon PIXEL
If (n800ConsCon == 1).or.(n800ConsCon == 3)
	@ aPosObj3[2,1],010 SAY oClasseA VAR "CLASSE A: "+cSimb1+" "+Transform(nClasseA,"@E 999,999,999.99")+" ["+Alltrim(Str(n800AClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	@ aPosObj3[2,1],100 SAY oClasseB VAR "CLASSE B: "+cSimb1+" "+Transform(nClasseB,"@E 999,999,999.99")+" ["+Alltrim(Str(n800BClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	@ aPosObj3[2,1],190 SAY oClasseC VAR "CLASSE C: "+cSimb1+" "+Transform(nClasseC,"@E 999,999,999.99")+" ["+Alltrim(Str(n800CClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	If (n800ConsCon == 1)
		oVarCre := u_GDVButton(oDlgCon,"oVarCre",iif(l800OrdCres,"Crescente","Decrescen"),aPosObj3[2,4]-370,aPosObj3[2,1],40,,{||(l800OrdCres:=!l800OrdCres),(oVarCre:cCaption:=iif(l800OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
		oVarOrd := u_GDVButton(oDlgCon,"oVarOrd","Ordenar"     ,aPosObj3[2,4]-330,aPosObj3[2,1],40,,{||oMenu:Activate((oDlgCon:nClientWidth-210),(aPosObj3[2,1]+35),oDlgCon)})
		oVarPes := u_GDVButton(oDlgCon,"oVarPes","Var.Peso"    ,aPosObj3[2,4]-290,aPosObj3[2,1],40,,{||GB800VarPer(6,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarQua := u_GDVButton(oDlgCon,"oVarPer","Var.Quant."  ,aPosObj3[2,4]-250,aPosObj3[2,1],40,,{||GB800VarPer(1,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarPrc := u_GDVButton(oDlgCon,"oVarPrc","Var.Preco"   ,aPosObj3[2,4]-210,aPosObj3[2,1],40,,{||GB800VarPer(5,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarFat := u_GDVButton(oDlgCon,"oVarFat","Var.Fatur."  ,aPosObj3[2,4]-170,aPosObj3[2,1],40,,{||GB800VarPer(2,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarPar := u_GDVButton(oDlgCon,"oVarPar","Var.Partic." ,aPosObj3[2,4]-130,aPosObj3[2,1],40,,{||GB800VarPer(3,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oPrcMed := u_GDVButton(oDlgCon,"oPrcMed","Prazo Medio" ,aPosObj3[2,4]-090,aPosObj3[2,1],40,,{||GB800VarPer(4,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarCus := u_GDVButton(oDlgCon,"oVarCus","An.Periodo"  ,aPosObj3[2,4]-050,aPosObj3[2,1],40,,{||GB800VarAna(oGetCon:aCols,oGetCon:oBrowse:nAt,xTipo)})
	Else
		oVarCre := u_GDVButton(oDlgCon,"oVarCre",iif(l800OrdCres ,"Crescente","Decrescen"),aPosObj3[2,4]-250,aPosObj3[2,1],40,,{||(l800OrdCres:=!l800OrdCres),(oVarCre:cCaption:=iif(l800OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
		oVarOrd := u_GDVButton(oDlgCon,"oVarOrd","Ordenar"       ,aPosObj3[2,4]-210,aPosObj3[2,1],40,,{||oMenu:Activate((oDlgCon:nClientWidth-210),(aPosObj3[2,1]+35),oDlgCon)})
		oVarPes := u_GDVButton(oDlgCon,"oVarPes","Var.Peso"      ,aPosObj3[2,4]-170,aPosObj3[2,1],40,,{||GB800VarPer(6,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarFat := u_GDVButton(oDlgCon,"oVarFat","Var.Fatur."    ,aPosObj3[2,4]-130,aPosObj3[2,1],40,,{||GB800VarPer(2,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarPar := u_GDVButton(oDlgCon,"oVarPar","Var.Partic"    ,aPosObj3[2,4]-090,aPosObj3[2,1],40,,{||GB800VarPer(3,oGetCon:aCols,oGetCon:oBrowse:nAt)})
		oVarCus := u_GDVButton(oDlgCon,"oVarCus","An.Periodo"    ,aPosObj3[2,4]-050,aPosObj3[2,1],40,,{||GB800VarAna(oGetCon:aCols,oGetCon:oBrowse:nAt,xTipo)})
	Endif
Elseif (n800ConsCon == 2) //Quantidade/Meta
	@ aPosObj3[2,1],010 SAY oClasseA VAR "CLASSE A: "+Transform(nClasseA,"@E 999,999,999.999")+" ["+Alltrim(Str(n800AClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	@ aPosObj3[2,1],100 SAY oClasseB VAR "CLASSE B: "+Transform(nClasseB,"@E 999,999,999.999")+" ["+Alltrim(Str(n800BClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	@ aPosObj3[2,1],190 SAY oClasseC VAR "CLASSE C: "+Transform(nClasseC,"@E 999,999,999.999")+" ["+Alltrim(Str(n800CClasse))+"%]" OF oDlgCon PIXEL SIZE 245,9 COLOR CLR_BLUE
	oVarCre := u_GDVButton(oDlgCon,"oVarCre",iif(l800OrdCres,"Crescente","Decrescen"),aPosObj3[2,4]-250,aPosObj3[2,1],40,,{||(l800OrdCres:=!l800OrdCres),(oVarCre:cCaption:=iif(l800OrdCres,"Crescente","Decrescen")),(oVarCre:Refresh())})
	oVarOrd := u_GDVButton(oDlgCon,"oVarOrd","Ordenar"         ,aPosObj3[2,4]-210,aPosObj3[2,1],40,,{||oMenu:Activate((oDlgCon:nClientWidth-210),(aPosObj3[2,1]+35),oDlgCon)})
	oVarPes := u_GDVButton(oDlgCon,"oVarPes","Var.Peso"        ,aPosObj3[2,4]-170,aPosObj3[2,1],40,,{||GB800VarPer(6,oGetCon:aCols,oGetCon:oBrowse:nAt)})
	oVarQua := u_GDVButton(oDlgCon,"oVarQua","Var.Quant."      ,aPosObj3[2,4]-130,aPosObj3[2,1],40,,{||GB800VarPer(1,oGetCon:aCols,oGetCon:oBrowse:nAt)})
	oVarPar := u_GDVButton(oDlgCon,"oVarPar","Var.Partic"      ,aPosObj3[2,4]-090,aPosObj3[2,1],40,,{||GB800VarPer(3,oGetCon:aCols,oGetCon:oBrowse:nAt)})
	oVarCus := u_GDVButton(oDlgCon,"oVarCus","An.Periodo"      ,aPosObj3[2,4]-050,aPosObj3[2,1],40,,{||GB800VarAna(oGetCon:aCols,oGetCon:oBrowse:nAt,xTipo)})
Endif
                                                           
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetCon := MsNewGetDados():New(aPosObj3[3,1],aPosObj3[3,2],aPosObj3[3,3],aPosObj3[3,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgCon,aHeader,aCols)
oGetCon:oBrowse:bLDblClick := { || GB800Coluna(oGetCon,oGetCon:oBrowse:nColPos,oGetCon:oBrowse:nAt,xTipo) }
oGetCon:oBrowse:lUseDefaultColors := .F.
oGetCon:oBrowse:SetBlkBackColor({||GB800CorCla(oGetCon:aHeader,oGetCon:aCols,oGetCon:nAt)})

nCol3 := 10 ; nLin3 := aPosObj3[4,1]
For ni := 1 to Len(a800Consul)
	If (a800Consul[ni,3])
		bBlock := &("{||GB800Consulta('"+a800Consul[ni,1]+"',oGetCon:aCols,oGetCon:oBrowse:nAt)}")
		oButton := u_GDVButton(oDlgCon,"oButCon"+Alltrim(Str(ni,1)),a800Consul[ni,2],nCol3,nLin3,40,,bBlock)
		nCol3 += 40
		If (nCol3 > ((aSizeAut[5]/3)-50))
			nCol3 := 10
			nLin3 += 12
		Endif
	Endif
Next ni
oExce   := u_GDVButton(oDlgCon,"oButExc","Excel"   ,aPosObj3[4,4]-170,aPosObj3[4,1],40,,{||GB800ExpExcel(@oGetCon:aHeader,@oGetCon:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oGrafico:= u_GDVButton(oDlgCon,"oButGrf","Grafico" ,aPosObj3[4,4]-130,aPosObj3[4,1],40,,{||GB800GrafDrill(@oGetCon:aHeader,@oGetCon:aCols)})
oImprim := u_GDVButton(oDlgCon,"oButImp","Imprimir",aPosObj3[4,4]-090,aPosObj3[4,1],40,,{||GB800Imprime(@oGetCon:aHeader,@oGetCon:aCols,@oClasseA:cCaption,@oClasseB:cCaption,@oClasseC:cCaption)})
oFechar := u_GDVButton(oDlgCon,"oButFec","Fechar"  ,aPosObj3[4,4]-050,aPosObj3[4,1],40,,{||oDlgCon:End()})

ACTIVATE MSDIALOG oDlgCon CENTER 
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Configuro consulta de acordo com o tipo                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos3 := aScan(a800Consul, {|x| x[1] == xTipo })
If (nPos3 > 0)
	a800Consul[nPos3,3] := .T.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retiro ultimo filtro aplicado                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPos3 := Len(a800Filtro)
aDel(a800Filtro,nPos3)
aSize(a800Filtro,Len(a800Filtro)-1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c800Filtro := "" ; c800DesFil := "" ; nMes4 := 13
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0)
	nMes4 := oGetFat:oBrowse:nAt                  
	If (nMes4 > 0).and.(nMes4 <= 13)
		c800Filtro := iif(nMes4==13,"MES [TODOS] > ","MES ["+Upper(oGetFat:aCols[nMes4,1])+"] > ")
	Endif
Endif	
For ni := 1 to Len(a800Filtro)
	If (ni == Len(a800Filtro))
		c800Filtro += a800Filtro[ni,1]
		c800DesFil += a800Filtro[ni,1]
	Else
		c800Filtro += a800Filtro[ni,1]+" ["+Alltrim(a800Filtro[ni+1,3])+"] > "
		c800DesFil += a800Filtro[ni,1]+" ["+Alltrim(a800Filtro[ni+1,7])+"] > "
	Endif
Next ni

Return

Static Function GB800DrillDown(aHeader,aCols,xTipo,xValor,xDescri,nClasseA,nClasseB,nClasseC)
************************************************************************************
LOCAL ni, nPeso := 0, nQuant := 0, nTotal := 0, nMeta := 0, cChave4, aDados := {}
LOCAL nDados4 := 0, nMeta4 := 0, nReal4 := 0, nPart4 := 0, nPartAcm4 := 0, nPos4
LOCAL nTotalA  := 0, nTotalB  := 0, nTotalC  := 0, nTotOut := 0, nMetOut := 0, nPedid := 0
LOCAL cClasse4, nQtdOut := 0, nDescon := 0, nDesOut := 0, lImp, cPeri4, nPedOut := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Filtro para consulta                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo == "CLI") //Visao por Cliente
	If (n800ConsLoj == 1) //Sim
		aadd(a800Filtro,{"CLIENTE"  ,"D2.D2_CLIENTE+D2.D2_LOJA",xValor,"SD2","D1.D1_FORNECE+D1.D1_LOJA","C6.C6_CLI+C6.C6_LOJA",xDescri})
	Elseif (n800ConsLoj == 2) //Nao
		aadd(a800Filtro,{"CLIENTE"  ,"D2.D2_CLIENTE",xValor,"SD2","D1.D1_FORNECE","C6.C6_CLI",xDescri})
	Endif
Elseif (xTipo == "REG") //Visao por Regiao
	aadd(a800Filtro,{"REGIAO"   ,"A1.A1_REGIAO",xValor,"SA1","A1.A1_REGIAO","A1.A1_REGIAO",xDescri})
Elseif (xTipo == "MUN") //Visao por Municipio
	aadd(a800Filtro,{"MUNICIPIO","A1.A1_MUN",xValor,"SA1","A1.A1_MUN","A1.A1_MUN",xDescri})
Elseif (xTipo == "PRO") //Visao por Produto
	aadd(a800Filtro,{"PRODUTO"  ,"D2.D2_COD",xValor,"SD2","D1.D1_COD","C6.C6_PRODUTO",xDescri})
Elseif (xTipo == "GRU") //Visao por Grupo
	aadd(a800Filtro,{"GRUPO"    ,"D2.D2_GRUPO",xValor,"SD2","D1.D1_GRUPO","B1.B1_GRUPO",xDescri})
Elseif (xTipo == "MER") //Visao por Mercado
	aadd(a800Filtro,{"MERCADO"  ,"A1.A1_GRPVEN",xValor,"SA1","A1.A1_GRPVEN","A1.A1_GRPVEN",xDescri})
Elseif (xTipo == "EST") //Visao por Estado
	aadd(a800Filtro,{"ESTADO"   ,"A1.A1_EST",xValor,"SA1","A1.A1_EST","A1.A1_EST",xDescri})
Elseif (xTipo == "FIL") //Visao por Filial
	aadd(a800Filtro,{"FILIAL"   ,"D2.D2_FILIAL",xValor,"SD2","D1.D1_FILIAL","C6.C6_FILIAL",xDescri})
Elseif (xTipo == "PAI") //Visao por Pais
	aadd(a800Filtro,{"PAIS"     ,"A1.A1_PAIS",xValor,"SA1","A1.A1_PAIS","A1.A1_PAIS",xDescri})
Elseif (xTipo == "GRE") //Visao por Representante
	aadd(a800Filtro,{"GRP.REPRESENTANTE" ,"A3.A3_GRPREP",xValor,"SA3","","A3_GRPREP",xDescri})
Elseif (xTipo == "VEN") //Visao por Vendedor
	aadd(a800Filtro,{"REPRESENTANTE" ,"F2.F2_VEND1",xValor,"SF2","","C5.C5_VEND1",xDescri})
Elseif (xTipo == "SUP") //Visao por Supervisor
	aadd(a800Filtro,{"SUPERVISOR" ,"A3.A3_SUPER",xValor,"SA3","","A3.A3_SUPER",xDescri})
Elseif (xTipo == "TIP") //Visao por Tipo Produto
	aadd(a800Filtro,{"TIPO"     ,"D2.D2_TP",xValor,"SD2","D1.D1_TP","B1.B1_TIPO",xDescri})
Elseif (xTipo == "SEG") //Visao por Segmento
	aadd(a800Filtro,{"SEGMENTO" ,"A1.A1_SATIV1",xValor,"SA1","A1.A1_SATIV1","A1.A1_SATIV1",xDescri})
Elseif (xTipo == "CFO") //Visao por CFOP
	aadd(a800Filtro,{"CFOP"     ,"D2.D2_CF",xValor,"SD2","D1.D1_CF","C6.C6_CF",xDescri})
Elseif (xTipo == "PAG") //Visao por Condicao de Pagamento
	aadd(a800Filtro,{"COND.PAGTO","F2.F2_COND",xValor,"SF2","F1.F1_COND","C5.C5_CONDPAG",xDescri})
Elseif (xTipo == "TPF") //Visao por Tipo de Frete
	aadd(a800Filtro,{"TIPO FRETE","F2.F2_TPFRETE",xValor,"SF2","F1.F1_TPFRETE","C5.C5_TPFRETE",xDescri})
Elseif (xTipo == "TRA") //Visao por Transportadora
	aadd(a800Filtro,{"TRANSPORTADORA","F2.F2_TRANSP",xValor,"SF2","F1.F1_TRANSP","C5.C5_TRANSP",xDescri})
Elseif (xTipo == "EMI") //Visao por Emissao
	aadd(a800Filtro,{"EMISSAO"  ,"D2.D2_EMISSAO",xValor,"SD1","D1.D1_DTDIGIT","C6.C6_ENTREG",xDescri})
Elseif (xTipo == "SAI") //Visao por Data Saida
	aadd(a800Filtro,{"DATA SAIDA","F2.F2_DTSAIDA",xValor,"SF2","","",xDescri})
Elseif (xTipo == "NOT") //Visao por Nota
	aadd(a800Filtro,{"NOTA"     ,"D2.D2_DOC+D2.D2_SERIE",xValor,"SD1","D1.D1_DOC+D1.D1_SERIE","C6.C6_NUM",xDescri})
Endif                
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Periodo para pesquisa                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPeri4 := "TODOS"
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0)
	cPeri4 := oGetFat:aCols[oGetFat:oBrowse:nAt,1]
Endif	                        

dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !MEMP->(Eof())
                            
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+" > Montando Drill-Down...")

	If !IsMark("M_OK",c800Marca,lInverte)
		dbSelectArea("MEMP")
		MEMP->(dbSkip())
	   Loop
	Endif  
	
	//Monto query para buscar dados de faturamento ano base
	///////////////////////////////////////////////////////
	nPos4  := Len(a800Filtro)
	If (n800ConsCli == 1) //Todos
		cQuery := "SELECT "+a800Filtro[nPos4,2]+" M_QUEBRA, "
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery := "SELECT D2.D2_CLIENTE M_CLIENTE,D2.D2_LOJA M_LOJA,D2.D2_EMISSAO M_EMISSAO,"+a800Filtro[nPos4,2]+" M_QUEBRA, "
	Endif
	cQuery += "COUNT(DISTINCT D2_PEDIDO) M_PEDID,SUM(D2.D2_QUANT*B1.B1_PESO) M_PESO,SUM(D2.D2_QUANT) M_QUANT,SUM(D2.D2_DESCON) M_VLDSC,"
	If (n800ConsIPI == 1) //Sim 
		cQuery += "SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6) M_TOTAL "
	Elseif (n800ConsIPI == 2) //Nao
		cQuery += "SUM(D2.D2_VALBRUT) M_TOTAL "
	Endif
	cQuery += "FROM "+GB800RetArq("SD2",MEMP->M_codemp)+" D2 "
	cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D2.D2_COD = B1.B1_COD) "
	cQuery += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
	cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
		cQuery += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D2.D2_CLIENTE = A1.A1_COD AND D2.D2_LOJA = A1.A1_LOJA) "
	Endif
	If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
		cQuery += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
	Endif
	cQuery += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+GB800RetFil("SD2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
		cQuery += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
		cQuery += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	cQuery += "AND D2.D2_TIPO NOT IN ('B','D') "
	If (Left(cPeri4,5) != "TOTAL")
		cQuery += "AND D2.D2_EMISSAO BETWEEN '"+Left(cPeri4,6)+"' AND '"+Left(cPeri4,6)+"ZZ' "
	Endif
	cQuery += "AND D2.D2_EMISSAO BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
	If (n800ConsFin == 1)
		cQuery += "AND F4.F4_DUPLIC = 'S' "
	Elseif (n800ConsFin == 2)
		cQuery += "AND F4.F4_DUPLIC = 'N' "
	Endif
	If (n800ConsEst == 1)
		cQuery += "AND F4.F4_ESTOQUE = 'S' "
	Elseif (n800ConsEst == 2)
		cQuery += "AND F4.F4_ESTOQUE = 'N' "
	Endif
	If !Empty(d800DtSdDe)
		cQuery += "AND F2.F2_DTSAIDA >= '"+dtos(d800DtSdDe)+"' "
	Endif
	If !Empty(d800DtSdAte)
		cQuery += "AND F2.F2_DTSAIDA <= '"+dtos(d800DtSdAte)+"' "
	Endif
	If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery += "AND F2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery += "AND F2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	If !Empty(c800BrCfFat)
		cQuery += "AND D2.D2_CF IN ("+c800BrCfFat+") "
	Endif
	If !Empty(c800BrCfNFat)
		cQuery += "AND D2.D2_CF NOT IN ("+c800BrCfNFat+") "
	Endif
	If !Empty(c800BrTsFat)
		cQuery += "AND D2.D2_TES IN ("+c800BrTsFat+") "
	Endif
	If !Empty(c800BrTsNFat)
		cQuery += "AND D2.D2_TES NOT IN ("+c800BrTsNFat+") "
	Endif
	For ni := 1 to Len(a800Filtro)-1
		cQuery += "AND "+a800Filtro[ni,2]+" = '"+a800Filtro[ni+1,3]+"' "
	Next ni
	If (n800ConsCli == 1) //Todos
		cQuery += "GROUP BY "+a800Filtro[nPos4,2]+" "
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery += "GROUP BY D2.D2_CLIENTE,D2.D2_LOJA,D2.D2_EMISSAO,"+a800Filtro[nPos4,2]+" "
	Endif
	cQuery += "ORDER BY "+a800Filtro[nPos4,2]+" "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	TCSetField("MAR","M_PEDID","N",07,0)
	TCSetField("MAR","M_PESO" ,"N",14,3)
	TCSetField("MAR","M_QUANT","N",14,3)
	TCSetField("MAR","M_VLDSC","N",17,2)
	TCSetField("MAR","M_TOTAL","N",17,2)
	dbSelectArea("MAR")
	While !MAR->(Eof())
		If (n800ConsCli != 1)
			cAnoMes := Substr(MAR->M_emissao,1,6)
			aNota := GB800Nota(MAR->M_cliente,MAR->M_loja,cAnoMes)
			If !(((n800ConsCli == 2).and.Empty(aNota[1])).or.((n800ConsCli == 3).and.!Empty(aNota[1]).and.(aNota[1] <= (FirstDay(stod(MAR->M_emissao))-n800DiasRec))))
				dbSelectArea("MAR")
				MAR->(dbSkip())
				Loop
			Endif
		Endif
		nPos4 := aScan(aDados, {|x| x[1] == MAR->M_QUEBRA })
		If (nPos4 == 0)
			aadd(aDados,{MAR->M_QUEBRA,0,0,0,MEMP->M_codemp,MEMP->M_codfil,0,0})
			nPos4 := Len(aDados)
		Endif
		aDados[nPos4,2] += MAR->M_peso
		aDados[nPos4,3] += MAR->M_quant
		aDados[nPos4,4] += MAR->M_total
		aDados[nPos4,7] += MAR->M_vldsc
		aDados[nPos4,8] += MAR->M_pedid
		nPedid += MAR->M_pedid
		nPeso  += MAR->M_peso
		nQuant += MAR->M_quant
		nDescon+= MAR->M_vldsc
		nTotal += MAR->M_total
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de devolucao ano base
	/////////////////////////////////////////////////////
	nPos4 := Len(a800Filtro)
	If (n800ConsDev == 1).and.!Empty(a800Filtro[nPos4,5])
		cQuery := "SELECT "+a800Filtro[nPos4,5]+" M_QUEBRA, "
		cQuery += "SUM(D1.D1_QUANT*B1.B1_PESO) M_PESO,SUM(D1.D1_QUANT) M_QUANT,SUM(D1.D1_VALDESC) M_VLDSC,"  
		If (n800ConsIPI == 1) //Sim 
			cQuery += "SUM(D1.D1_TOTAL-D1.D1_VALICM-D1.D1_VALIMP5-D1.D1_VALIMP6-D1.D1_VALDESC) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery += "SUM(D1.D1_TOTAL+D1.D1_VALIPI+D1.D1_ICMSRET-D1.D1_VALDESC+D1.D1_VALFRE) M_TOTAL "
		Endif
		cQuery += "FROM "+GB800RetArq("SD1",MEMP->M_codemp)+" D1 "
		cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D1.D1_COD = B1.B1_COD) "
		cQuery += "INNER JOIN "+GB800RetArq("SF1",MEMP->M_codemp)+" F1 ON (D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA) "
		cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
		cQuery += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D1.D1_NFORI = F2.F2_DOC AND D1.D1_SERIORI = F2.F2_SERIE AND D1.D1_FORNECE = F2.F2_CLIENTE AND D1.D1_LOJA = F2.F2_LOJA) "
		If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
			cQuery += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D1.D1_FORNECE = A1.A1_COD AND D1.D1_LOJA = A1.A1_LOJA) "
		Endif
		If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
			cQuery += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
		Endif
		cQuery += "WHERE D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+GB800RetFil("SD1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F1.D_E_L_E_T_ = '' AND F1.F1_FILIAL = '"+GB800RetFil("SF1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
		If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
			cQuery += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		Endif
		If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
			cQuery += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		Endif
		cQuery += "AND D1.D1_TIPO = 'D' "
		If (Left(cPeri4,5) != "TOTAL")
			cQuery += "AND D1.D1_DTDIGIT BETWEEN '"+Left(cPeri4,6)+"' AND '"+Left(cPeri4,6)+"ZZ' "
		Endif
		cQuery += "AND D1.D1_DTDIGIT BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
		If (n800ConsFin == 1)
			cQuery += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery += "AND F2.F2_VEND1 IN ("+cCodRep+") "
			Else
				cQuery += "AND F2.F2_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		For ni := 1 to Len(a800Filtro)-1
			If !Empty(a800Filtro[ni,5])
				cQuery += "AND "+a800Filtro[ni,5]+" = '"+a800Filtro[ni+1,3]+"' "
			Endif
		Next ni
		cQuery += "GROUP BY "+a800Filtro[nPos4,5]+" "
		cQuery += "ORDER BY "+a800Filtro[nPos4,5]+" "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		TCSetField("MAR","M_PESO" ,"N",14,3)
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_VLDSC","N",17,2)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos4 := aScan(aDados, {|x| x[1] == MAR->M_QUEBRA })
			If (nPos4 == 0)
				aadd(aDados,{MAR->M_QUEBRA,0,0,0,MEMP->M_codemp,MEMP->M_codfil,0,0})
				nPos4 := Len(aDados)
			Endif
			aDados[nPos4,2] -= MAR->M_peso
			aDados[nPos4,3] -= MAR->M_quant
			aDados[nPos4,4] -= MAR->M_total
			aDados[nPos4,7] -= MAR->M_vldsc
			nPeso  -= MAR->M_peso
			nQuant -= MAR->M_quant
			nDescon-= MAR->M_vldsc
			nTotal -= MAR->M_total
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	//Monto query para buscar dados de carteira ano base
	////////////////////////////////////////////////////
	If (n800ConsCar == 1).and.(Left(cPeri4,6) >= Substr(dtos(dDatabase),1,6))
		nPos4  := Len(a800Filtro)
		cQuery := "SELECT "+a800Filtro[nPos4,6]+" M_QUEBRA,C5.C5_MOEDA M_MOEDA, "
		cQuery += "COUNT(DISTINCT C5_NUM) M_PEDID,SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*B1.B1_PESO) M_PESO,SUM(C6.C6_QTDVEN-C6.C6_QTDENT) M_QUANT,SUM(C6.C6_VALDESC) M_VLDSC,"
		If (n800ConsIPI == 1) //Sim 
			cQuery += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCLIQ) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCVEN) M_TOTAL "
		Endif
		cQuery += "FROM "+GB800RetArq("SC6",MEMP->M_codemp)+" C6 "
		cQuery += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
		cQuery += "INNER JOIN "+GB800RetArq("SC5",MEMP->M_codemp)+" C5 ON (C6.C6_NUM = C5.C5_NUM) "
		cQuery += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (C6.C6_CLI = A1.A1_COD AND C6.C6_LOJA = A1.A1_LOJA) "
		cQuery += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
		cQuery += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (C5.C5_VEND1 = A3.A3_COD) "
		cQuery += "WHERE C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+GB800RetFil("SC6",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+GB800RetFil("SC5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery += "AND C5.C5_TIPO = 'N' AND C6.C6_QTDVEN > C6.C6_QTDENT AND C6.C6_BLQ <> 'R' "
		If (Left(cPeri4,5) != "TOTAL")
			If (Left(cPeri4,6) == Substr(dtos(dDatabase),1,6))
				cQuery += "AND C6.C6_ENTREG < '"+Left(cPeri4,6)+"ZZ' "
			Else
				cQuery += "AND C6.C6_ENTREG BETWEEN '"+Left(cPeri4,6)+"' AND '"+Left(cPeri4,6)+"ZZ' "
			Endif
		Else
			cQuery += "AND C6.C6_ENTREG < '"+Left(cPeri4,6)+"ZZ' "
		Endif
		If (n800ConsFin == 1)
			cQuery += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery += "AND C5.C5_VEND1 IN ("+cCodRep+") "
			Else
				cQuery += "AND C5.C5_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		For ni := 1 to Len(a800Filtro)-1
			cQuery += "AND "+a800Filtro[ni,6]+" = '"+a800Filtro[ni+1,3]+"' "
		Next ni
		If !Empty(c800BrCfFat)
			cQuery += "AND C6.C6_CF IN ("+c800BrCfFat+") "
		Endif
		If !Empty(c800BrCfNFat)
			cQuery += "AND C6.C6_CF NOT IN ("+c800BrCfNFat+") "
		Endif
		If !Empty(c800BrTsFat)
			cQuery += "AND C6.C6_TES IN ("+c800BrTsFat+") "
		Endif
		If !Empty(c800BrTsNFat)
			cQuery += "AND C6.C6_TES NOT IN ("+c800BrTsNFat+") "
		Endif
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		cQuery += "GROUP BY "+a800Filtro[nPos4,6]+",C5.C5_MOEDA "
		cQuery += "ORDER BY "+a800Filtro[nPos4,6]+" "
		TCQuery cQuery NEW ALIAS "MAR"
		TCSetField("MAR","M_PEDID","N",07,0)
		TCSetField("MAR","M_PESO" ,"N",14,3)
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_VLDSC","N",17,2)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos4 := aScan(aDados, {|x| x[1] == MAR->M_QUEBRA })
			If (nPos4 == 0)
				aadd(aDados,{MAR->M_QUEBRA,0,0,0,MEMP->M_codemp,MEMP->M_codfil,0,0})
				nPos4 := Len(aDados)
			Endif
			nValor := xMoeda(MAR->M_total,MAR->M_moeda,1,d800UltDtMoeda)
			nVlDsc := xMoeda(MAR->M_vldsc,MAR->M_moeda,1,d800UltDtMoeda)
			aDados[nPos4,2] += MAR->M_peso
			aDados[nPos4,3] += MAR->M_quant
			aDados[nPos4,4] += nValor
			aDados[nPos4,7] += nVlDsc
			aDados[nPos4,8] += MAR->M_pedid
			nPedid += MAR->M_pedid
			nPeso  += MAR->M_peso
			nQuant += MAR->M_quant
			nDescon+= nVlDsc
			nTotal += nValor
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif
	
	dbSelectArea("MEMP")
	MEMP->(dbSkip())
Enddo 
MEMP->(dbGotop())    

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno por Faturado/Quantidade                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(xTipo $ "EMI/SAI") //Visao por Emissao/Saida
	aDados := aSort(aDados,,,{|x,y| x[4]>y[4]})
Else
	aDados := aSort(aDados,,,{|x,y| x[1]<y[1]})
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
If (xTipo == "CLI") //Visao por Cliente
	aadd(aHeader,{"Cliente"     ,"A1_COD"   ,"@!",12,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"Estado"      ,"A1_EST"   ,"@!",02,0,"","","C","",""})
Elseif (xTipo == "REG") //Visao por Regiao
	aadd(aHeader,{"Regiao"      ,"A1_REGIAO","@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "MUN") //Visao por Municipio
	aadd(aHeader,{"Municipio"   ,"A1_MUN"   ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "PRO") //Visao por Produto
	aadd(aHeader,{"Produto"     ,"B1_COD"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_DESC"  ,"@!",40,0,"","","C","",""})
	aadd(aHeader,{"UM"          ,"B1_UM"    ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Tipo"        ,"B1_TIPO"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"NCM"         ,"B1_POSIPI","@!",10,0,"","","C","",""})
Elseif (xTipo == "GRU") //Visao por Grupo
	aadd(aHeader,{"Grupo"       ,"BM_GRUPO" ,"@!",04,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"BM_DESCRI","@!",40,0,"","","C","",""})
Elseif (xTipo == "GRE") //Visao por Grupo Representante
	aadd(aHeader,{"Grp.Represen","A3_COD"   ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A3_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "VEN") //Visao por Vendedor
	aadd(aHeader,{"Representante","A3_COD"   ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"A3_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SUP") //Visao por Supervisor
	aadd(aHeader,{"Supervisor"  ,"A3_COD"   ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"A3_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "MER") //Visao por Mercado
	aadd(aHeader,{"Mercado"     ,"A1_GRPVEN","@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "EST") //Visao por Estado
	aadd(aHeader,{"Estado"      ,"A1_EST"   ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "FIL") //Visao por Filial
	aadd(aHeader,{"Filial"      ,"B1_DESC"    ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_ESPECIF" ,"@!",35,0,"","","C","",""})
Elseif (xTipo == "PAI") //Visao por Pais
	aadd(aHeader,{"Pais"        ,"A1_PAIS"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TIP") //Visao por Tipo Produto
	aadd(aHeader,{"Tipo"        ,"B1_TIPO"  ,"@!",02,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_DESC"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "SEG") //Visao por Segmento
	aadd(aHeader,{"Segmento"    ,"A1_SATIV1","@!",06,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"A1_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "CFO") //Visao por CFOP
	aadd(aHeader,{"CFOP"        ,"F4_CF"    ,"@!",05,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"F4_TEXTO" ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "PAG") //Visao por Condicao de Pagamento
	aadd(aHeader,{"Condicao"    ,"E4_CODIGO","@!",03,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"E4_DESCRI","@!",40,0,"","","C","",""})
Elseif (xTipo == "TPF") //Visao por Tipo de Frete
	aadd(aHeader,{"Tipo Frete"  ,"B1_DESC"  ,"@!",01,0,"","","C","",""})
	aadd(aHeader,{"Descricao"   ,"B1_DESC"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "TRA") //Visao por Transportadora
	aadd(aHeader,{"Transp."     ,"A4_COD"   ,"@!",06,0,"","","C","",""})
	aadd(aHeader,{"Nome"        ,"A4_NOME"  ,"@!",40,0,"","","C","",""})
Elseif (xTipo == "EMI") //Visao por Emissao
	aadd(aHeader,{"Emissao"     ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Elseif (xTipo == "SAI") //Visao por Data Saida
	aadd(aHeader,{"Data Saida"  ,"B1_DESC"   ,"@!",10,0,"","","C","",""})
	aadd(aHeader,{"Dia Semana"  ,"B1_ESPECIF","@!",20,0,"","","C","",""})
Elseif (xTipo == "NOT") //Visao por Nota
	aadd(aHeader,{"Nota Fiscal" ,"D2_DOC"    ,"@!",12,0,"","","C","",""})
Endif                
aadd(aHeader,{"Pedidos"  ,"M_PEDID","@E 999,999",07,0,"","","N","",""})
aadd(aHeader,{"Peso KG"  ,"M_PESO" ,"@E 999,999,999",15,0,"","","N","",""})
If (n800ConsCon == 1) //Quantidade/Faturamento
	aadd(aHeader,{"Quantidade"  ,"M_QUANT" ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Faturamento" ,"M_FATUR" ,"@E 999,999,999.99",15,2,"","","N","",""})
Elseif (n800ConsCon == 2) //Quantidade/Meta
	aadd(aHeader,{"Quantidade"  ,"M_QUANT" ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"Meta"        ,"M_META"  ,"@E 999,999,999",15,0,"","","N","",""})
	aadd(aHeader,{"% Realiz."   ,"M_REAL"  ,"@E 999.99",6,2,"","","N","",""})
Elseif (n800ConsCon == 3) //Faturamento/Meta
	aadd(aHeader,{"Faturamento" ,"M_FATUR" ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"Meta"        ,"M_META"  ,"@E 999,999,999.99",15,2,"","","N","",""})
	aadd(aHeader,{"% Realiz."   ,"M_REAL"  ,"@E 999.99",6,2,"","","N","",""})
Endif
aadd(aHeader,{"% Desconto"  ,"M_PDESC" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Vlr.Descon"  ,"M_VLDSC" ,"@E 999,999,999.99",15,2,"","","N","",""})
aadd(aHeader,{"% Partic."   ,"M_PARTI" ,"@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"% Part.Acm." ,"M_PARACM","@E 999.99",6,2,"","","N","",""})
aadd(aHeader,{"Rank"        ,"M_RANK"  ,"@E 99999",5,0,"","","N","",""})
aadd(aHeader,{"ABC"         ,"M_CLASSE","@!",1,0,"","","C","",""})
                                                          
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calculo Classe ABC                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (n800ConsCon == 1) //Quantidade/Faturamento
	nClasseA := (n800AClasse/100)*nTotal
	nClasseB := (n800BClasse/100)*nTotal
	nClasseC := (n800CClasse/100)*nTotal
Elseif (n800ConsCon == 2) //Quantidade/Meta
	nClasseA := (n800AClasse/100)*nQuant
	nClasseB := (n800BClasse/100)*nQuant
	nClasseC := (n800CClasse/100)*nQuant
Elseif (n800ConsCon == 3) //Faturamento/Meta
	nClasseA := (n800AClasse/100)*nTotal
	nClasseB := (n800BClasse/100)*nTotal
	nClasseC := (n800CClasse/100)*nTotal
Endif
nTotalA  := nTotalB := nTotalC := 0                       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Indices para pesquisa e montagem aCols                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX5")
dbSetOrder(1)
aCols := {} ; N := 1 ; nTotOut := 0 ; nQtdOut := 0 ; nMeta := 0 ; nPedOut := 0
nMetOut := 0 ; nPart4 := 0 ; nDesc4 := 0 ; nPartAcm4 := 0 ; nPesOut := 0 ; nDesOut := 0
For ni := 1 to Len(aDados)                   
	nDados4 := 0 ; nMeta4 := 0; nReal4 := 0 ; nPart4 := 0 ; cClasse4 := ""            
	dData4 := Nil
	If (Left(cPeri4,5) != "TOTAL")
		dData4 := stod(Left(cPeri4,6)+"01")
	Endif
	If (Len(aCols) >= n800NumMax)
		If (n800ConsCon == 1) //Quantidade/Faturamento
			nPesOut += aDados[ni,2]
			nQtdOut += aDados[ni,3]
			nTotOut += aDados[ni,4]
			nDesOut += aDados[ni,7]
			nPedOut += aDados[ni,8]
		Elseif (n800ConsCon == 2) //Quantidade/Meta
			nQtdOut += aDados[ni,3]
			nDesOut += aDados[ni,7]
			nPedOut += aDados[ni,8]
			nMeta4 := GB800MetaSCT(aDados[ni,5],aDados[ni,6],aDados[ni,1],dData4)
			nMetOut+= nMeta4
		Elseif (n800ConsCon == 3) //Faturamento/Meta
			nTotOut += aDados[ni,4]
			nDesOut += aDados[ni,7]
			nPedOut += aDados[ni,8]
			nMeta4 := GB800MetaSCT(aDados[ni,5],aDados[ni,6],aDados[ni,1],dData4)
			nMetOut+= nMeta4
		Endif
	Else	
		If (n800ConsCon == 1) //Quantidade/Faturamento
			nDados4 := aDados[ni,4]
			nPart4 := (nDados4/iif(nTotal!=0,nTotal,1))*100
			nPartAcm4 += nPart4
			nDesc4 := (aDados[ni,7]/iif((aDados[ni,4]+aDados[ni,7])!=0,(aDados[ni,4]+aDados[ni,7]),1))*100
		Elseif (n800ConsCon == 2) //Quantidade/Meta
			nDados4 := aDados[ni,3]
			nMeta4 := GB800MetaSCT(aDados[ni,5],aDados[ni,6],aDados[ni,1],dData4)
			nMeta  += nMeta4
			If (nMeta4 > 0)
				nReal4 := (nDados4/nMeta4)*100
			Endif
			nPart4 := (nDados4/iif(nQuant!=0,nQuant,1))*100
			nPartAcm4 += nPart4
			nDesc4 := (aDados[ni,7]/iif((aDados[ni,4]+aDados[ni,7])!=0,(aDados[ni,4]+aDados[ni,7]),1))*100
		Elseif (n800ConsCon == 3) //Faturamento/Meta
			nDados4 := aDados[ni,4]
			nMeta4 := GB800MetaSCT(aDados[ni,5],aDados[ni,6],aDados[ni,1],dData4)
			nMeta  += nMeta4
			If (nMeta4 > 0)
				nReal4 := (nDados4/nMeta4)*100
			Endif
			nPart4 := (nDados4/iif(nTotal!=0,nTotal,1))*100
			nPartAcm4 += nPart4
			nDesc4 := (aDados[ni,7]/iif((aDados[ni,4]+aDados[ni,7])!=0,(aDados[ni,4]+aDados[ni,7]),1))*100
		Endif
		If (nTotalA == 0).or.(nClasseA >= nTotalA)
			nTotalA += nDados4
			cClasse4 := "A"
		Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
			nTotalB += nDados4
			cClasse4 := "B"
		Else
			nTotalC += nDados4
			cClasse4 := "C"
		Endif
		If (xTipo == "CLI") //Visao por Cliente
			cChave4 := GB800RetAlias("SA1",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SA1",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			cAux4 := (cChave4)->A1_est
			nPos4 := aScan(a800Filtro,{|x|x[1]=="ESTADO"})
			If (nPos4 > 0).and.((nPos4+1) <= Len(a800Filtro))
				cAux4 := a800Filtro[nPos4+1,3]
			Endif			
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->A1_nome,cAux4,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->A1_nome,cAux4,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "REG") //Visao por Regiao
			cChave4 := GB800RetAlias("ACA",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("ACA",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->ACA_descri,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->ACA_descri,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "MUN") //Visao por Municipio
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "PRO") //Visao por Produto
			cChave4 := GB800RetAlias("SB1",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SB1",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->B1_desc,(cChave4)->B1_um,(cChave4)->B1_tipo,(cChave4)->B1_posipi,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->B1_desc,(cChave4)->B1_um,(cChave4)->B1_tipo,(cChave4)->B1_posipi,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif			
		Elseif (xTipo == "GRU") //Visao por Grupo
			cChave4 := GB800RetAlias("SBM",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SBM",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->BM_desc,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->BM_desc,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo $ "VEN/SUP") //Visao por Vendedor/Supervisor
			cChave4 := GB800RetAlias("SA3",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SA3",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->A3_nome,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->A3_nome,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif			
		Elseif (xTipo == "GRE") //Visao por Grupo Representante
			cChave4 := GB800RetAlias("ACA",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("ACA",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->ACA_descri,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->ACA_descri,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "MER") //Visao por Mercado
			cChave4 := GB800RetAlias("ACY",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("ACY",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->ACY_descri,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->ACY_descri,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "EST") //Visao por Estado
			dbSelectArea("SX5")
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],Tabela("12",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],Tabela("12",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "FIL") //Visao por Filial
			nSM0 := SM0->(Recno())
			SM0->(dbSeek(cEmpAnt+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],iif(Empty(aDados[ni,1]),"",Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial)),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],iif(Empty(aDados[ni,1]),"",Alltrim(SM0->M0_nome)+" - "+Alltrim(SM0->M0_filial)),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "PAI") //Visao por Pais
			cChave4 := GB800RetAlias("SYA",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SYA",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->YA_descr,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->YA_descr,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "TIP") //Visao por Tipo Produto
			dbSelectArea("SX5")
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],Tabela("02",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],Tabela("02",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "SEG") //Visao por Segmento
			dbSelectArea("SX5")
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],Tabela("T3",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],Tabela("T3",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "CFO") //Visao por CFOP
			dbSelectArea("SX5")
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],Tabela("13",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],Tabela("13",aDados[ni,1],.F.),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "PAG") //Visao por Condicao de Pagamento
			cChave4 := GB800RetAlias("SE4",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SE4",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],(cChave4)->E4_descri,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],(cChave4)->E4_descri,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
		Elseif (xTipo == "TPF") //Visao por Tipo de Frete
			cDsFrete := ""
			If (aDados[ni,1] == "C")
				cDsFrete := "CIF - COST, INSURANCE E FREIGHT (FRETE PAGO)"
			Elseif (aDados[ni,1] == "F")
				cDsFrete := "FOB - FREE ON BOARD (FRETE A PAGAR)"
			Endif
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],cDsFrete,aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],cDsFrete,aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif			
			a800Filtro[Len(a800Filtro),7] := cDsFrete
		Elseif (xTipo == "TRA") //Visao por Transportadora
			cChave4 := GB800RetAlias("SA4",aDados[ni,5])
			(cChave4)->(dbSetOrder(1))
			(cChave4)->(dbSeek(GB800RetFil("SA4",aDados[ni,5],aDados[ni,6])+aDados[ni,1],.T.))
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],iif(!Empty(aDados[ni,1]),(cChave4)->A4_nome,""),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],iif(!Empty(aDados[ni,1]),(cChave4)->A4_nome,""),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif			
			a800Filtro[Len(a800Filtro),7] := aCols[Len(aCols),2]
		Elseif (xTipo $ "EMI/SAI") //Visao por Emissao/Data Saida
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],GB800Semana(stod(aDados[ni,1])),aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],GB800Semana(stod(aDados[ni,1])),aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
			a800Filtro[Len(a800Filtro),7] := GB800Semana(stod(aDados[ni,1]))
		Elseif (xTipo == "NOT") //Visao por Nota
			If (n800ConsCon == 1) //Quantidade/Faturamento
				aadd(aCols,{aDados[ni,1],aDados[ni,8],aDados[ni,2],aDados[ni,3],aDados[ni,4],nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Elseif (n800ConsCon == 2).or.(n800ConsCon == 3) //Quantidade/Meta //Faturamento/Meta
				aadd(aCols,{aDados[ni,1],aDados[ni,8],aDados[ni,2],nDados4,nMeta4,nReal4,nDesc4,aDados[ni,7],nPart4,nPartAcm4,ni,cClasse4,.F.})
			Endif
			a800Filtro[Len(a800Filtro),7] := aDados[ni,1]
		Endif
	Endif
Next ni
If (nPesOut != 0).or.(nQtdOut != 0).or.(nTotOut != 0).or.(nDesOut > 0).or.(nPedOut > 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPos4 := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)       
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPos4,ni] := "OUTROS >"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_PEDID")
			aCols[nPos4,ni] := nPedOut
		Elseif (Alltrim(aHeader[ni,2]) == "M_PESO")
			aCols[nPos4,ni] := nPesOut 
		Elseif (Alltrim(aHeader[ni,2]) == "M_QUANT")
			aCols[nPos4,ni] := nQtdOut 
		Elseif (Alltrim(aHeader[ni,2]) == "M_VLDSC")
			aCols[nPos4,ni] := nDesOut
		Elseif (Alltrim(aHeader[ni,2]) == "M_FATUR")
			aCols[nPos4,ni] := nTotOut
		Elseif (Alltrim(aHeader[ni,2]) == "M_META")
			aCols[nPos4,ni] := nMetOut
		Elseif (Alltrim(aHeader[ni,2]) == "M_PDESC")
			aCols[nPos4,ni] := (nDesOut/iif((nTotOut+nDesOut)!=0,nTotOut+nDesOut,1))*100
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			If (n800ConsCon == 2)
				aCols[nPos4,ni] := (nQtdOut/iif(nQuant!=0,nQuant,1))*100
			Else
				aCols[nPos4,ni] := (nTotOut/iif(nTotal!=0,nTotal,1))*100
			Endif
			nPartAcm4 += aCols[nPos4,ni]
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARACM")
			aCols[nPos4,ni] := nPartAcm4
		Elseif (Alltrim(aHeader[ni,2]) == "M_REAL")
			aCols[nPos4,ni] := 0
			If (n800ConsCon == 2).and.(nMetOut != 0)
				aCols[nPos4,ni] := (nQtdOut/nMetOut)*100
			Elseif (n800ConsCon == 3).and.(nMetOut != 0)
				aCols[nPos4,ni] := (nTotOut/nMetOut)*100
			Endif
		Elseif (aHeader[ni,8] == "C")
			aCols[nPos4,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPos4,ni] := 0
		Else
			aCols[nPos4,ni] := ""
		Endif	
	Next ni
	aCols[nPos4,Len(aHeader)+1] := .F.
Endif
If (nPeso != 0).or.(nQuant != 0).or.(nTotal != 0).or.(nDescon != 0).or.(nPedid != 0)
	aadd(aCols,Array(Len(aHeader)+1))
	nPos4 := Len(aCols) ; lImp := .F.
	For ni := 1 to Len(aHeader)       
		If (aHeader[ni,8] == "C").and.(aHeader[ni,4] > 10).and.(!lImp)
			aCols[nPos4,ni] := "TOTAL >"
			lImp := .T.
		Elseif (Alltrim(aHeader[ni,2]) == "M_PEDID") 
			aCols[nPos4,ni] := nPedid
		Elseif (Alltrim(aHeader[ni,2]) == "M_PESO")
			aCols[nPos4,ni] := nPeso
		Elseif (Alltrim(aHeader[ni,2]) == "M_QUANT")
			aCols[nPos4,ni] := nQuant 
		Elseif (Alltrim(aHeader[ni,2]) == "M_VLDSC")
			aCols[nPos4,ni] := nDescon
		Elseif (Alltrim(aHeader[ni,2]) == "M_FATUR")
			aCols[nPos4,ni] := nTotal
		Elseif (Alltrim(aHeader[ni,2]) == "M_META")
			aCols[nPos4,ni] := nMeta+nMetOut
		Elseif (Alltrim(aHeader[ni,2]) == "M_PARTI")
			aCols[nPos4,ni] := 100
		Elseif (Alltrim(aHeader[ni,2]) == "M_PDESC")
			aCols[nPos4,ni] := (nDescon/(nTotal+nDescon))*100
		Elseif (Alltrim(aHeader[ni,2]) == "M_REAL")
			aCols[nPos4,ni] := 0
			If (n800ConsCon == 2).and.((nMeta+nMetOut) != 0)
				aCols[nPos4,ni] := (nQuant/(nMeta+nMetOut))*100
			Elseif (n800ConsCon == 3).and.((nMeta+nMetOut) != 0)
				aCols[nPos4,ni] := (nTotal/(nMeta+nMetOut))*100
			Endif
		Elseif (aHeader[ni,8] == "C")
			aCols[nPos4,ni] := Space(aHeader[ni,4])
		Elseif (aHeader[ni,8] == "N")
			aCols[nPos4,ni] := 0
		Else
			aCols[nPos4,ni] := ""
		Endif	
	Next ni
	aCols[nPos4,Len(aHeader)+1] := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mensagem de filtro                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c800Filtro := "" ; c800DesFil := ""
If (oGetFat != Nil).and.(Len(oGetFat:aCols) > 0)
	c800Filtro := iif(Left(cPeri4,5)$"TOTAL","PERIODO [COMPLETO] > ","MES ["+cPeri4+"] > ")
Endif	                        
For ni := 1 to Len(a800Filtro)
	If (ni == Len(a800Filtro))
		c800Filtro += a800Filtro[ni,1]
		c800DesFil += a800Filtro[ni,1]
	Else
		c800Filtro += a800Filtro[ni,1]+" ["+Alltrim(a800Filtro[ni+1,3])+"] > "
		c800DesFil += a800Filtro[ni,1]+" ["+Alltrim(a800Filtro[ni+1,7])+"] > "
	Endif
Next ni

Return

Static Function GB800VarPer(xTipo,xCols,xAt)
**************************************
LOCAL oDlgVar, oBold7, oGetVar, oGraf7, aObjects7, aInfo7, aPosObj7, aSizeGrf7, nSerie7, nMeta := 0
LOCAL cTitulo := "GDView Faturamento - Variacao", cChave7, cVarPer, nPos7, lMeta := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold7 NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChave7 := xCols[xAt,1]
Endif
If (Left(cChave7,5) $ "TOTAL/OUTRO" .and. Len(a800Filtro) > 1)
	MsgInfo("> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco meta por produto / vendedor                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xTipo != 3).and.(xTipo != 4).and.(xTipo != 5)
	nPos7 := Len(a800Filtro)
	lMeta := (nPos7 > 0).and.(Alltrim(a800Filtro[nPos7,1]) $ "PRODUTO/VENDEDOR/SUPERVISOR")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB800ProcPerVar(@aHeader,@aCols,cChave7,xTipo,lMeta,nMeta)},cCadastro)

//Monto Grafico
///////////////
aObjects7 := {}
aSizeGrf7 := MsAdvSize(,.F.,430)
AAdd(aObjects7,{  0,  20, .T., .F. })
AAdd(aObjects7,{  0,  48, .T., .F. })
AAdd(aObjects7,{  0, 320, .T., .T. })
aInfo7 := {aSizeGrf7[1],aSizeGrf7[2],aSizeGrf7[3],aSizeGrf7[4],3,3}
aPosObj7 := MsObjSize(aInfo7,aObjects7)
DEFINE MSDIALOG oDlgVar FROM 0,0 TO aSizeGrf7[6],aSizeGrf7[5] TITLE cTitulo PIXEL 
@ aPosObj7[1,1],aPosObj7[1,2] SAY o800Ano7 VAR "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2) OF oDlgVar PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBold7
cVarPer := a800Filtro[Len(a800Filtro),1]+": "+cChave7
@ aPosObj7[1,1],aPosObj7[1,2]+110 SAY oVarPer VAR cVarPer OF oDlgVar PIXEL SIZE 400,9 COLOR CLR_BLACK FONT oBold7
@ aPosObj7[1,1]+14,aPosObj7[1,2] TO aPosObj7[1,1]+15,(aPosObj7[1,4]-aPosObj7[1,2]) LABEL "" OF oDlgVar PIXEL    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVar := MsNewGetDados():New(aPosObj7[2,1],aPosObj7[2,2],aPosObj7[2,3],aPosObj7[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVar,aHeader,aCols)
oGetVar:oBrowse:bLDblClick := { || GB800Coluna(oGetVar,oGetVar:oBrowse:nColPos) }
oGetVar:oBrowse:lUseDefaultColors := .F.
oGetVar:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

@ aPosObj7[3,1],aPosObj7[3,2] MSGRAPHIC oGraf7 SIZE ((oDlgVar:nClientWidth/2)-10),((oDlgVar:nClientHeight/3)-10) OF oDlgVar 
oGraf7:SetMargins(2,2,2,2)
oGraf7:SetGradient(GDBOTTOMTOP,CLR_WHITE,CLR_WHITE)
oGraf7:cCaption := cCadastro
oGraf7:SetTitle("Periodo","",CLR_BLUE,A_RIGHTJUS,GRP_FOOT)
oGraf7:SetTitle("",Alltrim(oGetVar:aCols[1,1])+iif(lMeta,"/Meta",""),CLR_BLUE,A_LEFTJUST,GRP_TITLE)
nSerie7 := oGraf7:CreateSerie(1,,iif(xTipo==3.or.xTipo==5,2,0))
If (lMeta)
	nSerieM := oGraf7:CreateSerie(1,,iif(xTipo==3.or.xTipo==5,2,0))
Endif
For ni := 2 to Len(oGetVar:aHeader)
	If     (xTipo == 2) ; nCor := GDV_FATUR
	Elseif (xTipo == 1) ; nCor := GDV_QUANT
	Elseif (xTipo == 3) ; nCor := GDV_PARTI
	Elseif (xTipo == 4) ; nCor := GDV_PRZMED
	Elseif (xTipo == 5) ; nCor := GDV_PRECO
	Elseif (xTipo == 6) ; nCor := GDV_PESO
	Endif
 	oGraf7:Add(nSerie7,oGetVar:aCols[1,ni],oGetVar:aHeader[ni,1],nCor)
	If (lMeta)
	 	oGraf7:Add(nSerieM,oGetVar:aCols[4,ni],oGetVar:aHeader[ni,1],GDV_META)
	Endif
Next ni  
nSerie7 := oGraf7:CreateSerie(1,,iif(xTipo==3.or.xTipo==5,2,0),.T.)
For ni := 2 to Len(oGetVar:aHeader)
 	oGraf7:Add(nSerie7,oGetVar:aCols[2,ni],oGetVar:aHeader[ni,1],GDV_MEDIA3)
Next ni  
nSerie7 := oGraf7:CreateSerie(1,,iif(xTipo==3.or.xTipo==5,2,0),.T.)
For ni := 2 to Len(oGetVar:aHeader)
 	oGraf7:Add(nSerie7,oGetVar:aCols[3,ni],oGetVar:aHeader[ni,1],GDV_MEDIA9)
Next ni
oGraf7:SetLegenProp(GRP_SCRRIGHT,CLR_WHITE,GRP_VALUES,.F.)
oGraf7:lShowHint := .T.
oGraf7:l3D := .T.
oGraf7:Refresh()
@ aSizeGrf7[4],008 BUTTON "Fechar"         SIZE 30,10 OF oDlgVar PIXEL ACTION oDlgVar:End()
@ aSizeGrf7[4],048 BUTTON "E-Mail"         SIZE 30,10 OF oDlgVar PIXEL ACTION PmsGrafMail(oGraf7,"GDView Faturamento",{"GDView Faturamento",cTitulo},{},1) // E-Mail
@ aSizeGrf7[4],078 BUTTON "Salvar"         SIZE 30,10 OF oDlgVar PIXEL ACTION GrafSavBmp(oGraf7)
@ aSizeGrf7[4],108 BUTTON "&3D"            SIZE 30,10 OF oDlgVar PIXEL ACTION oGraf7:l3D := !oGraf7:l3D
@ aSizeGrf7[4],138 BUTTON "[&Max] [Min]"   SIZE 30,10 OF oDlgVar PIXEL ACTION oGraf7:lAxisVisib := !oGraf7:lAxisVisib
@ aSizeGrf7[4],168 BUTTON "+"              SIZE 15,10 OF oDlgVar PIXEL ACTION oGraf7:ZoomIn()
@ aSizeGrf7[4],183 BUTTON "-"              SIZE 15,10 OF oDlgVar PIXEL ACTION oGraf7:ZoomOut()
If (xTipo == 1)
	@ aSizeGrf7[4],250 SAY "Quantidade" OF oDlgVar PIXEL COLOR GDV_QUANT SIZE 200,10 FONT oBold
Elseif (xTipo == 2)
	@ aSizeGrf7[4],250 SAY "Valor Vendas" OF oDlgVar PIXEL COLOR GDV_FATUR SIZE 200,10 FONT oBold
Elseif (xTipo == 3)
	@ aSizeGrf7[4],250 SAY "% Participacao" OF oDlgVar PIXEL COLOR GDV_PARTI SIZE 200,10 FONT oBold
Elseif (xTipo == 4)
	@ aSizeGrf7[4],250 SAY "Prazo Medio" OF oDlgVar PIXEL COLOR GDV_PRZMED SIZE 200,10 FONT oBold
Elseif (xTipo == 5)
	@ aSizeGrf7[4],250 SAY "Preco Medio" OF oDlgVar PIXEL COLOR GDV_PRECO SIZE 200,10 FONT oBold
Elseif (xTipo == 6)
	@ aSizeGrf7[4],250 SAY "Peso KG" OF oDlgVar PIXEL COLOR GDV_PESO SIZE 200,10 FONT oBold
Endif
@ aSizeGrf7[4],310 SAY "Media 3 Ult.Meses"  OF oDlgVar PIXEL COLOR GDV_MEDIA3 SIZE 200,10 FONT oBold
@ aSizeGrf7[4],380 SAY "Media 12 Ult.Meses" OF oDlgVar PIXEL COLOR GDV_MEDIA9 SIZE 200,10 FONT oBold
If (lMeta)
	@ aSizeGrf7[4],450 SAY "Meta" OF oDlgVar PIXEL COLOR GDV_META SIZE 200,10 FONT oBold
Endif
ACTIVATE MSDIALOG oDlgVar CENTER

Return

Static Function GB800ProcPerVar(aHeader,aCols,xChave,xTipo,lMeta,nMeta)
***************************************************************
LOCAL cQuery7, cPerIni7, cPerAux, cDescPer, aVarPer
LOCAL nLin7, nPos7, nValor7, nTotal7, nMedia3, nMedia9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {}
aadd(aHeader,{"Variacao"   ,"M_VARIAC" ,"@!",15,0,"","","C","",""})
For ni := 1 to Len(a800FatAno)              
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a800FatAno[ni,1],5,2))),1,3))+"/"+Substr(a800FatAno[ni,1],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999.99",17,2,"","","N","",""})
Next ni                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto Periodo                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aVarPer  := {}
cPerIni7 := Strzero(Year(d800Peri1)-1,4)+Strzero(Month(d800Peri1),2)
cPerAux  := cPerIni7
While (cPerAux <= dtos(d800Peri2))
	aadd(aVarPer,{cPerAux,0,0,0,0,0})
	If (Substr(cPerAux,5,2) == "12")
		cPerAux := Strzero(Val(Substr(cPerAux,1,4))+1,4)+"00"
	Endif
	cPerAux := Substr(cPerAux,1,4)+Strzero(Val(Substr(cPerAux,5,2))+1,2)
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotal7 := 0
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !MEMP->(Eof())
                            
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+" > Montando Variacao...")

	If !IsMark("M_OK",c800Marca,lInverte)
		dbSelectArea("MEMP")
		MEMP->(dbSkip())
	   Loop
	Endif  
	
	//Monto query para buscar dados de faturamento ano base
	///////////////////////////////////////////////////////
	If (n800ConsCli == 1) //Todos
		cQuery7 := "SELECT D2_EMISSAO M_EMISSAO, "
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery7 := "SELECT D2.D2_CLIENTE M_CLIENTE,D2.D2_LOJA M_LOJA,D2_EMISSAO M_EMISSAO, "
	Endif
	cQuery7 += "SUM(D2.D2_QUANT*B1.B1_PESO) M_PESO,SUM(D2.D2_QUANT) M_QUANT,"
	If (n800ConsIPI == 1) //Sim 
		cQuery7 += "SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6) M_TOTAL "
	Elseif (n800ConsIPI == 2) //Nao
		cQuery7 += "SUM(D2.D2_VALBRUT) M_TOTAL "
	Endif
	cQuery7 += "FROM "+GB800RetArq("SD2",MEMP->M_codemp)+" D2 "
	cQuery7 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D2.D2_COD = B1.B1_COD) "
	cQuery7 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
	cQuery7 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery7 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
	cQuery7 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D2.D2_CLIENTE = A1.A1_COD AND D2.D2_LOJA = A1.A1_LOJA) "
	cQuery7 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+GB800RetFil("SD2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery7 += "AND D2.D2_TIPO NOT IN ('B','D') "
	cQuery7 += "AND D2.D2_EMISSAO BETWEEN '"+cPerIni7+"' AND '"+dtos(d800Peri2)+"' "
	If (n800ConsFin == 1)
		cQuery7 += "AND F4.F4_DUPLIC = 'S' "
	Elseif (n800ConsFin == 2)
		cQuery7 += "AND F4.F4_DUPLIC = 'N' "
	Endif
	If (n800ConsEst == 1)
		cQuery7 += "AND F4.F4_ESTOQUE = 'S' "
	Elseif (n800ConsEst == 2)
		cQuery7 += "AND F4.F4_ESTOQUE = 'N' "
	Endif
	If !Empty(d800DtSdDe)
		cQuery7 += "AND F2.F2_DTSAIDA >= '"+dtos(d800DtSdDe)+"' "
	Endif
	If !Empty(d800DtSdAte)
		cQuery7 += "AND F2.F2_DTSAIDA <= '"+dtos(d800DtSdAte)+"' "
	Endif
	If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery7 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery7 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif
	For ni := 1 to Len(a800Filtro)-1
		cQuery7 += "AND "+a800Filtro[ni,2]+" = '"+a800Filtro[ni+1,3]+"' "
	Next ni
	If !Empty(c800BrCfFat)
		cQuery7 += "AND D2.D2_CF IN ("+c800BrCfFat+") "
	Endif
	If !Empty(c800BrCfNFat)
		cQuery7 += "AND D2.D2_CF NOT IN ("+c800BrCfNFat+") "
	Endif
	If !Empty(c800BrTsFat)
		cQuery7 += "AND D2.D2_TES IN ("+c800BrTsFat+") "
	Endif
	If !Empty(c800BrTsNFat)
		cQuery7 += "AND D2.D2_TES NOT IN ("+c800BrTsNFat+") "
	Endif
	cQuery7 += "AND "+a800Filtro[Len(a800Filtro),2]+" = '"+xChave+"' "
	If (n800ConsCli == 1) //Todos
		cQuery7 += "GROUP BY D2.D2_EMISSAO "
	Elseif (n800ConsCli != 1) //1a Compra/Recuperados
		cQuery7 += "GROUP BY D2.D2_CLIENTE,D2.D2_LOJA,D2.D2_EMISSAO "
	Endif
	cQuery7 += "ORDER BY M_EMISSAO "
	cQuery7 := ChangeQuery(cQuery7)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery7 NEW ALIAS "MAR"
	TCSetField("MAR","M_PESO" ,"N",14,3)
	TCSetField("MAR","M_QUANT","N",14,3)
	TCSetField("MAR","M_TOTAL","N",17,2)
	dbSelectArea("MAR")
	While !MAR->(Eof())
		If (n800ConsCli != 1)
			cAnoMes := Substr(MAR->M_emissao,1,6)
			aNota := GB800Nota(MAR->M_cliente,MAR->M_loja,cAnoMes)
			If !(((n800ConsCli == 2).and.Empty(aNota[1])).or.((n800ConsCli == 3).and.!Empty(aNota[1]).and.(aNota[1] <= (FirstDay(stod(MAR->M_emissao))-n800DiasRec))))
				dbSelectArea("MAR")
				MAR->(dbSkip())
				Loop
			Endif
		Endif
		nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If (nPos7 == 0)
			aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0,0,0,0})
			nPos7 := Len(aVarPer)
		Endif
		aVarPer[nPos7,2] += MAR->M_peso
		aVarPer[nPos7,3] += MAR->M_quant 
		aVarPer[nPos7,4] += MAR->M_total
		nMeta := 0
		If (lMeta).and.Empty(aVarPer[nPos7,6])
			nMeta := GB800MetaSCT(MEMP->M_codemp,MEMP->M_codfil,xChave,stod(MAR->M_emissao))
			aVarPer[nPos7,6] := nMeta
		Endif
		nTotal7 += MAR->M_total
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de devolucao ano base
	/////////////////////////////////////////////////////
	If (n800ConsDev == 1)
		cQuery7 := "SELECT D1_DTDIGIT M_EMISSAO, "
		cQuery7 += "SUM(D1.D1_QUANT*B1.B1_PESO) M_PESO,SUM(D1.D1_QUANT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim 
			cQuery7 += "SUM(D1.D1_TOTAL-D1.D1_VALICM-D1.D1_VALIMP5-D1.D1_VALIMP6-D1.D1_VALDESC) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery7 += "SUM(D1.D1_TOTAL+D1.D1_VALIPI+D1.D1_ICMSRET-D1.D1_VALDESC+D1.D1_VALFRE) M_TOTAL "
		Endif
		cQuery7 += "FROM "+GB800RetArq("SD1",MEMP->M_codemp)+" D1 "
		cQuery7 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D1.D1_COD = B1.B1_COD) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SF1",MEMP->M_codemp)+" F1 ON (D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D1.D1_FORNECE = A1.A1_COD AND D1.D1_LOJA = A1.A1_LOJA) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D1.D1_NFORI = F2.F2_DOC AND D1.D1_SERIORI = F2.F2_SERIE AND D1.D1_FORNECE = F2.F2_CLIENTE AND D1.D1_LOJA = F2.F2_LOJA) "
		cQuery7 += "WHERE D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+GB800RetFil("SD1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND F1.D_E_L_E_T_ = '' AND F1.F1_FILIAL = '"+GB800RetFil("SF1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND D1.D1_TIPO = 'D' "
		cQuery7 += "AND D1.D1_DTDIGIT BETWEEN '"+cPerIni7+"' AND '"+dtos(d800Peri2)+"' "
		If (n800ConsFin == 1)
			cQuery7 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery7 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery7 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery7 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery7 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
			Else
				cQuery7 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
			Endif
		Endif
		For ni := 1 to Len(a800Filtro)-1           
			If !Empty(a800Filtro[ni,5])
				cQuery7 += "AND "+a800Filtro[ni,5]+" = '"+a800Filtro[ni+1,3]+"' "
			Endif
		Next ni
		cQuery7 += "AND "+a800Filtro[Len(a800Filtro),5]+" = '"+xChave+"' "
		cQuery7 += "GROUP BY D1.D1_DTDIGIT "
		cQuery7 += "ORDER BY M_EMISSAO "
		cQuery7 := ChangeQuery(cQuery7)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery7 NEW ALIAS "MAR"
		TCSetField("MAR","M_PESO" ,"N",14,3)
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos7 := aScan(aVarPer, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
			If (nPos7 == 0)
				aadd(aVarPer,{Substr(MAR->M_emissao,1,6),0,0,0,0,0})
				nPos7 := Len(aVarPer)
			Endif
			aVarPer[nPos7,2] -= MAR->M_peso 
			aVarPer[nPos7,3] -= MAR->M_quant
			aVarPer[nPos7,4] -= MAR->M_total
			nTotal7 -= MAR->M_total
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	//Monto query para buscar dados de carteira ano base
	////////////////////////////////////////////////////
	If (n800ConsCar == 1)
		cQuery7 := "SELECT C6.C6_ENTREG M_EMISSAO,C5.C5_MOEDA M_MOEDA, "
		cQuery7 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*B1.B1_PESO) M_PESO,SUM(C6.C6_QTDVEN-C6.C6_QTDENT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim 
			cQuery7 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCLIQ) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery7 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCVEN) M_TOTAL "
		Endif
		cQuery7 += "FROM "+GB800RetArq("SC6",MEMP->M_codemp)+" C6 "
		cQuery7 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SC5",MEMP->M_codemp)+" C5 ON (C6.C6_NUM = C5.C5_NUM) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (C6.C6_CLI = A1.A1_COD AND C6.C6_LOJA = A1.A1_LOJA) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
		cQuery7 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (C5.C5_VEND1 = A3.A3_COD) "
		cQuery7 += "WHERE C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+GB800RetFil("SC6",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+GB800RetFil("SC5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery7 += "AND C5.C5_TIPO = 'N' AND C6.C6_QTDVEN > C6.C6_QTDENT AND C6.C6_BLQ <> 'R' "
		cQuery7 += "AND C6.C6_ENTREG BETWEEN '"+cPerIni7+"' AND '"+dtos(d800Peri2)+"' "
		If (n800ConsFin == 1)
			cQuery7 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery7 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery7 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery7 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery7 += "AND C5.C5_VEND1 IN ("+cCodRep+") "
			Else
				cQuery7 += "AND C5.C5_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		For ni := 1 to Len(a800Filtro)-1
			cQuery7 += "AND "+a800Filtro[ni,6]+" = '"+a800Filtro[ni+1,3]+"' "
		Next ni
		If !Empty(c800BrCfFat)
			cQuery7 += "AND C6.C6_CF IN ("+c800BrCfFat+") "
		Endif
		If !Empty(c800BrCfNFat)
			cQuery7 += "AND C6.C6_CF NOT IN ("+c800BrCfNFat+") "
		Endif
		If !Empty(c800BrTsFat)
			cQuery7 += "AND C6.C6_TES IN ("+c800BrTsFat+") "
		Endif
		If !Empty(c800BrTsNFat)
			cQuery7 += "AND C6.C6_TES NOT IN ("+c800BrTsNFat+") "
		Endif
		cQuery7 += "AND "+a800Filtro[Len(a800Filtro),6]+" = '"+xChave+"' "
		cQuery7 += "GROUP BY C6.C6_ENTREG,C5.C5_MOEDA "
		cQuery7 += "ORDER BY M_EMISSAO "
		cQuery7 := ChangeQuery(cQuery7)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery7 NEW ALIAS "MAR"
		TCSetField("MAR","M_PESO" ,"N",14,3)
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			cAnoMes := Substr(MAR->M_Emissao,1,6)
			If (cAnoMes < Substr(dtos(dDatabase),1,6))
				cAnoMes := Substr(dtos(dDatabase),1,6)
			Endif
			nPos7 := aScan(aVarPer, {|x| x[1] == cAnoMes })
			If (nPos7 == 0)
				aadd(aVarPer,{cAnoMes,0,0,0,0,0})
				nPos7 := Len(aVarPer)
			Endif
			nValor := xMoeda(MAR->M_total,MAR->M_moeda,1,d800UltDtMoeda)
			aVarPer[nPos7,2] += MAR->M_peso
			aVarPer[nPos7,3] += MAR->M_quant 
			aVarPer[nPos7,4] += nValor
			nTotal7 += nValor
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif
		
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
If (lMeta)
	aadd(aCols,Array(Len(aHeader)+1))
Endif
If (xTipo == 1)
	aCols[1,1] := "Quantidade"
Elseif (xTipo == 2)
	aCols[1,1] := "Faturamento"
Elseif (xTipo == 3)
	aCols[1,1] := "% Participacao"
Elseif (xTipo == 4)
	aCols[1,1] := "Prazo Medio (dias)"
Elseif (xTipo == 5)
	aCols[1,1] := "Preco Medio"
Elseif (xTipo == 6)
	aCols[1,1] := "Peso KG"
Endif
aCols[2,1] := "Media 3 Ult.Meses"
aCols[3,1] := "Media 12 Ult.Meses"
If (lMeta)
	aCols[4,1] := "Meta"
Endif
For ni := 2 to Len(aHeader)
	aCols[1,ni] := 0
	aCols[2,ni] := 0
	aCols[3,ni] := 0
	If (lMeta)
		aCols[4,ni] := 0
	Endif
Next ni
For ni := 1 to Len(aVarPer)
	nValor7 := 0
	If (xTipo == 1)
		nValor7 := aVarPer[ni,3]
	Elseif (xTipo == 2)
		nValor7 := aVarPer[ni,4]
	Elseif (xTipo == 3)
		nPos7 := aScan(a800FatAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
		If (nPos7 > 0).and.(a800FatAno[nPos7,4] > 0)
			nValor7 := (aVarPer[ni,4]/a800FatAno[nPos7,4])*100
		Else
			nValor7 := (aVarPer[ni,4]/a800FatAno[1,4])*100
		Endif
	Elseif (xTipo == 4)
		If (nTotal7 > 0)
			nValor7 := (aVarPer[ni,4]/(nTotal7/360))
		Endif
	Elseif (xTipo == 5)
		If (aVarPer[ni,3] > 0)
			nValor7 := (aVarPer[ni,4]/aVarPer[ni,3])
		Endif
	Elseif (xTipo == 6)
		nValor7 := aVarPer[ni,2]
	Endif
	aVarPer[ni,5] := nValor7
	nPos7 := aScan(a800FatAno, {|x| Substr(x[1],1,6) == aVarPer[ni,1] })
	If (nPos7 > 0)
		aCols[1,nPos7+1] := nValor7		
		If (lMeta)
			aCols[4,nPos7+1] := aVarPer[ni,6]
		Endif
		nConta := 0 ; nMedia3 := 0
		For nx := ni to (ni-2) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia3 += aVarPer[nx,5]
				nConta++
			Endif
		Next nx
		aCols[2,nPos7+1] := nMedia3/Max(nConta,1)
		nConta := 0 ; nMedia9 := 0
		For nx := ni to (ni-11) step -1
			If (nx > 0).and.(nx <= Len(aVarPer))
				nMedia9 += aVarPer[nx,5]
				nConta++
			Endif
		Next nx
		aCols[3,nPos7+1] := nMedia9/Max(nConta,1)
	Endif	
Next ni           
aCols[1,Len(aHeader)+1] := .F.
aCols[2,Len(aHeader)+1] := .F.
aCols[3,Len(aHeader)+1] := .F.
If (lMeta)
	aCols[4,Len(aHeader)+1] := .F.
Endif

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

Static Function GB800VarAna(xCols,xAt,xTipo)
***************************************
LOCAL oDlgVar, oBold9, oGetVar, oGraf9, aObjects9, aInfo9, aPosObj9, aSizeGrf9, nSerie9, cChave9
LOCAL cTitulo := "GDView Faturamento - Analise da Variacao", cVarPer, nPos9, nConta9

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold9 NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chave para filtro                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xCols != Nil).and.(Len(xCols) > 0).and.(xAt != Nil).and.(xAt > 0)
	cChave9 := xCols[xAt,1]
Endif
If (Left(cChave9,5) $ "TOTAL/OUTRO" .and. Len(a800Filtro) > 1)
	MsgInfo("> Sem dados para exibir!","ATENCAO")
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aCols := {} ; N := 1
Processa({||GB800ProcAnaVar(@aHeader,@aCols,cChave9,xTipo)},cCadastro)

//Monto Grafico
///////////////
aObjects9 := {} ; nConta9 := 0
aSizeGrf9 := MsAdvSize(,.F.,400)
AAdd(aObjects9,{  0,  20, .T., .F. })
AAdd(aObjects9,{  0, 360, .T., .T. })
AAdd(aObjects9,{  0,  20, .T., .F. })
aInfo9   := {aSizeGrf9[1],aSizeGrf9[2],aSizeGrf9[3],aSizeGrf9[4],3,3}
aPosObj9 := MsObjSize(aInfo9,aObjects9)
DEFINE MSDIALOG oDlgVar FROM aSizeGrf9[7],0 TO aSizeGrf9[6],aSizeGrf9[5] TITLE cTitulo PIXEL
@ aPosObj9[1,1],aPosObj9[1,2] SAY o800Ano9 VAR "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2) OF oDlgVar PIXEL SIZE 180,9 COLOR CLR_GREEN FONT oBold9
@ aPosObj9[1,1],aPosObj9[1,2]+150 SAY o800Filtro VAR c800Filtro OF oDlgVar PIXEL SIZE 400,9 COLOR CLR_GREEN FONT oBold9
@ aPosObj9[1,1]+14,aPosObj9[1,2] TO aPosObj9[1,1]+15,(aPosObj9[1,4]-aPosObj9[1,2]) LABEL "" OF oDlgVar PIXEL    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto getdados para consulta                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetVar := MsNewGetDados():New(aPosObj9[2,1],aPosObj9[2,2],aPosObj9[2,3],aPosObj9[2,4],4,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgVar,aHeader,aCols)
oGetVar:oBrowse:bLDblClick := { || GB800Coluna(oGetVar,oGetVar:oBrowse:nColPos) }
oGetVar:oBrowse:lUseDefaultColors := .F.
oGetVar:oBrowse:SetBlkBackColor({||GB800CorAna(oGetVar:aHeader,oGetVar:aCols,oGetVar:nAt)})

oExceX  := u_GDVButton(oDlgVar,"oButExc1","Excel"   ,aPosObj9[3,4]-130,aPosObj9[3,1],40,,{||GB800ExpExcel(@oGetVar:aHeader,@oGetVar:aCols)})
oImprim := u_GDVButton(oDlgVar,"oButImp1","Imprimir",aPosObj9[3,4]-090,aPosObj9[3,1],40,,{||GB800Imprime(@oGetVar:aHeader,@oGetVar:aCols)})
oFechar := u_GDVButton(oDlgVar,"oButFec1","Fechar"  ,aPosObj9[3,4]-050,aPosObj9[3,1],40,,{||oDlgVar:End()})

ACTIVATE MSDIALOG oDlgVar CENTER

Return

Static Function GB800ProcAnaVar(aHeader,aCols,xChave,xTipo)
****************************************************
LOCAL aPlan9, cQuery9, cPerAux, cDescPer, aVarPer 
LOCAL nLin9, nPos9, nCols9, nValor9, nTotal9, ni, nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aHeader                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := {} ; aVarPer := {}
nPos9 := Len(a800Filtro)
aadd(aHeader,{a800Filtro[nPos9,1],"M_FILTRO" ,"@!",15,0,"","","C","",""})
aadd(aHeader,{"Descricao","M_DESCRI","@!",30,0,"","","C","",""})
aadd(aHeader,{"Tipo","M_TIPO"  ,"@!",03,0,"","","C","",""})
nCols9 := Len(aHeader)
For ni := 1 to Len(a800FatAno)
	cDescPer := Upper(Substr(MesExtenso(Val(Substr(a800FatAno[ni,1],5,2))),1,3))+"/"+Substr(a800FatAno[ni,1],3,2)
	aadd(aHeader,{cDescPer ,"M_PER"+Strzero(ni,2) ,"@E 999,999,999",11,0,"","","N","",""})
	aadd(aVarPer,Substr(a800FatAno[ni,1],1,6))
Next ni                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aPlan9 := {}
aTotal9 := {Array(Len(aVarPer)),Array(Len(aVarPer))}
aFill(aTotal9[1],0) ; aFill(aTotal9[2],0)
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !MEMP->(Eof())
                            
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+" > Montando Variacao...")

	If !IsMark("M_OK",c800Marca,lInverte)
		dbSelectArea("MEMP")
		MEMP->(dbSkip())
	   Loop
	Endif  

	//Monto query para buscar dados de faturamento ano base
	///////////////////////////////////////////////////////
	nPos9 := Len(a800Filtro)
	If (n800ConsCli == 1)
		cQuery9 := "SELECT "+a800Filtro[nPos9,2]+" M_QUEBRA,D2.D2_EMISSAO M_EMISSAO,SUM(D2.D2_QUANT) M_QUANT,"
	Elseif (n800ConsCli != 1)
		cQuery9 := "SELECT D2.D2_CLIENTE M_CLIENTE,D2.D2_LOJA M_LOJA,"+a800Filtro[nPos9,2]+" M_QUEBRA,D2.D2_EMISSAO M_EMISSAO,SUM(D2.D2_QUANT) M_QUANT,"
	Endif	
	If (n800ConsIPI == 1) //Sim 
		cQuery9 += "SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6) M_TOTAL "
	Elseif (n800ConsIPI == 2) //Nao
		cQuery9 += "SUM(D2.D2_VALBRUT) M_TOTAL "
	Endif
	cQuery9 += "FROM "+GB800RetArq("SD2",MEMP->M_codemp)+" D2 "
	cQuery9 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
	cQuery9 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery9 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D2.D2_COD = B1.B1_COD) "
	If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
		cQuery9 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D2.D2_CLIENTE = A1.A1_COD AND D2.D2_LOJA = A1.A1_LOJA) "
	Endif
	If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
		cQuery9 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
	Endif
	cQuery9 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+GB800RetFil("SD2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery9 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery9 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery9 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	If (aScan(a800Filtro, {|x| x[4] == "SA1"}) > 0)
		cQuery9 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	If (aScan(a800Filtro, {|x| x[4] == "SA3"}) > 0)
		cQuery9 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	cQuery9 += "AND D2.D2_TIPO NOT IN ('B','D') "
	If (n800ConsFin == 1)
		cQuery9 += "AND F4.F4_DUPLIC = 'S' "
	Elseif (n800ConsFin == 2)
		cQuery9 += "AND F4.F4_DUPLIC = 'N' "
	Endif
	If (n800ConsEst == 1)
		cQuery9 += "AND F4.F4_ESTOQUE = 'S' "
	Elseif (n800ConsEst == 2)
		cQuery9 += "AND F4.F4_ESTOQUE = 'N' "
	Endif
	If !Empty(d800DtSdDe)
		cQuery9 += "AND F2.F2_DTSAIDA >= '"+dtos(d800DtSdDe)+"' "
	Endif
	If !Empty(d800DtSdAte)
		cQuery9 += "AND F2.F2_DTSAIDA <= '"+dtos(d800DtSdAte)+"' "
	Endif
	If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery9 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery9 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	For ni := 1 to Len(a800Filtro)-1
		cQuery9 += "AND "+a800Filtro[ni,2]+" = '"+a800Filtro[ni+1,3]+"' "
	Next ni
	If !Empty(c800BrCfFat)
		cQuery9 += "AND D2.D2_CF IN ("+c800BrCfFat+") "
	Endif
	If !Empty(c800BrCfNFat)
		cQuery9 += "AND D2.D2_CF NOT IN ("+c800BrCfNFat+") "
	Endif
	If !Empty(c800BrTsFat)
		cQuery9 += "AND D2.D2_TES IN ("+c800BrTsFat+") "
	Endif
	If !Empty(c800BrTsNFat)
		cQuery9 += "AND D2.D2_TES NOT IN ("+c800BrTsNFat+") "
	Endif
	cQuery9 += "AND D2.D2_EMISSAO BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
	If (n800ConsCli == 1)
		cQuery9 += "GROUP BY "+a800Filtro[nPos9,2]+",D2.D2_EMISSAO "
	Elseif (n800ConsCli != 1)
		cQuery9 += "GROUP BY D2.D2_CLIENTE,D2.D2_LOJA,"+a800Filtro[nPos9,2]+",D2.D2_EMISSAO "
	Endif	
	cQuery9 += "ORDER BY "+a800Filtro[nPos9,2]+" "
	cQuery9 := ChangeQuery(cQuery9)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery9 NEW ALIAS "MAR"
	TCSetField("MAR","M_QUANT","N",14,3)
	TCSetField("MAR","M_TOTAL","N",17,2)
	nQtdEmp := 0 ; nTotEmp := 0 ; nMetEmp := 0
	dbSelectArea("MAR")
	While !MAR->(Eof())
		If (n800ConsCli != 1)
			cAnoMes := Substr(MAR->M_emissao,1,6)
			aNota := GB800Nota(MAR->M_cliente,MAR->M_loja,cAnoMes)
			If !(((n800ConsCli == 2).and.Empty(aNota[1])).or.((n800ConsCli == 3).and.!Empty(aNota[1]).and.(aNota[1] <= (FirstDay(stod(MAR->M_emissao))-n800DiasRec))))
				dbSelectArea("MAR")
				MAR->(dbSkip())
				Loop
			Endif
		Endif
		nPos9 := aScan(aPlan9,{|x| x[1]==MAR->M_QUEBRA})
		If (nPos9 == 0)
			aadd(aPlan9,{MAR->M_QUEBRA,Array(Len(aVarPer)),Array(Len(aVarPer))})
			nPos9 := Len(aPlan9)
			For nn := 1 to Len(aVarPer)
				aPlan9[nPos9,2,nn] := 0 //Quantidade
				aPlan9[nPos9,3,nn] := 0 //Faturamento
			Next nn
		Endif	
		nLin9 := aScan(a800FatAno,{|x| Substr(x[1],1,6)==Substr(MAR->M_emissao,1,6) })
		If (nLin9 > 0).and.(nPos9 > 0)
			aPlan9[nPos9,2,nLin9] += MAR->M_quant
			aPlan9[nPos9,3,nLin9] += MAR->M_total
			aTotal9[1,nLin9] += MAR->M_quant
			aTotal9[2,nLin9] += MAR->M_total
		Endif
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de devolucao ano base
	/////////////////////////////////////////////////////
	If (n800ConsDev == 1)
		nPos9   := Len(a800Filtro)
		cQuery9 := "SELECT "+a800Filtro[nPos9,5]+" M_QUEBRA,D1.D1_DTDIGIT M_EMISSAO,SUM(D1.D1_QUANT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim 
			cQuery9 += "SUM(D1.D1_TOTAL-D1.D1_VALICM-D1.D1_VALIMP5-D1.D1_VALIMP6-D1.D1_VALDESC) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery9 += "SUM(D1.D1_TOTAL+D1.D1_VALIPI+D1.D1_ICMSRET-D1.D1_VALDESC+D1.D1_VALFRE) M_TOTAL "
		Endif
		cQuery9 += "FROM "+GB800RetArq("SD1",MEMP->M_codemp)+" D1 "
		cQuery9 += "INNER JOIN "+GB800RetArq("SF1",MEMP->M_codemp)+" F1 ON (D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D1.D1_FORNECE = A1.A1_COD AND D1.D1_LOJA = A1.A1_LOJA) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D1.D1_COD = B1.B1_COD) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D1.D1_NFORI = F2.F2_DOC AND D1.D1_SERIORI = F2.F2_SERIE AND D1.D1_FORNECE = F2.F2_CLIENTE AND D1.D1_LOJA = F2.F2_LOJA) "
		cQuery9 += "WHERE D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+GB800RetFil("SD1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND F1.D_E_L_E_T_ = '' AND F1.F1_FILIAL = '"+GB800RetFil("SF1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND D1.D1_TIPO = 'D' "
		If (n800ConsFin == 1)
			cQuery9 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery9 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery9 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery9 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery9 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
			Else
				cQuery9 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		For ni := 1 to Len(a800Filtro)-1
			If !Empty(a800Filtro[ni,5])
				cQuery9 += "AND "+a800Filtro[ni,5]+" = '"+a800Filtro[ni+1,3]+"' "
			Endif
		Next ni
		cQuery9 += "AND D1.D1_DTDIGIT BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
		cQuery9 += "GROUP BY "+a800Filtro[nPos9,5]+",D1.D1_DTDIGIT "
		cQuery9 += "ORDER BY "+a800Filtro[nPos9,5]+" "
		cQuery9 := ChangeQuery(cQuery9)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery9 NEW ALIAS "MAR"
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos9 := aScan(aPlan9,{|x| x[1]==MAR->M_QUEBRA})
			If (nPos9 == 0)
				aadd(aPlan9,{MAR->M_QUEBRA,Array(Len(aVarPer)),Array(Len(aVarPer))})
				nPos9 := Len(aPlan9)
				For nn := 1 to Len(aVarPer)
					aPlan9[nPos9,2,nn] := 0 //Quantidade
					aPlan9[nPos9,3,nn] := 0 //Faturamento
				Next nn
			Endif	
			nLin9 := aScan(a800FatAno,{|x| Substr(x[1],1,6)==Substr(MAR->M_emissao,1,6) })
			If (nLin9 > 0).and.(nPos9 > 0)
				aPlan9[nPos9,2,nLin9] -= MAR->M_quant
				aPlan9[nPos9,3,nLin9] -= MAR->M_total
				aTotal9[1,nLin9] -= MAR->M_quant
				aTotal9[2,nLin9] -= MAR->M_total
			Endif
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	//Monto query para buscar dados de carteira ano base
	////////////////////////////////////////////////////
	If (n800ConsCar == 1)
		nPos9   := Len(a800Filtro)
		cQuery9 := "SELECT "+a800Filtro[nPos9,6]+" M_QUEBRA,C5.C5_MOEDA M_MOEDA, "
		cQuery9 += "C6.C6_ENTREG M_EMISSAO,SUM(C6.C6_QTDVEN-C6.C6_QTDENT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim 
			cQuery9 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCLIQ) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery9 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCVEN) M_TOTAL "
		Endif
		cQuery9 += "FROM "+GB800RetArq("SC6",MEMP->M_codemp)+" C6 "
		cQuery9 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SC5",MEMP->M_codemp)+" C5 ON (C6.C6_NUM = C5.C5_NUM) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (C5.C5_CLIENTE = A1.A1_COD AND C5.C5_LOJACLI = A1.A1_LOJA) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
		cQuery9 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (C5.C5_VEND1 = A3.A3_COD) "
		cQuery9 += "WHERE C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+GB800RetFil("SC6",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+GB800RetFil("SC5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery9 += "AND C5.C5_TIPO = 'N' AND C6.C6_QTDVEN > C6.C6_QTDENT AND C6.C6_BLQ <> 'R' "
		cQuery9 += "AND C6.C6_ENTREG < '"+dtos(d800Peri2)+"' "
		If (n800ConsFin == 1)
			cQuery9 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery9 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery9 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery9 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery += "AND C5.C5_VEND1 IN ("+cCodRep+") "
			Else
				cQuery += "AND C5.C5_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		For ni := 1 to Len(a800Filtro)-1
			cQuery9 += "AND "+a800Filtro[ni,6]+" = '"+a800Filtro[ni+1,3]+"' "
		Next ni
		If !Empty(c800BrCfFat)
			cQuery9 += "AND C6.C6_CF IN ("+c800BrCfFat+") "
		Endif
		If !Empty(c800BrCfNFat)
			cQuery9 += "AND C6.C6_CF NOT IN ("+c800BrCfNFat+") "
		Endif
		If !Empty(c800BrTsFat)
			cQuery9 += "AND C6.C6_TES IN ("+c800BrTsFat+") "
		Endif
		If !Empty(c800BrTsNFat)
			cQuery9 += "AND C6.C6_TES NOT IN ("+c800BrTsNFat+") "
		Endif
		cQuery9 += "GROUP BY "+a800Filtro[nPos9,6]+",C6.C6_ENTREG,C5.C5_MOEDA "
		cQuery9 += "ORDER BY "+a800Filtro[nPos9,6]+",M_EMISSAO "
		cQuery9 := ChangeQuery(cQuery9)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery9 NEW ALIAS "MAR"
		TCSetField("MAR","M_QUANT"  ,"N",14,3)
		TCSetField("MAR","M_TOTAL" ,"N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos9 := aScan(aPlan9,{|x| x[1]==MAR->M_QUEBRA})
			If (nPos9 == 0)
				aadd(aPlan9,{MAR->M_QUEBRA,Array(Len(aVarPer)),Array(Len(aVarPer))})
				nPos9 := Len(aPlan9)
				For nn := 1 to Len(aVarPer)
					aPlan9[nPos9,2,nn] := 0 //Quantidade
					aPlan9[nPos9,3,nn] := 0 //Faturamento
				Next nn
			Endif	
			nLin9 := aScan(a800FatAno,{|x| Substr(x[1],1,6)==Substr(MAR->M_emissao,1,6) })
			If (nLin9 > 0).and.(nPos9 > 0)
				nValor := xMoeda(MAR->M_total,MAR->M_moeda,1,d800UltDtMoeda)
				aPlan9[nPos9,2,nLin9] += MAR->M_quant
				aPlan9[nPos9,3,nLin9] += nValor
				aTotal9[1,nLin9] += MAR->M_quant
				aTotal9[2,nLin9] += MAR->M_total
			Endif
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	dbSelectArea("MEMP")
	MEMP->(dbSkip())
Enddo 
MEMP->(dbGotop())    
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordeno aCols                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
For ni := 1 to Len(aPlan9)
	aadd(aCols,Array(Len(aHeader)+1))
	nPos9 := Len(aCols)
	aCols[nPos9,1] := aPlan9[ni,1]
	If (xTipo == "CLI") //Visao por Cliente
		aCols[nPos9,2] := Posicione("SA1",1,xFilial("SA1")+aCols[nPos9,1],"A1_NOME")
	Elseif (xTipo == "MUN") //Visao por Municipio
		aCols[nPos9,2] := Space(1)
	Elseif (xTipo == "PRO") //Visao por Produto
		aCols[nPos9,2] := Space(30)
		aCols[nPos9,4] := 0
		SB1->(dbSetOrder(1))
		If SB1->(dbSeek(xFilial("SB1")+aCols[nPos9,1]))
			aCols[nPos9,2] := SB1->B1_desc
			aCols[nPos9,4] := 0
		Endif
	Elseif (xTipo == "GRU") //Visao por Grupo
		aCols[nPos9,2] := Posicione("SBM",1,xFilial("SBM")+aCols[nPos9,1],"BM_DESC")
	Elseif (xTipo == "MER") //Visao por Mercado
		aCols[nPos9,2] := Posicione("ACY",1,xFilial("ACY")+aCols[nPos9,1],"ACY_DESCRI")
	Elseif (xTipo $ "GRE/REG") //Visao por Regiao
		aCols[nPos9,2] := Posicione("ACA",1,xFilial("ACA")+aCols[nPos9,1],"ACA_DESCRI")
	Elseif (xTipo == "EST") //Visao por Estado
		dbSelectArea("SX5")
		aCols[nPos9,2] := Tabela("12",aCols[nPos9,1],.F.)
	Elseif (xTipo == "PAI") //Visao por Pais
		aCols[nPos9,2] := Posicione("SYA",1,xFilial("SYA")+aCols[nPos9,1],"YA_DESCR")
	Elseif (xTipo == "VEN") //Visao por Vendedor
		aCols[nPos9,2] := Posicione("SA3",1,xFilial("SA3")+aCols[nPos9,1],"A3_NOME")
	Elseif (xTipo == "TIP") //Visao por Tipo Produto
		dbSelectArea("SX5")
		aCols[nPos9,2] := Tabela("02",aCols[nPos9,1],.F.)
	Elseif (xTipo == "SEG") //Visao por Segmento
		dbSelectArea("SX5")
		aCols[nPos9,2] := Tabela("T3",aCols[nPos9,1],.F.)
	Elseif (xTipo == "CFO") //Visao por CFOP
		dbSelectArea("SX5")
		aCols[nPos9,2] := Tabela("13",aCols[nPos9,1],.F.)
	Elseif (xTipo == "PAG") //Visao por Condicao de Pagamento
		aCols[nPos9,2] := Posicione("SE4",1,xFilial("SE4")+aCols[nPos9,1],"E4_DESCRI")
	Elseif (xTipo == "DIA") //Visao por Dia
		aCols[nPos9,2] := GB800Semana(stod(aCols[nPos9,1]))
	Endif
	aCols[nPos9,3] := "QTD"
	aCols[nPos9,Len(aHeader)+1] := .F.
	For nx := 1 to Len(aVarPer)
		aCols[nPos9,nCols9+nx] := aPlan9[ni,2,nx]
	Next nx
	aadd(aCols,Array(Len(aHeader)+1))
	nPos9 := Len(aCols)
	aCols[nPos9,1] := Space(1)
	aCols[nPos9,2] := Space(1)
	aCols[nPos9,3] := "VAL"
	aCols[nPos9,Len(aHeader)+1] := .F.
	For nx := 1 to Len(aVarPer)
		aCols[nPos9,nCols9+nx] := aPlan9[ni,3,nx]
	Next nx
Next ni
aadd(aCols,Array(Len(aHeader)+1))
nPos9 := Len(aCols)
aCols[nPos9,1] := "TOTAL >"
aCols[nPos9,2] := Space(1)
aCols[nPos9,3] := "QTD"
aCols[nPos9,Len(aHeader)+1] := .F.
For nx := 1 to Len(aVarPer)
	aCols[nPos9,nCols9+nx] := aTotal9[1,nx]
Next nx
aadd(aCols,Array(Len(aHeader)+1))
nPos9 := Len(aCols)
aCols[nPos9,1] := Space(1)
aCols[nPos9,2] := Space(1)
aCols[nPos9,3] := "VAL"
aCols[nPos9,Len(aHeader)+1] := .F.
For nx := 1 to Len(aVarPer)
	aCols[nPos9,nCols9+nx] := aTotal9[2,nx]
Next nx

Return

Static Function GB800Comparativo()
*****************************
LOCAL oDlgCom, oBold6, oGetCon, oMSGraphic, aInfo6, aPosObj6, aSizeGrf6, aObjects6
LOCAL oGetCom1, oGetCom2, aHeaPer1 := {}, aHeaPer2:= {}, aColPer1 := {}, aColPer2 := {}
LOCAL cTitulo := "GDView Faturamento - Comparativo"

PRIVATE dCOM1DtIni := ctod("//"), dCOM2DtIni := ctod("//")
PRIVATE dCOM1DtFim := ctod("//"), dCOM2DtFim := ctod("//")
                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Crio variavel para aumentar tamanho da fonte                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE FONT oBold6 NAME "Arial" SIZE 0, -12 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto COMPARATIVO                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeaPer1 := {}
aadd(aHeaPer1,{"Periodo 1"     ,"M_PERIO1" ,"@!",15,0,"","","C","",""})
If (n800ConsCon == 1).or.(n800ConsCon == 2)
	aadd(aHeaPer1,{"Quantidade"    ,"M_QUANT1" ,"@E 999,999,999.999",15,3,"","","N","",""})
Endif
If (n800ConsCon != 2)
	aadd(aHeaPer1,{"Total"         ,"M_TOTAL1" ,"@E 999,999,999.99",14,2,"","","N","",""})
Endif
aadd(aHeaPer1,{"% Participacao","M_PARTI1" ,"@E 999999.9999",11,4,"","","N","",""})
aHeaPer2 := {}
aadd(aHeaPer2,{"Periodo 2"     ,"M_PERIO2" ,"@!",15,0,"","","C","",""})
If (n800ConsCon == 1).or.(n800ConsCon == 2)
	aadd(aHeaPer2,{"Quantidade"    ,"M_QUANT2" ,"@E 999,999,999.999",15,3,"","","N","",""})
Endif
If (n800ConsCon != 2)
	aadd(aHeaPer2,{"Total"         ,"M_TOTAL2" ,"@E 999,999,999.99",14,2,"","","N","",""})
Endif
aadd(aHeaPer2,{"% Participacao","M_PARTI2" ,"@E 999999.9999",11,4,"","","N","",""})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Datas iniciais de comparacao                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dCOM1DtIni := ctod("01/01/"+Strzero(Year(dDatabase)-1,4))
dCOM1DtFim := ctod("31/12/"+Strzero(Year(dDatabase)-1,4))
dCOM2DtIni := ctod("01/01/"+Strzero(Year(dDatabase),4))
dCOM2DtFim := ctod("31/12/"+Strzero(Year(dDatabase),4))

//Monto Grafico
///////////////
aObjects6 := {}
aSizeGrf6 := MsAdvSize(,.F.,400)
AAdd(aObjects6,{  0,  30, .T., .F. })
AAdd(aObjects6,{  0,  15, .T., .F. })
AAdd(aObjects6,{  0, 335, .T., .T. })
AAdd(aObjects6,{  0,  25,	.T., .F. })
aInfo6 := {aSizeGrf6[1],aSizeGrf6[2],aSizeGrf6[3],aSizeGrf6[4],3,3}
aPosObj6 := MsObjSize(aInfo6,aObjects6)
DEFINE MSDIALOG oDlgCom FROM 0,0 TO aSizeGrf6[6],aSizeGrf6[5] TITLE cTitulo PIXEL 
@ aPosObj6[1,1],aPosObj6[1,2] SAY o800Ano6 VAR "PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2) OF oDlgCom PIXEL SIZE 245,9 COLOR CLR_BLACK FONT oBold6
@ (aPosObj6[1,1]+14),aPosObj6[1,2] TO (aPosObj6[1,1]+15),(aPosObj[1,4]-aPosObj[1,2]) LABEL "" OF oDlgCom PIXEL    

oSayCom1:= u_GDVSay(oDlgCom,"oSayCom1","Periodo 1 De:",005,aPosObj6[2,1])
oGetCom2:= u_GDVGet(oDlgCom,"dCOM1DtIni","dCOM1DtIni",042,aPosObj6[2,1]-2,50,,{|| .T. },"@E") 
oSayCom3:= u_GDVSay(oDlgCom,"oSayCom3","Ate:",097,aPosObj6[2,1])
oGetCom4:= u_GDVGet(oDlgCom,"dCOM1DtFim","dCOM1DtFim",110,aPosObj6[2,1]-2,50,,{|| .T. },"@E")
oAtuali1:= u_GDVButton(oDlgCom,"oAtuali1","Atualiza",170,aPosObj6[2,1]-2,,,{||GB800CalcCom(oGetCom1,dCOM1DtIni,dCOM1DtFim,"1")})
oGetCom1:= MsNewGetDados():New(aPosObj6[3,1],005,aPosObj6[3,3],(oDlgCom:nClientWidth/4),0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgCom,aHeaPer1,aColPer1)
oGetCom1:oBrowse:bLDblClick := { || GB800Coluna(oGetCom1,oGetCom1:oBrowse:nColPos) }
oGetCom1:oBrowse:lUseDefaultColors := .F.
oGetCom1:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

oSayCom5:= u_GDVSay(oDlgCom,"oSayCom5","Periodo 2 De:",(oDlgCom:nClientWidth/4)+000,aPosObj6[2,1])
oGetCom6:= u_GDVGet(oDlgCom,"dCOM2DtIni","dCOM2DtIni",(oDlgCom:nClientWidth/4)+037,aPosObj6[2,1]-2,50,,{|| .T. },"@E") 
oSayCom7:= u_GDVSay(oDlgCom,"oSayCom7","Ate:",(oDlgCom:nClientWidth/4)+092,aPosObj6[2,1])
oGetCom8:= u_GDVGet(oDlgCom,"dCOM2DtFim","dCOM2DtFim",(oDlgCom:nClientWidth/4)+105,aPosObj6[2,1]-2,50,,{|| .T. },"@E")
oAtuali2:= u_GDVButton(oDlgCom,"oAtuali2","Atualiza",(oDlgCom:nClientWidth/4)+165,aPosObj6[2,1]-2,,,{||GB800CalcCom(oGetCom2,dCOM2DtIni,dCOM2DtFim,"2")})
oGetCom2:= MsNewGetDados():New(aPosObj6[3,1],(oDlgCom:nClientWidth/4),aPosObj6[3,3],(oDlgCom:nClientWidth/2)-5,0,"AllwaysTrue","AllwaysTrue",,,,,,,,oDlgCom,aHeaPer2,aColPer2)
oGetCom2:oBrowse:bLDblClick := { || GB800Coluna(oGetCom2,oGetCom2:oBrowse:nColPos) }
oGetCom2:oBrowse:lUseDefaultColors := .F.
oGetCom2:oBrowse:SetBlkBackColor({||RGB(250,250,250)})

If (n800ConsCon == 1)
	oGrafi1 := u_GDVButton(oDlgCom,"oGrafi1","Compara Quantidade",010,aPosObj6[4,1],90,,{||GB800GrafCom(2,@oGetCom1:aCols,@oGetCom2:aCols)})
	oGrafi2 := u_GDVButton(oDlgCom,"oGrafi2","Compara Faturamento",100,aPosObj6[4,1],90,,{||GB800GrafCom(1,@oGetCom1:aCols,@oGetCom2:aCols)})
	oGrafi3 := u_GDVButton(oDlgCom,"oGrafi2","Compara % Participacao",190,aPosObj6[4,1],90,,{||GB800GrafCom(3,@oGetCom1:aCols,@oGetCom2:aCols)})
Elseif (n800ConsCon == 2)
	oGrafi1 := u_GDVButton(oDlgCom,"oGrafi1","Compara Quantidade",010,aPosObj6[4,1],90,,{||GB800GrafCom(2,@oGetCom1:aCols,@oGetCom2:aCols)})
	oGrafi3 := u_GDVButton(oDlgCom,"oGrafi2","Compara % Participacao",100,aPosObj6[4,1],90,,{||GB800GrafCom(3,@oGetCom1:aCols,@oGetCom2:aCols)})
Elseif (n800ConsCon == 3)
	oGrafi2 := u_GDVButton(oDlgCom,"oGrafi2","Compara Faturamento",010,aPosObj6[4,1],90,,{||GB800GrafCom(1,@oGetCom1:aCols,@oGetCom2:aCols)})
	oGrafi3 := u_GDVButton(oDlgCom,"oGrafi2","Compara % Participacao",100,aPosObj6[4,1],90,,{||GB800GrafCom(3,@oGetCom1:aCols,@oGetCom2:aCols)})
Endif

oFechar := u_GDVButton(oDlgCom,"oButFec","Fechar",aPosObj6[4,4]-050,aPosObj6[4,1],40,,{||oDlgCom:End()})

ACTIVATE MSDIALOG oDlgCom CENTER 

Return

Static Function GB800CalcCom(xObj,xPeri1,xPeri2,xOpca)
*************************************************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busco informacoes                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({||GB800ProcCalcCom(xObj,xPeri1,xPeri2,xOpca)},cCadastro)

Return

Static Function GB800ProcCalcCom(xObj,xPeri1,xPeri2,xOpca)
****************************************************
LOCAL cQuery5, cPeri5, nPos5, nQuant5, nTotal5, aPeri5, ni, nParti5

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrego parametros para consulta                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !GB800Par3(.T.,xOpca)
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monto aCols                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aPeri5 := {} ; nQuant5 := 0 ; nTotal5 := 0
dbSelectArea("MEMP")
Procregua(MEMP->(Reccount()))
dbGotop()
While !MEMP->(Eof())
                            
	Incproc(MEMP->M_codemp+"/"+MEMP->M_codfil+" > Montando Variacao...")

	If !IsMark("M_OK",c800Marca,lInverte)
		dbSelectArea("MEMP")
		MEMP->(dbSkip())
	   Loop
	Endif  
	
	//Monto query para buscar dados de faturamento ano base
	///////////////////////////////////////////////////////
	cQuery5 := "SELECT D2_EMISSAO M_EMISSAO, "
	cQuery5 += "SUM(D2.D2_QUANT) M_QUANT,"
	If (n800ConsIPI == 1) //Sim 
		cQuery5 += "SUM(D2.D2_TOTAL-D2.D2_VALICM-D2.D2_VALIMP5-D2.D2_VALIMP6) M_TOTAL "
	Elseif (n800ConsIPI == 2) //Nao
		cQuery5 += "SUM(D2.D2_VALBRUT) M_TOTAL "
	Endif
	cQuery5 += "FROM "+GB800RetArq("SD2",MEMP->M_codemp)+" D2 "
	cQuery5 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
	cQuery5 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery5 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D2.D2_COD = B1.B1_COD) "
	If !Empty(mv_par09).and.!Empty(mv_par10)
		cQuery5 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D2.D2_CLIENTE = A1.A1_COD AND D2.D2_LOJA = A1.A1_LOJA) "
	Endif
	If !Empty(mv_par15).and.!Empty(mv_par16)
		cQuery5 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
	Endif
	cQuery5 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+GB800RetFil("SD2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery5 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery5 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
	cQuery5 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	If !Empty(mv_par09).and.!Empty(mv_par10)
		cQuery5 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	If !Empty(mv_par15).and.!Empty(mv_par16)
		cQuery5 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
	Endif
	cQuery5 += "AND D2.D2_TIPO NOT IN ('B','D') AND D2.D2_EMISSAO BETWEEN '"+dtos(xPeri1)+"' AND '"+dtos(xPeri2)+"' "
	If !Empty(mv_par01)
		cQuery5 += "AND D2.D2_CLIENTE >= '"+mv_par01+"' "
	Endif
	If !Empty(mv_par02)
		cQuery5 += "AND D2.D2_CLIENTE <= '"+mv_par02+"' "
	Endif
	If !Empty(mv_par03)
		cQuery5 += "AND D2.D2_LOJA >= '"+mv_par03+"' "
	Endif
	If !Empty(mv_par04)
		cQuery5 += "AND D2.D2_LOJA <= '"+mv_par04+"' "
	Endif
	If !Empty(mv_par05)
		cQuery5 += "AND D2.D2_COD >= '"+mv_par05+"' "
	Endif
	If !Empty(mv_par06)
		cQuery5 += "AND D2.D2_COD <= '"+mv_par06+"' "
	Endif
	If !Empty(mv_par07)
		cQuery5 += "AND D2.D2_GRUPO >= '"+mv_par07+"' "
	Endif
	If !Empty(mv_par08)
		cQuery5 += "AND D2.D2_GRUPO <= '"+mv_par08+"' "
	Endif
	If !Empty(mv_par09)
		cQuery5 += "AND A1.A1_SATIV1 >= '"+mv_par09+"' "
	Endif
	If !Empty(mv_par10)
		cQuery5 += "AND A1.A1_SATIV1 <= '"+mv_par10+"' "
	Endif
	If !Empty(mv_par11)
		cQuery5 += "AND D2.D2_TP >= '"+mv_par11+"' "
	Endif
	If !Empty(mv_par12)
		cQuery5 += "AND D2.D2_TP <= '"+mv_par12+"' "
	Endif
	If !Empty(mv_par13)
		cQuery5 += "AND F2.F2_VEND1 >= '"+mv_par13+"' "
	Endif
	If !Empty(mv_par14)
		cQuery5 += "AND F2.F2_VEND1 <= '"+mv_par14+"' "
	Endif
	If !Empty(mv_par15)
		cQuery5 += "AND A3.A3_SUPER >= '"+mv_par15+"' "
	Endif
	If !Empty(mv_par16)
		cQuery5 += "AND A3.A3_SUPER <= '"+mv_par16+"' "
	Endif
	If !Empty(mv_par17)
		cQuery5 += "AND D2.D2_EST >= '"+mv_par17+"' "
	Endif
	If !Empty(mv_par18)
		cQuery5 += "AND D2.D2_EST <= '"+mv_par18+"' "
	Endif
	If (n800ConsFin == 1)
		cQuery5 += "AND F4.F4_DUPLIC = 'S' "
	Elseif (n800ConsFin == 2)
		cQuery5 += "AND F4.F4_DUPLIC = 'N' "
	Endif
	If (n800ConsEst == 1)
		cQuery5 += "AND F4.F4_ESTOQUE = 'S' "
	Elseif (n800ConsEst == 2)
		cQuery5 += "AND F4.F4_ESTOQUE = 'N' "
	Endif
	If !Empty(d800DtSdDe)
		cQuery5 += "AND F2.F2_DTSAIDA >= '"+dtos(d800DtSdDe)+"' "
	Endif
	If !Empty(d800DtSdAte)
		cQuery5 += "AND F2.F2_DTSAIDA <= '"+dtos(d800DtSdAte)+"' "
	Endif
	If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery5 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery5 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	If !Empty(c800BrCfFat)
		cQuery5 += "AND D2.D2_CF IN ("+c800BrCfFat+") "
	Endif
	If !Empty(c800BrCfNFat)
		cQuery5 += "AND D2.D2_CF NOT IN ("+c800BrCfNFat+") "
	Endif
	If !Empty(c800BrTsFat)
		cQuery5 += "AND D2.D2_TES IN ("+c800BrTsFat+") "
	Endif
	If !Empty(c800BrTsNFat)
		cQuery5 += "AND D2.D2_TES NOT IN ("+c800BrTsNFat+") "
	Endif
	cQuery5 += "GROUP BY D2.D2_EMISSAO "
	cQuery5 += "ORDER BY M_EMISSAO "
	cQuery5 := ChangeQuery(cQuery5)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery5 NEW ALIAS "MAR"
	TCSetField("MAR","M_QUANT","N",14,3)
	TCSetField("MAR","M_TOTAL","N",17,2)
	dbSelectArea("MAR")
	While !MAR->(Eof())
		nPos5 := aScan(aPeri5, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
		If (nPos5 == 0)
			aadd(aPeri5,{Substr(MAR->M_emissao,1,6),0,0})
			nPos5 := Len(aPeri5)
		Endif
		aPeri5[nPos5,2] += MAR->M_quant 
		aPeri5[nPos5,3] += MAR->M_total
		nQuant5 += MAR->M_quant 
		nTotal5 += MAR->M_total
		dbSelectArea("MAR")
		MAR->(dbSkip())
	Enddo

	//Monto query para buscar dados de devolucao ano base
	/////////////////////////////////////////////////////
	If (n800ConsDev == 1)
		cQuery5 := "SELECT D1_DTDIGIT M_EMISSAO, "
		cQuery5 += "SUM(D1.D1_QUANT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim
			cQuery5 += "SUM(D1.D1_TOTAL-D1.D1_VALICM-D1.D1_VALIMP5-D1.D1_VALIMP6-D1.D1_VALDESC) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery5 += "SUM(D1.D1_TOTAL+D1.D1_VALIPI+D1.D1_ICMSRET-D1.D1_VALDESC+D1.D1_VALFRE) M_TOTAL "
		Endif
		cQuery5 += "FROM "+GB800RetArq("SD1",MEMP->M_codemp)+" D1 "
		cQuery5 += "INNER JOIN "+GB800RetArq("SF1",MEMP->M_codemp)+" F1 ON (D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (D1.D1_COD = B1.B1_COD) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (D1.D1_FORNECE = A1.A1_COD AND D1.D1_LOJA = A1.A1_LOJA) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (F2.F2_VEND1 = A3.A3_COD) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SF2",MEMP->M_codemp)+" F2 ON (D1.D1_NFORI = F2.F2_DOC AND D1.D1_SERIORI = F2.F2_SERIE AND D1.D1_FORNECE = F2.F2_CLIENTE AND D1.D1_LOJA = F2.F2_LOJA) "
		cQuery5 += "WHERE D1.D_E_L_E_T_ = '' AND D1.D1_FILIAL = '"+GB800RetFil("SD1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND F1.D_E_L_E_T_ = '' AND F1.F1_FILIAL = '"+GB800RetFil("SF1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+GB800RetFil("SF2",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND D1.D1_TIPO = 'D' AND D1.D1_DTDIGIT BETWEEN '"+dtos(xPeri1)+"' AND '"+dtos(xPeri2)+"' "
		If !Empty(mv_par01)
			cQuery5 += "AND D1.D1_FORNECE >= '"+mv_par01+"' "
		Endif
		If !Empty(mv_par02)
			cQuery5 += "AND D1.D1_FORNECE <= '"+mv_par02+"' "
		Endif
		If !Empty(mv_par03)
			cQuery5 += "AND D1.D1_LOJA >= '"+mv_par03+"' "
		Endif
		If !Empty(mv_par04)
			cQuery5 += "AND D1.D1_LOJA <= '"+mv_par04+"' "
		Endif
		If !Empty(mv_par05)
			cQuery5 += "AND D1.D1_COD >= '"+mv_par05+"' "
		Endif
		If !Empty(mv_par06)
			cQuery5 += "AND D1.D1_COD <= '"+mv_par06+"' "
		Endif
		If !Empty(mv_par07)
			cQuery5 += "AND D1.D1_GRUPO >= '"+mv_par07+"' "
		Endif
		If !Empty(mv_par08)
			cQuery5 += "AND D1.D1_GRUPO <= '"+mv_par08+"' "
		Endif
		If !Empty(mv_par09)
			cQuery5 += "AND A1.A1_SATIV1 >= '"+mv_par09+"' "
		Endif
		If !Empty(mv_par10)
			cQuery5 += "AND A1.A1_SATIV1 <= '"+mv_par10+"' "
		Endif
		If !Empty(mv_par11)
			cQuery5 += "AND D1.D1_TP >= '"+mv_par11+"' "
		Endif
		If !Empty(mv_par12)
			cQuery5 += "AND D1.D1_TP <= '"+mv_par12+"' "
		Endif
		If !Empty(mv_par13)
			cQuery5 += "AND F2.F2_VEND1 >= '"+mv_par13+"' "
		Endif
		If !Empty(mv_par14)
			cQuery5 += "AND F2.F2_VEND1 <= '"+mv_par14+"' "
		Endif
		If !Empty(mv_par15)
			cQuery5 += "AND A3.A3_SUPER >= '"+mv_par15+"' "
		Endif
		If !Empty(mv_par16)
			cQuery5 += "AND A3.A3_SUPER <= '"+mv_par16+"' "
		Endif
		If (n800ConsFin == 1)
			cQuery5 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery5 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery5 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery5 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery5 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
			Else
				cQuery5 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		cQuery5 += "GROUP BY D1.D1_DTDIGIT "
		cQuery5 += "ORDER BY M_EMISSAO "
		cQuery5 := ChangeQuery(cQuery5)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery5 NEW ALIAS "MAR"
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos5 := aScan(aPeri5, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
			If (nPos5 == 0)
				aadd(aPeri5,{Substr(MAR->M_emissao,1,6),0,0})
				nPos5 := Len(aPeri5)
			Endif
			aPeri5[nPos5,2] -= MAR->M_quant 
			aPeri5[nPos5,3] -= MAR->M_total
			nQuant5 -= MAR->M_quant 
			nTotal5 -= MAR->M_total
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif

	//Monto query para buscar dados de carteira ano base
	////////////////////////////////////////////////////
	If (n800ConsCar == 1)
		cQuery5 := "SELECT C6.C6_ENTREG M_EMISSAO,C5.C5_MOEDA M_MOEDA, "
		cQuery5 += "SUM(C6.C6_QTDVEN-C6.C6_QTDENT) M_QUANT,"
		If (n800ConsIPI == 1) //Sim
			cQuery5 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCLIQ) M_TOTAL "
		Elseif (n800ConsIPI == 2) //Nao
			cQuery5 += "SUM((C6.C6_QTDVEN-C6.C6_QTDENT)*C6.C6_PRCVEN) M_TOTAL "
		Endif
		cQuery5 += "FROM "+GB800RetArq("SC6",MEMP->M_codemp)+" C6 "
		cQuery5 += "INNER JOIN "+GB800RetArq("SF4",MEMP->M_codemp)+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SC5",MEMP->M_codemp)+" C5 ON (C6.C6_NUM = C5.C5_NUM) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SA1",MEMP->M_codemp)+" A1 ON (C6.C6_CLI = A1.A1_COD AND C6.C6_LOJA = A1.A1_LOJA) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SB1",MEMP->M_codemp)+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
		cQuery5 += "INNER JOIN "+GB800RetArq("SA3",MEMP->M_codemp)+" A3 ON (C5.C5_VEND1 = A3.A3_COD) "
		cQuery5 += "WHERE C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+GB800RetFil("SC6",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND C5.D_E_L_E_T_ = '' AND C5.C5_FILIAL = '"+GB800RetFil("SC5",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+GB800RetFil("SF4",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND A1.D_E_L_E_T_ = '' AND A1.A1_FILIAL = '"+GB800RetFil("SA1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+GB800RetFil("SB1",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND A3.D_E_L_E_T_ = '' AND A3.A3_FILIAL = '"+GB800RetFil("SA3",MEMP->M_codemp,MEMP->M_codfil)+"' "
		cQuery5 += "AND C5.C5_TIPO = 'N' AND C6.C6_QTDVEN > C6.C6_QTDENT AND C6.C6_BLQ <> 'R' "
		cQuery5 += "AND C6.C6_ENTREG BETWEEN '"+dtos(xPeri1)+"' AND '"+dtos(xPeri2)+"' "
		If !Empty(mv_par01)
			cQuery5 += "AND C6.C6_CLI >= '"+mv_par01+"' "
		Endif
		If !Empty(mv_par02)
			cQuery5 += "AND C6.C6_CLI <= '"+mv_par02+"' "
		Endif
		If !Empty(mv_par03)
			cQuery5 += "AND C6.C6_LOJA >= '"+mv_par03+"' "
		Endif
		If !Empty(mv_par04)
			cQuery5 += "AND C6.C6_LOJA <= '"+mv_par04+"' "
		Endif
		If !Empty(mv_par05)
			cQuery5 += "AND C6.C6_PRODUTO >= '"+mv_par05+"' "
		Endif
		If !Empty(mv_par06)
			cQuery5 += "AND C6.C6_PRODUTO <= '"+mv_par06+"' "
		Endif
		If !Empty(mv_par07)
			cQuery5 += "AND B1.B1_GRUPO >= '"+mv_par07+"' "
		Endif
		If !Empty(mv_par08)
			cQuery5 += "AND B1.B1_GRUPO <= '"+mv_par08+"' "
		Endif
		If !Empty(mv_par09)
			cQuery5 += "AND A1.A1_SATIV1 >= '"+mv_par09+"' "
		Endif
		If !Empty(mv_par10)
			cQuery5 += "AND A1.A1_SATIV1 <= '"+mv_par10+"' "
		Endif
		If !Empty(mv_par11)
			cQuery5 += "AND B1.B1_TIPO >= '"+mv_par11+"' "
		Endif
		If !Empty(mv_par12)
			cQuery5 += "AND B1.B1_TIPO <= '"+mv_par12+"' "
		Endif
		If !Empty(mv_par13)
			cQuery5 += "AND C5.C5_VEND1 >= '"+mv_par13+"' "
		Endif
		If !Empty(mv_par14)
			cQuery5 += "AND C5.C5_VEND1 <= '"+mv_par14+"' "
		Endif
		If !Empty(mv_par15)
			cQuery5 += "AND A3.A3_SUPER >= '"+mv_par15+"' "
		Endif
		If !Empty(mv_par16)
			cQuery5 += "AND A3.A3_SUPER <= '"+mv_par16+"' "
		Endif
		If (n800ConsFin == 1)
			cQuery5 += "AND F4.F4_DUPLIC = 'S' "
		Elseif (n800ConsFin == 2)
			cQuery5 += "AND F4.F4_DUPLIC = 'N' "
		Endif
		If (n800ConsEst == 1)
			cQuery5 += "AND F4.F4_ESTOQUE = 'S' "
		Elseif (n800ConsEst == 2)
			cQuery5 += "AND F4.F4_ESTOQUE = 'N' "
		Endif
		If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
			cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
			If !Empty(cCodRep)
				cQuery5 += "AND C5.C5_VEND1 IN ("+cCodRep+") "
			Else
				cQuery5 += "AND C5.C5_VEND1 = 'ZZZZZZ' "
			Endif
		Endif	
		If !Empty(c800BrCfFat)
			cQuery5 += "AND C6.C6_CF IN ("+c800BrCfFat+") "
		Endif
		If !Empty(c800BrCfNFat)
			cQuery5 += "AND C6.C6_CF NOT IN ("+c800BrCfNFat+") "
		Endif
		If !Empty(c800BrTsFat)
			cQuery5 += "AND C6.C6_TES IN ("+c800BrTsFat+") "
		Endif
		If !Empty(c800BrTsNFat)
			cQuery5 += "AND C6.C6_TES NOT IN ("+c800BrTsNFat+") "
		Endif
		cQuery5 := ChangeQuery(cQuery5)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		cQuery5 += "GROUP BY C6.C6_ENTREG,C5.C5_MOEDA "
		cQuery5 += "ORDER BY M_EMISSAO "
		TCQuery cQuery5 NEW ALIAS "MAR"
		TCSetField("MAR","M_QUANT","N",14,3)
		TCSetField("MAR","M_TOTAL","N",17,2)
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nPos5 := aScan(aPeri5, {|x| x[1] == Substr(MAR->M_emissao,1,6) })
			If (nPos5 == 0)
				aadd(aPeri5,{Substr(MAR->M_emissao,1,6),0,0})
				nPos5 := Len(aPeri5)
			Endif
			nValor := xMoeda(MAR->M_total,MAR->M_moeda,1,d800UltDtMoeda)
			aPeri5[nPos5,2] += MAR->M_quant 
			aPeri5[nPos5,3] += nValor
			nQuant5 += MAR->M_quant 
			nTotal5 += nValor
			dbSelectArea("MAR")
			MAR->(dbSkip())
		Enddo
	Endif
		
	dbSelectArea("MEMP")
	MEMP->(dbSkip())
Enddo 
MEMP->(dbGotop())    
                        
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo aCols                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCols := {}
For ni := 1 to Len(aPeri5)
	cPeri5 := aPeri5[ni,1]+" - "+Upper(Substr(MesExtenso(Val(Substr(aPeri5[ni,1],5,2))),1,3))
	nParti5:= 0
	If (n800ConsCon == 1)
		If (nTotal5 > 0)
			nParti5 := (aPeri5[ni,3]/nTotal5)*100
		Endif
		aadd(aCols,{cPeri5,aPeri5[ni,2],aPeri5[ni,3],nParti5,.F.})
	Elseif (n800ConsCon == 2)
		If (nQuant5 > 0)
			nParti5 := (aPeri5[ni,2]/nTotal5)*100
		Endif
		aadd(aCols,{cPeri5,aPeri5[ni,2],nParti5,.F.})
	Elseif (n800ConsCon == 3)
		If (nTotal5 > 0)
			nParti5 := (aPeri5[ni,3]/nTotal5)*100
		Endif
		aadd(aCols,{cPeri5,aPeri5[ni,3],nParti5,.F.})
	Endif
Next ni
If (nQuant5 > 0).or.(nTotal5 > 0)
	If (n800ConsCon == 1)
		aadd(aCols,{"TOTAL >",nQuant5,nTotal5,100,.F.})
	Elseif (n800ConsCon == 2)
		aadd(aCols,{"TOTAL >",nQuant5,100,.F.})
	Elseif (n800ConsCon == 3)
		aadd(aCols,{"TOTAL >",nTotal5,100,.F.})
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualizo objeto solicitado                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (xObj != Nil)
	xObj:aCols := aClone(aCols)
	xObj:Refresh()
Endif	

Return

Static Function GB800MetaSCT(xEmp,xFil,xValor,xPeriodo)
**************************************************
LOCAL nRetu := 0, ni := 0, cPeri, cChave4, cCampo4, cQuery1, cCodRep

//Busco meta
////////////
cQuery1 := "SELECT SUM(CT_QUANT) M_QUANT,SUM(CT_VALOR) M_VALOR "
cQuery1 += "FROM "+GB800RetArq("SCT",xEmp)+" CT "
cQuery1 += "WHERE CT.D_E_L_E_T_ = '' AND CT.CT_FILIAL = '"+GB800RetFil("SCT",xEmp,xFil)+"' "
If (xPeriodo != Nil)
	cQuery1 += "AND CT.CT_DATA BETWEEN '"+Left(dtos(xPeriodo),6)+"' AND '"+Left(dtos(xPeriodo),6)+"ZZ' "
Else
	cQuery1 += "AND CT.CT_DATA BETWEEN '"+dtos(d800Peri1)+"' AND '"+dtos(d800Peri2)+"' "
Endif
If ExistBlock("BXRepAdm").and.(!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
	If !Empty(cCodRep)
		cQuery1 += "AND CT.CT_VEND IN ("+cCodRep+") "
	Endif
Endif
For ni := 1 to Len(a800Filtro)
	cChave4 := GB800RetAlias("SCT",xEmp)
	cCampo4 := "CT_"+Alltrim(Substr(a800Filtro[ni,2],AT("_",a800Filtro[ni,2])+1))
	If ("TP" $ cCampo4)
		cCampo4 := "CT_TIPO"
	Elseif ("VEND" $ cCampo4) 
		cCampo4 := "CT_VEND"
	Endif
	If ((cChave4)->(FieldPos(cCampo4)) > 0).and.(xValor != Nil)
		cQuery1 += "AND CT."+cCampo4+" = '"+iif(ni==Len(a800Filtro),xValor,a800Filtro[ni+1,3])+"' "
	Else
		Return nRetu
	Endif
Next ni
cQuery1 := ChangeQuery(cQuery1)
If (Select("META") <> 0)
	dbSelectArea("META")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "META"
TCSetField("META","M_QUANT","N",14,3)
TCSetField("META","M_VALOR","N",17,2)
dbSelectArea("META")
If !META->(Eof())
	If (n800ConsCon != 2)
		nRetu += META->M_VALOR
	Else
		nRetu += META->M_QUANT
	Endif
Endif	
If (Select("META") <> 0)
	dbSelectArea("META")
	dbCloseArea()
Endif

Return nRetu


/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////

Static Function GB800ExpExcel(xHeader,xCols,xClasseA,xClasseB,xClasseC)
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
	fWrite(nHandle,":: PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2)) // Titulo
	fWrite(nHandle,cCrLf) // Pula linha
	fWrite(nHandle,":: FILTRO: "+c800Filtro) // Filtro
	fWrite(nHandle,cCrLf) // Pula linha
	fWrite(nHandle,Space(4)+c800DesFil) // Filtro
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

Static Function GB800Imprime(xHeader,xCols,xClasseA,xClasseB,xClasseC)
**************************************************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1         := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2         := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3         := ""
LOCAL cPict          := ""
LOCAL titulo         := "GDView Faturamento"
LOCAL nLin           := 80
LOCAL Cabec1         := ""
LOCAL Cabec2         := ""
LOCAL imprime        := .T.
LOCAL aOrd           := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 132
PRIVATE tamanho      := "M"
PRIVATE nomeprog     := "GBRA800" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",1,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "GBRA800" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "SD2"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico se objeto esta criado                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Len(xCols) <= 0)
	MsgInfo("> Sem dados para exibir!","ATENCAO")
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
LOCAL nPos5, nCol5, cAux5, nx, ny
   
Cabec1 := ":: PERIODO: "+dtoc(d800Peri1)+" - "+dtoc(d800Peri2)+Space(10)+c800Filtro
Cabec2 := ""
For ny := 1 to Len(xHeader)
	cAux5  := Alltrim(xHeader[ny,1])
	nCol5  := Max(xHeader[ny,4],Len(xHeader[ny,1]))+2
	Cabec2 += cAux5+Space(nCol5-Len(cAux5))
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

	nCol5 := 0                    
   For ny := 1 to Len(xHeader) 
		If !Empty(xCols[nx,ny]).and.(xHeader[ny,8] == "C")
			@nLin,nCol5 PSAY Alltrim(Substr(xCols[nx,ny],1,xHeader[ny,4]))
		Elseif (xHeader[ny,8] == "N")
			@nLin,nCol5 PSAY Transform(xCols[nx,ny],xHeader[ny,3])
		Elseif (xHeader[ny,8] == "D")
			@nLin,nCol5 PSAY dtoc(xCols[nx,ny])
		Endif
		nCol5 += Max(xHeader[ny,4],Len(xHeader[ny,1]))+2
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

Static Function GB800Coluna(xObj,xCol,xLin,xTipo)
********************************************
LOCAL oCalcCol := Nil, nTotal := 0, nOpcy := 0, nY, nX, lFaz := .F.
LOCAL lProduto := .F., nContax := 0, nQuantx := 0, aSegx := GetArea()

//Monto tela para solicitar complemento
///////////////////////////////////////
If (xObj == Nil).or.(xCol <= 0)
	Return
Endif
lProduto := (xTipo != Nil).and.(xTipo == "PRO")
DEFINE MSDIALOG oCalcCol TITLE "Calcula Coluna "+Alltrim(xObj:aHeader[xCol,2]) FROM 0,0 TO iif(lProduto,240,123),195 PIXEL OF oDlgGer
xObj:oBrowse:nAt := 1 ; xObj:oBrowse:nRowPos := xObj:oBrowse:nAt
@ 008,010 BUTTON "Pesquisar" SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=0,u_GDVSeekCols(xObj,"Pesquisar...",@xObj:aHeader,@xObj:aCols,.F.),oCalcCol:End())
@ 020,010 BUTTON "Conta "+Alltrim(xObj:aHeader[xCol,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=1,oCalcCol:End())
@ 032,010 BUTTON "Soma "+Alltrim(xObj:aHeader[xCol,1])  SIZE 80,10 OF oCalcCol PIXEL WHEN (xObj:aHeader[xCol,8]=="N") ACTION (nOpcy:=2,oCalcCol:End())
@ 044,010 BUTTON "Media "+Alltrim(xObj:aHeader[xCol,1]) SIZE 80,10 OF oCalcCol PIXEL WHEN (xObj:aHeader[xCol,8]=="N") ACTION (nOpcy:=3,oCalcCol:End())
If (lProduto)
	@ 056,010 BUTTON "Consulta Produto "+Alltrim(xObj:aCols[xLin,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=4,oCalcCol:End())
	@ 068,010 BUTTON "Consulta Kardex "+Alltrim(xObj:aCols[xLin,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=5,oCalcCol:End())
	@ 080,010 BUTTON "GDView Produto "+Alltrim(xObj:aCols[xLin,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=6,oCalcCol:End())
	@ 092,010 BUTTON "GDView Historico "+Alltrim(xObj:aCols[xLin,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=7,oCalcCol:End())
	If VerSenha(107).and.(cNivel >= 6) //Permite consulta a Formacao de Precos
		@ 104,010 BUTTON "Formacao Preco "+Alltrim(xObj:aCols[xLin,1]) SIZE 80,10 OF oCalcCol PIXEL ACTION (nOpcy:=8,oCalcCol:End())
	Endif
Endif
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
Elseif (nOpcy == 4) //Produto
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xObj:aCols[xLin,1]))
		MaComView(xObj:aCols[xLin,1])
	Endif
	RestArea(aSegx)
Elseif (nOpcy == 5) //Kardex
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xObj:aCols[xLin,1]))
		If Pergunte("MTC030",.T.)
			MC030Con()
		EndIf
	Endif
	RestArea(aSegx)
Elseif (nOpcy == 6) //Consulta Geral
	INCLUI := .F. ; ALTERA := .F.
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xObj:aCols[xLin,1]))
		If ExistBlock("GDVA010")
			MsgRun('Montando a consulta. Aguarde... ','',{ || u_GDVA010() })
		Endif
	Endif
Elseif (nOpcy == 7) //Historico
	INCLUI := .F. ; ALTERA := .F.
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xObj:aCols[xLin,1]))
		If ExistBlock("GDVHISTMAN")
			u_GDVHistMan("SB1",.T.)
		Endif
	Endif
	RestArea(aSegx)
Elseif (nOpcy == 8) //Formacao de Preco
	cArqMemo   := "STANDARD"
	lDirecao   := .T.
	nQualCusto := 1
	cProg      := "C010"
	nQuantx    := 1000
	nPosx := aScan(xObj:aHeader,{|x| Alltrim(x[2])=="M_QUANT" })
	If (nPosx > 0).and.(xObj:aCols[xLin,nPosx] < 10000)
		nQuantx := xObj:aCols[xLin,nPosx]
	Endif
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xObj:aCols[xLin,1]))
		If Pergunte("MTC010",.T.)
			MC010Forma("SB1",SB1->(Recno()),98,nQuantx,2)
		Endif
	Endif
	RestArea(aSegx)
Endif

Return

Static Function GB800VerifCab(xHeader,xCols,xLin)
*******************************************
LOCAL lRetu := .T., nX
For nX := 1 to Len(xHeader)
	If (xHeader[nX,8] == "C").and.(xHeader[nX,4] >= 5).and.(Left(xCols[xLin,nX],5) $ "TOTAL/OUTRO")
		lRetu := .F.
		Exit
	Endif
Next nX
Return lRetu

Static Function GB800Semana(xData)
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

Static Function GB800Ordena(xOpcx,xGetCon)
*************************************
LOCAL aCols1, aCols2, nAux
nAux := Len(xGetCon:aCols)
aCols1 := aClone(xGetCon:aCols[nAux])
aCols2 := aClone(xGetCon:aCols)
aDel(aCols2,nAux)
aSize(aCols2,nAux-1)
If (l800OrdCres)
	aSort(aCols2,,,{|x,y| x[xOpcx]<y[xOpcx]})
Else
	aSort(aCols2,,,{|x,y| x[xOpcx]>y[xOpcx]})
Endif
aadd(aCols2,aCols1)
xGetCon:aCols := aClone(aCols2)
xGetCon:oBrowse:Refresh()
Return

Static Function GB800CorCla(xHeader,xCols,xAt)
****************************************
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

Static Function GB800CorAna(xHeader,xCols,xAt)
****************************************
LOCAL nRetu := RGB(250,250,250)
Return nRetu

Static Function GB800Nota(xCliente,xLoja,xAnoMes)
********************************************
LOCAL cQuery2 := "", aRetu2 := {ctod("//"),Space(9),Space(3)}
cQuery2 := "SELECT TOP 1 F2_EMISSAO,F2_DOC,F2_SERIE FROM "+RetSqlName("SF2")+" X "
cQuery2 += "WHERE X.D_E_L_E_T_ = '' AND X.F2_FILIAL = '"+xFilial("SF2")+"' AND X.F2_TIPO = 'N' "
cQuery2 += "AND X.F2_CLIENTE = '"+xCliente+"' AND X.F2_LOJA = '"+xLoja+"' AND X.F2_DUPL <> '' "
cQuery2 += "AND NOT X.F2_EMISSAO BETWEEN '"+xAnoMes+"' AND '"+xAnoMes+"99' "
cQuery2 += "ORDER BY F2_EMISSAO DESC,F2_DOC DESC "
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
cQuery2 := ChangeQuery(cQuery2)
TCQuery cQuery2 NEW ALIAS "MSF2"                            
TCSetField("MSF2","F2_EMISSAO","D",08,0)
If !MSF2->(Eof())
	aRetu2 := {MSF2->F2_emissao,MSF2->F2_doc,MSF2->F2_serie}
Endif
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
Return aRetu2

Static Function G800PrazoMedio(xAnoMes)
***********************************
LOCAL cQuery2 := "", nRetu2 := 0
cQuery2 := "SELECT SUM(E1_VALOR) VALOR1, SUM(DATEDIFF(dd,Convert(Varchar,F2_EMISSAO,112),Convert(Varchar,E1_VENCREA,112))*E1_VALOR) VALOR2 "
cQuery2 += "FROM "+RetSqlName("SF2")+" SF2,"+RetSqlName("SE1")+" SE1 "
cQuery2 += "WHERE SF2.D_E_L_E_T_ = '' AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.F2_TIPO = 'N' "
cQuery2 += "AND SE1.D_E_L_E_T_ = '' AND SE1.E1_FILIAL = '"+xFilial("SE1")+"' AND SF2.F2_DUPL = SE1.E1_NUM "
cQuery2 += "AND SF2.F2_CLIENTE = SE1.E1_CLIENTE AND SF2.F2_LOJA = SE1.E1_LOJA "
cQuery2 += "AND SF2.F2_EMISSAO BETWEEN '"+xAnoMes+"' AND '"+xAnoMes+"99' "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery2 NEW ALIAS "MAR"
If !MAR->(Eof()).and.(MAR->VALOR1 > 0)
	nRetu2 := Round(MAR->VALOR2/MAR->VALOR1,2)
Endif
If (Select("MAR") <> 0)
	dbSelectArea("MAR") 
	dbCloseArea()
Endif
Return nRetu2