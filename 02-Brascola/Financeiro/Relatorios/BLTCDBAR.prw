#INCLUDE "RWMAKE.CH"  
#INCLUDE "TbiConn.ch" 
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � BLTCDBAR � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO BANCO HSBC COM CODIGO DE BARRAS        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function BLTCDBAR()

LOCAL	aPergs := {} 
PRIVATE lExec    := .F.
PRIVATE cIndexName := ''
PRIVATE cIndexKey  := ''
PRIVATE cFilter    := ''

Tamanho  := "M"
titulo   := "Impressao de Boleto com Codigo de Barras"
cDesc1   := "Este programa destina-se a impressao do Boleto com Codigo de Barras."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETO"
lEnd     := .F.
cPerg     :="BLTBAR"
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }   
nLastKey := 0

dbSelectArea("SE1")

Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Portador","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"Ate Portador","","","mv_ch8","C",3,0,0,"G","","MV_PAR08","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
Aadd(aPergs,{"De Cliente","","","mv_ch9","C",6,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"Ate Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SE1","","","",""})
Aadd(aPergs,{"De Loja","","","mv_chb","C",2,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Emissao","","","mv_chd","D",8,0,0,"G","","MV_PAR13","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"De Vencimento","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","01/01/80","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","31/12/03","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Do Bordero","","","mv_chh","C",6,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Ate Bordero","","","mv_chi","C",6,0,0,"G","","MV_PAR18","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})

//AjustaSx1("BLTBAR",aPergs)

Pergunte (cPerg,.F.)

Wnrel := SetPrint(cString,Wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho,,)

If nLastKey == 27
	Set Filter to
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter to
	Return
Endif

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"
cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"'.And.E1_SALDO>0.And."
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "'.And.E1_PREFIXO<='" + MV_PAR02 + "'.And." 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "'.And.E1_NUM<='" + MV_PAR04 + "'.And."
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "'.And.E1_PARCELA<='" + MV_PAR06 + "'.And."
cFilter		+= "E1_PORTADO>='" + MV_PAR07 + "'.And.E1_PORTADO<='" + MV_PAR08 + "'.And."
cFilter		+= "E1_CLIENTE>='" + MV_PAR09 + "'.And.E1_CLIENTE<='" + MV_PAR10 + "'.And."
cFilter		+= "E1_LOJA>='" + MV_PAR11 + "'.And.E1_LOJA<='"+MV_PAR12+"'.And."
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par13)+"'.and.DTOS(E1_EMISSAO)<='"+DTOS(mv_par14)+"'.And."
cFilter		+= 'DTOS(E1_VENCREA)>="'+DTOS(mv_par15)+'".and.DTOS(E1_VENCREA)<="'+DTOS(mv_par16)+'".And.'
cFilter		+= "E1_NUMBOR>='" + MV_PAR17 + "'.And.E1_NUMBOR<='" + MV_PAR18 + "'.And."
cFilter		+= "!(E1_TIPO$MVABATIM).And."
cFilter		+= "E1_PORTADO<>'   '"

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()
@ 001,001 TO 400,700 DIALOG oDlg TITLE "Sele��o de Titulos"
@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
@ 180,310 BMPBUTTON TYPE 01 ACTION (lExec := .T.,Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (lExec := .F.,Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
	
dbGoTop()
If lExec
	Processa({|lEnd|MontaRel()})
Endif
RetIndex("SE1")
Ferase(cIndexName+OrdBagExt())

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MontaRel� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER DO HSBC COM CODIGO DE BARRAS     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function MontaRel()
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "

//Dados da Empresa
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                                           ,; //[1]Nome da Empresa
                        SM0->M0_ENDCOB                                                            ,; //[2]Endere�o
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+              ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                         } //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Ap�s o vencimento cobrar multa de R$ ",;
								"Mora Diaria de R$ ",;
								"Sujeito a Protesto apos 05 (cinco) dias do vencimento"}

LOCAL nI           := 1
LOCAL aCB_RN_NN    := {}
LOCAL nVlrAbat		:= 0

oPrint:= TMSPrinter():New( "Boleto Laser" )
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova p�gina

dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")

    //Dados do Banco
	aDadosBanco  := { SA6->A6_COD                                                   ,;// [1]Numero do Banco
                      SA6->A6_NOME      	            	                        ,;// [2]Nome do Banco
	                  SUBSTR(SA6->A6_AGENCIA, 5, 9)                                 ,;// [3]Ag�ncia
                      SUBSTR(SA6->A6_NUMCON,5,Len(AllTrim(SA6->A6_NUMCON))-1),       ;// [4]Conta Corrente
                      ALLTRIM(SUBSTR(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON)),1)),;// [5]D�gito da conta corrente
                      " "                                              		         }// [6]Codigo da Carteira

	If Empty(SA1->A1_ENDCOB)
	  
		//Dados do Sacado
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Raz�o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]C�digo
 		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endere�o
		AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
		SA1->A1_EST                                      ,;     	// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										 ,;         // [7]CGC
		SA1->A1_PESSOA									  }         // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Raz�o Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA               ,;   	// [2]C�digo
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC) ,;   	// [3]Endere�o
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                         ,;   	// [6]CEP
		SA1->A1_CGC											 ,;		// [7]CGC
		SA1->A1_PESSOA								          }		// [8]PESSOA
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Aqui defino parte do numero do t�tulo. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao
	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
	
  	//Monta codigo de barras
	//aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCTO)
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCTO,SEE->EE_CODEMP, SEE->EE_FAXATU)
	
	//Dados do Titulo
	aDadosTit	:= {AllTrim(E1_NUM)+" "+AllTrim(E1_PARCELA),;  // [1] N�mero do t�tulo
	                E1_EMISSAO                         	   ,;  // [2] Data da emiss�o do t�tulo
					dDataBase                    		   ,;  // [3] Data da emiss�o do boleto
					E1_VENCTO                              ,;  // [4] Data do vencimento
					(E1_SALDO - nVlrAbat)                  ,;  // [5] Valor do t�tulo
					aCB_RN_NN[3]                           ,;  // [6] Nosso n�mero (Ver f�rmula para calculo)
					E1_PREFIXO                             ,;  // [7] Prefixo da NF
					E1_TIPO	                          	    }  // [8] Tipo do Titulo
	
	If Marked("E1_OK")
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1  
	EndIf

	dbSkip()
	IncProc()
	nI := nI + 1   
	
EndDo
oPrint:EndPage()     // Finaliza a p�gina
//oPrint:Preview()     // Visualiza antes de imprimir 
oPrint:Print() //Imprime direto na impressora default do AP5
Return nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  Impress � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER DO HSBC COM CODIGO DE BARRAS     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8    := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n   := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11c  := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10   := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10n  := TFont():New("Arial",9,10,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14   := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20   := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21   := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n  := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15   := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n  := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont14n  := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont24   := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)
oFont26   := TFont():New("Arial",9,26,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova p�gina


/******************/
/* PRIMEIRA PARTE */
/******************/ 

nRow2 := 0

//Pontilhado separador
//For nI := 100 to 2300 step 50
  //	oPrint:Line(nRow2+0580, nI,nRow2+0580, nI+30)
//Next nI
   
oPrint:Line (nRow2+0150,100,nRow2+0150,2300)
oPrint:Line (nRow2+0150,500,nRow2+0070, 500)
oPrint:Line (nRow2+0150,710,nRow2+0070, 710)

oPrint:Say  (nRow2+0060,100,"HSBC",oFont24 )	        	// [2]Nome do Banco
oPrint:Say  (nRow2+0075,515,aDadosBanco[1]+"-9",oFont21 )	// [1]Numero do Banco  
oPrint:Say  (nRow2+0075,755,aCB_RN_NN[2],oFont10n)			// Linha Digitavel do Codigo de Barras
//oPrint:Say  (nRow2+0084,1800,"Recibo do Sacado",oFont10)

oPrint:Line (nRow2+0250,100,nRow2+0250,2300 )
oPrint:Line (nRow2+0350,100,nRow2+0350,2300 )
oPrint:Line (nRow2+0420,100,nRow2+0420,2300 )
oPrint:Line (nRow2+0490,100,nRow2+0490,2300 )

oPrint:Line (nRow2+0350,500,nRow2+0490,500)
oPrint:Line (nRow2+0420,750,nRow2+0490,750)
oPrint:Line (nRow2+0350,1000,nRow2+0490,1000)
oPrint:Line (nRow2+0350,1300,nRow2+0420,1300)
oPrint:Line (nRow2+0350,1480,nRow2+0490,1480)

oPrint:Say  (nRow2+0150,100 ,"Local de Pagamento",oFont8)
oPrint:Say  (nRow2+0190,100 ,"PAGAR PREFERENCIALMENTE EM AG�NCIA DO HSBC",oFont11c)
//oPrint:Say  (nRow2+0205,400 ,"AP�S O VENCIMENTO, SOMENTE NO ITA� OU BANERJ",oFont10)

oPrint:Say  (nRow2+0150,1810,"Vencimento:",oFont8)

cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1750+(374-(len(cString)*22))
oPrint:Say  (nRow2+0190,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0250,100 ,"Cedente",oFont8)
oPrint:Say  (nRow2+0290,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ

oPrint:Say  (nRow2+0250,1810,"Ag�ncia/C�digo Cedente:",oFont8)
cString := Alltrim(aDadosBanco[3]+" "+AllTrim(aDadosBanco[4])+aDadosBanco[5])
nCol := 1840+(374-(len(cString)*22))
oPrint:Say  (nRow2+0290,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0350,100 ,"Data de Emiss�o",oFont8)
oPrint:Say  (nRow2+0380,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4),oFont10)

oPrint:Say  (nRow2+0350,505 ,"N�mero do Documento",oFont8)
oPrint:Say  (nRow2+0380,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0350,1005,"Esp�cie Doc.",oFont8)
//oPrint:Say  (nRow2+0380,1050,aDadosTit[8],oFont10) //Tipo do Titulo 
oPrint:Say  (nRow2+0380,1050,"PD",oFont10) //Tipo do Titulo

oPrint:Say  (nRow2+0350,1305,"Aceite",oFont8)
oPrint:Say  (nRow2+0380,1350,"N�O",oFont10)

oPrint:Say  (nRow2+0350,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow2+0380,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4),oFont10) // Data impressao

oPrint:Say  (nRow2+0350,1810,"Nosso N�mero:",oFont8)
//cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)) 
cString := aDadosTit[6]
nCol := 1840+(374-(len(cString)*22))
oPrint:Say  (nRow2+0380,nCol,cString,oFont11c)

oPrint:Say  (nRow2+0420,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow2+0420,505 ,"Carteira",oFont8)
//oPrint:Say  (nRow2+0450,555 ,aDadosBanco[6],oFont10)
oPrint:Say  (nRow2+0450,555 ,"CSB",oFont10)

oPrint:Say  (nRow2+0420,755 ,"Esp�cie",oFont8)
oPrint:Say  (nRow2+0450,805 ,"REAL",oFont10)

oPrint:Say  (nRow2+0420,1005,"Quantidade",oFont8)
oPrint:Say  (nRow2+0420,1485,"Valor",oFont8)

oPrint:Say  (nRow2+0420,1810,"(=) Valor do Documento",oFont8)
cString := "R$ "+Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1750+(374-(len(cString)*22))
oPrint:Say  (nRow2+0450,nCol,cString ,oFont11c)

oPrint:Say  (nRow2+0490,100 ,"Instru��es (Texto de responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow2+0590,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))       ,oFont10)
oPrint:Say  (nRow2+0640,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99"))  ,oFont10)
oPrint:Say  (nRow2+0690,100 ,aBolText[3],oFont10)

oPrint:Say  (nRow2+0490,1810,"(-) Desconto/Abatimento",oFont8)
oPrint:Say  (nRow2+0560,1810,"(-) Outras Dedu��es",oFont8)
oPrint:Say  (nRow2+0630,1810,"(+) Mora/Multa",oFont8)
oPrint:Say  (nRow2+0700,1810,"(+) Outros Acr�scimos",oFont8)
oPrint:Say  (nRow2+0770,1810,"(=) Valor Cobrado",oFont8)

oPrint:Say  (nRow2+0840,100 ,"Sacado",oFont8n)
//oPrint:Say  (nRow2+0870,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont8n) 
oPrint:Say  (nRow2+0870,100 ,aDatSacado[1],oFont8n)
oPrint:Say  (nRow2+0900,100 ,aDatSacado[3],oFont8n)
oPrint:Say  (nRow2+0930,100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8n) // CEP+Cidade+Estado

If aDatSacado[8] = "J" //Se for pessoa Jur�dica
	oPrint:Say  (nRow2+0870,1500 ,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8n) // CGC
Else
	oPrint:Say  (nRow2+0870,1500 ,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8n) 	// CPF
EndIf

//oPrint:Say  (nRow2+1029,1850,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4)  ,oFont8n)
oPrint:Say  (nRow2+1029,1850 ,"C�digo de Baixa",oFont8)

oPrint:Say  (nRow2+1045,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow2+1085,1500,"Autentica��o Mec�nica",oFont8)

oPrint:Line (nRow2+0150,1800,nRow2+0840,1800 ) 
oPrint:Line (nRow2+0560,1800,nRow2+0560,2300 )
oPrint:Line (nRow2+0630,1800,nRow2+0630,2300 )
oPrint:Line (nRow2+0700,1800,nRow2+0700,2300 )
oPrint:Line (nRow2+0770,1800,nRow2+0770,2300 )
oPrint:Line (nRow2+0840,100 ,nRow2+0840,2300 )
oPrint:Line (nRow2+1080,100 ,nRow2+1080,2300 )

/*
Par�metros: 
01 cTypeBar      String com o tipo do c�digo de barras:          
     "EAN13","EAN8","UPCA" ,"SUP5"   ,"CODE128"     
     "INT25","MAT25,"IND25","CODABAR","CODE3_9"     
02 nRow          Numero da Linha em cent�metros               
03 nCol          Numero da coluna em cent�metros                        
04 cCode         String com o conte�do do c�digo               
05 oPr           Objeto Printer                                
06 lcheck        Se calcula o digito de controle              
07 Cor           Numero da Cor, utilize a "common.ch"          
08 lHort         Se imprime na Horizontal                      
09 nWidth        Numero do Tamanho da barra em cent�metros      
10 nHeigth       Numero da Altura da barra em mil�metros        
11 lBanner       Se imprime o linha em baixo do c�digo          
12 cFont         String com o tipo de fonte                    
13 cMode         String com o modo do c�digo de barras CODE128     

MSBAR(cTypeBar,nRow,nCol,   cCode    ,  oPr ,lCheck,Cor,lHort,nWidth,nHeigth,lBanner,cFont,cMode   ) */    
MSBAR("INT25" ,9.5 , 1  ,aCB_RN_NN[1],oPrint,  .F. ,Nil, Nil ,0.025 ,  1.5  ,   Nil , Nil , "A" ,.F.)

/******************/
/* SEGUNDA PARTE */
/******************/

nRow3 := -450

For nI := 100 to 2300 step 50
	oPrint:Line(nRow3+1880, nI, nRow3+1880, nI+30)
Next nI

oPrint:Line (nRow3+2000,100,nRow3+2000,2300)
oPrint:Line (nRow3+2000,500,nRow3+1920, 500)
oPrint:Line (nRow3+2000,710,nRow3+1920, 710)

oPrint:Say  (nRow3+1910,100,"HSBC",oFont24 )	        	// [2]Nome do Banco
oPrint:Say  (nRow3+1925,515,aDadosBanco[1]+"-9",oFont21 )	// [1]Numero do Banco
//oPrint:Say  (nRow3+1934,755,aCB_RN_NN[2],oFont15n)		// Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+2100,100,nRow3+2100,2300 )
oPrint:Line (nRow3+2200,100,nRow3+2200,2300 )
oPrint:Line (nRow3+2270,100,nRow3+2270,2300 )
oPrint:Line (nRow3+2340,100,nRow3+2340,2300 )

oPrint:Line (nRow3+2200,500 ,nRow3+2340,500 )
oPrint:Line (nRow3+2270,750 ,nRow3+2340,750 )
oPrint:Line (nRow3+2200,1000,nRow3+2340,1000)
oPrint:Line (nRow3+2200,1300,nRow3+2270,1300)
oPrint:Line (nRow3+2200,1480,nRow3+2340,1480)

oPrint:Say  (nRow3+2000,100 ,"Local de Pagamento",oFont8) 
oPrint:Say  (nRow3+2040,100 ,"PAGAR PREFERENCIALMENTE EM AG�NCIA DO HSBC",oFont11c)
//oPrint:Say  (nRow3+2055,400 ,"AP�S O VENCIMENTO, SOMENTE NO ITA� OU BANERJ",oFont10) 
         
oPrint:Say  (nRow3+2000,1810,"Vencimento:",oFont8)
cString:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol:= 1750+(374-(len(cString)*22))
oPrint:Say  (nRow3+2040,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2100,100 ,"Cedente",oFont8)
oPrint:Say  (nRow3+2140,100 ,aDadosEmp[1]+"                  - "+aDadosEmp[6],oFont10) //Nome + CNPJ

oPrint:Say  (nRow3+2100,1810,"Ag�ncia/C�digo Cedente:",oFont8)
cString:= Alltrim(aDadosBanco[3]+" "+AllTrim(aDadosBanco[4])+aDadosBanco[5])
nCol:= 1840+(374-(len(cString)*22))
oPrint:Say  (nRow3+2140,nCol,cString ,oFont11c)

oPrint:Say  (nRow3+2200,100 ,"Data de Emiss�o",oFont8)
oPrint:Say (nRow3+2230,100, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont10)

oPrint:Say  (nRow3+2200,505 ,"N�mero do Documento",oFont8)
oPrint:Say  (nRow3+2230,605 ,aDadosTit[7]+aDadosTit[1],oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+2200,1005,"Esp�cie Doc.",oFont8)
//oPrint:Say  (nRow3+2230,1050,aDadosTit[8],oFont10) //Tipo do Titulo  
oPrint:Say  (nRow3+2230,1050,"PD",oFont10) //Tipo do Titulo

oPrint:Say  (nRow3+2200,1305,"Aceite",oFont8)
oPrint:Say  (nRow3+2230,1350,"N�O",oFont10)

oPrint:Say  (nRow3+2200,1485,"Data do Processamento",oFont8)
oPrint:Say  (nRow3+2230,1550,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao

oPrint:Say  (nRow3+2200,1810,"Nosso N�mero:",oFont8)
//cString := Alltrim(Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4))
cString := aDadosTit[6]
nCol 	 := 1840+(374-(len(cString)*22))
oPrint:Say  (nRow3+2230,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2270,100 ,"Uso do Banco",oFont8)

oPrint:Say  (nRow3+2270,505 ,"Carteira",oFont8)
//oPrint:Say  (nRow3+2300,555 ,aDadosBanco[6],oFont10)
oPrint:Say  (nRow3+2300,555 ,"CSB",oFont10)

oPrint:Say  (nRow3+2270,755 ,"Esp�cie",oFont8)
oPrint:Say  (nRow3+2300,805 ,"REAL",oFont10)

oPrint:Say  (nRow3+2270,1005,"Quantidade",oFont8)
oPrint:Say  (nRow3+2270,1485,"Valor",oFont8)

oPrint:Say  (nRow3+2270,1810,"(=) Valor do Documento",oFont8)
cString := "R$ "+Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol 	 := 1750+(374-(len(cString)*22))
oPrint:Say  (nRow3+2300,nCol,cString,oFont11c)

oPrint:Say  (nRow3+2340,100 ,"Instru��es (Todas informa��es deste bloqueto s�o de exclusiva responsabilidade do cedente)",oFont8)
oPrint:Say  (nRow3+2440,100 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99")),oFont10)
oPrint:Say  (nRow3+2490,100 ,aBolText[2]+" "+AllTrim(Transform(((aDadosTit[5]*0.01)/30),"@E 99,999.99")),oFont10)
oPrint:Say  (nRow3+2540,100 ,aBolText[3],oFont10)

oPrint:Say  (nRow3+2340,1810,"(-) Desconto/Abatimento",oFont8)
oPrint:Say  (nRow3+2410,1810,"(-) Outras Dedu��es",oFont8)
oPrint:Say  (nRow3+2480,1810,"(+) Mora/Multa",oFont8)
oPrint:Say  (nRow3+2550,1810,"(+) Outros Acr�scimos",oFont8)
oPrint:Say  (nRow3+2620,1810,"(=) Valor Cobrado",oFont8)

oPrint:Say  (nRow3+2690,100 ,"Sacado",oFont8)
//oPrint:Say  (nRow3+2720,100 ,aDatSacado[1]+" ("+aDatSacado[2]+")",oFont8n)
oPrint:Say  (nRow3+2720,100 ,aDatSacado[1],oFont8n)

if aDatSacado[8] = "J"//Se for pessoa Jur�dica
	oPrint:Say  (nRow3+2720,1500,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont8n) // CGC
Else
	oPrint:Say  (nRow3+2720,1500,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont8n) 	// CPF
EndIf

oPrint:Say  (nRow3+2750,100 ,aDatSacado[3],oFont8n)
oPrint:Say  (nRow3+2780,100 ,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont8n) // CEP+Cidade+Estado
//oPrint:Say  (nRow3+2780,1750,Substr(aDadosTit[6],1,3)+Substr(aDadosTit[6],4),oFont8n)

oPrint:Say  (nRow3+2815,100 ,"Sacador/Avalista",oFont8)
oPrint:Say  (nRow3+2855,1500,"Autentica��o Mec�nica",oFont8)

oPrint:Line (nRow3+2000,1800,nRow3+2690,1800 )
oPrint:Line (nRow3+2410,1800,nRow3+2410,2300 )
oPrint:Line (nRow3+2480,1800,nRow3+2480,2300 )
oPrint:Line (nRow3+2550,1800,nRow3+2550,2300 )
oPrint:Line (nRow3+2620,1800,nRow3+2620,2300 )
oPrint:Line (nRow3+2690,100 ,nRow3+2690,2300 )
oPrint:Line (nRow3+2850,100,nRow3+2850,2300  )

//MSBAR("INT25",25.5,1,aCB_RN_NN[1],oPrint,.F.,Nil,Nil,0.025,1.5,Nil,Nil,"A",.F.)
 
DbSelectArea("SEE")
RecLock("SEE",.f.)
	SEE->EE_FAXATU:= StrZero(Val(SEE->EE_FAXATU) + 1,6)  //Incrementa Faixa Atual na SEE010
DbUnlock()

DbSelectArea("SE1")
RecLock("SE1",.f.)
	SE1->E1_NUMBCO:= aCB_RN_NN[3]   // Nosso n�mero (Ver f�rmula para calculo)
MsUnlock()

oPrint:EndPage() // Finaliza a p�gina

Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Modulo10 � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASE DO HSBC COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Modulo11 � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER DO HSBC COM CODIGO DE BARRAS     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � Modulo11 � Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASER DO HSBC COM CODIGO DE BARRAS     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Mod11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
    If (P == 8) 
    	P := 2
    EndIf
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End

If (mod(D,11)==0 .or. mod(D,11)==1)
	D := 0
Else
	D := 11 - (mod(D,11))
End    

Return(D)







/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �Ret_cBarra� Autor � Microsiga             � Data � 13/10/03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � IMPRESSAO DO BOLETO LASE DO HSBC COM CODIGO DE BARRAS      ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cConvenio,cSequencial)

LOCAL cValorFinal := strzero(int(nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCart			:= "109"


//-----------------------------
// Definicao do NOSSO NUMERO
// ---------------------------- 
If Substr(cBanco,1,3) == "399"  // Banco HSBC
	//Nosso Numero sem digito
	cNNumSDig := StrZero(Val(SubStr(cConvenio,1,5)),5)+strzero(val(cSequencial),5)
	//Nosso Numero
	cNN := cNNumSDig + AllTrim(Str(mod11(cNNumSDig)))
Else
	cS    :=  cAgencia + cConta + cCart + cNroDoc
	nDvnn := modulo10(cS) // digito verificador Agencia + Conta + Carteira + Nosso Num
	//cNN   := cCart + cNroDoc + '-' + AllTrim(Str(nDvnn))
	cNN   := cCart + cNroDoc + AllTrim(Str(nDvnn))
EndIf

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------

cS:= cBanco + cFator +  cValorFinal + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + AllTrim(cConta) + '001'
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5,25) + AllTrim(Str(nDvnn))+ SubStr(cS,31)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DFFFFY	GGGGG.GHHHZZ	K			UUUUVVVVVVVVVV


// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCCCC = Cinco primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

//cS    := cBanco + cCart + SubStr(cNroDoc,1,2)
cS    := cBanco + SubStr(cConvenio,1,5)
nDv   := modulo10(cS)
cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      
          
          
          
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DFFFFY	GGGGG.GHHHZZ	K			UUUUVVVVVVVVVV

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero - Nr. Sequencial
//	  FFFF = Quatro primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS :=Subs(cNN,6,6) + Subs(cAgencia,1,4)
nDv:= modulo10(cS)
//cRN := cRN + AllTrim(cNN) + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '+  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) + Alltrim(Str(nDvnn))+ Subs(cAgencia,1,3) +Alltrim(Str(nDv)) + ' ' 
cRN := cRN + SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 5) + AllTrim(Str(nDv)) + '  ' 

 
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DFFFFY	GGGGG.GHHHIZ	K			UUUUVVVVVVVVVV


// 	CAMPO 3:
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = C�digo da carteira 
//	   I   = C�digo do Aplicativo
//	   Z   = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS    := Subs(cConta,1,7) +  '001'
nDv   := modulo10(cS)
cRN   := cRN + SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 5) + AllTrim(Str(nDv)) + '  '


         
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DFFFFY	GGGGG.GHHHIZ	K			UUUUVVVVVVVVVV

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '



//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DFFFFY	GGGGG.GHHHIZ	K			UUUUVVVVVVVVVV

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN   := cRN + cFator + StrZero(Int(nValor * 100),14-Len(cFator))

Return({cCB,cRN,cNN})


/*/
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSx1    � Autor � Microsiga            	� Data � 13/10/03 ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica/cria SX1 a partir de matriz para verificacao          ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Clientes Microsiga                    	  		���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
����������������������������������������������������������������������������������
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next