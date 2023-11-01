/*
+----------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                          !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! Atualiza?o                                             !
+------------------+---------------------------------------------------------+
!Modulo            ! FAT - Faturamento                                       !
+------------------+---------------------------------------------------------+
!Nome              ! IFATC020                                                !
+------------------+---------------------------------------------------------+
!Descricao         ! Consulta de situa?o de pedidos (Mapa Operacional)      !
+------------------+---------------------------------------------------------+
!Autor             ! PAULO AFONSO ERZINGER JUNIOR                            !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 05/01/2012                                              !
+------------------+---------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN


#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function IFATC020()
**********************
Local aFolder := {'Estoque','Ent. Ped.','Financeiro','Faturamento'} 
//Local aFolder := {'Estoque','Faturamento'}
//Local aFolder := {'Financeiro','Faturamento'}

U_ITECX010("IFATC020","Mapa Operacional")//Grava detalhes da rotina usada

//????????????????????????????????
//?Gravacao do historico de acessos (ZGY e ZGZ)                 ?
//????????????????????????????????  

//If ExistBlock("GDVRDMENT") //Verifico rotina GDVRDMENT
//	u_GDVRdmEnt() //Entrada na rotina
//Endif

//============= VARIAVEIS ABA ESTOQUE =============//
Private cLocalDe  := "  "
Private cLocalAte := "99"

Private aOpcEst   := {"1=Produto","2=Tipo Produto","3=Grupo de Produto"}
Private cOpcEst   := SUBSTR(aOpcEst[1],1,1)

Private cAliasEst := GetNextAlias()
Private aEstoque  := {}
Private cPesEst   := Space(2)
//Private cTipEst   := Space(2)
//Private cTipop := "  " 

//============= VARIAVEIS ABA ENTRADA DE PEDIDOS =============//
Private aOpcPed  := {"1=Pedido","2=Grupo Clientes","3=Grupo Produto"}
Private cOpcPed  := SUBSTR(aOpcPed[1],1,1)
Private oFont := TFont():New("Courier New",0,14,,.T.,,,,,.F.,.F.)

Private aPedidos := {}
Private aRelato1 := {}, nLinha1 := 0
Private dDataEnt := DDATABASE
Private aTotPed  := {}

//============= VARIAVEIS ABA FATURAMENTO =============//
Private oOk      := LoadBitMap(GetResources(), "QMT_OK")
Private oNo      := LoadBitMap(GetResources(), "QMT_NO")
Private oAt      := LoadBitMap(GetResources(), "QMT_COND")
Private oLa      := LoadBitMap(GetResources(), "CHECKED_CHILD_25")

	//@ 002,005 BITMAP OBMP RESNAME "QMT_NO" 				SIZE 16,16 NOBORDER OF OWIN2 PIXEL	// VERMELHO
	//@ 020,005 BITMAP OBMP RESNAME "QMT_OK"				SIZE 16,16 NOBORDER OF OWIN2 PIXEL	// VERDE

Private aFatura  := {}

Private cProduto := SPACE(TAMSX3("B1_COD")[1])
Private cPedido  := SPACE(TAMSX3("C5_NUM")[1])
Private cCliente := SPACE(TAMSX3("A1_COD")[1])
Private cLoja    := SPACE(TAMSX3("A1_LOJA")[1])
Private cNome    := SPACE(TAMSX3("A1_NOME")[1])
Private cFamilia := SPACE(TAMSX3("B1_GRUPO")[1])
Private dEntDe   := CTOD("  /  /  ")
Private dEntAte  := DDATABASE

//Private nValMin  := SuperGetMv("BR_VALMIN") 
Private nValMin  := 200//SuperGetMv("200,00")
Private cLote	 := SPACE(TAMSX3("C6_LOTECTL")[1]) //19/03/2020

Private aOpcao   := {"1=Todos os Pedidos","2=Pendente Rentab.","3=Rejeitado Rentab.","4=Pendente Liberacao","5=Rejeitado no Creito","6=Item sem Estoque","7=Pedidos sem Estoque","8=Em Analise de Credito","9=Aptos a Faturar"}
Private cOpcao   := SUBSTR(aOpcao[1],1,1)

Private aOrdem   := {"1=Produto","2=Pedido","3=Cliente"}
Private cOrdem   := SUBSTR(aOrdem[1],1,1)

//Private aFilFat   := {"01=Matriz","02=Manaus","00=Ambas"}
//Private cFilFat   := cFilAnt //vari?el que guarda a filial corrente
Private aFilFat   := {"02=Itajai","03=Manaus","04=Manaus2","00=Todas"}
Private cFilFat   := cFilAnt //vari?el que guarda a filial corrente

Private cFiltroSC9  := ""
Private cFiltroSC6  := ""

Private aFilDupli	:= {"S=Sim","N=Nao"}
Private cFilDupli	:= "S"

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
Private aFilTip    := {"1=Todos","2=Em Aberto","3=Liquidados"}
Private cFilTip    := aFilTip[1]
Private cTipTit    := Space(3)
Private aFilFin    := {"01=Matriz","02=Manaus","00=Ambas"}
Private cFilFin    := cFilAnt
Private cNomFin    := Space(TAMSX3("E1_NOMCLI")[1])
Private cNumFat    := Space(TAMSX3("E1_FATURA")[1])
Private cUsrTop	   := SuperGetMV("TG_USERTOP",.F.,"")

//=================================================//
Private aRotina := {{ "Pesquisar" , "AxPesqui" , 0 , 1},;
	{ "Visualizar", "AxVisual" , 0 , 2},;
	{ "Incluir"   , "AxInclui" , 0 , 3},;
	{ "Alterar"   , "AxAltera" , 0 , 4, 20 },;
	{ "Excluir"   , "AxExclui" , 0 , 5, 21 }}


// Calcula as dimensoes dos objetos                                         
oSize := FwDefSize():New( .F. ) // Com enchoicebar
oSize:lLateral     := .F.  // Calculo vertical
// adiciona folder                                                           
oSize:AddObject( "FOLDER",100, 100, .T., .T. ) // Adiciona Folder               
// Dispara o calculo                                                     
oSize:Process()

//DEFINE MSDIALOG oDlgMapa TITLE "[IFATC020] - Mapa Operacional" From 004,004 to 900,2000 Pixel //19/03/2020
DEFINE MSDIALOG oDlgMapa TITLE "[IFATC020] - Mapa Operacional" FROM oSize:aWindSize[1],oSize:aWindSize[2] TO oSize:aWindSize[3],oSize:aWindSize[4] PIXEL

//oFolder := TFolder():New(002,004,aFolder,,oDlgMapa,,,,.T.,,650,300 )
//oFolder:Align := CONTROL_ALIGN_ALLCLIENT
//oFolder :SetOption(4)

oFolder:=TFolder():New( oSize:GetDimension("FOLDER","LININI"),;
	oSize:GetDimension("FOLDER","COLINI"),aFolder,,oDlgMapa,,,,.T.,;
	.T.,oSize:GetDimension("FOLDER","XSIZE"),;
	oSize:GetDimension("FOLDER","YSIZE"))
oFolder :SetOption(4)


//======================================================== ABA ESTOQUE ========================================================//
//oGrpFilEst := tGroup():New(005,005,032,400,"Filtros",oFolder:aDialogs[1],CLR_HBLUE,,.T.)
oGrpFilEst := tGroup():New(005,005,032,oSize:GetDimension("FOLDER","XSIZE") - 4,"Filtros",oFolder:aDialogs[1],CLR_HBLUE,,.T.)

oSayLocDe  := tSay():New(017,010,{|| "Armazem de:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLocDe  := tGet():New(015,045,{|u| if(PCount()>0,cLocalDe:=u,cLocalDe)}, oGrpFilEst,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLocalDe')

oSayLocAte := tSay():New(017,070,{|| "Ate"  },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLocAte := tGet():New(015,085,{|u| if(PCount()>0,cLocalAte:=u,cLocalAte)}, oGrpFilEst,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLocalAte')

oSayOpcEst := tSay():New(017,120,{|| "Aglutinar por:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpcEst := tComboBox():New(015,160,{|u|if(PCount()>0,cOpcEst:=u,cOpcEst)},aOpcEst,70,9,oGrpFilEst,, { || cPesEst := Space(200) } ,,,,.T.,,,,,,,,,'cOpcEst')

//oSayTipEst := tSay():New(017,250,{|| "Tipo de Prod:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
//oGetTipEst := tGet():New(015,300,{|u| if(PCount()>0,cTipEst:=u,cTipop)}, oGrpFilEst,80,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cTipop')

oSayPesEst := tSay():New(017,250,{|| "Tipo Prod:" },oGrpFilEst,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetPesEst := tGet():New(015,280,{|u| if(PCount()>0,cPesEst:=u,cPesEst)}, oGrpFilEst,080,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cPesEst')

oBtnAtuEst := tButton():New(015, 400, "Atualizar" , oGrpFilEst, { || Processa({|| fAtuEst() }, "[IFATC020] - AGUARDE") },40,12,,,,.T.,,,,,,)

//oGrpEst := tGroup():New(037,005,257,445,"Estoques", oFolder:aDialogs[1],CLR_HBLUE,,.T.)
oGrpEst := tGroup():New(037,005,oSize:GetDimension("FOLDER","YSIZE")-24,oSize:GetDimension("FOLDER","XSIZE") - 4,"Estoques", oFolder:aDialogs[1],CLR_HBLUE,,.T.)

//oBrwEst := MYGRID():New(oGrpEst,047,010,430,205,15)
oBrwEst := MYGRID():New(oGrpEst,047,010,oSize:GetDimension("FOLDER","XSIZE") - 24,oSize:GetDimension("FOLDER","YSIZE")-100,15)
oBrwEst:oGrid:Align := CONTROL_ALIGN_ALLCLIENT
oBrwEst:LDblClick({|| fSaldoAtu() })

oBtnSair1 := tButton():New(oSize:GetDimension("FOLDER","YSIZE")-40, 590, "Sair"   , oGrpEst, {|| oDlgMapa:End() },50,12,,,,.T.,,,,,,)

//======================================================== ABA ENTRADA DE PEDIDOS ========================================================//
oSayOpcP := tSay():New(007,005,{|| "Opcoes:" },oFolder:aDialogs[2],,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpcP := tComboBox():New(005,035,{|u|if(PCount()>0,cOpcPed:=u,cOpcPed)},aOpcPed,70,9,oFolder:aDialogs[2],, { ||  } ,,,,.T.,,,,,,,,,'cOpcPed')

oSayDatEnt := tSay():New(007,125,{|| "Data:" },oFolder:aDialogs[2],,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetDatEnt := tGet():New(005,150,{|u| if(PCount()>0,dDataEnt:=u,dDataEnt)},oFolder:aDialogs[2],50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dDataEnt')

oBtnAtuEnt := tButton():New(005, 400, "Atualizar" , oFolder:aDialogs[2], { || Processa({|| fAtuPed() }, "[IFATC020] - AGUARDE") },40,12,,,,.T.,,,,,,)

//oGrpEnt := tGroup():New(020,005,170,445,, oFolder:aDialogs[2],CLR_HBLUE,,.T.)
nSizeT := Round((oSize:GetDimension("FOLDER","YSIZE")-24) * (64/100),0)
nSizeT := 20 + nSizeT
oGrpEnt := tGroup():New(020,005,nSizeT,oSize:GetDimension("FOLDER","XSIZE") - 4,, oFolder:aDialogs[2],CLR_HBLUE,,.T.)
//oBrwPed := MYGrid():New(oGrpEnt,025,010,430,140,9)
oBrwPed := MYGrid():New(oGrpEnt,025,010,oSize:GetDimension("FOLDER","XSIZE") - 24,nSizeT-35,9)
oBrwPed:oGrid:Align := CONTROL_ALIGN_ALLCLIENT

nSizet2 := ((oSize:GetDimension("FOLDER","XSIZE") - 4)-5)/2
//oGrpTotMes := tGroup():New(175,005,255,220,"Pedidos que entraram no m? " + STRZERO(MONTH(dDataEnt),2) +"/" + ALLTRIM(STR(YEAR(dDataEnt))), oFolder:aDialogs[2],CLR_HBLUE,,.T.)
oGrpTotMes := tGroup():New(nSizeT+3,005,oSize:GetDimension("FOLDER","YSIZE")-60,nSizet2,"Pedidos que entraram no m? " + STRZERO(MONTH(dDataEnt),2) +"/" + ALLTRIM(STR(YEAR(dDataEnt))), oFolder:aDialogs[2],CLR_HBLUE,,.T.)

//oBrwTotMes := TCBrowse():New(185,010,205,065,,,,oGrpTotMes,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotMes := TCBrowse():New((nSizeT+3)+10,010,205,065,,,,oGrpTotMes,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotMes:AddColumn(TCColumn():New("Entrega p/ M?" , {|| aTotPed[oBrwTotMes:nAt,01]},,,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Atual"          , {|| aTotPed[oBrwTotMes:nAt,02]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Futuro"         , {|| aTotPed[oBrwTotMes:nAt,03]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:AddColumn(TCColumn():New("Total"          , {|| aTotPed[oBrwTotMes:nAt,04]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotMes:SetArray(aTotPed)
oBrwTotMes:Align := CONTROL_ALIGN_ALLCLIENT

//oGrpTotDia := tGroup():New(175,225,255,445,"Pedidos que entraram no dia " + DTOC(dDataEnt), oFolder:aDialogs[2],CLR_HBLUE,,.T.)
oGrpTotDia := tGroup():New(nSizeT+3,nSizet2+5,oSize:GetDimension("FOLDER","YSIZE")-60,oSize:GetDimension("FOLDER","XSIZE") - 4,"Pedidos que entraram no dia " + DTOC(dDataEnt), oFolder:aDialogs[2],CLR_HBLUE,,.T.)

//oBrwTotDia := TCBrowse():New(185,230,210,065,,,,oGrpTotDia,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotDia := TCBrowse():New((nSizeT+3)+10,nSizet2+10,210,065,,,,oGrpTotDia,,,,,,,,,,,,.F.,,.T.,,.F.,,.F.,.F.)
oBrwTotDia:AddColumn(TCColumn():New("Entrega p/ M?" , {|| aTotPed[oBrwTotDia:nAt,01]},,,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Atual"          , {|| aTotPed[oBrwTotDia:nAt,05]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Futuro"         , {|| aTotPed[oBrwTotDia:nAt,06]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:AddColumn(TCColumn():New("Total"          , {|| aTotPed[oBrwTotDia:nAt,07]},"@E 9,999,999.99",,,,50,.F.,.F.,,,,.F., ) )
oBrwTotDia:SetArray(aTotPed)
oBrwTotDia:Align := CONTROL_ALIGN_ALLCLIENT

oBtnSair2 := tButton():New(oSize:GetDimension("FOLDER","YSIZE")-40, 590, "Sair"   , oFolder:aDialogs[2], {|| oDlgMapa:End() },50,12,,,,.T.,,,,,,)

//========================================================== ABA FINANCEIRO ==========================================================//
//oGrpFilFin := tGroup():New(005,005,060,445,"Filtros",oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oGrpFilFin := tGroup():New(005,005,060,oSize:GetDimension("FOLDER","XSIZE") - 4,"Filtros",oFolder:aDialogs[3],CLR_HBLUE,,.T.)

oSayCartei := tSay():New(017,010,{ || "Carteira:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbCartei := tComboBox():New(015,040,{|u|if(PCount()>0,cOpcCart:=u,cOpcCart)},aOpcCart,50,9,oGrpFilFin,, { || BTrocaCar() } ,,,,.T.,,,,,,,,,'cOpcCart')

oSayCliFor := tSay():New(017,105,{ || "Cliente:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetCliFor := tGet():New(015,135,{|u| if(PCount()>0,cCliFor:=u,cCliFor)}, oGrpFilFin,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,"SA1",'cCliFor')
oGetFinLoj := tGet():New(015,190,{|u| if(PCount()>0,cFinLoj:=u,cFinLoj)}, oGrpFilFin,25,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cFinLoj')
oGetFinNom := tGet():New(015,220,{|u| if(PCount()>0,cFinNom:=u,cFinNom)}, oGrpFilFin,150,9,'@!',{ ||  },,,,,,.T.,,, {|| .F. } ,,,,.F.,,,'cFinNom')

oBtnAtuFin := tButton():New(015, 390, "Atualizar" , oGrpFilFin, { || Processa({|| fAtuFin() }, "[IFATC020] - AGUARDE") },40,12,,,,.T.,,,,,,)

oSayFEmiDe := tSay():New(032,010,{ || "Emiss? de:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFEmiDe := tGet():New(030,040,{|u| if(PCount()>0,dFinEmiDe:=u,dFinEmiDe)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinEmiDe')

oSayFEmiAt := tSay():New(032,095,{ || "ate" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFEmiAt := tGet():New(030,107,{|u| if(PCount()>0,dFinEmiAte:=u,dFinEmiAte)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinEmiAte')

oSayFinTit := tSay():New(032,170,{ || "Titulo:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFinTit := tGet():New(030,190,{|u| if(PCount()>0,cTitFin:=u,cTitFin)}, oGrpFilFin,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cTitFin')

oSayFilTip := tSay():New(032,258,{|| "Filtro:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbFilTip := tComboBox():New(030,275,{|u|if(PCount()>0,cFilTip:=u,cFilTip)},aFilTip,50,9,oGrpFilFin,, { ||  } ,,,,.T.,,,,,,,,,'cFilTip')

oSayTipTit := tSay():New(032,345,{ || "Tipo:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetTipTit := tGet():New(030,360,{|u| if(PCount()>0,cTipTit:=u,cTipTit)}, oGrpFilFin,30,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'05','cTipTit')

oSayFVctDe := tSay():New(047,010,{ || "Vencto de:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFVctDe := tGet():New(045,040,{|u| if(PCount()>0,dFinVctDe:=u,dFinVctDe)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinVctDe')

oSayFVctAt := tSay():New(047,095,{ || "ate" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFVctAt := tGet():New(045,107,{|u| if(PCount()>0,dFinVctAte:=u,dFinVctAte)}, oGrpFilFin,50,9,'@D',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'dFinVctAte')

oSayFilFin := tSay():New(047,170,{|| "Filial:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbFilFin := tComboBox():New(045,190,{|u|if(PCount()>0,cFilFin:=u,cFilFin)},aFilFin,50,9,oGrpFilFin,, { ||  } ,,,,.T.,,,,,,,,,'cFilFin')

oSayFinNom := tSay():New(047,250,{ || "Nome Cli:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFinNom := tGet():New(045,278,{|u| if(PCount()>0,cNomFin:=u,cNomFin)}, oGrpFilFin,75,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cNomFin')

oSayFinFat := tSay():New(047,378,{ || "Fatura:" },oGrpFilFin,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFinFat := tGet():New(045,400,{|u| if(PCount()>0,cNumFat:=u,cNumFat)}, oGrpFilFin,40,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cNumFat')

//oGrpTitFin := tGroup():New(065,005,195,445,, oFolder:aDialogs[3],CLR_HBLUE,,.T.)
nSizeT := Round((oSize:GetDimension("FOLDER","YSIZE")-24) * (64/100),0)
nSizeT := 65 + nSizeT
oGrpTitFin := tGroup():New(065,005,nSizeT,oSize:GetDimension("FOLDER","XSIZE") - 4,, oFolder:aDialogs[3],CLR_HBLUE,,.T.)

//oBrwTitFin := MYGrid():New(oGrpTitFin,075,010,430,115,8)
oBrwTitFin := MYGrid():New(oGrpTitFin,070,010,oSize:GetDimension("FOLDER","XSIZE") - 24,nSizeT-75,8)
oBrwTitFin:LDblClick( { || fConsTit() } )
oBrwTitFin:oGrid:Align := CONTROL_ALIGN_ALLCLIENT

nSizet2 := ((oSize:GetDimension("FOLDER","XSIZE") - 4)-5)/2
nLinGF := nSizeT+15
nLinGF2 := nSizeT+15
//oGrpFinRec := tGroup():New(200,005,260,220,"Totais (A Receber)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oGrpFinRec := tGroup():New(nSizeT+5,005,oSize:GetDimension("FOLDER","YSIZE")-42,nSizet2,"Totais (A Receber)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oSayTotSR  := tSay():New(nLinGF,010,{|| "Total Contas a Receber: " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSR    := tSay():New(nLinGF,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF += 10

oSayFilSR  := tSay():New(nLinGF,010,{|| "Saldo a Receber: " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSFilSR    := tSay():New(nLinGF,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF += 10

oSayFilLR  := tSay():New(nLinGF,010,{|| "Total Liquidado: " },oGrpFinRec,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSFilLR    := tSay():New(nLinGF,150,,oGrpFinRec,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

//oGrpFinPag := tGroup():New(200,225,260,445,"Totais (A Pagar)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oGrpFinPag := tGroup():New(nSizeT+5,nSizet2+5,oSize:GetDimension("FOLDER","YSIZE")-42,oSize:GetDimension("FOLDER","XSIZE") - 4,"Totais (A Pagar)", oFolder:aDialogs[3],CLR_HBLUE,,.T.)
oSayTotSP  := tSay():New(nLinGF2,(nSizet2+10),{|| "Total Contas a Pagar: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSP    := tSay():New(nLinGF2,(nSizet2+10)+140,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF2 += 10

oSayFilSP  := tSay():New(nLinGF2,(nSizet2+10),{|| "Saldo a Pagar: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSFilSP    := tSay():New(nLinGF2,(nSizet2+10)+140,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF2 += 10

oSayFilLP  := tSay():New(nLinGF2,(nSizet2+10),{|| "Total Liquidado: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSFilLP    := tSay():New(nLinGF2,(nSizet2+10)+140,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF2 += 10

oSayTotSTP := tSay():New(nLinGF2,(nSizet2+10),{|| "Saldo a Pagar ST/Produtos: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSTP   := tSay():New(nLinGF2,(nSizet2+10)+140,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)
nLinGF2 += 10

oSayTotSTI := tSay():New(nLinGF2,(nSizet2+10),{|| "Saldo a Pagar ST/Compl. Icms: " },oGrpFinPag,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotSTI   := tSay():New(nLinGF2,(nSizet2+10)+140,,oGrpFinPag,"@E 99,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oBtnSairF := tButton():New(oSize:GetDimension("FOLDER","YSIZE")-35, 590, "Sair"   , oFolder:aDialogs[3], {|| oDlgMapa:End() },50,12,,,,.T.,,,,,,)

//========================================================== ABA FATURAMENTO ==========================================================//
//oGrpFil := tGroup():New(003,005,055,645,"Filtros",oFolder:aDialogs[4],CLR_HBLUE,,.T.)
oGrpFil := tGroup():New(003,005,055,oSize:GetDimension("FOLDER","XSIZE") - 4,"Filtros",oFolder:aDialogs[4],CLR_HBLUE,,.T.)

oSayProd := tSay():New(014,010,{|| "Produto:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetProd := tGet():New(012,035,{|u| if(PCount()>0,cProduto:=u,cProduto)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SB1','cProduto')

oSayPed  := tSay():New(014,120,{|| "Pedido:"  },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetPed  := tGet():New(012,145,{|u| if(PCount()>0,cPedido:=u,cPedido)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SC5','cPedido')

oSayFam  := tSay():New(014,215,{|| "Família:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFam  := tGet():New(012,235,{|u| if(PCount()>0,cFamilia:=u,cFamilia)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SBM','cFamilia')

oSayVal  := tSay():New(014,340,{|| "Valor Mínimo:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetVal  := tGet():New(012,375,{|u| if(PCount()>0,nValMin:=u,nValMin)}, oGrpFil,50,9,'@E 9,999,999.99', { ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'nValMin')

oSayFam  := tSay():New(014,445,{|| "Lote:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetFam  := tGet():New(012,473,{|u| if(PCount()>0,cLote:=u,cLote)}, oGrpFil,50,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SB8MFJ','cLote')

oSayCli  := tSay():New(029,010,{|| "Cliente:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetCli  := tGet():New(027,035,{|u| if(PCount()>0,cCliente:=u,cCliente)}, oGrpFil,50,9,'@!',;
{ || fAtuFat(), IIf(!Empty(cCliente), (cNome := SA1->A1_NOME), (cNome := SPACE(TAMSX3("A1_NOME")[1]), cLoja := SPACE(TAMSX3("A1_LOJA")[1])) ) },;
,,,,,.T.,,, {|| .T. } ,,,,.F.,,'SA1','cCliente')

oSayLoja := tSay():New(029,120,{|| "Loja:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetLoja := tGet():New(027,145,{|u| if(PCount()>0,cLoja:=u,cLoja)}, oGrpFil,20,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.F.,,,'cLoja')

oSayNome := tSay():New(029,215,{|| "Nome:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetNome := tGet():New(027,235,{|u| if(PCount()>0,cNome:=u,cNome)}, oGrpFil,92,9,'@!',{ ||  },,,,,,.T.,,, {|| .F. } ,,,,.F.,,,'cNome')

oSayEntDe  := tSay():New(029,340,{|| "Dt.Fat de:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetEntDe  := tGet():New(027,375,{|u| if(PCount()>0,dEntDe:=u,dEntDe)}, oGrpFil,50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dEntDe')

oSayEntAte := tSay():New(029,445,{|| "Dt.Fat ate:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oGetEntAte := tGet():New(027,473,{|u| if(PCount()>0,dEntAte:=u,dEntAte)}, oGrpFil,50,9,'@D',{ ||  },,,,,,.T.,,,,,,,.F.,,,'dEntAte')

oSayOpc := tSay():New(043,010,{|| "Opções:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOpc := tComboBox():New(041,035,{|u|if(PCount()>0,cOpcao:=u,cOpcao)},aOpcao,70,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cOpcao')

oSayOrd := tSay():New(043,120,{|| "Ordem:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbOrd := tComboBox():New(041,145,{|u|if(PCount()>0,cOrdem:=u,cOrdem)},aOrdem,50,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cOrdem')

oSayFil := tSay():New(043,215,{|| "Filial:" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
oCmbFil := tComboBox():New(041,235,{|u|if(PCount()>0,cFilFat:=u,cFilFat)},aFilFat,50,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cFilFat')

oSayComD := tSay():New(043,340,{|| "Considera apenas quem gera financeiro?" },oGrpFil,,,,,,.T.,CLR_BLACK,CLR_WHITE,120,9)
oCmbComD := tComboBox():New(041,445,{|u|if(PCount()>0,cFilDupli:=u,cFilDupli)},aFilDupli,50,9,oGrpFil,, { ||  } ,,,,.T.,,,,,,,,,'cFilDupli')

//oBtnAtu  := tButton():New(025, 560, "Atualizar" , oGrpFil, { || Processa({ || fAtuFat() },"[IFATC020] - AGUARDE") },50,12,,,,.T.,,,,,,) // 19/03/2020
oBtnAtu    := tButton():New(010, 560, "Atualizar" , oGrpFil, { || Processa({ || fAtuFat() },"[IFATC020] - AGUARDE") },50,12,,,,.T.,,,,,,) // 19/03/2020
oBtnPedEst := tButton():New(024, 560, "Pedidos x Estoque" , oGrpFil, {|| fPedEst()  },50,12,,,,.T.,,,,,,)
oBtnSair3  := tButton():New(038, 560, "Sair"   , oGrpFil, {|| oDlgMapa:End() },50,12,,,,.T.,,,,,,)

//oGrpPed := tGroup():New(058,005,210,645,"Pedidos", oFolder:aDialogs[4],CLR_HBLUE,,.T.)
//nSizeT := Round((oSize:GetDimension("FOLDER","YSIZE")-24) * (64/100),0)
nSizeT := Round((oSize:GetDimension("FOLDER","YSIZE")-24) * (44/100),0)
nSizeT := 58 + nSizeT
oGrpPed := tGroup():New(058,005,nSizeT,oSize:GetDimension("FOLDER","XSIZE") - 4,"Pedidos", oFolder:aDialogs[4],CLR_HBLUE,,.T.)

oBrwFat := TCBrowse():New(066,010,625,135,,,,oGrpPed,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
oBrwFat:Align := CONTROL_ALIGN_ALLCLIENT
//oBrwFat:AddColumn(TCColumn():New("Filial"    , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,01],0)},,,,,20,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Pedido"    , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,02],0)},,,,,20,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Item"      , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,03],0)},,,,,12,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Produto"   , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,04],0)},,,,,25,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Descricao" , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,05],0)},,,,,60,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Qtd. Est." , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,06],0)},"@E 9,999,999.99",,,, 30 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Saldo Disp", {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,07],0)},"@E 9,999,999.99",,,, 30 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Quantidade", {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,08],0)},"@E 9,999,999.99",,,, 40 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Valor"     , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,09],0)},"@E 9,999,999.99",,,, 40 ,.F.,.T.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Rentabilidade"  , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),If(aFatura[oBrwFat:nAt,10]=='1',oAt,If(aFatura[oBrwFat:nAt,10]=='2',oNo,oOk)),0) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Liberacao" , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),If(Empty(aFatura[oBrwFat:nAt,11]),oAt,oOk),0) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Estoque"   , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),If(aFatura[oBrwFat:nAt,12]=='02',oAt,If(aFatura[oBrwFat:nAt,12]=='  ',oOk,oNo)),0) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Credito"   , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),If(aFatura[oBrwFat:nAt,13]=='01',oAt,If(aFatura[oBrwFat:nAt,13]=='  ',oOk,oNo)),0) },,,,,30,.T.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Lote"      , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,14],0)},,,,,20,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Tip.Fat", {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,15],0)},,,,,30,.F.,.F.,,,,.F., ) )
oBrwFat:AddColumn(TCColumn():New("Cliente"   , {|| iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),aFatura[oBrwFat:nAt,16],0)},,,,,80,.F.,.F.,,,,.F., ) )
oBrwFat:SetArray(aFatura)

oBrwFat:bLDblClick := { || iif(Len(aFatura)>0.and.(oBrwFat:nAt>0),(Posicione("SC5",1,aFatura[oBrwFat:nAt,01]+aFatura[oBrwFat:nAt,02],"C5_NUM"),A410Visual("SC5",SC5->(Recno()),2)),0) }

//oGrpTot := tGroup():New(205,005,280,645,"Totais", oFolder:aDialogs[4],CLR_HBLUE,,.T.)
oGrpTot := tGroup():New((nSizeT + 3),005,oSize:GetDimension("FOLDER","YSIZE")-24,oSize:GetDimension("FOLDER","XSIZE") - 4,"Totais", oFolder:aDialogs[4],CLR_HBLUE,,.T.)
nLinG3 := (nSizeT + 3) + 9

oSayTotPed := tSay():New(nLinG3,015,{|| "1= Total de Pedidos: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,380,9)
oSTotPed := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oSayTotFat := tSay():New(nLinG3,220,{|| "Faturado no dia " + DTOC(DDATABASE) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotFat := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayTotMes := tSay():New(nLinG3,450,{|| "Acumulado do mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotMes := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotPRet := tSay():New(nLinG3,015,{|| "2= Pedidos Pend.Analise Rentab.: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSToPRet := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatDBol := tSay():New(nLinG3,220,{|| "Faturado no dia BOLETO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatDBol := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatMBol := tSay():New(nLinG3,450,{|| "Faturado no mês BOLETO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatMBol := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotRRet := tSay():New(nLinG3,015,{|| "3= Pedidos Rejeitados Rentab.: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSToRRet := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatDAvi := tSay():New(nLinG3,220,{|| "Faturado no dia DP/A VISTA: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatDAvi := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatMAvi := tSay():New(nLinG3,450,{|| "Faturado no mês DP/A VISTA: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatMAvi := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotPen := tSay():New(nLinG3,015,{|| "4= Pedidos Pendentes Liberacao: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotPen := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatDNeg := tSay():New(nLinG3,220,{|| "Faturado no dia DP/NEGOCIADO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatDNeg := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatMNeg := tSay():New(nLinG3,450,{|| "Faturado no mês DP/NEGOCIADO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatMNeg := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotRej := tSay():New(nLinG3,015,{|| "5= Pedidos Rejeitados no Credito: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotRej := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatDCC := tSay():New(nLinG3,220,{|| "Faturado no dia CARTAO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatDCC := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayFatMCC := tSay():New(nLinG3,450,{|| "Faturado no mês CARTAO: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSFatMCC := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotSes := tSay():New(nLinG3,015,{|| "6= Itens sem Estoque Disponivel: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotSes := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK ,CLR_WHITE,60,9)

oSayDevFat := tSay():New(nLinG3,220,{|| "Devolvido no dia " + DTOC(DDATABASE) + ": " },oGrpTot,,oFont,,,,.T.,CLR_HRED,CLR_WHITE,380,9)
oDTotFat := tSay():New(nLinG3,325,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_HRED,CLR_WHITE,60,9)

//oSayTitDev := tSay():New(nLinG3,450,{|| "DEVOLUÇÕES: " },oGrpTot,,oFont,,,,.T.,CLR_HRED,CLR_WHITE,380,9)
oSayDevMes := tSay():New(nLinG3,450,{|| "Devolvido no mês " + STRZERO(MONTH(DDATABASE),2) +"/" + ALLTRIM(STR(YEAR(DDATABASE))) + ": " },oGrpTot,,oFont,,,,.T.,CLR_HRED,CLR_WHITE,380,9)
oDTotMes := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_HRED,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotCre := tSay():New(nLinG3,015,{|| "7= Pedidos em Analise Credito: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotCre := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

oSayMetFat := tSay():New(nLinG3,450,{|| "Objetivo Faturamento: " },oGrpTot,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,380,9)
oGetMetFat := tSay():New(nLinG3,545,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,60,9)
nLinG3 += 9

oSayTotApt := tSay():New(nLinG3,015,{|| "8= Pedidos Aptos a Faturar: " },oGrpTot,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,380,9)
oSTotApt := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_BLACK,CLR_WHITE,60,9)

nLinG3 += 9
//nLinG3 += 15

//oSayMetFat := tSay():New(nLinG3,015,{|| "Objetivo Faturamento: " },oGrpTot,,oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,380,9)
//oGetMetFat := tSay():New(nLinG3,130,,oGrpTot,"@E 9,999,999,999.99",oFont,,,,.T.,CLR_HBLUE,CLR_WHITE,60,9)

nLinG3 += 9


//oBtnRkgPro := tButton():New(nLinG3, 410, "Ranking Produtos"  , oFolder:aDialogs[4], {|| fRankPro() },50,12,,,,.T.,,,,,,)
//oBtnRkgCli := tButton():New(nLinG3, 470, "Ranking Clientes"  , oFolder:aDialogs[4], {|| fRankCli() },50,12,,,,.T.,,,,,,)
//oBtnEstPed := tButton():New(275, 295, "Estoque x Pedidos" , oFolder:aDialogs[4], {|| fEstPed()  },50,12,,,,.T.,,,,,,)
//trocado de lugar
//oBtnPedEst := tButton():New(nLinG3, 530, "Pedidos x Estoque" , oFolder:aDialogs[4], {|| fPedEst()  },50,12,,,,.T.,,,,,,)

//oBtnPedEst := tButton():New(275, 295, "Pedidos x Estoque" , oFolder:aDialogs[4], {|| fPedEst()  },50,12,,,,.T.,,,,,,)
// 345
//======================================================= BOT?S FIXOS =======================================================//
//oBtnSair := tButton():New(286, 590, "Sair"   , oDlgMapa, {|| ::End() },50,12,,,,.T.,,,,,,)
//oBtnSair3 := tButton():New(nLinG3, 590, "Sair"   , oFolder:aDialogs[4], {|| oDlgMapa:End() },50,12,,,,.T.,,,,,,)

//==================================================== INICIALIZADORES =======================================================//
Processa({|| fAtuFat() }, "[IFATC020] - AGUARDE")

ACTIVATE MSDIALOG oDlgMapa CENTERED

//????????????????????????????????
//?Gravacao do historico de acessos (ZGY e ZGZ)                 ?
//????????????????????????????????
//If ExistBlock("GDVRDMSAI") //Verifico rotina GDVRDMSAI
//	u_GDVRdmSai() //Saida da rotina
//Endif

Return

//=========================================================== ATUALIZA FATURAMENTO ===========================================================//
Static Function fAtuFat()
***********************
LOCAL cQuery1 := ""
//Local cCodRep := ""
LOCAL cBrCfFat  := ''//u_BXLstCfTes("BR_CFFAT")
LOCAL cBrCfNFat := '5551'//u_BXLstCfTes("BR_CFNFAT")
LOCAL cBrTsFat  := ''//u_BXLstCfTes("BR_TSFAT")
LOCAL cBrTsNFat := ''//u_BXLstCfTes("BR_TSNFAT")
//LOCAL cAlias  := GetNextAlias()
LOCAL nTotPed := 0, nTotPen := 0, nTotSes := 0, nTotCre := 0
LOCAL nTotRej := 0, nTotEst := 0, nTotFat := 0, nTotRRet := 0, nTotPRet := 0
//LOCAL cHoje := "%"+dtos(dDatabase)+"%"
//LOCAL cMes  := "%"+Substr(dtos(dDatabase),1,6)+"%"
Local nx

aFatura := {}
                                               
//Monto Query para buscar dados de Pedidos
//////////////////////////////////////////
If (cOpcao $ "1234") //Pendentes de Liberacao
	cQuery1 := "SELECT SC6.C6_FILIAL AS FILIAL, SA1.A1_NOME AS NOME, SC6.C6_NUM AS PEDIDO, SC6.C6_ITEM AS ITEM, SC6.C6_PRODUTO AS PRODUTO, SC6.C6_LOCAL AS ARMAZEM, SC6.C6_QTDEMP AS QTDEMP, "
	cQuery1 += "SB2.B2_QATU AS QTDEST,(SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO, SB1.B1_DESC AS DESCRI,((SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))*SC6.C6_PRCVEN) AS VALOR, SC5.C5_TIPOFAT AS TIPOFAT,"
	cQuery1 += "(SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT)) AS QUANT,SC5.C5_BLQ AS BLQRENT,(CASE WHEN (SC9.C9_BLCRED IS NULL) THEN '01' ELSE SC9.C9_BLCRED END) AS BLQCREDITO,(CASE WHEN (SC9.C9_BLEST IS NULL) THEN '02' ELSE SC9.C9_BLEST END) AS BLQESTOQUE,SC5.C5_LIBEROK AS BLQPEDLIB, "
	cQuery1 += "(CASE WHEN (SC6.C6_QTDVEN-(SC6.C6_QTDEMP+SC6.C6_QTDENT))>(SB2.B2_QATU-SB2.B2_RESERVA) THEN 'N' ELSE 'S' END) AS BLQESTDISP, "
	cQuery1 += "(CASE WHEN (SC9.C9_LOTECTL IS NULL) THEN ' ' ELSE SC9.C9_LOTECTL END) AS LOTE "
	cQuery1 += "FROM "+RetSqlName("SC6")+" SC6 (NOLOCK) "
	cQuery1 += "INNER JOIN "+RetSqlName("SC5")+" SC5 (NOLOCK) ON (SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.C5_NUM = SC6.C6_NUM AND SC5.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SA1")+" SA1 (NOLOCK) ON (SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC6.C6_CLI AND SA1.A1_LOJA = SC6.C6_LOJA AND SA1.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SB1")+" SB1 (NOLOCK) ON (SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO AND SB1.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SF4")+" SF4 (NOLOCK) ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SC6.C6_TES AND SF4.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SB2")+" SB2 (NOLOCK) ON (SB2.B2_FILIAL = SC6.C6_FILIAL AND SB2.B2_COD = SC6.C6_PRODUTO AND SB2.B2_LOCAL = SC6.C6_LOCAL AND SB2.D_E_L_E_T_='') "
	cQuery1 += "FULL OUTER JOIN "+RetSqlName("SC9")+" SC9 (NOLOCK) ON (SC9.D_E_L_E_T_='' AND SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND SC9.C9_FILIAL = SC6.C6_FILIAL AND SC9.C9_PEDIDO = SC6.C6_NUM AND SC9.C9_ITEM = SC6.C6_ITEM AND SC9.C9_PRODUTO = SC6.C6_PRODUTO AND SC9.C9_LOCAL = SC6.C6_LOCAL ) "
	
	If !(alltrim(__cUserID) $ (cUsrTop))
		cQuery1 += "INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON (SA3.A3_COD = SA1.A1_VEND AND SA3.D_E_L_E_T_<> '*' AND (SA3.A3_CODUSR = '"+__cUserID+"' OR SA3.A3_USRAUX = '"+__cUserID+"' OR SA3.A3_GEREN = '"+__cUserID+"'OR SA3.A3_SUPER = '"+__cUserID+"'))"
	Endif	
	cQuery1 += "WHERE SC6.D_E_L_E_T_='' AND SC6.C6_BLQ<>'R' AND (SC6.C6_QTDVEN-SC6.C6_QTDEMP)>0 AND SC6.C6_QTDVEN>SC6.C6_QTDENT "
	if cFilDupli == "S"
		cQuery1 += "AND SF4.F4_DUPLIC='S' "
	endif
	If !Empty(cBrCfFat)
		cQuery1 += "AND SC6.C6_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery1 += "AND SC6.C6_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery1 += "AND SC6.C6_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery1 += "AND SC6.C6_TES NOT IN ("+cBrTsNFat+") "
	Endif
	If (cFilFat == "02")
		cQuery1 += "AND SC6.C6_FILIAL = '0102' "
	Elseif (cFilFat == "03")
		cQuery1 += "AND SC6.C6_FILIAL = '0103' "
	Elseif (cFilFat == "04")
		cQuery1 += "AND SC6.C6_FILIAL = '0104' "
	Endif
	If !Empty(cProduto)
		cQuery1 += "AND SC6.C6_PRODUTO = '"+cProduto+"' "
	EndIf
	If !Empty(cPedido)
		cQuery1 += "AND SC6.C6_NUM = '"+cPedido+"' "
	EndIf
	If !Empty(cCliente)
		cQuery1 += "AND SC6.C6_CLI = '"+cCliente+"' "
	EndIf
	If !Empty(cLoja)
		cQuery1 += "AND SC6.C6_LOJA = '"+cLoja+"' "
	EndIf
	If !Empty(cFamilia)
		cQuery1 += "AND SB1.B1_GRUPO = '"+cFamilia+"' "
	EndIf
	If !Empty(cLote)
		cQuery1 += "AND SC9.C9_LOTECTL = '"+cLote+"' "
	EndIf
	/*
	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery1 += "AND SC5.C5_VEND1 IN ("+cCodRep+") "
		Else
			cQuery1 += "AND SC5.C5_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	       
	*/
	If (cOpcao == "2") //Pend. Rentabilidade
		cQuery1 += "AND SC5.C5_BLQ = '1' "
	Endif
	
	If (cOpcao == "3") //Rejeitado Rentabilidade
		cQuery1 += "AND SC5.C5_BLQ = '2' "
	Endif
	
	cQuery1 += "AND SC6.C6_ENTREG BETWEEN '"+dtos(dEntDe)+"' AND '"+dtos(dEntAte)+"' "
	Do Case
		Case cOrdem == "1"; cQuery1 += "ORDER BY 5, 3, 2"
		Case cOrdem == "2"; cQuery1 += "ORDER BY 3, 2"
		Case cOrdem == "3"; cQuery1 += "ORDER BY 5, 3, 2"
	EndCase  
	cQuery1 := ChangeQuery(cQuery1)
	//memowrite('\data\IFATC020-1-FAT.txt',cQuery1)
	//memowrite('\data\teste_query_totped1.txt',cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	
	dbSelectArea("MAR")
	ProcRegua(1)
	dbGoTop()
	While !MAR->(Eof())
		
		IncProc("Buscando informa?es de faturamento...")
		                                                                                 
		cEstoque := "B"
		If Empty(MAR->BLQCREDITO)
			If (MAR->BLQESTDISP == "S").and.Empty(MAR->BLQESTOQUE)
				cEstoque := "L" //Liberado
			Elseif (MAR->BLQESTDISP == "N")
				cEstoque := "S" //Liberado sem estoque
			Endif
		Endif
		
		//AADD(aFatura,{MAR->FILIAL,MAR->PEDIDO,MAR->ITEM,MAR->PRODUTO,MAR->DESCRI,MAR->QTDEST,MAR->SALDO,MAR->QUANT,;
		//	MAR->VALOR,MAR->BLQPEDLIB,MAR->BLQCREDITO,cEstoque,iif(MAR->TIPLIB=="1","Item","Pedido"),MAR->NOME})
   		AADD(aFatura,{MAR->FILIAL,MAR->PEDIDO,MAR->ITEM,MAR->PRODUTO,MAR->DESCRI,MAR->QTDEST,MAR->SALDO,MAR->QUANT,;
			MAR->VALOR,MAR->BLQRENT,MAR->BLQPEDLIB,MAR->BLQESTOQUE,MAR->BLQCREDITO,MAR->LOTE,iif(MAR->TIPOFAT=="1","Item","Pedido"),MAR->NOME})
	
		nTotPed += MAR->VALOR
		nTotPen += MAR->VALOR
		If (MAR->BLQESTDISP == "N")
			nTotSes += MAR->VALOR
		Endif
		
		If (MAR->BLQRENT == "1") //Bloqueio Rentabilidade
			nTotPRet += MAR->VALOR
		Endif
		
		If (MAR->BLQRENT == "2") //Bloqueio Rentabilidade
			nTotRRet += MAR->VALOR
		Endif

		dbSelectArea("MAR")
		MAR->(dbSkip())
	EndDo
Endif

If !(cOpcao $ "234") //Diferente de Pendente de Liberacao
	cQuery1 := "SELECT SC9.C9_FILIAL AS FILIAL,SA1.A1_NOME AS NOME,SC9.C9_PEDIDO AS PEDIDO,SC9.C9_ITEM AS ITEM,SC9.C9_PRODUTO AS PRODUTO,SC9.C9_LOCAL AS ARMAZEM,"
	cQuery1 += "SC6.C6_QTDEMP AS QTDEMP,SB2.B2_QATU AS QTDEST,(SB2.B2_QATU-SB2.B2_RESERVA) AS SALDO,SB1.B1_DESC AS DESCRI,(SC9.C9_QTDLIB*SC9.C9_PRCVEN) AS VALOR," 
	cQuery1 += "SC5.C5_TIPOFAT AS TIPOFAT,SC9.C9_QTDLIB AS QUANT,SC5.C5_BLQ AS BLQRENT,(CASE WHEN (SC9.C9_BLCRED IS NULL) THEN '01' ELSE SC9.C9_BLCRED END) AS BLQCREDITO,(CASE WHEN (SC9.C9_BLEST IS NULL) THEN '02' ELSE SC9.C9_BLEST END) AS BLQESTOQUE,SC5.C5_LIBEROK AS BLQPEDLIB, "
	cQuery1 += "(CASE WHEN SC9.C9_QTDLIB>(SB2.B2_QATU-SB2.B2_RESERVA) AND SC9.C9_BLEST <> '' THEN 'N' ELSE 'S' END) AS BLQESTDISP, "
	cQuery1 += "(CASE WHEN (SC9.C9_LOTECTL IS NULL) THEN ' ' ELSE SC9.C9_LOTECTL END) AS LOTE "
	cQuery1 += "FROM "+RetSqlName("SC9")+" SC9 (NOLOCK) "
	cQuery1 += "INNER JOIN "+RetSqlName("SC5")+" SC5  (NOLOCK) ON (SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND SC5.C5_NUM = SC9.C9_PEDIDO AND SC5.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SC6")+" SC6  (NOLOCK) ON (SC6.C6_FILIAL = SC9.C9_FILIAL AND SC6.C6_NUM = SC9.C9_PEDIDO AND SC6.C6_ITEM = SC9.C9_ITEM AND SC6.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SA1")+" SA1  (NOLOCK) ON (SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SB1")+" SB1  (NOLOCK) ON (SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC9.C9_PRODUTO AND SB1.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SF4")+" SF4  (NOLOCK) ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SC6.C6_TES = SF4.F4_CODIGO AND SF4.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SB2")+" SB2  (NOLOCK) ON (SB2.B2_FILIAL = SC9.C9_FILIAL AND SB2.B2_COD = SC9.C9_PRODUTO AND SB2.B2_LOCAL = SC9.C9_LOCAL AND SB2.D_E_L_E_T_='') "
	
	If !(alltrim(__cUserID) $ (cUsrTop))
		cQuery1 += "INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON (SA3.A3_COD = SA1.A1_VEND AND SA3.D_E_L_E_T_<> '*' AND (SA3.A3_CODUSR = '"+__cUserID+"' OR SA3.A3_USRAUX = '"+__cUserID+"' OR SA3.A3_GEREN = '"+__cUserID+"'OR SA3.A3_SUPER = '"+__cUserID+"'))"
	Endif	

	cQuery1 += "WHERE SC9.D_E_L_E_T_='' AND SC9.C9_BLCRED <> '10' AND SC9.C9_BLEST <> '10' "
	If (cFilFat == "02")
		cQuery1 += "AND SC9.C9_FILIAL = '0102' "
	Elseif (cFilFat == "03")
		cQuery1 += "AND SC9.C9_FILIAL = '0103' "
	Elseif (cFilFat == "04")
		cQuery1 += "AND SC9.C9_FILIAL = '0104' "
	Endif
	If !Empty(cProduto)
		cQuery1 += "AND SC9.C9_PRODUTO = '"+cProduto+"' "
	EndIf
	If !Empty(cPedido)
		cQuery1 += "AND SC9.C9_PEDIDO = '"+cPedido+"' "
	EndIf
	If !Empty(cCliente)
		cQuery1 += "AND SC9.C9_CLIENTE = '"+cCliente+"' "
	EndIf
	If !Empty(cLoja)
		cQuery1 += "AND SC9.C9_LOJA = '"+cLoja+"' "
	EndIf
	If !Empty(cFamilia)
		cQuery1 += "AND SB1.B1_GRUPO = '"+cFamilia+"' "
	EndIf
	If !Empty(cBrCfFat)
		cQuery1 += "AND SC6.C6_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery1 += "AND SC6.C6_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery1 += "AND SC6.C6_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery1 += "AND SC6.C6_TES NOT IN ("+cBrTsNFat+") "
	Endif
	If !Empty(cLote)
		cQuery1 += "AND SC9.C9_LOTECTL = '"+cLote+"' "
	EndIf
	cQuery1 += "AND SC6.C6_QTDVEN > SC6.C6_QTDENT "
	if cFilDupli == "S"
		cQuery1 += "AND SF4.F4_DUPLIC='S' "
	endif
	/*
	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery1 += "AND SC5.C5_VEND1 IN ("+cCodRep+") "
		Else
			cQuery1 += "AND SC5.C5_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	*/
	cQuery1 += "AND SC6.C6_ENTREG BETWEEN '"+dtos(dEntDe)+"' AND '"+dtos(dEntAte)+"' "
	
	If (cOpcao == "2") //Pendente Analise Rentabilidade
		cQuery1 += "AND SC5.C5_BLQ = '1' "
	Endif
	
	If (cOpcao == "3") //Rejeitado Rentabilidade
		cQuery1 += "AND SC5.C5_BLQ = '2' "
	Endif
	
	if (cOpcao == "5") //Rejeicao Credito
		cQuery1 += "AND SC9.C9_BLCRED = '09' "
	Elseif (cOpcao == "6") //Itens Sem Estoque Disponivel
		cQuery1 += "AND ((SC9.C9_BLEST <> '' AND SC9.C9_QTDLIB>(SB2.B2_QATU-SB2.B2_RESERVA)) OR SC9.C9_BLEST = '02') "
	Elseif (cOpcao == "7") //Pedidos Bloqueados Estoque
		cQuery1 += "AND SC9.C9_BLCRED = '' AND SC9.C9_BLEST = '02' "
	Elseif (cOpcao == "8") //Pendencia Analise de Credito
		cQuery1 += "AND SC9.C9_BLCRED = '01' "
	Elseif (cOpcao == "9") //Apto a Faturar
		cQuery1 += "AND SC9.C9_BLCRED = '' AND SC9.C9_BLEST = '' "
	Endif
	If (nValMin > 0)
		cQuery1 += "AND (SELECT SUM(A.C9_QTDLIB*A.C9_PRCVEN) FROM "+RetSqlName("SC9")+" A WHERE A.C9_FILIAL = SC9.C9_FILIAL AND A.C9_PEDIDO = SC6.C6_NUM AND A.D_E_L_E_T_='') >= "+cValToChar(nValMin)+" "
	Endif
	Do Case
		Case cOrdem == "1"; cQuery1 += "ORDER BY 5, 3, 2"
		Case cOrdem == "2"; cQuery1 += "ORDER BY 3, 2"
		Case cOrdem == "3"; cQuery1 += "ORDER BY 5, 3, 2"
	EndCase  
	cQuery1 := ChangeQuery(cQuery1)
	//memowrite('\data\IFATC020-2-FAT.txt',cQuery1)
	//memowrite('\data\teste_query_totped2.txt',cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	
	dbSelectArea("MAR")
	ProcRegua(1)
	dbGoTop()
	While !MAR->(Eof())
		
		IncProc("Buscando informa?es de faturamento...")
		
		AADD(aFatura,{MAR->FILIAL,MAR->PEDIDO,MAR->ITEM,MAR->PRODUTO,MAR->DESCRI,MAR->QTDEST,MAR->SALDO,MAR->QUANT,;
			MAR->VALOR,MAR->BLQRENT,MAR->BLQPEDLIB,MAR->BLQESTOQUE,MAR->BLQCREDITO,MAR->LOTE,iif(MAR->TIPOFAT=="1","Item","Pedido"),MAR->NOME})
	
		nLin := Len(aFatura)
		lItemSes := .F.
		If (cOpcao == "6").and.(aFatura[nLin,13] != "S") //Itens Sem Estoque Disponivel
			aDel(aFatura,nLin)
			aSize(aFatura,Len(aFatura)-1)
			lItemSes := .T.
		Endif

	   If (!lItemSes)
			nTotPed += MAR->VALOR
		Endif
		
		If (!lItemSes).and.(MAR->BLQRENT == "1") //PENDENTE Rentabilidade
			nTotPRet += MAR->VALOR
		Endif
		
		If (!lItemSes).and.(MAR->BLQRENT == "2") //REJEITADO Rentabilidade
			nTotRRet += MAR->VALOR
		Endif
		
		If (!lItemSes).and.(MAR->BLQCREDITO == "09") //Rejeitado Credito
			nTotRej += MAR->VALOR
		Endif
		
		If MAR->TIPOFAT == '1' .and. (MAR->BLQESTOQUE == "02") //Pedidos Bloqueados Estoque
			nTotEst += MAR->VALOR
		Else 
//		Else 
			
		Endif
		If (!lItemSes).and.(MAR->BLQCREDITO == "01") //Pendente Analise de Credito
			nTotCre += MAR->VALOR
		Endif
		If (!lItemSes).and.(MAR->BLQESTDISP == "N") //Item Estoque Disponivel
			nTotSes += MAR->VALOR
		Endif
		If (!lItemSes).and.Empty(MAR->BLQCREDITO).and.Empty(MAR->BLQESTOQUE) //Apto a Faturar
			nTotFat += MAR->VALOR
		Endif                   
		
		dbSelectArea("MAR")
		MAR->(dbSkip())
	EndDo
Endif
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

//Atualizo Browse
/////////////////
If (Len(aFatura) <= 0)
	AADD(aFatura,{Space(2),Space(6),Space(2),Space(15),"",0,0,0,0,Space(1),Space(1),Space(1),Space(1),Space(1),Space(1),""})
Endif
oBrwFat:SetArray(aFatura)
oBrwFat:GoTop()
oBrwFat:Refresh()
   
//Monto Query para buscar dados de Faturamento/Devolucao
////////////////////////////////////////////////////////
For nx := 1 to 2 //1=Calcula para o Mes / 2=Calcula para o Dia
	cQuery1 := "SELECT SUM(SD2.D2_VALBRUT) AS FATURA, "
	cQuery1 += "SUM(CASE WHEN E4_FORMA = 'BOL' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATBOL, "
	cQuery1 += "SUM(CASE WHEN E4_CODIGO = '003' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATAVI, "
	cQuery1 += "SUM(CASE WHEN E4_FORMA = 'DPN' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATNEG, "
	cQuery1 += "SUM(CASE WHEN E4_FORMA = 'CC' THEN SD2.D2_VALBRUT ELSE 0 END ) AS FATCC "
	cQuery1 += "FROM "+RetSqlName("SD2")+" SD2 "
	
	cQuery1 += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON ( SF2.F2_DOC = SD2.D2_DOC "
	cQuery1 += "AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_='') "
	cQuery1 += "INNER JOIN "+RetSqlName("SE4")+" E4 ON E4_CODIGO = F2_COND "

	If !(alltrim(__cUserID) $ (cUsrTop))
		cQuery1 += "INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON (SA3.A3_COD = SF2.F2_VEND1 AND SA3.D_E_L_E_T_<> '*' AND (SA3.A3_CODUSR = '"+__cUserID+"' OR SA3.A3_USRAUX = '"+__cUserID+"' OR SA3.A3_GEREN = '"+__cUserID+"'OR SA3.A3_SUPER = '"+__cUserID+"'))"
	Endif	
	
	cQuery1 += "WHERE SD2.D_E_L_E_T_='' AND E4.D_E_L_E_T_=' ' AND SD2.D2_TIPO NOT IN ('B','D') "
	If (nx == 1)
		cQuery1 += "AND SUBSTRING(SD2.D2_EMISSAO,1,6) = '"+Substr(dtos(dDatabase),1,6)+"' "
	Elseif (nx == 2)
		cQuery1 += "AND SD2.D2_EMISSAO = '"+dtos(dDatabase)+"' "
	Endif
	if cFilDupli == "S"
		cQuery1 += "AND SF4.F4_DUPLIC='S' "
	endif
	If !Empty(cBrCfFat)
		cQuery1 += "AND SD2.D2_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery1 += "AND SD2.D2_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery1 += "AND SD2.D2_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery1 += "AND SD2.D2_TES NOT IN ("+cBrTsNFat+") "
	Endif
	If (cFilFat == "02")
		cQuery1 += "AND SD2.D2_FILIAL = '0102' "
	Elseif (cFilFat == "03")
		cQuery1 += "AND SD2.D2_FILIAL = '0103' "
	Elseif (cFilFat == "04")
		cQuery1 += "AND SD2.D2_FILIAL = '0104' "
	Endif
	/*
	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery1 += "AND SF2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery1 += "AND SF2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	
	*/
	cQuery1 := ChangeQuery(cQuery1)
	memowrite('\data\IFATC020-3-FAT.txt',cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	If !MAR->(Eof())              
		If (nx == 1)
			oSTotMes:SetText(MAR->FATURA)
			oSFatMBol:SetText(MAR->FATBOL)
			oSFatMAvi:SetText(MAR->FATAVI)
			oSFatMNeg:SetText(MAR->FATNEG)
			oSFatMCC:SetText(MAR->FATCC)
		Elseif (nx == 2)
			oSTotFat:SetText(MAR->FATURA)
			oSFatDBol:SetText(MAR->FATBOL)
			oSFatDAvi:SetText(MAR->FATAVI)
			oSFatDNeg:SetText(MAR->FATNEG)
			oSFatDCC:SetText(MAR->FATCC)
		Endif
	Endif	  
Next nx
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
	
For nx := 1 to 2 //1=Calcula para o Mes / 2=Calcula para o Dia
	cQuery1 := "SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) AS DEVOLU FROM "+RetSqlName("SD1")+" SD1 "
	cQuery1 += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON (SF2.F2_FILIAL = '"+xFilial("SD2")+"' AND SF2.F2_DOC = SD1.D1_NFORI "
	cQuery1 += "AND SF2.F2_SERIE = SD1.D1_SERIORI AND SF2.F2_CLIENTE = SD1.D1_FORNECE AND SF2.F2_LOJA = SD1.D1_LOJA AND SF2.D_E_L_E_T_='') "
	
	If !(alltrim(__cUserID) $ (cUsrTop))
		cQuery1 += "INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON (SA3.A3_COD = SF2.F2_VEND1 AND SA3.D_E_L_E_T_<> '*' AND (SA3.A3_CODUSR = '"+__cUserID+"' OR SA3.A3_USRAUX = '"+__cUserID+"' OR SA3.A3_GEREN = '"+__cUserID+"'OR SA3.A3_SUPER = '"+__cUserID+"'))"
	Endif	
	
	cQuery1 += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON ( SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_='') "
	cQuery1 += "WHERE SD1.D_E_L_E_T_='' "
	If (nx == 1)
		cQuery1 += "AND SUBSTRING(SD1.D1_DTDIGIT,1,6) = '"+Substr(dtos(dDatabase),1,6)+"' "
	Elseif (nx == 2)
		cQuery1 += "AND SD1.D1_DTDIGIT = '"+dtos(dDatabase)+"' "
	Endif
	if cFilDupli == "S"
		cQuery1 += "AND SF4.F4_DUPLIC='S' "
	endif
	cQuery1 += "AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411') " //CFOPs de Devolucao
	If (cFilFat == "02")
		cQuery1 += "AND SD1.D1_FILIAL = '0102' "
	Elseif (cFilFat == "03")
		cQuery1 += "AND SD1.D1_FILIAL = '0103' "
	Elseif (cFilFat == "04")
		cQuery1 += "AND SD1.D1_FILIAL = '0104' "
	Endif
/*	If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
		cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
		If !Empty(cCodRep)
			cQuery1 += "AND SF2.F2_VEND1 IN ("+cCodRep+") "
		Else
			cQuery1 += "AND SF2.F2_VEND1 = 'ZZZZZZ' "
		Endif
	Endif	*/
	cQuery1 := ChangeQuery(cQuery1)
	memowrite('\data\IFATC020-4-DEVOL.txt',cQuery1)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MAR"
	If !MAR->(Eof())              
		If (nx == 1)
			oDTotMes:SetText(MAR->DEVOLU)
		Elseif (nx == 2)
			oDTotFat:SetText(MAR->DEVOLU)
		Endif
	Endif	  
Next nx
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

oSTotPed:SetText(nTotPed)
oSToPRet:SetText(nTotPRet)
oSToRRet:SetText(nTotRRet)
oSTotPen:SetText(nTotPen)
oSTotRej:SetText(nTotRej)
oSTotSes:SetText(nTotSes)
//oSTotEst:SetText(nTotEst)
oSTotCre:SetText(nTotCre)
oSTotApt:SetText(nTotFat)
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
Local i

If !(__cUserID $ (cUsrTop))
	cCond1 := '%'
	cCond1 += "AND (SA3.A3_USRAUX='"+__cUserID+"' OR SA3.A3_CODUSR='"+__cUserID+"' OR SA3.A3_SUPER='"+__cUserID+"' OR SA3.A3_GEREN='"+__cUserID+"' )"
	cCond1 += '%'
else
	cCond1 := '%AND 1=1%'
endif

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
			
			%exp:cCond1%
			
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
			
			%exp:cCond1%
			
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
			
			%exp:cCond1%
			
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
			
			%exp:cCond1%
			
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
			
			INNER JOIN %table:SA1% SA1 ON SA1.A1_FILIAL = %xfilial:SA1%
			AND SA1.A1_COD = SC5.C5_CLIENT
			AND SA1.A1_LOJA = SC5.C5_LOJACLI
			AND SA1.%notDel%
			
			LEFT JOIN %table:SA3% SA3 ON SA3.A3_FILIAL = %xfilial:SA3%
			AND SA3.A3_COD = SC5.C5_VEND1
			AND SA3.%notDel%
			
			%exp:cCond1%
				
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
	
	IncProc("Buscando informa?es do estoque...")
	
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
//oBrwPed:ShowData(1,9)
oBrwPed:oGrid:SetColumnSize(1, 500)
oBrwPed:DoUpdate()

oGrpTotMes:cCaption := "Pedidos que entraram no m? " + STRZERO(MONTH(dDataEnt),2) +"/" + ALLTRIM(STR(YEAR(dDataEnt)))
oGrpTotDia:cCaption := "Pedidos que entraram no dia " + DTOC(dDataEnt)

Return

//================================================= ATUALIZA INFORMACOES ESTOQUE =================================================//
Static Function fAtuEst()
***********************
Local nCount := 0
Local cAlias := GetNextAlias()

Local cPesq  := "%LIKE ('%" + ALLTRIM(cPesEst) + "%') %"
//Local cTipop := "%LIKE ('%" + ALLTRIM(cTipEst) + "%') %"
//Local cTipop  := ALLTRIM(cTipEst)
Local i

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
   			AND SB1.B1_TIPO %exp:cPesq%
			//AND SB1.B1_DESC %exp:cPesq%
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
  			AND SB1.B1_TIPO %exp:cPesq%
			AND SB1.%notDel%
			
			INNER JOIN %table:SX5% SX5 ON SX5.X5_FILIAL = %xfilial:SX5%
			AND SX5.X5_TABELA = '02'
			AND SX5.X5_CHAVE %exp:cPesq%
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
   			AND SB1.B1_TIPO %exp:cPesq%
			AND SB1.%notDel%
			
			INNER JOIN %table:SBM% SBM ON SBM.BM_FILIAL = %xfilial:SBM%
			AND SBM.BM_GRUPO = SB1.B1_GRUPO
			//AND SBM.BM_DESC %exp:cPesq%
			AND SBM.%notDel%
			
			WHERE SB2.B2_FILIAL = %xfilial:SB2%
			AND SB2.B2_LOCAL BETWEEN %exp:cLocalDe% AND %exp:cLocalAte%
			AND SB2.%notDel%
			
			GROUP BY SB1.B1_GRUPO, SBM.BM_DESC
			ORDER BY SBM.BM_DESC
		EndSql
		
EndCase
memowrite('\data\IFATC020-5.txt',  GetLastQuery()[2])			

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
	
	IncProc("Buscando informa?es do estoque...")
	
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
					AADD(aClone,TRANSFORM((cAlias)->(FieldGet(i)),"@E 999,999,999.9999"))
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
Do Case
	Case cOpcEst == "1"
		oBrwEst:oGrid:SetColumnSize(1, 500)
		oBrwEst:oGrid:SetColumnSize(3, 250)
		oBrwEst:oGrid:SetColumnSize(5, 150)
		oBrwEst:oGrid:SetColumnSize(6, 150)
		oBrwEst:oGrid:SetColumnSize(7, 150)
		oBrwEst:oGrid:SetColumnSize(8, 150)
		oBrwEst:oGrid:SetColumnSize(9, 150)
	Case cOpcEst == "2" .or. cOpcEst == "3"
		oBrwEst:oGrid:SetColumnSize(1, 500)
		oBrwEst:oGrid:SetColumnSize(2, 150)
		oBrwEst:oGrid:SetColumnSize(3, 150)
		oBrwEst:oGrid:SetColumnSize(4, 150)
		oBrwEst:oGrid:SetColumnSize(5, 150)
		oBrwEst:oGrid:SetColumnSize(6, 150)
EndCase
//oBrwEst:ShowData(1,15)
oBrwEst:DoUpdate()

Return

//================================================= ATUALIZA INFORMA?ES DA ABA FINANCEIRO =================================================//
Static Function fAtuFin()
***********************
Local cAlias    := GetNextAlias()
//Local cAliasTot := GetNextAlias()
//Local cOntem    := "%"+DTOS(DDATABASE-1)+"%"
//Local cMes      := "%"+SUBSTR(DTOS(DDATABASE),1,6)+"%"
//Local cEstST :=  ''//"%" + FormatIn(GetMv("BR_STPOS"),"/") + "%"
//Local cPesq  := "%LIKE ('%" + ALLTRIM(cNomFin) + "%') %"
Local nCount := 0
Local aDados := {}
Local aClone := {}
Local aTotal := {0,0,0,0,0,0}
Local cFiltroSE2 := ""
Local cFiltroSE1 := ""
Local cFiltroSE5 := ""
Local cFiltroSF2 := ""
Local i

If  AllTrim(__cUserID) $ (GetMv("TG_ABAFIN")) //Charles Battisti Medeiros
//If  AllTrim(cUsername) $ (GetMv("TG_ABAFIN")) //Charles Battisti Medeiros
//If !(alltrim(__cUserID) $ (cUsrTop))
	
	Do Case
		Case cFilFin == "01"
			cFiltroSE2 += "AND SE2.E2_FILORIG = '0102' "
			cFiltroSE1 += "AND SE1.E1_FILORIG = '0102' "
			cFiltroSE5 += "AND SE5.E5_FILORIG = '0102' "
			cFiltroSF2 += "AND SF2.F2_FILIAL = '0102' "
		Case cFilFin == "02"
			cFiltroSE2 += "AND SE2.E2_FILORIG = '0103' "
			cFiltroSE1 += "AND SE1.E1_FILORIG = '0103' "
			cFiltroSE5 += "AND SE5.E5_FILORIG = '0103' "
			cFiltroSF2 += "AND SF2.F2_FILIAL = '0103' "
		Case cFilFin == "00"
			cFiltroSE2 += "AND SE2.E2_FILORIG <> ('') "
			cFiltroSE1 += "AND SE1.E1_FILORIG <> ('') "
			cFiltroSE5 += "AND SE5.E5_FILORIG <> ('') "
			cFiltroSF2 += "AND SF2.F2_FILIAL <> ('') "
	EndCase
	
	If !Empty(cCliFor) .And. !Empty(cFinLoj)
		cFiltroSE2 += "AND SE2.E2_FORNECE = '" + cCliFor + "' AND SE2.E2_LOJA = '" + cFinLoj + "' "
		cFiltroSE1 += "AND SE1.E1_CLIENTE = '" + cCliFor + "' AND SE1.E1_LOJA = '" + cFinLoj + "' "
	EndIf
	
	If !Empty(cTitFin)
		cFiltroSE2 += "	AND SE2.E2_NUM = '" + cTitFin + "' "
		cFiltroSE1 += "	AND SE1.E1_NUM = '" + cTitFin + "' "
	EndIf 
	
	If !Empty(cTipTit)
		cFiltroSE2 += "	AND SE2.E2_TIPO = '" + cTipTit + "' "
		cFiltroSE1 += "	AND SE1.E1_TIPO = '" + cTipTit + "' "
	Endif

	If !Empty(cNumFat)
		cFiltroSE2 += "	AND SE2.E2_FATURA = '" + cNumFat + "' "
		cFiltroSE1 += "	AND SE1.E1_FATURA = '" + cNumFat + "' "
	Endif

	If (Left(cFilTip,1) == "2") //Em Aberto
		cFiltroSE2 += "	AND SE2.E2_SALDO > 0 "
		cFiltroSE1 += "	AND SE1.E1_SALDO > 0 "
	Elseif (Left(cFilTip,1) == "3") //Liquidados
		cFiltroSE2 += "	AND SE2.E2_SALDO = 0 "
		cFiltroSE1 += "	AND SE1.E1_SALDO = 0 "
	Endif	
	
	cFiltroSE2 := "%" + cFiltroSE2 + "%"
	cFiltroSE1 := "%" + cFiltroSE1 + "%"
	cFiltroSE5 := "%" + cFiltroSE5 + "%"
	cFiltroSF2 := "%" + cFiltroSF2 + "%"
	
	Do Case
		Case Left(cOpcCart,1) == "1"
			
			BeginSql alias cAlias
				
				COLUMN E2_VENCREA AS DATE
				
				SELECT 	(CASE WHEN SE2.E2_SALDO = 0 THEN 'RPO_IMAGE=DISABLE' ELSE (CASE WHEN SE2.E2_BAIXA <> ' ' AND SE2.E2_SALDO > 0 THEN 'RPO_IMAGE=BR_AZUL' ELSE 'RPO_IMAGE=ENABLE' END) END) AS STATUS,
				SE2.E2_FILIAL, SE2.E2_PREFIXO, SE2.E2_NUM, SE2.E2_PARCELA, SE2.E2_TIPO,
				SE2.E2_VENCREA, SE2.E2_VALOR, SE2.E2_SALDO, SE2.E2_NOMFOR, SE2.E2_FORNECE, SE2.E2_LOJA
				FROM %table:SE2% SE2
				WHERE SE2.E2_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
				AND SE2.E2_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
				//AND SE2.E2_NOMFOR %exp:cPesq%
				AND SE2.%notDel%
				%exp:cFiltroSE2%
			EndSql
			
		Case Left(cOpcCart,1) == "2"
			
			BeginSql alias cAlias
				
				COLUMN E1_VENCREA AS DATE
				
				SELECT	(CASE WHEN SE1.E1_SALDO = 0 THEN 'RPO_IMAGE=DISABLE' ELSE (CASE WHEN SE1.E1_BAIXA <> ' ' AND SE1.E1_SALDO > 0 THEN 'RPO_IMAGE=BR_AZUL' ELSE 'RPO_IMAGE=ENABLE' END) END) AS STATUS,
				SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO,
				SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_NOMCLI
				FROM %table:SE1% SE1
				WHERE SE1.E1_EMISSAO BETWEEN %exp:dFinEmiDe% AND %exp:dFinEmiAte%
				AND SE1.E1_VENCREA BETWEEN %exp:dFinVctDe% AND %exp:dFinVctAte%
				//AND SE1.E1_NOMCLI %exp:cPesq%
				AND SE1.%notDel%
				%exp:cFiltroSE1%
			EndSql
	EndCase
	memowrite('\data\IFATC020-6.txt',  GetLastQuery()[2])		

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
		
		IncProc("Buscando informa?es do financeiro...")
		
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
		If (Left(cOpcCart,1) == "1")
			aTotal[1] += (cAlias)->E2_valor
			aTotal[2] += (cAlias)->E2_saldo
			aTotal[3] += (cAlias)->E2_valor-(cAlias)->E2_saldo
		Elseif (Left(cOpcCart,1) == "2")
			aTotal[4] += (cAlias)->E1_valor
			aTotal[5] += (cAlias)->E1_saldo
			aTotal[6] += (cAlias)->E1_valor-(cAlias)->E1_saldo
		Endif
		
		dbSelectArea(cAlias)
		(cAlias)->(dbSkip())
	EndDo
	
	oBrwTitFin:SetArray(aDados)
	//oBrwTitFin:ShowData(1,oBrwTitFin:nVisibleRows)
	oBrwTitFin:oGrid:SetColumnSize(7, 150)
	oBrwTitFin:oGrid:SetColumnSize(8, 150)
	oBrwTitFin:oGrid:SetColumnSize(9, 500)
	oBrwTitFin:DoUpdate()
	oSayCliFor:CtrlRefresh()
	oSTotSP:SetText(aTotal[1])
	oSFilSP:SetText(aTotal[2])
	oSFilLP:SetText(aTotal[3])
	oSTotSR:SetText(aTotal[4])
	oSFilSR:SetText(aTotal[5])
	oSFilLR:SetText(aTotal[6])
	/*
	BeginSql alias cAliasTot
		SELECT TOT_STP, TOT_STI
		FROM
		(
		(SELECT SUM(SF2.F2_ICMSRET) AS TOT_STP
		FROM %table:SF2% SF2
		WHERE  SF2.F2_EST NOT IN (%exp:cEstST%)
		AND SF2.F2_TIPO <> 'I'
		AND SF2.%notDel%
		%exp:cFiltroSF2%
		) AS TOT_STP,
		
		(SELECT SUM(SF2.F2_ICMSRET) AS TOT_STI
		FROM %table:SF2% SF2
		WHERE SF2.F2_TIPO = 'I'
		AND SF2.F2_EST NOT IN (%exp:cEstST%)
		AND SF2.%notDel%
		%exp:cFiltroSF2%
		) AS TOT_STI
		)
	EndSql
	*/
	//dbSelectArea(cAliasTot)
	//dbGoTop()
	
	//oSTotSTP:SetText((cAliasTot)->TOT_STP)
	//oSTotSTI:SetText((cAliasTot)->TOT_STI)

Else //Charles Battisti Medeiros
	Aviso("ATENCAO",; //Charles Battisti Medeiros
	" ROTINA COM ACESSO RESTRITO !!!!",; 
	{"&Ok"},,"Para acesso constatar - TI. ")  
	Return 
EndIf //Charles Battisti Medeiros

Return

//================================================= IMPRESS? DO RELAT?IO PEDIDOS X ESTOQUE =================================================//
Static Function fPedEst()
***********************
Local oReport := ReportDef()
oReport:PrintDialog()
Return
                 
Static Function fSaldoSB2(xProduto)
*******************************
LOCAL aRetu := {0,0,0}
SB2->(dbSetOrder(1))
SB2->(dbSeek(xFilial("SB2")+xProduto,.T.))
While !SB2->(Eof()).and.(xFilial("SB2") == SB2->B2_filial).and.(SB2->B2_cod == xProduto)
	If (SB2->B2_local $ "01")
		aRetu[1] += SB2->B2_salpedi
		aRetu[2] += SB2->B2_qatu
		aRetu[3] += SB2->B2_qatu*SB2->B2_cm1
	Endif	             
	SB2->(dbSkip())
Enddo
Return aRetu 

Static Function ReportDef()
*************************
Local oReport
Local oSection1

oReport := TReport():New("IFATC020","Pedidos x Estoque",NIL,{|oReport| PrintReport(oReport)},"Impress? do relat?io de Pedidos x Estoque")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Mapa",{"SB1"})
TRCell():New(oSection1,"PRODUTO","","Produto"       ,,,,{|| aRelato1[nLinha1,1] }) //Produto
TRCell():New(oSection1,"DESCRIC","","Descri?o"     ,,,,{|| aRelato1[nLinha1,2] })  //Descricao
TRCell():New(oSection1,"QTDEPED","","Qtd.Pedido"    ,"@E 9,999,999.99",,,{|| aRelato1[nLinha1,3] }) //Qtde Pedido
TRCell():New(oSection1,"VALRPED","","Val.Pedido"    ,"@E 9,999,999.99",,,{|| aRelato1[nLinha1,4] }) //Valor Pedido
TRCell():New(oSection1,"SALDEST","","Saldo Estoque" ,"@E 9,999,999.99",,,{|| aRelato1[nLinha1,5] }) //Saldo Estoque
TRCell():New(oSection1,"SALPEDI","","Qtd.Prevista"  ,"@E 9,999,999.99",,,{|| aRelato1[nLinha1,6] }) //Saldo Pedido
TRCell():New(oSection1,"VALREST","","Val.Estoque"   ,"@E 9,999,999.99",,,{|| aRelato1[nLinha1,7] }) //Valor Estoque

oSection1:Cell("PRODUTO"):SetSize(15)
oSection1:Cell("DESCRIC"):SetSize(70)
oSection1:Cell("QTDEPED"):SetSize(25)
oSection1:Cell("VALRPED"):SetSize(25)
oSection1:Cell("SALDEST"):SetSize(25)
oSection1:Cell("SALPEDI"):SetSize(25)
oSection1:Cell("VALREST"):SetSize(25)
oSection1:Cell("QTDEPED"):SetHeaderAlign("RIGHT")
oSection1:Cell("VALRPED"):SetHeaderAlign("RIGHT")
oSection1:Cell("SALDEST"):SetHeaderAlign("RIGHT")
oSection1:Cell("VALREST"):SetHeaderAlign("RIGHT")
oSection1:Cell("PRODUTO"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("DESCRIC"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("QTDEPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALRPED"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SALDEST"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("SALPEDI"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)
oSection1:Cell("VALREST"):SetBorder("BOTTOM",1,CLR_BLACK,.F.)

TRFunction():New(oSection1:Cell("QTDEPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALRPED"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("SALDEST"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)
TRFunction():New(oSection1:Cell("VALREST"),NIL,"SUM",NIL,NIL,NIL,NIL,.F.)

Return oReport

Static Function PrintReport(oReport)
********************************
LOCAL nx, nPos1, aSaldoB2
                             
//Monto variaveis para impressao
////////////////////////////////
aRelato1 := {} 
SB1->(dbSetOrder(1)) ; SB2->(dbSetOrder(1))
For nx := 1 to Len(aFatura)
	nPos1 := aScan(aRelato1,{|x| x[1] == aFatura[nx,4]})
	If (nPos1 == 0)
		aadd(aRelato1,{aFatura[nx,4],aFatura[nx,5],0,0,0,0,0})
		nPos1 := Len(aRelato1)
		aSaldoB2 := fSaldoSB2(aFatura[nx,4])
		aRelato1[nPos1,6] := aSaldoB2[1]
		aRelato1[nPos1,5] := aSaldoB2[2]
		aRelato1[nPos1,7] := aSaldoB2[3]
	Endif
	If (nPos1 > 0)
		aRelato1[nPos1,3] += aFatura[nx,8]
		aRelato1[nPos1,4] += aFatura[nx,9]
	Endif
Next nx 
aRelato1 := aSort(aRelato1,,,{|x, y| x[4]>y[4] })

//Impressao do Relatorio
////////////////////////
nLinha1 := 1
oReport:SetMeter(1)
oReport:Section(1):Init()
While !oReport:Cancel().and.(nLinha1 <= Len(aRelato1))
	oReport:IncMeter()
	oReport:Section(1):PrintLine()
	nLinha1++		
EndDo
oReport:Section(1):Finish()

Return

//================================================= IMPRESS? DO RELAT?IO ESTOQUE x PEDIDOS =================================================//
Static Function fEstPed()
**********************
Local oReport := fEstPed2()
oReport:PrintDialog()
Return

Static Function fEstPed2()
***********************
Local oReport
Local oSection1

oReport := TReport():New("BFATC002","Estoque x Pedidos",NIL,{|oReport| fEstPed3(oReport)},"Impress? do relat?io Estoque x Pedidos")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oSection1 := TRSection():New(oReport,"Mapa",{"SB2","SB1","SC6"})

TRCell():New(oSection1,"B2_COD","SB2","Produto")
TRCell():New(oSection1,"B1_DESC","SB1","Descri?o")
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
//Local cAlias := GetNextAlias()
Local oSection1 := oReport:Section(1)

oSection1:BeginQuery()


oSection1:EndQuery()

oSection1:Print()

Return

//================================================= IMPRESS? DO RANKING DE CLIENTES =================================================//
Static Function fRankCli()
***********************
Local cPerg   := 'BFATC00300'//PADR("BFATC003",10)
Local oReport := fRankCli2(cPerg)

//fRankCli4(cPerg)

If Pergunte('BFATC00300',.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function fRankCli2(cPerg)
****************************
Local oReport
Local oSection1

oReport := TReport():New("BFATC003","Ranking de Clientes",cPerg,{|oReport| fRankCli3(oReport)},"Impress? do relat?io Ranking de Clientes")
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

//================================================= IMPRESS? DO RANKING DE CLIENTES =================================================//
Static Function fRankPro()
***********************
Local cPerg   := 'BFATC00300'//PADR("BFATC003",10)
Local oReport := fRankPro2(cPerg)

//fRankCli4(cPerg)

If Pergunte('BFATC00300',.T.)
	oReport:PrintDialog()
EndIf

Return

Static Function fRankPro2(cPerg)
*****************************
Local oReport
Local oSection1

oReport := TReport():New("BFATC004","Ranking de Produtos",cPerg,{|oReport| fRankPro3(oReport)},"Impress? do relat?io Ranking de Produtos")
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

//======================================== EXIBE TELA DE CONSULTA DE T?ULO ========================================//
Static Function fConsTit()
***********************
Local cPesq := ""
If (lEN(oBrwTitFin:aData) > 0).and.(oBrwTitFin:nRecno > 0)                                           
	cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Filial")]
	cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Prefixo")]
	cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("No. Titulo")]
	cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Parcela")]
	cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Tipo")]
	If (Left(cOpcCart,1) == "1")
		cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Fornecedor")]
		cPesq += oBrwTitFin:aData[oBrwTitFin:nRecno,oBrwTitFin:ColPos("Loja")]
		dbSelectArea("SE2")
		dbSetOrder(1)
		If dbSeek(cPesq)
			Fc050Con()
		Else
			ApMsgStop("T?ulo n? encontrado!", "[IFATC020] - NAO ENCONTRADO")
		EndIf
	Elseif (Left(cOpcCart,1) == "2")
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbSeek(cPesq)
			Fc040Con()
		Else
			ApMsgStop("T?ulo n? encontrado!", "[IFATC020] - NAO ENCONTRADO")
		EndIf
	EndIf
Endif
Return

Static Function BuscaMeta()
************************
LOCAL nRetu := 0, cQuery := ""
/*                   
If (u_BXRepAdm()) //Parametro/Presidente/Diretor
	SZ4->(dbSetOrder(1))
	If SZ4->(dbSeek(xFilial("SZ4")+Left(dtos(dDatabase),6)))
		nRetu := SZ4->Z4_meta
	Endif
	If Empty(nRetu)
		nRetu := GetMv("BR_METAFAT")
	Endif
Else
	cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
*/
//If !Empty(cCodRep)
		cQuery := "SELECT SUM(CT_VALOR) M_META FROM "+RetSqlName("SCT")+" SCT "
		
		If !(alltrim(__cUserID) $ (cUsrTop))
			cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 (NOLOCK) ON (SA3.A3_COD = SCT.CT_VEND AND SA3.D_E_L_E_T_<> '*' AND (SA3.A3_CODUSR = '"+__cUserID+"' OR SA3.A3_USRAUX = '"+__cUserID+"' OR SA3.A3_GEREN = '"+__cUserID+"'OR SA3.A3_SUPER = '"+__cUserID+"'))"
		Endif
		
		cQuery += "WHERE SCT.D_E_L_E_T_ = '' AND SCT.CT_FILIAL = '"+xFilial("SCT")+"' "// AND SCT.CT_VEND IN ("+cCodRep+") "
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
	//Endif
//Endif	

Return nRetu

Static Function BTrocaCar()
************************
If (Left(cOpcCArt,1) == "1")
	oSayCliFor:SetText("Forneced:")
	oGetCliFor:cF3 := "SA2"
	oSayFinNom:cCaption := "Nome For:"
Elseif (Left(cOpcCArt,1) == "2")
	oSayCliFor:SetText("Cliente:")
	oGetCliFor:cF3 := "SA1"
	oSayFinNom:cCaption := "Nome Cli:"
Endif
oSayCliFor:Refresh()
oSayFinNom:Refresh()
Return .T.
