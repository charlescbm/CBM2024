#Include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  |RFATA11   บ Autor ณ AP6 IDE            บ Data ณ  05/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function RFATA11

Private cPerg   := "FATA11"
Private oLeTxt	:= {}
Private aRegs 	:= {}  
Private nTotReg := 0
Private lauto   := .f.
Private cLegVerd:= "1 - Com pedidos no mes corrente"
Private cLegAmar:= "3 - Com Pedidos em dois meses"
Private cLegVerm:= "5 - Sem pedidos nos ultimos dois meses"
Private cLegPret:= "7 - Sem pedidos ha mais de dois meses"	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Montagem da tela de processamento.                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

@ 200,1 TO 390,460 DIALOG oLeTxt TITLE OemToAnsi("Posi็ใo de clientes")  
@ 02,10 TO 080,190 
@ 10,018 Say " Este programa exibir uma posi็ใo de clientes, por representante, "	
@ 18,018 Say " conforme os parametros definidos pelo usuario "                         
@ 26,018 Say "                                                            "            

@ 26,198 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 40,198 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 54,198 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)    


aAdd( aRegs, { cPerg, "01", "Cliente de ?"      			,"", "", "MV_CH1", "C", 6, 0, 0, "G", "", "MV_PAR01", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SA1", "" , "", "", "", "" } )
aAdd( aRegs, { cPerg, "02", "Loja de ?"      		        ,"", "", "MV_CH2", "C", 2, 0, 0, "G", "", "MV_PAR02", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","   ", "" , "", "", "", "" } )
aAdd( aRegs, { cPerg, "03", "Cliente at้?"      			,"", "", "MV_CH3", "C", 6, 0, 0, "G", "", "MV_PAR03", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SA1", "" , "", "", "", "" } )
aAdd( aRegs, { cPerg, "04", "Loja ate ?"      		        ,"", "", "MV_CH4", "C", 2, 0, 0, "G", "", "MV_PAR04", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","   ", "" , "", "", "", "" } )
aAdd( aRegs, { cPerg, "05", "Representante de ?"			,"", "", "MV_CH5", "C", 6, 0, 0, "G", "", "MV_PAR05", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SA3", "" , "", "", "", "" } )
aAdd( aRegs, { cPerg, "06", "Representante at้?"			,"", "", "MV_CH6", "C", 6, 0, 0, "G", "", "MV_PAR06", ""   , "", "", "", "", ""	  ,"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","SA3", "" , "", "", "", "" } )
Aadd( aRegs, { cPerg, "07", "Inclui Clientes Bloqueados?"	,"", "", "MV_CH7", "C", 1, 0, 1, "C", "", "MV_PAR07", "Sim", "", "", "", "", "Nao","", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "","   ", "S", "", "", "", "" } )

//U_CriaSX1( aRegs )

Pergunte( cPerg, .F. )

//lValidPerg( aRegs )

Activate Dialog oLeTxt Centered

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ OKLETXT  บ Autor ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao chamada pelo botao OK na tela inicial de processamenบฑฑ
ฑฑบ          ณ to. Executa algumas verificacoes...                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function OkLeTxt()

Private cCodRep:= ''

If MV_PAR03 < MV_PAR01 
  	Alert( 'O C๓digo do Cliente "De" nใo pode ser maior que o C๓digo do Cliente "At้" : ')
	Return
ElseIf MV_PAR06 < MV_PAR05                                 
  	Alert( 'O C๓digo do Representante "De" nใo pode ser maior que o C๓digo do Representante "At้" :' )	
  	Return
EndIf

DbSelectArea("SA3")
DbSetOrder(7)

If DbSeek( xFilial("SA3") + __cUserId, .f. )
	While !Eof() .And. ( AllTrim( __cUserId ) == AllTrim( A3_CODUSR ) )
		If A3_TIPO <> 'I'
			cCodRep+= A3_COD + "','"
		EndIf	
		DbSkip()
	EndDo	
	cCodRep:= Subst( cCodRep, 1, Len ( cCodRep ) - 3 ) 
EndIf	

// Inicializa a regua de processamento                                 
Processa( { || U_GeraPa8(.f.) }, "Processando..." )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  05/05/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function GeraPa8( lauto )

Local cQuery:= ''
Local nLoop := 0

// elimina os dados antigos da tabela de estatisticas sempre de 1024 em 1024
// para nใo estourar o log do Top Connect  
cQuery:= " SELECT MIN(R_E_C_N_O_) PRIREC, MAX(R_E_C_N_O_) ULTREC FROM " + RetSQLName("PA8") 

If Select("TRB") > 0 
	TRB->( DbCloseArea() )
EndIf

cQuery := ChangeQuery( cQuery )

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), 'TRB', .f., .t. )    

TCSetField( 'TRB', "PRIREC", "N", 16, 0 )
TCSetField( 'TRB', "ULTREC", "N", 16, 0 )

nLoop  := TRB->PRIREC
nTotReg:= TRB->ULTREC 

TRB->( DbCloseArea() )

If nLoop > 0
   If lAuto = .t.	
	    For nLoop:=  nLoop To Max( nTotReg, 1024 ) Step 1024
		    cQuery := "DELETE FROM " + RetSqlName("PA8") + " WHERE "
		    cQuery += " R_E_C_N_O_ >=" + Str( nLoop, 10, 0 ) + " AND R_E_C_N_O_ <=" + Str( nLoop + 1023, 10, 0) + ""
		    cQuery += " AND PA8_IDUSER = 'lauto'" 
		    
		    MemoWrite( "\QUERYSYS\FATA11DEL.SQL", cQuery )
		    
		    TCSQLEXEC( cQuery ) 
		    TCRefresh("PA8")
	    Next nLoop
   Else
        For nLoop:=  nLoop To Max( nTotReg, 1024 ) Step 1024
		    cQuery := "DELETE FROM " + RetSqlName("PA8") + " WHERE "
		    cQuery += " R_E_C_N_O_ >=" + Str(nLoop, 10, 0 ) + " AND R_E_C_N_O_ <=" + Str( nLoop + 1023, 10, 0 ) + ""
		    cQuery += " AND PA8_IDUSER = '" + __cUserID + "'" 

		    MemoWrite("\QUERYSYS\FATA11DEL.SQL",cQuery)

		    TCSQLEXEC( cQuery ) 
		    TCRefresh("PA8")
	    Next nLoop
  EndIf

  DbSelectArea("PA8")
  DbCloseArea()

  ChkFile( "PA8", .f. )
EndIf       

cQuery := "SELECT A1_VEND, "                 + Chr(10)
cQuery += "       A1_COD + A1_LOJA A1_COD, " + Chr(10)
cQuery += "       A1_NREDUZ, "               + Chr(10)
cQuery += "       A1_MSBLQL , "              + Chr(10)
cQuery += "       A1_MUN, "                  + Chr(10) 
cQuery += "       CASE WHEN LEN( RTRIM(LTRIM(A1_DDD)) ) > 0 THEN RTRIM( LTRIM(A1_DDD) ) + ' - ' + RTRIM( LTRIM(A1_TEL) ) ELSE RTRIM( LTRIM(A1_TEL) ) END A1_TEL, "
cQuery += "       RTRIM( LTRIM(A1_DDD) ) + RTRIM( LTRIM(A1_TEL) ) A1_TEL, "              + Chr(10) 
cQuery += "       A1_CONTATO, " + Chr(10) 
cQuery += "       ISNULL( MAX(SC5.C5_EMISSAO), ' ' ) 	'ULTPED',"                       + Chr(10)

cQuery += " 	  ( SELECT ISNULL( SUM(SC6X.C6_QTDVEN * SC6X.C6_PRCVEN), 0 ) "           + Chr(10)
cQuery += "	       FROM " + RetSQLName("SC5") + " SC5X, " + RetSQLName("SC6") + " SC6X " + Chr(10)
cQuery += "	       WHERE " + Chr(10)
cQuery += "            SC5X.C5_CLIENTE = A1_COD "                                        + Chr(10)
cQuery += "        AND SC5X.C5_LOJACLI = A1_LOJA "                                       + Chr(10)
cQuery += "	       AND SC5X.C5_CANCELA <> 'S' "                                          + Chr(10)
cQuery += "	       AND SC5X.C5_EMISSAO <  '" + DToS(FirstDay(dDatabase)) + "' "          + Chr(10)
cQuery += "	       AND SC5X.C5_EMISSAO >= '" + DToS(FirstDay(dDatabase - 60)) + "' "     + Chr(10)
cQuery += "	       AND SC5X.C5_FILIAL	= SC6X.C6_FILIAL "                               + Chr(10)
cQuery += "	       AND SC5X.C5_NUM		= SC6X.C6_NUM "                                  + Chr(10)
cQuery += "	       AND SC5X.C5_CLIENTE	= SC6X.C6_CLI "                                  + Chr(10)
cQuery += "	       AND SC5X.C5_CANCELA <> 'S'         "                                  + Chr(10)
//cQuery += "	       AND SC5X.C5_AMOSTRA	= '2'         "                                  + Chr(10)
cQuery += "	       AND SC6X.C6_BLQ 	   <> 'R' "                                          + Chr(10)
cQuery += "	       AND SC5X.D_E_L_E_T_  = ' ' "                                          + Chr(10)
cQuery += "	       AND SC6X.D_E_L_E_T_  = ' ')	'TOTPEDMESANT',"               + Chr(10) + Chr(10)

cQuery += "	      (SELECT ISNULL( SUM(SC6X.C6_QTDVEN * SC6X.C6_PRCVEN), 0 ) "            + Chr(10)
cQuery += "	       FROM " + RetSQLName("SC5") + " SC5X, " + RetSQLName("SC6") + " SC6X " + Chr(10)
cQuery += "	       WHERE "                                                               + Chr(10)
cQuery += "            SC5X.C5_CLIENTE = A1_COD "                                        + Chr(10)
cQuery += "        AND SC5X.C5_LOJACLI = A1_LOJA "                                       + Chr(10)
cQuery += "        AND SC5X.C5_CANCELA 	<> 'S' "                                         + Chr(10)
cQuery += "        AND SC5X.C5_EMISSAO 	>= '" + DToS(FirstDay(dDatabase)) + "' "         + Chr(10)
cQuery += "        AND SC5X.C5_FILIAL	= SC6X.C6_FILIAL "                               + Chr(10)
cQuery += "        AND SC5X.C5_NUM		= SC6X.C6_NUM "                                  + Chr(10)
cQuery += "        AND SC5X.C5_CLIENTE	= SC6X.C6_CLI "                                  + Chr(10)
cQuery += "        AND SC5X.C5_CANCELA <> 'S' "                                          + Chr(10)
//cQuery += "        AND SC5X.C5_AMOSTRA	= '2' "                                          + Chr(10)
cQuery += "        AND SC5X.D_E_L_E_T_  = ' ' "                                          + Chr(10)
cQuery += "        AND SC6X.D_E_L_E_T_  = ' ' ) 'TOTPEDMES',"               + Chr(10)    + Chr(10)

cQuery += "	       ISNULL((SELECT COUNT(*) "                                             + Chr(10)
cQuery += "	       FROM " + RetSQLName("SC5") + " SC5C "                                 + Chr(10)
cQuery += "	       WHERE "
cQuery += "            SC5C.C5_CLIENTE = A1_COD "                                        + Chr(10)
cQuery += "        AND SC5C.C5_LOJACLI = A1_LOJA "                                       + Chr(10)
cQuery += "        AND SC5C.C5_EMISSAO >= '" + DTos(FirstDay(dDatabase)) + "'"           + Chr(10)
cQuery += "        AND SC5C.C5_CANCELA <> 'S' " 
//cQuery += "        AND SC5C.C5_AMOSTRA = '2' " 
cQuery += "        AND SC5C.D_E_L_E_T_ = ' '),0) 	'NRPEDMES'"                          + Chr(10)

cQuery += " FROM " + RetSQLName("SA1") + " SA1"                                          + Chr(10)
cQuery += "          LEFT JOIN " + RetSQLName("SC5") + " SC5 ON   SA1.A1_COD = SC5.C5_CLIENTE " + Chr(10)
cQuery += "	       	       	       	       	       	     AND SA1.A1_LOJA = SC5.C5_LOJACLI "     + Chr(10) 
cQuery += "	       	       	       	       	       	     AND SC5.C5_TIPO 	NOT IN ('B','D')"   + Chr(10) 
cQuery += "	       	       	       	       	       	     AND SC5.C5_CANCELA <> 'S' "            + Chr(10) 
//cQuery += "	       	       	       	       	       	     AND SC5.C5_AMOSTRA = '2' "             + Chr(10) 
cQuery += " WHERE "                                                                             + Chr(10)

If lauto = .t.
     cQuery += "     SA1.A1_COD  >= '      '"            + Chr(10)
     cQuery += " AND SA1.A1_COD  <= 'ZZZZZZ'"            + Chr(10)
     cQuery += " AND SA1.A1_VEND >= '      '"            + Chr(10)
     cQuery += " AND SA1.A1_VEND <= 'ZZZZZZ'"            + Chr(10)
Else
     cQuery += "     SA1.A1_COD  >= '" + MV_PAR01 + "'"  + Chr(10)
     cQuery += " AND SA1.A1_COD  <= '" + MV_PAR03 + "'"  + Chr(10)     
     cQuery += " AND SA1.A1_LOJA >= '" + MV_PAR02 + "'"  + Chr(10)
     cQuery += " AND SA1.A1_LOJA <= '" + MV_PAR04 + "'"  + Chr(10)
     cQuery += " AND SA1.A1_VEND >= '" + MV_PAR05 + "'"  + Chr(10)
     cQuery += " AND SA1.A1_VEND <= '" + MV_PAR06 + "'"  + Chr(10)

     If MV_PAR07 == 2
	    cQuery += " AND SA1.A1_MSBLQL = '2' "            + Chr(10)
     Endif

	 If  !Empty( cCodRep )
	     cQuery += " AND SA1.A1_VEND IN ('" + cCodRep + "')" + Chr(10)
     else
         cQuery += " AND SA1.A1_VEND >= '" + MV_PAR05 + "'"  + Chr(10)
         cQuery += " AND SA1.A1_VEND <= '" + MV_PAR06 + "'"  + Chr(10)
     endif
     

EndIf

cQuery += " AND SA1.D_E_L_E_T_ = ' '"                    + Chr(10) 
cQuery += " GROUP BY SA1.A1_VEND, SA1.A1_COD, A1_LOJA, SA1.A1_NREDUZ, SA1.A1_MSBLQL, A1_MUN, A1_DDD, A1_TEL, A1_CONTATO "
cQuery += " ORDER BY SA1.A1_VEND, SA1.A1_COD, A1_LOJA " 

MemoWrite( "\QUERYSYS\RFATA11.SQL", cQuery )

If Select("TRB") > 0 
	TRB->( dbCloseArea() )
EndIf

cQuery:= ChangeQuery(cQuery)

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), 'TRB', .f., .t.)

TCSetField( 'TRB', "ULTPED"      ,"D", 08, 0 )
TCSetField( 'TRB', "TOTPEDMES"   ,"N", 16, 2 )
TCSetField( 'TRB', "TOTPEDMESANT","N", 16, 2 )
TCSetField( 'TRB', "NRPEDMES"    ,"N", 16, 2 )
                  
DbSelectArea('TRB')

nTotReg:= 0

TRB->( dbEval( { || nTotReg++ },,{ || !Eof() } ) )

ProcRegua( nTotReg ) // Numero de registros a processar

DbSelectArea('TRB')
DbGoTop()

While !Eof() 

	IncProc( "Calculando Cliente : " + TRB->A1_NREDUZ )

	DbSelectArea("PA8")	     

	RecLock( 'PA8', .t. )		

 	PA8->PA8_VENDED:= TRB->A1_VEND 
 	PA8->PA8_CODCLI:= TRB->A1_COD                        
  	PA8->PA8_NREDUZ:= TRB->A1_NREDUZ         
 	PA8->PA8_ULTPED:= TRB->ULTPED
 	PA8->PA8_TOTANT:= TRB->TOTPEDMESANT 
 	PA8->PA8_TOTPED:= TRB->TOTPEDMES
  	PA8->PA8_NRPEDM:= TRB->NRPEDMES          
  	PA8->PA8_MSBLQL:= TRB->A1_MSBLQL 

  	If lauto = .t.
  	   PA8->PA8_IDUSER:= 'lauto'
  	Else
  	   PA8->PA8_IDUSER:= __cUserId
  	EndIf
  	   
  	PA8->PA8_MUN   := TRB->A1_MUN
  	PA8->PA8_TEL   := TRB->A1_TEL
  	PA8->PA8_CONTAT:= TRB->A1_CONTATO	  	

	/*
	Ordem da Legenda, para que aparecam em ordem de interesse de visualiza็ใo

	Verde	 1
	Amarelo  3
	Vermelho 5
	Preto    7
	*/    	

  	If PA8_NRPEDM > 0 
  		PA8->PA8_LEGEND:= "1"	//Verde
  	ElseIf PA8_ULTPED <  FirstDay(dDatabase) .And. PA8_ULTPED >= FirstDay(dDatabase)-90	.And. PA8_TOTANT > 0 
  		PA8->PA8_LEGEND:= "3"	//AMARELO
 	ElseIf PA8_ULTPED <  FirstDay(dDatabase) .And. PA8_ULTPED >= FirstDay(dDatabase)-90 .And. PA8_TOTANT == 0
  		PA8->PA8_LEGEND:= "5"	//VERMELHO
  	ElseIf PA8_ULTPED < FirstDay(dDatabase) - 90
  		PA8->PA8_LEGEND:= "7"	//PRETO
  	EndIf
  	  	 	
  	MsUnlock()
      	
	DbSelectArea("TRB")	 
	DbSkip()

EndDo	

If lauto = .f.
   FATA11Brw()
EndIf

PA8->( DbCloseArea() )

Return        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บAutor  ณ                    บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function FATA11Brw

Local 	aFixos 	 := {}
Local 	aCores 	 := {} 
Local 	aIndexPA8:= {}

Private	aRotina  := {}
Private	cCadastro:= "" //"Cadastro de Software"

aAdd( aRotina, { "Pesquisar" 	, "AxPesqui" 	,	0	,	1 })  
aAdd( aRotina, { "Legenda"		, "u_FATA11Leg",	0	,	2 })
aAdd( aRotina, { "Exporta"		, "u_FATA11Exp",	0	,	3 })		

//aCores := {	{"PA8_NRPEDM > 0 ",'ENABLE'},;//Cliente com pedidos no mes
//				{"PA8_ULTPED < FirstDay(dDatabase).And.PA8_ULTPED>FirstDay(dDatabase)-60.And.PA8_TOTANT > 0 ",'BR_AMARELO'},; //cliente com saldo de pedido de mese anterior
//				{"PA8_ULTPED > FirstDay(dDatabase) - 60 .And. PA8_TOTPED == 0 ",'DISABLE'},; //Clientes com pedido nos ultimos 2 meses
//				{"PA8_ULTPED < FirstDay(dDatabase) - 60"								,'BR_PRETO'}}	//Clientes sem pedidos nos ultimos 2 meses

aCores := {	{ "PA8_LEGEND=='1'", 'ENABLE'     },;	//Cliente com pedidos no mes
			{ "PA8_LEGEND=='3'", 'BR_AMARELO' },; 	//cliente com saldo de pedido de mese anterior
			{ "PA8_LEGEND=='5'", 'DISABLE'    },; 	//Clientes com pedido nos ultimos 2 meses
			{ "PA8_LEGEND=='7'", 'BR_PRETO'   }}	//Clientes sem pedidos nos ultimos 2 meses

cFiltraPA8:= "PA8_IDUSER==__cUserID"

//Filtra o arquivo com dados do usuario atual
bFiltraBrw 	:= {|| FilBrowse( "PA8", @aIndexPA8, @cFiltraPA8 ) }
Eval(bFiltraBrw)

DbSelectArea("PA8")
DbSetOrder(1)
DbGoTop()

mBrowse( 6, 1, 22, 75, 'PA8',,,,,, aCores )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRestaura o filtro inicial                                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
EndFilBrw( 'PA8', aIndexPA8 )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFun…o    ณFata11Leg  ณ Autor ณ                      ณ Data ณ          ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณCria uma janela contendo a legenda da mBrowse               ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ Uso      ณ                                                            ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function Fata11Leg  

/*
Ordem da Legenda, para que aparecam em orde de interesse de visualiza็ใo

Verde	 1
Amarelo  3
Vermelho 5
Preto    7
*/  
BrwLegenda( cCadastro, "Legenda de Clientes :", { { "ENABLE"    , @cLegVerd },; 	
								 				  { "BR_AMARELO", @cLegAmar },;
												  { "DISABLE"   , @cLegVerm },;
								 				  { "BR_PRETO"  , @cLegPret }})
Return(.t.)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRFATA11ExpบAutor  ณ                    บ Data ณ  06/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao que faz a exportacao dos dados, para excel ou para  บฑฑ
ฑฑบ          ณ relatorio, dependendo da escolha do usuario                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function FATA11Exp  

// Inicializa a regua de processamento                                 
Processa( {|| RunExcel() },"Processando..." )
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RunExcel บAutor  ณ                    บ Data ณ  06/09/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Gera planilha excel                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunExcel()

Local cQuery := ""
Local aArray := {}
Local nTotOld:= nTotNew := 0 
Local cLegAnt:= "" 

If nTotReg == 0 //Esta variavel publica 
	Return
EndIf

aAdd( aArray, { "LEGENDA"	, "C", 040, 0 } )
aAdd( aArray, { "VENDEDOR"	, "C", 006, 0 } )
aAdd( aArray, { "CODCLIENTE", "C", 006, 0 } )
aAdd( aArray, { "NREDUZIDO"	, "C", 020, 0 } )
aAdd( aArray, { "ULTPEDIDO"	, "D", 008, 0 } )
aAdd( aArray, { "TOTANTERIO", "N", 016, 2 } )
aAdd( aArray, { "TOTPEDMES"	, "N", 016, 2 } )
aAdd( aArray, { "NRPEDMES"	, "N", 016, 0 } )
aAdd( aArray, { "CLIBLOQ"	, "C", 003, 0 } )
aAdd( aArray, { "MUN"		, "C", 040, 0 } )
aAdd( aArray, { "TEL"		, "C", 040, 0 } )
aAdd( aArray, { "CONTAT"	, "C", 015, 0 } )

_cArqCbc := CriaTrab(aArray,.T.)
DbUseArea( .t.,, _cArqCbc, "MP01", .f., .f. )

// executa a query em ambas os bancos de dados
            
cQuery := " SELECT PA8_LEGEND, PA8_VENDED, PA8_CODCLI, PA8_NREDUZ, PA8_ULTPED, "
cQuery += " PA8_TOTANT, PA8_TOTPED, PA8_NRPEDM, PA8_MSBLQL, PA8_MUN, PA8_TEL, PA8_CONTAT "
cQuery += " FROM " + RetSQLName("PA8") 
cQuery += " WHERE "
cQuery += "     PA8_IDUSER = '" + __cUserID + "'"
cQuery += " AND D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY PA8_VENDED, PA8_LEGEND, PA8_CODCLI "

If Select("TRB") > 0 
	TRB->( DbCloseArea() )
EndIf

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), 'TRB', .f., .t. )    

TCSetField( 'TRB', "PA8_ULTPED" , "D", 08, 0 )
TCSetField( 'TRB', "PA8_TOTANT" , "N", 16, 2 )
TCSetField( 'TRB', "PA8_TOTPED" , "N", 16, 2 )
TCSetField( 'TRB', "PA8_NROPED" , "N", 16, 2 )

DbSelectArea('TRB')

nTotReg:= 0

TRB->( dbEval( { || nTotReg++ },,{ || !Eof() } ) )

ProcRegua( nTotReg ) // Numero de registros a processar

DbGoTop()

While !Eof() 

	IncProc( "Exportanto para Excel ... : " + TRB->PA8_CODCLI ) 
	
	If !cLegAnt == TRB->PA8_LEGEND  

  		DbSelectArea('MP01')
		RecLock('MP01', .t. )
			Do Case
		      	Case TRB->PA8_LEGEND == "1"
							MP01->LEGENDA 	:= @cLegVerd
		      	Case TRB->PA8_LEGEND == "3"
							MP01->LEGENDA 	:= @cLegAmar
		      	Case TRB->PA8_LEGEND == "5"
							MP01->LEGENDA 	:= @cLegVerm
		      	Case TRB->PA8_LEGEND == "7"
							MP01->LEGENDA 	:= @cLegPret
		   	EndCase
			MP01->VENDEDOR:= TRB->PA8_VENDED 
		MsUnlock()
		
		cLegAnt:= TRB->PA8_LEGEND 
	
	EndIf
	
  	DbSelectArea('MP01')
	RecLock( 'MP01', .t. )   
		MP01->CODCLIENTE:= TRB->PA8_CODCLI
		MP01->NREDUZIDO := TRB->PA8_NREDUZ
		MP01->ULTPEDIDO := TRB->PA8_ULTPED
		MP01->TOTANTERIO:= TRB->PA8_TOTANT
		MP01->TOTPEDMES := TRB->PA8_TOTPED
		MP01->NRPEDMES 	:= TRB->PA8_NRPEDM
		MP01->CLIBLOQ 	:= Iif( TRB->PA8_MSBLQL = '1', 'SIM', 'NAO' )
		MP01->MUN		:= TRB->PA8_MUN
		MP01->TEL		:= TRB->PA8_TEL
		MP01->CONTAT	:= TRB->PA8_CONTAT
	MsUnlock()
	             	
	DbSelectArea('TRB')
	DbSkip()
EndDo	

U_ProcExcel('MP01')

TRB-> ( DbCloseArea() )   
MP01->( DbCloseArea() )

FERASE( _cArqCbc + '.DBF')

Return 