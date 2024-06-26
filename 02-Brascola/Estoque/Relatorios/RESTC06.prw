#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"

#DEFINE  cEOL     CHR(13)+CHR(10)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RESTC04  � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de ultimas notas fiscais                             ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function RESTC06(xParam)
**************************
LOCAL aRegs := {}
LOCAL cPerg	:= U_CriaPerg("ESTC06")

aAdd(aRegs,{cPerg,"01","Data Inicial?"	 			,"","","mv_ch1","D",08,0,0,"G","","mv_par01",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"02","Data Final?"    			,"","","mv_ch2","D",08,0,0,"G","","mv_par02",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"03","Considera Tipo Produto :","","","mv_ch3","C",30,0,0,"G","","mv_par03",""      ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"04","Desconsidera TES"			,"","","mv_ch4","C",30,0,0,"G","","mv_par04",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aRegs,{cperg,"05","Totaliza Complementos?"	,"","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim"     ,"","","","","Nao" ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aRegs,{cPerg,"06","Produto De ?"      		,"","","mv_ch6","C",15,0,0,"G","","mv_par06",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})
Aadd(aRegs,{cPerg,"07","Produto At�?"      		,"","","mv_ch7","C",15,0,0,"G","","mv_par07",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})
lValidPerg(aRegs)
If (xParam == Nil)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	MSGRUN("Aguarde....","Processando",{ || u_RESTC061()})
Elseif (xParam != Nil)
	Pergunte(cPerg,.F.)
	mv_par01 := xParam[1]  //Data Inicio
	mv_par02 := xParam[2]  //Data Final
	mv_par03 := xParam[3]  //Considera Tipo de Produto
	mv_par04 := xParam[4]  //Desconsidera TES
	mv_par05 := xParam[5]  //Totaliza Complementos
	mv_par06 := xParam[6]  //Produto De
	mv_par07 := xParam[7]  //Produto Ate
	u_RESTC061()
Endif

Return(.T.)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    �          � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de Faturamento por Produto                           ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function RESTC061(aPar)
*************************
LOCAL cQuery := ""
LOCAL cAlias := "TRB"
LOCAL cTipos := ""

//Valor de custo retornado por esta funcao quando for 
//utilizada por um programa que aproveita este codigo
LOCAL nRet := 0

PRIVATE _mv_par01 := mv_par01   //Data Inicio
PRIVATE _mv_par02 := mv_par02   //Data Final
PRIVATE _mv_par03 := mv_par03   //Considera Tipo de Produto
PRIVATE _mv_par04 := mv_par04   //Desconsidera TES
PRIVATE _mv_par05 := mv_par05   //Totaliza Complementos
PRIVATE _mv_par08 := mv_par08   //Totaliza Complementos
PRIVATE lSint    //Verifica se o resultado sera totalizando os valores de
PRIVATE lProdUni //Verifica se sera pesquisado apenas um produto

//��������������������������������������������������������������
//�Tratamento dos parametros quando a funcao for chamada por   �
//|algum programa que esta aproveitando o codigo.              |
//��������������������������������������������������������������
lProdUni := .t.

//���������������������������������������������
//�Verifica se ira totalizar os complementos  �
//���������������������������������������������
lSint := If(_mv_par05==1,.T.,.F.)

//���������������������������������������������
//�Selecao de itens do mercado INTERNO somente�
//���������������������������������������������
cQuery := " SELECT D1_TES, D1_NUMSEQ, D1_COD, B1_DESC, D1_DOC, D1_SERIE, D1_TP TIPOPROD, D1_DTDIGIT, D1_FORNECE, D1_CF  "+cEOL
cQuery += " FROM "+RetSQLName("SD1")+" SD1, "+RetSQLName("SB1")+" SB1"+cEOL
//cQuery += " WHERE D1_FILIAL = '"+xFilial(dbSelectArea("SD1"))+"'"+cEOL						// ZANARDO 25/04/08
//cQuery += " AND D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL		// ZANARDO 25/04/08
cQuery += " WHERE D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL
cQuery += " AND D1_TIPO = 'N'"+cEOL
cQuery += " AND D1_QUANT > 0"+cEOL
cQuery += " AND D1_TP IN ('"+StrTran(_MV_PAR03,"/","','")+"')"+cEOL
cQuery += " AND D1_TES IN (SELECT F4_CODIGO FROM SF4010 WHERE F4_UPRC = 'S' AND F4_CODIGO <'501' AND SF4010.D_E_L_E_T_ = '')"+cEOL
cQuery += " AND SD1.D_E_L_E_T_ <> '*'"+cEOL
cQuery += " AND D1_DTDIGIT+D1_NUMSEQ = ISNULL((	SELECT MAX(D1_DTDIGIT+D1_NUMSEQ) FROM "+RetSQLName("SD1")+" SD12 "+cEOL
//cQuery += " 									WHERE SD12.D1_FILIAL = SD1.D1_FILIAL"+cEOL														// ZANARDO 25/04/08
//cQuery += " 			  						AND SD12.D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL				// ZANARDO 25/04/08
cQuery += " 			  						WHERE SD12.D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL
cQuery += " 									AND SD12.D1_COD = SD1.D1_COD"+cEOL
cQuery += " 			  						AND SD12.D1_TIPO = 'N'"+cEOL
cQuery += " 									AND SD12.D1_QUANT > 0"+cEOL

//If Len(AllTrim(_mv_par04))>0
//	cQuery += "                                 AND D1_TES IN ('"+StrTran(_MV_PAR04,"/","','")+"')"+cEOL
cQuery += " AND D1_TES IN (SELECT F4_CODIGO FROM SF4010 WHERE F4_UPRC = 'S' AND F4_CODIGO <'501' AND SF4010.D_E_L_E_T_ = '')"+cEOL
cQuery += " AND SD12.D_E_L_E_T_ <> '*'), ' ')"+cEOL
//cQuery += " AND B1_FILIAL = '  '"+cEOL						// ZANARDO 25/04/08
cQuery += " AND B1_COD = D1_COD"+cEOL
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"+cEOL
//Filtra o intervalo dos produtos
cQuery += " AND D1_COD >= '"+mv_par06+"'"+cEOL
cQuery += " AND D1_COD <= '"+mv_par07+"'"+cEOL

cQuery += " ORDER BY D1_COD"+cEOL

MemoWrite("\QUERYSYS\RESTC06.SQL",cQuery)

If Select("TRB")>0
	dbSelectArea("TRB")
	TRB->(dbCloseArea("TRB"))
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

//�����������������������������������������������������������������������������Ŀ
//�Se a rotina NAO foi chamada por um programa que es� reaproveitando           �
//�o codigo para chegar no ultimo custo de entrada, exibe os dados no EXCEL     �
//�caso afirmativo, grava o valor do custo de entrada da unica linha TRB->TOTAL �
//�������������������������������������������������������������������������������
If lProdUni
	nRet := ArqTemp()
ENDIF
TRB->(DBClosearea())

Return nRet


************************************
*//Gera arquivo temporario
************************************
Static Function ArqTemp()
**********************
Local aStruc := {}
Local aCompl := {}
Local nRet   := 0

//��������������������������Ŀ
//� Cria Arquivo temporario. �
//����������������������������
Aadd(aStruc,{"D1_TES",			"C",03,00})
Aadd(aStruc,{"D1_NUMSEQ",		"C",06,00})
Aadd(aStruc,{"D1_COD",			"C",15,00})
Aadd(aStruc,{"B1_DESC",			"C",40,00})
Aadd(aStruc,{"D1_DOC",			"C",09,00})
Aadd(aStruc,{"D1_SERIE",		"C",03,00})
Aadd(aStruc,{"TIPOPROD",		"C",02,00})
Aadd(aStruc,{"D1_DTDIGIT",		"D",08,00})
Aadd(aStruc,{"D1_FORNECE",		"C",06,00})
Aadd(aStruc,{"D1_QUANT",		"N",16,04})
Aadd(aStruc,{"D1_VUNIT",		"N",16,04})
Aadd(aStruc,{"D1_TOTAL",		"N",16,04})
Aadd(aStruc,{"ICM",				"N",16,04})
Aadd(aStruc,{"IPI",				"N",16,04})
Aadd(aStruc,{"PIS",				"N",16,04})
Aadd(aStruc,{"COFINS",			"N",16,04})
Aadd(aStruc,{"ULTPRC",			"N",16,04})
Aadd(aStruc,{"TIPO",				"C",01,00})

cArqTRB := CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cArqTRB, "TRBX",.F.,.F.)

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	//IF TRB->D1_COD <> '1160018        '
	//DBSKIP()
	//LOOP
	//ENDIF
	
	dbSelectArea("TRBX")
	RecLock("TRBX",.T.)
	TRBX->D1_TES			:= TRB->D1_TES
	TRBX->D1_NUMSEQ		:= TRB->D1_NUMSEQ
	TRBX->D1_COD 			:= TRB->D1_COD
	TRBX->B1_DESC			:= TRB->B1_DESC
	TRBX->D1_DOC			:= TRB->D1_DOC
	TRBX->D1_SERIE 		:= TRB->D1_SERIE
	TRBX->TIPOPROD 		:= TRB->TIPOPROD
	TRBX->D1_DTDIGIT 		:= STOD(TRB->D1_DTDIGIT)
	TRBX->D1_FORNECE		:= TRB->D1_FORNECE
	
	//���������������������������������������������������������������������Ŀ
	//�Insere os valores sumarizados por nota fiscal                        �
	//�����������������������������������������������������������������������
	cQuery := " SELECT 	LEFT(D1_CF,1) AS CFO, "+cEOL
	cQuery += " 			SUM(D1_QUANT) 		D1_QUANT, "+cEOL
	cQuery += " 			SUM(D1_VUNIT) 		D1_VUNIT, "+cEOL
	cQuery += " 			SUM(D1_TOTAL) 		D1_TOTAL, "+cEOL
	cQuery += "				SUM(D1_VALICM) 	    ICM, "+cEOL
	cQuery += " 			SUM(D1_VALIPI) 	    IPI, "+cEOL
	cQuery += " 			SUM(D1_VALIMP5)	    PIS, "+cEOL
	cQuery += "				SUM(D1_VALIMP6) 	COFINS "+cEOL
	//cQuery += "				,SUM((D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6) / CASE WHEN D1_QUANT=0 THEN 1 ELSE D1_QUANT END) ULTPRC "+cEOL
	cQuery += "	FROM "+RetSQLName("SD1")+" SD1 "+cEOL
	//		cQuery += " WHERE "
	//		cQuery += "     D1_FILIAL 			= '"+xFilial(dbSelectArea("SD1"))+"'"+cEOL					// ZANARDO 25/04/08
	//		cQuery += " AND D1_FORNECE 	        = '"+TRB->D1_FORNECE+"'"+cEOL                				// ZANARDO 25/04/08
	cQuery += " WHERE D1_FORNECE 	        = '"+TRB->D1_FORNECE+"'"+cEOL
	cQuery += " AND D1_DOC 				= '"+TRB->D1_DOC+"'"+cEOL
	cQuery += " AND D1_SERIE 			= '"+TRB->D1_SERIE+"'"+cEOL
	cQuery += " AND D1_COD				= '"+TRB->D1_COD+"'"+cEOL
	cQuery += " AND SD1.D_E_L_E_T_	= ''"+cEOL
	cQuery += " GROUP BY LEFT(D1_CF,1) "
	If Select("TRB2")>0
		dbSelectArea("TRB2")
		TRB->(dbCloseArea("TRB2"))
	EndIf
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB2",.F.,.T.)
	
	//���������������������������������������������������������������������Ŀ
	//�Insere valores referentes a notas fiscais de Complemento, se houveram�
	//�����������������������������������������������������������������������
	//		aCompl := VrComp(xFilial("SD1"),TRB->D1_FORNECE,TRB->D1_COD,TRB->D1_DOC,TRB->D1_SERIE)
	aCompl := VrComp(TRB->D1_FORNECE,TRB->D1_COD,TRB->D1_DOC,TRB->D1_SERIE)
	
	If lSint
		TRBX->D1_QUANT      := TRB2->D1_QUANT	+ aCompl[01,09]
		TRBX->D1_VUNIT      := TRB2->D1_VUNIT	+ aCompl[01,10]
		TRBX->D1_TOTAL      := TRB2->D1_TOTAL	+ aCompl[01,11]
		TRBX->ICM           := TRB2->ICM		+ aCompl[01,12]
		TRBX->IPI           := TRB2->IPI 		+ aCompl[01,13]
		TRBX->PIS           := TRB2->PIS 		+ aCompl[01,14]
		TRBX->COFINS        := TRB2->COFINS	+ aCompl[01,15]
		TRBX->ULTPRC        := TRB2->(D1_TOTAL- ICM-PIS-COFINS+aCompl[01,16]) / TRB2->D1_QUANT//TRB2->(D1_TOTAL-IIF(CFO=='3',0,ICM+PIS+COFINS)+aCompl[01,16]) / TRB2->D1_QUANT
		TRBX->TIPO          := "N"
		MsUnlock()
	Else
		TRBX->D1_QUANT      := TRB2->D1_QUANT
		TRBX->D1_VUNIT      := TRB2->D1_VUNIT
		TRBX->D1_TOTAL      := TRB2->D1_TOTAL
		TRBX->ICM           := TRB2->ICM
		TRBX->IPI           := TRB2->IPI
		TRBX->PIS           := TRB2->PIS
		TRBX->COFINS        := TRB2->COFINS
		TRBX->ULTPRC        := TRB2->(D1_TOTAL-ICM-PIS-COFINS) / TRB2->D1_QUANT//TRB2->(D1_TOTAL-IIF(CFO=='3',0,ICM+PIS+COFINS)) / TRB2->D1_QUANT
		TRBX->TIPO          := "N"
		MsUnlock()
		
		For ix:=2 To Len(aCompl)
			RecLock("TRBX",.T.)
			TRBX->D1_TES     := aCompl[ix,01]
			TRBX->D1_NUMSEQ  := aCompl[ix,02]
			TRBX->D1_COD     := aCompl[ix,03]
			TRBX->B1_DESC    := TRB->B1_DESC
			TRBX->D1_DOC     := aCompl[ix,04]
			TRBX->D1_SERIE   := aCompl[ix,05]
			TRBX->TIPOPROD   := aCompl[ix,06]
			TRBX->D1_DTDIGIT := STOD(aCompl[ix,07])
			TRBX->D1_FORNECE := aCompl[ix,08]
			TRBX->D1_QUANT   := aCompl[ix,09]
			TRBX->D1_VUNIT   := aCompl[ix,10]
			TRBX->D1_TOTAL   := aCompl[ix,11]
			TRBX->ICM        := aCompl[ix,12]
			TRBX->IPI        := aCompl[ix,13]
			TRBX->PIS        := aCompl[ix,14]
			TRBX->COFINS     := aCompl[ix,15]
			TRBX->ULTPRC     := aCompl[ix,16]
			TRBX->TIPO       := "C"
			MsUnlock()
		Next
		
	EndIf
	
	DDATAA:=(MV_PAR02)
	
	//cMF :=  StrZero(MONTH(GETMV("MV_ULMES")),2)
	//cMes := StrZero(MONTH(DDATAA),2)
	//cCampo2 := "B3_STD&cMes"
	//cCampo3 := "B3_STDM&cMes
	//cCampo4 := "B3_CMD&cMes
	_nValor := 0
	/*
	DBSELECTAREA("SB3")
	IF DBSeek('04'+TRBX->D1_COD)
	RecLock("SB3",.F.)
	&(cCampo2) := TRBX->ULTPRC
	&(cCampo3) := TRBX->ULTPRC
	MsUnlock()
	ENDIF
	SB3->(dbclosearea("SB3"))
	
	DBSELECTAREA("SB3")
	IF DBSeek('01'+TRBX->D1_COD)
	RecLock("SB3",.F.)
	&(cCampo2) := TRBX->ULTPRC
	&(cCampo3) := TRBX->ULTPRC
	MsUnlock()
	ENDIF
	*/
	//IF MV_PAR08  = 1
	DBSELECTAREA("SB1")
	IF DBSEEK(XFILIAL("SB1")+TRBX->D1_COD)
		RECLOCK("SB1",.F.)
		SB1->B1_CUSTD:=TRBX->ULTPRC
		SB1->B1_CUSTDM:=TRBX->ULTPRC
		SB1->(MSUNLOCK())
		If ExistBlock("A320CUSTR")
			ExecBlock("A320CUSTR",.F.,.F.,{SB1->B1_cod,SB1->B1_custd})
		Endif
	ENDIF
	// ENDIF
	
	
	/*
	if cMes >= cMF
	dbselectarea("SB2")
	DBSETORDER(1)
	IF DBSEEK('01'+TRBX->D1_COD+SB1->B1_LOCPAD)
	IF cMes > cMF
	_nValor := SB2->B2_CM1
	elseif cMes == cMF
	If SB2->(B2_QFIM>0 .And. B2_VFIM1>0)
	_nValor := SB2->B2_VFIM1 / SB2->B2_QFIM
	Else
	_nValor := SB2->B2_CM1
	ENDIF
	ENDIF
	
	DBSELECTAREA("SB3")
	IF DBSeek('01'+TRBX->D1_COD)
	RECLOCK("SB3",.F.)
	&(cCampo4) := _nValor
	SB3->(MSUNLOCK())
	ENDIF
	endif
	SB3->(dbclosearea("SB3"))
	SB2->(dbclosearea("SB2"))
	
	dbselectarea("SB2")
	DBSETORDER(1)
	IF DBSEEK('04'+TRBX->D1_COD+SB1->B1_LOCPAD)
	IF cMes > cMF
	_nValor := SB2->B2_CM1
	elseif cMes == cMF
	If SB2->(B2_QFIM>0 .And. B2_VFIM1>0)
	_nValor := SB2->B2_VFIM1 / SB2->B2_QFIM
	Else
	_nValor := SB2->B2_CM1
	ENDIF
	ENDIF
	
	DBSELECTAREA("SB3")
	IF DBSeek('04'+TRBX->D1_COD)
	RecLock("SB3",.F.)
	&(cCampo4) := _nValor
	MsUnlock()
	endif
	ENDIF
	endif
	
	*/
	dbSelectArea("TRB2")
	TRB2->(dbCloseArea())
	
	dbSelectArea("TRB")
	TRB->(dbSkip())
	
EndDo

TRBX->(dbCloseArea())

Ferase(cArqTRB)

Return(nRet)

***********************************
*//verifica os valores de complementos
************************************
//Static Function VrComp(_cFilial,cFornece,cProd,cDoc,cSerie)		// ZANARDO 25/04/08
Static Function VrComp(cFornece,cProd,cDoc,cSerie)
*********************************************
Local cQuery := ""
Local aRet   := {}

aAdd(aRet,{"","","","","","","","",0,0,0,0,0,0,0,0})

cQuery := " SELECT 	    D1_TES, D1_NUMSEQ, D1_COD, D1_DOC, D1_SERIE, D1_TP TIPOPROD, D1_DTDIGIT, D1_FORNECE, D1_QUANT, "+cEOL
cQuery += "             D1_VUNIT, D1_TOTAL, D1_VALICM ICM, D1_VALIPI IPI, D1_VALIMP5 PIS, D1_VALIMP6 COFINS, "+cEOL
cQuery += "             ((D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6) / CASE WHEN D1_QUANT=0 THEN 1 ELSE D1_QUANT END ) ULTPRC "+cEOL
cQuery += " FROM "+RetSQLName("SD1")+" SD1 "+cEOL
//cQuery += " WHERE "+cEOL													// ZANARDO 25/04/08
//cQuery += " (   D1_FILIAL 		= '"+_cFilial+"'"+cEOL					// ZANARDO 25/04/08
//cQuery += " AND D1_FORNECE	 	= '"+cFornece+"'"+cEOL					// ZANARDO 25/04/08
cQuery += " WHERE (D1_FORNECE	 	= '"+cFornece+"'"+cEOL
cQuery += " AND D1_NFORI 		= '"+cDoc+"'"+cEOL
cQuery += " AND D1_COD			= '"+cProd+"'"+cEOL
cQuery += " AND D1_TIPO 		= 'C' "+cEOL
cQuery += " AND SD1.D_E_L_E_T_ <> '*' "+cEOL
cQuery += " ) OR ( "
cQuery += "     D1_DOC+D1_SERIE IN (	SELECT F8_NFDIFRE+F8_SEDIFRE "+cEOL
cQuery += " 									FROM "+RetSQLName("SF8")+" SF8 "+cEOL
cQuery += " 									WHERE F8_FORNECE+F8_NFORIG IN ('"+cFornece+cDoc+"')"+cEOL
cQuery += " 									AND SF8.D_E_L_E_T_='') "+cEOL
cQuery += " AND SD1.D_E_L_E_T_  = '' "
cQuery += " AND D1_COD          = '"+cProd+"'"
cQuery += " ) "


// ZANARDO 25/04/08
/*cQuery += "     D1_FILIAL+D1_DOC+D1_SERIE IN (	SELECT F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE "+cEOL
cQuery += " 									FROM "+RetSQLName("SF8")+" SF8 "+cEOL
cQuery += " 									WHERE F8_FILIAL+F8_FORNECE+F8_NFORIG IN ('"+_cFilial+cFornece+cDoc+"')"+cEOL
cQuery += " 									AND SF8.D_E_L_E_T_='') "+cEOL
cQuery += " AND SD1.D_E_L_E_T_  = '' "
cQuery += " AND D1_COD          = '"+cProd+"'"
cQuery += " ) "
*/


If Select("TRBSQL")>0
	dbSelectArea("TRBSQL")
	TRBSQL->(dbCloseArea("TRBSQL"))
EndIf

cQuery := ChangeQuery(cQuery)
MemoWrite("\QUERYSYS\RESTC04_VrComp.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TRBSQL"

dbSelectArea("TRBSQL")
dbGoTop()
While !Eof()
	
	If lSint
		aRet[01,01] := 0
		aRet[01,02] := 0
		aRet[01,03] := 0
		aRet[01,04] := 0
		aRet[01,05] := 0
		aRet[01,06] := 0
		aRet[01,07] := 0
		aRet[01,08] := 0
		aRet[01,09] := If(aRet[01,09]==Nil,0,aRet[01,09]+TRBSQL->D1_QUANT)
		aRet[01,10] := If(aRet[01,10]==Nil,0,aRet[01,10]+TRBSQL->D1_VUNIT)
		aRet[01,11] := If(aRet[01,11]==Nil,0,aRet[01,11]+TRBSQL->D1_TOTAL)
		aRet[01,12] := If(aRet[01,12]==Nil,0,aRet[01,12]+TRBSQL->ICM)
		aRet[01,13] := If(aRet[01,13]==Nil,0,aRet[01,13]+TRBSQL->IPI)
		aRet[01,14] := If(aRet[01,14]==Nil,0,aRet[01,14]+TRBSQL->PIS)
		aRet[01,15] := If(aRet[01,15]==Nil,0,aRet[01,15]+TRBSQL->COFINS)
		aRet[01,16] := If(aRet[01,16]==Nil,0,aRet[01,16]+TRBSQL->ULTPRC)
	Else
		aAdd(aRet,{		TRBSQL->D1_TES,;
		TRBSQL->D1_NUMSEQ,;
		TRBSQL->D1_COD,;
		TRBSQL->D1_DOC,;
		TRBSQL->D1_SERIE,;
		TRBSQL->TIPOPROD,;
		TRBSQL->D1_DTDIGIT,;
		TRBSQL->D1_FORNECE,;
		TRBSQL->D1_QUANT,;
		TRBSQL->D1_VUNIT,;
		TRBSQL->D1_TOTAL,;
		TRBSQL->ICM,;
		TRBSQL->IPI,;
		TRBSQL->PIS,;
		TRBSQL->COFINS,;
		TRBSQL->ULTPRC})
	Endif
	
	TRBSQL->(dbSkip())
EndDo

TRBSQL->(dbCloseArea())

Return(aRet)   