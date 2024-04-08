#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
#xCommand CLOSETRANSACTION LOCKIN <aAlias,...>   => EndTran( \{ <aAlias> \}  ); End Sequence

Static __lHasWSSTART    

/*����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    � BRCA410  � Rev.  � Evaldo V. Batista     � Data � 16.06.2005���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Programa de atualizacao de Pedidos de Venda                 ���
���          � Retirando os bot�es de rotinas de consulta de itens para    ���
���          � evitar acessos indevidos da informa��es de clientes e etc.  ���
���          � rotina customizada baseada em rotinas padr�o                ���
���          �                                                             ���
���          � Todas as rotinas de grava��o e valida��o s�o rotinas do     ���
���          � Microsiga padr�o mantendo total integridade.                ���
���          �                                                             ���
���          �                                                             ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Sintaxe   � Void MATA410(void)                                          ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
��������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ���
��������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                    ���
��������������������������������������������������������������������������Ĵ��
���              �        �      �                                         ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
����������������������������������������������������������������������������*/

User Function BrcA410(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja)
   

//������������������������������������������������������Ŀ
//� Define Variaveis                                     �
//��������������������������������������������������������                                    
Local aCores := {}
Local cRoda  := ""
Local bRoda  := {|| .T.}
Local xRet   := Nil
   
U_BCFGA002("BrcA410")//Grava detalhes da rotina usada

//��������������������������������������������������������������Ŀ
//� Gravacao do historico de acessos (ZGY e ZGZ)                 �
//����������������������������������������������������������������
If ExistBlock("GDVRDMENT") //Verifico rotina GDVRDMENT
	u_GDVRdmEnt() //Entrada na rotina
Endif

PRIVATE lOnUpdate  := .T.	
PRIVATE l410Auto   := xAutoCab <> NIL  .And. xAutoItens <> NIL
PRIVATE aAutoCab   := {}
PRIVATE aAutoItens := {}

// 15.02.06 - Almir Bandina - Na rotina padr�o MATA410 foi acrescentado um novo bot�o para efetuar a prepara��o de
// documentos, desta forma foi compatibilizado o array a rotina, pois existem pontos de entrada trocando fun��es
// do arotina e este tem que ficar compat�vel com o fonte padr�o.
PRIVATE aRotina := {	{ OemToAnsi(STR0001),	"AxPesqui"  ,0,1},;			//"Pesquisar"
							{ OemToAnsi(STR0002),	"U_A410Visual",0,2},;		//"Visual"
							{ OemToAnsi(STR0003),	"U_A410Inclui",0,3},;		//"Incluir"
							{ OemToAnsi(STR0004),	"U_A410Altera",0,4,20},; 	//"Alterar"
							{ OemToAnsi(STR0005),	"U_A410Deleta",0,5,21},;	//"Excluir"
							{ OemToAnsi(STR0006),	"A410Barra",0,3,0},;			//"Cod.barra"
							{ OemToAnsi(STR0042),	"U_A410PCopia",0,6},;		//"Copia"				
							{ OemToAnsi(STR0052),	"A410Devol",0,3},;			//"Dev.Compras"
							{ "Prep.Doc",				"U_A410Nota",0,3},;			//"Prep.Doc"
							{ OemToAnsi(STR0032),	"A410Legend" ,0,3,0} }    //"Legenda"

PRIVATE cCadastro := OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
If ( cPaisLoc != "BRA" )
	PRIVATE aArrayAE:={}
	PRIVATE lImpMsg:=.T.
EndIf

DEFAULT nOpcAuto := 3
DEFAULT lSimulacao := .F.
PRIVATE aHeadLEA :={} //Template GEM
PRIVATE aColsLEA :={} //Template GEM

If SC5->(FieldPos("C5_BLQ")) == 0
	aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA)",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E'",'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA)",'BR_AMARELO'}}	//Pedido Liberado
Else
	aCores := {{"Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ)",'ENABLE' },;		//Pedido em Aberto
				{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ)" ,'DISABLE'},;		   	//Pedido Encerrado
				{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ)",'BR_AMARELO'},;
				{ "C5_BLQ == '1'",'BR_AZUL'},;	//Pedido Bloquedo por regra
				{ "C5_BLQ == '2'",'BR_LARANJA'}}	//Pedido Bloquedo por verba
Endif
				
//�������������������������������������������Ŀ
//�Ajuste da Validacao e BOX do C5_TPCARGA    �
//���������������������������������������������


//�������������������������������������������Ŀ
//�Tratamento de Rotina Automatica            �
//���������������������������������������������

If ValType( cRotina ) == "C"
	//����������������������������������������������������������Ŀ
	//� Faz tratamento para chamada por outra rotina             �
	//������������������������������������������������������������
	If !Empty( nScan := AScan( aRotina, { |x| Upper(Alltrim(x[2])) == Upper(Alltrim(cRotina)) } ) ) 
		bRoda := &( "{ || " + cRotina + "( 'SC5', SC5->( Recno() ), " + Str(nScan,2) + If(ValType(cCodCli)=="C",",nil,nil,nil,nil,nil,cCodCli,cLoja", "" ) + ") } " )  
		xRet  := Eval( bRoda ) 
	EndIf 
	
Else    

	If  ( Type("l410Auto") <> "U" .And. l410Auto )
		lOnUpdate  := !lSimulacao
		aAutoCab   := xAutoCab
		aAutoItens := xAutoItens
		MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SC5")
		xAutoCab   := aAutoCab
		xAutoItens := aAutoItens	
	Else
		//������������������������������������������������������Ŀ
		//� Define variaveis de parametrizacao de lancamentos    �
		//��������������������������������������������������������
		//������������������������������������������������������Ŀ
		//� MV_PAR01 Sugere Quantidade Liberada ? Sim/Nao        �
		//� MV_PAR02 Preco Venda Com Substituicao ? Sim?Nao      �
		//� MV_PAR03 Utiliz.Op.Triangular     ?   Sim/Nao        �
		//��������������������������������������������������������
		//������������������������������������������������������Ŀ
		//� Ativa tecla F-10 para parametros                     �
		//��������������������������������������������������������
		SetKey(VK_F12,{|| a410Ativa()})

		//��������������������������������������������������������������Ŀ
		//� Ponto de Entrada para alterar cores do Browse do Cadastro    �
		//����������������������������������������������������������������
		If ExistBlock("MA410COR")
			aCores := ExecBlock("MA410COR",.F.,.F.,aCores)
		Endif	

		//������������������������������������������������������Ŀ
		//� Endereca a funcao de BROWSE                          �
		//��������������������������������������������������������
		If ExistBlock("MT410BRW")
			ExecBlock("MT410BRW",.F.,.F.)
		EndIf
		mBrowse( 6, 1,22,75,"SC5",,,,,,aCores)
	Endif
	
Endif
	
dbSelectArea("SC5")
dbSetOrder(1)
dbClearFilter()
SetKey(VK_F12,Nil)

//��������������������������������������������������������������Ŀ
//� Gravacao do historico de acessos (ZGY e ZGZ)                 �
//����������������������������������������������������������������
If ExistBlock("GDVRDMSAI") //Verifico rotina GDVRDMSAI
	u_GDVRdmSai() //Saida da rotina
Endif

Return(.T.)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Visual� Rev.  �Evaldo V. Batista  � Data �26.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Visualizacao do Pedido de Venda                             ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
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
User Function A410Visual(cAlias,nReg,nOpc)

Local aArea    := GetArea()
Local aHeadSC6 := {}
Local aCpos1   := {"C6_QTDVEN ","C6_QTDLIB"}
Local aCpos2   := {}
Local aBackRot := aClone(aRotina)
Local aPosObj  := {}
Local aObjects := {}
Local aSize    := {}
Local aPosGet  := {}
Local aInfo    := {}

Local lContinua:= .T.
Local lGrade   := MaGrade()
Local lQuery   := .F.
Local lHeadSC6 := .F.   
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)

Local nGetLin  := 0
Local nOpcA    := 0
Local nUsado   := 0
Local nTotPed  := 0
Local nTotDes  := 0
Local nCntFor  := 0
Local nNumDec  := TamSX3("C6_VALOR")[2]
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)

Local cArqQry  := ""
Local cCadastro:= OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
Local oDlg                                        

#IFDEF TOP
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 

DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//������������������������������������������������������Ŀ
//� Inicializa a Variaveis Privates.                     �
//��������������������������������������������������������
PRIVATE aTrocaF3  := {}
PRIVATE aTELA[0][0],aGETS[0]
PRIVATE aHeader	  := {}
PRIVATE aCols	  := {}
PRIVATE aColsGrade:= {}
PRIVATE aHeadGrade:= {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1
If Type("Inclui") == "U"
	Inclui := .F.
	Altera := .F.
EndIf
Pergunte("MTA410",.F.)
If ( lGrade )
	aRotina[nOpc][4] := 6
EndIf
//������������������������������������������������������Ŀ
//� Inicializa a Variaveis da Enchoice.                  �
//��������������������������������������������������������
RegToMemory( "SC5", .F., .F. )
//������������������������������������������������������Ŀ
//� Montagem do aHeader                                  �
//��������������������������������������������������������

lHeadSC6 := .f.
If __lHasWSSTART
	lHEADSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
	
	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
Else
	aHeader := aClone( aHeadSC6 ) 	
	nUsado  := Len( aHeader ) 
EndIf 	
	
For nCntFor := 1 To Len(aHeader)
	If aHeader[nCntFor][8] == "M"
		aadd(aCpos1,aHeader[nCntFor][2])
	EndIf
Next nCntFor
//������������������������������������������������������Ŀ
//� Montagem do aCols                                    �
//��������������������������������������������������������
dbSelectArea("SC6")
dbSetOrder(1)
#IFDEF TOP
	If Ascan(aHeader,{|x| x[8] == "M"}) == 0
		aStruSC6:= SC6->(dbStruct())
		cArqQry := "SC6"
		lQuery  := .T.
		cQuery := "SELECT * "
		cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
		cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
		cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
		cQuery += "SC6.D_E_L_E_T_<>'*' "
		cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

		cQuery := ChangeQuery(cQuery)

		dbSelectArea("SC6")
		dbCloseArea()
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
		For nCntFor := 1 To Len(aStruSC6)
			If ( aStruSC6[nCntFor,2]<>"C" )
				TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
			EndIf
		Next nCntFor
	Else
#ENDIF
	cArqQry := "SC6"
	MsSeek(xFilial("SC6")+SC5->C5_NUM)
	#IFDEF TOP
	EndIf
	#ENDIF
While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
		(cArqQry)->C6_NUM 	== SC5->C5_NUM )
	//������������������������������������������������������Ŀ
	//� Verifica se este item foi digitada atraves de uma    �
	//� grade, se for junta todos os itens da grade em uma   �
	//� referencia , abrindo os itens so quando teclar enter �
	//� na quantidade                                        �
	//��������������������������������������������������������
	If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
		a410Grade(.F.,,cArqQry)
	Else
		AADD(aCols,Array(Len(aHeader)))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else			
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		//��������������������������������������������������������������Ŀ
		//� Mesmo nao sendo um item digitado atraves de grade e' necessa-�
		//� rio criar o Array referente a este item para controle da     �
		//� grade                                                        �
		//����������������������������������������������������������������
		MatGrdMont(Len(aCols))
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
	
	dbSelectArea(cArqQry)
	dbSkip()
EndDo
nTotPed  -= M->C5_DESCONT
nTotDes  += M->C5_DESCONT
nTotDes  += A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
nTotPed  -= A410Arred(nTotPed*M->C5_PDESCAB/100,"C6_VALOR")
If ( lQuery )
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
If ( lContinua )
	//������������������������������������������������������Ŀ
	//� Faz o calculo automatico de dimensoes de objetos     �
	//��������������������������������������������������������
	aSize := MsAdvSize()
	aObjects := {}
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	AAdd( aObjects, { 100, 015, .t., .f. } )

	aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,;
		{{003,033,160,200,240,263}} )

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
	//������������������������������������������������������������������������Ŀ
	//� Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      �
	//��������������������������������������������������������������������������
	If ( M->C5_TIPO $ "DB" )
		aTrocaF3 := {{"C5_CLIENTE","SA2"}}
	Else
		aTrocaF3 := {}
	EndIf
	EnChoice( cAlias, nReg, nOpc, , , , , aPosObj[1],aCpos2,3,,,"A415VldTOk")
	nGetLin := aPosObj[3,1]
	@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
	@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!" OF oDlg PIXEL
	@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
	@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL
	@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
	@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL RIGHT
	@ nGetLin+10,aPosGet[1,5] SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
	@ nGetLin+10,aPosGet[1,6] SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
	oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
		oSay2:SetText(n2),;
		oSay3:SetText(n3),;
		oSay4:SetText(n4) }
	oGetd   := MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,,,"",,aCpos1,nColFreeze,,"A410FldOk",,,,,,lFreeze)	
	Ma410Rodap(oGetd,nTotPed,nTotDes)
	ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||nOpcA:=1,oDlg:End()},{||oDlg:End()},nOpc)
EndIf
aRotina := aClone(aBackRot)
RestArea(aArea)
Return( nOpcA )
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Altera� Rev.  �Evaldo V. Batista  � Data �26.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Alteracao do Pedido de Venda                                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
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
User Function A410Altera(cAlias,nReg,nOpc)

Local aArea     := GetArea()
Local aLiberado := {}
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aRegSC6   := {}
Local aRegSCV   := {}
Local aInfo     := {}
Local aHeadSC6  := {}
Local lLiber 	:= .F.
Local lTransf	:= .F.
Local lGrade	:= MaGrade()
Local lBloqueio := .T.
Local lNaoFatur := .F.
Local lContrat  := .F.
Local lQuery    := .F.
Local lContinua := .T.                             
Local lMt410Alt := Existblock("MT410ALT")
Local lM410Stts := ExistBlock("M410STTS")
Local lFreeze   := (GetMv("MV_PEDFREZ",.F.,0) <> 0)
//Local lAltPrcCtr:= (GetMv("MV_ALTCTR2",.F.,"2") == "1")
Local lAltPrcCtr:= GetMv("MV_ALTCTR",.F.,".F.") 
Local nOpcA		:= 0
Local nUsado    := 0
Local nCntFor   := 0
Local nTotalPed := 0
Local nTotalDes := 0
Local nPIdentB6 := 0
Local nPNfOrig  := 0
Local nPSerOrig := 0
Local nPItOrig  := 0
Local nAux	    := 0
Local nNumDec   := TamSX3("C6_VALOR")[2]
Local nGetLin   := 0
Local nStack    := GetSX8Len() 
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)
Local cArqQry   := "SC6"
Local cCadastro := OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
Local cCampo    := ""
Local oDlg
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4

#IFDEF TOP 
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 

DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//����������������������������������������������������������������������������Ŀ
//�Criar array PRIVATE p/ integracao com sistema de Distribuicao - NAO REMOVER �
//������������������������������������������������������������������������������
PRIVATE aDistrInd:={}
//������������������������������������������������������Ŀ
//� Variaveis utilizadas na LinhaOk                      �
//��������������������������������������������������������
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aColsGrade := {}
PRIVATE aHeadgrade := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1

//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������
PRIVATE aTELA[0][0],aGETS[0]
//������������������������������������������������������������������������Ŀ
//�Carrega perguntas do MATA440 e MATA410                                  �
//��������������������������������������������������������������������������
Pergunte("MTA440",.F.)
lLiber := MV_PAR02 == 1
lTransf:= MV_PAR01 == 1
Pergunte("MTA410",.F.)
//������������������������������������������������������Ŀ
//� Variavel utilizada p/definir Op. Triangulares.       �
//��������������������������������������������������������
IsTriangular( MV_PAR03==1 )
//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
IF ( (ExistBlock("M410ALOK")) )
	If (! ExecBlock("M410ALOK",.F.,.F.) )
		lContinua := .F.
	EndIf
EndIf
//�����������������������������������������������������������������������������������Ŀ
//�EXECUTAR CHAMADA DE FUNCAO p/ integracao com sistema de Distribuicao - NAO REMOVER �
//�������������������������������������������������������������������������������������
If lContinua .And. SuperGetMv("MV_FATDIST") == "S" // Apenas quando utilizado pelo modulo de Distribuicao
	lContinua:=D410Alok()
EndIf
IF ( SC5->C5_FILIAL <> xFilial("SC5") )
	Help(" ",1,"A000FI")
	lContinua := .F.
EndIf

//������������������������������������������������������Ŀ
//| Se o Pedido foi originado no SIGAEEC - Nao Altera    |
//��������������������������������������������������������
dbSelectArea("SC5")
IF !Empty(SC5->C5_PEDEXP) .And. nModulo == 5 .And. ( Type("l410Auto") == "U" .OR. !l410Auto )
	Help(" ",1,"MTA410ALT")
	lContinua := .F.
EndIf

//������������������������������������������������������Ŀ
//| Se o Pedido foi originado no SIGATMS - Nao Altera    |
//��������������������������������������������������������
If SC5->(FieldPos("C5_SOLFRE")) > 0 .And. !Empty(SC5->C5_SOLFRE)
	Help(" ",1,"A410TMSNAO")
	lContinua := .F.
EndIf

//������������������������������������������������������Ŀ
//| Verifica se o pedido tem carga montada               |
//��������������������������������������������������������
If OmsHasCg(SC5->C5_NUM)
	Help(" ",1,"A410CARGA")
Endif

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
If !SoftLock(cAlias)
	lContinua := .F.
EndIf
//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "SC5", .F., .F. )
//������������������������������������������������������Ŀ
//� Montagem do aHeader                                  �
//��������������������������������������������������������
//������������������������������������������������������Ŀ
//� Montagem do aHeader                                  �
//��������������������������������������������������������

lHeadSC6 := .f.
If __lHasWSSTART
	lHEADSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
				
			If ( AllTrim(SX3->X3_CAMPO)=="C6_IDENTB6" )
				nPIdentB6 := nUsado
			EndIf
			If ( AllTrim(SX3->X3_CAMPO)=="C6_NFORI" )
				nPNfOrig := nUsado
			EndIf
			If ( AllTrim(SX3->X3_CAMPO)=="C6_SERIORI" )
				nPSerOrig:= nUsado
			EndIf
			If ( AllTrim(SX3->X3_CAMPO)=="C6_ITEMORI" )
				nPItOrig := nUsado
			EndIf
			
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo   
	
	If lHEADSC6
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
Else
	aHeader := aClone( aHeadSC6 ) 	
	nUsado    := Len(aHeader)
	nPIdentB6 := aScan(aHeader,{|x| AllTrim(x[2])=="C6_IDENTB6"})
	nPNfOrig  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
	nPSerOrig := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
	nPItOrig  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})	
EndIf 	

If ( lContinua )
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !InTransact() .And. Ascan(aHeader,{|x| x[8] == "M"}) == 0
			cArqQry := "SC6"
			aStruSC6:= SC6->(dbStruct())
			lQuery  := .T.
			cQuery := "SELECT SC6.*,SC6.R_E_C_N_O_ SC6RECNO "
			cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
			cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
			cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
			cQuery += "SC6.D_E_L_E_T_<>'*' "
			cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("SC6")
			dbCloseArea()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
			For nCntFor := 1 To Len(aStruSC6)
				If ( aStruSC6[nCntFor,2]<>"C" )
					TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		cArqQry := "SC6"
		MsSeek(xFilial("SC6")+SC5->C5_NUM)
		#IFDEF TOP
		EndIf
		#ENDIF
	//������������������������������������������������������Ŀ
	//� Montagem do aCols                                    �
	//��������������������������������������������������������
	While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
			(cArqQry)->C6_NUM == SC5->C5_NUM .And. lContinua )
		If SC5->C5_TIPO$"CIP"
			If Empty((cArqQry)->C6_NOTA)
				lNaoFatur := .T.
			EndIf
		Else
			If ( (cArqQry)->C6_QTDENT < (cArqQry)->C6_QTDVEN )
				lNaoFatur := .T.
			EndIf
		EndIf
		If !(("R"$Alltrim((cArqQry)->C6_BLQ)).And.(SuperGetMv("MV_RSDOFAT")=="N"))
			lBloqueio := .F.
		EndIf
		If !Empty((cArqQry)->C6_CONTRAT) .And. !lContrat
			dbSelectArea("ADB")
			dbSetOrder(1)
			If MsSeek(xFilial("ADB")+(cArqQry)->C6_CONTRAT+SC6->C6_ITEMCON)
				If ADB->ADB_QTDEMP > 0 .And. ADB->ADB_PEDCOB == (cArqQry)->C6_NUM
					lContrat := .T.
				EndIf
			EndIf
			dbSelectArea(cArqQry)
		EndIf
		//������������������������������������������������������Ŀ
		//� Verifica se este item foi digitada atraves de uma    �
		//� grade, se for junta todos os itens da grade em uma   �
		//� referencia , abrindo os itens so quando teclar enter �
		//� na quantidade                                        �
		//��������������������������������������������������������
		If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
			a410Grade(.T.,,cArqQry)
		Else
			AADD(aCols,Array(Len(aHeader)+1))
			For nCntFor := 1 To Len(aHeader)
				cCampo := Alltrim(aHeader[nCntFor,2])
				If ( aHeader[nCntFor,10] # "V" .And. cCampo <> "C6_QTDLIB" )
					aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(cCampo))
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(cCampo)
				EndIf
			Next nCntFor
			//��������������������������������������������������������������Ŀ
			//� Mesmo nao sendo um item digitado atraves de grade e' necessa-�
			//� rio criar o Array referente a este item para controle da     �
			//� grade                                                        �
			//����������������������������������������������������������������
			MatGrdMont(Len(aCols))
		EndIf
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
		nTotalPed += (cArqQry)->C6_VALOR
		If ( (cArqQry)->C6_PRUNIT = 0 )
			nTotalDes += (cArqQry)->C6_VALDESC
		Else
			nTotalDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
		EndIf
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		//������������������������������������������������������������������������Ŀ
		//�Guarda os registros do SC6 para posterior gravacao                      �
		//��������������������������������������������������������������������������
		aadd(aRegSC6,If(lQuery,(cArqQry)->SC6RECNO,(cArqQry)->(RecNo())))
		dbSelectArea(cArqQry)
		dbSkip()
	EndDo
	nTotalPed  -= M->C5_DESCONT
	nTotalDes  += M->C5_DESCONT
	nTotalDes  += A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")
	nTotalPed  -= A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")
	If ( lQuery )
		dbSelectArea(cArqQry)
		dbCloseArea()
		ChkFile("SC6",.F.)
		dbSelectArea("SC6")
	EndIf
EndIf
//�����������������������������������������������Ŀ
//�Monta o array com as formas de pagamento do SX5�
//�������������������������������������������������
Ma410MtFor(@aHeadFor,@aColsFor,@aRegSCV)
//������������������������������������������������������Ŀ
//� Caso nao ache nenhum item , abandona rotina.         �
//��������������������������������������������������������
If ( lContinua )
	If ( Len(aCols) == 0 )
		lContinua := .F.
		Help(" ",1,"A410S/ITEM")
	EndIf
	If ( (ExistBlock("M410GET")) )
		ExecBlock("M410GET",.F.,.F.)
	EndIf
	If ( lBloqueio )
		Help(" ",1,"A410ELIM")
		lContinua := .F.
	EndIf
	If (!(SuperGetMv("MV_ALTPED")=="S") .And. !lNaoFatur)
		Help(" ",1,"A410PEDFAT")
		lContinua := .F.
	EndIf
	If ( lContrat ) .And. !lAltPrcCtr
		Help(" ",1,"A410CTRPAR")
		lContinua := .F.
	EndIf
EndIf
If ( lContinua )   

	//������������������������������������������������������Ŀ
	//� Atualiza com cliente original do pedido caso troque  �
	//��������������������������������������������������������
	A410ChgCli(M->C5_CLIENTE+M->C5_LOJACLI)

	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .f. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//������������������������������������������������������Ŀ
		//� Armazenar dados do Pedido anterior.                  �
		//��������������������������������������������������������
		IF M->C5_TIPO $ "DB"
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		EnChoice( "SC5", nReg, nOpc, , , , , aPosObj[1],,3,,,"A415VldTOk")
		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)	SIZE 050,09 OF oDlg PIXEL		
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL 	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		If cPaisLoc == "BRA"				
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,2) OF oDlg PIXEL RIGHT
		Else
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
		EndIf
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		Set Key VK_F4 to A440Stok(NIL,"A410")
		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"A410LinOk","A410TudOk","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,,nColFreeze,,ITENSSC6*IIF(MaGrade(),1,3.33),"A410Blq()",,,"A410ValDel()",,lFreeze)		
		Private oGetDad:=oGetd
		A410Bonus(2)
		Ma410Rodap(oGetD,nTotalPed,nTotalDes)
		ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||nOpcA:=1,if(A410VldTOk().And.oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||Iif( Ma410VldUs(nOpca), oDlg:End(),  )},nOpc)
		SetKey(VK_F4,)
	Else
		//��������������������������������������������������������������Ŀ
		//� validando dados pela rotina automatica                       �
		//����������������������������������������������������������������
		If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"A410LinOk",{|| A410VldTOk() .and. A410TudOk},aAutoCab,aRotina[nOpc][4])
			nOpcA := 1
		EndIf
	EndIf
	If ( nOpcA == 1 )
		A410Bonus(1)
		If Type("lOnUpDate") == "U" .Or. lOnUpdate
			If a410Trava()
				//�����������������������������������������������������������Ŀ
				//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
				//�������������������������������������������������������������
				PcoIniLan("000100") 
				Begin Transaction
					If !A410Grava(lLiber,lTransf,2,aHeadFor,aColsFor,aRegSC6,aRegSCV,nStack)
						Help(" ",1,"A410NAOREG")
					EndIf
				End Transaction
				//�����������������������������������������������������������Ŀ
				//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
				//�������������������������������������������������������������
				PcoFinLan("000100")
				
				If lMt410Alt
					Execblock("MT410ALT",.F.,.F.)
				Endif

				If lM410Stts
				ExecBlock("M410STTS",.f.,.f.)			
				Endif
			EndIf
		Else
			aAutoCab := MsAuto2Ench("SC5")
			aAutoItens := MsAuto2Gd(aHeader,aCols)
		EndIf
	Else
		If ( (ExistBlock("M410ABN")) )
			ExecBlock("M410ABN",.f.,.f.)
		EndIf
	EndIf
EndIf

//������������������������������������������������������������������������Ŀ
//�Limpa cliente anterior para proximo pedido                              �
//��������������������������������������������������������������������������
a410ChgCli("")

//������������������������������������������������������������������������Ŀ
//�Destrava Todos os Registros                                             �
//��������������������������������������������������������������������������
MsUnLockAll()
RestArea(aArea)
Return( nOpcA )
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Inclui� Rev.  �Evaldo V. Batista  � Data �26.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Inclusao do do pedido de venda                              ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
���          �ExpL4: Indica se a inclusao vem de um orcamento             ���
���          �ExpL5: Recnos do arquivo SC5 de um orcamento                ���
���          �ExpL6: Indica se a inclusao vem de um contrato de parceria  ���
���          �ExpN7: Tipo do contrato (1=Aprovacao / 2=Remessa)           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
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
User Function A410Inclui(cAlias,nReg,nOpc,lOrcamento,nStack,aRegSCK,lContrat,nTpContr,cCodCli,cLoja,cMedPMS)

Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aInfo     := {}
Local aCpos     := Nil
Local aHeadSC6  := {}
Local nOpcA 	:= 0
Local nCntFor	:= 0
Local nNumDec   := TamSX3("C6_VALOR")[2]
Local nGetLin   := 0
Local nUsado	:= 0
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)
Local cCadastro := OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
Local cPedido   := "" 
Local cCpoContr := SuperGetMv("MV_CPOCONT",.F.,"C6_QTDVEN|C6_QTDLIB|C6_PRCVEN|C6_PRCUNIT")
Local cHblContr := SuperGetMv("MV_HBLCONT",.F.,"22")
Local cReadBkp  := ReadVar()
Local lHabilOrc := SuperGetMv("MV_HBLORC",.F.,"1") == "1"
Local lMt410Inc := Existblock("MT410INC")
Local lM410Stts := ExistBlock("M410STTS")
Local lLiber	:= .F.
Local lTransf	:= .F.                                   
Local lProperty := .F.
Local lMemory   := .F.
Local lHeadSC6  := .F.                           
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)
Local oDlg
Local oGetD
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
                        
DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")
DEFAULT nStack := GetSX8Len() 
DEFAULT cCodCli   := ""
DEFAULT cLoja     := ""

//����������������������������������������������������������������������������Ŀ
//�Criar array PRIVATE p/ integracao com sistema de Distribuicao - NAO REMOVER �
//������������������������������������������������������������������������������
PRIVATE aDistrInd:={}
//������������������������������������������������������������������������Ŀ
//�Carrega perguntas do MATA440 e MATA410                                  �
//��������������������������������������������������������������������������
Pergunte("MTA440",.F.)
lLiber := MV_PAR02 == 1
lTransf:= MV_PAR01 == 1
Pergunte("MTA410",.F.)
//������������������������������������������������������Ŀ
//� Variavel utilizada p/definir Op. Triangulares.       �
//��������������������������������������������������������
IsTriangular( (MV_PAR03==1) )
//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������
PRIVATE aTela[0][0]
PRIVATE aGets[0]
PRIVATE bArqF3
PRIVATE bCpoF3
PRIVATE aTrocaF3  := {}
PRIVATE aHeadFor  := {}
PRIVATE aColsFor  := {}
PRIVATE N         := 1

DEFAULT aRegSCK   := {} 
DEFAULT nTpContr  := 0

//������������������������������������������������������������������������Ŀ
//�O Orcamento de Venda n�o permite grade de produtos                      �
//��������������������������������������������������������������������������
lOrcamento := If(ValType(lOrcamento)=="L",lOrcamento,.F.)
lContrat   := If(ValType(lContrat)  =="L",lContrat  ,.F.)
l416Auto   := If (Type("l416Auto") == "U",.f.,l416Auto)
//������������������������������������������������������������������������Ŀ
//�A inicializacao das variaveis ja foi feita pela rotina de Orcamento     �
//��������������������������������������������������������������������������
If ( !lOrcamento )
	PRIVATE aColsGrade:= {}
	PRIVATE aHeadGrade:= {}
	PRIVATE aHeader   := {}
	PRIVATE aCols     := {}
	//������������������������������������������������������Ŀ
	//� Salva a integridade dos campos de Bancos de Dados    �
	//��������������������������������������������������������
	dbSelectArea("SC5")
	dbSetOrder(1)
	//���������������������������������������������������������������������������Ŀ
	//� Inicializa desta forma para criar uma nova instancia de variaveis private �
	//�����������������������������������������������������������������������������
	RegToMemory( "SC5", .T., .F. )                           
	
	lHeadSC6 := .f.
	If __lHasWSSTART
		lHeadSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
	EndIf
	
	If !lHEADSC6
		dbSelectArea("SX3")
		dbSetOrder(1)    
		MsSeek("SC6")
		While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
			If ( X3USO(SX3->X3_USADO) .And.;
					!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
					Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
					Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
					cNivel >= SX3->X3_NIVEL )
				nUsado++
				Aadd(aHeader,{ TRIM(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo       
		
		If __lHasWSSTART
			WS_HEADSC6(.f.,cEmpAnt,aHeader)
		EndIf 	
	Else
		aHeader := aClone( aHeadSC6 ) 	
		nUsado  := Len(aHeader)		
	EndIf 	
	
	//������������������������������������������������������Ŀ
	//�Montagem do aCols                                     �
	//��������������������������������������������������������
	aadd(aCOLS,Array(nUsado+1))
	For nCntFor	:= 1 To nUsado
		aCols[1][nCntFor] := CriaVar(aHeader[nCntFor][2])
		If ( AllTrim(aHeader[nCntFor][2]) == "C6_ITEM" )
			aCols[1][nCntFor] := "01"
		EndIf
	Next nCntFor
	aCOLS[1][Len(aHeader)+1] := .F.
	
	If !Empty(cCodCli) .And. !Empty(cLoja)
	
		ALTERA   := (aRotina[nOpc,4] == 4)
		INCLUI   := (aRotina[nOpc,4] == 3)
		lRefresh := .T.		

		M->C5_CLIENTE := cCodCli		
		__ReadVar := "M->C5_CLIENTE"
		lRet := CheckSX3("C5_CLIENTE")
		
		If lRet
			If ExistTrigger("C5_CLIENTE")
				RunTrigger(1,Nil,Nil,,"C5_CLIENTE")
			Endif	                
			

			M->C5_LOJACLI := cLoja
			__ReadVar := "M->C5_LOJACLI"
			lRet := CheckSX3("C5_LOJACLI")
			
			If lRet	
				If ExistTrigger("C5_CLIENTE")
					RunTrigger(1,Nil,Nil,,"C5_LOJACLI")
				Endif	
			Endif	
			
		Endif	

		__ReadVar := cReadBkp
		
	Endif
	
EndIf                                                     

//���������������������������������������������������������Ŀ
//�Verifica os campos do contrato se serao habilitados      �
//�����������������������������������������������������������
If lContrat
	//������������������������������������������������������������Ŀ
	//�Verifica os os parametros estao ativos para a movimentacao  �
	//��������������������������������������������������������������
	If (nTpContr == 1 .And. SubStr(cHblContr,1,1) == "1") .Or. (nTpContr == 2 .And. SubStr(cHblContr,2,1) == "1")
		aCpos:= {}
		For nCntFor := 1 To Len(aHeader)
			//���������������������������������������������������������Ŀ
			//�Verifica o campos esta no parametro MV_CPOCONTR          �
			//�����������������������������������������������������������
			If !(Alltrim(aHeader[nCntFor][2]) $ cCpoContr)
				aadd(aCpos,aHeader[nCntFor][2])
			EndIf
		Next nCntFor
	Endif	
Endif	

//���������������������������������������������������������������������������������������Ŀ
//�Verifica os campos da Medicao do PMS que serao liberados para visualizacao na getdados �
//�����������������������������������������������������������������������������������������
If cMedPMS <> Nil
	aCpos:= {}
	For nCntFor := 1 To Len(aHeader)
		//���������������������������������������������������������Ŀ
		//�Verifica o campos esta no parametro MV_CPOCONTR          �
		//�����������������������������������������������������������
		If !(Alltrim(aHeader[nCntFor][2]) $ cMedPMS)
			aadd(aCpos,aHeader[nCntFor][2])
		EndIf
	Next nCntFor
EndIf

//�����������������������������������������������Ŀ
//�Monta o array com as formas de pagamento do SX5�
//�������������������������������������������������
Ma410MtFor(@aHeadFor,@aColsFor)
//������������������������������������������������������������������������Ŀ
//� Estabelece a Troca de Clientes conforme o Tipo do Pedido de Venda      �
//��������������������������������������������������������������������������
If ( M->C5_TIPO $ "DB" )
	aTrocaF3 := {{"C5_CLIENTE","SA2"}}
Else
	aTrocaF3 := {}
EndIf
//������������������������������������������������������Ŀ
//�Verifica se eh rotina de inclusao automatica          �
//��������������������������������������������������������
If ( Type("l410Auto") == "U" .Or. ! l410Auto )
	If !( l416Auto )
	
		//������������������������������������������������������������������������Ŀ
		//� Caso seja orcamento verifica se o parametro permite a alteracao do     �
		//� pedido na efetivacao. Caso nao permita troca variaveis de parametro da �		
		//� Enchoice para apenas visualizacao.                                     �		
		//��������������������������������������������������������������������������
		If lOrcamento .And. !lHabilOrc	
			nOpc      := 2
			lProperty := .T.
			lMemory   := .T.
		Endif	

		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .f. } )	
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		EnChoice( "SC5", nReg, nOpc, , , , , aPosObj[1],,3,,,"A415VldTOk",,,lMemory,,,,lProperty)		
		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg	PIXEL //"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg PIXEL
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg	PIXEL	RIGHT
		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		SetKey(VK_F4,{||A440Stok(NIL,"A410")})
		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"A410LinOk","A410TudOk","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,aCpos,nColFreeze,,ITENSSC6*IIF(MaGrade(),1,3.33),,,,,,lFreeze)		
		Private oGetDad:=oGetd
		If Type("lCodBarra") <> "U"
			oGetd:oBrowse:bGotFocus:={|| IIF(lCodBarra,a410EntraBarra(oGetD),)}
		EndIf
		A410Bonus(2)
		Ma410Rodap(oGetd)
		ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||nOpcA:=1,If(A410VldTOk().And.oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA:=0,oDlg:End()),nOpcA:=0)},{||Iif(Ma410VldUs(nOpca),oDlg:End(), ) },nOpc)
		SetKey(VK_F4,)
	EndIf
Else
	//�������������������������������������������������������������Ŀ
	//� Variaveis utilizadas pela rotina de inclusao automatica     �
	//���������������������������������������������������������������
	If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"A410LinOk",{|| A410VldTOk() .and. A410TudOk},aAutoCab)
		nOpcA := 1
	EndIf
EndIf
If ( l416Auto )
	A410TudOk
	nOpcA := 1
EndIf
//������������������������������������������������������������������������Ŀ
//�Efetua a Gravacao do Pedido de Venda                                    �
//��������������������������������������������������������������������������
If ( nOpcA == 1 )  

	If lOrcamento
		a410Trava()
	Endif	

	A410Bonus(1)
	cPedido := M->C5_NUM
	
	//������������������������������������������������������������������������Ŀ
	//�Verifica se eh orcamento para realizar a transacao total e nao por item �
	//��������������������������������������������������������������������������
	If Type("lOnUpDate") == "U" .Or. lOnUpdate
		If lOrcamento	

			//������������������������������������������������������������������������Ŀ
			//� Troca o status de visualizacao para inclusao caso nao permita a alte   �
			//� racao do pedido de venda na efetivacao do orcamento                    �		
			//��������������������������������������������������������������������������
	
			If !lHabilOrc	
				INCLUI := .T.
			Endif	
		
			//�����������������������������������������������������������Ŀ
			//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
			//�������������������������������������������������������������
			PcoIniLan("000100") 
			Begin Transaction
				If ( !A410Grava(lLiber,lTransf,1,aHeadFor,aColsFor) )
					Help(" ",1,"A410NAOREG")
				Else	
					If ( cPedido <> M->C5_NUM )
						If !( Type("l410Auto") <> "U" .And. l410Auto )
							Help(" ",1,"NUMSEQ",,M->C5_NUM,4,15)
						EndIf
					EndIf
				EndIf
				//������������������������������������������������������������������������Ŀ
				//�Chama  funcao de atualizacao do orcamento com os dados do pedido        �
				//��������������������������������������������������������������������������			
				M416AtuSCK(aRegSCK)
	
			End Transaction
			//�����������������������������������������������������������Ŀ
			//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
			//�������������������������������������������������������������
			PcoFinLan("000100")

		Else	
			//�����������������������������������������������������������Ŀ
			//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
			//�������������������������������������������������������������
			PcoIniLan("000100") 

			If ( !A410Grava(lLiber,lTransf,1,aHeadFor,aColsFor,NIL,NIL,nStack) )
				Help(" ",1,"A410NAOREG")
			Else	
				If ( cPedido <> M->C5_NUM )
					If !( Type("l410Auto") <> "U" .And. l410Auto )
						Help(" ",1,"NUMSEQ",,M->C5_NUM,4,15)
					EndIf
				EndIf
			EndIf
			//�����������������������������������������������������������Ŀ
			//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
			//�������������������������������������������������������������
			PcoFinLan("000100")
			
		Endif
	Else
		aAutoCab := MsAuto2Ench("SC5")
		aAutoItens := MsAuto2Gd(aHeader,aCols)	
	EndIf		
	
	If lMt410Inc
		Execblock("MT410INC",.F.,.F.)
	Endif
	
	If lM410Stts
		ExecBlock("M410STTS",.f.,.f.)			
	EndIf
Else
	If !( nModulo <> 5 .And. Type("l410Auto") <> "U" .And. l410Auto)
		While GetSX8Len() > nStack 
			RollBackSX8()
		EndDo 
	EndIf
	If ( (ExistBlock("M410ABN")) )
		ExecBlock("M410ABN",.f.,.f.)
	EndIf
EndIf

//������������������������������������������������������������������������Ŀ
//�Limpa cliente anterior para proximo pedido                              �
//��������������������������������������������������������������������������
a410ChgCli("")

//������������������������������������������������������������������������Ŀ
//�Restaura a Integridade da Tela de Entrada                               �
//��������������������������������������������������������������������������
dbSelectArea(cAlias)
Return( nOpcA )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Deleta� Rev.  �Evaldo V. Batista  � Data �26.08.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Delecao do Pedido de Venda                                  ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
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
User Function A410Deleta(cAlias,nReg,nOpc)

Local aArea     := GetArea()
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aRegSC6   := {}
Local aRegSCV   := {}
Local aInfo     := {}
Local aHeadSC6  := {}
Local lLiber 	:= .F.
Local lContinua := .T.
Local lGrade	:= MaGrade()
Local lFaturado := .F.
Local lQuery    := .F.
Local lContrat  := .F.
Local lPedTLMK  := .F.
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)
Local nOpcA		:= 0
Local nUsado    := 0
Local nCntFor   := 0
Local nTotalPed := 0
Local nTotalDes := 0
Local nGetLin   := 0
Local nNumDec   := TamSX3("C6_VALOR")[2]                
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)
Local cCampo	:= ""
Local cArqQry   := "SC6"
Local cCadastro := OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
Local oDlg
Local oGetd
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4                    

#IFDEF TOP 
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 
                                                    
DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//������������������������������������������������������Ŀ
//� Variaveis utilizadas na LinhaOk                      �
//��������������������������������������������������������
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aColsGrade := {}
PRIVATE aHeadgrade := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1
PRIVATE aOPs       := {}
PRIVATE aTELA[0][0],aGETS[0]
//������������������������������������������������������������������������Ŀ
//�Carrega perguntas do MATA440 e MATA410                                  �
//��������������������������������������������������������������������������
Pergunte("MTA440",.F.)
lTransf:= MV_PAR01 == 1
Pergunte("MTA410",.F.)
//������������������������������������������������������Ŀ
//� Variavel utilizada p/definir Op. Triangulares.       �
//��������������������������������������������������������
IsTriangular( MV_PAR03==1 )
//������������������������������������������������������Ŀ
//� Executa o ponto de entrada M410ALOK                  �
//��������������������������������������������������������
dbSelectArea(cAlias)
IF ( (ExistBlock("M410ALOK")) )
	If (! ExecBlock("M410ALOK",.F.,.F.) )
		lContinua := .F.
	EndIf
EndIf
//�����������������������������������������������������������������������������������Ŀ
//�EXECUTAR CHAMADA DE FUNCAO p/ integracao com sistema de Distribuicao - NAO REMOVER �
//�������������������������������������������������������������������������������������
If lContinua .And. SuperGetMv("MV_FATDIST") == "S" // Apenas quando utilizado pelo modulo de Distribuicao
	lContinua:=D410Alok()
EndIf
IF ( SC5->C5_FILIAL <> xFilial("SC5") )
	Help(" ",1,"A000FI")
	lContinua := .F.
EndIf
//������������������������������������������������������Ŀ
//| Se o Pedido foi originado no SIGAEEC - Nao Exclui    |
//��������������������������������������������������������
dbSelectArea("SC5")
IF !Empty(SC5->C5_PEDEXP)  .AND. NMODULO == 5 .And. ( Type("l410Auto") == "U" .OR. !l410Auto )
	Help(" ",1,"MTA410DEL")
	lContinua := .F.
EndIf

//������������������������������������������������������Ŀ
//| Verifica se o pedido tem carga montada               |
//��������������������������������������������������������
If OmsHasCg(SC5->C5_NUM)
	Help(" ",1,"A410CARGA")
Endif

//������������������������������������������������������Ŀ
//| Se o Pedido foi originado no SIGATMS, verificar se   |
//| existe NF de Conhecimento.                           |
//��������������������������������������������������������
If SC5->(FieldPos("C5_SOLFRE")) > 0 .And. !Empty(SC5->C5_SOLFRE)
	DT5->(dbSetOrder(1))
	If DT5->(dbSeek(xFilial("SC5")+SC5->C5_SOLFRE+SC5->C5_ITESOL))
		Help(" ",1, "A410NFCON")
		lContinua := .F.
	EndIf
EndIf

//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
If !SoftLock(cAlias)
	lContinua := .F.
EndIf
//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "SC5", .F., .F. )

lHeadSC6 := .f.
If __lHasWSSTART
	lHeadSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo               
	
	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
Else
	aHeader := aClone( aHeadSC6 ) 	
	nUsado  := Len(aHeader)		
EndIf 	

If ( lContinua )
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		If ( TcSrvType()<>"AS/400"  .And. !InTransact() .And. Ascan(aHeader,{|x| x[8] == "M"}) == 0 )
			cArqQry := "SC6"
			aStruSC6:= SC6->(dbStruct())
			lQuery  := .T.
			cQuery := "SELECT SC6.*,R_E_C_N_O_ SC6RECNO "
			cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
			cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
			cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
			cQuery += "SC6.D_E_L_E_T_<>'*' "
			cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

			cQuery := ChangeQuery(cQuery)
			dbSelectArea("SC6")
			dbCloseArea()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
			For nCntFor := 1 To Len(aStruSC6)
				If ( aStruSC6[nCntFor,2]<>"C" )
					TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		cArqQry := "SC6"
		MsSeek(xFilial("SC6")+SC5->C5_NUM)
		#IFDEF TOP
		EndIf
		#ENDIF
	//������������������������������������������������������Ŀ
	//� Montagem do aCols                                    �
	//��������������������������������������������������������

	lPedTLMK := .F.

	While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
			(cArqQry)->C6_NUM == SC5->C5_NUM .And. lContinua )

		//������������������������������������������������������������������������Ŀ
		//� Verifica se algum item foi criado no TLMK                              �
		//��������������������������������������������������������������������������
		If Left( ( cArqQry )->C6_PEDCLI, 3 ) == "TMK"
			lPedTLMK := .T.
		EndIf 				

		If ( (cArqQry)->C6_QTDEMP > 0 )
			lLiber := .T.
		EndIf
		If ( (cArqQry)->C6_QTDENT > 0 ) .Or. ( SC5->C5_TIPO $ "CIP" .And. !Empty((cArqQry)->C6_NOTA) )
			lFaturado  :=  .T.
		EndIf
		If !Empty((cArqQry)->C6_CONTRAT) .And. !lContrat
			dbSelectArea("ADB")
			dbSetOrder(1)
			If MsSeek(xFilial("ADB")+(cArqQry)->C6_CONTRAT+SC6->C6_ITEMCON)
				If ADB->ADB_QTDEMP > 0 .And. ADB->ADB_PEDCOB == (cArqQry)->C6_NUM
					lContrat := .T.
				EndIf
			EndIf
			dbSelectArea(cArqQry)			
		EndIf
		//������������������������������������������������������Ŀ
		//� Verifica se este item gerou OP, caso tenha gerado    �
		//� inclui no array aOPs para perguntar se exclui ou nao �
		//��������������������������������������������������������
		If (cArqQry)->C6_OP $ "01/03"
			AADD(aOPs,{(cArqQry)->C6_ITEM,Alltrim((cArqQry)->C6_PRODUTO),(cArqQry)->C6_NUMOP,(cArqQry)->C6_ITEMOP})
		EndIf
		//������������������������������������������������������Ŀ
		//� Verifica se este item foi digitada atraves de uma    �
		//� grade, se for junta todos os itens da grade em uma   �
		//� referencia , abrindo os itens so quando teclar enter �
		//� na quantidade                                        �
		//��������������������������������������������������������
		If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
			a410Grade(.T.,,cArqQry)
		Else
			AADD(aCols,Array(Len(aHeader)+1))
			For nCntFor := 1 To Len(aHeader)
				cCampo := Alltrim(aHeader[nCntFor,2])
				If ( aHeader[nCntFor,10] # "V" )
					aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(cCampo))
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(cCampo)
				EndIf
			Next nCntFor
			//��������������������������������������������������������������Ŀ
			//� Mesmo nao sendo um item digitado atraves de grade e' necessa-�
			//� rio criar o Array referente a este item para controle da     �
			//� grade                                                        �
			//����������������������������������������������������������������
			MatGrdMont(Len(aCols))
		EndIf
		nTotalPed += (cArqQry)->C6_VALOR
		If ( (cArqQry)->C6_PRUNIT = 0 )
			nTotalDes += (cArqQry)->C6_VALDESC
		Else
			nTotalDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
		EndIf
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		//������������������������������������������������������������������������Ŀ
		//�Guarda os registros do SC6 para posterior gravacao                      �
		//��������������������������������������������������������������������������
		aadd(aRegSC6,If(lQuery,(cArqQry)->SC6RECNO,(cArqQry)->(RecNo())))
		dbSelectArea(cArqQry)
		dbSkip()
	EndDo

	nTotalPed  -= M->C5_DESCONT
	nTotalDes  += M->C5_DESCONT
	nTotalDes  += A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")
	nTotalPed  -= A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")
	If ( lQuery )
		dbSelectArea(cArqQry)
		dbCloseArea()
		ChkFile("SC6",.F.)
		dbSelectArea("SC6")
	EndIf
EndIf
If ( lContinua )
	//������������������������������������������������������Ŀ
	//� Caso nao ache nenhum item , abandona rotina.         �
	//��������������������������������������������������������
	If ( Len(aCols)  == 0 )
		Help(" ",1,"A410SEMREG")
		lContinua := .F.
	EndIf
	//������������������������������������������������������������������Ŀ
	//� Caso algum item ja tenha sido FATURADO , impede a exclusao do PV �
	//��������������������������������������������������������������������
	If ( lFaturado )
		Help(" ",1,"A410REGFAT")
		lContinua := .F.
	EndIf
	//������������������������������������������������������������������Ŀ
	//� Caso algum item ja tenha sido LIBERADO , impede a exclusao do PV �
	//��������������������������������������������������������������������
	If ( lLiber )
		Help(" ",1,"A410LIBER")
		lContinua  := .F.
	EndIf
	If ( ExistBlock("A410EXC") )
		lRdRet := ExecBlock("A410EXC",.F.,.F.)
		If ValType(lRdRet)=="L" .And. !lRdRet
			lContinua  := .F.
		EndIf
	EndIf
	If ( lContrat )
		Help(" ",1,"A410CTRPAR")
		lContinua := .F.
	EndIf	

	//������������������������������������������������������������������������Ŀ
	//� Se algum item originou-se no telemarketing, impede a exclusao          �
	//��������������������������������������������������������������������������
	If lPedTLMK
		Help( " ", 1, "A410TLMK" ) // Nao e possivel excluir um pedido com itens originados no TLMK
		lContinua := .F. 		
	EndIf 	

EndIf
//�����������������������������������������������Ŀ
//�Monta o array com as formas de pagamento do SX5�
//�������������������������������������������������
Ma410MtFor(@aHeadFor,@aColsFor,@aRegSCV)
If ( lContinua )
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .f. } )	
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//������������������������������������������������������Ŀ
		//� Armazenar dados do Pedido anterior.                  �
		//��������������������������������������������������������
		IF M->C5_TIPO $ "DB"
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		EnChoice( "SC5", nReg, nOpc, , , , , aPosObj[1],,3,,,"A415VldTOk")
		@ nGetLin,aPosGet[1,1] SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 OF oDlg PIXEL	//"Fornec.:"###"Cliente: "
		@ nGetLin,aPosGet[1,2] SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3] SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg PIXEL		
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL 	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL	 RIGHT
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		Set Key VK_F4 to A440Stok(NIL,"A410")
		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"A410LinOk","A410DelOk","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,,nColFreeze,,ITENSSC6*IIF(MaGrade(),1,3.33),"A410Blq()",,,,,lFreeze)		
		Ma410Rodap(oGetD,nTotalPed,nTotalDes)
		ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||If(A410DelOk().And.A410VldTOk(),(nOpcA:=2,oDlg:End()),nOpcA := 0)},{||Iif( Ma410VldUs( nOpca ), oDlg:End(),  ) },nOpc)
	Else
		nOpcA := 2
	EndIf
	If ( nOpcA == 2  )
		If Type("lOnUpDate") == "U" .Or. lOnUpdate
			//�����������������������������������������������������������Ŀ
			//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
			//�������������������������������������������������������������
			PcoIniLan("000100") 

			A410Grava(lLiber,lTransf,3,aHeadFor,aColsFor,aRegSC6,aRegSCV)
	
			If ( (ExistBlock("M410STTS") ) )
				ExecBlock("M410STTS",.f.,.f.)			
			Endif

			//�����������������������������������������������������������Ŀ
			//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
			//�������������������������������������������������������������
			PcoFinLan("000100")
			
		Else
			aAutoCab := MsAuto2Ench("SC5")
			aAutoItens := MsAuto2Gd(aHeader,aCols)
		EndIf
	EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//�Destrava Todos os Registros                                             �
//��������������������������������������������������������������������������
MsUnLockAll()
RestArea(aArea)
Return nOpcA       

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410PCopia� Autor � Henry Fila            � Data �17/09/2004���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Prepara a funcao de copia para evitar que seja chamada a   ���
���          � janela de filiais                                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function a410PCopia(cAlias,nReg,nOpc)

Local aRotBkp := aClone(aRotina)                  

aRotina := { { OemToAnsi(STR0001),"AxPesqui"  ,0,1},;		//"Pesquisar"
	{ OemToAnsi(STR0002),"U_A410Visual",0,2},;		//"Visual"
	{ OemToAnsi(STR0003),"A410Copia",0,3}}		//"Incluir"

U_a410Copia(calias,nReg,3)

aRotina := aClone(aRotBkp)

Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �a410Copia �Autor  �Evaldo V. Batista  � Data �07.09.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Copia do Pedido de Venda                                    ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpC1: Alias do cabecalho do pedido de venda                ���
���          �ExpN2: Recno do cabecalho do pedido de venda                ���
���          �ExpN3: Opcao do arotina                                     ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo efetuar a interface com o usua���
���          �rio e o pedido de vendas                                    ���
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
User Function A410Copia(cAlias,nReg,nOpc)

Local aArea     := GetArea()
Local aPosObj   := {}
Local aObjects  := {}
Local aSize     := {}
Local aPosGet   := {}
Local aRegSC6   := {}
Local aRegSCV   := {}
Local aInfo     := {}
Local aCpoNCopia:= {}
Local aHeadSC6  := {}
Local lLiber 	:= .F.
Local lTransf	:= .F.
Local lGrade	:= MaGrade()
Local lQuery    := .F.
Local lContinua := .T.
Local lFreeze   := (SuperGetMv("MV_PEDFREZ",.F.,0) <> 0)
Local nOpcA		:= 0
Local nUsado    := 0
Local nCntFor   := 0
Local nTotalPed := 0
Local nTotalDes := 0
Local nNumDec   := TamSX3("C6_VALOR")[2]
Local nGetLin   := 0
Local nStack    := GetSX8Len() 
Local nColFreeze:= SuperGetMv("MV_PEDFREZ",.F.,0)
Local cArqQry   := "SC6"
Local cCadastro := OemToAnsi(STR0007) //"Atualiza��o de Pedidos de Venda"
Local cCampo    :=""
Local cTipoDat  := SuperGetMv("MV_TIPCPDT",.F.,"1")
Local oDlg
Local oGetd        
Local dOrig     := Ctod("//")
Local dCopia    := Ctod("//")
Local oSAY1
Local oSAY2
Local oSAY3
Local oSAY4
                            
#IFDEF TOP 
	Local aStruSC6 := {}       
	Local cQuery   := ""
#ENDIF 
                                                   
DEFAULT __lHasWSSTART := FindFunction("WS_HEADSC6")

//������������������������������������������������������Ŀ
//� Variaveis utilizadas na LinhaOk                      �
//��������������������������������������������������������
PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aColsGrade := {}
PRIVATE aHeadgrade := {}
PRIVATE aHeadFor   := {}
PRIVATE aColsFor   := {}
PRIVATE N          := 1
//������������������������������������������������������Ŀ
//� Monta a entrada de dados do arquivo                  �
//��������������������������������������������������������
PRIVATE aTELA[0][0],aGETS[0]
//������������������������������������������������������������������������Ŀ
//�Carrega perguntas do MATA440 e MATA410                                  �
//��������������������������������������������������������������������������

INCLUI := .T.
ALTERA := .F.

Pergunte("MTA440",.F.)
lLiber := MV_PAR02 == 1
lTransf:= MV_PAR01 == 1
Pergunte("MTA410",.F.)
//������������������������������������������������������Ŀ
//� Variavel utilizada p/definir Op. Triangulares.       �
//��������������������������������������������������������
IsTriangular( MV_PAR03==1 )
//������������������������������������������������������Ŀ
//� Salva a integridade dos campos de Bancos de Dados    �
//��������������������������������������������������������
dbSelectArea(cAlias)
IF ( (ExistBlock("M410ALOK")) )
	If (! ExecBlock("M410ALOK",.F.,.F.) )
		lContinua := .F.
	EndIf
EndIf
IF ( SC5->C5_FILIAL <> xFilial("SC5") )
	Help(" ",1,"A000FI")
	lContinua := .F.
EndIf
//������������������������������������������������������Ŀ
//| Se o Pedido foi originado no SIGATMS - Nao Copia     |
//��������������������������������������������������������
If SC5->(FieldPos("C5_SOLFRE")) > 0 .And. !Empty(SC5->C5_SOLFRE)
	Help(" ",1,"A410TMSNAO")
	lContinua := .F.
EndIf

//���������������������������������������������������������������������������Ŀ
//� Inicializa desta forma para criar uma nova instancia de variaveis private �
//�����������������������������������������������������������������������������
RegToMemory( "SC5", .F., .F. )

dOrig  := M->C5_EMISSAO
dCopia := CriaVar("C5_EMISSAO",.T.)

//���������������������������������������������������������������������������Ŀ
//� Limpa as variaveis que possuem amarracoes do pedido anterior              �
//�����������������������������������������������������������������������������
M->C5_NOTA  := Space(Len(SC5->C5_NOTA))
M->C5_SERIE := Space(Len(SC5->C5_SERIE))
M->C5_OS    := Space(Len(SC5->C5_OS))

//������������������������������������������������������Ŀ
//� Montagem do aHeader                                  �
//��������������������������������������������������������

lHeadSC6 := .f.
If __lHasWSSTART
	lHeadSC6 := WS_HEADSC6(.t.,cEmpAnt,@aHeadSC6)
EndIf

If !lHEADSC6
	dbSelectArea("SX3")
	dbSetOrder(1)    
	MsSeek("SC6")
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If ( X3USO(SX3->X3_USADO) .And.;
				!(	Trim(SX3->X3_CAMPO) == "C6_NUM" ) 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDEMP" 	.And.;
				Trim(SX3->X3_CAMPO) <> "C6_QTDENT" 	.And.;
				cNivel >= SX3->X3_NIVEL )
			nUsado++
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo           
	
	If __lHasWSSTART
		WS_HEADSC6(.f.,cEmpAnt,aHeader)
	EndIf 	
Else
	aHeader := aClone( aHeadSC6 ) 	
	nUsado  := Len(aHeader)		
EndIf 	

If ( lContinua )
	dbSelectArea("SC6")
	dbSetOrder(1)
	#IFDEF TOP
		If TcSrvType()<>"AS/400" .And. !InTransact() .And. Ascan(aHeader,{|x| x[8] == "M"}) == 0
			cArqQry := "SC6"
			aStruSC6:= SC6->(dbStruct())
			lQuery  := .T.
			cQuery := "SELECT SC6.*,SC6.R_E_C_N_O_ SC6RECNO "
			cQuery += "FROM "+RetSqlName("SC6")+" SC6 "
			cQuery += "WHERE SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
			cQuery += "SC6.C6_NUM='"+SC5->C5_NUM+"' AND "
			cQuery += "SC6.D_E_L_E_T_<>'*' "
			cQuery += "ORDER BY "+SqlOrder(SC6->(IndexKey()))

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("SC6")
			dbCloseArea()
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)
			For nCntFor := 1 To Len(aStruSC6)
				If ( aStruSC6[nCntFor,2]<>"C" )
					TcSetField(cArqQry,aStruSC6[nCntFor,1],aStruSC6[nCntFor,2],aStruSC6[nCntFor,3],aStruSC6[nCntFor,4])
				EndIf
			Next nCntFor
		Else
	#ENDIF
		cArqQry := "SC6"
		MsSeek(xFilial("SC6")+SC5->C5_NUM)
		#IFDEF TOP
		EndIf
		#ENDIF

	//������������������������������������������������������Ŀ
	//� Estes campos nao podem ser copiados                  �
	//��������������������������������������������������������
	aCpoNCopia := { "C6_QTDLIB","C6_RESERVA","C6_CONTRAT"   ,"C6_ITEMCON",;
		"C6_PROJPMS","C6_EDTPMS","C6_TASKPMS","C6_LICITA" ,"C6_PROJET",;
		"C6_ITPROJ" ,"C6_CONTRT","C6_TPCONTR","C6_ITCONTR","C6_NUMOS",;
		"C6_NUMOSFAT","C6_OP","C6_NUMOP","C6_ITEMOP","C6_NUMORC","C6_BLQ","C6_NOTA","C6_SERIE" }
	//������������������������������������������������������Ŀ
	//� Montagem do aCols                                    �
	//��������������������������������������������������������
	While ( !Eof() .And. (cArqQry)->C6_FILIAL == xFilial("SC6") .And.;
			(cArqQry)->C6_NUM == SC5->C5_NUM .And. lContinua )
		//������������������������������������������������������Ŀ
		//� Verifica se este item foi digitada atraves de uma    �
		//� grade, se for junta todos os itens da grade em uma   �
		//� referencia , abrindo os itens so quando teclar enter �
		//� na quantidade                                        �
		//��������������������������������������������������������

		If ( (cArqQry)->C6_GRADE == "S" .And. lGrade )
			a410Grade(.T.,,cArqQry)
		Else
			AADD(aCols,Array(Len(aHeader)+1))
			For nCntFor := 1 To Len(aHeader)
				cCampo := Alltrim(aHeader[nCntFor,2])
				If ( aHeader[nCntFor,10] # "V" .And. Empty( Ascan( aCpoNCopia, { |x| x == cCampo } ) ) )
					If cCampo == "C6_ENTREG"
						Do Case
							Case cTipoDat == "1"
								aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(cCampo))							
							Case cTipoDat == "2"
								aCols[Len(aCols)][nCntFor] := If(FieldGet(FieldPos(cCampo)) < dCopia,dCopia,FieldGet(FieldPos(cCampo)) )
							Case cTipoDat == "3"
								aCols[Len(aCols)][nCntFor] := dCopia + (FieldGet(FieldPos(cCampo)) - dOrig )
						EndCase							
					Else
						aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(cCampo))
					Endif	
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(cCampo)
				EndIf
			Next nCntFor
			//��������������������������������������������������������������Ŀ
			//� Mesmo nao sendo um item digitado atraves de grade e' necessa-�
			//� rio criar o Array referente a este item para controle da     �
			//� grade                                                        �
			//����������������������������������������������������������������
			MatGrdMont(Len(aCols))
		EndIf
		nTotalPed += (cArqQry)->C6_VALOR
		If ( (cArqQry)->C6_PRUNIT = 0 )
			nTotalDes += (cArqQry)->C6_VALDESC
		Else
			nTotalDes += A410Arred(((cArqQry)->C6_PRUNIT*(cArqQry)->C6_QTDVEN),"C6_VALOR")-A410Arred(((cArqQry)->C6_PRCVEN*(cArqQry)->C6_QTDVEN),"C6_VALOR")
		EndIf
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		dbSelectArea(cArqQry)
		dbSkip()
	EndDo
	nTotalPed  -= M->C5_DESCONT
	nTotalDes  += M->C5_DESCONT
	nTotalDes  += A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")
	nTotalPed  -= A410Arred(nTotalPed*M->C5_PDESCAB/100,"C6_VALOR")	
	If ( lQuery )
		dbSelectArea(cArqQry)
		dbCloseArea()
		ChkFile("SC6",.F.)
		dbSelectArea("SC6")
	EndIf
EndIf
//�����������������������������������������������Ŀ
//�Monta o array com as formas de pagamento do SX5�
//�������������������������������������������������
Ma410MtFor(@aHeadFor,@aColsFor)
//������������������������������������������������������Ŀ
//� Caso nao ache nenhum item , abandona rotina.         �
//��������������������������������������������������������
If ( lContinua )
	If ( Len(aCols) == 0 )
		lContinua := .F.
	EndIf
EndIf
//���������������������������������������������������������������������������Ŀ
//� Ajusta as variaveis para copia                                            �
//�����������������������������������������������������������������������������
M->C5_NUM := CriaVar("C5_NUM",.T.)
M->C5_EMISSAO := CriaVar("C5_EMISSAO",.T.)
aRegSC6 := {}
aRegSCV := {}
If ExistBlock("MT410CPY")
	ExecBlock("MT410CPY",.F.,.F.)
EndIf
If ( lContinua )
	If ( Type("l410Auto") == "U" .OR. !l410Auto )
		//������������������������������������������������������Ŀ
		//� Faz o calculo automatico de dimensoes de objetos     �
		//��������������������������������������������������������
		aSize := MsAdvSize()
		aObjects := {}
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 100, .t., .t. } )
		AAdd( aObjects, { 100, 015, .t., .f. } )
		aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
		aPosObj := MsObjSize( aInfo, aObjects )
		aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{003,033,160,200,240,263}} )
		nGetLin := aPosObj[3,1]

		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
		//������������������������������������������������������Ŀ
		//� Armazenar dados do Pedido anterior.                  �
		//��������������������������������������������������������
		IF M->C5_TIPO $ "DB"
			aTrocaF3 := {{"C5_CLIENTE","SA2"}}
		Else
			aTrocaF3 := {}
		EndIf
		EnChoice( "SC5", nReg, nOpc, , , , , aPosObj[1],,3,,,"A415VldTOk")
		@ nGetLin,aPosGet[1,1]  SAY OemToAnsi(IIF(M->C5_TIPO$"DB",STR0008,STR0009)) SIZE 020,09 PIXEL	//"Fornec.:"###"Cliente: "
		@ nGetLin,aPosGet[1,2]  SAY oSAY1 VAR Space(40)						SIZE 120,09 PICTURE "@!"	OF oDlg PIXEL
		@ nGetLin,aPosGet[1,3]  SAY OemToAnsi(STR0011)						SIZE 020,09 OF oDlg PIXEL	//"Total :"
		@ nGetLin,aPosGet[1,4]  SAY oSAY2 VAR 0 PICTURE TM(0,16,nNumDec)	SIZE 050,09 OF oDlg PIXEL		
		@ nGetLin,aPosGet[1,5]  SAY OemToAnsi(STR0012)						SIZE 020,09 OF oDlg PIXEL 	//"Desc. :"
		@ nGetLin,aPosGet[1,6]  SAY oSAY3 VAR 0 PICTURE TM(0,16,nNumDec)		SIZE 050,09 OF oDlg PIXEL RIGHT
		@ nGetLin+10,aPosGet[1,5]  SAY OemToAnsi("=")							SIZE 020,09 OF oDlg PIXEL
		If cPaisLoc == "BRA"				
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,2) OF oDlg PIXEL RIGHT
		Else
			@ nGetLin+10,aPosGet[1,6]  SAY oSAY4 VAR 0								SIZE 050,09 PICTURE TM(0,16,nNumDec) OF oDlg PIXEL RIGHT
		EndIf
		oDlg:Cargo	:= {|c1,n2,n3,n4| oSay1:SetText(c1),;
			oSay2:SetText(n2),;
			oSay3:SetText(n3),;
			oSay4:SetText(n4) }
		Set Key VK_F4 to A440Stok(NIL,"A410")
		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"A410LinOk","A410TudOk","+C6_ITEM/C6_Local/C6_TES/C6_CF/C6_PEDCLI",.T.,,nColFreeze,,ITENSSC6*IIF(MaGrade(),1,3.33),"A410Blq()",,,,,lFreeze)		
		Private oGetDad:=oGetd
		A410Bonus(2)
		Ma410Rodap(oGetD,nTotalPed,nTotalDes)
		ACTIVATE MSDIALOG oDlg ON INIT Ma410Bar(oDlg,{||nOpcA:=1,if(A410VldTOk().And.oGetd:TudoOk(),If(!obrigatorio(aGets,aTela),nOpcA := 0,oDlg:End()),nOpcA := 0)},{||oDlg:End()},nOpc)
		SetKey(VK_F4,)
	Else
		//��������������������������������������������������������������Ŀ
		//� validando dados pela rotina automatica                       �
		//����������������������������������������������������������������
		If EnchAuto(cAlias,aAutoCab,{|| Obrigatorio(aGets,aTela)},aRotina[nOpc][4]) .and. MsGetDAuto(aAutoItens,"A410LinOk",{|| A410VldTOk() .and. A410TudOk() },aAutoCab)
			nOpcA := 1
		EndIf
	EndIf
	If ( nOpcA == 1 )
		A410Bonus(1)
		If Type("lOnUpDate") == "U" .Or. lOnUpdate
			//�����������������������������������������������������������Ŀ
			//� Inicializa a gravacao dos lancamentos do SIGAPCO          �
			//�������������������������������������������������������������
			PcoIniLan("000100") 
	
			If !A410Grava(lLiber,lTransf,1,aHeadFor,aColsFor,aRegSC6,aRegSCV,nStack)
				Help(" ",1,"A410NAOREG")
			EndIf
			If ( (ExistBlock("M410STTS") ) )
				ExecBlock("M410STTS",.f.,.f.)
			EndIf
			
			//�����������������������������������������������������������Ŀ
			//� Finaliza a gravacao dos lancamentos do SIGAPCO            �
			//�������������������������������������������������������������
			PcoFinLan("000100")
			
		Else
			aAutoCab := MsAuto2Ench("SC5")
			aAutoItens := MsAuto2Gd(aHeader,aCols)		
		EndIf
	Else
		While GetSX8Len() > nStack 
			RollBackSX8()
		EndDo
		If ( (ExistBlock("M410ABN")) )
			ExecBlock("M410ABN",.f.,.f.)
		EndIf
	EndIf
EndIf
//������������������������������������������������������������������������Ŀ
//�Destrava Todos os Registros                                             �
//��������������������������������������������������������������������������
MsUnLockAll()
RestArea(aArea)
Return( nOpcA )

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Ma410Bar  � Autor � Eduardo Riera         � Data � 18.02.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � EnchoiceBar especifica do Mata410                          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���Parametros� oDlg: 	Objeto Dialog                                     ���
���          � bOk:  	Code Block para o Evento Ok                       ���
���          � bCancel: Code Block para o Evento Cancel                   ���
���          � nOpc:		nOpc transmitido pela mbrowse                     ���
���          � aForma: Array com as formas de pagamento                   ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function Ma410Bar(oDlg,bOk,bCancel,nOpc)

Local aButtons  := {}
Local aButtonUsr := {}
Local nI        := 0
        
//aadd(aButtons,{"BUDGET",{|| Ma410ForPg(nOpc)},STR0041, STR0068 }) //"Formas de Pagamento"
//aadd(aButtons,{"Planilha",{||Ma410Impos()},STR0043, STR0069 })	//"Planilha Financeira"
aadd(aButtons,{"RELATORIO",{||E410Imposc()},"Planilha Financeira", "Planilha" })	//"Planilha Financeira"
//������������������������������������������������������������������������Ŀ
//�Ponto de entrada para verificar se o usuario pode acessar a formacao    �
//��������������������������������������������������������������������������
/*
If VerSenha(107) //Permite consulta a Formacao de Precos
	If ExistBlock("A410BPRC")                      
		If ExecBlock("A410BPRC",.F.,.F.)
			aadd(aButtons,{"AUTOM",{||Ma410Forma()},STR0056,STR0070 })	//"Formacao de Precos"
		Endif	
	Else	                                                                          
		aadd(aButtons,{"AUTOM",{||Ma410Forma()},STR0056,STR0070 })	//"Formacao de Precos"
	Endif
EndIf


Aadd(aButtons,{"PRODUTO", {|| Ma410BOM(aHeader,aCols,N) } ,STR0085,STR0086}) //"Estrutura de Produto"###"Estr.Prod."
*/
//������������������������������������������������������������������������Ŀ
//�Pontos de Entrada 													   �
//��������������������������������������������������������������������������
If ExistTemplate("A410CONS",,.T.)
	aButtonUsr := ExecTemplate("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
If ExistBlock("A410CONS",,.T.)
	aButtonUsr := ExecBlock("A410CONS",.F.,.F.)
	If ValType(aButtonUsr) == "A"
		For nI   := 1  To  Len(aButtonUsr)
			Aadd(aButtons,aClone(aButtonUsr[nI]))
		Next nI
	EndIf
EndIf
/*
If ExistTemplate("GEMDLGSOL",,.T.)      
	Aadd(aButtons,{"GROUP", {|| ExecTemplate("GEMDLGSOL",.F.,.F.,{nOpc,M->C5_NUM}) } ,"Cadastro de Solidarios","Solidarios"})
EndIf
*/
If ( nOpc == 3 .Or. nOpc == 4 )
	aadd(aButtons,{"POSCLI",{|| If(M->C5_TIPO=="N".And.!Empty(M->C5_CLIENTE),a450F4Con(),.F.),Pergunte("MTA410",.F.)},STR0022,STR0067 }) 	//"Posi��o de Cliente"
EndIf
If ( aRotina[ nOpc, 4 ] == 2 .Or. aRotina[ nOpc, 4 ] == 6 ) .And. !AtIsRotina("A410TRACK")
	AAdd(aButtons,{ "ORDEM", {|| A410Track() }, STR0050, STR0071 } )  // "System Tracker"
EndIf 	

Aadd( aButtons, {"RELATORIO",{|| U_PEDVEN()},"Imprime","Imprime" })

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))

/*/
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �MA410BOM  � Autor � Eduardo Riera         � Data �06.12.2001 ���
��������������������������������������������������������������������������Ĵ��
���          �Ma410Impos()                                                 ���
���          �Funcao de calculo dos impostos contidos no pedido de venda   ���
��������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���          �                                                             ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �Esta funcao efetua os calculos de impostos (ICMS,IPI,ISS,etc)���
���          �com base nas funcoes fiscais, a fim de possibilitar ao usua- ���
���          �rio o valor de desembolso financeiro.                        ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                    ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function Ma410Bom(aHeader,aCols,nX)

Local aArea     := GetArea()
Local aBOM      := {}
Local aHeadBom  := {"",RetTitle("C6_PRODUTO"),RetTitle("C6_QTDVEN"),RetTitle("C6_DESCRI")}
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
Local nPItem    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
Local nY        := 0
Local nZ        := 0
Local cItem     := ""
PRIVATE N := nX
//������������������������������������������������������Ŀ
//� Posiciona registros                                  �
//��������������������������������������������������������
dbSelectArea("SB1")
dbSetOrder(1)
MsSeek(xFilial("SB1")+aCols[nX][nPProduto])
//������������������������������������������������������Ŀ
//� Verifica os produtos do primeiro n�vel da estrutura  �
//��������������������������������������������������������
dbSelectArea("SG1")
dbSetOrder(1)
MsSeek(xFilial("SG1")+aCols[nX][nPProduto])
While !Eof() .And. xFilial("SG1") == SG1->G1_FILIAL .And.;
	aCols[nX][nPProduto] == SG1->G1_COD

	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek(xFilial("SB1")+aCols[nX][nPProduto])
	If SB1->B1_FANTASM<>"S"
		aadd(aBOM,{SG1->G1_COMP,ExplEstr(aCols[nX][nPQtdVen],dDataBase,"",SB1->B1_REVATU),SB1->B1_DESC})
	EndIf
	dbSelectArea("SG1")
	dbSkip()
EndDo
//������������������������������������������������������Ŀ
//� Adiciona os produtos no aCols                        �
//��������������������������������������������������������
For nX := 1 To Len(aBOM)
	If aScan(aCols,{|x| x[nPProduto]==aBom[nX][1]})==0
		cItem := aCols[Len(aCols)][nPItem]
		aadd(aCOLS,Array(Len(aHeader)+1))
		For nY	:= 1 To Len(aHeader)
			If ( AllTrim(aHeader[nY][2]) == "C6_ITEM" )
				aCols[Len(aCols)][nY] := Soma1(cItem)
			Else
				aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])		
			EndIf
		Next nY
		N := Len(aCols)
		aCOLS[N][Len(aHeader)+1] := .F.
		A410Produto(aBom[nX][1],.F.)
		aCols[N][nPProduto]      := aBom[nX][1]
		A410MultT("M->C6_PRODUTO",aBom[nX][1])
		aCols[N][nPQtdVen]       := aBom[nX][2]
		A410MultT("M->C6_QTDVEN",aBom[nX][2])
		If Empty(aCols[N][nPTotal]) .Or. Empty(aCols[N][nPTES])
			aCOLS[N][Len(aHeader)+1] := .T.
		EndIf
	EndIf
Next nX
RestArea(aArea)
Return(.T.)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �A410Bonus � Autor �Evaldo V. Batista  � Data �16.06.2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Rotina de tratamento da regra de bonificacao para interface ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpN1: Tipo de operacao                                     ���
���          �       [1] Inclusao do bonus                                ���
���          �       [2] Exclusao do bonus                                ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Esta rotina tem como objetivo avaliar a regra de bonificacao���
���          �e adicionar na respectiva interface                         ���
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
Static Function A410Bonus(nTipo)

Local aArea     := GetArea()
Local aBonus    := {}
Local nX        := 0
Local nY        := 0
Local nW        := 0 
Local nZ        := Len(aCols)
Local nUsado    := Len(aHeader)
Local nPProd    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO" })
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN" })
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN" })
Local nPValor   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR" })
Local nPTES		:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES" })
Local nPItem	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEM" })
Local nPQtdLib  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDLIB" })
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
			aBonus   := FtRgrBonus(aCols,{nPProd,nPQtdVen,nPTES},M->C5_CLIENTE,M->C5_LOJACLI,M->C5_TABELA,M->C5_CONDPAG)
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
					aCols[nZ,nW] := CriaVar(aHeader[nW,2],.T.)
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
				
 				If ExistTrigger("C6_TES")
   					RunTrigger(2,Len(aCols))
				Endif	

				If mv_par01 == 1 
					aCols[nZ,nPQtdLib ] := aCols[nZ,nPQtdVen ]
				Endif	
				
			Next nX
		EndIf
	EndIf
Else
	FtDelBonus(aCols,{nPProd,nPQtdVen,nPTES,nUsado+1})	
EndIf
RestArea(aArea)
Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �Ma410Track� Autor � Evaldo V. Batista     � Data �18/12/2001���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Faz o tratamento da chamada do System Tracker              ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � .T.                                                        ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Nenhum                                                     ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function A410Track()

Local aEnt     := {}
Local cPedido  := M->C5_NUM
Local nPosItem := GDFieldPos( "C6_ITEM" )
Local nLoop    := 0

//���������������������������������������������Ŀ
//�Inicializa a funcao fiscal                   �
//�����������������������������������������������
For nLoop := 1 To Len( aCols )
	AAdd( aEnt, { "SC6", cPedido + aCols[ nLoop, nPosItem ] } )
Next nLoop

MaTrkShow( aEnt )

Return( .T. )


User Function A410NOTA()

Aviso(	"Prepara��o de Documentos",;
			"Fun��o n�o dispon�vel para Representante.",;
			{"&Continua"},,;
			"Sem Acesso" )
			
Return(Nil)               



******************************************************************************************************
Static Function E410Imposc()
******************************************************************************************************

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aFisGet	:= {}
Local aFisGetSC5:= {}
Local aTitles   := {"Nota Fiscal","Duplicatas","Rentabilidade"}
Local aDupl     := {}
Local aVencto   := {}
Local aFlHead   := { "Vencimento","Valor","Dt. Entrega Ref." }
Local aEntr     := {}                
Local aDuplTmp  := {}
Local aRFHead   := { RetTitle("C6_PRODUTO"),RetTitle("C6_VALOR"),"C.M.V","Vlr.Presente","Lucro Bruto","Margem de Contribui��o(%)"}
Local aRentab   := {}
Local nPLocal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0 
Local nPosCpo   := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := M->C5_EMISSAO
Local oDlg
Local oDupl
Local oFolder
Local oRentab

//���������������������������������������������Ŀ
//�Busca referencias no SC6                     �
//�����������������������������������������������
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//���������������������������������������������Ŀ
//�Busca referencias no SC5                     �
//�����������������������������������������������
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//���������������������������������������������Ŀ
//�Inicializa a funcao fiscal                   �
//�����������������������������������������������
MaFisSave()
MaFisEnd()
MaFisIni(M->C5_CLIENTE,;// 1-Codigo Cliente/Fornecedor
	M->C5_LOJAENT,;		// 2-Loja do Cliente/Fornecedor
	IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
	M->C5_TIPO,;				// 4-Tipo da NF
	M->C5_TIPOCLI,;		// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//Na argentina o calculo de impostos depende da serie.
If cPaisLoc == 'ARG'                         
	SA1->(DbSetOrder(1))
	SA1->(MsSeek(xFilial()+M->C5_CLIENTE+M->C5_LOJAENT))
	MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
Endif
//���������������������������������������������Ŀ
//�Agrega os itens para a funcao fiscal         �
//�����������������������������������������������
If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aCols)
		nQtdPeso := 0
		If Len(aCols[nX])==nUsado+1			// Como � s� de visualiza��o n�o precisa testar deletados .Or. !aCols[nX][nUsado+1]
			nItem++
			//���������������������������������������������Ŀ
			//�Posiciona Registros                          �
			//�����������������������������������������������			
			SB1->(dbSetOrder(1))
			If SB1->(MsSeek(xFilial("SB1")+aCols[nX][nPProduto]))
				nQtdPeso := aCols[nX][nPQtdVen]*SB1->B1_PESO
			EndIf
					
			If nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aCols[nX][nPNfOri]) .And. !Empty(aCols[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPNfOri]+aCols[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][nPProduto]+aCols[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					Endif	
				Endif
			EndIf           
            SB2->(dbSetOrder(1))
            SB2->(MsSeek(xFilial("SB2")+SB1->B1_COD+aCols[nX][nPLocal]))
            SF4->(dbSetOrder(1))
            SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))	            
			//���������������������������������������������Ŀ
			//�Calcula o preco de lista                     �
			//�����������������������������������������������
			nValMerc  := aCols[nX][nPTotal]
			nPrcLista := aCols[nX][nPPrUnit]
			If ( nPrcLista == 0 )
				nPrcLista := NoRound(nValMerc/aCols[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])
			EndIf
			nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")		
			nDesconto := a410Arred(nPrcLista*aCols[nX][nPQtdVen],"D2_DESCON")-nValMerc
			nDesconto := IIf(nDesconto==0,aCols[nX][nPValDesc],nDesconto)
			nDesconto := Max(0,nDesconto)		
			nPrcLista += nAcresFin			
			
			//Para os outros paises, este tratamento e feito no programas que calculam os impostos.
			If cPaisLoc=="BRA"
				nValMerc  += nDesconto
			Endif

			//���������������������������������������������Ŀ
			//�Verifica a data de entrega para as duplicatas�
			//�����������������������������������������������
			If ( nPDtEntr > 0 )
				If ( dDataCnd > aCols[nX][nPDtEntr] .And. !Empty(aCols[nX][nPDtEntr]) )
					dDataCnd := aCols[nX][nPDtEntr]
				EndIf
			Else
				dDataCnd  := M->C5_EMISSAO
			EndIf
			//���������������������������������������������Ŀ
			//�Agrega os itens para a funcao fiscal         �
			//�����������������������������������������������
			MaFisAdd(aCols[nX][nPProduto],;   	// 1-Codigo do Produto ( Obrigatorio )
				aCols[nX][nPTES],;	   	// 2-Codigo do TES ( Opcional )
				aCols[nX][nPQtdVen],;  	// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  	// 4-Preco Unitario ( Obrigatorio )
				nDesconto,; 	// 5-Valor do Desconto ( Opcional )
				"",;	   			// 6-Numero da NF Original ( Devolucao/Benef )
				"",;				// 7-Serie da NF Original ( Devolucao/Benef )
				nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
				0,;					// 9-Valor do Frete do Item ( Opcional )
				0,;					// 10-Valor da Despesa do item ( Opcional )
				0,;					// 11-Valor do Seguro do item ( Opcional )
				0,;					// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;			// 13-Valor da Mercadoria ( Obrigatorio )
				0)					// 14-Valor da Embalagem ( Opiconal )	
			//���������������������������������������������Ŀ
			//�Calculo do ISS                               �
			//�����������������������������������������������
			SF4->(dbSetOrder(1))
			SF4->(MsSeek(xFilial("SF4")+aCols[nX][nPTES]))			
			If ( M->C5_INCISS == "N" .And. M->C5_TIPO == "N")
				If ( SF4->F4_ISS=="S" )
					nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
				EndIf
			EndIf	
			//���������������������������������������������Ŀ
			//�Altera peso para calcular frete              �
			//�����������������������������������������������
			MaFisAlt("IT_VALMERC",nValMerc,nItem)
			MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
			MaFisAlt("IT_PESO",nQtdPeso,nItem)
			//���������������������������������������������Ŀ
			//�Analise da Rentabilidade                     �
			//�����������������������������������������������
			If SF4->F4_DUPLIC=="S"
				nY := aScan(aRentab,{|x| x[1] == aCols[nX][nPProduto]})
				If nY == 0
					aadd(aRenTab,{aCols[nX][nPProduto],0,0,0,0,0})
					nY := Len(aRenTab)
				EndIf
				If cPaisLoc=="BRA"
					aRentab[nY][2] += (nValMerc - nDesconto)
				Else
					aRentab[nY][2] += nValMerc
				Endif
				aRentab[nY][3] += aCols[nX][nPQtdVen]*SB2->B2_CM1
			EndIf
		EndIf
	Next nX
EndIf
//���������������������������������������������Ŀ
//�Indica os valores do cabecalho               �
//�����������������������������������������������
MaFisAlt("NF_FRETE",M->C5_FRETE)
MaFisAlt("NF_SEGURO",M->C5_SEGURO)
MaFisAlt("NF_AUTONOMO",M->C5_FRETAUT)
MaFisAlt("NF_DESPESA",M->C5_DESPESA)
If M->C5_DESCONT > 0
	MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,M->C5_DESCONT+MaFisRet(,"NF_DESCONTO")))
EndIf
If M->C5_PDESCAB > 0
	MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*M->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
EndIf
//�������������������������������������������������Ŀ
//�Realiza alteracoes de referencias do SC6         �
//���������������������������������������������������
dbSelectArea("SC6")                     
If Len(aFisGet) > 0
	For nX := 1 to Len(aCols)                                    	
		If Len(aCols[nX])==nUsado+1			// Como � s� de visualiza��o n�o precisa ver deletados .Or. !aCols[nX][Len(aHeader)+1]			
			For nY := 1 to Len(aFisGet)
				nPosCpo := aScan(aHeader,{|x| AllTrim(x[2])==Alltrim(aFisGet[ny][2])})
				If nPosCpo > 0	
					If !Empty(aCols[nX][nPosCpo])
						MaFisAlt(aFisGet[ny][1],aCols[nX][nPosCpo],nX,.F.)
					Endif	
				EndIf
			Next nX	
		Endif	
	Next nY           
EndIf
//�������������������������������������������������Ŀ
//�Realiza alteracoes de referencias do SC5         �
//���������������������������������������������������
If Len(aFisGetSC5) > 0	
	dbSelectArea("SC5")
	For nY := 1 to Len(aFisGetSC5)
		If !Empty(&("M->"+Alltrim(aFisGetSC5[ny][2])))
		
			If aFisGetSC5[ny][1] == "NF_SUFRAMA"
				MaFisAlt(aFisGetSC5[ny][1],Iif(&("M->"+Alltrim(aFisGetSC5[ny][2])) == "1",.T.,.F.),nItem,.F.)
			Else	
				MaFisAlt(aFisGetSC5[ny][1],&("M->"+Alltrim(aFisGetSC5[ny][2])),nItem,.F.)
			Endif	
		EndIf
	Next nY
Endif
If ExistBlock("M410PLNF")
	ExecBlock("M410PLNF",.F.,.F.)
EndIf
MaFisWrite(1)
//�������������������������������������������������Ŀ
//�Calcula os venctos conforme a condicao de pagto  �
//���������������������������������������������������
If lDtEmi
	dbSelectarea("SE4")
	dbSetOrder(1)
	MsSeek(xFilial("SE4")+M->C5_CONDPAG)
	If !(SE4->E4_TIPO=="9")	
		aDupl := Condicao(MaFisRet(,"NF_BASEDUP"),M->C5_CONDPAG,MaFisRet(,"NF_VALIPI"),dDataCnd,MaFisRet(,"NF_VALSOL"))
		If Len(aDupl) > 0
			For nX := 1 To Len(aDupl)
				nAcerto += aDupl[nX][2]
			Next nX
			aDupl[Len(aDupl)][2] += MaFisRet(,"NF_BASEDUP") - nAcerto
			aVencto := aClone(aDupl)
			For nX := 1 To Len(aDupl)
				aDupl[nX][2] := TransForm(aDupl[nX][2],PesqPict("SE1","E1_VALOR"))
			Next nX			
		Endif	
	Else
		aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
		aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
	EndIf
Else
	For nX := 1 to Len(aCols)
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]	
			If nPDtEntr > 0				
				nPosEntr := Ascan(aEntr,{|x| x[1] == aCols[nX][nPDtEntr]})
 				If nPosEntr == 0
					Aadd(aEntr,{aCols[nX][nPDtEntr],MaFisRet(nX,"IT_BASEDUP"),MaFisRet(nX,"IT_VALIPI"),MaFisRet(nX,"IT_VALSOL")})
				Else    
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_BASEDUP")
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_VALIPI")
					aEntr[nPosEntr][2]+= MaFisRet(nX,"IT_VALSOL")
				EndIf				
			Endif	
		Endif	
    Next
	dbSelectarea("SE4")
	dbSetOrder(1)
	MsSeek(xFilial("SE4")+M->C5_CONDPAG)
	If !(SE4->E4_TIPO=="9")	
		For nY := 1 to Len(aEntr)
			nAcerto  := 0
			aDuplTmp := Condicao(aEntr[nY][2],M->C5_CONDPAG,aEntr[nY][3],aEntr[nY][1],aEntr[nY][4])			
			If Len(aDuplTmp) > 0			
				For nX := 1 To Len(aDuplTmp)
					nAcerto += aDuplTmp[nX][2]
				Next nX			
				aDuplTmp[Len(aDuplTmp)][2] += aEntr[nY][2] - nAcerto
				aVencto := aClone(aDuplTmp)
				For nX := 1 To Len(aDuplTmp)
					aDuplTmp[nX][2] := TransForm(aDuplTmp[nX][2],PesqPict("SE1","E1_VALOR"))
				Next nX			
				aEval(aDuplTmp,{|x| Aadd(aDupl,{aEntr[nY][1],x[1],x[2]})})
			EndIf			
		Next			
	Else
		aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
		aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
	EndIf
EndIf
If Len(aDupl) == 0
	aDupl := {{Ctod(""),TransForm(MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR"))}}
	aVencto := {{dDataBase,MaFisRet(,"NF_BASEDUP")}}
EndIf
//���������������������������������������������Ŀ
//�Analise da Rentabilidade - Valor Presente    �
//�����������������������������������������������
nItem := 0
For nX := 1 To Len(aCols)
	If Len(aCols[nX])==nUsado+1		//  .Or. !aCols[nX][nUsado+1]
		nItem++
		nY := aScan(aRentab,{|x| x[1] == aCols[nX][nPProduto]})
		If nY <> 0
			aRentab[nY][4] += Max(Ma410Custo(nItem,aVencto,aCols[nX][nPTES],aCols[nX][nPProduto],aCols[nX][nPLocal],aCols[nX][nPQtdVen]),0)
			aRentab[nY][5] := Max(aRentab[nY][4]-aRentab[nY][3],0)
			aRentab[nY][6] := aRentab[nY][5]/aRentab[nY][4]*100
		EndIf
	EndIf
Next nX
aadd(aRentab,{"",0,0,0,0,0})
For nX := 1 To Len(aRentab)
	If nX <> Len(aRentab)
		aRentab[Len(aRentab)][2] += aRentab[nX][2]
		aRentab[Len(aRentab)][3] += aRentab[nX][3]
		aRentab[Len(aRentab)][4] += aRentab[nX][4]
		aRentab[Len(aRentab)][5] += aRentab[nX][5]
		aRentab[Len(aRentab)][6] := aRentab[Len(aRentab)][5]/aRentab[Len(aRentab)][4]*100
	EndIf	
	aRentab[nX][2] := TransForm(aRentab[nX][2],"@e 999,999,999.999999")
	aRentab[nX][3] := TransForm(aRentab[nX][3],"@e 999,999,999.999999")
	aRentab[nX][4] := TransForm(aRentab[nX][4],"@e 999,999,999.999999")
	aRentab[nX][5] := TransForm(aRentab[nX][5],"@e 999,999,999.999999")
	aRentab[nX][6] := TransForm(aRentab[nX][6],"@e 999,999,999.999999")
Next nX
//���������������������������������������������Ŀ
//�Monta a tela de exibicao dos valores fiscais �
//�����������������������������������������������
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Planilha Financeira") FROM 09,00 TO 28,80
oFolder := TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,140)    
oFolder:adialogs[3]:disable()
//���������������������������������������������Ŀ
//�Folder 1                                     �
//�����������������������������������������������
MaFisRodape(1,oFolder:aDialogs[1],,{005,001,310,60},Nil,.T.)
@ 070,005 SAY RetTitle("F2_FRETE")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,105 SAY RetTitle("F2_SEGURO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,205 SAY RetTitle("F2_DESCONT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,005 SAY RetTitle("F2_FRETAUT")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,105 SAY RetTitle("F2_DESPESA")	SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 085,205 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 070,050 MSGET MaFisRet(,"NF_FRETE")		PICTURE PesqPict("SF2","F2_FRETE",16,2)		SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 070,150 MSGET MaFisRet(,"NF_SEGURO")  	PICTURE PesqPict("SF2","F2_SEGURO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 070,250 MSGET MaFisRet(,"NF_DESCONTO")	PICTURE PesqPict("SF2","F2_DESCONTO",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,050 MSGET MaFisRet(,"NF_AUTONOMO")	PICTURE PesqPict("SF2","F2_FRETAUT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,150 MSGET MaFisRet(,"NF_DESPESA")		PICTURE PesqPict("SF2","F2_DESPESA",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 085,250 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[1]
@ 110,005 SAY OemToAnsi("Total da Nota")   SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
@ 110,050 MSGET MaFisRet(,"NF_TOTAL")      PICTURE PesqPict("SF2","F2_VALBRUT",16,2) 	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[1]
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[1] PIXEL
//���������������������������������������������Ŀ
//�Folder 2                                     �
//�����������������������������������������������                                                                                                      
If lDtEmi
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Else	
	@ 005,001 LISTBOX oDupl FIELDS TITLE aFlHead[3],aFlHead[1],aFlHead[2] SIZE 310,095 	OF oFolder:aDialogs[2] PIXEL
Endif	
oDupl:SetArray(aDupl)
oDupl:bLine := {|| aDupl[oDupl:nAt] }
@ 105,005 TO 106,310 PIXEL OF oFolder:aDialogs[2]
If cPaisLoc == "BRA"
	@ 110,005 SAY RetTitle("F2_VALFAT")		SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Else
	@ 110,005 SAY OemToAnsi("Vlr. Duplicatas")	    SIZE 40,10 PIXEL OF oFolder:aDialogs[2]
Endif	
@ 110,050 MSGET MaFisRet(,"NF_BASEDUP")		PICTURE PesqPict("SF2","F2_VALFAT",16,2)	SIZE 50,07 PIXEL WHEN .F. OF oFolder:aDialogs[2]
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End() OF oFolder:aDialogs[2] PIXEL
//���������������������������������������������Ŀ
//�Folder 3                                     �
//�����������������������������������������������
@ 005,001 LISTBOX oRentab FIELDS TITLE aRFHead[1],aRFHead[2],aRFHead[3],aRFHead[4],aRFHead[5],aRFHead[6] SIZE 310,095 	OF oFolder:aDialogs[3] PIXEL
@ 110,270 BUTTON OemToAnsi("Sair")			SIZE 040,11 FONT oFolder:aDialogs[3]:oFont ACTION oDlg:End() OF oFolder:aDialogs[3] PIXEL		//"Sair"
If Empty(aRentab)
	aRentab   := {{"",0,0,0,0,0}}
EndIf
oRentab:SetArray(aRentab)
oRentab:bLine := {|| aRentab[oRentab:nAt] }
ACTIVATE MSDIALOG oDlg CENTERED
MaFisEnd()
MaFisRestore()

RestArea(aAreaSA1)
RestArea(aArea)
Return(.T.)

