#Include "RWMAKE.CH"
#INCLUDE "colors.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#DEFINE  ENTER CHR(13)+CHR(10)
#DEFINE  _NRODAPE 2200

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ IVENR020 บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                              บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//DESENVOLVIDO POR INOVEN

*---------------------------*
User Function IVENR020(_nOpc,_cTipo)
*---------------------------*
Default _nOpc     := 0
Default _cTipo    := 'V'
Private _lImpAuto := iIF(_nOpc==1,.T.,.F.)

/*** FONTES ***/
Private oFont16T  	:= TFont():New("Arial",,16,,.T.,,,,,.F.)
Private oFont14TI  	:= TFont():New("Arial",,13,,.T.,,,,.T.,.F.)
Private oFont11T  	:= TFont():New("Courier New",,11,,.T.,,,,,.F.)
Private oFont09T  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)
Private oFont09F  	:= TFont():New("Courier New",,09,,.T.,,,,,.F.)
Private oFont08F  	:= TFont():New("Courier New",,08,,.T.,,,,,.F.)
Private oFont08T  	:= TFont():New("Courier New",,08,,.T.,,,,,.F.)
Private oFont06F  	:= TFont():New("Courier New",,06,,.T.,,,,,.F.)
Private oFont07F  	:= TFont():New("Courier New",,06,,.T.,,,,,.F.)
/*** ABRE FOLHA ***/
Private oPrn      	:= TMSPrinter():New()

/*** IMAGENS ***/
Private _cLogo    	:= FisxLogo("1")
Private Titulo    	:= SM0->M0_NOMECOM

Private _aOS:={}

/*** PERGUNTA ***/
Private cPerg1 	  	:= 'XRPVEND'
PutSx1(cPerg1,"01","Pedido de Venda:","Pedido de Venda:","Pedido de Venda:","mv_ch01","C",06,00,00,"G","","SC52","","","mv_par01","","","","","","","","","","","","","","","","")

IF !_lImpAuto
	IF !Pergunte(cPerg1,.T.)
		Return
	EndIf
Else
	Private MV_PAR01 := SC5->C5_NUM
ENDIF

// Renato Bandeira em 28/01/15 - Area comercial nao irao imprimir, apenas a logistica
/*/
IF !u_xAcessoC5(MV_PAR01)
	MsgInfo('Pedido de Venda nใo pertence a carteira do vendedor!')
	Return
EndIF
/*/
// Renato Bandeira em 28/01/15 - Verifica se ja foi impresso, Jah estara posicionado
//If 	SC5->C5_XSTATUS	== '000009'		.AND.	! MsgYesNo("PEDIDO JA IMPRESSO, REIMPRIME ?")
// Renato Bandeira em 12/02/15 - Verifica se ja foi impresso  atraves do campo Quantidade impressa
/*
SE4->(DbSetOrder(01)) 
IF SE4->(DbSeek(xFilial('SE4')+SC5->C5_CONDPAG))  
	If "BON" $ SE4->E4_DESCRI
		If 	SC5->C5_XQTIMPV > 0 .AND. _cTipo=='G'
			If !(__cUserID $ GetMV('LI_410LIB2',.F.,'000000') .Or. __cUserID == '000000' )
				ALERT("PEDIDO BONIFICAวรO. SOLICITE O GERENCIA/DIRETORIA A IMPRESSรO!!!")
				RETURN	
			ENDIF
		Endif   
	Else
		If 	SC5->C5_XQTIMPV > 0 .AND. _cTipo=='V'	//! MsgYesNo("PEDIDO JA IMPRESSO "+STRZERO(SC5->C5_XQTIMPV,2)+" VEZ(ES), REIMPRIME ?")
			ALERT("PEDIDO JA IMPRESSO "+STRZERO(SC5->C5_XQTIMPV,2)+" VEZ(ES). SOLICITE O GERENTE A RE-IMPRESSรO!!!")
			RETURN
		ElseIf 	SC5->C5_XQTIMPV > 0 .AND. _cTipo=='G'
			If !(__cUserID $ GetMV('LI_410LIB2',.F.,'000000') .Or. __cUserID == '000000' )
				ALERT("PEDIDO JA IMPRESSO "+STRZERO(SC5->C5_XQTIMPV,2)+" VEZ(ES). SOLICITE O GERENCIA/DIRETORIA A RE-IMPRESSรO!!!")
				RETURN	
			ENDIF
		Endif                	             
	EndIf
EndIf
*/

if _nOpc == 3//status do pedido
	U_ICADA040(,,,.F.)// fonte MA410MNU

ELSE	
		
oPrn:SetPortrait() //Retrato
/** oPrn:SetLandscape() // Paisagem() **/
oPrn:StartPage()

Private lEnd := .F.

FWMsgRun(, {|| XRORCA_2(MV_PAR01) }, "Aguarde...", "Imprimindo relat๓rio...")

oPrn:EndPage()
oPrn:Setup()
oPrn:Preview()
MS_FLUSH()   

ENDIF


	// Renato Bandeira em 28/01/2015 - Atualiza Status de impresso
//	u_DnyGrvSt(SC5->C5_NUM, "000009")
	// Renato Bandeira em 12/02/2015 - Atualiza Quantidade Impressa
//    IF SC5->(RecLock("SC5",.F.))
//		SC5->C5_XQTIMPV	:=	SC5->C5_XQTIMPV + 1
//    	SC5->(MSUNLOCK())		    
//  	ENDIF 

/*  	
	//If cFilAnt=="0502"	
		dbSelectArea("SC9")
		SC9->(dbGoTop())
		SC9->(DBSEEK(XFILIAL("SC5")+SC5->C5_NUM))
		WHILE SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO							                     
		     If XFILIAL("SC5")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO      
					SC9->(RECLOCK("SC9",.F.))
					SC9->C9_BLEST  := "  "
					SC9->(MSUNLOCK())							        
		     EndIf	      
		     SC9->(dbSkip())
		EndDo  								
	//EndIf  	
*/  	

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRPVEND บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*---------------------------------*
Static Function XRORCA_2(MV_PAR01)
*---------------------------------*
Local _nLs
/*** VARIAVEIS DO SISTEMA ***/
Private _NPULALIN   := 2700
Private _nLin     	:= 0
Private _nBxInfo    := 0
Private _nPag     	:= 0
Private _NCBLINFO   := 40

Private _aLstPv    := {}

/* LISTA ITENS DO ORวAMENTO */
// Renato Bandeira em 28/01/15 - Trata o status do pedido, se ja impresso
_cQryPAM := " SELECT C5_NUM AS 'PVEND' , C5_XSTATUS "
_cQryPAM += " FROM "+ RetSqlName('SC5') +" SC5  "
_cQryPAM += " WHERE SC5.D_E_L_E_T_ <> '*' "
_cQryPAM += " AND C5_FILIAL = '"+ xFilial('SC5') +"' "
_cQryPAM += " AND C5_NUM    = '"+ MV_PAR01 +"' "
_cQryPAM += " ORDER BY C5_NUM "

If Select("_LIB") > 0
	_LIB->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQryPAM),"_LIB",.F.,.T.)
DbSelectArea("_LIB")
_LIB->(DbGoTop())

DO While !_LIB->(Eof())
	aADD(_aLstPv, _LIB->PVEND )
	_LIB->(DbSkip())
EndDo

FOR _nLs:=1 TO LEN(_aLstPv)
	
	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	IF !SC5->(DbSeek(xFilial('SC5')+_aLstPv[_nLs]))
		Loop
	ENDIF
	
	_nPag ++
	IF _nPag >= 2
		fVerifLin(.T.,.F.)
	ENDIF
	
	C_XRORCA(_aLstPv[_nLs])
	
	I_XRORCA(_aLstPv[_nLs])
	
	R_XRORCA(_nLin)
	
	// Renato Bandeira em 28/01/2015 - Atualiza Status de impresso
	u_DnyGrvSt(SC5->C5_NUM, "000009")
	// Renato Bandeira em 12/02/2015 - Atualiza Quantidade Impressa
    SC5->(RecLock("SC5",.F.))
	SC5->C5_XQTIMPV	:=	SC5->C5_XQTIMPV + 1
    SC5->(MSUNLOCK())		    


	
Next _nLs

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRPVEND บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*------------------------------*
Static Function C_XRORCA(_cPV)
*------------------------------*
Local _nLnCb    := 050

//Imprimi numero de paginas
oPrn:Say(_nLnCb,2170,OemToAnsi('Pแgina: '+TransForm(_nPag,'@e 99')),oFont08F)
_nLnCb+=050
oPrn:Say(_nLnCb,2000,OemToAnsi(DtoC(dDataBase)+' - '+Time()),oFont08F)
_nLnCb-=050

oPrn:Say(_nLnCb,0150,OemToAnsi(PadR(SM0->M0_NOMECOM,47)),oFont16T)
_nLnCb+=_NCBLINFO+040

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> CABECALHO
_nIniBx1 := _nLnCb

oPrn:Say(_nLnCb+_NCBLINFO,0180,OemToAnsi('PEDIDO'),oFont16T)
_nLnCb+=_NCBLINFO+_NCBLINFO
oPrn:Say(_nLnCb+_NCBLINFO,0220,OemToAnsi(_cPV),oFont16T)
_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0600,OemToAnsi('Endere็o: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(AllTrim(SM0->M0_ENDCOB)),oFont09F)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('Bairro.: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(AllTrim(SM0->M0_BAIRCOB)),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Cidade.: '),oFont09T)
oPrn:Say(_nLnCb,1400,OemToAnsi(AllTrim(SM0->M0_CIDCOB)+'/'+AllTrim(SM0->M0_ESTCOB)),oFont09F)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('CEP.: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(TransForm(SM0->M0_CEPCOB,'@R 99999-999')),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Telefone: '),oFont09T)
oPrn:Say(_nLnCb,1400,OemToAnsi(AllTrim(SM0->M0_TEL)),oFont09F)
oPrn:Say(_nLnCb,1700,OemToAnsi('Fax.: '),oFont09T)
oPrn:Say(_nLnCb,1900,OemToAnsi(AllTrim(SM0->M0_FAX)),oFont09F)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,0600,OemToAnsi('CNPJ.: '),oFont09T)
oPrn:Say(_nLnCb,0800,OemToAnsi(TransForm(SM0->M0_CGC,"@R 99.999.999/9999-99")),oFont09F)
oPrn:Say(_nLnCb,1200,OemToAnsi('Ins.Est.: '),oFont09T)
oPrn:Say(_nLnCb,1400,OemToAnsi(TransForm(SM0->M0_INSC,'@R 99.999.999.9999')),oFont09F)
_nLnCb += _NCBLINFO+(_NCBLINFO/2)
_nCol2 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += _NCBLINFO
oPrn:SayBitmap(_nLnCb,2090,_cLogo ,_nLnCb+065,100)
_nLnCb += _NCBLINFO
_nCol3 := _nLnCb

//Impressao do Box1
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350)
//Impressao do Box1 - Linha1
oPrn:Line(_nIniBx1,0555,_nLnCb,0555)
//Impressao do Box1 - Linha2
oPrn:Line(_nIniBx1,2055,_nLnCb,2055)

_nLnCb+=_NCBLINFO

DbSelectArea('SC5')
SC5->(DbSetOrder(1))
IF !SC5->(DbSeek(xFilial('SC5')+_cPV))
	Alert('Pedido de Venda nใo localizado, '+ _cPV +'.')
	Return
EndIF

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ORวAMENTO
oPrn:Say(_nLnCb,120,OemToAnsi('Ped.Venda'),oFont11T)
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
_nIniBx1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0150,OemToAnsi('Nบ PV Cli: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SC5->C5_PEDCLI)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Cod.Pag.: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))),oFont09F)
//_nLnCb+=_NCBLINFO/1.5
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0400,OemToAnsi('** (Sujeito a analise de cr้dito)'),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Transp.: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SC5->C5_TRANSP)+' - '+PadR(Posicione("SA4",1,xFilial("SA4")+SC5->C5_TRANSP,"A4_NOME"),30)),oFont09F)
_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,1150,OemToAnsi('Emissใo: '),oFont09T)
oPrn:Say(_nLnCb,1380,OemToAnsi(DtoC(SC5->C5_EMISSAO)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Frete: '),oFont09T)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Valor Frete:'),oFont09T)
_nLnCb-=_NCBLINFO

//_aTpFrete := CTBCBOX("C5_TPFRETE")
//oPrn:Say(_nLnCb,1380,OemToAnsi(CTBCBOX("C5_TPFRETE")[Ascan(_aTpFrete,SC5->C5_TPFRETE)]),oFont09F)
DbSelectArea('SUA')
SUA->(DbSetOrder(8))
SUA->(DbGoTop())
IF SUA->(DbSeek(xFilial('SUA')+SC5->C5_NUM))
	_aTpFrete := CTBCBOX("UA_XTPFRET")
	oPrn:Say(_nLnCb,1380,OemToAnsi(CTBCBOX("UA_XTPFRET")[Ascan(_aTpFrete,SUA->UA_XTPFRET)]),oFont09F)
Else
	_aTpFrete := CTBCBOX("C5_TPFRETE")
	oPrn:Say(_nLnCb,1380,OemToAnsi(CTBCBOX("C5_TPFRETE")[Ascan(_aTpFrete,SC5->C5_TPFRETE)]),oFont09F)
EndIF
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1380,OemToAnsi(AllTrim(TransForm(SC5->C5_FRETE,PesqPict('SC5','C5_FRETE')))),oFont09F)
_nLnCb+=_NCBLINFO
_nCol2 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,1800,OemToAnsi('Entrega: '),oFont09T)
oPrn:Say(_nLnCb,2100,OemToAnsi(DTOC(SC5->C5_FECENT)),oFont09F)
_nLnCb+=_NCBLINFO
//oPrn:Say(_nLnCb,1800,OemToAnsi('Valor Frete:'),oFont09T)
//oPrn:Say(_nLnCb,2100,OemToAnsi(AllTrim(TransForm(SC5->C5_FRETE,PesqPict('SC5','C5_FRETE')))),oFont09F)
_nLnCb+=_NCBLINFO
_nCol3 := _nLnCb

//Impressao do Box2
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350)
_nLnCb += _NCBLINFO

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> CLIENTE
DbSelectArea('SA1')
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial('SA1')+SC5->(C5_CLIENTE+C5_LOJACLI)))
oPrn:Say(_nLnCb,120,OemToAnsi('Cliente'),oFont11T)
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
_nIniBx1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0150,OemToAnsi('C๓digo: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(SA1->A1_COD+'/'+SA1->A1_LOJA+' - '+PadR(SA1->A1_NOME,35)),oFont09F)
_nLnCb+=_NCBLINFO
//oPrn:Say(_nLnCb,0150,OemToAnsi('Grp. Cli: '),oFont09T)
//_aTpcLI := CTBCBOX("A1_TIPO")
//oPrn:Say(_nLnCb,0400,OemToAnsi(_aTpcLI[Ascan(_aTpcLI,SA1->A1_TIPO)]),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Endere็o: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SA1->A1_END)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Cidade: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(AllTrim(SA1->A1_MUN)+' - '+AllTrim(SA1->A1_EST)+'/'+AllTrim(SA1->A1_PAIS)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi('Cnpj: '),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi(Transform(SA1->A1_CGC,Iif(Len(Alltrim(SA1->A1_CGC))>=14,"@R 99.999.999/9999-99","@R 999.999.999-99"))),oFont09F)
_nLnCb+=_NCBLINFO
_nCol1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Contato'),oFont09T)
oPrn:Say(_nLnCb,1380,OemToAnsi(SA1->A1_CONTATO),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Bairro:'),oFont09T)
oPrn:Say(_nLnCb,1380,OemToAnsi(AllTrim(SA1->A1_BAIRRO)),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Cep:'),oFont09T)
oPrn:Say(_nLnCb,1380,OemToAnsi(TransForm(SA1->A1_CEP,'@R 99999-999')),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1150,OemToAnsi('Ins.Est.: '),oFont09T)
oPrn:Say(_nLnCb,1380,OemToAnsi(TransForm(SA1->A1_INSCR,'@R 99.999.999.9999')),oFont09F)
_nLnCb+=_NCBLINFO
_nCol2 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
_nLnCb += _NCBLINFO
oPrn:Say(_nLnCb,1800,OemToAnsi('Telefone'),oFont09T)
oPrn:Say(_nLnCb,2000,OemToAnsi(+'('+AllTrim(SA1->A1_DDD)+') '+TransForm(SA1->A1_TEL,"@R 99999-9999")),oFont09F)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,1800,OemToAnsi('Fax:'),oFont09T)
oPrn:Say(_nLnCb,2000,OemToAnsi(AllTrim(SA1->A1_FAX)),oFont09F)
_nLnCb+=_NCBLINFO
_nCol3 := _nLnCb

//Impressao do Box3
_nLnCb := iIF(_nCol1>_nCol2, iIF(_nCol1>_nCol3,_nCol1,_nCol3), iIF(_nCol2>_nCol3,_nCol2,_nCol3))
oPrn:Box(_nLnCb,0100,_nIniBx1,2350)
_nLnCb += _NCBLINFO

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> REPRESENTANTE / VENDEDOR
oPrn:Say(_nLnCb,120,OemToAnsi('Representante / Vendedor'),oFont11T)
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
_nIniBx1 := _nLnCb

_nLnCb := _nIniBx1
_nLnCb += (_NCBLINFO/2)
oPrn:Say(_nLnCb,0150,OemToAnsi('C๓digo:'),oFont09T)
oPrn:Say(_nLnCb,0500,OemToAnsi('Razใo Social do Representante'),oFont09T)
_nLnCb+=_NCBLINFO
oPrn:Say(_nLnCb,0150,OemToAnsi(AllTrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_COD"))),oFont09F)
oPrn:Say(_nLnCb,0500,OemToAnsi(AllTrim(Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME"))),oFont09F)
_nLnCb+=_NCBLINFO

//Impressao do Box4
oPrn:Box(_nLnCb,0100,_nIniBx1,2350)
_nLnCb += _NCBLINFO

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ITEM


//DbSelectArea('SC6')   // eliminado gesser
//SC6->(DbSetOrder(1))  // eliminado gesser
//SC6->(DbSeek(xFilial('SC6')+SC5->C5_NUM))   // eliminado gesser

oPrn:Say(_nLnCb,120,OemToAnsi('Item(s)'),oFont11T)
_nLnCb += _NCBLINFO+(_NCBLINFO/4)
oPrn:Say(_nLnCb,0120,OemToAnsi('Seq'),oFont09T)
oPrn:Say(_nLnCb,0210,OemToAnsi('C๓digo'),oFont09T)
oPrn:Say(_nLnCb,0400,OemToAnsi('Descri็ใo'),oFont09T)
//oPrn:Say(_nLnCb,1180,OemToAnsi('Un.'),oFont09T)
//oPrn:Say(_nLnCb,1100,OemToAnsi('Entrega'),oFont09T)
//oPrn:Say(_nLnCb,1300,OemToAnsi('CFO'),oFont09T)
//oPrn:Say(_nLnCb,1150,OemToAnsi('Pr็ Lista'),oFont09T)
oPrn:Say(_nLnCb,1465,OemToAnsi('Quant.'),oFont09T)
oPrn:Say(_nLnCb,1690,OemToAnsi('Pre็o'),oFont09T)
oPrn:Say(_nLnCb,1920,OemToAnsi('Val.IPI'),oFont09T)
oPrn:Say(_nLnCb,2115,OemToAnsi('Val.Liquido'),oFont09T)
_nLnCb += _NCBLINFO+(_NCBLINFO/2)

_nLin := _nLnCb
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRPVEND บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Uso especifico                                          บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*------------------------------*
Static Function I_XRORCA(_cPV)
*------------------------------*
Local _nPr
_nTItem  := 0
_nTQant  := 0
_nTVlIpi := 0
_nTValor := 0
_nTDesp  := 0
_nTIcmSb := 0
_nTSeg   := 0
_nTVlIST := 0

_nBaseDup := 0
_nValSol  := 0

//Cubagem
nPLiqui := 0
nPBruto := 0
nVol3   := 0
nVolCx  := 0

nDesSUA := 0
SUA->(dbSetOrder(1))
if SUA->(msSeek(xFilial('SUA') + SC5->C5_XNUMORC))
	nDesSUA := SUA->UA_DESCONT	//desconto no valor total
endif

_cQry := " SELECT CASE WHEN SUM(C6_VALOR) IS NULL THEN 0 ELSE SUM(C6_VALOR) END VALOR "
_cQry += "  FROM "+ RetSqlName('SC6') +" (NOLOCK) SC6 "
_cQry += "   WHERE SC6.D_E_L_E_T_ <> '*'  "
_cQry += "     AND C6_FILIAL = '"+ xFilial('SC6') +"' "
_cQry += "     AND C6_NUM    = '"+ _cPV +"' "  // gesser
//_cQry += "     AND C6_NUM    = '"+ SC5->C5_NUM +"' "
If Select("_TOT") > 0
	_TOT->(DbCloseArea())
EndIf
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQry),"_TOT",.F.,.T.)
DbSelectArea("_TOT")
_TOT->(dbGoTop())
_nTotPed := _TOT->VALOR

DBSELECTAREA("SC6")          // gesser
DBSETORDER(1)                // gesser
DBSEEK(xFilial("SC6")+_cPV)  // gesser


While !EOF() .And. SC6->C6_FILIAL == xFilial('SC6') .And. SC6->C6_NUM == _cPV   // gesser
	
	_nFreteIT := u_PrcFret(_nTotPed, SC6->C6_VALOR, SC5->C5_FRETE)
	//Inicio do processo Fiscal
	MaFisIni(SC5->C5_CLIENTE, SC5->C5_LOJACLI, IIf(SC5->C5_TIPO$'DB',"F","C"),SC5->C5_TIPO,SC5->C5_TIPOCLI,,,,,"MATA461")
	MaFisAdd(SC6->C6_PRODUTO, SC6->C6_TES, SC6->C6_QTDVEN, SC6->C6_PRCVEN, 0, "", "", 0, 0, 0, 0, 0, (SC6->C6_VALOR+_nFreteIT) , 0, 0, 0)
	
	_nAliqIcm  := MaFisRet(1,"IT_ALIQICM")
	_nValIcm   := MaFisRet(1,"IT_VALICM" )
	_nBaseIcm  := MaFisRet(1,"IT_BASEICM")
	_nValIpi   := MaFisRet(1,"IT_VALIPI" )
	_nBaseIpi  := MaFisRet(1,"IT_BASEICM")
	//_nValMerc  := SC6->C6_VALOR //MaFisRet(1,"IT_VALMERC")
    _nValMerc  := iif(!empty(nDesSUA),Round(SC6->C6_QTDVEN*SC6->C6_PRUNIT, 2), SC6->C6_VALOR)
	_nValSol   := MaFisRet(1,"IT_VALSOL" ) 	
	_nNfTotal  := (_nValMerc) //MaFisRet(,"NF_TOTAL" )
	_nTVlIST   += _nValSol
	_nBaseDup  += MaFisRet(,"NF_BASEDUP")
	_nDescTot  := MaFisRet(,"NF_DESCONTO")  	
	MaFisEnd()
	//Fim do processo Fiscal
	
	fVerifLin(, .T.)
	
	DbSelectArea('SB1')
	SB1->(DbSetOrder(1))
	SB1->(DbGoTop())
	SB1->(DbSeek(xFilial('SB1')+SC6->C6_PRODUTO))  
	
	oPrn:Say(_nLin,0120,OemToAnsi(SC6->C6_ITEM),oFont08F)
	oPrn:Say(_nLin,0210,OemToAnsi(PadR(SC6->C6_PRODUTO,10)),oFont08F)

	lTemF1 := .F.
	lTemF3 := .F.
	/*
	DBSELECTAREA("SB2")
	SB2->(DbSetOrder(1))
	SB2->(Dbseek(Xfilial("SB2")+SC6->C6_PRODUTO+'01'))
	iF  SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN + SC6->C6_QTDVEN) //cbm 16/12/2020 
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,38)+'(F)'),oFont08F)
		//oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,72)),oFont08F)//oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,55)),oFont08F)	
	ELSE
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,40)),oFont08F)
	ENDIF
	*/
	SB2->(DbSetOrder(1))
	SB2->(Dbseek(Xfilial("SB2")+SC6->C6_PRODUTO+'01'))
	//iF  SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN + SC6->C6_QTDVEN) //cbm 16/12/2020 
	iF  SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)
		lTemF1 := .T.
	endif
	SB2->(DbSetOrder(1))
	SB2->(Dbseek(Xfilial("SB2")+SC6->C6_PRODUTO+'03'))
	//iF  SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN + SC6->C6_QTDVEN) //cbm 16/12/2020 
	iF  SC6->C6_QTDVEN > (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QPEDVEN)
		lTemF3 := .T.
	endif
	if lTemF1 .and. lTemF3
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,38)+'(F)'),oFont08F)
	else
		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,40)),oFont08F)
	endif
	
//	IF !Empty(SC6->C6_LOTECTL)
 //		oPrn:Say(_nLin,0400,OemToAnsi(PadR(ALLTRIM(SB1->B1_DESC)+' ('+ALLTRIM(SC6->C6_LOTECTL)+')',72)),oFont08F)
 //	Else
  //		oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,72)),oFont08F)//oPrn:Say(_nLin,0400,OemToAnsi(PadR(SB1->B1_DESC,55)),oFont08F)	
//	EndIf
	//oPrn:Say(_nLin,1180,OemToAnsi(SB1->B1_UM),oFont08F)
	//oPrn:Say(_nLin,1100,OemToAnsi(DtoC(SC6->C6_ENTREG)),oFont08F)
	//oPrn:Say(_nLin,1300,OemToAnsi(SC6->C6_CF),oFont08F)
	//oPrn:Say(_nLin,1000,OemToAnsi(TransForm(SC6->C6_XTABPRC,PesqPict('SC6','C6_VALOR'))),oFont08F)
	oPrn:Say(_nLin,1430,OemToAnsi(TransForm(SC6->C6_QTDVEN,PesqPict('SC6','C6_QTDVEN'))),oFont08F)
	//oPrn:Say(_nLin,1580,OemToAnsi(TransForm(SC6->C6_PRCVEN,PesqPict('SC6','C6_PRCVEN'))),oFont08F)
	//oPrn:Say(_nLin,1580,OemToAnsi(TransForm(SC6->C6_PRCVEN,PesqPict('SC6','C6_PRUNIT'))),oFont08F)
	oPrn:Say(_nLin,1580,OemToAnsi(TransForm(iif(!empty(nDesSUA),SC6->C6_PRUNIT,SC6->C6_PRCVEN),PesqPict('SC6','C6_PRUNIT'))),oFont08F)
	oPrn:Say(_nLin,1830,OemToAnsi(TransForm(_nValIpi,PesqPict('SC6','C6_VALOR'))),oFont08F)
	oPrn:Say(_nLin,2030,OemToAnsi(TransForm(_nValMerc,PesqPict('SC6','C6_VALOR'))),oFont08F)
	_nLin += _NCBLINFO
	
	_dEntreg := SC6->C6_ENTREG
	_nTItem  ++
	_nTQant  += SC6->C6_QTDVEN
	_nTVlIpi += _nValIpi
	_nTValor += _nNfTotal

	nPLiqui += ( SC6->C6_QTDVEN * SB1->B1_PESO )
	nPBruto += ( SC6->C6_QTDVEN * SB1->B1_PESBRU )
	nVol3   += Round(SC6->C6_QTDVEN * SB1->B1_XALTURA * SB1->B1_XLARG * SB1->B1_XCOMPR,4)   	
	nVolCx  += SC6->C6_QTDVEN

	select SC6
	DbSkip()
EndDo

fVerifLin(, .T.)
_nLin += (_NCBLINFO/2)
oPrn:Line(_nLin,0800,_nLin,2340)
_nLin += (_NCBLINFO/2)
oPrn:Say(_nLin,0800,OemToAnsi('Total P.Venda: '+StrZero(_nTItem,2)),oFont09T)
oPrn:Say(_nLin,1400,OemToAnsi(TransForm(_nTQant,PesqPict('SC6','C6_QTDVEN'))),oFont09T)
oPrn:Say(_nLin,1800,OemToAnsi(TransForm(_nTVlIpi,PesqPict('SC6','C6_VALOR'))),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(_nTValor,PesqPict('SC6','C6_VALOR'))),oFont09T)
_nLin += _NCBLINFO+(_NCBLINFO/2)

fVerifLin(, .T.)
oPrn:Say(_nLin,1450,OemToAnsi('Valor Seguro: '),oFont09T)
//oPrn:Say(_nLin,2060,OemToAnsi(TransForm(_nTSeg,PesqPict('SC6','C6_VALOR'))),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(SC5->C5_SEGURO,PesqPict('SC6','C6_VALOR'))),oFont09T)
_nTSeg:=SC5->C5_SEGURO
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor Frete: '),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(SC5->C5_FRETE,PesqPict('SC6','C6_VALOR'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor Desp.Acess๓rias:'),oFont09T)
//oPrn:Say(_nLin,2060,OemToAnsi(TransForm(_nTDesp,PesqPi/ct('SC6','C6_VALOR'))),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(SC5->C5_DESPESA,PesqPict('SC6','C6_VALOR'))),oFont09T) 
_nTDesp:=SC5->C5_DESPESA
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor ICMS Subtitui็ใo:'),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(_nTVlIST,PesqPict('SC6','C6_VALOR'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('Valor Desconto:'),oFont09T)
//oPrn:Say(_nLin,2060,OemToAnsi(TransForm(SC5->C5_DESCONT,PesqPict('SC6','C6_VALOR'))),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm(nDesSUA,PesqPict('SC6','C6_VALOR'))),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,1450,OemToAnsi('TOTAL PEDIDO: '),oFont09T)
//oPrn:Say(_nLin,2060,OemToAnsi(TransForm((SC5->C5_FRETE + _nTValor + _nTDesp + _nTSeg + _nTVlIST - SC5->C5_DESCONT + _nTVlIpi),PesqPict('SC6','C6_VALOR'))),oFont09T)
oPrn:Say(_nLin,2060,OemToAnsi(TransForm((SC5->C5_FRETE + _nTValor + _nTDesp + _nTSeg + _nTVlIST - nDesSUA + _nTVlIpi),PesqPict('SC6','C6_VALOR'))),oFont09T)
_nLin += _NCBLINFO
//CUBAGEM
//oPrn:Line(_nLin,0800,_nLin,2340)
//_nLin += _NCBLINFO
oPrn:Say(_nLin+15,0200,OemToAnsi('VOL. mณ'),oFont09T)
oPrn:Say(_nLin+15,0550,OemToAnsi('VOL. CAIXAS'),oFont09T)
oPrn:Say(_nLin+15,1150,OemToAnsi('PESO BRUTO'),oFont09T)
oPrn:Say(_nLin+15,1800,OemToAnsi('PESO LIQUIDO'),oFont09T)
oPrn:Say(_nLin+60,0170,OemToAnsi(Transform(nVol3,PesqPict('SUB','UB_QUANT'))),oFont08F)
oPrn:Say(_nLin+60,0570,OemToAnsi(Transform(nVolCx,PesqPict('SUB','UB_QUANT'))),oFont08F)
oPrn:Say(_nLin+60,1150,OemToAnsi(Transform(nPBruto,PesqPict('SUB','UB_QUANT'))),oFont08F)
oPrn:Say(_nLin+60,1800,OemToAnsi(Transform(nPLiqui,PesqPict('SUB','UB_QUANT'))),oFont08F)

oPrn:Box(_nLin+100,0100,_nLin,2350)
_nLin += _NCBLINFO + 100


//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><> ITEM
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO/2
oPrn:Say(_nLin,120,OemToAnsi('Parcelas'),oFont09T)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('Os vencimentos estใo sendo calculados com base na data de Entrega dos itens. Quando Faturado as datas serใo calculadas pela'),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('Data de Emissใo da Nota Fiscal.'),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)
oPrn:Say(_nLin,0150,OemToAnsi('Cod.Pag.: '),oFont09T)
oPrn:Say(_nLin,0400,OemToAnsi(AllTrim(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)   

oPrn:Say(_nLin,0120,OemToAnsi('Dt. Entrega'),oFont09T)
oPrn:Say(_nLin,0400,OemToAnsi('Parcela'),oFont09T)
oPrn:Say(_nLin,0560,OemToAnsi('Prazo'),oFont09T)
oPrn:Say(_nLin,0700,OemToAnsi('Vencimento'),oFont09T)
oPrn:Say(_nLin,1010,OemToAnsi('Valor Total'),oFont09T)
oPrn:Say(_nLin,1400,OemToAnsi('Tipo'),oFont09F)

//_nBaseFin := (SC5->C5_FRETE + _nTValor + _nTDesp + _nTSeg + _nTVlIST - SC5->C5_DESCONT + _nTVlIpi)
_nBaseFin := (SC5->C5_FRETE + _nTValor + _nTDesp + _nTSeg + _nTVlIST - nDesSUA + _nTVlIpi)
_aDuplic := Condicao(_nBaseFin, SC5->C5_CONDPAG, 0, dDataBase, 0)
_nTotPar := 0
For _nPr:=1 To Len(_aDuplic)
	_nLin += _NCBLINFO
	IF _nPr == 1
		oPrn:Say(_nLin,0120,OemToAnsi(DtoC(_dEntreg)),oFont08F)
	ENDIF
	oPrn:Say(_nLin,0400,OemToAnsi(StrZero(_nPr,2)),oFont08F)
	oPrn:Say(_nLin,0560,OemToAnsi( AllTrim(STR((_aDuplic[_nPr][1] - iIF(Type('_aDuplic[_nPr-1][1]')<>'U', _aDuplic[_nPr-1][1], dDataBase-1 ))))   ),oFont08F)
	oPrn:Say(_nLin,0700,OemToAnsi(DtoC(_aDuplic[_nPr][1])),oFont08F)
	oPrn:Say(_nLin,0985,OemToAnsi(TransForm(_aDuplic[_nPr][2],PesqPict('SC6','C6_VALOR'))),oFont08F)
	_nTotPar += _aDuplic[_nPr][2]  
	
	SE4->(DbSetOrder(01)) 
	IF SE4->(DbSeek(xFilial('SE4')+SC5->C5_CONDPAG))  
		If "BOL" $ SE4->E4_DESCRI
		   	cDescPG	  :="BOLETO BANCARIO"
		ElseIf "CC" $ SE4->E4_DESCRI
		   	cDescPG	  :="CARTAO DE CREDITO"
		ElseIf "CD" $ SE4->E4_DESCRI
		   	cDescPG	  :="CARTAO DE DEBITO AUTOMATICO"
		ElseIf "CH" $ SE4->E4_DESCRI
		   	cDescPG	  :="CHEQUE"
		ElseIf "FAT" $ SE4->E4_DESCRI
		   	cDescPG	  :="FATURA"
		ElseIf "CR" $ SE4->E4_DESCRI
		   	cDescPG	  :="CREDITO"	   	
		ElseIf "BON" $ SE4->E4_DESCRI
		   	cDescPG	  :="BONIFICACAO"	   			   	
		Else
		   	cDescPG	  :=Space(20)
		EndIf
		oPrn:Say(_nLin,1400,OemToAnsi(cDescPG),oFont08F)	
	EndIf	
Next _nPr
_nLin += _NCBLINFO
oPrn:Line(_nLin,0120,_nLin,1300)
_nLin += _NCBLINFO/2
oPrn:Say(_nLin,0120,OemToAnsi('Total Geral'),oFont09T)
oPrn:Say(_nLin,0950,OemToAnsi(TransForm(_nBaseFin,PesqPict('SC6','C6_VALOR'))),oFont09T)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRPVEND บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
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
		C_XRORCA(SC5->C5_NUM)
	ENDIF
ENDIF

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณ XRPVEND บ Autor ณ 	Meliora/Gustavo	 บ Data ณ  04/11/2013   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Grafico - Pedido de Venda...                       นฑฑ
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
_aTpFrete := CTBCBOX("UA_TPFRETE")

// Renato Bandeira em 12/02/2015 - Adaptado para a Jplus pois e endere็o de entrega estแ somente na mensagem do pedido
// Como existem PV importados, estes nao tem or็amento (SUA), entao tratei
//DbSelectArea('SUA')
//SUA->(DbSetOrder(8))
//SUA->(DbGoTop())
//IF SUA->(DbSeek(xFilial('SUA')+SC5->C5_NUM))
//	_cMsgComen := AllTrim(SUA->UA_XOBSLO)
//Else
_cMsgComen := AllTrim(SC5->C5_XOBSLO)
//Endif
IF !Empty(_cMsgComen)
	oPrn:Say(_nLin,120,OemToAnsi('OBS. DE ENTREGA: '),oFont08F)
	_nLin += _NCBLINFO+(_NCBLINFO/2)
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
oPrn:Say(_nLin,120,OemToAnsi('1)CONDICAO DE PAGTO:'+AllTrim(Posicione("SE4",1,xFilial("SE4")+SUA->UA_CONDPG,"E4_DESCRI")) + '(SUJEITO A ANALISE DE CREDITO'),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)
//oPrn:Say(_nLin,120,OemToAnsi('2) NO CASO DE VENDA PARA REVEDAS, A SUBSTITUIวรO TRIBUTมRIA INCIDENTE EM SERINGAS, AGULHAS, ETC, SERม COBRADO NA NF'),oFont08F)
oPrn:Say(_nLin,120,OemToAnsi('2) VALIDADE: 7 DIAS'),oFont08F)
_nLin += _NCBLINFO+(_NCBLINFO/2)
oPrn:Say(_nLin,120,OemToAnsi('3)PEDIDO MINIMO: R$ 1.500,00 '),oFont08F)
_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('4)FRETE : CIF/FOB(DEPENDE DA REGIAO'),oFont08F)
_nLin += _NCBLINFO
//oPrn:Say(_nLin,120,OemToAnsi('5)IPI INCLUSO'),oFont08F)
//_nLin += _NCBLINFO
oPrn:Say(_nLin,120,OemToAnsi('5)REDESPACHO POR CONTA DO CLIENTE.'),oFont08F)
_nLin += _NCBLINFO
oPrn:Line(_nLin,0120,_nLin,2340)
_nLin += _NCBLINFO+_NCBLINFO

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
User Function xAcessoC5(_cPV,_nOpc)
*---------------------------*
Local _lRet := .F.
Default _cPV := ''
Default _nOpc := 0

IF _nOpc == 2
	Return(&("__cUserID $ Posicione('SA3',1,xFilial('SA3')+ (Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_VEND')) ,'A3_CODUSR')+'/'+AllTrim(GetMv('LI_USRXVND',.F.,'000000'))"))
Else
	DbSelectArea('SC5')
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())
	
	DbSelectArea('SA1')
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	
	DbSelectArea('SA3')
	SA3->(DbSetOrder(1))
	SA3->(DbGoTop())
	
	IF SC5->(DbSeek(xFilial('SC5')+_cPV))
		IF SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
			IF SA3->(DbSeek(xFilial('SA3')+SA1->A1_VEND))
				IF __cUserID $ SA3->A3_CODUSR+'/'+AllTrim(GetMv('LI_USRXVND',.F.,'000000'))+'/'+Posicione('SA3',1,xFilial('SA3')+SC5->C5_VEND1,'A3_CODUSR')
					_lRet := .T.
				ENDIF
			EndIF
		EndIF
	EndIF
	
	Return(_lRet)
EndIF

Return
