#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTA03   �Autor  �Daniel Pelegrinelli � Data �  11/29/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao de registros no SB7 automaticamente.               ���
���          � Rotina de Ficha de Inventario                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RESTA03()

//������������������

//�Define variaveis�
//������������������
Private cPerg    := U_CriaPerg("ESTA03")
Private aRegs    := {}
Private oInvent             
Private cEOL     := Chr(13)+Chr(10)

//��������������������Ŀ
//�Carrega as perguntas�
//����������������������
Aadd(aRegs,{cPerg,"01","Data Base ?"            ,"Data Base"        ,"Data Base"        ,"mv_ch1","D",8 ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Tipo de Ficha ?"        ,"Tipo de Ficha"       ,"Tipo de Ficha"      ,"mv_ch2","N",1,0,1,"C","","mv_par02","Fichas de Saldos","Fichas de Saldos","Fichas de Saldos","","","Ficha em Branco","Ficha em Branco","Ficha em Branco","","","","","","","","","","","","","","","","","","S","","",""})
Aadd(aRegs,{cPerg,"03","Quantas Fichas ?"       ,"Quantas Fichas ?","Quantas Fichas ?"      ,"mv_ch3","N",5,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Tipo de Saldo ?"        ,"Tipo de Saldo","Tipo de Saldo"      ,"mv_ch4","N",1,0,1,"C","","mv_par04","Apenas com Saldo","Apenas com Saldo","Apenas com Saldo","","","Todos","Todos","Todos","","","","","","","","","","","","","","","","","","S","","",""})
Aadd(aRegs,{cPerg,"05","Local a Desconsiderar ?","Local a Desconsiderar","Local a Desconsiderar","mv_ch5","C",50,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
Aadd(aRegs,{cPerg,"06","Local a Considerar ?   ","Local a Considerar ? ","Local a Considerar ? ","mv_ch6","C",50,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

lValidPerg(aRegs)
Pergunte(cPerg,.T.)

//����������������������Ŀ
//�Monta a tela principal�
//������������������������
@ 200,1 to 380,380 Dialog oInvent Title OemToAnsi("Gera��o de Ficha de Inventario")
@ 02,10 to 060,180
@ 10,018 Say OemToAnsi(" Este programa ir� gerar fichas para o inventario de acordo    ")
@ 18,018 Say OemToAnsi(" com o saldo atual de cada produto e cada lote.                ")

@ 72,085 BmpButton Type 01 Action RESTA031()
@ 72,115 BmpButton TYPE 02 Action Close(oInvent)
@ 72,145 BmpButton TYPE 05 Action Pergunte(cPerg,.T.)

Activate Dialog oInvent Centered

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTA031 �Autor  � Octavio Moreira    � Data �  05/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de inicializacao do processamento                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RESTA031()

//��������������������������Ŀ
//�Define variaveis da funcao�
//����������������������������
Local cQuery := "", lProcGer := .t.
Private cProxFicha 

//������������������������������������������������������������������������Ŀ
//�Verifica se ha fichas geradas na data ou proxima ficha para as em branco�
//��������������������������������������������������������������������������
cQuery += "SELECT ISNULL(MAX(B7_DOC),'000000000') MAXFICHA"+cEOL
cQuery += "FROM "+RetSQLName("SB7")+cEOL
cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
cQuery += "      AND B7_DATA = '"+Dtos(mv_par01)+"'"+cEOL
cQuery += "      AND D_E_L_E_T_ <> '*'"+cEOL

//�����������������������Ŀ
//�Abre resultado de query�
//�������������������������
If Select("SB7DOC") > 0
	DbSelectArea("SB7DOC")
	DbCloseArea()
Endif               

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SB7DOC',.F.,.T.)

DbSelectArea("SB7DOC")
DbGoTop()

//������������������������������������Ŀ
//�Verifica se ha itens sem apontamento�
//��������������������������������������
cProxFicha := Soma1(MAXFICHA)

//����������������������Ŀ
//�Fecha arquivo da query�
//������������������������
If Select("SB7DOC") > 0
	DbSelectArea("SB7DOC")
	DbCloseArea()
Endif

//����������������������������������Ŀ
//�Gera fichas por saldo ou em branco�
//������������������������������������
IF mv_par02 == 1

	//�����������������������������������������������������������������
	//�Verifica se ha a necessidade de excluir as fichas ja existentes�
	//�����������������������������������������������������������������
	If cProxFicha <> "000000001"
	   lProcGer := MsgYesNo("Ha fichas geradas. Podem ser excluidas ?")
	   
	   If lProcGer
			cQuery += "DELETE FROM "+RetSQLName("SB7")+cEOL
			cQuery += "WHERE B7_FILIAL = '"+xFilial("SB7")+"'"+cEOL
			cQuery += "      AND B7_DATA = '"+Dtos(mv_par01)+"'"+cEOL
			cQuery += "      AND D_E_L_E_T_ <> '*'"+cEOL

			//�����������������������Ŀ
			//�Abre resultado de query�
			//�������������������������
			If Select("SB7DEL") > 0
				DbSelectArea("SB7DEL")
				DbCloseArea()
			Endif               

			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SB7DEL',.F.,.T.)

			//����������������������Ŀ
			//�Fecha arquivo da query�
			//������������������������
			If Select("SB7DEL") > 0
				DbSelectArea("SB7DEL")
				DbCloseArea()
			Endif
			
			cProxFicha := "000000001"
		Else
          lProcGer := MsgYesNo("Podem ser acrescentadas novas fichas ?")
	   EndIf
	EndIf
	
	If lProcGer
		MsgRun("Gerando Fichas por Saldo de Estoque","Processando",{ || U_RESTA032()})
	EndIf
Else
	MsgRun("Gerando Fichas em Branco","Processando",{ || U_RESTA033()})
Endif

//�������������������������������������������������������
//�Avisa sobre o termindo o processamento e fecha a tela�
//�������������������������������������������������������
Alert("Fim do Processo")

Close(oInvent)

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � RESTA032 �Autor  �Daniel Pelegrinelli � Data �  11/29/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao de registros no SB7 automaticamente.               ���
���          � Rotina de Ficha de Inventario                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RESTA032()

//��������������������Ŀ
//�Inicializa variaveis�
//����������������������
Local cQryB8, cQryB2, dData, cCond, nCont := 3, i
Local cLoc := FormatIn(AllTrim(mv_par05),"/")
Local cLoc1 := FormatIn(AllTrim(mv_par06),"/")
LOCAL ctipo := FormatIn(AllTrim(mv_par07),"/")
//��������������������������������������Ŀ
//�Inclusao dos Registros no arquivo SB7 �
//�por saldo por Lote SB8                �
//����������������������������������������
cQryB8 := " SELECT B1_COD COD, B1_TIPO TIPO, B8_LOCAL ARM, SUM(B8_SALDO) SALDO,"+cEOL
cQryB8 += "        B8_LOTECTL LOTECTL, MAX(B8_DTVALID) DTVALID "+cEOL
cQryB8 += " FROM "+RetSQLName("SB1")+" SB1,"+RetSQLName("SB8")+" SB8 "+cEOL
cQryB8 += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+cEOL
cQryB8 += "       AND B1_COD = B8_PRODUTO "+cEOL
cQryB8 += "       AND B1_RASTRO <> 'N' "+cEOL
//cQryB8 += "       AND B1_MSBLQL = '1' "+cEOL
cQryB8 += "       AND SB1.D_E_L_E_T_ <> '*' "+cEOL
cQryB8 += "       AND B8_FILIAL = '"+xFilial("SB8")+"' "+cEOL
cQryB8 += If(mv_par04 == 1," AND B8_SALDO <> 0   "+cEOL,"")
cQryB8 += "       AND B8_LOCAL NOT IN "+cLoc+" "+cEOL
cQryB8 += "       AND B1_TIPO  IN "+ctipo+"  "+cEOL

If !Empty(mv_par06)
	cQryB8 += "       AND B8_LOCAL IN "+cLoc1+" "+cEOL
EndIf
cQryB8 += "       AND SB8.D_E_L_E_T_ <> '*' "+cEOL
cQryB8 += " GROUP BY B1_COD,B1_TIPO,B8_LOCAL,B8_LOTECTL "+cEOL
cQryB8 += " ORDER BY B1_COD "+cEOL

//MemoWrite("\QUERYSYS\RESTA03.SQL",cQryB8)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryB8),'TMP',.F.,.T.)

dbSelectArea("TMP")
dbGotop()

//������������������������������������Ŀ
//�Inicia a geracao de registros no SB7�
//��������������������������������������
Do While !Eof()
	
	//���������������������������������Ŀ
	//�Loop para gerar as tres contagens�
	//�����������������������������������
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
			MsUnlock()
  //		Endif
	Next

	//����������������������������Ŀ
	//�Incrementa o numero da ficha�
	//������������������������������
	cProxFicha := Soma1(cProxFicha)
		
	//�����������������������������������Ŀ
	//�Vai para o proximo registro de lote�
	//�������������������������������������
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

DbSelectArea("TMP")
TMP->(DbCloseArea())

//�������������������������������������������
//�Inclusao dos registros do Inventario SB7 �
//�pelo saldo atual (registros sem lote) SB2�
//�������������������������������������������
cQryB2:= " SELECT B1_COD COD, B1_TIPO TIPO, B2_LOCAL ARM, B2_QATU SALDO "+cEOL
cQryB2+= " FROM "+RETSQLNAME("SB1")+" SB1,"+RETSQLNAME("SB2")+" SB2 "+cEOL
cQryB2+= " WHERE B1_FILIAL = '"+xFilial("SB1")+"' "+cEOL
cQryB2+= "       AND B1_RASTRO = 'N' "+cEOL
//cQryB2+= " 	     AND B1_MSBLQL <> '1' "+cEOL
cQryB2+= " 	     AND SB1.D_E_L_E_T_ <> '*' "+cEOL
cQryB2+= "       AND B2_FILIAL = '"+xFilial("SB2")+"' "+cEOL
cQryB2+= "       AND B2_COD = B1_COD "+cEOL
cQryB2+= If(mv_par04 == 1,"AND B2_QATU <> 0 "+cEOL,"")
cQryB2+= "       AND B1_TIPO  IN "+ctipo+"  "+cEOL
cQryB2+= "       AND B2_LOCAL NOT IN "+cLoc+" "+cEOL
If !Empty(mv_par06)
	cQryB2 += "       AND B2_LOCAL IN "+cLoc1+" "+cEOL
EndIf
cQryB2+= " 	     AND SB2.D_E_L_E_T_ <> '*' "+cEOL
cQryB2+= " ORDER BY B1_COD "+cEOL

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQryB2),'TMP',.F.,.T.)

dbSelectArea("TMP")
dbGotop()

//������������������������������������Ŀ
//�Inicia a geracao de registros no SB7�
//��������������������������������������
Do While !Eof()
	
	For i:= 1 to nCont
		dbSelectArea("SB7")
		
		Reclock("SB7",.T.)
		B7_FILIAL  := xFilial("SB7")
		B7_COD     := TMP->COD
		B7_TIPO    := TMP->TIPO
		B7_DOC     := cProxFicha
		B7_LOCAL   := TMP->ARM
		B7_QUANT   := 0
		B7_QTSEGUM := 0
		B7_DATA    := mv_par01
		B7_LOTECTL := " "
		B7_DTVALID := CtoD(" /  /  ")
		B7_CONTAGE := STRZERO(i,3)
		B7_X_TPFC  := "N"
		MsUnlock()

	Next 			

	//����������������������������Ŀ
	//�Incrementa o numero da ficha�
	//������������������������������
	cProxFicha := Soma1(cProxFicha)

	//�����������������������������������Ŀ
	//�Vai para o proximo registro de lote�
	//�������������������������������������
	dbSelectArea("TMP")
	dbSkip()
	
EndDo

DbSelectArea("TMP")
TMP->(DbCloseArea())

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RESTR033  �Autor  �Microsiga           � Data �  11/29/05   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Criar Fichas em Branco                                    ���
�������������������������������������������������������������������������͹��
���Uso       � MP8                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RESTA033

//��������������������������Ŀ
//�Define variaveis da funcao�
//����������������������������
Local nCount, nCont := 3

//������������������������������Ŀ
//�Inicia a geracao das etiquetas�
//��������������������������������
For nCount := 1 to mv_par03	
	
	//�����������������������������������Ŀ
	//�Gera as tres contagens para a ficha�
	//�������������������������������������
	For i:= 1 to nCont
		dbSelectArea("SB7")
		
		Reclock("SB7",.t.)
		B7_FILIAL  := xFilial("SB7")
		B7_COD     := " "
		B7_TIPO    := " "
		B7_DOC     := cProxFicha
		B7_LOCAL   := " "
		B7_QUANT   := 0
		B7_QTSEGUM := 0
		B7_DATA    := mv_par01
		B7_LOTECTL := " "
		B7_DTVALID := Ctod(" /  /  ")
		B7_CONTAGE := STRZERO(i,3)
		B7_X_TPFC  := "B"
		MsUnlock()

	Next

	//����������������������������Ŀ
	//�Incrementa o numero da ficha�
	//������������������������������
	cProxFicha := Soma1(cProxFicha)

Next

Return()
