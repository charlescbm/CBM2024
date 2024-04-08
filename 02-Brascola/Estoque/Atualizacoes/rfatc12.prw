#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATC12  � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Consulta de lancamentos por CCusto                            ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function RFATC12()

MSGRUN("Aguarde....","Processando",{ || RFATC121()})

Return(.T.)	

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATC121 � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o �                                                               ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static Function RFATC121()

Local cQuery := ""
Local aRegs  := {}
Local cPerg  := U_CriaPerg("FATC12")
Local cAlias := "TRB"

aAdd(aRegs,{cPerg,"01","Data Inicial?","Dt Inicio  ?","Dt Inicio  ?","mv_ch1","D",08,0,0,"G","","MV_PAR01",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
aAdd(aRegs,{cPerg,"02","Data Final  ?","Dt Final   ?","Dt Final   ?","mv_ch2","D",08,0,0,"G","","MV_PAR02",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
aAdd(aRegs,{cPerg,"03","Conta de    ?","Conta de   ?","Conta de   ?","mv_ch3","C",20,0,0,"G","","MV_PAR03",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","CT1"	,"","","",""})
aAdd(aRegs,{cPerg,"04","Conta at�   ?","Conta at�  ?","Conta at�  ?","mv_ch4","C",20,0,0,"G","","MV_PAR04",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","CT1"	,"","","",""})
aAdd(aRegs,{cPerg,"05","C.Custo de  ?","C.Custo de ?","C.Custo de ?","mv_ch5","C",09,0,0,"G","","MV_PAR05",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","CTT"	,"","","",""})
aAdd(aRegs,{cPerg,"06","C.Custo at� ?","C.Custo at�?","C.Custo at�?","mv_ch6","C",09,0,0,"G","","MV_PAR06",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","CTT"	,"","","",""})
aAdd(aRegs,{cPerg,"07","Exibe Dados ?","Exibe Dados?","Exibe Dados?","mv_ch7","N",01,0,0,"C","","MV_PAR07","Analitico"	,"","","","","Sintetico"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
aAdd(aRegs,{cPerg,"08","Tp.de Saldo ?","Tp.de Saldo?","Tp.de Saldo?","mv_ch8","C",01,0,0,"G","","MV_PAR08",""					,"","","","",""				,"","","","","","","","","","","","","","","","","","","SLW"	,"","","",""})

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
   Return
EndIf
        
//���������������������������������������������Ŀ
//�Caso a opcao seja selecionar dados sinteticos�
//�����������������������������������������������
If mv_par07 == 2
	cQuery += " SELECT DATA1, CONTA, DESCCONTA, CUSTO, DESCCUSTO, SUM(VALOR) VALOR FROM (	" 
EndIf

cQuery += " SELECT	SUBSTRING(CT2_DATA,1,6) DATA1, "
cQuery += " 			CT2_CREDIT 					CONTA, "
cQuery += " 			CT1_DESC01					DESCCONTA, "
cQuery += " 			ISNULL(CT2_CCC,'')		CUSTO, "
cQuery += " 			ISNULL(CTT_DESC01,'')	DESCCUSTO, "
cQuery += " 			CAST(SUM(CT2_VALOR) AS NUMERIC(20,2)) VALOR "
cQuery += " FROM "+ RetSQLName("CT1") + " CT1, "+RetSQLName("CT2") + " CT2 LEFT JOIN "  + RetSQLName("CTT")
cQuery += " ON CTT_CUSTO = CT2_CCC AND CTT010.D_E_L_E_T_ = ' ' "
cQuery += " WHERE			"
cQuery += "     CT2_DATA 		>= '" + dtos(mv_par01) + "'"
cQuery += " AND CT2_DATA  		<= '" + dtos(mv_par02) + "'"
cQuery += " AND CT2_CREDIT 	>= '" + mv_par03 + "'"
cQuery += " AND CT2_CREDIT 	<= '" + mv_par04 + "'"
cQuery += " AND CT2_CCC			>= '" + mv_par05 + "'"
cQuery += " AND CT2_CCC			<= '" + mv_par06 + "'"
cQuery += " AND CT2.D_E_L_E_T_ = ' '			"     
cQuery += " AND CT2_TPSALD    = '"  + MV_PAR08 + "'" 
cQuery += " AND CT1_CONTA 	 	 = CT2_CREDIT 
cQuery += " AND CT1.D_E_L_E_T_ = ' '
cQuery += " GROUP BY SUBSTRING(CT2_DATA,1,6), CT2_CREDIT, CT2_CCC, CT1_DESC01, CTT_DESC01 		
cQuery += " UNION ALL 			
cQuery += " SELECT 	SUBSTRING(CT2_DATA,1,6)	DATA1, 	
cQuery += " 			CT2_DEBITO 	  				CONTA, 
cQuery += " 			CT1_DESC01			  		DESCCONTA, 
cQuery += " 			ISNULL(CT2_CCD,'')		CUSTO, 
cQuery += "  			ISNULL(CTT_DESC01,'')	DESCCUSTO, 
cQuery += "  			CAST(-SUM(CT2_VALOR) AS NUMERIC(20,2)) VALOR 
cQuery += " FROM "+RetSQLName("CT1") + " CT1, "+RetSQLName("CT2") + " CT2 LEFT JOIN "+RetSQLName("CTT")
cQuery += " ON CTT_CUSTO = CT2_CCD AND CTT010.D_E_L_E_T_ = ' ' "
cQuery += " WHERE			
cQuery += "     CT2_DATA 		>= '" + dtos(mv_par01) + "'"
cQuery += " AND CT2_DATA 		<= '" + dtos(mv_par02) + "'"
cQuery += " AND CT2_DEBITO 	>= '" + mv_par03 + "'"
cQuery += " AND CT2_DEBITO 	<= '" + mv_par04 + "'"  
cQuery += " AND CT2_CCD			>= '" + mv_par05 + "'"
cQuery += " AND CT2_CCD			<= '" + mv_par06 + "'"
cQuery += " AND CT2_TPSALD    = '"  + MV_PAR08 + "'" 
cQuery += " AND CT2.D_E_L_E_T_ = ' '			
cQuery += " AND CT1_CONTA 	 	 = CT2_DEBITO 
cQuery += " AND CT1.D_E_L_E_T_ = ' '
cQuery += " GROUP BY SUBSTRING(CT2_DATA,1,6), CT2_DEBITO, CT2_CCD, CT1_DESC01, CTT_DESC01   

//���������������������������������������������Ŀ
//�Caso a opcao seja selecionar dados sinteticos�
//�����������������������������������������������
If mv_par07 == 2
	cQuery += " ) AGRUPA1 "
	cQuery += " GROUP BY DATA1, CONTA, DESCCONTA, CUSTO, DESCCUSTO "
	cQuery += " ORDER BY DATA1, CONTA, DESCCONTA, CUSTO, DESCCUSTO "
EndIf

cQuery := ChangeQuery(cQuery)
MemoWrite("\QUERYSYS\RFATC12.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

TCSetField('TRB', "VALOR"	, "N",16,2)
	
u_ProcExcel(cAlias)

TRB->(DBClosearea())

Return(.T.)             