#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'
/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RESTA01  � Rotina de manuten��o no cadastro invent�rio com base nas     ���
���             �          � fichas geradas previamente.                                  ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � ??.??.?? � ?????                                                        ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 24.11.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o                                        ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RESTA01()

Local aIndexSB7	:= {}
Local aRegs			:= {}
Local cFiltraSB7	:= ""
Local cPerg			:= U_CriaPerg("ESTA01")

Private cCadastro		:= 'Ficha de Invent�rio'
Private aRotina		:= {}
Private bFiltraBrw	:= {|| Nil}								// Code block para filtro

// Posiciona no arquivo
dbSelectArea('SB7')
dbSetOrder(1)

// Monta os bot�es da rotina
aAdd( aRotina, { 'Pesquisar',		'AxPesqui',	 										0, 1} )
aAdd( aRotina, { 'Visualizar',	'AxVisual',	 										0, 2} )
aAdd( aRotina, { 'Manuten��o',	'U_RESTA01MAN("SB7",SB7->(RECNO()),3)',	0, 3} )

//���������������������������������������������������Ŀ
//� mv_par01 - Contagem [1a., 2a. 3a.]                �
//� mv_par02 - Data do Invent�rio                     �
//�����������������������������������������������������
// Monta array com as perguntas
aAdd(aRegs,{	cPerg,;				  								// Grupo de perguntas
					"01",;												// Sequencia
					"Contagem",;										// Nome da pergunta
					"",;													// Nome da pergunta em espanhol
					"",;													// Nome da pergunta em ingles
					"mv_ch1",;											// Vari�vel
					"C",;													// Tipo do campo
					3,;													// Tamanho do campo
					0,;													// Decimal do campo
					0,;													// Pr�-selecionado quando for choice
					"C",;													// Tipo de sele��o (Get ou Choice)
					"",;													// Valida��o do campo
					"MV_PAR01",;										// 1a. Vari�vel dispon�vel no programa
					"1a. Contagem",;									// 1a. Defini��o da vari�vel - quando choice
					"",;													// 1a. Defini��o vari�vel em espanhol - quando choice
					"",;													// 1a. Defini��o vari�vel em ingles - quando choice
					"",;													// 1o. Conte�do vari�vel
					"",;													// 2a. Vari�vel dispon�vel no programa
					"2a. Contagem",;									// 2a. Defini��o da vari�vel
					"",;													// 2a. Defini��o vari�vel em espanhol
					"",;													// 2a. Defini��o vari�vel em ingles
					"",;													// 2o. Conte�do vari�vel
					"",;													// 3a. Vari�vel dispon�vel no programa
					"3a. Contagem",;									// 3a. Defini��o da vari�vel
					"",;													// 3a. Defini��o vari�vel em espanhol
					"",;													// 3a. Defini��o vari�vel em ingles
					"",;													// 3o. Conte�do vari�vel
					"",;													// 4a. Vari�vel dispon�vel no programa
					"",;													// 4a. Defini��o da vari�vel
					"",;													// 4a. Defini��o vari�vel em espanhol
					"",;													// 4a. Defini��o vari�vel em ingles
					"",;													// 4o. Conte�do vari�vel
					"",;													// 5a. Vari�vel dispon�vel no programa
					"",;													// 5a. Defini��o da vari�vel
					"",;													// 5a. Defini��o vari�vel em espanhol
					"",;													// 5a. Defini��o vari�vel em ingles
					"",;													// 5o. Conte�do vari�vel
					"",;													// F3 para o campo
					"",;													// Identificador do PYME
					"",;													// Grupo do SXG
					"",;													// Help do campo
					"" })													// Picture do campo
aAdd(aRegs,{cPerg,"02","Data Inventario",	"","","mv_ch2","D",8,0,0,"G","","MV_PAR02","","","","31/12/05","","","","","","","","","","","","","","","","","","","","","","","","","" })

// Cria as perguntas
U_CriaSX1(aRegs)

// Chama a interface com o usu�rio para definir os par�metros
Pergunte(cPerg, .T.)
//SetKey( VK_F12, { || Pergunte(cPerg, .T.) } )

// Monta o filto do browse de acordo com os par�mtros
If mv_par01 == 1
	cFiltraSB7	:= "B7_CONTAGE=='001'.AND.B7_DATA==mv_par02"
ElseIf mv_par01 == 2
	cFiltraSB7	:= "B7_CONTAGE=='002'.AND.B7_DATA==mv_par02"
ElseIf mv_par01 == 3
	cFiltraSB7	:= "B7_CONTAGE=='003'.AND.B7_DATA==mv_par02"
EndIf

//��������������������������������������������������������������Ŀ
//� Filtra o arquivo com as revis�es diferentes da atual         �
//����������������������������������������������������������������
bFiltraBrw 	:= {|| FilBrowse( "SB7", @aIndexSB7, @cFiltraSB7 ) }
Eval(bFiltraBrw)

dbSelectArea('SB7')
dbSetOrder(1)
mBrowse(6, 1, 22, 75, 'SB7')

//������������������������������������������������������������������������Ŀ
//�Restaura o filtro inicial                                               �
//��������������������������������������������������������������������������
EndFilBrw("SB7", aIndexSB7)

//�����������������������������������������������Ŀ
//� Desativa tecla que aciona pergunta            �
//�������������������������������������������������
Set Key VK_F12 To

Return(Nil)




/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    �RESTA01MAN� Rotina de manuten��o no cadastro invent�rio com base nas     ���
���             �          � fichas geradas previamente.                                  ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � ??.??.?? � ?????                                                        ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 24.11.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o                                        ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RESTA01MAN(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized)

Local aArea    := GetArea(cAlias)
Local aCRA     := { "Confirma","Redigita","Abandona" }
Local aSvRot   := Nil
Local aPosEnch := {}
Local cMemo    := ""
Local nX       := 0
Local nOpcA    := 0
Local nLenSX8  := GetSX8Len()
Local bCampo   := {|nCPO| Field(nCPO) }
Local bOk      := Nil
Local bOk2     := {|| .T.}
Local nTop
Local nLeft
Local nBottom
Local nRight
Local cAliasMemo
Local cQry		:= ""

Private aTELA[0][0]
Private aGETS[0]
Private oDlg 

DEFAULT cTudoOk := ".T."
DEFAULT bOk     := &("{|| "+cTudoOk+"}")
DEFAULT lF3     := .F.
DEFAULT lVirtual:= .F.

//�������������������������������������������������������������������Ŀ
//� Processamento de codeblock de validacao de confirmacao            �
//���������������������������������������������������������������������
If !Empty(aParam)
	bOk2 := aParam[2]
EndIf
//��������������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo							     �
//����������������������������������������������������������������
If nOpc == Nil
	nOpc := 3
	If Type("aRotina") == "A"
		aSvRot := aClone(aRotina)
	EndIf
	Private aRotina := { { " "," ",0,1 } ,{ " "," ",0,2 },{ " "," ",0,3 } }
EndIf
RegToMemory(cAlias, .T., lVirtual )

//����������������������������������������������������������������������Ŀ
//� Inicializa variaveis para campos Memos Virtuais (GILSON)		    	 �
//������������������������������������������������������������������������
If Type("aMemos")=="A"
	For nX :=1 To Len(aMemos)
		cMemo := aMemos[nX][2]
		If ExistIni(cMemo)
			&cMemo := InitPad(SX3->X3_RELACAO)
		Else
			&cMemo := ""
		EndIf
	Next nX
EndIf
//������������������������������������������������������Ŀ
//� Funcoes executadas antes da chamada da Enchoice      �
//��������������������������������������������������������
If cFunc != NIL
	&cFunc.()
EndIf
//�������������������������������������������������������������������Ŀ
//� Processamento de codeblock de antes da interface                  �
//���������������������������������������������������������������������
If !Empty(aParam)
	Eval(aParam[1],nOpc)
EndIf
//������������������������������������������������������Ŀ
//� Envia para processamento dos Gets					      �
//��������������������������������������������������������
If aAuto == Nil

	If SetMDIChild()
		oMainWnd:ReadClientCoors()
		nTop := 40
		nLeft := 30 
		nBottom := oMainWnd:nBottom-80
		nRight := oMainWnd:nRight-70		
	Else
		nTop := 135
		nLeft := 0
		nBottom := TranslateBottom(.T.,28)
		nRight := 632
	EndIf

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM nTop,nLeft TO nBottom,nRight PIXEL OF oMainWnd

	If lMaximized <> NIL
		oDlg:lMaximized := lMaximized
	EndIf

	aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}
	EnChoice( cAlias, nReg, nOpc, aCRA,"CRA","Quanto a Inclus�o",aAcho, aPosEnch , aCpos, , , ,cTudoOk,,lF3,lVirtual)
	If lF3  // Esta na conpad, desabilita o trigger por execblock
		SetEntryPoint(.f.)
	EndIf
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| nOpcA := 1,If(Obrigatorio(aGets,aTela).And.Eval(bOk).And.Eval(bOk2,nOpc),oDlg:End(),(nOpcA:=3,.f.))},{|| nOpcA := 3,oDlg:End()},,aButtons)
Else
	If EnchAuto(cAlias,aAuto,{|| Obrigatorio(aGets,aTela).And.Eval(bOk).And.Eval(bOk2,nOpc)},nOpc,aCpos)
		nOpcA := 1
	EndIf
EndIf


cValidRep := ValidRep()
clot      := U_resta06()

//������������������������������������������������������Ŀ
//� Gravacao da enchoice                                 �
//��������������������������������������������������������
If nOpcA == 1 .and. clot //.And. Empty(cValidRep)

	Begin Transaction
		RecLock("SB7",.F.)
			SB7->B7_COD			:= M->B7_COD
			SB7->B7_TIPO		:= M->B7_TIPO
			SB7->B7_LOCAL		:= M->B7_LOCAL
			SB7->B7_QUANT		:= M->B7_QUANT
			SB7->B7_QTSEGUM	    := M->B7_QTSEGUM
			SB7->B7_LOTECTL	    := M->B7_LOTECTL  
			SB7->B7_DTVALID     := M->B7_DTVALID
			SB7->B7_DTDIGIT	    := dDataBase 
			SB7->B7_TPESTR      := M->B7_TPESTR
		MsUnLock()
		// Verifica se as demais fichas tem os dados b�sicos do produto
		cQry	+= " UPDATE "+RetSqlName("SB7")+" SET"
		cQry	+= " B7_COD = '"+M->B7_COD+"',"
		cQry	+= " B7_TIPO = '"+M->B7_TIPO+"',"
		cQry	+= " B7_LOCAL = '"+M->B7_LOCAL+"',"
		cQry	+= " B7_LOTECTL = '"+M->B7_LOTECTL+"',"           
		cQry	+= " B7_DTVALID = '"+Dtos(M->B7_DTVALID)+"'"				
		cQry	+= " WHERE B7_FILIAL = '"+xFilial("SB7")+"'"
		cQry	+= " AND B7_DOC = '"+M->B7_DOC+"'"
		cQry	+= " AND B7_DATA = '"+Dtos(M->B7_DATA)+"'"                                                  
		cQry	+= " AND D_E_L_E_T_ <> '*'"
		// Faz via sql pois o arquivo esta filtrada pelo n�mero da contagem
		TcSqlExec(cQry)
	End Transaction


//ElseIf nOpcA == 1 .And. !Empty(cValidRep)
///	MsgAlert("ESTAS INFORMA��ES DE LOCAL/LOTE/PRODUTO J� CONSTAM NA FICHA "+cValidRep+".","ATENCAO.")
//	MsgAlert("Ficha: "+cValidRep,"Dados j� digitados no Cadastro. Verifique.",{"&Ok"})
EndIf

//�������������������������������������������������������������������Ŀ
//� Restaura a integridade dos dados                                  �
//���������������������������������������������������������������������
If aSvRot != Nil
	aRotina := aClone(aSvRot)
EndIf

RestArea(aArea)

lRefresh := .T.

Return(nOpcA)

/*
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
��� Programa    � RESTA01A � Rotina executada pela valida��o do usu�rio  para que seja    ���
���             �          � inicializado os campos da enchoice com base no n�mero da     ���
���             �          � Ficha digitada pelo usu�rio.                                 ���
�����������������������������������������������������������������������������������������͹��
��� Solicitante � ??.??.?? � ?????                                                        ���
�����������������������������������������������������������������������������������������͹��
��� Autor       � 24.11.05 � Almir Bandina                                                ���
�����������������������������������������������������������������������������������������͹��
��� Produ��o    � ??.??.?? � Ignorado                                                     ���
�����������������������������������������������������������������������������������������͹��
��� Par�metros  � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Retorno     � Nil.                                                                    ���
�����������������������������������������������������������������������������������������͹��
��� Observa��es �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������͹��
��� Altera��es  � 99.99.99 - Consultor - Descri��o                                        ���
���             �                                                                         ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
*/
User Function RESTA01A()

//��������������������������Ŀ
//�Define variaveis da rotina�
//����������������������������
Local lRet		:= .T.

//����������������������������������������������������Ŀ
//�Verifica se o documento esta completamente preechido�
//������������������������������������������������������
If Len(Alltrim(M->B7_DOC)) <> 9
	M->B7_DOC := Strzero(Val(M->B7_DOC),9)
EndIf

//�����������������������������Ŀ
//�Consiste o documento digitado�
//�������������������������������
dbSelectArea("SB7")
dbSetOrder(4)
If !MsSeek(xFilial("SB7")+M->B7_DOC+StrZERO(mv_par01,3)+Dtos(mv_par02))
	Aviso(	"Ficha de Invent�rio",;
				"Ficha n�o localizada no cadastro. Verifique.",;
				{"&Continua"},,;
				"Ficha: "+M->B7_DOC)
	lRet	:= .F.
Else
	If SB7->B7_DATA != mv_par02
		Aviso(	"Ficha de Invent�rio",;
					"Data de Invent�rio da Ficha diferente da data definida no par�metro. Verifique.",;
					{"&Continua"},,;
					"Ficha: "+M->B7_DOC)
		lRet	:= .F.
	Else 
		
		//�����������������������������������������������������Ŀ
		//�Avisa se a ficha ja tiver sido digitada anteriormente�
		//�������������������������������������������������������
		If !Empty(SB7->B7_DTDIGIT)
			MsgAlert("Ficha ja digitada anteriormente !")
		EndIf
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		M->B7_DATA		:= SB7->B7_DATA
		M->B7_CONTAGE	:= SB7->B7_CONTAGE
		M->B7_COD		:= SB7->B7_COD
		M->B7_TIPO		:= SB7->B7_TIPO
		M->B7_DESC		:= POSICIONE("SB1",1,XFILIAL("SB1")+SB7->B7_COD,"B1_DESC")+" - "+POSICIONE("SB1",1,XFILIAL("SB1")+SB7->B7_COD,"B1_UM")
		M->B7_LOCAL		:= SB7->B7_LOCAL
		M->B7_QUANT		:= SB7->B7_QUANT
		M->B7_QTSEGUM	:= SB7->B7_QTSEGUM
		M->B7_NUMLOTE	:= SB7->B7_NUMLOTE
	   	M->B7_LOTECTL	:= SB7->B7_LOTECTL
		M->B7_DTVALID	:= If(Empty(SB7->B7_DTVALID),Ctod("31/12/2009"),SB7->B7_DTVALID)
		M->B7_LOCALIZ	:= SB7->B7_LOCALIZ
		M->B7_NUMSERI	:= SB7->B7_NUMSERI
		M->B7_TPESTR	:= SB7->B7_TPESTR
		M->B7_ESCOLHA	:= SB7->B7_ESCOLHA
		M->B7_X_TPFC	:= SB7->B7_X_TPFC
		M->B7_DTDIGIT	:= SB7->B7_DTDIGIT
	EndIf
EndIf

odlg:Refresh(.T.)

Return(lRet)


//���������������������������������������������������������������������������������������������������Ŀ
//�Esta  fun��o valida se os dados da ficha que est� sendo digitada j� n�o existe, gerada pelo sistema�
//�ou manualmente!                                                                                    �
//�����������������������������������������������������������������������������������������������������
Static Function ValidRep()

cQuery := " SELECT * FROM "+RetSQLName("SB7")+" SB7 WHERE "
cQuery += "     B7_FILIAL 		  		  		=  '"+xFilial("SB7")+"' "
cQuery += " AND RTRIM(LTRIM(B7_COD))		=  '"+AllTrim(B7_COD)+"' "
cQuery += " AND RTRIM(LTRIM(B7_LOTECTL))	=  '"+AllTrim(B7_LOTECTL)+"' "
cQuery += " AND B7_DATA 						=  '"+DToS(B7_DATA)+"'"          
cQuery += " AND RTRIM(LTRIM(B7_LOCAL)) 	=  '"+AllTrim(B7_LOCAL)+"' "
cQuery += " AND SB7.D_E_L_E_T_				=  ' ' " 
cQuery += " AND RTRIM(LTRIM(B7_DOC))		<> '"+AllTrim(B7_DOC)+"'" 

If Select("_TRB") > 0
	_TRB->(dbCloseArea())
EndIf

ChangeQuery(cQuery)	
//MemoWrite("\QUERYSYS\ValidRep.SQL",cQuery)
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"_TRB", .F., .T.)

dbSelectArea("_TRB")
cRet := AllTrim(_TRB->B7_DOC)

_TRB->(dbCloseArea())

Return(cRet)