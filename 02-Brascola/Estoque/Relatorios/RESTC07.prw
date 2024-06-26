#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"

#DEFINE  cEOL     CHR(13)+CHR(10)

/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � RESTC07  � Autor �                          � Data �   /  /   ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Grava custo medio  historico                            ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function RESTC07()

Local 	aRegs		:= {}
Local 	cPerg		:= U_CriaPerg("ESTC07")

aAdd(aRegs,{cPerg,"01","Data Fim Mes?"	 			,"","","mv_ch1","D",08,0,0,"G","","mv_par01",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aRegs,{cPerg,"02","Produto De ?"      			,"","","mv_ch2","C",15,0,0,"G","","mv_par02",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})
Aadd(aRegs,{cPerg,"03","Produto At�?"      			,"","","mv_ch3","C",15,0,0,"G","","mv_par03",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

MSGRUN("Aguarde....","Processando",{ || u_RESTC071()})

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
User Function RESTC071(aPar)

Local cQuery		:= ""
Local cAlias		:= "TRB"
Local cTipos		:= ""

//Valor de custo retornado por esta funcao quando for utilizada por um
//programa que aproveita este codigo
Local nRet  		:= 0

DDATAA:=(MV_PAR01)

nMFF:=   StrZero(Year(GETMV("MV_ULMES")),4)+StrZero(MONTH(GETMV("MV_ULMES")),2) 
NMES:=   StrZero(Year(DDATAA), 4)+StrZero(MontH(DDATAA), 2)

cMF :=  StrZero(MONTH(GETMV("MV_ULMES")),2)
cMes := StrZero(MONTH(DDATAA),2)
cCampo1 := "B3_CMD&cMes
cCampo2 := "B3_STD&cMes

_nValor := 0

_nValor1 := 0
//���������������������������������������������
//�Selecao de itens do mercado INTERNO somente�
//���������������������������������������������
cQuery := " SELECT B3_FILIAL,B3_COD "
cQuery += " FROM "+RetSQLName("SB3")+" SB3"
cQuery += " where SB3.D_E_L_E_T_ <> '*'"
cQuery += " AND B3_COD >= '"+mv_par02+"'" "
cQuery += " AND B3_COD <= '"+mv_par03+"'" "
cQuery += " ORDER BY B3_FILIAL,B3_COD"


If Select("TRB")>0
	dbSelectArea("TRB")
	TRB->(dbCloseArea("TRB"))
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)

DBSELECTAREA("TRB")
DBGOTOP()

WHILE TRB->(!EOF())
	_nValor := 0
	_nValor1 := 0
	
	SB1->(DBSEEK(XFILIAL("SB1")+TRB->B3_COD))
	_CLOCAL:=SB1->B1_LOCPAD
	   
	IF MV_PAR04 ==1 .OR. MV_PAR04 == 3
		
	    IF 	NMES > nMFF
		//IF cMes > cMF 
			
			dbselectarea("SB2")
			DBSETORDER(1)
			IF DBSEEK(TRB->B3_FILIAL+TRB->B3_COD+_CLOCAL)
				If SB2->(B2_QFIM>0 .And. B2_VFIM1>0)
					_nValor := SB2->B2_VFIM1 / SB2->B2_QFIM
				Else
					_DTAF:=lastday(MV_PAR01)
					_DTAI:=firstday(MV_PAR01-180)
					_cQuery :=" SELECT ISNULL((DATA),' ')DATAT,TIPO FROM ( "
					_cQuery +=" SELECT MAX(D3_EMISSAO) DATA,'SD3' TIPO FROM SD3020 SD3 WHERE D3_COD = '"+TRB->B3_COD+"' AND D3_EMISSAO >='"+DTOS(_DTAI)+"'  AND D3_EMISSAO <= '"+DTOS(_DTAF)+"'  AND SD3.D_E_L_E_T_ = '' "
					_cQuery +=" AND D3_ESTORNO <> 'S' AND D3_FILIAL = '"+TRB->B3_FILIAL+"' and D3_QUANT <> 0 " //AND D3_LOCAL = '"+_CLOCAL+"' "
					_cQuery +=" UNION "
					_cQuery +=" SELECT MAX(D1_EMISSAO) DATA,'SD1' TIPO FROM SD1020 SD1,SF4020 WHERE D1_COD = '"+TRB->B3_COD+"' AND D1_DTDIGIT >='"+DTOS(_DTAI)+"' AND D1_DTDIGIT <='"+DTOS(_DTAF)+"' AND SD1.D_E_L_E_T_ = ''  "
					_cQuery +=" AND D1_FILIAL = '"+TRB->B3_FILIAL+"' AND D1_QUANT <> 0  AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4020.D_E_L_E_T_ = '' "//AND D1_LOCAL = '"+_CLOCAL+"' AND D1_QUANT <> 0  "
					_cQuery +=" UNION "
					_cQuery +=" SELECT MAX(D2_EMISSAO) DATA,'SD2' TIPO FROM SD2020 SD2 ,SF4020 WHERE D2_COD ='"+TRB->B3_COD+"' AND D2_EMISSAO  >='"+DTOS(_DTAI)+"' AND D2_EMISSAO < = '"+DTOS(_DTAF)+"' AND SD2.D_E_L_E_T_ = ''
					_cQuery +=" AND D2_FILIAL = '"+TRB->B3_FILIAL+"' AND D2_QUANT <> 0 AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND SF4020.D_E_L_E_T_ = '' " //AND D2_LOCAL = '"+_CLOCAL+"' AND D2_QUANT <> 0"
					_cQuery +=" )AGRUPA "
					_cQuery +=" ORDER  BY DATA+TIPO DESC "
					If Select("TRB1")>0
						dbSelectArea("TRB1")
						TRB1->(dbCloseArea("TRB1"))
					EndIf
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB1",.F.,.T.)
					
					DBSELECTAREA("TRB1")
					DBGOTOP()
					WHILE TRB1->(!EOF())
						IF !EMPTY(TRB1->DATAT)
							EXIT
						ENDIF
						
						TRB1->(DBSKIP())
					ENDDO
					
					IF TRB1->TIPO = 'SD1'
						_cQuery2 :=" SELECT SUM(D1_CUSTO)/SUM(D1_QUANT) CUSTO FROM SD1020 SD1 WHERE D1_COD = '"+TRB->B3_COD+"' AND D1_EMISSAO ='"+TRB1->DATAT+"'  AND SD1.D_E_L_E_T_ = ''  "
						_cQuery2 +=" AND D1_FILIAL = '"+TRB->B3_FILIAL+"' AND D1_QUANT <> 0 AND D1_CUSTO <> 0"//D1_LOCAL = '"+_CLOCAL+"' "
						If Select("TRB2")>0
							dbSelectArea("TRB2")
							TRB2->(dbCloseArea("TRB2"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"TRB2",.F.,.T.)
						_nValor:=TRB2->CUSTO
					ELSEIF TRB1->TIPO = 'SD2'
						_cQuery3 :=" SELECT SUM(D2_CUSTO1)/SUM(D2_QUANT) CUSTO FROM SD2020 SD2 WHERE D2_COD = '"+TRB->B3_COD+"' AND D2_EMISSAO ='"+TRB1->DATAT+"'  AND SD2.D_E_L_E_T_ = ''  "
						_cQuery3 +=" AND D2_FILIAL = '"+TRB->B3_FILIAL+"'  AND D2_QUANT  <> 0 AND D2_CUSTO1 <> 0 "//AND D2_LOCAL = '"+_CLOCAL+"' "
						If Select("TRB3")>0
							dbSelectArea("TRB3")
							TRB3->(dbCloseArea("TRB3"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),"TRB3",.F.,.T.)
						_nValor:=TRB3->CUSTO
					ELSEif TRB1->TIPO = 'SD3'
						
						_cQuery4 :=" SELECT SUM(D3_CUSTO1)/SUM(D3_QUANT) CUSTO FROM SD3020 SD3 WHERE D3_COD = '"+TRB->B3_COD+"' AND D3_EMISSAO ='"+TRB1->DATAT+"'   AND SD3.D_E_L_E_T_ = '' "
						_cQuery4 +=" AND D3_ESTORNO <> 'S' AND D3_FILIAL = '"+TRB->B3_FILIAL+"'  AND D3_QUANT <> 0 AND D3_CUSTO1 <> 0 "    //AND D3_LOCAL = '"+_CLOCAL+"'  AND D3_QUANT <> 0 "
						If Select("TRB4")>0
							dbSelectArea("TRB4")
							TRB4->(dbCloseArea("TRB4"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),"TRB4",.F.,.T.)
						
						_nValor:=TRB4->CUSTO
					ELSE
						sb2->((DBSEEK(TRB->B3_FILIAL+TRB->B3_COD+_CLOCAL)))
						_nValor := SB2->B2_CM1
					ENDIF
				endif
			ENDIF
		ELSE
			dbselectarea("SB9")
			DBSETORDER(1)
			IF DBSEEK(TRB->B3_FILIAL+TRB->B3_COD+_CLOCAL+DTOS(MV_PAR01))
				If SB9->(B9_QINI>0 .And. B9_VINI1>0)
					_nValor := SB9->B9_VINI1 / SB9->B9_QINI
				Else
					// _dta:=lastday(ddatabase-30)
					// for i:=_dta to firstday(_dta) step (-1)
					//    aSaldos:=CalcEst(TRB->B3_COD,_CLOCAL,i,TRB->B3_FILIAL)
					//    if aSaldos[1]>0
					//       exit
					//    endif
					// next
					_DTAF:=lastday(MV_PAR01)
					_DTAI:=firstday(MV_PAR01-180)
					_cQuery :=" SELECT ISNULL((DATA),' ')DATAT,TIPO FROM ( "
					_cQuery +=" SELECT MAX(D3_EMISSAO) DATA,'SD3' TIPO FROM SD3020 SD3 WHERE D3_COD = '"+TRB->B3_COD+"' AND D3_EMISSAO >='"+DTOS(_DTAI)+"'  AND D3_EMISSAO <= '"+DTOS(_DTAF)+"'  AND SD3.D_E_L_E_T_ = '' "
					_cQuery +=" AND D3_ESTORNO <> 'S' AND D3_FILIAL = '"+TRB->B3_FILIAL+"'  AND D3_QUANT <> 0 "//AND D3_LOCAL = '"+_CLOCAL+"' "
					_cQuery +=" UNION "
					_cQuery +=" SELECT MAX(D1_EMISSAO) DATA,'SD1' TIPO FROM SD1020 SD1 WHERE D1_COD = '"+TRB->B3_COD+"' AND D1_EMISSAO >='"+DTOS(_DTAI)+"' AND D1_EMISSAO <='"+DTOS(_DTAF)+"' AND SD1.D_E_L_E_T_ = ''  "
					_cQuery +=" AND D1_FILIAL = '"+TRB->B3_FILIAL+"' AND D1_QUANT <> 0  "   //D1_LOCAL = '"+_CLOCAL+"' AND D1_QUANT <> 0  "
					_cQuery +=" UNION "
					_cQuery +=" SELECT MAX(D2_EMISSAO) DATA,'SD2' TIPO FROM SD2020 SD2 WHERE D2_COD ='"+TRB->B3_COD+"' AND D2_EMISSAO  >='"+DTOS(_DTAI)+"' AND D2_EMISSAO < = '"+DTOS(_DTAF)+"' AND SD2.D_E_L_E_T_ = ''
					_cQuery +=" AND D2_FILIAL = '"+TRB->B3_FILIAL+"'  AND D2_QUANT <> 0"  //D2_LOCAL = '"+_CLOCAL+"' AND D2_QUANT <> 0"
					_cQuery +=" )AGRUPA "
					_cQuery +=" ORDER  BY DATA DESC "
					If Select("TRB1")>0
						dbSelectArea("TRB1")
						TRB1->(dbCloseArea("TRB1"))
					EndIf
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"TRB1",.F.,.T.)
					
					DBSELECTAREA("TRB1")
					DBGOTOP()
					WHILE TRB1->(!EOF())
						IF !EMPTY(TRB1->DATAT)
							EXIT
						ENDIF
						
						TRB1->(DBSKIP())
					ENDDO
					
					IF TRB1->TIPO = 'SD1'
						_cQuery2 :=" SELECT SUM(D1_CUSTO)/SUM(D1_QUANT) CUSTO FROM SD1020 SD1 WHERE D1_COD = '"+TRB->B3_COD+"' AND D1_EMISSAO ='"+TRB1->DATAT+"'  AND SD1.D_E_L_E_T_ = ''  "
						_cQuery2 +=" AND D1_FILIAL = '"+TRB->B3_FILIAL+"'  AND D1_QUANT <> 0 AND D1_CUSTO <> 0"//AND D1_LOCAL = '"+_CLOCAL+"' "
						If Select("TRB2")>0
							dbSelectArea("TRB2")
							TRB2->(dbCloseArea("TRB2"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery2),"TRB2",.F.,.T.)
						_nValor:=TRB2->CUSTO
					ELSEIF TRB1->TIPO = 'SD2'
						_cQuery3 :=" SELECT SUM(D2_CUSTO1)/SUM(D2_QUANT) CUSTO FROM SD2020 SD2 WHERE D2_COD = '"+TRB->B3_COD+"' AND D2_EMISSAO ='"+TRB1->DATAT+"'  AND SD2.D_E_L_E_T_ = ''  "
						_cQuery3 +=" AND D2_FILIAL = '"+TRB->B3_FILIAL+"'  AND D2_QUANT <> 0 AND D2_CUSTO1 <> 0 " // D2_LOCAL = '"+_CLOCAL+"' "
						If Select("TRB3")>0
							dbSelectArea("TRB3")
							TRB3->(dbCloseArea("TRB3"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery3),"TRB3",.F.,.T.)
						_nValor:=TRB3->CUSTO
					ELSEif TRB1->TIPO = 'SD3'
						
						_cQuery4 :=" SELECT SUM(D3_CUSTO1)/SUM(D3_QUANT) CUSTO FROM SD3020 SD3 WHERE D3_COD = '"+TRB->B3_COD+"' AND D3_EMISSAO ='"+TRB1->DATAT+"'   AND SD3.D_E_L_E_T_ = '' "
						_cQuery4 +=" AND D3_ESTORNO <> 'S' AND D3_FILIAL = '"+TRB->B3_FILIAL+"' AND D3_QUANT <> 0  AND D3_CUSTO1 <> 0"// D3_LOCAL = '"+_CLOCAL+"'  AND D3_QUANT <> 0 "
						If Select("TRB4")>0
							dbSelectArea("TRB4")
							TRB4->(dbCloseArea("TRB4"))
						EndIf
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery4),"TRB4",.F.,.T.)
						
						_nValor:=TRB4->CUSTO
						
					else
						sb2->((DBSEEK(TRB->B3_FILIAL+TRB->B3_COD+_CLOCAL)))
						_nValor := SB2->B2_CM1
					ENDIF
				ENDIF
			ENDIF
		ENDIF
		
		//if MV_PAR04 == 3
		IF SB1->(DBSEEK(XFILIAL("SB1")+TRB->B3_COD)) .AND. MV_PAR04 = 3
			_nValor1:=SB1->B1_CUSTD
			DBSELECTAREA("SB3")
			IF DBSeek(TRB->B3_FILIAL+TRB->B3_COD)
				RECLOCK("SB3",.F.)
				&(cCampo2) := _nValor1
				SB3->(MSUNLOCK())
			ENDIF
		ENDIF
		//ENDIF
		
		DBSELECTAREA("SB3")
		IF DBSeek(TRB->B3_FILIAL+TRB->B3_COD)
			RECLOCK("SB3",.F.)
			&(cCampo1) := _nValor
			SB3->(MSUNLOCK())
		ENDIF
	else
		
		IF SB1->(DBSEEK(XFILIAL("SB1")+TRB->B3_COD))
			_nValor1:=SB1->B1_CUSTD
		ENDIF
		
		DBSELECTAREA("SB3")
		IF DBSeek(TRB->B3_FILIAL+TRB->B3_COD)
			RECLOCK("SB3",.F.)
			&(cCampo2) := _nValor1
			SB3->(MSUNLOCK())
		ENDIF
		
	endif
	
	//TRB4->(dbclosearea("TRB4"))
	TRB->(DBSKIP())
	//TRB4->(dbclosearea("TRB4"))
	
	
ENDDO




SB3->(dbclosearea("SB3"))
SB2->(dbclosearea("SB2"))
SB9->(dbclosearea("SB2"))


Return

