#include "protheus.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: BFIN001         AUTOR:                        DATA: 24/01/12
----------------------------------------------------------------------------

DESCRICAO: Impresao de carta de solicitacao de TED/DOC para ser enviado ao 
banco. Geracao automatica na rotina de transferencia no movimento bancario.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function A100BL01()

Local aArea	:= GetArea()

Local _cBcoOrig		:= PARAMIXB[1]
Local _cAgOrig		:= PARAMIXB[2]
Local _cCtaOrig		:= PARAMIXB[3]
Local _cBcoDes		:= PARAMIXB[5]
Local _cAgDest		:= PARAMIXB[6]
Local _cCtaDest		:= PARAMIXB[7]
Local _nValorTran	:= PARAMIXB[10]
Local _cDocumento:= PARAMIXB[11]
Local _cFavorecido  := PARAMIXB[12]
Local _cHistorico    := PARAMIXB[13]

// chama relatorio de impressao
u_ImprimeCarta(_cBcoOrig,_cAgOrig,_cCtaOrig,_cBcoDes,_cAgDest,_cCtaDest,_nValorTran,_cDocumento,_cFavorecido,_cHistorico)

RestArea(aArea)

Return

*******************************************************
// Impressao da Carta

User FUNCTION ImprimeCarta(_cBcoOrig,_cAgOrig,_cCtaOrig,_cBcoDes,_cAgDest,_cCtaDest,_nValorTran,_cDocumento,_cFavorecido,_cHistorico)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := " "
Local cPict          := ""
Local titulo         := "Carta"
Local Li             := 80

Local Cabec1         := " "
Local Cabec2         := " "
Local imprime        := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "P"
Private nomeprog     := "CARTA"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CARTA"
Private cString := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Monta a interface padrao com o usuario...                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,li,_cBcoOrig,_cAgOrig,_cCtaOrig,_cBcoDes,_cAgDest,_cCtaDest,_nValorTran,_cDocumento,_cFavorecido,_cHistorico) },Titulo)

SET DEVICE TO SCREEN

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impressao em disco, chama o gerenciador de impressao...          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

***********************************************************
Static Function RunReport(Cabec1,Cabec2,Titulo,Li,_cBcoOrig,_cAgOrig,_cCtaOrig,_cBcoDes,_cAgDest,_cCtaDest,_nValorTran,_cDocumento,_cFavorecido,_cHistorico)

Local TabMes:={}
Local 	cNomBcoDest	:= " "
Local 	cEndBcoDest		:= " "
Local cNomBcoOrig		:= " "
Local 	cEndBcoOri			:= " "
Local cValorEst				:= " "

TabMes   := {"Janeiro", "Fevereiro", "Mar�o", "Abril", "Maio", "Junho",;
"Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"}

// dados do destino
DbSelectArea("SA6")
DbSetOrder(1)
If MsSeek(xfilial("SA6")+_cBcoDes+_cAgDest+_cCtaDest)
	cNomBcoDest	:= SA6->A6_NOME
	cEndBcoDest		:= SA6->A6_END
EndIf

DiaStr       := substr(dtoc(SE5->E5_DATA),1,2)
MesProc      := substr(dtoc(SE5->E5_DATA),4,2)
AnoStr       := substr(dtos(SE5->E5_DATA),1,4)
MesStr       := TabMes[Val(MesProc)]

// dados da origem
DbSelectArea("SA6")
DbSetOrder(1)
If MsSeek(xfilial("SA6")+_cBcoOrig+_cAgOrig+_cCtaOrig)
	cNomBcoOrig	:= SA6->A6_NOME
	cEndBcoOri		:= SA6->A6_END
EndIf

li:=5

@li,30   PSAY "Joinville, "+Alltrim(DiaStr)+" de "+alltrim(MesStr)+" de "+alltrim(AnoStr)
li:=li+3

@li,06   PSAY "Ao Banco "
@li+1,06 PSAY cNomBcoOrig
@li+2,06 PSAY cEndBcoOri

li:=li+6

@li,06   PSAY "Prezados Senhores,"

li:=li+4

@li,06   PSAY "Ref: AUTORIZACAO DE DEBITO"
@li+1,11 PSAY "TRANSFERENCIA DE VALORES"
@li+2,11 PSAY "FAVORECIDO: "
@li+2,23 PSAY _cFavorecido

li:=li+7

@li,10   PSAY "Pela presente, autorizamos este Banco, a debitar nesta data, em"
@li+1,06 PSAY "nossa Conta Corrente Nr:"
@li+1,30 PSAY _cCtaOrig
@li+1,45 PSAY "Agencia: "
@li+1,54 PSAY _cAgOrig

@li+2,06 PSAY "o valor de R$ "
@li+2,20 PSAY _nValorTran PICTURE "@E 999,999,999.99"
@li+2,35 PSAY "e efetuarem a transfer�ncia em favor de:"

li:=li+6

cValorExt	:= Extenso(_nValorTran)

@li,06   PSAY   "NR BANCO: "
@li,15   PSAY   _cBcoDes
@li,19   PSAY  "-"
@li,21   PSAY   cNomBcoDest
@li+1,06 PSAY "AGENCIA : "
@li+1,15 PSAY _cAgDest
@li+2,06 PSAY "CONTA NR: "
@li+2,15 PSAY _cCtaDest
@li+3,06 PSAY "ENDERECO: "
@li+3,15 PSAY cEndBcoDest
@li+4,06 PSAY "   VALOR: "
@li+4,15 PSAY _nValorTran PICTURE "@E 999,999,999.99"
@li+5,06 PSAY "   VALOR POR EXTENSO: "
@li+5,28 PSAY substr(cValorExt,001,050)
@li+6,28 PSAY substr(cValorExt,051,050)
@li+7,28 PSAY substr(cValorExt,101,050)
@li+8,28 PSAY substr(cValorExt,151,050)

li := Li + 10

@li,06   PSAY "Finalidade: CREDITO NA CONTA CORRENTE DE BRASCOLA JUNTO AO FAVORECIDO."
li:=li+4

@li,45   PSAY "Atenciosamente,"
li := li+4
@li,35 PSAY repl("-",35)
li:= li+1
@li,45 PSAY SM0->M0_NOMECOM


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Finaliza a execucao do relatorio...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Return