#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
#INCLUDE "PROTHEUS.CH"                                 
#INCLUDE "TOPCONN.CH"
#Define  _CRLF  CHR(13)+CHR(10)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} SF2460I
Ponto de entrada utilizado para tratar informaçoes apos faturamento                                            
       
@author		P2P
@since     	16/09/16
@version  	P.11              
@param 		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function SF2460I()
	
	Local aAreaOld	:= {SF2->(GetArea()),SD2->(GetArea()),SE1->(GetArea()),GetArea()}
	//Local cCodDoc	:= SF2->F2_DOC
	//Local cSerie	:= SF2->F2_SERIE
	//Local cCliente	:= SF2->F2_CLIENTE
	//Local cLoja		:= SF2->F2_LOJA
	//Local cSql		:= ''
	//Local cAliasSCV	:= GetNextAlias()
	//Local aSCV		:= {}
	//Local nContTit	:= 1
	//Local cCNPJFil	:= ''//Getmv('TI_CNPJDE',.F.,'03662136000155')
	//Local cFilLoj	:= ''//GetMv('TI_FILLOJ',.F.,'0502')     
	Local cTipoPG   := Space(3)
	//Local cDescPG   := Space(20)
	//Local cCodPed	:= ''
	Local dDtAgenda	:= DataValida(DaySum(dDataBase, GetMv('IN_DIAAGEN',.F.,10)))
	Local _TIPOV:= ''

	//Destinado a compensacao automatica dos titulos
	Local aRecSE1 := {}
	Local aRecRA  := {}
	Local cCpPed  := ""	//pedido, quando compensacao
    
	// Chamada Ponto de Entrada Projetos Corporativos
	//If ExistBlock("XSF2460I")
	//	ExecBlock("XSF2460I",.F.,.F.)
	//EndIf

	//Return .T.

	SE4->(DbSetOrder(01)) 
	If SE4->(DbSeek(xFilial('SE4')+SF2->F2_COND))  
		If !Empty(SE4->E4_FORMA)	
			cTipoPG   :=SE4->E4_FORMA
			SE1->(DbSetorder(01))
			SE1->(DbSeek(xFilial('SE1') + SF2->F2_PREFIXO + SF2->F2_DOC,.t.))
			Do While SE1->(!Eof()) .And. SF2->F2_PREFIXO == SE1->E1_PREFIXO .And. SF2->F2_DOC == SE1->E1_NUM .And. SE1->E1_CLIENTE = SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA				
				SE1->(RecLock('SE1',.F.))
				SE1->E1_XFORMA := cTipoPG
				SE1->(MsUnLock())
				
				SE1->(DbSkip())
			EndDo
		EndIf
	EndIf
	//Integração com agenda
	SD2->(DbSetOrder(3))
	If SD2->(DbSeek( xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ))   
   		u_DnyGrvSt(SD2->D2_PEDIDO, "000002")
   		//--Finaliza agenda
   		_TIPOV:= Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_TIPO")
         IF _TIPOV == 'I'
   			SC5->(DbSetOrder(01))
   			If SC5->(DbSeek(SD2->D2_FILIAL+SD2->D2_PEDIDO))   		
   				u_gravaAgenda(xFilial('ZAF'), SC5->C5_XNUMORC, "P")
   				//--Grava nova agenda para o cliente
   				FGravaAge('', SF2->F2_CLIENTE, SF2->F2_LOJA, dDtAgenda, '')
   			EndIf
   		ENDIF		
	EndIf  
	//Fim

	//Ajuste do nome do cliente no financeiro
	if !(SF2->F2_TIPO$"DB")
		cNumRA := ""
		cPedRA := ""
		cCpPed := ""
		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA))
		SE1->(DbSetorder(01))
		SE1->(DbSeek(xFilial('SE1') + SF2->F2_PREFIXO + SF2->F2_DOC,.t.))
		Do While SE1->(!Eof()) .And. SF2->F2_PREFIXO == SE1->E1_PREFIXO .And. SF2->F2_DOC == SE1->E1_NUM .And. SE1->E1_CLIENTE = SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA				
			SE1->(RecLock('SE1',.F.))
			SE1->E1_NOMCLI := SA1->A1_NOME
			SE1->E1_XCGCCLI:= SA1->A1_CGC
			SE1->(MsUnLock())

			/*SC5->(dbSetOrder(1))
			if SC5->(msSeek(xFilial("SC5") + SE1->E1_PEDIDO))
				if SC5->C5_CONDPAG == "003"
					cNumRA := SC5->C5_ZFINANT
					cPedRA := SC5->C5_NUM
					AAdd(aRecSE1, SE1->(RECNO()))
				endif
			endif*/	
			SC5->(dbSetOrder(1))
			if SC5->(msSeek(xFilial("SC5") + SE1->E1_PEDIDO))
				if SC5->C5_CONDPAG $ GetNewPar("IN_CPADIAN", "003")
					cCpPed := SC5->C5_NUM
					AAdd(aRecSE1, SE1->(RECNO()))
				endif
			endif
			
			SE1->(DbSkip())
		EndDo

		/*if !empty(cNumRA)
			SE1->(dbSetOrder(1))
			SE1->(msSeek(xFilial("SE1") + cNumRA, .T.))
			While SE1->(!Eof()) .And. SE1->E1_FILIAL == xFilial("SE1") .and. cNumRA == SE1->E1_PREFIXO + SE1->E1_NUM .And. SE1->E1_CLIENTE = SF2->F2_CLIENTE .And. SE1->E1_LOJA == SF2->F2_LOJA				
				if alltrim(SE1->E1_TIPO) == "RA" .and. SE1->E1_PEDIDO == cPedRA
					AAdd(aRecRA, SE1->(RECNO()))
				endif				
				
				SE1->(DbSkip())
			EndDo

			//MsAguarde({|lEnd| MaIntBxCR(3, aRecSe1,, aRecRA,, {.T.,.F.,.F.,.F.,.F.,.T.},,,,,,,,,,, MV_PAR08 == 1) },"Aguarde...","Realizando o processo de compensação...",.T.)
			MsAguarde({|lEnd| MaIntBxCR(3, aRecSe1,, aRecRA,, {.F.,.F.,.F.,.F.,.F.,.T.},,,,,,,,,,, MV_PAR08 == 1) },"Aguarde...","Realizando o processo de compensação...",.T.)

		endif*/
		if !empty(cCpPed)
			IF SELECT("QRYE1") <> 0
				QRYE1->(DBCLOSEAREA())
			ENDIF                                                                     
			
			BeginSQL Alias "QRYE1"	                    
				SELECT E1_NUM, E1_PREFIXO, E1_TIPO, E1_CLIENTE, E1_LOJA, R_E_C_N_O_ E1RECNO
				FROM %Table:SE1% E1
				WHERE
					E1.%NotDel%
					AND E1_PEDIDO = %Exp:cCpPed%
					AND E1_CLIENTE = %Exp:SF2->F2_CLIENTE% AND E1_LOJA = %Exp:SF2->F2_LOJA%
					AND E1_SALDO  > 0 AND E1_TIPO <> 'NF '
			EndSql
			While QRYE1->(!eof())
				AAdd(aRecRA, QRYE1->E1RECNO)
				QRYE1->(dbSkip())
			End
			MsAguarde({|lEnd| MaIntBxCR(3, aRecSe1,, aRecRA,, {.F.,.F.,.F.,.F.,.F.,.T.},,,,,,,,,,, MV_PAR08 == 1) },"Aguarde...","Realizando o processo de compensação...",.T.)
		endif					

	Endif

	//Beneficio do ICMS
	SA1->(dbSetOrder(1))
	SA1->(msSeek(xFilial('SA1') + SF2->F2_CLIENTE + SF2->F2_LOJA))

	//somente se cliente nao for INOVEN
	if substr(SA1->A1_CGC,1,8) <> '07826504'

		//Definir o % de ICMS com beneficio
		nPIcms := 0
		Do Case
			//Fora do Estado
			Case SA1->A1_EST <> SM0->M0_ESTENT; nPIcms := 0.01
			//Dentro do Estado e Simples
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPSIMP", "SCA"); nPIcms := 0.036
			//Dentro do Estado e Consumidor Final
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPCFIN", "055"); nPIcms := 0.036
			//Dentro do Estado e Nao Simples
			Case SA1->A1_EST == SM0->M0_ESTENT .and. SA1->A1_GRPTRIB == GetNewPar("IN_GRPNSIM", "SCC"); nPIcms := 0.001
		EndCase

		//Enquanto houver itens
		SD2->(dbSetOrder(3))
		SD2->(msSeek(FWxFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ))
		nItAtu := 0
		While !SD2->(EoF()) .And. SD2->D2_FILIAL == FWxFilial('SD2') .and. SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
			nItAtu++
		
			SD2->(recLock('SD2', .F.))
			SD2->D2_ZPICM := nPIcms * 100
			SD2->D2_ZVALICM := Round(SD2->D2_BASEICM * nPIcms, 2)
			SD2->(msUnlock())

			SD2->(DbSkip())
		EndDo

	endif
	//Fim do Beneficio do ICMS

	//Grava o valor da comissão
	nCuba := 0
	SD2->(dbSetOrder(3))
	SD2->(msSeek(FWxFilial('SD2') + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA, .T. ))
	While !SD2->(EoF()) .And. SD2->D2_FILIAL == FWxFilial('SD2') .and. SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
	
		SB1->(dbSetOrder(1))
		SB1->(msSeek(xFilial('SB1') + SD2->D2_COD))

		SD2->(recLock('SD2', .F.))
		SD2->D2_ZVCOMIS := SD2->D2_TOTAL * (SD2->D2_COMIS1 / 100)
		SD2->D2_ZVCOMSS := SD2->D2_TOTAL * (SD2->D2_COMIS2 / 100)
		SD2->D2_XALTURA	:= SB1->B1_XALTURA
		SD2->D2_XLARG	:= SB1->B1_XLARG
		SD2->D2_XCOMPR	:= SB1->B1_XCOMPR
		SD2->D2_XVOL	:= SB1->B1_XVOL
		SD2->(msUnlock())

		//Calcula Cubagem
		nCuba += Round(SD2->D2_QUANT * SB1->B1_XALTURA * SB1->B1_XLARG * SB1->B1_XCOMPR,5)   	
		//nCuba += Round(SD2->D2_QUANT * SB1->B1_XVOL,4)   	

		SD2->(DbSkip())
	EndDo
	//Fim comissão

	//Grava a cubagem
	if !empty(nCuba)
		SF2->(recLock('SF2', .F.))
		SF2->F2_ZCUBA := nCuba
		SF2->(msUnlock())
	endif
	//Fim da gravacao da cubagem

	//Gravar nota no contas a pagar, guia icms complementar
	if !empty(SF2->F2_GNRDIF)
		SE2->(dbSetOrder(1))
		SE2->(msSeek(xFilial('SE2') + SF2->F2_GNRDIF + space(len(SE2->E2_PARCELA)) + 'TX '))
		if SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO == xFilial('SE2') + SF2->F2_GNRDIF + space(len(SE2->E2_PARCELA)) + 'TX '
			SE2->(recLock('SE2', .F.))
			SE2->E2_ZGDOC := SF2->F2_DOC + SF2->F2_SERIE
			SE2->(msUnlock())
		endif
	endif
	//fim


	//--Restaura Area
	Aeval(aAreaOld,{|nlem| RestArea(nlem) })

Return(Nil)
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} FGravaAge
Função grava agenda 

@author		.iNi Sistemas
@since     	01/03/2019
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
Static Function FGravaAge(CDOC, CCLI, COJA, dAgenda, cHistor)

	Local cId := '', cQuery := ''
	
	//Verificar se existe alguma agenda em aberto para o cliente
	cQuery := "SELECT * FROM "+RetSqlName("ZAF")+" ZAF " + CRLF
	cQuery += "WHERE ZAF.D_E_L_E_T_ = ' ' AND ZAF.ZAF_CLIENT = '" + CCLI + "' " + CRLF
	cQuery += "AND ZAF.ZAF_LOJA = '" + COJA + "' " + CRLF
	//cQuery += "AND ZAF.ZAF_NUMORC = ' ' " + CRLF
	cQuery += "AND ((ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN < '"+Dtos(dDatabase)+"') " + CRLF
	cQuery += "OR (ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN = '"+Dtos(dDatabase)+"') " + CRLF
	cQuery += "OR (ZAF.ZAF_ATEND IN (' ','2') AND ZAF.ZAF_DTAGEN > '"+Dtos(dDatabase)+"')) " + CRLF
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"ZAFX",.F.,.T.)

	ZAFX->(dbGotop())
	lTem := .F.
	While ZAFX->(!eof())
		lTem := .T.
		ZAFX->(dbSkip())
	End
	If Select( 'ZAFX' ) > 0; ZAFX->(dbCloseArea()); EndIf

	if !lTem	//caso nao tenha nenhuma agenda em aberto, cria uma nova
		cId := U_TAG06PRX()
		
		ZAF->(RecLock("ZAF",.T.))
		ZAF->ZAF_FILIAL  := xFilial("ZAF")
		ZAF->ZAF_TPAGEN  := '000002'
		ZAF->ZAF_DATINC  := dDataBase
		ZAF->ZAF_HORINC  := Time()
		ZAF->ZAF_DTAGEN  := dAgenda
		ZAF->ZAF_CONTAT  := ''
		ZAF->ZAF_FORMA   := '1'
		ZAF->ZAF_PROSP   := '2'
		ZAF->ZAF_CLIENT  := CCLI
		ZAF->ZAF_LOJA    := COJA
		ZAF->ZAF_HISTOR  := cHistor
		ZAF->ZAF_USRINC  := __cUserId
		ZAF->ZAF_ID      := cId
		ZAF->ZAF_IDPAI   := cId
		ZAF->ZAF_ATEND   := "2"
		ZAF->ZAF_NUMORC	:= CDOC
		ZAF->(MsUnLock())
	endif

Return( Nil )
