#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
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
*************************
PRIVATE lAuto := If(lAuto == NIL,{.F.},lAuto)
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do Ambiente      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RPCSetType(3)  // Nao usar Licensa
RpcSetEnv("01","01","","","FAT","",{"SA1","SA3","SB1","SB2","SC5","SC6","SC9","SE4","SF2","SF4"})
U_RFATM03A() //Job para Geracao de Nota Fiscal
//U_RFATM03B() //Job para Eliminar residuos e enviar e-mail com aviso

Return

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
User Function RFATM03A(xPedido)
****************************
LOCAL cPedido := Space(6) , aAreaAtu := GetArea()
LOCAL lValBon := .T., lFCICod := .F.

PRIVATE aPvlNfs := {}, aValBon := {}, aNota := {}  
PRIVATE aPcond  := {}, aPedEst := {}, aPedFCI := {}
PRIVATE cCodCli := "", cEstCli := "  ", cNomCli := "", cNota := " "
PRIVATE cCfBon  := GetMV("BR_CFBON") , cBlQuf  := GetMV("BR_BLQUF")
PRIVATE nValMin := GetMV("BR_VALMIN"), nValBon := GetMV("BR_000098")    

ConOut("----------------------------------------")
ConOut(" Inicio de Faturamento RFATM03 "+Time())
ConOut("----------------------------------------")

lMSErroAuto := .F. ; lMSHelpAuto := .F.

cQueryn := "SELECT C9.R_E_C_N_O_ RECSC9,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO "
cQueryn += "FROM SC9010 C9,SC5010 C5 "
cQueryn += "WHERE C9.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' "
cQueryn += "AND C9.C9_PEDIDO = C5.C5_NUM AND C9.C9_FILIAL = C5.C5_FILIAL "
cQueryn += "AND C9.C9_BLEST = '' AND C9.C9_BLCRED = '' AND C9.C9_FILIAL = '01' "
If (xPedido != Nil).and.!Empty(xPedido)
	cQueryn += "AND C9.C9_PEDIDO = '"+xPedido+"' "
Endif
cQueryn += "AND (C5.C5_CONDPAG IN ('000','001','060') OR "
cQueryn += " (SELECT SUM((C92.C9_QTDLIB*C92.C9_PRCVEN)) "
cQueryn += "  FROM SC9010 C92 WHERE C92.D_E_L_E_T_ <> '*' "
cQueryn += "  AND C92.C9_BLEST = '' AND C92.C9_BLCRED = '' "
cQueryn += "  AND C92.C9_FILIAL = '01' AND C92.C9_NFISCAL = '' "
cQueryn += "  AND C92.C9_PEDIDO = C9.C9_PEDIDO "
cQueryn += "  GROUP BY C92.C9_PEDIDO) >= "+Alltrim(Str(nValMin))+") "
cQueryn += "GROUP BY C9.R_E_C_N_O_,C9_PEDIDO,C9_ITEM,C9_SEQUEN, C9_PRODUTO "
cQueryn += "ORDER BY C9.C9_PEDIDO, C9.C9_ITEM "
If Select("TRBN") > 0 
	TRBN->(dbCloseArea())        
EndIf
TCQUERY cQueryn NEW ALIAS "TRBN"

dbSelectArea("TRBN")
dbGotop() 

//MemoWrite("\QUERYSYS\RFATM03.SQL",cQuery)
//dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)

While !TRBN->(Eof()) //.and. dDataBase==DataValida(dDataBase) //.and.; //Filtra faturamentos de feriados/sabados/domingos
		//dDataBase<=GetMV("BR_DATAFAT") //Impede o fat automatico quando o parametro estiver trancado
	
	nOpc := 3
	aPvlNfs := {}	
	cPedido := TRBN->C9_PEDIDO   
	_vltot  := 0
	cFilOld:=cFilAnt
	cEmpOld:=cEmpAnt // Salva a filial atu
	cCodCli := "" ; cEstCli := "  " ; cNomCli := "" ; cTipoPed := ""
	
	While !TRBN->(Eof()) .And. TRBN->C9_PEDIDO == cPedido
         

		dbSelectArea("SC9")
		dbSetOrder(1)
   	dbGoto(TRBN->RECSC9)
		//SC9->(DbSeek(xFilial("SC9")+TRBN->C9_PEDIDO+TRBN->C9_ITEM+TRBN->C9_SEQUEN+TRBN->C9_PRODUTO) )
	
		cNumPed  := SC9->C9_PEDIDO
		cItemPed := SC9->C9_ITEM
	
		//	SC9->(DbSetOrder(1))
		//	SC9->(DbSeek(xFilial("SC9")+_cNumPed+"01") )               //FILIAL+NUMERO+ITEM
	
		SC5->(DbSetOrder(1))
		SC5->(DbSeek(xFilial("SC5")+cNumPed) )                       //FILIAL+NUMERO
		cTipoPed := SC5->C5_tipo
	
		SC6->(DbSetOrder(1))
		SC6->(DbSeek(xFilial("SC6")+cNumPed+cItemPed) )              //FILIAL+NUMERO+ITEM
	
		SE4->(DbSetOrder(1))
		SE4->(DbSeek(xFilial("SE4")+SC5->C5_CONDPAG) )               //FILIAL+NUMERO+ITEM+PRODUTO
	
		SB1->(DbSetOrder(1))
		SB1->(DbSeek(xFilial("SB1")+SC9->C9_PRODUTO) )               //FILIAL+PRODUTO
	
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(xFilial("SB2")+SC9->C9_PRODUTO+SC9->C9_LOCAL) )         //FILIAL+PRODUTO+LOCAL    
		
		SA1->(DbSetOrder(1))
		SA1->(DbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI) )       //FILIAL+PRODUTO+LOCAL
		cCodCli := SC5->C5_cliente+SC5->C5_lojacli
		cNomCli := SA1->A1_nome
		cEstCli := SA1->A1_est
	
		SF4->(DbSetOrder(1))
		SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES) )                            //FILIAL+CODIGO
	
		If !Empty(SC5->C5_TABELA)
			cTabela := "DAK"
			DAK->(DbSetOrder(1))
			DAK->(DbSeek(xFilial("DAK")+SC5->C5_TABELA))                       //FILIAL+CODIGO
		Else
			cTabela := ""
		EndIf

		//23/01/13 - Marcelo - Validacao para nao faturar bonificacao
		/////////////////////////////////////////////////////////////
		If !Empty(cCfBon).and.(SC6->C6_cf $ cCfBon).and.Empty(SC6->C6_x_regra)
			aadd(aPedEst,{SC9->C9_pedido,SC9->C9_item})
			dbSelectArea("TRBN")
			TRBN->(dbSkip())
			Loop
		Endif

		//19/02/14 - Marcelo - Validacao para nao faturar pedidos sem codigo FCI
		////////////////////////////////////////////////////////////////////////
		If Empty(SC6->C6_fcicod) .And. ((SC6->C6_clasfis>="300".and.SC6->C6_clasfis<="390").or.(SC6->C6_clasfis>="500".and.SC6->C6_clasfis<="590").or.(SC6->C6_clasfis>="800".and.SC6->C6_clasfis<="890"))
			lFCICod := .F.
			CFD->(dbSetOrder(2))
			CFD->(dbSeek(xFilial("CFD")+SC6->C6_produto,.T.))
			While !CFD->(Eof()).and.(xFilial("CFD") == CFD->CFD_filial).and.(CFD->CFD_cod == SC6->C6_produto)
				If !Empty(CFD->CFD_fcicod)
					lFCICod := .T.
					Exit
				Endif
				CFD->(dbSkip())
			Enddo
			If (!lFCICod)
				aadd(aPedFCI,{SC9->C9_pedido,SC9->C9_item,cCodCli,cNomCli,cEstCli,SC9->C9_qtdlib*SC9->C9_prcven})
				dbSelectArea("TRBN")
				TRBN->(dbSkip())
				Loop
			Endif
		Endif

		Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
							SC9->C9_ITEM,;
							SC9->C9_SEQUEN,;
							SC9->C9_QTDLIB,;
							SC6->C6_PRCVEN,;     //Informação indicando o Preço de Venda
	  						SC9->C9_PRODUTO,;
							.F.,;
	  						SC9->(RecNo()),;
	  						SC5->(RecNo()),;
	  						SC6->(RecNo()),;
							SE4->(RecNo()),;
							SB1->(RecNo()),;
							SB2->(RecNo()),;
							SF4->(RecNo()),;
							SB2->B2_LOCAL,;
							If(cTabela<>"DAK",0,DAK->(RecNo())),SC9->C9_QTDLIB2})
	                         
	    _vltot+=SC9->C9_QTDLIB*SC9->C9_PRCVEN
		_COND:=SC5->C5_CONDPAG
		dbSelectArea("TRBN")
		dbSkip()
	EndDo

	//28/01/13 - Marcelo - Validacao para nao faturar valor minimo
	//////////////////////////////////////////////////////////////
	lValBon := .F.
	If (cTipoPed == "N").and.(cEstCli $ cBlQuf).and.(_vltot > 0).and.(nValBon > _vltot).and. (_COND != "060")
		nPos1 := aScan(aValBon,{|x| x[1] == cPedido })
		If (nPos1 == 0)
			aadd(aValBon,{cPedido,0,cCodCli,cNomCli,cEstCli})
			nPos1 := Len(aValBon)
		Endif
		aValBon[nPos1,2] += _vltot
		lValBon := .T.
		For nx := 1 to Len(aPvlNfs)
		 	SC9->(dbGoto(aPvlNfs[nx,8]))
			Begin Transaction
			dbSelectArea("SC9")
		 	SC9->(a460Estorna()) //Estorno Liberacao
			End Transaction
      Next nx		
	Endif
	If (!lValBon)
		cserie := "7  " 
   	//	If 	_COND <> '000' .and. 	_COND  <> '001'  .AND. _vltot > 0
	   	aParc :=  Condicao(_vltot,_COND,0)
	  	//ENDIF
	  	If (aParc[1,2] > nValMin).or.(_COND $ "000/001/060")
			If Len(aPvlNfs) > 0
				Pergunte("MT460A",.F.)
				//cNota := MaPvlNfs(aPvlNfs,"   ", .F., .F., .T., .T., .F., 0, 0, .T., .F.)
				//cNota := MaPvlNfs(aPvlNfs,"1  ", .F., .F., .T., .T., .F., 0, 0, .T., .F.)
				//cNota := MaPvlNfs(aPvlNfs,"7  "    , .F.      , .F.     , .F.      , .F.     , .F.     , 0      , 0          , .F.   , .F.)   
				mv_par17 := 1 //Gerar Titulo
				mv_par18 := 1 //Gerar Guia 
				cNota := MaPvlNfs(aPvlNfs,cserie, .F., .F., .f., .f., .F., 0, 0, .T., .F.)
	  			//Function MaPvlNfs(aPvlNfs,cSerieNFS,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajuste,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,cEmbExp,bAtuFin)   
		    	//AADD(aList,{QUERY3->B8_PRODUTO,QUERY3->B8_LOTECTL,cSaldo,cVenc,QUERY3->B8_NUMLOTE} )
	   	 	AADD(aNota,{cNota})
	    		//aadd(aNota,cNota)
				dbSelectArea("TRBN")
			EndIf	
	  	Else
			AADD(aPcond,  { cNumPed, cItemPed })
			aadd(aPedEst, { cNumPed, cNumPed  })
 		Endif	
	 Endif
	
	cFilAnt:=cFilOld   
	cEmpAnt:=cEmpOld
		
	dbSelectArea("TRBN")
	
EndDo 

//DBCLOSEAREA("TRBA")
//DBCLOSEAREA("TRBC")	

//StartJob("NSaida", GetEnvServer(), .F.)
//NSaida()

//Static function NSaida()


//MsgRun("Enviando workflow...","Relacao de solicitacao de Compra nao atendida",{|| u_EMAILSOL(_USER,_C1NUM,nVlrMaxAprov,_VALOR,_CCUSTO,_NUMC8)})
                
//aNota := {{"000034474"}}              
if len(aNota) > 0
	U_EMAILNOT(aNota)
endif
             

if len(aPcond) > 0
	U_EMAICOND(aPcond)
endif

if (len(aValBon) > 0)
	WFValBon(@aValBon,nValBon,cBlQuf)
endif

if (len(aPedFCI) > 0)
	WFPedFCI(@aPedFCI)
endif

//23/01/13 - Marcelo - Estorno liberacao
////////////////////////////////////////
SC9->(dbSetOrder(1))
For nx := 1 to Len(aPedEst)
	aRecEst := {}
	SC9->(dbSeek(xFilial("SC9")+aPedEst[nx,1]+aPedEst[nx,2],.T.))
	While !SC9->(Eof()).and.(xFilial("SC9") == SC9->C9_filial).and.(SC9->C9_pedido+SC9->C9_item == aPedEst[nx,1]+aPedEst[nx,2])
		aadd(aRecEst,SC9->(Recno()))
		SC9->(dbSkip())
	Enddo
	For ny := 1 to Len(aRecEst)
	 	SC9->(dbGoto(aRecEst[ny]))
	 	Begin Transaction
		dbSelectArea("SC9")
	 	SC9->(a460Estorna()) //Estorno Liberacao
		End Transaction  
	Next ny
Next nx

//19/02/14 - Marcelo - Estorno itens sem FCI
////////////////////////////////////////////
SC9->(dbSetOrder(1))
For nx := 1 to Len(aPedFCI)
	aRecEst := {}
	SC9->(dbSeek(xFilial("SC9")+aPedFCI[nx,1]+aPedFCI[nx,2],.T.))
	While !SC9->(Eof()).and.(xFilial("SC9") == SC9->C9_filial).and.(SC9->C9_pedido+SC9->C9_item == aPedFCI[nx,1]+aPedFCI[nx,2])
		aadd(aRecEst,SC9->(Recno()))
		SC9->(dbSkip())
	Enddo
	For ny := 1 to Len(aRecEst)			 	
	 	SC9->(dbGoto(aRecEst[ny]))
	 	Begin Transaction
		dbSelectArea("SC9")
	 	SC9->(a460Estorna()) //Estorno Liberacao
		End Transaction  
	Next ny
Next nx

 /*
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
     

Restarea(aAreaAtu)	
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
User FUNCTION EMAILNOT(aNota)
**************************
Local lRet
Local nTotal	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametros  WorkFlow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cCodProc 	:= "Notas Fiscais"
Local cDescProc	:= "Notas Fiscais"
Local cHTMLModelo	:= "\workflow\wfrelnot.htm"

Local cDestinat1	:= GetMv("BR_000096")
Local cSubject		:= "WORKFLOW:Notas Fiscais | "+dtoc(MsDate())+" as "+SubStr(Time(),1,5)
Local cFromName	:= "Workflow -  BRASCOLA"
lOCAL _TOTAL      := 0


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Data",		dDataBase)
oProcess:oHtml:ValByName("Hora",		ALLTRIM(TIME()) )
FOR i:=1 to LEN(aNota)
	cQuery := " SELECT F2_DOC,F2_SERIE,F2_CLIENTE ,F2_LOJA,F2_VALBRUT,F2_DUPL,F2_COND,(SELECT COUNT(*) FROM SF2010 F2 WHERE F2.F2_CLIENTE = SF2.F2_CLIENTE 
	cQuery += " AND F2_FILIAL = SF2.F2_FILIAL) SIT FROM SF2010 SF2 WHERE F2_DOC = '"+aNota[i,1]+"' " 
	If Select("TRAB2") > 0 
		TRAB2->(dbCloseArea())
	EndIf      
	TCQUERY cQuery NEW ALIAS "TRAB2"
	SE4->(dbSetOrder(1))
	dbSelectArea("TRAB2")
	dbGotop() 
   AAdd( oProcess:oHtml:ValByName( "Item.nota" 	), TRAB2->F2_DOC  )      
   AAdd( oProcess:oHtml:ValByName( "Item.Duplic" ), TRAB2->F2_DUPL ) 
   AAdd( oProcess:oHtml:ValByName( "Item.cli"	), TRAB2->F2_CLIENTE)
   AAdd( oProcess:oHtml:ValByName( "Item.desc" 	), Posicione("SA1",1,XFILIAL("SA1")+TRAB2->F2_CLIENTE,"A1_NOME"))
   AAdd( oProcess:oHtml:ValByName( "Item.vlr"	), TRAB2->F2_VALBRUT)
   If SE4->(dbSeek(xFilial("SE4")+TRAB2->F2_COND)).and.(Alltrim(SE4->E4_cond) $ "0/00/1").and.(SE4->E4_tipo == "1") //A Vista
	   AAdd( oProcess:oHtml:ValByName( "Item.sit" 	), "A Vista" )
	Else
  		AAdd( oProcess:oHtml:ValByName( "Item.sit" 	), IIF(TRAB2->SIT == 1  , "Prim.Nota",TRAB2->SIT ) )
 	Endif
	_TOTAL+= TRAB2->F2_VALBRUT
NEXT I
oProcess:oHtml:ValByName("Total",_TOTAL )
oProcess:ClientName(cUserName)
cDestinat1 := u_BXFormatEmail(cDestinat1)
oProcess:cTo := cDestinat1
oProcess:cSubject := cSubject
oProcess:CFROMNAME:= cFromName
oProcess:Start()
oProcess:Finish()

ConOut("----------------------------------------")
ConOut(" FIM Faturamento RFATM03 "+Time())
ConOut("----------------------------------------")

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFATM03   ºAutor  ³Microsiga           º Data ³  11/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function EmaiCond(aPcond)
***************************
LOCAL lRet, nTotal := 0
LOCAL cCodProc 	:= "Pedidos"
LOCAL cDescProc	:= "Pedidos duplic menor que 200"
LOCAL cHTMLModelo	:= "\workflow\wfrelped.htm"
LOCAL cDestinat1 	:= GetMv("BR_000097")
LOCAL cSubject		:= "WORKFLOW:Pedidos | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
FOR i:=1 to LEN(aPcond)
   SC5->(dbSetOrder(1))
   SC5->(dbseek(xFilial("SC5")+aPcond[i,1]))
   AAdd( oProcess:oHtml:ValByName( "Item.ped"  ), aPcond[i,1] )      
   AAdd( oProcess:oHtml:ValByName( "Item.item" ), aPcond[i,2] ) 
   AAdd( oProcess:oHtml:ValByName( "Item.cli"  ), SC5->C5_CLIENTE)
   AAdd( oProcess:oHtml:ValByName( "Item.desc" ), Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE,"A1_NOME") )
   AAdd( oProcess:oHtml:ValByName( "Item.cond" ), SC5->C5_CONDPAG )
NEXT
oProcess:ClientName(cUserName)
cDestinat1 := u_BXFormatEmail(cDestinat1)
oProcess:cTo :=  cDestinat1
oProcess:cCC := "charlesm@brascola.com.br;kcarbonera@brascola.com.br"
oProcess:cSubject  := cSubject
oProcess:cFromName := cFromName
oProcess:Start()
//oProcess:Free()
oProcess:Finish()

Return

Static Function WFValBon(xPedidos,xValBon,xBlQuf)
********************************************
LOCAL cCodProc 	:= "Pedidos"
LOCAL cDescProc	:= "Pedidos Faturamento Minimo R$"+Alltrim(Str(xValBon,14,2))+" para os estados "+xBlQuf
LOCAL cHTMLModelo	:= "\workflow\wfvalmin.htm"
LOCAL cSubject		:= "WORKFLOW:Pedidos | "+dtoc(MsDate())+" às "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("ValMin","R$"+Transform(xValBon,"@E 999,999,999.99"))
oProcess:oHtml:ValByName("Estados",xBlQuf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to Len(xPedidos)
   AAdd( oProcess:oHtml:ValByName("Item.ped")  , xPedidos[nx,1] )      
   AAdd( oProcess:oHtml:ValByName("Item.cli")  , xPedidos[nx,3] )
   AAdd( oProcess:oHtml:ValByName("Item.desc") , xPedidos[nx,4] )
   AAdd( oProcess:oHtml:ValByName("Item.est")  , xPedidos[nx,5] )
   AAdd( oProcess:oHtml:ValByName("Item.val")  , xPedidos[nx,2] )
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
cEmail := Alltrim(SuperGetMV("BR_FATMINI",.F.,"")) //Lista de E-mails
oProcess:ClientName(cUserName)
cEmail := u_BXFormatEmail(cEmail) //Adiciona o Dominio na lista de e-mails
oProcess:cTo := cEmail
//03/09/2013: Marlon - retirei o e-mail da Mirian da linha abaixo conforme chamado 4085
//25/09/2013: Marlon - Adicionado o e-mail kelen.antonello@brascola.com.br  conforme chamado 4440
//oProcess:cTo := "kcarbonera@brascola.com.br;abner.santana@brascola.com.br;whay@brascola.com.br;gefferson.landarini@brascola.com.br;leticia.souza@brascola.com.br;ilca.figueiredo@brascola.com.br;kelen.antonello@brascola.com.br"
//oProcess:cTo := "marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
//oProcess:Free()
oProcess:Finish()

Return

Static Function WFPedFCI(xPedidos)
*******************************
LOCAL cCodProc 	:= "Pedidos"
LOCAL cDescProc	:= "Pedidos sem Código FCI cadastrado"
LOCAL cHTMLModelo	:= "\workflow\wfpedfci.htm"
LOCAL cSubject		:= "WORKFLOW:Pedidos | "+dtoc(MsDate())+" às "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow -  BRASCOLA"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nx := 1 to Len(xPedidos)
   AAdd( oProcess:oHtml:ValByName("Item.ped")  , xPedidos[nx,1]+"/"+xPedidos[nx,2] )
   AAdd( oProcess:oHtml:ValByName("Item.cli")  , xPedidos[nx,3] )
   AAdd( oProcess:oHtml:ValByName("Item.desc") , xPedidos[nx,4] )
   AAdd( oProcess:oHtml:ValByName("Item.est")  , xPedidos[nx,5] )
   AAdd( oProcess:oHtml:ValByName("Item.val")  , xPedidos[nx,6] )
Next nx

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
cEmail := Alltrim(SuperGetMV("BR_WPEDFCI",.F.,"")) //Lista de E-mails
oProcess:ClientName(cUserName)
cEmail := u_BXFormatEmail(cEmail) //Adiciona o Dominio na lista de e-mails
oProcess:cTo := cEmail
oProcess:cCC := "charlesm@brascola.com.br;marcelo@goldenview.com.br
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Finish()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATM03B ºAutor  ³ Marcelo da Cunha   º Data ³  03/04/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Job para Eliminar residuos e enviar e-mail com aviso       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/    
/*
User Function RFATM03B()
***********************
PRIVATE cQueryn := "", aResumo := {}, aInfo := {0,0}
PRIVATE nValMin := GetMV("BR_VALMIN") //Valor Minimo
                  
//Se nao for data valida, nao processa
//////////////////////////////////////                    
If (dDataBase != DataValida(dDataBase))
	Return
Endif
                     
//Monto Query para enviar ao banco de dados
///////////////////////////////////////////
cQueryn := 	" SELECT C9.R_E_C_N_O_ RECSC9,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO "+;
				" FROM SC9010 C9 WHERE C9.D_E_L_E_T_ <> '*' "+;
				" AND C9.C9_BLEST = ''    "+;
				" AND C9.C9_BLCRED = ''   "+;
				" AND C9.C9_FILIAL = '01' "+;  
				" AND ( SELECT sum((C92.C9_QTDLIB*C92.C9_PRCVEN)) "+;  
				"			FROM SC9010 C92 "+;  	
				"			WHERE C92.D_E_L_E_T_ <> '*' "+;  
				"			AND C92.C9_BLEST = '' "+;   
				"			AND C92.C9_BLCRED = '' "+; 
				"			AND C92.C9_FILIAL = '01' "+;  	 						
				"			AND C92.C9_NFISCAL = '' "+; 
				"			AND C92.C9_PEDIDO =C9.C9_PEDIDO "+; 
				"		GROUP BY C92.C9_PEDIDO) < "+Alltrim(Str(nValMin))+" "+;           
				" GROUP BY C9.R_E_C_N_O_,C9_PEDIDO,C9_ITEM,C9_SEQUEN,C9_PRODUTO "+; 
				" ORDER BY C9.C9_PEDIDO, C9.C9_ITEM "  
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif
TCQuery cQueryn NEW ALIAS "MAR"

SC5->(dbSetOrder(1))
SC6->(dbSetOrder(1))
SC9->(dbSetOrder(1))
dbSelectArea("MAR")
While !MAR->(Eof())
                                     
	//Estorno liberacao para devolver saldo para o estoque
	//////////////////////////////////////////////////////
 	SC9->(dbGoto(MAR->RECSC9))
 	aInfo[1] := SC9->C9_qtdlib
 	aInfo[2] := (SC9->C9_qtdlib*SC9->C9_prcven)
 	Begin Transaction
		dbSelectArea("SC9")
	 	SC9->(a460Estorna()) //Estorno Liberacao
	End Transaction  
	
	//Eliminar pedido/item por residuo
	//////////////////////////////////
	SC5->(dbSeek(xFilial("SC5")+MAR->C9_pedido,.T.))
	If SC6->(dbSeek(xFilial("SC6")+MAR->C9_pedido+MAR->C9_item))
		If Empty(SC5->C5_pedexp).and.	Empty(SC6->C6_reserva).and.!(SC6->C6_blq$"R #S ")
			MaResDoFat(,.T.,.T.)
			WFAvResRep(@aInfo,@aResumo,nValMin) //Enviar aviso para representante sobre pedido eliminado
		Endif
	Endif
	                                                        
	MAR->(dbSkip())
Enddo
If (Select("MAR") > 0)
	dbSelectArea("MAR")
	MAR->(dbCloseArea())        
Endif

//Enviar aviso para setor de vendas com resumo
//////////////////////////////////////////////
If (Len(aResumo) > 0)
	WFAvResRes(@aResumo,nValMin)
Endif

Return

Static Function WFAvResRep(xInfo,xResumo,xValMin)
*******************************************
LOCAL cCodProc 	:= "Pedido Eliminado por Residuo", nPos1 := 0, cEmail1 := ""
LOCAL cDescProc	:= "Item "+MAR->C9_item+" do Pedido "+MAR->C9_pedido+" foi Eliminado por Residuo"
LOCAL cHTMLModelo	:= "\workflow\wfavresrep.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Item "+MAR->C9_item+" do Pedido "+MAR->C9_pedido+" foi Eliminado por Residuo | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Data",	dDataBase)
oProcess:oHtml:ValByName("Hora",	Alltrim(Time()))
oProcess:oHtml:ValByName("Motivo","Item eliminado por resíduo por não atingir o valor mínimo para faturamento de R$"+Transform(xValMin,"@E 999,999,999.99"))
cEmail1 := ""
SA3->(dbSetOrder(1))
If SA3->(dbSeek(xFilial("SA3")+SC5->C5_vend1))
	cEmail1 := Alltrim(SA3->A3_email)
	oProcess:oHtml:ValByName("Vend",Alltrim(SA3->A3_cod)+"-"+Alltrim(SA3->A3_nome))
Else
	oProcess:oHtml:ValByName("Vend","&nbsp;")
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(xResumo,Array(5))
nPos1 := Len(xResumo)
xResumo[nPos1,1] := MAR->C9_pedido+"/"+MAR->C9_item
xResumo[nPos1,2] := Substr(Posicione("SA1",1,xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,"A1_NOME"),1,20)
xResumo[nPos1,3] := Alltrim(SC6->C6_produto)+" - "+Alltrim(Posicione("SB1",1,xFilial("SB1")+SC6->C6_produto,"B1_DESC"))
xResumo[nPos1,4] := xInfo[1]
xResumo[nPos1,5] := xInfo[2]
AAdd( oProcess:oHtml:ValByName("Item.ped") , xResumo[nPos1,1] )
AAdd( oProcess:oHtml:ValByName("Item.cli") , xResumo[nPos1,2] )
AAdd( oProcess:oHtml:ValByName("Item.pro") , xResumo[nPos1,3] )
AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(xResumo[nPos1,4],PesqPict("SC6","C6_QTDVEN")) )
AAdd( oProcess:oHtml:ValByName("Item.val") , Transform(xResumo[nPos1,5],PesqPict("SC6","C6_VALOR")) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
cEmail1 := u_BXFormatEmail(cEmail1)
If !Empty(cEmail1)
	oProcess:cTo := cEmail1
Else
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return

Static Function WFAvResRes(xResumo,xValMin)
**************************************
LOCAL cCodProc 	:= "Resumo Pedidos Eliminados por Residuo", nPos1 := 0
LOCAL cDescProc	:= "Resumo Pedidos Eliminados por Residuo"
LOCAL cHTMLModelo	:= "\workflow\wfavresres.htm", cFromName	:= "Workflow -  BRASCOLA"
LOCAL cSubject		:= "WORKFLOW:Resumo dos Pedidos Eliminados por Residuo | "+dtoc(MsDate())+" as "+Substr(Time(),1,5)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Processo de Workflow ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Data",	dDataBase)
oProcess:oHtml:ValByName("Hora",	Alltrim(Time()))
oProcess:oHtml:ValByName("ValMin","R$"+Transform(xValMin,"@E 999,999,999.99"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico Pedidos          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For nPos1 := 1 to Len(xResumo)
	AAdd( oProcess:oHtml:ValByName("Item.ped") , xResumo[nPos1,1] )
	AAdd( oProcess:oHtml:ValByName("Item.cli") , xResumo[nPos1,2] )
	AAdd( oProcess:oHtml:ValByName("Item.pro") , xResumo[nPos1,3] )
	AAdd( oProcess:oHtml:ValByName("Item.qtd") , Transform(xResumo[nPos1,4],PesqPict("SC6","C6_QTDVEN")) )
	AAdd( oProcess:oHtml:ValByName("Item.val") , Transform(xResumo[nPos1,5],PesqPict("SC6","C6_VALOR")) )
Next nPos1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza Processo Workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oProcess:ClientName(cUserName)
cEmail1 := Alltrim(GetMV("BR_000097"))
cEmail1 := u_BXFormatEmail(cEmail1)
oProcess:cTo := cEmail1
If Empty(oProcess:cTo)
	oProcess:cTo := "charlesm@brascola.com.br"
Endif
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return
*/