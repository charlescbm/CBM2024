#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO2     º Autor ³ AP6 IDE            º Data ³  30/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RQIER02()


local aRegs			:= {}
Local cDesc1		:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3		:= "Indices da Qualidade - IQF - IQP - IPO "
Local cPict			:= ""
Local titulo		:= "INDICES DA QUALIDADE - IQF - IQP - IPO "
Local nLin			:= 80
Local Cabec1		:= ""
Local Cabec2		:= "" 
Local imprime		:= .T.

Private lEnd		:= .F.
Private lAbortPrint := .F.
Private CbTxt		:= ""
Private limite		:= 132
Private tamanho		:= "M"
Private nomeprog	:= "RQIER02"
Private nTipo		:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey	:= 0
Private cPerg		:= U_CriaPerg("QIER02")
Private cbtxt		:= Space(10)
Private cbcont		:= 00
Private CONTFL		:= 01
Private m_pag		:= 01
Private wnrel		:= "RQIER02"
Private cString 	:= ""

aAdd(aRegs,{cPerg,"01","Do Fornecedor"			,"","","mv_ch1","C",08,0,0,"G","","mv_par01",""				,"","",""						,"",""				,"","","","","","","","","","","","","","","","","","","SA2","S","","",""}) 
aAdd(aRegs,{cPerg,"02","Ate o Fornecedor?"		,"","","mv_ch2","C",08,0,0,"G","","mv_par02",""				,"","","ZZZZZZ"					,"",""				,"","","","","","","","","","","","","","","","","","","SA2","S","","",""}) 
aAdd(aRegs,{cPerg,"03","Do Produto ?"			,"","","mv_ch3","C",15,0,0,"G","","mv_par03",""				,"","",""						,"",""				,"","","","","","","","","","","","","","","","","","","SB1","S","","",""}) 
aAdd(aRegs,{cPerg,"04","Ate o Produto ?"		,"","","mv_ch4","C",15,0,0,"G","","mv_par04",""				,"","","ZZZZZZZZZZZZZZZ"		,"",""				,"","","","","","","","","","","","","","","","","","","SB1","S","","",""}) 
aAdd(aRegs,{cPerg,"05","Ano ?"					,"","","mv_ch5","C",04,0,0,"G","","mv_par05","    "			,"","",""						,"",""				,"","","","","","","","","","","","","","","","","","",""	,"S","","",""}) 
aAdd(aRegs,{cPerg,"06","Semestre?"				,"","","mv_ch6","N",01,0,0,"C","","mv_par06","1 Semestre"	,"","",""						,"","2 Semestre"	,"","","","","","","","","","","","","","","","","","",""	,"N","","",""}) 
aAdd(aRegs,{cPerg,"07","Indicador?"				,"","","mv_ch7","N",01,0,0,"C","","mv_par07","IQF"	,"","","","","IQP","","","","","IPO","","","","","","","","","","","","","",""		,"N","","",""}) 

lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

titulo:= "INDICES DA QUALIDADE - " + IIF( MV_PAR07 = 1, "IQF", IIF(MV_PAR07 = 2, "IQP", "IPO") )

//Monta a interface padrao com o usuario...
wnrel:= SetPrint(,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

// Processamento. RPTSTATUS monta janela com a regua de processamento.
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  30/06/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nTotReg	:= 0 
Local nColuna	:= 0
Local cTable	:= "QEV"
Local nLoop		:= IIF(mv_par06==1,1,7)
Local nLoopF	:= IIF(mv_par06==1,6,12)  
Local cQuery 	:= " SELECT QEV_FILIAL, QEV_ANO, QEV_FORNEC +'/'+ A2_LOJA QEV_FORNEC, A2_NOME " +  Chr(10)
Local aMeses	:= {"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
Local cCabec    := "  Fornecedor  Nome Fornecedor                                  "
local nTot1 	:= nTot2 := nTot3 := nTot4 := nTot5 := nTot6 := 0
local nQtd1 	:= nQtd2 := nQtd3 := nQtd4 := nQtd5 := nQtd6 := 0
Local cQEVIndicador   :=  "QEV_IQF"

if mv_par07 == 1
	cQEVIndicador   := "QEV_IQF" 
	cIndicador		:= "IQF"
elseif mv_par07 == 2
	cQEVIndicador   := "QEV_IQP"
	cIndicador		:= "IQP"	
else
	cQEVIndicador   := "QEV_IPO"
	cIndicador		:= "IPO"	
Endif

If Empty(mv_par02)
	mv_par02 := 'ZZZZZZ'
EndIf

If Empty(mv_par04)
	mv_par02 := 'ZZZZZZZZZZZZZZZ'
EndIf

For nLoop := nLoop To nLoopF

	cTable := "QEV" + AllTrim(Str(nLoop))
	
	nColuna++
	
	cQuery += " ,( " + Chr(10)
	cQuery += " SELECT ISNULL(CAST(SUM(" + cQEVIndicador + ") / COUNT(*) AS NUMERIC(10,2) ),0) " + Chr(10)
	cQuery += " FROM " + RetSQLName("QEV") + " " + cTable + Chr(10)
	cQuery += " WHERE " + Chr(10)
	cQuery += "     " + cTable + ".QEV_FILIAL	= QEV.QEV_FILIAL " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_ANO		= QEV.QEV_ANO "	 + Chr(10)
	cQuery += " AND " + cTable + ".QEV_MES		= " + AllTrim(StrZero(nLoop,2)) + " " + Chr(10)
	cQuery += " AND " + cTable + ".D_E_L_E_T_   = '' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_PRODUT >= '" + mv_par03 + "' " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_PRODUT <= '" + mv_par04 + "' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_FORNEC	= QEV.QEV_FORNEC ) MEDIA_" + AllTrim(Str(nColuna)) + " "    + Chr(10)
    
    cQuery += " ,( " + Chr(10)
  	cQuery += " SELECT ISNULL(CAST(SUM(QEV_IQF) / COUNT(*) AS NUMERIC(10,2) ),0) " + Chr(10)
	cQuery += " FROM " + RetSQLName("QEV") + " " + cTable  + Chr(10)
	cQuery += " WHERE " + Chr(10)
	cQuery += "     " + cTable + ".QEV_FILIAL	= QEV.QEV_FILIAL " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_ANO		= QEV.QEV_ANO "	 + Chr(10)
	cQuery += " AND " + cTable + ".QEV_MES		= " + AllTrim(StrZero(nLoop,2)) + " " + Chr(10)
	cQuery += " AND " + cTable + ".D_E_L_E_T_   = '' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_PRODUT >= '" + mv_par03 + "' " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_PRODUT <= '" + mv_par04 + "' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_FORNEC	= QEV.QEV_FORNEC ) IQFMEDIA_" + AllTrim(Str(nColuna)) + " "    + Chr(10)

	cQuery += " ,( " + Chr(10)
	cQuery += " SELECT COUNT(*)" + Chr(10)
	cQuery += " FROM " + RetSQLName("QEV") + " " + cTable  + Chr(10)
	cQuery += " WHERE " + Chr(10)
	cQuery += "     " + cTable + ".QEV_FILIAL	= QEV.QEV_FILIAL " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_ANO		= QEV.QEV_ANO "	 + Chr(10)
	cQuery += " AND " + cTable + ".QEV_MES		= " + AllTrim(StrZero(nLoop,2)) + " " + Chr(10)
	cQuery += " AND " + cTable + ".D_E_L_E_T_ = '' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_PRODUT >= '" + mv_par03 + "' " + Chr(10)
	cQuery += " AND " + cTable + ".QEV_PRODUT <= '" + mv_par04 + "' " + Chr(10)
	
	cQuery += " AND " + cTable + ".QEV_FORNEC	= QEV.QEV_FORNEC "  + Chr(10)

	cQuery += " AND " + cTable + ".QEV_FILIAL + " + cTable + ".QEV_FORNEC IN ( SELECT D1_FILIAL + D1_FORNECE FROM " + RetSqlName('SD1')           + Chr(10)
	cQuery +=                                                                 " WHERE " + cTable + ".QEV_FILIAL = D1_FILIAL"                      + Chr(10)	 
	cQuery +=                                                                 " AND   " + cTable + ".QEV_ANO    = SUBSTRING( D1_DTDIGIT, 1, 4)"   + Chr(10) 
	cQuery +=                                                                 " AND   " + cTable + ".QEV_MES    = SUBSTRING( D1_DTDIGIT, 5, 2)"   + Chr(10) 			
	cQuery +=                                                                 " AND   " + cTable + ".QEV_PRODUT BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' " + Chr(10)
	cQuery +=                                                                 " AND   " + cTable + ".QEV_FORNEC = D1_FORNECE"                     + Chr(10)
	cQuery +=                                                                 " AND D_E_L_E_T_ <> '*' ) ) MOVTO_" + AllTrim(Str(nColuna)) + " "   + Chr(10)
	
	//Esta variavel constroe o cabecalho de acordo com o semeste e os anos
	cCabec += aMeses[nLoop] + "/" + mv_par05 + "    "	

Next      

cQuery += " FROM " 	+ RetSQLName("QEV") + " QEV,  "   + Chr(10)
cQuery += " " 		+ RetSQLName("SA2") + " SA2 "     + Chr(10)
cQuery += " WHERE QEV_FILIAL = '"+xFilial("QEV")+"' " + Chr(10)
cQuery += " AND QEV.D_E_L_E_T_ = ' ' "                + Chr(10)
cQuery += " AND QEV_ANO     = '" + mv_par05 + "' "    + Chr(10)
cQuery += " AND QEV_FORNEC >= '" + mv_par01 + "' "    + Chr(10)
cQuery += " AND QEV_FORNEC <= '" + mv_par02 + "' "    + Chr(10)
cQuery += " AND QEV_PRODUT >= '" + mv_par03 + "' "    + Chr(10)
cQuery += " AND QEV_PRODUT <= '" + mv_par04 + "' "    + Chr(10)
cQuery += " AND QEV_FORNEC  = A2_COD "                + Chr(10)

//Verificação de o Fornecedor possui movimentaçao no periodo
cQuery += " AND QEV.QEV_MES >= '" + AllTrim(StrZero(nLoopF-5,2)) + "' " + Chr(10)
cQuery += " AND QEV.QEV_MES <= '" + AllTrim(StrZero(nLoopF  ,2)) + "' " + Chr(10)

cQuery += " GROUP BY QEV_FILIAL, QEV_FORNEC, A2_LOJA, A2_NOME, QEV_ANO " + Chr(10)
cQuery += " ORDER BY QEV_FILIAL, QEV_FORNEC, A2_LOJA, A2_NOME, QEV_ANO "

//Se já existir qualquer alias aberto com esse nome, ele encerra para abrir novamente sem erros
If Select("XQEV") > 0
	XQEV->(dbCloseArea())
EndIf   

Cabec1 := cCabec

//MemoWrite("\QUERYSYS\RQIER01.SQL",cQuery)

dbUseArea(.T.,'TOPCONN',TcGenQry(,,cQuery),"XQEV",.T.,.T.)      

dbSelectArea("XQEV")
//este codigo soma o total de registros, a serem incrementados na regua de processamento
XQEV->( dbEval( { || nTotReg++ },,{ || !Eof() } ))

dbGoTop()

SetRegua(nTotReg)

While !Eof() 

	IncRegua("Processando o Fornecedor :" + XQEV->QEV_FORNEC )

   //Verifica o cancelamento pelo usuario...
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //Impressao do cabecalho do relatorio. . .                            
   If nLin > 70 // Salto de Página. Neste caso o formulario tem 70 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
/*       1         2         3         4         5         6         7         8         9         0         1          2        3
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
  Fornecedor  Nome Fornecedor              Jan/2005     Fev/2005     Mar/2005     Abr/2005     Mai/2005     Jun/2005

*/
	@ nLin, 002 PSAY XQEV->QEV_FORNEC
	@ nLin, 020 PSAY XQEV->A2_NOME

	If XQEV->MOVTO_1 <> 0
		@ nLin, 065 PSAY XQEV->MEDIA_1 Picture '@E 999.99'
	Else
		@ nLin, 068 PSAY '-'		
	EndIf
	If XQEV->MOVTO_2 <> 0	
		@ nLin, 077 PSAY XQEV->MEDIA_2 Picture '@E 999.99'
	Else
		@ nLin, 080 PSAY '-'				
	EndIf		
	If XQEV->MOVTO_3 <> 0		
		@ nLin, 089 PSAY XQEV->MEDIA_3 Picture '@E 999.99'
	Else
		@ nLin, 092 PSAY '-'				
	EndIf		
	If XQEV->MOVTO_4 <> 0		
		@ nLin, 101 PSAY XQEV->MEDIA_4 Picture '@E 999.99'
	Else
		@ nLin, 104 PSAY '-'				
	EndIf	
	If XQEV->MOVTO_5 <> 0
		@ nLin, 113 PSAY XQEV->MEDIA_5 Picture '@E 999.99'
	Else
		@ nLin, 116 PSAY '-'				
	EndIf
	If XQEV->MOVTO_6 <> 0
		@ nLin, 125 PSAY XQEV->MEDIA_6 Picture '@E 999.99'
	Else
		@ nLin, 128 PSAY '-'				
	EndIf	

	nLin++
	
	nTot1+= XQEV->MEDIA_1
	
	IF cIndicador $ "IPO/IQP"
	  nQtd1+= IIF( XQEV->IQFMEDIA_1 > 0, 1, 0 )
	else
	  nQtd1+= IIF( XQEV->MEDIA_1    > 0, 1, 0 )
	ENDIF
	 
	nTot2+= XQEV->MEDIA_2
	
	IF cIndicador $ "IPO/IQP"
	   nQtd2+= IIF( XQEV->IQFMEDIA_2 > 0, 1, 0 )
    else
       nQtd2+= IIF( XQEV->MEDIA_2    > 0, 1, 0 )
	endif

	nTot3+= XQEV->MEDIA_3
	
	IF cIndicador $ "IPO/IQP"
	   nQtd3+= IIF( XQEV->IQFMEDIA_3 > 0, 1, 0 )
    else            
	   nQtd3+= IIF( XQEV->MEDIA_3    > 0, 1, 0 )
	endif
	
	nTot4+= XQEV->MEDIA_4

    IF cIndicador $ "IPO/IQP"
       nQtd4+= IIF( XQEV->IQFMEDIA_4 > 0, 1, 0 )
    else
	   nQtd4+= IIF( XQEV->MEDIA_4    > 0, 1, 0 )
	endif
	
	nTot5+= XQEV->MEDIA_5
	
	IF cIndicador $ "IPO/IQP"
       nQtd5+= IIF( XQEV->IQFMEDIA_5 > 0, 1, 0 )
    else
	   nQtd5+= IIF( XQEV->MEDIA_5    > 0, 1, 0 )
	ENDIF

	nTot6+= XQEV->MEDIA_6

	IF cIndicador $ "IPO/IQP"
      nQtd6+= IIF( XQEV->IQFMEDIA_6 > 0, 1, 0 )
    ELSE
	  nQtd6+= IIF( XQEV->MEDIA_6    > 0, 1, 0 )
	ENDIF
	   	
	dbSkip() // Avanca o ponteiro do registro no arquivo

EndDo 

//Caso a numeracao da inha não caiba o final do relatorio, parte para uma nova pagina
If nLin > 65 // Salto de Página. Neste caso o formulario tem 70 linhas...
   Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo )
   nLin:= 8
Endif

nLin+=2

@ nLin,063 PSAY "--------    --------    --------    --------    --------    --------"

nLin++

@ nLin,001 PSAY " Media Total Mensal do " + cIndicador + "         ----------------->"

@ nLin,065 PSAY nTot1 / nQtd1 Picture '@E 999.99'
@ nLin,077 PSAY nTot2 / nQtd2 Picture '@E 999.99'
@ nLin,089 PSAY nTot3 / nQtd3 Picture '@E 999.99'
@ nLin,101 PSAY nTot4 / nQtd4 Picture '@E 999.99'
@ nLin,113 PSAY nTot5 / nQtd5 Picture '@E 999.99'
@ nLin,125 PSAY nTot6 / nQtd6 Picture '@E 999.99'	

If aReturn[5]==1
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return