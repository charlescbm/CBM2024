#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATM03  ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 30/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Job para Geracao de Nota Fiscal                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATM03(lAuto)

Local aButtons		:= {}
Local aAreaAtu		:= GetArea()
Local cCadastro   := OemToAnsi("Geracao de Notas")
Local nProcessa   := 3
Local lAuto       := If(lAuto == NIL,{.F.},lAuto)
Local lJob			:= .t.
//Local lJob		:= Iif(lAuto[1]==.T.,.T.,.F.)
Local cQuery
 
RPCSetType(3)  // Nao usar Licensa

// Posicionar as Tabelas Necessarias
//RpcSetEnv("02","01","Administrador","","sigafat","",{"SC9","SC5","SC6","SE4","SB1","SB2","SF4"})
RpcSetEnv("02","01",,,,,{"SC9","SC5","SC6","SE4","SB1","SB2","SF4"})
//RpcSetEnv("99","01",,,,,{"SC9","SC5","SC6","SE4","SB1","SB2","SF4"})

PREPARE ENVIRONMENT EMPRESA "02" FILIAL "04" FUNNAME "U_RFATM03" TABLES "SF2"
//PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" FUNNAME "U_RFATM03" TABLES "SF2"

U_RFATM03A(cCadastro)

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATM03A ³ Autor ³ Marcos Eduardo Rocha  ³ Data ³ 30/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Job para Geracao de Nota Fiscal                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATM03A()

Local cPedido  := Space(6)
Private aPvlNfs := {}    

//Chama rotina customizada antes do faturamento
u_qglibera()

cQuery := 	" SELECT    RECSC9, PEDIDO FROM ( "+;
				" SELECT 	SC9.C9_CLIENTE+SC9.C9_LOJA CLILOJA, SC9.R_E_C_N_O_ RECSC9, "+;
				"  			SC9.C9_PEDIDO PEDIDO, SC9.C9_ITEM ITEM,  "+;
				" 				CAST((SELECT SUM(SC91.C9_QTDLIB*SC91.C9_PRCVEN)  "+;
				" 						FROM SC9020 SC91 WHERE "+;
				" 					       SC91.C9_FILIAL   = SC9.C9_FILIAL "+;
				" 						AND SC91.C9_PEDIDO   = SC9.C9_PEDIDO "+;
				" 						AND SC91.D_E_L_E_T_  = ' ' "+;
				" 						AND SC91.C9_BLEST    = '  ' "+;
				" 						AND SC91.C9_BLCRED   = '  ' "+;
				" 						AND SC91.C9_APTOFAT  = '2' "+;
				" 						AND SC91.C9_ENTREG   >= '20080101' "+;           //dtos(dDatabase-30)
				" 						AND SC91.C9_ENTREG   <= '"+dtos(dDatabase   )+"' ) AS NUMERIC (10,2)) TOTSC9 , "+;
				" 				CAST((SELECT SUM(SC6.C6_QTDVEN*SC6.C6_PRCVEN) "+;
				" 						FROM SC6020 SC6 WHERE "+;
				" 						    SC6.C6_FILIAL  = SC9.C9_FILIAL "+;
				" 						AND SC6.C6_NUM     = SC9.C9_PEDIDO "+;
				" 						AND SC6.D_E_L_E_T_ = ' ') AS NUMERIC(10,2)) TOTSC6 "+;
				" FROM SC9020 SC9 "+;
				" WHERE "+;
				"     SC9.C9_FILIAL   = '04'  "+;
				" AND SC9.C9_BLEST    = '  ' "+;
				" AND SC9.C9_BLCRED   = '  ' "+;
				" AND SC9.D_E_L_E_T_ <> '*' "+;
				" AND SC9.C9_APTOFAT  = '2' "+;
				" AND SC9.C9_ENTREG  >= '20080101' "+;
				" AND SC9.C9_ENTREG  <= '"+dtos(dDatabase   )+"' "+;
				" ) AGRUPA1 "+;
				" WHERE "+;
				"     TOTSC9   = TOTSC6 "+;
				" AND TOTSC9  >= 450 "+;		//Filtra o valor minimo para faturamento para que nao haja docs automaticos inferiores a R$ 100,00
				" AND CLILOJA NOT IN (  "+;		//Filtra para não imprimir notas dos clientes BRASCOLA e TIGRE
				" 	SELECT DISTINCT A1_COD FROM (  "+;
				" 	SELECT A1_COD+A1_LOJA A1_COD  "+;
				" 	FROM SA1020 SA1  WHERE (A1_NOME LIKE '%BRASCOLA%' OR A1_NOME LIKE '%TIGRE%')  "+;
				" 	AND SA1.D_E_L_E_T_ = ' '  "+;
				" 	UNION  "+;
				" 	SELECT A2_COD+A2_LOJA A1_COD  "+;
				" 	FROM SA2020 SA2  "+;
				" 	WHERE (A2_NOME LIKE '%TIGRE%'    OR A2_NOME LIKE '%BRASCOLA%' )  "+;
				"	AND SA2.D_E_L_E_T_ = ' '  ) AGRUPA2 ) "+;
				" ORDER BY PEDIDO, ITEM "

MemoWrite("\QUERYSYS\RFATM03.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)       

dbSelectArea("TRB")
dbGotop()
While !Eof() .and.;
		dDataBase==DataValida(dDataBase) .and.; //Filtra faturamentos de feriados/sabados/domingos
		dDataBase<=GetMV("BR_DATAFAT") //Impede o fat automatico quando o parametro estiver trancado
	
	nOpc := 3
	aPvlNfs := {}	
	cPedido := TRB->PEDIDO
	While !Eof() .And. TRB->PEDIDO == cPedido

		dbSelectArea("SC9")
		dbSetOrder(1)
		dbGoto(TRB->RECSC9)
	
		cNumPed  := SC9->C9_PEDIDO
		cItemPed := SC9->C9_ITEM
	
		//	SC9->(DbSetOrder(1))
		//	SC9->(DbSeek(xFilial("SC9")+_cNumPed+"01") )                    //FILIAL+NUMERO+ITEM
	
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+cNumPed) )                         //FILIAL+NUMERO
	
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+cNumPed+cItemPed) )                    //FILIAL+NUMERO+ITEM
	
		SE4->(DbSetOrder(1))
		SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )                           //FILIAL+NUMERO+ITEM+PRODUTO
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO) )               //FILIAL+PRODUTO
	
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL) )          //FILIAL+PRODUTO+LOCAL
	
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                            //FILIAL+CODIGO
	
		If !Empty(SC5->C5_TABELA)
			cTabela := "DAK"
			DAK->(DbSetOrder(1))
			DAK->(DbSeek(xFilial("DAK")+SC5->C5_TABELA))                            //FILIAL+CODIGO
		
		Else
			cTabela := ""
		
		EndIf

		Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
							SC9->C9_ITEM,;
							SC9->C9_SEQUEN,;
							SC9->C9_QTDLIB,;
							SC6->C6_PRCVEN,;     //Informação indicando o Preço de Venda
	  						SC9->C9_PRODUTO,;
							SF4->F4_ISS=="S",;
	  						SC9->(RecNo()),;
	  						SC5->(RecNo()),;
	  						SC6->(RecNo()),;
							SE4->(RecNo()),;
							SB1->(RecNo()),;
							SB2->(RecNo()),;
							SF4->(RecNo()),;
							SB2->B2_LOCAL,;
							If(cTabela<>"DAK",0,DAK->(RecNo())),SC9->C9_QTDLIB2})
	
		dbSelectArea("TRB")
		dbSkip()
	EndDo
	
	If Len(aPvlNfs) > 0
		//cNota := MaPvlNfs(aPvlNfs,"   ", .F., .F., .T., .T., .F., 0, 0, .T., .F.)
		//cNota := MaPvlNfs(aPvlNfs,"1  ", .F., .F., .T., .T., .F., 0, 0, .T., .F.)
		cNota := MaPvlNfs(aPvlNfs,"1  ", .F., .F., .f., .f., .F., 0, 0, .T., .F.)
	EndIf	
	

EndDo

//StartJob("NSaida", GetEnvServer(), .F.)
//NSaida()

//Static function NSaida()
             
cEmail    := GetMV("BR_000020")
cAssunto  := "Geração de Nota Fiscal realizado as "+Time()
cTexto    := "Geração de Notas Fiscais "

If U_SendMail(cEmail,cAssunto,cTexto,"",.t.)
	ConOut("--------------------------------------------------")
	ConOut("  Enviado e-mail - Geração de Notas Fiscais       ")
	ConOut("--------------------------------------------------")
Else
	ConOut("--------------------------------------------------")
	ConOut("  Problema no envio de e-mail - Geração de Notas Fiscais ")
   ConOut("--------------------------------------------------")
EndIf

//MOSTRAERRO()
//conout("Disparou a função")
Return

/*
Abaixo um exemplo de montagem da matriz APVLNFS:


aadd(aPvlNfs,{ C9_PEDIDO,;
C9_ITEM,;
C9_SEQUEN,;
C9_QTDLIB,;
nPrcVen,;     //Informação indicando o Preço de Venda
C9_PRODUTO,;
SF4->F4_ISS=="S",;
SC9->(RecNo()),;
SC5->(RecNo()),;
SC6->(RecNo()),;
SE4->(RecNo()),;
SB1->(RecNo()),;
SB2->(RecNo()),;
SF4->(RecNo()),;
SB2->B2_LOCAL,;
If(cTabela<>"DAK",0,DAK->(RecNo())),;
C9_QTDLIB2})
*/

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³MaPvlNfs  ³ Autor ³Eduardo Riera          ³ Data ³28.08.1999³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclusao de Nota fiscal de Saida atraves do PV liberado     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpA1: Array com os itens a serem gerados                   ³±±
±±³          ³ExpC2: Serie da Nota Fiscal                                 ³±±
±±³          ³ExpL3: Mostra Lct.Contabil                                  ³±±
±±³          ³ExpL4: Aglutina Lct.Contabil                                ³±±
±±³          ³ExpL5: Contabiliza On-Line                                  ³±±
±±³          ³ExpL6: Contabiliza Custo On-Line                            ³±±
±±³          ³ExpL7: Reajuste de preco na nota fiscal                     ³±±
±±³          ³ExpN8: Tipo de Acrescimo Financeiro                         ³±±
±±³          ³ExpN9: Tipo de Arredondamento                               ³±±
±±³          ³ExpLA: Atualiza Amarracao Cliente x Produto                 ³±±
±±³          ³ExplB: Cupom Fiscal                                         ³±±
±±³          ³ExpCC: Numero do Embarque de Exportacao                     ³±±
±±³          ³ExpBD: Code block para complemento de atualizacao dos titu- ³±±
±±³          ³       los financeiros.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//Function MaPvlNfs(aPvlNfs,cSerieNFS,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,cEmbExp,bAtuFin)