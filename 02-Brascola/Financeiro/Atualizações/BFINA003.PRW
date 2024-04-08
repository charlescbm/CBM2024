#INCLUDE "rwmake.ch"                        
#INCLUDE 'TOPCONN.CH'
  
/*/
----------------------------------------------------------------------------
PROGRAMA: BFINA003         AUTOR: CHARLES MEDEIROS         DATA: 23/03/12
----------------------------------------------------------------------------

DESCRICAO: PROGRAMA QUE IMPORTA PLANILHA EM EXCEL COMPARA COM SF3,SF2,SD1
----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFINA003() 

Local cPERG := "BFINA003"    

U_BCFGA002("BFINA003")//Grava detalhes da rotina usada

PRIVATE  aArray :=  {}
	
dbSelectArea("SX1")
dbSetOrder(1)
If !dbseek(cPerg)
	//	PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03		,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01"	  ,"Nome do Arquivo    ?","",""	,"mv_ch1","C"  ,20,0,0		   ,"G" ,""			,""		,""		 ,""	,"mv_par01"	,""    ,""		,""		 ,""	,""		,""		 ,""	  ,""	 		,""	  	 ,""	   	,""			,""		,""			,""			,""		 ,""		,{""},{""},{""})
Endif

If !Pergunte(cPerg,.T.)
	Return
Endif
	        
Processa({ || BFINA003a()}, "Aguarde",,.t.)  

Processa({ || fImprimir()}, "Aguarde",,.t.)   

msgalert(" Rsultado Concluído ")

Return  


Static Function BFINA003a()
*********************************                     
//PRIVATE  aArray :=  {}

cQuery := "SELECT * "
cQuery += "FROM OpenRowSet('Microsoft.Jet.OLEDB.4.0', 'Excel 8.0;DATABASE=c:\import\"+ALLTRIM(mv_par01)+"','Select * from [Plan1$]') "
cQuery += "WHERE NOTA <> '' "
//cQuery += "GROUP BY NOTA, DATA" 
//cQuery := ChangeQuery(cQuery)

If (Select("CHA") <> 0)
	dbSelectArea("CHA")
	dbCloseArea()
Endif

TCQUERY cQuery new alias "CHA" 

//TCSetField("CHA","DATA","D",08,0)

DbSelectArea("CHA")
DbGoTop()
While CHA->(!Eof()) .AND. !EMPTY(CHA->NOTA)

	If SUBSTR(CHA->NOTA,1,1) == '7'
		
		If SUBSTR(CHA->NOTA,3,6) <= '006517'     
			
			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////
			cQuery1 := "SELECT * FROM DADOS10.dbo.SF3020 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery1 += "AND F3_FILIAL = '01' " 
			
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
		                                    			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM DADOS10.dbo.SF2020 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery2 += "AND F2_FILIAL = '01' " 
			
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    			
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM DADOS10.dbo.SD1020 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery3 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"  
		                                    			
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery4 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"  
		                                    
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			
				
		    CHA->(DBSKIP())
	
		Else
		
			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////
			cQuery1 := "SELECT * FROM SF3010 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery1 += "AND F3_FILIAL = '01' " 
		
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
		                                    			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM SF2010 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery2 += "AND F2_FILIAL = '01' " 
	
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM DADOS10.dbo.SD1020 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery3 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"                                  
			
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery4 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"  
		                                    
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			    
	
		    CHA->(DBSKIP())
		
		Endif   
	
	Else
	
		If SUBSTR(CHA->NOTA,3,6) > '004979' .and.  SUBSTR(CHA->NOTA,3,6) < '014051' 
		
			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////
			cQuery1 := "SELECT * FROM DADOS10.dbo.SF3020 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery1 += "AND F3_FILIAL = '03' " 
			
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM DADOS10.dbo.SF2020 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery2 += "AND F2_FILIAL = '03' " 
			
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM DADOS10.dbo.SD1020 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery3 += "AND D1_FILIAL = '03' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"  
			
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery4 += "AND D1_FILIAL = '03' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"  
		                                    
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			
				
		    CHA->(DBSKIP())
		
		ElseIf SUBSTR(CHA->NOTA,3,6) > '035167' .and.  SUBSTR(CHA->NOTA,3,6) < '061920'   
		
			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////   
		   
			cQuery1 := "SELECT * FROM DADOS10.dbo.SF3020 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery1 += "AND F3_FILIAL = '04' " 
			
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM DADOS10.dbo.SF2020 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery2 += "AND F2_FILIAL = '04' " 
			
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM DADOS10.dbo.SD1020 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery3 += "AND D1_FILIAL = '04' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery4 += "AND D1_FILIAL = '04' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"  
		                                    
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			
				
		    CHA->(DBSKIP())

		
		ElseIf SUBSTR(CHA->NOTA,3,9) > '000014099' .and.  SUBSTR(CHA->NOTA,3,9) < '000014862'

			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////   
		   
			cQuery1 := "SELECT * FROM SF3010 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,9)+ "' "    
			cQuery1 += "AND F3_FILIAL = '03' " 
			
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM SF2010 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,9)+ "' "    
			cQuery2 += "AND F2_FILIAL = '03' " 
			
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    
		
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,9)+ "' "    
			cQuery3 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"  
		                                    
			
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,9)+ "' "    
			cQuery4 += "AND D1_FILIAL = '03' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"  
		                                    
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			
				
		    CHA->(DBSKIP())      
		
		ElseIf SUBSTR(CHA->NOTA,3,6) > '014052' .and.  SUBSTR(CHA->NOTA,3,6) < '014098'


			///////////////////////////////////////////////////////////// VERIFICAR SF3 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////   
		   
			cQuery1 := "SELECT * FROM SF3010 F3 WHERE F3.D_E_L_E_T_ <> '*' AND F3_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery1 += "AND F3_NFISCAL = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery1 += "AND F3_FILIAL = '03' " 
			
			If Select("CHA1") > 0
				DbSelectArea("CHA1")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery1 new alias "CHA1"  
			
		   ///////////////////////////////////////////////////////////// VERIFICAR SF2 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery2 := "SELECT * FROM SF2010 F2 WHERE F2.D_E_L_E_T_ <> '*' AND F2_SERIE = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery2 += "AND F2_DOC = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery2 += "AND F2_FILIAL = '03' " 
			
			If Select("CHA2") > 0
				DbSelectArea("CHA2")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery2 new alias "CHA2"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE ANTIGA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery3 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery3 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery3 += "AND D1_FILIAL = '01' " 
	
			If Select("CHA3") > 0
				DbSelectArea("CHA3")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery3 new alias "CHA3"  
		                                    
			///////////////////////////////////////////////////////////// VERIFICAR SD1 BASE NOVA
		   ////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
			cQuery4 := "SELECT * FROM SD1010 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_SERIORI = '"+SUBSTR(CHA->NOTA,1,1)+ "' " 
			cQuery4 += "AND D1_NFORI = '"+SUBSTR(CHA->NOTA,3,6)+ "' "    
			cQuery4 += "AND D1_FILIAL = '03' " 
	
			If Select("CHA4") > 0
				DbSelectArea("CHA4")
				DbCloseArea()
			Endif
			
			TCQUERY cQuery4 new alias "CHA4"
			
			aadd(Aarray,{CHA1->F3_FILIAL,CHA1->F3_NFISCAL,CHA1->F3_SERIE, CHA1->F3_OBSERV, CHA2->F2_DTSAIDA, CHA2->F2_EMISSAO, CHA3->D1_DOC, CHA3->D1_SERIE, CHA4->D1_DOC, CHA4->D1_SERIE})			
            
            CHA->(DBSKIP()) 
            
 		Else
 		
 			aadd(Aarray,{'Formato Invalido',CHA->NOTA,'Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido', 'Formato Invalido','Formato Invalido','Formato Invalido'})			
			
 			CHA->(DBSKIP()) 

	    Endif
	    
	    //aadd(Aarray,{'Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido','Formato Invalido', 'Formato Invalido','Formato Invalido','Formato Invalido'})			
	
	Endif 

EndDo   

Return  

///////////////////////////////////////FUNÇÃO DE IMPRIRMIR

Static Function fImprimir()      

Local oReport

If TRepInUse()	//verifica se relatorios personalizaveis esta disponivel
	oReport := ReportDef()
	oReport:PrintDialog()	
EndIf
Return

Static Function ReportDef()


Local oReport
Local oSection

oReport := TReport():New("BFINA003","Consulta Status da nota Fiscal importada",,{|oReport| PrintReport(oReport)},"Este relatorio ira imprimir O STATUS das notas do excel.")
oReport:SetTotalInLine(.F.)

oSection := TRSection():New(oReport,OemToAnsi("Consulta Status Notas"),)

TRCell():New(oSection,"FIL",,"Filial")
oSection:Cell("FIL"):SetSize(05)

TRCell():New(oSection,"DOC",,"Documento")
oSection:Cell("DOC"):SetSize(15)

TRCell():New(oSection,"SERIE",,"Serie")
oSection:Cell("SERIE"):SetSize(05)

TRCell():New(oSection,"OBS",,"Observacao")
oSection:Cell("OBS"):SetSize(30)

TRCell():New(oSection,"SAIDA",,"Dt.Saida")
oSection:Cell("SAIDA"):SetSize(25)

TRCell():New(oSection,"EMISSAO",,"Dt.Emissao")
oSection:Cell("EMISSAO"):SetSize(20)

TRCell():New(oSection,"NFENTA",,"NF.Dev.2011")
oSection:Cell("NFENTA"):SetSize(15)   

TRCell():New(oSection,"SRENTA",,"Sr.Dev.2011")
oSection:Cell("SRENTA"):SetSize(05)

TRCell():New(oSection,"NFENTN",,"NF.Dev.2012")
oSection:Cell("NFENTN"):SetSize(15)

TRCell():New(oSection,"SRENTN",,"Sr.Dev.2012")
oSection:Cell("SRENTN"):SetSize(05)

/*
TRFunction():New(oSection:Cell("QUANT"),NIL,"SUM",,,"@E 9,999,999.99",,.F.)
TRFunction():New(oSection:Cell("TOTAL"),NIL,"SUM",,,"@E 9,999,999.99",,.F.)
*/
Return oReport   

/////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////ALIMENTAR COM DADOS

Static Function PrintReport(oReport)

Local oSection := oReport:Section(1)

oReport:SetMeter(Len(Aarray))

oSection:Init()
	
For i:=1 to Len(Aarray)
	
	oReport:IncMeter()
	
	If oReport:Cancel()
		Exit
	EndIf
	
	oSection:Cell("FIL"):SetValue(Aarray[i,1])
	oSection:Cell("DOC"):SetValue(Aarray[i,2])
	oSection:Cell("SERIE"):SetValue(Aarray[i,3])
	oSection:Cell("OBS"):SetValue(Aarray[i,4])
	oSection:Cell("SAIDA"):SetValue(STOD(Aarray[i,5]))
	oSection:Cell("EMISSAO"):SetValue(STOD(Aarray[i,6]))
	oSection:Cell("NFENTA"):SetValue(Aarray[i,7])
	oSection:Cell("SRENTA"):SetValue(Aarray[i,8])
	oSection:Cell("NFENTN"):SetValue(Aarray[i,9])
	oSection:Cell("SRENTN"):SetValue(Aarray[i,10])

	oSection:Cell("FIL"):Show()
	oSection:Cell("DOC"):Show()
	oSection:Cell("SERIE"):Show()
	oSection:Cell("OBS"):Show()
	oSection:Cell("SAIDA"):Show()
	oSection:Cell("EMISSAO"):Show()
	oSection:Cell("NFENTA"):Show()
	oSection:Cell("SRENTA"):Show()
	oSection:Cell("NFENTN"):Show()
	oSection:Cell("SRENTN"):Show()

	oSection:PrintLine()

	oSection:Cell("FIL"):Hide()
	oSection:Cell("DOC"):Hide()
	oSection:Cell("SERIE"):Hide()
	oSection:Cell("OBS"):Hide()
	oSection:Cell("SAIDA"):Hide()
	oSection:Cell("EMISSAO"):Hide()
	oSection:Cell("NFENTA"):Hide()
	oSection:Cell("SRENTA"):Hide()
	oSection:Cell("NFENTN"):Hide()
	oSection:Cell("SRENTN"):Hide()

Next i
  
//	oSection:Cell("SAIDA"):SetValue(DTOC(Aarray[i,5]))
oSection:Finish()

Return


