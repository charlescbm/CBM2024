#INCLUDE "rwmake.ch"

User Function AVISOIMP()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "RELATOAVISO"
Local cPict          := ""
Local titulo       := "CONFERENCIA CEGA"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "CONFCEGA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "AVC001"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RELATOAVISO" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZC"

dbSelectArea("SZC")
dbSetOrder(1)

pergunte(cPerg,.F.)
If (Type("paramixb") == "C")
	mv_par01 := paramixb
	mv_par02 := paramixb
	cDe := mv_par01
	cAte:= mv_par02 
	cPerg := NIL
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FinaliZC a execucao do relatorio...                                 ³
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


Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  02/12/04   º±±
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

dbSelectArea(cString)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

cDe := mv_par01
cAte:= mv_par02 
cCod:= SZC->ZC_COD
SZC->(dbSeek(xFilial("SZC")+cDe,.T.))
while !SZC->(EOF()) .AND. SZC->ZC_cod >= cDe .AND. SZC->ZC_cod <=cAte

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

   nLin := nLin + 1 // Avanca a linha de impressao
   
//   cCod:= ZC_COD

   dbselectarea("SZC")
   dbsetorder(1)
   dbseek(xfilial()+cCod)
   if found()
      while !EOF() .and. cCod == SZC->ZC_COD
        If nLin > 55 
          Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
          nLin := 5
        Endif
         @nLin,0 PSAY "CODIGO: " + ZC_cod
         nLin := nLin + 1
         @nLin,0 PSAY "FORNECEDOR: " + ZC_fornec
         @nLin,40 PSAY "NOME: " + ZC_nome
         nLin := nLin + 1
         @nLin,0 PSAY "N.FISCAL: " + ZC_nfiscal
         @nLin,20 PSAY "SERIE: " + ZC_serie
         @nLin,40 PSAY "EMISSAO: "
         @nLin,50 PSAY ZC_EMISSNF
         nLin := nLin + 1
         @nLin,0 PSAY "CHEGADA: "// + ZC_chegada
         @nLin,9 PSAY ZC_CHEGADA
         @nLin,40 PSAY "SAIDA: " //+ ZC_saida
         @nLin,47 PSAY ZC_SAIDA
         nLin := nLin + 1
         @nLin,0 PSAY REPLICATE("_",131)
         nLin := nLin + 1           
         @nLin,0 PSAY "|" + SPACE(25) + "   ITEM   " + SPACE(25) + "|" + SPACE(05) + "QTD" + SPACE(05) + "|" + space(01) + "UN.MED." + SPACE(01) + "|" + SPACE(10) + "N.LOTE" + SPACE(12) + "|" + SPACE(03) + "VALIDADE" + SPACE(04) + "|"
         nLin := nLin+1
         @nLin,0 PSAY REPLICATE("_",131)
         nLin := nLin+1
         
            dbselectarea("SZD")
            dbsetorder(2)
            dbseek(xfilial()+cCod)
            if !found()
               nlin:= U_Brancos(nlin)
            Else
               nlin:= U_ITEM(nlin)
               nlin:= U_Brancos(nlin)
            eNDiF      
            
            @nLin,0 PSAY "|" + "FALTAS:" + SPACE(53) + "|"
            @nLin,62 PSAY "ACESSORIOS:" + SPACE(57) + "|"
			nLin := nLin + 1
            @nLin,0 PSAY "|" +  SPACE(07) + SPACE(53) + "|"
            @nLin,62 PSAY SPACE(11) + SPACE(57) + "|"
            @nLin,0 PSAY REPLICATE("_",131)          
            nLin ++
            @nLin,0 PSAY "|" + "SOBRAS:" + SPACE(122) + "|"
            nLin := nLin + 1
            @nLin,0 PSAY "|" + SPACE(07) + SPACE(122) + "|"
            @nLin,0 PSAY REPLICATE("_",131)          
            nLin ++
            @nlin,0 PSAY "|" + SPACE(129) + "|"
            nlin++
            @nLin,0 PSAY "|" + "CONFERENTE 1: ______________________________" + SPACE(85) + "|" 
            nLin ++
            @nlin,0 PSAY "|" + SPACE(129) + "|"
            nlin++
            @nLin,0 PSAY "|" + "CONFERENTE 2: ______________________________" + SPACE(85) + "|"            
            nLin ++
            @nlin,0 PSAY "|" + SPACE(129) + "|"
            @nLin,0 PSAY REPLICATE("_",131)                      
            nLin ++
            @nLin,0 PSAY "|" + "Data Emissao: "  
            @nlin,20 PSAY DDATABASE
            @nLin,70 PSAY "Emitido Por: " + cusername
            @nlin,130 PSAY "|"
            nLin ++
            @nlin,0 PSAY "|" + SPACE(129) + "|"
            @nLin,0 PSAY REPLICATE("_",131)                      
            nLin := 80
            dbselectarea("SZC")
            SZC->(dbSkip()) // Avanca o ponteiro do registro no arquivo   
       endDo 
     EndIf
 cCod:= SZC->ZC_COD
Enddo 


User Function Brancos(nlin)
while nlin < 50
            @nLin,0 PSAY "|"+ SPACE(15) + "|" //Codigo
            @nLin,17 PSAY SPACE(44) + "|"     //Descricao
            @nLin,62 PSAY SPACE(13) + "|"     //Qtd
            @nLin,76 PSAY SPACE(09) + "|"     //Un.Med
            @nLin,86 PSAY SPACE(28) + "|"     //N.Lote
            @nLin,115 PSAY SPACE(15) + "|"    //Validade
            nLin := nLin+1              
            @nLin,0 PSAY "|"+ SPACE(15) + "|" //Codigo
            @nLin,17 PSAY SPACE(44) + "|"     //Descricao
            @nLin,62 PSAY SPACE(13) + "|"     //Qtd
            @nLin,76 PSAY SPACE(09) + "|"     //Un.Med
            @nLin,86 PSAY SPACE(28) + "|"     //N.Lote
            @nLin,115 PSAY SPACE(15) + "|"    //Validade
            @nLin,0 PSAY REPLICATE("_",131)
            nLin++
//loop
EndDo            
Return(nlin)

User Function Item(nlin)
while ZD_aviso == cCod
            @nLin,0 PSAY "|"+ ZD_cod +"|"
            @nLin,17 PSAY substr(ZD_descric,1,44) + "|"
            @nLin,62 PSAY SPACE(13) + "|"
            @nLin,76 PSAY SPACE(09) + "|"
            @nLin,86 PSAY SPACE(28) + "|"
            @nLin,115 PSAY SPACE(15) + "|"
            nLin := nLin+1              
            @nLin,0 PSAY "|"+ SPACE(15) + "|"
            @nLin,17 PSAY SPACE(44) + "|"
            @nLin,62 PSAY SPACE(13) + "|"
            @nLin,76 PSAY SPACE(09) + "|"
            @nLin,86 PSAY SPACE(28) + "|"
            @nLin,115 PSAY SPACE(15) + "|"
            @nLin,0 PSAY REPLICATE("_",131)
            nLin++
            dbskip()
EndDo            
Return(nlin)