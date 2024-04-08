/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualização                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! BFATC001                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Consulta de situação de pedidos (Mapa Operacional)      !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 05/01/2012                                              !
+------------------+---------------------------------------------------------+
*/

#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function BFATC001()
**********************
Local aFolder := {'Estoque','Ent. Ped.','Financeiro','Faturamento'}

U_BCFGA002("BFATC001")//Grava detalhes da rotina usada

//============= VARIAVEIS ABA ESTOQUE =============//
Private cLocalDe  := "  "
Private cLocalAte := "99"

Private aOpcEst   := {"1=Produto","2=Tipo Produto","3=Grupo de Produto"}
Private cOpcEst   := SUBSTR(aOpcEst[1],1,1)

Private cAliasEst := GetNextAlias()
Private aEstoque  := {}
Private cPesEst   := Space(200)

//============= VARIAVEIS ABA ENTRADA DE PEDIDOS =============//
Private aOpcPed  := {"1=Pedido","2=Grupo Clientes","3=Grupo Produto"}
Private cOpcPed  := SUBSTR(aOpcPed[1],1,1)
Private oFont := TFont():New("Courier New",0,14,,.T.,,,,,.F.,.F.)

Private aPedidos := {}
Private dDataEnt := DDATABASE
Private aTotPed  := {}

//============= VARIAVEIS ABA FATURAMENTO =============//
Private oOk      := LoadBitMap(GetResources(), "CHECKOK")
Private oNo      := LoadBitMap(GetResources(), "UPDERROR")
Private oAt      := LoadBitMap(GetResources(), "UPDWARNING")

Private aFatura  := {}

Private cProduto := SPACE(TAMSX3("B1_COD")[1])
Private cPedido  := SPACE(TAMSX3("C5_NUM")[1])
Private cCliente := SPACE(TAMSX3("A1_COD")[1])
Private cLoja    := SPACE(TAMSX3("A1_LOJA")[1])
Private cNome    := SPACE(TAMSX3("A1_NOME")[1])
Private cFamilia := SPACE(TAMSX3("B1_GRUPO")[1])
Private dEntDe   := CTOD("  /  /  ")
Private dEntAte  := DDATABASE

Private nValMin  := SuperGetMv("BR_VALMIN")

Private aOpcao   := {"1=Todos","2=Pend. Liberação","3=Rej. Crédito","4=Item sem Estoque","5=Pedidos sem Estoque","6=Pend. Anal. Créd.","7=Aptos a Faturar"}
Private cOpcao   := SUBSTR(aOpcao[1],1,1)

Private aOrdem   := {"1=Produto","2=Pedido","3=Cliente"}
Private cOrdem   := SUBSTR(aOrdem[1],1,1)

Private aFilFat   := {"01=Joinville","03=Franca","00=Ambas"}
Private cFilFat   := cFilAnt //variável que guarda a filial corrente

Private cFiltroSC9  := ""
Private cFiltroSC6  := ""

//============= VARIAVEIS ABA FINANCEIRO =============//
Private aOpcCart   := {"1=Pagar","2=Receber"}
Private cOpcCArt   := SUBSTR(aOpcao[2],1,1)
Private cF3CliFor  := ""
Private cCliFor    := Space(TAMSX3("A1_COD")[1])
Private cFinLoj    := Space(TAMSX3("A1_LOJA")[1])
Private cFinNom    := Space(TAMSX3("A1_NOME")[1])
Private dFinEmiDe  := CTOD("  /  /  ")
Private dFinEmiAte := DDATABASE
Private dFinVctDe  := CTOD("  /  /  ")
Private dFinVctAte := DDATABASE
Private cTitFin    := Space(TAMSX3("E1_NUM")[1])
Private aTipFin    := {"1=Todos","2=Em Aberto","3=Vencidos"}
Private cTipFin    := aTipFin[1]
Private aFilFin    := {"01=Joinville","03=Franca","00=Ambas"}
Private cFilFin    := cFilAnt
Private cNomFin    := Space(TAMSX3("E1_NOMCLI")[1])

//=================================================//
Private aRotina := {{ "Pesquisar" , "AxPesqui" , 0 , 1},;
	{ "Visualizar", "AxVisual" , 0 , 2},;
	{ "Incluir"   , "AxInclui" , 0 , 3},;
	{ "Alterar"   , "AxAltera" , 0 , 4, 20 },;
	{ "Excluir"   , "AxExclui" , 0 , 5, 21 }}

DEFINE MSDIALOG oDlgMapa TITLE "[BFATC001] - Mapa Operacional" From 001,001 to 580,900 Pixel

oFolder := TFolder():New(000,000,aFolder,,oDlgMapa,,,,.T.,,500,300 )
oFolder:SetOption(4)

//======================================================== ABA ESTOQUE ========================================================//
oGrpFilEst := tGroup():New(005,005,032,445,"Filtros",oFolder:aDialogs[1],CLR_HBLUE,,.T.)

oSayLocDe  := tSay():New(017,010,{|| "Armazem de:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLocDe  := tGet():New(015,045,{|u| if(PCount()>0,cLocalDe:=u,cLocalDe)}, oGrpFilEst,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLocalDe')

oSayLocAte := tSay():New(017,070,{|| "Ate"  },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLocAte := tGet():New(015,085,{|u| if(PCount()>0,cLocalAte:=u,cLocalAte)}, oGrpFilEst,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLocalAte')

oSayOpcEst := tSay():New(017,120,{|| "Aglutinar por:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpcEst := tComboBox():New(015,160,{|u|if(PCount()>0,cOpcEst:=u,cOpcEst)},aOpcEst,70,9,oGrpFilEst,, { || cPesEst := Space(200) } ,,,,.T.,,,,,,,,,'cOpcEst')

oSayPesEst := tSay():New(017,250,{|| "Pesquisar:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetPesEst := tGet():New(015,280,{|u| if(PCount()>0,cPesEst:=u,cPesEst)}, oGrpFilEst,110,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cPesEst')

oBtnAtuEst := tButton():New(015, 400, "Atualizar" , oGrpFilEst, { || Processa({|| fAtuEst() }, "[BFATC001] - AGUARDE") },40,12,,,,.T.,,,,,,)

oGrpEst := tGroup():New(037,005,257,445,"Estoques", oFolder:aDialogs[1],CLR_HBLUE,,.T.)

oBrwEst := MyGrid():New(oGrpEst,047,010,430,205,15)
oBrwEst:LDblClick({|| fSaldoAtu() })

//======================================================== ABA ENTRADA DE PEDIDOS ========================================================//
oSayOpcP := tSay():New(007,005,{|| "Opções:" },oFolder:aDialogs[2],,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpcP := tComboBox():New(005,035,{|u|if(PCount()>0,cOpcPed:=u,cOpcPed)},aOpcPed,70,9,oFolder:aDialogs[2],, { ||  } ,,,,.T.,,,,,,,,,'cOpcPed')

oSayDatEnt := tSay():New(007,125,{|| "Data:" },oFolder:aDialogs[2],,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetDatEnt := tGet():New(005,150,{|u| if(PCount()>0,dDataEnt:=u,dDataEnt)},oFolder:aDialogs[2],50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dDataEnt')

oBtnAtuEnt := tButton():New(005, 400, "Atualizar" , oFolder:aDialogs[2], { || Processa({|| fAtuPed() }, "[BFATC001] - AGUARDE") },40,12,,,,.T.,,,,,,)

oGrpEnt := tGroup():New(020,005,170,445,, oFolder:aDialogs[2],CLR_HBLUE,,.T.)

oBrwPed := MyGrid():New(oGrpEnt,025,010,430,140,9)

oGrpTotMes := tGroup():New(175,005,255,220,"Pedidos que entraram no mês " + STRZERO(MONTH(dDataEnt),2) +"/" + ALLTRIM(STR(YEAR(dDataEnt))), oFolder:aDialogs[2],CLR_HBLUE,,.T.)

oBrwTotMes := TCBrowse():New(185,010,205,065,,,,oGrpTotMes,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotMes:AddColumn(TCColumn():New("Entrega p/ Mês" , {|| aTotPed[oBrwTotMes:nAt,01]},,,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Atual"          , {|| aTotPed[oBrwTotMes:nAt,02]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Futuro"         , {|| aTotPed[oBrwTotMes:nAt,03]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Total"          , {|| aTotPed[oBrwTotMes:nAt,04]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:SetArray(aTotPed)

oGrpTotDia := tGroup():New(175,225,255,445,"Pedidos que entraram no dia " + DTOC(dDataEnt), oFolder:aDialogs[2],CLR_HBLUE,,.T.)

oBrwTotDia := TCBrowse():New(185,230,210,065,,,,oGrpTotDia,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotDia:AddColumn(TCColumn():New("Entrega p/ Mês" , {|| aTotPed[oBrwTotDia:nAt,01]},,,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Atual"          , {|| aTotPed[oBrwTotDia:nAt,05]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Futuro"         , {|| aTotPed[oBrwTotDia:nAt,06]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Total"          , {|| aTotPed[oBrwTotDia:nAt,07]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:SetArray(aTotPed)

//========================================================== ABA FINANCEIRO ==========================================================//
oGrpFilFin := tGroup():New(005,005,060,445,"Filtros",oFolder:aDialogs[3],CLR_HBLUE,,.T.)

oSayCartei := tSay():New(017,010,{|| "Carteira:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbCartei := tComboBox():New(015,040,{|u|if(PCount()>0,cOpcCart:=u,cOpcCart)},aOpcCart,50,9,oGrpFilFin,, { ||  } ,,,,.T.,,,,,,,,,'cOpcCart')

oSayCliFor := tSay():New(017,105,,oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetCliFor := tGet():New(015,135,{|u| if(PCount()>0,cCliFor:=u,cCliFor)}, oGrpFilFin,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cCliFor')
oGetFinLoj := tGet():New(015,190,{|u| if(PCount()>0,cFinLoj:=u,cFinLoj)}, oGrpFilFin,25,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cFinLoj')
oGetFinNom := tGet():New(015,220,{|u| if(PCount()>0,cFinNom:=u,cFinNom)}, oGrpFilFin,150,9,'@!',{ ||  },,,,,,.T.,,, {|| .F. } ,,,,.F.,,,'cFinNom')

oBtnAtuFin := tButton():New(015, 390, "Atualizar" , oGrpFilFin, { || Processa({|| fAtuFin() }, "[BFATC001] - AGUARDE") },40,12,,,,.T.,,,,,,)

oSayFEmiDe := tSay():New(032,010,{ || "Emissão de:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFEmiDe := tGet():New(030,040,{|u| if(PCount()>0,dFinEmiDe:=u,dFinEmiDe)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinEmiDe')

oSayFEmiAt := tSay():New(032,095,{ || "ate" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFEmiAt := tGet():New(030,107,{|u| if(PCount()>0,dFinEmiAte:=u,dFinEmiAte)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinEmiAte')

oSayFinTit := tSay():New(032,170,{ || "Titulo:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFinTit := tGet():New(030,190,{|u| if(PCount()>0,cTitFin:=u,cTitFin)}, oGrpFilFin,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cTitFin')

oSayTipTit := tSay():New(032,250,{|| "Tipo:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbTipTit := tComboBox():New(030,275,{|u|if(PCount()>0,cTipFin:=u,cTipFin)},aTipFin,50,9,oGrpFilFin,, { ||  } ,,,,.T.,,,,,,,,,'cTipFin')

oSayFVctDe := tSay():New(047,010,{ || "Vencto de:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFVctDe := tGet():New(045,040,{|u| if(PCount()>0,dFinVctDe:=u,dFinVctDe)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinVctDe')

oSayFVctAt := tSay():New(047,095,{ || "ate" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFVctAt := tGet():New(045,107,{|u| if(PCount()>0,dFinVctAte:=u,dFinVctAte)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinVctAte')

oSayFilFin := tSay():New(047,170,{|| "Filial:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbFilFin := tComboBox():New(045,190,{|u|if(PCount()>0,cFilFin:=u,cFilFin)},aFilFin,50,9,oGrpFilFin,, { ||  } ,,,,.T.,,,,,,,,,'cFilFin')

oSayFinNom := tSay():New(047,250,{ || "Nome Cli:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFinNom := tGet():New(045,275,{|u| if(PCount()>0,cNomFin:=u,cNomFin)}, oGrpFilFin,100,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cNomFin')

oGrpTitFin := tGroup():New(065,005,195,445,, oFolder:aDialogs[3],CLR_HBLUE,,.T.)

oBrwTitFin := MyGrid():New(oGrpTitFin,075,010,430,115,8)
oBrwTitFin:LDblClick( { || fConsTit() } )

oGrpFinRec := tGroup():New(200,005,260,220,"Totais (A Receber)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oSayTotSR  := tSay():New(215,010,{|| "Saldo a Receber: " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSR    := tSay():New(215,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
oSayRecDia := tSay():New(225,010,{|| "Valor recebido no mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSRecDia   := tSay():New(225,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
oSayRecAnt := tSay():New(235,010,{|| "Valor recebido dia anterior: " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSRecAnt   := tSay():New(235,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oGrpFinPag := tGroup():New(200,225,260,445,"Totais (A Pagar)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oSayTotSP  := tSay():New(210,230,{|| "Saldo a Pagar: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSP    := tSay():New(210,370,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
oSayPagDia := tSay():New(220,230,{|| "Valor pago no mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSPagDia   := tSay():New(220,370,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
oSayPagAnt := tSay():New(230,230,{|| "Valor pago dia anterior: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSPagAnt   := tSay():New(230,370,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
oSayTotSTP := tSay():New(240,230,{|| "Saldo a Pagar ST/Produtos: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSTP   := tSay():New(240,370,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
oSayTotSTI := tSay():New(250,230,{|| "Saldo a Pagar ST/Compl. Icms: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSTI   := tSay():New(250,370,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

//========================================================== ABA FATURAMENTO ==========================================================//
oGrpFil := tGroup():New(005,005,060,445,"Filtros",oFolder:aDialogs[4],CLR_HBLUE,,.T.)

oSayProd := tSay():New(017,010,{|| "Produto:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetProd := tGet():New(015,035,{|u| if(PCount()>0,cProduto:=u,cProduto)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SB1','cProduto')

oSayPed  := tSay():New(017,095,{|| "Pedido:"  },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetPed  := tGet():New(015,120,{|u| if(PCount()>0,cPedido:=u,cPedido)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SC5','cPedido')

oSayFam  := tSay():New(017,180,{|| "Família:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFam  := tGet():New(015,205,{|u| if(PCount()>0,cFamilia:=u,cFamilia)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SBM','cFamilia')

oSayVal  := tSay():New(017,265,{|| "Valor Mínimo:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetVal  := tGet():New(015,300,{|u| if(PCount()>0,nValMin:=u,nValMin)}, oGrpFil,50,9,'@E 9,999,999.99', { ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'nValMin')

oBtnAtu  := tButton():New(015, 370, "Atualizar" , oGrpFil, { || Processa({ || fAtuFat() },"[BFATC001] - AGUARDE") },50,12,,,,.T.,,,,,,)

oSayCli  := tSay():New(032,010,{|| "Cliente:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetCli  := tGet():New(030,035,{|u| if(PCount()>0,cCliente:=u,cCliente)}, oGrpFil,50,9,'@!',;
{ || fAtuFat(), IIf(!Empty(cCliente), (cNome := SA1->A1_NOME), (cNome := SPACE(TAMSX3("A1_NOME")[1]), cLoja := SPACE(TAMSX3("A1_LOJA")[1])) ) },;
,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SA1','cCliente')

oSayLoja := tSay():New(032,095,{|| "Loja:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLoja := tGet():New(030,110,{|u| if(PCount()>0,cLoja:=u,cLoja)}, oGrpFil,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLoja')

oSayNome := tSay():New(032,140,{|| "Nome:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetNome := tGet():New(030,160,{|u| if(PCount()>0,cNome:=u,cNome)}, oGrpFil,92,9,'@!',{ ||  },,,,,,.T.,,, {|| .F. } ,,,,.F.,,,'cNome')

oSayEntDe  := tSay():New(032,265,{|| "Dt.Fat de:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetEntDe  := tGet():New(030,300,{|u| if(PCount()>0,dEntDe:=u,dEntDe)}, oGrpFil,50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dEntDe')

oSayEntAte := tSay():New(032,360,{|| "Dt.Fat ate:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetEntAte := tGet():New(030,390,{|u| if(PCount()>0,dEntAte:=u,dEntAte)}, oGrpFil,50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dEntAte')

oSayOpc := tSay():New(047,010,{|| "Opções:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpc := tComboBox():New(045,035,{|u|if(PCount()>0,cOpcao:=u,cOpcao)},aOpcao,70,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cOpcao')

oSayOrd := tSay():New(047,155,{|| "Ordem:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOrd := tComboBox():New(045,180,{|u|if(PCount()>0,cOrdem:=u,cOrdem)},aOrdem,50,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cOrdem')

oSayFil := tSay():New(047,280,{|| "Filial:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbFil := tComboBox():New(045,300,{|u|if(PCount()>0,cFilFat:=u,cFilFat)},aFilFat,50,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cFilFat')

oGrpPed := tGroup():New(065,005,195,445,"Pedidos", oFolder:aDialogs[4],CLR_HBLUE,,.T.)

oBrwFat := TCBrowse():New(075,010,430,118,,,,oGrpPed,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwFat:AddColumn(TCColumn():New("Filial"    , {|| aFatura[oBrwFat:nAt,14]},,,,,20,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Pedido"    , {|| aFatura[oBrwFat:nAt,01]},,,,,20,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Item"      , {|| aFatura[oBrwFat:nAt,02]},,,,,15,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Produto"   , {|| aFatura[oBrwFat:nAt,03]},,,,,30,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Descrição" , {|| aFatura[oBrwFat:nAt,04]},,,,,80,.F.,.F.,,,,.F., ) )
//oBrwFat:AddColumn(TCColumn():New("Local"     , {|| aFatura[oBrwFat:nAt,05]},,,,,25,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Qtd. Est." , {|| aFatura[oBrwFat:nAt,06]},"@E 9,999,999.99",,,, 30 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Saldo Disp", {|| aFatura[oBrwFat:nAt,16]},"@E 9,999,999.99",,,, 30 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Quantidade", {|| aFatura[oBrwFat:nAt,07]},"@E 9,999,999.99",,,, 40 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Valor"     , {|| aFatura[oBrwFat:nAt,08]},"@E 9,999,999.99",,,, 40 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Desconto"  , {|| If(aFatura[oBrwFat:nAt,09] == 'B',oNo,oOk) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Liberação" , {|| If(aFatura[oBrwFat:nAt,10] == 'X',oAt,oOk) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Crédito"   , {|| If(aFatura[oBrwFat:nAt,11] == 'X',oNo,If(aFatura[oBrwFat:nAt,11] == 'A',oAt,oOk)) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Estoque"   , {|| If(aFatura[oBrwFat:nAt,12] == 'B',oNo,oOk) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Lib.Pedido", {|| If(aFatura[oBrwFat:nAt,15] == 'B',oNo,oOk) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Cliente"   , {|| aFatura[oBrwFat:nAt,13]},,,,,80,.F.,.F.,,,,.F., ) )
oBrwFat:SetArray(aFatura)

oBrwFat:bLDblClick := { || POSICIONE("SC5",1,aFatura[oBrwFat:nAt,14]+aFatura[oBrwFat:nAt,01],"C5_NUM"),A410Visual("SC5",SC5->(Recno()),2) }

oGrpTot := tGroup():New(200,005,260,445,"Totais", oFolder:aDialogs[4],CLR_HBLUE,,.T.)

oSayTotPed := tSay():New(208,020,{|| "Pedidos: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotPed := tSay():New(208,150,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oSayTotCrd := tSay():New(218,020,{|| "Pedidos Pend. Anal. Crédito: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotCrd := tSay():New(218,150,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayTotRej := tSay():New(228,020,{|| "Pedidos com Crédito Rejeitado: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotRej := tSay():New(228,150,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oSayTotEst := tSay():New(238,020,{|| "Pedidos sem Estoque: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotEst := tSay():New(238,150,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayTotApt := tSay():New(248,020,{|| "Pedidos Aptos a Faturar: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotApt := tSay():New(248,150,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayTotFat := tSay():New(208,250,{|| "Faturado no dia " + DTOC(DDATABASE) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotFat := tSay():New(208,365,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayTotMes := tSay():New(218,250,{|| "Acumulado do mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotMes := tSay():New(218,365,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayDevFat := tSay():New(228,250,{|| "Devolvido no dia " + DTOC(DDATABASE) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oDTotFat := tSay():New(228,365,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayDevMes := tSay():New(238,250,{|| "Devolvido no mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oDTotMes := tSay():New(238,365,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayMetFat := tSay():New(248,250,{|| "Meta Faturamento: " },oGrpTot,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,380,9)
oGetMetFat := tSay():New(248,365,,oGrpTot,"@E 9,999,999.99",oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,60,9)

oBtnRkgPro := tButton():New(263, 175, "Ranking Produtos"  , oFolder:aDialogs[4], {|| fRankPro() },50,12,,,,.T.,,,,,,)
oBtnRkgCli := tButton():New(263, 230, "Ranking Clientes"  , oFolder:aDialogs[4], {|| fRankCli() },50,12,,,,.T.,,,,,,)
oBtnEstPed := tButton():New(263, 285, "Estoque x Pedidos" , oFolder:aDialogs[4], {|| fEstPed() },50,12,,,,.T.,,,,,,)
oBtnPedEst := tButton():New(263, 340, "Pedidos x Estoque" , oFolder:aDialogs[4], {|| fPedEst() },50,12,,,,.T.,,,,,,)

//======================================================= BOTÕES FIXOS =======================================================//
oBtnSair   := tButton():New(275.5, 395, "Sair"   , oDlgMapa, {|| ::End() },50,12,,,,.T.,,,,,,)

//======================================================= INICIALIZADORES =======================================================//

Processa({|| fAtuFat() }, "[BFATC001] - AGUARDE")

ACTIVATE MSDIALOG oDlgMapa CENTERED

Return

//=========================================================== ATUALIZA FATURAMENTO ===========================================================//
Static Function fAtuFat(nOpc)
**************************
DEFAULT nOpc := 0

cFiltroSC9 := ""
cFiltroSC6 := ""
cFiltroSC5 := ""
cFiltroSF2 := ""
cFilInner  := ""

If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
	If !Empty(cCodRep)
		cFiltroSC5 += "AND SC5.C5_VEND1 IN ("+cCodRep+") "
		cFiltroSF2 += "AND SF2.F2_VEND1 IN ("+cCodRep+") "
		//Fernando: 28/03/13 
		cFilInner  += " INNER JOIN SF2010 SF2 (NOLOCK) ON SF2.F2_FILIAL = '01' AND SF2.F2_DOC = SD1.D1_NFORI " 
		cFilInner  += " AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA AND SF2.D_E_L_E_T_ = ' ' "
	Else
		cFiltroSC5 += "AND SC5.C5_VEND1 = 'ZZZZZZ' "
		cFiltroSF2 += "AND SF2.F2_VEND1 = 'ZZZZZZ' "
	Endif
Endif	

Do Case
	Case cFilFat == "01"
		cFiltroSC9 += "AND SC9.C9_FILIAL = '01' "
		cFiltroSC6 += "AND SC6.C6_FILIAL = '01' "
	Case cFilFat == "03"
		cFiltroSC9 += "AND SC9.C9_FILIAL = '03' "
		cFiltroSC6 += "AND SC6.C6_FILIAL = '03' "
	Case cFilFat == "00"
		cFilFil := "AND SD2.D2_FILIAL IN ('01','03','04') "
		cFilDev := "AND SD1.D1_FILIAL IN ('01','03','04') "
EndCase

If !Empty(cProduto)
	cFiltroSC9 += "AND SC9.C9_PRODUTO = '" + cProduto + "' "
	cFiltroSC6 += "AND SC6.C6_PRODUTO = '" + cProduto + "' "
EndIf

If !Empty(cPedido)
	cFiltroSC9 += "AND SC9.C9_PEDIDO = '" + cPedido + "' "
	cFiltroSC6 += "AND SC6.C6_NUM = '" + cPedido + "' "
EndIf

If !Empty(cCliente)
	cFiltroSC9 += "AND SC9.C9_CLIENTE = '" + cCliente + "' "
	cFiltroSC6 += "AND SC6.C6_CLI = '" + cCliente + "' "
EndIf

If !Empty(cLoja)
	cFiltroSC9 += "AND SC9.C9_LOJA = '" + cLoja + "' "
	cFiltroSC6 += "AND SC6.C6_LOJA = '" + cLoja + "' "
EndIf

If !Empty(cFamilia)
	cFiltroSC9 += "AND SB1.B1_GRUPO = '" + cFamilia + "' "
	cFiltroSC6 += "AND SB1.B1_GRUPO = '" + cFamilia + "' "
EndIf

cFiltroSC9 += "AND SC6.C6_ENTREG BETWEEN '" + DTOS(dEntDe) + "' AND '" + DTOS(dEntAte) + "' "
cFiltroSC6 += "AND SC6.C6_ENTREG BETWEEN '" + DTOS(dEntDe) + "' AND '" + DTOS(dEntAte) + "' "

Do Case
	Case cOpcao == '3'; cFiltroSC9 += "AND SC9.C9_BLCRED = '09' "
	Case cOpcao == '5'; cFiltroSC9 += "AND SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST = '02' "
	Case cOpcao == '6'; cFiltroSC9 += "AND SC9.C9_BLCRED = '01' "
	Case cOpcao == '7'; cFiltroSC9 += "AND SC9.C9_BLCRED = '  ' AND SC9.C9_BLEST = '  ' "
EndCase

If cOpcao != '7'
	cFiltroSC9 += "AND (SELECT SUM(A.C9_QTDLIB*A.C9_PRCVEN) FROM " + RetSqlName("SC9") + " A WHERE A.C9_FILIAL = SC9.C9_FILIAL AND A.C9_PEDIDO = SC9.C9_PEDIDO AND A.C9_BLCRED <> '10' AND A.C9_BLEST <> '10' AND A.D_E_L_E_T_ <> '*') >= " + cValToChar(nValMin) + " "
Else
	cFiltroSC9 += "AND (SELECT SUM(A.C9_QTDLIB*A.C9_PRCVEN) FROM " + RetSqlName("SC9") + " A WHERE A.C9_FILIAL = SC9.C9_FILIAL AND A.C9_PEDIDO = SC9.C9_PEDIDO AND A.C9_BLCRED <> '10' AND A.C9_BLEST NOT IN ('10','02') AND A.D_E_L_E_T_ <> '*') >= " + cValToChar(nValMin) + " "
EndIf
cFiltroSC6 += "AND (SELECT SUM((A.C6_QTDVEN-(A.C6_QTDEMP+A.C6_QTDENT))*A.C6_PRCVEN) FROM " + RetSqlName("SC6") + " A WHERE A.C6_FILIAL = SC6.C6_FILIAL AND A.C6_NUM = SC6.C6_NUM AND A.D_E_L_E_T_ <> '*') >= " + cValToChar(nValMin) + " "

If nOpc == 0
	fBrwFat()
EndIf

Return

//=========================================================== MONTA BROWSE DE FATURAMENTO ===========================================================//
Static Function fBrwFat()
***********************
Local cAlias  := GetNextAlias()
Local nCount  := 0

Local nTotPed := 0
Local nTotCrd := 0
Local nTotRej := 0
Local nTotEst := 0
Local nTotFat := 0
Local cFiltro1 := cFiltroSC6+" "+cFiltroSC5
Local cFiltro2 := cFiltroSC9+" "+cFiltroSC5

Local cFilFil := ""
Local cFilDev := ""

Local cHoje := "%"+DTOS(DDATABASE)+"%"
Local cMes  := "%"+SUBSTR(DTOS(DDATABASE),1,6)+"%"

Do Case
	Case cOrdem == "1"; cFiltro2 += "ORDER BY 5, 3, 2"
	Case cOrdem == "2"; cFiltro2 += "ORDER BY 3, 2"
	Case cOrdem == "3"; cFiltro2 += "ORDER BY 5, 3, 2"
EndCase

cFiltro1 := "%" + cFiltro1 + "%"
cFiltro2 := "%" + cFiltro2 + "%"   
cFilInner:= "%" + cFilInner + "%"   

Do Case
	Case cOpcao $ '14'
		BeginSql alias cAlias
			SELECT	SC6.C6_FILIAL AS FILIAL, SA1.A1_NOME AS NOME, SC6.C6_NUM AS PEDIDO, SC6.C6_ITEM AS ITEM, SC6.C6_PRODUTO AS PRODUTO, SC6.C6_LOCAL AS ARMAZEM,
			SB2.B2_QATU AS QTDEST,(SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO, SB1.B1_DESC AS DESCRI,((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALOR, SC5.C5_TIPLIB AS TIPLIB,
			(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QUANT,C6_X_BLDSC AS BLQDESCO,'X' AS PENDENTE,'A' AS REJEITADO,'A' AS BLQEST,' ' AS APTO,SC6.C6_QTDEMP AS QTDEMP
			FROM %table:SC6% SC6 (NOLOCK)

			INNER JOIN %table:SC5% SC5 (NOLOCK) ON SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_NUM = SC6.C6_NUM
			AND SC5.%notDel%
			
			INNER JOIN %table:SB1% SB1 (NOLOCK) ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL = SC6.C6_FILIAL
			AND SB2.B2_COD = SC6.C6_PRODUTO
			AND SB2.B2_LOCAL = SC6.C6_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SA1% SA1 (NOLOCK) ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC6.C6_CLI
			AND SA1.A1_LOJA = SC6.C6_LOJA
			AND SA1.%notDel%
			
			WHERE (SC6.C6_QTDVEN-SC6.C6_QTDEMP) > 0
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT   
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*
			AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_BLQ <> 'R'
			AND SC6.%notDel%
			%exp:cFiltro1%
			
			UNION ALL
			
			SELECT	SC9.C9_FILIAL AS FILIAL, SA1.A1_NOME AS NOME, SC9.C9_PEDIDO AS PEDIDO, SC9.C9_ITEM AS ITEM, SC9.C9_PRODUTO AS PRODUTO,
			SC9.C9_LOCAL AS ARMAZEM, SB2.B2_QATU AS QTDEST, (SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO, SB1.B1_DESC AS DESCRI,(SC9.C9_QTDLIB*SC9.C9_PRCVEN) AS VALOR, 
			SC5.C5_TIPLIB AS TIPLIB, SC9.C9_QTDLIB AS QUANT, ' ' AS BLQDESCO, ' ' AS PENDENTE,
			(CASE SC9.C9_BLCRED WHEN '09' THEN 'X' ELSE (CASE SC9.C9_BLCRED WHEN '01' THEN 'A' ELSE ' ' END) END) AS REJEITADO,
			(CASE SC9.C9_BLEST  WHEN '02' THEN 'X' ELSE ' ' END) AS BLQEST,
			(CASE SC9.C9_BLCRED WHEN '  ' THEN (CASE SC9.C9_BLEST WHEN '  ' THEN 'X' ELSE ' ' END) ELSE ' ' END) AS APTO,0 AS QTDEMP
			FROM %table:SC9% SC9 (NOLOCK)

			INNER JOIN %table:SC5% SC5 (NOLOCK) ON SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_NUM = SC9.C9_PEDIDO
			AND SC5.%notDel%
			
			INNER JOIN %table:SB1% SB1 (NOLOCK) ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC9.C9_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL = SC9.C9_FILIAL
			AND SB2.B2_COD = SC9.C9_PRODUTO
			AND SB2.B2_LOCAL = SC9.C9_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SC6% SC6 (NOLOCK) ON SC6.C6_FILIAL = SC9.C9_FILIAL
			AND SC6.C6_NUM = SC9.C9_PEDIDO
			AND SC6.C6_ITEM = SC9.C9_ITEM
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 (NOLOCK) ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC9.C9_CLIENTE
			AND SA1.A1_LOJA = SC9.C9_LOJA
			AND SA1.%notDel%
			WHERE SC9.C9_BLCRED <> '10'
			AND SC9.C9_BLEST <> '10'
			AND SC9.%notDel%
			%exp:cFiltro2%
		EndSql
	
   	aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos	
		
	Case cOpcao == '2'
		BeginSql alias cAlias
			SELECT	SC6.C6_FILIAL AS FILIAL, SA1.A1_NOME AS NOME, SC6.C6_NUM AS PEDIDO, SC6.C6_ITEM AS ITEM, SC6.C6_PRODUTO AS PRODUTO, SC6.C6_LOCAL AS ARMAZEM,
			SB2.B2_QATU AS QTDEST, (SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO, SB1.B1_DESC AS DESCRI,((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALOR,SC5.C5_TIPLIB AS TIPLIB,
			(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QUANT,C6_X_BLDSC AS BLQDESCO,'X' AS PENDENTE,'A' AS REJEITADO,'A' AS BLQEST,' ' AS APTO,SC6.C6_QTDEMP AS QTDEMP
			FROM %table:SC6% SC6 (NOLOCK)

			INNER JOIN %table:SC5% SC5 (NOLOCK) ON SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_NUM = SC6.C6_NUM
			AND SC5.%notDel%
			
			INNER JOIN %table:SB1% SB1 (NOLOCK) ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL = SC6.C6_FILIAL
			AND SB2.B2_COD = SC6.C6_PRODUTO
			AND SB2.B2_LOCAL = SC6.C6_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SA1% SA1 (NOLOCK) ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC6.C6_CLI
			AND SA1.A1_LOJA = SC6.C6_LOJA
			AND SA1.%notDel%
			WHERE (SC6.C6_QTDVEN-SC6.C6_QTDEMP) > 0
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_BLQ <> 'R'
			AND SC6.%notDel%
			%exp:cFiltro1%
		EndSql
	Otherwise
		BeginSql alias cAlias
			SELECT	SC9.C9_FILIAL AS FILIAL, SA1.A1_NOME AS NOME, SC9.C9_PEDIDO AS PEDIDO, SC9.C9_ITEM AS ITEM, SC9.C9_PRODUTO AS PRODUTO,
			SC9.C9_LOCAL AS ARMAZEM, SB2.B2_QATU AS QTDEST, (SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO, SB1.B1_DESC AS DESCRI,(SC9.C9_QTDLIB*SC9.C9_PRCVEN) AS VALOR, 
			SC5.C5_TIPLIB AS TIPLIB, SC9.C9_QTDLIB AS QUANT, ' ' AS BLQDESCO, ' ' AS PENDENTE,
			(CASE SC9.C9_BLCRED WHEN '09' THEN 'X' ELSE (CASE SC9.C9_BLCRED WHEN '01' THEN 'A' ELSE ' ' END) END) AS REJEITADO,
			(CASE SC9.C9_BLEST  WHEN '02' THEN 'X' ELSE ' ' END) AS BLQEST,
			(CASE SC9.C9_BLCRED WHEN '  ' THEN (CASE SC9.C9_BLEST WHEN '  ' THEN 'X' ELSE ' ' END) ELSE ' ' END) AS APTO,0 AS QTDEMP
			FROM %table:SC9% SC9 (NOLOCK)

			INNER JOIN %table:SC5% SC5 (NOLOCK) ON SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_NUM = SC9.C9_PEDIDO
			AND SC5.%notDel%
			
			INNER JOIN %table:SB1% SB1 (NOLOCK) ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC9.C9_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SB2% SB2 (NOLOCK) ON SB2.B2_FILIAL = SC9.C9_FILIAL
			AND SB2.B2_COD = SC9.C9_PRODUTO
			AND SB2.B2_LOCAL = SC9.C9_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SC6% SC6 (NOLOCK) ON SC6.C6_FILIAL = SC9.C9_FILIAL
			AND SC6.C6_NUM = SC9.C9_PEDIDO
			AND SC6.C6_ITEM = SC9.C9_ITEM  
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 (NOLOCK) ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC9.C9_CLIENTE
			AND SA1.A1_LOJA = SC9.C9_LOJA
			AND SA1.%notDel%
			WHERE SC9.C9_BLCRED <> '10'
			AND SC9.C9_BLEST <> '10'
			AND SC9.%notDel%
			%exp:cFiltro2%
		EndSql
EndCase

COUNT TO nCount

aFatura := {}

dbSelectArea(cAlias)
ProcRegua(nCount)
dbGoTop()
While !Eof()
	
	IncProc("Buscando informações de faturamento...")
	
	AADD(aFatura,{	(cAlias)->PEDIDO, (cAlias)->ITEM, (cAlias)->PRODUTO, (cAlias)->DESCRI, (cAlias)->ARMAZEM,;
	(cAlias)->QTDEST, (cAlias)->QUANT, (cAlias)->VALOR, (cAlias)->BLQDESCO, (cAlias)->PENDENTE, (cAlias)->REJEITADO,;
	(cAlias)->BLQEST, (cAlias)->NOME, (cAlias)->FILIAL,  (cAlias)->TIPLIB, (cAlias)->SALDO, (cAlias)->QTDEMP })
	
	nTotPed += (cAlias)->VALOR
	
	If (cAlias)->REJEITADO == 'A' .AND. Empty((cAlias)->PENDENTE)
		nTotCrd += (cAlias)->VALOR
	EndIf
	
	If (cAlias)->REJEITADO == 'X'
		nTotRej += (cAlias)->VALOR
	EndIf
	
	If Empty((cAlias)->PENDENTE) .And. Empty((cAlias)->REJEITADO) .And. Empty((cAlias)->BLQEST) .And. (cAlias)->APTO == "X"
		nTotFat += (cAlias)->VALOR
	EndIf

	//Avalio estoque
	////////////////
	nPos1 := Len(aFatura)
	If ((aFatura[nPos1,17] > 0).and.(aFatura[nPos1,17] == aFatura[nPos1,7])).or.;
	   ((aFatura[nPos1,17] == 0).and.(aFatura[nPos1,7] <= aFatura[nPos1,16]))
		aFatura[nPos1,12] := "A" //Com Estoque
		If ((cAlias)->TIPLIB == "1") //Por Item
			aFatura[nPos1,15] := "A" //Com Estoque
		Elseif ((cAlias)->TIPLIB == "2") //Por Pedido
			lSemEst := .F.
			aEval(aFatura,{ |x,y| lSemEst:=iif(x[1]==(cAlias)->PEDIDO.and.x[12]=="B",.T.,lSemEst) })
			If (!lSemEst)
				aEval(aFatura,{ |x,y| iif(x[1]==(cAlias)->PEDIDO,x[15]:="A",)})
			Endif
		Endif
		If (cOpcao == "4") //Item sem Estoque
			aDel(aFatura,nPos1)
			aSize(aFatura,Len(aFatura)-1)
		Endif
	Else
		aFatura[nPos1,12] := "B" //Sem Estoque
		If ((cAlias)->TIPLIB == "1") //Por Item
			aFatura[nPos1,15] := "B" //Sem Estoque
		Elseif ((cAlias)->TIPLIB == "2") //Por Pedido
			aEval(aFatura,{ |x,y| iif(x[1]==(cAlias)->PEDIDO,x[15]:="B",)})
		Endif  
		nTotEst += (cAlias)->VALOR
	Endif
	
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
EndDo

oBrwFat:SetArray(aFatura)
oBrwFat:GoTop()
oBrwFat:Refresh()

cAlias := GetNextAlias()

Do Case
	Case cFilFat == "01"
		cFilFil := "AND SD2.D2_FILIAL = '01' "
		cFilDev := "AND SD1.D1_FILIAL = '01' "
		
	Case cFilFat == "03"
		cFilFil := "AND SD2.D2_FILIAL = '03' "
		cFilDev := "AND SD1.D1_FILIAL = '03' "
		
	Case cFilFat == "00"
		cFilFil := "AND SD2.D2_FILIAL IN ('01','03','04') "
		cFilDev := "AND SD1.D1_FILIAL IN ('01','03','04') "
		
EndCase

cFilFil := "%" + cFilFil + " " + cFiltroSF2 + "%"
cFilDev := "%" + cFilDev + " " + cFiltroSF2 + "%" 

BeginSql alias cAlias
	SELECT FAT_MES, FAT_DIA, DEV_MES, DEV_DIA
	FROM
	(
	SELECT SUM(SD2.D2_VALBRUT) AS FAT_MES
	FROM %table:SD2% SD2
	INNER JOIN %table:SF2% SF2 (NOLOCK) ON SF2.F2_FILIAL = %xfilial:SF2%
	AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA 
	AND SF2.%notDel%
	WHERE SUBSTRING(SD2.D2_EMISSAO,1,6) = %exp:cMes%
	AND SD2.D2_TES IN (	SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	AND SF4.F4_DUPLIC = 'S'
	AND SF4.%notDel%)     
	AND SD2.D2_TES NOT IN ( '506','802')
	AND SD2.D2_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	AND SD2.%notDel%
	%exp:cFilFil%
	) AS FAT_MES,
	(
	SELECT SUM(SD2.D2_VALBRUT) AS FAT_DIA
	FROM  %table:SD2% SD2
	INNER JOIN %table:SF2% SF2 (NOLOCK) ON SF2.F2_FILIAL = %xfilial:SF2%
	AND SF2.F2_DOC = SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA 
	AND SF2.%notDel%
	WHERE SD2.D2_EMISSAO = %exp:cHoje%
	AND SD2.D2_TES IN (	SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	AND SF4.F4_DUPLIC = 'S'
	AND SF4.%notDel%) 
	AND SD2.D2_TES NOT IN ( '506','802')
	AND SD2.D2_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	AND SD2.%notDel%
	%exp:cFilFil%
	) AS FAT_DIA,
	(
  	SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEV_MES
	FROM %table:SD1% SD1 %exp:cFilInner%  	//Fernando: ************* 28/03/13 
	WHERE SUBSTRING(SD1.D1_DTDIGIT,1,6) = %exp:cMes%
	AND SD1.D1_TES IN (	SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	AND SF4.F4_DUPLIC = 'S'
	AND SF4.%notDel%)
	AND SD1.D1_CF IN (
	'1201',
	'2201',
	'1202',
	'2202',
	'1203',
	'2203',
	'1204',
	'2204',
	'1410',
	'2503',
	'2410',
	'1411',
	'2411')
	AND SD1.%notDel%
	%exp:cFilDev%
	) AS DEV_MES,
	(
	SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEV_DIA
	FROM  %table:SD1% SD1 %exp:cFilInner%	//Fernando: ************* 28/03/13 
	WHERE SD1.D1_DTDIGIT = %exp:cHoje%
	AND SD1.D1_TES IN (	SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	AND SF4.F4_DUPLIC = 'S'
	AND SF4.%notDel%)
	AND SD1.D1_CF IN (
	'1201',
	'2201',
	'1202',
	'2202',
	'1203',
	'2203',
	'1204',
	'2204',
	'2503',
	'1410',
	'2410',
	'1411',
	'2411')
	AND SD1.%notDel%
	%exp:cFilDev%
	) AS DEV_DIA
EndSql 
	aQuery:= GetLastQuery()//funcao que mostra todas as informações da query, util para visualizar na aba Comandos	


dbSelectArea(cAlias)
dbGoTop(cAlias)

oSTotPed:SetText(nTotPed)
oSTotCrd:SetText(nTotCrd)
oSTotRej:SetText(nTotRej)
oSTotEst:SetText(nTotEst)
oSTotApt:SetText(nTotFat)
oSTotFat:SetText((cAlias)->FAT_DIA)
oSTotMes:SetText((cAlias)->FAT_MES)
oDTotFat:SetText((cAlias)->DEV_DIA)
oDTotMes:SetText((cAlias)->DEV_MES)
nMetaMes := BuscaMeta()
oGetMetFat:SetText(nMetaMes)
oFolder:aDialogs[4]:Refresh()

Return

//=========================================================== ATUALIZA PEDIDOS ===========================================================//
Static Function fAtuPed()
***********************
Local aPedidos := {}
Local cAlias   := GetNextAlias()
Local nCount   := 0
Local cHoje    := "%"+DTOS(dDataEnt)+"%"
Local cMes     := "%"+SUBSTR(DTOS(dDataEnt),1,6)+"%"

Do Case
	Case cOpcPed == '1'
		BeginSql alias cAlias
			SELECT	SC5.C5_NUM, (SC5.C5_CLIENT + '/' + SC5.C5_LOJACLI + ' - ' + SA1.A1_NOME) AS CLIENTE,
			SE4.E4_DESCRI, SC6.C6_ENTREG, (SC5.C5_VEND1 + ' - ' + SA3.A3_NREDUZ) AS VENDEDOR, AVG(SC6.C6_DESCONT) AS DESC_MEDIO,
			SUM(CASE WHEN SUBSTRING(SC6.C6_ENTREG,1,6) <= %exp:cMes% THEN SC6.C6_VALOR ELSE 0 END) AS IMEDIATO,
			SUM(CASE WHEN SUBSTRING(SC6.C6_ENTREG,1,6) > %exp:cMes% THEN SC6.C6_VALOR ELSE 0 END) AS FUTURO,
			SUM(SC6.C6_VALOR) AS VALOR_GLOBAL
			
			FROM %table:SC5% SC5
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_NUM = SC5.C5_NUM  
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENT
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%
			
			LEFT JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%
			
			INNER JOIN %table:SE4% SE4 ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SC5.C5_CONDPAG
			AND SE4.%notDel%
			
			WHERE SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_EMISSAO = %exp:cHoje%
			AND SC5.%notDel%
			
			GROUP BY	SC5.C5_NUM, (SC5.C5_CLIENT + '/' + SC5.C5_LOJACLI + ' - ' + SA1.A1_NOME),
			SE4.E4_DESCRI, SC6.C6_ENTREG, (SC5.C5_VEND1 + ' - ' + SA3.A3_NREDUZ)
			
			ORDER BY VALOR_GLOBAL DESC
		EndSql
		
	Case cOpcPed == '2'
		BeginSql alias cAlias
			SELECT  CLIENTE,
			AVG(DESC_MEDIO) AS DESC_MEDIO,
			SUM(IMEDIATO) AS IMEDIATO,
			SUM(QTD_MES) AS QTD_MES,
			SUM(FUTURO) AS FUTURO,
			SUM(QTD_FUT) AS QTD_FUT,
			SUM(VALOR_GLOBAL) AS VALOR_GLOBAL
			FROM
			(
			SELECT (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI) AS CLIENTE,
			AVG(SC6.C6_DESCONT) AS DESC_MEDIO,
			SUM(SC6.C6_VALOR) AS IMEDIATO,
			COUNT(DISTINCT SC6.C6_NUM) AS QTD_MES,
			SUM(0) AS FUTURO,
			SUM(0) AS QTD_FUT,
			SUM(0) AS VALOR_GLOBAL
			
			FROM %table:SC5% SC5
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC5%
			AND SC6.C6_NUM = SC5.C5_NUM
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SUBSTRING(SC6.C6_ENTREG,1,6) <= %exp:cMes%
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENT
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%
			
			LEFT JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%
			
			INNER JOIN %table:SE4% SE4 ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SC5.C5_CONDPAG
			AND SE4.%notDel%
			
			INNER JOIN %table:ACY% ACY ON ACY.ACY_FILIAL = %xfilial:ACY%
			AND ACY.ACY_GRPVEN = SA1.A1_GRPVEN
			AND ACY.%notDel%
			
			WHERE SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_EMISSAO = %exp:cHoje%
			AND SC5.%notDel%
			
			GROUP BY (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI)
			
			UNION ALL
			
			SELECT (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI) AS CLIENTE,
			AVG(SC6.C6_DESCONT) AS DESC_MEDIO,
			SUM(0) AS IMEDIATO,
			SUM(0) AS QTD_MES,
			SUM(SC6.C6_VALOR) AS FUTURO,
			COUNT(DISTINCT SC6.C6_NUM) AS QTD_FUT,
			SUM(0) AS VALOR_GLOBAL
			
			FROM %table:SC5% SC5
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC5%
			AND SC6.C6_NUM = SC5.C5_NUM
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SUBSTRING(SC6.C6_ENTREG,1,6) > %exp:cMes%
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENT
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%
			
			LEFT JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%
			
			INNER JOIN %table:SE4% SE4 ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SC5.C5_CONDPAG
			AND SE4.%notDel%
			
			INNER JOIN %table:ACY% ACY ON ACY.ACY_FILIAL = %xfilial:ACY%
			AND ACY.ACY_GRPVEN = SA1.A1_GRPVEN
			AND ACY.%notDel%
			
			WHERE SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_EMISSAO = %exp:cHoje%
			AND SC5.%notDel%
			
			GROUP BY (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI)
			
			UNION ALL
			
			SELECT (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI) AS CLIENTE,
			AVG(SC6.C6_DESCONT) AS DESC_MEDIO,
			SUM(0) AS IMEDIATO,
			SUM(0) AS QTD_MES,
			SUM(0) AS FUTURO,
			SUM(0) AS QTD_FUT,
			SUM(SC6.C6_VALOR) AS VALOR_GLOBAL
			
			FROM %table:SC5% SC5
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC5%
			AND SC6.C6_NUM = SC5.C5_NUM   
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			INNER JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENT
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%
			
			LEFT JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%
			
			INNER JOIN %table:SE4% SE4 ON SE4.E4_FILIAL = %xfilial:SE4%
			AND SE4.E4_CODIGO = SC5.C5_CONDPAG
			AND SE4.%notDel%
			
			INNER JOIN %table:ACY% ACY ON ACY.ACY_FILIAL = %xfilial:ACY%
			AND ACY.ACY_GRPVEN = SA1.A1_GRPVEN
			AND ACY.%notDel%
			
			WHERE SC5.C5_FILIAL = %xfilial:SC5%
			AND SC5.C5_EMISSAO = %exp:cHoje%
			AND SC5.%notDel%
			
			GROUP BY (SA1.A1_GRPVEN + ' - ' + ACY.ACY_DESCRI)
			)
			
			DERIVED GROUP BY CLIENTE
			ORDER BY VALOR_GLOBAL DESC
		EndSql
		
	Case cOpcPed == '3'
		BeginSql alias cAlias
			SELECT	(SB1.B1_GRUPO + ' - ' + SBM.BM_DESC) AS PRODUTO,
			AVG(SC6.C6_DESCONT) AS DESC_MEDIO,
			SUM(CASE WHEN SUBSTRING(SC6.C6_ENTREG,1,6) <= %exp:cMes% THEN SC6.C6_VALOR ELSE 0 END) AS IMEDIATO,
			SUM(CASE WHEN SUBSTRING(SC6.C6_ENTREG,1,6) > %exp:cMes% THEN SC6.C6_VALOR ELSE 0 END) AS FUTURO,
			SUM(SC6.C6_VALOR) AS VALOR_GLOBAL
			
			FROM %table:SC6% SC6
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SBM% SBM ON SBM.BM_FILIAL = %xfilial:SBM%
			AND SBM.BM_GRUPO = SB1.B1_GRUPO
			AND SBM.%notDel%
			
			WHERE SC6.C6_FILIAL+SC6.C6_NUM IN (	SELECT SC5.C5_FILIAL+SC5.C5_NUM
			FROM %table:SC5% SC5
			WHERE SC5.C5_EMISSAO = %exp:cHoje%
			AND SC5.%notDel%)             
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4 (NOLOCK)
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			GROUP BY (SB1.B1_GRUPO + ' - ' + SBM.BM_DESC)
			ORDER BY VALOR_GLOBAL DESC
		EndSql
EndCase

COUNT TO nCount

oBrwPed:ClearRows()

aPedidos := {}

For i:=1 to Len(oBrwPed:aColumns)
	oBrwPed:delColumn(oBrwPed:aColumns[i,1])
Next i

For i:=1 to (cAlias)->(FCount())
	
	cCampo := (cAlias)->(FieldName(i))
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbGoTop()
	If dbSeek(cCampo)
		Do Case
			Case ValType((cAlias)->(FieldGet(i))) == "N"
				oBrwPed:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_RIGHT)
			Case ValType((cAlias)->(FieldGet(i))) == "D"
				oBrwPed:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, 0)
			Otherwise
				oBrwPed:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_LEFT)
		EndCase
	Else
		
		cCampo := Upper(Substr(cCampo,1,1))+Lower(Substr(cCampo,2))
		cCampo := StrTran(cCampo,"_"," ")
		
		Do Case
			Case ValType((cAlias)->(FieldGet(i))) == "N"
				oBrwPed:addColumn(i,cCampo,Len(ALLTRIM(STR((cAlias)->(FieldGet(i)))))+80, CONTROL_ALIGN_RIGHT)
			Case ValType((cAlias)->(FieldGet(i))) == "D"
				oBrwPed:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, 0)
			Otherwise
				oBrwPed:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, CONTROL_ALIGN_LEFT)
		EndCase
	EndIf
Next i

dbSelectArea(cAlias)
ProcRegua(nCount)
dbGoTop()
While !Eof()
	
	IncProc("Buscando informações do estoque...")
	
	aClone := {}
	
	For i:=1 to (cAlias)->(FCount())
		
		cCampo := (cAlias)->(FieldName(i))
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek(cCampo)
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),X3Picture(cCampo)))
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
				Otherwise
					AADD(aClone,(cAlias)->(FieldGet(i)))
			EndCase
		Else
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),"@E 9,999,999.9999"))
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
				Otherwise
					AADD(aClone,(cAlias)->(FieldGet(i)))
			EndCase
		EndIf
	Next i
	
	AADD(aPedidos,aClone)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
EndDo

oBrwPed:SetArray(aPedidos)
oBrwPed:ShowData(1,9)
oBrwPed:DoUpdate()

oGrpTotMes:cCaption := "Pedidos que entraram no mês " + STRZERO(MONTH(dDataEnt),2) +"/" + ALLTRIM(STR(YEAR(dDataEnt)))
oGrpTotDia:cCaption := "Pedidos que entraram no dia " + DTOC(dDataEnt)

Return

//================================================= ATUALIZA INFORMAÇÕES ESTOQUE =================================================//
Static Function fAtuEst()
***********************
Local nCount := 0
Local cAlias := GetNextAlias()

Local cPesq  := "%LIKE ('%" + ALLTRIM(cPesEst) + "%') %"

Do Case
	Case cOpcEst == "1"
		BeginSql alias cAlias
			SELECT 	SB1.B1_COD, SB1.B1_DESC, SX5.X5_DESCRI AS TIPO, SBM.BM_DESC, SB2.B2_LOCAL, (SB2.B2_QATU-SB2.B2_QEMP) AS QTD_DISPONIVEL,
			SB2.B2_QATU, (SB2.B2_QATU*SB2.B2_CM1) AS VALOR_ATUAL, SB2.B2_SALPEDI,
			(	SELECT AVG(C6_PRCVEN)
			FROM %table:SC6% SC6
			WHERE SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_PRODUTO = SB1.B1_COD
			AND SC6.C6_LOCAL = SB2.B2_LOCAL
			AND SC6.%notDel%
			) AS PRECO_MEDIO
			
			FROM %table:SB2% SB2
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SB2.B2_COD
			AND SB1.B1_DESC %exp:cPesq%
			AND SB1.%notDel%
			
			INNER JOIN %table:SBM% SBM ON SBM.BM_FILIAL = %xfilial:SBM%
			AND SBM.BM_GRUPO = SB1.B1_GRUPO
			AND SBM.%notDel%
			
			INNER JOIN %table:SX5% SX5 ON SX5.X5_FILIAL = %xfilial:SX5%
			AND SX5.X5_TABELA = '02'
			AND SX5.X5_CHAVE = SB1.B1_TIPO
			AND SX5.%notDel%
			
			WHERE SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_LOCAL BETWEEN %exp:cLocalDe% AND %exp:cLocalAte%
			AND SB2.%notDel%
			
			ORDER BY SB1.B1_DESC
		EndSql
		
	Case cOpcEst == "2"
		BeginSql alias cAlias
			
			SELECT 	SB1.B1_TIPO, SX5.X5_DESCRI AS TIPO, SUM(SB2.B2_QATU-SB2.B2_QEMP) AS QTD_DISPONIVEL,
			SUM(SB2.B2_QATU) AS B2_QATU, SUM(SB2.B2_QATU*SB2.B2_CM1) AS VALOR_ATUAL, SUM(SB2.B2_SALPEDI) AS B2_SALPEDI,
			(SELECT AVG(C6_PRCVEN)
			FROM %table:SC6% SC6
			WHERE SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_PRODUTO IN (SELECT A.B1_COD FROM %table:SB1% A WHERE A.B1_FILIAL = %xfilial:SB1% AND A.B1_TIPO = SB1.B1_TIPO AND A.%notDel%)
			AND SC6.%notDel%
			) AS PRECO_MEDIO
			
			FROM %table:SB2% SB2
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SB2.B2_COD
			AND SB1.%notDel%
			
			INNER JOIN %table:SX5% SX5 ON SX5.X5_FILIAL = %xfilial:SX5%
			AND SX5.X5_TABELA = '02'
			AND SX5.X5_CHAVE = SB1.B1_TIPO
			AND SX5.X5_DESCRI %exp:cPesq%
			AND SX5.%notDel%
			
			WHERE SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_LOCAL BETWEEN %exp:cLocalDe% AND %exp:cLocalAte%
			AND SB2.%notDel%
			
			GROUP BY SB1.B1_TIPO, SX5.X5_DESCRI
			ORDER BY SX5.X5_DESCRI
		EndSql
		
	Case cOpcEst == "3"
		BeginSql alias cAlias
			
			SELECT 	SB1.B1_GRUPO, SBM.BM_DESC, SUM(SB2.B2_QATU-SB2.B2_QEMP) AS QTD_DISPONIVEL,
			SUM(SB2.B2_QATU) AS B2_QATU, SUM(SB2.B2_QATU*SB2.B2_CM1) AS VALOR_ATUAL, SUM(SB2.B2_SALPEDI) AS B2_SALPEDI,
			(SELECT AVG(C6_PRCVEN)
			FROM %table:SC6% SC6
			WHERE SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_PRODUTO IN (SELECT A.B1_COD FROM %table:SB1% A WHERE A.B1_FILIAL = %xfilial:SB1% AND A.B1_GRUPO = SB1.B1_GRUPO AND A.%notDel%)
			AND SC6.%notDel%
			) AS PRECO_MEDIO
			
			FROM %table:SB2% SB2
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SB2.B2_COD
			AND SB1.%notDel%
			
			INNER JOIN %table:SBM% SBM ON SBM.BM_FILIAL = %xfilial:SBM%
			AND SBM.BM_GRUPO = SB1.B1_GRUPO
			AND SBM.BM_DESC %exp:cPesq%
			AND SBM.%notDel%
			
			WHERE SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_LOCAL BETWEEN %exp:cLocalDe% AND %exp:cLocalAte%
			AND SB2.%notDel%
			
			GROUP BY SB1.B1_GRUPO, SBM.BM_DESC
			ORDER BY SBM.BM_DESC
		EndSql
		
EndCase

COUNT TO nCount

oBrwEst:ClearRows()

aEstoque := {}

For i:=1 to Len(oBrwEst:aColumns)
	oBrwEst:delColumn(oBrwEst:aColumns[i,1])
Next i

For i:=1 to (cAlias)->(FCount())
	
	cCampo := (cAlias)->(FieldName(i))
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbGoTop()
	If dbSeek(cCampo)
		Do Case
			Case ValType((cAlias)->(FieldGet(i))) == "N"
				oBrwEst:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_RIGHT)
			Case ValType((cAlias)->(FieldGet(i))) == "D"
				oBrwEst:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, 0)
			Otherwise
				oBrwEst:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_LEFT)
		EndCase
	Else
		
		cCampo := Upper(Substr(cCampo,1,1))+Lower(Substr(cCampo,2))
		cCampo := StrTran(cCampo,"_"," ")
		
		Do Case
			Case ValType((cAlias)->(FieldGet(i))) == "N"
				oBrwEst:addColumn(i,cCampo,Len(ALLTRIM(STR((cAlias)->(FieldGet(i)))))+80, CONTROL_ALIGN_RIGHT)
			Case ValType((cAlias)->(FieldGet(i))) == "D"
				oBrwEst:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, 0)
			Otherwise
				oBrwEst:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, CONTROL_ALIGN_LEFT)
		EndCase
	EndIf
Next i

dbSelectArea(cAlias)
ProcRegua(nCount)
dbGoTop()
While !Eof()
	
	IncProc("Buscando informações do estoque...")
	
	aClone := {}
	
	For i:=1 to (cAlias)->(FCount())
		
		cCampo := (cAlias)->(FieldName(i))
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek(cCampo)
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),X3Picture(cCampo)))
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
				Otherwise
					AADD(aClone,(cAlias)->(FieldGet(i)))
			EndCase
		Else
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),"@E 9,999,999.9999"))
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
				Otherwise
					AADD(aClone,(cAlias)->(FieldGet(i)))
			EndCase
		EndIf
	Next i
	
	AADD(aEstoque,aClone)
	
	dbSelectArea(cAlias)
	(cAlias)->(dbSkip())
EndDo

oBrwEst:SetArray(aEstoque)
oBrwEst:ShowData(1,15)
oBrwEst:DoUpdate()

Return

//================================================= ATUALIZA INFORMAÇÕES DA ABA FINANCEIRO =================================================//
Static Function fAtuFin()
***********************
Local cAlias    := GetNextAlias()
Local cAliasTot := GetNextAlias()
Local cOntem    := "%"+DTOS(DDATABASE-1)+"%"
Local cMes      := "%"+SUBSTR(DTOS(DDATABASE),1,6)+"%"
Local cEstST := "%" + FormatIn(GetMv("BR_STPOS"),"/") + "%"
Local cPesq  := "%LIKE ('%" + ALLTRIM(cNomFin) + "%') %"
Local nCount := 0
Local aDados := {}
Local aClone := {}
Local cFiltroSE2 := ""
Local cFiltroSE1 := ""
Local cFiltroSE5 := ""
Local cFiltroSF2 := ""

If  AllTrim(cUsername) $ (GetMv("BR_ABAFIN")) //Charles Battisti Medeiros
	
	Do Case
		Case cFilFin == "01"
			cFiltroSE2 += "AND SE2.E2_FILIAL = '01' "
			cFiltroSE1 += "AND SE1.E1_FILIAL = '01' "
			cFiltroSE5 += "AND SE5.E5_FILORIG = '01' "
			cFiltroSF2 += "AND SF2.F2_FILIAL = '01' "
		Case cFilFin == "03"
			cFiltroSE2 += "AND SE2.E2_FILIAL = '03' "
			cFiltroSE1 += "AND SE1.E1_FILIAL = '03' "
			cFiltroSE5 += "AND SE5.E5_FILORIG = '03' "
			cFiltroSF2 += "AND SF2.F2_FILIAL = '03' "
		Case cFilFat == "00"
			cFiltroSE2 += "AND SE2.E2_FILIAL IN ('01','03') "
			cFiltroSE1 += "AND SE1.E1_FILIAL IN ('01','03') "
			cFiltroSE5 += "AND SE5.E5_FILORIG IN ('01','03') "
			cFiltroSF2 += "AND SF2.F2_FILIAL IN ('01','03') "
	EndCase
	
	If !Empty(cCliFor) .And. !Empty(cFinLoj)
		cFiltroSE2 += "AND SE2.E2_FORNECE = '" + cCliFor + "' AND SE2.E2_LOJA = '" + cFinLoj + "' "
		cFiltroSE1 += "AND SE1.E1_CLIENTE = '" + cCliFor + "' AND SE1.E1_LOJA = '" + cFinLoj + "' "
	EndIf
	
	If !Empty(cTitFin)
		cFiltroSE2 += "	AND SE2.E2_NUM = '" + cTitFin + "' "
		cFiltroSE1 += "	AND SE1.E1_NUM = '" + cTitFin + "' "
	EndIf

	If (Left(cTipFin,1) == "2") //Em Aberto
		cFiltroSE2 += "	AND SE2.E2_SALDO > 0 "
		cFiltroSE1 += "	AND SE1.E1_SALDO > 0 "
	Elseif (Left(cTipFin,1) == "3") //Vencidos
		cFiltroSE2 += "	AND SE2.E2_SALDO > 0 AND SE2.E2_VENCREA < '"+dtos(dDatabase)+"' "
		cFiltroSE1 += "	AND SE1.E1_SALDO > 0 AND SE1.E1_VENCREA < '"+dtos(dDatabase)+"' "
	Endif	
	
	cFiltroSE2 := "%" + cFiltroSE2 + "%"
	cFiltroSE1 := "%" + cFiltroSE1 + "%"
	cFiltroSE5 := "%" + cFiltroSE5 + "%"
	cFiltroSF2 := "%" + cFiltroSF2 + "%"
	
	Do Case
		Case cOpcCart == "1"
			oGrpTitFin:cCaption := "Títulos a Pagar"
			oSayCliFor:SetText("Fornecedor:")
			oGetCliFor:cF3 := "SA2"
			
			BeginSql alias cAlias
				
				COLUMN E2_VENCREA AS DATE
				
				SELECT 	(CASE WHEN SE2.E2_SALDO = 0 THEN 'RPO_IMAGE=DISABLE' ELSE (CASE WHEN SE2.E2_BAIXA <> ' ' AND SE2.E2_SALDO > 0 THEN 'RPO_IMAGE=BR_AZUL' ELSE 'RPO_IMAGE=ENABLE' END) END) AS STATUS,
				SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,
				SE2.E2_VENCREA, SE2.E2_VALOR, SE2.E2_NOMFOR
				FROM %table:SE2% SE2
				WHERE SE2.E2_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
				AND SE2.E2_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
				AND SE2.E2_NOMFOR %exp:cPesq%
				AND SE2.%notDel%
				%exp:cFiltroSE2%
			EndSql
			
		Case cOpcCart == "2"
			oGrpTitFin:cCaption := "Títulos a Receber"
			oSayCliFor:SetText("Cliente:")
			oGetCliFor:cF3 := "SA1"
			
			BeginSql alias cAlias
				
				COLUMN E1_VENCREA AS DATE
				
				SELECT	(CASE WHEN SE1.E1_SALDO = 0 THEN 'RPO_IMAGE=DISABLE' ELSE (CASE WHEN SE1.E1_BAIXA <> ' ' AND SE1.E1_SALDO > 0 THEN 'RPO_IMAGE=BR_AZUL' ELSE 'RPO_IMAGE=ENABLE' END) END) AS STATUS,
				SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,
				SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_NOMCLI
				FROM %table:SE1% SE1
				WHERE SE1.E1_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
				AND SE1.E1_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
				AND SE1.E1_NOMCLI %exp:cPesq%
				AND SE1.%notDel%
				%exp:cFiltroSE1%
			EndSql
	EndCase
	
	COUNT TO nCount
	
	oBrwTitFin:ClearRows()
	
	For i:=1 to Len(oBrwTitFin:aColumns)
		oBrwTitFin:delColumn(oBrwTitFin:aColumns[i,1])
	Next i
	
	For i:=1 to (cAlias)->(FCount())
		
		cCampo := (cAlias)->(FieldName(i))
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbGoTop()
		If dbSeek(cCampo)
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					oBrwTitFin:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_RIGHT)
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					oBrwTitFin:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, 0)
				Otherwise
					oBrwTitFin:addColumn(i,X3Titulo(),TAMSX3(cCampo)[1]+80, CONTROL_ALIGN_LEFT)
			EndCase
		Else
			
			cCampo := Upper(Substr(cCampo,1,1))+Lower(Substr(cCampo,2))
			cCampo := StrTran(cCampo,"_"," ")
			
			Do Case
				Case ValType((cAlias)->(FieldGet(i))) == "N"
					oBrwTitFin:addColumn(i,cCampo,Len(ALLTRIM(STR((cAlias)->(FieldGet(i)))))+80, CONTROL_ALIGN_RIGHT)
				Case ValType((cAlias)->(FieldGet(i))) == "D"
					oBrwTitFin:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, 0)
				Otherwise
					oBrwTitFin:addColumn(i,cCampo,Len((cAlias)->(FieldGet(i)))+80, CONTROL_ALIGN_LEFT)
			EndCase
		EndIf
	Next i
	
	dbSelectArea(cAlias)
	ProcRegua(nCount)
	dbGoTop()
	While !Eof()
		
		IncProc("Buscando informações do financeiro...")
		
		aClone := {}
		
		For i:=1 to (cAlias)->(FCount())
			
			cCampo := (cAlias)->(FieldName(i))
			
			dbSelectArea("SX3")
			dbSetOrder(2)
			dbGoTop()
			If dbSeek(cCampo)
				Do Case
					Case ValType((cAlias)->(FieldGet(i))) == "N"
						AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),X3Picture(cCampo)))
					Case ValType((cAlias)->(FieldGet(i))) == "D"
						AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
					Otherwise
						AADD(aClone,(cAlias)->(FieldGet(i)))
				EndCase
			Else
				Do Case
					Case ValType((cAlias)->(FieldGet(i))) == "N"
						AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),"@E 9,999,999.9999"))
					Case ValType((cAlias)->(FieldGet(i))) == "D"
						AADD(aClone,DTOC(((cAlias)->(FieldGet(i)))))
					Otherwise
						AADD(aClone,(cAlias)->(FieldGet(i)))
				EndCase
			EndIf
		Next i
		
		AADD(aDados,aClone)
		
		dbSelectArea(cAlias)
		(cAlias)->(dbSkip())
	EndDo
	
	oBrwTitFin:SetArray(aDados)
	oBrwTitFin:ShowData(1,oBrwTitFin:nVisibleRows)
	oBrwTitFin:DoUpdate()
	
	oSayCliFor:CtrlRefresh()
	
	BeginSql alias cAliasTot
		SELECT SALDO_REC, REC_MES, REC_ONTEM, SALDO_PAG, PAG_MES, PAG_ONTEM, TOT_STP, TOT_STI
		FROM
		(
		(SELECT SUM(SE1.E1_SALDO) AS SALDO_REC
		FROM %table:SE1% SE1
		WHERE SE1.E1_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
		AND SE1.E1_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
		AND SE1.%notDel%
		%exp:cFiltroSE1%) AS SALDO_REC,
		
		(SELECT SUM(SE5.E5_VALOR) AS REC_MES
		FROM %table:SE5% SE5
		WHERE SUBSTRING(SE5.E5_DTDIGIT,1,6) = %exp:cMes%
		AND SE5.E5_RECPAG = 'R'
		AND SE5.E5_TIPODOC IN ('BA','VL','V2')
		AND SE5.E5_MOTBX = 'NOR'
		AND SE5.%notDel%
		%exp:cFiltroSE5%
		
		) AS REC_DIA,
		
		(SELECT SUM(SE5.E5_VALOR) AS REC_ONTEM
		FROM %table:SE5% SE5
		WHERE SE5.E5_DTDIGIT = %exp:cOntem%
		AND SE5.E5_RECPAG = 'R'
		AND SE5.E5_TIPODOC IN ('BA','VL','V2')
		AND SE5.E5_MOTBX = 'NOR'
		AND SE5.%notDel%
		%exp:cFiltroSE5%
		
		) AS REC_ONTEM,
		
		(SELECT SUM(SE2.E2_SALDO) AS SALDO_PAG
		FROM %table:SE2% SE2
		WHERE SE2.E2_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
		AND SE2.E2_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
		AND SE2.%notDel%
		%exp:cFiltroSE2%) AS SALDO_PAG,
		
		(SELECT SUM(SE5.E5_VALOR) AS PAG_MES
		FROM %table:SE5% SE5
		WHERE SUBSTRING(SE5.E5_DTDIGIT,1,6) = %exp:cMes%
		AND SE5.E5_RECPAG = 'P'
		AND SE5.E5_TIPODOC = 'BA'
		AND SE5.E5_MOTBX = 'NOR'
		AND SE5.%notDel%
		%exp:cFiltroSE5%
		
		) AS PAG_DIA,
		
		(SELECT SUM(SE5.E5_VALOR) AS PAG_ONTEM
		FROM %table:SE5% SE5
		WHERE SE5.E5_DTDIGIT = %exp:cOntem%
		AND SE5.E5_RECPAG = 'P'
		AND SE5.E5_TIPODOC = 'BA'
		AND SE5.E5_MOTBX = 'NOR'
		AND SE5.%notDel%
		%exp:cFiltroSE5%
		
		) AS PAG_ONTEM,
		
		(SELECT SUM(SF2.F2_ICMSRET) AS TOT_STP
		FROM %table:SF2% SF2
		WHERE SF2.F2_DTSAIDA = ' '
		AND SF2.F2_X_DTGNR = ' '
		AND SF2.F2_EST NOT IN %exp:cEstST%
		AND SF2.F2_TIPO <> 'I'
		AND SF2.%notDel%
		%exp:cFiltroSF2%
		) AS TOT_STP,
		
		(SELECT SUM(SF2.F2_ICMSRET) AS TOT_STI
		FROM %table:SF2% SF2
		WHERE SF2.F2_X_DTGNR = ' '
		AND SF2.F2_TIPO = 'I'
		AND SF2.F2_EST NOT IN %exp:cEstST%
		AND SF2.%notDel%
		%exp:cFiltroSF2%
		) AS TOT_STI
		)
	EndSql
	
	dbSelectArea(cAliasTot)
	dbGoTop()
	
	oSTotSR:SetText((cAliasTot)->SALDO_REC)
	oSRecDia:SetText((cAliasTot)->REC_MES)
	oSRecAnt:SetText((cAliasTot)->REC_ONTEM)
	oSTotSP:SetText((cAliasTot)->SALDO_PAG)
	oSPagDia:SetText((cAliasTot)->PAG_MES)
	oSPagAnt:SetText((cAliasTot)->PAG_ONTEM)
	oSTotSTP:SetText((cAliasTot)->TOT_STP)
	oSTotSTI:SetText((cAliasTot)->TOT_STI)
	
	Return
	
Else //Charles Battisti Medeiros
	Aviso("ATENCAO",; //Charles Battisti Medeiros
	" ROTINA COM ACESSO RESTRITO !!!!",; //Charles Battisti Medeiros
	{"&Ok"},,"Para acesso constatar - TI - Brascola Ltda. ")  //Charles Battisti Medeiros
	Return   //Charles Battisti Medeiros
EndIf //Charles Battisti Medeiros

//================================================= IMPRESSÃO DO RELATÓRIO PEDIDOS X ESTOQUE =================================================//
Static Function fPedEst()
***********************
Local oReport := ReportDef()
oReport:PrintDialog()

Return

Static Function ReportDef()
*************************
Local oReport
Local oSection1

oReport := TReport():New("BFATC001","Pedidos x Estoque",NIL,{|oReport| PrintReport(oReport)},"Impressão do relatório de Pedidos x Estoque")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Mapa",{"SC9","SB1","SB2"})

TRCell():New(oSection1,"C6_PRODUTO","SC9","Produto")
TRCell():New(oSection1,"B1_DESC","SB1","Descrição")
TRCell():New(oSection1,"QTDPED","SC9","Qtd. Pedido","@E 9,999,999.99")
TRCell():New(oSection1,"VALPED","SC9","Val. Pedido","@E 9,999,999.99")
TRCell():New(oSection1,"SALEST","SC9","Saldo Estoque","@E 9,999,999.99")
TRCell():New(oSection1,"VALEST","SC9","Valor Estoque","@E 9,999,999.99")
TRCell():New(oSection1,"B2_SALPEDI","SB2")

oSection1:Cell("C6_PRODUTO"):SetSize(20)
oSection1:Cell("B1_DESC"):SetSize(40)
oSection1:Cell("QTDPED"):SetSize(30)
oSection1:Cell("VALPED"):SetSize(30)
oSection1:Cell("SALEST"):SetSize(30)
oSection1:Cell("VALEST"):SetSize(30)
oSection1:Cell("B2_SALPEDI"):SetSize(30)

oSection1:Cell("QTDPED"):SetHeaderAlign("RIGHT")
oSection1:Cell("VALPED"):SetHeaderAlign("RIGHT")
oSection1:Cell("SALEST"):SetHeaderAlign("RIGHT")
oSection1:Cell("VALEST"):SetHeaderAlign("RIGHT")

oSection1:Cell("C6_PRODUTO"):SetRowDiff(5)

oSection1:Cell("C6_PRODUTO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("QTDPED"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VALPED"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("SALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B2_SALPEDI"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("C6_PRODUTO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("QTDPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B2_SALPEDI"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

TRFunction():New(oSection1:Cell("QTDPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("SALEST"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALEST"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

Return oReport

Static Function PrintReport(oReport)
********************************
Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)
Local cFiltro1 := ""
Local cFiltro2 := ""

fAtuFat(1)

cFiltro1 := cFiltroSC6
cFiltro2 := cFiltroSC9
cFiltro1 := "%" + cFiltro1 + "%"
cFiltro2 := "%" + cFiltro2 + "%"

oSection1:BeginQuery()

Do Case
	Case cOpcao == '1'
		BeginSql alias cAlias
			SELECT 	C6_PRODUTO,
			B1_DESC,
			B2_SALPEDI,
			SUM(QTDPED) AS QTDPED,
			SUM(VALPED) AS VALPED,
			SALEST,
			VALEST
			FROM (
			SELECT	SC6.C6_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SUM(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QTDPED,
			SUM((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALPED, SB2.B2_QATU AS SALEST,
			(SB2.B2_QATU*SB2.B2_CM1) AS VALEST
			
			FROM %table:SC6% SC6
			
			INNER JOIN %table:SB2% SB2 ON SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_COD = SC6.C6_PRODUTO
			AND SB2.B2_LOCAL = SC6.C6_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%
			
			WHERE SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SC6.C6_TES NOT IN ('506','802')
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.C6_BLQ <> 'R'
			AND SC6.%notDel%
			%exp:cFiltro1%
			
			GROUP BY SC6.C6_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SB2.B2_QATU, (SB2.B2_QATU*SB2.B2_CM1)
			
			UNION ALL
			
			SELECT	SC9.C9_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SUM(SC9.C9_QTDLIB) AS QTDPED,
			SUM(SC9.C9_QTDLIB*SC9.C9_PRCVEN) AS VALPED, SB2.B2_QATU AS SALEST,
			(SB2.B2_QATU*SB2.B2_CM1) AS VALEST
			
			FROM %table:SC9% SC9
			
			INNER JOIN %table:SB2% SB2 ON SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_COD = SC9.C9_PRODUTO
			AND SB2.B2_LOCAL = SC9.C9_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC9.C9_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_NUM = SC9.C9_PEDIDO
			AND SC6.C6_ITEM = SC9.C9_ITEM    
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			//AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SF4.%notDel%)
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			WHERE SC9.C9_FILIAL = %xfilial:SC9%
			AND SC9.C9_BLCRED <> '10'
			AND SC9.C9_BLEST <> '10'
			AND SC9.%notDel%
			%exp:cFiltro2%
			
			GROUP BY SC9.C9_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SB2.B2_QATU, (SB2.B2_QATU*SB2.B2_CM1)
			)
			
			DERIVED GROUP BY C6_PRODUTO, B1_DESC, B2_SALPEDI, SALEST, VALEST
			ORDER BY VALPED DESC
		EndSql
	Case cOpcao == '2'
		BeginSql alias cAlias
			SELECT	SC6.C6_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SUM(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QTDPED,
			SUM((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALPED, SB2.B2_QATU AS SALEST,
			(SB2.B2_QATU*SB2.B2_CM1) AS VALEST
			
			FROM %table:SC6% SC6
			
			INNER JOIN %table:SB2% SB2 ON SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_COD = SC6.C6_PRODUTO
			AND SB2.B2_LOCAL = SC6.C6_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC6.C6_PRODUTO
			AND SB1.%notDel%
			
			WHERE SC6.C6_FILIAL = %xfilial:SC6%  
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.C6_BLQ <> 'R'
			AND SC6.%notDel%
			%exp:cFiltro1%
			
			GROUP BY SC6.C6_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SB2.B2_QATU, (SB2.B2_QATU*SB2.B2_CM1)
			ORDER BY VALPED DESC
		EndSql
		
	Otherwise
		BeginSql alias cAlias
			SELECT	SC9.C9_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SUM(SC9.C9_QTDLIB) AS QTDPED,
			SUM(SC9.C9_QTDLIB*SC9.C9_PRCVEN) AS VALPED, SB2.B2_QATU AS SALEST,
			(SB2.B2_QATU*SB2.B2_CM1) AS VALEST
			
			FROM %table:SC9% SC9
			
			INNER JOIN %table:SB2% SB2 ON SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_COD = SC9.C9_PRODUTO
			AND SB2.B2_LOCAL = SC9.C9_LOCAL
			AND SB2.%notDel%
			
			INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
			AND SB1.B1_COD = SC9.C9_PRODUTO
			AND SB1.%notDel%
			
			INNER JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC6%
			AND SC6.C6_NUM = SC9.C9_PEDIDO
			AND SC6.C6_ITEM = SC9.C9_ITEM   
			AND SC6.C6_TES NOT IN ('506','802')
			AND SC6.C6_TES IN (SELECT SF4.F4_CODIGO
			FROM %table:SF4% SF4
			WHERE SF4.F4_FILIAL = %xfilial:SF4%
			AND SF4.F4_DUPLIC = 'S'
			/*AND SF4.F4_ESTOQUE = 'S'
			AND F4_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			*/
			AND SF4.%notDel%)
			AND SC6.C6_CF IN (
			'5101',
			'5102',
			'5401',
			'5403',
			'5501',
			'6101',
			'6102',
			'6107',
			'6108',
			'6109',
			'6118',
			'6119',
			'6401',
			'6403',
			'6501',
			'6502',
			'7101',
			'7102')
			AND SC6.C6_QTDVEN > SC6.C6_QTDENT
			AND SC6.%notDel%
			
			WHERE SC9.C9_FILIAL = %xfilial:SC9%
			AND SC9.C9_BLCRED <> '10'
			AND SC9.C9_BLEST <> '10'
			AND SC9.%notDel%
			%exp:cFiltro2%
			
			GROUP BY SC9.C9_PRODUTO, SB1.B1_DESC, SB2.B2_SALPEDI, SB2.B2_QATU, (SB2.B2_QATU*SB2.B2_CM1)
			ORDER BY VALPED DESC
		EndSql
EndCase

oSection1:EndQuery()

oSection1:Print()

Return

//================================================= IMPRESSÃO DO RELATÓRIO ESTOQUE x PEDIDOS =================================================//
Static Function fEstPed()
**********************
Local oReport := fEstPed2()
oReport:PrintDialog()

Return

Static Function fEstPed2()
***********************
Local oReport
Local oSection1

oReport := TReport():New("BFATC002","Estoque x Pedidos",NIL,{|oReport| fEstPed3(oReport)},"Impressão do relatório Estoque x Pedidos")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Mapa",{"SB2","SB1","SC6"})

TRCell():New(oSection1,"B2_COD","SB2","Produto")
TRCell():New(oSection1,"B1_DESC","SB1","Descrição")
TRCell():New(oSection1,"B2_QATU","SB2")
TRCell():New(oSection1,"VALEST","SB2","Valor Estoque","@E 9,999,999.99")
TRCell():New(oSection1,"QTDPED","SC6","Qtd. Pedido","@E 9,999,999.99")
TRCell():New(oSection1,"VALPED","SC6","Val. Pedido","@E 9,999,999.99")
TRCell():New(oSection1,"B2_SALPEDI","SB2")

oSection1:Cell("B2_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B2_QATU"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("QTDPED"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("VALPED"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B2_SALPEDI"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("B2_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B2_QATU"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALEST"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("QTDPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B2_SALPEDI"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)


TRFunction():New(oSection1:Cell("B2_QATU"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALEST"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("QTDPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)


Return oReport

Static Function fEstPed3(oReport)
*****************************
Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT	SB2.B2_COD, SB1.B1_DESC, SB2.B2_SALPEDI,
	SUM(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QTDPED,
	SUM((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALPED, SB2.B2_QATU,
	(SB2.B2_QATU*SB2.B2_CM1) AS VALEST
	FROM %table:SB2% SB2
	INNER JOIN %table:SB1% SB1 ON SB1.B1_FILIAL = %xfilial:SB1%
	AND SB1.B1_COD = SB2.B2_COD
	AND SB1.%notDel%
	
	LEFT JOIN %table:SC6% SC6 ON SC6.C6_FILIAL = %xfilial:SC6%
	AND SC6.C6_PRODUTO = SB2.B2_COD
	AND SC6.C6_LOCAL = SB2.B2_LOCAL 
	AND SC6.C6_TES NOT IN ('506','802')
	AND SC6.%notDel%
	WHERE SB2.B2_FILIAL = %xfilial:SB2%
	AND SB2.B2_LOCAL = '40'
	AND SB2.B2_QATU > 0
	AND SB2.%notDel%
	
	GROUP BY SB2.B2_COD, SB1.B1_DESC, SB2.B2_SALPEDI, SB2.B2_QATU,(SB2.B2_QATU*SB2.B2_CM1)
	ORDER BY VALEST DESC
EndSql

oSection1:EndQuery()

oSection1:Print()

Return

//================================================= IMPRESSÃO DO RANKING DE CLIENTES =================================================//
Static Function fRankCli()
***********************
Local cPerg   := PADR("BFATC003",10)
Local oReport := fRankCli2(cPerg)

fRankCli4(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function fRankCli2(cPerg)
****************************
Local oReport
Local oSection1

oReport := TReport():New("BFATC003","Ranking de Clientes",cPerg,{|oReport| fRankCli3(oReport)},"Impressão do relatório Ranking de Clientes")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Ranking de Clientes",{"SA1"})

TRCell():New(oSection1,"A1_COD","SA1")
TRCell():New(oSection1,"A1_LOJA","SA1")
TRCell():New(oSection1,"A1_NOME","SA1")
TRCell():New(oSection1,"FATURAMENTO","SD2","Faturamento","@E 9,999,999.99")
TRCell():New(oSection1,"PERC_FAT","SD2","Perc.","@R 999.99%")

oSection1:Cell("A1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("A1_LOJA"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("A1_NOME"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("FATURAMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("PERC_FAT"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("A1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("A1_LOJA"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("A1_NOME"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("FATURAMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("PERC_FAT"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

TRFunction():New(oSection1:Cell("FATURAMENTO"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("PERC_FAT"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

Return oReport

Static Function fRankCli3(oReport)
******************************
Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT	A1_COD, A1_LOJA, A1_NOME, FATURAMENTO,
	((FATURAMENTO/SUM(FATURAMENTO)OVER(PARTITION BY 1))*100) AS PERC_FAT
	FROM
	(
	SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SUM(SD2.D2_VALBRUT) AS FATURAMENTO
	FROM %table:SA1% SA1
	INNER JOIN %table:SD2% SD2 ON SD2.D2_FILIAL = %xfilial:SD2%
	AND SD2.D2_CLIENTE = SA1.A1_COD
	AND SD2.D2_LOJA = SA1.A1_LOJA           
	AND SD2.D2_TES NOT IN ('506','802')
	AND SD2.D2_TES IN (SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	//AND SF4.F4_ESTOQUE = 'S'
	AND SF4.F4_DUPLIC = 'S'
	/*AND F4_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	*/
	AND SF4.%notDel%
	)
	AND SD2.D2_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	AND SD2.D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SD2.D2_VALBRUT > 0
	AND SD2.%notDel%
	WHERE SA1.A1_FILIAL = %xfilial:SA1%
	AND SA1.%notDel%
	
	GROUP BY SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME
	) AS FATURAMENTO
	
	ORDER BY 4 DESC
EndSql

oSection1:EndQuery()
oSection1:Print()

Return

Static Function fRankCli4(cPerg)
*****************************
//PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03		,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
PutSX1(cPerg, "01", "Data de"      , "", "", "mv_ch1", "D", TAMSX3("D2_EMISSAO")[1] , 0, 0, "G", "",  , "", "", "mv_par01", "","","","","","","","","","","","","","","","")
PutSX1(cPerg, "02", "Data ate"     , "", "", "mv_ch2", "D", TAMSX3("D2_EMISSAO")[1] , 0, 0, "G", "",  , "", "", "mv_par02", "","","","","","","","","","","","","","","","")
Return

//================================================= IMPRESSÃO DO RANKING DE CLIENTES =================================================//
Static Function fRankPro()
***********************
Local cPerg   := PADR("BFATC003",10)
Local oReport := fRankPro2(cPerg)

fRankCli4(cPerg)

If Pergunte(cPerg,.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function fRankPro2(cPerg)
*****************************
Local oReport
Local oSection1

oReport := TReport():New("BFATC004","Ranking de Produtos",cPerg,{|oReport| fRankPro3(oReport)},"Impressão do relatório Ranking de Produtos")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Ranking de Produtos",{"SA1"})

TRCell():New(oSection1,"B1_COD","SB1")
TRCell():New(oSection1,"B1_DESC","SB1")
TRCell():New(oSection1,"FATURAMENTO","SD2","Faturamento","@E 9,999,999.99")
TRCell():New(oSection1,"PERC_FAT","SD2","Perc.","@R 999.99%")

oSection1:Cell("B1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("FATURAMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)
oSection1:Cell("PERC_FAT"):SetBorder("BOTTOM",1,CLR_BLACK,.T.)

oSection1:Cell("B1_COD"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("B1_DESC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("FATURAMENTO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("PERC_FAT"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

TRFunction():New(oSection1:Cell("FATURAMENTO"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("PERC_FAT"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

Return oReport

Static Function fRankPro3(oReport)
******************************
Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()

BeginSql alias cAlias
	SELECT	B1_COD, B1_DESC, FATURAMENTO,
	((FATURAMENTO/SUM(FATURAMENTO)OVER(PARTITION BY 1))*100) AS PERC_FAT
	FROM
	(
	SELECT SB1.B1_COD, SB1.B1_DESC, SUM(SD2.D2_VALBRUT) AS FATURAMENTO
	FROM %table:SB1% SB1
	INNER JOIN %table:SD2% SD2 ON SD2.D2_FILIAL = %xfilial:SD2%
	AND SD2.D2_COD = SB1.B1_COD        
	AND SD2.D2_TES NOT IN ('506','802')
	AND SD2.D2_TES IN (SELECT SF4.F4_CODIGO
	FROM %table:SF4% SF4
	WHERE SF4.F4_FILIAL = %xfilial:SF4%
	//AND SF4.F4_ESTOQUE = 'S'
	AND SF4.F4_DUPLIC = 'S'
	/*AND F4_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	*/
	AND SF4.%notDel%
	)
	AND SD2.D2_CF IN (
	'5101',
	'5102',
	'5401',
	'5403',
	'5501',
	'6101',
	'6102',
	'6107',
	'6108',
	'6109',
	'6118',
	'6119',
	'6401',
	'6403',
	'6501',
	'6502',
	'7101',
	'7102')
	AND SD2.D2_EMISSAO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
	AND SD2.D2_VALBRUT > 0
	AND SD2.%notDel%
	WHERE SB1.B1_FILIAL = %xfilial:SB1%
	AND SB1.%notDel%
	
	GROUP BY SB1.B1_COD, SB1.B1_DESC
	) AS FATURAMENTO
	
	ORDER BY 3 DESC
EndSql

oSection1:EndQuery()
oSection1:Print()

Return

//======================================== EXIBE TELA DO SALDO ATUAL ========================================//
Static Function fSaldoAtu()
************************
dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
If dbSeek(xFilial("SB1")+oBrwEst:aData[oBrwEst:nRecno,oBrwEst:ColPos("Codigo")])
	MaViewSB2(SB1->B1_COD)
EndIf

Return

//======================================== EXIBE TELA DE CONSULTA DE TÍTULO ========================================//
Static Function fConsTit()
***********************
Local cPesq := ""

cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Filial")]
cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Prefixo")]
cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("No. Titulo")]
cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Parcela")]
cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Tipo")]

If cOpcCart == "1"
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(cPesq)
		Fc050Con()
	Else
		ApMsgStop("Título não encontrado!", "[BFATC001] - NAO ENCONTRADO")
	EndIf
Else
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek(cPesq)
		Fc040Con()
	Else
		ApMsgStop("Título não encontrado!", "[BFATC001] - NAO ENCONTRADO")
	EndIf
EndIf

Return

Static Function BuscaMeta()
************************
LOCAL nRetu := 0, cQuery := ""
                   
If (u_BXRepAdm()) //Parametro/Presidente/Diretor
	nRetu := GetMv("BR_METAFAT")
Else
	cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
	If !Empty(cCodRep)
		cQuery := "SELECT SUM(CT_VALOR) M_META FROM "+RetSqlName("SCT")+" SCT "
		cQuery += "WHERE SCT.D_E_L_E_T_ = '' AND SCT.CT_FILIAL = '"+xFilial("SCT")+"' AND SCT.CT_VEND IN ("+cCodRep+") "
		cQuery += "AND SCT.CT_DATA BETWEEN '"+Left(dtos(DDATABASE),6)+"' AND '"+Left(dtos(DDATABASE),6)+"99' "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nRetu += MAR->M_META
			MAR->(dbSkip())
		Enddo
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
	Endif
Endif	

Return nRetu