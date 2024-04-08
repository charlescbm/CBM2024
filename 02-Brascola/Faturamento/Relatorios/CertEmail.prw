#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"                        
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TopConn.ch"        
#INCLUDE "TbiConn.ch"
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CERTQEMAIL� Autor �                    � Data �  02/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Certificados de Qualidade por email                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Brascola                                                   ���
�������������������������������������������������������������������������͹��
���Parametros� BR_EMCERT - E-mail que sera notificado das inconsistencias ���
�������������������������������������������������������������������������͹��
���Rogerio   � Implementacao de melhorias na rotina                       ���
���06/02/06  � - Permitir impressao de Certificados diretamente do modulo ���
���          �de inspecao de entregas                                     ���
���          � - Permitir impressao de itens de segundo nivel na estrutura���
���          �quando nao encontrar no primeiro nivel                      ���
���          � - Imprimir relatorio final com inconsistencias em vez de   ���
���          �certificados parciais inconsistentes.                       ���
���Elias Reis� - Permitir impressao de certificados de itens da NF, para o���
���30/08/06  �   caso de o usuario ja ter impresso o certificado de algum ���
���          �   item, e nao ter que repetir a impressao de todos novament���
���          �   e.                                                       ���
���Thiago(SS)� - Envio dos certificados via email no formato html         ���
���14/06/10  �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CertQEmail()
**************************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= "Certificados de Qualidade por Email"
Local lJob		:= .t.
Local nProcessa		:= 3
//Local lAuto			:= If(lAuto == NIL,{.F.},lAuto)

RPCSetType(3)  // Nao usar Licensa
PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "U_CTQUAE()"  TABLES "SA1","SA7","SB1","SB8","SC2","SD1","SD2","SD3","SD5","SF2","SG1","QE1","QE6","QE7","QE8","QEK","QEQ","QER","QES","QIE","QIP","QP1","QP6","QP7","QP8","QPR","QPS","QPQ"

U_CTQUAE()

//Processa({ ||U_CertQuaE()}, "Certificados de Qualidade por Email",,.t.)
RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)

User Function CTQUAE()
************************
Local aRegs     := {}
Local cOP       := ""
Local cChave    := ""
Local cPerg     := "CTFQLD"
Local _aCBC     := {}
Local _aItem 	:= {}
Local _aResul	:= {}
Local lGravaCBC	:= .f.
Local aInconSub1:= {}
Local aInconSub2:= {}
Local aEstrutura:= {}
Local nCasas
Private cProduto:= ""
Private aIncon  := {}
Private cLote   := "" 
//Private cData   := '20130131'

// ����������������������������������������������������������������Ŀ
// � Prepara perguntas de filtro para emissao do(s) Certificado(s)  �
// ������������������������������������������������������������������
AADD(aRegs,{cPerg,"01","NF Inicial         ?"," "," ","mv_ch1","C",09,0,0,"G","","mv_par01"})
AADD(aRegs,{cPerg,"02","NF Final           ?"," "," ","mv_ch2","C",09,0,0,"G","","mv_par02"})
AADD(aRegs,{cPerg,"03","Serie              ?"," "," ","mv_ch3","C",03,0,0,"G","","mv_par03"})
AADD(aRegs,{cPerg,"04","Produto        	   ?"," "," ","mv_ch4","C",15,0,0,"G","","mv_par04"})
//AADD(aRegs,{ALLTRIM(cPerg),"05","Item Final         ?"," "," ","mv_ch5","C",2,0,0,"G","","mv_par05"})

// ����������������������������������������������������������������Ŀ
// � Cria arquivo temporario com cabecalho do certificado (CBC)     �
// ������������������������������������������������������������������

Aadd(_aCBC,{"NOTA"         ,"C",009,0})
Aadd(_aCBC,{"SERIE"        ,"C",003,0})
Aadd(_aCBC,{"CLIENTE"      ,"C",008,0})
Aadd(_aCBC,{"LOJA"         ,"C",004,0})
Aadd(_aCBC,{"PRODUTO"      ,"C",015,0})
Aadd(_aCBC,{"ITEM"         ,"C",004,0})
Aadd(_aCBC,{"NOME"         ,"C",040,0})
Aadd(_aCBC,{"EMISSAO"      ,"D",008,0})

_cArqCbc := CriaTrab(_aCBC,.T.)

//Verifica se o Alias j� est� aberto, antes de abrir novamente
//Elias 08/02/2006
If Select("CBC") > 0
	dbCloseArea("CBC")
EndIF

ConOut("----------------------------------------")
ConOut(" Inicio de Processamento "+Time())
ConOut("----------------------------------------")

dbUseArea( .T.,,_cArqCbc, "CBC", .F., .F. )

// �������������������������������������������������������������Ŀ
// � Cria arquivo temporario com itens do certificado (ITEM)     �
// ���������������������������������������������������������������
Aadd(_aItem,{"NOTA"         ,"C",009,0})
Aadd(_aItem,{"SERIE"        ,"C",003,0})
Aadd(_aItem,{"PRODUTO"      ,"C",015,0})
Aadd(_aItem,{"ITEM"         ,"C",004,0})
Aadd(_aItem,{"DESC"         ,"C",050,0})
Aadd(_aItem,{"UM"           ,"C",002,0})
Aadd(_aItem,{"LOTE"         ,"C",011,0})
Aadd(_aItem,{"FABRI"        ,"D",008,0})
Aadd(_aItem,{"DTVALID"      ,"D",008,0})
Aadd(_aItem,{"QUANT"        ,"N",014,2})

_cArqItm := CriaTrab(_aItem,.T.)

If Select("ITEM") > 0
	dbCloseArea("ITEM")
EndIF

dbUseArea( .T.,,_cArqItm, "ITEM", .F., .F. )

// ����������������������������������������������������������������������Ŀ
// � Cria arquivo temporario com detalhes do certificado por item (RESUL) �
// ������������������������������������������������������������������������
Aadd(_aResul,{"NOTA"         ,"C",009,0})
Aadd(_aResul,{"SERIE"        ,"C",003,0})
Aadd(_aResul,{"PRODUTO"      ,"C",015,0})
Aadd(_aResul,{"ITEM"         ,"C",004,0})
Aadd(_aResul,{"LOTE"         ,"C",011,0})
Aadd(_aResul,{"ENSAIO"       ,"C",050,0})
Aadd(_aResul,{"NOME"         ,"C",050,0})
Aadd(_aResul,{"ESPEC"        ,"C",050,0})
Aadd(_aResul,{"RESULT"       ,"C",050,0})

_cArqRes := CriaTrab(_aResul,.T.)

If Select("RESUL") > 0
	dbCloseArea("RESUL")
EndIF

dbUseArea(.T.,,_cArqRes,"RESUL",.F.,.F.)

MV_PAR01:= "         "
MV_PAR02:= "ZZZZZZZZZ"
MV_PAR03:= "7  "
MV_PAR04:= Space(15)

//ProcRegua(VAL(MV_PAR02) - VAL(MV_PAR01))
IF .T. //PERGUNTE(cPerg)
	//PERGUNTE(cPerg,.F.)

	CursorWait()
	
	// ��������������������������������������������������������Ŀ
	// � Varre Notas Fiscais de Saida com o Filtro Selecionado  �
	// ����������������������������������������������������������
	DbSelectArea("SF2")
	
	//SF2->(DbSetOrder(9)) //FILIAL+EMISSAO+DOC+SERIE   
	SF2->(DbSetOrder(3)) //FILIAL+EMISSAO+DOC+SERIE 
	//F2_FILIAL, F2_ECF, F2_EMISSAO
	MSSeek(xFilial("SF2")+" "+DtoS(dDataBase))  
    //MSSeek(xFilial("SF2")+" "+cData)//Fernando
	While SF2->(!EOF()) .AND. SF2->F2_FILIAL==xFilial("SF2") .AND. DtoS(SF2->F2_EMISSAO)==DtoS(dDataBase)
	//While SF2->(!EOF()) .AND. SF2->F2_FILIAL==xFilial("SF2") .AND. DtoS(SF2->F2_EMISSAO) == cData //Fernando
		If AllTrim(SF2->F2_SERIE) <> AllTrim(MV_PAR03)
		   SF2->(DBSKIP())
		   LOOP
		ENDIF		   
		// ��������������������������������������������������������Ŀ
		// � So trata Cliente / Desconsidera Fornecedor             �
		// ����������������������������������������������������������
		If SF2->F2_TIPO $ "BD"
			DBSELECTAREA("SF2")
			SF2->(DbSkip())
			Loop
		Endif		
		cOP := ""
		INCPROC("Selecionando Registros")
		DBSELECTAREA("SA1")
		DBSETORDER(1)
		If SA1->(DBSEEK( xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))  
			// ��������������������������������������������������������Ŀ
			// � Valida se cliente necessita de certificado             �
			// ����������������������������������������������������������
			If SA1->A1_CERTQUA $ "1/S"
				DBSELECTAREA("SD2")
				DBSETORDER(3)				
				// ��������������������������������������������������������Ŀ
				// � Varre os itens da Nota Fiscal                          �
				// ����������������������������������������������������������
				IF DBSEEK( XFILIAL("SD2") + SF2->F2_DOC + SF2->F2_SERIE)
					WHILE !EOF() .AND. ALLTRIM(SD2->D2_DOC) == ALLTRIM(SF2->F2_DOC) .AND. ALLTRIM(SD2->D2_SERIE) == ALLTRIM(SF2->F2_SERIE)						
						If Empty(SD2->D2_LOTECTL)
							SD2->(DbSkip())
							Loop
						Endif
						
						cOP	     := ""
						cProduto := ""
						
						// ��������������������������������������������������������Ŀ
						// � Analise de quais dados serao impressos no certificado  �
						// ����������������������������������������������������������
						
						// ������������������������������������������������������������������Ŀ
						// � 1. Verifica se existe Especificacao, OP e Resultado Deste Lote   �
						// � no Modulo de Inspecao de Processos                               �
						// ��������������������������������������������������������������������
						
						DbSelectArea("QP6")
						QP6->(DbSetOrder(1))
						If QP6->(DbSeek( xFilial("QP6") + SD2->D2_COD)) .AND. QP6->QP6_SKPLOT <> '27'
							cProduto := ALLTRIM(SD2->D2_COD)
							
							DbSelectArea("SC2")
							SC2->(DbSetOrder(11))		// C2_FILIAL+C2_LOTECTL+C2_PRODUTO
							//IF DBSEEK( XFILIAL("SC2") + SD2->D2_LOTECTL + cProduto) // Daniel Neves - 19.09.05 - Indice sem produto
							If SC2->(DbSeek( xFilial("SC2") + SD2->D2_LOTECTL)) 
							//If SC2->(DbSeek(SD2->D2_LOTECTL))
								While SC2->(!EOF()) .AND. SC2->C2_LOTECTL == SD2->D2_LOTECTL									
									IF AllTrim(SC2->C2_PRODUTO ) == cProduto
										cOP := AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN) //- Daniel N. - os registros tem que ser identicos
										Exit
									ENDIF
									SC2->(DbSkip())
								ENDDO
								
								DbSelectArea("QPR")//Medi��es � Dados Gen�ricos
								QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
								If QPR->(DbSeek( xFilial("QPR") + cOP + "  " + SD2->D2_LOTECTL ))
									If GravaCBC("QIP")
										GravaQIP(cOP,SD2->D2_LOTECTL)
									Endif
								Else
									Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD2->D2_LOTECTL + " sem resultados"})
									// ��������������������������������������������������������Ŀ
									// � Inicia analise do proximo item da Nota Fiscal de Saida �
									// ����������������������������������������������������������
									DbSelectArea("SD2")
									SD2->(DbSkip())
									Loop
								Endif
								
								// ��������������������������������������������������������Ŀ
								// � Inicia analise do proximo item da Nota Fiscal de Saida �
								// ����������������������������������������������������������
								DbSelectArea("SD2")
								SD2->(DbSkip())
								Loop								
								// ����������������������������������������������������������������������������Ŀ
								// � Bloco abaixo comentado em 28/04 - Pois encontramos um produto no QIP e QIE �
								// ������������������������������������������������������������������������������						
							Endif
						Endif						
						// �����������������������������������������������������������������������Ŀ
						// � 3. Analisa estrutura do produto e imprime valores dos resultados de   �
						// � todos os PIs da estrutura                                             �
						// �������������������������������������������������������������������������
						DbSelectArea("SG1")
						SG1->(DbSetOrder(1))
						QP6->(DbSetOrder(1))						
						
						aInconSub1 	:= {}
						aInconSub2 	:= {}
						aEstrutura	:= {}					
						If SG1->(DbSeek( xFilial("SG1") + SD2->D2_COD))
							lGravaCBC := .f.
							While SG1->(!EOF()) .AND. ;
								AllTrim(SG1->G1_COD) == AllTrim(SD2->D2_COD)
								// ��������������������������������������������������������Ŀ
								// � Considerar somente PI/PAs				                  �
								// ����������������������������������������������������������
								If ! AllTrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COD,"B1_TIPO")) $ "3/4"
									SG1->(DbSkip())
									Loop
								Endif
								// ��������������������������������������������������������Ŀ
								// � Carrega com a estrutura a ser avaliada no nivel 2      �
								// ����������������������������������������������������������
								Aadd(aEstrutura,SG1->G1_COMP)
								If QP6->(DbSeek(xFilial("QP6") + SG1->G1_COMP))
									cProduto := ALLTRIM(SG1->G1_COMP)
									// ��������������������������������������������������������Ŀ
									// � O Lote do PA eh igual ao Lote do PI                    �
									// ����������������������������������������������������������
									DbSelectArea("SC2")
									SC2->(DbSetOrder(11))		// C2_FILIAL+C2_LOTECTL+C2_PRODUTO
									lNumeroPAPI := .T.
									cOp := ""
									If SC2->(DbSeek( xFilial("SC2") + SD2->D2_LOTECTL))
										While SC2->(!EOF()) .AND. ;
											SC2->C2_LOTECTL == SD2->D2_LOTECTL											
											IF AllTrim(SC2->C2_PRODUTO ) == cProduto
												cOP := AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN) //- Daniel N. - os registros tem que ser identicos
												Exit
											Endif
											SC2->(DbSkip())
										Enddo										
										If Empty(cOP)
											lNumeroPAPI := .f.
										Else
											DbSelectArea("QPR")
											QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
											If QPR->(DbSeek( xFilial("QPR") + cOP + "  " + SD2->D2_LOTECTL ))
												GravaQIP(cOP,SD2->D2_LOTECTL)
												lGravaCBC := .t.
											Else
												Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD2->D2_LOTECTL + " sem resultados"})												
												// ��������������������������������������������������������Ŀ
												// � Inicia analise do proximo item da estrutura            �
												// ����������������������������������������������������������
												SG1->(DbSkip())
												Loop
											Endif
										Endif
									Endif
									// ��������������������������������������������������������Ŀ
									// � Nao encontrou OP de PI com o mesmo numero da OP do PA  �
									// � Ira analisar os lotes utilizados na OP para localizar  �
									// � qual lote de PI foi utilizado na fabricacao do PA e    �
									// � imprime os dados deste lote.                           �
									// ����������������������������������������������������������
									If ! lNumeroPaPi
										SC2->(DbSetOrder(11))		// C2_FILIAL+C2_LOTECTL+C2_PRODUTO
										If SC2->(DbSeek(xFilial("SC2") + SD2->D2_LOTECTL + SD2->D2_COD))
											SD3->(DbSetOrder(1))		//	D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
											If SD3->(DbSeek(xFilial("SD3") + SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD) + cProduto))
												If ! Empty(SD3->D3_LOTECTL)
													If SC2->(DbSeek(xFilial("SC2") + SD3->D3_LOTECTL + cProduto))
														cOp := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
														DbSelectArea("QPR")
														QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
														If QPR->(DbSeek( xFilial("QPR") + cOp + "  " + SD3->D3_LOTECTL ))
															GravaQIP(cOP,SD3->D3_LOTECTL)
															lGravaCBC := .t.
														Else
															Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD3->D3_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD3->D3_LOTECTL + " sem resultados"})
														Endif
													Else
														Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD3->D3_LOTECTL,cProduto,cOP,"OP " + cOP + " empenhada nao foi localizada"})
													Endif
												Else													
													lSD5 := .f.
													aInconSubX := {}
													
													SD5->(DbSetOrder(4))		//	D5_FILIAL+D5_OP+D5_NUMSEQ
													IF SD5->(DbSeek(xFilial("SD5") + SD3->D3_OP + SD3->D3_NUMSEQ))
														While xFilial("SD5") + SD3->D3_OP + SD3->D3_NUMSEQ == SD5->D5_FILIAL + SD5->D5_OP + SD5->D5_NUMSEQ .and. ! SD5->(Eof())
															If SD5->D5_PRODUTO <> cProduto
																SD5->(DbSkip())
																Loop
															Endif
															// Indice 9 da base estah sem o campo Produto, logo Seek Falha
															// Realizado tratamento abaixo para contornar
															lSC2 := .f.
															If SC2->(DbSeek(xFilial("SC2") + SD5->D5_LOTECTL + cProduto))
																While ! SC2->(Eof()) .and. xFilial("SC2") + SD5->D5_LOTECTL == SC2->C2_FILIAL + SC2->C2_LOTECTL		
																	If AllTrim(cProduto) <> AllTrim(SC2->C2_PRODUTO)
																		SC2->(DbSkip())
																		Loop
																	Endif
																	lSC2 := .t.
																	Exit
																Enddo
															Endif
															If lSC2
																cOp := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
																DbSelectArea("QPR")
																QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
																If QPR->(DbSeek( xFilial("QPR") + cOp + "  " + SD5->D5_LOTECTL ))
																	GravaQIP(cOP,SD5->D5_LOTECTL)
																	lGravaCBC	:= .t.
																	lSD5			:= .t.
																	Exit
																Else
																	Aadd(aInconSubX,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD5->D5_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD5->D5_LOTECTL + " sem resultados (SD5)"})
																Endif
															Else
																Aadd(aInconSubX,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD5->D5_LOTECTL,cProduto,cOP,"OP " + cOP + " empenhada nao foi localizada"})
															Endif
															SD5->(DbSkip())
														Enddo
														// ��������������������������������������������������������Ŀ
														// � Se nao validou nenhum SD5, gera inconsistencias        �
														// ����������������������������������������������������������
														If ! lSD5
															If !Empty(aInconSubX)
																For nConta := 1 To Len(aInconSubX)
																	Aadd(aInconSub1,{aInconSubX[nConta,1],aInconSubX[nConta,2],aInconSubX[nConta,3],aInconSubX[nConta,4],aInconSubX[nConta,5]})
																Next nConta
															Endif
														Endif
													Else
														Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Empenho foi realizado com lote em branco (SD3/SD5)"})
													Endif
												Endif
											Else
												Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Empenho nao localizado"})
											Endif
										Else
											Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Ordem de Producao nao localizada"})
										Endif
									Endif
								Endif
								
								DbSelectArea("SG1")
								SG1->(DbSkip())
							EndDo
							If lGravaCBC
								// ���������������������������������������������������������������������Ŀ
								// � Gravo um cabecalho para o item, pois conseguiu localizar resultados �
								// �����������������������������������������������������������������������
								GravaCBC("QIP")
								// ��������������������������������������������������������Ŀ
								// � Inicia analise do proximo item da Nota Fiscal de Saida �
								// ����������������������������������������������������������
								DbSelectArea("SD2")
								SD2->(DbSkip())
								Loop
							Else
								lGravaCBC2 := .f.
								// ������������������������������������������������������������������������������������Ŀ
								// � Nao localizou resultados para primeiro nivel, analisa o segundo nivel da estrutura �
								// ��������������������������������������������������������������������������������������
								For nConta := 1 To Len(aEstrutura)
									If SG1->(DbSeek( xFilial("SG1") + aEstrutura[nConta]))
										While SG1->(!EOF()) .AND. AllTrim(SG1->G1_COD) == AllTrim(aEstrutura[nConta])
											If QP6->(DbSeek(xFilial("QP6") + SG1->G1_COMP))
												cProduto := ALLTRIM(SG1->G1_COMP)
												lNumeroPAPI := .T.
												cOp := ""
												// ��������������������������������������������������������Ŀ
												// � O Lote do PA eh igual ao Lote do PI                    �
												// ����������������������������������������������������������
												DbSelectArea("SC2")
												SC2->(DbSetOrder(11))		// C2_FILIAL+C2_LOTECTL+C2_PRODUTO
												If SC2->(DbSeek( xFilial("SC2") + SD2->D2_LOTECTL))
													While SC2->(!EOF()) .AND. SC2->C2_LOTECTL == SD2->D2_LOTECTL
														IF AllTrim(SC2->C2_PRODUTO ) == cProduto
															cOP := AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN)
															Exit
														Endif
														SC2->(DbSkip())
													Enddo
													If Empty(cOP)
														lNumeroPAPI := .f.
														//															Aadd(aInconSub2,{SD2->D2_DOC + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto," ","Lote " + SD2->D2_LOTECTL + " sem OP para o produto " + cProduto + " da estrutura (nivel 2)"})
														//				              							SG1->(DbSkip())
														//				              							Loop
														//															Endif
													Else
														DbSelectArea("QPR")
														QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
														If QPR->(DbSeek( xFilial("QPR") + cOP + "  " + SD2->D2_LOTECTL ))
															GravaQIP(cOP,SD2->D2_LOTECTL)
															lGravaCBC2 := .t.
														Else
															Aadd(aInconSub2,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD2->D2_LOTECTL + " sem resultados (nivel 2)"})
															// ��������������������������������������������������������Ŀ
															// � Inicia analise do proximo item da estrutura            �
															// ����������������������������������������������������������
															SG1->(DbSkip())
															Loop
														Endif
													Endif
												Endif
												// ��������������������������������������������������������Ŀ
												// � Nao encontrou OP de PI com o mesmo numero da OP do PA  �
												// � Ira analisar os lotes utilizados na OP para localizar  �
												// � qual lote de PI foi utilizado na fabricacao do PA e    �
												// � imprime os dados deste lote.                           �
												// ����������������������������������������������������������
												If ! lNumeroPaPi
													SC2->(DbSetOrder(11))		// C2_FILIAL+C2_LOTECTL+C2_PRODUTO
													If SC2->(DbSeek(xFilial("SC2") + SD2->D2_LOTECTL + SD2->D2_COD))
														SD3->(DbSetOrder(1))		//	D3_FILIAL+D3_OP+D3_COD+D3_LOCAL
														If SD3->(DbSeek(xFilial("SD3") + SC2->(C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD) + cProduto))
															If ! Empty(SD3->D3_LOTECTL)
																If SC2->(DbSeek(xFilial("SC2") + SD3->D3_LOTECTL + cProduto))
																	cOp := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
																	DbSelectArea("QPR")
																	QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
																	If QPR->(DbSeek( xFilial("QPR") + cOp + "  " + SD3->D3_LOTECTL ))
																		GravaQIP(cOP,SD3->D3_LOTECTL)
																		lGravaCBC := .t.
																	Else
																		Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD3->D3_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD3->D3_LOTECTL + " sem resultados"})
																	Endif
																Else
																	Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD3->D3_LOTECTL,cProduto,cOP,"OP " + cOP + " empenhada nao foi localizada"})
																Endif
															Else
																SD5->(DbSetOrder(4))		//	D5_FILIAL+D5_OP+D5_NUMSEQ
																IF SD5->(DbSeek(xFilial("SD5") + SD3->D3_OP + SD3->D3_NUMSEQ))
																	lSD5 := .f.
																	aInconSubX := {}
																	While xFilial("SD5") + SD3->D3_OP + SD3->D3_NUMSEQ == SD5->D5_FILIAL + SD5->D5_OP + SD5->D5_NUMSEQ .and. ! SD5->(Eof())
																		If SD5->D5_PRODUTO <> cProduto
																			SD5->(DbSkip())
																			Loop
																		Endif
																		// Indice 9 da base estah sem o campo Produto, logo Seek Falha
																		// Realizado tratamento abaixo para contornar
																		lSC2 := .f.
																		If SC2->(DbSeek(xFilial("SC2") + SD5->D5_LOTECTL + cProduto))
																			While ! SC2->(Eof()) .and. xFilial("SC2") + SD5->D5_LOTECTL == SC2->C2_FILIAL + SC2->C2_LOTECTL
																				If AllTrim(cProduto) <> AllTrim(SC2->C2_PRODUTO)
																					SC2->(DbSkip())
																					Loop
																				Endif
																				lSC2 := .t.
																				Exit
																			Enddo
																		Endif
																		If lSC2
																			cOp := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN) 
																			
																			DbSelectArea("QPR")
																			QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
																			If QPR->(DbSeek( xFilial("QPR") + cOp + "  " + SD5->D5_LOTECTL ))
																				GravaQIP(cOP,SD5->D5_LOTECTL)
																				lGravaCBC := .t.
																				lSD5 := .t.
																				Exit
																			Else
																				Aadd(aInconSubX,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD5->D5_LOTECTL,cProduto,cOP,"OP " + cOP + " do Lote " + SD5->D5_LOTECTL + " sem resultados (SD5)"})
																			Endif
																		Else
																			Aadd(aInconSubX,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD5->D5_LOTECTL,cProduto,cOP,"OP " + cOP + " empenhada nao foi localizada"})
																		Endif
																		SD5->(DbSkip())
																	Enddo
																	// ��������������������������������������������������������Ŀ
																	// � Se nao validou nenhum SD5, gera inconsistencias        �
																	// ����������������������������������������������������������
																	If ! lSD5
																		If !Empty(aInconSubX)
																			For nConta := 1 To Len(aInconSubX)
																				Aadd(aInconSub1,{aInconSubX[nConta,1],aInconSubX[nConta,2],aInconSubX[nConta,3],aInconSubX[nConta,4],aInconSubX[nConta,5]})
																			Next nConta
																		Endif
																	Endif
																Else
																	Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Empenho foi realizado com lote em branco (SD3/SD5)"})
																Endif
															Endif
														Else
															Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Empenho nao localizado"})
														Endif
													Else
														Aadd(aInconSub1,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM," ",cProduto," ","Ordem de Producao nao localizada"})
													Endif
												Endif
											Endif
											
											DbSelectArea("SG1")
											SG1->(DbSkip())
										EndDo	
									Endif	// Localiza Estrutura de Segundo Nivel
								Next nConta
							Endif
							// Grava Inconsistencias do nivel 2 ou nivel 1
							If ! lGravaCBC2
								lProximo := .f.
								If ! Empty(aInconSub2)
									lProximo := .t.
									For nConta := 1 To Len(aInconSub2)
										Aadd(aIncon,{aInconSub2[nConta,1],aInconSub2[nConta,2],aInconSub2[nConta,3],aInconSub2[nConta,4],aInconSub2[nConta,5]})
									Next nConta
								Endif
								If ! Empty(aInconSub1)
									lProximo := .t.
									For nConta := 1 To Len(aInconSub1)
										Aadd(aIncon,{aInconSub1[nConta,1],aInconSub1[nConta,2],aInconSub1[nConta,3],aInconSub1[nConta,4],aInconSub1[nConta,5]})
									Next nConta
								Endif								
								If lProximo
									// ��������������������������������������������������������Ŀ
									// � Inicia analise do proximo item da Nota Fiscal de Saida �
									// � Pois ja logou inconsistencia                           �
									// ����������������������������������������������������������
									DbSelectArea("SD2")
									SD2->(DbSkip())
									Loop
								Endif
							Else
								// ���������������������������������������������������������������������Ŀ
								// � Gravo um cabecalho para o item, pois conseguiu localizar resultados �
								// �����������������������������������������������������������������������
								GravaCBC("QIP")
								// ��������������������������������������������������������Ŀ
								// � Inicia analise do proximo item da Nota Fiscal de Saida �
								// ����������������������������������������������������������
								DbSelectArea("SD2")
								SD2->(DbSkip())
								Loop
							Endif
						Endif
						// �����������������������������������������������������������������������Ŀ
						// � 2. Verifica se existe Especificacao, Entrega e Resultado Deste Lote   �
						// � no Modulo de Inspecao de Entregas                                     �
						// �������������������������������������������������������������������������
						
						DbSelectArea("QE6")
						QE6->(DbSetOrder(1))
						If QE6->(DbSeek( xFilial("QE6") + SD2->D2_COD))
							cProduto := ALLTRIM(SD2->D2_COD)
							DbSelectArea("QEK")
							QEK->(DbSetOrder(6))		// QEK_FILIAL + QEK_LOTE
							// ���������������������������������������������������������������Ŀ
							// � Tera que localizar uma entrada deste lote, desconsiderando os �
							// � sub-lotes do mesmo. Pela qualidade, todos os sub-lotes deste  �
							// � lote, possuem os mesmos resultados.                           �
							// �����������������������������������������������������������������
							nCasas 	:= Len(AllTrim(SD2->D2_LOTECTL))
							cLote		:= ""
							If QEK->(DbSeek( xFilial("QEK") + AllTrim(SD2->D2_LOTECTL)))
								While QEK->(!Eof()) .and. QEK->QEK_FILIAL == xFilial("QEK") .and. Substr(QEK->QEK_LOTE,1,nCasas) == AllTrim(SD2->D2_LOTECTL)
									//If Len(AllTrim(QEK->QEK_LOTE)) == nCasas + 6 .and. ;	// 6 posicoes de Sub-Lote
									//	QEK->QEK_PRODUT == SD2->D2_COD
									IF alltrim(QEK->QEK_LOTE) == alltrim(SD2->D2_LOTECTL) .AND. QEK->QEK_PRODUT == SD2->D2_COD
										cLote := QEK->QEK_LOTE
										cChave := QEK->(QEK_PRODUT+QEK_REVI+QEK_FORNEC+QEK_LOJFOR+DTOS(QEK_DTENTR)+QEK_LOTE)
										Exit
									Endif
									QEK->(DbSkip())
								Enddo
							Endif
							If ! Empty(cLote )
								DbSelectArea("QER")
								QER->(DbSetOrder(1)) 	// QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE+QER_LABOR+QER_ENSAIO+DTOS(QER_DTMEDI)+QER_HRMEDI+STR(QER_AMOSTR,1)
								If QER->(DbSeek( xFilial("QER") + cChave ))
									If GravaCBC("QIE")
										GravaQIE(cChave)
									Endif
									// ��������������������������������������������������������Ŀ
									// � Inicia analise do proximo item da Nota Fiscal de Saida �
									// ����������������������������������������������������������
									DbSelectArea("SD2")
									SD2->(DbSkip())
									Loop
								Else
									Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cLote,"Entrega do lote " + cLote + " sem resultados"})
									// ��������������������������������������������������������Ŀ
									// � Inicia analise do proximo item da Nota Fiscal de Saida �
									// ����������������������������������������������������������
									DbSelectArea("SD2")
									SD2->(DbSkip())
									Loop
								Endif
							Else
								Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto," ","Entrega n�o localizada do Lote " + SD2->D2_LOTECTL})
								// ��������������������������������������������������������Ŀ
								// � Inicia analise do proximo item da Nota Fiscal de Saida �
								// ����������������������������������������������������������
								DbSelectArea("SD2")
								SD2->(DbSkip())
								Loop
							Endif
						Else
							//verifica pelo PI 
						    cCodPIAx:= ""
						    
							DbSelectArea("SG1")
							DbSetOrder(1)
							MsSeek(xFilial("SG1")+SD2->D2_COD)
							While !Eof() .And. SG1->G1_COD==SD2->D2_COD
								If AllTrim(Posicione("SB1",1,xFilial("SB1")+SG1->G1_COMP,"B1_TIPO"))=="4"
									cCodPIAx:= SG1->G1_COMP								
								EndIf		
								DbSelectArea("SG1")
								DbSkip()
							EndDo

							DbSelectArea("QE6")
							QE6->(DbSetOrder(1))
							If QE6->(DbSeek( xFilial("QE6") + cCodPIAx))
								cProduto := ALLTRIM(SD2->D2_COD) //cCodPIAx)
								
								DbSelectArea("QEK")
								QEK->(DbSetOrder(6))		// QEK_FILIAL + QEK_LOTE
								// ���������������������������������������������������������������Ŀ
								// � Tera que localizar uma entrada deste lote, desconsiderando os �
								// � sub-lotes do mesmo. Pela qualidade, todos os sub-lotes deste  �
								// � lote, possuem os mesmos resultados.                           �
								// �����������������������������������������������������������������
								nCasas 	:= Len(AllTrim(SD2->D2_LOTECTL))
								cLote	:= ""
								If QEK->(DbSeek( xFilial("QEK") + AllTrim(SD2->D2_LOTECTL)))
									While QEK->(!Eof()) .and. QEK->QEK_FILIAL == xFilial("QEK") .and. Substr(QEK->QEK_LOTE,1,nCasas) == AllTrim(SD2->D2_LOTECTL)
										If Len(AllTrim(QEK->QEK_LOTE)) == nCasas + 6 .and. ;	// 6 posicoes de Sub-Lote
											QEK->QEK_PRODUT == SD2->D2_COD
											cLote := QEK->QEK_LOTE
											cChave := QEK->(QEK_PRODUT+QEK_REVI+QEK_FORNEC+QEK_LOJFOR+DTOS(QEK_DTENTR)+QEK_LOTE)
											Exit
										Endif
										QEK->(DbSkip())
									Enddo
								Endif
								If ! Empty(cLote )
									DbSelectArea("QER")
									QER->(DbSetOrder(1)) 	// QER_FILIAL+QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE+QER_LABOR+QER_ENSAIO+DTOS(QER_DTMEDI)+QER_HRMEDI+STR(QER_AMOSTR,1)
									If QER->(DbSeek( xFilial("QER") + cChave ))
										If GravaCBC("QIE")
											GravaQIE(cChave)
										Endif
										// ��������������������������������������������������������Ŀ
										// � Inicia analise do proximo item da Nota Fiscal de Saida �
										// ����������������������������������������������������������
										DbSelectArea("SD2")
										SD2->(DbSkip())
										Loop
									Else
										Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cLote,"Entrega do lote " + cLote + " sem resultados"})
										// ��������������������������������������������������������Ŀ
										// � Inicia analise do proximo item da Nota Fiscal de Saida �
										// ����������������������������������������������������������
										DbSelectArea("SD2")
										SD2->(DbSkip())
										Loop
									Endif
								Else	  
									Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto," ","Entrega n�o localizada do Lote " + SD2->D2_LOTECTL})
									// ��������������������������������������������������������Ŀ
									// � Inicia analise do proximo item da Nota Fiscal de Saida �
									// ����������������������������������������������������������
									DbSelectArea("SD2")
									SD2->(DbSkip())
									Loop
								Endif
							EndIf
						Endif
						// ������������������������������������������������������������Ŀ
						// � Gerar Inconsistencia, pois nao atendeu nenhuma regra acima �
						// ��������������������������������������������������������������
						Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,SD2->D2_COD," ","Lote n�o atendeu nenhuma regra"})	
						// ��������������������������������������������������������Ŀ
						// � Inicia analise do proximo item da Nota Fiscal de Saida �
						// ����������������������������������������������������������
						DbSelectArea("SD2")
						SD2->(DbSkip())
					ENDDO
				ENDIF
			ENDIF
		ELSE
			MSGBOX("CLIENTE NAO ENCONTRADO")
			DBSELECTAREA("SF2")
			SF2->(DbSkip())
		ENDIF
		// ������������������������������������������������Ŀ
		// � Inicia analise da proxima Nota Fiscal de Saida �
		// ��������������������������������������������������
		DBSELECTAREA("SF2")
		DBSKIP()
	ENDDO
	//	ELSE     dan
	//	MSGBOX("NOTA FISCAL INICIAL NAO ENCONTRADA")  dan
	//	ENDIF          dan
	
	CursorArrow()
	
	// ����������������������������������������������������������������������������Ŀ
	// � Chama rotina de impressao das inconsistencias e envia as mesmas por e-mail �
	// ������������������������������������������������������������������������������

	If ! Empty(aIncon)
//		U_LogIncon()
		EnviaIncon()
	Endif

	// ��������������������������������������������������Ŀ
	// � Chama rotina de envio dos certificados via email �
	// ����������������������������������������������������
	
    U_CTMAIL() 
	
	ConOut("---------------------------------------")
    ConOut("     FIM de Processamento "+Time())
    ConOut("---------------------------------------")

Endif

ConOut("---------------------------------------")
ConOut("     FIM1 de Processamento "+Time())
ConOut("---------------------------------------")

CBC->(DBCLOSEAREA())
FERASE(_cArqCbc)
ITEM->(DBCLOSEAREA())
FERASE(_cArqItm)
RESUL->(DBCLOSEAREA())
FERASE(_cArqRes)

Return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaQIP  �Autor  �Rogerio Nagy        � Data �  02/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava dados do certificado de um determinado Lote, Produto ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaQIP(cOp,cLote)

// ������������������������������������������������������������������������������Ŀ
// � Guarda valores temporarios do certificado com dados do Inspecao de Processos �
// ��������������������������������������������������������������������������������

DBSELECTAREA("QPR")
QPR->(DbSetOrder(8)) 	// QPR_FILIAL+QPR_OP+QPR_LOTE+QPR_OPERAC+QPR_LABOR+QPR_ENSAIO+DTOS(QPR_DTMEDI)+QPR_HRMEDI+STR(QPR_AMOSTR,1)
If QPR->(DbSeek( xFilial("QPR") + cOP + "  " + cLote ))	
	//IF ALLTRIM(cOP) == ALLTRIM(QPR->QPR_OP) // INCLUIDO APOS ALTERACAO DE IF DBSEEK
	WHILE !EOF() .AND. ALLTRIM(QPR->QPR_OP) == ALLTRIM(cOP) .and. Substr(QPR->QPR_LOTE,1,10) == cLote
		DBSELECTAREA("RESUL")
		RECLOCK("RESUL",.T.)
		RESUL->NOTA   := ALLTRIM(SF2->F2_DOC)
		RESUL->SERIE  := ALLTRIM(SF2->F2_SERIE)
		RESUL->PRODUTO:= ALLTRIM(SD2->D2_COD)
		RESUL->ITEM   := SD2->D2_ITEM
		RESUL->LOTE   := ALLTRIM(SD2->D2_LOTECTL)
		RESUL->ENSAIO := ALLTRIM(QPR->QPR_ENSAIO)
		cChave        := ALLTRIM(QPR->QPR_CHAVE)
	
		DBSELECTAREA("QP1")
		DBSETORDER(1)
		IF DBSEEK( XFILIAL("QP1") + QPR->QPR_ENSAIO )
			RESUL->NOME := QP1->QP1_DESCPO
		ENDIF
		
		DBSELECTAREA("QP8")
		DBSETORDER(3)
		IF DBSEEK( XFILIAL("QP8") + QPR->QPR_ENSAIO + cProduto )
			Do while !EOF() .AND. QPR->QPR_ENSAIO == QP8->QP8_ENSAIO .AND. ALLTRIM(cProduto) == ALLTRIM (QP8->QP8_PRODUT)
				IF QPR->QPR_REVI == QP8->QP8_REVI
					RESUL->ESPEC := ALLTRIM(QP8->QP8_TEXTO)
					DBSKIP()
				ELSE
					DBSKIP()
				ENDIF
			ENDDO
			
			DBSELECTAREA("QPQ")
			DBSETORDER(1)
			IF DBSEEK( XFILIAL("QPS") + cChave )
				RESUL->RESULT  := ALLTRIM(QPQ->QPQ_MEDICA)
			ENDIF
			MSUNLOCK()
		ELSE
			DBSELECTAREA("QP7")
			DBSETORDER(3)
			QP7->(DBGOTOP())
			IF DBSEEK( XFILIAL("QP7") + QPR->QPR_ENSAIO + cProduto)
				Do while !EOF() .AND. QPR->QPR_ENSAIO == QP7->QP7_ENSAIO .AND. ALLTRIM(cProduto) == ALLTRIM (QP7->QP7_PRODUT)
					IF QPR->QPR_REVI == QP7->QP7_REVI
						RESUL->ESPEC := ALLTRIM(QP7->QP7_LIE)+ " / " + ALLTRIM(QP7->QP7_LSE)
						DBSKIP()
					ELSE
						DBSKIP()
					ENDIF
				ENDDO
				DBSELECTAREA("QPS")
				DBSETORDER(1)
				IF DBSEEK( XFILIAL("QPS") + cChave ) //1
					RESUL->RESULT := QPS->QPS_MEDICA
					MSUNLOCK()
				ENDIF //1
			ENDIF
		ENDIF
		DBSELECTAREA("QPR")
		DBSKIP()
	ENDDO
ELSE
	MSGBOX("OP "+cOP+" DO PRODUTO:"+ cProduto +", NAO ENCONTRADA NOS RESULTADOS, POR FAVOR, CRIAR O MESMO MANUALMENTE") //Alterado apos acerto de QPR
ENDIF

Return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaQIE  �Autor  �Rogerio Nagy        � Data �  02/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava dados do certificado de um determinado lote.          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaQIE(cChave)

Local cChaveQE := ""
// ������������������������������������������������������������������������������Ŀ
// � Guarda valores temporarios do certificado com dados do Inspecao de Entregas  �
// ��������������������������������������������������������������������������������

DbSelectArea("QER")
QER->(DbSetOrder(1))
If QER->(DbSeek( xFilial("QER") + cChave ))
	While QER->(!EOF()) .AND. ;
		cChave == QER->(QER_PRODUT+QER_REVI+QER_FORNEC+QER_LOJFOR+DTOS(QER_DTENTR)+QER_LOTE)
		
		DbSelectArea("RESUL")
		RecLock("RESUL",.T.)
		RESUL->NOTA   := AllTrim(SF2->F2_DOC)
		RESUL->SERIE  := AllTrim(SF2->F2_SERIE)
		RESUL->PRODUTO:= AllTrim(SD2->D2_COD)
		RESUL->ITEM   := SD2->D2_ITEM
		RESUL->LOTE   := AllTrim(SD2->D2_LOTECTL)
		RESUL->ENSAIO := AllTrim(QER->QER_ENSAIO)
		cChaveQE      := AllTrim(QER->QER_CHAVE)
		
		DbSelectArea("QE1")
		QE1->(DbSetOrder(1))
		If QE1->(DbSeek( xFilial("QE1") + QER->QER_ENSAIO ))
			RESUL->NOME := QE1->QE1_DESCPO
		Endif
		
		DbSelectArea("QE8")
		QE8->(DbSetOrder(3))  // QE8_FILIAL+QE8_ENSAIO+QE8_PRODUT+QE8_REVI
		If QE8->(DbSeek( xFilial("QE8") + QER->QER_ENSAIO + cProduto ))
			While QE8->(!EOF()) .AND. ;
				QER->QER_ENSAIO == QE8->QE8_ENSAIO .AND. AllTrim(cProduto) == AllTrim (QE8->QE8_PRODUT)
				If QER->QER_REVI == QE8->QE8_REVI
					RESUL->ESPEC := AllTrim(QE8->QE8_TEXTO)
				Endif
				QE8->(DBSkip())
			Enddo
			
			DbSelectArea("QEQ")
			QEQ->(DbSetOrder(1))
			If QEQ->(DbSeek( xFilial("QEQ") + cChaveQE ))
				RESUL->RESULT  := ALLTRIM(QEQ->QEQ_MEDICA)
			Endif
			MSUNLOCK()
		Else
			DbSelectArea("QE7")
			QE7->(DbSetOrder(3))  	// QE7_FILIAL+QE7_ENSAIO+QE7_PRODUT+QE7_REVI
			//QE7->(DBGOTOP())
			If QE7->(DbSeek( xFilial("QE7") + QER->QER_ENSAIO + cProduto))
				While QE7->(!EOF()) .AND. QER->QER_ENSAIO == QE7->QE7_ENSAIO .AND. AllTrim(cProduto) == AllTrim (QE7->QE7_PRODUT)
					If QER->QER_REVI == QE7->QE7_REVI
						RESUL->ESPEC := AllTrim(QE7->QE7_LIE)+ " / " + AllTrim(QE7->QE7_LSE)
					Endif
					QE7->(DBSkip())
				Enddo
				
				DbSelectArea("QES")
				QES->(DbSetOrder(1))		//QES_FILIAL+QES_CODMED
				If QES->(DbSeek( xFilial("QES") + cChaveQE ))
					RESUL->RESULT := QES->QES_MEDICA
				Endif
				MSUNLOCK()
			Endif
		Endif
		DbSelectArea("QER")
		QER->(DbSkip())
	Enddo
Endif

Return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaCBC  �Autor  �Rogerio Nagy        � Data �  02/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava Cabecalho e Itens do Certificado                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaCBC(cModulo)

Local lRet 	:= .T.
Local dData := Ctod("  /  /  ")

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek( xFilial("SB1") + SD2->D2_COD )

If cModulo == "QIE"
	// ������������������������������������������������������������������������������Ŀ
	// � Valida se Data de Fabricacao calculada eh maior que a data atual             �
	// ��������������������������������������������������������������������������������
	
	// ������������������������������������������������������������������������������Ŀ
	// � Localiza Nota Fiscal de Entrada deste Lote                                   �
	// ��������������������������������������������������������������������������������
	SD1->(DbSetOrder(4))		// D1_FILIAL+D1_NUMSEQ
	If SD1->(DbSeek(xFilial("SD1") + QEK->QEK_NUMSEQ))
		If Empty(SD1->D1_DTVALID)
			Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cLote,"Data de validade em branco na NF de entrada"})
			Return .f.
		Endif
		dData	:= SD1->D1_DTVALID - (SB1->B1_MESVALI * 30)
	Endif
	If dData > dDataBase
		Aadd(aIncon,{RTrim(SD2->D2_DOC) + "/" + SD2->D2_ITEM,SD2->D2_LOTECTL,cProduto,cLote,"Data de fabricacao calculada " + Dtoc(dData) +  " superior a data base"})
		Return .f.
	Endif
Endif

DBSELECTAREA("CBC")
RECLOCK("CBC",.T.)
CBC->NOTA     := ALLTRIM(SF2->F2_DOC)
CBC->SERIE    := ALLTRIM(SF2->F2_SERIE)
CBC->CLIENTE  := ALLTRIM(SF2->F2_CLIENTE)
CBC->LOJA     := ALLTRIM(SF2->F2_LOJA)
CBC->NOME     := ALLTRIM(SA1->A1_NOME)
CBC->EMISSAO  := SF2->F2_EMISSAO
CBC->PRODUTO  := ALLTRIM(SD2->D2_COD)
CBC->ITEM     := SD2->D2_ITEM
MSUNLOCK()

DBSELECTAREA("ITEM")
RECLOCK("ITEM",.T.)
ITEM->NOTA     := ALLTRIM(SF2->F2_DOC)
ITEM->SERIE    := ALLTRIM(SF2->F2_SERIE)
ITEM->PRODUTO  := ALLTRIM(SD2->D2_COD)
ITEM->ITEM     := SD2->D2_ITEM
ITEM->DESC     := ALLTRIM(SB1->B1_DESC)
ITEM->UM       := ALLTRIM(SD2->D2_UM)
ITEM->QUANT    := SD2->D2_QUANT
ITEM->LOTE     := ALLTRIM(SD2->D2_LOTECTL)

If cModulo == "QIP"
	// ������������������������������������������������������������������������������Ŀ
	// � Imprime Data de Fabricacao e Validade conforme Ordem de Producao             �
	// ��������������������������������������������������������������������������������
	DBSELECTAREA("SC2")
	DBSETORDER(11)    // C2_FILIAL+C2_LOTECTL+C2_PRODUTO
	IF DBSEEK( XFILIAL("SC2") + SD2->D2_LOTECTL)
		//ITEM->FABRI := SC2->C2_EMISSAO RODOLFO A PEDIDO DO FABIO PCP FOI TROCADO PELA C2_DATPRINI 27/12
		ITEM->FABRI := SC2->C2_DATPRI		
	ENDIF
	
	DBSELECTAREA("SB8")
	DBSETORDER(6)
	IF DBSEEK( XFILIAL("SB8") + SD2->D2_LOTECTL)
		ITEM->DTVALID := SB8->B8_DTVALID
	ENDIF
Else
	// ������������������������������������������������������������������������������Ŀ
	// � Imprime Data de Validade informada na Nota Fiscal de Entrada                 �
	// � Imprime Data de Fabricacao com Data de Validade Menos Periodo de Validade do �
	// � Produto                                                                      �
	// ��������������������������������������������������������������������������������
	
	// ������������������������������������������������������������������������������Ŀ
	// � Localiza Nota Fiscal de Entrada deste Lote                                   �
	// ��������������������������������������������������������������������������������
	SD1->(DbSetOrder(4))		// D1_FILIAL+D1_NUMSEQ
	If SD1->(DbSeek(xFilial("SD1") + QEK->QEK_NUMSEQ))
		ITEM->DTVALID 	:= SD1->D1_DTVALID
		ITEM->FABRI 	:= SD1->D1_DTVALID - (SB1->B1_MESVALI * 30)
	Endif	
Endif

MSUNLOCK()

Return .t.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EnviaIncon�Autor  �Rogerio Nagy        � Data �  02/07/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Envia inconsistencias encontradas por e-mail               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Brascola                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EnviaIncon

Local _cServer := GetMV("MV_RELSERV")   	// Servidor
Local _cConta  := GetMV("MV_RELACNT")   	// Conta
Local _cPass   := GetMV("MV_RELPSW")     	// Senha da conta
Local _cResp   := GetMv("BR_EMCERTI")		// Responsavel pelas inconsistencias do certificado
Local _cBody	:= " "
Local _cErro 	:= ""
Local lOk 		:= .t.

ConOut("----------------------------------------")
ConOut(" FIM1 de Processamento "+Time())
ConOut("----------------------------------------")

_cBody    :="<HTML>"
_cBody    += "<HEAD><TITLE> Inconsist�ncias encontradas na emiss�o de certificados da qualidade</TITLE></HEAD>"
_cBody    += "<BODY>"
_cBody    +="<p style=line-height: 100%; margin-top: 0; margin-bottom: 0></p>"
_cBody    +="<P> </P>"
_cBody    +="<P> </P>"
_cBody    +="<P> </P>"
_cBody    +="<P> Favor verificar inconsist�ncias encontradas abaixo" + "</P>"
_cBody    +="<P> </P>"
_cBody    +="<P> </P>"
_cBody    += "<table bordercolor=#0099cc height=15 cellspacing=1 width=620 bordercolorlight=#0099cc  border=1>"
_cBody    += '<tr><td align=center width=065 height=15><font face="Arial Black" size=1>Nota Fiscal</font></td>'
_cBody    += '    <td align=center width=100 height=15><font face="Arial Black" size=1>Lote</font></td>'
_cBody    += '    <td align=center width=110 height=15><font face="Arial Black" size=1>Produto</font></td>'
_cBody    += '    <td align=center width=90 height=15><font face="Arial Black" size=1>OP</font></td>'
_cBody    += '    <td align=center width=350 height=15><font face="Arial Black" size=1>Inconsist�ncia</font></td>'

For nConta := 1 To Len(aIncon)	
	_cBody += '<tr>'
	_cBody += '    <td align=center width=065 height=15> <font face="Arial" size=1>'+ aIncon[nConta,1]+'</font></td>'
	_cBody += '    <td align=center width=100 height=15> <font face="Arial" size=1>'+ Iif(Empty(aIncon[nConta,2]),"-",aIncon[nConta,2])+'</font></td>'
	_cBody += '    <td align=center width=110 height=15> <font face="Arial" size=1>'+ Iif(Empty(aIncon[nConta,3]),"-",aIncon[nConta,3])+'</font></td>'
	_cBody += '    <td align=center width=090 height=15> <font face="Arial" size=1>'+ Iif(Empty(aIncon[nConta,4]),"-",aIncon[nConta,4])+'</font></td>'
	_cBody += '    <td align=center width=350 height=15> <font face="Arial" size=1>'+ Iif(Empty(aIncon[nConta,5]),"-",aIncon[nConta,5])+'</font></td>'
	_cBody += '</tr>'	
Next nConta

_cBody    +="</table>"
_cBody    +="<P> </P>"
_cBody    +="<P> </P>"
_cBody    +="<P> </P>"
_cBody    +="<P> E-mail gerado pelo m�dulo Quality em " + dtoc(ddatabase) + "as " + Left(Time(),5) + "</P>"
_cBody    += "</BODY>"
_cBody    +="</HTML>"+"<P> </P>"+"<P> </P>"+"<P> </P>"

//������������������������������������������������������������������Ŀ
//� Envia e-mail para aviso de Inconsistencia                        �
//��������������������������������������������������������������������
CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPass RESULT lOk

If lOk
	//Envio de e-mail HTML
	SEND MAIL FROM _cConta ;
	TO _cResp ;
	SUBJECT 'Inconsist�ncia na emiss�o de Certificados de Qualidade' ;
	BODY _cBody ;
	RESULT lOk
	If !lOk
		//Erro no Envio do e-mail
		GET MAIL ERROR cError
		MsgInfo(cError,OemToAnsi("Erro no envio de e-mail"))
	EndIf
Else
	//Erro na conexao com o SMTP Server
	GET MAIL ERROR cError
	MsgInfo(cError,OemToAnsi("Erro na conex�o com o servidor de e-mail"))
EndIf

DISCONNECT SMTP SERVER

Return .t.


User Function CTMAIL()
***************************
Local _cServer  := GetMV("MV_RELSERV")   // Servidor
Local _cConta   := GetMV("MV_RELACNT")   // Conta
Local _cPass    := GetMV("MV_RELAPSW")   // Senha da conta
Local cArqItm   := CriaTrab(NIL,.f.)
Local cArqResul := CriaTrab(NIL,.f.)
Local _cBody    := ""
Local lEnvCertif:= .f.  //controle de envio de certificado

ConOut("----------------------------------------")
ConOut(" incmail 1 de Processamento "+Time())
ConOut("----------------------------------------")

dbSelectArea("CBC")

Resume()

dbSelectArea("RESX")
dbGoTop()

While !EOF()
   ConOut("----------------------------------------")
   ConOut(" incmail loop de Processamento "+Time())
   ConOut("----------------------------------------")

	cEmailCli:= Alltrim(Posicione("SA1",1,xFilial("SA1")+RESX->CLIENTE+RESX->LOJA,"A1_EMAIL"))
    
	_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
	_cBody += "<html>"                                                                                                                                                              
	_cBody += "<head>"                                                                                                                                                              
	_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
	_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
	_cBody += "</head>"                                                                                                                                                             
	_cBody += " <hr> " //linha horizontal
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2'><b>Brascola Ltda</b></font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += '<p align="center"><font face="Tahoma" size="3"><b>Certificado de Qualidade</b></font></p>'
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += " <hr> " //linha horizontal
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	
	cCodCliAux:= ""
	
	dbSelectArea("SA7")
	dbSetOrder(1)
	If MsSeek(xFilial()+RESX->CLIENTE+RESX->LOJA+RESX->PRODUTO)
		If Len(AllTrim(SA7->A7_CODCLI)) > 0 
			cCodCliAux:= ALLTRIM(SA7->A7_CODCLI)+" - "+Upper(ALLTRIM(SA7->A7_DESCCLI))
		Else
			cCodCliAux:= "N/C"
		EndIf
	Else 		
		cCodCliAux:= "N/C"
	EndIf

	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Produto</b>: "+Upper(AllTrim(RESX->PRODUTO))+" - "+Upper(AllTrim(RESX->DESC))+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Cod.Produto no Cliente</b>: "+cCodCliAux+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Cliente</b>: "+RESX->CLIENTE+"/"+RESX->LOJA+" - "+Upper(AllTrim(RESX->NOME))+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Nota Fiscal</b>: "+Upper(AllTrim(RESX->NOTA))+" / "+Upper(RESX->SERIE)+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Emiss�o</b>: "+DtoC(RESX->EMISSAO)+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                            
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Lote</b>: "+Upper(AllTrim(RESX->LOTE))+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Fabrica��o</b>: "+DtoC(RESX->FABRI)+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Validade</b>: "+DtoC(RESX->DTVALID)+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'><b>Quantidade</b>: "+AllTrim(Str(RESX->QUANT))+" "+RESX->UM+" </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<table border='1' cellspacing='1' width='100%'>"
	_cBody += "  <tbody>"
	_cBody += "    <tr>"
	_cBody += "      <td width='40%' align='left' bgcolor='#f0f0f0'> <font face='Tahoma' size='2' ><b>Ensaio</font></b></td>"
	_cBody += "      <td width='40%' align='left' bgcolor='#f0f0f0'> <font face='Tahoma' size='2' ><b>Especifica��o</font></b></td>"
	_cBody += "      <td width='20%' align='left' bgcolor='#f0f0f0'> <font face='Tahoma' size='2' ><b>Resultado</font></b></td>"
	_cBody += "    </tr>"                                                                                                                                                           
	
	cBgColor:= "#ffffff" //branco 
	
	dbSelectArea("RESUL")
	IndRegua( "RESUL",cArqResul,"NOTA+SERIE+PRODUTO+ITEM+LOTE",,,"Ordenando Registros !" )

	If dbSeek( RESX->NOTA + RESX->SERIE + RESX->PRODUTO +RESX->ITEM +RESX->LOTE )
		While !Eof() .AND. RESUL->NOTA == RESX->NOTA .AND. RESUL->SERIE == RESX->SERIE;
				.AND. RESUL->PRODUTO == RESX->PRODUTO .AND. RESUL->LOTE == RESX->LOTE;
				.AND. RESUL->ITEM == RESX->ITEM
				
			_cBody += "  <tr>"                                                                                                                                                            
			_cBody += "    <td width='40%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Upper(AllTrim(RESUL->NOME))+"</font></td>"
			_cBody += "    <td width='40%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Upper(AllTrim(RESUL->ESPEC))+"</font></td>"
			_cBody += "    <td width='20%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Upper(AllTrim(RESUL->RESULT))+"</font></td>"
			_cBody += "  </tr>"                                                                                                                                                           
 		   	
 		   	dbSkip()
 		 EndDo
 	EndIf

	_cBody += "  </tbody>"
	_cBody += "</table>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'>Juliana Cirilo</font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='2'>CRQ-XIII Regiao 13100830</font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></b></td>"                                                                                        
	_cBody += "</body>"
	_cBody += " <hr> " //linha horizontal
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='1'>CERTIFICADO EMITIDO ELETRONICAMENTE DIA "+DtoC(Date())+" �S "+Time()+".  </font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                      
	_cBody += "   <tr><font face='Tahoma' size='1'>TEL.:0800-7241727 / FAX.:(47)3205-2700</font></tr>" 
	_cBody += "</body>"
	_cBody += "<body>"                                                                                                                                                              
	_cBody += "   <tr><font face='Tahoma' size='1'>EMAIL: faleconosco@brascola.com.br</font></tr>" 
	_cBody += "</body>"
	_cBody += " <hr> " //linha horizontal
	_cBody += "</html>"                                                                                                 

	cAssunto:= "Certificado de Qualidade - "+AllTrim(RESX->PRODUTO)+" / Lote:"+AllTrim(RESX->LOTE)+" / "+RESX->CLIENTE+"/"+RESX->LOJA+"-"+AllTrim(Posicione("SA1",1,xFilial("SA1")+RESX->CLIENTE+RESX->LOJA,"A1_NREDUZ")) 
    cEmailCli+= Iif(!Empty(cEmailCli),"; ","")+"fmaia@brascola.com.br;juliana.cirilo@brascola.com.br;jacksonr@brascola.com.br;fmartim@brascola.com.br;gpatricio@brascola.com.br"
    //cEmailCli:= "fmaia@brascola.com.br;juliana.cirilo@brascola.com.br;jacksonr@brascola.com.br;fmartim@brascola.com.br"
  
//	U_SendMail(cEmailCli,cAssunto,_cBody,"",.t.)

	CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPass RESULT lOk
	
	If lOk
		//Envio de e-mail HTML
		SEND MAIL FROM _cConta TO cEmailCli SUBJECT cAssunto BODY _cBody RESULT lOk
		If !lOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgInfo(cError,OemToAnsi("Erro no envio de e-mail"))
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgInfo(cError,OemToAnsi("Erro na conex�o com o servidor de e-mail"))
	EndIf
	
	DISCONNECT SMTP SERVER
	    
    ConOut("----------------------------------------")
    ConOut(" enviou email de Processamento "+Time())
    ConOut("----------------------------------------")

	lEnvCertif:= .t.
	
	dbSelectArea("RESX")
	dbSkip() // Avanca o ponteiro do registro no arquivo  	
EndDo


If !lEnvCertif //nao enviou nenhum certificado.
	_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
	_cBody += "<html>"                                                                                                                                                              
	_cBody += "<head>"                                                                                                                                                              
	_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
	_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
	_cBody += "</head>"                                                                                                                                                             
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += '<p align="left"><font face="Tahoma" size="3">N�o houve certificado de qualidade emitido em '+DtoC(dDataBase)+'</font></p>' 
	//Fernando:_cBody += '<p align="left"><font face="Tahoma" size="3">N�o houve certificado de qualidade emitido em '+cData+'</font></p>'
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += " <hr> " //linha horizontal
	_cBody += '<p align="left"><font face="Tahoma" size="1"><i>Notifica��o emitida automaticamente em '+DtoC(Date())+' �s '+Time()+' hs.</i></font></p>'
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1' color='#ffffff' >.</font></td>"                                                                                        
	_cBody += "</body>"
	_cBody += "</html>"

	_cAssunto:= "Notifica��o sobre certificado de qualidade - "+DtoC(dDataBase)
    _cEmail  := "fmaia@brascola.com.br;juliana.cirilo@brascola.com.br;jacksonr@brascola.com.br;fmartim@brascola.com.br;gpatricio@brascola.com.br"
    //_cEmail  := "fmaia@brascola.com.br;juliana.cirilo@brascola.com.br;jacksonr@brascola.com.br;fmartim@brascola.com.br"

	//U_SendMail(_cEmail, _cAssunto, _cBody, "", .t.)
	CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPass RESULT lOk
	
	If lOk
		//Envio de e-mail HTML
		SEND MAIL FROM _cConta TO _cEmail SUBJECT _cAssunto BODY _cBody RESULT lOk
		If !lOk
			//Erro no Envio do e-mail
			GET MAIL ERROR cError
			MsgInfo(cError,OemToAnsi("Erro no envio de e-mail"))
		EndIf
	Else
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		MsgInfo(cError,OemToAnsi("Erro na conex�o com o servidor de e-mail"))
	EndIf
	DISCONNECT SMTP SERVER
EndIf

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IMPRCERT  �Autor  �Microsiga           � Data �  06/20/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta funcao resume os dois alias anteriores, CBC e ITEM,   ���
���          � para resumir a impressao dos certificados                  ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Resume()
************************
Local _aRes 		:= {}
Local _nQUANT 		:= 0

aAdd(_aRes,{"NOTA"         ,"C",009,0})
aAdd(_aRes,{"SERIE"        ,"C",003,0})
aAdd(_aRes,{"CLIENTE"      ,"C",008,0})
aAdd(_aRes,{"LOJA"         ,"C",004,0})
aAdd(_aRes,{"PRODUTO"      ,"C",015,0})
aAdd(_aRes,{"ITEM"         ,"C",004,0})
aAdd(_aRes,{"NOME"         ,"C",040,0})
aAdd(_aRes,{"EMISSAO"      ,"D",008,0})
aAdd(_aRes,{"DESC"         ,"C",050,0})
aAdd(_aRes,{"UM"           ,"C",002,0})
aAdd(_aRes,{"LOTE"         ,"C",011,0})
aAdd(_aRes,{"FABRI"        ,"D",008,0})
aAdd(_aRes,{"DTVALID"      ,"D",008,0})
aAdd(_aRes,{"QUANT"        ,"N",014,2})     

_cArqCbc := CriaTrab(_aRes,.T.)

If Select("RESX") > 0
   RESX->(dbCloseArea())
EndIF

dbUseArea( .T.,,_cArqCbc, "RESX", .F., .F. )

dbSelectArea("ITEM")
dbGoTop()

dbSelectArea("CBC")
dbGoTop()

While !Eof()
	dbSelectArea("RESX")
	RecLock("RESX",.T.)
	RESX->NOTA		:= CBC->NOTA
	RESX->SERIE		:= CBC->SERIE
	RESX->CLIENTE	:= CBC->CLIENTE
	RESX->LOJA		:= CBC->LOJA
	RESX->PRODUTO	:= CBC->PRODUTO
	RESX->ITEM		:= CBC->ITEM
	RESX->NOME		:= CBC->NOME
	RESX->EMISSAO	:= CBC->EMISSAO
	RESX->DESC		:= ITEM->DESC
	RESX->UM		:= ITEM->UM
	RESX->LOTE		:= ITEM->LOTE
	RESX->FABRI		:= ITEM->FABRI
	RESX->DTVALID	:= ITEM->DTVALID
	MsUnlock()

	_nQuant := ITEM->QUANT

	dbSelectArea("ITEM")
	dbSkip()	

	dbSelectArea("CBC")
	dbSkip()

	While !Eof() .And. RESX->NOTA == CBC->NOTA .And. RESX->PRODUTO == CBC->PRODUTO .And. RESX->LOTE == ITEM->LOTE 
		_nQuant += ITEM->QUANT

		dbSelectArea("CBC")
		dbSkip()
		dbSelectArea("ITEM")
		dbSkip()	
	EndDo                               	

	dbSelectArea("RESX")
	RecLock("RESX",.F.)
	RESX->QUANT		:= _nQuant
	MsUnlock()     	
	dbSelectArea("CBC")	
EndDo

Return 
