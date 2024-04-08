#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATC07   ºAutor  ³Cleiton/Thiago      ºData ³ 18/07/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relacao em HTML dos pedidos emitidos, ordenados por        º±±
±±º          ³ valor.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Brascola                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

User Function GeraEntP(lAuto)
**********************


Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro		:= OemToAnsi("Envio de Relatorio Entrada de Pedidos aos Diretores")
Local nProcessa		:= 3
Local lAuto			:= If(lAuto == NIL,{.F.},lAuto)
Local lJob			:= .t.
Local cQuery

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "U_GeraEntP"

ConOut(" ")
ConOut("> GERAENTP - Entrada de Pedidos... Inicio: "+Time())

RPCSetType(3)  // Nao usar Licensa

U_GerEntP(lJob)
       
ConOut(">GERAENTP - Entrada de Pedidos... Fim: "+Time())
RESET ENVIRONMENT
RestArea(aAreaAtu)

Return(.T.)



User Function GerEntPM()
***********************
U_GerEntP(.f.)

Return(Nil)


User Function GerEntP(lJob)
**************************
Local cQuery     := ""
Local cPerg      := U_CriaPerg("FATC07")
Local aRegs      := {}
Local cEst       := "", cFin := ""
Local aMeses     := {"Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"}
Local dDataOntem := DataValida(dDataBase , .f.)

Private cMesAux    := ""
Private cAnoAux    := ""
Private cDataAux   := ""
Private cHoraAux   := ""
Private cEmissao   := ""
Private cGeraFat   := ""
Private nTotalAtual:= 0
Private nTotNAtual := 0
Private nTotVAtual := 0
Private nTotalFut  := 0
Private nTotValor  := 0
Private nQtpdatual := 0
Private nQtpdfut   := 0
Private nTotqt     := 0
Private nMedAtual  := 0
Private nMedFut    := 0
Private nTotMed    := 0
Private aDadosAux  :={} 
Private cEmail     := GETMV("BR_000009")//emails de usuários que receberão workflow Entrada de Pedido 
//Private cEmail := "charlesm@brascola.com.br"

//If lJob .And. Month(dDataOntem) <> Month(dDataBase)
//	Return .t.
//EndIf

aAdd(aRegs,{"FATC07",	"01","Por Data de?"		,"Por Data de?"		,"Por Data de?"		,"mv_ch1","N",1,0,0,"C","","mv_par01","Emissao"	 ,"","","","","Entrega"		,"","","","",""		,"","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"FATC07",	"02","Dt Inicio  ?"		,"Dt Inicio  ?"  	,"Dt Inicio  ?"		,"mv_ch2","D",8,0,0,"G","","mv_par02",""		 ,"","","","",""			,"","","","",""		,"","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"FATC07",	"03","Dt Final   ?"		,"Dt Final   ?"  	,"Dt Final   ?"		,"mv_ch3","D",8,0,0,"G","","mv_par03",""		 ,"","","","",""			,"","","","",""		,"","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"FATC07",	"04","Formato    ?"		,"Formato    ?"		,"Formato    ?"  	,"mv_ch4","N",1,0,0,"C","","mv_par04","Sintético","","","","","Analitico"	,"","","","",""		,"","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"FATC07",	"05","Gera.Financ?"		,"Gera.Financ?"  	,"Gera.Financ?"		,"mv_ch5","N",1,0,0,"C","","mv_par05","Sim"      ,"","","","","Não"      	,"","","","","Ambos","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{"FATC07",	"06","Mov.Estoque?"		,"Mov.Estoque?"  	,"Mov.Estoque?"  	,"mv_ch6","N",1,0,0,"C","","mv_par06","Sim"      ,"","","","","Não"      	,"","","","","Ambos","","","","","","","","","","","","","","","","","",""})

lValidPerg(aRegs)

If (!lJob .And. Pergunte(cPerg,.T.)) .Or. LoadVar()
	//Indica a data a ser utilizada
	If MV_Par01 == 1
		cCampo := "SC5.C5_EMISSAO"
	Else
		cCampo := "SC6.C6_ENTREG"
	EndIf
	
	//Indica as movimentacoes de financeiro
	If mv_par05 == 1
		cEst := "S"
	ElseIf mv_par05 == 2
		cEst := "N"
	EndIf
	
	//Indica as movimentacoes de estoque
	If mv_par06 == 1
		cFin := "S"
	ElseIf mv_par06 == 2
		cFin := "S"
	EndIf
	         
	//mv_par02 := 01/11/2011   
	//mv_par03 := 10/11/2011
	cMesAux  := aMeses[Month(dDataBase)]
	cAnoAux  := StrZero(Year(dDataBase), 4)
	cDataAux := DtoC(dDataBase)
	cHoraAux := Time()
    

 

	// Atual Venc
	cQuery := "SELECT 	SUM(ISNULL(CAST((CASE WHEN SC6.C6_ENTREG <= '" + DtoS(LastDay(dDataBase)) + "' "
	cQuery += "          	                  THEN ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)), 0) END) AS NUMERIC (10,2)), 0)) RESULT "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE " + cCampo + " >= '" + DtoS(MV_Par02) + "' AND " + cCampo + " <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <>  'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	cQuery += "     AND SC6.C6_ENTREG <= '"+DtoS(dDataBase)+"'"
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_01a.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	nTotalAtual:= TRB->Result

	// Atual Nao Venc.
	cQuery := "SELECT 	SUM(ISNULL(CAST((CASE WHEN SC6.C6_ENTREG <= '" + DtoS(LastDay(dDataBase)) + "' "
	cQuery += "          	                  THEN ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)), 0) END) AS NUMERIC (10,2)), 0)) RESULT "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE " + cCampo + " >= '" + DtoS(MV_Par02) + "' AND " + cCampo + " <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <>  'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	cQuery += "     AND SC6.C6_ENTREG > '"+DtoS(dDataBase)+"' "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_01b.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	nTotNAtual:= TRB->Result
	nTotVAtual:= nTotalAtual+nTotNAtual

	// Futuro
	cQuery := "SELECT 	SUM(ISNULL(CAST((CASE WHEN SC6.C6_ENTREG > '" + DtoS(LastDay(dDataBase)) + "' "
	cQuery += "         	                  THEN ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)), 0) END) AS NUMERIC (10,2)), 0)) RESULT "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <> 'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_02.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
    nTotalFut:= TRB->Result
	
	// Total
	cQuery := "SELECT 	SUM(CAST(SC6.C6_PRCVEN * SC6.C6_QTDVEN AS NUMERIC (10,2))) RESULT "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <>  'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_03.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	nTotValor:= TRB->Result
	
	// Qtd Pedidos Atual
	cQuery := "SELECT COUNT(*) RESULT "
	cQuery += "FROM   ( "
	cQuery += "SELECT 	DISTINCT SC5.C5_NUM, SC6.C6_ENTREG "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <> 'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "     AND SC6.C6_ENTREG <= '" + DtoS(LastDay(dDataBase)) + "') AGRUPA "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_04.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	nQtPdAtual:= TRB->Result
	
	// Qtd Pedidos Futuro
	cQuery := "SELECT COUNT(*) RESULT "
	cQuery += "FROM   ( "
	cQuery += "SELECT 	DISTINCT SC5.C5_NUM, SC6.C6_ENTREG "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
    cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <>  'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "     AND SC6.C6_ENTREG > '" + DtoS(LastDay(dDataBase)) + "') AGRUPA "
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_05.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	nQtPdFut:= TRB->Result
	
	// Qtd Pedidos Total
	cQuery := "SELECT COUNT(*) RESULT "
	cQuery += "FROM   ( "
	cQuery += "SELECT 	DISTINCT SC5.C5_NUM, SC6.C6_ENTREG "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <>  'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ') AGRUPA "
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_06.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

	nTotQt   := TRB->Result	
	nMedAtual:= (nTotalAtual+nTotNAtual)/nQtPdAtual
	nMedFut  := nTotalFut/nQtPdFut
	nTotMed  := nTotValor/nTotQt
	cEmissao := DtoC(dDataBase)
	cGeraFat := cFin
	
	// Listagem
	cQuery := "SELECT 	SC5.C5_FILIAL + ' - ' + SC5.C5_NUM + ' - ' + SC5.C5_CLIENTE + '-' + SUBSTRING(SA1.A1_NREDUZ,1,15) LOCAL_PEDIDO_CLIENTE,  "
	cQuery += "         SC5.C5_CONDPAG + ' ' + SE4.E4_DESCRI COND_PAGTO, SC6.C6_ENTREG PREV_FAT, SC5.C5_VEND1 + ' ' + SA3.A3_NREDUZ REPRES, "
	cQuery += "     	SUM(ISNULL(CAST((CASE WHEN SC6.C6_ENTREG <= '" + DtoS(LastDay(dDataBase)) + "' "
	cQuery += "         	                  THEN ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)), 0) END) AS NUMERIC (10,2)), 0)) ATUAL, "
	cQuery += "     	SUM(ISNULL(CAST((CASE WHEN SC6.C6_ENTREG > '" + DtoS(LastDay(dDataBase)) + "' "
	cQuery += "         	                  THEN ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)), 0) END) AS NUMERIC (10,2)), 0)) FUTURO, "
	cQuery += "     	SUM(ISNULL(CAST((SC6.C6_PRCVEN * SC6.C6_QTDVEN) AS NUMERIC (10,2)),0)) TOTAL_GLOBAL, "
	cQuery += "     	SUM(ISNULL(CAST((SC6.C6_VALDESC) AS NUMERIC (10,2)),0)) TOTAL_BRUTO "
	cQuery += "FROM 	SC5010 SC5 "
	cQuery += "RIGHT JOIN SA3010 SA3 ON SA3.A3_COD = SC5.C5_VEND1 AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SA1010 SA1 ON SA1.A1_COD = SC5.C5_CLIENTE AND SA1.A1_LOJA = SC5.C5_LOJACLI AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN SE4010 SE4 ON SE4.E4_CODIGO = SC5.C5_CONDPAG AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "RIGHT JOIN ACY010 ACY ON ACY.ACY_GRPVEN = SA1.A1_GRPVEN AND ACY.D_E_L_E_T_ = ' ' ,SC6010 SC6 ,SF4010 SF4 "
	cQuery += "WHERE 	SC5.C5_EMISSAO >= '" + DtoS(MV_Par02) + "' AND SC5.C5_EMISSAO <= '" + DtoS(MV_Par03) + "' AND SC5.C5_TIPO = 'N' AND SC6.C6_FILIAL = SC5.C5_FILIAL "
   	cQuery += "     AND SC5.C5_CANCELA <> 'S' AND   SUBSTRING(SC5.C5_NOTA,1,6) <> 'XXXXXX' AND SC5.C5_SERIE <> 'XXX' "
	cQuery += "     AND SC6.C6_NUM = SC5.C5_NUM AND SC6.C6_CLI = SC5.C5_CLIENTE AND SC6.C6_LOJA = SC5.C5_LOJACLI AND SF4.F4_CODIGO = SC6.C6_TES "
	If !Empty(cEst)
		cQuery += "     AND SF4.F4_ESTOQUE = '" + cEst + "' "
	EndIf
	If !Empty(cFin)
		cQuery += "     AND SF4.F4_DUPLIC = '" + cFin + "' "
	EndIf
	cQuery += "     AND SF4.D_E_L_E_T_ = ' ' AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "GROUP BY SC5.C5_FILIAL, SC5.C5_NUM, SC5.C5_CLIENTE, SA1.A1_NREDUZ, SC5.C5_CONDPAG, SE4.E4_DESCRI, SC6.C6_ENTREG, SC5.C5_VEND1, SA3.A3_NREDUZ "
	cQuery += "ORDER BY TOTAL_GLOBAL DESC"
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf
	//MemoWrite("\QUERYSYS\GERAENTP_07.sql",cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
	
	TRB->(DbGoTop())
	While TRB->(!Eof())
		aAdd(aDadosAux, { AllTrim(TRB->Local_Pedido_Cliente)             ,;
						  AllTrim(TRB->Cond_Pagto)                       ,;
						  TRB->(DtoC(StoD(Prev_Fat)))                    ,;
						  AllTrim(TRB->Repres)                           ,;
						  Iif(TRB->(StoD(Prev_Fat))<=dDataBase, Atual, 0),; //vencidos
						  Iif(TRB->(StoD(Prev_Fat))<=dDataBase, 0, Atual),; //nao vencidos
						  TRB->Futuro                                    ,; 
						  TRB->Total_Global                              ,;
						  TRB->Total_Bruto       					     })
		TRB->(DbSkip())
	EndDo
	
	TRB->(DBClosearea())
EndIf

/*
If ExisteSX6("BR_000032")
	lTeste := GetMV("BR_000032")
Else
	lTeste := .f.
EndIf

//If lTeste
//	cEmail := "onsten@brascola.com.br"
//Else */
/*  
cEmail := "alfredo.mann@brascola.com.br; "
cEmail += "daniel.prado@brascola.com.br; "
cEmail += "gunther.faltin@brascola.com.br; "
cEmail += "marcelo.pintarelli@brascola.com.br; "
cEmail += "paulo.fontanezi@brascola.com.br; rodrigo.andrade@brascola.com.br; "
cEmail += "ronaldo.lima@brascola.com.br; sidnei.almeida@brascola.com.br; "
cEmail += "vanderlei.madruga@brascola.com.br; adriana.quarck@brascola.com.br; fernando.leite@brascola.com.br; "
cEmail += "angela.fioravanti@brascola.com.br; antonio.adolar@brascola.com.br; ronaldo.silva@brascola.com.br; "
cEmail += "natalia.reinert@brascola.com.br; camila.maia@brascola.com.br; rodolfo.gaboardi@brascola.com.br "
*/  
//EndIf 
//cEmail := "rodolfo.gaboardi@brascola.com.br"
//cEmail := "thiago.moyses@brascola.com.br"

//cEmail  := ""   //Fernando
cTipMail:= "000005"

/*cQuery  := ""
cQuery  += "SELECT ZG.ZG_EMAIL "
cQuery  += "FROM "+RetSqlName("SZI")+" ZI (NOLOCK), "
cQuery  +=         RetSqlName("SZG")+" ZG (NOLOCK) "
cQuery  += "WHERE ZI.ZI_FILIAL = '"+xFilial("SZI")+"' AND ZI.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZI.ZI_TIPO = '"+cTipMail+"' AND ZI.ZI_RESPONS = ZG.ZG_CODIGO "
cQuery  += "  AND ZG.ZG_FILIAL = '"+xFilial("SZG")+"' AND ZG.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZG.ZG_ATIVO = 'S' "
cQuery  := ChangeQuery(cQuery)
TCQuery cQuery NEW ALIAS "SZGS" 

dbSelectArea("SZGS")
dbGoTop()
While !EOF()
	cEmail += Alltrim(SZGS->ZG_EMAIL)+";"
	dbSkip()
Enddo
cEmail:= SubStr(cEmail,1,Len(cEmail)-1) //tira o ultimo ';' 

dbSelectArea("SZGS")
dbCloseArea()*/

 //Fernando 
//cEmail:= "alfredo.mann@brascola.com.br;glandarini@brascola.com.br;angela.fioravanti@brascola.com.br;rerpen@brascola.com.br;da"
//cEmail+= "charlesm@brascola.com.br;fernando.maia@brascola.com.br" 


EnvMailPed(cEmail,aDadosAux)

Return(.T.)



Static Function EnvMailPed(cEmailAx, aDadosAx)
**************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""

/*
25                                         13                    6         13                    7            9             9                     9        9
LOCAL-PEDIDO-CLIENTE                       COND.PAGTO            PREV.FAT  REPRESENTANTE         DESC.MEDIO   ATUAL VENC.   ATUAL N.VENC.         FUTURO   TOTAL GLOBAL
XX - 999999 - 999999-XXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXX  99/99/99  XXXXXXXXXXXXXXXXXXXX  999999.99%  99,999,999.99  99,999,999.99  99,999,999.99  99,999,999.99
                                         123456789*123456789*12          123456789*123456789*12            123456789*12345               123456789*12345
123456789*123456789*123456789*123456789*1                      123456789*                      123456789*12               123456789*12345               123456789*12345
123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*1234567 167
*/

_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"                                                                                                                                                              
_cBody += "<head>"                                                                                                                                                              
_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
_cBody += "</head>"                                                                                                                                                             
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='3'><b>Entrada Diária de Pedidos - "+AllTrim(cMesAux)+" de "+cAnoAux+"</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='1'><b>Atualizado em "+cDataAux+" às "+SubStr(cHoraAux,1,5)+"hs, com referência ao dia "+DtoC(DataValida(CtoD(cDataAux)-1))+".</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='1'>** RELATÓRIO GERADO AUTOMATICAMENTE PELO PROTHEUS **</font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'>Emissão: "+cEmissao+"   -   Gera Fat.?: "+cGeraFat+" </font></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
// 1a tabela
_cBody += "<table border='2' cellspacing='1' width='60%'>"                                                                                                                     
_cBody += "  <TBODY>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font face='Tahoma' size='2'><b>Entrega p/ o mês ></font></b></td>"
_cBody += "      <td width='15%' align='center' bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Atual</font></b></td>"
_cBody += "      <td width='15%' align='center' bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Futuro</font></b></td>"
_cBody += "      <td width='15%' align='center' bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Total</font></b></td>"
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  </tbody>"                                                                                                                                                           
_cBody += "  <tbody>"
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'><b>Valor ></font></b></td>"                                                                             
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nTotVAtual,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nTotalFut ,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nTotValor,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  </tbody>"
_cBody += "  <tbody>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'><b>Quant.de Ped. ></font></b></td>"
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nQtPdAtual,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nQtPdFut  ,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nTotQt    ,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  </tbody>"
_cBody += "  <tbody>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'><b>Valor Médio ></font></b></td>"
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nMedAtual,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nMedfut  ,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "      <td width='15%' align='right'  bgcolor='#ffffff'><font size='2' face='Tahoma'>"+Transform(nTotMed  ,"@E 99,999,999.99")+"</font></td>"                                                                              
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  </tbody>"
_cBody += "</table>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
// 2a Tabela(lista)
_cBody += "<table border='1' cellspacing='1' width='100%'>"                                                                                                                     
_cBody += "  <TBODY>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='22%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Local - Pedido - Cliente</font></b></td>"
_cBody += "      <td width='16%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Cond.Pagto</font></b></td>"
_cBody += "      <td width='06%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Prev.Fat.</font></b></td>"
_cBody += "      <td width='13%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Representante</font></b></td>"
_cBody += "      <td width='07%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Desc.Medio</font></b></td>"
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Imediato</font></b></td>"
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Progr.</font></b></td>"
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Futuro</font></b></td>"
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Total Global</font></b></td>"
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  <tbody>"                                                                                                                                                           

cBgColor:= "#ffffff" //=branco  #ffffcc =amarelo claro 

For nI:= 1 to Len(aDadosAx)
	nDescMedio:= ((aDadosAx[nI][9]/(aDadosAx[nI][8]+aDadosAx[nI][9]))*100)

	_cBody += "    <tr>"                                                                                                                                                            
	_cBody += "      <td width='22%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][1]+"</font></td>"                                                                             
	_cBody += "      <td width='16%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][2]+"</font></td>"                                                                              
	_cBody += "      <td width='06%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][3]+"</font></td>"                                                                              
	_cBody += "      <td width='13%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][4]+"</font></td>"                                                                              
	_cBody += "      <td width='07%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(nDescMedio,"@R 999999.99%"))+"</font></td>"                                                                              
	_cBody += "      <td width='09%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][5],"@E 99,999,999.99"))+"</font></td>"                                                                              
	_cBody += "      <td width='09%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][6],"@E 99,999,999.99"))+"</font></td>"                                                                             
	_cBody += "      <td width='09%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][7],"@E 99,999,999.99"))+"</font></td>"         
	_cBody += "      <td width='09%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][8],"@E 99,999,999.99"))+"</font></td>"         
	_cBody += "    </tr>"                                                                                                                                                           
Next

_cBody += "  </tbody>"
_cBody += "  <tbody>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='22%' align='left'   bgcolor='#cccccc'><b><font size='1' face='Tahoma'>TOTAL GLOBAL</font></b></td>"
_cBody += "      <td width='16%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='06%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='13%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='07%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='09%' align='right'  bgcolor='#cccccc'><b><font size='1' face='Tahoma'>"+Alltrim(Transform(nTotalAtual,"@E 99,999,999.99"))+"</font></b></td>"
_cBody += "      <td width='09%' align='right'  bgcolor='#cccccc'><b><font size='1' face='Tahoma'>"+Alltrim(Transform(nTotNAtual ,"@E 99,999,999.99"))+"</font></b></td>"
_cBody += "      <td width='09%' align='right'  bgcolor='#cccccc'><b><font size='1' face='Tahoma'>"+Alltrim(Transform(nTotalFut  ,"@E 99,999,999.99"))+"</font></b></td>"
_cBody += "      <td width='09%' align='right'  bgcolor='#cccccc'><b><font size='1' face='Tahoma'>"+Alltrim(Transform(nTotValor  ,"@E 99,999,999.99"))+"</font></b></td>"
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  </tbody>"
_cBody += "</table>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "</html>"

cAssunto:= "Planilha Entrada de Pedidos - " + DtoC(dDatabase)

//Envio do email
U_SendMail(cEmailAx,cAssunto,_cBody,"",.f.)

Return


Static Function LoadVar()
*************************
MV_Par01 := 1
//IF MONTH(DataValida(dDataBase, .f.)) <> MONTH(DDATABASE)
IF MONTH(DataValida(dDataBase - 1, .f.)) <> MONTH(DDATABASE)
   MV_Par02 := dDataBase 
   MV_Par03 := dDataBase 
ELSE
   //MV_Par02 := DataValida(dDataBase, .f.)
   //MV_Par03 := DataValida(dDataBase, .f.)
   MV_Par02 := DataValida(dDataBase - 1, .f.)
   MV_Par03 := DataValida(dDataBase - 1, .f.)
ENDIF


MV_Par04 := 1
MV_Par05 := 1
MV_Par06 := 1

Return .t.