#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCTBA01   ºAutor  ³Andreza Favero      º Data ³  06/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Programa com funcoes contabeis para lancamento padronizado  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTit    ºAutor  ³Andreza Favero      º Data ³  06/09/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o valor de retencao do titulo baseado no contas a  º±±
±±º          ³ pagar. Foi necessario pois os campos d1_valimp1, d1_valimp2º±±
±±º          ³ e d1_valimp4 nao estao com o mesmo valor da retencao do    º±±
±±º          ³ contas a pagar.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Opcoes possiveis³
//³PIS - Pis retido³
//³COF - Cofins ret|
//³CSL - Csçç retid³
// ISS - ISS retido
// IRF	- Impostos de renda
// INS	- Impostos de renda
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RetTit(cOpcao)

Local aArea	:= GetArea()
Local aAreaD1	:= SD1->(GetArea())
Local aAreaE2	:= SE2->(GetArea())
Local cQryPIS	:= " "
Local cQryCOF	:= " "
Local cQryCSL	:= " "
Local cQryIss	:= " "
Local cQryIrf	:= " "
Local nValor := 0
Local cFilNot	:= SF1->F1_FILIAL
Local cSerie	:= SF1->F1_PREFIXO
Local cNum 		:= SF1->F1_DOC
Local cFornec	:= SF1->F1_FORNECE
Local cLoja		:= SF1->F1_LOJA
Local cTpNF		:= SF1->F1_TIPO
Local cForTX	:= GetMv("MV_UNIAO")
Local cForIss	:= GetMv("MV_MUNIC")
Local cForIns	:= GetMv("MV_FORINSS")
Local cNatPis 	:= GetMv("MV_PISNAT")
Local cNatCof	:= GetMv("MV_COFINS")
Local cNatCsll	:= GetMv("MV_CSLL")
Local cNatISS	:= GetMv("MV_ISS")
Local cNatIrf	:= GetMv("MV_IRF")
Local cNatIns	:= GetMv("MV_INSS")
Local cDelet	:= IIf(Inclui, " ","*")
Local cMinItem	:= " "


cNatIrf	:= StrTran(cNatIrf,'"',"")
cNatIns	:= StrTran(cNatIns,'"',"")
cNatIss	:= StrTran(cNatIss,'"',"")


// Faz a query para identificar qual o menor item da nota fiscal.
// Isto garante que o valor das retencoes de impostos serao contabilizadas apenas uma vez
// independente da quantidade de itens na nota fiscal, ja que as retencoes serao obtidas.
// diretamente do SE2.

cQryNF	:= " SELECT D1_ITEM MIN, MAX(D1_TOTAL) VALOR FROM "+RetSqlName("SD1")+" SD1,"+RetSqlName("SF4")+" SF4"
cQryNF	+= " WHERE D1_FILIAL ='"+cFilNot+"' "
cQryNF	+= " AND D1_DOC ='"+cNum+"' "
cQryNF	+= " AND D1_SERIE ='"+cSerie+"'  "
cQryNF	+= " AND D1_FORNECE ='"+cFornec+"' "
cQryNF	+= " AND D1_LOJA ='"+cLoja+"'  "
cQryNF	+= " AND D1_TIPO ='"+cTpNf+"'  "
cQryNF	+= " AND SD1.D_E_L_E_T_ = ' '"
cQryNF	+= " AND F4_FILIAL ='"+xFilial("SF4")+"'"
cQryNF	+= " AND F4_CODIGO = D1_TES"
cQryNF	+= " AND SF4.D_E_L_E_T_ = ' '"
cQryNF	+= " GROUP BY D1_ITEM"
cQryNF	+= " ORDER BY 2 DESC,1"

If Select("TMPNF") > 0
	DbSelectArea("TMPNF")
	DbCloseArea()
Endif

TCQUERY cQryNF NEW ALIAS "TMPNF"

dbSelectArea("TMPNF")
dbGotop()
If !TMPNF->(Eof())
	cMinItem	:= TMPNF->MIN
EndIF

If SD1->D1_ITEM <> cMinItem
	RestArea(aAreaD1)
	RestArea(aAreaE2)
	RestArea(aArea)
	Return(0)
EndIf

If cOpcao == "COF"
	cQryCOF := " SELECT E2_VALOR AS COFINS FROM "+RetSqlName("SE2")+" SE2COF "
	cQryCOF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCOF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCOF += " AND E2_TIPO = 'TX'  "
	cQryCOF += " AND E2_NATUREZ ='"+cNatCof+"' AND "
	cQryCOF += " E2_PARCELA = (SELECT MAX(E2_PARCCOF) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCOF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCOF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCOF += "					  AND E2_NUM = '"+cNum+"' "
	cQryCOF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCOF += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryCOF += "					  AND E2_TIPO ='NF' "
	cQryCOF += "					  AND E2_PARCCOF <> ' ' "
	cQryCOF += "					  AND SE2COF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCOF += "					  AND SE2COF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCOF += "					  AND SE2COF.E2_PARCELA = SE2TIT.E2_PARCCOF "
	cQryCOF += "					  AND SE2COF.E2_VALOR = SE2TIT.E2_VRETCOF "
	cQryCOF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCOF += "					  AND SE2COF.D_E_L_E_T_= '"+cDelet+"') "
	cQryCOF += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "
	cQryCof += " AND SE2COF.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryCof += " FROM "+RetSqlName("SE2")+" A "
	cQryCof += " WHERE SE2COF.E2_FILIAL=A.E2_FILIAL "
	cQryCof += " AND SE2COF.E2_PREFIXO=A.E2_PREFIXO "
	cQryCof += " AND SE2COF.E2_NUM=A.E2_NUM "
	cQryCof += " AND SE2COF.E2_PARCELA=A.E2_PARCELA "
	cQryCof += " AND SE2COF.E2_TIPO=A.E2_TIPO "
	cQryCof += " AND SE2COF.E2_FORNECE =A.E2_FORNECE "
	cQryCof += " AND SE2COF.E2_LOJA =A.E2_LOJA  "
	cQryCof += " AND SE2COF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCof += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "
	cQryCof += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	If Select("TMPCOF") > 0
		DbSelectArea("TMPCOF")
		DbCloseArea()
	Endif
	
	//		MEMOWRIT("RCTBR04.SQL",cQryCOF)
	
	TCQUERY cQryCOF NEW ALIAS "TMPCOF"
	
	dbSelectArea("TMPCOF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCOF->COFINS
		dbSelectArea("TMPCOF")
		dbSkip()
	End
	
	dbSelectArea("TMPCOF")
	dbCloseArea()
	
ElseIf cOpcao == "PIS"
	
	cQryPIS := " SELECT E2_VALOR AS PIS FROM "+RetSqlName("SE2")+" SE2PIS "
	cQryPIS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryPIS += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryPIS += " AND E2_TIPO = 'TX'  "
	cQryPIS += " AND E2_NATUREZ ='"+cNatPIS+"' AND "
	cQryPIS += " E2_PARCELA = (SELECT MAX(E2_PARCPIS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryPIS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryPIS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryPIS += "					  AND E2_NUM = '"+cNum+"' "
	cQryPIS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryPIS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryPIS += "					  AND E2_TIPO ='NF' "
	cQryPIS += "					  AND E2_PARCPIS <> ' ' "
	cQryPIS += "					  AND SE2PIS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryPIS += "					  AND SE2PIS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryPIS += "					  AND SE2PIS.E2_PARCELA = SE2TIT.E2_PARCPIS "
	cQryPIS += "					  AND SE2PIS.E2_VALOR = SE2TIT.E2_VRETPIS "
	cQryPIS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += "					  AND SE2PIS.D_E_L_E_T_='"+cDelet+"') "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND SE2PIS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryPIS += " FROM "+RetSqlName("SE2")+" A "
	cQryPIS += " WHERE SE2PIS.E2_FILIAL=A.E2_FILIAL "
	cQryPIS += " AND SE2PIS.E2_PREFIXO =A.E2_PREFIXO "
	cQryPIS += " AND SE2PIS.E2_NUM =A.E2_NUM "
	cQryPIS += " AND SE2PIS.E2_PARCELA =A.E2_PARCELA "
	cQryPIS += " AND SE2PIS.E2_TIPO =A.E2_TIPO "
	cQryPIS += " AND SE2PIS.E2_FORNECE =A.E2_FORNECE "
	cQryPIS += " AND SE2PIS.E2_LOJA =A.E2_LOJA  "
	cQryPIS += " AND SE2PIS.E2_VALOR =A.E2_VALOR  "
	cQryPIS += " AND SE2PIS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	If Select("TMPPIS") > 0
		DbSelectArea("TMPPIS")
		DbCloseArea()
	Endif
	
	TCQUERY cQryPIS NEW ALIAS "TMPPIS"
	
	dbSelectArea("TMPPIS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPPIS->PIS
		dbSelectArea("TMPPIS")
		dbSkip()
	End
	
	dbSelectArea("TMPPIS")
	dbCloseArea()
	
	
ElseIf cOpcao == "CSL"
	
	cQryCSL := " SELECT E2_VALOR AS CSL FROM "+RetSqlName("SE2")+" SE2CSL "
	cQryCSL += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCSL += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCSL += " AND E2_TIPO = 'TX'  "
	cQryCSL += " AND E2_NATUREZ ='"+cNatCSLL+"' AND "
	cQryCSL += " E2_PARCELA = (SELECT MAX(E2_PARCSLL) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCSL += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCSL += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCSL += "					  AND E2_NUM = '"+cNum+"' "
	cQryCSL += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCSL += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryCSL += "					  AND E2_TIPO ='NF' "
	cQryCSL += "					  AND E2_PARCSLL <> ' ' "
	cQryCSL += "					  AND SE2CSL.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCSL += "					  AND SE2CSL.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCSL += "					  AND SE2CSL.E2_PARCELA = SE2TIT.E2_PARCSLL "
	cQryCSL += "					  AND SE2CSL.E2_VALOR = SE2TIT.E2_VRETCSL "
	cQryCSL += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += "					  AND SE2CSL.D_E_L_E_T_='"+cDelet+"' )"
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND SE2CSL.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryCSL += " FROM "+RetSqlName("SE2")+" A "
	cQryCSL += " WHERE SE2CSL.E2_FILIAL=A.E2_FILIAL "
	cQryCSL += " AND SE2CSL.E2_PREFIXO =A.E2_PREFIXO "
	cQryCSL += " AND SE2CSL.E2_NUM =A.E2_NUM "
	cQryCSL += " AND SE2CSL.E2_PARCELA =A.E2_PARCELA "
	cQryCSL += " AND SE2CSL.E2_TIPO =A.E2_TIPO "
	cQryCSL += " AND SE2CSL.E2_FORNECE =A.E2_FORNECE "
	cQryCSL += " AND SE2CSL.E2_LOJA =A.E2_LOJA  "
	cQryCSL += " AND SE2CSL.E2_VALOR =A.E2_VALOR  "
	cQryCSL += " AND SE2CSL.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND A.D_E_L_E_T_='"+cDelet+"')"
	
	If Select("TMPCSL") > 0
		DbSelectArea("TMPCSL")
		DbCloseArea()
	Endif
	
	TCQUERY cQryCSL NEW ALIAS "TMPCSL"
	
	dbSelectArea("TMPCSL")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCSL->CSL
		dbSelectArea("TMPCSL")
		dbSkip()
	End
	
	dbSelectArea("TMPCSL")
	dbCloseArea()
	
ElseIf cOpcao == "ISS"
	cQryISS := " SELECT E2_VALOR AS ISS FROM "+RetSqlName("SE2")+" SE2ISS "
	cQryISS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryISS += " AND E2_FORNECE = '"+cForISS+"'  "
	cQryISS += " AND E2_TIPO = 'ISS'  "
	cQryISS += " AND E2_NATUREZ ='"+cNatISS+"' AND "
	cQryISS += " E2_PARCELA = (SELECT MAX(E2_PARCISS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryISS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryISS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryISS += "					  AND E2_NUM = '"+cNum+"' "
	cQryISS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryISS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryISS += "					  AND E2_TIPO ='NF' "
	cQryISS += "					  AND E2_PARCISS <> ' ' "
	cQryISS += "					  AND SE2ISS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryISS += "					  AND SE2ISS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryISS += "					  AND SE2ISS.E2_PARCELA = SE2TIT.E2_PARCISS "
	cQryISS += "					  AND SE2ISS.E2_VALOR = SE2TIT.E2_ISS "
	cQryISS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += "					  AND SE2ISS.D_E_L_E_T_= '"+cDelet+"') "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND SE2ISS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryISS += " FROM "+RetSqlName("SE2")+" A "
	cQryISS += " WHERE SE2ISS.E2_FILIAL=A.E2_FILIAL "
	cQryISS += " AND SE2ISS.E2_PREFIXO =A.E2_PREFIXO "
	cQryISS += " AND SE2ISS.E2_NUM =A.E2_NUM "
	cQryISS += " AND SE2ISS.E2_PARCELA =A.E2_PARCELA "
	cQryISS += " AND SE2ISS.E2_TIPO =A.E2_TIPO "
	cQryISS += " AND SE2ISS.E2_FORNECE =A.E2_FORNECE "
	cQryISS += " AND SE2ISS.E2_LOJA =A.E2_LOJA  "
	cQryISS += " AND SE2ISS.E2_VALOR =A.E2_VALOR  "
	cQryISS += " AND SE2ISS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND A.D_E_L_E_T_='"+cDelet+"')"
	
	
	If Select("TMPISS") > 0
		DbSelectArea("TMPISS")
		DbCloseArea()
	Endif
	
	TCQUERY cQryISS NEW ALIAS "TMPISS"
	
	dbSelectArea("TMPISS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPISS->ISS
		dbSelectArea("TMPISS")
		dbSkip()
	End
	
	dbSelectArea("TMPISS")
	dbCloseArea()
	
ElseIf cOpcao == "IRF"
	
	cQryIRF := " SELECT E2_VALOR AS IRF FROM "+RetSqlName("SE2")+" SE2IRF "
	cQryIRF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryIRF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryIRF += " AND E2_TIPO = 'TX'  "
	cQryIRF += " AND E2_NATUREZ ='"+cNatIRF+"' AND "
	cQryIRF += " E2_PARCELA = (SELECT MAX(E2_PARCIR) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryIRF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryIRF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryIRF += "					  AND E2_NUM = '"+cNum+"' "
	cQryIRF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryIRF += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryIRF += "					  AND E2_TIPO ='NF' "
	cQryIRF += "					  AND E2_PARCIR <> ' ' "
	cQryIRF += "					  AND SE2IRF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryIRF += "					  AND SE2IRF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryIRF += "					  AND SE2IRF.E2_PARCELA = SE2TIT.E2_PARCIR "
	cQryIRF += "					  AND SE2IRF.E2_VALOR = SE2TIT.E2_IRRF "
	cQryIRF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += "					  AND SE2IRF.D_E_L_E_T_= '"+cDelet+"') "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND SE2IRF.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryIRF += " FROM "+RetSqlName("SE2")+" A "
	cQryIRF += " WHERE SE2IRF.E2_FILIAL=A.E2_FILIAL "
	cQryIRF += " AND SE2IRF.E2_PREFIXO =A.E2_PREFIXO "
	cQryIRF += " AND SE2IRF.E2_NUM =A.E2_NUM "
	cQryIRF += " AND SE2IRF.E2_PARCELA =A.E2_PARCELA "
	cQryIRF += " AND SE2IRF.E2_TIPO =A.E2_TIPO "
	cQryIRF += " AND SE2IRF.E2_FORNECE =A.E2_FORNECE "
	cQryIRF += " AND SE2IRF.E2_LOJA =A.E2_LOJA  "
	cQryIRF += " AND SE2IRF.E2_VALOR =A.E2_VALOR "
	cQryIRF += " AND SE2IRF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	
	If Select("TMPIRF") > 0
		DbSelectArea("TMPIRF")
		DbCloseArea()
	Endif
	
	
	TCQUERY cQryIRF NEW ALIAS "TMPIRF"
	
	dbSelectArea("TMPIRF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPIRF->IRF
		dbSelectArea("TMPIRF")
		dbSkip()
	End
	
	dbSelectArea("TMPIRF")
	dbCloseArea()
	
	
ElseIf cOpcao == "INS"
	
	cQryINS := " SELECT E2_VALOR AS INS FROM "+RetSqlName("SE2")+" SE2INS "
	cQryINS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryINS += " AND E2_FORNECE = '"+cForIns+"'  "
	cQryINS += " AND E2_TIPO = 'INS'  "
	cQryINS += " AND E2_NATUREZ ='"+cNatIns+"' AND "
	cQryINS += " E2_PARCELA = (SELECT MAX(E2_PARCINS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryINS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryINS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryINS += "					  AND E2_NUM = '"+cNum+"' "
	cQryINS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryINS += "					  AND E2_LOJA = '"+cLoja+"' "
	cQryINS += "					  AND E2_TIPO ='NF' "
	cQryINS += "					  AND E2_PARCINS <> ' ' "
	cQryINS += "					  AND SE2INS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryINS += "					  AND SE2INS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryINS += "					  AND SE2INS.E2_PARCELA = SE2TIT.E2_PARCINS "
	cQryINS += "					  AND SE2INS.E2_VALOR = SE2TIT.E2_INSS "
	cQryINS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += "					  AND SE2INS.D_E_L_E_T_= '"+cDelet+"') "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND SE2INS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryINS += " FROM "+RetSqlName("SE2")+" A "
	cQryINS += " WHERE SE2INS.E2_FILIAL=A.E2_FILIAL "
	cQryINS += " AND SE2INS.E2_PREFIXO =A.E2_PREFIXO "
	cQryINS += " AND SE2INS.E2_NUM =A.E2_NUM "
	cQryINS += " AND SE2INS.E2_PARCELA =A.E2_PARCELA "
	cQryINS += " AND SE2INS.E2_TIPO =A.E2_TIPO "
	cQryINS += " AND SE2INS.E2_FORNECE =A.E2_FORNECE "
	cQryINS += " AND SE2INS.E2_LOJA =A.E2_LOJA  "
	cQryINS += " AND SE2INS.E2_VALOR =A.E2_VALOR "
	cQryINS += " AND SE2INS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	
	If Select("TMPINS") > 0
		DbSelectArea("TMPINS")
		DbCloseArea()
	Endif
	
	
	TCQUERY cQryINS NEW ALIAS "TMPINS"
	
	dbSelectArea("TMPINS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPINS->INS
		dbSelectArea("TMPINS")
		dbSkip()
	End
	
	dbSelectArea("TMPINS")
	dbCloseArea()
	
EndIf

RestArea(aAreaD1)
RestArea(aAreaE2)
RestArea(aArea)

Return(nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SeqCli    ºAutor  ³Andreza Favero      º Data ³  09/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SegCli()

Local aArea	:= GetArea()
Local cSegmento	:= " "

DbSelectArea("ACY")
DbSetOrder(1)
If MsSeek(xFilial("ACY")+SA1->A1_GRPVEN)
	cSegmento	:= ACY->ACY_CLVL
Else
	cSegmento	:= " "
EndIf

RestArea(aArea)

Return(cSegmento)



User Function Segnd()

Local aArea	:= GetArea()
Local cSegmento	:= " "

Dbselectarea("SA1")
DBSETORDER(1)
DBSEEK(XFILIAL("SA1")+SD1->D1_FORNECE)

DbSelectArea("ACY")
DbSetOrder(1)
If MsSeek(xFilial("ACY")+SA1->A1_GRPVEN)
	cSegmento	:= ACY->ACY_CLVL
Else
	cSegmento	:= " "
EndIf

RestArea(aArea)

Return(cSegmento)











************************************************************
User Function SegC()

Local aArea	:= GetArea()
Local cSegmento	:= " "

DBSELECTAREA("SA1")
DBSETORDER(1)
DBSEEK(XFILIAL("SA1")+SD2->D2_CLIENTE)

DbSelectArea("ACY")
DbSetOrder(1)
If MsSeek(xFilial("ACY")+SA1->A1_GRPVEN)
	cSegmento	:= ACY->ACY_CLVL
Else
	cSegmento	:= " "
EndIf

RestArea(aArea)

Return(cSegmento)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCSegCli  ºAutor  ³Andreza Favero      º Data ³  09/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Centro de custo relacionado ao segmento do cliente.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCSegCli()

Local aArea				:= GetArea()
Local cCCusto	:= " "

DbSelectArea("ACY")
DbSetOrder(1)
If MsSeek(xFilial("ACY")+SA1->A1_GRPVEN)
	cCCusto	:= ACY->ACY_XCC
Else
	cCCusto	:= " "
EndIf

RestArea(aArea)

Return(cCCusto)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³CtbCheque ³ Monta valor dos juros, desconto, multa, correcao             º±±
±±º             ³          ³                                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Solicitante ³          ³Especifico Brascola                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³          ³ Almir Bandina                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Produção    ³ ??.??.?? ³ Ignorado                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Parâmetros  ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno     ³ Nil.                                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±º             ³                                                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Alterações  ³ ??.??.?? - Nome - Descrição                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CtbCheque(cTpDoc)

Local aAreaAtu	:= GetArea()
Local nRet		:= 0
Local cQry		:= ""
Local cPrefixo	:= SEF->EF_PREFIXO
Local cNumero	:= SEF->EF_TITULO
Local cParcela	:= SEF->EF_PARCELA
Local cTipo		:= SEF->EF_TIPO
Local cFornece	:= SEF->EF_FORNECE
Local cLoja		:= SEF->EF_LOJA

Default cTpDoc	:= " "

// Define a select para apurar o valor de desconto, juros e multa
cQry	+= "SELECT"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'DC' THEN E5.E5_VALOR ELSE 0 END) AS DESCON,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('JR','MT') THEN E5.E5_VALOR ELSE 0 END) AS JUROS,"
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC = 'CM' THEN E5.E5_VALOR ELSE 0 END) AS CORREC, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('BA','VL') THEN E5.E5_VRETPIS ELSE 0 END) AS PIS, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('BA','VL') THEN E5.E5_VRETCOF ELSE 0 END) AS COFINS, "
cQry	+= " SUM(CASE WHEN E5.E5_TIPODOC IN ('BA','VL') THEN E5.E5_VRETCSL ELSE 0 END) AS CSLL "
cQry	+= " FROM "+RetSqlName("SE5")+" E5 WHERE"
cQry	+= " E5.E5_FILIAL = '"+xFilial("SE5")+"' AND"
cQry	+= " E5.E5_PREFIXO = '"+cPrefixo+"' AND"
cQry	+= " E5.E5_NUMERO = '"+cNumero+"' AND"
cQry	+= " E5.E5_PARCELA = '"+cParcela+"' AND"
cQry	+= " E5.E5_TIPO = '"+cTipo+"' AND"
cQry	+= " E5.E5_CLIFOR = '"+cFornece+"' AND"
cQry	+= " E5.E5_LOJA = '"+cLoja+"' AND"
cQry	+= " E5.D_E_L_E_T_ <> '*'"

// Verifica se o alias esta em uso
If Select("TMP590") > 0
	dbSelectArea("TMP590")
	dbCloseArea()
EndIf

// Roda a query
TCQUERY cQry NEW ALIAS "TMP590"

// Define o valor do retorno
If cTpDoc == "DC"					// Desconto
	nRet	:= TMP590->DESCON
ElseIf cTpDoc == "JR"				// Juros
	nRet	:= TMP590->JUROS
ElseIf cTpDoc == "CM"
	nRet	:= TMP590->CORREC		// correcao monetaria
ElseIf cTpDoc == "PIS"
	nRet	:= TMP590->PIS			// Pis retido
ElseIf cTpDoc == "COF"
	nRet	:= TMP590->COFINS			// Cofins retido
ElseIf cTpDoc == "CSL"
	nRet	:= TMP590->CSLL			// Csll retido
Else
	nRet	:= 0					// Força Zero
EndIf

//Restaura a integridade dos arquivos
dbSelectArea("TMP590")
dbCloseArea()
RestArea(aAreaAtu)

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CMPCP     ºAutor  ³Andreza Favero      º Data ³  21/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para regras de contabilizacao de Compensacao Contas  º±±
±±º          ³a Pagar                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Parmalat                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CMPCP(cOpcao, cTipo)

Local aArea		:= GetArea()
Local aAreaSA2	:= SA2->(GetArea())
Local aAreaSE2	:= SE2->(GetArea())
Local aAreaSED	:= SED->(GetArea())
Local aAreaSE5	:= SE5->(GetArea())
Local nRecSE2	:= SE2->(RECNO())
Local nRecSA2	:= SA2->(RECNO())
Local	lAdto		:= .T.
Local cCtaAd	:= " "
Local cCtaTit	:= " "
Local	cHistAd	:= " "
Local cHistTit	:= " "
Local cOriAd	:= " "
Local	cOriTit	:= " "
Local	nVlrAd	:= 0
Local	nVlrtit	:= 0
Local	cItAd		:= " "
Local cItTit	:= " "
Local	cCCAdt	:= " "
Local	cCCTit	:= "  "
Local	nVlrVM	:= 0
Local	cCtaVM	:= " "
Local	cHistVM  := " "
Local cCtaAcrP	:= " "					// Conta do Acrescimo Pago (constante no NDF/PA)
Local nAcreP	:= 0						// Valor do Acrescimo Pago (constante no NDF/PA)
Local cCtaAcrO	:= " "					// Conta do Acrescimo Obtido (constante no título)
Local nAcreO	:= 0						// Valor do Acrescimo Obtido (constante no título)
Local nOriSE5	:= SE5->(Recno())		// Guarda o registro do SE5 original
Local nTamChave:= TAMSX3("E2_PREFIXO")[1]+TAMSX3("E2_NUM")[1]+TAMSX3("E2_PARCELA")[1]+TAMSX3("E2_TIPO")[1]
Local cChvSE5	:= ""						// Chave de pesquisa do SE5
Local lAchoSE5	:= .F.					// Identificador de localização
Local cCCAdt	:= ""
Local cCCTit	:= ""
Local nDecreC	:= 0
Local nAcreO	:= 0
Local nCorrec := 0
Local nDecreO	:= 0
Local nAcreC	:= 0
Local cquery	:= " "
Local cChavePri	:= ""
Local cChaveSe2	:= SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Local lContabil	:= .T.
Local cQryTit		:= " "
Local cQryAdt		:= " "
Local nSe2Rec		:= 0
Local nRecSe5Ori  := 0
Local cSe5CPart	:= " "
Local cPrefCPar := Substr(SE5->E5_DOCUMEN,1,3)
Local cNumCPar	 := Substr(SE5->E5_DOCUMEN,4,6)
Local cParCPar  := Substr(SE5->E5_DOCUMEN,10,2)
Local cTpCPar	 := Substr(SE5->E5_DOCUMEN,12,3)
Local cForCPar	 := SE5->E5_CLIFOR
Local cLojCPar  := SE5->E5_LOJA
Local cSeqCPar  := SE5->E5_SEQ
                                               
Default cTipo		:= "I"

If Type("STRLCTPAD") == "U"
	STRLCTPAD := SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
Endif
cChavePri	 := STRLCTPAD

If SUBSTR(cChavePri,12,3) == "NDF"
	If Alltrim(Upper(Posicione("SE2",1,xFilial("SE2")+cChavePri,"E2_ORIGEM"))) <> "FINA050"
		lContabil := .F.
	EndIf
ElseIf SUBSTR(cChaveSe2,12,3) == "NDF"
	If Alltrim(Upper(Posicione("SE2",1,xFilial("SE2")+cChaveSe2,"E2_ORIGEM"))) <> "FINA050"
		lContabil := .F.
	EndIf
EndIf

// 26.09.05 - Almir Bandina
// No processo off-line, os arquivos SE2 e SE5 sempre estão posicionados no PA
// e na variável STRLCTPAD tem os dados do título compensado.
// Quando for a opção VLRAD usar SE5
// Quando for a opção VLRTI usar STRLCTPAD para posicionar
//If VALOR <= 0 .and. lContabil
If lContabil
	nDecreO	:= SE5->E5_VLDESCO
	cCtaDecO	:= "  "
	nAcreP	:= SE5->E5_VLJUROS
	cCtaAcrP	:= " "
	cSEQ	:= SE5->E5_SEQ
	// Posiciona no fornecedor para pegar a conta a débito
	dbSelectArea("SA2")
	MsSeek(xFilial("SA2")+SE5->E5_CLIFOR+SE5->E5_LOJA)
	// Posiciona na natureza para pegar a conta a crédito
	dbSelectArea("SED")
	dbSetorder(1)
	MsSeek(xFilial("SED")+SE5->E5_NATUREZ)
	// Posiciona no título principal (NF)
	
	dbSelectArea("SE2")
	dbSetOrder(1)
	If cTipo == "C"
		MsSeek(xFilial("SE2")+SubStr(SE5->E5_DOCUMEN,1,14)+SE5->E5_CLIFOR+SE5->E5_LOJA)
	Else
		MsSeek(xFilial("SE2")+SubStr(STRLCTPAD,1,14)+SE5->E5_CLIFOR+SE5->E5_LOJA)
	EndIf
	
	If cOpcao $ "CADT#HADT#OADT#VLRAD#ITADT#VLDESCO#CTDESCO#VLACREP#CTACREP#CCADT#CVMTIT#VVMTIT"
		// Define a conta do titulo
		cCtaAd	:= SED->ED_DEBITO
		//		nVlrAd	:= SE5->E5_VALOR+nDecreO-nAcreP//+nCorrec
		nVlrAd	:= SE5->E5_VALOR//+nDecreO-nAcreP+SE5->E5_VLCORRE
		cHistAd	:= If(cTipo=="C","CANC.","")+"CMP ADTO "+SE5->E5_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		
		// SALVA O RECNO
		nSe2Rec	:= SE2->(Recno())
		DbSelectArea("SE2")
		DbSetOrder(1)
		If MsSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
			cItAd		:= "001"+SE2->E2_MSFIL+"0"
		EndIf
		// VOLTA O RECNO
		DbSelectArea("SE2")
		DbGoTo(nSe2Rec)
		
	ElseIf cOpcao  $ "CTIT#HTIT#OTIT#VLRTI#ITTIT#VLDESCC#CTDESCC#VLACREO#CTACREO#CCTIT#CVMADT#VVMAD"
		// Define a conta do titulo
		If Alltrim(SE2->E2_TIPO) == "RD"
			cCtatit	:= SA2->A2_XCTAREE
		Else
			cCtaTit	:= SA2->A2_CONTA
		EndIf
		// Posiciono o SE5 para pegar o valor da correcao da contra partida, pois o valor gravado no SE2 nao esta correto
		
		//		nVlrTit	:= SE5->E5_VALOR+nDecreC-nAcreO//+nCorrec
		nVlrTit	:= SE5->E5_VALOR//+nDecreC-nAcreO+SE5->E5_VLCORRE
		cHistTit	:= If(cTipo=="C","CANC.","")+"CMP TIT "+SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+SE2->E2_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		cItTIT	:= "001"+SE2->E2_MSFIL+"0"
	EndIf
	cOriTit	:= SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA
	
	If cOpcao $ "CVMADD#HVMAD#VVMAD"
		cHistVM	:= "VC ADTO "+SE5->E5_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		ncorrec	:= SE5->E5_VLCORRE
		If nCorrec > 0		// variacao ativa do adiantamento
			If Alltrim(SE5->E5_TIPO) $ "NDF/PA"
//				cCtaVm	:= "56120001"
				cCtaVm	:= SED->ED_DEBITO
			EndIf
		Else
			If Alltrim(SE5->E5_TIPO) $ "NDF/PA"
				cCtaVm	:= "56110001"
//				cCtaVm	:= SED->ED_DEBITO
			EndIf
		EndIf
	ElseIf cOpcao $ "CVMADC#HVMAD#VVMAD"
		cHistVM	:= If(cTipo=="C","CANC.","")+"VC ADTO "+SE5->E5_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		ncorrec	:= SE5->E5_VLCORRE
		If nCorrec > 0
			If Alltrim(SE5->E5_TIPO) $ "NDF/PA"
//				cCtaVm	:= SED->ED_DEBITO
				cCtaVm	:= "56120001"				
			EndIf
		Else
			If Alltrim(SE5->E5_TIPO) $ "NDF/PA"
//				cCtaVm	:= "56110001"
				cCtaVm	:= SED->ED_DEBITO
			EndIf
		EndIf
	ElseIf cOpcao	$ "CVMTID#HVMTI#VVMTI"
		
		// Faz query no SE5 para obter o valor da correcao da contra partida
		cQuery := " SELECT E5_VLCORRE AS CORREC FROM "+RetSqlName("SE5")+" SE5 "
		cQuery += " WHERE E5_FILIAL= '"+xFilial("SE5")+"' "
		cQuery += " AND E5_PREFIXO = '"+cPrefCPar+"'  "
		cQuery += " AND E5_NUMERO = '"+cNumCPar+"'  "
		cQuery += " AND E5_PARCELA = '"+cParCPar+"'  "
		cQuery += " AND E5_TIPO = '"+cTpCPar+"'  "
		cQuery += " AND E5_CLIFOR = '"+cForCPar+"'  "
		cQuery += " AND E5_LOJA = '"+cLojCPar+"'  "
		cQuery += " AND E5_SEQ = '"+cSeqCPar+"'  "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		
		If Select("TMPCOR") > 0
			DbSelectArea("TMPCOR")
			DbCloseArea()
		Endif
		
		//		MEMOWRIT("RCTBR04.SQL",cQryCOF)
		
		TCQUERY cQuery NEW ALIAS "TMPCOR"
		
		dbSelectArea("TMPCOR")
		dbGotop()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a string de retorno³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof()
			nCorrec += TMPCOR->CORREC
			dbSelectArea("TMPCOR")
			dbSkip()
		End
		
		dbSelectArea("TMPCOR")
		dbCloseArea()
		
		//		ncorrec	:= SE2->E2_CORREC - nao pegar do SE2, pois o valor pode estar desatualizado
		cHistVM	:= If(cTipo=="C","CANC.","")+"VC TIT "+SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+SE2->E2_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		If nCorrec	> 0
			If !Alltrim(SE2->E2_TIPO) $ "NDF/PA"
//				cCtaVm	:= SA2->A2_CONTA
				cCtaVm	:= "56120001"
			EndIf
		Else
			If !Alltrim(SE2->E2_TIPO) $ "NDF/PA"
//				cCtaVm	:= "56110001"
				cCtaVm	:= SA2->A2_CONTA
			EndIf
		EndIf
	ElseIf cOpcao	$ "CVMTIC#HVMTI#VVMTI"
		
		// Faz query no SE5 para obter o valor da correcao da contra partida
		cQuery := " SELECT E5_VLCORRE AS CORREC FROM "+RetSqlName("SE5")+" SE5 "
		cQuery += " WHERE E5_FILIAL= '"+xFilial("SE5")+"' "
		cQuery += " AND E5_PREFIXO = '"+cPrefCPar+"'  "
		cQuery += " AND E5_NUMERO = '"+cNumCPar+"'  "
		cQuery += " AND E5_PARCELA = '"+cParCPar+"'  "
		cQuery += " AND E5_TIPO = '"+cTpCPar+"'  "
		cQuery += " AND E5_CLIFOR = '"+cForCPar+"'  "
		cQuery += " AND E5_LOJA = '"+cLojCPar+"'  "
		cQuery += " AND E5_SEQ = '"+cSeqCPar+"'  "
		cQuery += " AND D_E_L_E_T_ <> '*' "
		
		If Select("TMPCOR") > 0
			DbSelectArea("TMPCOR")
			DbCloseArea()
		Endif
		
		//		MEMOWRIT("RCTBR04.SQL",cQryCOF)
		
		TCQUERY cQuery NEW ALIAS "TMPCOR"
		
		dbSelectArea("TMPCOR")
		dbGotop()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Monta a string de retorno³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While !Eof()
			nCorrec += TMPCOR->CORREC
			dbSelectArea("TMPCOR")
			dbSkip()
		End
		
		dbSelectArea("TMPCOR")
		dbCloseArea()
		cHistVM	:= "VC TIT "+SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+SE2->E2_PARCELA+" "+ALLTRIM(SA2->A2_NOME)
		//		ncorrec	:= SE2->E2_CORREC
		If nCorrec	> 0
			If !Alltrim(SE2->E2_TIPO) $ "NDF/PA"
//				cCtaVm	:= "56120001"   
				cCtaVm	:= SA2->A2_CONTA
			EndIf
		Else
			If !Alltrim(SE2->E2_TIPO) $ "NDF/PA"
//				cCtaVm	:= SA2->A2_CONTA
				cCtaVm	:= "56110001"   
			EndIf
		EndIf
	EndIf
	
	If cOpcao $ "VVMAD#VVMTI"
		nVlrVM	:= Abs(nCorrec)
	EndIf
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CADT - Retorno conta de debito Adto                   ³
//³CTIT - Retorno conta de credito fornecedor       		³
//³HADT - Historico do PA/NDF                            ³
//³HTIT - Historico do Titulo                            ³
//³OADT - Origem do Adiantamento                         ³
//³OTIT - Origem do Titulo                               ³
//³VLRAD - Valor da compensacao Adto                     ³
//³VLRTI - Valor da compensacao titulo                   ³
//|ITADT - Item contabil do adiantamento						³
//|ITTIT - Item contabil do titulo       						³
//|CORTI - Variacao cambial do titulo    						³
//|CORAD - Variacao cambial do PA/NDF    						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cOpcao  == "CADT"
	cRetorno	:= cCtaAd
ElseIf cOpcao == "CTIT"
	cRetorno	:= cCtaTit
ElseIf cOpcao	== "HADT"
	cRetorno	:= cHistAd
ElseIf cOpcao == "HTIT"
	cRetorno	:= cHistTit
ElseIf cOpcao == "OADT"
	cRetorno	:= cOriAd
ElseIf cOpcao	== "OTIT"
	cRetorno	:= cOriTit
ElseIf cOpcao == "VLRAD"
	cRetorno	:= nVlrAd
ElseIf cOpcao == "VLRTI"
	cRetorno	:= nVlrtit
ElseIf cOpcao	== "ITADT"
	cRetorno	:= cItAd
ElseIf cOpcao == "ITTIT"
	cRetorno	:= cItTit
ElseIf cOpcao == "CCADT"
	cRetorno	:= cCCAdt
ElseIf cOpcao == "CCTIT"
	cRetorno	:= cCCTit
ElseIf cOpcao	$ "VVMAD#VVMTI"
	cRetorno	:= nVlrVM
ElseIf cOpcao $ "CVMADD#CVMADC#CVMTID#CVMTIC"
	cRetorno := cCtaVM
ElseIf cOpcao $ "HVMAD#HVMTI"
	cRetorno := cHistVM
Else
	cRetorno	:= " "
EndIf

RestArea(aAreaSA2)
RestArea(aAreaSE2)
RestArea(aAreaSED)
RestArea(aAreaSE5)
RestArea(aArea)

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP510MNAT ºAutor  ³Andreza Favero      º Data ³  09/17/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Encontra dados necessarios a contabilizacao de titulos com  º±±
±±º          ³multiplas naturezas, mas que nao possuem                    º±±
±±º          ³rateio de centro de custo. Lancamento padrao: 510           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function LP510MNAT(cOpcao)

Local aArea	:= GetArea()
Local aArSEV	:= SEV->(GetArea())
Local aArSE2	:= SE2->(GetArea())
Local cRetorno	:= " "

/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Opcoes disponiveis           	  ³
//³                                ³
//³510CC  - Centro de Custo        ³
//³510HIS - Historico do lancamento³
//³510ORI - Campo de origem        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

If cOpcao == "510CC"			// Busca o centro de custo a ser utilizado
	If SE2->(EOF())
		// Se o titulo e Multiplas Naturezas, o SE2 estara disposicionado. Posicionar no SE2 a partir do SEV
		DbSelectArea("SE2")
		DbSetOrder(1)
		If MsSeek(xFilial("SE2")+SEV->(EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA))
			cRetorno	:= SE2->E2_CCD
		Else
			cRetorno	:= " "
		EndIf
	Else
		// retorna branco, pois nao sera utilizado o LP 510 e sim o LP 508.
	  //	cRetorno	:= "  "
	  cRetorno	:= SE2->E2_CCD
	EndIf
	
ElseIf cOpcao == "510HIS"
	
	If SE2->(EOF())
		cRetorno := "INC TIT PAG "+SEV->EV_PREFIXO+" "+SEV->EV_NUM+" "+ALLTRIM(SA2->A2_NOME)
	Else
		cRetorno	:=  "INC TIT PAG "+SE2->E2_PREFIXO+" "+SE2->E2_NUM+" "+ALLTRIM(SA2->A2_NOME)
	EndIf
	
ElseIf cOpcao		== "510ORI"
	
	If SE2->(EOF())
		cRetorno := SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA)
	Else
		cRetorno	:= SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
	EndIf
	
ElseIf cOpcao == "510VLMU"
	
	If M->E2_MULTNAT == "1"
		DbSelectArea("SE2")
		DbSetOrder(1)
		If MsSeek(SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA))
			If SE2->E2_MULTNAT == "1"		// apenas se for Multi Natureza
				// verifica a natureza
				DbSelectArea("SED")
				DbSetOrder(1)
				If MsSeek(xFilial("SED")+SEV->EV_NATUREZ)
					If SED->ED_XCTB <> "N" .and. SA2->A2_EST <> "EX"
						cRetorno	:= SEV->EV_VALOR
					Else
						cRetorno	:= 0
					EndIf
				Else
					cRetorno	:= 0
				EndIf
			Else
				cRetorno	:= 0
			EndIf
		Else
			cRetorno	:= 0
		EndIf
	Else
		cRetorno	:= 0
	EndIf
Else
	cRetorno	:= " "
EndIf

RestArea(aArSEV)
RestArea(aArSE2)
RestArea(aArea)

Return(cRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CMPCR     ºAutor  ³Andreza Favero      º Data ³  21/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para regras de contabilizacao de Compensacao Contas  º±±
±±º          ³a Receber                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Brascola                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CMPCR(cOpcao, cTipo)

Local aArea		:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())
Local aAreaSE1	:= SE1->(GetArea())
Local aAreaSED	:= SED->(GetArea())
Local aAreaSE5	:= SE5->(GetArea())
Local nRecSE1	:= SE1->(RECNO())
Local nRecSA1	:= SA1->(RECNO())
Local	lAdto		:= .T.
Local	cCtaAd	:= ""
Local	nVlrAd	:= 0
Local	cHistAd	:= " "
Local	cOriAd	:= " "
Local	cItAd		:= " "
LOcal cTipoAtu	:= " "
Local cCtaCli	:= " "
Local	cCtaTit	:= " "
Local	nVlrTit	:= 0
Local	cHistTit	:= " "
Local	cOriTit	:= " "
Local	cItTIT	:= " "
Local cFilatu	:= " "
Local cConta	:= " "

Local cCtaDecO	:= " "					// Conta do Decrescimo Obtido (constante no NCC/RA)
Local nDecreO	:= 0						// Valor do Decrescimo Obtido (constante no NCC/RA)
Local cCtaDecC	:= " "					// Conta do Decrescimo Concedido (constante no título)
Local nDecreC	:= 0						// Valor do Decrescimo Concedido (constante no título)
Local nCorrec	:= 0						// Valor da Variacao Cambial

Local cCtaAcrP	:= " "					// Conta do Acrescimo Pago (constante no NCC/RA)
Local nAcreP	:= 0						// Valor do Acrescimo Pago (constante no NCC/RA)
Local cCtaAcrO	:= " "					// Conta do Acrescimo Obtido (constante no título)
Local nAcreO	:= 0						// Valor do Acrescimo Obtido (constante no título)
Local nOriSE5	:= SE5->(Recno())		// Guarda o registro do SE5 original
Local nTamChave:= TAMSX3("E1_PREFIXO")[1]+TAMSX3("E1_NUM")[1]+TAMSX3("E1_PARCELA")[1]+TAMSX3("E1_TIPO")[1]
Local cChvSE5	:= ""						// Chave de pesquisa do SE5
Local lAchoSE5	:= .F.					// Identificador de localização
Local cCCAdt	:= ""
Local cCCTit	:= ""

Local cChavePri	:= ""
Local cChaveSe1	:= SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
Local lContabil	:= .T.
Local cQryTit		:= " "
Local cQryAdt		:= " "
Local nSe1Rec		:= 0
Default cTipo		:= "I"				// Tipo de processo I=Inclusão C=Cancelamento

If Type("STRLCTPAD") == "U"
	STRLCTPAD := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
Endif
cChavePri	 := STRLCTPAD

If SUBSTR(cChavePri,12,3) == "NCC"
	If Alltrim(Upper(Posicione("SE1",1,xFilial("SE1")+cChavePri,"E1_ORIGEM"))) <> "FINA040"
		lContabil := .F.
	EndIf
ElseIf SUBSTR(cChaveSe1,12,3) == "NCC"
	If Alltrim(Upper(Posicione("SE1",1,xFilial("SE1")+cChaveSe1,"E1_ORIGEM"))) <> "FINA040"
		lContabil := .F.
	EndIf
EndIf

// 26.09.05 - Almir Bandina
// No processo off-line, os arquivos SE1 e SE5 sempre estão posicionados no RA
// e na variável STRLCTPAD tem os dados do título compensado.
// Quando for a opção VLRAD usar SE5
// Quando for a opção VLRTI usar STRLCTPAD para posicionar
If lContabil
	nDecreO	:= SE5->E5_VLDESCO
	cCtaDecO	:= "  "
	nAcreP	:= SE5->E5_VLJUROS
	cCtaAcrP	:= " "
	nCorrec	:= SE5->E5_VLCORRE
	// Posiciona no fornecedor para pegar a conta a débito
	dbSelectArea("SA1")
	MsSeek(xFilial("SA1")+SE5->E5_CLIFOR+SE5->E5_LOJA)
	// Posiciona na natureza para pegar a conta a crédito
	dbSelectArea("SED")
	dbSetorder(1)
	MsSeek(xFilial("SED")+SE5->E5_NATUREZ)
	// Posiciona no título principal (NF)
	dbSelectArea("SE1")
	dbSetOrder(1)
	If cTipo == "C"
		MsSeek(xFilial("SE1")+SubStr(SE5->E5_DOCUMEN,1,14))
	Else
		MsSeek(xFilial("SE1")+SubStr(STRLCTPAD,1,14))
	EndIf
	
	If cOpcao $ "CADT#HADT#OADT#VLRAD#ITADT#VLDESCO#CTDESCO#VLACREP#CTACREP#CCADT#CVMTIT#VVMTIT"
		// Define a conta do titulo
		cCtaAd	:= SED->ED_DEBITO
		nVlrAd	:= SE5->E5_VALOR+nDecreO-nAcreP+nCorrec
		cHistAd	:= If(cTipo=="C","CANC.","")+"CMP ADTO "+SE5->E5_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA1->A1_NOME)
		nSe1Rec	:= SE1->(Recno())
		DbSelectArea("SE1")
		DbSetOrder(1)
		If MsSeek(SE5->(E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA))
			cItAd		:= "001"+SE1->E1_MSFIL+"0"
		EndIf
		DbGoTo(nSe1Rec)
		
	ElseIf cOpcao  $ "CTIT#HTIT#OTIT#VLRTI#ITTIT#VLDESCC#CTDESCC#VLACREO#CTACREO#CCTIT#CVMADT#VVMAD"
		// Define a conta do titulo
		cCtaTit	:= SA1->A1_CONTA
		nVlrTit	:= SE5->E5_VALOR+nDecreC-nAcreO+nCorrec
		cHistTit	:= If(cTipo=="C","CANC.","")+"CMP TIT "+SE1->E1_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA1->A1_NOME)
		cItTIT	:= "001"+SE1->E1_MSFIL+"0"
	EndIf
	cOriTit	:= SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_TIPO
	
	// Define a conta e valor da variação monetária
	If cOpcao $ "CVMADD#CVMTIC#HVMAD"
		// Debita Cliente ou Adiantamento
		If nCorrec > 0
			cCtaVM	:= SA1->A1_CONTA
		Else
			cCtaVM	:= SED->ED_DEBITO
		EndIf
		cHistVM	:= If(cTipo=="C","CANC.","")+"VC TIT "+SE1->E1_PREFIXO+" "+SE1->E1_NUM+" "+SE1->E1_PARCELA+" "+ALLTRIM(SA1->A1_NOME)
	ElseIf cOpcao $ "CVMADC#CVMTID#HVMTI"
		// Credito Variação
		If nCorrec > 0
			cCtaVM	:= "56120001"
		Else
			cCtaVM := "56110001"
		EndIf
		cHistVM	:= If(cTipo=="C","CANC.","")+"VC ADTO "+SE5->E5_PREFIXO+" "+SE5->E5_NUMERO+" "+SE5->E5_PARCELA+" "+ALLTRIM(SA1->A1_NOME)
	EndIf
	If cOpcao == "VVMAD#VVMTI"
		nVlrVM	:= Abs(nCorrec)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³CADT - Retorno conta de credito Adto                  ³
//³CTIT - Retorno conta de debito Cliente           		³
//³HADT - Historico do RA/NCC                            ³
//³HTIT - Historico do Titulo                            ³
//³OADT - Origem do Adiantamento                         ³
//³OTIT - Origem do Titulo                               ³
//³VLRAD - Valor da compensacao Adto                     ³
//³VLRTI - Valor da compensacao titulo                   ³
//|ITADT - Item contabil do adiantamento						³
//|ITTIT - Item contabil do titulo       						³
//|CORTI - Variacao cambial do titulo    						³
//|CORAD - Variacao cambial do RA/NCC    						³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cOpcao  == "CADT"
	cRetorno	:= cCtaAd
ElseIf cOpcao == "CTIT"
	cRetorno	:= cCtaTit
ElseIf cOpcao	== "HADT"
	cRetorno	:= cHistAd
ElseIf cOpcao == "HTIT"
	cRetorno	:= cHistTit
ElseIf cOpcao == "OADT"
	cRetorno	:= cOriAd
ElseIf cOpcao	== "OTIT"
	cRetorno	:= cOriTit
ElseIf cOpcao == "VLRAD"
	cRetorno	:= nVlrAd
ElseIf cOpcao == "VLRTI"
	cRetorno	:= nVlrtit
ElseIf cOpcao	== "ITADT"
	cRetorno	:= cItAd
ElseIf cOpcao == "ITTIT"
	cRetorno	:= cItTit
ElseIf cOpcao == "CCADT"
	cRetorno	:= cCCAdt
ElseIf cOpcao == "CCTIT"
	cRetorno	:= cCCTit
ElseIf cOpcao	$ "VVMAD#VVMTI"
	cRetorno	:= nVlrVM
ElseIf cOpcao $ "CVMADD#CVMADC#CVMTID#CVMTIC"
	cRetorno := cCtaVM
ElseIf cOpcao $ "HVMAD#HVMTI"
	cRetorno := cHistVM
Else
	cRetorno	:= " "
EndIf

RestArea(aAreaSA1)
RestArea(aAreaSE1)
RestArea(aAreaSED)
RestArea(aAreaSE5)
RestArea(aArea)

Return(cRetorno)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BCOPA     ºAutor  ³Andreza Favero      º Data ³  05/26/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traz a conta contabil do banco para os titulos de PA.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function BcoPA()

Local aArSE2	:= SE2->(GetArea())
Local aArSE5	:= SE5->(GetArea())
Local aArea		:= GetArea()
Local cCtaBco	:= " "
Local cQuery	:= " "
Local cPrefixo	:= SE2->E2_PREFIXO
Local cNum		:= SE2->E2_NUM
Local cParcela	:= SE2->E2_PARCELA
Local cTipoTit	:= SE2->E2_TIPO
Local CTABCO	:= " "

cQuery	:= "SELECT A6_CONTA AS CTABCO "
cQuery	+= " FROM "+RetSqlName("SE5")+" SE5,"+RetSqlName("SA6")+" SA6 WHERE "
cQuery	+= " SE5.E5_FILIAL = '"+xFilial("SE5")+"' AND"
cQuery	+= " SA6.A6_FILIAL = '"+xFilial("SA6")+"' AND"
cQuery	+= " SE5.E5_PREFIXO = '"+cPrefixo+"' AND"
cQuery	+= " SE5.E5_NUMERO = '"+cNum+"' AND"
cQuery	+= " SE5.E5_PARCELA = '"+cParcela+"' AND"
cQuery	+= " SE5.E5_TIPO = '"+cTipoTit+"' AND"
cQuery	+= " SE5.E5_BANCO = SA6.A6_COD AND"
cQuery	+= " SE5.E5_AGENCIA = SA6.A6_AGENCIA AND"
cQuery	+= " SE5.E5_CONTA = SA6.A6_NUMCON AND"
cQuery	+= " SE5.E5_TIPODOC IN ('PA','ES') AND "
cQuery	+= " SE5.E5_MOTBX	= 'NOR' AND "
cQuery	+= " SE5.D_E_L_E_T_ <> '*' AND"
cQuery	+= " SA6.D_E_L_E_T_ <> '*'"

If Select("CTBCO") > 0
	DbSelectArea("CTBCO")
	DbCloseArea()
Endif

TCQUERY cQuery NEW ALIAS "CTBCO"

dbSelectArea("CTBCO")
dbGotop()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a string de retorno³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()
	cCtaBco := CTBCO->CTABCO
	dbSkip()
End

dbCloseArea()

RestArea(aArSe2)
RestArea(aArSe5)
RestArea(aArea)

Return(cCtaBco)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLRBX     ºAutor  ³Andreza Favero      º Data ³  05/26/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traz o valor a ser contabilizado na baixa de titulos.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CtBx()

Local aArea	:= GetArea()
Local aArSe2:= SE2->(GetArea())
Local aArSe5:= SE5->(GetArea())
Local lcontab	:= .t.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³O tratamento abaixo foi necessario tendo em vista que é necessário      ³
//³que o parâmetro MV_CTBAIXA esteja como "Ambos".                         ³
//³Nesta situacao o sistema contabiliza tanto a baixa do título (530) como ³
//³o cheque (590) duplicando valores na contabilidade.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !SE5->E5_MOTBX$"FAT/CMP"
	If SE5->E5_MOTBX<>"NOR" .OR. (SE5->E5_TIPODOC =="VL" .and. Empty(SE5->E5_NUMCHEQ)) .OR. !Empty(SE5->E5_LOTE)
		lContab	:= .t.
	Else
		lContab	:= .f.
	EndIf
Else
	lcontab	:= .f.
EndIf  

Return(lContab)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CustDev   ºAutor  ³Andreza Favero      º Data ³  10/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traz o valor do custo da Nfiscal de origem.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CustDev()

Local aArea		:= GetArea()
Local nCusto	:= 0

If SD2->D2_CUSTO1 == 0
	DbSelectArea("SD1")
	DbSetOrder(1)
	If MsSeek(SD2->(D2_FILIAL+D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEMORI))
		nCusto	:= SD1->(D1_CUSTO / D1_QUANT) * SD2->D2_QUANT 
	Else
		nCusto	:= SD2->(D2_TOTAL+D2_ICMSRET+D2_VALIPI+D2_DESPESA+D2_VALFRE+D2_SEGURO)
	EndIf
Else
	nCusto	:= SD2->D2_CUSTO1
EndIf


RestArea(aArea)

Return(nCusto)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CcOrig    ºAutor  ³Andreza Favero      º Data ³  10/11/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Traz o valor o centro de custo de origem.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCOrig()

Local aArea		:= GetArea()
Local cCusto	:= " "

DbSelectArea("SD1")
DbSetOrder(1)
If MsSeek(SD2->(D2_FILIAL+D2_NFORI+D2_SERIORI+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEMORI))
	cCusto	:= SD1->D1_CC
Else
	cCusto	:= SD2->D2_CCUSTO
EndIf

RestArea(aArea)

Return(cCusto)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlrFor    ºAutor  ³Andreza Favero      º Data ³  08/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o valor a ser contabilizado para o fornecedor no      º±±
±±º          ³documento de entrada.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VlrFor()

Local aArea	:= GetArea()
Local nVlrFor:= 0

If SD1->D1_TIPO $ "PI" // OMB - 05/01/06 - desconsiderar D1_TOTAL nos complementos de impostos (nesses casos, D1_TOTAL e igual ao imposto, duplicando o valor no fornecedor)
	nVlrFor	:= SD1->(D1_VALIPI+D1_ICMSRET+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC)-U_RETTIT("ISS")-U_RETTIT("INS")-U_RETTIT("IRF") - U_RETTIT("PIS") - U_RETTIT("COF")- U_RETTIT("CSL")
Else
	nVlrFor	:= SD1->(D1_TOTAL+D1_VALIPI+D1_ICMSRET+D1_VALFRE+D1_DESPESA+D1_SEGURO-D1_VALDESC)-U_RETTIT("ISS")-U_RETTIT("INS")-U_RETTIT("IRF") - U_RETTIT("PIS") - U_RETTIT("COF")- U_RETTIT("CSL")
EndIf

RestArea(aArea)

Return(nVlrFor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetTitFIN ºAutor  ³Andreza Favero      º Data ³  22/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula o valor de retencao do titulo baseado no contas a  º±±
±±º          ³ pagar.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ mp8                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAlteracoes³ Elias Reis - 25/09/07 - Inseri o parametro da busca nos    º±±
±±º          ³              titulos buscando tb o recn. Estava dando prob-º±±
±±º          ³              blema quando um titulo era lancado e excluido º±±
±±º          ³              diversas vezes e com retencoes diferentes.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Opcoes possiveis³
//³PIS - Pis retido³
//³COF - Cofins ret|
//³CSL - Csçç retid³
// ISS - ISS retido
// IRF	- Impostos de renda
// INS	- Impostos de renda
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function RetTitFin(cOpcao)

Local aArea	    := GetArea()
Local aAreaE2	:= SE2->(GetArea())
Local cQryPIS	:= " "
Local cQryCOF	:= " "
Local cQryCSL	:= " "
Local cQryIss	:= " "
Local cQryIrf	:= " "
Local nValor    := 0
Local cFilNot	:= SE2->E2_FILIAL
Local cSerie	:= SE2->E2_PREFIXO
Local cNum 		:= SE2->E2_NUM
Local cFornec	:= SE2->E2_FORNECE
Local cLoja		:= SE2->E2_LOJA
Local cForTX	:= GetMv("MV_UNIAO")
Local cForIss	:= GetMv("MV_MUNIC")
Local cForIns	:= GetMv("MV_FORINSS")
Local cNatPis 	:= GetMv("MV_PISNAT")
Local cNatCof	:= GetMv("MV_COFINS")
Local cNatCsll	:= GetMv("MV_CSLL")
Local cNatISS	:= GetMv("MV_ISS")
Local cNatIrf	:= GetMv("MV_IRF")
Local cNatIns	:= GetMv("MV_INSS")
Local cDelet	:= IIf(Inclui, " ","*")

Local nSE2Rec   := SE2->(Recno())    

cNatIrf	:= StrTran(cNatIrf,'"',"")
cNatIns	:= StrTran(cNatIns,'"',"")
cNatIss	:= StrTran(cNatIss,'"',"")


If cOpcao == "COF"
	cQryCOF := " SELECT E2_VALOR AS COFINS FROM "+RetSqlName("SE2")+" SE2COF "
	cQryCOF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCOF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCOF += " AND E2_TIPO = 'TX'  "
	cQryCOF += " AND E2_NATUREZ ='"+cNatCof+"' AND "
	cQryCOF += " E2_PARCELA = (SELECT MAX(E2_PARCCOF) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCOF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCOF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCOF += "					  AND E2_NUM = '"+cNum+"' "
	cQryCOF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCOF += "					  AND E2_LOJA = '"+cLoja+"' " 
	
	cQryCOF += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""
	
	cQryCOF += "					  AND E2_TIPO <>'TX' "
	cQryCOF += "					  AND E2_PARCCOF <> ' ' "
	cQryCOF += "					  AND SE2COF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCOF += "					  AND SE2COF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCOF += "					  AND SE2COF.E2_PARCELA = SE2TIT.E2_PARCCOF "
	cQryCOF += "					  AND SE2COF.E2_VALOR = SE2TIT.E2_VRETCOF "
	cQryCOF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCOF += "					  AND SE2COF.D_E_L_E_T_= '"+cDelet+"') "
	cQryCOF += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "
	cQryCof += " AND SE2COF.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryCof += " FROM "+RetSqlName("SE2")+" A "
	cQryCof += " WHERE SE2COF.E2_FILIAL=A.E2_FILIAL "
	cQryCof += " AND SE2COF.E2_PREFIXO=A.E2_PREFIXO "
	cQryCof += " AND SE2COF.E2_NUM=A.E2_NUM "
	cQryCof += " AND SE2COF.E2_PARCELA=A.E2_PARCELA "
	cQryCof += " AND SE2COF.E2_TIPO=A.E2_TIPO "
	cQryCof += " AND SE2COF.E2_FORNECE =A.E2_FORNECE "
	cQryCof += " AND SE2COF.E2_LOJA =A.E2_LOJA  "
	cQryCof += " AND SE2COF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCof += " AND SE2COF.D_E_L_E_T_='"+cDelet+"' "
	cQryCof += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	If Select("TMPCOF") > 0
		DbSelectArea("TMPCOF")
		DbCloseArea()
	Endif
	
	//		MEMOWRIT("RCTBR04.SQL",cQryCOF)
	
	TCQUERY cQryCOF NEW ALIAS "TMPCOF"
	
	dbSelectArea("TMPCOF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCOF->COFINS
		dbSelectArea("TMPCOF")
		dbSkip()
	End
	
	dbSelectArea("TMPCOF")
	dbCloseArea()
	
ElseIf cOpcao == "PIS"
	
	cQryPIS := " SELECT E2_VALOR AS PIS FROM "+RetSqlName("SE2")+" SE2PIS "
	cQryPIS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryPIS += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryPIS += " AND E2_TIPO = 'TX'  "
	cQryPIS += " AND E2_NATUREZ ='"+cNatPIS+"' AND "
	cQryPIS += " E2_PARCELA = (SELECT MAX(E2_PARCPIS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryPIS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryPIS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryPIS += "					  AND E2_NUM = '"+cNum+"' "
	cQryPIS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryPIS += "					  AND E2_LOJA = '"+cLoja+"' "

	cQryPIS += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""

	cQryPIS += "					  AND E2_TIPO <>'TX' "
	cQryPIS += "					  AND E2_PARCPIS <> ' ' "
	cQryPIS += "					  AND SE2PIS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryPIS += "					  AND SE2PIS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryPIS += "					  AND SE2PIS.E2_PARCELA = SE2TIT.E2_PARCPIS "
	cQryPIS += "					  AND SE2PIS.E2_VALOR = SE2TIT.E2_VRETPIS "
	cQryPIS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += "					  AND SE2PIS.D_E_L_E_T_='"+cDelet+"') "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND SE2PIS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryPIS += " FROM "+RetSqlName("SE2")+" A "
	cQryPIS += " WHERE SE2PIS.E2_FILIAL=A.E2_FILIAL "
	cQryPIS += " AND SE2PIS.E2_PREFIXO =A.E2_PREFIXO "
	cQryPIS += " AND SE2PIS.E2_NUM =A.E2_NUM "
	cQryPIS += " AND SE2PIS.E2_PARCELA =A.E2_PARCELA "
	cQryPIS += " AND SE2PIS.E2_TIPO =A.E2_TIPO "
	cQryPIS += " AND SE2PIS.E2_FORNECE =A.E2_FORNECE "
	cQryPIS += " AND SE2PIS.E2_LOJA =A.E2_LOJA  "
	cQryPIS += " AND SE2PIS.E2_VALOR =A.E2_VALOR  "
	cQryPIS += " AND SE2PIS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryPIS += " AND SE2PIS.D_E_L_E_T_='"+cDelet+"' "
	cQryPIS += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	If Select("TMPPIS") > 0
		DbSelectArea("TMPPIS")
		DbCloseArea()
	Endif
	
	TCQUERY cQryPIS NEW ALIAS "TMPPIS"
	
	dbSelectArea("TMPPIS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPPIS->PIS
		dbSelectArea("TMPPIS")
		dbSkip()
	End
	
	dbSelectArea("TMPPIS")
	dbCloseArea()
	
	
ElseIf cOpcao == "CSL"
	
	cQryCSL := " SELECT E2_VALOR AS CSL FROM "+RetSqlName("SE2")+" SE2CSL "
	cQryCSL += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryCSL += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryCSL += " AND E2_TIPO = 'TX'  "
	cQryCSL += " AND E2_NATUREZ ='"+cNatCSLL+"' AND "
	cQryCSL += " E2_PARCELA = (SELECT MAX(E2_PARCSLL) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryCSL += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryCSL += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryCSL += "					  AND E2_NUM = '"+cNum+"' "
	cQryCSL += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryCSL += "					  AND E2_LOJA = '"+cLoja+"' "
	
	cQryCSL += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""

	cQryCSL += "					  AND E2_TIPO <>'TX' "
	cQryCSL += "					  AND E2_PARCSLL <> ' ' "
	cQryCSL += "					  AND SE2CSL.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryCSL += "					  AND SE2CSL.E2_NUM 	= SE2TIT.E2_NUM "
	cQryCSL += "					  AND SE2CSL.E2_PARCELA = SE2TIT.E2_PARCSLL "
	cQryCSL += "					  AND SE2CSL.E2_VALOR = SE2TIT.E2_VRETCSL "
	cQryCSL += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += "					  AND SE2CSL.D_E_L_E_T_='"+cDelet+"' )"
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND SE2CSL.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryCSL += " FROM "+RetSqlName("SE2")+" A "
	cQryCSL += " WHERE SE2CSL.E2_FILIAL=A.E2_FILIAL "
	cQryCSL += " AND SE2CSL.E2_PREFIXO =A.E2_PREFIXO "
	cQryCSL += " AND SE2CSL.E2_NUM =A.E2_NUM "
	cQryCSL += " AND SE2CSL.E2_PARCELA =A.E2_PARCELA "
	cQryCSL += " AND SE2CSL.E2_TIPO =A.E2_TIPO "
	cQryCSL += " AND SE2CSL.E2_FORNECE =A.E2_FORNECE "
	cQryCSL += " AND SE2CSL.E2_LOJA =A.E2_LOJA  "
	cQryCSL += " AND SE2CSL.E2_VALOR =A.E2_VALOR  "
	cQryCSL += " AND SE2CSL.E2_NATUREZ =A.E2_NATUREZ  "
	cQryCSL += " AND SE2CSL.D_E_L_E_T_='"+cDelet+"' "
	cQryCSL += " AND A.D_E_L_E_T_='"+cDelet+"')"
	
	If Select("TMPCSL") > 0
		DbSelectArea("TMPCSL")
		DbCloseArea()
	Endif
	
	TCQUERY cQryCSL NEW ALIAS "TMPCSL"
	
	dbSelectArea("TMPCSL")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPCSL->CSL
		dbSelectArea("TMPCSL")
		dbSkip()
	End
	
	dbSelectArea("TMPCSL")
	dbCloseArea()
	
ElseIf cOpcao == "ISS"
	cQryISS := " SELECT E2_VALOR AS ISS FROM "+RetSqlName("SE2")+" SE2ISS "
	cQryISS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryISS += " AND E2_FORNECE = '"+cForISS+"'  "
	cQryISS += " AND E2_TIPO = 'ISS'  "
	cQryISS += " AND E2_NATUREZ ='"+cNatISS+"' AND "
	cQryISS += " E2_PARCELA = (SELECT MAX(E2_PARCISS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryISS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryISS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryISS += "					  AND E2_NUM = '"+cNum+"' "
	cQryISS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryISS += "					  AND E2_LOJA = '"+cLoja+"' "

	cQryISS += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""

	cQryISS += "					  AND E2_TIPO <>'TX' "
	cQryISS += "					  AND E2_PARCISS <> ' ' "
	cQryISS += "					  AND SE2ISS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryISS += "					  AND SE2ISS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryISS += "					  AND SE2ISS.E2_PARCELA = SE2TIT.E2_PARCISS "
	cQryISS += "					  AND SE2ISS.E2_VALOR = SE2TIT.E2_ISS "
	cQryISS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += "					  AND SE2ISS.D_E_L_E_T_= '"+cDelet+"') "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND SE2ISS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryISS += " FROM "+RetSqlName("SE2")+" A "
	cQryISS += " WHERE SE2ISS.E2_FILIAL=A.E2_FILIAL "
	cQryISS += " AND SE2ISS.E2_PREFIXO =A.E2_PREFIXO "
	cQryISS += " AND SE2ISS.E2_NUM =A.E2_NUM "
	cQryISS += " AND SE2ISS.E2_PARCELA =A.E2_PARCELA "
	cQryISS += " AND SE2ISS.E2_TIPO =A.E2_TIPO "
	cQryISS += " AND SE2ISS.E2_FORNECE =A.E2_FORNECE "
	cQryISS += " AND SE2ISS.E2_LOJA =A.E2_LOJA  "
	cQryISS += " AND SE2ISS.E2_VALOR =A.E2_VALOR  "
	cQryISS += " AND SE2ISS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryISS += " AND SE2ISS.D_E_L_E_T_='"+cDelet+"' "
	cQryISS += " AND A.D_E_L_E_T_='"+cDelet+"')"
	
	
	If Select("TMPISS") > 0
		DbSelectArea("TMPISS")
		DbCloseArea()
	Endif
	
	TCQUERY cQryISS NEW ALIAS "TMPISS"
	
	dbSelectArea("TMPISS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPISS->ISS
		dbSelectArea("TMPISS")
		dbSkip()
	End
	
	dbSelectArea("TMPISS")
	dbCloseArea()
	
ElseIf cOpcao == "IRF"
	
	cQryIRF := " SELECT E2_VALOR AS IRF FROM "+RetSqlName("SE2")+" SE2IRF "
	cQryIRF += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryIRF += " AND E2_FORNECE = '"+cForTX+"'  "
	cQryIRF += " AND E2_TIPO = 'TX'  "
	cQryIRF += " AND E2_NATUREZ ='"+cNatIRF+"' AND "
	cQryIRF += " E2_PARCELA = (SELECT MAX(E2_PARCIR) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryIRF += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryIRF += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryIRF += "					  AND E2_NUM = '"+cNum+"' "
	cQryIRF += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryIRF += "					  AND E2_LOJA = '"+cLoja+"' "

	cQryIRF += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""

	cQryIRF += "					  AND E2_TIPO <>'TX' "
	cQryIRF += "					  AND E2_PARCIR <> ' ' "
	cQryIRF += "					  AND SE2IRF.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryIRF += "					  AND SE2IRF.E2_NUM 	= SE2TIT.E2_NUM "
	cQryIRF += "					  AND SE2IRF.E2_PARCELA = SE2TIT.E2_PARCIR "
	cQryIRF += "					  AND SE2IRF.E2_VALOR = SE2TIT.E2_IRRF "
	cQryIRF += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += "					  AND SE2IRF.D_E_L_E_T_= '"+cDelet+"') "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND SE2IRF.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryIRF += " FROM "+RetSqlName("SE2")+" A "
	cQryIRF += " WHERE SE2IRF.E2_FILIAL=A.E2_FILIAL "
	cQryIRF += " AND SE2IRF.E2_PREFIXO =A.E2_PREFIXO "
	cQryIRF += " AND SE2IRF.E2_NUM =A.E2_NUM "
	cQryIRF += " AND SE2IRF.E2_PARCELA =A.E2_PARCELA "
	cQryIRF += " AND SE2IRF.E2_TIPO =A.E2_TIPO "
	cQryIRF += " AND SE2IRF.E2_FORNECE =A.E2_FORNECE "
	cQryIRF += " AND SE2IRF.E2_LOJA =A.E2_LOJA  "
	cQryIRF += " AND SE2IRF.E2_VALOR =A.E2_VALOR "
	cQryIRF += " AND SE2IRF.E2_NATUREZ =A.E2_NATUREZ  "
	cQryIRF += " AND SE2IRF.D_E_L_E_T_='"+cDelet+"' "
	cQryIRF += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	
	If Select("TMPIRF") > 0
		DbSelectArea("TMPIRF")
		DbCloseArea()
	Endif
	
	
	TCQUERY cQryIRF NEW ALIAS "TMPIRF"
	
	dbSelectArea("TMPIRF")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPIRF->IRF
		dbSelectArea("TMPIRF")
		dbSkip()
	End
	
	dbSelectArea("TMPIRF")
	dbCloseArea()
	
	
ElseIf cOpcao == "INS"
	
	cQryINS := " SELECT E2_VALOR AS INS FROM "+RetSqlName("SE2")+" SE2INS "
	cQryINS += " WHERE E2_FILIAL= '"+xFilial("SE2")+"' "
	cQryINS += " AND E2_FORNECE = '"+cForIns+"'  "
	cQryINS += " AND E2_TIPO = 'INS'  "
	cQryINS += " AND E2_NATUREZ ='"+cNatIns+"' AND "
	cQryINS += " E2_PARCELA = (SELECT MAX(E2_PARCINS) FROM "+RetSqlName("SE2")+" SE2TIT "
	cQryINS += "   		   	  WHERE E2_FILIAL='"+xFilial("SE2")+"' "
	cQryINS += "					  AND E2_PREFIXO ='"+cSerie+"'  "
	cQryINS += "					  AND E2_NUM = '"+cNum+"' "
	cQryINS += "					  AND E2_FORNECE = '"+cFornec+"' "
	cQryINS += "					  AND E2_LOJA = '"+cLoja+"' "

	cQryINS += "                      AND SE2TIT.R_E_C_N_O_ = "+StrZero(nSE2Rec,15)+""

	cQryINS += "					  AND E2_TIPO <>'TX' "
	cQryINS += "					  AND E2_PARCINS <> ' ' "
	cQryINS += "					  AND SE2INS.E2_PREFIXO = SE2TIT.E2_PREFIXO "
	cQryINS += "					  AND SE2INS.E2_NUM 	= SE2TIT.E2_NUM "
	cQryINS += "					  AND SE2INS.E2_PARCELA = SE2TIT.E2_PARCINS "
	cQryINS += "					  AND SE2INS.E2_VALOR = SE2TIT.E2_INSS "
	cQryINS += "					  AND SE2TIT.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += "					  AND SE2INS.D_E_L_E_T_= '"+cDelet+"') "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND SE2INS.R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) MAXRECNO
	cQryINS += " FROM "+RetSqlName("SE2")+" A "
	cQryINS += " WHERE SE2INS.E2_FILIAL=A.E2_FILIAL "
	cQryINS += " AND SE2INS.E2_PREFIXO =A.E2_PREFIXO "
	cQryINS += " AND SE2INS.E2_NUM =A.E2_NUM "
	cQryINS += " AND SE2INS.E2_PARCELA =A.E2_PARCELA "
	cQryINS += " AND SE2INS.E2_TIPO =A.E2_TIPO "
	cQryINS += " AND SE2INS.E2_FORNECE =A.E2_FORNECE "
	cQryINS += " AND SE2INS.E2_LOJA =A.E2_LOJA  "
	cQryINS += " AND SE2INS.E2_VALOR =A.E2_VALOR "
	cQryINS += " AND SE2INS.E2_NATUREZ =A.E2_NATUREZ  "
	cQryINS += " AND SE2INS.D_E_L_E_T_='"+cDelet+"' "
	cQryINS += " AND A.D_E_L_E_T_='"+cDelet+"') "
	
	
	If Select("TMPINS") > 0
		DbSelectArea("TMPINS")
		DbCloseArea()
	Endif
	
	
	TCQUERY cQryINS NEW ALIAS "TMPINS"
	
	dbSelectArea("TMPINS")
	dbGotop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta a string de retorno³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof()
		nValor += TMPINS->INS
		dbSelectArea("TMPINS")
		dbSkip()
	End
	
	dbSelectArea("TMPINS")
	dbCloseArea()
	
EndIf

RestArea(aAreaE2)
RestArea(aArea)

Return(nValor)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlrFor    ºAutor  ³Andreza Favero      º Data ³  08/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta o valor a ser contabilizado para o fornecedor no      º±±
±±º          ³documento de entrada.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function VlrForTit()

Local aArea	:= GetArea()
Local nValor	:= 0

//msgalert()

nValor := SE2->(E2_VLCRUZ+E2_IRRF+E2_INSS+E2_ISS)+U_RETTITFIN("PIS")+U_RETTITFIN("COF")+U_RETTITFIN("CSL")

RestArea(aArea)

Return(nValor)   




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³vlreic    ºAutor  ³rodolfo gaboardi     º Data ³  08/12/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta valor para buscar despezas no eic                     º±±
±±º          ³documento de entrada.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function VlrEic()

Local aArea	:= GetArea()
Local nValor := 0
local _nVLDEIC := 0
//msgalert()        

                                                 
DBSELECTAREA("SW6")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SW6")+ALLTRIM(SD1->D1_CONHEC))

  IF SD1->D1_ITEM == '0001'

    DBSELECTAREA("EIJ")
    DBSETORDER(1)
    DBSEEK(XFILIAL("EIJ")+ALLTRIM(SW6->W6_HAWB)) 
    _nVLDEIC:=EIJ->EIJ_VLMMN
  ENDIF
ENDIF
  
RestArea(aArea)

Return(_nVLDEIC)  



User Function VlEic2()

Local aArea	    := GetArea()
Local nValor2   := 0
Local _nVLDEIC2 :=0
local _VLRDEIC  := 0
//msgalert()        

                                                 
DBSELECTAREA("SW6")
DBSETORDER(1)
IF DBSEEK(XFILIAL("SW6")+ALLTRIM(SD1->D1_CONHEC))

  IF SD1->D1_ITEM == '0001'

    DBSELECTAREA("EIJ")
    DBSETORDER(1)
    DBSEEK(XFILIAL("EIJ")+ALLTRIM(SW6->W6_HAWB)) 
    _nVLDEIC2:=EIJ->EIJ_VLMMN
    _VLRDEIC := SF1->F1_VALBRUT - _nVLDEIC2
  
  ENDIF
ENDIF
  
RestArea(aArea)

RETURN(_VLRDEIC)


