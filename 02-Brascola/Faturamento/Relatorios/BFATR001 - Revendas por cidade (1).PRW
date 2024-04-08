/*/
----------------------------------------------------------------------------
PROGRAMA: BFATR001         AUTOR:                        DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Relatorio de clientes tipo "revenda" relacionados por ordem de estado
ou cidade, conforme parametros selecionados pelo usuário.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/

User Function BFATR001()

Local cDesc1         := " Relatorio de clientes tipo revenda relacionados por ordem de estado"
Local cDesc2         := "ou cidade, conforme parametros selecionados pelo usuário."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "REVENDAS POR CIDADE"
Local nLin           := 80
Local Cabec1         := " Codigo Loja Nome Cliente                   Endereco                                  Bairro             Cidade                 Estado  DDD  Telefone          Email                                Contato               "
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Local cQuery         := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "REVNDA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CRIAPERG("REVNDA")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "REVNDA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aRegs        := {}
Private cString      := ""

Aadd(aRegs,{cPerg,"01","Consulta Por"        , "Consulta Por",	  		"Consulta Por",			"mv_ch1","N",01,0,0,"C","","mv_par01","Cidade",	"","","","","Estado",	"","","","","","","","","","","","","","","","","","","",		"","","",""}) 
AADD(aRegs,{cPerg,"02","Cidade"              , "Cidade",					"Cidade",			"mv_ch2","C",40,0,0,"G","","MV_PAR02","",			"","","","","",			"","","","","","","","","","","","","","","","","","","",		"","","",""})
Aadd(aRegs,{cPerg,"03","Estado      ?"       , ""      ,							"",			"mv_ch3","C",02,0,0,"G","","mv_par03","",			"","","","","",			"","","","","","","","","","","","","","","","","","","12",	"","","",""}) 
AADD(aRegs,{cPerg,"04","Meses de Faturamento", "Meses de Faturamento",	"Meses de Faturamento",	"mv_ch4","N",02,0,0,"G","","MV_PAR04","",			"","","","","",			"","","","","","","","","","","","","","","","","","","",		"","","",""})
Aadd(aRegs,{cPerg,"05","Produto"             , "Produto",					"Produto",			"mv_ch5","C",15,0,0,"G","","mv_par05","",			"","","","","",			"","","","","","","","","","","","","","","","","","","SB1",	"","","",""}) 
AADD(aRegs,{cPerg,"06","Grupo do Cliente :"  , "Grupo do Cliente :",	"Grupo do Cliente :",	"mv_ch6","C",40,0,0,"G","","MV_PAR06","",			"","","","","",			"","","","","","","","","","","","","","","","","","","ACY",	"","","",""})

U_BCFGA002("BFATR001")//Grava detalhes da rotina usada 

lValidPerg(aRegs)  


pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1, Cabec2,  Titulo,  nLin) },Titulo) 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  16/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
Local cQuery := ""

cQuery := "SELECT  SA1.A1_COD CODIGO , SA1.A1_LOJA LOJA , SA1.A1_NOME NOME , SA1.A1_END ENDERECO , SA1.A1_BAIRRO BAIRRO , "
cQuery += "SA1.A1_EST ESTADO , SA1.A1_MUN CIDADE , SA1.A1_DDD DDD , SA1.A1_TEL TELEFONE , SA1.A1_EMAIL EMAIL , "
cQuery += "SA1.A1_CONTATO CONTATO "
cQuery += "FROM " + RETSQLNAME("SA1") + " SA1 "
cQuery += "WHERE SA1.A1_COD IN (SELECT DISTINCT(SD2.D2_CLIENTE) FROM " + RETSQLNAME("SD2") + " SD2 "
cQuery += 																			 "WHERE SD2.D2_EMISSAO >= '"+DTOS(DDATABASE-(MV_PAR04 * 30))+"' "
cQuery += 																			 "AND SD2.D_E_L_E_T_ = '' "
cQuery +=																			 "AND SD2.D2_COD = '" + ALLTRIM(MV_PAR05) + "') "



IF MV_PAR01 == 1 //Cidade
	cQuery += "AND SA1.A1_MUN LIKE ('%"+UPPER(ALLTRIM(MV_PAR02))+"%') " 
	
	If Len(ALLTRIM(MV_PAR03)) > 0
		cQuery += "AND SA1.A1_EST = '" + UPPER(ALLTRIM(MV_PAR03)) + "' "	
	EndIf

ELSEIF MV_PAR01 == 2	 //Estado
	cQuery += "AND SA1.A1_EST = '" + UPPER(ALLTRIM(MV_PAR03)) + "' "
ENDIF	

cQuery += "AND SA1.D_E_L_E_T_ = '' "

If Len(ALLTRIM(mv_par06)) > 0
	cQuery += "AND SA1.A1_GRPVEN IN (" +Alltrim(mv_par06) + ") "
EndIf

cQuery += "ORDER BY SA1.A1_COD , SA1.A1_LOJA"

cQuery := ChangeQuery(cQuery)

//MEMOWRITE("\QUERYSYS\REVENDA.SQL",cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRB',.F.,.T.)

nTotal := 0

//este comando retorna o numero de registros de um Query
TRB->( dbEval( { || ntotal++ },,{|| !Eof() } ))

TRB->(dbGoTop()) 

SetRegua(nTotal)

While !Eof()

	IncRegua()

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Verifica o cancelamento pelo usuario...                             ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif

//            10        20        30        4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23
//  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

   nLin++ // Avanca a linha de impressao

   @ nLin , 001 PSAY TRB->CODIGO
   @ nLin , 008 PSAY TRB->LOJA
   @ nLin , 013 PSAY Left(TRB->NOME,30)
   @ nLin , 045 PSAY Left(ALLTRIM(TRB->ENDERECO),40)
   @ nLin , 086 PSAY Left(TRB->BAIRRO,18)
   @ nLin , 106 PSAY Left(TRB->CIDADE,22)
   @ nLin , 130 PSAY TRB->ESTADO
   @ nLin , 137 PSAY TRB->DDD
   @ nLin , 142 PSAY TRB->TELEFONE
//   @ nLin , 160 SAY IIF(LEN(ALLTRIM(TRB->EMAIL)) > 0,ALLTRIM(TRB->EMAIL),SPACE(45))
   @ nLin , 197 PSAY Left(TRB->CONTATO,17)

	dbSkip() //Avança uma linha 
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

TRB->(DBCLOSEAREA())

Return        


