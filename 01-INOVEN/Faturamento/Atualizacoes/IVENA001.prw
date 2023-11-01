#include 'protheus.ch'
#include 'parmtype.ch'
#include "RWMAKE.CH"
STATIC __cPrgNom
//--------------------------------------------------------------------------------------
/*/
Rotina importação de tabela de preço

//DESENVOLVIDO POR INOVEN
@version  	P.12
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
User Function IVENA001()

	//--Cria nome da pergunta
	__cPrgNom := Substr( ProcName() , 3 ) + '__'
	 
	//--Valida existencia de pergunta, caso nao exista a mesma será criada
	SX1->( dbSetorder(1) )
	If ( !SX1->( MsSeek( __cPrgNom ) ) )
		FCriaPerg( __cPrgNom )
	EndIf	
	//--Executa pergunta
	If Pergunte(__cPrgNom,.T.)
		//--Função de leitura
		Processa({|lEnd| FsReadArq() })
	EndIf
	
Return( Nil )
//--------------------------------------------------------------------------------------
/*/

@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FCriaPerg(cPerg)
	
	Local aRegs	 := {}
	Local xI	 := 0
	Local xJ	 := 0
	
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	cPerg := PadR(cPerg,10)
	
	AADD(aRegs,{cPerg,"01","Tabela"		 ,"","","mv_ch1" ,"C",35,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
	AADD(aRegs,{cPerg,"02","Diretorio"	 ,"","","mv_ch2" ,"C",40,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","DIR",""})
	AADD(aRegs,{cPerg,"03","Vigencia De" ,"","","mv_ch3" ,"D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","",""})	
	AADD(aRegs,{cPerg,"04","Vigencia Ate","","","mv_ch4" ,"D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","",""})		
		
	For xI := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[xI,2])
			If RecLock("SX1",.T.)
				For xJ := 1 To Len(aRegs[xI])
					FieldPut(xJ,aRegs[xI,xJ])
				Next xJ
				MsUnlock()
			EndIf
		EndIf
	Next xI

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
Função realiza leitura do arquivo 


Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FsReadArq()

	Local cCamArq	:= MV_PAR02
	Local nQuant 	:= 0
	Local nLidos	:= 1
	Local cCodTab	:= ''
	Local cLinha	:= ''
	Local nTab		:= 0
	Local aTabelas 	:= STRTOKARR(AllTrim(MV_PAR01),"|")
	Local aNomeTab	:= {}
	Local nPos		:= 0
	Local cMsg		:= ''
	
	//--Formatar em tabela generica
	//--Array com os nomes das colunas
	Aadd(aNomeTab, {'PRCTAB1',0,'001'})
	Aadd(aNomeTab, {'PRCTAB2',0,'002'})
	Aadd(aNomeTab, {'PRCTAB3',0,'003'})
	//Aadd(aNomeTab, {'PRCTAB4',0,'004'})
	//Aadd(aNomeTab, {'PRCTAB5',0,'005'})
	//Aadd(aNomeTab, {'PRCTAB6',0,'006'})
	//Aadd(aNomeTab, {'PRCTAB7',0,'007'})
	//Aadd(aNomeTab, {'PRCTAB8',0,'008'})	
	
	//--Abre arquivo
	FT_FUSE(cCamArq)
	//--Qtd de registros
	nQuant:= FT_FLASTREC()   
	//--Regua
	ProcRegua(nQuant)
	//--SetOrder nas principais tabelas
	DA0->(DbSetOrder(01))
	DA1->(DbSetOrder(01))
	SB1->(DbSetOrder(01))
	//--Inicia processo de gravação dos dados
	Do While !FT_FEOF()
		IncProc('Aguarde...Processando Registros. ' + Ltrim(Str(nLidos)) + "  de " + Alltrim(Str(nQuant)))
		//--Leitura da primeira linha
		cLinha	:= FT_FREADLN()
		//--Limpa array
		aLinha  := {}
		Aadd(aLinha,aClone(StrTokArr2(cLinha,";",.T.)))
		//--Avaliação das linhas [Cabeçalhos]
		If Left(cLinha,3) == 'SKU'
			//--Define cabeçalho com as posições
			FCarreCab(@aNomeTab, aLinha)			
			FT_FSKIP()
			Loop		
		ElseIf Left(cLinha,1) == ';'//--Linha Vazia
			FT_FSKIP()
			Loop
		ElseIf Left(cLinha,3) == 'Rel'//--Pula linha
			FT_FSKIP()
			Loop		
		Else
			//--Valida existencia do Produto			
			If SB1->(DbSeek(xFilial('SB1')+AvKey(aLinha[1][1],'B1_COD')))
				//--Percorre todas as tabelas
				For nTab:= 1 To Len(aTabelas)
					//--Valida se informou tabela correta
					If DA0->(DbSeek(xFilial('DA0')+ aTabelas[nTab]))
						//--Posição da coluna [Preço]
						nPos:= Ascan(aNomeTab,{|x| x[3] == aTabelas[nTab]})
						If nPos > 0
						 	//--Busca preço de acordo com a coluna encontrada
							nPosTab:= Val(Replace(Replace((aLinha[1][aNomeTab[nPos][2]]),'.',''),',','.'))
						Else
							cMsg+='Erro produto: '+AllTrim(aLinha[1][1])+Chr(13)+Chr(10) 								
							//--Qualquer tabela fora das padronizadas
							//--Necessario informar de qual coluna deseja buscar o valor
							//-- Exemplo nPosTab:= Val(Replace(Replace((aLinha[1][1]),'.',''),',','.'))								
						EndIf		
						//--Posiciona na tabela + produto
						If DA1->(DbSeek(xFilial('DA1')+aTabelas[nTab]+AvKey(aLinha[1][1],'DA1_CODPROD')))							
							//--Atualiza preço
							If RecLock("DA1",.F.)
									Replace DA1->DA1_PRCVEN	With nPosTab,; 
											DA1->DA1_DATVIG	With MV_PAR04	
								DA1->(MsUnlock())
							EndIf					
						Else
							//--Produto não existe na tabela, o mesmo será incluido
							RecLock('DA1',.T.)
								Replace DA1->DA1_FILIAL With xFilial('DA1'),;
										DA1->DA1_CODTAB With aTabelas[nTab],;
										DA1->DA1_ITEM   With FbusItem(aTabelas[nTab]),;
										DA1->DA1_CODPRO	With AvKey(aLinha[1][1],'DA1_CODPROD'),;								
										DA1->DA1_PRCVEN	With nPosTab,;
										DA1->DA1_ATIVO	With '1',;
										DA1->DA1_TPOPER	With '4',;
										DA1->DA1_QTDLOT With 999999.99,;
										DA1->DA1_MOEDA	With 1,;
										DA1->DA1_DATVIG	With MV_PAR04,;
										DA1->DA1_INDLOT	With StrZero(99999999,18,2)
							DA1->(MsUnLock())
						EndIf				
						//--Atualiza cabeçalho tabela de preço
						If RecLock("DA0",.F.)
							Replace DA0->DA0_DATDE  With MV_PAR03,;
									DA0->DA0_DATATE	With MV_PAR04
							DA0->(MsUnlock())		
						EndIf
					EndIf
				Next nTab
			Else
				cMsg+='Erro produto não existe na base de dados : '+AllTrim(aLinha[1][1])+Chr(13)+Chr(10)
			EndIf				
		EndIf
		nLidos++			
		//--Pula linha
		FT_FSKIP()
	EndDo
	//--Fecha arquivo
	FT_FUSE()
	
	MsgAlert('Processo concluido')
	
	If !Empty(cMsg) 
		MsgAlert(OemToAnsi(cMsg))
	EndIf	

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
Função utilizada para buscar sequencial do item


Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//--------------------------------------------------------------------------------------- 
Static Function FbusItem(cCodTab)

	Local cQuery	:= ''
	Local aAlias	:= GetNextAlias()
	Local cCodItem	:= ''
	
	cQuery+="SELECT MAX(DA1_ITEM) AS MAXIMO "
	cQuery+="FROM "+RetSqlName('DA1')+" DA1 " 
	cQuery+="WHERE DA1_CODTAB 	= '"+cCodTab+"' "
	cQuery+="AND DA1_ATIVO  	= '1' "
	cQuery+="AND D_E_L_E_T_ = '' "
	
	DbUseArea(.T., "TOPCONN",TCGenQry(,,cQuery),aAlias,.T., .T.)
    
	cCodItem:=Soma1((aAlias)->MAXIMO) 
	
	(aAlias)->(DbCloseArea())

Return(cCodItem)
//--------------------------------------------------------------------------------------
/*/
Função carrega cabeçalho com os nomes


Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function FCarreCab(aNomeTab, aLinha)

	Local nPos	:= 0
	Local nX	:= 0
	
	For nX:= 1 To Len(aLinha[1])
		//--Valida posição do cabeçalho no array de tabelas
		nPos:= Ascan(aNomeTab,{|x| x[1] == AllTrim(aLinha[1][nX])})
		If nPos > 0
			//--Grava no array de cabeçalho a posição da coluna
			aNomeTab[nPos][2]:= nX
		EndIf
	Next nX

Return( Nil )
