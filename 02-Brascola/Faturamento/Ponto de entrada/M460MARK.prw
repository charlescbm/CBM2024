#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M460MARK บAutor  ณ Marcelo da Cunha   บ Data ณ  21/01/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada para VALIDAR faturamento minimo para os   บฑฑ
ฑฑบ          ณ estados do parametro MV_BLQUF.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460MARK()
*********************
LOCAL lRetu := .T., lValMin := .F., lFCICod := .F.
LOCAL cTitulo, cTexto, cEmail, cQuery, cRegra, nx, nPos
LOCAL cMarca:= ThisMark(), lInverte := ThisInv()
LOCAL nValMin := GetMV("BR_000098"), nSC91 := SC9->(Recno())
LOCAL cBlQuf := GetMV("BR_BLQUF"), aNotas := {}, aParam := Array(8)

//Verifico tipo do pedido e valor e insertos para devolucao
///////////////////////////////////////////////////////////
If (lRetu).and.(__cUserID != "000000") //Administrador
	Pergunte("MT461A",.F.)
	aParam[01] := mv_par05 //Pedido De	
	aParam[02] := mv_par06 //Pedido Ate	
	aParam[03] := mv_par07 //Cliente De	
	aParam[04] := mv_par08 //Cliente Ate	
	aParam[05] := mv_par09 //Loja De	
	aParam[06] := mv_par10 //Loja Ate	
	aParam[07] := mv_par11 //Data De	
	aParam[08] := mv_par12 //Data Ate	
	Pergunte("MT460A",.F.)
	nValTot := 0
	CFD->(dbSetOrder(2)) ; 	SC5->(dbSetOrder(1)) ; 	SC6->(dbSetOrder(1))
	cQuery1 := "SELECT C9.R_E_C_N_O_ MRECSC9 FROM "+RetSqlName("SC9")+" C9 "
	cQuery1 += "WHERE C9.D_E_L_E_T_ = '' AND C9_FILIAL = '"+xFilial("SC9")+"' "
	cQuery1 += "AND C9_NFISCAL = '' AND C9_BLEST = '' AND C9_BLCRED = '' "
	cQuery1 += "AND C9_PEDIDO BETWEEN '"+aParam[01]+"' AND '"+aParam[02]+"' "
	cQuery1 += "AND C9_CLIENTE BETWEEN '"+aParam[03]+"' AND '"+aParam[04]+"' "
	cQuery1 += "AND C9_LOJA BETWEEN '"+aParam[05]+"' AND '"+aParam[06]+"' "
	cQuery1 += "AND C9_DATALIB BETWEEN '"+dtos(aParam[07])+"' AND '"+dtos(aParam[08])+"' "
	If (lInverte)
		cQuery1 += "AND C9_OK <> '"+cMarca+"' "
	Else
		cQuery1 += "AND C9_OK = '"+cMarca+"' "
	Endif
	cQuery1 := ChangeQuery(cQuery1)
	If (Select("MSC9") <> 0)
		dbSelectArea("MSC9")
		dbCloseArea()
	Endif
	TCQuery cQuery1 NEW ALIAS "MSC9"
	dbSelectArea("MSC9")
	While !MSC9->(Eof())
		SC9->(dbGoto(MSC9->(MRECSC9)))
		dbSelectArea("SC9")
		If IsMark("C9_OK",cMarca,lInverte)
			If SC5->(dbSeek(xFilial("SC5")+SC9->C9_pedido)).and.(SC5->C5_tipo == "N")
				cRegra := SC5->C5_tipo+SC5->C5_cliente+SC5->C5_lojacli+SC5->C5_condpag+SC5->C5_reajust+SC5->C5_vend1+SC5->C5_vend2+SC5->C5_vend3+SC5->C5_vend4+SC5->C5_vend5 //Aglutina pedidos
				//cRegra := SC5->C5_num
				nPos := 	aScan(aNotas,{|x| x[1]==cRegra })
				If (nPos == 0)
					aadd(aNotas,{cRegra,SC9->C9_cliente,SC9->C9_loja,0,.F.,{}})
					nPos := Len(aNotas)
				Endif
				aNotas[nPos,4] += SC9->C9_qtdlib*SC9->C9_prcven
				aadd(aNotas[nPos,6],SC9->(Recno()))
			Endif
			If SC6->(dbSeek(xFilial("SC6")+SC9->C9_pedido+SC9->C9_item)).and.Empty(SC6->C6_fcicod).and.((SC6->C6_clasfis>="300".and.SC6->C6_clasfis<="390").or.(SC6->C6_clasfis>="500".and.SC6->C6_clasfis<="590").or.(SC6->C6_clasfis>="800".and.SC6->C6_clasfis<="890"))
				lFCICod := .F.
				CFD->(dbSeek(xFilial("CFD")+SC6->C6_produto,.T.))
				While !CFD->(Eof()).and.(xFilial("CFD") == CFD->CFD_filial).and.(CFD->CFD_cod == SC6->C6_produto)
					If !Empty(CFD->CFD_fcicod)
						lFCICod := .T.
						Exit
					Endif
					CFD->(dbSkip())
				Enddo
				If (!lFCICod)
					Help("",1,"BRASCOLA",,OemToAnsi("Pedido "+SC9->C9_pedido+"/"+SC9->C9_item+" nใo possui c๓digo FCI cadastrado! Favor verificar."),1,0) 
					Return (lRetu := .F.)
				Endif
			Endif
		Endif
		MSC9->(dbSkip())
	Enddo
	SC9->(dbGoto(nSC91))
	///////////////////////////////////////////////////////////
	If (nValMin > 0)
		For nx := 1 to Len(aNotas)
			cQuery := "SELECT A1_EST FROM "+RetSqlName("SA1")+" A1 "
			cQuery += "WHERE A1.D_E_L_E_T_ = '' AND A1_FILIAL = '"+xFilial("SA1")+"' "
			cQuery += "AND A1_COD = '"+aNotas[nx,2]+"' AND A1_LOJA = '"+aNotas[nx,3]+"' "
			cQuery := ChangeQuery(cQuery)
			If (Select("MAR") <> 0)	
				dbSelectArea("MAR")
				dbCloseArea()
			Endif
			TCQuery cQuery NEW ALIAS "MAR"
			dbSelectArea("MAR")
			While !MAR->(Eof())
				If (MAR->A1_est $ cBlQuf).and. (M->C5_condpag != "060") .and. (aNotas[nx,4] > 0).and.(nValMin > aNotas[nx,4])
					Help("",1,"BRASCOLA",,OemToAnsi("Cliente: "+aNotas[nx,2]+"/"+aNotas[nx,3]+". Total da nota ("+Alltrim(Str(aNotas[nx,4],11,2))+") ้ menor que o faturamento minimo ("+Alltrim(Str(nValMin,11,2))+") para os estados "+cBlQuf+"! Favor verificar."),1,0) 
					aNotas[nx,5] := .T.
					lValMin := .T.
				Endif
				MAR->(dbSkip())
			Enddo
		Next nx
		If (Select("MAR") <> 0)	
			dbSelectArea("MAR")
			dbCloseArea()
		Endif
	Endif
	///////////////////////////////////////////////////////////
	If (lValMin)
		WFValMin(@aNotas,nValMin,cBlQuf)
	Endif
	SC9->(dbGoto(nSC91))                                                
	///////////////////////////////////////////////////////////
Endif

Return lRetu

Static Function WFValMin(xNotas,xValMin,xBlQuf)
******************************************
LOCAL cCodProc 	:= "Pedidos", aValMin := {}, nPos1 := 0
LOCAL cDescProc	:= "Pedidos Faturamento Minimo R$"+Alltrim(Str(xValMin,14,2))+" para os estados "+xBlQuf
LOCAL cHTMLModelo	:= "\workflow\wfvalmin.htm"
LOCAL cSubject		:= "WORKFLOW:Pedidos | "+dtoc(MsDate())+" เs "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow - BRASCOLA"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Cria Processo de Workflow ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("ValMin","R$"+Transform(xValMin,"@E 999,999,999.99"))
oProcess:oHtml:ValByName("Estados",xBlQuf)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Verifico notas fiscais    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
SA1->(dbSetOrder(1))
For nx := 1 to Len(xNotas)
	If (xNotas[nx,5])
		For ny := 1 to Len(xNotas[nx,6])
		 	SC9->(dbGoto(xNotas[nx,6,ny]))
		   SA1->(dbseek(xfilial("SA1")+SC9->C9_cliente+SC9->C9_loja,.T.))
			nPos1 := aScan(aValMin,{|x| x[1] == SC9->C9_pedido })
			If (nPos1 == 0)
				aadd(aValMin,{SC9->C9_pedido,0,SC9->C9_cliente+SC9->C9_loja,SA1->A1_nome,SA1->A1_est})
				nPos1 := Len(aValMin)
			Endif
			aValMin[nPos1,2] += SC9->C9_qtdlib*SC9->C9_prcven
			Begin Transaction
			dbSelectArea("SC9")
		 	SC9->(a460Estorna()) //Estorno Liberacao
			End Transaction         
		Next ny
	Endif
Next nx
For nx := 1 to Len(aValMin)		
   AAdd( oProcess:oHtml:ValByName("Item.ped")  , aValMin[nx,1] )      
   AAdd( oProcess:oHtml:ValByName("Item.cli")  , aValMin[nx,3] )
   AAdd( oProcess:oHtml:ValByName("Item.desc") , aValMin[nx,4] )
   AAdd( oProcess:oHtml:ValByName("Item.est")  , aValMin[nx,5] )
   AAdd( oProcess:oHtml:ValByName("Item.val")  , aValMin[nx,2] )
Next nx

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza Processo Workflowณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oProcess:ClientName(cUserName)
oProcess:cTo := "vviana@brascola.com.br;whay@brascola.com.br;gefferson.landarini@brascola.com.br;ilca.figueiredo@brascola.com.br"
//oProcess:cTo := "marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Free()

Return