#Include "Protheus.ch"

// ##############################################################################
// Projeto  : DVS
// Autor    : Robson Coral
// Modulo   : Financeiro
// Função   : DFINR01A
// Descrição: Gera Excel Relatorio Posição de Risco de Clientes
// Retorno  : Nenhum
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------
// 14/08/14 | Robson Coral      | Desenvolvimento da rotina.
// ---------+-------------------+------------------------------------------------
User Function DFINR01()

Private cCadastro := "Posição risco de clientes"
Private cPerg     := 'DFINR01A'

AjustaSX1()

If Pergunte( cPerg,.T.)
	Processa( {|| GerarArq() }, cCadastro, "Gerando relatório de posição de risco de clientes...", .F. )
EndIf

Return


// ##############################################################################
// Projeto  : DVS
// Autor    : Robson Coral
// Modulo   : Financeiro
// Função   : AjustaSX1
// Descrição: Montagem das perguntas
// Retorno  : Nenhum
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------
// 14/08/14 | Robson Coral      | Desenvolvimento da rotina.
// ---------+-------------------+------------------------------------------------
Static Function AjustaSX1()

Local aRegs   := {}
Local i,j,x

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)

aAdd(aRegs,{cPerg,"01","Abrir Excel no final           ?","","","MV_CH1","N",01,0,0,"C","","MV_PAR01","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate a data                     ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Número de meses                ?","","","mv_ch3","N",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Média atraso máx.bons pagadores?","","","mv_ch4","N",02,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Somente a filial logada        ?","","","mv_ch5","N",01,0,0,"C","","mv_par05","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	Else
		For x:=1 to len(aRegs[i])
			If x<=fcount() .and. aRegs[i,x]<>&(fieldname(x))
				If !(alltrim(str(x))$'10;17;22;27;32;37')
					RecLock("SX1",.f.)
					FieldPut(x,aRegs[i,x])
					MsUnLock()
				EndIf
			EndIf
		Next
	EndIf
Next
i:=len(aRegs)+1
While dbSeek(cPerg+strzero(i,2))
	RecLock("SX1",.f.)
	DbDelete()
	MsUnLock()
	i++
End

Return


// ##############################################################################
// Projeto  : DVS
// Autor    : Robson Coral
// Modulo   : Financeiro
// Função   : GerarArq
// Descrição: Gera relatorio
// Retorno  : Nenhum
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------
// 14/08/14 | Robson Coral      | Desenvolvimento da rotina.
// ---------+-------------------+------------------------------------------------
// 30/09/20 | Paola Stekl       | Ajuste em tratativa de filiais
// ---------+-------------------+------------------------------------------------

Static Function GerarArq( aRet )

Local oFwMsEx    := NIL
Local cArq       := ""
Local cWorkSheet := ""
Local cTable     := ""
Local cDirTmp    := "C:\TEMP"
Local aTotalfat  := 0
Local dDtIni     := MonthSub(MV_PAR02, MV_PAR03)
Local _nMedia 	 := 0
Local _nCount 	 := 0
Local _nPrazo	 := 0
Local cDvsFil    := ''
Local nX         := 0

If !file(cDirTmp)
	Alert("É obrigatório a pasta 'C:\TEMP' para gerar o relatório")
	return
EndIf

If MV_PAR05 == 2
	// Pega filiais da empresa logada
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))  // M0_CODIGO, M0_CODFIL.
	SM0->(msSeek(cEmpAnt, .F.))
	Do While SM0->(!eof() .and. SM0->M0_CODIGO == cEmpAnt)
			cDvsFil += ", '" + Substr(SM0->M0_CODFIL,1,4) + "'"
		SM0->(dbSkip())
	EndDo
	RestArea(aAreaSM0)
	cDvsFil  := SubStr(cDvsFil, 3)
Else
	// Pega somente a filial logada
	cDvsFil := "'" + cFilAnt + "'"
Endif

//Totais
cQuery := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_ULTCOM, SA1.A1_TITPROT, SA1.A1_DTULTIT, SA1.A1_RISCO, SA1.A1_LC, SA1.A1_MSALDO, " + CRLF 
cQuery += "      (SELECT MAX(E1.E1_BAIXA) " + CRLF 
cQuery += "       FROM "+RetSqlName("SE1")+" E1 " + CRLF 
cQuery += "       WHERE E1.E1_FILIAL   IN (" + cDvsFil + ") "+ CRLF
cQuery += "       AND   E1.E1_CLIENTE  = SA1.A1_COD " + CRLF 
cQuery += "       AND   E1.E1_LOJA     = SA1.A1_LOJA " + CRLF 
cQuery += "       AND   E1.E1_EMISSAO  BETWEEN '"+dtos(dDtIni)+"' AND '"+Dtos(MV_PAR02)+"' " + CRLF  // protesto dentro do periodo solicitado
cQuery += "       AND   E1.E1_BAIXA    <> ' ' " + CRLF 
cQuery += "       AND   E1.D_E_L_E_T_  = ' ') AS DATA_PAG, " + CRLF 

// Total faturado 6 meses
cQuery += "      (SELECT SUM(SF2.F2_VALBRUT) " + CRLF 
cQuery += "       FROM "+RetSqlName("SF2")+" SF2 " + CRLF 
cQuery += "       WHERE SF2.F2_FILIAL   IN (" + cDvsFil + ") "+ CRLF
cQuery += "       AND   SF2.F2_CLIENTE  = SA1.A1_COD " + CRLF 
cQuery += "       AND   SF2.F2_LOJA     = SA1.A1_LOJA " + CRLF 
cQuery += "       AND   SF2.F2_EMISSAO  BETWEEN '"+Dtos(dDtIni)+"' AND '"+Dtos(MV_PAR02)+"' " + CRLF 
cQuery += "       AND   SF2.F2_VALFAT   > 0 " + CRLF 
cQuery += "       AND   SF2.D_E_L_E_T_  = ' ') AS TOT_FAT, " + CRLF 

cQuery += "      (SELECT MAX(SF2.R_E_C_N_O_) " + CRLF 
cQuery += "       FROM "+RetSqlName("SF2")+" SF2 " + CRLF 
cQuery += "       WHERE SF2.F2_FILIAL  IN (" + cDvsFil + ") "+ CRLF
cQuery += "       AND   SF2.F2_CLIENTE = SA1.A1_COD " + CRLF 
cQuery += "       AND   SF2.F2_LOJA    = SA1.A1_LOJA " + CRLF 
cQuery += "       AND   SF2.F2_EMISSAO BETWEEN '"+dtos(dDtIni)+"' AND '"+Dtos(MV_PAR02)+"' " + CRLF 
cQuery += "       AND   SF2.F2_VALFAT  > 0 " + CRLF 
cQuery += "       AND   SF2.D_E_L_E_T_ = ' ') AS ULREGFAT, " + CRLF 

// GERAR TOTAL TITULOS BAIXADOS 
cQuery += "      (SELECT SUM(CASE WHEN SE5.E5_TIPODOC='ES' THEN SE5.E5_VALOR*-1 Else SE5.E5_VALOR-SE5.E5_VLJUROS-SE5.E5_VLMULTA-SE5.E5_VLCORRE+SE5.E5_VLDESCO END) " + CRLF 
cQuery += "       FROM "+RetSqlName("SE5")+" SE5 " + CRLF 
cQuery += "       WHERE SE5.E5_FILIAL     IN (" + cDvsFil + ") "+ CRLF
cQuery += "       AND   SE5.E5_CLIFOR     = SA1.A1_COD " + CRLF 
cQuery += "       AND   SE5.E5_LOJA       = SA1.A1_LOJA " + CRLF 
cQuery += "       AND   (( SE5.E5_TIPODOC = 'BA' AND SE5.E5_MOTBX IN ('NOR','FAT')) OR " + CRLF 
cQuery += "              ( SE5.E5_TIPODOC = 'VL' ) OR " + CRLF 
cQuery += "              ( SE5.E5_TIPODOC = 'CP' AND SE5.E5_MOTBX='CMP') ) " + CRLF 
cQuery += "       AND   SE5.D_E_L_E_T_    = ' ') AS TOTBAIXADOS, " + CRLF 

// GERAR TOTAL TITULOS ABERTOS
cQuery += "      (SELECT SUM(SE1.E1_SALDO) " + CRLF 
cQuery += "       FROM "+RetSqlName("SE1")+" SE1 " + CRLF 
cQuery += "       WHERE SE1.E1_FILIAL  IN (" + cDvsFil + ") "+ CRLF
cQuery += "       AND   SE1.E1_CLIENTE = SA1.A1_COD " + CRLF 
cQuery += "       AND   SE1.E1_LOJA    = SA1.A1_LOJA " + CRLF 
cQuery += "       AND   SE1.D_E_L_E_T_ = ' ') AS TOTABERTOS " + CRLF 

cQuery += "FROM "+RetSqlName("SA1")+" SA1 " + CRLF 
cQuery += "WHERE SA1.A1_FILIAL  = '"+xFilial("SA1")+"' " + CRLF 
cQuery += "AND   SA1.A1_ULTCOM  BETWEEN '"+dtos(dDtIni)+"' AND '"+Dtos(MV_PAR02)+"' " + CRLF 
cQuery += "AND   SA1.D_E_L_E_T_ = ' ' " + CRLF 
cQuery += "ORDER BY SA1.A1_COD, SA1.A1_LOJA " + CRLF 

//MemoWrit("c:\temp\DFINR01.sql",cQuery)

If Select( "TRB1" ) > 0; dbSelectArea( "TRB1" ); dbCloseArea(); EndIf

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB1", .F., .T.)

TcSetField("TRB1","A1_ULTCOM",  "D", 8,0)
TcSetField("TRB1","A1_DTULTIT", "D", 8,0)
TcSetField("TRB1","DATA_PAG",   "D", 8,0)
TcSetField("TRB1","TOT_FAT",    "N",12,2)
TcSetField("TRB1","TOTBAIXADOS","N",12,2)
TcSetField("TRB1","TOTABERTOS", "N",12,2)
TcSetField("TRB1","A1_LC",      "N",12,2)
TcSetField("TRB1","A1_TITPROT", "N", 3,0)
TcSetField("TRB1","A1_MSALDO",  "N",12,2)

cTable     := "Posição risco de clientes até "+Dtoc(MV_PAR02)+". Contemplando os períodos de "+dToc(dDtIni)+" a "+dToc(MV_PAR02)
oFwMsEx    := FWMsExcel():New()

//Cria duas planilhas
For nX := 1 to 2
	If(nX == 1)
		cWorkSheet := "Clientes bons pagadores"
	Else
		cWorkSheet := "Clientes média de atraso alta"
	EndIf

	oFwMsEx:AddWorkSheet( cWorkSheet)
	oFwMsEx:AddTable( cWorkSheet, cTable )

	//Tamanho da fonte do cabeçalho
	oFwMsEx:SetHeaderSizeFont(10)

	oFwMsEx:AddColumn( cWorkSheet, cTable, "Codigo/Loja",          1, 1) // A1_COD + "-" + A1_LOJA
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Cliente",              1, 1) // A1_NOME
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Risco",                1, 1) // A1_RISCO
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Lim.Credito",          3, 2) // A1_LC
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Novo Risco",           1, 2) // vazio
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Novo Limite",          1, 2) // ((TRB1->TOT_FAT/MV_PAR03)*_nPrazo)
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Ult.compra",           1, 1) // A1_ULTCOM
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Qtd.protesto",         3, 2) // A1_TITPROT
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Data ult.protesto",    1, 1) // A1_DTULTIT
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Total baixado",        3, 3) // Total titulos baixados
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Total aberto",         3, 3) // Total titulos em aberto
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Maior atraso",         3, 2) // nDias
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Qtd.tit.atraso",       3, 2) // nDias
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Dias atraso",          3, 2) // nDias
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Data vencimento",      1, 1) // E1_VENCORI
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Data pagamento",       1, 1) // DATA_PAG
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Média prazo ponderada",3, 2) // _nPrazo
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Condição pagamento",   1, 1) // F2_COND + " - " + E4_DESCRI
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Faturados no período", 3, 2) // TOT_FAT
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Média fat.no período", 3, 2) // (TOT_FAT / MV_PAR03)
	oFwMsEx:AddColumn( cWorkSheet, cTable, "Maior acumulo",        3, 2) // A1_MSALDO
Next nX

dbSelectArea("TRB1")
ProcRegua(0)
DBGOTOP()
While TRB1->(!Eof())

	IncProc()

	// Posiciono no registro.
	DbSelectArea("SF2")
	DbGoTo(TRB1->ULREGFAT)

	// Posiciono na condição de pagamento.
	DbSelectArea("SE4")
	DbSetOrder(1)  // E4_FILIAL + E4_CODIGO
	DbSeek(xFilial("SE4")+SF2->F2_COND)

	cQuery := "SELECT E1.E1_BAIXA, E1.E1_VENCREA, E1.E1_TIPO FROM "+RetSqlName("SE1")+" E1 " + CRLF 
	cQuery += "WHERE E1.E1_FILIAL  IN (" + cDvsFil + ") "+ CRLF 
	cQuery += "AND   E1.E1_CLIENTE = '"+TRB1->A1_COD+"'  " + CRLF 
	cQuery += "AND   E1.E1_LOJA    = '"+TRB1->A1_LOJA+"' " + CRLF 
	cQuery += "AND  (E1.E1_BAIXA   > E1.E1_VENCREA OR ('"+alltrim(Dtos(Date()))+"' > E1.E1_VENCREA AND E1.E1_BAIXA = ''))  " + CRLF 
	cQuery += "AND   E1.D_E_L_E_T_ = ' ' " + CRLF 

	If Select( "TRB4" ) > 0; dbSelectArea( "TRB4" ); dbCloseArea(); EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB4", .F., .T.)
	TcSetField("TRB4","E1_BAIXA" ,"D", 8,0)
	TcSetField("TRB4","E1_VENCREA" ,"D", 8,0)
	TcSetField("TRB4","E1_TIPO" ,"C", 3,0)
	TRB4->(DBGOTOP())

	_nMedia := 0
	_nCount := 0

	// Efetua o cálculo da média de atraso
	While !TRB4->(Eof())
		If (TRB4->E1_TIPO <> "NCC")
			If(!Empty(TRB4->E1_BAIXA))
				_nMedia += TRB4->E1_BAIXA - TRB4->E1_VENCREA
			Else
				_nMedia += Date() - TRB4->E1_VENCREA
			EndIf
			_nCount += 1
		EndIf
		TRB4->(DBSKIP())
	END

	_nMedia := 	_nMedia/_nCount

	cQuery := "SELECT TOP 1 SE1.E1_VENCORI " + CRLF 
	cQuery += "FROM "+RetSqlName("SE1")+" SE1 " + CRLF 
	cQuery += "WHERE SE1.E1_FILIAL  IN (" + cDvsFil + ") "+ CRLF
	cQuery += "AND   SE1.E1_CLIENTE = '"+TRB1->A1_COD+"' " + CRLF 
	cQuery += "AND   SE1.E1_LOJA    = '"+TRB1->A1_LOJA+"' " + CRLF 
	cQuery += "AND   SE1.E1_BAIXA   = '"+Dtos(TRB1->DATA_PAG)+"' " + CRLF 
	cQuery += "AND   SE1.D_E_L_E_T_ = ' ' " + CRLF 

	If Select( "TRB3" ) > 0; dbSelectArea( "TRB3" ); dbCloseArea(); EndIf

	dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB3", .F., .T.)

	TcSetField("TRB3","E1_VENCORI", "D", 8,0)

	If(!Empty(TRB1->DATA_PAG))
		nDias := TRB1->DATA_PAG-TRB3->E1_VENCORI
	Else
		nDias := Date()-TRB3->E1_VENCORI
	EndIf

	_nPrazo := U_DFINR01A(TRB1->A1_COD, TRB1->A1_LOJA, dDtIni, mv_par02, cDvsFil)

	aParam := {}
	aadd(aParam, TRB1->A1_COD+"-"+TRB1->A1_LOJA)                         // Código + Loja
	aadd(aParam, TRB1->A1_NOME)                                          // Cliente
	aadd(aParam, TRB1->A1_RISCO)                                         // Risco
	aadd(aParam, Transform(TRB1->A1_LC,"@E 999,999,999.99"))             // Lim. Credito
	aadd(aParam, "")                                                     // Novo Risco
	aadd(aParam, Transform(((TRB1->TOT_FAT/MV_PAR03)*_nPrazo),"@E 999,999,999.99"))// Novo limite
	aadd(aParam, IIf(TRB1->A1_ULTCOM==cTod("//"),"",TRB1->A1_ULTCOM))    // Ultima Compra
	aadd(aParam, TRansform(TRB1->A1_TITPROT,"@E 999")  )                 // N.Tit.Protestados
	aadd(aParam, IIf(TRB1->A1_DTULTIT==cTod("//"),"",TRB1->A1_DTULTIT))  // Dta Ultim PROTESTO
	aadd(aParam, Transform(TRB1->TOTBAIXADOS,"@E 999,999,999.99"))       // Total baixados
	aadd(aParam, Transform(TRB1->TOTABERTOS,"@E 999,999,999.99"))        // Total abertos
	aadd(aParam, TRansform(_nMedia,"@E 9999999"))                        // Media de Atraso
	aadd(aParam, TRansform(_nCount,"@E 9999999"))                        // Número de Títulos em Atraso
	aadd(aParam, IIf(nDias < 0,"0",TRansform(nDias,"@E 9999999")))       // Dias = TRB1->DATA_PAG - TRB3->E1_VENCORI
	aadd(aParam, IIf(TRB3->E1_VENCORI==cTod("//"),"",TRB3->E1_VENCORI))  // Dta Venc.Orig.
	aadd(aParam, IIf(TRB1->DATA_PAG==cTod("//"),"",TRB1->DATA_PAG))      // Dta Pagamento
	aadd(aParam, TRansform(_nPrazo,"@E 9999999.99"))                     // Prazo médio pagamento
	aadd(aParam, alltrim(SF2->F2_COND+" - "+SE4->E4_DESCRI))             // Cond.Pagamento
	aadd(aParam, Transform(TRB1->TOT_FAT,"@E 999,999,999.99"))           // Faturado no mês
	aadd(aParam, Transform((TRB1->TOT_FAT/MV_PAR03),"@E 999,999,999.99"))// Média fat
	aadd(aParam, Transform(TRB1->A1_MSALDO,"@E 999,999,999.99"))         // Maior acumulo

	//Arredonda o valor da média
	_nMedia := alltrim(TRansform(_nMedia,"@E 9999999"))

	//Separa em duas planilhas
	If(val(_nMedia) <= mv_par04 .OR. Empty(_nMedia) .OR. val(_nMedia) == 0)
		oFwMsEx:AddRow("Clientes bons pagadores",cTable, aParam)
	Else
		oFwMsEx:AddRow("Clientes média de atraso alta",cTable, aParam)
	EndIf

	aTotalfat := 0
	TRB1->(DBSKIP())
End

oFwMsEx:Activate()

cArq := "EMP"+ cfilant + CriaTrab( NIL, .F. ) + ".xml"

LjMsgRun("Gerando o arquivo relatorio risco de clientes, aguarde...", cCadastro, {|| oFwMsEx:GetXMLFile( cArq ) } )

If __CopyFile( cArq, cDirTmp +"\"+ cArq )
	If MV_PAR01 == 1
		If ApOleClient('MsExcel')
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirTmp +"\"+ cArq )
			oExcelApp:SetVisible(.T.)
		Else
			MsgInfo( "Microsoft Excel não instalado, arquivo " + cArq + " foi salvo na pasta " + cDirTmp )
		EndIf
	Else
		MsgInfo( "Arquivo " + cArq + " gerado com sucesso no diretório " + cDirTmp )
	EndIf
Else
	MsgInfo( "Arquivo não copiado para o diretório dos arquivos temporários do usuário." )
EndIf

Return


// ##############################################################################
// Projeto  : DVS
// Autor    : Robson Coral
// Modulo   : Financeiro
// Função   : DFINR01A
// Descrição: Calcula a média ponderada dos títulos a receber
// Retorno  : Nenhum
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------
// 05/12/15 | Robson Coral      | Desenvolvimento da rotina.
// ---------+-------------------+------------------------------------------------
User Function DFINR01A(cCliente, cLoja, dInicio, dFim, cDvsFil)

Local nTotalTit := 0
Local nPrazos   := {}
Local nTitulos  := {}
Local nPesos    := {}
Local nMedia    := 0
Local nX        := 0
Local cQuery

cQuery := " SELECT E1.E1_EMISSAO, E1.E1_VENCREA, E1.E1_VALOR " + CRLF 
cQuery += " FROM "+RetSqlName("SE1")+" E1 " + CRLF 
cQuery += " WHERE E1.E1_FILIAL  IN (" + cDvsFil + ") "+ CRLF
cQuery += " AND   E1.E1_CLIENTE = '"+cCliente+"' " + CRLF 
cQuery += " AND   E1.E1_LOJA    = '"+cLoja+"' " + CRLF 
cQuery += " AND   E1.E1_TIPO    = 'NF' " + CRLF 
cQuery += " AND   E1.E1_EMISSAO BETWEEN '"+dtos(dInicio)+"' AND '"+Dtos(dFim)+"' " + CRLF  // protesto dentro do periodo solicitado
cQuery += " AND   E1.D_E_L_E_T_ = ' ' " + CRLF 

//MemoWrit("c:\temp\DFINR01A_"+cCliente+cLoja+".sql",cQuery)

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"QSE1", .F., .T.)

dbSelectArea("QSE1")
dbgotop()

// Guarda nos vetores o valor dos titulos e dos prazos
While !QSE1->(Eof())
	aadd(nTitulos, QSE1->E1_VALOR)
	aadd(nPrazos, Stod(QSE1->E1_VENCREA) - Stod(QSE1->E1_EMISSAO))
	nTotalTit += QSE1->E1_VALOR
	QSE1->(DBSKIP())
End

// Calcula os Pesos e guarda no vetor
For nX := 1 to len(nTitulos)
	aadd(nPesos, nTitulos[nX]/nTotalTit)
Next nX

// Calcula a média ponderada
For nX := 1 to len(nPesos)
	nMedia += nPrazos[nX] * nPesos[nX]
Next nX

QSE1->(DBCLOSEAREA())

Return nMedia
