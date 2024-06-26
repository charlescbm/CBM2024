#INCLUDE "matr920.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR920  � Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Listagem das Entradas/Saidas para transcricao manual       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BFISR004
//������������������Ŀ
//� Define Variaveis �
//��������������������
wnRel:="MATR920"
Titulo:=STR0001 //"Listagem para escrituracao manual"
cDesc1:=STR0002 //"Emiss�o de listagem de movimenta�oes de notas fiscais de entradas e"
cDesc2:=STR0003 //"sa�das para transcricao em livros fiscais de escrituracao manual."
cDesc3:=STR0004 //"Ir� imprimir os lancamentos fiscais conforme os par�metros informados."
aReturn:= { STR0005, 1,STR0006, 2, 2, 1, "",1 } //"Zebrado"###"Administra��o"
nomeprog:="MATR920"
cPerg:= "MTR920"
cString:="SF3"
nPagina:=0
nLin:=80
nLargMax:=220
Tamanho:="G"
cArqTemp:=""
aSvArea:={Alias(),IndexOrd(),Recno()}
nPosObs:=0
lConsUF:=.F. 

//���������������������������������������Ŀ
//� Variaveis utilizadas no cabecalho     �
//�����������������������������������������
aMeses	:={STR0007,STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018} //"JANEIRO"###"FEVEREIRO"###"MARCO"###"ABRIL"###"MAIO"###"JUNHO"###"JULHO"###"AGOSTO"###"SETEMBRO"###"OUTUBRO"###"NOVEMBRO"###"DEZEMBRO"
cNomEmp	:= Trim(SM0->M0_NOMECOM)
cNomFil :=Trim(SM0->M0_FILIAL)

AjustaSx1()
Pergunte(cPerg,.F.)

//���������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT �
//�����������������������������������������
nLastKey:=0
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho,,.T.)
If nLastKey==27
	dbClearFilter()
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey==27
	dbClearFilter()
	Return
Endif
//��������������������������������������������������������������Ŀ
//� Executa relatorio                                            �
//����������������������������������������������������������������
RptStatus({|lEnd| R920Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

If aReturn[5]==1
	Set Printer To
	ourspool(wnrel)
Endif
MS_FLUSH()

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R920Imp  � Autor � Juan Jose Pereira     � Data � 18.12.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprime Relatorio                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC FUNCTION R920Imp(lEnd,wnRel,cString,Tamanho)
LOCAL 	lMatr921:=(existblock("U_BFISR005"))
Local	cIndxSF3	:=""
Local	cChave		:=""
Local	aRegSF3     :={}   

Private cArqSF3		:=""
PRIVATE lAbortPrint:=.F.
PRIVATE cTitLivro:=NIL
//�������������������������������Ŀ
//� Recebe valores dos Parametros �
//���������������������������������
PRIVATE dDtIni	:=mv_par01,;
dDtFim		:= mv_par02,;
nTipoMov	:= mv_par03,;
lLacuna 	:= (mv_par04==1 .Or. mv_par04==3),;
nApurICM	:= mv_par05,;
nApurIPI	:= mv_par06,;
cNrLivro	:= mv_par07,;
lServico	:= (mv_par08==1),;
lDesconto	:= (mv_par09==1),;
lImpZer		:= (mv_par10==1),;
nCodigo		:= mv_par11,;
lListaNFO 	:= (mv_par12==1),;
nModelo 	:= Iif (mv_par03==1, 1, 3),;
lEntrada 	:= (mv_par15==1)   

PRIVATE	nPagina:=1,cFilterUser:=aReturn[7]
//�������������������Ŀ
//� Recebe parametros �
//���������������������
PRIVATE cMV_ESTADO:=SuperGetMv("MV_ESTADO"),;
cContaContab:=NIL
mv_par27 :=2
If nTipoMov==1
	cContaContab:=Alltrim(SuperGetMV("MV_CTALFE"))	
	// Retira ref. ao Alias SF3 //
	cContaContab:=StrTran(cContaContab,"SF3->",)
Else
	cContaContab:=Alltrim(SuperGetMV("MV_CTALFS"))	
	// Retira ref. ao Alias SF3 //
	cContaContab:=StrTran(cContaContab,"SF3->",)
EndIf

//���������������������������Ŀ
//� Limite da pagina em linhas�
//�����������������������������
PRIVATE nLimPag:=64,nLinNec:=0
PRIVATE lAglutina:=.F.
PRIVATE lNFInutil:= (mv_par17==1)
PRIVATE lEmiteCiap :=.T.
//���������������������������������������������Ŀ
//� Armazena maior tamanho das notas (em linhas)�
//� [1]=Maior Nota da Pagina                    �
//� [2]=Maior Totalizacao de Transporte         �
//� [3]=Maior Totalizacao do Dia                �
//� [4]=Maior Totalizacao de Periodo ICM        �
//� [5]=Maior Totalizacao de Periodo IPI        �
//�����������������������������������������������
PRIVATE nTamNota	:=0,;
nTamTransp	:=0,;
nTamPerICM	:=0,;
nTamPerIPI	:=0,;
aTamNotas	:={0,0,0,0,0}
//����������������������Ŀ
//� Define Totalizadores �
//������������������������
PRIVATE	aTotDia:=NIL,;		// Totalizador diario
aTotPerICM:=NIL,;	// Totalizador de periodos de apuracao de ICMS
aTotPerIPI:=NIL,;	// Totalizador de periodos de apuracao de IPI
aTransp:=NIL,;		// Totalizador de transporte de pagina
aTotMes:=NIL,;		// Totalizador Mensal
aResumo:=NIL,;		// Totalizador para resumo final
aResCFO:=NIL		// Totalizador para resumo por CFO

//����������������������������������������������������������������������������Ŀ
//� Cria Arquivo Temporario para Controle de Contribuintes e Nao Contribuintes �
//������������������������������������������������������������������������������
AADD(aRegSF3,{"CHAVE"	,"C",100,0})
AADD(aRegSF3,{"CONTR"	,"C",01,0})
AADD(aRegSF3,{"FILIAL"	,"C",02,0})
AADD(aRegSF3,{"MES"		,"C",02,0})
AADD(aRegSF3,{"ANO"		,"C",02,0})
cArqSF3  :=CriaTrab(aRegSF3)
dbUseArea(.T.,,cArqSF3,cArqSF3,.T.,.F.)
cIndxSF3 :=Substr(CriaTrab(NIL,.F.),1,7)+"A"
cChave:="CONTR+CHAVE"
IndRegua(cArqSF3,cIndxSF3,cChave,,,"Criando Controles")

If lMatr921
	ExecBlock("U_BFISR005",.F.,.F.)
Else
	U_BFISR005()
Endif

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor �Microsiga              � Data � 09/05/08 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �Acerta o arquivo de perguntas                               ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function AjustaSx1()
Local aArea		:= GetArea()
Local aHelpP	:= {}
Local aHelpS	:= {}
Local aHelpE	:= {}

//���������Ŀ
//�Portugues�
//�����������
Aadd( aHelpP, "Na obriga��o da escriturac�o do livro ")
Aadd( aHelpP, "de acordo com o Mapa Resumo.  ")
Aadd( aHelpP, "Somente tem validade esta pergunta, se  ")
Aadd( aHelpP, "o par�metro MV_LJLVFIS for igual a 2. ")

//��������Ŀ
//�Espanhol�
//����������
Aadd( aHelpS, "En la obrigaci�n de la escrituraci�n del libro ")
Aadd( aHelpS, "de acuerdo con el Mapa Resumo.  ") 
Aadd( aHelpS, "Solamente tienda validad la pregunta,  ") 
Aadd( aHelpS, "con el parametro MV_LJLVFIS iqual a 2. ") 

//������Ŀ
//�Ingles�
//��������
Aadd( aHelpE, "In the obligation of the bookkeeping of the book ") 
Aadd( aHelpE, "in accordance with the Map Summary. ") 
Aadd( aHelpE, "This question only has validity, if ") 
Aadd( aHelpE, "equal parameter MV_LJLVFIS the 2. ") 

PutSx1("MTR920","14","Imprime Mapa Resumo ?","Emite Mapa Resumo ?","Printed Map Summary ?","mv_che","N",01,0,2,"C","MatxRValPer(mv_par14)","","","","mv_par14","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpE,aHelpS)

aHelpP 	:= {}
aHelpE 	:= {}
aHelpS	:= {}

//���������Ŀ
//�Portugues�
//�����������
Aadd( aHelpP, "Escolha 'Sim' para a impress�o de NFs de")
Aadd( aHelpP, "Entrada, quando o movimento for de Sa�- ")
Aadd( aHelpP, "das, ou escolha 'N�o' caso contr�rio.   ")
                                                              
//��������Ŀ
//�Espanhol�
//����������
Aadd( aHelpS, "Elija la opcion 'Si' para la impresion  ")
Aadd( aHelpS, "de las fac. de entrada, cuando el mov.  ") 
Aadd( aHelpS, "sea de salidas, o en caso contrario,    ") 
Aadd( aHelpS, "elija 'No'.                             ") 

//������Ŀ
//�Ingles�
//��������
Aadd( aHelpE, "Choose 'Yes' to print the inflow invoices")
Aadd( aHelpE, "when the moviment is an outflow one. On ") 
Aadd( aHelpE, "the contrary, choose 'No'.              ") 

PutSx1("MTR920","15","Impr. NF de Entrada ?","Impr. Fac.de Entrada ?","Print inflow invoice ?","mv_chf","N",01,0,2,"C","","","","","mv_par15","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpE,aHelpS)

//���������Ŀ
//�Portugues�
//�����������
aHelpP 	:= {}
Aadd( aHelpP, "Indica se o relatorio deve listar ")
Aadd( aHelpP, "opera��es com isen��o de ICMS  ")

PutSx1("MTR920","16","Impr. Opera��es isentas ?","Impr. Opera��es isentas ?","Impr. Opera��es isentas ?","mv_chg","N",01,0,2,"C","","","","","mv_par16","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpP,aHelpP)

//Impr. NF Inutil.
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}	

Aadd(aHelpPor,"Conforme indicado pelo RICMS de seu     ")
Aadd(aHelpPor,"estado, informe se as notas fiscais     ")
Aadd(aHelpPor,"inutilizadas deverao ser impressas.     ")

aHelpSpa := aHelpEng := aHelpPor
PutSx1("MTR920","17","Impr. NF Inutil. ?","Impr. NF Inutil. ?","Impr. NF Inutil. ?","mv_chh","N",1,0,0,"C","","","","","mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

If SX1->(dbSeek (Padr("MTR920",Len(SX1->X1_GRUPO)) + '03')) .And. SX1->X1_DEF02 $ Padr("Sa�das",Len(SX1->X1_DEF02))
	RecLock('SX1',.F.)
	SX1->X1_DEF02	:=	"Sa�das"
	MsUnLock()
Endif

RestArea(aArea)
Return
