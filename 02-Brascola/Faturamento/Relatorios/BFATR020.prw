#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠иммммммммммяммммммммммкмммммммяммммммммммммммммммммкммммммяммммммммммммм╩╠╠
╠╠╨Programa  Ё BFATR020 ╨ Autor Ё Marcelo da Cunha   ╨ Data Ё  18/12/13   ╨╠╠
╠╠лммммммммммьммммммммммймммммммоммммммммммммммммммммйммммммоммммммммммммм╧╠╠
╠╠╨Descricao Ё Relatorio de Pedidos Rejeitados                            ╨╠╠
╠╠╨          Ё                                                            ╨╠╠
╠╠лммммммммммьмммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╧╠╠
╠╠╨Uso       Ё MP10 e MP11                                                ╨╠╠
╠╠хммммммммммомммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╪╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
User Function BFATR020()
**********************

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Declaracao de Variaveis                                             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
LOCAL cDesc1  := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2  := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3  := "Relatorio de Pedidos Rejeitados"
LOCAL cPict   := ""
LOCAL titulo  := "Relatorio de Pedidos Rejeitados"
LOCAL nLin    := 80
LOCAL Cabec1  := "PEDIDO    EMISSAO     CLIENTE                                              VENDEDOR                                         VALOR      MOTIVO REJEICAO "
LOCAL Cabec2  := ""
LOCAL imprime := .T.
LOCAL aOrd    := {}                     
LOCAL aRegs   := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 220
PRIVATE tamanho      := "G"
PRIVATE nomeprog     := "BFATR020" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "BFATR020" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "SC9"                                  
PRIVATE cPerg        := "BFATR020"
                   
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Cria grupo de perguntas                                      Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
aRegs := {}
AADD(aRegs,{cPerg,"01","Emissao De    ?" ,"mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Ate   ?" ,"mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cliente De    ?" ,"mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"04","Cliente Ate   ?" ,"mv_ch4","C",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"05","Loja De       ?" ,"mv_ch5","C",04,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Loja Ate      ?" ,"mv_ch6","C",04,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Vendedor De   ?" ,"mv_ch7","C",06,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"08","Vendedor Ate  ?" ,"mv_ch8","C",06,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"09","Supervisor De ?" ,"mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"10","Supervisor Ate?" ,"mv_chA","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","SA3"})
u_BXCriaPer(cPerg,aRegs) //Brascola
Pergunte(cPerg,.F.)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Monta a interface padrao com o usuario                              Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Processamento. RPTSTATUS monta janela com a regua de processamento. Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***********************************************
LOCAL cQuery1 := "", aTotal := {0,0}
      
//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Query para buscar informacoes no banco de dados                     Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
cQuery1 := "SELECT C5_NUM,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C5_VEND1,SUM(C6_VALOR) C6_VALOR "
cQuery1 += "FROM "+RetSqlName("SC5")+" SC5, "+RetSqlName("SC6")+" SC6 "
cQuery1 += "WHERE SC5.D_E_L_E_T_='' AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery1 += "AND SC6.D_E_L_E_T_='' AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery1 += "AND SC5.C5_NUM = SC6.C6_NUM AND C5_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery1 += "AND C5_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND C5_LOJACLI BETWEEN '"+mv_par05+"' "
cQuery1 += "AND '"+mv_par06+"' AND C5_VEND1 BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' "
cQuery1 += "AND (SELECT COUNT(*) FROM "+RetSqlName("SC9")+" X WHERE X.D_E_L_E_T_='' AND X.C9_PEDIDO = SC5.C5_NUM AND X.C9_MOTREJ <> '') > 0 "
cQuery1 += "GROUP BY C5_NUM,C5_EMISSAO,C5_CLIENTE,C5_LOJACLI,C5_VEND1 "
cQuery1 += "ORDER BY C5_NUM "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
cQuery1 := ChangeQuery(cQuery1)
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","C5_EMISSAO","D",08,0)
   
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SC9->(dbSetOrder(1))
dbSelectArea("MAR")
SetRegua(RecCount())
While !MAR->(EOF())
                 
	Incregua()                 
                    
   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Verifica o cancelamento pelo usuario                                Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Impressao do cabecalho do relatorio                                 Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   If (nLin > 55)
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Filtro por supervisor                                               Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   cCodVen := "" ; cNomVen := ""
	If !Empty(MAR->C5_vend1)
		SA3->(dbSeek(xFilial("SA3")+MAR->C5_vend1,.T.))
		cCodVen := MAR->C5_vend1 ; cNomVen := SA3->A3_nome
		If (SA3->A3_super < mv_par09).or.(SA3->A3_super > mv_par10)
			MAR->(dbSkip())
			Loop
		Endif
	Endif

   //зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
   //Ё Verifico motivo da rejeivao                                         Ё
   //юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
   cMotRej := ""
   SC9->(dbSeek(xFilial("SC9")+MAR->C5_num,.T.))
   While !SC9->(Eof()).and.(xFilial("SC9") == SC9->C9_filial).and.(SC9->C9_pedido == MAR->C5_num)
   	If !Empty(SC9->C9_motrej)
   		cMotRej := Alltrim(SC9->C9_motrej)
   		Exit
   	Endif
	   SC9->(dbSkip())
   Enddo
                  
	SA1->(dbSeek(xFilial("SA1")+MAR->C5_cliente+MAR->C5_lojacli,.T.))
	@ nLin,000 PSAY MAR->C5_num
	@ nLin,010 PSAY dtoc(MAR->C5_emissao)
	@ nLin,022 PSAY MAR->C5_cliente+"/"+MAR->C5_lojacli+" - "+Alltrim(Substr(SA1->A1_nome,1,30))
	If !Empty(cCodVen)
		@ nLin,075 PSAY cCodVen+" - "+Alltrim(Substr(cNomVen,1,30))
	Endif
	@ nLin,115 PSAY Transform(MAR->C6_valor,"@E 999,999,999.99")
	If !Empty(cMotRej)
		@ nLin,135 PSAY Substr(cMotRej,1,85)
	Endif
   nLin++ // Avanca a linha de impressao
   
   aTotal[1]++                                         
	aTotal[2] += MAR->C6_valor

   MAR->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
If (nLin != 80)
   nLin++ // Avanca a linha de impressao
   @ nLin,000 PSAY "> TOTAL PEDIDOS REJEITADOS: "+Alltrim(Str(aTotal[1]))
	@ nLin,115 PSAY Transform(aTotal[2],"@E 999,999,999.99")
	Roda(cbcont,cbtxt,Tamanho)
Endif

SET DEVICE TO SCREEN

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Se impressao em disco, chama o gerenciador de impressao             Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return