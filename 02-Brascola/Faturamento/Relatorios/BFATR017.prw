#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � BFATR017 � Autor � Marcelo da Cunha   � Data �  02/05/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de NF Amostras e Bonificacoes                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10 e MP11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BFATR017()
**********************

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
LOCAL cDesc1  := "Este programa tem como objetivo imprimir relatorio "
LOCAL cDesc2  := "de acordo com os parametros informados pelo usuario."
LOCAL cDesc3  := "Relatorio de NF Amostras e Bonificacoes"
LOCAL cPict   := ""
LOCAL titulo  := "Relatorio de NF Amostras e Bonificacoes"
LOCAL nLin    := 80
LOCAL Cabec1  := "NOTA/SERIE     EMISSAO        VALOR BRUTO       TIPO                       CLIENTE "
LOCAL Cabec2  := ""
LOCAL imprime := .T.
LOCAL aOrd    := {}                     
LOCAL aRegs   := {}

PRIVATE lEnd         := .F.
PRIVATE lAbortPrint  := .F.
PRIVATE CbTxt        := ""
PRIVATE limite       := 132
PRIVATE tamanho      := "M"
PRIVATE nomeprog     := "BFATR017" // Coloque aqui o nome do programa para impressao no cabecalho
PRIVATE nTipo        := 18
PRIVATE aReturn      := {"Zebrado",1,"Administracao",2,2,1,"",1}
PRIVATE nLastKey     := 0
PRIVATE cbtxt        := Space(10)
PRIVATE cbcont       := 00
PRIVATE CONTFL       := 01
PRIVATE m_pag        := 01
PRIVATE wnrel        := "BFATR017" // Coloque aqui o nome do arquivo usado para impressao em disco
PRIVATE cString      := "SD2"                                  
PRIVATE cPerg        := "BFATR017"
                   
//��������������������������������������������������������������Ŀ
//� Cria grupo de perguntas                                      �
//����������������������������������������������������������������
aRegs := {}
AADD(aRegs,{cPerg,"01","Emissao De    ?" ,"mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Emissao Ate   ?" ,"mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Cliente De    ?" ,"mv_ch3","C",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"04","Cliente Ate   ?" ,"mv_ch4","C",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","CLI"})
AADD(aRegs,{cPerg,"05","Loja De       ?" ,"mv_ch5","C",04,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Loja Ate      ?" ,"mv_ch6","C",04,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Produto De    ?" ,"mv_ch7","C",15,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"08","Produto Ate   ?" ,"mv_ch8","C",15,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SB1"})
AADD(aRegs,{cPerg,"09","Vendedor De   ?" ,"mv_ch9","C",06,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"10","Vendedor Ate  ?" ,"mv_chA","C",06,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"11","Supervisor De ?" ,"mv_chB","C",06,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","SA3"})
AADD(aRegs,{cPerg,"12","Supervisor Ate?" ,"mv_chC","C",06,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","SA3"})
u_BXCriaPer(cPerg,aRegs) //Brascola
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario                              �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
***********************************************
LOCAL cQuery1 := "", aQuant := {0,0,0}, aTotal := {0,0,0}
      
//���������������������������������������������������������������������Ŀ
//� Query para buscar informacoes no banco de dados                     �
//�����������������������������������������������������������������������
cQuery1 := "SELECT D2.D2_DOC,D2.D2_SERIE,D2.D2_EMISSAO,D2.D2_CF,D2.D2_CLIENTE,D2.D2_LOJA,F2.F2_VEND1,SUM(D2.D2_QUANT) D2_QUANT,SUM(D2.D2_VALBRUT) D2_VALBRUT "
cQuery1 += "FROM "+RetSqlName("SD2")+" D2,"+RetSqlName("SF4")+" F4,"+RetSqlName("SF2")+" F2,"+RetSqlName("SC6")+" C6 "
cQuery1 += "WHERE D2.D_E_L_E_T_ = '' AND D2.D2_FILIAL = '"+xFilial("SD2")+"' AND F4.D_E_L_E_T_ = '' AND F4.F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery1 += "AND F2.D_E_L_E_T_ = '' AND F2.F2_FILIAL = '"+xFilial("SF2")+"' AND C6.D_E_L_E_T_ = '' AND C6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery1 += "AND D2.D2_TES=F4.F4_CODIGO AND D2.D2_DOC=F2.F2_DOC AND D2.D2_SERIE=F2.F2_SERIE AND D2.D2_CLIENTE=F2.F2_CLIENTE AND D2.D2_LOJA=F2.F2_LOJA "
cQuery1 += "AND D2.D2_PEDIDO=C6.C6_NUM AND D2.D2_ITEMPV=C6.C6_ITEM AND D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
cQuery1 += "AND D2.D2_CLIENTE BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' AND D2.D2_LOJA BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' "
cQuery1 += "AND D2.D2_COD BETWEEN '"+mv_par07+"' AND '"+mv_par08+"' AND F2.F2_VEND1 BETWEEN '"+mv_par09+"' AND '"+mv_par10+"' "
cQuery1 += "AND C6.C6_X_REGRA = '' AND D2.D2_CF IN ('5910','6910','5911','6911') "
cQuery1 += "GROUP BY D2.D2_DOC,D2.D2_SERIE,D2.D2_EMISSAO,D2.D2_CF,D2.D2_CLIENTE,D2.D2_LOJA,F2.F2_VEND1 "
cQuery1 += "ORDER BY D2.D2_DOC,D2.D2_SERIE "
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
cQuery1 := ChangeQuery(cQuery1)
TCQuery cQuery1 NEW ALIAS "MAR"
TCSetField("MAR","D2_EMISSAO","D",08,0)
   
SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
dbSelectArea("MAR")
SetRegua(RecCount())
While !MAR->(EOF())
                 
	Incregua()                 
                    
   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario                                �
   //�����������������������������������������������������������������������
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio                                 �
   //�����������������������������������������������������������������������
   If (nLin > 55)
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
   //���������������������������������������������������������������������Ŀ
   //� Filtro por supervisor                                               �
   //�����������������������������������������������������������������������
	If !Empty(MAR->F2_vend1)
		SA3->(dbSeek(xFilial("SA3")+MAR->F2_vend1,.T.))
		If (SA3->A3_super < mv_par11).or.(SA3->A3_super > mv_par12)
			MAR->(dbSkip())
			Loop
		Endif
	Endif
                  
	SA1->(dbSeek(xFilial("SA1")+MAR->D2_cliente+MAR->D2_loja,.T.))
	@ nLin,000 PSAY MAR->D2_doc+"/"+MAR->D2_serie
	@ nLin,015 PSAY dtoc(MAR->D2_emissao)
	@ nLin,027 PSAY Transform(MAR->D2_valbrut,"@E 999,999,999.99")
	If (Alltrim(MAR->D2_cf) $ "5910/6910") //Bonificacao
		@ nLin,048 PSAY MAR->D2_cf+" - BONIFICACAO "
		aQuant[1]++ ; 	aTotal[1] += MAR->D2_valbrut
	Elseif (Alltrim(MAR->D2_cf) $ "5911/6911") //Amostra
		@ nLin,048 PSAY MAR->D2_cf+" - AMOSTRA "
		aQuant[2]++ ; 	aTotal[2] += MAR->D2_valbrut
	Endif	
	@ nLin,075 PSAY MAR->D2_cliente+"/"+MAR->D2_loja+" - "+Alltrim(Substr(SA1->A1_nome,1,30))
   nLin++ // Avanca a linha de impressao
                                            
	aQuant[3]++ ; aTotal[3] += MAR->D2_valbrut

   MAR->(dbSkip()) // Avanca o ponteiro do registro no arquivo
EndDo
If (nLin != 80)
   nLin++ // Avanca a linha de impressao
   nTotFat1 := B017Fatur()
   @ nLin,000 PSAY "> TOTAL BONIFICACAO.: "+Alltrim(Str(aQuant[1]))
	@ nLin,027 PSAY Transform(aTotal[1],"@E 999,999,999.99")
	If (nTotFat1 > 0)
		@ nLin,042 PSAY Transform((aTotal[1]/nTotFat1)*100,"@E 99,999.99")+"% DO FATURAMENTO DO PERIODO"
	Endif
	nLin++
   @ nLin,000 PSAY "> TOTAL AMOSTRAS....: "+Alltrim(Str(aQuant[2]))
	@ nLin,027 PSAY Transform(aTotal[2],"@E 999,999,999.99")
	If (nTotFat1 > 0)
		@ nLin,042 PSAY Transform((aTotal[2]/nTotFat1)*100,"@E 99,999.99")+"% DO FATURAMENTO DO PERIODO"
	Endif
	nLin++
   @ nLin,000 PSAY "> TOTAL GERAL.......: "+Alltrim(Str(aQuant[3]))
	@ nLin,027 PSAY Transform(aTotal[3],"@E 999,999,999.99")
	If (nTotFat1 > 0)
		@ nLin,042 PSAY Transform((aTotal[3]/nTotFat1)*100,"@E 99,999.99")+"% DO FATURAMENTO DO PERIODO"
	Endif
	Roda(cbcont,cbtxt,Tamanho)
Endif                  

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao             �
//�����������������������������������������������������������������������
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()

Return                                          

Static Function B017Fatur()
************************
LOCAL cQuery2 := "", nRetu2 := 0
LOCAL cBrCfFat := u_BXLstCfTes("BR_CFFAT"), cBrCfNFat := u_BXLstCfTes("BR_CFNFAT")
LOCAL cBrTsFat := u_BXLstCfTes("BR_TSFAT"), cBrTsNFat := u_BXLstCfTes("BR_TSNFAT")
cQuery2 := "SELECT SUM(SD2.D2_VALBRUT) AS FATURA FROM "+RetSqlName("SD2")+" SD2 "
cQuery2 += "INNER JOIN "+RetSqlName("SF2")+" SF2 ON (SF2.F2_FILIAL = '"+xFilial("SF2")+"' AND SF2.F2_DOC = SD2.D2_DOC "
cQuery2 += "AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.D_E_L_E_T_='') "
cQuery2 += "INNER JOIN "+RetSqlName("SF4")+" SF4 ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SD2.D2_TES AND SF4.D_E_L_E_T_='') "
cQuery2 += "WHERE SD2.D_E_L_E_T_='' AND SF4.F4_DUPLIC = 'S' AND SD2.D2_EMISSAO BETWEEN '"+dtos(mv_par01)+"' AND '"+dtos(mv_par02)+"' "
If !Empty(cBrCfFat)
	cQuery2 += "AND SD2.D2_CF IN ("+cBrCfFat+") "
Endif
If !Empty(cBrCfNFat)
	cQuery2 += "AND SD2.D2_CF NOT IN ("+cBrCfNFat+") "
Endif
If !Empty(cBrTsFat)
	cQuery2 += "AND SD2.D2_TES IN ("+cBrTsFat+") "
Endif
If !Empty(cBrTsNFat)
	cQuery2 += "AND SD2.D2_TES NOT IN ("+cBrTsNFat+") "
Endif
cQuery2 := ChangeQuery(cQuery2)
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif
TCQuery cQuery2 NEW ALIAS "MSD2"
dbSelectArea("MSD2")
If  !MSD2->(Eof())
	nRetu2 := MSD2->FATURA
Endif
If (Select("MSD2") <> 0)
	dbSelectArea("MSD2")
	dbCloseArea()
Endif
Return nRetu2