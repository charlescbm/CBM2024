#INCLUDE "MATR290.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RESTR11  � Autor � Ricardo Berti         � Data �18.07.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao da Analise de Estoques                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � SIGAEST                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RESTR11()

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL Tamanho   := "G"
LOCAL titulo    := STR0001	//"Relacao para Analise dos Estoques"
LOCAL cDesc1    := STR0002	//"Este relatorio demonstra a situacao de cada item em relacao ao"
LOCAL cDesc2    := STR0003	//"seu saldo , seu empenho , suas entradas previstas e sua classe"
LOCAL cDesc3    := STR0004	//"ABC."
LOCAL cString   := "SB1"
LOCAL nTipo     := 0
LOCAL aOrd      := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008),OemToAnsi(STR0020)}  //############" Por Consumo //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "
LOCAL wnrel	    := "RESTR11"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
Private lVEIC	:= UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod	:= {}
Private aSB1Ite	:= {}
Private nCOL1	:= 0
Private nCOL2	:= 0
Private XSB1, XSB2, XSB3, XSC1, XSC2, XSC6, XSC7, XSC9, XSF4

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn := {OemToAnsi(STR0009), 1,OemToAnsi(STR0010), 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nLastKey:= 0 
PRIVATE cPerg   := U_CriaPerg("MTR290")

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
    Final(STR0023+"SIGACUS.PRW !!!")  //"Atualizar "
Endif
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
    Final(STR0023+"SIGACUSA.PRX !!!") //"Atualizar "
Endif
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
    Final(STR0023+"SIGACUSB.PRX !!!") //"Atualizar "
Endif

DbSelectArea("SF4")
DbSetOrder(1)
XSF4:= XFILIAL("SF4")

DbSelectArea("SC9")
DbSetOrder(1)
XSC9:= XFILIAL("SC9")

DbSelectArea("SC7")
DbSetOrder(1)
XSC7:= XFILIAL("SC7")

DbSelectArea("SC6")
DbSetOrder(1)
XSC6:= XFILIAL("SC6")

DbSelectArea("SC2")
DbSetOrder(1)
XSC2:= XFILIAL("SC2")

DbSelectArea("SC1")
DbSetOrder(1)
XSC1:= XFILIAL("SC1")

DbSelectArea("SB3")
DbSetOrder(1)
XSB3:= XFILIAL("SB3")

DbSelectArea("SB2")
DbSetOrder(1)
XSB2:= XFILIAL("SB2")

DbSelectArea("SB1")
DbSetOrder(1)
XSB1:= XFILIAL("SB1")

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
aSB1Cod:= TAMSX3("B1_COD")
aSB1Ite:= TAMSX3("B1_CODITE")

If lVEIC
   // nao tera'  a ordem de Consumo na gestao de veiculos. Marcos Hirakawa. 
	aOrd := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008)}  //############" Por Consumo //" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "
	nCOL1:= ABS(aSB1Cod[1] - aSB1Ite[1])
	nCOL2:= -15
EndIf

//��������������������������������������������������������������Ŀ
//� Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI                �
//����������������������������������������������������������������
AjustaSX1(cPerg,lVeic,aSB1Cod,aSB1Ite)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Produto de                                   �
//� mv_par02     // Produto ate                                  �
//� mv_par03     // tipo de                                      �
//� mv_par04     // tipo ate                                     �
//� mv_par05     // grupo de                                     �
//� mv_par06     // grupo ate                                    �
//� mv_par07     // descricao de                                 �
//� mv_par08     // descricao ate                                �
//� mv_par09     // Tudo ou so a Comprar                         �
//� mv_par10     // Subtrai empenho para Calculo Saldo           �
//� mv_par11     // Lista apenas itens obsoletos                 �
//� mv_par12     // data limite p/itens obsoletos                �
//� mv_par13     // Cons. Saldo do Almox. Processo ?  Sim , Nao  �
//� mv_par14     // Desconsidera P.V. que N Atu.Est.? Sim , Nao  �
//� mv_par15     // Lista produto com Saldo zerado  ? Sim , Nao  �
//� mv_par16     // Considera OPs 1- Firmes 2- Previstas 3- Ambas�
//� mv_par17     // Almoxarifado De  ?                           �
//� mv_par18     // Almoxarifado Ate ?                           �
//� mv_par19     // Consid Residuos PV ?  Sim, Nao               �
//����������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey = 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter to
	Return
Endif
RptStatus({|lEnd| C290Imp(aOrd,@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C290IMP  � Autor � Rodrigo de A. Sartorio� Data � 12.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � RESTR11                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C290Imp(aOrd,lEnd,WnRel,cString,tamanho,titulo)

LOCAL cRodaTxt:= STR0022 //"PRODUTO(S)"
LOCAL nCntImpr:= 0
LOCAL nSaldoPro,nEmpPro,nSCPro,nPCPro,nOPPro,nPVPro
LOCAL nSaldoSub,nEmpSub,nSCSub,nPCSub,nOPSub,nPVSub
LOCAL nSaldoTot,nEmpTot,nSCTot,nPCTot,nOPTot,nPVTot
LOCAL lPAssou1,lPassou2,nFirst := 0,dUsai,nSaldo, cLocProc := GETMV("MV_LOCPROC")
LOCAL cArqTmp,cFiltro
Local cChave := ""

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
LOCAL nAux1
LOCAL nI
LOCAL nLenc
Local nIndr
Local lT

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li:= 80 ,m_pag := 1

//��������������������������������������������������������������Ŀ
//� Variaveis privadas exclusivas deste programa                 �
//����������������������������������������������������������������
PRIVATE cCondicao ,lContinua ,cVar ,cCondSec

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

//������������������������������������������������������������Ŀ
//� Adiciona a ordem escolhida ao titulo do relatorio          �
//��������������������������������������������������������������
If Type("NewHead")#"U"
	NewHead += " ("+AllTrim(aOrd[aReturn[8]])+")"
Else
	Titulo  += " ("+AllTrim(aOrd[aReturn[8]])+")"
EndIf

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������
cabec1 := STR0011		//"CODIGO          DESCRICAO                      TP GRUP UM    SALDO ATUAL   EMPENHO PARA           SC's PC's/CONTRATOS           OP's           PV's     PONTO DE         LOTE   PRAZO  ESTOQUE       CONSUMO   ULTIMA   CL  "
cabec2 := STR0012		//"                                                                         REQ/PV/RESERVA      COLOCADAS      COLOCADOS      COLOCADAS      COLOCADOS       PEDIDO    ECONOMICO ENTREGA EM MESES         MEDIO    SAIDA       "
/////                   123456789012345 123456789012345678901234567890 12 1234 12 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 999,999,999.99 9,999,999.99 9,999,999.99 99999 D    99999 99,999,999.99 99/99/9999 A
/////                   0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
/////                   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
cArqTmp	:= ""

If lVEIC
	cabec1:= substr(cabec1 ,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(cabec1 ,aSB1Cod[1]+1)
	cabec2:= substr(cabec2 ,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(cabec2 ,aSB1Cod[1]+1)
	
	// Para retirar a coluna referente a OP ( SC2 )
	nAux1	:= AT('CONTRA',UPPER(cabec1))
	nLenc	:= LEN(cabec1)
	IF nAux1 > 0
	   FOR nI := nAux1 TO nLenc
	      IF SUBStr(cabec1,nI, 1 ) == ' '
	         exit
	      endif
	   NEXT nI
		cabec1:= substr(cabec1 ,1, nI-1 ) + substr(cabec1 ,nI + 15)
		cabec2:= substr(cabec2 ,1, nI-1 ) + substr(cabec2 ,nI + 15)
	ENDIF
EndIf	

DbSelectArea("SB1")
SetRegua(LastRec())

Set Softseek On

if ! lVEIC
	Set Order To aReturn[8]
	If aReturn[8] == 4
		Seek xSB1 + mv_par05
		cCondicao := "lContinua .And. !Eof() .And. B1_GRUPO <= mv_par06"
	ElseIf aReturn[8] == 3
		Seek xSB1 + mv_par07
		cCondicao := "lContinua .And. !Eof() .And. B1_DESC <= mv_par08"
	ElseIf aReturn[8] == 2
		Seek xSB1 + mv_par03
		cCondicao := "lContinua .And. !Eof() .And. B1_TIPO <= mv_par04"
	Else
		Seek xSB1 + mv_par01
		cCondicao := "lContinua .And. !Eof() .And. B1_COD <= mv_par02"
	Endif
else
	Set Order To aReturn[8]
	If aReturn[8] == 4
		dbSetOrder( 7 ) // B1_FILIAL+B1_GRUPO+B1_CODITE
		Seek xSB1 + mv_par05
		cCondicao := "lContinua .And. !Eof() .And. B1_GRUPO <= mv_par06"
	ElseIf aReturn[8] == 3
		Seek xSB1 + mv_par07
		cCondicao := "lContinua .And. !Eof() .And. B1_DESC <= mv_par08"
	ElseIf aReturn[8] == 2 // por tipo
		cFiltro   :=      "B1_TIPO>='" + mv_par03 + "'" 
		cFiltro   += ".And.B1_TIPO<='" + mv_par04 + "'"
		cFiltro   += ".and.B1_FILIAL=='" + xSB1 + "'"
		cArqTmp   := CriaTrab('',.F.)
		IndRegua('SB1',cArqTmp,'B1_FILIAL+B1_TIPO+B1_CODITE',,cFiltro,STR0021)    //"Selecionando Registros"
		nIndr	:=	RetIndex("SB1")
		#IFNDEF TOP
			dbSetIndex(cArqTmp+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndr + 1)
		dbSeek(xSB1 + mv_par03, .T.)
		cCondicao := "lContinua .And. !Eof() .And. B1_TIPO <= mv_par04"
	Else
		cFiltro   :=      "B1_CODITE>='" + mv_par01 + "'"
		cFiltro   += ".And.B1_CODITE<='" + mv_par02 + "'"
		cFiltro   += ".and.B1_FILIAL=='" + xSB1 + "'"
		cArqTmp   := CriaTrab('',.F.)
		IndRegua('SB1',cArqTmp,'B1_FILIAL+B1_CODITE',,cFiltro,STR0021)    //"Selecionando Registros"
		nIndr	:=	RetIndex("SB1")
		#IFNDEF TOP
			dbSetIndex(cArqTmp+OrdBagExt())
		#ENDIF
		dbSetOrder(nIndr + 1)
		dbSeek(xSB1 + mv_par01, .T.)
		cCondicao := "lContinua .And. !Eof() .And. B1_CODITE <= mv_par02"
	Endif
endif
Set SoftSeek Off

//��������������������������������������������������������������Ŀ
//� Posiciona os indices dos arquivos consultados                �
//����������������������������������������������������������������
dbSelectArea("SC1")
dbSetOrder(2)

dbSelectArea("SC2")
dbSetOrder(2)

dbSelectArea("SC6")
dbSetOrder(2)

dbSelectArea("SC7")
dbSetOrder(2)

Store 0 To nSaldoTot,nEmpTot,nSCTot,nPCTot,nOPTot,nPVTot

lPassou1  := .F.
lContinua := .T.

If aReturn[8] == 5
	dbSelectArea("SB3")
	cCondicao := "lContinua .And. SB3->(!Eof())"
	cFiltro   :=      "B3_COD>='" + mv_par01 + "'"
	cFiltro   += ".And.B3_COD<='" + mv_par02 + "'"
	cFiltro   += ".and.B3_FILIAL=='" + xSB3 + "'"
	cArqTmp   := CriaTrab('',.F.)
	IndRegua('SB3',cArqTmp,'STR(B3_MEDIA)',,cFiltro,STR0021)    //"Selecionando Registros"
	nIndSb3:=RetIndex("SB3")
	#IFNDEF TOP
		dbSetIndex(cArqTmp+OrdBagExt())
	#ENDIF
	dbSetOrder(nIndSb3 + 1)
	dbGotop()
Else
	dbSelectArea("SB1")
	cCondicao += ".and.B1_FILIAL=='" + xSB1 + "'"
Endif

Do While &cCondicao
   cCondSec := "B1_FILIAL=='" + xSB1 + "' .And. "
	if ! lVEIC
		If aReturn[8] == 5
	  		dbSelectArea("SB1")
	  		dbSetOrder(1)
			dbSeek(xSB1 + SB3->B3_COD)
			cCondSec += "B1_COD == SB3->B3_COD"
		ElseIf aReturn[8] == 4
			cVar     := B1_GRUPO
			cCondSec += "B1_GRUPO == cVar"
		ElseIf aReturn[8] == 3
			cVar     := B1_DESC
			cCondSec += "B1_DESC == cVar"
		ElseIf aReturn[8] == 2
			cVar     := B1_TIPO
			cCondSec += "B1_TIPO == cVar"
		Else
			cVar     := B1_COD
			cCondSec += "B1_COD == cVar"
		Endif
	ELSE
		If aReturn[8] == 4
			cVar     := B1_GRUPO
			cCondSec += "B1_GRUPO == cVar"
		ElseIf aReturn[8] == 3
			cVar     := B1_DESC
			cCondSec += "B1_DESC == cVar"
		ElseIf aReturn[8] == 2
			cVar     := B1_TIPO
			cCondSec += "B1_TIPO == cVar"
		Else
			cVar     := B1_CODITE
			cCondSec += "B1_CODITE == cVar"
		Endif
	ENDIF

	Store 0 To nSaldoSub,nEmpSub,nSCSub,nPCSub,nOPSub,nPVSub
	lPassou2 := .F.

	DO While &cCondicao .And. &(cCondSec)
		
		If lEnd
			@ PROW()+1,001 PSay  STR0013		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf
		
		IncRegua()
		
		lT := .F.
		if ! lVEIC
			If B1_COD < mv_par01 .Or. B1_COD > mv_par02
	   		lT := .T.
         endif
      else
			if B1_CODITE < mv_par01 .Or. B1_CODITE > mv_par02
	   		lT := .T.
			endif
		EndIf
		if lT
			dbSkip()
			Loop
		EndIf
		
		If B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04
			dbSkip()
			Loop
		EndIf
		
		If B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
			dbSkip()
			Loop
		EndIf
		
		If B1_DESC < mv_par07 .Or. B1_DESC > mv_par08
			dbSkip()
			Loop
		EndIf
		
		Store 0 To nSaldoPro,nEmpPro,nSCPro,nPCPro,nOPPro,nPVPro
		
		//��������������������������������������������������������������Ŀ
		//� Soma os saldos iniciais e os empenhos do SB2                 �
		//����������������������������������������������������������������
		dbSelectArea("SB2")
		Seek xSB2 + SB1->B1_COD

		dUsai := B2_USAI

		While !Eof() .And. B2_FILIAL + B2_COD == xSB2 + SB1->B1_COD
			
			If lEnd
				@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
			
			IF B2_LOCAL == cLocProc .and. mv_par13 == 2
				dbSkip()
				Loop
			Endif

			If B2_LOCAL < mv_par17 .Or. B2_LOCAL > mv_par18
				dbSkip()
				Loop
			EndIf

			nSaldoPro+= B2_QATU
		   
			
			_cQuery:= "SELECT  SUM(D4_QUANT) QTEMP "
            _cQuery+= "FROM "+RetSqlName("SD4")+" SD4 "
            _cQuery+= "WHERE SD4.D4_FILIAL = '" + xFilial("SD4") + "' AND "
			_cQuery+= " SD4.D4_DATA >= '" + DTOS(MV_PAR21) + "' AND "
			_cQuery+= " SD4.D4_DATA <= '" + DTOS(MV_PAR22) + "' AND "
			_cQuery+= " SD4.D4_COD   = '" + SB2->B2_COD    + "' AND "
		   	_cQuery+= " SD4.D4_LOCAL = '" + SB2->B2_LOCAL  + "' AND "
			_cQuery+= " SD4.D4_QUANT <> 0  AND "
			_cQuery+= "SD4.D_E_L_E_T_ <> '*'  "  
			
            If Select("QUERY") > 0
	          DbCloseArea()
            EndIf

            TCQUERY _cQuery NEW ALIAS "QUERY"
			
			nEmpPro+= QUERY->QTEMP
			nEmpPro+= If(mv_par20==1,B2_QEMPPRJ,0)
			
		
			_cQuery1:= "SELECT  SUM(C9_QTDLIB) QTRESER "
            _cQuery1+= "FROM " + RetSqlName("SC9") + " SC9 "
            _cQuery1+= "WHERE SC9.C9_FILIAL = '" + xFilial("SC9") + "' AND "
			_cQuery1+= " SC9.C9_DATALIB >= '" + DTOS(MV_PAR21) + "' AND "
			_cQuery1+= " SC9.C9_DATALIB <= '" + DTOS(MV_PAR22) + "' AND "
			_cQuery1+= " SC9.C9_PRODUTO  = '" + SB2->B2_COD    + "' AND "
		   	_cQuery1+= " SC9.C9_LOCAL    = '" + SB2->B2_LOCAL  + "' AND "
			_cQuery1+= " SC9.C9_LOTECTL <> ''  AND "
			_cQuery1+= " SC9.C9_BLEST = ''     AND "
			_cQuery1+= " SC9.C9_NFISCAL = ''   AND "
			_cQuery1+= " SC9.D_E_L_E_T_ <> '*'     "  
			
            If Select("QUERY1") > 0
	          DbCloseArea()
            EndIf

            TCQUERY _cQuery1 NEW ALIAS "QUERY1"
			
			
			//nEmpPro+= B2_RESERVA+B2_QEMPSA
		    nEmpPro+= QUERY1->QTRESER
			
		    DBSELECTAREA("SB2")
			
			If dUsai < B2_USAI
				dUsai := B2_USAI
			EndIf
			
			dbSkip()
			
			QUERY1->(DBCLOSEAREA())
			QUERY-> (DBCLOSEAREA())
			
		EndDo
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se deve subtrair empenho do saldo atual             �
		//����������������������������������������������������������������
		If mv_par10 == 1
			nSaldoPro-= nEmpPro
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se deve listar apenas os obsoletos                  �
		//����������������������������������������������������������������
		If mv_par11 == 1 .And. ( Empty(dUsai) .Or. dUsai > mv_par12 )
			DbSelectArea("SB1")
			DbSkip()
			Loop
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o relatorio foi interrompido pelo usuario        �
		//����������������������������������������������������������������
		If !lContinua
			Exit
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Posiciona-se no arquivo de Demandas para pegar dados         �
		//����������������������������������������������������������������
		If aReturn[8] # 5
			DbSelectArea("SB3")
			DbSeek(xSB3 + SB1->B1_COD)
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Aglutina as Solicitacos de Compra sem pedido colocado        �
		//����������������������������������������������������������������
		DbSelectArea("SC1")
		
		Seek xSC1 + SB1->B1_COD
		
		While !Eof() .And. C1_FILIAL + C1_PRODUTO == xSC1 + SB1->B1_COD
			
			If lEnd
				@ PROW() + 1, 001 PSay STR0013		//"CANCELADO PELO OPERADOR"
				lContinua:= .F.
				Exit
			EndIf
			
			If C1_LOCAL < mv_par17 .Or. C1_LOCAL > mv_par18
				DbSkip()
				Loop
			EndIf

			IF C1_DATPRF < MV_PAR21 .OR. C1_DATPRF > MV_PAR22
				DbSkip()
				Loop
			EndIf
			
			If C1_QUJE < C1_QUANT .And. MtrAvalOp(mv_par16,"SC1")
				nSCPro+= (C1_QUANT - C1_QUJE)
			EndIf
			
			DbSkip()
		
		EndDo
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o relatorio foi interrompido pelo usuario        �
		//����������������������������������������������������������������
		If !lContinua
			Exit
		EndIf
		
		If !lVEIC
		
			//��������������������������������������������������������������Ŀ
			//� Aglutina as Ordens de Producao em aberto                     �
			//����������������������������������������������������������������
			DbSelectArea("SC2")
			DbSeek(xSC2 + SB1->B1_COD)
			
		//	While !Eof() .And. C2_FILIAL + C2_PRODUTO == xSC2 + SB1->B1_COD            
			While !Eof() .And. '04' + C2_PRODUTO == xSC2 + SB1->B1_COD
				
				If lEnd
					@ PROW()+1,001 PSay STR0013		//"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf
				
				If C2_LOCAL < mv_par17 .Or. C2_LOCAL > mv_par18
					DbSkip()
					Loop
				EndIf
	
				IF C2_EMISSAO < MV_PAR21 .OR. C2_EMISSAO > MV_PAR22
					DbSkip()
					Loop
				EndIf
				
				If Empty(C2_DATRF) .And. (aSC2Sld()) > 0 .And. MtrAvalOp(mv_par16)
					nOPPro += (aSC2Sld())
				EndIf
				
				DbSkip()
				
			EndDo
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o relatorio foi interrompido pelo usuario        �
		//����������������������������������������������������������������
		If !lContinua
			Exit
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Aglutina os Pedidos de Vendas ainda nao entregues            �
		//����������������������������������������������������������������
		DbSelectArea("SC6")
		
		Seek xSC6 + SB1->B1_COD
		
		While !Eof() .And. C6_FILIAL + C6_PRODUTO == xSC6 + SB1->B1_COD
			
			If lEnd
				@ PROW() + 1, 001 PSay STR0013	//"CANCELADO PELO OPERADOR"
				lContinua:= .F.
				Exit
			EndIf
			
			If C6_LOCAL < mv_par17 .Or. C6_LOCAL > mv_par18
				DbSkip()
				Loop
			EndIf
            
            /*
            IF SC5->(DBSEEK(XFILIAL("SC5")+SC6->C6_NUM))
                If SC5->C5_EMISSAO < mv_par21 .Or. SC5->C5_EMISSAO > mv_par22
				   DbSkip()
				   Loop
			    EndIf
            ENDIF
            */
            
            If SC6->C6_ENTREG < mv_par21 .Or. SC6->C6_ENTREG > mv_par22 .Or. !Empty(SC6->C6_NOTA)  //linha substituida por Thiago em 12/12/09
			   DbSkip()
			   Loop
			EndIf
			
			If mv_par14 == 1
				DbSelectArea("SF4")
				DbSetOrder(1)
				
				DbSeek(xSF4 + SC6->C6_TES)

				DbSelectArea("SC6")

				If SF4->F4_ESTOQUE <> "S"
					DbSkip()
					Loop
				End
			End
			
			//��������������������������������������������������������������Ŀ
			//� Verifica se devera considerar ou nao os Residuos             �
			//����������������������������������������������������������������
			If mv_par19 == 2 .And. AllTrim(C6_BLQ) == "R"
				dbSkip()
				Loop
			EndIf
			
			nPVPro+= SC6->C6_QTDVEN
			
			DbSelectArea("SC9")
			DbSetOrder(1)
			
			cChave:= xSC9 + SC6->C6_NUM + SC6->C6_ITEM
			
			If DbSeek(cChave)
				While !SC9->(EOF()) .And. cChave = SC9->C9_FILIAL + SC9->C9_PEDIDO + SC9->C9_ITEM
					If C9_LOCAL < mv_par17 .Or. C9_LOCAL > mv_par18
						DbSkip()
						Loop
					EndIf
					
					If (Empty(SC9->C9_BLEST) .And. Empty(SC9->C9_BLCRED)) .And.SC9->C9_PRODUTO == SC6->C6_PRODUTO
						nPvPro -= SC9->C9_QTDLIB
					ElseIf SC9->C9_BLEST == "10" .AND. SC9->C9_PRODUTO == SC6->C6_PRODUTO
						nPvPro -= SC9->C9_QTDLIB
					EndIf
					
					Dbskip()
				End
			Endif
			
			nPVPro:= Max(0,nPVPro)

			DbSelectArea("SC6")
			DbSkip()
			
		EndDo
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o relatorio foi interrompido pelo usuario        �
		//����������������������������������������������������������������
		If !lContinua
			Exit
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Aglutina os Pedidos de Compra ainda nao entregues            �
		//����������������������������������������������������������������
		DbSelectArea("SC7")
		
		Seek xSC7 + SB1->B1_COD
		
		While !Eof() .And. C7_FILIAL + C7_PRODUTO == xSC7 + SB1->B1_COD
			
			If lEnd
				@ PROW() + 1, 001 PSay STR0013		//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
			
			If C7_LOCAL < mv_par17 .Or. C7_LOCAL > mv_par18
				DbSkip()
				Loop
			EndIf
           
            // If C7_DATPRF < (mv_par21) .Or. C7_DATPRF > (mv_par22)
		    //	DbSkip()
		    //	Loop
		    // EndIf

			If (C7_QUANT-C7_QUJE) > 0 .And. Empty(C7_RESIDUO) .And. MtrAvalOp(mv_par16,"SC7")
				nPCPro+= (C7_QUANT-C7_QUJE)
			EndIf
			
			DbSkip()
			
		EndDo
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o relatorio foi interrompido pelo usuario        �
		//����������������������������������������������������������������
		If !lContinua
			Exit
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Verifica deve listar apenas os itens a comprar               �
		//����������������������������������������������������������������
		If mv_par09 == 2
			
			nSaldo:= ( nSaldoPro + nSCPro + nPCPro+nOPPro ) - nPVPro
			
			If SM0->M0_CODFIL == '04'
			    If nSaldo > RetFldProd( SB1->B1_COD, "B1_EMIN") .Or. ( RetFldProd( SB1->B1_COD, "B1_EMIN" ) == 0 .And. nSaldo == 0 )
				   DbSelectArea("SB1")
				   DbSkip()
				   Loop
			    EndIf
		    Else
		        DbSelectArea("SBZ")
		        DbSeek(XFILIAL("SBZ") + SB1->B1_COD)
		        
		        If nSaldo > SBZ->BZ_EMIN .Or. ( SBZ->BZ_EMIN == 0 .And. nSaldo == 0 )
		           DbSelectArea("SB1")
				   DbSkip()
				   Loop
			    EndIf
		     EndIf 
		     
		EndIf
		
		//��������������������������������������������������������������Ŀ
		//� Verifica deve listar saldo de produto zerado                 �
		//����������������������������������������������������������������
		If mv_par15 == 2
			If nSaldoPro == 0
				DbSelectArea("SB1")
				DbSkip()
				Loop
			Endif
		Endif                                                                        
		
		lPassou1:= .T.
		lPassou2:= .T.
		
		If li > 58
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf
		
		//�������������������������������������������������������Ŀ
		//� Adiciona 1 ao contador de registros impressos         �
		//���������������������������������������������������������
		nCntImpr++
		
		DbSelectArea("SB1")
		
		If !lVEIC
			@ li,000 PSay B1_COD
		Else 
			@ li,000 PSay B1_CODITE
		EndIf
		
		@ li,016 + nCOL1 PSay Substr(B1_DESC,1,30)
		@ li,048 + nCOL1 PSay B1_TIPO
		@ li,051 + nCOL1 PSay B1_GRUPO
		@ li,056 + nCOL1 PSay B1_UM
	    @ li,059 + nCOL1 PSay nSaldoPro Picture PesqPictQt("B2_QATU"  ,14)
		@ li,074 + nCOL1 PSay nEmpPro   Picture PesqPictQt("B2_QEMP"  ,14)
		@ li,091 + nCOL1 PSay nSCPro    Picture PesqPictQt("C1_QUANT" ,14)
		@ li,106 + nCOL1 PSay nPCPro    Picture PesqPictQt("C7_QUANT" ,14)

		If !lVEIC
			@ li,121 + nCOL1 PSay nOPPro Picture PesqPictQt("C2_QUANT" ,14)
		EndIf
			
		@ li,136 + nCOL1 + nCOL2 PSay nPVPro Picture PesqPictQt("C6_QTDVEN",14)
	    
	    If SM0->M0_CODFIL == '04'
		   @ li,151 + nCOL1 + nCOL2 PSay RetFldProd(SB1->B1_COD,"B1_EMIN")   Picture PesqPictQt("B1_EMIN"  ,12)
		Else
		   SBZ->(dbseek(XFILIAL("SBZ")+SB1->B1_COD))
		   @ li,151 + nCOL1 + nCOL2 PSay SBZ->BZ_EMIN  Picture PesqPictQt("BZ_EMIN",12)
		EndIf
		
		@ li,164 + nCOL1 + nCOL2 PSay RetFldProd(SB1->B1_COD,"B1_LE") Picture PesqPictQt("B1_LE"    ,12)
		@ li,177 + nCOL1 + nCOL2 PSay CalcPrazo(B1_COD,RetFldProd(SB1->B1_COD,"B1_LE")) Picture "99999"
		@ li,184 + nCOL1 + nCOL2 PSay RetFldProd(SB1->B1_COD,"B1_TIPE")

		If SB3->B3_MEDIA != 0
			@ li,186 + nCOL1 + nCOL2 PSay nSaldoPro/SB3->B3_MEDIA Picture "99999"
		Else
			@ li,186 + nCOL1 + nCOL2 PSay STR0032 //"  N/D"
		EndIf

		@ li,192 + nCOL1 + nCOL2 PSay SB3->B3_MEDIA Picture PesqPictQt("B3_MEDIA",13)
		@ li,206 + nCOL1 + nCOL2 PSay dUsai
		@ li,216 + nCOL1 + nCOL2 PSay SB3->B3_CLASSE
		
		//��������������������������������������������������������������Ŀ
		//� Soma o Total do Produto ao total da quebra                   �
		//����������������������������������������������������������������
		nSaldoSub += nSaldoPro
		nEmpSub   += nEmpPro
		nSCSub    += nSCPro
		nPCSub    += nPCPro
		nOPSub    += nOPPro
		nPVSub    += nPVPro
		
		DbSelectArea("SB1")
		DbSkip()
		
		li++
		
	EndDo
	
	If (aReturn[8] == 2 .Or. aReturn[8] == 4) .And. lPassou2
		If aReturn[8] == 2
			@ li,024 + nCOL1 PSay STR0014+cVar		//"T o t a l  d o   T i p o : "
		ElseIf aReturn[8] == 4
			@ li,023 + nCOL1 PSay STR0015+cVar		//"T o t a l   d o   G r u p o : "
		EndIf
		@ li,059 + nCOL1 PSay nSaldoSub Picture PesqPictQt("B2_QATU"  ,14)
		@ li,074 + nCOL1 PSay nEmpSub   Picture PesqPictQt("B2_QEMP"  ,14)
		@ li,091 + nCOL1 PSay nSCSub    Picture PesqPictQt("C1_QUANT" ,14)
		@ li,106 + nCOL1 PSay nPCSub    Picture PesqPictQt("C7_QUANT" ,14)
		if ! lVEIC
			@ li,121 + nCOL1 PSay nOPSub Picture PesqPictQt("C2_QUANT" ,14)
		ENDIF
		@ li,136 + nCOL1 + nCOL2 PSay nPVSub Picture PesqPictQt("C6_QTDVEN",14)

		li++

		@ li, 000 PSay __PrtThinLine()

		li++
	EndIf
	
	//��������������������������������������������������������������Ŀ
	//� Soma o Total do Produto ao total da quebra                   �
	//����������������������������������������������������������������
	nSaldoTot += nSaldoSub
	nEmpTot   += nEmpSub
	nSCTot    += nSCSub
	nPCTot    += nPCSub
	nOPTot    += nOPSub
	nPVTot    += nPVSub
	
	If aReturn[8] == 5
		DbSelectArea("SB3")
		DbSkip()
	Else
		DbSelectArea("SB1")
	EndIf
	
EndDo

If lPassou1
	If 	li > 56
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf

	li++

	@ li,024 + nCOL1 PSay STR0016		//"T o t a l   G e r a l :"
	@ li,059 + nCOL1 PSay nSaldoTot Picture PesqPictQt("B2_QATU"  ,14)
	@ li,074 + nCOL1 PSay nEmpTot   Picture PesqPictQt("B2_QEMP"  ,14)
	@ li,091 + nCOL1 PSay nSCTot    Picture PesqPictQt("C1_QUANT" ,14)
	@ li,106 + nCOL1 PSay nPCTot    Picture PesqPictQt("C7_QUANT" ,14)

	if ! lVEIC
		@ li,121 + nCOL1 PSay nOPTot Picture PesqPictQt("C2_QUANT" ,14)
	endif	

	@ li,136 + nCOL1 + nCOL2 PSay nPVTot Picture PesqPictQt("C6_QTDVEN",14)
EndIf

DbSelectArea("SC1")
DbSetOrder(1)

DbSelectArea("SC2")
DbSetOrder(1)

DbSelectArea("SC6")
DbSetOrder(1)

DbSelectArea("SC7")
DbSetOrder(1)

If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
DbSelectArea(cString)
Set Filter To

//��������������������������������������������������������������Ŀ
//� Apaga Arquivos Temporarios especifico p/Gestao Concessionaria�
//����������������������������������������������������������������
If lVEIC
	If !Empty(cArqTmp)
		RetIndex("SB1")
		Dbsetorder(1)
		
		If File( cArqTmp + OrdBagExt() )
			fErase( cArqTmp + OrdBagExt())
		EndIf
		
		cArqTmp := ""		
	EndIf
EndIf	

Set Order To 1

If aReturn[5] = 1
	dbCommitAll()
	OurSpool(wnrel)
Endif

//��������������������������������������������������������������Ŀ
//� Apaga Arquivos Temporarios                                   �
//����������������������������������������������������������������
If aReturn[8] == 5
	DbSelectArea("SB3")
	Ferase(cArqTmp+OrdBagExt())
	DbSetOrder(1)
EndIf

MS_FLUSH()

return    
/*           
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � AjustaSX1 � Autor � Ricardo Berti      � Data � 18/07/2006 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Ajustar o SX1 para SIGAVEI, SIGAPEC e SIGAOFI  	          ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � AjustaSX1(ExpC1,ExpL1,ExpA1,ExpA2)  	                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = Grupo do pergunte 		                          ���
���          � ExpL1 = Se .T. = gestao de Concessionarias(MV_VEICULO ="S")���
���          � ExpA1 = Array com TAMSX3 do B1_COD		                  ���
���          � ExpA2 = Array com TAMSX3 do B1_CODITE		              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � RESTR11                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
*/
Static Function AjustaSX1(cPerg,lVeic,aSB1Cod,aSB1Ite)

Local aArea1 := Getarea() 
Local nTamSX1:= Len(SX1->X1_GRUPO)

DbSelectArea("SX1")
DbSetOrder(1)

DbSeek(cPerg)

If lVEIC
   DbSeek(cPerg)
   
   While SX1->X1_GRUPO == cPerg .AND. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .AND. Upper(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Ite[1] .OR. Upper(SX1->X1_F3) <> "VR4")

         RecLock("SX1",.F.)
	         SX1->X1_TAMANHO := aSB1Ite[1]
	         SX1->X1_F3 := "VR4"
    	     DbCommit()
         MsUnlock()
         
      EndIf
      DbSkip()
   EndDo
Else
    While SX1->X1_GRUPO == cPerg .AND. !SX1->(Eof())
      If "PRODU" $ Upper(SX1->X1_PERGUNT) .AND. Upper(SX1->X1_TIPO) == "C" .AND. ;
      (SX1->X1_TAMANHO <> aSB1Cod[1] .OR. Upper(SX1->X1_F3) <> "SB1")

         RecLock("SX1",.F.)
	         SX1->X1_TAMANHO := aSB1Cod[1]
	         SX1->X1_F3 := "SB1"
    	     DbCommit()
         MsUnlock()
         
      EndIf
      DbSkip()
   EndDo
EndIf

RESTAREA(aArea1)

Return