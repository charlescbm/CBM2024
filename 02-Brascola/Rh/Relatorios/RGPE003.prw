#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RGPE003 บ Autor ณ SSERVICES           บ Data ณ  28/01/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Emite relat๓rio de afastamento.                            บฑฑ
ฑฑบ          ณ                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function RGPE003()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local   cArq,cInd
Local   cString     := "SR8"
Local   cDesc1      := " Este programa tem como objetivo imprimir relatorio "
Local   cDesc2      := "de acordo com os parametros informados pelo usuario."
Local   cDesc3      := "Relatorio de Bonificacao"
Local   cPict       := ""
Local   Titulo      := "Relatorio de colaboradores afastados."
Local   nLin        := 80
Local   Cabec1      := "FL C.CUSTO   MATRICULA COLABORADOR                     CID        TIPO DE AFASTAMENTO                                    AFASTADO  RETORNO DURACAO SALDO"
Local   Cabec2      := ""
Local   Imprime     := .T.
Local   aOrd        := {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private Limite      := 132
Private Tamanho     := "G"
Private nomeprog    := "RGPE003"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "RGPE003"
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RGPE003"
Private cResponse   := ""
Private aResponse   := {}

Gera_SX1(cPerg)

Pergunte( cPerg, .f.)

wnrel := SetPrint("", NomeProg, cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .t., aOrd, .t., Tamanho,, .t.)

If nLastKey == 27
	Return
Endif

SetDefault( aReturn, cString )

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport( Cabec1, Cabec2, Titulo, nLin) }, Titulo)

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  03/12/09  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport( Cabec1, Cabec2, Titulo, nLin)

Local _cQuery := ''
Local _cDescr := Space(40)
Local _cSitFol:= ''
Local _I	  := 0

//-- Modifica variaveis para a Query 
For _I:= 1 to Len( MV_PAR07 )
	_cSitFol+= "'" + Subs(MV_PAR07, _I, 1 ) + "'"
	If ( _I+1 ) <= Len( MV_PAR07 )
		_cSitFol+= ',' 
	Endif
Next

_cQuery += "SELECT R8_FILIAL, "
_cQuery += "       R8_MAT, "
_cQuery += "       R8_DATA, "
_cQuery += "       R8_TIPO, "
_cQuery += "       R8_DATAINI, "
_cQuery += "       R8_DATAFIM, "
_cQuery += "       R8_TIPOAFA, "
_cQuery += "       R8_DPAGAR, "
_cQuery += "       R8_DURACAO, "
_cQuery += "       R8_CID, "
_cQuery += "       RA_FILIAL, "
_cQuery += "       RA_MAT, "
_cQuery += "       RA_NOME, "
_cQuery += "       RA_CC, "
_cQuery += "       RA_SITFOLH "
_cQuery += "FROM " + RetSqlName('SR8') + ' SR8 '
_cQuery+= "INNER JOIN " + RetSQLName('SRA') + " SRA ON RA_FILIAL = R8_FILIAL AND R8_MAT = RA_MAT "
_cQuery+=                 "AND RA_CC BETWEEN '" + AllTrim(MV_PAR05) + "' AND '" + AllTrim(MV_PAR06) + "' AND SRA.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SR8.D_E_L_E_T_ = ' ' "
_cQuery += "AND R8_DATAINI BETWEEN '" + DTOS(MV_PAR01)    + "' AND '" + DTOS(MV_PAR02)    + "' "
_cQuery += "AND R8_FILIAL  BETWEEN '" + AllTrim(MV_PAR03) + "' AND '" + AllTrim(MV_PAR04) + "' "
If MV_PAR07 <> ' '
	_cQuery += "AND R8_TIPO IN (" + _cSitFol +  " ) "
EndIf
_cQuery += "ORDER BY R8_FILIAL, RA_CC, R8_MAT "

If Select("QRY_SR8") > 0
	DbSelectArea("QRY_SR8")
	DbCloseArea()
EndIf

DbUseArea( .t.,"TOPCONN", TcGenQry(,,_cQuery), "QRY_SR8", .t., .t. )

TcSetField( "QRY_SR8", 'R8_DATAINI', 'D', 8, 0 )
TcSetField( "QRY_SR8", 'R8_DATAFIM', 'D', 8, 0 )

DbSelectArea("QRY_SR8")
DbGoTop()

SetRegua( RecCount() )

While !Eof()
	IncRegua()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Verifica o cancelamento pelo usuario...                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lAbortPrint
		@ nLin,000 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressao do cabecalho do relatorio. . .                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nLin > 55
		Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		nLin := 8
	Endif 

	DbSelectArea('SX5') 
	DbSetOrder(1)
	
	_cDescr:= Space(40)
	
	If DbSeek( xFILIAL('SX5') + '30' + QRY_SR8->R8_TIPO, .f. )
		_cDescr:= X5_DESCRI
	EndIf	

    //FL C.CUSTO   MATRICULA COLABORADOR                     CID        TIPO DE AFASTAMENTO                                    AFASTADO  RETORNO DURACAO SALDO
    //0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5
    //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
    //99 XXXXXXXXX XXXXXX    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXX 99 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99/99/99 99/99/99     999   999

	@ ++nLin, 000 PSay QRY_SR8->R8_FILIAL
	@   nLin, 003 PSay QRY_SR8->RA_CC
	@   nLin, 013 PSay QRY_SR8->R8_MAT
	@   nLin, 023 PSay Substr( QRY_SR8->RA_NOME,1,30 )
	@   nLin, 055 PSay QRY_SR8->R8_CID
	@   nLin, 066 PSay QRY_SR8->R8_TIPO
	@   nLin, 069 PSay Substr(_cDescr, 1, 50)
	@   nLin, 121 PSay QRY_SR8->R8_DATAINI
	@   nLin, 130 PSay QRY_SR8->R8_DATAFIM
	@   nLin, 143 PSay QRY_SR8->R8_DURACAO PICTURE '999'
	@   nLin, 149 PSay QRY_SR8->R8_DPAGAR  PICTURE '999'

	DbSelectArea("QRY_SR8")
	DbSkip()

EndDo

DbSelectArea("QRY_SR8")
DbCloseArea()

Roda()

If aReturn[5]==1
   dbCommitAll()
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ Gera_SX1 บ Autor ณ AP6 IDE            บ Data ณ  03/12/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ    Gera parโmetro de perguntas                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function Gera_SX1( cPerg )

Local I:= J:= 0
Local aRegs:= {}

cPerg:= PadR( cPerg, Len( SX1->X1_GRUPO ) )

DbSelectArea("SX1")
DbSetOrder(1)

AADD(aRegs,{ cPerg, "01", "Do  Afastamento ?","","","MV_CH1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AADD(aRegs,{ cPerg, "02", "Ate Afastamento ?","","","MV_CH2","D",8,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AADD(aRegs,{ cPerg, "03", "Da  Filial      ?","","","MV_CH3","C",2,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AADD(aRegs,{ cPerg, "04", "Ate Filial      ?","","","MV_CH4","C",2,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","","","" } )
AADD(aRegs,{ cPerg, "05", "Do  C.Custo     ?","","","MV_CH5","C",9,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","","" } )
AADD(aRegs,{ cPerg, "06", "Ate C.Custo     ?","","","MV_CH6","C",9,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","CTT","","","","","" } )
AADD(aRegs,{ cPerg, "07", "Situa็๕es       ?","","","MV_CH7","C",1,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","30 ","","","","","" } )

For I:= 1 to Len( aRegs )
	If !DbSeek( cPerg + aRegs[I, 2] )
		RecLock("SX1",.t.)
			For J:= 1 to FCount()
				FieldPut( J, aRegs[ I, J] )
			Next
		MsUnlock()
		dbCommit()
	Endif
Next

Return