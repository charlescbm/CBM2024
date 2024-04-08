#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "RWMAKE.CH"

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Rdmake    � BGPEG001  � Autor �                       � Data � 04/07/13 ���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Retorna descri��o da Justificativa de Desligamento          ���
��������������������������������������������������������������������������Ĵ��
���Observacao�                                                             ���
��������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                         ���
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function BGPEG001(cCodFil,cCodMat)
***************************************
LOCAL cQuery:= ""  
LOCAL cJust := ""
LOCAL aSeg1 := GetArea()

If Type("INCLUI")!="U" .And. (!INCLUI) .And. (SRA->RA_SITFOLH == "D")
	cQuery += "SELECT RG_TIPORES FROM SRG010 RG "
	cQuery += "WHERE RG.D_E_L_E_T_ <> '*' "
	cQuery += "AND RG_FILIAL = '"+xFilial("SRG")+"' "
	cQuery += "AND RG_RESCDIS NOT IN ('1','2') "
	cQuery += "AND RG_MAT = '"+cCodMat+"'"
	If (Select("QUERY") <> 0)
		dbSelectArea("QUERY")
		dbCloseArea()
	Endif
	dbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), "QUERY", .T., .F. ) 
	If !QUERY->(Eof())
		cJust := Substr(fDesc("SRX","32"+QUERY->RG_TIPORES,"RX_TXT",,cCodFil),1,30)
	Endif
	If (Select("QUERY") <> 0)
		dbSelectArea("QUERY")
		dbCloseArea()
	Endif
	RestArea(aSeg1)
Endif

Return(cJust)




