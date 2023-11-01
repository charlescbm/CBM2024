#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

//DESENVOLVIDO POR INOVEN


User Function MTA410()
**********************
Local cCli,cLoja,cFat,LRet,cTransp,cProd,cTipo
Local nPos1,nPos2,nPos3,nQuantVen,nQuantLib
Local nT
//Local nTotPed := 0, dValida := CtoD(""), nPercent := 0

aColsAux := {}
cCli	:= cLoja := cFat  := LRet		:= cTransp	:= cProd :=	cTipo := ""
nPos1	:= nPos2 := nPos3 := nQuantVen	:= nQuantLib:= 0
LRet    := lRet2 := .T.


_tipcond:=POSICIONE("SE4",1,XFILIAL("SE4")+M->C5_CONDPAG,"E4_TIPO")
If  ALLTRIM(_tipcond) == '9'

	IF EMPTY(M->C5_PARC1) .OR. EMPTY(M->C5_XDIAS1) .OR. EMPTY(M->C5_DATA1) 
   	MSGBOX("Não é permitido digitar pedidos com codição negociada sem parcela e vencimento")
	lRet := .F.     
	ENdif
EndIf


lDEntrgDif:= .f.
lcomisz:=0
nHumOk:=0
nPosEnt   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ENTREG" })					
nPoscom   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_COMIS1" })					
nPosCf    := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_CF" })	

nPosVlPP  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR" })
nPosQtd   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })
nPosVlPL  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_XTABPRC" })

Private nTotalPP := 0
Private nTotalPL := 0

	For nT := 1 To Len(aCols)
		If !aCols[nT,Len(aHeader)+1]
			
			If nHumOk==0
				IF !EMPTY(M->C5_FECENT)
	  		
					dPrimEntrg:= M->C5_FECENT
				ELSE                               
				
					dPrimEntrg:= aCols[nT][nPosEnt]
				ENDIF
				nHumOk++
			EndIf	
			
			If dPrimEntrg<>aCols[nT][nPosEnt]  
			
			   IF !EMPTY(M->C5_FECENT)
	  				aCols[nT][nPosEnt] :=M->C5_FECENT 
			   ELSE 
					lDEntrgDif:= .t.
				ENDIF
						
			EndIf	
		
		   IF ALLTRIM(aCols[nT][nPosCf]) $  ('5102/6403/5403/5405/6405/5404/5401/6401/6102/6108/6404/6405/5108') .and. M->C5_TIPO == 'N' .and. empty(aCols[nT][nPoscom])
			 	lcomisz:= .t.
		   endif

		   nTotalPP += aCols[nT][nPosVlPP]
		   nTotalPL += (aCols[nT][nPosQtd] * aCols[nT][nPosVlPL])
		EndIf
	Next

	
	If lDEntrgDif 
		Alert("Existe diferenças entre as Datas de Entrega nos itens do pedido. Verifique.")
		lRet:= .f.
	EndIf       
	
	// Alterado regra para incluir validação do usuário com permissao para incluir pedido com 0% comissao - CBM- 20/02/2019
	If lcomisz .AND. (!Alltrim(__cUserID) $ SuperGetMV("TG_USRCOMI",.F.,""))
		Alert("Usuário sem permissao para incluir pedidos com %de comissao zerados. Verifique TG_USRCOMI.")
		lRet:= .f.
	EndIf

	//Simulação de frete e gravacao do valor previsto
	If !IsInCallStack("U_IVENA020") .and. !empty(M->C5_TPFRETE) .and. M->C5_TPFRETE=="C" .and. M->C5_TIPO == 'N'	//Apenas frete CIF
	
		_nPrvFrt := 0
		xRet := U_IVENA080(,,.F.,@_nPrvFrt)
		if !empty(xRet)
			M->C5_TRANSP := xRet
			M->C5_ZPRVFRE := _nPrvFrt
		endif

	EndIf
	//Fim

	if lRet .and. !(!INCLUI .and. !ALTERA) .and. M->C5_TIPO == 'N'
		lRet := goCheckMG()	//Fazo calculo da margem
	endif
 	    	                                 
Return(lRet)

Static Function goCheckMG()
Local lRetM := .T.
Local _x
Private aTitles := {}
Private aCorpo  := {}

cSayHTML := '<table style="font-size:12px;font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;border-collapse: collapse;border-spacing: 0;width: 100%;">'+;
			'<tbody><tr><th style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;color:white;">Itens</th>'+;
			'<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">Valor</th>'+;
			'<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">&nbsp;</th>'+;
			'<th style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;color:white;">Itens</th>'+;
			'<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">Valor</th>'+;
			'<th style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;color:white;">&nbsp;</th></tr>'

//nFrete		:= iif(!empty(M->C5_FRETE), M->C5_FRETE, 0)
nFrete		:= M->C5_ZPRVFRE
nDespesa	:= M->C5_DESPESA
nDescont    := M->C5_DESCONT

nPosItem  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ITEM" })
nPosProd  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRODUTO" })
nPosNome  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_DESCRI" })
nPosLoca  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_LOCAL" })
nPosQtde  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_QTDVEN" })
nPosPrcP  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_PRCVEN" })
nPosPrcL  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_XTABPRC" })
nPosVlr   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_VALOR" })
nPosTES   := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_TES" })
nPosZICM  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ZVALICM" })
nPosCom1  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ZVCOMIS" })
nPosCom2  := Ascan(aHeader,{|m| Alltrim(m[2]) == "C6_ZVCOMSS" })

	For _x := 1 To Len(aCols)
		If !aCols[_x,Len(aHeader)+1]

			MaFisIni(M->C5_CLIENTE,;
						M->C5_LOJACLI,;      // 2-Loja do Cliente/Fornecedor
						"C",;         // 3-C:Cliente , F:Fornecedor
						'N',;         // 4-Tipo da NF
						M->C5_TIPOCLI,;   // 5-Tipo do Cliente/Fornecedor
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						"MATA461",;
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						Nil,;
						Nil,,,Nil,Nil,Nil,Nil,,Nil)

			cCorpo	 := cSayHTML

			IF SELECT("QRYCU") <> 0 //Gilmar 23/03/2016 - Tratativa dos Custos BLOG
				QRYCU->(DBCLOSEAREA())
			ENDIF                                                                     
			
			BeginSQL Alias "QRYCU"	                    
			
			SELECT
				B2_CM1 CUSUNIF
			FROM 
				%Table:SB2% SB2
			WHERE
				SB2.%NotDel%
				AND B2_FILIAL = %Exp:cFilAnt%//'0401'
				AND B2_COD    = %Exp:aCols[_x][nPosProd]%
				AND B2_LOCAL  = %Exp:aCols[_x][nPosLoca]%
			
			EndSql						
			nCusto := QRYCU->CUSUNIF

			nFreteIpP := 0
			nFreteIpL := 0
			nDespIp := 0
			nDespIL := 0
			nDescpP := 0
			nDescpL := 0
			nFrtDspP := 0
			nFrtDspL := 0

			If (nFrete) <> 0
				nFreteIpP := Round((nFrete) *  (aCols[_x][nPosVlr] / nTotalPP),2) //rateio frete para impostos
				//nFreteIpL := Round((nFrete) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPL),2) //rateio frete para impostos
				nFreteIpL := Round((nFrete) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPP),2) //rateio frete para impostos
			EndIf

			If (nDespesa) <> 0
				nDespIp := Round((nDespesa) *  (aCols[_x][nPosVlr] / nTotalPP),2) //rateio frete para impostos       
				//nDespIL := Round((nDespesa) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPL),2) //rateio frete para impostos       
				nDespIL := Round((nDespesa) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPP),2) //rateio frete para impostos       
			EndIf

			If (nDescont) <> 0
			   nDescpP := Round((nDescont) *  (aCols[_x][nPosVlr] / nTotalPP),2) //rateio frete para impostos
			   nDescpL := Round((nDescont) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPL),2) //rateio frete para impostos
			EndIf

			//Rateio Frete e Despesas
			If (nFrete + nDespesa) <> 0
				nFrtDspP := Round((nFrete + nDespesa) *  (aCols[_x][nPosVlr] / nTotalPP),2) //rateio frete e despesa
				//nFrtDspL := Round((nFrete + nDespesa) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPL),2) //rateio frete e despesa
				nFrtDspL := Round((nFrete + nDespesa) *  ((aCols[_x][nPosQtde] * aCols[_x][nPosPrcL]) / nTotalPP),2) //rateio frete e despesa
			EndIf

			//IMPOSTOS - Preco Praticado
			MaFisAdd( aCols[_x][nPosProd],;
						aCols[_x][nPosTES],;
						aCols[_x][nPosQtde],;
						aCols[_x][nPosPrcP],;
						nDescpP,;
						"",;
						"",;
						0,;
						nFreteIpP,;
						nDespIp,;
						0,;
						0,;
						aCols[_x][nPosVlr],;
						0,;
						0,;
						0)

   			nValIcm  := MaFisRet(1,"IT_VALICM")
			nValIpi  := MaFisRet(1,"IT_VALIPI")
			nValCof  := MaFisRet(1,"IT_VALCF2")
			nValPis  := MaFisRet(1,"IT_VALPS2")
			nIcmsRet := MaFisRet(1,"IT_VALSOL")
			nBaseICM := MaFisRet(1,"IT_BASEICM")
			nIcmComp := MaFisRet(1,"IT_VALCMP")
			nDifal   := MaFisRet(1,"IT_DIFAL")
			nFECP    := MaFisRet(1,"IT_VFCPDIF")

			if !empty(aCols[_x][nPosZICM]) 
				nValIcm := aCols[_x][nPosZICM]
			endif
			nComis := aCols[_x][nPosCom1] + aCols[_x][nPosCom2]

			nImpTot := (nValIcm+nValPis+nValCof+nIcmComp+nDifal+nFECP+nComis)
			//if nFreteIpP > 0
				nImpTot += nValIpi + nIcmsRet
			//else
			//	nValIpi := 0
			//	nIcmsRet := 0
			//endif
			//alert(nImpTot)

			nTotItem  := aCols[_x][nPosVlr]
			nTotItem  += (nValIpi+nIcmsRet+nFrtDspP) - (nDescpP)//SOMA DOS IMPOSTOS/FRETE DESPESAS NO TOTAL DO ITEM

			nCustot  := (aCols[_x][nPosQtde]*nCusto)
			nbenFil  := 0	//aVetPnl3[ny][38]

			nReceita := nTotItem-nImpTot
			nMargem  := Round((((nReceita - nCusTot + nbenFil ) / nReceita ) * 100),2)

			nTamMg := len(alltrim(str(nMargem)))
			if nTamMg > TAMSX3('C6_ZMARGPP')[1]

				aadd(aTitles, "Item " + aCols[_x][nPosItem])

				xItem := aCols[_x][nPosItem] + " - " + alltrim(aCols[_x][nPosProd]) + " / " + alltrim(aCols[_x][nPosNome])

				if __cUSERID $ SUPERGETMV("IN_VISMARG" , .T., "000000",)
					cCorpo += '<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;"><b>IMPOSTOS</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;"><b>'+alltrim(transf(nImpTot,'@E 999,999,999.99'))+'</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;"><b>CUSTO UNIT.</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;"><b>'+alltrim(transf(nCusto,'@E 999,999,999.99'))+'</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nValIcm,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;background:#6495ED;"><b>MARGEM</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;background:#6495ED;"><b>'+alltrim(transf(nMargem,'@E 999,999,999.99'))+'%</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)PIS</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nValPis,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Receita</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nReceita,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;(Produtos - Impostos)</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Cofins</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nValCof,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Custo Total</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nCusTot,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms Compl.</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nIcmComp,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Subs.Trib.</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nbenFil,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Difal</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nDifal,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)FECP</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nFECP,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Comissão</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(0,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;"><b>PRODUTOS</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;"><b>'+alltrim(transf(nTotItem,'@E 999,999,999.99'))+'</b></td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Vlr.Total</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(aCols[_x][nPosVlr],'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)IPI</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nValIpi,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Icms Sol.</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nIcmsRet,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(+)Prev.Frete</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nFrtDspP,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'+;
								'<tr><td style="border: 1px solid #ddd;text-align: left;padding: 5px;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(-)Desconto</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">'+alltrim(transf(nDescpP,'@E 999,999,999.99'))+'</td>'+;
								'<td style="border: 1px solid #ddd;text-align: right;padding: 5px;">&nbsp;</td></tr>'

					cCorpo += '</tbody></table>'

					/*//Mostra na tela
					DEFINE FONT oFont NAME "Arial" SIZE 0, -8 //BOLD

					DEFINE MSDIALOG oDlgM FROM 00,00 TO 540,700 PIXEL TITLE "Mapa de Calculo Margem "
						oSayData := tSay():New(008,010,{|| "Produto: " + xItem },oDlgM,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,9)
						oSayMsg  := tSay():New(015,010,{|| "ALERTA! Margem com valor errado. PEDIDO NAO SERA GRAVADO! " },oDlgM,,,,,,.T.,CLR_RED,CLR_WHITE,200,9)
						
						oScr:= TScrollBox():New(oDlgM,25,5,230,345,.T.,.F.,.T.)

						nW := ((2640 * len(cCorpo)) / 14769) / 2

						@ 3,5 SAY oFicha VAR cCorpo OF oScr FONT oFont PIXEL SIZE 500, 400 HTML

					ACTIVATE MSDIALOG oDlgM CENTERED */

					aadd(aCorpo, {xItem, cCorpo, 1})
				else

					//xItem := aCols[_x][nPosItem] + " - " + alltrim(aCols[_x][nPosProd]) + " / " + alltrim(aCols[_x][nPosNome])
					//Alert("ALERTA! Margem do produto [ " + xItem + " ] com valor errado. PEDIDO NAO SERA GRAVADO!")

					aadd(aCorpo, {xItem, "ALERTA! Margem do produto [ " + xItem + " ] com valor errado. PEDIDO NAO SERA GRAVADO!", 2})

				endif

				//lRetM := .F.
				//exit

			endif


			MaFisEnd()

		endif
	next

	if !empty(len(aTitles))

		DEFINE FONT oFont NAME "Arial" SIZE 0, -8 //BOLD
		DEFINE MSDIALOG oDlgM FROM 00,00 TO 540,700 PIXEL TITLE "Mapa de Calculo Margem "
			/*oSayData := tSay():New(008,010,{|| "Produto: " + xItem },oDlgM,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,9)
			oSayMsg  := tSay():New(015,010,{|| "ALERTA! Margem com valor errado. PEDIDO NAO SERA GRAVADO! " },oDlgM,,,,,,.T.,CLR_RED,CLR_WHITE,200,9)
			
			oScr:= TScrollBox():New(oDlgM,25,5,230,345,.T.,.F.,.T.)

			nW := ((2640 * len(cCorpo)) / 14769) / 2

			@ 3,5 SAY oFicha VAR cCorpo OF oScr FONT oFont PIXEL SIZE 500, 400 HTML*/

			oPanel := tPanel():New(0,0,,oDlgM,,,,,,655,10,.T.,.F.)
			oPanel:Align := CONTROL_ALIGN_ALLCLIENT
			oFolder := TFolder():New(25,5, aTitles,{},oPanel,,,, .F.,,100,100,,.T.)
			oFolder:bChange	:= {|| goCnsFld(oFolder:nOption, Len(aTitles))}
			oFolder:Align := CONTROL_ALIGN_ALLCLIENT

		ACTIVATE MSDIALOG oDlgM ON INIT oFolder:ShowPage(1) CENTERED

		lRetM := .F.
	endif

Return( lRetM )


Static Function goCnsFld(nFolder, nTitles)

DEFINE FONT oFont NAME "Arial" SIZE 0, -8 //BOLD

//alert(aCorpo[nFolder][1])
if aCorpo[nFolder][3] == 1
	oSay1 := "oSayDt" + alltrim(str(nFolder))
	oSay2 := "oSayMs" + alltrim(str(nFolder))
	xDscr := aCorpo[nFolder][1]
	&(oSay1) := tSay():New(008,010,{|| "Produto: " + xDscr },oFolder:aDialogs[nFolder],,,,,,.T.,CLR_BLACK,CLR_WHITE,200,9)
	&(oSay2)  := tSay():New(015,010,{|| "ALERTA! Margem com valor errado. PEDIDO NAO SERA GRAVADO! " },oFolder:aDialogs[nFolder],,,,,,.T.,CLR_RED,CLR_WHITE,200,9)
	
	oScr := "oScr" + alltrim(str(nFolder))
	&(oScr) := TScrollBox():New(oFolder:aDialogs[nFolder],25,5,230,345,.T.,.F.,.T.)

	nW := ((2640 * len(aCorpo[nFolder][2])) / 14769) / 2

	@ 3,5 SAY oFicha VAR aCorpo[nFolder][2] OF &(oScr) FONT oFont PIXEL SIZE 500, 400 HTML

else
	//Alert("ALERTA! Margem do produto [ " + xItem + " ] com valor errado. PEDIDO NAO SERA GRAVADO!")

	oSay1 := "oSayDt" + alltrim(str(nFolder))
	oSay2 := "oSayMs" + alltrim(str(nFolder))
	xDscr := aCorpo[nFolder][1]
	&(oSay1) := tSay():New(008,010,{|| "Produto: " + xDscr },oFolder:aDialogs[nFolder],,,,,,.T.,CLR_BLACK,CLR_WHITE,200,9)
	&(oSay2)  := tSay():New(015,010,{|| "ALERTA! Margem com valor errado. PEDIDO NAO SERA GRAVADO! " },oFolder:aDialogs[nFolder],,,,,,.T.,CLR_RED,CLR_WHITE,200,9)

endif

Return
