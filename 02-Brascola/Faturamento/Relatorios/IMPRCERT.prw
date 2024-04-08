#INCLUDE "rwmake.ch"
 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRCERT  ºAutor  ³                    º Data ³             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa que imprime o certificado de qualidade dos produtosº±±
±±º          ³para clientes que o exigem.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³                                                            º±±
±±º          ³Elias Reis - 21.06.06 - Alteracao para o relatorio aglutinarº±±
±±º          ³or produtos dentro de um mesmo lote, somando as quantidades º±±
±±º          ³Elias Reis - 30.08.06 - Alteracao do nome do arquivo temp.  º±±
±±º          ³                        criado com o nome de "RES", e que   º±±
±±º          ³                        estava conflitando com um arquivo   º±±
±±º          ³                        padrao do sistema                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function IMPRCERT(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Certificado de Qualidade"
Local cPict          := ""
Local titulo         := "Certificado de Qualidade"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "CERTQUA" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "CERTQUA" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cPergAux     := ""
Private cString      := ""

dbSelectArea("CBC")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

//Elias
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,)//.T.)

cPergAux:= U_CRIAPERG(cPerg)

wnrel := SetPrint(cString,NomeProg,cPergAux,@titulo,cDesc1,cDesc2,cDesc3,.F.,/*aOrd*/,.T.,Tamanho,,)//.T.)

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

/****************************************************************************************************************/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem
LOCAL cProduto := ""
LOCAL cArqItm  := CriaTrab( NIL , .f. )
LOCAL cArqResul:= CriaTrab( NIL , .f. )
Local nCol     := 6
Local nColAux  := 0

SetRegua(RecCount())

Resume()

dbSelectArea("RESX")
dbGoTop()

While !EOF()

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

//	IndRegua( "RES",cArqItm,"NOTA+SERIE+PRODUTO+ITEM",,,"Ordenando Registros !" )
	
//	IF DBSEEK( CBC->NOTA + CBC->SERIE + CBC->PRODUTO + CBC->ITEM)
	@ nLin, 001 PSAY UPPER("Produto...................: " + "( " + ALLTRIM(RESX->PRODUTO) + " )"  + " - " + ALLTRIM(RESX->DESC))
// ENDIF  

	nLin += 1	

	dbSelectArea("SA7")
	dbSetOrder(1)
	If MsSeek(xFilial()+RESX->CLIENTE+RESX->LOJA+RESX->PRODUTO)
		If Len(AllTrim(SA7->A7_CODCLI)) > 0 
			@ nLin, 001 PSAY UPPER("Cod. Produto no Cliente ..: " + "( " + ALLTRIM(SA7->A7_CODCLI) + " )"  + " - " + ALLTRIM(SA7->A7_DESCCLI)	)
		Else
			@ nLin, 001 PSAY UPPER("Cod. Produto no Cliente ..: N/C")
		EndIf
	Else 		
		@ nLin, 001 PSAY UPPER("Cod. Produto no Cliente ..: N/C")
	EndIf
	
	nLin += 1
	   
	@ nLin, 001 PSAY UPPER("Cliente...................: " + "( " + RESX->CLIENTE + " / " + RESX->LOJA + " ) " + " - " + ALLTRIM(RESX->NOME))
	   
	nLin += 1
	   
	@ nLin, 001 PSAY UPPER("Nota Fiscal...............: " + RESX->NOTA + " / " + RESX->SERIE)
	   
	nLin += 1
	   
	@ nLin, 001 PSAY UPPER("Emissao...................: " + DTOC(RESX->EMISSAO))
	 
	nLin += 1

	@ nLin, 001 PSAY UPPER("Lote......................: " + ALLTRIM(RESX->LOTE)  )
	   
	nLin += 1
	   
	@ nLin, 001 PSAY UPPER("Fabricacao................: " + DTOC(RESX->FABRI)   )

	nLin += 1

	@ nLin, 001 PSAY UPPER("Validade..................: " + DTOC(RESX->DTVALID))
	  	
	nLin += 1
	  	
	@ nLin, 001 PSAY UPPER("Quantidade................: " + ALLTRIM(STR(RESX->QUANT)) + " " + RESX->UM)
	  	
	nLin += 2
	  	
//	@ nLin , 000 PSAY REPLICATE("=",132)
   @ nLin, 000 PSAY __PrtFatLine()
	 	   
	nLin += 1
//						 	 		  1         2         3         4         5         6         7         8         9         1
//                           12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901		
	@ nLin , 001 PSAY UPPER("             Ensaio                              Especificacao                                     Resultado")
		
	nLin += 1
		
// @ nLin , 000 PSAY REPLICATE("=",132)
   @ nLin, 000 PSAY __PrtFatLine()
  
	nLin += 1//2		
   	
	DBSELECTAREA("RESUL")
	
	IndRegua( "RESUL",cArqResul,"NOTA+SERIE+PRODUTO+ITEM+LOTE",,,"Ordenando Registros !" )
	
	IF DBSEEK( RESX->NOTA + RESX->SERIE + RESX->PRODUTO +RESX->ITEM +RESX->LOTE )
	
		WHILE !EOF() .AND. RESUL->NOTA == RESX->NOTA .AND. RESUL->SERIE == RESX->SERIE;
				.AND. RESUL->PRODUTO == RESX->PRODUTO .AND. RESUL->LOTE == RESX->LOTE;
				.AND. RESUL->ITEM == RESX->ITEM
							 
 		   	@ nLin, 001 PSAY  UPPER(ALLTRIM(RESUL->NOME))
				
 		    @ nLin, 050 PSAY UPPER(ALLTRIM(RESUL->ESPEC))
	 		    		   			
 		   	@ nLin, 100 PSAY UPPER(ALLTRIM(RESUL->RESULT))
 		   	 		   	
 		   	nLin := nLin + 2
 		   	
 		   	DBSKIP()
 		 ENDDO
 	ENDIF
	   	
   	
//	@++nLin , 000 PSAY REPLICATE("=",132)
   @++nLin, 000 PSAY __PrtFatLine()

	nColAux 	:= int(132/(73-nLin))
	nResto  	:= 132 - (nColAux * (73-nLin))
	nCol		:= (Len( Repl("-",nResto/2)+"\" ) + 1 ) - nColAux
		
	@++nLin , 000 PSAY Repl("-",nResto/2)+"\"
		
	FOR N1 := nLin to 73//73

		@++nLin , (nCol+=nColAux) PSAY "\"	

		If N1 == 65//65
			@nLin, 17 PSAY UPPER("Juliana Cirilo")   //Fernando: 23/09/13 - Chamado nr.: 4409
		EndIf
		If N1 == 66
			@nLin, 17 PSAY " CRQ XIII 13100830 "     //Fernando: 23/09/13 - Chamado nr.: 4409
		EndIf

	NEXT				
		
   	@++nLin , (nCol+=nColAux) PSAY "\"+Repl("-",nResto/2)
			   	
   	nLin := 75
   	
//   	@ nLin , 000 PSAY REPLICATE("_",132)
  	@ nLin, 000 PSAY __PrtFatLine()
   	
  	nLin += 1
   	
  	@ nLin , 001 PSAY UPPER("Certificado emitido eletronicamente")
   	
  	nLin += 1
   	
  	@ nLin , 001 PSAY "TEL: 0800-7241727 / FAX: (47) 3205-2700"
   	
  	nLin +=1 
   	
  	@ nLin , 001 PSAY "E-MAIL: faleconosco@brascola.com.br"
   	
  	nLin += 1
   	
//		@ nLin , 000 PSAY REPLICATE("_",132)
  	@ nLin, 000 PSAY __PrtThinLine()
   	
  	nLin := 80
  	
  	
	dbSelectArea("RESX")
   dbSkip() // Avanca o ponteiro do registro no arquivo  	

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

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPRCERT  ºAutor  ³Microsiga           º Data ³  06/20/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta funcao resume os dois alias anteriores, CBC e ITEM,   º±±
±±º          ³ para resumir a impressao dos certificados                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Resume()

Local _aRes 		:= {}
Local _nQUANT 		:= 0

aAdd(_aRes,{"NOTA"         ,"C",009,0})
aAdd(_aRes,{"SERIE"        ,"C",003,0})
aAdd(_aRes,{"CLIENTE"      ,"C",008,0})
aAdd(_aRes,{"LOJA"         ,"C",004,0})
aAdd(_aRes,{"PRODUTO"      ,"C",015,0})
aAdd(_aRes,{"ITEM"         ,"C",004,0})
aAdd(_aRes,{"NOME"         ,"C",040,0})
aAdd(_aRes,{"EMISSAO"      ,"D",008,0})
aAdd(_aRes,{"DESC"         ,"C",050,0})
aAdd(_aRes,{"UM"           ,"C",002,0})
aAdd(_aRes,{"LOTE"         ,"C",011,0})
aAdd(_aRes,{"FABRI"        ,"D",008,0})
aAdd(_aRes,{"DTVALID"      ,"D",008,0})
aAdd(_aRes,{"QUANT"        ,"N",014,2})     

_cArqCbc := CriaTrab(_aRes,.T.)

If Select("RESX") > 0
   RESX->(dbCloseArea())
EndIF

dbUseArea( .T.,,_cArqCbc, "RESX", .F., .F. )

dbSelectArea("ITEM")
dbGoTop()
dbSelectArea("CBC")
dbGoTop()

While !Eof()

	dbSelectArea("RESX")
	RecLock("RESX",.T.)
	
	RESX->NOTA		:= CBC->NOTA
	RESX->SERIE		:= CBC->SERIE
	RESX->CLIENTE	:= CBC->CLIENTE
	RESX->LOJA		:= CBC->LOJA
	RESX->PRODUTO	:= CBC->PRODUTO
	RESX->ITEM		:= CBC->ITEM
	RESX->NOME		:= CBC->NOME
	RESX->EMISSAO	:= CBC->EMISSAO
	RESX->DESC		:= ITEM->DESC
	RESX->UM		:= ITEM->UM
	RESX->LOTE		:= ITEM->LOTE
	RESX->FABRI		:= ITEM->FABRI
	RESX->DTVALID	:= ITEM->DTVALID
	
	MsUnlock()

	_nQuant := ITEM->QUANT


	dbSelectArea("ITEM")
	dbSkip()	

	dbSelectArea("CBC")
	dbSkip()

	
	While !Eof() .And.;
			RESX->NOTA		== CBC->NOTA .And.;
			RESX->PRODUTO 	== CBC->PRODUTO .And.;
			RESX->LOTE 		== ITEM->LOTE 

		_nQuant += ITEM->QUANT

		dbSelectArea("CBC")
		dbSkip()
		dbSelectArea("ITEM")
		dbSkip()	

	EndDo                               	

	dbSelectArea("RESX")
	RecLock("RESX",.F.)
	RESX->QUANT		:= _nQuant
	MsUnlock()     
	
	dbSelectArea("CBC")	
	
EndDo

Return