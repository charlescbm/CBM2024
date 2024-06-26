#include "protheus.ch"
#include "topconn.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RESTR02  � Autor � Marcos Eduardo Rocha     � Data � 01/12/05 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Conferencia de Inventario                        ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function RESTR02()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1     := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2     := "de acordo com os parametros informados pelo usuario."
Local cDesc3     := "Relatorio de Conferencia de Inventario"
Local cPict      := ""
Local titulo     := "Rel. de Conferencia de Inventario"
Local nLin       := 80
Local imprime    := .T.
Local aOrd       := {}
Local Cabec1     := ""
Local Cabec2     := ""

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RESTR02"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := "XSTR02"
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RESTR02"
Private aRegs        := {}

Aadd( aRegs, { cPerg, "01","Data Inventario ?"    ,"","","mv_ch1","D",08,0,0,"G","","mv_par01","",				"","","","","",					"","","","","",						"","","","","",					"","","","","","","","","",	"","","",""})
Aadd( aRegs, { cPerg, "02","Produto De  ?"        ,"","","mv_ch2","C",15,0,0,"G","","mv_par02","",				"","","","","",					"","","","","",						"","","","","",					"","","","","","","","","SB1",	"","","",""})
Aadd( aRegs, { cPerg, "03","Produto Ate ?"        ,"","","mv_ch3","C",15,0,0,"G","","mv_par03","",				"","","","","",					"","","","","",						"","","","","",					"","","","","","","","","SB1",	"","","",""})
Aadd( aRegs, { cPerg, "04","Locais a Considerar ?","","","mv_ch4","C",02,0,0,"G","","mv_par04","",				"","","","","",					"","","","","",						"","","","","",					"","","","","","","","","SZ9",	"","","",""})
Aadd( aRegs, { cPerg, "05","Ficha De  ?"          ,"","","mv_ch5","C",09,0,0,"G","","mv_par05","",				"","","","","",					"","","","","",				   		"","","","","",					"","","","","","","","","",	"","","",""})
Aadd( aRegs, { cPerg, "06","Ficha Ate ?"          ,"","","mv_ch6","C",09,0,0,"G","","mv_par06","",				"","","","","",					"","","","","",						"","","","","",					"","","","","","","","","",	"","","",""})
Aadd( aRegs, { cPerg, "07","Lista ?"              ,"","","mv_ch7","N",01,0,0,"C","","mv_par07","Somente Ocor.",	"","","","","Somente Ajuste",	"","","","","Nao Inventariados",	"","","","","Todo Inventario",	"","","","","","","","","",	"","","",""})
Aadd( aRegs, { cPerg, "08","Custo a Consid.?"     ,"","","mv_ch8","N",01,0,0,"C","","mv_par08","Atual",			"","","","","Ultimo Fecham.",	"","","","","",						"","","","","",					"","","","","","","","","",	"","","",""})
lValidPerg(aRegs)

Private cString := "SB7"                                           

Pergunte(cPerg,.f.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,wnrel,		cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
EndIf

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RunReport� Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio de Conferencia de Inventario                        ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

//�����������������������Ŀ
//�Define variaveis locais�
//�������������������������
Local nOrdem, nQtdSys, nCstSys, nQtdDig, nCstDig, nCstFech
Local cQuery   := ""
Local nOcorr   := 0
Local nDispon	:= 0
Local nGQtdSys := 0
Local nGCstSys := 0
Local nGQtdDig := 0
Local nGCstDig := 0
Local cEol     := Chr(13)+Chr(10)
Local cData    := Dtos(mv_par01)
Local Cabec1   := "Ficha       Produto      Descricao                      Loc  Lote        |--------- Sistema ---------| | Contagem 1 | | Contagem 2 | | Contagem 3 | |-------- Contagem ---------| |--------- Ajuste ----------|    Status"
Local Cabec2   := "                                                                         |  Quantidade          Custo| | Quantidade | | Quantidade | | Quantidade | |  Quantidade          Custo| |  Quantidade          Custo|   Disponib."
//                 999999  xxxxxxxxxxxxxxx  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  xx   xxxxxxxxxx  9.999.999,99 999.999.999,99   9.999.999,99   9.999.999,99   9.999.999,99   9.999.999,99 999.999.999,99   9.999.999,99 999.999.999,99  9.999.999,99
//                 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
//                 0        10        20        30        40        50        60        70        80        90       100       110       120       130       140       150       160       170       180       190       200       210       220

//������������������������Ŀ
//�Monta a query de analise�
//��������������������������
cQuery := "SELECT PRODUTO,LOCAL,DOC,LOTE,SUM(NCT1N) NCT1N,SUM(QCT1N) QCT1N,SUM(NCT2N) NCT2N,SUM(QCT2N) QCT2N,SUM(NCT3N) NCT3N,SUM(QCT3N) QCT3N,SUM(NCT1S) NCT1S,SUM(QCT1S) QCT1S,SUM(NCT2S) NCT2S,SUM(QCT2S) QCT2S,SUM(NCT3S) NCT3S,SUM(QCT3S) QCT3S,"+cEOL
cQuery += "CASE WHEN LOTE = ' ' THEN ISNULL((SELECT SUM(B2_QATU-B2_RESERVA) FROM "+RetSQLName("SB2")+" WHERE B2_FILIAL = '"+xFilial("SB2")+"' AND B2_COD = PRODUTO AND B2_LOCAL = LOCAL AND D_E_L_E_T_ <> '*'),0)"+cEOL
cQuery += "ELSE ISNULL((SELECT SUM(B8_SALDO-B8_EMPENHO) FROM "+RetSQLName("SB8")+" WHERE B8_FILIAL = '"+xFilial("SB8")+"' AND B8_PRODUTO = PRODUTO AND B8_LOCAL = LOCAL AND B8_LOTECTL = LOTE AND D_E_L_E_T_ <> '*'),0) END DISPON"+cEOL
cQuery += " FROM("+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,COUNT(*) NCT1N,SUM(B7_QUANT) QCT1N,0 NCT2N,0 QCT2N,0 NCT3N,0 QCT3N,0 NCT1S,0 QCT1S,0 NCT2S,0 QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '001'"+cEOL
cQuery += "		AND B7_DTDIGIT = ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"' AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += "GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"+cEOL
cQuery += "UNION ALL"+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,0 NCT1N,0 QCT1N,COUNT(*) NCT2N,SUM(B7_QUANT) QCT2N,0 NCT3N,0 QCT3N,0 NCT1S,0 QCT1S,0 NCT2S,0 QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '002'"+cEOL
cQuery += "		AND B7_DTDIGIT = ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"' AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += "GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"+cEOL
cQuery += "UNION ALL"+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,0 NCT1N,0 QCT1N,0 NCT2N,0 QCT2N,COUNT(*) NCT3N,SUM(B7_QUANT) QCT3N,0 NCT1S,0 QCT1S,0 NCT2S,0 QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '003'"+cEOL
cQuery += "		AND B7_DTDIGIT = ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"' AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += "GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"+cEOL
cQuery += "UNION ALL"+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,0 NCT1N,0 QCT1N,0 NCT2N,0 QCT2N,0 NCT3N,0 QCT3N,COUNT(*) NCT1S,SUM(B7_QUANT) QCT1S,0 NCT2S,0 QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '001'"+cEOL
cQuery += "		AND B7_DTDIGIT <> ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"' AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += "GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"+cEOL
cQuery += "UNION ALL"+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,0 NCT1N,0 QCT1N,0 NCT2N,0 QCT2N,0 NCT3N,0 QCT3N,0 NCT1S,0 QCT1S,COUNT(*) NCT2S,SUM(B7_QUANT) QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '002'"+cEOL
cQuery += "		AND B7_DTDIGIT <> ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"' AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += "GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"+cEOL
cQuery += "UNION ALL"+cEOL
cQuery += "SELECT B7_COD PRODUTO,B7_LOCAL LOCAL,B7_DOC DOC,B7_LOTECTL LOTE,0 NCT1N,0 QCT1N,0 NCT2N,0 QCT2N,0 NCT3N,0 QCT3N,0 NCT1S,0 QCT1S,0 NCT2S,0 QCT2S,COUNT(*) NCT3S,SUM(B7_QUANT) QCT3S"+cEOL
cQuery += "FROM "+RetSqlName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B7_DATA = '"+cData+"'"+cEOL
cQuery += "		AND B7_COD BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B7_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B7_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += "		AND B7_COD <> ' '"+cEOL
cQuery += "		AND B7_CONTAGE = '003'"+cEOL
cQuery += "		AND B7_DTDIGIT <> ' '"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B7_TIPO >= '"+MV_PAR09+"'  AND B7_TIPO <= '"+MV_PAR10+"' "+cEOL
cQuery += " GROUP BY B7_COD,B7_LOCAL,B7_DOC,B7_LOTECTL"
cQuery += " UNION ALL"+cEOL
cQuery += " SELECT B8_PRODUTO PRODUTO,B8_LOCAL LOCAL,'NI' DOC,B8_LOTECTL LOTE,0 NCT1N,0 QCT1N,0 NCT2N,0 QCT2N,0 NCT3N,0 QCT3N,0 NCT1S,0 QCT1S,0 NCT2S,0 QCT2S,0 NCT3S,0 QCT3S"+cEOL
cQuery += " FROM "+RetSqlName("SB8")+" SB8 "+cEOL
cQuery += " WHERE B8_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "		AND B8_DATA <= '"+cData+"'"+cEOL
cQuery += "		AND D_E_L_E_T_ <> '*'"+cEOL
cQuery += "		AND B8_PRODUTO BETWEEN '"+mv_par02+"' AND '"+mv_par03+"'"+cEOL
cQuery += "		AND B8_LOCAL IN "+FormatIn(AllTrim(mv_par04),"/")+cEOL
cQuery += "		AND B8_DOC BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"+cEOL
cQuery += " AND ROUND((SELECT SUM((CASE WHEN D5_ORIGLAN = 'MAN' THEN 1 WHEN D5_ORIGLAN < '500' THEN 1 ELSE -1 END) * D5_QUANT)"+cEOL
cQuery += "	      FROM "+RetSqlName("SD5")+" SD5 "+cEOL
cQuery += "			WHERE SD5.D5_FILIAL = SB8.B8_FILIAL"+cEOL
cQuery += "			AND SD5.D5_PRODUTO = SB8.B8_PRODUTO"+cEOL
cQuery += "			AND SD5.D5_LOCAL = SB8.B8_LOCAL"+cEOL
cQuery += "			AND SD5.D5_LOTECTL = SB8.B8_LOTECTL"+cEOL
cQuery += "			AND SD5.D5_NUMLOTE = SB8.B8_NUMLOTE"+cEOL
cQuery += "			AND SD5.D5_ESTORNO <> 'S'"+cEOL
cQuery += "			AND SD5.D_E_L_E_T_ <> '*'),4) > 0"+cEOL
cQuery += " AND (SELECT COUNT(*) FROM "+RetSqlName("SB7")+" SB7 "+cEOL
cQuery += "			WHERE SB7.B7_FILIAL = SB8.B8_FILIAL"+cEOL
cQuery += "			AND SB7.B7_COD = SB8.B8_PRODUTO"+cEOL
cQuery += "			AND SB7.B7_LOTECTL = SB8.B8_LOTECTL"+cEOL
cQuery += "			AND SB7.B7_LOCAL = SB8.B8_LOCAL"+cEOL
cQuery += "			AND SB7.B7_DATA = '"+cData+"'"+cEOL
cQuery += "			AND SB7.D_E_L_E_T_ <> '*') = 0"+cEOL
cQuery += " GROUP BY B8_PRODUTO,B8_LOCAL,B8_DOC,B8_LOTECTL) SB7"+cEOL
cQuery += " GROUP BY PRODUTO,LOCAL,DOC,LOTE"+cEOL
cQuery += " ORDER BY DOC,PRODUTO,LOCAL,LOTE"

MemoWrite("\QUERYSYS\RESTR02.SQL",cQuery)
//cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

dbSelectArea("TRB")
SetRegua(RecCount())
dbGotop()

While !Eof()

	IncRegua()

	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	If lAbortPrint
		@nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	EndIf

	//�������������������������������Ŀ
	//�Inicializa variaveis de analise�
	//���������������������������������
	nQtdSys := 0
	nCstSys := 0
	nQtdDig := 0
	nCstDig := 0

	//������������������������������Ŀ
	//�Identifica tipo de divergencia�
	//��������������������������������
   cTipDif := " "
	If TRB->(NCT1N+NCT2N+NCT3N) > 1
	   cTipDif := "CI"   // Com Inventario
	ElseIf TRB->NCT1S == 1 .And. TRB->NCT2S == 1 .And. TRB->NCT3S == 0 .And. TRB->QCT1S <> TRB->QCT2S 
	   cTipDif := "N3"   // Faltando a Terceira contagem
	ElseIf TRB->(NCT1N+NCT2N+NCT3N) == 0 .And. AllTrim(TRB->DOC) == "NI"
	   cTipDif := "NI"   // Lotes n�o inventariados
	Else
	   cTipDif := "DF"
	   nQtdDig := If(TRB->NCT3S == 1,TRB->QCT3S,TRB->QCT2S)      
	EndIf
		   
	//�������������������������������������������������Ŀ
	//�Calcula custo do ultimo fechamento, se necessario�
	//���������������������������������������������������
	nCstFech := 0      
	
	If mv_par08 == 2
		dbSelectArea("SB9")                    
		dbSetOrder(1)
		dbSeek(xFilial("SB9")+TRB->PRODUTO+TRB->LOCAL)
		
		While xFilial("SB9")+TRB->PRODUTO+TRB->LOCAL == B9_FILIAL + B9_COD + B9_LOCAL
			nCstFech := If(B9_QINI = 0,0,B9_VINI1/B9_QINI)
			dbSkip()
		End
	EndIf             
	
	dbSelectArea("TRB")

	//������������������������Ŀ
	//�Calcula saldo do sistema�
	//��������������������������
	If !Rastro(TRB->PRODUTO)
		aSaldo    := CalcEst(TRB->PRODUTO,TRB->LOCAL,mv_par01+1)
   	nQtdSys := aSaldo[1]
		nCstSys := If(mv_par08==1,aSaldo[2],aSaldo[1]*nCstFech)
		nCstDig := If(mv_par08==1,(aSaldo[2] / aSaldo[1]),nCstFech) * nQtdDig
	Else	
		aSalQtd   := CalcEstL(TRB->PRODUTO,TRB->LOCAL,mv_par01+1,TRB->LOTE,"","","")
		aSaldo    := CalcEst(TRB->PRODUTO,TRB->LOCAL,mv_par01+1)
   	nQtdSys := aSalQtd[1]
		nCstSys := If(mv_par08==1,(aSaldo[2] / aSaldo[1]),nCstFech) * aSalQtd[1]
		nCstDig := If(mv_par08==1,(aSaldo[2] / aSaldo[1]),nCstFech) * nQtdDig
   EndIf

//	If (cTipDif $ "CI/N3" .And. mv_par07 <> 2) .Or. (mv_par07 == 3) .Or. (nQtdSys <> nQtdDig .And. !cTipDif $ "CI/N3" .And. mv_par07 <> 1)  

	If (cTipDif $ "NI" .And. mv_par07 == 3 .And. nQtdSys > 0) .Or. (cTipDif $ "CI/N3" .And. mv_par07 <> 2 .And. mv_par07 <> 3) .Or. (mv_par07 == 4) .Or. (nQtdSys <> nQtdDig .And. !cTipDif $ "CI/N3" .And. mv_par07 <> 1 .And. mv_par07 <> 3)
		@ nLin , 000 Psay TRB->DOC
		@ nLin , 012 Psay TRB->PRODUTO   //08
		@ nLin , 025 Psay Posicione("SB1",1,xFilial("SB1")+TRB->PRODUTO,"Left(B1_DESC,30)")
		@ nLin , 057 Psay TRB->LOCAL
		@ nLin , 062 Psay TRB->LOTE
		@ nLin , 074 Psay nQtdSys Picture "@E 9,999,999.99"
		@ nLin , 087 Psay nCstSys Picture "@E 999,999,999.99"
		@ nLin , 104 Psay TRB->QCT1N + TRB->QCT1S Picture "@E 9,999,999.99"
		@ nLin , 119 Psay TRB->QCT2N + TRB->QCT2S Picture "@E 9,999,999.99"
		@ nLin , 134 Psay TRB->QCT3N + TRB->QCT3S Picture "@E 9,999,999.99"
			
		If cTipDif == "CI"
			@ nLin , 149 Psay "Contagem Insuficiente"
			nOcorr ++
		ElseIf cTipDif == "N3"
			@ nLin , 149 Psay "Necessaria a Terceira Contagem"
			nOcorr ++
		ElseIf cTipDif == "NI"
			@ nLin , 149 Psay "Nao Inventariado"
			nGQtdSys += nQtdSys
			nGCstSys += nCstSys
			nOcorr ++
		Else
			@ nLin , 149 Psay nQtdDig Picture "@E 9,999,999.99"
			@ nLin , 162 Psay nCstDig Picture "@E 999,999,999.99"
			@ nLin , 179 Psay nQtdDig-nQtdSys Picture "@E 9,999,999.99"
			@ nLin , 192 Psay nCstDig-nCstSys Picture "@E 999,999,999.99"
			nGQtdSys += nQtdSys
			nGCstSys += nCstSys
			nGQtdDig += nQtdDig
			nGCstDig += nCstDig
		EndIf	
	
		If DISPON + nQtdDig - nQtdSys < 0 .And. !cTipDif $ "CI/N3/NI"
			@ nLin , 208 Psay DISPON Picture "@E 9,999,999.99"
			nDispon ++
		EndIf

		nLin ++
	EndIf

	dbSelectArea("TRB")
	dbSkip()
EndDo

If nLin <> 80
	nLin += 2

	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	EndIf

	@ nLin , 000 Psay "Total do Inventario : "
	@ nLin , 074 Psay nGQtdSys Picture "@E 9,999,999.99"
	@ nLin , 087 Psay nGCstSys Picture "@E 999,999,999.99"
	@ nLin , 149 Psay nGQtdDig Picture "@E 9,999,999.99"                           
	@ nLin , 162 Psay nGCstDig Picture "@E 999,999,999.99"                                                   
	@ nLin , 179 Psay nGQtdDig-nGQtdSys Picture "@E 9999,999,999.9999"//Picture "@E 9,999,999.99"
	@ nLin , 196 Psay nGCstDig-nGCstSys Picture "@E 999,999,999.99"
	
	nLin += 2

	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	EndIf

	@ nLin , 000 Psay If(nOcorr==0,"Nenhuma inconsistencia",LTrim(Str(nOcorr,6))+" inconsistencia"+If(nOcorr==1,"","s"))+" de apontamento de inventario."
	
	nLin += 2

	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	EndIf

	@ nLin , 000 Psay If(nDispon==0,"Nenhuma divergencia",LTrim(Str(nDispon,6))+" divergencia"+If(nDispon==1,"","s"))+" de empenho."
EndIf	

dbSelectArea("TRB")
dbCloseArea()

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������
Set Device To Screen

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
If aReturn[5]==1
	dbCommitAll()
   Set Printer To
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return