#INCLUDE "PROTHEUS.CH"
#INCLUDE "FOLDER.CH"                                                                                             
#INCLUDE "COLORS.CH"                                                                                                    
#INCLUDE "QIPA215.CH"                                                             
#INCLUDE "FILEIO.CH"                                                                                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                   
//³ Posicao do aHeader utilizado nas medicoes					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE HEAD_NCS    1                                                                               
#DEFINE HEAD_INST   2
#DEFINE HEAD_ANEXO  3
#DEFINE HEAD_RASTRO 4

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os niveis por Laboratorio no vetor aResultados		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE _OPE 1  //Operacao
#DEFINE _LAB 2  //Laboratorio
#DEFINE _ENS 3  //Ensaio
#DEFINE _MED 4  //Medicoes
#DEFINE _NCO 5  //Nao-conformidades
#DEFINE _CRO 6  //Cronicas
#DEFINE _INS 7  //Instrumentos
#DEFINE _ANE 8  //Documentos anexos
#DEFINE _LLA 9  //Laudo do laboratorio
#DEFINE _LOP 10 //Laudo da Operacao  
#DEFINE _MOP 11 //Mensagem da Operacao
#DEFINE _RAS 12 //Rastreabilidade  
#DEFINE _PLA 13 //Plano de Amostragem  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicoes das colunas no browse que contem os ensaios associa-³
//³	dos a cada Laboratorio.										 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE SEQ     01 //Sequencia do Laboratorio
#DEFINE ENSAIO  02 //Ensaio corrente
#DEFINE DESPOR  03 //Descricao do Ensaio Portugues
#DEFINE CARTA   04 //Carta
#DEFINE LIE     05 //Limite Inferior de Engenharia
#DEFINE VLRNOM  06 //Valor Nominal
#DEFINE LSE     07 //Limite Superior de Engenharia
#DEFINE QTDMED  08 //Quantidade de Medicoes (carta) 
#DEFINE TEXTO   09 //Texto do ensaio tipo TXT 
#DEFINE SKPTST  10 //Situacao do Skip-Teste
#DEFINE METODO  11 //Metodo
#DEFINE REVDOC  12 //Revisao do Documento 
#DEFINE DESING  13 //Descricao do Ensaio Ingles
#DEFINE DESESP  14 //Descricao do Ensaio Espanhol                
#DEFINE ENSOBR  15 //Define se o Ensaio eh Obrigatorio  
#DEFINE PLAMO   16 //Plano de Amostragem
#DEFINE ROTEIRO 17 //Roteiro de Operações
#DEFINE FAMVINC 18 //Define se tem Familia Vinculada
#DEFINE ENSCALC 19 //Identifica se o Ensaio é Calculado
#DEFINE FORMUL  20 //Fórmula do ensaio caso seja Cálculado

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                   Posicoes do Vetor aOBJETOS                 ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³  [1,x]      ³ Laudo da Operacao								 ³
//³  [2,x]      ³ Folder dos Laboratorios por Operacao			 ³
//³  [3,x,y,z]  ³ Ensaios										 ³
//³  [4]        ³ Laudo Geral									 ³
//ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³	Onde: x	 = Operacao selecionado						         ³
//³	      y	 = Laboratorio selecionado						     ³
//³		  z	 = Ensaio selecionado								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE OBJ_LAUOPE 1
#DEFINE OBJ_FOLLAB 2
#DEFINE OBJ_ENSAIO 3
#DEFINE OBJ_MEDICA 4    
#DEFINE OBJ_FOLNCC 5
#DEFINE OBJ_NCC    6     
#DEFINE OBJ_INST   7
#DEFINE OBJ_LAUDO  8
#DEFINE OBJ_CRONIC 9
#DEFINE OBJ_LAUGER 10 
#DEFINE OBJ_PLAMO  11 
#DEFINE OBJ_SEQ    12 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os numero dos Folders principais.            		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ             
#DEFINE FLD_OPE 1
#DEFINE FLD_LAB 2
#DEFINE FLD_GER 3     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define parametros para salvar posicao do a Resultados.		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ             
#DEFINE SAV_LAUO  1
#DEFINE SAV_MED   2
#DEFINE SAV_NCO   3
#DEFINE SAV_INS   4
#DEFINE SAV_CRO   5
#DEFINE SAV_LAUL  6
#DEFINE SAV_LAUG  7  
#DEFINE SAV_RAS   8  

#DEFINE NORMAL		"1"
#DEFINE ATRIBUTO	"2"
#DEFINE PARETO		"6"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QIPA215   ³ Autor ³ Cleber L. Souza       ³ data ³01/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de atualizacao de Resultados					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ SIGAQIP													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³STR 	     ³ Ultimo utilizado ->                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function MenuDef()
Local aRotina := {}

If GetMv("MV_QPTRLAY",.F.,"1") == "1"
	aRotina := {{STR0002   , "AxPesqui",   0, 1,,.F.},;  	//"Pesquisar
				{STR0004   , "QP215AtuRe", 0, 2},;	    	//"Visualizar"
				{STR0005   , "QP215AtuRe", 0, 4},;	    	//"Resultados"
				{STR0006   , "QP215AtuRe", 0, 5},;	  		//"Exclui"
				{STR0007   , "QP215LegOp", 0, 5,,.F.}}  	//"Legenda"
Else
	aRotina := {{STR0002   , "AxPesqui",   0, 1,,.F.},; 	//"Pesquisar
		        {STR0004   , "QP216AtuRe", 0, 2},;	  		//"Visualizar"
				{STR0005   , "QP216AtuRe", 0, 4},;	  		//"Resultados"
				{STR0006   , "QP216AtuRe", 0, 5},;	  		//"Exclui"
				{STR0007   , "QP215LegOp", 0, 5,,.F.}}  	//"Legenda"
EndIf
				 	 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Permite novas opcoes no menu               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215J26")
	aRotina := aClone(ExecBlock("QP215J26",.f.,.f.,{aRotina}))
Endif

Return aRotina

Function QIPA215() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//³    6 - Altera determinados campos sem incluir novos Regs     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local   aPontos := { {"QP220J23"  , "QP215J23"},;
				     {"QIPDELRE"  , "QP215DELR"},;
				     {"QPA210R"   , "QP215R"},;
				     {"QIP220J2"  , "QP215J2"},;
				     {"QIP220J8"  , "QP215J8"},;
				     {"QP220J15"  , "QP215J15"},;
				     {"QIP220J3"  , "QP215J3"},;
				     {"QIP220J7"  , "QP215J7"},;
				     {"QIP220QTE" , "QP215QTE"},;
				     {"QP220MED"  , "QP215MED"},;
				     {"QP220J24"  , "QP215J24"},;
				     {"QP220J19"  , "QP215J19"},;
				     {"QP220J12"  , "QP215J12"},;
					 {"QP220DEL"  , "QP215DEL"},;
				     {"QP220ENS"  , "QP215ENS"},;
				     {"QP220J10"  , "QP215J10"},;
				     {"QP220J13"  , "QP215J13"},;
				     {"QP220J14"  , "QP215J14"},;
				     {"QIP220J9"  , "QP215J9"},;
				     {"QP220J21"  , "QP215J21"},;
				     {"QP215EXE"  , "QP215EXE"}}


Private cMV_QDIRGRA	:= GetMv("MV_QDIRGRA")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabecalho da tela de atualizacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aSitEnt   	:= {}
Private aOperSel    := {}
Private aRotina 	:=  MenuDef()
           
AjustaSXB()
AjustaSX1()
AjustaSX3()
AjustaSX7()

If GetMv("MV_QQ2CONR",.F.,.F.)
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek("QQG_PRODUT")
		RecLock("SX3",.F.)
		SX3->X3_F3 := "SB1"
		MsUnlock()
	EndIf
Else
	dbSelectArea("SX3")
	dbSetOrder(2)
	If dbSeek("QQG_PRODUT")
		RecLock("SX3",.F.)
		SX3->X3_F3 := "QQ2"
		MsUnlock()
	EndIf
EndIf

Aadd(aSitEnt,{"QP215LdoPe()","BR_CINZA"})    //OP sem medicoes cadastradas 
Aadd(aSitEnt,{"QP215EntSM()","BR_AZUL"})    //Laudo Pedente
Aadd(aSitEnt,{"QP215LdoAp()","BR_VERDE"})    //Laudo Aprovado 
Aadd(aSitEnt,{"QP215LdoRe()","BR_VERMELHO"}) //Laudo Reprovado	
Aadd(aSitEnt,{"QP215LdoUr()","BR_AMARELO"})  //Liberacao Urgente
Aadd(aSitEnt,{"QP215LdoCo()","BR_LARANJA"})  //Laudo Condicional
Aadd(aSitEnt,{"QP215LdoSM()","BR_AZUL_OCEAN"})     //Laudo sem Movimentacao de Estoque

QIP215SXB()

If GetMv("MV_QPTRLAY",.F.,"1") == "1"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existem pontos de entrada com nome antigo.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !QPVerifiPE("QIPA215",aPontos,.T.)
		Return(NIL)
	EndIF	
	
	mBrowse(6,1,22,75,"QPK",,"QPK_SITOP",,,,aSitEnt)
Else
	mBrowse(6,1,22,75,"QPK",,"QPK_SITOP",,,,aSitEnt)
EndIf

Return(NIL)                                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215ATURES³ Autor ³Cleber L. Souza        ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Rotina de Atualizacao dos Resultados da OP.   			   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215ATURES(EXPC1,EXPN1,EXPN2)							   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Alias do arquivo									   ³±±
±±³			 ³ EXPN1 = Numero do registro 								   ³±±
±±³			 ³ EXPN2 = Opcao selecionada								   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ATURES(cAlias,nReg,nOpc,cOperAut) 
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"              
Local nOpcA 	 := 0
Local bOk        := {||QP215SavResu(IIF(nFldOpe==3,{SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUG,SAV_LAUO},;
												     IIF(nFldOpe==2,{SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUL},;
												     {SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUO})),.T.),nOpcA := 1,IIF(QP215TUDOK(),oDlgResu:End(),.F.)}
Local bCancel    := {||nOpcA := 0,QP215CANCE(nOpc)}
Local bBlock 
Local bValOk 
Local cTexLOpe   := ""  
Local lDadosOk   

Local nX		 := 0        
Local nY         := 0
Local nZ		 := 0
Local nW		 := 0    

Local aRetLab    := {}    //Laboratorios utilizados na medicao
Local aTitLab    := {}  
Local aTitNCC    := {}  
Local aTitOpe    := {}  
Local aPagLab    := {}    
Local aPagNCC    := {}    
Local aPagOpe    := {}    
Local aPosEncOP  := {}  
Local aPosEncLAU := {}  

Local nOpcEnc    := 2      //Visualiza (apenas para a Enchoice das OPs)
Local nPosLau
Local cEspecOP	 := "MATA650 "     
Local lGrava     := .T.  
Local lIntQNC   := If(GetMv("MV_QIPQNC",.F.,"1")=="1",.T.,.F.) // "Integracao com QNC 1-Sim/2-Nao"
Local lCarOtm 	 := .F.

// variaveis  utilizadas no outro layout
Private lExibConOut := .T.
Private cAliasOPQP7 := "QP7"
Private cAtuNco 	:= "1"
Private	lAtuIns     := .T.  
Private lCPrimOP	:= GetMv("MV_QPCPROP",.F.,"1") == "1" //Indica se o sistema irá carregar a primeira Operação na tela de Resultados ou irá possibilitar ao usuário carregar a Operação desejada, 1 = Sim / 2 = Não 

//variaveis utilizadas na edicao da getdados
Private aHeader
Private aCols

//variaveis utilizadas na edicao da getdados
Private nUsado    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Array que contem os arquivos anexos por Laboratorio/Ensaio.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aDocAne		:= {}      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis com os dados do usuario que esta anexando o documento.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMatCod    := QA_Usuario()[3] //Retorna a Matricula do Usuario logado
Private cMatFil    := QA_Usuario()[2] //Retorna a Filial do Usuario logado
Private cMatNom    := QA_Usuario()[6] //Retorna o Nome do Usuario logado

Private oGetLauOpe
Private oGet
Private oBrwOpe   
Private oFolder  
Private oFolderOP  
Private oBrwEns  
Private oCronica  
Private oGetRast
Private oDlgResu 
Private oSay1
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os Fatores Aprovado, Aprovado Condicional e Reprovado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cFatApr	:= " " //Aprovado
Private cFatRep	:= " " //Reprovado 
Private cFatApC	:= " " //Condicional
Private cFatLU	:= " " //Liberacao urgente

//Variaveis globais	 										 
Private aResultados := {}         	 //armazena os resultados das medicoes                                              
Private aEnsaios    := {}    		 //Ensaios utilizados nas medicoes   
Private aOperacoes  := {}    		 //Ensaios utilizados nas medicoes   
Private nQtdOpe     := 0  
Private nOpcX       := nOpc               
Private aOBJETOS    := {{},{},{},{},{},{},{},{},{},{},{},{}} 
Private lAutomatic  := .F.
//variaveis utilizadas na edicao dos dados do Laboratorio
Private aTela       := {}
Private aGets       := {}    
Private aGetLauOpe  := {}                                       
Private aTelaLauOpe := {}                                       
Private aButtons    := {}  
             
Private nPosAne    //Nome do Documento/Arquivo anexado ao Ensaio

//Salva o aHeader e aCols das Nao-conformidades, Instrumentos, Documentos Anexos e Rastreabilidade
Private aSavaHeader := {{},{},{},{}}
Private aSavaCols   := {{},{},{},{}}   
Private aSavTela 	:= {}   
Private aSavGets    := {}    
Private aSavHeadEns := {}   //Salva o aHeader e aCols definido de acordo com o ensaio selecionado 

Private aCpoUsu     := {}  //Armazena os campos ems uso criados pelo usuarios como aliases iguais a QPR,QES,QPQ
Private aCpoQry     := {}  //Armazena os campos a serem utilizados na montagem da Query
Private aPagLabOp  := {}    
Private aTitLabOp  := {}  

//Define as coordenadas da Tela
Private aPosObj	 := {}
Private aPosGet  := {}
Private aSize	 := {}
Private aInfo	 := {}  
Private aObjects := {}

Private aCpoEnc  := {{},{}}
Private aCpoLOP  := {{},{}}                              
Private aCpoQPK  := {{},{}}                              
            
//Variaveis publicas com os valores posicionados on line
Private nOperacao    := 1
Private nOperaAnt    := 1
Private nEnsaio      := 1
Private nEnsaioA     := 1
Private nMedicao     := 1  
Private nMedicaoA    := 1  
Private nNCO         := 1  
Private nNCOA        := 1  
Private cTexCro      := "" 

Private hOk := LoadBitmap(GetResources(),"PMSTASK4")  //Aprovado
Private hNo := LoadBitmap(GetResources(),"PMSTASK1")  //Reprovado 
Private hPd := LoadBitmap(GetResources(),"PMSTASK2")  //Pendente 
Private hVz := LoadBitMap(GetResources(),"PMSTASK3")  //Nao utilizado
/*
Private hOk := "A"
Private hNo := "R"
Private hPd := "P"
Private hVz := "NU"
*/
Private nPosCodNco //posicao do Codigo da Nao-Conformidade 
Private nPosNumNco //posicao do Numero de Nao-Conformidades
Private nPosClaNco //posicao da Classe da Nao-Conformidade    
Private nPosLauGer //posicao do Laudo do Laboratorio/Geral da OP
Private nPosDesLau //posicao da Descricao do Laudo da OP
Private nPosJusLau //posicao da Justificativa do Laudo Final da OP
Private nPosDtaLau //posicao da data do Laudo
Private nPosValLot //posicao da Validade do Lote
Private aDesLab    //Nome dos folders dos laboratorios

Private nFldOpe      := 1    //Posicao atual do laboratorio            
Private nFldOpeA     := 1    //Posicao do ultimo Folder selecionado  
Private nFldLab      := 0    //Posicao atual do laboratorio            
Private nFldLabA     := 0    //Posicao do ultimo Folder selecionado   
Private nFldLauGer   := 0    //Posicao do Laudo Geral da OP 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      Inicio Parametros cliente J&J        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Parametros de integração copm  o Metrologia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMV_QIPQMT	:= GetMv("MV_QIPQMT")
Private cMV_QPINAUT	:= GetMv("MV_QPINAUT")			// Define se o Instrumento da primeira  medição será replicado para as medições do ensaio qdo estas forem informadas.
Private cMV_QINTQMT := GetMv("MV_QINTQMT") 			// Define a Integração com o Metrologia
Private cMV_QPINSOB	:= GetMv("MV_QPINSOB") 			// Define a obrigatoriedade da familia do intrumento na rotina de Especificação e em Resultados se o Instrumento para dar o Laudo é obrigatório.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Define se quando o instrumento não for obrigatório e familia ³
//³de Instrumento for Informada, na rotina de Resultados        ³
//³1-Bloqueia Laudo e TudoOK                                    ³
//³2- Exibe Alerta                                              ³
//³3 - Bloqueia somente Laudo com Regra de Validação Invertida*.³
//³                                                             ³
//³* Regra de Validação Invertida - No padrão se valida primeiro³
//³o Instrumento e depois a Medição, a opção 3 inverte isso     ³
//³logo será  validado  primeiro a medição e depois o           ³
//³Instrumento.                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMV_QINOBFM	:= GetMV("MV_QINOBFM",.T.,"2") // Caso o Instrumento não seja  obrigatório e haja uma  familia  vinculada 1 = Valida Instrumento / 2 = Não Valida / 3 = Valida  somente no Laudo do Laboratório
Private cMV_QINVLTX	:= GetMV("MV_QINVLTX",.T.,"2") // Define se valida a obrigatoriedade do instrumento para ensaios do tipo Texto 1- Sim ou 2- Não.
Private cMV_QPVLIN	:= GetMv("MV_QPVLIN") 			// Define se valida o Instrumento na tela de Resultados S/N
Private cMV_QINVTOT := GetMv("MV_QINVTOT",.T.,"2")	// Define se irá atualizar o led do instrumento somente qdo todas as linhas estiverem preenchidas

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      Inicio Parametros cliente J&J        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMV_QAPCTOL	:= GetMv("MV_QAPCTOL")
Private cMV_QDIREIN	:= GetMv("MV_QDIREIN")
Private cMV_QPMEAUT := GetMv("MV_QPMEAUT") 
Private cMV_QINTPC  := GetMv("MV_QINTPC") 
Private lMV_INTRAST := GETMV("MV_INTRAST",,.T.)
Private lMV_QCALLIM := GetMV("MV_QCALLIM")
Private dDataFec    := If(FindFunction("MVUlmes"),MVUlmes(),GetMV("MV_ULMES")) 
Private lDelOpSC    := GetMV("MV_DELOPSC")== "S"
Private lProdAut    := GetMv("MV_PRODAUT")
Private lRastTot	:= Iif(GetMv('MV_QPLRAST') == 'T',.T.,.F.)
Private lAlteravel	:= Iif(GetMv("MV_QMEDLAU") == "S",.T.,.F.)

Private lLiberaUrg  := .F.
Private lJusLObrL   := .F.
Private lJusLObrO   := .F.
Private lJusLObrG   := .F.
Private lIntQual    := .T.
//Private lECalc		:= .F.  //Indica se existe ensaio calculado, utilizado no Layout 2 somente
//Private lAtuCalc 	:= .F.  //Indica se o ensaio calculado foi atualizado, utilizado no Layout 2 somente

Private lWhnCro    := .T.  
Private cEspObsOpe := "QIPA010 "
Private cTexObs    := "" 
Private cMensagem  := ""
Private cRoteiro   := ""
Private cCadastro  := OemtoAnsi(STR0008)  //"Cadastro de Resultados"   
Private cTexSeq    := ""

//Variaveis relacionamento entre Cliente x Produto.
Private cIPCLIENT  := CriaVar("A1_COD",.F.)
Private cIPLoj     := CriaVar("A1_LOJA",.F.)

Private lQP215Del	:=  ExistBlock("QP215DEL")
Private lQP215J1	:=	ExistBlock("QP215J1")
Private lQP215J2	:=	ExistBlock("QP215J2")
Private lQP215J8	:=	ExistBlock("QP215J8")
Private lQP215J15	:=	ExistBlock("QP215J15")  
Private lQP215EXE   :=  ExistBlock("QP215EXE")

//aHeader e aCols que serao usados na rotina
//de documentos anexos
Private aHeadAne := {}
Private	aColsAne := {}
Private cArq := ""   
Private nNoDel:= 0
Private lNoGravRast:= .F.
Private lMostraTela:= .F.

Default cOperAut    :=  ""        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se ja existe usuario ALTERANDO e/ou EXCLUINDO Resultado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpc == 3 .Or. nOpc == 4) .And. !SoftLock(cAlias)
	Return Nil
EndIf
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a posição da Operação								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(Alltrim(cOperAut))
	lAutomatic := .T.
EndIF

aSize	:= MsAdvSize()
aInfo	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo,aObjects,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o registro na Especificacao do Produto			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC2")
dbSetOrder(1)                               
SC2->(dbSeek(xFilial("SC2")+QPK->QPK_OP))
cRoteiro := SC2->C2_ROTEIRO

If nOpc == 4 //exclusao
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica na exclusao, se existem medicoes cadastradas, para  ³
	//³ OPs sem Laudos Informados.			    					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QPK->QPK_SITOP $("1, ")
		Help(" ",1,"QP215OPSME")  //OP naum possue laudo informado.
		(cAlias)->(MsUnlock())		//Libera SoftLock da QPK
		Return(NIL)
	EndIf
Else
	If lIntQNC .and. !QNCMSGERA(STR0193)  //"Verificar parâmetros referentes a integração com o QNC (Controle de Nao Conformidades"
		If nOpc == 3
			(cAlias)->(MsUnlock())	//Libera SoftLock da QPK
		EndIf
		Return(NIL)
	EndIF
EndIf
       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215J23")	
	lDadosOk := ExecBlock("QP215J23",.F.,.F.,{nOpc,QPK->QPK_OP,QPK->QPK_LOTE,QPK->QPK_NUMSER})
	If !lDadosOk
		If (nOpc == 3 .Or. nOpc == 4)
			(cAlias)->(MsUnlock())		//Libera SoftLock da QPK
		EndIf
		Return(NIL)
	Endif
Endif                                                  
            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se apresenta tela com o relacionamento entre 		 ³
//³ cliente x Produto.					    					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QPK->(FieldPos("QPK_CLIENT")) <> 0  
	If Empty(QPK->QPK_CLIENT) .And. cMV_QINTPC .And. Empty(QPK->QPK_SITOP)
		QP215Cli()            
		dbSelectArea("QPK")
		RecLock("QPK",.f.)
		QPK->QPK_CLIENT := cIPCLIENT
		QPK->QPK_LOJA   := cIPLoj
		MsUnlock()	
		lMostraTela := .T.
	Else
		cIPCLIENT  := QPK->QPK_CLIENT
		cIPLoj     := QPK->QPK_LOJA
	EndIf 
Else
	If cMV_QINTPC .and. Empty(QPK->QPK_SITOP)
		QP215Cli()
	Else
		dbSelectArea("QPR")
		dbSetOrder(9)
		If dbSeek(xFilial("QPR")+QPK->QPK_OP)
			cIPCLIENT  := QPR->QPR_CLIENT
			cIPLoj     := QPR->QPR_LOJA
		EndIf
	EndIf
EndIf	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena o aHeader e aCols para as Nao-conformidades         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader               := aClone(APBuildHeader("QPU"))
ADHeadRec("QPU",aHeader)
aCols                 := aClone(QP215aCols("QPU",Len(aHeader)))
aSavaHeader[HEAD_NCS] := aClone(aHeader)
aSavaCols[HEAD_NCS]   := aClone(aCols)

aHeader := {}
aCols   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena o aHeader e aCols para os Instrumentos				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(APBuildHeader("QPT"))
ADHeadRec("QPT",aHeader)
aCols   := aClone(QP215aCols("QPT",Len(aHeader)))
aSavaHeader[HEAD_INST] := aClone(aHeader)
aSavaCols[HEAD_INST]   := aClone(aCols)

aHeader := {}
aCols   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena o aHeader e aCols para os documentos anexos		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(APBuildHeader("QQJ"))
ADHeadRec("QQJ",aHeader)
aCols   := aClone(QP215aCols("QQJ",Len(aHeader)))
aSavaHeader[HEAD_ANEXO] := aClone(aHeader) 
aSavaCols[HEAD_ANEXO]   := aClone(aCols)  

nPosAne := Ascan(aHeader,{|x| Upper(Alltrim(x[2])) == "QQJ_ANEXO"}) //Arquivo;Documento Anexo	

aHeader := {}
aCols   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Armazena o aHeader e aCols para os Rastreabilidade			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aHeader := aClone(APBuildHeader("QQG"))
ADHeadRec("QQG",aHeader)
aCols   := aClone(QP215aCols("QQG",Len(aHeader)))
aSavaHeader[HEAD_RASTRO] := aClone(aHeader)
aSavaCols[HEAD_RASTRO]   := aClone(aCols)   

//Adiciona validacoes especificas no aHeader de Rastreabilidade.
For nY:=1 to Len(aSavaHeader[HEAD_RASTRO])
	If Alltrim(aSavaHeader[HEAD_RASTRO,nY,2]) == "QQG_PRODUT"
		aSavaHeader[HEAD_RASTRO,nY,6] := "QP215VPR()"       
	ElseIf Alltrim(aSavaHeader[HEAD_RASTRO,nY,2]) == "QQG_LOTE"
		aSavaHeader[HEAD_RASTRO,nY,6] := "QP215VLR()"       
	ElseIf Alltrim(aSavaHeader[HEAD_RASTRO,nY,2]) == "QQG_QTDE"
		aSavaHeader[HEAD_RASTRO,nY,6] := "QP215VQR()"       
    EndIf                                           
Next nY

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o vetor com os campos a serem utilizados na Enchoice OPE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(1))
SX3->(MsSeek("QPM"))
While SX3->(!Eof()) .And. (SX3->X3_ARQUIVO == "QPM") 
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(aCpoLOp[1],SX3->X3_CAMPO)
		Aadd(aCpoLOp[2],SX3->X3_CONTEXT)
	EndIf
	SX3->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o vetor com os campos a serem utilizados na Enchoice LAB³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(1))
SX3->(MsSeek("QPL"))
While SX3->(!Eof()) .And. (SX3->X3_ARQUIVO == "QPL") 
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)
		Aadd(aCpoEnc[1],SX3->X3_CAMPO)
		Aadd(aCpoEnc[2],SX3->X3_CONTEXT)
	EndIf
	SX3->(dbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva as posicoes dos campos utilizados nas nao-conformidades³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosCodNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_NAOCON"})                
nPosNumNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_NUMNC"})                
nPosClaNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_CLASSE"})                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva as posicoes das variaveis no aCpoEnc                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosLauGer := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_LAUDO"}) //Posicao do Laudo da OP
nPosJusLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_JUSTLA"})//posicao da Justificativa do Laudo
nPosDtaLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTLAUD"})//posicao da data do Laudo
nPosDesLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DESLAU"})//posicao da descricao do Laudo
nPosValLot := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTVAL"}) //posicao da Validade do Lote

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os botoes para as rotinas especificas 				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Aadd(aButtons,{"PENDENTE",  {|| QP215LegEn()},STR0158,STR0159}) //"Legenda dos Ensaios"###"Leg.Ensa" 
AAdd(aButtons,{"NCO",  {|| QP215ReNCo()},STR0009,STR0010}) //"Não Conformidades..."###"Nao Conf" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Botao para Visualizacao do Documento anexo ao Ensaio Metodo	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aButtons,{"VERNOTA",{||If(nFldOpe<>2,Help(" ",1,"QPH215072"),QDOVIEW(,aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPR_METODO"})] , ;
                                                                              aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPR_RVDOC"})]))},STR0154,STR0155}) //"Visualizar o conteudo do Documento..."###"Cont.Doc"

AAdd(aButtons,{"ENSAIO1", {|| QP215BEnsa(hOK,hNo,hVz)},STR0011,STR0012}) //"Ensaios..."###"Ensaio"
Aadd(aButtons,{"CARGA",     {|| QP215LibU(nOpc)},STR0013,STR0014}) //"Liberacao Urgente"###"Lib.Urg."

If lQP215J8
	Aadd(aButtons,{"DBG05",{|| ExecBlock("QP215J8",.F.,.F.,{QPK->QPK_OP,QPK->QPK_LOTE,QPK->QPK_NUMSER})},STR0199,STR0200}) //"Assinatura Eletronica..."###"Ass.Elet"
EndIf 

If lQP215J15
	Aadd(aButtons,{"HISTORIC",{|| ExecBlock("QP215J15",.F.,.F.,{QPK->QPK_OP,QPK->QPK_LOTE,QPK->QPK_NUMSER,nOpc,aResultados[nFldLauGer,1,nPosLauGer]}) },STR0015,STR0016})  //"Observacao"###"Observ" 
EndIf

Aadd(aButtons,{"PARAMETROS", {|| QipAnexo("QIP",nOpc) }, OemToAnsi(STR0017) } )   //"Anexar Documento."
Aadd(aButtons,{"LINE"  ,{||QIP215GCT()},STR0018,STR0019})  //"Carta de Controle"###"Cart.Con"
Aadd(aButtons,{"GRAF2D",{||QIP215GDP()},STR0020,STR0021})  //"Diagrama de Pareto"###"Diag.Par"
             
If lQP215J2 
	Aadd(aButtons,{	"EDIT",{|| ExecBlock("QP215J2",.F.,.F.,{aResultados[nOperacao,_OPE],QPK->QPK_OP,QPK->QPK_LOTE,QPK->QPK_NUMSER,aResultados[nOperacao,_LOP,QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO")],nOpc}) },STR0201,STR0202})   //"Campos informativos" ### "Camp.Inf"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Habilita botao para alterar potencia do lote         		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 3  // Somente na Inclusao/Alteracao
	Aadd(aButtons,{'AUTOM',{||QP215PotL(QPK->QPK_LOTE)},STR0022,STR0023}) //"Potencia do Lote"###"Pot.Lote"
Endif

Aadd(aButtons,{'DBG06',{||QP215OPRAP()},STR0203,STR0204}) //"Operacao Rapida"###"Oper.Rap"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define os Fatores Aprovado, Aprovado Condicional e Reprovado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QPD->(dbSeek(xFilial("QPD")))
	While !QPD->(Eof())
		If QPD->QPD_CATEG == "1"
			cFatApr := Iif(Empty(cFatApr),QPD->QPD_CODFAT,cFatApr)
		ElseIf QPD->QPD_CATEG == "2"
			cFatApC += QPD->QPD_CODFAT
		ElseIf QPD->QPD_CATEG == "3"
			cFatRep := Iif(Empty(cFatRep),QPD->QPD_CODFAT,cFatRep)
		ElseIf QPD->QPD_CATEG == "4"
			cFatLU := Iif(Empty(cFatLU),QPD->QPD_CODFAT,cFatLU)
		EndIf
		QPD->(dbSkip())
	EndDo
	If Empty(cFatApr) .Or. Empty(cFatApC) .Or. Empty(cFatRep)
		Help(" ",1,"QPH215020")  //Não foram cadastrados os fatores de Indice de Qualidade do Produto (IQP). É necessário existir um Fator para aprovação, Reprovação e Aprovação Condicional. Cadastre para continuar utilizando a rotina resultados.
		lDadosOk	:= .F.
	EndIf
Else
	Help(" ",1,"QPH215020")  //Não foram cadastrados os fatores de Indice de Qualidade do Produto (IQP). É necessário existir um Fator para aprovação, Reprovação e Aprovação Condicional. Cadastre para continuar utilizando a rotina resultados.
	lDadosOk	:= .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores com as opcoes no Folder (OPE x LAB)		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !QP215FLAB(QPK->QPK_PRODUT,QPK->QPK_REVI,@aRetLab,nOpc)   
	If (nOpc == 3 .Or. nOpc == 4)
		(cAlias)->(MsUnlock())		//Libera SoftLock da QPK
	EndIf
	Return()
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reset das Variaveis de Controle da Tela.					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOperacao :=1
nFldLab   :=1
nEnsaio   :=1                                                                                                                                                      
nMedicao  :=1 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores com os Laboratorios utilizados nas Operacoes³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 to Len(aRetLab)
	AADD(aTitLabOp,{})
	AADD(aPagLabOp,{})
	For nX:=1 to Len(aRetLab[nY])
		AADD(aTitLabOp[nY],OemToAnsi(aRetLab[nY,nX,1]))
		AADD(aPagLabOp[nY],aRetLab[nY,nX,2])
	Next nX
Next nY

DEFINE MSDIALOG oDlgResu TITLE cCadastro From aSize[7],000 To aSize[6],aSize[5] OF GetWndDefault() PIXEL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Trata o registro da OP selecionada	    					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc # 2 //Visualizacao
	RecLock("QPK",.F.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Dados da  OP a inspecionar							     	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
AADD(aPosEncOP,{15,3,53,393})
AADD(aPosEncLAU,{200,3,260,505}) 

RegToMemory("QPK")
oEncQPK:=MsMGet():New("QPK",nReg,nOpc,,,,,{1,1,35,50},aCpoQPK[1],3,,,,oDlgResu,,.T.,,,,,,,.T.)
oEncQPK:oBox:Align := CONTROL_ALIGN_TOP

Aadd(aPagLab,STR0024) //"LAUDO GERAL"
AADD(aTitLab,STR0025) //"OPERACOES"
AADD(aTitLab,STR0026) //"LABORATORIOS"
AADD(aTitLab,STR0024) //"LAUDO GERAL"
aDesLab := aClone(aPagLab)     

oFolder := TFolder():New(25,3,aTitLab,aPagLab,oDlgResu,,,,.T.,.T.,391,210)			
oFolder:Align := CONTROL_ALIGN_ALLCLIENT
oFolder:bSetOption:={|nPos|QP215ChgOpe(nFldOpe:=nPos,nFldOpeA:=oFolder:nOption,nOpc)} 
oFolder:lModified:=.T. 
               
AADD(aTitOpe,STR0027) //"LAUDO DA OPERACAO"
AADD(aTitOpe,STR0028) //"RASTREABILIDADE"
aPagOpe := aClone(aTitOpe)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Associa os ensaios ao Laboratorio corrente no Folder		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
Eval({||QP215Opera()})       

If Len(aOperacoes) >= 5
	hOk := "A"
	hNo := "R"
	hPd := "P"
	hVz := "NU"
	oBrwOpe:Refresh()
Endif

oFolderOp := TFolder():New(53,3,aTitOpe,aPagOpe,oFolder:aDialogs[1],,,,.T.,.T.,384,144)			
oFolderOp:bSetOption:={|nPos|IIF(oFolderOp:nOption==2,QP215RTOK(),.T.)} 
oFolderOp:Align := CONTROL_ALIGN_ALLCLIENT
oFolderOp:lModified:=.T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores das Enchoices de Laudos da Operacao		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
RegToMemory("QPM")
Aeval(aCpoLOP[1],{|x,y|M->&(aCpoLOP[1,y]):=aResultados[nOperacao,_LOP,y]})

aTela := {}
aGets := {}  
oGetLauOpe:=MsMGet():New("QPM",nReg,nOpc,,,,,{1,2,90,383},aCpoLOP[1],3,,,,oFolderOP:aDialogs[1],,.T.,,,,,,,.T.)
oGetLauOpe:oBox:Align := CONTROL_ALIGN_TOP
aGetLauOpe  := aClone(aGets)    
aTelaLauOpe := aClone(aTela) 

@ 97,005  GET oObsOPE VAR cTexObs MEMO VALID .T. Size 374,28 Of oFolderOP:aDialogs[1] Pixel NO MODIFY
oObsOPE:Align := CONTROL_ALIGN_ALLCLIENT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da GetDados da Rastreabilidade				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oGetRast := MsNewGetDados():New(1,2,127,382,Iif(Altera .Or. Inclui, GD_INSERT+GD_DELETE+GD_UPDATE, 0),"QP215RLOK","QP215RTOK","",,,,,,,oFolderOP:aDialogs[2],aSavaHeader[HEAD_RASTRO],aResultados[nOperacao,_RAS])
oGetRast:oBrowse:bLostFocus:= {|| QP215SavResu({SAV_RAS}), QP215RTOK() }
oGetRast:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
                                                                                                                                                  
If lCarOtm // Resurso ainda não disponivel neste layout
	// 0. Carregar o aOperaFull
	// 1. Carregar  somente  a  operação 1 do aResultados
	// 2. Criar uma  função de carga dinamica como faço no QIPA216 chamada na  mudança de linha 
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os vetores do Objetos									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nY:=1 to nQtdOpe 
	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao do Laudo da Operacao  						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   	AADD(aOBJETOS[OBJ_LAUOPE],{})
	   	QP215CarLau(nY,nReg,nOpc,oFolder:aDialogs[1])
	
	 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Definicao dos Folders dos Laboratorios					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		AADD(aOBJETOS[OBJ_FOLLAB],{})
	   	QP215CarFLab(nY,nReg,nOpc)                            
	
	Next nY  
EndIf	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores das Enchoices do Laudo Geral       		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTela := {}
aGets := {}                         
AADD(aSavTela,{})
AADD(aSavGets,{})
RegToMemory("QPL") 
Aeval(aCpoEnc[1],{|x,y|M->&(aCpoEnc[1,y]):=aResultados[nFldLauGer,1,y]})
AADD(aOBJETOS[OBJ_LAUGER],MsMGet():New("QPL",nReg,nOpc,,,,,{3.28,3.28,100,386},aCpoEnc[1],3,,,,oFolder:aDialogs[3],,.T.,,,,,,.T.))
aOBJETOS[OBJ_LAUGER,1]:oBox:Align := CONTROL_ALIGN_TOP

aSavTela[nFldLauGer] := aClone(aTela)
aSavGets[nFldLauGer] := aClone(aGets)  
                                               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Status da Array de Operacoes.             			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 to Len(aOperacoes)
	aOperacoes[nY,1] := QP215AtuSta(nY,,,,"O",{1},.F.)
	aOperacoes[nY,2] := QP215AtuSta(nY,,,,"O",{1},.F.)
	aOperacoes[nY,3] := QP215AtuSta(nY,,,,"O",{2},.F.)
Next nY 
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bloqueia ou naum Enchoice das Operacoes.          			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lLayout
	nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
Else                                                                                                   
	nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
EndIf

QP215ADMOBJ(,,,3,!Empty(aResultados[nFldLauGer,1,nPosLau]) .Or. lLiberaUrg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Get Memo da Observacao da OP.                     			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTexLOpe := IIF(QPK->QPK_SITOP#cFatLU .or. Empty(QPK->QPK_SITOP),QA_RecTxt(SC2->C2_CHAVE,cEspecOP,00,,"QA2",{}),"")
@ 111,007 GET oObsOP VAR cTexLOpe MEMO VALID .T. Size 376,80 Of oFolder:aDialogs[3] Pixel NO MODIFY
oObsOP:Align := CONTROL_ALIGN_ALLCLIENT
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se possui Liberacao Urgente.						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aResultados[nFldLauGer,1,3]) 
	If aResultados[nFldLauGer,1,3] == cFatLU 
		lLiberaUrg := If(!lLiberaUrg,.T.,lLiberaUrg)
    EndIF
EndIf     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza laudo das operações 								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTela := aSavTela[nOperacao,1]
aGets := aSavGets[nOperacao,1]  
For nX := 1 to Len(aCpoLOP[1])
	&("M->"+aCpoLOP[1,nX]) := aResultados[nOperacao,_LOP,nX]
Next nX  
oGetLauOpe:EnchRefreshAll()         

If ExistBlock("QP215Dlg")
	ExecBlock("QP215Dlg",.F.,.F.)
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada criado para mudar os botoes da enchoicebar                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215BUT")
	aButtons := ExecBlock("QP215BUT",.F.,.F.,{nOpc,aButtons})
EndIf

ACTIVATE MSDIALOG oDlgResu ON INIT (EnchoiceBar(oDlgResu,bOk,bCancel,,aButtons),QP215FLIBU(),IIF(lAutomatic,QP215OPRAP(cOperAut),.t.)) VALID QP215SavResu({SAV_RAS})

If nOpcA == 0 .And. lMostraTela .And. QPK->(FieldPos("QPK_CLIENT")) > 0  
	QPK->(dbSelectArea("QPK"))
	QPK->(RecLock("QPK",.F.))
	QPK->QPK_CLIENT := ""
	QPK->QPK_LOJA   := ""
	QPK->(MsUnlock())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para permitir prosseguir a gravacao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpcA==1 .And. ExistBlock("QP215J24")
	lGrava := ExecBlock("QP215J24",.F.,.F.,{nOpc})
Endif

If (nOpc==3 .or. nOpc==4) .and. nOpcA==1 .and. lGrava
	QP215GrvAll(nOpc)
EndIf   

If (nOpc == 3 .Or. nOpc == 4)
	(cAlias)->(MsUnlock())		//Libera SoftLock da QPK
EndIf

Return(nOpc)                           

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215FLAB ³ Autor ³Cleber L. Souza        ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Carrega o vetor aResultados com os dados das medicoes cadas-³±±
±±³			 ³tradas.													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FLAB(EXPC1,EXPC2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo do Produto								  ³±±
±±³			 ³ EXPC2 = Revisao do Produto								  ³±±
±±³			 ³ EXPA1 = Titulo dos Folders dos Laboratorios			      ³±±
±±³			 ³ EXPN1 = Opcao do aRotina									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 = .T. Ensaios a Inspecionar						  ³±±
±±³			 ³ 		   .F. Nao existem Ensaios a Inspecionar			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FLAB( cProduto, cRevisao, aTitPag, nOpc, cOperCar )
Local aAreaAnt   := GetArea()
Local aAreaQP7   := QP7->(GetArea())
Local aAreaQP8   := QP8->(GetArea())
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nPos       := 0                                        
Local aColsLab   := {} 
Local aColsEns   := {} 
Local aColsNCs   := {}
Local aColsIns   := {}
Local aColsAne   := {}
Local aLauAnt    := {}
Local aLauLab    := {}
Local aLauGer    := {}
Local nPosChvQPR
Local nPosChvNco      
Local cSeek      := ""
Local nLab       := 0
Local nMed       := 0
Local nNco       := 0
Local nIns       := 0
Local aNco       := {}
Local cTitLab    := ""
Local nPosLet    := 0
Local cTeclas    := "OLGURNIB"
Local cSkpTst 
Local lFilLab    := .T.
Local nY         := 0    
Local lOperaOk   := .T.
Local nPosOpe //Posicao da Operacao Corrente
Local nPosLab //Posicao do Laboratorio corrente
Local nPosEns //Posicao do Ensaio corrente      
               
//Variaveis utilizadas para iniciar campos no Laudo do Laboratorio
Local nPosDtEnLa := 0
Local nPosHrEnLa := 0
Local nPosTamLot := 0
Local nPosDtaLau := 0
Local nPosValLau := 0

//Variaveis utilizadas para iniciar campos no Laudo da Operacao
Local nPosDtEnOp := 0
Local nPosHrEnOp := 0
Local nTamLotOP  := 0
Local nDtaLauOP  := 0
Local nValLauOP  := 0
Local xRetorno
Local lCarOtm 	 := .F.
Local lVerif     := .T.
Local lFamVinc   := .F.

Default cOperCar := "  "
                      
If !lLayout
	lCarOtm := GetMv("MV_QPCAROT",.F.,"1") == "1"   // Carga Otimizada para o Layout simplificado, o valor default é carregar otimizado.
EndIf

//Variaveis utilizadas para iniciar campos no Laudo do Laboratorio
nPosDtEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTENLA"})
nPosHrEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_HRENLA"})
nPosTamLot := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_TAMLOT"}) 
nPosDtaLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTLAUD"})
nPosValLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTVAL"})  
	
//Variaveis utilizadas para iniciar campos no Laudo da Operacao
nPosDtEnOp := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTENLA"})
nPosHrEnOp := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_HRENLA"})
nTamLotOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_TAMLOT"})
nDtaLauOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTLAUD"})
nValLauOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTVAL"})
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³              Nova estrutura do vetor aResultados             ³
//ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ Elemento ³                     Descricao                     ³
//ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³ [1,1]    ³ Operacao	     						 			 ³
//³          ³                    	                             ³
//³ [1,2]    ³ Laboratorio 	    					 			 ³
//³          ³                    	                             ³
//³ [1,3]    ³ Ensaio 								 			 ³
//³ [1,3,01] ³ Status Medicoes 						 			 ³
//³ [1,3,02] ³ Status Nao-conformidades				 			 ³
//³ [1,3,03] ³ Status Instrumentos      				 		 ³
//³ [1,3,04] ³ Status dos Documentos Anexos				 		 ³
//³ [1,3,05] ³ QP7_SEQLAB/QP8_SEQLAB					 		 ³
//³ [1,3,06] ³ QP7_ENSAIO/QP8_ENSAIO 				 			 ³
//³ [1,3,07] ³ QP1_DESCPO	 						 			 ³
//³ [1,3,08] ³ QP1_CARTA								 		 ³
//³ [1,3,09] ³ QP7_LIE/" "			 				 			 ³
//³ [1,3,10] ³ QP7_NOMINA/" "						 			 ³
//³ [1,3,11] ³ QP7_LSE/" "							 			 ³
//³ [1,3,12] ³ Quantidade de Medicoes				 			 ³
//³ [1,3,13] ³ Situacao do Skip-Teste 							 ³
//³ [1,3,14] ³ QP1_METODO							 			 ³
//³ [1,3,15] ³ QP7_REVDOC 							 			 ³
//³ [1,3,16] ³ QP1_DESCIN							 			 ³
//³ [1,3,17] ³ QP1_DESCES						     			 ³
//³ [1,3,18] ³ Familia Vinculada QQ1			     			 ³
//³ [1,3,19] ³ QP1_TIPO							     			 ³
//³ [1,3,20] ³ QP7_FORMUL						     			 ³
//³          ³                    	                             ³
//³ [1,4]    ³ Medicoes (Getdados)					 			 ³
//³ [1,5]    ³ Nao-Conformidades (GetDados)			 			 ³
//³ [1,6]    ³ Cronicas 								 		 ³
//³ [1,7]    ³ Instrumentos (GetDados) 				 			 ³ 
//³ [1,8]    ³ Documentos Anexos								 ³
//³ [1,9]    ³ Laudo do laboratorio					 			 ³
//³ [1,10]   ³ Laudo da operacao  					 			 ³
//³          ³                    	                             ³
//³ [2,1]    ³ Laudo Geral da OP	    			 			 ³
//³ [2,2]    ³ Observacoes da OP    				 			 ³
//³          ³                    	                             ³
//³ [3,1]    ³ Liberacao/Rejeicao Material no CQ      			 ³
//³          ³                    	                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lLayout .AND. Len(aResultados) > 1
     Return .T.
EndIf

#IFDEF TOP
If TcSrvType() != "AS/400"	
	If lExibConout
		CONOUT("               Inicio Função SQL - QP215FLAB(QP7): "+DtoC(dDataBase)+"-"+Time())
	EndIf

	cSelQQ7:= "% "
		If !Empty(cIPClient)
	    	cSelQQ7 += " QQ7.QQ7_CLIENT = '"+cIPClient+"'	AND"
			cSelQQ7 += " QQ7.QQ7_LOJA   = '"+cIPLoj   +"'	AND"
	   	EndIf	
    cSelQQ7+= " %" 

	cAliasOPQP7 := GetNextAlias()

	BeginSql Alias cAliasOPQP7

		SELECT    QP7.QP7_PRODUT,   QP7.QP7_REVI, QP7.QP7_CODREC, QP7.QP7_OPERAC, QP7.QP7_LABOR , 
				  QP7.QP7_ENSAIO, QP7.QP7_SEQLAB, QP7.QP7_ENSAIO, QP7.QP7_LIE   , QP7.QP7_NOMINA, 
				  QP7.QP7_LSE   , QP7.QP7_METODO, QP7.QP7_ENSOBR, QP7.QP7_PLAMO , QP7.QP7_FORMUL, 
				  QP1.QP1_DESCPO, QP1.QP1_TPCART, QP1.QP1_CARTA , QP1.QP1_DESCIN, QP1.QP1_DESCES, 
				  QP1.QP1_TIPO  , QQ1.QQ1_INSTR , QQ1.QQ1_DESCR , QQK.QQK_DESCRI,  QQK.QQK_SETUP, 
				  QQK.QQK_TEMPAD, QQK.QQK_OPE_OB, QQK.QQK_SEQ_OB, QQK.QQK_LAU_OB,  QQK.QQK_CHAVE, 
				  QQ7.QQ7_CLIENT,   QQ7.QQ7_LOJA  
		FROM	  %table:QP1% QP1, %table:QQK% QQK, %table:QP7% QP7
		LEFT JOIN %table:QQ1% QQ1 
		       ON QQ1.QQ1_PRODUT = QP7.QP7_PRODUT		AND
				  QQ1.QQ1_REVI   = QP7.QP7_REVI			AND
				  QQ1.QQ1_ROTEIR = QP7.QP7_CODREC		AND
				  QQ1.QQ1_OPERAC = QP7.QP7_OPERAC		AND
				  QQ1.QQ1_ENSAIO = QP7.QP7_ENSAIO	    AND
				  QQ1.%notDel%          
		LEFT JOIN %table:QQ7% QQ7 
		       ON QQ7.QQ7_PRODUT = QP7.QP7_PRODUT		AND
		          QQ7.QQ7_LABOR  = QP7.QP7_LABOR		AND
		          QQ7.QQ7_ENSAIO = QP7.QP7_ENSAIO		AND
		          QQ7.QQ7_CODREC = QP7.QP7_CODREC		AND
                  QQ7.QQ7_OPERAC = QP7.QP7_OPERAC	    AND
				  QQ7.%notDel%
		WHERE	  QP7.QP7_FILIAL = %xFilial:QP7%		AND
				  QP7.QP7_PRODUT = %Exp:cProduto%		AND
				  QP7.QP7_REVI   = %Exp:cRevisao%		AND
				  QP7.QP7_CODREC = %Exp:cRoteiro%		AND
				  %Exp:cSelQQ7%
				  QP1.QP1_FILIAL = %xFilial:QP1%		AND
				  QP1.QP1_ENSAIO = QP7.QP7_ENSAIO		AND
				  QQK.QQK_FILIAL = QP7.QP7_FILIAL       AND
				  QQK.QQK_PRODUT = QP7.QP7_PRODUT		AND
				  QQK.QQK_REVIPR = QP7.QP7_REVI		    AND
				  QQK.QQK_CODIGO = QP7.QP7_CODREC		AND
				  QQK.QQK_OPERAC = QP7.QP7_OPERAC		AND
				  QP7.%notDel% AND
				  QQK.%notDel% AND
				  QP1.%notDel%
		ORDER BY  QP7.QP7_PRODUT, QP7.QP7_REVI, QP7.QP7_CODREC, QP7.QP7_OPERAC, QP7.QP7_SEQLAB
	
	EndSql	

	While &(cAliasOPQP7+"->(!Eof())")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("QP215J3")	
			lOperaOk := ExecBlock("QP215J3",.F.,.F.,{&(cAliasOPQP7+"->QP7_CODREC"),&(cAliasOPQP7+"->QP7_OPERAC"),&(cAliasOPQP7+"->QP7_LABOR"),&(cAliasOPQP7+"->QP7_ENSAIO"),"QP7"})
		Endif                                                      
				
		If lOperaOk
			
			If Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP7_OPERAC")}) == 0  			
	         	If !lLayout
	            	If Len(aResultados) == 1
						cOper := &(cAliasOPQP7+"->QP7_OPERAC")
					EndIf
	
					Aadd(aResultados,{&(cAliasOPQP7+"->QP7_OPERAC"),{},{},{},{},{},{},{},{},{},"",{},{}})     
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aOperacoes,{QPK->QPK_OP,;
									 &(cAliasOPQP7+"->QP7_OPERAC"),;
									 &(cAliasOPQP7+"->QQK_DESCRI"),;
									 Alltrim(Str(&(cAliasOPQP7+"->QQK_SETUP" ))),;
									 Alltrim(Str(&(cAliasOPQP7+"->QQK_TEMPAD"))),;
							     	 &(cAliasOPQP7+"->QQK_OPE_OB"),;
							     	 &(cAliasOPQP7+"->QQK_SEQ_OB"),;
							     	 &(cAliasOPQP7+"->QQK_LAU_OB")})
	         	Else
 					Aadd(aResultados,{&(cAliasOPQP7+"->QP7_OPERAC"),{},{},{},{},{},{},{},{},{},QA_RecTxt(&(cAliasOPQP7+"->QQK_CHAVE"),cEspObsOpe,00,,"QA2",{}),QP215Rastro(&(cAliasOPQP7+"->QP7_OPERAC")),{}})     
	
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aOperacoes,{hVZ,;
									 hVZ,;
									 hVZ,;
									 &(cAliasOPQP7+"->QP7_OPERAC"),;
									 &(cAliasOPQP7+"->QQK_DESCRI"),;
					  				 Alltrim(Str(&(cAliasOPQP7+"->QQK_SETUP" ))),;
					  				 Alltrim(Str(&(cAliasOPQP7+"->QQK_TEMPAD"))),;
					  		     	 &(cAliasOPQP7+"->QQK_OPE_OB"),;
							     	 &(cAliasOPQP7+"->QQK_SEQ_OB"),;
							     	 &(cAliasOPQP7+"->QQK_LAU_OB")})
	         	EndIf
			    
				nPosOpe := Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP7_OPERAC")})
				Aadd(aResultados[nPosOpe,_LAB],&(cAliasOPQP7+"->QP7_LABOR"))
				Aadd(aResultados[nPosOpe,_ENS],{})
				Aadd(aResultados[nPosOpe,_MED],{})
				Aadd(aResultados[nPosOpe,_NCO],{})
				Aadd(aResultados[nPosOpe,_CRO],{})
				Aadd(aResultados[nPosOpe,_INS],{})   
				Aadd(aResultados[nPosOpe,_ANE],{})   
				Aadd(aResultados[nPosOpe,_LLA],{})  
				Aadd(aResultados[nPosOpe,_PLA],{})  
				nQtdOpe ++ 
			Else
				nPosOpe := Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP7_OPERAC")})
				If Ascan(aResultados[nPosOpe,_LAB],{|x|x==&(cAliasOPQP7+"->QP7_LABOR")}) == 0  
					Aadd(aResultados[nPosOpe,_LAB],&(cAliasOPQP7+"->QP7_LABOR"))
					Aadd(aResultados[nPosOpe,_ENS],{})
					Aadd(aResultados[nPosOpe,_MED],{})
					Aadd(aResultados[nPosOpe,_NCO],{})
					Aadd(aResultados[nPosOpe,_CRO],{})
					Aadd(aResultados[nPosOpe,_INS],{})   
					Aadd(aResultados[nPosOpe,_ANE],{})   
					Aadd(aResultados[nPosOpe,_LLA],{})   
					Aadd(aResultados[nPosOpe,_PLA],{})  
				EndIf
			EndIf

			cSkpTst := QP215SkpT(&(cAliasOPQP7+"->QP7_ENSAIO"),&(cAliasOPQP7+"->QP7_OPERAC")) 
			
			//Preenche o aResultados com os Ensaios Vinculados ao Laboratorio
			nPosLab := Ascan(aResultados[nPosOpe,_LAB],{|x|x==&(cAliasOPQP7+"->QP7_LABOR")})
			If (nPosLab > 0)
				lFamVinc := !Empty(AllTrim(&(cAliasOPQP7+"->QQ1_INSTR")))
				
				nPosEns := Ascan(aResultados[nPosOpe,_ENS,nPosLab],{|x|x[2]==&(cAliasOPQP7+"->QP7_ENSAIO")})
				
				If  (nPosEns == 0)
					//Armazena os Ensaios por Laboratorio no vetor aResultados                                       
					aAdd(aResultados[nPosOpe,_ENS,nPosLab],;
							   {&(cAliasOPQP7+"->QP7_SEQLAB"),;
								&(cAliasOPQP7+"->QP7_ENSAIO"),;
								&(cAliasOPQP7+"->QP1_DESCPO"),;
								Iif(&(cAliasOPQP7+"->QP1_TPCART")=="T","TMP",&(cAliasOPQP7+"->QP1_CARTA")),;
								&(cAliasOPQP7+"->QP7_LIE"),;
								&(cAliasOPQP7+"->QP7_NOMINA"),;
								&(cAliasOPQP7+"->QP7_LSE")   ,;
								QP215QtdMed(&(cAliasOPQP7+"->QP7_ENSAIO"),.T.),;
								"",;
								cSkpTst,;
								&(cAliasOPQP7+"->QP7_METODO"),;
								QA_ULTRVDC(&(cAliasOPQP7+"->QP7_METODO"),dDataBase,.F.,.F.),;
								&(cAliasOPQP7+"->QP1_DESCIN"),;
								&(cAliasOPQP7+"->QP1_DESCES"),;
								&(cAliasOPQP7+"->QP7_ENSOBR"),;
								&(cAliasOPQP7+"->QP7_PLAMO"),;
								&(cAliasOPQP7+"->QP7_CODREC"),;
								lFamVinc,;
								&(cAliasOPQP7+"->QP1_TIPO") == "C",;
								AllTrim(&(cAliasOPQP7+"->QP7_FORMUL"))})
				        
								Aadd(aResultados[nPosOpe,_MED,nPosLab],{})
								Aadd(aResultados[nPosOpe,_NCO,nPosLab],{})
								Aadd(aResultados[nPosOpe,_CRO,nPosLab],{})
								Aadd(aResultados[nPosOpe,_INS,nPosLab],{})   
								Aadd(aResultados[nPosOpe,_ANE,nPosLab],{})   
								Aadd(aResultados[nPosOpe,_LLA,nPosLab],{})  
								Aadd(aResultados[nPosOpe,_PLA,nPosLab],{})
				EndIf
					
			EndIf
				
		EndIf
			
		&(cAliasOPQP7+"->(dbSkip())")	
	EndDo   

	If lExibConout
		CONOUT("               Final Função SQL-QP215FLAB(QP7): "+DtoC(dDataBase)+"-"+Time())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta Arquivo Temporario ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasOPQP7)
	dbClearFilter()
	dbCloseArea()
	Ferase(cAliasOPQP7+GetDBExtension())
	FErase(cAliasOPQP7+OrdBagExt())	
	
	If lExibConout
		CONOUT("               Inicio Função SQL - QP215FLAB(QP8): "+DtoC(dDataBase)+"-"+Time())
	EndIf

	BeginSql Alias cAliasOPQP7
	
		SELECT    QP8.QP8_PRODUT,   QP8.QP8_REVI, QP8.QP8_CODREC, QP8.QP8_OPERAC, QP8.QP8_LABOR , 
				  QP8.QP8_ENSAIO, QP8.QP8_SEQLAB, QP8.QP8_ENSAIO, QP8.QP8_METODO, QP8.QP8_ENSOBR, 
				  QP8.QP8_PLAMO ,  QP8.QP8_TEXTO, QP1.QP1_DESCPO, QP1.QP1_TPCART,  QP1.QP1_CARTA, 
				  QP1.QP1_DESCIN, QP1.QP1_DESCES,   QP1.QP1_TIPO,  QQ1.QQ1_INSTR,  QQ1.QQ1_DESCR, 
				  QQK.QQK_DESCRI,  QQK.QQK_SETUP, QQK.QQK_TEMPAD, QQK.QQK_OPE_OB, QQK.QQK_SEQ_OB, 
				  QQK.QQK_LAU_OB,  QQK.QQK_CHAVE, QQ7.QQ7_CLIENT,   QQ7.QQ7_LOJA  
		FROM	  %table:QP1% QP1, %table:QQK% QQK, %table:QP8% QP8
		LEFT JOIN %table:QQ1% QQ1 
		       ON QQ1.QQ1_PRODUT = QP8.QP8_PRODUT		AND
				  QQ1.QQ1_REVI   = QP8.QP8_REVI			AND
				  QQ1.QQ1_ROTEIR = QP8.QP8_CODREC		AND
				  QQ1.QQ1_OPERAC = QP8.QP8_OPERAC		AND
				  QQ1.QQ1_ENSAIO = QP8.QP8_ENSAIO  		AND
				  QQ1.%notDel%
		LEFT JOIN %table:QQ7% QQ7 
		       ON QQ7.QQ7_PRODUT = QP8.QP8_PRODUT		AND
		          QQ7.QQ7_LABOR  = QP8.QP8_LABOR		AND
		          QQ7.QQ7_ENSAIO = QP8.QP8_ENSAIO		AND
		          QQ7.QQ7_CODREC = QP8.QP8_CODREC		AND
                  QQ7.QQ7_OPERAC = QP8.QP8_OPERAC		AND
   				  QQ7.%notDel%
		WHERE	  QP8.QP8_FILIAL = %xFilial:QP8%		AND
				  QP8.QP8_PRODUT = %Exp:cProduto%		AND
				  QP8.QP8_REVI   = %Exp:cRevisao%		AND
				  QP8.QP8_CODREC = %Exp:cRoteiro%		AND
  				  %Exp:cSelQQ7%
				  QP1.QP1_FILIAL = %xFilial:QP1%		AND
				  QP1.QP1_ENSAIO = QP8.QP8_ENSAIO		AND
				  QQK.QQK_FILIAL = QP8.QP8_FILIAL       AND
				  QQK.QQK_PRODUT = QP8.QP8_PRODUT		AND
				  QQK.QQK_REVIPR = QP8.QP8_REVI		    AND
				  QQK.QQK_CODIGO = QP8.QP8_CODREC		AND
				  QQK.QQK_OPERAC = QP8.QP8_OPERAC		AND
				  QP1.%notDel% AND
				  QP8.%notDel% AND
				  QQK.%notDel% 
		ORDER BY  QP8.QP8_PRODUT, QP8.QP8_REVI, QP8.QP8_CODREC, QP8.QP8_OPERAC, QP8.QP8_SEQLAB
	
	EndSql	

	While &(cAliasOPQP7+"->(!Eof())")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ExistBlock("QP215J3")	
			lOperaOk := ExecBlock("QP215J3",.F.,.F.,{&(cAliasOPQP7+"->QP8_CODREC"),&(cAliasOPQP7+"->QP8_OPERAC"),&(cAliasOPQP7+"->QP8_LABOR"),&(cAliasOPQP7+"->QP8_ENSAIO"),"QP8"})
		Endif                                                      
				
		If lOperaOk
			
			If Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP8_OPERAC")}) == 0  			
	         	If !lLayout
	            	If Len(aResultados) == 1
						cOper := &(cAliasOPQP7+"->QP8_OPERAC")
					EndIf
	
					Aadd(aResultados,{&(cAliasOPQP7+"->QP8_OPERAC"),{},{},{},{},{},{},{},{},{},"",{},{}})     
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aOperacoes,{QPK->QPK_OP,;
									 &(cAliasOPQP7+"->QP8_OPERAC"),;
									 &(cAliasOPQP7+"->QQK_DESCRI"),;
									 Alltrim(Str(&(cAliasOPQP7+"->QQK_SETUP" ))),;
									 Alltrim(Str(&(cAliasOPQP7+"->QQK_TEMPAD"))),;
							     	 &(cAliasOPQP7+"->QQK_OPE_OB"),;
							     	 &(cAliasOPQP7+"->QQK_SEQ_OB"),;
							     	 &(cAliasOPQP7+"->QQK_LAU_OB")})
	         	Else
 					Aadd(aResultados,{&(cAliasOPQP7+"->QP8_OPERAC"),{},{},{},{},{},{},{},{},{},QA_RecTxt(&(cAliasOPQP7+"->QQK_CHAVE"),cEspObsOpe,00,,"QA2",{}),QP215Rastro(&(cAliasOPQP7+"->QP8_OPERAC")),{}})     
	
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					AADD(aOperacoes,{hVZ,;
									 hVZ,;
									 hVZ,;
									 &(cAliasOPQP7+"->QP8_OPERAC"),;
									 &(cAliasOPQP7+"->QQK_DESCRI"),;
					  				 Alltrim(Str(&(cAliasOPQP7+"->QQK_SETUP" ))),;
					  				 Alltrim(Str(&(cAliasOPQP7+"->QQK_TEMPAD"))),;
					  		     	 &(cAliasOPQP7+"->QQK_OPE_OB"),;
							     	 &(cAliasOPQP7+"->QQK_SEQ_OB"),;
							     	 &(cAliasOPQP7+"->QQK_LAU_OB")})
	         	EndIf
			    
				nPosOpe := Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP8_OPERAC")})
				Aadd(aResultados[nPosOpe,_LAB],&(cAliasOPQP7+"->QP8_LABOR"))
				Aadd(aResultados[nPosOpe,_ENS],{})
				Aadd(aResultados[nPosOpe,_MED],{})
				Aadd(aResultados[nPosOpe,_NCO],{})
				Aadd(aResultados[nPosOpe,_CRO],{})
				Aadd(aResultados[nPosOpe,_INS],{})   
				Aadd(aResultados[nPosOpe,_ANE],{})   
				Aadd(aResultados[nPosOpe,_LLA],{})  
				Aadd(aResultados[nPosOpe,_PLA],{})  
				nQtdOpe ++ 
			Else
				nPosOpe := Ascan(aResultados,{|x|x[_OPE]==&(cAliasOPQP7+"->QP8_OPERAC")})
				If Ascan(aResultados[nPosOpe,_LAB],{|x|x==&(cAliasOPQP7+"->QP8_LABOR")}) == 0  
					Aadd(aResultados[nPosOpe,_LAB],&(cAliasOPQP7+"->QP8_LABOR"))
					Aadd(aResultados[nPosOpe,_ENS],{})
					Aadd(aResultados[nPosOpe,_MED],{})
					Aadd(aResultados[nPosOpe,_NCO],{})
					Aadd(aResultados[nPosOpe,_CRO],{})
					Aadd(aResultados[nPosOpe,_INS],{})   
					Aadd(aResultados[nPosOpe,_ANE],{})   
					Aadd(aResultados[nPosOpe,_LLA],{})   
					Aadd(aResultados[nPosOpe,_PLA],{})  
				EndIf
			EndIf

			cSkpTst := QP215SkpT(&(cAliasOPQP7+"->QP8_ENSAIO"),&(cAliasOPQP7+"->QP8_OPERAC")) 
			
			//Preenche o aResultados com os Ensaios Vinculados ao Laboratorio
			nPosLab := Ascan(aResultados[nPosOpe,_LAB],{|x|x==&(cAliasOPQP7+"->QP8_LABOR")})
			If (nPosLab > 0)
				lFamVinc := !Empty(AllTrim(&(cAliasOPQP7+"->QQ1_INSTR")))
				
				nPosEns := Ascan(aResultados[nPosOpe,_ENS,nPosLab],{|x|x[2]==&(cAliasOPQP7+"->QP8_ENSAIO")})
				
				If  (nPosEns == 0)
	
					//Armazena os Ensaios por Laboratorio no vetor aResultados                                       
					aAdd(aResultados[nPosOpe,_ENS,nPosLab],;
							   {&(cAliasOPQP7+"->QP8_SEQLAB"),;
								&(cAliasOPQP7+"->QP8_ENSAIO"),;
								&(cAliasOPQP7+"->QP1_DESCPO"),;
								Iif(&(cAliasOPQP7+"->QP1_TPCART")=="T","TMP",&(cAliasOPQP7+"->QP1_CARTA")),;
								"N/A",;
								"N/A",;
								"N/A",;
								QP215QtdMed(&(cAliasOPQP7+"->QP8_ENSAIO"),.T.),;
								&(cAliasOPQP7+"->QP8_TEXTO"),;
								cSkpTst,;
								&(cAliasOPQP7+"->QP8_METODO"),;
								QA_ULTRVDC(&(cAliasOPQP7+"->QP8_METODO"),dDataBase,.F.,.F.),;
								&(cAliasOPQP7+"->QP1_DESCIN"),;
								&(cAliasOPQP7+"->QP1_DESCES"),;
								&(cAliasOPQP7+"->QP8_ENSOBR"),;
								&(cAliasOPQP7+"->QP8_PLAMO"),;
								&(cAliasOPQP7+"->QP8_CODREC"),;
								lFamVinc,;
								&(cAliasOPQP7+"->QP1_TIPO") == "C",;
								""})
				        
								Aadd(aResultados[nPosOpe,_MED,nPosLab],{})
								Aadd(aResultados[nPosOpe,_NCO,nPosLab],{})
								Aadd(aResultados[nPosOpe,_CRO,nPosLab],{})
								Aadd(aResultados[nPosOpe,_INS,nPosLab],{})   
								Aadd(aResultados[nPosOpe,_ANE,nPosLab],{})   
								Aadd(aResultados[nPosOpe,_LLA,nPosLab],{})  
								Aadd(aResultados[nPosOpe,_PLA,nPosLab],{})
				EndIf
					
			EndIf
				
		EndIf
			
		&(cAliasOPQP7+"->(DBSkip())")	
	EndDo   

	If lExibConout
		CONOUT("               Final Função SQL-QP215FLAB(QP8): "+DtoC(dDataBase)+"-"+Time())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Deleta Arquivo Temporario ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasOPQP7)
	dbClearFilter()
	dbCloseArea()
	Ferase(cAliasOPQP7+GetDBExtension())
	FErase(cAliasOPQP7+OrdBagExt())	
Else
#ENDIF	
	If lExibConout
		CONOUT("               Inicio Função QP215FLAB(QP7&QP8): "+DtoC(dDataBase)+"-"+Time())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona o registro na Especificacao do Produto			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QP6")
	dbSetOrder(1)                               
	MsSeek(xFilial("QP6")+cProduto+Inverte(cRevisao))
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ensaios Mensuraveis											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP7->(dbSetOrder(1))
	If QP7->(MsSeek(xFilial("QP7")+cProduto+cRevisao+cRoteiro))
		While QP7->(!Eof()) .And. (QP7->QP7_FILIAL+QP7->QP7_PRODUT+QP7->QP7_REVI+QP7->QP7_CODREC) ==;
			(xFilial("QP7")+cProduto+cRevisao+cRoteiro)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cIPClient)
				QQ7->(dbSetOrder(1))
				If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + cIPClient + cIPLoj + ;
					QP7->QP7_LABOR + QP7->QP7_ENSAIO + QP7->QP7_CODREC+QP7->QP7_OPERAC))
					QP7->(dbSkip())
					Loop
				EndIf
			EndIf
			
			cSkpTst := QP215SkpT(QP7->QP7_ENSAIO,QP7->QP7_OPERAC) 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("QP215J3")	
				lOperaOk := ExecBlock("QP215J3",.F.,.F.,{QP7->QP7_CODREC,QP7->QP7_OPERAC,QP7->QP7_LABOR,QP7->QP7_ENSAIO,"QP7"})
			Endif
			
			If lOperaOk
	
				//Preenche o aResultados com a Operacao
				If Ascan(aResultados,{|x|x[_OPE]==QP7->QP7_OPERAC}) == 0  
			    
					dbSelectArea("QQK")   
					dbSetOrder(1)
					dbSeek(xFilial("QQK")+QPK->QPK_PRODUT+QPK->QPK_REVI+cRoteiro+QP7->QP7_OPERAC)
	    	           
	    			If lLayout
						Aadd(aResultados,{QP7->QP7_OPERAC,{},{},{},{},{},{},{},{},{},QA_RecTxt(QQK->QQK_CHAVE,cEspObsOpe,00,,"QA2",{}),QP215Rastro(QP7->QP7_OPERAC),{}})     
	
	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AADD(aOperacoes,{hVZ,;
										 hVZ,;
										 hVZ,;
										 QQK->QQK_OPERAC,QQK->QQK_DESCRI,Alltrim(Str(QQK->QQK_SETUP)),Alltrim(Str(QQK->QQK_TEMPAD));
								     	,QQK->QQK_OPE_OB,QQK->QQK_SEQ_OB,QQK->QQK_LAU_OB})
					Else
	                    If Len(aResultados) == 1
							cOper := QP7->QP7_OPERAC 
						EndIf
	
				
						Aadd(aResultados,{QP7->QP7_OPERAC,{},{},{},{},{},{},{},{},{},"",{},{}})     
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AADD(aOperacoes,{QPK->QPK_OP,;
										 QQK->QQK_OPERAC,;
										 QQK->QQK_DESCRI,;
										 Alltrim(Str(QQK->QQK_SETUP)),;
										 Alltrim(Str(QQK->QQK_TEMPAD)),;
								     	 QQK->QQK_OPE_OB,;
								     	 QQK->QQK_SEQ_OB,;
								     	 QQK->QQK_LAU_OB})
					Endif	   				
					nPosOpe := Ascan(aResultados,{|x|x[_OPE]==QP7->QP7_OPERAC})
					Aadd(aResultados[nPosOpe,_LAB],QP7->QP7_LABOR)
					Aadd(aResultados[nPosOpe,_ENS],{})
					Aadd(aResultados[nPosOpe,_MED],{})
					Aadd(aResultados[nPosOpe,_NCO],{})
					Aadd(aResultados[nPosOpe,_CRO],{})
					Aadd(aResultados[nPosOpe,_INS],{})   
					Aadd(aResultados[nPosOpe,_ANE],{})   
					Aadd(aResultados[nPosOpe,_LLA],{})  
					Aadd(aResultados[nPosOpe,_PLA],{})  
					nQtdOpe ++ 
				Else     
			
					nPosOpe := Ascan(aResultados,{|x|x[_OPE]==QP7->QP7_OPERAC})
					If Ascan(aResultados[nPosOpe,_LAB],{|x|x==QP7->QP7_LABOR}) == 0  
					
						Aadd(aResultados[nPosOpe,_LAB],QP7->QP7_LABOR)
						Aadd(aResultados[nPosOpe,_ENS],{})
						Aadd(aResultados[nPosOpe,_MED],{})
						Aadd(aResultados[nPosOpe,_NCO],{})
						Aadd(aResultados[nPosOpe,_CRO],{})
						Aadd(aResultados[nPosOpe,_INS],{})   
						Aadd(aResultados[nPosOpe,_ANE],{})   
						Aadd(aResultados[nPosOpe,_LLA],{})   
						Aadd(aResultados[nPosOpe,_PLA],{})  
					EndIF	
				EndIf	
	        
				//Preenche o aResultados com os Ensaios Vinculados ao Laboratorio
				nPosLab := Ascan(aResultados[nPosOpe,_LAB],{|x|x==QP7->QP7_LABOR})
				If (nPosLab > 0)
					lInspeciona := .T.                        
				
	       		     If lInspeciona
	    				QP1->(dbSetOrder(1))
						If QP1->(MsSeek(xFilial("QP1")+QP7->QP7_ENSAIO))		
	       	                
	       	                lFamVinc := .F.
	       	                
							dbSelectArea("QQ1")
							dbSetOrder(3)
							If dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+QP7->QP7_REVI+QP7->QP7_CODREC+QP7->QP7_OPERAC+QP7->QP7_ENSAIO)
								lFamVinc := .T.
					        EndIf
							
							//Armazena os Ensaios por Laboratorio no vetor aResultados                                       
							Aadd(aResultados[nPosOpe,_ENS,nPosLab],{QP7->QP7_SEQLAB,QP7->QP7_ENSAIO,QP1->QP1_DESCPO,IIF(QP1->QP1_TPCART=="T","TMP",QP1->QP1_CARTA),QP7->QP7_LIE,;
								QP7->QP7_NOMINA,QP7->QP7_LSE,QP215QtdMed(QP7->QP7_ENSAIO),"",cSkpTst,QP7->QP7_METODO,QA_ULTRVDC(QP7->QP7_METODO,dDataBase,.F.,.F.),QP1->QP1_DESCIN,QP1->QP1_DESCES,QP7->QP7_ENSOBR,QP7->QP7_PLAMO,QP7->QP7_CODREC,lFamVinc,QP1->QP1_TIPO == "C",AllTrim(QP7->QP7_FORMUL)})
					        
							Aadd(aResultados[nPosOpe,_MED,nPosLab],{})
							Aadd(aResultados[nPosOpe,_NCO,nPosLab],{})
							Aadd(aResultados[nPosOpe,_CRO,nPosLab],{})
							Aadd(aResultados[nPosOpe,_INS,nPosLab],{})   
							Aadd(aResultados[nPosOpe,_ANE,nPosLab],{})   
							Aadd(aResultados[nPosOpe,_LLA,nPosLab],{})  
							Aadd(aResultados[nPosOpe,_PLA,nPosLab],{})
							
	//						If QP1->QP1_TIPO=="C"
	//							lECalc := .T.
	//						EndIf
				   		EndIf	
	   		        EndIf     
				EndIf
			
			EndIF
			QP7->(dbSkip())	
		EndDo   
	EndIf	   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ensaios Textos												 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP8->(dbSetOrder(1))
	If QP8->(MsSeek(xFilial("QP8")+cProduto+cRevisao+cRoteiro))
		While QP8->(!Eof()) .And. (QP8->QP8_FILIAL+QP8->QP8_PRODUT+QP8->QP8_REVI+QP8->QP8_CODREC) ==;
			(xFilial("QP8")+cProduto+cRevisao+cRoteiro)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe a amarracao do Produto x Cliente - QQ7     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(cIPClient)
				QQ7->(dbSetOrder(1))
				If 	!QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + cIPClient + cIPLoj + ;
					QP8->QP8_LABOR + QP8->QP8_ENSAIO + QP8->QP8_CODREC+QP8->QP8_OPERAC))
					QP8->(dbSkip())
					Loop
				EndIf
			EndIf
			
			cSkpTst := QP215SkpT(QP8->QP8_ENSAIO,QP8->QP8_OPERAC) 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("QP215J3")
				lOperaOk := ExecBlock("QP215J3",.F.,.F.,{QP8->QP8_CODREC,QP8->QP8_OPERAC,QP8->QP8_LABOR,QP8->QP8_ENSAIO,"QP8"})
			Endif
			
			If lOperaOk
				
				dbSelectArea("QQK")
				dbSetOrder(1)
				dbSeek(xFilial("QQK")+QPK->QPK_PRODUT+QPK->QPK_REVI+cRoteiro+QP8->QP8_OPERAC)
				
				//Preenche o aResultados com a Operacao
				If Ascan(aResultados,{|x|x[_OPE]==QP8->QP8_OPERAC}) == 0
	    			If lLayout
						Aadd(aResultados,{QP8->QP8_OPERAC,{},{},{},{},{},{},{},{},{},QA_RecTxt(QQK->QQK_CHAVE,cEspObsOpe,00,,"QA2",{}),QP215Rastro(QP8->QP8_OPERAC),{}})
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AADD(aOperacoes,{hVZ,;
										 hVZ,;
										 hVZ,;
										 QQK->QQK_OPERAC,QQK->QQK_DESCRI,Alltrim(Str(QQK->QQK_SETUP)),Alltrim(Str(QQK->QQK_TEMPAD));
								     	,QQK->QQK_OPE_OB,QQK->QQK_SEQ_OB,QQK->QQK_LAU_OB})
	   			    Else
	                    If Len(aResultados) == 1
							cOper := QP7->QP7_OPERAC 
						EndIf
					
						Aadd(aResultados,{QP8->QP8_OPERAC,{},{},{},{},{},{},{},{},{},"",{},{}})
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ MUDAR: Tira Revisao do QPK e pegar da revisao do produto     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						AADD(aOperacoes,{QPK->QPK_OP,;
										 QQK->QQK_OPERAC,;
										 QQK->QQK_DESCRI,;
										 Alltrim(Str(QQK->QQK_SETUP)),;
										 Alltrim(Str(QQK->QQK_TEMPAD)),;
								     	 QQK->QQK_OPE_OB,;
								     	 QQK->QQK_SEQ_OB,;
								     	 QQK->QQK_LAU_OB})   			    
					EndIf			
					nPosOpe := Ascan(aResultados,{|x|x[_OPE]==QP8->QP8_OPERAC})
					Aadd(aResultados[nPosOpe,_LAB],QP8->QP8_LABOR)
					Aadd(aResultados[nPosOpe,_ENS],{})
					Aadd(aResultados[nPosOpe,_MED],{})
					Aadd(aResultados[nPosOpe,_NCO],{})
					Aadd(aResultados[nPosOpe,_CRO],{})
					Aadd(aResultados[nPosOpe,_INS],{})
					Aadd(aResultados[nPosOpe,_ANE],{})
					Aadd(aResultados[nPosOpe,_LLA],{})
					Aadd(aResultados[nPosOpe,_PLA],{})  
					nQtdOpe ++
				Else
					
					nPosOpe := Ascan(aResultados,{|x|x[_OPE]==QP8->QP8_OPERAC})
					If Ascan(aResultados[nPosOpe,_LAB],{|x|x==QP8->QP8_LABOR}) == 0
						
						Aadd(aResultados[nPosOpe,_LAB],QP8->QP8_LABOR)
						Aadd(aResultados[nPosOpe,_ENS],{})
						Aadd(aResultados[nPosOpe,_MED],{})
						Aadd(aResultados[nPosOpe,_NCO],{})
						Aadd(aResultados[nPosOpe,_CRO],{})
						Aadd(aResultados[nPosOpe,_INS],{})
						Aadd(aResultados[nPosOpe,_ANE],{})
						Aadd(aResultados[nPosOpe,_LLA],{})
						Aadd(aResultados[nPosOpe,_PLA],{})  
					EndIF
				EndIf
				
				//Preenche o aResultados com os Ensaios Vinculados ao Laboratorio
				nPosLab := Ascan(aResultados[nPosOpe,_LAB],{|x|x==QP8->QP8_LABOR})
				If (nPosLab > 0)
					lInspeciona := .T.
					
					If lInspeciona
						QP1->(dbSetOrder(1))
						If QP1->(MsSeek(xFilial("QP1")+QP8->QP8_ENSAIO))
							lFamVinc := .F.
							
							dbSelectArea("QQ1")
							dbSetOrder(3)
							If dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+QP8->QP8_REVI+QP8->QP8_CODREC+QP8->QP8_OPERAC+QP8->QP8_ENSAIO)
								lFamVinc := .T.
							EndIf
	
							//Armazena os Ensaios por Laboratorio no vetor aResultados
							Aadd(aResultados[nPosOpe,_ENS,nPosLab],{QP8->QP8_SEQLAB,QP8->QP8_ENSAIO,QP1->QP1_DESCPO,;
								IIF(!Empty(QP1->QP1_CARTA),IIF(QP1->QP1_TPCART=="T","TMP",QP1->QP1_CARTA),"TXT"),"N/A","N/A","N/A",QP215QtdMed(QP8->QP8_ENSAIO),QP8->QP8_TEXTO,;
								cSkpTst,QP8->QP8_METODO,QA_ULTRVDC(QP8->QP8_METODO,DDATABASE,.F.,.F.),QP1->QP1_DESCIN,QP1->QP1_DESCES,QP8->QP8_ENSOBR,QP8->QP8_PLAMO,QP8->QP8_CODREC,lFamVinc,QP1->QP1_TIPO == "C",AllTrim(QP7->QP7_FORMUL) })
	
							Aadd(aResultados[nPosOpe,_MED,nPosLab],{})
							Aadd(aResultados[nPosOpe,_NCO,nPosLab],{})
							Aadd(aResultados[nPosOpe,_CRO,nPosLab],{})
							Aadd(aResultados[nPosOpe,_INS,nPosLab],{})
							Aadd(aResultados[nPosOpe,_ANE,nPosLab],{})
							Aadd(aResultados[nPosOpe,_LLA,nPosLab],{})
							Aadd(aResultados[nPosOpe,_PLA,nPosLab],{})  
						EndIf
					EndIf
				EndIf
			EndIF
			QP8->(dbSkip())
		EndDo
	EndIf
	If lExibConout
		CONOUT("               Final Função QP215FLAB(QP7&QP8): "+DtoC(dDataBase)+"-"+Time())
	EndIf
#IFDEF TOP
EndIf
#ENDIF	     

If Len(aResultados) == 0
	MsgAlert(STR0218) //"Nao existem ensaios definidos para essa Especificação."
	Return(.F.)
EndIf     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena as arrays de aResultados e aOperacoes				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aSort(aResultados,,,{|x,y|x[1]<y[1]})
If lLayout
	aSort(aOperacoes,,,{|x,y|x[4]<y[4]})
Else
	aSort(aOperacoes,,,{|x,y|x[2]<y[2]})                                 
EndIf

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Este ponto de entrada  tem o Objetivo de retirar do aOperacoes as  operações  que não farão parte deste Laudo.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
If !lLayout .AND. ExistBlock("QP215J25")	
	aOperaAnte := aClone(aOperacoes)
	aOperacoes := ExecBlock("QP215J25",.F.,.F.,{QPK->QPK_OP, QPK->QPK_PRODUT, QPK->QPK_REVI, aOperacoes})
    
    nTam := Iif(Len(aOperacoes)>Len(aOperaAnte), Len(aOperacoes), Len(aOperaAnte))
	nY := 1
	While .T.
		If nY > nTam
			Exit
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha sido retirado do aOperações retiro do aResultados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If aScan(aOperacoes,{|x| Iif(nY <= Len(aOperaAnte), x[2] == aOperaAnte[nY,2], .F.)}) <= 0
       		nPos := aScan(aResultados,{|x| x[1] == aOperaAnte[nY,2]})
       		aDel(aResultados,nPos)
	      	aSize(aResultados,Len(aResultados)-1)
      	EndIf

      	nY++
	EndDo

	nY := 1
	While .T.
		If nY > nTam
			Exit
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso tenha sido inserido no aOperações não permito          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      	If aScan(aOperaAnte,{|x| Iif(nY <= Len(aOperacoes), x[2] == aOperacoes[nY,2], .F.)}) < 1
      		If nY <= Len(aOperacoes)
      			nPos := aScan(aOperacoes,{|x| x[2] == aOperacoes[nY,2]})  // Caso ache
	       		aDel(aOperacoes,nPos)
		      	aSize(aOperacoes,Len(aOperacoes)-1)
			EndIf
      		//MsgAlert("Arrumar")
        EndIf
        
      	nY++
	EndDo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena as arrays de aResultados e aOperacoes				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aResultados,,,{|x,y|x[1]<y[1]})
	If lLayout
		aSort(aOperacoes,,,{|x,y|x[4]<y[4]})
	Else
		aSort(aOperacoes,,,{|x,y|x[2]<y[2]})                                 
	EndIf
	
	nQtdOpe := Len(aOperacoes)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Mantem no aOperacoes e no aResultados somente a primeira Operacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lCarOtm //Indica uma carga otimizada dos dados no aResultados
    
    // Guardo o aOperacoes completo
    aOperaFull := aClone(aOperacoes)                
    aResulFull := aClone(aResultados)
    
	If aScan(aOperaFull,{|x| x[2] == c220OPER}) > 0
		If !lCPrimOP
			aOperacoes  := {}
			aResultados := {}
		EndIf
		lVerif  := Q216VNCAR(0, aScan(aOperaFull,{|x| x[2] == c220OPER}), .F.)
		If !lVerif
			If nPriposs > 0
				nPosDes  := nPriposs // Seto a Primeira operação possivel
				cOper 	 := aOperaFull[nPriposs,2]
				c220OPER := cOper
				cOperCar := cOper
				lVerif   := .T.
			EndIf
			nPriposs := 0
		EndIf
		If !lCPrimOP
	    	aOperacoes  := aClone(aOperaFull)                
		    aResultados := aClone(aResulFull)
		EndIf
	EndIf
	If !lVerif
		cOperCar := aOperaFull[1,2] 
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retiro do aOperacoes o que nao quero deixando ou a  primeira  ou a operação selecionada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aOperSel) > 0 .OR. !Empty(AlltRIM(cOperCar))
		If !Empty(AllTrim(cOperCar)) // Carga de dados via  Operação rápida
			nPos := aScan(aOperacoes,{|x| x[2] == cOperCar})
		ElseIf Len(aOperSel) > 0
			nPos := aScan(aOperacoes,{|x| x[2] == aOperSel[2]})
		EndIf
		aOperAnte  := aClone(aOperacoes)   
		If nPos > 0        
			aOperacoes := {}
			For nY := Len(aOperAnte) To 1 step -1       
				If nY == nPos
					aAdd(aOperacoes, aOperAnte[nY])	
				Else
					aDel(aResultados,nY)
					aSize(aResultados,Len(aResultados)-1)		
				EndIf
			Next    
		Else // Caso não encontre carrego a primeira  operação
		
            MsgAlert("A Operação informada não esta correta, a primeira Operação da especificação será carregada!",STR0093)
		
			While .T.
				If Len(aOperacoes) == 1
					Exit
				EndIf
				
				nPos := 2
				
		    	aDel(aOperacoes,nPos)
			    aSize(aOperacoes,Len(aOperacoes)-1)
			    
		    	aDel(aResultados,nPos)
			    aSize(aResultados,Len(aResultados)-1)
	
			EndDo
	
		EndIf
	Else
		While .T.
			If Len(aOperacoes) == 1
				Exit
			EndIf
			
			nPos := 2
			
	    	aDel(aOperacoes,nPos)
		    aSize(aOperacoes,Len(aOperacoes)-1)
		    
	    	aDel(aResultados,nPos)
		    aSize(aResultados,Len(aResultados)-1)

		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena as arrays de aResultados e aOperacoes após a regularização ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aSort(aResultados,,,{|x,y|x[1]<y[1]})
	If lLayout
		aSort(aOperacoes,,,{|x,y|x[4]<y[4]})
	Else
		aSort(aOperacoes,,,{|x,y|x[2]<y[2]})                                 
	EndIf
EndIf

If lExibConout
	CONOUT("               Inicio Função Carga Dados - QP215COPE: "+DtoC(dDataBase)+"-"+Time())
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o aResultados com base no aOperaçoes    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP215COPE(cProduto, cRevisao, aTitPag, nOpc)
If lExibConout
	CONOUT("               Final  Função Carga Dados - QP215COPE: "+DtoC(dDataBase)+"-"+Time())
EndIf


RestArea(aAreaQP7)   
RestArea(aAreaQP8)   
RestArea(aAreaAnt)     

nQtdOpe := Len(aOperacoes)
Return(lFilLab)                                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215COPE ºAutor  ³ Cicero Cruz        º Data ³  23/01/2009 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega os dados de uma operacao com base no aOperacoes     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215COPE(cProduto, cRevisao, aTitPag, nOpc, nOpeCarr, nTipM)

Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nPos       := 0                                        
Local aColsLab   := {} 
Local aColsEns   := {} 
Local aColsNCs   := {}
Local aColsIns   := {}
Local aColsAne   := {}
Local aLauAnt    := {}
Local aLauLab    := {}
Local aLauGer    := {}
Local nPosChvQPR
Local nPosChvNco      
Local cSeek      := ""
Local nLab       := 0
Local nMed       := 0
Local nNco       := 0
Local nIns       := 0
Local aNco       := {}
Local cTitLab    := ""
Local nPosLet    := 0
Local cTeclas    := "OLGURNIB"
Local cSkpTst 
Local lFilLab    := .T.
Local nY         := 0    
Local lOperaOk   := .T.
Local nTotResu   := 0
Local nPosOpe //Posicao da Operacao Corrente
Local nPosLabi //Posicao do Laboratorio corrente
Local nPosEnsa //Posicao do Ensaio corrente      
               
//Variaveis utilizadas para iniciar campos no Laudo do Laboratorio
Local nPosDtEnLa := 0
Local nPosHrEnLa := 0
Local nPosTamLot := 0
Local nPosDtaLau := 0
Local nPosValLau := 0

//Variaveis utilizadas para iniciar campos no Laudo da Operacao
Local nPosDtEnOp := 0
Local nPosHrEnOp := 0
Local nTamLotOP  := 0
Local nDtaLauOP  := 0
Local nValLauOP  := 0
Local xRetorno            
Local lCarOtm 	 := .F.

If !lLayout
	lCarOtm := GetMv("MV_QPCAROT",.F.,"1") == "1"   // Carga Otimizada para o Layout simplificado, o valor default é carregar otimizado.
EndIf

Default nOpeCarr := 0
Default nTipM	 := 1 // 1 = Up e 2 =Down

//Variaveis utilizadas para iniciar campos no Laudo do Laboratorio
nPosDtEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTENLA"})
nPosHrEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_HRENLA"})
nPosTamLot := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_TAMLOT"}) 
nPosDtaLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTLAUD"})
nPosValLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTVAL"})  
	
//Variaveis utilizadas para iniciar campos no Laudo da Operacao
nPosDtEnOp := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTENLA"})
nPosHrEnOp := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_HRENLA"})
nTamLotOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_TAMLOT"})
nDtaLauOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTLAUD"})
nValLauOP  := Ascan(aCpoLOP[1],{|x|AllTrim(x)=="QPM_DTVAL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ordena as posições da sequencia dos ensaios nos Laboratorios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTotResu    := Iif(nOpeCarr==0,Len(aResultados),nOpeCarr) 
For nPosOpe := Iif(nOpeCarr==0,1,nOpeCarr) to nTotResu
	If lLayout
		Aadd(aSavHeadEns,{})  
	ElseIf !lLayout /*.AND. nTipM == 1
		Aadd(aSavHeadEns,{}) 
		ElseIf !lLayout .AND. nTipM == 2*/
		//Aadd(aSavHeadEns,{}) 
		If Len(aSavHeadEns) >= 1 .AND. lCarOtm
			aSavHeadBkp	:= aClone(aSavHeadEns) 
			aSavHeadEns := {}
			nY := 1
			While nY <= Len(aSavHeadBkp)+1
				If nY > Len(aSavHeadBkp) .AND. nY == nOpeCarr
					aAdd(aSavHeadEns,{})
				ElseIf nY == nOpeCarr .AND. nY <= Len(aSavHeadBkp)
				    aAdd(aSavHeadEns,{})
				    aAdd(aSavHeadEns,aSavHeadBkp[nY])
				ElseIf nY <= Len(aSavHeadBkp)
					aAdd(aSavHeadEns,aSavHeadBkp[nY])  
				EndIf
				nY++
			EndDo
		Else 
			Aadd(aSavHeadEns,{}) 
		EndIf
	EndIf

	//Cria as posicoes no vetor que armazena os titulos do Laboratorio
	Aadd(aTitPag,{})
	For nPosLabi := 1 to Len(aResultados[nPosOpe,_LAB])
		aSort(aResultados[nPosOpe,_ENS,nPosLabi],,,{|x,y|x[1]<y[1]})	
		Aadd(aSavHeadEns[nPosOpe],{}) 
		
		If Ascan(aTitPag[nPosOpe],{|x| x[2]==Upper(aResultados[nPosOpe,_LAB,nPosLabi])}) == 0
				
			//Captura as teclas de atalho no Folder
			cTitLab := AllTrim(aResultados[nPosOpe,_LAB,nPosLabi])
			For nPosLet := 1 to Len(cTitLab)
				If At("&",cTitLab) == 0
					If At(SubStr(cTitLab,nPosLet,1),cTeclas) == 0
						cTeclas += SubStr(cTitLab,nPosLet,1)
						cTitLab := Stuff(cTitLab,nPosLet,0,"&")
					EndIf
				EndIf
			Next
			Aadd(aTitPag[nPosOpe],{cTitLab,Upper(aResultados[nPosOpe,_LAB,nPosLabi])})
		EndIf
	
	Next nPosLabi
Next nPosOpe

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Associacao das Medicoes, Nao-conformidades, Cronicas e Ins-  ³
//³ trumentos ao Vetor aResultados, para edicao dos mesmos.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPosOpe := Iif(nOpeCarr==0,1,nOpeCarr) to nTotResu

	If lExibConout
		CONOUT("               Inicio Carga Dados Laboratório: "+DtoC(dDataBase)+"-"+Time())
	EndIf

	For nPosLabi := 1 to Len(aResultados[nPosOpe,_LAB])

		If lExibConout
			CONOUT("               	    Inicio Carga Ensaios: "+DtoC(dDataBase)+"-"+Time())
		EndIf
		
		For nPosEnsa := 1 to Len(aResultados[nPosOpe,_ENS,nPosLabi]) 
		
			If lExibConout
				CONOUT("               	    Inicio QP215MONPA: "+DtoC(dDataBase)+"-"+Time())
			EndIf

			//Pesquisa Plano de Amostragem dos ensaios	
			aResultados[nPosOpe,_PLA,nPosLabi,nPosEnsa] := QP215MONPA( aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ENSAIO],;
																	    aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,CARTA],;
																	    aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,PLAMO],;
																	    aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ROTEIRO],;
																	    aResultados[nPosOpe,_OPE])  
			
			If lExibConout
				CONOUT("               	    Final QP215MONPA: "+DtoC(dDataBase)+"-"+Time())
			EndIf
				
			If lExibConout
				CONOUT("               	    Inicio Carga Medicoes: "+DtoC(dDataBase)+"-"+Time())
			EndIf
			
			//Cria a posicao para as medicoes referentes ao ensaio		
			Aadd(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa],{}) 
			
			//Cria as posicoes no vetor que armazena o aHeader de acordo
			//com a carta utilizada no ensaio de cada laboratorio.
			Aadd(aSavHeadEns[nPosOpe,nPosLabi],{})
					
			//Armazena uma copia vazia do aCols no aResultados                 
			aColsEns := QP215aHeadMed(nPosOpe,nPosLabi,nPosEnsa,aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ENSAIO],aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,CARTA])
			aColsAux := aClone(aColsEns)
			
			//Preenche o aCols com as medicoes ja cadastradas
			aColsEns := QP215FILMED(cRoteiro,aResultados[nPosOpe,_OPE],aResultados[nPosOpe,_LAB,nPosLabi],aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ENSAIO],aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,CARTA])
			
			If Len(aColsEns) == 0
				aColsEns  := aClone(aColsAux)
			EndIf				                     
			//aResultados[nPosOpe,_MED,nPosLab,Len(aResultados[nPosOpe,nPosLab,_MED])] := aClone(aColsEns)
			aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa] := aClone(aColsEns)
			                     
		    //Pesquisa a Posicao do campo QPR_CHAVE no aHeader vinculado ao Laboratorio+Ensaio
			nPosChvQPR := Ascan(aSavHeadEns[nPosOpe,nPosLabi,nPosEnsa,1],{|x|AllTrim(x[2])=="QPR_CHAVE"})                
						
			//Pesquisa a chave de ligacao do Texto da Nao-conformidade (Cronica)
			nPosChvNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_CHAVE"})                

			If lExibConout
				CONOUT("               	    Final Carga Medicoes: "+DtoC(dDataBase)+"-"+Time())
			EndIf

			If lExibConout
				CONOUT("               	    Inicio NC & Instrumento: "+DtoC(dDataBase)+"-"+Time())
			EndIf
			
			For nMed := 1 to Len(aColsEns)
		
				//Cria a posicao para as nao-conformidades
				Aadd(aResultados[nPosOpe,_NCO,nPosLabi,nPosEnsa],{})                                                
						
				//Cria a posicao para as cronicas
				Aadd(aResultados[nPosOpe,_CRO,nPosLabi,nPosEnsa],{})   
			
				//Cria a posicao para os instrumentos 
				Aadd(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa],{})        

				//Preenche o aCols com as NC,s vinculadas ao Ensaio
			    aColsNCs := Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,aColsEns[nMed,nPosChvQPR],"QPU_CODMED",Len(aSavaHeader[HEAD_NCS]))
				If Len(aColsNCs) == 0 
					//Armazena uma copia vazia do aCols no aResultados
					aColsNCs := aClone(aSavaCols[HEAD_NCS])
			  		aResultados[nPosOpe,_NCO,nPosLabi,nPosEnsa,nMed] := aClone(aColsNCs)
				Else            
					//Armazena as NCs vinculadas ao Ensaio
			  		aResultados[nPosOpe,_NCO,nPosLabi,nPosEnsa,nMed] := aClone(aColsNCs)
				EndIf									
			
				//Armazena o texto da nao-conformidade
				aNco := {}					                          
				For nNco := 1 to Len(aColsNCs) 

					If lLayout
						//Cria a posicao para as cronicas
						Aadd(aResultados[nPosOpe,_CRO,nPosLabi,nPosEnsa,nMed],{})         
				        
						Aadd(aResultados[nPosOpe,_CRO,nPosLabi,nPosEnsa,nMed,nNco],QP215FilTxt(aColsNcs[nNco,nPosChvNco]))

					Else 
						If nPosChvNco == 0
							nPosChvNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_CHAVE"})
						EndIf          
						
						Aadd(aResultados[nPosOpe,_CRO,nPosLabi,nPosEnsa,nMed],{})         
				        
						Aadd(aResultados[nPosOpe,_CRO,nPosLabi,nPosEnsa,nMed,nNco],QP215FilTxt(aColsNcs[nNco,nPosChvNco]))
					
					EndIf	
		        Next nNco     
	
				//Preenche o aCols com os Instrumentos das Medicoes
		        aColsIns := Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,aColsEns[nMed,nPosChvQPR],"QPT_CODMED",Len(aSavaHeader[HEAD_INST]))
				If Len(aColsIns) == 0 
					//Armazena uma copia vazia do aCols no aResultados
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,nMed] := aClone(aSavaCols[HEAD_INST])
				Else            
					//Armazena as NCs vinculadas ao Ensaio
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,nMed] := aClone(aColsIns)
				EndIf					                      
	
			Next nMed
		    
			If lExibConout
				CONOUT("               	    Final NC & Instrumento: "+DtoC(dDataBase)+"-"+Time())
			EndIf
	
			//Adiciona os documentos anexos aos ensaios
			aColsAne := Q215FilCol(aSavaHeader[HEAD_ANEXO],"QQJ",1,aResultados[nPosOpe,_OPE]+aResultados[nPosOpe,_LAB,nPosLabi]+aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ENSAIO]+PadR(QPK->QPK_OP,13),"(QQJ_OPERAC+QQJ_LABOR+QQJ_ENSAIO+QQJ_OP)",Len(aSavaHeader[HEAD_ANEXO]))
			aResultados[nPosOpe,_ANE,nPosLabi,nPosEnsa] := If(Len(aColsAne)==0,aClone(aSavaCols[HEAD_ANEXO]),aResultados[nPosOpe,_ANE,nPosLabi,nPosEnsa] := aClone(aColsAne))

		Next nPosEnsa
	    
		If lExibConout
			CONOUT("               	    Final Carga Ensaios: "+DtoC(dDataBase)+"-"+Time())
		EndIf

		If lExibConout
			CONOUT("               	    Inicio Carga Laudo: "+DtoC(dDataBase)+"-"+Time())
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche os Laudos referentes dos Laboratorios	             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aLauLab := QP215FLAU(QPK->QPK_OP,cRoteiro,aResultados[nPosOpe,_OPE],aResultados[nPosOpe,_LAB,nPosLabi],"L")
		If Len(aLauLab)	== 0         
			//Preenche a posicao do Laudo com as variaveis default, caso nao haja laudo
			aLauLab := QP215FILENC("QPL",.F.)
                                               
			//Sugere os campos no Laudo do Laboratorio a partir da OP
			aLauLab[nPosDtEnLa] := dDataBase
			aLauLab[nPosHrEnLa] := Time()
			aLauLab[nPosTamLot] := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
		EndIf
	
		//Cria a posicao para o laudo 
		aResultados[nPosOpe,_LLA,nPosLabi] := aClone(aLauLab)
	
		//Armazena o Laudo e a Justificativa anteriores
		Aadd(aLauAnt,{aLauLab[nPosLauGer],aLauLab[nPosJusLau]})

		If lExibConout
			CONOUT("               	    Inicio Carga Laudo: "+DtoC(dDataBase)+"-"+Time())
		EndIf

	Next nPosLabi                                               
	
	If lExibConout
		CONOUT("               Final Carga Dados Laboratório: "+DtoC(dDataBase)+"-"+Time())
	EndIf

	If lExibConout
		CONOUT("               Inicio Carga Laudo Operacao: "+DtoC(dDataBase)+"-"+Time())
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche os Laudos referentes dos Laboratorios	             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aLauOpe := QP215FILLOP(QPK->QPK_OP,cRoteiro,aResultados[nPosOpe,_OPE])
	If Len(aLauOpe)	== 0         
		//Preenche a posicao do Laudo com as variaveis default, caso nao haja laudo
		aLauOpe := QP215FILENC("QPM",.F.)
                                              
		//Sugere os campos no Laudo do Laboratorio a partir da OP
		aLauOpe[nPosDtEnOp] := dDataBase
		aLauOpe[nPosHrEnOp] := Time()
		aLauOpe[nTamLotOP]  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
	EndIf
	
	//Cria a posicao para o laudo 
	aResultados[nPosOpe,_LOP] := aClone(aLauOpe)
	
	//Armazena o Laudo e a Justificativa anteriores
	Aadd(aLauAnt,{aLauLab[nPosLauGer],aLauLab[nPosJusLau]}) 
	
	If lExibConout
		CONOUT("               Final Carga Laudo Operação: "+DtoC(dDataBase)+"-"+Time())
	EndIf

Next nPosOpe

If lExibConout
	CONOUT("               Inicio Carga Laudo Geral: "+DtoC(dDataBase)+"-"+Time())
EndIf
If nOpeCarr == 0
	//Cria a posicao para o Laudo Geral
	Aadd(aResultados,{})
		
	//Caso o Laudo Geral da OP esteja preenchido carrega o mesmo para edicao
	aLauGer := QP215FLAU(QPK->QPK_OP,cRoteiro,"","","G")
	If Len(aLauGer)	== 0         
			
		//Preenche a posicao do Laudo com as variaveis default, caso nao haja laudo
		aLauGer := QP215FILENC("QPL",.F.)
			
		//Sugere os campos no Laudo Geral da OP 
		aLauGer[nPosDtEnLa] := dDataBase
		aLauGer[nPosHrEnLa] := Time()
		aLauGer[nPosTamLot] := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
		aLauGer[nPosDtaLau] := dDataBase
		aLauGer[nPosValLau] := dDataBase + QAtuShelf(QPK->QPK_PRODUT,QPK->QPK_REVI) 
			
	EndIf
		
	//Armazena o Laudo e a Justificativa anteriores
	Aadd(aLauAnt,{aLauGer[nPosLauGer],aLauGer[nPosJusLau]})
		
	//Salva a posicao do Laudo Geral da OP
	nFldLauGer := Len(aResultados)
			
	//Armazena o Laudo Geral da OP
	Aadd(aResultados[nFldLauGer],aClone(aLauGer))
Else
	aSavHeadBkp	:= aClone(aSavHeadEns)   
	
	//Salva a posicao do Laudo Geral da OP
	nFldLauGer := Len(aResultados)
	
	nQtdOpe := Len(aOperacoes)
EndIf

If lExibConout
	CONOUT("               Final Carga Laudo Geral: "+DtoC(dDataBase)+"-"+Time())
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215FILMED ³ Autor ³Cleber L. Souza      ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Preenche o vetor aResultados com as Medicoes cadastradas   ³±±
±±³			 ³ por Laboratorio.											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FILMED(EXPC1,EXPC2,EXPC3,EXPC4)						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Operacao										  	  ³±±
±±³			 ³ EXPC2 = Laboratorio		 								  ³±±
±±³			 ³ EXPC3 = Ensaio											  ³±±
±±³			 ³ EXPC4 = Carta											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Estrutura contendo as medicoes referente ao ensaio ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIEA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FILMED(cRoteiro,cOperacao,cLabor,cEnsaio,cCarta)
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aAreaAnt	:= GetArea()                      
Local aAreaQPS  := QPS->(GetArea())
Local aAreaQPQ  := QPQ->(GetArea())
Local aAreaQPR  := QPR->(GetArea())
Local nQtdMed   := 0  
Local nX        := 0 
Local lRetorno  := .F.              
Local cSeek     := ""
Local cChvMed	:= ""
Local aMed		:= {}
Local aMedicao  := {}
Local cAliasQPR := "QPR"
Local lQuery    := .F.          
Local cQuery
Local aStruQPR  
Local nPosCpo

nPosOper := Ascan(aResultados,{|x|x[_OPE] == cOperacao})       
nPosLab  := Ascan(aResultados[nPosOper,_LAB],{|x|x == cLabor})
nPosEns  := Ascan(aResultados[nPosOper,_ENS,nPosLab],{|x|x[ENSAIO] == cEnsaio})
nQtdMed	:= aResultados[nPosOper,_ENS,nPosLab,nPosEns,QTDMED]  //Define o numero de medicoes cadastradas
cSeek   := (padr(QPK->QPK_OP,TamSX3("QPR_OP")[1])+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+cOperacao+cLabor+cEnsaio)

dbSelectArea("QPR")
dbSetOrder(9)
If MsSeek(xFilial("QPR")+cSeek)

	While !Eof() .And. (xFilial("QPR")+cSeek) ==;
	  	(QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_NUMSER+QPR_ROTEIRO+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Valores das medicoes 									 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChvMed := QPR_CHAVE
		aMed    := {}			 
		
		If cCarta # "TXT"
			If cCarta == "P  "
				aMed := Afill(Array(4),0)     
				aMed[4] := " " //somente na quarta posicao
			EndIf
			QPS->(dbSetOrder(1))
			QPS->(MsSeek(xFilial("QPS")+cChvMed))
			While QPS->(!Eof()) .And.	(QPS->QPS_FILIAL+QPS->QPS_CODMED) ==;
				(xFilial("QPS")+cChvMed)
				
				If cCarta # "P  "
					Aadd(aMed,QPS->QPS_MEDICA)
				Else
					If QPS->QPS_INDMED == "A"
						aMed[1] := SuperVal(QPS->QPS_MEDICA)
					ElseIf QPS->QPS_INDMED == "N"
						aMed[2] := SuperVal(QPS->QPS_MEDICA)
						aMed[4] := "S"
					ElseIf QPS->QPS_INDMED == "P"
						aMed[3] := SuperVal(QPS->QPS_MEDICA)
					EndIf
				EndIf                    
				
				QPS->(dbSkip())
			EndDo  
			                      
			//Alimenta array com as medições em branco.
			If Len(aMed) < nQtdMed
				For nX := Len(aMed)+1 to nQtdMed
					Aadd(aMed,"0")
				Next nX
			EndIf
			                               
			If cCarta == "P  "
				If Empty(aMed[4])
					aMed[4] := "N"
					aMed[2] := 0
				Endif
			EndIf
		Else
			QPQ->(dbSetOrder(1))
			If QPQ->(MsSeek(xFilial("QPQ")+cChvMed))
				Aadd(aMed, QPQ->QPQ_MEDICA)
			EndIf				
		EndIf
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta o array das medicoes 								 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aMedicao,{})
		Aadd(aMedicao[Len(aMedicao)],QPR_DTMEDI)                                 //Data medicao
		Aadd(aMedicao[Len(aMedicao)],QPR_HRMEDI)                                 //Hora medicao
		Aadd(aMedicao[Len(aMedicao)],QPR_AMOSTR)                                 //Amostra
		Aadd(aMedicao[Len(aMedicao)],QPR_ENSR)                                   //Codigo do ensaiador
		Aadd(aMedicao[Len(aMedicao)],QA_NUSR(QPR_FILMAT,QPR_ENSR,.F.,"A"))      //Nome do Ensaiador  
		
		If cCarta == "TMP"
			Aadd(aMedicao[Len(aMedicao)],QPR_DTINI)
			Aadd(aMedicao[Len(aMedicao)],QPR_HRINI)
			Aadd(aMedicao[Len(aMedicao)],QPR_DTFIM)
			Aadd(aMedicao[Len(aMedicao)],QPR_HRFIM)
		EndIf
		
		Aeval(aMed,{|x|Aadd(aMedicao[Len(aMedicao)],x)})                        	//Medicoes
		
		Aadd(aMedicao[Len(aMedicao)],QPR_RESULT)                                 	//Resultado
		
		Aeval(aCpoUsu,{|x|Aadd(aMedicao[Len(aMedicao)],FieldGet(FieldPos(x)))}) 	//Campos Criados pelo usuario 
		
		Aadd(aMedicao[Len(aMedicao)],QPR_METODO)	                                //Chave de ligacao 
		Aadd(aMedicao[Len(aMedicao)],QPR_RVDOC)                                 	//Filial da matricula
		
		Aadd(aMedicao[Len(aMedicao)],QPR_CHAVE)	                               		//Chave de ligacao 
		Aadd(aMedicao[Len(aMedicao)],QPR_FILMAT)                               		//Filial da matricula

        If !lLayout 
			Aadd(aMedicao[Len(aMedicao)], "<Enter>")	                     		//Instrumentos 
			Aadd(aMedicao[Len(aMedicao)], "<Enter>")                            	//Filial da matricula
        EndIf

		Aadd(aMedicao[Len(aMedicao)],QPR->(Alias()))                            	//Alias
		Aadd(aMedicao[Len(aMedicao)],QPR->(RecNo()))                            	//Recno		
		Aadd(aMedicao[Len(aMedicao)],.F.)	                                	  	//Marca de delecao
		
		dbSkip()
	EndDo
	
EndIf   

//Ponto de Entrada apos carregar GetDados da Medicao.
If ExistBlock("QP215MED")
	ExecBlock("QP215MED",.F.,.F.)
Endif  
            
RestArea(aAreaQPS)
RestArea(aAreaQPQ)
RestArea(aAreaQPR)
RestArea(aAreaAnt)

Return(aMedicao)                      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Q215FilCol ³ Autor ³Cleber L. Souza		³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza o preenchimento dos dados no aCols, para as Nao-con³±±
±±³			 ³ formidades e Instrumentos associados ao Ensaio corrente    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Q215FilCol(EXPA1,EXPC1,EXPN1,EXPC2,EXPC3,EXPN2)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = aHeader do arquivo a ser criado o aCOLS        	  ³±±
±±³          ³ EXPC1 = Alias corrente        							  ³±±
±±³          ³ EXPN1 = Ordem para pesquisa dos dados         			  ³±±
±±³          ³ EXPC2 = Chave de pesquisa  								  ³±±
±±³          ³ EXPC3 = Campo a ser comparado        					  ³±±
±±³          ³ EXPN2 = nUsado          									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Estrutura do aCols 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QIPA215                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Q215FilCol(aHeadFC,cAlias,nOrder,cSeek,cCampo,nUsado)

Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aColsAux   := {}             
Local nX                 
Local cCpoGrv
Local nPosNaoCon := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_NAOCON"})
Local nPosDesNco := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_DESNCO"})
Local nPosClasse := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_CLASSE"}) 
Local nPosDesCla := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_DESCLA"}) 
Local nPosIns    := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_INSTR"})
Local nPosRvIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_REVINS"})
Local nPosDtIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_VALDAF"})
Local nPosTpIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_TIPO"})
Local nPosAli    := Ascan(aHeadFC,{|x|AllTrim(x[2])== cAlias+"_ALI_WT"})
Local nPosRec    := Ascan(aHeadFC,{|x|AllTrim(x[2])== cAlias+"_REC_WT"})

If !lLayout .AND. nUsado == 0
	aHeadFC := aClone(APBuildHeader(cAlias))
	ADHeadRec(cAlias,aHeadFC)
	nUsado := Len(aHeadFC)  
	nPosNaoCon := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_NAOCON"})
	nPosDesNco := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_DESNCO"})
	nPosClasse := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_CLASSE"}) 
	nPosDesCla := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPU_DESCLA"}) 
	nPosIns    := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_INSTR"})
	nPosRvIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_REVINS"})
	nPosDtIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_VALDAF"})
	nPosTpIns  := Ascan(aHeadFC,{|x|AllTrim(x[2])== "QPT_TIPO"})
	nPosAli    := Ascan(aHeadFC,{|x|AllTrim(x[2])== cAlias+"_ALI_WT"})
	nPosRec    := Ascan(aHeadFC,{|x|AllTrim(x[2])== cAlias+"_REC_WT"})
EndIf

dbSelectArea(cAlias)      
dbSetOrder(nOrder)
MsSeek(xFilial(cAlias)+cSeek)
While !Eof() .And. xFilial(cAlias) == &(cAlias+"_FILIAL") .And. cSeek == &(cAlias+"->"+cCampo)
    Aadd(aColsAux,Array(nUsado+1))
	For nX := 1 To Len(aHeadFC)                
  		If (aHeadFC[nX,10] # "V")
		    aColsAux[Len(aColsAux),nX] := &(FieldName(FieldPos(AllTrim(aHeadFC[nX,2]))))
  		ElseIf !(aHeadFC[nX,2] $ cAlias+"_ALI_WT"+cAlias+"_REC_WT")
  		    aColsAux[Len(aColsAux),nX] := CriaVar(AllTrim(aHeadFC[nX,2]))
  		EndIf
    Next
	If nPosAli > 0 .and. nPosRec > 0
		AcolsAux[Len(aColsAux),nPosAli] := &(cAlias+"->(Alias())")
		If IsHeadRec(aHeadFC[nPosRec,2])
			AcolsAux[Len(aColsAux),nPosRec] := &(cAlias+"->(RecNo())")
		EndIf
	Endif
    aColsAux[Len(aColsAux),Len(aHeadFC)+1] := .F.
   
 	If lLayout
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Preenche a descricao dos campos: nao-conformidade e classe³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    If cAlias == "QPU" 
	    	aColsAux[Len(aColsAux),nPosDesNco] := Posicione("SAG",1,xFilial("SAG")+aColsAux[Len(aColsAux),nPosNaoCon],"AG_DESCPO")
	    	aColsAux[Len(aColsAux),nPosDesCla] := Posicione("QEE",1,xFilial("QEE")+aColsAux[Len(aColsAux),nPosClasse],"QEE_DESCPO")	
	    ElseIf cAlias == "QPT" 
	    	aColsAux[Len(aColsAux),nPosTpIns] := Posicione("QM2",1,xFilial("QM2")+aColsAux[Len(aColsAux),nPosIns]+Inverte(aColsAux[Len(aColsAux),nPosRvIns]),"QM2_TIPO")
	    	aColsAux[Len(aColsAux),nPosDtIns] := QM2->QM2_VALDAF	
	    EndIf 
	Else
		If Len(aColsAux) >= 1 .AND. Len(aColsAux[1]) > 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Preenche a descricao dos campos: nao-conformidade e classe³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    If cAlias == "QPU" 
		    	aColsAux[Len(aColsAux),nPosDesNco] := Posicione("SAG",1,xFilial("SAG")+aColsAux[Len(aColsAux),nPosNaoCon],"AG_DESCPO")
		    	aColsAux[Len(aColsAux),nPosDesCla] := Posicione("QEE",1,xFilial("QEE")+aColsAux[Len(aColsAux),nPosClasse],"QEE_DESCPO")	
		    ElseIf cAlias == "QPT" 
		    	aColsAux[Len(aColsAux),nPosTpIns] := Posicione("QM2",1,xFilial("QM2")+aColsAux[Len(aColsAux),nPosIns]+Inverte(aColsAux[Len(aColsAux),nPosRvIns]),"QM2_TIPO")
		    	aColsAux[Len(aColsAux),nPosDtIns] := QM2->QM2_VALDAF	
		    EndIf 
		EndIf
	EndIf
		
    dbSkip()               
EndDo                     

If !lLayout .AND. Len(aColsAux) == 0
    Aadd(aColsAux,Array(nUsado+1))
	For nX := 1 To Len(aHeadFC)                
  		If (aHeadFC[nX,10] # "V")
		    aColsAux[Len(aColsAux),nX] := &(FieldName(FieldPos(AllTrim(aHeadFC[nX,2]))))
  		ElseIf !(aHeadFC[nX,2] $ cAlias+"_ALI_WT"+cAlias+"_REC_WT")
  		    aColsAux[Len(aColsAux),nX] := CriaVar(AllTrim(aHeadFC[nX,2]))
  		EndIf
    Next
	If nPosAli > 0 .and. nPosRec > 0
		AcolsAux[Len(aColsAux),nPosAli] := &(cAlias+"->(Alias())")
		If IsHeadRec(aHeadFC[nPosRec,2])
			AcolsAux[Len(aColsAux),nPosRec] := &(cAlias+"->(RecNo())")
		EndIf
	Endif
    aColsAux[Len(aColsAux),Len(aHeadFC)+1] := .F.
EndIf

Return(aClone(aColsAux))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³QP215FilTxt ³ Autor ³Cleber L. Souza	    ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a recuperacao do texto da nao-conformidade associa-³±±
±±³			 ³ da as medicoes para que a mesma seja editada.			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FilTxt(EXPC1)							 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Chave de ligacao do texto da nao-conformidade      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPC2 = Texto da Cronica utilizada nas medicoes			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QIPA215                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FilTxt(cChvNco)
Local cEspecie := "QIPA210C" // Cronicas das NCs
Local nTamLin  := 70
Local aTextos  := {}
Local cTxtNco  := Space(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a recuperacao do texto da nao-conformidade    		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
cTxtNco := QA_RecTxt(cChvNco,cEspecie,00,nTamLin,"QA2",aTextos)

Return(cTxtNco)          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215FLAU ³ Autor ³Cleber L. Souza    	³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Devolve o Laudo do Laboratorio corrente.					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FILLAU(EXPC1,EXPC2,EXPC3,EXPC4)         			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo da Ordem de Producao						  ³±±
±±³			 ³ EXPC2 = Operacao         								  ³±±
±±³			 ³ EXPC3 = Laboratorio			        					  ³±±
±±³			 ³ EXPC4 = Tipo da Pesquisa									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Estrutura contendo os dados do Laudo				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FLAU(cOP,cRoteiro,cOperacao,cLaboratorio,cTipo)
Local aLaudo  := {}   
Local cSeek   := "" 
Local cLote   := ""
Local lLayout := GetMv("MV_QPTRLAY",.F.,"1") == "1"

If !lLayout
   	If cTipo == "L"
   		nRegLLA := 0
   	Else
		nRegLLG := 0   	
   	EndIf
EndIf

If cTipo == "L"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pesquisa o Laudo do laboratorio							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSeek := (xFilial("QPL")+padr(QPK->QPK_OP,TamSX3("QPL_OP")[1])+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+cOperacao+cLaboratorio)
	dbSelectArea("QPL")
	dbSetOrder(3) 	
Else
	If !Empty(Alltrim(QPK->QPK_LOTE))
		cLote := QPK->QPK_LOTE
	EndIf
	cSeek := (xFilial("QPL")+padr(QPK->QPK_OP,TamSX3("QPL_OP")[1])+cLote)
	dbSelectArea("QPL")
	dbSetOrder(2) 
EndIF                                      

dbGotop()
If DbSeek(cSeek) .and. (IIF (cTipo=="L",.T.,IIF(Empty(QPL->QPL_LABOR),.T.,.F.)))
	aLaudo := QP215FILENC("QPL",.T.)
	If !lLayout
	   	If cTipo == "L"
	   		nRegLLA := QPL->(Recno())
	   	Else
			nRegLLG := QPL->(Recno())   	
	   	EndIf
	EndIf 
Else
EndIf

Return(aLaudo)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215FILLOP³ Autor ³Cleber L. Souza       ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Devolve o Laudo do Laboratorio corrente.					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FILLAU(EXPC1,EXPC2)         	   					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo da Ordem de Producao						  ³±±
±±³			 ³ EXPC2 = Operacao         								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Estrutura contendo os dados do Laudo				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FILLOP(cOP,cRoteiro,cOperacao)
Local lLayout := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aLaudo := {}                                         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o Laudo do laboratorio							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPM")
dbSetOrder(3)      
If MsSeek(xFilial("QPM")+padr(QPK->QPK_OP,TamSX3("QPM_OP")[1])+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+cOperacao)
	aLaudo := QP215FILENC("QPM",.T.)   
	If !lLayout
   		nRegLLO := QPM->(Recno())
	EndIf
EndIf

Return(aLaudo)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215aCols³ Autor ³Cleber L. Souza 		³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria a estrutura do aCols com elementos a serem preenchidos,³±±
±±³			 ³quando nao houverem dados a serem adicionados.	  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215aCols(EXPC1,EXPN1)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Alias para montagem do aCols     				  ³±±
±±³			 ³ EXPN1 = Numeros de campos definidos no aHeader             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Estrutura do aCols								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIEA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215aCols(cAlias,nUsado)
Local aAreaAnt := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local aColsTmp := {}

Local nPosAli := Ascan(aHeader,{|x| AllTrim(x[2]) == cAlias+"_ALI_WT"})
Local nPosRec := Ascan(aHeader,{|x| AllTrim(x[2]) == cAlias+"_REC_WT"})
                            
nUsado++          

//Monta o aCols em um array auxiliar						
aColsTmp := Array(1,nUsado)    

nUsado := 0
dbSelectArea("SX3")
dbSetorder(1)
MsSeek(cAlias)
While !Eof() .And. (X3_ARQUIVO == cAlias)
	If X3Uso(X3_USADO) .And. (cNivel >= X3_NIVEL)
	 	If X3_ARQUIVO == "QPU" .OR. X3_PROPRI <> "U"
    		nUsado++                           
			aColsTmp[1,nUsado] := CriaVar(AllTrim(X3_CAMPO))
   		EndIf
   	EndIf
    dbSkip()
EndDo
If nPosAli > 0 .and. nPosRec > 0
	AcolsTmp[Len(aColsTmp),nPosAli] := &(cAlias+"->(Alias())")
	If IsHeadRec(aHeader[nPosRec,2])
		AcolsTmp[Len(aColsTmp),nPosRec] := 0
	EndIf
Endif
aColsTmp[1,Len(aHeader)+1] := .F. 

RestArea(aAreaSX3)
RestArea(aAreaAnt) //Retorna a area corrente
Return(aColsTmp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Q215aHeadM³ Autor ³Cleber L. Souza 		³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria os aHeaders utilizados na getdados das Medicoes.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215aHeadMed(EXPN1,EXPN2,EXPN3,EXPC1,EXPC2)				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao						  ³±±
±±³			 ³ EXPN2 = Posicao atual do Laboratorio						  ³±±
±±³			 ³ EXPN3 = Posicao atual do Ensaio 							  ³±±
±±³			 ³ EXPC1 = Ensaio atual										  ³±±
±±³			 ³ EXPC2 = Carta do Ensaio Atual 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = aCols contendo as medicoes						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215aHeadMed(nPosOpe,nPosLab,nPosEns,cEnsaio,cCarta)

Local aAreaSX3   := SX3->(GetArea())   
Local aHeaderTmp := {}
Local aColsTmp   := {}
Local bHeadMed                    
Local nQtdMed    := 0 
Local nX         := 0    
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"

//Posiciona variaveis globais
nOperacao := nPosOpe
nFldLab   := nPosLab
nEnsaio   := nPosEns
                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero de medicoes de acordo com a Carta do Ensaio			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
nQtdMed	:= aResultados[nPosOpe,_ENS,nPosLab,nPosEns,QTDMED]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Bloco para preenchimento do aHeader							 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
bHeadMed := {||Aadd(aHeaderTmp,{X3Titulo(),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,;
	X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,X3_WHEN})}

//Dados padronizados da Getdados das Medicoes
dbSelectArea("SX3")                
dbSetOrder(2)         

//Campo Data da Medicao
MsSeek("QPR_DTMEDI") 
Eval(bHeadMed)
                    
//Campo Hora da Medicao
MsSeek("QPR_HRMEDI")
Eval(bHeadMed)

//Campo Amostragem
MsSeek("QPR_AMOSTR")
Eval(bHeadMed)

//Campo Ensaiador
MsSeek("QPR_ENSR")
Eval(bHeadMed)

//Campo Nome do Ensaiador
MsSeek("QPR_ENSRNO")
Eval(bHeadMed)

If cCarta # "TXT"

	If cCarta # "P  "
	
		//Campos das Medicoes Mensuraveis 
		MsSeek("QPS_MEDICA")
		If cCarta $ "XBR/XBS/XMR/IND/HIS"
			For nX := 1 to nQtdMed 
				Aadd(aHeaderTmp,{STR0031+StrZero(nX,2),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Medicao "
					X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
  			Next nX

		ElseIf cCarta == "U  "
			Aadd(aHeaderTmp,{STR0032,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Amostra"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
					
			Aadd(aHeaderTmp,{STR0033,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Nao Conf. p/ Unid."
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
					 
		ElseIf cCarta == "NP "
			Aadd(aHeaderTmp,{STR0034,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,;//"Nao Conformes"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
					
		ElseIf cCarta == "C  "
			Aadd(aHeaderTmp,{STR0035,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,;//"Nao Conformidades"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
				
		ElseIf cCarta == "TMP"
			SX3->(dbSeek("QPR_DTINI"))
			Aadd(aHeaderTmp,{STR0036,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Data Inicial"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
						
		    SX3->(dbSeek("QPR_HRINI"))
			Aadd(aHeaderTmp,{STR0037,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Hora Inicial"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
	
			SX3->(dbSeek("QPR_DTFIM"))
			Aadd(aHeaderTmp,{STR0038,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Data Final"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
	
			SX3->(dbSeek("QPR_HRFIM"))
			Aadd(aHeaderTmp,{STR0039,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,;//"Hora Final"
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})

			SX3->(dbSeek("QPS_MEDICA"))
			Aadd(aHeaderTmp,{STR0031+"01",X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Medi‡„o "
				X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})
	
		EndIf
	Else
		//Campo Amostra
		MsSeek("QPS_MEDIPA")
		Eval(bHeadMed)

		//Campo Unidades Nao Conforme
		MsSeek("QPS_MEDIPN")
		Eval(bHeadMed)

		//Campo Porcentagem Nao Conforme
		MsSeek("QPS_MEDIPP")
		Eval(bHeadMed)

		//Campo de Calculo da Porcentagem Automaticamente
		MsSeek("QPS_CALPOR")
		Eval(bHeadMed)

	EndIf
		
Else
	//Campo Medicao 
	MsSeek("QPQ_MEDICA")
	Aadd(aHeaderTmp,{STR0041,X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,; //"Texto"
		X3_VALID,X3_USADO,X3_TIPO,X3_F3,X3_CONTEXT,	X3CBOX(),X3_RELACAO,".T."})

EndIf
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Insere o campo do Resultado da Medicao						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
If cCarta # "TXT"
	MsSeek("QPR_RESULT")
	Eval(bHeadMed)
/*	If	cCarta == "TMP"
		aHeaderTmp[Len(aHeaderTmp)][3] := "999:99" 
		aHeaderTmp[Len(aHeaderTmp)][4] := "6"
	EndIf*/
Else
	MsSeek("QPQ_RESULT")
	Eval(bHeadMed)

EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos criados pelo Usuario						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
QP215FilCp("QPR",bHeadMed,@aHeaderTmp,@aCpoUsu,@aCpoQry)  

//Campo Chave da medicao 
MsSeek("QPR_METODO")
Eval(bHeadMed)

//Campo Chave da medicao 
MsSeek("QPR_RVDOC")
Eval(bHeadMed)

//Campo Chave da medicao 
MsSeek("QPR_CHAVE")
Eval(bHeadMed)

//Campo Filial do Usuario
MsSeek("QPR_FILMAT")
Eval(bHeadMed)  

If !lLayout
	//Instrumentos
	MsSeek("QPR_ENTINS")
	Eval(bHeadMed)
	
	//Não-Conformidades
	MsSeek("QPR_ENTNC")
	Eval(bHeadMed)
EndIf

// Inclui coluna de registro atraves de funcao generica
ADHeadRec("QPR",aHeaderTmp)

//Ponto de Entrada para  alterar o aHeader das Medições.
If ExistBlock("QP215HMED")
	aHeaderTmp := aClone(ExecBlock("QP215HMED",.F.,.F.,{aHeaderTmp, cCarta, nQtdMed}))
Endif  

//Cria o aCols de acordo com a Carta do Ensaio                                     
aColsTmp := QP215ColsM(aHeaderTmp)

//Armazena o aHeader de acordo com a Carta do Ensaio
Aadd(aSavHeadEns[nPosOpe,nPosLab,nPosEns],aClone(aHeaderTmp))

RestArea(aAreaSX3)

Return(aColsTmp)                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Q215ColsM ³ Autor ³Cleber L. Souza        ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Cria a estrutura o aCols de acordo com o aHeader utilizado ³±±
±±³			 ³ na Medicoes.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215ColsM(EXPA1)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = aHeader utilizado na medicao						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA2 = aCols contendo a estrutura das medicoes			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ColsM(aHeader)
Local aColsTmp := {}
Local nUsadTmp := 0
Local nX

Local nPosAli  := Ascan(aHeader,{|X| Upper( Alltrim(X[2])) == "QPR_ALI_WT"})
Local nPosRec  := Ascan(aHeader,{|X| Upper( Alltrim(X[2])) == "QPR_REC_WT"})
                            
nUsadTmp := Len(aHeader)+1          

//Monta o aCols em um array auxiliar						
aColsTmp := Array(1,nUsadTmp)    
nUsadTmp := 0
For nX := 1 To Len(aHeader)
	nUsadTmp++
	If !(aHeader[nX,2] $ "QPR_ALI_WT | QPR_REC_WT")
		aColsTmp[1,nUsadTmp] := CriaVar(aHeader[nX,2],.T.)
	EndIf
Next nX
If nPosAli > 0 .and. nPosRec > 0
	aColsTmp[Len(aColsTmp),nPosAli] := QPR->(Alias())
	If IsHeadRec(aHeader[nPosRec,2])
		aColsTmp[Len(aColsTmp),nPosRec] := 0
	EndIf
Endif
aColsTmp[1,Len(aHeader)+1] := .F. 

Return(aColsTmp)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QP215FilCp  ³ Autor ³ Cleber Souza           ³ Data ³12/06/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Define os campos criados no dicionario de dados pelo usuario   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FilCp(cAlias,bCampos,aHeaderTmp,aCpoUsu)				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Alias												  ³±±
±±³			 ³ EXPB1 = Code Block para avaliacao do aHeader					  ³±±
±±³			 ³ EXPA1 = aHeader a ser inseridos os novos campos				  ³±±
±±³			 ³ EXPA2 = Vetor com os campos criados pelo usuario				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                              
Static Function QP215FilCp(cAlias,bCampos,aHeaderTmp,aCpoUsu)
Local aAreaSX3 := SX3->(GetArea())
Local nPosCpo  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona os campos criados pelo usuario						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX3->(dbSetOrder(1))
SX3->(MsSeek(cAlias))
While SX3->(!Eof()) .And. (SX3->X3_ARQUIVO == cAlias) 
	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL) .And. SX3->X3_PROPRI == "U" .and. SX3->X3_CONTEXT <> "V"
		nPosCpo := Ascan(aCpoUsu,{|x|AllTrim(x)==AllTrim(SX3->X3_CAMPO)})
		If nPosCpo == 0		
			Aadd(aCpoUsu,SX3->X3_CAMPO)
		EndIf	
		Eval(bCampos)                                
	EndIf
	SX3->(dbSkip())
Enddo

RestArea(aAreaSX3)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215FILENC³ Autor ³Cleber L. Souza 		³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorna um vetor contendo os dados de Um arquivo a ser edi-³±±
±±³			 ³ tado na Enchoice (Rotina de Resultados)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215FILENC(EXPC1,EXPL1)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Alias para montagem dos campos					  ³±±
±±³			 ³ EXPL1 = .T. preenche com o valor do campo				  ³±±
±±³			 ³ 		   .F. preenche com variavel de memoria				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1 = Vetor contendo os valores de cada campo			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FILENC(cAlias,lAchou)
Local aDados := {}                                                       

//Pesquisa os campos em uso para edicao
SX3->(dbSetOrder(1))
SX3->(MsSeek(cAlias))
While SX3->(!Eof()) .and. SX3->X3_ARQUIVO == cAlias
   	If X3Uso(SX3->X3_USADO) .And. (cNivel >= SX3->X3_NIVEL)    
		If lAchou                                      
			If AllTrim(SX3->X3_CAMPO) == "QPL_DESLAU" //Preenche a descricao do Laudo
				If __LANGUAGE == "PORTUGUESE"
					Aadd(aDados,Posicione("QPD",1,xFilial("QPD")+QPL_LAUDO,"QPD_DESCPO"))
				Elseif __LANGUAGE == "SPANISH"
					Aadd(aDados,Posicione("QPD",1,xFilial("QPD")+QPL_LAUDO,"QPD_DESCES"))
				Elseif __LANGUAGE == "ENGLISH"
					Aadd(aDados,Posicione("QPD",1,xFilial("QPD")+QPL_LAUDO,"QPD_DESCIN"))
				Endif
			Else	                                                                  
		   		If SX3->X3_CONTEXT == "V"
			    	Aadd(aDados,CriaVar(AllTrim(SX3->X3_CAMPO)))
				Else                 
			    	Aadd(aDados,&(SX3->X3_CAMPO))                     
			    EndIf	
		    EndIf	
    	Else
	    	Aadd(aDados,CriaVar(AllTrim(SX3->X3_CAMPO)))
    	EndIf	                                       

    EndIf
	SX3->(dbSkip())
EndDo
Return(aDados)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LegOp ³ Autor ³Cleber L. Souza 		³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Define as Legendas utilizadas nas OPs				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LegOp()  											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIEA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LegOp() 
Local aLegenda   := {}  

Aadd(aLegenda,{"BR_CINZA",	  OemToAnsi(STR0042)})   //"Ordem de Producao sem medicoes cadastradas"
Aadd(aLegenda,{"BR_AZUL",	  OemToAnsi(STR0043)})   //"Laudo Pendente"
Aadd(aLegenda,{"BR_VERDE",   OemToAnsi(STR0044)})   //"Laudo Aprovado"
Aadd(aLegenda,{"BR_VERMELHO",OemToAnsi(STR0045)})  //"Laudo Reprovado"
Aadd(aLegenda,{"BR_AMARELO", OemToAnsi(STR0046)})  //"Laudo com Liberacao Urgente"
Aadd(aLegenda,{"BR_LARANJA", OemToAnsi(STR0047)})  //"Laudo Aprovado Condicionalmente"

BrwLegenda(OemtoAnsi(STR0008),STR0049,aLegenda)  //"Ordem de Producao"
Return(NIL)                    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³Q215LegEns³ Autor ³Paulo Emidio de Barros ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exibe a legenda utilizada nos Ensaios					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Q215LegEns()								                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIEA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LegEn()
Local aLegenda := {}

Aadd(aLegenda,{"PMSTASK4",OemToAnsi(STR0160)}) //"Aprovado"
Aadd(aLegenda,{"PMSTASK1",OemToAnsi(STR0161)}) //"Reprovado"
Aadd(aLegenda,{"PMSTASK2",OemToAnsi(STR0162)}) //"Pendente"
Aadd(aLegenda,{"PMSTASK3",OemToAnsi(STR0163)}) //"Nao obrigatorio"

BrwLegenda(STR0008,OemToAnsi(STR0164),aLegenda) //"Ensaios"

Return(NIL)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoPen³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos Pendentes					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Qp215LdoPen()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Qp215LdoPen()       
Local lRetorno := .F.

If Empty(QPK->QPK_SITOP) .or. QPK->QPK_SITOP=="1"
	lRetorno := .T.                    
EndIf
Return(lRetorno)                                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoApr³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos Aprovados					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LdoApr()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LdoApr()
Local lRetorno := .F.

If QPK->QPK_SITOP == "2"                
	lRetorno := .T.                    
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoRep³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos Reprovados					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LdoRep()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LdoRep()
Local lRetorno := .F.

If QPK->QPK_SITOP == "3"                
	lRetorno := .T.                    
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoUrg³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos com Liberacao Urgente		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LdoUrg()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LdoUrg()
Local lRetorno := .F.

If QPK->QPK_SITOP == "4"                
	lRetorno := .T.                    
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoCon³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos com Liberacao Condicional	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LdoCon()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LdoCon()
Local lRetorno := .F.

If QPK->QPK_SITOP == "5"                
	lRetorno := .T.                    
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215LdoSME³ Autor ³Cleber L. Souza       ³ Data ³30/10/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status dos Laudos sem movimentacao de Estoque    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215LdoSME()								              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LdoSME()
Local lRetorno := .F.

If QPK->QPK_SITOP == "6"
	lRetorno := .T.
EndIf
Return(lRetorno)	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215EntSMC³ Autor ³Cleber L. Souza       ³ Data ³02/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Retorna o status das OPs sem Medicoes				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215EntSMC()							                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NENHUM													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ .T.	ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215EntSMC()       
Local lRetorno := .F.

If QPK->QPK_SITOP == "7"                
	lRetorno := .T.                    
EndIf
Return(lRetorno)             

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215QtdMed³ Autor ³Cleber L. Souza       ³ Data ³11/09/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Retorna o numero de Medicoes de acordo com a Carta do Ensaio³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215QtdMed(EXPC1)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Ensaio											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPN1 = Numero de Medicoes								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215QtdMed(cEnsaio, lPosSQL)
Local nQtdMed := 1  //Valor default
Local cTabSel := "QP1"

Default lPosSQL := .F.

If lPosSQL
	cTabSel := cAliasOPQP7
Else
	cTabSel := "QP1"
	QP1->(dbSetOrder(1))
	QP1->(MsSeek(xFilial("QP1")+cEnsaio))
EndIf

If &(cTabSel+"->QP1_CARTA") $ "XBR/XBS/XMR/HIS"
	nQtdMed	:= &(cTabSel+"->QP1_QTDE")
ElseIf &(cTabSel+"->QP1_CARTA") == "IND"
	nQtdMed	:= 1
ElseIf &(cTabSel+"->QP1_CARTA") == "NP "
	nQtdMed	:= 1
ElseIf &(cTabSel+"->QP1_CARTA") == "C  "
	nQtdMed	:= 1
ElseIf &(cTabSel+"->QP1_CARTA") == "U  "
	nQtdMed	:= 2
ElseIf &(cTabSel+"->QP1_CARTA") == "P  "
	nQtdMed	:= 3
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Substitui a Quantidade padrao definida para a Carta do Ensaio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215QTE")
	nQtdMed := ExecBlock("QP215QTE",.F.,.F.,{cEnsaio,&(cTabSel+"->QP1_CARTA")})
EndIf

Return(nQtdMed)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215Opera³ Autor ³Cleber Souza           ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta o browse contendo as Operacaoes contidas n OP.   	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215Opera(EXPO1,EXPN1)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPO1 = Objeto da folder corrente 						  ³±±
±±³			 ³ EXPN1 = Posicao da Operacao Corrente	    				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215Opera()
Local aFields := {}
Local aSizes  := {} 
Local nY      := 0
Local bBlock  
Local nPosChvNco := Ascan(aSavaHeader[HEAD_NCS],{|x|AllTrim(x[2])=="QPU_CHAVE"})  

//Preenche os titulos dos campos			
aFields := {STR0050,STR0051,STR0052,STR0053,STR0054,STR0055,STR0056,STR0050,STR0051,STR0052} //"Oper. Obrig"###"Seq. Obrig"###"Laudo Obrig"###"Oper"###"Desc Operacao"###"Setup Hrs"###"Tempo Padrao"###"Oper. Obrig"###"Seq. Obrig"###"Laudo Obrig"
                                      
//Preenche o tamanho dos campos								 
aSizes := {35, 35, 35, 30, 100, 40, 40, 35, 35, 35 }
bBlock:= {||Afill(Array(Len(aSizes))," ")}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o browse com as Operacoes           					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oBrwOpe:= TwBrowse():New(0.16,0.49,385,50,bBlock,aFields,aSizes,oFolder:aDialogs[1])
oBrwOPe:SetArray(aOperacoes)      
oBrwOPe:lMChange      := .F.      
oBrwOpe:nClrBackFocus := GetSysColor(13)
oBrwOpe:nClrForeFocus := GetSysColor(14) 
oBrwOpe:bLine :=   {||{aOperacoes[oBrwOPe:nAt,1],aOperacoes[oBrwOPe:nAt,2],aOperacoes[oBrwOPe:nAt,3],aOperacoes[oBrwOPe:nAt,4],;
					   aOperacoes[oBrwOPe:nAt,5],aOperacoes[oBrwOPe:nAt,6],aOperacoes[oBrwOPe:nAt,7],;
					   aOperacoes[oBrwOPe:nAt,8],aOperacoes[oBrwOPe:nAt,9],aOperacoes[oBrwOPe:nAt,10]}}    
oBrwOpe:bChange := {||{nFldLab:=1, nOperaAnt:=nOperacao,nOperacao:=oBrwOPe:nAt,QP215ValNav("O"),QP215OLAUL(),aOperacoes[nOperaAnt,1] := QP215AtuSta(nOperaAnt,,,,"O",{1},.F.),;
															 aOperacoes[nOperaAnt,2] := QP215AtuSta(nOperaAnt,,,,"O",{1},.F.),;
															 aOperacoes[nOperaAnt,3] := QP215AtuSta(nOperaAnt,,,,"O",{2},.F.),;
															 nOperaAnt:=nOperacao,;
															 Iif(Empty(Alltrim(oCronica:cTitle)),;
															 (cTexCro := QP215FilTxt(aOBJETOS[6,nOperacao,1,1]:acols[aOBJETOS[6,nOperacao,1,1]:nAt,nPosChvNco]), oCronica:cTitle := cTexCro ),;
															 aResultados[nOperacao,_CRO,1,1,1,1] ) }}   
oBrwOpe:Align := CONTROL_ALIGN_TOP
Return(NIL)          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215CarFLab³ Autor ³Cleber Souza         ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta folder dos laboratorios conforme Operacao escolhida   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215CarFLab(EXPN1,EXPN2,EXPN3)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao Corrente  					  ³±±
±±³          ³ EXPN2 = Numero Registro    			  					  ³±±
±±³          ³ EXPN3 = Opcao escolhida				  					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215CarFLab(nPosOpe,nReg,nOpc)
Local nW      :=0
Local nY      :=0
Local aFields := {}
Local aSizes  := {} 
Local bBlock  
Local oGet                
Local oBrwPla
Local aTitNCC := {}  
Local aPagNCC := {}  
Local aEns    := {}  

AADD(aTitNCC,STR0156) //"NAO CONFORMIDADES"
AADD(aTitNCC,STR0057) //"INSTRUMENTOS"
If Len(aOperacoes) < 5 //Devido a quantidade de objetos
	AADD(aTitNCC,STR0216) //"PLANO AMOSTRAGEM"
Endif	
AADD(aTitNCC,STR0058) //"LAUDO DO LABORATORIO" 

aPagNCC := aClone(aTitNCC)

aOBJETOS[OBJ_FOLLAB,nPosOpe] := TFolder():New(0.16,0.32,aTitLabOp[nPosOpe],aPagLabOp[nPosOpe],oFolder:aDialogs[2],,,,.F.,.F.,389,192)
aOBJETOS[OBJ_FOLLAB,nPosOpe]:bSetOption:={|nPosL|IIF(nFldLabA#0,QP215SavResu({SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUL},.T.),.T.),QP215ChgLab(nFldLab:=if(nPosL==Nil,1,nPosL),nFldLabA:=If(aOBJETOS[OBJ_FOLLAB,nPosOpe]:nOption==Nil,1,aOBJETOS[OBJ_FOLLAB,nPosOpe]:nOption))}
aOBJETOS[OBJ_FOLLAB,nPosOpe]:bLostFocus := {||QP215SavResu({SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUL},.T.)}
aOBJETOS[OBJ_FOLLAB,nPosOpe]:Align := CONTROL_ALIGN_ALLCLIENT
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta TBrowse dos Ensaio correspondentes aos Laboratorios.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ     
AADD(aEnsaios,{})

AADD(aOBJETOS[OBJ_ENSAIO],{})    
AADD(aOBJETOS[OBJ_MEDICA],{})  
AADD(aOBJETOS[OBJ_FOLNCC],{})  
AADD(aOBJETOS[OBJ_NCC]   ,{})  
AADD(aOBJETOS[OBJ_INST]  ,{})  
AADD(aOBJETOS[OBJ_LAUDO] ,{})  
AADD(aOBJETOS[OBJ_CRONIC],{}) 
If Len(aOperacoes) < 5 //Devido a quantidade de objetos
	AADD(aOBJETOS[OBJ_PLAMO] ,{}) 
Endif	
AADD(aOBJETOS[OBJ_SEQ]   ,{}) 

For nW:=1 to Len(aResultados[nPosOpe,_LAB])     

	AADD(aEnsaios[nPosOpe],{})
	AADD(aOBJETOS[OBJ_ENSAIO,nPosOpe],{})
	AADD(aOBJETOS[OBJ_FOLNCC,nPosOpe],{})  
	AADD(aOBJETOS[OBJ_NCC,nPosOpe]   ,{})  
	AADD(aOBJETOS[OBJ_INST,nPosOpe]  ,{})  
	AADD(aOBJETOS[OBJ_LAUDO,nPosOpe] ,{})  
	AADD(aOBJETOS[OBJ_CRONIC,nPosOpe],{})  
	AADD(aOBJETOS[OBJ_MEDICA,nPosOpe],{})
	If Len(aOperacoes) < 5 //Devido a quantidade de objetos
		AADD(aOBJETOS[OBJ_PLAMO,nPosOpe] ,{}) 
	Endif	
	AADD(aOBJETOS[OBJ_SEQ,nPosOpe]   ,{}) 
	
		//Preenche os titulos dos campos			
	aFields := {STR0059,STR0060,STR0061,STR0062,STR0063,STR0012,STR0064,STR0065,"LIE",STR0066,"LSE",STR0067,STR0041,STR0068,STR0069,"Rev DOC",STR0070,STR0071} //"Med"###"Ncs"###"Ins"###"Anexo"###"Seq."###"Ensaio"###"Descricao"###"Carta"###"Nominal"###"Medicoes"###"Skip-Teste"###"Metodo"###"Desc Ingles "###"Desc Espanhol"
                                      
	//Preenche o tamanho dos campos								 
	aSizes := {15, 15, 15, 15, 20, 30, 100, 25, 30, 30, 30, 30, 100, 30, 45, 30, 95, 95} 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche os ensaios associados ao Laboratorio 				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aeval(aResultados[nPosOpe,_ENS,nW],{|x,y|Aadd(aEnsaios[nPosOpe,nW],{;
		QP215AtuSta(nPosOpe,nW,y,"","E",{1},.F.),;
		QP215AtuSta(nPosOpe,nW,y,"","E",{2},.F.),;
		QP215AtuSta(nPosOpe,nW,y,"","E",{3},.F.),;
		QP215AtuSta(nPosOpe,nW,y,"","E",{4},.F.),;
		aResultados[nPosOpe,_ENS,nW,y,1], aResultados[nPosOpe,_ENS,nW,y,2],;
		aResultados[nPosOpe,_ENS,nW,y,3], aResultados[nPosOpe,_ENS,nW,y,4],;
		aResultados[nPosOpe,_ENS,nW,y,5], aResultados[nPosOpe,_ENS,nW,y,6],;
		aResultados[nPosOpe,_ENS,nW,y,7], aResultados[nPosOpe,_ENS,nW,y,8],;
	  	aResultados[nPosOpe,_ENS,nW,y,9], aResultados[nPosOpe,_ENS,nW,y,10],;
		aResultados[nPosOpe,_ENS,nW,y,11],aResultados[nPosOpe,_ENS,nW,y,12],;
		aResultados[nPosOpe,_ENS,nW,y,13],aResultados[nPosOpe,_ENS,nW,y,14]})})       
	
	bBlock:= {||Afill(Array(Len(aSizes))," ")}

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o browse com os ensaios		                		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrwEns:= TwBrowse():New(0.17,0.17,395,55,bBlock,aFields,aSizes,aOBJETOS[OBJ_FOLLAB,nPosOpe]:aDialogs[nW])
   	oBrwEns:SetArray(aEnsaios[nPosOpe,nW])      
	oBrwEns:lMChange      := .F.      
	oBrwEns:nClrBackFocus := GetSysColor(13)
	oBrwEns:nClrForeFocus := GetSysColor(14) 
	oBrwEns:Align := CONTROL_ALIGN_TOP

	AADD(aOBJETOS[OBJ_ENSAIO,nPosOpe,nW],oBrwEns)     
                                   
	aOBJETOS[OBJ_ENSAIO,nPosOpe,nW,1]:bLine := ;
	{||{aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,1],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,2],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,3],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,4],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,5],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,6],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,7],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,8],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,9],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,10],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,11],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,12],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,13],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,14],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,15],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,16],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,17],;
		aEnsaios[nOperacao,nFldLab,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,18]}}    
	                               			
	
	aOBJETOS[OBJ_ENSAIO,nPosOpe,nW,1]:bChange := {|| nEnsaio:=aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt,;
													 QP215SavResu({SAV_MED,SAV_NCO,SAV_CRO,SAV_INS},.F.),;  
													 QP215ChgEns(nOperacao,nFldLab,nEnsaioA,aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAt),;
													 nEnsaioA:=nEnsaio} 
	aOBJETOS[OBJ_ENSAIO,nPosOpe,nW,1]:bLostFocus := {|| QP215RightMe(nOperacao,nFldLab,nEnsaio)} 
	aOBJETOS[OBJ_ENSAIO,nPosOpe,nW,1]:Align := CONTROL_ALIGN_TOP													 
	
	For nY:=1 to Len(aResultados[nPosOpe,_ENS,nW])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Get Dados das Medicoes.                     				 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oGet := MsNewGetDados():New(49,0.7 ,100,386,IIF(ALTERA .or. INCLUI,GD_INSERT+GD_UPDATE+GD_DELETE,0),"LinOkMed","Allwaystrue","",,,999,,,,aOBJETOS[OBJ_FOLLAB,nPosOpe]:aDialogs[nW],aSavHeadEns[nPosOpe,nW,nY,1],aResultados[nPosOpe,_MED,nW,nY])

		AADD(aOBJETOS[OBJ_MEDICA,nPosOpe,nW],oGet)
		aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:bChange := {||nMedicao:= aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,;
																	IIF(QP1->QP1_TIPO<>"C",QP215SavResu({SAV_NCO,SAV_CRO,SAV_INS},.F.),.T.),; 
																	nMedicaoA:= aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,;
																	QP215CALMD(),;
																	QP215ChgMed(nOperacao,nFldLab,nEnsaio,nMedicao),;
																	QP215RightMe(nOperacao,nFldLab,nEnsaio)}  
 		aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:oBrowse:bLostFocus := {||QP215SavResu({SAV_MED},.T.),QP215CALMD(),;
 																 QP215AtuSta(nOperacao,nFldLab,nEnsaio,"","E",{1,2},.T.)} 
		
		aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:oBrowse:bDelOK := {||QP215DelOK(aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,;
																			aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols,;
																			aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aHeader)}
		aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:oBrowse:Align := CONTROL_ALIGN_TOP
		If nY==1
			aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:SHOW()
		Else
			aOBJETOS[OBJ_MEDICA,nPosOpe,nW,nY]:HIDE()
		EndIF

    Next nY
    
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Folder das Nao Conformidades.               				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aOBJETOS[OBJ_FOLNCC,nPosOpe,nW] := TFolder():New(7.1,0.18,aTitNCC,aPagNCC,aOBJETOS[OBJ_FOLLAB,nPosOpe]:aDialogs[nW],,,,.F.,.F.,385,97)
	aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:bSetOption:={|nPosN|QP215ChgFNC(nFldNCO:=nPosN,nFldNCOA:=aOBJETOS[OBJ_FOLNCC,nOperacao,nFldLab]:nOption)}
    aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:Align := CONTROL_ALIGN_ALLCLIENT
 	 
  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sequencia das medições.			              				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    If SetMDIChild()
	  	@ aSize[7]+170,aSize[5]-550 SAY oSay1 PROMPT cTexSeq	SIZE 120/2,10	OF aOBJETOS[OBJ_FOLNCC,nPosOpe,nw]:aDialogs[1] PIXEL COLOR CLR_BLUE
	    	//@ aSize[7]+170,aSize[5]-550 SAY oSay1 PROMPT cTexSeq	SIZE 120/2,10	OF aOBJETOS[OBJ_FOLLAB,nPosOpe]:aDialogs[nW] PIXEL COLOR CLR_BLUE 
	    																											   
	Else
	    @ aSize[7]+90,IIF(aSize[5]<1012,aSize[5]-570,aSize[5]-570) SAY oSay1 PROMPT cTexSeq	SIZE 120/2,10	OF aOBJETOS[OBJ_FOLNCC,nPosOpe,nw]:aDialogs[1] PIXEL COLOR CLR_BLUE
	       	  //@ aSize[7]+100,IIF(aSize[5]<1012,aSize[5]-570,aSize[5]-570) SAY oSay1 PROMPT cTexSeq	SIZE 120/2,10	OF aOBJETOS[OBJ_FOLLAB,nPosOpe]:aDialogs[nW] PIXEL COLOR CLR_BLUE
	
	Endif
	
	 oSay1:Align:= CONTROL_ALIGN_RIGHT
    AADD(aOBJETOS[OBJ_SEQ,nPosOpe,nW],oSay1)
	
	 	
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Get Dados das Nao Conformidades.                    		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGet := MsNewGetDados():New(0.6,0.6 ,45,384,Iif(Altera .Or. Inclui, GD_INSERT+GD_DELETE+GD_UPDATE, 0),"LinOkNCC","Allwaystrue","",,,,,,,aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[1],aSavaHeader[HEAD_NCS],aResultados[nPosOpe,_NCO,nW,1,1])
	AADD(aOBJETOS[OBJ_NCC,nPosOpe,nW],oGet)  
	aOBJETOS[OBJ_NCC,nPosOpe,nW,1]:bChange    			:= {||nNCO:= aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:nAT,;
																			 	QP215SavResu({SAV_CRO},.F.),;
																				 nNCOA:= aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:nAT,;
																				 QP215ChgNco(nOperacao,nFldLab,nEnsaio,nMedicao,nNCO)}  
	aOBJETOS[OBJ_NCC,nPosOpe,nW,1]:oBrowse:bLostFocus  := {||QP215AtuSta(nOperacao,nFldLab,nEnsaio,"","E",{2},.T.),QP215SavResu({SAV_NCO},.T.)}
	aOBJETOS[OBJ_NCC,nPosOpe,nW,1]:oBrowse:bGotFocus   := {||QP215VOMED()}
	aOBJETOS[OBJ_NCC,nPosOpe,nW,1]:oBrowse:Align := CONTROL_ALIGN_TOP   
	
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Get Memo da Cronica.                     			     	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SetMDIChild() 
		@ 051,2 GET oCronica VAR cTexCro MEMO NO VSCROLL VALID .T. Size 381,20 When lWhnCro Of aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[1] Pixel 
	Else
		@ 051,2 GET oCronica VAR cTexCro MEMO NO VSCROLL VALID .T. Size 381,30 When lWhnCro Of aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[1] Pixel 
	Endif	
	oCronica:bLostFocus := {|| QP215SavResu({SAV_CRO},.T.)}
	oCronica:Align := CONTROL_ALIGN_TOP
	AADD(aOBJETOS[OBJ_CRONIC,nPosOpe,nW],oCronica)  
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Get Dados dos Instrumentos.                     			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oGet := MsNewGetDados():New(0.6,0.6 ,73,384,Iif(Altera .Or. Inclui, GD_INSERT+GD_DELETE+GD_UPDATE, 0),"LinOkINS","Allwaystrue","",,,,,,,aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[2],aSavaHeader[HEAD_INST],aResultados[nPosOpe,_INS,nW,1,1])
    AADD(aOBJETOS[OBJ_INST,nPosOpe,nW],oGet)  
	aOBJETOS[OBJ_INST,nPosOpe,nW,1]:oBrowse:bLostFocus  := {||QP215AtuSta(nOperacao,nFldLab,nEnsaio,"","E",{3},.T.)}
	aOBJETOS[OBJ_INST,nPosOpe,nW,1]:oBrowse:bGotFocus   := {||QP215VOMED()}
	aOBJETOS[OBJ_INST,nPosOpe,nW,1]:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	                                 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ TWBROWSE Plano de Amostragem.                     			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aFields := {STR0205,STR0206,STR0207,STR0208,STR0209,STR0210,STR0211,STR0212,STR0213,STR0214,STR0215} //"Plano ","Amostragem","Nivel Amost.","NQA","Descrição","Amostra 1","Aceite 1","Rejeite 1","Amostra 2","Aceite 2","Rejeite 2" 
	aSizes  := {30, 35, 35, 20, 150, 30, 25, 25, 30, 25, 25 }
	bBlock  := {||Afill(Array(Len(aSizes))," ")} 

	If Len(aOperacoes) < 5
		oBrwPla:= TwBrowse():New(0.10,0.10,382,73,bBlock,aFields,aSizes,aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[3])
		oBrwPla:SetArray(aResultados[nPosOpe,_PLA,nW,nEnsaio])      
		oBrwPla:lMChange      := .F.      
		oBrwPla:nClrBackFocus := GetSysColor(13)
		oBrwPla:nClrForeFocus := GetSysColor(14) 
		oBrwPla:bLine :=   {||{aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,1],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,2],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,3],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,4],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,5],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,6],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,7],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,8],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,9],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,10],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][oBrwPla:nAt,11]}} 
	    oBrwPla:Align := CONTROL_ALIGN_ALLCLIENT  
	    AADD(aOBJETOS[OBJ_PLAMO,nPosOpe,nW],oBrwPla) 
	Endif    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta os vetores das Enchoices do Laudo do Laboratorio       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTela := {}
	aGets := {} 
    AADD(aOBJETOS[OBJ_LAUOPE,nPosOpe],{})   
	Aeval(aCpoEnc[1],{|x,y|M->&(aCpoEnc[1,y]):=aResultados[nPosOpe,_LLA,nW,y]})
	If Len(aOperacoes) < 5
		AADD(aOBJETOS[OBJ_LAUDO,nPosOpe,nW],MsMGet():New("QPL",nReg,nOpcX,,,,,{0.6,0.6,93,384},aCpoEnc[1],3,,,,aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[4],,.T.,,,,,,.T.))
	Else
		AADD(aOBJETOS[OBJ_LAUDO,nPosOpe,nW],MsMGet():New("QPL",nReg,nOpcX,,,,,{0.6,0.6,93,384},aCpoEnc[1],3,,,,aOBJETOS[OBJ_FOLNCC,nPosOpe,nW]:aDialogs[3],,.T.,,,,,,.T.))	
	Endif	
	aOBJETOS[OBJ_LAUDO,nPosOpe,nW,1]:oBox:Align := CONTROL_ALIGN_ALLCLIENT  
	
	AADD(aSavTela[nPosOpe,2],aClone(aTela))
	AADD(aSavGets[nPosOpe,2],aClone(aGets))

Next nW 

Return(NIL)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215CarLau  ³ Autor ³Cleber Souza        ³ Data ³20/10/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Enchoice de Resultado das Operacoes e Laboratorios    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215CarFLab(EXPN1,EXPN2,EXPC1,EXPO1)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao Corrente  					  ³±±
±±³          ³ EXPN2 = Registro						  					  ³±±
±±³          ³ EXPC1 = Opcao Escolhida				  					  ³±±
±±³          ³ EXPO1 = Objeto Folder Geral			  					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215CarLau(nPosOpe,nReg,nOpc,oFldGer)

Local nW:=0  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os vetores das Enchoices de Laudos da Operacao		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                             
Aeval(aCpoLOP[1],{|x,y|M->&(aCpoLOP[1,y]):=aResultados[nPosOpe,_LOP,y]})
aGets := aClone(aGetLauOpe)
aTela := aClone(aTelaLauOpe)  

For nW := 1 To Len(aGets)
		aTela[Val(Subs(aGets[nW],1,2))][Val(Subs(aGets[nW],3,1))*2] := &("M->" + aCpoLOP[1,nW])
Next nW

AADD(aSavTela,{{},{}})   
AADD(aSavGets,{{},{}})   

aSavTela[nPosOpe,1] := aClone(aTela)
aSavGets[nPosOpe,1] := aClone(aGets)

Return(NIL)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Q215ChkMed³ Autor ³Cleber L. Souza    	 ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se todos os dados necessario foram digitados na	   ³±±
±±³			 ³ Getdados de Medicoes, Nao Conformidades e Instrumentos      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³SIntaxe   ³ Q215ChkMed(EXPN1,EXPN2,EXPN3,EXPN4,EXPC1,EXPN5,EXPL1,EXPL2) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao   							   ³±±
±±³          ³ EXPN2 = Posicao do Laboratorio							   ³±±
±±³			 ³ EXPN3 = Posicao do Ensaio							       ³±±
±±³			 ³ EXPN4 = Posicao da Linha da Medicao						   ³±±
±±³			 ³ EXPN5 = Posicao da Medicao								   ³±±
±±³			 ³ EXPC1 = Carta do Ensaio corrente					    	   ³±±
±±³			 ³ EXPN6 = Tipo, onde 1) Medicoes							   ³±±
±±³			 ³		    		  2) Nao-cOnformidades				  	   ³±±
±±³			 ³		  		  	  3) Instrumentos					   	   ³±±
±±³			 ³ EXPL1 = Indica se o registro sera marcado como deletado	   ³±±
±±³			 ³ EXPL2 = Indica se o registro deletado sera considerado      ³±±
±±³			 ³ EXPL3 = Indica se as consistencias serao realizadas no aCols³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL2 = .T. ou .F.										   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIEA215													   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ChkMed(nPosOperac,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,cCarta,nTipo,lDeleta,lConDel,laCols)
Local lRetorno := .T.       
Local aHeadTmp := {}                   
Local nY 	   := 0
Local nDel     := 0 //posicao da marca de exclusao no aCols 
Local nDelAux  := 0 //posicao da marca de exclusao no aCols 
Local nPosCpo  := 0 //posicao do campo medicao
Local nPosRes  := 0 //posicao do campo Resultado
Local nPosNco  := 0 //posicao do campo Nao-conformidade                                             
Local nPosInst := 0 //posicao do campo codigo do Instrumento
Local nQtdCpo  := 0
Local cEnsaio  := aResultados[nPosOperac,_ENS,nPosLabor,nPosEnsai,ENSAIO] 
Local nQtdMed  := aResultados[nPosOperac,_ENS,nPosLabor,nPosEnsai,QTDMED] 
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"

//Vinculo os arrays  auxiliares para na fucao               
If !lLayout
	lAcols := .F.
EndIf
	
Default lDeleta := .T.
Default lConDel := .F. //Indica se o registro deletado no aCols sera considerado
Default laCols  := .F. //Indica se as consistencias serao realizadas no aCols

If nTipo == 1 //Medicoes              
	If cCarta == "P  "
		nPosCpo  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPS_MEDIPA"})
		nPosRes  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
	ElseIf cCarta == "TXT"
		nPosCpo  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
		nPosRes  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
	Else
		nPosCpo  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
		nPosRes  := Ascan(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
	EndIf

	If lAcols //Realiza a validacao no aCols
		nDel := Len(aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aHeader)+1
		If !aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aCols[nPosMed,nDel] 
			If Empty(aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aCols[nPosMed,nPosRes])
				If lDeleta
					aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aCols[nPosMed,nDel] := .T.
				EndIf
				lRetorno := .F.
			Else
				nQtdCpo := (nPosCpo+nQtdMed-1)
				For nPosCpo := nPosCpo to nQtdCpo
					If AllTrim(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1,nPosCpo,2]) $ "QPQ_MEDICA/QPS_MEDICA/QPS_MEDIPA/QPS_MEDIPN/QPS_MEDIPP/QPR_RESULT/QPR_ENSR"	
						If Empty(aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aCols[nPosMed,nPosCpo])
							If lDeleta
								aOBJETOS[OBJ_MEDICA,nPosOperac,nPosLabor,nPosEnsai]:aCols[nPosMed,nDel]:= .T.
							EndIf
							lRetorno := .F.
							Exit
					    EndIf
				    EndIf
				Next nPosCpo
			EndIf
		Else 
			If lConDel
				lRetorno := .F.
			EndIf	    
	    EndIf
	Else
		nDel := Len(aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed]) 
		If !aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed,nDel]
			If !lLayout
				If Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai]) < nPosMed  
					aAdd(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai],aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,"     ","QPU_CODMED",Len(aSavaHeader[HEAD_NCS]))))
				EndIf
				For nY := 1 To Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed])
					nDelAux := Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY]) 
					If aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]
						aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]:= .F.
					EndIf
				Next nY	

				If Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai]) < nPosMed  
					aAdd(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai],aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"     ","QPT_CODMED",Len(aSavaHeader[HEAD_INST]))))
				EndIf
				For nY := 1 To Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed])
					nDelAux := Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY]) 
					If aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]
						aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]:= .F.
					EndIf
				Next nY	
			EndIf
			If Empty(aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed,nPosRes])
				If lDeleta
					aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed,nDel] := .T.
				EndIf
				lRetorno := .F.
			Else
				nQtdCpo := (nPosCpo+nQtdMed-1)
				For nPosCpo := nPosCpo to nQtdCpo
					If AllTrim(aSavHeadEns[nPosOperac,nPosLabor,nPosEnsai,1,nPosCpo,2]) $ "QEQ_MEDICA/QES_MEDICA/QES_MEDIPA/QES_MEDIPN/QES_MEDIPP/QER_RESULT/QER_ENSR/QPQ_RESULT/QPR_RESULT"	
						If Empty(aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed,nPosCpo])
							If lDeleta
								aResultados[nPosOperac,_MED,nPosLabor,nPosEnsai,nPosMed,nDel] := .T.
							EndIf
							lRetorno := .F.
							Exit
					    EndIf
				    EndIf
				Next nPosCpo
			EndIf
		Else
            If Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai]) >= nPosMed
				For nY := 1 To Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed])
					nDelAux := Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY]) 
					If !aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]
						aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]:= .T.
					EndIf
				Next nY
			EndIf
			If Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai]) >= nPosMed				
				If !lLayout /*.AND. oGetINS != Nil*/
					For nY := 1 To Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed])
						nDelAux := Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY]) 
						If !aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]
							aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosMed,nY,nDelAux]:= .T.
						EndIf
					Next nY
				EndIf
			EndIf
			If lConDel
				lRetorno := .F.
			EndIf	    
	    EndIf
    
    EndIf
ElseIf nTipo == 2 //Nao-conformidades            
	aHeadTmp := aClone(aSavaHeader[HEAD_NCS])
	nPosNco  := Ascan(aHeadTmp,{|x|AllTrim(x[2])=="QPU_NAOCON"})
    
    If laCols //Realiza a validacao no aCols
	    nDel := Len(aOBJETOS[OBJ_NCC,nPosOperac,nPosLabor,1]:aHeader)+1 
		If !aOBJETOS[OBJ_NCC,nPosOperac,nPosLabor,1]:aCols[nPosMed,nDel]                              
			If Empty(aOBJETOS[OBJ_NCC,nPosOperac,nPosLabor,1]:aCols[nPosMed,nPosNco])
				If lDeleta 
					aOBJETOS[OBJ_NCC,nPosOperac,nPosLabor,1]:aCols[nPosMed,nDel] := .T.
				EndIf	
				lRetorno := .F.        
		    EndIf
		Else
			If lConDel
				lRetorno := .F.
			EndIf	    
		EndIf
    Else	
        nDel := Len(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosLinMed,nPosMed]) 
		If !aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nDel]        
			If Empty(aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nPosNco])
				If lDeleta 
					aResultados[nPosOperac,_NCO,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nDel] := .T.
				EndIf	
				lRetorno := .F.
		    EndIf
		Else
			If lConDel
				lRetorno := .F.
			EndIf	    
		EndIf
	EndIf	
ElseIf nTipo == 3 //Instrumentos
	aHeadTmp := aClone(aSavaHeader[HEAD_INST])
	nPosInst := Ascan(aHeadTmp,{|x|AllTrim(x[2])=="QPT_INSTR"})
    
    If laCols //Realiza a validacao no aCols
	    nDel := Len(aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aHeader)+1          
   		If Len(aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols) < nPosMed
   			nPosMed := Len(aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols)
   		Endif
    	If !aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols[nPosMed,nDel]                              
    		If Empty(aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols[nPosMed,nPosInst])
				If lDeleta
					aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols[nPosMed,nDel] := .T.
				EndIf	
				lRetorno := .F.        
		    EndIf
		Else
			If lConDel
				lRetorno := .F.
			EndIf	    
		EndIf                            
		If lRetorno .AND. cMv_QPINAUT == "S" .AND. cMv_QINTQMT == "S" //Indica se os Instrumentos sao obrigatorios
			aSavaCols[HEAD_INST]   := aClone(aOBJETOS[OBJ_INST,nPosOperac,nPosLabor,1]:aCols)
			QP215SavResu({SAV_INS},.T.)                                          
		ElseIf lRetorno .AND. cMv_QINTQMT == "S" // Sem Instrumento automatico
			QP215SavResu({SAV_INS},.T.)		
		Endif			
    Else
	    nDel := Len(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosLinMed,nPosMed])        
		If !aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nDel]        
			If Empty(aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nPosInst])
				If lDeleta
					aResultados[nPosOperac,_INS,nPosLabor,nPosEnsai,nPosLinMed,nPosMed,nDel] := .T.       
				EndIf	
				lRetorno := .F.        
		    EndIf
		Else
			If lConDel
				lRetorno := .F.
			EndIf	    
		EndIf                            
	EndIf
EndIf

Return(lRetorno)                         

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215OLAUL³ Autor ³Cleber L. Souza        ³ Data ³14/07/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza Enchoice Laudo das Operacoes e Folder Laboratorios³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215OLAUL()          						 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215OLAUL()

Local nX := 0 
Local nY := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se precisa salvar Laudo Anterior na aResultados.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If !lAutomatic
	QP215SavResu({SAV_LAUO},.T.)
EndIF

aTela := aSavTela[nOperacao,1]
aGets := aSavGets[nOperacao,1]  
For nX := 1 to Len(aCpoLOP[1])
	&("M->"+aCpoLOP[1,nX]) := aResultados[nOperacao,_LOP,nX]
Next nX  
    
oGetLauOpe:EnchRefreshAll()
                                                         
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza aCols da Rastreabilidade.		   					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
oGetRast:aCols := aResultados[nOperacao,_RAS] 
oGetRast:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seta o Primeiro Folder dos Laboratorios	   					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
nFldLab  := aOBJETOS[OBJ_FOLLAB,nOperacao]:nOption
nFldLabA := 1          

For nY:=1 to Len(aOBJETOS[OBJ_FOLLAB])
	aOBJETOS[OBJ_FOLLAB,nY]:HIDE()
	aOBJETOS[OBJ_FOLLAB,nY]:REFRESH()
Next nY

If nOperacao == 1         
	aOBJETOS[OBJ_FOLLAB,nOperacao]:SHOW() 
	aOBJETOS[OBJ_FOLLAB,nOperacao]:REFRESH()  
EndIf                                                    
                   
cTexObs := aResultados[nOperacao,_MOP]
oObsOPE:Refresh()

Return(NIL)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgOpe³ Autor ³Cleber L. Souza       ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Atualiza Pastas dos Laboratorios de acordo com a operacao  ³±±
±±³			 ³ selecionada.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215ChgOpe(EXPN1,EXPN2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao 						  ³±±
±±³			 ³ EXPN2 = Ultima posicao selecionada da Operacao   		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ChgOpe(nOpeGot,nOpeLost,nOpc)                 
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aAreaAnt := GetArea()  
Local lRet  
Local nPosLau := 0			
Local aCampos  := {}
Local aTelaAnt := {}
Local aGetAnt  := {}
Local nPosLauOP := 0
Local nPosDtOP  := 0
Local nPosHrOP  := 0

If nOpeLost == 3
	If lLiberaUrg .And. nOpc != 2
		Help(" ",1,"QPH215001") //"Na rotina de liberacao urgente nao eh permitido digitar ensaios nem laudo para as operacoes."
		nFldOpe  := 3
		nFldOpeA := 3 
	   	Return(.F.)
	Else 
		QP215SavResu({SAV_LAUG},.T.)
	EndIf   	
EndIf 

If nOpeGot == 1 .and. (nOpeLost == 2 .or. nOpeLost == 1)  

	If lLayout
		nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
	Else                                                                                                   
		nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
	EndIf                                                         
    
	QP215ADMOBJ(,,,3,!Empty(aResultados[nFldLauGer,1,nPosLau]) .Or. lLiberaUrg)

	If nOpeLost == 2  
		QP215SavResu({SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUL},.T.)
	EndIF    
 
    If	!QP215VLDJUS("L") .or. !QP215VOMED()
    	nFldOpe   := nOpeLost 
    	Return(.F.)
    EndIf
                                                       
	aOBJETOS[OBJ_FOLLAB,nOperacao]:HIDE()
	aOBJETOS[OBJ_FOLLAB,nOperacao]:REFRESH()

ElseIf (nOpeGot == 2 .or. nOpeGot == 3 ) .and. nOpeLost == 1 

	nFldLabA := 0
	QP215SavResu({SAV_LAUO},.T.)
	
	aOBJETOS[OBJ_FOLLAB,nOperacao]:SHOW()
   	aOBJETOS[OBJ_FOLLAB,nOperacao]:SetOption(1)
	aOBJETOS[OBJ_FOLLAB,nOperacao]:REFRESH()  

EndIf               

If nOpeGot == 2

	nEnsaio  			:= aOBJETOS[OBJ_ENSAIO,nOperacao,nFldLab,1]:nAT 
	nMedicao:=nMedicaoA := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT
	nNCO:=nNCOA 		:= aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:nAT
                  
	If lLayout
		nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO")
	Else                                                                                                   
		nPosLau := QP215GetLau(aSavGets[1,1],"QPM_LAUDO")
	EndIf

	QP215ADMOBJ(nOperacao,,nEnsaio,1,!Empty(aResultados[nOperacao,_LOP,nPosLau]) .Or. lLiberaUrg .Or. !Empty(aResultados[nFldLauGer,1,nPosLauGer])) 
	QP215ChgFNC(3,1)                                                                             
	If Len(aOperacoes) < 5
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:SetArray(aResultados[nOperacao,_PLA,nFldLab,nEnsaio])  
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:bLine :=   {||{aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,1],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,2],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,3],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,4],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,5],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,6],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,7],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,8],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,9],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,10],;
						  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,11]}}    
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:Refresh()
    Endif
ElseIf nOpeGot == 3
    
    //Valida Laudo das Operacoes antes de acessar tela do Laudo Geral.
    If (!QP215ValNav("G") .and. !lLiberaUrg) .or. !QP215VLDJUS("O")
    	nFldOpe   := nOpeLost 
    	Return(.F.)
    EndIf
	
	//Valido campos obrigatorios do folder Laudo Operacao       
    aTelaAnt := aClone(aTela)
    aGetAnt  := aClone(aGets)
	aTela:={}
	aGets:={}   
	aTela:= aClone(aTelaLauOpe)
	aGets:= aClone(aGetLauOpe)
	
	//Caso a operacao, a sequencia e o laudo nao seja obrigatorio
	//para essa operacao, o atributo de obrigatoriedade de preenchimento
	//dos campos QPM_LAUDO, QPM_DTLAD E QPM_HR LAUDO (resultados da operacao)
	//sao alterados para falso.
	nPosLauOP  := Ascan(aGets,{|X| SubStr(X,9,10) == Padr("QPM_LAUDO" ,10)})
	nPosDtOP   := Ascan(aGets,{|X| SubStr(X,9,10) == Padr("QPM_DTLAUD",10)})
	nPosHrOP   := Ascan(aGets,{|X| SubStr(X,9,10) == Padr("QPM_HRLAUD",10)})
	If nOpeGot ==3 .And. aOperacoes[nOperacao,8]  == "N"; //Operacao Obrigatoria
				   .And. aOperacoes[nOperacao,9]  == "N"; // Sequencia Obrigatoria
				   .And. aOperacoes[nOperacao,10] == "N" // Laudo Obrigatorio
		aGets[nPosLauOP] := SubStr(aGets[nPosLauOP],1,24) + "F" + SubStr(aGets[nPosLauOP],26)
		aGets[nPosDtOP]  := SubStr(aGets[nPosDtOP],1,24)  + "F" + SubStr(aGets[nPosDtOP],26)
		aGets[nPosHrOP]  := SubStr(aGets[nPosHrOP],1,24)  + "F" + SubStr(aGets[nPosHrOP],26)
	EndIf
	If nOpc <> 2
	   	If Empty(aResultados[nFldLauGer,1,nPosLauGer]) .AND. !Obrigatorio(aGets,aTela)
			Return(.F.)
		EndIf
	Endif
    
	aTela:={}
	aGets:={}
    aTela := aClone(aTelaAnt)
    aGets  := aClone(aGetAnt)
           
    QP215SavResu({SAV_MED,SAV_NCO,SAV_INS,SAV_CRO,SAV_LAUL},.T.)
        
	aTela:={}
	aGets:={}
	aTela := aSavTela[nFldLauGer]
	aGets := aSavGets[nFldLauGer]  
	Aeval(aCpoEnc[1],{|x,y|M->&(aCpoEnc[1,y]):=aResultados[nFldLauGer,1,y]})
	aOBJETOS[OBJ_LAUGER,1]:EnchRefreshAll()   

EndIF                                 

RestArea(aAreaAnt)
Return(.T.)    
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgLab ³ Autor ³Cleber L. Souza 	    ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza a selecao na mudanca de Folder dos Laboratorios uti³±±
±±³			 ³ lizados na rotina de Resultados.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215ChgLab(EXPN1,EXPN2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual do Laboratorio						  ³±±
±±³			 ³ EXPN2 = Ultima posicao selecionada do Laboratorio		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ChgLab(nLabGot,nLabLost) 

Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aAreaAnt := GetArea()          
Local nX       := 0      
Local nPosLau  := 0
Local nEnsaioL := 0

If lLayout
	nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPL_LAUDO")
Else                                                                                                   
	nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
EndIf
	
aOBJETOS[OBJ_ENSAIO,nOperacao,nLabGot,1]:REFRESH(.T.)   
                                                                           	
nEnsaioL  := aOBJETOS[OBJ_ENSAIO,nOperacao,nLabLost,1]:nAt // Pego o numero correto do ensaio a ser preenchido
nEnsaio   := aOBJETOS[OBJ_ENSAIO,nOperacao,nLabGot ,1]:nAt 
nEnsaioA  := nEnsaio

For nX:=1 to Len(aResultados[nOperacao,_ENS,nLabGot])
	QP215AtuSta(nOperacao,nLabGot,nX,"","E",{1,2,3,4},.F.)
Next nX

//Atualiza medição Atual
nMedicao := aOBJETOS[OBJ_MEDICA,nOperacao,nLabGot,nEnsaio]:nAT 

//Atualiza a tela de sequencia 
QP215Seq(aOBJETOS[OBJ_MEDICA,nOperacao,nLabGot,nEnsaio])

aTela:={}
aGets:={}
aTela := aSavTela[nOperacao,2,nLabGot]
aGets := aSavGets[nOperacao,2,nLabGot]  
Aeval(aCpoEnc[1],{|x,y|M->&(aCpoEnc[1,y]):=aResultados[nOperacao,_LLA,nLabGot,y]})
aOBJETOS[OBJ_LAUGER,1]:EnchRefreshAll()  

QP215ChgFNC(3,1)

If Len(aOperacoes) < 5
	//Atualiza a tela de Plano de Amostragem
	aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:SetArray(aResultados[nOperacao,_PLA,nLabGot,nEnsaio])  
	If aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt <> Nil .AND. Len(AllTrim(aResultados[nOperacao,_PLA,nLabGot,nEnsaio])) > 0
		aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:bLine :=   {||{aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,1],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,2],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,3],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,4],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,5],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,6],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,7],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,8],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,9],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,10],;
						  	   aResultados[nOperacao,_PLA,nLabGot,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:nAt,11]}}    
		aOBJETOS[OBJ_PLAMO,nOperacao,nLabGot,1]:Refresh()
	EndIf	
Endif
//Atualiza Cronica da Nao Conformidade
aResultados[nOperacao,_CRO,nLabLost,nEnsaioL,;
   	Iif(nMedicaoA>len(aResultados[nOperacao,_CRO,nLabLost]),len(aResultados[nOperacao,_CRO,nLabLost]),nMedicaoA),;
	aOBJETOS[OBJ_NCC,nOperacao,nLabLost,1]:nAT,1] := cTexCro             
	
cTexCro  := aResultados[nOperacao,_CRO,nLabGot,nEnsaio,;
   	Iif(nMedicao>len(aResultados[nOperacao,_CRO,nLabGot]),len(aResultados[nOperacao,_CRO,nLabGot]),nMedicao),;
	aOBJETOS[OBJ_NCC,nOperacao,nLabGot,1]:nAT,1]

//Atualiza medição anterior após salvar todos os objetos.
nMedicaoA := Iif(nMedicao>len(aResultados[nOperacao,_CRO,nLabGot]),len(aResultados[nOperacao,_CRO,nLabGot]),nMedicao) 

RestArea(aAreaAnt)
Return(.T.)                       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgEns³ Autor ³Cleber L. Souza 		³ Data ³19/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza atualizacao dos objetos na mudanca de ensaio.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao						  ³±±
±±³			 ³ EXPN2 = Posicao atual do Laboratorio						  ³±±
±±³			 ³ EXPN3 = Posicao atual do Ensaio							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ChgEns( nPosOpe, nPosLabi, nPosEnsA, nPosEnsai, lAtuEns,;
					  lAtuSel) 
Local lLayout   := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRetPE    := .T.                 
Local lRet	    := .T.
Local lExPonto  := .T.
Local nAcPosMed := 0
Local nAcPosRes := 0

Default lAtuEns := .F.
Default lAtuSel := .F.

If !lCPrimOP
	Return(lRet)
EndIf

If ExistBlock("QP215J12")
/*	If !lLayout
	    lExPonto := .T.
		If ExistBlock("QP216J17A") 
			If cCartEns <> "TXT"
				If cCartEns <> "P  "
					nAcPosMed := aScan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPS_MEDICA' })
				Else
					nAcPosMed := aScan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPS_MEDIPA' })
				EndIF
				nAcPosRes := aScan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPR_RESULT' })
			Else
				nAcPosMed := aScan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPQ_MEDICA' })
				nAcPosRes := aScan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPQ_RESULT' })
			EndIf                    
			
			cResul	:=  aResultados[nPosOpe,_MED, nPosLabi, nPosEnsai, oGetMed:nAT, nAcPosRes]
			nAmo	:=	ascan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPR_AMOSTR' })
			nDtM	:=	ascan(oGetMed:aHeader, { |x| alltrim(x[2]) == 'QPR_DTMEDI' })
			
			If Len(aResultados[nPosOpe, _NCO, nPosLabi, nPosEnsai]) >= oGetMed:nAt
				aNc	:= aClone(aResultados[nPosOpe,_NCO,nPosLabi,nPosEnsai, oGetMed:nAt])
			EndIf
			lExPonto := ExecBlock("Q216J17A",.f.,.f.,{cResul,aResultados[nPosOpe, _ENS, nPosLabi],cDescLab,cOper,cIP210OP,aNc,aResultados[nPosOpe,_MED, nPosLabi, nPosEnsai, oGetMed:nAT, nAmo]})
		EndIf		
	Else 
	    lExPonto := .T.
	EndIf   
	
	If lExPonto*/
		lRetPE := ExecBlock("QP215J12",.F.,.F.,{aResultados[nPosOpe,_OPE], aResultados[nPosOpe,_LAB,nPosLabi], aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsai,ENSAIO], QPK->QPK_OP})
//	EndIf
Endif

If lLayout		           
	QP1->(dbSeek(xFilial("QP1")+aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsai,ENSAIO]))
	If QP1->QP1_TIPO=="C" .OR. !lRetPE
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:lupdate := .F.
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:linsert := .F.
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:ldelete := .F.
	Else
		If Empty(M->QPL_LAUDO) .and. (INCLUI .or. ALTERA)
			aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:lupdate := .T.
			aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:linsert := .T.
			aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:ldelete := .T.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acerta Posicionamento das NCOs da Medicao				 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsA]:HIDE()
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsA]:REFRESH()
	
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:SHOW() 
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:aCols := aResultados[nPosOpe,_MED,nPosLabi,nPosEnsai]
	nMedicao:=nMedicaoA:= aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:nAT := 1
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai]:REFRESH()

	//Atualiza a tela de sequencia 
	QP215Seq(aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsai])
	
	QP215ChgMed(nOperacao,nFldLab,nEnsaio,nMedicao)                 
	If Len(aOperacoes) < 5
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:SetArray(aResultados[nOperacao,_PLA,nFldLab,nEnsaio])  
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:bLine :=   {||{aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,1],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,2],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,3],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,4],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,5],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,6],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,7],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,8],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,9],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,10],;
							  	   aResultados[nOperacao,_PLA,nFldLab,nEnsaio][aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:nAt,11]}}    
		aOBJETOS[OBJ_PLAMO,nOperacao,nFldLab,1]:Refresh()
	Endif 
Else
	lRet := .T. 
	/*If !lExPonto
		nPosEnsai := nPosEnsA  
		lRet := .F. 
	Endif */
	//QP1->(dbSeek(xFilial("QP1")+aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsai,ENSAIO]))
	//QP215CALMD() 

   	If ExistBlock("QP215J12")
   		lRet := lRetPE       
   	EndIf            
	//QP1->(dbSeek(xFilial("QP1")+aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsai,ENSAIO]))
	If aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSCALC] .OR. !lRetPE
		lRet := .F.
	Else 
		If !Empty(AllTrim(aResultados[nPosOpe,_LLA,nPosLabi,3])) .OR. !Empty(AllTrim(aResultados[nFldLauGer,1,3]))
			lRet := .F.
		EndIf
	EndIf
	// Monto os Ensaios bloqueqndo as medições
	a216CarEns( nPosLabi,     Nil, oBrwJJ:oWnd,  !lRet, nPosEnsai,;
			  	     Nil, 	  Nil,         Nil, lAtuEns,   lAtuSel)
EndIf
Return(lRet) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgMed ³ Autor ³Cleber L. Souza      ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza a selecao na mudanca das Medicoes.	    		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao						  ³±±
±±³			 ³ EXPN2 = Posicao atual do Laboratorio						  ³±±
±±³			 ³ EXPN3 = Posicao atual do Ensaio							  ³±±
±±³			 ³ EXPN4 = Posicao atual da Medicao							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ChgMed(nPosOpe,nPosLab,nPosEns,nPosMed)  
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

/*If !lLayout .AND. Valtype(oGetMed) <> "U"
 	 oGetMed:aCols := aClone(aResultados[nPosOpe,_MED,nPosLab,nPosEns])
EndIf*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerta aCols das Nao Conformidades de acordo com o Ensaio.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
If Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns]) >= nPosMed
	If lLayout
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLab,1]:aCols   := aClone(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed])
	Else 
	    If oGetNc != Nil
		    oGetNc:aCols := aClone(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,oGetMed:nAT]) 
		EndIf
	EndIf
Else 
	//Acerta aResultados das Nao Conformidades
	If lLayout
		Aadd(aResultados[nPosOpe,_NCO,nPosLab,nPosEns],aClone(aSavaCols[HEAD_NCS]))
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLab,1]:aCols   := aClone(aSavaCols[HEAD_NCS]) 
/*	Else    
	    // Neste contexto eu não carrego o aCols aqui
	    If oGetNc != Nil
			oGetNc:aCols := aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,"     ","QPU_CODMED",Len(aSavaHeader[HEAD_NCS])))
			Aadd( aResultados[nPosOpe,_NCO,nPosLab,nPosEns], aClone(oGetNc:aCols) )
		Else
			Aadd( aResultados[nPosOpe,_NCO,nPosLab,nPosEns], aClone(oGetNc:aCols) )
		EndIf*/
	EndIf
EndIf
If lLayout
	aOBJETOS[OBJ_NCC,nPosOpe,nPosLab,1]:Refresh()
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Acerta aCols dos Instrumentos de acordo com o Ensaio.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aResultados[nPosOpe,_INS,nPosLab,nPosEns]) >= nPosMed
	If lLayout
		aOBJETOS[OBJ_INST,nPosOpe,nPosLab,1]:aCols   := aClone(aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed])
	EndIf
Else
	//Acerta aResultados dos Instrumentos
	If lLayout
		Aadd(aResultados[nPosOpe,_INS,nPosLab,nPosEns],aClone(aSavaCols[HEAD_INST]))
		aOBJETOS[OBJ_INST,nPosOpe,nPosLab,1]:aCols   := aClone(aSavaCols[HEAD_INST]) 
/*	Else 
	    // Neste contexto eu não carrego o aCols aqui
	    If oGetINS != Nil
    		oGetINS:aCols   := aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"     ","QPT_CODMED",Len(aSavaHeader[HEAD_INST]))) 
    		Aadd( aResultados[nPosOpe,_INS,nPosLab,nPosEns], aClone(oGetINS:aCols) )
    	Else
    		Aadd( aResultados[nPosOpe,_INS,nPosLab,nPosEns], aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"     ","QPT_CODMED",Len(aSavaHeader[HEAD_INST]))) )
    	EndIf*/
	EndIf
EndIf
If lLayout
	aOBJETOS[OBJ_INST,nPosOpe,nPosLab,1]:Refresh()
EndIf

nNCO  := 1
nNCOA := 1

If lLayout
	QP215ChgNco(nOperacao,nFldLab,nEnsaio,nMedicao,nNCO)     
Else                                                         
	QP215ChgNco(nPosOpe,nPosLab,nPosEns,nPosMed,nNCO)     
EndIf

//Atualiza a tela de sequencia 
If lLayout
	QP215Seq(aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio])
EndIf

Return(.T.)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgNco³ Autor ³Cleber L. Souza       ³ Data ³19/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza atualizacao da cronica na mudanca das NCCs         ³±±
±±³			 ³ lizados na rotina de Resultados.							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao						  ³±±
±±³			 ³ EXPN2 = Posicao atual do Laboratorio						  ³±±
±±³			 ³ EXPN3 = Posicao atual do Ensaio							  ³±±
±±³			 ³ EXPN4 = Posicao atual da Medicao							  ³±±
±±³			 ³ EXPN5 = Posicao atual da Nao Conformidader				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ChgNco(nPosOpe,nPosLab,nPosEns,nPosMed,nPosNco)
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

If lLayout
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Acerta Cronica das Nao Conformidades.   					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nPosMed <= Len(aResultados[nPosOpe,_CRO,nPosLab,nPosEns])
		If nPosNco <= Len(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed])
			cTexCro  := aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed,nPosNco,1]
		Else 
			Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed],{})
			Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed,Len(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed])],"")
			cTexCro  := ""
		EndIf
	Else
		Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEns],{})
		Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed],{})
		Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed,Len(aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed])],"")
		cTexCro  := ""
	EndIf
	
	aOBJETOS[OBJ_CRONIC,nPosOpe,nPosLab,1]:Refresh()
EndIf

Return(.T.)                     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChgFNC³ Autor ³Cleber L. Souza       ³ Data ³20/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Realiza a selecao na mudanca de Folder das NCCs            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da NCC								  ³±±
±±³			 ³ EXPN2 = Ultima posicao selecionada da NCC				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIEA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ChgFNC(nNcoGot,nNcoLost) 

Local aAreaAnt := GetArea()          
Local nX     

If nNcoGot == 3
	aTela := aSavTela[nOperacao,2,nFldLab]
	aGets := aSavGets[nOperacao,2,nFldLab]  
	For nX := 1 to Len(aCpoEnc[1])	
		&("M->"+aCpoEnc[1,nX]) := aResultados[nOperacao,_LLA,nFldLab,nX]
	Next nX      
	aObjetos[OBJ_LAUDO,nOperacao,nFldLab,1]:EnchRefreshAll()
ElseIf nNcoLost == 3
	QP215SavResu({SAV_LAUL},.F.)
EndIf

RestArea(aAreaAnt)
Return(.T.)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215SavResu³ Autor ³Cleber L. Souza 		³ Data ³20/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Salva o conteudo dos objetos na array aResultados		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = Opcao dos Objetos q serao salvos					  ³±±
±±³          ³ EXPL1 = Obriga a salvar conteudo dos objetos				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215() 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215SavResu(aOpcSav,lSav)
Local nY := 0
Local nI := 0
Local lRet := .T.
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nPosChv     := 0 

If lLayout
	nPosChv 	:= Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|AllTrim(x[2])=="QPR_CHAVE"})
Else
	nPosEns     := oBrwJJ:nAt // Quando se  clica  direto no Laudo Geral esta  variavel  vem desposicionada
	nPosChv   	:= Ascan(aSavHeadEns[nPosOper,nPosLab,nPosEns,1] ,{|x|AllTrim(x[2])=="QPR_CHAVE"})
EndIf	

For nY:=1 to Len(aOpcSav)

	If aOpcSav[nY] == 1 //Salva dados Objeto Laudo da Operacao

		If lLayout
			If nOperaAnt#nOperacao .or. lSav
	 			Aeval(aCpoLOP[1],{|x,y|aResultados[nOperaAnt,_LOP,y] := M->&(aCpoLOP[1,y])})
	 		    aSavTela[nOperaAnt,1] := aTela
			EndIf
		EndIf
		
	ElseIf aOpcSav[nY] == 2 //Salva dados Objeto Medicoes 
	
		If lLayout
			If nEnsaioA#nEnsaio .or. lSav
				aResultados[nOperacao,_MED,nFldLab,nEnsaioA] := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaioA]:aCols 
			EndIf
	    Else 
		    If Len(aResultados[nPosOper,_MED,nPosLab,oBrwJJ:nAt,1]) == Len(oGetMed:aCols[1])
		    	aResultados[nPosOper,_MED, nPosLab, nPosEns] :=  aClone(oGetMed:aCols)
		    Else                                                                          
			    oGetMed:aCols := aClone(aResultados[nPosOper,_MED, nPosLab, nPosEns])
		    Endif
	    EndIf                            
	    
	ElseIf aOpcSav[nY] == 3 //Salva dados Objetos Nao Conformidades

		If lLayout
			If nMedicaoA#nMedicao .or. nEnsaioA#nEnsaio .or. lSav
				If Len(aResultados[nOperacao,_NCO,nFldLab,nEnsaioA]) >= Len(aResultados[nOperacao,_MED,nFldLab,nEnsaioA])   //Verifica se eh uma linha nova na medicao
					aResultados[nOperacao,_NCO,nFldLab,nEnsaioA,nMedicaoA] := aClone(aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aCols)
				Else
					Aadd(aResultados[nOperacao,_NCO,nFldLab,nEnsaioA],aClone(aSavaCols[HEAD_NCS]))                                                
				EndIF
			EndIf
		EndIf
	
	ElseIf aOpcSav[nY] == 4 //Salva dados do Instrumento

		If lLayout
			If nMedicaoA#nMedicao .or. nEnsaioA#nEnsaio .or. lSav
				If Len(aResultados[nOperacao,_INS,nFldLab,nEnsaioA]) >= Len(aResultados[nOperacao,_MED,nFldLab,nEnsaioA])   //Verifica se eh uma linha nova na medicao
					aResultados[nOperacao,_INS,nFldLab,nEnsaioA,nMedicaoA] := aClone(aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols)
				Else
					Aadd(aResultados[nOperacao,_INS,nFldLab,nEnsaioA],aClone(aSavaCols[HEAD_INST]))   
				EndIF
			EndIf
		EndIf
					
	ElseIf aOpcSav[nY] == 5 //Salva Dados Objetos Cronica
	
		If lLayout
			If nNCOA<nNCO .or. nMedicaoA#nMedicao .or. nEnsaioA#nEnsaio .or. lSav
				If Len(aResultados[nOperacao,_CRO,nFldLab,nEnsaioA]) >= nMedicao
					If Len(aResultados[nOperacao,_CRO,nFldLab,nEnsaioA,nMedicaoA]) >= nNCOA   //Verifica se eh uma linha nova na medicao
						aResultados[nOperacao,_CRO,nFldLab,nEnsaioA,nMedicaoA,nNCOA,1] := cTexCro 
					Else
						Aadd(aResultados[nOperacao,_CRO,nFldLab,nEnsaioA,nMedicaoA],{})
					    Aadd(aResultados[nOperacao,_CRO,nFldLab,nEnsaioA,nMedicaoA,Len(aResultados[nOperacao,_CRO,nFldLab,nEnsaioA,nMedicaoA])],cTexCro)  
	    	        EndIF
				Else
					Aadd(aResultados[nOperacao,_CRO,nFldLab,nEnsaio],{})
					Aadd(aResultados[nOperacao,_CRO,nFldLab,nEnsaio,nMedicao],{})
				    Aadd(aResultados[nOperacao,_CRO,nFldLab,nEnsaio,nMedicao,Len(aResultados[nOperacao,_CRO,nFldLab,nEnsaio,nMedicao])],"")  
	    	    EndIf
				nNCOA := nNCO
			EndIf
		EndIf
				
	ElseIf aOpcSav[nY] == 6 //Salva dados Laudo do Laboratorio 
	    
		If lLayout
			Aeval(aCpoEnc[1],{|x,y|aResultados[nOperacao,_LLA,nFldLab,y] := M->&(aCpoEnc[1,y])})
			aSavTela[nOperacao,2,nFldLab] := aClone(aTela)
		EndIf

	ElseIf aOpcSav[nY] == 7 //Salva dados Laudo Geral da OP
        
		If ExistBlock("QP215J10")
			lRet := ExecBlock("QP215J10",.F.,.F.,{M->QPL_LAUDO, nOpcx, QPK->QPK_OP})
		EndIf
        
		If lRet
			If lLayout
				Aeval(aCpoEnc[1],{|x,y|aResultados[nFldLauGer,1,y] := M->&(aCpoEnc[1,y])})
				aSavTela[nFldLauGer]  := aTela
			Else 
				If Len(aSavGets[1]) <> 0
					For nI := 1 To Len(aSavGets[1,2])
						nY := Ascan(aCpoEnc[1],{|x| Upper(Alltrim(x)) == Upper(Alltrim(Left(Substr(aSavGets[1,2,nI],9),10)))})
						If nY > 0
							aResultados[nFldLauGer,1,nY] := M->&(aCpoEnc[1,nY])
						EndIf
					Next
				EndIf
			EndIf
    	EndIF   
    	
	ElseIf aOpcSav[nY] == 8 //Salva dados da Rastreabilidade    
	
		If lLayout 
    		aResultados[nOperacao,_RAS]  := oGetRast:aCols 
	    EndIf
	    
	EndIf
	
Next nY                                 

Return(.T.)          

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215GrvAll³ Autor ³Cleber Souza          ³ Data ³20/11/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Grava os dados referentes ao Resultado					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Opcao do aRotina									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215GrvAll(nOpc, lLibUrgCan, aTextoCan, cChaveUrg )     

Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nPosOpe   := 0
Local nPosLab   := 0
Local nPosEns   := 0
Local nPosMed   := 0
Local nPosNco   := 0
Local nPosIns   := 0
Local nPosCha   := 0   
Local cNumOp    := QPK->QPK_OP
Local nDel      := 0       
Local nMed      := 0       
Local nRes      := 0                       
Local nFil      := 0
Local cCartEns  := "" 
Local cMedicao  := 0
Local nDtM 	    := 0
Local nHrM	    := 0
Local nAmo      := 0                                                
Local cLabor    := ""
Local cOper     := "" 
Local cEnsaio   := ""
Local cChave    := ""   
Local lLock     := .T.  
Local axTexto   := {}
Local cTexto    := ""    
Local aCpoQNC   := {}
Local cChr      
Local lIntQNC   := If(GetMv("MV_QIPQNC",.F.,"1")=="1",.T.,.F.) // "Integracao com QNC 1-Sim/2-Nao" 
Local lQIP215C  := ExistBlock("QIP215C") 
Local nPosLau   := 0
Local lMedicao  := .F.  
Local nSaveSX8  := GetSX8Len() 
Local nY        := 0
Local nC        := 0
Local nI        := 0
Local nPosPrRas	:= Ascan( aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == "QQG_PRODUT"  } )
Local nPosTiRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_TIPO'		} )
Local nPosQtRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_QTDE' 	} )
Local nPosLoRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LOTE' 	} )
Local nPosLaRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LAUDO'	} )
Local nPosOrRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_ORIGEM'	} ) 
Local nPosDcAne	:= Ascan(aSavaHeader[HEAD_ANEXO],{ |x| AllTrim(x[2]) == 'QQJ_ANEXO'} ) 
Local cVar		:= '' 
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI) 
Local nCpoQQJ   := 0
Local nPosCal	:= 0    
Local cStatus	:= ''		//Inclusao ou Alteracao   
Local cStatus2  := ''		//Inclusao ou Alteracao   
Local lQP215J14	:= ExistBlock("QP215J14")
Local lQP215J9	:= ExistBlock("QP215J9")
Local lQP220Qnc	:= ExistBlock("QP220QNC")
Local cChaveQPU := ""
Local lDelQNC   := Iif(lIntQNC,.F.,.T.)

Default lLibUrgCan := .F.
Default aTextoCan  := {}   
Default cChaveUrg  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a exclusao do Resultado das Medicoes				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (nOpc == 4) 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("QP215DELR")	
		lDadosOk := ExecBlock("QP215DELR",.F.,.F.,{QPK->QPK_OP,QPK->QPK_LOTE,QPK->QPK_NUMSER})
		If !lDadosOk
			Return(NIL)
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclui as medicoes dos Resultados 							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP215DelMed(cNumOp)
	Return(NIL) 
EndIf	

nQtdOpe := Len(aOperacoes)
                               
For nPosOpe := 1 To nQtdOpe
    
	cOper := aResultados[nPosOpe,_OPE]
	
	Begin Transaction

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Grava os dados do laudo da Operacao	 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QPM")
	dbSetOrder(3)
	If dbSeek(xFilial("QPM")+Padr(cNumOp,13)+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+cOper)
		RecLock("QPM",.F.)
		cStatus2 := "A"
	Else
		RecLock("QPM",.T.)
		cStatus2 := "I"
	Endif
	QPM->QPM_FILIAL	:= xFilial("QPM")
	QPM->QPM_PRODUT	:= QPK->QPK_PRODUT
	QPM->QPM_DTPROD	:= QPK->QPK_EMISSA 
	QPM->QPM_NUMSER := QPK->QPK_NUMSER
	QPM->QPM_LOTE	:= QPK->QPK_LOTE 
	QPM->QPM_ROTEIR := cRoteiro
	QPM->QPM_OP 	:= Padr(cNumOp,13)
	QPM->QPM_OPERAC	:= cOper

    If lLayout
		Aeval(aCpoLOp[1],{|x,y| IIF(Alltrim(aCpoLOp[2,y])<>"V",FieldPut(FieldPos(aCpoLOp[1,y]),aResultados[nPosOpe,_LOP,y]),"")})
	Else
		If Len(aSavGets[1]) <> 0
			For nI := 1 To Len(aSavGets[1,1])
				nY := Ascan(aCpoLOp[1],{|x| Upper(Alltrim(x)) == Upper(Alltrim(Left(Substr(aSavGets[1,1,nI],9),10)))})
				If nY > 0 .AND. Alltrim(aCpoLOp[2,nY]) <> "V"
					FieldPut(  FieldPos(Left(Substr(aSavGets[1,1,nY],9),10)) , aResultados[nPosOpe,_LOP,nY])
				EndIf
			Next
		EndIf
	EndIf

	MsUnLock()

	If lQP215J14
		ExecBlock("QP215J14",.F.,.F.,{"QPM",cStatus2})
	EndIf   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³  Grava os dados do laudo do Laboratorio 	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nPosLab:=1 to Len(aResultados[nPosOpe,_LAB])		
	
		cLabor := aResultados[nPosOpe,_LAB,nPosLab]
	
		dbSelectArea("QPL")
		dbSetOrder(3)
		If dbSeek(xFilial("QPL")+Padr(cNumOp,13)+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+aResultados[nPosOpe,_OPE]+cLabor)
			RecLock("QPL",.F.)
			cStatus := "A"
		Else
			RecLock("QPL",.T.)
			cStatus := "I"
		Endif
		QPL->QPL_FILIAL	 := xFilial("QPL")
		QPL->QPL_PRODUT	 := QPK->QPK_PRODUT
		QPL->QPL_DTENTR	 := QPK->QPK_EMISSA
		QPL->QPL_LOTE	 := QPK->QPK_LOTE 
		QPL->QPL_ROTEIRO := cRoteiro 
		QPL->QPL_NUMSER  := QPK->QPK_NUMSER
		QPL->QPL_LABOR	 := cLabor
		QPL->QPL_OP 	 := Padr(cNumOp,13)
		QPL->QPL_OPERAC	 := cOper
        
		If lLayout
			Aeval(aCpoEnc[1],{|x,y| IIF(Alltrim(aCpoEnc[2,y])<>"V",FieldPut(FieldPos(aCpoEnc[1,y]),aResultados[nPosOpe,_LLA,nPosLab,y]),"")})        
		Else
			// Tirar do Aeval
			If Len(aSavGets[1]) <> 0
				For nI := 1 To Len(aSavGets[1,2])
					nY := Ascan(aCpoEnc[1],{|x| Upper(Alltrim(x)) == Upper(Alltrim(Left(Substr(aSavGets[1,2,nI],9),10)))})
					If nY > 0 .AND. Alltrim(aCpoEnc[2,nY]) <> "V"
						FieldPut(  FieldPos(Left(Substr(aSavGets[1,2,nY],9),10)) , aResultados[nPosOpe,_LLA,nPosLab,nY])
					EndIf
				Next
			EndIf
		EndIf
		MsUnLock()       
	
		If lQP215J14
			ExecBlock("QP215J14",.F.,.F.,{"QPL",cStatus})
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Gravacao das medicoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nPosEns:=1 To Len(aResultados[nPosOpe,_ENS,nPosLab])  
		   
			If lLayout		
				aHeadEns := aClone(aSavHeadEns[nPosOpe,nPosLab,nPosEns])
				cEnsaio  := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]
			Else 
//				Q216ARESU(nPosOpe, nPosLab, nPosEns)
				aSavHeadEns	:= aClone(aSavHeadBkp)
				aHeadEns 	:= aClone(aSavHeadEns[nPosOpe,nPosLab,nPosEns])
				cEnsaio  	:= aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]			
			EndIf
			
			For nPosMed:=1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])  
			    
				nDel     := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed])
				cCartEns := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]
				nPosCha  := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_CHAVE"})
							
				If cCartEns == "TXT"	                                                
					nPosRes  := aScan(aHeadEns[1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
					nMed     := aScan(aHeadEns[1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
				Else
					nPosRes  := aScan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_RESULT"})
					If cCartEns == "P  "
						nMed     := aScan(aHeadEns[1],{|x|Alltrim(x[2])=="QPS_MEDIPA"})
					Else 
						nMed     := aScan(aHeadEns[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
					EndIf
				EndIf

				nEns     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_ENSR"})
				cMedicao := Iif(Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])=="N",;
                                    Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed]),;
				                        aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])
			    
				If	!aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDel] 		.And.; //Medicao nao deletada
					!Empty(cMedicao)										 		.And.; //Medicao preenchida
					!Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nEns])	.And. ;//Ensaiador preenchido
					!Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosRes])	   //Resultado preenchido
									
					nDtM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
					nHrM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})
					nAmo	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_AMOSTR"})
					nFil    := 	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_FILMAT"})

					If Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDtM]) == "C"
						aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDtM] := CTOD(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDtM])
					EndIf
				
					If Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nAmo]) <> "N"
						aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nAmo] := Val(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nAmo])
					EndIf
				
					// Troca de conceito na gravacao devido a duplicacao do QES
					DbSelectArea("QPR")
					dbSetOrder(4) 
					If Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosCha]) // Caso nao exista chave de gravacao no QES
						RecLock("QPR",.T.)
						cStatus := "I"
						QPR->QPR_FILIAL	:= xFilial("QPR")
						QPR->QPR_PRODUT	:= QPK->QPK_PRODUT
					Else
						If dbSeek(xFilial("QPR")+aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosCha])
							RecLock("QPR",.F.)    
							cStatus := "A"						
						Else
							RecLock("QPR",.T.)
							cStatus := "I"
							QPR->QPR_FILIAL	:= xFilial("QPR")
							QPR->QPR_PRODUT	:= QPK->QPK_PRODUT
						EndIf
					EndIf
					
					QPR->QPR_REVI	:= Iif(!Empty(QPR->QPR_REVI),QPR->QPR_REVI,Iif(!Empty(QPK->QPK_REVI),QPK->QPK_REVI,QA_UltRvQ(QPK->QPK_PRODUT)))
					QPR->QPR_DTENTR	:= QPK->QPK_EMISSA
					QPR->QPR_LOTE	:= QPK->QPK_LOTE
					QPR->QPR_NUMSER	:= QPK->QPK_NUMSER
					QPR->QPR_ROTEIR	:= cRoteiro
					QPR->QPR_LABOR	:= cLabor
					QPR->QPR_ENSAIO	:= aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]
					QPR->QPR_OP		:= Padr(cNumOp,13)
					QPR->QPR_OPERAC	:= cOper
					QPR->QPR_CLIENT := cIPCLIENT
					QPR->QPR_LOJA   := cIPLoj   
					QPR->QPR_RESULT := aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosRes]
					QPR->QPR_FILMAT := aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nFil]
					     
 					For nY:=1 to Len(aHeadEns[1]) 
						If aHeadEns[1,nY,10]#"V" .and. !(Substr(aHeadEns[1,nY,2],1,3)$("QPS,QPQ"))
							&("QPR->"+Alltrim(aHeadEns[1,nY,2])) := aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nY]
						EndIF
	                Next nY
					
					If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosCha])
						cChave := aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosCha]
					Else
						cChave := QA_SXESXF("QPR","QPR_CHAVE",,4)
						While ( GetSX8Len() > nSaveSx8 )
							ConfirmSX8()
						EndDo
					EndIf
					QPR->QPR_CHAVE  := cChave
					lMedicao         := .T.                     

					MsUnLock()
					FKCOMMIT()
					
					QPR->(dbSetOrder(9))
					If lQP215J9
						ExecBlock("QP215J9",.F.,.F.,{"QPR",cStatus})
					EndIf
				
					If cCartEns <> "TXT" // Carta do ensaio
						
						dbSelectArea("QPS")
						dbSetOrder(1)
						If dbSeek(xFilial("QPS")+cChave)
							lLock   := .F.
							cStatus := "A"
						Else
							lLock := .T. 
							cStatus := "I"
						EndIf
						nQtdMed := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,QTDMED] 

						If cCartEns <> "TMP"
							For nY := 1 To nQtdMed
								If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1])
									RecLock("QPS",lLock)
									If lLock
										QPS->QPS_FILIAL := xFilial("QPS")
										QPS->QPS_CODMED := cChave
									EndIf
									If cCartEns <> "P  "
										QPS->QPS_MEDICA := Iif(Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1])=='N',Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1]),aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1])
									Else 
										nPosCal	:= ascan(aHeadEns[1], { |x| alltrim(x[2]) == 'QPS_CALPOR' })
										If nY == 1
											QPS->QPS_INDMED := "A"
										Elseif nY == 2 .And. aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nPosCal] == "S"   
											QPS->QPS_INDMED := "N"
										Elseif nY == 3
											QPS->QPS_INDMED := "P"
										EndIf
										If nY == 4
											QPS->QPS_MEDICA := StrTran(Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1],TamSx3("QPS_MEDICA")[1],2),".",",")
										Else
											QPS->QPS_MEDICA := Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,(nMed+nY)-1],TamSx3("QPS_MEDICA")[1],TamSx3("QPS_MEDIPP")[2])
										EndIf
									Endif
									MsUnLock()
									dbSkip()
								EndIf
							Next nY
							If lQP215J9
								ExecBlock("QP215J9",.F.,.F.,{"QPS",cStatus,cChave})
							EndIf
						Else
							If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])
								RecLock("QPS",lLock)
								If lLock
									QPS->QPS_FILIAL := xFilial("QPS")
									QPS->QPS_CODMED := cChave
								EndIf
								QPS->QPS_MEDICA := Iif(Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])=='N',AllTrim(Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])),AllTrim(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed]))
								MsUnLock() 
								FKCOMMIT()
								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QPS",cStatus,cChave})
								EndIf
							EndIf
						EndIf
					Else
						If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])
							dbSelectArea("QPQ")
							dbSetOrder(1)
							If dbSeek(xFilial("QPQ")+cChave)
								RecLock("QPQ",.F.)
							Else
								RecLock("QPQ",.T.)
								QPQ->QPQ_FILIAL := xFilial("QPQ")
								QPQ->QPQ_CODMED := cChave
							EndIf
							QPQ->QPQ_MEDICA := aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed]  
							MsUnLock()
							If lQP215J9
								ExecBlock("QP215J9",.F.,.F.,{"QPQ",cStatus,cChave})
							EndIf
						EndIf
					EndIf          
					
					aNCOSav   := {}
					aNCOSav   := aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,cChave,"QPU_CODMED",Len(aSavaHeader[HEAD_NCS])))
					aINSSav   := {}
					aINSSav   := aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,cChave,"QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
										
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava Nao Conformidades         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QPU")
					dbSetOrder(1)
					For nPosNco := 1 To Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed]) // Numero de Ncos
					 	nDel := Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco])
						If !aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nDel] .And.;
								QP215ChkGd(2,.F.,nPosOpe,nPosLab,nPosEns,nPosMed,nPosNco,,.T.) // Nao deletado e Nao Vazio 
							If dbSeek(xFilial("QPU")+cChave+aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1])
								RecLock("QPU",.F.)               
								cStatus := "A"
							Else
								RecLock("QPU",.T.)
								QPU->QPU_FILIAL := xFilial("QPU")
								QPU->QPU_CODMED := cChave
								cStatus := "I"
							EndIf  
		
							For nY:=1 to Len(aSavaHeader[HEAD_NCS]) 
								If aSavaHeader[HEAD_NCS,nY,10]#"V" 
									&("QPU->"+Alltrim(aSavaHeader[HEAD_NCS,nY,2])) := aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nY]
								EndIF
			                Next nY
							
							MsUnLock() 
                            FKCOMMIT()
                            
							If  Empty(QPU->QPU_CHAVE)
								cChaveQPU := QA_NewChave("QPU",3)
								
								RecLock("QPU",.F.)
								QPU->QPU_CHAVE  := cChaveQPU
								MsUnLock() 
	                            FKCOMMIT()

							Endif

							If lQP215J9
								ExecBlock("QP215J9",.F.,.F.,{"QPU",cStatus,cChave})
							EndIf
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Grava o texto da Nco ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If Len(aResultados[nPosOpe,_CRO,nPosLab,nPosEns]) >= nPosMed
								axTexto := {}  
							   	If Len(aResultados[nPosOpe,6,nPosLab,nPosEns,nPosMed]) >= nPosNco
							   		cTexto := aResultados[nPosOpe,_CRO,nPosLab,nPosEns,nPosMed,nPosNco,1]  
							   	Else
							   		cTexto := ""
							   	EndIf
								Aadd(axTexto,{1,cTexto})
								Qa_GrvTxt(QPU->QPU_CHAVE,"QIPA210C",1,axTexto,"QA2", 68)   
	
								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QA2",axTexto,QPU->QPU_CHAVE})
								EndIf
							EndIf

   							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ 			Integracao  QIP x QNC					     ³                                       
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
								cQNCVeri :=	"QNCVERI(QPU->QPU_CODNC, QPU->QPU_REVNC, 'QIP')"
							Else 
								cQNCVeri := ".T."	
							EndIf
							If lIntQNC .AND. &cQNCVeri
								//Se existirem os novos campos realiza a integracao
								aStrQPU := QPU->(dbStruct())
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Caso haja alteracao no Resultado, apaga a NC corrente    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
									aCpoQNC := {}
								    Aadd(aCpoQNC,xFilial("QI2"))
					   				Aadd(aCpoQNC,QPU->QPU_CODNC)
									Aadd(aCpoQNC,QPU->QPU_REVNC)
									If !lQP220Qnc
										QNCGERA(2,aCpoQNC)
			   						Else 
										ExecBlock("QP220QNC",.f.,.f.,{aCpoQNC,QPU->QPU_CHAVE,"E"})
			   						EndIF
								EndIf 
								aCpoQNC := {}
								cChr    := Chr(13)+Chr(10)
								Aadd(aCpoQNC,{"QI2_MEMO1"	,cTexto})
			   					Aadd(aCpoQNC,{"QI2_ORIGEM"	,"QIP"})
			   					Aadd(aCpoQNC,{"QI2_TPFIC"	,"2"})
			   					Aadd(aCpoQNC,{"QI2_CODPRO"	,QPK->QPK_PRODUT})
			   					Aadd(aCpoQNC,{"QI2_LOTE"	,QPK->QPK_lote}) 
			   					Aadd(aCpoQNC,{"QI2_QTDPRO"	,Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])}) 
			   					Aadd(aCpoQNC,{"QI2_DESCR"	,STR0073+AllTrim(QPK->QPK_PRODUT)+"  "+STR0074+QPR->QPR_REVI}) //"Produto: "###"Revisao: "
			   					
								cTxtNC := STR0075+AllTrim(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1])+" - "+;  //"Nao-Conformidade: "
	   							AllTrim(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,2])+cChr
								cTxtNC += AllTrim(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,5])+cChr
								cTxtNC += STR0076+cOper+cChr  //"Operacao: "
								cTxtNC += STR0077+AllTrim(QPR->QPR_ENSAIO)+STR0078+AllTrim(QPR->QPR_LABOR) //"Ensaio: "###" Laboratorio: " //"Ensaio: "###" Laboratorio: "
								
								Aadd(aCpoQNC,{"QI2_MEMO2"	,cTxtNC})
		   	 		     		Aadd(aCpoQNC,{"QI2_FILMAT"	,QPR->QPR_FILMAT})
								Aadd(aCpoQNC,{"QI2_MAT"		,QPR->QPR_ENSR}) 
								Aadd(aCpoQNC,{"QI2_OCORRE"	,QPR->QPR_DTMEDI})
								Aadd(aCpoQNC,{"QI2_UNIMED"	,QPK->QPK_UM})
								Aadd(aCpoQNC,{"QI2_ANO"		,Year(QPR->QPR_DTMEDI)})

				   				QAA->(dbSetOrder(1))
								If QAA->(dbSeek(QPR->QPR_FILMAT+QPR->QPR_ENSR))
			   					    Aadd(aCpoQNC,{"QI2_MATDEP"	,QAA->QAA_CC})
			   					    Aadd(aCpoQNC,{"QI2_FILDEP"	,QPR->QPR_FILMAT})
			   					    Aadd(aCpoQNC,{"QI2_ORIDEP"	,QAA->QAA_CC})
			   					    Aadd(aCpoQNC,{"QI2_FILORI"	,QPR->QPR_FILMAT})
								EndIf
		   						If !lQP220Qnc
							    	aRetQNC := QNCGERA(1,aCpoQNC)
									RecLock("QPU",.F.)
									QPU->QPU_CODNC := aRetQNC[2] //Codigo da Nao-conformidade
									QPU->QPU_REVNC := aRetQNC[3] //Revisao da Nao-conformidade
			   						QPU->(MsUnLock())
			   					Else 
									ExecBlock("QP220QNC",.f.,.f.,{aCpoQNC,QPU->QPU_CHAVE,"I"})
			   					EndIF
							Endif
						Else
							If dbSeek(xFilial("QPU")+cChave+aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1])
                                
								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QPU","D"})
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ 			Integracao  QIP x QNC					     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
									cQNCVeri :=	"QNCVERI(QPU->QPU_CODNC, QPU->QPU_REVNC, 'QIP')"
								Else 
									cQNCVeri := ".T."	
								EndIf
								
								If lIntQNC .AND. &cQNCVeri
	
									//Se existirem os novos campos, envia os mesmos para a exclusao das NC's
									aStrQPU := QPU->(dbStruct())
									aCpoQNC := {}
								    Aadd(aCpoQNC,xFilial("QI2"))
		   							Aadd(aCpoQNC,QPU->QPU_CODNC) 
									Aadd(aCpoQNC,QPU->QPU_REVNC)
									If !lQP220Qnc
										QNCGERA(2,aCpoQNC)
			   						Else 
										ExecBlock("QP220QNC",.f.,.f.,{aCpoQNC,QPU->QPU_CHAVE,"E"})
			   						EndIF          
			   						lDelQNC   := .T.
			   					Elseif lIntQNC
			   						If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
				   						lDelQNC   := .F.
				   						MsgAlert(STR0230+QPU->QPU_NAOCON+STR0231+QPU->QPU_CODNC+"/"+QPU->QPU_REVNC+STR0232) //"Nao foi possivel excluir a nao conformidade ( "###" ), pois, existe uma FNC ( "###" ) relacionada com status diferente de 'Registrada'"
				   						aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nDel] := .F.
				   					Else  
				   						lDelQNC   := .T.
				   					EndIf
								Endif
							
								If lDelQNC
									RecLock("QPU",.F.)
									dbDelete()
									MsUnLock()
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Deleta cada texto ligado a cada nco ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									axTexto := {}
									Aadd(axTexto,{1, "" })  // Deleta o Texto
									Qa_GrvTxt(QPU->QPU_CHAVE,"QIPA210C",1,axTexto,"QA2", 68)
								EndIf	
								
							EndIf
						EndIf
					Next nPosNco
					If !lLayout

						For nPosNco := 1 To Len(aNCOSav) // Numero de Ncos
							
							If aScan(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed],{|x|x[1]==aNCOSav[nPosNco,1]}) <= 0 .AND. dbSeek(xFilial("QPU")+cChave+aNCOSav[nPosNco,1]) 
                                
								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QPU","D"})
								EndIf

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ 			Integracao  QIP x QNC					     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
									cQNCVeri :=	"QNCVERI(QPU->QPU_CODNC, QPU->QPU_REVNC, 'QIP')"
								Else 
									cQNCVeri := ".T."	
								EndIf
								
								If lIntQNC .AND. &cQNCVeri
	
									//Se existirem os novos campos, envia os mesmos para a exclusao das NC's
									aStrQPU := QPU->(dbStruct())
									aCpoQNC := {}
								    Aadd(aCpoQNC,xFilial("QI2"))
		   							Aadd(aCpoQNC,QPU->QPU_CODNC) 
									Aadd(aCpoQNC,QPU->QPU_REVNC)
									If !lQP220Qnc
										QNCGERA(2,aCpoQNC)
			   						Else 
										ExecBlock("QP220QNC",.f.,.f.,{aCpoQNC,QPU->QPU_CHAVE,"E"})
			   						EndIF          
			   						lDelQNC   := .T.
			   					Elseif lIntQNC
			   						If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
				   						lDelQNC   := .F.
				   						MsgAlert(STR0230+QPU->QPU_NAOCON+STR0231+QPU->QPU_CODNC+"/"+QPU->QPU_REVNC+STR0232) //"Nao foi possivel excluir a nao conformidade ( "###" ), pois, existe uma FNC ( "###" ) relacionada com status diferente de 'Registrada'"
				   						aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nDel] := .F.
				   					Else  
				   						lDelQNC   := .T.
				   					EndIf
								Endif
							
								If lDelQNC
									RecLock("QPU",.F.)
									dbDelete()
									MsUnLock()
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Deleta cada texto ligado a cada nco ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									axTexto := {}
									Aadd(axTexto,{1, "" })  // Deleta o Texto
									Qa_GrvTxt(QPU->QPU_CHAVE,"QIPA210C",1,axTexto,"QA2", 68)
								EndIf	
								
							EndIf

					    Next

					EndIf
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava os intrumentos utilizados ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("QPT")
					dbSetOrder(1)
					For nPosIns := 1 To Len(aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed])
					 	nDel := Len(aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed,nPosIns])
						If !aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed,nPosIns,nDel] .And.;
							QP215ChkGd(3,.F.,nPosOpe,nPosLab,nPosEns,nPosMed,nPosNco,nPosIns,.T.) // Nao deletado e Nao Vazio  

							If dbSeek(xFilial("QPT")+QPR->QPR_CHAVE+aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed,nPosIns,1])
								RecLock("QPT",.F.)  
								cStatus := "A"
							Else
								RecLock("QPT",.T.)               
								cStatus := "I"
								QPT->QPT_FILIAL := xFilial("QPT")
								QPT->QPT_CODMED := QPR->QPR_CHAVE 
							EndIf

							For nY:=1 to Len(aSavaHeader[HEAD_INST]) 
								If aSavaHeader[HEAD_INST,nY,10]#"V" .and. Alltrim(aSavaHeader[HEAD_INST,nY,2])#"QPT_CODMED"
									&("QPT->"+Alltrim(aSavaHeader[HEAD_INST,nY,2])) := aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed,nPosIns,nY]
								EndIF
			                Next nY
							MsUnLock()                                
							If lQP215J9
								ExecBlock("QP215J9",.F.,.F.,{"QPT",cStatus})
							EndIf

						Else
							If dbSeek(xFilial("QPT")+QPR->QPR_CHAVE+aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed,nPosIns,1])
								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QPT","D"})
								EndIf
								RecLock("QPT",.F.)
								dbDelete()
								MsUnLock()
							EndIf
						EndIf
					Next nPosIns

					If !lLayout

						For nPosIns := 1 To Len(aINSSav) // Numero de Ncos
							
							If aScan(aResultados[nPosOpe,_INS,nPosLab,nPosEns,nPosMed],{|x|x[1]==aINSSav[nPosIns,1]}) <= 0 .AND. dbSeek(xFilial("QPU")+cChave+aINSSav[nPosIns,1]) 

								If lQP215J9
									ExecBlock("QP215J9",.F.,.F.,{"QPT","D"})
								EndIf

								RecLock("QPT",.F.)
								dbDelete()
								MsUnLock()

 							EndIf

 						Next

					EndIf
				
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Deleta a cabecalho ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nDtM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
					nHrM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})
					nAmo	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_AMOSTR"})
                    nEns	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_ENSR"})
				
					dbSelectArea("QPR")
					dbSetOrder(9)
					If dbSeek(xFilial("QPR")+Padr(cNumOp,13)+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+cOper+cLabor+cEnsaio+Dtos(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDtM])+;
							aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nHrM]+;
							Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nAmo],1))
							
						If lQP215J9
							ExecBlock("QP215J9",.F.,.F.,{"QPR","D"})
						EndIf

						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deleta medicoes ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If cCartEns <> "TXT" // Carta do ensaio
							dbSelectArea("QPS")
							dbSetOrder(1)
							If dbSeek(xFilial("QPS")+QPR->QPR_CHAVE)
								While !Eof() .And. xFilial("QPS")+QPR->QPR_CHAVE ==;
										QPS->QPS_FILIAL+QPS->QPS_CODMED
									RecLock("QPS",.F.)
									DbDelete()
									MsUnLock()
									dbSkip()
								EndDo
							EndIf
						Else
							dbSelectArea("QPQ")
							dbSetOrder(1)
							If dbSeek(xFilial("QPQ")+QPR->QPR_CHAVE)
								While !Eof() .And. xFilial("QPQ")+QPR->QPR_CHAVE ==;
										QPQ->QPQ_FILIAL+QPQ->QPQ_CODMED
									RecLock("QPQ",.F.)
									DbDelete()
									MsUnLock()
									dbSkip()
								EndDo
							EndIf
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deleta Nao conformidades ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("QPU")
						dbSetOrder(1)
						If dbSeek(xFilial("QPU")+QPR->QPR_CHAVE)
							While !Eof() .And. xFilial("QPU")+QPR->QPR_CHAVE ==;
									QPU->QPU_FILIAL+QPU->QPU_CODMED
								RecLock("QPU",.F.)
								dbDelete()
								MsUnLock()
								dbSkip()
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Deleta cada texto ligado a cada nco ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								axTexto := {}
								Aadd(axTexto,{ 1,"" })  // Deleta o Texto
								Qa_GrvTxt(QPU->QPU_CHAVE,"QIPA210C",1,axTexto,"QA2", 68)
							EndDo
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Deleta os instrumentos ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dbSelectArea("QPT")
						dbSetOrder(1)
						If dbSeek(xFilial("QPT")+QPR->QPR_CHAVE)
							While !Eof() .And. xFilial("QPT")+QPR->QPR_CHAVE == ;
									QPT->QPT_FILIAL+QPT->QPT_CODMED
								RecLock("QPT",.F.)
								dbDelete()
								MsUnLock()
								dbSkip()
							EndDo
						Endif
						RecLock("QPR",.F.)
						dbDelete()
						MsUnLock()
					EndIf
				EndIf
			Next nPosMed                         
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava dos doctos anexos.		³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nY:=1 to Len(aResultados[nPosOpe,_ANE,nPosLab,nPosEns])
				If !aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,Len(aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY])]
					If Substr(aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nPosDcAne],1,3)=="TMP"
						//Rotina q renomeia o anexo e sobre o arquivo para o server
						cNewAne := QepAdmAne(aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nPosDcAne],1,"QIP")
						If !Empty(cNewAne)
							dbSelectArea("QQJ")
							dbSetOrder(1)
							If !dbSeek(xFilial("QQJ")+cOper+aResultados[nPosOpe,_LAB,nPosLab]+aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]+PadR(cNumOp,13)+cNewAne)
								RecLock("QQJ",.T.)
								QQJ->QQJ_FILIAL  := xFilial("QQJ")
								QQJ->QQJ_OPERAC  := cOper
								QQJ->QQJ_LABOR   := aResultados[nPosOpe,_LAB,nPosLab]
								QQJ->QQJ_ENSAIO  := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]
								QQJ->QQJ_OP      := QPK->QPK_OP
								QQJ->QQJ_ANEXO   := cNewAne
							    For nCpoQQJ := 1 to Len(aSavaHeader[HEAD_ANEXO])   
									If (AllTrim(aSavaHeader[HEAD_ANEXO,nCpoQQJ,2]) <> "QQJ_ANEXO")
										If (aSavaHeader[HEAD_ANEXO,nCpoQQJ,10] <> "V") 
											QQJ->(FieldPut(FieldPos(AllTrim(aSavaHeader[HEAD_ANEXO,nCpoQQJ,2])),aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nCpoQQJ]))
										EndIf                                       
									EndIf
								Next nCpoQQJ
								MsUnlock() 
							EndIf
						EndIf
					EndIf
				Else	
					If Substr(aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nPosDcAne],1,3)#"TMP"
						dbSelectArea("QQJ")
						dbSetOrder(1)
						If dbSeek(xFilial("QQJ")+cOper+aResultados[nPosOpe,_LAB,nPosLab]+aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]+PadR(cNumOp,13)+aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nPosDcAne])
							RecLock("QQJ",.F.)
							dbDelete()
							MsUnlock()
							cNewAne := QepAdmAne(aResultados[nPosOpe,_ANE,nPosLab,nPosEns,nY,nPosDcAne],2,"QIP")
						EndIF
					EndIf
				EndIf
			Next nY
			//Fim da Gravacao Documento Anexo
		
		Next nPosEns
   	Next nPosLab 

	For nI := 1 to Len(aResultados[nPosOpe,_RAS])   
	
		dbSelectArea("QQG")
		dbSetOrder(1)
		If !(aResultados[nPosOpe,_RAS,nI,Len(aSavaHeader[HEAD_RASTRO])+1] ) .and. !Empty(aResultados[nPosOpe,_RAS,nI,nPosLoRas]) .And. !lNoGravRast	//Verifica se est  deletado.
			//ConOut("Gravar  Rastro")
			QQ2->(dbSetOrder(1))
			If QQ2->(dbSeek(xFilial("QQ2")+QPK->QPK_PRODUT+QPK->QPK_REVI+cRoteiro+cOper+aResultados[nPosOpe,_RAS,nI,nPosPrRas]))

				dbSelectArea("QQG")
				If dbSeek(xFilial("QQG")+QPK->QPK_OP+cOper+aResultados[nPosOpe,_RAS,nI,nPosPrRas]+aResultados[nPosOpe,_RAS,nI,nPosLoRas])
					RecLock("QQG",.F.)
				Else
					RecLock("QQG",.T.)
					QQG->QQG_FILIAL	:= xFilial("QQG")
					QQG->QQG_OP		:= QPK->QPK_OP
					QQG->QQG_OPERAC	:= cOper
					QQG->QQG_PRODUT	:= aResultados[nPosOpe,_RAS,nI,nPosPrRas]
					QQG->QQG_RASTRO	:= QPK->QPK_PRODUT  
					QQG->QQG_REVI	:= QQ2->QQ2_REVI
				EndIf	
				QQG->QQG_TIPO	:= aResultados[nPosOpe,_RAS,nI,nPosTiRas]
				QQG->QQG_QTDE	:= aResultados[nPosOpe,_RAS,nI,nPosQtRas]
				QQG->QQG_LOTE	:= aResultados[nPosOpe,_RAS,nI,nPosLoRas]
				QQG->QQG_LAUDO	:= aResultados[nPosOpe,_RAS,nI,nPosLaRas]
				QQG->QQG_ORIGEM	:= Iif(aResultados[nPosOpe,_RAS,nI,nPosOrRas]=="1","QIE","QIP")
				For nC := 1 To Len(aSavaHeader[HEAD_RASTRO])
					If aSavaHeader[HEAD_RASTRO,nC,10] <> 'V'
						cVar := alltrim(aSavaHeader[HEAD_RASTRO,nC,2])
						Replace &cVar. With aResultados[nPosOpe,_RAS,nI,nC]
					EndIf
				Next nC
   				MsUnlock()  
			Else                   
				If GetMv("MV_QQ2CONR",.F.,.F.) // Caso o ponto exista eu não consisto se existe  na QQ2
					dbSelectArea("QQG")
					If dbSeek(xFilial("QQG")+QPK->QPK_OP+cOper+aResultados[nPosOpe,_RAS,nI,nPosPrRas]+aResultados[nPosOpe,_RAS,nI,nPosLoRas])
						RecLock("QQG",.F.)
					Else
						RecLock("QQG",.T.)
						QQG->QQG_FILIAL	:= xFilial("QQG")
						QQG->QQG_OP		:= QPK->QPK_OP
						QQG->QQG_OPERAC	:= cOper
						QQG->QQG_PRODUT	:= aResultados[nPosOpe,_RAS,nI,nPosPrRas]
						QQG->QQG_RASTRO	:= QPK->QPK_PRODUT  
						QQG->QQG_REVI	:= QQ2->QQ2_REVI
					EndIf	
					QQG->QQG_TIPO	:= aResultados[nPosOpe,_RAS,nI,nPosTiRas]
					QQG->QQG_QTDE	:= aResultados[nPosOpe,_RAS,nI,nPosQtRas]
					QQG->QQG_LOTE	:= aResultados[nPosOpe,_RAS,nI,nPosLoRas]
					QQG->QQG_LAUDO	:= aResultados[nPosOpe,_RAS,nI,nPosLaRas]
					QQG->QQG_ORIGEM	:= Iif(aResultados[nPosOpe,_RAS,nI,nPosOrRas]=="1","QIE","QIP")
					For nC := 1 To Len(aSavaHeader[HEAD_RASTRO])
						If aSavaHeader[HEAD_RASTRO,nC,10] <> 'V'
							cVar := alltrim(aSavaHeader[HEAD_RASTRO,nC,2])
							Replace &cVar. With aResultados[nPosOpe,_RAS,nI,nC]
						EndIf
					Next nC
	   				MsUnlock()  
				EndIf
			EndIf
		
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cancela a Rastreabilidade  no Arquivo QQG    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If dbSeek(xFilial("QQG")+QPK->QPK_OP+cOper+aResultados[nPosOpe,_RAS,nI,nPosPrRas]+aResultados[nPosOpe,_RAS,nI,nPosLoRas])
				RecLock("QQG",.F.)
				dbDelete()
				MsUnlock()
			EndIf
		EndIf
	Next nI 
	
	End Transaction
Next nPosOpe
               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Grava os dados do laudo Geral			 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aResultados[nFldLauGer,1,3])
		dbSelectArea("QPL")
		dbSetOrder(3)
		If dbSeek(xFilial("QPL")+Padr(cNumOp,13)+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+Space(TamSx3("QPL_OPERAC")[1])+Space(TamSx3("QPL_LABOR")[1]))	
			RecLock("QPL",.F.)
			cStatus := "A"
		Else
			RecLock("QPL",.T.)
			cStatus := "I"
		Endif
		QPL->QPL_FILIAL	:= xFilial("QPL")
		QPL->QPL_PRODUT	:= QPK->QPK_PRODUT
		QPL->QPL_DTENTR	:= QPK->QPK_EMISSA
		QPL->QPL_LOTE	:= QPK->QPK_LOTE 
		QPL->QPL_OP 	:= Padr(cNumOp,13)
		QPL->QPL_OPERAC	:= Space(02)
		QPL->QPL_ROTEIRO := cRoteiro 
		QPL->QPL_NUMSER  := QPK->QPK_NUMSER
		
		If lLayout
			Aeval(aCpoEnc[1],{|x,y| IIF(Alltrim(aCpoEnc[2,y])<>"V",FieldPut(FieldPos(aCpoEnc[1,y]),aResultados[nFldLauGer,1,y]),"")})
		Else
			For nI := 1 To Len(aSavGets[1,2])
				nY := Ascan(aCpoEnc[1],{|x| Upper(Alltrim(x)) == Upper(Alltrim(Left(Substr(aSavGets[1,2,nI],9),10)))})
				If nY > 0 .AND. Alltrim(aCpoEnc[2,nY]) <> "V"
					FieldPut(  FieldPos(Left(Substr(aSavGets[1,2,nY],9),10)) , aResultados[nFldLauGer,1,nY])
				EndIf
			Next
		EndIf	
		MsUnLock()       
		If lQP215J14
			ExecBlock("QP215J14",.F.,.F.,{"QPL",cStatus})
		EndIf
	Else
		dbSelectArea("QPL")
		dbSetOrder(3)
		If dbSeek(xFilial("QPL")+Padr(cNumOp,13)+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro+Space(TamSx3("QPL_OPERAC")[1])+Space(TamSx3("QPL_LABOR")[1]))	
			If lQP215J14
				ExecBlock("QP215J14",.F.,.F.,{"QPL","D"})
			EndIf
	
			RecLock("QPL",.F.)
			dbDelete()
			MsUnLock()
	    EndIF    
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o Laudo do Laboratorio no QPK- Caso nao tenha o laudo final³
	//³ eh gravado '0'													 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("QPK",.F.)
	QPK->QPK_LAUDO := Iif(!Empty(aResultados[nFldLauGer,1,3]),aResultados[nFldLauGer,1,3],"0")
	IIF(Empty(QPK->QPK_CERQUA) .and. !Empty(aResultados[nFldLauGer,1,3]), QPK->QPK_CERQUA := QA_SEQUSX6("QIP_CEQU",TamSX3("C2_CERQUA")[1],"S",STR0079),.T.)  //"Certificado Qualidade"
	IIF(Empty(QPK->QPK_REVI),	QPK->QPK_REVI := QA_UltRvQ(QPK->QPK_PRODUT,,.F.),.T.) 
	If !lLayout .AND. !lLibUrgCan .AND. lLiberaUrg
		QA_GrvTxt(cChaveUrg,"QIPA210U",1,@aTextoCan)
		QPK->QPK_CHAVE := cChaveUrg
	EndIf
	IIF(!lLiberaUrg .AND. !(QPK->QPK_LAUDO $ cFatLU),QPK->QPK_CHAVE := "",.T.)
	MsUnLock()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a indisponibilidade da Ordem de Producao, atraves do parametro "MV_QPINDIS" ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aResultados[nFldLauGer,1,3])
		If aResultados[nFldLauGer,1,3] $ GetMv("MV_QPINDIS")
		 
			//Posiciona na Ordem de Producao
			dbSelectArea("SC2")
			dbSetOrder(1)
			dbSeek(xFilial("SC2")+QPK->QPK_OP)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Selecao da Indisponibilidade da Ordem de Producao            ³
			//³ mv_par01: Indisponibilizacao da O.P.                         ³
			//³           - Encerrar         							     ³
			//³           - Suspender                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SD3->(dbSetOrder(1))
			If SD3->(dbSeek(xFilial("SD3")+QPK->QPK_OP))
				Pergunte("QPA222",.T.)
				If mv_par01 == 1
					If !Empty(SC2->C2_DATRF)
			    	    Help(" ",1,"A250ENCERR")
					Else
						aArea	:= GetArea()
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Trata pergunta utilizada no MATA250										  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						Pergunte("MTA250",.F.)
						a250Encer("SD3",Recno(),5)
						RestArea(aArea)
					EndIf
				Else
					RecLock("SC2",.F.)
					SC2->C2_STATUS := "U" //Suspensa
					MsUnlock()
				EndIf
			EndIf
		EndIf
	EndIf
	                        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza campo de situacao da OP.        							      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	If lLayout
		nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
		
		If !lNoGravRast
			QP215AtuSit(aResultados[nFldLauGer,1,nPosLau],lMedicao)
		Endif
	Else                                                                                                   
		If !lMedicao .AND. Len(aOperaFull) <> Len(aOperacoes)
			If QPR->(DbSeek(xFilial("QPR")+PADR(QPK->QPK_OP,TamSX3("QPR_OP")[1])+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro))
				lMedicao := .T.
			EndIf
		EndIf
		nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
		QP215AtuSit(aResultados[nFldLauGer,1,nPosLau],lMedicao)
	EndIf
		

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o campo Resultado, utilizado na consulta de rastreabilidade      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QP6->(dbSeek(xFilial("QP6")+QPK->QPK_PRODUT+Inverte(QPK->QPK_REVI)))
		If Empty(QP6->QP6_RESULT)
			dbSelectArea("QP6")
			Reclock("QP6",.F.)
			QP6->QP6_RESULT := "S"
			MsUnlock()
		EndIF
	EndIf    
                                                                        
	If ExistBlock("QP215R")
		ExecBlock("QP215R",.F.,.F.,{nOpcX})
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Pergunta da impressao do Certificado de Qualidade.					      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aResultados[nFldLauGer,1,3])
		If QP215SelG()
			If lQIP215C
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Ponto de Entrada  para  impressao do Certificado customizado              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		ExecBlock("QIP215C",.F.,.F.,{QPK->QPK_OP})  
		 	Else
				QIPR050()			
			EndIf
		EndIf		
	EndIf

QPR->(dbSetOrder(1))
QPL->(dbSetOrder(1))
QPM->(dbSetOrder(1))

Return(NIL)                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215VldLauºAutor  ³Cleber Sozua       º Data ³  20/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que realiza validacao de todos os campos da Enchoiceº±±
±±º          ³ dos Laudos.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ NIL  													  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Retorno	 ³ EXPL01 = Resultado da Validacao						  	  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VldLau()

Local lRet		:= .T.
Local nOpe      := 0
Local nLab      := 0
Local nEns      := 0
Local nMed      := 0   
Local nDel      := 0
Local cTab      := Substr(Alltrim(ReadVar()),4,4)
Local lMensTLot := .T.
Local dDtEnLa
Local cHrEnLa
Local cLaudo
Local dDtLaud
Local cHrLaud
Local dDtVal
Local cTamLot
Local cQtRej
Local dDtDiLa
Local cHrDiLa
Local cJustLa   
Local cRevi		 := Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local nPosLau    := 0
Local nPosLauOP  := 0
Local nPosResult := 0   
Local lContinua  := .T. 
Local nCount     := 0  
Local lReprov    := .F.
Local lMostJust  := .F.
Local nCEns      := 0   
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"    
//Variaveis utilizadas para iniciar campos no Laudo do Laboratorio
Local nPosDtEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTENLA"})
Local nPosHrEnLa := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_HRENLA"})
Local nPosTamLot := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_TAMLOT"}) 
Local nPosDtaLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTLAUD"})
Local nPosValLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTVAL"})  
Local nPosDesLau := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DESLAU"})
Local nPosQTRej  := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_QTREJ"})
Local lMensExist := .F.     
Local lNaoEntra  := .F.

If !lLayout
	Private nOperacao := nPosOper
	Private nFldLab	  := nPosLab
	Private nEnsaio   := nPosEns
	lFechaLab := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida data de OP no Laboratorio.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Substr(Alltrim(ReadVar()),8,6) == "DTENLA"
	
	dDtEnLa := &(ReadVar())
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	
	If !Empty(dDtEnLa)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data OP Laboratorio ‚ >= Data OP      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(dDtEnLa) .And. dDtEnLa < 	SC2->C2_EMISSAO
			Help(" ",1,"QPH215021") //Data OP Laboratório anterior Data da OP
			lRet := .F.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data OP Laboratorio ‚ >= Data Sistema       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. dDtEnLa > dDataBase
			Help(" ",1,"QPH215022") //Data inválida, maior que a data base do sistema!
			lRet := .F.
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se houver Data Laudo, verifica se Data OP ‚ menor      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. !Empty(dDtLaud) .And. dDtEnLa > dDtLaud
			Help(" ",1,"QPH215023") //Data OP Laborat¢rio posterior a Data do Laudo
			lRet := .F.
		EndIf
		
		If nFldOpe == 1   //Valida Apenas as Medicoes da Operacao corrente
			For nLab := 1 to Len(aResultados[nOperacao,_LAB])
				For nEns := 1 to Len(aResultados[nOperacao,_ENS,nLab])
					nDel := Len(aResultados[nOperacao,_MED,nLab,nEns,1])
					Aeval(aResultados[nOperacao,_MED,nLab,nEns],{|x,y| IIF ( !aResultados[nOperacao,_MED,nLab,nEns,Y,nDel], ( IIF(aResultados[nOperacao,_MED,nLab,nEns,Y,1] < dDtEnLa,(IIF(lRet,Help(" ",1,"QPH215024"),.F.),lRet:=.F.),.F.)),.F.)})
					If !lRet
						Exit
					EndIf
				Next nEns
				If !lRet
					Exit
				EndIf
			Next nLab
		ElseIf nFldOpe == 2
			For nEns := 1 to Len(aResultados[nOperacao,_ENS,nFldLab])
				nDel := Len(aResultados[nOperacao,_MED,nFldLab,nEns,1])
				Aeval(aResultados[nOperacao,_MED,nFldLab,nEns],{|x,y|  IIF ( !aResultados[nOperacao,_MED,nFldLab,nEns,Y,nDel], ( IIF(aResultados[nOperacao,_MED,nFldLab,nEns,Y,1] < dDtEnLa,(IIF(lRet,Help(" ",1,"QPH215024"),.F.),lRet:=.F.),.F.)),.F.) })
				If !lRet
					Exit
				EndIf
			Next nEns
		ElseIf nFldOpe == 3
			For nOpe := 1 to nQtdOpe
				For nLab := 1 to Len(aResultados[nOpe,_LAB])
					For nEns := 1 to Len(aResultados[nOpe,_ENS,nLab])
						nDel := Len(aResultados[nOpe,_MED,nLab,nEns,1])
						Aeval(aResultados[nOpe,_MED,nLab,nEns],{|x,y|  IIF ( !aResultados[nOpe,_MED,nLab,nEns,Y,nDel], ( IIF(aResultados[nOpe,_MED,nLab,nEns,Y,1] < dDtEnLa,(IIF(lRet,Help(" ",1,"QPH215024"),.F.),lRet:=.F.),.F.)),.F.)})
						If !lRet
							Exit
						EndIf
					Next nEns
					If !lRet
						Exit
					EndIf
				Next nLab
				If !lRet
					Exit
				EndIf
			Next nOpe
		EndIF
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Valida hora de OP no Laboratorio.                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "HRENLA"
	
	cHrEnLa  := Left(&(ReadVar()),5)
	cHrLaud  := Left(&("M->"+cTab+"HRLAUD"),5)
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	
	If !Empty(cHrEnLa)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Hora Medicao ‚ >= Hora OP em Laboratorio	   ³
		//³ se as datas forem as mesmas									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	!Empty(cHrEnLa).And. Substr(cHrEnLa,1,2) > "23" .Or. Substr(cHrEnLa,4,2) > "59" .Or. ;
			Len(AllTrim(cHrEnLa)) <> 5
			Help(" ",1,"QPH215048") //Hora Inválida.
			lRet := .F.
		EndIf 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se existir a Hora Laudo, verifica se a Hora OP Laborat.        ³
		//³ ‚ <= Hora do Laudo, se as datas forem as mesmas				   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet	.And. SC2->C2_EMISSAO == dDtEnLa .And. ;
			(!Empty(Left(cHrLaud,2)) .And. !Empty(Right(cHrLaud,2))) .And. cHrEnLa > cHrLaud
			Help(" ",1,"QPH215025") //Hora OP em Laboratório posterior a do Laudo.
			lRet	:= .F.
		EndIf
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver Medicoes, verifica se a hora de Entr. Lab. <= hora das Medicoes  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		If nFldOpe == 1   //Valida Apenas as Medicoes da Operacao corrente
			For nLab := 1 to Len(aResultados[nOperacao,_LAB])
				For nEns := 1 to Len(aResultados[nOperacao,_ENS,nLab])
					nDel := Len(aResultados[nOperacao,_MED,nLab,nEns,1])
					Aeval(aResultados[nOperacao,_MED,nLab,nEns],{|x,y| IIF ( !aResultados[nOperacao,_MED,nLab,nEns,Y,nDel], ( ;
					IIF(aResultados[nOperacao,_MED,nLab,nEns,Y,1] == dDtEnLa .and. SuperVal(aResultados[nOperacao,_MED,nLab,nEns,Y,2]) < SuperVal(Substr(cHrEnLa,1,5)) , ( ;
					IIF(lRet,Help(" ",1,"QPH215026"),.F.),lRet:=.F.),.F.)),.F.)})
					If !lRet
						Exit
					EndIf
				Next nEns
				If !lRet
					Exit
				EndIf
			Next nLab
		ElseIf nFldOpe == 2   //Valida Apenas as Medicoes do Laboratorio corrente
			For nEns := 1 to Len(aResultados[nOperacao,_MED,nFldLab])
				nDel := Len(aResultados[nOperacao,_MED,nFldLab,nEns,1])
				Aeval(aResultados[nOperacao,_MED,nFldLab,nEns],{|x,y|  IIF ( !aResultados[nOperacao,_MED,nFldLab,nEns,Y,nDel], ( ;
				IIF(aResultados[nOperacao,_MED,nFldLab,nEns,Y,1] == dDtEnLa .and. SuperVal(aResultados[nOperacao,_MED,nFldLab,nEns,Y,2]) < SuperVal(Substr(cHrEnLa,1,5)) ,( ;
				IIF(lRet,Help(" ",1,"QPH215027"),.F.),lRet:=.F.),.F.)),.F.) })
				If !lRet
					Exit
				EndIf
			Next nEns
		ElseIf nFldOpe == 3   //Valida todas as Medicoes de todas Operacoes e Laboratorios
			For nOpe := 1 to nQtdOpe
				For nLab := 1 to Len(aResultados[nOpe,_LAB])
					For nEns := 1 to Len(aResultados[nOpe,_ENS,nLab])
						nDel := Len(aResultados[nOpe,_MED,nLab,nEns,1])
						Aeval(aResultados[nOpe,_MED,nLab,nEns],{|x,y|  IIF ( !aResultados[nOpe,_MED,nLab,nEns,Y,nDel], ( ;
						IIF(aResultados[nOpe,_MED,nLab,nEns,Y,1] == dDtEnLa .and. SuperVal(aResultados[nOpe,_MED,nLab,nEns,Y,2]) < SuperVal(Substr(cHrEnLa,1,5)) ,( ;
						IIF(lRet,Help(" ",1,"QPH215028"),.F.),lRet:=.F.),.F.)),.F.)})
						If !lRet
							Exit
						EndIf
					Next nEns
					If !lRet
						Exit
					EndIf
				Next nLab
				If !lRet
					Exit
				EndIf
			Next nOpe
		EndIF
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Laudo da Operacao,Laboratorio e Geral.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "LAUDO"

	cLaudo := &(ReadVar())
	               
	//Verifica Rotina de Liberacao Urgente.
	If lLiberaUrg .And. !Empty(cLaudo)
		If cLaudo#cFatLU 
			HELP(" ",1,"QPH215002",,cFatLU,3,1)  //Para rotina de Liberacao Urgente e obrigatorio que o Laudo da OP seja igual a : 	
			lRet := .F.
		EndIF
		If lRet
			QP215ADMOBJ(,,,3,!Empty(cLaudo) .Or. lLiberaUrg)
		EndIf	
		Return(lRet)
	ElseIF lLiberaUrg .And. Empty(cLaudo)
		lLiberaUrg:=.F.		
    EndIF
	
	If lRet                     

		If nFldOpe == 1  // Valida Laudo da Operacao         
		
			If lLayout
				nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO")
			Else                                                                                                   
				nPosLau := QP215GetLau(aSavGets[1,1],"QPM_LAUDO")
				nPosLau := Iif(nPosLau == 0, 3, nPosLau)
			EndIf
						
			For nLab := 1 to Len(aResultados[nOperacao,_LAB])                               
				If Empty(aResultados[nOperacao,_LLA,1,nPosLau])
					HELP(" ",1,"QPH215029",,Alltrim(aResultados[nOperacao,_LAB,1]),3,1)
					lRet := .F.
					Exit
				EndIf
			Next nLab
			
			If lRet .and. Empty(M->QPM_LAUDO)
				M->QPM_DTLAUD := CTOD("  /  /  ")
				M->QPM_HRLAUD := ""
				M->QPM_LAUDO  := ""
				M->QPM_DESLAU := "" 
				oGetLauOpe:Refresh()  
				QP215SavResu({SAV_LAUO},.T.)  
				If lLayout
					aOperacoes[nOperacao,1] := QP215AtuSta(nOperacao,,,,"O",{1},.F.)
					aOperacoes[nOperacao,2] := QP215AtuSta(nOperacao,,,,"O",{1},.F.)
					aOperacoes[nOperacao,3] := QP215AtuSta(nOperacao,,,,"O",{2},.F.)
					oBrwOpe:SetFocus()
					oBrwOpe:Refresh() 
				EndIf
			EndIf
		
		ElseIf nFldOpe == 2  //Valida Apenas as Medicoes do Laboratorio corrente 
			If lLayout
				For nEns := 1 to Len(aResultados[nOperacao,_ENS,nFldLab])
					If aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S"	//Resultado Obrigatorio ou Ensaio Obrigatorio
	
	               		For nCEns := 1 To Len(aResultados[nOperacao,_MED,nFldLab,nEns])
									
							If aResultados[nOperacao,_ENS,nFldLab,nEns,CARTA] == "TXT"	                                                
								nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
							Else
								nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
							EndIf
	
							cMedicao := Iif(Valtype(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult])=="N",Str(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult]),aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult])
							nDelMed	:= Len(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns])
	        				cInsCer := QP215SkpT(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
							If !(Upper(Substr(cInsCer,1,3)) == "CER")
								If !aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed] //Caso esteja em branco ou deletado
									lMensExist	:= .F.
									lNaoEntra	:= .T.
									If Empty(cMedicao) .AND. !Empty(cLaudo) .AND. lContinua .AND. cLauAnt <> M->QPL_LAUDO
										cLauAnt := M->QPL_LAUDO 
										If qpAviso("",STR0080 +aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO]+STR0081,{STR0082,STR0083}) == 1  //"Existe ensaio obrigatório que não foi preenchido :"###" para que seja possível informar o laudo do Laboratório, será sugerido laudo reprovado, deseja continuar?"###"Continua"###"Abandona"
											QPD->(dbSetOrder(1))
											If QPD->(dbSeek(xFilial("QPD")+cLaudo))
												M->QPL_LAUDO := Iif(QPD->QPD_CATEG=="3",cLaudo,cFatRep)
											Else
												M->QPL_LAUDO := cFatRep
											EndIf
											lReprov		:= .T.
										Else
											M->QPL_LAUDO	:= " "
										EndIf
										lContinua := .F.
										Exit
									EndIf
								Else
									lMensExist := .T.
								EndIf
							EndIf
						Next nCEns
					
						If lMensExist .And. !lNaoEntra .AND. cLauAnt <> M->QPL_LAUDO
							cLauAnt := M->QPL_LAUDO 
							If qpAviso("",STR0084,{STR0082,STR0083}) == 1  //"Existe ensaio obrigatório que não foi preenchido, para que seja possível informar o laudo do Laboratório, será sugerido laudo reprovado, deseja continuar?"###"Continua"###"Abandona"
								M->QPL_LAUDO := cFatRep
							Else
								M->QPL_LAUDO := " "
							EndIf
							lContinua := .F.
						EndIf
						lNaoEntra	:= .F.
					EndIf
				Next nEns
			EndIf	
			If M->QPL_LAUDO == "A"
				M->QPL_QTREJ := Left("0",TamSx3("QPL_QTREJ")[1])
			ElseIf M->QPL_LAUDO == "E"
		    	M->QPL_QTREJ := M->QPL_TAMLOT
			Else
		    	M->QPL_QTREJ := Space(TamSx3("QPL_QTREJ")[1])
	    	EndIf

		ElseIf nFldOpe == 3 // Laudo Geral
	
			If lRet .And. !Empty(cLaudo)//Somente para o Laudo Geral

				For nCount := 1 To nQtdOpe
					If lContinua                                                    
						
						If lLayout
							nPosLauOP := QP215GetLau(aSavGets[Len(aResultados)],"QPL_LAUDO")
						Else                                                                                                   
							nPosLauOP := Iif(QP215GetLau(aSavGets[1,1],"QPM_LAUDO") == 0, 3, QP215GetLau(aSavGets[1,1],"QPM_LAUDO"))
						EndIf
									
						If aOperacoes[nCount,Iif(lLayout,8,6)] == "S"				//Operacao Obrigatoria
							If aOperacoes[nCount,Iif(lLayout,9,7)] == "S"			//Sequencia Obrigatoria
								If aOperacoes[nCount,Iif(lLayout,10,8)] == "S"		//Laudo Obrigatorio
									If Empty(aResultados[nCount,_LOP,nPosLauOP]) .AND. M->QPL_LAUDO <> cLauAnt
										If qpAviso("",STR0085 +AllTrim(aResultados[nCount,_OPE])+STR0086,{STR0082,STR0083}) == 1  //"O Laudo da Operação : "###" é obrigatório, para que seja possível informar o laudo final, será sugerido como laudo reprovado, deseja continuar?"###"Continua"###"Abandona"
											cLauAnt := M->QPL_LAUDO 
											QPD->(dbSetOrder(1))
											If QPD->(dbSeek(xFilial("QPD")+M->QPL_LAUDO))
												M->QPL_LAUDO := Iif(QPD->QPD_CATEG=="3",cLaudo,cFatRep)
											Else
												M->QPL_LAUDO	:= cFatRep
											EndIf
											lReprov	:= .T.
										Else
											cLauAnt := M->QPL_LAUDO 
											M->QPL_LAUDO	:= " "  
										EndIf
										lContinua := .F.
									Else
										QPD->(dbSetOrder(1))
										QPD->(dbSeek(xFilial("QPD")+M->QPL_LAUDO))
										IF __LANGUAGE == "PORTUGUESE"
											M->QPL_DESLAU := QPD->QPD_DESCPO
										ElseIF __LANGUAGE == "SPANISH"
											M->QPL_DESLAU := QPD->QPD_DESCES
										ElseIF __LANGUAGE == "ENGLISH" 
											M->QPL_DESLAU := QPD->QPD_DESCES
										Endif
										
										If cLaudo = "A"
											M->QPL_QTREJ  := Left("0",TamSx3("QPL_QTREJ")[1]) 
										Else
											M->QPL_QTREJ  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
										Endif															
									EndIf
								EndIf
							Else
								If aOperacoes[nCount,Iif(lLayout,10,8)] == "S"			//Laudo Obrigatorio
									If Empty(aResultados[nCount,_LOP,nPosLauOP]) .AND. cLauAnt <> M->QPL_LAUDO
										If cLaudo	<> cFatRep
											cLauAnt := cFatRep 
											If qpAviso("",STR0085 +AllTrim(aResultados[nCount,1])+STR0086,{STR0082,STR0083}) == 1  //"O Laudo da Operação : "###" é obrigatório, para que seja possível informar o laudo final, será sugerido como laudo reprovado, deseja continuar?"###"Continua"###"Abandona"
												lReprov		:= .T.
												M->QPL_LAUDO	:= cFatRep
											Else
												M->QPL_LAUDO	:= " "
											EndIf
											lContinua := .F.
											Exit
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				Next nCount
			EndIf
		Else
			cLauAnt := M->QPL_LAUDO 
			M->QPL_LAUDO := ''
		EndIf
	    
		If !lLayout .AND. nFldOpe == 1 
			//Monta as variaveis para poder ser informado as variaveis apos ser colocado e retirado o laudo
			M->QPL_LAUDO  := CriaVar("QPL_LAUDO"  ,.T.)
			M->QPL_DTLAUD := CriaVar("QPL_DTLAUD" ,.T.)
			M->QPL_HRLAUD := CriaVar("QPL_HRLAUD" ,.T.)
			M->QPL_DESLAU := CriaVar("QPL_DESLAU" ,.T.)
			M->QPL_QTREJ  := CriaVar("QPL_QTREJ"  ,.T.)
            // Pego do aResultados
			M->QPL_LAUDO  := aResultados[nPosOper,_LLA,nPosLab,nPoslau] 
			M->QPL_DTLAUD := aResultados[nPosOper,_LLA,nPosLab,nPosDtEnLa]
			M->QPL_HRLAUD := aResultados[nPosOper,_LLA,nPosLab,nPosHrEnLa]
			M->QPL_DESLAU := aResultados[nPosOper,_LLA,nPosLab,nPosDesLau]
			M->QPL_QTREJ  := aResultados[nPosOper,_LLA,nPosLab,nPosQTRej]
		EndIf
		
		If ((!Empty(M->QPL_LAUDO).And. lContinua) .Or. lReprov) .and. nFldOpe > 1
			If !Empty(M->QPL_DTENLA) .And. !Empty(Left(Alltrim(M->QPL_HRENLA),2)) .And. !Empty(Right(Alltrim(M->QPL_HRENLA),2))
				If ExistCpo2("QPD",M->QPL_LAUDO,,STR0087)	 //"Laudo informado não cadastrado. Informe um válido."
					lRet := .T.
				Else
					lRet := .F.
				Endif
				QPD->(dbSetOrder(1))
				QPD->(dbSeek(xFilial("QPD")+M->QPL_LAUDO))
				IF __LANGUAGE == "PORTUGUESE"
					M->QPL_DESLAU := QPD->QPD_DESCPO
				ElseIF __LANGUAGE == "SPANISH"
					M->QPL_DESLAU := QPD->QPD_DESCES
				ElseIF __LANGUAGE == "ENGLISH" 
					M->QPL_DESLAU := QPD->QPD_DESCES
				Endif
				
				If cLaudo = "A"
					M->QPL_QTREJ  := Left("0",TamSx3("QPL_QTREJ")[1]) 
				Else
					M->QPL_QTREJ  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
				Endif	
			Else
				If Empty(M->QPL_DTENLA)
					Help(" ",1,"QPH215030") //Não foi informada a Data de OP em laboratório. Informe p/ digitar o laudo.
				Elseif Empty(Left(Alltrim(M->QPL_HRENLA),2)) .And. Empty(Right(Alltrim(M->QPL_HRENLA),2))
					Help(" ",1,"QPH215031") //Não foi informada a Hora de OP em laboratório. Informe p/ digitar o laudo.
				Else
					Help(" ",1,"QPH215032") //Não foi informada a Data a Hora de OP em laboratório. p/ digitar o laudo.
				Endif
				lRet := .F.
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Sugere a data/hora do laudo tambem ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(M->QPL_DTENLA)
				M->QPL_DTENLA	:= dDataBase
				M->QPL_HRENLA	:= Time() 
				If lLayout
					If nFldOpe == 2
						aOBJETOS[OBJ_LAUDO,nOperacao,nFldLab,1]:EnchRefreshAll()
					Else
						aOBJETOS[OBJ_LAUGER,1]:EnchRefreshAll()
					EndIf
				EndIf
			Endif
			
			If nFldOpe == 3 // Laudo Geral
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula Data de Validade do Laudo geral OP (Shelf-Life)	 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QP6->QP6_SHLF > 0
					If QP6->QP6_TPSLIF == "1"	
						nDias := QP6->QP6_SHLF
					ElseIF QP6->QP6_TPSLIF == "2"
						nDias := QP6->QP6_SHLF*30
					ElseIF QP6->QP6_TPSLIF == "3"
						nDias := Int(QP6->QP6_SHLF/24)
					ElseIF QP6->QP6_TPSLIF == "4"
						nDias := QP6->QP6_SHLF*365
					Else
						nDias := 0
					EndIF
				EndIf
					
				If  Empty(M->QPL_LAUDO) .And. !lContinua
					lRet := .F.
				EndIf
					
					
				If !Empty(cLaudo)
					QPD->(dbSetOrder(1))
					If QPD->(dbSeek(xFilial("QPD")+cLaudo))
						If QPD->QPD_CATEG <> "1"
							lMostJust := .T.
						EndIf
					EndIf
					If Empty(M->QPL_HRLAUD)
						M->QPL_HRLAUD := Time()
					Endif
				EndIf
					
				If lRet .And.( (Alltrim(cLaudo) <> Alltrim(aResultados[nFldLauGer,1,nPosLauOP]) .And.;
					!Empty(aResultados[nFldLauGer,1,nPosLauOP])) ; // Mudou laudo e esta no laudo da OP
					.Or. (cLaudo <> cFatApr .And. !Empty(cLaudo)) ;
					.Or. (cLaudo == cFatApr .And. lMostJust ) )
		
					lJusLObrG := .T.    
				Else
					lJusLObrG := .F.    
				EndIf
			EndIf
   	    Else	
   	    	If Empty(cLaudo)
				//Monta as variaveis para poder ser informado as variaveis apos ser colocado e retirado o laudo
				M->QPL_LAUDO  := CriaVar("QPL_LAUDO",.T.) 
				M->QPL_DTLAUD := CriaVar("QPL_DTLAUD",.T.)
				M->QPL_HRLAUD := CriaVar("QPL_HRLAUD",.T.)
				M->QPL_DESLAU := CriaVar("QPL_DESLAU",.T.)
				M->QPL_QTREJ  := CriaVar("QPL_QTREJ",.T.)
				If nFldOpe == 2
					If lLayout
						aOBJETOS[OBJ_LAUDO,nOperacao,nFldLab,1]:EnchRefreshAll()
						nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
					Else                                                                                                   
						nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
					EndIf
					aResultados[nOperacao,_LLA,nFldLab,nposLau]:=cLaudo
				Else
					If lLayout
						aOBJETOS[OBJ_LAUGER,1]:EnchRefreshAll()
					EndIf
				EndIf  			
			EndIf
   	    EndIf  
		
		If !lLayout
			nPosLauOP := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")   	    
		EndIf
   	         	    
   		If ((!Empty(Iif(lLayout,M->QPM_LAUDO,aResultados[nFldLauGer,1,nPosLauOP])).And. lContinua) .Or. lReprov) .and. nFldOpe = 1
			QPD->(dbSetOrder(1))
			QPD->(dbSeek(xFilial("QPD")+M->QPM_LAUDO))
			IF __LANGUAGE == "PORTUGUESE"
				M->QPM_DESLAU := QPD->QPD_DESCPO
			ElseIF __LANGUAGE == "SPANISH"
				M->QPM_DESLAU := QPD->QPD_DESCES
			ElseIF __LANGUAGE == "ENGLISH" 
				M->QPM_DESLAU := QPD->QPD_DESCES
			Endif
   		EndIf
   		
   		If lRet
			QP215ADMOBJ(nOperacao,nFldLab,nEnsaio,nFldOpe,!Empty(cLaudo) .Or. lLiberaUrg)
		EndIf		    
	EndIF

	If ExistBlock("QP215J13") .AND. AllTrim(cLauAnt) <> AllTrim(cLaudo)
		If ExecBlock("QP215J13",.F.,.F.,{ aResultados[nOperacao,_OPE], aResultados[nOperacao,_LAB,nFldLab], nOpcX, nFldOpe,  QPK->QPK_OP, cLaudo, nFldOpe })
			cLauAnt := &(ReadVar())
			Return(lRet)
		Else
			// Forco o foco no Laudo e impedindo que a tela seja fechada
			If  nFldOpe == 1   
				oGetLauOpe:AEntryCtrls[nPosLau]:LModified := .T.
				SetFocus(oGetLauOpe:AEntryCtrls[nPosLau]:hWnd)
				oGetLauOpe:nCtrl := nPosLau 
				oGetLauOpe:Refresh()				
			ElseIf nFldOpe == 2
				nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
				oGetLaudo:AEntryCtrls[nPosLau]:lModified := .T.
				SetFocus(oGetLaudo:AEntryCtrls[nPosLau]:hWnd)
				oGetLaudo:nCtrl := nPosLau 
				oGetLaudo:Refresh()
			ElseIf nFldOpe == 3  
				oGetLGer:AEntryCtrls[nPosLauOP]:LModified := .T.
				SetFocus(oGetLGer:AEntryCtrls[nPosLauOP]:hWnd)
				oGetLGer:nCtrl := nPosLauOP 
				oGetLGer:Refresh()			
			EndIf
			lFechaLab := .F.
			Return .F.
		EndIf
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Data doLaudo da Operacao,Laboratorio e Geral.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "DTLAUD"

	dDtLaud  := &(ReadVar())
	cLaudo   := &("M->"+cTab+"LAUDO")
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	dDtLaud  := &("M->"+cTab+"DTLAUD")

	If !Empty(dDtLaud)
		If Empty(cLaudo)
			Help(" ",1,"QPH215033") //Informe primeiro o Laudo para depois digitar a data de validade
			lRet := .F.
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data Laudo ‚ >= Data OP em Laboratorio      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(dDtEnLa) .And. dDtLaud < dDtEnLa .And. lRet
			Help(" ",1,"QPH215034") //Data do Laudo anterior a Data OP em Laboratório
			lRet := .F.
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data Laudo ‚ >= Data Sistema ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. dDtLaud > dDataBase
			Help(" ",1,"QPH215035") //Data inválida, data maior que data base do sistema.
			lRet := .F.
		EndIf
	
		If lRet .And. nFldOpe == 3
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Data de Validade do Laudo geral OP (Shelf-Life)	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QP6->QP6_SHLF > 0
				If QP6->QP6_TPSLIF == "1"	
					nDias := QP6->QP6_SHLF
				ElseIF QP6->QP6_TPSLIF == "2"
					nDias := QP6->QP6_SHLF*30
				ElseIF QP6->QP6_TPSLIF == "3"
					nDias := Int(QP6->QP6_SHLF/24)
				ElseIF QP6->QP6_TPSLIF == "4"
					nDias := QP6->QP6_SHLF*365
				Else
					nDias := 0
				EndIF 
				M->QPL_DTVAL := M->QPL_DTLAUD + nDias
				If lLayout
					aOBJETOS[OBJ_LAUGER,1]:EnchRefreshAll()   
				EndIf
			EndIf
		EndIf
	
	Else
		If !Empty(cLaudo)
			Help(" ",1,"OBRIGAT") 
			lRet := .F.
		EndIf
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Hora doLaudo da Operacao,Laboratorio e Geral.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "HRLAUD"

	cHrLaud  := &(ReadVar()) 
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	cHrEnLa  := Alltrim(&("M->"+cTab+"HRENLA"))
	cLaudo   := &("M->"+cTab+"LAUDO")

	If !Empty(cHrLaud)
        If 	AllTrim(cHrLaud) == ":"
	        If !Empty(cLaudo) .AND. !Empty(dDtLaud)
				Help(" ",1,"OBRIGAT") 
				lRet := .F.
			EndIf
        EndIf
		cHrLaud  := StrZero(Val(Left(cHrLaud ,2)),2)+":"+StrZero(Val(Right(cHrLaud ,2)),2)
		If !Empty(dDtLaud)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Hora Medicao ‚ >= Hora OP em Laboratorio	   ³
			//³ se as datas forem as mesmas									   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	!Empty(cHrLaud).And. Substr(cHrLaud,1,2) > "23" .Or. Substr(cHrLaud,4,2) > "59" .Or. ;
				Len(AllTrim(cHrLaud)) <> 5
				Help(" ",1,"QPH215048") //Hora Inválida.
				lRet := .F.
			EndIf 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Hora Laudo	 ‚ >= Hora OP em Laboratorio       ³
			//³ se as datas forem as mesmas									   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. dDtLaud == dDtEnLa .And. 	!Empty(dDtEnLa) .And. cHrLaud  < cHrEnLa
				Help(" ",1,"QPH215036")		//Hora do Laudo anterior a Hora OP em Laboratário
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"QPH215037") //Informe a Data do Laudo para digitar a hora do laudo.
			lRet := .F.
		Endif
	Endif
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Hora doLaudo da Operacao,Laboratorio e Geral.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "DTVAL"

	dDtVal   := &(ReadVar()) 
	cHrLaud  := Alltrim(&("M->"+cTab+"HRLAUD"))
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	cHrEnLa  := Alltrim(&("M->"+cTab+"HRENLA"))
	cLaudo   := &("M->"+cTab+"LAUDO")
             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Data Validade/Dispon. Laudo ‚ >= Data Laudo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(dDtVal)
		If !Empty(dDtLaud) .And. (!Empty(Left(cHrLaud,2)) .And. !Empty(Right(cHrLaud,2))) .And.;
		   !Empty(dDtEnLa) .And. (!Empty(Left(cHrEnLa,2)) .And. !Empty(Right(cHrEnLa,2))) .And.;
		   !Empty(cLaudo)
		   
		   If !Empty(dDtLaud) .And. dDtVal < dDtLaud
				Help(" ",1,"QPH215038") //Data de Validade Laudo anterior a Data Laudo
				lRet := .F.
			EndIf              
			
		Else
			Help(" ",1,"QPH215039") //Verifique se a Data e Hora de OP em laboratório, Laudo e data e hora do Laudo estão digitados, para informar a data de disponibilidade.
			lRet := .F.
		Endif
	EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Tamanho do Lote Operacao,Laboratorio e Geral.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "TAMLOT"  

	cTamLot := &(ReadVar())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³nLaudo -                                          ³
	//³5 - Laudo Geral	                                 ³
	//³6 - Laudo da Operacao                             ³
	//³7 - Laudo do Laboratorio                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(cTamLot) 

		If ExistBlock("QP215J21")
			lRet := ExecBlock("QP215J21",.F.,.F.,{nOpcX,aResultados[nOperacao,_OPE],QPK->QPK_OP})
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o valor digitado e' um numero valido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet
			If !QA_VerNum(@cTamLot)
				Help(" ",1,"QPH215040") //Numero Invalido!
				lRet := .F.
			EndIf            
		EndIf	        

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Tam. Lote Laborat. <= Tam. Lote ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. SuperVal(cTamLot) > SuperVal(Str(SC2->C2_QUANT))
			If lMensTLot	//Flag utilizado para tratar mensagem para que seja apresentada somente uma vez
				If qpAviso(STR0088,STR0089,{STR0082,STR0083}) == 2 //"Tamanho do Lote"###"Tam. Lote Laborat. maior que o Tamanho Lote OP. Deseja continuar ?"###"Continua"###"Abandona" //"Tamanho do Lote"###"Tam. Lote Laborat. maior que o Tamanho Lote OP. Deseja continuar ?"###"Continua"###"Abandona"
					lRet := .F.    
				Else
					If nFldOpe == 1
						aResultados[nOpercao,_LOP,7]	:= cTamLot
					ElseiF nFldOpe == 2
						aResultados[nOperacao,_LLA,nFldLab,7] := cTamLot
					ElseIf nFldOpe == 3
						aResultados[nFldLauGer,1,7] := cTamLot
					EndIf
				EndIf
				lMensTLot := .F.
			EndIf
		EndIf
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Hora doLaudo da Operacao,Laboratorio e Geral.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "QTREJ"  

	cQtRej   := &(ReadVar())
	cTamLot  := &("M->"+cTab+"TAMLOT")

	If !Empty(cQtRej)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o valor digitado e' um numero valido ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !QA_VerNum(@cQtRej)
			Help(" ",1,"QPH215040") //Numero Invalido!
			lRet := .F.
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Qtde. Rejeitada ‚ <= Tamanho do Lote		³
		//³ No Laudo da Entrega compara com o Tamanho do Lote da OP ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet 
			If nFldOpe == 3
				If SuperVal(cQtRej) > SuperVal(Str(SC2->C2_QUANT))
					Help(" ",1,"QPH215041") //"Qtde Rejeitada maior que o Tamanho do Lote"
					lRet := .F.
				EndIf
			Else
				If SuperVal(cQtRej) > SuperVal(cTamLot)
					Help(" ",1,"QPH215041") //"Qtde Rejeitada maior que o Tamanho do Lote"
					lRet := .F.
				EndIf
			EndIf
		EndIf
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Data de Disponibilidade do Laudo.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "DTDILA"  
     
	dDtDiLa  := &(ReadVar()) 
	cHrLaud  := Alltrim(&("M->"+cTab+"HRLAUD"))
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	cHrEnLa  := Alltrim(&("M->"+cTab+"HRENLA"))       
	cLaudo   := &("M->"+cTab+"LAUDO")

	If !Empty(dDtDiLa)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data Validade/Dispon. Laudo ‚ >= Data Laudo					³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(dDtLaud) .And. (!Empty(Left(cHrLaud,2)) .And. !Empty(Right(cHrLaud,2))) .And.;
				!Empty(dDtEnLa) .And. (!Empty(Left(cHrEnLa,2)) .And. !Empty(Right(cHrEnLa,2))) .And.;
				!Empty(cLaudo)
			If !Empty(dDtLaud) .And. dDtDilA < dDtLaud
				Help(" ",1,"QPH215042") //Data Disponib. Laudo anterior a Data Laudo
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"QPH215043") //Devem ser especificados: Data/Hora OP em Laboratório, Laudo, Data/Hora do Laudo.
			lRet := .F.
		Endif
	Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Hora de Disponibilidade do Laudo.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Substr(Alltrim(ReadVar()),8,6) == "HRDILA"  

	cHrDiLa := &(ReadVar())   
	dDtDiLa  := &("M->"+cTab+"DTDILA")
	cHrLaud  := Alltrim(&("M->"+cTab+"HRLAUD"))
	dDtLaud  := &("M->"+cTab+"DTLAUD")
	dDtEnLa  := &("M->"+cTab+"DTENLA")
	cHrEnLa  := Alltrim(&("M->"+cTab+"HRENLA"))       
	cLaudo   := &("M->"+cTab+"LAUDO")   

	If !Empty(cHrDiLa)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Hora Medicao ‚ >= Hora OP em Laboratorio	   ³
		//³ se as datas forem as mesmas									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	!Empty(cHrDiLa).And. Substr(cHrDiLa,1,2) > "23" .Or. Substr(cHrDiLa,4,2) > "59" .Or. ;
			Len(AllTrim(cHrDiLa)) <> 5
			Help(" ",1,"QPH215048") //Hora Inválida.
			lRet := .F.
		EndIf
			
		If !Empty(dDtLaud) .And. (!Empty(Left(cHrLaud,2)) .And. !Empty(Right(cHrLaud,2))) .And.;
				!Empty(dDtEnLa) .And. (!Empty(Left(cHrEnLa,2)) .And. !Empty(Right(cHrEnLa,2))) .And.;
				!Empty(cLaudo) .And. !Empty(dDtDiLa)
			If dDtDiLa == dDtLaud .And. !Empty(cHrLaud) .And. cHrDiLa < cHrLaud
				Help(" ",1,"QPH215044") //Hora de Disp. Laudo anterior a Hora Laudo
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"QPH215045") //Verifique a Data e Hora de OP em Labor., Laudo e Data e Hora de Val. do laudo. Estes campos deverão estar preenchidos para a digitação da Hora de disponibilidade.
			lRet := .F.
		Endif
	Endif

EndIf

If !lLayout
	lFechaLab := .T.
EndIf

Return(lRet)       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215VldMedºAutor  ³Cleber Souza       º Data ³  20/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que realiza validacao de todos os campos da Get de  º±±
±±º          ³ Medicoes.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Parametros³ NIL  													  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Retorno	 ³ EXPL01 = Resultado da Validacao						  	  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VldMed()
Local cVar	     
Local lRet		  := .T.   
Local nY          := 0             
Local lLayout	  := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lValEns	  := GetMv("MV_QL2AEML",.F.,"1") == "1"   	// Verifico se, somene para a tela do Layout 2 se efetua a Atualização do Ensaio 
Local cMV_QVLDTHR := GetMv("MV_QVLDTHR",.T.,"1")   		// Tipo de Validação a ser efetuada da Data e Hora 1 - Validação completa (Data Medição >= Database  >= Data Entrada Lab. >= Data OP), 2 - Validação JJ (Data Medição  >= Data Entrada Lab. >= Data OP)
Local aHeadEns    := Iif(lLayout,aSavHeadEns[nOperacao,nFldLab,nEnsaio],aSavHeadEns[nPosOper,nPosLab,nPosEns])
Local aCols       := Iif(lLayout,aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols,oGetMed:aCols)
Local N           := Iif(lLayout,aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,oGetMed:nAT) 
Local nPosDtm     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_DTMEDI"})   
Local nPosHrm     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_HRMEDI"})   
Local nPosAmo     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_AMOSTR"})   
Local nPosEnsAc   := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_ENSR"})   
Local nPosDti     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_DTINI"})   
Local nPosHri     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_HRINI"})   
Local nPosDtf     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_DTFIM"})   
Local nPosHrf     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_HRFIM"})  
Local nPosRDat	  := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPS_MEDICA"}) 
Local nPosFMat    := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|Alltrim(x[2])=="QPR_FILMAT"}) 
Local nPosChv     := Ascan(Iif(lLayout,aHeadEns[1],aHeader),{|x|AllTrim(x[2])=="QPR_CHAVE"})
Local cRevi		  := Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cOper		  := aResultados[Iif(lLayout,nOperacao,nPosOper),_OPE]
Local cEns		  := Iif(lLayout,aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO],aResultados[nPosOper,_ENS,nPosLab,oBrwJJ:nAT,ENSAIO])
Local cCarta	  := Iif(lLayout,aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA] ,aResultados[nPosOper,_ENS,nPosLab,oBrwJJ:nAT,CARTA])
Local nDia		  := 0
Local lCalc		  := .F. 
Local lQP215Ens	  := ExistBlock("QP215ENS")       
Local cTamAmo	  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
Local cPlAmEns	  := " " 
Local cIntNor     := " "
Local cAmost	  := " "
Local cDescPla	  := ""
Local cAliasEns   := " "     
Local aRetorno    := {}
Local nAceite2	  := 0
Local nRejeite2	  := 0
Local nTamAmo2	  := 0 
Local cForAmo2	  := 0
Local nPosDtEnLa  := Ascan(aCpoEnc[1],{|x|AllTrim(x)=="QPL_DTENLA"})
Local cChave      := ""
Local nSaveSX8    := GetSX8Len() 
Local nCins       := 0
Local aColInst    := {}

CONOUT("Inicio Validacao das Medicoes - Funcao: QP215VldMed: "+DtoC(dDataBase)+"-"+Time())

If !lLayout
	nOperacao := nPosOper
	nFldLab   := nPosLab   
Else
	nPosOper  := nOperacao 
	nPosLab   := nFldLab
	nPosEns   := nEnsaio
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Data da Medicao.					                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Alltrim(ReadVar()) == "M->QPR_DTMEDI"

	cVar := &(readvar()) // Conteudo da variavel do campo Data Medicao

	If AllTrim(cMV_QVLDTHR) $ "1|2"
		If AllTrim(cMV_QVLDTHR) == "1"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Data Medicao/Laudo ‚ >= Data OP em Laboratorio ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(aResultados[nOperacao,_LLA,nFldLab,1]) .And. cVar < aResultados[nOperacao,_LLA,nFldLab,nPosDtEnLa]
				Help(" ",1,"QPH215046") //Data da Medição anterior a Data OP em Laboratório
				lRet := .F.
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se a Data Medicao  ‚ >= Data Sistema ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lRet .And. cVar > dDataBase	
				Help(" ",1,"QPH215022")	
				lRet := .F.
			EndIf 
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a Data Medicao    >= Data Producao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lRet .And. cVar < SC2->C2_EMISSAO
	 		Help(" ",1,"QPH215047") //Data da Medição anterior a Data da Produção
		   lRet := .F.
		EndIf
	EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Valida a hora q foi feita a medicao.	                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Alltrim(ReadVar()) == "M->QPR_HRMEDI"

	cVar := Left(&(readvar()),TamSx3("QPR_HRMEDI")[1]) // Conteudo da variavel do campo Hora da Medicao

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Hora Medicao ‚ >= Hora OP em Laboratorio	   ³
	//³ se as datas forem as mesmas									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!Empty(cVar).And. Substr(cVar,1,2) > "23" .Or. Substr(cVar,4,2) > "59" .Or. ;
		Len(AllTrim(cVar)) <> 5
		Help(" ",1,"QPH215048") //Hora Inválida.
		lRet := .F.
	EndIf

	If lRet 	
		If aCols[N,nPosDtM] == Iif(lLayout,aResultados[nOperacao,_LLA,nFldLab,1],aResultados[nPosOper,_LLA,nPosLab,1]) .And. ;
				!Empty(Left(cVar,2)) .And. !Empty(Right(cVar,2)) .And. cVar < Iif(lLayout,aResultados[nOperacao,_LLA,nFldLab,2],aResultados[nPosOper,_LLA,nPosLab,2])
			Help(" ",1,"QPH215049")	 //Hora da Medição anterior a Hora OP em Laboratório.
			lRet := .F.
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ja existe medicao com esta data e hora ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nY := 1 To Len(aCols)
		If aCols[nY,nPosDtM] == aCols[N,nPosDtM] .And. nY <> n
			If cVar == aCols[nY,nPosHrm] .And. nY <> N
				Help(" ",1,"QPH215050") //Já existe medição com esta Data/Hora/Amostra
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next nY

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Valida Quantidade da Amostra.			                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Alltrim(ReadVar()) == "M->QPR_AMOSTR"  

	cVar := &(Readvar())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Amostragem ‚ valida ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cVar == 1 
		lRet := .T.
	ElseIf cVar == 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Caso seja dupla amostragem, devera checar se o plano    ³
		//³ escolhido tem as colunas de Aceite / Rejeite / Amostra  ³
		//³ estejam preenchidos. Caso contrario nao podera digitar. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Alltrim(cCarta) <> "TXT"
			cAliasEns := "QP7"
		Else                 
			cAliasEns := "QP8"
		EndIf
		
		dbSelectArea(cAliasEns)
		dbSetOrder(1)
		If dbSeek(xFilial(cAliasEns)+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns)
			cPlAmEns  := " "
			cIntNor   := " "
			cAmost	  := " "
				
			If !Empty(&(cAliasEns+"_PLAMO"))
				cPlAmEns := QA_Plano(&(cAliasEns+"_PLAMO"))			
				cIntNor  := &(cAliasEns+"_PLAMO")			
				
				If cIntNor == "I" //Somente para o Plano Interno
					cDescPla := &(cAliasEns+"_DESPLA")
	
					QQH->(dbSetOrder(1))
					QQH->(dbSeek(xFilial('QQH')+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns))
				    If QQH->(!Eof())
						cAmost    := QQH->QQH_AMOST
						aRetorno  := QEP_RetAmostra(cIntNor,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(cTamAmo)),8),"QPK_TAMLOT",.F.)
						nAceite2  := aRetorno[1,4] //Aceite  2
						nRejeite2 := aRetorno[1,5] //Rejeite 2
						nTamAmo2  := aRetorno[1,6] //Amostra 2
		
						If Empty(nRejeite2) .And. Empty(nTamAmo2) 
							lRet := .F.
						EndIf               
						
					EndIf	
				Else           
					lRet := .T.
				EndIf
			EndIf
					      
		EndIf

		If !lRet
			MsgAlert(STR0090 +Alltrim(cDescPla)) //"Não há Dupla Amostragem definido no "
		EndIf
	
	Else
		lRet := .F.
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida Codigo do Ensaiador.				                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Alltrim(ReadVar()) == "M->QPR_ENSR" .Or. Alltrim(ReadVar()) == "M->QPS_MEDICA" .Or. Alltrim(ReadVar()) == "M->QPQ_MEDICA" .Or. Alltrim(ReadVar()) == "M->QPQ_RESULT"
                               
	If Alltrim(ReadVar()) == "M->QPR_ENSR"
		cVar := &(Readvar())
	Else
		cVar := aCols[N,nPosEnsAc]              	
	Endif
		
	DbSelectArea("QAA")
	DbSetOrder(1)
	
	If DbSeek(xFilial("QAA")+cVar)                    
		cNivel_QAA	:= QAA->QAA_NIVEL                  
	EndIf                        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Ensaiador esta' cadastrado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! QA_CHKMAT(aCols[N,nPosFMat],cVar,.T.)
		lRet := .F.
	EndIf
             
    If lQP215Ens
		lRet := ExecBlock("QP215ENS",.F.,.F.,{cVar})
	EndIf

	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Ensaiador tem o nivel exigido pelo ensaio ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		QP1->(dbSeek(xFilial("QP1")+cEns))
		If QAA->(dbSeek(aCols[N,nPosFMat]+cVar))
		If Val(QAA->QAA_NIVEL) < Val(QP1->QP1_NIENSR)
			Help(" ",1,"QPH215051") //"Ensaiador não tem o nível exigido para o Ensaio
			lRet := .F.
			Endif
		EndIf
	EndIf
    
	If Alltrim(cCarta) == "TXT"                    
        
		If !lLayout
			If Len(aResultados[nPosOper,_MED,nPosLab,nPosEns]) >= oGetMed:nAT
				aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,aResultados[nPosOper,_MED,nPosLab,nPosEns,oGetMed:nAT,nPosChv],"QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
			Else
				aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
			EndIf
		Else    
			If Len(aResultados[nPosOper,_MED,nPosLab,nPosEns]) >= aOBJETOS[OBJ_INST,nPosOper,nPosLab,nPosEns]:nAT
				aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,aResultados[nPosOper,_MED,nPosLab,nPosEns,aOBJETOS[OBJ_INST,nPosOper,nPosLab,nPosEns]:nAT,nPosChv],"QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
			Else
				aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
			EndIf
		Endif
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz atualizacao automatica dos instrumentos a partir do(s)  Instrumento(s) informado(s) ³
		//³ na primeira medicao.                                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cMV_QPINAUT == "S"
			For nCins := 1 To Len(aResultados[nPosOper,_INS,nPosLab,nPosEns,1])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a inclusao de nova linha no Instrumento       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aResultados[nPosOper,_INS,nPosLab,nPosEns]) < N
					Aadd(aResultados[nPosOper,_INS,nPosLab,nPosEns], {})
					Aadd(aResultados[nPosOper,_INS,nPosLab,nPosEns,N],aClone(aColInst[1]))
				ElseIf Len(aResultados[nPosOper,_INS,nPosLab,nPosEns,N]) < nCIns
					Aadd(aResultados[nPosOper,_INS,nPosLab,nPosEns,N],aClone(aColInst[1]))
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ No momento da inclusao verifica se o instrumento estah vazio e tem familia  vinculada ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If 	Empty(aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,1])  .AND.;
					aResultados[nPosOper,_ENS,nPosLab,nPosEns,FAMVINC]
					aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,1]	:= aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,1]
					aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,2]	:= aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,2]
					aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,3]	:= aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,3]
					aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,4]	:= aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,4]
					aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,5]	:= aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,5]

					If aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns,Len(aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns])]
						aResultados[nPosOper,_INS,nPosLab,nPosEns,N,nCIns,Len(aResultados[nPosOper,_INS,nPosLab,nPosEns,1,nCIns])] := .T.				
					EndIf
					
					If Len(aResultados[nPosOper,_MED,nPosLab,nPosEns]) >= N .AND. Empty(AllTrim(aResultados[nPosOper,_MED,nPosLab,nPosEns,N,nPosChv]))
						cChave := QA_SXESXF("QPR","QPR_CHAVE",,4)
						While ( GetSX8Len() > nSaveSx8 )
							ConfirmSX8()
						EndDo
						aResultados[nPosOper,_MED,nPosLab,nPosEns,N,nPosChv] := cChave
						oGetMed:aCols[oGetMed:nAt,nPosChv] := cChave 
					EndIf
					If oGetIns <> Nil
					 	oGetIns:aCols := aClone(aResultados[nPosOper,_INS,nPosLab,nPosEns,N])
					EndIf
				EndIf
			Next nCIns
			If lLayout 
				QP215AtuSta(nPosOper,nPosLab,nPosEns,"","E",{3},.T.)
			Else 
				aListEns[nPosEns,3] := QP215AtuSta(nPosOper,nPosLab,nPosEns,"","E",{3},.T.)
				QP216AtuEns(oBrwJJ:oWnd, nPosOper, nPosLab, nPosLab, nPosEns, .F.)
				lAtuIns := .F.
			EndIf
		EndIf
    EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Valida data de Inicio da Medicao.		                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf Alltrim(ReadVar()) == "M->QPR_DTINI" .OR.;
	   Alltrim(ReadVar()) == "M->QPR_HRINI" .OR.;
	   Alltrim(ReadVar()) == "M->QPR_DTFIM" .OR.;
	   Alltrim(ReadVar()) == "M->QPR_HRFIM"
  

	QP1->(dbSetOrder(1))
	If QP1->(dbSeek(xFilial("QP1")+cEns))
		If QP1->QP1_TIPO == "C"	//Ensaio calculado
			lCalc := .T.
		EndIf
	EndIf

	If cCarta == "TMP" .And. !lCalc

   		If Alltrim(ReadVar()) =="M->QPR_DTINI"
			cValor := &(ReadVar())
			If !Empty(cValor) .And. !Empty(aCols[N,nPosDtf])
				If cValor > aCols[N,nPosDtf] .Or. cValor > dDataBase 
					Help(" ",1,"QPH215003") //Data incicial da medicao invalida!
					lRet := .F.
				Else
					aCols[n,nPosDti] := M->QPR_DTINI
				EndIf
			EndIf
		EndIf
	                                 
		If Alltrim(ReadVar()) =="M->QPR_DTFIM"
			cValor := &(ReadVar())
			If !Empty(aCols[n,nPosDti]) .And. !Empty(cValor)
				If cValor < aCols[n,nPosDti] .Or. cValor > dDataBase 
			   		Help(" ",1,"QPH215004") //Data final da medicao invalida!
					lRet := .F.
				Else
					aCols[n,nPosDtf] := M->QPR_DTFIM
				EndIf
			EndIf
		EndIf
   	
		If Alltrim(ReadVar()) =="M->QPR_HRINI"
			cValor := &(ReadVar())
			If	!Empty(cValor).And. Substr(cValor,1,2) > "23" .Or. Substr(cValor,4,2) > "59" .Or. ;
				Len(AllTrim(cValor)) < 5 .Or.;
				(	!Empty(cValor) .And. !Empty(aCols[n,nPosHrf])	.And. ;
					aCols[n,nPosDtf] == aCols[n,nPosDti]						.And. ;
					Superval(aCols[n,nPosHrf]) <= SuperVal(cValor)	)
				Help(" ",1,"QPH215004") 	//Hora Inicial da medicao invalida!
				lRet := .F.
			Else
				aCols[n,nPosHri] := M->QPR_HRINI
			EndIf
		EndIf
   	
		If Alltrim(ReadVar()) =="M->QPR_HRFIM"
			cValor := &(ReadVar())
			If	!Empty(aCols[n,nPosHri]) .And. !Empty(cValor)
				If	aCols[n,nPosDtf] == aCols[n,nPosDti]	.And. ;
					Superval(cValor) <= SuperVal(aCols[n,nPosHri]) .Or. ;
					Substr(cValor,1,2) > "23" .Or. Substr(cValor,4,2) > "59" .Or. ;
					Len(AllTrim(cValor)) < 5
					Help(" ",1,"QPH215005") 	//Hora Final da medicao invalida!
					lRet := .F.
				Else
					aCols[n,nPosHrf] := M->QPR_HRFIM
				EndIf
			EndIf
		EndIf
	
		If lRet
			If	!Empty(aCols[n,nPosDti]) .And. !Empty(aCols[n,nPosHri]) .And. ;
				!Empty(aCols[n,nPosDtf]) .And. !Empty(aCols[n,nPosHrf])
				nDia	:= DiaUtil(aCols[n,nPosDti],aCols[n,nPosDtf])
				aCols[n,nPosRDat] := PadL(AllTrim(QA_CalHor(nDia,aCols[n,nPosHrf],aCols[n,nPosHri])),6,"0")
				QP215COMED(aCols[n,nPosRDat])
				If SuperVal(aCols[n,nPosRDat]) <= 0
					Help(" ",1,"QPH215006") // Resultado invalido
					Iif(lLayout,aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[n,nPosRDat] := '',oGetMed:aCols[n,nPosRDat] := '')
				EndIf
			Else
				Iif(lLayout,aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[n,nPosRDat] := '',oGetMed:aCols[n,nPosRDat] := '')
			EndIf

		EndIf
	EndIf
EndIf

CONOUT("Final Validacao das Medicoes - Funcao: QP215VldMed: "+DtoC(dDataBase)+"-"+Time())

Return(lRet)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215Hr	³ Autor ³ Cleber Souza          ³ Data ³ 02/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se a medicao informada nao esta repetida.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExpC1 - Hora a sugerir.									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Hr()

Local cHora		:= Left(Time(),TamSx3("QPR_HRMEDI")[1])
Local nI		:= 1
Local nHoraAtu	:= 0
Local nHora		:= 0    
Local aCols     := {}
Local N         := 0
Local nPosDtm   := 0
Local nPosHrm   := 0
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1" 
Local oGetAux  

If lLayout
	If Len(aOBJETOS[OBJ_MEDICA])> 0
		oGetAux := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]  
	EndIf
Else
	nOperacao := nPosOper
	nFldLab	  := nPosLab
	nEnsaio	  := oBrwJJ:nAt
	oGetAux   := oGetMed
EndIf

If lLayout
	If Len(aOBJETOS[OBJ_MEDICA])> 0
		aCols     := oGetAux:aCols   
		N         := oGetAux:nAT  
		nPosDtm   := Ascan(oGetAux:aHeader,{|x|Alltrim(x[2])=="QPR_DTMEDI"})   
		nPosHrm   := Ascan(oGetAux:aHeader,{|x|Alltrim(x[2])=="QPR_HRMEDI"})   
	Else 
		Return(cHora)
	EndIF
Else
	If oGetAux <> Nil
		If Len(oGetAux:aHeader) > 0
			aCols     := oGetAux:aCols   
			N         := oGetAux:nAT  
			nPosDtm   := Ascan(oGetAux:aHeader,{|x|Alltrim(x[2])=="QPR_DTMEDI"})   
			nPosHrm   := Ascan(oGetAux:aHeader,{|x|Alltrim(x[2])=="QPR_HRMEDI"})   
		Else 
			Return(cHora)
	    EndIf
	Else 
		Return(cHora)
	EndIF
EndIf
	
	For nI := 1 To Len(aCols)-1
		If aCols[nI,nPosDtm] == dDataBase
			If SuperVal(cHora) > Superval(aCols[nI,nPosHrm]) .And. nHoraAtu == 0
				nHoraAtu := SuperVal(cHora)
			EndIf
			
			nHora := Superval(aCols[nI,nPosHrm])
		
			If nHora > nHoraAtu
				nHoraAtu := nHora
			EndIf
		EndIf
	Next                            
	
	If !Empty(nHoraAtu)
		If TamSx3("QPR_HRMEDI")[1]==8
			If Len(AllTrim(Str(nHoraAtu))) == 1
				cHora := "00000"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 2
				cHora := "0000"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 3
				cHora := "000"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 4
				cHora := "00"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 5
				cHora := "0"+AllTrim(Str(nHoraAtu))
			Else
				cHora := AllTrim(Str(nHoraAtu))
			EndIf
			cHora := Substr(cHora,1,2)+":"+Substr(cHora,3,2)+":"+Substr(cHora,5,2)
		Else
			If Len(AllTrim(Str(nHoraAtu))) == 1
				cHora := "000"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 2
				cHora := "00"+AllTrim(Str(nHoraAtu))
			ElseIf Len(AllTrim(Str(nHoraAtu))) == 3
				cHora := "0"+AllTrim(Str(nHoraAtu))
			Else
				cHora := AllTrim(Str(nHoraAtu))
			EndIf
			cHora := Substr(cHora,1,2)+":"+Substr(cHora,3,2)
		EndIf
	EndIf
	
	For nI := 1 To Len(aCols)-1
		If aCols[nI,nPosDtm] == dDataBase
			If Alltrim(aCols[nI,nPosHrm]) == Alltrim(cHora)
				If TamSx3("QPR_HRMEDI")[1] == 8 
					cHora := Left(Q_SomaHora(aCols[nI,nPosHrm],"00:00:01"),TamSx3("QPR_HRMEDI")[1])
				Else
					cHora := Left(Q_SomaHora(aCols[nI,nPosHrm]+":00","00:01:00"),TamSx3("QPR_HRMEDI")[1])
				EndIF
			EndIf
		EndIf
	Next nI
//EndIf
	
Return(cHora)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215Ens  ³ Autor ³ Cleber Souza          ³ Data ³ 01/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Inicializa Codigo e o apelido do ensaiador				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL  													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPC1 = Matricula do Ensaiador						  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215									                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Ens()

Local nOrdQAA	:= QAA->(IndexOrd())
Local cApelid	:= TRIM(UPPER(cUserName))
Local cCod		:= Space(10)

dbSelectArea("QAA")
dbSetOrder(6)
If dbSeek(cApelid)
	cCod := QAA->QAA_MAT
EndIf
dbSetOrder(nOrdQAA)

Return(cCod)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ChkGd³ Autor ³ Cleber Souza          ³ Data ³02/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se todos os dados necessario foram digitados na	  ³±±
±±³			 ³   Getdados de Medicoes e de Nao Conformidades			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 - Tipo 1 Indica checar medicoes						  ³±±
±±³			 ³ 		  Tipo 2 Indica checar Ncos 						  ³±±
±±³			 ³ExpL1 - .T. Checa acols e .F. checa aResultado			  ³±±
±±³			 ³ExpN1 - Numero da operacao atual*							  ³±±
±±³			 ³ExpN2 - Numero da Laboratorio atual*						  ³±±
±±³			 ³ExpN3 - Numero da Ensaio atual*							  ³±±
±±³			 ³ExpN4 - Numero da medicao atual*							  ³±±
±±³			 ³ExpN5 - Numero da Nco atual*								  ³±±
±±³			 ³ExpN6 - Numero do Instrumento atual* 						  ³±±
±±³			 ³ExpL2 - .T. Indica que e para verificar se esta deletada    ³±±
±±³			 ³ 															  ³±±
±±³			 ³ * Requerido caso o lAcols for .F.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExpL3 - .T. indica que esta tudo digitado. 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±							
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ChkGd( nTipo,lAcols,nOpe,nLab,nEns,nMed,nNco,nIns,lEnsObr )
Local lRet		:= .T.
Local nLoop 	:= 0
Local nDelete	:= 0
Local cMedicao  := ''
Local cMed		:= ''
Local aHeadEns  := {}  
Local aCols     := {}                                    
Local n         := 0
Local nPosMed   := 0 
Local nPosEnsR  := 0 
Local nPosRes   := 0
Local cCarta    := ""  
Local nQtdCpo   := 0
Local nQtdMed   := 0 

Default nTipo	:= 1
Default lAcols := .T. 
Default nOpe	:= 1
Default nLab	:= 1
Default nEns	:= 1
Default nMed	:= 1
Default nNco	:= 1
Default nIns	:= 1
Default lEnsObr:= .F.


Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄ¿
	//³ Medicoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÙ
Case nTipo == 1

	cCarta	:=	aResultados[nOpe,_ENS,nLab,nEns,CARTA] 
	nQtdMed  := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,QTDMED] 
	If lAcols 

		aHead     := aSavHeadEns[nOpe,nLab,nEns]
		aCols     := aOBJETOS[OBJ_MEDICA,nOpe,nLab,nEnsaio]:aCols   
		n         := aOBJETOS[OBJ_MEDICA,nOpe,nLab,nEnsaio]:nAT   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chamada do aCols ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDelete	:= Len(aCols[1]) // Nao conta o codigo de liq, nem a flag de delecao 

		If cCarta <> "TXT"
			If cCarta <> "P  "
				nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPS_MEDICA' })
				nPosRes := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPR_RESULT' })
			Else
				nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPS_MEDIPA' })
			EndIF
		Else
			nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_MEDICA' }) 
			nPosRes := Ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_RESULT' })
		EndIf
		nPosEnsR    := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPR_ENSR' })
		cMedicao  := Iif(Valtype(aCols[n,nPosMed])=="N",Str(aCols[n,nPosMed]),aCols[n,nPosMed])
	
		If (Empty(aCols[n,nPosEnsR]) .Or. Empty(cMedicao) .Or. Empty(aCols[n,nAcPosRes])) .And. !aCols[n,nDelete]
			lRet := .F.
		EndIf
		If lRet 
			nQtdCpo := (nPosMed+nQtdMed-1)
			For nLoop := nPosMed to nQtdCpo
				// Coluna Unidade nao Conforme para carta P
				If cCartEns == "P  "
					If nLoop == 2 
						Loop
					Endif
				EndIf
				cMed := Iif(Valtype(aCols[n,nLoop])=="N",Str(aCols[n,nLoop]),aCols[n,nLoop])
				If Empty(cMed) .And. !aCols[n,nDelete]
					lRet := .F.
					Exit
				EndIf
			Next nLoop
		EndIf	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao conformidades ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case nTipo == 2
	If lAcols  
		aCols     := aOBJETOS[OBJ_NCC,nOpe,nLab,1]:aCols
		n         := aOBJETOS[OBJ_NCC,nOpe,nLab,1]:nAT      
		nDelete   := Len(aCols[1])
		For nLoop := 1 To 4
			If Empty(aCols[n,nLoop]) .And. !aCols[n,nDelete]
				lRet := .F.
				Exit
			EndIf
		Next nLoop
	Else
		nDelete := Len(aResultados[nOpe,_NCO,nLab,nEns,nMed,nNco])
		If aResultados[nOpe,_NCO,nLab,nEns,nMed,nNco,nDelete] .And. lEnsObr
			lRet := .F.
		Else
			For nLoop := 1 To 4
				If Empty(aResultados[nOpe,_NCO,nLab,nEns,nMed,nNco,nLoop]) .And.;
						!aResultados[nOpe,_NCO,nLab,nEns,nMed,nNco,nDelete]
					lRet := .F.
					Exit
				EndIf
			Next nLoop
		Endif
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Instrumentos ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Case nTipo == 3
	If cMV_QIPQMT == "S"
		If lAcols	
			aCols     := aOBJETOS[OBJ_INST,nOpe,nLab,1]:aCols   
			n         := aOBJETOS[OBJ_INST,nOpe,nLab,1]:nAT   
			nDelete   := Len(aCols[1])
			If Empty(aCols[n,1]) .And. !aCols[n,nDelete]
				lRet := .F.
			EndIf
		Else
			nDelete := Len(aResultados[nOpe,_INS,nLab,nEns,nMed,nIns])
			If aResultados[nOpe,_INS,nLab,nEns,nMed,nIns,nDelete] .And. lEnsObr
				lRet := .F.
			Else
				If Empty(aResultados[nOpe,_INS,nLab,nEns,nMed,nIns,1]) .And.;
						!aResultados[nOpe,_INS,nLab,nEns,nMed,nIns,nDelete]
					lRet := .F.
				EndIf
			Endif
		EndIf
	Else
		lRet := .T.
	Endif
EndCase
Return lRet      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QP215ChkT   ³ Autor ³ Cleber Souza           ³ Data ³03/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verificao bloqueio do campo na tela de Medicoes				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL  														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 = Retorno da Validacao								  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											         	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/     
Function QP215ChkT()
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRet 		:= .T.   
Local cVar 		:= Alltrim(ReadVar())  
Local aCols     := {}
Local N         := 0
Local aHeadTMP  := {}
Local nPosCal	:= 0

If lLayout
	aCols     := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols 
	N         := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT  
	aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio])
	nPosCal	:= ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_CALPOR' })
Else
	nOperacao := nPosOper
	nFldLab	  := nPosLab
	nEnsaio	  := oBrwJJ:nAt
	aCols     := oGetMed:aCols 
	N         := oGetMed:nAT  
	aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio])
	nPosCal	  := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_CALPOR' })
EndIf

If cVar == "M->QPS_MEDIPN"   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se nao for automatico nao digita unidades Nc ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aCols[n,nPosCal] == "N"
		lRet := .F.
	EndIf
ElseIf cVar == "M->QPS_MEDIPP"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for automatico a porcentagem sera calculada ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Empty(aCols[n][nPosCal]) .Or. aCols[n][nPosCal] == "S"
		lRet := .F.
	EndIf                                       
ElseIf cVar == "M->QPU_TEMCRO"

Else
	If  !Empty(aResultados[nFldLauGer,1,3]) .Or.;    //Verifica se tem laudo Geral
	    !Empty(aResultados[nOperacao,_LLA,nFldLab,3]) .Or.;  //Verifica se tem laudo Laboratorio
	    !Empty(aResultados[nOperacao,_LOP,3])                //Verifica se tem laudo na Operacao
	
		lRet := .F.
	EndIf
EndIF

Return lRet     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215CalMd³ Autor ³Cleber Souza           ³ Data ³02/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza o tratamento dos ensaios calculados				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215CalMd(lCoMed)          
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lEnsCal  
Local cFormul    := "" 
Local cForAux    := "" 
Local cCarta     := "" 
Local cEnsCal    := "" 
Local nPosEnsa    := 0
Local nPosDes    := 0
Local nPosAvg    := 0
Local nPosFor    := 0 
Local aEnsCal    := {}
Local nPosEnsCal := 0
Local nX         := 0   
Local cOper      := ""
Local n             
Local cForArit	 :=""

Default lCoMed := .F.

If !lLayout
	aResultados := aClone(aResultados)
	nOperacao   := nPosOper
	nFldLab	    := nPosLab
	nEnsaio	    := oBrwJJ:nAt
EndIf

For nPosEnsa := 1 to Len(aResultados[nOperacao,_ENS,nFldLab])
	cCarta  := aResultados[nOperacao,_ENS,nFldLab,nPosEnsa,CARTA]
	cEnsCal := aResultados[nOperacao,_ENS,nFldLab,nPosEnsa,ENSAIO]  
	cOper   := aResultados[nOperacao,_OPE]
	lEnsCal := .F. 
	
	If cCarta $ "XBR/XBS/IND/XMR/HIS/TMP"
		QP1->(dbSetOrder(1))
		If QP1->(MsSeek(xFilial("QP1")+cEnsCal))
			If QP1->QP1_TIPO == "C"
				QP7->(dbSetOrder(1))                                                  
				If QP7->(dbSeek(xFilial("QP7")+QPK->(QPK_PRODUT+QPK_REVI+cRoteiro)+cOper+cEnsCal))
		 			cFormul := AllTrim(QP7->QP7_FORMUL)
		 			nDecimal := QA_NumDec(QP7->QP7_NOMINA)
		 			If !Empty(cFormul)
						lEnsCal := .T.	
		 			EndIf
				EndIf
			EndIf
	    EndIf
	EndIf 
	
	If lEnsCal
		nQtdMed  := aResultados[nOperacao,_ENS,nFldLab,nPosEnsa,QTDMED]
		For n:=1 to nQtdMed  
			cFormAux:=cFormul 
			While len(cFormAux) >0
				nPosDes := At("DESVPAD",cFormAux) //Posicao do calculo do Desvio Padrao
				nPosAvg := At("AVG",cFormAux)     //Posicao do calculo da Media
				
				If At("#",cFormAux) == 0
					//cOper:=substr(cFormAux,1,1)
					cForArit:=cForArit+substr(cFormAux,1,len(cFormAux))
					//ncalcForm:=Val(StrTran(QP215CalEns(nOperacao,nFldLab,nPosEns,aEnsCal,cForArit),",","."))
					Exit
				Endif   
				If nPosDes >0 .and. nPosAvg >0
					If nPosDes < nPosAvg
						nPosAvg:=0
					Else
						nposDes:=0
					Endif
				Endif
				
				If nPosDes >0 .or. nPosAvg >0
					nPosCalc:=If(nposDes>0,nPosDes,nPosAvg)
					If nPosCalc>1
						cForArit:=cForArit+substr(cFormAux,1,nPosCalc-2)+substr(cFormAux,nposcalc-1,1)
					Endif
				Endif 
				If nPosDes > 0 .and. cCarta#"TMP"                                         
				    cForAux := cFormAux
		 		   	cForAux := Stuff(cForAux,1,nPosDes+7,Space(nPosDes+7))
				  	nPosFor := At("#",cForAux)  
				  	cEnsCal := SubStr(cForAux,nPosFor+1,8)
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realiza o calculo do Desvio Padrao						 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				  	aResult:=QP215DesPad(nOperacao,nFldLab,nPosEnsa,cEnsCal)   
				  	cForArit:=cForArit+aResult[n]
				  	cForArit:= cForArit+substr(cForAux,nPosFor+11,1)
					cFormAux:=substr(cFormAux,nPosFor+12,len(cFormAux))
				  	
				  	
			    ElseIf nPosAvg > 0 .and. cCarta#"TMP"                                         
				    cForAux := cFormAux
			    	cForAux := Stuff(cForAux,1,nPosAvg+3,Space(nPosAvg+3))
			    	nPosFor := At("#",cForAux)
			    	cEnsCal := SubStr(cForAux,nPosFor+1,8)
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realiza o calculo da Media								 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aResult:=QP215Media(nOperacao,nFldLab,nPosEnsa,cEnsCal)
					cForArit:=cForArit+aResult[n]  
					cForArit:= cForArit+substr(cForAux,nPosFor+11,1)
					cFormAux:=substr(cFormAux,nPosFor+12,len(cFormAux))	    	
				    
				Else                  
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Realiza o calculo Normal da formula						 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				    aEnsCal := {}
				    cForAux := cFormul
				                      
				    For nX := 1 to Len(cForAux)
				    	nPosFor    := At("#",cForAux)
				    	If nPosFor == 0
				    		Exit
				    	EndIF	
				    	nPosEnsCal := Ascan(aResultados[nOperacao,_ENS,nFldLab],{|x|x[ENSAIO]==Padr(SubStr(cForAux,nPosFor+1,8),8)})
				    	
				    	Aadd(aEnsCal,{SubStr(cForAux,nPosFor+1,8),nPosEnsCal})
				    	
				    	cForAux := Stuff(cForAux,1,nPosFor+10,Space(nPosFor+10))
				    	nX      := (nPosFor+10)
				    Next nX
				    
					QP215CalEns(nOperacao,nFldLab,nPosEnsa,aEnsCal,cFormul,lCoMed)	    
					cFormAux:=""		
				EndIf    
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Cria as dimensoes referentes a: Nao-Conformidades,Cronicas³
				//³e Instrumentos para o Ensaio Calculado.					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nX := 1 to Len(aResultados[nOperacao,_MED,nFldLab,nPosEnsa])
					If Len(aResultados[nOperacao,_NCO,nFldLab,nPosEnsa]) < Len(aResultados[nOperacao,_MED,nFldLab,nPosEnsa]) //nao-conformidades
						Aadd(aResultados[nOperacao,_NCO,nFldLab,nPosEnsa],aClone(aSavaCols[HEAD_NCS])) 
		    		EndIf                          
		    		
					If Len(aResultados[nOperacao,_CRO,nFldLab,nPosEnsa]) < Len(aResultados[nOperacao,_MED,nFldLab,nPosEnsa]) //Cronicas	                                                  
							Aadd(aResultados[nOperacao,_CRO,nFldLab,nPosEnsa],{{""}})
					EndIf                                                   
					
					If Len(aResultados[nOperacao,_INS,nFldLab,nPosEnsa]) < Len(aResultados[nOperacao,_MED,nFldLab,nPosEnsa]) //Instrumentos
						Aadd(aResultados[nOperacao,_INS,nFldLab,nPosEnsa],aClone(aSavaCols[HEAD_INST]))
					EndIf				

				Next nX                                                                                       
					
				If lLayout
					//Atualiza status da medicao para o Ensaio Calculado
					aEnsaios[nOperacao,nFldLab,nPosEnsa,1] := QP215AtuSta(nOperacao,nFldLab,nPosEnsa,"","E",{1},.F.)
					aEnsaios[nOperacao,nFldLab,nPosEnsa,2] := QP215AtuSta(nOperacao,nFldLab,nPosEnsa,"","E",{2},.F.)

					//Atualiza aCols da tela de Objetos
					aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nPosEnsa]:aCols := aClone(aResultados[nOperacao,_MED,nFldLab,nPosEnsa])
					
					aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nPosEnsa]:oBrowse:Refresh()
				Else
					oGetMed:oBrowse:Refresh()
				EndIf
			EndDo
			If !Empty(cForArit)
				nCalc:=&(StrTran(cForArit,",","."))
				aResultados[nOperacao,_MED,nFldLab,nPosEnsa,1,n+5]:=StrTran(str(nCalc,TamSx3("QPS_MEDICA")[1],nDecimal),".",",")
				QP215CoMed(aResultados[nOperacao,_MED,nFldLab,nPosEnsa,1,n+5],nOperacao,nFldLab,nPosEnsa,1,aResultados[nOperacao,_ENS,nFldLab,nPosEnsa,ENSAIO],.T.,lCoMed)
			Endif
			cForArit:=""
		Next n
	EndIf
	
Next nPosEnsa
                   
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³Q215DesPad³ Autor ³Paulo Emidio de Barros ³ Data ³02/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula o Desvio Padrao do Ensaio calculado				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao corrente				    	  ³±±
±±³          ³ EXPN2 = Posicao do Laboratorio corrente					  ³±±
±±³			 ³ EXPN3 = Posicao do Ensaio calculado						  ³±±
±±³			 ³ EXPC2 = Ensaio a ser calculado o desvio padrao			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215DesPad(nPosOpe,nPosLab,nPosEnsCal,cEnsaio)
Local nPosEns  := Ascan(aResultados[nPosOpe,_ENS,nPosLab],{|x|x[ENSAIO]==cEnsaio})
Local aHeadTmp := aClone(aSavHeadEns[nPosOpe,nPosLab,nPosEns])             
Local nPosMed  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
Local nPosKey  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_CHAVE"})
Local nX       := 0
Local nY       := 0
Local nQtdMed  := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,QTDMED]						       
Local nDecimal := QA_NumDec(QP7->QP7_NOMINA) 					   
Local nMedia   := 0
Local nDel	   := 0	 
Local aQtdMed  := {}
Local nTotDes  := 0
Local nDivMed  := 0
Local nIteDel  := 0
Local aResMed  := {}
Local aTotRes  := {}

//Monta Array com as medias
For nX:=1 to nQtdMed
	AADD(aQtdMed,{})
	AADD(aResMed,Space(TamSx3("QPS_MEDICA")[1]))  
	AADD(aTotRes,0)
Next nX

For nX := 1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])
	nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX])
	If !aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX,nDel]            
		For nY:=1 to nQtdMed
			aTotRes[nY] += Round(Val(StrTran(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX,nPosMed+(nY-1)],",",".")),nDecimal)								
			Aadd(aQtdMed[nY],Round(Val(StrTran(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX,nPosMed+(nY-1)],",",".")),nDecimal))	
		Next nY
	Else
		nIteDel++	
    EndIf
Next nX         

For nX:=1 to nQtdMed
	nDivMed := Len(aQtdMed[nX])              
	nDivMed := If(nDivMed==0,1,nDivMed)
	nMedia  := aTotRes[nX]/nDivMed
    nTotDes := 0

	Aeval(aQtdMed[nX],{|x|nTotDes+=((x-nMedia)**2)})

	nTotDes := nTotDes/If(nDivMed>1,(nDivMed-1),1)
	nTotDes := Round(Sqrt(nTotDes),nDecimal)             
	aResMed[nX] := StrTran(Str(nTotDes,TamSx3("QPS_MEDICA")[1],nDecimal),".",",")
Next nX

nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1])

If nIteDel == Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])
	aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel] := .T.
Else	
	If aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel] 
		aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel] := .F.
	EndIf	
EndIf

Return(aResMed)
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215Media³ Autor ³Cleber Souza			³ Data ³01/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Calcula a Media do Ensaio calculado				  		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao corrente	 					  ³±±
±±³          ³ EXPN2 = Posicao do Laboratorio corrente					  ³±±
±±³			 ³ EXPN3 = Posicao do Ensaio calculado						  ³±±
±±³			 ³ EXPC2 = Ensaio a ser calculado a Media					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215Media(nPosOpe,nPosLab,nPosEnsCal,cEnsaio)
Local nPosEns  := Ascan(aResultados[nPosOpe,_ENS,nPosLab],{|x|x[ENSAIO]==cEnsaio})
Local aHeadTmp := aClone(aSavHeadEns[nPosOpe,nPosLab,nPosEns])             
Local nPosMed  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
local nPosKey  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_CHAVE"})
Local nX       := 0
Local nY       := 0
Local nQtdMed  := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,QTDMED]	 						                                          
Local nDecimal := QA_NumDec(QP7->QP7_NOMINA) 					   
Local nDel	   := 0	
Local nIteDel  := 0
Local nQtdDiv  := 0    
Local aQtdRes  := {} 
Local aMedia   := {}
Local aResMed  := {}

//Monta Array com as medias
For nX:=1 to nQtdMed
	AADD(aMedia,"NULL") 	
	AADD(aQtdRes,0)
	AADD(aResMed,Space(TamSx3("QPS_MEDICA")[1])) 	
Next nX

If (nPosMed > 0 .And. nPosEns > 0)

	For nX := 1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])   
		nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX])
		If !aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX,nDel]
			nTotVaz := 0
			For nY:=1 to nQtdMed  
				If Empty(AllTrim(aResultados[nPosOpe,4,nPosLab,nPosEns,nX,nPosMed+(nY-1)]))
					aQtdRes[nY] := "NULL"
				Else
					aQtdRes[nY] += Round(Val(StrTran(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nX,nPosMed+(nY-1)],",",".")),nDecimal)
				EndIf
	        Next nY     
			nQtdDiv ++                                                                                                 
		Else
			nIteDel++			
		EndIf
	Next nX         
	If nQtdDiv == 0
		nQtdDiv := 1
	EndIf
	For nY:=1 to nQtdMed  
		If ValType(aQtdRes[nY]) == "N"
	   		aMedia[nY]  := Round(aQtdRes[nY]/nQtdDiv,nDecimal)
   			aResMed[nY] := StrTran(Str(aMedia[nY],TamSx3("QPS_MEDICA")[1],nDecimal),".",",")
  		EndIf
   	Next
EndIf    
                                                  
nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,1])
                     
If nIteDel == Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])
    aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel] := .T.
Else
	If aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel]
		aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1,nDel] := .F.
	EndIf	
EndIf

Return(aResMed)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215CalEns³ Autor ³Cleber Souza		    ³ Data ³01/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza o calculo aritmetico das formulas				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao Corrente						  ³±±
±±³			 ³ EXPN2 = Posicao do Laboratorio Corrente			  		  ³±±
±±³			 ³ EXPN3 = Posicao do Ensaio Calculado				  		  ³±±
±±³			 ³ EXPA1 = Vetor com os ensaios a serem calculados			  ³±±
±±³			 ³ EXPC1 = Formula a ser aplicada							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215CalEns(nPosOpe,nPosLab,nPosEnsCal,aEnsaio,cFormul,lCoMed)
Local lLayout	  := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aHeadTmp    := aClone(aSavHeadEns[nPosOpe,nPosLab,nPosEnsCal])             
Local nMedCal     := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
Local nPosKey     := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_CHAVE"})   
Local nPosDtaMed  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})   
Local nPosHorMed  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})   
Local nPosEnsr    := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_ENSR"})  
Local nPosNomEns  := Ascan(aHeadTmp[1],{|x|Alltrim(x[2])=="QPR_ENSRNO"})
Local nEnsCal     := 0
Local nDel        := 0                   
Local aEnsCal     := {}
Local nMaior      := 0  
Local nQtdEns     := 0   
Local nPosCer     := 0
Local cForAux     := ""
Local cResMed     := ""
Local nQtdMed     := QP215QtdMed(aEnsaio[1,1]) 						                                          
Local nDecimal    := QA_NumDec(QP7->QP7_NOMINA) 					   
Local nX 		  := 0
Local nY   		  := 0
Local nW   		  := 0
Local aMedAtu     := {}         
Local aMedCal     := {}
Local lAtualiza 
Local nComma 
Local cCarta      := aResultados[nPosOpe,_ENS,nPosLab,nPosEnsCal,CARTA]     

Default lCoMed := .F.

If !lLayout
	aResultados[nPosOpe,_MED,nPosLab,nPosEns] := aClone(oGetMed:aCols)
EndIf

nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,1]) //Posicao de item deletado

For nX := 1 to Len(aEnsaio) 
	nEnsCal := aEnsaio[nX,2]
	If nMaior < Len(aResultados[nPosOpe,_MED,nPosLab,nEnsCal])  
		nMaior := Len(aResultados[nPosOpe,_MED,nPosLab,nEnsCal])  
	EndIf		
Next nX

nQtdEns := Len(aEnsaio) 
aEnsCal := Array(nMaior,nQtdMed,nQtdEns)
For nY:=1 to nMaior
	For nX:=1 to nQtdMed
		For nW:=1 to nQtdEns
			aEnsCal[nY,nX,nW]:= "(0)"
		Next nW
	Next nX
Next nY	

For nX := 1 to Len(aEnsaio) 
	nEnsCal := aEnsaio[nX,2]                                      

 	For nY := 1 to Len(aResultados[nPosOpe,_MED,nPosLab,nEnsCal])  
 		nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nEnsCal,nY])
 		If !aResultados[nPosOpe,_MED,nPosLab,nEnsCal,nY,nDel]    
			For nW:=1 to nQtdMed
				If !Empty(aResultados[nPosOpe,_MED,nPosLab,nEnsCal,nY,nMedCal+(nW-1)])   		
		 		    aEnsCal[nY,nW,nX] := aResultados[nPosOpe,_MED,nPosLab,nEnsCal,nY,nMedCal+(nW-1)]  
			    Else
		 		    aEnsCal[nY,nW,nX] := "(0)"
			    EndIf
			Next nW 
		Else
			For nW:=1 to nQtdMed
				aEnsCal[nY,nW,nX] := "DEL"    	
			Next nW
   	 	EndIf
 	Next nY
 	
Next nX
           
For nX := 1 to Len(aEnsCal)
	If Len(aResultados[nPosOpe,_MED,nPosLab,nEnsCal]) >= nX
		aMedAtu := {}
		For nW := 1 to nQtdMed
			cForAux := cFormul     
			For nY := 1 to Len(aEnsCal[nX,nW])
				nPosCer := At("#",cForAux)
				If nPosCer > 0
					cForAux := Stuff(cForAux,nPosCer,10,Iif(cCarta=="TMP",;
															Iif(aEnsCal[nX,nW,nY]<>"DEL",;
																QP215HTOM(aEnsCal[nX,nW,nY]),;
																aEnsCal[nX,nW,nY]),;
															aEnsCal[nX,nW,nY]))
				EndIf			                             
		    Next nY        
	                                       
		    If !(At("#",cForAux) > 0) .And. !(At("(0)",cForAux) > 0)
				If nW==1
					aMedAtu := aClone(aResultados[nPosOpe,_MED,nPosLab,nEnsCal,nX])    
	   	 		EndIf       
	    
	    		If (At("DEL",cForAux) > 0)    
					cResMed        := Space(TamSx3("QPS_MEDICA")[1])
					aMedAtu[nDel] := .T.
		    	Else          
	    			nComma := At(",",cForAux)
	    			If nComma > 0           
		    			cForAux := StrTran(cForAux,",",".")
			    	EndIf	
		    		cResMed := Str((&cForAux),TamSx3("QPS_MEDICA")[1],nDecimal)               
	    			If cCarta # "TMP"
						If nComma > 0	
			    			cResMed := StrTran(cResMed,".",",")
			    		EndIf	
					Else 
			   			cResMed := QP215MTOH(Val(cResMed))
					EndIF
		   			aMedAtu[nDel] := .F.	
	    		EndIf
				If Len(aResultados[nPosOpe,_MED,nPosLab,aEnsaio[1,2]]) >= nX 
	   		    	aMedAtu[nMedCal+(nW-1)] := cResMed
		   		    aMedAtu[nPosEnsr] := aResultados[nPosOpe,_MED,nPosLab,aEnsaio[1,2],nX,nPosEnsr]
		  		EndIf
		    EndIf              
	    Next nW          
	    If Len(aMedAtu) > 0
	        Aadd(aMedCal,aClone(aMedAtu))
	    EndIf              
	EndIf
Next nX

If Len(aMedCal) > 0 
                
	lAtualiza := .T.
	
	For nX := 1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])                         
		If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosKey])
			lAtualiza := If(lAtualiza,.F.,lAtualiza)
		EndIf
	Next nX

	If lAtualiza
	   	aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal] := aClone(aMedCal)
	   	
	   	For nX := 1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])           
	 		aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosDtaMed] := dDataBase   	
			aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosHorMed] := QP215HorMed(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])
            
            If Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEnsCal]) < nX
            	//Acerta aResultados das Nao Conformidades
				Aadd(aResultados[nPosOpe,_NCO,nPosLab,nPosEnsCal],aClone(aSavaCols[HEAD_NCS]))

				//Acerta aResultados dos Instrumentos
				Aadd(aResultados[nPosOpe,_INS,nPosLab,nPosEnsCal],aClone(aSavaCols[HEAD_INST]))

	   			//Acerta aResultados da Cronica da Nao Conformidade
				Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEnsCal],{})
				Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEnsCal,nX],{})
				Aadd(aResultados[nPosOpe,_CRO,nPosLab,nPosEnsCal,nX,1],"")
            EndIF
            
			For nW:=1 to nQtdMed
				cResMed := aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nMedCal+(nW-1)]
		    	QP215CoMed(cResMed,nPosOpe,nPosLab,nPosEnsCal,nX,aResultados[nPosOpe,_ENS,nPosLab,nPosEnsCal,ENSAIO],.T.,lCoMed) 
	    	Next nW
	
		Next nX	     
		
	Else        
		For nX := 1 to Len(aMedCal)
			If nX <= Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])
				For nW:=1 to nQtdMed
					cResMed := aMedCal[nX,nMedCal+(nW-1)]
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nMedCal+(nW-1)] := cResMed
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nDel] := aMedCal[nX,nDel]
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosEnsr] 	   		:= aMedCal[nX,nPosEnsr]
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosNomEns]			:= Posicione("QAA",1,xFilial("QAA")+aMedCal[nX,nPosEnsr],"QAA_APELIDO")  
					QP215CoMed(cResMed,nPosOpe,nPosLab,nPosEnsCal,nX,aResultados[nPosOpe,_ENS,nPosLab,nPosEnsCal,ENSAIO],.T.,lCoMed)
				Next nW
			Else                               
				cResMed := aMedCal[nX,nMedCal]                             
				aMedAtu := aClone(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,Len(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])])
				Aadd(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal],aClone(aMedAtu))	
				For nW:=1 to nQtdMed			
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosDtaMed] := dDataBase   	
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosHorMed] := QP215HorMed(aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal])
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosKey]    := " "
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nDel] 		:= aMedCal[nX,nDel]
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosEnsr] 	:= aMedCal[nX,nPosEnsr]
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nPosNomEns]	:= Posicione("QAA",1,xFilial("QAA")+aMedCal[nX,nPosEnsr],"QAA_APELIDO")  
					aResultados[nPosOpe,_MED,nPosLab,nPosEnsCal,nX,nMedCal+(nW-1)] 	:= cResMed

					QP215CoMed(cResMed,nPosOpe,nPosLab,nPosEnsCal,nX,aResultados[nPosOpe,_ENS,nPosLab,nPosEnsCal,ENSAIO],.T.,lCoMed)
				Next nW
			EndIf           
		Next
	EndIf	
EndIf        

Return(NIL)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215CoMed³ Autor ³ Cleber Souza          ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Consiste as medicoes digitadas							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 - Medicao Atual									  ³±±
±±³			 ³ EXPN1 - Posicao da Operacao								  ³±±
±±³			 ³ EXPN2 - Posicao do Laboratorio							  ³±±
±±³			 ³ EXPN3 - Posicao do Ensaio								  ³±±
±±³			 ³ EXPN4 - Posicao da Linha na aCols						  ³±±
±±³			 ³ EXPC2 - Ensaio Informado									  ³±±
±±³			 ³ EXPL1 - Indica se eh um ensaio calculado					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215				 									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215CoMed(cMediAtu, nPosOpe, nPosLabi, nPosEnsa, nPosLin, cEnsInf, lCalc, lCoMed)   
				   
Local nPTol		  := 0
Local nLIETol	  := 0
Local nLSETol	  := 0
Local nDec		  := 0
Local nCntFor	  := 0
Local nMed		  := 0
Local lRet		  := .T.
Local lErr1 	  := .F.		// Medicao fora do intervalo
Local lErr2 	  := .F.		// Existencia de Nao Conformidade
Local aMediana	  := {}		// Ser  utilizada no calculo da mediana
Local lAprCond	  := .F.		// Existencia de medicao fora limites mas dentro toler.
Local cRevi		  := Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cOper		  := ""
Local cEns        := ""
Local nQtdMed 	  := ""
Local cCarta	  := ""
Local nPosPri	  := 0
Local nPosPrv	  := 0
Local nPosNex	  := 0
Local nQP7_LIE	  := 0
Local nQP7_LSE	  := 0  
Local aHeadTMP    := {}
Local nPosRDat	  := ""
Local nPosDIni	  := ""
Local nPosHini	  := ""
Local nPosDFim	  := ""
Local nPosHFim	  := ""
Local nPosRes     := ""
Local nPosMed     := 0
Local nDia		  := 0
Local cMedica	  := ""
Local nDecMed	  := 0
Local nX		  := 0
Local nOcoDes	  := 0
Local nCins		  := 0
Local nPosColun	  := 0 
Local aColsAux    := {}
Local aColInst    := {}
Local N           := 0 
Local cVar        := "" 
Local cQPT_INSTR  := CriaVar("QPT_INSTR")
Local cQPT_REVINS := CriaVar("QPT_REVINS")
Local cQM2_VALDAF := CriaVar("QM2_VALDAF")
Local cQM2_TIPO	  := CriaVar("QM2_TIPO")
Local cQM2_REVTIP := CriaVar("QM6_REVTIP")
Local lLayout	  := GetMv("MV_QPTRLAY",.F.,"1") == "1"   
Local lValEns	  := GetMv("MV_QL2AEML",.F.,"1") == "1"   // Verifico se, somene para a tela do Layout 2 se efetua a Atualização do Ensaio 
Local nSaveSX8    := GetSX8Len()
Local cChave	  := ''

Default lCoMed  := .F.  

If lLayout
	DEFAULT nPosOpe	 := nOperacao 
	DEFAULT nPosLabi := nFldLab 
	DEFAULT nPosEnsa := nEnsaio 
	DEFAULT lCalc    := .F.

	cOper	 :=	aResultados[nPosOpe,_OPE] 
Else

	DEFAULT nPosOpe	 := nPosOper 
	DEFAULT nPosLabi := nPosLab 
	DEFAULT nPosEnsa := oBrwJJ:nAt 
	DEFAULT lCalc    := .F. 

//	Q216ARESU()	
	cOper	 :=	aResultados[nPosOpe,_OPE] 

EndIf

cEns     := aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,ENSAIO] 
aHeadTMP := aClone(aSavHeadEns[nPosOpe,nPosLabi,nPosEnsa])   
nPosRDat := ascan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPS_MEDICA'})
nPosDIni := ascan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPR_DTINI' })
nPosHini := ascan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPR_HRINI' })
nPosDFim := ascan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPR_DTFIM' })
nPosHFim := ascan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPR_HRFIM' })   
nPosRes  := aScan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPR_RESULT' })
nPosChv  := aScan(aHeadTMP[1], { |x| AllTrim(x[2]) == "QPR_CHAVE" })
If nPosRes == 0
	nPosRes   := aScan(aHeadTMP[1], { |x| AllTrim(x[2]) == 'QPQ_RESULT' })
EndIf        

If !lCalc
	If lLayout
		aColsAux := aObjetos[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsa]:aCols 
		N        := aObjetos[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsa]:nAT
		cVar     := ReadVar() 
	Else
		aColsAux := oGetMed:aCols
		N        := oGetMed:nAT 
		cVar     := ReadVar() 
	EndIf
Else 
	aColsAux := aClone(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa])
	N        := nPosLin
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Numero de Medicoes                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nQtdMed	:=	aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,QTDMED]	
cCarta	:=	aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,CARTA]

If cCarta <> "TXT"
	If cCarta <> "P  "
		nPosMed := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDICA' })
	Else
		nPosMed := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDIPA' })
	EndIF
	nPosRes := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPR_RESULT' })
Else
	nPosMed := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPQ_MEDICA' })
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Somente em situacao diferente de visualizacao           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If Iif(lLayout, nOpcX <> 2, .T.)
	If cCarta <> "P  " .And. cCarta <> "TMP"
		DEFAULT cMediAtu := If(Valtype(aColsAux[n,nPosMed])=="N",Str(aColsAux[n,nPosMed]),aColsAux[n,nPosMed])
		//nPosColun  := aObjetos[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEns]:oBrowse:nColPos
		
		If !Empty(cMediAtu)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula os limites inferior e superior com a tolerancia ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Porcentagem de Tolerancia
			nPTol := QP6->QP6_PTOLER / 100

			// Localiza Especif. Ensaio
			QP7->(dbSetOrder(1))
			QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns))

			// Limites com tolerancia
			If At('i',QP7->QP7_NOMINA) == 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Determina o no. casas decimais para valor nominal                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nDec := QA_NumDec(QP7->QP7_NOMINA)

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a medicao informada nao estah compativel com o mesmo numero de casas³
				//³ decimais. Caso nao esteja retorna .F.                                        ³
				//³ Verifica atraves do parametro MV_QPMEAUT - Onde poderah informar a medicao   ³
				//³ automatica atraves do Instrumento.                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If cMv_QPMEAUT	== "S"
			         cMediAtu	:= Val(StrTran(cMediAtu,",","."))
			         cMediAtu	:= Str(cMediAtu,8,nDec)
			         cMediAtu	:= StrTran(cMediAtu,".",",")
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Determina o no. casas decimais para valor da medicao                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nDecMed := QA_NumDec(cMediAtu)
				
				If nDec <> nDecMed
					Help(" ",1,"QPH215052") //A medição informada não está com o mesmo número de casas decimais. Por favor verifique. 
					aColsAux[n,nPosMed]	:= Space(TamSX3("QPS_MEDICA")[1])
					Return(.F.)
				EndIf
				
				nLSETol := round(SuperVal(QP7->QP7_LSE) + ( SuperVal(QP7->QP7_LSE)*nPTol ),nDec)
				nLIETol := round(SuperVal(QP7->QP7_LIE) - ( SuperVal(QP7->QP7_LIE)*nPTol ),nDec)
			Else
				//Verificar
				If !QA_CalPol(cMediAtu)
					Return .F.
				EndIf
			
				nLSETol := QA_CalLiPol(QP7->QP7_LSE)
				nLIETol := QA_CalLiPol(QP7->QP7_LIE)
				nLSETol := nLSETol + nLSETol*nPTol
				nLIETol := nLIETol - nLIETol*nPTol
			EndIf
			// Posiciona Ensaio
			QP1->(dbSeek(xFilial("QP1")+cEns))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Compara as medicoes com os Limites ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nCntFor := 1 to nQtdMed	// Private nQtdMed
				If nQtdMed == 1
					If At('i',QP7->QP7_NOMINA) == 0
						nMed := SuperVal(cMediAtu)
					Else	
						nMed := QA_CalLiPol(cMediAtu)
					EndIf
				Else
					If At('i',QP7->QP7_NOMINA) == 0
						If nPosMed == nCntFor
							nMed := SuperVal(cMediAtu)
						Else
							If lCalc
								nMed := SuperVal(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosMed+nCntFor-1])
							Else
								If lLayout
									If aObjetos[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEnsa]:oBrowse:nColPos == (nPosMed+nCntFor-1)
					  					nMed := SuperVal(&(cVar))
									Else    	
						  				nMed := SuperVal(aColsAux[n,nPosMed+nCntFor-1])
									EndIF 
								Else 
									If oGetMed:oBrowse:nColPos == (nPosMed+nCntFor-1)
					  					nMed := SuperVal(&(cVar))
									Else    	
						  				nMed := SuperVal(aColsAux[n,nPosMed+nCntFor-1])
									EndIF 
								EndIf
							EndIf
						EndIf
					Else	
						nMed := QA_CalLiPol(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,n,nPosMed+nCntFor-1])
					EndIf
				EndIf
				
				nQP7_LIE	:=Iif(At('i',QP7->QP7_LIE)==0,SuperVal(QP7->QP7_LIE),QA_CalLiPol(QP7->QP7_LIE))
				nQP7_LSE	:=Iif(At('i',QP7->QP7_LSE)==0,SuperVal(QP7->QP7_LSE),QA_CalLiPol(QP7->QP7_LSE))
				
				If cCarta $ 'XBR.XBS.IND.HIS'
					If QP7->QP7_MINMAX == "1"  // Controla Min e Max
						// Verifica se a Medicao est  dentro dos limites c/ tolerancia
						If nMed > nLSETol .or. nMed < nLIETol
							lErr1 := .T.
						EndIf
						
						// Verifica se est  fora dos limites, mas dentro da tolerancia
						If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
							If nMed >= nLIETol .And. nMed <= nLSETol
								lAprCond := .T.
							EndIf
						EndIf
						
					ElseIf QP7->QP7_MINMAX == "2" // Controla Min
						// Verifica se a Medicao est  dentro dos limites c/ tolerancia
						If nMed < nLIETol
							lErr1 := .T.
						EndIf
						
					ElseIf QP7->QP7_MINMAX == "3" // Controla Max
						// Verifica se a Medicao est  dentro dos limites c/ tolerancia
						If nMed > nLSETol
							lErr1 := .T.
						EndIf
					EndIf
					
					If lErr1
						Exit
					EndIf
			
				ElseIf cCarta == 'NP ' 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atenção:                                                                             ³
				//³                                                                                     ³
				//³Esta carta tem um funcionamento diferente, muito cuidado com alterações neste  ponto.³
				//³                                                                                     ³
				//³Regras:                                                                              ³
				//³                                                                                     ³
				//³1. O numero de unidades não pode ser maior que o numero de amostras.                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//Verifica se as medicoes nao-conformes sao maiores que a Amostra
					If nMed > QP1->QP1_QTDE
						lRet := .F.
					Else
						//Verifica se a medicao esta dentro dos limites com a Tolerancia
						If nMed > nLSETol .Or. nMed < nLIETol
							lErr1 := .T.
						Else
							//Verifica se a medicao esta fora dos limites , mas dentro da Tolerancia
							If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
								If nMed >= nLIETol .And. nMed <= nLSETol
									lAprCond := .T.
								EndIf
							EndIf
						EndIf
					EndIf				
					
				ElseIf cCarta == 'C  ' 
					//Verifica se a medicao esta dentro dos limites com a Tolerancia
					If nMed > nLSETol .Or. nMed < nLIETol
						lErr1 := .T.
					Else
						//Verifica se a medicao esta fora dos limites , mas dentro da Tolerancia
						If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
							If nMed >= nLIETol .And. nMed <= nLSETol
								lAprCond := .T.
							EndIf
						EndIf
					EndIf        
					
				ElseIf cCarta == 'U  '
					If nCntFor == 2
						//Verifica se a medicao esta dentro dos limites com a Tolerancia
						If nMed > nLSETol .Or. nMed < nLIETol
							lErr1 := .T.
						Else
							//Verifica se a medicao esta fora dos limites , mas dentro da Tolerancia
							If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
								If nMed >= nLIETol .And. nMed <= nLSETol
									lAprCond := .T.
								EndIf
							EndIf
						EndIf
					EndIf				
				
				ElseIf cCarta == 'XMR'
					aadd(aMediana,nMed)
				EndIf
			Next nCntFor
			
			If cCarta == 'XMR'
				nMed := QA_CALXM(aMediana) 	// Calcula mediana - QAXFUN
				If QP7->QP7_MINMAX == "1"  // Controla Min e Max
					// Verifica se a Mediana est  dentro dos limites c/ tolerancia
					If nMed > nLSETol .or. nMed < nLIETol
						lErr1 := .T.
					EndIf
					
					// Verifica se est  fora dos limites, mas dentro da tolerancia
					If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
						If nMed >= nLIETol .And. nMed <= nLSETol
							lAprCond := .T.
						EndIf
					EndIf
					
				ElseIf QP7->QP7_MINMAX == "2" // Controla Min
					// Verifica se a Mediana est  dentro dos limites c/ tolerancia
					If nMed < nLIETol
						lErr1 := .T.
					EndIf
					
					// Verifica se est  fora dos limites, mas dentro da tolerancia
					If nMed < nQP7_LIE .And. nMed >= nLIETol
						lAprCond := .T.
					EndIf
					
				ElseIf QP7->QP7_MINMAX == "3" // Controla Max
					// Verifica se a Mediana est  dentro dos limites c/ tolerancia
					If nMed > nLSETol
						lErr1 := .T.
					EndIf
					
					// Verifica se est  fora dos limites, mas dentro da tolerancia
					If nMed > nQP7_LSE .And. nMed <= nLSETol
						lAprCond := .T.
					EndIf
				EndIf
			EndIf
			
			If lRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza campo Resultado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Considera "A" - Aprovado
				// 			 "T" - Aprovado pela tolerancia
				// 			 "R" - Reprovado
	
				If lCalc
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRes]	 := Iif(lErr1 .Or. lErr2,"R",Iif(lAprCond,"T","A"))
					nPosEnsRef := Ascan(aResultados[nPosOpe,_ENS,nPosLabi],{|x|x[ENSAIO]==Substr(aResultados[nPosOpe,3,nPosLabi,nPosEnsa,20],At("#",aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,20])+1,8)})
					If nPosEnsRef > 0 .AND. aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosChv] == aResultados[nPosOpe,_MED,nPosLabi,nPosEnsRef,nPosLin,nPosChv]
						aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosChv] := Space(TamSX3("QPR_CHAVE")[1])
					EndIf
				Else
					aColsAux[n,nPosRes] := Iif(lErr1 .Or. lErr2,"R",Iif(lAprCond,"T","A"))
					M->QPR_RESULT := aColsAux[n,nPosRes]   
				EndIf
			EndIf
		Else
			If !lCalc
				M->QPR_RESULT			:=	aColsAux[n,nPosRes]
			Else
				aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRes]	:=	" " 
				aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosChv] := Space(TamSX3("QPR_CHAVE")[1])
			EndIF
		EndIf
		
	ElseIf cCarta == "TMP" // .And. n <= Len(aResultado[nPosAtu,4])
		If QP1->QP1_TIPO <> "C"
			If ReadVar() =="M->QPR_HRFIM" 
				aColsAux[n,nPosHFim] := M->QPR_HRFIM
				If	!Empty(aColsAux[n,nPosDIni]) .And. !Empty(aColsAux[n,nPosDFim]) .And.!Empty(aColsAux[n,nPosHIni])
					nDia	:= DiaUtil(aColsAux[n,nPosDIni],aColsAux[n,nPosDFim])
					aColsAux[n,nPosRDat] := PadL(AllTrim(QA_CalHor(nDia,aColsAux[n,nPosHFim],aColsAux[n,nPosHIni])),6,"0")
					M->QPS_MEDICA := aColsAux[n,nPosRDat]
					cMedica := aColsAux[n,nPosRDat]
				EndIf
			ElseIf ReadVar() =="M->QPR_HRINI" 
				aColsAux[n,nPosHIni] := M->QPR_HRINI
				If	!Empty(aColsAux[n	,nPosDIni]) .And. !Empty(aColsAux[n,nPosDFim]) .And.!Empty(aColsAux[n,nPosHFim])
					nDia	:= DiaUtil(aColsAux[n,nPosDIni],aColsAux[n,nPosDFim])
					aColsAux[n,nPosRDat] := PadL(AllTrim(QA_CalHor(nDia,aColsAux[n,nPosHFim],aColsAux[n,nPosHIni])),6,"0")
					M->QPS_MEDICA := aColsAux[n,nPosRDat]
					cMedica := aColsAux[n,nPosRDat]
				EndIf
			ElseIf ReadVar() =="M->QPR_DTFIM" 
				aColsAux[n,nPosDFim] := M->QPR_DTFIM
				If	!Empty(aColsAux[n,nPosDIni]) .And.!Empty(aColsAux[n,nPosHFim]).And.!Empty(aColsAux[n,nPosHIni])
					nDia	:= DiaUtil(aColsAux[n,nPosDIni],aColsAux[n,nPosDFim])
					aColsAux[n,nPosRDat] := PadL(AllTrim(QA_CalHor(nDia,aColsAux[n,nPosHFim],aColsAux[n,nPosHIni])),6,"0")
					M->QPS_MEDICA := aColsAux[n,nPosRDat]
					cMedica := aColsAux[n,nPosRDat]
				EndIf
			ElseIf ReadVar() =="M->QPR_DTINI" 
				aColsAux[n,nPosDIni] := M->QPR_DTINI
				If	!Empty(aColsAux[n,nPosDFim]) .And.!Empty(aColsAux[n,nPosHFim]).And.!Empty(aColsAux[n,nPosHIni])
					nDia	:= DiaUtil(aColsAux[n,nPosDIni],aColsAux[n,nPosDFim])
					aColsAux[n,nPosRDat] := PadL(AllTrim(QA_CalHor(nDia,aColsAux[n,nPosHFim],aColsAux[n,nPosHIni])),6,"0")
					M->QPS_MEDICA := aColsAux[n,nPosRDat]
					cMedica := aColsAux[n,nPosRDat]
				EndIf
			EndIf
		Else
			Iif(Empty(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosDIni]),(cMediAtu := "    ", aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRDat]:= "    "),)
			If !Empty(AllTrim(cMediAtu))
				cMediAtu := StrZero(Val(Left(cMediAtu,At(":",cMediAtu))),3)+":"+StrZero(Val(Right(cMediAtu,2)),2)
				M->QPS_MEDICA := cMediAtu
				cMedica := AllTrim(cMediAtu)
			Else
				M->QPS_MEDICA := aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRDat]
				cMedica := aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRDat]
			EndIf
		EndIf
		                                  
		If !Empty(cMedica)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula os limites inferior e superior com a tolerancia ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Porcentagem de Tolerancia
			nPTol := QP6->QP6_PTOLER / 100
				
			// Localiza Especif. Ensaio
			QP7->(dbSetOrder(1))
			QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns))
		
			// Limites com tolerancia
			nLSETol := SuperVal(QP7->QP7_LSE) + ( SuperVal(QP7->QP7_LSE)*nPTol )
			nLIETol := SuperVal(QP7->QP7_LIE) - ( SuperVal(QP7->QP7_LIE)*nPTol )
		
			// Posiciona Ensaio
			QP1->(dbSeek(xFilial("QP1")+cEns))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Compara as medicoes com os Limites ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nMed := SuperVal(cMedica)
			nQP7_LIE	:=SuperVal(QP7->QP7_LIE)
			nQP7_LSE	:=SuperVal(QP7->QP7_LSE)
			
			If QP7->QP7_MINMAX == "1"  // Controla Min e Max
				// Verifica se a Mediana est  dentro dos limites c/ tolerancia
				If nMed > nLSETol .or. nMed < nLIETol
					lErr1 := .T.
				EndIf
				
				// Verifica se est  fora dos limites, mas dentro da tolerancia
				If nMed < nQP7_LIE .Or. nMed > nQP7_LSE
					If nMed >= nLIETol .And. nMed <= nLSETol
						lAprCond := .T.
					EndIf
				EndIf
					
			ElseIf QP7->QP7_MINMAX == "2" // Controla Min
				// Verifica se a Mediana est  dentro dos limites c/ tolerancia
				If nMed < nLIETol
					lErr1 := .T.
				EndIf
					
				// Verifica se est  fora dos limites, mas dentro da tolerancia
				If nMed < nQP7_LIE .And. nMed >= nLIETol
					lAprCond := .T.
				EndIf
					
			ElseIf QP7->QP7_MINMAX == "3" // Controla Max
				// Verifica se a Mediana est  dentro dos limites c/ tolerancia
				If nMed > nLSETol
					lErr1 := .T.
				EndIf
					
				// Verifica se est  fora dos limites, mas dentro da tolerancia
				If nMed > nQP7_LSE .And. nMed <= nLSETol
					lAprCond := .T.
				EndIf
			EndIf
			
			If lRet
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza campo Resultado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				// Considera "A" - Aprovado
				// 			 "T" - Aprovado pela tolerancia
				// 			 "R" - Reprovado
	
				If QP1->QP1_TIPO <> "C"
					aColsAux[n,nPosRes] := Iif(Empty(cMedica),'',Iif(lErr1 .Or. lErr2,"R",Iif(lAprCond,"T","A")))
					M->QPR_RESULT := aColsAux[n,nPosRes]
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza o Vetor principal                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cCarta =='IND'
						aColsAux[n,nPosMed]		:= cMedica
					EndIf
				Else
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRes]	    := Iif(Empty(cMediAtu),'',Iif(lErr1 .Or. lErr2,"R",Iif(lAprCond,"T","A")))
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosDIni]	:= Ctod("11/11/11","ddmmyyyy") //dDataBase
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosHini]	:= "11:11" //SubStr(Time(),1,5)
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosDFim]	:= Ctod("11/11/11","ddmmyyyy") //dDataBase
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosHFim]	:= "11:11" //SubStr(Time(),1,5) 
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRDat]	:= cMedica
					aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosChv]    := Space(TamSX3("QPR_CHAVE")[1])
					M->QPR_RESULT := aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,nPosLin,nPosRes]
				Endif	
			EndIf
		EndIf
	EndIf          
	
	If lLayout
		//Atualiza campo de Metodo e Revisao do Documento
		QP215Metod(nPosOpe,nPosLabi,nPosEnsa)
	EndIf
	
	If !lLayout
		If Len(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa]) >= oGetMed:nAT
			aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,oGetMed:nAT,nPosChv],"QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
		Else
			aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
		EndIf
	Else    
		If Len(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa]) >= aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,nPosEnsa]:nAT
			aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,nPosEnsa]:nAT,nPosChv],"QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
		Else
			aColInst    := aClone(	Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST])))
		EndIf
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Faz atualizacao automatica dos instrumentos a partir do(s)  Instrumento(s) informado(s) ³
	//³ na primeira medicao.                                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cMV_QPINAUT == "S"
		If n > 1 .And. !lCalc
			For nCins := 1 To Len(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1])
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Faz a inclusao de nova linha no Instrumento       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Len(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa]) < N
					Aadd(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa], {})
					Aadd(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N],aClone(aColInst[1]))
				ElseIf Len(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N]) < nCIns
					Aadd(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N],aClone(aColInst[1]))
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ No momento da inclusao verifica se o instrumento estah vazio e tem familia  vinculada ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If 	Empty(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,1])  .AND.;
					aResultados[nPosOpe,_ENS,nPosLabi,nPosEnsa,FAMVINC]
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,1]	:= aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,1]
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,2]	:= aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,2]
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,3]	:= aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,3]
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,4]	:= aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,4]
					aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,5]	:= aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,5]

					If aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns,Len(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns])]
						aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N,nCIns,Len(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,1,nCIns])] := .T.				
					EndIf
					
					If Len(aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa]) >= N .AND. Empty(AllTrim(aResultados[nPosOpe,4,nPosLabi,nPosEnsa,N,nPosChv]))
						cChave := QA_SXESXF("QPR","QPR_CHAVE",,4)
						While ( GetSX8Len() > nSaveSx8 )
							ConfirmSX8()
						EndDo
						aResultados[nPosOpe,_MED,nPosLabi,nPosEnsa,N,nPosChv] := cChave
						aColsAux[N,nPosChv] := cChave 
					EndIf
					
					If !lLayout .AND. oGetIns <> Nil
					 	oGetIns:aCols := aClone(aResultados[nPosOpe,_INS,nPosLabi,nPosEnsa,N])
					EndIf
				EndIf
			Next nCIns
			lAtuIns := .T.
			If lLayout 
				QP215AtuSta(nPosOpe,nPosLabi,nPosEnsa,"","E",{3},.T.)
			Else 
				aListEns[nPosEnsa,3] := QP215AtuSta(nPosOpe,nPosLabi,nPosEnsa,"","E",{3},.T.)
				QP216AtuEns(oBrwJJ:oWnd, nPosOpe, nPosLabi, nPosLabi, nPosEnsa, .F.)
			EndIf
		EndIf
	EndIf
EndIf                                                                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para validar o resultado da medição ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215VRM")	
   	aColsAux[n,nPosRes] := ExecBlock("QP215VRM",.F.,.F.,{aColsAux[n,nPosRes],cCarta})
	M->QPR_RESULT	 := aColsAux[n,nPosRes]
Endif     

/*If !lLayout .AND. lValEns .AND. !lCalc                                               
	aResultados[nPosOpe,_MED, nPosLabi, nPosEns] :=  aClone(oGetMed:aCols)
	QP216AtuEns(oBrwJJ:oWnd, nPosOpe, nPosLabi, nPosLabi, oBrwJJ:nAt, .T.) 
	//lAtuCalc := .T.
EndIf */

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215VlPN ³ Autor ³ Cleber Souza          ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida campo Num.Nao Conforme - Carta P					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpL1 = Retorno da Validacao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA220 - E' cham. no X3_VALID do QPS_MEDIPN (virtual)     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VlPN()
Local lRet		:= .T.
Local cVar		:= &(Readvar()) // Conteudo da variavel do campo Num.N.Conforme
Local nPTol		:= 0
Local nDec		:= 0
Local nLSETol	:= 0
Local nLIETol	:= 0
Local nMed		:= 0
Local lMaior	:= .F.
Local lAprCon	:= .F.
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cOper		:= aResultados[nOperacao,_OPE]
Local cEns      := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]    
Local cCarta    := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]    
Local aCols     := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols 
Local N         := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT   
Local aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio])
Local nPosCal	:= ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_CALPOR' })
Local nPosPP	:= ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDIPP' })
Local nPosPN	:= ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDIPN' })
Local nPosMed   := 0
Local nPosRes   := 0

If cCarta <> "TXT"
	If cCarta <> "P  "
		nPosMed := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDICA' })
	Else
		nPosMed := ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_MEDIPA' })
	EndIF
	nPosRes := ascan(aHeader, { |x| alltrim(x[2]) == 'QPR_RESULT' })
Else
	nPosMed := ascan(aHeader, { |x| alltrim(x[2]) == 'QPQ_MEDICA' })
	nPosRes := ascan(aHeader, { |x| alltrim(x[2]) == 'QPQ_RESULT' })
EndIf
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula os limites inferior e superior com a tolerancia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Porcentagem de Tolerancia
nPTol := QP6->QP6_PTOLER / 100

// Localiza Especif. Ensaio
QP7->(dbSetOrder(1))
QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Determina o no. casas decimais                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDec := QA_NumDec(QP7->QP7_NOMINA)

nLSETol := round(SuperVal(QP7->QP7_LSE) + ( SuperVal(QP7->QP7_LSE)*nPTol ),nDec)
nLIETol := round(SuperVal(QP7->QP7_LIE) - ( SuperVal(QP7->QP7_LIE)*nPTol ),nDec)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se e' maior que a Amostra ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cVar > aCols[n][nPosMed]
	Help(" ",1,"QPH215053") //Unidades Não Conformes maior que a Amostra
	lRet := .F.
EndIf

If lRet

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calcula a Porcentagem Nao Conforme ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,nPosPP] := (cVar * 100) / aCols[n,nPosMed]
	nMed := aCols[n,nPosPP]
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Marca de calculo autom. Porcentagem Nao Conforme ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,nPosCal] := "S"
	M->QPS_CALPOR := "S"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a Porcentagem est  dentro dos limites c/ tolerancia		 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nMed > nLSETol .or. nMed < nLIETol
		lMaior := .T.
	Else
		// Verifica se est  fora dos limites, mas dentro da tolerancia
		If nMed < SuperVal(QP7->QP7_LIE) .Or. nMed > SuperVal(QP7->QP7_LSE)
			If nMed >= nLIETol .And. nMed <= nLSETol
				lAprCon := .T.
			EndIf
		EndIf
	EndIf
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Considera "A" - Aprovado 											 ³
	//³ 		 "T" - Aprovado pela tolerancia								 ³
	//³ 		 "R" - Reprovado											 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,nPosRes] := If(lMaior,"R",Iif(lAprCon,"T","A"))
	M->QPR_RESULT := aCols[N,nPosRes]
	
	aCols[n,nPosPN]  := cVar
	M->QPS_MEDIPN    := cVar
	
	aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols :=Aclone(aCols)
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215VlPP ³ Autor ³ Cleber Souza          ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida campo Porc.Nao Conforme - Carta P					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpL1 = Retorno da Validacao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215												      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VlPP()
Local lRet      := .T.
Local cVar      := &(readvar()) // Conteudo da variavel do campo Porc.N.Conforme 
Local cCarta    := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]
Local aCols     := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols 
Local N         := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT  
Local aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio])
Local nPosCal	:= ascan(aHeadTMP[1], { |x| alltrim(x[2]) == 'QPS_CALPOR' })
Local nPosRes   := 0

If cCarta <> "TXT"
	nPosRes := ascan(aHeader, { |x| alltrim(x[2]) == 'QPR_RESULT' })
Else
	nPosRes := ascan(aHeader, { |x| alltrim(x[2]) == 'QPQ_RESULT' })
EndIf    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se e' valida ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cVar > 100.00
	Help(" ",1,"QPH215054") //Porcentagem Não Conformes inválida
	lRet := .F.
EndIf

If lRet

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Marca de calculo autom. Porcentagem Nao Conforme ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n][nPosCal] := "N"
	M->QPS_CALPOR := "N"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza Resultado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aCols[n,nPosRes] := Iif(cVar == 0.00,"A","R")
	M->QPR_RESULT := aCols[n,nPosRes]

	aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols :=Aclone(aCols)
	
EndIf
Return lRet       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QP215VlNC³ Autor ³ Cleber Souza 			³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida campo Nao Conformidade 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpL1 = Retorno da Validacao								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215										              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VlNC()
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1
Local lRet		:= .T.
Local cCampo    := Alltrim(readvar())
Local cVar		:= &(readvar())// Conteudo da variavel do campo Nao Conformidade
Local nCtNc		:= 0 
Local nI        := 0        
Local aCols     := Iif(lLayout,aObjetos[OBJ_NCC,nOperacao,nFldLab,1]:aCols,oGetNC:aCols)
Local N         := Iif(lLayout,aObjetos[OBJ_NCC,nOperacao,nFldLab,1]:nAT,oGetNC:nAT)  
Local cCarta    := Iif(lLayout,aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA],aResultados[nPosOper,_ENS,nPosLab,nPosEns,CARTA])
Local aHeadTMP  := Iif(lLayout,aClone(aSavaHeader[HEAD_NCS]),Nil)
Local nPosNc	:= aScan(Iif(lLayout,aHeadTMP,aHeader), { |x| alltrim(x[2]) == 'QPU_NAOCON' })
Local nPosCla	:= aScan(Iif(lLayout,aHeadTMP,aHeader), { |x| alltrim(x[2]) == 'QPU_CLASSE' })
Local nPosNum	:= aScan(Iif(lLayout,aHeadTMP,aHeader), { |x| alltrim(x[2]) == 'QPU_NUMNC'  }) 
Local nPosDNC	:= aScan(Iif(lLayout,aHeadTMP,aHeader), { |x| alltrim(x[2]) == 'QPU_DESNCO' })
Local nPosDCl	:= aScan(Iif(lLayout,aHeadTMP,aHeader), { |x| alltrim(x[2]) == 'QPU_DESCLA' })
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)

If cCampo == "M->QPU_NAOCON"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se mudou a NC (Alterou o campo ja' digitado) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !Empty(aCols[n][nPosNC]) .And. !Empty(cVar) .And. aCols[n][nPosNC] <> cVar
		Help(" ",1,"QPH215055") //Campo não pode ser alterado.
		lRet := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a NC ja' existe ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		For nI := 1 to len(aCols)
			If cVar == aCols[nI][nPosNC] .and. nI <> n // Se ja' existir este cod. NC
				Help(" ",1,"QPH215056") //Não conformidade já associada a medição.
				lRet := .F.
			EndIf
		Next nI
	EndIf
	
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a NC esta' cadastrada no SAG ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !ExistCpo2("SAG",cVar,,STR0091)  //"Näo conformidades näo cadastrada. Informe uma NC. valida."
			aCols[n][nPosNC] := Space(TamSX3("QPU_NAOCON")[1])
			If lLayout
				aObjetos[OBJ_NCC,nOperacao,nFldLab,1]:aCols := aClone(aCols)
			EndIf
			lRet := .F.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sugere a Classe da NC ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet .And. Empty(aCols[n][nPosCla])
		SAG->(dbSeek(xFilial("SAG")+cVar))
		aCols[n][nPosCla] := SAG->AG_CLASSE
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche a Descricao da NC ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[n][nPosDNC] := QipxDNCo(cVar) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche Numero de NCC     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[n][nPosNum] := 1		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche a Descricao da Classe ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[n][nPosDCl] := A040DCla(aCols[n][nPosCla])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche Nao Conformidade.	   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[n][nPosNc] := cVar

	EndIf  
	
ElseIf cCampo == "M->QPU_NUMNC"

	If !Empty(aCols[n,nPosNc])
		If M->QPU_NUMNC <= 0
			lRet := .F.
			MessageDlg(STR0092,STR0093,3)	//"Informe o n£mero de n„o conformidades ( Maior que Zero )."###"Atencao"	
		Else
	   		aCols[n][nPosNum] := cVar
			M->QPU_NUMNC      := cVar
		EndIf
	EndIf

ElseIf cCampo == "M->QPU_CLASSE"

	If !ExistCpo2("QEE",cVar,,STR0094)	//"Classe näo cadastrada."	
		lRet := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Preenche a Descricao da Classe ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lRet
		aCols[n][nPosCla]:= cVar
		M->QPU_CLASSE    := cVar
		aCols[n][nPosDCl]:= A040DCla(cVar)
		M->QPU_DESCLA    := aCols[n,nPosDCl]
	EndIf
	
EndIF    

If lLayout .AND. lRet
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Salva Dados no aCols do Objeto ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aObjetos[OBJ_NCC,nOperacao,nFldLab,1]:aCols := aClone(aCols)
	aObjetos[OBJ_NCC,nOperacao,nFldLab,1]:Refresh()
EndIF

Return(lRet)      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³ QP215P	³ Autor ³ Cleber Souza          ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Monta a picture para as medicoes, de acordo com o Nominal. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Nome do Campo que tera' a picture a ser definida   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpC1 = Picture do campo									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215P(cCampo)
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local cPict		:= ''
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local nDec		:= 0
Local nRecSx3	:= 0
Local nTam		:= 0
Local cOper		:= "" 
Local cEns      := ""
Local cCartEns  := ""
Local nMedica   := 0   
Local nColPos   := 0  
Local aHeadTMP  := {}
Local lPicture	:= .T.

If lLayout
	cOper	  := aResultados[nOperacao,_OPE] 
	cEns      := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]  
	cCartEns  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]  
	nMedica   := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT   
	nColPos   := aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:oBrowse:nColPos  
	aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio]) 
Else
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := nPosEns
	cOper	  := aResultados[nOperacao,_OPE] 
	cEns      := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]  
	cCartEns  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]  
	nMedica   := oGetMed:nAT   
	nColPos   := oGetMed:oBrowse:nColPos  
	aHeadTMP  := aClone(aSavHeadEns[nOperacao,nFldLab,nEnsaio]) 
Endif

If cMv_QPMEAUT	== "S"
	If Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio,nMedica]) > 0
		If QM2->(dbSeek(xFilial("QM2")+aResultados[nOperacao,_INS,nFldLab,nEnsaio,nMedica,1]))
			If QM2->QM2_ONLINE == "1"
				lPicture := .F.
			EndIf
		EndIf
	EndIf
EndIf

If lPicture
	QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns))
	nDec := QA_NumDec(QP7->QP7_NOMINA)
	nRecSx3 := SX3->(Recno())
	nTam := TamSx3(cCampo)[1]	// A picture tera' o tamanho def. p/ o campo no SX3
	SX3->(dbGoTo(nRecSx3))

	If cCartEns <> "P  " .And. cCartEns <> "TMP"
		If At('i',QP7->QP7_NOMINA) == 0
			cPict := QA_PICT(cCampo,QP7->QP7_NOMINA) // Campo,Valor Referencia: Nominal
		Else 
			cPict := "%C"
		EndIf
	ElseIf cCartEns == "P  "
		// Monta a	picture def. no aheader
		cPict := aHeadTMP[nColPos][3]
	ElseIf cCartEns == "TMP"
		cPict := "@R 999:99"
	EndIf
EndIf
Return(cPict)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ QP215VlIn³ Autor ³ Cleber Souza          ³ Data ³ 03/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Valida campo Instrumento									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1	- Resultado da Validacao						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215										              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VlIn()
Local lRet			:= .T.
Local cVar			:= &(readvar()) // Conteudo da variavel do campo Instrumento
Local lMensag		:= .F.
Local cInstr		:= ""
Local lExistInst	:= .T.
Local lLayout		:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

Local aCols     	:= Iif(lLayout,aObjetos[OBJ_INST,nOperacao,nFldLab,1]:aCols,oGetINS:aCols)
Local N          	:= Iif(lLayout,aObjetos[OBJ_INST,nOperacao,nFldLab,1]:nAT,oGetINS:nAT)
Local aColsMed  	:= Iif(lLayout,aObjetos[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols,oGetMed:aCols)
Local cCarta    	:= ""
Local nPosIns		:= ascan(Iif(lLayout, aSavaHeader[HEAD_INST], aHeader) , { |x| alltrim(x[2]) == "QPT_INSTR" })
Local nPosRev		:= ascan(Iif(lLayout, aSavaHeader[HEAD_INST], aHeader) , { |x| alltrim(x[2]) == "QPT_REVINS" })
Local nPosDVA		:= ascan(Iif(lLayout, aSavaHeader[HEAD_INST], aHeader) , { |x| alltrim(x[2]) == "QPT_VALDAF" })
Local nPosTip		:= ascan(Iif(lLayout, aSavaHeader[HEAD_INST], aHeader) , { |x| alltrim(x[2]) == "QPT_TIPO" }) 
Local nPosRTi		:= ascan(Iif(lLayout, aSavaHeader[HEAD_INST], aHeader) , { |x| alltrim(x[2]) == "QPT_REVTIP" }) 
Local cOper         := ""
Local cEns          := ""
Local cRevi			:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local nDtM			:= aScan(Iif(lLayout, aSavHeadEns[nOperacao,nFldLab,nEnsaio,1], oGetMed:aHeader ), { |x| alltrim(x[2]) == 'QPR_DTMEDI' })
Local nI			:= 0

If lLayout
	cOper   := aResultados[nOperacao,_OPE]   
	cEns    := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]
	cCarta  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]
Else 
//	Q216ARESU()
	cOper   := aResultados[nPosOper,_OPE]
	cEns    := aResultados[nPosOper,_ENS,nPosLab,nPosEns,ENSAIO]
	cCarta  := aResultados[nPosOper,_ENS,nPosLab,nPosEns,CARTA]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a Instrumento existe   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to len(aCols)
	If !aCols[nI,Len(aCols[nI])]
		If cVar == aCols[nI,nPosIns] .and. nI <> n
			Help(" ",1,"QPH215057") //Instrumento informado já está associado ao ensaio.
			lRet := .F.
		EndIf
	Endif
Next nI
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se mudou o Instrumento (Alterou o campo ja' digitado)   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If !Empty(aCols[n,nPosIns]) .And. !Empty(cVar) .And. aCols[n,nPosIns] <> cVar
		Help(" ",1,"QPH215055") //Campo não pode ser alterado.	
		lRet := .F.
	EndIf
EndIf

If !lLayout
	Private cRoteiro := SC2->C2_ROTEIRO
	Private nMedicao := oGetMed:nAT
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Guarda as posicoes dos campos p/ posterior consistencia ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QQ1")
dbSetOrder(3)
If !dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns)
	If !Empty(cVar)
		Help(" ",1,"QPH215008") //Não existe a família de instrumento cadastrada na especificação de produtos, não poderá ser aceito o instrumento.
		lRet := .F.
	EndIf
EndIf
dbSetOrder(1)

If cMV_QIPQMT == "S" .And. lRet .And.!Empty(cVar) // Se estiver integrado com o SIGAQMT
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o Instrumento est  cadastrado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !ExistCpo2("QM2",cVar,,STR0095)	//"O instrumento informado näo existe. Informe um valido"
		lRet := .F.
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o Instrumento esta Calibrado      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lRet := .F.
		QM2->(dbSeek(xFilial("QM2")+cVar))
		While QM2->(!Eof()) .And. QM2->(QM2_FILIAL+QM2_INSTR) == xFilial("QM2")+cVar
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona na Calibracao do Instrumento         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QM6->(dbSetOrder(1))
			If QM6->(dbSeek(xFilial("QM6")+QM2->QM2_INSTR+QM2->QM2_REVINS))
				lRet := .T.
				Exit
			Endif
			QM2->(dbSkip())
		EndDo
		
		If lRet 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Posiciona no arquivo de Familia de Instrumentos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QM1->(dbSetOrder(1))
			QM1->(dbSeek(xFilial("QM1")+QM6->QM6_TIPO+INVERTE(QM6->QM6_REVTIP)))
			
			QQ1->(dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+cRevi+cOper+cEns))
			While !QQ1->(Eof()) .and. xFilial("QQ1") 	== QQ1->QQ1_FILIAL	.And.;
					QQ1->QQ1_PRODUT		== QPK->QPK_PRODUT			.And.;
					QQ1->QQ1_REVI		== cRevi					.And.;
					QQ1->QQ1_OPERAC		== cOper					.And.;
					QQ1->QQ1_ENSAIO		== cEns
	
				If	QQ1->QQ1_ROTEIR <> cRoteiro
					QQ1->(dbSkip())
					Loop
				EndIf
					
				If !Empty(QQ1->QQ1_INSTR)
					If QQ1->QQ1_INSTR <> QM1->QM1_TIPO
						cInstr+= " - "+QQ1->QQ1_INSTR+" "+CHR(13)
						lMensag:= .T.
					Else
						lExistInst:= .F.
					Endif
				EndIf
				QQ1->(dbSkip())
			EndDo
					
			If lMensag .And. lExistInst
				MessageDlg(STR0096+CHR(13)+cInstr,STR0093,3)	//"A familia do instrumento definida para o ensaio podera ser: "###"Atencao"
				lRet := .F.
			EndIf
		Else
			Help(" ",1,"Q215068")	//O instrumento selecionado nao possui calibracao
		Endif
		
		If lRet
			If !Empty(QM2->QM2_STATUS)
				If QMP->(dbSeek(xFilial("QMP")+QM2->QM2_STATUS))
					If QMP->QMP_ATUAL == "N"
						Help(" ",1,"QPH215058") //O instrumento nao podera ser utilizado, pois para o seu Status atual, nao permite a sua utilizacao.
						lRet := .F.
					EndIf
				EndIf
			EndIf
		Endif
		
		If lRet
			If cMV_QPVLIN == "S"	//Validar instrumento ?
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Compara a Validade Afericao do Instrumento com a Data Medicao  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If QM2->QM2_VALDAF < aColsMed[nMedicao,nDtm]
					Help(" ",1,"QPH215059") //A validade da aferição está expirada.
					lRet := .F.
				EndIf
				If Empty(QM2->QM2_LAUDO)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o Instrumento tem Laudo ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Help(" ",1,"QPH215060") //O instrumento escolhido não tem laudo.
					lRet := .F.
				ElseIf QM2->QM2_LAUDO == "1"
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o Laudo do Instrumento ‚ Reprovado ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					Help(" ",1,"QPH215061") //O laudo do instrumento escolhido ‚ reprovado.
					lRet := .F.
				ElseIf Upper(QM2->QM2_STATUS) == "I"
					MsgInfo(SubStr(OemToAnsi(STR0229),1,54);
						 + CHR(13)+CHR(10) + SubStr(OemToAnsi(STR0229),56))
					lRet := .F.
				EndIf
			EndIf
		Endif			
	EndIf
	If lRet
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os campos Familia e Validade Afericao ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aCols[n][nPosIns] := QM2->QM2_INSTR
		M->QPT_INSTR := QM2->QM2_INSTR
				
		aCols[n][nPosREV] := QM2->QM2_REVINS
		M->QPT_REVINS := QM2->QM2_REVINS
		
		aCols[n][nPosDVA] := QM2->QM2_VALDAF
		M->QPT_VALDAF := QM2->QM2_VALDAF
				
		aCols[n][nPosTip] := QM2->QM2_TIPO
		M->QPT_TIPO := QM2->QM2_TIPO
		
		aCols[n][nPosRTi] := QM1->QM1_REVTIP
		M->QPT_REVTIP := QM1->QM1_REVTIP
		
		Iif(lLayout, aObjetos[OBJ_INST,nOperacao,nFldLab,1]:aCols := aClone(aCols), oGetINS:aCols := aClone(aCols))
		Iif(lLayout, aObjetos[OBJ_INST,nOperacao,nFldLab,1]:Refresh(), oGetINS:Refresh())
	Else
		
		aCols[n][nPosIns] 	:= Space(TamSX3("QM2_INSTR")[1])
		M->QPT_INSTR 		:= Space(TamSX3("QM2_INSTR")[1])
				
		aCols[n][nPosREV] 	:= Space(TamSX3("QM2_REVINS")[1])
		M->QPT_REVINS 		:= Space(TamSX3("QM2_REVINS")[1])
		
		aCols[n][nPosDVA] 	:= Space(TamSX3("QM2_VALDAF")[1])
		M->QPT_VALDAF 		:= Space(TamSX3("QM2_VALDAF")[1])
				
		aCols[n][nPosTip] 	:= Space(TamSX3("QM2_TIPO")[1])
		M->QPT_TIPO 		:= Space(TamSX3("QM2_TIPO")[1])
		
		aCols[n][nPosRTi] 	:= Space(TamSX3("QM1_REVTIP")[1])
		M->QPT_REVTIP 		:= Space(TamSX3("QM1_REVTIP")[1])
		
		Iif(lLayout, aObjetos[OBJ_INST,nOperacao,nFldLab,1]:aCols := aClone(aCols), oGetIns:aCols := aClone(aCols) )
		
		Iif(lLayout, aObjetos[OBJ_INST,nOperacao,nFldLab,1]:REFRESH(), oGetIns:Refresh() )
		
	EndIf
EndIf
Return lRet      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215F3NC	³ Autor ³ Cleber Souza          ³ Data ³ 04/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta uma consulta via SXB especifica						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³Nil 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Qiea21?.PRW												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215F3NC()
Local lOkQP9	:= .F.
Local lOkQP2	:= .F.
Local lRet		:= .T.
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cTitulo	:= ""
Local aCampos	:= {} 
Local cOper     := ""
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Private cEns    := ""

If lLayout                                                  
	cOper := aResultados[nOperacao,_OPE]   
	cEns  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]
Else 
//	Q216ARESU()
	cOper := aResultados[nPosOper,_OPE]   
	cEns  := aResultados[nPosOper,_ENS,nPosLab,nPosEns,ENSAIO]
EndIf
   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe NC associada no QP9 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QP9")
dbSetOrder(3)

If DbSeek( xFilial("QP9") +QPK->QPK_PRODUT+ cRevi+ cRoteiro+cOper+cEns)
	lOkQP9 := .T.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao exista NC no QP9 verifica no QP2 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lOkQP9
	dbSelectArea("QP2")
	If dbSeek( xFilial("QP2") + cEns )
		lOkQP2 := .T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com os dados encontrados dispara uma consulta F3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOkQP9
	cTitulo := STR0165 //"Não Conformidade do Produto" 
	Aadd(aCampos,	{AllTrim(TitSX3("QP9_NAOCON")[1])	,"QP9_NAOCON"}) //"Nao Conformidade"
	Aadd(aCampos,	{AllTrim(TitSX3("QP9_DESNCO")[1])	,"QP9_DESNCO"}) //"Descricao Nao Conformidade"
	Aadd(aCampos,	{"Classe"							,"QP9_CLASSE"})  
	lRet := ConPadNC(cTitulo,"QP9",aCampos,3,	"QP9->QP9_FILIAL+QP9->QP9_PRODUT+QP9->QP9_REVI+QP9->QP9_ROTEIR+QP9->QP9_OPERAC+QP9->QP9_ENSAIO",	{||QP9_FILIAL+QP9_PRODUT+QP9_REVI+QP9_ROTEIR+QP9_OPERAC+QP9_ENSAIO == xFilial("QP9")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+cEns})
Elseif lOkQP2
	lRet := ConPad1(,,,"NC6")
Else
	lRet := ConPad1(,,,"SAG")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso a consulta F3 tenha sido executada fora do SAG, posi-   ³
//³ ciona no SAG , pois o retorno nsulta SXB diferente			 ³
//³ Caso o retorno venha de uma consulta SXB diferente			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lOkQP9
	dbSelectArea("SAG")
	dbSetOrder(1)
	dbSeek( xFilial("SAG") + QP9->QP9_NAOCON )
ElseIf lOkQP2
	dbSelectArea("SAG")
	dbSetOrder(1)
	dbSeek( xFilial("SAG") + QP2->QP2_NAOCON )
EndIf

dbSelectArea("QP9")
dbSetOrder(1)

Return lRet  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215HorMed³ Autor ³Cleber Souza          ³ Data ³04/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se a HoRa informada na Medicao se repete		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = Estrutura do aCols						 	  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPC1 = Hora da Medicao									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215					                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215HorMed(aColsMed)
Local cHora := Left(Time(),TamSx3("QPR_HRMEDI")[1])
Local nX

If aColsMed == NIL
	For nX := 1 to Len(aCols)
		If aCols[nX,1] == dDataBase
			If Alltrim(aCols[nX,2]) == Alltrim(cHora)
				cHora := Left(Q_SomaHora(aCols[nX,2]+":00","00:01:00"),TamSx3("QPR_HRMEDI")[1])
			EndIf
		EndIf
	Next nX           
Else
	aColsMed[1,2] := cHora
	For nX := 2 to Len(aColsMed)
			cHora := Left(Q_SomaHora(cHora+":00","00:01:00"),TamSx3("QPR_HRMEDI")[1])
			aColsMed[nX,2] := cHora
	Next nX           
EndIf

Return(cHora)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215AtuSta³ Autor ³Cleber Souza          ³ Data ³05/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza os status das telas de Resultados.			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao corrente						  ³±±
±±³			 ³ EXPN2 = Posicao do Laboratorio corrente					  ³±±
±±³			 ³ EXPN3 = Posicao do Ensaio corrente						  ³±±
±±³			 ³ EXPC1 = Resultado da Medicao A=Aprov ou R=Reprovado		  ³±±
±±³			 ³ EXPC2 = Tipo da pesquisa do Status O=Oper / L=Laboratorio  ³±±
±±³			 ³ EXPA1 = Sub tipos que serao validados.					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retornio  ³ NIL												 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215AtuSta(nPosOpera,nPosLabi,nPosEnsX,cResMed,cTipo,aOpcoes,laCols)
Local lNaoCon  := .F.
Local lRetNco  := .F.  
Local nX       := 0
Local nW       := 0
Local nY       := 0
Local cCarta   := ""
Local nPosRes  := 0
Local nMed     := 0
Local lInstru  := .F.
Local lRetIns 
Local cStaIns  := " " 
Local cStaAne  := " "  
Local cRet              
Local lLayout  := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nPosDel  := 0  
Local lTemMed  := .F.
//Iif(lLayout,aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO],aResultados[nPosOper,_ENS,nPosLab,oGetMed:nAT,ENSAIO])

If lLayout
	DEFAULT nPosOpera := nOperacao
	DEFAULT nPosLabi  := nFldLab
	DEFAULT nPosEnsX   := nEnsaio 
Else 
	DEFAULT nPosOpera := nPosOper
	DEFAULT nPosLabi  := nPosLab
	DEFAULT nPosEnsX   := oGetMed:nAT   
	If Len(aSavHeadBkp) >= 1
		aSavHeadEns	:= aClone(aSavHeadBkp)	
	EndIf		
EndIf

If Empty(cTipo) .or. Len(aOpcoes)==0
	Return(.T.)
EndIF	 
              
If cTipo == "E"                                    
	
	cCarta := aResultados[nPosOpera,_ENS,nPosLabi,nPosEnsX,CARTA]
	If cCarta == "TXT"	                                                
		nPosRes  := aScan(aSavHeadEns[nPosOpera,nPosLabi,nPosEnsX,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
		nMed     := aScan(aSavHeadEns[nPosOpera,nPosLabi,nPosEnsX,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
	Else
		nPosRes  := aScan(aSavHeadEns[nPosOpera,nPosLabi,nPosEnsX,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
		If cCarta == "P  "
			nMed     := aScan(aSavHeadEns[nPosOpera,nPosLabi,nPosEnsX,1],{|x|Alltrim(x[2])=="QPS_MEDIPA"})
		Else 
			nMed     := aScan(aSavHeadEns[nPosOpera,nPosLabi,nPosEnsX,1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
		EndIf
	EndIf      
	
	For nX:=1 to Len(aOpcoes) 
		
		If aOpcoes[nX] == 1 //Verifica Status da Medicao 
			
			nDelILn := 0
			
			For nW := 1 to Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX])
				If (Len(aResultados[nPosOpera, _INS, nPosLabi, nPosEnsX]) >= nW .AND. Len(aResultados[nPosOpera, _INS, nPosLabi, nPosEnsX, nW]) > 0 .AND. (!Empty(aResultados[nPosOpera, _INS, nPosLabi, nPosEnsX,nW,1,1]) .OR. !Empty(aResultados[nPosOpera, _INS, nPosLabi, nPosEnsX,1,1,1]) ) ) .OR. aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX, nW])]
					lAtuIns := .T.
				Else
					lAtuIns := .F.
				Endif
				If aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX, nW])]           
					nDelILn++
				Else
					IIf(cResMed#"R",(cResMed := aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosRes], lTemMed := !Empty(AllTrim(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nMed]))),.F.)
				EndIf
			Next nW
            
			If ( nDelILn == Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX]) ) .OR. ( nDelILn == Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX])-1 )
				lAtuIns := .T.
				cAtuNco := "3"
				If ( nDelILn == Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX]) )
					cResMed := " "
					lTemMed := .F.
				EndIf
			ElseIf nPosEnsX = nPosEns .AND. oGetMed <> Nil .AND. aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,oGetMed:nAt,Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX, oGetMed:nAt])]
				cAtuNco := "3"
			EndIf
			
			If cResMed == "R" 
				cAtuNco := "1"
				cRet := hNO
			ElseIf cResMed == "A"
				If cAtuNco == "3"
					cAtuNco := "1"
				Else
					cAtuNco := "2"
				EndIf
				cRet := hOK
			Else
				If  Empty(AllTrim(cResMed)) .AND. lTemMed
					cRet := hPd
					cAtuNco := "2" 
					lAtuIns := .F.
				Else
					cRet := hVZ 
					cAtuNco := "1"
				EndIf
			EndIf
			
			If laCols                            
				If lLayout
					aEnsaios[nPosOpera,nPosLabi,nPosEnsX,1] := cRet
				Else        
					Return(cRet)
				EndIf
			Else 
				QP215PlAm(.F., @cRet, nPosEnsX)	
				Return(cRet)
			EndIF
			
		ElseIf aOpcoes[nX] == 2 //Verifica Status da Nao Conformidade
			lAtuNco := .F. 
			
			If laCols	
				For nW := 1 to Len(aResultados[nPosOpera,_NCO,nPosLabi,nPosEnsX,aOBJETOS[OBJ_MEDICA,nPosOpera,nFldLab,nPosEnsX]:nAT]) 
				    If (lRetNco := QP215ChkMed(nPosOpera,nPosLabi,nPosEnsX,1,nW,,2,.F.,.T.,laCols)) 
						lNaoCon := If(lNaoCon,lNaoCon,.T.)
					EndIf                                               
				Next	
			Else
				For nW := 1 to Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX])       
					nPosDel := Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW])
					If !aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosDel]
						IIf((Empty(cResMed) .OR. cResMed=="A"),cResMed:= aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosRes],.F.)
						If nW > Len(aResultados[nPosOpera,_NCO,nPosLabi,nPosEnsX])
							aAdd(aResultados[nPosOpera,_NCO,nPosLabi,nPosEnsX],aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,"     ","QPU_CODMED",Len(aSavaHeader[HEAD_NCS]))))						
						EndIf						
						For nY := 1 to Len(aResultados[nPosOpera,_NCO,nPosLabi,nPosEnsX,nW])
						    If (lRetNco := QP215ChkMed(nPosOpera,nPosLabi,nPosEnsX,nW,nY,,2,.F.,.T.,laCols))
								lNaoCon := If(lNaoCon,lNaoCon,.T.)
							EndIf
						Next nY
					EndIf
				Next nW
			EndIf
		   
			IIF(Empty(cResMed) .AND. laCols,cResMed:= aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,aOBJETOS[OBJ_MEDICA,nPosOpera,nFldLab,nPosEnsX]:nAT,nPosRes],.F.)
				
   			If cResMed == "R"  //Medicao reprovada
				cRet := If(lNaoCon,hOK,hPd)
			Else
				cRet := If(lNaoCon,hOK,hVz)
			EndIf  

			If laCols                            
				aEnsaios[nPosOpera,nPosLabi,nPosEnsX,2] := cRet
			Else 
				Return(cRet)
			EndIF

		ElseIf aOpcoes[nX] == 3 //Verifica Status dos Instrumentos
			nRegVal := 0
			If cMV_QINVTOT == "1" 
				lInstru := .T.
				For nW := 1 to Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX]) 
					nPosDel := Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,1]) 
					If !aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosDel] 
						If Len(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX]) < nW
							aAdd(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX], aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST]))))
						EndIf 
						If nRegVal == 0 
							nRegVal := nW
						EndIf
						For nY := 1 to Len(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX,nW])
							lInstru := Iif(lInstru,QP215ChkMed(nPosOpera, nPosLabi, nPosEnsX, nW, nY,,3,.F.,.F.,.F.),.F.)
						Next
					EndIf 
				Next
			Else
				For nW := 1 to Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX])
					nPosDel := Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW])    
					If Len(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX]) < nW
						aAdd(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX], aClone(Q215FilCol(aSavaHeader[HEAD_INST],"QPT",1,"        ","QPT_CODMED",Len(aSavaHeader[HEAD_INST]))))
					EndIf 							
					For nY := 1 to Len(aResultados[nPosOpera,_INS,nPosLabi,nPosEnsX,nW])
					    If (lRetIns := QP215ChkMed(nPosOpera,nPosLabi,nPosEnsX,nW,nY,,3,.F.,.T.,laCols))          
						    lInstru := Iif(lInstru,lInstru,Iif(Empty(AllTrim(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosRes])),.F.,.T.))   
					    EndIf
				 		If !aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nW,nPosDel] .AND. nRegVal == 0 
				 			nRegVal := nW
				 		EndIf
				    Next nY
				Next nW
			EndIf
			If nRegVal == 0
				If cMV_QINVTOT == "1" 
					lInstru := .F.
				EndIf
				nRegVal := 1
			EndIf
			
   			If cMv_QINTQMT == "S" //Se houver Integracao com o Metrologia
				If cMV_QPINSOB == "S" //Indica se os Instrumentos sao obrigatorios
					cRet := If(lInstru,hOK,hPd)
				Else
					If cMV_QINOBFM $ "1,3"      
						cRet := If(lInstru,hOK,;
								Iif( aResultados[nPosOpera,_ENS,nPosLabi,nPosEnsX,FAMVINC] .AND. !aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,nRegVal,nPosDel] .AND.;
								     (( Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX]) == 1 .AND. !Empty(Alltrim(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX,1,nPosRes] ))  ) .OR.;
								        Len(aResultados[nPosOpera,_MED,nPosLabi,nPosEnsX]) > 1),hPd,hVz))
					ElseIf cMV_QINOBFM == "2"
						cRet := If(lInstru,hOK,hVz)
					EndIf
				EndIf
			Else
				cRet := If(lInstru,hOK,hVz)
			EndIf

			If laCols .AND. lLayout
		    	aEnsaios[nPosOpera,nPosLabi,nPosEnsX,3] := cRet
			Else 
				Return(cRet)
			EndIf

		ElseIf aOpcoes[nX] == 4 //Verifica Status dos Documentos Anexos
			cRet := hVz

			If lLayout
				If !Empty(aResultados[nPosOpera,_ANE,nPosLabi,nPosEnsX,1,nPosAne]) .And.;
					!aResultados[nPosOpera,_ANE,nPosLabi,nPosEnsX,1,Len(aResultados[nPosLabi,_ANE,nPosLabi,nPosEnsX,1])]
			        cRet := hOK
				EndIf
		 	
		 		If laCols
					aEnsaios[nPosOpera,nPosLabi,nPosEnsX,4] := cRet                
				Else                                                           
					Return(cRet)
				EndIf
			Else
				aResultados := aClone(aResultados) // Desvinculo os arrays
				aSavHeadEns := aClone(aSavHeadEns) // Desvinculo os arrays
				Return(cRet)			
			EndIf				
			
		EndIf
	Next nX
	If lLayout
		aOBJETOS[OBJ_ENSAIO,nPosOpera,nPosLabi,1]:Refresh() // Modificação nescessaria para  melhorar a performance da tela
	EndIf
ElseIf cTipo == "O"	 

	If lLayout
		For nX:=1 to Len(aOpcoes) 
			
			If aOpcoes[nX] == 1 //Verifica Status Operacao Obrigatoria  e Sequencia Obrigator.
	        	
	        	aRet := QP215ChkOpe(nPosOpera)
	        	If aRet[1,1] .and. aRet[2,1]
					cRet := hOK
	        	Else 
		        	If aOperacoes[nPosOpera,8] == "S" .or.;
		        	   aOperacoes[nPosOpera,9] == "S"
		        		cRet := hPD
	    			Else
		        		cRet := hVZ
	    			EndIF
	        	EndIf
	        	
	        	If laCols
	        		aOperacoes[nPosOpera,8] := cRet
	        	Else
	        		Return(cRet)
	        	EndIf		
	        	   
			ElseIf aOpcoes[nX]  == 2 //Verifica Status Laudo Obrigatorio
	
	        	aRet := QP215ChkOpe(nPosOpera)
	        	If aRet[1,1]
	        		If aRet[1,2] == cFatRep
						cRet := hNO
					ElseIf aRet[1,2] == cFatApr
						cRet := hOK  
					Else
						cRet := hPD	
	        		EndIf
	        	Else 
		        	If aOperacoes[nPosOpera,10] == "S"
		        		cRet := hPD
	    			Else
		        		cRet := hVZ
	    			EndIF
	        	EndIf
	        	
	        	If laCols
	        		aOperacoes[nPosOpera,8] := cRet
	        	Else
	        		Return(cRet)
	        	EndIf		
			EndIf
	    Next nX
	EndIf
	
EndIf   

Return(.T.)    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215ChkOpe³ Autor ³Cleber L. Souza       ³ Data ³05/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica se Existe Laudo para a Operacao	e seus Labs.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao da Operacao corrente						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPA1 = Resultado da Pesquisa							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ChkOpe(nPosOpe) 
            
Local aRet    := {}
Local nPosLau := 0 
Local lRetLab := .T.
Local nX      := 0

nPosLau := QP215GetLau(aSavGets[nPosOpe,1],"QPM_LAUDO")

//Verifica se Operacao possui Laudo
If Empty(aResultados[nPosOpe,_LOP,nPosLau])
	AADD(aRet,{.F.,""})
Else
	AADD(aRet,{.T.,aResultados[nPosOpe,_LOP,nPosLau]}) 
EndIF	

//Verifica se possui Laudo em todos os Laboratorios
For nX:=1 to Len(aResultados[nPosOpe,_LLA])
	If Empty(aResultados[nPosOpe,_LLA,nX,nPosLau])
		lRetLab := .F.
		Exit
	EndIf	
Next nX     
AADD(aRet,{lRetLab,""}) 

Return(aRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215GetLau³ Autor ³Cleber L. Souza       ³ Data ³05/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Pesquisa posicao do campo na Array oGet Objeto Enchoice.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPA1 = Array aGet do objeto Enchoice					  ³±±
±±³          ³ EXPC1 = Nome do campo pesquisado							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPN1 = Posicao Campo pesquisado							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215GetLau(aGet,cCampo)
           
Local nPos  := 0
Local nX    := 0

For nX:=1 to Len(aGet)
	If Alltrim(Substr(aGet[nX],9,10)) == Alltrim(cCampo)
		nPos := nX
        Exit
    EndIF    
Next nX

Return(nPos)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215ValNav³ Autor ³Cleber L. Souza       ³ Data ³05/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Valida Navegacao entre as Operacoes.					      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Objeto que sera validado.						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retiorno  ³ Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ValNav(cTipo)
            
Local lRet  		:= .T.
Local aRet  		:= {}
Local nY    		:= 0
Local nPosLau 		:= 0
Local nPosLauGer	:= 0
Local lLayout		:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

If cTipo == "O"  //Valida navegacao entre as operacoes verificando obrigatoriedade das operacoes. 

	If nOperacao==nOperaAnt
		Return(lRet)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se precisa salvar Laudo Anterior na aResultados.	 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	QP215SavResu({SAV_LAUO},.T.)
	
	aRet := QP215ChkOpe(nOperaAnt)	                                                                   
	
	If ExistBlock("QP215J7")
		lRet := ExecBlock("QP215J7",.F.,.F.,{aResultados[nOperacao,_OPE]})
	Endif

	If lRet
		//Verifica Operacao Obrigatoria
		If aOperacoes[nOperaAnt,8] == "S"
			If (!aRet[1,1] .or. !aRet[2,1])  
				If nOperaAnt < nOperacao
					lRet := .F.
					Help(" ",1,"QPH215009") //"Ensaio Obrigratorio, favor informar laudo para prosseguir para a proxima operacao!!"
				EndIF
			EndIf
		EndIf
    EndIF

	If lRet
		If aOperacoes[nOperaAnt,9] == "S"
			If !aRet[1,1] .or. !aRet[2,1] 
				If nOperaAnt < nOperacao
					lRet := .F.
				    Help(" ",1,"QPH215010") //Sequencia Obrigratoria, favor informar laudo para prosseguir para a proxima operacao!!
				EndIF
			EndIf
		EndIf
	EndIf

	If lRet
		If aOperacoes[nOperaAnt,10] == "S"
			If !aRet[1,1]
				If nOperaAnt < nOperacao
					lRet := .F.
					Help(" ",1,"QPH215011") //Laudo Obrigratorio, favor informar laudo para prosseguir para a proxima operacao!
				EndIf
			EndIf
		EndIf
	EndIf 
	
	If !lRet
		oBrwOpe:nAT := nOperaAnt
		nOperacao   := nOperaAnt
		oBrwOpe:Refresh() 
		If lAutomatic
			oDlgResu:END()
		EndIF
	Else
		nEnsaioA  := nEnsaio  := 1  
		nMedicaoA := nMedicao := 1
		cTexCro   := aResultados[nOperacao,_CRO,nFldLab,nEnsaio,nMedicao]
		oCronica:cTitle := cTexCro
	EndIf
	
ElseIf cTipo == "G" //Valida ida do folder para digitacao do Laudo Geral

	If lLayout
		nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO")
		nPosLauGer := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
	Else                                                                                                   
		nPosLau := QP215GetLau(aSavGets[1,1],"QPM_LAUDO")
		nPosLauGer := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
	EndIf	
	
	For nY:=1 to nQtdOpe
		If Empty(aResultados[nY,_LOP,nPosLau]) .and. (aOperacoes[nY,10] == "S" .OR. aOperacoes[nY,8] == "S" ) .and. Empty(aResultados[nFldLauGer,1,nPosLauGer])	
			Help(" ",1,"QPH215012")  //Existem operacoes sem laudo, favor verificar antes do laudo geral.
			lRet := .F.
			Exit
		EndIf			
    Next nY
    
EndIF

Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215SkpT ³ Autor ³ Cleber Souza          ³ Data ³05/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica se esta em Skip Teste 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC2 - Ensaio atual										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExcC1 - Resultado											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215SkpT(cEnsaio, cOperacao)
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local cRetorno  := "N/A"
Local cGrupo	:= ""

//If !lLayout .AND. ValType(cEnsaio) == "L"
//	Q216ARESU()
//EndIf

Default cOperacao:= aResultados[Iif(lLayout,nOperacao,nPosOper),_OPE]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Pesquisa o Grupo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QPA->(dbSetOrder(2))
If QPA->(dbSeek(xFilial("QPA")+QPK->QPK_PRODUT))
	cGrupo := QPA->QPA_GRUPO
EndIf
QPA->(dbSetOrder(1))

If QPH->(dbSeek(xFilial("QPH")+QPK->QPK_PRODUT+cRoteiro+cOperacao+cEnsaio))
	
	QPY->(dbSetOrder(1))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se a OP existe no historico, ‚ porque ‚ p/ inspecionar ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QPY->(dbSeek(xFilial("QPY")+cRoteiro+cOperacao+QPK->QPK_PRODUT+Dtos(QPK->QPK_EMISSA)+padr(QPK->QPK_OP,16)+cEnsaio))
		cRetorno := OemToAnsi(STR0166) //"Inspecionar"  
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe o controle ou o contador ‚ menor ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !QPN->(dbSeek(xFilial("QPN")+QPK->QPK_PRODUT+cRoteiro+cOperacao+cEnsaio)) ;
				.Or. QPN->QPN_CONTAD > QPH->QPH_SKPTES
			cRetorno := STR0166 //"Inspecionar" 
		Else
			cRetorno := STR0167 //"Certificar" 
		EndIf
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe skip-teste por grupo definido ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If QPI->(dbSeek(xFilial("QPI")+cGrupo+cRoteiro+cOperacao+cEnsaio))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se a OP existe no historico, ‚ porque ‚ p/ inspecionar ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If QPZ->(dbSeek(xFilial("QPZ")+cGrupo+DToS(QPK->QPK_EMISSA)+QPK->QPK_OP+cEnsaio))
			cRetorno := STR0166 //"Inspecionar"	 
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe o controle ou o contador ‚ menor ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !QPO->(dbSeek(xFilial("QPO")+cGrupo+cRoteiro+Space(02)+cEnsaio));
					.Or. QPO->QPO_CONTAD > QPI->QPI_SKPTES
				cRetorno := STR0166 //"Inspecionar"	 
			Else
				cRetorno := STR0167 //"Certificar"	 
			EndIf
		EndIf
	EndIf
EndIf
Return cRetorno                        

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215LibU ³ Autor ³ Cleber Souza          ³ Data ³09/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Digitacao do Texto da LIberacao Urgente					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Opcao do aRotina									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LibU(nOpc, lCancela, aTexto, cChave1)
Local lLayout      := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lLibUrg      := .F.
Local lEdita
Local lCarOtm 	   := GetMv("MV_QPCAROT",.F.,"1") == "1"   // Carga Otimizada para o Layout simplificado, o valor default é carregar otimizado. - Usado na J&J
Local lCarrOP      := .F.
Local cTexto       := " "
Local cTitulo      := STR0013	//"Liberacao Urgente"
Local cTitulo2     := ""
Local cEspecie     := "QIPA210U" 
Local cCabLib      := STR0097	//"Observacoes da Liberacao urgente" 
Local cOperA       := 0 
Local nTamLin      := 70
Local nPosLauGer   := 0 

Default lCancela   := .F.
Default cChave1    := ""
Default aTexto     := {}

If lLayout
	nPosLauGer := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
Else                                                                                                   
	If Len(aResultados) > 1
		cOperA     := aResultados[nPosOper,_OPE]
	Else
		Return Nil
	EndIf
	If lCarOtm
		Q216CALL()
		nPosOper := Ascan(aResultados,{|x|x[_OPE] == cOperA})	
	EndIf
	nPosLauGer := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
EndIf	

lEdita := If(nOpc==3,.T.,.F.)     

//Caso nao seja Liberacao Urgente, o texto nao sera utilizado
If !Empty(aResultados[nFldLauGer,1,nPosLauGer])
	If aResultados[nFldLauGer,1,nPosLauGer] <> cFatLU 
		Help(" ",1,"Q215NAOURG") 
		Return(NIL) 
	Else
		//Recupera o Texto da Liberacao Urgente, caso exista
		If !Empty(QPK->QPK_CHAVE) .And. (QPK->QPK_SITOP $ '1467') 
			cTexto := QA_RecTxt(QPK->QPK_CHAVE,cEspecie,00,70,"QA2",{})
			aTexto := {{1,cTexto}} 
			//cTextoBkp := cTexto   
			//aTextoBkp := aClone(aTexto)
	    EndIf
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera a  chave de Ligacao para o Texto da Liberacao Urgente   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(QPK->QPK_CHAVE)

	aAreaQA2 := GetArea()
	cChave1  := QA_NewChave()
    RestArea(aAreaQA2)
	
	dbSelectArea("QPK")
	RecLock("QPK",.F.)
	QPK->QPK_CHAVE := cChave1
	MsUnlock()
Else
	cChave1 := QPK->QPK_CHAVE
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Texto da Liberacao Urgente									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cTitulo2 := Posicione("SB1",1,xFilial("SB1")+QPK->QPK_PRODUT,"B1_DESC")
lLibUrg  := QA_TEXTO(cChave1,cEspecie,nTamLin,cTitulo,cTitulo2,@aTexto,1,cCabLib,lEdita)

//Grava o texto da Liberacao Urgente	
If lLibUrg .And. lEdita

	If lLayout
		QA_GrvTxt(QPK->QPK_CHAVE,cEspecie,1,@aTexto)
		oFolder:nOption := 3 
		nFldOpe := 3
		oFolder:Refresh() 
	EndIf
	
	lLiberaUrg := If(!lLiberaUrg,.T.,lLiberaUrg)

	If !lLayout	
		QipLaudGer(nOpcX, @lCancela)
/*If !lCancela
		QA_GrvTxt(QPK->QPK_CHAVE,cEspecie,1,@aTexto)
  EndIf*/
	EndIf
EndIf

Return(NIL)                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215LauS	³ Autor ³ Cleber Souza 		    ³ Data ³10/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Mostra dialog com o laudo sugerido pelo sistema. 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1 - Handle da Dialog Inicial							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³Nil 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215LauS(oGet)

Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1" // Define o Leioute da Tela
Local lIgnEnSMed := GetMv("MV_QPVMDEL",.F.,"2") == "2" // Define se irá VALIDAR o registro deletado para o ensaio obrigatório sem medição no Laudo  1 = Sim / 2 = Não 
Local lPerEnSMed := GetMv("MV_QPIESMD",.F.,"2") == "1" // Define se irá IGNORAR ensaios sem medições no Laudo do Laboratório mesmo que estes estejam definidos como Obrigatórios 1 = Sim / 2 = Não, será  somente  exibida  uma  mensagem de ação ao  uruário permitindo continuar ignorando a onbrigatoriedade ou abandonar
Local lPerOPSLau := GetMv("MV_QPSLFSO",.F.,"2") == "1" // Define se irá SUGERIR Laudo Final da OP mesmo existindo Operações sem Laudo  1 = Sim / 2 = Não.  
Local nTotEnsDel := 0
Local cLaudo	 := " "
Local nCEns		 := 0
Local cMedicao	 := ""
Local nPosResult := 0
Local nDias      := 0    
Local nPosLau    := 0 
Local nPosLauOP  := 0 
Local nLab       := 0   
Local lRetorno   := .T. 
Local cMensNConf := IIf(nFldOpe<>3,STR0098,STR0237)	//"O Laudo da Operacao deve ser APROVADO TOTALMENTE."###"O Laudo Geral deve ser APROVADO TOTALMENTE"
Local cLab       := ""  
Local cOpe       := ""     
Local lContinua  := .T.
Local nEns       := 0
Local nPosOpe    := 0  
Local nPosLauL   := 0   
Local lQP215J19	 := ExistBlock("QP215J19")
Local aLaudo	 := {}	//Retorno do Ponto de entrada QP215J19 - Laudo,Texto  
Local aRetIns    := {}  
Local lAnalisa   := .T. 
Local lIntApr    := Iif(GetMv("MV_QPLGAPR",.F.,"S")=="S",.T.,.F.)  
Local nPosCpo    := 0
Local nQtdMed    := 0  
Local nQtdCpo    := 0
Local nX         := 0      
Local cEnsSemMed := "" 
Local nPosEnsR   := 0
Local nDtM	     :=	0
Local nHrM	     :=	0
Local nAmo	     :=	0
Local nPulaEns	 := 0

If !lLayout
	nOperacao := nPosOper
	nFldLab   := nPosLab
	lFechaLab 	  := .F.
EndIf

If !(ReadVar() $ "M->QPL_LAUDO/M->QPM_LAUDO") .or. Iif(lLayout,!Empty(&(ReadVar())),.F.)
	If !lLayout
		lFechaLab := .T.
	EndIf
	Return(lRetorno)
EndIf

If (ReadVar() $ "M->QPL_LAUDO/M->QPM_LAUDO") .AND. !Empty(AllTrim(&(ReadVar())))
	If !lLayout
		lFechaLab := .T.
	EndIf
	Return(lRetorno)
EndIf

//Verifica se a Pasta corrente esta focada
If !oGet:lVisible 
	If !lLayout
		lFechaLab := .T.
	EndIf
	Return(lRetorno)
EndIf                 

If lLayout
	nPosLauL := QP215GetLau(aSavGets[nOperacao,2,nFldLab],"QPL_LAUDO")
Else                                                                                                   
	nPosLauL := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
EndIf
					
If !lLayout
	If nPosEns > Len(aSavHeadEns[nPosOper,nPosLab])
		nPosEns  := Ascan(aResultados[nPosOper,_ENS,nPosLab],{|x|x[ENSAIO] == cEnsAtu})
	EndIf
	If ValType(aSavHeadEns[nPosOper,nPosLab,nPosEns]) <> "A"
		aSavHeadEns[nPosOper,nPosLab,1] := {{}}
	Else
		aSavHeadEns[nPosOper,nPosLab,nPosEns,1] := {}
	EndIf
	aSavHeadEns[nPosOper,nPosLab,nPosEns,1] := aClone(oGetMed:aHeader)  
	
//	Q216ARESU()
EndIf

If nFldOpe == 1  // Valida Laudo da Operacao
	
	For nLab := 1 to Len(aResultados[nOperacao,_LAB])
	    If lLayout
			nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO")
	    Else 
	    	nPosLau := QP215GetLau(aSavGets[1,1],"QPM_LAUDO")
	    EndIf
		If Empty(aResultados[nOperacao,_LLA,nLab,3])
			HELP(" ",1,"QPH215062 ",,Alltrim(aResultados[nOperacao,_LAB,nLab]),3,1)
			lContinua := .F.
			Exit
		Else
			If lLayout
				nPosLauL := QP215GetLau(aSavGets[nOperacao,2,nLab],"QPL_LAUDO")
			Else                                                                                                   
				nPosLauL := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
			EndIf	

			If ExistBlock("QP215ALO")
				lAnalisa := ExecBlock("QP215ALO",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nLab],aResultados[nOperacao,_LLA,nLab,nPosLauL]})
			EndIf
			
			If lAnalisa
				If aResultados[nOperacao,_LLA,nLab,nPosLauL] # cFatApr
					cLaudo:=aResultados[nOperacao,_LLA,nLab,nPosLauL]
					cLab  := aResultados[nOperacao,_LAB,nLab]
					Exit
				Else
					cLaudo := aResultados[nOperacao,_LLA,nLab,nPosLauL]
				EndIf
			Else
				IIF(Empty(cLaudo),cLaudo:=cFatApr,.F.)
			EndIf
		EndIf
	Next nLab
	
	If lContinua
		IF cLaudo == cFatRep
			cMensNConf := STR0099 + cLab	//"O Laudo da Operacao deve ser REPROVADO devido ao Laboratorio :"
		ElseIf cLaudo $ cFatApC
			cMensNConf := STR0100 + cLab	//"O Laudo da Operacao deve ser APROVADO CONDICIONAL devido ao Laboratorio :"
		EndIf
	EndIf
	
ElseIf nFldOpe == 2  //Valida Apenas as Medicoes do Laboratorio corrente

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se foram digitados os instrumentos obrigatórios.				              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aRetIns := QP215VaLIn("L")
	If Iif( cMV_QINOBFM != "3", aRetIns[1], .T.)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica Plano de Amostragem no Laudo do Laboratorio.					              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aRetPlano  := QP215PlAm()
		cMensNConf := aRetPlano[1]		//Mensagem do Plano de Amostragem
		lAbandona  := aRetPlano[3]
		lAprovado  := aRetPlano[2]		//Flag informando que existe plano de amostragem com laudo reprovado.
		
		If !lAbandona
			
			If lLayout
				nPosLau := QP215GetLau(aSavGets[nOperacao,2,nFldLab],"QPL_LAUDO")
			Else                                                                                                   
				nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
			EndIf
			nPulaEns:=0
			For nEns := 1 to Len(aResultados[nOperacao,_ENS,nFldLab])
				If ExistBlock("QP215ALL")
					lAnalisa := ExecBlock("QP215ALL",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO]})
				EndIf
				If lAnalisa
					nPosEnsR   := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns][1],{|x|Alltrim(x[2])=="QPR_ENSR" })
					nDtM	   := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns][1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
					nHrM	   := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns][1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})
					nAmo	   := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns][1],{|x|Alltrim(x[2])=="QPR_AMOSTR"})
					nTotEnsDel := 0 // Total de Medições deletadas
					For nCEns := 1 To Len(aResultados[nOperacao,_MED,nFldLab,nEns])
					
						If aResultados[nOperacao,_ENS,nFldLab,nEns,CARTA] == "P  "
							nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
		 					nPosCpo    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPS_MEDIPA"})
					
						ElseIf aResultados[nOperacao,_ENS,nFldLab,nEns,CARTA] == "TXT"
							nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
							nPosCpo    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
						Else
							nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
		 					nPosCpo    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEns,1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
						EndIf
						       
						cMedicao := Iif(Valtype(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult])=="N",Str(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult]),aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult])
						nDelMed	:= Len(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns])
						cInsCer := QP215SkpT(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
						If !(Upper(Substr(cInsCer,1,3)) == "CER")
							
							//Verifica se existem medições em branco para ensaio dimensionais
							nQtdMed  := aResultados[nOperacao,_ENS,nFldLab,nEns,QTDMED]
							If	!aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed]
								nQtdCpo := (nPosCpo+nQtdMed-1)
								For nX := nPosCpo to nQtdCpo 
									If Empty(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nX]) .AND. aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S"
    									nPulaEns++
    									cEnsSemMed += IIF(nPulaEns>1,", ","")+Alltrim(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
    									If nPulaEns>4
											cEnsSemMed += ","+CHR(13)+CHR(10)
											nPulaEns:=0
										EndIf	
										lContinua := .F.
										Exit
									EndIF								
								Next nX
							EndIF							

							//Verifica se possui resultado na medição
							If !aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed] .And. lContinua //Caso esteja em branco ou deletado
								If Empty(cMedicao) .AND. aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S"
									nPulaEns++
									cEnsSemMed += IIF(nPulaEns>1,", ","")+Alltrim(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
   									If nPulaEns>4
										cEnsSemMed += ","+CHR(13)+CHR(10)
										nPulaEns:=0
									EndIf	
									lContinua := .F.
									Exit
								ElseIf !lPerEnSMed .AND. Empty(cMedicao) .AND. aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "N"
									cLaudo:=cFatRep
									cMensNConf := STR0223 //"O Laudo deve ser REPROVADO pois existem ensaios sem laudo."
								Else
									If Empty(cLaudo)
										IF aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult] == "R"
											cLaudo:=cFatRep
										ElseIf aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult] == "T"  .And. cMV_QAPCTOL == "S"
											cLaudo:=SubStr(Alltrim(cFatApC),1,1)
										Else
											cLaudo:=cFatApr
										EndIF
									Else
										IIF(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult] == "R",cLaudo:=cFatRep,.T.)
									EndIF
								EndIF
								IF aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosResult] == "R" .or. !lAprovado
									cMensNConf := IIf(lAprovado,STR0101+ aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO],cMensNConf)	//"O Laudo do Laboratorio dever REPROVADO devido medicoes reprovadas no ensaio: "
									cLaudo     := cFatRep
								ElseIf cLaudo $ cFatApC 
									cMensNConf := STR0219+ aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO]  //"O Laudo do Laboratorio deve ser APROVADO CONDICIONAL devido medicoes do ensaio: "
								EndIf 
							Else
								If aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed] .AND. aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S"
									nTotEnsDel++
							    	If nTotEnsDel == Len(aResultados[nOperacao,_MED,nFldLab,nEns]) .AND. !lIgnEnSMed // Valida Ensaio Deletado = Sim
										cEnsSemMed += Iif(nPulaEns>1,", "," ")+Alltrim(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
   										If nPulaEns>4
											cEnsSemMed += ","+CHR(13)+CHR(10)
											nPulaEns:=0
										EndIf
										nPulaEns++
										lContinua := .F.
									EndIf  
/*						        ElseIf lPerEnSMed .AND. aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed] .AND. aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S"
									nTotEnsDel++
									If nTotEnsDel == Len(aResultados[nOperacao,_MED,nFldLab,nEns]) .AND. !lIgnEnSMed // Valida Ensaio Deletado = Sim
							        	cEnsSemMed += IIF(nPulaEns>1,", "," ")+Alltrim(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
   										If nPulaEns>4
											cEnsSemMed += ","+CHR(13)+CHR(10)
											nPulaEns:=0
										EndIf
										nPulaEns++
						        	Endif*/
						    	EndIf
							EndIf
							
							//Verifica se possui informações obrigatorias
							If 	!aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDelMed] .AND.;
								lContinua .AND.; 
								aResultados[nOperacao,_ENS,nFldLab,nEns,ENSOBR] == "S" 
								
								If 	Empty(cMedicao) .OR.;
									Empty(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nPosEnsR]) .OR. ;       
								   	Empty(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nDtM]) 	.OR. ;       
								   	Empty(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nHrM]) 	.OR. ;       
								   	Empty(aResultados[nOperacao,_MED,nFldLab,nEns,nCEns,nAmo])      
    								
    								cEnsSemMed += IIF(!Empty(cEnsSemMed),", ","")+Alltrim(aResultados[nOperacao,_ENS,nFldLab,nEns,ENSAIO])
									lContinua := .F.
									Exit                                                            
									
								EndIf

							EndIf
						EndIf
					Next nCEns
				Else
					IIF(Empty(cLaudo),cLaudo:=cFatApr,.F.)
				EndIf
			Next nEns
											
		Else
			If !lLayout
				lFechaLab := .T.
			EndIf
			Return(.F.)
		EndIF

	Else
		MsgAlert(aRetIns[2])
		If !lLayout
			lFechaLab := .T.
		EndIf
		Return(.F.)
	EndIF
	
ElseIf nFldOpe == 3 // Laudo Geral
	
	If lLiberaUrg
		cLaudo     := cFatLU
		lContinua  := .T.
	Else
		If lLayout
			nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
		Else                                                                                                   
			nPosLau := QP215GetLau(aSavGets[1,1],"QPL_LAUDO")
		EndIf
		For nPosOpe := 1 To nQtdOpe
			If lContinua
				If lLayout
					nPosLauOP := QP215GetLau(aSavGets[nPosOpe,1],"QPM_LAUDO")
				Else                                                                                                   
					nPosLauOP := Iif(QP215GetLau(aSavGets[1,1],"QPM_LAUDO") == 0, 3, QP215GetLau(aSavGets[1,1],"QPM_LAUDO")) 
				EndIf
				
				If ExistBlock("QP215ALG")
					lAnalisa := ExecBlock("QP215ALG",.F.,.F.,{aResultados[nPosOpe,_OPE],aResultados[nPosOpe,_LOP,nPosLauOP]})
				EndIf
				
				If lAnalisa
					If aOperacoes[nPosOpe,Iif(lLayout,8,6)] == "S"				//Operacao Obrigatoria
						If aOperacoes[nPosOpe,Iif(lLayout,9,7)] == "S"			//Sequencia Obrigatoria
							If aOperacoes[nPosOpe,Iif(lLayout,10,8)] == "S"		//Laudo Obrigatorio
								If Empty(aResultados[nPosOpe,_LOP,nPosLauOP])
									If lPerOPSLau .AND. qpAviso("",STR0198+AllTrim(aResultados[nPosOpe,_OPE])+STR0102,{STR0082,STR0083}) == 1  //"Existe ensaio obrigatório que não foi preenchido :"###" para que seja possível informar o laudo do Laboratório, será sugerido laudo reprovado, deseja continuar?"###"Continua"###"Abandona"	
										cLaudo := cFatRep 
										cOpe   := aResultados[nPosOpe,_OPE]
										Exit
									Else
										If !lPerOPSLau
											MsgAlert(STR0198 +AllTrim(aResultados[nPosOpe,_OPE])+STR0103)
										EndIf
										lContinua := .F.
										Exit
									EndIf
								Else
									If aResultados[nPosOpe,_LOP,nPosLauOP] # cFatApr
										cLaudo:=aResultados[nPosOpe,_LOP,nPosLauOP]
										cOpe  :=aResultados[nPosOpe,_OPE]
										Exit
									Else
										cLaudo :=aResultados[nPosOpe,_LOP,nPosLauOP]
									EndIf
								EndIf
							EndIf
						Else
							If aOperacoes[nPosOpe,Iif(lLayout,10,8)] == "S"			//Laudo Obrigatorio
								If Empty(aResultados[nPosOpe,_LOP,nPosLauOP])
									If lPerOPSLau .AND. qpAviso("",STR0198+AllTrim(aResultados[nPosOpe,_OPE])+STR0102,{STR0082,STR0083}) == 1  //"Existe ensaio obrigatório que não foi preenchido :"###" para que seja possível informar o laudo do Laboratório, será sugerido laudo reprovado, deseja continuar?"###"Continua"###"Abandona"	
										cLaudo := cFatRep
										cOpe   := aResultados[nPosOpe,_OPE]
										Exit
									Else
										If !lPerOPSLau
											MsgAlert(STR0198 +AllTrim(aResultados[nPosOpe,_OPE])+STR0103)
										EndIf
										lContinua := .F.
										Exit
									EndIf
								Else
									cLaudo := aResultados[nPosOpe,_LOP,nPosLauOP]
								EndIf
							Else
								If Empty(aResultados[nPosOpe,_LOP,nPosLauOP])
									cLaudo := SubStr(Alltrim(cFatApC),1,1)
								Else
									If aResultados[nPosOpe,_LOP,nPosLauOP] # cFatApr
										cLaudo := aResultados[nPosOpe,_LOP,nPosLauOP]
										cOpe   := AllTrim(aResultados[nPosOpe,_OPE])
										Exit
									Else
										cLaudo := aResultados[nPosOpe,_LOP,nPosLauOP]
									EndIf
								EndIf
								cOpe   := AllTrim(aResultados[nPosOpe,_OPE])
							EndIf
						EndIf
					ElseIf !Empty(aResultados[nPosOpe,_LOP,nPosLauOP])
						If aResultados[nPosOpe,_LOP,nPosLauOP] # cFatApr
							cLaudo := aResultados[nPosOpe,_LOP,nPosLauOP]
							cOpe   := AllTrim(aResultados[nPosOpe,_OPE])
						Else
							cLaudo := aResultados[nPosOpe,_LOP,nPosLauOP]
						EndIf
						cOpe   := AllTrim(aResultados[nPosOpe,_OPE])
					EndIf
					
					If  aOperacoes[nPosOpe,Iif(lLayout,8,6)]  == "N"	.Or.; //Operacao Obrigatoria
						aOperacoes[nPosOpe,Iif(lLayout,10,8)] == "N" 		  //Laudo Obrigatorio
						If Empty(aResultados[nPosOpe,_LOP,nPosLauOP])
			  			    If !lIntApr
								cLaudo := cFatRep
								cOpe   := AllTrim(aResultados[nPosOpe,_OPE])
								Exit
					    	EndIf
						EndIF
					EndIF
				Else
					IIF(Empty(cLaudo),cLaudo:=cFatApr,.F.)
				EndIf
				
			EndIf
		Next nPosOpe
	EndIf
	
	cLauAnt := cLaudo
	
	If lContinua
		If cLaudo == cFatApr 
			cMensNConf := "O Laudo Geral da OP deve ser APROVADO TOTALMENTE."  //"O Laudo Geral da OP deve ser APROVADO TOTALMENTE."  
		ElseIf cLaudo == cFatRep
			cMensNConf := STR0104 + cOpe	//"O Laudo Geral da OP deve ser REPROVADO devido a Operacao : "
		ElseIf cLaudo $ cFatApC
			cMensNConf := STR0105 + cOpe	//"O Laudo Geral da OP deve ser APROVADO CONDICIONAL devido a Operacao :"
		ElseIf cLaudo == cFatLU
			cMensNConf := STR0106			//"O Laudo Geral da OP deve ser APROVADO atraves da rotina de LIBERACAO URGENTE."
		EndIf
		
		If lQP215J19 .AND. cLauAnt <> M->QPL_LAUDO
			aLaudo := ExecBlock("QP215J19",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados,nOpcX,cLaudo,cMensNConf,nFldOpe})
			If Len(aLaudo) > 0
				cLauAnt    := aLaudo[1]
				cLaudo     := aLaudo[1]
				cMensNConf := aLaudo[2]
			EndIf
		EndIf
	Else
		cLaudo := " "
	EndIF
EndIf

If lContinua 
	
	If nFldOpe == 2  //Valida Apenas as Medicoes do Laboratorio corrente
	
		If cMV_QINOBFM == "3" .AND. !aRetIns[1]
			MsgAlert(aRetIns[2])
			If !lLayout
				lFechaLab := .T.
			EndIf
			Return(.F.)
		EndIf 
		
		If lQP215J19 .AND. lAprovado
			aLaudo := ExecBlock("QP215J19",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados,nOpcX,cLaudo,cMensNConf,nFldOpe})
			If Len(aLaudo) > 0
				cLaudo     := aLaudo[1]
				cMensNConf := aLaudo[2]
			EndIf
		EndIf
	EndIf

	QPD->(dbSetOrder(1))
	QPD->(dbSeek(xFilial("QPD")+cLaudo))

	If nFldOpe == 2 .or. nFldOpe == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Sugere a data/hora do laudo tambem ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cLaudo)
			M->QPL_DTLAUD := dDataBase
			M->QPL_HRLAUD := Time()  
			M->QPL_LAUDO  := cLaudo
			IF __LANGUAGE == "PORTUGUESE"
				M->QPL_DESLAU := QPD->QPD_DESCPO
			ElseIF __LANGUAGE == "SPANISH"
				M->QPL_DESLAU := QPD->QPD_DESCES
			ElseIF __LANGUAGE == "ENGLISH" 
				M->QPL_DESLAU := QPD->QPD_DESCES
			Endif
			If cLaudo == "A"
				M->QPL_QTREJ  := Left("0",TamSx3("QPL_QTREJ")[1]) 
			Else
				M->QPL_QTREJ  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
			Endif	
		Endif
		
		If nFldOpe == 3  .and. !Empty(cLaudo) // Laudo Geral
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Calcula Data de Validade do Laudo geral OP (Shelf-Life)	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If QP6->QP6_SHLF > 0  
				If QP6->QP6_TPSLIF == "1" 
					nDias := QP6->QP6_SHLF
				ElseIf QP6->QP6_TPSLIF == "2"
					nDias := QP6->QP6_SHLF*30
				ElseIf QP6->QP6_TPSLIF == "3"
					nDias := Int(QP6->QP6_SHLF/24)
				ElseIf QP6->QP6_TPSLIF == "4"
					nDias := QP6->QP6_SHLF*365
				EndIf
				M->QPL_DTVAL := M->QPL_DTLAUD + nDias	 		
			EndIf
			If QPD->QPD_CATEG == "3"
				M->QPL_QTREJ := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
			EndIF		
		EndIf	

	Else
		
		If !Empty(cLaudo)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Sugere a data/hora do laudo tambem ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(M->QPM_DTLAUD)
				M->QPM_DTLAUD	:= dDataBase
				M->QPM_HRLAUD	:= Time()
			Endif
			M->QPM_LAUDO  := cLaudo
			IF __LANGUAGE == "PORTUGUESE"
				M->QPM_DESLAU := QPD->QPD_DESCPO
			ElseIF __LANGUAGE == "SPANISH"
				M->QPM_DESLAU := QPD->QPD_DESCES
			ElseIF __LANGUAGE == "ENGLISH" 
				M->QPM_DESLAU := QPD->QPD_DESCES
			Endif
		EndIf
		If lLayout
			oGetLauOpe:Refresh()
		Endif
		QP215SavResu({SAV_LAUO},.T.)  
		If lLayout
			aOperacoes[nOperacao,1] := QP215AtuSta(nOperacao,,,,"O",{1},.F.)
			aOperacoes[nOperacao,2] := QP215AtuSta(nOperacao,,,,"O",{1},.F.)
			aOperacoes[nOperacao,3] := QP215AtuSta(nOperacao,,,,"O",{2},.F.)
			oBrwOpe:SetFocus()
			oBrwOpe:Refresh()
		EndIf
	EndIf
	
	If !Empty(cMensNConf)
		MessageDlg(cMensNConf,,3)    
		cMensNConf := ""
	EndIf 

Else
   
	If !lPerEnSMed .AND. !Empty(cEnsSemMed)	
		//HELP(" ",1,"QPH215013",,cEnsSemMed,6,0) //Existe ensaio obrigatório cuja medicao nao foi apontada, para que seja possível informar o laudo do Laboratório, favor apontar medicoes para o ensaio:
		qpAviso("","Existe(m) ensaio(s) obrigatório(s) cuja medicao nao foi apontada, para que seja possível informar o laudo do Laboratório, favor apontar medicoes para o ensaio: "+cEnsSemMed,{"OK"},Nil,Nil)
		lRetorno:= .F.
	ElseIf lPerEnSMed .AND. !Empty(cEnsSemMed)	
		If qpAviso("",STR0080 +cEnsSemMed+STR0081,{STR0082,STR0083}) == 1  //"Existe ensaio obrigatório que não foi preenchido :"###" para que seja possível informar o laudo do Laboratório, será sugerido laudo reprovado, deseja continuar?"###"Continua"###"Abandona"
			cMensNConf := "O Laudo do Laboratorio deve ser REPROVADO devido a existência de ensaios obrigatórios não preenchidos!"
			cLaudo     := cFatRep    

			If nFldOpe == 2  //Valida Apenas as Medicoes do Laboratorio corrente
							
				If cMV_QINOBFM == "3" .AND. !aRetIns[1]
					MsgAlert(aRetIns[2])
					If !lLayout
						lFechaLab := .T.
					EndIf
					Return(.F.)
				EndIf 
				
				If lQP215J19
					aLaudo := ExecBlock("QP215J19",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados,nOpcX,cLaudo,cMensNConf,nFldOpe})
					If Len(aLaudo) > 0
						cLaudo     := aLaudo[1]
						cMensNConf := aLaudo[2]
					EndIf
				EndIf
			EndIf
						    
			M->QPL_DTLAUD := dDataBase
			M->QPL_HRLAUD := Time()  
			M->QPL_LAUDO  := cLaudo
			IF __LANGUAGE == "PORTUGUESE"
				M->QPL_DESLAU := QPD->QPD_DESCPO
			ElseIF __LANGUAGE == "SPANISH"
				M->QPL_DESLAU := QPD->QPD_DESCES
			ElseIF __LANGUAGE == "ENGLISH" 
				M->QPL_DESLAU := QPD->QPD_DESCES
			Endif
			If cLaudo == "A"
				M->QPL_QTREJ  := Left("0",TamSx3("QPL_QTREJ")[1]) 
			Else
				M->QPL_QTREJ  := Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
			Endif
			
			If !Empty(cMensNConf)
				MessageDlg(cMensNConf,,3)
			EndIf 
		
		Else
			lRetorno  := .F.
		EndIf 
	
	EndIf  

EndIf

If !lLayout
	lFechaLab := .T.
EndIf

Return(lRetorno)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Qp215TUDOK³ Autor ³ Cleber Souza          ³ Data ³11/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Realiza validacao geral da inspecao da OP.	 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nil														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExpL1 - Define se continua a gravacao da inspecao.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function Qp215TUDOK()
           
Local lRet      := .T.
Local nPosJus   := 0   
Local nPosLau   := 0   
Local nPosCha   := 0
Local aRetIns   := {} 
Local n
Local nPosLoRas	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LOTE' 	} )
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

If lLayout          
	nPosCha    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPR_CHAVE"})	
	QP215SavResu({SAV_RAS})
EndIf
               
//Nao valida para Liberacao Urgente.                        
If lLayout .AND. lLiberaUrg
	Return(.t.)
EndIf

//Verifica se o Instrumento eh obrigatorio, qual medicao esta sem instrumento.
If (cMv_QINTQMT == "S" .and. cMV_QPINSOB == "S") .OR. (cMv_QINTQMT == "S" .and. cMV_QPINSOB == "N" .AND. cMV_QINOBFM != "3")  //Não valido o Instrumento no TudoOK regra J&J
	aRetIns := QP215ValIn("T")
	If !aRetIns[1] .AND. nOpcX == 3
		lRet := aRetIns[1]   
	    MsgAlert(aRetIns[2])
	EndIf
EndIf	
//Varifica se eh Obrigatorio Justificar Laudos da OP.
If lRet

	If lLayout
		nPosJus := QP215GetLau(aSavGets[nFldLauGer],"QPL_JUSTLA")
		nPosLau := QP215GetLau(aSavGets[nFldLauGer],"QPL_LAUDO")
	Else                                                                                                   
		nPosJus := QP215GetLau(aSavGets[1,2],"QPL_JUSTLA")
		nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
	EndIf

    If  lLayout .AND. (aResultados[nFldLauGer,1,nPosLau] # cFatApr .or. lJusLObrG) .and.;
	    Empty(aResultados[nFldLauGer,1,nPosJus]) .and. !Empty(aResultados[nFldLauGer,1,nPosLau])
		Help(" ",1,"QPH215016")  //Eh obrigatorio a digitacao da justificativa do laudo Geral da OP.
		lRet  := .F.         
		Return(.F.)
	EndIf          
	If lRet
		lRet:=QP215VOMED()  
	Endif
	
	If lRet
		lRet:=QP215OkMed()
	Endif
	
	If lRet
	  	lRet:=QP215VLDJUS("L") 
	Endif
	
	If lRet
	   	lRet:=QP215VLDJUS("O")
	Endif
	
	If lLayout 	
		If nOpcx == 3 .And. nNoDel == 0 .And. len(aResultados[nOperacao,_RAS]) >=1       
			For n:=1 to len(aResultados[nOperacao,_RAS]) 
				If !empty(aResultados[nOperacao,_RAS,n,nposLoRas]) 
					If MsgYesNo(STR0236)//"Não há medições cadastradas, a rastreabilidade não será gravada.Deseja confirmar?"
						lNoGravRast:=.T.
					Else
						lRet:=.F.
					Endif 
					exit
				Endif
			Next n
		Endif	

		If Len(aResultados[nOperacao,_MED,nFldLab,nEnsaio,nMedicao])>0
			If Empty(aResultados[nOperacao,_MED,nFldLab,nEnsaio,nMedicao,nPosCha])
				QP215CalMd ()
				QP215ChgMed(nOperacao,nFldLab,nEnsaio,nMedicao)
				QP215RightMe(nOperacao,nFldLab,nEnsaio) 
			Endif
		Endif
	EndIf
EndIf  

If lRet .And. ExistBlock("Q215TDOK")
	lRet := ExecBlock("Q215TDOK",.F.,.F.)
EndIf
    
Return(lRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ADMOBJ³ Autor ³ Cleber Souza 	    ³ Data ³12/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Bloqueia os objetos que controlam laudos de Operacao, Labora³±±
±±³          ³torio e Geral. 											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1 - Posicao da Operacao 								  ³±±
±±³			 ³ExpN2 - Posicao do Laboratorio							  ³±±
±±³			 ³ExpN3 - Posicao do Ensaio     							  ³±±
±±³			 ³ExpN4 - Define qual objeto sera controlado.				  ³±±
±±³          ³Expl1 - Define se bloqueia ou libera objeto				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³Nil 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215					                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ADMOBJ(nPosOpe,nPosLabi,nPosEns,nTipo,lBlock)

Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"        
Local nY      := 0     
Local nW      := 0
Local nPosLau := 0
                                                
If nTipo == 1 // Bloqueia objetos laudo Laboratorios.
	
	If !lAlteravel
		For nY:=1 to Len(aResultados[nPosOpe,_LAB])
			 
			If lLayout
				IF lBlock
					aOBJETOS[OBJ_LAUDO,nPosOpe,nY,1]:oBox:Disable()
				Else
					aOBJETOS[OBJ_LAUDO,nPosOpe,nY,1]:oBox:Enable()
				EndIf
				
				nPosLau := QP215GetLau(aSavGets[nPosOpe,2,nY],"QPL_LAUDO")

				For nW:=1 to Len(aResultados[nPosOpe,_ENS,nY])
					//Bloqueia getdados das medicoes
					aOBJETOS[OBJ_MEDICA,nPosOpe,nY,nW]:lupdate := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
					aOBJETOS[OBJ_MEDICA,nPosOpe,nY,nW]:linsert := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
					aOBJETOS[OBJ_MEDICA,nPosOpe,nY,nW]:ldelete := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
					aOBJETOS[OBJ_MEDICA,nPosOpe,nY,nW]:Refresh()
				Next nW
				
				//Bloqueia getdados das Nao Conformidades
				aOBJETOS[OBJ_NCC,nPosOpe,nY,1]:lupdate := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_NCC,nPosOpe,nY,1]:linsert := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_NCC,nPosOpe,nY,1]:ldelete := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_NCC,nPosOpe,nY,1]:Refresh()
				
				//Bloqueia getdados dos Instrumentos
				aOBJETOS[OBJ_INST,nPosOpe,nY,1]:lupdate := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_INST,nPosOpe,nY,1]:linsert := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_INST,nPosOpe,nY,1]:ldelete := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				aOBJETOS[OBJ_INST,nPosOpe,nY,1]:Refresh()

			Else                                                                                                   
				nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO")
		
				oGetMed:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
				oGetMed:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
				oGetMed:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
				oGetMed:Refresh()
		
				If ValType(oGetNC) == "O"
					//Bloqueia getdados das Nao Conformidades
					oGetNC:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
					oGetNC:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
					oGetNC:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
					//oGetNC:Refresh()
				EndIf
					                          
				If ValType(oGetIns) == "O"
					//Bloqueia getdados dos Instrumentos
					oGetIns:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
					oGetIns:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
					oGetIns:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
				EndIf
					
			EndIf

			If lLayout
				//Bloqueia Get da Cronica
				lWhnCro := Empty(aResultados[nPosOpe,_LLA,nY,nPosLau]) .and. (INCLUI .or. ALTERA)
				oCronica:Refresh()
			EndIf
		Next nY
	EndIf
	
ElseIf nTipo == 2 //Bloqueia objetos laudo Operacao

	If lLayout    
	   	//Bloqueia getdados das medicoes
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEns]:lupdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEns]:linsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEns]:ldelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLabi,nPosEns]:Refresh()

		//Bloqueia getdados das Nao Conformidades
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLabi,1]:lupdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLabi,1]:linsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLabi,1]:ldelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_NCC,nPosOpe,nPosLabi,1]:Refresh()

		//Bloqueia getdados dos Instrumentos
		aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,1]:lupdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,1]:linsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,1]:ldelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		aOBJETOS[OBJ_INST,nPosOpe,nPosLabi,1]:Refresh()
	
 		//Bloqueia Get da Cronica
		lWhnCro := IIF(lBlock,.F.,.T.)
	    oCronica:Refresh()
	 Else
		oGetMed:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		oGetMed:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		oGetMed:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		oGetMed:Refresh()

		If ValType(oGetNC) == "O"
			//Bloqueia getdados das Nao Conformidades
			oGetNC:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
			oGetNC:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
			oGetNC:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)  
			//oGetNC:Refresh()
		EndIf
			                          
		If ValType(oGetIns) == "O"
			//Bloqueia getdados dos Instrumentos
			oGetIns:lUpdate := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
			oGetIns:lInsert := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
			oGetIns:lDelete := IIF(lBlock .and. (INCLUI .or. ALTERA),.F.,.T.)
		EndIf
			
	 Endif

ElseIf nTipo == 3 //Bloqueia objetos laudo Geral

	If lLayout 	
	    If lBlock
	    	oGetLauOpe:oBox:Disable()
	    Else 
	    	oGetLauOpe:oBox:Enable()
	    EndIf
	EndIf

EndIf
  
  
Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215AtuSit³ Autor ³Cleber Souza          ³ Data ³12/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza a Situacao da OP Inspecionada/a Inspecionar       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Laudo da OP Inspecionada/a Inspecionar             ³±±
±±³			 ³ EXPL1 = Indica se ha Medicoes cadastradas				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215											          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215AtuSit(cLaudo,lMedicao)

cLaudo   := If(cLaudo==NIL," ",cLaudo)
lMedicao := If(lMedicao==NIL,.F.,lMedicao)

RecLock("QPK",.F.)                 
If Empty(cLaudo)          //OP Excluida
	QPK->QPK_SITOP := "1" 
ElseIf cLaudo == cFatApr  //Laudo Aprovado              
	QPK->QPK_SITOP := "2"
ElseIf cLaudo == cFatRep  //Laudo Reprovado
	QPK->QPK_SITOP := "3"
ElseIf cLaudo == cFatLU   //Laudo com Liberacao Urgente
	QPK->QPK_SITOP := "4"
ElseIf cLaudo $ cFatApC   //Laudo Aprovado condicionalmente    
	QPK->QPK_SITOP := "5"
EndIf      

If lMedicao
	If QPK->QPK_SITOP == "1" 
		QPK->QPK_SITOP := "7"
	EndIf		
EndIf      
MsUnLock()                      

Return()  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215DelMed ³ Autor ³ Cleber Souza        ³ Data ³ 12/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Realiza a exclusao das amarracoes referentes as OPs		  ³±±
±±³			 ³ inspecionadas.										      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Codigo da OP								 	      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215DelMed(cOP)
Local aOldArea   := GetArea()             
Local cChvMed    := ""
Local cCarEns    := ""
Local aCpoQNC    := {}   
Local lQP215J14	:= ExistBlock("QP215J14")
Local lQP220Qnc	 := ExistBlock("QP220QNC")

dbSelectArea("QPR")
dbSetOrder(9)
MsSeek(xFilial("QPR")+cOP+QPK->QPK_LOTE+QPK->QPK_NUMSER,.T.)
While Alltrim(QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_NUMSER) == Alltrim(xFilial("QPR")+cOP+QPK->QPK_LOTE+QPK->QPK_NUMSER)
      
	cChvMed := QPR->QPR_CHAVE
	cCarEns := QPCarta(QPR->QPR_ENSAIO) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao dos Instrumentos associados as medicoes  	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QPT")
	dbSetOrder(1)
	If MsSeek(xFilial("QPT")+cChvMed)
		While !Eof() .And. QPT->QPT_FILIAL+QPT->QPT_CODMED == xFilial("QPT")+cChvMed
			RecLock("QPT",.F.)
			dbDelete()
			MsUnLock()
			FKCOMMIT()
			dbSkip()
		EndDo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao das nao-conformidades associadas as medicoes	   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QPU")
	dbSetOrder(1)
	If MsSeek(xFilial("QPU")+cChvMed)
		While !Eof() .And. QPU->QPU_FILIAL+QPU->QPU_CODMED == xFilial("QPU")+cChvMed
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Integracao SIGAQIE x SIGAQNC									   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !Empty(QPU->QPU_CODNC) .And. !Empty(QPU->QPU_REVNC)
				aCpoQNC := {}
			    Aadd(aCpoQNC,xFilial("QI2"))
				Aadd(aCpoQNC,QPU->QPU_CODNC) 
				Aadd(aCpoQNC,QPU->QPU_REVNC)
				If !lQP220Qnc
					QNCGERA(2,aCpoQNC)
				Else 
					ExecBlock("QP220QNC",.f.,.f.,{aCpoQNC,QPU->QPU_CHAVE,"E"})
				EndIF 
			EndIf	       
			
			RecLock("QPU",.F.)
			dbDelete()
			MsUnLock()
			FKCOMMIT()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza a Exclusao da Cronica das nao-conformidades				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QA_DelTxt(QPU->QPU_CHAVE,"QIEA210C")	
	
			dbSelectArea("QPU")
			dbSkip()           
			
		EndDo
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a exclusao das medicoes mensuraveis						   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCarEns # "TXT" 

		dbSelectArea("QPS")
		dbSetOrder(1)
		If MsSeek(xFilial("QPS")+cChvMed)
			While !Eof() .And. QPS->QPS_FILIAL+QPS->QPS_CODMED == xFilial("QPS")+cChvMed 
				RecLock("QPS",.F.)
				dbDelete()
				MsUnLock()
				FKCOMMIT()
				dbSkip()
			EndDo
		EndIf
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a exclusao das medicoes texto							   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("QPQ")
		dbSetOrder(1)
		If MsSeek(xFilial("QPQ")+cChvMed)
			While !Eof() .And. QPQ->QPQ_FILIAL+QPQ->QPQ_CODMED == xFilial("QPQ")+cChvMed
				RecLock("QPQ",.F.)
				dbDelete()
				MsUnLock()
				FKCOMMIT()
				dbSkip()
			EndDo
		EndIf
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a Exclusao da medicao									   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("QPR")	
	RecLock("QPR",.F.)
	dbDelete()
	MsUnLock()
	FKCOMMIT()
    dbSkip()
    
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a Exclusao dos Laudos Geral e do Laboratorio.			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPL")
dbSetOrder(3)
If MsSeek(xFilial("QPL")+cOP+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro)
	While !Eof() .And. Alltrim(QPL->QPL_FILIAL+QPL->QPL_OP+QPL->QPL_LOTE+QPL->QPL_NUMSER+QPL->QPL_ROTEIR)== Alltrim(xFilial("QPL")+cOP+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro)	
		If lQP215J14
			ExecBlock("QP215J14",.F.,.F.,{"QPL","D"})
		EndIf
		RecLock("QPL",.F.)
		dbDelete()
		MsUnLock()
		FKCOMMIT()
		dbSkip()
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza a Exclusao dos Laudos da Operacao.						   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPM")
dbSetOrder(3)
If MsSeek(xFilial("QPM")+cOP+QPK->QPK_LOTE+QPK->QPK_NUMSER+cRoteiro)
	While !Eof() .And. Alltrim(QPM->QPM_FILIAL+QPM->QPM_OP)==Alltrim(xFilial("QPM")+cOP)
		RecLock("QPM",.F.)
		dbDelete()
		MsUnLock()
		FKCOMMIT()
		dbSkip()
	EndDo
EndIf  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta os Documentos Anexo.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QQJ")
dbSetOrder(2)
If MsSeek(xFilial("QQJ")+cOP)
	While !Eof() .And. Alltrim(QQJ->QQJ_FILIAL+QQJ->QQJ_OP)== Alltrim(xFilial("QQJ")+cOP)	
		RecLock("QQJ",.F.)
		dbDelete()
		MsUnLock()
		FKCOMMIT()
		dbSkip()
	EndDo
EndIf         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta a Rastreabilidade                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QQG")
dbSetOrder(2)
If MsSeek(xFilial("QQG")+cOP)
	While !Eof() .And. Alltrim(QQG->QQG_FILIAL+QQG->QQG_OP)== Alltrim(xFilial("QQG")+cOP)	
		RecLock("QQG",.F.)
		dbDelete()
		MsUnLock()
		FKCOMMIT()
		dbSkip()
	EndDo
EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Exclui o texto da Liberacao Urgente								   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QPK->QPK_SITOP $ "1467"
	QA_DelTxt(QPK->QPK_CHAVE,"QIPA210U") 
EndIf                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Acerta Situacao da OP.											   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPK")
RecLock("QPK",.F.)
QPK->QPK_SITOP  := " "
QPK->QPK_LAUDO  := "0"
QPK->QPK_CERQUA := " "
MsUnlock()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o campo Resultado, utilizado na consulta de rastreabilidade      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QPR")
dbSetOrder(5)
If !QPR->(dbSeek(xFilial("QPR")+QP6->QP6_PRODUT+QP6->QP6_REVI))
	dbSelectArea("QP6")
	Reclock("QP6",.F.)
	QP6->QP6_RESULT := " "
	MsUnlock()
EndIf

If ExistBlock("QP215R")
	ExecBlock("QP215R",.F.,.F.,{nOpcX})
Endif

RestArea(aOldArea)
Return(NIL)                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215HTOM ºAutor  ³Cleber Souza        º Data ³  12/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de conversao de horas para minutos.	              º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 = Hora informados para conversao.		  		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPC1 = Minutos convertidos.								  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215	                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215HTOM(cHora)

Local nMin 
Local nPos

nPos := At(":",cHora)
nMin := (Val(Subs(cHora,nPos-2,2)) * 60) + Val(Subs(cHora,nPos+1,2))

Return(Alltrim(Str(nMin)))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215MTOH ºAutor  ³Cleber Souza		 º Data ³  12/12/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa de conversao de minos para horas.                 º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Minutos informados para conversao.			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPC1 = Hora convertida.									  ³±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215MTOH(nMin)

Local nInt
Local nDec

nInt := Int(nMin / 60)
nDec := Mod(nMin , 60)      

Return(Str(nInt,6)+":"+StrZero(nDec,2)) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215PlAm ³ Autor ³ Cleber Souza          ³ Data ³16/12/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Faz o controle do Plano de Amostragem x Nao Conformidade.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPC1 = Mensagem gerada pelo plano de amostragem.		  ³±±
±±³ 		 ³ EXPL1 = Flag que demonstra se ha ou naum NCC.			  ³±±
±±³  		 ³ EXPL2 = Flag indicando se deve abandonar o laudo.		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Siga Quality 			                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215PlAm(lExibeMsg, cRet, nPosE)
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local cPlAmEns	:= ''
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cOper		:= ''
Local cRoteiro	:= Iif(Empty(cRoteiro),"01",cRoteiro)
Local cCarta	:=	''
Local nQtdMed   := 0
Local nDel 		:= 0
Local nLoop		:= 0
Local cAmost	:= ''
Local cIntNor	:= ''	//Define se o tratamento serah em Pl.Amostragem Interno ou em NBR5626.
Local nAceite	:= 0
Local nRejeite	:= 0
Local nTamAmo	:= 0
Local cFatcon	:= ''
Local cTipCon	:= ''
Local nLoop2	:= 0
Local nLoop3	:= 0
Local aClasseNC	:= {}
Local nDelNco	:= 0
Local nDelMed	:= 0
Local nC		:= 0
Local aPlInt1   := {}
Local aPlInt2   := {}
Local lContinua	:= .T.
Local cClasse	:= " "
Local lAprova	:= .T.
Local cTamAmo	:= Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])	//Tamanho total do Lote
Local nAmo		:= 0
Local nCount01	:= 0
Local nCount02	:= 0
Local nCount11	:= 0
Local nCount12	:= 0
Local nCount21	:= 0
Local nCount22	:= 0
Local nCount31	:= 0
Local nCount32	:= 0
Local nCount41  := 0
Local nCount42	:= 0
Local nTamFor	:= 0
Local nCPlano	:= 0
Local nPlano	:= 0
Local cEnsaio	:= ''
Local aCtMED	:= {}	//Contador de medicoes por amostragem em cada ensaio
Local aCtNC		:= {}	//Contador de Nao conformidades por amostragem em cada ensaio
Local nTotGener1:= 0
Local nTotGener2:= 0
Local lNcok		:= .F.
Local lRepRes	:= .F.
Local nPosResult:= 0
Local lGeralNc	:= .T.
Local lMensNconf:= .F.
Local lSegAmost	:= .T.
Local lAbandona := .F.
Local lTemNConf	:= .F. //Flag para indicar se tem ou nao nao conformidade informada
Local lSegunda	:= .F. //Flag para mostrar a 2a. amostragem
Local cCodNorma := " "
Local aMed5429  := {}
Local nPosMed   := 0
Local nPosCpo   := 0
Local nQtdCpo   := 0
Local nLIETol   := 0
Local nLSETol   := 0
Local aHead     := {} 
Local nLoop1    := 0 
Local aRetorno  
Local cAliasEns := " "
Local aCtNCAcu  := {} 
Local aCtMEDAcu := {}               
Local lAnalisa  := .T.
Local lQP215J20 := ExistBlock("QP215J20")

Default lExibeMsg := .T.
If !lLayout
	//Q216ARESU()
	nOperacao := nPosOper 
	nFldLab   := nPosLab
EndIf

cOper := aResultados[nOperacao,_OPE]
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o Fator Conversao, se nao estiver definido             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QP6->QP6_UNMED1 == QPK->QPK_UM
	cFatCon := QP6->QP6_FATCO1
	cTipCon := QP6->QP6_TIPCO1
ElseIf QP6->QP6_UNMED2 == QPK->QPK_UM
	cFatCon := QP6->QP6_FATCO2
	cTipCon := QP6->QP6_TIPCO2
EndIf
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Tamanho da Amostra                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
If Superval(cFatCon) <> 0
	cFatCon := StrTran(cFatcon,",",".")
	If cTipCon == "D"
		cTamAmo := Alltrim(Str(QPK->QPK_TAMLOT / Superval(cFatCon)))
	Else
		cTamAmo := Str(QPK->QPK_TAMLOT * Superval(cFatCon))
	EndIf
EndIf                             

If !lLayout .AND. lQP215J20
	cTamAmo := ExecBlock("QP215J20",.f.,.f.,{nOpcX,cOper,QPK->QPK_OP})
EndIf

//nPosOper,_ENS,nPosLab,nPosEns
For nLoop1 := 1 To Len(aResultados[nOperacao,_ENS,nFldLab])
	
	If ExistBlock("QP215ALL")
		lAnalisa := ExecBlock("QP215ALL",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]})
	EndIf
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vetor com o no. de Medicoes em cada amostragem, por ensaio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aCtMED,{0,0,aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,1]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,2]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,3]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,4]})
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vetor com o no. de NCs em cada amostragem, por ensaio ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aCtNC,{0,0,aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,1]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,2]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,3]+;
	aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,4]})  
   		
	If lAnalisa
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorna a Posicao do campo Amostragem                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCarta := aResultados[nOperacao,_ENS,nFldLab,nLoop1,CARTA]
		nAmo   := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=='QPR_AMOSTR'})
		If cCarta == "TXT"
			nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
		Else
			nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Retorna numero de medicoes a partir do Ensaio corrente ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nQtdMed  := aResultados[nOperacao,_ENS,nFldLab,nLoop1,QTDMED]

		For nLoop := 1 To Len(aResultados[nOperacao,_MED,nFldLab,nLoop1])			// Todas as medicoes
			nDel := Len(aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop])
			If	!aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop,nDel]	.And.;		// Nao esta deletado
				!Empty(AllTrim(aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop,nPosResult]))
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza array dependendo da Amostragem    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop,nPosResult])
					aCtMED[nLoop1,aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop,nAmo]]++
				EndIf
	
				If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop,nPosResult] == "R"
					lRepRes := .T.	//Reprova resultado
				EndIf
			EndIf
		Next nLoop
		
		nDelMed    := Len(aResultados[nOperacao,_MED,nFldLab,nLoop1,1])
		
		For nLoop2 := 1 To Len(aResultados[nOperacao,_MED,nFldLab,nLoop1]) // Numero de medicoes
			If !aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nDelMed]
				If  Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1]) >= nLoop2 .AND. Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2]) >= 1
					nDelNco := Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,1])
					For nLoop3 := 1 To Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2]) // Numero de Ncs
						If !aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,nDelNco] .And.;
							!Empty(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,1]) .And.;
							QP215ChkGd(2,.F.,nOperacao,nFldLab,nLoop1,nLoop2,nLoop3,,.T.) // NC Nao Deletada
							
							lTemNConf:= .T. //Flag indicando que existe nao conformidade
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Utilizado para Plano de Amostragem Interno ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If cIntNor # "I"
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Utilizado para Plano de Amostragem NBR5426 ou QS9000  ³
								//³ Como contador das Nao Conformidades.                  ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aCtNC[nLoop1,aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo]]+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
							EndIf
						EndIf
					Next nLoop3
				EndIf
			EndIf
		Next nLoop2
		
	EndIf
	
Next nLoop1
    

For nLoop1 := Iif(lExibeMsg,1,nPosE) To Len(aResultados[nOperacao,_ENS,nFldLab])
	cMensagem:=""
	lSegAmost := .T.
	If ExistBlock("QP215ALL")
		lAnalisa := ExecBlock("QP215ALL",.F.,.F.,{aResultados[nOperacao,_OPE],aResultados[nOperacao,_LAB,nFldLab],aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]})
	EndIf
	
	If lAnalisa
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o Plano de Amostragem definido para o ensaio ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nTamAmo  := 0
		nAceite  := 0
		nRejeite := 0
		aPlInt1	 := {}
		aPlInt2	 := {}
		cPlAmEns := " "
		cIntNor  := " "
		cAmost	 := " "
		cClasse  := " "
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Retorna a Posicao do campo Amostragem                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCarta := aResultados[nOperacao,_ENS,nFldLab,nLoop1,CARTA]
		nAmo   := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=='QPR_AMOSTR'})
		If cCarta == "TXT"
			nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
		Else
			nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nLoop1,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
		EndIf
		
		If Alltrim(cCarta) <> "TXT"	//Tipo da Carta "X" Texto
			cAliasEns := "QP7"
		Else
			cAliasEns := "QP8"
		EndIf
		
		dbSelectArea(cAliasEns)
		dbSetOrder(1)
		If dbSeek(xFilial(cAliasEns)+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])
			cCodNorma := QA_Plano(&(cAliasEns+"_PLAMO"))
			
			If !Empty(&(cAliasEns+"_PLAMO"))
				cPlAmEns := QA_Plano(&(cAliasEns+"_PLAMO"))
				cIntNor  := &(cAliasEns+"_PLAMO")
				
				QQH->(dbSetOrder(1))
				QQH->(dbSeek(xFilial('QQH')+QPK->QPK_PRODUT+cRevi+cRoteiro+aResultados[nOperacao,_OPE]+aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]))
				If QQH->(!Eof())
					cAmost   := QQH->QQH_AMOST
					aRetorno := QEP_RetAmostra(cIntNor,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(cTamAmo)),8),"QPK_TAMLOT",.T.)
					If cIntNor == "I" //Somente para o Plano Interno
						aPlInt1 := aClone(aRetorno[1])
						aPlInt2 := aClone(aRetorno[2])
					Else
						nTamAmo  := aRetorno[1] //Amostra
						nAceite  := aRetorno[2] //Aceite
						nRejeite := aRetorno[3] //Rejeite
					EndIf
					
				EndIf
			EndIf
			
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe Plano de Amostragem definido para o Ensaio    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cPlAmEns)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tratar o tamanho da amostra caso seja valor Superior a quantidade³
			//³ da Ordem de Producao                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTamAmo > Val(cTamAmo)
				nTamAmo := Val(cTamAmo)
			EndIf
			
			nDelMed   := Len(aResultados[nOperacao,_MED,nFldLab,nLoop1,1])
			aMed5429 := {}
			
			For nLoop2 := 1 To Len(aResultados[nOperacao,_MED,nFldLab,nLoop1]) // Numero de medicoes
				If !aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nDelMed]
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Tratamento diferenciado para a Norma NBR-5429.                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If cIntNor == "B"  // B=NBR5429
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Armazena as medicoes efetuadas.                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If !Empty(aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nPosResult]) .And.;//Resultado da Medicao
							QP215ChkGd(1,.F.,nOperacao,nFldLab,nLoop1,nLoop2,,,.T.) // Nao deletado e Nao Vazio
							//Pesquisa posicao do campo de medicao.
							aHead   := aSavHeadEns[nOperacao,nFldLab,nLoop1,1]
							nPosMed := Ascan(aHead,{|x|Alltrim(x[2])=="QPS_MEDICA"})
							
							nPosCpo := nPosMed //QPS_MEDICA
							nQtdCpo := (nPosCpo+nQtdMed-1)
							For nPosCpo := nPosCpo to nQtdCpo
								If !Empty(aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nPosCpo])
									Aadd(aMed5429, aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nPosCpo])
								EndIf
							Next nPosCpo
						EndIf
					Else
						If Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1]) < nLoop2
							Aadd(aResultados[nOperacao,_NCO,nFldLab,nLoop1], aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,"     ","QPU_CODMED",Len(aSavaHeader[HEAD_NCS]))))
						ElseIf Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2]) < 1  
							aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2] :=  aClone(Q215FilCol(aSavaHeader[HEAD_NCS],"QPU",1,"     ","QPU_CODMED",Len(aSavaHeader[HEAD_NCS])))
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica numero de Ncs. da amostra ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nDelNco := Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,1])
						For nLoop3 := 1 To Len(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2]) // Numero de Ncs
							If !aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,nDelNco] .And.;
								!Empty(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,1]) .And.;
								QP215ChkGd(2,.F.,nOperacao,nFldLab,nLoop1,nLoop2,nLoop3,,.T.) // NC Nao Deletada
								
								lTemNConf:= .T. //Flag indicando que existe nao conformidade
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Utilizado para Plano de Amostragem Interno ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If cIntNor == "I"
									cClasse := Iif(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,4]=="A","1",;
									Iif(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,4]=="B","2",;
									Iif(aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,4]=="C","3","4")))
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Quantidade total das NCs utilizado para o tipo do pl. Amostragem ³
									//³ Generico                                                         ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo] == 1
										nTotGener1+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									EndIf
									nTotGener2+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									
									If cClasse == "1"
										If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo] == 1
											nCount11+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
										EndIf
										nCount12+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									ElseIf cClasse == "2"
										If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo] == 1
											nCount21+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
										EndIf
										nCount22+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									ElseIf cClasse == "3"
										If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo] == 1
											nCount31+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
										EndIf
										nCount32+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									ElseIf cClasse == "4"
										If aResultados[nOperacao,_MED,nFldLab,nLoop1,nLoop2,nAmo] == 1
											nCount41+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
										EndIf
										nCount42+=aResultados[nOperacao,_NCO,nFldLab,nLoop1,nLoop2,nLoop3,3]
									EndIf
								EndIf
							EndIf
						Next nLoop3
					EndIf
				EndIf
			Next nLoop2
			
			If cIntNor == 'I'	//Plano de Amostragem Interno
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe a 2amostragem, caso nao exista irah fazer a 1a. amostragem          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nC := 1 To Len(aPlInt1)
					If lSegAmost
						If aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSOBR] == "S" .Or. ( aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSOBR] == "N"  .And. aCtMED[nLoop1,1] <> 0) 	//Resultado Obrigatorio ou Ensaio Obrigatorio
							If aCtMED[nLoop1,1] <> aPlInt1[nC,4] .And. cEnsaio <> AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]) .And. !lAbandona
								If lExibeMsg .AND. qpAviso(STR0169,STR0170+cPlAmEns+STR0171+AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])+CHR(13)+"Número de Medições : " +Str(aCtMED[nLoop1,1])+" ==> Tamanho da Amostra : "+Str(aPlInt1[nC,4])+CHR(13)+"na primeira amostragem.",{"Continua","Abandona"}) == 2 //"Pl.Amostragem" #### "A quantidade de medições, é diferente do tamanho da Amostra definido no Plano de Amostragem : " #### ", no Ensaio : "
									lAprova	:= .F.
									lAbandona := .T.
									If lLayout
										aEnsaios[nOperacao,nFldLab,nLoop1,1] := hPd
									Else 
										If Len(aListEns) >= nLoop1
											aListEns[nLoop1,1] := hPd
										EndIf
									EndIf
									Exit
								Else
									cEnsaio := AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])
								EndIf
							EndIF
						EndIf
						
						If aPlInt1[nC,1] == "0"
							
							If nTotGener1 >= aPlInt1[nC,3]
								nCPlano := nTotGener1
								nPlano	:= aPlInt1[nC,3]
								lAprova := .F.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							Else
								If !Empty(cClasse)
									lNcok	:= .T.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
							
							//Verifica se irah pedir a 2a. amostragem.
							If nTotGener1 > aPlInt1[nC,2] .And. nTotGener1 < aPlInt1[nC,3]
								lSegunda := .T.
							EndIf
							
						ElseIf aPlInt1[nC,1] == "1"
							If nCount11 >= aPlInt1[nC,3]
								nCPlano := nCount11
								nPlano	:= aPlInt1[nC,3]
								lAprova := .F.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							Else
								If !Empty(cClasse)
									lNcok	:= .T.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
							
							//Verifica se irah pedir a 2a. amostragem.
							If nCount11 > aPlInt1[nC,2] .And. nCount11 < aPlInt1[nC,3]
								lSegunda := .T.
							EndIf
							
						ElseIf aPlInt1[nC,1] == "2"
							If nCount21 >= aPlInt1[nC,3]
								nCPlano := nCount21
								nPlano	:= aPlInt1[nC,3]
								lAprova := .F.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							Else
								If !Empty(cClasse)
									lNcok	:= .T.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
							
							//Verifica se irah pedir a 2a. amostragem.
							If nCount21 > aPlInt1[nC,2] .And. nCount21 < aPlInt1[nC,3]
								lSegunda := .T.
							EndIf
							
						ElseIf aPlInt1[nC,1] == "3"
							If nCount31 >= aPlInt1[nC,3]
								nCPlano := nCount31
								nPlano	:= aPlInt1[nC,3]
								lAprova := .F.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							Else
								If !Empty(cClasse)
									lNcok	:= .T.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
							
							//Verifica se irah pedir a 2a. amostragem.
							If nCount31 > aPlInt1[nC,2] .And. nCount31 < aPlInt1[nC,3]
								lSegunda := .T.
							EndIf
							
						ElseIf aPlInt1[nC,1] == "4"
							If nCount41 >= aPlInt1[nC,3]
								nCPlano := nCount41
								nPlano	:= aPlInt1[nC,3]
								lAprova := .F.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							Else
								If !Empty(cClasse)
									lNcok	:= .T.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
							
							//Verifica se irah pedir a 2a. amostragem.
							If nCount41 > aPlInt1[nC,2] .And. nCount41 < aPlInt1[nC,3]
								lSegunda := .T.
							EndIf
						EndIf
					EndIf
				Next nC
				cEnsaio := ''		//Limpa variavel para entrar na 1a. vez com mesmo ensaio.
				For nC := 1 To Len(aPlInt2)
					If 	cEnsaio <> AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]) .And. aCtMED[nLoop1,2] <> aPlInt2[nC,4] .And. !lAbandona
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³A variavel lSegunda darah a obrigatoriedade das Amostras na segunda amostragem.         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If lSegunda
							If lExibeMsg .AND. qpAviso(STR0107,STR0108+cPlAmEns+STR0109+AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])+CHR(13)+STR0110+Str(aCtMED[nLoop1,2])+STR0111+Str(aPlInt2[nC,4])+CHR(13)+STR0112,{STR0083}) == 1  //"Pl.Amostragem"##"A quantidade de medicöes, e diferente do tamanho da Amostra definido no Plano de Amostragem : "###", no Ensaio : "###"Numero de Medicöes : "###" ==> Tamanho da Amostra : "###"na segunda amostragem."###"Continua"
								lAprova  	:= .F.
								lAbandona   := .T.  
								cEnsaio		:= AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])
								Exit
							EndIf
						ElseIf aCtMED[nLoop1,2] <> 0
							If lExibeMsg .AND. qpAviso(STR0107,STR0108+cPlAmEns+STR0109+AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])+CHR(13)+STR0110 +Str(aCtMED[nLoop1,2])+STR0111+Str(aPlInt2[nC,4])+CHR(13)+STR0112,{STR0082,STR0083}) == 2	//"Pl.Amostragem"##"A quantidade de medicöes, e diferente do tamanho da Amostra definido no Plano de Amostragem : "###", no Ensaio : "###"Numero de Medicöes : "###" ==> Tamanho da Amostra : "###"na segunda amostragem."###"Continua"
								lAprova		:= .F.
								lAbandona	:= .T.
								Exit
							Else
								cEnsaio := AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])
							EndIf
						EndIf
					EndIf
					
					If aPlInt2[nC,1] == "0"
						If nTotGener2 >= aPlInt2[nC,3]
							nCPlano := nTotGener2
							nPlano	:= aPlInt2[nC,3]
							lAprova := .F.
							lSegAmost	:= .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						Else
							If !Empty(cClasse)
								lNcok	:= .T.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							EndIf
						EndIf
						
					ElseIf aPlInt2[nC,1] == "1"
						If nCount12 >= aPlInt2[nC,3]
							nCPlano := nCount12
							nPlano	:= aPlInt2[nC,3]
							lAprova := .F.
							lSegAmost	:= .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						Else
							If !Empty(cClasse)
								lNcok	:= .T.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							EndIf
						EndIf
					ElseIf aPlInt2[nC,1] == "2"
						If nCount22 >= aPlInt2[nC,3]
							nCPlano := nCount22
							nPlano	:= aPlInt2[nC,3]
							lAprova := .F.
							lSegAmost	:= .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						Else
							If !Empty(cClasse)
								lNcok	:= .T.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							EndIf
						EndIf
					ElseIf aPlInt2[nC,1] == "3"
						If nCount32 >= aPlInt2[nC,3]
							nCPlano := nCount32
							nPlano	:= aPlInt2[nC,3]
							lAprova := .F.
							lSegAmost	:= .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						Else
							If !Empty(cClasse)
								lNcok	:= .T.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							EndIf
						EndIf
					ElseIf aPlInt2[nC,1] == "4"
						If nCount42 >= aPlInt2[nC,3]
							nCPlano := nCount42
							nPlano	:= aPlInt2[nC,3]
							lAprova := .F.
							lSegAmost	:= .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						Else
							If !Empty(cClasse)
								lNcok	:= .T.
								lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
								//o controle neste momento deverah ser atraves do plano de amostragem
							EndIf
						EndIf
					EndIf
				Next nC
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso esteja reprovado no Plano de Amostragem³
				//³ Simples, nao faz checagem na Dupla          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
			ElseIf cIntNor == 'T'	//Plano de Amostragem TEXTO
				If aCtNc[nLoop1,1] <> 0 .Or. aCtNc[nLoop1,2] <> 0
					nCPlano	:= Iif(aCtNc[nLoop1,1]<>0,aCtNc[nLoop1,1],aCtNc[nLoop1,2])
					nPlano	:= 1
					lAprova := .F.
					lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
					//o controle neste momento deverah ser atraves do plano de amostragem
				EndIf
			ElseIf cIntNor $ "NßBßZ"   //Plano de Amostragem NBR5426, NBR5429 ou QS9000
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula o Indice de Defeito para o Plano de Amostragem NBR5429. ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
				
				aCtNCAcu   := QP215ACUPA(aCtNC, aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,1]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,2]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,3]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,4],nLoop1)
				aCtMEDAcu  := QP215ACUPA(aCtMED,aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,1]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,2]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,3]+;
				aResultados[nOperacao,_PLA,nFldLab,nLoop1,1,4],nLoop1)
				
				If cIntNor == "B" .And. Len(aMed5429) > 0
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Calcula os Limites: inferior e supeiror com a Tolerancia				³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Alltrim(cCarta) # "TXT"
						nLIETol := SuperVal(QP7->QP7_LIE)
						nLSETol := SuperVal(QP7->QP7_LSE)
					Else
						nLIETol := 0
						nLSETol := 0
					EndIf
					
					aCtNCAcu[aResultados[nOperacao,_MED,nFldLab,nLoop1,1,nAmo]] := QA_Def5429(aMed5429,nLIETol,nLSETol,cCodNorma,nTamAmo)[5]
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Compara o No. de NCs com o Aceite e Rejeite                               ³
				//³ Plano de Amostragem NBR5426 ou QS9000-Tbem chamado de Tabela Zero Defeito.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSOBR] == "S"	//Resultado Obrigatorio ou Ensaio Obrigatorio
					If aCtMEDAcu[1] < nTamAmo .And. cEnsaio <> AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]) .And. !lAbandona
						If lExibeMsg .AND. qpAviso(STR0107,STR0108+cPlAmEns+STR0109+AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])+CHR(13)+STR0110 +Str(aCtMEDAcu[1])+STR0111+Str(nTamAmo),{STR0082,STR0083}) == 2 //"Pl.Amostragem"##"A quantidade de medicöes, e diferente do tamanho da Amostra definido no Plano de Amostragem : "###", no Ensaio : "###"Numero de Medicöes : "###" ==> Tamanho da Amostra : "###"na segunda amostragem."###"Continua"
							lAprova	:= .F.
							lAbandona := .T.
							If lLayout
								aEnsaios[nOperacao,nFldLab,nLoop1,1] := hPd
							Else
								If Len(aListEns) >= nLoop1
									aListEns[nLoop1,1] := hPd
								EndIf
								cRet := hPd
							EndIf
							Exit
						Else
							If !lLayout
								cRet := hPd
							EndIf
							cEnsaio := AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])
						EndIf
					ElseIf !lLayout .AND. nPosE == nLoop1   
						lAnalisa := .F.
						Exit
					EndIf
				EndIf
				
				If !lAbandona
					//Amostragem Simples
					If Left(cAmost,1) <> "D"
						If aCtNCAcu[1] >= nRejeite
							nCPlano	:= aCtNCAcu[1]
							nPlano	:= nRejeite
							lAprova := .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
						EndIf
					Else
						If aCtNCAcu[1] >= nRejeite
							nCPlano	:= aCtNCAcu[1]
							nPlano	:= nRejeite
							lAprova := .F.
							lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
							//o controle neste momento deverah ser atraves do plano de amostragem
							
						Else
							If aCtMEDAcu[2] == 0
								If (aCtNCAcu[1] > nAceite .And. aCtNCAcu[1] < nRejeite)
									cMensagem := STR0113 + Alltrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO]) //"Ha necessidade de realizar uma Segunda Amostragem no Ensaio :"
									lAprova := .F.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
									lAbandona := .T.
									If lExibeMsg
										Messagedlg(cMensagem,,3) 
									EndIf
								EndIf
							Else
								If aCtNCAcu[1]+aCtNCAcu[2] >= nRejeite
									nCPlano	:= aCtNCAcu[1]+aCtNCAcu[2]
									nPlano	:= nRejeite
									lAprova := .F.
									lRepRes := .F.	//O flag neste momento eh passado como falso, pelo fato de que
									//o controle neste momento deverah ser atraves do plano de amostragem
								EndIf
							EndIf
						EndIf
					EndIF
				EndIf
			EndIf
			
			If !lAprova .And. !Empty(nCPlano) .And. !Empty(nPlano)
				cMensagem := STR0114+; //"Numero de Näo Conformidades do Ensaio : "
				AllTrim(aResultados[nOperacao,_ENS,nFldLab,nLoop1,ENSAIO])+ " ( " + AllTrim(Str(nCPlano)) + ;
				STR0115+AllTrim(Str(nPlano)) +;	//" ) e superior ou igual ao respectivo Rejeite ( "
				STR0116							//" )  . Laudo devera ser Reprovado."
				lGeralNc	:= .F.
				lMensNconf	:= .T.
				If lLayout
					aEnsaios[nOperacao,nFldLab,nLoop1,1] := hPd 
				Else
					If Len(aListEns) >= nLoop1
						aListEns[nLoop1,1] := hPd
					EndIf
				EndIf
				If lExibeMsg
					Messagedlg(cMensagem,,3) 
				EndIf
			EndIf
		EndIf
		
		//Se nao tem Nao conformidade informada e tem Resultado reprovado desativa o flag lGeralNC
		If !lTemNConf .And. lRepRes
			lGeralNc	:= .F.
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Reinicializa as variaveis para definicao    ³
		//³ de outro ensaio no Plano de Amostragem      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nCPlano		:= 0
		nPlano		:= 0
		nCount01	:= 0
		nCount02	:= 0
		nCount11	:= 0
		nCount12	:= 0
		nCount21	:= 0
		nCount22	:= 0
		nCount31	:= 0
		nCount32	:= 0
		nCount41	:= 0
		nCount42	:= 0
		nTotGener1	:= 0
		nTotGener2	:= 0
		lSegunda	:= .F.
		
	EndIf
Next nLoop1      
cMensagem:=""

//Caso nao tenha nenhuma nao conformidade e tenha medicao fora, ou seja, reprovado o flag fica Falso
If !lGeralNc
	lNcok := .F.
	If !lMensNconf                                                                      	
		cMensagem := STR0117 //"Existe Medicäo Reprovada. Laudo devera ser Rejeitado."
	EndIf
Else
	cMensagem := STR0118	//"Todas as medicöes säo Aprovadas. Laudo devera ser Aprovado."
	lNcok := .T.
EndIf

//Caso tenha nao conformidade e esteja dentro do Aceite de do Rejeite
//Verifica tbem se existe outro ensaio que esteja reprovado.
If lNcok
	If lRepRes
		lNcok := .F.
		cMensagem := STR0119	//"Existe Medicäo Reprovada. Laudo devera ser Rejeitado."
	EndIf
EndIf

Return({cMensagem,lNcok,lAbandona}) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP220RTxt   ³ Autor ³Marcelo Pimentel       ³ Data ³ 22/02/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Faz validacao do resultado quando o for ensaio TXT		    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ NIL										   				    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ EXPL1 = Resultado da Validacao.							    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215												        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215RTxt()
Local lLayout	  := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local cMediResu   := "" //M->QPQ_RESULT                  
Local n           := 0
Local nPosMed     := 0
Local cTxt		  := ""
Local lRet		  := .T.
Local nCins		  := 0  
Local cQPT_INSTR  := CriaVar("QPT_INSTR")
Local cQPT_REVINS := CriaVar("QPT_REVINS")
Local cQM2_VALDAF := CriaVar("QM2_VALDAF")
Local cQM2_TIPO	  := CriaVar("QM2_TIPO")
Local cQM2_REVTIP := CriaVar("QM6_REVTIP")     
Local nPosChv     := 0 
Local nSaveSX8    := GetSX8Len()
Local cChave	  := ''
Local cCarta	  := ''   
Local nPosGet     := 0

If lLayout
	nPosGet    := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT
	nPosMed    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"}) 
	nPosChv    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|AllTrim(x[2])=="QPR_CHAVE"})
	nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|AllTrim(x[2])=="QPQ_RESULT"})
	cTxt       := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAt,nPosMed]
	cMediResu  := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAt,nPosResult]
	cCarta 	   := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]
Else
	nOperacao  := nPosOper
	nFldLab    := nPosLab
	nEnsaio    := oBrwJJ:nAt
	nPosGet    := oGetMed:nAt
	nPosMed    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
	nPosChv    := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|AllTrim(x[2])=="QPR_CHAVE"})
	nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|AllTrim(x[2])=="QPQ_RESULT"})
	cTxt       := oGetMed:aCols[nPosGet,nPosMed]	  
	cMediResu  := oGetMed:aCols[nPosGet,nPosResult]
	cCarta 	   := aResultados[nOperacao,_ENS,nPosLab,nEnsaio,CARTA]
EndIf

If cCarta == "TXT"
	nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
Else
	nPosResult := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
EndIf

If Empty(cTxt)
	Help(" ",1,"QPH215063") //Não foi informado o texto para esse ensaio do tipo TXT.
	lRet := .F.
EndIf

If lRet
	If !Empty(cMediResu)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz atualizacao automatica dos instrumentos a partir do(s)  Instrumento(s) informado(s) ³
		//³ na primeira medicao.                                                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cMV_QPINAUT == "S"
			If nPosGet > 1                  
               
				If Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio]) < nPosGet
					While Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio]) < nPosGet
						Aadd(aResultados[nOperacao,_INS,nFldLab,nEnsaio],{})
					EndDo
				EndIf
				
				For nCIns := 1 To Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio,1])
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Faz a inclusao de nova linha no Instrumento       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet]) < nCIns
						Aadd(aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet],{cQPT_INSTR,cQPT_REVINS,cQM2_VALDAF,cQM2_TIPO,cQM2_REVTIP,"QPT",0,.F.})
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ No momento da inclusao verifica se o instrumento estah vazio ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lLayout
						If Empty(aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,1])
							aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,1]	:= aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,1]
							aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,2]	:= aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,2]
							aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,3]	:= aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,3]
							aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,4]	:= aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,4]
							aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,5]	:= aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,5]
							If aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns,Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns])]
								aResultados[nOperacao,_INS,nFldLab,nEnsaio,nPosGet,nCIns,Len(aResultados[nOperacao,_INS,nFldLab,nEnsaio,1,nCIns])] := .T.				
							EndIf
						EndIf
					Else 
						If Len(aResultados[nPosOper,_MED,nPosLab,oBrwJJ:nAT]) >= nPosGet .AND. Empty(AllTrim(aResultados[nPosOper,_MED,nPosLab,oBrwJJ:nAT,nPosGet,nPosChv]))
							cChave := QA_SXESXF("QPR","QPR_CHAVE",,4)
							While ( GetSX8Len() > nSaveSx8 )
								ConfirmSX8()
							EndDo
							aResultados[nPosOper,_MED,nPosLab,oBrwJJ:nAT,nPosGet,nPosChv] := cChave
							oGetMed:aCols[nPosGet,nPosChv] := cChave 
						EndIf
						If Empty(aResultados[nPosOper,_INS,nPosLab,oBrwJJ:nAT,nPosGet,nCIns,1])
							aResultados[nOperacao,_INS,nFldLab,oBrwJJ:nAT,nPosGet,nCIns]	:= aClone(aResultados[nOperacao,_INS,nFldLab,oBrwJJ:nAT,1,nCIns])
						EndIf					
					EndIf
					QP215AtuSta(nOperacao,nFldLab,nEnsaio,"","E",{_INS},.T.)
				Next nCIns
			EndIf
		EndIf
	EndIf
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215PotLot³ Autor ³ Cleber Souza			³ Data ³19/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Verifica a permissao para alteracao da potencia do lote     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ EXPC1 = Numero do Lote								      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL													      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215PotL(cLote)

Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lEncontrou := .F.
Local lInspecao  := GetMV("MV_QINSPEC",.T.,"1") == "2"
Local nPosLau    := 0

If lLayout
	nPosLau := QP215GetLau(aSavGets[nOperacao,1],"QPM_LAUDO") 
Else                                                                                                   
	nPosLau := QP215GetLau(aSavGets[1,1],"QPM_LAUDO")
EndIf
				
// Somente se ja efetuo o laudo e estiver na ultima operacao
cLote := Left(cLote, 10)

If lInspecao .AND. EMPTY(QPK->QPK_LOCAL) .AND. FieldPos("H6_LOCAL")==0    
 	// Aviso ao usurio  da  impossibilidade da alteracao da potencia do lote, peço para  criar o canpo H6_LOCAL 
 	MsgAlert(STR0224) //"Nao foi possivel alterar potencia de lote, devido a inexistencia  do campo H6_LOCAL, favor cria-lo!"
EndIf

If 	nPosLau > 0 .And. !Empty(aResultados[nOperacao,_LOP,nPosLau]) .And. nOperacao == (Len(aResultados)-1) .And.;
	PotencLote(QPK->QPK_PRODUT)
	SD5->(DbSetOrder(2))
 	SD5->(DbSeek(xFilial() + QPK->QPK_PRODUT + QPK->QPK_LOCAL + cLote))
 	While 	SD5->D5_FILIAL = xFilial("SD5") .And.;
 			SD5->D5_PRODUTO = QPK->QPK_PRODUT  .And.;
 			SD5->D5_LOCAL = QPK->QPK_LOCAL .And. SD5->D5_LOTECTL = cLote .And.;
 			! SD5->(Eof())
 		If	SD5->D5_OP = QPK->QPK_OP .And.;
 			SD5->D5_ESTORNO <> "S"
 			DbSelectArea("SB8")		// Seleciono para que xFilial retorne corretamente
			A390Poten("SD5",SD5->(Recno()),4)
			lEncontrou := .T.
			Exit			
		Endif
		SD5->(DbSkip())
	EndDo
	If ! lEncontrou
		Help(" ",1,"QPH215017") //O numero de op/Lote informados nao foram produzidos, favor verificar !
	Endif
Else
	Help(" ",1,"QPH215018")  //Nao e possivel alterar a potencia do lote ! Deve ser informado o lote e determinar o laudo da ultima operacao.
Endif

Return .T.   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ReNCo³ Autor ³ Cleber Souza          ³ Data ³ 19/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Calcula e exibe a reincidencia das NCs da OP      (posic.).³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 - Se .T. apenas verifica a existencia de NCs 		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ ExpL1 - .T. caso haja Nao Conformidades					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Siga Quality Celerina									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ReNCo(lCalcula)

Local lLayout     := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local nI
Local nDias
Local nPos
Local dDtLim
Local lRet		 := .F.
Local nRecQPK	 := QPK->(RecNo())
Local aVetNc	 := {}
Local aTabela	 := {}
Local cProd 	 := QPK->QPK_PRODUT
Local oDlgNc
Local oLbx
Local nOrdQPR	 := QPR->(IndexOrd())
Local nPosOpe	 := 0
Local nPosLab	 := 0
Local nPosEns	 := 0
Local nPosMed	 := 0
Local nPosNco	 := 0
Local nUsadoMed  := 0
Local nUsadoNco  := 0
Local oBmp
Local cRevi 	 := Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)

Default lCalcula := .F.

QPR->(dbSetOrder(1))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula data limite para selecionar as OP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nDias 	:= cMV_QDIREIN
dDtLim	:= QPK->QPK_EMISSA - nDias

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³									³
//³ Carrega array com as Ncos da OP ³
//³									³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPosOpe := 1 To nQtdOpe
	For nPosLab := 1 To Len(aResultados[nPosOpe,_LAB])
		For nPosEns := 1 To Len(aResultados[nPosOpe,_MED,nPosLab])
			For nPosMed := 1 To Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns])
				nUsadoMed := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed])
				If !aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nUsadoMed]	// Nao Deletado
					For nPosNco := 1 To Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed])
						nUsadoNco := Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco])
						If !aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nUsadoNco] .And.; // Nao Deletado
							!Empty(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1])
							nPos := Ascan(aVetNc,{ |x| x[1] == aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1] })
							If nPos == 0
								Aadd( aVetNc, { aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1], 0 } )
							Else
								aVetNc[nPos,2]++
							EndIf
						EndIf
					Next nPosNco
				EndIf
			Next nPosMed
		Next nPosEns
	Next nPosLab
Next nPosOpe 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se vetor com ncos esta vazio ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If len(aVetNC) > 0
	lRet := .T.
EndIf

If !lCalcula
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Volta OP no principal at‚ a Data Limite ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QPK->(dbSkip())
	While !QPK->(Eof()) .And. QPK->QPK_FILIAL == xFilial("QPK") .And. ;
			QPK->QPK_PRODUT == cProd
		If QPK->QPK_EMISSA < dDtLim
			Exit
		EndIf

		QPR->(dbSetOrder(6))
		If QPR->(dbSeek(xFilial("QPR")+QPK->QPK_PRODUT+cRevi+Dtos(QPK->QPK_EMISSA)))
			While !QPR->(Eof()) .And. QPR->QPR_FILIAL == xFilial("QPR") .And.;
				QPR->QPR_PRODUT+QPR->QPR_REVI+Dtos(QPR->QPR_DTENTR) ==;
				QPK->QPK_PRODUT+cRevi+Dtos(QPK->QPK_EMISSA)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria chave de ligacao da medicao com os outros arquivos ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cCHvMed := QPR->QPR_CHAVE
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se a medicao tem NC ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				QPU->(dbSeek(xFilial("QPU")+cChvMed))
				While !QPU->(eof()) .And. QPU->QPU_FILIAL == xFilial("QPU");
						.And. QPU->QPU_CODMED == cChvMed
					nPos := Ascan( aVetNc, { |x| x[1] == QPU->QPU_NAOCON })
					If nPos <> 0
						aVetNc[nPos][2]++
					EndIf
					QPU->(dbSkip())
				EndDo
				
				QPR->(dbSkip())
			EndDo
		EndIf
		QPK->(dbSkip())
	EndDo
	
	QPK->(dbGoto(nRecQPK))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena pela maior reincidencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aVetNc := Asort(aVetNc,,, { | x,y | x[2] > y[2] } )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exibicao das NC's com suas respectivas reincidencias ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to len(aVetNc)
		If aVetNc[nI][2] > 0 	// Tem reincidencia
			SAG->(dbSeek(xFilial("SAG")+aVetNc[nI][1]))
			Aadd( aTabela, { Padr(aVetNc[nI][1],12), SAG->AG_DESCPO, STR(aVetNc[nI][2]) }  )
		EndIf
	Next nI
	
	If len(aTabela) > 0
		DEFINE MSDIALOG oDlgNc FROM  63,4 TO 303,390 TITLE STR0120 PIXEL //"Näo Conformidade Reincidentes"
		
		oLbx := TWBrowse():New( 5, 4, 186, 98,{|| { " "," "," " }},;
			{TitSx3("QPU_NAOCON")[1],STR0121,STR0122},{80,150,40} ,oDlgNc, , , , , , , , , , , , , , .T., , , , , )	//"Descricäo"###"Reincidencia"
		
		oLbx:lMChange := .F. // Nao deixar mudar tamanho das colunas.
		oLbx:SetArray( aTabela )
		oLbx:bLine		:=	{ || {	aTabela[oLbx:nAT,1],;
			aTabela[oLbx:nAT,2],;
			aTabela[oLbx:nAT,3]	}}
		
		oLbx:nClrBackFocus := GetSysColor( 13 )
		oLbx:nClrForeFocus := GetSysColor( 14 )
		
		@ 136, 4 SAY "" SIZE 186,1 PIXEL OF oDlgNc BOX
		@ 107, 147 BUTTON STR0123 SIZE 44, 11 OF oDlgNc PIXEL ACTION oDlgNc:End()	//"<< &Voltar"
		ACTIVATE MSDIALOG oDlgNc CENTERED
	Else
		Help(" ",1,"QPH215064") //Não foram informadas Não Confomidades reincidentes
	EndIf
EndIf

QPR->(dbSetOrder(nOrdQPR))
Return lRet                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215BEnsa³ Autor ³ Cleber Souza          ³ Data ³19/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Todos os ensaios centralizados em um Browse				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1, ExpO2, ExpO3 - Handle dos pequenos bitmpas			  ³±±
±±³			 ³ 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³Nil 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215BEnsa(hOK,hNo,hRe)
Local oBrw
Local oDlgEns
Local aEns		:= {}
Local oBtn
Local oBtn1
Local oBmp
Local nPosOpe 	:= 0
Local nPosLab   := 0
Local nPosEns   := 0
Local aPesMed   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega array com as Ncos da OP ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPosOpe := 1 To nQtdOpe
	For nPosLab := 1 To Len(aResultados[nPosOpe,_LAB])
		For nPosEns := 1 To Len(aResultados[nPosOpe,_ENS,nPosLab])
			aPesMed := QP215Nume(nPosOpe,nPosLab,nPosEns)
		    AADD(aEns,{ IIF(aPesMed[1],IIF(aPesMed[2],"R","S"),""),;
						aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO],;
						QP215SkpT(aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]),;
						aResultados[nPosOpe,_OPE],;
						aResultados[nPosOpe,_LAB,nPosLab],;
						QP215RetEsp(aResultados[nPosOpe,_OPE],aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO],aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]),;
						QIPXDeEn(aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO]),;
						aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]})
		Next nPosEns
	Next nPosLab
Next nPosOpe 

If !Empty(aEns)
	DEFINE MSDIALOG oDlgEns FROM 10, 10 TO 230, 450 TITLE STR0172 PIXEL OF GetWndDefault() //"Ensaios" 
	
	oBrw := TWBrowse():New( 2, 05, 210, 83,{|| { " "," "," "," "," "," "," "," " }},;
		{"",STR0124,STR0125,STR0126,STR0127,STR0128,STR0129,STR0130},{15,80,60,80,80,80,200,30} , ; 
		oDlgEns, , , , , , , , , , , , , , .T., , , , , )	//"Ensaio"###"Skip Teste"###"Operacao"###"Laboratorio"###"Doc./Rev."###"Descricao"###"Carta"
	
	oBrw:lMChange := .F. // Nao deixar mudar tamanho das colunas.
	oBrw:nClrBackFocus := GetSysColor( 13 )
	oBrw:nClrForeFocus := GetSysColor( 14 )
	oBrw:SetArray( aEns )
	oBrw:bLine	:= { || { IiF(aEns[oBrw:nAt,1] == "S" ,hOk,Iif(aEns[oBrw:nAt,1] == "R",hNo,hRe)),aEns[oBrw:nAt,2],aEns[oBrw:nAt,3],aEns[oBrw:nAt,4],aEns[oBrw:nAt,5],aEns[oBrw:nAt,6],aEns[oBrw:nAt,7],aEns[oBrw:nAt,8] } }
	oBrw:bLDblClick := {|| oDlgEns:End()}
	
	@ 090, 2 SAY "" SIZE 218,1 PIXEL OF oDlgEns BOX
	@ 095, 111 BUTTON oBtn1 PROMPT STR0131 OF oDlgEns PIXEL ACTION QDOVIEW(,Substr(aEns[oBrw:nAt,6],1,16),Right(aEns[oBrw:nAt,6],3)) SIZE 35,11  //"&Documento"
	@ 095, 147 BUTTON oBtn1 PROMPT STR0132 OF oDlgEns PIXEL ACTION QA_Leg(oDlgEns) SIZE 35,11 //"&Legenda"
	@ 095, 183 BUTTON oBtn  PROMPT STR0133 OF oDlgEns PIXEL ACTION oDlgEns:End() SIZE 35,11	  //"&Voltar"
	
	ACTIVATE MSDIALOG oDlgEns CENTERED
Else
	MsgInfo(STR0173,STR0174) //"Não existem Ensaios" #### "Atenção"	 
Endif
Return Nil
                 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215Nume	³ Autor ³ Cleber Souza	 	    ³ Data ³19/12/03  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna se existe medicoes e NCO para o Ensaio informado    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Posicao da Operacao								  ³±±
±±³			 ³ExpC2 - Posicao do Laboratorio							  ³±±
±±³			 ³ExpC3 - Posicao do Ensaio 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExpA1	= Posicao 1 -> .T. Existe Medicoes					  ³±±
±±³			 ³       			   .F. Nao existe medicoes				  ³±±
±±³	 		 ³        Posicao 2 -> .T. Existe Nao Conformidade			  ³±±
±±³	 		 ³       			   .F. Nao exite Nao conformidade		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Nume(nPosOpe,nPosLab,nPosEns)

Local lMed		 := .F.	
Local lNco 		 := .F.	
Local nMed       := 0   
Local cCarta     := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]     
Local nPosResult := 0

If cCarta == "TXT"
	nPosResult := Ascan(aSavHeadEns[nPosOpe,nPosLab,nPosEns,1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
Else
	nPosResult := Ascan(aSavHeadEns[nPosOpe,nPosLab,nPosEns,1],{|x|Alltrim(x[2])=="QPR_RESULT"})
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se possui medicoes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns]) > 0
	For nMed:=1 to Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns]) 
		If !Empty(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nMed,nPosResult])	
			lMed := .T.
			EXIT
		EndIf
	Next nMed        
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se possui medicoes.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nMed:=1 to Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns]) 
	If Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nMed]) > 0
		If !Empty(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nMed,1,1])	
			lNco := .T.
			EXIT
		EndIf
	EndIf
Next nMed        
                
Return {lMed,lNco}

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215RetEsp³ Autor ³ Cleber Souza  	    ³ Data ³27/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna especificacao do ensaio / Metodo       			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Posicao da Operacao								  ³±±
±±³			 ³ExpC2 - Posicao do Ensaio									  ³±±
±±³			 ³ExpC3 - Carta do Ensaio 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpC1 - Metodo do Ensaio   								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215RetEsp(cOperacao,cEnsaio,cCartEns)
Local aArea		:=GetArea()
Local cRetorno	:=""
Local cRoteiro	:=Iif(Empty(cRoteiro),"01",cRoteiro)
Local cRevi		:=Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)

If cCartEns <> "TXT"
	QP7->(dbSetOrder(1))
	If QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOperacao+cEnsaio))
		If !Empty(QP7->QP7_METODO)
			cRetorno := QP7->QP7_METODO+" / "+QP7->QP7_RVDOC
		EndIf
	Endif
Else
	QP8->(dbSetOrder(1))
	If QP8->(dbSeek(xFilial("QP8")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOperacao+cEnsaio))
		If !Empty(QP8->QP8_METODO)
			cRetorno := QP8->QP8_METODO+" / "+QP8->QP8_RVDOC
		EndIf
	EndIf
EndIf
RestArea(aArea)

Return cRetorno  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215TP   ³ Autor ³ Cleber Souza          ³ Data ³ 20/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Retorna o tipo do produto,localizando primeiro no QE6 depois³±±
±±³Descri‡ao ³no SB1, caso nao encontre no QE6                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215TP(cVar)
Local cTipo := ''

QE6->(dbSetOrder(1))
If QE6->(dbSeek(xFilial("QE6")+cVar))
	cTipo := QE6->QE6_TIPO
Else
	SB1->(dbSelectArea(1))
	If SB1->(dbSeek(xFilial("SB1")+cVar))
		cTipo := SB1->B1_TIPO
	EndIf
EndIf
Return cTipo

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215SelG()³ Autor ³Cleber Souza		    ³ Data ³20/08/2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Seleciona as opcoes na atualizacao dos Resultados		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215SelG(EXPL1)			 				   			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPA1[1] = Certificado da Qualidade						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215SelG()                   
Local nTamChk := 029
Local lCheck1 := .F.
Local oDlgChk
Local oPanel
Local oBox1
Local oSay1

DEFINE MSDIALOG oDlgChk FROM 000,000 TO 150,300 TITLE OemToAnsi(STR0135) Pixel  //"Certificado de Qualidade"
@ 001,002 to 055,150  PIXEL                                    

@ 013,010 MSPANEL oPanel PROMPT "" SIZE 008,nTamChk OF oDlgChk
@ 10,001 CHECKBOX oBox1 VAR lCheck1 OF oPanel SIZE 150,11 PIXEL 
@ 24,025 SAY oSay1 PROMPT OemToAnsi(STR0079) OF oDlgChk;
	 SIZE 150,11 PIXEL COLOR CLR_BLUE                
	 
@ 058, 113 BUTTON OemToAnsi(STR0082) SIZE 035,015 OF oDlgChk PIXEL ACTION oDlgChk:End() 

ACTIVATE DIALOG oDlgChk CENTER
Return(lCheck1)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215Cli	³ Autor ³ Cleber Souza          ³ Data ³13/01/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela para informar o cliente                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Ordem de Producao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³QIPA215	                                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Cli()
Local oDlgClient
Local aFields   := {}
Local aSizes    := {} 
Local bBlock  
Local aClientes := {} 
Local oBrwCli
Local aButLoc   := {}
                        
//Posiciona Ordem de Producao
dbSelectArea("SC2")
dbSetOrder(1)
dbSeek(xFilial("SC2")+QPK->QPK_OP)

//Preenche os titulos dos campos			
aFields := {STR0136,STR0137,STR0138,STR0228} //"Cod. Cliente"###"Loja"###"Descricao do Cliente"###"Nome Reduzido"
                                      
//Preenche o tamanho dos campos								 
aSizes := {35, 10, 200}   

If ChkFile("QQ4")
	If !Empty(SC2->C2_PEDIDO)
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+SC2->C2_NUM))
			QQ4->(dbSetOrder(1))
			If QQ4->(dbSeek(xFilial("QQ4")+ QPK->QPK_PRODUT + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
				AADD(aClientes,{SC5->C5_CLIENTE,SC5->C5_LOJACLI,Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")})
			EndIf
		EndIf
	Else
		QQ4->(dbSetOrder(1))
		If QQ4->(dbSeek(xFilial("QQ4")+ QPK->QPK_PRODUT))
			While QQ4->(!EOF()) .and. QQ4->QQ4_PRODUTO == QPK->QPK_PRODUT
				AADD(aClientes,{QQ4->QQ4_CLIENT,QQ4->QQ4_LOJA,Posicione("SA1",1,xFilial("SA1")+QQ4->QQ4_CLIENT+QQ4->QQ4_LOJA,"A1_NOME"),Posicione("SA1",1,xFilial("SA1")+QQ4->QQ4_CLIENT+QQ4->QQ4_LOJA,"A1_NREDUZ")})
				QQ4->(dbSkip())
			EndDo
		EndIf
	EndIF
Else
	If !Empty(SC2->C2_PEDIDO)
		SC5->(dbSetOrder(1))
		If SC5->(dbSeek(xFilial("SC5")+SC2->C2_NUM))
			QQ7->(dbSetOrder(1))
			If QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT + SC5->C5_CLIENTE + SC5->C5_LOJACLI ))
				AADD(aClientes,{SC5->C5_CLIENTE,SC5->C5_LOJACLI,Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NOME"),Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_NREDUZ")})
			EndIf
		EndIf
	Else
		QQ7->(dbSetOrder(1))
		If QQ7->(dbSeek(xFilial("QQ7")+ QPK->QPK_PRODUT))
			While QQ7->(!EOF()) .and. QQ7->QQ7_PRODUTO == QPK->QPK_PRODUT
				If !Empty(QQ7->QQ7_MBROWS)
					AADD(aClientes,{QQ7->QQ7_CLIENT,QQ7->QQ7_LOJA,Posicione("SA1",1,xFilial("SA1")+QQ7->QQ7_CLIENT+QQ7->QQ7_LOJA,"A1_NOME"),Posicione("SA1",1,xFilial("SA1")+QQ7->QQ7_CLIENT+QQ7->QQ7_LOJA,"A1_NREDUZ")})
				EndIf
				QQ7->(dbSkip())
			EndDo
		EndIf
	EndIF
EndIF

If Len(aClientes) > 0
	bBlock:= {||Afill(Array(Len(aSizes))," ")}
	
	DEFINE MSDIALOG oDlgClient FROM	63,114 TO 300,900 TITLE STR0175 Of oMainWnd PIXEL //"Cliente"	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta o browse com as Operacoes           					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oBrwCli:= TwBrowse():New(1,0.49,385,100,bBlock,aFields,aSizes,oDlgClient)
	oBrwCli:SetArray(aClientes)
	oBrwCli:lMChange      := .F.
	oBrwCli:nClrBackFocus := GetSysColor(13)
	oBrwCli:nClrForeFocus := GetSysColor(14)
	oBrwCli:bLine :=   {||{aClientes[oBrwCli:nAt,1],aClientes[oBrwCli:nAt,2],aClientes[oBrwCli:nAt,3],aClientes[oBrwCli:nAt,4]}}
    
    AAdd(aButLoc,{"PESQUISA", { || QIP215LOC(oBrwCli,aClientes) } , OemToAnsi(STR0002) })//"Pesquisar"

	ACTIVATE MSDIALOG oDlgClient CENTERED ON INIT EnchoiceBar(oDlgClient,{||cIPClient:=aClientes[oBrwCli:nAt,1],cIPLoj:=aClientes[oBrwCli:nAt,2],oDlgClient:End()},{||oDlgClient:End()},,aButLoc)
EndIF

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QIP215LOC  ³ Autor ³ Leandro Sabino 		³ Data ³03/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Localizar o Nome do Cliente no oBrwCli					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³QIP215LOC						     						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³oBrwCli    = Browse com a amarracao Produto x Cliente		  ³±±
±±³          |aClientes  = Array com os dados do cliente 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QIP215LOC(oBrwCli,aClientes)
Local nReg := 0

Pergunte("QIA215",.T.)

For nReg:=1 to Len(aClientes)
	If mv_par01 == 01
		If Alltrim(aClientes[nReg,1])+Alltrim(aClientes[nReg,2]) == Alltrim(mv_par02)
			Exit
		Endif	
	ElseIf Alltrim(aClientes[nReg,4]) == Alltrim(mv_par02)
			Exit
	Endif	
Next

If nReg <= Len(aClientes) 
	oBrwCli:nAt:=nReg
	oBrwCli:Refresh()
	Eval(oBrwCli:bChange)
	cIPClient:= aClientes[oBrwCli:nAt,1]
	cIPLoj   := aClientes[oBrwCli:nAt,2]
Endif
	
Return() 

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ AjustaSX1  ³ Autor ³ Leandro de S. Sabino  ³ Data ³ 03/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Atualiza Arquivo de Perguntas                			    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AjustaSX1()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Void                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215				                 					    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1

Local cPerg := PadR("QIA215",10)

DbSelectArea("SX1")
dbSetOrder(1)
If ! ( SX1->(DbSeek(cPerg+"01")) )
	Reclock("SX1",.T.)
	SX1->X1_GRUPO  		:= cPerg
	SX1->X1_ORDEM  		:= "01"
	SX1->X1_PERGUNT		:= "Procurar por" 
	SX1->X1_PERSPA		:= "Buscar por "
	SX1->X1_PERENG		:= "Search"
	SX1->X1_VARIAVL 	:= "mv_ch1"
	SX1->X1_TIPO    	:= "C"
	SX1->X1_TAMANHO 	:= 20
	SX1->X1_DECIMAL 	:= 0
	SX1->X1_PRESEL  	:= 0
	SX1->X1_GSC     	:= "C"
	SX1->X1_VALID   	:= ""
	SX1->X1_VAR01   	:= "mv_par01"
	SX1->X1_DEF01   	:= "Codigo+Filial"
	SX1->X1_DEF02   	:= "Nome Reduzido"
	SX1->X1_DEFENG1		:= "Code+Branch"
	SX1->X1_DEFENG2		:= "Reduced name "
	SX1->X1_DEFSPA1		:= "Codigo+Sucursal"
	SX1->X1_DEFSPA2		:= "Nombre Reducido"
	MsUnlock()
Endif

If ! ( SX1->(DbSeek(cPerg+"02")) )
	Reclock("SX1",.T.)
	SX1->X1_GRUPO   	:= cPerg
	SX1->X1_ORDEM   	:= "02"
	SX1->X1_PERGUNT 	:= "Cliente"
	SX1->X1_PERSPA		:= "Cliente"
	SX1->X1_PERENG		:= "Customer"
	SX1->X1_VARIAVL 	:= "mv_ch2"
	SX1->X1_TIPO    	:= "C"
	SX1->X1_TAMANHO 	:= 40
	SX1->X1_DECIMAL 	:= 0
	SX1->X1_PRESEL  	:= 0
	SX1->X1_GSC     	:= "G"
	SX1->X1_VALID   	:= ""
	SX1->X1_VAR01   	:= "mv_par02"
	SX1->X1_DEF01   	:= ""
	SX1->X1_F3      	:= ""
	MsUnlock()
Endif

If SX1->(dbSeek(PadR("QIP215",10)+"01")) .And. Alltrim(SX1->X1_F3) <> "QQK04"
	Reclock("SX1",.F.)
	SX1->X1_F3 			:= "QQK04"
	MsUnlock()
Endif

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³A210Rastr ³ Autor ³ Marcelo Pimentel      ³ Data ³ 23/8/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Tela de rastreabilidade.                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpC1 - Ordem de Producao                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³A210Bar()                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Rastro(cOper)
LOCAL nCnt			:= 0
LOCAL aTam			:= {}
LOCAL nOpca			:= 0
LOCAL nC			:= 0
LOCAL lGravaOk		:= .T.
LOCAL cRevi			:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
LOCAL nBackUsado	:= nUsado				//Guarda nUsado anterior
LOCAL lEspec		:= .F.            		//Monta aCols baseado na Especificaco ou Resultado
LOCAL nOpcR         := 0
LOCAL aHeader       := aSavaHeader[HEAD_RASTRO]
LOCAL aCols         := {}
LOCAL nPosAli       := Ascan(aHeader,{|X| Upper(Alltrim(X[2])) $ "QQG_ALI_WT | QQ2_ALI_WT"})
LOCAL nPosRec       := Ascan(aHeader,{|X| Upper(Alltrim(X[2])) $ "QQG_REC_WT | QQ2_REC_WT"})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se ja existem Produtos Informados                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("QQG")
dbSetOrder(1)
dbSeek( xFilial("QQG")+QPK->QPK_OP+cOper)
nCnt := 0
While QQG->QQG_FILIAL   == xFilial("QQG") .and. ! QQG->(EOF()) .And. ;
	QQG->QQG_OP     == QPK->QPK_OP .And. ;
	QQG->QQG_OPERAC == cOper
	nCnt++
	dbSkip()
EndDo
	
If nCnt == 0
	dbSelectArea("QQ2")
	dbSetOrder(1)
	dbSeek( xFilial("QQ2")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper)
	nCnt := 0
	While !EOF().And. QQ2_FILIAL+QQ2_CODIGO== xFilial("QQ2")+QPK->QPK_PRODUT.And.;
		QQ2_REVI+QQ2_ROTEIR+QQ2_OPERAC	== cRevi+cRoteiro+cOper
		nCnt++
		dbSkip()
	EndDo
	lEspec := .T.
EndIf
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta vetor aCols com os Registros da Rastreabilidade     ³
//³ Cadastro anteriormente no cadastro de especificacao.         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lEspec
	nCnt := 0
	dbSelectArea("QQ2")
	dbSeek(xFilial("QQ2")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper)
	While !EOF().And.	QQ2_FILIAL+QQ2_CODIGO == xFilial("QQ2")+QPK->QPK_PRODUT.And.;
		QQ2_REVI+QQ2_ROTEIR+QQ2_OPERAC	 == cRevi+cRoteiro+cOper
		nCnt++
		nUsado:=0
	    aadd(aCols,Array(Len(aHeader)+1))
		dbSelectArea("SX3")
		dbSeek("QQ2")
		While !EOF() .And. x3_arquivo == "QQ2"
			IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .and. X3_PROPRI <> "U" .Or.;
				AllTrim(x3_campo) $ 'QQ2_ORIGEM.QQ2_LOTE.QQ2_LAUDO.QQ2_QTDE.QQ2_TIPO'
				nUsado++
				If x3_context # "V"
					aCOLS[nCnt,nUsado] := &("QQ2->"+x3_campo)
				ElseIF x3_context == "V"
					If Upper( Alltrim( x3_campo ) ) == "QQ2_TIPO"
						aCOLS[nCnt,nUsado] := QP215TP(QQ2->QQ2_CODIGO)
					Else
						aCOLS[nCnt,nUsado] := CriaVar(AllTrim(x3_campo))
					EndIf
				EndIf
			Endif
			dbSkip()
		Enddo
		If nPosAli > 0 .and. nPosRec > 0
			aCOLS[Len(aCOLS),nPosAli] := QQ2->(Alias())
			If IsHeadRec(aHeader[nPosRec,2])
				aCOLS[Len(aCOLS),nPosRec] := QQ2->(RecNo())
			EndIf
		Endif
		aCOLS[nCnt,Len(aHeader)+1] := .F.
		dbSelectArea("QQ2")
		dbSkip()
	Enddo
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta vetor aCols com os Registros da Rastreabilidade     ³
	//³ Ja informados (alteracao de resultados)                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nCnt := 0
	dbSelectArea("QQG")
	dbSetOrder(1)
	dbSeek( xFilial("QQG")+QPK->QPK_OP +cOper)
	While !Eof() .And. QQG_FILIAL   == xFilial("QQG") .And. ;
		QQG->QQG_OP     == QPK->QPK_OP .And. ;
		QQG->QQG_OPERAC == cOper
		nCnt++
		nUsado:=0
		aadd(aCols,Array(Len(aHeader)+1))
		dbSelectArea("SX3")
		dbSeek("QQG")
		While !EOF() .And. x3_arquivo == "QQG"
			IF X3USO(x3_usado) .AND. cNivel >= x3_nivel.Or.;
				AllTrim(x3_campo) $ 'QQG_ORIGEM.QQG_LOTE.QQG_LAUDO.QQG_QTDE.QQG_TIPO'
				nUsado++
				If x3_context # "V"
					aCOLS[nCnt,nUsado] := &("QQG->"+x3_campo)
				ElseIF x3_context == "V"
					If Upper( Alltrim( x3_campo ) ) == "QQG_DESC"
						aCOLS[nCnt,nUsado] := Capital(A010DProd(QQG->QQG_PRODUT))
					Else
						aCOLS[nCnt,nUsado] := CriaVar(AllTrim(x3_campo))
					EndIf
				EndIf
			Endif
			dbSkip()
		Enddo
		If nPosAli > 0 .and. nPosRec > 0
			aCOLS[Len(aCOLS),nPosAli] := QQG->(Alias())
			If IsHeadRec(aHeader[nPosRec,2])
				aCOLS[Len(aCOLS),nPosRec] := QQG->(RecNo())
			EndIf
		Endif
		aCOLS[nCnt,Len(aHeader)+1] := .F.
		dbSelectArea("QQG")
		dbSkip()
	Enddo
EndIf

	
If Len(aCols)==0
	aCols := aSavaCols[HEAD_RASTRO]
EndIf
	

Return(aCols)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215VPR  ³ Autor ³ CLEBER SOUZA          ³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Produto e atribuicao nos campos : Descricao e ³±±
±±³          ³ tipo do produto(pa,pi,mp...)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215	 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VPR()
LOCAL lRet     := .T.
LOCAL nPosDesc := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == "QQG_DESC"	} )
LOCAL nPosTipo := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == "QQG_TIPO"	} )
LOCAL cVar 	   := &(readvar()) //Conteudo da variavel do campo Produto
Local aCols    := oGetRast:aCols
Local n        := oGetRast:nAT

QP6->(dbSetOrder(1))
If !QP6->(dbSeek(xFilial("QP6")+cVar))
	QE6->(dbSetOrder(1))	
	If !QE6->(dbSeek(xFilial("QE6")+cVar))
		lRet := .F.
	Else
		aCols[n,nPosDesc] := QE6->QE6_DESCPO
		SB1->(dbSelectArea(1))
		If SB1->(dbSeek(xFilial("SB1")+cVar))
			aCols[n,nPosTipo] := SB1->B1_TIPO
		EndIf
	EndIf
Else
	aCols[n,nPosDesc] := QP6->QP6_DESCPO
	SB1->(dbSelectArea(1))
	If SB1->(dbSeek(xFilial("SB1")+cVar))
		aCols[n,nPosTipo] := SB1->B1_TIPO
	EndIf
EndIf

If !lRet
	Help(" ",1,"QPH215065") //O produto informado nÆo existe.
EndIf

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215VLR  ³ Autor ³ Cleber Souza          ³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Lote, checa o lote origem dependendo F3.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215	 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP215VLR()
LOCAL lRet		:= .T.
LOCAL nPosOrig	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_ORIGEM' })
LOCAL nPosLaudo	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LAUDO'	})
LOCAL nPosQuant	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_QTDE'	})
LOCAL nPosProd	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_PRODUT'	})   
LOCAL cVar		:= &(readvar()) 	//Conteudo da variavel do campo Lote
LOCAL aQEKArea	:= { 'QEK',QEK->(IndexOrd()),QEK->(Recno())	}
LOCAL aQPRArea	:= { 'QPR',QPR->(IndexOrd()),QPR->(Recno())	}
Local aCols    := oGetRast:aCols
Local n        := oGetRast:nAT

If !lMV_INTRAST
	Return(lRet)
EndIf

If aCols[n,nPosOrig] == "1"
	dbSelectArea('QEK')
	dbSetOrder(6)
	dbSeek(xFilial('QEK')+cVar)  
	
	While QEK->(!EOF()) .and. QEK->QEK_LOTE == cVar
		If QEK->QEK_PRODUT == aCols[n,nPosProd]                   
			Exit
	    EndIF
		QEK->(dbSkip())
	EndDo
	
	dbSelectArea('QEL')
	dbSetOrder(1)
	If !dbSeek( xFilial('QEL')+QEK->QEK_FORNEC+QEK->QEK_LOJFOR+QEK->QEK_PRODUT+;
		Dtos(QEK->QEK_DTENTR)+QEK->QEK_LOTE+Space(TamSX3("QEL_LABOR")[1]) )
		Help(" ",1,"QPH215066") //O lote informado não há laudo existente.
		lRet := .F.
	Else
		aCols[n,nPosLaudo]	:= QEL->QEL_LAUDO
		aCols[n,nPosQuant]	:= Val(TransForm(Val(QEL->QEL_TAMLOT),"@E 999,999.999999"))
	EndIf

	//-- Retorna a Integridade do Arquivo QEK
	dbSelectArea(aQEKArea[1]); dbSetOrder(aQEKArea[2]); dbGoto(aQEKArea[3])
Else
	dbSelectArea('QPR')
	dbSetOrder(7)
	dbSeek(xFilial('QPR')+cVar)
	
	dbSelectArea("QPL")
	dbSetOrder(3)
	If !dbSeek(xFilial("QPL")+QPR->QPR_OP+QPR->QPR_LOTE+QPR->QPR_NUMSER+cRoteiro+Space(02)+Space(TamSX3("QPL_LABOR")[1]) )
		Help(" ",1,"QPH215067") //O lote informado nÆo existe.
		lRet := .F.
	Else
		aCols[n,nPosLaudo]	:= QPL->QPL_LAUDO
		aCols[n,nPosQuant]	:= Val(TransForm(Val(QPL->QPL_TAMLOT),"@E 999,999.999999"))
	EndIf
	//-- Retorna a Integridade do Arquivo QPR
	dbSelectArea(aQPRArea[1]); dbSetOrder(aQPRArea[2]); dbGoto(aQPRArea[3])
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215VQR  ³ Autor ³ Cleber Souza          ³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao do Quantidade, checa a quantidade de acordo com  ³±±
±±³          ³ o Lote.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP215VQR()
LOCAL lRet		:= .T.
LOCAL nPosOrig	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_ORIGEM'	})
LOCAL nPosLote	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LOTE'	})
LOCAL aQEKArea	:= { 'QEK',QEK->(IndexOrd()),QEK->(Recno())	}
LOCAL aQPRArea	:= { 'QPR',QPR->(IndexOrd()),QPR->(Recno())	}
LOCAL nVar		:= &(readvar()) 	//Conteudo da variavel do campo Lote
Local aCols    := oGetRast:aCols
Local n        := oGetRast:nAT

If !lMV_INTRAST
	Return(lRet)
EndIf

If aCols[n,nPosOrig] == "1"
	dbSelectArea('QEK')
	dbSetOrder(6)
	dbSeek(xFilial('QEK')+aCols[n,nPosLote])
	If nVar > SuperVal(QEK->QEK_TAMLOT)
		Help(" ",1,"QPH215068") //A quantidade informada é maior que a quantidade especificada pelo lote.
		lRet := .F.
	EndIf
	//-- Retorna a Integridade do Arquivo QEK
	dbSelectArea(aQEKArea[1]); dbSetOrder(aQEKArea[2]); dbGoto(aQEKArea[3])
Else
	dbSelectArea('QPR')
	dbSetOrder(7)
	If dbSeek(xFilial('QPR')+aCols[n,nPosLote])
		dbSelectArea('SC2')
		dbSetOrder(1)
		dbSeek(xFilial('SC2')+QPR->QPR_OP)
		If nVar > SC2->C2_QUANT
			Help(" ",1,"QPH215068") //A quantidade informada é maior que a quantidade especificada pelo lote.
			lRet := .F.
		EndIf
	EndIf
	
	//-- Retorna a Integridade do Arquivo QPR
	dbSelectArea(aQPRArea[1]); dbSetOrder(aQPRArea[2]); dbGoto(aQPRArea[3])
EndIf
Return lRet  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215RLOK ³ Autor ³ Cleber Souza          ³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica se a linha digitada esta' Ok - Rastreabilidade     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215		       										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP215RLOK()
LOCAL lRet		:= .T.
LOCAL nC	    := 0 
Local aCols     := oGetRast:aCols
Local n         := oGetRast:nAT
LOCAL nPosProd	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_PRODUT'  } )
LOCAL nPosQtde	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_QTDE' 	} )
LOCAL nPosLote	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LOTE' 	} )
LOCAL nPosLau	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_LAUDO'	} )
LOCAL nPosOrig	:= Ascan(aSavaHeader[HEAD_RASTRO],{ |x| AllTrim(x[2]) == 'QQG_ORIGEM'	} )   
LOCAL cVarPrd	:= aCols[n,nPosProd]

If nopcx <> 2
	If !aCols[n,Len(aCols[n])] .and. !Empty(aCols[n,nPosProd])
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se o campo 'Produto','Quantidade','Lote'  estÆo     ³
		//³ preenchidos.                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If lMV_INTRAST
			If !Empty(aCols[n,nPosProd]) .And. ;
					(Empty(aCols[n,nPosQtde]) .Or. ;
					Empty(aCols[n,nPosLote]))
				Help(" ",1,"QPH215069") //Campos obrigatórios nÆo foram preenchidos.
				lRet := .F.
			EndIf
		Else 
			If !Empty(aCols[n,nPosProd]) .And. ;
					Empty(aCols[n,nPosLote])
				Help(" ",1,"QPH215069") //Campos obrigatórios nÆo foram preenchidos.
				lRet := .F.
			EndIf
		
		Endif
		
		If lRet
			If !Empty(aCols[n,nPosLau])
				If aCols[n,nPosOrig] == "1"
					dbSelectArea('QPD')
					If dbSeek(xFilial('QPD')+aCols[n,nPosLau])
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Parametro utilizado para indicar se poder  utilizar somente  ³
						//³ Laudo Aprovado Total (T) ou Laudo Aprovado Parcial (P)       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If	lRastTot
							If QPD->QPD_CATEG != '1'
								MessageDlg(STR0139,STR0093,2)	 //'O laudo informado esta fora das especificacöes. O laudo devera ser Aprovado Totalmente.'###"Verificar parametros referentes a integracäo com o QNC (Controle de Nao Conformidades"
								lRet := .F.
							EndIf
						Else
							If QPD->QPD_CATEG == '3'
								MessageDlg(STR0140,STR0093,2)	 //'O laudo informado esta fora das especificacöes.'###"Verificar parametros referentes a integracäo com o QNC (Controle de Nao Conformidades"	 
								lRet := .F.
							EndIf	
						EndIf
					EndIf
				Else
					dbSelectArea('QED')
					If dbSeek(xFilial('QED')+aCols[n,nPosLau])
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Parametro utilizado para indicar se poder  utilizar somente  ³
						//³ Laudo Aprovado Total (T) ou Laudo Aprovado Parcial (P)       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If	lRastTot
							If QED->QED_CATEG != '1'
								MessageDlg(STR0141,STR0093,2) //'O laudo informado esta fora das especificacöes. O laudo devera ser Aprovado Totalmente.'###"Verificar parametros referentes a integracäo com o QNC (Controle de Nao Conformidades"	 	 
								lRet := .F.
							EndIf
						Else
							If QED->QED_CATEG == '3'
								MessageDlg(STR0142,STR0093,2)	//'O laudo informado esta fora das especificacöes.'###"Verificar parametros referentes a integracäo com o QNC (Controle de Nao Conformidades"	 
								lRet := .F.
							EndIf	
						EndIf
					EndIf		
				EndIf		
			EndIf
		EndIf	
		
		If lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe o produto informado.                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nC := 1 To Len(aCols)
				If cVarPrd == aCols[nC,nPosProd].And. nC <> n .And. !aCols[nC,Len(aCols[n])] .And.;
					aCols[nC,nPosLote] == aCols[n,nPosLote]
					Help(" ",1,"QPH215070") // O produto informado já existe.	 
					lRet := .F.
					Exit
				EndIf                     
			Next
		EndIf
	Else
		lDelete := .T.	
	EndIf
Endif
Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215RTOK ³ Autor ³ Cleber Souza          ³ Data ³ 19/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Critica se toda a getdados esta' Ok - Rastreabilidade      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³QIPA215    												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP215RTOK()
Local lRet  := .T.
Local nI    := 0 
Local aCols := oGetRast:aCols

For nI := 1 to Len(aCols)
	If ! QP215RLOK()
		lRet := .F.
		Exit
	EndIf
Next

If !lRet
	oGetRast:oBrowse:SetFocus()
EndIf	

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³A210F3Rast³ Autor ³ Marcelo Pimetel       ³ Data ³02/09/1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta F3 para os Lotes filtrando pelo tipo do produto    ³±±
±±³			 ³Dependendo do tipo do produto "MP" -SigaQie "PI/PA" -SigaQip³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³.T. 			    										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Consulta SXB - QQ2										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215F3Rast()
LOCAL lRet		 := .T.
LOCAL nPosOrig	 := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_ORIGEM'})
Local aCols      := oGetRast:aCols
Local n          := oGetRast:nAT
PRIVATE nPosPrd	 := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_PRODUT'})

If aCols[n,nPosOrig] == "1"		//Serah utilizado a pesquisa no SIGAQIE
	lRet := Conpad1(,,,"QEL")
	cArq:="QEL"
Else
	lRet := Conpad1(,,,"QPL")	//Serah utilizado a pesquisa no SIGAQIP
	cArq:="QPL"
EndIf  

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³A210F3Esp ³ Autor ³ Marcelo Pimetel       ³ Data ³07/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta F3 para os Lotes filtrando pela Origem do Produto  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum 													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³.T. 			    										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Consulta SXB       										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215F3Esp()
LOCAL lRet		:= .T.
LOCAL nPosOrig	:= Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_ORIGEM'})
Local aCols     := oGetRast:aCols
Local n         := oGetRast:nAT

If aCols[n,nPosOrig] == "1"		//Serah utilizado a pesquisa no SIGAQIE
	lRet := Conpad1(,,,"QE6")
Else
	lRet := Conpad1(,,,"QP6")	//Serah utilizado a pesquisa no SIGAQIP
EndIf
Return lRet 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215F3I	³ Autor ³ Cleber Souza      	³ Data ³ 19/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta F3 para os instrumentos filtrando pela familia.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum 			    									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³.T. 														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Consulta SXB - QIT										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215F3I()
Local lRet := .T.
Local cTitulo	:= STR0143	//"Cadastro de Instrumentos"
Local aCampos	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ De acordo com os dados encontrados dispara uma consulta F3 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aCampos,{AllTrim(TitSX3("QM2_INSTR")[1]) ,"QM2_INSTR"})		//Instrumento
Aadd(aCampos,{AllTrim(TitSX3("QM2_REVINS")[1]),"QM2_REVINS"})		//Instrumento
Aadd(aCampos,{AllTrim(TitSX3("QM2_VALDAF")[1]),"QM2_VALDAF"})		//Validade Calibracao
Aadd(aCampos,{AllTrim(TitSX3("QM2_TIPO")[1])  ,"QM2_TIPO"})		//Familia
Aadd(aCampos,{AllTrim(TitSX3("QM6_REVTIP")[1]),"QM6_REVTIP"})		//Revisao da Familia

lRet := QP215ConPIn(cTitulo,"QM2",aCampos)

dbSelectArea("QQ1")
dbSetOrder(1)
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215ConPIn³ Autor ³ Cleber Souza         ³ Data ³19/01/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta Padrao Especifica - Instrumentos	    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215ConPIn( cTitulo, cAlias, aCampos )
Local oDlg
Local oBtn1
Local oBtn2
Local aListAux		:= {}
Local aHeaderEsp	:= {}
Local nOpc			:= 0
Local cConteudo		:= ''
Local nPos			:= 0
Local cRevi			:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI) 
Local lLayout	 := GetMv("MV_QPTRLAY",.F.,"1") == "1"
#IFDEF TOP
	Local cQuery		:= ''
	Local cProduto		:= QPK->QPK_PRODUT
	Local cRoteiro		:= ''
#ENDIF
	
Local nDtM			
Local cDatVal		:= ""
Local nPosInstEsp   := 0
Local nI            := 0      
Local cInstr
Local cRevIns

Private aListPad	:= {}
Private nReg		:= 0
Private oLBrowse

If !lLayout 
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := oBrwJJ:nAT
	nMedicao  := oGetMed:nAT
//	Q216ARESU()
EndIf

nDtM := Ascan(aSavHeadEns[nOperacao,nFldLab,nEnsaio,1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
                             
If Len(aResultados[nOperacao,4]) > 0
	cDatVal	:= Dtos(aResultados[nOperacao,_MED,nFldLab,nEnsaio,nMedicao,nDtM])
EndIf

cRoteiro := SC2->C2_ROTEIRO
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader especifico									     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aeval(aCampos,{|aElem|Aadd(aHeaderEsp,aElem[1])})
#IFDEF TOP
If TCSrvType() != "AS/400"
	aArea := GetArea()
	cQuery := "SELECT QQ1.QQ1_FILIAL,QQ1.QQ1_PRODUT,QQ1.QQ1_REVI,QQ1.QQ1_ROTEIR,QQ1.QQ1_OPERAC,QQ1.QQ1_ENSAIO,"
	cQuery += "QQ1.QQ1_INSTR,QM2.QM2_FILIAL, QM2.QM2_TIPO, QM2.QM2_INSTR, QM2.QM2_REVINS,QM2.QM2_LAUDO,"
	cQuery += "QM2.QM2_VALDAF,QM6.QM6_REVTIP, QM2.R_E_C_N_O_ QM2RECNO"
	cQuery += " FROM " + RetSqlName("QQ1")+" QQ1,"
	cQuery += RetSqlName("QM2")+" QM2 ,"
	cQuery += RetSqlName("QM6")+" QM6 "
	cQuery += "WHERE QQ1.QQ1_FILIAL='"+xFilial("QQ1")+"' AND "
	cQuery += "QQ1.QQ1_PRODUT = '"+cProduto+"' AND "
	cQuery += "QQ1.QQ1_REVI = '"+cRevi+"' AND "
	cQuery += "QQ1.QQ1_ROTEIR = '"+cRoteiro+"' AND "
	cQuery += "QQ1.QQ1_OPERAC = '"+aResultados[nOperacao,_OPE]+"' AND "
	cQuery += "QQ1.QQ1_ENSAIO = '"+aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]+"' AND "
	cQuery += "QQ1.D_E_L_E_T_<>'*' AND "
	cQuery += "QM2.QM2_FILIAL='"+xFilial("QM2")+"' AND "
	cQuery += "QM2.QM2_TIPO = QQ1.QQ1_INSTR	 AND "  
	cQuery += "QM6.QM6_INSTR = QM2.QM2_INSTR AND "
	cQuery += "QM6.QM6_REVINS = QM2.QM2_REVINS AND "	  
	
	If cMV_QPVLIN == "S"	//Validar instrumento ?
		cQuery += "QM2.QM2_LAUDO IN " + FormatIn(SuperGetMv("MV_QLINS"), "/") + " AND "
		cQuery += "QM2.QM2_VALDAF >= '"+cDatVal+"' AND "
	EndIf
	
	cQuery += "QM2.D_E_L_E_T_<>'*' AND "
	cQuery += "QM6.D_E_L_E_T_<>'*'"
	cQuery += " ORDER BY " + SqlOrder(QM2->(IndexKey()))
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),"QM2TMP", .F., .T.)
	
	TcSetField( "QM2TMP", "QM2_VALDAF", "D")

	dbSelectArea("QM2TMP")
	While !Eof()
		aListAux := {}
		For nI := 1 To Len(aCampos)
			cConteudo := QM2TMP->(FieldGet(FieldPos(aCampos[nI,2])))
			Aadd(aListAux,cConteudo)
		Next

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Jah estah posicionado no indice e irah atualizar somente o Instrumento na ultima revisao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cInstr <> QM2TMP->QM2_INSTR
			cInstr := QM2TMP->QM2_INSTR
			Aadd(aListAux, QM2RECNO)
			Aadd(aListPad,aListAux)
		EndIf
			
		dbSkip()
	EndDo
	dbSelectArea("QM2TMP")
	dbCloseArea()
	RestArea(aArea)
Else
#ENDIF
DbSelectArea("QQ1")
QQ1->(DbSetOrder(3))
If QQ1->(dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+cRevi+cRoteiro+aResultados[nOperacao,_OPE]+aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]))
	While !Eof() .And. xFilial("QQ1") == QQ1->QQ1_FILIAL .And. ;
		QQ1->QQ1_PRODUT	== QPK->QPK_PRODUT 	.And.;
		QQ1->QQ1_REVI	== cRevi				.And.;
		QQ1->QQ1_ROTEIR	== cRoteiro		.And.;
		QQ1->QQ1_OPERAC	== aResultados[Iif(lLayout,nOperacao,nPosOper),_OPE]	.And.;
		QQ1->QQ1_ENSAIO	== aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]
		dbSelectArea("QM2")
		dbSetOrder(2)
		If dbSeek(xFilial("QM2")+QQ1->QQ1_INSTR)
			While !Eof() .And. xFilial("QM2") == QM2->QM2_FILIAL .And. ;
				QM2->QM2_TIPO == QQ1->QQ1_INSTR
				If 	cMV_QPVLIN == "S" .And.;
					QM2->QM2_LAUDO $ FormatIn(SuperGetMv("MV_QLINS"), "/") .And.;
					Dtos(QM2->QM2_VALDAF) >= cDatVal
					
					//Verifica se instrumento possui calibracao.
					dbSelectArea("QM6")
					dbSetOrder(1)
					If dbSeek(xFilial("QM6")+QM2->QM2_INSTR+QM2->QM2_REVINS)
						dbSelectArea("QM2")
						aListAux := {}
						For nI := 1 To Len(aCampos)
							If Substr(aCampos[nI,2],1,3) == "QM6" 
								cConteudo := QM6->QM6_REVTIP
							Else
								cConteudo := FieldGet(FieldPos(aCampos[nI,2]))
							EndIF
							Aadd(aListAux,cConteudo)
						Next
						nPos := Ascan(aListPad,{|x| x[1] == QM2->QM2_INSTR } )
						If nPos == 0
							Aadd(aListAux, Recno())
							Aadd(aListPad,aListAux)
						EndIf
					EndIf
				Endif
				dbSkip()
			EndDo
		EndIf
		dbSelectArea("QQ1")
		DbSkip()
	EndDo
EndIf
DbGoTop()
#IFDEF TOP
Endif
#ENDIF

QQ1->(dbSetOrder(1))
QM2->(dbSetOrder(1))

If Len(aListPad) == 0
	Help(" ",1,"QPH215019") //"Não foram encontrados instrumentos!" / "Verifique se na especificação do produto, há Familia(s) informada(s) e se os instrumentos vinculados a familia são válidos."
	Return .F.
EndIf

DEFINE MSDIALOG oDlg TITLE STR0176+cTitulo From 9,0 To 21,60 OF oMainWnd  //"Consulta - "

oLBrowse:= TWBrowse():New( 0.4, 1, 182, 60,,aHeaderEsp,, oDlg,,,,,,,,,,,,.T.)

oLBrowse:SetArray(aListPad)
oLBrowse:bLine	:=	{ || {aListPad[oLBrowse:nAt,1],aListPad[oLBrowse:nAt,2],Dtoc(aListPad[oLBrowse:nAt,3]),aListPad[oLBrowse:nAt,4],aListPad[oLBrowse:nAt,5]}}
oLBrowse:bLDblClick := {||(nOpc := 1,cInstr:=aListPad[oLBrowse:nAt,1],cRevIns:=aListPad[oLBrowse:nAt,2],nReg:=aListPad[oLbrowse:nAt,Len(aListPad[1] ) ],oDlg:End())}
If !Empty(M->QPT_INSTR)
	nPosInstEsp := Ascan(aListPad,{|x| Left(x[1],Len(AllTrim(M->QPT_INSTR))) == AllTrim(M->QPT_INSTR) } )
	If nPosInstEsp > 0
		oLBrowse:nAt:=nPosInstEsp
		oLBrowse:Refresh()
	Endif
Endif

DEFINE SBUTTON oBtn1 FROM	4.0,200 TYPE	1	ACTION (nOpc := 1,cInstr:=aListPad[oLBrowse:nAt,1],cRevIns:=aListPad[oLBrowse:nAt,2],oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON oBtn2 FROM  18.5,200 TYPE	2	ACTION (nOpc := 0,oDlg:End())	ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona registro											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 1
	QM2->(DbSetOrder(1))
	QM2->(dbSeek(xFilial("QM2")+cInstr+Inverte(cRevIns)))
	
	QM6->(DbSetOrder(1))
	QM6->(dbSeek(xFilial("QM6")+cInstr+cRevIns))
EndIf
Return(nOpc == 1)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QIP215GCT ³ Autor ³ Cleber Souza          ³ Data ³ 20/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de geracao das Cartas de Controle				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SigaQIP													  ³±±
±±³			 ³ Obs.: Se nao especificar a revisao do produto, considera a ³±±
±±³			 ³ revisao vigente na data producao   limite (ate), para exi- ³±±
±±³			 ³ bir os ensaios para escolha e para identificar os Limites  ³±±
±±³			 ³ Engenharia. Neste caso (revisao em branco) serao conside-  ³±±
±±³			 ³ radas as medicoes de todas as revisoes que existirem no	  ³±±
±±³			 ³ periodo, mesmo que haja diferenca de especificacao do en-  ³±±
±±³			 ³ saio, de uma revisao para outra. 						  ³±±
±±³			 ³ Obs.: por enquanto, somente estao disponiveis os graficos  ³±±
±±³			 ³ 		das cartas IND, XBR e XBS. 							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

Function QIP215GCT()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis 											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cAlias := Alias()
Local cTit   := STR0144 //"Cartas de Controle"

PRIVATE cIndex1
PRIVATE nIndex,nOpt1 := 1
PRIVATE cMarca := GetMark()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva valores na array de Resultados.								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP215SavResu({SAV_MED,SAV_NCO,SAV_INS,SAV_CRO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecao da geracao das Cartas de Controle:					 ³
//³ mv_par01: Realizacao do Grafico? Todos / Atual               ³
//³ mv_par02: Data de Producao De  ?						     ³
//³ mv_par03: Data de Producao Ate'?                             ³
//³ mv_par04: Ensaiador 	   De  ?  							 ³
//³ mv_par05: Ensaiador 	   Ate'?                             ³
//³ mv_par06: Operacao 	De 		   ?			     			 ³
//³ mv_par07: Operacao Ate'        ?                			 ³
//³ mv_par08: Laboratorio De 	   ?			     			 ³
//³ mv_par09: Laboratorio Ate'     ?                			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("QPA220",.T.)
	mv_par05 := Iif(Empty(mv_par05),Replicate("Z",TamSx3("QPR_ENSR")[1]),mv_par05)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Funcao para montar o Browse para escolha dos ensaios  ³
	//³ e chamada da funcao para gerar os arquivos	                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP215MtBrw(QPK->QPK_REVI,cTit)
	
Endif 
dbSelectArea(cAlias)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QIP215GCT   ³ Autor ³ Cleber Souza        ³ Data ³ 20/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta browse para a escolha dos ensaios - MarkBrowse		  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP215MtBrw(ExpC1,ExpC2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Revisao											  ³±±
±±³			 ³ ExpC2 = Titulo da Janela									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215MtBrw(cRevi,cTit)

Local aStru		:= {}
Local nOpcA		:= 0
Local cArqTrab 	:= ''
Local aCpos		:= {}
Local cDir		:= ""
Local cReviAtu	:= 	Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local aQP7Area	:= { 'QP7',QP7->(IndexOrd()),QP7->(Recno())	}
Local aQPKArea	:= { 'QPK',QPK->(IndexOrd()),QPK->(Recno())}
Local oMark,oDlg  
Local nCount	:= 1
Local aEnsaios	:= {}
Local nPos		:= 0
Local aButtons	:= {}

Private lInverte:= .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho para a escolha dos ensaios ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "TB_OK"      ,	"C",02,0})
Aadd( aStru,{ "TB_ENSAIO"	,	"C",12,0})
Aadd( aStru,{ "TB_DESCRI"	,	"C",TamSX3("QP1_DESCPO")[1],0})
Aadd( aStru,{ "TB_CARTA"	,	"C",TamSX3("QP1_CARTA")[1],0})
Aadd( aStru,{ "TB_SELECAO"	,	"C",TamSX3("QP1_CARTA")[1],0})
Aadd( aStru,{ "TB_TAMAMO"	,  	"N",TamSX3("QP1_QTDE")[1],0})
Aadd( aStru,{ "TB_LABOR"	,	"C",TamSX3("QP7_LABOR")[1],0})
Aadd( aStru,{ "TB_OPERAC"	,  	"C",TamSX3("QP7_OPERAC")[1],0})

cArqTrab := CriaTrab(aStru)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"TB_ENSAIO",,,STR0177) //"Selecionando ensaios..."	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefinicao do aCpos para utilizar no MarkBrow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aCpos := {	{"TB_OK"		,"","  "},;
			{"TB_ENSAIO"	,"","Ensaio"},; 
			{"TB_DESCRI"	,"","Descrição"},; 
			{"TB_CARTA"		,"",AllTrim(TitSX3("QP1_CARTA")[1])},;
			{"TB_SELECAO"	,"","Selecao"},;	 
			{"TB_TAMAMO"	,"","Tamanho Amostra"},;	 
			{"TB_LABOR"		,"",AllTrim(TitSX3("QP7_LABOR")[1])},;
			{"TB_OPERAC"	,"",AllTrim(TitSX3("QP7_OPERAC")[1])}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta arquivo temporario com os ensaios dos Produtos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                   
QP7->(dbSetOrder(1))
QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cReviAtu))
While !QP7->(Eof()) .And. QP7->QP7_FILIAL == xFilial("QP7")	.And. ;
	QP7->QP7_PRODUT == QPK->QPK_PRODUT .And. QP7->QP7_REVI == cReviAtu
	
	//Filtra as Operacoes selecionadas
	If QP7->QP7_OPERAC < mv_par06 .Or. QP7->QP7_OPERAC > mv_par07
		QP7->(dbSkip())
		Loop
	EndIf
	
	//Filtra os Laboratorios selecionados	
	If QP7->QP7_LABOR < mv_par08 .Or. QP7->QP7_LABOR > mv_par09
		QP7->(dbSkip())
		Loop
	EndIf    
	
	//Verifica se possui medições cadastradas
	dbSelectArea("QPR")
	dbSetOrder(9)
	If !MsSeek(xFilial("QPR")+padr(QPK->QPK_OP,TamSX3("QPR_OP")[1])+QPK->QPK_LOTE+QPK->QPK_NUMSER+QP7->QP7_CODREC+QP7->QP7_OPERAC+QP7->QP7_LABOR+QP7->QP7_ENSAIO)
		QP7->(dbSkip())
		Loop
    EndIF
    
	// Verifica a Carta do Ensaio
	QP1->(dbSeek(xFilial("QP1")+QP7->QP7_ENSAIO))
	If QP1->QP1_CARTA $ "IND.XBR.XBS.HIS"
		If QPCarta(QP1->QP1_ENSAIO) <> "TMP"	
			RecLock("TRB",.T.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Vetor para efetuar a contagem dos ensaios sequencialmente        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nPos := Ascan(aEnsaios,{|x| x[1] == QP7->QP7_ENSAIO })
			If nPos <> 0
				aEnsaios[nPos,2]++
				nCount := aEnsaios[nPos,2]
			Else
				Aadd(aEnsaios,{QP7->QP7_ENSAIO,1})
			EndIf
			
			TRB->TB_ENSAIO := QP7->QP7_ENSAIO+"["+StrZero(nCount,2)+"]"
			TRB->TB_DESCRI := QIPXDeEn(QP7->QP7_ENSAIO)
			TRB->TB_CARTA	:= QP1->QP1_CARTA
			TRB->TB_LABOR	:= QP7->QP7_LABOR
			TRB->TB_OPERAC	:= QP7->QP7_OPERAC
		EndIf
	EndIf
	QP7->(dbSkip())
EndDo

dbSelectArea("TRB")
dbGoTop()
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
Else
	While .T.
		DEFINE MSDIALOG oDlg TITLE cTit From 9,0 To 30,76 OF oMainWnd
		oMark := MsSelect():New("TRB","TB_OK",,acpos,lInverte,cMarca,{20,7,151,293})
		oMark:oBrowse:lCanAllMark:=.T.
		oMark:oBrowse:lHasMark	 :=.T.
		oMark:bMark 			:= {|| QP215Esc(cMarca,lInverte,oDlg)}
		oMark:oBrowse:bAllMark	:= {|| QP215MrkA(cMarca,oDlg)}
		Aadd(aButtons,{"BMPPARAM",{||QPBuildGraf(Substr(TRB->TB_ENSAIO,1,8),TRB->TB_CARTA)},STR0145,STR0146}) //"Escolha da Carta de Controle..."###"Esc.Cart"	 

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()},,aButtons)
		If nOpcA == 1
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o diretorio do grafico e um  diretorio Local     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !QA_VerQDir(cMV_QDIRGRA) 
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Retorna a Integridade do Arquivo QP7³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(aQP7Area[1]); dbSetOrder(aQP7Area[2]); dbGoto(aQP7Area[3])
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Retorna a Integridade do Arquivo QPK³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(aQPKArea[1]); dbSetOrder(aQPKArea[2]); dbGoto(aQPKArea[3])

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Deleta Arquivo Temporario ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("TRB")
				dbClearFilter()
				dbCloseArea()
				Ferase(cArqTrab+GetDBExtension())
				FErase(cArqTrab+OrdBagExt())				
				
				Return   
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Obtem o diretorio para a criacao dos arquivos SPC ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cDir := cMV_QDIRGRA
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Rotina que gera os graficos ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			QP215GerCC(cReviAtu,cDir)
		Endif
		Exit
	EndDo
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a Integridade do Arquivo QP7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aQP7Area[1]); dbSetOrder(aQP7Area[2]); dbGoto(aQP7Area[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a Integridade do Arquivo QPK³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aQPKArea[1]); dbSetOrder(aQPKArea[2]); dbGoto(aQPKArea[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbClearFilter()
dbCloseArea()
Ferase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP220GerCC³ Autor ³ Marcelo Pimentel      ³ Data ³ 14/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera arquivo (SPC) para gerar o grafico					  ³±±
±±³			 ³ Gera 1 arquivo para cada ensaio selecionado				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ QP220GerCC(ExpC1,ExpC2)									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Revisao do Produto								  ³±±
±±³			 ³ ExpC2: Diretorio para a geracao dos arquivos SPC			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA220													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QP215GerCC(cRevi,cDir)

Local aEnsaios	:= {}
Local cOperac	:= ''
Local cLabor	:= ''
Local cAlias	:= Alias()
Local cChvMed	:= ''
Local nPos		:= 0
Local nI		:= 0
Local cCpo		:= ''
Local cEnsaio	:= ''
Local nQtde		:= 0
Local nQtdeOri	:= 0
Local cModelo	:= ''
Local nDec		:= 0
Local aMedicoes	:= {}
Local cArqTrab	:= ''
Local aStru		:= {}
Local cArqSPC	:= ""
Local cMedi		:= ""
Local lGera		:= .F.
Local aTabela	:= {}
Local nRecQPK	:= 0
Local cReviQPK	:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cRoteiro	:= Iif(Empty(cRoteiro),"01",cRoteiro)
Local nLoop		:= 0
Local nLoop2	:= 0
Local nDel		:= 0
Local cMedicao	:= ''
Local nC		:= 0
Local oDlg
Local oLbx
Local nDtm		:= 0
Local nHrM		:= 0
Local nAmo		:= 0
Local nEns		:= 0
Local nQtdMed	:= 0
Local nLoop3	:= 0
Local cCartEns	:= ''
Local aQP7Area	:= { 'QP7',QP7->(IndexOrd()),QP7->(Recno())	}
Local aQPKArea	:= { 'QPK',QPK->(IndexOrd()),QPK->(Recno())}
Local aQPRArea	:= { 'QPR',QPR->(IndexOrd()),QPR->(Recno())}
Local aPosEns	:= {}
Local nCountGrp	:= 0
Local cCartaOri	:= ""
Local cCarta	:= ""
Local nTamAmo	:= 0
Local nCnt      := 0
Local aOrdProd  := {}
Local aMed      := {}
Local nAmostra  := 0 
Local cIP210Pro := QPK->QPK_PRODUT
Local cIP210OP  := QPK->QPK_OP 
Local nMed      := 0 
Local aHeadEns  := {}
Local nQtdMax   := 0

dbSelectArea("TRB")
dbGoTop()
While !Eof()
	If !Empty(TB_OK)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ [1] - Ensaio                            ³
		//³ [2] - Tem Medicoes                      ³
		//³ [3] - Nome do Arquivo                   ³
		//³ [4] - Modelo                            ³
		//³ [5] - Laboratorio                       ³
		//³ [6] - Operacao                          ³
		//³ [7] - Carta                             ³
		//³ [8] - Carta Selecionada                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Aadd(aEnsaios,{ TB_ENSAIO,.F.,cArqSpc,"",TB_LABOR,TB_OPERAC,TB_CARTA,TB_SELECAO,TB_TAMAMO})
	EndIf
	dbSkip()
EndDo

//Pesquisa o Ensaio que possui maior numero de medições.
For nLoop := 1 to Len(aEnsaios)
	nQtdMax  := IIF(QP215QtdMed(aEnsaios[nLoop,1])>nQtdMax,QP215QtdMed(aEnsaios[nLoop,1]),nQtdMax)
Next nLoop	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho para guardar as meds. dos ensaios   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "TMP_ENSAIO"  ,  "C",12,0} )
Aadd( aStru,{ "TMP_OPERAC"	 ,	"C",2,0} )
Aadd( aStru,{ "TMP_LABOR"	 ,	"C",6,0} )
Aadd( aStru,{ "TMP_DTMEDI"  ,  "D",8,0} )
Aadd( aStru,{ "TMP_HRMEDI"  ,  "C",TamSx3("QPR_HRMEDI")[1],0} ) 

//Cria campo das medições
For nLoop:=1 to nQtdMax
	Aadd( aStru,{ "TMP_MEDI"+StrZero(nLoop,2)  ,  "C",8,0} )
Next nLoop

Aadd( aStru,{ "TMP_VERIFI"  ,  "C",1,0} )	//Verificador 
Aadd( aStru,{ "TMP_CARTA"	,  "C",3,0} )
Aadd( aStru,{ "TMP_CARTOR"	,  "C",3,0} )
Aadd( aStru,{ "TMP_TAMAMO"	,  "N",2,0} )

cArqTrab := CriaTrab(aStru)
dbUseArea(.T.,,cArqTrab,"TMP",.F.,.F.)
IndRegua("TMP",cArqTrab,"TMP_ENSAIO+DtoS(TMP_DTMEDI)+TMP_HRMEDI",,,STR0147) //"Indexando Arquivo..." 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona as producoes com medicoes no periodo.³
//³de acordo com a opcao de todos os resultados ou³
//³somente o Resultado em questao.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	nRecQPK := QPK->(Recno())
	QPK->(dbSetOrder(2))
	QPK->(dbSeek(xFilial("QPK")+cIP210Pro+dtos(mv_par02), .T.))
	While !QPK->(Eof()) .And. QPK->QPK_FILIAL == xFilial("QPK") .And. ;
		QPK->QPK_PRODUT == cIP210Pro .And. SC2->C2_EMISSAO >= mv_par02 .And.;
		SC2->C2_EMISSAO <= mv_par03

		QPR->(dbSetOrder(6))
		QPR->(dbSeek(xFilial("QPR")+QPK->QPK_PRODUT+cReviQPK+Dtos(SC2->C2_EMISSAO)))
		While !QPR->(Eof()) .And. QPR->QPR_FILIAL == xFilial("QPR") .And.;
			QPR->QPR_PRODUT+QPR->QPR_REVI+Dtos(QPR->QPR_DTENTR) ==;
			QPK->QPK_PRODUT+cReviQPK+Dtos(SC2->C2_EMISSAO)
			
			// Verifica Ordem de Producao
			If QPK->QPK_OP <> AllTrim(QPR->QPR_OP)
				QPR->(DbSkip())
				Loop
			EndIf
	
			// Verifica o Ensaiador
			If (!Empty(mv_par04) .And. QPR->QPR_ENSR < mv_par04) .Or. ;
				(!Empty(mv_par05) .And. QPR->QPR_ENSR > mv_par05)
	 			QPR->(dbSkip())
				Loop
			EndIf

			//Array utilizado na impressao do grafico
			If Ascan(aOrdProd, { |x| x[1] == QPK->QPK_OP}) == 0
				Aadd(aOrdProd,{QPK->QPK_OP,QPK->QPK_EMISSA,QPR->QPR_LOTE,QPK->QPK_TAMLOT})
			EndIf

			// Guarda as medicoes de acordo com o ensaio, se ele foi escolhido
			nPos := Ascan(aEnsaios, { |x| Substr(x[1],1,8) == QPR->QPR_ENSAIO})
			If nPos <> 0
				// Posiciona no arquivo de ensaios para saber a carta
				QP1->(dbSetOrder(1))
				QP1->(dbSeek(xFilial("QP1")+QPR->QPR_ENSAIO))
				cCartaOri	:= aEnsaios[nPos,7]
				cCarta		:= Iif(Empty(aEnsaios[nPos,8]),aEnsaios[nPos,7],aEnsaios[nPos,8])

				// Obtem a chave de ligacao da medicao com os outros arquivos
				cChvMed := QPR->QPR_CHAVE

				// Grava no arquivo auxiliar de medicoes
				RecLock("TMP", .T.)
				TMP->TMP_ENSAIO	:= QPR->QPR_ENSAIO
				TMP->TMP_OPERAC	:= QPR->QPR_OPERAC
				TMP->TMP_LABOR	:= QPR->QPR_LABOR
				TMP->TMP_DTMEDI	:= QPR->QPR_DTMEDI
				TMP->TMP_HRMEDI	:= QPR->QPR_HRMEDI
				TMP->TMP_CARTA	:= cCarta
				TMP->TMP_CARTOR	:= cCartaOri
				TMP->TMP_TAMAMO	:= aEnsaios[nPos,9]

				// Grava as medicoes
				nI := 1
				// Para cartas C e NP grava o Tamanho da Amostra antes de cada medicao
				If cCarta $ "C  .NP "
					TMP->TMP_MEDI01 := StrZero(QP1->QP1_QTDE,8)
					nI++
				EndIf

				QPS->(dbSetOrder(1))
				QPS->(dbSeek(xFilial("QPS")+cChvMed))
				While QPS->QPS_FILIAL+QPS->QPS_CODMED == xFilial("QPS")+cChvMed .And. !QPS->(Eof())
					cCpo := "TMP_MEDI"+StrZero(nI,2)
					TMP->&(cCpo) := QPS->QPS_MEDICA
					QPS->(dbSkip())
					nI++
				EndDo
			EndIf
			QPR->(dbSkip())
		EndDo
		QPK->(dbSkip())
	EndDo
	QPK->(dbGoto(nRecQPK))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a Integridade do Arquivo QPK³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aQPKArea[1]); dbSetOrder(aQPKArea[2]); dbGoto(aQPKArea[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso tenha esteja em ALTERACAO nao considerar os registros que estao gravados.³
//³devera atualizar o arquivo temporario atraves do Array aResultado             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 2

	//Array utilizado na impressao do grafico
	Aadd(aOrdProd,{AllTrim(cIP210OP),QPK->QPK_EMISSA,QPK->QPK_LOTE,QPK->QPK_TAMLOT})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao das medicoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nC := 1 To Len(aEnsaios)
		aPosEns := QP215PosRes(aEnsaios[nC,6],aEnsaios[nC,5],Substr(aEnsaios[nC,1],1,8))
		
		If aPosEns[1] <> 0	
			cEnsaio  :=Substr(aEnsaios[nC,1],1,8)
			cOperac	 :=aEnsaios[nC,6]
			cLabor	 :=aEnsaios[nC,5]  
			aHeadEns := aSavHeadEns[aPosEns[1],aPosEns[2],aPosEns[3]]
			If Alltrim(aEnsaios[nC,6]) == "TXT"	                                                
				nMed     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
			Else
				nMed     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
			EndIf

			For nLoop2 := 1 To Len(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3]]) // Numero de medicoes
				nDel := Len(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2]) // numero de colunas
				cMedicao := Iif(Valtype(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nMed])=="N",Str(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nMed]),aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nMed])
				If !aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nDel] .And. !Empty(cMedicao)	// Medicao Nao deletada e em branco
				
					If Alltrim(aEnsaios[nC,7]) <> "TMP"
						
						nDtM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
						nHrM	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})
						nAmo	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_AMOSTR"})
						cChvMed	:=	Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_CHAVE"}) 
						cCarta	:= Iif(Empty(aEnsaios[nC,8]),aEnsaios[nC,7],aEnsaios[nC,8]) 
						
						//Posiciona na Base de Dados dos Ensaios.6
						QP1->(dbSetOrder(1))
						QP1->(dbSeek(xFilial("QP1")+Substr(aEnsaios[nC,1],1,8)))
		
						// Grava no arquivo auxiliar de medicoes
						RecLock("TMP", .T.)
						TMP->TMP_ENSAIO	:= cEnsaio
						TMP->TMP_OPERAC	:= cOperac
						TMP->TMP_LABOR	:= cLabor
						TMP->TMP_DTMEDI := aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nDtM]
						TMP->TMP_HRMEDI := aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,nHrM]
						TMP->TMP_CARTA	:= cCarta
						TMP->TMP_CARTOR	:= aEnsaios[nC,7]
						TMP->TMP_TAMAMO	:= aEnsaios[nC,9]
		
						// Grava as medicoes
						nI := 1
						// Para cartas C e NP grava o Tamanho da Amostra antes de cada medicao
						If cCarta $ "C  .NP "
							TMP->TMP_MEDI01 := StrZero(QP1->QP1_QTDE,8)
							nI++
						EndIf
		
						nQtdMed := QP215QtdMed(cEnsaio)
						For nLoop3 := 1 To nQtdMed
							cCpo := "TMP_MEDI"+StrZero(nLoop3,2)
							If Alltrim(aEnsaios[nC,6]) <> "P  "
								TMP->&(cCpo) := Iif(Valtype(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,(nMed+nLoop3)-1])=='N',StrTran(Str(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,(nMed+nLoop3)-1]),".",","),aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,(nMed+nLoop3)-1])
							Else
								If nLoop3 == 4
									TMP->&(cCpo) := StrTran(Str(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,(nMed+nLoop3)-1],TamSx3("QPS_MEDICA")[1],2),".",",")
								Else
									TMP->&(cCpo) := Str(aResultados[aPosEns[1],_MED,aPosEns[2],aPosEns[3],nLoop2,(nMed+nLoop3)-1],TamSx3("QPS_MEDICA")[1])
								EndIf
							Endif
						Next nLoop3
					EndIf
				EndIf	
			Next nLoop2
		EndIf
	Next nC
EndIf	

nCnt:= 0
// Gera os arquivos de grafico
TMP->(dbGoTop())
While !TMP->(Eof())
	If 	TMP->TMP_VERIFI	==	"1"
		TMP->(dbSkip())
		Loop
	EndIf

	Aadd(aMed,{})
	nCnt++

	cEnsaio := Substr(TMP->TMP_ENSAIO,1,8)
	cOperac	:= TMP->TMP_OPERAC
	cLabor	:= TMP->TMP_LABOR
	QP1->(dbSetOrder(1))
	QP1->(dbSeek(xFilial("QP1")+cEnsaio))
	cCarta		:= TMP->TMP_CARTA
	cCartaOri	:= TMP->TMP_CARTOR

	// Define o modelo do grafico e a qtde de medicoes
	// Modelo 5: IND (IndMovRng), 6: XBR (XbarRange), 7:XBS (XbarStd)
	nQtde := QP1->QP1_QTDE	// Tamanho da Amostra

	Do Case
	Case TMP->TMP_CARTA == 'XBR'
		cModelo := "6"
	Case TMP->TMP_CARTA == 'XBS'
		cModelo := "7"
	Case TMP->TMP_CARTA == 'IND'
		cModelo := "5"
		If cCarta == cCartaOri
			nQtde := 1
		EndIf
	Case TMP->TMP_CARTA == 'HIS'
		cModelo := "5"
	EndCase
	nQtdeOri	:= nQtde
	nTamAmo	    := TMP->TMP_TAMAMO

	// Identifica o no. de casas decimais
	QP7->(dbSetOrder(1))
	QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cReviQPK+cRoteiro+cOperac+cEnsaio))
	nDec := QA_NumDec(QP7->QP7_NOMINA)

	// Monta vetor com os valores das medicoes e checa as menores/maiores datas
	aMedicoes := {}
	Aadd(aMedicoes,"QACHART.DLL - NORMAL")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Indica se os Limites serao recalculados na Carta de Controle					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMV_QCALLIM
		Aadd(aMedicoes,"[CALCULA LIMITE]")
		Aadd(aMedicoes,"FALSE")	

		//Grava L.S.C.
		Aadd( aMedicoes,"[USL]" )
		Aadd( aMedicoes,StrTran(Str(SuperVal(If(!Empty(QP7->QP7_LSC),QP7->QP7_LSC,QP7->QP7_LSE)),8,nDec),".",",") )
		
		//Grava o L.I.C.
		Aadd( aMedicoes,"[LSL]" )
		Aadd( aMedicoes,StrTran(Str(SuperVal(If(!Empty(QP7->QP7_LIC),QP7->QP7_LIC,QP7->QP7_LIE)),8,nDec),".",",") )
		
	Else
		//Grava L.S.E.
		Aadd( aMedicoes,"[USL]" )
		Aadd( aMedicoes,StrTran(Str(SuperVal(QP7->QP7_LSE),8,nDec),".",",") )
		
		//Grava o L.I.E.
		Aadd( aMedicoes,"[LSL]" )
		Aadd( aMedicoes,StrTran(Str(SuperVal(QP7->QP7_LIE),8,nDec),".",",") )

    EndIf
	
	//Grava o Valor Nominal
	Aadd( aMedicoes,"[TARGET]" )
	Aadd( aMedicoes,StrTran(Str(SuperVal(QP7->QP7_NOMINA),8,nDec),".",",") )

	//Se existir Ponto de OP, o mesmo retorna o Texto do titulo.
	aAdd( aMedicoes,"[TITLE]" )
	If ExistBlock("QPGCCT") 
		aAdd( aMedicoes,ExecBlock("QPGCCT",.F.,.F.) )
	Else
		aAdd( aMedicoes," - " + AllTrim(QP7->QP7_PRODUT) + " / " + QP7->QP7_REVI)
 	EndIF       

	//Se existir Ponto de OP, o mesmo retorna o Texto do rodape.
	aAdd( aMedicoes,"[FOOT]" )
	If ExistBlock("QPGCCF") 
		aAdd( aMedicoes,ExecBlock("QPGCCF",.F.,.F.) )
	Else
		aAdd( aMedicoes,OemToansi(STR0178) + ": " + AllTrim(QP1->QP1_ENSAIO) + " - " + QP1->QP1_DESCPO)  //"Ensaio"
    EndIf

	Aadd(aMedicoes,"[INICIO DE DADOS]")
	nRecno := TMP->(Recno())
	nAmostra:= 0
	While !TMP->(Eof()).And.Substr(TMP->TMP_ENSAIO,1,8) == cEnsaio .And. ;
		cOperac == TMP->TMP_OPERAC .And. cLabor == TMP->TMP_LABOR
		If 	TMP->TMP_VERIFI	==	"1"
			TMP->(dbSkip())
			Loop
		EndIf
		RecLock("TMP", .F.)
		TMP->TMP_VERIFI	:= "1"
		MsUnlock()

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Efetua controle caso haja troca da Carta de Controle para visualizacao do Grafico³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If TMP->TMP_CARTA <> TMP->TMP_CARTOR
			If TMP->TMP_CARTOR == "IND"
				nQtde := 1
				nCountGrp:= 0
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta vetor com os valores das medicoes ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cMedi:=	StrZero(Day(TMP->TMP_DTMEDI),2)+"/"+;
				StrZero(Month(TMP->TMP_DTMEDI),2)+"/"+Str(Year(TMP->TMP_DTMEDI),4)+;
				Substr(TMP->TMP_HRMEDI,1,3)+StrZero(nCountGrp,2)

		Aadd(aMed[nCnt],{})
		nAmostra++
		For nLoop := 1 to nQtde
			cCpo := "TMP_MEDI"+StrZero(nLoop,2)
			cMedicao := cMedi+StrTran(AllTrim(TMP->&cCpo),".",",")
			Aadd(aMedicoes,cMedicao)
			Aadd(aMed[nCnt,nAmostra],StrTran(AllTrim(TMP->&cCpo),".",","))
		Next

		TMP->(dbSkip())
	EndDo
	Aadd(aMedicoes,"[FIM DE DADOS]")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reavalia o Tamanho da Amostra caso seja alterada a carta.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cCarta <> cCartaOri
		nQtde := Iif(nTamAmo>0,nTamAmo,1)
	EndIf  

	If TMP->TMP_CARTOR == "IND"
		nQtde := Len(aMed[Len(aMed)])
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o tamanho do sub-grupo ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aMedicoes,"[SUBGRUPO]")
	Aadd(aMedicoes,Str(nQtde,4))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o ensaio apresenta mais de 2 sub-grupos de medicoes,³
	//³ necessarios para a geracao dos graficos.                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If Len(aMedicoes) > 5	// Header, Linha de Inicio e Fim de Dados

		nPos := Ascan(aEnsaios, { |x| 	Substr(x[1],1,8) == cEnsaio .And. ;
										x[5] == cLabor .And. x[6] == cOperac	 })
										
		If nPos <> 0
			// Atualiza aEnsaios indicando que tem medicoes suficientes p/ o grafico
			aEnsaios[nPos][2] := .T.
			
			// Identifica o modelo do grafico
			aEnsaios[nPos][4] := cModelo
		EndIf

		// Gera o nome do arquivo SPC
		cArqSPC := QP215NoArq(cDir)

		If !Empty(cArqSPC)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o arquivo SPC ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lGera := QP215GerAr(aMedicoes ,cArqSPC, cDir)
			If !lGera
				Exit
			EndIf
		
			// Atualiza o nome do arquivo SPC gerado no array de ensaios
			If nPos <> 0
				aEnsaios[nPos][3] := cArqSpc
			EndIf
		EndIf
	EndIf
EndDo

If lGera
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega array para o ListBox somente os que estao marcados ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nLoop := 1 to Len(aEnsaios)
		If aEnsaios[nLoop][2]
			Aadd( aTabela, {aEnsaios[nLoop][1], aEnsaios[nLoop][3], aEnsaios[nLoop][4],aEnsaios[nLoop][5], cIp210Pro, cReviQPK, aOrdProd, aMed[nLoop] } )
		EndIf
	Next nLoop
	
	If Len(aTabela) > 0
		
		DEFINE MSDIALOG oDlg FROM	18,16 TO 246,561 TITLE STR0148 PIXEL   //"Dados gerados"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Controle para abertura do grafico. Caso o grafico fique aberto por mais de 3 minutos ³
		//³ nao perca a conexao.																 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		PtInternal(9,"FALSE")
		
		@ 0.3,0.3 LISTBOX oLbx FIELDS HEADER TitSX3("QP1_ENSAIO")[1] ,STR0179;//"Arquivo"
		SIZE 225,100 OF oDlg
		
		oLbx:blDblClick:= {|| Calldll32("ShowChart",aTabela[oLbx:nAt,2],aTabela[oLbx:nAt,3],cDir,NORMAL,Iif(!Empty(cSenha),Encript(Alltrim(cSenha),0),"PADRAO")),A020StBtn(cDir,oBtn1,oBtn2)}
		oLbx:SetArray( aTabela )
		oLbx:bLine := { || {aTabela[oLbx:nAT,1],aTabela[oLbx:nAT,2]} }
		
		DEFINE SBUTTON FROM 005, 228 TYPE 1 ENABLE OF oDlg Action (Calldll32("ShowChart",aTabela[oLbx:nAt,2],aTabela[oLbx:nAt,3],cDir,NORMAL,Iif(!Empty(cSenha),Encript(Alltrim(cSenha),0),"PADRAO")),A020StBtn(cDir,oBtn1,oBtn2))
		DEFINE SBUTTON FROM 018, 228 TYPE 2 ENABLE OF oDlg Action oDlg:End()
		
		@ 031,228 BUTTON oBtn1 PROMPT OemToAnsi(STR0180) OF oDlg PIXEL SIZE 45,13 ;//"Impr. Histograma"
		ACTION Q215Impri (1,aTabela[oLbx:nAt]) // QIPR170
		
		@ 044,228 BUTTON oBtn2 PROMPT OemToAnsi(STR0181) OF oDlg PIXEL SIZE 45,13 ; //"Impr. Carta Crtl"
		ACTION Q215Impri (2,aTabela[oLbx:nAt]) // QIPR170
		
		oBtn1:lReadOnly := .F.
		oBtn2:lReadOnly := .F.
		
		ACTIVATE MSDIALOG oDlg CENTERED
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Exclui os arquivos (SPC) gerados agora ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		A020DelSpc( cDir, aTabela )
		PtInternal(9,"TRUE")
	Else
		MessageDlg(STR0182,,3)  //"Não há ensaios com medições suficientes para gerar o gráfico."
	Endif
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a Integridade do Arquivo QP7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aQP7Area[1]); dbSetOrder(aQP7Area[2]); dbGoto(aQP7Area[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna a Integridade do Arquivo QPR³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(aQPRArea[1]); dbSetOrder(aQPRArea[2]); dbGoto(aQPRArea[3])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta o arquivo auxiliar ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TMP")
dbClearFilter()
dbCloseArea()
Ferase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())
dbSelectArea(cAlias)
Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP220GerAr³ Autor ³ Fernando Godoy		³ Data ³12/22/1998³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Grava um arquivo Txt no formato da OCX QC_CHART		      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1 - Array com os dados a gravar						  ³±±
±±³			 ³ExpC1 - Arquivo para dados								  ³±±
±±³			 ³ExpC2 - Diretorio para gerar o arquivo					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ExpL1 - TRUE - caso criou o arquivo corretamente e FALSE	  ³±±
±±³			 ³ caso tenha havido alguma falha							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215GerAr( aDados , cFile , cDir )
Local lOk		:= .T.
Local nHandle	:= 0
Local nSec		:= 0

Default cFile	:= "QACHART.SPC"
Default aDados	:= { }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Formato do array a ser passado		    ³
//³ Array de uma coluna contendo uma string ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If File( cDir+cFile )
	If FErase(cDir+cFile) == 0
		lOk := .T.
	else
		nSec := Seconds()
		While FErase(cDir+cFile) <> 0
			if Seconds() > nSec + 5
				lOk := .F.
				Exit
			Endif
		EndDo
		if !lOk
			MsgStop(STR0183,STR0184)	//"Outro usuário utilizando o arquivo. Tente novamente" #### "Atenção"
		Endif
	Endif
Endif

If lOk
	IF (nHandle := FCREATE(cDir+cFile, FC_NORMAL)) == -1
		lOk := .F.
		MsgStop(STR0185 + cDir+cFile,STR0186) //"Não foi possível criar o arquivo para o gráfico " #### "Atenção" 
	Endif
Endif

If lOk
	aEval( aDados, { |cTexto,nX| FWrite( nHandle, cTexto + Chr(13)+Chr(10) ), Len(cTexto) } )
	FClose(nHandle)
Endif
Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ QP220Esc   ³ Autor ³ Marcelo Pimentel    ³ Data ³ 14/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Escolhe os Ensaios										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA220											    	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Esc(cMarca,lInverte,oDlg)
iF IsMark("TB_OK",cMarca,lInverte)
	RecLock("TRB",.F.)
	If !lInverte
		TRB->TB_OK	:= cMarca
	Else
		TRB->TB_OK	:= "  "
	Endif
	MsUnlock()
Else
	RecLock("TRB",.F.)
	If !lInverte
		TRB->TB_OK	:= "  "
	Else
		TRB->TB_OK	:= cMarca
	Endif
	MsUnlock()
Endif
oDlg:Refresh()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215MrkA   ³ Autor ³Cleber Souza 		³ Data ³ 14/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte os Ensaios Marcados/Desmarcados					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215MrkA(cMarca,oDlg)
Local nRecno:=Recno()
dbGotop()
Do While !Eof()
	RecLock("TRB",.F.)
	If Empty(TRB->TB_OK)
		TRB->TB_OK	:= cMarca
	Else
		TRB->TB_OK	:= "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPBuildGraf ³ Autor ³Marcelo Pimentel       ³ Data ³ 13/09/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza o acols NConformidade no vetor corretamente         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Cadastro de Resultados								        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QPBuildGraf(cEnsaio,cCarta)
Local oDlgGrf
Local oPanel
Local oRadio
Local nRadio
Local oTamAmo
Local cRadCarta	:= "INDXBRXBS"
Local nOpca		:= 0
Local nTamAmo	:= CriaVar("QP1_QTDE",.F.)

cRadCarta	:= StrTran(cRadCarta,cCarta,"")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o Tamanho da Amostra com 5      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTamAmo := Iif(Substr(cRadCarta,1,3) == "IND",1,5)

DEFINE MSDIALOG oDlgGrf TITLE STR0187 From 19,0 To 31.5,46 OF oMainWnd	//"Selecao da Carta de Controle"  

@ 21,02 SAY cEnsaio SIZE 40,7 OF oDlgGrf PIXEL COLOR CLR_BLUE
@ 21,50 SAY cCarta  SIZE 20,7 OF oDlgGrf PIXEL COLOR CLR_BLUE
oPanel	:= 	TPanel():New(35,2,,oDlgGrf,,,,,,179,58,.F.,.F.)

@ 7,2 SAY STR0188 SIZE 150,7 OF oPanel PIXEL COLOR CLR_BLUE	 //'Selecione o tipo do grafico:'
@ 17,80 Radio oRadio VAR nRadio ITEMS Substr(cRadCarta,1,3),Substr(cRadCarta,4,6) 3D ;
ON CLICK QPChgRadio(nRadio,cRadCarta,@nTamAmo,@oTamAmo)  SIZE 50,10 OF oPanel PIXEL

@ 42,2	SAY STR0189 SIZE 80, 7 OF oPanel PIXEL COLOR CLR_BLUE //"Tamanho das Amostras:"	
@ 40,80	MSGET oTamAmo VAR nTamAmo	PICTURE "99" Valid QPVldTam(nTamAmo) SIZE 20, 9 OF oPanel PIXEL
oTamAmo:cSX1Hlp := "QP1_QTDE"

ACTIVATE MSDIALOG oDlgGrf CENTERED ON INIT EnchoiceBar(oDlgGrf,{||nOpcA:=1,oDlgGrf:End()},{||nOpca:=0,oDlgGrf:End()})
If nOpca == 1
	RecLock("TRB",.F.)
	TRB->TB_SELECAO	:= Iif(nRadio==1,Substr(cRadCarta,1,3),Substr(cRadCarta,4,6))
	TRB->TB_TAMAMO	:= nTamAmo
	MsUnlock()
EndIf

Return(.T.)      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Microsiga           º Data ³  01/20/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215PosRes(cOpe,cLab,cEns)

Local nPosOpe  := 0
Local nPosLab  := 0
Local nPosEns  := 0
Local lAOpe    := .F.
Local lALab    := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa a posicao da Operacao.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPosOpe:=1 to nQtdOpe
	If aResultados[nPosOpe,_OPE] == cOpe
		lAOpe := .T.
		For nPosLab:=1 to Len(aResultados[nPosOpe,_LAB])
			If aResultados[nPosOpe,_LAB,nPosLab] == cLab
				For nPosEns:=1 to Len(aResultados[nPosOpe,_ENS,nPosLab])
					If aResultados[nPosOpe,_ENS,nPosLab,nPosEns,ENSAIO] == cEns
						lALab := .T.
						Exit
					EndIf		
				Next nPosEns	    
		    EndIf
        	If lALab
        		Exit
        	EndIF	
    	Next nPosLab	
    EndIf
	If lAOpe
		Exit
	EndIF	
Next nPosOpe

Return({nPosOpe,nPosLab,nPosEns})  

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP220NoArq³ Autor ³ Marcelo Pimentel      ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera nome do arquivo SPC									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA220													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QP215NoArq(cDir)
Local cArq	:= ""
Local nI 	:= 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o arquivo disponivel com extensao SPC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nI := 1 to 99999
	cArq := "QIP" + StrZero(nI,5) + ".SPC"
	If !File(Alltrim(cDir)+cArq)
		Exit
	EndIf
Next nI
Return cArq   

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QIP220GDP ³ Autor ³ Marcelo Pimentel      ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa de geracao do Diagrama de Pareto                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaQIP                                                    ³±±
±±³          ³ Obs.: Se nao especificar a revisao do produto, considera a ³±±
±±³          ³ revisao vigente na data producao   limite (ate), para exi- ³±±
±±³          ³ bir os ensaios para escolha e para identificar os Limites  ³±±
±±³          ³ Engenharia. Neste caso (revisao em branco) serao conside-  ³±±
±±³          ³ radas as medicoes de todas as revisoes que existirem no    ³±±
±±³          ³ periodo, mesmo que haja diferenca de especificacao do en-  ³±±
±±³          ³ saio, de uma revisao para outra.                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QIP215GDP()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cAlias	:= Alias()
Local cRevi		:= If(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cTit		:= STR0190 //"Diagrama de Pareto" 
Local lCont		:= .T.
Local cArqTrab	:= ''
Local lBrwEns	:= .F.

PRIVATE cIndex1
PRIVATE nIndex,nOpt1 := 1
PRIVATE cMarca := GetMark() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva valores na array de Resultados.								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP215SavResu({SAV_MED,SAV_NCO,SAV_INS,SAV_CRO})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Selecao da geracao da Diagrama de Pareto					 ³
//³ mv_par01: Realizacao do Grafico? (Todos/Atual)               ³
//³ mv_par02: Data de Producao De  ?							 ³
//³ mv_par03: Data de Producao Ate'?                             ³
//³ mv_par04: Ensaiador 	   De  ?   							 ³
//³ mv_par05: Ensaiador 	   Ate'?                             ³
//³ mv_par06: Operacao 	De 		   ?			     			 ³
//³ mv_par07: Operacao Ate'        ?                			 ³
//³ mv_par08: Laboratorio De 	   ?			     			 ³
//³ mv_par09: Laboratorio Ate'     ?                			 ³
//³ mv_par10: Exibe a coluna Outros? (Sim/Nao)          		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Pergunte("QPA221",.T.)

	mv_par05 := Iif(Empty(mv_par05),Replicate("Z",TamSx3("QPR_ENSR")[1]),mv_par05)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Funcao para montar o Browse para escolha dos ensaios  ³
	//³ e chamada da funcao para gerar os arquivos	                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lCont := QP215BrwEns(cRevi,cTit,@cArqTrab)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chamada da Funcao para montar o Browse para escolha das Classes NC  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCont
		QP215BrwCla(cRevi,cTit,lBrwEns)
	EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario Classes de NC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Select("TRB") > 0
	dbSelectArea("TRB")
	dbClearFilter()
	dbCloseArea()
	Ferase(cArqTrab+GetDBExtension())
	Ferase(cArqTrab+OrdBagExt())
EndIf

dbSelectArea(cAlias)
Return NIL                                        

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QP220BrwEns³ Autor ³ Marcelo Pimentel    ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta browse para a escolha dos ensaios - MarkBrowse       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP220BrwEns(ExpC1,ExpC2,ExpC3)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Revisao                                            ³±±
±±³          ³ ExpC2 = Titulo da Janela                                   ³±±
±±³          ³ ExpC3 = Arquivo temporario ensaios (a ser criado - @)      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ QIPA220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QP215BrwEns(cRevi,cTit,cArqTrab)
Local aStru		:= {}
Local nOpcA		:= 0
Local lRetu		:= .T.
Local aCpos		:= {}
Local cEnsNew	:= ''
Local cEnsBack	:= ''   
Local cReviAtu	:= 	QA_UltRvQ(QPK->QPK_PRODUT)
	
Local oMark,oDlg
Private lInverte:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "TB_OK"   	,"C",02,0} )
Aadd( aStru,{ "TB_ENSAIO"	,"C",TamSX3("QP7_ENSAIO")[1],0})
Aadd( aStru,{ "TB_DESCRI"  ,"C",TamSX3("QP1_DESCPO")[1],0})

cArqTrab := CriaTrab(aStru)
dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrab,"TB_ENSAIO",,,STR0191) //"Selecionando Ensaios..."    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefinicao do acpos para utilizar no MarkBrow               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
acpos := {	{"TB_OK"		,"","  "},;
			{"TB_ENSAIO"	,"","Ensaio"},;	 
			{"TB_DESCRI"	,"","Descrição"}}	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta arquivo temporario dos Ensaios Mensuraveis          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+cReviAtu))
While !QP7->(Eof()) .And. QP7->QP7_FILIAL == xFilial("QP7");
	.And. QP7->QP7_PRODUT == QPK->QPK_PRODUT .And. QP7->QP7_REVI == cReviAtu
	                       
    //Verifica as Operacoes selecionadas 
	If	QP7->QP7_OPERAC < mv_par06 .Or. QP7->QP7_OPERAC > mv_par07
		QP7->(dbSkip())
		Loop
	EndIf	

	//Verifica os Laboratorios selecionados	
	If QP7->QP7_LABOR  < mv_par08 .Or. QP7->QP7_LABOR  > mv_par09
		QP7->(dbSkip())
		Loop
	EndIF
	
	cEnsNew := 	AllTrim(QP7->QP7_ENSAIO)
	If Alltrim(cEnsNew) $ Alltrim(cEnsBack)
		QP7->(dbSkip())
		Loop
	EndIf
	cEnsBack += Alltrim(QP7->QP7_ENSAIO)+' '
		
	RecLock("TRB",.T.)
	TRB->TB_ENSAIO	:= QP7->QP7_ENSAIO
	TRB->TB_DESCRI	:= QIPXDeEn(QP7->QP7_ENSAIO)
	QP7->(dbSkip())
EndDo

cEnsBack:= ''
cEnsNew	:= ''
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta arquivo temporario dos Ensaios Textos               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QP8->(dbSeek(xFilial("QP8")+QPK->QPK_PRODUT+cReviAtu))
While !QP8->(Eof()) .And. QP8->QP8_FILIAL == xFilial("QP8");
	.And. QP8->QP8_PRODUT == QPK->QPK_PRODUT .And. QP8->QP8_REVI == cReviAtu

    //Verifica as Operacoes selecionadas 
	If	QP8->QP8_OPERAC < mv_par06 .Or. QP8->QP8_OPERAC > mv_par07
		QP8->(dbSkip())
		Loop
	EndIf	

	//Verifica os Laboratorios selecionados	
	If QP8->QP8_LABOR  < mv_par08 .Or. QP8->QP8_LABOR  > mv_par09
		QP8->(dbSkip())
		Loop
	EndIF

	cEnsNew := 	AllTrim(QP8->QP8_ENSAIO)
	If Alltrim(cEnsNew) $ Alltrim(cEnsBack)
		QP8->(dbSkip())
		Loop
	EndIf
	cEnsBack += Alltrim(QP8->QP8_ENSAIO)+' '
	
	RecLock("TRB",.T.)
	TRB->TB_ENSAIO	:= QP8->QP8_ENSAIO
	TRB->TB_DESCRI	:= QIPXDeEn(QP8->QP8_ENSAIO)
	QP8->(dbSkip())
EndDo

dbSelectArea("TRB")
dbGoTop()
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
Else
	While .T.                         
		DEFINE MSDIALOG oDlg TITLE cTit From 9,0 To 30,70 OF oMainWnd
		oMark := MsSelect():New("TRB","TB_OK",,acpos,lInverte,cMarca,{20,7,151,270})
		oMark:oBrowse:lCanAllMark	:=.T.
		oMark:oBrowse:lHasMark		:=.T.
		oMark:bMark					:= {| | QP215Esc(cMarca,lInverte,oDlg)}
		oMark:oBrowse:bAllMark		:= {| | QP215MrkA(cMarca,oDlg)}
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})
		If nOpcA <> 1
			lRetu := .F.
		Endif
		Exit
	EndDo
EndIf

Return(lRetu)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QP220BrwCla³ Autor ³ Marcelo Pimentel    ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta browse para a escolha das Classes de NC - MarkBrowse ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP220BrwCla(ExpC1,ExpC2,ExpL1)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Revisao                                            ³±±
±±³          ³ ExpC2 = Titulo da Janela                                   ³±±
±±³          ³ ExpL1 = Indica se montou o Browse para escolha dos ensaios ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ QIPA220                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QP215BrwCla(cRevi,cTit,lBrwEns)

Local aStru		:= {}
Local nOpcA		:= 0
Local cArqTrb1	:= ''
Local acpos		:= {}
Local cDir		:= ""
Local oMark, oDlg
Private lInverte:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd( aStru,{ "TB_OK"   	, 	"C",02,0} )
Aadd( aStru,{ "TB_CLASSE"	,	"C",TamSX3("QEE_CLASSE")[1],0} )
Aadd( aStru,{ "TB_DESCRI"  ,  "C",TamSX3("QEE_DESCPO")[1],0} )

cArqTrb1 := CriaTrab(aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
IndRegua("TRB1",cArqTrb1,"TB_CLASSE",,,"Indexando Arquivo...") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Redefinicao do acpos para utilizar no MarkBrow               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
acpos := {	{"TB_OK"		,"","  "		},;
			{"TB_CLASSE"	,"","Classe NC"},;	 
			{"TB_DESCRI"	,"","Descrição"}}	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Alimenta arquivo temporario das Classes de Nao Conformidade  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
QEE->(dbSeek(xFilial("QEE")))
While !QEE->(Eof()) .And. QEE->QEE_FILIAL == xFilial("QEE")
	RecLock("TRB1",.T.)
	TRB1->TB_CLASSE	:= QEE->QEE_CLASSE
	TRB1->TB_DESCRI	:= QEE->QEE_DESCPO
	QEE->(dbSkip())
EndDo

dbSelectArea("TRB1")
dbGoTop()
If BOF() .and. EOF()
	HELP(" ",1,"RECNO")
Else
	While .T.
		DEFINE MSDIALOG oDlg TITLE cTit From 9,0 To 23,68 OF oMainWnd
		oMark := MsSelect():New("TRB1","TB_OK",,acpos,lInverte,cMarca,{20,4,100,265})
		oMark:oBrowse:lCanAllMark:=.T.
		oMark:oBrowse:lHasMark	 :=.T.
		oMark:bMark 			:= {| | QP215EsCNC(cMarca,lInverte,oDlg)}
		oMark:oBrowse:bAllMark	:= {| | QP215M1All(cMarca,oDlg)}
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,oDlg:End()},{||nOpcA:=0,oDlg:End()})
		Exit
	EndDo
EndIf

If nOpca == 1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Obtem o diretorio para a criacao dos arquivos de graficos (SPC) ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDir := cMV_QDIRGRA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o diretorio do grafico e um  diretorio Local     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !QA_VerQDir(cMV_QDIRGRA)  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Deleta Arquivo Temporario Classes de NC ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("TRB1")
		dbClearFilter()
		dbCloseArea()
		Ferase(cArqTrb1+GetDBExtension())
		Ferase(cArqTrb1+OrdBagExt())
		Return   
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Chama a rotina que gera o Grafico ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	QP215GerDP(cRevi,lBrwEns,cDir)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Deleta Arquivo Temporario Classes de NC ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB1")
dbClearFilter()
dbCloseArea()
Ferase(cArqTrb1+GetDBExtension())
Ferase(cArqTrb1+OrdBagExt())
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QP220EsCNC ³ Autor ³ Marcelo Pimentel    ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Escolhe as Classes de NC                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ qipm030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215EsCNC(cMarca,lInverte,oDlg)
iF IsMark("TB_OK",cMarca,lInverte)
	RecLock("TRB1",.F.)
	If !lInverte
		TRB1->TB_OK	:= cMarca
	Else
		TRB1->TB_OK	:= "  "
	Endif
	MsUnlock()
Else
	RecLock("TRB1",.F.)
	If !lInverte
		TRB1->TB_OK	:= "  "
	Else
		TRB1->TB_OK	:= cMarca
	Endif
	MsUnlock()
Endif
oDlg:Refresh()
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ QP215M1All ³ Autor ³Marcelo Pimentel     ³ Data ³ 12/04/99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Inverte as Classes NC Marcadas/Desmarcadas                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ qipm030                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215M1All(cMarca,oDlg)
LOCAL nRecno:=Recno()
dbGotop()
Do While !Eof()
	RecLock("TRB1",.F.)
	If Empty(TRB1->TB_OK)
		TRB1->TB_OK	:= cMarca
	Else
		TRB1->TB_OK	:= "  "
	Endif
	MsUnlock()
	dbSkip()
EndDo
dbGoto(nRecno)
oDlg:Refresh()
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QP215GerDP³ Autor ³ Cleber Souza          ³ Data ³ 20/01/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Gera arquivo (SPC) para gerar o grafico                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ QP215GerDP(ExpC1,ExpL1,ExpC2)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1: Revisao do Produto                                  ³±±
±±³          ³ ExpL1: Indica se montou o browse para escolha dos ensaios  ³±±
±±³          ³ ExpC2: Diretorio para a geracao do arquivo SPC             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QIPA215                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function QP215GerDP(cRevi,lBrwEns,cDir)
Local aNC		:= {}
Local aNcGraf	:= {}
Local aDados	:= {}
Local nPos		:= 0
Local nI		:= 0
Local cArqSPC	:= ""
Local cReviQPK	:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local nRecQPK	:= 0
Local cChvMed	:= ''
Local nPosOpe   := 0 
Local nPosLab   := 0
Local nPosEns   := 0
Local nPosMed   := 0
Local nPosNco   := 0
Local cEnsaio	:= ''
Local nUsadoQPU	:= ''
Local cIP210Pro := QPK->QPK_PRODUT
Local cIP210OP  := QPK->QPK_OP       
Local lGera     := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleciona as producoes com medicoes no periodo.³
//³de acordo com a opcao de todos os resultados ou³
//³somente o Resultado em questao.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 1
	nRecQPK := QPK->(Recno())
	QPK->(dbSetOrder(2))
	QPK->(dbSeek(xFilial("QPK")+cIP210Pro+dtos(mv_par02), .T.))
	While !SC2->(Eof()) .And. QPK->QPK_FILIAL == xFilial("QPK") .And. ;
		QPK->QPK_PRODUT == cIP210Pro .And. QPK->QPK_EMISSA >= mv_par02 .And.;
		QPK->QPK_EMISSA <= mv_par03

		QPR->(dbSetOrder(6))
		QPR->(dbSeek(xFilial("QPR")+QPK->QPK_PRODUT+cReviQPK+Dtos(QPK->QPK_EMISSA)))
		While !QPR->(Eof()) .And. QPR->QPR_FILIAL == xFilial("QPR") .And.;
			QPR->QPR_PRODUT+QPR->QPR_REVI+Dtos(QPR->QPR_DTENTR) ==;
			QPK->QPK_PRODUT+cReviQPK+Dtos(QPK->QPK_EMISSA)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Caso tenha esteja em ALTERACAO nao considerar os registros que estao gravados.³
			//³devera atualizar o arquivo temporario atraves do Array aResultado             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ALTERA
				If cIP210OP == QPR->QPR_OP
					QPR->(dbSkip())
					Loop
				EndIf
			EndIf

			 //Verifica as Operacoes selecionadas 
			If	QPR->QPR_OPERAC < mv_par06 .Or. QPR->QPR_OPERAC > mv_par07
				QPR->(dbSkip())
				Loop
			EndIf	

			//Verifica os Laboratorios selecionados	
			If QPR->QPR_LABOR  < mv_par08 .Or. QPR->QPR_LABOR  > mv_par09
				QPR->(dbSkip())
				Loop
			EndIF

			// Verifica o Ensaiador
			If (!Empty(mv_par04) .And. QPR->QPR_ENSR < mv_par04) .Or. ;
				(!Empty(mv_par05) .And. QPR->QPR_ENSR > mv_par05)
	 			QPR->(dbSkip())
				Loop
			EndIf

			// Se montou browse ensaios, verifica se escolheu este ensaio
			If lBrwEns	
				TRB->(dbSeek(QPR->QPR_ENSAIO))
				If TRB->(Eof()) .Or. Empty(TRB->TB_OK)
					QPR->(dbSkip())
					Loop
				EndIf
			EndIf
			// Obtem chave de ligacao da medicao com os outros arquivos
			cChvMed := QPR->QPR_CHAVE

			// Verifica se a medicao apresenta NC
			If QPU->(dbSeek(xFilial("QPU")+cChvMed))
				While QPU->QPU_FILIAL+QPU->QPU_CODMED == xFilial("QPU")+cChvMed .And. !QPU->(Eof())
					// Verifica se a Classe da NC foi escolhida
					TRB1->(dbSeek(QPU->QPU_CLASSE))
					If TRB1->(Eof()) .Or. Empty(TRB1->TB_OK)
						QPU->(dbSkip())
						Loop
					EndIf
					nPos := ascan(aNC, { |x| x[1] == QPU->QPU_NAOCON })
					If nPos == 0
						// NC, Ocorrencia
						Aadd(aNC, { QPU->QPU_NAOCON, QPU->QPU_NUMNC })
					Else
						aNC[nPos][2]+= QPU->QPU_NUMNC
					EndIf
					QPU->(dbSkip())
				EndDo
			EndIf
			QPR->(dbSkip())
		EndDo
		QPK->(dbSkip())
	EndDo
	QPK->(dbGoto(nRecQPK))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso tenha esteja em ALTERACAO nao considerar os registros que estao gravados.³
//³devera atualizar o arquivo temporario atraves do Array aResultado             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par01 == 2 .Or. ALTERA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gravacao das medicoes ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	
	For nPosOpe:=1 to nQtdOpe
		If aResultados[nPosOpe,_OPE] >= mv_par06 .and. aResultados[nPosOpe,_OPE] <= mv_par07
			For nPosLab:=1 to Len(aResultados[nPosOpe,_LAB])
				If aResultados[nPosOpe,_LAB,nPosLab] >= mv_par08 .and. aResultados[nPosOpe,_LAB,nPosLab] <= mv_par09
					For nPosEns:=1 to Len(aResultados[nPosOpe,_ENS,nPosLab])
						aHeadEns := aSavHeadEns[nPosOpe,nPosLab,nPosEns]
						If Alltrim(aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]) == "TXT"	                                                
							nMed     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
						Else
							If Alltrim(aResultados[nPosOpe,_ENS,nPosLab,nPosEns,CARTA]) == "P"
						  		nMed     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPS_MEDIPA"}) 
							Else
								nMed     := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
							EndIf	
						EndIf
						For nPosMed := 1 To Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns]) // Numero de medicoes
							nDel := Len(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed]) // numero de colunas
							cMedicao := Iif(Valtype(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])=="N",Str(aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed]),aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nMed])
							If !aResultados[nPosOpe,_MED,nPosLab,nPosEns,nPosMed,nDel] .And. !Empty(cMedicao)	// Medicao Nao deletada e em branco
	                        
	                    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Grava Nao Conformidades         ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								For nPosNco := 1 To Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed]) // Numero de Ncos
									nUsadoQPU := Len(aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco])
									If !aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,nUsadoQPU] .And.;
											QP215ChkGd(2,.F.,nPosOpe,nPosLab,nPosEns,nPosMed,nPosNco,,.T.) // Nao deletado e Nao Vazio 
										nPos := ascan(aNC,{ |x| x[1]==aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1]})
										If nPos == 0
											// NC, Ocorrencia
											Aadd(aNC, { aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,1], aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,3] })
										Else
											aNC[nPos][2]+= aResultados[nPosOpe,_NCO,nPosLab,nPosEns,nPosMed,nPosNco,3]
										EndIf
									Endif
								Next nPosNco
	                    	EndIF
	                    Next nPosMed
			        Next nPosEns    
				EndIf	
	        Next nPosLab
	    EndIf
	Next nPosOpe
EndIf

If Len(aNc) <> 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Ordena o vetor de NCs em Ordem descendente de ocorrencia de  ³
	//³ NCs                                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aNC := aSort(aNC,,, { | x,y | x[2] > y[2] })
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Gera array com as 11 NCs de maior ocorrencia, acumulando as  ³
	//³ demais na 12a.                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nI := 1 to Len(aNC)
		If nI < 12
			// NC, Ocorrencia
			Aadd(aNcGraf, { aNC[nI,1], aNC[nI,2] })
		Elseif nI == 12                                     
			If mv_par10 == 1
				Aadd(aNcGraf, { STR0192, aNC[nI,2] })  //"Outras" 
			Else
				Exit
			EndIf	
		Else
			aNcGraf[12,2]+= aNC[nI,2]
		EndIf
	Next nI

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta vetor com os dados do grafico  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Aadd(aDados,"QACHART.DLL - PARETO")

	//Se existir Ponto de Entrada, o mesmo retorna o Texto do titulo.
	If ExistBlock("QPGPAT") 
		aAdd( aDados,"[TITLE]" )
		aAdd( aDados,ExecBlock("QPGPAT",.F.,.F.) )
 	EndIF       

	//Se existir Ponto de Entrada, o mesmo retorna o Texto do rodape.
	If ExistBlock("QPGPAF") 
		aAdd( aDados,"[FOOT]" )
		aAdd( aDados,ExecBlock("QPGPAF",.F.,.F.) )
    EndIf

	Aadd(aDados,"[DADOS PARETO]")

	For nI := 1 to Len(aNcGraf)
		Aadd(aDados,AllTrim(Str(aNcGraf[nI,2]))+";"+aNcGraf[nI,1])
	Next nI
	Aadd(aDados,"[FIM DADOS PARETO]")

	// Gera o nome do arquivo SPC
	cArqSPC := QP215NoArq(cDir)

	If !Empty(cArqSPC)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava o arquivo SPC ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lGera := QP215GerAr(aDados ,cArqSPC, cDir)

		If lGera
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Controle para abertura do grafico. Caso o grafico fique aberto por mais de 3 minutos ³
			//³ nao perca a conexao.																 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PtInternal(9,"FALSE")
			
			Calldll32("ShowChart",cArqSPC,"6",cDir,PARETO,Iif(!Empty(cSenha),Encript(Alltrim(cSenha),0),"PADRAO"))
   	
			// Exclui o arquivo SPC gerado	
			Ferase(cArqSPC)
			PtInternal(9,"TRUE")
		EndIf
	EndIf
Else
	MessageDlg(STR0149,,3)	 //"Näo foram encontradas Näo Conformidades, a partir dos dados solicitados."
EndIf

Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215FLIBUºAutor  ³Cleber Souza 		 º Data ³  02/10/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Seta foco na ultima pasta do folder para Liberacao Urg.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215FLIBU()

//Seta no Folder do Laudo Geral.
If lLiberaUrg
	oFolder:nOption := 3 
	nFldOpe := 3
	oFolder:Refresh()
EndIF

Return .T.  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215CANCEºAutor  ³Cleber Souza        º Data ³  02/16/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Botao de cancelar da tela de resultados.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215CANCE(nOpc)
         
If ExistBlock("QP215DEL")		// Nao faz confirmacao na visualizacao
	If ExecBlock("QP215DEL",.F.,.F.,{nOpc})
		If qpAviso('',STR0150,{STR0151,STR0152}) == 1	//"Confirma saida?"###"Sim"###"Nao"
			oDlgResu:End()
		EndIf
	EndIf
Else	
	oDlgResu:End()
Endif

If ExistBlock("QP215EXE")
	ExecBlock("QP215EXE",.F.,.F.,{nOpc})
Endif

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³LinOkMedi	³ Autor ³ Cleber Souza          ³ Data ³ 17/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Critica se a linha digitada esta' Ok - Getdados Medicoes   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LinOkMed()
Local lRet	    := .T.
Local aArea     := GetArea()
Local cProcura  := '' 
Local aHead     := aSavHeadEns[nOperacao,nFldLab,nEnsaio]
Local aCols     := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols   
Local N         := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT  
Local cMedicao  := ""
Local cRevi		:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
Local cOper		:= aResultados[nOperacao,_OPE]  
Local cCarta    := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]
Local aNC		:= {}
Local nPosChec	:= 0
Local nQtdMed   := 0
Local nCnt      := 0  
Local nPosRes   := 0
Local nPosMed   := 0  
Local nPosEnsR  := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPR_ENSR' })
Local nDtM	 :=	Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})
Local nHrM	 :=	Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})
Local nAmo	 :=	Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_AMOSTR"}) 

If cMv_QPINAUT == "S"
	aSavaCols[HEAD_INST] := aClone(aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols)
Endif

If cCarta <> "TXT"
	If cCarta <> "P  "
		nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPS_MEDICA' })
		nPosRes := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPR_RESULT' })
	Else
		nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPS_MEDIPA' })
	EndIF
Else
	nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_MEDICA' }) 
	nPosRes := Ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_RESULT' })
EndIf 

cMedicao := Iif(Valtype(aCols[n,nPosMed])=="N",Str(aCols[n,nPosMed]),aCols[n,nPosMed])

//Posiciona QP1 
dbSelectArea("QP1")
dbSetOrder(1)
dbSeek(xFilial("QP1")+aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO])

cProcura := Dtos(aCols[n,nDtM])+aCols[n,nHrM]+Str(aCols[n,nAmo],1)
If !(aCols[n,Len(aCols[n])])	// Se nao estiver deletado
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se a Medicao ja' existe ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Preciso checar se Data e Hora da Medicao e Amostra se repetem
	nAchou := Ascan(aCols,{|x| Dtos(x[nDtM])+x[nHrM]+Str(x[nAmo],1) == cProcura;
	.And. !(x[Len(aCols[n])])})
	If nAchou > 0 .And. nAchou <> n .and. ! Empty(aCols[n,nPosMed])
		MessageDlg(OemToAnsi(STR0153),STR0093,2) 	 //"Ja existe medicao com esta Data/Hora/Amostra"###"Atencao"
		lRet := .F.
	EndIf
	
	If lRet
		If QP1->QP1_CARTA $ "XBR.XBS.XMR.HIS"
			nQtdMed	:= QP1->QP1_QTDE
		ElseIf QP1->QP1_CARTA $ "IND.NP .C  "
			nQtdMed	:= 1
		ElseIf QP1->QP1_CARTA == "U  "
			nQtdMed	:= 2
		ElseIf QP1->QP1_CARTA == "P  "
			nQtdMed	:= 3
		EndIf
	
		For nCnt:= 1 To nQtdMed
			If Empty(aCols[N,(nPosMed+nCnt)-1]) // Verifica Medicao
				lRet := .F.
		 	EndIf
	  	Next nCnt
		
		If lRet
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se digitou o Ensaiador ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(aCols[N,nPosEnsr])
				lRet := .F.
			EndIf
			If lRet .And. cCarta == "TXT"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Se for Ensaio Texto, verifica se digitou o Resultado ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If Empty(aCols[N,nPosRes])
					lRet := .F.
				EndIf
			EndIf
			If lRet .And. cCarta <> "TXT"
				QP7->(dbSetOrder(1))
				If	QP7->(dbSeek(xFilial("QP7")+SC2->C2_PRODUTO+cRevi+SC2->C2_ROTEIRO+cOper+aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]))
					If At('i',QP7->QP7_NOMINA) <> 0 .And. !Empty(cMedicao)
						cMedicao := Lower(cMedicao)
						If At('i',cMedicao) == 0 .And. At('/',cMedicao) == 0
							HELP(" ",1,"QPH215071",,cMedicao,3,1)
							lret := .F.
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf        

RestArea(aArea)

Return(lRet)            

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³LinOkInS	³ Autor ³ Cleber Souza          ³ Data ³ 17/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Critica se a linha digitada esta' Ok - Getdados Instrumento³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LinOkINS()
Local lRet	  := .T. 
Local aCols   := aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols
Local aHeader := aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aHeader
Local N       := aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:nAT
Local nAcPosIns := ascan(aHeader, { |x| alltrim(x[2]) == 'QPT_INSTR' })

If !(aCols[n,Len(aCols[n])])	// Se nao estiver deletado
	If Empty(aCols[n,nAcPosIns])
		lRet := .F.
	EndIf
EndIf
Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³LinOkNCC	³ Autor ³ Cleber Souza          ³ Data ³ 17/02/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Critica se a linha digitada esta' Ok - Getdados NConformid.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215  		     									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function LinOkNCC()
Local lRet		:= .T. 
Local aHead     := aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aHeader
Local aCols     := aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aCols  
Local N         := aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:nAT  
Local nPosNc	:= ascan(aHead, { |x| alltrim(x[2]) == 'QPU_NAOCON'	})
Local nPosNumnc	:= ascan(aHead, { |x| alltrim(x[2]) == 'QPU_NUMNC'		})

If !(aCols[n,Len(aCols[n])])	// Se nao estiver deletado
	If Empty(aCols[n,nPosNC]) .Or. aCols[n,nPosNumnc] == 0
		lRet := .F.
	EndIf
EndIf
Return(lRet)      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215MetodºAutor  ³Cleber Souza 		 º Data ³  19/02/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza os campos de metodo e revisao do documento na     º±±
±±º          ³ inclusao das medicoes.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPN1 - Posicao da Operacao                                º±±
±±º          ³ EXPN2 - Posicao do Laboratorio                             º±±
±±º          ³ EXPN3 - Posicao do Ensaio                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215Metod(nPosOpe, nPosLab, nPosEns, aColsAux)

Local nPosMetod := Ascan(aSavHeadEns[nPosOpe,nPosLab,nPosEns,1],{|x|Alltrim(x[2])=="QPR_METODO"}) 
Local nPosRvDoc := Ascan(aSavHeadEns[nPosOpe,nPosLab,nPosEns,1],{|x|Alltrim(x[2])=="QPR_RVDOC"})  
Local N         := 0
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

If lLayout
	N           := aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLab,nPosEns]:nAT
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLab,nPosEns]:aCols[N,nPosMetod] := aResultados[nPosOpe,_ENS,nPosLab,nPosEns,METODO]
	aOBJETOS[OBJ_MEDICA,nPosOpe,nPosLab,nPosEns]:aCols[N,nPosRvDoc] := aResultados[nPosOpe,_ENS,nPOsLab,nPosEns,REVDOC]
//Else
//	QP216AtuEns(oBrwJJ:oWnd, nPosOpe, nPosLab, nPosLab, oBrwJJ:nAT)
EndIf

Return .T.    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ConPadNC  ³ Autor ³ Marcelo Pimentel      ³ Data ³24/11/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Consulta Padrao Especifica				    			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function ConPadNC( cTitulo, cAlias, aCampos, nOrdem, cSeek, bWhile, bFor )
Local oDlg
Local bConteudo
Local cBloco
Local oBtn1
Local oBtn2
Local aHeader	:= {}
Local nOpc		:= 0
Local nItens	:= 0
Local cConteudo	:= ''
Local cNaoCon	:= ''
Local aListAux  := {}
Local nI        := 0

Private aListPad := {}
Private oLBrowse
Private nReg	 := 0

nOrdem	 := If( nOrdem == NIL, 1, nOrdem )
bWhile	 := If( bWhile == NIL, {||.T.}, bWhile )
bFor	 := If( bFor	== NIL, {||.T.}, bFor	)

DbSelectArea(cAlias)
DbSetOrder(nOrdem)

CursorWait()

If cSeek == NIL
	DbGoTop()
Else
	DbSeek(&(cSeek),.T.)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta aHeader especifico									     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aeval(aCampos,{|aElem|Aadd(aHeader,aElem[1])})

Do While !Eof() .And. Eval( bWhile )
	IF ! Eval( bFor )
		DbSkip()
		LOOP
	ENDIF
	
	aListAux := {}
	For nI := 1 To Len(aCampos)
		If aCampos[nI,2] == "QP9_NAOCON"
			bConteudo	:= FieldWBlock(aCampos[nI,2],Select(cAlias))
			cNaoCon		:= Eval(bConteudo)
		EndIf
		If aCampos[nI,2] == "QP9_DESNCO"
			cConteudo := QipxDNCo(cNaoCon)
			Aadd(aListAux,cConteudo)
			cNaoCon	:= ''
		Else
			If ValType(aCampos[nI,2]) == "B"
				bConteudo := aCampos[nI,2]
			Else
				bConteudo := FieldWBlock(aCampos[nI,2],Select(cAlias))
			EndIf
			Aadd(aListAux,Eval(bConteudo))
		EndIf
	Next
	Aadd(aListAux, Recno() )
	Aadd(aListPad,aListAux)
	If (++nItens) == 4096
		Alert(STR0194)    //"Pesquisa PARCIAL, excedido numero de itens"
		Exit
	EndIf
	DbSkip()
EndDo

CursorArrow()

If Len(aListPad) == 0
	Alert(STR0195) //"Nao ha dados conforme selecao !"
	Return .F.
EndIf

DEFINE MSDIALOG oDlg TITLE STR0176+cTitulo From 9,0 To 18,60 OF oMainWnd  //"Consulta - "

oLBrowse:= TWBrowse():New( 0.4, 1, 182, 60,,aHeader,, oDlg,,,,,,,,,,,,.T.)
oLBrowse:SetArray(aListPad)

cBloco := "{|| { "
For nI := 1 To Len(aListPad[1]) - 1
	If nI > 1
		cBloco += ","
	EndIf
	cBloco += "aListPad[oLBrowse:nAt,"+StrZero(nI,2)+"]"
Next

cBloco += " }}"
oLBrowse:bLine := &(cBloco)
oLBrowse:bLDblClick := {||(nOpc := 1,nReg:=aListPad[oLbrowse:nAt,Len(aListPad[1] ) ],oDlg:End())}

DEFINE SBUTTON oBtn1 FROM	4.0,200 TYPE	1	ACTION (nOpc := 1,nReg:=aListPad[oLbrowse:nAt,Len(aListPad[1])],oDlg:End()) ENABLE OF oDlg
DEFINE SBUTTON oBtn2 FROM  18.5,200 TYPE	2	ACTION (nOpc := 0,oDlg:End())	ENABLE OF oDlg
ACTIVATE MSDIALOG oDlg CENTERED

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona registro											 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOpc == 1
	DbGoto( nReg )
EndIf
Return(nOpc == 1)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³DiaUtil   ³ Autor ³ Marcelo Pimentel      ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Retorna o numero de dias uteis no per¡odo                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³DiaUtil()                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FuncTion DiaUtil(dDtEntr,dDtSai)
Local nDat:=0

nDat := dDtSai-dDtEntr
If nDat > 1
	dDtEntr:= dDtEntr-1
EndIf
Return(nDat)      

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215ValIn³ Autor ³ Cleber Souza		    ³ Data ³ 19/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida se eh obrigatorio instrumento para as medicoes.      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIPA215                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
FuncTion QP215ValIn(cTipo)

Local lLayout    := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRet       := .T.
Local cMens      := ""                    
Local nPosOpe    := 0
Local nPosLabX   := 0
Local nPosEnsa   := 0
Local nPosMed    := 0 
Local aEnsIns    := {}
Local cRevi		 := ""
Local cOper      := ""
Local cTexto     := ""
Local nY         := 0
Local nPosRes	 := 0
Local nPosResa   := 0
Local cCarta	 := ""
Local cCartaA    := ""
Local nDel		 := 0

Private lTInP    := .T.

If !lLayout
	nOpera 	  := nPosOper
	nPosLabi  := nPoslab
	nEnsaioX  := oBrwJJ:nAt 
Else
	nOpera		:= nOperacao
	nPosLabi	:= nFldlab
	nEnsaioX    := nEnsaio 
EndIf

cRevi 	:= Iif(Empty(QPK->QPK_REVI),QA_UltRvQ(QPK->QPK_PRODUT),QPK->QPK_REVI)
cOper 	:= aResultados[nOpera,_OPE]
cCarta	:= aResultados[nOpera,_ENS,nPosLabi,nEnsaioX,CARTA]

//If !lLayout
//	Q216ARESU()
//EndIf

If cCarta == "P  "
	nPosRes  := Ascan(aSavHeadEns[nOpera, nPosLabi, nEnsaioX, 1],{|x|Alltrim(x[2])=="QPR_RESULT"})
ElseIf cCarta == "TXT"
	nPosRes  := Ascan(aSavHeadEns[nOpera, nPosLabi, nEnsaioX, 1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
Else
	nPosRes  := Ascan(Iif(lLayout,aSavHeadEns[nOpera, nPosLabi, nEnsaioX, 1], oGetMed:aHeader),{|x|Alltrim(x[2])=="QPR_RESULT"})
EndIf                                           

If (cMv_QINTQMT == "S" .and. cMV_QPINSOB == "S") .OR. (cMv_QINTQMT == "S" .and. cMV_QINOBFM $ "1|3" ) //Indica se os Instrumentos sao obrigatorios
	QP215SavResu({SAV_INS},.T.) // Atualizo o aresultados

	If cTipo == "L"   
        // Devo  consistir  todas os  ensaios  do Laboratorio
		For nPosEnsa:=1 to Len(aResultados[nOpera,_ENS,nPosLabi])
			nDel 	:= Len(aResultados[nOpera,_MED,nPosLabi,nPosEnsa,1]) 
			cCartaA	:= aResultados[nOpera,_ENS,nPosLabi,nPosEnsa,CARTA]
			If cCartaA <> "TXT"
				nPosResa  := Ascan(aSavHeadEns[nOpera, nPosLabi, nPosEnsa, 1],{|x|Alltrim(x[2])=="QPR_RESULT"})
			Else
				nPosResa  := Ascan(aSavHeadEns[nOpera, nPosLabi, nPosEnsa, 1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
			EndIf
			lTInP := .T.
			For nPosMed:=1 to Len(aResultados[nOpera,_MED,nPosLabi,nPosEnsa])
				If !aResultados[nOpera,4,nPosLabi,nPosEnsa,nPosMed,nDel] .AND. Len(aResultados[nOpera,_INS,nPosLabi,nPosEnsa,nPosMed]) >= 1 
					Aeval(aResultados[nOpera,_INS,nPosLabi,nPosEnsa,nPosMed],{|x,y| Iif(Empty(aResultados[nOpera,_INS,nPosLabi,nPosEnsa,nPosMed,1,y]) .AND. lTInP,lTInP := .F., Nil) })
				ElseIf !aResultados[nOpera,4,nPosLabi,nPosEnsa,nPosMed,nDel]     
					lTInP := .F.
				EndIf
				If !aResultados[nOpera,_MED,nPosLabi,nPosEnsa,nPosMed,nDel] .AND.;
				   !Empty(AllTrim(aResultados[nPosOper,_MED,nPosLabi,nPosEnsa,nPosMed,nPosResa])) .AND.;
				   !lTInP .AND.;
				   Iif(cMV_QINVLTX == "2",aResultados[nOpera,_ENS,nPosLabi,nPosEnsa,CARTA] != "TXT", .T.) .AND.;
				   aResultados[nOpera,_ENS,nPosLabi,nPosEnsa,FAMVINC] .AND. lRet
			    	cMens := STR0196 +" "+ Alltrim(Str(nPosMed)) +" "+ ;							// "Instrumento obrigatorio para a Medicäo "
				   		   	 STR0197 +" "+ aResultados[ nOpera, _ENS, nPosLabi,nPosEnsa,DESPOR]	// "referente ao Ensaio "  
				    lRet  := .F.   
				    Exit
				EndIF                                                    
			Next nPosMed		
		Next nPosEnsa
	ElseIf cTipo == "T"
		For nPosOpe:=1 to nQtdOpe
			For nPosLabX:=1 to Len(aResultados[nPosOpe,_LAB])
				For nPosEnsa:=1 to Len(aResultados[nPosOpe,_ENS,nPosLabX])
					nDel    := Len(aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa,1]) 
					cCartaA	:= aResultados[nPosOpe,_ENS,nPosLabX,nPosEnsa,CARTA]
					If cCartaA <> "TXT"
						nPosResa  := Ascan(aSavHeadEns[nPosOpe, nPosLabX, nPosEnsa, 1],{|x|Alltrim(x[2])=="QPR_RESULT"})
					Else
						nPosResa  := Ascan(aSavHeadEns[nPosOpe, nPosLabX, nPosEnsa, 1],{|x|Alltrim(x[2])=="QPQ_RESULT"})
					EndIf
					For nPosMed:=1 to Len(aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa])
						If Len(aResultados[nPosOpe,_INS,nPosLabX,nPosEnsa,nPosMed]) >= 1 .AND. Empty(aResultados[nPosOpe,_INS,nPosLabX,nPosEnsa,nPosMed,1,1]) .AND. Iif(cMV_QINVLTX == "2",aResultados[nPosOpe,_ENS,nPosLabX,nPosEnsa,CARTA] != "TXT", .T.) .AND. lRet
					    	If aOperacoes[nPosOpe,Iif(lLayout,8,6)]  == "S" .And. ;
							   aOperacoes[nPosOpe,Iif(lLayout,9,7)]  == "S" .And. ;
							   aOperacoes[nPosOpe,Iif(lLayout,10,8)] == "S" .And. ;  
							   aResultados[nPosOpe,_ENS,nPosLabX,nPosEnsa,FAMVINC] .And. ; 
							   !aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa,nPosMed,nDel] .AND. !Empty(AllTrim(aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa,nPosMed,nPosResa]))
					    			cMens := STR0196 +" "+ Alltrim(Str(nPosMed)) +" "+ ;							// "Instrumento obrigatorio para a Medicäo "
						   		   		 STR0197 +" "+ aResultados[nPosOpe,_ENS, nPosLabX, nPosEnsa,DESPOR]	// "referente ao Ensaio "  
								    lRet  := .F.   
								    Exit
							ElseIf aResultados[nPosOpe,_ENS,nPosLabX,nPosEnsa,FAMVINC] .And. !aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa,nPosMed,nDel] .AND. !Empty(AllTrim(aResultados[nPosOpe,_MED,nPosLabX,nPosEnsa,nPosMed,nPosResa]))
							    	cMens := STR0196 + Alltrim(Str(nPosMed)) + ;							// "Instrumento obrigatorio para a Medicäo "
					   		   	             STR0197 + aResultados[nPosOpe,_ENS,nPosLabX,nPosEnsa,DESPOR]	// "referente ao Ensaio "  
								    lRet  := .F.
							EndIf
						EndIF                                                    
					Next nPosMed		
				Next nPosEnsa		
		    Next nPosLabX
   		 Next nPosOpe
	EndIF
Else
	If cTipo == "L"   
        // Devo  consistir  todas os  ensaios  do Laboratorio
		For nPosEnsa:=1 to Len(aResultados[nOpera, _ENS, nPosLabi])
			nDel := Len(aResultados[ nOpera, _MED, nPosLabi, nPosEnsa, 1]) 
			If Iif(cMV_QINVLTX == "2",aResultados[nOpera,_ENS,nPosLabi,nPosEnsa,CARTA] != "TXT", .T.)
				//Verifica se possui familia de instrumento cadastrado.
				dbSelectArea("QQ1")
				dbSetOrder(3)
				If dbSeek(xFilial("QQ1")+QPK->QPK_PRODUT+cRevi+cRoteiro+cOper+aResultados[Iif(lLayout, nOpera, nPosOper),_ENS,Iif(lLayout, nPosLabi, nPosLab),nPosEnsa,ENSAIO])
					For nPosMed:=1 to Len(aResultados[nOpera, _MED, nPosLabi, nPosEnsa])
						If !aResultados[ nOpera, _MED, nPosLabi, nPosEnsa, nPosMed, nDel] .AND. Empty(aResultados[ nOpera, _INS, nPosLabi, nPosEnsa, nPosMed, 1, 1])
							AADD(aEnsIns,Alltrim(aResultados[ nOpera, _ENS, nPosLabi, nPosEnsa,DESPOR]))	
						    Exit
						EndIf
					Next nPosMed		
				EndIf
			EndIF    
		Next nPosEnsa
		If Len(aEnsIns) > 0 
			cTexto := STR0225  //"O(s) ensaio(s) "                              
			For nY:=1 to Len(aEnsIns)
				cTexto += aEnsIns[nY]+IIF(nY+1==Len(aEnsIns),STR0226,IIF(nY+1<Len(aEnsIns),", "," ")) //" e "
			Next nY	                     
			cTexto += STR0227  //"apesar de possuir familia de instrumento na especificação do produto, possuem medições onde o instrumento não foi informado."
			MsgAlert(cTexto)
	    EndIf
	EndIF
EndIf

Return({lRet,cMens})    

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215DelOK³ Autor ³ Cleber Souza		    ³ Data ³ 24/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida a exclusão da Linha das Medições				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIPA215                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/            
Function QP215DelOK(nAtu,aCols,aHeader)   
Local nY 	   := 0
Local nDelNCO  := Len(aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aHeader)+1 
Local nDelINS  := Len(aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aHeader)+1   
Local lDelOk   := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para permitir prosseguir a exclusao                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("QP215DOK")	
	lDelOk := ExecBlock("QP215DOK",.F.,.F.,{nOperacao,nFldLab,nEnsaio})
   	If !lDelOk
		Return(Nil)
	Endif
Endif     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Excluindo Nao Conformidades referentes a medicao				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 to Len(aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aCols)  
	aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aCols[nY,nDelNCO] := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[nAtu,Len(aHeader)+1] 
Next nY

aResultados[nOperacao,_NCO,nFldLab,nEnsaio,nAtu]:= aClone(aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:aCols)
aOBJETOS[OBJ_NCC,nOperacao,nFldLab,1]:Refresh()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Excluindo Instrumentos referentes a medicao		 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nY:=1 to Len(aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols)  
	aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols[nY,nDelINS] := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[nAtu,Len(aHeader)+1] 
Next nY

aResultados[nOperacao,_INS,nFldLab,nEnsaio,nAtu]:= aClone(aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:aCols)
aOBJETOS[OBJ_INST,nOperacao,nFldLab,1]:Refresh()

Return(NIL)

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QP215WHAMO³ Autor ³ Cleber Souza		    ³ Data ³ 31/03/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o campo de Amostragem na GetDados das Medicoes.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³QIPA215                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/            
Function QP215WHAMO()

Local lLayout := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRet    := .T.
Local cOper   := ""
Local cCarta  := ""
Local cEnsaio := ""

If !lLayout
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := nPosEns
EndIf

cOper   := aResultados[nOperacao,_OPE]
cCarta  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA]
cEnsaio := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,ENSAIO]
                   

If cCarta <> "TXT"
	QP7->(dbSetOrder(1))
	If QP7->(dbSeek(xFilial("QP7")+QPK->QPK_PRODUT+QPK->QPK_REVI+cRoteiro+cOper+cEnsaio))
		If Empty(QP7->QP7_PLAMO) .or. QP7->QP7_PLAMO $ "Z" //NBR5426, NBR5429, Zero Defeito 
			lRet := .F.
		EndIF
	EndIf
Else 
	lRet := .F.
EndIf          

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QPChgRadio  ³ Autor ³Cleber Souza           ³ Data ³ 01/04/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Atualiza o Tamanho da Amostra conforme a Carta               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215												        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QPChgRadio(nRadio,cRadCarta,nTamAmo,oTamAmo)

If nRadio == 1 .And. Substr(cRadCarta,1,3) == "IND"
	nTamAmo	:= 1
	oTamAmo:Disable()
	oTamAmo:Refresh()
Else
	nTamAmo	:= 5
	oTamAmo:EnaBle()
	oTamAmo:Refresh()
EndIf
Return(.T.)     

                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215VLDJUSºAutor  ³Cleber Souza 		 º Data ³  05/04/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se eh necessario justificativa nos laudos do Labora-º±±
±±º          ³ torio e Operacao.    .                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Define se Valida Lab ("L") ou Operacoes ("O")      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                   

Function QP215VLDJUS(cTipo)

Local lLayout  := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRet     := .T.
Local nPosJus  := 0   
Local nPosLau  := 0   
Local nPosOpera  := 0
Local nPosLab  := 0

If !(INCLUI .OR. ALTERA)
     Return(lRet)
EndIf

If !lLayout
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := nPosEns
	If cTipo == "L"
		QP215SavResu({SAV_LAUL})
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se eh necessario preencher o campo de justificativa nos laudos do laboratorio.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cTipo == "L"
	For nPosLab:=1 to Len(aResultados[nOperacao,_LAB])
 
		If lLayout
			nPosJus := QP215GetLau(aSavGets[nOperacao,2,nPosLab],"QPL_JUSTLA") 
			nPosLau := QP215GetLau(aSavGets[nOperacao,2,nPosLab],"QPL_LAUDO") 
		Else                                                                                                   
			nPosJus := QP215GetLau(aSavGets[1,2],"QPL_JUSTLA") 
			nPosLau := QP215GetLau(aSavGets[1,2],"QPL_LAUDO") 
		EndIf

		If aResultados[nOperacao,_LLA,nPosLab,nPosLau] # cFatApr .and.;
		    Empty(aResultados[nOperacao,_LLA,nPosLab,nPosJus]) .and. !Empty(aResultados[nOperacao,_LLA,nPosLab,nPosLau]) 	
			HELP(" ",1,"QPH215014",,aResultados[nOperacao,_LAB,nPosLab],3,1) //E obrigatorio a digitacao da justificativa do laudo no laboratorio 
			lRet  := .F.
			Exit
        EndIf  

    Next nPosLab
	 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se eh necessario preencher o campo de justificativa nos laudos das Operacoes .³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf cTipo == "O"

	For nPosOpera:=1 to nQtdOpe

		If lLayout
			nPosJus := QP215GetLau(aSavGets[nPosOpera,1],"QPM_JUSTLA") 
			nPosLau := QP215GetLau(aSavGets[nPosOpera,1],"QPM_LAUDO")  
		Else                                                                                                   
			nPosJus := Iif(QP215GetLau(aSavGets[1,1],"QPM_JUSTLA") > 0, QP215GetLau(aSavGets[1,1],"QPM_JUSTLA"), QP215GetLau(aSavGets[1,2],"QPL_JUSTLA") )
			nPosLau := Iif(QP215GetLau(aSavGets[1,1],"QPM_LAUDO")  > 0,  QP215GetLau(aSavGets[1,1],"QPM_LAUDO"), QP215GetLau(aSavGets[1,2],"QPL_LAUDO")  )
		EndIf
		
		If aResultados[nPosOpera,_LOP,nPosLau] # cFatApr .and.;
		   Empty(aResultados[nPosOpera,_LOP,nPosJus]) .and. !Empty(aResultados[nPosOpera,_LOP,nPosLau]) 	
			HELP(" ",1,"QPH215015",,aResultados[nPosOpera,_OPE],3,1) //E obrigatorio a digitacao da justificativa do laudo na operacao    
			lRet  := .F.
			Exit
        EndIf 

	Next nPosOpera   

EndIf


Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215VOMEDºAutor  ³Cleber Souza        º Data ³  04/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida os dados do objeto medicoes.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VOMED()

Local lLayout   := GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local lRet      := .T.
Local nPosRes   := 0
Local nDelete   := 0
Local aHead     := {}
Local aCols     := {}   
Local n         := 0
Local cCarta	:= ""
Local nPosDtm   := 0   
Local nPosHrm   := 0  
Local nPosAmo   := 0
Local nPosEnsR  := 0   
Local lPerEnSMed := GetMv("MV_QPIESMD",.F.,"2") == "1" // Define se irá ignorar ensaios sem medições mesmo que estes estejam definidos como Obrigatórios 1 = Sim / 2 = Não, será  somente  exibida  uma  mensagem de ação ao  uruário permitindo continuar ignorando a onbrigatoriedade ou abandonar

If lLayout
	aCols     := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols   
	n         := aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT   
Else
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := nPosEns
	aCols     := oGetMed:aCols   
	n         := oGetMed:nAT   
EndIf

aHead     := aSavHeadEns[nOperacao,nFldLab,nEnsaio]
cCarta	  := aResultados[nOperacao,_ENS,nFldLab,nEnsaio,CARTA] 
nPosDtm   := Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_DTMEDI"})   
nPosHrm   := Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_HRMEDI"})   
nPosAmo   := Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_AMOSTR"})   
nPosEnsR  := Ascan(aHead[1],{|x|Alltrim(x[2])=="QPR_ENSR"})

nNoDel:=0

If nOpcX<>3
	Return(lRet)
EndIF	

If cCarta <> "TXT"
	nPosRes := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPR_RESULT' }) 
	nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPS_MEDICA' }) 
Else
	nPosMed := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_MEDICA' })
	nPosRes := ascan(aHead[1], { |x| alltrim(x[2]) == 'QPQ_RESULT' }) 
EndIf
            
If !aCols[n,Len(aHead[1])+1] 	
	nNoDel++
	IF n>1
		If  Empty(aCols[n, nPosRes]) .OR.;
			Empty(aCols[n, nPosDtm]) .OR.;	
			Empty(aCols[n, nPosHrm]) .OR.;
	  		Empty(aCols[n, nPosAmo]) .OR.;
	  		Empty(aCols[n,nPosEnsR]) .OR.;
	  		Empty(acols[n, nposmed])  
	  		If lPerEnSMed       
		  		aCols[n,Len(aHead[1])+1] := .T. 	
	  		Else
		  		lRet  := .F.
		  	EndIf
  		Endif
  	Else
  		IF (Empty(aCols[n,nPosRes]) .OR. Empty(aCols[n,nPosEnsR]))  		
	  		If lPerEnSMed       
		  		aCols[n,Len(aHead[1])+1] := .T. 	
	  		Else
		  		lRet  := .F.
		  	EndIf
  		Endif
  	Endif
   	IF !lRet
   		Help(" ",1,"QPH215073") //"Existem campos obrigatorios que nao foram preenchidos na medicao atual."
		If lLayout
   			aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:oBrowse:SetFocus()
   			aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:Refresh()
  		EndIf
	EndIf 
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215OPERAPºAutor  ³Cleber Souza       º Data ³  04/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de operação rapida que posiciona na Operação        º±±
±±º          ³ selecionada pelo usuário.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215OPRAP(cOperAut)  

Local nPosicao   := 0 
Local nOPeABack  := nOperaAnt 
Local nOpeBack   := nOperacao 
Local nY         := 0

If nFldOpe <> 1 
	Help(" ",1,"QPH215075") //A rotina de operação rapida só pode ser executada na pasta OPERACOES.
	Return(NIL)
EndIF	
If lAutomatic
	For nY:=1 to Len(aResultados)-1
		If	aResultados[nY,_OPE]==cOperAut
			nPosicao := nY
			Exit
		EndIf
	Next nY
	
	If nPosicao == 0
		Help(" ",1,"QPH215076") //A operação informada não foi relacionada para esse produto.
		Return(NIL) 
	EndIF
ElseIf Pergunte("QIP215",.t.)
	For nY:=1 to Len(aResultados)-1
		If	aResultados[nY,_OPE]==mv_par01
			nPosicao := nY
			Exit
		EndIf
	Next nY

	If nPosicao == 0
		Help(" ",1,"QPH215076") //A operação informada não foi relacionada para esse produto.
		Return(NIL)
	EndIF
EndIf

If nPosicao > 0
	
	nOperacao:=nPosicao
	
	If QP215ValNav("O")
		
		QP215OLAUL()
		
		aOperacoes[nOperaAnt,1] := QP215AtuSta(nOperaAnt,,,,"O",{1},.F.)
		aOperacoes[nOperaAnt,2] := QP215AtuSta(nOperaAnt,,,,"O",{1},.F.)
		aOperacoes[nOperaAnt,3] := QP215AtuSta(nOperaAnt,,,,"O",{2},.F.)
		
		oBrwOpe:nAT := nOperacao
		oBrwOpe:Refresh()
		nEnsaioA:=nEnsaio:=1
		nMedicaoA:=nMedicao:=1
		nOperaAnt:=nPosicao
	Else
		nOperaAnt := nOPeABack
		nOperacao := nOpeBack
	EndIF
EndIF

IIF(lAutomatic,lAutomatic:=.F.,.F.)

Return(NIL)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215MONPA ºAutor  ³Cleber Souza       º Data ³  04/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que monta o Plano de Amostragem.				      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215MONPA(cEnsaio,cTpCart,cPlamo,cRoteiro,cOperac)

Local aRet      := {}
Local nY        := 0
Local cTamAmo	:= Padr(Alltrim(Str(QPK->QPK_TAMLOT)),TamSx3("QPL_TAMLOT")[1])
Local cFatcon	:= ""
Local cTipCon	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o Fator Conversao                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If QP6->QP6_UNMED1 == QPK->QPK_UM
	cFatCon := QP6->QP6_FATCO1
	cTipCon := QP6->QP6_TIPCO1
ElseIf QP6->QP6_UNMED2 == QPK->QPK_UM
	cFatCon := QP6->QP6_FATCO2
	cTipCon := QP6->QP6_TIPCO2
EndIf
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula o Tamanho da Amostra                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
If Superval(cFatCon) <> 0
	cFatCon := StrTran(cFatcon,",",".")
	If cTipCon == "D"
		cTamAmo := Alltrim(Str(QPK->QPK_TAMLOT / Superval(cFatCon)))
	Else
		cTamAmo := Str(QPK->QPK_TAMLOT * Superval(cFatCon))
	EndIf
EndIf

If Len(aOperacoes) < 5 
	QQH->(dbSetOrder(1))
	If QQH->(dbSeek(xFilial('QQH')+QPK->QPK_PRODUT+QPK->QPK_REVI+cRoteiro+cOperac+cEnsaio))
		aRetorno  := QEP_RetAmostra(cPlamo,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,+Str(Int(Val(cTamAmo)),8),"QPK_TAMLOT",.F.)
		If cPlamo=="I"
			For nY:=1 to Len(aRetorno)
				AADD(aRet,{QQH->QQH_PLANO,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,STR0217+aRetorno[nY,7],aRetorno[nY,3],aRetorno[nY,1],aRetorno[nY,2],aRetorno[nY,6],aRetorno[nY,4],aRetorno[nY,5]})	
			Next nY
		Else 
			If QQH->(FieldPos("QQH_DESCRI")<>0)
				AADD(aRet,{QQH->QQH_PLANO,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,QQH->QQH_DESCRI,aRetorno[1],aRetorno[2],aRetorno[3],aRetorno[4],aRetorno[5],aRetorno[6]})
			Else
				AADD(aRet,{QQH->QQH_PLANO,QQH->QQH_AMOST,QQH->QQH_NIVAMO,QQH->QQH_NQA,QA_Plano(cPlamo,.T.),aRetorno[1],aRetorno[2],aRetorno[3],aRetorno[4],aRetorno[5],aRetorno[6]})
			EndIF	
		EndIf	
	Else
		AADD(aRet,{"","","","","",0,0,0,0,0,0})
	EndIF	
Else
	AADD(aRet,{"","","","","",0,0,0,0,0,0})
Endif
Return(aRet)   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215ACUPA ºAutor  ³Cleber Souza       º Data ³  04/07/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina que acumula valores de Medições e Não Conformidades º±±
±±º          ³ referentes aos Plano de Amostragem NBR5426.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215ACUPA(aArray,cPlano,nLoop1)

Local aRet      := {}
Local lAcumula  := GetMv("MV_QACUPAM")
Local nY        := 0
Local nAmo1     := 0            
Local nAmo2     := 0            

If lAcumula      
             
	For nY:=1 to Len(aArray)
		If  aArray[nY,3] == cPlano
			nAmo1 += aArray[nY,1]
			nAmo2 += aArray[nY,2]
	    EndIF
	Next nY                      
	AADD(aRet,nAmo1)
	AADD(aRet,nAmo2)
Else                            
	AADD(aRet,aArray[nLoop1,1])
	AADD(aRet,aArray[nLoop1,2])
EndIf

Return(aRet)  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215VPOL   ³ Autor ³ Cleber Souza       ³ Data ³ 22/09/04  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Verifica se eh um campo que utiliza valores em polegadas.	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ NIL  													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 = True se for polegada.						  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215									                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215VPOL()
            
Local lRet  := .F.
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

If lLayout
	If At('i',aResultados[nOperacao,_ENS,nFldLab,nEnsaio,VLRNOM]) > 0
		lRet := .T.
	EndIf
Else
	If At('i',aResultados[nPosOper,_ENS,nPosLab,oBrwJJ:nAT,VLRNOM]) > 0
		lRet := .T.
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³QP215FilU ³ Autor ³Cleber Souza           ³ Data ³09/09/2004³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Filtra as Filiais para selecao do Usuario responsavel      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ QIPA215 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215FilU()
Local aHeadEns   := {}
Local nAcPosFilM := 0
Local cFiltro    := ""

If GetMv("MV_QPTRLAY",.F.,"1") == "1"
	aHeadEns   := aSavHeadEns[nOperacao,nFldLab,nEnsaio]
Else	
	aHeadEns   := aSavHeadEns[nPosOper,nPosLab,nPosEns]
EndIf
	
nAcPosFilM := Ascan(aHeadEns[1],{|x|Alltrim(x[2])=="QPR_FILMAT"}) 
If GetMv("MV_QPTRLAY",.F.,"1") == "1"
	cFiltro    := If(Empty(aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,nAcPosFilM]),xFilial("QAA"),aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:aCols[aOBJETOS[OBJ_MEDICA,nOperacao,nFldLab,nEnsaio]:nAT,nAcPosFilM])
Else
	cFiltro    := If(Empty(aCols[oGetMed:nAT,nAcPosFilM]),xFilial("QAA"),aCols[oGetMed:nAT,nAcPosFilM])
EndIf

Return(cFiltro)     

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³QP215CalPol³ Autor ³Cleber Souza          ³ Data ³ 02/12/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida os Campos AFI,AFS,LIC e LSC, quando  os mesmos forem³±±
±±³          ³ informados em polegadas.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPC1 - Campo que sera feita a validacao					  ³±±
±±³          ³ EXPL1 - Define se valor esta em polegada					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ EXPL1 - Resultado da Validacao							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215  		   										  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Function QP215CalPol(cCampo,lVlrPol)
Local cVar     := ""
Local nPosNml  := 0
Local nPosAsp  := 0
Local nPosBar  := 0
Local lRetorno := .T.
Local nOcoAsp  := 0
Local nOcoBar  := 0
Local nOcoDes  := 0
Local nIntPol  := 0
Local nDecPol  := 0
Local nX       := 0               

Default lVlrPol := .T.
 
cVar    := If(ValType(cCampo)=="N",Lower(AllTrim(Str(cCampo))),Lower(AllTrim(cCampo)))
nPosNml := At('i',cVar)

If nPosNml == 0 .Or. !lVlrPol
	lRetorno := .T.
Else                                    
	If nPosNml+1 < Len(AllTrim(cVar)) .And. !IsDigit(Substr(cVar,nPosNml+1,1))
		Help(" ",1,"QPH215007")  //Valor em polegada está incorreto. 
		lRetorno := .F.
	Else
		If !( At('"',cVar) > 0 .Or. At("'",cVar) > 0 )
			If !Empty(cVar)
				If nPosNml > 0    
					For nX := 1 to Len(cVar)
						If     SubStr(cVar,nX,1) == 'i'
							nOcoAsp++
						ElseIf SubStr(cVar,nX,1) == '/' 			
							nOcoBar++
						ElseIf !IsDigit(SubStr(cVar,nX,1)) 
						    nOcoDes++
						EndIf
					Next 
					If nOcoAsp > 1 .Or. nOcoAsp == 0 .Or. nOcoBar > 1 .Or.;
					   nOcoDes > 1 .Or. At(" ",cVar) > 0
		    			lRetorno := .F.
					Else
						nPosAsp := At('i',cVar)
						nPosBar := At('/',cVar)	        
						If nPosBar > 0
							If nPosBar > nPosAsp
								nIntPol := Val(SubStr(cVar,nPosAsp+1,nPosBar-(nPosAsp-1)))
								nDecPol := Val(SubStr(cVar,nPosBar+1,Len(cVar)-nPosbar))
							Else
							    nIntPol := Val(SubStr(cVar,1,nPosBar-1))
							    nDecPol := Val(SubStr(cVar,nPosBar+1,nPosAsp-(nPosBar-1)))
							EndIf		              
							If nDecPol == 0 
								lRetorno := .F.
							Else                
								If lVlrPol 
									nResto := 128%nDecPol
									If nResto > 0
										lRetorno := .F.
									EndIf               
								EndIf	
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			lRetorno := .F.      
		EndIf
	EndIf
EndIf
Return(lRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIP215SXB º Autor ³Cicero Odilio Cruz  º Data ³ 22/07/2005  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Refaz o SXB se o mesmo tiver sem a referencia em sua chama-º±±
±±º          ³ da                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QIP215SXB()
Local aArea := GetArea()
Local nAux := ""
dbSelectArea("SXB")
dbSetOrder(1)
dbSeek("QIY   20202")
If !EOF()
    RecLock("SXB",.F.)
    SXB->XB_COLUNA := "03"
	MsUnLock()
EndIf
dbSeek("QIY   40101")
Do While !EOF() .AND. Alltrim(SXB->XB_ALIAS) == "QIY"
	If Left(SXB->XB_CONTEM,4) == "QAA_"
    	nAux := SXB->XB_CONTEM
	    RecLock("SXB",.F.)
	    SXB->XB_CONTEM := "QAA->"+nAux
		MsUnLock()
	    dbSkip()
	Else
	    dbSkip()
	EndIf
EndDo   
RestArea(aArea)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215RightMe³Autor³Cleber Cousa           ³ Data ³23/08/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Posiciona o foco na coluna da medição conforme parametro	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Q215EditaMed()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ EXPN1 = Posicao atual da Operacao   					      ³±±
±±³          ³ EXPN2 = Posicao atual do Laboratorio	                      ³±±
±±³          ³ EXPN2 = Posicao atual do Ensaio   	                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ QIPA215													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215RightMe(nOpe,nLab,nEns)

Local nRight := GetMv("MV_QPPOSFO",.F.,5)
Local nY     := 0

//Posiciona na primeira coluna
aOBJETOS[OBJ_MEDICA,nOpe,nLab,nEns]:oBrowse:nColPos:=1

For nY:=1 to nRight
	aOBJETOS[OBJ_MEDICA,nOpe,nLab,nEns]:oBrowse:GoRight()
Next nY

Return() 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao	 ³QP215Seq    ³ Autor ³Cleber Souza           ³ Data ³ 12/09/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Verifica a sequencia das medicoes                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Cadastro de Resultados								        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function QP215Seq(oGet)
Local nC		:= 0
Local nCount1	:= 0

For nC := 1 To Len(oGet:aCols)
	If !oGet:aCols[nC,Len(oGet:aCols[nC])]
		nCount1++
	EndIf
Next nC
cTexSeq := STR0220+ StrZero(oGet:nAT,3)+ STR0221 + StrZero(nCount1,3) //"Medicao : "### " de "
aOBJETOS[OBJ_SEQ,nOperacao,nFldLab,1]:Refresh()
Return(.t.) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³QP215WhRej³ Autor ³ Rafael S.Bernardi     ³ Data ³10/11/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata When do campo de quantidade rejeitada   			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1 - Obejeto do campo editado							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³.T. ou .F.												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215WhRej()   
Local lRetorno := .T.  

If ReadVar() <> "M->QPL_QTREJ"
	Return(lRetorno)
EndIf

If lRetorno
	If !Empty(M->QPL_LAUDO)
   		//Verifica se o Laudo esta aprovado
		If M->QPL_LAUDO == "E" .Or. M->QPL_LAUDO == "A"
	      lRetorno := .F.
		EndIf
	EndIf      
EndIf

Return(lRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Renata Cavalcante   º Data ³  07/23/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste da consulta padrão QAD                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Ajuste da consulta padrão QAD                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSXB()
Local aArea := GetArea()
Local aPesq	:= {}
Local nI	:= 0

dbSelectArea("SXB")
dbSetOrder(1)
If dbSeek( "QED   40102" )
	RecLock("SXB",.F.)
		Replace XB_CONTEM With 'IIF(__LANGUAGE == "PORTUGUESE", QED->QED_DESCPO,IIF(__LANGUAGE == "SPANISH", QED->QED_DESCES,QED->QED_DESCIN))'
	MsUnLock()
Endif     

dbSelectArea("SXB")
dbSetOrder(1)
If dbSeek( "QIY   6" )
	If SXB->XB_CONTEM <> 'QA_SITFOLH().AND. !EMPTY(QAA->QAA_APELID)'
		RecLock("SXB",.F.)
			Replace XB_CONTEM With 'QA_SITFOLH().AND. !EMPTY(QAA->QAA_APELID)'
		MsUnLock()
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Consulta Operacoes                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aPesq,{"QQK04", "1", "01", "DB", "Consulta Operacoes"  ,"Consulta Operaciones","Search Operations","QQK"               })
Aadd(aPesq,{"QQK04", "2", "01", "01", "Codigo"              ,"Codigo"              ,"Code"             ,""                  })
Aadd(aPesq,{"QQK04", "4", "01", "01", "Operacao"            ,"Operacion"           ,"Operation"        ,"QQK_OPERAC"        })
Aadd(aPesq,{"QQK04", "4", "01", "02", "Descricao Operacao"  ,"Descripcion Operac. ","Operation Desc."  ,"QQK_DESCRI"        })
Aadd(aPesq,{"QQK04", "5", "01", " " , " "                   ," "                   ," "                ,"QQK->QQK_OPERAC"   })
Aadd(aPesq,{"QQK04", "6", "01", " " , " "                   ," "                   ," "                ,"QQK->QQK_PRODUT == QP6->QP6_PRODUT .AND. QQK->QQK_REVIPR == QP6->QP6_REVI"})
Aadd(aPesq,{"QQK04", "6", "02", " " , " "                   ," "                   ," "                ,"QQK->(dbGoTop())"  })

If !dbSeek(PadR("QQK04",6))
	For nI := 1 To Len(aPesq)
		RecLock("SXB",.T.)
		SXB->XB_ALIAS	:= aPesq[nI,1]
		SXB->XB_TIPO	:= aPesq[nI,2]
		SXB->XB_SEQ 	:= aPesq[nI,3]
		SXB->XB_COLUNA	:= aPesq[nI,4]
		SXB->XB_DESCRI	:= aPesq[nI,5]
		SXB->XB_DESCSPA	:= aPesq[nI,6]
		SXB->XB_DESCENG	:= aPesq[nI,7]
		SXB->XB_CONTEM	:= aPesq[nI,8]
		MsUnlock()
	Next
EndIf             

dbSelectArea("SXB")
dbSetOrder(1)
If dbSeek("QQG   50101")
	IF SXB->XB_CONTEM <> "IIF(cArq='QEL',QEL->QEL_LOTE,QPL->QPL_LOTE)"
		RecLock("SXB",.F.)
	   	Replace XB_CONTEM With "IIF(cArq='QEL',QEL->QEL_LOTE,QPL->QPL_LOTE)"
		MsUnLock()
	Endif
Endif     

dbSelectArea("SXB")
dbSetOrder(1)
If !dbSeek("QQG   50102")
	RecLock("SXB",.T.)
	SXB->XB_ALIAS	:= "QQG   "
	SXB->XB_TIPO	:= "5"
	SXB->XB_SEQ 	:= "01"
	SXB->XB_COLUNA	:= "02"
	SXB->XB_CONTEM	:= "IIF(cArq=='QEL',QEL->QEL_LAUDO,QPL->QPL_LAUDO)"
	MsUnlock()
Endif
RestArea( aArea )
Return Nil    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³AjustaSX3 ³ Autor ³ Renata Cavalcante     ³ Data ³23/07/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Altera o título do campo o QPL_TAMLOT            			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Void                             							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³NIL       												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³QIPA215				                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX3()
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"
Local aArea  	:= GetArea()
Local nIndex 	:= SX3->(IndexOrd())
Local cLaudo 	:= " "

cLaudo := STR0233

dbSelectArea("SX3")
dbSetOrder(2)

If dbSeek("QPL_TAMLOT")
	RecLock("SX3",.F.)
	SX3->X3_TITSPA:= "Tamano Lote"
	MsUnlock()
EndIf         

IF DbSeek("QPQ_MEDICA")
	IF Alltrim(X3_VALID)!="QP215VLDMED()"
		Reclock("SX3",.F.)
		X3_VALID  := "QP215VLDMED()"
		MSUNLOCK()	
    ENDIF
Endif     
IF DbSeek("QPQ_RESULT")
	If lLayout
		IF Alltrim(X3_VALID)!="QPQ_VALID() .And. Pertence2('AR',,'" +STR0233 + "') .AND. QP215METOD(nOperacao,nFldLab,nEnsaio)"
			Reclock("SX3",.F.)
			X3_VALID  := "QPQ_VALID() .And. Pertence2('AR',,'" +STR0233 + "') .AND. QP215METOD(nOperacao,nFldLab,nEnsaio)"
			MSUNLOCK()	
	    ENDIF
	Else
		IF Alltrim(X3_VALID)!="QPQ_VALID() .And. Pertence2('AR',,'" +STR0233 + "') .AND. QP215METOD(nPosOper,nPosLab,nPosEns)"
			Reclock("SX3",.F.)
			X3_VALID  := "QPQ_VALID() .And. Pertence2('AR',,'" +STR0233 + "') .AND. QP215METOD(nPosOper,nPosLab,nPosEns)"
			MSUNLOCK()	
	    ENDIF	
	Endif       
EndIf

IF DbSeek("QPS_MEDICA")
	IF Alltrim(X3_VALID)!="QPQ_VALID().AND. QA_CALPOL(M->QPS_MEDICA,QP215VPOL()) .AND. QP215COMED(M->QPS_MEDICA)"
		Reclock("SX3",.F.)
		X3_VALID  := "QPQ_VALID().AND. QA_CALPOL(M->QPS_MEDICA,QP215VPOL()) .AND. QP215COMED(M->QPS_MEDICA)"
		MSUNLOCK()	
    ENDIF
Endif                  
    
IF DbSeek("QQG_LOTE")
	IF SX3->X3_TRIGGER<> "S"
		Reclock("SX3",.F.)
		SX3->X3_TRIGGER  := "S"
		MSUNLOCK()	
    ENDIF
Endif      
                    

SX3->(dbSetOrder(nIndex))

RestArea(aArea)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QPQ_VALID ºAutor  ³Adalberto M. Neto   º Data ³  24/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que vai estar no X3_VALID do campo QPQ_RESULT, pois º±±
±±º          ³ o tamanho do campo nao suportou varias funcoes             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QPQ_RESULT - X3_VALID                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QPQ_VALID()
Local lRet := .F.
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"

lRet := QP215VLDMED()

If lRet .and. !empty(Iif(lLayout,aResultados[nOperacao,_ENS,nFldLab,nEnsaio,TEXTO],aResultados[nPosOper,_ENS,nPosLab,oBrwJJ:nAT,TEXTO]))
	lRet := QP215RTXT()
Endif

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Renata Cavalcante   º Data ³  09/19/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação das medições digitadas                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Validação das medições                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function QP215OkMed()     
Local nX,ny,nz 
Local lReturn:=.T. 
Local lLayout	:= GetMv("MV_QPTRLAY",.F.,"1") == "1"          

If !lLayout
	nOperacao := nPosOper
	nFldLab   := nPosLab
	nEnsaio   := nPosEns
EndIf

For nz:= 1 To Len(aResultados[nOperacao,_ENS])
	For nX := 1 To Len(aResultados[nOperacao,_ENS,nz])  
		cCarta  := aResultados[nOperacao,_ENS,nz,nx,CARTA]
				
		If cCarta == "P  "
			nPosMed  := Ascan(aSavHeadEns[nOperacao,nz,nx,1],{|x|Alltrim(x[2])=="QPS_MEDIPA"})
		ElseIf cCarta == "TXT"
			nPosMed  := Ascan(aSavHeadEns[nOperacao,nz,nx,1],{|x|Alltrim(x[2])=="QPQ_MEDICA"})
		Else
			nPosMed  := Ascan(aSavHeadEns[noperacao,nz,nx,1],{|x|Alltrim(x[2])=="QPS_MEDICA"})
		EndIf   
		      	
		For nY := 1 to Len(aResultados[nOperacao,_MED,nz,nX]) 
			If !Empty(aResultados[nOperacao,_MED,nz,nX,nY,nPosMed])                      
				lReturn:=QP215ChkMed(nOperacao,nz,nx,,ny,aResultados[nOperacao,_ENS,nz,nx,CARTA],1,.F.,.F.,.T.)                       
				IF !lReturn
					MessageDlg(STR0234+aResultados[nOperacao,_ENS,nz,nx,ENSAIO],,3)//"Existem medições não informadas no ensaio "
					exit
				ENDIF
			Endif
		Next ny
		If !(lReturn)
			exit
		Endif
	Next nx 
	If !(lReturn)
		exit
	Endif                                                        
Next nz

Return(lReturn)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Renata Cavalcante   º Data ³  02/15/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada no Gatilho para Rastreabilidade           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Função utilizada no Gatilho para Rastreabilidade           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Function QP215GAT()
LOCAL nPosOrig	 := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_ORIGEM'})
Local aCols      := oGetRast:aCols
Local n          := oGetRast:nAT            
Local nPosLote	 := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_LOTE'}) 
Local nPosPrd	 := Ascan(aSavaHeader[HEAD_RASTRO],{|x| AllTrim(x[2]) == 'QQG_PRODUT'}) 
Local cRet		 := ""    
Local aArea		 := GetArea()


If aCols[n,nPosOrig] == "1"		//Serah utilizado a pesquisa no SIGAQIE
	DbSelectArea("QEL") 
	cArquivo := CriaTrab(,.F.)

	cChave := "QEL_FILIAL+QEL_PRODUTO+QEL_LOTE"

	IndRegua("QEL",cArquivo,cChave,,)

	DbSelectArea("QEL")

	nIndex := RetIndex("QEL")

	#IFNDEF TOP

	DbSetIndex(cArquivo+OrdBagExt())

	#ENDIF

	DbSetOrder(nIndex+1)
	
	If DbSeek(xFilial("QEL")+aCols[n,nPosPrd]+M->QQG_LOTE)
		If QEL->QEL_LOTE == M->QQG_LOTE 
			cRet:=QEL->QEL_LAUDO
		Endif
	Endif  

Else
	cArq:="QPL"    
	DbSelectArea("QPL") 
		cArquivo := CriaTrab(,.F.)

	cChave := "QPL_FILIAL+QPL_PRODUTO+QPL_LOTE"

	IndRegua("QPL",cArquivo,cChave,,)

	DbSelectArea("QPL")

	nIndex := RetIndex("QPL")

	#IFNDEF TOP

	DbSetIndex(cArquivo+OrdBagExt())

	#ENDIF 

	DbSetOrder(nIndex+1)
	If DbSeek(xFilial("QPL")+aCols[n,nPosPrd]+M->QQG_LOTE)
		If QPL->QPL_LOTE == M->QQG_LOTE
			cRet:=QPL->QPL_LAUDO
		Endif
	Endif
EndIf              

RestArea(aArea)
Return(cRet)  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Renata Cavalcante   º Data ³  02/15/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Criação de Gatilho para Rastreabilidade                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Criação de Gatilho para Rastreabilidade                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static function AjustaSX7
Local cSeq	 :="0"        
Local aArea  :=GetArea()      
Local lAchou :=.F.

dbSelectArea("SX7")
dbSetOrder(1)
If dbSeek("QQG_LOTE")
    While SX7->(!Eof()) .AND. ALLTRIM(SX7->X7_CAMPO) == "QQG_LOTE"
    	If (Alltrim(SX7->X7_CDOMIN) == "QQG_LAUDO" .AND. Alltrim(SX7->X7_REGRA) == "QP215GAT()") 
    		lAchou:=.T.
    	Endif
    	cSeq:= SX7->X7_SEQUENC
        SX7->(DbSkip())
    Enddo              	    
Endif

IF !lAchou

	Reclock("SX7",.T.)  
	SX7->X7_CAMPO  := "QQG_LOTE"  
	SX7->X7_SEQUENC:= STRZERO(val(cSeq)+1,3)
	SX7->X7_REGRA  := "QP215GAT()"
	SX7->X7_CDOMIN := "QQG_LAUDO" 
	SX7->X7_TIPO   := "P"
	SX7->X7_SEEK   := "N"
	SX7->X7_PROPRI := "S"			
	MsUnLock()    
	
Endif
			
RestArea(aArea)	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QIPA215   ºAutor  ³Iolanda Vilanova   º Data ³  18/09/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Efetua a chamada do relatorio padrao ou do usuario          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ QIPA215                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Q215Impri(nOpt, aOpcoes)

If ExistBlock("QIPIMPR")
	ExecBlock("QIPIMPR",.f.,.f.)
Else	
	QIPR170(nOpt, aOpcoes)
Endif 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³QP215DpEnsºAutor  ³Cicero Odilio Cruz  º Data ³  02/18/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Estabelece a Dependencia em segundo                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Function QP215DpEns(cEnsaio, aEns, nPosEnsa)
Local   nCEns      := 0    // Posição do Ensaio Analisaso
Local   nPosAt     := 0    // Posição do Ensaio Pai
Local   nPosFor    := 0    // Utilizada na seperação do Ensaios que compoem a formula
Local   nPosEnsCal := 0    // Posição do Ensaio no aResultados
Local   nX         := 0	   // Variavel do For
Local   cFormul    := ""   // Formula 
Local   lCarAll    := .F.  // Indica se analisa todos os ensaios 
Local   aEnsCal    := {}

If ValType(cEnsaio) == "U"
	lCarAll  := .T.
EndIf

Default aEns     := {} 
Default nPosEnsa := 1

If lCarAll
	For nCEns := nPosEnsa To Len(aResultados[nPosOper,_ENS, nPosLab])                 
		aEns := aClone(QP215DpEns(aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO], @aEns, nCEns))
	Next
Else
	For nCEns := nPosEnsa+1 To Len(aResultados[nPosOper,_ENS, nPosLab])
		cFormul := ""
		QP1->(dbSetOrder(1))
		If QP1->(MsSeek(xFilial("QP1")+aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO]))
			If QP1->QP1_TIPO == "C"
				QP7->(dbSetOrder(1))                                                  
				If QP7->(dbSeek(xFilial("QP7")+QPK->(QPK_PRODUT+QPK_REVI+cRoteiro)+cOper+aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO]))
		 			cFormul := AllTrim(QP7->QP7_FORMUL)
		 			nDecimal := QA_NumDec(QP7->QP7_NOMINA)
				EndIf
			EndIf
		EndIf
		If !Empty(cFormul) .AND. cEnsaio $ cFormul
			If At("#",cFormul) > 0
			    For nX := 1 to Len(cFormul)
			    	nPosFor    := At("#",cFormul)
			    	If nPosFor == 0
						Exit
			    	EndIf	
			    	nPosEnsCal := Ascan(aResultados[nPosOper,_ENS,nPosLab],{|x|x[ENSAIO]==aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO]})

			  	    If SubStr(cFormul,nPosFor+1,8) <> aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO]
						//aEnsAux := QP215DpEns(SubStr(cFormul,nPosFor+1,8), Nil, nCEns)
			    		If aScan(aEnsCal,{|x| x[1] == aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO]}) <= 0
			    			Aadd(aEnsCal,{aResultados[nPosOper,_ENS,nPosLab,nCEns,ENSAIO],nPosEnsCal/*,aEnsAux*/})
			    		EndIf
					EndIf
			   	
			    	cFormul := Stuff(cFormul,1,nPosFor+10,Space(nPosFor+10))
			    	nX      := (nPosFor+10)
			    Next nX
			EndIf
			nPosAt := aScan(aEns,{|x| x[1] == cEnsaio})
			If nPosAt == 0
				Aadd(aEns,{cEnsaio,aEnsCal})
			EndIf
		EndIf
	Next
EndIf
		
Return aEns
