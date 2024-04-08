#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"
  
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RelFatMes ³ Autor ³ Thiago (Onsten)      ³ Data ³ 23/07/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatório de Faturamento Mensal p/ Representante/Cliente   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelFatMes()
************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Relatório de Faturamento Mensal p/ Representante/Cliente"
Local nProcessa	:= 3
Local lJob		:= .t.
Local cDesc1    := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    := "de acordo com os parametros informados pelo usuario."
Local cDesc3    := "Relatório de Faturamento Mensal p/ Representante/Cliente"
Local cPict     := ""
Local cString   := ""

Private Titulo  := "Relatório de Faturamento Mensal p/ Representante/Cliente"
Private nLin    := 99
Private Imprime := .T.
Private aOrd    := {}
Private cAnoAx  := ""
Private Cabec1  := ""
Private Cabec2  := ""
Private lEnd         := .F. 
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RELFATMES"
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CriaPerg("RFTMES")
Private cbtxt        := Space(10)                                                
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELFATMES"
Private aRegs        := {}

ValPergunte(cPerg)

wnrel:= SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.f.)

If nLastKey == 27
	Return
EndIf

SetDefault(aReturn,cString)

nTipo := If(aReturn[4]==1,15,18)

Processa({ ||U_ProcFatMes()}, "Faturamento Mensal p/ Representante/Cliente",,.t.)

RestArea(aAreaAtu)

Return(Nil)


User Function ProcFatMes()
***************************
Local cQuery     := ""
Local nGTVendLiq := 0
Local nGTVendBru := 0
Local nTtVendLiq := 0
Local nTtVendBru := 0
Local dDataDe    := CtoD("  /  /  ")
Local dDataAte   := CtoD("  /  /  ")

cAnoAx  := SubStr(DtoS(mv_par10),3,2)
Cabec1  := "REPRESENTANTE                         JAN/"+cAnoAx+"     FEV/"+cAnoAx+"     MAR/"+cAnoAx+"     ABR/"+cAnoAx+"     MAI/"+cAnoAx+"     JUN/"+cAnoAx+"     JUL/"+cAnoAx+"     AGO/"+cAnoAx+"     SET/"+cAnoAx+"     OUT/"+cAnoAx+"     NOV/"+cAnoAx+"     DEZ/"+cAnoAx+"     T O T A L          SOMA          SOMA"
Cabec2  := "C L I E N T E                                                                                                                                                                            CART.MES   CART.FUTURA    "                                                                                                                                 
//          999999 - XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX          
//          999999/99  XXXXXXXXXXXXXXXXXXXX  99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999 99.999.999   999.999.999   999.999.999   999.999.999   999.999.999
//          0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
//          012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901

If mv_par09==2
	Cabec2  := "                                                                                                                                                                                      CART.MES   CART.FUTURA    FATUR. MES"                                                                                                                                 
	Titulo  := Alltrim(Titulo)+" (Sintético)"
EndIf

dDataDe  := CtoD("01/01/"+cAnoAx) //mv_par01
dDataAte := CtoD("31/12/"+cAnoAx) //mv_par02
dDtMesDe := CtoD("01/01/1990") //FirstDay(dDataBase)  //pega tudo que esta em aberto
dDtMesAte:= LastDay(mv_par10) 

If mv_par09==1
	cQuery:= "SELECT SUPERV, VENDEDOR, CLIENTE," 
ElseIf mv_par09==2
	cQuery:= "SELECT SUPERV, VENDEDOR, " 
Else
	cQuery:= "SELECT SUPERV, CLIENTE, " 
Endif
cQuery+= " SUM(MES01) MES01, " 
cQuery+= " SUM(MES02) MES02, " 
cQuery+= " SUM(MES03) MES03, " 
cQuery+= " SUM(MES04) MES04, " 
cQuery+= " SUM(MES05) MES05, " 
cQuery+= " SUM(MES06) MES06, " 
cQuery+= " SUM(MES07) MES07, " 
cQuery+= " SUM(MES08) MES08, " 
cQuery+= " SUM(MES09) MES09, " 
cQuery+= " SUM(MES10) MES10, " 
cQuery+= " SUM(MES11) MES11, " 
cQuery+= " SUM(MES12) MES12, " 
cQuery+= " SUM(TOTMES) TOTMES, " 
cQuery+= " SUM(CARTATU) CARTATU, " 
cQuery+= " SUM(CARTFUT) CARTFUT FROM (" 

cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "
If mv_par09==1
	cQuery+= " SF2.F2_VEND1 AS VENDEDOR, "
	cQuery+= " SD2.D2_CLIENTE+SD2.D2_LOJA AS CLIENTE, "
ElseIf mv_par09==2
	cQuery+= " SF2.F2_VEND1 AS VENDEDOR, "
Else
	cQuery+= " SD2.D2_CLIENTE+SD2.D2_LOJA AS CLIENTE, "
Endif

cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"01' THEN D2_VALBRUT ELSE 0 END) AS MES01, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"02' THEN D2_VALBRUT ELSE 0 END) AS MES02, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"03' THEN D2_VALBRUT ELSE 0 END) AS MES03, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"04' THEN D2_VALBRUT ELSE 0 END) AS MES04, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"05' THEN D2_VALBRUT ELSE 0 END) AS MES05, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"06' THEN D2_VALBRUT ELSE 0 END) AS MES06, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"07' THEN D2_VALBRUT ELSE 0 END) AS MES07, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"08' THEN D2_VALBRUT ELSE 0 END) AS MES08, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"09' THEN D2_VALBRUT ELSE 0 END) AS MES09, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"10' THEN D2_VALBRUT ELSE 0 END) AS MES10, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"11' THEN D2_VALBRUT ELSE 0 END) AS MES11, "
cQuery+= " SUM(CASE WHEN SUBSTRING(D2_EMISSAO,1,6)='"+SubStr(DtoS(mv_par10),1,4)+"12' THEN D2_VALBRUT ELSE 0 END) AS MES12, "
cQuery+= " SUM(CASE WHEN D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' THEN D2_VALBRUT ELSE 0 END) AS TOTMES, "
cQuery+= " 0 AS CARTATU,  "
cQuery+= " 0 AS CARTFUT  "
cQuery+= "FROM "+RetSQLName("SD2")+" SD2 "
cQuery+= " INNER JOIN "+RetSQLName("SF2")+" SF2 ON SD2.D2_DOC=SF2.F2_DOC AND SD2.D2_SERIE=SF2.F2_SERIE AND SD2.D2_FILIAL=SF2.F2_FILIAL AND SF2.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SF4")+" SF4 ON F4_CODIGO=SD2.D2_TES  AND F4_DUPLIC='S' AND SF4.D_E_L_E_T_='' "
cQuery+= " INNER JOIN "+RetSQLName("SA1")+" SA1 ON D2_CLIENTE=A1_COD AND D2_LOJA=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= " LEFT JOIN SA3010 SA3 ON SF2.F2_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE D2_EMISSAO BETWEEN '"+DtoS(dDataDe)+"' AND '"+DtoS(dDataAte)+"' " 
cQuery+= "  AND D2_TP='3' "
cQuery+= "  AND D2_TIPO NOT IN ('B','D') "
cQuery+= "  AND SD2.D_E_L_E_T_='' "
cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+mv_par01+"' AND '"+mv_par01+"' "  //SUPERVISOR
cQuery+= "  AND SF2.F2_VEND1 BETWEEN '"+mv_par02+"' AND '"+mv_par02+"' "  //REPRES
cQuery+= "  AND SA1.A1_GRPVEN BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " //SEGMENTO
cQuery+= "  AND SA1.A1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "    //CLIENTE
cQuery+= "  AND SA1.A1_EST BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "    //ESTADO
If mv_par09==1
	cQuery+= "GROUP BY SA3.A3_SUPER,SF2.F2_VEND1,SD2.D2_CLIENTE+SD2.D2_LOJA "
ElseIf mv_par09==2
	cQuery+= "GROUP BY SA3.A3_SUPER,SF2.F2_VEND1 "
Else
	cQuery+= "GROUP BY SA3.A3_SUPER,SD2.D2_CLIENTE+SD2.D2_LOJA "
EndIf	

cQuery+= "UNION ALL "

cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "
If mv_par09==1
	cQuery+= " SC5.C5_VEND1 AS VENDEDOR, "
	cQuery+= " SC5.C5_CLIENTE+SC5.C5_LOJACLI AS CLIENTE, "
ElseIf mv_par09==2
	cQuery+= " SC5.C5_VEND1 AS VENDEDOR, "
Else
	cQuery+= " SC5.C5_CLIENTE+SC5.C5_LOJACLI AS CLIENTE, "
EndIf
cQuery+= " 0 AS MES01, 0 AS MES02, 0 AS MES03, 0 AS MES04, 0 AS MES05, 0 AS MES06, "
cQuery+= " 0 AS MES07, 0 AS MES08, 0 AS MES09, 0 AS MES10, 0 AS MES11, 0 AS MES12, "
cQuery+= " 0 AS TOTMES, "
cQuery+= " SUM((SC6A.C6_QTDVEN-SC6A.C6_QTDENT)*SC6A.C6_PRCVEN) AS CARTATU,  "
cQuery+= " 0 AS CARTFUT  "
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= " INNER JOIN "+RetSQLName("SC6")+" SC6A ON C5_FILIAL=SC6A.C6_FILIAL " 
cQuery+= "                      AND C5_NUM=SC6A.C6_NUM  "
cQuery+= "                      AND C5_CLIENTE=SC6A.C6_CLI  "
cQuery+= "                      AND C5_LOJACLI=SC6A.C6_LOJA  "
cQuery+= "                      AND SC6A.C6_QTDVEN>SC6A.C6_QTDENT  "
cQuery+= "                      AND SC6A.C6_ENTREG BETWEEN '"+DtoS(dDtMesDe)+"' AND '"+DtoS(dDtMesAte)+"' "
cQuery+= "                      AND SC6A.C6_BLQ<>'R'   "
cQuery+= "                      AND SC6A.D_E_L_E_T_=''  "
cQuery+= " INNER JOIN "+RetSQLName("SA1")+" SA1 ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= " LEFT JOIN SA3010 SA3 ON SC5.C5_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE SC5.C5_TIPO='N' "
cQuery+= "  AND SC5.D_E_L_E_T_='' "
cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+mv_par01+"' AND '"+mv_par01+"' "  //SUPERVISOR
cQuery+= "  AND SC5.C5_VEND1 BETWEEN '"+mv_par02+"' AND '"+mv_par02+"' "  //REPRES
cQuery+= "  AND SA1.A1_GRPVEN BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " //SEGMENTO
cQuery+= "  AND SA1.A1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "    //CLIENTE
cQuery+= "  AND SA1.A1_EST BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "    //ESTADO

If mv_par09==1
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_VEND1,SC5.C5_CLIENTE+SC5.C5_LOJACLI "
ElseIf mv_par09==2
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_VEND1 "
Else
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_CLIENTE+SC5.C5_LOJACLI "
EndIf

cQuery+= "UNION ALL "

cQuery+= "SELECT SA3.A3_SUPER AS SUPERV, "
If mv_par09==1
	cQuery+= " SC5.C5_VEND1 AS VENDEDOR, "
	cQuery+= " SC5.C5_CLIENTE+SC5.C5_LOJACLI AS CLIENTE, "
ElseIf mv_par09==2
	cQuery+= " SC5.C5_VEND1 AS VENDEDOR, "
Else
	cQuery+= " SC5.C5_CLIENTE+SC5.C5_LOJACLI AS CLIENTE, "
EndIf

cQuery+= " 0 AS MES01, 0 AS MES02, 0 AS MES03, 0 AS MES04, 0 AS MES05, 0 AS MES06, "
cQuery+= " 0 AS MES07, 0 AS MES08, 0 AS MES09, 0 AS MES10, 0 AS MES11, 0 AS MES12, "
cQuery+= " 0 AS TOTMES, "
cQuery+= " 0 AS CARTATU,  "
cQuery+= " SUM((SC6F.C6_QTDVEN-SC6F.C6_QTDENT)*SC6F.C6_PRCVEN) AS CARTFUT  "
cQuery+= "FROM "+RetSQLName("SC5")+" SC5 "
cQuery+= " INNER JOIN "+RetSQLName("SC6")+" SC6F ON C5_FILIAL=SC6F.C6_FILIAL  "
cQuery+= "                      AND C5_NUM=SC6F.C6_NUM  "
cQuery+= "                      AND C5_CLIENTE=SC6F.C6_CLI  "
cQuery+= "                      AND C5_LOJACLI=SC6F.C6_LOJA  "
cQuery+= "                      AND SC6F.C6_QTDVEN>SC6F.C6_QTDENT  "
cQuery+= "                      AND SC6F.C6_ENTREG BETWEEN '"+DtoS(dDtMesAte+1)+"' AND '"+DtoS(dDataAte)+"' "
cQuery+= "                      AND SC6F.C6_BLQ<>'R'   "
cQuery+= "                      AND SC6F.D_E_L_E_T_=''   "
cQuery+= " INNER JOIN "+RetSQLName("SA1")+" SA1 ON C5_CLIENTE=A1_COD AND C5_LOJACLI=A1_LOJA AND SA1.D_E_L_E_T_='' "
cQuery+= " LEFT JOIN SA3010 SA3 ON SC5.C5_VEND1=A3_COD AND SA3.D_E_L_E_T_='' "
cQuery+= "WHERE SC5.C5_TIPO='N' "
cQuery+= "  AND SC5.D_E_L_E_T_='' "
cQuery+= "  AND SA3.A3_SUPER BETWEEN '"+mv_par01+"' AND '"+mv_par01+"' "  //SUPERVISOR
cQuery+= "  AND SC5.C5_VEND1 BETWEEN '"+mv_par02+"' AND '"+mv_par03+"' "  //REPRES
cQuery+= "  AND SA1.A1_GRPVEN BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' " //SEGMENTO
cQuery+= "  AND SA1.A1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "    //CLIENTE
cQuery+= "  AND SA1.A1_EST BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "    //ESTADO

If mv_par09==1
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_VEND1,SC5.C5_CLIENTE+SC5.C5_LOJACLI "
ElseIf mv_par09==2
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_VEND1 "
Else
	cQuery+= "GROUP BY SA3.A3_SUPER,SC5.C5_CLIENTE+SC5.C5_LOJACLI "
EndIf

cQuery+=") AGRUPA " 

If mv_par09==1
	cQuery+= "GROUP BY SUPERV,VENDEDOR,CLIENTE  "
	cQuery+= "ORDER BY SUPERV,VENDEDOR,TOTMES DESC  "
ElseIf mv_par09==2
	cQuery+= "GROUP BY SUPERV,VENDEDOR  "
	cQuery+= "ORDER BY SUPERV,TOTMES DESC  "
Else
	cQuery+= "GROUP BY SUPERV,CLIENTE  "
	cQuery+= "ORDER BY SUPERV,TOTMES DESC  "
EndIf	


If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
TCQUERY cQuery NEW ALIAS "TRAB"

dbSelectArea("TRAB")
dbGotop()
ProcRegua(RecCount())
dbGotop()

//Impressao

aTotMesGer := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
aTotMesSup := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
aTotMesRep := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}

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

	cSupervAux:= TRAB->SUPERV
	cNomeSuper:= Posicione("SA3",1,xFilial("SA3")+TRAB->SUPERV,"A3_NOME")
	aTotMesSup:= {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
    nContCli  := 0

	@ ++nLin, 000 PSay "SUPERVISOR "+TRAB->SUPERV+" - "+cNomeSuper
	nLin++
	
	While !Eof() .And. cSupervAux==TRAB->SUPERV
		nContCli++
			
		If mv_par09==3 .And. nContCli>100
			DbSkip()
			Loop
		EndIf

		If lAbortPrint
			@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf
			
		If nLin > 56 
			nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			lNovaPag:= .t.
		EndIf

	    cVendAux   := Iif(mv_par09<3,TRAB->VENDEDOR,TRAB->CLIENTE)
		cNomeVend  := Iif(mv_par09<3,Posicione("SA3",1,xFilial("SA3")+TRAB->VENDEDOR,"A3_NOME"), Posicione("SA1",1,xFilial("SA1")+Substr(TRAB->CLIENTE,1,30),"A1_NOME"))
		aTotMesRep := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
	
		If mv_par09==1
			If !lNovaPag
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)		
			EndIf	
			
			@ ++nLin, 000 PSay TRAB->VENDEDOR+" - "+cNomeVend
			nLin++
	    EndIf
	    
	    lNovaPag:= .f.
		
		While !Eof() .And. Iif(mv_par09<3,cVendAux==TRAB->VENDEDOR,cVendAux==TRAB->CLIENTE)
		
			If lAbortPrint  // Verifica o cancelamento pelo usuario...
				@ nLin,00 Psay "*** CANCELADO PELO OPERADOR ***"
				Exit
			EndIf
				
			If nLin > 56
				nLin:= Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			EndIf
		     
		    //distancia entre uma coluna e outra = 13		    	    
		    If mv_par09==1
				@ ++nLin, 000 PSay SubStr(TRAB->CLIENTE,1,8)+"/"+SubStr(TRAB->CLIENTE,9,4)+"  "+substr(Posicione("SA1",1,xFilial("SA1")+TRAB->CLIENTE,"A1_NOME"),1,20)

				@   nLin, 037 PSay  TRAB->MES01             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 047 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0101").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0131"),"*","") 

				@   nLin, 048 PSay  TRAB->MES02             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 058 PSay IIf(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0201").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0229"),"*","") 

				@   nLin, 059 PSay  TRAB->MES03             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 069 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0301").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0331"),"*","") 

				@   nLin, 070 PSay  TRAB->MES04             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 080 PSay IIf(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0401").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0430"),"*","") 

				@   nLin, 081 PSay  TRAB->MES05             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 091 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0501").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0531"),"*","") 

				@   nLin, 092 PSay  TRAB->MES06             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 102 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0601").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0630"),"*","") 

				@   nLin, 103 PSay  TRAB->MES07             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 113 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0701").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0731"),"*","") 

				@   nLin, 114 PSay  TRAB->MES08             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 124 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0801").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0831"),"*","") 

				@   nLin, 125 PSay  TRAB->MES09             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 135 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"0901").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"0930"),"*","") 

				@   nLin, 136 PSay  TRAB->MES10             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 146 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"1001").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"1031"),"*","") 

				@   nLin, 147 PSay  TRAB->MES11             Picture "@E 999,999.99"//"@E 999,999.99"
				@   nLin, 157 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"1101").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"1130"),"*","") 

				@   nLin, 158 PSay  TRAB->MES12             Picture "@E 999,999.99"//999,999.99 
				@   nLin, 168 PSay Iif(SA1->A1_DTNASC>=StoD(SubStr(DtoS(mv_par10),1,4)+"1201").And.SA1->A1_DTNASC<=StoD(SubStr(DtoS(mv_par10),1,4)+"1231"),"*","") 

				@   nLin, 171 PSay  TRAB->TOTMES            Picture "@E 999,999.99"//"@E 999999.99"
				@   nLin, 185 PSay  TRAB->CARTATU           Picture "@E 999,999.99"//"@E 999999.99"
				@   nLin, 199 PSay  TRAB->CARTFUT           Picture "@E 999,999.99"//"@E 999999.99"
			   //	@   nLin, 209 PSay  TRAB->TOTMES/Month(mv_par12)   Picture "@E 999,999.99"
			EndIf	
			
			For nI:= 1 to 12	
				cMesAx:= StrZero(nI,2)
				aTotMesRep[nI]+= TRAB->(MES&cMesAx)
				aTotMesSup[nI]+= TRAB->(MES&cMesAx)
				aTotMesGer[nI]+= TRAB->(MES&cMesAx)
			Next	
			aTotMesRep[13]+= TRAB->TOTMES
			aTotMesSup[13]+= TRAB->TOTMES
			aTotMesGer[13]+= TRAB->TOTMES
			aTotMesRep[14]+= TRAB->CARTATU
			aTotMesSup[14]+= TRAB->CARTATU
			aTotMesGer[14]+= TRAB->CARTATU
			aTotMesRep[15]+= TRAB->CARTFUT
			aTotMesSup[15]+= TRAB->CARTFUT
			aTotMesGer[15]+= TRAB->CARTFUT
			
			DbSkip()
		EndDo

		If mv_par09==1
			nLin+=2
			@  nLin, 000 PSay "TOTAL REPRESENTANTE "+cVendAux
		Else
			@++nLin, 000 PSay SubStr(cVendAux,1,6)+"/"+SubStr(cVendAux,7,2)+"-"+SubStr(cNomeVend,1,20)
		EndIf	
	
		nCol:= 37
		For nI:= 1 to 12
			cMesAx:= StrZero(nI,2)             
			@  nLin, nCol PSay aTotMesRep[nI]   Picture "@E 999,999.99"//"@E 999999.99" //"@E 99,999,999"
			nCol+=11
		Next
	
		@   nLin, 172 PSay aTotMesRep[13]                   //Picture "@E 999.999.999.99" 
		@   nLin, 187 PSay aTotMesRep[14]                   //Picture "@E 999999.99"
 		@   nLin, 201 PSay aTotMesRep[15]                   //Picture "@E 999999.99"
		//@   nLin, 209 PSay aTotMesRep[13]/Month(mv_par12)   Picture "@E 999,999.99"
		If mv_par09==1
			@ ++nLin, 000 PSay __PrtThinLine()
			nLin++
		EndIf	
	EndDo

	If mv_par09>=2
	    nLin++
	EndIf    
	@++nLin, 000 PSay "TOTAL SUPERVISOR "+cSupervAux

	nCol:= 37
	For nI:= 1 to 12
		cMesAx:= StrZero(nI,2)             
		@  nLin, nCol PSay aTotMesSup[nI]   Picture "@E 999,999.99"//"@E 999999.99" //"@E 99,999,999"
		nCol+=11
	Next

	@   nLin, 172 PSay aTotMesSup[13]                   //Picture "@E 999999.99" 
	@   nLin, 187 PSay aTotMesSup[14]                   //Picture "@E 999999.99"
	@   nLin, 201 PSay aTotMesSup[15]                   //Picture "@E 999999.99"
   //	@   nLin, 209 PSay aTotMesSup[13]/Month(mv_par12)   Picture "@E 999,999.99"
	@ ++nLin, 000 PSay __PrtFatLine()
	nLin++
	
	If mv_par09==1
		nLin:= 99
	EndIf	
EndDo
	
nLin++ 
@  nLin, 000 PSay "T O T A L"
nCol:= 37
For nI:= 1 to 12
	cMesAx:= StrZero(nI,2)             
	@  nLin, nCol PSay aTotMesGer[nI]   Picture "@E 999,999.99"//"@E 999999.99" //"@e 99,999,999"
	nCol+=11
Next
@   nLin, 180 PSay aTotMesGer[13]                   //Picture "@E 999999.99" //"@E 999,999,999"
@   nLin, 187 PSay aTotMesGer[14]                   //Picture "@E 999999.99"
@   nLin, 201 PSay aTotMesGer[15]                   //Picture "@E 999999.99"
//@   nLin, 209 PSay aTotMesGer[13]/Month(mv_par12)   Picture "@E 999,999.99"
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
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta/                       Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                        /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture  /IDFil
aAdd(aRegs,{cPerg,"01" ,"Supervisor? "           ,"","","mv_ch1","C" ,6      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3001",""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"02" ,"Representante? "        ,"","","mv_ch2","C" ,6      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA3"   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"03" ,"Grupo Cli De? "         ,"","","mv_ch3","C" ,6      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"ACY"   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"04" ,"Grupo Cli Ate?"         ,"","","mv_ch4","C" ,6      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"ACY"   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"05" ,"Cliente De? "           ,"","","mv_ch5","C" ,8      ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA1"   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"06" ,"Cliente Ate?"           ,"","","mv_ch6","C" ,8      ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SA1"   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"07" ,"UF De? "                ,"","","mv_ch7","C" ,2      ,0      ,0     ,"G",""   ,"mv_par07",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"12 "   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"08" ,"UF Ate?"                ,"","","mv_ch8","C" ,2      ,0      ,0     ,"G",""   ,"mv_par08",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"12 "   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"09" ,"Tipo Relatório:"        ,"","","mv_ch9","N" ,1      ,0      ,0     ,"C",""   ,"mv_par09","Analitico"       ,"","" ,""   ,""   ,"Sintetico"     ,"","" ,""   ,""   ,"100 maiores clientes","","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   "   ,""    ,""     ,""   ,""     ,""})
aAdd(aRegs,{cPerg,"10" ,"Data Referencia:"       ,"","","mv_cha","D" ,8      ,0      ,0     ,"G",""   ,"mv_par10",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                    ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   "   ,""    ,""     ,""   ,""     ,""})

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