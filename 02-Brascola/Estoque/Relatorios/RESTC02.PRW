#INCLUDE "FIVEWIN.CH"
#INCLUDE "DBTREE.CH"
#INCLUDE "MSGRAPHI.CH"
#INCLUDE "COLORS.CH"

USER FUNCTION 	RESTC02()

MSGRUN("Aguarde....","Processando",{ || RESTC02A()})

RETURN(.T.)	/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RESTC02  ³ Autor ³ TI-2399 ARTUR DA COSTA   ³ Data ³ 24/11/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rastreabilidade por Lote/Produto/Cliente/Documento            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC FUNCTION RESTC02A()

LOCAL cQuery := ""
LOCAL aRegs  := {}
LOCAL cPerg  := U_CriaPerg("RESC02")
LOCAL cAlias := "RST"
LOCAL cProIni:= ""
LOCAL cProFin:= ""
LOCAL cLotIni:= ""
LOCAL cLotFin:= ""
LOCAL cCliIni:= ""
LOCAL cCliFin:= ""
LOCAL cDocIni:= ""
LOCAL cDocFin:= ""


Local oDlg, oListBox, oFont
Local oOk      	:= LoadBitMap(GetResources(),"LBTIK")		// marcação da listbox para itens
Local oNo      	:= LoadBitMap(GetResources(),"NADA")		// marcação da listbox para total
Local lRet		:= .T.										// Controle de retorno da rotina
Local nLoop1	:= 0										// Contador de loops
Local aList		:= {}										// Array com os dados a serem exibidos
Local aTitulo	:= {"Filial ", "Num. Lote", "Produto", "Desc.Produto", "Quantidade", "Data Val.Lote", "Potencia", "Numero Docto", "Cod.Cliente", "Nome Cliente", "Data Docto", "Loja", "Armazem", "Lote Fornecedor","Saldo Lote" }				// Array com os t'tiulos da janela listbox
Local cListBox	:= ""
Local cCadastro:= ""

AADD(aRegs,{cPerg,"01","Codigo Produto  ?","Codigo Produto  ?","Codigo Produto  ?","mv_ch2","C",15,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SB1","","","",""})
AADD(aRegs,{cPerg,"02","Lote Numero     ?","Lote Numero   ?"  ,"Lote Numero   ?"  ,"mv_ch3","C",10,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB8001","","","",""})
AADD(aRegs,{cPerg,"03","Cod. Cliente    ?","Cod. Cliente    ?","Cod. Cliente    ?","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
AADD(aRegs,{cPerg,"04","Doc.Numero      ?","Doc.Numero    ?"  ,"Doc.Numero    ?"  ,"mv_ch5","C",9,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","",""})
lValidPerg(aRegs)

If !Pergunte(cPerg,.T.)
	Return
EndIf

If Empty(mv_par01)
	cProIni	:= Replic(' ',TAMSX3("D5_PRODUTO")[1])
	cProFin	:= Replic('z',TAMSX3("D5_PRODUTO")[1])
Else
	cProIni	:= mv_par01
	cProFin	:= mv_par01
EndIf

If Empty(mv_par02)
	cLotIni	:= Replic(' ',TAMSX3("D5_LOTECTL")[1])
	cLotFin	:= Replic('z',TAMSX3("D5_LOTECTL")[1])
Else
	cLotIni	:= mv_par02
	cLotFin	:= mv_par02
EndIf

If Empty(mv_par03)
	cCliIni	:= Replic(' ',TAMSX3("D5_CLIFOR")[1])
	cCliFin	:= Replic('z',TAMSX3("D5_CLIFOR")[1])
Else
	cCliIni	:= mv_par03
	cCliFin	:= mv_par03
EndIf


If Empty(mv_par04)
	cDocIni	:= Replic(' ',TAMSX3("D5_DOC")[1])
	cDocFin	:= Replic('z',TAMSX3("D5_DOC")[1])
Else
	cDocIni	:= mv_par04
	cDocFin	:= mv_par04
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta Query³
//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
cQry := "SELECT D5_FILIAL,D5_PRODUTO,D5_LOCAL,D5_LOTEFOR,D5_POTENCI,D5_DOC,D5_DATA,D5_CLIFOR,A1_NOME,A1_LOJA,B1_DESC,B8_LOTECTL,B8_DTVALID,B8_SALDO, SUM(D5_QUANT) AS D5_QUANT"
cQry += " FROM "+RetSqlName("SD5")+" SD5"
cQry += ", " + RetSqlName("SD2")+ " SD2"
cQry += ", " + RetSqlName("SA1")+ " SA1"
cQry += ", " + RetSqlName("SB1")+ " SB1"
cQry += ", " + RetSqlName("SB8")+ " SB8"
cQry += " WHERE SD5.D5_FILIAL = '"+xFilial("SD5")+"'"

cQry += " AND SD5.D5_PRODUTO BETWEEN '" +cProIni+"' AND '"+cProFin+"'"
cQry += " AND SD5.D5_LOTECTL BETWEEN '" +cLotIni+"' AND '"+cLotFin+"'"
cQry += " AND SD5.D5_CLIFOR BETWEEN '" +cCliIni+"' AND '"+cCliFin+"'"
cQry += " AND SD5.D5_DOC BETWEEN '" +cDocIni+"' AND '"+cDocFin+"'"

cQry += " AND SD5.D_E_L_E_T_<> '*'"

cQry += " AND SD2.D2_FILIAL = SD5.D5_FILIAL"
cQry += " AND SD2.D2_DOC = SD5.D5_DOC"
cQry += " AND SD2.D2_SERIE = SD5.D5_SERIE"
cQry += " AND SD2.D2_LOCAL = SD5.D5_LOCAL"
cQry += " AND SD2.D_E_L_E_T_<> '*'"

cQry += " AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
cQry += " AND SA1.A1_COD = SD5.D5_CLIFOR"
cQry += " AND SA1.A1_LOJA = SD5.D5_LOJA"
cQry += " AND SA1.D_E_L_E_T_<> '*'"

cQry += " AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
cQry += " AND SB1.B1_COD = SD5.D5_PRODUTO"
cQry += " AND SB1.D_E_L_E_T_<> '*'"


cQry += " AND SB8.B8_FILIAL = '"+xFilial("SB8")+"'"
cQry += " AND SB8.B8_PRODUTO = SB1.B1_COD"
cQry += " AND SB8.B8_LOCAL = SD5.D5_LOCAL"
cQry += " AND SB8.B8_LOTECTL = SD5.D5_LOTECTL"
cQry += " AND SB8.B8_DTVALID = SD5.D5_DTVALID"
cQry += " AND SB8.B8_NUMLOTE = SD5.D5_NUMLOTE"
cQry += " AND SB8.D_E_L_E_T_<> '*'"

cQry += " GROUP BY D5_FILIAL,D5_PRODUTO,D5_LOCAL,D5_LOTEFOR,D5_POTENCI,D5_DOC,D5_DATA,D5_CLIFOR,A1_NOME,A1_LOJA,B1_DESC,B8_LOTECTL,B8_DTVALID,B8_SALDO"


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava query no diretorio             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cQry := ChangeQuery(cQry)
//MemoWrite("\QUERYSYS\RASTRO.SQL",cQry)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),'RST',.F.,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta os dados da ListBox            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("RST")
dbGoTop()
While !Eof()
	aAdd( aList, { RST->D5_FILIAL,;    //1
	RST->B8_LOTECTL,;		//2
	RST->D5_PRODUTO,;		//3
	RST->B1_DESC,;			//4
	RST->D5_QUANT,;		//5
	RST->B8_DTVALID,;		//6
	RST->D5_POTENCI,;		//7
	RST->D5_DOC,;			//8
	RST->D5_CLIFOR,;		//9
	RST->A1_NOME,;			//10
	RST->D5_DATA,;			//11
	RST->A1_LOJA,;			//12
	RST->D5_LOCAL,;	  	//13
	RST->D5_LOTEFOR,;		//14
	RST->B8_SALDO})		//15
	
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ordena array pela data de forma descendente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aList,,, { |x, y| x[11] < y[11] } )

dbSelectArea("RST")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta display  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Len(aList) > 0
	
	DEFINE MSDIALOG oDlg TITLE "Consulta Rastro" From 9,0 To 30,125 OF oMainWnd
	
	If !Empty(Alltrim(mv_par01))
	
	
//	@ 04,  5 Say 'Cod.Produto:' 	Of oDlg Size  30,8 Pixel 
		
		
		
 //		@ 18,  5 Say "Descricao:" 		Of oDlg Size  30,8 Pixel
		
	//	@ 04, 40 MsGet aList	[1,3]	 Size 158,8 Pixel When .F.
	//	@ 18, 40 MsGet aList [1,4]		 Size 158,8 Pixel When .F.
		
		DEFINE SBUTTON FROM    130,455 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg
		
		@ 3,.7 LISTBOX oListBox VAR cListBox Fields HEADER aTitulo[1], aTitulo[2], aTitulo[5], aTitulo[6], aTitulo[7], aTitulo[8], aTitulo[9], aTitulo[10], aTitulo[11], aTitulo[12], aTitulo[13], aTitulo[14], aTitulo[15] SIZE 485,80
		
		oListBox:SetArray(aList)
		oListBox:bLine := { || {	aList[oListBox:nAt,1],;
		aList[oListBox:nAt,2],;
		aList[oListBox:nAt,5],;
		STOD(aList[oListBox:nAt,6]),;
		aList[oListBox:nAt,7],;
		aList[oListBox:nAt,8],;
		aList[oListBox:nAt,9],;
		aList[oListBox:nAt,10],;
		STOD(aList[oListBox:nAt,11]),;
		aList[oListBox:nAt,12],;
		aList[oListBox:nAt,13],;
		aList[oListBox:nAt,14],;
		aList[oListBox:nAt,15]}}
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
	ElseIf !Empty(mv_par02)
//		@ 04,  5 Say "Lote :" Of oDlg Size  50,8 Pixel
//		@ 04,120 Say "Potencia:" Of oDlg Size  30,8 Pixel
//		@ 18,  5 Say "Saldo do Lote:" Of oDlg Size  40,8 Pixel
//		@ 18,120 Say "Validade do Lote:" Of oDlg Size  50,8 Pixel
//		@ 32,  5 Say "Produto:" Of oDlg Size  50,8 Pixel
		
		@ 4, 45 MsGet aList	[1,2]  	 Size  65,8 Pixel When .F.
		@ 4,193 MsGet aList	[1,7]	 Size  15,8 Pixel When .F.
		@ 18, 45 MsGet aList	[1,15] 	 	 Size  40,8 Pixel When .F. Right
		@ 18,168 MsGet StoD(aList	[1,6])	 Size  40,8 Pixel When .F. Center
		@ 32,45 MsGet aList [1,4]		 Size 163,8 Pixel When .F.
		
		DEFINE SBUTTON FROM    140,455	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg
		
		@ 3.5,.7 LISTBOX oListBox VAR cListBox Fields HEADER aTitulo[1], aTitulo[3], aTitulo[5], aTitulo[8], aTitulo[9], aTitulo[10], aTitulo[11], aTitulo[12], aTitulo[13], aTitulo[14] SIZE 485,80
		oListBox:SetArray(aList)
		oListBox:bLine := { || {	aList[oListBox:nAt,1],;
		aList[oListBox:nAt,3],;
		aList[oListBox:nAt,5],;
		aList[oListBox:nAt,8],;
		aList[oListBox:nAt,9],;
		aList[oListBox:nAt,10],;
		STOD(aList[oListBox:nAt,11]),;
		aList[oListBox:nAt,12],;
		aList[oListBox:nAt,13],;
		aList[oListBox:nAt,14]}}
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
	ElseIf !Empty(mv_par03)
//  		@ 04, 5 Say "Cod.Cliente:" Of oDlg Size  50,8 Pixel
//		@ 18, 5 Say "Nome Cliente:" Of oDlg Size  30,8 Pixel
//		
//		@ 04, 50 MsGet aList	[1,9]  	 Size  65,8 Pixel When .F.
//		@ 18, 50 MsGet aList	[1,10]  	 Size  65,8 Pixel When .F.
		
		
		DEFINE SBUTTON FROM    130,455 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg
		
		@ 3,.7 LISTBOX oListBox VAR cListBox Fields HEADER aTitulo[1], aTitulo[2], aTitulo[3], aTitulo[4], aTitulo[5], aTitulo[6], aTitulo[7], aTitulo[8], aTitulo[11], aTitulo[12], aTitulo[13], aTitulo[14], aTitulo[15] SIZE 485,80
		oListBox:SetArray(aList)
		oListBox:bLine := { || {	aList[oListBox:nAt,1],;
		aList[oListBox:nAt,2],;
		aList[oListBox:nAt,3],;
		aList[oListBox:nAt,4],;
		aList[oListBox:nAt,5],;
		STOD(aList[oListBox:nAt,6]),;
		aList[oListBox:nAt,7],;
		aList[oListBox:nAt,8],;
		STOD(aList[oListBox:nAt,11]),;
		aList[oListBox:nAt,12],;
		aList[oListBox:nAt,13],;
		aList[oListBox:nAt,14],;
		aList[oListBox:nAt,15]}}
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		
	ElseIf !Empty(mv_par04)
  	 //	@ 04, 5 Say "Documento N.:" Of oDlg Size  50,8 Pixel
		
//		@ 04, 50 MsGet aList	[1,8]  	 Size  65,8 Pixel When .F.
		
		DEFINE SBUTTON FROM    130,455 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg
		
		@ 3,.7 LISTBOX oListBox VAR cListBox Fields HEADER aTitulo[1], aTitulo[2], aTitulo[3], aTitulo[4], aTitulo[5], aTitulo[6], aTitulo[7], aTitulo[9], aTitulo[10], aTitulo[11], aTitulo[12], aTitulo[13], aTitulo[14], aTitulo[15] SIZE 485,80
		oListBox:SetArray(aList)
		oListBox:bLine := { || {	aList[oListBox:nAt,1],;
		aList[oListBox:nAt,2],;
		aList[oListBox:nAt,3],;
		aList[oListBox:nAt,4],;
		aList[oListBox:nAt,5],;
		STOD(aList[oListBox:nAt,6]),;
		aList[oListBox:nAt,7],;
		aList[oListBox:nAt,9],;
		aList[oListBox:nAt,10],;
		STOD(aList[oListBox:nAt,11]),;
		aList[oListBox:nAt,12],;
		aList[oListBox:nAt,13],;
		aList[oListBox:nAt,14],;
		aList[oListBox:nAt,15]}}
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
	Else
		Aviso(cCadastro, "Mensagem",{"&Ok"},,"Sem Dados")
	Endif
EndIf

Return(lRet)