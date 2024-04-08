#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRESTIZ   บAutor  ณRodolfo Gaboardi บ Data ณ  07/11/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao de registros no SB7 automaticamente.               บฑฑ
ฑฑบ          ณ Rotina de Ficha de Inventario                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RESTIZ()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ

//ณDefine variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPerg    := U_CriaPerg("ESTIZ")
Private aRegs    := {}
Private oInvent             
Private cEOL     := Chr(13)+Chr(10)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCarrega as perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Aadd(aRegs,{cPerg,"01","Data Base ?"            ,"Data Base"        ,"Data Base"        ,"mv_ch1","D",8 ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Local a Considerar ?   ","Local a Considerar ? ","Local a Considerar ? ","mv_ch6","C",50,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


lValidPerg(aRegs)
Pergunte(cPerg,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta a tela principalณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
@ 200,1 to 380,380 Dialog oInvent Title OemToAnsi("Gerao de Ficha de Inventario com Zero")
@ 02,10 to 060,180
@ 10,018 Say OemToAnsi(" Este programa irแ gerar fichas para o inventario de acordo    ")
@ 18,018 Say OemToAnsi(" com cada lote nao encontrado                ")

@ 72,085 BmpButton Type 01 Action RESTIZ31()
@ 72,115 BmpButton TYPE 02 Action Close(oInvent)
@ 72,145 BmpButton TYPE 05 Action Pergunte(cPerg,.T.)

Activate Dialog oInvent Centered

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RESTA031 บAutor  ณ Octavio Moreira    บ Data ณ  05/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de inicializacao do processamento                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RESTIZ31()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณDefine variaveis da funcaoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQuery := "", lProcGer := .t.
Private cProxFicha 


cDelSQL := "DELETE FROM "+RetSQLName("SB7")+cEOL
cDelSQL += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cDelSQL += "      AND B7_DATA = '"+Dtos(mv_par01)+"'"+cEOL
cDelSQL += "      AND D_E_L_E_T_ <> '*'"+cEOL
cDelSQL += "      AND B7_COD =  '    ' "+cEOL

TCSQLEXEC(cDelSQL)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre resultado de queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If Select("SB7DEL") > 0
//	DbSelectArea("SB7DEL")
//	DbCloseArea()
//Endif               

//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SB7DEL',.F.,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha arquivo da queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//If Select("SB7DEL") > 0
//	DbSelectArea("SB7DEL")
//	DbCloseArea()
//Endif
			



cProxFicha := "000000001"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ha fichas geradas na data ou proxima ficha para as em brancoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQuery += "SELECT ISNULL(MAX(B7_DOC),'000000000') MAXFICHA"+cEOL
cQuery += "FROM "+RetSQLName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "      AND B7_DATA = '"+Dtos(mv_par01)+"'"+cEOL
cQuery += "      AND D_E_L_E_T_ <> '*'"+cEOL

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAbre resultado de queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("SB7DOC") > 0
	DbSelectArea("SB7DOC")
	DbCloseArea()
Endif               

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SB7DOC',.F.,.T.)

DbSelectArea("SB7DOC")
DbGoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ha itens sem apontamentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cProxFicha := Soma1(MAXFICHA)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFecha arquivo da queryณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If Select("SB7DOC") > 0
	DbSelectArea("SB7DOC")
	DbCloseArea()
Endif

MsgRun("Gerando Fichas por Saldo de Estoque","Processando",{ || U_RESTIZ32()})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvisa sobre o termindo o processamento e fecha a telaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Alert("Fim do Processo")

Close(oInvent)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RESTA032 บAutor  ณDaniel Pelegrinelli บ Data ณ  11/29/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Criacao de registros no SB7 automaticamente.               บฑฑ
ฑฑบ          ณ Rotina de Ficha de Inventario                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RESTIZ32()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializa variaveisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQryB8, cQryB2, dData, cCond, nCont := 3, i
Local cLoc := FormatIn(AllTrim(mv_par02),"/")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInclusao dos Registros no arquivo SB7 ณ
//ณpor saldo por Lote SB8                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cQryB8 := " SELECT B1_COD COD, B1_TIPO TIPO, B8_LOCAL ARM, SUM(B8_SALDO) SALDO,"+cEOL
cQryB8 += "        B8_LOTECTL LOTECTL, MAX(B8_DTVALID) DTVALID "+cEOL
cQryB8 += " FROM "+RetSQLName("SB1")+" SB1,"+RetSQLName("SB8")+" SB8 "+cEOL
cQryB8 += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+cEOL
cQryB8 += "       AND B1_COD = B8_PRODUTO "+cEOL
cQryB8 += "       AND B1_RASTRO <> 'N' "+cEOL
//cQryB8 += "       AND B1_MSBLQL = '1' "+cEOL
cQryB8 += "       AND SB1.D_E_L_E_T_ <> '*' "+cEOL
cQryB8 += "       AND B8_FILIAL = '"+xFilial("SB8")+"' "+cEOL
cQryB8 += "       AND B8_SALDO <> 0   "+cEOL
cQryB8 += "       AND B8_LOCAL IN "+cLoc+" "+cEOL
cQryB8 += "       AND SB8.D_E_L_E_T_ <> '*' "+cEOL      
cQryB8 += "       AND SB8.B8_PRODUTO+SB8.B8_LOTECTL+SB8.B8_LOCAL NOT IN (SELECT B7_COD+B7_LOTECTL+B7_LOCAL FROM SB7010 ZZ WHERE ZZ.D_E_L_E_T_ <> '*' AND B7_CONTAGE = '001' AND B7_DATA = '"+Dtos(mv_par01)+"' )"
cQryB8 += " GROUP BY B1_COD,B1_TIPO,B8_LOCAL,B8_LOTECTL "+cEOL
cQryB8 += " ORDER BY B1_COD "+cEOL


If Select("TMP") > 0
	DbSelectArea("TMP")
	DbCloseArea()
Endif

//MemoWrite("\QUERYSYS\RESTA03.SQL",cQryB8)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryB8),'TMP',.F.,.T.)

dbSelectArea("TMP")
dbGotop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicia a geracao de registros no SB7ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Do While !Eof()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณLoop para gerar as tres contagensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For i:= 1 to nCont

		dbSelectArea("SB7")
      dbSetOrder(1) //B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE                                                                             
      //dbSeek(xFilial()+TMP->DTVALID+TMP->COD+TMP->ARM+SPACE(15)+SPACE(20)+TMP->LOTECTL)
//      If TMP->LOTECTL <> SB7->B7_LOTECTL .and. TMP->ARM <> SB7->B7_LOCAL 
			Reclock("SB7",.t.)
			B7_FILIAL  := xFilial("SB7")
			B7_COD     := TMP->COD
			B7_TIPO    := TMP->TIPO
			B7_DOC     := cProxFicha
			B7_LOCAL   := TMP->ARM
			B7_QUANT   := 0
			B7_QTSEGUM := 0
			B7_DATA    := mv_par01
			B7_LOTECTL := TMP->LOTECTL
			B7_DTVALID := StoD(TMP->DTVALID)
			B7_CONTAGE := STRZERO(i,3)
			B7_X_TPFC  := "L" 
			if i < 3
				B7_DTDIGIT := DDATABASE
			endif
			MsUnlock()
  //		Endif
	Next

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณIncrementa o numero da fichaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cProxFicha := Soma1(cProxFicha)
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVai para o proximo registro de loteณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("TMP")
	dbSkip()
	
EndDo
    
dbSelectArea("TMP")
DbCloseArea()
	
Return()

