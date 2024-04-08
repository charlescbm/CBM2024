#INCLUDE "MATR320.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR320  � Autor � Nereu Humberto Junior � Data � 30/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Resumo das entradas e saidas                                ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RESTR23()
*********************
Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	U_MATR320R3()
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �23.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection1
Local oCell         
Local cTamVlr  := 18
Local cPictVl  := PesqPict("SD2","D2_CUSTO1",18)
//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//�������������������������������������������������������������������
If !(FindFunction("SIGACUSA_V") .And. SIGACUSA_V() >= 20060321)
    Final("Atualizar SIGACUSA.PRX !!!")
EndIf

//��������������������������������������������������������������Ŀ
//� Ajusta Grupo de Perguntas                                    �
//����������������������������������������������������������������
AjustaSX1()

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR320",STR0001,"MTR320", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003+" "+STR0004) //"Resumo das Entradas e Saidas"##"Este programa mostra um resumo ,por tipo de material ,de todas  as  suas"##"entradas e saidas. A coluna SALDO INICIAL  e' o  resultado da  soma  das"##"outras colunas do relatorio e nao o saldo inicial cadastrado no estoque."
oReport:SetLandscape()    
oReport:SetTotalInLine(.F.)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Almoxarifado De                              �
//� mv_par02     // Almoxarifado Ate                             �
//� mv_par03     // Tipo inicial                                 �
//� mv_par04     // Tipo final                                   �
//� mv_par05     // Produto inicial                              �
//� mv_par06     // Produto Final                                �
//� mv_par07     // Emissao de                                   �
//� mv_par08     // Emissao ate                                  �
//� mv_par09     // moeda selecionada ( 1 a 5 )                  �
//� mv_par10     // Saldo a considerar : Atual / Fechamento      �
//� mv_par11     // Considera Saldo MOD: Sim / Nao               �
//� mv_par12     // Imprime OPs geradas pelo SIGAMNT? Sim / Nao  �
//����������������������������������������������������������������
Pergunte("MTR320",.F.)

oSection1 := TRSection():New(oReport,STR0034,{"SB1","SD1","SD2","SD3"}) //"Movimentacoes dos Produtos"
oSection1 :SetTotalInLine(.F.)
oSection1 :SetNoFilter("SD1")
oSection1 :SetNoFilter("SD2")
oSection1 :SetNoFilter("SD3")

TRCell():New(oSection1,"cTipant"	,"   ",/*Titulo*/			,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
oSection1:Cell("cTipant"):GetFieldInfo("B1_TIPO")
TRCell():New(oSection1,"nSalant"	,"   ",STR0016+CRLF+STR0017	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Saldo"##"Inicial"
TRCell():New(oSection1,"nCompras"	,"   ",STR0018				,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Compras"
TRCell():New(oSection1,"nReqCons"	,"   ",STR0019+CRLF+STR0020	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Movimentacoes"##"Internas"
TRCell():New(oSection1,"nReqProd"	,"   ",STR0021+CRLF+STR0022	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Requisicoes"##"para Producao"
TRCell():New(oSection1,"nReqTrans"	,"   ",STR0023				,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Transferencias"
TRCell():New(oSection1,"nProducao"	,"   ",STR0024				,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Producao"
TRCell():New(oSection1,"nVendas"	,"   ",STR0025				,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Vendas"
TRCell():New(oSection1,"nReqOutr"	,"   ",STR0026+CRLF+STR0027	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Transf. p/"##"Processo"
TRCell():New(oSection1,"nDevVendas"	,"   ",STR0028+CRLF+STR0025	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Devolucao de"##"Vendas"
TRCell():New(oSection1,"nDevComprs"	,"   ",STR0028+CRLF+STR0018	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Devolucao de"##"Compras"
TRCell():New(oSection1,"nEntrTerc"	,"   ",STR0029+CRLF+STR0030	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Entrada Poder"##"Terceiros"
TRCell():New(oSection1,"nSaiTerc"	,"   ",STR0031+CRLF+STR0030	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Saida Poder"##"Terceiros"
TRCell():New(oSection1,"nSaldoAtu"	,"   ",STR0032+CRLF+STR0033	,cPictVl,cTamVlr,/*lPixel*/,/*{|| code-block de impressao }*/,,,"RIGHT") //"Saldo"##"Atual"

TRFunction():New(oSection1:Cell("nSalant"   ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nCompras"  ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nReqCons"  ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nReqProd"  ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nReqTrans" ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nProducao" ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nVendas"   ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nReqOutr"  ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nDevVendas"),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nDevComprs"),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nEntrTerc" ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nSaiTerc"  ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
TRFunction():New(oSection1:Cell("nSaldoAtu" ),NIL,"SUM",/*oBreak*/,"",cPictVl,/*uFormula*/,.F.,.T.) 
	
Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor �Nereu Humberto Junior  � Data �21.06.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cAliasSDH)

Local oSection1:= oReport:Section(1) 
Local cSelectD1 := '', cWhereD1 := ''
Local cSelectD2 := '', cWhereD2 := ''
Local cSelectD3 := '', cWhereD3 := ''
Local cSelectB2 := '', cWhereB2 := ''
Local lContinua :=.T. 
Local lPassou   :=.F.
Local lTotal    :=.F.
Local nValor    := 0
Local cProduto  := ""
Local cFiltroUsr:= ""
Local nSalant,nCompras,nReqCons,nReqProd,nEntrTerc
Local nSaiTerc,cTipAnt,cCampo,cMoeda,nReqTrans,nProducao
Local nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
Local cSelect	:= ''
Local cSelect1	:= ''
Local aStrucSB1 := SB1->(dbStruct())      
Local cName		:= ""
Local nX        := 0


#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cAliasTop := ""
#ENDIF

cMoeda := LTrim(Str(mv_par09))
cMoeda := IIF(cMoeda=="0","1",cMoeda)
oReport:SetTitle( oReport:Title()+STR0007+AllTrim(GetMv("MV_SIMB"+cMoeda))+" - "+STR0035+dtoc(mv_par07,"ddmmyy")+STR0036+dtoc(mv_par08,"ddmmyy"))

oReport:NoUserFilter()  // Desabilita a aplicacao do filtro do usuario no filtro/query das secoes

cFiltroUsr := oSection1:GetAdvplExp()

dbSelectArea("SD2")
dbSetOrder(1)
nRegs := SD2->(LastRec())

dbSelectArea("SD3")
dbSetOrder(1)
nRegs += SD3->(LastRec())

dbSelectArea("SD1")
dbSetOrder(1)
nRegs += SD1->(LastRec())

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �	
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	
	cAliasTop := GetNextAlias()    

	//������������������������������������������������������������������������Ŀ
	//�Query do relatorio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	
    //�������������������������������������������������������������������Ŀ
    //�Esta rotina foi escrita para adicionar no select os campos         �
    //�usados no filtro do usuario quando houver, a rotina acrecenta      �
    //�somente os campos que forem adicionados ao filtro testando         �
    //�se os mesmo j� existem no select ou se forem definidos novamente   �
    //�pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  �
    //�de campos no select pois pelo fato da tabela SD1 ter muitos campos |
    //�e a query ter UNION, ao adicionar todos os campos do SD1 podera'   |
    //�derrubar o TOP CONNECT e abortar o sistema.                        |
    //���������������������������������������������������������������������	   	
	cSelect  := "B1_COD,B1_TIPO,B1_UM,B1_GRUPO,B1_DESC,"
	cSelect1 := "%"
	cSelect2 := "%"
	oSection1:GetAdvplExp()
    If !Empty(cFiltroUsr)
		For nX := 1 To SB1->(FCount())
			cName := SB1->(FieldName(nX))
		 	If AllTrim( cName ) $ cFiltroUsr
	      		If aStrucSB1[nX,2] <> "M"  
	      			If !cName $ cSelect
		        		cSelect1 += cName + "," 
		          	EndIf 	
		       	EndIf
			EndIf 			       	
		Next
		cSelect1 += "%"
    Endif    

	//������������������������������������������������������������������������Ŀ
	//�Complemento do SELECT da tabela SD1                                     �
	//��������������������������������������������������������������������������
	cSelectD1 := "% D1_CUSTO"
	If mv_par09 > 1
		cSelectD1 += Str(mv_par09,1,0) // Coloca a Moeda do Custo
	EndIf
	cSelectD1 += " CUSTO,"
	cSelectD1 += "%"
	
	//������������������������������������������������������������������������Ŀ
	//�Complemento do WHERE da tabela SD1                                      �
	//��������������������������������������������������������������������������
    cWhereD1 := "%"
	If cPaisLoc <> "BRA"
		cWhereD1 += " AND D1_REMITO = '" + Space(TamSx3("D1_REMITO")[1]) + "' "
	EndIf	
	cWhereD1 += "%"	
	
	//������������������������������������������������������������������������Ŀ
	//�Complemento do SELECT da tabela SD2                                     �
	//��������������������������������������������������������������������������
    cSelectD2 := "% D2_CUSTO"
	cSelectD2 += Str(mv_par09,1,0) // Coloca a Moeda do Custo
	cSelectD2 += " CUSTO,"
    cSelectD2 += "%"	

	//������������������������������������������������������������������������Ŀ
	//�Complemento do WHERE da tabela SD2                                      �
	//��������������������������������������������������������������������������
    cWhereD2 := "%"
	If cPaisLoc <> "BRA"
		cWhereD2 += " AND D2_REMITO = '" + Space(TamSx3("D2_REMITO")[1]) + "' "
	EndIf	
	cWhereD2 += "%"	
    
	//������������������������������������������������������������������������Ŀ
	//�Complemento do SELECT da tabelas SD3                                    �
	//��������������������������������������������������������������������������
	cSelectD3 := "% D3_CUSTO"
	cSelectD3 += Str(mv_par09,1,0) // Coloca a Moeda do Custo
	cSelectD3 +=	" CUSTO," 
	cSelectD3 += "%"    
	
	//������������������������������������������������������������������������Ŀ
	//�Complemento do WHERE da tabela SD3                                      �
	//��������������������������������������������������������������������������
    cWhereD3 := "%"
	If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
		cWhereD3 += " AND D3_ESTORNO <> 'S'"
	EndIf
	If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
		cWhereD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
		cWhereD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
	EndIf
	cWhereD3 += "%"	
	
	BeginSql Alias cAliasTop

		SELECT 	'SD1' ARQ, 				//-- 01 ARQ
				 SB1.B1_COD PRODUTO, 	//-- 02 PRODUTO
				 SB1.B1_TIPO, 			//-- 03 TIPO
				 SB1.B1_UM,   			//-- 04 UM
				 SB1.B1_GRUPO,      	//-- 05 GRUPO
				 SB1.B1_DESC,      		//-- 06 DESCR
 				 %Exp:cSelect1%			//-- 07 FILTRO COM CAMPOS DO USUARIO
				 D1_DTDIGIT DATA,		//-- 08 DATA
				 D1_TES TES,			//-- 09 TES
				 D1_CF CF,				//-- 10 CF
				 D1_NUMSEQ SEQUENCIA,	//-- 11 SEQUENCIA
				 D1_DOC DOCUMENTO,		//-- 12 DOCUMENTO
				 D1_SERIE SERIE,		//-- 13 SERIE
				 D1_QUANT QUANTIDADE,	//-- 14 QUANTIDADE
				 D1_QTSEGUM QUANT2UM,	//-- 15 QUANT2UM
				 D1_LOCAL ARMAZEM,		//-- 16 ARMAZEM
				 ' ' OP,				//-- 17 OP
				 D1_FORNECE FORNECEDOR,	//-- 18 FORNECEDOR
				 D1_LOJA LOJA,			//-- 19 LOJA
				 D1_TIPO TIPONF,		//-- 20 TIPO NF
				 %Exp:cSelectD1%		//-- 21 CUSTO / 21 B1_CODITE	
				 SD1.R_E_C_N_O_ NRECNO  //-- 22 RECNO
	
		FROM %table:SB1% SB1,%table:SD1% SD1,%table:SF4% SF4
	
		WHERE SB1.B1_COD     =  SD1.D1_COD		AND  	SD1.D1_FILIAL  =  %xFilial:SD1%		AND
			  SF4.F4_FILIAL  =  %xFilial:SF4%  	AND 	SD1.D1_TES     =  SF4.F4_CODIGO		AND
			  SF4.F4_ESTOQUE =  'S'				AND 	SD1.D1_DTDIGIT >= %Exp:mv_par07%   AND
			  SD1.D1_DTDIGIT <= %Exp:mv_par08%	AND		SD1.D1_ORIGLAN <> 'LF'				AND
			  SD1.D1_LOCAL   >= %Exp:mv_par01%	AND		SD1.D1_LOCAL   <= %Exp:mv_par02%	AND
			  SD1.%NotDel%						AND 	SF4.%NotDel%                        AND
	          SB1.B1_COD     >= %Exp:mv_par05%	AND		SB1.B1_COD     <= %Exp:mv_par06% 	AND
			  SB1.B1_FILIAL  =  %xFilial:SB1%	AND		SB1.B1_TIPO    >= %Exp:mv_par03%	AND
			  SB1.B1_TIPO    <= %Exp:mv_par04%	AND		SB1.%NotDel%						   		  
			  %Exp:cWhereD1%
		
	    UNION
	    
		SELECT 'SD2',	     			//-- 01 ARQ
				SB1.B1_COD,	        	//-- 02 PRODUTO
				SB1.B1_TIPO,		    //-- 03 TIPO
				SB1.B1_UM,				//-- 04 UM
				SB1.B1_GRUPO,		    //-- 05 GRUPO
				SB1.B1_DESC,		    //-- 06 DESCR
				%Exp:cSelect1%			//-- 07 FILTRO COM CAMPOS DO USUARIO
				D2_EMISSAO,				//-- 08 DATA
				D2_TES,					//-- 09 TES
				D2_CF,					//-- 10 CF
				D2_NUMSEQ,				//-- 11 SEQUENCIA
				D2_DOC,					//-- 12 DOCUMENTO
				D2_SERIE,				//-- 13 SERIE
				D2_QUANT,				//-- 14 QUANTIDADE
				D2_QTSEGUM,				//-- 15 QUANT2UM
				D2_LOCAL,				//-- 16 ARMAZEM
				' ',					//-- 17 OP
				D2_CLIENTE,				//-- 18 FORNECEDOR
				D2_LOJA,				//-- 19 LOJA
				D2_TIPO,				//-- 20 TIPO NF
				%Exp:cSelectD2%			//-- 21 CUSTO 
				SD2.R_E_C_N_O_ SD2RECNO //-- 22 RECNO
				
		FROM %table:SB1% SB1,%table:SD2% SD2,%table:SF4% SF4
			
		WHERE	SB1.B1_COD     =  SD2.D2_COD		AND	SD2.D2_FILIAL  = %xFilial:SD2%		AND
				SF4.F4_FILIAL  = %xFilial:SF4% 		AND	SD2.D2_TES     =  SF4.F4_CODIGO		AND
				SF4.F4_ESTOQUE =  'S'				AND	SD2.D2_EMISSAO >= %Exp:mv_par07%	AND
				SD2.D2_EMISSAO <= %Exp:mv_par08%	AND	SD2.D2_ORIGLAN <> 'LF'				AND
				SD2.D2_LOCAL   >= %Exp:mv_par01%	AND	SD2.D2_LOCAL   <= %Exp:mv_par02%	AND
				SD2.%NotDel%						AND SF4.%NotDel%						AND
		        SB1.B1_COD     >= %Exp:mv_par05%	AND		SB1.B1_COD  <= %Exp:mv_par06% 	AND
				SB1.B1_FILIAL  =  %xFilial:SB1%	    AND		SB1.B1_TIPO >= %Exp:mv_par03%	AND
				SB1.B1_TIPO    <= %Exp:mv_par04%	AND		SB1.%NotDel%						   		  
  				%Exp:cWhereD2%
				
		UNION		
	
		SELECT 	'SD3',	    			//-- 01 ARQ
				SB1.B1_COD,	    	    //-- 02 PRODUTO
				SB1.B1_TIPO,		    //-- 03 TIPO
				SB1.B1_UM,				//-- 04 UM
				SB1.B1_GRUPO,	     	//-- 05 GRUPO
				SB1.B1_DESC,		    //-- 06 DESCR
				%Exp:cSelect1%			//-- 07 FILTRO COM CAMPOS DO USUARIO				
				D3_EMISSAO,				//-- 08 DATA
				D3_TM,					//-- 09 TES
				D3_CF,					//-- 10 CF
				D3_NUMSEQ,				//-- 11 SEQUENCIA
				D3_DOC,					//-- 12 DOCUMENTO
				' ',					//-- 13 SERIE
				D3_QUANT,				//-- 14 QUANTIDADE
				D3_QTSEGUM,				//-- 15 QUANT2UM
				D3_LOCAL,				//-- 16 ARMAZEM
				D3_OP,					//-- 17 OP
				' ',					//-- 18 FORNECEDOR
				' ',					//-- 19 LOJA
				' ',					//-- 20 TIPO NF
				%Exp:cSelectD3%			//-- 21 CUSTO
				SD3.R_E_C_N_O_ SD3RECNO //-- 22 RECNO
	
		FROM %table:SB1% SB1,%table:SD3% SD3
		
		WHERE	SB1.B1_COD     =  SD3.D3_COD 		AND SD3.D3_FILIAL  =  %xFilial:SD3%		AND
				SD3.D3_EMISSAO >= %Exp:mv_par07%	AND	SD3.D3_EMISSAO <= %Exp:mv_par08%	AND
				SD3.D3_LOCAL   >= %Exp:mv_par01%	AND	SD3.D3_LOCAL   <= %Exp:mv_par02%	AND
				SD3.%NotDel%						                                   		AND
		        SB1.B1_COD     >= %Exp:mv_par05%	AND		SB1.B1_COD  <= %Exp:mv_par06% 	AND
				SB1.B1_FILIAL  =  %xFilial:SB1%	    AND		SB1.B1_TIPO >= %Exp:mv_par03%	AND
				SB1.B1_TIPO    <= %Exp:mv_par04%	AND		SB1.%NotDel%					   	   		  
				%Exp:cWhereD3%				
				
		UNION
		
		SELECT 	'SB1',			     	//-- 01 ARQ
				SB1.B1_COD,	    	    //-- 02 PRODUTO
				SB1.B1_TIPO,		    //-- 03 TIPO
				SB1.B1_UM,				//-- 04 UM
				SB1.B1_GRUPO,		    //-- 05 GRUPO
				SB1.B1_DESC,		    //-- 06 DESCR
				%Exp:cSelect1%			//-- 07 FILTRO COM CAMPOS DO USUARIO
				' ',					//-- 08 DATA
				' ',					//-- 09 TES
				' ',					//-- 10 CF
				' ',					//-- 11 SEQUENCIA	
				' ',					//-- 12 DOCUMENTO
				' ',					//-- 13 SERIE
				0,						//-- 14 QUANTIDADE
				0,						//-- 15 QUANT2UM
				' ',	    			//-- 16 ARMAZEM
				' ',					//-- 17 OP
				' ',					//-- 18 FORNECEDOR
				' ',					//-- 19 LOJA
				' ',					//-- 20 TIPO NF
				0,						//-- 21 CUSTO 
				0						//-- 22 RECNO 
	
		FROM %table:SB1% SB1
		
		WHERE   SB1.B1_COD     >= %Exp:mv_par05%	AND		SB1.B1_COD  <= %Exp:mv_par06% 	AND
				SB1.B1_FILIAL  =  %xFilial:SB1%	    AND		SB1.B1_TIPO >= %Exp:mv_par03%	AND
				SB1.B1_TIPO    <= %Exp:mv_par04%	AND		SB1.%NotDel%					   	   		  
	
		ORDER BY 3,2,1
	
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relatorio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
	//������������������������������������������������������������������������Ŀ
	//�Inicio da impressao do fluxo do relatorio                               �
	//��������������������������������������������������������������������������
	dbSelectArea(cAliasTop)
	oReport:SetMeter(nRegs)

	oSection1:Init() 

	While !oReport:Cancel() .And. !(cAliasTop)->(Eof())	
	
		If oReport:Cancel()
			Exit
		EndIf

		//��������������������������������������������������������������Ŀ
		//� Filtro de Usuario                                            �
		//����������������������������������������������������������������
		If !Empty(cFiltroUsr)
		    If !(&cFiltroUsr)
				dbSelectArea(cAliasTop)
				dbSkip()
				Loop
			EndIf	
		EndIf
		
		cTipant := (cAliasTop)->B1_TIPO
		oSection1:Cell("cTipant"):SetValue(cTipant)

		Store 0 TO 	nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc
		Store 0 TO 	nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
		lPassou := .F.
	
		While !oReport:Cancel() .And. !(cAliasTop)->(Eof()) .And. (cAliasTop)->B1_TIPO == cTipAnt
		
			If oReport:Cancel()
				Exit
			EndIf
	        
			//��������������������������������������������������������������Ŀ
			//� Filtro de Usuario                                            �
			//����������������������������������������������������������������
			If !Empty(cFiltroUsr)
			    If !(&cFiltroUsr)
					dbSelectArea(cAliasTop)
					dbSkip()
					Loop
				EndIf	
			EndIf

	
	        cProduto  := (cAliasTop)->PRODUTO

			oReport:IncMeter()
	
			//��������������������������������������������������������������Ŀ
			//� Saldo final e inicial dos almoxarifados                      �
			//����������������������������������������������������������������
			dbSelectArea("SB2")
			dbSeek(xFilial()+cProduto+mv_par01,.T.)
			While !EOF() .And. B2_FILIAL+B2_COD == xFilial()+cProduto .And. B2_LOCAL <= mv_par02
				//��������������������������������������������������������������Ŀ
				//� Verifica se deve somar custo da Mao de Obra no Saldo Final   �
				//����������������������������������������������������������������
				If	!(IsProdMod(SB2->B2_COD) .And. mv_par11 == 2)
					IF mv_par10==1
						nSaldoAtu := nSaldoAtu + &("B2_VATU"+cMoeda)
					Elseif mv_par10 == 2
						nSaldoAtu := nSaldoAtu + &("B2_VFIM"+cMoeda)
					Else
						aSaldoAtu	:= CalcEst(SB2->B2_COD,SB2->B2_LOCAL,mv_par08+1)
						nSaldoAtu 	:= nSaldoAtu + aSaldoAtu[mv_par09+1]
					EndIF
				EndIf	
				dbSkip()
			EndDo
	
			lPassou := IIF(nSaldoAtu > 0,.t.,lPassou)
			//��������������������������������������������������������������Ŀ
			//� SB1 - Verifica Produtos Sem Movimento						 �
			//����������������������������������������������������������������
			dbSelectArea(cAliasTop)
			While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SB1"
				dbSkip()
			EndDo

			//��������������������������������������������������������������Ŀ
			//� SD1 - Pesquisa as Entradas de um determinado produto         �
			//����������������������������������������������������������������
			dbSelectArea(cAliasTop)
			While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD1"

				dbSelectArea("SF4")
				dbSeek(xFilial()+(cAliasTop)->TES)
				dbSelectArea(cAliasTop)
			
				If SF4->F4_ESTOQUE == "S"
					nValor := (cAliasTop)->CUSTO
					If SF4->F4_PODER3 == "N"
						If (cAliasTop)->TIPONF == "D"
							nDevVendas  += nValor
						Else
							nCompras += nValor
						EndIf
					Else	
						nEntrTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo

			//��������������������������������������������������������������Ŀ
			//� SD2 - Pesquisa Vendas                                        �
			//����������������������������������������������������������������
			dbSelectArea(cAliasTop)
			While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD2"
		
				dbSelectArea("SF4")
				dbSeek(xFilial()+(cAliasTop)->TES)
				dbSelectArea(cAliasTop)
				If SF4->F4_ESTOQUE == "S"
					nValor := (cAliasTop)->CUSTO
					If SF4->F4_PODER3 == "N"
						If (cAliasTop)->TIPONF == "D"
							nDevComprs += nValor
						Else
							nVendas  += nValor
						EndIf
					Else
						nSaiTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo

			//��������������������������������������������������������������Ŀ
			//� SD3 - Pesquisa requisicoes                                   �
			//����������������������������������������������������������������
			dbSelectArea(cAliasTop)
			While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD3"

				nValor := (cAliasTop)->CUSTO
			
				If (cAliasTop)->TES > "500"
					nValor := nValor*-1
				EndIf
		
				If Substr((cAliasTop)->CF,1,2) == "PR"
					nProducao += nValor
				ElseIf allTrim((cAliasTop)->CF)$"RE4/DE4"
					nReqTrans += nValor
				ElseIf Empty((cAliasTop)->OP) .And. Substr((cAliasTop)->CF,3,1) != "3"
					nReqCons += nValor
				ElseIf !Empty((cAliasTop)->OP)
					nReqProd += nValor
				Else
					nReqOutr += nValor
				EndIf
				lPassou := .T.
				dbSkip()
			EndDo
			dbSelectArea(cAliasTop)
		EndDo
	
		If lPassou
			lTotal:=.T.
			nSalant := nSaldoAtu-nCompras-nReqProd-nReqCons-nProducao+nVendas-nReqTrans-nReqOutr-nDevVendas+nDevComprs-nEntrTerc+nSaiTerc

			oSection1:Cell("nSalant"   ):SetValue(nSalant)			
			oSection1:Cell("nCompras"  ):SetValue(nCompras)			
			oSection1:Cell("nReqCons"  ):SetValue(nReqCons)			
			oSection1:Cell("nReqProd"  ):SetValue(nReqProd)			
			oSection1:Cell("nReqTrans" ):SetValue(nReqTrans)			
			oSection1:Cell("nProducao" ):SetValue(nProducao)			
			oSection1:Cell("nVendas"   ):SetValue(nVendas)			
			oSection1:Cell("nReqOutr"  ):SetValue(nReqOutr)			
			oSection1:Cell("nDevVendas"):SetValue(nDevVendas)			
			oSection1:Cell("nDevComprs"):SetValue(nDevComprs)			
			oSection1:Cell("nEntrTerc" ):SetValue(nEntrTerc)			
			oSection1:Cell("nSaiTerc"  ):SetValue(nSaiTerc)			
			oSection1:Cell("nSaldoAtu" ):SetValue(nSaldoAtu)			
			
			oSection1:PrintLine()
		EndIf
		dbSelectArea(cAliasTop)
	EndDo
	oSection1:Finish()

#ELSE
	dbSelectArea("SB1")
	dbSetOrder(2)
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao Advpl                          �
	//��������������������������������������������������������������������������
	MakeAdvplExpr(oReport:uParam)

	cCondicao := 'B1_FILIAL == "'+xFilial("SB1")+'".And.' 
	cCondicao += 'B1_COD >= "'+mv_par05+'".And.B1_COD <="'+mv_par06+'".And.'
	cCondicao += 'B1_TIPO >= "'+mv_par03+'".And.B1_TIPO <="'+mv_par04+'"'
	
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
	//��������������������������������������������������������������Ŀ
	//� Redireciona as ordens a serem lidas                          �
	//����������������������������������������������������������������
	dbSelectArea("SD1")
	dbSetOrder(5)

	dbSelectArea("SD2")
	dbSetOrder(1)

	dbSelectArea("SD3")
	dbSetOrder(3)

	dbSelectArea("SB1")
	oSection1:Init() 
	While !oReport:Cancel() .And. SB1->(!Eof()) .And. B1_FILIAL == xFilial("SB1")	
	
		If oReport:Cancel()
			Exit
		EndIf
	
		//��������������������������������������������������������������Ŀ
		//� Filtro de Usuario                                            �
		//����������������������������������������������������������������
		If !Empty(cFiltroUsr) .And. !(&cFiltroUsr)
			dbSelectArea("SB1")
			dbSkip()
			Loop
		EndIf

		cTipant := B1_TIPO
		oSection1:Cell("cTipant"):SetValue(cTipant)		
		
		Store 0 TO 	nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc
		Store 0 TO 	nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
		lPassou := .F.
		
		While !oReport:Cancel() .And. SB1->(!Eof()) .And. B1_FILIAL+B1_TIPO == xFilial("SB1")+cTipAnt
			
			If oReport:Cancel()
				Exit
			EndIf
		
			oReport:IncMeter()
		
			//��������������������������������������������������������������Ŀ
			//� Saldo final e inicial dos almoxarifados                      �
			//����������������������������������������������������������������
			dbSelectArea("SB2")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !EOF() .And. B2_FILIAL+B2_COD == xFilial()+SB1->B1_COD .And. B2_LOCAL <= mv_par02
				//��������������������������������������������������������������Ŀ
				//� Verifica se deve somar custo da Mao de Obra no Saldo Final   �
				//����������������������������������������������������������������
				If	!(IsProdMod(SB2->B2_COD) .And. mv_par11 == 2)
					IF mv_par10==1
						nSaldoAtu := nSaldoAtu + &("B2_VATU"+cMoeda)
					Elseif mv_par10 == 2
						nSaldoAtu := nSaldoAtu + &("B2_VFIM"+cMoeda)
					Else
						aSaldoAtu	:= CalcEst(SB2->B2_COD,SB2->B2_LOCAL,mv_par08+1)
						nSaldoAtu 	:= nSaldoAtu + aSaldoAtu[mv_par09+1]
					EndIF
				EndIf	
				dbSkip()
			EndDo
		
			lPassou := IIF(nSaldoAtu > 0,.t.,lPassou)
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa as Entradas de um determinado produto               �
			//����������������������������������������������������������������
			dbSelectArea("SD1")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D1_FILIAL+D1_COD == xFilial()+SB1->B1_COD .And. D1_LOCAL <= mv_par02
			
				//��������������������������������������������������������������Ŀ
				//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
				//����������������������������������������������������������������
				If D1_ORIGLAN == "LF"
					dbSkip()
					Loop
				EndIf
			
				If cPaisLoc <> "BRA" .And. !Empty(D1_REMITO)
					dbSkip()
					Loop
				EndIf

				If D1_DTDIGIT < mv_par07 .Or. D1_DTDIGIT > mv_par08
					dbSkip()
					Loop
				EndIf
			
				dbSelectArea("SF4")
				dbSeek(xFilial()+SD1->D1_TES)
				dbSelectArea("SD1")
			
				If SF4->F4_ESTOQUE == "S"
					nValor := &("D1_CUSTO"+IIF(mv_par09 == 1," ",cMoeda))
					dbSelectArea("SD1")
					If SF4->F4_PODER3 == "N"
						If SD1->D1_TIPO == "D"
							nDevVendas  += nValor
						Else
							nCompras += nValor
						EndIf
					Else	
						nEntrTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa requisicoes                                         �
			//����������������������������������������������������������������
			dbSelectArea("SD3")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D3_FILIAL+D3_COD == xFilial()+SB1->B1_COD .And. D3_LOCAL <= mv_par02
				If D3_EMISSAO < mv_par07 .Or. D3_EMISSAO > mv_par08 .Or. D3_ESTORNO == "S"
					dbSkip()
					Loop
				EndIf
				
				//-- Filtro para Nao imprimir OPs referentes ao SIGAMNT
				If !Empty(D3_OP) .And. MV_PAR12 == 2 .And. !__lPyme 
					SC2->(dbSetOrder(1)) //-- C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
					If SC2->(dbSeek(xFilial('SC2')+SD3->D3_OP, .F.))
						If AllTrim(SC2->C2_ITEM) == 'OS' .AND. SC2->C2_SEQUEN == '001'
							dbSkip()
							Loop
						EndIf
					EndIf
				EndIf
				
				IF mv_par09 == 1
					nValor := D3_CUSTO1
				ElseIf mv_par09 == 2
					nValor := D3_CUSTO2
				ElseIf mv_par09 == 3
					nValor := D3_CUSTO3
				ElseIf mv_par09 == 4
					nValor := D3_CUSTO4
				ElseIf mv_par09 == 5
					nValor := D3_CUSTO5
				EndIf
			
				If D3_TM > "500"
					nValor := nValor*-1
				EndIf
			
				If Substr(D3_CF,1,2) == "PR"
					nProducao += nValor
				ElseIf D3_CF$"RE4/DE4"
					nReqTrans += nValor
				ElseIf Empty(D3_OP) .And. Substr(D3_CF,3,1) != "3"
					nReqCons += nValor
				ElseIf !Empty(D3_OP)
					nReqProd += nValor
				Else
					nReqOutr += nValor
				EndIf
				lPassou := .T.
				dbSkip()
			EndDo
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa Vendas                                              �
			//����������������������������������������������������������������
			dbSelectArea("SD2")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D2_FILIAL+D2_COD == xFilial()+SB1->B1_COD .And. D2_LOCAL <= mv_par02
				//��������������������������������������������������������������Ŀ
				//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
				//����������������������������������������������������������������
				If D2_ORIGLAN == "LF"
					dbSkip()
					Loop
				EndIf

				If cPaisLoc <> "BRA" .And. !Empty(D2_REMITO)
					dbSkip()
					Loop
				EndIf

				If D2_EMISSAO < mv_par07 .Or. D2_EMISSAO > mv_par08
					dbSkip()
					Loop
				EndIf
			
				dbSelectArea("SF4")
				dbSeek(xFilial()+SD2->D2_TES)
				dbSelectArea("SD2")
				If SF4->F4_ESTOQUE == "S"
					nValor := &("D2_CUSTO"+cMoeda)
					dbSelectArea("SD2")
					If SF4->F4_PODER3 == "N"
						If SD2->D2_TIPO == "D"
							nDevComprs += nValor
						Else
							nVendas  += nValor
						EndIf
					Else
						nSaiTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo
			dbSelectArea("SB1")
			dbSkip()
		EndDo

		If lPassou
			lTotal:=.T.
			nSalant := nSaldoAtu-nCompras-nReqProd-nReqCons-nProducao+nVendas-nReqTrans-nReqOutr-nDevVendas+nDevComprs-nEntrTerc+nSaiTerc

			oSection1:Cell("nSalant"):SetPicture(TM(nSalant,16))			
			oSection1:Cell("nCompras"):SetPicture(TM(nCompras,16))
			oSection1:Cell("nReqCons"):SetPicture(TM(nReqCons,16))
			oSection1:Cell("nReqProd"):SetPicture(TM(nReqProd,16))
			oSection1:Cell("nReqTrans"):SetPicture(TM(nReqTrans,16))
			oSection1:Cell("nProducao"):SetPicture(TM(nProducao,16))
			oSection1:Cell("nVendas"):SetPicture(TM(nVendas,16))
			oSection1:Cell("nReqOutr"):SetPicture(TM(nReqOutr,16))
			oSection1:Cell("nDevVendas"):SetPicture(TM(nDevVendas,16))
			oSection1:Cell("nDevComprs"):SetPicture(TM(nDevComprs,16))
			oSection1:Cell("nEntrTerc"):SetPicture(TM(nCompras,14))
			oSection1:Cell("nSaiTerc"):SetPicture(TM(nVendas,14))
			oSection1:Cell("nSaldoAtu"):SetPicture(TM(nSaldoAtu,16))
			

			oSection1:Cell("nSalant"):SetValue(nSalant)			
			oSection1:Cell("nCompras"):SetValue(nCompras)			
			oSection1:Cell("nReqCons"):SetValue(nReqCons)			
			oSection1:Cell("nReqProd"):SetValue(nReqProd)			
			oSection1:Cell("nReqTrans"):SetValue(nReqTrans)			
			oSection1:Cell("nProducao"):SetValue(nProducao)			
			oSection1:Cell("nVendas"):SetValue(nVendas)			
			oSection1:Cell("nReqOutr"):SetValue(nReqOutr)			
			oSection1:Cell("nDevVendas"):SetValue(nDevVendas)			
			oSection1:Cell("nDevComprs"):SetValue(nDevComprs)			
			oSection1:Cell("nEntrTerc"):SetValue(nEntrTerc)			
			oSection1:Cell("nSaiTerc"):SetValue(nSaiTerc)			
			oSection1:Cell("nSaldoAtu"):SetValue(nSaldoAtu)			
			
			oSection1:PrintLine()

		EndIf
		dbSelectArea("SB1")
	EndDo
	oSection1:Finish() 

#ENDIF		

Return NIL
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR320R3 � Autor � Eveli Morasco         � Data � 31/03/93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Resumo das entradas e saidas (Antigo)                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Marcelo Pim.�18/12/97�13695A�Ajuste no saldo final de acordo c/a moeda.���
���Rodrigo Sar.�01/04/98�13615A�Inclusao da Perg. mv_par10                ���
���Rodrigo Sar.�22/07/98�15188A�Inclusao de tratamento poder terceiros    ���
���Edson   M.  �17/11/98�xxxxxx�Substituicao do Gotop por Seeek no SB1.   ���
���Patricia Sal�04/01/00�xxxxxx�Inclusao Perg. Almoxarifado Ate.          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MATR320R3
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Resumo das Entradas e Saidas"
LOCAL cDesc1   := STR0002	//"Este programa mostra um resumo ,por tipo de material ,de todas  as  suas"
LOCAL cDesc2   := STR0003	//"entradas e saidas. A coluna SALDO INICIAL  e' o  resultado da  soma  das"
LOCAL cDesc3   := STR0004	//"outras colunas do relatorio e nao o saldo inicial cadastrado no estoque."
LOCAL cString  := "SB1"
LOCAL wnrel    := "MATR320"

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private padrao de todos os relatorios         �
//����������������������������������������������������������������
PRIVATE aReturn:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "MTR320"

//�����������������������������������������������������������������Ŀ
//� Funcao utilizada para verificar a ultima versao do fonte        �
//� SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	�
//�������������������������������������������������������������������
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20060321)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif

AjustaSX1() //-- Inclui a 12a pergunta

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // Almoxarifado De                              �
//� mv_par02     // Almoxarifado Ate                             �
//� mv_par03     // Tipo inicial                                 �
//� mv_par04     // Tipo final                                   �
//� mv_par05     // Produto inicial                              �
//� mv_par06     // Produto Final                                �
//� mv_par07     // Emissao de                                   �
//� mv_par08     // Emissao ate                                  �
//� mv_par09     // moeda selecionada ( 1 a 5 )                  �
//� mv_par10     // Saldo a considerar : Atual / Fechamento      �
//� mv_par11     // Considera Saldo MOD: Sim / Nao               �
//� mv_par12     // Imprime OPs geradas pelo SIGAMNT? Sim / Nao  �
//����������������������������������������������������������������
pergunte(cPerg,.F.)

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C320Imp(@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return NIL

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C320IMP  � Autor � Rodrigo de A. Sartorio� Data � 12.12.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR320  		                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function C320Imp(lEnd,WnRel,cString,tamanho,titulo)

//��������������������������������������������������������������Ŀ
//� Variaveis locais exclusivas deste programa                   �
//����������������������������������������������������������������
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0
LOCAL lContinua := .T. ,cMoeda ,lPassou:=.F.,lTotal:=.F.,cCampo
LOCAL nTotComp,nTotCons,nTotProc,nTotTrans,nTotProd,nTotEnTerc,nTotSaTerc
LOCAL nTotVend,nTotSaldo,nTotSant,nTotOutr,nTotDevVen,nTotDevCom
LOCAL cTipAnt
LOCAL nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc
LOCAL nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
LOCAL nValor := 0
LOCAL cAliasTop:= CriaTrab(,.F.)
LOCAL cQuery   := ""
LOCAL cQueryD1 := ""
LOCAL cQueryD2 := ""
LOCAL cQueryD3 := ""
LOCAL cQueryB1A:= ""
LOCAL cQueryB1C:= ""
LOCAL cQueryB1 := ""
LOCAL cProduto := ""
LOCAL lQuery   := .F.

//��������������������������������������������������������������Ŀ
//� Contadores de linha e pagina                                 �
//����������������������������������������������������������������
PRIVATE li := 80 ,m_pag := 1

//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//���������������������������������������������������������������������
nTipo  := IIF(aReturn[4]==1,15,18)

//������������������������������������������������������������Ŀ
//� Adiciona o simbolo da moeda escolhida ao titulo            �
//��������������������������������������������������������������
cMoeda := LTrim(Str(mv_par09))
cMoeda := IIF(cMoeda=="0","1",cMoeda)
If Type("NewHead")#"U"
	NewHead += STR0007+AllTrim(GetMv("MV_SIMB"+cMoeda))+" - "+STR0035+dtoc(mv_par07,"ddmmyy")+STR0036+dtoc(mv_par08,"ddmmyy")			//" EM "
Else
	Titulo  += STR0007+AllTrim(GetMv("MV_SIMB"+cMoeda))+" - "+STR0035+dtoc(mv_par07,"ddmmyy")+STR0036+dtoc(mv_par08,"ddmmyy")		   //" EM "
EndIf

//��������������������������������������������������������������Ŀ
//� Monta os Cabecalhos                                          �
//����������������������������������������������������������������

Cabec1 := STR0008		//"TIPO            SALDO          COMPRAS    MOVIMENTACOES      REQUISICOES   TRANSFERENCIAS         PRODUCAO           VENDAS       TRANSF. P/     DEVOLUCAO DE     DEVOLUCAO DE  ENTRADA PODER  SAIDA PODER        SALDO"
Cabec2 := STR0009 +Iif(mv_par10 == 1,STR0010,Iif(mv_par10 == 2,STR0011,STR0012))    //"              INICIAL                          INTERNAS    PARA PRODUCAO                                                           PROCESSO            VENDAS          COMPRAS    TERCEIROS      TERCEIROS"###"        ATUAL"###"DO FECHAMENTO"###" DO MOVIMENTO"

******************      12   9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 999,999,999.99 999,999,999.99 9,999,999,999.99
******************      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
******************      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// Posicoes (000,005,022,039,056,073,089,106,123,140,157,174,189,204)

#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		// **** ATENCAO - O ORDER BY UTILIZA AS POSICOES DO SELECT, SE ALGUM CAMPO
		// **** FOR INCLUIDO NA QUERY OU ALTERADO DE LUGAR DEVE SER REVISTA A SINTAXE
		// **** DO ORDER BY
		// 1 ARQ
		// 2 PRODUTO
		// 3 TIPO
		// 4 UM
		// 5 GRUPO
		// 6 DESC
		// 7 DATA
		// 8 TES
		// 9 CF
		// 10 SEQUENCIA
		// 11 DOCUMENTO
		// 12 SERIE
		// 13 QUANTIDADE
		// 14 QUANT2UM
		// 15 ARMAZEM
		// 17 OP
		// 19 FORNECEDOR
		// 20 LOJA
		// 22 TIPO NF
		// 23 CUSTO
		// 24 RECNO
	    
	    lQuery := .T.
		cQueryD1:= "SELECT 'SD1' ARQ,SB1.B1_COD PRODUTO,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D1_DTDIGIT DATA,D1_TES TES,D1_CF CF,D1_NUMSEQ SEQUENCIA,D1_DOC DOCUMENTO,D1_SERIE SERIE,D1_QUANT QUANTIDADE,D1_QTSEGUM QUANT2UM,D1_LOCAL ARMAZEM,'' OP,D1_FORNECE FORNECEDOR,D1_LOJA LOJA,D1_TIPO TIPONF,D1_CUSTO"
		// COLOCA A MOEDA DO CUSTO
		If mv_par09 > 1
			cQueryD1+= Str(mv_par09,1,0)
        EndIf
		cQueryD1 += " CUSTO,SD1.R_E_C_N_O_ NRECNO FROM " 	
		cQueryD1 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD1")+ " SD1 , "+ RetSqlName("SF4")+" SF4 "
		cQueryD1 += " WHERE SB1.B1_COD = D1_COD AND D1_FILIAL = '"+xFilial("SD1")+"'"
		cQueryD1 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
		cQueryD1 += " AND D1_DTDIGIT >= '"+DTOS(mv_par07)+"' AND D1_DTDIGIT <= '"+DTOS(mv_par08)+"'"
		cQueryD1 += " AND D1_ORIGLAN <> 'LF'"
		cQueryD1 += " AND D1_LOCAL >= '"+mv_par01+"'"+" AND D1_LOCAL <= '"+mv_par02+"'"
		If cPaisLoc <> "BRA"
			cQueryD1 += " AND D1_REMITO = '" + Space(TamSx3("D1_REMITO")[1]) + "' "
		EndIf	
		#IFDEF SHELL
			cQueryD1 += " AND D1_CANCEL <> 'S'"
		#ENDIF
		cQueryD1 += " AND SD1.D_E_L_E_T_<>'*' AND SF4.D_E_L_E_T_<>'*'"

		cQueryD2 := " SELECT 'SD2',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D2_EMISSAO,D2_TES,D2_CF,D2_NUMSEQ,D2_DOC,D2_SERIE,D2_QUANT,D2_QTSEGUM,D2_LOCAL,'',D2_CLIENTE,D2_LOJA,D2_TIPO,D2_CUSTO"
		cQueryD2 += Str(mv_par09,1,0)
		cQueryD2 += ",SD2.R_E_C_N_O_ SD2RECNO FROM "
		cQueryD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
		cQueryD2 += " WHERE SB1.B1_COD = D2_COD AND D2_FILIAL = '"+xFilial("SD2")+"'"
		cQueryD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
		cQueryD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par07)+"' AND D2_EMISSAO <= '"+DTOS(mv_par08)+"'"
		cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
		cQueryD2 += " AND D2_LOCAL >= '"+mv_par01+"'"+" AND D2_LOCAL <= '"+mv_par02+"'"
		If cPaisLoc <> "BRA"
			cQueryD2 += " AND D2_REMITO = '" + Space(TamSx3("D2_REMITO")[1]) + "' "
		EndIf	

		#IFDEF SHELL
			cQueryD2 += " AND D2_CANCEL <> 'S'"
		#ENDIF
		cQueryD2 += " AND SD2.D_E_L_E_T_<>'*' AND SF4.D_E_L_E_T_<>'*'"

		cQueryD3 := " SELECT 'SD3',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D3_EMISSAO,D3_TM,D3_CF,D3_NUMSEQ,D3_DOC,'',D3_QUANT,D3_QTSEGUM,D3_LOCAL,D3_OP,'','','',D3_CUSTO"
		cQueryD3 += Str(mv_par09,1,0)
		cQueryD3 += ",SD3.R_E_C_N_O_ SD3RECNO FROM "
		cQueryD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
		cQueryD3 += " WHERE SB1.B1_COD = D3_COD AND D3_FILIAL = '"+xFilial("SD3")+"' AND "
		cQueryD3 += " D3_EMISSAO >= '"+DTOS(mv_par07)+"' AND D3_EMISSAO <= '"+DTOS(mv_par08)+"'"

		If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
			cQueryD3 += " AND D3_ESTORNO <> 'S'"
		EndIf
		If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
			cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
			cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
		EndIf		                                 
		
		cQueryD3 += " AND D3_LOCAL >= '"+mv_par01+"'"+" AND D3_LOCAL <= '"+mv_par02+"'"
		cQueryD3 += " AND SD3.D_E_L_E_T_<>'*'"

		cQueryB1:= "SELECT 'SB1',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,'','','','','','',0,0,'','','','','',0,0"
		cQueryB1 += " FROM "
		cQueryB1 += RetSqlName("SB1") + " SB1 "
		cQueryB1 += " WHERE SB1.B1_COD >= '"+mv_par05+"' AND SB1.B1_COD <= '"+mv_par06+"'"

        cQueryB1A:= " AND SB1.B1_COD >= '"+mv_par05+"' AND SB1.B1_COD <= '"+mv_par06+"'"
		cQueryB1C:= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
		cQueryB1C+= " SB1.D_E_L_E_T_<>'*'"

		cQuery := cQueryD1+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryD2+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryD3+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryB1+" AND "+cQueryB1C
		cQuery += " ORDER BY 3,2,1" //3-TIPO/2-PRODUTO/1-ARQ

		cQuery:=ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTOP,.F.,.T.)},STR0015)
		SetRegua(LastRec())
		dbSelectArea(cAliasTop)	
	
		Store 0 TO nTotComp,nTotCons,nTotProc,nTotTrans,nTotProd,nTotEnTerc,nTotSaTerc
		Store 0 TO nTotVend,nTotSaldo,nTotSant,nTotOutr,nTotDevVen,nTotDevCom
	
		While lContinua .And. !EOF()
		
			If lEnd
				@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
	        //������������������������������������������������������������������������Ŀ
	        //� Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  �
		    //��������������������������������������������������������������������������
        	If !Empty(aReturn[7])
	            dbSelectArea("SB1") 
	            dbSetOrder(1) 
	            If dbSeek(xFilial()+(cAliasTop)->PRODUTO)
    	 	    	If !&(aReturn[7])
      		        	dbSelectArea(cAliasTop)
		    		    dbSkip()
				        Loop
		        	Endif   
			    Else
   	    	    	dbSelectArea(cAliasTop)
            		dbSkip()
				    Loop
		       	Endif
  		       	dbSelectArea(cAliasTop)
		    Endif   
			
			cTipant := (cAliasTop)->B1_TIPO
			Store 0 TO 	nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc
			Store 0 TO 	nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
			lPassou := .F.
		
			While !EOF() .And. (cAliasTop)->B1_TIPO == cTipAnt
			
				If lEnd
					@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf
		
   		        //������������������������������������������������������������������������Ŀ
		        //� Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  �
			    //��������������������������������������������������������������������������
        		If !Empty(aReturn[7])
		            dbSelectArea("SB1") 
		            dbSetOrder(1) 
	    	        If dbSeek(xFilial()+(cAliasTop)->PRODUTO)
    	 		    	If !&(aReturn[7])
      		    	    	dbSelectArea(cAliasTop)
		    			    dbSkip()
					        Loop
			        	Endif   
				    Else
   	    	    		dbSelectArea(cAliasTop)
            			dbSkip()
					    Loop
			       	Endif
  			       	dbSelectArea(cAliasTop)
		    	Endif   
		        
		        cProduto  := (cAliasTop)->PRODUTO
				IncRegua()
		
				//��������������������������������������������������������������Ŀ
				//� Saldo final e inicial dos almoxarifados                      �
				//����������������������������������������������������������������
				dbSelectArea("SB2")
				dbSeek(xFilial()+cProduto+mv_par01,.T.)
				While !EOF() .And. B2_FILIAL+B2_COD == xFilial()+cProduto .And. B2_LOCAL <= mv_par02
					//��������������������������������������������������������������Ŀ
					//� Verifica se deve somar custo da Mao de Obra no Saldo Final   �
					//����������������������������������������������������������������
					If	!(IsProdMod(SB2->B2_COD) .And. mv_par11 == 2)
						IF mv_par10==1
							nSaldoAtu := nSaldoAtu + &("B2_VATU"+cMoeda)
						Elseif mv_par10 == 2
							nSaldoAtu := nSaldoAtu + &("B2_VFIM"+cMoeda)
						Else
							aSaldoAtu	:= CalcEst(SB2->B2_COD,SB2->B2_LOCAL,mv_par08+1)
							nSaldoAtu 	:= nSaldoAtu + aSaldoAtu[mv_par09+1]
							/////////////////////////////////////////////////////////////
							//Acerto B2_VFIM1,B2_VFIM2,B2_VFIM3,B2_VFIM4,B2_VFIM5,B2_QFIM
							/////////////////////////////////////////////////////////////
							If (Alltrim(cUserName) == "mcunha")
								Reclock("SB2",.F.)
								If !Rastro(SB2->B2_cod,"L")
									SB2->B2_qfim  := aSaldoAtu[1]
								Endif
								SB2->B2_vfim1 := aSaldoAtu[2]
								SB2->B2_vfim2 := aSaldoAtu[3]
								SB2->B2_vfim3 := aSaldoAtu[4]
								SB2->B2_vfim4 := aSaldoAtu[5]
								SB2->B2_vfim5 := aSaldoAtu[6]
								MsUnlock("SB2")
							Endif
							/////////////////////////////////////////////////////////////
						EndIF
					EndIf	
					dbSkip()
				EndDo
		
				lPassou := IIF(nSaldoAtu > 0,.t.,lPassou)
				//��������������������������������������������������������������Ŀ
				//� SB1 - Verifica Produtos Sem Movimento						 �
				//����������������������������������������������������������������
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SB1"
					dbSkip()
				EndDo

				//��������������������������������������������������������������Ŀ
				//� SD1 - Pesquisa as Entradas de um determinado produto         �
				//����������������������������������������������������������������
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD1"

					dbSelectArea("SF4")
					dbSeek(xFilial()+(cAliasTop)->TES)
					dbSelectArea(cAliasTop)
				
					If SF4->F4_ESTOQUE == "S"
						nValor := (cAliasTop)->CUSTO
						If SF4->F4_PODER3 == "N"
							If (cAliasTop)->TIPONF == "D"
								nDevVendas  += nValor
							Else
								nCompras += nValor
							EndIf
						Else	
							nEntrTerc += nValor
						EndIf
						lPassou := .T.
					EndIf
					dbSkip()
				EndDo

				//��������������������������������������������������������������Ŀ
				//� SD2 - Pesquisa Vendas                                        �
				//����������������������������������������������������������������
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD2"
			
					dbSelectArea("SF4")
					dbSeek(xFilial()+(cAliasTop)->TES)
					dbSelectArea(cAliasTop)
					If SF4->F4_ESTOQUE == "S"
						nValor := (cAliasTop)->CUSTO
						If SF4->F4_PODER3 == "N"
							If (cAliasTop)->TIPONF == "D"
								nDevComprs += nValor
							Else
								nVendas  += nValor
							EndIf
						Else
							nSaiTerc += nValor
						EndIf
						lPassou := .T.
					EndIf
					dbSkip()
				EndDo

				//��������������������������������������������������������������Ŀ
				//� SD3 - Pesquisa requisicoes                                   �
				//����������������������������������������������������������������
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD3"

					nValor := (cAliasTop)->CUSTO
				
					If (cAliasTop)->TES > "500"
						nValor := nValor*-1
					EndIf
			
					If Substr((cAliasTop)->CF,1,2) == "PR"
						nProducao += nValor
					ElseIf allTrim((cAliasTop)->CF)$"RE4/DE4"
						nReqTrans += nValor
					ElseIf Empty((cAliasTop)->OP) .And. Substr((cAliasTop)->CF,3,1) != "3"
						nReqCons += nValor
					ElseIf !Empty((cAliasTop)->OP)
						nReqProd += nValor
					Else
						nReqOutr += nValor
					EndIf
					lPassou := .T.
					dbSkip()
				EndDo
				dbSelectArea(cAliasTop)
			EndDo
		
			If lPassou
				lTotal:=.T.
				If li > 55
					Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				li++
				nSalant := nSaldoAtu-nCompras-nReqProd-nReqCons-nProducao+nVendas-nReqTrans-nReqOutr-nDevVendas+nDevComprs-nEntrTerc+nSaiTerc
				// Posicoes (000,005,022,039,056,073,089,106,123,140,157,174,189,204)
				@ li,000 PSay cTipant
				@ li,005 PSay nSalant    Picture TM(nSalant,16)
				@ li,022 PSay nCompras   Picture TM(nCompras,16)
				@ li,039 PSay nReqCons   Picture TM(nReqCons,16)
				@ li,056 PSay nReqProd   Picture TM(nReqProd,16)
				@ li,073 PSay nReqTrans  Picture TM(nReqTrans,16)
				@ li,089 PSay nProducao  Picture TM(nProducao,16)
				@ li,106 PSay nVendas    Picture TM(nVendas,16)
				@ li,123 PSay nReqOutr   Picture TM(nReqOutr,16)
				@ li,140 PSay nDevVendas Picture TM(nDevVendas,16)
				@ li,157 PSay nDevComprs Picture TM(nDevComprs,16)
				@ li,174 PSay nEntrTerc  Picture TM(nCompras,14)
				@ li,189 PSay nSaiTerc   Picture TM(nVendas,14)
				@ li,204 PSay nSaldoAtu  Picture TM(nSaldoAtu,16)
				nTotSant  += nSalant
				nTotComp  += nCompras
				nTotCons  += nReqCons
				nTotProc  += nReqProd
				nTotTrans += nReqTrans
				nTotProd  += nProducao
				nTotVend  += nVendas
				nTotEnTerc+= nEntrTerc
				nTotSaTerc+= nSaiTerc
				nTotSaldo += nSaldoAtu
				nTotOutr  += nReqOutr
				nTotDevVen+= nDevVendas
				nTotDevCom+= nDevComprs
			EndIf
			dbSelectArea(cAliasTop)
		EndDo

    Else
#ENDIF

	//��������������������������������������������������������������Ŀ
	//� Redireciona as ordens a serem lidas                          �
	//����������������������������������������������������������������
	dbSelectArea("SD1")
	dbSetOrder(5)

	dbSelectArea("SD2")
	dbSetOrder(1)

	dbSelectArea("SD3")
	dbSetOrder(3)

	//��������������������������������������������������������������Ŀ
	//� Inicializa variaveis para controlar cursor de progressao     �
	//����������������������������������������������������������������
	dbSelectArea("SB1")
	dbSetOrder(2)
	dbSeek(xFilial())
	SetRegua(LastRec())
	
	Store 0 TO nTotComp,nTotCons,nTotProc,nTotTrans,nTotProd,nTotEnTerc,nTotSaTerc
	Store 0 TO nTotVend,nTotSaldo,nTotSant,nTotOutr,nTotDevVen,nTotDevCom
	
	While lContinua .And. !EOF() .And. B1_FILIAL == xFilial()
	
		If B1_TIPO < mv_par03 .Or. B1_TIPO > mv_par04
			dbSkip()
			Loop
		EndIf
		If B1_COD < mv_par05 .Or. B1_COD > mv_par06
			dbSkip()
			Loop
		EndIf
		//�������������������Ŀ
		//� Filtro do Usuario �
		//���������������������
		If !Empty(aReturn[7])
			If !&(aReturn[7])
				dbSkip()
				Loop
			EndIf
		EndIf			
		cTipant := B1_TIPO
		Store 0 TO 	nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc
		Store 0 TO 	nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
		lPassou := .F.
		
		While !EOF() .And. B1_FILIAL+B1_TIPO == xFilial()+cTipAnt
			
			If lEnd
				@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
		
			If B1_COD < mv_par05 .Or. B1_COD > mv_par06
				dbSkip()
				Loop
			EndIf
			//�������������������Ŀ
			//� Filtro do Usuario �
			//���������������������
			If !Empty(aReturn[7])
				If !&(aReturn[7])
					dbSkip()
					Loop
				EndIf
			EndIf	
		
			IncRegua()
		
			//��������������������������������������������������������������Ŀ
			//� Saldo final e inicial dos almoxarifados                      �
			//����������������������������������������������������������������
			dbSelectArea("SB2")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !EOF() .And. B2_FILIAL+B2_COD == xFilial()+SB1->B1_COD .And. B2_LOCAL <= mv_par02
				//��������������������������������������������������������������Ŀ
				//� Verifica se deve somar custo da Mao de Obra no Saldo Final   �
				//����������������������������������������������������������������
				If	!(IsProdMod(SB2->B2_COD) .And. mv_par11 == 2)
					IF mv_par10==1
						nSaldoAtu := nSaldoAtu + &("B2_VATU"+cMoeda)
					Elseif mv_par10 == 2
						nSaldoAtu := nSaldoAtu + &("B2_VFIM"+cMoeda)
					Else
						aSaldoAtu	:= CalcEst(SB2->B2_COD,SB2->B2_LOCAL,mv_par08+1)
						nSaldoAtu 	:= nSaldoAtu + aSaldoAtu[mv_par09+1]
					EndIF
				EndIf	
				dbSkip()
			EndDo
		
			lPassou := IIF(nSaldoAtu > 0,.t.,lPassou)
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa as Entradas de um determinado produto               �
			//����������������������������������������������������������������
			dbSelectArea("SD1")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D1_FILIAL+D1_COD == xFilial()+SB1->B1_COD .And. D1_LOCAL <= mv_par02
			
				//��������������������������������������������������������������Ŀ
				//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
				//����������������������������������������������������������������
				If D1_ORIGLAN == "LF"
					dbSkip()
					Loop
				EndIf
			
				If cPaisLoc <> "BRA" .And. !Empty(D1_REMITO)
					dbSkip()
					Loop
				EndIf
				#IFDEF SHELL
					//��������������������������������������������������������������Ŀ
					//� Despreza Notas Fiscais Canceladas.                           �
					//����������������������������������������������������������������
					If SD1->D1_CANCEL == "S"
						dbSkip()
						Loop
					EndIf
				#ENDIF
				If D1_DTDIGIT < mv_par07 .Or. D1_DTDIGIT > mv_par08
					dbSkip()
					Loop
				EndIf
			
				dbSelectArea("SF4")
				dbSeek(xFilial()+SD1->D1_TES)
				dbSelectArea("SD1")
			
				If SF4->F4_ESTOQUE == "S"
					nValor := &("D1_CUSTO"+IIF(mv_par09 == 1," ",cMoeda))
					dbSelectArea("SD1")
					If SF4->F4_PODER3 == "N"
						If SD1->D1_TIPO == "D"
							nDevVendas  += nValor
						Else
							nCompras += nValor
						EndIf
					Else	
						nEntrTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa requisicoes                                         �
			//����������������������������������������������������������������
			dbSelectArea("SD3")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D3_FILIAL+D3_COD == xFilial()+SB1->B1_COD .And. D3_LOCAL <= mv_par02
				If D3_EMISSAO < mv_par07 .Or. D3_EMISSAO > mv_par08 .Or. D3_ESTORNO == "S"
					dbSkip()
					Loop
				EndIf
				
				//-- Filtro para Nao imprimir OPs referentes ao SIGAMNT
				If !Empty(D3_OP) .And. MV_PAR12 == 2 .And. !__lPyme 
					SC2->(dbSetOrder(1)) //-- C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
					If SC2->(dbSeek(xFilial('SC2')+SD3->D3_OP, .F.))
						If AllTrim(SC2->C2_ITEM) == 'OS' .AND. SC2->C2_SEQUEN == '001'
							dbSkip()
							Loop
						EndIf
					EndIf
				EndIf
				
				IF mv_par09 == 1
					nValor := D3_CUSTO1
				ElseIf mv_par09 == 2
					nValor := D3_CUSTO2
				ElseIf mv_par09 == 3
					nValor := D3_CUSTO3
				ElseIf mv_par09 == 4
					nValor := D3_CUSTO4
				ElseIf mv_par09 == 5
					nValor := D3_CUSTO5
				EndIf
			
				If D3_TM > "500"
					nValor := nValor*-1
				EndIf
			
				If Substr(D3_CF,1,2) == "PR"
					nProducao += nValor
				ElseIf D3_CF$"RE4/DE4"
					nReqTrans += nValor
				ElseIf Empty(D3_OP) .And. Substr(D3_CF,3,1) != "3"
					nReqCons += nValor
				ElseIf !Empty(D3_OP)
					nReqProd += nValor
				Else
					nReqOutr += nValor
				EndIf
				lPassou := .T.
				dbSkip()
			EndDo
		
			//��������������������������������������������������������������Ŀ
			//� Pesquisa Vendas                                              �
			//����������������������������������������������������������������
			dbSelectArea("SD2")
			dbSeek(xFilial()+SB1->B1_COD+mv_par01,.T.)
			While !Eof() .And. D2_FILIAL+D2_COD == xFilial()+SB1->B1_COD .And. D2_LOCAL <= mv_par02
				//��������������������������������������������������������������Ŀ
				//� Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal  �
				//����������������������������������������������������������������
				If D2_ORIGLAN == "LF"
					dbSkip()
					Loop
				EndIf
				If cPaisLoc <> "BRA" .And. !Empty(D2_REMITO)
					dbSkip()
					Loop
				EndIf
				If D2_EMISSAO < mv_par07 .Or. D2_EMISSAO > mv_par08
					dbSkip()
					Loop
				EndIf
			
				#IFDEF SHELL
					//��������������������������������������������������������������Ŀ
					//� Despreza Notas Fiscais Canceladas.                           �
					//����������������������������������������������������������������
					If SD2->D2_CANCEL == "S"
						dbSkip()
						Loop
					EndIf
				#ENDIF
				dbSelectArea("SF4")
				dbSeek(xFilial()+SD2->D2_TES)
				dbSelectArea("SD2")
				If SF4->F4_ESTOQUE == "S"
					nValor := &("D2_CUSTO"+cMoeda)
					dbSelectArea("SD2")
					If SF4->F4_PODER3 == "N"
						If SD2->D2_TIPO == "D"
							nDevComprs += nValor
						Else
							nVendas  += nValor
						EndIf
					Else
						nSaiTerc += nValor
					EndIf
					lPassou := .T.
				EndIf
				dbSkip()
			EndDo
			dbSelectArea("SB1")
			dbSkip()
		EndDo

		If lPassou
			lTotal:=.T.
			If li > 55
				Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
			EndIf
			li++
			nSalant := nSaldoAtu-nCompras-nReqProd-nReqCons-nProducao+nVendas-nReqTrans-nReqOutr-nDevVendas+nDevComprs-nEntrTerc+nSaiTerc
			// Posicoes (000,005,022,039,056,073,089,106,123,140,157,174,189,204)
			@ li,000 PSay cTipant
			@ li,005 PSay nSalant   Picture TM(nSalant,16)
			@ li,022 PSay nCompras  Picture TM(nCompras,16)
			@ li,039 PSay nReqCons  Picture TM(nReqCons,16)
			@ li,056 PSay nReqProd  Picture TM(nReqProd,16)
			@ li,073 PSay nReqTrans Picture TM(nReqTrans,16)
			@ li,089 PSay nProducao Picture TM(nProducao,16)
			@ li,106 PSay nVendas   Picture TM(nVendas,16)
			@ li,123 PSay nReqOutr  Picture TM(nReqOutr,16)
			@ li,140 PSay nDevVendas Picture TM(nDevVendas,16)
			@ li,157 PSay nDevComprs Picture TM(nDevComprs,16)
			@ li,174 PSay nEntrTerc Picture TM(nCompras,14)
			@ li,189 PSay nSaiTerc Picture TM(nVendas,14)
			@ li,204 PSay nSaldoAtu Picture TM(nSaldoAtu,16)
			nTotSant  += nSalant
			nTotComp  += nCompras
			nTotCons  += nReqCons
			nTotProc  += nReqProd
			nTotTrans += nReqTrans
			nTotProd  += nProducao
			nTotVend  += nVendas
			nTotEnTerc+= nEntrTerc
			nTotSaTerc+= nSaiTerc
			nTotSaldo += nSaldoAtu
			nTotOutr  += nReqOutr
			nTotDevVen+= nDevVendas
			nTotDevCom+= nDevComprs
		EndIf
		dbSelectArea("SB1")
	EndDo

#IFDEF TOP
	EndIf
#ENDIF

If lTotal
	li++;li++
	If li > 55
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf

	@ li,000 PSay STR0014	//"TOT.:"
	@ li,005 PSay nTotSant  PicTure tm(nTotSant ,16)
	@ li,022 PSay nTotComp  PicTure tm(nTotComp ,16)
	@ li,039 PSay nTotCons  PicTure tm(nTotCons ,16)
	@ li,056 PSay nTotProc  PicTure tm(nTotProc ,16)
	@ li,073 PSay nTotTrans PicTure tm(nTotTrans,16)
	@ li,089 PSay nTotProd  PicTure tm(nTotProd ,16)
	@ li,106 PSay nTotVend  PicTure tm(nTotVend ,16)
	@ li,123 PSay nTotOutr  PicTure tm(nTotOutr ,16)
	@ li,140 PSay nTotDevVen PicTure tm(nTotDevVen,16)
	@ li,157 PSay nTotDevCom PicTure tm(nTotDevCom,16)
	@ li,174 PSay nTotEnTerc Picture TM(nTotComp,14)
	@ li,189 PSay nTotSaTerc Picture TM(nTotVend,14)
	@ li,204 PSay nTotSaldo PicTure tm(nTotSaldo,16)
EndIf

If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//��������������������������������������������������������������Ŀ
//� Restauras as ordens principais dos arquivos envolvidos       �
//����������������������������������������������������������������
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(1)

#IFDEF TOP
    If lQuery 
		(cAliasTop)->(dbCloseArea())
    Endif		
#ENDIF

//��������������������������������������������������������������Ŀ
//� Devolve a condicao original do arquivo principal             �
//����������������������������������������������������������������
dbSelectArea(cString)
dbSetOrder(1)
dbClearFilter()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    �AjustaSX1 � Autor � Fernando Joly Siquini � Data �30.06.2005���
�������������������������������������������������������������������������Ĵ��
���Descri�ao �Cria a 12a pergunta                                         ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function AjustaSX1()

Local aHelpPor := {} 
Local aHelpEng := {} 
Local aHelpSpa := {} 
Local nTamSX1  := Len(SX1->X1_GRUPO)

aAdd(aHelpPor, 'Considera ou nao as OPs geradas pelo    ')
aAdd(aHelpPor, 'modulo de Manutencao de Ativos          ')
aAdd(aHelpPor, 'neste relatorio                         ')

aAdd( aHelpEng, 'It considers or not the POs generated by')
aAdd( aHelpEng, 'the Asset Maintenance module            ')
aAdd( aHelpEng, 'in this report                          ')

aAdd( aHelpSpa, 'Considera o no las OPs generadas por el ')
aAdd( aHelpSpa, 'modulo de Mantenimiento De Activos      ')
aAdd( aHelpSpa, 'en este informe                         ')

PutSx1( 'MTR320','12','Considera OPs do SIGAMNT     ?','�Considera OPs do SIGAMNT    ?','Consider POs from SIGAMNT    ?','mv_chc',;
'N',1,0,1,'C','','','','N','mv_par12','Sim','Si','Yes','',;
'Nao','No','No','','','','','','','','','',;
aHelpPor,aHelpEng,aHelpSpa)

dbSelectArea("SX1")
dbSetOrder(1)
If SX1->(DbSeek (PADR("MTR320",nTamSX1)+"12"))
	RecLock("SX1",.F.)
	Replace SX1->X1_PYME With "N"
	MsUnLock()
EndIf

Return Nil
