#INCLUDE 'rwmake.ch'
#INCLUDE 'Topconn.ch'
/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё PCPG002  ╨ Autor Ё SSERVICES          ╨ Data Ё  26/06/10   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Programa para gerar o consumo medio em determinado periodo.╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6 IDE                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function PCPG002()
********************
Private dPerIni := dDataBase - Day( dDatabase ) + 1
Private dPerFim := dDataBase
Private cItemDe := CriaVar( 'B1_COD' , .f., 'L' )
Private cItemAte:= CriaVar( 'B1_COD' , .f., 'L' )
Private cTipo   := CriaVar( 'B1_TIPO', .f., 'L' )

cItemAte:= Replicate( 'Z', Len( cItemAte ) )

@ 000, 000 To 240, 300 Dialog oDlg Title 'Consumo mИdio no periodo.'
@ 005, 005 To 118, 148

@ 010, 010 Say 'Periodo Inicial  : '
@ 020, 010 Say 'Periodo Final    : '
@ 030, 010 Say 'Do item          : '
@ 040, 010 Say 'Ate item         : '
@ 050, 010 Say 'Tipo item        : '

@ 010, 080 Get dPerIni   Size 040,015
@ 020, 080 Get dPerFim   Size 040,015
@ 030, 080 Get cItemDe   Size 040,015 Picture 'XXXXXXXXXXXXXXX' F3 'SB1'
@ 040, 080 Get cItemAte  Size 040,015 Picture 'XXXXXXXXXXXXXXX' F3 'SB1'
@ 050, 080 Get cTipo     Size 040,015 Picture '@S(30)'

@ 100, 040 BUTTON 'Executa'  SIZE 030, 010 ACTION Processa( { |lEnd| Rotina() } )
@ 100, 080 BUTTON 'Abandona' SIZE 030, 010 ACTION Close( oDlg )

ACTIVATE DIALOG oDlg CENTERED

Return

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё Rotina   ╨ Autor Ё SSERVICES          ╨ Data Ё  26/06/10   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё   Calculo do consumo mИdio                                 ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё AP6 IDE                                                    ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
Static Function Rotina()
*********************
Local cAliasSD1 := 'SD1', cAliasSD2 := 'SD2', cAliasSD3 := 'SD3'
Local cCod := '', cDesc := '', cAnoMes := '', nTotCod := 0, nCons := 0
Local lMT290SD1 := ExistBlock('MT290SD1')
Local lA290CSD2 := ExistBlock('A290CSD2')
Local lMT290SD3 := ExistBlock('MT290SD3')
Local lM290QSD1 := ExistBlock('M290QSD1')
Local lM290QSD2 := ExistBlock('M290QSD2')
Local lM290QSD3 := ExistBlock('M290QSD3')
Local lM290QSB1 := ExistBlock('M290QSB1')
Local l290Cons  := IIf( ExistBlock('A290CONS'), .t., .f. )
Local lRetPE	 := .f., lConsumo  := .f.
Local cOpcoes	 := '', cQuery := '', cQueryUsr := ''
Local aCampos	 := {}, cNomeArq := {}
Local aFixo		 := {}, aPeriodos := {}
Local nPClaA := 80, nClasseA  := 0, nTotalA := 0
Local nPClaB := 15, nClasseA  := 0, nTotalB := 0
Local nPClaC := 05, nClasseC  := 0, nTotalC := 0

dAux := dPerIni
While (dAux <= dPerFim)
	If (aScan(aPeriodos,Substr(dtos(dAux),1,6)) == 0)
		aadd(aPeriodos,Substr(dtos(dAux),1,6))
	Endif
	dAux := LastDay(dAux)+1
Enddo
If (Len(aPeriodos) == 0)
	MsgInfo("> Periodo invalido!","ATENCAO")
	Return
Endif

AADD( aCampos, { 'CODIGO'  ,'C', 15, 0 } )
AADD( aCampos, { 'DESC'    ,'C', 40, 0 } )
For nx := 1 to Len(aPeriodos)
	AADD(aCampos,{'CONS'+aPeriodos[nx],"N",18,2})
	AADD(aCampos,{'CUST'+aPeriodos[nx],"N",18,2})
Next nx
AADD(aCampos,{'MEDCONS'  ,"N",18,2})
AADD(aCampos,{'MEDCUST'  ,"N",18,2})
AADD(aCampos,{'MORDEM'   ,"C",10,0})
AADD(aCampos,{'MRACKING' ,"C",01,0})
If (Select("TMP") <> 0)
	dbSelectArea("TMP")
	dbCloseArea()
Endif
cNomeArq := CriaTrab( aCampos )
DbUseArea( .t.,, cNomeArq, 'TMP', .f., .f. )
IndRegua( 'TMP', cNomeArq, 'CODIGO',,, '' )

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё            Processa o arquivo SD2 -> Itens das notas fiscais de saМda             Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
cAliasSD2:= GetNextAlias()

cQuery:= "SELECT D2_FILIAL, D2_COD, D2_LOCAL, D2_QUANT, D2_EMISSAO, D2_REMITO, D2_TES, D2_TIPO, D2_ORIGLAN, SD2.R_E_C_N_O_ RECNOSD2, SB1.B1_DESC "
cQuery+= "FROM " + RetSqlName("SD2") + " SD2 "
cQuery+= "JOIN " + RetSqlName("SB1") + " SB1  ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery+=                                     "AND B1_COD = D2_COD "
cQuery+=                                     "AND SB1.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SD2.D2_FILIAL = '" + xFilial("SD2") + "' "
cQuery+= "AND D2_COD BETWEEN '" + cItemDe + "' AND '" + cItemAte + "' "
cQuery+= "AND D2_EMISSAO >= '" + DTOS( dPerIni ) + "' "
cQuery+= "AND D2_EMISSAO <= '" + DTOS( dPerFim ) + "' "
cQuery+= "AND D2_ORIGLAN <> 'LF' AND D2_TIPO NOT IN ('D','B') "
cQuery+= "AND D2_REMITO = '" + CriaVar( "D2_REMITO" , .f. ) + "' "
cQuery+= "AND SD2.D_E_L_E_T_ = ' ' "
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё             M290QSD2 - Ponto de Entrada para adicionar filtro na query do SD2     |
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
If lM290QSD2
	cQueryUsr:= ExecBlock( "M290QSD2", .f., .f. )
	If ValType( cQueryUsr ) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

If !Empty( cTipo )
	cOpcoes:= AllTrim( cTipo )
	cOpcoes:= Substr( cTipo, 1, Len( cTipo ) - 1 )
	cQuery += "AND SB1.B1_TIPO IN ('" + StrTran( cOpcoes, ";", "','") + "') "
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lM290QSB1
	cQueryUsr:= ExecBlock( "M290QSB1", .f., .f. )
	If ValType( cQueryUsr ) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

cQuery+= " ORDER BY " + SqlOrder( SD2->( IndexKey() ) )

cQuery:= ChangeQuery( cQuery )

DbUseArea( .t., 'TOPCONN', TcGenQry( ,, cQuery ), cAliasSD2, .t., .t. )

TcSetField( cAliasSD2, "D2_QUANT"   , "N", TamSx3( "D2_QUANT"   ) [1], TamSx3( "D2_QUANT"  ) [2] )
TcSetField( cAliasSD2, "D2_EMISSAO" , "D", TamSx3( "D2_EMISSAO" ) [1], TamSx3( "D2_EMISSAO") [2] )

DbSelectArea( cAliasSD2 )
DbGoTop()

ProcRegua( LastRec() )

DbSelectArea( cAliasSD2 )
While !Eof()
	cCod	:= (cAliasSD2)->D2_COD
	cDesc	:= (cAliasSD2)->B1_DESC
	aVlPer:= Array(Len(aPeriodos))
	aCtPer:= Array(Len(aPeriodos))
	aFill(aVlPer,0) ; aFill(aCtPer,0)
	nTotCod := 0
	lConsumo:= .f.
	
	DbSelectArea( cAliasSD2 )
	While !Eof() .And. (cAliasSD2)->D2_COD == cCod
		
		IncProc()
		
		lConsumo:= .t.
		
		DbSelectArea("SF4")
		DbSeek( xFilial("SF4") + (cAliasSD2)->D2_TES )
		
		DbSelectArea( cAliasSD2 )
		
		If SF4->F4_ESTOQUE == "S"
			//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё A290CSD2 - Ponto de Entrada para filtrar a tabela SD2 (ANTIGO) Ё
			//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
			If lA290CSD2
				DbSelectArea("SD2")
				DbGoto(( cAliasSD2)->RECNOSD2 )
				
				If ValType( lRetPE:= ExecBlock( "A290CSD2", .f., .f., {"SD2"} ) ) == "L" .And. !lRetPE
					DbSelectArea( cAliasSD2 )
					DbSkip()
					Loop
				EndIf
				
				DbSelectArea( cAliasSD2 )
			EndIf
			        
			nCusto:= CustoB9((cAliasSD2)->D2_cod,(cAliasSD2)->D2_local,(cAliasSD2)->D2_emissao)
			nPos1 := aScan(aPeriodos,Substr(dtos((cAliasSD2)->D2_emissao),1,6))
			If (nPos1 > 0)
				If (cAliasSD2)->D2_TES <= "500"
					aVlPer[nPos1] -= (cAliasSD2)->D2_QUANT
					aCtPer[nPos1] -= (cAliasSD2)->D2_QUANT*nCusto
				Else
					aVlPer[nPos1] += (cAliasSD2)->D2_QUANT
					aCtPer[nPos1] += (cAliasSD2)->D2_QUANT*nCusto
				EndIf
			Endif
		EndIf
		
		DbSelectArea( cAliasSD2 )
		DbSkip()
	EndDo
	
	If lConsumo
		DbSelectArea('TMP')
		If DbSeek( cCod, .f. )
			RecLock( 'TMP', .f. )
		Else
			RecLock( 'TMP', .t. )
		EndIf
		CODIGO:= cCod
		DESC  := cDesc
		For nx := 1 to Len(aPeriodos)
			&("CONS"+aPeriodos[nx]) += aVlPer[nx]
			&("CUST"+aPeriodos[nx]) += aCtPer[nx]
		Next nx
		MsUnlock()
	EndIf
	
	DbSelectArea( cAliasSD2 )
	
EndDo

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё            Processa o arquivo SD1 -> Itens das notas fiscais de Dev.Vdas          Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
cAliasSD1:= GetNextAlias()

cQuery:= "SELECT D1_FILIAL, D1_COD, D1_LOCAL, D1_ORIGLAN, D1_TIPO, D1_REMITO, D1_DTDIGIT, D1_TES, D1_QUANT, SD1.R_E_C_N_O_ RECNOSD1, SB1.B1_DESC "
cQuery+= "FROM " + RetSqlName("SD1") + " SD1 "
cQuery+= "JOIN " + RetSqlName("SB1") + " SB1 ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery+=                                    "AND B1_COD = D1_COD "
cQuery+=                                    "AND SB1.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SD1.D1_FILIAL = '" + xFilial("SD1") +  "' "
cQuery+= "AND D1_COD BETWEEN '" + cItemDe + "' AND '" + cItemAte + "' "
cQuery+= "AND D1_DTDIGIT >= '" + DTOS( dPerIni ) + "' AND D1_DTDIGIT <= '" + DTOS( dPerFim ) + "' "
cQuery+= "AND D1_ORIGLAN <> 'LF' AND D1_TIPO = 'D' "
cQuery+= "AND D1_REMITO   = '" + CriaVar( "D1_REMITO", .f. ) + "' "
cQuery+= "AND SD1.D_E_L_E_T_ = ' ' "

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё          M290QSD1 - Ponto de Entrada para adicionar filtro na query do SD1        |
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
If lM290QSD1
	cQueryUsr:= ExecBlock( "M290QSD1", .f., .f. )
	If ValType( cQueryUsr ) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

If !Empty( cTipo )
	cOpcoes:= AllTrim( cTipo )
	cOpcoes:= Substr( cTipo, 1, Len( cTipo ) - 1 )
	cQuery += "AND SB1.B1_TIPO IN ('" + StrTran( cOpcoes, ";", "','") + "') "
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lM290QSB1
	cQueryUsr:= ExecBlock( "M290QSB1", .f., .f. )
	If ValType( cQueryUsr ) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

cQuery+= " ORDER BY " + SqlOrder( SD1->( IndexKey() ) )
cQuery:= ChangeQuery( cQuery )

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), cAliasSD1, .t., .t. )

TcSetField( cAliasSD1, "D1_QUANT"   , "N", TamSx3( "D1_QUANT"  ) [1], TamSx3( "D1_QUANT"  ) [2] )
TcSetField( cAliasSD1, "D1_DTDIGIT" , "D", TamSx3( "D1_DTDIGIT") [1], TamSx3( "D1_DTDIGIT") [2] )

DbSelectArea( cAliasSD1 )
DbGoTop()

ProcRegua( LastRec() )

While !Eof()
	cCod	:= (cAliasSD1)->D1_COD
	cDesc	:= (cAliasSD1)->B1_DESC
	aVlPer:= Array(Len(aPeriodos))
	aCtPer:= Array(Len(aPeriodos))
	aFill(aVlPer,0) ; aFill(aCtPer,0)
	nTotCod	:= 0
	lConsumo:= .f.
	
	While !Eof() .And. (cAliasSD1)->D1_COD == cCod
		lConsumo:= .t.
		
		IncProc()
		
		DbSelectArea("SF4")
		
		DbSeek( xFilial("SF4") + (cAliasSD1)->D1_TES )
		DbSelectArea( cAliasSD1 )
		
		If SF4->F4_ESTOQUE == "S"
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё     MT290SD1 - Ponto de Entrada para adicionar filtro na query do SD1 (ANTIGO)    |
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			If lMt290SD1
				DbSelectArea("SD1")
				DbGoto((cAliasSD1)->RECNOSD1)
				
				If ValType( lRetPE:= ExecBlock("MT290SD1", .f., .f.) ) == "L" .And. !lRetPE
					DbSelectArea( cAliasSD1 )
					dbSkip()
					Loop
				EndIf
				
				DbSelectArea( cAliasSD1 )
			EndIf
			
			nCusto:= CustoB9((cAliasSD1)->D1_cod,(cAliasSD1)->D1_local,(cAliasSD1)->D1_dtdigit)
			nPos1 := aScan(aPeriodos,Substr(dtos((cAliasSD1)->D1_dtdigit),1,6))
			If (nPos1 > 0)
				If (cAliasSD1)->D1_TES <= "500"
					aVlPer[nPos1] -= (cAliasSD1)->D1_QUANT
					aCtPer[nPos1] -= (cAliasSD1)->D1_QUANT*nCusto
				Else
					aVlPer[nPos1] += (cAliasSD1)->D1_QUANT
					aCtPer[nPos1] += (cAliasSD1)->D1_QUANT*nCusto
				EndIf
			Endif
			
		EndIf
		
		DbSkip()
		
	EndDo
	
	If lConsumo
		DbSelectArea('TMP')
		
		If DbSeek( cCod, .f. )
			RecLock( 'TMP', .f. )
		Else
			RecLock( 'TMP', .t. )
		EndIf
		CODIGO:= cCod
		DESC  := cDesc
		For nx := 1 to Len(aPeriodos)
			&("CONS"+aPeriodos[nx]) += aVlPer[nx]
			&("CUST"+aPeriodos[nx]) += aCtPer[nx]
		Next nx
		MsUnlock()
	EndIf
	
	DbSelectArea( cAliasSD1 )
	
EndDo

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё                 Processa o arquivo SD3 -> Movimentacoes Internas                  Ё
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
cAliasSD3:= GetNextAlias()

cQuery:= "SELECT D3_FILIAL, D3_COD, D3_LOCAL, D3_TM, D3_CF, D3_EMISSAO, D3_QUANT, SD3.R_E_C_N_O_ RECNOSD3, SB1.B1_DESC "
cQuery+= "FROM " + RetSqlName("SD3") + " SD3 "
cQuery+= "JOIN " + RetSqlName("SB1") + " SB1 ON  B1_FILIAL = '" + xFilial("SB1") + "' "
cQuery+=                                    "AND B1_COD  = D3_COD "
cQuery+=                                    "AND SB1.D_E_L_E_T_ = ' ' "
cQuery+= "WHERE SD3.D3_FILIAL = '" + xFilial("SD3") + "' "
cQuery+= "AND D3_COD BETWEEN '" + cItemDe + "' AND '" + cItemAte + "' "
cQuery+= "AND D3_EMISSAO >= '" + DTOS( dPerIni ) + "' AND D3_EMISSAO <= '" + DTOS( dPerFim )	+ "' "
cQuery+= "AND D3_CF      <> 'DE8' AND  D3_CF  <>  'RE8' "
cQuery+= "AND D3_DOC     <> 'INVENT' "
cQuery+= "AND SD3.D_E_L_E_T_ = ' ' "

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё         MT290SD3 - Ponto de Entrada para adicionar filtro na query do SD3         |
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
If lM290QSD3
	cQueryUsr:= ExecBlock( "M290QSD3", .f., .f. )
	If ValType( cQueryUsr ) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

If !Empty( cTipo )
	cOpcoes:= AllTrim( cTipo )
	cOpcoes:= Substr( cTipo, 1, Len( cTipo ) - 1 )
	cQuery += "AND SB1.B1_TIPO IN ('" + StrTran( cOpcoes, ";", "','") + "') "
EndIf

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё M290QSB1 - Ponto de Entrada utilizado para adicionar filtro na query (ref. SB1)   |
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If lM290QSB1
	cQueryUsr:= ExecBlock( "M290QSB1", .f., .f. )
	If ValType(cQueryUsr) == "C"
		cQuery+= cQueryUsr
	EndIf
EndIf

cQuery+= " ORDER BY " + SqlOrder( SD3->( IndexKey() ) )
cQuery:= ChangeQuery(cQuery)

DbUseArea( .t., "TOPCONN", TcGenQry(,,cQuery), cAliasSD3, .t., .t.)

TcSetField( cAliasSD3, "D3_QUANT"   , "N", TamSx3( "D3_QUANT"  ) [1], TamSx3("D3_QUANT"  ) [2] )
TcSetField( cAliasSD3, "D3_EMISSAO" , "D", TamSx3( "D3_EMISSAO") [1], TamSx3("D3_EMISSAO") [2] )

DbSelectArea(cAliasSD3)
DbGoTop()

ProcRegua( LastRec() )

While !Eof()
	cCod    := (cAliasSD3)->D3_COD
	cDesc	:= (cAliasSD3)->B1_DESC
	aVlPer:= Array(Len(aPeriodos))
	aCtPer:= Array(Len(aPeriodos))
	aFill(aVlPer,0) ; aFill(aCtPer,0)
	nTotCod := 0
	lConsumo:= .f.
	
	While !Eof() .And. (cAliasSD3)->D3_COD == cCod
		
		If Subs( (cAliasSD3)->D3_CF, 2, 1 ) == "E" .And. !Substr( (cAliasSD3)->D3_CF, 3, 1 ) $ "3478"
			
			lConsumo := .t.
			IncProc()
			
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			//Ё        MT290SD3 - Ponto de Entrada para adicionar filtro no SD3 (ANTIGO)          |
			//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
			If lMt290SD3
				DbSelectArea("SD3")
				DbGoto( (cAliasSD3)->RECNOSD3 )
				
				If ValType( lRetPE:= ExecBlock("MT290SD3", .f., .f.) ) == "L" .And. !lRetPE
					DbSelectArea( cAliasSD3 )
					DbSkip()
					Loop
				EndIf
				DbSelectArea( cAliasSD3 )
			EndIf
			
			nCusto:= CustoB9((cAliasSD3)->D3_cod,(cAliasSD3)->D3_local,(cAliasSD3)->D3_emissao)
			nPos1 := aScan(aPeriodos,Substr(dtos((cAliasSD3)->D3_emissao),1,6))
			If (nPos1 > 0)
				If (cAliasSD3)->D3_TM <= "500"
					aVlPer[nPos1] -= (cAliasSD3)->D3_QUANT
					aCtPer[nPos1] -= (cAliasSD3)->D3_QUANT*nCusto
				Else
					aVlPer[nPos1] += (cAliasSD3)->D3_QUANT
					aCtPer[nPos1] += (cAliasSD3)->D3_QUANT*nCusto
				EndIf
			Endif
			
		EndIf
		
		DbSkip()
		
	EndDo
	
	If lConsumo
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		//Ё      A290CONS - Ponto de Entrada utilizado para alterar o consumo calculado       Ё
		//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
		If l290Cons
			nCons:= ExecBlock( "A290CONS", .f., .f., { cCod, nTotCod } )
			If ValType( nCons ) == "N"
				nTotCod:= nCons
			EndIf
		EndIf
		
		DbSelectArea('TMP')
		
		If DbSeek( cCod, .f. )
			RecLock( 'TMP', .f. )
		Else
			RecLock( 'TMP', .t. )
		EndIf
		
		CODIGO:= cCod
		DESC  := cDesc
		For nx := 1 to Len(aPeriodos)
			&("CONS"+aPeriodos[nx]) += aVlPer[nx]
			&("CUST"+aPeriodos[nx]) += aCtPer[nx]
		Next nx
		MsUnlock()
	EndIf
	
	DbSelectArea(cAliasSD3)
	
EndDo

(cAliasSD1)->( DbCloseArea() )
(cAliasSD2)->( DbCloseArea() )
(cAliasSD3)->( DbCloseArea() )

// MBrowse
// Tipo: Processamento
// Monta um browse padrЦo do sistema, conforme os parБmetros.

// Sintaxe
// mBrowse(nLinha1, nColuna1, nLinha2, nColuna2, cAlias, aFixe, cCpo, nPar, cCor, n Opc)

// ParБmetros
// nLinha1  - NЗmero da linha inicial
// nColuna1 - NЗmero da coluna inicial
// nLinha2  - NЗmero da linha final
// nColuna2 - NЗmero da coluna final
// cAlias   - Alias do arquivo
// aFixe    - Array contendo os campos fixos (a serem mostrados em primeiro lugar no browse)
// cCpo     - Campo a ser tratado. Quando vazio, muda a cor da linha
// nPar     - ParБmetro obsoleto
// cCor     - FunГЦo que retorna um valor lСgico, muda a cor da linha
// nOpc     - Define qual opГЦo do aRotina que serА utilizada no double click
/*/

AADD( aFixo, { 'CODIGO'  , 'CODIGO'   } )
AADD( aFixo, { 'DESC'    , 'DESC'     } )
AADD( aFixo, { 'CONSUMO1', 'CONSUMO1' } )
AADD( aFixo, { 'CONSUMO2', 'CONSUMO2' } )

DbSelectArea('TMP')

mBrowse( 000, 000, 200, 200, 'TMP', aFixo,,,,,)
/*/

//Calcula Media de Consumo e Custo
//////////////////////////////////
nTotal := 0
DbSelectArea("TMP")
TMP->(DbGoTop())
While !TMP->(Eof())
	aTotal := {0,0,0,0}
	For nx := 1 to Len(aPeriodos)
		uValor := &("CONS"+aPeriodos[nx])
		If (uValor != 0)
			aTotal[1]++ ; 	aTotal[2] += uValor
		Endif
		uValor := &("CUST"+aPeriodos[nx])
		If (uValor != 0)
			aTotal[3]++ ; 	aTotal[4] += uValor
		Endif
	Next nx	
	Reclock("TMP",.F.)
	If (aTotal[1] > 0)
		MEDCONS := aTotal[2]/aTotal[1]
	Endif
	If (aTotal[3] > 0)
		MEDCUST := aTotal[4]/aTotal[3]
	Endif
	If (MEDCUST > 0)
		MORDEM := Strzero(0009999999-INT(MEDCUST),10)
	Else
		MORDEM := Replicate("9",10)
	Endif
	MsUnlock("TMP")
	nTotal += TMP->(MEDCUST)
	TMP->(dbSkip())
Enddo

//Montagem da Curva ABC
///////////////////////
nClasseA := nTotal*(nPClaA/100)
nClasseB := nTotal*(nPClaB/100)
nClasseC := nTotal*(nPClaC/100)
nTotalA := 0 ; nTotalB := 0 ; nTotalC := 0
DbSelectArea("TMP")
cIndex := CriaTrab(NIL,.F.)
IndRegua("TMP",cIndex,"MORDEM",,,"Indexando Arquivo Trabalho...")
TMP->(DbGoTop())
While !TMP->(Eof())
	If (nTotalA == 0).or.(nClasseA >= nTotalA)
		nTotalA += TMP->MEDCUST ; cRank := "A"
	Elseif (nTotalB == 0).or.(nClasseB >= nTotalB)
		nTotalB += TMP->MEDCUST ; cRank := "B"
	Else
		nTotalC += TMP->MEDCUST ; cRank := "C"
	Endif
	Reclock("TMP",.F.)
	MRACKING := cRank
	MsUnlock("TMP")
	TMP->(dbSkip())
Enddo

//Geracao do Excel
//////////////////
dbSelectArea("TMP")
TMP->(dbGoTop())
U_ProcExcel("TMP")

Return Nil

Static Function CustoB9(xProduto,xLocal,xData)
******************************************
LOCAL nRetu := 0, dUFech := ctod("01/"+Substr(dtoc(xData),4))-1
SB9->(dbSetOrder(1))
If SB9->(dbSeek(xFilial("SB9")+xProduto+xLocal+dtos(dUFech)))
	nRetu := SB9->B9_cm1
	If (nRetu == 0)
		SB9->(dbSkip(-1))
		While !SB9->(Eof()).and.(xFilial("SB9") == SB9->B9_filial).and.(SB9->B9_cod+SB9->B9_local == xProduto+xLocal)
			nRetu := SB9->B9_cm1
			If (nRetu > 0)
				Exit
			Endif
			SB9->(dbSkip(-1))
		Enddo
	Endif	
Endif
If (nRetu == 0)
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1")+xProduto+xLocal))
		nRetu := SB1->B1_custd
	Endif	
Endif
Return nRetu