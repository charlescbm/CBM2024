//#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTransTra  บAutor  ณ Sergio Lacerda     บ Data ณ  01/09/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime Relatorio da Transportadora                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAlteracoesณ 29.05.07 - Modificacao criada para que o sistema passe a   บฑฑ
ฑฑบ          ณ            chamar a funcao expgko passando um parametro.   บฑฑ
ฑฑบAlteracoesณ 11.06.07 - Modificacao para impressao das informacoes do   บฑฑ
ฑฑบ          ณ            destinatario da nota. Cliente ou Fornecedor.    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TRANSFRA(cMarca)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Transferencia de Produto para Transportadora"
Local cPict          := ""
Local titulo         := "Transf. de Produto p/ Transportadora"
Local nLin           := 80
					 //          1         2         3         4         5         6         7         8
                     //012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec1       	 := "NR.NOTA  PESO(KG)     VLR. NOTA  CLIENTE          UF  DT. NOTA  VOLUME  TRANSP."
Local Cabec2       	 := ""
Local imprime      	 := .T.
Local aOrd 			 := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite		 := 80
Private tamanho      := "P"
Private nomeprog     := "TRANSTRA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CRIAPERG("TRANSP2")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "TRANSTRA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aRegs        := {}
Private nPeso,nValor,nNotas,nVolum
Private cString := "SF2"

nPeso  := 0
nValor := 0
nNotas := 0
nVolum := 0
         
/*
If MsgYesNo("Deseja gerar arquivo txt ?")
	U_ExpGKO2()
endif
*/

dbSelectArea("SF2")

AADD(aRegs,{cPerg,"01","Transportadora     ?"," "," ","mv_ch1","C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA4","","","","",""})
AADD(aRegs,{cPerg,"02","Embarcar em        ?"," "," ","mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","","",""})

lValidPerg( aRegs )

If pergunte(cPerg,.T.)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
EndIf
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport บAutor  ณ Sergio Lacerda     บ Data ณ  01/09/2005 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cQuery 	:= ''
Local cAlias	:= 'TRANSTRA'
Local nCount	:= 0

cQuery := " SELECT SF2.R_E_C_N_O_ AS REGISTRO"
cQuery += " 	FROM "+RetSqlName('SF2')+" SF2 "
cQuery += " 	WHERE SF2.D_E_L_E_T_ <> '*' "
cQuery += " 		AND SF2.F2_OK2 = '"+cMarca+"'"
cQuery += " ORDER BY SF2.R_E_C_N_O_ "


cQuery := ChangeQuery( cQuery ) 
dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), cAlias, .T., .T. )

(cAlias)->( dbGotop() ) 
While !(cAlias)->( Eof() ) 
	nCount++
	(cAlias)->( dbSkip() ) 
EndDo
                              
SetRegua( nCount )

(cAlias)->( dbGotop() ) 
While !(cAlias)->( Eof() ) 
	IncRegua()

	dbSelectArea( 'SF2' )
	SF2->( dbGoTo( (cAlias)->REGISTRO ) ) 

	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Verifica o cancelamento pelo usuario...                             ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	   If lAbortPrint
	      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      Exit
	   Endif
	
	   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	   //ณ Impressao do cabecalho do relatorio. . .                            ณ
	   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	   If nLin > 55 // Salto de Pแgina. Neste caso o formulario tem 55 linhas...
	      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	      nLin := 8
	   Endif
	   nLin := nLin + 1 // Avanca a linha de impressao
	   
		@  nLin, 000 PSAY RTRIM(SF2->F2_DOC)
		@  nLin, 009 PSAY SF2->F2_PBRUTO     PICTURE "999,999.9999"  //007
		@  nLin, 023 PSAY SF2->F2_VALBRUTO   PICTURE "9,999,999.99"  //020
		
		nPeso := nPeso + SF2->F2_PBRUTO
		nValor:= nValor + SF2->F2_VALBRUTO
		nNotas++  
		
      //Tratamento para correta impresใo de informacใo dos clientes ou fornecedores
		_cAlias  := IIF(SF2->F2_TIPO$"D/B","SA2","SA1")		
		DBSELECTAREA(_cAlias)
		DBSETORDER(1)
		IF DBSEEK(XFILIAL(_cAlias)+SF2->F2_CLIENTE+SF2->F2_LOJA)
			_cNreduz := IIF(SF2->F2_TIPO$"D/B",SA2->A2_NREDUZ,SA1->A1_NREDUZ)		
			_cEst    := IIF(SF2->F2_TIPO$"D/B",SA2->A2_EST,SA1->A1_EST)		
			@  nLin, 036 PSAY SUBSTR(_cNreduz,1,15)
			@  nLIn, 050 PSAY _cEst
			DBSELECTAREA("SF2")
		ENDIF   
		
		@ nLin, 054 PSAY SF2->F2_EMISSAO
		@ nLin, 064 PSAY SF2->F2_VOLUME1
		
		nVolum := nVolum + SF2->F2_VOLUME1
		
		DBSELECTAREA("SA4")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SA4")+MV_PAR01)
			@ nLin, 072 PSAY SA4->A4_NREDUZ
		ENDIF
		DBSELECTAREA("SF2")
		RECLOCK("SF2",.F.)
		SF2->F2_DTSAIDA := MV_PAR02
	 //	SF2->F2_OK2 	 := Space(Len(SF2->F2_OK2))
		SF2->( MSUNLOCK() ) 
	(cAlias)->(dbSkip())
EndDo

nLin += 2                     
 
cTexto := "A Transportadora "+AllTrim(SA4->A4_NREDUZ)+" declara estar recebendo em " + AllTrim(DTOC(mv_par02))
cTexto += " as Notas Fiscais relacionadas acima, bem como suas respectivas mercadorias,"
cTexto += " totalizando " + AllTrim(STR(nNotas,3)) + " NOTAS, com " + AllTrim(STR(nPeso,10))  + " KILOS no VALOR TOTAL DE R$ " + alltrim(Transform(nValor,"@E 999,999,999.99"))
cTexto += " embalados em " + ALLTRIM(TransForm(nVolum,"@E 999,999,999")) + " Volumes"

nMsgLin := MLCOUNT(cTexto, 75, 3, .T.)

For _nLinMsg := 1 To nMsgLin
	@nLin++,001 PSay MemoLine(cTexto, 75, _nLinMsg, 3, .T.)	
Next _nLinMsg

nLin += 4

@  nLin, 001 PSAY "Chapa do Caminhao _______________          Peso do Caminhใo __________  __________"	
@++nLin, 001 PSAY "                                                              Antes      Depois   "

nLin += 4

@  nLin, 001 PSAY "____________________          ____________________          ____________________"
@++nLin, 001 PSAY "     Liberado Por                 Transportadora                  Liberador    "

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

(cAlias)->( dbCloseArea() )                  
//Novo
If MsgYesNo("Deseja gerar arquivo txt ?")
	//Elias Reis - 29/05/07
	U_ExpGKO2() 
	lPar := .T.
	U_ExpGKO(lPar)
endif             

TcSqlExec("UPDATE "+RetSqlName('SF2')+" SET F2_OK2 = SPACE(4) WHERE F2_OK2 <> '    '")
     
//Fim

Return