# INCLUDE "RWMAKE.CH"

/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA009         AUTOR:                          DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO:Consulta lotes a vencer.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

USER FUNCTION BESTA009()

Local cQuery      := ""
Local aRegs       := {}
Local aTela       := {}
Private aRotina   := { { "Legenda"  ,"U_LEGCON" ,0,1},;
                       { "Relatorio","U_RELCON" ,0,2}}
Private cCadastro := "Consulta a Lotes"
Private aCampos   := {}
Private _cArqTmp  := ""

_aTela   := {{"PRODUTO","","PRODUTO"},{"UM","","UM"},{"DESCRICAO","","DESCRICAO"},{"LOCAL","","LOCAL"},;
				 {"LOTE","","LOTE"},{"VALIDADE","","VALIDADE"},{"SALDO",,"SALDO","@E 9,999,999.99"}}
				 
Aadd(aCampos,{"OK"           ,"C",002,0})
Aadd(aCampos,{"PRODUTO"      ,"C",015,0})
Aadd(aCampos,{"UM"           ,"C",003,0})
Aadd(aCampos,{"DESCRICAO"    ,"C",050,0})
Aadd(aCampos,{"LOCAL"        ,"C",002,0})
Aadd(aCampos,{"LOTE"         ,"C",015,0})
Aadd(aCampos,{"VALIDADE"     ,"D",008,0})
Aadd(aCampos,{"SALDO"        ,"N",016,2})   


AADD(aRegs,{"CONLOT","01","A Vencer Ate?","A Vencer Ate?","A Vencer Ate?","mv_ch1","D",8,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{"CONLOT","02","Considera Saldo Zerado?","Considera Saldo Zerado?","Considera Saldo Zerado?","mv_ch2","N",01,0,0,"C","","mv_par01","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","" } ) 
//Aadd(aRegs,{"CONLOT","03","Somente PA?","Somente PA?","Somente PA?","mv_ch3","N",01,0,0,"C","","mv_par03","Sim","","","","","Nao","","","","","","Apenas Arm.10?","","","","","","","","","","","","","","","" } ) 

//Fernando: 28/10/13 - Alterado a combo da pergunta 3
Aadd(aRegs,{"CONLOT","03","Tipo?","Tipo?","Tipo?","mv_ch3","N",01,0,0,"C","","mv_par03","1-MP","","","","","2-EMB","","","","","3-PA","","","","","Apenas Arm.10?","","","","","","","","","","","" } ) 

lValidPerg(aRegs)

IF PERGUNTE("CONLOT",.T.)  
	cQuery := "SELECT SB8.B8_PRODUTO PRODUTO, SB1.B1_UM UM, SB1.B1_DESC DESCRICAO, SB8.B8_LOTECTL LOTE, "
	cQuery += "SB8.B8_LOCAL LOCAL , SB8.B8_DTVALID VALIDADE , SB8.B8_SALDO SALDO "
	cQuery += "FROM SB8010 SB8 INNER JOIN SB1010 SB1 ON SB1.D_E_L_E_T_ = '' AND SB1.B1_COD = SB8.B8_PRODUTO "
	
	//Fernando: 29/10/13 - Alterado condi��o para validar Tipo do Produto
	IF MV_PAR03 == 1
		cQuery += "AND SB1.B1_TIPO = '1' "
	ELSEIF MV_PAR03 == 2 
		cQuery += "AND SB1.B1_TIPO = '2' " 
	ELSEIF MV_PAR03 == 3 
		cQuery += "AND SB1.B1_TIPO = '3' " 
	ENDIF        
	 
	IF MV_PAR03 == 4
		cQuery += "AND SB8.B8_LOCAL = '10' "
	ENDIF

	cQuery += "WHERE SB8.D_E_L_E_T_ = '' AND SB8.B8_FILIAL = '" + XFILIAL("SB8") + "' "
	
	//Fernando: 28/10/13 - alterado compara��o para 3, antes era 1
	IF MV_PAR03 == 3
		cQuery += "AND SB8.B8_LOCAL = '40' "
	ENDIF
	cQuery += "AND SB8.B8_DTVALID <= '" + DTOS(MV_PAR01) + "' " 
	IF MV_PAR02 == 2
		cQuery += "AND SB8.B8_SALDO > 0 "
	ENDIF
	cQuery += "ORDER BY SB8.B8_DTVALID"

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBSB8',.F.,.T.)
	
	TCSetField('TRBSB8', "VALIDADE" , "D",08,0)
	TCSetField('TRBSB8', "SALDO"  , "N",16,2)
	
	_cArqTmp := CriaTrab(aCampos,.T.)
   	dbUseArea( .T.,,_cArqTmp, "TRB", .F., .F. )
   
   TRBSB8->(DBGOTOP())
   WHILE !TRBSB8->(EOF())
   	RECLOCK("TRB",.T.)
	   	TRB->PRODUTO   := TRBSB8->PRODUTO
   		TRB->UM        := TRBSB8->UM
   		TRB->DESCRICAO := TRBSB8->DESCRICAO
   		TRB->LOCAL     := TRBSB8->LOCAL
   		TRB->LOTE      := TRBSB8->LOTE
   		TRB->VALIDADE  := TRBSB8->VALIDADE
   		TRB->SALDO     := TRBSB8->SALDO
   	MSUNLOCK()
   	TRBSB8->(DBSKIP())	
   ENDDO	
   
   TRB->(DBGOTOP())
    MarkBrowse("TRB","","SALDO == 0",_aTela)

	TRBSB8->(DBCLOSEAREA())
	TRB->(DBCLOSEAREA())
	FERASE(_cArqTmp+".DBF")

ENDIF

RETURN(.T.)	


/******************************************************************************************************************
** FUNCAO:     FUNCAO PARA MOSTRAR LEGENDA                                                                       **
** DATA  :     14/04/05																														  **
** AUTOR :     SERGIO LACERDA/WANDERLEY GONCALVES                                                                **
******************************************************************************************************************/

USER Function LegCon()

Local aCores := {  {"BR_VERDE" ,"Com Saldo Disponivel"},; //"Faturamento com Meio Magnetico"
                     {"BR_VERMELHO","Sem Saldo Disponivel"}}                     
BrwLegenda("Status do Item",,aCores)

Return(.T.)

/******************************************************************************************************************
**                                IMPRESSAO DA CONSULTA DE LOTES																  **
******************************************************************************************************************/

User Function RELCON()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Lotes por Validade"
Local cPict          := ""
Local titulo         := "Relatorio de Lotes por Validade"
Local nLin           := 80
Local Cabec1         := "Produto             Um     Descricao                                  Lote           Validade            Saldo"
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 132
Private tamanho      := "M"
Private nomeprog     := "RELCON" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "RELCON" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPerg        := ""

Private cString := "TRB"

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

//wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  16/08/05   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

dbSelectArea("TRB")
dbGoTop()
While !EOF()

   //���������������������������������������������������������������������Ŀ
   //� Verifica o cancelamento pelo usuario...                             �
   //�����������������������������������������������������������������������

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //���������������������������������������������������������������������Ŀ
   //� Impressao do cabecalho do relatorio. . .                            �
   //�����������������������������������������������������������������������

   If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

   @ nLin , 001 PSAY TRB->PRODUTO
   @ nLin , 020 PSAY TRB->UM
   @ nLin , 027 PSAY TRB->DESCRICAO
   @ nLin , 071 PSAY TRB->LOTE
   @ nLin , 086 PSAY TRB->VALIDADE
   @ nLIn , 101 PSAY TRB->SALDO PICTURE "@R 999,999.99"
   
   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return(.T.)