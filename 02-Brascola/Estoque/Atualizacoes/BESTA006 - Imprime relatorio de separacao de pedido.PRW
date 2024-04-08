#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
                      
/*/
----------------------------------------------------------------------------
PROGRAMA: BESTA006         AUTOR:                          DATA: 21/12/11
----------------------------------------------------------------------------

DESCRICAO: Imprime relatorio de separacao de pedido de venda.

----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/



USER FUNCTION BESTA006()

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Transferencia de Produto para Transportadora"
Local cPict          := ""
Local titulo         := "SEPARACAO DE PEDIDOS"
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd 			 := {}
Private Lin          := 0
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 80
Private tamanho      := "M"
Private nomeprog     := "SEPPED" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := U_CRIAPERG("SEPPED")
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "SEPPED" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aRegs    	 := {}
Private cString      := "SF2"
PRIVATE nlargura	 :=80
PRIVATE xStr		 := 40
PRIVATE  nrecuo		 :=10
Private nVolTot      := 0
Public oPrint
Private oFont16, oFont14, oFont18, oFont12, oFont10, oFont09

AADD(aRegs,{cPerg,"01","Da Nota            ?"," "," ","mv_ch1","C", 9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","","",""})
AADD(aRegs,{cPerg,"02","Ate Nota           ?"," "," ","mv_ch2","C", 9,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","","",""})
//AADD(aRegs,{cPerg,"03","Despachar em       ?"," "," ","mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","","",""})
AADD(aRegs,{cPerg,"03","Serie              ?"," "," ","mv_ch3","C", 3,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","","",""})

DBSELECTAREA("SX1")
DBSETORDER(1)

For i:= 1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next

if ! pergunte(cPerg,.T.)
	return
endif


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

//SetDefault(aReturn,cString)

//nTipo := If(aReturn[4]==1,15,18)

oPrint:= TMSPrinter():New("SEPARAÇÃO DE PEDIDOS")
oPrint:SetPortrait()

MsgRun("Gerando Visualizacao, Aguarde...","",{|| CursorWait(), RunReport(oPrint) ,CursorArrow()})

oPrint:Preview()  // Visualiza antes de imprimir


Return Nil


Static Function RunReport()

Local nOrdem

oFont09		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont09n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont11n	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)
oFont12		:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
oFont14		:= TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16		:= TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont18		:= TFont():New("Arial",18,18,,.F.,,,,.T.,.F.)

dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SetRegua(RecCount())


IF DBSEEK(XFILIAL("SF2")+MV_PAR01+MV_PAR03)
	While !EOF() .AND. SF2->F2_DOC <= MV_PAR02 .AND. SF2->F2_FILIAL == XFILIAL("SF2") .AND. SF2->F2_SERIE <= MV_PAR03
		// IncProc("Selecionando Nota Fiscal Nr.: "	+ SF2->F2_DOC )
		
		If SF2->F2_SERIE <> MV_PAR03
			DbSkip()
			Loop
		EndIf
		
		If !SF2->F2_FIMP $ 'S*T'
			DbSkip()
			Loop
		EndIf
		
		
			If SF2->F2_IMPSEP <> 0//	"Não existem dados a serem impressos.",;
				Aviso(OemToAnsi("Atenção"),OemToAnsi("Ja foram impressas ordem de separação! Da Nota fiscal"+space(2)+SF2->F2_DOC+ "!!!"),{"Ok"})
			EndIf
		
		//if SM0->M0_CODFIL = '04' //.AND.  !SF2->F2_CLIENTE $  '000004'
			
		 //	If SF2->F2_IMPSEP <> 0
		 //	    SF2->(DBSKIP())
		 //		LOOP
		 //	ENDIF
			
			/*
			If SF2->F2_EST<>'SC'
				lDifalRS:=.F.
				if sf2->F2_EST = 'RS'
					dbSelectArea("SD2")
					dbSetorder(3)
					dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
					lDifalRS:= .F.
					While !EOF() .AND. SD2->D2_FILIAL==SF2->F2_FILIAL ;
						.AND. SD2->D2_DOC==SF2->F2_DOC ;
						.AND. SD2->D2_SERIE==SF2->F2_SERIE
						
						cDifalRS:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DIFALRS")
						
						If AllTrim(cDifalRS) == '1'
							lDifalRS:= .T.
						EndIf
						
						dbSelectArea("SD2")
						dbSkip()
					EndDo
				ENDIF
				
				dbselectarea("SF2")
				
				
				IF (SF2->F2_ICMSRET > 0 .And. empty(SF2->F2_X_DTGNR)) .OR. (lDifalRS .AND. empty(SF2->F2_X_DTGNR))
					SF2->(DbSkip())
					Loop
				EndIf
			 */	
		   //	EndIf
			
		//ENDIF
		
		
		ImpCab()
		
		
		
		dbSelectArea("SD2")
		dbSetorder(3)
		If dbSeek(XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE)
			
			_cCtrlIt:=_nQuant		:= 0 
		   //	nVolTot := 0
			
			While !EOF() .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
				_cLocal		:= SD2->D2_LOCAL
				_cCod		:= SD2->D2_COD
				_cLoteCtl	:= SD2->D2_LOTECTL
				_cUm		:= SD2->D2_UM
				_nQuant		+= SD2->D2_QUANT
				_cChavLote  := SD2->D2_DOC+SD2->D2_COD+SD2->D2_LOTECTL
			   //	nVolTot 	+= SD2->D2_QUANT
				
				dbSkip()
				
				
				If EOF() .or. _cChavLote <> SD2->D2_DOC+SD2->D2_COD+SD2->D2_LOTECTL
					
					lin += 100
					oPrint:Say(lin,0005,_cLocal,oFont11)
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					
					If dbSeek(XFILIAL("SB1")+_cCod)
						oPrint:Say(lin,0120,SB1->B1_TIPO,oFont11)
					EndIf
					
					oPrint:Say(lin,0220,ALLTRIM(_cCod),oFont11)
					oPrint:Say(lin,0420,ALLTRIM(SUBSTR(SB1->B1_DESC,1,50)),oFont11)
					oPrint:Say(lin,1500,_cLoteCtl,oFont11)      //1300
					oPrint:Say(lin,1740,ALLTRIM(_cUM),oFont11)
					oPrint:Say(lin,1900,STR(_nQuant,9,2),oFont11)
					oPrint:Say(lin,2100,"______________",oFont11)
					
					_nQuant		:= 0
					_cCtrlIt++
					If _cCtrlIt>15
						If SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE
							oPrint:EndPage() 		// Finaliza a pagina
							IMPCAB()
						EndIf
						_cCtrlIt:=0
					EndIf
				EndIf
				
				dbSelectArea("SD2")
			EndDo
			
			lin += 5
			oPrint:Say(lin,0000,Replicate("_",80),oFont16)
			lin += 80
			oPrint:Say(lin,0005,"Descricao dos Volumes: " + ALLTRIM(STR(SF2->F2_VOLUME1)) + " " + SF2->F2_ESPECI1,oFont11)    
			//oPrint:Say(lin,0005,"Descricao dos Volumes: " +ALLTRIM(STR(nVolTot))+ " " + SF2->F2_ESPECI1,oFont11)
			lin += 100
			oPrint:Say(lin,0005,"Peso Liquido: " +  ALLTRIM(STR(SF2->F2_PLIQUI)) ,oFont11)
			oPrint:Say(lin,1200,"Peso Bruto: " + ALLTRIM(STR(SF2->F2_PBRUTO)) ,oFont11)
			lin += 100
			oPrint:Say(lin,0005,"Separado Por: ______________________________",oFont11)
			oPrint:Say(lin,1200,"Conferido Por: _____________________________",oFont11)
			
			
			// imprime "GERADO PIN"  PARA  A1_SUFRAMA <> ''
			cSuframa:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_SUFRAMA")
			
			If !Empty(cSuframa)
				lin += 80
				oPrint:Say(lin,0005,"Aguardando Geracao de P I N ______________________________",oFont14)
			EndIf
			
		EndIf
		
		oPrint:EndPage() 		// Finaliza a pagina
		
		dbSelectArea("SF2")
		
		// GRAVA NUMERO DE IMPRESSOES DO RELATORIO
		RECLOCK("SF2",.F.)
		F2_IMPSEP := F2_IMPSEP + 1
		MSUNLOCK()
		
		
		SF2->(dbSkip()) // Avanca o ponteiro do registro no arquivo
		
	EndDo
	
EndIf

RETURN



Static Function impcab()
************************

oPrint:StartPage() 		// Inicia uma nova pagina
lin := 045
oPrint:SayBitmap(lin,0005,"LGRL01.BMP",237,58)
oPrint:SayBitmap(lin,2050,"LOGO.BMP"    ,237,58)
oPrint:Say(lin,0800,"SEPARAÇÃO DE PEDIDOS" ,oFont16)
lin += 048
oPrint:Say(lin,0005,"Empresa: "+SM0->M0_NOME,oFont14)
oPrint:Say(lin,2000,"Data: "+DtoC(Date())/*SM0->M0_NOME*/,oFont14)
lin += 020
oPrint:Say(lin,0000,REPLICATE("_",80),oFont16)
DBSELECTAREA("SA4")
DBSETORDER(1)

IF DBSEEK(XFILIAL("SA4")+ALLTRIM(SF2->F2_TRANSP))
	lin += 100
	oPrint:Say(lin,1000,"TRANSPORTADORA: " + SA4->A4_COD + '--> ' + SA4->A4_NREDUZ,oFont16)
ENDIF

IF !Empty(SF2->F2_REDESP)
	IF DBSEEK(XFILIAL("SA4")+ALLTRIM(SF2->F2_REDESP))
		lin += 070
		oPrint:Say(lin,1000,"REDESPACHO: " + SA4->A4_COD + '--> ' + SA4->A4_NREDUZ,oFont14)
	ENDIF
EndIf

Lin += 050
//MSBAR("CODE3_9",3.6,16.2,SF2->F2_SERIE+SF2->F2_DOC,oPrint,.F.,,,0.025,0.9,,,"E",.F.)
MSBAR("CODE3_9",3.6,15,SF2->F2_SERIE+SF2->F2_DOC,oPrint,.F.,,,0.025,0.9,,,"E",.F.)


dbSelectArea("SF2")
dbSetOrder(1)

lin += 100

oPrint:Say(lin,0005,"Nota Nr.: " + RTRIM(SF2->F2_DOC),oFont11)
oPrint:Say(lin,0400,"Serie: " + SF2->F2_SERIE,oFont11)
//oPrint:Say(lin,1200,"Despachar em: " + DTOC(MV_PAR03),oFont11)
oPrint:Say(lin,1200,"Despachar em: " + DTOC(SF2->F2_EMISSAO),oFont11)

DBSELECTAREA("SA3")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA3")+SF2->F2_VEND1)
	lin += 70
	oPrint:Say(lin,0005,"Representante: " + SF2->F2_VEND1 + " " + SA3->A3_NREDUZ,oFont11)
ENDIF

DBSELECTAREA("SA1")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)
	lin += 70
	//Fernando:oPrint:Say(lin,0005,"Cliente: " + SA1->A1_COD + " " + SA1->A1_LOJA + " " + SA1->A1_NREDUZ,oFont11)
	oPrint:Say(lin,0005,"Cliente: " + SA1->A1_COD + " " + SA1->A1_LOJA + " " + SA1->A1_NOME,oFont11)  
	oPrint:Say(lin,1200,"Telefone: " + TRANSFORM(SA1->A1_TEL,"@R 9999-9999"),oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Endereço: " + SUBSTR(SA1->A1_END,1,50),oFont11)
	oPrint:Say(lin,1200,"Bairro: " + SA1->A1_BAIRRO,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Cidade: " + SUBSTR(SA1->A1_MUN,1,50),oFont11)
	oPrint:Say(lin,1200,"Estado: " + SA1->A1_EST ,oFont11)
	oPrint:Say(lin,1600,"CEP: " + SA1->A1_CEP ,oFont11)
	oPrint:Say(lin,2000,"País: " ,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"CNPJ / CGC: " + Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont11)
	oPrint:Say(lin,1200, "Insc. Est.: " + SA1->A1_INSCR,oFont11)
ENDIF

DBSELECTAREA("SA4")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SA4")+ALLTRIM(SF2->F2_TRANSP))
	lin += 100
	oPrint:Say(lin,0005,"Nome: " + SA4->A4_COD + "-"+SA4->A4_NREDUZ,oFont11)
	oPrint:Say(lin,1200,"Telefone: " + TRANSFORM(SA4->A4_TEL,"@R 9999-9999"),oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Endereço: " + SUBSTR(SA4->A4_END,1,50),oFont11)
	oPrint:Say(lin,1200,"Bairro: " + SA4->A4_BAIRRO,oFont11)
	lin += 70
	oPrint:Say(lin,0005,"Cidade: " + SA4->A4_MUN,oFont11)
	oPrint:Say(lin,1200,"Estado: " + SA4->A4_EST,oFont11)
	oPrint:Say(lin,1600,"CEP: " + SA4->A4_CEP,oFont11)
	oPrint:Say(lin,2000,"País: ",oFont11)
	lin += 70
	oPrint:Say(lin,0005,"CNPJ / CPF: " + Transform(SA4->A4_CGC,"@R 99.999.999/9999-99"),oFont11)
	oPrint:Say(lin,1200,"Ins. Est.: " + SA4->A4_INSEST,oFont11)
ENDIF

lin += 5
oPrint:Say(lin,0000,REPLICATE("_",80),oFont16)
lin += 80
//oPrint:Say(lin,0005,"DEP  TIPO  ITEM        DESCRIÇÃO                                                        LOTE/SERIE/REFER       UN QTD ALOCADA QTD SEPARADA",oFont11)
oPrint:Say(lin,0005,"DEP  TIPO  ITEM        DESCRIÇÃO                                                                               LOTE       UN QTD ALOCADA QTD SEPARADA",oFont11)
lin += 25
oPrint:Say(lin,0005,"____  ____  _____      _______________________________________ ____________________  __ _____________  ______________",oFont11)

Return
