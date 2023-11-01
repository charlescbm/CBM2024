#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"

Static nTCaixa 	:= TamSx3("ZZA_NUMCX")[1]
Static nTPallet := TamSx3("ZZA_PALLET")[1]

//-------------------------------------------------------------------
/*/{Protheus.doc} MT103FIM
Utilizado para gravar a tabela de etiquetas ao final da inclusão do 
Documento de Entrada
@author  Victor Andrade
@since   04/04/2018
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function MT103FIM()

Local aArea     := GetArea()

//Local aAreaSD1  := SD1->(GetArea())
Local lConfirma := (PARAMIXB[2] == 1)
Local lInclui   := (PARAMIXB[1] == 3)
Local lAltera   := (PARAMIXB[1] == 4)
Local lSrvPgto  := GetNewPar("BZ_SRVPGTO",.F.) // Habilita aprovacao de pagamento notas de serviço

Local nOpcao    := ParamIXB[1]
Local nConfirm  := ParamIXB[2]
/*Local nQtdPallet:= 0
local nVolPallet:= 0
Local nCount	:= 0
Local nPallet	:= 0

Local cNPallet	:= ""
Local cSeq		:= "001"*/
Local nI

Local aFormas	:= { "Boleto","Deposito","Cheque","Dinheiro","Convênio","Compensação" }
Local aCodFor	:= { "BO","DB","CH","DI","CO","CP"}
//Local nForma	:= 1	
Local lOK		:= .F.
Local lGeraFin  := .F.
Local _lSaldo	:= .F.

Private aArrEtq	:= {}
Private aParam	:= {}

cBanco  := MV_PAR01
cAgenc  := MV_PAR02
cDVage  := MV_PAR03
cConta  := MV_PAR04
cDVcon  := MV_PAR05

Static cBanco := '' // Antigo MV_PAR01
Static cAgenc := '' // Antigo MV_PAR02
Static cDVage := '' // Antigo MV_PAR03
Static cConta := '' // Antigo MV_PAR04
Static cDVcon := '' // Antigo MV_PAR05

If lConfirma .And. (lInclui .Or. lAltera)

    // Nota Fiscal de Serviço - Envia Workflow de Aprovação de Pagamento
    If AllTrim(cEspecie) == "NFS" .And. lSrvPgto
        FWMsgRun(, {|| U_TAGINT05(cNFiscal, cSerie, cA100For, cLoja) }, "Processando", "Enviando Workflow de Pagamento...")
    EndIf

EndIf


If nConfirm == 1 

/////////////////////////////////////////////////////////
	dbSelectArea("SF4")
	SF4->( dbSetOrder(1) )
	
	For nI := 1 To Len(aCols)
		
		If SF4->( dbSeek(xFilial("SF4") + GDFieldGet("D1_TES", nI)) ) 
			If SF4->F4_DUPLIC == "S"
				lGeraFin := .T.
			EndIf
			
			If SF4->F4_ESTOQUE == "S"
				_lSaldo := .T.
			Endif
			
		EndIf
		
	Next nI
	
	If Inclui .AND. !cTipo $ "DB" .AND. !EMPTY(cNFiscal) .AND. POSICIONE("SA2", 1, XFILIAL("SA2") + ca100For + cLoja, "A2_EST") <> "EX" .And. lGeraFin
		
		aAreaT := GetArea()
				
		WHILE !lOK .And. Inclui
		
			IF PARAMBOX( { 	{3,"Forma Pgto",1,aFormas,120,"",.T.},	;
							{1,"Resumo da Compra",CriaVar("E2_HIST",.F.),"@!","","","",70,.F.}	;
							},"COMPLEMENTO DE TITULO-MT103FIM")				
				cResumo := MV_PAR02

			dbSelectArea("SE2")
				aAreaSE2 := GetArea()
				dbSetOrder(6)	// E2_FILIAL, E2_FORNECE, E2_LOJA, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, R_E_C_N_O_, D_E_L_E_T_
				dbSeek(XFILIAL()+ca100For+cLoja+cSerie+cNFiscal)
				WHILE !EOF() .AND. (SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM)==(ca100For+cLoja+cSerie+cNFiscal)
					
					RecLock("SE2",.F.)
						E2_FORPAG	:= aCodFor[mv_par01]
						E2_HIST		:= mv_par02
					MsUnLock()
					// Solicita digitacao do boleto/convênio
					IF mv_par01==1 .OR. mv_par01==5
						IF APMSGYESNO("Deseja capturar o codigo de barras da parcela ' "+SE2->E2_PARCELA+" ' agora?")
							U_ICOMX010()
						ENDIF
					// Verifica dados bancarios
					ELSEIF mv_par01==2
						dbSelectArea("SA2")
						dbSetOrder(1)	// FILIAL+COD+LOJA
						dbSeek(XFILIAL()+SE2->E2_FORNECE+SE2->E2_LOJA)
						IF EMPTY(SA2->A2_BANCO) .OR. EMPTY(SA2->A2_AGENCIA) .OR. EMPTY(SA2->A2_NUMCON)
							
							IF ALLTRIM(FUNNAME())=="MATA103"
								PARAMBOX( { 	{1,"Banco",CriaVar("A2_BANCO",.F.),"@!","","","",70,.T.},	;
												{1,"Num. Agencia",CriaVar("A2_AGENCIA",.F.),"@!","","","",70,.T.},	;
												{1,"DV. Agencia",CriaVar("A2_DVAGE",.F.),"@!","","","",70,.F.},	;
												{1,"Num Conta",CriaVar("A2_NUMCON",.F.),"@!","","","",70,.T.},	;
												{1,"DV. Conta",CriaVar("A2_DVCTA",.F.),"@!","","","",70,.F.}	;
												},"COMPLEMENTO DE TITULO-MT103FIM",@aParam)
												
												cBanco  := MV_PAR01
												cAgenc  := MV_PAR02
												cDVage  := MV_PAR03
												cConta  := MV_PAR04
												cDVcon  := MV_PAR05
												GravaSA2()
							
							ELSE
								MsgAlert("Foi verificado que os dados bancarios deste fornecedor estao incompletos. Favor acessar o cadastro e corrigir, pois caso contrário não será possível a liberação para pagamento.","DADOS BANCÁRIOS-"+ALLTRIM(FUNNAME())+"-MT119AGR")
							ENDIF
						ENDIF
					ENDIF
					dbSelectArea("SE2")
					dbSkip()
				ENDDO
				RestArea(aAreaSE2)
				lOK := .T.
			ENDIF
		ENDDO
		RestArea(aAreaT)		
	EndIf

	////////////////////////////////////////////////////////
	//---------------------+
	// Posiciona etiquetas |
	//---------------------+
	dbSelectArea("ZZA")
	ZZA->( dbSetOrder(1) )
		
	//---------------------------+			
    // Inclusão ou Classificação |
    //---------------------------+
    If ( nOpcao == 3 .Or. nOpcao == 4 ) .And. !cTipo $ "DB" .And. !Empty(SF1->F1_STATUS) .And. _lSaldo
    	
    	//---------------+
    	// Atualiza Flag |
    	//---------------+
    	Reclock("SF1",.F.)
    		SF1->F1_XSTATUS := "1"
    	SF1->( MsUnLock() )
    	/*    		
    	//------------------------+
		// Complemento de Produto |
		//------------------------+
		dbSelectArea("SB5")
		SB5->( dbSetOrder(1) )
    	
        dbSelectArea("SD1")
        SD1->( dbSetOrder( 1 ) )
        If SD1->( DbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
            While SD1->( !Eof() ) .And. SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA ) == ; 
                                        SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
                
                //------------------------------+
                // Valida se ja exsite etiqueta |
                //------------------------------+
                If ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SD1->D1_ITEM) )
                	SD1->( DbSkip() )
                	Loop
                EndIf
                
                //------------------------------------------+
                // Valida a quantidade de caixas por Pallet |
                //------------------------------------------+
                nVolPallet := 0
                If SB5->( dbSeek(xFilial("SB5") + SD1->D1_COD) )
                	nVolPallet := SB5->B5_XPALLET
                EndIf
                
                nCount 		:= 1
                nPallet		:= 1
                nQtdPallet	:= Int(SD1->D1_QUANT/nVolPallet)
                cNPallet	:= ""
                If nQtdPallet > 0
                	//cNPallet	:= PadL(Alltrim(SF1->F1_DOC),7,"0") + PadL(Alltrim(SF1->F1_SERIE),3,"0") + cSeq
                	cNPallet	:= StrZero(Val(SF1->F1_DOC),7) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
                EndIf	
                
                While SD1->D1_QUANT >= nCount 
                	
	                RecLock( "ZZA", .T. )
		                ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
		                ZZA->ZZA_CODPRO	:= SD1->D1_COD
		                ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + SD1->D1_COD, 1 )
		                ZZA->ZZA_QUANT  := 1
		                ZZA->ZZA_VLRUNI := SD1->D1_VUNIT
		                ZZA->ZZA_NUMNF  := SF1->F1_DOC
		                ZZA->ZZA_SERIE  := SF1->F1_SERIE
		                ZZA->ZZA_FORNEC := SF1->F1_FORNECE
		                ZZA->ZZA_LOJA   := SF1->F1_LOJA
		                ZZA->ZZA_NUMCX  := StrZero(nCount,4)
		                ZZA->ZZA_NUMLOT := SD1->D1_LOTECTL
		                ZZA->ZZA_ITEMNF := SD1->D1_ITEM
		                ZZA->ZZA_LOCENT := SD1->D1_LOCAL
		                ZZA->ZZA_PALLET	:= cNPallet	
		                ZZA->ZZA_BAIXA	:= "1"
		                ZZA->ZZA_CONFER	:= .F.
	                ZZA->( MsUnlock() )
	                
	                //------------------------------+
	                // Valida se preencheu o Pallet |
	                //------------------------------+
	                If nPallet == nVolPallet .And. nQtdPallet <> 0
	                	nPallet 	:= 0
	                	cSeq		:= Soma1(cSeq)
	                	cNPallet	:= StrZero(Val(SF1->F1_DOC),7) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
	                	nQtdPallet--
	                ElseIf nQtdPallet == 0
	                	cNPallet	:= ""
	                EndIf	
	                
	                //-----------------+
	                // Contador Rotina |
	                //-----------------+
	                nCount++
	                nPallet++
                
	            EndDo
	                
                SD1->( DbSkip() )

            EndDo 
        EndIf
		*/
    //-----------+			
    // Devolução |
    //-----------+	
    ElseIf ( nOpcao == 3 .Or. nOpcao == 4 ) .And. cTipo == "D" .And. !Empty(SF1->F1_STATUS) .And. _lSaldo
    	
    	//---------------+
    	// Atualiza Flag |
    	//---------------+
    	Reclock("SF1",.F.)
    		SF1->F1_XSTATUS := "1"
    	SF1->( MsUnLock() )
    	    		
    	/*
		//------------------------+
		// Complemento de Produto |
		//------------------------+
		dbSelectArea("SB5")
		SB5->( dbSetOrder(1) )
    	
        dbSelectArea("SD1")
        SD1->( dbSetOrder( 1 ) )
        If SD1->( DbSeek( SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
            While SD1->( !Eof() ) .And. SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA ) == ; 
                                        SF1->( F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
                
                //------------------------------+
		        // Valida se ja exsite etiqueta |
		        //------------------------------+
		        If ZZA->( dbSeek(xFilial("ZZA") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA + SD1->D1_ITEM) )
		        	SD1->( DbSkip() )
		        	Loop
		        EndIf
                
                //------------------------------------------+
                // Valida a quantidade de caixas por Pallet |
                //------------------------------------------+
                nVolPallet := 0
                If SB5->( dbSeek(xFilial("SB5") + SD1->D1_COD) )
                	nVolPallet := SB5->B5_XPALLET
                EndIf
                
                nCount 		:= 1
                nPallet		:= 1
                nQtdPallet	:= Int(SD1->D1_QUANT/nVolPallet)
                cNPallet	:= ""
                If nQtdPallet > 0
                	//cNPallet	:= PadL(Alltrim(SF1->F1_DOC),7,"0") + PadL(Alltrim(SF1->F1_SERIE),3,"0") + cSeq
                	cNPallet	:= "D" + StrZero(Val(SF1->F1_DOC),6) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
                EndIf	
                
                While SD1->D1_QUANT >= nCount 
                	
	                RecLock( "ZZA", .T. )
		                ZZA->ZZA_FILIAL	:= xFilial( "ZZA" )
		                ZZA->ZZA_CODPRO	:= SD1->D1_COD
		                ZZA->ZZA_CODBAR := GetADVFVal( "SB1", "B1_CODBAR", xFilial( "SB1" ) + SD1->D1_COD, 1 )
		                ZZA->ZZA_QUANT  := 1
		                ZZA->ZZA_VLRUNI := SD1->D1_VUNIT
		                ZZA->ZZA_NUMNF  := SF1->F1_DOC
		                ZZA->ZZA_SERIE  := SF1->F1_SERIE
		                ZZA->ZZA_FORNEC := SF1->F1_FORNECE
		                ZZA->ZZA_LOJA   := SF1->F1_LOJA
		                ZZA->ZZA_NUMCX  := StrZero(nCount,4)
		                ZZA->ZZA_NUMLOT := SD1->D1_LOTECTL
		                ZZA->ZZA_ITEMNF := SD1->D1_ITEM
		                ZZA->ZZA_LOCENT := SD1->D1_LOCAL
		                ZZA->ZZA_PALLET	:= cNPallet	
		                ZZA->ZZA_BAIXA	:= "1"
		                ZZA->ZZA_CONFER	:= .F.
	                ZZA->( MsUnlock() )
	                
	                //------------------------------+
	                // Valida se preencheu o Pallet |
	                //------------------------------+
	                If nPallet == nVolPallet .And. nQtdPallet <> 0
	                	nPallet 	:= 0
	                	cSeq		:= Soma1(cSeq)
	                	cNPallet	:= "D" + StrZero(Val(SF1->F1_DOC),6) + StrZero(Val(SF1->F1_SERIE),3) + cSeq
	                	nQtdPallet--
	                ElseIf nQtdPallet == 0
	                	cNPallet	:= ""
	                EndIf	
	                
	                //-----------------+
	                // Contador Rotina |
	                //-----------------+
	                nCount++
	                nPallet++
                
	            EndDo
	                
                SD1->( DbSkip() )

            EndDo 
        EndIf
        */

    //----------+ 
    // Exclusão |    
    //----------+
    ElseIf nOpcao == 5 .And. _lSaldo

        //--------------+
        // Exclui a ZZA |
        //--------------+
        DeleteZZA()

    EndIf

EndIf

RestArea( aArea )
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} DeleteZZA
Exclui a ZZA de acordo com a SF1 posicionada
@author  Victor Andrade
@since   04/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function DeleteZZA()

Local aArea      := GetArea()
Local cNextAlias := GetNextAlias()

If Select( cNextAlias ) > 0; (cNextAlias)->( DbCloseArea() ); EndIf

BeginSQL Alias cNextAlias
    SELECT R_E_C_N_O_ RECNO FROM %table:ZZA%
    WHERE   ZZA_FILIAL   = %xFilial:ZZA%
    AND     ZZA_NUMNF    = %exp:SF1->F1_DOC%
    AND     ZZA_SERIE    = %exp:SF1->F1_SERIE%
    AND     ZZA_FORNEC   = %exp:SF1->F1_FORNECE%
    AND     ZZA_LOJA     = %exp:SF1->F1_LOJA%
    AND     %notdel%
EndSQL

(cNextAlias)->( DbGoTop() )

While (cNextAlias)->( !Eof() )

    ZZA->( DbGoTo( (cNextAlias)->RECNO ) )
    
    RecLock( "ZZA", .F. )
    	ZZA->( DbDelete() )
    ZZA->( MsUnlock() )

    (cNextAlias)->( DbSkip() )

EndDo

(cNextAlias)->( DbCloseArea() )

RestArea( aArea )

Return Nil

Static Function GravaSA2()

	DbSelectArea("SA2")
	If !Empty(cBanco) .and. !Empty(cAgenc) .and. !Empty(cConta) .and. !Empty(cDVcon)
	
	Reclock("SA2",.F.)
	   SA2->A2_BANCO 	:= Alltrim(cBanco)
	   SA2->A2_AGENCIA	:= Alltrim(cAgenc)
	   SA2->A2_DVAGE	:= Alltrim(cDVage)
	   SA2->A2_NUMCONTA	:= Alltrim(cConta)
	   SA2->A2_DVCTA	:= Alltrim(cDVcon)
	msUnlock("SA2")
	
	Endif

Return
