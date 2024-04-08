#INCLUDE "PROTHEUS.CH"

Static __aInfoTable__

/*/
зддддддддддбдддддддддддбдддддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁMrkOpcoes  Ё Autor Ё Marinaldo de Jesus   Ё Data Ё14/08/2006Ё
цддддддддддедддддддддддадддддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁListBox com a Selecao dos Motivos de Abono do Ponto			Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁGenerico                                                    Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   Ё.T. por ser Utilizado em Validacao                          Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
User Function MrkOpcoes(;
							cAlias 			,;	//01 -> Alias
							cField 			,;	//02 -> Campo de Codigo
							cFieldDesc		,;	//03 -> Campo que contem a descricao
							l1Elem			,;	//04 -> Se serА permitido selecionar apenas um unico elemento
							nMaxElem		,;	//05 -> Maximo de Elementos para Selecao
							cFilter			,;	//06 -> Se Devera Filtar a Tabela para a carga das informacoes
							cPreSelect		,;	//07 -> Elementos que ja foram pre-selecionados
							cTitulo			,;	//08 -> Titulo para f_Opcoes
							lMultSelect		,;	//09 -> Inclui Botoes para Selecao de Multiplos Itens
							lComboBox		,;	//10 -> Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
							lNotOrdena		,;	//11 -> Nao Permite a Ordenacao
							lNotPesq		,;	//12 -> Nao Permite a Pesquisa	
							lForceRetArr    ,;	//13 -> Forca o Retorno Como Array
							cF3				 ;	//14 -> Consulta F3
						 )

Local aPreSelect	:= {}
Local aOpcoes		:= {}
Local cFil			:= xFilial( cAlias )
Local cMvPar		:= &( Alltrim( ReadVar() ) )
Local cMvParDef		:= ""
Local cMvRetor		:= ""
Local cMvParam		:= ""
Local cReplicate	:= ""
Local cFieldFil
Local lFilExistField
Local nFor			:= 0
Local nLenFor		:= Len( AllTrim( cMvPar ) )
Local nTamCpo		:= 0
Local nInfoTable

DEFAULT l1Elem 			:= .F.
DEFAULT cPreSelect		:= ""
DEFAULT cMvPar			:= SetMemVar( "__NoExistVar__" , "" , .T. )
DEFAULT lMultSelect		:= .T.
DEFAULT lComboBox		:= .F.
DEFAULT lNotOrdena		:= .F.
DEFAULT lNotPesq		:= .F.
DEFAULT lForceRetArr    := .F.
DEFAULT cF3				:= cAlias

cField		:= Upper( AllTrim( cField ) )
nTamCpo		:= GetSx3Cache( cField , "X3_TAMANHO" )
cReplicate  := Replicate( "*" , nTamCpo )

CursorWait()

	IF !( l1Elem )
		nLenFor := Len( AllTrim( cMvPar ) )
		For nFor := 1 To nLenFor
			cMvParam += SubStr( cMvPar , nFor , nTamCpo )
			cMvParam += cReplicate
		Next nFor
	EndIF
	cMvPar := cMvParam

	lFilExistField	:= FilExistField( cAlias , @cFieldFil )

	DEFAULT __aInfoTable__	:= {}
	IF ( ( nInfoTable := aScan( __aInfoTable__ , { |x| x[1] == cAlias } ) ) == 0 )
		aAdd( __aInfoTable__ , { cAlias , NIL , {} } )
		nInfoTable := Len( __aInfoTable__ )
	EndIF

	IF ( Empty( __aInfoTable__[ nInfoTable , 3 ] ) )
		IF ( lFilExistField )
			( cAlias )->( dbSetOrder( RetOrder( cAlias , cFieldFil + cField ) ) )
		Else
			( cAlias )->( dbSetOrder( RetOrder( cAlias , cField ) ) )
		EndIF	
		BldaMrkOpcoes( @cAlias , @cFil , @cField , @cFieldDesc , @cFieldFil , @cFilter , @__aInfoTable__ , @nInfoTable )
	EndIF	

	nLenFor := Len( cPreSelect )
	For nFor := 1 To Len( cPreSelect ) Step nTamCpo
		aAdd( aPreSelect , SubStr( cPreSelect , nFor , nTamCpo ) )
	Next nFor
	
	nLenFor := Len( __aInfoTable__[ nInfoTable , 3 ] )
	For nFor := 1 To nLenFor
		IF ( aScan( aPreSelect , SubStr( __aInfoTable__[ nInfoTable , 3 , nFor ] , 1 , nTamCpo ) ) == 0 )
			cMvParDef += SubStr( __aInfoTable__[ nInfoTable , 3 , nFor ] , 1 , nTamCpo )
			aAdd( aOpcoes , __aInfoTable__[ nInfoTable , 3 , nFor ] )
		EndIF
	Next nFor

CursorArrow()

IF (;
		Empty( cTitulo );
		.and.;
		GetCache( "SX2" , cAlias , NIL , NIL , 1 , .T. );
	)	
	cTitulo := GetCache( "SX2" , cAlias , NIL , "X2Nome()" , 1 , .F. )
EndIF

DEFAULT nMaxElem	:= Len( aOpcoes )

IF f_Opcoes(;
				@cMvPar 		,;	//01 -> Variavel de Retorno
				cTitulo   		,;	//02 -> Titulo da Coluna com as opcoes
				aOpcoes   		,;	//03 -> Opcoes de Escolha (Array de Opcoes)
				cMvParDef 		,;	//04 -> String de Opcoes para Retorno
				NIL				,;	//05 -> Nao Utilizado
				NIL				,;	//06 -> Nao Utilizado
				l1Elem			,;	//07 -> Se a Selecao sera de apenas 1 Elemento por vez
				nTamCpo			,;	//08 -> Tamanho da Chave
				nMaxElem		,;	//09 -> No maximo de elementos na variavel de retorno	
				lMultSelect		,;	//10 -> Inclui Botoes para Selecao de Multiplos Itens
				lComboBox		,;	//11 -> Se as opcoes serao montadas a partir de ComboBox de Campo ( X3_CBOX )
				cField			,;	//12 -> Qual o Campo para a Montagem do aOpcoes
				lNotOrdena		,;	//13 -> Nao Permite a Ordenacao
				lNotPesq		,;	//14 -> Nao Permite a Pesquisa	
				lForceRetArr    ,;	//15 -> Forca o Retorno Como Array
				cF3				 ;	//16 -> Consulta F3
			 )

	CursorWait()

		nLenFor := Len( cMvPar )
		For nFor := 1 To nLenFor Step nTamCpo
			IF ( SubStr( cMvpar , nFor , nTamCpo ) # cReplicate )
				cMvRetor += SubStr( cMvPar , nFor , nTamCpo )
			EndIF
		Next nFor

		&( Alltrim( ReadVar() ) ) := AllTrim( cMvRetor )

	CursorArrow()

EndIF

Return( .T. )

/*/
зддддддддддбдддддддддддддбдддддбддддддддддддддддддддддбддддддбдддддддддд©
ЁFun┤└o    ЁBldaMrkOpcoesЁAutorЁMarinaldo de Jesus    Ё Data Ё14/08/2006Ё
цддддддддддедддддддддддддадддддаддддддддддддддддддддддаддддддадддддддддд╢
ЁDescri┤└o ЁCarregar as Opcoes para a f_Opcoes() em U_MrkOpcoes()		Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁSintaxe   Ё<vide parametros formais>									Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁUso       ЁU_MrkOpcoes()												Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁRetorno   ЁNIL                                                         Ё
цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
ЁParametrosЁ<vide parametros formais>									Ё
юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды/*/
Static Function BldaMrkOpcoes(;
									cAlias		,;	//01 -> Apelido da Tabela
									cFil		,;	//02 -> Filial
									cField		,;	//03 -> Campo de Codigo
									cFieldDesc	,;	//04 -> Campo de Descricao
									cFieldFil	,;	//05 -> Campo da Filial
									cFilter		,;	//06 -> Filtro a Ser Executado para a Carga das Informacoes
									aInfoTable	,;	//07 -> Array com Informacoes da Tabela
									nInfoTable	 ;	//08 -> Posicao da Tabela no Array
							  )

Local aArea		:= GetArea()
Local aQuery	:= {}
Local aHeader	:= {}
Local aIndex	:= {}

Local bAscan	:= { |x| ( x == cCpoDes ) } 
Local bSkip		:= { || .F. }
Local cCntCpo	:= ""
Local cCpoDes	:= ""

Begin Sequence

	IF ( ( cAlias )->( FieldPos( cField ) ) == 0 )
		Break
	EndIF

	bSkip	:= { || (;
						cCpoDes := (;
										( cCntCpo := &( cField ) )	+ ;
										" - "						+ ;
										&( cFieldDesc )				  ;
										);
						 ),;
						 IF( aScan( aInfoTable[ nInfoTable , 3 ] , bAscan ) == 0 .and. !Empty( cCntCpo ),;
						 	 aAdd( aInfoTable[ nInfoTable , 3 ] , cCpoDes ),;
						 	 NIL;
						 	),;
						 (;
						 	cCntCpo	:= "" ,;
						 	.F.;
						 );	
					}

	IF !Empty( aInfoTable[ nInfoTable , 2 ] )
		aHeader := aInfoTable[ nInfoTable , 2 ]
	EndIF	

	#IFDEF TOP
		IF (;
				( cAlias )->( RddName() == "TOPCONN" );
				.and.;
				Empty( cFilter );
			)	
			IF !Empty( cFieldFil )
				aQuery		:= Array( 03 )
				aQuery[01]	:= cFieldFil+"='"+cFil+"'"
				aQuery[02]	:= " AND "
				aQuery[03]	:= "D_E_L_E_T_<>'*' "
			EndIF
		EndIF
	#ENDIF

	IF !Empty( cFilter )

		( cAlias )->( FilBrowse( cAlias , @aIndex , cFilter ) )

	EndIF

	( cAlias )->( GdBuildCols(	aHeader			,;	//01 -> Array com os Campos do Cabecalho da GetDados
								NIL				,;	//02 -> Numero de Campos em Uso
								NIL				,;	//03 -> [@]Array com os Campos Virtuais
								NIL				,;	//04 -> [@]Array com os Campos Visuais
								NIL				,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
								{				 ;
									cFieldFil	,;
									cField		,;
									cFieldDesc	 ;
								}				,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
								NIL				,;	//07 -> [@]Array unidimensional contendo os Recnos
								cAlias			,;	//08 -> Alias do Arquivo Pai
								cFil			,;	//09 -> Chave para o Posicionamento no Alias Filho
								NIL				,;	//10 -> Bloco para condicao de Loop While
								bSkip			,;	//11 -> Bloco para Skip no Loop While
								.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols 
								.F.				,;	//13 -> Se Sera considerado o Inicializador Padrao
								.F.				,;	//14 -> Opcional, Carregar Todos os Campos
								.F.				,;	//15 -> Opcional, Nao Carregar os Campos Virtuais
								aQuery			,;	//16 -> Opcional, Utilizacao de Query para Selecao de Dados
								.F.				,;	//17 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
								.T.				,;	//18 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
								.F.				,;	//19 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
								.T.				,;	//20 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
								.F.				,;	//21 -> Verifica se Deve Checar se o campo eh usado
								.F.				,;	//22 -> Verifica se Deve Checar o nivel do usuario
								.F.				 ;	//23 -> Verifica se Deve Carregar o Elemento Vazio no aCols
					   		);
		         )

		IF !Empty( cFilter )

			( cAlias )->( EndFilBrw( cAlias , @aIndex ) )

		EndIF

		IF !Empty( aInfoTable[ nInfoTable , 2 ] )
			aInfoTable[ nInfoTable , 2 ] := aHeader
		EndIF

End Sequence

RestArea( aArea )

Return( NIL )