#Include "Protheus.ch"
#Include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ RCTBA03	³ Autor ³ Elias Reis    	    ³ Data ³ 25/07/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Funcao para descontabilizacao manual financeiro            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³                											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³                 											  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RCTBA03  

Local aRegs     := {}
Local cPerg     := U_CriaPerg("CTBA03")

Private oGeraTxt
Private cString := ""          

aAdd(aRegs,{cPerg,"01","Data Inicial?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Data Final  ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Origem      ?","","","mv_ch9","N",01,0,1,"C","","mv_par03","Compras","","","","","Faturamento","","","","","Financeiro","","","","","","","","","","","","","","","S","","","" })
aAdd(aRegs,{cPerg,"04","Filial      ?","","","mv_ch3","C",10,0,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","" })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 200,1 TO 380,430 DIALOG oGeraTxt TITLE OemToAnsi("Estorno de Contabilização")
@ 02,10 TO 080,270
@ 10,018 Say " Este programa ira desfazer os movimentos gerados na contabilidade  "
@ 18,018 Say " e limpar as flags de contabilização do modulo selecionado, conforme"
@ 26,018 Say " os parametros definido pelo usuario.                               "
                 
If lValidPerg(aRegs)
	Pergunte(cPerg,.F.)
EndIf

@ 70,128 BMPBUTTON TYPE 1 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
@ 70,188 BMPBUTTON TYPE 2 ACTION Close(oGeraTxt)

Activate Dialog oGeraTxt Centered

Return


*******************************************
******* ENCAMINHA A FUNCAO DESEJADA **********
*******************************************
Static Function OkGeraTxt

Local cFuncao := ""

If mv_par03 == 1 
   cFuncao := "EstCom()"
ElseIf mv_par03 == 2
   cFuncao := "EstFat()"
ElseIf mv_par03 == 3
   cFuncao := "EstFin()"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Processa({|| &(cFuncao) },"Processando...") 

Close(oGeraTxt)

Return


*******************************************
*** ESTORNA A CONTABILIZACAO DO FINANCEIRO ****
*******************************************
Static Function EstFin()
Local cQuery    := ""

// Desmarca SE5 para reprocessamento
cQuery := " UPDATE SE5010 
cQuery += " SET E5_LA = ' ' 
cQuery += " WHERE E5_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		AND E5_LA ='S'
cQuery += " 		AND E5_SITUACA <> 'C'
cQuery += " 		AND E5_MOTBX <> 'FAT'
cQuery += " 		AND (E5_TIPODOC IN ('BA','VL','V2','DC','D2','JR','J2', 'MT','M2','CM','C2','AP', 'EP','PE','RF','IF', 'CP','TL','ES','TR','DB','OD','LJ','E2','TE','PE','  ')
cQuery += "      		  OR (E5_TIPODOC = ' ' AND E5_LOTE = ' ') 
cQuery += "      		  OR (E5_TIPO = 'RA' AND (E5_MOTBX <> 'NOR' OR (E5_MOTBX = 'NOR' AND E5_RECPAG <> 'R')))
cQuery += "      		  OR (E5_TIPO = 'PA' AND (E5_MOTBX <> 'NOR' OR (E5_MOTBX = 'NOR' AND E5_RECPAG <> 'P'))))
cQuery += " 		AND D_E_L_E_T_ <> '*'   
TCSQLEXEC(cQuery)

// Desmarca SE1 para reprocessamento
cQuery := " UPDATE SE1010 
cQuery += " SET E1_LA =' '
cQuery += " WHERE E1_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		AND E1_LA ='S'
cQuery += " 		AND (E1_ORIGEM LIKE 'FIN%' OR E1_ORIGEM = ' ')
cQuery += " 		AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

// Desmarca SE2 para reprocessamento
cQuery := " UPDATE SE2010 
cQuery += " SET E2_LA =' ' 
cQuery += " WHERE E2_EMIS1 BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		AND E2_LA ='S'
cQuery += " 		AND E2_MULTNAT IN  ('2',' ')
cQuery += " 		AND (E2_ORIGEM LIKE 'FIN%' OR E2_ORIGEM = ' ')
cQuery += " 		AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

// Desmarca SE2 para reprocessamento
cQuery := " UPDATE SEF010 
cQuery += " SET EF_LA =' '
cQuery += " WHERE EF_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		AND EF_LA ='S'
cQuery += " 		AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

// Desmarca CT2 para reprocessamento
cQuery := " UPDATE CT2010 
cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_
cQuery += " WHERE CT2_FILIAL =' ' 
cQuery += " AND CT2_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
//cQuery += " 		AND CT2_LP <> '599'
cQuery += " 		AND CT2_LOTE IN ('008850','8850','002905')
cQuery += " 		AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

// ATUALIZA FLAGS DOS TITULOS COM MULTIPLAS NATUREZAS  -- PROCESSAR TAMBEM PARA OS ARQUIVOS COMPLEMENTARES SEV E SEZ
cQuery := " UPDATE SE2010 
cQuery += " SET E2_LA =' ' 
cQuery += " WHERE E2_FILIAL BETWEEN ' ' AND 'ZZ'
cQuery += " AND E2_EMIS1 BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND E2_MULTNAT ='1'  
cQuery += " AND E2_NUMDATA =' '
cQuery += " AND E2_LA ='S'
cQuery += " AND (E2_ORIGEM LIKE 'FIN%' OR E2_ORIGEM = ' ')
cQuery += " AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

cQuery := " UPDATE SEV010 SET EV_LA =' '
cQuery += " FROM SE2010 
cQuery += " WHERE E2_FILIAL BETWEEN ' ' AND 'ZZ'
cQuery += " AND EV_FILIAL = E2_FILIAL
cQuery += " AND EV_PREFIXO = E2_PREFIXO
cQuery += " AND EV_NUM = E2_NUM
cQuery += " AND EV_CLIFOR = E2_FORNECE 
cQuery += " AND EV_LOJA = E2_LOJA
cQuery += " AND E2_EMIS1 BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND E2_MULTNAT ='1'
cQuery += " AND E2_NUMDATA =' '
cQuery += " AND (E2_ORIGEM LIKE 'FIN%' OR E2_ORIGEM = ' ')
cQuery += " AND SEV010.D_E_L_E_T_ <> '*'
cQuery += " AND SE2010.D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

cQuery := " UPDATE SEZ010 SET EZ_LA =' '
cQuery += " FROM SE2010
cQuery += " WHERE E2_FILIAL BETWEEN ' ' AND 'ZZ'
cQuery += " AND EZ_FILIAL = E2_FILIAL
cQuery += " AND EZ_PREFIXO = E2_PREFIXO
cQuery += " AND EZ_NUM = E2_NUM
cQuery += " AND EZ_CLIFOR = E2_FORNECE 
cQuery += " AND EZ_LOJA = E2_LOJA
cQuery += " AND E2_EMIS1 BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND E2_MULTNAT ='1'
cQuery += " AND E2_NUMDATA =' '
cQuery += " AND (E2_ORIGEM LIKE 'FIN%' OR E2_ORIGEM = ' ')
cQuery += " AND SEZ010.D_E_L_E_T_ <> '*'
cQuery += " AND SE2010.D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

Return  

*******************************************
*** ESTORNA A CONTABILIZACAO DO FATURAMENTO ***
*******************************************
Static Function EstFat()
Local cQuery    := ""

// Desmarca lancamentos de saida para recontabilizacao
cQuery := " UPDATE SF2010
cQuery += " SET F2_DTLANC = ''
//cQuery += " WHERE F2_FILIAL IN ('01','02','03','04')
cQuery += " WHERE F2_FILIAL IN  ('"+StrTran(MV_PAR04,"/","','")+"')                           
cQuery += " AND F2_EMISSAO BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

// Desmarca CT2 para reprocessamento
cQuery := " UPDATE CT2010 
cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_, CT2_SEGOFI = ' '
cQuery += " WHERE CT2_FILIAL IN ('"+StrTran(MV_PAR04,"/","','")+"')
cQuery += " AND CT2_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
//cQuery += " 		AND CT2_LP = '610'
cQuery += " AND CT2_LOTE IN ('008820')
cQuery += " AND CT2_FILORI IN ('"+StrTran(MV_PAR04,"/","','")+"')
cQuery += " AND D_E_L_E_T_ <> '*'
TCSQLEXEC(cQuery)

Return


*******************************************
*** ESTORNA A CONTABILIZACAO DO COMPRAS *******
*******************************************
Static Function EstCom()
Local cQuery    := ""

// Desmarca lancamentos de entrada para recontabilizacao
cQuery := " UPDATE SF1010
cQuery += " SET F1_DTLANC = ' '
//cQuery += " WHERE F1_FILIAL IN ('01','02','03','04')
cQuery += " WHERE F1_FILIAL IN ('"+StrTran(MV_PAR04,"/","','")+"')
cQuery += " 		AND F1_DTDIGIT BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
cQuery += " 		AND D_E_L_E_T_ <> '*'
//MemoWrite("\QUERYSYS\RCTBA02_C1.SQL",cQuery)
TCSQLEXEC(cQuery)

// Desmarca CT2 para reprocessamento
cQuery := " UPDATE CT2010 
cQuery += " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ 
cQuery += " WHERE CT2_FILIAL IN ('"+StrTran(MV_PAR04,"/","','")+"')
cQuery += " AND CT2_DATA BETWEEN '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"'"
//cQuery += " 		AND CT2_LP = '650'
cQuery += " 		AND CT2_LOTE IN ('008810')
cQuery += " AND CT2_FILORI IN ('"+StrTran(MV_PAR04,"/","','")+"')
cQuery += " 		AND D_E_L_E_T_ <> '*'
//MemoWrite("\QUERYSYS\RCTBA02_C2.SQL",cQuery)
TCSQLEXEC(cQuery)

Return