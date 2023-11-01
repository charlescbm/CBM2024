#include 'protheus.ch'
#include 'parmtype.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "TOPCONN.CH"


#DEFINE  ENTER CHR(13)+CHR(10)

//DESENVOLVIDO POR INOVEN


User Function IVENA070(nOpcA,CCLI,COJA,CUM_ORC, CPEDCLI, COD_FPG, _CBPCOD_FPG, COD_TRP, COBS_EXP, COBS_FIN, COBS_CO, COBS_ENT, DENTREG,;
COD_BANCO, COPORCPED, LPROSP, CEND_ENT, CBAI_ENT, CMUN_ENT, CEST_ENT, CCEP_ENT, CTPFRETE, CTPOPER,NFRETE, NDESPESA, CTPLIBERA/*, COD_RED*/,;
CXFRECIF,_CCOD_VEND, _NTTOTFIM,dDtProgr,nVlrProg1,dDtProgr2,nVlrProg2,dDtProgr3, nVlrProg3,dDtProgr4,nVlrProg4,nDescT,nDescTota,;
cCodTab,nVatrazo,nLCrdT,nLCrd, ObjSCV,nCNVal_Uti, dVenc1, dVenc2, dVenc3, dVenc4, nParc1, nParc2, nParc3, nParc4,nDias1,nDias2,nDias3,nDias4,cCod_por, cLoja_por, cod_Redesp, dAgenda, nPrvFrt )

LOCAL ACABEC	:= {}
LOCAL AITENS	:= {}
LOCAL ALINHA	:= {}
LOCAL AAREA		:= GETAREA()
LOCAL CTESINT	:= ""
LOCAL LRET		:= .F.
//LOCAL CORC		:= ""
LOCAL NOPC		:= 0
LOCAL CCOD_CLI	:= ""
LOCAL CLOJA_CLI	:= ""
LOCAL CEND_COB	:= ""
LOCAL CBAI_COB	:= ""
LOCAL CMUN_COB	:= ""
LOCAL CCEP_COB	:= ""
LOCAL CEST_COB	:= ""
//LOCAL CCELULA	:= ""
LOCAL LSIT		:= LPROSP
LOCAL LPARC		:= .F.
LOCAL COPER		:= ""
LOCAL CNUMSC5   := ""
LOCAL CDOC		:= ""
LOCAL NCOMVED   := ""
//LOCAL nMargemPv	:= 0
Local nMargemPV := {}
LOCAL _CNUMORC  := ''

LOCAL _LTEMDESC	:=	.F.

//Local nDescLim:= GetNewPar("MV_DESCLIM",5)
Local nValItTab:=0
Local nValItTot:=0
Local cSql		:= ''
Local lOrcCond	:= .F.
Local lCredito  := .F.
Local lBonifica := .F.
Local cProdCTL  := ""
Local cSequen	:= "01"
Local cLocAx 	:= "01"
//Local lPode 	:= .T.
//Local _Recno 	:= 0
//Local aSaldos 	:= {}
//Local cCondicoes:= GetMv("ES_CONDPG",,"121/122/123/124/125/126")
//Local lProsp	:= .F.
Local nPercTab	:= 0
Local cEstCif   := GetMv("ES_ESTCIF")
Local nX

_CVENDSUPER		:= ""

NCOMISEX		:=	 0
NCOMISS2		:=	 0

PRIVATE _LSEMEST	:= .F.
PRIVATE	LMSERROAUTO := .F.
PRIVATE N := 0
Private nUsaCred := 0

//Condição Negociada
Private nPosSeq		:= GDFieldPos("Z1_SEQUENC",	oGetConNe:aHeader)
Private nPosCond	:= GDFieldPos("Z1_COND",	oGetConNe:aHeader)
Private nPosDesCon	:= GDFieldPos("E4_DESCRI",	oGetConNe:aHeader)
Private nPosNat		:= GDFieldPos("Z1_NATUREZ",	oGetConNe:aHeader)
Private nPosDesNat	:= GDFieldPos("ED_DESCRIC",	oGetConNe:aHeader)
Private nPosDtIVen	:= GDFieldPos("Z1_DTIVENC",	oGetConNe:aHeader)
Private nPosDtFVen	:= GDFieldPos("Z1_DTFVENC",	oGetConNe:aHeader)
Private nPosValCon	:= GDFieldPos("Z1_VALCON",	oGetConNe:aHeader)
Private nPosValPar	:= GDFieldPos("Z1_VALPAR",	oGetConNe:aHeader)
Private nPosValNsu	:= GDFieldPos("Z1_NSU", 	oGetConNe:aHeader)
Private nPosValAut	:= GDFieldPos("Z1_AUTORIZ",	oGetConNe:aHeader)
Private nPosValAdq	:= GDFieldPos("Z1_ADQUIRI",	oGetConNe:aHeader)
Private nPosValCob	:= GDFieldPos("Z1_CODBAND",	oGetConNe:aHeader)
Private nPosValBan	:= GDFieldPos("Z1_BANDEIR",	oGetConNe:aHeader)
Private lCondNeg	:= .F.

PRIVATE LIBERAG :=GETMV("TG_LIBAGEN")

//GRAVA BACKUP DA ULTIMA CONDIçãO DE PAGAMENTO
_CBPCOD_FPG := COD_FPG

if EMPTY(CTPOPER)
	CTPOPER:='51'
ENDIF

IF EMPTY(TKOPERADOR())
	ALERT("OPERADOR NãO CADASTRADO!!!")
	RETURN .F.
ENDIF

IF COD_FPG == '000' .AND. ALLTRIM(CTPOPER) <> ALLTRIM(SUPERGETMV("DN_TPOPAM",.F.,'000'))
	ALERT("CONDIÇAO DE PAGAMENTO AMOSTRA NãO CONFERE COM O TIPO DE VENDA")
	RETURN .F.
ENDIF

IF COPORCPED == "3"
	SUA->(DbSetOrder(01))
	SUA->(DbSeek(xFilial('SUA')+CUM_ORC))
	lOrcCond:= (SUA->UA_CONDPG != COD_FPG)
EndIf
//--Verifica se usuario é um vendedor [Representante]
SA3->(dbSetOrder(7))
If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
	//--Verifica se é um vendedor externo
	If SA3->A3_TIPO == 'E'
		_CCOD_VEND:= SA3->A3_COD
	EndIf
EndIf

If CTPOPER == '05' .AND. ! (COD_FPG $ GETMV("FS_CONDBON",.F.,'010'))
	ALERT("Tipo de operação não corresponde a forma de pagamento. Verifique!")
	Return ( .F. )
EndIf

If CTPOPER <> '05' .AND. (COD_FPG $ GETMV("FS_CONDBON",.F.,'010'))
	ALERT("Tipo de operação não corresponde a forma de pagamento. Verifique!")
	Return ( .F. )
EndIf

//--Valida se orçamento está vinculado ao PV
SUA->(DbSetOrder(01))
SUA->(DbSeek(xFilial('SUA')+CUM_ORC))
If !Empty(SUA->UA_NUMSC5)
	MsgAlert(OemToAnsi('ALERTA: Orçamento vinculado ao PV:'+SUA->UA_NUMSC5+' .Alteração de orçamento somente será realizada após exclusao do PV!!' ))
	Return(.F.)
EndIf
//--Valida vencimentos
SE4->(DbSetOrder(01))
If SE4->(DbSeek(xFilial('SE4')+COD_FPG))
	nPercTab:= SE4->E4_ZPERC
	If SE4->E4_TIPO == '9'
		If Empty(dVenc1) .And. Empty(dVenc2) .And. Empty(dVenc3) .And. Empty(dVenc4)
			MsgAlert(OemToAnsi('ALERTA!!! Condição de pagamento Tipo 9. Necessario preencher o(s) de vencimento(s)!!!'))
			Return(.F.)
		Endif
		
		If nParc1+nParc2+nParc3+nParc4 != 100
			MsgAlert(OemToAnsi('ALERTA!! Condição de pagamento tipo 9. A soma das parcelas está incorreta!!!'))
			Return(.F.)
		EndIf
	EndIf
EndIf

If nOpcA == '2'
	//--Validação de prospect
	If Empty(CCLI) .And. !Empty(cCod_por)
		MsgAlert(OemToAnsi('ALERTA!! Nessario efetivar Prospect para cliente!!!'))
		Return(.F.)
	EndIf
EndIf


if IsInCallStack("u_IVENA010") .and. empty(dAgenda)
	MsgAlert(OemToAnsi('ALERTA!! Gravaçao de orçamento será necessario informar data do agendamento!!!'))
	Return(.F.)
endif


//--Orçamento
If nOpcA == '1' .AND. !LIBERAG
	If Empty(dAgenda)
		MsgAlert(OemToAnsi('ALERTA!! Gravaçao de orçamento será necessario informar data do agendamento!!!'))
		Return(.F.)
	EndIf
EndIf

IF EMPTY(_CCOD_VEND)
	ALERT("Codigo de Vendedor Vazio")
	RETURN .F.
ENDIF

//--Tratamento para desconto negativo [Proj Promoção]
If nDescT < 0
	nDescT:= 0
EndIf

If Empty(CCLI) .And. !Empty(cCod_por)
	CCOD_CLI	:= SUS->US_COD
	CLOJA_CLI	:= SUS->US_LOJA
	CEND_COB	:= SUS->US_END
	CBAI_COB	:= SUS->US_BAIRRO
	CMUN_COB	:= SUS->US_MUN
	CCEP_COB	:= SUS->US_CEP
	CEST_COB	:= SUS->US_EST
	lProsp		:= .T.
	//CCELULA		:= SUS->US_CELULA
	LRET 		:= .T.
ELSE
	DBSELECTAREA("SA1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SA1")+alltrim(CCLI)+alltrim(COJA))
		CCOD_CLI	:= SA1->A1_COD
		CLOJA_CLI	:= SA1->A1_LOJA
		CEND_COB	:= SA1->A1_ENDCOB
		CBAI_COB	:= SA1->A1_BAIRROC
		CMUN_COB	:= SA1->A1_MUNC
		CCEP_COB	:= SA1->A1_CEPC
		CEST_COB	:= SA1->A1_ESTC
		CEND_ENT	:= SA1->A1_ENDENT
		CBAI_ENT	:= SA1->A1_BAIRROE
		CMUN_ENT	:= SA1->A1_MUNE
		CCEP_ENT	:= SA1->A1_CEPE
		CEST_ENT	:= SA1->A1_ESTE
		//CCELULA		:= SA1->A1_CELULA
		LRET := .T.
	ENDIF
ENDIF

IF LRET
	IF COPORCPED == "3"
		COPER := "1"
	ELSE
		COPER := "2"
	ENDIF
ENDIF

//previsao de frete
if (empty(COD_TRP) .and. empty(nPrvFrt)) .or. (!empty(COD_TRP) .and. empty(nPrvFrt))
	_nPrvFrt := 0
	xRet := U_IVENA080(,,.F.,@_nPrvFrt,COD_TRP)
	if !empty(xRet)
		COD_TRP := xRet
		nPrvFrt := _nPrvFrt
	endif
endif
				

IF EMPTY(COD_TRP)
	ALERT("CODIGO DA TRANSPORTADORA NãO INFORMADO. DEVERá SER INFORMADO PARA CONTINUAR A GRAVACAO.")
	LRET := .F.
ENDIF


IF EMPTY(cod_Redesp).and. !CEST_ENT $ (cEstCif)  .and.  alltrim(CTPFRETE) == '1'
	ALERT("CODIGO DA TRANSPORTADORA DE REDESPAPACHO NãO INFORMADO. DEVERá SER INFORMADO PARA CONTINUAR A GRAVACAO DEVIDO A REGIAO DO CLIENTE.")
ENDIF

If COPER == "1"
	IF COD_FPG == "   "
		ALERT(OemToAnsi("CONDIÇÃO DE PAGAMENTO NãO INFORMADA. DEVERá SER INFORMADA PARA CONTINUAR A GRAVAÇÃO."))
		LRET := .F.
	ElseIf AllTrim(COD_FPG) $ AllTrim(GetNewPar("FS_CONNEG",""))
		lCondNeg	:= .T.
		
		//Validar valor do orçamento com o valor da condição negociada
		If _NTTOTFIM <> nCNVal_Uti
			Aviso("Valores","Valor total do orçamento divergente do valor utilizado na condição negociada",{"OK"})
			lRet	:= .F.
		Else
			//Valida as parcelas do grid
			For nX := 1 To Len(oGetConNe:aCols)
				If !oGetConNe:aCols[nX][Len(oGetConNe:aCols[nX])] //Desconsidera deletados
					aCondPgt	:= Condicao(oGetConNe:aCols[nX][nPosValCon], AllTrim(oGetConNe:aCols[nX][nPosCond]),, dDataBase,,,,,,)
				EndIf
			Next nX
		EndIf
	ELSE
		If Len(oGetConNe:aCols) > 0
			If !EMPTY(oGetConNe:aCols[1][nPosCond])
				If !MsgYesNo("Condição selecionada não é negociada e existem dados na aba de condição negociada. Deseja continuar e descartar os dados?")
					lRet	:= .F.
				EndIf
			EndIf
		EndIf
	ENDIF
Else
	lCondNeg	:= .T.
EndIf


IF LRET
	IF COPORCPED == "3"
		LPARC :=  U_IVENA090(cTPOper)
		IF !LPARC
			MSGINFO("PROCESSO CANCELADO!","-= ATENçãO =-")
			RETURN(.F.)
		ENDIF
	ENDIF
	
	If	COPER == "1"
		fBuscCred(_NTTOTFIM)
	EndIf
	
	CONOUT("***********************************************************")
	CONOUT("**   INICIO DA EXECAUTO TMKA271 (ORCAMENTO) : " +TIME() + "   **")		//"INICIO: "
	CONOUT("***********************************************************")
	ACABEC := {}
	AITENS := {}
	
	IF !EMPTY(CUM_ORC)
		AADD(ACABEC,{"UA_FILIAL"	,XFILIAL("SUA") ,NIL})
		AADD(ACABEC,{"UA_NUM"		,CUM_ORC 		,NIL})
		CDOC := CUM_ORC
	ELSE
		AADD(ACABEC,{"UA_FILIAL"	,XFILIAL("SUA") ,NIL})
	ENDIF
	AADD(ACABEC,{"UA_CLIENTE"	,CCOD_CLI	  	,NIL})
	AADD(ACABEC,{"UA_LOJA"		,CLOJA_CLI	 	,NIL})
	AADD(ACABEC,{"UA_OPERADO"	,TKOPERADOR()	,NIL})	//CODIGO DO OPERADOR
	AADD(ACABEC,{"UA_OPER"		,COPER			,NIL})	//1-FATURAMENTO 2-ORCAMENTO 3-ATENDIMENTO
	AADD(ACABEC,{"UA_TMK"		,"2"			,NIL})	//1-ATIVO 2-RECEPTIVO
	AADD(ACABEC,{"UA_CONDPG"	,COD_FPG		,NIL})	//CONDICAO DE PAGAMENTO
	AADD(ACABEC,{"UA_TRANSP"	,COD_TRP		,NIL})	//TRANSPORTADORA
	AADD(ACABEC,{"UA_XREDESP"	,cod_Redesp		,NIL})	//REDESPACHO
	AADD(ACABEC,{"UA_ENDCOB"  	,CEND_COB		,NIL})
	AADD(ACABEC,{"UA_BAIRROC"	,CBAI_COB		,NIL})
	AADD(ACABEC,{"UA_MUNC"		,CMUN_COB		,NIL})
	AADD(ACABEC,{"UA_CEPC"  	,CCEP_COB		,NIL})
	AADD(ACABEC,{"UA_ESTC"  	,CEST_COB		,NIL})
	AADD(ACABEC,{"UA_ENDENT"   	,CEND_ENT		,NIL})
	AADD(ACABEC,{"UA_BAIRROE"	,CBAI_ENT		,NIL})
	AADD(ACABEC,{"UA_MUNE"		,CMUN_ENT		,NIL})
	AADD(ACABEC,{"UA_CEPE"  	,CCEP_ENT 		,NIL})
	AADD(ACABEC,{"UA_ESTE"   	,CEST_ENT		,NIL})
	AADD(ACABEC,{"UA_PROSPEC"	,LSIT	     	,NIL})
	AADD(ACABEC,{"UA_DESCONT"  	,nDescTota     	,NIL})
	AADD(ACABEC,{"UA_FRETE"   	,0		       	,NIL})
	AADD(ACABEC,{"UA_DESPESA"  	,0				,NIL})
	//AADD(ACABEC,{"UA_TPFRETE"  	,U_XTPFRETE(CTPFRETE),NIL})
	AADD(ACABEC,{"UA_TPFRETE"  	,CTPFRETE		,NIL})
	AADD(ACABEC,{"UA_XTPFRET"  	,CTPFRETE       ,NIL})
	AADD(ACABEC,{"UA_PEDCLI"  	,CPEDCLI      	,NIL})
	AADD(ACABEC,{"UA_XOBSEXP"  	,COBS_EXP      	,NIL})
	AADD(ACABEC,{"UA_XOBSLO"  	,COBS_ENT      	,NIL})
	AADD(ACABEC,{"UA_XOBSCO"  	,COBS_CO      	,NIL})
	AADD(ACABEC,{"UA_XOBSFIN"  	,COBS_FIN      	,NIL})
	//AADD(ACABEC,{"UA_CELULA"  	,CCELULA      	,NIL})
	AADD(ACABEC,{"UA_TIPLIB"  	,CTPLIBERA    	,NIL})
	AADD(ACABEC,{"UA_VEND"  	,_CCOD_VEND    	,NIL})
	AADD(ACABEC,{"UA_PROSPEC"  	,lProsp    		,NIL})
	
	
	chkFile('SUB')
	
	IF !EMPTY(CUM_ORC)
		DBSELECTAREA('SUB')
		SUB->(DBSETORDER(1))
		SUB->(DBGOTOP())
		SUB->(DBSEEK(XFILIAL()+CUM_ORC))
		DO WHILE SUB->(!EOF()) .AND. SUB->UB_FILIAL==XFILIAL('SUB') .AND. SUB->UB_NUM==CUM_ORC
			RECLOCK('SUB',.F.)
			DBDELETE()
			SUB->(MSUNLOCK())
			SUB->(DBSKIP())
		ENDDO
		
		SUA->(DBSEEK(XFILIAL()+CUM_ORC))
		RECLOCK('SUA',.F.)
	ELSE
		RECLOCK('SUA', .T.)
		REPLACE UA_FILIAL 	WITH XFILIAL("SUA")
		REPLACE UA_NUM    	WITH GETSX8NUM('SUA')
		REPLACE UA_EMISSAO  WITH DDATABASE
	ENDIF
	REPLACE SUA->UA_CLIENTE WITH CCOD_CLI
	REPLACE SUA->UA_LOJA    WITH CLOJA_CLI
	REPLACE SUA->UA_OPERADO WITH TKOPERADOR()
	REPLACE SUA->UA_OPER    WITH COPER
	REPLACE SUA->UA_TMK     WITH "2"
	REPLACE SUA->UA_CONDPG  WITH COD_FPG
	REPLACE SUA->UA_TRANSP  WITH COD_TRP
	REPLACE SUA->UA_XREDESP WITH cod_Redesp
	REPLACE SUA->UA_ENDCOB  WITH CEND_COB
	REPLACE SUA->UA_BAIRROC WITH CBAI_COB
	REPLACE SUA->UA_MUNC    WITH CMUN_COB
	REPLACE SUA->UA_CEPC    WITH CCEP_COB
	REPLACE SUA->UA_ESTC    WITH CEST_COB
	REPLACE SUA->UA_ENDENT  WITH CEND_ENT
	REPLACE SUA->UA_BAIRROE WITH CBAI_ENT
	REPLACE SUA->UA_MUNE    WITH CMUN_ENT
	REPLACE SUA->UA_CEPE    WITH CCEP_ENT
	REPLACE SUA->UA_ESTE    WITH CEST_ENT
	REPLACE SUA->UA_PROSPEC WITH lProsp
	REPLACE SUA->UA_DESCONT WITH nDescTota
	REPLACE SUA->UA_FRETE   WITH 0
	REPLACE SUA->UA_DESPESA WITH 0
	
	//REPLACE SUA->UA_TPFRETE WITH U_XTPFRETE(CTPFRETE)
	REPLACE SUA->UA_TPFRETE WITH CTPFRETE
	REPLACE SUA->UA_XTPFRET WITH CTPFRETE
	REPLACE SUA->UA_PEDCLI  WITH CPEDCLI
	REPLACE SUA->UA_XOBSEXP WITH COBS_EXP
	REPLACE SUA->UA_XOBSLO  WITH COBS_ENT
	REPLACE SUA->UA_XOBSCO  WITH COBS_CO
	REPLACE SUA->UA_XOBSFIN WITH COBS_FIN
	//REPLACE SUA->UA_CELULA  WITH CCELULA
	REPLACE SUA->UA_TIPLIB  WITH CTPLIBERA
	REPLACE SUA->UA_VEND    WITH _CCOD_VEND
	//REPLACE SUA->UA_TABELA  WITH cCodTab
	REPLACE SUA->UA_XTOPER  WITH CTPOPER
	REPLACE SUA->UA_XDATA1  WITH dVenc1
	REPLACE SUA->UA_XDATA2	WITH dVenc2
	REPLACE SUA->UA_XDATA3	WITH dVenc3
	REPLACE SUA->UA_XDATA4	WITH dVenc4
	REPLACE SUA->UA_XPARC1	WITH nParc1
	REPLACE SUA->UA_XPARC2	WITH nParc2
	REPLACE SUA->UA_XPARC3	WITH nParc3
	REPLACE SUA->UA_XPARC4	WITH nParc4
	REPLACE SUA->UA_XDIAS1	WITH nDias1
	REPLACE SUA->UA_XDIAS2	WITH nDias2
	REPLACE SUA->UA_XDIAS3	WITH nDias3
	REPLACE SUA->UA_XDIAS4	WITH nDias4
	
	MSUNLOCK()
	CONFIRMSX8()
	
	//TEMPORARIO
	CDOC := SUA->UA_NUM
	
	nValItTab:=0
	nValItTot:=0
	FOR NX := 1 TO LEN(OORCAMENTO:ACOLS)
		
		IF OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:AHEADER)+1]
			LOOP
		ENDIF
		
		ALINHA := {}
		
		IF !EMPTY(CUM_ORC)
			AADD(ALINHA,{"UB_FILIAL"	, XFILIAL("SUB")	, NIL})
			AADD(ALINHA,{"UB_NUM"		, CUM_ORC			, NIL})
		ELSE
			AADD(ALINHA,{"UB_FILIAL"	, XFILIAL("SUB")	, NIL})
		ENDIF
		
		NTOTLIN := (OORCAMENTO:ACOLS[NX,GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)] * OORCAMENTO:ACOLS[NX,GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)])
		
		AADD(ALINHA,{"UB_ITEM"		,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ITEM",OORCAMENTO:AHEADER)]		,NIL})
		AADD(ALINHA,{"UB_PRODUTO"	,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)]	,".T."})
		cCodB1 := padr(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],TamSX3('B1_COD')[1])
		SB1->(DBSEEK(XFILIAL('SB1')+cCodB1))
		AADD(ALINHA,{"UB_DESCRI"	,SB1->B1_DESC	,".T."})
		AADD(ALINHA,{"UB_SITPROD"	,'01'			,".T."})
		AADD(ALINHA,{"UB_QUANT"		,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)]	,NIL})
		AADD(ALINHA,{"UB_VRUNIT"	,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]	,NIL})
		AADD(ALINHA,{"UB_VLRITEM"	,NTOTLIN                                                            ,NIL})
		
		_AVLDESC := XCLDESCUN(@OORCAMENTO,NX,COD_FPG)
		
		If CTPOPER $ '87|84'
			IF ALLTRIM(cFilAnt) $ "0103|0102" // ATENDER TRANFERENCIAIS
				if SB1->B1_ORIGEM $ "0|2"
					CTPOPER:= '84'
				else
					dbSelectArea("SB2")
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						CTPOPER:= '87' 
					ELSE
						dbSeek(xFilial("SB2") +OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] + '03')
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							CTPOPER:= '84'
						Else
							If SB1->B1_LOCPAD $ '01|90'							
								CTPOPER	:= '87'
							ElseIf SB1->B1_LOCPAD $ '03|80'
								CTPOPER	:= '84'
							Else
								MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
							EndIf
						EndIf
					ENDIF		
				endif
				CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
			ELSE				
				CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
			ENDIF		
		//ElseIf CTPOPER == '05'
		//	CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
		Else
			IF ALLTRIM(cFilAnt) $ "0103|0102" // ATENDER TRANFERENCIAIS
				if SB1->B1_ORIGEM $ "0|2"
					CTPOPER:= '52'
				else
					dbSelectArea("SB2")
					SB2->(dbSetOrder(01))
					SB2->(dbSeek(xFilial("SB2") +OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] + '01'))
					IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
						CTPOPER:= '51' 
					ELSE
						dbSeek(xFilial("SB2") +OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] + '03')
						IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
							CTPOPER:= '52'
						Else
							If SB1->B1_LOCPAD $ '01|90'							
								CTPOPER	:= '51'
							ElseIf SB1->B1_LOCPAD $ '03|80'
								CTPOPER	:= '52'
							Else
								MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
							EndIf	
						EndIf
					ENDIF		
				endif
				CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
			ELSE				
				CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
			ENDIF		
		EndIf

		IF EMPTY(CTESINT)
			CTESINT := GETMV('LB_TGVTES',.F.,'502')
		ENDIF
		
		AADD(ALINHA,{"UB_TES"		,CTESINT															,".T."})
		//AADD(ALINHA,{"UB_OPER"		,'51'	    														,".T."})
		AADD(ALINHA,{"UB_OPER"		,CTPOPER	    													,".T."})
		AADD(ALINHA,{"UB_EMISSAO"	,DDATABASE															,NIL})
		AADD(ALINHA,{"UB_DTENTRE"	,DENTREG															,NIL})
		AADD(ALINHA,{"UB_XPED"   	,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPED",OORCAMENTO:AHEADER)]	    ,NIL})
		AADD(ALINHA,{"UB_XPEDIT" 	,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPEDIT",OORCAMENTO:AHEADER)]	,NIL})
		
		IF (OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])])
			AADD(ALINHA,{"AUTDELETA"	,IF( (OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])]), "S", "N" )	,NIL})
		ENDIF
		
		IF EMPTY(CTESINT) .And. !LPROSP
			ALERT(OemToAnsi("AMARRAÇÃO FISCAL AUSENTE"))
			RETURN(.F.)
		ENDIF
		
		AADD(AITENS,ALINHA)
		
		RECLOCK('SUB', .T.)
		REPLACE SUB->UB_FILIAL  WITH XFILIAL("SUB")
		REPLACE SUB->UB_NUM     WITH SUA->UA_NUM
		REPLACE SUB->UB_ITEM    WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ITEM",OORCAMENTO:AHEADER)]
		REPLACE SUB->UB_PRODUTO WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)]
		SB1->(DBSEEK(XFILIAL('SB1')+OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)]))
		
		REPLACE SUB->UB_QUANT   WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)]
		REPLACE SUB->UB_VRUNIT  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]
		REPLACE SUB->UB_VLRITEM WITH NTOTLIN
		REPLACE SUB->UB_TES     WITH CTESINT
		
		REPLACE SUB->UB_EMISSAO WITH DDATABASE
		REPLACE SUB->UB_DTENTRE WITH DENTREG
		REPLACE SUB->UB_XPED    WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPED",OORCAMENTO:AHEADER)]
		REPLACE SUB->UB_XPEDIT  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPEDIT",OORCAMENTO:AHEADER)]
		//REPLACE SUB->UB_PRCTAB  WITH _AVLDESC[1]
		//REPLACE SUB->UB_PRCTAB  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]
		if !empty(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)])
			REPLACE SUB->UB_PRCTAB  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)]
		else
			REPLACE SUB->UB_PRCTAB  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]
		endif

		REPLACE SUB->UB_VALDESC WITH _AVLDESC[3]
		// RENATO BANDEIRA EM 30/10/14 - GRAVACAO DO DESCONTO NA LINHA
		REPLACE SUB->UB_DESC    WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_DESC",OORCAMENTO:AHEADER)]
		SA3->(dbSetOrder(1))
		SA3->(msSeek(xFilial('SA3') + _CCOD_VEND))
		cCodSup := SA3->A3_SUPER
		if SA3->A3_TIPO == 'I'
			REPLACE SUB->UB_XCOMIS  WITH SA3->A3_COMIS
		else
			REPLACE SUB->UB_XCOMIS  WITH OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XCOMIS",OORCAMENTO:AHEADER)]
		endif
		//% comissao do supervisor
		SA3->(dbSetOrder(1))
		SA3->(msSeek(xFilial('SA3') + cCodSup))
		REPLACE SUB->UB_XCOMIS2  WITH SA3->A3_COMIS
		
		nValItTab+=SUB->UB_PRCTAB*SUB->UB_QUANT
		nValItTot+=SUB->UB_VLRITEM
		MSUNLOCK()
		
	NEXT NX
	
	NOPC  := IF( EMPTY(CUM_ORC), 3, 4 )
	N     :=LEN(AITENS)
	ACOLS := ACLONE(OORCAMENTO:ACOLS)
	
	LMSERROAUTO := .F.
	
	IF !LMSERROAUTO
		
		IF EMPTY(CDOC)
			IF EMPTY(CUM_ORC)
				DBSELECTAREA("SUA")
				DBSETORDER(6)
				IF DBSEEK(XFILIAL("SUA") + CCOD_CLI + CLOJA_CLI + DTOS(DDATABASE) )
					WHILE !SUA->(EOF()) .AND. CCOD_CLI == SUA->UA_CLIENTE .AND. CLOJA_CLI == SUA->UA_LOJA .AND. SUA->UA_EMISSAO == DDATABASE
						CDOC := SUA->UA_NUM
						SUA->(DBSKIP())
					END
				ENDIF
			ELSE
				CDOC := CUM_ORC
			ENDIF
		ENDIF
		
		
		MSGINFO("ORCAMENTO " + CDOC + " GERADO!")
		_CNUMORC := CDOC
		
		IF COPORCPED == "2"
			CONFIRMSX8()
		ENDIF
		
		DBSELECTAREA("SUA")
		DBSETORDER(1)
		LRET := DBSEEK(XFILIAL("SUA") + CDOC )
		IF LRET
			RECLOCK("SUA",.F.)
			SUA->UA_FRETE   := NFRETE
			SUA->UA_DESPESA := NDESPESA
			SUA->UA_TIPLIB  := CTPLIBERA
			SUA->UA_ZPRVFRE	:= nPrvFrt
			SUA->(MSUNLOCK())
		ENDIF
		
		//U_PCxUpdCP(xFilial("SUA") + SUA->UA_NUM)		
		//--Orçamento gravado
		//If COPER == '2' .And. !Empty(dAgenda)
		If (COPER == '2' .or. COPORCPED == "3") .And. !Empty(dAgenda)
			FGravaAge(CDOC, CCLI, COJA, dAgenda,'')
		EndIf
		

		IF COPER == "1"
			IF LRET
				CNUMSC5 := SUA->UA_NUMSC5
				If !EMPTY(CNUMSC5 )
					DBSELECTAREA("SC5")
					DBSETORDER(1)
					IF !DBSEEK(XFILIAL("SC5") + CNUMSC5 )
						ALERT("PEDIDO " + SUA->UA_NUMSC5 + " NãO ENCONTRADO!")
					Else
						IF ALLTRIM(SC5->C5_XSTATUS)<>"000004" .AND. !Empty(SC5->C5_XSTATUS)
							MSGINFO('ATENÇÃO, SÓ É PERMITIDO ALTERAR UM PEDIDO CUJO O STATUS SEJA 000004.')
							Return .F.
						EndIf
					ENDIF
				ENDIF
				
				ACAB        := {}
				AITENS      := {}

				SA1->(DBSETORDER(1))
				SA1->(DBSEEK(XFILIAL("SA1")+alltrim(CCOD_CLI)+alltrim(CLOJA_CLI)))
				
				NOPCPED := IF( EMPTY(SUA->UA_NUMSC5), 3, 4)
				
				IF ! EMPTY(SUA->UA_NUMSC5)
					AADD(ACAB,{"C5_NUM"    ,SUA->UA_NUMSC5,			NIL})
				ENDIF
				
				AADD(ACAB,{"C5_TIPO"   ,"N",			NIL})
				AADD(ACAB,{"C5_CLIENTE",CCOD_CLI,	NIL})
				AADD(ACAB,{"C5_LOJACLI",CLOJA_CLI,	NIL})
				AADD(ACAB,{"C5_LOJAENT",CLOJA_CLI,	NIL})
				AADD(ACAB,{"C5_TIPOCLI",SA1->A1_TIPO,	NIL})
				AADD(ACAB,{"C5_XTABELA",cCodTab,		NIL})
				AADD(ACAB,{"C5_CONDPAG",COD_FPG,		NIL})
				//AADD(ACAB,{"C5_TPFRETE",U_XTPFRETE(CTPFRETE),		NIL})
				AADD(ACAB,{"C5_TPFRETE",CTPFRETE,		NIL})
				AADD(ACAB,{"C5_XUSER", CUSERNAME,		NIL})
				AADD(ACAB,{"C5_TIPLIB",CTPLIBERA,		NIL})
				//AADD(ACAB,{"C5_XADQUIR",cAdquiri,		NIL})
				//AADD(ACAB,{"C5_XBANDEI",cBandei,		NIL})
				//AADD(ACAB,{"C5_XNUMAU",cAutoriz,		NIL})
				//AADD(ACAB,{"C5_NSU",cNSU,	   			NIL})
				AADD(ACAB,{"C5_FRETE",	NFRETE,			NIL})
				AADD(ACAB,{"C5_DESPESA",NDESPESA,		NIL})
				//AADD(ACAB,{"C5_REDESP",COD_RED,      	NIL})
				AADD(ACAB,{"C5_XFRECIF", CXFRECIF,      NIL})
				AADD(ACAB,{"C5_VEND1"  ,_CCOD_VEND,     NIL})
				AADD(ACAB,{"C5_XCRECLI" ,nUsaCred,     NIL})
				//--Vencimentos
				
				AADD(ACAB,{"C5_DATA1" ,dVenc1,     NIL})
				AADD(ACAB,{"C5_PARC1" ,nParc1,     NIL})
				AADD(ACAB,{"C5_XDIAS1" ,nDias1,     NIL})
				AADD(ACAB,{"C5_DATA2" ,dVenc2,     NIL})
				AADD(ACAB,{"C5_PARC2" ,nParc2,     NIL})
				AADD(ACAB,{"C5_XDIAS2",nDias2,     NIL})
				AADD(ACAB,{"C5_DATA3" ,dVenc3,     NIL})
				AADD(ACAB,{"C5_PARC3" ,nParc3,     NIL})
				AADD(ACAB,{"C5_XDIAS3",nDias3,     NIL})
				AADD(ACAB,{"C5_DATA4" ,dVenc4,     NIL})
				AADD(ACAB,{"C5_PARC4" ,nParc4,     NIL})
				AADD(ACAB,{"C5_XDIAS4",nDias4,     NIL})
				
				AADD(ACAB,{"C5_REDESP",cod_Redesp, NIL})
				AADD(ACAB,{"C5_TIPOFAT",'2', NIL})
				//--Entrega retira - Desconto condição de pagamento

				AADD(ACAB,{"C5_ESPECI1",'VOLUMES', NIL})
				//soma dos volumes
				nTotVol := 0
				FOR NX := 1 TO LEN(OORCAMENTO:ACOLS)
					IF NOPCPED==4 .OR. (NOPCPED==3 .AND. (!OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])]))
						nTotVol += OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)]
					ENDIF
				NEXT
				AADD(ACAB,{"C5_VOLUME1",nTotVol, NIL})
				//AADD(ACAB,{"C5_ZPRVFRE",nPrvFrt, NIL})

				_NTOTAL := 0
				cSequen :="01"
				
				If cTPOper == "02"
					cLocAx := "02"
				Else
					cLocAx := "01"
				EndIf
				
				FOR NX := 1 TO LEN(OORCAMENTO:ACOLS)
					//--Smpere iniciar no 01									
					IF NOPCPED==4 .OR. (NOPCPED==3 .AND. (!OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])]))
						
						SA1->(DBSETORDER(1))
						SA1->(DBSEEK(XFILIAL("SA1")+alltrim(CCOD_CLI)+alltrim(CLOJA_CLI)))
										
						DBSELECTAREA("SA7")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SA7") + SA1->A1_COD + SA1->A1_LOJA + OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] )
						
						DBSELECTAREA("SB1")
						DBSETORDER(1)
						DBSEEK(XFILIAL("SB1") + OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] )
						
						ALINHA := {}
						
						NTOTLIN := ROUND((OORCAMENTO:ACOLS[NX,GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)] * OORCAMENTO:ACOLS[NX,GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]),TAMSX3('C6_VALOR')[2])
						
						AADD(ALINHA,{"C6_ITEM"             ,cSequen    ,NIL})
						AADD(ALINHA,{"C6_PRODUTO"          ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)] ,NIL})
						AADD(ALINHA,{"C6_UM"               ,SB1->B1_UM                                                        ,NIL})
						AADD(ALINHA,{"C6_QTDVEN"           ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)]   ,NIL})
						AADD(ALINHA,{"C6_PRCVEN"           ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]  ,NIL})
						//-- IR -- PEDIDO NÃO SERÁ MAIS LIBERADO AUTOMÁTICAMENTE
						//AADD(ALINHA,{"C6_QTDLIB"           ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_QUANT",OORCAMENTO:AHEADER)]   ,NIL})
						AADD(ALINHA,{"C6_VALOR"	           ,NTOTLIN                                                           ,NIL})
												
						If CTPOPER $ '84|87'
							cLocAx	:= '01'
							CTPOPER	:= '87'
							IF ALLTRIM(cFilAnt) $ "0103|0102"
								if SB1->B1_ORIGEM $ "0|2"
									CTPOPER	:= '84'
									cLocAx	:= '03'
								else
									dbSelectArea("SB2")
									SB2->(dbSetOrder(01))
									SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '01'))
									IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
										CTPOPER	:= '87'
										cLocAx	:= '01'
									ELSE
										SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
										IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
											CTPOPER	:= '84'
											cLocAx	:= '03'
										Else
											//--Se nao tiver saldo em nenhum dos dois, deve-se buscar pelo padrão 			
											If SB1->B1_LOCPAD $ '01|90'
												cLocAx:= SB1->B1_LOCPAD
												CTPOPER	:= '87'
											ElseIf SB1->B1_LOCPAD $ '03|80'
												cLocAx:= SB1->B1_LOCPAD
												CTPOPER	:= '84'
											Else
												MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
											EndIf
										EndIf
									ENDIF								
								endif
								CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)								
							ELSE
								CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)			
							ENDIF
							//CTESINT := MATESINT(2,CTPOPER,CCOD_CLI,CLOJA_CLI,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)	
							//cLocAx	:= '01'			
						//ElseIf CTPOPER == '05'		
						//	CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)		
						ElseIf CTPOPER $ '51|52'
							cLocAx	:= '01'
							CTPOPER	:= '51'
							IF ALLTRIM(cFilAnt) $ "0103|0102"
								if SB1->B1_ORIGEM $ "0|2"
									CTPOPER	:= '52'
									cLocAx	:= '03'
								else
									dbSelectArea("SB2")
									SB2->(dbSetOrder(01))
									SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '01'))
									IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
										CTPOPER	:= '51'
										cLocAx	:= '01'
									ELSE
										SB2->(dbSeek(xFilial("SB2") +AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD') + '03'))
										IF SB2->(B2_QATU-B2_QACLASS-B2_RESERVA-B2_QEMP) > 0
											CTPOPER	:= '52'
											cLocAx	:= '03'
										Else
											//--Se nao tiver saldo em nenhum dos dois, deve-se buscar pelo padrão 			
											If SB1->B1_LOCPAD $ '01|90'
												cLocAx:= SB1->B1_LOCPAD
												CTPOPER	:= '51'
											ElseIf SB1->B1_LOCPAD $ '03|80'
												cLocAx:= SB1->B1_LOCPAD
												CTPOPER	:= '52'
											Else
												MsgAlert(OemToAnsi('Produto com armazem padrao diferente de 01/90 ou 03/80'))
											EndIf
										EndIf
									ENDIF				
								endif
								CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)							
							ELSE
								CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)			
							ENDIF
						EndIf
						/*										
						If CTPOPER == '05'
							CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
						Else
							CTESINT := MATESINT(2,CTPOPER,SA1->A1_COD,SA1->A1_LOJA,"C",OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],NIL)
						EndIf
						
						
						IF EMPTY(CTESINT)
							CTESINT := GETMV('LB_TGVTES',.F.,'502')
						ENDIF
		  */				
						//1=TABELA DE PRECO/ 2=TABELA DE PRECO COM DESCONTO FINANCEIRO/ 3=DESCONTO CONCEDIDO
						_AVLDESC := XCLDESCUN(@OORCAMENTO,NX,COD_FPG)
						
						IF	_AVLDESC[3] > 0
							_LTEMDESC	:=	.T.
						ENDIF
						
						IF !(ALLTRIM(SA1->A1_GRPTRIB) $ ALLTRIM(GETMV('LI_GRPTRIB',.F.,'005/006/007/008/012')))
							AADD(ALINHA,{"C6_PRUNIT", OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]   ,NIL})
						ENDIF
						//AADD(ALINHA,{"C6_PRUNIT", OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]   ,NIL})
						//if !empty(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)])
						//	AADD(ALINHA,{"C6_PRUNIT", OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)]   ,NIL})
						//else
						//	AADD(ALINHA,{"C6_PRUNIT", OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]   ,NIL})
						//ENDIF
						
						AADD(ALINHA,{"C6_TES"		       ,CTESINT 	                                                      ,NIL})
						AADD(ALINHA,{"C6_NUMPCOM"          ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPED",OORCAMENTO:AHEADER)]    ,NIL})
						AADD(ALINHA,{"C6_ITEMPC"           ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XPEDIT",OORCAMENTO:AHEADER)]  ,NIL})
						SA3->(dbSetOrder(1))
						SA3->(msSeek(xFilial('SA3') + _CCOD_VEND))
						cCodSup := SA3->A3_SUPER
						if SA3->A3_TIPO == 'I'
							AADD(ALINHA,{"C6_COMIS1"           ,SA3->A3_COMIS  ,NIL})
						else
							AADD(ALINHA,{"C6_COMIS1"           ,OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_XCOMIS",OORCAMENTO:AHEADER)]  ,NIL})
						endif
						//% comissao do supervisor
						SA3->(dbSetOrder(1))
						SA3->(msSeek(xFilial('SA3') + cCodSup))
						if !empty(SA3->A3_COMIS)
							AADD(ALINHA,{"C6_COMIS2"           ,SA3->A3_COMIS  ,NIL})
						endif
						AADD(ALINHA,{"C6_LOCAL"   		   ,cLocAx  ,NIL})
					
						//Alterado para tratar comissao
						//AADD(ALINHA,{"C6_XTABPRC"	, OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]  , NIL})
						//if !empty(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)])
						//if empty(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)])
						//	AADD(ALINHA,{"C6_XTABPRC"	, OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_ZPRCDIG",OORCAMENTO:AHEADER)]  , NIL})
						//else
							AADD(ALINHA,{"C6_XTABPRC"	, OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRCTAB",OORCAMENTO:AHEADER)]  , NIL})
						//endif
						
						IF (OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])]) .AND. NOPCPED==4
							AADD(ALINHA,{"AUTDELETA"	,IF( (OORCAMENTO:ACOLS[NX][LEN(OORCAMENTO:ACOLS[NX])]), "S", "N" )	,NIL})
						ENDIF
						
						dbSelectArea("SB2")
						SB2->(dbSetOrder(01))
						If SB2->(!DbSeek(xFilial("SB2")+AvKey(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],'B2_COD')+AvKey(cLocAx,'B2_LOCAL')))
							CriaSB2(OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_PRODUTO",OORCAMENTO:AHEADER)],cLocAx)
						EndIf
						
						AADD(AITENS,ALINHA)
						
						_NTOTAL += NTOTLIN
						cSequen :=Soma1(cSequen)
					ENDIF
					
				NEXT NX
				
				LMSERROAUTO := .F.
				FSAceArr(ACAB, 	"SC5")
				FSAceArr(AITENS,"SC6")
				MSEXECAUTO({|X,Y,Z| MATA410(X,Y,Z)},ACAB,AITENS, NOPCPED)
				
				IF !LMSERROAUTO //.OR. _LTP9
					CONFIRMSX8()
					MSGINFO("PEDIDO DE VENDA " + SC5->C5_NUM + IIF(NOPCPED==3, " GERADO!"," ALTERADO!"))
					DBSELECTAREA("SUA")
					RECLOCK("SUA",.F.)
						SUA->UA_NUMSC5 := SC5->C5_NUM
					MSUNLOCK()
					
					DBSELECTAREA("SUB")
					DBSETORDER(1)
					SUB->(DBSEEK( XFILIAL("SUB") + SUA->UA_NUM))
					
					Do While SUB->(!EOF()) .AND. XFILIAL("SUB") == SUB->UB_FILIAL .AND. SUA->UA_NUM == SUB->UB_NUM
						RECLOCK("SUB",.F.)
						SUB->UB_NUMPV := SC5->C5_NUM
						MSUNLOCK()
						SUB->(DBSKIP())
					EndDo
					//--Passa o Cliente Inativo para Carteira do vendedor Representante
					SA3->(dbSetOrder(7))
					If SA3->(DbSeek(xFilial("SA3") + __CUSERID))
						//--Verifica se é um vendedor externo
						//If SA3->A3_TIPO == 'E'
						SA1->(DbSetOrder(01))
						If SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
							If AllTrim(SA1->A1_VEND) $ '1000|2000'
								RecLock('SA1',.F.)
								SA1->A1_VEND:= _CCOD_VEND
								SA1->(MsUnLock())
							EndIf
						EndIf
						//EndIf
					EndIf
					
					//Grava e atualiza a Condição Negociada
					If lCondNeg
						fAtuConNeg(SUA->UA_NUM, _CCOD_VEND, _NTTOTFIM, SC5->C5_NUM)
					EndIf
					
					//U_PC5UpdSt("V", xFilial("SUA") + SUA->UA_XNUMPC5)
					//Grava status no pedido
					u_DnyGrvSt(SC5->C5_NUM, "000004")
					
					NCOMISEX	:=  0
					NCOMISS2	:=	0
					
					aArSA3 := GetArea("SA3")
					SA3->(dbSetOrder(1))
					If SA3->(dbSeek(XFILIAL("SA3")+_CCOD_VEND))
						If SA3->A3_TIPO == 'E'
							NCOMISEX := SA3->A3_COMIS
						EndIf
						If !EMPTY(SA3->A3_SUPER)
							_CVENDSUPER := SA3->A3_SUPER
							NCOMISS2 := POSICIONE("SA3",1,XFILIAL("SA3")+_CVENDSUPER, "A3_COMIS")
						EndIf
					EndIf
					RestArea(aArSA3)
					
					If TCSQLExec( cSql ) <> 0
						MsgAlert(OemtoAnsi('Falha na atualização do pedido x condição de pagamento'))
					EndIF
					
					RECLOCK("SC5",.F.)
					SC5->C5_XOBSEXP	:= COBS_EXP
					SC5->C5_XOBSLO	:= COBS_ENT
					SC5->C5_XOBSCO	:= COBS_CO
					SC5->C5_XOBSFIN	:= COBS_FIN
					SC5->C5_TRANSP	:= COD_TRP
					SC5->C5_REDESP	:= cod_Redesp
					SC5->C5_BANCO	:= COD_BANCO
					//SC5->C5_CELULA	:= CCELULA
					SC5->C5_PEDCLI	:= CPEDCLI
					SC5->C5_FECENT	:= DENTREG
					SC5->C5_TIPLIB	:= CTPLIBERA
					//SC5->C5_DESCONT := nDescTota		//Comentado pois é o campo INDENIZACAO
					//LEANDRO.EBER - TRATATIVAS DE DESCONTO NO TOTAL E NO ITEM PARA TRANPORTAR PARA O PEDIDO DE VENDA - 20/10/2016
					SC5->C5_ZVALBRU :=nValItTab
					SC5->C5_ZVALTOT :=nValItTot-nDescTota
					SC5->C5_ZDESITE :=nValItTab-nValItTot
					SC5->C5_ZDESTOT :=nDescT
					//SC5->C5_DESCONT :=nDescTota
					//SC5->C5_COMIS1  :=U_COMISS(nValItTot-nDescTota, nValItTab,cCodTab, COD_FPG) //(nValItTot-nDescTota)/nValItTab
					//SC5->C5_COMIS1  :=iIf(NCOMISEX>0,NCOMISEX,U_COMISS(nValItTot-nDescTota, nValItTab,cCodTab, COD_FPG))
					//SC5->C5_COMIS2  :=NCOMISS2
					//SC5->C5_XMOTBLQ := U_XPVMOTBLQ(_NTTOTFIM,COD_FPG,NFRETE,CTPOPER,/*LPARC*/_LSEMEST,_LTEMDESC,nDescT,nDescLim)
					SC5->C5_XNUMORC :=CDOC
					SC5->C5_ZPRVFRE := nPrvFrt
					
					IF (POSICIONE("SE4",1,XFILIAL("SE4")+COD_FPG,"E4_TIPO")=='9')
						REPLACE SC5->C5_CONDPAG WITH COD_FPG//
					EndIf
					U_IRENT020(SC5->C5_NUM, @nMargemPV)
					SC5->C5_ZMARGPP := nMargemPV[1]
					SC5->C5_ZMARGPL := nMargemPV[2]
					/*If nMargemPV[1] < GetMv('TG_MARGEM',.F.,40)
						SC5->C5_XMOTBLQ := '01'//Rentabilidde
						SC5->C5_BLQ     := '1'
						//Grava status no pedido
						u_DnyGrvSt(SC5->C5_NUM, "000045")
						MsgAlert(OemToAnsi('Pedido bloqueado por rentabilidade. Favor solicitar analise da gerencia'))
					EndIf*/
					If Select("QRYZM1") <> 0
						QRYZM1->(dbCloseArea())
					EndIf

					BeginSQL Alias "QRYZM1"
					SELECT
						ZM1_COR, ZM1_BLQ
					FROM 
						%Table:ZM1% ZM1
					WHERE
						ZM1.%NotDel%
						AND %exp:nMargemPV[1]% >= ZM1_MARGI 
						AND %exp:nMargemPV[1]% < ZM1_MARGF
					EndSql
					if QRYZM1->ZM1_BLQ == 'S' .or. nMargemPV[1] < 0
						SC5->C5_XMOTBLQ := '01'//Rentabilidde
						SC5->C5_BLQ     := '1'
						//Grava status no pedido
						u_DnyGrvSt(SC5->C5_NUM, "000045")
						MsgAlert(OemToAnsi('Pedido bloqueado por rentabilidade. Favor solicitar analise da gerencia'))
					endif

					
					//--Atualizando agenda
					/*If COPER == '1'
						u_gravaAgenda(xFilial('ZAF'), _CNUMORC, "P")
						If MsgYesNo( "Deseja agendar retorno para ? ", "Atenção" )
							_DIGAGEN(CDOC, CCLI, COJA, dAgenda)
						EndIf
					EndIf*/
			
					SC5->(MSUNLOCK())
					
					DBSELECTAREA("SC6")
					SC6->(DBSETORDER(1))
					SC6->(DBGOTOP())
					SC6->(DBSEEK(XFILIAL("SC6")+SC5->C5_NUM))
					WHILE SC6->(!EOF()) .AND. XFILIAL("SC6")==SC6->C6_FILIAL .AND. SC5->C5_NUM==SC6->C6_NUM
						// RENATO BANDEIRA EM 28/11/14 - AVALIAAR SE USAREMOS ESSE CONCEITO
						cProdCTL:=""
						
						DBSELECTAREA("SA7")
						SA7->(DBSETORDER(1))
						SA7->(DBSEEK(XFILIAL("SA7")+SC5->C5_CLIENTE+SC5->C5_LOJACLI+SC6->C6_PRODUTO))
						IF SA7->(!EOF())
							SB1->(DBSEEK(XFILIAL('SB1')+SC6->C6_PRODUTO))
							IF SA7->A7_UMNFE	== "2" .AND. SB1->B1_CONV != 0
								IF ( SB1->B1_TIPCONV != "D" )
									NQTD2 := (SC6->C6_QTDVEN * SB1->B1_CONV)
								ELSE
									NQTD2 := (SC6->C6_QTDVEN / SB1->B1_CONV)
								ENDIF
								CSEGUM   := SB1->B1_SEGUM
								//CXUM     := "2"
							ELSE
								NQTD2    := SC6->C6_UNSVEN
								CSEGUM   := SC6->C6_SEGUM
								//CXUM     := SC6->C6_XUM
							ENDIF
							CPRDCLI     := SA7->A7_CODCLI
						ELSE
							CPRDCLI     := ""
							NQTD2       := SC6->C6_UNSVEN
							CSEGUM      := SC6->C6_SEGUM
							//CXUM        := SC6->C6_XUM
						ENDIF
						
						NCOMVED := 0
						
						RECLOCK("SC6",.F.)
						REPLACE SC6->C6_CODINF  WITH CPRDCLI
						REPLACE SC6->C6_ENTREG  WITH DENTREG
						REPLACE SC6->C6_PEDCLI  WITH CPEDCLI //SUA->UA_NUM //"TMK" + SUA->UA_NUM
						REPLACE SC6->C6_UNSVEN  WITH NQTD2
						REPLACE SC6->C6_SEGUM   WITH CSEGUM
						//REPLACE SC6->C6_XUM     WITH CXUM
						//REPLACE SC6->C6_LOTECTL WITH cProdCTL
						
						SC6->(MSUNLOCK())
						SC6->(DBSKIP())
					ENDDO
					
					
					
					If lBonifica
						ALERT("ATENÇÃO, PEDIDO COM BONIFICAÇÃO, FAVOR ENCAMINHAR PARA O GERENTE!!!!!!!")
					Else
						If lCredito
							ALERT("ATENÇÃO, PEDIDO COM BLOQUEIO DE LIMITE DE CREDITO, FAVOR ENCAMINHAR PARA O FINANCEIRO!!!!!!!")
						Else
						EndIf
					EndIf
					
					//--Valida se não ocorreu bloqueio
					If Empty(SC5->C5_BLQ)
						If MsgYesNo( "Deseja realizar a liberação do pedido ? ", "Atenção" )
							FsLibPed()
						EndIf
					EndIf
					
					
					
				ELSE
					MOSTRAERRO()
					DISARMTRANSACTION()
				EndIf
			EndIf
		Else
			//Grava e atualiza a Condição Negociada
			If lCondNeg
				fAtuConNeg(SUA->UA_NUM, _CCOD_VEND, _NTTOTFIM, "")
			EndIf
		EndIf
	Else
		CONOUT("***********************************************************")
		CONOUT("**   FINAL DA EXECAUTO TMKA271 (ORCAMENTO) : " +TIME() + "    **")		  // FINAL
		CONOUT("**   ERRO NA INCLUSAO DO ORçAMENTO!                      **")		//"ATENDIMENTO INCLUIDO COM SUCESSO! "
		CONOUT("***********************************************************")
		MOSTRAERRO()
		ROLLBACKSX8()
		BREAK
	ENDIF
ENDIF

RESTAREA(AAREA)
CURSORARROW()

IF LRET
	PUTSX1('XRORCA',"01","NUM. ORçAMENTO:","NUM. ORçAMENTO:","NUM. ORçAMENTO:","MV_CH01","C",06,00,00,"G","","SUA","","","MV_PAR01","","","","","","","","","","","","","","","","")
	DBSELECTAREA("SX1")
	SX1->(DBSETORDER(1))
	CPERG := PADR('XRORCA',10)
	IF SX1->(DBSEEK(CPERG))
		IF 	RECLOCK("SX1",.F.)
			REPLACE SX1->X1_CNT01 WITH _CNUMORC
			SX1->(MSUNLOCK())
		ENDIF
	ENDIF
ENDIF

RETURN(LRET)

USER FUNCTION DNYGRVST(CPEDIDO, CCODST)
LOCAL AAREA := GETAREA()
DBSELECTAREA("Z05")
RECLOCK("Z05", .T.)

Z05->Z05_FILIAL := XFILIAL("Z05")
Z05->Z05_PEDIDO	:= CPEDIDO
Z05->Z05_STATUS	:= CCODST
Z05->Z05_DATA	:= DDATABASE
Z05->Z05_HORA	:= TIME()
Z05->Z05_NOMUSU := CUSERNAME

IF Z05->Z05_STATUS == "000003"
	IF Z05->(FIELDPOS("Z05_CPPED")) > 0
		Z05->Z05_CPPED := MONTAHIST()
	ENDIF
ENDIF


Z05->(MSUNLOCK())

//RECLOCK("SC5", .F.)
//SC5->C5_XSTATUS := CCODST
//SC5->(MSUNLOCK())

RESTAREA(AAREA)

RETURN

STATIC FUNCTION CHKTRARC(CUF, CTRAN)
LOCAL AAREAZ03 := Z03->(GETAREA())
LOCAL LRET := .F.

DBSELECTAREA("Z03")
DBSETORDER(1)
IF ( DBSEEK(XFILIAL("Z03")+ CTRAN+ CUF) )
	LRET := .T.
ELSE
	ALERT("TRANSPORTADORA NÃO ATENDE UF DE ENTREGA DO CLIENTE" + CHR(10)+CHR(13)+ "TRANSPORTADORA: " + CTRAN + CHR(10)+CHR(13)+ "UF: " + CUF)
	LRET := .F.
ENDIF

RESTAREA(AAREAZ03)

RETURN LRET

USER FUNCTION XPVMOTBLQ(_NVLPV,_CCP,NFRETE,CTPOPER,LPARC,_LTEMDESC,nDescT,nDescLim)

LOCAL _CMSG      := ''
LOCAL _CRET      := ALLTRIM(CRIAVAR('C5_XMOTBLQ'))
//LOCAL _LNOBLQPRC := (ALLTRIM(PADR(CTPOPER,TAMSX3('UA_XTOPER')[1])) $ ALLTRIM(GETMV('LI_BLBONAM',.F.,'04/R')))

DEFAULT _NVLPV := 0
DEFAULT _CCP   := ''

IF _LSEMEST
	_CRET += '06,'
	_CMSG += '06 - BLOQUEIO POR FALTA DE ESTOQUE";'+ENTER
ENDIF

IF !EMPTY(_CRET)
	_CRET := SUBSTR(_CRET,01,LEN(_CRET)-1)
ENDIF

IF !EMPTY(_CMSG)
	MSGINFO("              -= PEDIDO BLOQUEADO =-"+ENTER+ENTER+;
	"TIPO(S) DE BLOQUEIO(S) DIAGNOSTICADO(S):"+ENTER+;
	_CMSG)
ENDIF

RETURN(_CRET)

STATIC FUNCTION XCLDESCUN(OORCAMENTO,NI,COD_FPG)

LOCAL _ARET := {}
_NTABPRC := U_XTABPRC(COD_CLI, COJA_CLI, SB1->B1_COD)

_NPRCDSC := U_XDESCFIN(_NTABPRC, COD_FPG)
//_NPRCATU := OORCAMENTO:ACOLS[NX, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]
_NPRCATU := OORCAMENTO:ACOLS[NI, GDFIELDPOS("UB_VRUNIT",OORCAMENTO:AHEADER)]

AADD(_ARET, _NTABPRC)
AADD(_ARET, _NPRCDSC)
AADD(_ARET, IIF(_NPRCATU<_NPRCDSC, (_NPRCDSC-_NPRCATU), 0))

RETURN(_ARET)

STATIC FUNCTION MONTAHIST()

_CCPPED := ""

SC6->(DBSETORDER(1))
SC6->(DBSEEK(XFILIAL("SC6")+Z05->Z05_PEDIDO))

DO WHILE SC6->(!EOF()) .AND. SC6->C6_FILIAL==XFILIAL("SC6") .AND. SC6->C6_NUM == Z05->Z05_PEDIDO
	_CCPPED += SC6->C6_PRODUTO+" - "+SC6->C6_DESCRI+" - "+TRANSFORM(SC6->C6_QTDVEN, PESQPICT('SC6','C6_QTDVEN'))+CHR(13)+CHR(10)
	SC6->(DBSKIP())
ENDDO

RETURN _CCPPED

USER FUNCTION COMISS(nPrcVen, xTabPrc, cCodTab, COD_FPG)

LOCAL NRETORNO	:=	0 //(nPrcVen - xTabPrc) / xTabPrc * 100
//LOCAL NRETCOMIS	:=	0
//LOCAL ALISX1	:=	{}
//LOCAL _NLISX1	:=	0
//LOCAL XALTABDES :=	{}	//ACLONE(__ALTABDESC)

If nPrcVen==0 .OR. xTabPrc==0
	Return 0
EndIf

//BONIFICAÇÃO NAO GERA COMISSAO
SE4->(DbSetOrder(01))
IF SE4->(DbSeek(xFilial('SE4')+COD_FPG))
	If "BON" $ SE4->E4_DESCRI
		Return 0
	ElseIf "CR " $ SE4->E4_DESCRI
		Return 0
	Endif
ENDIF

NRETORNO	:=	 ROUND((((nPrcVen/xTabPrc)*100)-100)*-1,2)
/*
ZZ1->(DBSETORDER(1))
ZZ1->( DBSEEK(XFILIAL("ZZ1") + cCodTab )  )
WHILE ! ZZ1->( EOF()) .AND. ZZ1->ZZ1_CODIGO == cCodTab
AADD( XALTABDESC, {ZZ1->ZZ1_DESCAT,ZZ1->ZZ1_COMIS} )
ZZ1->( DBSKIP())
ENDDO

XALTABDESC := ASORT(XALTABDESC,,, { |X, Y| X[1] < Y[1] })
FOR NCTT:=	1 TO LEN( XALTABDESC)
IF NRETORNO	<=	XALTABDESC[NCTT][1]
IF NRETORNO < 0
IF LEN( XALTABDESC) > 1

IF NCTT == 1
NRETORNO:=		XALTABDESC[1][2]
ELSE
If NCTT-1>0 .AND. NCTT-1<LEN(XALTABDESC)
NRETORNO:=		XALTABDESC[ NCTT-1][2]
EndIf
ENDIF
ELSE
NRETORNO:=		XALTABDESC[1][2]
ENDIF
ELSE
NRETORNO:=		XALTABDESC[NCTT][2]
ENDIF
RETURN(	NRETORNO)
ENDIF
NEXT NCTT
*/
//--Se chegar nesse ponto, considera a ultima faixa
//NRETORNO	:=		IIF(Len(XALTABDESC)>0,XALTABDESC[NCTT][3],0)
NRETORNO	:=		0

RETURN NRETORNO

User /*Static*/ Function FAjuCom(aCab,aItens)

Local nXi		:= 0
Local aIteAux	:= {}
Local aIteNew	:= {}
Local nTotCom	:= 0
Local nTotPdv	:= 0
Local nPerTot	:= 0
Local nVlrCom	:= 0
Local nPerCom	:= 0
Local nComMin := GetNewpar("JP_COMMIN", 0.8)
Local nComMax := GetNewpar("JP_COMMAX", 1.2)
Local lRecalc	:= .F.

//Calcula valor total do pedido e de comissao
For nXi:= 1 To Len(aItens)
	aIteAux:= aClone(aItens[nXi])
	nTotPdv+= U_FSRetVal(aIteAux,"C6_VALOR")
	nTotCom+= (U_FSRetVal(aIteAux,"C6_VALOR") * U_FSRetVal(aIteAux,"C6_COMIS1")) / 100
Next nXi

//Calcula o percentual total da comissao
nPerTot:= (nTotCom * 100) / nTotPdv

//Avalia se eh menor do que o
If nPerTot < nComMin
	nPerTot	:= nComMin
	lRecalc	:= .T.
ElseIf nPerTot > nComMax
	nPerTot	:= nComMax
	lRecalc	:= .T.
EndIf

//Recalcula comissao
If lRecalc
	//Valor de comissao
	nTotCom:= nTotPdv * nPerTot / 100
	
	//Calcula comissao por item
	For nXi:= 1 To Len(aItens)
		aIteAux:= aClone(aItens[nXi])
		nVlrCom:= (U_FSRetVal(aIteAux,"C6_VALOR") * nTotCom) / nTotPdv
		nPerCom:= nVlrCom * 100 / U_FSRetVal(aIteAux,"C6_VALOR")
		
		//Ajusta novo valor de comissao
		U_FSSetVal(aIteAux,"C6_COMIS1",nPerCom)
		
		Aadd(aIteNew,aIteAux)
	Next nXi
	
	//Atualiza itens do pedido
	aItens:= aClone(aIteNew)
EndIf

Return

User Function FSRetVal(aArray,cCampo)

Local xRet
Local nPos:= 0

If (nPos:= aScan(aArray,{|x| Alltrim(x[1]) == Alltrim(cCampo)})) <> 0
	xRet := aArray[nPos,2]
EndIf

Return(xRet)

User Function FSSetVal(aArray,cCampo,cConteudo)

Local nPos:= 0

If (nPos:= aScan(aArray,{|x| Alltrim(x[1]) == Alltrim(cCampo)})) <> 0
	aArray[nPos,2]:= cConteudo
EndIf

Return

//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FSGravaSCV
Função utilizada para exibir grid com as opções para o usuario informar o tipo de
pagamento

@author		P2P
@since     	12/09/16
@version  	P.11
@param 		oGetDad - Array com dados da SCV
@param 		cNumOrc - Numero da cotação
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FSGravaSCV(oGetDad, cNumOrc)

Local aAreaOld	:= {SCV->(GetArea()),GetArea()}
Local cTabAux	:= 'SCV'
Local cSql		:= ''
Local nLin

//BeginTran()
//--Caso exista registro gravado deve-se deletar
cSql += "UPDATE "+RetSqlName("SCV")+" SET D_E_L_E_T_ = '*' "
cSql += "WHERE CV_FILIAL = '"+xFilial('SCV')+"' And CV_XORCAME = '"+cNumOrc+"' "
cSql += "AND D_E_L_E_T_ <> '*' "

If TCSQLExec( cSql ) <> 0
	MsgAlert(OemtoAnsi('Erro ao excluir registro de Cotacao x Cond Pgt SCV'))
EndIf

DbSelectArea(cTabAux)
For nLin:= 1 To Len(oGetDad)
	Reclock((cTabAux),.T.)
	Replace CV_FILIAL 	With xFilial('SCV'),;
	CV_FORMAPG  With oGetDad[nLin][1],;
	CV_DESCFOR	With oGetDad[nLin][2],;
	CV_XDATA	With oGetDad[nLin][3],;
	CV_XVALOR	With oGetDad[nLin][4],;
	CV_XORCAME  With cNumOrc
	(cTabAux)->(MsUnLock())
Next nLin

//EndTran()
//--Necessario retirar o Begin, pois o sistema não estava fazendo a inlcusao
//--Restaura Area
Aeval(aAreaOld,{|x| RestArea(x)})

Return(Nil)

Static Function FSAceArr(aArrPar, cAliasSX3)

Local nPos          := 0
//Local nXi        := 0
Local aArrAux     := {}

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAliasSX3,.T.)
While !Eof() .And. (X3_ARQUIVO==cAliasSX3)
	
	//Acerta array com somente uma linha
	If (nPos:= aScan(aArrPar,{|x| Alltrim(x[1]) == Alltrim(X3_CAMPO) })) <> 0
		aadd(aArrAux,aClone(aArrPar[nPos]))
	EndIf
	
	dbSkip()
	
EndDo

Return(aArrAux)

Static Function	fBuscCred(nVenda)

Local _oDlgCred
Local nVlrCre := 0
Local lContin := .F.
Local nUsrCre := 0
Local nValVen := nVenda
Local nEmPedi := 0

Private lValCre := .F.

cQuery := "SELECT SUM(SE1.E1_SALDO) E1SALDO "
cQuery += "FROM "+RetSqlName("SE1")+" SE1 "
cQuery += "WHERE SUBSTRING(SE1.E1_FILIAL,1,2)  = '"+SubStr(xFilial("SE1"),1,2)+"' "
cQuery += "AND   SE1.E1_CLIENTE = '"+cod_cli+"' "
cQuery += "AND   SE1.E1_LOJA    = '"+coja_cli+"' "
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
	nVlrCre := CRE->E1SALDO
EndIf

If Select("CRE") > 0
	dbSelectArea("CRE")
	dbCloseArea()
EndIf

//nVlrCre:= 0  // alterado por rodolfo para não paresentar credito para abater.

If nVlrCre > 0
	//lContin := MsgYesNo('Este cliente possuí credito no valor de R$ ' +Alltrim(Transform(nVlrCre, "@E 999,999,999,999.99")) + "."+ENTER+;
	//' Deseja Utilizar??', '-= Credito de Cliente =-')
	Msgalert('Este cliente possuí credito no valor de R$ ' +Alltrim(Transform(nVlrCre, "@E 999,999,999,999.99")) + "."+ENTER+;
	' Favor solicitar ao financeiro caso queira utilizar', '-= Credito de Cliente =-')
EndIf

If lContin
	
	cQuery := "SELECT SUM(SC5.C5_XCRECLI) EMPEDIDO "
	cQuery += "FROM "+RetSqlName("SC5")+" SC5 "
	cQuery += "WHERE SUBSTRING(SC5.C5_FILIAL,1,2)  = '"+SubStr(xFilial("SC5"),1,2)+"' "
	cQuery += "AND   SC5.C5_CLIENTE = '"+cod_cli+"' "
	cQuery += "AND   SC5.C5_LOJACLI = '"+coja_cli+"' "
	cQuery += "AND   SC5.C5_XCRECLI > 0 "
	cQuery += "AND   SC5.C5_NOTA = '' "
	cQuery += "AND   SC5.D_E_L_E_T_ <> '*' "
	If Select("PED") > 0
		dbSelectArea("PED")
		dbCloseArea()
	EndIf
	
	TcQuery cQuery New Alias "PED"
	
	dbSelectArea("PED")
	DBGOTOP()
	If !Eof()
		nEmPedi := PED->EMPEDIDO
	EndIf
	
	If Select("PED") > 0
		dbSelectArea("PED")
		dbCloseArea()
	EndIf
	
	Do While !lValCre
		
		DEFINE MSDIALOG _oDlgCred TITLE "Utilização de Crédito no TGV" FROM 100,100 TO 400,700 PIXEL Style DS_MODALFRAME
		
		Tsay():New(020,20,{|| OemToAnsi("Credito a utilizar:")} ,_oDlgCred,,,,,,.T.,,100,200)
		TGet():New(020,120,{|u| if(PCount()>0,nUsrCre:=u,nUsrCre)},_oDlgCred,100,15,"@E 999,999,999,999.99",{|| fValeCred(nUsrCre,nValVen,nVlrCre)},,,,,,.T.,,,,,,,,,,"nUsrCre")
		
		Tsay():New(060,20,{|| OemToAnsi("Credito Usado : R$"+Alltrim(Transform(nEmPedi,"@E 999,999,999,999.99")))} ,_oDlgCred,,,,,,.T.,,200,200)
		
		Tsay():New(080,20,{|| OemToAnsi("Valor da Venda : R$"+Alltrim(Transform(nValVen,"@E 999,999,999,999.99")))} ,_oDlgCred,,,,,,.T.,,200,200)
		
		Tsay():New(100,20,{|| OemToAnsi("Valor do Credito: R$"+Alltrim(Transform(nVlrCre,"@E 999,999,999,999.99")))} ,_oDlgCred,,,,,,.T.,,300,200)
		
		@ 120,248 Button "Confirma" Size 050,020 ACTION fImputCred(nUsrCre) .AND. _oDlgCred:End() PIXEL OF _oDlgCred
		
		ACTIVATE MSDIALOG _oDlgCred CENTERED
		
	EndDo
	
EndIf

Return (.T.)

Static Function	fValeCred(nUso,nVen,nCre)

If nUso <= nVen .AND. nUso <= nCre
	
	lValCre := .T.
	
	Return (.T.)
EndIf

If nUso < 0
	ApMsgAlert("Valor a ser utilizado é inválido. Verifique!")
	Return (.F.)
EndIf

If nUso > nVen
	ApMsgAlert("Valor a ser utilizado é maior do que a Venda. Verifique!")
	Return (.F.)
EndIf

If nUso > nCre
	ApMsgAlert("Valor a ser utilizado é maior do que o Crédito. Verifique!")
	Return (.F.)
EndIf


Return (.F.)


Static Function	fImputCred(nValor)

If fValeCred()
	nUsaCred := nValor
EndIf

Return (.T.)

Static Function fAtuConNeg(cCodOrc, cCodVend, nTotOrc, cNumPed)

Local cSQL		:= ""
Local lContinua	:= .T.
Local nSequenc	:= 1
Local nX

Default cCodOrc		:= ""
Default cCodVend	:= ""
Default nTotOrc		:= 0
Default cNumPed		:= ""

cSQL := "DELETE FROM "+RetSqlName("SZ1")+""
cSQL += " WHERE Z1_ORCAMEN = "+AllTrim(cCodOrc)+""

If TcSQLExec(cSQL) <> 0
	Aviso("Condição Negociada","Ocorreu um erro ao gerar a condição negociada. Favor revisar o Orçamento e salvar novamente.",{"OK"})
	lContinua	:= .F.
EndIf

If lCondNeg .And. lContinua
	For nX := 1 To Len(oGetConNe:aCols)
		If !oGetConNe:aCols[nX][Len(oGetConNe:aCols[nX])] .And. !EMPTY(oGetConNe:aCols[nX][nPosCond])
			RecLock("SZ1", .T.)
			SZ1->Z1_FILIAL	:= xFilial("SZ1")
			SZ1->Z1_ORCAMEN	:= cCodOrc
			SZ1->Z1_PEDIDO	:= cNumPed
			SZ1->Z1_CODVEN	:= cCodVend
			SZ1->Z1_TOTPED	:= nTotOrc
			SZ1->Z1_SEQUENC	:= AllTrim(StrZero(nSequenc,3))//oGetConNe:aCols[nX][nPosSeq]
			SZ1->Z1_COND	:= oGetConNe:aCols[nX][nPosCond]
			SZ1->Z1_NATUREZ	:= oGetConNe:aCols[nX][nPosNat]
			SZ1->Z1_DTIVENC	:= oGetConNe:aCols[nX][nPosDtIVen]
			SZ1->Z1_DTFVENC	:= oGetConNe:aCols[nX][nPosDtFVen]
			SZ1->Z1_VALCON	:= oGetConNe:aCols[nX][nPosValCon]
			SZ1->Z1_VALPAR	:= oGetConNe:aCols[nX][nPosValPar]
			SZ1->Z1_NSU		:= oGetConNe:aCols[nX][nPosValNsu]
			SZ1->Z1_ADQUIRI	:= oGetConNe:aCols[nX][nPosValAdq]
			SZ1->Z1_AUTORIZ	:= oGetConNe:aCols[nX][nPosValAut]
			SZ1->Z1_CODBAND	:= oGetConNe:aCols[nX][nPosValCob]
			SZ1->Z1_BANDEIR	:= oGetConNe:aCols[nX][nPosValBan]
			
			SZ1->(MsUnlock())
			
			nSequenc++
		EndIf
	Next nX
EndIf

Return()

Static Function fBuscPromo(cProdu)

Local nResul := 0

DbSelectArea("SZ2")

SZ2->(DbSetOrder(3))

If SZ2->(MsSeek(xFilial("SZ2")+'1'+AvKey(cProdu,'Z2_PRODUTO')))
	
	Do While !EOF() .AND. SZ2->Z2_FILIAL + AllTrim(SZ2->Z2_PRODUTO)  == xFilial("SZ2") + AllTrim(cProdu)
		
		If SZ2->Z2_DTIVIGE <= dDatabase .AND. SZ2->Z2_DTFVIGE >= dDatabase
			
			If	cCodTab == '001'
				nResul := SZ2->Z2_PRCTAB1
			ElseIf 	cCodTab == '002'
				nResul := SZ2->Z2_PRCTAB2
			ElseIf 	cCodTab == '003'
				nResul := SZ2->Z2_PRCTAB3
			ElseIf 	cCodTab == '004'
				nResul := SZ2->Z2_PRCTAB4
			ElseIf 	cCodTab == '005'
				nResul := SZ2->Z2_PRCTAB5
			ElseIf 	cCodTab == '006'
				nResul := SZ2->Z2_PRCTAB6
			ElseIf 	cCodTab == '007'
				nResul := SZ2->Z2_PRCTAB7
			ElseIf 	cCodTab == '008'
				nResul := SZ2->Z2_PRCTAB8
			EndIf
			
		EndIf
		
		DBSelectArea("SZ2")
		DBSkip()
		
	EndDo
	
EndIf

Return (nResul)

Static Function FsLibPed()

Local nLiberou	:= 0
Local lPode		:= .T.
Local nValItTot	:= 0
LOCAL aRegistros    := {}
LOCAL _TEMSC9 := .F.
Pergunte("MTA440",.F.)

Public lTransf:= MV_PAR01==1
Public lLiber := MV_PAR02==1
Public lSugere:= MV_PAR03==1

//-- IR -- Necessário estornar a liberação do pedido antes de liberar novamente.
aEstLibPv(SC5->C5_FILIAL,SC5->C5_NUM)

dbSelectArea("SC6")
SC6->( dbSetOrder(1) )
SC6->( dbSeek(SC5->C5_FILIAL+SC5->C5_NUM))
Do While (SC6->(!Eof()) .And. SC5->C5_FILIAL+SC5->C5_NUM == SC6->(C6_FILIAL+C6_NUM))
	
	
	nValItTot += SC6->C6_VALOR
	//--Produto que controla Lote deve-se avaliar sem validar estoque
	
	//	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN		,.F.		,.F.		,.T.,.T.,lLiber,lTransf)
	//	MaLibDoFat(nRegSC6,      nQtdaLib               ,lCredito   ,lEstoque   ,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lGeraDCF,nVlrCred,nQtdalib2)
	
	
	IF SC6->C6_QTDVEN > SC6->C6_QTDENT  .and. !AllTrim(SC6->C6_BLQ) $ "SR"
		
		IF  SC5->C5_TIPLIB == '2'
			RecLock("SC6")
			SC6->C6_QTDLIB := SC6->C6_QTDVEN
			MsUnLock()
			aadd(aRegistros,SC6->(RecNo()))
		ELSEIF SC5->C5_TIPLIB == '1'
			nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.T.,.T.,lLiber,lTransf)
		endif
		
	endif
	/*
	If Rastro(SC6->C6_PRODUTO)
	nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.T.,.T.,.F.,lLiber,lTransf)
	Else
	nLiberou  += MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.F.,.T.,.T.,lLiber,lTransf)
	EndIf
	*/
	SC6->( dbSkip() )
EndDo

lLiber:=.F.
lTransf:=.f.

If ( Len(aRegistros) > 0 )
	Begin Transaction
	SC6->(MaAvLibPed(SC5->C5_NUM,lLiber,lTransf,.F.,aRegistros,Nil,Nil,Nil,Nil))
	End Transaction
EndIf

MSUnlockAll()

SC6->(MaLiberOk({SC5->C5_NUM},.T.))

If SC5->C5_TIPO == 'N'
	
	//--Posicionamento no cliente
	SA1->(DbSetOrder(01))
	SA1->(DbSeek(xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI))
	
	dbSelectArea("SC9")
	SC9->(dbGoTop())
	SC9->(DBSEEK(XFILIAL("SC5")+SC5->C5_NUM))
	Do While SC9->(!EOF()) .AND. XFILIAL("SC9")==SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO
		If xFilial("SC5") == SC9->C9_FILIAL .AND. SC5->C5_NUM==SC9->C9_PEDIDO
			//--Valida se teve bloqueio de credito
			_TEMSC9 := .T.
			If !Empty(SC9->C9_BLCRED)
				lPode := .F.
			EndIf
		EndIf
		SC9->(dbSkip())
	EndDo
	
	If !lPode
		ALERT(OemToAnsi("AGUARDE A LIBERAÇÃO DA ANALISE DE CRÉDITO!!!"))
		u_DnyGrvSt(SC5->C5_NUM, "000036") //Informa que pedido está em analise de crédito.
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
		ENDIF
	Else
		MsgInfo('PEDIDO APTO A FATURAR!!')
		u_DnyGrvSt(SC5->C5_NUM, "000007")
		IF EMPTY(SC5->C5_LIBEROK) .AND.	_TEMSC9 == .T.
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->(MsUnLock())
		ENDIF
	EndIf
EndIf//Fim validação tipo do pedido

Return( Nil )



Static Function aEstLibPv(cFilPed,cPedido)

Local aArea	:= GetArea()

//------------------+
// Posiciona Pedido |
//------------------+
dbSelectArea("SC9")
SC9->( dbSetOrder(1) )
If SC9->( dbSeek(cFilPed + cPedido ) )
	While SC9->( !Eof() .And. cFilPed + cPedido == SC9->( C9_FILIAL + C9_PEDIDO ) )
		If Empty(SC9->C9_NFISCAL) .And. Empty(SC9->C9_SERIENF)
			//--------------------------+
			// Estorna Liberação Pedido |
			//--------------------------+
			a460Estorna(.T.,.F.)
		EndIf
		SC9->( dbSkip() )
	EndDo
EndIf

RestArea(aArea)

Return .T.
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FGravaAge
Função grava agenda 

@author		.iNi Sistemas
@since     	01/03/2019
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
Static Function FGravaAge(CDOC, CCLI, COJA, dAgenda, cHistor)

	Local cId 	:= U_TAG06PRX()
	Local lSeek	:= .F.
	
	ZAF->(DbSetOrder(2))
	lSeek:= ZAF->(DbSeek(xFilial("ZAF") + CDOC + "2"))
	
	RecLock("ZAF",!lSeek)
	   ZAF->ZAF_FILIAL  := xFilial("ZAF")
	   ZAF->ZAF_TPAGEN  := '000002'
	   ZAF->ZAF_DATINC  := dDataBase
	   ZAF->ZAF_HORINC  := Time()
	   ZAF->ZAF_DTAGEN  := dAgenda
	   ZAF->ZAF_CONTAT  := ''
	   ZAF->ZAF_FORMA   := '1'
	   ZAF->ZAF_PROSP   := '2'
	   ZAF->ZAF_CLIENT  := CCLI
	   ZAF->ZAF_LOJA    := COJA
	   ZAF->ZAF_HISTOR  := cHistor
	   ZAF->ZAF_USRINC  := __cUserId
	   ZAF->ZAF_ID      := cId
	   ZAF->ZAF_IDPAI   := cId
	   ZAF->ZAF_ATEND   := "2"
	   ZAF->ZAF_NUMORC	:= CDOC
	ZAF->(MsUnLock())

Return( Nil )                         

Static function _DIGAGEN(CDOC, CCLI, COJA, dAgenda)
                                 
Local oSayHis01, oDlgHInc
Local oHisDth, oDlgDT
Local oHButton1, oHButton2
//Local cTitulo := SPACE(06)
//Local cDescric:= SPACE(40)
//Local cHora   := Time()
Local dDtAgen := dAgenda
Local cHistor := Space(50)
Local oHistor := Nil
Local nOpca   := 0

DEFINE MSDIALOG oDlgDT TITLE "Data Programada" FROM C(000),C(000)  TO C(180),C(280) COLORS 0, 16777215 PIXEL

@ C(007),C(005) SAY   oSayHis01 PROMPT "Data Agendamento:"       SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(007),C(055) MSGET oHisDth  VAR dDtAgen  PICTURE '99/99/9999' SIZE C(040),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(025),C(005) SAY   oSayHis01 PROMPT "Historico:"       		 SIZE C(075),C(007) OF oDlgHInc COLORS 0, 16777215 PIXEL
@ C(035),C(005) MSGET oHistor  VAR cHistor   					 SIZE C(130),C(009) OF oDlgHInc COLORS 0, 16777215 PIXEL

@ C(060),C(010)	BUTTON oHButton1 PROMPT "&Confirma"              SIZE C(052),C(018) OF oDlgHInc ACTION (nOpca:=1,oDlgDT:End()) PIXEL
@ C(060),C(080) BUTTON oHButton2 PROMPT "&Sair"                  SIZE C(052),C(018) OF oDlgHInc ACTION (nOpca:=0,oDlgDT:End()) PIXEL

ACTIVATE MSDIALOG oDlgDT CENTERED

If nOpca == 1
 	FGravaAge(Space(6), CCLI, COJA, dDtAgen, cHistor)							
EndIf	

Return(Nil)
