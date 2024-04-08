#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFatProdABC ³ Autor ³ Thiago (Onsten)    ³ Data ³ 03/12/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Faturamento p/ Produto - Curva ABC            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFatProdAbc()
************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Relatório de Faturamento Mensal p/ Produto"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Relatório de Faturamento p/ Produto - Curva ABC"
Local cPict     := ""
Local cString   := ""

Private Titulo  := "Relatório de Faturamento p/ Produto - Curva ABC"
Private nLin    := 99
Private Imprime := .T.
Private aOrd    := {}
//Private cAnoAx  := SubStr(DtoS(dDataBase),3,2)
//Private Cabec1  := "REPRESENTANTE                                            JAN/"+cAnoAx+"     FEV/"+cAnoAx+"     MAR/"+cAnoAx+"     ABR/"+cAnoAx+"     MAI/"+cAnoAx+"     JUN/"+cAnoAx+"     JUL/"+cAnoAx+"     AGO/"+cAnoAx+"     SET/"+cAnoAx+"     OUT/"+cAnoAx+"     NOV/"+cAnoAx+"     DEZ/"+cAnoAx+"     T O T A L   PARTIC. CART.FUTURA "
//Private Cabec2  := "P R O D U T O                                                                                                                                                                                              (%)  "
//                  999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                       //
//                  9999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999   999.999.999    999.99  999,999,999
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Private lEnd         := .F. 
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RFATPRODABC"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CriaPerg("RFTPRODABC")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RFATPRODABC"
Private aRegs        := {}

ValPergunte(cPerg)

wnrel:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

Processa({ ||U_PFatProdABC()}, "Faturamento p/ Produto - Curva ABC",,.t.)

RestArea(aAreaAtu)

Return(Nil)


 
User Function PFatProdABC()
***************************
Local cQuery     := ""
Local nGTVendLiq := 0
Local nGTVendBru := 0
Local nTtVendLiq := 0
Local nTtVendBru := 0
Local dDataDe    := CtoD("  /  /  ")
Local dDataAte   := CtoD("  /  /  ")
Private cAnoAx  := SubStr(DtoS(mv_par16),3,2)
Private Cabec1  := "REPRESENTANTE                                            JAN/"+cAnoAx+"     FEV/"+cAnoAx+"     MAR/"+cAnoAx+"     ABR/"+cAnoAx+"     MAI/"+cAnoAx+"     JUN/"+cAnoAx+"     JUL/"+cAnoAx+"     AGO/"+cAnoAx+"     SET/"+cAnoAx+"     OUT/"+cAnoAx+"     NOV/"+cAnoAx+"     DEZ/"+cAnoAx+"     T O T A L   PARTIC. CART.FUTURA "
Private Cabec2  := "P R O D U T O                                                                                                                                                                                              (%)  "
//                  999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                                                                                                                       //
//                  9999999  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999   999.999.999    999.99  999,999,999
//                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890


If mv_par12==1
	Titulo  := Alltrim(Titulo)+" - Valores em R$"
ElseIf mv_par12==2
	Titulo  := Alltrim(Titulo)+" - em Quantidades"
Else
	Titulo  := Alltrim(Titulo)+" - em Peso"
EndIf

dDataDe  := CtoD("01/01/"+cAnoAx) //mv_par01
dDataAte := CtoD("31/12/"+cAnoAx) //mv_par02
//dDtMesDe := FirstDay(dDataBase)
//dDtMesAte:= LastDay(dDataBase) 
dDtMesDe := CtoD("01/01/1990") //FirstDay(dDataBase)  //pega tudo que esta em aberto
dDtMesAte:= LastDay(mv_par16) 




cQuery:= "SELECT " 
If mv_par11==1 //por Representante
	cQuery+= " SUPERV, "
	cQuery+= " VENDEDOR, "
ElseIf mv_par11==2 //por Supervisor
	cQuery+= " SUPERV, "
EndIf
cQuery+= " CODIGO, "

cQuery+= " SUM(TOTCART) AS TOTCART, "
cQuery+= " SUM(MES01) AS MES01, "
cQuery+= " SUM(MES02) AS MES02, "
cQuery+= " SUM(MES03) AS MES03, "
cQuery+= " SUM(MES04) AS MES04, "
cQuery+= " SUM(MES05) AS MES05, "
cQuery+= " SUM(MES06) AS MES06, "
cQuery+= " SUM(MES07) AS MES07, "
cQuery+= " SUM(MES08) AS MES08, "
cQuery+= " SUM(MES09) AS MES09, "
cQuery+= " SUM(MES10) AS MES10, "
cQuery+= " SUM(MES11) AS MES11, "
cQuery+= " SUM(MES12) AS MES12, "
cQuery+= " SUM(TOTMES) AS TOTMES FROM (" 

cQuery+= "SELECT "  
If mv_par11==1 //por Representante
	cQuery+= " SA3.A3_SUPER AS SUPERV, "
	cQuery+= " SF2.F2_VEND1 AS VENDEDOR, "
ElseIf mv_par11==2 //por Supervisor
	cQuery+= " SA3.A3_SUPER AS SUPERV, "
EndIf

If mv_par15==1
	cQuery+= " SD2.D2_COD AS CODIGO, "
Else
	cQuery+= " SB1.B1_XFAMCOM AS CODIGO, "
EndIf

cQuery+= " 0 AS TOTCART, "

cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"01' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES01, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"02' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES02, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"03' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES03, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"04' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES04, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"05' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES05, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"06' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES06, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"07' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES07, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"08' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES08, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"09' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES09, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"10' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES10, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"11' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES11, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par16),1,4)+"12' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS MES12, "
cQuery+= " SUM(CASE WHEN D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' THEN "+Iif(mv_par12==1,"D2_VALBRUT",Iif(mv_par12==2,"D2_QUANT","D2_PESO*D2_QUANT"))+" ELSE 0 END) AS TOTMES "
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= " INNER JOIN "+RetSQLName("SF2")+" SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SF4")+" SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SA1")+" SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= " LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SB1")+" SB1 ON D2_COD=B1_COD AND SB1.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SBM")+" SBM ON B1_XFAMCOM = BM_GRUPO AND SBM.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= "  AND D2_TP='3' "
cQuery+= "  AND D2_TIPO NOT IN ('B','D') "
cQuery+= "  AND SD2.D_E_L_E_T_='' "
cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "   //SUPERVISOR
cQuery+= "  AND SF2.F2_VEND1 BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "   //REPRES
cQuery+= "  AND SA1.A1_GRPVEN BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "  //SEGMENTO
cQuery+= "  AND SD2.D2_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "     //CODIGO 
cQuery+= "  AND SA1.A1_EST BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "     //ESTADO
cQuery+= "  AND SB1.B1_XFAMCOM BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' " //FAMILIA COMERCIAL
If mv_par15==1
	If mv_par11==1
		cQuery+= "GROUP BY SA3.A3_SUPER,SF2.F2_VEND1,SD2.D2_COD "
	ElseIf mv_par11==2
		cQuery+= "GROUP BY SA3.A3_SUPER,SD2.D2_COD "
	Else	
		cQuery+= "GROUP BY SD2.D2_COD "
	EndIf	
Else
	If mv_par11==1
		cQuery+= "GROUP BY SA3.A3_SUPER,SF2.F2_VEND1,SB1.B1_XFAMCOM "
	ElseIf mv_par11==2
		cQuery+= "GROUP BY SA3.A3_SUPER,SB1.B1_XFAMCOM "
	Else	
		cQuery+= "GROUP BY SB1.B1_XFAMCOM "
	EndIf	
EndIf	



cQuery+= " UNION ALL " 

//Carteira Futura

cQuery+= " SELECT "  
If mv_par11==1 //por Representante
	cQuery+= " SA3.A3_SUPER AS SUPERV, "
	cQuery+= " SA3.A3_COD AS VENDEDOR, "
ElseIf mv_par11==2 //por Supervisor
	cQuery+= " SA3.A3_SUPER AS SUPERV, "
EndIf

If mv_par15==1
	cQuery+= " SC6.C6_PRODUTO AS CODIGO, "
Else
	cQuery+= " SB1.B1_XFAMCOM AS CODIGO, "
EndIf

cQuery+= " SUM("+Iif(mv_par12==1,"(SC6.C6_QTDVEN-SC6.C6_QTDENT)*SC6.C6_PRCVEN",Iif(mv_par12==2,"(SC6.C6_QTDVEN-SC6.C6_QTDENT)","B1_PESO*(SC6.C6_QTDVEN-SC6.C6_QTDENT)"))+" ) AS TOTCART, "
cQuery+= " 0 AS MES01, "
cQuery+= " 0 AS MES02, "
cQuery+= " 0 AS MES03, "
cQuery+= " 0 AS MES04, "
cQuery+= " 0 AS MES05, "
cQuery+= " 0 AS MES06, "
cQuery+= " 0 AS MES07, "
cQuery+= " 0 AS MES08, "
cQuery+= " 0 AS MES09, "
cQuery+= " 0 AS MES10, "
cQuery+= " 0 AS MES11, "
cQuery+= " 0 AS MES12, "
cQuery+= " 0 AS TOTMES "

cQuery+= "FROM "+RetSQLName("SC5")+" SC5,"+RetSQLName("SC6")+" SC6,"+RetSQLName("SA1")+" SA1,"+RetSQLName("SA3")+" SA3 ,"+RetSQLName("SF4")+" SF4 ,"+RetSQLName("SB1")+" SB1 " 
cQuery+= "WHERE SC5.D_E_L_E_T_='' AND SC6.D_E_L_E_T_='' AND SA1.D_E_L_E_T_='' AND SA3.D_E_L_E_T_='' AND SF4.D_E_L_E_T_ = '' AND SB1.D_E_L_E_T_ = '' " 
cQuery+= " AND C5_FILIAL=C6_FILIAL " 
cQuery+= " AND C5_NUM=C6_NUM" 
cQuery+= " AND C5_CLIENTE=A1_COD " 
cQuery+= " AND C5_LOJACLI=A1_LOJA" 
cQuery+= " AND SC5.C5_VEND1=SA3.A3_COD"     
cQuery+= " AND SC6.C6_QTDVEN>SC6.C6_QTDENT" 
cQuery+= " AND SC6.C6_ENTREG BETWEEN '"+DtoS(LastDay(mv_par16)+1)+"' AND '"+SubStr(DtoS(mv_par16),1,4)+"1231"+"' "
cQuery+= " AND SC5.C5_TIPO='N' "
cQuery+= " AND C6_BLQ<>'R'" 
cQuery+= " AND SC6.C6_TES = SF4.F4_CODIGO "
cQuery+= " AND SF4.F4_DUPLIC = 'S'  "
cQuery+= " AND SC6.C6_PRODUTO = SB1.B1_COD "

cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "   //SUPERVISOR
cQuery+= "  AND SA3.A3_COD BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "     //REPRES
cQuery+= "  AND SA1.A1_GRPVEN BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "  //SEGMENTO
cQuery+= "  AND SC6.C6_PRODUTO BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' " //CODIGO 
cQuery+= "  AND SA1.A1_EST BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "     //ESTADO
cQuery+= "  AND SB1.B1_XFAMCOM BETWEEN '"+mv_par13+"' AND '"+mv_par14+"' " //FAMILIA COMERCIAL

If mv_par15==1
	If mv_par11==1
		cQuery+= "GROUP BY SA3.A3_SUPER,SA3.A3_COD,SC6.C6_PRODUTO "
	ElseIf mv_par11==2
		cQuery+= "GROUP BY SA3.A3_SUPER,SC6.C6_PRODUTO "
	Else	
		cQuery+= "GROUP BY SC6.C6_PRODUTO "
	EndIf	
Else
	If mv_par11==1
		cQuery+= "GROUP BY SA3.A3_SUPER,SA3.A3_COD,SB1.B1_XFAMCOM "
	ElseIf mv_par11==2
		cQuery+= "GROUP BY SA3.A3_SUPER,SB1.B1_XFAMCOM "
	Else	
		cQuery+= "GROUP BY SB1.B1_XFAMCOM "
	EndIf	
EndIf	

cQuery+= " ) AGRUPA " 

If mv_par11==1
	cQuery+= "GROUP BY SUPERV,VENDEDOR,CODIGO "
ElseIf mv_par11==2
	cQuery+= "GROUP BY SUPERV,CODIGO "
Else	
	cQuery+= "GROUP BY CODIGO "
EndIf	

If mv_par11==1
	cQuery+= "ORDER BY SUPERV,VENDEDOR,TOTMES DESC  "
ElseIf mv_par11==2
	cQuery+= "ORDER BY SUPERV,TOTMES DESC  "
Else
	cQuery+= "ORDER BY TOTMES DESC  "
EndIf	

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()

nTotGeral  := 0 //acumula total geral para calculo da porcentagem
While !Eof()
	nTotGeral+= TRAB->TOTMES
	DbSkip()
EndDo


dbGotop()
ProcRegua(RecCount())
dbGotop()

//Impressao

aTotMesGer := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
aTotMesSup := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
aTotMesRep := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

While !Eof()
	IncProc()

	If lAbortPrint
		@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
		
	If nLin > 56
		nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		lNovaPag:= .t.
	EndIf

	cSupervAux:= Iif(mv_par11<3, TRAB->SUPERV, .T.)
	cNomeSuper:= Iif(mv_par11<3, Posicione("SA3",1,xFilial("SA3")+TRAB->SUPERV,"A3_NOME"),.T.)
	aTotMesSup:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    nContCli  := 0

	If mv_par11<3
		@ ++nLin, 000 PSay "SUPERVISOR "+TRAB->SUPERV+" - "+cNomeSuper
		nLin++
	EndIf
	
	While !Eof() .And. Iif(mv_par11<3, cSupervAux==TRAB->SUPERV, .T.)
		nContCli++
			
		If lAbortPrint
			@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf
			
		If nLin > 56 
			nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			lNovaPag:= .t.
		EndIf

	    cVendAux   := Iif(mv_par11<2,TRAB->VENDEDOR,"")
		cNomeVend  := Iif(mv_par11<2,Posicione("SA3",1,xFilial("SA3")+TRAB->VENDEDOR,"A3_NOME"),"")
		aTotMesRep := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	
		If mv_par11<2
			@ ++nLin, 000 PSay TRAB->VENDEDOR+" - "+cNomeVend
			nLin++
	    EndIf
	    
	    lNovaPag:= .f.
		
		While !Eof() .And. Iif(mv_par11==1,cVendAux==TRAB->VENDEDOR,Iif(mv_par11==2,cSupervAux==TRAB->SUPERV,.T.))
		
			If lAbortPrint  // Verifica o cancelamento pelo usuario...
				@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
				Exit
			EndIf
				
			If nLin > 56
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
			
			nPParticAux:= (TRAB->TOTMES*100)/nTotGeral
		    
			If mv_par15==1
				@ ++nLin, 000 PSay SubStr(TRAB->CODIGO,1,10)+"  "+SubStr(Posicione("SB1",1,xFilial("SB1")+TRAB->CODIGO,"B1_DESC"),1,40)
			Else
				@ ++nLin, 000 PSay SubStr(TRAB->CODIGO,1,6)+"   "+SubStr(Posicione("SX5",1,xFilial("SX5")+"Z2"+TRAB->CODIGO,"X5_DESCRI"),1,40)
			EndIf	

			@   nLin, 053 PSay  TRAB->MES01             Picture "@E 99,999,999"
			@   nLin, 064 PSay  TRAB->MES02             Picture "@E 99,999,999"
			@   nLin, 075 PSay  TRAB->MES03             Picture "@E 99,999,999"
			@   nLin, 086 PSay  TRAB->MES04             Picture "@E 99,999,999"
			@   nLin, 097 PSay  TRAB->MES05             Picture "@E 99,999,999"
			@   nLin, 108 PSay  TRAB->MES06             Picture "@E 99,999,999"
			@   nLin, 119 PSay  TRAB->MES07             Picture "@E 99,999,999"
			@   nLin, 130 PSay  TRAB->MES08             Picture "@E 99,999,999"
			@   nLin, 141 PSay  TRAB->MES09             Picture "@E 99,999,999"
			@   nLin, 152 PSay  TRAB->MES10             Picture "@E 99,999,999"
			@   nLin, 163 PSay  TRAB->MES11             Picture "@E 99,999,999"
			@   nLin, 174 PSay  TRAB->MES12             Picture "@E 99,999,999"
			@   nLin, 187 PSay  TRAB->TOTMES            Picture "@E 999,999,999"
			@   nLin, 200 PSay  nPParticAux             Picture "@E 9999.99"

			@   nLin, 210 PSay  TRAB->TOTCART           Picture "@E 99,999,999"
		
			For nI:= 1 to 12	
				cMesAx:= StrZero(nI,2)
				aTotMesRep[nI]+= TRAB->(MES&cMesAx)
				aTotMesSup[nI]+= TRAB->(MES&cMesAx)
				aTotMesGer[nI]+= TRAB->(MES&cMesAx)
			Next	
			aTotMesRep[13]+= TRAB->TOTMES
			aTotMesSup[13]+= TRAB->TOTMES
			aTotMesGer[13]+= TRAB->TOTMES
			aTotMesRep[14]+= TRAB->TOTCART
			aTotMesSup[14]+= TRAB->TOTCART
			aTotMesGer[14]+= TRAB->TOTCART
			
			DbSkip()
		EndDo

		If mv_par11==1
			nLin+=2
			@  nLin, 000 PSay "TOTAL REPRESENTANTE "+cVendAux
		
			nCol:= 53
			For nI:= 1 to 12
				cMesAx:= StrZero(nI,2)             
				@  nLin, nCol PSay aTotMesRep[nI]   Picture "@E 99,999,999" //"@E 99,999,999"
				nCol+=11
			Next
		
			nPParticAux:= (aTotMesRep[13]*100)/nTotGeral
	
			@   nLin, 187 PSay aTotMesRep[13]   Picture "@E 999,999,999" 
			@   nLin, 200 PSay nPParticAux      Picture "@E 9999.99"
			@   nLin, 210 PSay aTotMesRep[14]   Picture "@E 99,999,999"
	
			@ ++nLin, 000 PSay __PrtThinLine()
			nLin++
		EndIf	
		
	EndDo

	If mv_par11<3
	    nLin++
		@++nLin, 000 PSay "TOTAL SUPERVISOR "+cSupervAux
	
		nCol:= 53
		For nI:= 1 to 12
			cMesAx:= StrZero(nI,2)             
			@  nLin, nCol PSay aTotMesSup[nI]   Picture "@E 99,999,999" //"@E 99,999,999"
			nCol+=11
		Next
	
		nPParticAux:= (aTotMesSup[13]*100)/nTotGeral
	
		@   nLin, 187 PSay aTotMesSup[13]   Picture "@E 999,999,999" 
		@   nLin, 200 PSay nPParticAux      Picture "@E 9999.99"
		@   nLin, 210 PSay aTotMesSup[14]   Picture "@E 99,999,999"

		@ ++nLin, 000 PSay __PrtFatLine()
		nLin++
	EndIf	

EndDo
	
nLin++ 
@  nLin, 000 PSay "T O T A L"
nCol:= 53
For nI:= 1 to 12
	cMesAx:= StrZero(nI,2)             
	@  nLin, nCol PSay aTotMesGer[nI]   Picture "@E 99,999,999" //"@e 99,999,999"
	nCol+=11
Next

nPParticAux:= 100 //(aTotMesGer[13]*100)/nTotGeral

@   nLin, 187 PSay aTotMesGer[13]   Picture "@E 999,999,999" //"@E 999,999,999"
@   nLin, 200 PSay nPParticAux      Picture "@E 9999.99"
@   nLin, 210 PSay aTotMesGer[14]   Picture "@E 99,999,999"

@ ++nLin, 000 PSay __PrtFatLine()

dbSelectArea("TRAB")
dbCloseArea()

Set Device To Screen
If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
EndIf
MS_FLUSH()

Return

 

Static Function ValPergunte(cPerg)
******************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta/                       Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture/IDFil
aAdd(aRegs,{cPerg,"01" ,"Supervisor De? "        ,"","","mv_ch1","C" ,6      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"02" ,"Supervisor Ate?"        ,"","","mv_ch2","C" ,6      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"03" ,"Representante De? "     ,"","","mv_ch3","C" ,6      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"04" ,"Representante Ate?"     ,"","","mv_ch4","C" ,6      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"05" ,"Segmento De? "          ,"","","mv_ch5","C" ,6      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"ACY",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"06" ,"Segmento Ate?"          ,"","","mv_ch6","C" ,6      ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"ACY",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"07" ,"Produto De? "           ,"","","mv_ch7","C" ,15     ,0      ,0     ,"G",""   ,"mv_par07",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SB1",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"08" ,"Produto Ate?"           ,"","","mv_ch8","C" ,15     ,0      ,0     ,"G",""   ,"mv_par08",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SB1",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"09" ,"UF De? "                ,"","","mv_ch9","C" ,2      ,0      ,0     ,"G",""   ,"mv_par09",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"12 ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"10" ,"UF Ate?"                ,"","","mv_cha","C" ,2      ,0      ,0     ,"G",""   ,"mv_par10",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"12 ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"11" ,"Tipo Relatório:"        ,"","","mv_chb","N" ,1      ,0      ,0     ,"C",""   ,"mv_par11","Por Representante","","",""   ,""   ,"Por Supervisor","","" ,""   ,""   ,"Geral"            ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"12" ,"Totais em: "            ,"","","mv_chc","N" ,1      ,0      ,0     ,"C",""   ,"mv_par12","Valores(R$)"     ,"","" ,""   ,""   ,"Quantidades"   ,"","" ,""   ,""   ,"Peso"             ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"13" ,"Familia De? "           ,"","","mv_chd","C" ,06     ,0      ,0     ,"G",""   ,"mv_par13",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"Z2 ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"14" ,"Familia Ate?"           ,"","","mv_che","C" ,06     ,0      ,0     ,"G",""   ,"mv_par14",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"Z2 ",""    ,""     ,""   ,""    ,""})
aAdd(aRegs,{cPerg,"15" ,"Agrupamento por: "      ,"","","mv_chf","N" ,1      ,0      ,0     ,"C",""   ,"mv_par15","Codigo Produto"  ,"","" ,""   ,""   ,"Familia Coml"  ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,""    ,""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return