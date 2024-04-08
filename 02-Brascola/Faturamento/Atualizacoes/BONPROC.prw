#include "Protheus.ch"
#include "FATA090.CH"
#DEFINE MAXGETDAD 4096
#DEFINE MAXSAVERESULT 4096
Static cTesBonus

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    � FATA090  � Autor �Eduardo Riera          � Data �09.05.2001  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Manutencao das Regras de Bonificacao               ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   � FATA090                                                      ���
���������������������������������������������������������������������������Ĵ��
���Parametros�                                                              ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizACQes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function BONPROC()

//��������������������������������������������������������������Ŀ
//� Define Array contendo as Rotinas a executar do programa      �
//� ----------- Elementos contidos por dimensao ------------     �
//� 1. Nome a aparecer no cabecalho                              �
//� 2. Nome da Rotina associada                                  �
//� 3. Usado pela rotina                                         �               `
//� 4. Tipo de Transa��o a ser efetuada                          �
//�    1 - Pesquisa e Posiciona em um Banco de Dados             �
//�    2 - Simplesmente Mostra os Campos                         �
//�    3 - Inclui registros no Bancos de Dados                   �
//�    4 - Altera o registro corrente                            �
//�    5 - Remove o registro corrente do Banco de Dados          �
//����������������������������������������������������������������
Private cCadastro := OemToAnsi(STR0007)	//"Manutencao das Regras de Bonificacao"
Private aRotina   := MenuDef()   
                      
//If FindFunction("LJValCenVd")
///	LJValCenVd() 
//EndIf	

//������������������������������������������������������������������������Ŀ
//�Endereca para a funcao MBrowse                                          �
//��������������������������������������������������������������������������
dbSelectArea("ZZQ")
dbSetOrder(1)
MsSeek(xFilial("ZZQ"))
mBrowse(06,01,22,75,"ZZQ")
//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade da Rotina                                        �
//��������������������������������������������������������������������������
dbSelectArea("ZZQ")
dbSetOrder(1)
dbClearFilter()
Return
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �Ft090RDes � Autor �Eduardo Riera          � Data �09.05.2001  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Manutencao da Regra de Bonificacao                  ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ft090RDes                                                     ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do Arquivo                                       ���
���          �ExpN2: Numero do Registro                                     ���
���          �ExpN3: Opcao do aRotina                                       ���
���          �                                                              ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizZZQes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
��� Fernando     �15/02/07�119218�Altera��o feita para usar a FilgetDados   ���
���              �        �      �na montagem do Aheader e Acols            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Bt090RDes(cAlias,nReg,nOpc,xPar,lCopia)

Local aArea     := GetArea()
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aInfo     := {}
Local nUsado    := 0
Local nX        := 0
Local nOpcA     := 0      
Local nSaveSx8  := GetSx8Len()
Local lContinua := .T.
Local lGrade 	:= ZZR->(FieldPos("ZZR_ITEMGR")) > 0 .And. MaGrade()

Local oDlg
Local oGetD
Local cSeek  := Nil
Local cWhile :=	Nil

Private oGrade := MsMatGrade():New("oGrade",,"ZZR_LOTE",,".T.",,{{"ZZR_LOTE",.T. ,,.T. }}) 

Private aHeader := {}
Private aCols   := {}     
Private aTELA[0][0],aGETS[0]

DEFAULT INCLUI := .F.
DEFAULT lCopia := .F.

nOper := aRotina[ nOpc, 4 ]

INCLUI := ( nOper == 3 .And. !lCopia )

//������������������������������������������������������������������������Ŀ
//�Inicializa as variaveis da Enchoice                                     �
//��������������������������������������������������������������������������
If INCLUI
	RegToMemory( "ZZQ", .T., .F. )
EndIf

If !INCLUI
	If SoftLock("ZZQ")
		RegToMemory( "ZZQ", .F., .F. )
	Else
		lContinua := .F.
	EndIf
EndIf

If lContinua

	cSeek  := xFilial("ZZR")+M->ZZQ_CODREG
	cWhile := "ZZR->ZZR_FILIAL + ZZR->ZZR_CODREG"          
	
	FillGetDados(	nOpc , "ZZR", 1, cSeek ,; 
						{||&(cWhile)}, {|| Iif (ZZR->ZZR_FILIAL + ZZR->ZZR_CODREG==xFilial("ZZR")+M->ZZQ_CODREG,.T.,.F.) }, /*aNoFields*/,; 
				   		/*aYesFields*/, /*lOnlyYes*/,/* cQuery*/, /*bMontAcols*/, IIf(nOpc<>3,.F.,.T.),; 
						/*aHeaderAux*/, /*aColsAux*/,{||U_Bat090Item()} , /*bBeforeCols*/,;
						/*bAfterHeader*/, /*cAliasQry*/)
	
	If lGrade					
		aCols := aColsGrade(oGrade,aCols,aHeader,"ZZR_CODPRO","ZZR_ITEM","ZZR_ITEMGR",aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_DESPRO"}))
	EndIf
						
	dbSelectArea( "ZZQ" ) 	
	If lCopia
		M->ZZQ_CODREG := CriaVar("ZZQ_CODREG",.T.)
	EndIf
   
	
	dbSelectArea("ZZR")
	
	//������������������������������������������������������Ŀ
	//� Faz o calculo automatico de dimensoes de objetos     �
	//��������������������������������������������������������
	aSize := MsAdvSize()
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 200, 200, .T., .T. } )
	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] of oMainWnd PIXEL
	EnChoice( "ZZQ", nReg, nOpc,,,,,aPosObj[1], , 3, , , , , ,.F. )
	oGetD := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"u_Bt090LOk()","U_Bt090TOk()","+ZZR_ITEM",(nOper==4 .Or. nOper==3),,1,,MAXGETDAD)
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA := 1,If(oGetd:TudoOk(),If(!Obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()})
	//��������������������������������������������������������������Ŀ
	//�Rotina de Gravacao da Tabela de preco                         �
	//����������������������������������������������������������������
	If nOpcA == 1 .And. nOpc > 2
		Begin Transaction
			If lGrade
				aCols := aGradeCols(oGrade,aCols,aHeader,"ZZR_CODPRO","ZZR_ITEMGR","ZZR_LOTE","ZZR_ITEM")
			EndIf
			BFt090Grv(nOpc-2,lCopia)
			While (Getsx8Len() > nSaveSx8)
				ConfirmSx8()
			EndDo
			EvalTrigger()
		End Transaction
	EndIf
EndIf
//��������������������������������������������������������������Ŀ
//�Restaura a entrada da Rotina                                  �
//����������������������������������������������������������������
While (GetSx8Len() > nSaveSx8)
	RollBackSxE()
EndDo
MsUnLockAll()
FreeUsedCode()
RestArea(aArea)
Return(nOpcA)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    |Fat090ITem  �Autor �Fernando Amorim      � Data � 14/02/07  ���
�������������������������������������������������������������������������͹��
���Descricao �Inclui na primeira linha do acols o numero do item 		  ���
�������������������������������������������������������������������������͹��
���Parametros�												              ���
�������������������������������������������������������������������������͹��
���Uso       � Regras de descontos                                   	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Bat090Item()
Local nX := 0
If Len(aCols) == 1
	For nX := 1 To Len(aHeader)
		If AllTrim(aHeader[nX,2]) == "ZZR_ITEM"
			Acols[Len(Acols)][nX] := StrZero(1,Len(ZZR->ZZR_ITEM))
		EndIf    
	Next nX
EndIf  
Return(.T.)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �Ft090Grv  � Autor �Eduardo Riera          � Data � 08/05/2001 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Gravacao                                            ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ft090Grv                                                      ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Opcao da Gravacao sendo:                               ���
���          �       [1] Inclusao                                           ���
���          �       [2] Alteracao                                          ���
���          �       [3] Exclusao                                           ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizZZQes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
Static Function BFt090Grv(nOpcao,lCopia)

Local aArea     := GetArea()
Local lGravou   := .F.
Local aRegNo    := {}
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_CODPRO"})
Local nPLote    := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_LOTE"})
Local nX        := 0
Local nY        := 0
Local nUsado    := Len(aHeader)
Local bCampo 	:= {|nCPO| Field(nCPO) }
Local cItem     := Repl("0",Len(ZZR->ZZR_ITEM))
Local cProcesCab := "023"												//Codigo do processo que sera utilizado para enviar a tabela ZZQ
Local cProcesIte := "024"												//Codigo do processo que sera utilizado para enviar a tabela ZZR
Local cChaveCab	 :=	""								   					//Chave utilizada na busca
Local cChaveIte	 := ""													//Chave utilizada na busca
Local cTabelaCab := "ZZQ"												//Tabela enviada no processo Off-line
Local cTabelaIte := "ZZR"												//Tabela enviada no processo Off-line

If nPProd > 0 .And. nPLote  > 0
	aCols := aSort(aCols,,,{|x,y| x[nPProd]+StrZero(x[nPLote ],18,2) < y[nPProd]+StrZero(y[nPLote ],18,2)})
EndIf

Do Case
Case nOpcao <> 3
	//��������������������������������������������������������������Ŀ
	//�Grava o Cabecalho                                             �
	//����������������������������������������������������������������
	dbSelectArea("ZZQ")
	dbSetOrder(1)
	If MsSeek(xFilial("ZZQ")+M->ZZQ_CODREG)
		RecLock("ZZQ",.F.)
	Else
		RecLock("ZZQ",.T.)
	EndIf
	For nX := 1 TO FCount()
		FieldPut(nX,M->&(EVAL(bCampo,nX)))
	Next nX
	ZZQ->ZZQ_FILIAL := xFilial("ZZQ")
	MsUnLock()

	//Insere o registro na integracao	
  //	If FindFunction("Om010CabOk")	
	//	cChaveCab:= xFilial("ZZQ") + ZZQ->ZZQ_CODREG
	 //	Om010CabOk(cProcesCab, cChaveCab, cTabelaCab)
	//Endif	

	//��������������������������������������������������������������Ŀ
	//�Guarda os registro para reaproveita-los                       �
	//����������������������������������������������������������������
	dbSelectArea("ZZR")
	dbSetOrder(1)
	MsSeek(xFilial("ZZR")+M->ZZQ_CODREG)
	While ( !Eof() .And. xFilial("ZZR") == ZZR->ZZR_FILIAL .And. M->ZZQ_CODREG == ZZR->ZZR_CODREG )
		aAdd(aRegNo,RecNo())
		dbSelectArea("ZZR")
		dbSkip()
	EndDo

	//��������������������������������������������������������������Ŀ
	//�Grava os itens                                                �
	//����������������������������������������������������������������
	For nX := 1 To Len(aCols)
		If !lCopia .And. !Empty(aCols[nX,nUsado])
			dbSelectArea("ZZR")
			dbGoto(aCols[nX,nUsado])
			RecLock("ZZR")
			nY := aScan(aRegNo,{|x| x == aCols[nX,nUsado]})
			aDel(aRegNo,nY)
			aSize(aRegNo,Len(aRegNo)-1)
		ElseIf !aCols[nX][nUsado+1]
			RecLock("ZZR",.T.)	
		EndIf
		If (!aCols[nX][nUsado+1])
			For nY := 1 to Len(aHeader)
				If aHeader[nY][10] <> "V"
					ZZR->(FieldPut(FieldPos(aHeader[nY][2]),aCols[nX][nY]))
				EndIf
			Next nY
			ZZR->ZZR_FILIAL := xFilial("ZZR")
			ZZR->ZZR_CODREG := M->ZZQ_CODREG
			lGravou := .T.
		ElseIf !lCopia .And. !Empty(aCols[nX][nUsado])
			ZZR->(dbDelete())
		EndIf
		MsUnLock()

		//Insere o registro na integracao	
		//If FindFunction("Om010IteOk")	
		  //	cChaveIte:= xFilial("ZZR") + ZZR->ZZR_CODREG + ZZR->ZZR_ITEM
		//	Om010IteOk(cProcesIte, cChaveIte, cTabelaIte, nX, nUsado)
		//EndIf
		
	Next nX
	dbSelectArea("ZZR")
	//Deleta registros alterados por outro produto
	For nX := 1 To Len(aRegNo)
		dbGoto(aRegNo[nX])
		RecLock("ZZR",.F.)
		dbDelete()
		MsUnLock()
	Next nX
Case nOpcao == 3
	dbSelectArea("ZZR")
	dbSetOrder(1)
	MsSeek(xFilial("ZZR")+M->ZZQ_CODREG)
	While ( !Eof() .And. xFilial("ZZR") == ZZR->ZZR_FILIAL .And. M->ZZQ_CODREG == ZZR->ZZR_CODREG )
		RecLock("ZZR")
		dbDelete()
		
		//Insere o registro na integracao	
	  //	If FindFunction("Om010IteOk")	
	  //		cChaveIte:= xFilial("ZZR") + ZZR->ZZR_CODREG + ZZR->ZZR_ITEM
	//		Om010IteOk(cProcesIte, cChaveIte, cTabelaIte, nX, nUsado)
	//	EndIf
		
		MsUnLock()
		dbSelectArea("ZZR")
		dbSkip()
	EndDo
	dbSelectArea("ZZQ")
	dbSetOrder(1)
	If MsSeek(xFilial("ZZQ")+M->ZZQ_CODREG)
		RecLock("ZZQ")
		dbDelete()
		
		//Insere o registro na integracao	
 //		If FindFunction("Om010CabOk")	
	 //		cChaveCab:= xFilial("ZZQ") + ZZQ->ZZQ_CODREG
   //			Om010CabOk(cProcesCab, cChaveCab, cTabelaCab)
	   //	EndIf
	
		MsUnLock()
	EndIf
EndCase
Return(lGravou)
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �Ft090LOk  � Autor �Eduardo Riera          � Data � 09/05/2001 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Validacao da linha Ok                               ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ft090Lok()                                                    ���
���������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                        ���
���          �                                                              ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizZZQes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
USER Function Bt090Lok()

Local aArea     := GetArea()
Local lRetorno  := .T.
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_CODPRO"})
Local nPLote    := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_LOTE"})
Local nPGrupo   := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_GRUPO"})
Local nUsado    := Len(aHeader)
Local nX        := 0
//������������������������������������������������������������������������Ŀ
//�Verifica os campos obrigatorios                                         �
//��������������������������������������������������������������������������
If !aCols[n][nUsado+1]
	Do Case
	Case nPProd == 0 .Or. nPLote  == 0 .Or. nPGrupo == 0
		lRetorno := .F.
		Help(" ",1,"OBRIGAT",,RetTitle("ZZR_CODPRO")+","+RetTitle("ZZR_GRUPO")+","+RetTitle("ZZR_LOTE"),4)
	Case Empty(aCols[n][nPProd]) .And. Empty(aCols[n][nPGrupo])
		lRetorno := .F.
		Help(" ",1,"OBRIGAT",,RetTitle("ZZR_CODPRO"),4)
	Case Empty(aCols[n][nPLote ])
		lRetorno := .F.
		Help(" ",1,"OBRIGAT",,RetTitle("ZZR_LOTE"),4)
	EndCase
	//������������������������������������������������������������������������Ŀ
	//�Verifica se nao ha valores duplicados                                   �
	//��������������������������������������������������������������������������
	
	If lRetorno
		IF m->ZZQ_TIPO == '1'
			If nPProd <> 0
				For nX := 1 To Len(aCols)
					If nX <> N .And. !aCols[nX][nUsado+1]
						If ( aCols[nX][nPProd]+aCols[nX][nPGrupo]==aCols[N][nPProd]+aCols[N][nPGrupo] )
							lRetorno := .F.
							Help(" ",1,"JAGRAVADO")
						EndIf
					EndIf
				Next nX
			EndIf
		ENDIF
	EndIf

EndIf
RestArea(aArea)
Return(lRetorno)

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �Ft090TOk  � Autor �Eduardo Riera          � Data � 10/05/2001 ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Validacao da TudoOk                                 ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �Ft090Tok()                                                    ���
���������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                        ���
���          �                                                              ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizZZQes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Bt090Tok()
**********************
Local lRetorno  := .T.
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="ZZR_CODPRO"})
Local nUsado    := Len(aHeader)
Local nX        := 0, lTemItem := .F.
                
If (M->ZZQ_tipo $ "12").and.(Empty(M->ZZQ_codpro).or.(M->ZZQ_quant <= 0))
	Help("",1,"BRASCOLA",,OemToAnsi("Para os tipos de regra 1 e 2, deve ser informado o C�digo do Produto e a Quantidade!"),1,0)
	Return (lRetorno := .F.)
Elseif (M->ZZQ_tipo $ "3")
	If ((M->ZZQ_pedmin == 0).or.(M->ZZQ_pedmax == 0))
		Help("",1,"BRASCOLA",,OemToAnsi("Para o tipo de regra 3, deve ser informado os valores minimo e maximo do pedido!"),1,0)
		Return (lRetorno := .F.)
	Endif
	For nX := 1 To Len(aCols)
		If !(aCols[nX][nUsado+1]).and.!Empty(aCols[nX][nPProd])
			lTemItem := .T.
			Exit
		Endif
	Next nX
	If (!lTemItem)
		Help("",1,"BRASCOLA",,OemToAnsi("Para o tipo de regra 3, deve ser informado pelo menos 1 item!"),1,0)
		Return (lRetorno := .F.)
	Endif
Endif

Return(lRetorno)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtRgrBonus� Autor �Eduardo Riera          � Data �15.05.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de avaliacao da regra de bonificacao                 ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: aCols da GetDados ou Alias da GetDb                  ���
���          �ExpA2: Quando acols informar:                               ���
���          �       [1] Posicao do codigo do produto                     ���
���          �       [2] Posicao da Quantidade                            ���
���          �       [3] Posicao da TES                                   ���
���          �       Quando GetDb informar:                               ���
���          �       [1] Nome do campo do codigo do produto               ���
���          �       [2] Nome do campo da quantidade                      ���
���          �       [3] Nome do campo da TES                             ���
���          �ExpC3: Cliente                                              ���
���          �ExpC4: Loja                                                 ���
���          �ExpC5: Tabela                                               ���
���          �ExpC6: Condicao de Pagamento                                ���
���          �ExpC7: Forma de Pagamento                                   ���
���          �ExpA8: Array com os registros do ZZQ que devem ser usados   ���
���          �       EXCLUSIVAMENTE.                                      ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpA1: Array com a seguinte estrutura:                      ���
���          �       [1] Codigo do Produto                                ���
���          �       [2] Quantidade                                       ���
���          �       [3] TES                                              ���
���          �       [4] Regra aplicada                                   ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo avaliar a regra de bonificacao���
���          �conforme os parametros da rotina                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
USER Function BFtRgrB(xPar1,xPar2,cCliente,cLoja,cTabPreco,cCondPg,cFormPg,aRecZZQ,cCodVend)
********************************************************************************************
Local aArea    := GetArea()
Local aAreaSF4 := SF4->(GetArea())
Local aArea2   := {}
Local aRetorno := {}
Local aPos     := {1,2,3}
Local aCopia   := {}
Local aGrupos  := {}
Local aRemove  := {}
Local aLote    := {}
Local aSoma    := {}
Local aStruZZQ := ZZQ->(dbStruct())
Local aStruZZR := ZZR->(dbStruct())
Local aGrpZZR  := {}
Local aBkCopia := {}

Local cQuery   := ""
Local cCursor  := "ZZQ"
Local cCursor2 := "ZZR"
Local cProduto := ""
Local cGrupo   := ""
Local cCnt	   :=	""

Local nX       := 0
Local nY       := 0
Local nZ       := 0
Local nMult    := 0
Local nCabLote := 0
Local nSoma    := 0
Local nQuant   :=	0

Local nRecs
Local nCnt     := 1

Local lQuery   := .F.
Local lValido  := .F.
Local lBonific := .F.
Local lContinua:= .T.
Local lGrpAcul := .T.
Local lAcumula := SuperGetMv("MV_TPBONUS",.F.,.T.)
Local lBonusTd := (SuperGetMv("MV_BONUSTD",.F.,"2") == "1")
Local cAnTES   := SuperGetMv("MV_TESBONS",.F.,"")

DEFAULT cProduto  := Space(Len(SB1->B1_COD))
DEFAULT cCliente  := Space(Len(SA1->A1_COD))
DEFAULT cLoja     := Space(Len(SA1->A1_LOJA))
DEFAULT cTabPreco := Space(Len(DA0->DA0_CODTAB))
DEFAULT cCondPg   := Space(Len(DA0->DA0_CONDPG))
DEFAULT cFormPg   := Space(Len(ACO->ACO_FORMPG))
DEFAULT aRecZZQ	:=	{}

nRecs	:=	Len(aRecZZQ)
//������������������������������������������������������������������������Ŀ
//�Verifica se a tes eh valida                                             �
//��������������������������������������������������������������������������
If cTesBonus == Nil
	DEFAULT cTesBonus := &(GetMv("MV_BONUSTS"))
	If Empty(cTesBonus)
		lContinua := .F.
	Else
		//Trata se par�metro for num�rico
		If ValType(cTesBonus) == "N"
			cTesBonus := cValToChar(cTesBonus)
		EndIf
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		If SubStr(cTesBonus,1,3)<="500" .Or. !MsSeek(xFilial("SF4")+cTesBonus)
			lContinua := .F.	
		EndIf
	EndIf
	If !lContinua
		cTesBonus := Nil
	EndIf
EndIf
If lContinua
	If ValType(xPar1)=="C"
		dbSelectArea(xpar1)
		aArea2 := GetArea()
		dbGotop()
		While ( !Eof())
			If (FieldGet(FieldPos(xPar2[3])) <> cTesBonus) .And. ( Empty(cAnTES) .Or. !(FieldGet(FieldPos(xPar2[3])) $ cAnTES)) 
				nPosProd	:=	Ascan(aCopia,{|x| x[1] == FieldGet(FieldPos(xPar2[1])) })
				If nPosProd	>	0
					aCopia[nPosProd][2]	+=	FieldGet(FieldPos(xPar2[2]))
				Else
					aadd(aCopia,{ FieldGet(FieldPos(xPar2[1])) , FieldGet(FieldPos(xPar2[2])),FieldGet(FieldPos(xPar2[3])) })
				Endif
			Endif
			dbSelectArea(xpar1)	
			dbSkip()
		EndDo
		RestArea(aArea2)
	Else
		For nX	:=	1	To Len(xPar1)
			If Valtype(xPar1[nX][Len(xPar1[nX])]) =='L' .And. !xPar1[nX][Len(xPar1[nX])] .And. xPar1[nX][xPar2[3]] <> cTesBonus ;
			    .And. ( Empty(cAnTES) .Or. !(xPar1[nX][xPar2[3]] $ cAnTES) ) 
				nPosProd	:=	Ascan(aCopia,{|x| x[1] == xPar1[nX][xPar2[1]]})
				If nPosProd	> 0
					aCopia[nPosProd][2]	+=	xPar1[nX][xPar2[2]]
				Else
					AAdd(aCopia,{xPar1[nX][xPar2[1]],xPar1[nX][xPar2[2]],xPar1[nX][xPar2[3]]})
				Endif
			Endif
		Next
	EndIf

	//������������������������������������������������������������������������Ŀ
	//�Guarda o array aCopia original para bonificar regras identicas caso o   �
	//�parametro esteja ativo                                                  �	
	//��������������������������������������������������������������������������

	If lBonusTd
		aCopiaBk := aClone(aCopia)
	Endif	
	
	
	SA1->(DBSEEK(XFILIAL("SA1")+cCliente+cLoja))
	_VEND:=SA1->A1_VEND 
	_GRPREP:=SA1->A1_REGIAO
	
	
	SA3->(DBSEEK(XFILIAL("SA3")+_VEND))
	//_GRPREP:=SA3->A3_GRPREP
   //	_GRPREP:=SA1->A1_REGIAO
	
	
	
	
	
	dbSelectArea("ZZQ")
	dbSetOrder(1)
	#IFDEF TOP
		lQuery := .T.
		cCursor:= "FTRGRBONUS"
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("ZZQ")+" ZZQ "
		cQuery += "WHERE ZZQ.ZZQ_FILIAL='"+xFilial("ZZQ")+"' AND "
		If nRecs > 0
			cQuery	+=	"R_E_C_N_O_ IN ("
			For nX:=	1 To nRecs
				cQuery	+=	Alltrim(Str(aRecZZQ[nX]))+','
			Next	
			cQuery	+=	"0) AND "
		Endif
		cQuery += "(ZZQ.ZZQ_CODCLI = '"+cCliente+"'  OR    ZZQ.ZZQ_CODCLI='"+Space(Len(ZZQ->ZZQ_CODCLI))+"') AND "
		If !Empty(_GRPREP)
			cQuery += "((ZZQ.ZZQ_REG1 = '"+_GRPREP+"'  OR    ZZQ.ZZQ_REG2 = '"+_GRPREP+"'   OR  ZZQ.ZZQ_REG3 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG4 = '"+_GRPREP+"' OR  ZZQ.ZZQ_REG5 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG6 = '"+_GRPREP+"' OR ZZQ.ZZQ_REG7 = '"+_GRPREP+"') OR (ZZQ.ZZQ_REG1 = ''  AND    ZZQ.ZZQ_REG2 = ''   AND  ZZQ.ZZQ_REG3 = '' AND ZZQ.ZZQ_REG4 = '' AND  ZZQ.ZZQ_REG5 = '' AND ZZQ.ZZQ_REG6 = '' AND ZZQ.ZZQ_REG7 = ''))  AND "
		Endif
		cQuery += "(ZZQ.ZZQ_VEND1 = '' OR ZZQ.ZZQ_VEND1 = '"+cCodVend+"') AND "
		cQuery += "(ZZQ.ZZQ_LOJA = '"+cLoja+"' OR ZZQ.ZZQ_LOJA='"+Space(Len(ZZQ->ZZQ_LOJA))+"') AND "
		cQuery += "(ZZQ.ZZQ_CODTAB = '"+cTabPreco+"' OR ZZQ.ZZQ_CODTAB='"+Space(Len(ZZQ->ZZQ_CODTAB))+"') AND "
		cQuery += "(ZZQ.ZZQ_CONDPG = '"+cCondPg+"' OR ZZQ.ZZQ_CONDPG='"+Space(Len(ZZQ->ZZQ_CONDPG))+"') AND "
		cQuery += "(ZZQ.ZZQ_FORMPG = '"+cFormPg+"' OR ZZQ.ZZQ_FORMPG='"+Space(Len(ZZQ->ZZQ_FORMPG))+"') AND "
		cQuery += "ZZQ.ZZQ_TIPO  = '1' AND  "
		cQuery += "ZZQ.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY "+SqlOrder(ZZQ->(IndexKey()))
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
		For nX := 1 To Len(aStruZZQ)
			If aStruZZQ[nX][2] <> "C"
				TcSetField(cCursor,aStruZZQ[nX][1],aStruZZQ[nX][2],aStruZZQ[nX][3],aStruZZQ[nX][4])
			EndIf
		Next nX
	#ELSE
		dbSeek(xFilial("ZZQ"))
	#ENDIF
	While If(nRecs=0.Or.lQuery,!Eof(),nCnt	<=	nRecs)
		lValido:= .F.
		If !lQuery
			If nRecs	>	0
				ZZQ->(DbGoTo(aRecZZQ[nCnt]))
				nCnt++
			Endif	
			If ((ZZQ->ZZQ_CODCLI == cCliente .Or. Empty(ZZQ->ZZQ_CODCLI) ).And.;
					(ZZQ->ZZQ_LOJA == cLoja .Or. Empty(ZZQ->ZZQ_LOJA) ) .And.;
					(ZZQ->ZZQ_CODTAB == cTabPreco .Or. Empty(ZZQ->ZZQ_CODTAB) ) .And.;
					(ZZQ->ZZQ_CONDPG == cCondPg .Or. Empty(ZZQ->ZZQ_CONDPG) ) .And.;
					(ZZQ->ZZQ_VEND1 == cCodVend .Or. Empty(ZZQ->ZZQ_VEND1) ) .And. ;
					(ZZQ->ZZQ_FORMPG == cFormPg .Or. Empty(ZZQ->ZZQ_FORMPG) ) )
				lValido := .T.
			EndIf
		Else
			lValido := .T.
		EndIf	
		If FtIsDataOk("ZZQ",cCursor) .And. If(ZZQ->(FieldPos("ZZQ_GRPVEN"))>0, !Empty(FtIsGrpOk((cCursor)->ZZQ_GRPVEN,SA1->A1_GRPVEN)),.T.)
			If lValido
				lBonific := .T.
				aGrpZZR  := {}
				If (cCursor)->(FieldPos("ZZQ_LOTE"))>0
					nCabLote := Max((cCursor)->ZZQ_LOTE,0)
				Endif
				dbSelectArea("ZZR")
				dbSetOrder(1)
				#IFDEF TOP
					lQuery := .T.
					cCursor2 := cCursor+"A"
					cQuery := "SELECT * "
					cQuery += "FROM "+RetSqlName("ZZR")+" ZZR "
					cQuery += "WHERE ZZR.ZZR_FILIAL='"+xFilial("ZZR")+"' AND "
					cQuery += "ZZR.ZZR_CODREG='"+(cCursor)->ZZQ_CODREG+"' AND "
					cQuery += "ZZR.D_E_L_E_T_=' ' "
					cQuery += "ORDER BY "+SqlOrder(ZZR->(IndexKey()))
					
					cQuery := ChangeQuery(cQuery)
					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor2,.T.,.T.)
					For nX := 1 To Len(aStruZZR)
						If aStruZZR[nX][2] <> "C"
							TcSetField(cCursor2,aStruZZR[nX][1],aStruZZR[nX][2],aStruZZR[nX][3],aStruZZR[nX][4])
						EndIf
					Next nX			
				#ELSE
					MsSeek(xFilial("ZZR")+(cCursor)	->ZZQ_CODREG)
				#ENDIF
				aRemove := {}    
				aLote   := {}
				While ( !Eof() .And. (cCursor)->ZZQ_CODREG == (cCursor2)->ZZR_CODREG )
					
					If nCabLote == 0
						//������������������������������������������������������������������������Ŀ
						//�Busca por Produto                                                       �
						//��������������������������������������������������������������������������
						nY := aScan(aCopia,{|x| x[aPos[1]]==(cCursor2)->ZZR_CODPRO .And. x[aPos[2]]>=IIf(nCabLote>0,nCabLote,(cCursor2)->ZZR_LOTE) .And. x[aPos[3]]<>cTesBonus })
						//������������������������������������������������������������������������Ŀ
						//�Busca por Grupo                                                         �
						//��������������������������������������������������������������������������
						If nY == 0 .And. Empty((cCursor2)->ZZR_CODPRO)
						
							//������������������������������������������������������������������������Ŀ
							//�Cria um array dos grupos para analise acumulada                         �
							//��������������������������������������������������������������������������
							Aadd(aGrpZZR,{(cCursor2)->ZZR_CODPRO,.F.}) 
						
							For nX := 1 To Len(aCopia)
								cProduto := aCopia[nX][aPos[1]]
								nY := aScan(aGrupos,{|x| x[1] == cProduto})
								If nY == 0
									dbSelectArea("SB1")
									dbSetOrder(1)
									MsSeek(xFilial("SB1")+cProduto)
									cGrupo := SB1->B1_GRUPO
									aadd(aGrupos,{cProduto,cGrupo})
								Else
									cGrupo := aGrupos[nY][2]
								EndIf
								
								nY := 0
								
								If cGrupo == (cCursor2)->ZZR_GRUPO .And. aCopia[nX][aPos[2]]>=IIf(nCabLote>0,nCabLote,(cCursor2)->ZZR_LOTE)
									nY := nX
									
									//������������������������������������������������������������������������Ŀ
									//�Analisa caso seja bonificacao acumulada                                 �
									//��������������������������������������������������������������������������
									If lAcumula                    
										//������������������������������������������������������������������������Ŀ
										//�Se for somente um ja adiciona a bonificacao do produto do grupo         �
										//��������������������������������������������������������������������������
										If (cCursor)->ZZQ_TPRGBN == "2"	
											If nY <> 0
												Aadd(aRemove,{nY,Int(aCopia[nY][aPos[2]]/(cCursor2)->ZZR_LOTE),(cCursor2)->ZZR_LOTE,aCopia[nY][aPos[2]]})									
											Endif	
										Else        
											//������������������������������������������������������������������������Ŀ
											//�Se for somente todos marca o grupo da bonificacao como .T.              �
											//��������������������������������������������������������������������������
											If nY <> 0 
												Aadd(aRemove,{nY,Int(aCopia[nY][aPos[2]]/(cCursor2)->ZZR_LOTE),(cCursor2)->ZZR_LOTE,aCopia[nY][aPos[2]]})																				
												aGrpZZR[Len(aGrpZZR)][2] := .T.
											Endif								
										Endif	
									Else
										Exit
									Endif	
								EndIf
							Next nX

						Else
							If lAcumula
								//������������������������������������������������������������������������Ŀ
								//�Se acumula e encontrou o produto e bonificado                           �
								//��������������������������������������������������������������������������
								If ( nY <> 0 )
									Aadd(aRemove,{nY,Int(aCopia[nY][aPos[2]]/(cCursor2)->ZZR_LOTE),(cCursor2)->ZZR_LOTE,aCopia[nY][aPos[2]]})
								//������������������������������������������������������������������������Ŀ
								//�Se for todos e nao encontrou o produto nao bonifica                     �
								//��������������������������������������������������������������������������
								ElseIf (cCursor)->ZZQ_TPRGBN <> "2"
									aRemove	:=	{}
								EndIf
							Endif
						EndIf
						//������������������������������������������������������������������������Ŀ
						//�Avalia o tipo de Bonificacao                                            �
						//��������������������������������������������������������������������������
						//Se o tipo de bonificacao for "TODOS" e nao achei algum produto, zerar o aRemove e sair
						If !lAcumula
							If ( nY <> 0 )
								Aadd(aRemove,{nY,Int(aCopia[nY][aPos[2]]/(cCursor2)->ZZR_LOTE),(cCursor2)->ZZR_LOTE,aCopia[nY][aPos[2]]})
							ElseIf (cCursor)->ZZQ_TPRGBN <> "2"
								aRemove	:=	{}
								Exit
							EndIf
						Else
							//������������������������������������������������������������������������Ŀ
							//�Se acumula e bonifica todos analisa se algum grupo nao foi encontrado   �
							//��������������������������������������������������������������������������
							If (cCursor)->ZZQ_TPRGBN == "1"
								If Ascan(aGrpZZR,{|x| x[2] == .F.}) > 0
									aRemove := {}
								Endif	
							Endif								
						Endif
							
					Else
						Aadd(aLote,{(cCursor2)->ZZR_CODPRO,(cCursor2)->ZZR_GRUPO})
					EndIf
					dbSelectArea(cCursor2)
					dbSkip()
				EndDo
				If lQuery
					dbSelectArea(cCursor2)
					dbCloseArea()
					dbSelectArea(cCursor)
				EndIf
				//������������������������������������������������������������������������Ŀ
				//�Avalia as bonificacoes por lote de produto                              �
				//��������������������������������������������������������������������������
				nQuant	:=	(cCursor)->ZZQ_QUANT
				If nCabLote > 0
					nSoma	:=	0
					aSoma := {}
					For nZ := 1 To Len(aCopia)
						If !Empty(aCopia[nZ,aPos[1]])
							If aScan(aLote,{|x| aCopia[nZ,aPos[1]]==x[1] }) > 0
								aadd(aSoma,nZ)
								nSoma += aCopia[nZ,aPos[2]]
							EndIf
						Else
							cProduto := aCopia[nZ][aPos[1]]
							nY := aScan(aGrupos,{|x| x[1] == cProduto})
							If nY == 0
								dbSelectArea("SB1")
								dbSetOrder(1)
								MsSeek(xFilial("SB1")+cProduto)
								cGrupo := SB1->B1_GRUPO
								aadd(aGrupos,{cProduto,cGrupo})
							Else
								cGrupo := aGrupos[nY][2]
							EndIf
							If aScan(aLote,{|x| cGrupo==x[2] }) > 0
								aadd(aSoma,nZ)
								nSoma += aCopia[nZ,aPos[2]]
							EndIf
						EndIf
					Next nZ
						Bt090ChkLot(@nQuant,@aRemove,@nSoma,aSoma,aCopia,aPos,cCursor,nCabLote,@nMult)
				Else
					//�������������������������������������������������������������������������������Ŀ
					//�Definir o multiplicador dependendo do tipo de bonificacao, se for tipo "TODOS",�
					//�pego o m�nimo multiplo, se for "SOMENTE UM" pego o maximo multiplo.            �
					//���������������������������������������������������������������������������������
					For nX:=	1	To	Len(aRemove)
						If (cCursor)->ZZQ_TPRGBN=="1"
							nMult	:=	If(nX==1,aRemove[1][2],Min(aRemove[nX][2],nMult))
						Else 
							nMult	:=	If(nX==1,aRemove[1][2],Max(aRemove[nX][2],nMult))
						Endif
					Next							                                         
				Endif

				//������������������������������������������������������������������������Ŀ
				//�Avalia o tipo de Bonificacao                                            �
				//��������������������������������������������������������������������������
				If lBonific .And. Len(aRemove)>0
					While nQuant > 0
						For nX := 1 To Len(aRemove)   
							//��������������������������������������������������������������Ŀ
							//�Anular los items que foram usados em uma Regra de bonificacao �
							//�por lotes.                                                    �
							//����������������������������������������������������������������
							If nCabLote > 0
								aCopia[aRemove[nX][1]][aPos[2]]	:=	0
								nMult	:=	aRemove[nX][2]
							Else
								//���������������������������������������������������������������������������Ŀ
								//�Se o tipo de bonificacao for por "SOMENTE UM", vou dar bonificacao         �
								//�de acordo com o item que atingiu a maior bonificacao                       �
								//�����������������������������������������������������������������������������
								If (cCursor)->ZZQ_TPRGBN=="2" 
								
									If aRemove[nX][2] >= nMult
										aCopia[aRemove[nX][1]][aPos[2]] -= aRemove[nX][3] * nMult
										If !lAcumula
											Exit                                                       
										Endif	
									Endif
	
								//���������������������������������������������������������������������������Ŀ
								//�Se o tipo de bonificacao for por "TODOS", vou dar bonificacao de acordo com�
								//�o item que limitou a bonificacao (nMult)                                   �
								//�����������������������������������������������������������������������������
								Else
									aCopia[aRemove[nX][1]][aPos[2]] -= aRemove[nX][3] * nMult
								Endif
							Endif               
							
							If lAcumula //.And. (cCursor)->ZZQ_TPRGBN=="2" 
								nPosRet := Ascan(aRetorno,{|x| Alltrim(x[1]) == Alltrim((cCursor)->ZZQ_CODPRO) })
								If nPosRet == 0
									Aadd(aRetorno,{(cCursor)->ZZQ_CODPRO,aRemove[nX][2]*nQuant,cTesBonus,(cCursor)->ZZQ_CODREG})							
								Else
									aRetorno[nPosRet][2]+= aRemove[nX][2]*nQuant
								Endif		
							Endif	 
							
						Next nX
						
						If !lAcumula 
							Aadd(aRetorno,{(cCursor)->ZZQ_CODPRO,nMult*nQuant,cTesBonus,(cCursor)->ZZQ_CODREG})
						Endif
							
						nQuant	:=	0
						//�����������������������������������������������������������������������������������Ŀ
						//�Se o tipo de bonificacao for escalavel (por lotes) avaliar se o saldo do lote usado�
						//�ainda se ancaixa em alguma faixa menor.                                            �
						//�������������������������������������������������������������������������������������
						If nCabLote	>	0
							Bt090ChkLote(@nQuant,@aRemove,@nSoma,aSoma,aCopia,aPos,cCursor,nCabLote,@nMult)
						Endif
					Enddo
				EndIf
			Endif
		EndIf
		//������������������������������������������������������������������������Ŀ
		//�Verifica se deve continuar                                              �
		//��������������������������������������������������������������������������
		If !lBonusTd		
			nY := aScan(aCopia,{|x| x[aPos[2]]>0 })
			If nY == 0
				Exit
			EndIf
		Else                         
			//������������������������������������������������������������������������Ŀ
			//�Restaura o array aCopia para buscar novas regras de bonificacao         �
			//��������������������������������������������������������������������������
			aCopia := aClone(aCopiaBk)	
		Endif
			
		dbSelectArea(cCursor)
		dbSkip()
	EndDo
	If lQuery
		dbSelectArea(cCursor)
		dbCloseArea()
		dbSelectArea("ZZQ")
	EndIf
EndIf
RestArea(aAreaSF4)
RestArea(aArea)
Return(aRetorno)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtIsBonus � Autor �Eduardo Riera          � Data �15.05.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Verifica se o item refere-se a um Bonus                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: Array com a seguinte estrutura                       ���
���          �       [1] Codigo do Produto                                ���
���          �       [2] Quantidade                                       ���
���          �       [3] TES                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpL1: Indica que o item refere-se a um bonus               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo avaliar a regra de bonificacao���
���          �conforme os parametros da rotina                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Function FtIsBonus(aParam)

Local aArea  := GetArea()
Local lBonus := .T.
//������������������������������������������������������������������������Ŀ
//�Verifica se a tes eh valida                                             �
//��������������������������������������������������������������������������
If cTesBonus == Nil
	DEFAULT cTesBonus := &(GetMv("MV_BONUSTS"))
	If Empty(cTesBonus)
		lBonus := .F.
	Else
		//Trata se par�metro for num�rico
		If ValType(cTesBonus) == "N"
			cTesBonus := cValToChar(cTesBonus)
		EndIf
		
		dbSelectArea("SF4")
		dbSetOrder(1)
		If SubStr(cTesBonus,1,3)<="500" .Or. !MsSeek(xFilial("SF4")+cTesBonus)
			lBonus := .F.
		EndIf
	EndIf
	If !lBonus
		cTesBonus := Nil
	EndIf
EndIf
If aParam[3] <> cTesBonus
	lBonus := .F.
EndIf
RestArea(aArea)
Return(lBonus)
   */
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtDelBonus� Autor �Eduardo Riera          � Data �15.05.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua a delecao das regras de bonificacao                  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: aCols da GetDados ou Alias da GetDb                  ���
���          �ExpA2: Quando acols informar:                               ���
���          �       [1] Posicao do codigo do produto                     ���
���          �       [2] Posicao da Quantidade                            ���
���          �       [3] Posicao da TES                                   ���
���          �       [4] Controle de delecao                              ���
���          �       Quando GetDb informar:                               ���
���          �       [1] Nome do campo do codigo do produto               ���
���          �       [2] Nome do campo da quantidade                      ���
���          �       [3] Nome do campo da TES                             ���
���          �       [4] Nome do campo do controle de delecao             ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo deletar os bonus para reavali-���
���          �acao.                                                       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  
/*
Function FtDelBonus(xPar1,xPar2)

Local aArea   := GetArea()
Local aArea2  := {}
Local nX      := 0

If ValType(xPar1)=="C"
	dbSelectArea(xPar1)
	aArea2 := GetArea()
	dbGotop()
	While !Eof()
		If !FieldGet(FieldPos(xPar2[4]))
			If FtIsBonus({FieldGet(FieldPos(xPar2[1])),FieldGet(FieldPos(xPar2[2])),FieldGet(FieldPos(xPar2[3]))})
				FieldPut(FieldPos(xPar2[4]),.T.)
			EndIf
		EndIf
		dbSkip()
	EndDo
	RestArea(aArea2)
Else
	For nX := 1 To Len(xPar1)
		If !xPar1[nX,xPar2[4]]
			If FtIsBonus({ xPar1[nX,xPar2[1]],xPar1[nX,xPar2[2]],xPar1[nX,xPar2[3]] })
				xPar1[nX,xPar2[4]] := .T.
			EndIf
		EndIf
	Next Nx
EndIf
RestArea(aArea)
Return(xPar1)
  */
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �FtRecBonus� Autor �Eduardo Riera          � Data �15.05.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Efetua a delecao das regras de bonificacao                  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpA1: aCols da GetDados ou Alias da GetDb                  ���
���          �ExpA2: Quando acols informar:                               ���
���          �       [1] Posicao do codigo do produto                     ���
���          �       [2] Posicao da Quantidade                            ���
���          �       [3] Posicao da TES                                   ���
���          �       [4] Controle de delecao                              ���
���          �       Quando GetDb informar:                               ���
���          �       [1] Nome do campo do codigo do produto               ���
���          �       [2] Nome do campo da quantidade                      ���
���          �       [3] Nome do campo da TES                             ���
���          �       [4] Nome do campo do controle de delecao             ���
���          �ExpA3: Array com a seguinte estrutura:                      ���
���          �       [1] Codigo do Produto                                ���
���          �       [2] Quantidade                                       ���
���          �       [3] TES                                              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo deletar os bonus para reavali-���
���          �acao.                                                       ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
Function FtRecBonus(xPar1,xPar2,aBonus)

Local aArea   := GetArea()
Local aArea2  := {}
Local nX      := 0
Local nScan   := 0

If ValType(xPar1)=="C"
	dbSelectArea(xPar1)
	aArea2 := GetArea()
	dbGotop()
	While !Eof()
		If FieldGet(FieldPos(xPar2[4]))
			If FtIsBonus({FieldGet(FieldPos(xPar2[1])),FieldGet(FieldPos(xPar2[2])),FieldGet(FieldPos(xPar2[3]))})
				nScan := aScan(aBonus,{|x| x[1] == FieldGet(FieldPos(xPar2[1])) .And.;
					x[2] == FieldGet(FieldPos(xPar2[2])) .And.;
					x[3] == FieldGet(FieldPos(xPar2[3]))} )
				If nScan <> 0
					FieldPut(FieldPos(xPar2[4]),.F.)
					aDel(aBonus,nScan)
					aSize(aBonus,Len(aBonus)-1)
				EndIf
			EndIf
		EndIf
		dbSkip()
	EndDo
	RestArea(aArea2)
Else
	For nX := 1 To Len(xPar1)
		If xPar1[nX,xPar2[4]]
			If FtIsBonus({ xPar1[nX,xPar2[1]],xPar1[nX,xPar2[2]],xPar1[nX,xPar2[3]] })
				nScan := aScan(aBonus,{|x| x[1] == xPar1[nX,xPar2[1]] .And.;
					x[2] == xPar1[nX,xPar2[2]] .And.;
					x[3] == xPar1[nX,xPar2[3]]} )
				If nScan <> 0
					xPar1[nX,xPar2[4]] := .F.
					aDel(aBonus,nScan)
					aSize(aBonus,Len(aBonus)-1)
				EndIf
			EndIf
		EndIf
	Next nX
EndIf
RestArea(aArea)
Return(aBonus)

/*
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �Ft090Copia� Autor �Sergio Silveira        � Data �20/09/2001  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de Copia da Regra de Descontos                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �ExpX1 := Ft090Copia( ExcC1, ExpN1, ExpN2 )                    ���
���������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do Arquivo                                       ���
���          �ExpN1: Numero do Registro                                     ���
���          �ExpN2: Opcao do aRotina                                       ���
���������������������������������������������������������������������������Ĵ��
���Retorno   �ExpX1 -> Retorno da FT090RDES                                 ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
��� AtualizACOes sofridas desde a Construcao Inicial.                       ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
*/

USER Function Bt090Copia( cAlias, nRecno, nOpcao )

Local xRet

//��������������������������������������������������������������Ŀ
//� Faz a chamada passando o parametro de copia                  �
//����������������������������������������������������������������
xRet := Ft090RDes( cAlias, nRecno, nOpcao, , .T. )

Return( xRet )
/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  �FT090ChkLote�Autor  �Bruno Sobieski         �Fecha �  01/28/02���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina para avaliar a bonificao por lotes (escalavel).        ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe   �FT090ChkLote                                                  ���
���������������������������������������������������������������������������Ĵ��
���Parametros�nQuant  :Quantidade do bonus (pasada por referencia)          ���
���          �aRemove :Acumulado de produtos Utilizados em bonificacoes     ���
���          �           (pasada por referencia)                            ���
���          �nSoma   :Quantidade total de produtos (pasada por referencia) ���
���          �aSoma   :Array com o detalhe de PRODUTOxQuantidade            ���
���          �aCopia  :Saldo de produtos                                    ���
���          �aPos    :Posicoes do array aCopia                             ���
���          �cCursor :Alias em uso                                         ���
���          �nCabLote:1ro lote da escalabilidade                           ���
���          �nMult   :Multiplicador que determina "quantas vezes" deve ser ���
���          �          otorgada a bonificacao. (pasada por referencia)     ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Materiais/Distribuicao/Logistica                             ���
���������������������������������������������������������������������������Ĵ��
���Retorno   � Ver parametros recebidos por referencia.                     ���
���������������������������������������������������������������������������Ĵ��
��� Atualizaces sofridas desde a Construcao Inicial.                        ���
���������������������������������������������������������������������������Ĵ��
��� Programador  � Data   � BOPS �  Motivo da Alteracao                     ���
���������������������������������������������������������������������������Ĵ��
���              �        �      �                                          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/  


Static Function Bt090ChkLote(nQuant,aRemove,nSoma,aSoma,aCopia,aPos,cCursor,nCabLote,nMult)
Local cCnt		:=	"2"
Local nLote :=	0
Local nZ
If nSoma >= nCabLote               
	nQuant	:=	(cCursor)->ZZQ_QUANT       
	nLote		:=	nCabLote
	While (cCursor)->(FieldPos('ZZQ_LOTE'+cCnt)) > 0  .And. ;
			nSoma >= (cCursor)->(FieldGet(FieldPos('ZZQ_LOTE'+cCnt))) .And. ;
			(cCursor)->(FieldGet(FieldPos('ZZQ_LOTE'+cCnt)))  > 0
		nQuant:=	(cCursor)->(FieldGet(FieldPos('ZZQ_QUANT'+cCnt)))
		nLote	:=	(cCursor)->(FieldGet(FieldPos('ZZQ_LOTE'+cCnt)))
		cCnt	:=	SOMA1(cCnt)
	Enddo
	If Len(aSoma) == 0
		aRemove	:=	{}
	Else
		For nZ := 1 To Len(aSoma)
			Aadd(aRemove,{aSoma[nZ],Int(nSoma/nLote),Min(aCopia[nZ,aPos[2]],nLote)})
		Next nZ                                                                           
	Endif
	nMult	:=	Int(nSoma/nLote)
	aSoma	:=	{}
	If nLote > 0
		nSoma	-=	(Int(nSoma/nLote) * nLote)
	Endif
Else
	nQuant	:=	0
EndIf
Return
  */
/*/
���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �MenuDef   � Autor � Marco Bianchi         � Data �01/09/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Utilizacao de menu Funcional                               ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Array com opcoes da rotina.                                 ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Parametros do array a Rotina:                               ���
���          �1. Nome a aparecer no cabecalho                             ���
���          �2. Nome da Rotina associada                                 ���
���          �3. Reservado                                                ���
���          �4. Tipo de Transa��o a ser efetuada:                        ���
���          �		1 - Pesquisa e Posiciona em um Banco de Dados         ���
���          �    2 - Simplesmente Mostra os Campos                       ���
���          �    3 - Inclui registros no Bancos de Dados                 ���
���          �    4 - Altera o registro corrente                          ���
���          �    5 - Remove o registro corrente do Banco de Dados        ���
���          �5. Nivel de acesso                                          ���
���          �6. Habilita Menu Funcional                                  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function MenuDef()
     
Private aRotina := {	{ OemToAnsi(STR0001),"AxPesqui"	,0,1,0,.F.},;	  		//"Pesquisar"
							{ OemToAnsi(STR0002),"u_Bt090RDes" ,0,2,0,NIL},;		//"Visualizar"
							{ OemToAnsi(STR0003),"u_Bt090RDes" ,0,3,0,NIL},;		//"Incluir"
							{ OemToAnsi(STR0004),"U_Bt090RDes" ,0,4,0,NIL},;		//"Alterar"
							{ OemToAnsi(STR0005),"U_Bt090RDes" ,0,5,0,NIL},;		//"Excluir"
							{ OemToAnsi(STR0006),"u_Bt090Copia",0,3,0,NIL}}		//"Copiar"

If ExistBlock("FT090MNU")
	ExecBlock("FT090MNU",.F.,.F.)
EndIf

Return(aRotina)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft090Prod �Autor  �Andre Anjos	     � Data �  11/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao de validacao do produto digitado.                   ���
�������������������������������������������������������������������������͹��
���Uso       � FATA090                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static Function BFt090Prod()
Local lRet        := .T.
Local nITEMGR     := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_ITEMGR"})
Local nDESPRO     := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_DESPRO"})
Local nLOTE       := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_LOTE"})
Local lGrade      := !Empty(nITEMGR) .And. MaGrade()
Local cProduto	  := M->ZZR_CODPRO
Local lReferencia := MatGrdPrrf(@cProduto)

If lGrade
	oGrade:MontaGrade(n,cProduto,.T.,,lReferencia)
EndIf

If lReferencia
	aCols[n,nITEMGR] := "01"
	aCols[n,nDESPRO] := oGrade:GetDescProd(M->ZZR_CODPRO)
	aCols[n,nLOTE]   := 0
ElseIf (lRet := ExistCpo("SB1",M->ZZR_CODPRO))
	aCols[n,nDESPRO] := Posicione("SB1",1,xFilial("SB1")+M->ZZR_CODPRO,"B1_DESC")
	If !Empty(nITEMGR)
		aCols[n,nITEMGR] := CriaVar("ZZR_ITEMGR")
	EndIf
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ft090GrQtd�Autor  �Andre Anjos		 � Data �  10/11/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para exibicao da grade na digitacao do lote.		  ���
�������������������������������������������������������������������������͹��
���Uso       � FATA090                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function Ft090GrQtd()
Local nCODPRO  := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_CODPRO"})
Local nITEM    := aScan(aHeader,{|x| AllTrim(x[2]) == "ZZR_ITEM"})
Local lGrade   := ZZR->(FieldPos("ZZR_ITEMGR")) > 0 .And. MaGrade()
Local cProduto := aCols[n,nCODPRO]
If lGrade .And. MatGrdPrrf(@cProduto)
	oGrade:cProdRef := aCols[n,nCODPRO]
	oGrade:lShowGrd := .T.
	oGrade:nPosLinO := n	
	oGrade:Show("ZZR_LOTE")	
	&(ReadVar()) := oGrade:SomaGrade("ZZR_LOTE",oGrade:nPosLinO)
EndIf
Return .T.
