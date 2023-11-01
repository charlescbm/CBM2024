#INCLUDE "PROTHEUS.CH"

//DESENVOLVIDO POR INOVEN


User Function MTA410T()

SA1->(dbSetOrder(1))
SA1->(msSeek(xFilial('SA1') + SC5->C5_CLIENTE + SC5->C5_LOJACLI))

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

	MaFisIni(SC5->C5_CLIENTE,;                   // 01 - Codigo Cliente/Fornecedor
		SC5->C5_LOJACLI,;                        // 02 - Loja do Cliente/Fornecedor
		Iif(SC5->C5_TIPO $ "D;B", "F", "C"),;    // 03 - C:Cliente , F:Fornecedor
		SC5->C5_TIPO,;                           // 04 - Tipo da NF
		SC5->C5_TIPOCLI,;                        // 05 - Tipo do Cliente/Fornecedor
		MaFisRelImp("MT100", {"SF2", "SD2"}),;   // 06 - Relacao de Impostos que suportados no arquivo
		,;                                       // 07 - Tipo de complemento
		,;                                       // 08 - Permite Incluir Impostos no Rodape .T./.F.
		"SB1",;                                  // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
		"MATA461")                               // 10 - Nome da rotina que esta utilizando a funcao

	//Enquanto houver itens
	SC6->(msSeek(FWxFilial('SC6') + SC5->C5_NUM, .T.))
	nItAtu := 0
	While !SC6->(EoF()) .And. SC6->C6_FILIAL == FWxFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM
		nItAtu++
	
		//Adiciona o item nos tratamentos de impostos
		SB1->(msSeek(FWxFilial("SB1")+SC6->C6_PRODUTO))
		MaFisAdd(SC6->C6_PRODUTO,;    // 01 - Codigo do Produto                    ( Obrigatorio )
			SC6->C6_TES,;             // 02 - Codigo do TES                        ( Opcional )
			SC6->C6_QTDVEN,;          // 03 - Quantidade                           ( Obrigatorio )
			SC6->C6_PRCVEN,;          // 04 - Preco Unitario                       ( Obrigatorio )
			SC6->C6_VALDESC,;         // 05 - Desconto
			SC6->C6_NFORI,;           // 06 - Numero da NF Original                ( Devolucao/Benef )
			SC6->C6_SERIORI,;         // 07 - Serie da NF Original                 ( Devolucao/Benef )
			0,;                       // 08 - RecNo da NF Original no arq SD1/SD2
			0,;                       // 09 - Valor do Frete do Item               ( Opcional )
			0,;                       // 10 - Valor da Despesa do item             ( Opcional )
			0,;                       // 11 - Valor do Seguro do item              ( Opcional )
			0,;                       // 12 - Valor do Frete Autonomo              ( Opcional )
			SC6->C6_VALOR,;           // 13 - Valor da Mercadoria                  ( Obrigatorio )
			0,;                       // 14 - Valor da Embalagem                   ( Opcional )
			SB1->(RecNo()),;          // 15 - RecNo do SB1
			0)                        // 16 - RecNo do SF4

		nBasICM    := MaFisRet(nItAtu, "IT_BASEICM")

		SC6->(recLock('SC6', .F.))
		SC6->C6_ZPICM := nPIcms * 100
		SC6->C6_ZVALICM := Round(nBasICM * nPIcms, 2)
		SC6->(msUnlock())

		SC6->(DbSkip())
	EndDo

	MaFisEnd()

endif

//Grava o valor da comissão
SC6->(msSeek(FWxFilial('SC6') + SC5->C5_NUM, .T.))
While !SC6->(EoF()) .And. SC6->C6_FILIAL == FWxFilial('SC6') .and. SC6->C6_NUM == SC5->C5_NUM

	SC6->(recLock('SC6', .F.))
	SC6->C6_ZVCOMIS := SC6->C6_VALOR * (SC6->C6_COMIS1 / 100)
	SC6->C6_ZVCOMSS := SC6->C6_VALOR * (SC6->C6_COMIS2 / 100)
	SC6->(msUnlock())

	SC6->(DbSkip())
EndDo
//Fim comissão


Return()
