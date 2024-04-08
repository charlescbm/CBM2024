#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ COMR001  บ Autor ณ SSERVICES          บ Data ณ  09/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ     Emite relatorio de curva abc de fornecedores por nota  บฑฑ
ฑฑบ          ณ fiscal de entrada.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function COMR001()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := ""
Local Titulo       := "CURVA ABC DE COMPRAS"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local aOrd 		   := {}

Private limite     := 80
Private tamanho    := "G"
Private nomeprog   := "COMR001"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1 }
Private nLastKey   := 0
Private cBTxt      := Space(10)
Private cBCont     := 00
Private m_pag      := 1
Private wnrel      := "COMR001"
Private cString	   := "SD1"
Private _cPerg	   := Padr( 'COMR001', Len( SX1->X1_GRUPO ) )
/*/
ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
ณ Variaveis utilizadas para parametros                         ณ
ณ MV_PAR01    Da  Data                                         ณ
ณ MV_PAR02    Ate Data                                         ณ
ณ MV_PAR03    Percentual para A                                ณ
ณ MV_PAR04    Percentual para B                                ณ
ณ MV_PAR05    Tipo de Produto                                  ณ
ณ MV_PAR06    Do  Fornecedor                                   ณ
ณ MV_PAR07    Ate Fornecedor                                   ณ
ณ MV_PAR08    Do  Produto                                      ณ
ณ MV_PAR09    Ate Produto                                      ณ
ณ MV_PAR10    Do  Local                                        ณ
ณ MV_PAR11    Ate Local                                        ณ
ณ MV_PAR12    Da  Filial                                       ณ
ณ MV_PAR13    Ate Filial                                       ณ
ณ MV_PAR14    Tipo do Relatorio                                ณ
ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*/
ValPergunte( _cPerg )

While .t.
	If !Pergunte( _cPerg, .t. )
		Return
	EndIf
	
	If Empty( MV_PAR01 ) .Or. Empty( MV_PAR02 )
		Alert( 'Necessario digitar as datas!..' )
		Loop
	EndIf
	
	If Empty( MV_PAR03 ) .Or. Empty( MV_PAR04 )
		Alert( 'Necessario digitar os pecentuais!..' )
		Loop
	EndIf		
	
	Exit
EndDo	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := SetPrint( cString, NomeProg, _cPerg, @titulo, cDesc1, cDesc2, cDesc3, .t., aOrd, .t., Tamanho,, .t. )

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
   Return
Endif

nTipo := If( aReturn[4] == 1, 15, 18 )
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RptStatus( { || RunReport( Cabec1, Cabec2, Titulo, nLin) },Titulo )
Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  09/04/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport( Cabec1, Cabec2, Titulo, nLin )

Private cDUPLICATA	:= CriaVar('E2_NUM'   , .f., 'L' )
Private cTES		:= CriaVar('F4_CODIGO', .f., 'L' )
Private cDESCR		:= CriaVar('A2_NOME'  , .f., 'L' )
Private cUM			:= CriaVar('D1_UM'    , .f., 'L' )
Private cSubTit		:= ''
Private aCAMPOS		:= {}
Private cNOMEARQ	:= {}
Private cCHAVE		:= {}
Private cCAMPO		:= {}
Private cQUEBRA		:= {}
Private cDESC		:= {}
Private cCLASSE		:= ' '
Private nTOTAL		:= 0
Private nTOTGER		:= 0
Private nTOTPER		:= 0
Private nTotFxA		:= 0 
Private nTotFxB		:= 0 
Private nTotFxC		:= 0
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria array para gerar arquivo de trabalho                    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
aCampos:= {}
AADD( aCampos,{ 'TRB_COD'     , "C", 15, 0 } )
AADD( aCampos,{ 'TRB_LOCAL'   , "C", 02, 0 } )
AADD( aCampos,{ 'TRB_DESC'    , "C", 40, 0 } )
AADD( aCampos,{ 'TRB_FORNEC'  , "C", 08, 0 } )
AADD( aCampos,{ 'TRB_LOJA'    , "C", 04, 0 } )
AADD( aCampos,{ 'TRB_NOME'    , "C", 40, 0 } )
AADD( aCampos,{ 'TRB_UM'      , "C", 02, 0 } )
AADD( aCampos,{ 'TRB_QUANT'   , "N", 18, 6 } )
AADD( aCampos,{ 'TRB_PRECO'   , "N", 18, 6 } )
AADD( aCampos,{ 'TRB_TOTAL'   , "N", 18, 2 } )
AADD( aCampos,{ 'TRB_PERC'    , "N", 10, 6 } )

cNomeArq:= CriaTrab( aCampos )
DbUseArea( .t.,, cNomeArq, 'TRB', .t., .f. )

DbSelectArea( 'TRB' )

If MV_PAR14 = 1
	IndRegua( 'TRB', cNomeArq, 'TRB_FORNEC',,, 'Selecionando Registros!...' )
	
	cSubTit:= ' POR FORNECEDOR'
	cSubTit+= ' DA FILIAL: '  + AllTrim( MV_PAR12 ) + ' A '  + AllTrim( MV_PAR13 )
	cSubTit+= ' DO PRODUTO: ' + AllTrim( MV_PAR08 ) + ' AO ' + AllTrim( MV_PAR09 )
	cSubTit+= ' DO LOCAL: '   + AllTrim( MV_PAR10 ) + ' A0 ' + AllTrim( MV_PAR11 )	
	If Empty( MV_PAR06 ) .And. Empty( MV_PAR08 )
                   
		Cabec1 := "FORNECEDOR      NOME                                            QUANTIDADE            PRECO                TOTAL    % ITEM             ACUMULADO   %ACUMULADO CLASSE"
	Else
		Cabec1 := "FORNECEDOR      NOME                                            QUANTIDADE            PRECO                TOTAL    % ITEM             ACUMULADO   %ACUMULADO"
	EndIf	
Else
	IndRegua( 'TRB', cNomeArq, 'TRB_COD'   ,,, 'Selecionando Registros!...' )

	cSubTit:= ' POR PRODUTO'
	cSubTit+= ' DA FILIAL: '     + AllTrim( MV_PAR12 ) + ' A '  + AllTrim( MV_PAR13 )
	cSubTit+= ' DO FORNECEDOR: ' + AllTrim( MV_PAR06 ) + ' AO ' + AllTrim( MV_PAR07 )
	cSubTit+= ' DO LOCAL: '      + AllTrim( MV_PAR10 ) + ' A0 ' + AllTrim( MV_PAR11 )	
	If Empty( MV_PAR06 ) .And. Empty( MV_PAR08 )
		Cabec1 := "PRODUTO         DESCRICAO                                       QUANTIDADE            PRECO                TOTAL    % ITEM             ACUMULADO   %ACUMULADO CLASSE"
	Else
		Cabec1 := "PRODUTO         DESCRICAO                                       QUANTIDADE            PRECO                TOTAL    % ITEM             ACUMULADO   %ACUMULADO"
	EndIf	
EndIf

nTotal:= 0

SetRegua( RecCount() )

_cQuery:= ""
_cQuery+= "SELECT SUM ( D1_TOTAL + D1_VALIPI + D1_VALFRE + D1_SEGURO + D1_DESPESA + D1_ICMSRET - D1_VALDESC ) AS TOTAL "
_cQuery+= "FROM " + RetSqlName('SD1')  + " SD1, " + RetSqlName('SF4')  + " SF4, " + RetSqlName('SA2')  + " SA2 "
_cQuery+= "WHERE SD1.D1_FILIAL  BETWEEN '" + MV_PAR12         + "' AND '" + MV_PAR13         + "' "
_cQuery+= "AND   SD1.D1_DTDIGIT BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
_cQuery+= "AND   SD1.D1_FORNECE BETWEEN '" + MV_PAR06         + "' AND '" + MV_PAR07         + "' "
_cQuery+= "AND   SD1.D1_COD     BETWEEN '" + MV_PAR08         + "' AND '" + MV_PAR09         + "' "
_cQuery+= "AND   SD1.D1_LOCAL   BETWEEN '" + MV_PAR10         + "' AND '" + MV_PAR11         + "' "
If !Empty( MV_PAR05 )
	_cQuery+= "AND D1_TP IN ('" + StrTran( AllTrim( MV_PAR05 ), ";", "','" ) + "') "
EndIf	
_cQuery+= "AND ( SF4.F4_DUPLIC = 'S' OR A2_EST = 'EX' ) "
_cQuery+= "AND   SD1.D1_TES    = SF4.F4_CODIGO "
_cQuery+= "AND   SD1.D1_FORNECE= SA2.A2_COD "
_cQuery+= "AND   SD1.D1_LOJA   = SA2.A2_LOJA "
_cQuery+= "AND   SD1.D1_TIPO   = 'N' "
_cQuery+= "AND SD1.D_E_L_E_T_ <> '*' "
_cQuery+= "AND SF4.D_E_L_E_T_ <> '*' "
_cQuery+= "AND SA2.D_E_L_E_T_ <> '*' "

If Select('SQL') > 0
	DbCloseArea('SQL')
	DbCloseArea()
EndIf	
           
_cQuery:= ChangeQuery( _cQuery )
TCQUERY _cQuery Alias SQL NEW

nTotal:= TOTAL

_cQuery:= ""
_cQuery+= "SELECT SD1.D1_FILIAL, "
_cQuery+= "SD1.D1_COD, "
_cQuery+= "SD1.D1_LOCAL, "
_cQuery+= "SD1.D1_TP, "
_cQuery+= "SD1.D1_TES, "
_cQuery+= "SD1.D1_QUANT, "
_cQuery+= "SD1.D1_TOTAL, "
_cQuery+= "SD1.D1_VALIPI, "
_cQuery+= "SD1.D1_VALFRE, "
_cQuery+= "SD1.D1_SEGURO, "
_cQuery+= "SD1.D1_DESPESA, "
_cQuery+= "SD1.D1_ICMSRET, "
_cQuery+= "SD1.D1_VALDESC, "
_cQuery+= "SD1.D1_DTDIGIT, "
_cQuery+= "SD1.D1_FORNECE, "
_cQuery+= "SD1.D1_LOJA, "
_cQuery+= "SD1.D1_UM, "
_cQuery+= "SD1.D1_TIPO, "
_cQuery+= "SF4.F4_FILIAL, "
_cQuery+= "SF4.F4_CODIGO, "
_cQuery+= "SF4.F4_DUPLIC, "
_cQuery+= "SA2.A2_FILIAL, "
_cQuery+= "SA2.A2_COD, "
_cQuery+= "SA2.A2_NOME, "
_cQuery+= "SA2.A2_EST, "
_cQuery+= "SB1.B1_COD, "
_cQuery+= "SB1.B1_DESC "
_cQuery+= "FROM " + RetSqlName('SD1')  + " SD1, " + RetSqlName('SF4')  + " SF4, " + RetSqlName('SA2')  + " SA2, "  + RetSqlName('SB1')  + " SB1 "
_cQuery+= "WHERE SD1.D1_FILIAL  BETWEEN '" + MV_PAR12         + "' AND '" + MV_PAR13         + "' "
_cQuery+= "AND   SD1.D1_DTDIGIT BETWEEN '" + DtoS( MV_PAR01 ) + "' AND '" + DtoS( MV_PAR02 ) + "' "
_cQuery+= "AND   SD1.D1_FORNECE BETWEEN '" + MV_PAR06         + "' AND '" + MV_PAR07         + "' "
_cQuery+= "AND   SD1.D1_COD     BETWEEN '" + MV_PAR08         + "' AND '" + MV_PAR09         + "' "
_cQuery+= "AND   SD1.D1_LOCAL   BETWEEN '" + MV_PAR10         + "' AND '" + MV_PAR11         + "' "
If !Empty( MV_PAR05 )
	_cQuery+= "AND D1_TP IN ('" + StrTran( AllTrim( MV_PAR05 ), ";", "','" ) + "') "
EndIf	
_cQuery+= "AND ( SF4.F4_DUPLIC = 'S' OR A2_EST = 'EX' ) "
_cQuery+= "AND   SD1.D1_TES    = SF4.F4_CODIGO "
_cQuery+= "AND   SD1.D1_FORNECE= SA2.A2_COD "
_cQuery+= "AND   SD1.D1_LOJA   = SA2.A2_LOJA "
_cQuery+= "AND   SD1.D1_TIPO   = 'N' "
_cQuery+= "AND   SD1.D1_COD    = SB1.B1_COD "
_cQuery+= "AND SD1.D_E_L_E_T_ <> '*' "
_cQuery+= "AND SF4.D_E_L_E_T_ <> '*' "
_cQuery+= "AND SA2.D_E_L_E_T_ <> '*' "
_cQuery+= "AND SB1.D_E_L_E_T_ <> '*' "

If Select('SQL') > 0
	DbCloseArea('SQL')
	DbCloseArea()
EndIf	
            
_cQuery:= ChangeQuery( _cQuery )
TCQUERY _cQuery Alias SQL NEW

DbSelectArea('SQL')   
DbGoTop()

While !Eof()

	IncRegua()

	DbSelectArea('TRB')
	DbSetOrder(1)
	
	If !DbSeek( IIF( MV_PAR14 = 1, SQL->D1_FORNECE, SQL->D1_COD ), .f. )
        RecLock( 'TRB', .t. )
	Else
		RecLock( 'TRB', .f. )
	EndIf	
			TRB_COD   := SQL->D1_COD
			TRB_LOCAL := SQL->D1_LOCAL
			TRB_DESC  := SQL->B1_DESC
			TRB_FORNEC:= SQL->D1_FORNECE
			TRB_LOJA  := SQL->D1_LOJA 
			TRB_NOME  := SQL->A2_NOME
			TRB_UM    := SQL->D1_UM
			TRB_QUANT += SQL->D1_QUANT
			TRB_TOTAL += SQL->D1_TOTAL + SQL->D1_VALIPI + SQL->D1_VALFRE + SQL->D1_SEGURO + SQL->D1_DESPESA + SQL->D1_ICMSRET - SQL->D1_VALDESC
			TRB_PRECO := TRB_TOTAL / TRB_QUANT
			TRB_PERC  := ( TRB_TOTAL / nTotal ) * 100
		MsUnLock()

	DbSelectArea('SQL')   
	DbSkip()

EndDo

DbSelectArea('SQL')
DbCloseArea()

DbSelectArea('TRB')
IndRegua( 'TRB', cNomearq, "Descend( StrZero( TRB_TOTAL, 14, 2) )",,,"Selecionando Registros!..." )
DbGoTop()

While !Eof()
	If nLin > 50
		Cabec( AllTrim(Titulo) + cSubTit, cabec1, cabec2, nomeprog, tamanho, nTipo )
		nLin:= 8
	EndIf
	/*/
	FORNECEDOR      NOME                                            QUANTIDADE            PRECO                TOTAL    % ITEM             ACUMULADO   %ACUMULADO CLASSE
	123456789012345 1234567890123456789012345678901234567890    999.999,999.99   999,999,999.99   999,999,999,999.99   999.999   9999,999,999,999.99      999.99     X
	*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789
    0         1         2         3         4         5         6         7         8         9        10        11        12        13         14        15        16
	/*/
	nTOTGER += TRB_TOTAL
	nTOTPER += TRB_PERC
	
	@ ++nLin, 000 PSay IIF( MV_PAR14 = 1, TRB_FORNECE, TRB_COD  )
	@   nLin, 016 PSay IIF( MV_PAR14 = 1, Substr( TRB_NOME, 1, 40 ), Substr( TRB_DESC, 1, 40 ) )
	@   nLin, 060 PSay TRB_QUANT	Picture '@E 999,999,999.99'
	@   nLin, 077 PSay TRB_PRECO	Picture '@E 999,999,999.99'
	@   nLin, 094 PSay TRB_TOTAL	Picture "@E 999,999,999,999.99"
	@   nLin, 115 PSay TRB_PERC		Picture "@E 999.9999"
	@   nLin, 125 PSay nTOTGER		Picture "@E 9999,999,999,999.99"	
	@   nLin, 150 PSay nTOTPER		Picture "@E 999.99"

	If Empty( MV_PAR06 ) .And. Empty( MV_PAR08 )
		If ( nTOTPER <= MV_PAR03 )
			cCLASSE:= 'A'
			++nTotFxA
		ElseIf	( nTOTPER <= MV_PAR03 + MV_PAR04 )
			cCLASSE:= 'B'
			++nTotFxB
		Else                                  
			cCLASSE:= 'C'
			++nTotFxC
		EndIf	
	
		@   nLin, 161 PSay cCLASSE

	EndIf	

    DbSkip()

EndDo

++nLin

If Empty( MV_PAR06 ) .And. Empty( MV_PAR08 )
	@ ++nLin, 000 PSay 'Total de ' + IIF( MV_PAR14 = 1, 'fornecedores', 'produtos' ) + ' na classe A: '
	@   nLin, 035 PSay nTotFxA	Picture '999,999'
	@ ++nLin, 000 PSay 'Total de ' + IIF( MV_PAR14 = 1, 'fornecedores', 'produtos' ) + ' na classe B: '
	@   nLin, 035 PSay nTotFxB	Picture '999,999'
	@ ++nLin, 000 PSay 'Total de ' + IIF( MV_PAR14 = 1, 'fornecedores', 'produtos' ) + ' na classe C: '
	@   nLin, 035 PSay nTotFxC	Picture '999,999'
EndIf

If nLin <> 80
	Roda( cbcont, cBTxt )
EndIf	

DbSelectArea('TRB')
DbCloseArea()

If aReturn[5]==1
   dbCommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ValPergunte  บAutor  ณMicrosiga       บ Data ณ  03/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ   Valida pergunta SX1                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ValPergunte( _cPerg )

Local I:= 0
Local J:= 0

DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
AAdd( aRegs, { _cPerg, "01", "Data de           ? ", "", "", "MV_CH1", "D",  8, 0, 0, "G", "", "MV_PAR01", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AAdd( aRegs, { _cPerg, "02", "Data ate          ? ", "", "", "MV_CH2", "D",  8, 0, 0, "G", "", "MV_PAR02", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "03", "Percentual A      ? ", "", "", "MV_CH3", "N",  5, 2, 0, "G", "", "MV_PAR03", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "04", "Percentual B      ? ", "", "", "MV_CH4", "N",  5, 2, 0, "G", "", "MV_PAR04", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "05", "Tipo de Produto   ? ", "", "", "MV_CH5", "C", 20, 0, 0, "G", "", "MV_PAR05", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "06", "Do  Fornecedor    ? ", "", "", "MV_CH6", "C",  8, 0, 0, "G", "", "MV_PAR06", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2", "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "07", "Ate Fornecedor    ? ", "", "", "MV_CH7", "C",  8, 0, 0, "G", "", "MV_PAR07", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2", "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "08", "Do  Produto       ? ", "", "", "MV_CH8", "C", 15, 0, 0, "G", "", "MV_PAR08", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "09", "Ate Produto       ? ", "", "", "MV_CH9", "C", 15, 0, 0, "G", "", "MV_PAR09", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1", "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "10", "Do  Local         ? ", "", "", "MV_CHA", "C",  2, 0, 0, "G", "", "MV_PAR10", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "11", "Ate Local         ? ", "", "", "MV_CHB", "C",  2, 0, 0, "G", "", "MV_PAR11", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "12", "Da  Filial        ? ", "", "", "MV_CHC", "C",  2, 0, 0, "G", "", "MV_PAR12", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "13", "Ate Filial        ? ", "", "", "MV_CHD", "C",  2, 0, 0, "G", "", "MV_PAR13", ""              , "", "", "", "", ""           , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )
AADD( aRegs, { _cPerg, "14", "Tipo do Relatorio ? ", "", "", "MV_CHE", "N",  1, 0, 0, "C", "", "MV_PAR14", "Por Fornecedor", "", "", "", "", "Por Produto", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""   , "", "", "", "", "" } )

For I:= 1 To Len( aRegs )
	If !DbSeek( _cPerg + aRegs[ I, 2 ] )
		RecLock( "SX1", .t. )
		For J:=1 To Max( FCount(), Len( aRegs[ I ] ) )
			FieldPut(J, aRegs[ I,J ] )
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return
