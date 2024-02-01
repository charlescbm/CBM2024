#include "protheus.ch"
#include "rwmake.ch"
#include "fwbrowse.ch"
#include "fwmvcdef.ch"
#include "topconn.ch"                                                                                               
#include "tbiconn.ch"
#include "tbicode.ch"
#include "rptdef.ch"

#define ORCAMENTO     "2"
#define DS_MODALFRAME 128

Static cFiliais   := ""
Static __Vendedor := ""
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} IVENA010
Rotina de agendas Inoven 

@author		.iNi Sistemas (Rodolfo)
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function IVENA010()
	
	Local oTelSelct, oPtela, oLayer, oBrwCab1
	Local oWin01, oWin02, oWin03, oWin04, oWin05, oWin06, oWin07
	//Local cTitulo   := "Controle de agendas"
	//Local lEntrar   := .F.
	//Local nX        := 0
	//Local cQuery    := ""
	//Local cQry      := ""
	Local cArqAge   := ""
	Local cIndAge1  := ""
	Local cIndAge2	:= ""
	Local cIndAge3	:= ""
	Local cIndAge4	:= ""
	Local cIndAge5	:= ""	
	Local cIndAge6	:= ""	
	Local cIndAge7  := ""
	Local cIndAge8	:= ""
	Local cIndAge9	:= ""
	Local cIndAge10	:= ""
	Local cIndAge11	:= ""
	Local cIndAge12	:= ""
	Local cIndAge13	:= ""
	Local aArqAge   := {}
	Local cAtend    := ""
	Local aCoors    := ""
	Local aRet      := {}
	Local aTotais   := {}
	Local aSeek     := {}
	Local cGrCart   := ""
	Local cCarteiras:= ""
	Local bOK     	:= Nil
	Local bCancel 	:= Nil
	Local oFont     := TFont():New('Verdana',,-13,.T.,.T.)
	Local oFont1    := TFont():New('Verdana',,-11,.T.,.T.)
	Local aButtons  := {}
	Static cAgBaixa := SuperGetMv("BZ_AGBAIXA",, '000004')

	Static oTot1, oTot2, oTot3, oTot4, oTot5, oTot6, oTot7, oTot8, oTot9, oTotA, oTotB

	Private cPerg   := 'BZLCA070'
	Private aArqTemp:= {}
	Private cOrdBrw := ""
	//Private DTAGEN  := Ctod(('//'))

	Private cCadastro := "Controle de agendas"

	Private dDtInicial := FirstDate(dDataBase) //-1
	Private dDtFinal   := LastDate(dDataBase) //-1

	Private cTRB1 	:= GetNextAlias()
	Private cTRB4 	:= ''
	Private cUsrTop	   := SuperGetMV("TG_USERTOP",.F.,"")
	//Private cTRBUSR := GetNextAlias()

	Private nTimerWin := 60	//padrao de tempo para atualizacao da tela
	Private oTimer

	aAdd(aRet, {.F.,})

	DbSelectArea("SU7")
	SU7->(dbSetOrder(4))  // U7_FILIAL + U7_CODUSU
	If !SU7->(DbSeek(xFilial('SU7')+ __cUserId, .F.))
		ApMsgInfo("Acesso não permitido","Operador não cadastrado")
		Return aRet
	EndIf

	//--Guarda em variavel estaticas as filiais que farÃ£o parte do processamento.
	If Empty(cFiliais)
		aAreaSM0 := SM0->(GetArea())
		cFiliais := "''"
		SM0->(dbSetOrder(1))  // M0_CODIGO, M0_CODFIL.
		SM0->(msSeek(cEmpAnt, .F.))
		Do While SM0->(!eof() .And. M0_CODIGO == cEmpAnt)
			cFiliais += ", '" + SM0->M0_CODFIL + "'"
			SM0->(dbSkip())
		EndDo
		RestArea(aAreaSM0)
	EndIf

	AAdd( aArqAge, {'FILIAL',    "C", 004, 0} )
	AAdd( aArqAge, {'CLIENTE',   "C", 008, 0} )
	AAdd( aArqAge, {'LOJA',      "C", 004, 0} )
	AAdd( aArqAge, {'COLIGADA',  "C", 006, 0} )
	AAdd( aArqAge, {'NOME_COLIG',"C", 020, 0} )
	AAdd( aArqAge, {'NOME',      "C", 040, 0} )
	AAdd( aArqAge, {'CGC_CPF',   "C", 014, 0} )
	AAdd( aArqAge, {'FONE_CLI',  "C", 020, 0} )	
	AAdd( aArqAge, {'DTAGEN',    "D", 008, 0} )
	AAdd( aArqAge, {'NUMORC',    "N", 012, 0} )
	AAdd( aArqAge, {'PEDIDO',  	 "N", 012, 0} )
	AAdd( aArqAge, {'AGENDAS',   "N", 012, 0} )
	AAdd( aArqAge, {'VENDEDOR',  "C", 040, 0} )
	
	//-- Cria Indice de Trabalho
	cArqAge  := CriaTrab(aArqAge)
	cIndAge1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
	cIndAge2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
	cIndAge3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
	cIndAge4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
	cIndAge5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
	cIndAge6 := Substr(CriaTrab(NIL,.F.),1,7)+"6"
	cIndAge7 := Substr(CriaTrab(NIL,.F.),1,7)+"7"
	cIndAge8 := Substr(CriaTrab(NIL,.F.),1,7)+"8"
	cIndAge9 := Substr(CriaTrab(NIL,.F.),1,7)+"9"
	cIndAge10:= Substr(CriaTrab(NIL,.F.),1,7)+"10"
	cIndAge11:= Substr(CriaTrab(NIL,.F.),1,7)+"11"
	cIndAge12:= Substr(CriaTrab(NIL,.F.),1,7)+"12"
	cIndAge13:= Substr(CriaTrab(NIL,.F.),1,7)+"13"

	//-- Criando Indice Temporario por codigo do cliente
	dbUseArea(.T.,__LOCALDRIVER,cArqAge,cTRB1,.T.,.F.)
	IndRegua(cTRB1, cIndAge1, "FILIAL",,, "Criando indice por...")
	IndRegua(cTRB1, cIndAge2, "CLIENTE",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge3, "LOJA",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge4, "COLIGADA",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge5, "NOME_COLIG",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge6, "NOME",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge7, "CGC_CPF",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge8, "FONE_CLI",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge9, "DTAGEN",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge10,"NUMORC",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge11,"PEDIDO",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge12,"AGENDAS",,, "Criando indice por..")
	IndRegua(cTRB1, cIndAge13,"VENDEDOR",,, "Criando indice por..")

	//IndRegua(cTRB1, cIndAge5, "ID",,, "Criando indice por ID...")

	Set Cursor Off
	DbClearIndex()
	DbSetIndex(cIndAge1+OrdBagExt())
	DbSetIndex(cIndAge2+OrdBagExt())
	DbSetIndex(cIndAge3+OrdBagExt())
	DbSetIndex(cIndAge4+OrdBagExt())
	DbSetIndex(cIndAge5+OrdBagExt())
	DbSetIndex(cIndAge6+OrdBagExt())
	DbSetIndex(cIndAge7+OrdBagExt())
	DbSetIndex(cIndAge8+OrdBagExt())
	DbSetIndex(cIndAge9+OrdBagExt())
	DbSetIndex(cIndAge10+OrdBagExt())
	DbSetIndex(cIndAge11+OrdBagExt())
	DbSetIndex(cIndAge12+OrdBagExt())
	DbSetIndex(cIndAge13+OrdBagExt())
	//--Busca os dados 
	cTRB4:=FBuscaDad()
	//--Carrega os dados
	FSCarDados(@cTRB1, @cTRB4,'')
	//--Busco os totais da carteira
	aAdd(aTotais, {0, 0, 0.0, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0})
	MsgRun("Aguarde... Buscando dados para dashboard",,{|| FSTOTCAR(cGrCart, cAtend, @aTotais) } )

	DbSelectArea(cTRB1)
	DbSetOrder(1)
	DbGotop()

	aAdd(aSeek,{"FILIAL",     {{"","C",04,0,"FILIAL"}} } )
	aAdd(aSeek,{"CLIENTE",    {{"","C",08,0,"CLIENTE"}} } )
	aAdd(aSeek,{"LOJA",       {{"","C",04,0,"CLIENTE"}} } )
	aAdd(aSeek,{"COLIGADA",   {{"","C",06,0,"COLIGADA"}} } )
	aAdd(aSeek,{"NOME_COLIG", {{"","C",20,0,"NOME_COLIG"}} } )
	aAdd(aSeek,{"NOME",       {{"","C",40,0,"NOME"}} } )
	aAdd(aSeek,{"CGC_CPF",    {{"","C",14,0,"CGC_CPF"}} } )
	aAdd(aSeek,{"FONE_CLI",   {{"","C",14,0,"CGC_CPF"}} } )	
	aAdd(aSeek,{"DTAGEN", 	  {{"","D",8,0,"DTAGEN"}} } )
	aAdd(aSeek,{"NUMORC",     {{"","N",12,0,"NUMORC"}} } )
	aAdd(aSeek,{"PEDIDO",     {{"","N",12,0,"PEDIDO"}} } )
	aAdd(aSeek,{"AGENDAS",    {{"","N",12,0,"AGENDAS"}} } )
	aAdd(aSeek,{"VENDEDOR",   {{"","C",40,0,"VENDEDOR"}} } )

	aSize := MSADVSIZE()

	aCoors := FWGetDialogSize( oMainWnd )

	Define MsDialog oTelSelct Title "Controle de agendas" FROM aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel Style DS_MODALFRAME

	oTelSelct:lEscClose := .F.
	
	oLayer := FWLayer():New()

	oLayer:Init(oTelSelct)
	oLayer:addLine("TOTAIS", 13, .F.)
	//oLayer:addLine("AGENDA", 55, .F.)
	oLayer:addLine("AGENDA", 75, .F.)
	//oLayer:addLine("HISTOR", 25, .F.)

	oLayer:AddCollumn("BOX1",     14.28, .F., "TOTAIS")
	oLayer:AddCollumn("BOX2",     14.28, .F., "TOTAIS")
	oLayer:AddCollumn("BOX3",     14.28, .F., "TOTAIS")
	oLayer:AddCollumn("BOX4",     14.29, .F., "TOTAIS")
	oLayer:AddCollumn("BOX5",     14.29, .F., "TOTAIS")
	oLayer:AddCollumn("BOX6",     14.29, .F., "TOTAIS")
	oLayer:AddCollumn("BOX7",     14.29, .F., "TOTAIS")
	oLayer:addCollumn("COL_AGENDA", 100, .f., "AGENDA")
	//oLayer:addCollumn("COL_HISTOR", 100, .f., "HISTOR")

	oLayer:AddWindow("BOX1", "oPanel1", "Número de clientes", 100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX2", "oPanel2", "Compraram no mês",   100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX3", "oPanel3", "Positivação",        100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX4", "oPanel4", "Meta do mês",        100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX5", "oPanel5", "Vendas acumuladas",  100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX6", "oPanel6", "Meta diária",        100,.F.,.F.,,"TOTAIS",{ || })
	oLayer:AddWindow("BOX7", "oPanel7", "Agendas",            100,.F.,.F.,,"TOTAIS",{ || })

	oWin01 := oLayer:GetWinPanel('BOX1', 'oPanel1', 'TOTAIS')
	oWin02 := oLayer:GetWinPanel('BOX2', 'oPanel2', 'TOTAIS')
	oWin03 := oLayer:GetWinPanel('BOX3', 'oPanel3', 'TOTAIS')
	oWin04 := oLayer:GetWinPanel('BOX4', 'oPanel4', 'TOTAIS')
	oWin05 := oLayer:GetWinPanel('BOX5', 'oPanel5', 'TOTAIS')
	oWin06 := oLayer:GetWinPanel('BOX6', 'oPanel6', 'TOTAIS')
	oWin07 := oLayer:GetWinPanel('BOX7', 'oPanel7', 'TOTAIS')

	oPtela := oLayer:GetColPanel("COL_AGENDA","AGENDA")
	oPtela:FreeChildren()

	//oPtela1 := oLayer:GetColPanel("COL_HISTOR","HISTOR")
	//oPtela1:FreeChildren()

	// Totais parte superior da tela
	oTot1 := TSay():New(03, 013, {|| aTotais[1][1]}, oWin01,"@E 999,999,999", oFont,,,,.T.,,,60, 18 )
	oTot2 := TSay():New(03, 013, {|| aTotais[1][2]}, oWin02,"@E 999,999,999", oFont,,,,.T.,,,60, 18 )
	oTot3 := TSay():New(03, 013, {|| aTotais[1][3]}, oWin03,"@E 9999.9",      oFont,,,,.T.,,,60, 18 )
	TSay():New(03, 039, {|| "%" },          oWin03,,                 oFont,,,,.T.,,,10, 18 )
	oTot4 := TSay():New(03, 010, {|| aTotais[1][4]}, oWin04,"@E 999,999,999,999.99", oFont,,,,.T.,,,70, 18 )
	oTot5 := TSay():New(03, 007, {|| aTotais[1][5]}, oWin05,"@E 999,999,999,999.99", oFont,,,,.T.,,,70, 18 )
	oTot6 := TSay():New(03, 010, {|| aTotais[1][6]}, oWin06,"@E 999,999,999,999.99", oFont,,,,.T.,Iif(aTotais[1][6] < 0.00, CLR_HRED, CLR_HBLUE), CLR_WHITE,60, 18 )
	
	oTot7 := TSay():New(03, 000, {|| aTotais[1][7]}, oWin07,"@E 9999",        oFont1,,,,.T.,CLR_HRED,CLR_WHITE,60, 18 )
	TSay():New(03, 015, {|| "/" },          oWin07,,                 oFont1,,,,.T.,,,60, 18 )
	oTot8 := TSay():New(03, 015, {|| aTotais[1][8]}, oWin07,"@E 9999",        oFont1,,,,.T.,,,60, 18 )
	TSay():New(03, 030, {|| "/" },          oWin07,,                 oFont1,,,,.T.,,,60, 18 )
	oTot9 := TSay():New(03, 033, {|| aTotais[1][9]}, oWin07,"@E 9999",        oFont1,,,,.T.,,,60, 18 )
	//TSay():New(03, 049, {|| "/" },          oWin07,,                 oFont1,,,,.T.,,,60, 18 )
	//oTotA := TSay():New(03, 054, {|| aTotais[1][10]}, oWin07,"@E 9999",        oFont1,,,,.T.,,,60, 18 )
	//TSay():New(03, 069, {|| "/" },          oWin07,,                 oFont1,,,,.T.,,,60, 18 )
	//oTotB := TSay():New(03, 071, {|| aTotais[1][11]}, oWin07,"@E 9999",        oFont1,,,,.T.,,,60, 18 )
	//oTot7:SetTextAlign( 0, 2 )
	// Browser das agendas
	DEFINE FWFORMBROWSE oBrwCab1 DATA TABLE ALIAS cTRB1 OF oPtela

	oBrwCab1:SetDescription("Agendamentos do dia: "+Dtoc(dDataBase))
	oBrwCab1:SetAlias((cTRB1))
	oBrwCab1:SetTemporary(.T.)
	oBrwCab1:SetdbFFilter(.T.)
	oBrwCab1:SetUseFilter(.T.)
	oBrwCab1:DisableReport()
	oBrwCab1:DisableDetails()
	oBrwCab1:DisableConfig()
	oBrwCab1:bHeaderClick := {|| OrdenaBrowse(oBrwCab1) }

	//oBrwCab1:SetChange( {|| FSDETAGE((cTRB1)->FILIAL, (cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->DATINC, (cTRB1)->HORINC, oPtela1, .F.)} )
	//oBrwCab1:bLDblClick := {|| U_TAG06DUP((cTRB1)->FILIAL, (cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->DATINC, (cTRB1)->HORINC, cGrCart, cCarteiras, cAtend, oBrwCab1, oTelSelct, @aRet, (cTRB1)->ID) }
	oBrwCab1:bLDblClick := {|| U_TAGAGEND((cTRB1)->CLIENTE, (cTRB1)->LOJA) }
	oBrwCab1:SetSeek({|oSeek, oBrowse| fConSeek(oSeek, oBrowse,'','P')}, aSeek)
	//oBrwCab1:SetSeek({||.T.},aSeek)
	
	//ADD LEGEND DATA {|| &(aArqAge[01,1])=="1" } COLOR "RED"   TITLE "Atrasada"        OF oBrwCab1
	//ADD LEGEND DATA {|| &(aArqAge[01,1])=="2" } COLOR "BLUE"  TITLE "Agenda do dia"   OF oBrwCab1
	//ADD LEGEND DATA {|| &(aArqAge[01,1])=="3" } COLOR "GREEN" TITLE "Agenda atendida" OF oBrwCab1
	//ADD LEGEND DATA {|| &(aArqAge[01,1])=="4" } COLOR "WHITE" TITLE "Agenda futura"   OF oBrwCab1

	//oBrwCab1:aColumns[1]:cTitle := "Sts"
                                 
	ADD COLUMN oColumn DATA { || &(aArqAge[01,1]) } TITLE "Filial"          SIZE aArqAge[01,3] PICTURE PesqPict("ZAF","ZAF_FILIAL")  TYPE aArqAge[01,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[02,1]) } TITLE "Cliente"         SIZE aArqAge[02,3] PICTURE PesqPict("ZAF","ZAF_CLIENT")  TYPE aArqAge[02,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[03,1]) } TITLE "Loja"            SIZE aArqAge[03,3] PICTURE PesqPict("ZAF","ZAF_LOJA")    TYPE aArqAge[03,2] ALIGN 1 OF oBrwCab1

	ADD COLUMN oColumn DATA { || &(aArqAge[04,1]) } TITLE "Coligada"        SIZE aArqAge[04,3] PICTURE PesqPict("SA1","A1_XCOLIG")   TYPE aArqAge[04,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[05,1]) } TITLE "Nome_colig"      SIZE aArqAge[05,3] PICTURE PesqPict("SZ6","Z6_DESCRI")   TYPE aArqAge[05,2] ALIGN 1 OF oBrwCab1

	ADD COLUMN oColumn DATA { || &(aArqAge[06,1]) } TITLE "Nome cliente"    SIZE aArqAge[06,3] PICTURE PesqPict("SA1","A1_NOME")     TYPE aArqAge[06,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[07,1]) } TITLE "CGC/CPF"   		SIZE aArqAge[07,3] PICTURE PesqPict("SA1","A1_CGC")      TYPE aArqAge[07,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[08,1]) } TITLE "Fone cliente"    SIZE aArqAge[08,3] PICTURE '@R 9999999999999'      		 TYPE aArqAge[08,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[08,1]) } TITLE "Contato"       SIZE aArqAge[08,3] PICTURE PesqPict("SA1","A1_CONTATO")  TYPE aArqAge[08,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[09,1]) } TITLE "Dt Agenda(+)Prox"SIZE aArqAge[09,3] PICTURE PesqPict("ZAF","ZAF_DTAGEN")  TYPE aArqAge[09,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[10,1]) } TITLE "Qtd Orçamento"  SIZE aArqAge[10,3] PICTURE '@R 999'    					 TYPE aArqAge[10,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[11,1]) } TITLE "Qtd Pedido"      SIZE aArqAge[11,3] PICTURE '@R 999'  	 				 TYPE aArqAge[11,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[12,1]) } TITLE "Qtd Agendas"     SIZE aArqAge[12,3] PICTURE '@R 999'    					 TYPE aArqAge[12,2] ALIGN 1 OF oBrwCab1
	ADD COLUMN oColumn DATA { || &(aArqAge[13,1]) } TITLE "Nome vendedor"   SIZE aArqAge[13,3] PICTURE PesqPict("SA3","A3_NOME")     TYPE aArqAge[13,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[13,1]) } TITLE "Vlr.orcamento"   SIZE aArqAge[13,3] PICTURE PesqPict("ZAF","ZAF_VLRORC")  TYPE aArqAge[13,2] ALIGN 2 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[14,1]) } TITLE "Data inc.agenda" SIZE aArqAge[14,3] PICTURE PesqPict("ZAF","ZAF_DATINC")  TYPE aArqAge[14,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[15,1]) } TITLE "Fone contato"    SIZE aArqAge[15,3] PICTURE PesqPict("SU5","U5_FCOM1")    TYPE aArqAge[15,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[16,1]) } TITLE "Tipo agenda"     SIZE aArqAge[16,3] PICTURE PesqPict("ZAD","ZAD_DESC")    TYPE aArqAge[16,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[15,1]) } TITLE "Carteira"        SIZE aArqAge[15,3] PICTURE PesqPict("ZA6","ZA6_DESCR")   TYPE aArqAge[15,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[17,1]) } TITLE "Hora Inc"  		SIZE aArqAge[17,3] PICTURE PesqPict("ZAF","ZAF_HORINC")  TYPE aArqAge[17,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[18,1]) } TITLE "ID Agenda"       SIZE aArqAge[18,3] PICTURE PesqPict("ZAF","ZAF_ID")      TYPE aArqAge[18,2] ALIGN 1 OF oBrwCab1
	//ADD COLUMN oColumn DATA { || &(aArqAge[19,1]) } TITLE "ID Pai"          SIZE aArqAge[19,3] PICTURE PesqPict("ZAF","ZAF_IDPAI")   TYPE aArqAge[19,2] ALIGN 1 OF oBrwCab1

	//oTimer := TTimer():New(GetMv('TAG_TEMPAG',.F.,30000), {|| FsTime(@cTRB1, oBrwCab1, @aTotais) }, oTelSelct )
    //oTimer:Activate()

	ACTIVATE FWFORMBROWSE oBrwCab1

	oBrwCab1:SetFocus()

	bOK     := {|| oTelSelct:End()}
	bCancel := {|| oTelSelct:End()}
	
	//aAdd(aButtons, {"EDITABLE", {|| U_TAG06VIS((cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->DATINC, (cTRB1)->HORINC), oBrwCab1:SetFocus() }, "Visualizar"})
	//aAdd(aButtons, {"EDITABLE", {|| U_IVENA020('','',(cTRB1)->NUMORC, (cTRB1)->ID) }, "Retornar ao CVI"})	
	//aAdd(aButtons, {"EDITABLE", {|| U_TAG06DUP((cTRB1)->FILIAL, (cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->DATINC, (cTRB1)->HORINC, cGrCart, cCarteiras, cAtend, oBrwCab1, oTelSelct, @aRet, (cTRB1)->ID) }, "Retorno"})
	//aAdd(aButtons, {"EDITABLE", {|| FsFuncRet((cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->NUMORC, (cTRB1)->ID), FsTime(@cTRB1, oBrwCab1, @aTotais) }, "Retornar ao CVI"})
	//aAdd(aButtons, {"EDITABLE", {|| U_TAG06LEG("G"), oBrwCab1:SetFocus() }, "Legenda"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06NEW(cGrCart, cCarteiras, cAtend, oBrwCab1), oBrwCab1:SetFocus() }, "Nova"})
	aAdd(aButtons, {"EDITABLE", {|| MATA410()}, "Pedidos de venda" })
	aAdd(aButtons, {"EDITABLE", {|| U_GDVA035()}, "Gdview Cli" })
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HIS((cTRB1)->CLIENTE, (cTRB1)->LOJA), oBrwCab1:SetFocus() }, "Hist.Cliente"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HAG((cTRB1)->CLIENTE, (cTRB1)->LOJA, ''), oBrwCab1:SetFocus() }, "Hist.Agenda"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HCL((cTRB1)->CLIENTE, (cTRB1)->LOJA, (cTRB1)->NUMORC), oBrwCab1:SetFocus() }, "Hist.Orçamento"})	
	aAdd(aButtons, {"EDITABLE", {|| U_TAGAGEND((cTRB1)->CLIENTE, (cTRB1)->LOJA), oBrwCab1, oBrwCab1:SetFocus(), @aTotais }, "Seleção Agenda"})			
	aAdd(aButtons, {"EDITABLE", {|| FsTime(@cTRB1, oBrwCab1, @aTotais) }, "Refresh"})
	aAdd(aButtons, {"EDITABLE", {|| goUpdTime(@nTimerWin, oTimer) }, "Alt.Tempo Refresh"})

	//Executa o Refresh 
	oTimer := TTimer():New((nTimerWin*1000), {|| FsTime(@cTRB1, oBrwCab1, @aTotais) }, oTelSelct)	//milisegundos *1000
	oTimer:Activate()

	ACTIVATE MSDIALOG oTelSelct ON INIT EnchoiceBar(oTelSelct, bOK, bCancel,, aButtons,,,, .F., .F., .F., .F., .F. ) centered

	//If Select( cTRBUSR ) > 0; dbSelectArea( cTRBUSR ); dbCloseArea(); EndIf
	If Select( cTRB1 ) > 0; dbSelectArea( cTRB1 ); dbCloseArea(); EndIf
	//If Select( cTMP3 ) > 0; dbSelectArea( cTMP3 ); dbCloseArea(); EndIf
	
	FErase(cTRB1 + GetDbExtension())
	FErase(cTRB1 + OrdBagExt())
	
	FErase(cArqAge + GetDbExtension())
	FErase(cIndAge1 + OrdBagExt())
	FErase(cIndAge2 + OrdBagExt())
	FErase(cIndAge3 + OrdBagExt())
	FErase(cIndAge4 + OrdBagExt())
	FErase(cIndAge5 + OrdBagExt())
	FErase(cOrdBrw + OrdBagExt())

Return aRet
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} DEN05C22
Funcao mostra detalhe do agendamento 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSDETAGE(cFilZAF, cCliente, cLoja, dDta, cHor, oDet, lHist)
	
	Local mHistor := ""
	Local oFont1  := TFont():New( "Courier New",,14,.f.,.f.,,,,,.f. )

	dbselectarea("ZAF")
	DBSETORDER(1)  // ZAF_FILIAL + ZAF_CLIENT + ZAF_LOJA + DTOS(ZAF_DATINC) + ZAF_HORINC)
	DBSEEK(cFilZAF+cCliente+cLoja+dTos(dDta)+cHor)

	mHistor := ZAF->ZAF_HISTOR

	If lHist
		@ 007,004 GET oHistor VAR mHistor MEMO SIZE 640,160  FONT oFont1 OF oDet PIXEL
	Else
		@ 007,004 GET oHistor VAR mHistor MEMO SIZE 640,050  FONT oFont1 OF oDet PIXEL
	EndIf

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06LEG
Funcaoo exibe legenda 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//--------------------------------------------------------------------------------------
User Function TAG06LEG(cTp)
	
	Local aLegenda := {}

	If cTp=="G"
		aAdd(aLEGENDA, {""            ,"Status da agenda"})
		aAdd(aLEGENDA, {"BR_VERMELHO" ,"Agenda atrasada"})
		aAdd(aLEGENDA, {"BR_AZUL"     ,"Agenda do dia"})
		aAdd(aLEGENDA, {"BR_VERDE"    ,"Agenda finalizada"})
		aAdd(aLEGENDA, {"BR_BRANCO"   ,"Agenda futura"})
		//aAdd(aLEGENDA, {""            ,""})
		//aAdd(aLEGENDA, {""            ,"Tipo de agenda"})
		//aAdd(aLEGENDA, {"BR_BRANCO"   ,"Agenda manual"})
		//aAdd(aLEGENDA, {"BR_AMARELO"  ,"Agenda acompanhamento de orcamento"})
		//aAdd(aLEGENDA, {"BR_MARROM"   ,"Agenda cliente sem compra"})
		//aAdd(aLEGENDA, {"BR_PINK"     ,"Agenda por inatividade"})
	Else
		aAdd(aLEGENDA, {"BR_BRANCO"   ,"Agenda manual"})
		aAdd(aLEGENDA, {"BR_AMARELO"  ,"Agenda acompanhamento de orçamento"})
		aAdd(aLEGENDA, {"BR_MARROM"   ,"Agenda cliente sem compra"})
		aAdd(aLEGENDA, {"BR_PINK"     ,"Agenda por inatividade"})
	Endif

	BrwLegenda("Agenda","Legenda" ,aLegenda)

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06VIS
Funcao de visualizar agendamento 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06VIS(cCliente, cLoja, dDta, cHor)
	
	Local oDlgAge
	Local oAge1, oAge2, oAge3, oAge5, oAge6, oAge9, oAge10, oAge11, oAge12, oAge15
	Local aForma   := {"1=Telefone", "2=E-mail", "3=Outros"}
	Local cTpAgen  := CriaVar("ZAF_TPAGEN", .F.)
	Local cDescric := CriaVar("ZAD_DESC", .F.)
	Local dDtaInc  := dDataBase
	Local cHorInc  := Time()
	Local dDtAgen  := cTod("//")
	Local cHistor  := CriaVar("ZAF_HISTOR", .F.)
	Local cCodCnt  := CriaVar("ZAF_CONTAT", .F.)
	Local cForma   := CriaVar("ZAF_FORMA", .F.)
	Local cGrpCar  := CriaVar("ZAF_GRCART", .F.)
	Local cDesGrCar:= CriaVar("ZAE_DESC", .F.)
	Local cCart    := CriaVar("ZAF_CART", .F.)
	Local cDesCart := CriaVar("ZA6_DESCR", .F.)
	Local cProsp   := CriaVar("ZAF_PROSP", .F.)
	Local cUsrInc  := ""
	Local cNomCnt  := ""
	Local cFonCnt  := ""
	Local cEmlCnt  := ""

	dbselectarea("ZAF")
	DbSetOrder(1)  // ZAF_FILIAL + ZAF_CLIENT + ZAF_LOJA + DTOS(ZAF_DATINC) + ZAF_HORINC)
	MsSeek(xFilial("ZAF") + cCliente + cLoja + dTos(dDta) + cHor)

	cTpAgen  := ZAF->ZAF_TPAGEN
	cDescric := Posicione("ZAD",1,xFilial("ZAD")+ZAF->ZAF_TPAGEN,"ZAD_DESC")
	dDtaInc  := ZAF->ZAF_DATINC
	cHorInc  := ZAF->ZAF_HORINC
	dDtAgen  := ZAF->ZAF_DTAGEN
	cHistor  := ZAF->ZAF_HISTOR
	cCodCnt  := ZAF->ZAF_CONTAT
	cForma   := ZAF->ZAF_FORMA
	cGrpCar  := ZAF->ZAF_GRCART
	cDesGrCar:= Posicione("ZAE",1,xFilial("ZAE")+ZAF->ZAF_GRCART,"ZAE_DESC")
	cCart    := ZAF->ZAF_CART
	cDesCart := Posicione("ZA6",1,xFilial("ZA6")+ZAF->ZAF_CART,"ZA6_DESCR")
	cProsp   := ZAF->ZAF_PROSP
	cUsrInc  := UsrRetName(ZAF->ZAF_USRINC)

	DbSelectArea("SU5")
	dbSetOrder(1)  // U5_FILIAL, U5_CODCONT.
	MsSeek(xFilial("SU5") + ZAF->ZAF_CONTAT, .F.)
	cNomCnt  := SU5->U5_CONTAT
	cFonCnt  := SU5->U5_FCOM1
	cEmlCnt  := SU5->U5_EMAIL

	DEFINE MSDIALOG oDlgAge TITLE "Agenda" FROM 000,000 TO 370,900   PIXEL Style DS_MODALFRAME

	oDlgAge:lEscClose := .F.

	@ 007,005 SAY "Tipo atendimento:"         Size 075,007 OF oDlgAge   PIXEL

	@ 022,005 SAY "Data inclusão:"            Size 075,007 OF oDlgAge   PIXEL
	@ 022,200 SAY "Hora:"                     Size 075,007 OF oDlgAge   PIXEL
	@ 022,320 SAY "Atendente:"                Size 075,007 OF oDlgAge   PIXEL

	@ 037,005 SAY "Data agendamento:"         Size 075,007 OF oDlgAge   PIXEL
	//@ 037,200 SAY "Carteira:"                 Size 075,007 OF oDlgAge   PIXEL
	@ 037,200 SAY "Telefone do contato:"      Size 075,007 OF oDlgAge   PIXEL

	@ 052,005 SAY "Contato empresa:"          Size 075,007 OF oDlgAge   PIXEL


	@ 067,005 SAY "Forma de contato:"         Size 075,007 OF oDlgAge   PIXEL
	//@ 067,200 SAY "Grupo carteira:"           Size 075,007 OF oDlgAge   PIXEL

	@ 082,005 SAY "Historico"                 Size 105,009 OF oDlgAge   PIXEL

	@ 007,055 MSGET    oAge1   Var cTpAgen   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "ZAD"    WHEN .F.
	@ 007,100 MSGET    oAge2   Var cDescric                       Size 150,009 OF oDlgAge  PIXEL             WHEN .F.

	@ 022,055 MSGET    oAge3   Var dDtaInc   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL             WHEN .F.
	@ 022,250 MSGET    oAge3   Var cHorInc   PICTURE '99:99:99'   Size 030,009 OF oDlgAge  PIXEL             WHEN .F.
	@ 022,360 MSGET    oAge5   Var cUsrInc                        Size 085,009 OF oDlgAge  PIXEL             WHEN .F.

	@ 037,055 MSGET    oAge6   Var dDtAgen   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL             WHEN .F.
	@ 037,250 MSGET    oAge11  Var cFonCnt   PICTURE "@!"         Size 095,009 OF oDlgAge  PIXEL             WHEN .F.
	
	//@ 052,055 MSGET    oAge9   Var cCodCnt   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "CNTAGE" WHEN .F.
	@ 052,055 MSGET    oAge9   Var cCodCnt   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "SUS" WHEN .F.
	@ 052,100 MSGET    oAge10  Var cNomCnt   PICTURE '@!'         Size 095,009 OF oDlgAge  PIXEL             WHEN .F.

	@ 067,055 ComboBox oAge12  Var cForma    Items aForma         Size 060,008 OF oDlgAge  PIXEL             WHEN .F.
	
	@ 095,005 GET      oAge15   Var cHistor   MEMO 	              Size 440,063 OF oDlgAge PIXEL

	@ 162,360 BUTTON oHButton2 PROMPT "&Sair"                     Size 062,018 OF oDlgAge ACTION (oDlgAge:End()) PIXEL

	ACTIVATE MSDIALOG oDlgAge CENTERED

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06DUP
Funcao duplo Click 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06DUP(cFilZAF, cCliente, cLoja, dDta, cHor, cGrCart, cCarteiras, cAtend, oBrwCab1, oTelSelct, aRet, cIdAged, cTabAgen)
	
	Local oDlgAge, oHButton1, oHButton2
	Local oAge1, oAge2, oAge3, oAge5, oAge6, oAge9, oAge10, oAge11, oAge12, oAge15
	Local aForma   := {"1=Telefone", "2=E-mail", "3=Outros"}
	Local cTpAgen  := CriaVar("ZAF_TPAGEN", .F.)
	Local cDescric := CriaVar("ZAD_DESC", .F.)
	Local dDtaInc  := dDataBase
	Local cHorInc  := Time()
	Local dDtAgen  := cTod("//")
	Local cHistor  := CriaVar("ZAF_HISTOR", .F.)
	Local cCodCnt  := CriaVar("ZAF_CONTAT", .F.)
	Local cForma   := CriaVar("ZAF_FORMA", .F.)
	Local cGrpCar  := CriaVar("ZAF_GRCART", .F.)
	Local cDesGrCar:= CriaVar("ZAE_DESC", .F.)
	Local cCart    := CriaVar("ZAF_CART", .F.)
	Local cDesCart := CriaVar("ZA6_DESCR", .F.)
	Local cProsp   := CriaVar("ZAF_PROSP", .F.)
	Local cUsrInc  := ""
	Local cNomCnt  := ""
	Local cFonCnt  := ""
	Local cEmlCnt  := ""
	Local cNumOrc  := ""
	Local nVlrOrc  := 0.00
	Local cIdPai   := CriaVar("ZAF_IDPAI", .F.)
	Local cId      := CriaVar("ZAF_ID", .F.)
	Local cQryUpd  := ""
	Local aTotais  := {}
	//Local cQry     := ""
	Local lRet     := .T.
	Local cTipFin  := ''
	Local lCampTrue:= .F.

	Local lNewAg := .T.

	dbselectarea("ZAF")
	DbSetOrder(1)  // ZAF_FILIAL + ZAF_CLIENT + ZAF_LOJA + DTOS(ZAF_DATINC) + ZAF_HORINC)
	MsSeek(cFilZAF + cCliente + cLoja + dTos(dDta) + cHor)

	IF ZAF->ZAF_ATEND == '1'
		MsgAlert("Agenda já atendida em " + dToc(ZAF->ZAF_DTARET) + ", as " + ZAF->ZAF_HORRET + ", por " +  UsrRetName(ZAF->ZAF_USRRET) )
		Return
	Endif

	//--Busco o contato do agendamento
	DbSelectArea("SU5")
	dbSetOrder(1)  // U5_FILIAL, U5_CODCONT.
	MsSeek(xFilial("SU5") + ZAF->ZAF_CONTAT, .F.)
	cNomCnt  := SU5->U5_CONTAT
	cFonCnt  := SU5->U5_FCOM1
	cEmlCnt  := SU5->U5_EMAIL

	cCodCnt  := ZAF->ZAF_CONTAT

	cGrpCar  := ZAF->ZAF_GRCART
	cDesGrCar:= Posicione("ZAE",1,xFilial("ZAE")+ZAF->ZAF_GRCART,"ZAE_DESC")
	cCart    := ZAF->ZAF_CART
	cDesCart := Posicione("ZA6",1,xFilial("ZA6")+ZAF->ZAF_CART,"ZA6_DESCR")
	cProsp   := ZAF->ZAF_PROSP
	cUsrInc  := UsrRetName(ZAF->ZAF_USRINC)

	cEntZAF  := IIF(cProsp=="2","SA1","SUS")
	cCliEnt  := cCliente
	cLojEnt  := cLoja

	DEFINE MSDIALOG oDlgAge TITLE "Retorno de agenda" FROM 000,000 TO 370,900   PIXEL Style DS_MODALFRAME

	oDlgAge:lEscClose     := .F.

	@ 007,005 SAY "Tipo atendimento:"         Size 075,007 OF oDlgAge   PIXEL

	@ 022,005 SAY "Data inclusão:"            Size 075,007 OF oDlgAge   PIXEL
	@ 022,200 SAY "Hora:"                     Size 075,007 OF oDlgAge   PIXEL
	@ 022,320 SAY "Atendente:"                Size 075,007 OF oDlgAge   PIXEL

	@ 037,005 SAY "Data agendamento:"         Size 075,007 OF oDlgAge   PIXEL
	@ 037,200 SAY "Telefone do contato:"      Size 075,007 OF oDlgAge   PIXEL

	@ 052,005 SAY "Contato empresa:"          Size 075,007 OF oDlgAge   PIXEL
	
	@ 067,005 SAY "Forma de contato:"         Size 075,007 OF oDlgAge   PIXEL

	@ 082,005 SAY "Historico"                 Size 105,009 OF oDlgAge   PIXEL

	@ 007,055 MSGET    oAge1   Var cTpAgen   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "ZAD" VALID VldTpAg(cTpAgen, @cDescric) WHEN IIF(ZAF->ZAF_ATEND=='1',.F.,.T.) .Or. lCampTrue
	@ 007,100 MSGET    oAge2   Var cDescric                       Size 150,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 022,055 MSGET    oAge3   Var dDtaInc   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL          WHEN .F.
	@ 022,250 MSGET    oAge3   Var cHorInc   PICTURE '99:99:99'   Size 030,009 OF oDlgAge  PIXEL          WHEN .F.
	@ 022,360 MSGET    oAge5   Var cUsrInc                        Size 085,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 037,055 MSGET    oAge6   Var dDtAgen   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL          VALID (dDtAgen<>CTOD("//").And.dDtAgen>=dDatabase) WHEN IIF(ZAF->ZAF_ATEND=='1',.F.,.T.) .Or. lCampTrue
	@ 037,250 MSGET    oAge11  Var cFonCnt   PICTURE "@!"         Size 095,009 OF oDlgAge  PIXEL          WHEN .F.
	
	@ 052,055 MSGET    oAge9   Var cCodCnt   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "SU5" WHEN IIF(ZAF->ZAF_ATEND=='1',.F.,.T.) .Or. lCampTrue
	@ 052,100 MSGET    oAge10  Var cNomCnt   PICTURE '@!'         Size 095,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 067,055 ComboBox oAge12  Var cForma    Items aForma         Size 060,008 OF oDlgAge  PIXEL          WHEN IIF(ZAF->ZAF_ATEND=='1',.F.,.T.) .Or. lCampTrue

	@ 095,005 GET      oAge15  Var cHistor   MEMO 	              Size 440,063 OF oDlgAge  PIXEL

	If ZAF->ZAF_ATEND <> '1'
		//@ 162,130 BUTTON oHButton1 PROMPT "&Retornar CVI" 	  	  Size 062,018 OF oDlgAge ACTION (IIF(U_IVENA020(cCliente, cLoja,'', cIdAged),(nOpca:=0, oDlgAge:End()),) ) PIXEL
		@ 162,130 BUTTON oHButton1 PROMPT "&Retornar CVI" 	  	  Size 062,018 OF oDlgAge ACTION (IIF(FsFuncRet(cCliente, cLoja, '',cIdAged),(nOpca:=0, lCampTrue:= .T.),), oDlgAge:End() ) PIXEL		
		@ 162,210 BUTTON oHButton1 PROMPT "&Finalizar atend." 	  Size 062,018 OF oDlgAge ACTION (IIF(VldFin(@lNewAg),(nOpca:=2, oDlgAge:End()),) ) PIXEL		
		@ 162,290 BUTTON oHButton1 PROMPT "&Reagendar"            Size 062,018 OF oDlgAge ACTION (IIF(ValHist(cTpAgen, dDtAgen, cCliente, cLoja, cCodCnt, cHistor, 'R'),(nOpca:=1, oDlgAge:End()), (nOpca:=0, oAge1:SetFocus()))) PIXEL
	EndIf
	@ 162,370    BUTTON oHButton2 PROMPT "&Sair"                  Size 062,018 OF oDlgAge ACTION (nOpca:=0, oDlgAge:End()) PIXEL

	ACTIVATE MSDIALOG oDlgAge CENTERED

	If nOpca == 1
		//Verifica se tem pedido gerado
		SUA->(dbSetOrder(1)) //UA_FILIAL, UA_NUM
		If ZAF->ZAF_ATEND == '1'
			MsgAlert("Agenda já antendida em " + dToc(ZAF->ZAF_DTARET) + ", as " + ZAF->ZAF_HORRET + ", por " +  UsrRetName(ZAF->ZAF_USRRET) )
			lRet := .F.
		ElseIf SUA->(DbSeek(ZAF->ZAF_FILIAL + ZAF->ZAF_NUMORC))
			/*If !Empty(SUA->UA_NUMSC5) .And. Empty(SUA->UA_CODCANC)
				MsgAlert("Agenda encerrada pois foi gerado o pedido de venda " + SUA->UA_NUMSC5 + ".")
				lRet := .F.
				u_gravaAgenda(ZAF->ZAF_FILIAL, ZAF->ZAF_NUMORC, "P")
			Else*/
			If !empty(SUA->UA_CODCANC)
				MsgAlert("Agenda encerrada pois o orçamento foi cancelado.")
				lRet := .F.
				u_gravaAgenda(ZAF->ZAF_FILIAL, ZAF->ZAF_NUMORC, "C")
			EndIf
		EndIf
		If lRet
			// Pega proximo Id da Agenda.
			cId := U_TAG06PRX()

			dbselectarea("ZAF")
			DBSETORDER(1)  // ZAF_FILIAL + ZAF_CLIENT + ZAF_LOJA + DTOS(ZAF_DATINC) + ZAF_HORINC
			DBSEEK(cFilZAF + cCliente + cLoja + dTos(dDta) + cHor)
			IF !Eof()
				If !Empty(ZAF->ZAF_IDPAI)
					cQryUpd := "UPDATE "+RetSqlname("ZAF")+" SET ZAF_IDPAI = '"+cId+"' "
					cQryUpd += "WHERE D_E_L_E_T_ = ' ' "
					cQryUpd += "AND   ZAF_FILIAL = '"+cFilZAF+"' "
					cQryUpd += "AND   ZAF_IDPAI  = '"+ZAF->ZAF_IDPAI+"' "
					TCSqlExec(cQryUpd)
				Endif

				RecLock("ZAF",.F.)
				ZAF->ZAF_ATEND  := '1'
				ZAF->ZAF_DTARET := dDatabase
				ZAF->ZAF_HORRET := Time()
				ZAF->ZAF_USRRET := __cUserId
				ZAF->ZAF_IDPAI  := cId
				MsUnLock()

				cNumOrc := ZAF->ZAF_NUMORC
				nVlrOrc := ZAF->ZAF_VLRORC
			Endif

			If !DbSeek(cFilZAF + cCliente + cLoja + DTos(dDataBase) + cHorInc)
				RecLock("ZAF",.T.)
				ZAF->ZAF_FILIAL  := cFilZAF
				ZAF->ZAF_TPAGEN  := cTpAgen
				ZAF->ZAF_DATINC  := dDtaInc
				ZAF->ZAF_HORINC  := cHorInc
				ZAF->ZAF_DTAGEN  := dDtAgen
				ZAF->ZAF_CONTAT  := cCodCnt
				ZAF->ZAF_FORMA   := cForma
				ZAF->ZAF_GRCART  := cGrpCar
				ZAF->ZAF_CART    := cCart
				ZAF->ZAF_PROSP   := cProsp
				ZAF->ZAF_CLIENT  := cCliente
				ZAF->ZAF_LOJA    := cLoja
				ZAF->ZAF_HISTOR  := cHistor
				ZAF->ZAF_USRINC  := __cUserId
				ZAF->ZAF_NUMORC  := cNumOrc
				ZAF->ZAF_VLRORC  := nVlrOrc
				ZAF->ZAF_IDPAI   := cIdPai
				ZAF->ZAF_ID      := cId
				ZAF->ZAF_IDPAI   := cId
				ZAF->ZAF_ATEND   := "2"

				IF ZAD->ZAD_ACAO == "2"
					ZAF->ZAF_ATEND  := "1"
					ZAF->ZAF_DTARET := dDatabase
					ZAF->ZAF_HORRET := Time()
					ZAF->ZAF_USRRET := __cUserId
				Endif

				ZAF->(MsUnLock())
			Endif                
			
			
			Dbselectarea("SZB")
			
			RecLock("SZB",.T.)
			SZB->ZB_FILIAL  := cFilZAF
			SZB->ZB_CLIENTE := cCliente
			SZB->ZB_LOJA    := cLoja
			SZB->ZB_TITULO  := "000010"
			SZB->ZB_DTHIST  := dDtaInc
			SZB->ZB_HORA    := cHorInc
			SZB->ZB_DTAGEN  := dDtAgen
			SZB->ZB_USER    := cUserName//__cUserId
			SZB->ZB_RESPRES := " "
			SZB->ZB_CONTATO := cCodCnt
			SZB->ZB_FORMA   := cForma
			SZB->ZB_HISTOR  := cHistor
			SZB->ZB_CELULA  := ""
			
			SZB->(MsUnLock())

			DbSelectArea(cTabAgen)
			RecLock(cTabAgen,.F.)
			(cTabAgen)->FLAG := "3"
			MsUnLock()
		Else
			//Quando o pedido é gerado ou ja cancelado e com a tela de reagendamento aberta,
			//garanto o encerramento da agenda e a atualizacao da tela.
			DbSelectArea(cTabAgen)
			RecLock(cTabAgen,.F.)
			(cTabAgen)->(dbDelete())
			(cTabAgen)->(MsUnLock())
		endIf
	ENDIF

	//--Finaliza agendamento
	If nOpca == 2
		// Pega proximo Id da Agenda.
		cId := U_TAG06PRX()
		//--Tela para selecionar opção
		If !FsOpFin(@cTipFin)		
			Return()
		EndIf	

		dbselectarea("ZAF")
		DBSETORDER(1)  // ZAF_FILIAL + ZAF_CLIENT + ZAF_LOJA + DTOS(ZAF_DATINC) + ZAF_HORINC
		DBSEEK(cFilZAF + cCliente + cLoja + dTos(dDta) + cHor)
		IF !Eof()
			If !Empty(ZAF->ZAF_IDPAI)
				cQryUpd := "UPDATE "+RetSqlname("ZAF")+" SET ZAF_IDPAI = '"+cId+"' "
				cQryUpd += "WHERE D_E_L_E_T_ = ' ' "
				cQryUpd += "AND   ZAF_FILIAL = '"+cFilZAF+"' "
				cQryUpd += "AND   ZAF_IDPAI  = '"+ZAF->ZAF_IDPAI+"' "
				TCSqlExec(cQryUpd)
			Endif

			RecLock("ZAF",.F.)
			ZAF->ZAF_ATEND  := '1'
			ZAF->ZAF_DTARET := dDatabase
			ZAF->ZAF_HORRET := Time()
			ZAF->ZAF_USRRET := __cUserId
			ZAF->ZAF_IDPAI  := cId
			ZAF->(MsUnLock())

			cNumOrc := ZAF->ZAF_NUMORC
			nVlrOrc := ZAF->ZAF_VLRORC
		Endif

		cHorInc := Time()
		cCodCnt := ZAF->ZAF_CONTAT
		cForma  := ZAF->ZAF_FORMA

		//Perguntar se deseja criar nova agenda
		//aquicrele
		If lNewAg
			dDtNewAg := dDataBase + 15
			//If !DbSeek(cFilZAF + cCliente + cLoja + DTos(dDataBase) + cHorInc)
			If !DbSeek(cFilZAF + cCliente + cLoja + DTos(dDtNewAg) + cHorInc)
				RecLock("ZAF",.T.)
				ZAF->ZAF_FILIAL  := cFilZAF
				ZAF->ZAF_TPAGEN  := cTipFin
				ZAF->ZAF_DATINC  := dDtaInc
				ZAF->ZAF_HORINC  := cHorInc
				ZAF->ZAF_DTAGEN  := dDtNewAg	//dDtaInc
				ZAF->ZAF_CONTAT  := cCodCnt
				ZAF->ZAF_FORMA   := cForma
				ZAF->ZAF_GRCART  := cGrpCar
				ZAF->ZAF_CART    := cCart
				ZAF->ZAF_PROSP   := cProsp
				ZAF->ZAF_CLIENT  := cCliente
				ZAF->ZAF_LOJA    := cLoja
				ZAF->ZAF_HISTOR  := cHistor
				ZAF->ZAF_USRINC  := __cUserId
				ZAF->ZAF_ATEND   := "2"
				//ZAF->ZAF_ATEND   := "1"
				//ZAF->ZAF_DTARET  := dDatabase
				//ZAF->ZAF_HORRET  := Time()
				//ZAF->ZAF_USRRET  := __cUserId
				ZAF->ZAF_NUMORC  := cNumOrc
				ZAF->ZAF_VLRORC  := nVlrOrc
				ZAF->ZAF_IDPAI   := cId
				ZAF->ZAF_ID      := cId
			ZAF->(MsUnLock())
				
				Dbselectarea("SZB")
				RecLock("SZB",.T.)
				SZB->ZB_FILIAL  := cFilZAF
				SZB->ZB_CLIENTE := cCliente
				SZB->ZB_LOJA    := cLoja
				SZB->ZB_TITULO  := "000010"
				SZB->ZB_DTHIST  := dDtaInc
				SZB->ZB_HORA    := cHorInc
				SZB->ZB_DTAGEN  := dDtNewAg	//dDtAgen
				SZB->ZB_USER    := cUserName//__cUserId
				SZB->ZB_RESPRES := " "
				SZB->ZB_CONTATO := cCodCnt
				SZB->ZB_FORMA   := cForma
				SZB->ZB_HISTOR  := cHistor
				SZB->ZB_CELULA  := ""
				
				SZB->(MsUnLock())

			Endif
		Endif

		DbSelectArea(cTabAgen)
		RecLock(cTabAgen,.F.)
		(cTabAgen)->FLAG := "3"
		MsUnLock()
	ENDIF

	oBrwCab1:GoTo(1,.T.)
	oBrwCab1:Refresh(.T.)

	// Busco os totais da carteira
	aAdd(aTotais, {0, 0, 0.0, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0})
	MsgRun("Aguarde... Atualizando dashboard",,{|| FSTOTCAR(cGrCart, cAtend, @aTotais) } )
	
	FsAtuTot(@aTotais)
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06NEW
Funcao de inclusao de um novo contato 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06NEW(cGrCart, cCarteiras, cAtend, oBrwCab1)
	
	Local oDlgAge, oHButton1, oHButton2
	Local oAge1, oAge2, oAge3, oAge5, oAge6, oAge7, oAge8, oAge9, oAge10, oAge13, oAge14, oAge15, oAge16, oAge19
	Local aForma   := {"1=Telefone", "2=E-mail", "3=Outros"}
	Local aProsp   := {"1=Sim", "2=Nao"}
	Local cTpAgen  := CriaVar("ZAF_TPAGEN", .F.)
	Local cDescric := CriaVar("ZAD_DESC", .F.)
	Local dDtaInc  := dDataBase
	Local cHorInc  := Time()
	Local dDtAgen  := cTod("//")
	Local cHistor  := CriaVar("ZAF_HISTOR", .F.)
	Local cCodCnt  := CriaVar("ZAF_CONTAT", .F.)
	Local cForma   := CriaVar("ZAF_FORMA", .F.)
	Local cGrpCar  := CriaVar("ZAF_GRCART", .F.)
	Local cDesGrCar:= CriaVar("ZAE_DESC", .F.)
	Local cCart    := CriaVar("ZAF_CART", .F.)
	Local cDesCart := CriaVar("Z6_DESCRI", .F.)
	Local cProsp   := "2"
	Local cNomCnt  := ""
	Local cFonCnt  := ""
	//Local cEmlCnt  := ""
	Local cUsrInc  := UsrRetName(__cUserId)
	Local cCliente := CriaVar("ZAF_CLIENT", .F.)
	Local cLoja    := CriaVar("ZAF_LOJA", .F.)
	Local cNomCli  := CriaVar("A1_NOME", .F.)
	Local cId      := CriaVar("ZAF_ID", .F.)
	Local aTotais  := {}

	Private lProspect := .F.

	cEntZAF  := "SA1"
	cCliEnt  := ""
	cLojEnt  := ""

	DEFINE MSDIALOG oDlgAge TITLE "Agenda nova" FROM 000,000 TO 415,900   PIXEL Style DS_MODALFRAME

	oDlgAge:lEscClose := .F.

	@ 007,005 SAY "Cliente/Prospect:"         Size 075,007 OF oDlgAge   PIXEL

	@ 022,005 SAY "Cliente:"                  Size 075,007 OF oDlgAge   PIXEL

	@ 037,005 SAY "Tipo atendimento:"         Size 075,007 OF oDlgAge   PIXEL

	@ 052,005 SAY "Data inclusão:"            Size 075,007 OF oDlgAge   PIXEL
	@ 052,200 SAY "Hora:"                     Size 075,007 OF oDlgAge   PIXEL
	@ 052,320 SAY "Atendente:"                Size 075,007 OF oDlgAge   PIXEL

	@ 067,005 SAY "Data agendamento:"         Size 075,007 OF oDlgAge   PIXEL
	@ 067,200 SAY "Telefone do contato:"      Size 075,007 OF oDlgAge   PIXEL

	@ 082,005 SAY "Contato empresa:"          Size 075,007 OF oDlgAge   PIXEL

	@ 097,005 SAY "Forma de contato:"         Size 075,007 OF oDlgAge   PIXEL

	@ 112,005 SAY "Historico"                 Size 105,009 OF oDlgAge   PIXEL

	@ 007,055 ComboBox oAge1   Var cProsp    Items aProsp         Size 060,008 OF oDlgAge  PIXEL          WHEN .F.

	//@ 022,055 MSGET    oAge2   Var cCliente  PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "U_CLT" VALID VldCli(@cProsp, @cCliente, @cLoja, @cNomCli, @cCart, @cDesCart, @cGrpCar, @cDesGrCar, @cEntZAF, @cCliEnt, @cLojEnt)
	@ 022,055 MSGET    oAge2   Var cCliente  PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "SA1_2" VALID VldCli(@cProsp, @cCliente, @cLoja, @cNomCli, @cCart, @cDesCart, @cGrpCar, @cDesGrCar, @cEntZAF, @cCliEnt, @cLojEnt)
	@ 022,100 MSGET    oAge3   Var cLoja     PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL            VALID VldCli(@cProsp, @cCliente, @cLoja, @cNomCli, @cCart, @cDesCart, @cGrpCar, @cDesGrCar, @cEntZAF, @cCliEnt, @cLojEnt)
	@ 022,150 MSGET    oAge3   Var cNomCli                        Size 295,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 037,055 MSGET    oAge5   Var cTpAgen   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "ZAD" VALID VldTpAg(cTpAgen, @cDescric)
	@ 037,100 MSGET    oAge6   Var cDescric                       Size 150,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 052,055 MSGET    oAge7   Var dDtaInc   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL          WHEN .F.
	@ 052,250 MSGET    oAge8   Var cHorInc   PICTURE '99:99:99'   Size 030,009 OF oDlgAge  PIXEL          WHEN .F.
	@ 052,360 MSGET    oAge9   Var cUsrInc                        Size 085,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 067,055 MSGET    oAge10  Var dDtAgen   PICTURE '99/99/9999' Size 040,009 OF oDlgAge  PIXEL          VALID (dDtAgen<>CTOD("//").And.dDtAgen>=dDatabase)
	@ 067,250 MSGET    oAge15  Var cFonCnt   PICTURE "@!"         Size 095,009 OF oDlgAge  PIXEL          WHEN .F.

	//@ 082,055 MSGET    oAge13  Var cCodCnt   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "CNTAGE"
	@ 082,055 MSGET    oAge13  Var cCodCnt   PICTURE '@!'         Size 035,009 OF oDlgAge  PIXEL F3 "SU5"
	@ 082,100 MSGET    oAge14  Var cNomCnt   PICTURE '@!'         Size 095,009 OF oDlgAge  PIXEL          WHEN .F.

	@ 097,055 ComboBox oAge16  Var cForma    Items aForma         Size 060,008 OF oDlgAge  PIXEL          WHEN .T.

	@ 112,005 GET      oAge19  Var cHistor   MEMO 	              Size 440,063 OF oDlgAge  PIXEL

	@ 185,280 BUTTON oHButton1 PROMPT "&Confirmar"                Size 062,018 OF oDlgAge ACTION (IIF(ValHist(cTpAgen, dDtAgen, cCliente, cLoja, cCodCnt, cHistor, 'N'),(nOpca:=1, oDlgAge:End()), (nOpca:=0, oAge3:SetFocus()))) PIXEL
	@ 185,360 BUTTON oHButton2 PROMPT "&Sair"                     Size 062,018 OF oDlgAge ACTION (nOpca:=0, oDlgAge:End()) PIXEL

	ACTIVATE MSDIALOG oDlgAge CENTERED

	If nOpca == 1
		DBSELECTAREA("ZAF")
		If !DbSeek(xFilial("ZAF") + cCliente + cLoja + DTos(dDtaInc) + cHorInc)

			// Pega proximo Id da agenda
			cId := U_TAG06PRX()

			RecLock("ZAF",.T.)
			ZAF->ZAF_FILIAL  := xFilial("ZAF")
			ZAF->ZAF_TPAGEN  := cTpAgen
			ZAF->ZAF_DATINC  := dDtaInc
			ZAF->ZAF_HORINC  := cHorInc
			ZAF->ZAF_DTAGEN  := dDtAgen
			ZAF->ZAF_CONTAT  := cCodCnt
			ZAF->ZAF_FORMA   := cForma
			ZAF->ZAF_GRCART  := cGrpCar
			ZAF->ZAF_CART    := cCart
			ZAF->ZAF_PROSP   := cProsp
			ZAF->ZAF_CLIENT  := cCliente
			ZAF->ZAF_LOJA    := cLoja
			ZAF->ZAF_HISTOR  := cHistor
			ZAF->ZAF_USRINC  := __cUserId
			ZAF->ZAF_ID      := cId
			ZAF->ZAF_ATEND   := "2"
			If ZAD->ZAD_ACAO == "2"
				ZAF->ZAF_ATEND  := "1"
				ZAF->ZAF_DTARET := dDatabase
				ZAF->ZAF_HORRET := Time()
				ZAF->ZAF_USRRET := __cUserId
			EndIf
                        
			ZAF->(MsUnLock())  
						
			Dbselectarea("SZB")
			RecLock("SZB",.T.)
			SZB->ZB_FILIAL  := xFilial("ZAF")
			SZB->ZB_CLIENTE := cCliente
			SZB->ZB_LOJA    := cLoja
			SZB->ZB_TITULO  := "000010"
			SZB->ZB_DTHIST  := dDtaInc
			SZB->ZB_HORA    := cHorInc
			SZB->ZB_DTAGEN  := dDtAgen
			SZB->ZB_USER    := cUserName//__cUserId
			SZB->ZB_RESPRES := " "
			SZB->ZB_CONTATO := cCodCnt
			SZB->ZB_FORMA   := cForma
			SZB->ZB_HISTOR  := cHistor
			SZB->ZB_CELULA  := ""
			SZB->(MsUnLock())

			If ApMsgYesNo("Agendamento realizado, deseja iniciar orçamento a partir do cliente?","Confirmar agendamento")
				U_IVENA020(cCliente, cLoja,'', cId)
			EndIf
		Endif
	EndIf

	oBrwCab1:GoTo(1,.T.)
	oBrwCab1:Refresh(.T.)

	// Busco os totais da carteira
	aAdd(aTotais, {0, 0, 0, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0})
	MsgRun("Aguarde... Buscando dados para dashboard",,{|| FSTOTCAR(cGrCart, cAtend, @aTotais) } )

	oTot1:SetText( aTotais[1][1] )
	oTot2:SetText( aTotais[1][2] )
	oTot3:SetText( aTotais[1][3] )
	oTot4:SetText( aTotais[1][4] )
	oTot5:SetText( aTotais[1][5] )
	oTot6:SetText( aTotais[1][6] )
	oTot7:SetText( aTotais[1][7] )
	oTot8:SetText( aTotais[1][8] )
	oTot9:SetText( aTotais[1][9] )
	//oTotA:SetText( aTotais[1][10] )
	//oTotB:SetText( aTotais[1][11] )

	oTot1:refresh()
	oTot2:refresh()
	oTot3:refresh()
	oTot4:refresh()
	oTot5:refresh()
	oTot6:refresh()
	IF aTotais[1][6] < 0.00
		oTot6:nClrText := CLR_HRED
	Else
		oTot6:nClrText := CLR_HBLUE
	Endif
	oTot7:refresh()
	oTot8:refresh()
	oTot9:refresh()
	//oTotA:refresh()
	//oTotB:refresh()

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06NEW
Funcao de inclusao de um novo contato 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function VldTpAg(cTpAgen, cDescric)

	Local lRet := .T.

	cDescric := CriaVar("ZAD_DESC" , .F.)

	DbSelectArea("ZAD")
	DbSetOrder(1)  // ZAD_FILIAL + ZAD_COD
	MsSeek(xFilial("ZAD") + cTpAgen)
	If !Empty(cTpAgen)
		If Eof()
			MsgAlert("Tipo de agenda não cadastrado!")
			lRet := .F.
		Else
			cDescric := ZAD->ZAD_DESC
			lRet := .T.
		Endif
	Endif

Return lRet
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06NEW
Funcao de inclusao de um novo contato 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function VldCli(cProsp, cCliente, cLoja, cNomCli, cCart, cDesCart, cGrpCar, cDesGrCar, cEntZAF, cCliEnt, cLojEnt)

	Local nTamA1Cod := TamSX3("A1_COD")[1]
	Local nTamA1Loj := TamSX3("A1_LOJA")[1]
	Local cCli      := cCliente
	Local cLoj      := cLoja
	Local cReadVar  := ReadVar()

	cCart           := ""
	cGrpCar         := ""
	cDesCart        := ""
	cDesGrCar       := ""

	If lProspect
		cProsp := "1"
	Else
		cProsp := "2"
	Endif

	If "CCLIENTE"$cReadVar
		If Empty(cCliente)
			Return .T.
		Endif
		cCliente := PadL(AllTrim(cCli), nTamA1Cod, "0")
	ElseIf "CLOJA"$cReadVar
		If Empty(cLoja)
			Return .T.
		Endif
		cLoja    := PadL(AllTrim(cLoj), nTamA1Loj, "0")
	Endif

	If !lprospect
		DbSelectArea("SA1")
		DbSetOrder(1)  // A1_FILIAL + A1_COD + A1_LOJA
		If MsSeek(xFilial("SA1") + cCliente + AllTrim(cLoja))
			cLoja     := SA1->A1_LOJA
			cNomCli   := SA1->A1_NOME
			cCliEnt   := SA1->A1_COD
			cLojEnt   := SA1->A1_LOJA
		Else
			MsgAlert("Cliente não cadastrado!")
			Return .F.
		Endif

		If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
			//--Se é vendendor valida se cliente pertence a sua carteira
			SA3->(DbSetOrder(07))
			If SA3->(DbSeek(xFilial("SA3") + __cUserID ))
				//If !(SA1->A1_VEND $ SA3->A3_COD+'|'+SA3->A3_XVENDSU) 
				If !(SA1->A1_VEND $ SA3->A3_COD+'|'+SA3->A3_SUPER+'|'+SA3->A3_GEREN) 
					MsgAlert("Cliente não pertence a carteira do vendedor!!")
					Return(.F.)
				EndIf
			EndIf
		Endif
	Else
		DbSelectArea("SUS")
		DbSetOrder(1)  // US_FILIAL + US_COD + US_LOJA
		If MsSeek(xFilial("SUS") + cCliente + AllTrim(cLoja))
			cLoja     := SUS->US_LOJA
			cNomCli   := SUS->US_NOME
			cCliEnt   := SUS->US_COD
			cLojEnt   := SUS->US_LOJA
		Else
			MsgAlert("Prospect não cadastrado!")
			Return .F.
		Endif
	Endif

	If "CLOJA"$cReadVar
		If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
			//--Se é vendendor valida se cliente pertence a sua carteira
			SA3->(DbSetOrder(07))
			If SA3->(DbSeek(xFilial("SA3") + __cUserID ))
				//If !(SA1->A1_VEND $ SA3->A3_COD+'|'+SA3->A3_XVENDSU)
				If !(SA1->A1_VEND $ SA3->A3_COD+'|'+SA3->A3_SUPER+'|'+SA3->A3_GEREN)
					MsgAlert("Cliente não pertence a carteira do vendedor!!")
					Return(.F.)
				EndIf
			EndIf
		Endif	
	EndIf

Return .T.

Static Function ValHist(cTpAgen, dDtAgen, cCliente, cLoja, cCodCnt, cHistor, cTipo)
	****************************************************************************
	Local lRet := .T.

	IF (Empty(cCliente) .or. Empty(cLoja))
		Msgstop("Cliente/loja não informados. Confirmação não permitida.")
		lRet := .F.
	ElseIF Empty(dDtAgen)
		Msgstop("Data do agendamento em branco. Confirmação não permitida.")
		lRet := .F.
	ElseIf Empty(cTpAgen)
		Msgstop("Tipo de agenda não informado. Confirmação não permitida.")
		lRet := .F.
	//ElseIf Empty(cCodCnt)
	//	Msgstop("Contato não informado. Confirmação não permitida.")
	//	lRet := .F.
	ElseIf Empty(cHistor)
		Msgstop("Histórico não informado. Confirmação não permitida.")
		lRet := .F.
	ElseIf cTipo == 'N'
		If (FVldAgen(cCliente, cLoja)) 
			Msgstop("Já existe um agendamento em aberto para esse cliente.")
			lRet := .F.
		EndIf	
	Endif
	
	
Return lRet

Static Function AjustaSX1()
***************************
	Local aRegs   := {}
	Local i,j,x

	dbSelectArea("SX1")
	dbSetOrder(1)

	cPerg := PADR(cPerg,10)

	AADD(aRegs,{cPerg,"01","Dias agenda futura    ?","","","mv_ch1","N",02,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Else
			For x:=1 to len(aRegs[i])
				If x<=fcount() .and. aRegs[i,x]<>&(fieldname(x))
					If !(alltrim(str(x))$'10;17;22;27;32;37')
						RecLock("SX1",.f.)
						FieldPut(x,aRegs[i,x])
						MsUnLock()
					Endif
				Endif
			Next
		Endif
	Next
	i:=len(aRegs)+1
	While dbSeek(cPerg+strzero(i,2))
		RecLock("SX1",.f.)
		DbDelete()
		MsUnLock()
		i++
	End

Return( Nil )

/*Static Function OrdenaBrowse(oBrwCab1, cOp, oTelSelct)
	
	Local nColuna  := oBrwCab1:ColPos()
	local nIndice  := 0
	Local cAlias   := oBrwCab1:Alias()
	Local aField   := {}
	Local cIndAnt  := cOrdBrw
	Local cIndAge1  := ""
	Local cIndAge2	:= ""
	Local cIndAge3	:= ""
	Local cIndAge4	:= ""
	Local cIndAge5	:= ""
	Local cIndAge6	:= ""	
	Local cIndAge7	:= ""

	Static nclick  := 0

	Default cOp := ""

	dbSelectArea(cAlias)
	aField := Dbstruct()

	For nIndice := 1 to len(aField)

		If nIndice = nColuna
			cOrdBrw := CriaTrab(Nil,.F.)
			cChave  := aField[nIndice][1]

			//If (nclick == nColuna)
				If aField[nIndice,2] == "D"
					cChave := 'Descend(dTos('+ cChave + '))'
				ElseIf aField[nIndice,2] == "N"
					cChave := 'Descend(Strzero('+ cChave + ','+AllTrim(Str(aField[nIndice][3],2))+','+AllTrim(Str(aField[nIndice][4],2))+'))'
				Else
					cChave := 'Descend('+ cChave + ')'
				Endif
				nclick := 0
			//Else
			//	nclick := nColuna
			//Endif
			If aField[nIndice,2] <> "L" 
				//cChave := 'Descend(dTos('+ cChave + '))'
				IndRegua(cAlias, cOrdBrw, cChave,,, "Ordenando coluna")
				oBrwCab1:GoTop (.T. )
				oBrwCab1:FwBrowse():Refresh()
			Endif
		Endif
	Next nIndice

	FErase(cIndAnt + OrdBagExt())

	//--Recria indices - Nesse momento os indices eram perdidos
	If cOp == 'G'
		cIndAge1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
		cIndAge2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
		cIndAge3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
		cIndAge4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
		cIndAge5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
		cIndAge6 := Substr(CriaTrab(NIL,.F.),1,7)+"6"
		cIndAge7 := Substr(CriaTrab(NIL,.F.),1,7)+"7"
	Else
		cIndAge1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
		cIndAge2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
		cIndAge3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
		cIndAge4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
		cIndAge5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
		cIndAge6 := Substr(CriaTrab(NIL,.F.),1,7)+"6"
	EndIf

	If cOp == 'G'
		IndRegua(cAlias, cIndAge1, "CLIENTE",,, "Criando indice por Cliente...")
		IndRegua(cAlias, cIndAge2, "NUMORC",,, "Criando indice por orçamento...")	
		IndRegua(cAlias, cIndAge3, "CGC_CPF",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge4, "NOME",,, "Criando indice por NOME...")
		IndRegua(cAlias, cIndAge5, "ID",,, "Criando indice por ID...")
		IndRegua(cAlias, cIndAge6, "COLIGADA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge7, "NOME_COLIG",,, "Criando indice por NOME...")
	Else
		IndRegua(cAlias, cIndAge1, "CLIENTE",,, "Criando indice por Cliente...")
		IndRegua(cAlias, cIndAge2, "CGC_CPF",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge3, "NOME",,, "Criando indice por NOME...")
		IndRegua(cAlias, cIndAge4, "COLIGADA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge5, "NOME_COLIG",,, "Criando indice por NOME...")
		IndRegua(cAlias, cIndAge6, "DTAGEN",,, "Criando indice por DATA...")
	EndIf

	If cOp == 'G'
		DbSetIndex(cIndAge1+OrdBagExt())
		DbSetIndex(cIndAge2+OrdBagExt())
		DbSetIndex(cIndAge3+OrdBagExt())
		DbSetIndex(cIndAge4+OrdBagExt())
		DbSetIndex(cIndAge5+OrdBagExt())
		DbSetIndex(cIndAge6+OrdBagExt())
		DbSetIndex(cIndAge7+OrdBagExt())
	Else 
		DbSetIndex(cIndAge1+OrdBagExt())
		DbSetIndex(cIndAge2+OrdBagExt())
		DbSetIndex(cIndAge3+OrdBagExt())
		DbSetIndex(cIndAge4+OrdBagExt())
		DbSetIndex(cIndAge5+OrdBagExt())
		DbSetIndex(cIndAge6+OrdBagExt())
	EndIf

	//IndRegua(cAlias, cOrdBrw, cChave,,, "Ordenando coluna")
	//oBrwCab1:GoTop (.T. )
	//oBrwCab1:FwBrowse():Refresh()

Return*/

/*Static Function OrdenaBrowse(oBrw)
    Local  nColuna	:= oBrw:ColPos()
	local  nIndice	:= 0
	Local  cAlias	:= oBrw:Alias()
	Local  aField	:= {}
	Static nclick	:= 0
	dbSelectArea(cAlias)
	aField	:= Dbstruct()

	For nIndice := 1 to len(aField)
		if nIndice = nColuna
			cArqInd	:= CriaTrab(Nil,.F.)
			cChave	:= aField[nIndice][1]
			If (nclick == nColuna)
				If aField[nIndice,2] == "D"
					cChave := 'Descend(dTos('+ cChave + '))'
				ElseIf aField[nIndice,2] == "N"
					cChave := 'Descend(Strzero('+ cChave + ','+AllTrim(Str(aField[nIndice][3],2))+','+AllTrim(Str(aField[nIndice][4],2))+'))'
				Else
					cChave := 'Descend('+ cChave + ')'
				Endif
				nclick := 0
			Else
				nclick := nColuna
			Endif
			IndRegua(cAlias,cArqInd,cChave,,,"Ordenando Registros")
			#IFNDEF TOP
			DbSetIndex(cArqInd+OrdBagExt())
			#ENDIF
			oBrw:Refresh()
			oBrw:GoColumn(nColuna)
		Endif
	Next nIndice
Return*/
Static Function OrdenaBrowse(oBrw )
    //A Classe fwTemporaryTable não preve a criação de indices decrescente
    Local  nColuna  := oBrw:ColPos()
    local  nIndice  := 0
    Local  cAlias   := oBrw:Alias()
    Local  aField   := {}
    dbSelectArea(cAlias)
    aField  := Dbstruct()

    For nIndice := 1 to len(aField)
        If nIndice = nColuna
           (cAlias)->(DbSetOrder(nIndice))
		   //OrdDescend(nIndice,IndexKey(IndexOrd()), .T.)
		   ORDDESCEND()
           //oBrw:Refresh()
           //oBrw:GoColumn(nColuna)
           Exit
        Endif
    Next nIndice
Return

User Function AgeContatos(cEntZAF, cCliEnt, cLojEnt)
	
	Local oLbx							 					// Listbox com os nomes dos contatos
	Local aCont		:= {}									// Array com os contatos
	Local cDFuncao	:= CRIAVAR("U5_FUNCAO",.F.)		    	// Funcao do contato na empresa
	Local cEntCod	:= ""									// Ccdigo da entidade
	Local cEntLoja	:= ""									// Loja da entidade
	Local cDesc		:= ""									// Descricao da entidade
	Local nOpcao	:= 0									// Opcao
	Local nContato	:= 0									// Posicao do contato dentro do array na selecao
	Local oDlg												// Tela
	Local lRet		:= .F.									// Retorno da tela

	cEntCod		:= cCliEnt
	cEntLoja	:= cLojEnt

	If cEntZAF == "SUS"
		cDesc    := Posicione( "SUS",1, xFilial("SUS") + cCliEnt + cLojEnt, "US_NREDUZ" )
	Else
		cDesc    := Posicione( "SA1",1, xFilial("SA1") + cCliEnt + cLojEnt, "A1_NREDUZ" )
	Endif

	If Empty(cEntCod)
		Help(" ",1,"SEM CLIENT")
		Return(lRet)
	Endif

	DbSelectArea("AC8")
	DbSetOrder(2)  //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
	If DbSeek(xFilial("AC8") + cEntZAF + xFilial(cEntZAF) + cCliEnt + cLojEnt)

		While (!Eof())                                   .AND.;
		(AC8->AC8_FILIAL == xFilial("AC8"))        .AND.;
		(AC8->AC8_ENTIDA == cEntZAF)               .AND.;
		(AC8->AC8_FILENT == xFilial(cEntZAF))      .AND.;
		(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliEnt + cLojEnt))

			DbSelectArea("SU5")
			DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
			If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)
				cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

				Aadd(aCont, {SU5->U5_CODCONT,;		//Codigo
				SU5->U5_CONTAT,;		//Nome
				cDFuncao,;				//Funcao
				SU5->U5_FONE,;			//Telefone
				SU5->U5_EMAIL,;		//E-Mail
				SU5->U5_OBS;			//Observacao
				} )
			Else
				Aadd(aCont,{"","","","","",""})
			Endif
			DbSelectArea("AC8")
			DbSkip()
		End
	Else
		If AgeIncCt(@oLbx, @aCont, cEntZAF, cEntCod, cEntLoja, cDesc) == 3 // Cancelou a Inclusao
			Return(lRet)
		Else
			lRet := .T.
			Return(lRet)
		Endif
	Endif

	// Mostra dados dos Contatos
	DEFINE MSDIALOG oDlg FROM  48,171 TO 230,800 TITLE "Cadastro de contatos" + " - " + cDesc PIXEL

	@ 03,02 TO 73,310 LABEL "Cadastro de contatos" + ":" OF oDlg  PIXEL

	@ 10,05	LISTBOX oLbx FIELDS ;
	HEADER	;
	"Código",;
	"Nome",;
	"Função",;
	"Telefone",;
	"E-Mail",;
	"Observação";	
	SIZE 303,60  NOSCROLL OF oDlg PIXEL ;
	ON DBLCLICK( nOpcao:= 1,nContato := oLbx:nAt,oDlg:End() )

	oLbx:SetArray(aCont)
	oLbx:bLine:={ || {	aCont[oLbx:nAt,1],;		// Codigo
	aCont[oLbx:nAt,2],;		// Nome
	aCont[oLbx:nAt,3],;		// Funcao
	aCont[oLbx:nAt,4],;		// Telefone
	aCont[oLbx:nAt,5],;		// E-Mail
	aCont[oLbx:nAt,6];		// Observacao
	}}

	DEFINE SBUTTON FROM 74,162 TYPE 4	ENABLE OF oDlg ACTION AgeIncCt(@oLbx, @aCont, cEntZAF, cEntCod, cEntLoja, cDesc)
	DEFINE SBUTTON FROM 74,192 TYPE 11	ENABLE OF oDlg ACTION AgeAltCt(@oLbx, 1,      @aCont,  cEntCod, cEntLoja)
	DEFINE SBUTTON FROM 74,222 TYPE 15	ENABLE OF oDlg ACTION AgeVisCt(oLbx,  1,      @aCont,  cEntCod, cEntLoja)

	DEFINE SBUTTON FROM 74,252 TYPE 1	ENABLE OF oDlg ACTION (nOpcao := 1, nContato := oLbx:nAt, oDlg:End())
	DEFINE SBUTTON FROM 74,282 TYPE 2	ENABLE OF oDlg ACTION (nOpcao := 0, oDlg:End())

	ACTIVATE MSDIALOG oDlg CENTERED

	DbSelectArea("SU5")
	DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
	If (nOpcao == 1)
		lRet := .T.
		DbSeek(xFilial("SU5") + aCont[nContato,1])
	Endif

Return(lRet)

Static Function AgeIncCt(oLbx, aCont, cEntZAF, cCliente, cLoja, cDesc)
	************************************************************************
	Local aArea   		:= GetArea()							// Salva a area atual
	Local nOpca     	:= 0									// Opcao de OK ou CANCELA
	Local cDFuncao  	:= CRIAVAR("U5_FUNCAO",.F.)			    // Cargo da funcao do contato
	Local cAlias    	:= "SA1"								// Alias
	Local lIncluiAnt	:= INCLUI                          		// Guarda o conteudo da variavel para restaurar apos a inclusao do contato

	Private cCadastro 	:= "Inclusão de contatos"

	INCLUI := .T.

	DbSelectArea("SU5")
	nOpcA := A70INCLUI("SU5",0,3)

	INCLUI:= lIncluiAnt

	If (nOpca == 1)
		DbSelectArea("AC8")
		RecLock("AC8",.T.)
		REPLACE AC8_FILIAL With xFilial("AC8")
		REPLACE AC8_FILENT With xFilial(cEntZAF)
		REPLACE AC8_ENTIDA With cEntZAF
		REPLACE AC8_CODENT With cCliente + cLoja
		REPLACE AC8_CODCON With SU5->U5_CODCONT
		MsUnLock()
		DbCommit()
	Endif

	// Se houve inclusao do registro atualizo o listbox de contatos
	If nOpcA == 1

		aCont := {}

		DbSelectArea("AC8")
		DbSetOrder(2)  //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
		If DbSeek(xFilial("AC8") + cAlias + xFilial(cAlias) + cCliente + cLoja,.T.)

			While (!Eof()) 							   .AND.;
			(AC8->AC8_FILIAL == xFilial("AC8"))  .AND.;
			(AC8->AC8_ENTIDA == cAlias) 	  	   .AND.;
			(AC8->AC8_FILENT == xFilial(cAlias)) .AND.;
			(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

				DbSelectArea("SU5")
				DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
				If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)
					cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")

					Aadd(aCont,{SU5->U5_CODCONT,;		//Codigo
					SU5->U5_CONTAT,;		//Nome
					cDFuncao,;				//Funcao
					SU5->U5_FONE,;			//Telefone
					SU5->U5_EMAIL,;			//E-Mail
					SU5->U5_OBS} )			//Observacao
				Else
					Aadd(aCont,{"","","","","",""})
				Endif

				DbSelectArea("AC8")
				DbSkip()
			End
		Endif

		If ValType(oLbx) == "O"
			oLbx:SetArray(aCont)
			oLbx:nAt:= Len(aCont)
			oLbx:bLine:={||{aCont[oLbx:nAt,1],;  //Codigo
			aCont[oLbx:nAt,2],;  //Nome
			aCont[oLbx:nAt,3],;	 //Fucao
			aCont[oLbx:nAt,4],;	 //Telefone
			aCont[oLbx:nAt,5],;	 //E-Mail
			aCont[oLbx:nAt,6] }} //Observacao
			oLbx:Refresh()
		EndIf

	Endif

	RestArea(aArea)
Return(nOpcA)

Static Function AgeAltCt(oLbx, nPos, aCont, cCliente, cLoja)
	************************************************************
	Local aArea		  := GetArea()						// Salva a area atual
	Local cCod	      := ""								// Codigo do contato
	Local cDFuncao    := ""								// Cargo do contato
	Local cAlias	  := "SA1"							// Alias
	Local nOpcA       := 0								// Opcao de retorno OK ou CANCELA
	Local lRet		  := .T.							// Retorno da funcao

	Private cCadastro := "Alteração de contatos"
	Private lRefresh  := .T.

	// A ocorrencia 82 (ACS), verifica se o usuario poderá ou nao alterar cadastros
	If !ChkPsw(82)
		HELP(" ",1,"TMKACECAD")
		lRet := .F.
		Return(lRet)
	Endif

	cCod := Eval(oLbx:bLine)[nPos]

	DbSelectArea("SU5")
	DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
	If DbSeek(xFilial("SU5")+ cCod)

		BEGIN TRANSACTION

			aRotina:={}
			aRotina:= MenuDef()

			If lRet
				nOpcA:=A70ALTERA("SU5",RECNO(),4)
			Endif

		END TRANSACTION

		// Se houve alteracao do registro atualizo o listbox de contatos
		If nOpcA == 1
			lRet  := .T.
			aCont := {}
			DbSelectArea("AC8")
			DbSetOrder(2)  //AC8_FILIAL+AC8_ENTIDA+AC8_FILENT+AC8_CODENT+AC8_CODCON
			If DbSeek(xFilial("AC8") + cAlias + xFilial(cAlias) + cCliente + cLoja,.T.)
				While (!Eof()) 							  	.AND.;
				(AC8->AC8_FILIAL == xFilial("AC8")) 	.AND.;
				(AC8->AC8_ENTIDA == cAlias) 		  	.AND.;
				(AC8->AC8_FILENT == xFilial(cAlias))	.AND.;
				(AllTrim(AC8->AC8_CODENT) == AllTrim(cCliente + cLoja))

					DbSelectArea("SU5")
					DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
					If DbSeek(xFilial("SU5") + AC8->AC8_CODCON)
						cDFuncao := Posicione("SUM",1,xFilial("SUM")+SU5->U5_FUNCAO,"UM_DESC")
						Aadd(aCont,{SU5->U5_CODCONT,;		//Codigo
						SU5->U5_CONTAT,;		//Nome
						cDFuncao,;				//Funcao
						SU5->U5_FONE,;			//Telefone
						SU5->U5_EMAIL,;			//E-Mail
						SU5->U5_OBS} )			//Observacao
					Else
						Aadd(aCont,{"","","","","",""})
					Endif

					DbSelectArea("AC8")
					DbSkip()
				End
			Endif

			oLbx:SetArray(aCont)
			oLbx:bLine:={||{aCont[oLbx:nAt,1],;  //Codigo
			aCont[oLbx:nAt,2],;  //Nome
			aCont[oLbx:nAt,3],;	 //Funcao
			aCont[oLbx:nAt,4],;	 //Telefone
			aCont[oLbx:nAt,5],;	 //E-Mail
			aCont[oLbx:nAt,6] }} //Observacao
			oLbx:Refresh()

		Endif
	Endif

	RestArea(aArea)

Return(lRet)

Static Function AgeVisCt(oLbx, nPos, aCont, cCliente, cLoja)
	************************************************************
	Local cAliasOld   := Alias()
	Local cCod		  := ""

	Private cCadastro := "Visualização de contatos"

	cCod := Eval(oLbx:bLine)[nPos]

	DbSelectArea("SU5")
	DbSetOrder(1)  // U5_FILIAL + U5_CODCONT
	If DbSeek(xFilial("SU5")+ cCod)
		// Envia para processamento dos Gets
		A70Visual("SU5",RECNO(), 2)
	Endif

	DbSelectArea(cAliasOld)

Return(.T.)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} VldFin
Funcao valida finalizacao de agenda 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function VldFin(lNewAg)
	
	Local lCont := .F.
	Local cGrpAprv := GetMv("FS_GRPGPED",,"000000")

	If ApMsgYesNo("Confirma a finalização dos agendamentos selecionados?","Finaliza agendamentos")

		//criar nova agenda
		//aquicrele
		If MsgYesNo("Deseja criar nova agenda?")
			lCont := .T.
		else
			aDadosUsu := U_FSLogin("<b>Sera necessário solicitar aprovação do gerente para prosseguir.</b>", .F.)
			If(aDadosUsu != Nil)//Achou o usuário
				If (aDadosUsu[1] == .F. .or. !(aDadosUsu[3]$ cGrpAprv))  //Se o usuário for valido ainda dever?estar dentro do grupo de aprovadores
					Alert("O usuario invalido ou nao pertence ao grupo de gerentes!!!")
				Else
					lNewAg := .F.
					lCont := .T.
				EndIf	
			EndIF
		Endif

	Endif

Return(lCont)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSTOTCAR
Funcao busca totais de carteira 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSTOTCAR(cGrCart, cCarteiras, aTotais)

	Local cQry      := ""
	Local nMetaDia  := 0.00
	Local nDutil    := 0
	Local dData     := cTod("//")
	Local dDtMeta   := dDataBase
	Local nDias     := 0
	Local nVndDia   := 0.00

	Private cTMPA := GetNextAlias()

	// Busco total de dias uteis no mes corrente para calculo da meta diária
	nDutil := DateWorkDay( dDtInicial, dDtFinal, .F., .F., .F.)

	// Total de Clientes na Carteira
	cQry :="SELECT COUNT(*) TOTCLICAR "+ CRLF 
	cQry +="FROM "+RetSqlName("SA1")+" SA1 "+ CRLF
	
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') ) "+ CRLF	
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') ) "+ CRLF	
			cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif	

	cQry += "WHERE SA1.D_E_L_E_T_ = '' "+ CRLF
	cQry += "AND  SA1.A1_MSBLQL <> '1' "+ CRLF

	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

	TCQuery cQry new Alias (cTMPA)
	TCSetField(cTMPA, "TOTCLICAR", "N", 06, 0)
	
	DbSelectArea(cTMPA)
	If (cTMPA)->(!EOF())
		aTotais[1][1] := (cTMPA)->TOTCLICAR
	Endif

	//--Total de Clientes que compraram
	cQry := "SELECT COUNT(*) TOTCLICOM "+ CRLF
	cQry += "FROM "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) "+ CRLF

	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif

	cQry += "WHERE SA1.D_E_L_E_T_ = ' '  "+ CRLF
	cQry += "AND EXISTS ( "+ CRLF
	cQry += "	SELECT TOP 1 NULL "+ CRLF
	cQry += "	FROM "+RetSqlName("SC5")+" SC5 WITH (NOLOCK) "+ CRLF
	cQry += "	WHERE SC5.D_E_L_E_T_ = '' "+ CRLF
	cQry += "	AND SC5.C5_FILIAL  IN (" + cFiliais + ") " + CRLF
	cQry += "	AND SC5.C5_CLIENTE = SA1.A1_COD "+ CRLF
	cQry += "	AND SC5.C5_LOJACLI = SA1.A1_LOJA "+ CRLF
	cQry += "	AND SC5.C5_EMISSAO BETWEEN '"+dTos(dDtInicial)+"' AND '"+dTos(dDtFinal)+"' "+ CRLF
	cQry += "	AND SC5.C5_TIPO    NOT IN ('D', 'B')  "+ CRLF
	cQry += "	AND SC5.C5_NOTA    NOT LIKE 'XXX%'  "+ CRLF
	cQry += ") "+ CRLF

	//MemoWrite("c:\temp\BZLCA070B.SQL",cQry)

	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

	TCQuery cQry new Alias (cTMPA)
	TCSetField(cTMPA, "TOTCLICOM", "N", 06, 0)

	DbSelectArea(cTMPA)
	If (cTMPA)->(!EOF())
		aTotais[1][2] := (cTMPA)->TOTCLICOM
	EndIf

	// Positivacao = Número de clientes que compraram no mês /  total de clientes
	aTotais[1][3] := (aTotais[1][2] / aTotais[1][1]) * 100
	
	cQry := "SELECT SUM(CT_VALOR) METAMES "+ CRLF
	cQry += "FROM "+RetSqlName("SCT")+" SCT WITH (NOLOCK) "+ CRLF
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQry += "AND SCT.CT_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQry += "AND SCT.CT_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQry += "AND SCT.CT_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	endif
	cQry += "WHERE SCT.CT_FILIAL = '"+xFilial("SCT")+"' "+ CRLF
	cQry += "AND   SCT.D_E_L_E_T_ = ' ' "+ CRLF
	cQry += "AND   SCT.CT_DATA Like '%"+Left(Dtos(dDatabase),6)+"%' "+ CRLF

	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

	TCQuery cQry new Alias (cTMPA)
	TCSetField(cTMPA, "TOTCLICOM", "N", 12, 2)

	DbSelectArea(cTMPA)
	If (cTMPA)->(!EOF())
		aTotais[1][4] := (cTMPA)->METAMES
	Endif

	// Total de vendas acumulada
	
	cQry := "  SELECT SUM(D2_VALBRUT-D2_ICMSRET) VLRACUMES,
	cQry += "     SUM(CASE WHEN SF2.F2_EMISSAO = '"+dTos(dDataBase)+"' AND SF2.F2_DOC NOT LIKE 'XXX%' THEN SD2.D2_VALBRUT-SD2.D2_ICMSRET ELSE 0 END) VNDDIA 
	cQry += "FROM "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) 
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		Else
			cQry += "LEFT JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' )"+ CRLF
		EndIf
	endif
	cQry += "INNER JOIN "+RetSqlName("SF2")+" SF2 WITH (NOLOCK) ON SF2.D_E_L_E_T_ = '' "
   	cQry += "                   AND SF2.F2_FILIAL  IN (" + cFiliais + ") " + CRLF
    	cQry += "               AND SF2.F2_CLIENTE = SA1.A1_COD  "
     	cQry += "               AND SF2.F2_LOJA = SA1.A1_LOJA 
     	//cQry += "               AND SF2.F2_EMISSAO BETWEEN '"+dTos(dDtInicial)+"' AND '"+dTos(dDtFinal)+"' " + CRLF
     	cQry += "               AND LEFT(SF2.F2_EMISSAO,6) LIKE '%"+Left(Dtos(dDatabase),6)+"%'" + CRLF
      	cQry += "               AND SF2.F2_TIPO    NOT IN ('D', 'B') "
		cQry += "				INNER JOIN "+RetSqlName("SD2")+" SD2 ON D2_DOC = F2_DOC    "
			cQry += "			AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE "
			cQry += "			AND F2_LOJA = D2_LOJA AND D2_FILIAL = F2_FILIAL   "
			cQry += "			AND SD2.D_E_L_E_T_=  ''         "
			cQry += "			INNER JOIN "+RetSqlName("SF4")+" SF4 ON SF4.F4_FILIAL = ''  "
				cQry += "		AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_=''   "
				cQry += "		AND SF4.F4_DUPLIC = 'S' "
         	cQry += "           WHERE SA1.D_E_L_E_T_ = ''      "
	
	/*
	cQry := "SELECT SUM(SC5.C5_ZVALTOT) VLRACUMES, " + CRLF
	cQry += "       SUM(CASE WHEN SC5.C5_EMISSAO = '"+dTos(dDataBase)+"' AND SC5.C5_NOTA NOT LIKE 'XXX%' THEN SC5.C5_ZVALTOT ELSE 0 END) VNDDIA " + CRLF
	cQry += "FROM "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) " + CRLF
	//--Verifica se usuario é vendedor
	SA3->(dbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+__cUserID))
		cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		cQry += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
	EndIf
	cQry += "INNER JOIN "+RetSqlName("SC5")+" SC5 WITH (NOLOCK) ON SC5.D_E_L_E_T_ = '' " + CRLF
	cQry += "                     AND SC5.C5_FILIAL  IN (" + cFiliais + ") " + CRLF
	cQry += "                     AND SC5.C5_CLIENTE = SA1.A1_COD " + CRLF
	cQry += "                     AND SC5.C5_LOJACLI = SA1.A1_LOJA " + CRLF
	cQry += "                     AND SC5.C5_EMISSAO BETWEEN '"+dTos(dDtInicial)+"' AND '"+dTos(dDtFinal)+"' " + CRLF
	cQry += "                     AND SC5.C5_TIPO    NOT IN ('D', 'B') " + CRLF
	cQry += "                     AND SC5.C5_NOTA    NOT LIKE 'XXX%' " + CRLF
	cQry += "WHERE SA1.D_E_L_E_T_ = '' "
   
*/
	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

	TCQuery cQry new Alias (cTMPA)
	TCSetField(cTMPA, "TOTCLICOM", "N", 12, 2)
	TCSetField(cTMPA, "VNDDIA",    "N", 12, 2)

	DbSelectArea(cTMPA)
	If (cTMPA)->(!EOF())
		aTotais[1][5] := (cTMPA)->VLRACUMES
		nVndDia       := (cTMPA)->VNDDIA
	Endif

	// Cálculo da meta diária
	nDias := 0
	Do While dDtMeta <= LastDate(dDataBase - 1)

		dData := DataValida(dDtMeta, .T.)

		If dData == dDtMeta
			If Dow(dDtMeta) > 1 .And. Dow(dDtMeta) <= 6
				nDias += 1
			Endif
		EndIf

		dDtMeta := DaySum(dDtMeta, 1)
		dDtMeta := DataValida(dDtMeta, .T.)
	EndDo

	nMetaDia      := Round(((aTotais[1][4] - aTotais[1][5]) / nDias), 2)
	If nMetaDia < 0    
  		aTotais[1][6]:= 0   
  	Else
		aTotais[1][6] := (nMetaDia - nVndDia) * -1
    EndIf
    
	// Total de agendas
	cQry := "SELECT SUM(CASE WHEN ZAF.ZAF_DTAGEN < '"+dTos(dDataBase)+"' THEN 1 ELSE 0 END) as 'AGATR', "+ CRLF
	cQry += "       SUM(CASE WHEN ZAF.ZAF_DTAGEN = '"+dTos(dDataBase)+"' THEN 1 ELSE 0 END) as 'AGDIA', "+ CRLF
	cQry += "       SUM(CASE WHEN ZAF.ZAF_DTAGEN > '"+dTos(dDataBase)+"' THEN 1 ELSE 0 END) as 'AGFUT', "+ CRLF
	cQry += "		SUM(CASE WHEN ZAF.ZAF_NUMORC <> '' THEN 1 ELSE 0 END) as 'AGORC', "
	cQry += "       SUM(CASE WHEN SUA.UA_NUMSC5 <> '' THEN 1 ELSE 0 END) AS 'TOTPED' " 
	cQry += "FROM "+RetSqlName("ZAF")+" ZAF WITH (NOLOCK) "+ CRLF

	cQry += "INNER JOIN " + RetSqlName("SA1") + " A1 WITH (NOLOCK)" + CRLF
	cQry += "ON A1.D_E_L_E_T_ = '' "+ CRLF
	cQry += "AND A1.A1_FILIAL = '"+xFilial('SA1')+"' "+ CRLF
	cQry += "AND A1.A1_COD = ZAF.ZAF_CLIENT "+ CRLF
	cQry += "AND A1.A1_LOJA = ZAF.ZAF_LOJA "+ CRLF
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQry += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQry += "AND A1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQry += "AND A1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQry += "AND A1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif
	cQry += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
	cQry += "ON SUA.D_E_L_E_T_ = '' "+ CRLF
	cQry += "AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL "+ CRLF
	cQry += "AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
	cQry += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT "+ CRLF
	cQry += "AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF
	//cQry += "AND   SUA.UA_DOC = ' ' "+ CRLF
	cQry += "WHERE ZAF.D_E_L_E_T_ = '' " + CRLF
	cQry += "AND   ZAF.ZAF_FILIAL IN (" + cFiliais + ") " + CRLF
	cQry += "AND   ZAF.ZAF_ATEND  NOT IN ('1') "+ CRLF
	//cQry += "AND   (ZAF.ZAF_NUMORC = '' OR (SUA.UA_NUMSC5 = '' AND SUA.UA_CODCANC = '')) "+ CRLF

	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

	TCQuery cQry new Alias (cTMPA)
	TCSetField(cTMPA, "TOTCART", "N", 06, 0)

	DbSelectArea(cTMPA)
	If (cTMPA)->(!EOF())
		aTotais[1][7] := (cTMPA)->AGATR
		aTotais[1][8] := (cTMPA)->AGDIA
		aTotais[1][9] := (cTMPA)->AGFUT
		aTotais[1][10]:= (cTMPA)->AGORC
		aTotais[1][11]:= (cTMPA)->TOTPED
	Endif

	If Select( cTMPA ) > 0; dbSelectArea( cTMPA ); dbCloseArea(); EndIf

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06HIS
Apresenta consulta dos historicos de agendas do cliente 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06HIS(cCliente, cLoja)
	
	Local oSize, oHistor
	Local cQuery     := ""
	Local oBrowse    := Nil
	Local oColumn    := Nil
	Local oDlg       := Nil
	Local cArqTemp   := ""
	Local cCliNome   := ""
	Local aCoors     := FWGetDialogSize( oMainWnd )

	Private cOrdBrw  := ""

	Private cTRBHIS := GetNextAlias()
	Private cTMPH 	:= GetNextAlias()

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())

	// Cria arquivo de trabalho
	aArqTemp := {}
	AAdd(aArqTemp,{"Atend"     ,"C",01,0,})
	AAdd(aArqTemp,{"Filial"    ,"C",04,0,})
	AAdd(aArqTemp,{"Emissao"   ,"D",08,0,})
	AAdd(aArqTemp,{"Agenda"    ,"D",08,0,})
	AAdd(aArqTemp,{"NumOrc"    ,"C",06,0,})
	AAdd(aArqTemp,{"VlrOrc"    ,"N",12,2,})
	AAdd(aArqTemp,{"TpAgen"    ,"C",40,0,})
	AAdd(aArqTemp,{"NomCnt"    ,"C",20,0,})
	AAdd(aArqTemp,{"FonCnt"    ,"C",15,0,})
	AAdd(aArqTemp,{"EmlCnt"    ,"C",40,0,})
	AAdd(aArqTemp,{"Carteira"  ,"C",40,0,})
	AAdd(aArqTemp,{"GrpCart"   ,"C",40,0,})
	AAdd(aArqTemp,{"Hora"      ,"C",08,0,})
	AAdd(aArqTemp,{"DtaRet"    ,"D",08,0,})
	AAdd(aArqTemp,{"HorRet"    ,"C",08,0,})
	AAdd(aArqTemp,{"UsrRet"    ,"C",20,0,})
	AAdd(aArqTemp,{"Coligada"  ,"C",40,0,})
	AAdd(aArqTemp,{"Nome_Colig","C",40,0,})
	AAdd(aArqTemp,{"ID"        ,"C",10,0,})
	AAdd(aArqTemp,{"IDPAI"     ,"C",10,0,})


	//-- Cria Indice de Trabalho
	cArqTemp := CriaTrab(aArqTemp)

	//-- Criando Indice Temporario
	dbUseArea(.T.,__LOCALDRIVER,cArqTemp,cTRBHIS,.T.,.F.)

	cQuery := "SELECT ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,   ZAF.ZAF_DATINC, "
	cQuery += "       ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, SA1.A1_XCOLIG, SZ6.Z6_DESCRI, "
	cQuery += "       SA1.A1_TEL,     ZAF.ZAF_CONTAT, SU5.U5_CONTAT,  SU5.U5_FCOM1,   SU5.U5_EMAIL,   "
	cQuery += "       ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, "
	cQuery += "       CASE "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '1' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '2' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '3' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '4' "
	cQuery += "       END AS ATEND, ZAF.ZAF_ID, ZAF.ZAF_IDPAI, ZAF.ZAF_FILIAL "
	cQuery += "FROM "+RetSqlName("ZAF")+" ZAF WITH (NOLOCK) "
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
	cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "
	cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "
	cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif
	cQuery += "INNER JOIN "+RetSqlName("ZAD")+" ZAD WITH (NOLOCK) ON ZAD.ZAD_CODIGO = ZAF.ZAF_TPAGEN "
	cQuery += "                                    AND ZAD.D_E_L_E_T_ = ' ' "
	//cQuery += "INNER JOIN "+RetSqlName("ZAE")+" ZAE WITH (NOLOCK) ON ZAE.ZAE_FILIAL = '"+xFilial("ZAE")+"' "
	//cQuery += "                                    AND ZAE.ZAE_CODIGO = ZAF.ZAF_GRCART "
	//cQuery += "                                    AND ZAE.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT  JOIN "+RetSqlName("SU5")+" SU5 WITH (NOLOCK) ON SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "
	cQuery += "                                    AND SU5.U5_CODCONT = ZAF.ZAF_CONTAT "
	cQuery += "                                    AND SU5.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT  JOIN "+RetSqlName("SZ6")+" SZ6 WITH (NOLOCK) ON SZ6.Z6_FILIAL  = '"+xFilial("SZ6")+"' "+ CRLF
	cQuery += "                                    AND SZ6.Z6_CODIGO = SA1.A1_XCOLIG "+ CRLF
	cQuery += "                                    AND SZ6.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "WHERE ZAF.ZAF_CLIENT = '"+cCliente+"' "
	cQuery += "AND   ZAF.ZAF_LOJA    = '"+cLoja+"' "
	cQuery += "AND   ZAF.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY ZAF.ZAF_ATEND,  ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,  ZAF.ZAF_DATINC, "
	cQuery += "         ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, "
	cQuery += "         SA1.A1_TEL,     ZAF.ZAF_CONTAT, SU5.U5_CONTAT,  SU5.U5_FCOM1,   SU5.U5_EMAIL,    "
	cQuery += "         ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, ZAF.ZAF_ATEND, ZAF.ZAF_ID, "
	cQuery += "         ZAF.ZAF_IDPAI,  ZAF.ZAF_FILIAL, SA1.A1_XCOLIG,  SZ6.Z6_DESCRI "
	cQuery += "ORDER BY ZAF.ZAF_DTAGEN "

	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTMPH, .F., .T.)
	TcSetField(cTMPH,"ZAF_DATINC","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTAGEN","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTARET","D", 8,0)

	DbSelectArea(cTMPH)
	While (cTMPH)->(!Eof())

		DbselectArea(cTRBHIS)
		Reclock(cTRBHIS,.T.)

		(cTRBHIS)->ATEND      := (cTMPH)->ATEND
		(cTRBHIS)->FILIAL     := (cTMPH)->ZAF_FILIAL
		(cTRBHIS)->EMISSAO    := (cTMPH)->ZAF_DATINC
		(cTRBHIS)->AGENDA     := (cTMPH)->ZAF_DTAGEN
		(cTRBHIS)->TPAGEN     := (cTMPH)->ZAD_DESC
		(cTRBHIS)->NOMCNT     := (cTMPH)->U5_CONTAT
		(cTRBHIS)->FONCNT     := (cTMPH)->U5_FCOM1
		(cTRBHIS)->EMLCNT     := (cTMPH)->U5_EMAIL
		(cTRBHIS)->HORA       := (cTMPH)->ZAF_HORINC
		(cTRBHIS)->NUMORC     := (cTMPH)->ZAF_NUMORC
		(cTRBHIS)->VLRORC     := (cTMPH)->ZAF_VLRORC
		(cTRBHIS)->DTARET     := (cTMPH)->ZAF_DTARET
		(cTRBHIS)->HORRET     := (cTMPH)->ZAF_HORRET
		(cTRBHIS)->USRRET     := UsrRetName((cTMPH)->ZAF_USRRET)
		(cTRBHIS)->COLIGADA   := (cTMPH)->A1_XCOLIG
		(cTRBHIS)->NOME_COLIG := (cTMPH)->Z6_DESCRI
		(cTRBHIS)->ID         := (cTMPH)->ZAF_ID
		(cTRBHIS)->IDPAI      := (cTMPH)->ZAF_IDPAI
		Msunlock()

		cCliNome           := (cTMPH)->A1_NOME

		(cTMPH)->(DbSkip())
	EndDo

	DbSelectArea(cTRBHIS)

	//- Coordenadas da area total da Dialog
	oSize := FWDefSize():New(.T.)
	oSize:AddObject('DLG',100,100,.T.,.T.)
	oSize:SetWindowSize(aCoors)
	oSize:lProp 	:= .T.
	oSize:Process()

	DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .F.

	oLayer2 := FWLayer():New()

	oLayer2:Init(oDlg)
	oLayer2:addLine("TOP",34,.F.)
	oLayer2:addLine("BODY",60,.F.)
	oLayer2:addCollumn("COL_TOP",100,.f.,"TOP")
	oLayer2:addCollumn("COL_BODY",100,.f.,"BODY")

	oHistor := oLayer2:GetColPanel("COL_TOP","TOP")
	oHistor:FreeChildren()

	oHistor1 := oLayer2:GetColPanel("COL_BODY","BODY")
	oHistor1:FreeChildren()

	DEFINE FWFORMBROWSE oBrowse DATA TABLE ALIAS cTRBHIS DESCRIPTION "Históricos de agendamentos do cliente: "+cCliNome OF oHistor

	oBrowse:SetTemporary(.T.)
	oBrowse:bHeaderClick := {|| OrdenaBrowse(oBrowse) }
	oBrowse:SetdbFFilter(.F.)
	oBrowse:SetUseFilter(.F.)
	oBrowse:DisableDetails()
	oBrowse:DisableReport()
	oBrowse:DisableConfig()
	oBrowse:SetChange( {|| FSDETAGE((cTRBHIS)->FILIAL, cCliente, cLoja, (cTRBHIS)->EMISSAO, (cTRBHIS)->HORA, oHistor1, .T.)} )

	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="1" } COLOR "GREEN"   TITLE "Agenda em aberto"        OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="2" } COLOR "RED"     TITLE "Agenda atendido"         OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="3" } COLOR "YELLOW"  TITLE "Agenda futura em aberto" OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="4" } COLOR "ORANGE"  TITLE "Agenda futura atendido"  OF oBrowse
	oBrowse:aColumns[1]:cTitle := "Sts"

	ADD COLUMN oColumn DATA { || &(aArqTemp[02,1]) } TITLE "Filial"           SIZE aArqTemp[02,3] PICTURE PesqPict("ZAF","ZAF_FILIAL") TYPE aArqTemp[02,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[03,1]) } TITLE "Dt.emissao"       SIZE aArqTemp[03,3] PICTURE PesqPict("ZAF","ZAF_DATINC") TYPE aArqTemp[03,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[04,1]) } TITLE "Dt agendamento"   SIZE aArqTemp[04,3] PICTURE PesqPict("ZAF","ZAF_DTAGEN") TYPE aArqTemp[04,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[05,1]) } TITLE "Orç½amento"        SIZE aArqTemp[05,3] PICTURE PesqPict("ZAF","ZAF_NUMORC") TYPE aArqTemp[05,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[06,1]) } TITLE "Vlr.orçamento"    SIZE aArqTemp[06,3] PICTURE PesqPict("ZAF","ZAF_VLRORC") TYPE aArqTemp[06,2] ALIGN 2 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[07,1]) } TITLE "Tipo agendamento" SIZE aArqTemp[07,3] PICTURE PesqPict("ZAD","ZAD_DESC")   TYPE aArqTemp[07,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[08,1]) } TITLE "Nome do contato"  SIZE aArqTemp[08,3] PICTURE PesqPict("ZAF","U5_CONTAT")  TYPE aArqTemp[08,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[09,1]) } TITLE "Fone contato"     SIZE aArqTemp[09,3] PICTURE PesqPict("ZAF","U5_FCOM1")   TYPE aArqTemp[09,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[10,1]) } TITLE "E-Mail contato"   SIZE aArqTemp[10,3] PICTURE PesqPict("ZAF","U5_EMAIL")   TYPE aArqTemp[10,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[11,1]) } TITLE "Carteira"         SIZE aArqTemp[11,3] PICTURE PesqPict("SA3","ZA6_DESC")   TYPE aArqTemp[11,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[12,1]) } TITLE "Grupo carteira"   SIZE aArqTemp[12,3] PICTURE PesqPict("SA1","ZAE_DESC")   TYPE aArqTemp[12,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[11,1]) } TITLE "Hora"             SIZE aArqTemp[11,3] PICTURE PesqPict("ZAF","ZAF_HORINC") TYPE aArqTemp[11,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[12,1]) } TITLE "Data retorno"     SIZE aArqTemp[12,3] PICTURE PesqPict("ZAF","ZAF_DTARET") TYPE aArqTemp[12,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[13,1]) } TITLE "Hora retorno"     SIZE aArqTemp[13,3] PICTURE PesqPict("ZAF","ZAF_HORRET") TYPE aArqTemp[13,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[14,1]) } TITLE "Quem Retornou"    SIZE aArqTemp[14,3] PICTURE PesqPict("ZAF","ZAF_USRRET") TYPE aArqTemp[14,2] ALIGN 1 OF oBrowse
	
	ADD COLUMN oColumn DATA { || &(aArqTemp[15,1]) } TITLE "Coligada"         SIZE aArqTemp[15,3] PICTURE PesqPict("SA1","A1_XCOLIG")  TYPE aArqTemp[15,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[16,1]) } TITLE "Nome Coligada"    SIZE aArqTemp[16,3] PICTURE PesqPict("SZ6","Z6_DESCRI")  TYPE aArqTemp[16,2] ALIGN 1 OF oBrowse

	ADD COLUMN oColumn DATA { || &(aArqTemp[17,1]) } TITLE "ID"               SIZE aArqTemp[17,3] PICTURE PesqPict("ZAF","ZAF_ID")     TYPE aArqTemp[17,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[18,1]) } TITLE "Id Pai"           SIZE aArqTemp[18,3] PICTURE PesqPict("ZAF","ZAF_IDPAI")  TYPE aArqTemp[18,2] ALIGN 1 OF oBrowse

	ACTIVATE FWFORMBROWSE oBrowse

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,,,,, .F., .F., .F., .F., .F. ) centered

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())
	FErase(cArqTemp + GetDbExtension())

Return
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06PRX
Funcao busca proximo numero de agenda 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06PRX()
	************************
	Local cId      := GetSXENum("ZAF", "ZAF_ID")
	Local nSaveSX8 := GetSX8Len()

	dbSelectArea("ZAF")
	dbSetOrder(3)  // ZAF_FILIAL + ZAF_ID
	While .T.
		If !dbSeek(xFilial("ZAF") + cId, .F.)
			Exit
		Endif
		While (GetSX8Len() > nSaveSX8)
			ConfirmSX8()
		End
		cId := GetSXENum("ZAF", "ZAF_ID")
	End

Return(cId)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06HAG
Apresenta consulta dos historicos da agenda agrupados pelo IDPAI 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06HAG(cCliente, cLoja, cId)
	********************************************
	Local oSize, oHistor
	Local cQuery     := ""
	Local oBrowse    := Nil
	Local oColumn    := Nil
	Local oDlg       := Nil
	Local cArqTemp   := ""
	Local cCliNome   := ""
	Local aCoors     := FWGetDialogSize( oMainWnd )

	Private cOrdBrw  := ""

	Private cTRBHIS := GetNextAlias()
	Private cTMPH 	:= GetNextAlias()

	If Empty(cId)
		ApMsgInfo("Não existe ligações com outras agendas","Atenção")
		Return
	Endif

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())

	// Cria arquivo de trabalho
	aArqTemp := {}
	AAdd(aArqTemp,{"Atend"     ,"C",01,0,})
	AAdd(aArqTemp,{"Filial"    ,"C",04,0,})
	AAdd(aArqTemp,{"Emissao"   ,"D",08,0,})
	AAdd(aArqTemp,{"Agenda"    ,"D",08,0,})
	AAdd(aArqTemp,{"NumOrc"    ,"C",06,0,})
	AAdd(aArqTemp,{"VlrOrc"    ,"N",12,2,})
	AAdd(aArqTemp,{"TpAgen"    ,"C",40,0,})
	AAdd(aArqTemp,{"NomCnt"    ,"C",20,0,})
	AAdd(aArqTemp,{"FonCnt"    ,"C",15,0,})
	AAdd(aArqTemp,{"EmlCnt"    ,"C",40,0,})
	//AAdd(aArqTemp,{"Carteira"  ,"C",40,0,})
	//AAdd(aArqTemp,{"GrpCart"   ,"C",40,0,})
	AAdd(aArqTemp,{"Hora"      ,"C",08,0,})
	AAdd(aArqTemp,{"DtaRet"    ,"D",08,0,})
	AAdd(aArqTemp,{"HorRet"    ,"C",08,0,})
	AAdd(aArqTemp,{"UsrRet"    ,"C",20,0,})
	AAdd(aArqTemp,{"Coligada"  ,"C",40,0,})
	AAdd(aArqTemp,{"Nome_Colig","C",40,0,})
	AAdd(aArqTemp,{"ID"        ,"C",10,0,})
	AAdd(aArqTemp,{"IDPAI"     ,"C",10,0,})

	//-- Cria Indice de Trabalho
	cArqTemp := CriaTrab(aArqTemp)

	//-- Criando Indice Temporario
	dbUseArea(.T.,__LOCALDRIVER,cArqTemp,cTRBHIS,.T.,.F.)

	cQuery := "SELECT ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,   ZAF.ZAF_DATINC, "
	cQuery += "       ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, SA1.A1_XCOLIG, SZ6.Z6_DESCRI, "
	cQuery += "       SA1.A1_TEL,     ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   SU5.U5_EMAIL,  "
	cQuery += "       ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, "
	cQuery += "       CASE "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '1' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '2' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '3' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '4' "
	cQuery += "       END AS ATEND, ZAF.ZAF_ID, ZAF.ZAF_IDPAI, ZAF.ZAF_FILIAL "
	cQuery += "FROM "+RetSqlName("ZAF")+" ZAF with (nolock) "
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 with (nolock) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
	cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "
	cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "
	cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif
	cQuery += "INNER JOIN "+RetSqlName("ZAD")+" ZAD with (nolock) ON ZAD.ZAD_CODIGO = ZAF.ZAF_TPAGEN "
	cQuery += "                                    AND ZAD.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT  JOIN "+RetSqlName("SU5")+" SU5 with (nolock) ON SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "
	cQuery += "                                    AND SU5.U5_CODCONT = ZAF.ZAF_CONTAT "
	cQuery += "                                    AND SU5.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT  JOIN "+RetSqlName("SZ6")+" SZ6 WITH (NOLOCK) ON SZ6.Z6_FILIAL  = '"+xFilial("SZ6")+"' "+ CRLF
	cQuery += "                                    AND SZ6.Z6_CODIGO = SA1.A1_XCOLIG "+ CRLF
	cQuery += "                                    AND SZ6.D_E_L_E_T_ = ' ' "+ CRLF

	//cQuery += "WHERE ZAF.ZAF_IDPAI  = '"+cId+"' "
	cQuery += "WHERE   ZAF.D_E_L_E_T_ <> '*' "
	cQuery += "AND ZAF.ZAF_CLIENT = '" + cCliente + "' AND ZAF.ZAF_LOJA = '" + cLoja + "' "
	cQuery += "GROUP BY ZAF.ZAF_ATEND,  ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC, ZAF.ZAF_DATINC, "
	cQuery += "         ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, "
	cQuery += "         SA1.A1_TEL,     ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   SU5.U5_EMAIL,  "
	cQuery += "         ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, ZAF.ZAF_ATEND, "
	cQuery += "         ZAF.ZAF_ID,     ZAF.ZAF_IDPAI,  ZAF.ZAF_FILIAL, SA1.A1_XCOLIG, SZ6.Z6_DESCRI "

	cQuery += "ORDER BY ZAF.ZAF_DTAGEN "

	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTMPH, .F., .T.)
	TcSetField(cTMPH,"ZAF_DATINC","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTAGEN","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTARET","D", 8,0)

	DbSelectArea(cTMPH)
	Do While (cTMPH)->(!Eof())

		DbselectArea(cTRBHIS)
		Reclock(cTRBHIS,.T.)

		(cTRBHIS)->ATEND      := (cTMPH)->ATEND
		(cTRBHIS)->FILIAL     := (cTMPH)->ZAF_FILIAL
		(cTRBHIS)->EMISSAO    := (cTMPH)->ZAF_DATINC
		(cTRBHIS)->AGENDA     := (cTMPH)->ZAF_DTAGEN
		(cTRBHIS)->TPAGEN     := (cTMPH)->ZAD_DESC
		(cTRBHIS)->NOMCNT     := (cTMPH)->A1_CONTATO
		(cTRBHIS)->FONCNT     := (cTMPH)->U5_FCOM1
		(cTRBHIS)->EMLCNT     := (cTMPH)->U5_EMAIL
		//(cTRBHIS)->CARTEIRA   := (cTMPH)->ZA6_DESCR
		//(cTRBHIS)->GRPCART    := (cTMPH)->ZAE_DESC
		(cTRBHIS)->HORA       := (cTMPH)->ZAF_HORINC
		(cTRBHIS)->NUMORC     := (cTMPH)->ZAF_NUMORC
		(cTRBHIS)->VLRORC     := (cTMPH)->ZAF_VLRORC
		(cTRBHIS)->DTARET     := (cTMPH)->ZAF_DTARET
		(cTRBHIS)->HORRET     := (cTMPH)->ZAF_HORRET
		(cTRBHIS)->USRRET     := UsrRetName((cTMPH)->ZAF_USRRET)
		(cTRBHIS)->COLIGADA   := (cTMPH)->A1_XCOLIG
		(cTRBHIS)->NOME_COLIG := (cTMPH)->Z6_DESCRI
		(cTRBHIS)->ID         := (cTMPH)->ZAF_ID
		(cTRBHIS)->IDPAI      := (cTMPH)->ZAF_IDPAI
		Msunlock()
		cCliNome           := (cTMPH)->A1_NOME
		(cTMPH)->(DbSkip())
	EndDo

	DbSelectArea(cTRBHIS)

	//- Coordenadas da area total da Dialog
	oSize := FWDefSize():New(.T.)
	oSize:AddObject('DLG',100,100,.T.,.T.)
	oSize:SetWindowSize(aCoors)
	oSize:lProp 	:= .T.
	oSize:Process()

	DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .F.

	oLayer2 := FWLayer():New()

	oLayer2:Init(oDlg)
	oLayer2:addLine("TOP",34,.F.)
	oLayer2:addLine("BODY",60,.F.)
	oLayer2:addCollumn("COL_TOP",100,.f.,"TOP")
	oLayer2:addCollumn("COL_BODY",100,.f.,"BODY")

	oHistor := oLayer2:GetColPanel("COL_TOP","TOP")
	oHistor:FreeChildren()

	oHistor1 := oLayer2:GetColPanel("COL_BODY","BODY")
	oHistor1:FreeChildren()


	DEFINE FWFORMBROWSE oBrowse DATA TABLE ALIAS cTRBHIS DESCRIPTION "Históricos de agendamentos do cliente: "+AllTrim(cCliNome)+" - Id: "+cId OF oHistor

	oBrowse:SetTemporary(.T.)
	oBrowse:bHeaderClick := {|| OrdenaBrowse(oBrowse) }
	oBrowse:SetdbFFilter(.F.)
	oBrowse:SetUseFilter(.F.)
	oBrowse:DisableDetails()
	oBrowse:DisableReport()
	oBrowse:DisableConfig()
	oBrowse:SetChange( {|| FSDETAGE((cTRBHIS)->FILIAL, cCliente, cLoja, (cTRBHIS)->EMISSAO, (cTRBHIS)->HORA, oHistor1, .T.)} )

	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="1" } COLOR "GREEN"  TITLE "Agenda em aberto"        OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="2" } COLOR "RED"    TITLE "Agenda atendido"         OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="3" } COLOR "YELLOW" TITLE "Agenda futura em aberto" OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="4" } COLOR "ORANGE" TITLE "Agenda futura atendido"  OF oBrowse
	oBrowse:aColumns[1]:cTitle := "Sts"

	ADD COLUMN oColumn DATA { || &(aArqTemp[02,1]) } TITLE "Filial"           SIZE aArqTemp[02,3] PICTURE PesqPict("ZAF","ZAF_FILIAL") TYPE aArqTemp[02,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[03,1]) } TITLE "Dt.emissao"       SIZE aArqTemp[03,3] PICTURE PesqPict("ZAF","ZAF_DATINC") TYPE aArqTemp[03,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[04,1]) } TITLE "Dt agendamento"   SIZE aArqTemp[04,3] PICTURE PesqPict("ZAF","ZAF_DTAGEN") TYPE aArqTemp[04,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[05,1]) } TITLE "Orçamento"        SIZE aArqTemp[05,3] PICTURE PesqPict("ZAF","ZAF_NUMORC") TYPE aArqTemp[05,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[06,1]) } TITLE "Vlr.Orçamentoo"    SIZE aArqTemp[06,3] PICTURE PesqPict("ZAF","ZAF_VLRORC") TYPE aArqTemp[06,2] ALIGN 2 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[07,1]) } TITLE "Tipo agendamento" SIZE aArqTemp[07,3] PICTURE PesqPict("ZAD","ZAD_DESC")   TYPE aArqTemp[07,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[08,1]) } TITLE "Nome do contato"  SIZE aArqTemp[08,3] PICTURE PesqPict("ZAF","U5_CONTAT")  TYPE aArqTemp[08,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[09,1]) } TITLE "Fone contato"     SIZE aArqTemp[09,3] PICTURE PesqPict("ZAF","U5_FCOM1")   TYPE aArqTemp[09,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[10,1]) } TITLE "E-Mail contato"   SIZE aArqTemp[10,3] PICTURE PesqPict("ZAF","U5_EMAIL")   TYPE aArqTemp[10,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[11,1]) } TITLE "Carteira"         SIZE aArqTemp[11,3] PICTURE PesqPict("SA3","ZA6_DESC")   TYPE aArqTemp[11,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[12,1]) } TITLE "Grupo carteira"   SIZE aArqTemp[12,3] PICTURE PesqPict("SA1","ZAE_DESC")   TYPE aArqTemp[12,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[11,1]) } TITLE "Hora"             SIZE aArqTemp[11,3] PICTURE PesqPict("ZAF","ZAF_HORINC") TYPE aArqTemp[11,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[12,1]) } TITLE "Data retorno"     SIZE aArqTemp[12,3] PICTURE PesqPict("ZAF","ZAF_DTARET") TYPE aArqTemp[12,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[13,1]) } TITLE "Hora retorno"     SIZE aArqTemp[13,3] PICTURE PesqPict("ZAF","ZAF_HORRET") TYPE aArqTemp[13,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[14,1]) } TITLE "Quem Retornou"    SIZE aArqTemp[14,3] PICTURE PesqPict("ZAF","ZAF_USRRET") TYPE aArqTemp[14,2] ALIGN 1 OF oBrowse
	
	ADD COLUMN oColumn DATA { || &(aArqTemp[15,1]) } TITLE "Coligada"         SIZE aArqTemp[15,3] PICTURE PesqPict("SA1","A1_XCOLIG")   TYPE aArqTemp[15,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[16,1]) } TITLE "Nome Coligada"    SIZE aArqTemp[16,3] PICTURE PesqPict("SZ6","Z6_DESCRI")   TYPE aArqTemp[16,2] ALIGN 1 OF oBrowse

	ADD COLUMN oColumn DATA { || &(aArqTemp[17,1]) } TITLE "Id"               SIZE aArqTemp[17,3] PICTURE PesqPict("ZAF","ZAF_ID")     TYPE aArqTemp[17,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[18,1]) } TITLE "Id Pai"           SIZE aArqTemp[18,3] PICTURE PesqPict("ZAF","ZAF_IDPAI")  TYPE aArqTemp[18,2] ALIGN 1 OF oBrowse

	ACTIVATE FWFORMBROWSE oBrowse

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,,,,, .F., .F., .F., .F., .F. ) centered

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())
	FErase(cArqTemp + GetDbExtension())

Return
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} TAG06HCL
Apresenta consulta dos historicos das agendas do orcamento 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function TAG06HCL(cCliente, cLoja, cNumOrc)
	
	Local oSize, oHistor
	Local cQuery     := ""
	Local oBrowse    := Nil
	Local oColumn    := Nil
	Local oDlg       := Nil
	Local cArqTemp   := ""
	Local cCliNome   := ""
	Local aCoors     := FWGetDialogSize( oMainWnd )

	Private cOrdBrw  := ""

	Private cTRBHIS := GetNextAlias()
	Private cTMPH 	:= GetNextAlias()

	If Empty(cNumOrc)
		ApMsgInfo("Esta consulta de históricos de agenda é somente para orçamento","Atenção")
		Return
	Endif

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())

	// Cria arquivo de trabalho
	aArqTemp := {}
	AAdd(aArqTemp,{"Atend"     ,"C",01,0,})
	AAdd(aArqTemp,{"Emissao"   ,"D",08,0,})
	AAdd(aArqTemp,{"Agenda"    ,"D",08,0,})
	AAdd(aArqTemp,{"VlrOrc"    ,"N",12,2,})
	AAdd(aArqTemp,{"TpAgen"    ,"C",40,0,})
	AAdd(aArqTemp,{"NomCnt"    ,"C",20,0,})
	AAdd(aArqTemp,{"FonCnt"    ,"C",15,0,})
	AAdd(aArqTemp,{"EmlCnt"    ,"C",40,0,})
	//AAdd(aArqTemp,{"Carteira"  ,"C",40,0,})
	//AAdd(aArqTemp,{"GrpCart"   ,"C",40,0,})
	AAdd(aArqTemp,{"Hora"      ,"C",08,0,})
	AAdd(aArqTemp,{"DtaRet"    ,"D",08,0,})
	AAdd(aArqTemp,{"HorRet"    ,"C",08,0,})
	AAdd(aArqTemp,{"UsrRet"    ,"C",20,0,})
	AAdd(aArqTemp,{"Coligada"  ,"C",40,0,})
	AAdd(aArqTemp,{"Nome_Colig","C",40,0,})
	AAdd(aArqTemp,{"ID"        ,"C",10,0,})
	AAdd(aArqTemp,{"IDPAI"     ,"C",10,0,})
	AAdd(aArqTemp,{"Filial"    ,"C",04,0,})

	//-- Cria Indice de Trabalho
	cArqTemp := CriaTrab(aArqTemp)

	//-- Criando Indice Temporario
	dbUseArea(.T.,__LOCALDRIVER,cArqTemp,cTRBHIS,.T.,.F.)

	cQuery := "SELECT ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,   ZAF.ZAF_DATINC, "
	cQuery += "       ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, SA1.A1_XCOLIG, SZ6.Z6_DESCRI, "
	cQuery += "       SA1.A1_TEL,     ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   SU5.U5_EMAIL, "
	cQuery += "       ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, "
	cQuery += "       CASE "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '1' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN <= '"+Dtos(dDatabase)+"' THEN '2' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '3' "
	cQuery += "           WHEN ZAF.ZAF_ATEND IN ('1')     AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '4' "
	cQuery += "       END AS ATEND, ZAF.ZAF_ID, ZAF.ZAF_IDPAI, ZAF.ZAF_FILIAL "
	cQuery += "FROM "+RetSqlName("ZAF")+" ZAF with (nolock) "
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 with (nolock) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
	cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "
	cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "
	cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "
	If !(alltrim(__cUserID) $ (cUsrTop)) // INCUIDO POR CHARLES 17/06/2021
		//--Verifica se usuario é vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID))

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		EndIf
	Endif
	cQuery += "LEFT  JOIN "+RetSqlName("SU5")+" SU5 with (nolock) ON SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "
	cQuery += "                                    AND SU5.U5_CODCONT = ZAF.ZAF_CONTAT "
	cQuery += "                                    AND SU5.D_E_L_E_T_ = ' ' "
	cQuery += "INNER JOIN "+RetSqlName("ZAD")+" ZAD with (nolock) ON ZAD.ZAD_CODIGO = ZAF.ZAF_TPAGEN "
	cQuery += "                                    AND ZAD.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT  JOIN "+RetSqlName("SZ6")+" SZ6 WITH (NOLOCK) ON SZ6.Z6_FILIAL  = '"+xFilial("SZ6")+"' "+ CRLF
	cQuery += "                                    AND SZ6.Z6_CODIGO = SA1.A1_XCOLIG "+ CRLF
	cQuery += "                                    AND SZ6.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "WHERE ZAF.ZAF_FILIAL = '"+xFilial("ZAF")+"' "
	cQuery += "AND   ZAF.ZAF_NUMORC = '"+cNumOrc+"' "
	cQuery += "AND   ZAF.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY ZAF.ZAF_ATEND,  ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,  ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC, ZAF.ZAF_DATINC, "
	cQuery += "         ZAF.ZAF_CART,   ZAF.ZAF_DTAGEN, ZAF.ZAF_HORINC, SA1.A1_DDD, "
	cQuery += "         SA1.A1_TEL,     ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   SU5.U5_EMAIL, "
	cQuery += "         ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, ZAF.ZAF_DTARET, ZAF.ZAF_HORRET, ZAF.ZAF_USRRET, ZAF.ZAF_ATEND, "
	cQuery += "         ZAF.ZAF_ID,     ZAF.ZAF_IDPAI,  ZAF.ZAF_FILIAL, SA1.A1_XCOLIG, SZ6.Z6_DESCRI "

	cQuery += "ORDER BY ZAF.ZAF_DTAGEN "

	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),cTMPH, .F., .T.)
	TcSetField(cTMPH,"ZAF_DATINC","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTAGEN","D", 8,0)
	TcSetField(cTMPH,"ZAF_DTARET","D", 8,0)

	DbSelectArea(cTMPH)
	While (cTMPH)->(!Eof())

		DbselectArea(cTRBHIS)
		Reclock(cTRBHIS,.T.)

		(cTRBHIS)->ATEND      := (cTMPH)->ATEND
		(cTRBHIS)->EMISSAO    := (cTMPH)->ZAF_DATINC
		(cTRBHIS)->AGENDA     := (cTMPH)->ZAF_DTAGEN
		(cTRBHIS)->TPAGEN     := (cTMPH)->ZAD_DESC
		(cTRBHIS)->NOMCNT     := (cTMPH)->A1_CONTATO
		(cTRBHIS)->FONCNT     := (cTMPH)->U5_FCOM1
		(cTRBHIS)->EMLCNT     := (cTMPH)->U5_EMAIL
		//(cTRBHIS)->CARTEIRA   := (cTMPH)->ZA6_DESCR
		//(cTRBHIS)->GRPCART    := (cTMPH)->ZAE_DESC
		(cTRBHIS)->HORA       := (cTMPH)->ZAF_HORINC
		(cTRBHIS)->VLRORC     := (cTMPH)->ZAF_VLRORC
		(cTRBHIS)->DTARET     := (cTMPH)->ZAF_DTARET
		(cTRBHIS)->HORRET     := (cTMPH)->ZAF_HORRET
		(cTRBHIS)->USRRET     := UsrRetName((cTMPH)->ZAF_USRRET)
		(cTRBHIS)->COLIGADA   := (cTMPH)->A1_XCOLIG
		(cTRBHIS)->NOME_COLIG := (cTMPH)->Z6_DESCRI
		(cTRBHIS)->ID         := (cTMPH)->ZAF_ID
		(cTRBHIS)->IDPAI      := (cTMPH)->ZAF_IDPAI
		(cTRBHIS)->FILIAL     := (cTMPH)->ZAF_FILIAL
		Msunlock()

		cCliNome           := (cTMPH)->A1_NOME

		(cTMPH)->(DbSkip())
	EndDo

	DbSelectArea(cTRBHIS)

	//- Coordenadas da area total da Dialog
	oSize := FWDefSize():New(.T.)
	oSize:AddObject('DLG',100,100,.T.,.T.)
	oSize:SetWindowSize(aCoors)
	oSize:lProp 	:= .T.
	oSize:Process()

	DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME

	oDlg:lEscClose     := .F.

	oLayer2 := FWLayer():New()

	oLayer2:Init(oDlg)
	oLayer2:addLine("TOP",34,.F.)
	oLayer2:addLine("BODY",60,.F.)
	oLayer2:addCollumn("COL_TOP",100,.f.,"TOP")
	oLayer2:addCollumn("COL_BODY",100,.f.,"BODY")

	oHistor := oLayer2:GetColPanel("COL_TOP","TOP")
	oHistor:FreeChildren()

	oHistor1 := oLayer2:GetColPanel("COL_BODY","BODY")
	oHistor1:FreeChildren()

	DEFINE FWFORMBROWSE oBrowse DATA TABLE ALIAS cTRBHIS DESCRIPTION "Históricos de agendamentos do orçamento: "+AllTrim(cNumOrc)+" do cliente "+cCliNome OF oHistor

	oBrowse:SetTemporary(.T.)
	oBrowse:bHeaderClick := {|| OrdenaBrowse(oBrowse) }
	oBrowse:SetdbFFilter(.F.)
	oBrowse:SetUseFilter(.F.)
	oBrowse:DisableDetails()
	oBrowse:DisableReport()
	oBrowse:DisableConfig()
	oBrowse:SetChange( {|| FSDETAGE((cTRBHIS)->FILIAL, cCliente, cLoja, (cTRBHIS)->EMISSAO, (cTRBHIS)->HORA, oHistor1, .T.)} )

	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="1" } COLOR "GREEN"  TITLE "Agenda em aberto"        OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="2" } COLOR "RED"    TITLE "Agenda atendido"         OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="3" } COLOR "YELLOW" TITLE "Agenda futura em aberto" OF oBrowse
	ADD LEGEND DATA {|| &(aArqTemp[01,1])=="4" } COLOR "ORANGE" TITLE "Agenda futura atendido"  OF oBrowse
	oBrowse:aColumns[1]:cTitle := "Sts"

	ADD COLUMN oColumn DATA { || &(aArqTemp[02,1]) } TITLE "Dt.emissao"       SIZE aArqTemp[02,3] PICTURE PesqPict("ZAF","ZAF_DATINC") TYPE aArqTemp[02,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[03,1]) } TITLE "Dt agendamento"   SIZE aArqTemp[03,3] PICTURE PesqPict("ZAF","ZAF_DTAGEN") TYPE aArqTemp[03,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[04,1]) } TITLE "Vlr.orçamento"    SIZE aArqTemp[04,3] PICTURE PesqPict("ZAF","ZAF_VLRORC") TYPE aArqTemp[04,2] ALIGN 2 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[05,1]) } TITLE "Tipo agendamento" SIZE aArqTemp[05,3] PICTURE PesqPict("ZAD","ZAD_DESC")   TYPE aArqTemp[05,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[06,1]) } TITLE "Nome do contato"  SIZE aArqTemp[06,3] PICTURE PesqPict("ZAF","U5_CONTAT")  TYPE aArqTemp[06,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[07,1]) } TITLE "Fone contato"     SIZE aArqTemp[07,3] PICTURE PesqPict("ZAF","U5_FCOM1")   TYPE aArqTemp[07,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[08,1]) } TITLE "E-Mail contato"   SIZE aArqTemp[08,3] PICTURE PesqPict("ZAF","U5_EMAIL")   TYPE aArqTemp[08,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[09,1]) } TITLE "Carteira"         SIZE aArqTemp[09,3] PICTURE PesqPict("SA3","ZA6_DESC")   TYPE aArqTemp[09,2] ALIGN 1 OF oBrowse
	//ADD COLUMN oColumn DATA { || &(aArqTemp[10,1]) } TITLE "Grupo carteira"   SIZE aArqTemp[10,3] PICTURE PesqPict("SA1","ZAE_DESC")   TYPE aArqTemp[10,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[09,1]) } TITLE "Hora"             SIZE aArqTemp[09,3] PICTURE PesqPict("ZAF","ZAF_HORINC") TYPE aArqTemp[09,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[10,1]) } TITLE "Data retorno"     SIZE aArqTemp[10,3] PICTURE PesqPict("ZAF","ZAF_DTARET") TYPE aArqTemp[10,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[11,1]) } TITLE "Hora retorno"     SIZE aArqTemp[11,3] PICTURE PesqPict("ZAF","ZAF_HORRET") TYPE aArqTemp[11,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[12,1]) } TITLE "Quem Retornou"    SIZE aArqTemp[12,3] PICTURE PesqPict("ZAF","ZAF_USRRET") TYPE aArqTemp[12,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[13,1]) } TITLE "Coligada"         SIZE aArqTemp[13,3] PICTURE PesqPict("SA1","A1_XCOLIG")  TYPE aArqTemp[13,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[14,1]) } TITLE "Nome Coligada"    SIZE aArqTemp[14,3] PICTURE PesqPict("SZ6","Z6_DESCRI")  TYPE aArqTemp[14,2] ALIGN 1 OF oBrowse
	
	ADD COLUMN oColumn DATA { || &(aArqTemp[15,1]) } TITLE "Id"               SIZE aArqTemp[15,3] PICTURE PesqPict("ZAF","ZAF_ID")     TYPE aArqTemp[15,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aArqTemp[16,1]) } TITLE "Id Pai"           SIZE aArqTemp[16,3] PICTURE PesqPict("ZAF","ZAF_IDPAI")  TYPE aArqTemp[16,2] ALIGN 1 OF oBrowse

	ACTIVATE FWFORMBROWSE oBrowse

	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,,,,, .F., .F., .F., .F., .F. ) centered

	If Select(cTRBHIS) > 0; dbSelectArea(cTRBHIS); dbCloseArea(); EndIf
	If Select(cTMPH) > 0; dbSelectArea(cTMPH); dbCloseArea(); EndIf

	FErase(cTRBHIS + GetDbExtension())
	FErase(cTRBHIS + OrdBagExt())
	FErase(cTMPH + GetDbExtension())
	FErase(cTMPH + OrdBagExt())
	FErase(cArqTemp + GetDbExtension())

Return
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} fConSeek
Recria indice por orçamento e faz a posiciona no registro 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function fConSeek(oSeek, oBrowse, cPriId, cOp)
	
	//Local cOrder  := oSeek:cOrder
	Local cSeek   := oSeek:cSeek
	Local cAlias  := oBrowse:Alias()
	//Local nIndAnt := oBrowse:ColPos()
	//Local nOpFilt := IIF(!Empty(cPriId),5,oSeek:OORDER:NOPTION)
	//Local nIndice := 0
	Local nOpFilt := oSeek:OORDER:NOPTION

	dbSelectArea(cAlias)
	
	/*If cOp == 'G'
		cIndAge1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
		cIndAge2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
		cIndAge3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
		cIndAge4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
		cIndAge5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
		cIndAge6 := Substr(CriaTrab(NIL,.F.),1,7)+"6"
		cIndAge7 := Substr(CriaTrab(NIL,.F.),1,7)+"7"
	Else
		cIndAge1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
		cIndAge2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
		cIndAge3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
		cIndAge4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
		cIndAge5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
	EndIf	
	If cOp == 'G'
		IndRegua(cAlias, cIndAge1, "CLIENTE",,, "Criando indice por Cliente...")
		IndRegua(cAlias, cIndAge2, "NUMORC",,, "Criando indice por orçamento...")	
		IndRegua(cAlias, cIndAge3, "CGC_CPF",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge4, "NOME",,, "Criando indice por NOME...")
		IndRegua(cAlias, cIndAge5, "ID",,, "Criando indice por ID...")
		//IndRegua(cAlias, cIndAge6, "COLIDATA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge6, "COLIGADA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge7, "NOME_COLIG",,, "Criando indice por NOME...")
	Else
		IndRegua(cAlias, cIndAge1, "CLIENTE",,, "Criando indice por Cliente...")
		IndRegua(cAlias, cIndAge2, "CGC_CPF",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge3, "NOME",,, "Criando indice por NOME...")
		//IndRegua(cAlias, cIndAge4, "COLIDATA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge4, "COLIGADA",,, "Criando indice por CGC...")
		IndRegua(cAlias, cIndAge5, "NOME_COLIG",,, "Criando indice por NOME...")
		IndRegua(cAlias, cIndAge6, "DTAGEN",,, "Criando indice por DATA...")
		
	EndIf
	
	//IndRegua(cAlias, cIndAge2, "NUMORC",,, "Criando indice por orcamento...")		
	//IndRegua(cAlias, cIndAge5, "ID",,, "Criando indice por ID...")
	
	Set Cursor Off
	DbClearIndex()
	
	If cOp == 'G'
		(cAlias)->(DbSetIndex(cIndAge1+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge2+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge3+OrdBagExt()))	
		(cAlias)->(DbSetIndex(cIndAge4+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge5+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge6+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge7+OrdBagExt()))
	Else
		(cAlias)->(DbSetIndex(cIndAge1+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge2+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge3+OrdBagExt()))			
		(cAlias)->(DbSetIndex(cIndAge4+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge5+OrdBagExt()))
		(cAlias)->(DbSetIndex(cIndAge6+OrdBagExt()))
	EndIf*/
	
	oBrowse:GoTo(1)
	dbSelectArea(cAlias)
	/*If cOp == 'G'
		If nOpFilt == 1
			//DbSetOrder(1)
			(cAlias)->(dbSetOrder(1))
		ElseIf nOpFilt == 2
			//DbSetOrder(2)
			(cAlias)->(dbSetOrder(2))
		ElseIf nOpFilt == 3
			(cAlias)->(dbSetOrder(3))
		ElseIf nOpFilt == 4
			(cAlias)->(dbSetOrder(4))		
		ElseIf nOpFilt == 5
			(cAlias)->(dbSetOrder(5))
		Else
			(cAlias)->(dbSetOrder(6))
		EndIf
	Else	
		If nOpFilt == 1
			//DbSetOrder(1)
			(cAlias)->(dbSetOrder(1))
		ElseIf nOpFilt == 2
			//DbSetOrder(2)
			(cAlias)->(dbSetOrder(2))
		ElseIf nOpFilt == 3
			(cAlias)->(dbSetOrder(3))
		ElseIf nOpFilt == 4
			(cAlias)->(dbSetOrder(4))
		ElseIf nOpFilt == 5
			(cAlias)->(dbSetOrder(5))
		ElseIf nOpFilt == 6
			(cAlias)->(dbSetOrder(6))
		EndIf
	EndIf*/
	(cAlias)->(dbSetOrder(nOpFilt))
	//--Seek	
	(cAlias)->(DbSeek(AllTrim(cSeek),.T.))
	oBrowse:GoTo(Recno())

	/*If cOp == 'G'
		FErase(cIndAge1 + OrdBagExt())
		FErase(cIndAge2 + OrdBagExt())	
		FErase(cIndAge3 + OrdBagExt())	
		FErase(cIndAge4 + OrdBagExt())
		FErase(cIndAge5 + OrdBagExt())
		FErase(cIndAge6 + OrdBagExt())
		FErase(cIndAge7 + OrdBagExt())
	Else
		FErase(cIndAge1 + OrdBagExt())
		FErase(cIndAge2 + OrdBagExt())	
		FErase(cIndAge3 + OrdBagExt())	
		FErase(cIndAge4 + OrdBagExt())
		FErase(cIndAge5 + OrdBagExt())
		FErase(cIndAge6 + OrdBagExt())
	EndIf*/
	
Return(Recno())
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} gravaAgenda
Funcao grava agenda 

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function gravaAgenda(cFilAtend,cNumAtend,cTipo)
	
	Local aZAF  := ZAF->(getArea())
	Local aArea := getArea()

	ZAF->(DbSetOrder(2))  // ZAF_FILIAL, ZAF_NUMORC, ZAF_ATEND.
	If ZAF->(DbSeek(cFilAtend + cNumAtend + "2"))
		RecLock("ZAF",.F.)
		ZAF->ZAF_ATEND  := "1"
		ZAF->ZAF_DTARET := dDatabase
		ZAF->ZAF_HORRET := Time()
		ZAF->ZAF_USRRET := __cUserId
		If cTipo == "P"
			ZAF->ZAF_HISTOR := AllTrim(ZAF->ZAF_HISTOR) + CRLF + "Data " + dToc(dDataBase) + CRLF + "Agenda encerrada pois foi gerado o pedido " + SUA->UA_NUMSC5
		ElseIf cTipo == "C"
			ZAF->ZAF_HISTOR := AllTrim(ZAF->ZAF_HISTOR) + CRLF + "Data: " + Dtoc(dDataBase) + CRLF + "Encerramento da agenda via cancelamento total de orcamento"
		endIf
		ZAF->(MsUnLock())
	EndIf

	restArea(aZAF)
	restArea(aArea)

Return
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldAgen
Funcao valida existencia de agenda

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FVldAgen(cCodAux, cLojaAux)

	Local cQuery := ''
	Local aTabAge:= GetNextAlias()
	Local lRet	 := .T.

	cQuery:="SELECT COUNT(*) AS TOT " 
	cQuery+="FROM "+RetsqlName('ZAF')+" " 
	cQuery+="WHERE D_E_L_E_T_ = '' AND ZAF_CLIENT = '"+cCodAux+"' AND ZAF_LOJA = '"+cLojaAux+"' " 
	cQuery+="AND ZAF_ATEND = '2' AND ZAF_USRRET = '' AND ZAF_NUMORC = '' "
	cQuery+="AND ZAF_DTAGEN < '"+Dtos(DdataBase)+"' "
			
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), aTabAge )
	
	(aTabAge)->(DbGoTop())
	//--Valida quantidade de registros
	lRet:= IIF((aTabAge)->TOT>0,.T.,.F.)
	//--Fecha tabela temporaria
	(aTabAge)->(DbCloseArea())		

Return(lRet)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldAgen
Funcao valida existencia de agenda

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsTime(cTRB1, oBrwDCW, aTotais)

	Local cTRB4 := ''
	Local cPriId:= ''
	
	If Select( cTRB1 ) > 0 
		DbSelectArea(cTRB1)
		(cTRB1)->(DbGoTop())
		Do While (cTRB1)->(!Eof())
			Reclock(cTRB1,.F.)
			(cTRB1)->(DbDelete())
			(cTRB1)->(Msunlock())
			(cTRB1)->(DbSkip())
		EndDo
		//--Carrega dados na tabela temporaria
		cTRB4:=FBuscaDad()
		//--Atualiza dados no grid
		FSCarDados(@cTRB1, cTRB4, @cPriId)
		//FSAgecli(cTRB1, cTRB4, cPriId)
		//--Atualiza grid
		oBrwDCW:Refresh()
		aAdd(aTotais, {0, 0, 0.0, 0.00, 0.00, 0.00, 0, 0, 0, 0, 0})
		MsgRun("Aguarde... Atualizando dashboard",,{|| FSTOTCAR('', '', @aTotais) } )
		//--Atualiza totais
		FsAtuTot(@aTotais)
		(cTRB1)->(DbSetOrder(01))
		//--Seek
		//(cTRB1)->(DbSeek(AllTrim(cPriId),.T.))
	EndIf

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldAgen
Funcao valida existencia de agenda

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FBuscaDad()

	Local cTMP3 	:= GetNextAlias()
	Local cQuery	:=''

	/*cQuery := "SELECT CASE " + CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN < '"+Dtos(dDatabase)+"'  THEN '1' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN = '"+Dtos(dDatabase)+"'  THEN '2' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND = '1'        AND ZAF.ZAF_DTAGEN = '"+Dtos(dDatabase)+"'  THEN '3' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '4' "+ CRLF
	cQuery += "       END AS FLAG, "+ CRLF
	cQuery += "       	ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME, ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,  ZAF.ZAF_DATINC, "+ CRLF
	cQuery += "         ZAF.ZAF_CART, ZAF.ZAF_DTAGEN, ZAF.ZAF_GRCART, ZAF.ZAF_HORINC, SA1.A1_DDD, "+ CRLF
	cQuery += "         SA1.A1_TEL, ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   ZAF.ZAF_NUMORC, "+ CRLF
	cQuery += "         ZAF.ZAF_VLRORC, ZAF.ZAF_ID, ZAF.ZAF_IDPAI, ZAF.ZAF_FILIAL, SA3.A3_NOME, SA1.A1_CGC, SUA.UA_NUMSC5 "+ CRLF
	cQuery += "FROM "+RetSqlName("ZAF")+" ZAF WITH (NOLOCK) "+ CRLF
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
	cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
	cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
	cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF

	//--Verifica se usuario é vendedor
	SA3->(dbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+__cUserID))
		cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
	Else
		cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' )"+ CRLF
	EndIf
	cQuery += "INNER JOIN "+RetSqlName("ZAD")+" ZAD WITH (NOLOCK) ON ZAD.ZAD_CODIGO = ZAF.ZAF_TPAGEN "+ CRLF
	cQuery += "                                    AND ZAD.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "LEFT  JOIN "+RetSqlName("SU5")+" SU5 WITH (NOLOCK) ON SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "+ CRLF
	cQuery += "                                    AND SU5.U5_CODCONT = ZAF.ZAF_CONTAT "+ CRLF
	cQuery += "                                    AND SU5.D_E_L_E_T_ = ' ' "+ CRLF
	
	cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
	cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
	cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF
	
	cQuery += "WHERE ZAF.ZAF_ATEND  <> '1' "+ CRLF
	cQuery += "AND   ZAF.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "GROUP BY ZAF.ZAF_ATEND, ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,   ZAF.ZAF_DATINC, "+ CRLF
	cQuery += "         ZAF.ZAF_CART,  ZAF.ZAF_DTAGEN, ZAF.ZAF_GRCART, ZAF.ZAF_HORINC, SA1.A1_DDD, "+ CRLF
	cQuery += "         SA1.A1_TEL,    ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, "+ CRLF
	cQuery += "         ZAF.ZAF_ID,    ZAF.ZAF_IDPAI,  ZAF.ZAF_FILIAL, SA3.A3_NOME, SA1.A1_CGC, SUA.UA_NUMSC5 "+ CRLF
	cQuery += "ORDER BY ZAF.ZAF_DTAGEN "+ CRLF
	*/
	
	cQuery += "SELECT A.*, B.QTD_ORC, C.QTD_PEDIDO, D.QTD_AGENDAS "+ CRLF
		cQuery += "FROM "+ CRLF 
		cQuery += "( "+ CRLF
		cQuery += "SELECT "+ CRLF
		cQuery += "ZAF_FILIAL, ZAF_CLIENT, ZAF_LOJA, A1_NOME, A1_CGC , A1_TEL, A3_NOME, MIN(ZAF_DTAGEN) AS ZAF_DTAGEN, A1_XCOLIG, Z6_DESCRI "+ CRLF
		cQuery += "FROM " + RetSqlName("ZAF") + " ZAF WITH (NOLOCK) "+ CRLF 
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
		cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
		cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
		cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF 
		
		//--Verifica se usuario ID vendedor
		SA3->(dbSetOrder(7))
		If SA3->(DbSeek(xFilial("SA3")+__cUserID)) .and. !(alltrim(__cUserID) $ cUsrTop)

			cCodIn := "('" + SA3->A3_COD + "'"
			//Procurar se é substituto de alguem
			If (Select("A3SUBS") <> 0)
				A3SUBS->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "A3SUBS"
				SELECT A3_COD
				FROM %table:SA3% SA3
				WHERE SA3.%notdel%
				AND SA3.A3_SUBST = %exp:SA3->A3_COD%
			ENDSQL
			if !empty(A3SUBS->A3_COD)
				cCodIn += ",'" + A3SUBS->A3_COD + "'"
			endif
			cCodIn += ")"

			cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
			//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
			cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
		Else
			cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
			cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' )"+ CRLF
		EndIf
		
		cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
		cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
		cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF

		cQuery += "LEFT  JOIN "+RetSqlName("SZ6")+" SZ6 WITH (NOLOCK) ON SZ6.Z6_FILIAL  = '"+xFilial("SZ6")+"' "+ CRLF
		cQuery += "AND SZ6.Z6_CODIGO = SA1.A1_XCOLIG "+ CRLF
		cQuery += "AND SZ6.D_E_L_E_T_ = ' ' "+ CRLF	
		
		cQuery += "WHERE  ZAF.D_E_L_E_T_ = ' ' AND ZAF.ZAF_ATEND <> '1' "+ CRLF
		cQuery += "GROUP BY ZAF_FILIAL, ZAF_CLIENT, ZAF_LOJA, A1_NOME, A1_CGC , A1_TEL, A3_NOME, A1_XCOLIG, Z6_DESCRI ) A "+ CRLF
		cQuery += "LEFT JOIN "+ CRLF
		cQuery += "(SELECT  ZAF_CLIENT, ZAF_LOJA, COUNT(*) AS QTD_ORC "+ CRLF
		cQuery += "FROM " + RetSqlName("ZAF") + " ZAF "+ CRLF
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
		cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
		cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
		cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF 

		//cQuery += "WHERE ZAF_NUMORC <> '' "+ CRLF 
		//cQuery += "AND  ZAF.D_E_L_E_T_ = ' ' " + CRLF
		//cQuery += "GROUP BY ZAF_CLIENT, ZAF_LOJA ) B "+ CRLF
		cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
		cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
		cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF  
		cQuery += "WHERE UA_DOC = ' ' "+ CRLF 
		cQuery += "AND  ZAF.D_E_L_E_T_ = ' ' "+ CRLF 
		cQuery += "GROUP BY ZAF_CLIENT, ZAF_LOJA ) B "+ CRLF

		cQuery += "ON A.ZAF_CLIENT = B.ZAF_CLIENT AND A.ZAF_LOJA = B.ZAF_LOJA "+ CRLF
		cQuery += "LEFT JOIN "+ CRLF 
		cQuery += "(SELECT  ZAF_CLIENT, ZAF_LOJA, COUNT(*) AS QTD_PEDIDO "+ CRLF
		cQuery += "FROM " + RetSqlName("ZAF") + " ZAF "+ CRLF
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
		cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
		cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
		cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF 
		cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
		cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
		cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF  
		cQuery += "WHERE UA_NUMSC5 <> '' AND UA_DOC = ' ' "+ CRLF 
		cQuery += "AND  ZAF.D_E_L_E_T_ = ' ' "+ CRLF 
		cQuery += "GROUP BY ZAF_CLIENT, ZAF_LOJA ) C "+ CRLF
		cQuery += "ON A.ZAF_CLIENT = C.ZAF_CLIENT AND A.ZAF_LOJA = C.ZAF_LOJA "+ CRLF
		
		cQuery += "LEFT JOIN "+ CRLF 
		cQuery += "(SELECT  ZAF_CLIENT, ZAF_LOJA, COUNT(*) AS QTD_AGENDAS "+ CRLF
		cQuery += "FROM " + RetSqlName("ZAF") + " ZAF "+ CRLF
		cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
		cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
		cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
		cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF 
		cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
		cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
		cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF  
		cQuery += "WHERE ZAF.ZAF_ATEND <> '1' "+ CRLF 
		cQuery += "AND ZAF.D_E_L_E_T_ = ' ' "+ CRLF 
		cQuery += "GROUP BY ZAF_CLIENT, ZAF_LOJA ) D "+ CRLF
		cQuery += "ON A.ZAF_CLIENT = D.ZAF_CLIENT AND A.ZAF_LOJA = D.ZAF_LOJA "+ CRLF
		cQuery += "ORDER BY ZAF_DTAGEN DESC "
		
	If Select( cTMP3 ) > 0; dbSelectArea( cTMP3 ); dbCloseArea(); EndIf

	TCQuery cQuery new Alias (cTMP3)
	
	TCSetField(cTMP3, "ZAF_DTAGEN", "D", 08, 0)
	//TCSetField(cTMP3, "ZAF_DATINC", "D", 08, 0)

Return( cTMP3 )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSCarDados
Funcao busca dados

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSCarDados(cTMP1, cTMP4, cPriId)

	Local aSaveLines := FWSaveRows()

	DbSelectArea(cTMP4)
	Do While (cTMP4)->(!Eof())
		DbselectArea(cTRB1)
		Reclock(cTRB1,.T.)		
		(cTRB1)->FILIAL   := (cTMP4)->ZAF_FILIAL
		(cTRB1)->CLIENTE  := (cTMP4)->ZAF_CLIENT
		(cTRB1)->LOJA     := (cTMP4)->ZAF_LOJA
		(cTRB1)->NOME     := (cTMP4)->A1_NOME
		(cTRB1)->CGC_CPF  := (cTMP4)->A1_CGC
		(cTRB1)->VENDEDOR := (cTMP4)->A3_NOME
		(cTRB1)->NUMORC   := (cTMP4)->QTD_ORC
		(cTRB1)->PEDIDO   := (cTMP4)->QTD_PEDIDO
		(cTRB1)->AGENDAS  := (cTMP4)->QTD_AGENDAS
		(cTRB1)->DTAGEN   := (cTMP4)->ZAF_DTAGEN
		(cTRB1)->COLIGADA := (cTMP4)->A1_XCOLIG
		(cTRB1)->NOME_COLIG:= (cTMP4)->Z6_DESCRI		
		
		//(cTRB1)->FLAG     := (cTMP4)->FLAG
		//(cTRB1)->FONE_CLI := (cTMP4)->A1_DDD+"-"+(cTMP4)->A1_TEL
		//(cTRB1)->DATINC   := (cTMP4)->ZAF_DATINC		
		//(cTRB1)->TPAGEN   := (cTMP4)->ZAD_DESC
		//(cTRB1)->CONTATO  := (cTMP4)->A1_CONTATO
		//(cTRB1)->FONE_CONT:= (cTMP4)->U5_FCOM1
		//(cTRB1)->HORINC   := (cTMP4)->ZAF_HORINC		
		//(cTRB1)->VLRORC   := (cTMP4)->ZAF_VLRORC
		//(cTRB1)->ID       := (cTMP4)->ZAF_ID
		//(cTRB1)->IDPAI    := (cTMP4)->ZAF_IDPAI
		Msunlock()
		(cTMP4)->(DbSkip())
	EndDo
	(cTRB1)->(DbGoTop())
	//cPriId:= (cTRB1)->ID
	FwRestRows(aSaveLines)
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FsAtuTot
Funcao atualiza totalizadores

@author		.iNi Sistemas
@since     	01/03/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsAtuTot(aTotais)

	oTot1:SetText( aTotais[1][1] )
	oTot2:SetText( aTotais[1][2] )
	oTot3:SetText( aTotais[1][3] )
	oTot4:SetText( aTotais[1][4] )
	oTot5:SetText( aTotais[1][5] )
	oTot6:SetText( aTotais[1][6] )
	oTot7:SetText( aTotais[1][7] )
	oTot8:SetText( aTotais[1][8] )
	oTot9:SetText( aTotais[1][9] )
	//oTotA:SetText( aTotais[1][10] )
	//oTotB:SetText( aTotais[1][11] )

	oTot1:refresh()
	oTot2:refresh()
	oTot3:refresh()
	oTot4:refresh()
	oTot5:refresh()
	oTot6:refresh()
	IF aTotais[1][6] < 0.00
		oTot6:nClrText := CLR_HRED
	Else
		oTot6:nClrText := CLR_HBLUE
	Endif
	oTot7:refresh()
	oTot8:refresh()
	oTot9:refresh()
	//oTotA:refresh()
	//oTotB:refresh()
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FsOpFin
funcao opcoes de finalizar agenda

@author		.iNi Sistemas
@since     	03/05/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alteracoes Realizadas desde a Estruturacao Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsOpFin(cTipFin)

	Local oDlg	  := Nil
	Local oMainWnd:= Nil
	Local cTitRpt := 'Opcao de cancelamento'
	Local cCombo1 := Space(6)
	Local nOp	  := 0
	Local aItems  := {}
	Local bEndWnd := {|| oDlg:End()}
	Local bProces := {|| nOp:= 1, oDlg:End()}
	
	ZAD->(DbSetOrder(01))
	ZAD->(DbGoTop())
	Do While ZAD->(!Eof())
		If ZAD->ZAD_TIPO == 'F'
			Aadd(aItems,ZAD->ZAD_CODIGO+' = '+AllTrim(ZAD->ZAD_DESC))
		EndIf
	ZAD->(DbSkip())
	EndDo

	DEFINE MSDIALOG oDlg TITLE cTitRpt FROM 0,0 TO 08,28 OF oMainWnd
	   
	@  05,25 SAY OemToAnsi('Opção de cancelamento') PIXEL 
	TComboBox():New(020,005,{|u| IIf(PCount() > 0,cCombo1 := u,cCombo1)},aItems,105,015,oDlg,,,,,,.T.,,,,,,,,,"cCombo1")
	
	SButton():New(040,045,01,bProces,oDlg,.T.,"OK")
	SButton():New(040,083,02,bEndWnd,oDlg,.T.,"Sair")
	      
	oDlg:Activate(Nil,Nil,Nil,.T.,{|| .T.},Nil,{|| oDlg:lEscClose := .F.},Nil,Nil)
	
	If nOp == 1
		If !Empty(cCombo1)
			cTipFin:= Left(cCombo1,6)
		Else
			MsgAlert(OemToAnsi('Necessario informar opcao de finalização'))
			nOp:= 0
		EndIf	
	EndIf

Return(IIF(nOp==1,.T.,.F.))
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FsFuncRet
Função clique de retorno

@author		.iNi Sistemas
@since     	03/05/2019
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsFuncRet(cCodCli, cCodLoj, cNumOrc, cIdAgend)
	
	//--CVI
	U_IVENA020(cCodCli,cCodLoj,cNumOrc, cIdAgend)
			
Return(.T.)

User Function TAGAGEND(cCodCLi, cCodLoja, oBrwCab1,  aTotais)

	Local cQuery	:= ''
	Local cAlias	:= GetNextAlias()
	Local cTabAgen 	:= GetNextAlias()
	Local cArqAgen	:= ''
	Local cAgeInd1  := ""
	Local cAgeInd2	:= ""
	Local cAgeInd3	:= ""
	Local cAgeInd4	:= ""
	Local cAgeInd5	:= ""
	Local aAgendas	:= {}
	Local oHisAge	:= Nil
	Local oHisAge1	:= Nil
	Local oLayer2	:= Nil
	Local oSize		:= Nil
	Local oDlg		:= Nil
	Local oBrowse	:= Nil
	Local aRet      := {}
	Local aButtons  := {}
	Local aSeek		:= {}
	Local aCoors    := FWGetDialogSize( oMainWnd )
	
	cQuery := "SELECT CASE " + CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN < '"+Dtos(dDatabase)+"'  THEN '1' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN = '"+Dtos(dDatabase)+"'  THEN '2' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND = '1'        AND ZAF.ZAF_DTAGEN = '"+Dtos(dDatabase)+"'  THEN '3' "+ CRLF
	cQuery += "           WHEN ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"'  THEN '4' "+ CRLF
	cQuery += "       END AS FLAG, "+ CRLF
	cQuery += "       	ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME, ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,  ZAF.ZAF_DATINC, "+ CRLF
	cQuery += "         ZAF.ZAF_CART, ZAF.ZAF_DTAGEN, ZAF.ZAF_GRCART, ZAF.ZAF_HORINC, SA1.A1_DDD, SA1.A1_XCOLIG, SZ6.Z6_DESCRI, "+ CRLF
	cQuery += "         SA1.A1_TEL, ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   ZAF.ZAF_NUMORC, "+ CRLF
	cQuery += "         ZAF.ZAF_VLRORC, ZAF.ZAF_ID, ZAF.ZAF_IDPAI, ZAF.ZAF_FILIAL, SA3.A3_NOME, SA1.A1_CGC, SUA.UA_NUMSC5 "+ CRLF
	cQuery += "FROM "+RetSqlName("ZAF")+" ZAF WITH (NOLOCK) "+ CRLF
	cQuery += "INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "+ CRLF
	cQuery += "                                    AND SA1.A1_COD     = ZAF.ZAF_CLIENT "+ CRLF
	cQuery += "                                    AND SA1.A1_LOJA    = ZAF.ZAF_LOJA "+ CRLF
	cQuery += "                                    AND SA1.D_E_L_E_T_ = ' ' "+ CRLF

	//--Verifica se usuario ID vendedor
	SA3->(dbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+__cUserID)) .and. !(alltrim(__cUserID) $ cUsrTop)

		cCodIn := "('" + SA3->A3_COD + "'"
		//Procurar se é substituto de alguem
		If (Select("A3SUBS") <> 0)
			A3SUBS->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "A3SUBS"
			SELECT A3_COD
			FROM %table:SA3% SA3
			WHERE SA3.%notdel%
			AND SA3.A3_SUBST = %exp:SA3->A3_COD%
		ENDSQL
		if !empty(A3SUBS->A3_COD)
			cCodIn += ",'" + A3SUBS->A3_COD + "'"
		endif
		cCodIn += ")"

		cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
		//cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_SUPER = '"+SA3->A3_COD+"' OR A3_GEREN = '"+SA3->A3_COD+"') )"+ CRLF	
		cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD IN "+cCodIn+" OR A3_SUPER IN "+cCodIn+" OR A3_GEREN IN "+cCodIn+") ) "+ CRLF	
	Else
		cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' )"+ CRLF
	EndIf

	cQuery += "INNER JOIN "+RetSqlName("ZAD")+" ZAD WITH (NOLOCK) ON ZAD.ZAD_CODIGO = ZAF.ZAF_TPAGEN "+ CRLF
	cQuery += "                                    AND ZAD.D_E_L_E_T_ = ' ' "+ CRLF
	cQuery += "LEFT  JOIN "+RetSqlName("SU5")+" SU5 WITH (NOLOCK) ON SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "+ CRLF
	cQuery += "                                    AND SU5.U5_CODCONT = ZAF.ZAF_CONTAT "+ CRLF
	cQuery += "                                    AND SU5.D_E_L_E_T_ = ' ' "+ CRLF
	
	cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA WITH (NOLOCK) " + CRLF
	cQuery += "ON SUA.D_E_L_E_T_ = '' AND SUA.UA_FILIAL = ZAF.ZAF_FILIAL AND SUA.UA_NUM = ZAF.ZAF_NUMORC "+ CRLF
	cQuery += "AND SUA.UA_CLIENTE = ZAF.ZAF_CLIENT AND SUA.UA_LOJA = ZAF.ZAF_LOJA  "+ CRLF

	cQuery += "LEFT  JOIN "+RetSqlName("SZ6")+" SZ6 WITH (NOLOCK) ON SZ6.Z6_FILIAL  = '"+xFilial("SZ6")+"' "+ CRLF
	cQuery += "AND SZ6.Z6_CODIGO = SA1.A1_XCOLIG "+ CRLF
	cQuery += "AND SZ6.D_E_L_E_T_ = ' ' "+ CRLF
	
	cQuery += "WHERE ZAF.ZAF_ATEND  <> '1' "+ CRLF
	cQuery += "AND   SA1.A1_COD  = '"+cCodCLi+"' "+ CRLF
	cQuery += "AND   SA1.A1_LOJA = '"+cCodLoja+"' "+ CRLF
	cQuery += "AND   ZAF.D_E_L_E_T_ = ' ' "+ CRLF
	
	cQuery += "GROUP BY ZAF.ZAF_ATEND, ZAF.ZAF_CLIENT, ZAF.ZAF_LOJA,   SA1.A1_NOME,    ZAF.ZAF_TPAGEN, ZAD.ZAD_DESC,   ZAF.ZAF_DATINC, "+ CRLF
	cQuery += "         ZAF.ZAF_CART,  ZAF.ZAF_DTAGEN, ZAF.ZAF_GRCART, ZAF.ZAF_HORINC, SA1.A1_DDD, "+ CRLF
	cQuery += "         SA1.A1_TEL,    ZAF.ZAF_CONTAT, SA1.A1_CONTATO,  SU5.U5_FCOM1,   ZAF.ZAF_NUMORC, ZAF.ZAF_VLRORC, "+ CRLF
	cQuery += "         ZAF.ZAF_ID,    ZAF.ZAF_IDPAI,  ZAF.ZAF_FILIAL, SA3.A3_NOME, SA1.A1_CGC, SUA.UA_NUMSC5, SA1.A1_XCOLIG, SZ6.Z6_DESCRI "+ CRLF
	cQuery += "ORDER BY ZAF.ZAF_DTAGEN DESC "+ CRLF
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.F.,.T.)
	
	TCSetField(cAlias, "ZAF_DTAGEN", "D", 08, 0)
	TCSetField(cAlias, "ZAF_DATINC", "D", 08, 0)
	
	// Campos utilizados
	AAdd( aAgendas, {'FLAG',      "C", 001, 0} )
	AAdd( aAgendas, {'FILIAL',    "C", 004, 0} )
	AAdd( aAgendas, {'CLIENTE',   "C", 008, 0} )
	AAdd( aAgendas, {'LOJA',      "C", 004, 0} )
	AAdd( aAgendas, {'COLIGADA',  "C", 030, 0} )
	AAdd( aAgendas, {'NOME_COLIG',"C", 030, 0} )
	AAdd( aAgendas, {'NOME',      "C", 040, 0} )
	AAdd( aAgendas, {'CGC_CPF',   "C", 014, 0} )
	AAdd( aAgendas, {'FONE_CLI',  "C", 020, 0} )
	AAdd( aAgendas, {'CONTATO',   "C", 030, 0} )
	AAdd( aAgendas, {'DTAGEN',    "D", 008, 0} )
	AAdd( aAgendas, {'NUMORC',    "C", 006, 0} )
	AAdd( aAgendas, {'PEDIDO', 	  "C", 006, 0} )
	AAdd( aAgendas, {'VENDEDOR',  "C", 040, 0} )
	AAdd( aAgendas, {'VLRORC',    "N", 012, 2} )
	AAdd( aAgendas, {'DATINC',    "D", 008, 0} )
	AAdd( aAgendas, {'FONE_CONT', "C", 015, 0} )
	AAdd( aAgendas, {'TPAGEN',    "C", 030, 0} )
	AAdd( aAgendas, {'HORINC',    "C", 008, 0} )
	AAdd( aAgendas, {'ID',        "C", 010, 0} )
	AAdd( aAgendas, {'IDPAI',     "C", 010, 0} )

	//-- Cria Indice de Trabalho
	cArqAgen  := CriaTrab(aAgendas)
	cAgeInd1 := Substr(CriaTrab(NIL,.F.),1,7)+"1"
	cAgeInd2 := Substr(CriaTrab(NIL,.F.),1,7)+"2"
	cAgeInd3 := Substr(CriaTrab(NIL,.F.),1,7)+"3"
	cAgeInd4 := Substr(CriaTrab(NIL,.F.),1,7)+"4"
	cAgeInd5 := Substr(CriaTrab(NIL,.F.),1,7)+"5"
	cAgeInd6 := Substr(CriaTrab(NIL,.F.),1,7)+"6"
	cAgeInd7 := Substr(CriaTrab(NIL,.F.),1,7)+"7"

	//-- Criando Indice Temporario por codigo do cliente
	dbUseArea(.T.,__LOCALDRIVER,cArqAgen,cTabAgen,.T.,.F.)
	IndRegua(cTabAgen, cAgeInd1, "CLIENTE",,, "Criando indice por Cliente...")
	IndRegua(cTabAgen, cAgeInd2, "NUMORC",,, "Criando indice por orçamento...")	
	IndRegua(cTabAgen, cAgeInd3, "CGC_CPF",,, "Criando indice por CGC/CPF...")
	IndRegua(cTabAgen, cAgeInd4, "NOME",,, "Criando indice por NOME...")
	IndRegua(cTabAgen, cAgeInd5, "ID",,, "Criando indice por ID...")
	IndRegua(cTabAgen, cAgeInd6, "COLIGADA",,, "Criando indice por COLIGADA...")
	IndRegua(cTabAgen, cAgeInd7, "NOME_COLIG",,, "Criando indice por NOME COLIGADA...")

	Set Cursor Off
	DbClearIndex()
	DbSetIndex(cAgeInd1+OrdBagExt())
	DbSetIndex(cAgeInd2+OrdBagExt())
	DbSetIndex(cAgeInd3+OrdBagExt())
	DbSetIndex(cAgeInd4+OrdBagExt())
	DbSetIndex(cAgeInd5+OrdBagExt())
	DbSetIndex(cAgeInd6+OrdBagExt())
	DbSetIndex(cAgeInd7+OrdBagExt())
	
	FSAgecli(@cTabAgen, @cAlias)
	
	aAdd(aSeek,{"Cliente",      {{"","C",06,0,"CLIENTE"}} } )
	aAdd(aSeek,{"Orçamento",    {{"","C",06,0,"NUMORC"}} } )	
	aAdd(aSeek,{"CGC_CPF",      {{"","C",14,0,"CGC_CPF"}} } )
	aAdd(aSeek,{"NOME",        	{{"","C",40,0,"NOME"}} } )
	aAdd(aSeek,{"ID",        	{{"","C",10,0,"ID"}} } )
	aAdd(aSeek,{"COLIGADA",     {{"","C",40,0,"COLIGADA"}} } )
	aAdd(aSeek,{"NOME_COLIG", 	{{"","C",40,0,"NOME_COLIG"}} } )

	//- Coordenadas da area total da Dialog
	oSize := FWDefSize():New(.T.)
	oSize:AddObject('DLG',100,100,.T.,.T.)
	oSize:SetWindowSize(aCoors)
	oSize:lProp 	:= .T.
	oSize:Process()

	DEFINE MSDIALOG oDlg FROM oSize:aWindSize[1], oSize:aWindSize[2] TO oSize:aWindSize[3], oSize:aWindSize[4] OF oMainWnd PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .F.

	oLayer2 := FWLayer():New()

	oLayer2:Init(oDlg)
	oLayer2:addLine("TOP",34,.F.)
	oLayer2:addLine("BODY",60,.F.)
	oLayer2:addCollumn("COL_TOP",100,.f.,"TOP")
	oLayer2:addCollumn("COL_BODY",100,.f.,"BODY")

	oHisAge := oLayer2:GetColPanel("COL_TOP","TOP")
	oHisAge:FreeChildren()

	oHisAge1 := oLayer2:GetColPanel("COL_BODY","BODY")
	oHisAge1:FreeChildren()

	DEFINE FWFORMBROWSE oBrowse DATA TABLE ALIAS cTabAgen DESCRIPTION "Agendas Cliente: "+AllTrim(cCodCLi) OF oHisAge

	oBrowse:SetTemporary(.T.)
	oBrowse:SetdbFFilter(.F.)
	oBrowse:SetUseFilter(.F.)
	oBrowse:DisableDetails()
	oBrowse:DisableReport()
	oBrowse:DisableConfig()
	//oBrowse:bHeaderClick := {|| OrdenaBrowse(oBrowse,'G') }
	oBrowse:SetChange( {|| FSDETAGE((cTabAgen)->FILIAL, (cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->DATINC, (cTabAgen)->HORINC, oHisAge1, .T.)} )	
	oBrowse:bLDblClick := {|| U_TAG06DUP((cTabAgen)->FILIAL, (cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->DATINC, (cTabAgen)->HORINC, '', '', '', oBrowse, oDlg, @aRet, (cTabAgen)->ID, cTabAgen) }
	//oBrowse:SetSeek({|oSeek, oBrowse| fConSeek(oSeek, oBrowse,'','G')}, aSeek)

	ADD LEGEND DATA {|| &(aAgendas[01,1])=="1" } COLOR "RED"   TITLE "Atrasada"        OF oBrowse
	ADD LEGEND DATA {|| &(aAgendas[01,1])=="2" } COLOR "BLUE"  TITLE "Agenda do dia"   OF oBrowse
	ADD LEGEND DATA {|| &(aAgendas[01,1])=="3" } COLOR "GREEN" TITLE "Agenda atendida" OF oBrowse
	ADD LEGEND DATA {|| &(aAgendas[01,1])=="4" } COLOR "WHITE" TITLE "Agenda futura"   OF oBrowse

	oBrowse:aColumns[1]:cTitle := "Sts"
                                 
	ADD COLUMN oColumn DATA { || &(aAgendas[02,1]) } TITLE "Filial"          SIZE aAgendas[02,3] PICTURE PesqPict("ZAF","ZAF_FILIAL")  TYPE aAgendas[02,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[03,1]) } TITLE "Cliente"         SIZE aAgendas[03,3] PICTURE PesqPict("ZAF","ZAF_CLIENT")  TYPE aAgendas[03,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[04,1]) } TITLE "Loja"            SIZE aAgendas[04,3] PICTURE PesqPict("ZAF","ZAF_LOJA")    TYPE aAgendas[04,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[05,1]) } TITLE "Coligada"        SIZE aAgendas[05,3] PICTURE PesqPict("SA1","A1_XCOLIG")   TYPE aAgendas[05,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[06,1]) } TITLE "Nome_colig"      SIZE aAgendas[06,3] PICTURE PesqPict("SZ6","Z6_DESCRI")   TYPE aAgendas[06,2] ALIGN 1 OF oBrowse

	
	ADD COLUMN oColumn DATA { || &(aAgendas[07,1]) } TITLE "Nome cliente"    SIZE aAgendas[07,3] PICTURE PesqPict("SA1","A1_NOME")     TYPE aAgendas[07,2] ALIGN 1 OF oBrowse	
	ADD COLUMN oColumn DATA { || &(aAgendas[08,1]) } TITLE "CGC/CPF"   		 SIZE aAgendas[08,3] PICTURE PesqPict("SA1","A1_CGC")      TYPE aAgendas[08,2] ALIGN 1 OF oBrowse		
	ADD COLUMN oColumn DATA { || &(aAgendas[09,1]) } TITLE "Fone cliente"    SIZE aAgendas[09,3] PICTURE '@R 9999999999999'      	   TYPE aAgendas[09,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[10,1]) } TITLE "Contato"         SIZE aAgendas[10,3] PICTURE PesqPict("SA1","A1_CONTATO")  TYPE aAgendas[10,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[11,1]) } TITLE "Data agenda"     SIZE aAgendas[11,3] PICTURE PesqPict("ZAF","f")  		   TYPE aAgendas[11,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[12,1]) } TITLE "Orçaamento"       SIZE aAgendas[12,3] PICTURE PesqPict("ZAF","ZAF_NUMORC")  TYPE aAgendas[12,2] ALIGN 1 OF oBrowse	
	ADD COLUMN oColumn DATA { || &(aAgendas[13,1]) } TITLE "Pedido"       	 SIZE aAgendas[13,3] PICTURE PesqPict("SC5","C5_NUM")  	   TYPE aAgendas[13,2] ALIGN 1 OF oBrowse	
	ADD COLUMN oColumn DATA { || &(aAgendas[14,1]) } TITLE "Nome vendedor"   SIZE aAgendas[14,3] PICTURE PesqPict("SA3","A3_NOME")     TYPE aAgendas[14,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[15,1]) } TITLE "Vlr.orçaamento"   SIZE aAgendas[15,3] PICTURE PesqPict("ZAF","ZAF_VLRORC")  TYPE aAgendas[15,2] ALIGN 2 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[16,1]) } TITLE "Data inc.agenda" SIZE aAgendas[16,3] PICTURE PesqPict("ZAF","ZAF_DATINC")  TYPE aAgendas[16,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[17,1]) } TITLE "Fone contato"    SIZE aAgendas[17,3] PICTURE PesqPict("SU5","U5_FCOM1")    TYPE aAgendas[17,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[18,1]) } TITLE "Tipo agenda"     SIZE aAgendas[18,3] PICTURE PesqPict("ZAD","ZAD_DESC")    TYPE aAgendas[18,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[19,1]) } TITLE "Hora Inc"  		 SIZE aAgendas[19,3] PICTURE PesqPict("ZAF","ZAF_HORINC")  TYPE aAgendas[19,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[20,1]) } TITLE "ID Agenda"       SIZE aAgendas[20,3] PICTURE PesqPict("ZAF","ZAF_ID")      TYPE aAgendas[20,2] ALIGN 1 OF oBrowse
	ADD COLUMN oColumn DATA { || &(aAgendas[21,1]) } TITLE "ID Pai"          SIZE aAgendas[21,3] PICTURE PesqPict("ZAF","ZAF_IDPAI")   TYPE aAgendas[21,2] ALIGN 1 OF oBrowse

	ACTIVATE FWFORMBROWSE oBrowse
	
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06VIS((cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->DATINC, (cTabAgen)->HORINC), oBrowse:SetFocus() }, "Visualizar"})
	aAdd(aButtons, {"EDITABLE", {|| FsFuncRet((cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->NUMORC, (cTabAgen)->ID) }, "Retornar ao CVI"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06DUP((cTabAgen)->FILIAL, (cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->DATINC, (cTabAgen)->HORINC, '', '', '', oBrowse, oDlg, @aRet, (cTabAgen)->ID, cTabAgen) }, "Retorno"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06NEW('', '', '', oBrowse), oBrowse:SetFocus() }, "Nova"})
	aAdd(aButtons, {"EDITABLE", {|| MATA410()}, "Pedidos de venda" })
	aAdd(aButtons, {"EDITABLE", {|| U_GDVA035()}, "Gdview Cli" })
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HIS((cTabAgen)->CLIENTE, (cTabAgen)->LOJA), oBrowse:SetFocus() }, "Hist.Cliente"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HAG((cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->IDPAI), oBrowse:SetFocus() }, "Hist.Agenda"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06HCL((cTabAgen)->CLIENTE, (cTabAgen)->LOJA, (cTabAgen)->NUMORC), oBrowse:SetFocus() }, "Hist.Orcamento"})
	aAdd(aButtons, {"EDITABLE", {|| U_TAG06LEG("G"), oBrowse:SetFocus() }, "Legenda"})
	//aAdd(aButtons, {"EDITABLE", {|| FsTime(@cTabAgen, oBrowse, @aTotais) }, "Refresh"})
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| oDlg:End() }, {|| oDlg:End() },,aButtons,,,, .F., .F., .F., .F., .F. ) centered
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, bOK, bCancel,, aButtons,,,, .F., .F., .F., .F., .F. ) centered
	
Return( Nil )

Static Function FSAgecli(cTabAgen, cAlias, cPriId)

	DbSelectArea(cAlias)
	Do While (cAlias)->(!Eof())
	
		DbselectArea(cTabAgen)
		Reclock(cTabAgen,.T.)
		(cTabAgen)->FLAG     := (cAlias)->FLAG
		(cTabAgen)->FILIAL   := (cAlias)->ZAF_FILIAL
		(cTabAgen)->CLIENTE  := (cAlias)->ZAF_CLIENT		
		(cTabAgen)->COLIGADA := (cAlias)->A1_XCOLIG
		(cTabAgen)->NOME_COLIG:= (cAlias)->Z6_DESCRI
		(cTabAgen)->LOJA     := (cAlias)->ZAF_LOJA
		(cTabAgen)->NOME     := (cAlias)->A1_NOME
		(cTabAgen)->CGC_CPF  := (cAlias)->A1_CGC
		(cTabAgen)->VENDEDOR := (cAlias)->A3_NOME
		(cTabAgen)->FONE_CLI := (cAlias)->A1_DDD+"-"+(cAlias)->A1_TEL
		(cTabAgen)->DATINC   := (cAlias)->ZAF_DATINC
		(cTabAgen)->DTAGEN   := (cAlias)->ZAF_DTAGEN
		(cTabAgen)->TPAGEN   := (cAlias)->ZAD_DESC
		(cTabAgen)->CONTATO  := (cAlias)->A1_CONTATO
		(cTabAgen)->FONE_CONT:= (cAlias)->U5_FCOM1
		(cTabAgen)->HORINC   := (cAlias)->ZAF_HORINC
		(cTabAgen)->NUMORC   := (cAlias)->ZAF_NUMORC
		(cTabAgen)->PEDIDO   := (cAlias)->UA_NUMSC5
		(cTabAgen)->VLRORC   := (cAlias)->ZAF_VLRORC
		(cTabAgen)->ID       := (cAlias)->ZAF_ID
		(cTabAgen)->IDPAI    := (cAlias)->ZAF_IDPAI
		Msunlock()
		(cAlias)->(DbSkip())
	EndDo
	(cTabAgen)->(DbGoTop())
	//cPriId:= (cTRB1)->ID 
	
Return( Nil )

//Solicitar novo tempo de atualizacao da tela - Refresh
Static Function goUpdTime(nTimerWin)
Local aParam := {}, xTime := 0

	__cmvPar01 := mv_par01
	xTime := nTimerWin

	While .T.
		
		IF PARAMBOX( { {1,"Tempo em segundos", xTime,"@E 999","Positivo()",,".T.",60,.F.}	;
						},"Alt.Tempo Refresh",@aParam,,,,,,,,.F.,.F.)

			if empty(mv_par01)
				APMSGALERT("O TEMPO NAO PODE SER ZERO. DIGITE NOVAMENTE.","DIGITAÇÃO TEMPO")
				loop
			else
				nTimerWin := mv_par01
				oTimer:nInterval := nTimerWin*1000
				exit
			endif
		Else
			exit
		Endif

	End
	mv_par01 := __cmvPar01

Return
