#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TbiConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±³Fun‡…o    ³Bolbrad   º Autor ³ Microsiga			  º Data ³ 29/03/99   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡…o ³Emite boleto HSBC										      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico para De Nadai								      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BOLHSBC()
#INCLUDE "RWMAKE.CH"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  RFINR02 ³ Autor ³                       ³ Data ³ 01/08/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO HSBC COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

LOCAL   nOpc := 0
PRIVATE Exec := .F.
//
cPerg        := U_CriaPerg("PFIR10")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ValidPerg()
//
If !Pergunte(cPerg,.T.)
	Return()
EndIf
//
CRIA_MV()
//
PRIVATE nCB1Linha	:= GETMV("PV_BOL_LI1") //14.5
PRIVATE nCB2Linha	:= GETMV("PV_BOL_LI2") //26.1
Private nCBColuna	:= GETMV("PV_BOL_COL") //1.3
Private nCBLargura	:= GETMV("PV_BOL_LAR") //0.0280
Private nCBAltura	:= GETMV("PV_BOL_ALT") //1.4
//
DbselectArea("SE1")
DbSetOrder(1)
//
Processa({|lEnd|MontaRel()})
//
Return Nil
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MontaRel()   ³Descri‡ão³Montagem e Impressao de boleto Gra- ³±±
±±³          ³             ³         ³fico do Banco Itau.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel()
LOCAL   oPrint
LOCAL   n := 0
LOCAL aBitmap := "\SIGAADV\ITAU.BMP"

LOCAL aDadosEmp    := {	AllTrim(SM0->M0_NOMECOM)                                                   ,; //[1]Nome da Empresa
SM0->M0_ENDCOB                                                              ,; //[2]Endereço
AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
"PABX/FAX: "+SM0->M0_TEL                                                    ,; //[5]Telefones
"C.N.P.J.: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
Subs(SM0->M0_CGC,13,2)                                                     ,; //[6]CGC
"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {} //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

// "Após o vencimento cobrar multa de R$ "

LOCAL i            := 1
LOCAL CB_RN_NN     := {}
LOCAL nRec         := 0
LOCAL _nVlrAbat    := 0
LOCAL cParcela	   := ""

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página
//

cSQLT    := ""

cSQLT+= " SELECT * "
cSQLT+= " FROM "+RetSQLName("SE1")
cSQLT+= " WHERE  D_E_L_E_T_ <> '*' "
cSQLT+= " AND E1_NUMBOR BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"'"
cSQLT+= " ORDER BY E1_NUMBOR,E1_NUM"
cSQLT:= ChangeQuery(cSQLT)
TCQUERY cSQLT new alias "ARQTRB"


TCSetField("ARQTRB", 'E1_VALOR', 'N', 14,	2)


//
Do While !EOF()
	/*
	IF EMPTY(E1_NUMBCO)	.OR. SUBSTR(ALLTRIM(E1_NUMBCO),1,3) <> "109"
	//
	IF !MsgBox("O título ("+E1_PREFIXO+"/"+E1_NUM+"-"+E1_PARCELA+") não gerou um Boleto Itaú préviamente. Deseja Imprimir o Boleto Itaú?", "Impressão de Boleto ITAÚ", "YESNO")
	DBSKIP()
	LOOP
	ENDIF
	//
	ENDIF
	//
	*/
	
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+ARQTRB->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	//
	/*       RODOLFO
	DO CASE
	CASE ARQTRB->E1_PARCELA == "A"
	cParcela := "1"
	CASE ARQTRB->E1_PARCELA == "B"
	cParcela := "2"
	CASE ARQTRB->E1_PARCELA == "C"
	cParcela := "3"
	CASE ARQTRB->E1_PARCELA == "D"
	cParcela := "4"
	CASE ARQTRB->E1_PARCELA == "E"
	cParcela := "5"
	CASE ARQTRB->E1_PARCELA == "F"
	cParcela := "6"
	CASE ARQTRB->E1_PARCELA == "G"
	cParcela := "7"
	CASE ARQTRB->E1_PARCELA == "H"
	cParcela := "8"
	CASE ARQTRB->E1_PARCELA == "I"
	cParcela := "9"
	OTHERWISE
	cParcela := "0"
	ENDCASE
	*/
	//
	IF EMPTY(ARQTRB->E1_PARCELA)
		cParcela:= "0"
	ELSE
		cParcela:= alltrim(ARQTRB->E1_PARCELA)
	ENDIF
	
	_cNossoNum := cFilant + substr((strzero(Val(Alltrim(ARQTRB->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela
	//
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+ARQTRB->E1_CLIENTE+ARQTRB->E1_LOJA,.T.)
	//
	
	//	substr(strzero(val(cConta),12),1,11)		,; // [4]Conta Corrente
	//	substr(strzero(val(cConta),12),12,1)  		,; // [5]Dígito da conta corrente
	
	
	DbSelectArea("ARQTRB")
	//
	cConta := StrTran(SA6->A6_NUMCON,"-","")
	cConta := StrTran(cConta,".","")
	
	aDadosBanco  := {"341"           		,; // [1]Numero do Banco
	"Banco Itaú S.A."      ,; // [2]Nome do Banco
	strzero(val(sa6->a6_agencia),4)                 	,; // [3]Agência
	substr(strzero(val(cConta),6),1,5)		,; // [4]Conta Corrente
	substr(strzero(val(cConta),6),6,1)  		,; // [5]Dígito da conta corrente
	"109"                  }  // [6]Codigo da Carteira
	//
	
	
	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)                            ,;     // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;     // [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;     // [3]Endereço
		AllTrim(SA1->A1_MUN )                             ,;     // [4]Cidade
		SA1->A1_EST                                       ,;     // [5]Estado
		SA1->A1_CEP                                       ,;     // [6]CEP
		SA1->A1_CGC									  }       // [7]CGC
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)                               ,;   // [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   // [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   // [3]Endereço
		AllTrim(SA1->A1_MUNC)	                              ,;   // [4]Cidade
		SA1->A1_ESTC	                                      ,;   // [5]Estado
		SA1->A1_CEPC                                         ,;   // [6]CEP
		SA1->A1_CGC										   }    // [7]CGC
	Endif
	
	//If aMarked[i]
	_nVlrAbat   :=  SomaAbat(ARQTRB->E1_PREFIXO,ARQTRB->E1_NUM,ARQTRB->E1_PARCELA,"R",1,,ARQTRB->E1_CLIENTE,ARQTRB->E1_LOJA)
	
   //	VRD1:=STOD(ARQTRB->E1_VENCTO)
	
	VRD1:=STOD(ARQTRB->E1_VENCREA)
	VRD2:=STOD(ARQTRB->E1_EMISSAO)
	
	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cNossoNum),(ARQTRB->E1_VALOR -_nVlrAbat),Datavalida(VRD1,.T.))
	
	aDadosTit    := {AllTrim(ARQTRB->E1_NUM)+AllTrim(ARQTRB->E1_PARCELA)						,;  // [1] Número do título
	VRD2                             					,;  // [2] Data da emissão do título
	Date()                                  					,;  // [3] Data da emissão do boleto
	Datavalida(VRD1,.T.)                  					,;  // [4] Data do vencimento
	(ARQTRB->E1_SALDO - _nVlrAbat)                  					,;  // [5] Valor do título
	CB_RN_NN[3]                             					,;  // [6] Nosso número (Ver fórmula para calculo)
	ARQTRB->E1_PREFIXO                               					,;  // [7] Prefixo da NF
	ARQTRB->E1_TIPO	                               						}  // [8] Tipo do Titulo
	//
	
	IF SUBSTR(ARQTRB->E1_TIPO,1,2) = 'AL'
		aBolText     := {"Apos o vencimento, multa equivalente à 2%, mais juros de mora de 1% ao mes (pro-rata).",;
		"Aplicar correção monetária pelo IGPM caso o pagamento ocorra após o 30o. (trigésimo)",;
		"dia contado do vencimento.",ALLTRIM(ARQTRB->E1_OBSERV)}
	ELSEIF SUBSTR(ARQTRB->E1_TIPO,1,2) = 'IU'
		aBolText     := {"",;
		"APÓS O VENCIMENTO MORA DIARIA DE R$ ",;
		ALLTRIM(ARQTRB->E1_OBSERV),""} //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}
	ELSE
		aBolText     := {"",;
		"APÓS O VENCIMENTO MORA DIARIA DE R$ ",;
		"",""} //"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}
	ENDIF
	
	Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
	n := n + 1
	
	DBSELECTAREA("SE1")
	DBSETORDER(1)
	IF DBSEEK(XFILIAL("SE1")+ARQTRB->E1_PREFIXO+ARQTRB->E1_NUM+ARQTRB->E1_PARCELA+ARQTRB->E1_TIPO)
		reclock('se1',.f.)
		SE1->E1_NUMBCO:=_cNossoNum
		msunlock()
	ENDIF
	
	DBSELECTAREA("ARQTRB")
	dbSkip()
	IncProc()
	i := i + 1
EndDo
//
oPrint:EndPage()     // Finaliza a página
oPrint:Preview()     // Visualiza antes de imprimir

DBSELECTAREA("ARQTRB")
DBCLOSEAREA()

Return nil
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Impress      ³Descri‡ão³Impressao de Boleto Grafico do Banco³±±
±±³          ³             ³         ³Itau.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aBitmap,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,CB_RN_NN)
LOCAL _nTxper := GETMV("MV_TXPER")
LOCAL oFont2n
LOCAL oFont8
LOCAL oFont9
LOCAL oFont10
LOCAL oFont15n
LOCAL oFont16
LOCAL oFont16n
LOCAL oFont14n
LOCAL oFont24
LOCAL i := 0
LOCAL aCoords1 := {0150,1900,0550,2300}
LOCAL aCoords2 := {0450,1050,0550,1900}
LOCAL aCoords3 := {0710,1900,0810,2300}
LOCAL aCoords4 := {0980,1900,1050,2300}
LOCAL aCoords5 := {1330,1900,1400,2300}
LOCAL aCoords6 := {2080,1900,2180,2300}     // 2000 - 2100
LOCAL aCoords7 := {2350,1900,2420,2300}     // 2270 - 2340
LOCAL aCoords8 := {2700,1900,2770,2300}     // 2620 - 2690
LOCAL oBrush
//
aBmp 	:= "\SIGAADV\ITAU.BMP"
aBmp2 	:= "\SIGAADV\LOGO.BMP"
//
//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
//
oFont2n := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont8  := TFont():New("Arial",9,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Arial",9,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n:= TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n:= TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
//
oBrush := TBrush():New("",5)//4
//
oPrint:StartPage()   // Inicia uma nova página
//
/*   ZANARDO
oPrint:FillRect(aCoords1,oBrush)
oPrint:FillRect(aCoords2,oBrush)
oPrint:FillRect(aCoords3,oBrush)
oPrint:FillRect(aCoords4,oBrush)
oPrint:FillRect(aCoords5,oBrush)
oPrint:FillRect(aCoords6,oBrush)
oPrint:FillRect(aCoords7,oBrush)
oPrint:FillRect(aCoords8,oBrush)
*/
//
// LOGOTIPO
If File(aBmp2)
	oPrint:SayBitmap( 0040,0100,aBmp2,0175,0100 )
Else
	oPrint:Say  (0084,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf

IF SUBSTR(ARQTRB->E1_TIPO,1,2) $ 'AL*IU'
	aDadosEmp[6]:="C.N.P.J.: 61.105.060/0001-63"
ENDIF
//
oPrint:Say  (0084,1860,"Comprovante de Entrega",oFont10)
oPrint:Line (0150,100,0150,2300)
oPrint:Say  (0150,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0150,1060,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0150,1510,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0200,100 ,aDadosEmp[1]                                 	,oFont10) //Nome + CNPJ
oPrint:Say  (0200,1090,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
oPrint:Say  (0200,1510,(alltrim(aDadosTit[7]))+aDadosTit[1]	         ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (0250,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (0250,1060,"Vencimento"                                     ,oFont8)
oPrint:Say  (0250,1510,"Valor do Documento"                          	,oFont8)
oPrint:Say  (0300,100 ,aDatSacado[1]                                    ,oFont10)	//Nome
oPrint:Say  (0300,1090,DTOC(aDadosTit[4])                               ,oFont10,100)
oPrint:Say  (0300,1550,AllTrim(Transform(ARQTRB->E1_VALOR,"@E 999,999,999.99"))   ,oFont10)
if cFilant == "06" .or. cFilant == "18"
	oPrint:Say  (0370,0100,"Recebi(emos) o bloqueto/título com"  		,oFont10)
	oPrint:Say  (0410,0100,"as características acima."             		,oFont10)
	oPrint:Say  (0450,0100,"Favor devolver assinado juntamente"  		,oFont10)
	oPrint:Say  (0490,0100,"com o canhoto da Nota Fiscal." 				,oFont10)
else
	oPrint:Say  (0400,0100,"Até o Vencimento preferencialmente no Banco Itaú."                 ,oFont10)
	oPrint:Say  (0450,0100,"Após o Vencimento somente no Banco Itaú."           		,oFont10)
endif
oPrint:Say  (0350,1060,"Data"                                           ,oFont8)
oPrint:Say  (0350,1410,"Assinatura"                                 	,oFont8)
oPrint:Say  (0450,1060,"Data"                                           ,oFont8)
oPrint:Say  (0450,1410,"Entregador"                                 	,oFont8)
//
oPrint:Line (0250, 100,0250,1900 )
oPrint:Line (0350, 100,0350,1900 )
oPrint:Line (0450,1050,0450,1900 )
oPrint:Line (0550, 100,0550,2300 )
//
oPrint:Line (0550,1050,0150,1050 )
oPrint:Line (0550,1400,0350,1400 )
oPrint:Line (0350,1500,0150,1500 )
oPrint:Line (0550,1900,0150,1900 )
//
oPrint:Say  (0165,1910,"(  ) Mudou-se"                                	,oFont8)
oPrint:Say  (0205,1910,"(  ) Ausente"                                    ,oFont8)
oPrint:Say  (0245,1910,"(  ) Não existe nº indicado"                  	,oFont8)
oPrint:Say  (0285,1910,"(  ) Recusado"                                	,oFont8)
oPrint:Say  (0325,1910,"(  ) Não procurado"                              ,oFont8)
oPrint:Say  (0365,1910,"(  ) Endereço insuficiente"                  	,oFont8)
oPrint:Say  (0405,1910,"(  ) Desconhecido"                            	,oFont8)
oPrint:Say  (0445,1910,"(  ) Falecido"                                   ,oFont8)
oPrint:Say  (0485,1910,"(  ) Outros(anotar no verso)"                  	,oFont8)
//
For i := 100 to 2300 step 50
	oPrint:Line( 0590, i, 0590, i+30)
Next i
//
oPrint:Line (0710,100,0710,2300)
oPrint:Line (0710,550,0610, 550)
oPrint:Line (0710,800,0610, 800)
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 0600,0100,aBmp,0100,0100 )
	oPrint:Say  (0640,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (0644,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco
EndIf
//
oPrint:Say  (0618,569,"341-7",oFont24 )	// [1]Numero do Banco
oPrint:Say  (0644,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
//VAR1:=DTOC(ARQTRB->E1_VENCTO)
///VAR1:=ARQTRB->E1_VENCTO

VAR1:=ARQTRB->E1_VENCREA
oPrint:Line (0810,100,0810,2300 )
oPrint:Line (0910,100,0910,2300 )
oPrint:Line (0980,100,0980,2300 )
oPrint:Line (1050,100,1050,2300 )
//
oPrint:Line (0910,500,1050,500)
oPrint:Line (0980,750,1050,750)
oPrint:Line (0910,1000,1050,1000)
oPrint:Line (0910,1350,0980,1350)
oPrint:Line (0910,1550,1050,1550)
//
oPrint:Say  (0710,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (0730,400 ,"Até o Vencimento preferencialmente no Banco Itaú."        ,oFont9)
oPrint:Say  (0770,400 ,"Após o Vencimento somente no Banco Itaú."        ,oFont9)

//
oPrint:Say  (0710,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (0750,2010,DTOC(aDadosTit[4])                               ,oFont10)
//oPrint:Say  (0710,1910,"Nosso Número"                                   ,oFont8)
//oPrint:Say  (0740,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)

//
oPrint:Say  (0810,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (0850,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (0810,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (0850,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (0910,100 ,"Data do Documento"                              ,oFont8)
//oPrint:Say  (0940,100 ,DTOC(ARQTRB->E1_EMISSAO)                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
oPrint:Say  (0940,100 ,ARQTRB->E1_EMISSAO                               ,oFont10) // Emissao do Titulo (E1_EMISSAO)
//
oPrint:Say  (0910,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (0940,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (0910,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (0940,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (0910,1355,"Aceite"                                         ,oFont8)
oPrint:Say  (0940,1455,"N"                                             ,oFont10)
//
oPrint:Say  (0910,1555,"Data do Processamento"                          ,oFont8)
oPrint:Say  (0940,1655,DTOC(DATE())                               ,oFont10) // Data impressao
//
oPrint:Say  (0910,1910,"Nosso Número"                                   ,oFont8)
oPrint:Say  (0940,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)
//
oPrint:Say  (0980,100 ,"Uso do Banco"                                   ,oFont8)
//
oPrint:Say  (0980,505 ,"Carteira"                                       ,oFont8)
oPrint:Say  (1010,555 ,aDadosBanco[6]                                  	,oFont10)
//
oPrint:Say  (0980,755 ,"Espécie"                                        ,oFont8)
oPrint:Say  (1010,805 ,"R$"                                             ,oFont10)
//
oPrint:Say  (0980,1005,"Quantidade"                                     ,oFont8)
oPrint:Say  (0980,1555,"Valor"                                          ,oFont8)
//
oPrint:Say  (0980,1910,"Valor do Documento"                          	,oFont8)
oPrint:Say  (1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
//
oPrint:Say  (1050,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (1200,100 ,aBolText[1]                                        ,oFont10)
oPrint:Say  (1250,100 ,aBolText[2]+" "+IIF(!SUBSTR(ARQTRB->E1_TIPO,1,2)$'AL',AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99")),"")  ,oFont10)
oPrint:Say  (1300,100 ,aBolText[3]                                        ,oFont10)
oPrint:Say  (1350,100 ,aBolText[4]                                        ,oFont10)
//
oPrint:Say  (1050,1910,"(-)Desconto/Abatimento"                         ,oFont8)
oPrint:Say  (1120,1910,"(-)Outras Deduções"                             ,oFont8)
oPrint:Say  (1190,1910,"(+)Mora/Multa"                                  ,oFont8)
oPrint:Say  (1260,1910,"(+)Outros Acréscimos"                           ,oFont8)
oPrint:Say  (1330,1910,"(=)Valor Cobrado"                               ,oFont8)
//
oPrint:Say  (1400,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (1430,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (1483,400 ,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (1536,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
if Len(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (1589,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC
else
	oPrint:Say  (1589,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF
endif
oPrint:Say  (1589,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)
//
oPrint:Say  (1605,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (1645,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (1645,1900,"Recibo do Sacado"								,oFont8) //oFont10)
//
oPrint:Line (0710,1900,1400,1900 )
oPrint:Line (1120,1900,1120,2300 )
oPrint:Line (1190,1900,1190,2300 )
oPrint:Line (1260,1900,1260,2300 )
oPrint:Line (1330,1900,1330,2300 )
oPrint:Line (1400,100 ,1400,2300 )
oPrint:Line (1640,100 ,1640,2300 )
//
For i := 100 to 2300 step 50
	oPrint:Line( 1930, i, 1930, i+30)                 // 1850
Next i
//
oPrint:Line (2080,100,2080,2300)                                                       //   2000
oPrint:Line (2080,550,1980, 550)                                                       //   2000 - 1900
oPrint:Line (2080,800,1980, 800)                                                       //    2000 - 1900
//
// LOGOTIPO
If File(aBmp)
	oPrint:SayBitmap( 1970,0100,aBmp,0100,0100 )
	oPrint:Say  (2010,240,"Banco Itaú SA",oFont10 )	// [2]Nome do Banco
Else
	oPrint:Say  (2014,100,aDadosBanco[2],oFont15n )	// [2]Nome do Banco                     1934
EndIf
//
oPrint:Say  (1988,569,"341-7",oFont24 )	// [1]Numero do Banco                       1912
oPrint:Say  (2014,820,CB_RN_NN[2],oFont14n)		//Linha Digitavel do Codigo de Barras   1934
//
oPrint:Line (2180,100,2180,2300 )
oPrint:Line (2280,100,2280,2300 )
oPrint:Line (2350,100,2350,2300 )
oPrint:Line (2420,100,2420,2300 )
//
oPrint:Line (2280, 500,2420,500)
oPrint:Line (2350, 750,2420,750)
oPrint:Line (2280,1000,2420,1000)
oPrint:Line (2280,1350,2350,1350)
oPrint:Line (2280,1550,2420,1550)
//
oPrint:Say  (2080,100 ,"Local de Pagamento"                             ,oFont8)
oPrint:Say  (2100,400 ,"Até o Vencimento preferencialmente no Banco Itaú."        ,oFont9)
oPrint:Say  (2140,400 ,"Após o Vencimento somente no Banco Itaú."        ,oFont9)
//
oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont8)
oPrint:Say  (2120,2010,DTOC(aDadosTit[4])                               ,oFont10)
//
oPrint:Say  (2180,100 ,"Cedente"                                        ,oFont8)
oPrint:Say  (2220,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6]	,oFont10) //Nome + CNPJ
//
oPrint:Say  (2180,1910,"Agência/Código Cedente"                         ,oFont8)
oPrint:Say  (2220,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
//
oPrint:Say  (2280,100 ,"Data do Documento"                              ,oFont8)
oPrint:Say  (2310,100 ,DTOC(aDadosTit[2])                               ,oFont10)
//
oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont8)
oPrint:Say  (2310,605 ,(alltrim(aDadosTit[7]))+aDadosTit[1]			,oFont10) //Prefixo +Numero+Parcela
//
oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont8)
oPrint:Say  (2310,1050,aDadosTit[8]										,oFont10) //Tipo do Titulo
//
oPrint:Say  (2280,1355,"Aceite"                                         ,oFont8)  // 2200
oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230
//
oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont8)       // 2200
oPrint:Say  (2310,1655,DTOC(aDadosTit[3])                               ,oFont10) // Data impressao  2230
//
oPrint:Say  (2280,1910,"Nosso Número"                                   ,oFont8)       // 2200
oPrint:Say  (2310,2010,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4),oFont10)  // 2230
//
oPrint:Say  (2350,100 ,"Uso do Banco"                                   ,oFont8)       // 2270
//
oPrint:Say  (2350,505 ,"Carteira"                                       ,oFont8)       // 2270
oPrint:Say  (2380,555 ,aDadosBanco[6]                                  	,oFont10)      //  2300
//
oPrint:Say  (2350,755 ,"Espécie"                                        ,oFont8)       //  2270
oPrint:Say  (2380,805 ,"R$"                                             ,oFont10)      //  2300
//
oPrint:Say  (2350,1005,"Quantidade"                                     ,oFont8)       //  2270
oPrint:Say  (2350,1555,"Valor"                                          ,oFont8)       //  2270
//
oPrint:Say  (2350,1910,"Valor do Documento"                          	,oFont8)        //  2270
oPrint:Say  (2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300
//
oPrint:Say  (2420,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont8) // 2340
oPrint:Say  (2570,100 ,aBolText[1]                                        ,oFont10)    //2540
oPrint:Say  (2620,100 ,aBolText[2]+" "+IIF(!SUBSTR(ARQTRB->E1_TIPO,1,2)$'AL',AllTrim(Transform((aDadosTit[5]*(_nTxper/100)),"@E 99,999.99")),"")  ,oFont10)  // 2490  // *0.05)/30)
oPrint:Say  (2670,100 ,aBolText[3]                                        ,oFont10)    //2540
oPrint:Say  (2720,100 ,aBolText[4]                                        ,oFont10)    //2540
//
oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont8)      //  2340
oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont8)      //  3410
oPrint:Say  (2560,1910,"(+)Mora/Multa"                                  ,oFont8)      //  2480
oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont8)      //  2550
oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont8)      //  2620
//
oPrint:Say  (2770,100 ,"Sacado"                                         ,oFont8)
oPrint:Say  (2800,400 ,aDatSacado[1]+" ("+aDatSacado[2]+")"             ,oFont10)
oPrint:Say  (2853,400 ,aDatSacado[3]                                    ,oFont10)       // 2773
oPrint:Say  (2906,400 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado  2826
IF LEN(Alltrim(aDatSacado[7])) == 14
	oPrint:Say  (2959,400 ,"C.N.P.J.: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont10) // CGC        2879
ELSE
	oPrint:Say  (2959,400 ,"C.P.F.: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont10) // CPF        2879
ENDIF
oPrint:Say  (2959,1850,Substr(aDadosTit[6],1,3)+"/"+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)  ,oFont10)         //  2879
//
oPrint:Say  (2975,100 ,"Sacador/Avalista"                               ,oFont8)
oPrint:Say  (3015,1500,"Autenticação Mecânica -"                        ,oFont8)
oPrint:Say  (3015,1850,"Ficha de Compensação"                           ,oFont8) //oFont10)      // 2935 + 280      = 3215
//
oPrint:Line (2080,1900,2770,1900 )
oPrint:Line (2490,1900,2490,2300 )
oPrint:Line (2560,1900,2560,2300 )
oPrint:Line (2630,1900,2630,2300 )
oPrint:Line (2700,1900,2700,2300 )
oPrint:Line (2770,100 ,2770,2300 )
//
oPrint:Line (3010,100 ,3010,2300 )
//
MsBar("INT25"  ,nCB1Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
MsBar("INT25"  ,nCB2Linha,nCBColuna,CB_RN_NN[1]  ,oPrint,.F.,,,nCBLargura,nCBAltura,,,,.F.)
//
/*
DbSelectArea("SE1")
RecLock("SE1",.f.)
SE1->E1_NUMBCO :=	Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4,8)+Substr(aDadosTit[6],13,1)   // Nosso número (Ver fórmula para calculo)
SE1->E1_PORTADO	:= 	"999"
SE1->E1_AGEDEP 	:=  "999"
SE1->E1_CONTA	:=  "99999-9"
SE1->E1_SITUACA	:=	"1"
MsUnlock()
*/
//
oPrint:EndPage() // Finaliza a página
//
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(nValor*100,10) //strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
//RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
  RN   := RN + _cfator + StrZero(nValor * 100,14-Len(_cfator))    
 
//
Return({CB,RN,NN})
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ValidPerg   ³Descri‡ão³Verifica o Arquivo Sx1, criando as  ³±±
±±³          ³             ³         ³Perguntas se necessario.            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg()
//
PRIVATE APERG := {},AALIASSX1:=GETAREA()
//
//     "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"      			,"X1_PERSPA"				,"X1_PERENG"				,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"	,"X1_VAR01"	,"X1_DEF01"	,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"	,"X1_DEFSPA2"	,"X1_DEFENG2"	,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"	,"X1_DEFSPA3"	,"X1_DEFENG3"	,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"
/*
//
AADD(APERG,{CPERG  ,"01"		,"Prefixo?"     			,"Prefixo?"    		    	,"Prefixo?"     			,"mv_ch1"		,"C"		,3 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Numero?"         		    ,"Numero?"                  ,"Numero?"          		,"mv_ch2"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"03"		,"Da Parcela?"     			,"Da Parcela?"		    	,"Da Parcela?"		    	,"mv_ch3"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"04"		,"Ate a Parcela?"    		,"Ate a Parcela?"     		,"Ate a Parcela?"     		,"mv_ch4"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//
*/

AADD(APERG,{CPERG  ,"01"		,"Border   de:"     			,"Border   de:"    		    	,"Border   de:"     			,"mv_ch1"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par01"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
AADD(APERG,{CPERG  ,"02"		,"Bordero ate:"         		,"Bordero ate:"                 ,"Bordero ate:"          		,"mv_ch2"		,"C"		,6 				,0 				,0 				,"G"		,""			,"mv_par02"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//AADD(APERG,{CPERG  ,"03"		,"Da Parcela?"     			,"Da Parcela?"		    	,"Da Parcela?"		    	,"mv_ch3"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par03"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})
//AADD(APERG,{CPERG  ,"04"		,"Ate a Parcela?"    		,"Ate a Parcela?"     		,"Ate a Parcela?"     		,"mv_ch4"		,"C"		,1 			    ,0 				,0 				,"G"		,""			,"mv_par04"	,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""   		,"S"		,""				,""})

DBSELECTAREA("SX1")
DBSETORDER(1)
//
FOR I := 1 TO LEN(APERG)
	IF  !DBSEEK(CPERG+APERG[I,2])
		RECLOCK("SX1",.T.)
		FOR J := 1 TO FCOUNT()
			IF  j <= LEN(APERG[I])
				FIELDPUT(J,APERG[I,J])
			ENDIF
		NEXT
		MSUNLOCK()
	ENDIF
NEXT
RESTAREA(AALIASSX1)
//
RETURN()
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CRIA_MV ³Descri‡…o³ Criacao dos Param.Necessarios no (SX6) ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC FUNCTION CRIA_MV()
//
dbSelectArea("SX6")
dbSetOrder(1)
//
If !dbSeek(cFilant+"PV_BOL_LI1")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI1"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "14.5"
	SX6->X6_CONTSPA	:= "14.5"
	SX6->X6_CONTENG	:= "14.5"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LI2")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LI2"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA SEGUNDA LINHA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "26.1"
	SX6->X6_CONTSPA	:= "26.1"
	SX6->X6_CONTENG	:= "26.1"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_COL")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_COL"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "NUMERO DA PRIMEIRA COLUNA EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.3"
	SX6->X6_CONTSPA	:= "1.3"
	SX6->X6_CONTENG	:= "1.3"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_LAR")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_LAR"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "TAMANHO DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "0.0280"
	SX6->X6_CONTSPA	:= "0.0280"
	SX6->X6_CONTENG	:= "0.0280"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
If !dbSeek(cFilant+"PV_BOL_ALT")
	RecLock("SX6",.T.)
	SX6->X6_FIL		:= cFilant
	SX6->X6_VAR		:= "PV_BOL_ALT"
	SX6->X6_TIPO	:= "N"
	SX6->X6_DESCRIC	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCSPA	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DSCENG	:= "ALTURA DO CODIGO EM (CM) PARA IMPRESSAO DO "
	SX6->X6_DESC1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCSPA1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DSCENG1	:= "CODIGO DE BARRAS (PODENDO VARIAR CONFORME DRIVER "
	SX6->X6_DESC2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCSPA2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_DSCENG2	:= "DA IMPRESSORA) - A SER USADO NO BOLETO ITAU."
	SX6->X6_CONTEUD	:= "1.40"
	SX6->X6_CONTSPA	:= "1.40"
	SX6->X6_CONTENG	:= "1.40"
	SX6->X6_PROPRI	:= "U"
	SX6->X6_PYME	:= ""
	MsUnLock()
Endif
//
RETURN()


/*
Private _return := ""
cPerg:="BOLDN"
ValidPerg()
Pergunte(cPerg,.T.)

M->NFi      := MV_PAR01
M->NFf      := MV_PAR02
M->Serie    := MV_PAR03
M->Banco    := MV_PAR04
M->Agencia  := MV_PAR05
M->Conta    := MV_PAR06
M->Carteira := MV_PAR08
M->Tipo     := MV_PAR11
M->Desconto := Transform(MV_PAR09,"@E 999,999,999.99")
M->Fator   := CTOD("07/10/1997")

if MsgBox("Confirma geração dos Boletos?","Atenção !!!","YESNO")
Processa({|| ProcBol() })
endif

DbSelectArea("SX1")
DbSetOrder(1)
DbSeek("BOLDN 09")
RECLOCK("SX1",.F.)
X1_CNT01:='0       '
MSUNLOCK()
mv_par09:=0
Return nil

Static Function ProcBol()
dbSelectArea("SE1")
dbsetorder(1)
dbGoTop()
dbSeek(xFilial()+M->SERIE+M->NFI)

oPrn := TMSPrinter():New()

do while !eof() .and. SE1->E1_NUM >= M->NFI .and. SE1->E1_NUM <= M->NFF
If !EMPTY(M->TIPO)
If M->TIPO<> SE1->E1_TIPO
SE1->(DbSkip())
Loop
Endif
Endif
_mCompoe := U_VERTPNV()
DbSelectArea("SA1")
DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA)
DbSelectArea("SA6")
DbSeek(xFilial("SA6")+M->Banco+M->Agencia+M->Conta)

dbSelectArea("SE1")

// Define Variavéis para a impressao

cNomBanco     := "ATE O VENCIMENTO PAGAVEL PREFERENCIALMENTE NAS AGENCIAS ITAU OU BANERJ"
cLocPagto     := "APOS O VENCIMENTO PAGUE SOMENTE NAS AGENCIAS ITAU OU BANERJ"
dVencto       := Substr(Dtos(SE1->E1_VENCTO),7,2)+"/"+Substr(Dtos(SE1->E1_VENCTO),5,2)+"/"+Substr(Dtos(SE1->E1_VENCTO),1,4)
cCedente      := AllTrim(SM0->M0_NOMECOM)

cConta := StrTran(SA6->A6_NUMCON,"-","")
cConta := StrTran(cConta,".","")
cAgCed := Transform(STRZERO(VAL(SA6->A6_AGENCIA),4)+'7',"@R 9999-9") +" /  "+ Transform(strzero(val(cConta),8),"@R 9999999-9")
dDataPro      := Substr(Dtos(dDataBase),7,2)+"/"+Substr(Dtos(dDataBase),5,2)+"/"+Substr(Dtos(dDataBase),1,4)
cNDocto       := SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
cEspDoc       := "DM"
cAceite       := "Nao"
cNssNum:=0
cNssNum1:=''

//		if Len(Alltrim(SE1->E1_PLNUCOB)) > 0
//            cNssNum := SE1->E1_PLNUCOB
//			cNssNum  := SUBS(cNssNum,1,11) +"-"+SUBS(cNssNum,12,1)
//			cNssNum   := '09/'+Substr(cNssNum,1,2)+"/"+Substr(cNssNum,3,Len(cNssNum))
//			cNssNum1  := SE1->E1_PLNUCOB
//		else
NossoNum()
//   		    reclock('se1',.f.)
//      		E1_PLNUCOB := cNssNum
//	     	msunlock()
cNssNum  := SUBS(cNssNum,1,11) +"-"+SUBS(cNssNum,12,1)
cNssNum   := '09/'+Substr(cNssNum,1,2)+"/"+Substr(cNssNum,3,Len(cNssNum))
cNssNum1  := '0000000016' //SE1->E1_PLNUCOB
//		endif
cUsoBco       := "08650"
cCip          := "000"
nVlrDoc       := If(SE1->E1_VALOR<>0,Transform(SE1->E1_VALOR,"@E 999,999,999.99"),Transform(SE1->E1_SALDO,"@E 999,999,999.99"))
cCGCSac       := If(SA1->A1_PESSOA = "F",Transform(Alltrim(SA1->A1_CGC),"@R 999.999.999-99"),Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99"))
cNomSac       := SA1->A1_NOME + "     CNPJ/CPF: " + cCGCSac
NumBoleta := 999998
cCodBanco     := "|341-2|"
If Empty(SA1->A1_ENDCOB)
cEndSac   := SA1->A1_END + SA1->A1_BAIRRO
cCepSac   := SA1->A1_CEP
cCidSac   := SA1->A1_MUN
cEstSac   := SA1->A1_EST
Else
cEndSac   := SA1->A1_ENDCOB + SA1->A1_BAIRROC
cCepSac   := SA1->A1_CEPC
cCidSac   := SA1->A1_MUNC
cEstSac   := SA1->A1_ESTC
EndIf
nDigBar       := 0
cBarra        := ""
cLinha        := ""
cLograd       := Transform(cCepSac,"@R 99999-999") + " - " + Alltrim(cCidSac) + " - " + Alltrim(cEstSac)
cSacAvl       := ""
dDataDoc      := Substr(Dtos(SE1->E1_EMISSAO),7,2)+"/"+Substr(Dtos(SE1->E1_EMISSAO),5,2)+"/"+Substr(Dtos(SE1->E1_EMISSAO),1,4)
cEspTit       := ""
nQuantid      := ""
nVlrQtd       := ""
cInstruc      := "ENCARGOS POR DIA DE ATRASO: " + Transform(MV_PAR07,"@E 99.99") + "%"
nVlrJur       := (SE1->E1_VALOR * MV_PAR07 / 30) / 100
cDescIns      := cInstruc + "  ( R$ " + Alltrim(Transform(nVlrJur,"@E 999,999.99")) + " )."
cMenBol       := SA6->A6_MENSAGE
cMenDesc      := ""
cSacAvl       := ""

MontaCodBar()
BolLinDig()

oFont2     := TFont():New("Arial"          ,22,22,,.T.,,,,,.F.)
oFont3     := TFont():New("Times New Roman",14,14,,.T.,,,,,.F.)
oFont4     := TFont():New("Arial"          , 6, 6,,.F.,,,,,.F.)
oFont5     := TFont():New("Times New Roman", 9, 9,,.T.,,,,,.F.)
oFont6     := TFont():New("Arial"          ,10,10,,.T.,,,,,.F.)
oFont7     := TFont():New("Arial"          ,08,08,,.F.,,,,,.F.)
oFont8     := TFont():New("Arial"          ,11,11,,.T.,,,,,.F.)
oFont9     := TFont():New("Times New Roman",08,08,,.T.,,,,,.F.)
oFontA1    := TFont():New("Tahoma"         ,22,22,,.t.,,,,,.F.)

oPrn:StartPage()
oPrn:SayBitmap(30,95,"\sigaadv\ITAU.bmp",60,60)
oPrn:Say(  10,  170, "ITAU"               ,oFontA1,100)
oPrn:Say(  10,  600, cCodBanco                ,oFont2,100)
oPrn:Say(  40, 1690, "Comprovante de Entrega" ,oFont8,100)

//Desenho do Primeiro Boleto

oPrn:box( 100, 090, 170,845)   	// Cedente
oPrn:box( 100, 845, 170,1160) 	// Agencia/Cod. Cendente
oPrn:box( 100, 1160, 310, 2200) // Motivos de não entrega
oPrn:box( 170, 090, 240, 845) 	// Sacado
oPrn:box( 170, 845, 240, 1160) 	// Nosso Numero
oPrn:Box( 240, 090, 310,260)  	// Vencimento
oPrn:box( 240, 260, 310,545)  	// Nº documento
oPrn:box( 240, 545, 310,845)  	// Especie Moeda
oPrn:box( 240, 845, 310,1160) 	// Valor Documento
oPrn:box( 310, 090, 380,385)  	// Recebemos o bloqueto
oPrn:box( 310, 385, 380,593)  	// Data
oPrn:box( 310, 593, 380,1160) 	// Assinatura
oPrn:box( 310, 1160,380,1460) 	// Data
oPrn:box( 310, 1460, 380,2200) 	// Entregador
oPrn:Box( 380, 090, 450,1890) 	// Local de Pagto
oPrn:box( 380,1890, 450,2200) 	// Data Processamento

oPrn:Say( 100,  095, "Cedente"                     ,oFont9,100)
oPrn:Say( 100,  850, "Agência/Código Cedente"      ,oFont9,100)
oPrn:Say( 100, 1300, "Motivos de não entrega(para uso da empresa entregadora)",oFont9,100)
oPrn:Say( 150, 1170, "( )Mudou-se"                 ,oFont9,100)
oPrn:Say( 150, 1500, "( )Ausente"                  ,oFont9,100)
oPrn:Say( 150, 1850, "( )Não existe nº indicado"   ,oFont9,100)
oPrn:Say( 170,  095, "Sacado"                      ,oFont9,100)
oPrn:Say( 170,  850, "Nosso Número"                ,oFont9,100)
oPrn:Say( 220, 1170, "( )Recusado"                 ,oFont9,100)
oPrn:Say( 220, 1500, "( )Não procurado"            ,oFont9,100)
oPrn:Say( 220, 1850, "( )Falecido"                 ,oFont9,100)
oPrn:Say( 240, 095,  "Vencimento"                  ,oFont9,100)
oPrn:Say( 240, 270,  "Nº do Documento"             ,oFont9,100)
oPrn:Say( 240, 555,  "Espécie Moeda"               ,oFont9,100)
oPrn:Say( 240, 855,  "Valor do Documento"          ,oFont9,100)

oPrn:Say( 275, 1170, "( )Desconhecido"             ,oFont9,100)
oPrn:Say( 275, 1500, "( )Endereço insuficiente"    ,oFont9,100)
oPrn:Say( 275, 1850, "( )Outros (anotar no verso)" ,oFont9,100)

oPrn:Say( 310, 095,  "Recebí(emos) o bloqueto"     ,oFont9,100)
oPrn:Say( 310, 395,  "Data"                        ,oFont9,100)
oPrn:Say( 310, 603,  "Assinatura"                  ,oFont9,100)
oPrn:Say( 310, 1170, "Data"                        ,oFont9,100)
oPrn:Say( 310, 1470, "Entregador"                  ,oFont9,100)
oPrn:Say( 380, 100, "Local de Pagamento"           ,oFont9,100)
oPrn:Say( 380, 1900, "Data de Processamento"       ,oFont9,100)

oPrn:Say( 480, 1750, "Recibo do Sacado"               ,oFont6,100)

oPrn:Say( 130,  100, cCedente                 ,oFont7,100)
oPrn:Say( 130,  850, cAgCed                   ,oFont7,100)
oPrn:Say( 200,  100, Left(cNomsac,40)         ,oFont7,100)
oPrn:Say( 200,  850, cNssNum                  ,oFont7,100)
oPrn:Say( 270,  100, dVencto                  ,oFont7,100)
oPrn:Say( 270,  265, cNDocto                  ,oFont5,100)
oPrn:Say( 270,  550, "R$"                     ,oFont5,100)
oPrn:Say( 270,  850, nVlrDoc                  ,oFont5,100)
oPrn:Say( 380,  400, cNomBanco                ,oFont5,100)
oPrn:Say( 410,  400, cLocPagto                ,oFont5,100)
oPrn:Say( 410,  1940,dDataPro                 ,oFont5,100)

// RECIBO DO SACADO
oPrn:SayBitmap(460,95,"\sigaadv\ITAU.bmp",60,60)
oPrn:Say(440,  170, "ITAU"               ,oFontA1,100)
oPrn:Say(440,  600, cCodBanco                 ,oFont2,100)


// Desenho do Segundo Boleto
oPrn:Box(530, 090,600,1570) 	// Local de Pagto
oPrn:box(530,1570,1000,2200) 	// Logo
oPrn:box(600, 090,675,1570) 	// Cedente
oPrn:box(675, 090,750, 455) 	// Data Documento
oPrn:box(675, 455,750, 795) 	// N. Documento
oPrn:box(675, 795,750, 1070) 	// Esp. documento
oPrn:box(675, 1070,750,1170) 	// Aceite
oPrn:box(675,1170,750,1570) 	// Data Processamento

oPrn:box(750, 090, 825, 340) 	// Uso do Banco
oPrn:box(750, 340, 825, 455) 	// Cip
oPrn:box(750, 455, 825, 580) 	// Carteira
oPrn:box(750, 580, 825, 795) 	// Especie Moeda
oPrn:box(750, 795, 825,1170) 	// Quantidade
oPrn:box(750,1170, 825,1570) 	// Valor
oPrn:box(825, 090,1675,1570) 	// Instruções
oPrn:box(1675, 090,1825,2200) 	// Sacado

oPrn:box(1000,1570,1075,2200) 	// Vencimento
oPrn:box(1075,1570,1150,2200) 	// Agencia / Codigo Cedente
oPrn:box(1150,1570,1225,2200) 	// Cart./nosso numero
oPrn:box(1225,1570,1300,2200) 	// 1 - Valor do Documento
oPrn:box(1300,1570,1375,2200) 	// 2 - Desconto / Abatimento
oPrn:box(1375,1570,1450,2200) 	// 3 - Outras deduções
oPrn:box(1450,1570,1525,2200) 	// 4 - Mora / Multa
oPrn:box(1525,1570,1600,2200) 	// 5 - Outros acrescimos
oPrn:box(1600,1570,1675,2200) 	// 6 - Valor cobrado

oPrn:Say( 530,   95, "Local de Pagamento"                     ,oFont9,100)
oPrn:Say( 600,   95, "Cedente"                                ,oFont9,100)
oPrn:Say( 675,   95, "Data do Documento"                      ,oFont9,100)
oPrn:Say( 675,  460, "N. do Documento"                        ,oFont9,100)
oPrn:Say( 675,  800, "Espécie Doc."                           ,oFont9,100)
oPrn:Say( 675, 1075, "Aceite"                                 ,oFont9,100)
oPrn:Say( 675, 1175, "Data do processamto"                    ,oFont9,100)
oPrn:Say( 750,   95, "Uso do Banco"                           ,oFont9,100)
oPrn:Say( 750,  345, "Cip"                                    ,oFont9,100)
oPrn:Say( 750,  460, "Carteira"                               ,oFont9,100)
oPrn:Say( 750,  585, "Espécie moeda"                          ,oFont9,100)
oPrn:Say( 750,  800, "Quantidade"                             ,oFont9,100)
oPrn:Say( 750, 1175, "Valor"                                  ,oFont9,100)
oPrn:Say( 825,   95, "INSTRUÇÕES DE RESPONSABILIDADE DO CEDENTE",oFont9,100)
oPrn:Say( 875,   95, "***VALORES EXPRESSOS EM R$"             ,oFont9,100)
oPrn:Say( 925,   95, "APÓS O VENCIMENTO MORA DIA "+"  ( R$ " + Alltrim(Transform(nVlrJur,"@E 999,999.99")) + " ).",oFont9,100)

oPrn:Say( 530,1580, cCodBanco                                 ,oFont6,100)
oPrn:Say( 530,1800,"Recibo do Sacado"                         ,oFont9,100)
oPrn:SayBitmap(620,1800,"\sigaadv\ITAU.bmp",220,220)
oPrn:Say( 870,1720, "ITAU"                                ,oFontA1,100)

If !EMPTY(SUBSTR(_mCompoe,1,70))
oPrn:Say(1000, 95, "CONFORME : "+SUBSTR(_mCompoe,1,87)     ,oFont9,100)
Endif
If !EMPTY(SUBSTR(_mCompoe,88,175))
oPrn:Say(1038, 95,SUBSTR(_mCompoe,88,175)                  ,oFont9,100)
Endif
If !EMPTY(SUBSTR(_mCompoe,176,263))
oPrn:Say(1076, 95,SUBSTR(_mCompoe,176,263)                 ,oFont9,100)
Endif


oPrn:Say(1000, 1575, "Vencimento"                            ,oFont9,100)
oPrn:Say(1075, 1575, "Agencia/Codigo cedente"                ,oFont9,100)
oPrn:Say(1150,   95, "PROTESTO NO TERCEIRO DIA ÚTIL APÓS O VENCIMENTO"             ,oFont9,100)
oPrn:Say(1150, 1575, "Cart./Nosso numero"                    ,oFont9,100)
oPrn:Say(1225, 1575, "1(=) Valor do documento"               ,oFont9,100)
oPrn:Say(1300,   95, "-Pague este título nas Agências ITAU (ou através do Sistema Integrado de Compensação",oFont9,100)
oPrn:Say(1300, 1575, "2(-) Desconto/Abatimento"              ,oFont9,100)
oPrn:Say(1375,   95, "-Após o 3o. dia útil do vencimento, pagável na Agência Depositária Oficial, se houver indicação no",oFont9,100)
oPrn:Say(1375, 1575, "3(-) Outras deduções"                  ,oFont9,100)
oPrn:Say(1450,   95, "LOCAL DE PAGAMENTO, desta papeleta e desde que não haja instruções contrárias do CEDENTE  no espaço acima.",oFont9,100)
oPrn:Say(1450, 1575, "4(+) Mora/Multa"                       ,oFont9,100)
oPrn:Say(1525, 1575, "5(+) Outros acréscimos"                ,oFont9,100)
oPrn:Say(1600, 1575, "6(=) Valor cobrado"                    ,oFont9,100)

oPrn:Say(1670,   95, "Sacado"                                ,oFont9,100)
oPrn:Say(1780,   95, "Sacado/Avalista"                       ,oFont9,100)
oPrn:Say(1825, 1650, "Autenticação Mecanica"                 ,oFont9,100)


oPrn:Say( 530,  400,cNomBanco                                ,oFont7,100)
oPrn:Say( 560,  400,cLocPagto                                ,oFont7,100)
oPrn:Say( 630,   95,cCedente                                 ,oFont7,100)
oPrn:Say( 705,   95,dDataPro                                 ,oFont7,100)
oPrn:Say( 705,  600,cNDocto                                  ,oFont7,100)
oPrn:Say( 705,  980,'DM'                                     ,oFont7,100)
oPrn:Say( 705, 1080,"Não"                                    ,oFont7,100)
oPrn:Say( 705, 1180,dDataPro                                 ,oFont7,100)
oPrn:Say( 780,  200,"08650"                                  ,oFont7,100)
oPrn:Say( 780,  350,"000"                                    ,oFont7,100)
oPrn:Say( 780,  475,"09"                                     ,oFont7,100)
oPrn:Say( 780,  610,"R$"                                     ,oFont7,100)
oPrn:Say(1030, 1700,dVencto                                  ,oFont7,100)
oPrn:Say(1105, 1700,cAgCed                                   ,oFont7,100)
oPrn:Say(1180, 1700,cNssNum                                  ,oFont7,100)
oPrn:Say(1255, 1700,nVlrDoc                                  ,oFont7,100)
oPrn:Say(1330, 1700,Desconto                                 ,oFont7,100)


oPrn:Say(1670,  240, cNomSac                  ,oFont5,100)
oPrn:Say(1700,  240, cEndSac                  ,oFont5,100)
oPrn:Say(1730,  240, cLograd                  ,oFont5,100)
oPrn:Say(1730,  520, cSacAvl                  ,oFont5,100)

oPrn:Say(2130,    0, Replicate("_ ",110)      ,oFont5,100)

// FICHA DE COMPENSACAO
oPrn:SayBitmap(2185,95,"\sigaadv\ITAU.bmp",60,60)
oPrn:Say(2165,  170, "ITAU"               ,oFontA1,100)
oPrn:Say(2165,  600, cCodBanco                ,oFont2,100)
oPrn:Say(2200,  880, cLinha                   ,oFont3,100)

// Desenho do Terceiro Boleto
oPrn:Box(2260, 100,2345,1640) 	// Local de Pagto
oPrn:Box(2260,1640,2345,2310) 	// Vencimento
oPrn:box(2345, 100,2430,1640) 	// Cedente
oPrn:box(2345,1640,2430,2310) 	// Agencia/Cod. Cendente
oPrn:box(2430, 100,2515, 350) 	// Data Documento
oPrn:box(2430, 350,2515, 700) 	// N. Documento
oPrn:box(2430, 700,2515, 880) 	// Esp. documento
oPrn:box(2430, 880,2515,1060) 	// Aceite
oPrn:box(2430,1060,2515,1640) 	// Data Processamento
oPrn:box(2430,1640,2515,2310) 	// Nosso Numero

oPrn:box(2515, 100,2600, 340) 	// Uso do Banco
oPrn:box(2515, 340,2600, 455) 	// Cip
oPrn:box(2515, 455,2600, 580) 	// Carteira
oPrn:box(2515, 580,2600, 795) 	// Especie Moeda
oPrn:box(2515, 795,2600,1170) 	// Quantidade
oPrn:box(2515,1170,2600,1640) 	// Valor

oPrn:box(2515,1640,2600,2310) 	// Valor Documento
oPrn:box(2600,1640,2685,2310) 	// Desconto/Abat.
oPrn:box(2600,100,3025,1640) 	// Instrucoes

oPrn:box(2685,1640,2770,2310) 	// Outras Deducoes
oPrn:box(2770,1640,2855,2310) 	// Mora/Multa
oPrn:box(2855,1640,2940,2310) 	// Outros Acresc.
oPrn:box(2940,1640,3025,2310) 	// Valor Cobrado
oPrn:box(3025, 100,3175,2310) 	// Sacado

oPrn:Say(2260,  120, "Local de Pagamento"     ,oFont4,100)
oPrn:Say(2260, 1645, "Vencimento"             ,oFont4,100)
oPrn:Say(2290,  130, cLocPagto                ,oFont5,100)
oPrn:Say(2290, 1800, dVencto                  ,oFont5,100)
oPrn:Say(2345,  120, "Cedente"                ,oFont4,100)
oPrn:Say(2345, 1645, "Agência/Código Cedente" ,oFont4,100)
oPrn:Say(2370,  130, cCedente                 ,oFont5,100)
oPrn:Say(2370, 1800, cAgCed                   ,oFont5,100)
oPrn:Say(2430,  120, "Data do Documento"      ,oFont4,100)
oPrn:Say(2430,  370, "Nº do Documento"        ,oFont4,100)
oPrn:Say(2430,  720, "Esp. Doc."              ,oFont4,100)
oPrn:Say(2430,  900, "Aceite"                 ,oFont4,100)
oPrn:Say(2430, 1080, "Data Processamento"     ,oFont4,100)
oPrn:Say(2430, 1645, "Nosso Número"           ,oFont4,100)
oPrn:Say(2450,  130, dDataDoc                 ,oFont5,100)
oPrn:Say(2450,  380, cNDocto                  ,oFont5,100)
oPrn:Say(2450,  750, cEspDoc                  ,oFont5,100)
oPrn:Say(2450,  940, cAceite                  ,oFont5,100)
oPrn:Say(2450, 1090, dDataPro                 ,oFont5,100)
oPrn:Say(2450, 1800, cNssNum                  ,oFont5,100)
oPrn:Say(2515,  105, "Uso do Banco"                           ,oFont9,100)
oPrn:Say(2515,  345, "Cip"                                    ,oFont9,100)
oPrn:Say(2515,  460, "Carteira"                               ,oFont9,100)
oPrn:Say(2515,  585, "Espécie moeda"                          ,oFont9,100)
oPrn:Say(2515,  800, "Quantidade"                             ,oFont9,100)
oPrn:Say(2515, 1175, "Valor"                                  ,oFont9,100)
oPrn:Say(2515, 1645, "Valor do Documento"     ,oFont4,100)
oPrn:Say(2545,  130, cUsoBco                  ,oFont5,100)
oPrn:Say(2545,  355, "000"                    ,oFont5,100)
oPrn:Say(2545,  485, M->Carteira              ,oFont5,100)
oPrn:Say(2545,  630, "R$"                     ,oFont5,100)
oPrn:Say(2545,  700, nQuantid                 ,oFont5,100)
oPrn:Say(2545, 1100, nVlrQtd                  ,oFont5,100)
oPrn:Say(2545, 1900, nVlrDoc                  ,oFont5,100)
oPrn:Say(2615, 1900,Desconto                  ,oFont5,100)
oPrn:Say(2605,  120, "INSTRUÇÕES DE RESPONSABILIDADE DO CEDENTE",oFont9,100)
oPrn:Say(2605, 1645, "(-) Desconto/Abatimento",oFont4,100)
oPrn:Say(2685,  120, "***VALORES EXPRESSOS EM R$"             ,oFont9,100)
oPrn:Say(2685, 1645, "(-) Outras Deduções"    ,oFont4,100)
//		oPrn:Say(2730,  120, cMenBol                  ,oFont5,100)
//		oPrn:Say(2750,  120, cMenDesc                 ,oFont5,100)
oPrn:Say(2730, 1645, "(+) Mora/Multa"         ,oFont4,100)
oPrn:Say(2750,  120, "APÓS O VENCIMENTO MORA DIA "+"  ( R$ " + Alltrim(Transform(nVlrJur,"@E 999,999.99")) + " ).",oFont9,100)

If !EMPTY(SUBSTR(_mCompoe,1,70))
oPrn:Say(2855, 120, "CONFORME : "+SUBSTR(_mCompoe,1,87)     ,oFont9,100)
Endif
If !EMPTY(SUBSTR(_mCompoe,88,175))
oPrn:Say(2890, 120, SUBSTR(_mCompoe,88,175)                 ,oFont9,100)
Endif
If !EMPTY(SUBSTR(_mCompoe,176,263))
oPrn:Say(2890, 120, SUBSTR(_mCompoe,176,263)                ,oFont9,100)
Endif


oPrn:Say(2855, 1645, "(+) Outros Acréscimos"  ,oFont4,100)
oPrn:Say(2940, 1645, "(=) Valor Cobrado"      ,oFont4,100)
oPrn:Say(3030,  120, "Sacado:"                ,oFont4,100)
oPrn:Say(3030,  240, cNomSac                  ,oFont5,100)
oPrn:Say(3055,  240, cEndSac                  ,oFont5,100)
oPrn:Say(3085,  240, cLograd                  ,oFont5,100)
oPrn:Say(3140,  120, "Sacador/Avalista:"      ,oFont4,100)
oPrn:Say(3140,  320, cSacAvl                  ,oFont5,100)
oPrn:Say(3140, 1645, "Código de Baixa:"       ,oFont4,100)
oPrn:Say(3170, 1595, "Autenticação Mecânica"  ,oFont4,100)
oPrn:Say(3290, 1700, "FICHA DE COMPENSAÇÃO"   ,oFont6,100)
MSBAR("INT25", 27.50, 1.50,cbarra,oprn,.F.,,.T.,0.025,1.30,NIL,NIL,NIL,.F.)
dbSelectArea("SE1")
dbSkip()
oPrn:EndPage()
enddo
oPrn:Preview()
Return nil

Static Function MontaCodBar()
NumBanc := Strzero(NumBoleta,11,0)
cCampo  := "341" +;                                   // Codigo Banco
"9" +;                                     // Moeda
Str((SE1->E1_VENCTO - M->Fator),4) +;     // Fator de Vencimento
StrZero(Int(SE1->E1_VALOR*100),10) +;      // Valor
M->Carteira+;                              // Carteira
SUBS(cNssNum1,1,11)+;                       // Nosso Numero
substr(m->agencia,2,4) +;                  // Agencia
Strzero(Val(Alltrim(substr(m->conta,1,3))),7,0) +"0"   // Conta Corrente
DigBar()     // Calcula o DV do Codigo de Barras

cBarra := Substr(cCampo,1,4) + nDigBar + Substr(cCampo,5,39)
Return nil

Static Function DigBar()
nCont := 0
cPeso := 2
For i := Len(cCampo) To 1 Step -1
nCont := nCont+(Val(Substr(cCampo,i,1))*cPeso)
cPeso := cPeso+1
If cPeso > 9
cPeso := 2
EndIf
Next i
Resto := (ncont%11)
Resto := 11 - Resto

//	If Resto == 10 .or. Resto == 11 .or. Resto == 0
If Resto == 0 .or. Resto == 1 .or. Resto > 9
nDigbar:='1'
Else
nDigbar:=Str(Resto,1)
EndIf

Return(.T.)

Static Function Digito()

nCont:=0
cCampo:=StrZero(Val(cCampo),10)

For i := 1 to Len(cCampo)
If (i%2) != 0
nCont := nCont+(Val(Substr(cCampo,i,1))*1)
Else
If Val(Substr(cCampo,i,1))*2 >= 10
nVal  := Val(Substr(cCampo,i,1))*2
nCont := nCont+(Val(Substr(Str(nVal,2),1,1))+Val(Substr(Str(nVal,2),2,1)))
Else
nCont := nCont+(Val(Substr(cCampo,i,1))*2)
Endif
Endif
Next i

nDigito:=Abs(If((nCont%10)==0,0,10-(nCont%10)))

Return(.T.)

Static Function BolLinDig()

cLinha  := ""
nDigito := 0

// CAMPO: 001 91 1899 0000064652 00001234567 1892 00008438 11
//                    1          2         3           4
//        237 90 3398 0123456789 01234567890 1234 56789012 34

// Calculo do Primeiro Campo
// Codigo Banco + Moeda + 5 primeiras posicoes do campo livre (20-24) do Cod.Barras + DV
cCampo := Substr(cBarra,1,4)+Substr(cBarra,20,5)
cCamp1 := cCampo
Digito()
cLinha := cLinha+Substr(cCamp1,1,5)+"."+Substr(cCamp1,6,4)+Str(nDigito,1)+Space(2)

// Calculo do Segundo Campo
// Posicoes 25 a 34 do Cod. Barras + DV
cCampo := Substr(cBarra,25,10)
Digito()
cLinha := cLinha+Substr(cCampo,1,5)+"."+Substr(cCampo,6,5)+Str(nDigito,1)+Space(2)

// Calculo do Terceiro Campo
// Posicoes 16 a 25 do Campo Livre e posicoes 35 a 44 do Cod. Barras + DV
cCampo := Substr(cBarra,35,10)
Digito()
cLinha := cLinha + Substr(cCampo,1,5)+"."+Substr(cCampo,6,5)+Str(nDigito,1,0)+Space(2)

// Calculo do Quarto Campo
//DV do Codigo de Barras (5a. Posicao)
cLinha := cLinha + nDigbar + SPACE(2)

// Calculo do Quinto Campo
// Posicoes 6 a 9 e 10 a 19 Cod. Barras
If Val(Substr(cBarra,06,14)) == 0 .or. SE1->E1_MOEDA != 1
cCampo := "            000"
Else
cCampo := AllTrim(STR((SE1->E1_VENCTO - M->Fator))) + StrZero(Int(SE1->E1_Valor*100),10)
Endif
cLinha := cLinha + cCampo

Return(.T.)



Static Function ValidPerg()
cAlias := alias()
DbSelectArea("SX1")
DbSetOrder(1)
DbSeek("BOLDN")
If found()
DbSelectArea(cAlias)
Return Nil
EndIf
cGRUPO     := "BOLDN" // Nome do grupo de perguntas
aORDEM     := {1,2,3,4,5,6,7,8}
aPERGUNT   := {"Da Nota Fiscal     ?","Ate Nota Fiscal    ?","Serie NF           ?",;
"Banco Portador     ?","Agencia            ?","Conta              ?",;
"Encargos Dia Atraso?","Carteira           ?"}
aVARIAVL   := {"MV_CH1","MV_CH2","MV_CH3","MV_CH4","MV_CH5","MV_CH6","MV_CH7","MV_CH8"}
aTIPO      := {"C","C","C","C","C","C","N","C"}
aTAMANHO   := {6,6,3,3,5,10,4,2}
aDECIMAL   := {0,0,0,0,0,0,2,0}
aPRESEL    := {0,0,0,0,0,0,0,0}
aGSC       := {"G","G","G","G","G","G","G","G"}
aCNT01     := {"      ","      ","   ","   ","     ","          ","     ","  "}
aVALID     := {" "," "," "," "," "," "," "," "}
aVAR01     := {"MV_PAR01","MV_PAR02","MV_PAR03","MV_PAR04","MV_PAR05","MV_PAR06","MV_PAR07","MV_PAR08"}
aDEF01     := {" "," "," "," "," "," "," "," "}
aDEF02     := {" "," "," "," "," "," "," "," "}
aDEF03     := {" "," "," "," "," "," "," "," "}
aDEF04     := {" "," "," "," "," "," "," "," "}
aDEF05     := {" "," "," "," "," "," "," "," "}
aF3        := {"   ","   ","   ","SA6","   ","   ","   ","   "}

for indice := 1 to len(aOrdem)
while .not. reclock("SX1",.T.)
enddo
replace X1_GRUPO    with  cGRUPO
replace X1_ORDEM    with  strzero(aORDEM[indice],2,0)
replace X1_PERGUNT  with  aPERGUNT[indice]
replace X1_VARIAVL  with  aVARIAVL[indice]
replace X1_TIPO     with  aTIPO[indice]
replace X1_TAMANHO  with  aTAMANHO[indice]
replace X1_DECIMAL  with  aDECIMAL[indice]
replace X1_PRESEL   with  aPRESEL[indice]
replace X1_GSC      with  aGSC[indice]
replace X1_VALID    with  aVALID[indice]
replace X1_VAR01    with  aVAR01[indice]
replace X1_CNT01    with  aCNT01[indice]
replace X1_DEF01    with  aDEF01[indice]
replace X1_DEF02    with  aDEF02[indice]
replace X1_DEF03    with  aDEF03[indice]
replace X1_DEF04    with  aDEF04[indice]
replace X1_DEF05    with  aDEF05[indice]
replace X1_F3       with  aF3[indice]
MsUnlock()
next
DbSelectArea(cAlias)
Return Nil


Static Function NossoNum()
//	cVar := "09"+GetSx8Num("SE1","E1_NUMBCO")
//	ConfirmSX8()
//	cVar := "0900000000001"

A:= 2     //GETMV("MV_CNABBRD")
cretorno := '09'+strzero(A,11)

cretornof := val(subs(cretorno,1,1))*2+val(subs(cretorno,2,1))*7
cretornof := cretornof+val(subs(cretorno,3,1))*6+val(subs(cretorno,4,1))*5
cretornof := cretornof+val(subs(cretorno,5,1))*4+val(subs(cretorno,6,1))*3
cretornof := cretornof+val(subs(cretorno,7,1))*2+val(subs(cretorno,8,1))*7
cretornof := cretornof+val(subs(cretorno,9,1))*6+val(subs(cretorno,10,1))*5
cretornof := cretornof+val(subs(cretorno,11,1))*4+val(subs(cretorno,12,1))*3
cretornof := cretornof+val(subs(cretorno,13,1))*2


cretornof := cretornof - (int(cretornof / 11)*11)

do case
case int(cretornof) = 0
cretornof := '0'
case int(cretornof) = 1
cretornof := 'P'
otherwise
cretornof := strzero(11-int(cretornof),1)
endcase

cNssnum := strzero(A,11)+cretornof

/*
dbselectarea("sx6")
reclock("sx6",.f.)
repla x6_conteud with ltrim(str(a+1,11))
msunlock()
*/

Return cnssnum

Static Function DigNossoNum(cNssN)
return()  //VOLTA SEM FAZER NADA
aDigitos := {}
For k=1 to Len(AllTrim(cNssN))
	aadd(aDigitos,Val(Substr(cNssN,k,1)))
Next
cBase:="2765432765432"
For j=1 to Len(aDigitos)
	aDigitos[j] := aDigitos[j] * Val(Substr(cBase,j,1))
Next
nValor:=0
For j=1 to Len(aDigitos)
	nValor := nValor + aDigitos[j]
Next
nValor := nValor % 11
nDigito := 11 - nValor
if nDigito = 11
	cDig := "0"
elseif nDigito = 10
	cDig := "P"
else
	cDig := StrZero(nDigito,1)
endif
Return cDig

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
User Function VERTPNV()
Local _cArea  := ALIAS()
Local cSQL    := ""

_return := ""

cSQL+= " SELECT E1_TIPO,E1_NUM "
cSQL+= " FROM "+RetSQLName("SE1")
cSQL+= " WHERE E1_FATURA='"+ARQTRB->E1_NUM+"'  "
cSQL+= " AND D_E_L_E_T_ <> '*' "
cSQL:= ChangeQuery(cSQL)
TCQUERY cSQL new alias "ARQTMP"

Do While !ARQTMP->(EOF())
	_return += ARQTMP->E1_TIPO+" "+ARQTMP->E1_NUM+"/"
	ARQTMP->(DbSkip())
EndDo

dbSelectArea("ARQTMP")
dbCloseArea()

DbSelectArea(_cArea)
Return(_return)
