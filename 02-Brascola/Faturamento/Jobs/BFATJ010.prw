#include "rwmake.ch"
#include "topconn.ch"
                 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATJ010 ºAutor  ³ Marcelo da Cunha   º Data ³  08/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa em enviar Aviso de Faturamento Diário             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BFATJ010()
************************
LOCAL oProcess := Nil, dData, dData1M, dData2M, dDatAux, dDatFim
LOCAL cArquivo := "wffaturamento.htm", cQuery := "", cDir := "", cEmail := ""
LOCAL cBrCfFat := "", cBrCfNFat := "", cBrTsFat := "", cBrTsNFat := ""
LOCAL cFromName:= "Workflow -  BRASCOLA", cSimb, aTotal := {}

//Abro arquivos necessarios
///////////////////////////
If (Type("oMainWnd") == "U")
	RpcSetType(3)
	RPCSetEnv("01","01","","","FAT","",{"SA1","SA7","SD2","SF2","SC5","SC6","SB1","SF4"})
Endif
dData := MsDate() 
//dData := dDatabase   Marlon 06/01/2014 - Use esta linha para o programa utilizar a data base do sistema. ( MsDate() é para data do servidor)
dData1M := LastDay(dData)+1 //1 Mes
dData2M := LastDay(dData1M)+1 //2 Meses
cSimb := GetMV("MV_SIMB1")
cBrCfFat  := u_BXLstCfTes("BR_CFFAT")
cBrCfNFat := u_BXLstCfTes("BR_CFNFAT")
cBrTsFat  := u_BXLstCfTes("BR_TSFAT")
cBrTsNFat := u_BXLstCfTes("BR_TSNFAT")

//Inicio do processo
////////////////////
conout(" ")
conout("Inicio do Processo para avisar sobre Faturamento Diário - "+dtoc(MsDate()))
conout("=============================================================")

//Coloco a barra no final do parametro do diretorio
///////////////////////////////////////////////////
cDir := Alltrim(GetMV("MV_WFDIR"))
If Substr(cDir,Len(cDir),1) != "\"
	cDir += "\"
Endif

//Verifico se existe o arquivo de workflow
//////////////////////////////////////////
If !File(cDir+cArquivo)
	conout("> Nao foi encontrado o arquivo "+cDir+cArquivo)
	Return
Endif                           

//Inicio o processo
///////////////////
If !TCCanOpen(RetSqlName("SA1"))
	conout("> Erro de acesso ao DATABASE: "+dtoc(MsDate())+" "+Time())
	Return
Endif
oProcess := TWFProcess():New("FATURAMENTO","> Faturamento Diário")
oProcess:NewTask("100001",cDir+cArquivo)
oProcess:cSubject := "WORKFLOW:Faturamento Diário - "+dtoc(MsDate())
cEmail := Alltrim(SuperGetMV("BR_WFFATD",.F.,"")) //Lista de E-mails
cEmail := u_BXFormatEmail(cEmail)
If !Empty(cEmail)
	oProcess:cTo := cEmail
Else
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
//oProcess:cCC := "marcelo@goldenview.com.br"
oProcess:UserSiga := __cUserID
oProcess:cFromName:= cFromName
oProcess:oHtml:ValByName("DATAAMA" ,dtoc(dData+1))
oProcess:oHtml:ValByName("DATAFIMM" ,dtoc(LastDay(dData)))
oProcess:oHtml:ValByName("DATA1MES" ,MesExtenso(Month(dData1M))+"/"+Strzero(Year(dData1M),4))
oProcess:oHtml:ValByName("DATA2MES" ,MesExtenso(Month(dData2M))+"/"+Strzero(Year(dData2M),4))
oProcess:oHtml:ValByName("DATA" ,"DIA: "+dtoc(dData))
oProcess:oHtml:ValByName("MES"  ,"MES: "+MesExtenso(Month(dData)))
oProcess:oHtml:ValByName("ANO"  ,"ANO: "+Strzero(Year(dData),4))

//Resumo Faturamento Bruto
//////////////////////////
cQuery := "SELECT D2.D2_EMISSAO,SUM(D2.D2_VALBRUT) D2_VALBRUT "
cQuery += "FROM "+RetSqlName("SD2")+" D2 INNER JOIN "+RetSqlName("SF4")+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
cQuery += "WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND NOT D2.D2_TIPO IN ('B','D') AND F4.F4_DUPLIC = 'S' "
cQuery += "AND D2.D2_EMISSAO >= '"+Strzero(Year(dData),4)+"' AND D2.D2_EMISSAO <= '"+dtos(dData)+"' "
If !Empty(cBrCfFat)
	cQuery += "AND D2.D2_CF IN ("+cBrCfFat+") "
Endif
If !Empty(cBrCfNFat)
	cQuery += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
Endif
If !Empty(cBrTsFat)
	cQuery += "AND D2.D2_TES IN ("+cBrTsFat+") "
Endif
If !Empty(cBrTsNFat)
	cQuery += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
Endif
cQuery += "GROUP BY D2.D2_EMISSAO ORDER BY D2.D2_EMISSAO "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
TCSetField("MAR","D2_EMISSAO","D",08,0)
aTotal := {0,0,0}
dbSelectArea("MAR")
While !MAR->(Eof())
	If (MAR->D2_emissao == dData) //Dia
		aTotal[1] += MAR->D2_valbrut
	Endif
	If (Month(MAR->D2_emissao) == Month(dData)).and.(Year(MAR->D2_emissao) == Year(dData)) //Mes
		aTotal[2] += MAR->D2_valbrut
	Endif
	If (Year(MAR->D2_emissao) == Year(dData)) //Ano
		aTotal[3] += MAR->D2_valbrut
	Endif
	MAR->(dbSkip())
Enddo
oProcess:oHtml:ValByName("FATD" ,cSimb+" "+Transform(aTotal[1],PesqPict("SD2","D2_VALBRUT"))) //Faturamento Dia
oProcess:oHtml:ValByName("FATM" ,cSimb+" "+Transform(aTotal[2],PesqPict("SD2","D2_VALBRUT"))) //Faturamento Mes
oProcess:oHtml:ValByName("FATA" ,cSimb+" "+Transform(aTotal[3],PesqPict("SD2","D2_VALBRUT"))) //Faturamento Ano

//Resumo Devolucoes Bruto
/////////////////////////
cQuery := "SELECT D1.D1_DTDIGIT,SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) D1_VALBRUT "
cQuery += "FROM "+RetSqlName("SD1")+" D1 INNER JOIN "+RetSqlName("SF4")+" F4 ON (D1.D1_TES = F4.F4_CODIGO) "
cQuery += "WHERE D1.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' AND F4.F4_DUPLIC = 'S' "
cQuery += "AND D1.D1_DTDIGIT >= '"+Strzero(Year(dData),4)+"' AND D1.D1_DTDIGIT <= '"+dtos(dData)+"' "
cQuery += "AND D1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411') " //CFOPs de Devolucao
cQuery += "GROUP BY D1.D1_DTDIGIT ORDER BY D1.D1_DTDIGIT "
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
TCSetField("MAR","D1_DTDIGIT","D",08,0)
aTotal := {0,0,0}
dbSelectArea("MAR")
While !MAR->(Eof())
	If (MAR->D1_dtdigit == dData) //Dia
		aTotal[1] += MAR->D1_valbrut
	Endif
	If (Month(MAR->D1_dtdigit) == Month(dData)).and.(Year(MAR->D1_dtdigit) == Year(dData)) //Mes
		aTotal[2] += MAR->D1_valbrut
	Endif
	If (Year(MAR->D1_dtdigit) == Year(dData)) //Ano
		aTotal[3] += MAR->D1_valbrut
	Endif
	MAR->(dbSkip())
Enddo
oProcess:oHtml:ValByName("DEVD" ,cSimb+" "+Transform(aTotal[1],PesqPict("SD1","D1_TOTAL"))) //Devolucoes Dia
oProcess:oHtml:ValByName("DEVM" ,cSimb+" "+Transform(aTotal[2],PesqPict("SD1","D1_TOTAL"))) //Devolucoes Mes
oProcess:oHtml:ValByName("DEVA" ,cSimb+" "+Transform(aTotal[3],PesqPict("SD1","D1_TOTAL"))) //Devolucoes Ano

//Resumo Carteira de Pedidos
////////////////////////////
cQuery := "SELECT C5_MOEDA,C6_ENTREG,(C6_QTDVEN-C6_QTDENT) C6_SALDO,C6_PRCVEN "
cQuery += "FROM "+RetSqlName("SC6")+" C6 " 
cQuery += "INNER JOIN "+RetSqlName("SC5")+" C5 ON (C5.C5_NUM = C6.C6_NUM) "
cQuery += "INNER JOIN "+RetSqlName("SF4")+" F4 ON (C6.C6_TES = F4.F4_CODIGO) "
cQuery += "INNER JOIN "+RetSqlName("SB1")+" B1 ON (C6.C6_PRODUTO = B1.B1_COD) "
cQuery += "WHERE C6.D_E_L_E_T_ = '' AND C5.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND B1.D_E_L_E_T_ = '' "
cQuery += "AND NOT C5.C5_TIPO IN ('B','D') AND F4.F4_DUPLIC='S' AND C6.C6_BLQ<>'R' AND C6.C6_QTDVEN>C6.C6_QTDENT "
If !Empty(cBrCfFat)
	cQuery += "AND C6.C6_CF IN ("+cBrCfFat+") "
Endif
If !Empty(cBrCfNFat)
	cQuery += "AND C6.C6_CF NOT IN ("+cBrCfNFat+") "
Endif
If !Empty(cBrTsFat)
	cQuery += "AND C6.C6_TES IN ("+cBrTsFat+") "
Endif
If !Empty(cBrTsNFat)
	cQuery += "AND C6.C6_TES NOT IN ("+cBrTsNFat+") "
Endif
cQuery := ChangeQuery(cQuery)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery NEW ALIAS "MAR"
TCSetField("MAR","C6_ENTREG","D",08,0)
aTotal := {0,0,0,0,0,0,0}
dbSelectArea("MAR")
While !MAR->(Eof())
	nValor := (MAR->C6_saldo*MAR->C6_prcven)
	If (MAR->C5_moeda != 1)
		nValor := xMoeda(nValor,MAR->C5_moeda,1,dDatabase)
	Endif
	If (MAR->C6_entreg <= dData)
		aTotal[1] += nValor
	Elseif (MAR->C6_entreg == (dData+1))
		aTotal[2] += nValor
	Elseif (Left(dtos(MAR->C6_entreg),6) == Left(dtos(dData),6))
		aTotal[3] += nValor
	Elseif (Left(dtos(MAR->C6_entreg),6) == Left(dtos(dData1M),6))
		aTotal[4] += nValor
	Elseif (Left(dtos(MAR->C6_entreg),6) == Left(dtos(dData2M),6))
		aTotal[5] += nValor
	Endif     
	aTotal[6] += nValor
	MAR->(dbSkip())
Enddo
oProcess:oHtml:ValByName("PEDATR" ,cSimb+" "+Transform(aTotal[1],PesqPict("SC6","C6_VALOR"))) //Pedidos Atraso
oProcess:oHtml:ValByName("PEDAMA" ,cSimb+" "+Transform(aTotal[2],PesqPict("SC6","C6_VALOR"))) //Pedidos Amanha
oProcess:oHtml:ValByName("PEDMES" ,cSimb+" "+Transform(aTotal[3],PesqPict("SC6","C6_VALOR"))) //Pedidos Mes Atual
oProcess:oHtml:ValByName("PED1ME" ,cSimb+" "+Transform(aTotal[4],PesqPict("SC6","C6_VALOR"))) //Pedidos 1 Mes
oProcess:oHtml:ValByName("PED2ME" ,cSimb+" "+Transform(aTotal[5],PesqPict("SC6","C6_VALOR"))) //Pedidos 2 Meses
oProcess:oHtml:ValByName("PEDTOT" ,cSimb+" "+Transform(aTotal[6],PesqPict("SC6","C6_VALOR"))) //Pedidos Total

//Faturamento Histórico
///////////////////////                      
dDatAux := stod(Strzero(Year(dData),4)+"0101")
dDatFim := LastDay(dData+31) //Ultimo Dia
While (dDatAux <= dDatFim)

	nMes := Month(dDatAux) ; nAno := Year(dDatAux)

	//Faturamento Ano Anterior
	//////////////////////////
	cQuery := "SELECT SUM(D2.D2_VALBRUT) D2_VALBRUT "
	cQuery += "FROM "+RetSqlName("SD2")+" D2 INNER JOIN "+RetSqlName("SF4")+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery += "WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND NOT D2.D2_TIPO IN ('B','D') AND F4.F4_DUPLIC = 'S' "
	cQuery += "AND D2.D2_EMISSAO BETWEEN '"+Strzero(nAno-1,4)+Strzero(nMes,2)+"01' AND '"+Strzero(nAno-1,4)+Strzero(nMes,2)+"99' "
	cQuery += "AND D2.D2_EMISSAO <= '"+dtos(dData)+"' "
	If !Empty(cBrCfFat)
		cQuery += "AND D2.D2_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery += "AND D2.D2_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
	Endif
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	nFatAnt := 0
	dbSelectArea("MAR")
	If !MAR->(Eof())
		nFatAnt := MAR->D2_valbrut
	Endif

	//Faturamento Ano Atual
	///////////////////////
	cQuery := "SELECT SUM(D2.D2_VALBRUT) D2_VALBRUT "
	cQuery += "FROM "+RetSqlName("SD2")+" D2 INNER JOIN "+RetSqlName("SF4")+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
	cQuery += "WHERE D2.D_E_L_E_T_ = '' AND F4.D_E_L_E_T_ = '' AND NOT D2.D2_TIPO IN ('B','D') AND F4.F4_DUPLIC = 'S' "
	cQuery += "AND D2.D2_EMISSAO BETWEEN '"+Strzero(nAno,4)+Strzero(nMes,2)+"01' AND '"+Strzero(nAno,4)+Strzero(nMes,2)+"99' "
	cQuery += "AND D2.D2_EMISSAO <= '"+dtos(dData)+"' "
	If !Empty(cBrCfFat)
		cQuery += "AND D2.D2_CF IN ("+cBrCfFat+") "
	Endif
	If !Empty(cBrCfNFat)
		cQuery += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
	Endif
	If !Empty(cBrTsFat)
		cQuery += "AND D2.D2_TES IN ("+cBrTsFat+") "
	Endif
	If !Empty(cBrTsNFat)
		cQuery += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
	Endif
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	nFatAtu := 0
	dbSelectArea("MAR")
	If !MAR->(Eof())
		nFatAtu := MAR->D2_valbrut
	Endif

	//Devolucao Ano Anterior
	////////////////////////
	cQuery := "SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) D1_VALDEV FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_='') "
	cQuery += "WHERE SD1.D_E_L_E_T_='' AND SF4.F4_DUPLIC = 'S' AND SD1.D1_DTDIGIT <= '"+dtos(dData)+"' "
	cQuery += "AND SD1.D1_DTDIGIT BETWEEN '"+Strzero(nAno-1,4)+Strzero(nMes,2)+"01' AND '"+Strzero(nAno-1,4)+Strzero(nMes,2)+"99' "
	cQuery += "AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411') " //CFOPs de Devolucao
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	nDevAnt := 0
	dbSelectArea("MAR")
	If !MAR->(Eof())
		nDevAnt := MAR->D1_valdev
	Endif	

	//Devolucao Ano Anterior
	////////////////////////
	cQuery := "SELECT SUM(D1_TOTAL+D1_ICMSRET+D1_VALFRE+D1_VALIPI-D1_VALDESC) D1_VALDEV FROM "+RetSqlName("SD1")+" SD1 "
	cQuery += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SD1.D1_TES AND SF4.D_E_L_E_T_='') "
	cQuery += "WHERE SD1.D_E_L_E_T_='' AND SF4.F4_DUPLIC = 'S' AND SD1.D1_DTDIGIT <= '"+dtos(dData)+"' "
	cQuery += "AND SD1.D1_DTDIGIT BETWEEN '"+Strzero(nAno,4)+Strzero(nMes,2)+"01' AND '"+Strzero(nAno,4)+Strzero(nMes,2)+"99' "
	cQuery += "AND SD1.D1_CF IN ('1201','2201','1202','2202','1203','2203','1204','2204','1410','2503','2410','1411','2411') " //CFOPs de Devolucao
	cQuery := ChangeQuery(cQuery)
	If (Select("MAR") <> 0)
		dbSelectArea("MAR")
		dbCloseArea()
	Endif
	TCQuery cQuery NEW ALIAS "MAR"
	nDevAtu := 0
	dbSelectArea("MAR")
	If !MAR->(Eof())
		nDevAtu := MAR->D1_valdev
	Endif	

	//Gero Informacoes no Html
	//////////////////////////
	aadd(oProcess:oHtml:ValByName("IT1.PERANT")   ,Alltrim(MesExtenso(nMes))+"/"+Strzero(nAno-1,4))
	aadd(oProcess:oHtml:ValByName("IT1.FATANT")   ,cSimb+" "+Transform(nFatAnt,PesqPict("SD2","D2_VALBRUT")))
	aadd(oProcess:oHtml:ValByName("IT1.DEVANT")   ,cSimb+" "+Transform(nDevAnt,PesqPict("SD1","D1_TOTAL")))
	aadd(oProcess:oHtml:ValByName("IT1.PERATU")   ,Alltrim(MesExtenso(nMes))+"/"+Strzero(nAno,4))
	aadd(oProcess:oHtml:ValByName("IT1.FATATU")   ,cSimb+" "+Transform(nFatAtu,PesqPict("SD2","D2_VALBRUT")))
	aadd(oProcess:oHtml:ValByName("IT1.DEVATU")   ,cSimb+" "+Transform(nDevAtu,PesqPict("SD1","D1_TOTAL")))
	If !Empty(nFatAnt)
		nEvo := ((nFatAtu/nFatAnt)-1)*100  
		If (nEvo > 0)
			aadd(oProcess:oHtml:ValByName("IT1.EVO") ,"<font color='green'>"+Transform(nEvo,"@E 999,999.999")+" % </font>")
		Elseif (nEvo < 0)
			aadd(oProcess:oHtml:ValByName("IT1.EVO") ,"<font color='red'>"+Transform(nEvo,"@E 999,999.999")+" % </font>")
		Else
			aadd(oProcess:oHtml:ValByName("IT1.EVO") ,Transform(nEvo,"@E 999,999.999"))
		Endif
	Else
		aadd(oProcess:oHtml:ValByName("IT1.EVO") ,Transform(0,"@E 999,999.999"))
	Endif                                     

	dDatAux := LastDay(dDatAux)+1
Enddo

//Envio email
/////////////
oProcess:Start()
oProcess:Finish()

If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

conout("=============================================================")
conout("Fim do Processo para avisar sobre Faturamento Diário - "+dtoc(MsDate()))
conout(" ")

Return
