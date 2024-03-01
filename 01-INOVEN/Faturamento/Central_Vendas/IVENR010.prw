#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE  ENTER CHR(13)+CHR(10)
#DEFINE  _NRODAPE 2400

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  IVENR010 บ Autor  	Meliora/Gustavo	 บ Data   04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao  Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso                                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//DESENVOLVIDO POR INOVEN

*-------------------*
User Function IVENR010
*-------------------* 
/*** FONTES ***/                              
Private oFont16T  	:= TFont():New("Arial",,16,,.T.,,,,,.F.) 
Private oFont14TI  	:= TFont():New("Arial",,13,,.T.,,,,.T.,.F.) 
Private oFont11T  	:= TFont():New("Courier New",,11,,.T.,,,,,.F.)
Private oFont09T  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)
Private oFont09F  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)
//Private oFont08F  	:= TFont():New("Courier New",,08,,.F.,,,,,.F.)
// Renato Bandeira em 28/11/13 - Alteracao do fonte para conteudo
Private oFont08F  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)

Private oFont08T  	:= TFont():New("Courier New",,08,,.T.,,,,,.F.)
Private oFont06F  	:= TFont():New("Courier New",,06,,.F.,,,,,.F.)
Private oFont07F  	:= TFont():New("Courier New",,06,,.F.,,,,,.F.)
/*** ABRE FOLHA ***/
//Private oPrn      	:= TMSPrinter():New()
Private oPrn      	:= FWMSPrinter():New("TGVORCA", IMP_PDF,.T., /*Dir*/, .T.,,,, .T.,, .F.)

/*** IMAGENS ***/
Private _cLogo    	:= lower(FisxLogo("1"))
Private Titulo    	:= SM0->M0_NOMECOM  

Private _aOS:={}

/*** PERGUNTA ***/
Private cPerg1 	  	:= 'XRORCA'    

If AllTrim(FunName()) != 'DNYGESVEN'
	PutSx1(cPerg1,"01","Nบ. Or็amento:","Nบ. Or็amento:","Nบ. Or็amento:","mv_ch01","C",06,00,00,"G","","SUA","","","mv_par01","","","","","","","","","","","","","","","","")
	Pergunte(cPerg1,.F.)
	DbSelectArea("SX1")
	SX1->(DbSetorder(1))
	If SX1->(DbSeek(cPerg1))
		IF 	RecLock("SX1",.F.)
				MV_PAR01 :=  AllTrim(SX1->X1_CNT01)
			SX1->(MsUnlock())
		ENDIF				
	EndIf
Else
	PutSx1(cPerg1,"01","Nบ. Or็amento:","Nบ. Or็amento:","Nบ. Or็amento:","mv_ch01","C",06,00,00,"G","","SUA","","","mv_par01","","","","","","","","","","","","","","","","")
	Pergunte(cPerg1,.F.)
	DbSelectArea("SX1")
	SX1->(DbSetorder(1))
	If SX1->(DbSeek(cPerg1))
		IF 	RecLock("SX1",.F.)
				MV_PAR01 :=  AllTrim(SUA->UA_NUM)
			SX1->(MsUnlock())
		ENDIF				
	EndIf
EndIf

IF !Pergunte(cPerg1,.T.)
	Return
EndIf

//IF !u_xAcessoUA(MV_PAR01)
////	MsgInfo('Or็amento de Venda nใo pertence a carteira do vendedor!')  
//	Return
//EndIF

oPrn:SetParm( "-RFS")
oPrn:SetResolution(72)

oPrn:SetPortrait() //Retrato

oPrn:SetPaperSize(DMPAPER_A4)

/** oPrn:SetLandscape() // Paisagem() **/
oPrn:StartPage()

Private lEnd := .F.

FWMsgRun(, {|| XRORCA_2() }, "Aguarde...", "Imprimindo relat๓rio...")      

oPrn:EndPage()
//oPrn:Setup()
oPrn:Preview()
//MS_FLUSH()

Return   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRORCA บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*-------------------------*
Static Function XRORCA_2
*-------------------------*
Local _nLs
/*** VARIAVEIS DO SISTEMA ***/  
Private _NPULALIN   := 2700 //2700
Private _nLin     	:= 0  
Private _nBxInfo    := 0
Private _nPag     	:= 0  
Private _NCBLINFO   := 30	//40 

Private _aLstOrc    := {}

/* LISTA ITENS DO ORวAMENTO */  
_cQryPAM := " SELECT UA_NUM AS 'ORCAMENT' "
_cQryPAM += " FROM "+ RetSqlName('SUA') +" SUA   "
_cQryPAM += " WHERE SUA.D_E_L_E_T_ <> '*' "
_cQryPAM += " AND UA_FILIAL = '"+ xFilial('SUA') +"' "
_cQryPAM += " AND UA_NUM    = '"+ MV_PAR01 +"' "
_cQryPAM += " ORDER BY UA_NUM "

If Select("_LIB") > 0                                                                                   
	_LIB->(DbCloseArea())
EndIf 
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryPAM),"_LIB",.F.,.T.) 
DbSelectArea("_LIB")
_LIB->(DbGoTop())    
DO While !_LIB->(Eof())	
	aADD(_aLstOrc, _LIB->ORCAMENT )
	_LIB->(DbSkip())
EndDo

FOR _nLs:=1 TO LEN(_aLstOrc) 
	
	DbSelectArea('SUA')
	SUA->(DbSetOrder(1))
	SUA->(DbGoTop())
	IF !SUA->(DbSeek(xFilial('SUA')+_aLstOrc[_nLs]))
		Loop
	ENDIF
	_cDtEntrega := DtoC(Posicione("SUB",1,xFilial("SUB")+SUA->UA_NUM,"UB_DTENTRE"))
	
	_nPag ++
	IF _nPag >= 2
		fVerifLin(.T.,.F.)
	ENDIF 	          
	
	C_XRORCA(_aLstOrc[_nLs])
	I_XRORCA(_aLstOrc[_nLs])
	R_XRORCA(_nLin)
		    	
Next _nLs 
     
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRORCA บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/               
*------------------------------*
Static Function C_XRORCA(_cORc)
*------------------------------*
Local _nLnCb    := 050   
Local cNomeVend	:= Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
Local cEmailVend:= Posicione("SA1",1,xFilial("SA1")+SUA->UA_CLIENTE+SUA->UA_LOJA,"A1_EMAIL")
//Imprimi numero de paginas
oPrn:Say(_nLnCb,2170,OemToAnsi('Pแgina: '+TransForm(_nPag,'@e 99')),oFont08F)
_nLnCb+=050                                                                  
oPrn:Say(_nLnCb,2000,OemToAnsi(DtoC(dDataBase)+' - '+Time()),oFont08F)
_nLnCb-= 030	//050

oPrn:Say(_nLnCb,0150,OemToAnsi(PadR(SM0->M0_NOMECOM,47)),oFont16T) 
_nLnCb+=_NCBLINFO+040

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> CABECALHO
_nIniBx1 := _nLnCb

//Impressao do Box1
//oPrn:Box(320,0100,120,2350) 
oPrn:Box(260,0100,120,2350) 
//Impressao do Box1 - Linha1  
oPrn:Line(120,0555,260,0555)
//Impressao do Box1 - Linha2
oPrn:Line(120,2055,260,2055)

oPrn:Say(_nLnCb+_NCBLINFO,0120,OemToAnsi('ORวAMENTO'),oFont16T) 

_nLnCb+=_NCBLINFO+_NCBLINFO
oPrn:Say(_nLnCb+_NCBLINFO,0220,OemToAnsi(_cORc),oFont16T)
_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0600,OemToAnsi('Endere็o: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(AllTrim(SM0->M0_ENDCOB)),oFont09F)

oPrn:SayBitmap(_nLnCb-19,2090,_cLogo ,_nLnCb+070,105)

_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('Bairro: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(AllTrim(SM0->M0_BAIRCOB)),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Cidade: '),oFont09T)
oPrn:Say(_nLnCb,1400,OemToAnsi(AllTrim(SM0->M0_CIDCOB)+'/'+AllTrim(SM0->M0_ESTCOB)),oFont09F)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('CEP: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(TransForm(SM0->M0_CEPCOB,'@R 99999-999')),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Telefone: '),oFont09T)
oPrn:Say(_nLnCb,1400,OemToAnsi(AllTrim(SM0->M0_TEL)),oFont09F)
//oPrn:Say(_nLnCb,1700,OemToAnsi('Fax.: '),oFont09T)
//oPrn:Say(_nLnCb,1800,OemToAnsi(AllTrim(SM0->M0_FAX)),oFont09F)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('CNPJ: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(TransForm(SM0->M0_CGC,"@R 99.999.999/9999-99")),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Ins.Est.: '),oFont09T)                            
oPrn:Say(_nLnCb,1400,OemToAnsi(TransForm(SM0->M0_INSC,'@R 99.999.999.9999')),oFont09F)
_nLnCb += _NCBLINFO+(_NCBLINFO/2)
_nCol2 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += _NCBLINFO
//oPrn:SayBitmap(_nLnCb,2090,_cLogo ,_nLnCb+065,100)
_nLnCb += _NCBLINFO
_nCol3 := _nLnCb

//Impressao do Box1
_nLnCb := 270
/*
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350) 
//Impressao do Box1 - Linha1  
oPrn:Line(_nIniBx1,0555,_nLnCb,0555)
//Impressao do Box1 - Linha2
oPrn:Line(_nIniBx1,2055,_nLnCb,2055)
*/

_nLnCb+=_NCBLINFO										

DbSelectArea('SUA')
SUA->(DbSetOrder(1))
IF !SUA->(DbSeek(xFilial('SUA')+_cORc))
	Alert('Or็amento nใo localizado, '+ _cORc +'.')  
	Return
EndIF

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ORวAMENTO
oPrn:Say(_nLnCb,120,OemToAnsi('Or็amento'),oFont11T) 
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
_nIniBx1 := _nLnCb

//Impressao do Box2
oPrn:Box(480,0100,315,2350) 

_nLnCb := _nIniBx1
//_nLnCb += (_NCBLINFO/2)
_nLnCb += 10
oPrn:Say(_nLnCb,0150,OemToAnsi('Nบ Or็.Cli: '),oFont09T)
//oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SUA->UA_PEDCLI)),oFont09F)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SUA->UA_PEDCLI)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Cod.Pag.: '),oFont09T)
cDesE4 := AllTrim(Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI"))
if alltrim(SUA->UA_CONDPG) == "900"
	cDesE4 += " - " + iif(!empty(SUA->UA_XDIAS1), alltrim(str(SUA->UA_XDIAS1)), "")
	cDesE4 += iif(!empty(SUA->UA_XDIAS2), "/"+alltrim(str(SUA->UA_XDIAS2)), "")
	cDesE4 += iif(!empty(SUA->UA_XDIAS3), "/"+alltrim(str(SUA->UA_XDIAS3)), "")
	cDesE4 += iif(!empty(SUA->UA_XDIAS4), "/"+alltrim(str(SUA->UA_XDIAS4)), "")
	cDesE4 += " DIAS"
endif
//oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI"))),oFont09F)
oPrn:Say(_nLnCb,0400,OemToAnsi(cDesE4),oFont09F)
//_nLnCb+=_NCBLINFO/1.5
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0400,OemToAnsi('** (Sujeito a analise de cr้dito)'),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Transp.: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SUA->UA_TRANSP)+' - '+PadR(Posicione("SA4",1,xFilial("SA4")+SUA->UA_TRANSP,"A4_NOME"),30)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Vendedor: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(ALLTRIM(cNomeVend)),oFont09F)     //adicionar nome do vendedor (representante do cliente) jแ esta posicionada	Pierre P2P - 30/01/2017
_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,1150,OemToAnsi('Emissใo: '),oFont09T)
oPrn:Say(_nLnCb,1395,OemToAnsi(DtoC(SUA->UA_EMISSAO)),oFont09F)
_nLnCb+=_NCBLINFO
//oPrn:Say(_nLnCb,1150,OemToAnsi('Frete: '),oFont09T)
//aTpFrete := CTBCBOX("UA_TPFRETE")
//oPrn:Say(_nLnCb,1380,OemToAnsi(CTBCBOX("UA_TPFRETE")[Ascan(_aTpFrete,SUA->UA_TPFRETE)]),oFont09F)
//_nLnCb+=_NCBLINFO 
//oPrn:Say(_nLnCb,1150,OemToAnsi('Valor Frete:'),oFont09T)
//oPrn:Say(_nLnCb,1395,OemToAnsi(AllTrim(TransForm(SUA->UA_FRETE,PesqPict('SUA','UA_FRETE')))),oFont09F)
_nLnCb+=_NCBLINFO*2
//oPrn:Say(_nLnCb,1150,OemToAnsi('E-Mail: '),oFont09T)
//oPrn:Say(_nLnCb,1325,OemToAnsi(AllTrim(cEmailVend)),oFont09F)
_nLnCb+=_NCBLINFO
_nCol2 := _nLnCb   

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,1715,OemToAnsi('Prev. Fat: '),oFont09T)
oPrn:Say(_nLnCb,1960,OemToAnsi(_cDtEntrega),oFont09F)
_nLnCb+=_NCBLINFO
//oPrn:Say(_nLnCb,1800,OemToAnsi('Valor Frete:'),oFont09T)
//oPrn:Say(_nLnCb,2100,OemToAnsi(AllTrim(TransForm(SUA->UA_FRETE,PesqPict('SUA','UA_FRETE')))),oFont09F)
//_nLnCb+=_NCBLINFO
_nCol3 := _nLnCb

//Impressao do Box2
_nLnCb := 480
/*
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350) 
_nLnCb += _NCBLINFO
*/
_nLnCb += _NCBLINFO+10

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> CLIENTE
DbSelectArea('SA1')
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial('SA1')+SUA->(UA_CLIENTE+UA_LOJA)))
oPrn:Say(_nLnCb,120,OemToAnsi('Cliente'),oFont11T)                               	
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
_nIniBx1 := _nLnCb

//Impressao do Box3
oPrn:Box(712,0100,544,2350) 
/*
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
_nLnCb += _NCBLINFO
*/

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0150,OemToAnsi('C๓digo: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+PadR(SA1->A1_NOME,35)),oFont09F)
_nLnCb+=_NCBLINFO 
oPrn:Say(_nLnCb,0150,OemToAnsi('Contato'),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(SA1->A1_CONTATO),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Endere็o: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SA1->A1_END)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Cidade: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SA1->A1_MUN)+' - '+AllTrim(SA1->A1_EST)+'/'+AllTrim(SA1->A1_PAIS)),oFont09F)
_nLnCb+=_NCBLINFO                     
oPrn:Say(_nLnCb,0150,OemToAnsi('Cnpj: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(Transform(SA1->A1_CGC,Iif(Len(Alltrim(SA1->A1_CGC))>=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))),oFont09F)

oPrn:Say(_nLnCb,1150,OemToAnsi('E-Mail: '),oFont09T)
oPrn:Say(_nLnCb,1325,OemToAnsi(AllTrim(cEmailVend)),oFont09F)

_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
_nLnCb+=_NCBLINFO

//oPrn:Say(_nLnCb,1150,OemToAnsi('Contato'),oFont09T)
//oPrn:Say(_nLnCb,1395,OemToAnsi(SA1->A1_CONTATO),oFont09F)
//_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Bairro:'),oFont09T)
oPrn:Say(_nLnCb,1395,OemToAnsi(AllTrim(SA1->A1_BAIRRO)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Cep:'),oFont09T)
oPrn:Say(_nLnCb,1395,OemToAnsi(TransForm(SA1->A1_CEP,'@R 99999-999')),oFont09F)
_nLnCb+=_NCBLINFO                     
oPrn:Say(_nLnCb,1150,OemToAnsi('Ins.Est.: '),oFont09T)
oPrn:Say(_nLnCb,1395,OemToAnsi(TransForm(SA1->A1_INSCR,'@R 99.999.999.9999')),oFont09F)
_nLnCb+=_NCBLINFO
_nCol2 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,1760,OemToAnsi('Telefone'),oFont09T)
oPrn:Say(_nLnCb,1960,OemToAnsi(+'('+AllTrim(SA1->A1_DDD)+') '+TransForm(SA1->A1_TEL,"@R 99999-9999")),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1760,OemToAnsi('Celular:'),oFont09T)
oPrn:Say(_nLnCb,1960,OemToAnsi(AllTrim(SA1->A1_TELEX)),oFont09F)
_nLnCb+=_NCBLINFO
_nCol3 := _nLnCb
//Impressao do Box3
_nLnCb := 740
/*
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350) 
_nLnCb += _NCBLINFO
*/

//--Condi็ใo negociada
If SUA->UA_CONDPG == '900'
	_nLnCb += _NCBLINFO
	oPrn:Say(_nLnCb,0120,OemToAnsi('Condi็ใo negociada'),oFont09T)
	_nLnCb += _NCBLINFO
	If !Empty(SUA->UA_XDATA1)
		oPrn:Say(_nLnCb,0120,OemToAnsi(DTOC(SUA->UA_XDATA1)),oFont09T)
	EndIf
	If !Empty(SUA->UA_XDATA2)
		oPrn:Say(_nLnCb,0370,OemToAnsi(DTOC(SUA->UA_XDATA2)),oFont09T)
	EndIf	
	If !Empty(SUA->UA_XDATA3)
		oPrn:Say(_nLnCb,0620,OemToAnsi(DTOC(SUA->UA_XDATA3)),oFont09T)
	EndIf	
	If !Empty(SUA->UA_XDATA4)
		oPrn:Say(_nLnCb,0870,OemToAnsi(DTOC(SUA->UA_XDATA4)),oFont09T)
	EndIf	
	_nLnCb += _NCBLINFO	
	_nLnCb += _NCBLINFO
EndIf

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ITEM
//DbSelectArea('SUB')
//SUB->(DbSetOrder(1))
//SUB->(DbSeek(xFilial('SUB')+SUA->UA_NUM))

oPrn:Say(_nLnCb,120,OemToAnsi('Item(s)'),oFont11T)                               	
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
oPrn:Say(_nLnCb,0120,OemToAnsi('Seq'),oFont09T)
oPrn:Say(_nLnCb,0210,OemToAnsi('C๓digo'),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi('Descri็ใo'),oFont09T)
//oPrn:Say(_nLnCb,1170,OemToAnsi('Un.'),oFont09T)
oPrn:Say(_nLnCb,1220,OemToAnsi('Un.'),oFont09T)
//oPrn:Say(_nLnCb,1100,OemToAnsi('Entrega'),oFont09T)
//oPrn:Say(_nLnCb,1300,OemToAnsi('CFO'),oFont09T)
//oPrn:Say(_nLnCb,1170,OemToAnsi('Pr็ Lista'),oFont09T)
oPrn:Say(_nLnCb,1465,OemToAnsi('Quant.'),oFont09T)
oPrn:Say(_nLnCb,1690,OemToAnsi('Pre็o'),oFont09T)
oPrn:Say(_nLnCb,1920,OemToAnsi('Val.IPI'),oFont09T)
oPrn:Say(_nLnCb,2115,OemToAnsi('Val.Liquido'),oFont09T)      
_nLnCb += _NCBLINFO+(_NCBLINFO/2)
                    
_nLin := _nLnCb
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRORCA บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*------------------------------*
Static Function I_XRORCA(_cORc)
*------------------------------*
_nTItem  := 0
_nTQant  := 0
_nTVlIpi := 0
_nTVlIST := 0
_nTValor := 0 
_nTDesp  := 0
_nTSeg   := 0

_cQry := " SELECT " 
_cQry += "  CASE WHEN SUM(UB_VLRITEM) IS NULL THEN 0 ELSE SUM(UB_VLRITEM) END VALOR, "
_cQry += "  CASE WHEN SUM(UB_QUANT*UB_PRCTAB) IS NULL THEN 0 ELSE SUM(UB_QUANT*UB_PRCTAB) END VALORT, "
_cQry += "  CASE WHEN COUNT(UB_ITEM)  IS NULL THEN 0 ELSE COUNT(UB_ITEM)  END TITEM "
_cQry += "  FROM "+ RetSqlName('SUB') +" (NOLOCK) SUB "
_cQry += "   WHERE SUB.D_E_L_E_T_ <> '*'  "
_cQry += "     AND UB_FILIAL = '"+ xFilial('SUB') +"' "
_cQry += "     AND UB_NUM    = '"+ SUA->UA_NUM +"' "
If Select("_TOT") > 0
	_TOT->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TOT",.F.,.T.) 
DbSelectArea("_TOT")
_TOT->(dbGoTop()) 
_nTotPed := _TOT->VALOR

nPLiqui := 0
nPBruto := 0
nVol3   := 0
nVolCx  := 0

DBselectArea('SUB')
SUB->(DbSetOrder(1))
SUB->(DbGoTop())
SUB->(DbSeek(xFilial('SUB')+SUA->UA_NUM))
While SUB->(!EOF()) .And. SUB->UB_FILIAL==xFilial('SUB') .And. SUB->UB_NUM==SUA->UA_NUM
    
	IF _nTItem > _TOT->TITEM 
		EXIT
	ENDIF

	DbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop()) 
	SB1->(DbSeek(xFilial('SB1')+SUB->UB_PRODUTO))
		
	_nFreteIT := u_PrcFret(_nTotPed, SUB->UB_VLRITEM, SUA->UA_FRETE)    

	//Inicio do processo Fiscal
///	MaFisIni(SUA->UA_CLIENTE, SUA->UA_LOJA,IIf('N'$'DB',"F","C"),'N',SA1->A1_TIPO,,,,,"MATA461")
///	MaFisAdd(SUB->UB_PRODUTO, SUB->UB_TES, SUB->UB_QUANT, SUB->UB_VRUNIT, 0, "", "", 0, 0, 0, 0, 0, (SUB->UB_VLRITEM+_nFreteIT), 0, 0, 0)

	MaFisIni(	SUA->UA_CLIENTE,;
				SUA->UA_LOJA,;	// 2-Loja do Cliente/Fornecedor
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
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				Nil,,,Nil,Nil,Nil,Nil,,Nil)
                                                             				                        	                        
	MaFisAdd(	SUB->UB_PRODUTO,;
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
	            (SUB->UB_VLRITEM+_nFreteIT),;
	            0,;
	            0,;
	            0)

	_nAliqIcm  := MaFisRet(1,"IT_ALIQICM")
    _nValIcm   := MaFisRet(1,"IT_VALICM" )
    _nBaseIcm  := MaFisRet(1,"IT_BASEICM")
    _nValIpi   := MaFisRet(1,"IT_VALIPI" )
    _nBaseIpi  := MaFisRet(1,"IT_BASEICM")
    //_nValMerc  := SUB->UB_VLRITEM//MaFisRet(1,"IT_VALMERC")              
    _nValMerc  := iif(!empty(SUA->UA_DESCONT),Round(SUB->UB_QUANT*SUB->UB_PRCTAB, 2), SUB->UB_VLRITEM)
    _nValSol   := MaFisRet(1,"IT_VALSOL" )
	_nDescTot  := MaFisRet(,"NF_DESCONTO")           
    _nNfTotal  := MaFisRet(,"NF_TOTAL")
    _nBaseDup  := MaFisRet(,"NF_BASEDUP")
    MaFisEnd()
    
	//Fim do processo Fiscal
	fVerifLin(, .T.)
	              
	//Preco de lista utilizado pelo TGV
	_nXTABPRC := u_xTabPrc(SUA->UA_CLIENTE, SUA->UA_LOJA, SUB->UB_PRODUTO)
	
	oPrn:Say(_nLin,0120,OemToAnsi(SUB->UB_ITEM),oFont08F)
	oPrn:Say(_nLin,0210,OemToAnsi(PadR(SUB->UB_PRODUTO,10)),oFont08F)
	
	lTemF1 := .F.
	lTemF3 := .F.
	/*DBSELECTAREA("SB2")
	SB2->(DbSetOrder(1))
	SB2->(Dbseek(Xfilial("SB2")+SUB->UB_PRODUTO+'01'))
	iF  SUB->UB_QUANT > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)  
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,38)+'(F)'),oFont08F)
	ELSE
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,40)),oFont08F)
	ENDIF*/
	SB2->(DbSetOrder(1))
	SB2->(Dbseek(Xfilial("SB2")+SUB->UB_PRODUTO+'01'))
	iF  SUB->UB_QUANT > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)
		lTemF1 := .T.
	endif
	SB2->(Dbseek(Xfilial("SB2")+SUB->UB_PRODUTO+'03'))
	iF  SUB->UB_QUANT > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)
		lTemF3 := .T.
	endif
	if lTemF1 .and. lTemF3
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,38)+'(F)'),oFont08F)
	else
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,40)),oFont08F)
	endif
	
	oPrn:Say(_nLin,1220,OemToAnsi(SB1->B1_UM),oFont08F)
	//oPrn:Say(_nLin,1100,OemToAnsi(DtoC(SUB->UB_DTENTRE)),oFont08F)
	//oPrn:Say(_nLin,1300,OemToAnsi(SUB->UB_CF),oFont08F)
	//oPrn:Say(_nLin,1030,OemToAnsi(TransForm(_nXTABPRC,PesqPict('SC6','C6_VALOR'))),oFont08F)	                                         
	oPrn:Say(_nLin,1450,OemToAnsi(TransForm(SUB->UB_QUANT	,"99,999" )),oFont08F)
	//oPrn:Say(_nLin,1630,OemToAnsi(TransForm(SUB->UB_VRUNIT	,PesqPict('SUB','UB_VRUNIT' ))),oFont08F)
	oPrn:Say(_nLin,1630,OemToAnsi(TransForm(iif(!empty(SUA->UA_DESCONT),SUB->UB_PRCTAB,SUB->UB_VRUNIT)	,PesqPict('SUB','UB_VRUNIT' ))),oFont08F)
	oPrn:Say(_nLin,1890,OemToAnsi(TransForm(_nValIpi		,PesqPict('SUB','UB_VLRITEM'))),oFont08F)
	oPrn:Say(_nLin,2170,OemToAnsi(TransForm(_nValMerc		,PesqPict('SUB','UB_VLRITEM'))),oFont08F)
	_nLin += _NCBLINFO
    
	_nTItem  ++
 	_nTQant  += SUB->UB_QUANT
	_nTVlIpi += _nValIpi
	_nTVlIST += _nValSol
	_nTValor += (_nValMerc-_nDescTot) 

	nPLiqui += ( SUB->UB_QUANT * SB1->B1_PESO )
	nPBruto += ( SUB->UB_QUANT * SB1->B1_PESBRU )
	//nVol3   += Round(SUB->UB_QUANT * SB1->B1_XALTURA * SB1->B1_XLARG * SB1->B1_XCOMPR,4)   	
	nVol3   += Round(SUB->UB_QUANT * SB1->B1_XVOL,4)   	
	nVolCx  += SUB->UB_QUANT

	SUB->(DbSkip())
EndDo

fVerifLin(, .T.)
_nLin += (_NCBLINFO/2)
//oPrn:Line(_nLin,0800,_nLin,2340)
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO	//(_NCBLINFO/2)
oPrn:Say(_nLin,0800,OemToAnsi('Total Or็amento: '+StrZero(_nTItem,2)),oFont09T)
oPrn:Say(_nLin,1350,OemToAnsi(TransForm(_nTQant, "999,999" /* PesqPict('SUB','UB_VRUNIT')*/)),oFont09T)
oPrn:Say(_nLin,1860,OemToAnsi(TransForm(_nTVlIpi,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
oPrn:Say(_nLin,2130,OemToAnsi(TransForm(_nTValor,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
_nLin += _NCBLINFO+(_NCBLINFO/2)

fVerifLin(, .T.)
//oPrn:Say(_nLin,1450,OemToAnsi('Valor Seguro: '),oFont09T)
//oPrn:Say(_nLin,2130,OemToAnsi(TransForm(SC5->C5_SEGURO,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
//_nLin += _NCBLINFO
//oPrn:Say(_nLin,1450,OemToAnsi('Valor Frete: '),oFont09T)
//oPrn:Say(_nLin,2130,OemToAnsi(TransForm(SUA->UA_FRETE,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
//_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor ICMS Substitui็ใo: '),oFont09T)
oPrn:Say(_nLin,2130,OemToAnsi(TransForm(_nTVlIST,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor Desp.Acess๓rias: '),oFont09T)
oPrn:Say(_nLin,2130,OemToAnsi(TransForm(SC5->C5_DESPESA,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor Desconto: '),oFont09T)
oPrn:Say(_nLin,2130,OemToAnsi(TransForm(SUA->UA_DESCONT,PesqPict('SUB','UB_VLRITEM'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('TOTAL ORวAMENTO: '),oFont09T)
oPrn:Say(_nLin,2130,OemToAnsi(TransForm((SUA->UA_FRETE + _nTValor + _nTDesp + _nTSeg +_nTVlIST - SUA->UA_DESCONT + _nTVlIpi),PesqPict('SUB','UB_VLRITEM'))),oFont09T)
_nLin += _NCBLINFO
//oPrn:Line(_nLin,0800,_nLin,2340)
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO

//Impressao do Box Volumes
oPrn:Box(_nLin+100,0100,_nLin,2350) 

oPrn:Line(_nLin,0755,_nLin+100,0755)
oPrn:Line(_nLin,1210,_nLin+100,1210)
oPrn:Line(_nLin,1665,_nLin+100,1665)

_nLin += 25
oPrn:Say(_nLin,0300,OemToAnsi('VOL. mณ'),oFont09T)
oPrn:Say(_nLin,0820,OemToAnsi('VOL. CAIXAS'),oFont09T)
oPrn:Say(_nLin,1310,OemToAnsi('PESO BRUTO'),oFont09T)
oPrn:Say(_nLin,1750,OemToAnsi('PESO LIQUIDO'),oFont09T)

_nLin += 50
oPrn:Say(_nLin,0420,OemToAnsi(Transform(nVol3,PesqPict('SUB','UB_QUANT'))),oFont09T)
oPrn:Say(_nLin,0940,OemToAnsi(Transform(nVolCx,PesqPict('SUB','UB_QUANT'))),oFont09T)
oPrn:Say(_nLin,1430,OemToAnsi(Transform(nPBruto,PesqPict('SUB','UB_QUANT'))),oFont09T)
oPrn:Say(_nLin,1870,OemToAnsi(Transform(nPLiqui,PesqPict('SUB','UB_QUANT'))),oFont09T)

_nLin += _NCBLINFO + 25	//100

Return                          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRORCA บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*--------------------------*
Static Function fVerifLin(_lSalt, _lCab)
*--------------------------*    
Default _lSalt := .F.
Default _lCab  := .F.
/**************************************** VALIDAวรO DE LINHAS ****************************************/ 
IF _nLin > _NPULALIN .Or. _lSalt
	oPrn:EndPage()
	oPrn:StartPage()
	_nPag ++               
	IF _lCab
		C_XRORCA(SUA->UA_NUM)	
	ENDIF
ENDIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ R_XRORCA บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Or็amento...                             นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/                        
*-------------------------------*
Static Function R_XRORCA(_nLin)
*-------------------------------*
Local _nX

IF _nLin > _NRODAPE
	fVerifLin(.T.,.T.)	
EndIF

_nLin := _NRODAPE
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO/2
oPrn:Say(_nLin,120,OemToAnsi('Anota็๕es'),oFont09T)                               	
_nLin += _NCBLINFO+(_NCBLINFO/2)
//oPrn:Say(_nLin,120,OemToAnsi('Or็amento Vแlido: '+DtoC(SUA->UA_EMISSAO+GetMv('LB_TGVDIAE',.F.,7)))/*+' Faturar dia 23/10 e Entrega Agendada para dia 25/10'*/,oFont08F)                               	
oPrn:Say(_nLin,120,OemToAnsi('Or็amento Vแlido para data da emissใo e disp. de estoque '),oFont08F)                               	
_nLin += _NCBLINFO+(_NCBLINFO/2)
_aTpFrete := CTBCBOX("UA_TPFRETE")

oPrn:Say(_nLin,120,OemToAnsi('OBS. DE ENTREGA: '),oFont08F)  
_nLin += _NCBLINFO+(_NCBLINFO/2)
_cMsgComen := AllTrim(SUA->UA_XOBSLO)
IF !Empty(_cMsgComen)
	_nQtdLMemo := 100
	_nLinhas := MlCount(_cMsgComen,_nQtdLMemo)
	For _nX:=1 To _nLinhas
		oPrn:Say(_nLin,120,OemToAnsi(MemoLine(_cMsgComen,_nQtdLMemo,_nX)),oFont08F) 
		_nLin += _NCBLINFO
	Next _nX
	_nLin += (_NCBLINFO/2)
ENDIF

//EndIF
//oPrn:Say(_nLin,120,OemToAnsi('ENTREGA: '+SA1->A1_ENDENT+iIF(!Empty(SA1->A1_BAIRROE),', ','')+SA1->A1_BAIRROE+iIF(!Empty(SA1->A1_ESTE),', ','')+SA1->A1_ESTE),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)
//oPrn:Say(_nLin,120,OemToAnsi('1) PREวOS FOB'),oFont08F)

oPrn:Say(_nLin,120,OemToAnsi('1) CONDICAO DE PAGTO:'+AllTrim(Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI")) + '(SUJEITO A ANALISE DE CREDITO'),oFont08F)
_nLin += _NCBLINFO
//oPrn:Say(_nLin,120,OemToAnsi('2) NO CASO DE VENDA PARA REVEDAS, A SUBSTITUIวรO TRIBUTมRIA INCIDENTE EM SERINGAS, AGULHAS, ETC, SERม COBRADO NA NF'),oFont08F)
oPrn:Say(_nLin,120,OemToAnsi('2) VALIDADE: 48 hrs'),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('3) PEDIDO MINIMO: R$ 1.300,00 '),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('4) FRETE : CIF/FOB(DEPENDE DA REGIAO'),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('5) REDESPACHO A PARTIR DE SP POR CONTA DO CLIENTE.'),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('6) NรO ATENDEMOS CONSUMIDOR FINAL.'),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)
oPrn:Say(_nLin,120,OemToAnsi('OBRIGADO POR COTAR CONOSCO.'),oFont08F)
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO+_NCBLINFO


/*

oPrn:Say(_nLin,120,OemToAnsi('1) PREวOS FOB'),oFont08F)  
_nLin += _NCBLINFO+(_NCBLINFO/2)
oPrn:Say(_nLin,120,OemToAnsi('2) NO CASO DE VENDA PARA REVENDAS, A SUBSTITUIวรO TRIBUTมRIA INCIDENTE EM SERINGAS, AGULHAS, ETC, SERม COBRADO NA NF'),oFont08F)  
_nLin += _NCBLINFO+(_NCBLINFO/2)
oPrn:Say(_nLin,120,OemToAnsi('3) NO CASO DE VENDA PARA CONSUMIDOR FINAL NรO CONTRIBUINTE DO ICMS, SERม COBRADO ANTECIPADAMENTE A ALอQUOTA DE ICMS '),oFont08F)  
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('   DA COMPRA NรO PRESENCIAL NAS VENDAS PARA ESTADOS QUE ADOTAM ESTA MODALIDADE.'),oFont08F)
_nLin += _NCBLINFO
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO+_NCBLINFO

*/
	
oPrn:Say(_nLin,0300,OemToAnsi('AUTORIZADO POR:______________________________________________'),oFont08F)
oPrn:Say(_nLin,1800,OemToAnsi('DATA: ___/___/___'),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,850,OemToAnsi('( Nome por Extenso )'),oFont06F)
_nLin += _NCBLINFO+_NCBLINFO
oPrn:Say(_nLin,0700,OemToAnsi('Assinatura / Carimbo:______________________________________________'),oFont08F)
_nLin += _NCBLINFO+_NCBLINFO
oPrn:Line(_nLin,0120,_nLin,2340)	

Return

*---------------------------*
User Function xAcessoUA(_cUA)
*---------------------------*
Local _lRet := .F.
Default _cUA := ''           

DbSelectArea('SUA')
SUA->(DbSetOrder(1))
SUA->(DbGoTop())
	
DbSelectArea('SA1')
SA1->(DbSetOrder(1))                     
SA1->(DbGoTop())
	
DbSelectArea('SA3')
SA3->(DbSetOrder(1))
SA3->(DbGoTop())
	           
IF SUA->(DbSeek(xFilial('SC5')+_cUA))
	IF SA1->(DbSeek(xFilial('SA1')+SUA->UA_CLIENTE+SUA->UA_LOJA))
		IF SA3->(DbSeek(xFilial('SA3')+SA1->A1_VEND))
			IF __cUserID $ SA3->A3_CODUSR+'/'+AllTrim(GetMv('LI_USRXVND',.F.,'000000'))+'/'+Posicione('SA3',1,xFilial('SA3')+SUA->UA_VEND,'A3_CODUSR')
				_lRet := .T.
			ENDIF
		EndIF
	EndIF
EndIF
	
Return(_lRet)
