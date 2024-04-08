#INCLUDE "matr920.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR920  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Listagem das Entradas/Saidas para transcricao manual       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFISR004
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnRel:="MATR920"
Titulo:=STR0001 //"Listagem para escrituracao manual"
cDesc1:=STR0002 //"Emiss„o de listagem de movimenta‡oes de notas fiscais de entradas e"
cDesc2:=STR0003 //"sa¡das para transcricao em livros fiscais de escrituracao manual."
cDesc3:=STR0004 //"Ir  imprimir os lancamentos fiscais conforme os parƒmetros informados."
aReturn:= { STR0005, 1,STR0006, 2, 2, 1, "",1 } //"Zebrado"###"Administra‡„o"
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no cabecalho     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMeses	:={STR0007,STR0008,STR0009,STR0010,STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018} //"JANEIRO"###"FEVEREIRO"###"MARCO"###"ABRIL"###"MAIO"###"JUNHO"###"JULHO"###"AGOSTO"###"SETEMBRO"###"OUTUBRO"###"NOVEMBRO"###"DEZEMBRO"
cNomEmp	:= Trim(SM0->M0_NOMECOM)
cNomFil :=Trim(SM0->M0_FILIAL)

AjustaSx1()
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa relatorio                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|lEnd| R920Imp(@lEnd,wnRel,cString,Tamanho)},titulo)

If aReturn[5]==1
	Set Printer To
	ourspool(wnrel)
Endif
MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R920Imp  ³ Autor ³ Juan Jose Pereira     ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime Relatorio                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION R920Imp(lEnd,wnRel,cString,Tamanho)
LOCAL 	lMatr921:=(existblock("U_BFISR005"))
Local	cIndxSF3	:=""
Local	cChave		:=""
Local	aRegSF3     :={}   

Private cArqSF3		:=""
PRIVATE lAbortPrint:=.F.
PRIVATE cTitLivro:=NIL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe valores dos Parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe parametros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Limite da pagina em linhas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nLimPag:=64,nLinNec:=0
PRIVATE lAglutina:=.F.
PRIVATE lNFInutil:= (mv_par17==1)
PRIVATE lEmiteCiap :=.T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena maior tamanho das notas (em linhas)³
//³ [1]=Maior Nota da Pagina                    ³
//³ [2]=Maior Totalizacao de Transporte         ³
//³ [3]=Maior Totalizacao do Dia                ³
//³ [4]=Maior Totalizacao de Periodo ICM        ³
//³ [5]=Maior Totalizacao de Periodo IPI        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE nTamNota	:=0,;
nTamTransp	:=0,;
nTamPerICM	:=0,;
nTamPerIPI	:=0,;
aTamNotas	:={0,0,0,0,0}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Totalizadores ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE	aTotDia:=NIL,;		// Totalizador diario
aTotPerICM:=NIL,;	// Totalizador de periodos de apuracao de ICMS
aTotPerIPI:=NIL,;	// Totalizador de periodos de apuracao de IPI
aTransp:=NIL,;		// Totalizador de transporte de pagina
aTotMes:=NIL,;		// Totalizador Mensal
aResumo:=NIL,;		// Totalizador para resumo final
aResCFO:=NIL		// Totalizador para resumo por CFO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo Temporario para Controle de Contribuintes e Nao Contribuintes ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³Microsiga              ³ Data ³ 09/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Acerta o arquivo de perguntas                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSx1()
Local aArea		:= GetArea()
Local aHelpP	:= {}
Local aHelpS	:= {}
Local aHelpE	:= {}

//ÚÄÄÄÄÄÄÄÄÄ¿
//³Portugues³
//ÀÄÄÄÄÄÄÄÄÄÙ
Aadd( aHelpP, "Na obrigação da escrituracão do livro ")
Aadd( aHelpP, "de acordo com o Mapa Resumo.  ")
Aadd( aHelpP, "Somente tem validade esta pergunta, se  ")
Aadd( aHelpP, "o parâmetro MV_LJLVFIS for igual a 2. ")

//ÚÄÄÄÄÄÄÄÄ¿
//³Espanhol³
//ÀÄÄÄÄÄÄÄÄÙ
Aadd( aHelpS, "En la obrigación de la escrituración del libro ")
Aadd( aHelpS, "de acuerdo con el Mapa Resumo.  ") 
Aadd( aHelpS, "Solamente tienda validad la pregunta,  ") 
Aadd( aHelpS, "con el parametro MV_LJLVFIS iqual a 2. ") 

//ÚÄÄÄÄÄÄ¿
//³Ingles³
//ÀÄÄÄÄÄÄÙ
Aadd( aHelpE, "In the obligation of the bookkeeping of the book ") 
Aadd( aHelpE, "in accordance with the Map Summary. ") 
Aadd( aHelpE, "This question only has validity, if ") 
Aadd( aHelpE, "equal parameter MV_LJLVFIS the 2. ") 

PutSx1("MTR920","14","Imprime Mapa Resumo ?","Emite Mapa Resumo ?","Printed Map Summary ?","mv_che","N",01,0,2,"C","MatxRValPer(mv_par14)","","","","mv_par14","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpE,aHelpS)

aHelpP 	:= {}
aHelpE 	:= {}
aHelpS	:= {}

//ÚÄÄÄÄÄÄÄÄÄ¿
//³Portugues³
//ÀÄÄÄÄÄÄÄÄÄÙ
Aadd( aHelpP, "Escolha 'Sim' para a impressão de NFs de")
Aadd( aHelpP, "Entrada, quando o movimento for de Saí- ")
Aadd( aHelpP, "das, ou escolha 'Não' caso contrário.   ")
                                                              
//ÚÄÄÄÄÄÄÄÄ¿
//³Espanhol³
//ÀÄÄÄÄÄÄÄÄÙ
Aadd( aHelpS, "Elija la opcion 'Si' para la impresion  ")
Aadd( aHelpS, "de las fac. de entrada, cuando el mov.  ") 
Aadd( aHelpS, "sea de salidas, o en caso contrario,    ") 
Aadd( aHelpS, "elija 'No'.                             ") 

//ÚÄÄÄÄÄÄ¿
//³Ingles³
//ÀÄÄÄÄÄÄÙ
Aadd( aHelpE, "Choose 'Yes' to print the inflow invoices")
Aadd( aHelpE, "when the moviment is an outflow one. On ") 
Aadd( aHelpE, "the contrary, choose 'No'.              ") 

PutSx1("MTR920","15","Impr. NF de Entrada ?","Impr. Fac.de Entrada ?","Print inflow invoice ?","mv_chf","N",01,0,2,"C","","","","","mv_par15","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpE,aHelpS)

//ÚÄÄÄÄÄÄÄÄÄ¿
//³Portugues³
//ÀÄÄÄÄÄÄÄÄÄÙ
aHelpP 	:= {}
Aadd( aHelpP, "Indica se o relatorio deve listar ")
Aadd( aHelpP, "operações com isenção de ICMS  ")

PutSx1("MTR920","16","Impr. Operações isentas ?","Impr. Operações isentas ?","Impr. Operações isentas ?","mv_chg","N",01,0,2,"C","","","","","mv_par16","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpP,aHelpP,aHelpP)

//Impr. NF Inutil.
aHelpPor	:=	{}
aHelpEng	:=	{}
aHelpSpa	:=	{}	

Aadd(aHelpPor,"Conforme indicado pelo RICMS de seu     ")
Aadd(aHelpPor,"estado, informe se as notas fiscais     ")
Aadd(aHelpPor,"inutilizadas deverao ser impressas.     ")

aHelpSpa := aHelpEng := aHelpPor
PutSx1("MTR920","17","Impr. NF Inutil. ?","Impr. NF Inutil. ?","Impr. NF Inutil. ?","mv_chh","N",1,0,0,"C","","","","","mv_par17","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

If SX1->(dbSeek (Padr("MTR920",Len(SX1->X1_GRUPO)) + '03')) .And. SX1->X1_DEF02 $ Padr("SaÝdas",Len(SX1->X1_DEF02))
	RecLock('SX1',.F.)
	SX1->X1_DEF02	:=	"Saídas"
	MsUnLock()
Endif

RestArea(aArea)
Return
