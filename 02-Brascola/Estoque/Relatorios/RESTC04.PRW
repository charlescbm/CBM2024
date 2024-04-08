#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"   
#INCLUDE "TopConn.ch" 

#DEFINE  cEOL     CHR(13)+CHR(10)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESTC04  ³ Autor ³                          ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de ultimas notas fiscais                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTC04()  

Local 	aRegs		:= {}
Local 	cPerg		:= U_CriaPerg("ESTC04")

aAdd(aRegs,{cPerg,"01","Data Inicial?"	 			,"","","mv_ch1","D",08,0,0,"G","","mv_par01",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"02","Data Final?"    			,"","","mv_ch2","D",08,0,0,"G","","mv_par02",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"03","Considera Tipo Produto :"	,"","","mv_ch3","C",30,0,0,"G","","mv_par03",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
aAdd(aRegs,{cPerg,"04","Desconsidera TES"			,"","","mv_ch4","C",30,0,0,"G","","mv_par04",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aRegs,{cperg,"05","Totaliza Complementos?"		,"","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim"     ,"","","","","Nao"	,"","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aRegs,{cPerg,"06","Produto De ?"      			,"","","mv_ch6","C",15,0,0,"G","","mv_par06",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})
Aadd(aRegs,{cPerg,"07","Produto Até?"      			,"","","mv_ch7","C",15,0,0,"G","","mv_par07",""        ,"","","","",""    ,"","","","","","","","","","","","","","","","","","","SB1","","","",""})

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf                                                

MSGRUN("Aguarde....","Processando",{ || u_RESTC041()})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³          ³ Autor ³                          ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Consulta de Faturamento por Produto                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RESTC041(aPar)

Local cQuery		:= ""
Local cAlias		:= "TRB"
Local cTipos		:= "" 

//Valor de custo retornado por esta funcao quando for utilizada por um
//programa que aproveita este codigo       
Local nRet  		:= 0  

Private _mv_par01 := mv_par01   //Data Inicio
Private _mv_par02 := mv_par02   //Data Final
Private _mv_par03 := mv_par03   //Considera Tipo de Produto
Private _mv_par04 := mv_par04   //Desconsidera TES
Private _mv_par05 := mv_par05   //Totaliza Complementos 
Private _mv_par08 := mv_par08   //Totaliza Complementos 

Private lSint    						//Verifica se o resultado sera totalizando os valores de 
Private lProdUni  					//Verifica se sera pesquisado apenas um produto     
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento dos parametros quando a funcao for chamada por   ³
//|algum programa que esta aproveitando o codigo.              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
/*
If !Upper(AllTrim(FunName())) == "RESTC04"
	_mv_par01 := ctod("01/01/01")
	_mv_par02 := apar[3]
	_mv_par03 := ""
	//_mv_par04 := "060/039/094/008"
	_mv_par04 := apar[4]
	_mv_par05 := 1
	//Indica que o codigo esta sendo aproveitando
	lProdUni := .t.
EndIf
 */
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se ira totalizar os complementos  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lSint := If(_mv_par05==1,.T.,.F.)
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Selecao de itens do mercado INTERNO somente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery := " SELECT D1_TES, D1_NUMSEQ, D1_COD, B1_DESC, D1_DOC, D1_SERIE, D1_TP TIPOPROD, D1_DTDIGIT, D1_FORNECE, D1_CF  "+cEOL
//cQuery := " SELECT D1_TES, D1_NUMSEQ, D1_COD, B1_DESC, D1_DOC, D1_SERIE, D1_TP TIPOPROD,RTRIM(CONVERT(CHAR,CONVERT(DATETIME,(SUBSTRING(D1_DTDIGIT,1,4)+'-'+SUBSTRING(D1_DTDIGIT,5,2)+'-'+SUBSTRING(D1_DTDIGIT,7,2))),103)) AS D1_DTDIGIT , D1_FORNECE, D1_CF  "+cEOL
cQuery += " FROM "+RetSQLName("SD1")+" SD1, "+RetSQLName("SB1")+" SB1"+cEOL
//cQuery += " WHERE D1_FILIAL = '"+xFilial(dbSelectArea("SD1"))+"'"+cEOL						// ZANARDO 25/04/08
//cQuery += " AND D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL		// ZANARDO 25/04/08
cQuery += " WHERE D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL
cQuery += " AND D1_TIPO = 'N'"+cEOL
cQuery += " AND D1_QUANT > 0"+cEOL 
If !lProdUni
	cQuery += " AND D1_TP IN ('"+StrTran(_MV_PAR03,"/","','")+"')"+cEOL 
EndIf
//If Len(AllTrim(_mv_par04))>0
	cQuery += " AND D1_TES IN (SELECT F4_CODIGO FROM SF4010 WHERE F4_UPRC = 'S' AND F4_CODIGO <'501' AND SF4010.D_E_L_E_T_ = '')"+cEOL
  
//EndIf
cQuery += " AND SD1.D_E_L_E_T_ <> '*'"+cEOL
cQuery += " AND D1_DTDIGIT+D1_NUMSEQ = ISNULL((	SELECT MAX(D1_DTDIGIT+D1_NUMSEQ) FROM "+RetSQLName("SD1")+" SD12 "+cEOL
//cQuery += " 									WHERE SD12.D1_FILIAL = SD1.D1_FILIAL"+cEOL														// ZANARDO 25/04/08
//cQuery += " 			  						AND SD12.D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL				// ZANARDO 25/04/08
cQuery += " 			  						WHERE SD12.D1_DTDIGIT BETWEEN '"+dtos(_mv_par01)+"' AND '"+dtos(_mv_par02)+"'"+cEOL
cQuery += " 									AND SD12.D1_COD = SD1.D1_COD"+cEOL
cQuery += " 			  						AND SD12.D1_TIPO = 'N'"+cEOL
cQuery += " 									AND SD12.D1_QUANT > 0"+cEOL 

If !lProdUni
   cQuery += "                                  AND D1_TP IN ('"+StrTran(_MV_PAR03,"/","','")+"')"+cEOL 
EndIf
//If Len(AllTrim(_mv_par04))>0      
   //	cQuery += "                                 AND D1_TES IN ('"+StrTran(_MV_PAR04,"/","','")+"')"+cEOL
	cQuery += " AND D1_TES IN (SELECT F4_CODIGO FROM SF4010 WHERE F4_UPRC = 'S' AND F4_CODIGO <'501' AND SF4010.D_E_L_E_T_ = '')"+cEOL
  

If lProdUni
	cQuery += "                                 AND B1_COD = '"+aPar[1]+"'"
EndIf

cQuery += " AND SD12.D_E_L_E_T_ <> '*'), ' ')"+cEOL
//cQuery += " AND B1_FILIAL = '  '"+cEOL						// ZANARDO 25/04/08
cQuery += " AND B1_COD = D1_COD"+cEOL
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"+cEOL

If lProdUni
	cQuery += " AND B1_COD = '"+aPar[1]+"'"
Else
   //Filtra o intervalo dos produtos
   cQuery += " AND D1_COD >= '"+mv_par06+"'"+cEOL
   cQuery += " AND D1_COD <= '"+mv_par07+"'"+cEOL
EndIf

cQuery += " ORDER BY D1_COD"+cEOL

MemoWrite("\QUERYSYS\RESTC04.SQL",cQuery)
                                          
If Select("TRB")>0
	dbSelectArea("TRB")
	TRB->(dbCloseArea("TRB"))
EndIf
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.F.,.T.)   
           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a rotina NAO foi chamada por um programa que esá reaproveitando           ³
//³o codigo para chegar no ultimo custo de entrada, exibe o5s dados no EXCEL     ³
//³caso afirmativo, grava o valor do custo de entrada da unica linha TRB->TOTAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lProdUni
	nRet := ArqTemp()
Else
	ArqTemp()
EndIf

TRB->(DBClosearea())

Return nRet


************************************
*//Gera arquivo temporario             
************************************
Static Function ArqTemp()

Local aStruc := {}
Local aCompl := {}
Local nRet   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo temporario. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aStruc,{"D1_TES",			"C",03,00})
Aadd(aStruc,{"D1_NUMSEQ",		"C",06,00})
Aadd(aStruc,{"D1_COD",			"C",15,00})
Aadd(aStruc,{"B1_DESC",			"C",40,00})
Aadd(aStruc,{"D1_DOC",			"C",09,00})
Aadd(aStruc,{"D1_SERIE",		"C",03,00})
Aadd(aStruc,{"TIPOPROD",		"C",02,00})
Aadd(aStruc,{"D1_DTDIGIT",		"D",08,00})
Aadd(aStruc,{"D1_FORNECE",		"C",06,00})
Aadd(aStruc,{"D1_QUANT",		"N",16,02})
Aadd(aStruc,{"D1_VUNIT",		"N",16,02})
Aadd(aStruc,{"D1_TOTAL",		"N",16,02})
Aadd(aStruc,{"ICM",				"N",16,02})
Aadd(aStruc,{"IPI",				"N",16,02})
Aadd(aStruc,{"PIS",				"N",16,02})
Aadd(aStruc,{"COFINS",			"N",16,02})
Aadd(aStruc,{"ULTPRC",			"N",16,02})
Aadd(aStruc,{"TIPO",			"C",01,00})

cArqTRB := CriaTrab(aStruc,.T.)
dbUseArea(.T.,,cArqTRB, "TRBX",.F.,.F.)
                                                           
dbSelectArea("TRB")      
dbGoTop()
While !Eof()                                
//IF TRB->D1_COD <> '1160018        '
//DBSKIP()
//LOOP                   
//ENDIF

//		VR1:=SUBSTR(TRB->D1_DTDIGIT,5,2)+'/'+SUBSTR(TRB->D1_DTDIGIT,7,2)+'/'+SUBSTR(TRB->D1_DTDIGIT,3,2)
		dbSelectArea("TRBX")
  		RecLock("TRBX",.T.)
		TRBX->D1_TES			:= TRB->D1_TES
		TRBX->D1_NUMSEQ			:= TRB->D1_NUMSEQ
		TRBX->D1_COD 			:= TRB->D1_COD
		TRBX->B1_DESC			:= TRB->B1_DESC
		TRBX->D1_DOC			:= TRB->D1_DOC
		TRBX->D1_SERIE 			:= TRB->D1_SERIE
		TRBX->TIPOPROD 			:= TRB->TIPOPROD
		TRBX->D1_DTDIGIT 		:= STOD(TRB->D1_DTDIGIT)
//		TRBX->D1_DTDIGIT 		:= CTOD(VR1)
		TRBX->D1_FORNECE		:= TRB->D1_FORNECE 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Insere os valores sumarizados por nota fiscal                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		cQuery := " SELECT 	LEFT(D1_CF,1) AS CFO, "+cEOL
		cQuery += " 			SUM(D1_QUANT) 		D1_QUANT, "+cEOL
		cQuery += " 			SUM(D1_VUNIT) 		D1_VUNIT, "+cEOL
		cQuery += " 			SUM(D1_TOTAL) 		D1_TOTAL, "+cEOL
		cQuery += "				SUM(D1_VALICM) 	    ICM, "+cEOL
		cQuery += " 			SUM(D1_VALIPI) 	    IPI, "+cEOL
		cQuery += " 			SUM(D1_VALIMP5)	    PIS, "+cEOL
		cQuery += "				SUM(D1_VALIMP6) 	COFINS "+cEOL
		//cQuery += "				,SUM((D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6) / CASE WHEN D1_QUANT=0 THEN 1 ELSE D1_QUANT END) ULTPRC "+cEOL
		cQuery += "	FROM "+RetSQLName("SD1")+" SD1 "+cEOL
//		cQuery += " WHERE "
//		cQuery += "     D1_FILIAL 			= '"+xFilial(dbSelectArea("SD1"))+"'"+cEOL					// ZANARDO 25/04/08
//		cQuery += " AND D1_FORNECE 	        = '"+TRB->D1_FORNECE+"'"+cEOL                				// ZANARDO 25/04/08
		cQuery += " WHERE D1_FORNECE 	        = '"+TRB->D1_FORNECE+"'"+cEOL
		cQuery += " AND D1_DOC 				= '"+TRB->D1_DOC+"'"+cEOL
		cQuery += " AND D1_SERIE 			= '"+TRB->D1_SERIE+"'"+cEOL 
		cQuery += " AND D1_COD				= '"+TRB->D1_COD+"'"+cEOL
		cQuery += " AND SD1.D_E_L_E_T_	= ''"+cEOL
		cQuery += " GROUP BY LEFT(D1_CF,1) "  
		If Select("TRB2")>0
  			dbSelectArea("TRB2")
			TRB->(dbCloseArea("TRB2"))
		EndIf
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB2",.F.,.T.)   

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Insere valores referentes a notas fiscais de Complemento, se houveram³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//		aCompl := VrComp(xFilial("SD1"),TRB->D1_FORNECE,TRB->D1_COD,TRB->D1_DOC,TRB->D1_SERIE)    
		aCompl := VrComp(TRB->D1_FORNECE,TRB->D1_COD,TRB->D1_DOC,TRB->D1_SERIE)    
						
 		If lSint
			TRBX->D1_QUANT      := TRB2->D1_QUANT	+ aCompl[01,09]
			TRBX->D1_VUNIT      := TRB2->D1_VUNIT	+ aCompl[01,10]
			TRBX->D1_TOTAL      := TRB2->D1_TOTAL	+ aCompl[01,11]
			TRBX->ICM           := TRB2->ICM		+ aCompl[01,12]
			TRBX->IPI           := TRB2->IPI 		+ aCompl[01,13]
			TRBX->PIS           := TRB2->PIS 		+ aCompl[01,14]
			TRBX->COFINS        := TRB2->COFINS	+ aCompl[01,15]
			TRBX->ULTPRC        := TRB2->(D1_TOTAL-ICM-PIS-COFINS +aCompl[01,16]) / TRB2->D1_QUANT   //TRB2->(D1_TOTAL-IIF(CFO=='3',0,ICM+PIS+COFINS)+aCompl[01,16]) / TRB2->D1_QUANT
			TRBX->TIPO          := "N"
	  		MsUnlock()          
		Else
			TRBX->D1_QUANT      := TRB2->D1_QUANT
			TRBX->D1_VUNIT      := TRB2->D1_VUNIT
			TRBX->D1_TOTAL      := TRB2->D1_TOTAL
			TRBX->ICM           := TRB2->ICM
			TRBX->IPI           := TRB2->IPI
			TRBX->PIS           := TRB2->PIS
			TRBX->COFINS        := TRB2->COFINS
			TRBX->ULTPRC        := TRB2->(D1_TOTAL-ICM-PIS-COFINS) / TRB2->D1_QUANT//TRB2->(D1_TOTAL-IIF(CFO=='3',0,ICM+PIS+COFINS)) / TRB2->D1_QUANT
			TRBX->TIPO          := "N" 
			MsUnlock()
	    		                                                                 
			For ix:=2 To Len(aCompl)
				RecLock("TRBX",.T.)
				TRBX->D1_TES     := aCompl[ix,01]
				TRBX->D1_NUMSEQ  := aCompl[ix,02]
				TRBX->D1_COD     := aCompl[ix,03]
				TRBX->B1_DESC    := TRB->B1_DESC
				TRBX->D1_DOC     := aCompl[ix,04]
				TRBX->D1_SERIE   := aCompl[ix,05]
				TRBX->TIPOPROD   := aCompl[ix,06]
				TRBX->D1_DTDIGIT := STOD(aCompl[ix,07])
				TRBX->D1_FORNECE := aCompl[ix,08]
				TRBX->D1_QUANT   := aCompl[ix,09]
				TRBX->D1_VUNIT   := aCompl[ix,10]
				TRBX->D1_TOTAL   := aCompl[ix,11]
				TRBX->ICM        := aCompl[ix,12]
				TRBX->IPI        := aCompl[ix,13]
				TRBX->PIS        := aCompl[ix,14]
				TRBX->COFINS     := aCompl[ix,15]
				TRBX->ULTPRC     := aCompl[ix,16]
				TRBX->TIPO       := "C"
				MsUnlock()
			Next
		
		EndIf
		
	dbSelectArea("TRB2")
	TRB2->(dbCloseArea())		

	dbSelectArea("TRB")		      
	TRB->(dbSkip())
EndDo               
                        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se a rotina NAO foi chamada por um programa que esta' reaproveitando         ³
//³o codigo para chegar no ultimo custo de entrada, exibe os dados no EXCEL     ³
//³caso afirmativo, grava o valor do custo de entrada da unica linha TRB->TOTAL ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lProdUni
	u_ProcExcel("TRBX")
Else
   nRet := TRBX->ULTPRC
EndIf

TRBX->(dbCloseArea())                   	

Ferase(cArqTRB)

Return(nRet)

***********************************
*//verifica os valores de complementos
************************************
//Static Function VrComp(_cFilial,cFornece,cProd,cDoc,cSerie)		// ZANARDO 25/04/08
Static Function VrComp(cFornece,cProd,cDoc,cSerie)
Local cQuery := ""
Local aRet   := {}

aAdd(aRet,{"","","","","","","","",0,0,0,0,0,0,0,0})

cQuery := " SELECT 	    D1_TES, D1_NUMSEQ, D1_COD, D1_DOC, D1_SERIE, D1_TP TIPOPROD, D1_DTDIGIT, D1_FORNECE, D1_QUANT, "+cEOL
cQuery += "             D1_VUNIT, D1_TOTAL, D1_VALICM ICM, D1_VALIPI IPI, D1_VALIMP5 PIS, D1_VALIMP6 COFINS, "+cEOL
cQuery += "             ((D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6) / CASE WHEN D1_QUANT=0 THEN 1 ELSE D1_QUANT END ) ULTPRC "+cEOL
cQuery += " FROM "+RetSQLName("SD1")+" SD1 "+cEOL
//cQuery += " WHERE "+cEOL													// ZANARDO 25/04/08
//cQuery += " (   D1_FILIAL 		= '"+_cFilial+"'"+cEOL					// ZANARDO 25/04/08
//cQuery += " AND D1_FORNECE	 	= '"+cFornece+"'"+cEOL					// ZANARDO 25/04/08
cQuery += " WHERE (D1_FORNECE	 	= '"+cFornece+"'"+cEOL
cQuery += " AND D1_NFORI 		= '"+cDoc+"'"+cEOL                         
cQuery += " AND D1_COD			= '"+cProd+"'"+cEOL
cQuery += " AND D1_TIPO 		= 'C' "+cEOL
cQuery += " AND SD1.D_E_L_E_T_ <> '*' "+cEOL
cQuery += " ) OR ( "
cQuery += "     D1_DOC+D1_SERIE IN (	SELECT F8_NFDIFRE+F8_SEDIFRE "+cEOL
cQuery += " 									FROM "+RetSQLName("SF8")+" SF8 "+cEOL
cQuery += " 									WHERE F8_FORNECE+F8_NFORIG IN ('"+cFornece+cDoc+"')"+cEOL
cQuery += " 									AND SF8.D_E_L_E_T_='') "+cEOL
cQuery += " AND SD1.D_E_L_E_T_  = '' "
cQuery += " AND D1_COD          = '"+cProd+"'"
cQuery += " ) "


// ZANARDO 25/04/08
/*cQuery += "     D1_FILIAL+D1_DOC+D1_SERIE IN (	SELECT F8_FILIAL+F8_NFDIFRE+F8_SEDIFRE "+cEOL
cQuery += " 									FROM "+RetSQLName("SF8")+" SF8 "+cEOL
cQuery += " 									WHERE F8_FILIAL+F8_FORNECE+F8_NFORIG IN ('"+_cFilial+cFornece+cDoc+"')"+cEOL
cQuery += " 									AND SF8.D_E_L_E_T_='') "+cEOL
cQuery += " AND SD1.D_E_L_E_T_  = '' "
cQuery += " AND D1_COD          = '"+cProd+"'"
cQuery += " ) "
*/

                                            
If Select("TRBSQL")>0
	dbSelectArea("TRBSQL")
	TRBSQL->(dbCloseArea("TRBSQL"))
EndIf                                               
       
cQuery := ChangeQuery(cQuery)
MemoWrite("\QUERYSYS\RESTC04_VrComp.SQL",cQuery)
TCQUERY cQuery NEW ALIAS "TRBSQL"  
                                                                                                    
dbSelectArea("TRBSQL")
dbGoTop()
While !Eof() 
			                     
		If lSint    
			aRet[01,01] := 0
			aRet[01,02] := 0
			aRet[01,03] := 0
			aRet[01,04] := 0
			aRet[01,05] := 0
			aRet[01,06] := 0
			aRet[01,07] := 0
			aRet[01,08] := 0
			aRet[01,09] := If(aRet[01,09]==Nil,0,aRet[01,09]+TRBSQL->D1_QUANT)
			aRet[01,10] := If(aRet[01,10]==Nil,0,aRet[01,10]+TRBSQL->D1_VUNIT) 
			aRet[01,11] := If(aRet[01,11]==Nil,0,aRet[01,11]+TRBSQL->D1_TOTAL) 
			aRet[01,12] := If(aRet[01,12]==Nil,0,aRet[01,12]+TRBSQL->ICM) 
			aRet[01,13] := If(aRet[01,13]==Nil,0,aRet[01,13]+TRBSQL->IPI) 
			aRet[01,14] := If(aRet[01,14]==Nil,0,aRet[01,14]+TRBSQL->PIS) 
			aRet[01,15] := If(aRet[01,15]==Nil,0,aRet[01,15]+TRBSQL->COFINS) 
			aRet[01,16] := If(aRet[01,16]==Nil,0,aRet[01,16]+TRBSQL->ULTPRC) 
		Else                                
			aAdd(aRet,{		TRBSQL->D1_TES,;
							TRBSQL->D1_NUMSEQ,;
							TRBSQL->D1_COD,;
							TRBSQL->D1_DOC,;
							TRBSQL->D1_SERIE,;
							TRBSQL->TIPOPROD,;
							TRBSQL->D1_DTDIGIT,;
							TRBSQL->D1_FORNECE,;
							TRBSQL->D1_QUANT,;
							TRBSQL->D1_VUNIT,;
							TRBSQL->D1_TOTAL,;
							TRBSQL->ICM,;
							TRBSQL->IPI,;
							TRBSQL->PIS,;
							TRBSQL->COFINS,;
							TRBSQL->ULTPRC})			
		Endif

		TRBSQL->(dbSkip())
EndDo  

TRBSQL->(dbCloseArea())

Return(aRet)   