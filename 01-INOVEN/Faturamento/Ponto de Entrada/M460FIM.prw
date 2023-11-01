#Include "Protheus.ch"
#INCLUDE "COLORS.CH"
#Include "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³M460FIM   ?Autor ?RENATO BANDEIRA    ?Data ? 20/05/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Ponto de Entrada excutado apos a gravacao da NF de saida.  º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?Limpar Volume e Quantidade de volumes apos a NFS           º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
/*/
//DESENVOLVIDO POR INOVEN

User Function M460FIM

	Local _cArea:=GetArea() 
	
	//--Valida Condição negociada
	If AllTrim(SF2->F2_COND) $ AllTrim(GetMv("FS_CONNEG",.F.,'001'))
		fAtuTit() 
	EndIf
   
	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE )   
   		u_DnyGrvSt(SD2->D2_PEDIDO, "000002")
	EndIF  
     
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava informacao de especie e volume?
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	GdEspVol()
    

	RestArea(_cArea)                                                         
                                                      
Return(Nil)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³GdEspVol  ºAutor  ³SServices           ?Data ? 26/10/11   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDesc.     ³Grava dados de especie e volume no documento fiscal         º±?
±±?         ?                                                           º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?AP                                                         º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß?
*/
Static Function GdEspVol()
Local aArea		 	:= GetArea()
Local aAreaSD2		:= SD2->(GetArea())
Local cNumDoc		:= SF2->F2_DOC
Local cSerie   		:= SF2->F2_SERIE
Local cCli			:= SF2->F2_CLIENTE
Local cLoja			:= SF2->F2_LOJA
Local nVol1			:= 0
Local nCxa			:= 0
//Local nVol2			:= 0
//Local nCxa2			:= 0

DbSelectArea("SD2")
SD2->(DbSetOrder(3))
SD2->(DbSeek(xFilial("SD2")+cNumDoc+cSerie+cCli+cLoja))
While !SD2->(Eof()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_DOC == cNumDoc .and. SD2->D2_SERIE == cSerie .and.	SD2->D2_CLIENTE == cCli .and. SD2->D2_LOJA == cLoja

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
	nCxa := 0 
	nVol1 := nVol1 + SD2->D2_QUANT
	
	/*
	
	IF ALLTRIM(SB1->B1_UM) = 'CX'
		If SB1->B1_QE == 0 
			nVol1 := nVol1 + SD2->D2_QUANT
		ElseIf SD2->D2_QUANT <= SB1->B1_QE
			nVol1++
		ElseIf SB1->B1_QE > 0 .and. SD2->D2_QUANT > SB1->B1_QE
			nCxa := SD2->D2_QUANT/SB1->B1_QE
			IF MOD(SD2->D2_QUANT,SB1->B1_QE) > 0
				nCxa++
		   		nCxa := Int(nCxa)
			ENDIF
			nVol1 := nVol1 + nCxa
		EndIf
     ELSEIF ALLTRIM(SB1->B1_UM) = 'ROLO'
	 	nCxa2 := 0 
		If SB1->B1_QE == 0 
			nVol2 := nVol2 + SD2->D2_QUANT
		ElseIf SD2->D2_QUANT <= SB1->B1_QE
			nVol2++
		ElseIf SB1->B1_QE > 0 .and. SD2->D2_QUANT > SB1->B1_QE
			nCxa2 := SD2->D2_QUANT/SB1->B1_QE
			IF MOD(SD2->D2_QUANT,SB1->B1_QE) > 0
				nCxa2++
		   		nCxa2 := Int(nCxa2)
			ENDIF
			nVol2 := nVol2 + nCxa2
		EndIf
    ENDIF 
	*/

    //Valor do frete
    If (Select("QRYFRE") <> 0)
        QRYFRE->(dbCloseArea())
    Endif
    BEGINSQL ALIAS "QRYFRE"
        SELECT SUM(GWM_VLFRET) VLFRETECALC 
        FROM %table:GWM% GWM WHERE 
        GWM.%notdel% AND GWM_TPDOC = '1' 
        AND GWM_FILIAL = %xfilial:GWM%
        AND GWM_NRDC = %exp:SD2->D2_DOC%
        AND GWM_SERDC = %exp:SD2->D2_SERIE%
		AND GWM_SEQGW8 = %exp:SD2->D2_ITEM%
		AND GWM_ITEM = %exp:SD2->D2_COD%
    ENDSQL
    if !empty(QRYFRE->VLFRETECALC)
		SD2->(recLock('SD2',.F.))
		SD2->D2_ZPRVFRE := QRYFRE->VLFRETECALC
		SD2->D2_ZTPFRE	:= "P"
		SD2->(msUnlock())
    endif

	SD2->(DbSkip())
EndDo


If Empty(SF2->F2_ESPECI1) .and. SF2->F2_VOLUME1 == 0 // Analisar nVol
	
	RecLock("SF2",.F.)
	SF2->F2_ESPECI1 := "VOLUMES"
	SF2->F2_VOLUME1 := nVol1
   
   /*
   	IF nVol2 > 0
		SF2->F2_ESPECI2 := "ROLO"
		SF2->F2_VOLUME2 := nVol2
	ENDIF
	*/
	SF2->(MsUnLock())
EndIf

RestArea(aAreaSD2)
RestArea(aArea)
Return

























/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±?
±±ºPrograma  ³fAtuTit   ?Autor ?Gabriel Gonçalves  ?Data ? 20/05/13   º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºDescricao ?Altera os titulos no financeiro de acordo com a condição   º±?
±±?         ?negociada                                                  º±?
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±?
±±ºUso       ?													          º±?
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
/*/
Static Function fAtuTit()

Local cSql		:= ""
Local lContinua	:= .T.
Local aArraySE1	:= {}
Local cQuery	:= ""
Local cAlias	:= GetNextAlias()
Local aCond		:= {}
Local nParcela	:= 1

//Variaveis do titulo original
Local cLA		:= ""
Local cOcorren	:= ""
Local cPedido	:= ""
Local cFluxo	:= ""
Local cTipoDes	:= ""
Local cMultNat	:= ""
Local cProjPms	:= ""
Local cDesdoBr	:= ""
Local cModSPB	:= ""
Local cScorGP	:= ""
Local cFretISS	:= ""
Local cVLMinis	:= ""
//Local cRatFin	:= ""
Local nComis1	:= 0
Local nX
 
Private lMsErroAuto := .F.

Begin Transaction
	
	//Cria os titulos de acordo com a condição negociada
	cQuery := "SELECT *"
	cQuery += " FROM "+RetSqlName("SE1")+" SE1"
	
	cQuery += " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"'"
	cQuery += " AND SE1.E1_NUM = '"+SF2->F2_DOC+"'"
	cQuery += " AND SE1.E1_PREFIXO = '"+SF2->F2_SERIE+"'"
	cQuery += " AND SE1.E1_CLIENTE = '"+SF2->F2_CLIENTE+"'"
	cQuery += " AND SE1.E1_LOJA = '"+SF2->F2_LOJA+"'"
	cQuery += " AND SE1.E1_ORIGEM = 'MATA460'"
	cQuery += " AND SE1.D_E_L_E_T_ <> '*'"
	
	dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .F., .T. )
	
	(cAlias)->(DbGoTop())
	If !(cAlias)->(EoF())
		cLA			:= (cAlias)->E1_LA
		cOcorren	:= (cAlias)->E1_OCORREN
		cPedido		:= (cAlias)->E1_PEDIDO
		cFluxo		:= (cAlias)->E1_FLUXO
		cTipoDes	:= (cAlias)->E1_TIPODES
		cMultNat	:= (cAlias)->E1_MULTNAT
		cProjPms	:= (cAlias)->E1_PROJPMS
		cDesdoBr	:= (cAlias)->E1_DESDOBR
		cModSPB		:= (cAlias)->E1_MODSPB
		cScorGP		:= (cAlias)->E1_SCORGP
		cFretISS	:= (cAlias)->E1_FRETISS
		cVLMinis	:= (cAlias)->E1_VLMINIS
		//cRatFin		:= (cAlias)->E1_RATFIN
		nComis1		:= (cAlias)->E1_COMIS1
	EndIf
	(cAlias)->(DbCloseArea())
	
	//Atualiza os titulos originais e altera a origem para controle
	cSql := "UPDATE "+RetSqlName("SE1")+""
	
	cSql += " SET D_E_L_E_T_ = '*'"
	cSql += ", E1_ORIGEM = 'IVENA030'"
	
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_NUM = '"+SF2->F2_DOC+"'"
	cSql += " AND   E1_PREFIXO = '"+SF2->F2_SERIE+"'"
	cSql += " AND   E1_CLIENTE = '"+SF2->F2_CLIENTE+"'"
	cSql += " AND   E1_LOJA = '"+SF2->F2_LOJA+"'"
	cSql += " AND   E1_ORIGEM = 'MATA460'"
	cSql += " AND   D_E_L_E_T_ <> '*'"
	
	If TCSqlExec(cSql) <> 0
		lContinua	:= .F.
	EndIf
	
	//Cria os titulos de acordo com a condição negociada
	cQuery := "SELECT *"
	cQuery += " FROM "+RetSqlName("SZ1")+" SZ1"
	cQuery += " WHERE SZ1.Z1_FILIAL = '"+xFilial("SZ1")+"'"
	cQuery += " AND SZ1.Z1_PEDIDO = '"+SD2->D2_PEDIDO+"'"
	cQuery += " AND SZ1.D_E_L_E_T_ <> '*'"
	
	dbUseArea(.T., 'TOPCONN', TcGenQry(,, cQuery), cAlias, .F., .T. )
	
	(cAlias)->(DbGoTop())
	If !(cAlias)->(EoF())
		Do While !(cAlias)->(EoF())
			aCond	:= Condicao((cAlias)->Z1_VALCON, (cAlias)->Z1_COND,, dDataBase,,,,,,)  
					
			aAreaA1 := SA1->(GetArea())
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2 ))
			
			For nX := 1 To Len(aCond)
				aArraySE1 := {  { "E1_PREFIXO"  	, SF2->F2_SERIE						, NIL },;
					            { "E1_NUM"      	, SF2->F2_DOC						, NIL },;
					            { "E1_PARCELA"  	, AllTrim(StrZero(nParcela, 3))		, NIL },;
					            { "E1_TIPO"     	, "NF"								, NIL },;
					            { "E1_NATUREZ"  	, (cAlias)->Z1_NATUREZ				, NIL },;
					            { "E1_CLIENTE"  	, SF2->F2_CLIENTE   				, NIL },;
					            { "E1_LOJA"			, SF2->F2_LOJA	   					, NIL },;  
					            { "E1_NOMCLI"		, SA1->A1_NREDUZ					, NIL },;
					            { "E1_EMISSAO"  	, dDataBase							, NIL },;
					            { "E1_VENCTO"   	, aCond[nX][1]						, NIL },;
					            { "E1_VENCREA"  	, DataValida(aCond[nX][1], .T.)	, NIL },;
					            { "E1_VALOR"    	, aCond[nX][2]						, NIL },; 
					            { "E1_XTPTRAN"    	, "C"								, NIL },;
					            { "E1_VEND1"    	, SF2->F2_VEND1						, NIL } }    
					            
				 
				MsExecAuto( { |x,y| FINA040(x,y)} , aArraySE1, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
				
				nParcela++
				
				If lMsErroAuto
				    lContinua	:= .F.
				Endif  
				
				RestArea(aAreaA1)
				
			Next nX
			
			//Atualiza a condição negociada com os dados da nota
			cSql := "UPDATE "+RetSqlName("SZ1")+""
			
			cSql += " SET Z1_PREFIXO = '"+SF2->F2_SERIE+"'"
			cSql += ", Z1_TITULO = '"+SF2->F2_DOC+"'"
			cSql += ", Z1_DTIVENC = '"+DtoS(aCond[1][1])+"'"
			cSql += ", Z1_DTFVENC = '"+DtoS(aCond[Len(aCond)][1])+"'"
			
			cSql += " WHERE Z1_FILIAL = '"+xFilial("SZ1")+"'"
			cSql += " AND Z1_PEDIDO = '"+SD2->D2_PEDIDO+"'"
			cSql += " AND Z1_COND = '"+AllTrim((cAlias)->Z1_COND)+"'"
			cSql += " AND D_E_L_E_T_ <> '*'"
			
			If TCSqlExec(cSql) <> 0
				lContinua	:= .F.
			EndIf
			
			(cAlias)->(DbSkip())
		EndDo
	Else
		lContinua	:= .F.
	EndIf
	(cAlias)->(DbCloseArea())
	
	//Atualiza os titulos novos e altera a origem para controle
	cSql := "UPDATE "+RetSqlName("SE1")+""
	
	cSql += " SET E1_SERIE = '"+SF2->F2_SERIE+"'"
	cSql += ", E1_ORIGEM = 'MATA460'"
	cSql += ", E1_LA = '"+cLA+"'"
	cSql += ", E1_OCORREN = '"+cOcorren+"'"
	cSql += ", E1_PEDIDO = '"+cPedido+"'"
	cSql += ", E1_FLUXO = '"+cFluxo+"'"
	cSql += ", E1_TIPODES = '"+cTipoDes+"'"
	cSql += ", E1_MULTNAT = '"+cMultNat+"'"
	cSql += ", E1_PROJPMS = '"+cProjPms+"'"
	cSql += ", E1_DESDOBR = '"+cDesdoBr+"'"
	cSql += ", E1_MODSPB = '"+cModSPB+"'"
	cSql += ", E1_SCORGP = '"+cScorGP+"'"
	cSql += ", E1_FRETISS = '"+cFretISS+"'"
	cSql += ", E1_VLMINIS = '"+cVLMinis+"'"
	//cSql += ", E1_RATFIN = '"+cRatFin+"'"
	cSql += ", E1_COMIS1 = '"+AllTrim(Str(nComis1))+"'"
	
	cSql += " WHERE E1_FILIAL = '"+xFilial("SE1")+"'"
	cSql += " AND   E1_NUM = '"+SF2->F2_DOC+"'"
	cSql += " AND   E1_PREFIXO = '"+SF2->F2_SERIE+"'"
	cSql += " AND   E1_CLIENTE = '"+SF2->F2_CLIENTE+"'"
	cSql += " AND   E1_LOJA = '"+SF2->F2_LOJA+"'"
	cSql += " AND   E1_ORIGEM = 'FINA040'"
	cSql += " AND   D_E_L_E_T_ <> '*'"
	
	If TCSqlExec(cSql) <> 0
		lContinua	:= .F.
	EndIf
	
	//Caso haja algum erro, RollBack em toda a rotina e avisa o usuario
	If !lContinua
		DisarmTransaction()
		Aviso("Condição Negociada","Ocorreu um erro ao gerar os titulos da condição negociada. Favor EXCLUIR a NF "+SF2->F2_DOC+" e refaturar.",{"OK"})
	EndIf
	
End Transaction

Return()
