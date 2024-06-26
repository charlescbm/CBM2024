#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SF2460I  � Autor � Marcelo da Cunha      � Data � 28/01/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � PE que envia email a usuarios qdo for devolu��o            ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function SF2460I()
********************
Local aAreaAtu:= GetArea()
Local cTipMail:= ""
Local cEmail  := ""
Local cQuery  := ""
Local cTxtMail:= ""
Local cEmailAux:= ""
Local cAssuntAx:= ""

Private lListaNF:= .f.

_nRecSE2:= SE2->(RECNO())
_nRecSD2:= SD2->(RECNO())
_nRecSF2:= SF2->(RECNO())
lInclui := INCLUI 

If lInclui .And. SF2->F2_TIPO=="D" 
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	
	cTxtMail := " "
	cTxtMail += "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
	cTxtMail += "<html>"
	cTxtMail += "<head>"
	cTxtMail += "<title>Documento sem t&iacute;tulo</title>"
	cTxtMail += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
	cTxtMail += "</head>"
	cTxtMail += "<body>"
	cTxtMail += "   <tr><font face='Tahoma' size='2'><b>Informa��es adicionais sobre devolu��o de nota fiscal</font></b></tr>"
	cTxtMail += "</body>"
	cTxtMail += "<body>"
	cTxtMail += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	cTxtMail += "</body>"
	
	//manda email do Select SE2 para ver se possui titulos em aberto
	cQrySE2 := " SELECT SE2.E2_TIPO,SE2.E2_PREFIXO,SE2.E2_NUM,SE2.E2_PARCELA,SE2.E2_FORNECE,SE2.E2_LOJA, SE2.E2_VENCREA, SE2.E2_SALDO, SE2.E2_VALOR, ISNULL(E5_DOCUMEN,'') E5_DOCUMEN , ISNULL(E5_VALOR,0) E5_VALOR "
	cQrySE2	+= " FROM "+RetSqlName("SE2")+" SE2 "
	cQrySE2	+= " LEFT OUTER JOIN SE5010 ON SE2.E2_FILIAL = E5_FILIAL "
	cQrySE2	+= "   AND SE2.E2_FORNECE = E5_CLIFOR  "
	cQrySE2	+= "   AND SE2.E2_LOJA = E5_LOJA       "
	cQrySE2	+= "   AND SE2.E2_PREFIXO = E5_PREFIXO "
	cQrySE2	+= "   AND SE2.E2_NUM = E5_NUMERO      "
	cQrySE2	+= "   AND SE2.E2_PARCELA = E5_PARCELA "
	cQrySE2	+= "   AND E5_DOCUMEN <> ''            "
	cQrySE2	+= "   AND SE5010.D_E_L_E_T_<> '*'        "
	cQrySE2	+= " WHERE SE2.E2_FILIAL = '"+xFilial("SE2")+"' "
	cQrySE2	+= "   AND SE2.E2_FORNECE = '"+SF2->F2_CLIENTE+"' "
	cQrySE2	+= "   AND SE2.E2_LOJA = '"+SF2->F2_LOJA+"' "
	cQrySE2	+= "   AND SE2.E2_SALDO > 0 "
	cQrySE2	+= "   AND SE2.D_E_L_E_T_ <> '*' "
	cQrySE2	+= " ORDER BY SE2.E2_TIPO,SE2.E2_NUM,SE2.E2_PARCELA "
	If Select("TRAB") > 0
		TRAB->(dbCloseArea())
	EndIf
	TCQUERY cQrySE2 NEW ALIAS "TRAB"
		
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
		cTxtMail += "   <td><font face='Tahoma' size='2'>- A nota fiscal "+AllTrim(SF2->F2_DOC)+" da serie "+Alltrim(SF2->F2_SERIE)+" foi devolvida hoje e o cliente possui as seguintes duplicatas com saldo a pagar: </font></td>"
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
				
			cQrySD1	:= "SELECT D2_NFORI,D2_SERIORI,D2_ITEMORI,D2_PEDIDO,D2_ITEMPV,C5_QTDPEN "
			cQrySD1	+= "FROM "+RetSqlName("SD2")+" SD2 "
			cQrySD1	+= "WHERE SD2.D_E_L_E_T_ <> '*' "
			cQrySD1	+= "  AND D2_FILIAL = '"+SF2->F2_FILIAL+"' "
			cQrySD1	+= "  AND D2_DOC = '"+SF2->F2_DOC+"' "
			cQrySD1	+= "  AND D2_SERIE = '"+SF2->F2_SERIE+"' "
			cQrySD1	+= "  AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
			cQrySD1	+= "  AND D2_LOJA = '"+SF2->F2_LOJA+"' "
			TCQUERY cQrySD1 NEW ALIAS "TRABP"
			DbSelectArea("TRABP")
			DbGoTop()
			
			cBgColor:= "#ffffff" //#ffffff = branco || #ffffcc = amarelo claro
				
			cTxtMail += " <tr>"
			cTxtMail += "   <td width='05%' align='left'   bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+TRAB->E2_TIPO+"</font></td>"
			cTxtMail += "   <td width='14%' align='left'   bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+TRAB->E2_NUM+"/"+TRAB->E2_PARCELA+"</font></td>"
			cTxtMail += "   <td width='14%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+DtoC(StoD(TRAB->E2_VENCREA))+"</font></td>"
			cTxtMail += "   <td width='14%' align='right'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(Transform(TRAB->E2_SALDO,"@E 999,999,999.99"))+"</font></td>"
			cTxtMail += "   <td width='19%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(TRAB->E5_DOCUMEN)+"</font></td>"
			cTxtMail += "   <td width='14%' align='right'  bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(Transform(TRAB->E5_VALOR,"@E 999,999,999.99"))+"</font></td>"
			cTxtMail += "   <td width='10%' align='center' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'>"+Alltrim(TRABP->D2_NFORI)+"/"+Alltrim(TRABP->D2_SERIORI)+"</font></td>"
			cTxtMail += " </tr>"
				
			nTotSald+= TRAB->E2_SALDO
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
		// O Cliente n�o possui pendencias..
		cTxtMail += "<body>"
		cTxtMail += "   <td><font face='Tahoma' size='2'>- A nota fiscal "+AllTrim(SF2->F2_DOC)+" da serie "+Alltrim(SF2->F2_SERIE)+" foi devolvida hoje e o cliente n�o possui nenhuma pend�ncia financeira.</font></td>"
		cTxtMail += "</body>"
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
	//cEmailAx2:= "marcia.souza@brascola.com.br;cmoreira@brascola.com.br"
	cEmailAx2:= "marcelo@goldenview.com.br"

	cAssuntoAx:= "N.D.F. -->  Informa��es adicionais sobre devolu��o de nota fiscal (Filial "+SF2->F2_FILIAL+")"
	
	//Envio do email
	U_SendMail(cEmailAx2,cAssuntoAx,cTxtMail,"",.f.)  
	
	////////////////////////////ALIMENTA OBS DA NDF NA TABELA SE2 CONFORME NOTAS ORIGINAIS INFORMADAS NA TABELA SD2///////////////////////   
	cQryCHA	:= "SELECT D2_NFORI,D2_SERIORI,D2_ITEMORI "
	cQryCHA	+= "FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SD1")+" SD1 "
	cQryCHA	+= "WHERE SD2.D_E_L_E_T_ <> '*' "
	cQryCHA	+= "  AND D2_FILIAL = '"+SF2->F2_FILIAL+"' "
	cQryCHA	+= "  AND D2_DOC = '"+SF2->F2_DOC+"' "
	cQryCHA	+= "  AND D2_SERIE = '"+SF2->F2_SERIE+"' "
	cQryCHA	+= "  AND D2_FORNECE = '"+SF2->F2_CLIENTE+"' "
	cQryCHA	+= "  AND D2_LOJA = '"+SF2->F2_LOJA+"' "
	cQryCHA	+= "  AND D2_FILIAL = D1_FILIAL "
	cQryCHA	+= "  AND D2_NFORI = D1_DOC "
	cQryCHA	+= "  AND D2_SERIORI = D1_SERIE "
	cQryCHA	+= "  AND D2_ITEMORI = D1_ITEM "
	cQryCHA	+= "  GROUP BY D2_NFORI,D2_SERIORI,D2_ITEMORI "
	TCQUERY cQryCHA NEW ALIAS "CHA"  
	DbSelectArea("CHA")
	DbGoTop()      
	While !Eof("CHA") 
		dbSelectArea("SE2")
		DbSetOrder(6)          
		MsSeek(xFilial("SE2")+SF2->F2_cliente+SF2->F2_loja+SF2->F2_prefixo+SF2->F2_dupl,.T.)
		While !SE2->(Eof()).and.(xFilial("SE2") == SE2->E2_filial).and.(SE2->E2_fornece+SE2->E2_loja+SE2->E2_prefixo+SE2->E2_num == SF2->F2_cliente+SF2->F2_loja+SF2->F2_prefixo+SF2->F2_dupl)
	   	Begin Transaction
		   	RecLock("SE2",.F.)
				SE2->E2_OBSERV  := 'NDF referente a: Nota '+ Alltrim(CHA->D2_NFORI)+'-' + Alltrim(CHA->D2_SERIORI)+' Item' + Alltrim(CHA->D2_ITEMORI)
				MsUnlock()
			End Transaction
			SE2->(dbSkip())
		Enddo
		DBSELECTAREA("CHA")	  	
		DbSkip()   	    
	EndDo

EndIf

DbSelectArea("SE2")
DbGoTo(_nRecSE2)

DbSelectArea("SD2")
DbGoTo(_nRecSD2)

DbSelectArea("SF2")
DbGoTo(_nRecSF2)

RestArea(aAreaAtu)

Return