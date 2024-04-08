#include "rwmake.ch"
#include "topconn.ch"

/*
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё WBRA860  ╨Autor  Ё Marcelo da Cunha   ╨ Data Ё  19/04/13   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Desc.     Ё Calculo Cubo GDView Gestao Pessoal                         ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP                                                         ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
*/
User Function WBRA860AUTO()
************************
If (Type("oMainWnd") == "U")
	RPCSetType(3)
	RPCSetEnv("01","01","","","PON","",{"SRA","SPC","SP9","SRD","SRV","SPJ","ZMP"})
Endif
conout(" ")
conout("Iniciando Calculo Cubo Ponto/RH")
conout("===============================")
conout("Data: "+dtoc(MsDate())+" Hora: "+Time())
u_WBRA860(.T.)
conout("===============================")
Return

User Function WBRA860(xAuto)
*************************
PRIVATE aRegs := {}, cPerg := "WBRA860" 
PRIVATE lAuto := iif(xAuto!=Nil,xAuto,.F.)
PRIVATE nHora := Val(Substr(Time(),1,2))
PRIVATE cPon1 := Substr(GetMV("MV_PONMES"),1,8)
PRIVATE cPon2 := Substr(GetMV("MV_PONMES"),10,8)

//Crio parametros
/////////////////
aadd(aRegs,{cPerg,"01","Periodo Calculo De ?","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Periodo Calculo Ate?","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Resumo Ponto/RH    ?","mv_ch3","N",01,0,0,"C","","MV_PAR03","Sim","","","Nao","","","","","","","","","","",""})
u_GDVCriaPer(cPerg,aRegs) //GOLDENVIEW
                     
If (lAuto)
	Pergunte(cPerg,.F.)
	mv_par01 := dDatabase-30
	mv_par02 := dDatabase
	mv_par03 := 1
Else
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Utiliza apenas nos modulo PCP                                Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (cModulo != "PON").and.(cModulo != "GPE")
		MsgInfo(">>> Utilizar esta rotina para modulo de PONTO/RH!","ATENCAO")
		Return
	Elseif (cNivel < 8)
		MsgInfo(">> Voce nao tem acesso para utilizar esta rotina!","ATENCAO")
		Return
	Endif
	If !Pergunte(cPerg,.T.)
		Return
	Endif
Endif

//Chamo rotina para processamento
/////////////////////////////////
If (lAuto)
	If (mv_par03 == 1) //Cubo Ponto Eletronico
		W860ResPon()
	Endif
Else
	If !MsgYesNo(">>> Confirma processamento?","ATENCAO")
		Return
	Endif
	If (mv_par03 == 1) //Cubo Ponto Eletronico
		Processa({|| W860ResPon() })
	Endif
Endif

Return

Static Function W860ResPon()
*************************
LOCAL cQuery,nMes:=0,nAno:=0,aFilial,nx
LOCAL cCampo1,dAux,_i,nNumFun,aAnoMes:={}

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Zerando informacoes                                          Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cQuery := "DELETE FROM "+RetSqlName("ZMP")+" WHERE D_E_L_E_T_ = '' AND ZMP_FILIAL = '"+xFilial("ZMP")+"' "
cQuery += "AND ZMP_ANOMES BETWEEN '"+Substr(dtos(mv_par01),1,6)+"' AND '"+Substr(dtos(mv_par02),1,6)+"ZZ' "
TCSQLExec(cQuery)
       
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processando todas as filiais                                 Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aProcFil := {"01"}
For nx := 1 to Len(aProcFil)

	If (!lAuto)
		Procregua(1)
	Endif                       

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monto resumo dados Horas Abono / Horas Atraso / Horas Falta SRD Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuery := "SELECT RD_DATARQ,RD_PD,RV_GDOPER,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '3' THEN RD_HORAS ELSE 0 END) RD_HRSATR,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '4' THEN RD_HORAS ELSE 0 END) RD_HRSABO,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '5' THEN RD_HORAS ELSE 0 END) RD_HRSFAL,"
	cQuery += "SUM(CASE WHEN RV_GDTIPO = '6' THEN RD_HORAS ELSE 0 END) RD_HRSDES "
	cQuery += "FROM "+RetSqlName("SRD")+" A,"+RetSqlName("SRV")+" B,"+RetSqlName("SRA")+" C,"+RetSqlName("CTT")+" D "
	cQuery += "WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D.D_E_L_E_T_ = '' "
	cQuery += "AND A.RD_FILIAL = '"+W860Filial("SRD",aProcFil[nx])+"' AND B.RV_FILIAL = '"+W860Filial("SRV",aProcFil[nx])+"' "
	cQuery += "AND C.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' AND D.CTT_FILIAL = '"+W860Filial("CTT",aProcFil[nx])+"' "
	cQuery += "AND A.RD_FILIAL = C.RA_FILIAL AND B.RV_GDTIPO IN ('3','4','5','6') AND C.RA_CATFUNC IN ('H','M','D') "
	cQuery += "AND B.RV_TIPO IN ('H','V','D') AND A.RD_PD = B.RV_COD AND A.RD_MAT = C.RA_MAT AND A.RD_CC = D.CTT_CUSTO AND A.RD_MES <> '13' "
	cQuery += "AND A.RD_DATARQ BETWEEN '"+Substr(dtos(mv_par01),1,6)+"' AND '"+Substr(dtos(mv_par02),1,6)+"ZZ' "
	cQuery += "GROUP BY RD_DATARQ,RD_PD,RV_GDOPER "
	cQuery += "ORDER BY RD_DATARQ "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		If (!lAuto)
			Incproc(" >>> Horas Abonadas/Atraso/Falta..."+MAR->RD_datarq)
		Endif
		dbSelectArea("ZMP")
		If ZMP->(dbSeek(W860Filial("ZMP",aProcFil[nx])+MAR->RD_datarq))
			RecLock("ZMP",.F.)
		Else
			RecLock("ZMP",.T.)
			ZMP->ZMP_filial := W860Filial("ZMP",aProcFil[nx])
			ZMP->ZMP_anomes := MAR->RD_datarq
		Endif
		nHrsFal := MAR->RD_HRSFAL
		nHrsDes := MAR->RD_HRSDES
		nHrsAbo := MAR->RD_HRSABO
		nHrsAtr := MAR->RD_HRSATR
		If (MAR->RD_PD $ "182") //Converter para Horas
			nHrDia  := W860HrsMes(MAR->RD_datarq)
			nHrsFal := nHrsFal * nHrDia
			nHrsDes := nHrsDes * nHrDia
			nHrsAbo := nHrsAbo * nHrDia
			nHrsAtr := nHrsAtr * nHrDia
		Endif
		If (MAR->RV_GDoper == "+")
			ZMP->ZMP_hrsabo += nHrsAbo
			ZMP->ZMP_hrsatr += nHrsAtr
			ZMP->ZMP_hrsfal += nHrsFal-nHrsDes
		Elseif (MAR->RV_GDoper == "-")
			ZMP->ZMP_hrsabo -= nHrsAbo
			ZMP->ZMP_hrsatr -= nHrsAtr
			ZMP->ZMP_hrsfal -= nHrsFal-nHrsDes
		Endif
		//If (ZMP->ZMP_hrstra > 0)
		//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
		//Endif
		ZMP->ZMP_dtatua := MsDate()
		ZMP->ZMP_hratua := Time()
		MsUnLock("ZMP")
		If (aScan(aAnoMes,ZMP->ZMP_anomes) == 0)
			aadd(aAnoMes,ZMP->ZMP_anomes)
		Endif
		MAR->(dbSkip())	
	Enddo

	//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monto resumo dados Horas Abono / Horas Atraso / Horas Falta - SPC Ё
	//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (Substr(dtos(mv_par02),1,6) >= Substr(cPon2,1,6))
		cQuery := "SELECT PC_DATA,RV_COD,RV_GDOPER,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '4' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) PC_HRSABO,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '3' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) PC_HRSATR,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '5' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) PC_HRSFAL,"
		cQuery += "SUM(CASE WHEN RV_GDTIPO = '6' THEN (FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6)) ELSE 0 END) PC_HRSDES "
		cQuery += "FROM "+RetSqlName("SPC")+" A,"+RetSqlName("SP9")+" B,"+RetSqlName("SRA")+" C,"+RetSqlName("CTT")+" D,"+RetSqlName("SRV")+" E "
		cQuery += "WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D.D_E_L_E_T_ = '' AND E.D_E_L_E_T_ = '' "
		cQuery += "AND B.P9_FILIAL = '"+W860Filial("SP9",aProcFil[nx])+"' AND D.CTT_FILIAL = '"+W860Filial("CTT",aProcFil[nx])+"' AND E.RV_FILIAL = '"+W860Filial("SRV",aProcFil[nx])+"' "
		cQuery += "AND C.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' AND A.PC_FILIAL = C.RA_FILIAL  AND E.RV_GDTIPO IN ('3','4','5','6') "
		cQuery += "AND A.PC_PD = B.P9_CODIGO AND B.P9_CODFOL = E.RV_COD AND A.PC_MAT = C.RA_MAT AND A.PC_CC = D.CTT_CUSTO AND C.RA_CATFUNC IN ('H','M','D') "
		cQuery += "AND A.PC_DATA BETWEEN '"+Substr(cPon2,1,6)+"' AND '"+dtos(dDatabase-1)+"' AND E.RV_TIPO IN ('H','V','D') "
		cQuery += "GROUP BY PC_DATA,RV_COD,RV_GDOPER "
		cQuery += "ORDER BY PC_DATA "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !MAR->(Eof())
			If (!lAuto)
				Incproc(" >>> Horas Abonadas/Atraso/Falta..."+MAR->PC_data)
			Endif
			dbSelectArea("ZMP")
			If ZMP->(dbSeek(W860Filial("ZMP",aProcFil[nx])+Substr(MAR->PC_data,1,6)))
				RecLock("ZMP",.F.)
			Else
				RecLock("ZMP",.T.)
				ZMP->ZMP_filial := W860Filial("ZMP",aProcFil[nx])
				ZMP->ZMP_anomes := Substr(MAR->PC_data,1,6)
			Endif
			nHrsFal := MAR->PC_HRSFAL
			nHrsDes := MAR->PC_HRSDES
			nHrsAbo := MAR->PC_HRSABO
			nHrsAtr := MAR->PC_HRSATR
			If (MAR->RV_cod $ "182") //Converter para Horas
				nHrDia  := W860HrsMes(Substr(MAR->PC_data,1,6))
				nHrsFal := nHrsFal * nHrDia
				nHrsDes := nHrsDes * nHrDia
				nHrsAbo := nHrsAbo * nHrDia
				nHrsAtr := nHrsAtr * nHrDia
			Endif
			If (MAR->RV_GDoper == "+")
				ZMP->ZMP_hrsabo += nHrsAbo
				ZMP->ZMP_hrsatr += nHrsAtr
				ZMP->ZMP_hrsfal += (nHrsFal-nHrsDes)
			Elseif (MAR->RV_GDoper == "-")
				ZMP->ZMP_hrsabo -= nHrsAbo
				ZMP->ZMP_hrsatr -= nHrsAtr
				ZMP->ZMP_hrsfal -= (nHrsFal-nHrsDes)
			Endif
			//If (ZMP->ZMP_hrstra > 0)
			//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
			//Endif
			ZMP->ZMP_dtatua := MsDate()
			ZMP->ZMP_hratua := Time()
			MsUnLock("ZMP")
			If (aScan(aAnoMes,ZMP->ZMP_anomes) == 0)
				aadd(aAnoMes,ZMP->ZMP_anomes)
			Endif
			MAR->(dbSkip())	
		Enddo
	Endif
		
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monto resumo dados Horas Pagas / Horas Extra / Valor - SRD   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	cQuery := "SELECT RD_DATARQ,RD_PD,RV_GDTIPO,RV_GDOPER,SUM(RD_HORAS) RD_HORAS,SUM(RD_VALOR) RD_VALOR "
	cQuery += "FROM "+RetSqlName("SRD")+" A,"+RetSqlName("SRV")+" B,"+RetSqlName("SRA")+" C "
	cQuery += "WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND RD_PD = RV_COD AND RD_MAT = RA_MAT "
	cQuery += "AND A.RD_FILIAL = '"+W860Filial("SRD",aProcFil[nx])+"' AND B.RV_FILIAL = '"+W860Filial("SRV",aProcFil[nx])+"' AND C.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' "
	cQuery += "AND A.RD_MES <> '13' AND B.RV_GDTIPO IN ('1','2') AND B.RV_TIPO IN ('H','V','D') AND A.RD_FILIAL = C.RA_FILIAL "
	cQuery += "AND RD_DATARQ BETWEEN '"+Substr(dtos(mv_par01),1,6)+"' AND '"+Substr(dtos(mv_par02),1,6)+"ZZ' AND C.RA_CATFUNC IN ('H','M','D') "
	cQuery += "GROUP BY RD_DATARQ,RD_PD,RV_GDTIPO,RV_GDOPER "
	cQuery += "ORDER BY RD_DATARQ,RD_PD "
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	dbSelectArea("MAR")
	While !MAR->(Eof())
		If (!lAuto)
			Incproc(" >>> Horas Pagas/Extra/Valor..."+MAR->RD_datarq)
		Endif	
		dbSelectArea("ZMP")
		If ZMP->(dbSeek(W860Filial("ZMP",aProcFil[nx])+MAR->RD_datarq))
			RecLock("ZMP",.F.)
		Else
			RecLock("ZMP",.T.)
			ZMP->ZMP_filial := W860Filial("ZMP",aProcFil[nx])
			ZMP->ZMP_anomes := MAR->RD_datarq
		Endif
		nHoras := MAR->RD_horas
		nValor := MAR->RD_valor
		If (MAR->RD_PD $ "101") //Salario Mensalista
			nHoras := nHoras*W860HrsMes(MAR->RD_datarq) //220-44=176hr = 30d = 176/30 = 5.87/hrd
		Endif
		If (MAR->RD_PD != "700")
			//ZMP->ZMP_hrstra += nHoras
			ZMP->ZMP_hrspag += nHoras
			ZMP->ZMP_valpag += nValor
		Endif
		If (MAR->RV_GDtipo == "2") //Hora Extra
			If (MAR->RV_GDoper == "+")
				ZMP->ZMP_hrsext += nHoras
				ZMP->ZMP_valext += nValor
			Elseif (MAR->RV_GDoper == "-")
				ZMP->ZMP_hrsext += nHoras
				ZMP->ZMP_valext += nValor
			Endif
		Endif
		If (MAR->RD_PD $ "700")
			ZMP->ZMP_valnom += nValor
		Endif
		ZMP->ZMP_dtatua := MsDate()
		ZMP->ZMP_hratua := Time()
		//If (ZMP->ZMP_hrstra > 0)
		//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
		//Endif
		MsUnLock("ZMP")
		If (aScan(aAnoMes,ZMP->ZMP_anomes) == 0)
			aadd(aAnoMes,ZMP->ZMP_anomes)
		Endif
		MAR->(dbSkip())
	Enddo                       
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monto resumo dados Horas Pagas / Horas Extra / Valor - SRC   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	If (Substr(dtos(mv_par02),1,6) > Substr(cPon2,1,6))
		cQuery := "SELECT PC_DATA,P9_CODFOL,RV_GDTIPO,RV_GDOPER,SUM((FLOOR(PC_QUANTC)+((PC_QUANTC-FLOOR(PC_QUANTC))/0.6))) PC_QUANTC "
		cQuery += "FROM "+RetSqlName("SPC")+" A,"+RetSqlName("SP9")+" B,"+RetSqlName("SRA")+" C,"+RetSqlName("SRV")+" D "
		cQuery += "WHERE A.D_E_L_E_T_ = '' AND B.D_E_L_E_T_ = '' AND C.D_E_L_E_T_ = '' AND D.D_E_L_E_T_ = '' "
		cQuery += "AND PC_PD = P9_CODIGO AND P9_CODFOL = RV_COD AND PC_MAT = RA_MAT AND C.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' "
		cQuery += "AND B.P9_FILIAL = '"+W860Filial("SP9",aProcFil[nx])+"' AND D.RV_FILIAL = '"+W860Filial("SRV",aProcFil[nx])+"' AND A.PC_FILIAL = C.RA_FILIAL "
		cQuery += "AND D.RV_GDTIPO IN ('1','2') AND A.PC_DATA BETWEEN '"+Substr(cPon2,1,6)+"' AND '"+dtos(dDatabase-1)+"' AND C.RA_CATFUNC IN ('H','M','D') "
		cQuery += "GROUP BY PC_DATA,P9_CODFOL,RV_GDTIPO,RV_GDOPER "
		cQuery += "ORDER BY PC_DATA,P9_CODFOL,RV_GDTIPO,RV_GDOPER "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		dbSelectArea("MAR")
		While !MAR->(Eof())
			If (!lAuto)
				Incproc(" >>> Horas Pagas/Extra..."+MAR->PC_data)
			Endif
			dbSelectArea("ZMP")
			If ZMP->(dbSeek(W860Filial("ZMP",aProcFil[nx])+Substr(MAR->PC_data,1,6)))
				RecLock("ZMP",.F.)
			Else
				RecLock("ZMP",.T.)
				ZMP->ZMP_filial := W860Filial("ZMP",aProcFil[nx])
				ZMP->ZMP_anomes := Substr(MAR->PC_data,1,6)
			Endif
			nHoras := MAR->PC_quantc
			If (MAR->P9_CODFOL $ "101") //Salario Mensalista
				nHoras := nHoras*W860HrsMes(Substr(MAR->PC_data,1,6)) //220-44=176hr = 30d = 176/30 = 5.87/hrd
			Endif
			If (MAR->P9_CODFOL != "700")
				//ZMP->ZMP_hrstra += nHoras
				ZMP->ZMP_hrspag += nHoras
			Endif
			If (MAR->RV_GDtipo == "2") //Hora Extra
				If (MAR->RV_GDoper == "+")
					ZMP->ZMP_hrsext += nHoras
				Elseif(MAR->RV_GDoper == "-")
					ZMP->ZMP_hrsext -= nHoras
				Endif
			Endif
			ZMP->ZMP_dtatua := MsDate()
			ZMP->ZMP_hratua := Time()
			//If (ZMP->ZMP_hrstra > 0)
			//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
			//Endif
			MsUnLock("ZMP")
			If (aScan(aAnoMes,ZMP->ZMP_anomes) == 0)
				aadd(aAnoMes,ZMP->ZMP_anomes)
			Endif
			MAR->(dbSkip())
		Enddo                       
	Endif
	
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Monto resumo dados Numero de Funcionarios                    Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	RCF->(dbSetOrder(1))
	For na := 1 to Len(aAnoMes)
		RCF->(dbSeek(xFilial("RCF")+aAnoMes[na],.T.))
		If (!lAuto)
			Incproc(">>> Funcionarios...")
		Endif	                                                                       
		cPerAnt := aAnoMes[na]
		If (Substr(cPerAnt,5,2) == "12")
			cPerAnt := Strzero(Val(Substr(cPerAnt,1,4))-1,4)+"01"
		Else
			cPerAnt := Substr(cPerAnt,1,4)+Strzero(Val(Substr(cPerAnt,5,2))-1,2)
		Endif                                                    
		cQuery := "SELECT RA_MAT,"
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+aAnoMes[na]+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+aAnoMes[na]+"ZZ')) THEN 1 ELSE 0 END) M_TOTNOR, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) <= '"+cPerAnt+"' AND ((RA_DEMISSA = '' AND RA_SITFOLH <> 'D') OR RA_DEMISSA > '"+cPerAnt+"ZZ')) THEN 1 ELSE 0 END) M_TOTNO2, "
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_ADMISSA,1,6) BETWEEN '"+aAnoMes[na]+"' AND '"+aAnoMes[na]+"ZZ') THEN 1 ELSE 0 END) M_TOTADM, " 
		cQuery += "SUM(CASE WHEN (SUBSTRING(RA_DEMISSA,1,6) BETWEEN '"+aAnoMes[na]+"' AND '"+aAnoMes[na]+"ZZ') THEN 1 ELSE 0 END) M_TOTDEM, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+RetSqlName("SR8")+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+W860Filial("SR8",aProcFil[nx])+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery += "AND (A.R8_DATAINI BETWEEN '"+aAnoMes[na]+"' AND '"+aAnoMes[na]+"ZZ' OR (R8_DATAINI <= '"+aAnoMes[na]+"' AND (R8_DATAFIM >= '"+aAnoMes[na]+"' OR R8_DATAFIM = ''))) "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAFA, "
		cQuery += "(SELECT COUNT(DISTINCT R8_MAT) FROM "+RetSqlName("SR8")+" A WHERE A.D_E_L_E_T_ = '' AND A.R8_FILIAL = '"+W860Filial("SR8",aProcFil[nx])+"' AND A.R8_MAT = RA.RA_MAT AND A.R8_TIPO <> 'F' "
		cQuery += "AND (A.R8_DATAINI BETWEEN '"+cPerAnt+"' AND '"+cPerAnt+"ZZ' OR (R8_DATAINI <= '"+cPerAnt+"' AND (R8_DATAFIM >= '"+cPerAnt+"' OR R8_DATAFIM = ''))) "
		cQuery += "AND (A.R8_DATAFIM = '' OR A.R8_DURACAO >= 15 OR (A.R8_DATAFIM <> '' AND A.R8_DATAFIM > SUBSTRING(A.R8_DATAINI,1,6)+'ZZ'))) M_TOTAF2 "
		cQuery += "FROM "+RetSqlName("SRA")+" RA WHERE RA.D_E_L_E_T_ = '' AND RA.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' AND RA.RA_CATFUNC IN ('H','M','D') "
		cQuery += "GROUP BY RA_MAT ORDER BY RA_MAT "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		nTotNor := 0 ; nTotNo2 := 0 ; nTotAfa := 0 ; nTotAf2 := 0 ; nTotAdm := 0 ; nTotDem := 0
		dbSelectArea("MAR")
		While !MAR->(Eof())
			nTotNor += MAR->M_totnor
			nTotNo2 += MAR->M_totno2
			nTotAfa += MAR->M_totafa
			nTotAf2 += MAR->M_totaf2
			nTotAdm += MAR->M_totadm
			nTotDem += MAR->M_totdem
			MAR->(dbSkip())
		Enddo
		cQuery := "SELECT SUM(RA4_HORAS) M_HORAS "
		cQuery += "FROM "+RetSqlName("RA4")+" RA4,"+RetSqlName("CTT")+" CT, "+RetSqlName("SRA")+" RA "
		cQuery += "WHERE RA4.D_E_L_E_T_ = '' AND RA.D_E_L_E_T_ = '' AND CT.D_E_L_E_T_ = '' "
		cQuery += "AND RA.RA_MAT = RA4.RA4_MAT AND RA.RA_CC = CT.CTT_CUSTO "
		cQuery += "AND RA4.RA4_FILIAL = '"+W860Filial("RA4",aProcFil[nx])+"' AND RA.RA_FILIAL = '"+W860Filial("SRA",aProcFil[nx])+"' "
		cQuery += "AND RA4_DATAFI BETWEEN '"+aAnoMes[na]+"' AND '"+aAnoMes[na]+"ZZ' AND RA.RA_CATFUNC IN ('H','M','D') "
		cQuery := ChangeQuery(cQuery)
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MAR"
		nHorTre := 0
		If !MAR->(Eof())
			nHorTre := MAR->M_HORAS
		Endif
		If (Select("MAR") <> 0)
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
		If ZMP->(dbSeek(W860Filial("ZMP",aProcFil[nx])+aAnoMes[na],.T.))
			RecLock("ZMP",.F.)
			ZMP->ZMP_numfun := nTotNor
			If (aAnoMes[na] > Substr(cPon2,1,6))
				ZMP->ZMP_hrspag += ZMP->ZMP_numfun*RCF->RCF_diatra*RCF->RCF_hrsdia
			Endif
			ZMP->ZMP_dtatua := MsDate()
			ZMP->ZMP_hratua := Time()
			//If (ZMP->ZMP_hrstra > 0)
			//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
			//Endif
			If ((nTotNor-nTotAfa) > 0)
				ZMP->ZMP_hrtrfu := (nHorTre/(nTotNor-nTotAfa))
			Endif
			If ((nTotNo2-nTotAf2) > 0)
				ZMP->ZMP_turnov := (((nTotAdm+nTotDem)/2)/(nTotNo2-nTotAf2))*100
			Endif
			MsUnLock("ZMP")
		Else
			RecLock("ZMP",.T.)
			ZMP->ZMP_filial := W860Filial("ZMP",aProcFil[nx])
			ZMP->ZMP_anomes := aAnoMes[na]
			ZMP->ZMP_numfun := nTotNor
			If (aAnoMes[na] > Substr(cPon2,1,6))
				ZMP->ZMP_hrspag += ZMP->ZMP_numfun*RCF->RCF_diatra*RCF->RCF_hrsdia
			Endif
			ZMP->ZMP_dtatua := MsDate()
			ZMP->ZMP_hratua := Time()
			//If (ZMP->ZMP_hrstra > 0)
			//	ZMP->ZMP_absent := ((ZMP->ZMP_hrsfal+ZMP->ZMP_hrsabo+ZMP->ZMP_hrsatr)/ZMP->ZMP_hrstra)*100
			//Endif
			If ((nTotNor-nTotAfa) > 0)
				ZMP->ZMP_hrtrfu := (nHorTre/(nTotNor-nTotAfa))
			Endif
			If ((nTotNo2-nTotAf2) > 0)
				ZMP->ZMP_turnov := (((nTotAdm+nTotDem)/2)/(nTotNo2-nTotAf2))*100
			Endif
			MsUnLock("ZMP")
	   Endif
	Next na
Next nx

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return

Static Function W860Filial(xAlias,xCodFil)
**************************************
LOCAL cRetu := iif(Empty(xFilial(xAlias)),xFilial(xAlias),xCodFil)
Return cRetu

Static Function W860HrsMes(xAnoMes)
*******************************
LOCAL nRetu := 0
SRX->(dbSetOrder(1)) //Tipo + Codigo
If SRX->(dbSeek(xFilial("SRX")+"19"+Space(12)+xAnoMes+Space(3)))
   nRetu := Val(Substr(SRX->RX_txt,1,6))/30
Endif
Return nRetu 

Static Function W860DecHora(xTempo)
********************************
LOCAL nMin,nHora
nMin := ROUND( xTempo - INT(xTempo),2)
nMin := ROUND( (nMin * 60 / 100) ,2)
nHora:= Int(xTempo) + nMin
Return(nHora)

Static Function W860HoraDec(xTempo)
********************************
nMin := ROUND( xTempo - INT(xTempo),2)
nMin := ROUND( (nMin / 60 * 100) ,2)
nHora:= Int(xTempo) + nMin
Return(nHora)