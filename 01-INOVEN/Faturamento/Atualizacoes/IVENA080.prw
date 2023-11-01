#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWEVENTVIEWCONSTS.CH"       
#INCLUDE "FWADAPTEREAI.CH"     

#DEFINE SMMARCA	 	1
#DEFINE SMCODTRAN	2
#DEFINE SMNOMETRAN	3
#DEFINE SMVALOR		4
#DEFINE SMPRAZO		5

#DEFINE SMNUMCALC	6	
#DEFINE SMCLASSFRE 	7
#DEFINE SMTIPOPER  	8
#DEFINE SMTRECHO   	9
#DEFINE SMTABELA  	10
#DEFINE SMNUMNEGOC 	11
#DEFINE SMROTA     	12
#DEFINE SMDATVALID 	13
#DEFINE SMFAIXA    	14
#DEFINE SMTIPOVEI	15       
#DEFINE SMEXISTMP	16 

//-------------------------------------------------------------------
/*/{Protheus.doc} IVENA080
Rotina para realização da simulação de frete de acordo com rotina utilizada no GFE.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

//User Function IVENA080(_oObjCT,_oObjTFrt,_lMostra)
User Function IVENA080(_oObjCT,_oObjTFrt,_lMostra,_nPrvFrt,_cTrpPes)

	Local aArea 		:= GetArea()
	Local oModelSim  	:= FWLoadModel("GFEX010")
	Local oModelNeg  	:= oModelSim:GetModel("GFEX010_01")
	Local oModelAgr  	:= oModelSim:GetModel("DETAIL_01")  // oModel do grid "Agrupadores"
	Local oModelDC   	:= oModelSim:GetModel("DETAIL_02")  // oModel do grid "Doc Carga"
	Local oModelIt   	:= oModelSim:GetModel("DETAIL_03")  // oModel do grid "Item Carga"
	Local oModelTr   	:= oModelSim:GetModel("DETAIL_04")  // oModel do grid "Trechos"
	Local oModelInt  	:= oModelSim:GetModel("SIMULA")     // oModel do field que dispara a simulação
	Local oModelCal1 	:= oModelSim:GetModel("DETAIL_05")  // oModel do calculo do frete
	Local oModelCal2 	:= oModelSim:GetModel("DETAIL_06")  // oModel das informações complemetares do calculo
	Local nCont      	:= 0
	Local nRegua 		:= 0                   
	Local cCdClFr		:= "" //-- simulacao de frete: considerar todas a negociacoes cadastradas no GFE.
	Local cTpOp			:= "" //-- simulacao de frete: considerar todas a negociacoes cadastradas no GFE.
	Local cTpDoc		:= ''
	Local cTpVc			:= ''
	Local nLenAcols		:= 0
	Local nItem			:= 0
	Local nX			:= 0
	Local cCGCTran		:= ''                                        
	Local nVlrFrt		:= 0
	Local dPrevEnt      := CToD("//")
	Local nPrevEnt		:= 0         
	Local lPrevEnt      := SuperGetMV("LA_PREVENT",,.F.)
	Local aRet			:= {}
	Local nNumCalc		:= 0
	Local nClassFret	:= 0
	Local nTipOper		:= 0
	Local cTrecho		:= ""
	Local cTabela		:= ""
	Local cNumNegoc		:= ""
	Local cRota			:= ""
	Local dDatValid		:= ""
	Local cFaixa		:= ""
	Local cTipoVei		:= ""
	Local lInclui 		:= INCLUI
	Local cCgc 			:= ''
	/*Local _aHeaderOrc	:= oOrcamento:aHeader
	Local _nPosProd		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_PRODUTO"})
	Local _nPosQtde		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_QUANT"})
	Local _nPosVlr		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_VLRITEM"})*/
	Local _aHeaderOrc	:= {}
	Local _nPosProd		:= 0
	Local _nPosQtde		:= 0
	Local _nPosVlr		:= 0
	Local _nVlrPercent	:= 0.72
	Local _nTipoFrete	:= iif(valtype(_oObjTFrt) == "O",_oObjTFrt:nAt,1)
	Local _nVolume		:= 0
	Local cXXX := ""
	Local _aColsIt		:= {}
	
	Default _cTrpPes	:= ""

	Private cCodTrans	:= ""

	If IsInCallStack("U_IVENA020")
		_aHeaderOrc		:= oOrcamento:aHeader
		_aColsIt		:= oOrcamento:aCols
		_nPosProd		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_PRODUTO"})
		_nPosQtde		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_QUANT"})
		_nPosVlr		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2])=="UB_VLRITEM"})

		N 				:= oOrcamento:oBrowse:nAt
		xProd 			:= oOrcamento:aCols[oOrcamento:oBrowse:nAt,_nPosProd]
	else
		_aHeaderOrc		:= aHeader
		_aColsIt		:= aCols
		_nPosProd		:= Ascan(_aHeaderOrc,{|m| Alltrim(m[2]) == "C6_PRODUTO" })
		_nPosQtde		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
		_nPosVlr		:= aScan(_aHeaderOrc,{|x| AllTrim(x[2]) == "C6_VALOR"})

		cod_cli			:= M->C5_CLIENTE
		coja_cli		:= M->C5_LOJACLI
		xProd 			:= aCols[n,_nPosProd]
	endif


	
	//If !Empty(cod_cli) .And. !Empty(coja_cli) .And. !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,_nPosProd]) //.And. !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_QUANT", __aHeaderEx)]) .And. !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VLRITEM", __aHeaderEx)])	
	If !Empty(cod_cli) .And. !Empty(coja_cli) .And. !Empty(xProd) //.And. !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_QUANT", __aHeaderEx)]) .And. !Empty(oOrcamento:aCols[oOrcamento:oBrowse:nAt,GdFieldPos("UB_VLRITEM", __aHeaderEx)])	
	
		ProcRegua(nRegua)      
	
		SA1->(dbSeek(xFilial("SA1")+cod_cli+coja_cli))	   
	
		cCdClFr	:= "0001"	//define como carga fracionada
		cTpDoc := "" 
		//Verifica primeiro se existe a chave "NS" cadastrada, se n? busca a chave "N". Mesmo tratamento utilizado no OMSM011.
		cTpDoc	:= AllTrim(Posicione("SX5",1,xFilial("SX5")+"MQNS","X5_DESCRI"))
		If Empty(cTpDoc)
			cTpDoc := Alltrim(Posicione("SX5",1,xFilial("SX5")+"MQN","X5_DESCRI"))
		EndIf
			
		oModelSim:SetOperation(3) //Seta como inclusão
		oModelSim:Activate() 			
		
		oModelNeg:LoadValue('CONSNEG' ,"2" ) // -- 1=Considera Tab.Frete em Negociacao; 2=Considera apenas Tab.Frete Aprovadas
		IncProc()
		//Agrupadores - Não obrigatorio
		oModelAgr:LoadValue('GWN_CDCLFR',cCdClFr)  //classificação de frete                                 
		oModelAgr:LoadValue('GWN_CDTPOP',cTpOp)    //tipo da operação
		oModelAgr:LoadValue('GWN_CDTPVC',AllTrim(cTpVc))  	//Tipo de veiculo
		oModelAgr:LoadValue('GWN_DOC'   ,"ROMANEIO"     )           
		//Documento de Carga
		oModelDC:LoadValue('GW1_EMISDC', SM0->M0_CGC) 	//codigo do emitente - chave
		oModelDC:LoadValue('GW1_NRDC'  , ""  ) 	//numero da nota - chave
		oModelDC:LoadValue('GW1_CDTPDC', cTpDoc) 		// tipo do documento - chave
		oModelDC:LoadValue('GW1_CDREM' , IIF(_fL1ChkE(SM0->M0_CGC),SM0->M0_CGC, _fL1RetE(xFilial("SC5")) ) )  	//remetente
		oModelDC:LoadValue('GW1_CDDEST', IIF(_fL1ChkE(SA1->A1_CGC),SA1->A1_CGC, OMSM011COD(cod_cli,coja_cli,1,,) ) )   //destinatario
		oModelDC:LoadValue('GW1_TPFRET', "1")
		oModelDC:LoadValue('GW1_ICMSDC', "2")
		oModelDC:LoadValue('GW1_USO'   , "1")
		oModelDC:LoadValue('GW1_QTUNI' , 1)   
		//Trechos
		oModelTr:LoadValue('GWU_EMISDC' ,SM0->M0_CGC)												//codigo do emitente - chave
		oModelTr:LoadValue('GWU_NRDC'   ,""  ) 												//numero da nota - chave
		oModelTr:LoadValue('GWU_CDTPDC' ,cTpDoc)													// tipo do documento - chave
		oModelTr:LoadValue('GWU_SEQ'    ,"01"   )    												//sequencia - chave
		oModelTr:LoadValue('GWU_NRCIDD' ,AllTrim(TMS120CdUf(SA1->A1_EST, "1") + SA1->A1_COD_MUN))   // codigo da cidade para o calculo

		//nLenAcols := Len(oOrcamento:aCols)
		nLenAcols := Len(_aColsIt)

		dbSelectArea("SB5")
		cXXX := ""
		For nX:= 1 To nLenACols			
			//If !oOrcamento:aCols[nX][Len(_aHeaderOrc)+1]
			If !_aColsIt[nX][Len(_aHeaderOrc)+1]
				//Itens  								
				nItem += 1
				SB1->(DbSetOrder(1))
				//SB1->(dbSeek(xFilial("SB1")+oOrcamento:aCols[nX,_nPosProd]))
				SB1->(dbSeek(xFilial("SB1")+_aColsIt[nX,_nPosProd]))
				//--VERIFICAR QUESTÃO DOS PRODUTOS
				oModelIt:LoadValue('GW8_EMISDC',SM0->M0_CGC)	//codigo do emitente - chave
				oModelIt:LoadValue('GW8_NRDC'  ,""  ) 	//numero da nota - chave
				oModelIt:LoadValue('GW8_CDTPDC',cTpDoc) 		// tipo do documento - chave
				oModelIt:LoadValue('GW8_ITEM'  , "ITEM"+ PADL((nItem),3,"0")  )        		//codigo do item    -
				oModelIt:LoadValue('GW8_DSITEM', "ITEM GENERICO  "	+ PADL((nItem),3,"0"))  //descrição do item -
				oModelIt:LoadValue('GW8_CDCLFR',cCdClFr)    								//classificação de frete
				
				cXXX += "ITEM"+PADL((nItem),3,"0")
				cXXX += " - VOLUME:"
				//Incluso a informação do volume conforme solicitação do Sidnei (Neftali) - 15/10/2015.
				SB5->(dbSetOrder(1))
				//If SB5->(dbSeek(xFilial("SB5")+ oOrcamento:aCols[nX,_nPosProd]))
				If SB5->(dbSeek(xFilial("SB5")+ _aColsIt[nX,_nPosProd]))
					//_nVolume := (SB5->B5_ALTURA * SB5->B5_LARG * SB5->B5_COMPR) * oOrcamento:aCols[nX,_nPosQtde]
					_nVolume := (SB5->B5_ALTURA * SB5->B5_LARG * SB5->B5_COMPR) * _aColsIt[nX,_nPosQtde]
					oModelIt:LoadValue('GW8_VOLUME', _nVolume )    
					cXXX+= cValtoChar(_nVolume)    
				else
					cXXX+="0"
				EndIf
				
				/*oModelIt:LoadValue('GW8_PESOR' ,oOrcamento:aCols[nX,_nPosQtde] * SB1->B1_PESBRU ) 		//peso real
				oModelIt:LoadValue('GW8_VALOR' ,oOrcamento:aCols[nX,_nPosVlr] )     					//valor do item
				oModelIt:LoadValue('GW8_QTDE'  ,oOrcamento:aCols[nX,_nPosQtde] )     					//QTDE do item
				oModelIt:LoadValue('GW8_TRIBP' ,"1" )
				oModelIt:AddLine(.T.)  
				cXXX += " - PESO:"+cValtoChar(oOrcamento:aCols[nX,_nPosQtde] * SB1->B1_PESBRU)
				cXXX += " - VALOR:"+cValtoChar(oOrcamento:aCols[nX,_nPosVlr])
				cXXX += " - QTD:"+cValtoChar(oOrcamento:aCols[nX,_nPosQtde])*/ 
				oModelIt:LoadValue('GW8_PESOR' ,_aColsIt[nX,_nPosQtde] * SB1->B1_PESBRU ) 		//peso real
				oModelIt:LoadValue('GW8_VALOR' ,_aColsIt[nX,_nPosVlr] )     					//valor do item
				oModelIt:LoadValue('GW8_QTDE'  ,_aColsIt[nX,_nPosQtde] )     					//QTDE do item
				oModelIt:LoadValue('GW8_TRIBP' ,"1" )
				oModelIt:AddLine(.T.)  
				cXXX += " - PESO:"+cValtoChar(_aColsIt[nX,_nPosQtde] * SB1->B1_PESBRU)
				cXXX += " - VALOR:"+cValtoChar(_aColsIt[nX,_nPosVlr])
				cXXX += " - QTD:"+cValtoChar(_aColsIt[nX,_nPosQtde])
				cXXX += CHR(13)+CHR(10)	 								
			EndIf	
		Next nX   
	
		// Dispara a simulação
		oModelInt:SetValue("INTEGRA" ,"A") 	 
		IncProc()
		
		//Verifica se há linhas no model do calculo, se não há linhas significa que a simulação falhou
		If oModelCal1:GetQtdLine() > 1 .Or. !Empty( oModelCal1:GetValue('C1_NRCALC'  ,1) )
			//Percorre o grid, cada linha corresponde a um calculo diferente
			For nCont := 1 to oModelCal1:GetQtdLine()
				oModelCal1:GoLine( nCont )                                 			
	
				nVlrFrt	 		:= oModelCal1:GetValue('C1_VALFRT'  ,nCont )       
				//Alterado 09/10/2015 - BZO - De acordo com solicitação do Gilmar, sobre acrescentar o percentual de 28% no valor do frete.
				nVlrFrt			:= Round(Iif(_nTipoFrete<>1,(nVlrFrt/_nVlrPercent),nVlrFrt),TamSX3("UA_FRETE")[2])
				
				dPrevEnt        := oModelCal1:GetValue('C1_DTPREN'  ,nCont ) // alterado por Guilherme Muniz em 05/12/2016 - Tratamento de prazo negativo
				nPrevEnt  		:= Iif(!Empty(dPrevEnt),dPrevEnt - dDataBase,0)
	
				nNumCalc		:= oModelCal2:GetValue	("C2_NRCALC" ,1 )  //"Número Cálculo"
				nClassFret		:= oModelCal2:GetValue	("C2_CDCLFR" ,1 )  //"Class Frete"
				nTipOper		:= oModelCal2:GetValue	("C2_CDTPOP" ,1 )  //"Tipo Operação"
				cTrecho			:= oModelCal2:GetValue	("C2_SEQ" ,1 )     //"Trecho"
				cCGCTran		:= oModelCal2:GetValue	("C2_CDEMIT" ,1 )  //"Emit Tabela"
				cTabela			:= oModelCal2:GetValue	("C2_NRTAB" ,1 )   //"Nr tabela "
				cNumNegoc		:= oModelCal2:GetValue	("C2_NRNEG" ,1 )   //"Nr Negoc"
				cRota			:= oModelCal2:GetValue	("C2_NRROTA" ,1 )  //"Rota"
				dDatValid		:= oModelCal2:GetValue	("C2_DTVAL" ,1 )   //"Data Validade"
				cFaixa			:= oModelCal2:GetValue	("C2_CDFXTV" ,1 )  //"Faixa"
				cTipoVei		:= oModelCal2:GetValue	("C2_CDTPVC" ,1 )  //"Tipo Veículo"
				
				//para efeitos de debug
				cXXX += "Transportadora: "+cCGCTran
				cXXX += " Num. Calculo: "+nNumCalc
				cXXX += " Classe Frete: "+nClassFret
				cXXX += " Tipo Oper: "+nTipOper
				cXXX += " Tabela Frete: "+cTabela
				cXXX += " Negociacao: "+cNumNegoc
				  
											
				//alterado por Guilherme Muniz em 05/12/2016 - Tratamento de prazo negativo    
				cXXX += " Dias Previstos:"+  cValtoChar(nPrevEnt) 
				cXXX += " Data Prevista:"+  dtoc(dPrevEnt)
				cXXX += " Considera dias prev. ent <= 0?: "+  iif(lPrevEnt,".T.",".F.")
				//If nPrevEnt > 0 .Or. lPrevEnt
	
					dbSelectArea("GV9")
					GV9->(dbSetOrder(1))
					
					dbSelectArea("GVA")//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
					GVA->(dbSetOrder(1))
					
					SA4->(dbSetOrder(3))
					If SA4->(dbSeek(xFilial("SA4")+Padr(cCGCTran,TamSX3("A4_CGC")[1]))) 
					    cXXX += "A4_MSBLQL = "+SA4->A4_MSBLQL
					    IF SA4->A4_MSBLQL <> '1'			// Rodolfo 10/05/2017 - Desconsiderar transportadoras que estejam bloqueadas no cálculo do Frete.
							If GV9->(dbSeek(xFilial("GV9")+cCGCTran+cTabela))
								cXXX += " GV9_SIT = "  +AllTrim(GV9->GV9_SIT)
								If AllTrim(GV9->GV9_SIT) == '2'
									If GVA->(dbSeek(xFilial("GVA")+cCGCTran+cTabela))//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
										cXXX += " GVA_TPTAB = "  +AllTrim(GVA->GVA_TPTAB)
										If AllTrim(GVA->GVA_TPTAB) == '1'
											AADD (aRet, {,SA4->A4_COD,SA4->A4_NOME,nVlrFrt,nPrevEnt,nNumCalc,nClassFret,nTipOper,cTrecho,cTabela,cNumNegoc,cRota,dDatValid,cFaixa,cTipoVei,.T.})			   
										EndIf
									EndIf//Gilmar 27/07/2016 para trata somente timpo normal da tabela.	
								EndIf
							Else
								cXXX += " - NAO TEM GV9"
								If GVA->(dbSeek(xFilial("GVA")+cCGCTran+cTabela))//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
										cXXX += " - TEM GVA - GVA_TPTAB = "+GVA_TPTAB
										If AllTrim(GVA->GVA_TPTAB) == '1'
											AADD (aRet, {,SA4->A4_COD,SA4->A4_NOME,nVlrFrt,nPrevEnt,nNumCalc,nClassFret,nTipOper,cTrecho,cTabela,cNumNegoc,cRota,dDatValid,cFaixa,cTipoVei,.T.})
										EndIf
								EndIf//Gilmar 27/07/2016 para trata somente timpo normal da tabela.			   
							EndIf
						ENDIF
					Else
						cCGC := _fL1RCGC(cCGCTran) 
						cXXX += " - OUTRO CNPJ"+cCGC
						If SA4->(dbSeek(xFilial("SA4")+cCGC))
							cXXX += " - TEM SA4"
							IF SA4->A4_MSBLQL <> '1'		// Rodolfo 10/05/2017 - Desconsiderar transportadoras que estejam bloqueadas no cálculo do Frete.				
								cXXX += " - DESBLOQUEADA SA4"
								//If GV9->(dbSeek(xF/ilial("GV9")+cCGC+cTabela))
								//--Helder - Rodolfo 18/07/19
								If GV9->(dbSeek(xFilial("GV9")+cCGCTran+cTabela))								
									cXXX += " - TEM GV9"
									If AllTrim(GV9->GV9_SIT) == '2'
										cXXX += " - GV9_SIT = 2"
										If GVA->(dbSeek(xFilial("GVA")+cCGCTran+cTabela))//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
											If AllTrim(GVA->GVA_TPTAB) == '1'
												AADD (aRet, {,SA4->A4_COD,SA4->A4_NOME,nVlrFrt,nPrevEnt,nNumCalc,nClassFret,nTipOper,cTrecho,cTabela,cNumNegoc,cRota,dDatValid,cFaixa,cTipoVei,.T.})
											EndIf
										EndIf//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
									EndIf
								Else 
									cXXX += " - NAO TEM GV9"
									If GVA->(dbSeek(xFilial("GVA")+cCGC+cTabela))//Gilmar 27/07/2016 para trata somente timpo normal da tabela.
										cXXX += " - TEM GVA - GVA_TPTAB = "+GVA_TPTAB
										If AllTrim(GVA->GVA_TPTAB) == '1'
											AADD (aRet, {,SA4->A4_COD,SA4->A4_NOME,nVlrFrt,nPrevEnt,nNumCalc,nClassFret,nTipOper,cTrecho,cTabela,cNumNegoc,cRota,dDatValid,cFaixa,cTipoVei,.T.})
										EndIf
									EndIf//Gilmar 27/07/2016 para trata somente timpo normal da tabela.	
							EndIf
						ENDIF
						Else
							AADD (aRet, {,cCGCTran,"Transportadora não cadastrada no Microsiga Protheus!",nVlrFrt,nPrevEnt,nNumCalc,nClassFret,nTipOper,cTrecho,cTabela,cNumNegoc,cRota,dDatValid,cFaixa,cTipoVei,.F.}) //--"Transportadora não cadastrada no Microsiga Protheus!!!"
						EndIf
					EndIf	
				//EndIf 
				cXXX += CHR(13)+CHR(10)
			Next nCont    
			
			If !Empty(aRet)
				_aTranspGFE	:= aClone(aRet)
				If _lMostra
					_fLDM1RS(aRet,_oObjCT,@_nPrvFrt)
				else
					if !empty(_cTrpPes)
						lAchou := 0
						for nX := 1 to len(aRet)
							if alltrim(aRet[nX][2]) == alltrim(_cTrpPes)
								cCodTrans 	:= aRet[nX][2]
								_nPrvFrt	:= aRet[nX][4]
								lAchou := 1
								exit
							endif
						next
						if empty(lAchou)
							_cTrpPes := ""
						endif
					endif
					if empty(_cTrpPes)
						aSort(aRet,,,{|x,y| str(x[4],14,2) < str(y[4],14,2)})

						cCodTrans 	:= aRet[len(aRet)][2]
						_nPrvFrt	:= aRet[len(aRet)][4]
					endif
				EndIf
			EndIf			
			
		EndIf
	Else
	
		Help(" ",1,"A410SMLFRT")  		
	
	EndIf  
	//MemoWrite( "c:\temp\calculofrete.txt", cXXX )
	INCLUI := lInclui
	RestArea(aArea)		
	                
	//alterado por Guilherme Muniz em 27/01/2017
	//If IsInCallStack("DNYCalcFrt")
	//	Return( {cCodTrans, _nDNYVlFrt} )
	//EndIf

Return(cCodTrans)

//-------------------------------------------------------------------
/*/{Protheus.doc} _fL1ChkE
Função para validação do Emitente.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
Static Function _fL1ChkE(cCod)

	Local aArea  := GetArea()
	Local lEncontrou := .F.
	
	dbSelectArea("GU3")
	dbSetOrder(1)
	
	If DBSeek(xFilial("GU3") + cCod)
		lEncontrou := .T.
	EndIf
		 
	RestArea(aArea)

Return lEncontrou

//-------------------------------------------------------------------
/*/{Protheus.doc} _fL1RetE
Função para retorno do código do remetente, de acordo com GFE.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
Static Function _fL1RetE(cFil)

	Local aAreaGW0
	Local aArea := GetArea()
	Local cCodGFE := ""
	
	aAreaGW0 := GW0->( GetArea() )
	dbSelectArea("GW0")
	GW0->( dbSetOrder(1) )
	GW0->( DbSeek( Space( TamSx3("F2_FILIAL")[1] )+PadR( "FILIALEMIT",TamSx3("GW0_TABELA")[1] )+PadR( cFil,TamSx3("GW0_CHAVE")[1] ) ) )
	If !GW0->( EOF() ) .And. GW0->GW0_FILIAL == Space( TamSx3("F2_FILIAL")[1] ) .And. ;
		GW0->GW0_TABELA == PadR( "FILIALEMIT",TamSx3("GW0_TABELA")[1] ) .And. ;
	  	GW0->GW0_CHAVE == PadR( cFil,TamSx3("GW0_CHAVE")[1] )
	
		cCodGFE := PadR( GW0->GW0_CHAR01,TamSx3("GW1_EMISDC")[1] )
	EndIf
	
	RestArea( aAreaGW0 )	
	RestArea( aArea )
			
Return cCodGFE

//-------------------------------------------------------------------
/*/{Protheus.doc} _fL1RCGC
Função para retorno do CPF/CNPJ do emitente.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
Static Function _fL1RCGC(cCodEmit)

	Local cCGC  := ""
	Local aArea := GetArea()
	
	dbSelectArea("GU3")
	dbSetOrder(1)
	
	If DBSeek(xFilial("GU3") + cCodEmit)
		cCGC := GU3->GU3_IDFED
	EndIf
	
	RestArea( aArea )

Return cCGC

//-------------------------------------------------------------------
/*/{Protheus.doc} _fLDM1RS
Função para apresentação da tela de Simulação de frete.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
Static Function _fLDM1RS(aListBox,_oObjCT,_nPrvFrt)

	Local aSize     	:= {}
	Local aObjects  	:= {}
	Local aInfo     	:= {}
	Local aPosObj   	:= {}  
	Local oOk       	:= LoadBitMap(GetResources(),"LBOK")
	Local oNo       	:= LoadBitMap(GetResources(),"LBNO")
	Local oBtn01
	Local oBtn02
//	Local cCodTrans 	:= ""
	Local _cNomTrans	:= ""
	Local _nLVlrFrt		:= 0
	Local nItemMrk		:= 0
	Local nOpca			:= 0
	
	Default aListBox:= {}
	
	Private oListBox:= Nil
	Private oDlg	 := Nil
										  
	//-- Rotinas Marcadas
	Private aRotMark:= {}                                                         
										
	aSize    	:= MsAdvSize(.F. )
	aObjects 	:= {}
		
	AAdd( aObjects, { 100, 000, .T., .F., .T.  } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	AAdd( aObjects, { 100, 005, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ]*0.60, aSize[ 4 ]*0.68, 3, 3, .T.  }
	aPosObj := MsObjSize( aInfo, aObjects, .T. )
		
	DEFINE MSDIALOG oDlg TITLE "Simulação de Frete" From aSize[7],0 to aSize[6]*0.68,aSize[5]*0.61 OF oMainWnd PIXEL //--"Simulação de Frete"
		
			oPanel := TPanel():New(aPosObj[1,1],aPosObj[1,2],"",oDlg,,,,,CLR_WHITE,(aPosObj[1,3]), (aPosObj[1,4]), .T.,.T.)
				
			//-- Cabecalho dos campos do Monitor.                                                        
			@ aPosObj[2,1],aPosObj[2,2] LISTBOX oListBox Fields HEADER;
			  "","Cod.Transp.","Nome Transp.","Valor do Frete","Prazo de Entrega (Dias)","Número do Cálculo", "Classificação do Frete", "Tipo de Operação", "Trecho", "Tabela", "Negociação", "Rota", "Validade", "Faixa", "Veiculo"  SIZE aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] PIXEL //--"Nome Transp.","Valor do Frete","Cod.Transp.","Prazo de Entrega (Dias)"
						
			oListBox:SetArray( aListBox )
			//oListBox:bLDblClick := { || _fL1MrkS(aListBox,@nItemMrk,@cCodTrans,@_cNomTrans,@_nLVlrFrt,@_nDnyVlFrt) }                              
			oListBox:bLDblClick := { || _fL1MrkS(aListBox,@nItemMrk,@cCodTrans,@_cNomTrans,@_nLVlrFrt) }                              
			oListBox:bLine      := { || {	Iif(aListBox[ oListBox:nAT,SMMARCA 	] == '1',oOk,oNo),;	
												aListBox[ oListBox:nAT,SMCODTRAN	],;				
												aListBox[ oListBox:nAT,SMNOMETRAN	],;
												aListBox[ oListBox:nAT,SMVALOR	   	],;
												aListBox[ oListBox:nAT,SMPRAZO	   	],; 
												aListBox[ oListBox:nAT,SMNUMCALC	],;
												aListBox[ oListBox:nAT,SMCLASSFRE 	],;
												aListBox[ oListBox:nAT,SMTIPOPER  	],;
												aListBox[ oListBox:nAT,SMTRECHO   	],;
												aListBox[ oListBox:nAT,SMTABELA  	],;
												aListBox[ oListBox:nAT,SMNUMNEGOC 	],;
												aListBox[ oListBox:nAT,SMROTA     	],;
												aListBox[ oListBox:nAT,SMDATVALID 	],;
												aListBox[ oListBox:nAT,SMFAIXA    	],;
												aListBox[ oListBox:nAT,SMTIPOVEI	]}}		        
									
			//-- Botoes da tela do monitor.
			@ aPosObj[3,1],001 BUTTON oBtn01	PROMPT "Confirmar"	ACTION (nOpca := 1, oDlg:End()) OF oDlg PIXEL SIZE 035,011	//-- "Confirmar"
			@ aPosObj[3,1],040 BUTTON oBtn02	PROMPT "Sair"	ACTION oDlg:End() OF oDlg PIXEL SIZE 035,011	//-- "Sair"																										                                                    		

		ACTIVATE MSDIALOG oDlg CENTERED

		If nOpca == 1
			cod_trp 	:= cCodTrans 
			come_transp	:= _cNomTrans
			_nDnyVlFrt	:= _nLVlrFrt
			_nPrvFrt	:= _nLVlrFrt
			
			Public _nNewVlFrt := _nDnyVlFrt
//			Public _cNewDetal := _cDetalhe
			
			_oObjCT:cCaption := cCodTrans
			_oObjCT:Refresh()
			
			oDlgFimCot:Refresh()
		End If

Return(cCodTrans)	
	
//-------------------------------------------------------------------
/*/{Protheus.doc} _fL1MrkS
Função para realizar a marcação da Transportadora.

@author 	BZechetti | Bruna Zechetti de Oliveira
@since 		07/10/2015
@version 	P11
@obs    	
/*/
//-------------------------------------------------------------------
Static Function _fL1MrkS(aListBox,nItemMrk,cCodTrans,_cNomTrans,_nLVlrFrt)

	Local nItem   		:= oListBox:nAt
	
	Default aListBox	:= {}
	Default nItemMrk	:= 0 	//Item já marcado        
	Default cCodTrans	:= "" 
	
	If nItemMrk == 0  //Nenhum Item Marcado em Memória
		If aListBox[nItem,SMEXISTMP]
			cCodTrans 				:= aListBox[nItem,SMCODTRAN]
			_cNomTrans				:= aListBox[nItem,SMNOMETRAN]
			_nLVlrFrt				:= aListBox[nItem,SMVALOR]
			aListBox[nItem,SMMARCA] := '1'	
			nItemMrk 				:= nItem                         		
		Else
			MsgAlert("Transportadora não cadastrada no Microsiga Protheus!")
		EndIf
		
	ElseIf nItemMrk == nItem //Item Já Marcado
		aListBox[nItem,SMMARCA] := '2'                
		nItemMrk 				:= 0
		cCodTrans 				:=  ""
		
	Else //Marca o Item selecionado e desmarca o Item já marcado anteriormente.
		If aListBox[nItem,SMEXISTMP]
			aListBox[nItem,SMMARCA] 	:= '1'			
			aListBox[nItemMrk,SMMARCA] 	:= '2'				
			nItemMrk 					:= nItem                         		
			cCodTrans 					:= aListBox[nItem,SMCODTRAN]		
			_cNomTrans					:= aListBox[nItem,SMNOMETRAN]
			_nLVlrFrt					:= aListBox[nItem,SMVALOR]
		Else
			MsgAlert("Transportadora não cadastrada no Microsiga Protheus!")
		EndIf	
	EndIf	
		
	oListBox:Refresh()
						
Return(Nil)	
