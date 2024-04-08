#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  BFINA001   บ Autor ณ AP6 IDE            บ Data ณ  27/12/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Importa Titulos Base antiga para nova                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BFINA001()
***********************     

U_BCFGA002("BFINA001")//Grava detalhes da rotina usada

If MsgYesNo("Deseja importar Titulos da Base Antiga ?")
	
	cPERG := "BFINA001"
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	If !dbseek(cPerg)
		//	PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03		,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
		PutSx1(cPerg,"01"	  ,"Data De            ?","",""	,"mv_ch1","D"  ,08,0,0		   ,"G" ,""			,""		,""		 ,""	,"mv_par01"	,""    ,""		,""		 ,""	,""		,""		 ,""	  ,""	 		,""	  	 ,""	   	,""			,""		,""			,""			,""		 ,""		,{""},{""},{""})
		PutSx1(cPerg,"02"	  ,"Data Ate           ?","",""	,"mv_ch2","D"  ,08,0,0		   ,"G" ,""			,""		,""		 ,""	,"mv_par02"	,""    ,""		,""		 ,""	,""		,""		 ,""	  ,""	 		,""	  	 ,""	   	,""			,""		,""			,""			,""		 ,""		,{""},{""},{""})
		PutSx1(cPerg,"03"	  ,"CNPJ 	           ?","",""	,"mv_ch3","C"  ,14,0,0		   ,"G" ,""			,""		,""		 ,""	,"mv_par03"	,""    ,""		,""		 ,""	,""		,""		 ,""	  ,""	 		,""	  	 ,""	   	,""			,""		,""			,""			,""		 ,""		,{""},{""},{""})
	     //PutSX1(cPerg,"03"     ,"Cnpj               ?","","" ,"mv_ch3","C"  ,18,0,0         ,"G" ,""         ,       ,""      ,""    ,"mv_par03" ,""    ,""      ,""      ,""    ,""     ,""      ,""      ,""           ,""      ,""        ,""         ,""     ,""         ,""         ,""      ,""                       )
	Endif
	
	If !Pergunte(cPerg,.T.)
		Return
	Endif
	
	
	Processa({|| BFNA001Processa()})
	
EndIf

Return

Static Function BFNA001Processa()
*********************************


/*
cQuery := "SELECT  * "
cQuery += "FROM DADOS10.dbo.SE1020 E1 "
cQuery += "WHERE E1.E1_FILIAL = '02' "
cQuery += "AND E1.E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
cQuery += "AND E1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY E1_VENCREA "
*/

//1 - Titulos com vendedores
//2 - Titulos sem vendedores

For _y := 1 To 2
	
	cArqQry   := "MSE1"
	nCont     := 0
	aStruMSE1 := {}
	aStruSE1  := {}
	
	If _y == 1
		
		cQuery := "SELECT * "
		cQuery += "FROM DADOS10.dbo.SE1020 E1, DADOS10.dbo.SA1020 A1, DADOS10.dbo.SA3020 A3 "
		//cQuery += "WHERE E1.E1_FILIAL = '01' "
		cQuery += "WHERE E1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQuery += "AND E1_VEND1 = A3_COD "
		cQuery += "AND E1_CLIENTE = A1_COD "
		cQuery += "AND E1_LOJA = A1_LOJA "
		cQuery += "AND E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
		cQuery += "AND E1_DATAEDI = ' ' "          
		
		If !empty (mv_par03)
			cQuery += "AND A1_CGC = '"+(mv_par03)+"'"
		Endif
		
		cQuery += "AND E1_SALDO <> 0 "
		cQuery += "AND E1_TIPO NOT IN ('NCC','RA') "
		cQuery += "ORDER BY E1_VENCREA "
		
	Else
		
		cQuery := "SELECT * "
		cQuery += "FROM DADOS10.dbo.SE1020 E1, DADOS10.dbo.SA1020 A1 "
		//cQuery += "WHERE E1.E1_FILIAL = '01' "
		cQuery += "WHERE E1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' "
		cQuery += "AND E1_CLIENTE = A1_COD "
		cQuery += "AND E1_LOJA = A1_LOJA "
		cQuery += "AND E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
		cQuery += "AND E1_DATAEDI = ' ' "  
		
		If !empty (mv_par03)
			cQuery += "AND A1_CGC = '"+(mv_par03)+"'"
		Endif
		
		cQuery += "AND E1_SALDO <> 0 "
		cQuery += "AND E1_TIPO NOT IN ('NCC','RA') "
		cQuery += "ORDER BY E1_VENCREA "
		
	EndIF
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
	
	aStruMSE1 := MSE1->(dbStruct())
	aStruSE1  := SE1->(dbStruct())
	
	For nCntFor := 1 To Len(aStruSE1)
		If ( aStruSE1[nCntFor,2]<>"C" )
			TcSetField(cArqQry,aStruSE1[nCntFor,1],aStruSE1[nCntFor,2],aStruSE1[nCntFor,3],aStruSE1[nCntFor,4])
		EndIf
	Next nCntFor
	
	DbSelectArea("MSE1")
	DbGotop()
	ProcRegua(1)
	While !Eof()
		
		IncProc()
		
		DbSelectArea("SE1")
		RecLock("SE1",.T.)
		
		For _x := 1 To Len(aStruSE1)
			
			cCampo := aStruSE1[_x,1]
			
			If aStruSE1[_x,1] == "R_E_C_N_O_" .OR. aStruSE1[_x,1] == "D_E_L_E_T_" .OR. aStruSE1[_x,1] == "R_E_C_D_E_L_"
				//aStruSE1[_x,1] == "E1_X_OBS" .OR. aStruSE1[_x,1] == "E1_USERLGI" .OR. aStruSE1[_x,1] == "E1_USERLGA" .OR.;
				Loop
			EndIf
			
			If AScan(aStruMSE1,{|x| x[1] == aStruSE1[_x,1]}) != 0
				Do Case
					Case aStruSE1[_x,1] == "E1_CLIENTE"
						SE1->(&cCampo) := SubStr(MSE1->A1_CGC,1,8)
					Case aStruSE1[_x,1] == "E1_LOJA"
						SE1->(&cCampo) := SubStr(MSE1->A1_CGC,9,4)
					Case aStruSE1[_x,1] == "E1_FILIAL"
						If MSE1->(&cCampo) != "03"
							SE1->(&cCampo) := "01"
						Else
							SE1->(&cCampo) := MSE1->(&cCampo)
						EndIF
					Case aStruSE1[_x,1] == "E1_VEND1" .AND. _y == 1
						SA3->(DbSetOrder(3))
						If SA3->(DbSeek(xFilial("SA3")+MSE1->A3_CGC))
							SE1->(&cCampo) := SA3->A3_COD
						Else
							SE1->(&cCampo) := MSE1->(&cCampo)
						EndIf
					OtherWise
						SE1->(&cCampo) := MSE1->(&cCampo)
				EndCase
			EndIf
			
		Next _x
		
		SE1->(MsUnLock())
		
		nCont++
		
		DbSelectArea("MSE1")
		DbSkip()
	EndDo
	
	
	If _y == 1
		cQuery := "UPDATE DADOS10.dbo.SE1020 SET E1_DATAEDI = '"+DtoS(MsDate())+"' "
		cQuery += "FROM DADOS10.dbo.SE1020 E1, DADOS10.dbo.SA1020 A1, DADOS10.dbo.SA3020 A3 "
		cQuery += "WHERE E1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' AND A3.D_E_L_E_T_ = ' ' "
		cQuery += "AND E1_VEND1 = A3_COD "
		cQuery += "AND E1_CLIENTE = A1_COD "
		cQuery += "AND E1_LOJA = A1_LOJA "
		cQuery += "AND E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
		cQuery += "AND E1_DATAEDI = ' ' "
		
		If !empty (mv_par03)
			cQuery += "AND A1_CGC = '"+(mv_par03)+"'"
		Endif
		
		cQuery += "AND E1_SALDO <> 0 "
		cQuery += "AND E1_TIPO NOT IN ('NCC','RA') "
		TCSQLEXEC(cQuery)
		
		MsgInfo("Importado "+AllTrim(Str(nCont))+" Titulos com Vendedor.")
		
	Else
		cQuery := "UPDATE DADOS10.dbo.SE1020 SET E1_DATAEDI = '"+DtoS(MsDate())+"' "
		cQuery += "FROM DADOS10.dbo.SE1020 E1, DADOS10.dbo.SA1020 A1 "
		cQuery += "WHERE E1.D_E_L_E_T_ = ' ' AND A1.D_E_L_E_T_ = ' ' "
		cQuery += "AND E1_CLIENTE = A1_COD "
		cQuery += "AND E1_LOJA = A1_LOJA "
		cQuery += "AND E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
		cQuery += "AND E1_DATAEDI = ' ' "
		
		If !empty (mv_par03)
			cQuery += "AND A1_CGC = '"+(mv_par03)+"'"
		Endif
		
		cQuery += "AND E1_SALDO <> 0 "
		cQuery += "AND E1_TIPO NOT IN ('NCC','RA') "
		TCSQLEXEC(cQuery)
		
		MsgInfo("Importado "+AllTrim(Str(nCont))+" Titulos sem Vendedor.")
		
	EndIf
	
	If Select("MSE1") > 0
		DbSelectArea("MSE1")
		DbCloseArea()
	Endif
	
	If Select("SE1") > 0
		DbSelectArea("SE1")
		DbCloseArea()
	Endif
	
Next _y

Return
