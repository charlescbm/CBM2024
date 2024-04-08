#INCLUDE "RWMAKE.CH"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF


User Function Rec_TXT()
***********************
// Define Variaveis Locais (Basicas)
Local cString:="SRA"        // alias do arquivo principal (Base)

// Define Variaveis Private(Basicas)
Private aReturn  := {"Zebrado", 1,"Administrativo", 2, 2, 1, "",1 }
Private nomeprog := "REC_TXT"
Private aLinha   := { },nLastKey := 0
Private cPerg    := U_CRIAPERG("GERTXT")

// Define Variaveis Private(Programa)
Private Titulo := "GERA ARQUIVO TEXTO DE RECIBOS DE PAGAMENTOS"
Private cAlias:=""
Private cLinha:=""
Private cNomPrv:=""
Private aLayC:={}
Private nControlTXT:=0

wnrel:="GERTXT"        //Nome Default do relatorio em Disco

Pergunte("GERTXT",.t.)

dDataRef   := mv_par01  //Data de Referencia para a impressao
cCcDe      := mv_par02	//Centro de Custo De
cCcAte     := mv_par03	//Centro de Custo Ate
cMatDe     := mv_par04	//Matricula Des
cMatAte    := mv_par05	//Matricula Ate
cNomDe     := mv_par06	//Nome De
cNomAte    := mv_par07	//Nome Ate
ChapaDe    := mv_par08	//Chapa De
ChapaAte   := mv_par09	//Chapa Ate
cSituacao  := mv_par10  //Situacoes a Imprimir
cCategoria := mv_par11  //Categorias a Imprimir
cFilialDe  := mv_par12  //filial de
cFilialAte := mv_par13  //filial ate
//cFilialAte := mv_par14  //local de gravação do arquivo

If aReturn[5]==1
	li:= 0
EndIf

RptStatus({|lEnd| RGERTXT()},Titulo)  // Chamada do Relatorio

Return NIL


Static Function RGERTXT()
*************************
// Define Variaveis Locais (Basicas)
Local aOrdBag     := {}
Local cMesAnoRef  := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)
Local cMesArqRef  := cMesAnoRef
Local cArqMov     := ""
Local aCodBenef   := {}
Local nMes, nAno
Local nX

Private tamanho  := "M"
Private limite	 := 132
Private cAliasMov:= ""
Private cDtPago
Private cPict1   := "@E 999,999,999.99"
Private cPict2   := "@E 99,999,999.99"
Private cPict3   := "@E 999,999.99"
If MsDecimais(1) == 0
	cPict1:= "@E 99,999,999,999"
	cPict2:= "@E 9,999,999,999"
	cPict3:= "@E 99,999,999"
Endif


// Verifica se existe o arquivo de fechamento do mes informado

//If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, @dDataRef , NIL ,lTerminal )
//	Return( IF( lTerminal , cHtml , NIL ) )
//Endif

dbSelectArea( "SRA")
dbSetOrder(8) // FILIAL+CENTROCUSTO+NOME
dbGoTop()

cInicio := "SRA->RA_MAT"
cFim    := cMatAte //&(cInicio)

dbSelectArea("SRA")

SetRegua(RecCount())	// Total de elementos da regua

TOTVENC:= TOTDESC:= FLAG:= CHAVE := 0

Desc_Fil := Desc_End := DESC_CC:= DESC_FUNC:= ""
DESC_MSG1:= DESC_MSG2:= DESC_MSG3:= Space(01)
cFilialAnt := "  "
Vez        := 0
OrdemZ     := 0

While SRA->( !Eof()) // .And. &cInicio <= cFim )
	
	IncRegua()  // Anda a regua
	
	//Filtra FILIAIS
	If (SRA->RA_FILIAL < cFilialDe) .Or. (SRA->RA_FILIAL > cFilialAte)
		SRA->(dbSkip(1))
		Loop
	Endif
	
	// Consiste Parametrizacao do Intervalo de Impressao
	
	If (SRA->RA_CHAPA < ChapaDe)   .Or. (SRA->Ra_CHAPa > ChapaAte)   .Or. ;
		(SRA->RA_NOME < cNomDe)     .Or. (SRA->Ra_NOME > cNomAte)     .Or. ;
		(SRA->RA_MAT < cMatDe)      .Or. (SRA->Ra_MAT > cMatAte)      .Or. ;
		(SRA->RA_CC < cCcDe)        .Or. (SRA->Ra_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf
	
	// Verifica Data Demissao
	cSitFunc := SRA->RA_SITFOLH
	dDtPesqAf:= CTOD("01/" + Left(cMesAnoRef,2) + "/" + Right(cMesAnoRef,4),"DDMMYY")
	If cSitFunc == "D" .And. (!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA) > MesAno(dDtPesqAf))
		cSitFunc := " "
	Endif
	
	// Consiste situacao e categoria dos funcionarios
	If !(cSitFunc $ cSituacao) .OR.  !(SRA->RA_CATFUNC $ cCategoria)
		dbSkip()
		Loop
	Endif
	If cSitFunc $ "D" .And. Mesano(SRA->RA_DEMISSA) # Mesano(dDataRef)
		dbSkip()
		Loop
	Endif
	
	DbSelectArea("SRC")
	DbSetOrder(1)
	DbSeek(SRA->RA_FILIAL+SRA->RA_MAT) //XFILIAL("SRA")
	If !Found()
		DbSelectArea("SRA")
		DbSkip()
		Loop
	EndIf
	
	lverif:=.f.
	While !Eof() .And. SRA->RA_FILIAL == SRC->RC_FILIAL .AND. SRC->RC_MAT==SRA->RA_MAT
		If !(SRC->RC_PD$"706-721-731-732-743")
			DbSkip()
			Loop
		EndIf
		DbSelectArea("SRV")
		DbSetOrder(1)
		DbSeek(xFilial("SRV")+SRC->RC_PD)
		If !(RV_TIPOCOD$"1-2-3")
			DbSelectArea("SRC")
			DbSkip()
			Loop
		EndIf
		lverif:=.t.
		DbSelectArea("SRC")
		DbSkip()
	EndDo
	
	If !lverif
		DbSelectArea("SRA")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRA")
	
	GeraTXT()
	
	dbSkip()
EndDo

//REGISTRO - final
aLayC:= {}
aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
cLINHA := ""
For ii := 1 to Len(aLayC)
	cLINHA := cLINHA + aLayC[ii]
Next

If fWrite(cALIAS, cLINHA, Len(cLINHA)) <> Len(cLINHA)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		fClose(cALIAS)
		//Exit
	Endif
Endif

fClose(cALIAS)


// Termino do relatorio
dbSelectArea("SRA")
SET FILTER TO
RetIndex("SRA")

If !(Type("cArqNtx") == "U")
	fErase(cArqNtx + OrdBagExt())
Endif

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return


Static Function GeraTXT()
*************************
If nControlTXT==0

	//para rodar nas estacoes
//	cNOMPRV := "HOLERITE\"+StrZero(Month(dDataRef),2)+SubStr(Str(Year(dDataRef),4),3,2)+".TXT"
	cNOMPRV := alltrim(mv_par14)+StrZero(Month(dDataRef),2)+SubStr(Str(Year(dDataRef),4),3,2)+".TXT"
	
	//para rodar no servidor
	//cNOMPRV := "E:\PROTHEUS8\PROTHEUS_DATA\HOLERITE\"+StrZero(Month(dDataRef),2)+SubStr(Str(Year(dDataRef),4),3,2)+".TXT"
	
	cALIAS := fCreate(cNOMPRV)
	If cALIAS == -1
		MsgBox("Nao foi possivel criar arquivo TXT!","Atencao!","STOP")
		Return
	Endif
	
	Do Case
		Case Month(dDataRef)==1
			cMesAno:="  Janeiro/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==2
			cMesAno:="Fevereiro/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==3
			cMesAno:="    Marco/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==4
			cMesAno:="    Abril/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==5
			cMesAno:="     Maio/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==6
			cMesAno:="    Junho/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==7
			cMesAno:="    Julho/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==8
			cMesAno:="   Agosto/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==9
			cMesAno:=" Setembro/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==10
			cMesAno:="  Outubro/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==11
			cMesAno:=" Novembro/"+StrZero(Year(dDataRef),4)
		Case Month(dDataRef)==12
			cMesAno:=" Dezembro/"+StrZero(Year(dDataRef),4)
	EndCase
	
	//REGISTRO-0
	aLayC:= {}
	aadd(aLayC, "0")                                       // fixo 0
	aadd(aLayC, SUBSTR(SM0->M0_NOMECOM,1,40) )                          // empresa  x(40)
	aadd(aLayC, SUBSTR(SM0->M0_CODFIL,1,2))                            // filial  x(2)
	aadd(aLayC, SUBSTR(SM0->M0_CGC,1,14))                               // CGC  x(14)
	aadd(aLayC, SUBSTR(cMesAno,1,14))                                   // mes ano  x(14)
	aadd(aLayC, Space(100))                                // filler  x(100)
	aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
	cLINHA := ""
	For ii := 1 to Len(aLayC)
		cLINHA := cLINHA + aLayC[ii]
	Next
	fWrite(cALIAS, cLINHA, Len(cLINHA))
	
	nControlTXT:=1
EndIf


DbSelectArea("CTT")
DbSetOrder(1)
DbSeek(xFilial("CTT")+SRA->RA_CC)

DbSelectArea("SRJ")
DbSetOrder(1)
DbSeek(xFilial("SRJ")+SRA->RA_CODFUNC)

//REGISTRO-1
aLayC:= {}
aadd(aLayC, "1")                                       //fixo 1
aadd(aLayC, SRA->RA_MAT)                               //matricula x(6)
aadd(aLayC, SubStr(SRA->RA_NOME,1,30))                   //nome x(30)
aadd(aLayC, StrZero(SRA->RA_SALARIO*100,12))           //salario 9(10)v99
aadd(aLayC, SRA->RA_DEPSF)                             //desp sal.familia  x(2)
aadd(aLayC, SRA->RA_DEPIR)                             //desp ir  x(2)
aadd(aLayC, SRA->RA_CC)                                // centro custo  x(9)
aadd(aLayC, SubStr(CTT->CTT_DESC01,1,25))              //descr.cc  x(25)
aadd(aLayC, SubStr(SRJ->RJ_DESC,1,20))                 //descr.funcao  x(20)
aadd(aLayC, SubStr(SRA->RA_BCDEPSA,1,3))               //banco  x(3)
aadd(aLayC, SubStr(SRA->RA_BCDEPSA,4,5))               //agencia  x(5)
aadd(aLayC, SRA->RA_CTDEPSA)                           //cta corr  x(12)
aadd(aLayC, SPACE(100))                                //filler  x(100)
aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
cLINHA := ""
For ii := 1 to Len(aLayC)
	cLINHA := cLINHA + aLayC[ii]
Next
fWrite(cALIAS, cLINHA, Len(cLINHA))


//REGISTRO-2  (Proventos)
DbSelectArea("SRC")
DbSetOrder(1)
DbSeek(SRA->RA_FILIAL+SRA->RA_MAT) //SRC
nTotProv:=0

While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT
	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRC->RC_PD)
	If RV_TIPOCOD<>"1"
		DbSelectArea("SRC")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRC")
	
	nTotRcHoras:= nTotRcValor:= 0
	
	While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT .And. SRC->RC_PD==SRV->RV_COD
		nTotRcHoras+= SRC->RC_HORAS
		nTotRcValor+= SRC->RC_VALOR
		
		nTotProv+= SRC->RC_VALOR
		
		DbSelectArea("SRC")
		DbSkip()
	EndDo
	
	aLayC:= {}
	aadd(aLayC, "2")                                       //fixo 2
	aadd(aLayC, SRV->RV_COD)                               //cod provento  x(3)
	aadd(aLayC, SubStr(SRV->RV_DESC,1,20))                 //descr. provento  x(20)
	aadd(aLayC, StrZero(nTotRcHoras*100,6))                //ref. provento  9(4)v99
	aadd(aLayC, StrZero(nTotRcValor*100,12))               //val. provento  9(10)v99
	aadd(aLayC, SPACE(100))                                //filler  x(150)
	aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
	cLINHA := ""
	For ii := 1 to Len(aLayC)
		cLINHA := cLINHA + aLayC[ii]
	Next
	fWrite(cALIAS, cLINHA, Len(cLINHA))
	
	//   nTotProv+= SRC->RC_VALOR
	
	//   DbSelectArea("SRC")
	//   DbSkip()
EndDo


//REGISTRO-3  (Descontos)
DbSelectArea("SRC")
DbSetOrder(1)
DbSeek(SRA->RA_FILIAL+SRA->RA_MAT) //SRA
nTotDesc:=0

While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT
	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRC->RC_PD)
	
	If RV_TIPOCOD<>"2"
		DbSelectArea("SRC")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRC")
	
	nTotRcHoras:= nTotRcValor:= 0
	
	While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT .And. SRC->RC_PD==SRV->RV_COD
		nTotRcHoras+= SRC->RC_HORAS
		nTotRcValor+= SRC->RC_VALOR
		
		nTotDesc+= SRC->RC_VALOR
		
		DbSelectArea("SRC")
		DbSkip()
	EndDo
	
	aLayC:= {}
	aadd(aLayC, "3")                                      //fixo 3
	aadd(aLayC, SRV->RV_COD)                              //cod desconto  x(3)
	aadd(aLayC, SubStr(SRV->RV_DESC,1,20))                //descr. desconto  x(20)
	aadd(aLayC, StrZero(nTotRcHoras*100,6))               //ref. desconto  9(4)v99
	aadd(aLayC, StrZero(nTotRcValor*100,12))              //val. desconto  9(10)v99
	aadd(aLayC, SPACE(100))                               //filler x(150)
	aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
	cLINHA := ""
	For ii := 1 to Len(aLayC)
		cLINHA := cLINHA + aLayC[ii]
	Next
	fWrite(cALIAS, cLINHA, Len(cLINHA))
	
	// nTotDesc+= SRC->RC_VALOR
	
	// DbSelectArea("SRC")
	// DbSkip()
EndDo


//REGISTRO-4  (Base)
DbSelectArea("SRC")
DbSetOrder(1)
DbSeek(SRA->RA_FILIAL+SRA->RA_MAT) //SRC

While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT
	If !(SRC->RC_PD$"706-721-731-732")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRV")
	DbSetOrder(1)
	DbSeek(xFilial("SRV")+SRC->RC_PD)
	If RV_TIPOCOD<>"3"
		DbSelectArea("SRC")
		DbSkip()
		Loop
	EndIf
	
	DbSelectArea("SRC")
	
	nTotRcHoras:= nTotRcValor:= 0
	
	While !Eof() .And. SRC->RC_MAT==SRA->RA_MAT .And. SRC->RC_PD==SRV->RV_COD
		If !(SRC->RC_PD$"706-721-731-732")
			DbSkip()
			Loop
		EndIf
		
		nTotRcHoras+= SRC->RC_HORAS
		nTotRcValor+= SRC->RC_VALOR
		
		DbSelectArea("SRC")
		DbSkip()
	EndDo
	
	aLayC:= {}
	aadd(aLayC, "4")                                       //fixo 4
	aadd(aLayC, SRV->RV_COD)                               //cod base  x(3)
	aadd(aLayC, SubStr(SRV->RV_DESC,1,20))                 //descr. base  x(20)
	aadd(aLayC, StrZero(nTotRcHoras*100,6))                //ref. base  9(4)v99
	aadd(aLayC, StrZero(nTotRcValor*100,12))               //val. base  9(10)v99
	aadd(aLayC, SPACE(100))                                //filler x(150)
	aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
	cLINHA := ""
	For ii := 1 to Len(aLayC)
		cLINHA := cLINHA + aLayC[ii]
	Next
	fWrite(cALIAS, cLINHA, Len(cLINHA))
	
	//DbSelectArea("SRC")
	// DbSkip()
EndDo


//REGISTRO-5 (Mensagens)
aLayC:= {}
aadd(aLayC, "5")                                       //fixo 5
DbSelectArea("SRX")
DbSetOrder(1)
DbSeek(xFilial("SRX")+"06")

cMensagem1:=Space(30)
cMensagem2:=Space(30)
cMensagem3:=Space(30)

If Found()
	nCont:=0
	While !Eof() .And. SRX->RX_TIP=="06"
		nCont++
		If nCont==1
			cMensagem1:=SRX->RX_TXT
		ElseIf nCont==2
			cMensagem2:=SRX->RX_TXT
		ElseIf nCont==3
			cMensagem3:=SRX->RX_TXT
		EndIf
		DbSkip()
	EndDo
EndIf

aadd(aLayC, SubStr(cMensagem1,1,30))                   //mensagem 1  x(30)
aadd(aLayC, SubStr(cMensagem2,1,30))                   //mensagem 2  x(30)
aadd(aLayC, SubStr(cMensagem3,1,30))                   //mensagem 3  x(30)
//aadd(aLayC, IIf(Month(SRA->RA_NASC)==Month(dDataRef),"FELIZ ANIVERSARIO!!!"+Space(10) ,Space(30)) )                   //mensagem 4  x(30)  
//Fernando: 10/07/13
aadd(aLayC, IIf(Month(SRA->RA_NASC)==Month(dDataRef),"A BRASCOLA DESEJA A VOCÊ UM FELIZ ANIVERSÁRIO!" ,Space(30)) )     //mensagem 4  x(30)  
aadd(aLayC, SPACE(100))                                //filler  x(100)
aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
cLINHA := ""
For ii := 1 to Len(aLayC)
	cLINHA := cLINHA + aLayC[ii]
Next
fWrite(cALIAS, cLINHA, Len(cLINHA))


//REGISTRO-6 (Totais)
aLayC:= {}
aadd(aLayC, "6")                                       //fixo 6
aadd(aLayC, StrZero(nTotProv*100,12))                  //Total Proventos  9(10)v99
aadd(aLayC, StrZero(nTotDesc*100,12))                  //Total Descontos  9(10)v99
aadd(aLayC, StrZero((nTotProv-nTotDesc)*100,12))       //Total Liquido    9(10)v99
aadd(aLayC, SPACE(150))                                //filler  x(100)
aadd(aLayC, Chr(13)+Chr(10))  //FIM DA LINHA
cLINHA := ""
For ii := 1 to Len(aLayC)
	cLINHA := cLINHA + aLayC[ii]
Next
fWrite(cALIAS, cLINHA, Len(cLINHA))

DbSelectArea("SRA")

Return