#include "protheus.ch" 
#include "topconn.ch"
#include "colors.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BFATPR001 �Autor  � Marcelo da Cunha   � Data �  26/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para visualizar pedido de venda de forma customizada���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MA410COR()
**********************
LOCAL aRet	:= PARAMIXB

//Status dos Pedidos de Venda
//////////////////////////////
If SC5->(FieldPos("C5_BLQ")) == 0
	aRet := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.C5_QTDPEN==0",'ENABLE' },;			//Pedido em Aberto
				{ "(!Empty(C5_NOTA) .And. Empty(C5_CANCELA)) .Or.C5_LIBEROK=='E'",'DISABLE'},;//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And.C5_QTDPEN==0",'BR_AMARELO'},;		//Pedido Liberado
				{"C5_QTDPEN<>0","BR_CINZA"},; 																//Pedido Parcial
				{"C5_NOTA == 'XXXXXX'","BR_PRETO"} }														//Pedido Excluido
Else
	aRet := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ) .And. C5_QTDPEN==0",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).AND. Empty(C5_CANCELA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ) .And. C5_QTDPEN==0",'BR_AMARELO'},;//Pedido Liberado
				{ "C5_BLQ == '1' .And. C5_QTDPEN==0",'BR_AZUL'},;	 															//Pedido Bloquedo por regra
				{ "C5_BLQ == '2' .And. C5_QTDPEN==0",'BR_LARANJA'},; 															//Pedido Bloquedo por verba
				{"C5_QTDPEN<>0","BR_CINZA"} ,; 																						//Pedido Parcial
				{" C5_NOTA == 'XXXXXX' .And. C5_CANCELA == 'S'","BR_PRETO"} }  											//Pedido Excluido
Endif               

//Adiciona o bot�o de situa��o no array aRotina
///////////////////////////////////////////////
Aadd(aRotina,{"Visual. Brascola" ,"U_E410VISU"  ,2,0,0})
Aadd(aRotina,{"Situa��o Pedido"  ,"U_A410SITUA" ,2,0,0})
  
Return(aRet)

User Function A410Situa(cAlias,nReg,nOpc)
*************************************
//������������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                                �
//��������������������������������������������������������������������������
LOCAL nI       		:= 0
LOCAL cTitulo  		:= OemToAnsi("Situacao do Pedido de Venda "+SC5->C5_NUM+" - Filial "+SC5->C5_FILIAL)
LOCAL nOpc     		:= 0
LOCAL aTitulo  		:= {"Situacao", "Valor (R$)"}
LOCAL oListBox
LOCAL oSay
LOCAL oDlg
LOCAL aDados			:= {}
LOCAL cPedido			:= SC5->C5_NUM
LOCAL cQuery			:= ""
LOCAL nValaLib			:= 0.00
//������������������������������������������������������������������������Ŀ
//� Alimenta o array com os status do pedido de venda                      �
//��������������������������������������������������������������������������
Aadd(aDados, {Padr("Bloqueio por regra",60),0.00})
Aadd(aDados, {Padr("Bloqueio por cr�dito",60),0.00})
Aadd(aDados, {Padr("Sem estoque",60),0.00})
Aadd(aDados, {Padr("Liberados para faturamento",60),0.00})
Aadd(aDados, {Padr("Em aberto",60),0.00})
Aadd(aDados, {Padr("Faturados",60),0.00})
Aadd(aDados, {Padr("",60),0.00})
Aadd(aDados, {Padr("Total do Pedido",60),0.00})
//������������������������������������������������������������������������Ŀ
//� Soma o total de pedidos bloqueados por regra                           �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM((C6_QTDVEN-C6_QTDENT)*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND C6_BLOQUEI = '01'"
cQuery += " AND D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[1,2] := Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//������������������������������������������������������������������������Ŀ
//� Soma o total de pedidos bloqueados por credito                         �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND C6_BLOQUEI = '  '"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED NOT IN('  ','10')"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[2,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//������������������������������������������������������������������������Ŀ
//� Soma o total de pedidos bloqueados por estoque                         �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '  '"
cQuery += " AND C9_BLEST NOT IN('  ','10')"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[3,2]	:= Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//������������������������������������������������������������������������Ŀ
//� Soma o total de pedidos liberados para faturamento                     �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '  '"
cQuery += " AND C9_BLEST = '  '"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[4,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//������������������������������������������������������������������������Ŀ
//� Soma o total de pedidos faturados                                      �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM(C9_QTDLIB*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK),"
cQuery += "      "+RetSqlName("SC9")+" SC9 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
cQuery += " AND C9_FILIAL = '"+xFilial("SC9")+"'"
cQuery += " AND C9_PEDIDO = C6_NUM"
cQuery += " AND C9_ITEM = C6_ITEM"
cQuery += " AND C9_BLCRED = '10'"
cQuery += " AND C9_BLEST = '10'"
cQuery += " AND SC9.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[6,2] := Abs(SC6TRB->TOTAL)
nValaLib		+= Abs(SC6TRB->TOTAL)
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
//������������������������������������������������������������������������Ŀ
//� Soma o total do pedido                                                 �
//��������������������������������������������������������������������������
cQuery := " SELECT SUM(C6_QTDVEN*C6_PRCVEN) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC6")+" SC6 (NOLOCK)"
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
cQuery += " AND C6_NUM = '"+cPedido+"'"
cQuery += " AND SC6.D_E_L_E_T_ <> '*'"
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif
TcQuery cQuery New Alias "SC6TRB"
DbSelectArea("SC6TRB")
DbGoTop()
aDados[8,2] := Abs(SC6TRB->TOTAL)
//������������������������������������������������������������������������Ŀ
//� Total a liberar                                                        �
//��������������������������������������������������������������������������
aDados[5,2] := Abs(SC6TRB->TOTAL) - nValaLib
If Select("SC6TRB") > 0
	DbSelectArea("SC6TRB")
	DbCloseArea()
Endif

//������������������������������������������������������������������������Ŀ
//� Monta a tela de selecao                                                �
//��������������������������������������������������������������������������
If Len(aDados) > 0
   DEFINE MSDIALOG oDlg TITLE cTitulo From 9,0 To 25,070 OF oMainWnd 
   @ .1,.1 LISTBOX oListBox VAR cListBox FIELDS HEADER OemtoAnsi(aTitulo[1]),OemtoAnsi(aTitulo[2]) SIZE 240,119
   oListBox:SetArray(aDados)
   oListBox:bLine := { || { aDados[oListBox:nAt,1],iif(oListBox:nAt<>7,Transform(aDados[oListBox:nAt,2],"@E 999,999,999.99"),"")}}
   DEFINE SBUTTON FROM    4,245 	TYPE 1  ACTION (nOpc := 1,oDlg:End()) ENABLE OF oDlg 
   DEFINE SBUTTON FROM 18.5,245 	TYPE 2  ACTION (nOpc := 0,oDlg:End()) ENABLE OF oDlg
   ACTIVATE MSDIALOG oDlg CENTERED
Endif

Return

User Function E410VISU(cAlias,nReg,nOpc)
************************************
LOCAL aArea    := GetArea()
LOCAL aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
LOCAL aCpos2   := {}
LOCAL aBackRot := aClone(aRotina)
LOCAL aPosObj  := {}
LOCAL aObjects := {}
LOCAL aSize    := {}
LOCAL aPosGet  := {}
LOCAL aInfo    := {}

LOCAL lContinua:= .T.
LOCAL lGrade   := MaGrade()
LOCAL lQuery   := .F.
LOCAL lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

LOCAL nGetLin  := 0
LOCAL nOpcA    := 0
LOCAL nTotPed  := 0
LOCAL nTotDes  := 0
LOCAL nCntFor  := 0
LOCAL nNumDec  := TamSX3("C6_VALOR")[2]
LOCAL nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

LOCAL cArqQry  := "SC6"
LOCAL cCadastro:= IIF(cCadastro == Nil,OemToAnsi("STR0007"),cCadastro) //"Atualiza��o de Pedidos de Venda"
LOCAL oGetd
LOCAL oSAY1
LOCAL oSAY2
LOCAL oSAY3
LOCAL oSAY4
LOCAL oDlg
LOCAL lMt410Ace:= Existblock("MT410ACE")

LOCAL bCond     := {|| .T. }
LOCAL bAction1  := {|| Mta410Vis(cArqQry,@nTotPed,@nTotDes,lGrade) }	
LOCAL bAction2  := {|| .T. }
LOCAL cSeek     := ""
LOCAL aNoFields := {"C6_NUM","C6_QTDEMP","C6_QTDENT","C6_QTDEMP2","C6_QTDENT2"}		// Campos que nao devem entrar no aHeader e aCols
LOCAL bWhile    := {|| }
LOCAL cQuery    := ""
LOCAL lGrdOk	 := If(lGrade.And.MatOrigGrd()=="SB4",If(FindFunction("VldDocGrd"),VldDocGrd(1,SC5->C5_NUM),.T.),.T.)
LOCAL aRecnoSE1RA
LOCAL aHeadAGG  := {}
LOCAL aColsAGG  := {}

//������������������������������������������������������Ŀ
//� Inicializa a Variaveis Privates.                     �
//��������������������������������������������������������
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	:= {}
PRIVATE aCols	   := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
PRIVATE aGEMCVnd  := {"",{},{}} //Template GEM - Condicao de Venda 
PRIVATE oGetPV	   := Nil

//���������������������������������������������������Ŀ
//�Verifica se o campo de codigo de lancamento cat 83 �
//�deve estar visivel no acols                        �
//�����������������������������������������������������
If SC6->(FieldPos("C6_CODLAN"))>0 .and. !SuperGetMV("MV_CAT8309",,.F.)
	aAdd(aNoFields,"C6_CODLAN")
EndIf

//�����������������������������������������������������������Ŀ
//� Ponto de entrada para validar acesso do usuario na funcao �
//�������������������������������������������������������������
If lMt410Ace
	lContinua := Execblock("MT410ACE",.F.,.F.,{nOpc})
Endif

//������������������������������������������������������Ŀ
//� Cria Ambiente/Objeto para tratamento de grade        �
//��������������������������������������������������������        
If FindFunction("MsMatGrade") .And. IsAtNewGrd()
	PRIVATE oGrade := MsMatGrade():New('oGrade',,"C6_QTDVEN",,"a410GValid()",;
					{{VK_F4,{|| A440Saldo(.T.,oGrade:aColsAux[oGrade:nPosLinO][aScan(oGrade:aHeadAux,{|x| AllTrim(x[2])=="C6_LOCAL"})])}} },;
					{{"C6_QTDVEN",NIL,NIL},{"C6_QTDLIB",NIL,NIL},{"C6_QTDENT",NIL,NIL},{"C6_ITEM",NIL,NIL},{"C6_UNSVEN",NIL,NIL},{"C6_OPC",NIL,NIL},{"C6_BLQ",NIL,NIL}})

	//-- Inicializa grade multicampo
	A410InGrdM()
Else
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
EndIf

If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf
Pergunte("MTA410",.F.) 
//Carrega as variaveis com os parametros da execauto
Ma410PerAut()

If ( lGrade )
	aRotina[nOpc][4] := 6
EndIf

If lGrdOk
	//������������������������������������������������������Ŀ
	//� Inicializa a Variaveis da Enchoice.                  �
	//��������������������������������������������������������
	RegToMemory( "SC5", .F., .F. )
	
	//������������������������������������������������������Ŀ
	//� Filtros para montagem do aCols                       �
	//��������������������������������������������������������
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))
	
		dbSelectArea("SC6")
		dbCloseArea()
	#ENDIF
	cSeek  := xFilial("SC6")+SC5->C5_NUM
	bWhile := {|| C6_FILIAL+C6_NUM }
	
	//�������������������������������������������������������Ŀ
	//� Montagem do aHeader e aCols                           �
	//���������������������������������������������������������
	//������������������������������������������������������������������������������������������������������������Ŀ
	//�FillGetDados( nOpcx, cAlias, nOrder, cSeekKey, bSeekWhile, uSeekFor, aNoFields, aYesFields, lOnlyYes,       �
	//�				  cQuery, bMountFile, lInclui )                                                                �
	//�nOpcx			- Opcao (inclusao, exclusao, etc).                                                         �
	//�cAlias		- Alias da tabela referente aos itens                                                          �
	//�nOrder		- Ordem do SINDEX                                                                              �
	//�cSeekKey		- Chave de pesquisa                                                                            �
	//�bSeekWhile	- Loop na tabela cAlias                                                                        �
	//�uSeekFor		- Valida cada registro da tabela cAlias (retornar .T. para considerar e .F. para desconsiderar �
	//�				  o registro)                                                                                  �
	//�aNoFields	- Array com nome dos campos que serao excluidos na montagem do aHeader                         �
	//�aYesFields	- Array com nome dos campos que serao incluidos na montagem do aHeader                         �
	//�lOnlyYes		- Flag indicando se considera somente os campos declarados no aYesFields + campos do usuario   �
	//�cQuery		- Query para filtro da tabela cAlias (se for TOP e cQuery estiver preenchido, desconsidera     �
	//�	           parametros cSeekKey e bSeekWhiele)                                                              �
	//�bMountFile	- Preenchimento do aCols pelo usuario (aHeader e aCols ja estarao criados)                     �
	//�lInclui		- Se inclusao passar .T. para qua aCols seja incializada com 1 linha em branco                 �
	//�aHeaderAux	-                                                                                              �
	//�aColsAux		-                                                                                              �
	//�bAfterCols	- Bloco executado apos inclusao de cada linha no aCols                                         �
	//�bBeforeCols	- Bloco executado antes da inclusao de cada linha no aCols                                     �
	//�bAfterHeader -                                                                                              �
	//�cAliasQry	- Alias para a Query                                                                           �
	//��������������������������������������������������������������������������������������������������������������
	FillGetDados(nOPc,"SC6",1,cSeek,bWhile,{{bCond,bAction1,bAction2}},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,/*bMontCols*/,.F.,/*aHeaderAux*/,/*aColsAux*/,{|| AfterCols(cArqQry) },/*bBeforeCols*/,/*bAfterHeader*/,"SC6")
	
	If FindFunction("MATGRADE_V") .And. MATGRADE_V() >= 20110425 .And. "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"") .And. lGrade
		aCols := aColsGrade(oGrade,aCols,aHeader,"C6_PRODUTO","C6_ITEM","C6_ITEMGRD",aScan(aHeader,{|x| AllTrim(x[2]) == "C6_DESCRI"}))
	EndIf

	If AliasInDic("AGG")
		A410FRat(@aHeadAGG,@aColsAGG)	
	EndIf
	
	If lQuery
		dbSelectArea("SC6")
		dbCloseArea()
		ChkFile("SC6",.F.)
	EndIf	
	
	For nCntFor := 1 To Len(aHeader)
		If aHeader[nCntFor][8] == "M"
			aadd(aCpos1,aHeader[nCntFor][2])
		EndIf
	Next nCntFor

	nTotDes += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
	nTotPed -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")	
	nTotPed -= M->C5_DESCONT
	nTotDes += M->C5_DESCONT

	If (lQuery)
		dbSelectArea(cArqQry)
		dbCloseArea()
		ChkFile("SC6",.F.)
		dbSelectArea("SC6")
	EndIf

	//�����������������������������������������������Ŀ
	//�Monta o array com as formas de pagamento       �
	//�������������������������������������������������
	Ma410MtFor(@aHeadFor,@aColsFor)

	//������������������������������������������������������Ŀ
	//� Caso nao ache nenhum item , abandona rotina.         �
	//��������������������������������������������������������
	If ( Len(aCols) == 0 )
		Help(" ",1,"A410SEMREG")
		lContinua := .F.
	EndIf

	//�������������������������������������������������������Ŀ
	//� Ponto de Entrada para visualizao do pedido de vendas  �
	//���������������������������������������������������������
	If ExistBlock("M410VIS")
		ExecBlock("M410VIS",.F.,.F.)
	EndIf
	
	If ( lContinua )
		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 020, .t., .f. } )
		aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
		aPosObj := MsObjSize(aInfo,aObjects)
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )	
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//������������������������������������������������������������������������Ŀ
		//� Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      �
		//��������������������������������������������������������������������������
		If ( M->C5_TIPO $ "DB" )
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		oGetPV:=MSMGet():New( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
		nGetLin := aPosObj[3,1]
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi("Total :")					SIZE 020,09 OF oDlg PIXEL
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec))		SIZE 060,09 OF oDlg	PIXEL
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi("Desc. :")					SIZE 030,09 OF oDlg PIXEL
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec))		SIZE 060,09 OF oDlg	PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")						SIZE 020,09 OF oDlg PIXEL
		@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0						SIZE 060,09 PICTURE TM(0,22,Iif(cPaisloc=="CHI" .And. M->C5_MOEDA == 1,NIL,nNumDec)) OF oDlg PIXEL RIGHT
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),oSay2:SetText(n2),oSay3:SetText(n3),oSay4:SetText(n4) }
		oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,,"A410FldOk(1)",,,,,lFreeze)	
		PRIVATE oGetDad := oGetD
		A410Bonus(2)
		Ma410Rodap(oGetd,nTotPed,nTotDes)
		ACTIVATE MSDIALOG oDlg ON INIT (A410Limpa(.F.,M->C5_TIPO),EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},,{}))
	EndIf
	
	//�������������������������������������������������������Ŀ
	//� Ponto de Entrada apos visualizao do pedido de vendas  �
	//���������������������������������������������������������
	If ExistBlock("MTA410V")
		ExecBlock("MTA410V",.F.,.F.)
	EndIf
EndIf	

aRotina := aClone(aBackRot)
RestArea(aArea)

Return(nOpcA)

Static Function Mta410Vis(cArqQry,nTotPed,nTotDes,lGrade)
***************************************************
LOCAL lRet      := .T.
LOCAL nTamaCols := Len(aCols)
LOCAL nPosItem  := GDFieldPos("C6_ITEM")
LOCAL nPosQtd   := GDFieldPos("C6_QTDVEN")
LOCAL nPosQtd2  := GDFieldPos("C6_UNSVEN")
LOCAL nPosVlr   := GDFieldPos("C6_VALOR")
LOCAL nPosSld   := GDFieldPos("C6_SLDALIB")
LOCAL nPosDesc  := GDFieldPos("C6_VALDESC")
LOCAL lCriaCols := .F.		// Nao permitir que a funcao A410Grade crie o aCols
LOCAL lGrdMult  := FindFunction("MATGRADE_V") .And. MATGRADE_V() >= 20110425 .And. "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"")
//������������������������������������������������������Ŀ
//� Verifica se este item foi digitada atraves de uma    �
//� grade, se for junta todos os itens da grade em uma   �
//� referencia , abrindo os itens so quando teclar enter �
//� na quantidade                                        �
//��������������������������������������������������������
If !lGrdMult .And. (cArqQry)->C6_GRADE == "S" .And. lGrade
	a410Grade(.F.,,cArqQry,.T.,lCriaCols)   
	If ( nTamAcols==0 .Or. aCols[nTamAcols][nPosItem] <> (cArqQry)->C6_ITEM )
		lRet := .T.	
	Else
		lRet := .F.	
		aCols[nTamAcols][nPosQtd]  += (cArqQry)->C6_QTDVEN
		aCols[nTamAcols][nPosQtd2] += (cArqQry)->C6_UNSVEN
		If ( nPosDesc > 0 )
			aCols[nTamAcols][nPosDesc] += (cArqQry)->C6_VALDESC
		Endif
		If ( nPosSld > 0 )
			aCols[nTamAcols][nPosSld] += Ma440SaLib()
		EndIf
		aCols[nTamAcols][nPosVlr] += (cArqQry)->C6_VALOR
	EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//�Efetua a Somatoria do Rodape                                            �
//��������������������������������������������������������������������������
nTotPed	+= (cArqQry)->C6_VALOR
If ( (cArqQry)->C6_PRUNIT = 0 )
	nTotDes	+= (cArqQry)->C6_VALDESC
Else
	nTotDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
EndIf
Return(lRet)

Static Function A410InGrdM(lEdit)
******************************
LOCAL nPQTDVEN := 0
LOCAL nPPRCVEN := 0
LOCAL lGrdMult  := FindFunction("MATGRADE_V") .And. MATGRADE_V() >= 20110425 .And. "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"")
DEFAULT lEdit := .F.
If lGrdMult
	aAdd(oGrade:aCposCtrlGrd,{"C6_PRCVEN",.F.,{},{},.T.})
	aAdd(oGrade:aCposCtrlGrd,{"C6_VALOR",.F.,{},{},.F.})
	aAdd(oGrade:aCposCtrlGrd,{"C6_VALDESC",.F.,{},{},.F.})
	aAdd(oGrade:aCposCtrlGrd,{"C6_DESCRI",.F.,{},{},.F.})
	aAdd(oGrade:aCposCtrlGrd,{"C6_PRUNIT",.F.,{},{},.F.})
	If lEdit
		nPQTDVEN := aScan(oGrade:aCposCtrlGrd, {|x| x[1] == "C6_QTDVEN"})
		nPPRCVEN := aScan(oGrade:aCposCtrlGrd, {|x| x[1] == "C6_PRCVEN"})
		If Len(oGrade:aCposCtrlGrd[nPQTDVEN]) == 3
			aAdd(oGrade:aCposCtrlGrd[nPQTDVEN],{ }) //Array de gatilhos
			aAdd(oGrade:aCposCtrlGrd[nPQTDVEN],.T.) //Flag de obrigatoriedade		
		Endif
		//-- Campos a atualizar ao confirmar a tela da grade
		aAdd(oGrade:aCposCtrlGrd[nPQTDVEN,3],{"C6_DESCRI",{|| Posicione("SB1",1,xFilial("SB1")+oGrade:GetNameProd(,nLinha,nColuna),"B1_DESC")}})
		//-- Campos a atualizar na grade multicampo
		aAdd(oGrade:aCposCtrlGrd[nPQTDVEN,4],{"C6_PRCVEN",{|| A410GrInPr(nLinha,nColuna) }})
		aAdd(oGrade:aCposCtrlGrd[nPQTDVEN,4],{"C6_VALDESC",{|| (((&(ReadVar()) * 100) / oGrade:aColsFieldByName("C6_QTDVEN",,nLinha,nColuna)) / 100) * oGrade:aColsFieldByName("C6_VALDESC",,nLinha,nColuna) }})
		aAdd(oGrade:aCposCtrlGrd[nPQTDVEN,4],{"C6_VALOR",{|| A410Arred(&(ReadVar()) * oGrade:GetFieldMC("C6_PRCVEN"),"C6_VALOR")}})
		aAdd(oGrade:aCposCtrlGrd[nPPRCVEN,4],{"C6_VALOR",{|| A410Arred(&(ReadVar()) * oGrade:GetFieldMC("C6_QTDVEN"),"C6_VALOR")}})
	Endif
Endif
Return

Static Function Ma410PerAut()
**************************
LOCAL nX := 0, cVarParam := ""
If Type("aParamAuto") == "A"
	For nX := 1 to Len(aParamAuto)
		cVarParam := Alltrim(Upper(aParamAuto[nX][1]))
		If "MV_PAR" $ cVarParam
			&(cVarParam) := aParamAuto[nX][2]
		EndIf
	Next nX
EndIf
Return

Static Function A410FRat(aHeadAGG,aColsAGG)
**************************************
Local lQuery    := .T.
Local aStruAGG  := AGG->(dbStruct())
Local cAliasAGG := "AGG" 
Local nX	:= 0
Local nY	:= 0  
Local aBackAGG  := {}
Local cItemAGG  := ""
Local nItemAGG	 := 0
//������������������������������������������������������Ŀ
//� Monta o Array contendo as registros do AGG           �
//��������������������������������������������������������
DbSelectArea("AGG")
DbSetOrder(1)
cAliasAGG := "AGG"		
#IFDEF TOP
	If TcSrvType()<>"AS/400"
		lQuery    := .T.
		aStruAGG  := AGG->(dbStruct())
		cAliasAGG := "A120NFISCAL"
		cQuery    := "SELECT AGG.*,AGG.R_E_C_N_O_ AGGRECNO "
		cQuery    += "FROM "+RetSqlName("AGG")+" AGG "
		cQuery    += "WHERE AGG.AGG_FILIAL='"+xFilial("AGG")+"' AND "
		cQuery    += "AGG.AGG_PEDIDO='"+SC5->C5_NUM+"' AND "
		cQuery    += "AGG.AGG_FORNEC='"+SC5->C5_CLIENTE+"' AND "
		cQuery    += "AGG.AGG_LOJA='"+SC5->C5_LOJACLI+"' AND "
		cQuery    += "AGG.D_E_L_E_T_=' ' "
		cQuery    += "ORDER BY "+SqlOrder(AGG->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasAGG,.T.,.T.)
		For nX := 1 To Len(aStruAGG)
			If aStruAGG[nX,2]<>"C"
				TcSetField(cAliasAGG,aStruAGG[nX,1],aStruAGG[nX,2],aStruAGG[nX,3],aStruAGG[nX,4])
			EndIf
		Next nX
		
	Else
#ENDIF
		MsSeek(xFilial("AGG")+SC5->C5_NUM+SC5->C5_CLIENTE+SC5->C5_LOJACLI)
#IFDEF TOP
	EndIf
#ENDIF

dbSelectArea(cAliasAGG)
While ( !Eof() .And. ;
		xFilial('AGG') == (cAliasAGG)->AGG_FILIAL .And.;
		SC5->C5_NUM == (cAliasAGG)->AGG_PEDIDO .And.;
		SC5->C5_CLIENTE == (cAliasAGG)->AGG_FORNEC .And.;
		SC5->C5_LOJACLI == (cAliasAGG)->AGG_LOJA )
	If Empty(aBackAGG)
		//��������������������������������������������������������������Ŀ
		//� Montagem do aHeader                                          �
		//����������������������������������������������������������������
		DbSelectArea("SX3")
		DbSetOrder(1)
		MsSeek("AGG")
		While ( !EOF() .And. SX3->X3_ARQUIVO == "AGG" )
			If X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL .And. !"AGG_CUSTO"$SX3->X3_CAMPO
				aadd(aBackAGG,{ TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_F3,;
					SX3->X3_CONTEXT })
			EndIf
			DbSelectArea("SX3")
			dbSkip()
		EndDo
	EndIf
	aHeadAGG  := aBackAGG
	//��������������������������������������������������������������Ŀ
	//� Adiciona os campos de Alias e Recno ao aHeader para WalkThru.�
	//����������������������������������������������������������������
	ADHeadRec("AGG",aHeadAGG)    
	If cItemAGG <> 	(cAliasAGG)->AGG_ITEMPD
		cItemAGG	:= (cAliasAGG)->AGG_ITEMPD
		aadd(aColsAGG,{cItemAGG,{}})
		nItemAGG++
	EndIf
	aadd(aColsAGG[nItemAGG][2],Array(Len(aHeadAGG)+1))
	For nY := 1 to Len(aHeadAGG)
		If IsHeadRec(aHeadAGG[nY][2])
			aColsAGG[nItemAGG][2][Len(aColsAGG[nItemAGG][2])][nY] := IIf(lQuery , (cAliasAGG)->AGGRECNO , AGG->(Recno())  )
		ElseIf IsHeadAlias(aHeadAGG[nY][2])
			aColsAGG[nItemAGG][2][Len(aColsAGG[nItemAGG][2])][nY] := "AGG"
		ElseIf ( aHeadAGG[nY][10] <> "V")
			aColsAGG[nItemAGG][2][Len(aColsAGG[nItemAGG][2])][nY] := (cAliasAGG)->(FieldGet(FieldPos(aHeadAGG[nY][2])))
		Else
			aColsAGG[nItemAGG][2][Len(aColsAGG[nItemAGG][2])][nY] := (cAliasAGG)->(CriaVar(aHeadAGG[nY][2]))
		EndIf
		aColsAGG[nItemAGG][2][Len(aColsAGG[nItemAGG][2])][Len(aHeadAGG)+1] := .F.
	Next nY
	DbSelectArea(cAliasAGG)
	dbSkip()
EndDo
If lQuery
	DbSelectArea(cAliasAGG)
	dbCloseArea()
	DbSelectArea("AGG")
EndIf
Return

Static Function AfterCols(cArqQry,cTipoDat,dCopia,dOrig,lCopia)
*********************************************************           
LOCAL nPosProd  := GDFieldPos("C6_PRODUTO")
LOCAL nPosGrade := GDFieldPos("C6_GRADE")
LOCAL nPIdentB6 := GDFieldPos("C6_IDENTB6")
LOCAL nPEntreg  := GDFieldPos("C6_ENTREG")
LOCAL nPPedCli  := GDFieldPos("C6_PEDCLI")
LOCAL nQtdLib   := GDFieldPos("C6_QTDLIB")
LOCAL nAux      := 0
LOCAL aLiberado := {}
LOCAL cCampo    := ""
LOCAL lGrdMult  := FindFunction("MATGRADE_V") .And. MATGRADE_V() >= 20110425 .And. "MATA410" $ SuperGetMV("MV_GRDMULT",.F.,"")
DEFAULT lCopia  := .F.
If !lGrdMUlt
	If nPosGrade > 0 .And. aCols[Len(aCols)][nPosGrade] == "S"
		cProdRef := (cArqQry)->C6_PRODUTO
		MatGrdPrRf(@cProdRef,.T.)
		aCols[Len(aCols)][nPosProd] := cProdRef
	Else
		//��������������������������������������������������������������Ŀ
		//� Mesmo nao sendo um item digitado atraves de grade e' necessa-�
		//� rio criar o Array referente a este item para controle da     �
		//� grade                                                        �
		//����������������������������������������������������������������
		If FindFunction("MsMatGrade") .And. IsAtNewGrd()
			oGrade:MontaGrade(Len(aCols))
		Else
			MatGrdMont(Len(aCols))
		EndIf 
	EndIf	
EndIf
If Altera
	If ( SC5->C5_TIPO <> "D" )
		nAux := aScan(aLiberado,{|x| x[2] == aCols[Len(aCols)][nPIdentB6]})
		If ( nAux == 0 )
			aadd(aLiberado,{ (cArqQry)->C6_ITEM , aCols[Len(aCols)][nPIdentB6] , (cArqQry)->C6_QTDEMP, (cArqQry)->C6_QTDENT })
		Else
			aLiberado[nAux][3] += (cArqQry)->C6_QTDEMP
			aLiberado[nAux][4] += (cArqQry)->C6_QTDENT
		EndIf
	Else
		nAux := aScan(aLiberado,{|x| x[1] == (cArqQry)->C6_SERIORI .And.;
		x[2] == (cArqQry)->C6_NFORI   .And.;
		x[3] == (cArqQry)->C6_ITEMORI })
		If ( nAux == 0 )
			aadd(aLiberado,{ (cArqQry)->C6_SERIORI , (cArqQry)->C6_NFORI , (cArqQry)->C6_ITEMORI , (cArqQry)->C6_QTDEMP })
		Else
			aLiberado[nAux][4] += (cArqQry)->C6_QTDEMP
		EndIf
	EndIf
	// Necessario para disparar inicializador padrao
	aCols[Len(aCols)][nQtdLib] := CriaVar("C6_QTDLIB")
EndIf
If lCopia
	cCampo := Alltrim(aHeader[nPEntreg,2])           
	Do Case
		Case cTipoDat == "1"
			aCols[Len(aCols)][nPEntreg] := FieldGet(FieldPos(cCampo))
		Case cTipoDat == "2"
			aCols[Len(aCols)][nPEntreg] := If(FieldGet(FieldPos(cCampo)) < dCopia,dCopia,FieldGet(FieldPos(cCampo)) )
		Case cTipoDat == "3"
			aCols[Len(aCols)][nPEntreg] := dCopia + (FieldGet(FieldPos(cCampo)) - dOrig )
	EndCase
	If SubStr(aCols[Len(aCols)][nPPedCli],1,3)=="TMK"
		cCampo := Alltrim(aHeader[nPPedCli,2])           
		aCols[Len(aCols)][nPPedCli] := CriaVar(cCampo)
	EndIf	
	//������������������������������������������������������Ŀ
	//� Estes campos nao podem ser copiados                  �
	//��������������������������������������������������������
	GDFieldPut("C6_QTDLIB"  ,CriaVar("C6_QTDLIB"  ),Len(aCols))
	GDFieldPut("C6_RESERVA" ,CriaVar("C6_RESERVA" ),Len(aCols))
	GDFieldPut("C6_CONTRAT" ,CriaVar("C6_CONTRAT" ),Len(aCols))
	GDFieldPut("C6_ITEMCON" ,CriaVar("C6_ITEMCON" ),Len(aCols))
	GDFieldPut("C6_PROJPMS" ,CriaVar("C6_PROJPMS" ),Len(aCols))
	GDFieldPut("C6_EDTPMS"  ,CriaVar("C6_EDTPMS"  ),Len(aCols))
	GDFieldPut("C6_TASKPMS" ,CriaVar("C6_TASKPMS" ),Len(aCols))
	GDFieldPut("C6_LICITA"  ,CriaVar("C6_LICITA"  ),Len(aCols))
	GDFieldPut("C6_PROJET"  ,CriaVar("C6_PROJET"  ),Len(aCols))
	GDFieldPut("C6_ITPROJ"  ,CriaVar("C6_ITPROJ"  ),Len(aCols))
	GDFieldPut("C6_CONTRT"  ,CriaVar("C6_CONTRT"  ),Len(aCols))
	GDFieldPut("C6_TPCONTR" ,CriaVar("C6_TPCONTR" ),Len(aCols))
	GDFieldPut("C6_ITCONTR" ,CriaVar("C6_ITCONTR" ),Len(aCols))
	GDFieldPut("C6_NUMOS"   ,CriaVar("C6_NUMOS"   ),Len(aCols))
	GDFieldPut("C6_NUMOSFAT",CriaVar("C6_NUMOSFAT"),Len(aCols))
	GDFieldPut("C6_OP"      ,CriaVar("C6_OP"      ),Len(aCols))
	GDFieldPut("C6_NUMOP"   ,CriaVar("C6_NUMOP"   ),Len(aCols))
	GDFieldPut("C6_ITEMOP"  ,CriaVar("C6_ITEMOP"  ),Len(aCols))
	GDFieldPut("C6_NUMSC"   ,CriaVar("C6_NUMSC"   ),Len(aCols))
	GDFieldPut("C6_ITEMSC"  ,CriaVar("C6_ITEMSC"  ),Len(aCols))
	GDFieldPut("C6_NUMORC"  ,CriaVar("C6_NUMORC"  ),Len(aCols))
	GDFieldPut("C6_BLQ"     ,CriaVar("C6_BLQ"     ),Len(aCols))
	GDFieldPut("C6_NOTA"    ,CriaVar("C6_NOTA"    ),Len(aCols))
	GDFieldPut("C6_SERIE"   ,CriaVar("C6_SERIE"   ),Len(aCols))
EndIf
Return(.T.) 

Static Function A410Bonus(nTipo)
*****************************
Local aArea     := GetArea()
Local aBonus    := {}
Local lA410BLCo := ExistBlock("A410BLCO")
Local nX        := 0
Local nY        := 0
Local nW        := 0 
Local nZ        := Len(aCols)
Local nUsado    := Len(aHeader)
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"  })
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"  })
Local nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"   })
Local nPTES		 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"     })                
Local nPItem	 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM"    })
Local nPQtdLib  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB"  })
//��������������������������������������������������������Ŀ
//�Verifica os bonus                                       �
//����������������������������������������������������������
If nTipo == 1
	Ma410GraGr()
	If M->C5_TIPO=="N"
		//��������������������������������������������������������Ŀ
		//�Verifica os bonus por item de venda                     �
		//����������������������������������������������������������
		If ExistBlock('A410BONU')
			aBonus	:=	ExecBlock('A410BONU',.F.,.F.,{aCols,{nPProd,nPQtdVen,nPTES}})
		Else
			aAreaSE4 := SE4->(GetArea())
			SE4->(DbSetOrder(1))
			SE4->(DbSeek( xFilial("SE4") + M->C5_CONDPAG ))
			aBonus   := FtRgrBonus(aCols,{nPProd,nPQtdVen,nPTES},M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,M->C5_CONDPAG,SE4->E4_FORMA)
			SE4->(RestArea(aAreaSE4))
		Endif
		//��������������������������������������������������������Ŀ
		//�Recupera os bonus ja existentes                         �
		//����������������������������������������������������������
		aBonus   := FtRecBonus(aCols,{nPProd,nPQtdVen,nPTES,nUsado+1},aBonus)
		//��������������������������������������������������������Ŀ
		//�Grava os novos bonus                                    �
		//����������������������������������������������������������
		nY := Len(aBonus)
		If nY > 0
			cItem := aCols[nZ,nPItem]
			For nX := 1 To nY
				cItem := Soma1(cItem)
				aadd(aCols,Array(nUsado+1))
				nZ++
				N := nZ
				For nW := 1 To nUsado
					If (aHeader[nW,2] <> "C6_REC_WT") .And. (aHeader[nW,2] <> "C6_ALI_WT")
						aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
					EndIf	
				Next nW
				aCols[nZ,nUsado+1] := .F.
				aCols[nZ,nPItem  ] := cItem
				A410Produto(aBonus[nX][1],.F.)
				A410MultT("M->C6_PRODUTO",aBonus[nX][1])
				A410MultT("M->C6_TES",aBonus[nX][3])
				aCols[nZ,nPProd  ] := aBonus[nX][1]
 				If ExistTrigger("C6_PRODUTO")
   					RunTrigger(2,Len(aCols))
				Endif
				aCols[nZ,nPQtdVen] := aBonus[nX][2]
				aCols[nZ,nPTES   ] := aBonus[nX][3]
				If ( aCols[nZ,nPPrcVen] == 0 )
					aCols[nZ,nPPrcVen] := 1
					aCols[nZ,nPValor ] := aCols[nZ,nPQtdVen]
				Else
					aCols[nZ,nPValor ] := A410Arred(aCols[nZ,nPQtdVen]*aCols[nZ,nPPrcVen],"C6_VALOR")
				EndIf				
 				If ExistTrigger("C6_TES    ")
   					RunTrigger(2,Len(aCols))
				Endif
				If mv_par01 == 1 
					aCols[nZ,nPQtdLib ] := aCols[nZ,nPQtdVen ]
				Endif
				If lA410BLCo
					aCols[nZ] := ExecBlock("A410BLCO",.F.,.F.,{aHeader,aCols[nZ]})
				Endif
			Next nX
		EndIf
	EndIf
Else
	FtDelBonus(aCols,{nPProd,nPQtdVen,nPTES,nUsado+1})	
EndIf
RestArea(aArea)
Return(.T.)