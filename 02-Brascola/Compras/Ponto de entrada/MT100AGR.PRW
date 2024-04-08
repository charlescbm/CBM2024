#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT100AGR ³ Autor ³ Thiago (Onsten)       ³ Data ³ 08/04/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ PE que envia email a usuarios qdo for devolução            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT100AGR()
************************
Local aAreaAtu:= GetArea()
Local cTipMail:= ""
Local cEmail  := ""
Local cQuery  := ""
Local cTxtMail:= ""
Local cEmailAux:= ""
Local cAssuntAx:= ""

Private lListaNF:= .f.

_nRecSE1:= SE1->(RECNO())
_nRecSD1:= SD1->(RECNO())
_nRecSF1:= SF1->(RECNO())
lInclui := INCLUI 

If lInclui .And. SF1->F1_TIPO =="D" .And. SF1->F1_FILIAL =="01"  .AND. SF1->F1_FORMUL =='S'
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	MsSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
	If Found()
		DbSelectArea("SA3")
		DbSetOrder(1)
		MsSeek(xFilial("SA3")+SA1->A1_VEND)
		If Found()
			If At("@",SA3->A3_EMAIL)>0
				cEmail+= Alltrim(SA3->A3_EMAIL)+"; " //envia copia do email para vendedor
			EndIf
			
			MsSeek(xFilial("SA3")+SA1->A1_SUPER)
			If Found()
				If At("@",SA3->A3_EMAIL)>0
					cEmail+= Alltrim(SA3->A3_EMAIL)+"; " //envia copia do email para supervisor
				EndIf
			EndIf
		EndIf
	EndIf
	
	//cEmail:= SubStr(cEmail,1,Len(cEmail)-1) //tira o ultimo ';'
		
	cEmail:= "marcia.souza@brascola.com.br;cmoreira@brascola.com.br"
	
	If !Empty(cEmail)
		EnvMailDev(cEmail)
	EndIf
	
//	dbSelectArea("SZGS")
//	dbCloseArea()
EndIf


DbSelectArea("SF1")
DbGoTo(_nRecSF1)

If lInclui .And. SF1->F1_TIPO=="D" //.And. SF1->F1_FILIAL=="04"
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	MsSeek(xFilial("SF2")+SD1->D1_NFORI+SD1->D1_SERIORI)
	
	cTxtMail := " "
	cTxtMail += "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
	cTxtMail += "<html>"
	cTxtMail += "<head>"
	cTxtMail += "<title>Documento sem t&iacute;tulo</title>"
	cTxtMail += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	cTxtMail += "</head>"
	cTxtMail += "<body>"
	cTxtMail += "   <tr><font face='Tahoma' size='2'><b>Informações adicionais sobre devolução de nota fiscal</font></b></tr>"
	cTxtMail += "</body>"
	cTxtMail += "<body>"
	cTxtMail += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	cTxtMail += "</body>"
	
 	If SF1->F1_VALBRUT == SF2->F2_VALBRUT .AND. SF2->F2_TIPO = 'N'  .and. SF2->F2_DUPL <> ''
   
   //If SF1->F1_VALMERC == SF2->F2_VALMERC .AND. SF2->F2_TIPO = 'N'  .and. SF2->F2_DUPL <> ''
   
		
	  //U_CompNCC(_nRecSE1) //função para compensar titulo automaticamente
		
		//manda email que compensou
		cTxtMail += "<body>"
		cTxtMail += "   <td><font face='Tahoma' size='2'>- A nota fiscal "+AllTrim(SF1->F1_DOC)+" da serie "+Alltrim(SF1->F1_SERIE)+" foi devolvida hoje e o titulo foi compensado automaticamente com o titulo original "+AllTrim(SF2->F2_DOC)+"</font></tr>"
		cTxtMail += "</body>"
		
	Else
		
		//manda email do Select SE1 para ver se possui titulos em aberto
		
		cQrySE1 := " SELECT SE1.E1_TIPO,SE1.E1_PREFIXO,SE1.E1_NUM,SE1.E1_PARCELA,SE1.E1_CLIENTE,SE1.E1_LOJA, SE1.E1_VENCREA, SE1.E1_SALDO, SE1.E1_VALOR, ISNULL(E5_DOCUMEN,'') E5_DOCUMEN , ISNULL(E5_VALOR,0) E5_VALOR "
		cQrySE1	+= " FROM "+RetSqlName("SE1")+" SE1 "
		cQrySE1	+= " LEFT OUTER JOIN SE5010 ON SE1.E1_FILIAL = E5_FILIAL "
		cQrySE1	+= "   AND SE1.E1_CLIENTE = E5_CLIFOR  "
		cQrySE1	+= "   AND SE1.E1_LOJA = E5_LOJA       "
		cQrySE1	+= "   AND SE1.E1_PREFIXO = E5_PREFIXO "
		cQrySE1	+= "   AND SE1.E1_NUM = E5_NUMERO      "
		cQrySE1	+= "   AND SE1.E1_PARCELA = E5_PARCELA "
		cQrySE1	+= "   AND E5_DOCUMEN <> ''            "
		cQrySE1	+= "   AND SE5010.D_E_L_E_T_<> '*'        "
		cQrySE1	+= " WHERE SE1.E1_FILIAL = '"+xFilial("SE1")+"' "
		cQrySE1	+= "   AND SE1.E1_CLIENTE = '"+SF1->F1_FORNECE+"' "
		cQrySE1	+= "   AND SE1.E1_LOJA = '"+SF1->F1_LOJA+"' "
		cQrySE1	+= "   AND SE1.E1_SALDO > 0 "
		cQrySE1	+= "   AND SE1.D_E_L_E_T_ <> '*' "
		cQrySE1	+= " ORDER BY SE1.E1_TIPO,SE1.E1_NUM,SE1.E1_PARCELA "
		
		If Select("TRAB") > 0
			TRAB->(dbCloseArea())
		EndIf
		TCQUERY cQrySE1 NEW ALIAS "TRAB"
		
		dbSelectArea("TRAB")
		dbGotop()
		
		If Eof()
			//nao existe pendencia
			lListaNF:= .f.
		Else
			//relaciona as notas
			lListaNF:= .t.
		EndIf
		
		cTxtMail += "<body>"
		cTxtMail += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
		cTxtMail += "</body>"
		
		If lListaNF
			// Lista pendencias do TRAB->
			cTxtMail += "<body>"
			cTxtMail += "   <td><font face='Tahoma' size='2'>- A nota fiscal "+AllTrim(SF1->F1_DOC)+" da serie "+Alltrim(SF1->F1_SERIE)+" foi devolvida hoje e o cliente possui as seguintes duplicatas com saldo a pagar: </font></td>"
			cTxtMail += "</body>"
			
			cTxtMail += "<table border='1' cellspacing='1' width='90%'>"
			cTxtMail += "  <tbody>"
			cTxtMail += "    <tr>"
			cTxtMail += "      <td width='05%' align='left'   bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Tipo</font></b></td>"
			cTxtMail += "      <td width='14%' align='left'   bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Duplic./Parc.</font></b></td>"
			cTxtMail += "      <td width='14%' align='center' bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Vencto</font></b></td>"
			cTxtMail += "      <td width='14%' align='right'  bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Saldo a Pagar</font></b></td>"
			cTxtMail += "      <td width='19%' align='right'  bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Num NCC</font></b></td>"
			cTxtMail += "      <td width='14%' align='right'  bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>Valor NCC</font></b></td>"
			cTxtMail += "      <td width='10%' align='right'  bgcolor='#ffffcc'><font face='Tahoma' size='2'><b>NF Orig.</font></b></td>"
			cTxtMail += "    </tr>"
			
			nTotSald:= 0
			nTotValo:= 0
			
			DbSelectArea("TRAB")
			
			While !Eof()
				
				cQrySD1	:= "SELECT D1_NFORI,D1_SERIORI,D1_ITEMORI, D2_PEDIDO,D2_ITEMPV, C5_QTDPEN "
				cQrySD1	+= "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SC5")+" SC5 "
				cQrySD1	+= "WHERE SD1.D_E_L_E_T_ <> '*' "
				cQrySD1	+= "  AND D1_FILIAL = '"+SF1->F1_FILIAL+"' "
				cQrySD1	+= "  AND D1_DOC = '"+SF1->F1_DOC+"' "
				cQrySD1	+= "  AND D1_SERIE = '"+SF1->F1_SERIE+"' "
				cQrySD1	+= "  AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
				cQrySD1	+= "  AND D1_LOJA = '"+SF1->F1_LOJA+"' "
				cQrySD1	+= "  AND D1_FILIAL = D2_FILIAL "
				cQrySD1	+= "  AND D1_NFORI = D2_DOC "
				cQrySD1	+= "  AND D1_SERIORI = D2_SERIE "
				cQrySD1	+= "  AND D1_ITEMORI = D2_ITEM "
				cQrySD1	+= "  AND D2_FILIAL = C5_FILIAL "
				cQrySD1	+= "  AND D2_PEDIDO = C5_NUM "
				TCQUERY cQrySD1 NEW ALIAS "TRABP"
				DbSelectArea("TRABP")
				DbGoTop()
				
				cBgColor:= "#ffffff" //#ffffff = branco || #ffffcc = amarelo claro
				
				cTxtMail += " <tr>"
				cTxtMail += "   <td width='05%' align='left'   bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+TRAB->E1_TIPO+"</font></td>"
				cTxtMail += "   <td width='14%' align='left'   bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+TRAB->E1_NUM+"/"+TRAB->E1_PARCELA+"</font></td>"
				cTxtMail += "   <td width='14%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+DtoC(StoD(TRAB->E1_VENCREA))+"</font></td>"
				cTxtMail += "   <td width='14%' align='right'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(Transform(TRAB->E1_SALDO,"@E 999,999,999.99"))+"</font></td>"
				cTxtMail += "   <td width='19%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(TRAB->E5_DOCUMEN)+"</font></td>"
				cTxtMail += "   <td width='14%' align='right'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(Transform(TRAB->E5_VALOR,"@E 999,999,999.99"))+"</font></td>"
				cTxtMail += "   <td width='10%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(TRABP->D1_NFORI)+"/"+Alltrim(TRABP->D1_SERIORI)+"</font></td>"

				cTxtMail += " </tr>"
				
				nTotSald+= TRAB->E1_SALDO
				nTotValo+= TRAB->E5_VALOR
				
				DbSelectArea("TRABP")
				DbCloseArea()
				
				DbSelectArea("TRAB")
				DbSkip()
			EndDo
			
			cBgColor:= '#cccccc'
			
			cTxtMail += " <tr>"
			cTxtMail += "   <td width='05%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b></font></b></td>"
			cTxtMail += "   <td width='14%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b>T O T A L</font></b></td>"
			cTxtMail += "   <td width='14%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b></font></b></td>"
			cTxtMail += "   <td width='14%' align='right' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b>"+Alltrim(Transform(nTotSald,"@E 999,999,999.99"))+"</font></b></td>"
			cTxtMail += "   <td width='10%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b></font></b></td>"
			cTxtMail += "   <td width='19%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b></font></b></td>"
			cTxtMail += "   <td width='14%' align='right' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b>"+Alltrim(Transform(nTotValo,"@E 999,999,999.99"))+"</font></b></td>"
			cTxtMail += "   <td width='10%' align='left'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b></font></b></td>"
			cTxtMail += " </tr>"
			
			cTxtMail += "  </tbody>"
			cTxtMail += "</table>"
			
		Else
			// O Cliente não possui pendencias..
			
			cTxtMail += "<body>"
			cTxtMail += "   <td><font face='Tahoma' size='2'>- A nota fiscal "+AllTrim(SF1->F1_DOC)+" da serie "+Alltrim(SF1->F1_SERIE)+" foi devolvida hoje e o cliente não possui nenhuma pendência financeira.</font></td>"
			cTxtMail += "</body>"
		EndIf
		
	EndIf
	
	cTxtMail += "<body>"
	cTxtMail += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	cTxtMail += "</body>"
	
	cTxtMail += "<body>"
	cTxtMail += "   <td><font face='Tahoma' size='1'>"+DtoC(Date())+" - "+Time()+"</font></td>"
	cTxtMail += "</body>"
	cTxtMail += "</html>"
	
	//Envia email sobre titulos

	cEmailAx2:= ""

	//cEmailAx2:= SubStr(cEmailAx2,1,Len(cEmailAx2)-1) //tira o ultimo ';'
	cEmailAx2:= "marcia.souza@brascola.com.br;cmoreira@brascola.com.br"

	cAssuntoAx:= "N.C.C. -->  Informações adicionais sobre devolução de nota fiscal (Filial "+SF1->F1_FILIAL+")"
	
	//Envio do email
	U_SendMail(cEmailAx2,cAssuntoAx,cTxtMail,"",.f.)  
	
	
	////////////////////////////ALIMENTA OBS DA NCC NA TABELA SE1 CONFORME NOTAS ORIGINAIS INFORMADAS NA TABELA SD1///////////////////////   
	
	cQryCHA	:= "SELECT D1_NFORI,D1_SERIORI,D1_ITEMORI "
	cQryCHA	+= "FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SD2")+" SD2 "
	cQryCHA	+= "WHERE SD1.D_E_L_E_T_ <> '*' "
	cQryCHA	+= "  AND D1_FILIAL = '"+SF1->F1_FILIAL+"' "
	cQryCHA	+= "  AND D1_DOC = '"+SF1->F1_DOC+"' "
	cQryCHA	+= "  AND D1_SERIE = '"+SF1->F1_SERIE+"' "
	cQryCHA	+= "  AND D1_FORNECE = '"+SF1->F1_FORNECE+"' "
	cQryCHA	+= "  AND D1_LOJA = '"+SF1->F1_LOJA+"' "
	cQryCHA	+= "  AND D1_FILIAL = D2_FILIAL "
	cQryCHA	+= "  AND D1_NFORI = D2_DOC "
	cQryCHA	+= "  AND D1_SERIORI = D2_SERIE "
	cQryCHA	+= "  AND D1_ITEMORI = D2_ITEM "
	cQryCHA	+= "  GROUP BY D1_NFORI,D1_SERIORI,D1_ITEMORI "
	If (Select("CHA") <> 0)
		dbSelectArea("CHA")
		dbCloseArea()
	Endif
	TCQUERY cQryCHA NEW ALIAS "CHA"  
	
	
    DbSelectArea("CHA")
	DbGoTop()      
	
	While !Eof("CHA") 
	
	DbSelectArea("SE1")
    DbSetOrder(1)          
    
    MsSeek(xFilial("SE1")+SE1->E1_PREFIXO+SE1->E1_NUM)

   		Begin Transaction
		
	   		RecLock("SE1",.F.)
	   			If empty (SE1->E1_OBSERV) 
					SE1->E1_OBSERV  := 'NCC referente a: Nota '+ Alltrim(CHA->D1_NFORI)+'-' + Alltrim(CHA->D1_SERIORI)+' Item' + Alltrim(CHA->D1_ITEMORI)
					MsUnlock()
				Else 
		        	SE1->E1_OBSERV  := Alltrim(SE1->E1_X_OBS)+ ' - Nota '+ Alltrim(CHA->D1_NFORI)+'-' + Alltrim(CHA->D1_SERIORI)+' Item' + Alltrim(CHA->D1_ITEMORI)
					MsUnlock()
		        Endif
		        
		End Transaction

		DBSELECTAREA("CHA")	  	
        DbSkip()   	    

	EndDo
	
EndIf


DbSelectArea("SE1")
DbGoTo(_nRecSE1)

DbSelectArea("SD1")
DbGoTo(_nRecSD1)

DbSelectArea("SF1")
DbGoTo(_nRecSF1)

RestArea(aAreaAtu)

Return



Static Function EnvMailDev(cEmailAx)
************************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""

_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"
_cBody += "<head>"
_cBody += "<title>Documento sem t&iacute;tulo</title>"
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
_cBody += "</head>"
_cBody += "<body>"
_cBody += "   <tr><font face='Tahoma' size='2'><b>Notificação de devolução de nota fiscal</font></b></tr>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='1'>Informamos que a nota fiscal "+SF1->F1_DOC+" foi devolvida hoje com os seguintes dados: </font></tr>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='1'><b>Cliente:</b> "+SF1->F1_FORNECE+"/"+SF1->F1_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_NOME")+"</font></tr>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='1'><b>Nota Fiscal:</b> "+SF1->F1_DOC+" / <b>Serie:</b> "+SF1->F1_SERIE+"  -  <b>Emissão:</b> "+DtoC(SF1->F1_EMISSAO)+"</font></tr>"
_cBody += "</body>"
  
/*
dbSelectArea("PA2")
dbSetOrder(1)
MsSeek(xFilial("PA2")+SF1->F1_DOC+SF1->F1_SERIE)
If Found()
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='1'><b>Observação:</b> "+AllTrim(PA2->PA2_OBS)+" </font></tr>"
	_cBody += "</body>"
EndIf
*/

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

_cBody += "<table border='1' cellspacing='1' width='50%'>"
_cBody += "  <TBODY>"
_cBody += "    <tr>"
_cBody += "      <td width='10%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Codigo</font></b></td>"
_cBody += "      <td width='45%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Descrição</font></b></td>"
_cBody += "      <td width='15%' align='right'  bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Quantidade</font></b></td>"
_cBody += "      <td width='15%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Lote</font></b></td>"
_cBody += "      <td width='15%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>NF Original</font></b></td>"
_cBody += "    </tr>"
_cBody += "  <tbody>"

cBgColor:= "#ffffff" //#ffffff = branco || #ffffcc = amarelo claro

DbSelectArea("SD1")
DbSetOrder(1)
MsSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

While !Eof() .And. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	_cBody += "    <tr>"
	_cBody += "      <td width='10%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+SD1->D1_COD+"</font></td>"
	_cBody += "      <td width='45%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")+"</font></td>"
	_cBody += "      <td width='15%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(SD1->D1_QUANT,"@E 999,999,999.99"))+"</font></td>"
	_cBody += "      <td width='15%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+SD1->D1_LOTECTL+"</font></td>"
	_cBody += "      <td width='15%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+SD1->D1_NFORI+"</font></td>"
	_cBody += "    </tr>"
	
	DbSkip()
EndDo

_cBody += "  </tbody>"
_cBody += "</table>"

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='1'>"+DtoC(Date())+" - "+Time()+"</font></td>"
_cBody += "</body>"
_cBody += "</html>"

cAssunto:= "Notificação de devolução de nota fiscal"

//Envio do email
U_SendMail(cEmailAx,cAssunto,_cBody,"",.f.)

Return