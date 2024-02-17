#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH" 
#include 'parmtype.ch'
#define DS_MODALFRAME   128
#DEFINE USADO CHR(0)+CHR(0)+CHR(1) 

#DEFINE  ENTER CHR(13)+CHR(10)
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IVENA020 ºAutor  ?Fabio Luiz Gesser  ?Data ? 01/03/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Montagem da interface de gestao de vendas                   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
//DESENVOLVIDO POR INOVEN - 11/02/2024

                               
Static Banco
Static cod_ativ
Static cod_banco  	    := Space(TamSx3("A1_BCO1")[1])
Static desc_ativ
Static cesc_ativ
Static cesc_banco
Static come_comprador   := ''
Static come_seguranca	:= '                                                             '//Space(TamSX3("A1_SEGUR") [1])
Static cig_contrato		:= CToD("  /  /  ")
Static cum_orca
Static _cDetalhe		:= ''

//Static _cBpCod_Fpg

// F_orcamento
Static oSayIOrc
Static __aHeaderEx  := {}
Static __aColsEx    := {}
Static aFieldFill   := {}                                                                                                                                                           
Static aFields      := {"UB_ITEM","UB_PRODUTO","UB_DESCRI","UB_QUANT","UB_VRUNIT","UB_VLRITEM","UB_DESC","UB_PRCTAB","UB_XPED","UB_XPEDIT","D2_VALICM","D2_ICMSRET","D2_VALIPI","D2_VALINS","D2_VALCOF","D2_VALCSL","D2_VALPIS","D2_VALBRUT","UB_XCOMIS","D2_BASEICM","UB_ZPRCDIG"}
Static aAlterFields := {"UB_QUANT", "UB_VRUNIT", "UB_XPED", "UB_XPEDIT","UB_XCOMIS"} 

// F_estoque
Static oSayEst
Static __aColsEst   := {}
Static __aHeadEst   := {}
Static aFldAEst	    := {"B2_COD"}
Static aFldEst	    := {"B2_COD", "B2_QATU", "B2_QPEDVEN", "B2_RESERVA", "B2_QEMP"}                                                                                     
Static aFldFest	    := {}

// F_Pedidos
Static oCliPed
STATIC aFldxPED  := {"C5_NUM", "C5_EMISSAO", "C5_PEDCLI", "C6_NOTA", "C6_DATFAT", "C5_ESPECI1", "C5_XDESST"}
Static aColsxPED := {}
Static aHeadxPED := {}
Static aFldAxPED := {}
Static aFldFxPED := {}

// Resumo cliente 12 ultimos meses
Static aHeade12m := {}
Static aFldA12m  := {"F2_VALMERC"}
Static aCols12m  := {}

Static cPEDCLI	:= '                                        '//Space(TamSX3("UA_PEDCLI") [1])
Static oPEDCLI
Static cobsexp
Static oobsexp
Static dEntreg	:= ddatabase
Static dAgenda	:= CToD("//")
Static oEntreg
Static oDtAgen	
Static dDtUser  := dDatabase
Static cHrUser  := substr(Time(), 1, 5)
Static nFldCoc  := 0

Static dGestor
Static cGestor
Static oGestor
Static oNomGestor
Static cNomGestor := " "
Static oCTpFrete
Static cCTpFrete  := ''//CTBCBOX("UA_XTPFRET")[1]

Static oGetTpOp    
Static oGetTabe
Static cCodTabAnt:= SUPERGETMV("HL_ZRTABELA" , .F., " ",)
Static _nDnyVlFrt   := 0
Static nDespesa := 0
Static nDescTota:= 0
Static cTplibera:= "2"
Static _nPrvFrt := 0	//Previsao de Frete

// Tela Geral
Static oSayCli01, oSayCli02, oSayCli03, oSayCli04, oSayCli05, oSayCli06, oSayCli07, oSayCli08, oSayCli09, oSayCli10, oSayCli11, oSayCli12, oSayCli13, oSayCli14
Static oSayCli15, oSayCli16, oSayCli17, oSayCli18, oSayCli19, oSayCli20, oSayCli21, oSayCli22, oSayCli23, oSayCli24, oSayCli25, oSayCli26, oSayCli27, oSayCli28
Static oSayCli29
//--Botões promoção
Static oButOrc11, oButPromo, oSayPromo
Static oButComis
Static oButAmo, oButPos

Static ocod_cli,  oloja_cli, onome_cli, oTipCli,  ocod_colig, oNome_colig,   ocod_atend, oNome_atend,oDtultcp, oStatus,   ocod_cnpj,      ocod_IE,   oTest_fat,     oPer_icms,  oMrcComl
Static oCidade,   oContrib,  o_Pis,     oCliDDD,     oFone_1,    oFone_2,    oEmail,   ocod_fpg,  oDes_forma_pgto,oPrz_medio,oPgto_especial,oDesc_marca,oStatBl
Static ocod_rep,  oNome_rep, ocod_trp,  oNome_transp,ocod_zona,  oEmail_nfe, oMobs_nfe,oObsfin,   oObsLog,        oObscob,   oCod_Por,   oLoja_Por, oGetVndD, oGetVend
Static oNome_Por, oTipPor,   oTraDDD,   oTraFone,  oTelCont,  oXdtrcad, oObjLote, oObjSim, oPedFat, oPedCom, oObjSim, oCliQNC, oCliPED, oCliIFAT

//Renato Bandeira em 06/10/14
Static oGetEndE
//Renato Bandeira em 28/11/14
Static oSegunUm

//Renato Bandeira em 18/12/14
Static dDtProgr	:= CTOD("  /  /  ")
Static oDtProgr
Static dDtProgr2:= CTOD("  /  /  ")
Static oDtProgr2
Static dDtProgr3:= CTOD("  /  /  ")
Static oDtProgr3
Static dDtProgr4:= CTOD("  /  /  ")
Static oDtProgr4

Static nVlrProg1:= 0
Static oVlrProg1
Static nVlrProg2:= 0
Static oVlrProg2
Static nVlrProg3:= 0
Static oVlrProg3
Static nVlrProg4:= 0
Static oVlrProg4

Static come_cli       := Space(TamSX3("A1_NOME") [1])
Static cTipCli        := Space(15)
Static cCod_por       := Space(TamSX3("A1_COD")  [1])
Static cLoja_por      := Space(TamSX3("A1_LOJA") [1])
Static cNome_por      := Space(TamSX3("A1_NOME") [1])
Static cod_colig      := Space(TamSX3("A1_XCOLIG")  [1])
Static come_colig     := Space(TamSX3("A3_NOME")  [1])
Static cTipPor        := Space(15)
Static cod_atend      := Space(TamSX3("A1_VEND")  [1])
Static come_atend     := Space(TamSX3("A3_NOME")  [1])
Static dDtUltCp       := Space(TamSX3("A1_ULTCOM")[1])
Static dXdtrcad       := '        '//Space(TamSX3("A1_XDTRCAD")[1])
Static cStatBl        := Space(17)
Static cStatus        := Space(15)
//Static cod_cnpj       := Space(TamSX3("A1_CGC")  [1])
Static cod_IE         := Space(TamSX3("A1_INSCR")[1])
Static cest_fat       := Space(TamSX3("A1_EST")  [1])
Static cer_icms       := Space(05)
//Static cMrcComl       := Space(TamSX3("A1_MRCOML") [1])
//Static cesc_marca     := Space(TamSX3("A1_MARCA")  [1])
Static cCidade        := Space(TamSX3("A1_MUN")    [1])
Static cContrib       := SPACE(3)//Space(TamSX3("A1_CONTRIB")[1])
Static c_Pis          := Space(01)
Static cCliDDD        := Space(TamSX3("A1_DDD")    [1])
Static cone_1         := Space(TamSX3("A1_TEL")    [1])
//Static cone_2         := Space(TamSX3("A1_TEL2")   [1])
Static cone_2         := Space(TamSX3("A1_TEL")    [1])
Static cEmail         := ''
Static cContFone	  := ''
Static cod_fpg        := Space(TamSx3("A1_COND")   [1])
Static ces_forma_pgto := Space(TamSx3("E4_DESCRI") [1])
Static crz_medio      := Space(01)
//Static cgto_especial  := Space(900)
Static cod_rep        := Space(TamSx3("A1_VEND")  [1])
Static come_rep       := Space(TamSX3("A3_NOME")  [1])
Static cod_trp        := Space(TamSx3("A1_TRANSP")[1])
Static cod_Redesp     := Space(TamSx3("A1_TRANSP")[1])
Static come_transp    := Space(TamSx3("A4_NOME")  [1])
Static come_Redesp    := Space(TamSx3("A4_NOME")  [1])
Static cod_zona       := Space(01)
Static cmail_nfe      := Space(TamSX3("A1_EMAIL") [1])
Static cTraDDD        := Space(TamSX3("A4_DDD")   [1])
Static cTraFone       := Space(TamSX3("A4_TEL")   [1])
Static cObsfin        := Space(900)
Static cObslog        := Space(900)
Static cObscob        := Space(900)

// Resumo Cliente
STATIC oPanel01, oPanel02, oPanel03, oPanel04, oPanel05, oPanel06, oPanel07, oPanel08, oPanel09, oPanel10, oPanel11, oPanel12, oPanel13,oPanel14,oPanel15
STATIC oSayRes01, oSayRes02, oSayRes03, oSayRes04, oSayRes05, oSayRes06, oSayRes07, oSayRes08, oSayRes09, oSayRes10, oSayRes11, oSayRes12, oSayRes13
Static oLCrdT, oLNCC, oLCrd, oVMargem, oVMarInd, oVatrazo, oVMaior, oVQuant, oVSupre, oQSupre, oHSupre, oVEssen, oQEssen, oHEssen, oVFat12m, oFat12m

Static nLCrdT  := 0.00
Static nLCNCC  := 0.00
Static nLCrd   := 0.00
Static nVMargem:= 0.00
Static nVMarInd:= 0.00
Static nVatrazo:= 0.00
Static nVMaior := 0.00
Static nVQuant := 0
Static nVSupre := 0.00
Static nQSupre := 0.00
Static nHSupre := 0.00
Static nVEssen := 0.00
Static nQEssen := 0.00
Static nHEssen := 0.00
Static nFat12m := 0.00

// Orcamento
Static oSayOrc01, oSayOrc01, oSayOrc03, oSayOrc04, oSayOrc05, oSayOrc06, oSayOrc07, oSayOrc08, oSayOrc09, oSayOrc10, oSayOrc11
Static oButOrc1, oButOrc2, oButOrc3, oButOrc4, oButOrc5, oButOrc6, oButOrc7, oButOrc8, oButOrc9, oButOrc10
Static oCod_produto, UM, preco_1, preco_2, oCodCA, perc_icm, perc_ipi, oQtde, oPreco, oPedxCli, oPedxIte, oDesc, oTotal, desc_nfe, desc_comercial, onum_orc
Static oVDesc, oDescT
Static oTotPV

Static gCod_produto   := Space(TamSX3("B1_COD") [1])
Static cM             := Space(TamSX3("B1_UM")  [1])
Static creco_1        := 0.00
Static creco_2        := 0.00
//Static cCodCA         := '      '//Space(TamSX3("B1_CA")  [1])
Static cerc_icm       := Space(TamSX3("B1_PICM")[1])
Static cerc_ipi       := Space(TamSX3("B1_IPI") [1])
Static nQtde          := 0 //0.00
Static nPrecoAnt      := 0.00
Static nDescT		  := Space(TamSX3("UB_DESC")[1])	// usado para mostra a porcentagem na Tela
Static nVDesc		  := 0.00
Static nTotItem       := 0.00
Static nTotalPV		  := 0.00
Static cSegunUm		  := space(10)
Static cPedxCli       := Space(TamSX3("C6_NUMPCOM")[1])
Static cPedxIte       := Space(TamSX3("C6_ITEMPC") [1])
Static cesc_nfe       := Space(TamSX3("B1_DESC")   [1])
Static cesc_comercial := Space(TamSX3("A1_NOME")[1])                                                                                      

// Historico de Cliente
Static oSayCod, oGetCod, oSayLoj, oGetLoj, oSayCli, oGetCli, oGetHis, oFonteS
Static oHcod_cli,  oHloja_cli, oHnome_cli
Static oButHis1, oButHis2
Static aHeadHist := {}
Static aFldHist  := {"ZB_DTHIST","ZB_HORA","ZC_DESCRIC","ZB_USER","ZB_CONTATO","ZB_DTAGEN","ZB_FORMA","A3_NOME","ZB_CELULA"}
Static aColsHist := {}

// Contatos do cliente
Static oSaynCCod, oGetCCod, oSayCLoj, oGetCLoj, oSayCCli, oGetCCli, oGetCon
Static oCcod_cli,  oCloja_cli, oCnome_cli
Static oButCon1, oButCon2
Static aHeadCont := {}
Static aFldCont  := {"U5_CODCONT","U5_CONTAT","U5_EMAIL","U5_DDD","U5_FONE","U5_CELULAR","U5_FAX","U5_FCOM1","U5_FCOM2","QB_DESCRIC","UM_DESC"}
Static aColsCont := {}

//--Helder Santos 
Static aHeadSCV := {}
Static aColsSCV	:= {}
Static lGravou	:= .F.
Static __lProsp	:= .F.

//Static oMargem1, oMargem2, oMargem3, oMargem4
Static oMargem1
Static oSayMarg
Static nSayMarg := 0

User Function IVENA020(cCLiAgen, cLojaAge, nCodOrc, cIdPai) 

	//Local cArqTRB	   := ""
	//Local nX 		   := 0
	//Local nOpca		   := 0
	Local aSizeAut 	   := MsAdvSize()
	Local aObjects	   := {}
	Local aInfo 	   := {}
	Local aPosObj	   := {}
	Local aTitles 	   := {}
	Local aButtons 	   := {}
	//Local aListColumns := {}
	//Local aTitulo 	   := {}
	//Local bOk
	//Local bCancel
	//Local oList
	//Local aArea
	//Local nSaveSX8     := GetSX8Len()
	Local lContx       := .T.
	Local bCancel 	   := {|| lContx:=.F., oDlgVendas:End() }
	//--Vencimentos
	Private dVenc1 := CTOD("  /  /  ")	
	Private dVenc2 := CTOD("  /  /  ")
	Private dVenc3 := CTOD("  /  /  ")
	Private dVenc4 := CTOD("  /  /  ")
	Private oDVenc1:= Nil
	Private oDVenc2:= Nil	
	Private oDVenc3:= Nil		
	Private oDVenc4:= Nil
	Private nParc1 := 0
	Private nParc2 := 0
	Private nParc3 := 0
	Private nParc4 := 0
	Private nDias1 := 0
	Private nDias2 := 0
	Private nDias3 := 0
	Private nDias4 := 0
	Private oParc1 := 0
	Private oParc2 := 0
	Private oParc3 := 0
	Private oParc4 := 0
	Private oDias1 := 0
	Private oDias2 := 0
	Private oDias3 := 0
	Private oDias4 := 0

	Private _cCod_EndE  := Space(4)
	Private _lBotaoGrvOrc  := .t.

	//Renato Bandeira em 27/02/15
	Private _lPedBotaoGrv  := .t.

	//Renato Bandeira em 31/10/14
	Private	_cBlqTabPrc	:=	""
	Private	__HLTABPADR	:=	PadR(SUPERGETMV("HL_ZRTABELA", .F., "  ",),TamSX3('A1_TABELA')[1])
	Private	__HLOPERCOM	:=	PadR(SUPERGETMV("HL_OPERCOM" , .F., "10",),02)
	Private	__HLPRODCOM	:=	PadR(SUPERGETMV("HL_PRODCOM" , .F., "000007",),25)
	
	//Renato Bandeira em 30/10/14
	Private bfDeleta := {|| fDeleta()}
	//Private __aLTabDesc := u_HLRetLstDesc()
	Private	nPreco		:=	0	
	Private aListBKPr 	:= {}
	Private cTabeBKPr 	:= ''	
	Private nPrcTab_A	:=	0.00
	Private nTotComiss  :=  0.00
	Private _nTotTabe   :=  0.00
	Private _nTotFina   :=  0.00	
	Private _nTTotFim   :=  0.00	
	Private cCocAdm	    := SUPERGETMV("DN_COCADM" , .T., "",)
	Private cProd_Ant   := Space(TamSX3("B1_COD") [1])  // Variavel conter?o ultimo produto digitado, servir?para consulta
	Private coja_cli   	:= "0001"	//"0001"
	Private cod_cli     := Space(TamSx3("A1_COD") [1])
	Private cod_cnpj     := Space(TamSx3("A1_CGC") [1])
	Private oTipo
	Private oDlgVendas
	Private oFolder
	Private oOrcamento
	//Private oVFat12m
	//Private oFat12m
	Private oEstoque	
	//Private oPedCom
	//Private oPedFat
 	//Private oCliIFAT
	Private cum_orc	   := Space(TamSX3("C5_NUM")[1])
	Private aTela[0][0],aGets[0]
	Private lLocRes	   := .F.	// Utilizada na inclusao no X3_WHEN do campo JA1_LOCINS
	Private cMarca     := GetMark()
	Private aLugar     := { "", "", "", "" }
	//Private onum_orc
	//Private gCod_produto   := Space(TamSX3("B1_COD") [1])
	//Private cod_trp        := Space(TamSX3("A4_COD") [1])		
	Private lProspect  := .F.
	Private lProsp	   := .F.
	Private cUSRVen    := ""
	Private __aCAux3   := {}
	Private oGraphic1,oGraphic2,oGraphic3,oGraphic4,oCBX
	Private __aCAuxOrc := {}
	Private	__aCEstAux := {}        
	Private cXFRECIF   := 0           	
	Private _lAltSE4   := .T.                                                                                                                     
	Private _nAltSE4   := 0
	Private oGetCnd
	Private oGetI
	
	//Private oGetTpOp    
	Private cCTpOper  := CTBCBOX("UA_XTOPER")[01] //SuperGetMv("DN_TPOPER")//+"="+"Vendas"
	Private aDTpOper  := CTBCBOX("UA_XTOPER")
	   
	Private _cBpCod_Fpg := ''
	
	Private oGetDad := Nil              
	
	Private nFldCokPit
	
	// Variaveis Condicao Negociada - Gabriel Gonçalves
	Private oSayCNCli, oGetCNCod, oGetCNLoj, oGetCNCli, oSayCNVTot, oGetCNVTot, oSayCNVUti, oGetCNVUti, oSayCNMaxP, oGetCNMaxP, oSayCNMinP, oGetCNMinP, oSayCNDife,oGetCNDife, oSayCNCred
	Private cCNCod_Cli, cCNLoja_Cli, cCNNomeCli, nCNVal_Tot, nCNVal_Uti, nCNMax_Par, nCNMin_Par, nCNCre_Cli, nCNDif_Par
	Private oGetConNe
	
	//--Variaveis [Promoção]
	Private oPromocoes  := Nil   		
	Private cProdProm	:= ''   
	Private aHeadProm	:= {}
	Private aColsProm	:= {}
	Private aItensPro	:= {}
	Private aPrdCProm	:= {}
	
	Private oComissao	:= NIl
	Private aColsComis	:= {}
	Private aHeadComis	:= {}

	//Para impressão da DANFE
	Private aFilBrw     := {}

	Public cCodTab  := SUPERGETMV("HL_ZRTABELA" , .F., "",)
	
	DEFAULT cCLiAgen:= ''
	DEFAULT cLojaAge:= ''
	DEFAULT nCodOrc := ''
	DEFAULT cIdPai  := ''
	
	Private lParVldC:= .F.

	//Campo margem por item
	if __cUSERID $ SUPERGETMV("IN_VISMARG" , .T., "000000",)
		aadd(aFields,"C6_ZMARGPP")
	endif
	 	   
	cCodTab   := GETMV("HL_ZRTABELA",.F.,'  ')
	cCodTabAnt:= GETMV("HL_ZRTABELA",.F.,'  ')
	
	INCLUI   := .T.
	ALTERA   := .T.

	aCols    := {}
	aHeader  := {}

	cUSRVen  := U_QRYFILTRO()

	cum_orca := cum_orc
	nFolder  := 3

	aAdd( aTitles, "Dados do Cliente")
	aAdd( aTitles, "Resumo Cliente")
	aAdd( aTitles, "Orçamento")
	aAdd( aTitles, "Históricos")
	aAdd( aTitles, "Contatos")
	aAdd( aTitles, "Condição Negociada")
	If !Empty(cCocAdm)
		aAdd( aTitles, "Cockpit do Vendedor" )
		nFldCokPit	:= Len(aTitles)
	Endif

	aAdd( aObjects, { 200, 200, .T., .T. })
	aAdd( aObjects, { 130, 130, .T., .T. })

	aInfo   := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )

	cPerg   := Padr("PERCOCKPIT",10)
	U_FUPDSX1(cPerg)
	
	SetKey(VK_F1,{||U_IMPBOL()})
	SetKey(VK_F2, {||DnyDFIMCOT(cod_cli,coja_cli,lProsp,cod_fpg,@_cBpCod_Fpg,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]))})
	SetKey(VK_F3,{||U_IFATM002()})
	SetKey(VK_F4, {||FALTDADO(lProsp),SetFocus(7035)})
	SetKey(VK_F5, {||u_IVENA040(lProsp,cod_cli,coja_cli)})
	SetKey(VK_F6, {||u_ftransp()})
	//SetKey(VK_F7, {||FCONPCLI(cod_cli,coja_cli)}) 
	SetKey(VK_F7, {||MsgRun("Aguarde Listando Tab. de Preço...",,{||u_xF3DA0_2()}) })
	SetKey(VK_F8, {||u_IVENR010()}) 
	SetKey(VK_F9, {||u_IVENR020(3)})
	SetKey(VK_F10,{||u_IVENR020(2)})
	If !Empty(cCocAdm)
		SetKey(VK_F11,{||MsgRun("Aguarde Processando Cockpit...",,{||u_DnyCockP(oFolder:aDialogs[nFldCokPit])})})
	Endif
	SetKey(VK_F12,{||Pergunte(cPerg,.T.)})
	
	aAdd(aButtons,{"SIMULACA",{||U_IMPBOL()}                                                                   ,"<F1> Boletos Inovem"})
	aAdd(aButtons,{"OBJETIVO",{||DnyDFIMCOT(cod_cli,coja_cli,lProsp,cod_fpg,@_cBpCod_Fpg,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@_nAltSE4)} ,"<F2>  Dados Finais da Cotação"})
	aAdd(aButtons,{"SIMULACA",{||U_IFATM002()}                                                          		,"<F3> Imprimir Danfe"})
	aAdd(aButtons,{"EDITABLE",{||FALTDADO(lProsp),SetFocus(7035)}                                               ,"<F4>  Grava Alteração dos Dados do Cliente"})
	aAdd(aButtons,{"DESTINOS",{||u_IVENA040(lProsp,cod_cli,coja_cli)}                                          ,"<F5>  Endereços do Cliente"})
	aAdd(aButtons,{"DESTINOS",{||u_ftransp()}                                                                   ,"<F6>  Transportadoras"})
	//aAdd(aButtons,{"SIMULACA",{||FCONPCLI(cod_cli,coja_cli)}                                                  ,"<F7>  Consulta Posição do Cliente"}) 
	aAdd(aButtons,{"SIMULACA",{||MsgRun("Aguarde Listando Tab. de Preço...",,{||u_xF3DA0_2()})} 				,"<F7>  Consulta Tabela de Preço x Estoque"})

	aAdd(aButtons,{"SIMULACA",{||u_IVENR010()}                                                                    ,"<F8>  Imprime Orçamento"})
	aAdd(aButtons,{"SIMULACA",{||u_IVENR020(3)}                                                                   ,"<F9>  Status Pedido"})
	aAdd(aButtons,{"SIMULACA",{||U_IVENR020(2)}                                                                   ,"<F10> Imprime Pedido"})
   //	aAdd(aButtons,{"SIMULACA",{||U_IVENR020(1)}                                                                   ,"<F15> Imprime Pedido"})
	
	If !Empty(cCocAdm)
		aAdd(aButtons,{"SIMULACA",{||MsgRun("Aguarde Processando Cockpit...",,{||u_DnyCockP(oFolder:aDialogs[nFldCokPit])})} ,"<F11> Processa Cockpit do Vendedor"})
	Endif
	aAdd(aButtons,{"SIMULACA",{||Pergunte(cPerg,.T.)}                                                           ,"<F12> Parametros Gerais"})
	
	aAdd(aButtons,{"SIMULACA",{||u_IVENR030()}                                                                    ,"Envia Pedido Por E-Mail a Cliente"})
	aAdd(aButtons,{"SIMULACA",{||u_dny004()}                                                                    ,"Envia Orçamento Por E-Mail a Cliente"})
	aAdd(aButtons,{"DESTINOS",{||u_famarra()}                                                                   ,"Amarração Produto x Cliente"})
	//aAdd(aButtons,{"DESTINOS",{||u_Dny001()}                                                                  ,"Relatório de Históricos"})
	aAdd(aButtons,{"DESTINOS",{||u_Dny002()}                                                                  ,"Relatório Status de Pedido"})
	aAdd(aButtons,{"DESTINOS",{||MATR580()}                                                                     ,"Relatório Ranking"})
	aAdd(aButtons,{"DESTINOS",{|| MPReport('REL_SA1_ATIVO',"SA1","Relacao de Clientes","Este relatório ir?imprimir a relacao de clientes",,.T.)   		 }                    ,"Relatório Clientes Ativos"})
	aAdd(aButtons,{"DESTINOS",{||u_DEN05R03()}                                                                  ,"Relatório Promoções"})
	aAdd(aButtons,{"DESTINOS",{||u_IVENR040()}                                                                  ,"Liberação de Pedidos"})
	aAdd(aButtons,{"DESTINOS",{||SpedDanfe()}                                                                   ,"DANFE"})
	aAdd(aButtons,{"DESTINOS",{||u_IFATM050()}                                                                  ,"Exportar XML"})
		
	Do WHILE lContx
		INCLUI   := .T.
		ALTERA   := .T.

		aCols    := {}
		aHeader  := {}
	
		coja_cli := "0001"
		cod_cli  := Space(TamSx3("A1_COD") [1])
		
		DEFINE MSDIALOG oDlgVendas TITLE OemToAnsi("Gestão de Vendas") FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL Style DS_MODALFRAME

		If valtype(oFolder) == "O"
			FreeObj(oFolder)
		EndIf   
		aTitles := {}
		aAdd( aTitles, "Dados do Cliente")
		aAdd( aTitles, "Resumo Cliente")
		aAdd( aTitles, "Orçamento")
		aAdd( aTitles, "Históricos")
		aAdd( aTitles, "Contatos")
		aAdd( aTitles, "Condição Negociada")
		If !Empty(cCocAdm)
			aAdd( aTitles, "Cockpit do Vendedor" )
			nFldCokPit	:= Len(aTitles)
		Endif

		oFolder  := TFolder():New(aPosObj[1,1],aPosObj[1,2],aTitles,{} ,oDlgVendas,,,, .T., .F.,aPosObj[1,4],aPosObj[2,4])
		oFolder:bSetOption := {|nNewOption| fTotConNeg(nNewOption) }

		//////// Tela Dados do Cliente
		//@ C(005), C(005) SAY oSayCli01  PROMPT "Cliente:"		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(005), C(005) SAY oSayCli08  PROMPT "CNPJ:"			SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(020), C(005) SAY oSatCli02  PROMPT "Prospect:"      SIZE C(045), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(035), C(005) SAY oSayCli03  PROMPT "Sit.Cliente:"	SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(035), C(145) SAY oSayCli04  PROMPT "Sit.Compra:"   	SIZE C(045), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(050), C(005) SAY oSayCli05  PROMPT "Atendente:"		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(050), C(145) SAY oSayCli06  PROMPT "Dta Ult.Cp.:"  	SIZE C(045), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(050), C(280) SAY oSayCli07  PROMPT "Dta Cad.:"     	SIZE C(045), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		//@ C(065), C(005) SAY oSayCli08  PROMPT "CNPJ:"			SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(065), C(005) SAY oSayCli01  PROMPT "Cliente:"		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(065), C(145) SAY oSayCli09  PROMPT "IE:"			SIZE C(010), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(065), C(280) SAY oSayCli10  PROMPT "Est.Fat.:"		SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(080), C(005) SAY oSayCli11  PROMPT "ICMS %:"		    SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(080), C(145) SAY oSayCli12  PROMPT "M.Coml.:"		    SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(080), C(280) SAY oSayCli13  PROMPT "M.Logis:"		    SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(095), C(005) SAY oSayCli14  PROMPT "Cidade:"   		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(095), C(145) SAY oSayCli15  PROMPT "Contrib.:" 		SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(095), C(280) SAY oSayCli16  PROMPT "PIS/COFINS:"	    SIZE C(040), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(110), C(005) SAY oSayCli17  PROMPT "Telefones:"		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		
		@ C(110), C(220) SAY oSayOrc13  PROMPT "Coligada:" 		SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(125), C(005) SAY oSayCli18  PROMPT "E-Mail:"   		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(140), C(005) SAY oSayCli19  PROMPT "Form. Pg.:"		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(140), C(145) SAY oSayCli20  PROMPT "Prz. Medio:"	    SIZE C(065), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(155), C(005) SAY oSayCli21  PROMPT "Repres.:" 		SIZE C(035), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(170), C(005) SAY oSayCli22  PROMPT "Transp.: " 		SIZE C(045), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(170), C(285) SAY oSayCli23  PROMPT "Zona:"			SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(185), C(005) SAY oSayCli24  PROMPT "Telefone:"    	SIZE C(040), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		
		@ C(185), C(145) SAY oSayCli29  PROMPT "Contato:"    	SIZE C(040), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(200), C(005) SAY oSayCli25  PROMPT "Email NFE:" 	SIZE C(040), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(215), C(005) SAY oSayOrc13  PROMPT "Orçamento:" 	SIZE C(030), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		@ C(004), C(355) SAY oSayCli26  PROMPT "Obs Financeira"   SIZE C(105), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(081), C(355) SAY oSayCli27  PROMPT "Obs Logistica" 	SIZE C(105), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
		@ C(158), C(355) SAY oSayCli28  PROMPT "Obs Comercial"	SIZE C(105), C(009) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

		DnyCarCli(@oDlgVendas,@oFolder)

		//////// Resumo de Cliente
		@ C(003),C(003) MSPANEL oPanel01 PROMPT "Limite de Crédito"                             SIZE C(638),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(017),C(003) MSPANEL oPanel02                                                        SIZE C(638),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(042),C(003) MSPANEL oPanel03 PROMPT "Atraso de Duplicatas"                          SIZE C(638),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(056),C(003) MSPANEL oPanel04                                                        SIZE C(638),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(081),C(003) MSPANEL oPanel05 PROMPT "Margem Indexada Acumulado dos 2 Ultimos Meses" SIZE C(313),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(095),C(003) MSPANEL oPanel06                                                        SIZE C(313),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(081),C(317) MSPANEL oPanel07 PROMPT "Margem Indexada do Ultimo Pedido"              SIZE C(325),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(095),C(317) MSPANEL oPanel08                                                        SIZE C(325),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(120),C(003) MSPANEL oPanel09 PROMPT "Numero de Itens Suprema nos Ultimos 90 Dias"   SIZE C(313),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(134),C(003) MSPANEL oPanel10                                                        SIZE C(313),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(120),C(317) MSPANEL oPanel11 PROMPT "Numero de Itens Essencial Nos Ultimos 90 Dias" SIZE C(325),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(134),C(317) MSPANEL oPanel12                                                        SIZE C(325),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED
        
		@ C(159),C(003) MSPANEL oPanel13 PROMPT "Faturamento Total Ultimos 12 Meses"            SIZE C(638),C(014) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED
		@ C(173),C(003) MSPANEL oPanel14                                                        SIZE C(638),C(020) OF oFolder:aDialogs[2] COLORS 0, 14215660          RAISED

		@ C(200),C(003) MSPANEL oPanel15 PROMPT "Compras Ultimos 12 Meses"                      SIZE C(638),C(009) OF oFolder:aDialogs[2] COLORS 0, 14215660 CENTERED RAISED

		@ C(006),C(010) SAY oSayRes01  PROMPT "Disponível:"                             SIZE C(030),C(009) OF oPanel02 COLORS 0, 16777215 PIXEL
		@ C(006),C(240) SAY oSayRes06  PROMPT "Limite Total:" 		                    SIZE C(060),C(009) OF oPanel02 COLORS 0, 16777215 PIXEL  //LEANDRO.EBER 01/09/2016
		@ C(006),C(440) SAY oSayRes02  PROMPT "Carta de Crédito:"                       SIZE C(060),C(009) OF oPanel02 COLORS 0, 16777215 PIXEL

		@ C(006),C(010) SAY oSayRes03  PROMPT "Valor:"                                  SIZE C(060),C(009) OF oPanel04 COLORS 0, 16777215 PIXEL
		@ C(006),C(240) SAY oSayRes04  PROMPT "Maior Atraso:"                           SIZE C(060),C(009) OF oPanel04 COLORS 0, 16777215 PIXEL
		@ C(006),C(440) SAY oSayRes05  PROMPT "Total de Titulos:"                       SIZE C(060),C(009) OF oPanel04 COLORS 0, 16777215 PIXEL
        
        @ C(006),C(105) SAY oSayRes09  PROMPT "Quantidade:"                             SIZE C(060),C(009) OF oPanel10 COLORS 0, 16777215 PIXEL
		@ C(006),C(220) SAY oSayRes10  PROMPT "Historico:"                              SIZE C(060),C(009) OF oPanel10 COLORS 0, 16777215 PIXEL
		
		@ C(006),C(105) SAY oSayRes12  PROMPT "Quantidade:"                             SIZE C(060),C(009) OF oPanel12 COLORS 0, 16777215 PIXEL
		@ C(006),C(220) SAY oSayRes13  PROMPT "Historico:"                              SIZE C(060),C(009) OF oPanel12 COLORS 0, 16777215 PIXEL

		DnyResCli(@oDlgVendas,@oFolder)

		//////// Tela do Orcamento
		@ C(005),C(005) SAY oSayOrc01 PROMPT "Produto" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
         
		@ C(020),C(005) SAY oSayOrc05 PROMPT "IPI%" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(020),C(075) SAY oSayOrc03 PROMPT "ICMS %" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
				
		@ C(036),C(005) SAY oSayFim14 PROMPT "Tp Oper."		 SIZE C(060), C(009) 	OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(036),C(105) SAY oSayOrc11 PROMPT "Ped.Cliente:"  SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(036),C(190) SAY oSayOrc12 PROMPT "Item Ped.Cli:" SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		
		@ C(036),C(275) SAY oSayOrc12 PROMPT "2a.Un:"   	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(140),C(005) SAY oSayOrc07 PROMPT "Qtde" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(120),C(005) SAY oSayOrc07 PROMPT "Qtde" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(110),C(005) SAY oSayOrc07 PROMPT "Qtde" 		 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL

		//oMargem1 := TBitmap():New(C(120),C(140),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		//oMargem1:lAutoSize := .T.
		//oMargem2 := TBitmap():New(C(120),C(158),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		//oMargem2:lAutoSize := .T.
		//oMargem3 := TBitmap():New(C(120),C(176),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		//oMargem3:lAutoSize := .T.
		//oMargem4 := TBitmap():New(C(120),C(194),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		//oMargem4:lAutoSize := .T.
		//oMargem1 := TBitmap():New(C(120),C(194),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		//oMargem1:lAutoSize := .T.
		oMargem1 := TBitmap():New(C(110),C(194),36,36,,"web\images\margem_no.png",.T.,oFolder:aDialogs[3],,,.F.,.F.,,,.F.,,.T.,,.F.)
		oMargem1:lAutoSize := .T.


		//@ C(140),C(255) SAY oSayOrc13 PROMPT "Total PV:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(155),C(255) SAY oSayOrc13 PROMPT "Descto (%):" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(235),C(410) SAY oSayOrc13 PROMPT "Total PV:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(235),C(520) SAY oSayOrc13 PROMPT "Descto (%):" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(235),C(005) SAY oSayOrc13 PROMPT "Vlr Descto:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(235),C(124) SAY oSayOrc13 PROMPT "Total PV:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(235),C(234) SAY oSayOrc13 PROMPT "Descto (%):" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		//@ C(225),C(005) SAY oSayOrc13 PROMPT "Vlr Descto:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(225),C(124) SAY oSayOrc13 PROMPT "Total PV:" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		@ C(225),C(234) SAY oSayOrc13 PROMPT "Descto (%):" 	 SIZE C(030),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
		
		DnyOrcam(@oDlgVendas, @oFolder, @cCTpOper)

		//////// Tela de Hitorico
		@ C(005),C(005) SAY oSayCli01  PROMPT "Cliente:"		 SIZE C(035),C(009) OF oFolder:aDialogs[4] COLORS 0, 16777215 PIXEL
		DnyHisto(@oDlgVendas, @oFolder)

		//////// Tela de Contatos
		@ C(005),C(005) SAY oSayCli01  PROMPT "Cliente:"		 SIZE C(035),C(009) OF oFolder:aDialogs[5] COLORS 0, 16777215 PIXEL
		DnyConta(@oDlgVendas, @oFolder)

		//////// Tela de Condição Negociada
		U_IVENA030(@oDlgVendas, @oFolder, @oSayCNCli, @oGetCNCod, @oGetCNLoj, @oGetCNCli, @oSayCNVTot, @oGetCNVTot, @oSayCNVUti, @oGetCNVUti, @oSayCNMaxP, @oGetCNMaxP, @oSayCNMinP, @oGetCNMinP, @cCNCod_Cli, @cCNLoja_Cli, @cCNNomeCli, @nCNVal_Tot, @nCNVal_Uti, @nCNMax_Par, @nCNMin_Par, @oGetConNe,@nCNDif_Par,@nCNCre_Cli)
				
		If !Empty(cCLiAgen) .And. !Empty(cLojaAge) .And. IsInCallStack("U_IVENA010")
			
			//posiciona no cliente
			SA1->(dbSetOrder(1))
			SA1->(msSeek(xFilial('SA1') + cCLiAgen + cLojaAge))
			
			cod_cnpj := SA1->A1_CGC
			coja_cli := cLojaAge
			cod_cli  := cCLiAgen
			oCod_cnpj:Disable()
			oCod_cli:Disable()
			oLoja_cli:Disable()
			lParVldC := .T.
		
			// Duplicatas de atraso
			cQuery := "SELECT SUM(SE1.E1_SALDO) AS E1SALDO, COUNT(*) AS E1QTDDUP, MIN(SE1.E1_VENCTO) AS E1ATRZ "
			cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
			//cQuery += "WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"' "
			cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
			cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
			cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
			cQuery += "AND   SE1.E1_SALDO   > 0 "
			//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase)+"' "    //wap.o
			//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase - 4)+"' " 		//wap.n 	//ppl.o
			cQuery += "AND   SE1.E1_VENCREA  <= '"+DTOS(DataValida(dDatabase, .T.) - SUPERGETMV("FS_DIASRET" , .T., 2,)	 )+"' " 	 	//ppl.o
			cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) AND SE1.E1_SITUACA <> '2' "
			cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
			
			TcQuery cQuery New Alias "CRE"
			TCSetField("CRE", "E1ATRZ" , "D",08,0)
			
			dbSelectArea("CRE")
			DBGOTOP()
			IF !Eof()
				IF CRE->E1QTDDUP > 0
					Alert("Atenção, o Cliente possui R$ " +Alltrim(Transform(CRE->E1SALDO, "@E 999,999,999,999.99")) + " de atraso. Verifique!")	
				ENDIF
			ENDIF
			
			If Select("CRE") > 0
				dbSelectArea("CRE")
				dbCloseArea()
			EndIf
			
			If POSICIONE("SA1",1,XFILIAL("SA1")+ALLTRIM(cod_cli)+ALLTRIM(coja_cli),"A1_COND") == '003'
				Alert("Cliente com condição de Pgto somente Antecipado!")
			Endif
					
		EndIf
		
		If !Empty(nCodOrc) .And. IsInCallStack("U_IVENA010")
			cum_orc:= nCodOrc
			onum_orc:SetFocus()				
		EndIf
		
		//ACTIVATE MSDIALOG oDlgVendas ON INIT EnchoiceBar(oDlgVendas,{|| IIF(DnyDFIMCOT(cod_cli,coja_cli,lProsp,cod_fpg,@_cBpCod_Fpg,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@_nAltSE4),(lContx:=.T.,oDlgVendas:End()),lContx:=.F.)}, {|| oDlgVendas:Refresh(), lContx:=.F., oDlgVendas:End()},,aButtons)
		ACTIVATE MSDIALOG oDlgVendas ON INIT EnchoiceBar(oDlgVendas,{|| IIF(DnyDFIMCOT(cod_cli,coja_cli,lProsp,cod_fpg,@_cBpCod_Fpg,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@_nAltSE4, cIdPai),(lContx:=.T.,oDlgVendas:End()),lContx:=.F.)}, bCancel ,,aButtons)

		DNYLIMPVAR(1,@lContx)
		
	EndDo

Return(Nil)

Static Function DnyCarCli(oDlgVendas, oFolder)
**********************************************
	
	chkFile('SA1')
	SA1->(dbGoTop())

	IF VALTYPE(oCod_cli) <> "U"

		FreeObj(onum_orc)

		FreeObj(oCod_cli)
		FreeObj(oLoja_cli)
		FreeObj(oNome_cli)
		FreeObj(oTipCli)

		FreeObj(oCod_por)
		FreeObj(oLoja_por)
		FreeObj(oNome_por)
		FreeObj(oTippor)

		FreeObj(oStatbl)
		FreeObj(oStatus)

		FreeObj(oCod_atend)
		FreeObj(oNome_atend)
		FreeObj(oDtultcp)
		FreeObj(oXdtrcad)

		FreeObj(oCod_cnpj)
		FreeObj(oCod_IE)
		FreeObj(oTest_fat)

		FreeObj(oPer_icms)
		FreeObj(oMrcComl)
		FreeObj(oDesc_marca)

		FreeObj(oCidade)
		FreeObj(oContrib)
		FreeObj(o_Pis)
   
		FreeObj(oCliDDD)
		FreeObj(oFone_1)
		FreeObj(oFone_2)

		FreeObj(oEmail)

		FreeObj(oCod_fpg)
		FreeObj(oDes_forma_pgto)
		FreeObj(oPrz_medio)

		FreeObj(oCod_rep)
		FreeObj(oNome_rep)

		FreeObj(oCod_trp)
		FreeObj(oNome_transp)
		FreeObj(oCod_zona)

		FreeObj(oTraDDD)
		FreeObj(oTraFone)

		FreeObj(oEmail_nfe)

		FreeObj(oObsfin)
		FreeObj(oObsLog)
		FreeObj(oObscob)

		FreeObj(oButAmo)
		FreeObj(oButPos)

		FreeObj(oGetVend)
		FreeObj(oGetVndD)				

		FreeObj(oGetEndE)
		FreeObj(oGetEndE)
	Endif
	
	//@ C(004), C(042) MSGET 	oCod_cli 		VAR cod_cli 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3('SA1_2') PIXEL Valid( xVldCltDny(@cod_cli, @coja_cli) ) HASBUTTON	
	@ C(004), C(042) MSGET 	oCod_cnpj  		VAR cod_cnpj 		SIZE C(070), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3('SA1_2') PIXEL Valid( xVldCltDny(@cod_cnpj) ) .and. If( !DnyDadCli(1), oCod_cnpj:SetFocus() ,.T.) HASBUTTON	
	
	//@ C(004), C(090) MSGET 	oLoja_cli 		VAR coja_cli		SIZE C(015), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 VALID If( !DnyDadCli(1), oCod_cli:SetFocus() ,.T.) PIXEL
	@ C(004), C(125) MSGET 	oNome_cli 		VAR come_cli 		SIZE C(141), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(004), C(280) MSGET 	oTipCli  		VAR cTipCli 		SIZE C(067), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	//@ C(019), C(042) MSGET 	oCod_por 		VAR cCod_por 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3('SUS') PIXEL Valid(.T.) HASBUTTON 
	@ C(019), C(042) MSGET 	oCod_por 		VAR cCod_por 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3('SUS') PIXEL Valid( IIF( !Empty(cod_cli),DnyDadCli(1),DnyDadCli(2)),.T.,.T.) HASBUTTON
	//@ C(019), C(090) MSGET 	oLoja_por 		VAR cLoja_por		SIZE C(015), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 VALID If(!DnyDadCli(2), oCod_por:SetFocus() ,.T.) PIXEL 
	@ C(019), C(090) MSGET 	oLoja_por 		VAR cLoja_por		SIZE C(015), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 VALID If(  IIF( !Empty(cod_cli),DnyDadCli(1),DnyDadCli(2)), .T.,.T.) PIXEL
	@ C(019), C(125) MSGET 	oNome_por 		VAR cNome_por 		SIZE C(141), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL 
	//@ C(019), C(280) MSGET 	oTippor  		VAR cTippor 		SIZE C(067), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL //LEANDRO.EBER 01/09/2016

	@ C(034), C(042) MSGET 	oStatbl     	VAR cStatbl      	SIZE C(067), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL CENTER
	@ C(034), C(190) MSGET 	oStatus     	VAR cStatus      	SIZE C(067), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL CENTER

	@ C(049), C(042) MSGET 	oCod_atend 		VAR cod_atend 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(049), C(075) MSGET 	oNome_atend 	VAR come_atend 		SIZE C(060), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(049), C(190) MSGET 	oDtultcp    	VAR dDtUltCp     	SIZE C(060), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(049), C(305) MSGET 	oXdtrcad    	VAR dXdtrCad     	SIZE C(043), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	//@ C(064), C(042) MSGET 	oCod_cnpj  		VAR cod_cnpj 		SIZE C(070), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(064), C(042) MSGET 	oCod_cli 		VAR cod_cli 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(064), C(090) MSGET 	oLoja_cli 		VAR coja_cli		SIZE C(015), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(064), C(190) MSGET 	oCod_IE 		VAR cod_IE 	 		SIZE C(060), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(064), C(325) MSGET 	oTest_fat 		VAR cest_fat 		SIZE C(023), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	@ C(079), C(042) MSGET 	oPer_icms 		VAR cer_icms 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	//@ C(079), C(190) MSGET 	oMrcComl 		VAR cMrcComl 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp F3 "SX5MS" PIXEL
	//@ C(079), C(325) MSGET 	oDesc_marca 	VAR cesc_marca 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp F3 "SX5MR" PIXEL

	@ C(094), C(042) MSGET 	oCidade 		VAR cCidade 		SIZE C(090), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(094), C(190) MSGET 	oContrib 		VAR cContrib 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(094), C(325) MSGET 	o_Pis 			VAR c_Pis 			SIZE C(023), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
                         
	@ C(109), C(042) MSGET 	oCliDDD 		VAR cCliDDD 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
	@ C(109), C(065) MSGET 	oFone_1 		VAR cone_1 			SIZE C(055), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
	@ C(109), C(124) MSGET 	oFone_2 		VAR cone_2 			SIZE C(055), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

	@ C(109), C(250) MSGET 	oColigada 		VAR come_colig 		SIZE C(090), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	@ C(124), C(042) MSGET 	oEmail  		VAR cEmail  		SIZE C(306), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215  PIXEL

	@ C(139), C(042) MSGET 	oCod_fpg 		VAR cod_fpg 		SIZE C(020), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(139), C(070) MSGET 	oDes_forma_pgto VAR ces_forma_pgto 	SIZE C(060), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(139), C(190) MSGET 	oPrz_medio 		VAR crz_medio 		SIZE C(020), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	@ C(154), C(042) MSGET 	oCod_rep 		VAR cod_rep 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(154), C(080) MSGET 	oNome_rep 		VAR come_rep 		SIZE C(170), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	@ C(169), C(042) MSGET 	oCod_trp 		VAR cod_trp 		SIZE C(030), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(169), C(080) MSGET 	oNome_transp 	VAR come_transp 	SIZE C(170), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(169), C(314) MSGET 	oCod_zona 		VAR cod_zona 		SIZE C(035), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL

	@ C(184), C(042) MSGET 	oTraDDD 		VAR cTraDDD 		SIZE C(010), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215     PIXEL
	@ C(184), C(065) MSGET 	oTraFone		VAR cTraFone		SIZE C(055), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215     PIXEL
	
	@ C(184), C(190) MSGET 	oTelCont		VAR cContFone		SIZE C(055), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

	@ C(199), C(042) MSGET 	oEmail_nfe 		VAR cmail_nfe 		SIZE C(306), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL

	//@ C(214), C(042) MSGET 	onum_orc 		VAR cum_orc 		SIZE C(045), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3("ORC2") VALID( FWMsgRun(,{|| DnyAltOrc() }, "Aguarde...", "Localizando Orçamento...") ) PIXEL HASBUTTON
	@ C(214), C(042) MSGET 	onum_orc 		VAR cum_orc 		SIZE C(045), C(010) OF oFolder:aDialogs[1] COLORS 0, 16777215 F3("ORC2") PIXEL VALID( FWMsgRun(,{|| DnyAltOrc() }, "Aguarde...", "Localizando Orçamento...") ) HASBUTTON
	
	@ C(012), C(355) GET 	oObsfin 		VAR cObsfin MEMO 	SIZE C(280), C(063) OF oFolder:aDialogs[1] COLORS 0, 16777215 WHEN lProsp PIXEL
	@ C(090), C(355) GET 	oObsLog 		VAR cObslog MEMO 	SIZE C(280), C(063) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL
	@ C(168), C(355) GET 	oObscob 		VAR cObscob MEMO 	SIZE C(280), C(063) OF oFolder:aDialogs[1] COLORS 0, 16777215 PIXEL                    
	
	oButAmo:=tButton():New(c(234),c(355),/*'Amostra'*/'Bonificações Enviadas'    ,oFolder:aDialogs[1],{||U_FCAMOST(cod_cli,coja_cli)},c(140),c(018),,,,.T.)	
	oButPos:=tButton():New(c(234),c(500),'Pos.Cliente',oFolder:aDialogs[1],{||FCONPCLI(cod_cli,coja_cli)} ,c(138),c(018),,,,.T.)
	
	oObsfin:enablevscroll(.T.)
	oObsfin:lwordwrap := .T.
	oObsLog:enablevscroll(.T.)
	oObsLog:lwordwrap := .T.
	oObscob:enablevscroll(.T.)
	oObscob:lwordwrap := .T.

Return()

Static Function DnyResCli(oDlgVendas, oFolder)  // Resumo de cliente 17/04/13 Fabio Gesser
**********************************************
	IF VALTYPE(oLCrd) <> "U"
		FreeObj(oLCrd)
		FreeObj(oLCrdT)
		FreeObj(oLNCC)
		
		FreeObj(oVAtrazo)
		FreeObj(oVMaior)
		FreeObj(oVQuant)

		FreeObj(oVMargem)
		FreeObj(oVMarInd)

		FreeObj(oVSupre)
		FreeObj(oQSupre)
		FreeObj(oHSupre)
		
		FreeObj(oVFat12m)

		FreeObj(oFat12m)
	Endif

	@ C(005),C(050) MSGET	oLCrd     VAR 	nLCrd    PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel02 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(290) MSGET 	oLCrdT    VAR 	nLCrdT   PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel02 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(480) MSGET 	oLNCC     VAR 	nLCNCC   PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel02 COLORS 0, 16777215 WHEN .F. PIXEL

	@ C(005),C(050) MSGET	oVAtrazo  VAR 	nVatrazo PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel04 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(290) MSGET	oVMaior   VAR 	nVMaior  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel04 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(500) MSGET	oVQuant   VAR 	nVQuant  PICTURE "@E 999,999,999"       SIZE C(060),C(010) OF oPanel04 COLORS 0, 16777215 WHEN .F. PIXEL
    
	@ C(005),C(050) MSGET	oVMargem  VAR 	nVMargem PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel06 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(050) MSGET	oVMarInd  VAR 	nVMarInd PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel08 COLORS 0, 16777215 WHEN .F. PIXEL

	@ C(005),C(030) MSGET	oVSupre   VAR 	nVSupre  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel10 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(143) MSGET	oQSupre   VAR 	nQSupre  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel10 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(250) MSGET	oHSupre   VAR 	nHSupre  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel10 COLORS 0, 16777215 WHEN .F. PIXEL

	@ C(005),C(030) MSGET	oVEssen   VAR 	nVEssen  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel12 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(143) MSGET	oQEssen   VAR 	nQEssen  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel12 COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(005),C(250) MSGET	oHEssen   VAR 	nHEssen  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel12 COLORS 0, 16777215 WHEN .F. PIXEL

	@ C(005),C(290) MSGET	oVFat12m  VAR 	nFat12m  PICTURE "@E 999,999,999.99"    SIZE C(060),C(010) OF oPanel14 COLORS 0, 16777215 WHEN .F. PIXEL

	oFat12m := MsNewGetDados():New( C(210), C(003), C(250), C(641), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldA12m,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[2], aHeade12m, aCols12m)

Return()


Static Function DnyOrcam(oDlgVendas, oFolder, cCTpOper)
//Renato Bandeira em 28/10/14
//Local lAlteraPreco	:=	.F.

*********************************************
	IF VALTYPE(oCod_produto) <> "U"
		FreeObj(oCod_produto)
		FreeObj(UM)
		FreeObj(preco_1)
		FreeObj(preco_2)
		FreeObj(oCodCA)
		FreeObj(perc_icm)
		FreeObj(perc_ipi)

		FreeObj(oQtde)
		FreeObj(oPreco)
		FreeObj(oTotal)
		FreeObj(oVDesc)
		FreeObj(oDescT)
		FreeObj(oTotPV)

		FreeObj(oPedxCli)
		FreeObj(oPedxIte)
		FreeObj(oGetTabe)

		FreeObj(desc_nfe)
		FreeObj(desc_comercial)

		//FreeObj(onum_orc)

		FreeObj(oButOrc1)
		FreeObj(oButOrc2)
		FreeObj(oButOrc3)
		FreeObj(oButOrc4)
		FreeObj(oButOrc5)
		FreeObj(oButOrc6)
		FreeObj(oButOrc7)
		FreeObj(oButOrc8)
		FreeObj(oButOrc9)
		FreeObj(oButOrc10)
		FreeObj(oSayMarg)
	Endif

	//@ C(004),C(032) MSGET	oCod_produto 	VAR 	gCod_produto 	SIZE C(060),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3 "SB1DNY" VALID DnyCarPrd(@oDlgVendas,@oFolder) PIXEL 
	@ C(004),C(032) MSGET	oCod_produto 	VAR 	gCod_produto 	SIZE C(060),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3("SB1TGV") VALID DnyCarPrd(@oDlgVendas,@oFolder)  PIXEL  //.AND. ChkIncItem(gCod_produto,nQtde,@oDlgVendas, @oFolder)
	
	@ C(004),C(100) MSGET 	UM 				VAR 	cM 				SIZE C(020),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
	//@ C(019),C(032) MSGET 	preco_1 		VAR 	creco_1 		SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//@ C(034),C(032) MSGET 	preco_2 		VAR	 	creco_2 		SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//@ C(049),C(032) MSGET 	oCodCA 			VAR 	cCodCA 			SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
	@ C(019),C(100) MSGET 	perc_icm 		VAR 	cerc_icm 		SIZE C(020),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(019),C(032) MSGET 	perc_ipi 		VAR 	cerc_ipi 		SIZE C(020),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
    

//	@ C(036),C(032) MSGET    oGetCnd   VAR cod_fpg	                SIZE C(003),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 When(_lAltSE4) PIXEL F3("SE4TGV") VALID(DNYCONDPG(cod_fpg, @ces_forma_pgto, oFolder:aDialogs[3],@_lAltSE4,@_nAltSE4,oGetCnd) .And. MsgRun("Aguarde Processando itens...",,{||xCalcxCnp()}))
//	@ C(036),C(070) MSGET    oGetH 	   VAR ces_forma_pgto	   		SIZE C(066),C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL

//	@ C(036),C(032) COMBOBOX oGetTpOp  VAR cCTpOper  ITEMS aDTpOper SIZE C(067),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL //VALID(iIF(Empty(cCTpOper),.F.,DNYIMPOST(@oDlgVendas,@oFolder)))  PIXEL
	@ C(036),C(032) COMBOBOX oGetTpOp  VAR cCTpOper  ITEMS aDTpOper SIZE C(067),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL VALID(fTrocaOp(cCTpOper) )  PIXEL

    // Renato Bandeira em 30/10/14 - Outro pondo da tela
	//@ C(036),C(180) MSGET 	onum_orc 		VAR 	cum_orc 		SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3("ORC2") VALID( FWMsgRun(,{|| DnyAltOrc() }, "Aguarde...", "Localizando Orçamento...") ) PIXEL
	@ C(036),C(135) MSGET	oPedxCli        VAR 	cPedxCli        SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN (SA1->A1_PEDCOMP= "S") PIXEL
	@ C(036),C(220) MSGET 	oPedxIte     	VAR 	cPedxIte     	SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN (SA1->A1_PEDCOMP= "S") PIXEL

	@ C(036),C(295) MSGET 	oSegunUm     	VAR 	cSegunUm     	SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL

	//@ C(050),C(032) MSGET 	oGetTabe     	VAR 	cCodTab     	SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3("DA0") VALID DnyValTab(cCodTab,cod_atend) PIXEL HASBUTTON
   //	@ C(050),C(032) MSGET 	oGetTabe     	VAR 	cCodTab     	SIZE C(030),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3("DA0") VALID .T. PIXEL
	
	// Renato Bandeira em 30/10/14 - Tratativa para Higiene e Limpeza :
	// 1) Comodato : nao edita. Verificar pelo Tipo da Operacao. Criar paramtro . Se ctoper == DN_TPOPCO
	// 2) Tab.Fixa (ex.contrato) : não edita. Verificar o parametro criado para esse fim. Se o ! A1_TABELA $ HL_EDITPRC 
	//(Edita PRECO, Informar Tabela padrao, ex. A)
	// 3) 
	//@ C(139),C(158) MSGET	oPreco          VAR 	nPreco          PICTURE "@E 9,999,999.9999"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN ChkAltPreco(nPreco, lAlteraPreco) /*(!nPreco>=0 .AND. lAlteraPreco)*/ VALID DnyCarTot() PIXEL
	//@ C(139),C(158) MSGET	oPreco          VAR 	nPreco          PICTURE "@E 9,999,999.9999"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .t.  VALID DnyCarTot() PIXEL
	//RODOLFO 1305 @ C(139),C(034) MSGET	oPreco          VAR 	nPreco          PICTURE "@E 9,999,999.9999"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL  
	//@ C(139),C(108) MSGET 	oQtde 			VAR 	nQtde  			PICTURE "@e 9,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID (ChkIncItem(gCod_produto,nQtde,@oDlgVendas, @oFolder))  PIXEL
	
	//@ C(139),C(034) MSGET 	oQtde 			VAR 	nQtde  			PICTURE "@e 9,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID (ChkIncItem(gCod_produto,nQtde,@oDlgVendas, @oFolder))  PIXEL
	//@ C(119),C(034) MSGET 	oQtde 			VAR 	nQtde  			PICTURE "@e 9,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID (ChkIncItem(gCod_produto,nQtde,@oDlgVendas, @oFolder))  PIXEL
	@ C(109),C(034) MSGET 	oQtde 			VAR 	nQtde  			PICTURE "@e 9,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID (ChkIncItem(gCod_produto,nQtde,@oDlgVendas, @oFolder))  PIXEL

                  //200
	//RODOLFO 1205 @ C(139),C(190) MSGET 	oTotal   		VAR 	nTotItem		PICTURE "@E 99,999,999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL


	//@ C(128),C(260) MSGET	oSayMarg        VAR 	nSayMarg        PICTURE "@e 999.99%"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 valid (1=1) WHEN .f. PIXEL
	@ C(110),C(260) MSGET	oSayMarg        VAR 	nSayMarg        PICTURE "@e 999.99%"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 valid (1=1) WHEN .f. PIXEL
	oSayMarg:hide()

	// Renato Bandeira em 30/10/14 - Mostra o desconto Total
	//@ C(139),C(284) MSGET	oTotPV        VAR 	nTotalPV        PICTURE "@E 999,999,999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//@ C(154),C(284) MSGET	oDescT        VAR 	nDescT        PICTURE "@e 999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .f. PIXEL
	//@ C(234),C(439) MSGET	oTotPV        VAR 	nTotalPV        PICTURE "@E 999,999,999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//@ C(234),C(559) MSGET	oDescT        VAR 	nDescT        PICTURE "@e 999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .f. PIXEL
	//@ C(234),C(034) MSGET 	oVDesc		VAR 	nDescTota		PICTURE "@E 99,999,999"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID goCalcDTot(nDescTota)  PIXEL
	//@ C(234),C(153) MSGET	oTotPV		VAR 	nTotalPV        PICTURE "@E 999,999,999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//@ C(234),C(273) MSGET	oDescT		VAR 	nDescT        PICTURE "@e 999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .f. PIXEL
	//@ C(224),C(034) MSGET 	oVDesc		VAR 	nDescTota		PICTURE "@E 99,999,999.99"      SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215  VALID goCalcDTot(nDescTota)  PIXEL
	@ C(224),C(153) MSGET	oTotPV		VAR 	nTotalPV        PICTURE "@E 999,999,999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	@ C(224),C(273) MSGET	oDescT		VAR 	nDescT        PICTURE "@e 999.99"  SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .f. PIXEL

	//@ C(154),C(158) MSGET	oPedxCli        VAR 	cPedxCli        SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
	//@ C(154),C(284) MSGET 	oPedxIte     	VAR 	cPedxIte     	SIZE C(050),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL PIXEL

	@ C(004),C(135) MSGET 	desc_nfe 		VAR 	cesc_nfe 		SIZE C(200),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
	@ C(020),C(135) MSGET 	desc_comercial 	VAR 	cesc_comercial 	SIZE C(200),C(010/*030*/) OF oFolder:aDialogs[3] COLORS 0, 16777215 WHEN .F. PIXEL
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
	
	//ORCAM.
	//Renato Bandeira em 20/10/14 - orcamento em outro ponto da tela
	//@ C(154),C(034) MSGET 	onum_orc 		VAR 	cum_orc 		SIZE C(045),C(010) OF oFolder:aDialogs[3] COLORS 0, 16777215 F3("ORC2") VALID( FWMsgRun(,{|| DnyAltOrc() }, "Aguarde...", "Localizando Orçamento...") ) PIXEL

	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>

	f_Estoque(@oFolder)
	f_Orcamento(@oFolder)
	//--Grid de promoções
	f_Promocao(@oFolder)
	f_Comissao(@oFolder)

	//oButOrc1:=tButton():New(c(224),c(340),'Previsão'     ,oFolder:aDialogs[3],{||frev_chegada(@oDlgVendas, @oFolder)},c(055),c(013),,,,.T.)
	//oButOrc2:=tButton():New(c(224),c(400),'Itens Compra' ,oFolder:aDialogs[3],{||f_comprados(@oDlgVendas,  @oFolder)},c(055),c(013),,,,.T.)
	//oButOrc3:=tButton():New(c(224),c(462),/*'Não Compra''Familía'*/'Itens ?Compra'   ,oFolder:aDialogs[3],{||f_ncomprados(@oDlgVendas, @oFolder)},c(055),c(013),,,,.T.)
	//oButOrc4:=tButton():New(c(224),c(520),'Pedido'       ,oFolder:aDialogs[3],{||f_pedidos(@oDlgVendas,    @oFolder)},c(055),c(013),,,,.T.)
	//oButPromo:= tButton():New(c(224),c(578),'Promoções'    ,oFolder:aDialogs[3],{|| f_Promocao(@oFolder) },c(055),c(013),,,,.T.)
	//oButOrc1:=tButton():New(c(119),c(340),'Previsão'     ,oFolder:aDialogs[3],{||frev_chegada(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc2:=tButton():New(c(119),c(400),'Itens Compra' ,oFolder:aDialogs[3],{||f_comprados(@oDlgVendas,  @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc3:=tButton():New(c(119),c(462),/*'Não Compra''Familía'*/'Itens ?Compra'   ,oFolder:aDialogs[3],{||f_ncomprados(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc4:=tButton():New(c(119),c(520),'Pedido'       ,oFolder:aDialogs[3],{||f_pedidos(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	//oButPromo:= tButton():New(c(119),c(578),'Promoções'    ,oFolder:aDialogs[3],{|| f_Promocao(@oFolder) },c(055),c(009),,,,.T.)
	//oButOrc1:=tButton():New(c(234),c(340),'Previsão'     ,oFolder:aDialogs[3],{||frev_chegada(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc2:=tButton():New(c(234),c(400),'Itens Compra' ,oFolder:aDialogs[3],{||f_comprados(@oDlgVendas,  @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc3:=tButton():New(c(234),c(462),/*'Não Compra''Familía'*/'Itens ?Compra'   ,oFolder:aDialogs[3],{||f_ncomprados(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc4:=tButton():New(c(234),c(520),'Pedido'       ,oFolder:aDialogs[3],{||f_pedidos(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	//oButPromo:= tButton():New(c(234),c(578),'Promoções'    ,oFolder:aDialogs[3],{|| f_Promocao(@oFolder) },c(055),c(009),,,,.T.)
	oButOrc1:=tButton():New(c(224),c(340),'Previsão'     ,oFolder:aDialogs[3],{||frev_chegada(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	oButOrc2:=tButton():New(c(224),c(400),'Itens Compra' ,oFolder:aDialogs[3],{||f_comprados(@oDlgVendas,  @oFolder)},c(055),c(009),,,,.T.)
	oButOrc3:=tButton():New(c(224),c(462),/*'Não Compra''Familía'*/'Itens ?Compra'   ,oFolder:aDialogs[3],{||f_ncomprados(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	oButOrc4:=tButton():New(c(224),c(520),'Pedido'       ,oFolder:aDialogs[3],{||f_pedidos(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	oButPromo:= tButton():New(c(224),c(578),'Promoções'    ,oFolder:aDialogs[3],{|| f_Promocao(@oFolder) },c(055),c(009),,,,.T.)

	//oButOrc5:=tButton():New(c(239),c(340),'Itens NF'     ,oFolder:aDialogs[3],{||f_ItensNf(@oDlgVendas,    @oFolder)},c(055),c(013),,,,.T.)   
	//oButOrc8 := tButton():New(c(239),c(400),'Lote'       ,oFolder:aDialogs[3],{||f_lote(@oDlgVendas,    @oFolder)},c(055),c(013),,,,.T.)
	//oButOrc9 := tButton():New(c(239),c(462),'Orcamento'    ,oFolder:aDialogs[3],{||f_orc(@oDlgVendas, @oFolder)},c(055),c(013),,,,.T.)
	//oButOrc10:= tButton():New(c(239),c(520),'Foto'       ,oFolder:aDialogs[3],{||f_Foto(@oDlgVendas, @oFolder)},c(055),c(013),,,,.T.)
	//oButComis:= tButton():New(c(239),c(578),'Comissão x Preço',oFolder:aDialogs[3],{|| f_Comissao(@oFolder) },c(055),c(013),,,,.T.)
	//oButOrc5:=tButton():New(c(130),c(340),'Itens NF'     ,oFolder:aDialogs[3],{||f_ItensNf(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)   
	//oButOrc8 := tButton():New(c(130),c(400),'Lote'       ,oFolder:aDialogs[3],{||f_lote(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc9 := tButton():New(c(130),c(462),'Orcamento'    ,oFolder:aDialogs[3],{||f_orc(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc10:= tButton():New(c(130),c(520),'Foto'       ,oFolder:aDialogs[3],{||f_Foto(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButComis:= tButton():New(c(130),c(578),'Comissão x Preço',oFolder:aDialogs[3],{|| f_Comissao(@oFolder) },c(055),c(009),,,,.T.)
	//oButOrc5:=tButton():New(c(245),c(340),'Itens NF'     ,oFolder:aDialogs[3],{||f_ItensNf(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)   
	//oButOrc8 := tButton():New(c(245),c(400),'Lote'       ,oFolder:aDialogs[3],{||f_lote(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc9 := tButton():New(c(245),c(462),'Orcamento'    ,oFolder:aDialogs[3],{||f_orc(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButOrc10:= tButton():New(c(245),c(520),'Foto'       ,oFolder:aDialogs[3],{||f_Foto(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	//oButComis:= tButton():New(c(245),c(578),'Comissão x Preço',oFolder:aDialogs[3],{|| f_Comissao(@oFolder) },c(055),c(009),,,,.T.)
	oButOrc5:=tButton():New(c(235),c(340),'Itens NF'     ,oFolder:aDialogs[3],{||f_ItensNf(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)   
	oButOrc8 := tButton():New(c(235),c(400),'Lote'       ,oFolder:aDialogs[3],{||f_lote(@oDlgVendas,    @oFolder)},c(055),c(009),,,,.T.)
	oButOrc9 := tButton():New(c(235),c(462),'Orcamento'    ,oFolder:aDialogs[3],{||f_orc(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	oButOrc10:= tButton():New(c(235),c(520),'Foto'       ,oFolder:aDialogs[3],{||f_Foto(@oDlgVendas, @oFolder)},c(055),c(009),,,,.T.)
	oButComis:= tButton():New(c(235),c(578),'Comissão x Preço',oFolder:aDialogs[3],{|| f_Comissao(@oFolder) },c(055),c(009),,,,.T.)
	
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>	
	
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?DnyImpost ºAutor  ?LEANDRO.EBER    ?Data ? 31/08/16    º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Validacao de tabela de precos e vendedores                 º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±?  USO    ?               											  º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/
Static Function DnyValTab(cCodTab,cod_atend)

Local lRet:=.T.  
Local nPosUtl	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_UTILIZA'} )
Local lKitApl	:= .F.
//Default cCodTab:="001"

Local nX

DbSelectArea("SA3")
DbSetOrder(1)
If DbSeek(xFilial("SA3") + cod_atend )
	/*If cCodTab $ SA3->A3_XTABELA
		lRet:=.T.
	Else
		lRet:=.F.	
		Alert("Atenção, o Vendedor: "+ALLTRIM(SA3->A3_COD)+" - "+ALLTRIM(SA3->A3_NOME)+" não tem acesso para usar a tabela "+cCodTab)	
	EndIf*/
//Else
//	lRet:=.F.
EndIf 
//--Validação promoção
If cCodTabAnt<>cCodTab
	//--Verifica se tem alguma promoção aplicada
	Aeval(oPromocoes:aCols,{|x| IIF(x[nPosUtl]=='1',lKitApl:= .T.,)})
	//--Promoção aplicada sim/ão
	If lKitApl
		MsgAlert(OemToAnsi('Não ser?possivel modificar a tabela de preço, pois existe uma promoção aplicada no orçamento. Favor retirar promoção aplicada para alterar codigo da tabela'))
		Return(.F.)
	EndIf	
EndIf

If !Empty(cCodTabAnt)
	If cCodTabAnt<>cCodTab
		If (MSGYesNo('Atenção, a tabela de preço usado no Orçamento foi a '+Alltrim(cCodTabAnt)+ ', voc?deseja alterar a tabela de preço para '+Alltrim(cCodTab)+' e recalcular todos os itens do Orçamento?'))	
			
			For nX := 1 To Len(oOrcamento:aCols)   
				
				If !Empty(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)])
					DbSelectArea("DA1")
					DA1->(DbSetOrder(1))
					If DA1->(MsSeek(xFilial("DA1")+cCodTab+oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)]))
						nPreco:=DA1->DA1_PRCVEN
						//--.iNi Verifica existencia de promoção
						FSPromDes(@nPreco, cCodTab, oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)])
					ElseIf DA1->(MsSeek(xFilial("DA1")+__HLTABPADR+oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)]))
						nPreco:=DA1->DA1_PRCVEN
						//--.iNi Verifica existencia de promoção
						FSPromDes(@nPreco, __HLTABPADR, oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)]) 	
					EndIf		
													 
				    oOrcamento:aCols[nX, GdFieldPos("UB_PRCTAB" ,__aHeaderEx)] := nPreco
				EndIf				
			Next nX  
			
			oOrcamento:oBrowse:Refresh()
			oOrcamento:Refresh()
			
			EndIf				
		EndIf
	EndIf

CalcDescTot()

//If cCTpOper=='02' .AND. cCodTab<>'002'
//	lRet:=.F.	
//	Alert("Atenção, a operação 02-Academico s?pode ser usada com a Tabela Academico.")	
//EndIf                 

//Valida se usou a tabela anteriormente
//If Len(oOrcamento:ACOLS)>0
	//If !EMPTY(oOrcamento:ACOLS[1][2]) .AND. oOrcamento:ACOLS[1][Len(oOrcamento:AHEADER)+1] == .F. .AND. Alltrim(cCodTabAnt)<>Alltrim(cCodTab)
	//	lRet:=.F.	
	//	Alert("Atenção, não ?possivel alterar a tabela de preço depois de um item j?incluido, exclua o item e altera e tabela novamente.")
	//EndIf
//EndIf

cCodTabAnt:=cCodTab

Return lRet

                                              
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?DnyImpost ºAutor  ?Meliora/Gustavo  ?Data ? 02/12/13    º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Estrutura pra recalculo de imposto                         º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±?  USO    ? 											  º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/
*--------------------------------------------*
Static Function DnyImpost(oDlgVendas, oFolder)
*--------------------------------------------*
Local xCRLF := CHR(13)+CHR(10)
Local lRet  := .T.
Local nX

DbSelectArea("SA3")
DbSetOrder(1)
If DbSeek(xFilial("SA3") + cod_atend )
	/*If cCTpOper $ SA3->A3_XLOCAL
		lRet:=.T.
	Else
		If cCTpOper=='01' .OR. cCTpOper=='02'
			lRet:=.F.	
			Alert("Atenção, o Vendedor: "+ALLTRIM(SA3->A3_COD)+" - "+ALLTRIM(SA3->A3_NOME)+" não tem acesso para usar a operação "+cCTpOper)	
		EndIf
	EndIf*/
Else
	lRet:=.F.
EndIf                    


If oOrcamento:aCols[1, GdFieldPos("UB_PRODUTO",__aHeaderEx)] == SPACE(15)
   Return(lRet)
EndIf

For nX := 1 To Len(oOrcamento:aCols)   

	//Renato Bandeira em 8/4/14
	If oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)] == nil
		Loop
	Endif

	SB1->(DbSetOrder(01))
	SB1->(DbSeek(xFilial('SB1')+AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B1_COD')))

	If __lProsp
		cTesInt := GetMv('LB_TGVTES',.F.,'503')
	Else
	    If cCTpOper == '05'
	    	cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
	    Else    
	    	IF ALLTRIM(cFilAnt) $ "0103|0102"
				If cCTpOper <> '87'
					if SB1->B1_ORIGEM $ "0|2"
						cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
					else
						SB2->(dbSetOrder(01))
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
						Else
							SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
								cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
							EndIf
						EndIf
						If Empty(cTesInt)
							If SB1->B1_LOCPAD $ '01|90'														
								cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							ElseIf SB1->B1_LOCPAD $ '03|80'							
								cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								MsgAlert(OemToAnsi('Produto com armazem diferente de 01 ou 03'))
							EndIf
						EndIf
					endif
					/*Posicione("SB2",1,xFilial("SB2")+oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)]+'01',"B2_QATU") > 0
						cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ELSEIF Posicione("SB2",1,xFilial("SB2")+oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)]+'03',"B2_QATU") > 0
						cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ELSE
						cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ENDIF*/
				Else
					if SB1->B1_ORIGEM $ "0|2"
						cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
					else
						SB2->(dbSetOrder(01))
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
						Else
							SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
								cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
							EndIf
						EndIf
						If Empty(cTesInt)
							If SB1->B1_LOCPAD $ '01|90'														
								cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							ElseIf SB1->B1_LOCPAD $ '03|80'							
								cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								MsgAlert(OemToAnsi('Produto com Arm. Padrao diferente de 01/90 ou 03/80'))
							EndIf
						EndIf
						//cTesInt:= MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					endif
				EndIf	
       		ELSE
 	    		cTesInt:= MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
	    	ENDIF
	    EndIf
		//MSGALERT(cTesInt+" := "+cTesInt)
		IF Empty(cTesInt)    
			MSGALERT("MSG 1. TES NÃO CADASTRADO, AVISE A ÁREA FISCAL!! PARAMETROS:" + xCRLF + ;
			"Tp.oper = [" + PadR(cCTpOper,TamSX3('UA_XTOPER')[1]) + "] " + xCRLF + ;
			"Cliente = [" + cod_cli  + "] " + xCRLF + ;
			"Loja    = [" + coja_cli  + "] " + xCRLF + ;
			"Produto = [" + oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)] + "] ")
	
			// MSGALERT("MSG 1. TES NAO CADASTRADO, AVISE A AREA FISCAL !!")
			cTesInt := GetMv('LB_TGVTES',.F.,'503')
	 	EndIf
	 EndIf	

	SB1->(dbSetOrder(1))  // B1_FILIAL, B1_COD.
	SB1->(!dbSeek(xFilial() + oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)], .F.))
 	
	SF4->(dbSetOrder(1))  // F4_FILIAL, F4_CODIGO.
	SF4->(dbSeek(xFilial() + cTesInt, .F.))

    MaFisIni(cod_cli,coja_cli,"C","N",cTipCli,,,,,"MATA461",,,IIF(__lProsp,cCod_por+cLoja_por,Nil))

    MaFisAdd(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],;
             cTesInt,;
             oOrcamento:aCols[nX, GdFieldPos("UB_QUANT"  ,__aHeaderEx)],;
             oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT" ,__aHeaderEx)],;
             0.00,;
             "",;
             "",;
             0,;
             0,;
             0,;
             0,;
             0,;
             oOrcamento:aCols[nX, GdFieldPos("UB_VLRITEM",__aHeaderEx)],;
             0,;
             SB1->(RecNo()),;
             SF4->(RecNo()))

			 
    oOrcamento:aCols[nX, GdFieldPos("D2_VALICM" ,__aHeaderEx)] := MaFisRet(1,"IT_VALICM")
    oOrcamento:aCols[nX, GdFieldPos("D2_ICMSRET",__aHeaderEx)] := MaFisRet(1,"IT_VALSOL")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALIPI" ,__aHeaderEx)] := MaFisRet(1,"IT_VALIPI")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALINS" ,__aHeaderEx)] := MaFisRet(1,"IT_VALINS")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALCOF" ,__aHeaderEx)] := MaFisRet(1,"IT_VALCF2")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALCSL" ,__aHeaderEx)] := MaFisRet(1,"IT_VALCSL")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALPIS" ,__aHeaderEx)] := MaFisRet(1,"IT_VALPS2")
    oOrcamento:aCols[nX, GdFieldPos("D2_VALBRUT",__aHeaderEx)] := MaFisRet(1,"IT_TOTAL")
    oOrcamento:aCols[nX, GdFieldPos("D2_BASEICM" ,__aHeaderEx)] := MaFisRet(1,"IT_BASEICM")
			 
    MaFisEnd()
    
next

oOrcamento:oBrowse:Refresh()
oOrcamento:Refresh()
oGetTpOp:Refresh()

Return(lRet)

Static Function DnyHisto(oDlgVendas, oFolder)
*********************************************
Local nX
//IF VALTYPE(ohCod_cli) <> "U"
//   FreeObj(ohCod_cli)
//   FreeObj(ohLoja_cli)
//   FreeObj(ohNome_cli)

//   FreeObj(oGetHis)

//   FreeObj(oButHis1)
//   FreeObj(oButHis2)
//Endif

	aHeadHist := {}
	aColsHist := {}

	DbSelectArea("SX3")
	DbSetOrder(2)
	For nX := 1 to Len(aFldHist)
		If SX3->(DbSeek(aFldHist[nX]))

			cPict := SX3->X3_PICTURE

			cX3Tit:= AllTrim(X3Titulo())

			IF     Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
				cX3Tit := "Titulo"
			ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
				cX3Tit := "Nome Repres."
			Endif

			Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	AADD(aColsHist,Array(Len(aHeadHist)+1))
	aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.

	@ C(005),C(042) MSGET 	ohCod_cli 		VAR cod_cli 		SIZE C(030),C(010) OF oFolder:aDialogs[4] COLORS 0, 16777215 PIXEL WHEN .F.
	@ C(005),C(090) MSGET 	ohLoja_cli 		VAR coja_cli		SIZE C(015),C(010) OF oFolder:aDialogs[4] COLORS 0, 16777215 PIXEL WHEN .F.
	@ C(005),C(125) MSGET 	ohNome_cli 		VAR come_cli 		SIZE C(141),C(010) OF oFolder:aDialogs[4] COLORS 0, 16777215 PIXEL WHEN .F.

	oGetHis := MsNewGetDados():New(C(020),C(003),C(233),C(641),GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldHist,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[4], aHeadHist, aColsHist)

	oGetHis:oBrowse:bLDblClick := {||DNYHISINC(@oDlgVendas, @oFolder,1)}

	oGetHis:oBrowse:Refresh()
	oGetHis:Refresh()

	oButHis1:=tButton():New(c(240),c(505),'Visualiza Histórico' ,oFolder:aDialogs[4],{||DNYHISINC(@oDlgVendas, @oFolder,1)},c(065),c(012),,,,.T.)
	oButHis2:=tButton():New(c(240),c(576),'Novo Histórico'      ,oFolder:aDialogs[4],{||DNYHISINC(@oDlgVendas, @oFolder,2)},c(065),c(012),,,,.T.)

Return


Static Function DnyConta(oDlgVendas, oFolder)
*********************************************
Local nX
	IF VALTYPE(oCCod_cli) <> "U"
		FreeObj(oCCod_cli)
		FreeObj(oCLoja_cli)
		FreeObj(oCNome_cli)

		FreeObj(oGetCon)

		FreeObj(oButCon1)
		FreeObj(oButCon2)
	Endif


	aHeadCont := {}
	aColsCont := {}

	DbSelectArea("SX3")
	DbSetOrder(2)
	For nX := 1 to Len(aFldCont)
		If SX3->(DbSeek(aFldCont[nX]))

			cPict := SX3->X3_PICTURE

			cX3Tit:= AllTrim(X3Titulo())

			IF     Alltrim(SX3->X3_CAMPO) == "QB_DESCRIC"
				cX3Tit := "Departamento"
			ElseIf Alltrim(SX3->X3_CAMPO) == "UM_DESC"
				cX3Tit := "Função"
			Endif

			Aadd(aHeadCont, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX


	@ C(005),C(042) MSGET 	oCCod_cli 		VAR cod_cli 		SIZE C(030),C(010) OF oFolder:aDialogs[5] COLORS 0, 16777215 PIXEL WHEN .F.
	@ C(005),C(090) MSGET 	oCLoja_cli 		VAR coja_cli		SIZE C(015),C(010) OF oFolder:aDialogs[5] COLORS 0, 16777215 PIXEL WHEN .F.
	@ C(005),C(125) MSGET 	oCNome_cli 		VAR come_cli 		SIZE C(141),C(010) OF oFolder:aDialogs[5] COLORS 0, 16777215 PIXEL WHEN .F.

	oGetCon := MsNewGetDados():New(C(020),C(003),C(233),C(641),GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldCont,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[5], aHeadCont, aColsCont)

	oGetCon:oBrowse:Refresh()
	oGetCon:Refresh()

	oButCon1:=tButton():New(c(240),c(505),'Novo Contato'        ,oFolder:aDialogs[5],{||DNYCONMNT(@oDlgVendas, @oFolder,1)},c(065),c(012),,,,.T.)
	oButCon2:=tButton():New(c(240),c(576),'Alterar Contato'     ,oFolder:aDialogs[5],{||DNYCONMNT(@oDlgVendas, @oFolder,2)},c(065),c(012),,,,.T.)

Return

*---------------------------------------------*
Static Function f_Estoque(oFolder)
*---------------------------------------------*
	Local nX
	
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	aFldEst    := {}
	__aHeadEst := {}
	Aadd(__aHeadEst,{'Filial'      ,'B2FILIAL', "@!" , 30, 0, '', USADO, 'C', '', ''}) 
	Aadd(aFldEst,'B2FILIAL')
	Aadd(__aHeadEst, {'Qtd.Disp.'  ,'ESQTDDIS', "@E 99,999,999.99" , TamSX3('B2_QATU')[1], TamSX3('B2_QATU')[2], '', USADO, 'N', '', ''}) 
	Aadd(aFldEst,'ESQTDDIS')
	Aadd(__aHeadEst, {'Prev.Entr','PREVENTR', "@E 99,999,999.99" , TamSX3('B2_SALPEDI')[1], TamSX3('B2_SALPEDI')[2], '', USADO, 'N', '', ''}) 
	Aadd(aFldEst,'PREVENTR')	
//	Aadd(__aHeadEst, {'Lote Futuro','ESLOTFUT', "@E 99,999,999.99" , TamSX3('B2_QATU')[1], TamSX3('B2_QATU')[2], '', USADO, 'N', '', ''}) 
//	Aadd(aFldEst,'ESLOTFUT')	
	
	
	
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
// Define field values
	DbSelectArea("SX3")  
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFldEst)
		If DbSeek(aFldEst[nX])
			Aadd(aFldFest, CriaVar(SX3->X3_CAMPO))
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	 //	ElseIf aFldEst[nX] $ 'ESQTDDIS/ESLOTFUT/PREVENTR'
	 	ElseIf aFldEst[nX] $ 'ESQTDDIS/PREVENTR'
		    Aadd(aFldFest, 0)
		ElseIf aFldEst[nX] $ 'B2FILIAL'
		    Aadd(aFldFest, '')		    
		Endif
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	Next nX

	Aadd(aFldFest, .F.)
	Aadd(__aColsEst, aFldFest)
	__aCEstAux := aClone(__aColsEst)

	//@ C(065), C(005) SAY oSayEst PROMPT "Estoque" SIZE C(050), C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
	@ C(055), C(005) SAY oSayEst PROMPT "Estoque" SIZE C(050), C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
	//oEstoque := MsNewGetDados():New( C(075), C(005), C(135), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)
	//oEstoque := MsNewGetDados():New( C(075), C(005), C(115), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)
	oEstoque := MsNewGetDados():New( C(065), C(005), C(105), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)

Return


// Consulta dos pedidos de compra referente ao produto digitado

Static Function frev_chegada(oDlgVendas, oFolder)  // Ajustado por Fabio Gesser 04/04/2013
*************************************************
	Local nX, oPanel
	Local lCria
	Local cQuery := ""

	//Atualiza Folder 03
	xRshFol3(@oDlgVendas, @oFolder)

	IF gCod_produto == SPACE(15)
		MSGINFO("Para esta consulta ?obrigatório informar o código do produto", "Produto não Preenchido")
	Return
	Endif

	aFldCHE	 := {"C7_NUM", "C7_QUANT", "C7_EMISSAO", "C7_DATPRF"}
	aColsCHE := {}
	aHeadCHE := {}
	aFldACHE := {}
	aFldFCHE := {}

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFldCHE)
		If SX3->(DbSeek(aFldCHE[nX]))

			IF ALLTRIM(SX3->X3_CAMPO) == "C7_QUANT"
				cPict := "@E 99,999,999.99"
			else
				cPict := SX3->X3_PICTURE
			endif

			Aadd(aHeadCHE, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	For nX := 1 to Len(aFldCHE)
		If DbSeek(aFldCHE[nX])
			Aadd(aFldFCHE, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX

	Aadd(aFldFCHE, .F.)
	Aadd(aColsCHE, aFldFCHE)

	If Len(aColsCHE) > 1 .OR. !Empty(aColsCHE[1,1] )
		aColsCHE := {}
		AADD(aColsCHE,Array(Len(aHeadCHE)+1))
		aColsCHE[Len(aColsCHE)][Len(aHeadCHE)+1] := .F.
	EndIf

	cQuery := "SELECT C7_QUANT - C7_QUJE SALDO, C7_NUM, C7_EMISSAO, C7_DATPRF " + Chr(10) + Chr(13)
	cQuery += "FROM " + RetSqlName("SC7")  + " " + Chr(10) + Chr(13)
	cQuery += "WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND C7_PRODUTO = '" + AllTrim(gCod_produto) + "' AND D_E_L_E_T_ = '' AND C7_ENCER = '' " + Chr(10) + Chr(13)
	cQuery += "ORDER BY C7_DATPRF " + Chr(10) + Chr(13)

	If Select("CHE") > 0
		dbSelectArea("CHE")
		dbCloseArea()
	EndIf

	TcQuery cQuery New Alias "CHE"
	TCSetField("CHE", "C7_EMISSAO","D")
	TCSetField("CHE", "C7_DATPRF", "D")

	DbSelectArea("CHE")
	While !CHE->(Eof())

		If Len(aColsCHE) == 1 .AND. Empty(aColsCHE[Len(aColsCHE),GdFieldPos("C7_NUM", aHeadCHE)] )
			lCria := .F.
		Else
			lCria := .T.
		EndIf

		If lCria
			AADD(aColsCHE,Array(Len(aHeadCHE)+1))
			aColsCHE[Len(aColsCHE)][Len(aHeadCHE)+1] := .F.
		EndIf

		aColsCHE[Len(aColsCHE), GdFieldPos("C7_NUM",    aHeadCHE)] 	:= CHE->C7_NUM
		aColsCHE[Len(aColsCHE), GdFieldPos("C7_QUANT",  aHeadCHE)] 	:= CHE->SALDO
		aColsCHE[Len(aColsCHE), GdFieldPos("C7_EMISSAO",aHeadCHE)]	:= CHE->C7_EMISSAO
		aColsCHE[Len(aColsCHE), GdFieldPos("C7_DATPRF", aHeadCHE)]	:= CHE->C7_DATPRF

		CHE->(DbSkip())
	End

	@ C(003),C(340) MSPANEL oPanel PROMPT "Previsão Chegada" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED //COLOR CLR_HRED
	//oPedCom := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldACHE,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadCHE, aColsCHE)
	//oPedCom := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldACHE,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadCHE, aColsCHE)
	//oPedCom := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldACHE,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadCHE, aColsCHE)
	oPedCom := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldACHE,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadCHE, aColsCHE)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³f_compradosºAutor  ³Microsiga          ?Data ? 06/18/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Criacao da interface de itens comprados pelo cliente       º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function f_comprados(oDlgVendas, oFolder)
************************************************
	Local nX, opanel
	Local cQuery := ""
	Local lCria
	Local cCodPro := ""
	Local nTamX3	:= 0

	//Atualiza Folder 03
	xRshFol3(@oDlgVendas, @oFolder)

	aColsFat := {}
	aHeadFat := {}
	aFldAFat := {}
	aFldFat	 := {"D2_COD", "B1_DESC", "D2_QUANT", "D2_PRCVEN", "D2_TOTAL", "D2_EMISSAO", "D2_DOC", "A7_CODCLI"}
	aFldFFat := {}

// Define field properties
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFldFat)
		If SX3->(DbSeek(aFldFat[nX]))
			IF ALLTRIM(SX3->X3_CAMPO) $ "D2_QUANT/D2_PRCVEN/D2_TOTAL"
				cPict := "@E 99,999,999.99"
			ElseIF ALLTRIM(SX3->X3_CAMPO) $ "B1_DESC"
				cPict := SX3->X3_PICTURE
				nTamX3:= 40
			ELSE
				cPict := SX3->X3_PICTURE
				nTamX3:= SX3->X3_TAMANHO
			ENDIF
			Aadd(aHeadFat, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,nTamX3,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

// Define field values
	For nX := 1 to Len(aFldFat)
		If DbSeek(aFldFat[nX])
			Aadd(aFldFFat, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX

	Aadd(aFldFFat, .F.)
	Aadd(aColsFat, aFldFFat)

	If !lProsp
		If ValType(aColsFat[1,1]) <> "U"
			If Len(aColsFat) > 1 .OR. !Empty(aColsFat[1,1] )
				aColsFat := {}
				AADD(aColsFat,Array(Len(aHeadFat)+1))
				aColsFat[Len(aColsFat)][Len(aHeadFat)+1] := .F.
			EndIf
		EndIf

		cQuery := "SELECT SD2.D2_DOC, SD2.D2_COD, SA7.A7_CODCLI, SB1.B1_DESC , SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_EMISSAO "
		cQuery += "FROM "+RetSqlName("SD2")+" SD2 "
		cQuery += "LEFT JOIN "+RetSqlName("SB1")+" SB1 ON "
		cQuery += "SB1.B1_FILIAL  = '"+xFilial("SB1")+ "' " 
		cQuery += "AND   SD2.D2_COD     = SB1.B1_COD "
		cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
		cQuery += "LEFT JOIN "+RetSqlName("SA7")+" SA7 ON     SA7.A7_FILIAL  = '"+xFilial("SA7")+"' "
		cQuery += "                                       AND SA7.A7_PRODUTO = SD2.D2_COD "
		cQuery += "                                       AND SA7.A7_CLIENTE = SD2.D2_CLIENTE "
		cQuery += "                                       AND SA7.A7_LOJA    = SD2.D2_LOJA "
		cQuery += "                                       AND SA7.D_E_L_E_T_ <> '*' "
		cQuery += "WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "
		cQuery += "AND   SD2.D2_CLIENTE = '"+cod_cli+"' "
		cQuery += "AND   SD2.D2_LOJA    = '"+coja_cli+"' "
		cQuery += "AND   SD2.D_E_L_E_T_ <> '*' "
		cQuery += "AND   SD2.D2_TIPO    = 'N' "
		cQuery += "GROUP BY SD2.D2_DOC, SD2.D2_COD, SA7.A7_CODCLI, SB1.B1_DESC, SD2.D2_QUANT, SD2.D2_PRCVEN, SD2.D2_TOTAL, SD2.D2_EMISSAO "
		cQuery += "ORDER BY SD2.D2_COD, SD2.D2_EMISSAO DESC "

		If Select("FAT") > 0
			dbSelectArea("FAT")
			dbCloseArea()
		EndIf

		TcQuery cQuery New Alias "FAT"
		TCSetField("FAT", "D2_EMISSAO", "D")

		DbSelectArea("FAT")
		While !FAT->(Eof())

			If cCodPro == FAT->D2_COD
				FAT->(DbSkip())
				loop
			Endif
		
			cCodPro := FAT->D2_COD
		
			If Len(aColsFat) == 1 .AND. Empty(aColsFat[Len(aColsFat),GdFieldPos("D2_DOC", aHeadFat)] )
				lCria := .F.
			Else
				lCria := .T.
			EndIf
		
			If lCria
				AADD(aColsFat,Array(Len(aHeadFat)+1))
				aColsFat[Len(aColsFat)][Len(aHeadFat)+1] := .F.
			EndIf
		
			aColsFat[Len(aColsFat), GdFieldPos("D2_COD",     aHeadFat)] := FAT->D2_COD
			aColsFat[Len(aColsFat), GdFieldPos("B1_DESC",    aHeadFat)] := FAT->B1_DESC
			aColsFat[Len(aColsFat), GdFieldPos("D2_QUANT",   aHeadFat)]	:= FAT->D2_QUANT
			aColsFat[Len(aColsFat), GdFieldPos("D2_PRCVEN",  aHeadFat)]	:= FAT->D2_PRCVEN
			aColsFat[Len(aColsFat), GdFieldPos("D2_TOTAL",   aHeadFat)]	:= FAT->D2_TOTAL
			aColsFat[Len(aColsFat), GdFieldPos("D2_EMISSAO", aHeadFat)]	:= FAT->D2_EMISSAO
			aColsFat[Len(aColsFat), GdFieldPos("D2_DOC",     aHeadFat)] := FAT->D2_DOC
			aColsFat[Len(aColsFat), GdFieldPos("A7_CODCLI",  aHeadFat)] := FAT->A7_CODCLI

			FAT->(DbSkip())
		End
	Else
		AColsFat := {}
		AADD(aColsFat,Array(Len(aHeadFat)+1))
		aColsFat[Len(aColsFat)][Len(aHeadFat)+1] := .F.
	Endif

	@ C(003),C(340) MSPANEL oPanel PROMPT "Itens Comprados" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
	//oPedFat := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFat,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFat, aColsFat)
	//oPedFat := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFat,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFat, aColsFat)
	//oPedFat := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFat,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFat, aColsFat)
	oPedFat := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFat,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFat, aColsFat)

Return


Static Function f_ncomprados(oDlgVendas, oFolder)
*************************************************
	Local oPanel
	//Local n_comprados
	Local cQuery := ""
	Local cEOL	 := chr(10)+chr(13)
	Local lCria
	Local nX

	//Atualiza Folder 03
	xRshFol3(@oDlgVendas, @oFolder)

	aFldQNC  := {"D2_EMISSAO", "D2_COD", "D2_QUANT", "D2_TOTAL", "D2_DOC", "C5_PEDCLI"}
	aColsQNC := {}
	aHeadQNC := {}
	aFldAQNC := {}
	aFldFQNC := {}

// Define field properties
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFldQNC)
		If SX3->(DbSeek(aFldQNC[nX]))
			IF ALLTRIM(SX3->X3_CAMPO) $ "D2_QUANT/D2_TOTAL"
				cPict := "@E 99,999,999.99"
			else
				cPict := SX3->X3_PICTURE
			endif

			Aadd(aHeadQNC, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

// Define field values
	For nX := 1 to Len(aFldQNC)
		If DbSeek(aFldQNC[nX])
			Aadd(aFldFQNC, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX

	Aadd(aFldFQNC, .F.)
	Aadd(aColsQNC, aFldFQNC)

	If !lProsp
		If Len(aColsQNC) > 1 .OR. !Empty(aColsQNC[1,1] )
			aColsQNC := {}
			AADD(aColsQNC,Array(Len(aHeadQNC)+1))
			aColsQNC[Len(aColsQNC)][Len(aHeadQNC)+1] := .F.
		EndIf
	
		cPerg := Padr("PERCOCKPIT",10)
		U_FUPDSX1(cPerg)
		Pergunte(cPerg, .F.)
	
		cQuery := " SELECT TRB.D2_EMISSAO, TRB.D2_DOC, TRB.D2_CLIENTE, TRB.D2_TOTAL, TRB.D2_QUANT, TRB.D2_COD, SC5.C5_PEDCLI FROM " + cEOL
		cQuery += "   (SELECT SD2.D2_EMISSAO AS D2_EMISSAO, SD2.D2_DOC AS D2_DOC, SD2.D2_CLIENTE AS D2_CLIENTE, SD2.D2_LOJA AS D2_LOJA, ISNULL( SUM(SD2.D2_TOTAL), 0) AS D2_TOTAL, " + cEOL
		cQuery += "      ISNULL( SUM(SD2.D2_QUANT), 0) AS D2_QUANT, SD2.D2_COD AS D2_COD FROM " +RetSqlName("SD2")+ " AS SD2 " + cEOL
		cQuery += "      WHERE '" +xFilial("SD2")+ "' = SD2.D2_FILIAL AND SD2.D2_TIPO = 'N' AND SD2.D2_EMISSAO < '" + DToS(MV_PAR01) + "' "+cEOL
		cQuery += "      		AND SD2.D2_CLIENTE = '" +cod_cli+ "' AND SD2.D2_LOJA = '" +coja_cli+ "' " + cEOL
		cQuery += "      GROUP BY SD2.D2_EMISSAO, SD2.D2_DOC, SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_COD) AS TRB, " +RetSqlName("SC5")+ " AS SC5 " + cEOL
		cQuery += " WHERE (NOT EXISTS (SELECT * FROM " +RetSqlName("SD2")+ " As SD2 WHERE '" +xFilial("SD2")+ "' = SD2.D2_FILIAL AND " + cEOL
		cQuery += "	SD2.D2_CLIENTE     = '" +cod_cli+ "' AND SD2.D2_LOJA = '" + coja_cli + "' AND SD2.D2_TIPO = 'N' AND " + cEOL
		cQuery += " SD2.D2_EMISSAO     BETWEEN '" +DToS(MV_PAR01)+ "' AND '" +DToS(MV_PAR02)+ "' AND SD2.D2_COD = TRB.D2_COD)) " + cEOL
		cQuery += " AND SC5.C5_FILIAL  = '"+xFilial("SC5")+"'" + cEOL
		cQuery += " AND SC5.C5_NOTA    = TRB.D2_DOC " + cEOL
		cQuery += " AND SC5.D_E_L_E_T_ <> '*' " + cEOL

		cQuery += " GROUP BY TRB.D2_EMISSAO, TRB.D2_DOC, TRB.D2_CLIENTE, TRB.D2_TOTAL, TRB.D2_QUANT, TRB.D2_COD, SC5.C5_PEDCLI " + cEOL
		cQuery += " ORDER BY TRB.D2_EMISSAO DESC "

		If Select("QNC") > 0
			dbSelectArea("QNC")
			dbCloseArea()
		EndIf
	
		TcQuery cQuery New Alias "QNC"
		TCSetField("QNC", "D2_VALOR",  "N")
		TCSetField("QNC", "D2_QTDE",   "N")
		TCSetField("QNC", "D2_EMISSAO","D")
	
		DbSelectArea("QNC")
		While !QNC->(Eof())
		
			If Len(aColsQNC) == 1 .AND. Empty(aColsQNC[Len(aColsQNC),GdFieldPos("D2_COD", aHeadQNC)] )
				lCria := .F.
			Else
				lCria := .T.
			EndIf
		
			If lCria
				AADD(aColsQNC,Array(Len(aHeadQNC)+1))
				aColsQNC[Len(aColsQNC)][Len(aHeadQNC)+1] := .F.
			EndIf
	
			aColsQNC[Len(aColsQNC), GdFieldPos("D2_EMISSAO", aHeadQNC)] := QNC->D2_EMISSAO
			aColsQNC[Len(aColsQNC), GdFieldPos("D2_COD",     aHeadQNC)] := QNC->D2_COD
			aColsQNC[Len(aColsQNC), GdFieldPos("D2_QUANT",   aHeadQNC)]	:= QNC->D2_QUANT
			aColsQNC[Len(aColsQNC), GdFieldPos("D2_TOTAL",   aHeadQNC)]	:= QNC->D2_TOTAL
			aColsQNC[Len(aColsQNC), GdFieldPos("D2_DOC",     aHeadQNC)]	:= QNC->D2_DOC
			aColsQNC[Len(aColsQNC), GdFieldPos("C5_PEDCLI",  aHeadQNC)]	:= QNC->C5_PEDCLI
		
			QNC->(DbSkip())
		End
	Else
		aColsQNC := {}
		AADD(aColsQNC,Array(Len(aHeadQNC)+1))
		aColsQNC[Len(aColsQNC)][Len(aHeadQNC)+1] := .F.
	Endif

	@ C(003),C(340) MSPANEL oPanel PROMPT "Não Comprados" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
	//oCliQNC := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAQNC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadQNC, aColsQNC)
	//oCliQNC := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAQNC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadQNC, aColsQNC)
	//oCliQNC := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAQNC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadQNC, aColsQNC)
	oCliQNC := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAQNC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadQNC, aColsQNC)

Return



// Itens NF: que vai mostrar por ordem de data + NF (em ordem decrescente de data) 
// os dados dos itens de NF enviados ao cliente (somente com Status Entregue)

Static Function f_ItensNf(oDlgVendas, oFolder)  // Desenvolvimento por Fabio Gesser em 02/04/2013
**********************************************
	Local oPanel
	Local cQuery := ""
	Local cEOL	 := chr(10)+chr(13)
	Local lCria
	Local nX

	//Atualiza Folder 03
	xRshFol3(@oDlgVendas, @oFolder)

	aFldIFAT := {"F2_DOC", "F2_EMISSAO", "D2_COD", "B1_DESC", "D2_QUANT", "D2_TOTAL"}
	aColsIFAT:= {}
	aHeadIFAT:= {}
	aFldAIFAT:= {}
	aFldFIFAT:= {}

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFldIFAT)
		If SX3->(DbSeek(aFldIFAT[nX]))
			IF ALLTRIM(SX3->X3_CAMPO) $ "D2_QUANT/D2_TOTAL"
				cPict := "@E 99,999,999.99"
			else
				cPict := SX3->X3_PICTURE
			endif

			Aadd(aHeadIFAT, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
				SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX

	For nX := 1 to Len(aFldIFAT)
		If DbSeek(aFldIFAT[nX])
			Aadd(aFldFIFAT, CriaVar(SX3->X3_CAMPO))
		Endif
	Next nX

	Aadd(aFldFIFAT, .F.)
	Aadd(aColsIFAT, aFldFIFAT)

	If !lProsp
		If Len(aColsIFAT) > 1 .OR. !Empty(aColsIFAT[1,1] )
			aColsIFAT := {}
			AADD(aColsIFAT,Array(Len(aHeadIFAT)+1))
			aColsIFAT[Len(aColsIFAT)][Len(aHeadIFAT)+1] := .F.
		EndIf

		cQuery := " SELECT SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_EMISSAO, SD2.D2_COD, SD2.D2_QUANT, SD2.D2_TOTAL, SB1.B1_DESC " + cEOL
		cQuery += " FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, " +RetSqlName("SB1")+" SB1 " + cEOL
		cQuery += " WHERE SF2.F2_FILIAL  = '"+xFilial("SF2")+ "' " + cEOL
		cQuery += " AND   SF2.F2_CLIENTE = '"+cod_cli + "' " + cEOL
		cQuery += " AND   SF2.F2_LOJA    = '"+coja_cli+ "' " + cEOL
		cQuery += " AND   SF2.D_E_L_E_T_ <> '*' " + cEOL
		cQuery += " AND   SD2.D2_FILIAL  = '"+xFilial("SD2")+ "' " + cEOL
		cQuery += " AND   SD2.D2_SERIE   = SF2.F2_SERIE " + cEOL
		cQuery += " AND   SD2.D2_DOC     = SF2.F2_DOC " + cEOL
		cQuery += " AND   SD2.D_E_L_E_T_ <> '*' " + cEOL
		cQuery += " AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+ "' " + cEOL
		cQuery += " AND   SD2.D2_COD     = SB1.B1_COD " + cEOL
		cQuery += " AND   SB1.D_E_L_E_T_ <> '*' " + cEOL
		cQuery += " ORDER BY SF2.F2_EMISSAO DESC " + cEOL

		If Select("IFAT") > 0
			dbSelectArea("IFAT")
			dbCloseArea()
		EndIf
	
		TcQuery cQuery New Alias "IFAT"
		TCSetField("IFAT", "F2_EMISSAO", "D",08,0)
		TCSetField("IFAT", "D2_QUANT"  , "N",12,2)
		TCSetField("IFAT", "D2_TOTAL"  , "N",12,2)
	
		DbSelectArea("IFAT")
		While !IFAT->(Eof())
		
			If Len(aColsIFAT) == 1 .AND. Empty(aColsIFAT[Len(aColsIFAT),GdFieldPos("F2_DOC", aHeadIFAT)] )
				lCria := .F.
			Else
				lCria := .T.
			EndIf
		
			If lCria
				AADD(aColsIFAT,Array(Len(aHeadIFAT)+1))
				aColsIFAT[Len(aColsIFAT)][Len(aHeadIFAT)+1] := .F.
			EndIf
		
			aColsIFAT[Len(aColsIFAT), GdFieldPos("F2_DOC",     aHeadIFAT)]	:= IFAT->F2_DOC
			aColsIFAT[Len(aColsIFAT), GdFieldPos("F2_EMISSAO", aHeadIFAT)]	:= IFAT->F2_EMISSAO
			aColsIFAT[Len(aColsIFAT), GdFieldPos("D2_COD",     aHeadIFAT)]	:= IFAT->D2_COD
			aColsIFAT[Len(aColsIFAT), GdFieldPos("B1_DESC",    aHeadIFAT)]	:= IFAT->B1_DESC
			aColsIFAT[Len(aColsIFAT), GdFieldPos("D2_QUANT",   aHeadIFAT)]	:= IFAT->D2_QUANT
			aColsIFAT[Len(aColsIFAT), GdFieldPos("D2_TOTAL",   aHeadIFAT)]	:= IFAT->D2_TOTAL
		
			IFAT->(DbSkip())
			End
		Else
			aColsIFAT := {}
			AADD(aColsIFAT,Array(Len(aHeadIFAT)+1))
			aColsIFAT[Len(aColsIFAT)][Len(aHeadIFAT)+1] := .F.
		Endif

		@ C(003),C(340) MSPANEL oPanel PROMPT "Itens J?Entregues" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
		//oCliIFAT := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAIFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadIFAT, aColsIFAT)
		//oCliIFAT := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAIFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadIFAT, aColsIFAT)
		//oCliIFAT := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAIFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadIFAT, aColsIFAT)
		oCliIFAT := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAIFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadIFAT, aColsIFAT)

	Return

	Static Function f_faturas(oDlgVendas, oFolder)  // Desenvolvimento por Fabio Gesser em 06/04/2013
**********************************************
		Local oPanel
		Local cQuery := ""
		Local cEOL	 := chr(10)+chr(13)
		Local lCria
		Local nX

		aFldFAT := {"F2_DOC", "F2_EMISSAO", "F2_VALFAT", "D2_PEDIDO", "A3_NOME", "A4_NOME"}
		aColsFAT:= {}
		aHeadFAT:= {}
		aFldAFAT:= {}
		aFldFFAT:= {}

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFldFAT)
			If SX3->(DbSeek(aFldFAT[nX]))

				cTitCp := ""

				IF     UPPER(alltrim(SX3->X3_CAMPO)) == "A3_NOME"
					cTitCp := "Vendedor"
				ELSEIF UPPER(alltrim(SX3->X3_CAMPO)) == "A4_NOME"
					cTitCp := "Transportadora"
				ELSE
					cTitCp := AllTrim(X3Titulo())
				ENDIF

				IF ALLTRIM(SX3->X3_CAMPO) $ "F2_VALFAT"
					cPict := "@E 99,999,999.99"
				else
					cPict := SX3->X3_PICTURE
				endif

				Aadd(aHeadFAT, {AllTrim(cTitCp),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Endif
		Next nX

		For nX := 1 to Len(aFldFAT)
			If DbSeek(aFldFAT[nX])
				Aadd(aFldFFAT, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX

		Aadd(aFldFFAT, .F.)
		Aadd(aColsFAT, aFldFFAT)

		If !lProsp
			If Len(aColsFAT) > 1 .OR. !Empty(aColsFAT[1,1] )
				aColsFAT := {}
				AADD(aColsFAT,Array(Len(aHeadFAT)+1))
				aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
			EndIf

			cQuery := " SELECT SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_EMISSAO, SF2.F2_VALFAT, SD2.D2_PEDIDO, SA3.A3_NOME, SA4.A4_NOME " + cEOL
			cQuery += " FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SF2")+" SF2 " + cEOL
			cQuery += " INNER JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL = '"+xFilial("SA3")+"' AND SA3.A3_COD = SF2.F2_VEND1  AND SA3.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " INNER JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL = '"+xFilial("SA4")+"' AND SA4.A4_COD = SF2.F2_TRANSP AND SA4.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " WHERE SF2.F2_FILIAL  = '"+xFilial("SF2")+ "' " + cEOL
			cQuery += " AND   SF2.F2_CLIENTE = '"+cod_cli + "' " + cEOL
			cQuery += " AND   SF2.F2_LOJA    = '"+coja_cli+ "' " + cEOL
			cQuery += " AND   SF2.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " AND   SD2.D2_FILIAL  = '"+xFilial("SD2")+ "' " + cEOL
			cQuery += " AND   SD2.D2_SERIE   = SF2.F2_SERIE " + cEOL
			cQuery += " AND   SD2.D2_DOC     = SF2.F2_DOC " + cEOL
			cQuery += " AND   SD2.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " GROUP BY SF2.F2_SERIE, SF2.F2_DOC, SF2.F2_EMISSAO, SF2.F2_VALFAT, SD2.D2_PEDIDO, SA3.A3_NOME, SA4.A4_NOME " + cEOL
			cQuery += " ORDER BY SF2.F2_EMISSAO DESC " + cEOL
	
			If Select("FAT") > 0
				dbSelectArea("FAT")
				dbCloseArea()
			EndIf
	
			TcQuery cQuery New Alias "FAT"
			TCSetField("FAT", "F2_EMISSAO", "D",08,0)
			TCSetField("FAT", "F2_VALFAT" , "N",12,2)
	
			DbSelectArea("FAT")
			While !FAT->(Eof())
		
				If Len(aColsFAT) == 1 .AND. Empty(aColsFAT[Len(aColsFAT),GdFieldPos("F2_DOC", aHeadFAT)] )
					lCria := .F.
				Else
					lCria := .T.
				EndIf
		
				If lCria
					AADD(aColsFAT,Array(Len(aHeadFAT)+1))
					aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
				EndIf
		
				aColsFAT[Len(aColsFAT), GdFieldPos("F2_DOC",     aHeadFAT)]	:= FAT->F2_DOC
				aColsFAT[Len(aColsFAT), GdFieldPos("F2_EMISSAO", aHeadFAT)]	:= FAT->F2_EMISSAO
				aColsFAT[Len(aColsFAT), GdFieldPos("F2_VALFAT",  aHeadFAT)]	:= FAT->F2_VALFAT
				aColsFAT[Len(aColsFAT), GdFieldPos("D2_PEDIDO",  aHeadFAT)]	:= FAT->D2_PEDIDO
				aColsFAT[Len(aColsFAT), GdFieldPos("A3_NOME",    aHeadFAT)]	:= FAT->A3_NOME
				aColsFAT[Len(aColsFAT), GdFieldPos("A4_NOME",    aHeadFAT)]	:= FAT->A4_NOME
		
				FAT->(DbSkip())
			End
		Else
			aColsFAT := {}
			AADD(aColsFAT,Array(Len(aHeadFAT)+1))
			aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
		Endif

		@ C(003),C(340) MSPANEL oPanel PROMPT "Faturas" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
		//oCliFAT := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
		//oCliFAT := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
		//oCliFAT := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
		oCliFAT := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)

	Return


// Criar botão que apresente todos os pedidos colocados para o item selecionado (de todos os clientes) 
// Mostrar os campos: ENTREGA, N.PEDIDO,  COD/LOJA CLIENTE, NOME FANTASIA, STATUS PV,  SALDO, QTD PV

	Static Function f_peditem(oDlgVendas, oFolder)  // Desenvolvimento por Fabio Gesser em 04/04/2013
**********************************************
		Local oPanel
		Local cQuery := ""
		Local cEOL	 := chr(10)+chr(13)
		Local nX

		IF gCod_produto == SPACE(15)
			MSGINFO("Para esta consulta ?obrigatório informar o código do produto", "Produto não Preenchido")
		Return
		Endif
        // Renato Bandeira em 20/02/15 - Novo campo contendo Local do Cliente
		//aFldPEDI := {"C6_ENTREG", "C6_NUM", "C6_CLI", "C6_LOJA", "A1_NREDUZ","Z04_DESC","C6_QTDVEN","C6_QTDENT","C6_QTDLIB"}
		aFldPEDI := {"C6_ENTREG", "C6_NUM", "C6_CLI", "C6_LOJA", "A1_NREDUZ","Z04_DESC","C6_QTDVEN","C6_QTDENT","C6_QTDLIB"}
		aColsPEDI:= {}
		aHeadPEDI:= {}
		aFldAPEDI:= {}
		aFldFPEDI:= {}

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFldPEDI)
			If SX3->(DbSeek(aFldPEDI[nX]))
				IF UPPER(alltrim(SX3->X3_CAMPO)) $ "C6_QTDENT/C6_QTDVEN/C6_QTDLIB"
					IF     UPPER(alltrim(SX3->X3_CAMPO)) == "C6_QTDVEN"
						cTitCp := "Qtde Vendida"
					ELSEIF UPPER(alltrim(SX3->X3_CAMPO)) == "C6_QTDENT"
						cTitCp := "Qtde Entregue"
					ELSE
						cTitCp := "Saldo Pedido"
					ENDIF
				ELSE
					cTitCp := AllTrim(X3Titulo())
				ENDIF

				IF ALLTRIM(SX3->X3_CAMPO) $ "C6_QTDENT/C6_QTDVEN/C6_QTDLIB"
					cPict := "@E 99,999,999.99"
				else
					cPict := SX3->X3_PICTURE
				endif

				Aadd(aHeadPEDI, {AllTrim(cTitCp),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Endif
		Next nX

		For nX := 1 to Len(aFldPEDI)
			If DbSeek(aFldPEDI[nX])
				Aadd(aFldFPEDI, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX

		Aadd(aFldFPEDI, .F.)
		Aadd(aColsPEDI, aFldFPEDI)

		If !lProsp
			If Len(aColsPEDI) > 1 .OR. !Empty(aColsPEDI[1,1] )
				aColsPEDI := {}
				AADD(aColsPEDI,Array(Len(aHeadPEDI)+1))
				aColsPEDI[Len(aColsPEDI)][Len(aHeadPEDI)+1] := .F.
			EndIf
	
	        // Renato Bandeira em 20/02/15 - Novo campo contendo Local do Cliente
			//cQuery := " SELECT SC6.C6_ENTREG, SC6.C6_NUM, SC6.C6_CLI, SC6.C6_LOJA, SA1.A1_NREDUZ, Z04.Z04_DESC, SC6.C6_QTDVEN, SC6.C6_QTDENT, (SC6.C6_QTDVEN-SC6.C6_QTDENT) SALDO " + cEOL
			cQuery := " SELECT SC6.C6_ENTREG, SC6.C6_NUM, SC6.C6_CLI, SC6.C6_LOJA, SA1.A1_NREDUZ, Z04.Z04_DESC, SC6.C6_QTDVEN, SC6.C6_QTDENT, (SC6.C6_QTDVEN-SC6.C6_QTDENT) SALDO " + cEOL
			cQuery += " FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5, "+RetSqlName("SA1")+" SA1, "+RetSqlName("Z04")+" Z04 " + cEOL
			cQuery += " WHERE SC6.C6_FILIAL  = '"+xFilial("SC6")+ "' " + cEOL
			cQuery += " AND   SC6.C6_PRODUTO = '"+AllTrim(gCod_produto)+"' " + cEOL
			cQuery += " AND   SC6.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " AND   SC5.C5_FILIAL  = '"+xFilial("SC5")+ "' " + cEOL
			cQuery += " AND   SC5.C5_NUM     = SC6.C6_NUM " + cEOL
			cQuery += " AND   SC5.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " AND   SA1.A1_FILIAL  = '"+xFilial("SA1")+ "' " + cEOL
			cQuery += " AND   SA1.A1_COD     = SC6.C6_CLI " + cEOL
			cQuery += " AND   SA1.A1_LOJA    = SC6.C6_LOJA " + cEOL
			cQuery += " AND   SA1.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " AND   Z04.Z04_FILIAL = '"+xFilial("Z04")+ "' " + cEOL
			cQuery += " AND   Z04.Z04_COD    = SC5.C5_XSTATUS " + cEOL
			cQuery += " AND   Z04.D_E_L_E_T_ <> '*' " + cEOL
			cQuery += " ORDER BY SC6.C6_ENTREG DESC " + cEOL
	
			If Select("PEDI") > 0
				dbSelectArea("PEDI")
				dbCloseArea()
			EndIf
	
			TcQuery cQuery New Alias "PEDI"
			TCSetField("PEDI", "C6_ENTREG" , "D",08,0)
			TCSetField("PEDI", "C6_QTDVEN" , "N",12,2)
			TCSetField("PEDI", "C6_QTDENT" , "N",12,2)
			TCSetField("PEDI", "SALDO"     , "N",12,2)
	
			DbSelectArea("PEDI")
			While !PEDI->(Eof())
		
				If Len(aColsPEDI) == 1 .AND. Empty(aColsPEDI[Len(aColsPEDI),GdFieldPos("C6_NUM", aHeadPEDI)] )
					lCria := .F.
				Else
					lCria := .T.
				EndIf
		
				If lCria
					AADD(aColsPEDI,Array(Len(aHeadPEDI)+1))
					aColsPEDI[Len(aColsPEDI)][Len(aHeadPEDI)+1] := .F.
				EndIf

				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_ENTREG",  aHeadPEDI)]	:= PEDI->C6_ENTREG
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_NUM",     aHeadPEDI)]	:= PEDI->C6_NUM
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_CLI",     aHeadPEDI)]	:= PEDI->C6_CLI
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_LOJA",    aHeadPEDI)]	:= PEDI->C6_LOJA
		        // Renato Bandeira em 20/02/15 - Novo campo contendo Local do Cliente
				//aColsPEDI[Len(aColsPEDI), GdFieldPos("A1_NREDUZ",  aHeadPEDI)]	:= PEDI->A1_NREDUZ
				aColsPEDI[Len(aColsPEDI), GdFieldPos("A1_NREDUZ", aHeadPEDI)]	:= PEDI->A1_NREDUZ
				aColsPEDI[Len(aColsPEDI), GdFieldPos("Z04_DESC",   aHeadPEDI)]	:= PEDI->Z04_DESC
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_QTDVEN",  aHeadPEDI)]	:= PEDI->C6_QTDVEN
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_QTDENT",  aHeadPEDI)]	:= PEDI->C6_QTDENT
				aColsPEDI[Len(aColsPEDI), GdFieldPos("C6_QTDLIB",  aHeadPEDI)]	:= PEDI->SALDO
		
				PEDI->(DbSkip())
			End
		Else
			aColsPEDI := {}
			AADD(aColsPEDI,Array(Len(aHeadPEDI)+1))
			aColsPEDI[Len(aColsPEDI)][Len(aHeadPEDI)+1] := .F.
		Endif

		@ C(003),C(340) MSPANEL oPanel PROMPT "Pedidos do Item "+AllTrim(gCod_produto) SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
		//oCliPEDI := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAPEDI,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadPEDI, aColsPEDI)
		//oCliPEDI := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAPEDI,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadPEDI, aColsPEDI)
		//oCliPEDI := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAPEDI,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadPEDI, aColsPEDI)
		oCliPEDI := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAPEDI,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadPEDI, aColsPEDI)

	Return

Static Function f_Orcamento(oFolder)
************************************************
Local nX

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	SX3->(DbSeek(aFields[nX]))
	
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	//IF ALLTRIM(aFields[nX]) $ "UB_QUANT/UB_VRUNIT/UB_VLRITEM"
	//	cPict := "@E 99,999,999.99"
	//else
	cPict := SX3->X3_PICTURE
	//endif
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	
	If aFields[nX] == "UB_QUANT" .OR. aFields[nX] == "UB_VRUNIT"
		Aadd(__aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"u_DnyMudOrc()",;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Else
		Aadd(__aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX


Aadd(aFieldFill, .F.)
Aadd(__aColsEx, aFieldFill)
__aCAuxOrc := aClone(__aColsEx)

//@ C(155), C(005) SAY oSayIOrc PROMPT "Itens Orcamento" SIZE C(100), C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
//oOrcamento := MsNewGetDados():New( C(165), C(005), C(250), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "Eval(bfDeleta)"/*"AllwaysTrue"*/, oFolder:aDialogs[3], __aHeaderEx, __aColsEx)

//@ C(135), C(005) SAY oSayIOrc PROMPT "Itens Orcamento" SIZE C(100), C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
@ C(125), C(005) SAY oSayIOrc PROMPT "Itens Orcamento" SIZE C(100), C(009) OF oFolder:aDialogs[3] COLORS 0, 16777215 PIXEL
//oOrcamento := MsNewGetDados():New( C(145), C(005), C(230), C(645), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "Eval(bfDeleta)"/*"AllwaysTrue"*/, oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
//oOrcamento := MsNewGetDados():New( C(145), C(005), C(230), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "Eval(bfDeleta)"/*"AllwaysTrue"*/, oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
oOrcamento := MsNewGetDados():New( C(135), C(005), C(220), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "Eval(bfDeleta)"/*"AllwaysTrue"*/, oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
//Definicao da cor da linha dos produto
oOrcamento:oBrowse:lUseDefaultColors := .F.
oOrcamento:oBrowse:SetBlkBackColor({|| goGETDCLR(oOrcamento:aCols,oOrcamento:nAt,__aHeaderEx)})
oOrcamento:oBrowse:bChange := {|x| FSVLDLIN() }

oFolder:aDialogs[3]:Refresh()
Return


Static Function f_pedidos(oDlgVendas, oFolder)  // Desenvolvimento por Fabio Gesser em 02/04/2013
**********************************************
		Local oPanel
		Local cQuery := ""
		//Local cEOL	 := chr(10)+chr(13)
		Local lCria
		Local nX

		//Atualiza Folder 03
		xRshFol3(@oDlgVendas, @oFolder)

		aFldxPED  := {"C5_NUM", "C5_EMISSAO", "C5_PEDCLI", "C6_NOTA", "C6_DATFAT", "C5_ESPECI1", "C5_XDESST", "E4_DESCRI", "XX_PRAZO", "A4_NOME", "C5_TPFRETE", "A3_NOME"}
		aColsxPED := {}
		aHeadxPED := {}
		aFldAxPED := {}
		aFldFxPED := {}

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFldxPED)
			If SX3->(DbSeek(aFldxPED[nX])) .and. ALLTRIM(aFldxPED[nX]) <> "XX_PRAZO"
				IF ALLTRIM(aFldxPED[nX]) $ "C5_ESPECI1/C5_NOTA/E4_DESCRI/A4_NOME/A3_NOME"
					IF     ALLTRIM(aFldxPED[nX]) == "C5_ESPECI1"
						cTit := "OBS"
					ELSEIF ALLTRIM(aFldxPED[nX]) == "C5_NOTA"
						cTit := "Ult. Nota"
					ELSEIF ALLTRIM(aFldxPED[nX]) == "E4_DESCRI"
						cTit := "Cond.Pagto"
					ELSEIF ALLTRIM(aFldxPED[nX]) == "A3_NOME"
						cTit := "Vendedor"
					ELSE
						cTit := "Transportadora"
					ENDIF
				else
					cTit := AllTrim(X3Titulo())
				endif

				Aadd(aHeadxPED, {cTit,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			else
				SX3->(DbSeek("C5_NUM"))
				Aadd(aHeadxPED, {"Prazo","XX_PRAZO","@!",20,0,"",SX3->X3_USADO,"C","","R","",""})
			Endif
		Next nX

		For nX := 1 to Len(aFldxPED)
			If DbSeek(aFldxPED[nX]) .and. ALLTRIM(aFldxPED[nX]) <> "XX_PRAZO"
				Aadd(aFldFxPED, CriaVar(SX3->X3_CAMPO))
			else
				Aadd(aFldFxPED, space(20))
			Endif
		Next nX

		Aadd(aFldFxPED, .F.)
		Aadd(aColsxPED, aFldFxPED)

		If !lProsp
			If Len(aColsxPED) > 1 .OR. !Empty(aColsxPED[1,1] )
				aColsxPED := {}
				AADD(aColsxPED,Array(Len(aHeadxPED)+1))
				aColsxPED[Len(aColsxPED)][Len(aHeadxPED)+1] := .F.
			EndIf

			cQuery := "SELECT SC5.C5_NUM, SC5.C5_EMISSAO, Z04.Z04_DESC, MAX(SC6.C6_NOTA) C6_NOTA, MAX(SC6.C6_DATFAT) C6_DATFAT, SC5.C5_PEDCLI, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, "
			cQuery += "       SUM(SC6.C6_QTDVEN) AS QTDVEN, SUM(SC6.C6_QTDENT) AS QTDENT, (SELECT SUM(C6.C6_QTDVEN) "
			cQuery += "                                                                    FROM "+RetSqlName("SC6")+" C6 "
			cQuery += "                                                                    WHERE C6.C6_FILIAL   = '"+xFilial("SC6")+"' "
			cQuery += "                                                                    AND   C6.C6_NUM      = SC6.C6_NUM "
			cQuery += "                                                                    AND   C6.C6_BLQ      = 'R' "
			cQuery += "                                                                    AND   C6.D_E_L_E_T_ <> '*' "
			cQuery += "                                                                    GROUP BY C6.C6_NUM) AS QTDRES, SC5.C5_TPFRETE "
//	cQuery := "SELECT SC5.C5_NUM, SC5.C5_EMISSAO, Z04.Z04_DESC, "
//	cQuery += "       CASE "
//	cQuery += "           WHEN SUM(SC6.C6_QTDVEN)-SUM(SC6.C6_QTDENT)         = 0 THEN 'TOTAL' "
//	cQuery += "           WHEN SUM(SC6.C6_QTDVEN) > 0 AND SUM(SC6.C6_QTDENT) = 0 THEN 'ABERTO' "
//	cQuery += "           WHEN SC6.C6_BLQ = 'R'                                  THEN 'PARCIAL C/RES' "
//	cQuery += "           ELSE 'PARCIAL' "
//	cQuery += "       END AS TIPO, MAX(SC6.C6_NOTA) C6_NOTA, MAX(SC6.C6_DATFAT) C6_DATFAT, SC5.C5_PEDCLI, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME "
			cQuery += "FROM "+RetSqlName("SC6")+" SC6, "+RetSqlName("SC5")+" SC5 "
			cQuery += "LEFT JOIN "+RetSqlName("Z04")+" Z04 ON Z04.Z04_FILIAL = '"+xFilial("Z04")+"' AND Z04.Z04_COD   = SC5.C5_XSTATUS AND Z04.D_E_L_E_T_ <> '*' "
			cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL  = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ <> '*' "
			cQuery += "LEFT JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL  = '"+xFilial("SA4")+"' AND SA4.A4_COD    = SC5.C5_TRANSP  AND SA4.D_E_L_E_T_ <> '*' "
			cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL  = '"+xFilial("SA3")+"' AND SA3.A3_COD    = SC5.C5_VEND1   AND SA3.D_E_L_E_T_ <> '*' "
			cQuery += "WHERE SC5.C5_FILIAL  = '"+xFilial("SC5")+"' "
			cQuery += "AND   SC5.C5_CLIENTE = '"+cod_cli + "' "
			cQuery += "AND   SC5.C5_LOJACLI = '"+coja_cli+ "' "
			cQuery += "AND   SC5.D_E_L_E_T_ <> '*' "
			cQuery += "AND   SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "
			cQuery += "AND   SC6.C6_NUM     = SC5.C5_NUM "
//	cQuery += "AND   SC6.C6_BLQ     <> 'R' "
			cQuery += "AND   SC6.D_E_L_E_T_ <> '*' "
//	cQuery += "AND   SC6.C6_NUM     NOT IN (SELECT A.C6_NUM FROM "+RetSqlName("SC6")+" A WHERE A.C6_FILIAL = '"+xFilial("SC6")+"' "
//	cQuery += "                                                           AND   A.C6_NUM    = SC6.C6_NUM "
//	cQuery += "                                                           AND   A.C6_PRODUTO = SC6.C6_PRODUTO "
//	cQuery += "                                                           AND   A.C6_BLQ    = 'R' "
//	cQuery += "                                                           AND   A.C6_NOTA   = '         ' "
//	cQuery += "                                                           AND   A.C6_QTDVEN-A.C6_QTDENT > 0.00) "
			cQuery += "GROUP BY SC5.C5_NUM, SC5.C5_EMISSAO, Z04.Z04_DESC, SC5.C5_PEDCLI, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, SC6.C6_NUM, SC5.C5_TPFRETE "
			cQuery += "ORDER BY SC5.C5_NUM DESC "
	
			If Select("PED") > 0
				dbSelectArea("PED")
				dbCloseArea()
			EndIf
	
			TcQuery cQuery New Alias "PED"
			TCSetField("PED", "C5_EMISSAO", "D",08,00)
			TCSetField("PED", "C6_DATFAT",  "D",08,00)
			TCSetField("PED", "QTDVEN",     "N",12,02)
			TCSetField("PED", "QTDENT",     "N",12,02)
			TCSetField("PED", "QTDRES",     "N",12,02)
	
			DbSelectArea("PED")
			While !PED->(Eof())
		
				If Len(aColsxPED) == 1 .AND. Empty(aColsxPED[Len(aColsxPED),GdFieldPos("C5_NUM", aHeadxPED)] )
					lCria := .F.
				Else
					lCria := .T.
				EndIf
		
				If lCria
					AADD(aColsxPED,Array(Len(aHeadxPED)+1))
					aColsxPED[Len(aColsxPED)][Len(aHeadxPED)+1] := .F.
				EndIf

				IF     Ped->QTDVEN == PED->QTDENT
					cTipoPed := "TOTAL        "
				ElseIf Ped->QTDRES > 0.00
					cTipoPed := "PARCIAL C/RES"
				ElseIf Ped->QTDRES == 0.00 .AND. PED->QTDENT == 0.00
					cTipoPed := "ABERTO       "
				Else
					cTipoPed := "PARCIAL      "
				Endif

				//Verificar condicao negociada
				cPrazo := ""
				SC5->(dbSetOrder(1))
				if SC5->(msSeek(xFilial('SC5') + PED->C5_NUM))
					if alltrim(SC5->C5_CONDPAG) == "900" .and. !empty(SC5->C5_XDIAS1 + SC5->C5_XDIAS2 + SC5->C5_XDIAS3 + SC5->C5_XDIAS4)
						cPrazo += iif(!empty(SC5->C5_XDIAS1), alltrim(str(SC5->C5_XDIAS1)), "")
						cPrazo += iif(!empty(SC5->C5_XDIAS2), "/"+alltrim(str(SC5->C5_XDIAS2)), "")
						cPrazo += iif(!empty(SC5->C5_XDIAS3), "/"+alltrim(str(SC5->C5_XDIAS3)), "")
						cPrazo += iif(!empty(SC5->C5_XDIAS4), "/"+alltrim(str(SC5->C5_XDIAS4)), "")
						cPrazo += " DIAS"
					endif
				endif
		
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_NUM",     aHeadxPED)]	:= PED->C5_NUM
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_EMISSAO", aHeadxPED)]	:= PED->C5_EMISSAO
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_PEDCLI",  aHeadxPED)]	:= PED->C5_PEDCLI
				aColsxPED[Len(aColsxPED), GdFieldPos("C6_NOTA",    aHeadxPED)]	:= PED->C6_NOTA
				aColsxPED[Len(aColsxPED), GdFieldPos("C6_DATFAT",  aHeadxPED)]	:= PED->C6_DATFAT
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_ESPECI1", aHeadxPED)]	:= cTipoPed
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_XDESST",  aHeadxPED)]	:= PED->Z04_DESC
				aColsxPED[Len(aColsxPED), GdFieldPos("E4_DESCRI",  aHeadxPED)]	:= PED->E4_DESCRI
				aColsxPED[Len(aColsxPED), GdFieldPos("XX_PRAZO",   aHeadxPED)]	:= cPrazo
				aColsxPED[Len(aColsxPED), GdFieldPos("A4_NOME",    aHeadxPED)]	:= PED->A4_NOME
				aColsxPED[Len(aColsxPED), GdFieldPos("C5_TPFRETE", aHeadxPED)]	:= PED->C5_TPFRETE
				aColsxPED[Len(aColsxPED), GdFieldPos("A3_NOME",    aHeadxPED)]	:= PED->A3_NOME

				PED->(DbSkip())
			End
		Else
			aColsxPED := {}
			AADD(aColsxPED,Array(Len(aHeadxPED)+1))
			aColsxPED[Len(aColsxPED)][Len(aHeadxPED)+1] := .F.
		Endif

		@ C(003),C(340) MSPANEL oPanel PROMPT "Pedidos" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
		//oCliPED := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxPED,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxPED, aColsxPED)
		//oCliPED := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxPED,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxPED, aColsxPED)
		//oCliPED := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxPED,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxPED, aColsxPED)
		oCliPED := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxPED,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxPED, aColsxPED)
		oCliPED:OBROWSE:BRCLICKED  := {|| OnClicPED()}
		oCliPED:oBrowse:bLDblClick := {|| OnClicPED()}

	Return


Static Function f_orc(oDlgVendas, oFolder)  // Desenvolvimento por Fabio Gesser em 02/04/2013
**********************************************
		Local oPanel
		Local cQuery := ""
		//Local cEOL	 := chr(10)+chr(13)
		Local lCria
		Local nX

		//Atualiza Folder 03
		xRshFol3(@oDlgVendas, @oFolder)

		//aFldxORC  := {"UA_NUM", "UA_EMISSAO", "UA_NUMSC5","E4_DESCRI", "A4_NOME", "UA_TPFRETE", "A3_NOME"}
		aFldxORC  := {"UA_NUM", "UA_EMISSAO", "UA_NUMSC5","E4_DESCRI", "XX_PRAZO", "A4_NOME", "UA_TPFRETE", "A3_NOME"}
		aColsxORC := {}
		aHeadxORC := {}
		aFldAxORC := {}
		aFldFxORC := {}

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFldxORC)
			If SX3->(DbSeek(aFldxORC[nX])) .and. ALLTRIM(aFldxORC[nX]) <> "XX_PRAZO"
				IF ALLTRIM(aFldxORC[nX]) $ "UA_NUM/UA_EMISSAO/E4_DESCRI/A4_NOME/A3_NOME/UA_NUMSC5/UA_TPFRETE"
				    IF ALLTRIM(aFldxORC[nX]) == "E4_DESCRI"
						cTit2 := "Cond.Pagto"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "A3_NOME"
						cTit2 := "Vendedor"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "UA_NUMSC5"
						cTit2 := "Pedido"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "A4_NOME"
						cTit2 := "Transportadora"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "UA_NUM"
						cTit2 := "Orcamento"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "UA_EMISSAO"
						cTit2 := "Emissao"
					ELSEIF ALLTRIM(aFldxORC[nX]) == "UA_TPFRETE"
						cTit2 := "TP.FRETE"
					ENDIF
				else
					cTit2 := ''//AllTrim(X3Titulo())
				endif

				Aadd(aHeadxORC, {cTit2,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			
			else
				SX3->(DbSeek("UA_NUM"))
				Aadd(aHeadxORC, {"Prazo","XX_PRAZO","@!",20,0,"",SX3->X3_USADO,"C","","R","",""})
			Endif
		Next nX

		For nX := 1 to Len(aFldxORC)
			If DbSeek(aFldxORC[nX]) .and. ALLTRIM(aFldxORC[nX]) <> "XX_PRAZO"
				Aadd(aFldFxORC, CriaVar(SX3->X3_CAMPO))
			else
				Aadd(aFldFxORC, space(20))
			Endif
		Next nX

		Aadd(aFldFxORC, .F.)
		Aadd(aColsxORC, aFldFxORC)

		If !lProsp
			If Len(aColsxORC) > 1 .OR. !Empty(aColsxORC[1,1] )
				aColsxORC := {}
				AADD(aColsxORC,Array(Len(aHeadxORC)+1))
				aColsxORC[Len(aColsxORC)][Len(aHeadxORC)+1] := .F.
			EndIf

			
			cQuery := "SELECT UA_NUM, UA_EMISSAO, UA_NUMSC5, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, " 
			cQuery += "       SUM(SUB.UB_QUANT) AS QTDVEN,UA_TPFRETE  "
			cQuery += ", UA_XDIAS1, UA_XDIAS2, UA_XDIAS3, UA_XDIAS4, UA_CONDPG "
			cQuery += "FROM "+RetSqlName("SUB")+" SUB, "+RetSqlName("SUA")+" SUA "
			cQuery += "LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.E4_FILIAL  = '"+xFilial("SE4")+"' AND SE4.E4_CODIGO  = SUA.UA_CONDPG AND SE4.D_E_L_E_T_ <> '*'   "
			cQuery += "LEFT JOIN "+RetSqlName("SA4")+" SA4 ON SA4.A4_FILIAL  = '"+xFilial("SA4")+"' AND SA4.A4_COD    = SUA.UA_TRANSP  AND SA4.D_E_L_E_T_ <> '*'  "
			cQuery += "LEFT JOIN "+RetSqlName("SA3")+" SA3 ON SA3.A3_FILIAL  = '"+xFilial("SA3")+"' AND SA3.A3_COD   = SUA.UA_VEND   AND SA3.D_E_L_E_T_ <> '*'    "
			cQuery += "WHERE SUA.UA_FILIAL  = '"+xFilial("SUA")+"' "
			cQuery += "AND   SUA.UA_CLIENTE = '"+cod_cli + "' "
			cQuery += "AND   SUA.UA_LOJA = '"+coja_cli+ "' "
			cQuery += "AND   SUA.D_E_L_E_T_ <> '*' "
			cQuery += "AND   SUB.UB_FILIAL  = '"+xFilial("SUB")+"' "
			cQuery += "AND   SUB.UB_NUM     = SUA.UA_NUM "
			cQuery += "AND   SUB.D_E_L_E_T_ <> '*'          "
			cQuery += "GROUP BY SUA.UA_NUM, SUA.UA_EMISSAO, SUA.UA_NUMSC5, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, SUB.UB_NUM, SUA.UA_TPFRETE, UA_XDIAS1, UA_XDIAS2, UA_XDIAS3, UA_XDIAS4, UA_CONDPG  "
			cQuery += "ORDER BY SUA.UA_NUM DESC                                        "
			
			If Select("ORCC") > 0
				dbSelectArea("ORCC")
				dbCloseArea()
			EndIf
	
			TcQuery cQuery New Alias "ORCC"
			TCSetField("ORCC", "UA_EMISSAO", "D",08,00)
			TCSetField("ORCC", "QTDVEN",     "N",12,02)
			TCSetField("ORCC", "UA_XDIAS1",  "N",03,00)
			TCSetField("ORCC", "UA_XDIAS2",  "N",03,00)
			TCSetField("ORCC", "UA_XDIAS3",  "N",03,00)
			TCSetField("ORCC", "UA_XDIAS4",  "N",03,00)
			
			DbSelectArea("ORCC")
			While !ORCC->(Eof())
		
				If Len(aColsxORC) == 1 .AND. Empty(aColsxORC[Len(aColsxORC),GdFieldPos("UA_NUM", aHeadxORC)] )
					lCria := .F.
				Else
					lCria := .T.
				EndIf
		
				If lCria
					AADD(aColsxORC,Array(Len(aHeadxORC)+1))
					aColsxORC[Len(aColsxORC)][Len(aHeadxORC)+1] := .F.
				EndIf

				cPrazo := ""
				if alltrim(ORCC->UA_CONDPG) == "900" .and. !empty(ORCC->UA_XDIAS1 + ORCC->UA_XDIAS2 + ORCC->UA_XDIAS3 + ORCC->UA_XDIAS4)
					cPrazo += iif(!empty(ORCC->UA_XDIAS1), alltrim(str(ORCC->UA_XDIAS1)), "")
					cPrazo += iif(!empty(ORCC->UA_XDIAS2), "/"+alltrim(str(ORCC->UA_XDIAS2)), "")
					cPrazo += iif(!empty(ORCC->UA_XDIAS3), "/"+alltrim(str(ORCC->UA_XDIAS3)), "")
					cPrazo += iif(!empty(ORCC->UA_XDIAS4), "/"+alltrim(str(ORCC->UA_XDIAS4)), "")
					cPrazo += " DIAS"
				endif

				
				aColsxORC[Len(aColsxORC), GdFieldPos("UA_NUM",     aHeadxORC)]	:= ORCC->UA_NUM
				aColsxORC[Len(aColsxORC), GdFieldPos("UA_EMISSAO", aHeadxORC)]	:= ORCC->UA_EMISSAO
				aColsxORC[Len(aColsxORC), GdFieldPos("UA_NUMSC5",  aHeadxORC)]	:= ORCC->UA_NUMSC5
				aColsxORC[Len(aColsxORC), GdFieldPos("E4_DESCRI",  aHeadxORC)]	:= ORCC->E4_DESCRI
				aColsxORC[Len(aColsxORC), GdFieldPos("XX_PRAZO",   aHeadxORC)]	:= cPrazo
				aColsxORC[Len(aColsxORC), GdFieldPos("A4_NOME",    aHeadxORC)]	:= ORCC->A4_NOME
				aColsxORC[Len(aColsxORC), GdFieldPos("UA_TPFRETE", aHeadxORC)]	:= ORCC->UA_TPFRETE
				aColsxORC[Len(aColsxORC), GdFieldPos("A3_NOME",    aHeadxORC)]	:= ORCC->A3_NOME

				ORCC->(DbSkip())
			End
		Else
			aColsxORC := {}
			AADD(aColsxORC,Array(Len(aHeadxORC)+1))
			aColsxORC[Len(aColsxORC)][Len(aHeadxORC)+1] := .F.
		Endif

	   	@ C(003),C(340) MSPANEL oPanel PROMPT "Orcamentos" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
	    //MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxORC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxORC, aColsxORC)
	    //MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxORC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxORC, aColsxORC)
	    //MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxORC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxORC, aColsxORC)
	    MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAxORC,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadxORC, aColsxORC)
	 //	oCliPED:OBROWSE:BRCLICKED  := {|| OnClicOrc()}
	 //	oCliPED:oBrowse:bLDblClick := {|| OnClicorc()}

	Return






	Static Function OnClicPED()  // Desenvolvimento por Fabio Gesser em 02/04/2013
***************************
		Local oDlgIPED
		//Local oPanel
		Local cQuery := ""
		Local cEOL	 := chr(10)+chr(13)
		Local lCria
		Local nX

		aFldIPED  := {"C6_PRODUTO", "D2_QUANT", "D2_PRCVEN", "D2_TOTAL", "C6_QTDVEN", "C6_QTDLIB"}
		aColsIPED := {}
		aHeadIPED := {}
		aFldAIPED := {}
		aFldFIPED := {}

		DbSelectArea("SX3")
		SX3->(DbSetOrder(2))
		For nX := 1 to Len(aFldIPED)
			If SX3->(DbSeek(aFldIPED[nX]))

				cTitCp := ""

				IF     UPPER(alltrim(SX3->X3_CAMPO)) == "C6_QTDVEN"
					cTitCp := "Quant.Pendente"
				ELSEIF UPPER(alltrim(SX3->X3_CAMPO)) == "D2_QUANT"
					cTitCp := "Quant.Faturada"
				ELSEIF UPPER(alltrim(SX3->X3_CAMPO)) == "C6_QTDLIB"
					cTitCp := "Quant.Residuo"
				ELSE
					cTitCp := AllTrim(X3Titulo())
				ENDIF

				IF ALLTRIM(SX3->X3_CAMPO) $ "D2_QUANT/C6_QTDVEN/C6_QTDLIB/D2_PRCVEN/D2_TOTAL"
					cPict := "@E 99,999,999.99"
				else
					cPict := SX3->X3_PICTURE
				endif

				Aadd(aHeadIPED, {cTitCp,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Endif
		Next nX

		For nX := 1 to Len(aFldIPED)
			If DbSeek(aFldIPED[nX])
				Aadd(aFldFIPED, CriaVar(SX3->X3_CAMPO))
			Endif
		Next nX

		Aadd(aFldFIPED, .F.)
		Aadd(aColsIPED, aFldFIPED)

		If !lProsp
			If Len(aColsIPED) > 1 .OR. !Empty(aColsIPED[1,1] )
				aColsIPED := {}
				AADD(aColsIPED,Array(Len(aHeadIPED)+1))
				aColsIPED[Len(aColsIPED)][Len(aHeadIPED)+1] := .F.
			EndIf

			cQuery := "SELECT SC6.C6_NUM PEDIDO, SC6.C6_PRODUTO PRODUTO, SC6.C6_QTDVEN QTDVEN, (SELECT SUM(SD2.D2_QUANT) D2_QUANT "+ cEOL
			cQuery += "                                                                         FROM "+RetSqlName("SD2")+" SD2 "+ cEOL
			cQuery += "                                                                         WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+ "' " + cEOL
			cQuery += "                                                                         AND   SD2.D2_PEDIDO  = SC6.C6_NUM "+ cEOL
			cQuery += "                                                                         AND   SD2.D2_COD     = SC6.C6_PRODUTO "+ cEOL
			cQuery += "                                                                         AND   SD2.D_E_L_E_T_ <> '*') "+ cEOL
			cQuery += "                                                                         AS QUANT, SC6.C6_PRCVEN PRCVEN, SC6.C6_PRCVEN*SC6.C6_QTDVEN AS VALTOT, SC6.C6_BLQ "+ cEOL
			cQuery += "FROM "+RetSqlName("SC6")+" SC6 "+ cEOL
			cQuery += "WHERE SC6.C6_FILIAL  = '"+xFilial("SC6")+ "' " + cEOL
			cQuery += "AND   SC6.C6_NUM     = '"+aColsxPED[oCliPED:nAt][1]+"' "
			cQuery += "AND   SC6.D_E_L_E_T_ <> '*' "+ cEOL
			cQuery += "ORDER BY SC6.C6_PRODUTO "
	
			If Select("IPED") > 0
				dbSelectArea("IPED")
				dbCloseArea()
			EndIf
	
			TcQuery cQuery New Alias "IPED"
			TCSetField("IPED", "C6_QTDVEN", "N")
			TCSetField("IPED", "D2_QUANT" , "N")
	
			DbSelectArea("IPED")
			While !IPED->(Eof())
		
				If Len(aColsIPED) == 1 .AND. Empty(aColsIPED[Len(aColsIPED),GdFieldPos("C6_PRODUTO", aHeadIPED)] )
					lCria := .F.
				Else
					lCria := .T.
				EndIf
		
				If lCria
					AADD(aColsIPED,Array(Len(aHeadIPED)+1))
					aColsIPED[Len(aColsIPED)][Len(aHeadIPED)+1] := .F.
				EndIf
		
				aColsIPED[Len(aColsIPED), GdFieldPos("C6_PRODUTO", aHeadIPED)]	:= IPED->PRODUTO
//		aColsIPED[Len(aColsIPED), GdFieldPos("C6_QTDVEN" , aHeadIPED)]	:= IPED->QTDVEN-IPED->QUANT
				aColsIPED[Len(aColsIPED), GdFieldPos("D2_QUANT" ,  aHeadIPED)]	:= IPED->QUANT
				IF alltrim(IPED->C6_BLQ) == "R"
					aColsIPED[Len(aColsIPED), GdFieldPos("C6_QTDLIB",  aHeadIPED)]	:= IPED->QTDVEN-IPED->QUANT
				Else
					aColsIPED[Len(aColsIPED), GdFieldPos("C6_QTDVEN" , aHeadIPED)]	:= IPED->QTDVEN-IPED->QUANT
				Endif

				aColsIPED[Len(aColsIPED), GdFieldPos("D2_PRCVEN" , aHeadIPED)]	:= IPED->PRCVEN
				aColsIPED[Len(aColsIPED), GdFieldPos("D2_TOTAL"  , aHeadIPED)]	:= IPED->VALTOT

		
				IPED->(DbSkip())
			End
		Else
			aColsIPED := {}
			AADD(aColsIPED,Array(Len(aHeadIPED)+1))
			aColsIPED[Len(aColsIPED)][Len(aHeadIPED)+1] := .F.
		Endif

		DEFINE MSDIALOG oDlgIPED TITLE "Itens do Pedido: "+aColsxPED[oCliPED:nAt][1] FROM C(000), C(000)  TO C(350), C(700) COLORS 0, 16777215 PIXEL

		MsNewGetDados():New( C(001), C(005), C(150), C(350), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAIPED,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgIPED, aHeadIPED, aColsIPED)
		@ C(153), C(283) BUTTON oButton1 PROMPT "&Sair" SIZE C(062), C(018) OF oDlgIPED ACTION ODlgIPED:End() PIXEL

		ACTIVATE MSDIALOG oDlgIPED CENTERED

	Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyDadCli ºAutor  ³Microsiga           ?Data ? 06/13/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍadmin	ÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Funcao que carrega os dados do cliente                     º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function DnyDadCli(nOp)
Local lRet       := .T.
Local nQtDias	 := SuperGetMv("DN_CLIATIV",.F.,90)
Local dUltCompra := SToD("  /  /  ")
Local nX

If nOp == 2 .Or. nOp == 3 
	 __lProsp:= .T.
ElseIf nOp == 1
	__lProsp:= .F.
EndIf

//If lProspect
If __lProsp
	DbSelectArea("SUS")
	DbSetOrder(1)
	If DbSeek(xFilial("SUS") + cCod_por + cLoja_por )
		If !Empty(SUS->US_CODCLI)
			Alert("Prospect j?possui cliente criado. Utilize o cliente " + SUS->US_CODCLI + "/" + SUS->US_LOJACLI +".")
			Return(.F.)
		Else
			cod_atend		:= SUS->US_VEND
			cod_ativ		:= SUS->US_CNAE
			come_cli		:= SUS->US_NOME
			cest_fat		:= SUS->US_EST
			//cod_cli  		:= SUS->US_COD
			cod_cli  		:= Space(06)
			cContrib		:= SUS->US_CONTRIB
			cone_1			:= SUS->US_TEL
			cod_cnpj		:= SUS->US_CGC
			cod_IE  		:= SUS->US_INSCR
			cod_rep			:= SUS->US_VEND
			cmail_nfe		:= SUS->US_EMAIL
			cCliDDD			:= SUS->US_DDD
			cod_fpg  		:= Space(TamSx3("A1_COND")[1])
			cod_trp			:= Space(TamSx3("A1_TRANSP")[1])
			//cesc_ativ		:= Posicione("CC3",1,xFilial("CC3")+substr(cod_ativ,1,4)+"-"+substr(cod_ativ,6,1)+"/"+substr(cod_ativ,8,2),"CC3_DESC")
			cesc_ativ		:= ''
			come_transp		:= Space(TamSx3("A4_NOME")[1])
			ces_forma_pgto	:= Space(TamSx3("E4_DESCRI")[1])
			//come_comprador	:= Space(TamSx3("A1_COMPRAD ")[1])
			come_rep		:= Space(TamSx3("A3_NOME")[1])
			come_transp		:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_NOME")
			ces_forma_pgto	:= Space(TamSx3("E4_DESCRI")[1])
			cTraDDD     	:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_DDD")
			cTraFone    	:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_TEL")
			cod_banco  		:= Space(TamSx3("A1_BCO1")[1])
			cesc_banco		:= Space(TamSx3("A6_NOME")[1])
			come_atend		:= Posicione("SA3",1,xFilial("SA3")+cod_atend,"A3_NOME")
			cObslog     	:= space(900)
			cObsfin     	:= space(900)
			cObscob     	:= space(900)
			//cDtUltCp        := cTod("//")
			cCidade         := Space(TamSx3("A1_MUN")[1])
			cEmail          := Space(TamSx3("A1_XEMAILC")[1])
			come_seguranca	:= '                                                             '	//Space(TamSx3("A1_SEGUR")[1])
			cNomGestor		:= ' '
			cCNCod_Cli		:= SUS->US_CODCLI
			cCNLoja_Cli		:= SUS->US_LOJACLI
			cCNNomeCli		:= SUS->US_NOME
			nCNCre_Cli      := fBuscCred(cCNCod_Cli,cCNLoja_Cli)
			cContFone		:= Space(TamSx3("A1_CONTATO")[1])
			fGridConNe(.F.)
			
			lProsp		    := lProspect
			lProspect 	    := .F.
			
		EndIf
	Else
		lRet                := .F.
	EndIf
Else
	//DbSelectArea("SA1")
	//DbSetOrder(1)
	//If DbSeek(xFilial("SA1") + cod_cli + coja_cli )
	SA1->(DbSetOrder(3))
	If SA1->(DbSeek(xFilial("SA1") + cod_cnpj ))
		DbSelectArea("SA1")
		DbSetOrder(1)
		If SA1->A1_MSBLQL == "1"
			Alert("Cliente bloqueado!")
			Return(.F.)
		EndIf
		cCod_por:= Space(01) 
		cLoja_por:= Space(04)
		cod_atend:= POSICIONE("SA3",7,XFILIAL("SA3")+__cUserID,"A3_COD")
		come_atend:=SA3->A3_NOME

		If Empty(cod_atend) .AND. !Empty(SA1->A1_VEND) .AND. cod_atend<>'0001' 
			cod_atend		:= SA1->A1_VEND
		EndIf
		
		cod_ativ		:= SA1->A1_CNAE
		come_cli		:= SA1->A1_NOME
		cesc_comercial  := 'CLIENTE: '+SA1->A1_NREDUZ
		cest_fat		:= SA1->A1_EST
		cod_banco  		:= SA1->A1_BCO1
		cod_cli  		:= SA1->A1_COD
		coja_cli		:= SA1->A1_LOJA
		IF ALLTRIM(SA1->A1_CONTRIB) == '1'
			cContrib		:= 'SIM'
		ELSE
			cContrib        := 'NAO'
		ENDIF
		cone_1			:= SA1->A1_TEL
		//cone_2			:= SA1->A1_TEL2
		cod_cnpj		:= SA1->A1_CGC
		cod_fpg  		:= Space(TamSx3("A1_COND")[1]) //SA1->A1_COND
		cod_IE  		:= SA1->A1_INSCR
		cod_rep			:= SA1->A1_VEND
		cod_trp			:= SA1->A1_TRANSP
		cObslog     	:= SA1->A1_OBSLO
		cObsfin     	:= SA1->A1_OBSFIN
		cObscob     	:= SA1->A1_OBSCO
		cmail_nfe		:= SA1->A1_EMAIL
		//come_comprador	:= SA1->A1_COMPRAD
		come_seguranca	:= ''  //SA1->A1_SEGUR
		dDtUltCp		:= SA1->A1_ULTCOM
		dXdtrcad		:= SA1->A1_DTNASC
		cCidade 		:= SA1->A1_MUN
		cEmail  		:= SA1->A1_XEMAILC
		cContFone		:= SA1->A1_CONTATO
		//cNomGestor		:= UsrRetName(SA1->A1_GESTOR)
		come_rep		:= Posicione("SA3",1,xFilial("SA3")+cod_rep,"A3_NOME")
		come_transp		:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_NOME")
		cTraDDD     	:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_DDD")
		cTraFone    	:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_TEL")
		ces_forma_pgto	:= Posicione("SE4",1,xFilial("SE4")+cod_fpg,"E4_DESCRI")
		cesc_banco		:= Posicione("SA6",1,xFilial("SA6")+cod_banco,"A6_NOME")
		come_atend		:= Posicione("SA3",1,xFilial("SA3")+cod_atend,"A3_NOME")
		come_colig		:= Posicione("SZ6",1,xFilial("SZ6")+SA1->A1_XCOLIG,"Z6_DESCRI")
		//cesc_ativ		:= Posicione("CC3",1,xFilial("CC3")+substr(cod_ativ,1,4)+"-"+substr(cod_ativ,6,1)+"/"+substr(cod_ativ,8,2),"CC3_DESC")
		cesc_ativ		:= ''
		cCliDDD			:= SA1->A1_DDD
		cTipCli         := IIF(SA1->A1_TIPO=="F","Cons.Final",IIF(SA1->A1_TIPO=="L","Produtor Rural",IIF(SA1->A1_TIPO=="R","Revendedor",IIF(SA1->A1_TIPO=="S","Solidario",IIF(SA1->A1_TIPO=="X","Exportacao","          ")))))
		
		//Condição Negociada
		cCNCod_Cli		:= SA1->A1_COD
		cCNLoja_Cli		:= SA1->A1_LOJA
		cCNNomeCli		:= SA1->A1_NOME
		nCNCre_Cli      := fBuscCred(cCNCod_Cli,cCNLoja_Cli)

		fGridConNe(.F.)
		
		If SA1->A1_MSBLQL == "1"
			cStatBl	    := "BLOQUEADO        "
		Else
			cStatBl	    := "LIBERADO         "
		Endif
		
		nLCrd           := 0.00
		nLCrdT          := SA1->A1_LC
		
		cNome_por       := SA1->A1_NREDUZ   
		//cCodTab 		:= SA1->A1_TABELA  //LEANDRO.EBER 31/08/2016
		
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		DBSEEK(xFilial("SA1")+cod_cli+coja_cli)
		
		cQuery := " SELECT MAX(SF2.F2_EMISSAO) AS ULTCOMPRA FROM " + RetSqlName("SF2") + " AS SF2 "  + Chr(10) + Chr(13)
		cQuery += " WHERE SF2.F2_FILIAL = '"+ xFilial("SF2") +"' AND SF2.F2_CLIENT = '"+ cod_cli +"' AND SF2.F2_LOJA = '"+ coja_cli +"' AND " + Chr(10) + Chr(13)
		cQuery += " SF2.D_E_L_E_T_ = ' '" + Chr(10) + Chr(13)
		If Select("FAT") > 0
			dbSelectArea("FAT")
			dbCloseArea()
		EndIf
		
		TcQuery cQuery New Alias "FAT"
		// Renato Bandeira em 22/08/16  - Se nao houver venda 		
		If FAT->(Eof())
			cStatus	:= " CLIENTE INATIVO "
		Else
			While FAT->(!Eof())
				dUltCompra := SToD( FAT->ULTCOMPRA )
				FAT->(dbSkip())
			End
			
			If dDatabase - nQtDias > dUltCompra
				cStatus	:= "CLIENTE INATIVO"
			Else
				cStatus	:= " CLIENTE ATIVO "
			Endif
		Endif
		If ValType(oStatus) == 'O'
			oStatus:Refresh()
		EndIf	helder
		lProsp		    := .F.
		lProspect 	    := .F.
		
	Else
		MSGINFO("Cliente não cadastrado, informe um código válido", "Cliente não cadastrado")
		Return .F.
	EndIf
EndIf

nVMargem:= 0.00
nVMarInd:= 0.00

nVatrazo:= 0.00
nVMaior := 0.00
nVQuant := 0

nVSupre := 0.00
nQSupre := 0.00
nHSupre := 0.00

nVEssen := 0.00
nQEssen := 0.00
nHEssen := 0.00

nFat12m := 0.00


// Duplicatas em aberto
cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "   
cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"
TCSetField("TRB", "E1ATRZ" , "D",08,0)

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nLCrd := nLCrdT-TRB->E1SALDO
ENDIF


// Cartas de Credito em Aberto
cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
cQuery += "AND   SE1.E1_TIPO IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nLCNCC := TRB->E1SALDO
ENDIF



// Busca margem indexada dos ultimos 2 meses
nAnoMesF := StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase),2)
nAnoMesI := If(Month(dDatabase) -1 <= 0, StrZero(Year(dDataBase) -1,4) + StrZero(Month(dDatabase) -1 +12,2) , StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase) -1,2) )

// Bandeira em 7/10/13 para que os outros campos ?
//cQuery := "SELECT  sum(SC6.C6_VALOR) AS VLRLIQ, sum((SB1.B1_CUSTD*SC6.C6_QTDVEN)) AS VLRCUST, sum((SC6.C6_VALOR-(SB1.B1_CUSTD*SC6.C6_QTDVEN))/SC6.C6_VALOR) AS MARGEM "
cQuery := "SELECT  sum((SC6.C6_VALOR-(SB1.B1_CUSTD*SC6.C6_QTDVEN))/SC6.C6_VALOR) AS MARGEM "
cQuery += "FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SC5.C5_FILIAL  = '"+xFilial("SC5")+"' "
cQuery += "AND   SUBSTRING(SC5.C5_EMISSAO,1,6) BETWEEN '"+ nAnoMesI +"' AND '"+ nAnoMesF +"' "
cQuery += "AND   SC5.C5_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SC5.C5_LOJACLI = '"+coja_cli+"' "
cQuery += "AND   SC5.D_E_L_E_T_ <> '*' "
cQuery += "AND   SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "
cQuery += "AND   SC6.C6_NUM     = SC5.C5_NUM "
cQuery += "AND   SC6.D_E_L_E_T_ <> '*' "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SC6.C6_PRODUTO "
cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"
TCSetField("TRB", "MARGEM" , "N",12,2)

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nVMargem := TRB->MARGEM
ENDIF


// Busca margem indexada do ultimo pedido
cQuery := "SELECT sum(((SC6.C6_VALOR-(SB1.B1_CUSTD*SC6.C6_QTDVEN))/SC6.C6_VALOR)*100) AS MARGEM, SA3.A3_XMETA "
cQuery += "FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6, "+RetSqlName("SB1")+" SB1, "+RetSqlName("SA3")+" SA3 "
cQuery += "WHERE SC5.C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery += "AND   SC5.C5_NUM IN (SELECT MAX(C5.C5_NUM) "
cQuery += "                     FROM "+RetSqlName("SC5")+" C5 "
cQuery += "                     WHERE C5.C5_FILIAL = '"+xFilial("SC5")+"' AND C5.C5_CLIENTE = '"+cod_cli+"' AND C5.C5_LOJACLI = '"+coja_cli+"' AND C5.D_E_L_E_T_ <> '*' )
cQuery += "AND   SC5.C5_EMISSAO IN (SELECT MAX(C5.C5_EMISSAO)
cQuery += "                     FROM "+RetSqlName("SC5")+" C5 "
cQuery += "                     WHERE C5.C5_FILIAL = '"+xFilial("SC5")+"' AND C5.C5_CLIENTE = '"+cod_cli+"' AND C5.C5_LOJACLI = '"+coja_cli+"' AND C5.D_E_L_E_T_ <> '*' )
cQuery += "AND   SC5.D_E_L_E_T_ <> '*' AND SC6.D_E_L_E_T_ <> '*' "
cQuery += "AND   SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "
cQuery += "AND   SC6.C6_NUM     = SC5.C5_NUM "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SC6.C6_PRODUTO "
cQuery += "AND   SA3.A3_FILIAL  = '"+xFilial("SA3")+"' "
cQuery += "AND   SA3.A3_COD     = SC5.C5_VEND1 "
cQuery += "GROUP BY SA3.A3_XMETA "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"
TCSetField("TRB", "MARGEM"   , "N",12,2)
TCSetField("TRB", "A3_XMETA" , "N",06,2)

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nVMarInd := (TRB->MARGEM/TRB->A3_XMETA)
ENDIF


// Duplicatas de atraso
cQuery := "SELECT SUM(SE1.E1_SALDO) AS E1SALDO, COUNT(*) AS E1QTDDUP, MIN(SE1.E1_VENCTO) AS E1ATRZ "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
//cQuery += "WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"' "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase)+"' "     //wap.o
//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase - 4)+"' " //wap.n
//--Utilizar mesma regra da funçao de validaçao do cliente [validar dias de atraso pelo parametro FS_DIASRET]
cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(DataValida(dDatabase, .T.) - SUPERGETMV("FS_DIASRET" , .T., 2,)	 )+"' "
cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"
TCSetField("TRB", "E1ATRZ" , "D",08,0)

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	IF TRB->E1QTDDUP > 0
		nVatrazo := TRB->E1SALDO
		nVQuant  := TRB->E1QTDDUP
		nVMaior  := VAL(DTOS(dDatabase)) - VAL(DTOS(TRB->E1ATRZ))
	ENDIF
ENDIF


// Busca valor historico Suprema
cQuery := "SELECT SUM(SD2.D2_TOTAL) AS D2TOTAL "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "
cQuery += "AND   SD2.D2_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SD2.D2_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SD2.D_E_L_E_T_ <> '*' "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SD2.D2_COD "
//cQuery += "AND   SB1.B1_CATE    = '001' "
cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nHSupre := TRB->D2TOTAL
ENDIF


// Busca valor calculados para o Suprema Ultimos 90 Dias (3 meses)
nAnoMesF := StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase),2)
nAnoMesI := If(Month(dDatabase) -2 <= 0, StrZero(Year(dDataBase) -1,4) + StrZero(Month(dDatabase) -2 +12,2) , StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase) -2,2) )
cQuery := "SELECT SD2.D2_COD, SUM(SD2.D2_TOTAL) AS D2TOTAL "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "
cQuery += "AND   SUBSTRING(SD2.D2_EMISSAO,1,6) BETWEEN '"+ nAnoMesI +"' AND '"+ nAnoMesF +"' "
cQuery += "AND   SD2.D2_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SD2.D2_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SD2.D_E_L_E_T_ <> '*' "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SD2.D2_COD "
//cQuery += "AND   SB1.B1_CATE    = '001' "
cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SD2.D2_COD "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
DBGOTOP()
WHILE !Eof()
	nVSupre := nVSupre+TRB->D2TOTAL
	nQSupre += 1
	DBSKIP()
ENDDO


// Busca valor historico Essencial
cQuery := "SELECT SUM(SD2.D2_TOTAL) AS D2TOTAL "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "
cQuery += "AND   SD2.D2_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SD2.D2_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SD2.D_E_L_E_T_ <> '*' "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SD2.D2_COD "
//cQuery += "AND   SB1.B1_CATE    = '002' "
cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
DBGOTOP()
IF !Eof()
	nHEssen := TRB->D2TOTAL
ENDIF


// Busca o valor faturado do Cliente nos ultimos 12 meses
nAnoMesF := StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase),2)
nAnoMesI := If(Month(dDatabase) -11 <= 0, StrZero(Year(dDataBase) -1,4) + StrZero(Month(dDatabase) -11 +12,2) , StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase) -11,2) )
cQuery := " SELECT SUM(SF2.F2_VALBRUT) TOTAL "  + Chr(10) + Chr(13)
cQuery += " FROM " + RetSqlName("SF2") + " SF2 "  + Chr(10) + Chr(13)
cQuery += " WHERE SF2.F2_FILIAL = '"+ xFilial("SF2") +"' AND SF2.F2_CLIENT = '"+ cod_cli +"' AND SF2.F2_LOJA = '"+ coja_cli +"' AND " + Chr(10) + Chr(13)
cQuery += " SUBSTRING(SF2.F2_EMISSAO,1,6) BETWEEN '"+ nAnoMesI +"' AND '"+ nAnoMesF +"' AND SF2.D_E_L_E_T_ = ' '" + Chr(10) + Chr(13)

If Select("FAT") > 0
	dbSelectArea("FAT")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "FAT"

IF FAT->(!Eof())
	nFat12m  += FAT->TOTAL
	FAT->(dbSkip())
End


// Busca valor calculados para o Essencial Ultimos 90 Dias (3 meses)
nAnoMesF := StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase),2)
nAnoMesI := If(Month(dDatabase) -2 <= 0, StrZero(Year(dDataBase) -1,4) + StrZero(Month(dDatabase) -2 +12,2) , StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase) -2,2) )
cQuery := "SELECT SD2.D2_COD, SUM(SD2.D2_TOTAL) AS D2TOTAL "
cQuery += "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1 "
cQuery += "WHERE SD2.D2_FILIAL  = '"+xFilial("SD2")+"' "
cQuery += "AND   SUBSTRING(SD2.D2_EMISSAO,1,6) BETWEEN '"+ nAnoMesI +"' AND '"+ nAnoMesF +"' "
cQuery += "AND   SD2.D2_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SD2.D2_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SD2.D_E_L_E_T_ <> '*' "
cQuery += "AND   SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += "AND   SB1.B1_COD     = SD2.D2_COD "
//cQuery += "AND   SB1.B1_CATE    = '002' "
cQuery += "AND   SB1.D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY SD2.D2_COD "
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "TRB"

dbSelectArea("TRB")
DBGOTOP()
WHILE !Eof()
	nVEssen := nVEssen+TRB->D2TOTAL
	nQEssen += 1
	DBSKIP()
ENDDO

//Renato Bandeira em 07/10/13 - Calcula as compras dos ultimos 12 meses
aHeade12m:= {}
aCols12m := {}
cQuery   := ""
nAnoMesF := StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase),2)
nAnoMesI := If(Month(dDatabase) -11 <= 0, StrZero(Year(dDataBase) -1,4) + StrZero(Month(dDatabase) -11 +12,2) , StrZero(Year(dDataBase),4) + StrZero(Month(dDatabase) -11,2) )

cQuery := " SELECT DATEPART(YEAR,SF2.F2_EMISSAO) AS ANO, DATEPART(MONTH,SF2.F2_EMISSAO) AS MES, SUM(SF2.F2_VALBRUT) AS TOTAL "  + Chr(10) + Chr(13)
cQuery += " FROM " + RetSqlName("SF2") + " AS SF2 "  + Chr(10) + Chr(13)
cQuery += " WHERE SF2.F2_FILIAL  = '"+ xFilial("SF2") +"' " + Chr(10) + Chr(13)
cQuery += " AND   SF2.F2_CLIENT  = '"+ cod_cli +"' " + Chr(10) + Chr(13)
cQuery += " AND   SF2.F2_LOJA    = '"+ coja_cli +"' " + Chr(10) + Chr(13)
cQuery += " AND   SUBSTRING(SF2.F2_EMISSAO,1,6) BETWEEN '"+ nAnoMesI +"' AND '"+ nAnoMesF +"' " + Chr(10) + Chr(13)
cQuery += " AND   SF2.D_E_L_E_T_ = ' '" + Chr(10) + Chr(13)
cQuery += " GROUP BY DATEPART(YEAR,SF2.F2_EMISSAO), DATEPART(MONTH,SF2.F2_EMISSAO) "
cQuery += " ORDER BY DATEPART(YEAR,SF2.F2_EMISSAO), DATEPART(MONTH,SF2.F2_EMISSAO) "

If Select("FAT") > 0
	dbSelectArea("FAT")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "FAT"

dbSelectArea("SX3")
dbsetorder(2)
dbSeek("F2_VALMERC")
IF !Eof() .And. (x3_campo=="F2_VALMERC")
	SELECT FAT
	DBGOTOP()
	nUsado :=0
	WHILE !EOF()
		nUsado:=nUsado+1
		
		cPict := "@E 99,999,999.99"
		
		Aadd(aHeade12m,{AllTrim( strzero(FAT->MES,2)+"/"+STRZERO(FAT->ANO,4)),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		dbSkip()
	END
ENDIF

SELECT FAT
DBGOTOP()
nX := 0
WHILE !EOF()
	nX := nX+1
	
	AADD(aCols12M,Array(Len(aHeade12M)+1))
	aCols12M[Len(aCols12M)][Len(aHeade12M)+1] := .F.
	
	aCols12m[1,nX] := FAT->TOTAL
	
	DBSKIP()
END

AADD(aCols12M,Array(Len(aHeade12M)+1))
aCols12M[Len(aCols12M)][Len(aHeade12M)+1] := .F.

oLCrd:Refresh()
oLCrdT:Refresh()
oVAtrazo:Refresh()
oVMaior:Refresh()
oVQuant:Refresh()

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
//IF cEmpAnt $ "01/02"
	oVMargem:Refresh()
	oVMarInd:Refresh()
	oVSupre:Refresh()
	oQSupre:Refresh()
	oHSupre:Refresh()
	oVEssen:Refresh()
	oQEssen:Refresh()
	oHEssen:Refresh()
//EndIF
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>

oVFat12m:Refresh()

IF VALTYPE(oFat12m) <> "U"
	FreeObj(oFat12m)
Endif

oFat12m := MsNewGetDados():New( C(210), C(003), C(250), C(641), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldA12m,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[2], aHeade12m, aCols12m)
oFat12m:oBrowse:Refresh()

// ABA - HISTORICOS
// Historicos de Clienteg
aHeadHist := {}
aColsHist := {}

chkFile('SZB')

cQuery := " SELECT SZB.ZB_DTHIST, SZB.ZB_HORA, SZC.ZC_DESCRIC, SZB.ZB_USER, SZB.ZB_CONTATO, SZB.ZB_DTAGEN, SZB.ZB_FORMA, ISNULL(SA3.A3_NOME,'') A3_NOME "
cQuery += " FROM "+RetSqlName('SZB') + " SZB "
cQuery += " INNER JOIN "+RetSqlName('SZC') + " SZC ON   SZC.ZC_FILIAL  = '" + xFilial("SZC") + "' AND   SZC.ZC_CODIGO  = SZB.ZB_TITULO AND   SZC.D_E_L_E_T_ <> '*' "
cQuery += " LEFT JOIN "+RetSqlName('SA3') + " SA3  ON    SA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND   SA3.A3_COD  = SZB.ZB_RESPRES  AND   SA3.D_E_L_E_T_ <> '*' "
cQuery += " WHERE SZB.ZB_FILIAL  = '" + xFilial("SZB") + "' "
cQuery += " AND   SZB.ZB_CLIENTE = '" + Cod_Cli + "' "
cQuery += " AND   SZB.ZB_LOJA    = '" + coja_Cli + "' "
cQuery += " AND   SZB.D_E_L_E_T_ <> '*' "
cQuery += " ORDER BY ZB_DTHIST+ZB_HORA DESC "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TCQuery cQuery new Alias "TRB"
TCSetField("TRB", "ZB_DTHIST","D",08,0)
TCSetField("TRB", "ZB_DTAGEN","D",08,0)

DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to Len(aFldHist)
	If SX3->(DbSeek(aFldHist[nX]))
		
		cPict := SX3->X3_PICTURE
		
		cX3Tit:= AllTrim(X3Titulo())
		
		IF  Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
			cX3Tit := "Titulo"
		ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
			cX3Tit := "Nome Repres."
		Endif
		
		Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

SELECT TRB
DBGOTOP()
WHILE !EOF()
	
	AADD(aColsHist,Array(Len(aHeadHist)+1))
	aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.
	
	aColsHist[Len(aColsHist), GdFieldPos("ZB_DTHIST", aHeadHist)]	:= TRB->ZB_DTHIST
	aColsHist[Len(aColsHist), GdFieldPos("ZB_HORA",   aHeadHist)]	:= TRB->ZB_HORA
	aColsHist[Len(aColsHist), GdFieldPos("ZC_DESCRIC",aHeadHist)]	:= TRB->ZC_DESCRIC
	aColsHist[Len(aColsHist), GdFieldPos("ZB_USER",   aHeadHist)]	:= TRB->ZB_USER
	aColsHist[Len(aColsHist), GdFieldPos("ZB_CONTATO",aHeadHist)]	:= TRB->ZB_CONTATO
	aColsHist[Len(aColsHist), GdFieldPos("ZB_DTAGEN", aHeadHist)]	:= TRB->ZB_DTAGEN
	aColsHist[Len(aColsHist), GdFieldPos("ZB_FORMA",  aHeadHist)]	:= TRB->ZB_FORMA
	aColsHist[Len(aColsHist), GdFieldPos("A3_NOME",   aHeadHist)]	:= TRB->A3_NOME
	
	DBSKIP()
END

AADD(aColsHist,Array(Len(aHeadHist)+1))
aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.

oGetHis:SetArray(aColsHist)
oGetHis:oBrowse:Refresh()
oGetHis:Refresh()


// Contatos do Cliente
aHeadCont := {}
aColsCont := {}

chkFile('SQB')
chkFile('AC8')
chkFile('SU5')

cQuery := " SELECT SU5.U5_CODCONT, SU5.U5_CONTAT, SU5.U5_EMAIL, SU5.U5_DDD, SU5.U5_FONE, SU5.U5_CELULAR, SU5.U5_FAX, SU5.U5_FCOM1, SU5.U5_FCOM2, "
cQuery += "        SQB.QB_DESCRIC, SUM.UM_DESC "
cQuery += " FROM "+RetSqlName('AC8')+" AC8, "+RetSqlName('SU5')+" SU5 "
cQuery += " LEFT JOIN "+RetSqlName('SQB')+" SQB (NOLOCK) ON SQB.QB_DEPTO = SU5.U5_DEPTO "
cQuery += " LEFT JOIN "+RetSqlName('SUM')+" SUM (NOLOCK) ON SUM.UM_CARGO = SU5.U5_FUNCAO "
cQuery += " WHERE AC8.AC8_FILIAL = '"+xFilial("AC8")+"' "
cQuery += " AND   AC8.AC8_CODENT = '"+Cod_cli+coja_cli+"' "
cQuery += " AND   AC8.D_E_L_E_T_ <> '*' "
cQuery += " AND   SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "
cQuery += " AND   SU5.U5_CODCONT = AC8.AC8_CODCON "
cQuery += " AND   SU5.D_E_L_E_T_ <> '*' "

If Select("TRB") > 0
	dbSelectArea("TRB")
	dbCloseArea()
EndIf

TCQuery cQuery new Alias "TRB"

DbSelectArea("SX3")
DbSetOrder(2)
For nX := 1 to Len(aFldCont)
	If SX3->(DbSeek(aFldCont[nX]))
		
		cPict := SX3->X3_PICTURE
		
		cX3Tit:= AllTrim(X3Titulo())
		
		IF     Alltrim(SX3->X3_CAMPO) == "QB_DESCRIC"
			cX3Tit := "Departamento"
		ElseIf Alltrim(SX3->X3_CAMPO) == "UM_DESC"
			cX3Tit := "Função"
		Endif
		
		Aadd(aHeadCont, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

SELECT TRB
DBGOTOP()
WHILE !EOF()
	
	AADD(aColsCont,Array(Len(aHeadCont)+1))
	aColsCont[Len(aColsCont)][Len(aHeadCont)+1] := .F.
	
	aColsCont[Len(aColsCont), GdFieldPos("U5_CODCONT",aHeadCont)]	:= TRB->U5_CODCONT
	aColsCont[Len(aColsCont), GdFieldPos("U5_CONTAT", aHeadCont)]	:= TRB->U5_CONTAT
	aColsCont[Len(aColsCont), GdFieldPos("U5_EMAIL",  aHeadCont)]	:= TRB->U5_EMAIL
	aColsCont[Len(aColsCont), GdFieldPos("U5_DDD",    aHeadCont)]	:= TRB->U5_DDD
	aColsCont[Len(aColsCont), GdFieldPos("U5_FONE",   aHeadCont)]	:= TRB->U5_FONE
	aColsCont[Len(aColsCont), GdFieldPos("U5_CELULAR",aHeadCont)]	:= TRB->U5_CELULAR
	aColsCont[Len(aColsCont), GdFieldPos("U5_FAX",    aHeadCont)]	:= TRB->U5_FAX
	aColsCont[Len(aColsCont), GdFieldPos("U5_FCOM1",  aHeadCont)]	:= TRB->U5_FCOM1
	aColsCont[Len(aColsCont), GdFieldPos("U5_FCOM2",  aHeadCont)]	:= TRB->U5_FCOM2
	aColsCont[Len(aColsCont), GdFieldPos("QB_DESCRIC",aHeadCont)]	:= TRB->QB_DESCRIC
	aColsCont[Len(aColsCont), GdFieldPos("UM_DESC",   aHeadCont)]	:= TRB->UM_DESC
	DBSKIP()
END

AADD(aColsCont,Array(Len(aHeadCont)+1))
aColsCont[Len(aColsCont)][Len(aHeadCont)+1] := .F.

oGetCon:SetArray(aColsCont)
oGetCon:oBrowse:Refresh()
oGetCon:Refresh()

Return(lRet)


Static Function DnyCarPrd(oDlgVendas,oFolder)	//,lAlteraPreco)
*********************************************
Local lRet := .T.
Local __xnElem
                       
If Empty(gCod_produto)
	gCod_produto:= space(tamSx3('B1_COD')[1]) //Space(04) 
	cesc_nfe 	:= CriaVar('B1_DESC')
	cM			:= CriaVar('B1_UM')
	cerc_icm	:= CriaVar('B1_PICM')
	cerc_ipi	:= CriaVar('B1_IPI')	
	Return lRet
EndIf

//If Len(Alltrim(gCod_produto))<4
//	gCod_produto:=StrZero(Val(gCod_produto),4)
//EndIf            

cProd_ant := gCod_produto  // Salva o ultimo produto digitado.     

// Renato Bandeira em 7/1/15 - somente se tiver item informado
If len(oOrcamento:aCols) >= 1	//0
	For __xnElem := 1 to len(oOrcamento:aCols)
		If !(oOrcamento:aCols[__xnElem][Len(__aHeaderEx)+1]) .And. ALLTRIM(oOrcamento:aCols[__xnElem][GdFieldPos("UB_PRODUTO", __aHeaderEx)]) == ALLTRIM(gCod_produto)
			MsgInfo('Produto j?informado !!')
			Return(.f.)
		EndIf
	Next
Endif

/*DA1->(DbSetOrder(01))
If DA1->(DbSeek(xFilial('DA1')+cCodTab+Avkey(gCod_produto,'DA1_CODPRO')))
	If DA1->DA1_PRCVEN == 0
		Alert("Atenção! Não ser?possivel digitar preço, produto encontra-se com preço zerado na tabela de preço")
		Return(.F.)
	EndIf
EndIf*/

cesc_nfe 	:= CriaVar('B1_DESC')
cM			:= CriaVar('B1_UM')
cerc_icm	:= CriaVar('B1_PICM')
cerc_ipi	:= CriaVar('B1_IPI')
//cCodCA		:= CriaVar('B1_CA')

If !IsInCallStack("u_DnyEscPrd")
	DnyAtuEst()
EndIf

DbSelectArea("SB1")
DbSetOrder(1)
If DbSeek(xFilial("SB1") + gCod_Produto )
	If SB1->B1_MSBLQL <> "1"
		cesc_nfe 		:= SB1->B1_DESC
		
		cM				:= SB1->B1_UM
		cerc_icm		:= SB1->B1_PICM
		cerc_ipi		:= SB1->B1_IPI
		//		cCodCA			:= SB1->B1_CA

		// Renato Bandeira em 28/11/14 - trata a 2a.unidade na tela do orçamento
		DbSelectArea("SA7")
		SA7->(DbSetOrder(1))
		// tem prod x cliente e vai usar a 2a. unidade
		IF SA7->(DbSeek(xFilial("SA7")+cod_cli+coja_cli+gCod_Produto)) .and. 	SA7->A7_UMNFE	== "2"
			cSegunUm	:=	SB1->B1_SEGUM+"/"+ALLTRIM(STR(SB1->B1_CONV,5,2))
        ENDIF
		
		// Renato Bandeira em 31/10/14 - se produto for Comodato, preço = custo medio
		IF .F. //(SB1->B1_XSITPRO == __HLPRODCOM	.OR. cCTpOper	==	__HLOPERCOM)
			nPreco := u_xPCustoMedio()
			nPrecoAnt	:=	nPreco
		Else			
			DbSelectArea("SA1")
			SA1->(DbSetOrder(1))
			If SA1->(DbSeek(xFilial("SA1") + PadR(cod_cli,TamSX3('A1_COD')[1]) + PadR(coja_cli,TamSX3('A1_LOJA')[1]) ))
				IF !Empty(SA1->A1_TABELA) 
					nPreco := u_xDescFin(u_xTabPrc(cod_cli, coja_cli, SB1->B1_COD), cod_fpg)
					nPrecoAnt	:=	nPreco					
				Else                                                                        
					nPreco := u_xDescFin(u_xTabPrc(cod_cli, coja_cli, SB1->B1_COD), cod_fpg)
					nPrecoAnt	:=	nPreco				
				EndIF
			EndIf
		EndIF	//IF SB1->B1_XSITPRO == __HLPRODCOM	.OR. cCTpOper	==	__HLOPERCOM)
		// Renato Bandeira em 30/10/14 - Variavel para controlar o desconto
		nPrcTab_A	:=	nPreco
		
		//If  ValType(oObjLote) <> 'U'
		if Type('oObjLote:OBROWSE:LVISIBLE') <> 'U'
			@ C(003),C(340) MSPANEL oPanel PROMPT "" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
			oObjLote:OBROWSE:LVISIBLE := .F.
		EndIF
		IF SB1->B1_RASTRO == 'L'
			//oButOrc8:Enable()
		Else
			//oButOrc8:Disable()
		EndIF
		//EndIF
		
		//Atualiza Folder 03
		xRshFol3(@oDlgVendas, @oFolder)
		
		//Abre foto do produto
		//f_Foto(@oDlgVendas, @oFolder)
		//f_Similar(@oDlgVendas, @oFolder)
		
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><>
	Else
		lRet := .F.
	EndIf
Else
	lRet := .F.
EndIF

IF !lRet
	MsgInfo('Produto indisponivel !!')          	    
	 //oPreco:SetFocus()
EndIF

If lRet
	FComPreco(gCod_Produto)
//	oQtde:SetFocus()
EndIf

Return(lRet)

*----------------------*
//Static Function xRshFol3
Static Function xRshFol3(oDlgVendas, oFolder)
*----------------------*
IF Type('oObjLote:OBROWSE:LVISIBLE') <> 'U'
	oObjLote:OBROWSE:LVISIBLE := .F. 
EndIF
IF Type('oObjSim:OBROWSE:LVISIBLE') <> 'U'
	oObjSim:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oPedCom:OBROWSE:LVISIBLE') <> 'U'
	oPedCom:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oPedFat:OBROWSE:LVISIBLE') <> 'U'
	oPedFat:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oCliQNC:OBROWSE:LVISIBLE') <> 'U'
	oCliQNC:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oCliPED:OBROWSE:LVISIBLE') <> 'U'
	oCliPED:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oCliIFAT:OBROWSE:LVISIBLE') <> 'U'
	oCliIFAT:OBROWSE:LVISIBLE  := .F.
EndIF
IF Type('oObjLote:OBROWSE:LVISIBLE') <> 'U'
	oObjLote:OBROWSE:LVISIBLE  := .F.
 EndIF 
                        
 oObjLote := Nil
 oPedFat  := Nil
 oPedCom  := Nil
 oObjSim  := Nil
 oCliQNC  := Nil  
 oCliPED  := Nil
 oCliIFAT := Nil
// oObjLote := Nil              
//FreeObj(oCod_cli)
                
oFolder:aDialogs[3]:Refresh()
oDlgVendas:Refresh()
oFolder:Refresh() 
Return                

Static Function DnyCarTot()
***************************
//nTotItem:= nQtde * nPreco
//oTotal:Refresh()

Return()


Static Function DnyCarOrc(oDlgVendas, oFolder)
**********************************************
Local lCria
Local nElem 	:= 1
Local nI
Local nPos
Local cTesInt	:=  ''

If Empty(AllTrim(gCod_Produto))
	Alert("Selecione o produto!")
	ocod_Produto:SetFocus()
	Return()
EndIf

IF nQtde == 0.00
	Alert("Informe a Qtde do produto!")
	oQtde:SetFocus()
	Return()
EndIf
/*
IF nPreco == 0.00
	Alert("Informe o preço do produto!")
	oPreco:SetFocus()
	Return()
EndIf
*/
// Renato Bandeira em 21/12/14 - ja fez antes
/*/
If SB1->(!DbSeek(xFilial("SB1") + gCod_produto ))
	Alert("Produto não encontrado")
	ocod_Produto:SetFocus()
	Return()
EndIf
/*/

IF SA1->A1_PEDCOMP == "S"
	IF Empty(cPedxCli)
		Alert("Informe o pedido de compra do Cliente!")
		oPedxCli:SetFocus()
		Return()
	EndIf
	
	IF Empty(cPedxIte)
		Alert("Informe o item do pedido de compra do Cliente!")
		oPedxIte:SetFocus()
		Return()
	EndIf
ENDIF

nTotItem:= nQtde * nPreco

nElem := 0

If nElem <= 0
	
	nPos := Len(oOrcamento:aCols)
	
	If Len(oOrcamento:aCols) == 1 .AND. Empty(oOrcamento:aCols[Len(oOrcamento:aCols),GdFieldPos("UB_PRODUTO", __aHeaderEx)] )
		lCria := .F.
		nElem := nPos
	Else
		lCria := .T.
		nElem := Val(oOrcamento:aCols[nPos, GdFieldPos("UB_ITEM", __aHeaderEx)] ) + 1
	EndIf
	
	If lCria
		AADD(oOrcamento:aCols,Array(Len(__aHeaderEx)+1))
		oOrcamento:aCols[Len(oOrcamento:aCols)][Len(__aHeaderEx)+1] := .F.
	EndIf
	
	nPos := Len(oOrcamento:aCols)
	
Endif

// ter certeza que o a variavel nElem nao esta NULL -- CVerneque
If ValType(nElem) == Nil
	nElem := 1
EndIf

If __lProsp 
	cTesInt := GetMv('LB_TGVTES',.F.,'503')
Else
	//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
	If cCTpOper == '05'
		cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
	Else	
		IF ALLTRIM(cFilAnt) $ "0103|0102"
			//aquicrele
			If cCTpOper <> '87'
				if SB1->B1_ORIGEM $ "0|2"
					cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
				else
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +AvKey(gCod_produto,'B2_COD') + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
					Else
						SB2->(dbSeek(xFilial("SB2") +AvKey(gCod_produto,'B2_COD') + '03'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
						EndIf
					EndIf
					If Empty(cTesInt)
						If SB1->B1_LOCPAD $ '01|90'														
							cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
						ElseIf SB1->B1_LOCPAD $ '03|80'							
							cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
						Else
							MsgAlert(OemToAnsi('Produto com Armaz. Padrao diferente de 01/90 ou 03/80.'))
						EndIf
					EndIf
				endif
			Else
				if SB1->B1_ORIGEM $ "0|2"
					cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
				else
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +AvKey(gCod_produto,'B2_COD') + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
					Else
						SB2->(dbSeek(xFilial("SB2") +AvKey(gCod_produto,'B2_COD') + '03'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)						
						EndIf
					EndIf
					If Empty(cTesInt)
						If SB1->B1_LOCPAD $ '01|90'														
							cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
						ElseIf SB1->B1_LOCPAD $ '03|80'							
							cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
						Else
							MsgAlert(OemToAnsi('Produto Armaz. Padrao diferente de 01/90 ou 03/80.'))
						EndIf
					EndIf
				endif
			EndIf
			/*If cCTpOper <> '87'
				if Posicione("SB2",1,xFilial("SB2")+gCod_produto+'01',"B2_QATU") > 0
					cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
				ELSEIF Posicione("SB2",1,xFilial("SB2")+gCod_produto+'03',"B2_QATU") > 0
					cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
				ELSE
					cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
				ENDIF
			Else
				cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
			EndIf*/
       	ELSE
 	    	cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",gCod_produto,NIL)
	    ENDIF
	EndIf
	
	//MSGALERT(cTesInt+" := "+cTesInt)
	IF Empty(cTesInt)
		MSGALERT("MSG 2. TES NAO CADASTRADO, AVISE A AREA FISCAL !!")
		cTesInt := GetMv('LB_TGVTES',.F.,'503')
	EndIF
EndIf
//MaFisIni(cod_cli,coja_cli,"C","N",cTipCli,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")

MaFisIni(	cod_cli,;
coja_cli,;		// 2-Loja do Cliente/Fornecedor
"C",;				// 3-C:Cliente , F:Fornecedor
'N',;				// 4-Tipo da NF
SA1->A1_TIPO,;		// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461",;
Nil,;
Nil,;
IIF(__lProsp,cCod_por+cLoja_por,Nil),;
Nil,;
Nil,;
Nil,;
Nil,;
Nil,,,Nil,Nil,Nil,Nil,,Nil)

//		         0.00,;
MaFisAdd(gCod_produto,;
cTesInt,;
nQtde,;
nPreco,;
0.00,;
"",;
"",;
0,;
0,;
0,;
0,;
0,;
(nQtde*nPreco),;
0,;
0,;
0)

nValIcm  := MaFisRet(1,"IT_VALICM")
nIcmsRet := MaFisRet(1,"IT_VALSOL" )
nValIpi  := MaFisRet(1,"IT_VALIPI")
nValIns  := MaFisRet(1,"IT_VALINS" )
nValCof  := MaFisRet(1,"IT_VALCF2")
nValCsl  := MaFisRet(1,"IT_VALCSL")
nValPis  := MaFisRet(1,"IT_VALPS2")
nTotItem := MaFisRet(1,"IT_TOTAL")
nBaseIcm := MaFisRet(1,"IT_BASEICM")

MaFisEnd()

oOrcamento:aCols[nPos, 1] 	:= StrZero(nElem, 2)
oOrcamento:aCols[nPos, GdFieldPos("UB_PRODUTO",__aHeaderEx)] := gCod_produto
oOrcamento:aCols[nPos, GdFieldPos("UB_DESCRI" ,__aHeaderEx)] := cesc_nfe
oOrcamento:aCols[nPos, GdFieldPos("UB_QUANT"  ,__aHeaderEx)] := nQtde
oOrcamento:aCols[nPos, GdFieldPos("UB_VRUNIT" ,__aHeaderEx)] := nPreco
oOrcamento:aCols[nPos, GdFieldPos("UB_VLRITEM",__aHeaderEx)] := nQtde * nPreco
// Renato Bandeira em 30/10/14 - Calculo da Porcentagem de Desconto
// Renato Bandeira em 05/01/14 - arredonda a Porcentagem de Desconto
oOrcamento:aCols[nPos, GdFieldPos("UB_DESC",__aHeaderEx)] := 0 //ROUND((((nPreco/nPrecoAnt)*100)-100) * -1, 2)//NAO SERA USADO DESCONTO NO ITEM O DESCONTO ?NO TOTAL, DESCONTO NO ITEM MUDA O PREÇO DO PRODUTO, EM UM LIMITE DE 30% - LEANDRO.EBER 
oOrcamento:aCols[nPos, GdFieldPos("UB_PRCTAB",__aHeaderEx)] := nPrecoAnt

oOrcamento:aCols[nPos, GdFieldPos("UB_XPED"   ,__aHeaderEx)] := cPedxCli
oOrcamento:aCols[nPos, GdFieldPos("UB_XPEDIT" ,__aHeaderEx)] := cPedxIte

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
oOrcamento:aCols[nPos, GdFieldPos("D2_VALICM" ,__aHeaderEx)] := nValIcm
oOrcamento:aCols[nPos, GdFieldPos("D2_ICMSRET",__aHeaderEx)] := nIcmsRet
oOrcamento:aCols[nPos, GdFieldPos("D2_VALIPI" ,__aHeaderEx)] := nValIpi
oOrcamento:aCols[nPos, GdFieldPos("D2_VALINS" ,__aHeaderEx)] := nValIns
oOrcamento:aCols[nPos, GdFieldPos("D2_VALCOF" ,__aHeaderEx)] := nValCof
oOrcamento:aCols[nPos, GdFieldPos("D2_VALCSL" ,__aHeaderEx)] := nValCsl
oOrcamento:aCols[nPos, GdFieldPos("D2_VALPIS" ,__aHeaderEx)] := nValPis
oOrcamento:aCols[nPos, GdFieldPos("D2_VALBRUT",__aHeaderEx)] := nTotItem
oOrcamento:aCols[nPos, GdFieldPos("UB_XCOMIS",__aHeaderEx)] := 0
oOrcamento:aCols[nPos, GdFieldPos("D2_BASEICM" ,__aHeaderEx)] := nBaseIcm
//oOrcamento:aCols[nPos, GdFieldPos("C6_ZMARGPP",__aHeaderEx)] := 0

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

// Trata  Deletado
If !Empty(oOrcamento:aCols)
	For nI := 1 to Len(oOrcamento:aCols)
		oOrcamento:aCols[nI][Len(__aHeaderEx)+1] := oOrcamento:aCols[nI][Len(__aHeaderEx)+1]     // atualizo os que estão marcados para deleção.
	next
Endif

//FComPreco(gCod_Produto)

// Renato Bandeira em 30/10/14 - Calcula e mostra desconto total
CalcDescTot()

oOrcamento:aCols := aClone(oOrcamento:aCols)
oOrcamento:oBrowse:Refresh()
oOrcamento:Refresh()

gCod_produto := Space(TamSX3("B1_COD") [1])
nQtde 	     := 0.00
nPreco	     := 0.00
nTotItem     := 0.00

oCod_produto:SetFocus()
oFolder:aDialogs[1]:Refresh()

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYATUEST ºAutor  ³Microsiga           ?Data ? 06/15/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Query que realiza busca parcial por codigo e devolve as    º±?
±±?         ?quantidades em estoque                                     º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	Static Function DnyAtuEst()
		Local lCria
		//Local cQuery     := ""
		Local lRep	     := .F.
		//Local bOldError  := ""//ErrorBlock()
		//Local lUsaBlqEst := .T.
		Local _nSld

		//ErrorBlock( {|x| u_DnyTrtEst(x) } ) // muda code-block de erro

		DbSelectArea("SA3")
		DbSetOrder(7)
		If DbSeek(xFilial("SA3") + __cUserID )
			If SA3->A3_TIPO == "E"
				lRep := .T.
			EndIf
		EndIf

		If Len(oEstoque:aCols) > 1 .OR. !Empty(oEstoque:aCols[1,1] )
			oEstoque:aCols := aClone(__aCEstAux)
		EndIf
        
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
		cPerg := Padr("PERCOCKPIT",10)
		U_FUPDSX1(cPerg)
		Pergunte(cPerg, .F.)

		_aSaldB2 := u_xViewSB2(AllTrim(gCod_produto)) 		
        
		IF Len(oEstoque:aCols) == 0
			AADD(oEstoque:aCols,Array(Len(__aHeadEst)+1))
			oEstoque:aCols[Len(oEstoque:aCols)][Len(__aHeadEst)+1] := .F.
		ENDIF

    For _nSld:=1 To Len(_aSaldB2)
			
       IF ALLTRIM(_aSaldB2[_nSld,1]) == xFilial('SB2')

			If Len(oEstoque:aCols) == 1 .AND. Empty(oEstoque:aCols[Len(oEstoque:aCols),GdFieldPos('B2FILIAL', __aHeadEst)] )
				lCria := .F.
			Else
				lCria := .T.
			EndIf

			If lCria
				AADD(oEstoque:aCols,Array(Len(__aHeadEst)+1))
				oEstoque:aCols[Len(oEstoque:aCols)][Len(__aHeadEst)+1]   := .F.
			EndIf
			
			
			If lRep								                                                                                                                                                                                    				
			   oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('B2FILIAL',__aHeadEst)]  := 'SALDO DISOPNIVEL'//Upper(RetField('SM0',1,SM0->M0_CODIGO+_aSaldB2[_nSld,1],'M0_FILIAL'))
			   oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESQTDDIS',__aHeadEst)]  := IIF(_aSaldB2[_nSld,03]>0,_aSaldB2[_nSld,03],_aSaldB2[_nSld,03])//_aSaldB2[_nSld,03]
			  // oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESLOTFUT',__aHeadEst)]  := _aSaldB2[_nSld,17]
			  oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('PREVENTR',__aHeadEst)]  := _aSaldB2[_nSld,07]
			Else				
			   oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('B2FILIAL',__aHeadEst)]  := 'SALDO DISPONIVEL'//Upper(RetField('SM0',1,SM0->M0_CODIGO+_aSaldB2[_nSld,1],'M0_FILIAL'))
			   oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESQTDDIS',__aHeadEst)]  := IIF(_aSaldB2[_nSld,03]>0,_aSaldB2[_nSld,03],_aSaldB2[_nSld,03])
			  // oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESLOTFUT',__aHeadEst)]  := _aSaldB2[_nSld,17]
			  oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('PREVENTR',__aHeadEst)]  := _aSaldB2[_nSld,07]
			EndIf
         
       ENDIF                                                                                                                ?

    Next _nSld	
		
		//Busca valor calculados para o Essencial Ultimos 90 Dias (3 meses)
        /*
		cPerg := Padr("PERCOCKPIT",10)
		U_FUPDSX1(cPerg)
		Pergunte(cPerg, .F.)

		dPrazo := dDataBase+VAL(mv_par06)

		cQuery := "SELECT SB2.B2_COD, SB2.B2_QATU, SB2.B2_QEMP, SB2.B2_QPEDVEN, SB2.B2_RESERVA, (SELECT SUM(SC6.C6_QTDVEN-SC6.C6_QTDENT) "
		cQuery += "                                                                              FROM  "+RetSqlName("SC6")+" SC6 "
		cQuery += "                                                                              WHERE SC6.C6_FILIAL  = '"+xFilial("SC6")+"' "
		cQuery += "                                                                              AND   SC6.C6_PRODUTO = SB2.B2_COD "
		cQuery += "                                                                              AND   SC6.C6_LOCAL   = '01' "
		cQuery += "                                                                              AND   SC6.C6_BLQ     <> 'R' "
		cQuery += "                                                                              AND   SC6.C6_ENTREG  <= '"+DTOS(dPrazo)+"' "
		cQuery += "                                                                              AND   SC6.D_E_L_E_T_ <> '*') AS C6QTPED, "
		cQuery += "                                                                             (SELECT SUM(SC9.C9_QTDLIB) "
		cQuery += "                                                                              FROM  "+RetSqlName("SC9")+" SC9 "
		cQuery += "                                                                              WHERE SC9.C9_FILIAL  = '"+xFilial("SC9")+"' "
		cQuery += "                                                                              AND   SC9.C9_PRODUTO = SB2.B2_COD "
		cQuery += "                                                                              AND   SC9.C9_NFISCAL = '         ' "
		cQuery += "                                                                              AND   SC9.C9_BLEST   = '  ' "
		cQuery += "                                                                              AND   SC9.C9_BLCRED  = '  ' "
		cQuery += "                                                                              AND   SC9.D_E_L_E_T_ <> '*') AS C9QTLIB "
		cQuery += "FROM  "+RetSqlName("SB2")+" SB2 "
		cQuery += "WHERE SB2.B2_FILIAL  = '"+xFilial("SB2")+"' "
		cQuery += "AND   SB2.B2_COD     LIKE '"+AllTrim(gCod_produto)+"%' "
		cQuery += "AND   SB2.B2_LOCAL   = '01' "
		cQuery += "AND   SB2.D_E_L_E_T_ = '' "

		If Select("EST") > 0
			dbSelectArea("EST")
			dbCloseArea()
		EndIf

		TcQuery cQuery New Alias "EST"

		DbSelectArea("EST")

		While !EST->(Eof())
			//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
			//If Len(oEstoque:aCols) == 1 .AND. Empty(oEstoque:aCols[Len(oEstoque:aCols),GdFieldPos("B2_COD", __aHeadEst)] )
			If Len(oEstoque:aCols) == 1 .AND. Empty(oEstoque:aCols[Len(oEstoque:aCols),GdFieldPos('B2FILIAL', __aHeadEst)] )
			//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
				lCria := .F.
			Else
				lCria := .T.
			EndIf

			If lCria
				AADD(oEstoque:aCols,Array(Len(__aHeadEst)+1))
				oEstoque:aCols[Len(oEstoque:aCols)][Len(__aHeadEst)+1]                    := .F.
			EndIf
			//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
			//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_COD", __aHeadEst)] 	   := EST->B2_COD                                                                               
			//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

			If lRep
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
				
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QATU",   __aHeadEst)]  := ((EST->B2_QATU - EST->C6QTPED - (EST->B2_RESERVA - EST->C9QTLIB))*50)/100
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QPEDVEN",__aHeadEst)]  := EST->C6QTPED
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QEMP",   __aHeadEst)]  := EST->B2_QEMP
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_RESERVA",__aHeadEst)]  := 0  
								                                                                                                                                                                                    				
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('B2FILIAL',__aHeadEst)]  := 'xx'
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESQTDDIS',__aHeadEst)]  := 100
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESLOTFUT',__aHeadEst)]  := 200
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>				
			Else
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
				
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QATU",   __aHeadEst)]  := EST->B2_QATU - EST->C6QTPED - (EST->B2_RESERVA - EST->C9QTLIB)
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QPEDVEN",__aHeadEst)]  := EST->C6QTPED
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_QEMP",   __aHeadEst)]  := EST->B2_QEMP
				//oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos("B2_RESERVA",__aHeadEst)]  := EST->B2_RESERVA-EST->C9QTLIB
				
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('B2FILIAL',__aHeadEst)]  := 'xx'				
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESQTDDIS',__aHeadEst)]  := 300
				oEstoque:aCols[Len(oEstoque:aCols), GdFieldPos('ESLOTFUT',__aHeadEst)]  := 400
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>								
			EndIf

			EST->(DbSkip())
		End
        */
		oEstoque:oBrowse:Refresh()
		oEstoque:Refresh()

		//ErrorBlock( {|E| CHECERRO(E)} )

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyEscPrd ºAutor  ³Microsiga           ?Data ? 06/18/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Atualiza produto escolhido para interface do orcamento     º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	User Function DnyEscPrd()

		gCod_produto := &(ReadVar())

		DnyCarPrd()

		oFolder:aDialogs[3]:Refresh()
		oCod_produto:Refresh()
		UM:Refresh()
		desc_nfe:Refresh()
		desc_comercial:Refresh()

	Return(.T.)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±³Programa  ?FCONPCLI ?Autor ?Thiago S. Joaquim     ?Data ?8/06/2012³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±³Locacao   ?                  ³Contato ?thiago.joaquim@totvs.com.br    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Descricao ?Monta a tela para consulta do Historico do Cliente.        ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Parametros?Nenhum.                                                    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Retorno   ?Nenhum.                                                    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Aplicacao ?Itens adicionais na Tela do Cliente e de Vendas.           ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Uso       ?Especifico.                                                ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±³Analista Resp.? Data  ?Bops ?Manutencao Efetuada                    ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?             ? /  /  ?     ?                                       ³±?
±±?             ? /  /  ?     ?                                       ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/
*-----------------------------------*
Static Function FCONPCLI(cCod,cLoja)    // utiliza PE: F010FILT
*-----------------------------------*
		Local nRecno := 0
		Local cAlias := "SA1"
		Local ObjAux	:= oFolder
		Private cCadastro := ""
		Private aRotina	:=	{{"Pesquisar", "AxPesqui" , 0 , 1},;
			{"Visualizar","AxVisual" , 0 , 2},;
			{"Consultar", "FC010CON" , 0 , 2},;
			{"Impressao", "FC010IMP" , 0 , 4}}
			
		//--Posiciona na SF2
		DbSelectArea("SF2")

		If (Trim(cCod) != "" .AND. Trim(cLoja) != "")
	
			DBSelectArea(cAlias)
			(cAlias)->(DBSetOrder(1))
			(cAlias)->(DBGoTop())
			(cAlias)->(DBSeek(XFilial(cAlias)+CVALTOCHAR(cCod)+CVALTOCHAR(cLoja)))
	
			nRecno := RECNO()
			Pergunte("FIC010",.T.) //Carrega a Lista de Perguntas para Parametrizar a Consulta da Posicao do Cliente.
			Fc010Con(cAlias,nRecno,2) //Exibe a Tela com o Resumo da Posicao do Cliente.
	
		Else
	
			MsgAlert("Selecione um Cliente antes de realizar a consulta da Posicao do Cliente.","Atencao!")
	
		EndIf
		
        oFolder		:= ObjAux
        
	Return Nil                                                                                                                            
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyAltOrc ºAutor  ³Microsiga           ?Data ? 06/27/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Carrega orçamento na tela para alteracao                   º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function DnyAltOrc()

Local cCodAux:= ''
Local lAltOrc := .F.     
Local  cTPVEN := ''

lAltOrc := Alltrim(UsrRetName( RetCodUsr() )) $ GetMv("LI_ALTORC",.F.,"ana.fernandes;orlando.ramalho;Administrador;admin")


//--Validação de venvedor
SA3->(dbSetOrder(7))
If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
   cTPVEN:= SA3->A3_TIPO
EndIf


DbSelectArea("SUB")
DbSetOrder(1)
If SUB->(DbSeek(xFilial("SUB") + AllTrim(cum_orc) ) )
	If .T.//Empty(oOrcamento:aCols) .or. cum_orc <> cum_orca
		cum_orca := cum_orc
		oOrcamento:aCols := {}
		AADD(oOrcamento:aCols,Array(Len(__aHeaderEx)+1))
		oOrcamento:aCols[Len(oOrcamento:aCols)][Len(__aHeaderEx)+1] := .F.
				
		DbSelectArea("SUA")
		DbSetOrder(1)
		If DbSeek(xFilial("SUA") + cum_orc )
		
			If !Empty(SUA->UA_NUMSC5)
				MsgAlert(OemToAnsi('ALERTA: Orçamento vinculado ao PV:'+SUA->UA_NUMSC5+' .Alteração de orçamento somente ser?realizada após exclusao do PV!!' ))
			EndIf
								
			If  SUA->UA_VEND <> cUsrVen .and. !Empty(cUsrVen) .AND. !lAltOrc  .AND. cTPVEN == 'E'
				cum_orc	 := Space(TamSX3("C5_NUM") [1])
				cum_orca  := cum_orc
				onum_orc:Refresh()
				Alert("Orçamento não pertence a sua Carteira.")
				//Renato Bandeira em 28/10/14 - permitir alterar o PV
			ElseIf ( (/*Empty(SUA->UA_NUMSC5) .And.*/ SUA->UA_OPERADO == TKOPERADOR()) .Or. (__cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000' .or. lAltOrc .or. cTPVEN <> "E" ))
				//Desabilita botao da condição de pagamento quando o orçamento ja existe
				_lAltSE4 := .F.
				IF ! EMPTY( SUA->UA_NUMSC5)
					_lBotaoGrvOrc	:=	.F.
					// Renato Bandeira em 27/02/15 - Verifica a situacao do pedido 
					If SC5->( DbSeek(xFilial("SC5")+ SUA->UA_NUMSC5 ))
						// Se gerado nota não permite alterar o pedido.
						IF ! EMPTY(SC5->C5_NOTA)
							MSGINFO("Pedido de Venda j?est?Faturado. N.Fiscal : "+SC5->C5_NOTA+" , nao pode ser alterado.")
							_lPedBotaoGrv := .f.
						// Se Liberado permite alterar o pedido, mas avisa
						ELSEIF ! EMPTY(SC5->C5_LIBEROK)
							MSGINFO("Pedido de Venda j?est?liberado. Status : "+SC5->C5_XSTATUS+"-"+POSICIONE("Z04",1,XFILIAL("Z04")+SC5->C5_XSTATUS,"Z04_DESC")+"")
							//_lPedBotaoGrv := .f.
						ENDIF
					Endif
					//
				ENDIF
				
				//--Orçamento gravado por um prospect	
				If SUA->UA_PROSPEC
					cCod_por := SUA->UA_CLIENTE
					cLoja_por:= SUA->UA_LOJA
				Else
					cod_cli	 := SUA->UA_CLIENTE
					coja_cli := SUA->UA_LOJA
				Endif
				//cCTpOper := iIF(Empty(SUA->UA_XTOPER),SuperGetMv("DN_TPOPER")/*+"="+"Vendas"*/,SUA->UA_XTOPER)
				
				//oGetI:Refresh()     //VAR cCTpOper  ITEMS aDTpOper
				IF (_nOpcTP:=aScan(aDTpOper, SUA->UA_XTOPER)) == 0
					_nOpcTP := 1
				ENDIF
				cCTpOper := CTBCBOX("UA_XTOPER")[_nOpcTP]//SUA->UA_XTOPER
				//oGetTpOp:AITEMS[_nOpcTP]
				oGetTpOp:NAT := _nOpcTP
				oGetTpOp:Refresh()
				oGetTpOp:SetFocus()
				
				If !DnyDadCli(IIF(SUA->UA_PROSPEC,3,1))
					Return(.F.)
				EndIf
				
				//Dados cond. pagto
				cod_fpg        := SUA->UA_CONDPG
				ces_forma_pgto := POSICIONE("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI")
				cCodTab        := IIF(Empty(SUA->UA_TABELA),cCodTab,SUA->UA_TABELA)				
				cod_Redesp	   := SUA->UA_XREDESP
				cCTpFrete 	   := SUA->UA_XTPFRET
				come_Redesp	   := Posicione('SA4',1,xFilial('SA4')+cod_Redesp,'A4_NOME')
				dVenc1 		   := SUA->UA_XDATA1
				dVenc2 		   := SUA->UA_XDATA2
				dVenc3 		   := SUA->UA_XDATA3
				dVenc4 		   := SUA->UA_XDATA4
				nParc1 		   := SUA->UA_XPARC1
				nParc2 		   := SUA->UA_XPARC2
				nParc3 		   := SUA->UA_XPARC3
				nParc4 		   := SUA->UA_XPARC4
				nDias1 		   := SUA->UA_XDIAS1
				nDias2 		   := SUA->UA_XDIAS2
				nDias3 		   := SUA->UA_XDIAS3
				nDias4 		   := SUA->UA_XDIAS4
				
				nDescTota		:= SUA->UA_DESCONT
				
				//cCodTabAnt     := IIF(Empty(SUA->UA_TABELA),cCodTab,SUA->UA_TABELA)
				//Dados Tipo do frete
				// Renato Bandeira em 28/11/14 - Carrega item do endereco
				//_cCod_EndE	:=	SUA->UA_XITENDE - GILMAR 22/06/2016 

				//Condição Negociada
				fGridConNe(.T.)
				
				oFolder:aDialogs[1]:Refresh()
				oFolder:aDialogs[3]:Refresh()
				
				
				oOrcamento:aCols := {}
				
				Do While SUB->(!Eof()) .AND. AllTrim(cum_orc) == SUB->UB_NUM
					cCodAux:= SUB->UB_PRODUTO
					//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
					AADD(oOrcamento:aCols,Array(Len(__aHeaderEx)+1))
					oOrcamento:aCols[Len(oOrcamento:aCols)][Len(__aHeaderEx)+1] := .F.
					
					//MaFisIni(cod_cli,coja_cli,"C","N",cTipCli,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700")
					MaFisIni(	cod_cli,;
					coja_cli,;		// 2-Loja do Cliente/Fornecedor
					"C",;			// 3-C:Cliente , F:Fornecedor
					'N',;			// 4-Tipo da NF
					SA1->A1_TIPO,;	// 5-Tipo do Cliente/Fornecedor
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					"MATA461",;
					Nil,;
					Nil,;
					IIF(SUA->UA_PROSPEC,cCod_por+cLoja_por,Nil),;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					Nil,,,Nil,Nil,Nil,Nil,,Nil)
					
					MaFisAdd(SUB->UB_PRODUTO,;
					SUB->UB_TES,;
					SUB->UB_QUANT,;
					SUB->UB_VRUNIT,;
					0.00,;
					"",;
					"",;
					0,;
					0,;
					0,;
					0,;
					0,;
					(SUB->UB_QUANT*SUB->UB_VRUNIT),;
					0,;
					0,;
					0)
					
					nValIcm  := MaFisRet(1,"IT_VALICM")
					nIcmsRet := MaFisRet(1,"IT_VALSOL")
					nValIpi  := MaFisRet(1,"IT_VALIPI")
					nValIns  := MaFisRet(1,"IT_VALINS")
					nValCof  := MaFisRet(1,"IT_VALCF2")
					nValCsl  := MaFisRet(1,"IT_VALCSL")
					nValPis  := MaFisRet(1,"IT_VALPS2")
					nTotItem := MaFisRet(1,"IT_TOTAL")
					nBaseIcm := MaFisRet(1,"IT_BASEICM")
					
					MaFisEnd()
					//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
					
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_ITEM",   __aHeaderEx)] := SUB->UB_ITEM
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_PRODUTO",__aHeaderEx)] := SUB->UB_PRODUTO
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_DESCRI", __aHeaderEx)] := Posicione("SB1",1, xFilial("SB1") + SUB->UB_PRODUTO, "B1_DESC")
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_QUANT",  __aHeaderEx)] := SUB->UB_QUANT
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_VRUNIT", __aHeaderEx)] := SUB->UB_VRUNIT
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_VLRITEM",__aHeaderEx)] := SUB->UB_VLRITEM
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XPED",   __aHeaderEx)] := SUB->UB_XPED
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XPEDIT", __aHeaderEx)] := SUB->UB_XPEDIT
					
					// Renato Bandeira em 30/10/14 - Calculo da Porcentagem de Desconto
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_DESC"  , __aHeaderEx)] := SUB->UB_DESC
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_PRCTAB", __aHeaderEx)] := SUB->UB_PRCTAB
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XCOMIS", __aHeaderEx)] := SUB->UB_XCOMIS
					
					//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALICM", __aHeaderEx)] := nValIcm
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_ICMSRET",__aHeaderEx)] := nIcmsRet
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALIPI", __aHeaderEx)] := nValIpi
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALINS", __aHeaderEx)] := nValIns
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALCOF", __aHeaderEx)] := nValCof
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALCSL", __aHeaderEx)] := nValCsl
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALPIS", __aHeaderEx)] := nValPis
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALBRUT",__aHeaderEx)] := nTotItem
					oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_BASEICM", __aHeaderEx)] := nBaseIcm
					//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
					
					SUB->(DbSkip())
					
				End
				// Renato Bandeira em 30/10/14 - Calculo da Porcentagem de Desconto
				CalcDescTot()
			Else
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
				//Renato Bandeira em 28/10/14
				/*/
				IF !Empty(SUA->UA_NUMSC5)
					_cMsErr := "Foi gerado Pedido para o orçamento - Orçamento não pode ser mais editado."
				Else
					/*/
					IF SUA->UA_OPERADO <> TKOPERADOR() .AND. !lAltOrc .AND. cTPVEN == 'E' 
						_cMsErr := "Orçamento não pertence a carteira do Operador["+TKOPERADOR()+"]." 
					EndIF
					//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
					cum_orc	 := Space(TamSX3("C5_NUM") [1])
					cum_orca := cum_orc
					onum_orc:Refresh()
					Alert(_cMsErr)
				EndIf
			EndIf
			//		oOrcamento:aCols := aClone(__aColsEx)
			oOrcamento:oBrowse:Refresh()
			oOrcamento:Refresh()
			oFolder:aDialogs[1]:Refresh()
			oFolder:aDialogs[3]:Refresh()
		EndIf
	Else
		oOrcamento:aCols := {}
		AADD(oOrcamento:aCols,Array(Len(__aHeaderEx)+1))
		oOrcamento:aCols[Len(oOrcamento:aCols)][Len(__aHeaderEx)+1] := .F.
	Endif
	oCod_Produto:SetFocus()
	//--Carrega promoções
	//FKitDesc('',1, .F.)
	FComPreco(cCodAux)
Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYMUDORC ºAutor  ³Microsiga           ?Data ? 06/27/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
User Function DnyMudOrc()
Local aArea		:= GetArea()
Local nPosPrd	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRODUTO'} )
Local nPosPrcT	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRCTAB'} )
//Local nPosPrcD	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_VRUNIT'} )
//Local nColDel	:= Len(__aHeaderEx)+1
//Local nPosProm	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_CODPROM'} )
//Local nPosKit	:= 0
//Local nDelKit	:= 0
//Local cPrdAux	:= ''
//Local nQtdPrd	:= 0
//Local nPrd		:= 0
Local aTabelas	:= {'001','002','003'}
Local aPrecos	:= {0,0,0}
Local nTab		:= 0
Local cTipoVend	:= ''
Local cTesInt	:= ''

//--Valida se item pode ser excluido - Projeto Promoções
If aScan( aItensPro , { |x| AllTrim(x[01]) == AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd]) } )
	MsgAlert(OemToAnsi('Quantidade/preço do produto :' + oOrcamento:aCols[oOrcamento:nAt, nPosPrd] + ' não pode ser alterado, pois existe uma promoção aplicada para o produto. Favor retire a promoção !!' ))
	Return(.F.)
EndIf
//--Retirada de promoção somente quando a digitação for originada pelo campo Preço
/*--Retirado validação a pedido do Julio
If ReadVar() == "M->UB_VRUNIT"
	//--Deleta Kit do Grid de promoções
	//--Valida se item a ser digitado < que preço
	If &(ReadVar()) < oOrcamento:aCols[oOrcamento:nAt, nPosPrcT]
		//--Codigo do produto
		cPrdAux:= AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd])
		//--Grava na Variavel nQtdPrd quantidade de vezes de produto x promoção
		AEval(aPrdCProm,{|x| IIF( AllTrim(x[2]) == cPrdAux ,nQtdPrd++,.T.)})
		For nPrd:= 1 To nQtdPrd
			nPosKit:= Ascan(aPrdCProm,{|x| AllTrim(x[2]) == AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd]) })
			//--Posição do Kit 
			If nPosKit > 0
				//--Posição do Kit
				nDelKit:= aScan( oPromocoes:Acols , { |x| AllTrim(x[02]) == aPrdCProm[nPosKit][1] } )
				//--Valida se encontrou Kit
				If nDelKit > 0 
					If Len(oPromocoes:aCols) > 1
						//--Redefine tamanho do Array
						ADel(oPromocoes:Acols,nDelKit)
						ASize(oPromocoes:Acols,Len(oPromocoes:Acols)-1)	
					Else							
						oPromocoes:aCols[1][1]:= ''
						oPromocoes:aCols[1][2]:= ''
						oPromocoes:aCols[1][3]:= ''
						oPromocoes:aCols[1][4]:= ''
						oPromocoes:aCols[1][5]:= .F.
					EndIf
				EndIf
				If Len(aPrdCProm) > 1
					//--Redefine tamanho do array de produtos x promoção
					ADel(aPrdCProm,nPosKit)
					ASize(aPrdCProm,Len(aPrdCProm)-1)
				Else
					aPrdCProm[1][1]:= ''
					aPrdCProm[1][2]:= ''
				EndIf			
			EndIf	
		Next nPrd		
		//--Atualiza Grid de promoções
		oPromocoes:Refresh()
	EndIf 
EndIf*/

If ReadVar() == "M->UB_QUANT"
	
	nVlr := &(ReadVar())
	IF nVlr == 0
		Alert("Informe a quantidade do produto!")
		Return(.F.)
	Endif
	
	oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_QUANT",   __aHeaderEx)] := &(ReadVar())
	oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VLRITEM", __aHeaderEx)] := oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VRUNIT",  __aHeaderEx)] * &(ReadVar())
Else

	nVlr := &(ReadVar())
	IF nVlr == 0
		Alert("Informe o preço do produto!")
		Return(.F.)
	EndIf
	//--Valida se usuario informou 
	If oOrcamento:aCols[oOrcamento:nAt, nPosPrcT] == 0
		Alert("Favor vincular tabela de preço e comissão ao produto!")
		Return(.F.)
	EndIf
	DA1->(DbSetOrder(01))
	For nTab:= 1 To Len(aTabelas)
		If DA1->(DbSeek(xFilial('DA1')+aTabelas[nTab]+AvKey(oOrcamento:aCols[oOrcamento:nAt, nPosPrd],'DA1_CODPRO')))
			aPrecos[nTab]:= DA1->DA1_PRCVEN
		EndIf
	Next nTab
	
	//--Validação de venvedor
	SA3->(dbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
		cTipoVend:= SA3->A3_TIPO
	EndIf
	//--Valida tipo de vendedor
	/*
	If GetMv('TG_BLOQVEN',.F.,'A') ==  cTipoVend .Or. GetMv('TG_BLOQVEN',.F.,'A') == 'A' 		
		//--Validação de preço	
		If Len(aPrecos)>0
			//--Ordenação pelo menor valor
			Asort(aPrecos)
			If nVlr < aPrecos[1]
				MsgAlert(OemToAnsi('ALERTA!! Valor inferior ao minimo permitido!!!'))
				//--Parametro define se vai bloquear ou não
				If GetMv('TG_BLQPMIN',.F.,.T.)
					Return(.F.)
				EndIf	
			EndIf
		EndIf
	ElseIf cTipoVend == 'I' //--Caso de vendedor interno informa para o vendedor		
		If Len(aPrecos)>0
			//--Ordenação pelo menor valor
			Asort(aPrecos)
			If nVlr < aPrecos[1]
				MsgAlert(OemToAnsi('ALERTA!! Valor inferior ao minimo permitido. Pedido pode ser bloqueado futuramento pelo gestor devido a falta de rentabilidade!!!'))	
			EndIf
		EndIf		
	EndIf	
	*/
	If GetMv('TG_BLQPMIN',.F.,.T.)
		if cTipoVend $ GetMv('TG_BLOQVEN',.F.,'A')
			//--Validação de preço	
			If Len(aPrecos)>0
				//--Ordenação pelo menor valor
				Asort(aPrecos)
				If nVlr < aPrecos[1]
					MsgAlert(OemToAnsi('ALERTA!! Valor inferior ao minimo permitido!!!'))
					Return(.F.)
				EndIf
			EndIf
		else
			If Len(aPrecos)>0
				//--Ordenação pelo menor valor
				Asort(aPrecos)
				If nVlr < aPrecos[1]
					MsgAlert(OemToAnsi('ALERTA!! Valor inferior as tabelas de preço. Pedido pode ser bloqueado futuramente pelo gestor devido a falta de rentabilidade!!!'))	
				EndIf
			EndIf		
		endif
	Endif	
			
	oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VRUNIT",  __aHeaderEx)] := &(ReadVar())
	oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VLRITEM", __aHeaderEx)] := oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_QUANT",   __aHeaderEx)] * &(ReadVar())
	oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_DESC", __aHeaderEx)] := 0
	
EndIf

If __lProsp
	cTesInt := GetMv('LB_TGVTES',.F.,'503')
Else
	If cCTpOper = '05'
		cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)
	Else
		IF ALLTRIM(cFilAnt) $ "0103|0102"
			If cCTpOper <> '87'
				if SB1->B1_ORIGEM $ "0|2"
					cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)						
				else
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO", __aHeaderEx)],'B2_COD') + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)						
					Else
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD') + '03'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)						
						EndIf
					EndIf
					If Empty(cTesInt)
						If SB1->B1_LOCPAD $ '01|90'														
							cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD'),NIL)
						ElseIf SB1->B1_LOCPAD $ '03|80'							
							cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD'),NIL)
						Else
							MsgAlert(OemToAnsi('Produto Armaz. Padrao diferente de 01/90 ou 03/80.'))
						EndIf
					EndIf				
				endif
			Else
				if SB1->B1_ORIGEM $ "0|2"
					cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)						
				else
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD') + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)
					Else
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD') + '03'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)						
						EndIf
					EndIf
					If Empty(cTesInt)
						If SB1->B1_LOCPAD $ '01|90'														
							cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD'),NIL)
						ElseIf SB1->B1_LOCPAD $ '03|80'							
							cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],'B2_COD'),NIL)
						Else
							MsgAlert(OemToAnsi('Produto Armaz. Padrao diferente de 01/90 ou 03/80.'))
						EndIf
					EndIf
					//cTesInt:= MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
				endif
			EndIf
       	ELSE
 	    	cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO",  __aHeaderEx)],NIL)
	    ENDIF
	Endif   
	//MSGALERT(cTesInt+" := "+cTesInt)
	IF Empty(cTesInt)
		MSGALERT("MSG 3. TES NAO CADASTRADO, AVISE A AREA FISCAL !!")
		cTesInt := GetMv('LB_TGVTES',.F.,'503')
	EndIF
EndIf

MaFisIni(cod_cli,coja_cli,"C","N",cTipCli,MaFisRelImp("MTR700",{"SC5","SC6"}),,,"SB1","MTR700",,,IIF(__lProsp,cCod_por+cLoja_por,Nil))

MaFisAdd(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO", __aHeaderEx)],;
cTesInt,;
oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_QUANT",   __aHeaderEx)],;
oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VRUNIT",  __aHeaderEx)],;
0.00,;
"",;
"",;
0,;
0,;
0,;
0,;
0,;
oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VLRITEM", __aHeaderEx)],;
0,;
0,;
0)

nValIcm  := MaFisRet(1,"IT_VALICM")
nIcmsRet := MaFisRet(1,"IT_VALSOL")
nValIpi  := MaFisRet(1,"IT_VALIPI")
nValIns  := MaFisRet(1,"IT_VALINS")
nValCof  := MaFisRet(1,"IT_VALCF2")
nValCsl  := MaFisRet(1,"IT_VALCSL")
nValPis  := MaFisRet(1,"IT_VALPS2")
nTotItem := MaFisRet(1,"IT_TOTAL")
nBaseIcm  := MaFisRet(1,"IT_BASEICM")

MaFisEnd()

oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALICM" ,__aHeaderEx)] := nValIcm
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_ICMSRET",__aHeaderEx)] := nIcmsRet
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALIPI" ,__aHeaderEx)] := nValIpi
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALINS" ,__aHeaderEx)] := nValIns
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALCOF" ,__aHeaderEx)] := nValCof
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALCSL" ,__aHeaderEx)] := nValCsl
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALPIS" ,__aHeaderEx)] := nValPis
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_VALBRUT",__aHeaderEx)] := nTotItem
oOrcamento:aCols[oOrcamento:oBrowse:nAt, GdFieldPos("D2_BASEICM" ,__aHeaderEx)] := nBaseIcm
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

// Renato Bandeira
CalcDescTot()

oOrcamento:oBrowse:Refresh()
oOrcamento:Refresh()

RestArea(aArea)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyDFimCotºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para montagem da tela de dados finais da cotação     º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function DnyDFimCot(cod_cli,coja_cli,lProsp,cod_fpg,_cBpCod_Fpg,cCTpOper,_nAltSE4, cIdPai)

		Local aArea		:= GetArea()
		Local aAreaSUA	:= SUA->(GetArea())
		Local aAreaSUB	:= SUB->(GetArea())
		Local lRet		:= .T.	//.F.    
		
		//Local cParCC	:= GetMv("ES_CONDPG",,"121/122/123/124/125/126")
		
		Local  oButton1, oButton3, oButton4, oGrupo, oGrupo2

		Local  oSayFim01, oSayFim02, oSayFim03, oSayFim04, oSayFim05, oSayFim06, oSayFim07, oSayFim08, oSayFim09, oSayFim10, oSayFim11, oSayFim12, oSayFim13
		Local  oSayFim15, oSayFim16, oSayFim17, oSayFim19, oSayFim20, oSayFim21, oSayFim22, oSayFim23, oSayFim24, oSayFim25, oSayFim26, oSayFim27
		Local  oSayFim30, oSayFim31, oSayFim32, oSayFim33, oSayFim34, oSayFim35 

		Local  oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7, oGet8, oGet9, oGetB, oGetD, oGetE, oGetF, oGetH
		Local  oGetJ, oGetL, oGetM, oGetN, oGetO, oGetP, oGetQ, oGetR, oGetS, oGetT, oGetU, oGetW

		//Local  cAltCNPJ		:= cod_cnpj

		Local  nTotal		:= 0
		Local  nVlrIPI		:= 0
		Local  nI			:= 0

		Local  cEndEnt		:= Space(TamSx3("A1_END")[1])
		Local  cBaiEnt		:= Space(TamSx3("A1_BAIRRO")[1])
		Local  cMunEnt		:= Space(TamSx3("A1_MUN")[1])
		Local  cEstEnt		:= Space(TamSx3("A1_EST")[1])
		Local  cCepEnt		:= Space(TamSx3("A1_CEP")[1])   
		
		//Local oNSU			:= Nil
		//Local oAutoriz		:= Nil
		//Local cNSU			:= Space(15)
		//Local cAutoriz		:= Space(15) 
		//Local oAdquiri 		:= Nil
		//Local oBandei	 	:= Nil
		//Local cAdquiri  	:= ""
		//Local cBandei 		:= Space(15)
		//Local aAdquiri    	:= {"C=CIELO",}
		//Local oSx5Bn		:= Nil  
		//Local cSx5Bn		:= Space(2)   
		
		//Local lRet	   		:= .T.
		//Local nX 	   		:= 1
		//Local nPosCond 		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_COND"} )  
		//Local nPosNSU  		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_NSU"} )  
		//Local nPosAdqu		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_ADQUIRI"} )  
		//Local nPosCodB		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_CODBAND"} )  
		//Local nPosBand		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_BANDEIR"} ) 
		//Local nPosAut		:= Ascan(oGetConNe:aHeader,{|x| AllTrim(x[2]) == "Z1_AUTORIZ"} )  
		//Local cCondPg		:= GetMv("ES_CONDPG",,"121/122/123/124/125/126")		
		Local  cobsexp      := SPACE(900)
		Local lFim          := .T. 
		Local __HLDESCMAX	:=	SUPERGETMV("HL_DESCMAX" , .F., 99,)
		Local __HLTOTCMAX	:=	SUPERGETMV("HL_DTOTMAX" , .F., 99,)
		
		Private oGetVAL            
		Private oGetVAL1
		Private oDlgFimCot
		Private oGetc		:= NIl
		
		//Public  _nDnyVlFrt  := 0.00				
		Public _cUF         := ""
		Public _MunEnt      := ""           
		Public _cCODCLI     := cod_cli
		Public _cLOJCLI     := coja_cli 
		
		Private _cCod_Vend  := POSICIONE("SA1",1,XFILIAL("SA1")+ALLTRIM(cod_cli)+ALLTRIM(coja_cli),"A1_VEND")
		Private _cNom_Vend  := POSICIONE("SA3",1,XFILIAL("SA3")+ALLTRIM(cod_cli),"A3_NOME")
		Private _aDadosFin  := {}
		Private _oTTotFim   := Nil
		//Private nDespesa    := 0.00
		//Private nDescTota   := 0.00 
		//Private OGETC		:= Nil

		If Empty(_cCod_Vend)
			_cCod_Vend:=POSICIONE("SA3",7,XFILIAL("SA3")+__cUserID,"A3_COD")
			_cNom_Vend:=SA3->A3_NOME
		EndIf
			    _cBpCod_Fpg := cod_fpg
    		
		IF ALLTRIM(cStatBl) == "CLIENTE BLOQUEADO"
			Aviso("Cliente Inativo","Este cliente encontra-se Bloqueado, confirmação não permitida.",{"OK"})
			Return .F.
		EndIf

		cCTpOper := PadR(cCTpOper,TamSX3('UA_XTOPER')[1])
	
		If !Empty(cod_cli) .and. !Empty(coja_cli)
			For nI := 1 To Len(oOrcamento:aCols)
				If !(oOrcamento:aCols[nI][Len(oOrcamento:aCols[nI])])
		
					IF EMPTY(oOrcamento:aCols[nI, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)]) .OR. EMPTY(oOrcamento:aCols[nI, GdFieldPos("UB_PRCTAB",oOrcamento:aHeader)])
						Exit
					ENDIF					
					
					// Renato Bandeira em 4/1/15
					If ROUND((((oOrcamento:aCols[nI, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)]/oOrcamento:aCols[nI, GdFieldPos("UB_PRCTAB",oOrcamento:aHeader)])*100)-100) * -1, 2) > __HLDESCMAX	//30
						MSGALERT("Produto : "+oOrcamento:aCols[nI][2]+" com desconto superior a "+ALLTRIM(STR(__HLDESCMAX,2))+"%. Verifique!")
						Return .F.            
                    Endif  
                    
					// Renato Bandeira em 4/1/15
					If  ROUND((((oOrcamento:aCols[nI, GdFieldPos("UB_PRCTAB",oOrcamento:aHeader)]/oOrcamento:aCols[nI, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])*100)-100) * -1, 2) > __HLDESCMAX //30
						MSGALERT("Produto : "+oOrcamento:aCols[nI][2]+" com acressimo superior a "+ALLTRIM(STR(__HLDESCMAX,2))+"%. Verifique!")
						Return .F.            
                    Endif                    
				Endif
			Next
		Endif
		
		//--Em caso de bonificação não deve-se avaliar
		If AllTrim(cCTpOper) $ '01|02'
			If ValType(nDescT) != 'N'
				nDescT:= 0
			EndIf
			If nDescT > __HLTOTCMAX
				Alert("Atenção, a soma dos dos descontos dos itens e total não pode ultrapassar o limite de "+Alltrim(Str(__HLTOTCMAX))+"%")
				Return(.F.)	
			EndIf
		EndIf	

		DbSelectArea('SA1')
		SA1->(DbGoTop())
		lRet := SA1->(DbSeek(xFilial('SA1')+PadR(cod_cli,TamSX3('A1_COD')[1]) + PadR(coja_cli,TamSX3('A1_LOJA')[1])))
		
		If (!Empty(cod_cli) .and. !Empty(coja_cli) .and. lRet) .Or. __lProsp
			
			lRet := .F.
			If !Empty(cum_orc)
				dbSelectArea("SUA")
				dbSetOrder(1)
				If SUA->(dbSeek( xFilial("SUA") + cum_orc ))
					If lProsp
						cobsfin 	:= If(Empty(SUA->UA_XOBSFIN), cObsFin, SUA->UA_XOBSFIN)
						cobslog 	:= If(Empty(SUA->UA_XOBSLO),  cObsLog, SUA->UA_XOBSLO)
						cobscob 	:= If(Empty(SUA->UA_XOBSCO),  cObsCob, SUA->UA_XOBSCO)
						cobsexp 	:= If(Empty(SUA->UA_XOBSEXP), cObsExp, SUA->UA_XOBSEXP)
						cod_trp		:= If(Empty(SUA->UA_TRANSP),  Cod_Trp, SUA->UA_TRANSP)
						Cod_Redesp	:= If(Empty(SUA->UA_XREDESP), Cod_Redesp, SUA->UA_XREDESP)
						cod_fpg		:= If(Empty(SUA->UA_CONDPG),  Cod_Fpg, SUA->UA_CONDPG)
						cPedCli		:= If(Empty(SUA->UA_PEDCLI),  cPedCli, SUA->UA_PEDCLI)
						cEndEnt		:= If(Empty(SUA->UA_ENDENT),  cEndEnt, SUA->UA_ENDENT)
						cBaiEnt		:= If(Empty(SUA->UA_BAIRROE), cBaiEnt, SUA->UA_BAIRROE)
						cMunEnt		:= If(Empty(SUA->UA_MUNE), 	  cMunEnt, SUA->UA_MUNE)
						cEstEnt		:= If(Empty(SUA->UA_ESTE),	  cEstEnt, SUA->UA_ESTE)
						cCepEnt		:= If(Empty(SUA->UA_CEPE),	  cCepEnt, SUA->UA_CEPE)
						_nDnyVlFrt  := If(Empty(SUA->UA_FRETE), _nDnyVlFrt, SUA->UA_FRETE)
						//_cCod_Vend  := If(Empty(SUA->UA_VEND),  _cCod_Vend, SUA->UA_VEND)
						_cCod_Vend  := iIF(!Empty(SA1->A1_VEND), SA1->A1_VEND, If(Empty(SUA->UA_VEND),  _cCod_Vend, SUA->UA_VEND))
						_cNom_Vend  := POSICIONE("SA3",1,XFILIAL("SA3")+_cCod_Vend,"A3_NOME")														
			   			nDespesa    := If(Empty(SUA->UA_DESPESA),  nDespesa, SUA->UA_DESPESA)
			   			nDescTota   := If(Empty(SUA->UA_DESCONT),  nDescTota, SUA->UA_DESCONT) 
			   			cCTpOper    := If(Empty(SUA->UA_XTOPER),   cCTpOper, SUA->UA_XTOPER)   
						//cCodTab     := If(Empty(SUA->UA_TABELA),   cCodTab,SUA->UA_TABELA) 
						//cCodTabAnt  =  If(Empty(SUA->UA_TABELA),   cCodTabAnt, SUA->UA_TABELA) 
						_nPrvFrt	:= If(Empty(SUA->UA_ZPRVFRE), _nPrvFrt, SUA->UA_ZPRVFRE)							   			
					Else
						//cobsfin 	:= SUA->UA_XOBSFIN
						cobsfin 	:= SA1->A1_OBSFIN
						cobslog 	:= SUA->UA_XOBSLO
						cobscob 	:= SUA->UA_XOBSCO
						cobsexp 	:= SUA->UA_XOBSEXP
						cod_trp		:= SUA->UA_TRANSP
						cod_Redesp	:= SUA->UA_XREDESP
						//[Meliora/Gustavo]-Habilita alteracao da condição de pagamento
						//cod_fpg		:= SUA->UA_CONDPG                              
						//[Meliora/Gustavo]-Habilita alteracao da condição de pagamento
						cPedCli		:= SUA->UA_PEDCLI
						cEndEnt		:= If(Empty(SUA->UA_ENDENT),	SA1->A1_END,	 SUA->UA_ENDENT)
						cBaiEnt		:= If(Empty(SUA->UA_BAIRROE),	SA1->A1_BAIRRO, SUA->UA_BAIRROE)
						cMunEnt		:= If(Empty(SUA->UA_MUNE),		SA1->A1_MUN,	 SUA->UA_MUNE)
						cEstEnt		:= If(Empty(SUA->UA_ESTE),		SA1->A1_EST,	 SUA->UA_ESTE)
						cCepEnt		:= If(Empty(SUA->UA_CEPE),		SA1->A1_CEP,	 SUA->UA_CEPE)
						_nDnyVlFrt  := SUA->UA_FRETE 
						//_cCod_Vend  := SUA->UA_VEND 
						_cCod_Vend  := iIF(!Empty(SA1->A1_VEND), SA1->A1_VEND, If(Empty(SUA->UA_VEND),  _cCod_Vend, SUA->UA_VEND))
						_cNom_Vend  := POSICIONE("SA3",1,XFILIAL("SA3")+_cCod_Vend,"A3_NOME")
						nDespesa    := If(Empty(SUA->UA_DESPESA),  nDespesa, SUA->UA_DESPESA)
			   			nDescTota   := If(Empty(SUA->UA_DESCONT),  nDescTota, SUA->UA_DESCONT) 
						//cCTpOper    :=  If(!Empty(cCTpOper),  PadR(cCTpOper,2) , SuperGetMv("DN_TPOPER"))
						//cCTpOper    := If(Empty(cCTpOper),   cCTpOper, SUA->UA_XTOPER)
						//cCodTab       := If(Empty(SUA->UA_TABELA),  cCodTab, SUA->UA_TABELA) 
						//cCodTabAnt    :=  If(Empty(SUA->UA_TABELA), cCodTabAnt, SUA->UA_TABELA) 
						_nPrvFrt	:= SUA->UA_ZPRVFRE				
					Endif
			
					dbSelectArea("SUB")
					dbSetOrder(1)
					SUB->(dbSeek( xFilial("SUB") + cum_orc))
			  
					dEntreg	:= ddatabase
			
					lRet := .T.
			
				EndIf
		
			else
				dVenc1 := ctod('')
				dVenc2 := ctod('')
				dVenc3 := ctod('')
				dVenc4 := ctod('')
				nParc1 := 0
				nParc2 := 0
				nParc3 := 0
				nParc4 := 0
				nDias1 := 0
				nDias2 := 0
				nDias3 := 0
				nDias4 := 0
			EndIf
	
			If !lRet .Or. __lProsp
				cobsfin			:= If( Empty( cobsfin )  .and. !__lProsp, SA1->A1_OBSFIN, cobsfin )
				cobslog			:= If( Empty( cobslog )  .and. !__lProsp, SA1->A1_OBSLO,  cobslog )
				cobscob			:= If( Empty( cobscob )  .and. !__lProsp, SA1->A1_OBSCO,  cobscob )
				dEntreg			:= dDatabase
				cPEDCLI			:= Space(TamSX3("UA_PEDCLI") [1])
				cEndEnt			:= If( Empty( cEndEnt )  .and. !__lProsp, SA1->A1_END,	cEndEnt)
				cBaiEnt			:= If( Empty( cBaiEnt )  .and. !__lProsp, SA1->A1_BAIRRO,cBaiEnt)
				cMunEnt			:= If( Empty( cMunEnt )  .and. !__lProsp, SA1->A1_MUN,	cMunEnt)
				cEstEnt			:= If( Empty( cEstEnt )  .and. !__lProsp, SA1->A1_EST,	cEstEnt)
				cCepEnt			:= If( Empty( cCepEnt )  .and. !__lProsp, SA1->A1_CEP,	cCepEnt)
			Endif

			_cUF    := cEstEnt		// Adicionado Valdemir Jose 31/10/2013
			_MunEnt := cMunEnt		// Adicionado Fabio Gesser 22/11/2013

			come_rep		:= Posicione("SA3",1,xFilial("SA3")+cod_rep,"A3_NOME")
			come_transp		:= Posicione("SA4",1,xFilial("SA4")+cod_trp,"A4_NOME")
			ces_forma_pgto	:= Posicione("SE4",1,xFilial("SE4")+cod_fpg,"E4_DESCRI")
	
			For nI := 1 To Len(oOrcamento:aCols)
		
				If !(oOrcamento:aCols[nI][Len(oOrcamento:aCols[nI])])
			
					If !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO", __aHeaderEx)])
					    						                    			           
						DbSelectArea("SB1")
						DbSetOrder(1)
						DbSeek(xFilial("SB1") + oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO", __aHeaderEx)] )
												
						nTotal	+= oOrcamento:aCols[nI,GdFieldPos("UB_VLRITEM", __aHeaderEx)]
						nVlrIPI += NoRound( oOrcamento:aCols[nI,GdFieldPos("UB_VLRITEM", __aHeaderEx)] * (Posicione("SB1",1,xFilial("SB1") + oOrcamento:aCols[nI,GdFieldPos("UB_PRODUTO", __aHeaderEx)], "B1_IPI" ) / 100) , 2)
				
					EndIf
			
				Endif
		
			Next nI  
			
			If !xCalcTtGer(@_aDadosFin, _nDnyVlFrt, PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli)
				Return(.F.)
			EndIf   
			
			DEFINE FONT oFont1 NAME "Arial Black" SIZE 8,25 
    		DEFINE FONT oFont2 NAME "Arial Black" SIZE 6,17
    		
			DEFINE MSDIALOG oDlgFimCot TITLE "Dados Finais da Cotação" FROM C(100),C(300) TO C(655),C(1220) COLORS 0, 16777215 PIXEL Style 128
			oDlgFimCot:lEscClose := .F. 	
			@ C(004),C(005) SAY oSayFim01 PROMPT "CNPJ" 			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(004),C(304) SAY oSayFim02 PROMPT "Atendente"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(018),C(005) SAY oSayFim03 PROMPT "Aberta"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(032),C(005) SAY oSayFim04 PROMPT "Repres."			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(032),C(105) SAY oSayFim05 PROMPT "No.Cotação"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(032),C(220) SAY oSayFim06 PROMPT "Total"			SIZE C(060), C(009)		OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(032),C(312) SAY oSayFim07 PROMPT "IPI"				SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
		
			@ C(046),C(005) SAY oSayFim09 PROMPT "Tipo do Frete"	SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(046),C(202) SAY oSayFim08 PROMPT "Transp."			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(060),C(202) SAY oSayFim30 PROMPT "Redesp."			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
							            			                                                                                  
   			@ C(060),C(005) SAY oObjVend PROMPT "Vendedor:"         SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
						
			@ C(074),C(005) SAY oSayFim10 PROMPT "Ped.Compra"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(074),C(110) SAY oSayFim11 PROMPT "Comprador"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(074),C(291) SAY oSayFim12 PROMPT "Frete"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			
   			@ C(088),C(005) SAY oObjVend  PROMPT "End.Entrega:"     SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

   			@ C(088),C(090) SAY oSayFim13 PROMPT "Forma Pgt"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(088),C(279) SAY oSayFim15 PROMPT "Despesas"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(102),C(005) SAY oSayFim11 PROMPT "Data Pri Parc"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL 
			
			//nTotComiss:=U_COMISS(_nTotFina, _nTotTabe,cCodTab, cod_fpg) //ROUND(_nTotTabe/_nTotFina,2)
			@ C(102),C(279) SAY oSayFim16 PROMPT "Desconto Tot"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL			
						                                                                                                   
			//@ C(102),C(205) SAY oSayFim11 PROMPT "Data Progr.2"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(116),C(005) SAY oSayFim11 PROMPT "Data Ult Parc"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			//@ C(116),C(205) SAY oSayFim11 PROMPT "Data Progr.4"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			//@ C(116),C(279) SAY oSayFim11 PROMPT "% "+Alltrim(TransForm(nTotComiss,PesqPict('SC6', 'C6_COMIS1'))) FONT oFont1 SIZE C(100),C(015) OF oDlgFimCot PIXEL COLOR CLR_RED
						
			@ C(102),C(120) SAY oSayFim15 PROMPT "Vlr.Pri.Parc"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			//@ C(102),C(300) SAY oSayFim15 PROMPT "Parcela 2"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(116),C(120) SAY oSayFim15 PROMPT "Vlr.Ult.Parc"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			//@ C(116),C(300) SAY oSayFim15 PROMPT "Parcela 4"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(130),C(005) SAY oSayFim17 PROMPT "Obs.Comercial"  	SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(153),C(005) SAY oSayFim19 PROMPT "Obs.Entrega"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(176),C(005) SAY oSayFim20 PROMPT "Obs.Pedido"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(199),C(005) SAY oSayFim21 PROMPT "Ent.Prometida"	SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			
			//--Data do agendamento
			@ C(199),C(140) SAY oSayFim35 PROMPT "Dt Agendamento"	SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			
			@ C(199),C(260) SAY oSayFim22 PROMPT "Tp.Liberação" 	SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			//@ C(215),C(003) GROUP oGrupo  TO C(273),C(385) PROMPT " ENDEREÇO DO FATURAMENTO" 		OF oDlgFimCot COLOR  0, 16777215 PIXEL  
			@ C(215),C(003) GROUP oGrupo  TO C(273),C(230) PROMPT " ENDEREÇO DO FATURAMENTO " 		OF oDlgFimCot COLOR  0, 16777215 PIXEL

			@ C(227),C(005) SAY oSayFim23 PROMPT "Endereço" 		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(241),C(005) SAY oSayFim24 PROMPT "Bairro"			SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL

			@ C(241),C(160) SAY oSayFim25 PROMPT "CEP"				SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(255),C(005) SAY oSayFim26 PROMPT "Município"		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(255),C(170) SAY oSayFim27 PROMPT "Estado"	   		SIZE C(060), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL   
						
			//--vencimentos Tipo 9
			@ C(215),C(233) GROUP oGrupo  TO C(273),C(382) PROMPT " VENCIMENTOS " OF oDlgFimCot COLOR  0, 16777215 PIXEL
			@ C(227),C(236) SAY oSayFim23 PROMPT "Venc 1" 	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(239),C(236) SAY oSayFim24 PROMPT "Venc 2"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(251),C(236) SAY oSayFim25 PROMPT "Venc 3"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(263),C(236) SAY oSayFim26 PROMPT "Venc 4"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL     
			//--Combos de vencimentos
			@ C(224),C(256) MsGet oDVenc1 VAR dVenc1 Size C(042),C(009) COLOR CLR_BLACK WHEN .F. PIXEL OF oDlgFimCot		
			@ C(236),C(256) MsGet oDVenc2 VAR dVenc2 Size C(042),C(009) COLOR CLR_BLACK WHEN .F. PIXEL OF oDlgFimCot 
			@ C(248),C(256) MsGet oDVenc3 VAR dVenc3 Size C(042),C(009) COLOR CLR_BLACK WHEN .F. PIXEL OF oDlgFimCot 
			@ C(260),C(256) MsGet oDVenc4 VAR dVenc4 Size C(042),C(009) COLOR CLR_BLACK WHEN .F. PIXEL OF oDlgFimCot 
			
			@ C(227),C(302) SAY oSayFim23 PROMPT "Perc%1" 	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(239),C(302) SAY oSayFim24 PROMPT "Perc%2"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(251),C(302) SAY oSayFim25 PROMPT "Perc%3"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(263),C(302) SAY oSayFim26 PROMPT "Perc%4"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL     
			
			@ C(224),C(322) MsGet oParc1 VAR nParc1 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot			
			@ C(236),C(322) MsGet oParc2 VAR nParc2 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot 
			@ C(248),C(322) MsGet oParc3 VAR nParc3 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot
			@ C(260),C(322) MsGet oParc4 VAR nParc4 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot
			
			@ C(227),C(342) SAY oSayFim31 PROMPT "Dias P1" 	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(239),C(342) SAY oSayFim32 PROMPT "Dias P2"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(251),C(342) SAY oSayFim33 PROMPT "Dias P3"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ C(263),C(342) SAY oSayFim34 PROMPT "Dias P4"	SIZE C(020), C(009) 	OF oDlgFimCot COLORS 0, 16777215 PIXEL     
			
			@ C(224),C(363) MsGet oDias1 VAR nDias1 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot Valid FsDataVe(nDias1, @oDVenc1, @dVenc1, @dVenc2, @dVenc3, @dVenc4, '1')			
			@ C(236),C(363) MsGet oDias2 VAR nDias2 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot Valid FsDataVe(nDias2, @oDVenc2, @dVenc1, @dVenc2, @dVenc3, @dVenc4, '2')
			@ C(248),C(363) MsGet oDias3 VAR nDias3 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot Valid FsDataVe(nDias3, @oDVenc3, @dVenc1, @dVenc2, @dVenc3, @dVenc4, '3')
			@ C(260),C(363) MsGet oDias4 VAR nDias4 PICTURE "@R 999" Size C(018),C(009) COLOR CLR_BLACK PIXEL OF oDlgFimCot Valid FsDataVe(nDias4, @oDVenc4, @dVenc1, @dVenc2, @dVenc3, @dVenc4, '4')
			
			@ C(004),C(387) GROUP oGrupo  TO C(267),C(459)                              	OF oDlgFimCot COLOR  0, 16777215 PIXEL
	
			@ C(004),C(055) MSGET    oGet1	   VAR cod_cnpj	 PICTURE "@R 99.999.999/9999-99"	  SIZE C(100),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(004),C(349) MSGET    oGet2 	   VAR cod_atend 									  SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL

			@ C(018),C(055) MSGET    oGet3 	   VAR cod_cli 									      SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(018),C(093) MSGET    oGet4 	   VAR coja_cli 									  SIZE C(003),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(018),C(130) MSGET    oGet5 	   VAR come_cLi 									  SIZE C(180),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL

			@ C(032),C(055) MSGET    oGet6 	   VAR cod_rep 									      SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(032),C(093) MSGET    oGet7 	   VAR come_rep 									  SIZE C(120),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(032),C(245) MSGET    oGet8 	   VAR nTotal 	 PICTURE "@E 99,999,999.99"	          SIZE C(050),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(032),C(335) MSGET    oGet9 	   VAR nVlrIPI	 PICTURE "@E 99,999,999.99"	          SIZE C(050),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			
			
			@ C(046),C(055) COMBOBOX oGetC     VAR cCTpFrete ITEMS CTBCBOX("UA_XTPFRET")   /*{'1=CIF','2=FOB Incluso na NF','3=FOB A Cobrar (Cliente paga no destino)','4=Cliente Retira'}*/  SIZE C(107),C(010) OF oDlgFimCot COLORS 0, 16777215  PIXEL Valid FSDescont(@nDescTota,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd, cCTpFrete,cod_cli,coja_cli )
   			
   			@ C(046),C(225) MSGET    oGetVAL   VAR cod_trp SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215  PIXEL F3("SA4_2") VALID(DNYTRANSP(cod_trp, @come_transp,oGetB) ) .and. RetEndE(@cobslog )   			   		
			@ C(046),C(265) MSGET    oGetB 	   VAR come_transp  SIZE C(120),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			
			@ C(060),C(225) MSGET    oGetVAL1  VAR cod_Redesp   SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215  PIXEL F3("SA4_2") VALID(DNYTRANSP(cod_Redesp, @come_Redesp,oGetB1) )     			   		
			@ C(060),C(265) MSGET    oGetB1	   VAR come_Redesp  SIZE C(120),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL           
              
			@ C(060),C(055) MSGET  oGetVend VAR _cCod_Vend SIZE 026,009 OF oDlgFimCot COLORS 0, 16777215  PIXEL F3("SA3") VALID(((_cNom_Vend:=POSICIONE("SA3",1,XFILIAL("SA3")+_cCod_Vend,"A3_NOME")),ExistCpo('SA3',_cCod_Vend))) When(xAltVnd(_cCod_Vend,@oGetVend))
			@ C(060),C(100) MSGET  oGetVndD VAR _cNom_Vend SIZE 100,009 OF oDlgFimCot COLORS 0, 16777215 WHEN(.F.) PIXEL
									
			@ C(074),C(055) MSGET    oGetD     VAR cPedCli								   		  SIZE C(050),C(009) OF oDlgFimCot COLORS 0, 16777215          PIXEL         // VALID VLDPEDCLI()
			@ C(074),C(150) MSGET    oGetE 	   VAR come_comprador								  SIZE C(050),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(074),C(320) MSGET    oGetF 	   VAR _nDnyVlFrt    PICTURE PesqPict('SUA','UA_FRETE')   SIZE C(066),C(009) OF oDlgFimCot COLORS 0, 16777215 Valid(xValidFrt(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli) .And. FSDescont(@nDescTota,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd, cCTpFrete,cod_cli,coja_cli  ))     PIXEL
			
			@ C(088),C(055) MSGET  oGetEndE VAR _cCod_EndE SIZE 026,009 OF oDlgFimCot COLORS 0, 16777215 when .F.  PIXEL F3("Z31") VALID( RetEndE(@cobslog ) /*, ExistCpo('Z31',_cCODCLI + _cCod_EndE)*/)

			@ C(088),C(120) MSGET  oGetCnd  VAR cod_fpg	          SIZE C(003),C(009) OF oDlgFimCot COLORS 0, 16777215 /*When(_lAltSE4)*/ PIXEL F3("SE4_2") VALID(DNYCONDPG(cod_fpg, @ces_forma_pgto, oFolder:aDialogs[3],@_lAltSE4,@_nAltSE4,oGetCnd,oDVenc1, oDVenc2, oDVenc3, oDVenc4,cod_cli) .And. FSDescont(@nDescTota,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd, cCTpFrete,cod_cli,coja_cli) )
			@ C(088),C(150) MSGET  oGetH 	VAR ces_forma_pgto	  SIZE C(050),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL

			@ C(088),C(320) MSGET  oGetJ 	   VAR nDespesa	 PICTURE PesqPict('SUA','UA_DESPESA') SIZE C(066),C(009) OF oDlgFimCot COLORS 0, 16777215  WHEN .F.  Valid(xValidFrt(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli) .And. FSDescont(@nDescTota,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd, cCTpFrete,cod_cli,coja_cli))  PIXEL

			@ C(102),C(055) MSGET    oDtProgr     VAR dDtProgr                           		  SIZE C(055),C(009) OF oDlgFimCot COLORS 0, 16777215  WHEN .F. PIXEL 		//LEANDRO.EBER - 31/08/2016 //VALID VLDDTPROG(@cod_fpg, dDtProgr)
			
			@ C(102),C(150) MSGET    oVlrProg1	  VAR nVlrProg1	 PICTURE PesqPict('SE1','E1_VALOR')	SIZE C(055),C(009) OF oDlgFimCot COLORS 0, 16777215  WHEN .F. PIXEL 	//LEANDRO.EBER - 31/08/2016 //VALID VLDVLPROG() 
						
			//@ C(102),C(320) MSGET    oGetJ 	   VAR nDescTota	 PICTURE PesqPict('SUA','UA_DESCONT') SIZE C(066),C(009) OF oDlgFimCot COLORS 0, 16777215 Valid(xValidDes(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd))  PIXEL
			@ C(102),C(320) MSGET    oGetJ 	   VAR nDescTota	 PICTURE PesqPict('SUA','UA_DESCONT') SIZE C(066),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN GetMv('DN_BLOQDES',.F.,.F.) Valid(xValidDes(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd,cod_cli,coja_cli))  PIXEL
			
			@ C(116),C(055) MSGET    oDtProgr3    VAR dDtProgr3                           		      	SIZE C(055),C(009) OF oDlgFimCot COLORS 0, 16777215  WHEN .F. PIXEL //LEANDRO.EBER - 31/08/2016//VALID VLDDTPROG(@cod_fpg, dDtProgr3)			
			@ C(116),C(150) MSGET    oVlrProg3	  VAR nVlrProg3	 PICTURE PesqPict('SE1','E1_VALOR')	SIZE C(055),C(009) OF oDlgFimCot COLORS 0, 16777215  WHEN .F. PIXEL  	//LEANDRO.EBER - 31/08/2016//VALID VLDVLPROG() 

			@ C(130),C(055) GET      oGetL     VAR cobscob	MEMO							      SIZE C(330),C(020) OF oDlgFimCot COLORS 0, 16777215          PIXEL

			@ C(153),C(055) GET      oGetM     VAR cobslog 	MEMO							      SIZE C(330),C(020) OF oDlgFimCot COLORS 0, 16777215          PIXEL

			@ C(176),C(055) GET      oGetN     VAR cobsexp 	MEMO							      SIZE C(330),C(020) OF oDlgFimCot COLORS 0, 16777215          PIXEL

			@ C(199),C(055) MSGET    oGetO     VAR dEntreg                           		      SIZE C(060),C(009) OF oDlgFimCot COLORS 0, 16777215          PIXEL          VALID (dEntreg >= ddatabase)
			
			@ C(199),C(190) MSGET    oGetW     VAR dAgenda                           		      SIZE C(060),C(009) OF oDlgFimCot COLORS 0, 16777215    WHEN IsInCallStack("u_IVENA010")      PIXEL     //VALID (dAgenda >= ddatabase)
			
			@ C(199),C(305) COMBOBOX oGetP     VAR cTpLibera ITEMS {"1=Libera Por Item","2=Libera por Pedido"} SIZE C(080),C(010) OF oDlgFimCot COLORS 0, 16777215  WHEN .F.        PIXEL

			@ C(227),C(055) MSGET    oGetQ 	   VAR cEndEnt	PICTURE PesqPict('SA1', 'A1_END')  SIZE C(168),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL

			@ C(241),C(055) MSGET    oGetR 	   VAR cBaiEnt	PICTURE PesqPict('SA1', 'A1_BAIRRO') SIZE C(088),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL

			@ C(241),C(186) MSGET    oGetS 	   VAR cCepEnt	PICTURE PesqPict('SA1', 'A1_CEP')    SIZE C(022),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(255),C(055) MSGET    oGetT 	   VAR cMunEnt	PICTURE PesqPict('SA1', 'A1_MUN')    SIZE C(068),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL
			@ C(255),C(208) MSGET    oGetU 	   VAR cEstEnt	PICTURE PesqPict('SA1', 'A1_EST')    SIZE C(014),C(009) OF oDlgFimCot COLORS 0, 16777215 WHEN .F. PIXEL 
						
    		@ C(010),C(395) SAY  oxDesTtGer PROMPT "Dados Financeiro" FONT oFont1 SIZE C(060), C(015) OF oDlgFimCot PIXEL COLOR CLR_RED
    		    		    		
    		//_nVlFim    := xCalcTtGer(@_aDadosFin, _nDnyVlFrt, PadR(cCTpOper,TamSX3('UA_XTOPER')[1]))
    		_nLin      := 030 
    		
    		If Len(_aDadosFin)== 0
    			Return(.T.)
    		EndIf 
			@ _nLin,390 SAY _oTImp01D PROMPT _aDadosFin[01][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp01V PROMPT TransForm(_aDadosFin[01][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
			_nLin+=10
			@ _nLin,390 SAY _oTImp02D PROMPT _aDadosFin[02][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp02V PROMPT TransForm(_aDadosFin[02][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
			_nLin+=10
			@ _nLin,390 SAY _oTImp03D PROMPT _aDadosFin[03][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp03V PROMPT TransForm(_aDadosFin[03][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
			_nLin+=10
			@ _nLin,390 SAY _oTImp04D PROMPT _aDadosFin[04][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp04V PROMPT TransForm(_aDadosFin[04][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
			_nLin+=10
			@ _nLin,390 SAY _oTImp05D PROMPT _aDadosFin[05][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp05V PROMPT TransForm(_aDadosFin[05][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
			_nLin+=10
			@ _nLin,390 SAY _oTImp06D PROMPT _aDadosFin[06][01] SIZE 060, 009 OF oDlgFimCot COLORS 0, 16777215 PIXEL
			@ _nLin,425 SAY _oTImp06V PROMPT TransForm(_aDadosFin[06][02],PesqPict('SC6','C6_VALOR')) SIZE 060, 009 OF oDlgFimCot PIXEL COLOR CLR_BLUE
																    		
    		//_nTTotFim := (_aDadosFin[06][02]+_nDnyVlFrt-nDescTota) 
    		_nTTotFim := (_aDadosFin[06][02]+_nDnyVlFrt) 
    		_nTotFina := _nTTotFim-_nDnyVlFrt
    		//nTotComiss:= U_COMISS(_nTotFina, _nTotTabe, cCodTab, cod_fpg) //ROUND(_nTotTabe/_nTotFina,2)
    		nTotComiss:= 0
    		@ 100,393 MSGET _oTTotFim VAR _nTTotFim PICTURE(PesqPict('SC6','C6_VALOR')) SIZE 062,009 OF oDlgFimCot WHEN(.F.)  PIXEL COLOR CLR_RED
    		
			@ C(125),C(387) GROUP oGrupo2  TO C(267),C(459) OF oDlgFimCot COLOR  0, 16777215 PIXEL
    		
			@ C(170), C(390) BUTTON oButton6 PROMPT "Calcular &Frete" SIZE C(065), C(015) OF oDlgFimCot ACTION ;
			{MsgRun("Calculando frete...",,{|| DNYCalcFrt(cCTpFrete, oGetB, oGetF, _aDadosFin, _oTImp03V, _oTImp06V, _cDetalhe)} ),oGetL:SetFocus()} PIXEL // "1" Calculo de Frete	
    		
			@ C(190), C(390) BUTTON oButton1 PROMPT "Gravar &Orçamento"   	SIZE C(065), C(015) OF oDlgFimCot WHEN _lBotaoGrvOrc ACTION ;
			MsgRun("Gerando orcamento...",,{|| lGravou:= .T., lRet := u_IVENA070("1",cod_cli,coja_cli, cum_orc, cPedCli,; 
			cod_fpg, _cBpCod_Fpg, cod_trp, cobsexp, cobsfin, cobscob, cobslog, dEntreg, cod_banco, "2",lProsp, cEndEnt, cBaiEnt, cMunEnt,;
			cEstEnt, cCepEnt, cCTpFrete, PadR(cCTpOper,TamSX3('UA_XTOPER')[1]), _nDnyVlFrt, nDespesa, cTpLibera/*, cod_red*/,cXFRECIF,_cCod_Vend,_nTTotFim,dDtProgr,;
			nVlrProg1,dDtProgr2,nVlrProg2,dDtProgr3,nVlrProg3,dDtProgr4,nVlrProg4,nDescT,nDescTota,cCodTab,nVatrazo,nLCrdT,nLCrd, IIF(Type("oGetDad:Acols")!= 'U',oGetDad:Acols,{}),@nCNVal_Uti,;
			dVenc1, dVenc2, dVenc3, dVenc4, nParc1, nParc2, nParc3, nParc4,nDias1,nDias2,nDias3,nDias4,cCod_por, cLoja_por, cod_Redesp, dAgenda, _nPrvFrt),;
			If(lRet, FSGravPrm(aItensPro),),;
			If(lRet, oDlgFimCot:END(),),;
			If(lRet, FsAtuaAge(cIdPai, 'O', dAgenda),),;				
			If(lRet, DNYLIMPVAR(2,.F.),),;
			If(lRet, ofolder:noption:=1,),;
			If(lRet, oCod_Cli:setfocus(),),;
			If(lRet, u_IVENR010(),),;
			If(lRet, lGravou:= .F.,),;
			If(lRet, __lProsp:= .F.,),;
			If(lRet, (_nAltSE4:=0,_lAltSE4:=.T.),)	} ) PIXEL									// "2" Orçamento                         
			
				
			@ C(210), C(390) BUTTON oButton4 PROMPT "Gravar &Pedido"		    SIZE C(065), C(015) OF oDlgFimCot WHEN _lPedBotaoGrv ACTION ;				
			{ lGravou:= .T., If(.T., lRet:= u_IVENA070("2",cod_cli, coja_cli, cum_orc, cPedCli, cod_fpg,;
			_cBpCod_Fpg, cod_trp, cobsexp,  cobsfin, cobscob,  cobslog, dEntreg, cod_banco, "3", lProsp, cEndEnt, cBaiEnt, cMunEnt, cEstEnt,;
			cCepEnt, cCTpFrete, PadR(cCTpOper,TamSX3('UA_XTOPER')[1]), _nDnyVlFrt, nDespesa, cTpLibera/*, cod_red*/,cXFRECIF,_cCod_Vend,;
			_nTTotFim,dDtProgr,nVlrProg1,dDtProgr2,nVlrProg2,dDtProgr3,nVlrProg3,dDtProgr4,nVlrProg4,nDescT, nDescTota,cCodTab,nVatrazo,nLCrdT,;
			nLCrd, IIF(Type("oGetDad:Acols")!= 'U',oGetDad:Acols,{}),nCNVal_Uti, dVenc1, dVenc2, dVenc3, dVenc4, nParc1, nParc2, nParc3, nParc4,nDias1,nDias2,nDias3,nDias4,cCod_por,cLoja_por,cod_Redesp, dAgenda, _nPrvFrt),),;
			if(lRet, FSGravPrm(aItensPro),),;
			If(lRet, oDlgFimCot:END(),),;
			If(lRet, FsAtuaAge(cIdPai,'P', dAgenda),),;
			If(lRet, DNYLIMPVAR(2,.F.),),;
			If(lRet, lGravou:= .F.,),;
			If(lRet, __lProsp:= .F.,),;			
			If(lret, ofolder:noption:=1,),;
			If(lRet, (_nAltSE4:=0,_lAltSE4:=_lBotaoGrvOrc:=.T.),)   } 	PIXEL									// "2" Orçamento            
		   	@ C(230), C(390) BUTTON oButton3 PROMPT "&Historico" SIZE C(065), C(015) OF oDlgFimCot ACTION U_IFATC010(cod_cli, coja_cli) PIXEL			
			@ C(250), C(390) BUTTON oButton3 PROMPT "&Sair" SIZE C(065), C(015) OF oDlgFimCot ACTION (lFim:=.F.,oDlgFimCot:END(),_nAltSE4:=0,_lAltSE4:=.T.) PIXEL
			
			ACTIVATE MSDIALOG oDlgFimCot CENTERED
		Else
			Alert("Selecione Cliente e/ou Produto, faça o orçamento")
		Endif

		RestArea(aAreaSUB)
		RestArea(aAreaSUA)
		RestArea(aArea)

	Return(lFim)

//[##Meliora/Gustavo] CALCULA VALOR TOTAL "FATURADO"                          
*-------------------------------------------------*
Static Function xCalcTtGer(_aDadosFin,_nDnyVlFrt,cCTpOper,cod_cli,coja_cli)   
*-------------------------------------------------*
Local _nTVlIpi  := 0
Local _nTValor  := 0
Local _nTValSol := 0
Local _nTValIcm := 0
Local _nTTotal  := 0 
Local _nDescTot := 0
Local cTesInt	:= ''
Local _nSum, nX

_aDadosFin := {}
	
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1")+cod_cli+coja_cli))

//SOMA TOTAL DO VALOR DOS ITENS QUANTIDADE * VALOR TOTAL
_nTotItem:=0 
For _nSum:=1 To Len(oOrcamento:aCols)
	If oOrcamento:aCols[_nSum][Len(oOrcamento:aHeader)+1] 
		Loop
	EndIf                                                 
	If Empty(oOrcamento:aCols[_nSum, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]) .OR. Empty(oOrcamento:aCols[_nSum, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
		Alert("Existem produtos sem dados de Quantidade e Valor Unitário.")		
		Return(.F.)	
	EndIf
	_nTotItem += (oOrcamento:aCols[_nSum, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[_nSum, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
Next _nSum




//INICIA PROCESSO PARA CALCULAO DOS IMPOSTOS	        
For nX:=1 To Len(oOrcamento:aCols)
	If oOrcamento:aCols[nX][Len(oOrcamento:aHeader)+1]
		Loop
	EndIf

	SB1->(DbSetOrder(01))
	SB1->(DbSeek(xFilial('SB1')+AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD')))

	If __lProsp
		cTesInt := GetMv('LB_TGVTES',.F.,'503')
	Else
		If cCTpOper == '05'
			cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),_ccli,_cloja,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)],NIL)
		Else
			IF ALLTRIM(cFilAnt) $ "0103|0102"
				If cCTpOper <> '87'
					if SB1->B1_ORIGEM $ "0|2"
						cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
					else
						SB2->(dbSetOrder(01))
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
						Else
							SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
								cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
							EndIf
						EndIf
						If Empty(cTesInt)
							If SB1->B1_LOCPAD $ '01|90'														
								cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							ElseIf SB1->B1_LOCPAD $ '03|80'							
								cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								MsgAlert(OemToAnsi('Produto com armazem padrão diferente de 01/90 ou 03/80'))
							EndIf
						EndIf					
					endif
				Else
					if SB1->B1_ORIGEM $ "0|2"
						cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
					else
						SB2->(dbSetOrder(01))
						SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
						Else
							SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
								cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)						
							EndIf
						EndIf
						If Empty(cTesInt)
							If SB1->B1_LOCPAD $ '01|90'														
								cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							ElseIf SB1->B1_LOCPAD $ '03|80'							
								cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								MsgAlert(OemToAnsi('Produto com armazem padrão diferente de 01/90 ou 03/80'))
							EndIf
						EndIf	
					endif
				EndIf	
       		Else
 	    		cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
	    	EndIf
		EndIf
	
		IF Empty(cTesInt)    
			MSGALERT("MSG 4. TES NAO CADASTRADO, AVISE A AREA FISCAL !!")
	    	cTesInt := GetMv('LB_TGVTES',.F.,'503')
	 	EndIF		 	
	EndIf		
	//Inicio do processo Fiscal
	MaFisIni(	cod_cli,;
				coja_cli,;		// 2-Loja do Cliente/Fornecedor
				"C",;			// 3-C:Cliente , F:Fornecedor
				'N',;			// 4-Tipo da NF
				SA1->A1_TIPO,;	// 5-Tipo do Cliente/Fornecedor
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				"MATA461",;
				Nil,;
				Nil,;
				IIF(__lProsp,cCod_por+cLoja_por,Nil),;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				Nil,,,Nil,Nil,Nil,Nil,,Nil)
                     
                     
    _nPorFrt := u_PrcFret(_nTotItem, (oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]*oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)]),_nDnyVlFrt)
				                        	                        
	MaFisAdd(	oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)],;
				cTesInt,;
	            oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)],;
	            oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)],;
	            0.00,;
	            "",;
	            "",;
	            0,;
	            0,;
	            0,;
	            0,;
	            0,;
	            ((oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]*oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])+_nPorFrt),;
	            0,;
	            0,;
	            0)

	_nAliqIcm  := MaFisRet(1,"IT_ALIQICM")
    _nValIcm   := MaFisRet(1,"IT_VALICM" )
    _nBaseIcm  := MaFisRet(1,"IT_BASEICM")
    _nValIpi   := MaFisRet(1,"IT_VALIPI" )
    _nBaseIpi  := MaFisRet(1,"IT_BASEICM")
    _nValMerc  := MaFisRet(1,"IT_VALMERC")
    _nValSol   := MaFisRet(1,"IT_VALSOL" ) 
    
    _nDescTot  := MaFisRet(,"NF_DESCONTO")           
    _nNfTotal  := MaFisRet(,"NF_TOTAL")
    _nBaseDup  := MaFisRet(,"NF_BASEDUP")
    MaFisEnd()              
    
	//Fim do processo Fiscal
	_nTVlIpi  += _nValIpi
	_nTValor  += (oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)]) //_nValMerc
	_nTValSol += _nValSol
	_nTValIcm += _nValIcm
	_nTTotal  := (_nTValor+_nTVlIpi+_nTValSol-_nDescTot)

Next nX      

Aadd(_aDadosFin,{'TOTAL ITEM:'		,_nTValor})
Aadd(_aDadosFin,{'ITEM + IPI:'		,_nTValor+_nTVlIpi})
Aadd(_aDadosFin,{'IPI:'				,_nTVlIpi})
Aadd(_aDadosFin,{'ICMS:'			,_nTValIcm})
Aadd(_aDadosFin,{'ICMS-ST:'			,_nTValSol})
Aadd(_aDadosFin,{'TOTAL GERAL:'		,_nTTotal})	

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYMOVOPERºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para alimentar array COMBO com as Operações          º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	Static Function DNYMOVOPER( aDTpOper )

		aDTpOper := {}

		//Renato Bandeira em 27/12 - ajustado para o tamanho 2, devido a tipo amostra gratis ser igual a R, um caracter
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPER"),02)+"="+"Vendas")
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPAM"),02)+"="+"Amostra Gratis")
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPBO"),02)+"="+"Remessa Bonificação")
		// Renato Bandeira em 29/10/14
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPCO"),02)+"="+"Comodato")
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPDE"),02)+"="+"Demonstracao")
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPVF"),02)+"="+"Simples Faturamento")
		aAdd(aDTpOper, Padr(SuperGetMv("DN_TPOPRF"),02)+"="+"Simples Remessa")

		//aAdd(aDTpOper, SuperGetMv("DN_TPOPVT")+"="+"Simples Faturamento")

	Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYGRVDCLIºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para checar o Codigo da Transportadora e carregar o  º±?
±±?         ³nome da transportadora em variavel de memoria               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	Static Function DNYGRVDCLI(cod_cli,coja_cli)

		Local aArea		:= GetArea()
		Local aAreaSA1	:= SA1->(GetArea())

		DbSelectArea("SA1")
		DbSetOrder(1)

		If SA1->(DbSeek(xFilial("SA1") + cod_cli + coja_cli ))
	
			RecLock("SA1",.F.)
	
	//	SA1->A1_XOBSFIN	:= cobsfin
			SA1->A1_OBSLO	:= cobslog
			SA1->A1_OBSCO	:= cobscob
			SA1->A1_TRANSP	:= cod_trp
			SA1->A1_COND	:= cod_fpg
	
			MsUnLock()
	
	
			MSGINFO("Atualizado com Exito os dados do Cliente", "Dados do Cliente")
	
		Endif

		RestArea(aAreaSA1)
		RestArea(aArea)
	Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYTRANSP ºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para checar o Codigo da Transportadora e carregar o  º±?
±±?         ³nome da transportadora em variavel de memoria               º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function DNYTRANSP(cCOD, cCPO,oOBJ1)
		//Local aArea		:= GetArea()
		//Local aAreaSA4	:= SA4->(GetArea())   
		Local lRet      := .T.  
		IF cCOD <> "      "
			DbSelectArea("SA4")
			DbSetOrder(1)
			If SA4->(DbSeek( xFilial("SA4") + cCOD ))
				cCPO := SA4->A4_NOME
				oOBJ1:Refresh()   
			Else
				Alert("Transportadora não encontrada")
				lRet       := .F.                     						
				cCOD       := Space(TamSx3("A1_TRANSP")[1])
				cCPO       := Space(TamSx3("A4_NOME")  [1])			
			EndIf
		Else 
			cCPO           := ''
			oOBJ1:Refresh()			
		ENDIF
					
Return lRet
/* LEANDRO.EBER 31/08/2016 

	Static Function DNYTRANSP(cCOD, cCPO, oOBJ1,_nDnyVlFrt,cCTpFrete,_lChange,_aDadosFin,_oTImp02V,_oTImp03V,_oTImp06V)
		Local lRet		:= .T.

		Local aArea		:= GetArea()
		Local aAreaSA4	:= SA4->(GetArea())                      
					
		Default _lChange := .F.
		
		cCTpOper := PadR(cCTpOper,TamSX3('UA_XTOPER')[1])
		
		IF !Empty(cCTpFrete) .And. _lChange
			cCOD := Space(TamSx3("A1_TRANSP")[1])
			cCPO := Space(TamSx3("A4_NOME")  [1])
			
			IF SubStr(AllTrim(cCTpFrete),01,01)=='2'
	   			@ C(046),C(225) MSGET    oGetVAL   VAR cod_trp SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215  PIXEL F3("STR") VALID(DNYTRANSP(cod_trp, @come_transp, oOBJ1,@_nDnyVlFrt,@cCTpFrete,.F.,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V))
	   		Else
	   			@ C(046),C(225) MSGET    oGetVAL   VAR cod_trp SIZE C(026),C(009) OF oDlgFimCot COLORS 0, 16777215  PIXEL F3("SA4") VALID(DNYTRANSP(cod_trp, @come_transp, oOBJ1,@_nDnyVlFrt,@cCTpFrete,.F.,@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V))
	   		EndIF
	   		oGetVAL:Refresh()   	
	  	EndIF

		IF cCOD <> "      "
			DbSelectArea("SA4")
			DbSetOrder(1)
			If SA4->(DbSeek( xFilial("SA4") + cCOD ))
				cCPO := SA4->A4_NOME
				oOBJ1:Refresh() 
				 
				//Busca apenas informacoes da tela de busca F3
				_aTransp   := {}
				_nDnyVlFrt := 0
				IF SubStr(AllTrim(cCTpFrete),01,01) == '2'
					_aTransp   := u_DNY017(oOBJ1,.F.)
					IF (_nPos := ASCan(_aTransp, {|x|, x[2] == cCOD })) > 0
						_nDnyVlFrt := iIF(Type('_nNewVlFrt')<>'U',_nNewVlFrt,0)//_aTransp[_nPos][5]
					Else                  
						Alert("Transportadora não encontrada")
						lRet       := .F.                     						
						_nDnyVlFrt := 0
						cCOD       := Space(TamSx3("A1_TRANSP")[1])
						cCPO       := Space(TamSx3("A4_NOME")  [1])
					ENDIF
				EndIF
				//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
			Else
				Alert("Transportadora não encontrada")
				lRet := .F.
			Endif
		Else 
			cCPO       := ''
			_nDnyVlFrt := 0
			oOBJ1:Refresh()
		EndIF                                     
		
        //Calcula informacoes dos Dados Financeiro          
		//xValidFrt()		
		xValidFrt(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]))
		
		RestArea(aAreaSA4)
		RestArea(aArea)

	Return(lRet)
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYCONDPG ºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para checar o Codigo da condicao de pgto e carregar  º±?
±±?         ³a descricao em variavel de memoria                          º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
//Static Function DNYCONDPG(cCOD, cCPO, oOBJ1,_lAltSE4,_nAltSE4,oGetCnd,oSx5Bn,oBandei,oNSU,oAutoriz,cSx5Bn,cBandei,cNSU,cAutoriz)
Static Function DNYCONDPG(cCOD, cCPO, oOBJ1,_lAltSE4,_nAltSE4,oGetCnd, oDVenc1, oDVenc2, oDVenc3, oDVenc4,_cli)

		Local lRet		:= .T.

		Local aArea		:= GetArea()
		Local aAreaSE4	:= SE4->(GetArea())     
		Local aParcela  := {}
		Local nXi	    := 0   
		//Local cParCC	:= GetMv("ES_CONDPG",,"121/122/123/124/125/126")

		IF Empty(cCOD)
			Return(lRet)
		ENDIF        

		DbSelectArea("SE4")
		DbSetOrder(1)
		If SE4->(DbSeek( xFilial("SE4") + cCOD ))
	   		
	   		_CONPAGCLI  := POSICIONE("SA1",1,XFILIAL("SA1")+ALLTRIM(_cli)+ALLTRIM(coja_cli),"A1_COND") 	
		
		IF SE4->E4_CODIGO <> _CONPAGCLI .AND. !EMPTY(_CONPAGCLI)
			Alert("Condição de Pagamento não pode ser diferente do cadastro de cliente: " +_CONPAGCLI )
			lRet := .F.	
		EndIf                 
		
		
		if SE4->E4_TIPO <> '9'
		
			//Calculo de Parcela
			aParcela:=Condicao(_nTTotFim,cCOD,,DDATABASE,)
			For nXi:=1 To Len(aParcela)
				If nXi==1
					dDtProgr  := aParcela[nXi,1]
					nVlrProg1 := aParcela[nXi,2]
				//ElseIf nXi==2
				//	dDtProgr2 := aParcela[nXi,1]
				//	nVlrProg2 := aParcela[nXi,2]
				ElseIf nXi==Len(aParcela)
					dDtProgr3 := aParcela[nXi,1]
					nVlrProg3 := aParcela[nXi,2]
				//ElseIf nXi==4
				//	dDtProgr4 := aParcela[nXi,1]
				//	nVlrProg4 := aParcela[nXi,2]
				EndIf			
			Next nXi
		ENDIF			
			cCPO := SE4->E4_DESCRI
			
			nPreco := u_xDescFin(nPreco, SE4->E4_CODIGO)
		
			oOBJ1:Refresh()
			
			If SE4->E4_TIPO == '9'
				oDVenc1:lReadOnly:= .F. 
				oDVenc2:lReadOnly:= .F.
				oDVenc3:lReadOnly:= .F.
				oDVenc4:lReadOnly:= .F.
				oDVenc1:Refresh()
				oDVenc2:Refresh()
				oDVenc3:Refresh()
				oDVenc4:Refresh()
			EndIf
			
		Else	
			Alert("Condição de Pagamento não encontrada")
			lRet := .F.	
		EndIf                 
		/*
		If cCOD $ cParCC
			oSx5Bn:lReadOnly 	:= .F.
			oNSU:lReadOnly 		:= .F.
			oAutoriz:lReadOnly 	:= .F. 
			oSx5Bn:Refresh()
			oBandei:Refresh()
			oNSU:Refresh()  
			oAutoriz:Refresh()
		Else        
			cSx5Bn 		:= Space(2)
			cBandei		:= Space(15)
			cNSU		:= Space(15)
			cAutoriz	:= Space(15)
			oSx5Bn:lReadOnly 	:= .T.
			oNSU:lReadOnly 		:= .T.
			oAutoriz:lReadOnly 	:= .T. 
			oSx5Bn:Refresh()
			oBandei:Refresh()
			oNSU:Refresh()  
			oAutoriz:Refresh()
		EndIf*/

		RestArea(aAreaSE4)
		RestArea(aArea)

Return lRet



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³IVENA020 ºAutor  ³Microsiga           ?Data ? 06/27/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ? GRAVA ALTERACAO DOS DADOS DO CADASTRO DO CLIENTE.         º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	Static Function FALTDADO(lProsp)

		Local aArea  := {}
		Local lSit	 := lProsp
		aArea := GetArea()

		If (Trim(cod_cli) != '' .AND. Trim(coja_cli) != '')
	
			If (MSGYesNo('Deseja realizar a Gravacao dos Dados Alterados?'))
				If lProsp
					If !Empty(SUS->US_CODCLI) .and. !Empty(SUS->US_LOJACLI)
						lSit := .F.     // Prospect Virou Cliente então gravo no Cliente, esqueço o SUS
					Endif
				Endif
		
				If !lSit         // Não ?Prospect OU o Prospect ?Cliente, gravo no SA1
					DBSelectArea('SA1')
					SA1->(DBSetOrder(1))
					If SA1->(DBSeek(XFilial('SA1')+CValToChar(cod_cli)+CValtoChar(coja_cli)))
				
						RecLock('SA1',.F.)
				
						SA1->A1_TRANSP  := cod_trp
						SA1->A1_TEL     :=  cone_1 //cone_1
						//SA1->A1_TEL2    := cone_2
						SA1->A1_EMAIL   := cmail_nfe
						SA1->A1_OBSCO   := cObscob
						SA1->A1_OBSLO   := cObsLog
						SA1->A1_DDD     := cCliDDD
						SA1->A1_XEMAILC := cEmail
						SA1->A1_CONTATO := cContFone 
						If lProsp
							SA1->A1_VEND	:= cod_atend
							SA1->A1_CNAE	:= cod_ativ
							SA1->A1_NOME  	:= come_cli
							SA1->A1_EST		:= cest_fat
							SA1->A1_BCO1	:= cod_banco
							SA1->A1_CGC		:= cod_cnpj
							SA1->A1_FILIAL	:= xFilial("SA1")
							SA1->A1_COND	:= cod_fpg
							SA1->A1_INSCR	:= cod_IE
							SA1->A1_OBSFIN	:= cObsfin
							//SA1->A1_MARCA	:= cesc_marca
							//SA1->A1_MRCOML	:= cMrcComl
							//SA1->A1_GESTOR	:= cGestor
							//SA1->A1_DTVCONT	:= cig_contrato
						EndIf

						SA1->(MSUNLOCK())

						MsgInfo('Alteracoes Salvas com Sucesso!!')
					EndIf
				Else
			// ?Prospect - atualizo SUS
					RecLock('SUS',.F.)
					SUS->US_VEND	:= cod_atend
					SUS->US_CNAE  	:= cod_ativ
					SUS->US_NOME   	:= come_cli
					SUS->US_EST		:= cest_fat
					SUS->US_COD		:= cod_cli
					SUS->US_CONTRIB	:= cContrib
					SUS->US_DDD     := cCliDDD
					SUS->US_TEL		:= cone_1
					SUS->US_CGC		:= cod_cnpj
					SUS->US_INSCR	:= cod_IE
					SUS->US_VEND	:= cod_rep
					SUS->US_EMAIL	:= cmail_nfe
					SUS->(MSUNLOCK())
			
					MsgInfo('PROSPECT: Alteracoes Salvas com Sucesso!!')
			
				Endif
			Else
		
				MsgInfo('As Alteracoes ainda não foram Gravadas.')
		
			EndIf
	
		Else
	
			MsgAlert('Não e possivel alterar os dados do Cliente, pois nenhum Cliente foi selecionado.', 'Atencao!!')
	
		EndIf

		SA1->(DBCloseArea())

		RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³COCKFoldChºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para checar o tempo e verificar se h?atualização dasº±?
±±?         ³tabelas do Cockpit                                          º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºParametros?nFldAtu = Folder Selecionada                               º±?
±±?         ?nFldAnt = Folder Selecionada Anteriormente                 º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
	Static Function COCKFoldCh(nFldAtu, nFldAnt)
		Local dData		:= ""
		Local cHora		:= ""
		Local cDifHr	:= ""
		//Local cTpFreq	:= ""
		Local cInterval	:= ""

		If nFldAtu == 3
	
			dData		:= GETMV("MV_COCPITD")
			cHora		:= GETMV("MV_COCPITH")
			cDifHr		:= ElapTime( cHora+":00" , cHrUser+":00" )
	
			dbSelectArea("XX1")
			dbSetorder(2)
			xx1->( dbSeek( "000000" ) )
	//	xx1->( dbSeek( __cUserID ) )
	
	//	While XX1->(!EOF()) .and. XX1->XX1_USERID == __cUserID
			While XX1->(!EOF()) .and. XX1->XX1_USERID == "000000"
		
				If Alltrim( Upper( XX1->XX1_ROTINA ) ) == "U_SCHCOCKPIT()"
			
					cInterval := XX1->XX1_RECORR
					cInterval := substr( cInterval, At("Interval(", cInterval) + 9, 5)
			
					If dData > DToS(dDtUser) .or. ( dData >= DToS(dDtUser) .and. cHora > cHrUser .and. cDifHr > cInterval )
				
						MsgRun("Aguarde atualizando Metas...",,{|| u_DnyCockP(oFolder:aDialogs[nFldAtu]) } )
				
						dDtUser := dDatabase
						cHrUser := substr(Time(), 1, 5)
				
					Endif
			
					Exit
			
				Endif
		
				XX1->(dbSkip())
		
			End
	
		Endif
	Return .t.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DNYLIMPVARºAutor  ³Microsiga           ?Data ? 06/06/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Funcao para  limpar variaveis de memoria 					  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

Static Function DNYLIMPVAR(nTp, lContx)

		//Local bOldError := ""//ErrorBlock()
		
		//--Não volta para tela do TGV
		If IsInCallStack("U_IVENA010")
			lContx:= .F.
		EndIf	
		
		IF nTp <> 1
			//ErrorBlock( {|x| u_DnyTrtErro(x) } ) // muda code-block de erro
		ENDIF

		cod_cli        := Space(TamSX3("A1_COD")  [1])
		coja_cli       := "0001"	//Space(TamSX3("A1_LOJA") [1])
		come_cli       := Space(TamSX3("A1_NOME") [1])
		cTipCli        := Space(15)
		cCod_por       := Space(TamSX3("A1_COD") [1])
		cLoja_por      := Space(TamSX3("A1_LOJA") [1])
		cNome_por      := Space(TamSX3("A1_NOME") [1])
		cTipPor        := Space(15)
		cod_atend      := Space(TamSX3("A1_VEND") [1])
		come_atend     := Space(TamSX3("A3_NOME") [1])
		dDtUltCp       := Space(TamSX3("A1_ULTCOM") [1])
		dXdtrcad       := Space(TamSX3("A1_DTNASC") [1])
		cStatBl        := Space(17)
		cStatus        := Space(15)
		cod_cnpj       := Space(TamSX3("A1_CGC") [1])
		cod_IE         := Space(TamSX3("A1_INSCR") [1])
		cest_fat       := Space(TamSX3("A1_EST") [1])
		cer_icms       := Space(05)
		//cMrcComl       := Space(TamSX3("A1_MRCOML") [1])
		//cesc_marca     := Space(TamSX3("A1_MARCA") [1])
		cCidade        := Space(TamSX3("A1_MUN") [1])
		cContrib       := Space(TamSX3("A1_CONTRIB") [1])
		c_Pis          := Space(01)
		cCliDDD        := Space(TamSX3("A1_DDD") [1])
		cone_1         := Space(TamSX3("A1_TEL") [1])
		//cone_2         := Space(TamSX3("A1_TEL2") [1])
		cEmail         := Space(TamSX3("A1_XEMAILC") [1])
		cod_fpg        := Space(TamSx3("A1_COND")[1])
		ces_forma_pgto := Space(TamSx3("E4_DESCRI")[1])
		crz_medio      := Space(01)
		//cgto_especial  := Space(900)
		cod_rep        := Space(TamSx3("A1_VEND")[1])
		come_rep       := Space(TamSX3("A3_NOME") [1])
		cod_trp        := Space(TamSx3("A1_TRANSP")[1])
		come_transp    := Space(TamSx3("A4_NOME")[1])
		cod_Redesp     := Space(TamSx3("A1_TRANSP")[1])
		come_Redesp    := Space(TamSx3("A4_NOME")[1])
		cod_zona       := Space(01)
		cmail_nfe      := Space(TamSX3("A1_EMAIL") [1])
		cTraDDD        := Space(TamSX3("A4_DDD") [1])
		cTraFone       := Space(TamSX3("A4_TEL") [1])
		cObsfin        := Space(900)
		cObslog        := Space(900)
		cObscob        := Space(900)
		cCodTab        := SUPERGETMV("HL_ZRTABELA" , .T., "   ",)
		cCodTabAnt     := SUPERGETMV("HL_ZRTABELA" , .T., "   ",)
		cCTpFrete	   := ''
		dAgenda		   := CToD("//")

// Resumo de Cliente
		nLCrdT         := 0.00
		nLCrd          := 0.00
		nVMargem       := 0.00
		nVMarInd       := 0.00
		nVatrazo       := 0.00
		nVMaior        := 0.00
		nVQuant        := 0
		nVSupre        := 0.00
		nQSupre        := 0.00
		nHSupre        := 0.00
		nVEssen        := 0.00
		nQEssen        := 0.00
		nHEssen        := 0.00
		nFat12m        := 0.00

// Orcamento
		nDescT	:=	0
		//lGravou := .F.
		nVDesc		   := 0
		nTotalPV	   := 0
		gCod_produto   := Space(TamSX3("B1_COD") [1])
		cM             := Space(TamSX3("B1_UM")  [1])
		creco_1        := 0.00
		creco_2        := 0.00
//		cCodCA         := Space(TamSX3("B1_CA")  [1])
		cerc_icm       := Space(TamSX3("B1_PICM")[1])
		cerc_ipi       := Space(TamSX3("B1_IPI") [1])
		nQtde          := 0.00
		nPreco         := 0.00
		nTotItem       := 0.00
		cPedxCli       := Space(TamSX3("C6_NUMPCOM") [1])
		cPedxIte       := Space(TamSX3("C6_ITEMPC") [1])
		cesc_nfe       := Space(TamSX3("B1_DESC")[1])
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
		cesc_comercial := Space(TamSX3("A1_NOME")[1])
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>
		cum_orc        := Space(TamSX3("C5_NUM") [1])

		dDtProgr	:= CTOD("  /  /  ")
		dDtProgr2	:= CTOD("  /  /  ")
		dDtProgr3	:= CTOD("  /  /  ")
		dDtProgr4	:= CTOD("  /  /  ")
		
		nVlrProg1:= 0
		nVlrProg2:= 0
		nVlrProg3:= 0
		nVlrProg4:= 0

		cCTpOper	:= CTBCBOX("UA_XTOPER")[01]
		cod_fpg	:= Space(TamSx3("A1_COND")[1])
		_cCod_EndE := Space(4)
		_nDnyVlFrt	:= 0
		nDespesa	:= 0
		nDescTota   := 0
		cobsexp:= Space(900)
		_nPrvFrt	:= 0

// chegada
		aFldCHE	 := {"C7_NUM", "C7_QUANT", "C7_EMISSAO", "C7_DATPRF"}
		aColsCHE := {}
		aHeadCHE := {}
		aFldACHE := {}
		aFldFCHE := {}

// Comprados
		aColsFat := {}
		aHeadFat := {}
		aFldAFat := {}
		aFldFat	 := {"D2_COD", "A7_CODCLI", "D2_EMISSAO", "D2_QUANT", "D2_PRCVEN", "D2_TOTAL", "D2_DOC"}
		aFldFFat := {}

// Nao Comrpados
		aFldQNC  := {"D2_EMISSAO", "D2_COD", "D2_QUANT", "D2_TOTAL", "D2_DOC", "C5_PEDCLI"}
		aColsQNC := {}
		aHeadQNC := {}
		aFldAQNC := {}
		aFldFQNC := {}

// Pedidos
		aFldxPED  := {"C5_NUM", "C5_EMISSAO", "C5_PEDCLI", "C6_NOTA", "C6_DATFAT", "C5_ESPECI1", "C5_XDESST"}
		aColsxPED := {}
		aHeadxPED := {}
		aFldAxPED := {}
		aFldFxPED := {}

// Itens pedido
		aFldIPED  := {"C6_PRODUTO", "D2_QUANT", "D2_PRCVEN", "D2_TOTAL", "C6_QTDVEN", "C6_QTDLIB"}
		aColsIPED := {}
		aHeadIPED := {}
		aFldAIPED := {}
		aFldFIPED := {}

// Itens NF
		aFldIFAT := {"F2_DOC", "F2_EMISSAO", "D2_COD", "D2_QUANT", "D2_TOTAL"}
		aColsIFAT:= {}
		aHeadIFAT:= {}
		aFldAIFAT:= {}
		aFldFIFAT:= {}

// Faturas
		aFldFAT := {"F2_DOC", "F2_EMISSAO", "F2_VALFAT", "D2_PEDIDO", "A3_NOME", "A4_NOME"}
		aColsFAT:= {}
		aHeadFAT:= {}
		aFldAFAT:= {}
		aFldFFAT:= {}

// Itens pedidos
        // Renato Bandeira em 20/02/15 - Novo campo contendo Local do Cliente
		//aFldPEDI := {"C6_ENTREG", "C6_NUM", "C6_CLI", "C6_LOJA", "A1_NREDUZ","Z04_DESC","C6_QTDVEN","C6_QTDENT","C6_QTDLIB"}
		aFldPEDI := {"C6_ENTREG", "C6_NUM", "C6_CLI", "C6_LOJA", "A1_NREDUZ","Z04_DESC","C6_QTDVEN","C6_QTDENT","C6_QTDLIB"}
		aColsPEDI:= {}
		aHeadPEDI:= {}
		aFldAPEDI:= {}
		aFldFPEDI:= {}

// Orcamento
		__aHeaderEx  := {}
		__aColsEx    := {}
		aFieldFill   := {}
		//aFields      := {"UB_ITEM", "UB_PRODUTO", "UB_DESCRI", "UB_QUANT", "UB_VRUNIT", "UB_VLRITEM", "UB_XPED", "UB_XPEDIT"}
		//aFields      := {"UB_ITEM", "UB_PRODUTO", "UB_DESCRI", "UB_QUANT", "UB_VRUNIT", "UB_VLRITEM", "UB_XPED", "UB_XPEDIT","D2_VALICM","D2_ICMSRET","D2_VALIPI","D2_VALINS","D2_VALCOF","D2_VALCSL","D2_VALPIS","D2_VALBRUT"}
		// Renato Bandeira em 30/10/14 - Novao campo
		aFields      := {"UB_ITEM", "UB_PRODUTO", "UB_DESCRI", "UB_QUANT", "UB_VRUNIT", "UB_VLRITEM", "UB_DESC", "UB_XPED", "UB_XPEDIT","D2_VALICM","D2_ICMSRET","D2_VALIPI","D2_VALINS","D2_VALCOF","D2_VALCSL","D2_VALPIS","D2_VALBRUT","UB_PRCTAB","UB_XCOMIS","D2_BASEICM","UB_ZPRCDIG"}
		aAlterFields := {"UB_QUANT", "UB_VRUNIT", "UB_XPED", "UB_XPEDIT"}

		//Campo margem por item
		if __cUSERID $ SUPERGETMV("IN_VISMARG" , .T., "000000",)
			aadd(aFields,"C6_ZMARGPP")
		endif

// Estoque
		__aColsEst  := {}
		__aHeadEst  := {}
		aFldAEst    := {"B2_COD"}
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
		aFldEst	    := {"B2_COD", "B2_QATU", "B2_QPEDVEN", "B2_RESERVA", "B2_QEMP"}                                                                                     
		//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>		
		aFldFest    := {}

// Compras ultimos 12 meses
		aHeade12m := {}
		aFldA12m  := {"F2_VALMERC"}
		aCols12m  := {}

// Historicos de cliente
		aHeadHist := {}
		aFldHist  := {"ZB_DTHIST","ZB_HORA","ZC_DESCRIC","ZB_USER","ZB_CONTATO","ZB_DTAGEN","ZB_FORMA","A3_NOME","ZB_CELULA"}
		aColsHist := {}

// Contatos do cliente
		aHeadCont := {}
		aFldCont  := {"U5_CODCONT","U5_CONTAT","U5_EMAIL","U5_DDD","U5_FONE","U5_CELULAR","U5_FAX","U5_FCOM1","U5_FCOM2","QB_DESCRIC","UM_DESC"}
		aColsCont := {}
		//--Limpa Array
		oPromocoes:= Nil
		oComissao := Nil
		aColsComis:={}
		dVenc1 := CTOD("  /  /  ")
		dVenc2 := CTOD("  /  /  ")
		dVenc3 := CTOD("  /  /  ")
		dVenc4 := CTOD("  /  /  ")
		nParc1 := 0
		nParc2 := 0
		nParc3 := 0
		nParc4 := 0
			
		IF nTp == 2            
			f_Estoque(@oFolder)
			f_Orcamento(oFolder)
		ENDIF

		IF nTp <> 1
			//ErrorBlock( {|E| CHECERRO(E)} )
		endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³IVENA020 ºAutor  ³Microsiga           ?Data ? 07/16/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

	Static Function DnyValPro()

	Return(.T.) //Mauro
/*
Local lRet := .F.
Local oGet1
Local oGet2
Local cCliente	:= GetSXENum("SA1", "A1_COD")
Local cLoja		:= StrZero(1,TamSx3("A1_LOJA")[1])
Local oDlgCli
Local cCliOri 	:= cCliente

If lProsp
DbSelectArea("SUS")
DbSetOrder(1)
If DbSeek(xFilial("SUS") + cod_cli + coja_cli )
If Empty(SUS->US_CODCLI)
If MsgYesNo("Deseja gravar dados do prospect para geração do cliente?")

DEFINE MSDIALOG oDlgCli TITLE "Prospect -> Cliente" FROM 100, 300  TO 200, 500 COLORS 0, 16777215 PIXEL

@ 005, 005 SAY oSay1   	PROMPT "Código"		SIZE 036, 007 	OF oDlgCli COLORS 0, 16777215 PIXEL
@ 020, 005 SAY oSay2	PROMPT "Loja"		SIZE 036, 007 	OF oDlgCli COLORS 0, 16777215 PIXEL

@ 004, 045 MSGET oGet1	VAR cCliente   		SIZE 040, 009 	OF oDlgCli COLORS 0, 16777215 F3 "SA1" PIXEL
@ 019, 045 MSGET oGet2 	VAR cLoja 	   		SIZE 040, 009 	OF oDlgCli COLORS 0, 16777215 PIXEL

@ 035, 005 BUTTON oButton1 PROMPT "OK" 		SIZE 050, 012 OF oDlgCli ACTION {lRet := U_DnyGerCli(cCliente,cLoja,cCliOri), oDlgCli:END()}		PIXEL									// "2" Orçamento
@ 035, 070 BUTTON oButton2 PROMPT "&Sair"	SIZE 050, 012 OF oDlgCli ACTION {lRet :=.F.,oDlgCli:END()} 	PIXEL

ACTIVATE MSDIALOG oDlgCli CENTERED

Else
Alert("Para geração do pedido deve-se concluir o cadastro do cliente!")
EndIf
EndIf
EndIf
Else
lRet := .T.
EndIf

Return(lRet)
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³IVENA020 ºAutor  ³Microsiga           ?Data ? 07/16/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

	User Function DnyGerCli(cCliente, cLoja, cCliOri)

	Return(.T.) //Bandeira em 07/10/13

		/*/
		Local lRet      := .F.
		Local cCodCel	:= ""
		Local aArea		:= GetArea()
		Local aAreaSA3	:= SA3->(GetArea())

		dbSelectArea("SA3")
		dbSetOrder(7)
		If SA3->(dbSeek(xFilial("SA3")+__cUserID))
			dbSelectArea("Z02")
			dbSetOrder(1)
			If Z02->(dbSeek(xFilial("Z02") + SA3->A3_COD))
				While Z02->(!EOF()) .and. xFilial("Z02") == Z02->Z02_FILIAL .and. Z02->Z02_PART == SA3->A3_COD
					If Z02->Z02_ATIVO == "S"
						cCodCel := Z02->Z02_COD
						Exit
					Endif
					Z02->(dbSKIP())
				End
			Endif
		Endif

		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1") + cCliente + cLoja )
			Alert("Cliente e/ou loja existente!")
		Else
			RecLock("SA1", .T.)
			SA1->A1_FILIAL	:= xFilial("SA1")
			SA1->A1_COD	:= cCliente
			SA1->A1_LOJA:= cLoja
			SA1->A1_TIPO:= SUS->US_TIPO
			SA1->A1_NREDUZ:= SUS->US_NREDUZ
			SA1->A1_DDI:= SUS->US_DDI
			SA1->A1_DDD:= SUS->US_DDD
			SA1->A1_CELULA := cCodCel
			SA1->A1_VEND := SUS->US_VEND
	
			SA1->(MsUnlock())
			lRet := .T.
		EndIf

		If cCliente == cCliOri
			If lRet
				ConfirmSX8()
				cod_cli := cCliente
				coja_cli:= cLoja
				oFolder:aDialogs[1]:Refresh()
			EndIf
		Else
			RollbackSX8()
		EndIf

		If lRet
			RecLock("SUS", .F.)
			SUS->US_CODCLI	:= cCliente
			SUS->US_LOJACLI	:= cLoja
			SUS->(MsUnlock())
	
			fAltDado(lProsp)
			u_IVENA040(lProsp,cCliente,cLoja)
			lRet := .T.
		EndIf

		RestArea(aAreaSA3)
		RestArea(aArea)

	Return(lRet)
		/*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³BUSCELUSR ºAutor  ³Microsiga           ?Data ? 07/16/12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

User Function BusCelUsr()

		Local aArea 		:= GetArea()
		Local aAreaSA3		:= SA3->(GetArea())
		Local cCondUsr		:= ""

		dbSelectArea("SA3")
		dbSetOrder(7)
		lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

		If lVendUSU //.and. SA3->A3_TPART == "R"
	
			dbSelectArea("Z02")
			dbSetOrder(1)
	
			If Z02->(dbSeek(xFilial("Z02") + SA3->A3_COD))
		
				While Z02->(!EOF()) .and. xFilial("Z02") == Z02->Z02_FILIAL .and. Z02->Z02_PART == SA3->A3_COD
			
					cCondUsr += Z02->Z02_COD + "/"
			
					Z02->(dbSKIP())
			
				End
		
			Endif
	
		Endif
		RestArea(aAreaSA3)
		RestArea(aArea)

	Return (cCondUsr)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ?  C()   ?Autores ?Norbert/Ernani/Mansano ?Data ?0/05/2005³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ?Funcao responsavel por manter o Layout independente da       ³±?
±±?          ?resolucao horizontal do Monitor do Usuario.                  ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
	Static Function C(nTam)
***********************
		Local nHRes	:=	oMainWnd:nClientWidth         // Resolucao horizontal do monitor

		If     nHRes == 640                           // Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
			nTam *= 0.8
		ElseIf (nHRes ==  798) .Or. (nHRes == 800)	      // Resolucao 800x600
			nTam *= 1
		ElseIf (nHRes == 1024) .OR. (nHRes == 969)    // Resolucao 1024x768 e acima
			nTam *= 0.74
		ElseIf (nHRes == 1309) .OR. (nHRes == 1311)
			nTam *= 1
		EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//³Tratamento para tema "Flat"?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		If "MP8" $ oApp:cVersion
			If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
				nTam *= 0.90
			EndIf
		EndIf
	Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyTrtErroºAutor  ³Microsiga           ?Data ? 11-30-12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

	User Function DnyTrtErro(x)

		oOrcamento := Nil
		//oOrcamento := MsNewGetDados():New( C(180), C(005), C(250), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
		//oOrcamento := MsNewGetDados():New( C(145), C(005), C(230), C(645), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
		//oOrcamento := MsNewGetDados():New( C(145), C(005), C(230), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
		oOrcamento := MsNewGetDados():New( C(135), C(005), C(220), C(335), GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeaderEx, __aColsEx)
		msgstop("IVENA020 ..::Erro " + x:Description + " ::.. " )
		Conout("IVENA020 ..::Erro " + x:Description + " ::.. " )

	Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³DnyTrtEst ºAutor  ³Microsiga           ?Data ? 11-30-12   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?                                                           º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                        º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/

	User Function DnyTrtEst(x)

		oEstoque := Nil
		//oEstoque := MsNewGetDados():New( C(075), C(005), C(135), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)
		//oEstoque := MsNewGetDados():New( C(075), C(005), C(115), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)
		oEstoque := MsNewGetDados():New( C(065), C(005), C(105), C(335), GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , aFldAEst,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], __aHeadEst, __aColsEst)
		Conout("IVENA020 ..::Erro " + x:Description + " ::.. " )

	Return
                    
//Funcao que valida se o Pedido de Compra do Cliente ja existe em algum orcamento

	Static Function VLDPEDCLI()
		Local lOK		:= .T.
		Local cAlias
		Local cQuery

//So valida se tiver preenchido. Vazio e permitido.

		if !Empty(AllTrim(cPedCli))
	
			cAlias	:= CriaTrab(Nil,.F.)
	
	//Verifica se ja existe amarracao Pedido Cliente x Orcamento
	
			cQuery := "SELECT UA_NUM FROM "+RETSQLNAME("SUA")+" WHERE D_E_L_E_T_ = '' AND UA_FILIAL = '"+xFilial("SUA")+"' AND "
			cQuery += "UA_NUM <> '"+AllTrim(cum_orc)+"' AND UA_PEDCLI = '"+AllTrim(cPedCli)+"' AND UA_CLIENTE = '"+AllTrim(cod_cli)+"' AND UA_LOJA = '"+Alltrim(coja_cli)+"'"
			TCQuery cQuery NEW ALIAS (cAlias)
	
			if !(cAlias)->(Eof())
				Aviso("Pedido j?existente","Este Pedido de Compra j?est?amarrado ao Orçamento "+AllTrim((cAlias)->UA_NUM)+" deste cliente/loja.",{"OK"})
				lOK := .F.
			EndIf
	
			(cAlias)->(dbCloseArea())
	
	//Verifica se ja existe amarracao Pedido Cliente x Pedido de Venda
	
			if lOK
				cQuery := "SELECT C5_NUM FROM "+RETSQLNAME("SC5")+" WHERE D_E_L_E_T_ = '' AND C5_FILIAL = '"+xFilial("SC5")+"' AND C5_CLIENTE = '"+AllTrim(cod_cli)+"' AND C5_LOJACLI = '"+Alltrim(coja_cli)+"' AND "
				cQuery += "C5_PEDCLI = '"+AllTrim(cPedCli)+"'"
				TCQuery cQuery NEW ALIAS (cAlias)
		
				if !(cAlias)->(Eof())
					Aviso("Pedido j?existente","Este Pedido de Compra j?est?amarrado ao Pedido de Venda "+AllTrim((cAlias)->C5_NUM)+" deste cliente/loja.",{"OK"})
					lOK := .F.
				EndIf
		
				(cAlias)->(dbCloseArea())
		
			EndIf
		EndIf

	Return(lOK)


	User Function ftransp()
***********************
		cCadastro := "Transportadora"

		aRotina   := {{ "Pesquisar " ,"AxPesqui"  , 0, 1},;
			{ "Visualizar" ,"AxVisual"  , 0, 2}}
  	       	                  	       
		DbSelectArea("SA4")
		DbSetOrder(1)

		MBrowse( 10,10,20,65,"SA4")

	Return


	User Function famarra()
***********************
		cCadastro := "Amarração Produto x Cliente"

		aRotina   := {{"Pesquisar " ,"AxPesqui", 0, 1},;
			{"Visualizar" ,"AxVisual", 0, 2},;
			{"Incluir"    ,"AxInclui", 0, 3},;
			{"Alterar"    ,"AxAltera", 0, 4},;
			{"Excluir"    ,"AxExclui", 0, 5}}
  	       	                  	       
		DbSelectArea("SA7")
		DbSetOrder(1)

		MBrowse( 10,10,20,65,"SA7")

	Return


	Static Function DnyHisInc(a,b,nTp)  // Incluir novo Historico 05/03/13
**********************************
		Local oSayHis01, oSayHis02, oSayHis03, oSayHis04, oSayHis05, oSayHis06, oSayHis07, oSayHis08, oSayHis09, oSayHis10, oDlgHInc
		Local oHisTit, oHisDes, oHisDth, oHisHor, oHisDta, oHisUsr, oHisRep, oHisRaz, oHisCon, oHisFor, oHisHis, oHisCel, oHisNce
		Local oHButton1, oHButton2
		Local cTitulo := SPACE(06)
		Local cDescric:= SPACE(40)
		Local dDtHist := dDatabase
		Local cHora   := Time()
		Local dDtAgen := ctod("//")
		Local cUser   := cUserName
		Local cRepres := SA1->A1_VEND
		Local cNomRep := Posicione("SA3",1,xFilial("SA3")+SA1->A1_VEND,"A3_NOME")
		Local cContato:= SPACE(30)
		Local cForma  := SPACE(30)
		Local cHistor := SPACE(900)
		//Local cCelula := SA1->A1_CELULA
		Local cCelula := ''
		//Local cNomCel := Posicione("Z01",1,xFilial("Z01")+SA1->A1_CELULA,"Z01_REGIA")
		Local cNomCel := ''
		Local nOpca   := 0
		Local nX

		IF nTp == 1
			IF len(alltrim(aColsHist[oGetHis:nAt][3])) == 0
				MsgAlert("Visualização não permitida, Historico inexistente!")
				Return
			EndIf
			chkFile('SZB')
			chkFile('SZC')
			DBSELECTAREA("SZB")
			DBSETORDER(1)
			DBSEEK(xFilial("SZB")+cod_cli+coja_cli+DTOS(aColsHist[oGetHis:nAt][1])+aColsHist[oGetHis:nAt][2])

			cTitulo  := SZB->ZB_TITULO
			cDescric := Posicione("SZC",1,xFilial("SZC")+SZB->ZB_TITULO,"ZC_DESCRIC")
			dDtHist  := SZB->ZB_DTHIST
			cHora    := SZB->ZB_HORA
			dDtAgen  := SZB->ZB_DTAGEN
			cUser    := SZB->ZB_USER
			cRepres  := SZB->ZB_RESPRES
			cNomRep  := Posicione("SA3",1,xFilial("SA3")+SZB->ZB_RESPRES,"A3_NOME")
			cContato := SZB->ZB_CONTATO
			cForma   := SZB->ZB_FORMA
			cHistor  := SZB->ZB_HISTOR
			cCelula  := SZB->ZB_CELULA
			//cNomCel  := Posicione("Z01",1,xFilial("Z01")+SA1->A1_CELULA,"Z01_REGIA")
		ENDIF

		DEFINE MSDIALOG oDlgHInc TITLE "Histórico" FROM C(000),C(000)  TO C(350),C(900) COLORS 0, 16777215 PIXEL

		@ C(007),C(005) SAY oSayHis01 PROMPT "Titulo:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

		@ C(022),C(005) SAY oSayHis02 PROMPT "Data Histórico:"           SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
		@ C(022),C(200) SAY oSayHis03 PROMPT "Hora:"                     SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
		@ C(022),C(320) SAY oSayHis04 PROMPT "Usuario:"                  SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

		@ C(037),C(005) SAY oSayHis05 PROMPT "Data Agendamento:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
		@ C(037),C(200) SAY oSayHis06 PROMPT "Representante:"            SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

		@ C(052),C(005) SAY oSayHis07 PROMPT "Contato Empresa:"          SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
		@ C(052),C(200) SAY oSayHis08 PROMPT "Forma de Contato:"         SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

		@ C(067),C(005) SAY oSayHis09 PROMPT "Histórico"                 SIZE C(105),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL
		@ C(067),C(200) SAY oSayHis10 PROMPT "Celula:"                   SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL

		@ C(007),C(055) MSGET oHisTit  VAR cTitulo  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SZC" VALID VldTit(cTitulo,@cDescric) WHEN IIF(nTp==1,.F.,.T.)
		@ C(007),C(100) MSGET oHisDes  VAR cDescric                      SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

		@ C(022),C(055) MSGET oHisDth  VAR dDtHist  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
		@ C(022),C(250) MSGET oHisHor  VAR cHora    PICTURE '99:99'      SIZE C(030),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.
		@ C(022),C(360) MSGET oHisUsr  VAR cUser    PICTURE '@!'         SIZE C(085),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

		@ C(037),C(055) MSGET oHisDta  VAR dDtAgen  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL //VALID (dDtAgen<>CTOD("//")) WHEN IIF(nTp==1,.F.,.T.)
		@ C(037),C(250) MSGET oHisRep  VAR cRepres  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "SA3" VALID VldRep(cRepres,@cNomRep)  WHEN .F.
		@ C(037),C(295) MSGET oHisRaz  VAR cNomRep  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

		@ C(052),C(055) MSGET oHisCon  VAR cContato PICTURE '@!'         SIZE C(140),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN IIF(nTp==1,.F.,.T.)
		@ C(052),C(250) MSGET oHisFor  VAR cForma   PICTURE '@!'         SIZE C(195),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN IIF(nTp==1,.F.,.T.)

		@ C(067),C(250) MSGET oHisCel  VAR cCelula  PICTURE '@!'         SIZE C(035),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL F3 "Z01" WHEN .F.
		@ C(067),C(295) MSGET oHisNCe  VAR cNomCel  PICTURE '@!'         SIZE C(150),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL          WHEN .F.

		@ C(080),C(005) GET   oHisHis  VAR cHistor MEMO 	             SIZE C(440),C(063) OF oDlgHInc COLORS 0, 16777215 PIXEL          //WHEN IIF(nTp==1,.F.,.T.)

		IF nTp == 2
			@ C(147),C(280) BUTTON oHButton1 PROMPT "&Confirma"           SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=1,oDlgHInc:End()) PIXEL
		ENDIF
		@ C(147),C(360)    BUTTON oHButton2 PROMPT "&Sair"               SIZE C(062),C(018) OF oDlgHInc ACTION (nOpca:=0,oDlgHInc:End()) PIXEL

		ACTIVATE MSDIALOG oDlgHInc CENTERED

		IF nOpca == 1          
			
			RecLock("SZB",.T.)
			SZB->ZB_FILIAL  := xFilial("SZB")
			SZB->ZB_CLIENTE := cod_cli
			SZB->ZB_LOJA    := coja_cli
			SZB->ZB_TITULO  := cTitulo
			SZB->ZB_DTHIST  := dDtHist
			SZB->ZB_HORA    := cHora
			SZB->ZB_DTAGEN  := dDtAgen
			SZB->ZB_USER    := cUser
			SZB->ZB_RESPRES := cRepres
			SZB->ZB_CONTATO := cContato
			SZB->ZB_FORMA   := cForma
			SZB->ZB_HISTOR  := cHistor
			SZB->ZB_CELULA  := cCelula
			MsUnLock()


			aHeadHist := {}
			aFldHist  := {"ZB_DTHIST","ZB_HORA","ZC_DESCRIC","ZB_USER","ZB_CONTATO","ZB_DTAGEN","ZB_FORMA","A3_NOME","ZB_CELULA"}
			aColsHist := {}

			cQuery := " SELECT SZB.ZB_DTHIST, SZB.ZB_HORA, SZC.ZC_DESCRIC, SZB.ZB_USER, SZB.ZB_CONTATO, SZB.ZB_DTAGEN, SZB.ZB_FORMA, ISNULL(SA3.A3_NOME,'') A3_NOME, SZB.ZB_CELULA "
			cQuery += " FROM "+RetSqlName('SZB') + " SZB "
   			cQuery += " INNER JOIN "+RetSqlName('SZC') + " SZC ON   SZC.ZC_FILIAL  = '" + xFilial("SZC") + "' AND   SZC.ZC_CODIGO  = SZB.ZB_TITULO AND   SZC.D_E_L_E_T_ <> '*' "
	 		cQuery += " LEFT JOIN "+RetSqlName('SA3') + " SA3  ON    SA3.A3_FILIAL  = '" + xFilial("SA3") + "' AND   SA3.A3_COD  = SZB.ZB_RESPRES  AND   SA3.D_E_L_E_T_ <> '*' "	
			cQuery += " WHERE SZB.ZB_FILIAL  = '" + xFilial("SZB") + "' "
			cQuery += " AND   SZB.ZB_CLIENTE = '" + Cod_Cli + "' "
			cQuery += " AND   SZB.ZB_LOJA    = '" + coja_Cli + "' "
   
			cQuery += " AND   SZB.D_E_L_E_T_ <> '*' "
			cQuery += " ORDER BY ZB_DTHIST+ZB_HORA DESC "
	
			
			If Select("TRB") > 0
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf

			TCQuery cQuery new Alias "TRB"
			TCSetField("TRB", "ZB_DTHIST","D",08,0)
			TCSetField("TRB", "ZB_DTAGEN","D",08,0)

			DbSelectArea("SX3")
			DbSetOrder(2)
			For nX := 1 to Len(aFldHist)
				If SX3->(DbSeek(aFldHist[nX]))

					cPict := SX3->X3_PICTURE

					cX3Tit:= AllTrim(X3Titulo())

					IF     Alltrim(SX3->X3_CAMPO) == "ZC_DESCRIC"
						cX3Tit := "Titulo"
					ElseIf Alltrim(SX3->X3_CAMPO) == "A3_NOME"
						cX3Tit := "Nome Repres."
					Endif

					Aadd(aHeadHist, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
						SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
				Endif
			Next nX

			SELECT TRB
			DBGOTOP()
			WHILE !EOF()

				AADD(aColsHist,Array(Len(aHeadHist)+1))
				aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.

				aColsHist[Len(aColsHist), GdFieldPos("ZB_DTHIST", aHeadHist)] := TRB->ZB_DTHIST
				aColsHist[Len(aColsHist), GdFieldPos("ZB_HORA",   aHeadHist)] := TRB->ZB_HORA
				aColsHist[Len(aColsHist), GdFieldPos("ZC_DESCRIC",aHeadHist)] := TRB->ZC_DESCRIC
				aColsHist[Len(aColsHist), GdFieldPos("ZB_USER",   aHeadHist)] := TRB->ZB_USER
				aColsHist[Len(aColsHist), GdFieldPos("ZB_CONTATO",aHeadHist)] := TRB->ZB_CONTATO
				aColsHist[Len(aColsHist), GdFieldPos("ZB_DTAGEN", aHeadHist)] := TRB->ZB_DTAGEN
				aColsHist[Len(aColsHist), GdFieldPos("ZB_FORMA",  aHeadHist)] := TRB->ZB_FORMA
				aColsHist[Len(aColsHist), GdFieldPos("A3_NOME",   aHeadHist)] := TRB->A3_NOME
				aColsHist[Len(aColsHist), GdFieldPos("ZB_CELULA", aHeadHist)] := TRB->ZB_CELULA
				DBSKIP()
			END

			AADD(aColsHist,Array(Len(aHeadHist)+1))
			aColsHist[Len(aColsHist)][Len(aHeadHist)+1] := .F.

			oGetHis:SetArray(aColsHist)
			oGetHis:oBrowse:Refresh()
			oFolder:aDialogs[4]:Refresh()
		ENDIF

Return

	Static Function VldTit(cTitulo,cDescric)
*****************************************
		cDescric := SPACE(40)

		SELECT SZC
		DBSETORDER(1)
		DBSEEK(xFilial("SZC")+cTitulo)
		IF cTitulo <> SPACE(6)
			IF EOF()
				MsgAlert("Titulo não Cadastrado!")
			Return .F.
			ELSE
				cDescric := SZC->ZC_DESCRIC
			Return .T.
			ENDIF
		ENDIF
	Return

	Static Function VldRep(cRepres,cNomRep)
*****************************************
		cNomRep := SPACE(40)

		SELECT SA3
		DBSETORDER(1)
		DBSEEK(xFilial("SA3")+cRepres)
		IF cRepres <> SPACE(6)
			IF EOF()
				MsgAlert("Representante não Cadastrado!")
			Return .F.
			ELSE
				cNomRep := SA3->A3_NOME
			Return .T.
			ENDIF
		ENDIF
	Return

	Static Function DnyConMnt(a,b,nTp)  // Incluir novo Contato 07/05/13
**********************************
	Local nX
		INCLUI   := .T.
		ALTERA   := .T.

		IF nTp == 1

			nOpca1 := A70INCLUI("SU5",,3)

			IF nOpca1 == 1
				RecLock("AC8", .T.)
				AC8->AC8_FILIAL := xFilial("AC8")
				AC8->AC8_ENTIDA := "SA1"
				AC8->AC8_CODENT := cod_cli+coja_cli
				AC8->AC8_CODCON := SU5->U5_CODCONT
				MsUnlock()
			Endif
		ELSE

			IF ALLTRIM(aColsCont[oGetCon:nAt][1]) == ""
				MsgAlert("Alteração não permitida, Contato Inexistente!")
			Return
			ENDIF

			DBSELECTAREA("SU5")
			DBSETORDER(1)
			DBSEEK(xFilial("SU5")+aColsCont[oGetCon:nAt][1])

			nOpca1 := A70Altera("SU5",,4)

		ENDIF

		aHeadCont := {}
		aFldCont  := {"U5_CODCONT","U5_CONTAT","U5_EMAIL","U5_DDD","U5_FONE","U5_CELULAR","U5_FAX","U5_FCOM1","U5_FCOM2","QB_DESCRIC","UM_DESC"}
		aColsCont := {}

		cQuery := " SELECT SU5.U5_CODCONT, SU5.U5_CONTAT, SU5.U5_EMAIL, SU5.U5_DDD, SU5.U5_FONE, SU5.U5_CELULAR, SU5.U5_FAX, SU5.U5_FCOM1, SU5.U5_FCOM2, "
		cQuery += "        SQB.QB_DESCRIC, SUM.UM_DESC "
		cQuery += " FROM "+RetSqlName('AC8')+" AC8, "+RetSqlName('SU5')+" SU5 "
		cQuery += " LEFT JOIN "+RetSqlName('SQB')+" SQB (NOLOCK) ON SQB.QB_DEPTO = SU5.U5_DEPTO "
		cQuery += " LEFT JOIN "+RetSqlName('SUM')+" SUM (NOLOCK) ON SUM.UM_CARGO = SU5.U5_FUNCAO "
		cQuery += " WHERE AC8.AC8_FILIAL = '"+xFilial("AC8")+"' "
		cQuery += " AND   AC8.AC8_CODENT = '"+Cod_cli+coja_cli+"' "
		cQuery += " AND   AC8.D_E_L_E_T_ <> '*' "
		cQuery += " AND   SU5.U5_FILIAL  = '"+xFilial("SU5")+"' "
		cQuery += " AND   SU5.U5_CODCONT = AC8.AC8_CODCON "
		cQuery += " AND   SU5.D_E_L_E_T_ <> '*' "

		If Select("TRB") > 0
			dbSelectArea("TRB")
			dbCloseArea()
		EndIf

		TCQuery cQuery new Alias "TRB"

		DbSelectArea("SX3")
		DbSetOrder(2)
		For nX := 1 to Len(aFldCont)
			If SX3->(DbSeek(aFldCont[nX]))

				cPict := SX3->X3_PICTURE

				cX3Tit:= AllTrim(X3Titulo())

				IF     Alltrim(SX3->X3_CAMPO) == "QB_DESCRIC"
					cX3Tit := "Departamento"
				ElseIf Alltrim(SX3->X3_CAMPO) == "UM_DESC"
					cX3Tit := "Função"
				Endif

				Aadd(aHeadCont, {cX3Tit,SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
			Endif
		Next nX

		SELECT TRB
		DBGOTOP()
		WHILE !EOF()

			AADD(aColsCont,Array(Len(aHeadCont)+1))
			aColsCont[Len(aColsCont)][Len(aHeadCont)+1] := .F.

			aColsCont[Len(aColsCont), GdFieldPos("U5_CODCONT",aHeadCont)]	:= TRB->U5_CODCONT
			aColsCont[Len(aColsCont), GdFieldPos("U5_CONTAT", aHeadCont)]	:= TRB->U5_CONTAT
			aColsCont[Len(aColsCont), GdFieldPos("U5_EMAIL",  aHeadCont)]	:= TRB->U5_EMAIL
			aColsCont[Len(aColsCont), GdFieldPos("U5_DDD",    aHeadCont)]	:= TRB->U5_DDD
			aColsCont[Len(aColsCont), GdFieldPos("U5_FONE",   aHeadCont)]	:= TRB->U5_FONE
			aColsCont[Len(aColsCont), GdFieldPos("U5_CELULAR",aHeadCont)]	:= TRB->U5_CELULAR
			aColsCont[Len(aColsCont), GdFieldPos("U5_FAX",    aHeadCont)]	:= TRB->U5_FAX
			aColsCont[Len(aColsCont), GdFieldPos("U5_FCOM1",  aHeadCont)]	:= TRB->U5_FCOM1
			aColsCont[Len(aColsCont), GdFieldPos("U5_FCOM2",  aHeadCont)]	:= TRB->U5_FCOM2
			aColsCont[Len(aColsCont), GdFieldPos("QB_DESCRIC",aHeadCont)]	:= TRB->QB_DESCRIC
			aColsCont[Len(aColsCont), GdFieldPos("UM_DESC",   aHeadCont)]	:= TRB->UM_DESC
			DBSKIP()
		END

		AADD(aColsCont,Array(Len(aHeadCont)+1))
		aColsCont[Len(aColsCont)][Len(aHeadCont)+1] := .F.

		oGetCon:SetArray(aColsCont)
		oGetCon:oBrowse:Refresh()
		oFolder:aDialogs[5]:Refresh()

	Return


//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
*-----------------------------------------*
Static Function f_Lote(oDlgVendas, oFolder)
*-----------------------------------------*
Local oPanel
Local cQuery := ""
Local cEOL	 := chr(10)+chr(13)
Local lCria
Local cPrdAux:= oOrcamento:aCols[oOrcamento:nAt, GdFieldPos("UB_PRODUTO" ,__aHeaderEx)]
Local nX, __xnElem

//Atualiza Folder 03
xRshFol3(@oDlgVendas, @oFolder)

aFldFAT := {"B8_LOCAL", "B8_LOTECTL", "B8_DTVALID", "B8_SALDO", "B8_EMPENHO", "C6_QTDVEN"}
aColsFAT:= {}
aHeadFAT:= {}
aFldAFAT:= {}
aFldFFAT:= {}

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFldFAT)
	If SX3->(DbSeek(aFldFAT[nX]))
	
		cTitCp := AllTrim(X3Titulo())
		If Alltrim(SX3->X3_CAMPO) == "C6_QTDVEN"
				cTitCp := "Saldo Disponível"
		Endif
		
		cPict := SX3->X3_PICTURE

		Aadd(aHeadFAT, {AllTrim(cTitCp),SX3->X3_CAMPO,cPict,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

For nX := 1 to Len(aFldFAT)
	If DbSeek(aFldFAT[nX])
		Aadd(aFldFFAT, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX

Aadd(aFldFFAT, .F.)
Aadd(aColsFAT, aFldFFAT)

If !lProsp
	If Len(aColsFAT) > 1 .OR. !Empty(aColsFAT[1,1] )
		aColsFAT := {}
		AADD(aColsFAT,Array(Len(aHeadFAT)+1))
		aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
	EndIf
    
    
    If len(oOrcamento:aCols) >= 1	//0
	For __xnElem := 1 to len(oOrcamento:aCols)
		If !(oOrcamento:aCols[__xnElem][Len(__aHeaderEx)+1]) .And. ALLTRIM(oOrcamento:aCols[__xnElem][GdFieldPos("UB_PRODUTO", __aHeaderEx)]) == ALLTRIM(gCod_produto)
			cPrdAux:=gCod_produto
		EndIf
	Next
    ELSE
    	cPrdAux:=gCod_produto
    ENDIF
    
    
    if empty(cPrdAux) 
    	cPrdAux:=gCod_produto
    ENDIF
    	

	cQuery := " SELECT B8_LOCAL xLOCAL, B8_LOTECTL LOTECTL, B8_DTVALID DTVALID, B8_SALDO SALDO, B8_EMPENHO EMPENHO, (B8_SALDO-B8_EMPENHO) SALDO_ATU  "+cEOL
	cQuery += "   FROM "+ RetSqlName('SB8') +" SB8 "+cEOL
	cQuery += "     WHERE SB8.D_E_L_E_T_ <> '*' "+cEOL
	cQuery += "       AND B8_SALDO  > 0  "+cEOL
	cQuery += "       AND B8_FILIAL  = '"+ xFilial('SB8') +"'"+cEOL
	//cQuery += "       AND B8_PRODUTO = '"+ SB1->B1_COD +"' "+cEOL
	// Renato Bandeira em 23/4/14 - Usar a variavel private com o produto digitado
	cQuery += "       AND B8_PRODUTO = '"+ cPrdAux +"' "+cEOL
	cQuery += " ORDER BY B8_LOCAL, B8_DTVALID "
	
	If Select("LOT") > 0
	dbSelectArea("LOT")
		LOT->(dbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "LOT"
	TCSetField("LOT", "DTVALID"  , "D",08,0)
	TCSetField("LOT", "SALDO"    , "N",12,2)
	TCSetField("LOT", "EMPENHO"  , "N",12,2)
	TCSetField("LOT", "SALDO_ATU", "N",12,2)
	

	DbSelectArea("LOT")
	While !LOT->(Eof())
		
		If Len(aColsFAT) == 1 .AND. Empty(aColsFAT[Len(aColsFAT),GdFieldPos("B8_LOCAL", aHeadFAT)] )
			lCria := .F.
		Else
			lCria := .T.
		EndIf
		
		If lCria
			AADD(aColsFAT,Array(Len(aHeadFAT)+1))
			aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
		EndIf
		
		aColsFAT[Len(aColsFAT), GdFieldPos("B8_LOCAL",  aHeadFAT)]	:= LOT->xLOCAL
		aColsFAT[Len(aColsFAT), GdFieldPos("B8_LOTECTL",aHeadFAT)]	:= LOT->LOTECTL
		aColsFAT[Len(aColsFAT), GdFieldPos("B8_DTVALID",aHeadFAT)]	:= LOT->DTVALID
		aColsFAT[Len(aColsFAT), GdFieldPos("B8_SALDO", 	aHeadFAT)]	:= LOT->SALDO
		aColsFAT[Len(aColsFAT), GdFieldPos("B8_EMPENHO",aHeadFAT)]	:= LOT->EMPENHO
		aColsFAT[Len(aColsFAT), GdFieldPos("C6_QTDVEN",	aHeadFAT)]	:= LOT->SALDO_ATU
		
		//_aRST := SldPorLote(SB1->B1_COD, LOT->xLOCAL,1,,LOT->LOTECTL)
		//_nSl := SldAtuEst(SB1->B1_COD,LOT->xLOCAL,1,LOT->LOTECTL)
		
		LOT->(DbSkip())
	End
Else
	aColsFAT := {}
	AADD(aColsFAT,Array(Len(aHeadFAT)+1))
	aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
Endif

@ C(003),C(340) MSPANEL oPanel PROMPT "Lotes" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
//oObjLote := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
//oObjLote := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
//oObjLote := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
oObjLote := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)

Return
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
*-----------------------------------------*
Static Function f_Similar(oDlgVendas, oFolder)
*-----------------------------------------*
Local oPanel
Local cQuery := ""
Local cEOL	 := chr(10)+chr(13)
Local lCria
//Local _cCodSim := ''  
Local nTam := 0
Local cPrdAux:= oOrcamento:aCols[oOrcamento:nAt, GdFieldPos("UB_PRODUTO" ,__aHeaderEx)]
Local nX
//Atualiza Folder 03
xRshFol3(@oDlgVendas, @oFolder)

aFldFAT := {"B1_COD", "B1_DESC", "B2_QATU" }
aColsFAT:= {}
aHeadFAT:= {}
aFldAFAT:= {}
aFldFFAT:= {}

//Aadd(aHeadFAT, {'TIPO', 'ZNTIPO', '@!' , 12, 0, '', USADO, 'C', 'SB1', ''}) 

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFldFAT)
	If SX3->(DbSeek(aFldFAT[nX]))	
		cTitCp := AllTrim(X3Titulo())	
		cPict  := SX3->X3_PICTURE   
		If ALLTRIM(SX3->X3_CAMPO)=="B1_DESC"
			nTam   := 50
		ElseIf ALLTRIM(SX3->X3_CAMPO)=="B1_COD"
			nTam   := 06
		Else
			nTam   := SX3->X3_TAMANHO
		EndIf

		Aadd(aHeadFAT, {AllTrim(cTitCp),SX3->X3_CAMPO,cPict,nTam,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

For nX := 1 to Len(aFldFAT)
	If DbSeek(aFldFAT[nX])
		Aadd(aFldFFAT, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX

//Aadd(aFldFFAT, .F.)
//Aadd(aColsFAT, aFldFFAT)

//If !lProsp
	//If Len(aColsFAT) > 1 .OR. !Empty(aColsFAT[1,1] )
	//	aColsFAT := {}
	//	AADD(aColsFAT,Array(Len(aHeadFAT)+1))
	//	aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
//	EndIf

//For _nSm:=1 To 1 //2 
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + cPrdAux)


		cQuery := " SELECT SB1.B1_CATEG CODCAT, ACU.ACU_DESC NOMCAT, SB1.B1_COD SIMILAR, SB1.B1_DESC DESCRICAO, SB2.B2_QATU ESTOQUE "+cEOL //, SZN.ZN_SIMILAR SIMILAR "+cEOL
		cQuery += "   FROM "+ RetSqlName('SB1') +" SB1  "+cEOL
		cQuery += "   INNER JOIN "+ RetSqlName('ACU') +" ACU ON ACU.D_E_L_E_T_ <> '*' AND ACU_FILIAL = '"+ xFilial('ACU') +"' AND ACU.ACU_COD=SB1.B1_CATEG "+cEOL
		cQuery += "   INNER JOIN "+ RetSqlName('SB2') +" SB2 ON SB2.D_E_L_E_T_ <> '*' AND SB2.B2_FILIAL  = '0501' AND SB2.B2_COD=SB1.B1_COD AND SB2.B2_LOCAL='01' "+cEOL
		cQuery += "     WHERE SB1.D_E_L_E_T_ <> '*'   "+cEOL
		cQuery += "      AND SB1.B1_FILIAL = '"+ xFilial('SB1') +"'  "+cEOL
		cQuery += "      AND SB1.B1_CATEG   = '"+ SB1->B1_CATEG +"'  "+cEOL
		cQuery += "      AND SB1.B1_POSIPI = '"+ SB1->B1_POSIPI +"'  "+cEOL		
		cQuery += "      AND SB1.B1_COD   <> '"+ SB1->B1_COD +"' "+cEOL		
/*	
		cQuery := " SELECT '___CATEGORIA___' TP_CAT, SB1.B1_CATE CODCAT, SZN.ZN_NOME NOMCAT, SZN.ZN_SIMILAR SIMILAR "+cEOL
		cQuery += "   FROM "+ RetSqlName('SB1') +" SB1  "+cEOL
		cQuery += "   INNER JOIN "+ RetSqlName('SZN') +" SZN ON SZN.D_E_L_E_T_ <> '*' AND ZN_FILIAL = '"+ xFilial('SZN') +"' AND SZN.ZN_COD=SB1.B1_CATE "+cEOL
		cQuery += "     WHERE SB1.D_E_L_E_T_ <> '*'   "+cEOL
		cQuery += "      AND SB1.B1_FILIAL = '"+ xFilial('SB1') +"'  "+cEOL
		cQuery += "      AND SB1.B1_COD    = '"+ SB1->B1_COD +"' "+cEOL
		IF _nSm == 2 .And. !Empty(_cCodSim)
			cQuery += " UNION ALL "+cEOL
			cQuery += " SELECT 'OFEREÇA' TP_CAT, SZN.ZN_COD CODCAT, SZN.ZN_NOME NOMCAT, SZN.ZN_SIMILAR SIMILAR "+cEOL
			cQuery += "   FROM "+ RetSqlName('SZN') +" SZN  "+cEOL
			cQuery += "     WHERE SZN.D_E_L_E_T_ <> '*'   "+cEOL
			cQuery += "      AND SZN.ZN_FILIAL  = '"+ xFilial('SZN') +"'  "+cEOL
			cQuery += "      AND SZN.ZN_COD    IN ("+ _cCodSim +") "+cEOL
			//cQuery += " ORDER BY TP_CAT, CODCAT "+cEOL
		EndIF
*/
		If Select("_SML") > 0
		dbSelectArea("_SML")
			_SML->(dbCloseArea())
		EndIf
		TcQuery cQuery New Alias "_SML"  

		DbSelectArea("_SML")
		
		IF Empty(_SML->CODCAT)
			Return
		EndIF
		
		While !_SML->(Eof())
		/*
			IF _nSm == 1
				_cOrSim := AllTrim(_SML->SIMILAR)
				
				For _nCont:=1 To Len(_cOrSim)
					IF At('/',_cOrSim) > 0
						_cCodSim += "'"+ SubStr(_cOrSim, 01, At('/',_cOrSim)-1) +"',"
						_cOrSim  := SubStr(_cOrSim, At('/',_cOrSim)+1, Len(_cOrSim))
					Else 
						_cCodSim += "'"+ SubStr(_cOrSim, 01, Len(_cOrSim)) +"',"
						_cOrSim  := ''
						Exit
					EndIF
					
				Next _nCont
				
				_cCodSim := SubStr(_cCodSim,01,Len(_cCodSim)-1)
		*/
			//Else
				If Len(aColsFAT) == 1 .AND. Empty(aColsFAT[Len(aColsFAT),GdFieldPos("B1_COD", aHeadFAT)] )       //"B1_COD", "B1_DESC", "B1_CATEG", "ACU_DESC"
					lCria := .F.
				Else
					lCria := .T.
				EndIf
				
				If lCria
					AADD(aColsFAT,Array(Len(aHeadFAT)+1))
					aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
				EndIf
				
				aColsFAT[Len(aColsFAT), GdFieldPos("B1_COD",    aHeadFAT)]	:= _SML->SIMILAR
				aColsFAT[Len(aColsFAT), GdFieldPos("B1_DESC",   aHeadFAT)]	:= _SML->DESCRICAO
				//aColsFAT[Len(aColsFAT), GdFieldPos("B1_CATEG",  aHeadFAT)]	:= _SML->CODCAT
				//aColsFAT[Len(aColsFAT), GdFieldPos("ACU_DESC", 	aHeadFAT)]	:= _SML->NOMCAT
				aColsFAT[Len(aColsFAT), GdFieldPos("B2_QATU", 	aHeadFAT)]	:= _SML->ESTOQUE				
			//EndIF	
			_SML->(DbSkip())
		EndDo
		
	//Next _nSm

//Else
//	aColsFAT := {}
//	AADD(aColsFAT,Array(Len(aHeadFAT)+1))
//	aColsFAT[Len(aColsFAT)][Len(aHeadFAT)+1] := .F.
//Endif
                                       
@ C(003),C(340) MSPANEL oPanel PROMPT "Produtos na Mesma Categoria" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
//oObjSim := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
//oObjSim := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
//oObjSim := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)
oObjSim := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_DELETE, "AllwaysTrue", "AllwaysTrue", , aFldAFAT,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadFAT, aColsFAT)

oObjSim:Refresh()
oDlgVendas:Refresh()
oFolder:aDialogs[3]:Refresh()
oFolder:Refresh()

Return
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
*-----------------------------------------*
Static Function f_Foto(oDlgVendas, oFolder)
*-----------------------------------------*
Local oPanel
Private _oImgProd
Private _cImgProd   := ''   
Private _cPstFOTO   := GetMV('LA_TGVFOTO',.F., 'TGV')
Private _cImgFund   := FisxLogo("1")                 
Private cIniFile	:= GetADV97()
Private _cDirFOTO 	:= GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+AllTrim(_cPstFOTO)+'\' 

//Atualiza Folder 03
xRshFol3(@oDlgVendas, @oFolder)

//Cria diretorio
MakeDir(GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )+AllTrim(_cPstFOTO)+'\')

// FOTO DO PRODUTO
//_cImgProd := _cDirFOTO + AllTrim(SB1->B1_COD)+'.JPG'
//Renato Bandeira em 28/10/14 - Ajustado para padrao Jplus
//_cImgProd := _cDirFOTO + "PR" + AllTrim(SB1->B1_COD)+'.JPG'
_cImgProd := _cDirFOTO + "PR" + AllTrim(SB1->B1_COD)+'.BMP'
IF !FILE(_cImgProd)
	_cImgProd := _cImgFund
ENDIF

@ C(003),C(340) MSPANEL oPanel PROMPT "Imagem do Produto" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED
//@ 017,341 BITMAP _oImgProd FILENAME _cImgProd   PIXEL OF oFolder:aDialogs[3] SIZE 292,200 NOBORDER ADJUST
//@ 017,341 BITMAP _oImgProd FILENAME _cImgProd   PIXEL OF oFolder:aDialogs[3] SIZE 252,200 NOBORDER ADJUST
//@ 017,341 BITMAP _oImgProd FILENAME _cImgProd   PIXEL OF oFolder:aDialogs[3] SIZE 160,190 NOBORDER ADJUST
@ 017,341 BITMAP _oImgProd FILENAME _cImgProd   PIXEL OF oFolder:aDialogs[3] SIZE 060,190 NOBORDER ADJUST
                                       
Return

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
*------------------------------------------------*
User Function xViewSB2(cProduto, cFilCon ,cAlmox)
*------------------------------------------------*
Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local aViewB2	:= {}
Local aStruSB2  := {}
Local nSaldoSB2 := 0
Local nHdl      := GetFocus()

Local _cFilEmp  := AllTrim(GetMv('LA_TGVFIL' ,.F.,''))
Local _cFilArm  := AllTrim(GetMv('LA_TGVLOC' ,.F.,''))
Local _cFilFut  := AllTrim(GetMv('LA_TGVLFUT',.F.,'05'))
Local nX

DEFAULT cAlmox := ""

//?Verifica a filial de pesquisa do saldo 
_nRecSM0 := SM0->(Recno())
_cEmpSM0 := SM0->M0_CODIGO
DbSelectArea("SM0")
SM0->(dbSetOrder(1))
SM0->(DbgoTop())
While SM0->(!Eof())
	
	//Valida Empresa logada	
	IF _cEmpSM0 <> SM0->M0_CODIGO
		SM0->(DbSkip())
		Loop
	EndIf
	
	//?Posiciona o cadastro de produtos 
	dbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	If SB1->(MsSeek(xFilial('SB1')+cProduto))
		cCursor  := "MAVIEWSB2"
		aStruSB2 := SB2->(dbStruct())		
				
		cQuery := " SELECT * 													" 
		cQuery += "  FROM "+RetSqlName("SB2")+" SB2 "+" WITH (NOLOCK)           "
		cQuery += "   WHERE SB2.D_E_L_E_T_ <> '*' 								"
		cQuery += "     AND B2_FILIAL       = '"+ AllTrim(SM0->M0_CODFIL) +"' 	"
		cQuery += "     AND B2_COD          = '"+cProduto+"' 					"
	   //IF cFilAnt <> '0302'
	//	If cCTpOper=='01' .OR. cCTpOper=='05'
		//	cQuery += "     AND B2_LOCAL      = '01' 			 			"		
	//	ElseIf cCTpOper=='02'
	//		cQuery += "     AND B2_LOCAL      = '"+cCTpOper+"' 				"		
	 //	EndIf		
		//else 
			cQuery += "     AND B2_LOCAL      in ('01','03') 			 			"		
	   
	   //endif
		cQuery += "     AND B2_STATUS      <> '2' 								"
		cQuery += " ORDER BY B2_FILIAL, B2_LOCAL 								"
				
		//cQuery := ChangeQuery(cQuery)	
		If Select(cCursor) > 0
			(cCursor)->(DbCloseArea())
		EndIF
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
				
		For nX := 1 To Len(aStruSB2)
			If aStruSB2[nX][2] <> "C"
				TcSetField(cCursor, aStruSB2[nX][1], aStruSB2[nX][2], aStruSB2[nX][3], aStruSB2[nX][4])
			EndIf
		Next nX
				
		DbSelectArea(cCursor)
		Do While (cCursor)->(!Eof())
			
			//Valida filtro - FILIAL	
			IF !(AllTrim(SM0->M0_CODFIL) $ _cFilEmp) .And. !Empty(_cFilEmp)
				(cCursor)->(DbSkip())
				Loop
			EndIF
            
			//Valida filtro - LOCAL
			IF !(AllTrim((cCursor)->B2_LOCAL) $ _cFilArm) .And. !Empty(_cFilArm) .And. iIF(!Empty(_cFilFut),(!AllTrim((cCursor)->B2_LOCAL) $ _cFilFut),.T.)
				(cCursor)->(DbSkip())
				Loop
			EndIF
	
    		//--Saldo do produto
    		nSaldoSB2 := ((cCursor)->B2_QATU ) - ((cCursor)->B2_RESERVA + (cCursor)->B2_QPEDVEN)
    				
			IF (_nItem := Ascan(aViewB2, {|x| x[1] == SM0->M0_CODFIL })) > 0 
				//aViewB2[_nItem][03] += iIF(!Empty(_cFilFut) .And. AllTrim((cCursor)->B2_LOCAL) $ _cFilFut ,0 ,(nSaldoSB2-(cCursor)->B2_QPEDVEN))
				aViewB2[_nItem][03] += iIF(!Empty(_cFilFut) .And. AllTrim((cCursor)->B2_LOCAL) $ _cFilFut ,0 ,nSaldoSB2)
				aViewB2[_nItem][04] += (cCursor)->B2_QATU		
				aViewB2[_nItem][05] += (cCursor)->B2_QPEDVEN	
				aViewB2[_nItem][06] += (cCursor)->B2_QEMP		
				aViewB2[_nItem][07] += (cCursor)->B2_SALPEDI	
				aViewB2[_nItem][08] += (cCursor)->B2_QEMPSA
				aViewB2[_nItem][09] += (cCursor)->B2_RESERVA
				aViewB2[_nItem][10] += (cCursor)->B2_QTNP
				aViewB2[_nItem][11] += (cCursor)->B2_QNPT
				aViewB2[_nItem][12] += (cCursor)->B2_QTER
				aViewB2[_nItem][13] += (cCursor)->B2_QEMPN
				aViewB2[_nItem][14] += (cCursor)->B2_QACLASS
				aViewB2[_nItem][15] += (cCursor)->B2_QEMPPRJ
				aViewB2[_nItem][16] += (cCursor)->B2_QEMPPRE 
				aViewB2[_nItem][17] += iIF(AllTrim((cCursor)->B2_LOCAL) $ _cFilFut ,nSaldoSB2 ,0)
            Else
            	/*
				IF SM0->M0_CODFIL <> '0501' .And. Len(aViewB2) > 0
					//aViewB2[1][03] := aViewB2[1][03] - ((ABS(nSaldoSB2)+(cCursor)->B2_QPEDVEN) )
					aViewB2[1][03] := aViewB2[1][03] + nSaldoSB2			
				ENDIF*/
				
				aAdd(aViewB2,{  SM0->M0_CODFIL			,;
								(cCursor)->B2_LOCAL		,;
								iIF(!Empty(_cFilFut) .And. AllTrim((cCursor)->B2_LOCAL) $ _cFilFut ,0 , nSaldoSB2),;
								(cCursor)->B2_QATU		,;
								(cCursor)->B2_QPEDVEN	,;
								(cCursor)->B2_QEMP		,;
								(cCursor)->B2_SALPEDI	,;
								(cCursor)->B2_QEMPSA	,;
								(cCursor)->B2_RESERVA	,;
								(cCursor)->B2_QTNP		,;
							    (cCursor)->B2_QNPT		,;
								(cCursor)->B2_QTER		,;
								(cCursor)->B2_QEMPN		,;
								(cCursor)->B2_QACLASS	,;
								(cCursor)->B2_QEMPPRJ	,;
								(cCursor)->B2_QEMPPRE	,;
								iIF(AllTrim((cCursor)->B2_LOCAL) $ _cFilFut ,nSaldoSB2 ,0) })
			EndIF									
			(cCursor)->(DbSkip())
		EndDo
	EndIf

	SM0->(DbSkip())
EndDo
DbSelectArea("SM0")
SM0->(DbGoTo(_nRecSM0))

RestArea(aAreaSM0)
RestArea(aAreaSB2)
RestArea(aArea)
SetFocus(nHdl)

Return(aViewB2)
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>        
*----------------------*
User Function VldTGV001
*----------------------*
Local _aNwSX3 := {'ZN_SIMILAR'}
Local _aNwSXB := {'ZNSIML'}
Local _cErr    := ''
Local _nCp

For _nCp:=1 To Len(_aNwSX3)
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	If !SX3->(MsSeek(_aNwSX3[_nCp]))
		_cErr += '[u_UpdTGV101()] Campos não localizado: '+_aNwSX3[_nCp]
	EndIf
NExt _nCp

For _nCp:=1  To Len(_aNwSXB)
	DbSelectArea("SXB")
	SXB->(DbSetOrder(1))
	If !SXB->(MsSeek(_aNwSXB[_nCp]))
		_cErr += '[u_UpdTGV101()] Cons.Padrão não localizado: '+_aNwSXB[_nCp]
	EndIf
NExt _nCp

IF !Empty(_cErr)
	Alert(_cErr)
EndIf

Return(Empty(_cErr))   
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><>        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xTpFrete ?Autor ?Meliora/Gustavo    ?Data ? 21/11/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Rotina - Valida tipo de Frete                              º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/ 
*-----------------------------*
User Function xTpFrete(_cFrete)
*-----------------------------*
Local _cTpFr := 'C'

IF SubStr(Upper(AllTrim(_cFrete)),1,1) == '1'
	_cTpFr := 'C'
ElseIF SubStr(Upper(AllTrim(_cFrete)),1,1) == '2'
	_cTpFr := 'C'
ElseIF SubStr(Upper(AllTrim(_cFrete)),1,1) == '3'
	_cTpFr := 'F'
ElseIF SubStr(Upper(AllTrim(_cFrete)),1,1) == '4'
	_cTpFr := 'T'
ENDIF

Return(_cTpFr)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xTpFrete ?Autor ?Meliora/Gustavo    ?Data ? 21/11/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Rotina - Valida tipo de Frete                              º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/ 
*----------------------------------------*
User Function xDescFin(_nPreco, _cCdPgto)
*----------------------------------------*

Default _nPreco  := 0
Default _cCdPgto := 0

//	Renato Bandeira em 30/10/14 - nao ira tratar o desconto no item para Higiene e LImpeza
// foi transferido o get da condicao para o encerramento, onde nao eh possivel calcular o desconto
/*/
IF _nPreco > 0
	DbSelectArea("SE4")
	SE4->(DbSetOrder(1))
	SE4->(DbGoTop())
	If SE4->(DbSeek(xFilial("SE4")+_cCdPgto))
		IF SE4->E4_DESCFIN > 0
	   		_nPreco := (_nPreco - (_nPreco*(SE4->E4_DESCFIN/100)))			
		ENDIF	
	EndIF
	DnyCarTot()
EndIF
/*/

Return(_nPreco)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xTabPrc  ?Autor ?Meliora/Gustavo    ?Data ? 02/12/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Rotina - Preco da Tabela de Preco                           º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/ 
*------------------------------------------------*
User Function xTabPrc(_cCodCli, _cCodLj, _cCodPrd)
*------------------------------------------------*
Local _nPreco := 0

If !__lProsp	
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))	
	If SA1->(DbSeek(xFilial("SA1") + PadR(_cCodCli,TamSX3('A1_COD')[1]) + PadR(_cCodLj,TamSX3('A1_LOJA')[1]) ))
		If !Empty(cCodTab) //LEANDRO.EBER - 31/08/2016
			IF MaVldTabPrc(cCodTab,,,dDataBase)
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				If DA1->(MsSeek(xFilial("DA1")+cCodTab+_cCodPrd))
					_nPreco := DA1->DA1_PRCVEN //u_xDescFin(DA1->DA1_PRCVEN, cod_fpg) //DA1->DA1_PRCVEN
					//--.iNi Verifica existencia de promoção para o produto
					FSPromDes(@_nPreco, cCodTab, _cCodPrd)
				ElseIf DA1->(MsSeek(xFilial("DA1")+__HLTABPADR+_cCodPrd))
					_nPreco := DA1->DA1_PRCVEN
					//--.iNi Verifica existencia de promoção para o produto
					FSPromDes(@_nPreco, cCodTab, _cCodPrd)
				EndIf
			EndIF	
		ELSEIF !Empty(SA1->A1_TABELA)   
			IF MaVldTabPrc(SA1->A1_TABELA,,,dDataBase)
				DbSelectArea("DA1")
				DA1->(DbSetOrder(1))
				//DA1->(DbGoTop())
				If DA1->(MsSeek(xFilial("DA1")+SA1->A1_TABELA+_cCodPrd))
					_nPreco := DA1->DA1_PRCVEN //u_xDescFin(DA1->DA1_PRCVEN, cod_fpg) //DA1->DA1_PRCVEN			
					//--.iNi Verifica existencia de promoção para o produto
					FSPromDes(@_nPreco, SA1->A1_TABELA, _cCodPrd)			
				ElseIf DA1->(MsSeek(xFilial("DA1")+__HLTABPADR+_cCodPrd))
						_nPreco := DA1->DA1_PRCVEN
						//--.iNi Verifica existencia de promoção para o produto
					FSPromDes(@_nPreco, __HLTABPADR, _cCodPrd)
				EndIf
			EndIF
		EndIF
	EndIf 
Else
	//--Prospect
	DbSelectArea("DA1")
	DA1->(DbSetOrder(1))
	If DA1->(MsSeek(xFilial("DA1")+cCodTab+_cCodPrd))
		_nPreco := DA1->DA1_PRCVEN
		//--.iNi Verifica existencia de promoção para o produto
		FSPromDes(@_nPreco, cCodTab, _cCodPrd)
	EndIf
EndIf

Return(_nPreco)                                                               

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xVldCltDny ?Autor ?Meliora/Gustavo   ?Data ? 03/01/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Validacao do F3(VldCltDny) - Cadastro de Cliente           º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                 
*---------------------------------*
//Static Function xVldCltDny(cod_cli, coja_cli)
Static Function xVldCltDny(cod_cnpj)
*---------------------------------*
Local _lRet := .T.
Local _cMsg := ''      
Local cQuery := ""                                                             

if IsInCallStack("U_IVENA020")
   if len(alltrim(cod_cnpj)) < 11
      MSGALERT("Atenção!!! Digite todo o conteúdo do campo para pesquisa!")
      _lRet := .F.
	  Return _lRet
   elseif len(alltrim(cod_cnpj)) > 11 .and. len(alltrim(cod_cnpj)) < 14
      MSGALERT("Atenção!!! Digite todo o conteúdo do campo para pesquisa!")
      _lRet := .F.
	  Return _lRet
   endif
endif

//ajuste para a busca por CNPJ
SA1->(dbSetOrder(3))
if SA1->(dbSeek(xFilial('SA1') + cod_cnpj))
	cod_cli		:= SA1->A1_COD
	coja_cli	:= SA1->A1_LOJA
endif

If !Empty(cod_cli)
	//--Tratamento para inserir quantidade de 0 a variavel codigo e loja do cliente
	If Len(Alltrim(cod_cli))<6
		cod_cli:=StrZero(Val(cod_cli),6)
	EndIf
	If Len(Alltrim(coja_cli))<4
		coja_cli:=StrZero(Val(coja_cli),4)
	EndIf
EndIf

If !Empty(cod_cli) .And. !Empty(coja_cli) .And. !lParVldC
//--Valida se cliente tem agenda em aberto	
	If FVldAgen(cod_cli, coja_cli)
		MsgAlert(OemtoAnsi('Cliente com agenda em aberto. Necessario finalizar agendamento(s)!!!'))
		cod_cnpj := Space(TamSx3("A1_CGC") [1]) 
		cod_cli	:= Space(TamSx3("A1_COD") [1])
		coja_cli:= Space(TamSx3("A1_LOJA") [1])
		Return(.F.)
	EndIf
EndIf

// Duplicatas de atraso
cQuery := "SELECT SUM(SE1.E1_SALDO) AS E1SALDO, COUNT(*) AS E1QTDDUP, MIN(SE1.E1_VENCTO) AS E1ATRZ "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
//cQuery += "WHERE SE1.E1_FILIAL  = '"+xFilial("SE1")+"' "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase)+"' "    //wap.o
//cQuery += "AND   SE1.E1_VENCTO  <= '"+DTOS(dDatabase - 4)+"' " 		//wap.n 	//ppl.o
cQuery += "AND   SE1.E1_VENCREA  <= '"+DTOS(DataValida(dDatabase, .T.) - SUPERGETMV("FS_DIASRET" , .T., 2,)	 )+"' " 	 	//ppl.o
cQuery += "AND   SE1.E1_TIPO NOT IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "

TcQuery cQuery New Alias "CRE"
TCSetField("CRE", "E1ATRZ" , "D",08,0)

dbSelectArea("CRE")
DBGOTOP()
IF !Eof()
	IF CRE->E1QTDDUP > 0
		Alert("Atenção, o Cliente possui R$ " +Alltrim(Transform(CRE->E1SALDO, "@E 999,999,999,999.99")) + " de atraso. Verifique!")	
	ENDIF
ENDIF

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

If POSICIONE("SA1",1,XFILIAL("SA1")+ALLTRIM(cod_cli)+ALLTRIM(coja_cli),"A1_COND") == '003'
	Alert("Cliente com condição de Pgto somente Antecipado!")
Endif

//If ! Empty(cod_cli)// .Or. !Empty(coja_cli)
If !Empty(cod_cli) .And. !Empty(coja_cli)

	If Len(Alltrim(cod_cli))<6
		cod_cli:=StrZero(Val(cod_cli),6)
	EndIf
	
	If Len(Alltrim(coja_cli))<4
		coja_cli:=StrZero(Val(coja_cli),4)
	EndIf
	
	//If Posicione("SA1",1,xFilial("SA1")+cod_cli+"01","A1_RISCO")=="E"
	If Posicione("SA1",1,xFilial("SA1")+cod_cli+coja_cli,"A1_RISCO")=="E"
		// CLIENTE COM RISCO = E
		//MSGALERT("Restrição Total de Crédito para esse cliente")
		MSGALERT("Atenção!!! Crédito deve ser liberado pelo financeiro!")
		//_lRet := .F.
	Else		
		DbSelectArea('SA3')
		SA3->(dbSetOrder(7))
		_lFilCli := SA3->(dbSeek(xFilial("SA3")+__cUserID))
		
		_cQuery := " SELECT "+ENTER
		_cQuery += " 	CASE "+ENTER
		_cQuery += " 		WHEN TMA.LISTA = 0 THEN '.F.'  "+ENTER
		_cQuery += " 		ELSE ( "+ENTER
		_cQuery += " 				 SELECT CASE WHEN SA1.A1_COD IS NULL THEN '.F.' ELSE '.T.' END LIB  "+ENTER
		_cQuery += " 					  FROM " + RetSqlName("SA1") + " SA1  "+ENTER
		_cQuery += " 						WHERE SA1.D_E_L_E_T_ <> '*'  "+ENTER
		_cQuery += " 						  AND SA1.A1_FILIAL  = '"+ xFilial('SA1') +"' "+ENTER
		_cQuery += " 						  AND SA1.A1_MSBLQL <> '1'  "+ENTER
		_cQuery += " 						  AND SA1.A1_COD     = '"+ cod_cli +"' "+ENTER
		_cQuery += " 						  AND SA1.A1_LOJA    = '"+ coja_cli +"' "+ENTER
		//IF _lFilCli
		//	_cQuery += "          ) " //LEANDRO.EBER - 31/08/2016 //OR SA1.A1_VEND = '000033' ) "+ENTER  AND ( SA1.A1_VEND = '"+ SA3->A3_COD +"'
		//EndIF
		_cQuery += " 		)  "+ENTER
		_cQuery += " 	END LIB   "+ENTER
		_cQuery += " 		FROM ( "+ENTER
		_cQuery += " 				 SELECT COUNT(*) LISTA "+ENTER
		_cQuery += " 				  FROM " + RetSqlName("SA1") + " SA1  "+ENTER
		_cQuery += " 					WHERE SA1.D_E_L_E_T_ <> '*'  "+ENTER
		_cQuery += " 					  AND SA1.A1_FILIAL  = '"+ xFilial('SA1') +"' "+ENTER
		_cQuery += " 					  AND SA1.A1_MSBLQL <> '1'  "+ENTER
		_cQuery += " 					  AND SA1.A1_COD     = '"+ cod_cli +"' "+ENTER
		_cQuery += " 					  AND SA1.A1_LOJA    = '"+ coja_cli +"' "+ENTER
		//IF _lFilCli
		//	_cQuery += "				  AND ( SA1.A1_VEND = '"+  SA3->A3_COD  +"' ) " //LEANDRO.EBER - 31/08/2016 //OR SA1.A1_VEND = '000033' ) "+ENTER
		//EndIF
		_cQuery += " ) TMA "
		
		If Select("_CLI") > 0
			_CLI->(DbCloseArea())
		EndIf
		DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"_CLI",.F.,.T.)
		DbSelectArea("_CLI")
		_CLI->(dbGoTop())
		
		If !(_lRet := &(_CLI->LIB))
			_cMsg := 'Opção indisponivel. Informe um cliente válido!!'
		EndIf
		
		If !Empty(_cMsg)
			//MsgInfo(_cMsg)
			cod_cli := Space(TamSX3('A1_COD')[1])
			coja_cli:= '0001'
		EndIf  			
	EndIf	//If Posicione("SA1",1,xFilial("SA1")+cod_cli+"0001","A1_RISCO")=="E"
EndIf	//If ! Empty(cod_cli)

If _lRet .And. !Empty(cod_cli)
	//--.iNi Verifica se vendedor ?um representante
	//--.iNi Verifica se cliente que est?sendo informado pertence a carteira do representante ou se ?um cliente inativo
	SA3->(DbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+__cUserID))		
		If SA3->A3_TIPO == 'E'
			/*If (AllTrim(SA1->A1_VEND) != AllTrim(SA3->A3_COD))
				//--Caso seja um cliente que não esteja vinculado a carteira, mas seja um cliente inativo deve-se passar
				If !(AllTrim(SA1->A1_VEND) $ '1000|2000')
					Alert("Atenção, Cliente não est?vinculado a carteira do representante.")
					cod_cli := CriaVar('A1_COD',.F.)
					_lRet:= .F.
				EndIf	
			EndIf*/
		EndIf
	EndIf	
EndIf

Return(_lRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xValidFrt ?Autor ?Meliora/Gustavo    ?Data ? 10/01/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Validacao para calculo do total do quadro dados financeiro º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                       
*--------------------------------------------------------------------*
Static Function xValidDes(_aDadosFin, _oTImp02V, _oTImp03V, _oTImp06V, cCTpOper, cod_fpg, oGetCnd,cod_cli,coja_cli)
*--------------------------------------------------------------------*
Local _lRetFrt := .T.       
Local __HLTOTCMAX	:=	SUPERGETMV("HL_DTOTMAX" , .T., 99,)		
		
If nDescTota>0
	If ROUND(((nDescTota+(_nTotTabe-_nTotFina))/_nTotTabe)*100, 2) > __HLTOTCMAX	//30
		Alert("Atenção, a soma dos dos descontos de iten e total não pode ultrapassar o limite de "+Alltrim(Str(__HLTOTCMAX))+"%")	
		Return .F.
	EndIf     
	//oGetCnd:SetFocus()
EndIf
	
xCalcTtGer(@_aDadosFin, _nDnyVlFrt,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli)

//_nTTotFim := (_aDadosFin[06][02] + _nDnyVlFrt + nDespesa - nDescTota)
_nTTotFim := (_aDadosFin[06][02] + _nDnyVlFrt + nDespesa)
_oTTotFim:Refresh()
//nTotComiss:=U_COMISS(_nTTotFim, _nTotTabe, cCodTab, cod_fpg) //ROUND(_nTotTabe/_nTTotFim,2)
    		
_oTImp02V:CCAPTION := TransForm(_aDadosFin[02][02],PesqPict('SC6','C6_VALOR'))
_oTImp03V:CCAPTION := TransForm(_aDadosFin[03][02],PesqPict('SC6','C6_VALOR'))
_oTImp06V:CCAPTION := TransForm(_aDadosFin[06][02],PesqPict('SC6','C6_VALOR'))

Return(_lRetFrt)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xValidFrt ?Autor ?Meliora/Gustavo    ?Data ? 10/01/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Validacao para calculo do total do quadro dados financeiro º±?
±±?         ?                                                           º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                       
*--------------------------------------------------------------------*
Static Function xValidFrt(_aDadosFin, _oTImp02V, _oTImp03V, _oTImp06V,cCTpOper,cod_cli,coja_cli)
*--------------------------------------------------------------------*
Local _lRetFrt := .T.       

xCalcTtGer(@_aDadosFin, _nDnyVlFrt,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli)

_nTTotFim := (_aDadosFin[06][02] + _nDnyVlFrt + nDespesa - nDescTota)
_oTTotFim:Refresh()

_oTImp02V:CCAPTION := TransForm(_aDadosFin[02][02],PesqPict('SC6','C6_VALOR'))
_oTImp03V:CCAPTION := TransForm(_aDadosFin[03][02],PesqPict('SC6','C6_VALOR'))
_oTImp06V:CCAPTION := TransForm(_aDadosFin[06][02],PesqPict('SC6','C6_VALOR'))

Return(_lRetFrt)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?xAltVnd ?Autor ?Meliora/Gustavo      ?Data ? 10/01/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Validacao do Vendedor.                                     º±?
±±?         ?So pode alterar o vendedor que nao tem amarracao c/ usuarioº±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                 
*---------------------------------*
Static Function xAltVnd(_cCod_Vend,oGetVend)
*---------------------------------*

Local _lAltera := .F.
/*
DbSelectArea('SA3')
SA3->(DbSetOrder(7))
SA3->(DbGoTop())
IF !SA3->(dbSeek(xFilial("SA3")+__cUserID))
	_lAltera := .T.
EndIF
*/    
IF Alltrim(UsrRetName( RetCodUsr() )) $ GetMv("TG_ALTVEND",.F.,"ana.fernandes;orlando.ramalho;Administrador;admin") 
	_lAltera := .T.
EndIF

//_lAltera := .T.

oGetVend:Refresh()
Return(_lAltera)
                 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?PrcFret ?Autor ?Meliora/Gustavo      ?Data ? 13/01/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Calculo da proporcao de frete x Item                       º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                 
*-----------------------------------------------------*
User Function PrcFret(_nTotPed, _nTotItem, _nTotFrete)
*-----------------------------------------------------*
Local _nPrcFrt	 := 0
Default _nTotPed := _nTotItem := _nTotFrete := 0

IF _nTotFrete > 0
	_nPrcFrt := ((_nTotItem * _nTotFrete) / _nTotPed)
ENDIF

Return(_nPrcFrt)

                         
*------------------------*
Static Function xCalcxCnp
*------------------------*           
Local _lRet 	:= .T.
Local cTesInt	:= ''
Local _nLin
//Local _lRecalc := ((AllTrim(_cBpCod_Fpg) <> AllTrim(Cod_Fpg)) .And. ( AllTrim(Posicione("SE4",1,xFilial("SE4")+_cBpCod_Fpg,"E4_COND")) == '00' .Or. AllTrim(Posicione("SE4",1,xFilial("SE4")+Cod_Fpg,"E4_COND")) == '00'))

//_cBpCod_Fpg, Cod_Fpg              
_aOldCols := aClone(oOrcamento:aCols)

If Len(_aOldCols) > 0 .And. !Empty(_aOldCols[Len(_aOldCols)][GdFieldPos("UB_PRODUTO",__aHeaderEx)]) 
	oOrcamento:aCols := {}
Else 
	Return(_lRet)
EndIf

For _nLin:=1 To Len(_aOldCols)
	
	If _aOldCols[_nLin][Len(__aHeaderEx)+1]
		Loop
	EndIf
					            
	AADD(oOrcamento:aCols,Array(Len(__aHeaderEx)+1))
	oOrcamento:aCols[Len(oOrcamento:aCols)][Len(__aHeaderEx)+1] := .F.						

	nPreco := 0
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(xFilial("SA1") + PadR(cod_cli,TamSX3('A1_COD')[1]) + PadR(coja_cli,TamSX3('A1_LOJA')[1]) ))

	SB1->(dbSetOrder(1))
	SB1->(msSeek(xFilial('SB1') + _aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)]))
		   
	//nPreco := u_xDescFin(u_xTabPrc(cod_cli, coja_cli, _aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)]), cod_fpg)
		                                                                      
	nPreco:= _aOldCols[_nLin][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)]
		
	If __lProsp
		cTesInt := GetMv('LB_TGVTES',.F.,'503')
	Else	
	    If cCTpOper == '05'
	    	cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
		Else
			IF ALLTRIM(cFilAnt) $ "0103|0102"
				If cCTpOper == '05'	
					if Posicione("SB2",1,xFilial("SB2")+_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)]+'01',"B2_QATU") > 0
						cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ELSEIF Posicione("SB2",1,xFilial("SB2")+_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)]+'03',"B2_QATU") > 0
						cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ELSE
						cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					ENDIF
				Else
					//cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
					If cCTpOper <> '87'
						if SB1->B1_ORIGEM $ "0|2"
							cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
						else
							SB2->(dbSetOrder(01))
							SB2->(dbSeek(xFilial("SB2") +AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0							
								cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								SB2->(dbSeek(xFilial("SB2") +AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '03'))
								IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0							
									cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
								EndIf
							EndIf
							If Empty(cTesInt)
								If SB1->B1_LOCPAD $ '01|90'														
									cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD'),NIL)
								ElseIf SB1->B1_LOCPAD $ '03|80'							
									cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD'),NIL)
								Else
									MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
								EndIf
							EndIf					
						endif
					Else
						if SB1->B1_ORIGEM $ "0|2"
							cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
						else
							SB2->(dbSetOrder(01))
							SB2->(dbSeek(xFilial("SB2") +AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '01'))
							IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
								cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
							Else
								SB2->(dbSeek(xFilial("SB2") +AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD') + '03'))
								IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0								
									cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
								EndIf
							EndIf
							If Empty(cTesInt)
								If SB1->B1_LOCPAD $ '01|90'														
									cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD'),NIL)
								ElseIf SB1->B1_LOCPAD $ '03|80'							
									cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B2_COD'),NIL)
								Else
									MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
								EndIf
							EndIf
						endif
					EndIf
				EndIf	
			ELSE
				cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],NIL)
			ENDIF	   
	  	EndIf
	 	
	    IF Empty(cTesInt)    
			MSGALERT("MSG 5. TES NAO CADASTRADO, AVISE A AREA FISCAL !!")
	    	cTesInt := GetMv('LB_TGVTES',.F.,'503')
	 	EndIF
	 EndIf	
 										                    		
	MaFisIni(	cod_cli,;
				coja_cli,;		// 2-Loja do Cliente/Fornecedor
				"C",;			// 3-C:Cliente , F:Fornecedor
				'N',;			// 4-Tipo da NF
				SA1->A1_TIPO,;	// 5-Tipo do Cliente/Fornecedor
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				"MATA461",;
				Nil,;
				Nil,;
				IIF(__lProsp,cCod_por+cLoja_por,Nil),;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				Nil,,,Nil,Nil,Nil,Nil,,Nil)
						                        
			                        
	MaFisAdd(	_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],;
			    cTesInt,;
			    _aOldCols[_nLin][GdFieldPos("UB_QUANT" ,__aHeaderEx)],;
			    nPreco,;
			    0.00,;
			    "",;
			    "",;
			    0,;
			    0,;
			    0,;
			    0,;
			    0,;
			    (_aOldCols[_nLin][GdFieldPos("UB_QUANT",__aHeaderEx)] * nPreco),;
			    0,;
			    0,;
			    0)
			                         
	nValIcm  := MaFisRet(1,"IT_VALICM")
	nIcmsRet := MaFisRet(1,"IT_VALSOL")
	nValIpi  := MaFisRet(1,"IT_VALIPI")
	nValIns  := MaFisRet(1,"IT_VALINS")
	nValCof  := MaFisRet(1,"IT_VALCF2")
	nValCsl  := MaFisRet(1,"IT_VALCSL")
	nValPis  := MaFisRet(1,"IT_VALPS2")
	nTotItem := MaFisRet(1,"IT_TOTAL")
	nBaseIcm  := MaFisRet(1,"IT_BASEICM")
			
	MaFisEnd()
								
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_ITEM",   __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_ITEM",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_PRODUTO",__aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_DESCRI",   __aHeaderEx)] := Posicione('SB1',1,xFilial('SB1')+_aOldCols[_nLin][GdFieldPos("UB_PRODUTO",__aHeaderEx)],'B1_DESC')
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_QUANT",  __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_QUANT",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_VRUNIT", __aHeaderEx)] := nPreco
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_VLRITEM",__aHeaderEx)] := (_aOldCols[_nLin][GdFieldPos("UB_QUANT",__aHeaderEx)]*nPreco)
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XPED",   __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_XPED",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XPEDIT", __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_XPEDIT",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_PRCTAB", __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_PRCTAB",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_XCOMIS", __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_XCOMIS",__aHeaderEx)]
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("UB_ZPRCDIG", __aHeaderEx)] := _aOldCols[_nLin][GdFieldPos("UB_ZPRCDIG",__aHeaderEx)]

	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALICM", __aHeaderEx)] := nValIcm
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_ICMSRET",__aHeaderEx)] := nIcmsRet
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALIPI", __aHeaderEx)] := nValIpi
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALINS", __aHeaderEx)] := nValIns
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALCOF", __aHeaderEx)] := nValCof
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALCSL", __aHeaderEx)] := nValCsl
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALPIS", __aHeaderEx)] := nValPis
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_VALBRUT",__aHeaderEx)] := nTotItem							
	oOrcamento:aCols[Len(oOrcamento:aCols), GdFieldPos("D2_BASEICM", __aHeaderEx)] := nBaseIcm
				   											
Next _nLin
						
oOrcamento:oBrowse:Refresh()
oOrcamento:Refresh()
//oFolder:aDialogs[1]:Refresh()
//oFolder:aDialogs[3]:Refresh()
//ocod_Produto:SetFocus()

Return(_lRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±ºPrograma  ?RetEndE ?Autor ?Renato Bandeira      ?Data ? 06/10/14  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Alimenta o endereço de Entrega no Cliente na Obs Logistica  º±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?*/                 
*-----------------------------------------------------*
Static Function RetEndE(xcobslog)
*-----------------------------------------------------*
Local xNovoEnd	:=	""
//
IF ! EMPTY( _cCod_EndE)
	//xNovoEnd	:=	ALLTRIM(Z31->Z31_NOMECL)+" "+ALLTRIM(Z31->Z31_XEND)+" "+ALLTRIM(Z31->Z31_XBAIRR)+" "+ALLTRIM(Z31->Z31_XCIDAD)+" "+ALLTRIM(Z31->Z31_CEP)+" "+ALLTRIM(Z31->Z31_ESTADO)
	//
	IF ! xNovoEnd $ xcobslog
		xcobslog	+=	iif(!Empty(xcobslog)," ","")+"Entrega : "+xNovoEnd
	ENDIF
// Renato Bandeira em 30/12/14 - tratamento para endereço de entrega do cliente
//Somente quando não tiver endereço no Z31 e o end.entrega estiver preenchido e diferente do principal
ELSE
	//Imprime o Endereço de Entrega
	If Alltrim(SA1->A1_END) <> Alltrim(SA1->A1_ENDENT)        
		xNovoEnd	+=	ALLTRIM(SA1->A1_ENDENT ) + " "
		xNovoEnd	+=	ALLTRIM(SA1->A1_BAIRROE ) + " "
		xNovoEnd	+=	ALLTRIM(SA1->A1_MUNE ) + " "
		xNovoEnd	+=	ALLTRIM(SA1->A1_CEPE ) + " "
		xNovoEnd	+=	ALLTRIM(SA1->A1_ESTE ) + " "
 		//
		IF ! xNovoEnd $ xcobslog
			xcobslog	+=	iif(!Empty(xcobslog)," ","")+"Entrega : "+xNovoEnd
		ENDIF
	EndIf

ENDIF
//
Return( .t.)


// Renato Bandeira
Static Function ChkAltPreco()
Local lRetorno	:=	.T.

Return lRetorno


// Renato Bandeira
Static Function CalcDescTot()
Local	_XnVRUNIT	:=	_XnPRCTAB	:= 0
//Local	_nVTemp		:=	0
Local nX               

_nTotTabe := 0.00
_nTotFina := 0.00

// Calcula o desconto total em porcentagem
For nX:=1 To Len(oOrcamento:aCols)
	// Nao deletado                                     
	If !Empty(oOrcamento:aCols[nX, GdFieldPos("UB_PRODUTO",oOrcamento:aHeader)])
		If !oOrcamento:aCols[nX][Len(oOrcamento:aHeader)+1] 
			If !Empty(oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)]) .AND. !Empty(oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
				_XnVRUNIT	+=	(oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
				_XnPRCTAB	+= 	(oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_PRCTAB",oOrcamento:aHeader)])
				_nTotTabe   +=  (oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_PRCTAB",oOrcamento:aHeader)])
				_nTotFina   +=  (oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
			EndIf
		EndIf
	EndIf
Next nX

// Renato Bandeira em 24/11/14 - Total dos Itens na tela do Orçamento
nTotalPV	:=	_XnVRUNIT

nDescT	:= ROUND((((_nTotFina/_nTotTabe)*100)-100)*-1,2)
/*
If nDescT	> 0 //.AND. ROUND( (_nVTemp-100) * -1, 2)>0
//	nDescT	:= 100-_nVTemp
	// Renato Bandeira em 05/01/15 - ARREDONDA a Porcentagem do Desconto
//	nDescT	:= ROUND( (_nVTemp-100) * -1, 2)
Else
	nDescT	:= 0
Endif*/



oDescT:Refresh()
oTotPV:Refresh()
Return Nil

// Trata Deletado e recalcula desconto total na linha dos itens
Static Function fDeleta()
Local nColDel	:=	Len(__aHeaderEx)+1
Local nPosPrd	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRODUTO'} )
//Local nPosProm	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_CODPROM'} )
Local nPosKit	:= 0
Local nDelKit	:= 0
Local cPrdAux	:= ''
Local nQtdPrd	:= 0
Local nPrd		:= 0

oOrcamento:aCols[oOrcamento:nAt, nColDel] := !oOrcamento:aCols[oOrcamento:nAt, nColDel]
If Len(aItensPro) > 0
	//--Valida se item pode ser excluido - Projeto Promoções
	nPosKit:= aScan( aItensPro , { |x| AllTrim(x[01]) == AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd]) } )
	If nPosKit > 0 
		MsgAlert(OemToAnsi('Produto :' + oOrcamento:aCols[oOrcamento:nAt, nPosPrd] + ' não pode ser excluido, pois existe uma promoção aplicada para o produto. Favor retire a promoção !!' ))
		oOrcamento:aCols[oOrcamento:nAt, nColDel] := .F.
	Else
		//--Codigo do produto
		cPrdAux:= AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd])
		//--Grava na Variavel nQtdPrd quantidade de vezes de produto x promoção
		AEval(aPrdCProm,{|x| IIF( AllTrim(x[2]) == cPrdAux ,nQtdPrd++,.T.)})
		//--Posiciona na promoção e delete o registro de Kit
		For nPrd:= 1 To nQtdPrd
			nPosKit:= Ascan(aPrdCProm,{|x| AllTrim(x[2]) == AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd]) })		
			If nPosKit > 0
				nDelKit:= aScan( oPromocoes:Acols , { |x| AllTrim(x[02]) == AllTrim(aPrdCProm[nPosKit][1]) } )
				If nDelKit > 0 			
					If Len(oPromocoes:Acols) > 1 
						//--Redefine tamanho do Array
						ADel(oPromocoes:Acols,nDelKit)
						ASize(oPromocoes:Acols,Len(oPromocoes:Acols)-1)
					Else
						oPromocoes:aCols[1][1]:= ''
						oPromocoes:aCols[1][2]:= ''
						oPromocoes:aCols[1][3]:= 0
						oPromocoes:aCols[1][4]:= ''
						oPromocoes:aCols[1][5]:= .F.
					EndIf				
				EndIf
				If Len(aPrdCProm) > 1
					//--Redefine tamanho do array de produtos x promoção
					ADel(aPrdCProm,nPosKit)
					ASize(aPrdCProm,Len(aPrdCProm)-1)
				Else
					aPrdCProm[1][1]:= ''
					aPrdCProm[1][2]:= ''
				EndIf			
			EndIf
		Next nPrd
		//--Atualiza Grid de orçamento e promoção
		oOrcamento:oBrowse:Refresh()
		oOrcamento:Refresh()
		oPromocoes:oBrowse:Refresh()
		oPromocoes:Refresh()
		CalcDescTot()
	EndIf
Else
	//--Codigo do produto
	cPrdAux:= AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd])
	//--Grava na Variavel nQtdPrd quantidade de vezes de produto x promoção
	AEval(aPrdCProm,{|x| IIF( AllTrim(x[2]) == cPrdAux ,nQtdPrd++,.T.)})
	//--Posiciona na promoção e delete o registro de Kit
	For nPrd:= 1 To nQtdPrd
		//--Utiliza 
		nPosKit:= Ascan(aPrdCProm,{|x| AllTrim(x[2]) == AllTrim(oOrcamento:aCols[oOrcamento:nAt, nPosPrd]) })
		If nPosKit > 0
		 	nDelKit:= aScan( oPromocoes:Acols , { |x| AllTrim(x[02]) == AllTrim(aPrdCProm[nPosKit][1]) } )			
			//--Posição do Kit a ser deletado		
			If nDelKit > 0
			 	If Len(oPromocoes:Acols) > 1
					//--Redefine tamanho do Array
					ADel(oPromocoes:Acols,nDelKit)
					ASize(oPromocoes:Acols,Len(oPromocoes:Acols)-1)				
				Else
					oPromocoes:aCols[1][1]:= ''
					oPromocoes:aCols[1][2]:= ''
					oPromocoes:aCols[1][3]:= 0
					oPromocoes:aCols[1][4]:= ''
					oPromocoes:aCols[1][5]:= .F.
				EndIf				
			EndIf
			If Len(aPrdCProm) > 1
				//--Redefine tamanho do array de produtos x promoção
				ADel(aPrdCProm,nPosKit)
				ASize(aPrdCProm,Len(aPrdCProm)-1)
			Else
				aPrdCProm[1][1]:= ''
				aPrdCProm[1][2]:= ''
			EndIf
		EndIf
	 Next nPrd	 
	//--Atualiza Grid de orçamento e promoção
	oOrcamento:oBrowse:Refresh()
	oOrcamento:Refresh()
	oPromocoes:oBrowse:Refresh()
	oPromocoes:Refresh()
	CalcDescTot()
EndIf

Return()

// Renato Bandeira em 30/10/14
// Chamada : __aLTabDesc := HL_RetLstDesc()
User Function HLRetLstDesc()
Local aRetorno	:=	{}

// ira ler da tabela ZZ1
// ZZ1GRID  '|ZZ1_FAIXA|ZZ1_DESCDE|ZZ1_DESCAT|ZZ1_COMIS|ZZ1_DESCRI|'	// Campos do Grid
ZZ1->(DBSETORDER(1))
ZZ1->( DBSEEK(XFILIAL("ZZ1") + __HLTABPADR )  )
WHILE ! ZZ1->( EOF()) .AND. ZZ1->ZZ1_CODIGO == __HLTABPADR

//  NOME DA FAIXA	,DESC OU ACRESCIMO	, COMISSAO	,COD.BLOQUEIO DE PV
//	AADD( aRetorno, {ZZ1->ZZ1_DESCRI,ZZ1->ZZ1_DESCAT,ZZ1->ZZ1_COMIS		,""} )
// Renato Bandeira em 28/12/14 - Campo ZZ1_DESCDE usado para a diferença na tabela principal
	AADD( aRetorno, {ZZ1->ZZ1_DESCRI,ZZ1->ZZ1_DESCAT,ZZ1->ZZ1_COMIS,"",ZZ1->ZZ1_DESCDE} )
	ZZ1->( DBSKIP())

ENDDO

/*
//              NOME DA FAIXA	,DESC OU ACRESCIMO	, COMISSAO	,COD.BLOQUEIO DE PV
AADD( aRetorno, {"A"			,0					, 1.20		,""} )
AADD( aRetorno, {"B"			,-2					, 1.00		,""} )
AADD( aRetorno, {"C"			,-5					, 0.80		,""} )
AADD( aRetorno, {"D COMODATO"	,10					, 1.00		,""} )
AADD( aRetorno, {"E BOBINA"		,30					, 1.00		,""} )
AADD( aRetorno, {"F DISTRIB."	,-8					, 0.00		,""} )
AADD( aRetorno, {"G INTERIOR"	,5					, 0.00		,""} )
AADD( aRetorno, {"H CPP"		,11.5				, 0.00		,""} )
AADD( aRetorno, {"I NEGOCIACAO"	,3					, 0.00		,"08"} )
*/

Return( aRetorno)

// RETORNO O CUSTO MEDIO DO ULTIMO FECHAMENTO DE ESTOQUES
// Chamada :	nPreco := u_xPCustoMedio(SB1->B1_COD)
//B9_FILIAL+B9_COD+B9_LOCAL+DTOS(B9_DATA)
User Function xPCustoMedio()
Local nValor	:=	0
// Renato Bandeira em 30/10/14 - VERIFICAR , almoxarifado para comodato
nValor	:=	POSICIONE("SB9",1,XFILIAL("SB9") + SB1->B1_COD + "01" + DTOS(GETMV("MV_ULMES")), "B9_VINI1")
IF nValor > 0
nValor	:=	nValor / SB9->B9_QINI
ELSE
	nValor	:=	SB1->B1_CUSTD	// Default eh o custo standard
ENDIF

Return( nValor)

// Renato Bandeira em 18/12/14
// VALIDA SE DATA PROGRAMA FOI DIGITADA E AJUSTA COD. DA CONDICAO DE PAGAMENTO
// CHAMADA :
//	@ C(088),C(150) MSGET    oDtProgr     VAR dDtProgr                           		      SIZE C(060),C(009) OF oDlgFimCot COLORS 0, 16777215          PIXEL      VALID VLDDTPROG(@cod_fpg, dDtProgr)
Static Function VLDDTPROG(cod_fpg, dDtProgr)

/*
If DTOC(dDtProgr) <> "  /  /  "

cod_fpg	:=	"010"
If Empty(nVlrProg1)
	nVlrProg1:= 100
	nVlrProg2:= 0
	nVlrProg3:= 0
	nVlrProg4:= 0
EndIf

oDtProgr:REFRESH()

ENDIF
*/
RETURN .T.


/*/{Protheus.doc} VLDVLPROG
Valida Percentual de parcelas

@author claudiol
@since 23/01/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function VLDVLPROG()

//Local cNomVar:= ReadVar()
Local lRet		:= .T.

//Total do percentual das parcelas
//nTotPer:= nVlrProg1 + nVlrProg2 + nVlrProg3 + nVlrProg4

//If nTotPer > 100
//	ApMsgAlert("Percentual das parcelas Invalido. A soma tem que ser 100%.")
//	lRet:= .F.
//EndIf

Return(lRet)


Static Function ChkIncItem(gCod_produto,nQtde,oDlgVendas, oFolder)
//Local lRetorno := u_VldForaLin(gCod_produto,nQtde)
Local lRetorno := .T.
Local nSaldo := 0
Local nXi

//wap.sn
If lRetorno

	For nXi := 1 To Len ( oEstoque:aCols )
		nSaldo += oEstoque:aCols[nXi][2]
	Next nXi
	
	If nQtde > nSaldo
		Alert("Atenção, a quantidade solicitada ?maior do que a disponível!")	
		//lRetorno := .F.
    EndIf

EndIf


If lRetorno
	DnyCarTot()
	DnyCarOrc(@oDlgVendas, @oFolder)
	ocod_Produto:SetFocus()
	//--Valida existencia de Kit Desconto
	FKitDesc(gCod_produto, nQtde, .T.)	
Endif
	
Return(lRetorno)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSCondSCV
Função utilizada criar tela referente aos tipos de titulos a serem informados para 
os titulos a serem gerados
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSCondSCV(cCondPag,cum_orc)
	
	//Local aAreaAll	:= {SUA->(GetArea()),GetArea()}
	//--Verifica se condição de pagamento est?preenchida    
    If !Empty(cCondPag)
    	SUA->(DbSetorder(01))
		If SUA->(DbSeek(xFilial('SUA')+cum_orc))
			//--Verifica se Cotação ja virou NF
			If Empty(SUA->UA_DOC)		    
			    //--Cria Array
				FSMontGrid(cCondPag)
				//--Cria tela 
				FSGridPGT()
			EndIf
		Else
		    //--Cria Array
			FSMontGrid(cCondPag)
			//--Cria tela 
			FSGridPGT()
		EndIf
	EndIf

Return(.T.)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSGridPGT
Função utilizada para exibir grid com as opções para o usuario informar o tipo de
pagamento
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSGridPGT()

	Local aAreaOld     	:= GetArea()
	Local aPosObj   	:= {}
	Local aObjects  	:= {}
	Local aSize     	:= MsAdvSize()
	Local nOpca 		:= 1
	Local oDlgSCV      	:= Nil	
	Local oMainWnd  	:= Nil
	Local cLinhaOk     	:= "AllwaysTrue" //"U_P2PVLDOK(1)"
	Local cTudoOk      	:= "AllwaysTrue" //"U_P2PVLDOK(2)"
	Local cIniCpos     	:= ()				
	Local nFreeze      	:= 000
	Local nMax         	:= 99
	Local cCampoOk     	:= "AllwaysTrue"
	Local cSuperApagar 	:= ""	
	Local cApagaOk     	:= "AllwaysTrue"//"U_P2PVLDOK(3)"
	Local oWnd			:= Nil
	Local aAlter		:= {'CV_FORMAPG'}
	Local nOpcao        := GD_UPDATE
	//Local bNok			:= {|| FVldAcols(oGetDad),nOpcA:= 0}
	Private aRotina		:= {}
			
	aAdd( aObjects, { 100, 100, .t., .t. } )
	
	aSize[ 3 ] -= 50
	aSize[ 4 ] -= 50 	
	
	aSize[ 5 ] -= 100
	aSize[ 6 ] -= 100
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	DEFINE MSDIALOG oDlgSCV TITLE OemToAnsi('Cond Pgt x Orçamento') From aSize[7],00 to aSize[6],aSize[5] Of oMainWnd PIXEL
	oGetDad:=MsNewGetDados():New(aPosObj[1,1],aPosObj[1][2],aPosObj[1][3],aPosObj[1][4],nOpcao,cLinhaOk,cTudoOk,cIniCpos,;
  	aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,aHeadSCV,aColsSCV)
		
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(oGetDad:TudoOk(),oDlg:End(),Eval(bNok) )},{|| FVldAcols(oGetDad),oDlg:End()}) CENTERED  
	
	//EnchoiceBar(_oDlg,{||(( nOpcA:=1,_oDlg:End()), nOpcA:=0 )},{||_oDlg:End()},,aButtons) 
	//ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,oDlg:End()},oDlg:End()) CENTERED	
	ACTIVATE MSDIALOG oDlgSCV ON INIT EnchoiceBar(oDlgSCV,{|| nOpcA := 1,oDlgSCV:End() },{|| nOpcA := 0,oDlgSCV:End() }) CENTERED  
	//array out of bounds ( 8 of 7 )  on {|| TRANSFORM(SELF:ACOLS[IIF( LEN( SELF:ACOLS ) >= SELF:OBROWSE:NAT, SELF:OBROWSE:NAT, LEN( SELF:ACOLS ) )][8],TRIM(SELF:AHEADER[8][3]))} line : 330
		
	RestArea(aAreaOld)
	
Return(.T.)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSMontGrid
Função utilizada criar grid com base na tabela SCV
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		cCondPag - Condição de pagamento
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSMontGrid(cCondPag)

	Local nUsado    := 0
	Local aCondPag	:= {}	 
	Local cTipoPG   := Space(3)
	Local cDescPG   := Space(20)
	Local nCond, nX
    //--Valida existencia do objeto
    If Type("oGetDad:Acols") != 'U'
		//--Destroi objeto
		FreeObj(oGetDad)
		aHeadSCV := {}
		aColsSCV := {}
    EndIf
    
	dbSelectArea("SX3")
	SX3->(dbSetOrder(1))
	SX3->(dbSeek("SCV"))
	Do While !Eof() .And. SX3->X3_ARQUIVO == "SCV"
		If X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			nUsado++
			aAdd(aHeadSCV, { AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_F3,;
				SX3->X3_CONTEXT,;
				SX3->X3_CBOX,;
				SX3->X3_RELACAO,;
				SX3->X3_WHEN,;
				SX3->X3_VISUAL,;
				SX3->X3_VLDUSER,;
				SX3->X3_PICTVAR,;
				SX3->X3_BROWSE,;
				SX3->X3_OBRIGAT})
		EndIf
		SX3->(dbSkip())
	EndDo
	
	SE4->(DbSetOrder(01)) 
	SE4->(DbSeek(xFilial('SE4')+cCondPag))  
	If "BOL" $ SE4->E4_DESCRI
		cTipoPG   :="BOL"
	   	cDescPG	  :="BOLETO BANCARIO"
	ElseIf "CC" $ SE4->E4_DESCRI
		cTipoPG   :="CC"
	   	cDescPG	  :="CARTAO DE CREDITO"
	ElseIf "CD" $ SE4->E4_DESCRI
		cTipoPG   :="CD"
	   	cDescPG	  :="CARTAO DE DEBITO AUTOMATICO"
	ElseIf "CH" $ SE4->E4_DESCRI
		cTipoPG   :="CH"
	   	cDescPG	  :="CHEQUE"
	ElseIf "FAT" $ SE4->E4_DESCRI
		cTipoPG   :="FAT"
	   	cDescPG	  :="FATURA"
	ElseIf "CR" $ SE4->E4_DESCRI
		cTipoPG   :="CR"
	   	cDescPG	  :="CREDITO"	   	
	Else
		cTipoPG   :=Space(3)
	   	cDescPG	  :=Space(20)
	EndIf
	//--Busca vencimentos a partir da condição informada
	aCondPag := Condicao(_nTTotFim,cCondPag,,dDataBase,,,,,,)
	//--Carrega Grid com as informaçoes de vencimento
	For nCond:= 1 To Len(aCondPag)		
		aAdd(aColsSCV,Array(nUsado+1))
		For nX := 1 To nUsado
			If AllTrim(aHeadSCV[nX][2]) $ 'CV_XDATA'
				aColsSCV[nCond][nX] := aCondPag[nCond][1]
			ElseIf AllTrim(aHeadSCV[nX][2]) $ 'CV_XVALOR'
				aColsSCV[nCond][nX] := aCondPag[nCond][2]
			ElseIf AllTrim(aHeadSCV[nX][2]) $ 'CV_FORMAPG'
				aColsSCV[nCond][nX] := cTipoPG
			ElseIf AllTrim(aHeadSCV[nX][2]) $ 'CV_DESCFOR'
				aColsSCV[nCond][nX] := cDescPG
			Else
				aColsSCV[nCond][nX] := CriaVar(aHeadSCV[nX][2])
			EndIf	
		Next nX
		aColsSCV[Len(aColsSCV)][nUsado+1] := .F.
	Next nCond	

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} P2PVLDOK
Função utilizada para validar Grid
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		nOp - Numero da opçao
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function P2PVLDOK(nOp)

	//Local nPosVlr	:= Ascan(oGetDad:aHeader,{|x| AllTrim(x[2]) = "CV_XVALOR"})
	Local lRetLin	:= .T.
	//Local nSomaPed	:= 0

/*	
	If nOp == 2
		For nXi:=1 To Len(oGetDad:aCols)
			If ! oGetDad:aCols[nXi][Len(oGetDad:aHeader)+1]
				nSomaPed+= oGetDad:aCols[nXi][nPosVlr]
			EndIf
		Next nXi
		If _nTTotFim <> nSomaPed
			MsgAlert(OemToAnsi('Total rateado deve ser igual ao valor do orçamento, favor verificar rateio!!'))
			lRetLin:=.F.
		EndIf	
	Endif

	If nOp == 1
		If !GDDeleted(N)
			lRetLin:= oGetDad:aCols[N][nPosVlr]> 0
			If !lRetLin
				MsgAlert(OemToAnsi('Favor preencher o campo valor [CV_XVALOR]!!'))
			EndIf
		EndIf
	ElseIf nOp == 2	
		Aeval(oGetDad:aCols,{|x| nSomaPed+= IIF( !x[Len(oGetDad:aHeader)+1],x[nPosVlr],0)})
		lRetLin:= (_nTTotFim == nSomaPed)
		If !lRetLin
			MsgAlert(OemToAnsi('Total rateado deve ser igual ao valor do orçamento, favor verificar rateio!!'))
		EndIf
	EndIf	
*/
Return(lRetLin)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldCond
Função utilizada para validar Valores
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		cum_orc - Numero do orçamento
@param 		cod_fpg - Condição de pagamento
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FVldCond(cum_orc,cod_fpg)
	//Função pode ser utilizada para validar alteração de valores	
Return(.T.)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldAcols
Função utilizada para validar existencia do Grid
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		oGetDad - Objeto com Informações
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FVldAcols(oGetDad)
	
	Local lTrue	:= .F.
	Local nX    := 0

	If Type("oGetDad:Acols") != 'U'
		For nX:=1 to len(oGetDad:Acols)
			If !Empty(oGetDad:Acols[nX][2])
				lTrue:=.T.
			EndIf
		Next nX
		
		//--Verifica se existe algum registro com informação
		//Aeval(oGetDad:Acols,{|x| IIF(!Empty(x[2]),lTrue:=.T.,) })
		
		If !lTrue
			FreeObj(oGetDad)
			aHeadSCV := {}
			aColsSCV := {}		
		EndIf
	EndIf

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldCondPV
Função utilizada para validar gravação do PV
       
@author		P2P
@since     	12/09/16
@version  	P.11              
@param 		cum_orc  - Numero da cotação
@param 		cod_fpg  - Condição de pagamento
@param 		lRet	 - Variavel de controle
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FVldCondPV(cum_orc,cod_fpg,lRet)

	/*Local cQuery	:= ''
	Local AliasTrb	:= GetNextAlias()

	SUA->(DbSetorder(01))
	If SUA->(DbSeek(xFilial('SUA')+cum_orc))		
		If SUA->UA_CONDPG != cod_fpg		
			SCV->(DbSetorder(02))
			If SCV->(DbSeek(xFilial('SCV')+cum_orc,.T.))			
				If MsgYesNo("Condição de pagamento foi alterada, deseja informar os tipo de pagamento?",OemToAnsi('ATENCAO'))
					//--Cria Array
					FSMontGrid(cCondPag)
					//--Cria tela 
					FSGridPGT()
					lRet:=.T.
				EndIf
			EndIf	
		EndIf
	EndIf*/

Return(.T.)

Static Function fTrocaOp(cOper)

Local aArea  := GetArea()   

Local lRet := .T.

IF  cOper <> '51'
	MsgAlert("O tipo de operação esta diferente de venda, favor verificar!!")
endif
/*
DbSelectArea("SA3")
DbSetOrder(1)
If DbSeek(xFilial("SA3") + cVend )
	/*If cCTpOper $ SA3->A3_XLOCAL
		lRet:=.T.
	Else
		If cCTpOper <> '05'adm
			lRet:=.F.	
			Alert("Atenção, o Vendedor: "+ALLTRIM(SA3->A3_COD)+" - "+ALLTRIM(SA3->A3_NOME)+" não tem acesso para usar esta operação!")	
		Else
			lRet := .T.
		EndIf
	EndIf*/

//EndIf    

RestArea(aArea)

Return (lRet)


//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} fGridConNe
Função utilizada para atualizar grid da condição negociada
       
@author		Gabriel Gonçalves
@since     	08/03/17
@version  	P.11              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function fGridConNe(lBusca)

Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local aDados	:= {}
Local nValAvi	:= 0
Local cTipoPG	:= ""
Local cDescPG	:= ""
Local aCond		:= {}
Local dDataIni
Local dDataFim

//Limpa os dados da tela
nCNVal_Tot	:= 0
nCNVal_Uti	:= 0
nCNMin_Par	:= 0
nCNDif_Par  := 0

chkFile('SZ1')
chkFile('SZ2')

aDados		:= {{"001",Space(TamSX3("Z1_COND")[1]),"","","",dDataBase,dDataBase,0,0,CriaVar("Z1_NSU"),CriaVar("Z1_AUTORIZ"),"G",CriaVar("Z1_CODBAND"),CriaVar("Z1_BANDEIR"),.F.}}

If lBusca	
	//Busca Valores da condição negociada
	cQuery := "SELECT Z1_SEQUENC, Z1_COND, E4_DESCRI, Z1_DTIVENC, Z1_DTFVENC, Z1_VALCON, Z1_VALPAR, Z1_TOTPED, Z1_NSU, Z1_AUTORIZ, Z1_ADQUIRI, Z1_CODBAND, Z1_BANDEIR "
	
	cQuery += " FROM "+RetSqlName("SZ1")+" SZ1"
	cQuery += " INNER JOIN "+RetSqlName("SE4")+" SE4 ON SZ1.Z1_COND = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ <> '*'"
	
	cQuery += " WHERE SZ1.Z1_FILIAL = '"+xFilial("SUA")+"'"
	cQuery += " AND SZ1.Z1_ORCAMEN = '"+cum_orc+"'"
	cQuery += " AND SZ1.D_E_L_E_T_ <> '*'"
	
	cQuery += " ORDER BY SZ1.Z1_SEQUENC"
	
	dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .F., .T. )
	
	(cAlias)->(DbGoTop())
	If !(cAlias)->(EoF())
		aDados		:= {}
		nCNVal_Tot	:= (cAlias)->(Z1_TOTPED)
		
		While !(cAlias)->(EoF())
			If "BOL" $ (cAlias)->E4_DESCRI
				cTipoPG   :="BOL"
			   	cDescPG	  :="BOLETO BANCARIO"
			ElseIf "CC" $ (cAlias)->E4_DESCRI
				cTipoPG   :="CC"
			   	cDescPG	  :="CARTAO DE CREDITO"
			ElseIf "CD" $ (cAlias)->E4_DESCRI
				cTipoPG   :="CD"
			   	cDescPG	  :="CARTAO DE DEBITO AUTOMATICO"
			ElseIf "CH" $ (cAlias)->E4_DESCRI
				cTipoPG   :="CH"
			   	cDescPG	  :="CHEQUE"
			ElseIf "FAT" $ (cAlias)->E4_DESCRI
				cTipoPG   :="FAT"
			   	cDescPG	  :="FATURA"
			ElseIf "CR" $ (cAlias)->E4_DESCRI
				cTipoPG   :="CR"
			   	cDescPG	  :="CREDITO"
			EndIf
			
			aCond		:= Condicao((cAlias)->(Z1_VALCON), (cAlias)->(Z1_COND),, dDataBase,,,,,,)
			dDataIni	:= aCond[1][1]
			dDataFim	:= aCond[Len(aCond)][1]
			
			aAdd(aDados, {	(cAlias)->(Z1_SEQUENC);
							,(cAlias)->(Z1_COND);
							,(cAlias)->(E4_DESCRI);
							,cTipoPG;
							,cDescPG;
							,dDataIni;
							,dDataFim;
							,(cAlias)->(Z1_VALCON);
							,(cAlias)->(Z1_VALPAR); 
							,(cAlias)->(Z1_NSU);
							,(cAlias)->(Z1_AUTORIZ);
							,(cAlias)->(Z1_ADQUIRI);
							,(cAlias)->(Z1_CODBAND);
							,(cAlias)->(Z1_BANDEIR);
							,.F.})     
							
			nCNVal_Uti	+= (cAlias)->(Z1_VALCON)
			
			nValAvi		+= U_ValAVisCon((cAlias)->(Z1_COND), (cAlias)->(Z1_VALCON))
			
			nCNDif_Par := nCNVal_Tot - nCNVal_Uti
			
			(cAlias)->(DbSkip())
		EndDo
		
		nCNMin_Par	:= (nCNVal_Tot - nValAvi) / nCNMax_Par
	EndIf
	(cAlias)->(DbCloseArea())
EndIf
//--Valida existencia do objeto
If ValType(oGetConNe) != 'U' 
	oGetConNe:SetArray(aDados)
	
	oGetConNe:oBrowse:Refresh()
	oGetConNe:Refresh()
	oFolder:aDialogs[6]:Refresh()
EndIf

Return()

//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} fTotConNeg
Função utilizada para atualizar o total do PV no folder da condição negociada
       
@author		Gabriel Gonçalves
@since     	08/03/17
@version  	P.11              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function fTotConNeg(nNewOption)

Local nTotal	:= 0
Local nAVisGrid	:= 0

Local nPosCond	:= GDFieldPos("Z1_COND",	oGetConNe:aHeader)
//Local nPosDtIVen:= GDFieldPos("Z1_DTIVENC",	oGetConNe:aHeader)
//Local nPosDtFVen:= GDFieldPos("Z1_DTFVENC",	oGetConNe:aHeader)
Local nPosValCon:= GDFieldPos("Z1_VALCON",	oGetConNe:aHeader)
Local nI

If nNewOption == 6
	For nI := 1 To Len(oOrcamento:aCols)
		If !(oOrcamento:aCols[nI][Len(oOrcamento:aCols[nI])])
			If !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_PRODUTO", __aHeaderEx)])									
				nTotal	+= oOrcamento:aCols[nI,GdFieldPos("UB_VLRITEM", __aHeaderEx)]
			EndIf
		Endif
	Next nI
	
	nCNVal_Tot	:= nTotal
	
	//Busca os valores do grid
	For nI := 1 To Len(oGetConNe:aCols)
		If !oGetConNe:aCols[nI][Len(oGetConNe:aCols[nI])] //Desconsidera deletados
			nAVisGrid	+= U_ValAVisCon(AllTrim(oGetConNe:aCols[nI][nPosCond]), oGetConNe:aCols[nI][nPosValCon])
		EndIf
	Next nI
	
	nCNMin_Par	:= (nCNVal_Tot-nAVisGrid) / GetNewPar("FS_MAXPAR", 1)

	oGetCNVTot:Refresh()	
	oGetCNMinP:Refresh()
	
	oFolder:Refresh()
	oFolder:aDialogs[6]:Refresh()
EndIf

Return()

Static Function fBuscCred(cCli,cLoj)

Local nValor := 0
  
cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cCli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+cLoj+"' "
cQuery += "AND   SE1.E1_SALDO   > 0 "
cQuery += "AND   SE1.E1_TIPO IN ('NCC','RA' ) "
cQuery += "AND   SE1.D_E_L_E_T_ <> '*' "

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

TcQuery cQuery New Alias "CRE"

dbSelectArea("CRE")
DBGOTOP()
If !Eof()
	nValor := CRE->E1SALDO
EndIf

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

**
Return ( nValor )
**


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ?ExistX5T ?Autor ?Anderson Goncalves ?Data ? 10/07/15   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ?Validacao do campo bandeira                                º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?                                               º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/   

Static Function ExistX5T(oSx5Bn,cSx5Bn,oBandei,cBandei)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Variaveis da Rotina                              						 ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
Local lRet 		:= .T.  
Local aAreaX5	:= SX5->(GetArea())     

If !Empty(cSx5Bn)
	If ExistCPO("SX5","ZY"+cSx5Bn)  
		dbSelectArea("SX5")
		SX5->(dbSetOrder(1))
		SX5->(dbSeek(xFilial("SX5")+"ZY"+cSx5Bn ))
		cBandei := SX5->X5_DESCRI
	Else
		cBandei := Space(15) 
		lRet := .F.
	EndIf 
Else
	cBandei := Space(15)
EndIf	  

oSx5Bn:Refresh()
oBandei:Refresh()  

RestArea(aAreaX5)  

Return(lRet)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSPromDes
Função utilizada para buscar promoção do tipo desconto

@author		.iNi Sistemas
@since     	22/12/17
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
Static Function FSPromDes(_nPreco, cCodTab, _cCodPrd)

	Local cQuery	:= ''
	Local cCampoTab	:= ''
	Local aAliasTrb	:= ''
	
	//--Tabela temporaria
	aAliasTrb	:= GetNextAlias()
	//--Define de qual tabela devo buscar o preço
	If cCodTab == '001'
		cCampoTab:= 'Z2_PROTAB1'
	ElseIf cCodTab == '002'
		cCampoTab:= 'Z2_PROTAB2'
	ElseIf cCodTab == '003'
		cCampoTab:= 'Z2_PROTAB3'
	ElseIf cCodTab == '004'
		cCampoTab:= 'Z2_PROTAB4'
	ElseIf cCodTab == '005'
		cCampoTab:= 'Z2_PROTAB5'
	ElseIf cCodTab == '006'
		cCampoTab:= 'Z2_PROTAB6'
	ElseIf cCodTab == '007'
		cCampoTab:= 'Z2_PROTAB7'
	ElseIf cCodTab == '008'
		cCampoTab:= 'Z2_PROTAB8'
	EndIf
	//--Tratamento para não ocorrer erro
	If Empty(cCampoTab)
		Return( Nil )
	EndIf
	//--Busca os dados	
	cQuery+= Chr(13)+Chr(10)+"SELECT "+cCampoTab+" AS PROMO "
	cQuery+= Chr(13)+Chr(10)+"FROM "+RetSqlName('SZ2')+" Z2 "
	cQuery+= Chr(13)+Chr(10)+"INNER JOIN "+RetSqlName('SB1')+" B1 ON (B1.D_E_L_E_T_ = '' AND B1_FILIAL = '"+xFilial('SB1')+"' AND Z2_PRODUTO = B1_COD AND B1_MSBLQL <> '1' ) "
	cQuery+= Chr(13)+Chr(10)+"WHERE Z2.D_E_L_E_T_ = '' AND Z2_TIPO = '1' " 
	cQuery+= Chr(13)+Chr(10)+"AND (Z2_DTIVIGE <= '"+Dtos(DDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(DDataBase)+"') " 
	cQuery+= Chr(13)+Chr(10)+"AND Z2_TABELAS LIKE '%"+cCodTab+"%' "
	cQuery+= Chr(13)+Chr(10)+"AND Z2_PRODUTO = '"+_cCodPrd+"' "
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aAliasTrb,.F.,.T.)
	
	(aAliasTrb)->(DbGoTop())	
	If (aAliasTrb)->PROMO > 0 .And. !lGravou 
		MsgAlert(OemToAnsi('Produto: '+AllTrim(_cCodPrd)+ ' em promoção. De: '+AllTrim(Transform(_nPreco,'@E 999,999,999.99'))+;
		' por: '+AllTrim(Transform((aAliasTrb)->PROMO,'@E 999,999,999.99'))))
	EndIf
	//--Define qual preço ser?utilizado
	_nPreco:= IIF((aAliasTrb)->PROMO > 0,(aAliasTrb)->PROMO,_nPreco)	 
	//--Fecha tabela temporaria
	(aAliasTrb)->(DbCloseArea())

Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} f_Promocao
Função monta folder [aba] promoções

@author		.iNi Sistemas
@since     	22/12/17
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
Static Function f_Promocao(oFolder)
    
    Local nUsado
    Local aAux1		:= {}
    Local nPosCampo	:= 0
    Local nPosicao	:= 0
    Local oPanel	:= Nil
    Local nPosUtl	:= 0
    Local lBotProm	:= .F.
    
    //--Somente cria acols se estiver entrando na tela pela primeira vez
    If ValType(oPromocoes) != 'O' 
	    //--Define ordem do campos
		Aadd(aAux1,{'Z2_DESCPRO',1})
		Aadd(aAux1,{'Z2_CODPROM',2})
		Aadd(aAux1,{'Z2_PDESCKI',3})
		Aadd(aAux1,{'Z2_UTILIZA',4})
		
		//--Posiciona na tabela
		SX3->(dbSetOrder(1))
		SX3->(dbSeek("SZ2"))
		nUsado:=0
		aHeadProm:={}
		Do While SX3->( !Eof()) .And. (SX3->X3_ARQUIVO == "SZ2")    
			IF ALLTRIM(SX3->X3_CAMPO) $ "Z2_DESCPRO|Z2_CODPROM|Z2_PDESCKI|Z2_UTILIZA" 
		   		nPosCampo:= Ascan(aAux1,{|x| x[1] = ALLTRIM(SX3->X3_CAMPO)})
		   		nPosicao := aAux1[nPosCampo][2]
				nUsado   := nUsado+1
				AADD(aHeadProm,{ TRIM(SX3->X3_TITULO),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT,;
					SX3->X3_CBOX,;
					SX3->X3_RELACAO,;
					SX3->X3_WHEN,;
					SX3->X3_VISUAL,;
					SX3->X3_VLDUSER,;
					SX3->X3_PICTVAR,;
					SX3->X3_BROWSE,;
					SX3->X3_OBRIGAT,;
					nPosicao})
			EndIf
			SX3->(DbSkip())
		EndDo
		nUsado := Len(aHeadProm)
		//--.iNi HS Ordena pela definição passada pelo Julio
		aSort(aHeadProm,,, { |x, y| x[19] < y[19] })	
	
		aColsProm:= Array(1,nUsado+1)
		
		dbSelectArea("SX3")
		SX3->(DbSeek("SZ2"))
		nUsado:=0
		Do While SX3->( !Eof()) .And. (SX3->X3_ARQUIVO == "SZ2")
			If ALLTRIM(SX3->X3_CAMPO) $ "Z2_DESCPRO|Z2_CODPROM|Z2_PDESCKI|Z2_UTILIZA" 
				nUsado:=nUsado+1
				IF SX3->X3_TIPO == "C"
					aColsProm[1][nUsado] := Space(SX3->X3_TAMANHO)
				Elseif SX3->X3_TIPO == "N"
			   		aColsProm[1][nUsado] := 0
				Elseif SX3->X3_TIPO == "D"
			   		aColsProm[1][nUsado] := dDataBase
				Elseif SX3->X3_TIPO == "M"
			   		aColsProm[1][nUsado] := ""
				Else
			   		aColsProm[1][nUsado] := .F.
				Endif            
			Endif   
			SX3->(DbSkip())
		EndDo
		aColsProm[1][nUsado+1] := .F.
	Else		
		//--Atualiza acols
		aColsProm:= AClone(oPromocoes:Acols)
		lBotProm:= .T.
	EndIf
			
	@ C(003),C(340) MSPANEL oPanel PROMPT "Promoções" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED //COLOR CLR_HRED
	//oPromocoes := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadProm, aColsProm)
	//oPromocoes := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadProm, aColsProm)
	//oPromocoes := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadProm, aColsProm)
	oPromocoes := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadProm, aColsProm)
	oPromocoes:oBrowse:bLDblClick := {|| FAddKit()}
	If lBotProm
		nPosUtl	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_UTILIZA'} )
		oPromocoes:oBrowse:SetBlkBackColor( {|| IIF(oPromocoes:aCols[oPromocoes:nAt,nPosUtl] == '1',CLR_HCYAN,CLR_WHITE )})
	EndIf
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} f_Promocao
Função monta folder [aba] promoções

@author		.iNi Sistemas
@since     	22/12/17
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
Static Function f_Comissao(oFolder)
    
    Local oPanel:= Nil
    Local nUsado:= 0
    Local nLim	:= 0
    
    //--Somente cria acols se estiver entrando na tela pela primeira vez
    If ValType(oComissao) != 'O' 
        
		Aadd(aHeadComis,{"Produto","XX_PRODUTO","@!",15,0,"","","C","",""})
		//Aadd(aHeadComis,{"Descricao","XX_DESC","@!",40,0,"","","C","",""})
		Aadd(aHeadComis,{"Descricao","XX_DESC","@!",20,0,"","","C","",""})
		Aadd(aHeadComis,{"Tabela 2","XX_TAB1","@E 999,999,999.99",09,2,"","","N","",""})
		Aadd(aHeadComis,{"Tabela 3","XX_TAB2","@E 999,999,999.99",09,2,"","","N","",""})
		Aadd(aHeadComis,{"Tabela 5","XX_TAB3","@E 999,999,999.99",09,2,"","","N","",""})
		Aadd(aHeadComis,{"Comis Tab 2","XX_COMIS1","@E 999.99",5,2,"","","N","",""})		
		Aadd(aHeadComis,{"Comis Tab 3","XX_COMIS2","@E 999.99",5,2,"","","N","",""})		
		Aadd(aHeadComis,{"Comis Tab 5","XX_COMIS3","@E 999.99",5,2,"","","N","",""})
		
		nUsado := Len(aHeadComis)
		
		aColsComis:= Array(1,nUsado+1)
		
		For nLim:= 1 To Len(aHeadComis)
			If Trim(aHeadComis[nLim][2]) == "XX_PRODUTO"
				aColsComis[1][nLim] := Criavar('B1_COD',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_DESC"
				//aColsComis[1][nLim] := Criavar('B1_DESC',.F.)
				aColsComis[1][nLim] := space(20)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_TAB1"
				aColsComis[1][nLim] := Criavar('DA0_CODTAB',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_COMIS1"
				aColsComis[1][nLim] := Criavar('DA0_COMIS',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_TAB2"
				aColsComis[1][nLim] := Criavar('DA0_CODTAB',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_COMIS2"
				aColsComis[1][nLim] := Criavar('DA0_COMIS',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_TAB3"
				aColsComis[1][nLim] := Criavar('DA0_CODTAB',.F.)
			ElseIf Trim(aHeadComis[nLim][2]) == "XX_COMIS3"
				aColsComis[1][nLim] := Criavar('DA0_COMIS',.F.)
			EndIf		
		Next nLim
		
		aColsComis[1][Len(aHeadComis)+1]:= .F.
	Else
		If !lGravou
			//--Posição do produto posicionado no Grid
			If !oOrcamento:Acols[oOrcamento:oBrowse:nAt][Len(oOrcamento:AHeader)+1]
				FComPreco(oOrcamento:Acols[oOrcamento:oBrowse:nAt][2])
			Else
				FComPreco('')
			EndIf
			//--Atualiza acols
			aColsComis:= AClone(oComissao:Acols)
		EndIf	
	EndIf
			
	@ C(003),C(340) MSPANEL oPanel PROMPT "Comissao x Preço" SIZE C(305),C(009) OF oFolder:aDialogs[3] CENTERED LOWERED //COLOR CLR_HRED
	//oComissao := MsNewGetDados():New( C(013), C(340), C(221), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadComis, aColsComis)
	//oComissao := MsNewGetDados():New( C(013), C(340), C(115), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadComis, aColsComis)
	//oComissao := MsNewGetDados():New( C(013), C(340), C(230), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadComis, aColsComis)
	oComissao := MsNewGetDados():New( C(013), C(340), C(220), C(645), GD_UPDATE, "AllwaysTrue", "AllwaysTrue", , {},,, "AllwaysTrue", "", "AllwaysTrue", oFolder:aDialogs[3], aHeadComis, aColsComis)
	oComissao:oBrowse:bLDblClick := {|x,y| FSelComis(x,y,oComissao:oBrowse:nAt)}
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FKitDesc
Função verifica existencia de promoção para os produtos selecionado

@author		.iNi Sistemas
@since     	22/12/17
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
Static Function FKitDesc(gCod_produto, nQtde, lParm)

	Local nTamHeader:= Len(oOrcamento:aHeader)+1
	Local cProd		:= ''
	Local cQuery	:= ''
	Local aKits		:= GetNextAlias()
	Local nPosPrd	:= 0
	Local nPosGrid	:= 0
	Local nPosProm	:= 0
	//Local nPosPrcT	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRCTAB'} )
	//Local nPosPrcD	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_VRUNIT'} )
	Local nPosUtl	:= 0	
	
	chkFile('SZ2')
	chkFile('SZ4')
	//--Qtd sempre > 0
	If nQtde == 0 .And. !Empty(gCod_produto)
		Return(.F.)
	EndIf
	//--Busca posição do produto no Grid de orçamento
	nPosPrd:= aScan( oOrcamento:aCols , { |x| AllTrim(x[02]) == AllTrim(gCod_produto) .And. !x[nTamHeader] } )
	/* Retirado a pedido do Julio
	If nPosPrd > 0
		//--Verifica se o preço utilizado ?igual ao preço de tabela. Produto somente ser?avaliado em caso de preço >= preço de tabela
		If oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)] < oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)]
			Return(.F.)
		EndIf 
	EndIf*/	
	//--Add na variavel todos os produtos que estão no orçamento
	AEval(oOrcamento:Acols,{|x| IIF( !x[nTamHeader] ,cProd+=AllTrim(x[2])+'|',.T.)})
	//--Add codigo do produto inserido no Get
	cProd+=AllTrim(gCod_produto)
	//--Busca Kit
	cQuery+= Chr(13)+ Chr(10)+"SELECT A.Z2_CODPROM, A.Z2_DESCPRO, A.Z2_TIPO, A.Z2_PDESCKI FROM " 
	cQuery+= Chr(13)+ Chr(10)+"( "
		cQuery+= Chr(13)+ Chr(10)+"SELECT Z2_CODPROM, Z2_DESCPRO, Z2_TIPO, Z2_PDESCKI, COUNT(*) AS QTD_KIT FROM "+RetSqlName('SZ2')+" " 
		cQuery+= Chr(13)+ Chr(10)+"WHERE Z2_PRODUTO IN "+FormatIn(cProd,"|")+" "
		cQuery+= Chr(13)+ Chr(10)+"AND Z2_TIPO = '2' "
		cQuery+= Chr(13)+ Chr(10)+"AND Z2_TABELAS LIKE '%"+cCodTab+"%' "
		cQuery+= Chr(13)+ Chr(10)+"AND (Z2_DTIVIGE <= '"+Dtos(dDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(dDataBase)+"') "
		cQuery+= Chr(13)+ Chr(10)+"AND D_E_L_E_T_ = '' "
		cQuery+= Chr(13)+ Chr(10)+"GROUP BY Z2_CODPROM, Z2_DESCPRO, Z2_TIPO, Z2_PDESCKI "
	cQuery+= Chr(13)+ Chr(10)+") A, "
	cQuery+= Chr(13)+ Chr(10)+"(	SELECT Z2_CODPROM, Z2_TIPO, COUNT(*) AS QTD_PRD FROM "+RetSqlName('SZ2')+" "	
		cQuery+= Chr(13)+ Chr(10)+"WHERE Z2_TIPO = '2' "
		cQuery+= Chr(13)+ Chr(10)+"AND Z2_TABELAS LIKE '%"+cCodTab+"%' "
		cQuery+= Chr(13)+ Chr(10)+"AND (Z2_DTIVIGE <= '"+Dtos(dDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(dDataBase)+"') "
		cQuery+= Chr(13)+ Chr(10)+"AND D_E_L_E_T_ = '' "
		cQuery+= Chr(13)+ Chr(10)+"GROUP BY Z2_CODPROM, Z2_TIPO, Z2_PDESCKI "
	cQuery+= Chr(13)+ Chr(10)+") B "
	cQuery+= Chr(13)+ Chr(10)+"WHERE A.Z2_CODPROM = B.Z2_CODPROM AND A.Z2_TIPO = B.Z2_TIPO "
	cQuery+= Chr(13)+ Chr(10)+"AND A.QTD_KIT = B.QTD_PRD "

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),aKits,.F.,.T.)
	(aKits)->(DbGoTop())
	Do While (aKits)->(!Eof())
		//--Add no array de promoçoes
		//--Somente add se o mesmo ja não estiver incluido no array
		If Ascan(oPromocoes:aCols,{|x| x[2] == (aKits)->Z2_CODPROM }) == 0
			If Empty(oPromocoes:aCols[1][1])
				oPromocoes:aCols[1][1]:= (aKits)->Z2_DESCPRO
				oPromocoes:aCols[1][2]:= (aKits)->Z2_CODPROM
				oPromocoes:aCols[1][3]:= (aKits)->Z2_PDESCKI
				oPromocoes:aCols[1][4]:= '2'
				oPromocoes:aCols[1][5]:= .F.
			Else
				Aadd(oPromocoes:aCols,{(aKits)->Z2_DESCPRO,(aKits)->Z2_CODPROM,(aKits)->Z2_PDESCKI,'2',.F.})
			EndIf
			//--Posição do campo
			nPosUtl	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_UTILIZA'} )
			//--Valida se item foi usado na promoção
			//--Validação faz-se necessario no caso de alteração de orçamentos
			If !lParm
				SZ4->(DbSetOrder(01))
				If SZ4->(DbSeek(xFilial('SZ4')+(aKits)->Z2_CODPROM))
					//--Atualiza grid como usado
					oPromocoes:aCols[1][4]:= '1'
				EndIf
			EndIf			
			//--Grava todos os itens 
			SZ2->(DbSetOrder(03))
			If SZ2->(DbSeek(xFilial('SZ2')+Avkey((aKits)->Z2_CODPROM,'Z2_CODPROM')+(aKits)->Z2_TIPO))
				Do While SZ2->(!Eof()) .And. SZ2->Z2_CODPROM == (aKits)->Z2_CODPROM .And. SZ2->Z2_TIPO == (aKits)->Z2_TIPO
					//--Posição do produto no grid principal
					nPosGrid:= Ascan(oOrcamento:Acols,{|x| AllTrim(x[2]) == AllTrim(SZ2->Z2_PRODUTO) .And. !x[nTamHeader]})					
					If nPosGrid > 0
						If oOrcamento:Acols[nPosGrid][4] < SZ2->Z2_QTDKIT
							//--Deleta registro da promoção
							If Len(oPromocoes:aCols) > 1
								nPosProm:= Ascan(oPromocoes:aCols,{|x| x[2] == SZ2->Z2_CODPROM })
								If nPosProm > 0 									
									ADel(oPromocoes:aCols,nPosProm)
									ASize(oPromocoes:aCols,Len(oPromocoes:aCols)-1)
								EndIf	
							Else							
								oPromocoes:aCols[1][1]:= ''
								oPromocoes:aCols[1][2]:= ''
								oPromocoes:aCols[1][3]:= ''
								oPromocoes:aCols[1][4]:= ''
								oPromocoes:aCols[1][5]:= .F.
							EndIf
							Exit
						//--Valida se o preço digitado > preço da tabela												
						/*ElseIf oOrcamento:Acols[nPosGrid][nPosPrcD] < oOrcamento:Acols[nPosGrid][nPosPrcT]
						  	If Len(oPromocoes:aCols) > 1
						  		nPosProm:= Ascan(oPromocoes:aCols,{|x| AllTrim(x[2]) == AllTrim(SZ2->Z2_CODPROM) })
								If nPosProm > 0 									
									ADel(oPromocoes:aCols,nPosProm)
									ASize(oPromocoes:aCols,Len(oPromocoes:aCols)-1)
								EndIf	
							Else							
								oPromocoes:aCols[1][1]:= ''
								oPromocoes:aCols[1][2]:= ''
								oPromocoes:aCols[1][3]:= ''
								oPromocoes:aCols[1][4]:= ''
								oPromocoes:aCols[1][5]:= .F.
							EndIf
							Exit*/
						Else
							If Ascan(aPrdCProm,{|x| AllTrim(x[2]) == AllTrim(SZ2->Z2_CODPROM) .And. AllTrim(x[1]) == AllTrim(SZ2->Z2_PRODUTO) }) == 0
								//--Add produto x promoção
								Aadd(aPrdCProm,{SZ2->Z2_CODPROM, SZ2->Z2_PRODUTO})								
							EndIf
						EndIf
					EndIf
					SZ2->(DbSkip())
				EndDo
			EndIf
		EndIf			
	(aKits)->(DbSkip())
	EndDo
	//--Fecha tabela temporaria	
	(aKits)->(DbCloSeArea())
	//--Atualiza Objeto de promoções
	If nPosUtl > 0 
		If !Empty(oPromocoes:aCols[oPromocoes:nAt][nPosUtl])
			oPromocoes:oBrowse:SetBlkBackColor( {|| IIF(oPromocoes:aCols[oPromocoes:nAt,nPosUtl] == '1',CLR_HCYAN,CLR_WHITE )})
		EndIf
	EndIf		
	
	//--Atualiza Objeto		
	If ValType(oPromocoes) == 'O'
		oPromocoes:Refresh()
	EndIf	
		
Return( .T. )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FAddKit
Função add Kit de desconto no orçamento

@author		.iNi Sistemas
@since     	22/12/17
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
Static Function FAddKit()

	Local nPosCod	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_CODPROM'} )
	Local nPosPer	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_PDESCKI'} )
	Local nPosDes	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_DESCPRO'} )
	Local nPosUtl	:= aScan( oPromocoes:aHeader , { |x| AllTrim(x[02]) == 'Z2_UTILIZA'} )
	//Local nPosPrcT	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRCTAB'} )
	//Local nPosPrcD	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_VRUNIT'} )	
	Local nPosQtd	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_QUANT'} )
	Local nPercCalc	:= 0
	Local nVlrItem	:= 0
	Local nPosPrd	:= 0
	Local cTesInt	:= ''
	Local nValIcm   := 0
	Local nIcmsRet  := 0
	Local nValIpi   := 0
	Local nValIns   := 0
	Local nValCof   := 0
	Local nValCsl   := 0
	Local nValPis   := 0
	Local nTotItem  := 0
	Local nTamHeader:= Len(oOrcamento:aHeader)+1
	Local cMsg		:= ''
	Local lKitInc	:= .F.
	Local nSobra	:= 0
	Local nQtdKit	:= 0
	Local nPTotKit	:= 0
	Local nPosKitDel:= 0
	Local nPercTab	:= 0
	Local nVlrItemT	:= 0
	Local nPrecTabP	:= 0
	Local nPercInv	:= 0
	//Local cTesInt	:= ''
	
	//--Avalia se existem itens no grid de promoção
	If Empty(oPromocoes:aCols[oPromocoes:nAt][nPosUtl])
		Return( Nil )
	EndIf
	//--Valida se Kit foi incluido
	If oPromocoes:aCols[oPromocoes:nAt][nPosUtl] == '2'
		cMsg:= "Deseja aplicar [Kit desconto] "+AllTrim(oPromocoes:aCols[oPromocoes:nAt][nPosDes])+" nos itens ? "
		lKitInc:= .T.
	Else
		cMsg:= "[Kit desconto] j?aplicado "+AllTrim(oPromocoes:aCols[oPromocoes:nAt][nPosDes])+", deseja retirar Kit Desconto ? "
		lKitInc:= .F.
	EndIf
	//--Exibe mensagem
	If MsgYesNo(cMsg)
		SZ2->(DbSetOrder(03))
		If SZ2->(DbSeek(xFilial('SZ2')+Avkey(oPromocoes:aCols[oPromocoes:nAt][nPosCod],'Z2_CODPROM')+'2'))
			//--Caso vendedor altere a tabela sempre validar se tabela informada faz referencia com a promoção a ser aplicada
			If !(cCodTab $ SZ2->Z2_TABELAS)
				MsgAlert(OemToAnsi('Tabela informada não faz referencia a promoção: '+ SZ2->Z2_CODPROM))
				Return( Nil )
			EndIf
			Do While SZ2->(!Eof()) .And. SZ2->Z2_CODPROM == oPromocoes:aCols[oPromocoes:nAt][nPosCod] .And. SZ2->Z2_TIPO == '2'
				//--Busca produto no array de orçamentos - Avalia itens deletados
				nPosPrd:= aScan( oOrcamento:aCols , { |x| AllTrim(x[02]) == AllTrim(SZ2->Z2_PRODUTO) .And. !x[nTamHeader] } )				
				//--Avalia se o preço do produto < preço de tabela [Necessario, pois usuario pode alterar para uma tabela com preço menor]								
				//--Posição do produto no Grid
				/* Retirado a pedido do Julio*/
				If nPosPrd > 0  .And. oOrcamento:Acols[nPosPrd][nPosQtd] >= SZ2->Z2_QTDKIT 
					If lKitInc
						//--Calcula qtd que não ser?aplicada o desconto
						nSobra := Mod(oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)], SZ2->Z2_QTDKIT)
						/*If SZ2->Z2_QTDKIT > oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)]
							nSobra:= 0
						Else	
							nSobra := ABS(SZ2->Z2_QTDKIT - oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)])
						EndIf*/	
						//--Calcula qtd total - qtd que sobrou [quantidade e ser calculada]
						nQtdKit:= oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)] - nSobra
						//--Aplica % do desconto no preço
						nPercCalc:= oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)] * (oPromocoes:aCols[oPromocoes:nAt][nPosPer]/100)
						//--Aplica % do desconto no preço de tabela
						nPercTab := oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)] * (oPromocoes:aCols[oPromocoes:nAt][nPosPer]/100)
						//--Valor do item sem desconto
						nVlrItem := oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)]
						//--Valor do item na tabela de preço
						nVlrItemT := oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)]
						//--Total do kit a ser calculado
						nPTotKit := nQtdKit * (nVlrItem - nPercCalc)
						//--Total do Kit a ser calculado por preço de tabela
						nPKitTab := nQtdKit * (nVlrItemT - nPercTab)
						//--Preço cheio
						nPrecTab := nSobra * nVlrItem
						//--Preço cheio tabela de preço
						nPrecTabP:= nSobra * nVlrItemT
						//--Aplica desconto no item
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)] := (nPTotKit + nPrecTab) / oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)] //Round(nVlrItem - nPercCalc,2)
						//--Atualiza preço da tabela de preço - Utilizado para nao gerar desconto
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)] := (nPKitTab + nPrecTabP) / oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT" ,__aHeaderEx)] //Round(nVlrItem - nPercCalc,2)
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VLRITEM",__aHeaderEx)] := nPTotKit + nPrecTab
						//--Sempre zerar o campo de desconto
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_DESC",__aHeaderEx)] := 0
						//--Add item no array de itens Kits
						AAdd(aItensPro,{SZ2->Z2_PRODUTO,SZ2->Z2_CODPROM})
					Else
						//--Percentual invertido
						nPercInv:= (100-oPromocoes:aCols[oPromocoes:nAt][nPosPer])/100
						//--Retorna com valores antigos
						//nVlrItem:= u_xDescFin(u_xTabPrc(cod_cli, coja_cli, SZ2->Z2_PRODUTO), cod_fpg)
						nVlrItem := oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)]
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)]:= nVlrItem / nPercInv
						//--Calculo invertido
						nPrecTabP:= oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)]
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_PRCTAB" ,__aHeaderEx)]:= nPrecTabP / nPercInv
						//--Valor do item
						oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VLRITEM",__aHeaderEx)]:= oOrcamento:aCols[nPosPrd][GdFieldPos("UB_VRUNIT" ,__aHeaderEx)] * oOrcamento:aCols[nPosPrd][GdFieldPos("UB_QUANT"  ,__aHeaderEx)]
						//--Posição do item no array de Kits
						nPosKitDel:= aScan( aItensPro , { |x| AllTrim(x[01]) == AllTrim(SZ2->Z2_PRODUTO) } )
						//--Deleta Item
						If nPosKitDel > 0 
							//--Redefine tamanho do Array
							ADel(aItensPro,nPosKitDel)
							ASize(aItensPro,Len(aItensPro)-1)
						EndIf							
					EndIf	
					If __lProsp
						cTesInt := GetMv('LB_TGVTES',.F.,'503')
					Else								
						//--TES Inteligente					
						If cCTpOper == '05'
							cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
						Else
							IF ALLTRIM(cFilAnt) $ "0103|0102"
								if cCTpOper <> '05'
									if Posicione("SB2",1,xFilial("SB2")+oOrcamento:aCols[nPosPrd][2]+'01',"B2_QATU") > 0
										cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
									ELSEIF Posicione("SB2",1,xFilial("SB2")+oOrcamento:aCols[nPosPrd][2]+'03',"B2_QATU") > 0
										cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
									ELSE
										cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
									ENDIF
								Else									
									If cCTpOper <> '87'
										if SB1->B1_ORIGEM $ "0|2"
											cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
										else
											SB2->(dbSetOrder(01))
											SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD') + '01'))
											IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
												cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
											Else
												SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD') + '03'))
												IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
													cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
												EndIf
											EndIf
											If Empty(cTesInt)
												If SB1->B1_LOCPAD $ '01|90'														
													cTesInt := MaTesInt(2,PadR('51',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD'),NIL)
												ElseIf SB1->B1_LOCPAD $ '03|80'							
													cTesInt := MaTesInt(2,PadR('52',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD'),NIL)
												Else
													MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
												EndIf
											EndIf										
										endif
									Else
										if SB1->B1_ORIGEM $ "0|2"
											cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
										else
											SB2->(dbSetOrder(01))
											SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD') + '01'))
											IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
												cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
											Else
												SB2->(dbSeek(xFilial("SB2") +AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD') + '03'))
												IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
													cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)						
												EndIf
											EndIf
											If Empty(cTesInt)
												If SB1->B1_LOCPAD $ '01|90'														
													cTesInt := MaTesInt(2,PadR('87',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD'),NIL)
												ElseIf SB1->B1_LOCPAD $ '03|80'							
													cTesInt := MaTesInt(2,PadR('84',TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",AvKey(oOrcamento:aCols[nPosPrd][2],'B2_COD'),NIL)
												Else
													MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
												EndIf
											EndIf										
										endif
									EndIf
								EndIf	
       						ELSE
 	   							cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
	    					ENDIF
							//cTesInt := MaTesInt(2,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),cod_cli,coja_cli,"C",oOrcamento:aCols[nPosPrd][2],NIL)
						EndIf
						//--Valida TES
						If Empty(cTesInt)
							MsgAlert(OemToAnsi("MSG 2. TES NAO CADASTRADO, AVISE A AREA FISCAL !!"))
							cTesInt := GetMv('LB_TGVTES',.F.,'503')
						EndIf
					EndIf	
					//--Tratamento fiscais
					SA1->(DbSetOrder(01))
					SA1->(DbSeek(xFilial('SA1')+cod_cli+coja_cli))
					
					MaFisIni(cod_cli,;
							 coja_cli,;		
							 "C",;				
							 'N',;				
							 SA1->A1_TIPO,;
							 Nil,;
							 Nil,;
							 Nil,;
							 Nil,;
							 "MATA461",;
							 Nil,;
							 Nil,;
							 IIF(__lProsp,cCod_por+cLoja_por,Nil),;
							 Nil,;
							 Nil,;
							 Nil,;
							 Nil,;
							 Nil,,,Nil,Nil,Nil,Nil,,Nil)
							
							 MaFisAdd(oOrcamento:ACOLS[nPosPrd][2],;
							 cTesInt,;
							 oOrcamento:aCols[nPosPrd][4],;
							 oOrcamento:aCols[nPosPrd][5],;
							 0.00,;
							 "",;
							 "",;
							 0,;
							 0,;
							 0,;
							 0,;
							 0,;
							 (oOrcamento:aCols[nPosPrd][4]*oOrcamento:aCols[nPosPrd][5]),;
							 0,;
							 0,;
							 0)
							 
							 //--Impostos
							 nValIcm  := MaFisRet(1,"IT_VALICM")
							 nIcmsRet := MaFisRet(1,"IT_VALSOL" )
							 nValIpi  := 0//MaFisRet(1,"IT_VALIPI")
							 nValIns  := MaFisRet(1,"IT_VALINS" )
							 nValCof  := MaFisRet(1,"IT_VALCF2")
							 nValCsl  := MaFisRet(1,"IT_VALCSL")
							 nValPis  := MaFisRet(1,"IT_VALPS2")
							 nTotItem := MaFisRet(1,"IT_TOTAL")
							
							 MaFisEnd()
							 //--Atualiza Grid com as informações dos impostos
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALICM" ,__aHeaderEx)] := nValIcm
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_ICMSRET",__aHeaderEx)] := nIcmsRet
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALIPI" ,__aHeaderEx)] := nValIpi
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALINS" ,__aHeaderEx)] := nValIns
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALCOF" ,__aHeaderEx)] := nValCof
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALCSL" ,__aHeaderEx)] := nValCsl
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALPIS" ,__aHeaderEx)] := nValPis
							 oOrcamento:aCols[nPosPrd, GdFieldPos("D2_VALBRUT",__aHeaderEx)] := nTotItem
										 	
				EndIf
				SZ2->(DbSkip())
			EndDo
		EndIf
		//--Atualiza Grid de promoções
		oPromocoes:aCols[oPromocoes:nAt][nPosUtl]:= IIF(lKitInc,'1','2')
		//--Atualiza Cor do Grid
		If !Empty(oPromocoes:aCols[oPromocoes:nAt][nPosUtl]) 
			oPromocoes:oBrowse:SetBlkBackColor( {|| IIF(oPromocoes:aCols[oPromocoes:nAt,nPosUtl] == '1',CLR_HCYAN,CLR_WHITE )})
			oPromocoes:Refresh()
		EndIf
		//--Atualiza valor total do pedido
		CalcDescTot()
		//--Atualiza Grid de orçamento
		oOrcamento:Refresh()		
	EndIf
	
Return( Nil )

Static Function FSGravPrm(aItensPro)

	Local nProm	:= 0
	Local cSql	:= ''
	
	chkFile('SZ4')
	
	//--Primeiro deleta todos os itens caso exista
	//--Necessario, pois usuario pode gravar orçamento com promoção e depois retirar a promoçao
	cSql += "UPDATE "+RetSqlName("SZ4")+" SET D_E_L_E_T_ = '*' " 	
	cSql += "WHERE Z4_NUMORC = '"+SUA->UA_NUM+"' "		
	cSql += "AND D_E_L_E_T_ <> '*' "
	//--Executa update
	If TCSQLExec( cSql ) <> 0		
		Aviso("Atencao","Falha na atualização [Exclusao orçamento x promoçao]",{"Ok"})				
	EndIf	
	//--Grava as informações na tabela de historico
	For nProm:= 1 To Len(aItensPro)
		RecLock('SZ4',.T.)
			Replace SZ4->Z4_FILIAL  With xFilial('SZ4')
			Replace SZ4->Z4_CODPROM With aItensPro[nProm][2]
			Replace SZ4->Z4_PRODUTO With aItensPro[nProm][1]
			Replace SZ4->Z4_NUMORC  With SUA->UA_NUM
		SZ4->(MsUnLock())	
	Next nProm 

Return( Nil )

Static Function FComPreco(gCod_Produto)

	//Local aAreaOld	:= {DA1->(GetArea()), Getarea()}
	Local aTabelas	:= {'001','002','003'}
	Local nTab		:= 0
	
	SB1->(DbSetOrder(01))
	If SB1->(DbSeek(xFilial('SB1')+Avkey(gCod_Produto,'B1_COD')))
		DA1->(DbSetOrder(01))
		DA0->(DbSetOrder(01))
		For nTab:= 1 To Len(aTabelas)
			If DA0->(DbSeek(xFilial('DA0')+aTabelas[nTab]))
				If DA1->(DbSeek(xFilial('DA1')+aTabelas[nTab]+AvKey(gCod_Produto,'DA1_CODPRO')))
					oComissao:aCols[1][1]:= SB1->B1_COD
					oComissao:aCols[1][2]:= substr(SB1->B1_DESC,1,20)	//SB1->B1_DESC					
					If nTab == 1
						oComissao:aCols[1][3]:=DA1->DA1_PRCVEN 						 
						//oComissao:aCols[1][4]:=DA0->DA0_COMIS 
						oComissao:aCols[1][6]:=DA0->DA0_COMIS 
					ElseIf nTab == 2
						//oComissao:aCols[1][5]:=DA1->DA1_PRCVEN 						 
						//oComissao:aCols[1][6]:=DA0->DA0_COMIS
						oComissao:aCols[1][4]:=DA1->DA1_PRCVEN 						 
						oComissao:aCols[1][7]:=DA0->DA0_COMIS
					ElseIf nTab == 3
						//oComissao:aCols[1][7]:=DA1->DA1_PRCVEN 						 
						//oComissao:aCols[1][8]:=DA0->DA0_COMIS
						oComissao:aCols[1][5]:=DA1->DA1_PRCVEN 						 
						oComissao:aCols[1][8]:=DA0->DA0_COMIS
					EndIf
				EndIf
			EndIf		
		Next nTab	
	Else
		oComissao:aCols[1][1]:= CriaVar('B1_COD',.F.)
		oComissao:aCols[1][2]:= space(20)	//CriaVar('B1_DESC',.F.)
		oComissao:aCols[1][3]:= 0
		oComissao:aCols[1][4]:= 0
		oComissao:aCols[1][5]:= 0
		oComissao:aCols[1][6]:= 0
		oComissao:aCols[1][7]:= 0 
		oComissao:aCols[1][8]:= 0		
	EndIf
	
	//--Valida objeto
	If ValType(oPromocoes) == 'O'
		//--Atualiza Grid
		oComissao:Refresh()
	EndIf
	
Return( Nil )

Static Function FSelComis(x,y, nPos)
	
	Local cCodPrd	:= oComissao:aCols[1][1]//--Codigo do produto
	Local nPosPrd	:= 0
	Local nTamHeader:= Len(oOrcamento:aHeader)+1
	Local nPosPrcT	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_PRCTAB'} )
	Local nPosPrcD	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_VRUNIT'} )
	Local nPosVlr	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_VLRITEM'} )
	Local nPosComi	:= aScan( oOrcamento:aHeader , { |x| AllTrim(x[02]) == 'UB_XCOMIS'} )
	Local nComis	:= 0
	Local nPreco	:= 0
	Local cQuery	:= ''
	//Local cTabAux	:= ''
	Local cCampoTab	:= ''
	Local cCampoPre	:= ''
	Local aTabProm	:= GetNextAlias()	
	
	nPosPrd:= aScan( oOrcamento:aCols , { |x| AllTrim(x[02]) == AllTrim(cCodPrd) .And. !x[nTamHeader] } )
	
	If nPosPrd > 0 
		If y > 2
			//If y == 3 .Or. y == 4 
			If y == 3 .Or. y == 6 
				nPreco:= oComissao:Acols[1][3]
				//nComis:= oComissao:Acols[1][4]
				nComis:= oComissao:Acols[1][6]
				cCampoTab:= 'Z2_PROTAB1'
				cCampoPre:= 'Z2_PRETAB1'
			//ElseIf y == 5 .Or. y == 6 
			ElseIf y == 4 .Or. y == 7 
				//nPreco:= oComissao:Acols[1][5]
				//nComis:= oComissao:Acols[1][6]
				nPreco:= oComissao:Acols[1][4]
				nComis:= oComissao:Acols[1][7]
				cCampoTab:= 'Z2_PROTAB2'
				cCampoPre:= 'Z2_PRETAB2'
			//ElseIf y == 7 .Or. y == 8
			ElseIf y == 5 .Or. y == 8
				//nPreco:= oComissao:Acols[1][7]
				//nComis:= oComissao:Acols[1][8]
				nPreco:= oComissao:Acols[1][5]
				nComis:= oComissao:Acols[1][8]
				cCampoTab:= 'Z2_PROTAB3'
				cCampoPre:= 'Z2_PRETAB4'
			EndIf
		
			cQuery:="SELECT "+cCampoTab+" AS PROMO, "+cCampoPre+" AS PRECO, Z2_PRODUTO " 
			cQuery+="FROM "+RetsqlName('SZ2')+" WHERE D_E_L_E_T_ = '' AND Z2_TIPO = '1' " 
			cQuery+="AND (Z2_DTIVIGE <= '"+DTos(DDataBase)+"' AND Z2_DTFVIGE >= '"+Dtos(DDataBase)+"') "
			cQuery+="AND Z2_PRODUTO = '"+cCodPrd+"' "
			
			DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), aTabProm )
			
			(aTabProm)->(DbGoTop())
			If (aTabProm)->(!Eof())
				MsgAlert(OemToAnsi('Produto: '+AllTrim(cCodPrd)+ ' em promoção. De: '+AllTrim(Transform(nPreco,'@E 999,999,999.99'))+;
				' por: '+AllTrim(Transform((aTabProm)->PROMO,'@E 999,999,999.99'))))		
				nPreco:= (aTabProm)->PROMO
			EndIf
			//--Fecha tabela temporaria
			(aTabProm)->(DbCloseArea())		
					
			//--Atualização dos valores
			oOrcamento:aCols[nPosPrd][nPosPrcT]:= nPreco
			oOrcamento:aCols[nPosPrd][nPosPrcD]:= nPreco
			oOrcamento:aCols[nPosPrd][nPosVlr]:= nPreco
			oOrcamento:aCols[nPosPrd][nPosComi]:= nComis
					
			xCalcxCnp()
			//--Atualiza Grid
			oOrcamento:Refresh()
			//--Atualiza valor total do pedido
			CalcDescTot()	
		EndIf		
	EndIf

Return ( Nil )

Static Function FSVLDLIN()
	
	If ValType(oOrcamento) == 'O'
		If !Empty(oOrcamento:aCols[oOrcamento:nAt][2])
			FComPreco(oOrcamento:aCols[oOrcamento:nAt][2])
			//ocod_Produto:SetFocus()	

			//goTotMarg(oOrcamento:aCols)	//Verifica a margem do orçamento digitado		
		EndIf
	EndIf

Return(.T.)

Static Function FSDescont(nDescTota,_aDadosFin, _oTImp02V, _oTImp03V, _oTImp06V, cCTpOper, cod_fpg, oGetCnd, cCTpFrete,cod_cli,coja_cli )

	Local aAreaAll	:= {SE4->(GetArea()), GetArea()}
	Local nTotAux	:= _nDnyVlFrt + nDespesa
	Local nDescFob	:= GetMv('TG_DESCFOB',.F.,3)
	Local nDescPerc	:= 0
	Local nX		:= 0
	Local nTotDesco	:= 0
	
	//--Calcula total dos itens
	For nX:= 1 To Len(oOrcamento:aCols)
		If !oOrcamento:aCols[nX][Len(oOrcamento:aHeader)+1]
			nTotAux+=(oOrcamento:aCols[nX, GdFieldPos("UB_QUANT",oOrcamento:aHeader)] * oOrcamento:aCols[nX, GdFieldPos("UB_VRUNIT",oOrcamento:aHeader)])
		EndIf	
	Next nX
	
	//--Tipo de Frete Retiraadmin	
	If cCTpFrete == '4'
		nDescPerc:= Round((nDescFob/100) * nTotAux,2)
	Else
		nDescPerc:= 0
	EndIf
	/*
	//--Recebe o desconto
	nDescTota:= nDescPerc
	//--Desconta o % FOB
	nTotDesco:= nTotAux - nDescTota
	//--Avalia desconto na condição de pagamento
	nDescPerc:= 0 
	SE4->(DbSetOrder(01))
	If SE4->(DbSeek(xFilial('SE4')+cod_fpg))
		If SE4->E4_ZPERC > 0
			nDescPerc:= Round((SE4->E4_ZPERC/100) * nTotDesco,2)
		EndIf
	EndIf

	//--Recebe o desconto novamente
	nDescTota+= nDescPerc
	*/
	xValidDes(@_aDadosFin,@_oTImp02V,@_oTImp03V,@_oTImp06V,PadR(cCTpOper,TamSX3('UA_XTOPER')[1]),@cod_fpg,@oGetCnd,cod_cli,coja_cli)
	
	AeVal(aAreaAll,{|nLem| RestArea(nLem)})

Return(.T.)

Static Function FsDataVe(nDias, ObjVenc, dDtVenc1, dDtVenc2, dDtVenc3, dDtVenc4, cOpc)
	
	Local lRetDt:= .T.
	//--Valilda se informaçou dias
	If nDias > 0
		If cOpc == '1' 
			//--Soma data
			dDtVenc1:= DATAVALIDA(DaySum(dDatabase, nDias),.T.)
			If !Empty(dDtVenc2)
				If dDtVenc1 > dDtVenc2
					MsgAlert(OemToAnsi('Vencimento da primeira parcela deve ser menor que da segunda parcela'))
					lRetDt:= .F.
					dDtVenc1:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc3)
				If dDtVenc1 > dDtVenc3
					MsgAlert(OemToAnsi('Vencimento da primeira parcela deve ser menor que da terceira parcela'))
					lRetDt:= .F.
					dDtVenc1:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc4)
				If dDtVenc1 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da primeira parcela deve ser menor que da quarta parcela'))
					lRetDt:= .F.
					dDtVenc1:= CTOD('\\')
				EndIf 
			EndIf
		ElseIf cOpc == '2'
			//--Soma data
			dDtVenc2:= DataValida(DaySum(dDatabase, nDias),.T.)
			If !Empty(dDtVenc1)
				If dDtVenc1 > dDtVenc2
					MsgAlert(OemToAnsi('Vencimento da segunda parcela deve ser maior que da primeira parcela'))
					lRetDt:= .F.
					dDtVenc2:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc3)
				If dDtVenc2 > dDtVenc3
					MsgAlert(OemToAnsi('Vencimento da segunda parcela deve ser menor que da terceira parcela'))
					lRetDt:= .F.
					dDtVenc2:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc4)
				If dDtVenc2 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da segunda parcela deve ser menor que da quarta parcela'))
					lRetDt:= .F.
					dDtVenc2:= CTOD('\\')
				EndIf 
			EndIf	
		ElseIf cOpc == '3'
			//--Soma data
			dDtVenc3:= DataValida(DaySum(dDatabase, nDias),.T.)
			If !Empty(dDtVenc1)
				If dDtVenc1 > dDtVenc3
					MsgAlert(OemToAnsi('Vencimento da terceira parcela deve ser maior que da primeira parcela'))
					lRetDt:= .F.
					dDtVenc3:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc3)
				If dDtVenc2 > dDtVenc3
					MsgAlert(OemToAnsi('Vencimento da terceira parcela deve ser maior que da segunda parcela'))
					lRetDt:= .F.
					dDtVenc3:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc4)
				If dDtVenc3 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da terceira parcela deve ser menor que da quarta parcela'))
					lRetDt:= .F.
					dDtVenc3:= CTOD('\\')
				EndIf 
			EndIf
		ElseIf cOpc == '4'
			dDtVenc4:= DataValida(DaySum(dDatabase, nDias),.T.)
			If !Empty(dDtVenc1)
				If dDtVenc1 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da quarta parcela deve ser maior que da primeira parcela'))
					lRetDt:= .F.
					dDtVenc4:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc3)
				If dDtVenc2 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da quarta parcela deve ser maior que da segunda parcela'))
					lRetDt:= .F.
					dDtVenc4:= CTOD('\\')
				EndIf 
			EndIf
			If !Empty(dDtVenc3)
				If dDtVenc3 > dDtVenc4
					MsgAlert(OemToAnsi('Vencimento da quarta parcela deve ser maior que da terceiras parcela'))
					lRetDt:= .F.
					dDtVenc4:= CTOD('\\')
				EndIf 
			EndIf
		EndIf
		//--Atualiza Objeto
		ObjVenc:Refresh()
	EndIf
	
Return(lRetDt)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FVldAgen
Função valida agenda x numero de orçamentos

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
Static Function FVldAgen(cod_cli, coja_cli)

	Local cQuery := ''
	Local aTabAge:= GetNextAlias()
	Local lRet	 := .T.

	cQuery:="SELECT COUNT(*) AS TOT " 
	cQuery+="FROM "+RetsqlName('ZAF')+" ZAF "
	cQuery+="INNER JOIN "+RetSqlName("SA1")+" SA1 WITH (NOLOCK) ON SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
	cQuery+="AND SA1.A1_COD = ZAF.ZAF_CLIENT AND SA1.A1_LOJA    = ZAF.ZAF_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	//--Verifica se usuario ?vendedor
	SA3->(dbSetOrder(7))
	If SA3->(DbSeek(xFilial("SA3")+__cUserID))
		cQuery += "INNER JOIN "+RetSqlName("SA3")+" SA3 WITH (NOLOCK) ON (SA3.A3_FILIAL = '"+xFilial('SA3')+"' "+ CRLF
		cQuery += "AND SA1.A1_VEND = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' AND (A3_COD = '"+SA3->A3_COD+"' OR A3_COD = '"+SA3->A3_XVENDSU+"') )"+ CRLF	
	EndIf 
	cQuery+="WHERE ZAF.D_E_L_E_T_ = '' AND ZAF_CLIENT = '"+cod_cli+"' AND ZAF_LOJA = '"+coja_cli+"' " 
	cQuery+="AND ZAF_ATEND = '2' AND ZAF_USRRET = '' AND ZAF_NUMORC = '' "
	cQuery+="AND ZAF_DTAGEN <= '"+Dtos(DdataBase)+"' "
			
	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery ), aTabAge )
	
	(aTabAge)->(DbGoTop())
	//--Valida quantidade de registros
	lRet:= IIF((aTabAge)->TOT>0,.T.,.F.)
	//--Fecha tabela temporaria
	(aTabAge)->(DbCloseArea())

Return(lRet)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} DNYCalcFrt
Função calculo de frete

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
Static Function DNYCalcFrt(cCTpFrete, oGetB, oGetF, _aDadosFin, _oTImp03V, _oTImp06V, _cDetalhe)
	
	Local xRet 
	Local _aHeaderOrc	:= oOrcamento:aHeader
	Local _nPosProd		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_PRODUTO"})
	Local _nPosQtde		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_QUANT"})
	Local _nPosVlr		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_VRUNIT"})
	Local aCotacao 		:= {}     
	Local cModoCalc		:= AllTrim(GetMv("ES_MODCFRT",.F.,"INTELIPOST"))
	Local nX			:= 0
	
	For nX:= 1 To Len(oOrcamento:aCols)			
		If !oOrcamento:aCols[nX][Len(_aHeaderOrc)+1]         
			aAdd(aCotacao, {oOrcamento:aCols[nX,_nPosProd],oOrcamento:aCols[nX,_nPosVlr],oOrcamento:aCols[nX,_nPosQtde] })
		Endif
	Next nX
	
	//If SubStr(cCTpFrete,1,1)$"2/5" .or. (SubStr(AllTrim(cCTpFrete),01,01)$'1' .AND. cModoCalc == "INTELIPOST")
	If !empty(cCTpFrete) .and.cCTpFrete=="C"	//Apenas frete CIF
	
		cod_trp     := ""
		come_transp := "" 
		_nDnyVlFrt  := 0.00	 		
		
		//xRet := U_IVENA080(oGetVAL,oGetC,.T.,@_nDnyVlFrt)
		//xRet := U_IVENA080(oGetVAL,oGetC,.T.)
		xRet := U_IVENA080(oGetVAL,oGetC,.T.,@_nPrvFrt,,Cod_Redesp)
				
		If ValType(xRet) == "A"
			//--Codigo da transportadora
			cod_trp    := IIF(Empty(xRet[1]),Space(TamSx3("A1_TRANSP")[1]),xRet[1])			
			come_transp:= POSICIONE("SA4",1,xFilial("SA4")+cod_trp,"A4_NOME")		
		ElseIf ValType(xRet) == "C"
			//cod_trp := xRet
			cod_trp   := IIF(Empty(xRet),Space(TamSx3("A1_TRANSP")[1]),xRet)
		EndIf
	
		oGetVAL:cCaption := cod_trp
		
		oGetVAL:Refresh()	
		oGetB:Refresh()
		oGetF:Refresh()

	    //xValidFrt(_aDadosFin, _oTImp02V, _oTImp03V, _oTImp06V,cCTpOper,nDespesa)
	Else
		MsgStop("Opção não disponível para o tipo de frete selecionado.","Cálculo de Frete")	
	EndIf

Return( .T. )
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FsAtuaAge
Função atualiza agenda

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
Static Function FsAtuaAge(cIdPai, cTipo, dAgenda)

	ZAF->(DbSetOrder(03))
	If ZAF->(DbSeek(xFilial('ZAF')+cIdPai))
		//If cTipo == 'O'
		If (cTipo == 'O' .or. cTipo == 'P')
			//--Finalizar somente se for primeiro atendimento
			If Empty(ZAF->ZAF_NUMORC)
				RecLock("ZAF",.F.)
					ZAF->ZAF_ATEND  := '1'
					ZAF->ZAF_DTARET := dDatabase
					ZAF->ZAF_HORRET := Time()
					ZAF->ZAF_USRRET := __cUserId
				ZAF->(MsUnLock())
			EndIf
		Else
			//--Atualiza Data da Agenda
			If !Empty(dAgenda)
				RecLock("ZAF",.F.)
					ZAF->ZAF_DTAGEN := dAgenda
				ZAF->(MsUnLock())
			EndIf	
		EndIf	
	EndIf			

Return(Nil)


// Fun?o para tratamento das regras de cores para a grid da MsNewGetDados
Static Function goGETDCLR(aLinha,nLinha,__aHeaderEx)
Local nCor00 := RGB(255,255,255) //White
Local nCor01 := RGB(255,128,128)	//Red
Local nCor02 := RGB(255,255,128) //Yellow
Local nCor03 := RGB(128,255,128)	//Green
Local nCor04 := RGB(128,255,255) //Blue

Local nUsado	:= Len(__aHeaderEx)+1
Local nRet		:= nCor00
Local nL

/*
1 - Item
2 - Produto
3 - Descricao
4 - Quantidade
5 - Preço aplicado
6 - Total do Item
*/
//nTotPP := 0
//For nL := 1 to len(aLinha)
//	nTotPP += aLinha[nLinha][6]
//Next

if !empty(aLinha[nLinha][5]).AND. !(aLinha[nLinha][nUsado])

	nCusto := 0
	SB2->(dbSetOrder(1))
	if SB2->(msSeek(xFilial('SB2') + aLinha[nLinha][2] + '01'))
		if !empty(SB2->B2_CM1)
			nCusto := SB2->B2_CM1
		endif
	endif
	if empty(nCusto)
		if SB2->(msSeek(xFilial('SB2') + aLinha[nLinha][2] + '03'))
			if !empty(SB2->B2_CM1)
				nCusto := SB2->B2_CM1
			endif
		endif
	endif

	nFrtDsp := 0	//Rateio frete/despesa

	nValIcm := oOrcamento:aCols[nLinha, GdFieldPos("D2_VALICM", __aHeaderEx)]
	nValIpi := oOrcamento:aCols[nLinha, GdFieldPos("D2_VALIPI", __aHeaderEx)]
	nValCof := oOrcamento:aCols[nLinha, GdFieldPos("D2_VALCOF", __aHeaderEx)]
	nValPis := oOrcamento:aCols[nLinha, GdFieldPos("D2_VALPIS", __aHeaderEx)]
	nIcmsRet := oOrcamento:aCols[nLinha, GdFieldPos("D2_ICMSRET",__aHeaderEx)]
	nBaseIcm := oOrcamento:aCols[nLinha, GdFieldPos("D2_BASEICM", __aHeaderEx)]

	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + cod_cli + coja_cli))
	//somente se cliente nao for INOVEN
	if substr(SA1->A1_CGC,1,8) <> '07826504'
		//Definir o % de ICMS com beneficio
		nPIcms := 0
		Do Case
			//Fora do Estado
			Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
			//Dentro do Estado e Simples
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
			//Dentro do Estado e Consumidor Final
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
			//Dentro do Estado e Nao Simples
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
		EndCase

		nValIcm := Round(nBaseIcm * nPIcms, 2)
	endif

	nIcmComp := 0
	nDifal := 0
	nFECP := 0
	nComis := 0

	nTotImp := (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP+nComis)
	//if nFrete > 0
	//	nTotImp += nValIpi + nIcmsRet
	//endif
	nValIpi := 0	//zero este valor por nao ter frete aqui no orçamento
	nIcmsRet := 0   //zero este valor por nao ter frete aqui no orçamento

	nVlrDsc := 0	//Round((aLinha[nLinha][4] * aLinha[nLinha][8]) - (aLinha[nLinha][4] * aLinha[nLinha][5]),2)

	nTotItem := aLinha[nLinha][6]
	nTotItem  += (nValIpi+nIcmsRet+nFrtDsp) - (nVlrDsc)//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM

	nReceita := nTotItem-nTotImp
	nCustot  := aLinha[nLinha][4]*nCusto
	nbenFil  := 0	//aVetPnl3[ny][38]
	nMargem  := Round((((nReceita - nCusTot + nbenFil ) / nReceita ) * 100),2)
	//alert(aLinha[nLinha][2] + '-' + str(nMargem))

	If Select("QRYZM1") <> 0
		QRYZM1->(dbCloseArea())
	EndIf

	BeginSQL Alias "QRYZM1"
	SELECT
		ZM1_COR
	FROM 
		%Table:ZM1% ZM1
	WHERE
		ZM1.%NotDel%
		AND %exp:nMargem% >= ZM1_MARGI 
		AND %exp:nMargem% < ZM1_MARGF
	
	EndSql
	cCpoCor := 'nCor' + iif(!empty(QRYZM1->ZM1_COR), QRYZM1->ZM1_COR, '00')
	cCpoCor := iif(nMargem < 0, 'nCor01', cCpoCor)		//Vermelho quando margem negativa

	nRet := &(cCpoCor)	//nCor2

	if __cUSERID $ SUPERGETMV("IN_VISMARG" , .T., "000000",)
		oOrcamento:aCols[nLinha, GdFieldPos("C6_ZMARGPP", __aHeaderEx)] := nMargem
	endif
	//if upper(ReadVar()) <> "NDESCTOTA"
	//	oOrcamento:aCols[nLinha, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)] := oOrcamento:aCols[nLinha, GdFieldPos("UB_VRUNIT", __aHeaderEx)]
	//endif

	goTotMarg(oOrcamento:aCols)	//Verifica a margem do orçamento digitado		
elseif (aLinha[nLinha][nUsado])	//se deletado
	nRet := RGB(192,192,192)
endif
Return nRet


//Verifica a margem total do orçamento digitado
/*
1 - Item
2 - Produto
3 - Descricao
4 - Quantidade
5 - Preço aplicado
6 - Total do Item
*/
Static Function goTotMarg( aLinha )
Local nUsado	:= Len(__aHeaderEx)+1
Local nL

nTotPP := 0
nTotImp := 0
nCustot := 0
nbenFil := 0
For nL := 1 to len(aLinha)

	if !empty(aLinha[nL][5]) .AND. !(aLinha[nL][nUsado])

		//nTotPP += aLinha[nL][6]

		nCusto := 0
		SB2->(dbSetOrder(1))
		if SB2->(msSeek(xFilial('SB2') + aLinha[nL][2] + '01'))
			if !empty(SB2->B2_CM1)
				nCusto := SB2->B2_CM1
			endif
		endif
		if empty(nCusto)
			if SB2->(msSeek(xFilial('SB2') + aLinha[nL][2] + '03'))
				if !empty(SB2->B2_CM1)
					nCusto := SB2->B2_CM1
				endif
			endif
		endif

		nFrtDsp := 0	//Rateio frete/despesa

		nValIcm := oOrcamento:aCols[nL, GdFieldPos("D2_VALICM", __aHeaderEx)]
		nValIpi := oOrcamento:aCols[nL, GdFieldPos("D2_VALIPI", __aHeaderEx)]
		nValCof := oOrcamento:aCols[nL, GdFieldPos("D2_VALCOF", __aHeaderEx)]
		nValPis := oOrcamento:aCols[nL, GdFieldPos("D2_VALPIS", __aHeaderEx)]
		nIcmsRet := oOrcamento:aCols[nL, GdFieldPos("D2_ICMSRET",__aHeaderEx)]
		nBaseIcm := oOrcamento:aCols[nL, GdFieldPos("D2_BASEICM", __aHeaderEx)]

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + cod_cli + coja_cli))
		//somente se cliente nao for INOVEN
		if substr(SA1->A1_CGC,1,8) <> '07826504'
			//Definir o % de ICMS com beneficio
			nPIcms := 0
			Do Case
				//Fora do Estado
				Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
				//Dentro do Estado e Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
				//Dentro do Estado e Consumidor Final
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
				//Dentro do Estado e Nao Simples
				Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
			EndCase

			nValIcm := Round(nBaseIcm * nPIcms, 2)
		endif

		nIcmComp := 0
		nDifal := 0
		nFECP := 0
		nComis := 0

		nTotImp += (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP+nComis)
		//if nFrete > 0
		//	nTotImp += nValIpi + nIcmsRet
		//endif
		nValIpi := 0	//zero este valor por nao ter frete aqui no orçamento
		nIcmsRet := 0   //zero este valor por nao ter frete aqui no orçamento

		nVlrDsc := 0	//Round((aLinha[nLinha][4] * aLinha[nLinha][8]) - (aLinha[nLinha][4] * aLinha[nLinha][5]),2)

		nTotPP  += aLinha[nL][6]
		nTotPP  += (nValIpi+nIcmsRet+nFrtDsp) - (nVlrDsc)//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM

		nCustot  += (aLinha[nL][4]*nCusto)
		nbenFil  += 0	//aVetPnl3[ny][38]

	endif

Next
nRetMarg := Round((((nTotPP  - nTotImp)  - nCustot + 	nbenFil)  / (nTotPP - nTotImp) * 100),2)

If Select("QRYZM1") <> 0
	QRYZM1->(dbCloseArea())
EndIf

BeginSQL Alias "QRYZM1"
SELECT
	ZM1_COR
FROM 
	%Table:ZM1% ZM1
WHERE
	ZM1.%NotDel%
	AND %exp:nRetMarg% >= ZM1_MARGI 
	AND %exp:nRetMarg% < ZM1_MARGF

EndSql
cCpoCor := iif(!empty(QRYZM1->ZM1_COR), QRYZM1->ZM1_COR, '00')
cCpoCor := iif(nRetMarg < 0, '01', cCpoCor)		//Vermelho quando margem negativa

if __cUSERID $ SUPERGETMV("IN_VISMARG" , .T., "000000",)
	nSayMarg := nRetMarg
	oSayMarg:show()
	oSayMarg:Refresh()
ENDIF

Do Case
	Case cCpoCor == '00'
		oMargem1:Load(NIL, "web\images\margem_no.png" )
		//oMargem2:Load(NIL, "web\images\margem_no.png" )
		//oMargem3:Load(NIL, "web\images\margem_no.png" )
		//oMargem4:Load(NIL, "web\images\margem_no.png" )
	Case cCpoCor == '01'
		oMargem1:Load(NIL, "web\images\margem_red.png" )
		//oMargem2:Load(NIL, "web\images\margem_red.png" )
		//oMargem3:Load(NIL, "web\images\margem_red.png" )
		//oMargem4:Load(NIL, "web\images\margem_red.png" )
	Case cCpoCor == '02'
		oMargem1:Load(NIL, "web\images\margem_yellow.png" )
		//oMargem2:Load(NIL, "web\images\margem_yellow.png" )
		//oMargem3:Load(NIL, "web\images\margem_yellow.png" )
		//oMargem4:Load(NIL, "web\images\margem_yellow.png" )
	Case cCpoCor == '03'
		oMargem1:Load(NIL, "web\images\margem_green.png" )
		//oMargem2:Load(NIL, "web\images\margem_green.png" )
		//oMargem3:Load(NIL, "web\images\margem_green.png" )
		//oMargem4:Load(NIL, "web\images\margem_green.png" )
	Case cCpoCor == '04'
		oMargem1:Load(NIL, "web\images\margem_blue.png" )
		//oMargem2:Load(NIL, "web\images\margem_blue.png" )
		//oMargem3:Load(NIL, "web\images\margem_blue.png" )
		//oMargem4:Load(NIL, "web\images\margem_blue.png" )
EndCase

Return

//Calcula o desconto Total do orçamento em valor
Static Function goCalcDTot()
Local _x

if nDescTota >= 0
	nTotTab := 0
	for _x := 1 to len(oOrcamento:aCols)
		nPreco := iif(!empty(oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)]), oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)], oOrcamento:aCols[_x, GdFieldPos("UB_VRUNIT", __aHeaderEx)])
		//nTotTab += oOrcamento:aCols[_x, GdFieldPos("UB_QUANT", __aHeaderEx)] * oOrcamento:aCols[_x, GdFieldPos("UB_PRCTAB", __aHeaderEx)]
		//nTotTab += oOrcamento:aCols[_x, GdFieldPos("UB_QUANT", __aHeaderEx)] * oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)]
		nTotTab += oOrcamento:aCols[_x, GdFieldPos("UB_QUANT", __aHeaderEx)] * nPreco
	next
	nTotDD := nTotTab - nDescTota	//valor total com desconto
	for _x := 1 to len(oOrcamento:aCols)
		//nInd := oOrcamento:aCols[_x, GdFieldPos("UB_PRCTAB", __aHeaderEx)] / nTotTab
		nPreco := iif(!empty(oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)]), oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)], oOrcamento:aCols[_x, GdFieldPos("UB_VRUNIT", __aHeaderEx)])
		//nInd := oOrcamento:aCols[_x, GdFieldPos("UB_ZPRCDIG", __aHeaderEx)] / nTotTab
		nInd := nPreco / nTotTab
		nPrcDD := Round(nTotDD * nInd, 2)
		oOrcamento:aCols[_x, GdFieldPos("UB_VRUNIT", __aHeaderEx)] := nPrcDD
		oOrcamento:aCols[_x, GdFieldPos("UB_VLRITEM", __aHeaderEx)] := oOrcamento:aCols[_x, GdFieldPos("UB_QUANT", __aHeaderEx)] * nPrcDD
	next
endif
xCalcxCnp()
CalcDescTot()
//--Atualiza Grid de orçamento
oOrcamento:Refresh()		
Return( .T. )
