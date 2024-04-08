#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATR018 º Autor ³ Marcelo da Cunha   º Data ³  02/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Clientes 1a Compra/Reativados                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10 e MP11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BFATR018()
**********************

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cDesc1  := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2  := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3  := "Relatorio de Clientes 1a Compra/Reativados"
LOCAL cPict   := ""
LOCAL titulo  := "Relatorio de Clientes 1a Compra/Reativados"
LOCAL nLin    := 80
LOCAL Cabec1  := "CODIGO/LOJA     NOME CLIENTE                             VALOR FATURADO    PEDIDO      EMISSSAO             VALOR     VENDEDOR     "
LOCAL Cabec2  := ""
LOCAL imprime := .T.
LOCAL aOrd    := {}                     
LOCAL aRegs   := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 220
PRIVATE tamanho      := "G"
PRIVATE nomeprog     := "BFATR018" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "BFATR018" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "SA1"
PRIVATE cPerg        := "BFATR018"
PRIVATE cRepres      := ""
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria grupo de perguntas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aRegs := {}
AADD(aRegs,{cPerg,"01","Mostrar Dados           ?" ,"mv_ch1","N",01,0,0,"C","","MV_PAR01","1a Compra","","","Reativados","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ult.Compra Menor (dias) ?" ,"mv_ch2","N",03,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Data Emissao De         ?" ,"mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Data Emissao Ate        ?" ,"mv_ch4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Vendedor De             ?" ,"mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"06","Vendedor Ate            ?" ,"mv_ch6","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","SA3"})
u_BXCriaPer(cPerg,aRegs) //Brascola
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***********************************************
LOCAL cQuery1 := "", nQuant1 := 0, nTotal1 := 0                       
LOCAL cBrCfFat  := u_BXLstCfTes("BR_CFFAT")
LOCAL cBrCfNFat := u_BXLstCfTes("BR_CFNFAT")
LOCAL cBrTsFat  := u_BXLstCfTes("BR_TSFAT")
LOCAL cBrTsNFat := u_BXLstCfTes("BR_TSNFAT")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Query para buscar informacoes no banco de dados                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cQuery1 := "SELECT D2.D2_CLIENTE,D2.D2_LOJA,SUM(D2.D2_VALBRUT) D2_VALBRUT "
cQuery1 += "FROM "+RetSqlName("SD2")+" D2 "
cQuery1 += "INNER JOIN "+RetSqlName("SF2")+" F2 ON (D2.D2_DOC = F2.F2_DOC AND D2.D2_SERIE = F2.F2_SERIE AND D2.D2_CLIENTE = F2.F2_CLIENTE AND D2.D2_LOJA = F2.F2_LOJA) "
cQuery1 += "INNER JOIN "+RetSqlName("SF4")+" F4 ON (D2.D2_TES = F4.F4_CODIGO) "
cQuery1 += "INNER JOIN "+RetSqlName("SB1")+" B1 ON (D2.D2_COD = B1.B1_COD) "
cQuery1 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery1 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery1 += "AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery1 += "AND B1.D_E_L_E_T_ = '' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cQuery1 += "AND D2.D2_TIPO NOT IN ('B','D') AND F4.F4_DUPLIC = 'S' "
If (!u_BXRepAdm()) //Parametro/Presidente/Diretor
	cCodRep := u_BXRepLst("SQL") //Lista dos Representantes
	If !Empty(cCodRep)
		cQuery1 += "AND F2.F2_VEND1 IN ("+cCodRep+") "
	Else
		cQuery1 += "AND F2.F2_VEND1 = 'ZZZZZZ' "
	Endif
Endif	
If !Empty(cBrCfFat)
	cQuery1 += "AND D2.D2_CF IN ("+cBrCfFat+") "
Endif
If !Empty(cBrCfNFat)
	cQuery1 += "AND D2.D2_CF NOT IN ("+cBrCfNFat+") "
Endif
If !Empty(cBrTsFat)
	cQuery1 += "AND D2.D2_TES IN ("+cBrTsFat+") "
Endif
If !Empty(cBrTsNFat)
	cQuery1 += "AND D2.D2_TES NOT IN ("+cBrTsNFat+") "
Endif
cQuery1 += "AND F2.F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
cQuery1 += "AND F2.F2_VEND1 BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery1 += "GROUP BY D2.D2_CLIENTE,D2.D2_LOJA ORDER BY D2.D2_CLIENTE,D2.D2_LOJA "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
cQuery1 := ChangeQuery(cQuery1)
TCQuery cQuery1 NEW ALIAS "MAR"
   
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
dbSelectArea("MAR")
SetRegua(RecCount())
While !MAR->(EOF())
                 
	Incregua()                 
                    
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario                                ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio                                 ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   If (nLin > 55)
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifico 1a Compra e cliente Reativos                               ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aNota := B018Nota(MAR->D2_cliente,MAR->D2_loja)
	If ((mv_par01 == 1).and.Empty(aNota[2])).or.((mv_par01 == 2).and.!Empty(aNota[1]).and.!Empty(aNota[2]).and.(aNota[1] <= (FirstDay(mv_par03)-mv_par02)))
		SA1->(dbSeek(xFilial("SA1")+MAR->D2_cliente+MAR->D2_loja,.T.))
		@ nLin,000 PSAY MAR->D2_cliente+"/"+MAR->D2_loja+" - "+Alltrim(Substr(SA1->A1_nome,1,30))
		@ nLin,055 PSAY Transform(MAR->D2_valbrut,"@E 999,999,999.99")
		aDados := B018Dados(MAR->D2_cliente,MAR->D2_loja)
		@ nLin,075 PSAY aDados[2]
		@ nLin,087 PSAY dtoc(aDados[3])
		@ nLin,099 PSAY Transform(aDados[4],"@E 999,999,999.99")
		If !Empty(aDados[1]).and.SA3->(dbSeek(xFilial("SA3")+aDados[1]))
			@ nLin,118 PSAY Alltrim(SA3->A3_cod)+" - "+Alltrim(SA3->A3_nome)
		Endif
		nQuant1++
 		nTotal1 += MAR->D2_valbrut
		nLin++ // Avanca a linha de impressao
	Endif
                                            
   MAR->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
If (nLin != 80)
	nLin++
   @ nLin,000 PSAY "> TOTAL > "
   @ nLin,025 PSAY "CLIENTE(S): "+Alltrim(Str(nQuant1))
	@ nLin,055 PSAY Transform(nTotal1,"@E 999,999,999.99")
	Roda(cbcont,cbtxt,Tamanho)
Endif                  

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return                                          

Static Function B018Nota(xCliente,xLoja)
****************************************
LOCAL cQuery2 := "", aRetu2 := {ctod("//"),Space(9),Space(3)}
cQuery2 := "SELECT TOP 1 F2_EMISSAO,F2_DOC,F2_SERIE FROM "+RetSqlName("SF2")+" X "
cQuery2 += "WHERE X.D_E_L_E_T_ = '' AND X.F2_FILIAL = '"+xFilial("SF2")+"' AND X.F2_TIPO = 'N' "
cQuery2 += "AND X.F2_CLIENTE = '"+xCliente+"' AND X.F2_LOJA = '"+xLoja+"' AND X.F2_DUPL <> '' "
cQuery2 += "AND NOT X.F2_EMISSAO BETWEEN '"+dtos(mv_par03)+"' AND '"+dtos(mv_par04)+"' "
cQuery2 += "ORDER BY F2_EMISSAO DESC,F2_DOC DESC "
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
cQuery2 := ChangeQuery(cQuery2)
TCQuery cQuery2 NEW ALIAS "MSF2"                            
TCSetField("MSF2","F2_EMISSAO","D",08,0)
If !MSF2->(Eof())
	aRetu2 := {MSF2->F2_emissao,MSF2->F2_doc,MSF2->F2_serie}
Endif
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
Return aRetu2

Static Function B018Dados(xCliente,xLoja)
*****************************************
LOCAL cQuery3 := "", aRetu3 := {Space(6),Space(6),ctod("//"),0}
cQuery3 := "SELECT TOP 1 F2_EMISSAO,F2_DOC,F2_SERIE,F2_VEND1 FROM "+RetSqlName("SF2")+" X "
cQuery3 += "WHERE X.D_E_L_E_T_ = '' AND X.F2_FILIAL = '"+xFilial("SF2")+"' AND X.F2_TIPO = 'N' "
cQuery3 += "AND X.F2_CLIENTE = '"+xCliente+"' AND X.F2_LOJA = '"+xLoja+"' AND X.F2_DUPL <> '' "
cQuery3 += "ORDER BY F2_EMISSAO DESC,F2_DOC DESC "
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
cQuery3 := ChangeQuery(cQuery3)
TCQuery cQuery3 NEW ALIAS "MSF2"                            
TCSetField("MSF2","F2_EMISSAO","D",08,0)
If !MSF2->(Eof())
	aRetu3[1] := MSF2->F2_vend1
	SD2->(dbSetOrder(3)) ; SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
	SD2->(dbSeek(xFilial("SD2")+MSF2->F2_doc+MSF2->F2_serie,.T.))
	While !SD2->(Eof()).and.(xFilial("SD2") == SD2->D2_filial).and.(SD2->D2_doc+SD2->D2_serie == MSF2->F2_doc+MSF2->F2_serie)
		aRetu3[2] := SD2->D2_pedido
		If SC5->(dbSeek(xFilial("SC5")+SD2->D2_pedido))
			aRetu3[3] := SC5->C5_emissao
			SC6->(dbSeek(xFilial("SC6")+SC5->C5_num,.T.))
			While !SC6->(Eof()).and.(xFilial("SC6") == SC6->C6_filial).and.(SC6->C6_num == SC5->C5_num)
				aRetu3[4] += SC6->C6_valor
				SC6->(dbSkip())
			Enddo			
		Endif
		If !Empty(aRetu3[2])
			Exit
		Endif
		SD2->(dbSkip())
	Enddo
Endif
If (Select("MSF2") <> 0)
	dbSelectArea("MSF2")
	dbCloseArea()
Endif
Return aRetu3