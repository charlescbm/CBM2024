#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TbiConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZeraCus   ºAutor  ³Cleiton             º Data ³  24/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Com base em query passada por Rodolfo, rotina sera executadaº±±
±±º          ³no fechamento                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Brascola                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function ZeraCus
Local _cQuery := ""

If !Pergunte("ZERAC",.t.)
  	Return
EndIf

_cQuery := "UPDATE " + RetSqlName("SB9") + "                                "
_cQuery += "SET    B9_VINI1 = 0, B9_CM1 = 0                                 "
_cQuery += "FROM   SB9010                                                   "
_cQuery += "WHERE  B9_QINI = 0                                              "
_cQuery += "   AND B9_DATA = '" + DtoS(MV_Par01) + "'                       "
_cQuery += "   AND B9_FILIAL = '" + xFilial("SB9") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSB901.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SB2") + "                                "
_cQuery += "SET    B2_VFIM1 = 0, B2_CMFIM1 = 0                              "
_cQuery += "FROM   SB2010                                                   "
_cQuery += "WHERE  B2_QFIM = 0                                              "
_cQuery += "   AND B2_FILIAL = '" + xFilial("SB2") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSB201.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SD1") + "                                "
_cQuery += "SET    D1_CUSTO2=0,D1_CUSTO3=0,D1_CUSTO4=0,D1_CUSTO5=0          "
_cQuery += "FROM   SD1010                                                   "
_cQuery += "WHERE  D_E_L_E_T_ = ''                                          "
_cQuery += "   AND D1_DTDIGIT > '" + DtoS(MV_Par01) + "'                   "
_cQuery += "   AND D1_FILIAL = '" + xFilial("SD1") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSD1.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SD2") + "                                "
_cQuery += "SET    D2_CUSTO2=0,D2_CUSTO3=0,D2_CUSTO4=0,D2_CUSTO5=0          "
_cQuery += "FROM   SD2010                                                   "
_cQuery += "WHERE  D_E_L_E_T_ = ''                                          "
_cQuery += "   AND D2_EMISSAO > '" + DtoS(MV_Par01) + "'                   "
_cQuery += "   AND D2_FILIAL = '" + xFilial("SD2") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSD2.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SD3") + "                                "
_cQuery += "SET    D3_CUSTO2=0,D3_CUSTO3=0,D3_CUSTO4=0,D3_CUSTO5=0          "
_cQuery += "FROM   SD3010                                                   "
_cQuery += "WHERE  D_E_L_E_T_ = ''                                          "
_cQuery += "   AND D3_EMISSAO > '" + DtoS(MV_Par01) + "'                   "
_cQuery += "   AND D3_FILIAL = '" + xFilial("SD3") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSD3.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SB2") + "                                "
_cQuery += "SET    B2_VATU2=0,B2_VATU3=0,B2_VATU4=0,B2_VATU5=0,             "
_cquery += "       B2_CM2=0,B2_CM3=0,B2_CM4=0,B2_CM5=0,                     "
_cQuery += "       B2_VFIM2=0,B2_VFIM3=0,B2_VFIM4=0,B2_VFIM5=0,             "
_cQuery += "       B2_CMFIM2=0,B2_CMFIM3=0,B2_CMFIM4=0,B2_CMFIM5=0          "
_cQuery += "FROM   SB2010                                                   "
_cQuery += "WHERE  D_E_L_E_T_ = ''                                          "
_cQuery += "   AND B2_FILIAL = '" + xFilial("SB2") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSB202.SQL", _cQuery)


_cQuery := "UPDATE " + RetSqlName("SB9") + "                                "
_cQuery += "SET    B9_VINI2 = 0,B9_VINI3 = 0,B9_VINI4 = 0,B9_VINI5 = 0      "
_cQuery += "WHERE  B9_DATA = '" + DtoS(MV_Par01) + "'                       "
_cQuery += "   AND D_E_L_E_T_ = ''                                          "
_cQuery += "   AND B9_FILIAL = '" + xFilial("SB9") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSB902.SQL", _cQuery)

_cQuery := "UPDATE " + RetSqlName("SB6") + "                                "
_cQuery += "SET    B6_CUSTO2 = 0 ,B6_CUSTO3 = 0,B6_CUSTO4 = 0,B6_CUSTO5 = 0 "
_cQuery += "WHERE  B6_DTDIGIT > '" + DtoS(MV_Par01) + "'                   "
_cQuery += "   AND D_E_L_E_T_ = ''                                          "
_cQuery += "   AND B6_FILIAL = '" + xFilial("SB6") + "'                     "

_Ret 	:= TcSqlExec( _cQuery ) 
//MemoWrite("\QUERYSYS\ZERACUSSB6.SQL", _cQuery)

Return