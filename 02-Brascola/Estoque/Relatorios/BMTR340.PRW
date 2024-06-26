#INCLUDE "MATR340.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR340  � Autor � Marcos V. Ferreira    � Data � 25/05/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � VARIA��O MENSAL                                            ���
���Descri��o � ADAPTADO PARA O LUCAS POR ZANARDO						  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri��o � PLANO DE MELHORIA CONTINUA        �Programa    MATR340.PRX ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data       	|BOPS             ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �           	|                 ���
���      02  � Ricardo Berti            � 06/10/2006	| 00000109555     ���
���      03  �                          �           	|                 ���
���      04  � Ricardo Berti            � 06/10/2006	| 00000109555     ���
���      05  �                          �           	|                 ���
���      06  �                          �           	|                 ���
���      07  �                          �           	|                 ���
���      08  �                          �           	|                 ���
���      09  �                          �           	|                 ���
���      10  �                          �           	|                 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BMTR340()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= BReportDef()
	oReport:PrintDialog()
Else
	BMATR340R3()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Marcos V. Ferreira     � Data �25/05/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR225			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function BReportDef()
Local oReport
Local oConsumo
Local aOrdem  := {STR0005,STR0006,STR0007,STR0008} //##Por Codigo##Por Tipo##Por Descricao##Por Grupo

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR340",OemToAnsi(STR0001),"MTR340", {|oReport| BReportPrint(oReport)},OemToAnsi(STR0002)+" "+OemToAnsi(STR0003)+" "+OemToAnsi(STR0004)) //##"Este programa exibira' o consumo dos ultimos 12 meses de cada material"##"ou produto acabado. No caso dos produtos ele estara' listando o  total"##"das vendas."
oReport:SetLandscape()
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // codigo de                                    �
//� mv_par02	 // codigo ate                                   � 
//� mv_par03     // tipo de                                      �
//� mv_par04     // tipo ate                                     �
//� mv_par05     // grupo de                                     �
//� mv_par06     // grupo ate                                    �
//� mv_par07     // descricao de                                 �
//� mv_par08     // descricao ate                                �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//��������������������������������������������������������������������������

//��������������������������������������������������������������Ŀ
//� Sessao 1 (oConsumo)                                          �
//����������������������������������������������������������������
oConsumo := TRSection():New(oReport,STR0039,{"SB1","SB3"},aOrdem) //"Consumos/Vendas mes a mes de Materiais"##"Demandas"
oConsumo:SetTotalInLine(.F.)
oConsumo:SetTotalText(STR0028) //"Total geral"

TRCell():New(oConsumo,'B1_COD'		,'SB1',STR0031	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B1_TIPO'		,'SB1',STR0032	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B1_GRUPO'	,'SB1',STR0033	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B1_DESC'		,'SB1',STR0034	 ,/*Picture*/					,30			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B1_UM'		,'SB1',STR0035	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES01'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q01',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES02'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q02',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES03'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q03',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES04'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q04',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES05'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q05',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES06'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q06',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES07'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q07',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES08'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q08',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES09'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q09',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES10'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q10',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES11'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q11',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'MES12'		,'  ' ,/*Titulo*/,PesqPict('SB3','B3_Q12',11)	,11			,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B3_MEDIA'	,'SB3',STR0036	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B3_TOTAL'	,'SB3',STR0037	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oConsumo,'B3_CLASSE'	,'SB3',STR0038	 ,/*Picture*/					,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oConsumo:SetHeaderPage()

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint � Autor �Marcos V. Ferreira   � Data �25/05/06  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportPrint devera ser criada para todos  ���
���          �os relatorios que poderao ser agendados pelo usuario.       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR340			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function BReportPrint(oReport)
Local oConsumo  := oReport:Section(1)
Local aMeses	:= {STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021,STR0022}	//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"
Local aArea 	:= GetArea()
Local nMesAux	:= 0
Local nAno		:= 0
Local nMes		:= 0 
Local nX		:= 0
Local cPictQuant:= ''
Local cAliasSB1 := 'SB1'
Local nTotRegs  := 0
Local cFiltro   := ''
Local nOrdem    := oConsumo:GetOrder()
Local cParam    := ''
Local lQuery    := .F.
Local oBreak

//��������������������������������������������������������������Ŀ
//� Variaveis privadas exclusivas deste programa                 �
//����������������������������������������������������������������
Private cMes
Private lContinua := .T. 
Private cCondSec
Private cAnt   

//��������������������������������������������������������������Ŀ
//� Definicao da linha de SubTotal                               |
//����������������������������������������������������������������
If nOrdem == 2
	oBreak := TRBreak():New(oConsumo,oConsumo:Cell("B1_TIPO"),STR0029,.F.) //"SubTotal por Tipo:"
ElseIf nOrdem == 4
	oBreak := TRBreak():New(oConsumo,oConsumo:Cell("B1_GRUPO"),STR0030,.F.) //"SubTotal por Grupo:"
EndIf	

If nOrdem == 2 .Or. nOrdem == 4
	TRFunction():New(oConsumo:Cell("MES01"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES02"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES03"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES04"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES05"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES06"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES07"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES08"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES09"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES10"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)	
	TRFunction():New(oConsumo:Cell("MES11"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("MES12"		),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("B3_MEDIA"	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
	TRFunction():New(oConsumo:Cell("B3_TOTAL"	),NIL,"SUM",oBreak,/*Titulo*/,/*cPicture*/,/*uFormula*/,.T.,.F.)
EndIf

//��������������������������������������������������������������Ŀ
//� Definicao da linha de Total Geral                            |
//����������������������������������������������������������������
TRFunction():New(oConsumo:Cell("MES01"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES02"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES03"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES04"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES05"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES06"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES07"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES08"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES09"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES10"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)	
TRFunction():New(oConsumo:Cell("MES11"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("MES12"		),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("B3_MEDIA"	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)
TRFunction():New(oConsumo:Cell("B3_TOTAL"	),NIL,"SUM",/*oBreak*/,/*Titulo*/,/*cPicture*/,/*uFormula*/,IIf(nOrdem == 2 .Or. nOrdem == 4 ,.F.,.T.),.F.)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relatorio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP

	dbSelectArea("SB1")
	dbSetOrder(oConsumo:GetOrder())

	lQuery := .T.
 
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)

	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������

	oReport:Section(1):BeginQuery()	
	
	cAliasSB1 := GetNextAlias()
	
	BeginSql Alias cAliasSB1

	SELECT B1_FILIAL,B1_COD,B1_DESC,B1_TIPO,B1_GRUPO,B1_UM,B3_Q01,B3_Q02,B3_Q03,B3_Q04,
	       B3_Q05,B3_Q06,B3_Q07,B3_Q08,B3_Q09,B3_Q10,B3_Q11,B3_Q12,B3_MEDIA,B3_TOTAL,
	       B3_CLASSE
	
	FROM %table:SB1% SB1,%table:SB3% SB3
	
	WHERE B1_FILIAL = %xFilial:SB1%		AND 
	 	  B1_COD   >= %Exp:mv_par01%	AND 
	 	  B1_COD   <= %Exp:mv_par02%	AND 
	 	  B1_TIPO  >= %Exp:mv_par03%	AND 
	 	  B1_TIPO  <= %Exp:mv_par04%	AND 
	 	  B1_GRUPO >= %Exp:mv_par05%	AND 
	 	  B1_GRUPO <= %Exp:mv_par06%	AND 
		  B1_DESC  >= %Exp:mv_par07%	AND 	
		  B1_DESC  <= %Exp:mv_par08%	AND 	
		  B1_COD    = B3_COD			AND
		  B3_FILIAL = %xFilial:SB3%		AND 
 		  SB1.%NotDel% AND
 		  SB3.%NotDel%

	ORDER BY %Order:SB1% 
			
	EndSql 

	oReport:Section(1):EndQuery()
	
#ELSE

	dbSelectArea("SB1")
	dbSetOrder(oConsumo:GetOrder())

	cFiltro := "B1_COD   >= '" + mv_par01 + "' .And. B1_COD   <= '" + mv_par02 + "' .And. "
	cFiltro += "B1_TIPO  >= '" + mv_par03 + "' .And. B1_TIPO  <= '" + mv_par04 + "' .And. "
	cFiltro += "B1_GRUPO >= '" + mv_par05 + "' .And. B1_GRUPO <= '" + mv_par06 + "' .And. "
	cFiltro += "B1_DESC  >= '" + mv_par07 + "' .And. B1_DESC  <= '" + mv_par08 + "' "
	
	oReport:Section(1):SetFilter(cFiltro,IndexKey())

	TRPosition():New(oConsumo,"SB3",1,{|| xFilial("SB3") + (cAliasSB1)->B1_COD})

#ENDIF

//��������������������������������������������������������������Ŀ
//� Montagem dos dados do cabecalho do relatorio                 �
//����������������������������������������������������������������
nAno := Year(dDataBase)
If month(dDatabase) < 12
	nAno--
EndIf

nMes := Month(dDataBase)+1
If nMes = 13 
	nMes := 1
EndIf

cMes := StrZero(nMes,2)
For nX := 1 To 12
	If aMeses[nMes] == STR0011 .And. nX != 1	//"JAN"
		nAno++
	EndIf
	oConsumo:Cell('MES'+StrZero(nX,2)):SetTitle(Space(3)+aMeses[nMes]+"/"+StrZero(nAno,4))
	nMes++
	If nMes > 12
		nMes := 1
	EndIf
Next nX

oReport:SetMeter(SB1->(LastRec()))

oConsumo:Init()

Do While !oReport:Cancel() .And. (cAliasSB1)->(!Eof()) .And. (cAliasSB1)->B1_FILIAL == xFilial('SB1')

	oReport:IncMeter()

	If !lQuery
		dbSelectArea("SB3")
		If !MsSeek(xFilial("SB3")+SB1->B1_COD)
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf
	EndIf
	
	oConsumo:Cell("B1_COD"		):Show()
	oConsumo:Cell("B1_TIPO"		):Show()
	oConsumo:Cell("B1_GRUPO"	):Show()
	oConsumo:Cell("B1_DESC"		):Show()
	oConsumo:Cell("B1_UM"		):Show()

	nMesAux := nMes
	For nX := 1 To 12
		#IFDEF TOP
			cCampo := "B3_Q"+StrZero(nMesAux,2)
		#ELSE
			cCampo := "SB3->B3_Q"+StrZero(nMesAux,2)
		#ENDIF	
		oConsumo:Cell("MES"+StrZero(nX,2)):SetValue(&cCampo)
		nMesAux++
		If nMesAux > 12
			nMesAux := 1
		EndIf
		cMes := StrZero(nMesAux,2)
	Next nX
	oConsumo:Cell("B3_MEDIA"	):Show()
	oConsumo:Cell("B3_TOTAL"	):Show()
	oConsumo:Cell("B3_CLASSE"	):Show()

	oConsumo:PrintLine()

	dbSelectArea(cAliasSB1)
	dbSkip()

EndDo

oConsumo:Finish()
    
//-- Devolve a condicao original do arquivo principal
dbSelectArea('SB1')
dbSetOrder(1)
dbClearFilter()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR340R3� Autor � Wagner Xavier         � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Consumos mes a mes                                         ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
*/
STATIC Function BMATR340R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Consumos/Vendas mes a mes de Materiais"
LOCAL cDesc1   := STR0002	//"Este programa exibira' o consumo dos ultimos 12 meses de cada material"
LOCAL cDesc2   := STR0003	//"ou produto acabado. No caso dos produtos ele estara' listando o  total"
LOCAL cDesc3   := STR0004	//"das vendas."
LOCAL cString  := "SB1"
LOCAL aOrd     := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0007),OemToAnsi(STR0008)}	//" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "
LOCAL wnrel	   := "MATR340"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn  := {STR0009, 1,STR0010, 1, 2, 1, "",1 }	//"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 
PRIVATE cPerg    := U_CriaPerg("MTR340")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // codigo de                                    �
//� mv_par02	 // codigo ate                                   � 
//� mv_par03     // tipo de                                      �
//� mv_par04     // tipo ate                                     �
//� mv_par05     // grupo de                                     �
//� mv_par06     // grupo ate                                    �
//� mv_par07     // descricao de                                 �
//� mv_par08     // descricao ate                                �
//����������������������������������������������������������������
Pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao Setprint                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho)

If nLastKey <> 27

	SetDefault(aReturn,cString)

	RptStatus({|lEnd| BC340Imp(@lEnd,aOrd,wnRel,cString,tamanho,titulo)},titulo)

Else
	dbClearFilter()
EndIf

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C340IMP  � Autor � Rodrigo de A. Sartorio� Data � 13.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR340			                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BC340Imp(lEnd,aOrd,WnRel,cString,tamanho,titulo)

//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
LOCAL aMeses	:= {STR0011,STR0012,STR0013,STR0014,STR0015,STR0016,STR0017,STR0018,STR0019,STR0020,STR0021,STR0022}	//"JAN"###"FEV"###"MAR"###"ABR"###"MAI"###"JUN"###"JUL"###"AGO"###"SET"###"OUT"###"NOV"###"DEZ"
LOCAL aArea 	:= GetArea()
LOCAL cPictQuant:= ""
LOCAL nX 		:= 0
LOCAL nAno		:= 0 
LOCAL nMes		:= 0 
LOCAL nCol 		:= 0
LOCAL nMesAux	:= 0
LOCAL aSub[14] 
LOCAL aTot[14] 
LOCAL lPassou 

//��������������������������������������������������������������Ŀ
//� Variaveis privadas exclusivas deste programa                 �
//����������������������������������������������������������������
PRIVATE lContinua := .T. 
PRIVATE cMes 	  := ""	
PRIVATE cCondicao := ""	 
PRIVATE cCondSec  := ""
PRIVATE cAnt      := ""

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Imporessao do Cabecalho e Rodape   �
//����������������������������������������������������������������
cbtxt    := Space(10)
cbcont   := 0
li       := 80
m_pag    := 1

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIf(aReturn[4]==1,15,18)

//��������������������������������������������������������������Ŀ
//� Pega a Picture da quantidade (maximo de 10 posicoes)         �
//����������������������������������������������������������������
dbSelectArea("SX3")
dbSetOrder(2)
dbSeek("B3_Q01")
If X3_TAMANHO >= 10
	For nX := 1 To 10
		If (nX == X3_TAMANHO - X3_DECIMAL) .And. X3_DECIMAL > 0
			cPictQuant := cPictQuant+"."
		Else
			cPictQuant := cPictQuant+"9"
		EndIf
	Next nX
Else
	For nX := 1 To 10
		If (nX == (X3_DECIMAL + 1)) .And. X3_DECIMAL > 0
			cPictQuant := "."+cPictQuant
		Else
			cPictQuant := "9"+cPictQuant
		EndIf
	Next nX
EndIf
RestArea(aArea)

//��������������������������������������������������������������Ŀ
//� Soma a ordem escolhida ao titulo do relatorio                �
//����������������������������������������������������������������
If Type("NewHead")#"U"
	NewHead += " ("+AllTrim(aOrd[aReturn[8]])+")"
Else
	Titulo += " ("+AllTrim(aOrd[aReturn[8]])+")"
EndIf

//��������������������������������������������������������������Ŀ
//� Montagem Dos Dados do cabecalho do relatorio                 �
//����������������������������������������������������������������
nAno := Year(dDataBase)
If month(dDatabase) < 12
	nAno--
EndIf

nMes := Month(dDataBase)+1
If nMes = 13 
	nMes := 1
EndIf

cMes := StrZero(nMes,2) 



cMF := GETMV("MV_ULMES")

cabec1 := STR0023	//"CODIGO          TP GRUP DESCRICAO                      UM"
*****      123456789012345 12 1234 123456789012345678901234567890 12 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 1234567890 999,999,999.99 A
*****      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
*****      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
For nX := 1 To 12
	If aMeses[nMes] == STR0011 .And. nX != 1	//"JAN"
		nAno++
	EndIf
	cabec1 += Space(3)+aMeses[nMes]+"/"+StrZero(nAno,4)
	nMes++
	If nMes > 12
		nMes := 1
	EndIf
Next nX
cabec1 += STR0024	//"      MEDIA          VALOR CL"
cabec2 := ""

dbSelectArea("SB1")
SetRegua(LastRec())

Set SoftSeek On
Set Order To aReturn[8]
If aReturn[8] == 4
	Seek cFilial+mv_par05
	cCondicao := "lContinua .And. !EOF() .And. B1_GRUPO <= mv_par06"
ElseIf aReturn[8] == 3
	Seek cFilial+mv_par07
	cCondicao := "lContinua .And. !EOF() .And. B1_DESC <= mv_par08"
ElseIf aReturn[8] == 2
	Seek cFilial+mv_par03
	cCondicao := "lContinua .And. !EOF() .And. B1_TIPO <= mv_par04"
Else
	Seek cFilial+mv_par01
	cCondicao := "lContinua .And. !EOF() .And. B1_COD <= mv_par02"
Endif
Set SoftSeek Off

AFILL(aTot,0)
While &cCondicao .and. B1_FILIAL == cFilial

	If aReturn[8] == 2
		cAnt := B1_TIPO
		cCondSec := "B1_TIPO == cAnt"
		cLinhaSub := STR0025+cAnt+" .........."	//"Total do tipo "
	ElseIf aReturn[8] == 4
		cAnt := B1_GRUPO
		cCondSec := "B1_GRUPO == cAnt"
		cLinhaSub := STR0026+cAnt+" ......."		//"Total do grupo "
	Else
		cCondSec := ".T."
	EndIf

	AFILL(aSub,0)
	lPassou := .F.
	While &cCondicao .And. &cCondSec .and. B1_FILIAL == cFilial

		If lEnd
			@Prow()+1,001 PSay STR0027	//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		EndIf

		IncRegua()

		If B1_COD < mv_par01 .Or. B1_COD > mv_par02
			Skip
			Loop
		EndIf

		If B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04
			Skip
			Loop
		EndIf
	
		If B1_GRUPO < mv_par05 .Or. B1_GRUPO > mv_par06
		   Skip
		   Loop
		EndIf

		If B1_DESC < mv_par07 .Or. B1_DESC > mv_par08
		   Skip
		   Loop
		EndIf

		dbSelectArea("SB3")
		Seek cFilial+SB1->B1_COD
		If !Found()
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf

		If li > 55
			Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
		EndIf

		lPassou := .T.
		Select SB1
		@ li,000 PSay B1_COD
		@ li,016 PSay B1_TIPO
		@ li,019 PSay B1_GRUPO
		@ li,024 PSay Substr(B1_DESC,1,30)
		@ li,055 PSay B1_UM

		Select SB3
		nCol    := 58
		nMesAux := nMes

// IMPRIME QTDE
		For nX := 1 To 12     
		//ZANARDO
			cCampo := "B3_Q&cMes"
			@ li,nCol PSay &(cCampo) Picture cPictQuant
			aSub[nX] += &(cCampo)
			nMesAux++
			If nMesAux > 12
				nMesAux := 1
			EndIf
			cMes := StrZero(nMesAux,2)
			nCol += 11
		Next nX
		@ li,190 PSay B3_MEDIA PicTure cPictQuant
		@ li,201 PSay B3_TOTAL PicTure TM(B3_TOTAL,14)
		@ li,216 PSay B3_CLASSE
		li++

		aSub[13] += B3_MEDIA
		aSub[14] += B3_TOTAL
    

// IMPRIME CUSTO MEDIO 
		@ li,000 PSay "CUSTO MEDIO             -->"
		nCol    := 58

		For nX := 1 To 12     
		//ZANARDO
			cCampo := "B3_CMD&cMes"
	
			
			
			if cMes > strZERO(month(cMF),2)  .and. cMes <= strzero(month(date()),2) 
			
				SB2->(msSeek(xFilial("SB2")+SB1->B1_COD+SB1->B1_LOCPAD))
				_cm:=SB2->B2_CM1
				
			elseif cMes > strZERO(month(cMF),2)  .and. cMes > strzero(month(date()),2)  
				_cm:= 0
			else
				_data:= strzero(nAno,4)+cMes+'01'
				_dia :=LASTDAY(stod(_data))
				
				//_dtfech:=nAno+cMes+_dia
								
				dbSelectArea("SB9")
				dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DATA
				SB9->(DBSEEK(XFILIAL("SB9")+SB1->B1_COD+SB1->B1_LOCPAD+dtos(_dia)))
				_cm:=SB9->B9_CM1
		//		_CST:=SB9->B9_CUSTD
			
			//cMes:=MONTH(LASTDAY(MV_PAR02-26))
			
			
			//cMes:= StrZero(cMes, 2)
			
			ENDIF
			
			
				@ li,nCol PSay _cm Picture "@E 9,999.9999"
				aSub[nX] += _cm
				nMesAux++
				If nMesAux > 12
					nMesAux := 1
				EndIf
				cMes := StrZero(nMesAux,2)
				nCol += 11
				Next nX
//		@ li,190 PSay B3_MEDIA PicTure Picture "@E 9,999.9999"
//		@ li,201 PSay B3_TOTAL PicTure TM(B3_TOTAL,14)
//		@ li,216 PSay B3_CLASSE
		li++

		dbSelectArea("SB3")
		Seek cFilial+SB1->B1_COD
		
		
		aSub[13] += SB3->B3_MEDIA
		aSub[14] += SB3->B3_TOTAL

// IMPRIME CUSTO STANDARD
	 
	 @ li,000 PSay "CUSTO STANDARD          -->"
     
     nCol    := 58

	    For nX := 1 To 12     
		//ZANARDO
			cCampo := "B3_CMD&cMes"
	
	    	if cMes > strZERO(month(cMF),2)  .and. cMes <= strzero(month(date()),2) 
			
				_cSTD:=SB1->B1_CUSTD
				
	      	elseif cMes > strZERO(month(cMF),2)  .and. cMes > strzero(month(date()),2)  
				_cSTD:= 0
			else
				_data:= strzero(nAno,4)+cMes+'01'
				_dia :=LASTDAY(stod(_data))
				
				//_dtfech:=nAno+cMes+_dia
								
				dbSelectArea("SB9")
				dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DATA
				SB9->(DBSEEK(XFILIAL("SB9")+SB1->B1_COD+SB1->B1_LOCPAD+dtos(_dia)))
				_cSTD:=SB9->B9_CUSTD
		//		_CST:=SB9->B9_CUSTD
			
			//cMes:=MONTH(LASTDAY(MV_PAR02-26))
			
			
			//cMes:= StrZero(cMes, 2)
			
			ENDIF
			
			
				@ li,nCol PSay _cSTD Picture "@E 9,999.9999"
				aSub[nX] += _cSTD
				nMesAux++
				If nMesAux > 12
					nMesAux := 1
				EndIf
				cMes := StrZero(nMesAux,2)
				nCol += 11
				Next nX
//		@ li,190 PSay B3_MEDIA PicTure Picture "@E 9,999.9999"
//		@ li,201 PSay B3_TOTAL PicTure TM(B3_TOTAL,14)
//		@ li,216 PSay B3_CLASSE
		li++

		dbSelectArea("SB3")
		Seek cFilial+SB1->B1_COD
		
		
		aSub[13] += SB3->B3_MEDIA
		aSub[14] += SB3->B3_TOTAL

	    
	 
// IMPRIME CUSTO STANDARD DIGITADO
		@ li,000 PSay "CUSTO STANDARD DIGITADO -->"
		nCol    := 58

	   For nX := 1 To 12     
		//ZANARDO
			cCampo := "B3_CMD&cMes"
	
	     	if cMes > strZERO(month(cMF),2)  .and. cMes <= strzero(month(date()),2) 
			
				_cSTDm:=SB1->B1_CUSTDM
				
	     	elseif cMes > strZERO(month(cMF),2)  .and. cMes > strzero(month(date()),2)  
		
				_cSTDm:= 0
			else 
				_cSTDm:=SB1->B1_CUSTDM
			
			
				_data:= strzero(nAno,4)+cMes+'01'
				_dia :=LASTDAY(stod(_data))
				
				//_dtfech:=nAno+cMes+_dia
								
				dbSelectArea("SB9")
				dbSetOrder(1)//DA1_FILIAL+DA1_CODTAB+DA1_CODPRO+DATA
				SB9->(DBSEEK(XFILIAL("SB9")+SB1->B1_COD+SB1->B1_LOCPAD+dtos(_dia)))
				_cSTD:=SB9->B9_CUSTD
		//		_CST:=SB9->B9_CUSTD
			
			//cMes:=MONTH(LASTDAY(MV_PAR02-26))
			
			
			//cMes:= StrZero(cMes, 2)
			
			ENDIF
			
			
				@ li,nCol PSay _cSTDm Picture "@E 9,999.9999"
				aSub[nX] += _cSTDm
				nMesAux++
				If nMesAux > 12
					nMesAux := 1
				EndIf
				cMes := StrZero(nMesAux,2)
				nCol += 11
				Next nX
//		@ li,190 PSay B3_MEDIA PicTure Picture "@E 9,999.9999"
//		@ li,201 PSay B3_TOTAL PicTure TM(B3_TOTAL,14)
//		@ li,216 PSay B3_CLASSE
		li++

		dbSelectArea("SB3")
		Seek cFilial+SB1->B1_COD
		
		
		aSub[13] += SB3->B3_MEDIA
		aSub[14] += SB3->B3_TOTAL

	
	
		li++

		dbSelectArea("SB1")
		dbSkip()

	EndDo

	If (aReturn[8] == 2 .Or. aReturn[8] == 4) .And. lPassou
		@ li,030 PSay cLinhaSub
		nCol := 58
		For nX := 1 To 12
			@ li,nCol PSay aSub[nX] Picture cPictQuant
			nCol += 11
		Next nX
		@ li,190 PSay aSub[13] PicTure cPictQuant
		@ li,201 PSay aSub[14] PicTure TM(aSub[14],14)
		li += 2
	EndIf

	For nX := 1 To Len(aTot)
		aTot[nX] += aSub[nX]
	Next nX

EndDo

If li != 80
	If (aReturn[8] == 1 .Or. aReturn[8] == 3)
		li++
	EndIf
	@ li,010 PSay STR0028+Replicate(".",36)		//"Total geral"
	nCol := 58
	For nX := 1 To 12
		@ li,nCol PSay aTot[nX] Picture cPictQuant
		nCol += 11
	Next nX
	@ li,190 PSay aTot[13] PicTure cPictQuant
	@ li,201 PSay aTot[14] PicTure TM(aTot[14],14)
	li += 2
	Roda(cbcont,cbtxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea(cString)
dbClearFilter()

Set Order To 1

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf
MS_FLUSH()
Return