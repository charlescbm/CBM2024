#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
'±±≥FunáÖo    ≥ RFATM13  ≥ Autor ≥ Thiago (Onsten)       ≥ Data ≥ 22/04/09 ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥ Envia email p/ Adm.Vendas dos ped. com residuos eliminados ≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥ Uso      ≥ Especifico Brascola                                        ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

User Function RFATM13()
***********************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= OemToAnsi("RelaÁ„o de pedidos com residuos eliminados - Adm.Vendas")
Local nProcessa	:= 3
Local lJob		:= .t.

//RPCSetType(3)  // Nao usar Licensa
//PREPARE ENVIRONMENT EMPRESA "02" FILIAL "04" FUNNAME "U_RFATM13()"  TABLES "SC5","SC6"

U_ProcM13A()

//RESET ENVIRONMENT

//RestArea(aAreaAtu)

Return(Nil)



User Function ProcM13A()
************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

cQuery:= "SELECT SA3.A3_GEREN, SA3.A3_SUPER, SC5.C5_VEND1, SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SA1.A1_NREDUZ, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_QTDENT, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG"
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SA3")+" SA3 "
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' '  AND SC6.D_E_L_E_T_ = ' '  AND SA1.D_E_L_E_T_ = ' '  AND SA3.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery+= "   AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery+= "   AND C5_NUM = C6_NUM "
cQuery+= "   AND C5_CLIENTE = A1_COD "
cQuery+= "   AND C5_LOJACLI = A1_LOJA "
cQuery+= "   AND C5_VEND1 <> '001001' " //transferencias
cQuery+= "   AND C6_BLQ = 'R' "
cQuery+= "   AND C6_NOTA = '' "
cQuery+= "   AND C6_X_DATR = '"+DtoS(dDataBase)+"' "
//cQuery+= "   AND C6_X_DATR BETWEEN '"+DtoS(Firstday(dDataBase))+"' AND '"+DtoS(dDataBase)+"' "
cQuery+= "   AND SC5.C5_VEND1=SA3.A3_COD "
cQuery+= " ORDER BY A3_GEREN, A3_SUPER, C5_VEND1, C5_NUM, C6_ITEM"
If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
//MemoWrite("\QUERYSYS\RFATM07.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
dbGotop()
 
cGerenAux:= Space(6)
aDadMail := {}
 
While !Eof()
	If ((TRAB->C6_QTDVEN-TRAB->C6_QTDENT)*TRAB->C6_PRCVEN)>0

	    aAdd(aDadMail, {TRAB->C5_NUM, TRAB->C5_CLIENTE, TRAB->C5_LOJACLI, TRAB->C6_ITEM, TRAB->C6_PRODUTO,;
	    				TRAB->C6_DESCRI, ((TRAB->C6_QTDVEN-TRAB->C6_QTDENT)*TRAB->C6_PRCVEN),TRAB->C6_ENTREG, ;
	    				TRAB->A1_NREDUZ, TRAB->A3_SUPER, TRAB->C5_VEND1, TRAB->A3_GEREN }) 
	EndIf
	    				
	dbSkip()                   	
EndDo

If Len(aDadMail)>0
	EnvMailM13(aDadMail)
EndIf

Return(.T.)


 
Static Function EnvMailM13(aDadosAx)
**************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""
Local cPLin   := Chr(13)+Chr(10)
/*
14                            14                            14                            15                              3       3     5           21                                                       6       5
GERENTE                       SUPERVISOR                    REPRESENTANTE                 CLIENTE                         PEDIDO  ITEM  PRODUTO     DESCRI«AO                                                TOTAL   ENTREGA 
999999  XXXXXXXXXXXXXXXXXXXX  999999  XXXXXXXXXXXXXXXXXXXX  999999  XXXXXXXXXXXXXXXXXXXX  054156/01  CASA DO ELETRICISTA  032321   04   0491812     SILICONE BRASCOVED SUPER TRANSPAR.12 BLISTERS   999.999.999,99  99/99/99
                              123456789*123456789*123456789*                              123456789*123456789*123456789*12       1234567            123456789*123456789*123456789*123456789*12345678              123456789*
123456789*123456789*123456789*                              123456789*123456789*123456789*                                1234567       123456789*12                                                123456789*1234
123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789* 220
*/
_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"                                                                                                                                                              
_cBody += "<head>"                                                                                                                                                              
_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
_cBody += "</head>"                                                                                                                                                             
/*
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'>Gerente: "+cGerAx+"-"+cNomGAx+"</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
*/
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'>Segue abaixo os itens onde foram eliminados resÌduos do dia "+DtoC(dDataBase)+"</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<table border='1' cellspacing='1' width='100%'>"
_cBody += "  <TBODY>"
_cBody += "    <tr>"
_cBody += "      <td width='14%' align='left' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Gerente</b></font></td>"
_cBody += "      <td width='14%' align='left' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Supervisor</b></font></td>"
_cBody += "      <td width='14%' align='left' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Representante</b></font></td>"
_cBody += "      <td width='15%' align='left' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Cliente</b></font></td>"
_cBody += "      <td width='03%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Pedido</b></font></td>"
_cBody += "      <td width='03%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Item</b></font></td>" 
_cBody += "      <td width='05%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Produto</b></font></td>"
_cBody += "      <td width='21%' align='left' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>DescriÁ„o</b></font></td>"
_cBody += "      <td width='06%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Total</b></font></td>"
_cBody += "      <td width='05%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='1'><b>Dt.Entrega</b></font></td>" 
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  <tbody>"                                                                                                                                                           

cGerAux := aDadosAx[1][12]
cBgColor:= "#ffffff" //branco 
nCtColor:= 0

nTotGer:= 0
nTotalR:= 0

For nI:= 1 to Len(aDadosAx)
  
	If cGerAux<> aDadosAx[nI][12] //controle para alternar cor de fundo conforme muda o gerente      

		_cBody += "    <tr>"                                                                                                                                                            
		_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'><b>"+"TOTAL "+"</b></font></td>"
		_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
		_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
		_cBody += "      <td width='15%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
		_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
		_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
		_cBody += "      <td width='05%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
		_cBody += "      <td width='21%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
		_cBody += "      <td width='06%' align='right' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'><b>"+Alltrim(Transform(nTotGer,"@E 999,999.99"))+"</b></font></td>"         
		_cBody += "      <td width='05%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"         
		_cBody += "    </tr>"

		If nCtColor==0
			cBgColor:= "#ffffcc" //amarelo claro 
			nCtColor++
		Else
			cBgColor:= "#ffffff" //branco 
			nCtColor:= 0
		EndIf	

		nTotGer:= 0
		cGerAux:= aDadosAx[nI][12]
	EndIf
  
	_cBody += "    <tr>"                                                                                                                                                            
	_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][12]+"  "+SubStr(AllTrim(Posicione("SA3",1,xFilial("SA3")+aDadosAx[nI][12],"A3_NOME")),1,20)+"</font></td>"
	_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][10]+"  "+SubStr(AllTrim(Posicione("SA3",1,xFilial("SA3")+aDadosAx[nI][10],"A3_NOME")),1,20)+"</font></td>"
	_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][11]+"  "+SubStr(AllTrim(Posicione("SA3",1,xFilial("SA3")+aDadosAx[nI][11],"A3_NOME")),1,20)+"</font></td>"
	_cBody += "      <td width='15%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][2]+"/"+aDadosAx[nI][3]+"   "+AllTrim(aDadosAx[nI][9])+"</font></td>"                                                                             
	_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][1]+"</font></td>"                                                                              
	_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][4]+"</font></td>"                                                                              
	_cBody += "      <td width='05%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][5]+"</font></td>"                                                                              
	_cBody += "      <td width='21%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][6]+"</font></td>"                                                                             
	_cBody += "      <td width='06%' align='right' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][7],"@E 999,999.99"))+"</font></td>"         
	_cBody += "      <td width='05%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+DtoC(StoD(aDadosAx[nI][8]))+"</font></td>"         
	_cBody += "    </tr>"

	nTotGer+= aDadosAx[nI][7]
	nTotalR+= aDadosAx[nI][7]
Next 

_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'><b>"+"TOTAL"+"</b></font></td>"
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
_cBody += "      <td width='15%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='05%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='21%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
_cBody += "      <td width='06%' align='right' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'><b>"+Alltrim(Transform(nTotGer,"@E 999,999.99"))+"</b></font></td>"         
_cBody += "      <td width='05%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"         
_cBody += "    </tr>"


cBgColor:="#cccccc"

_cBody += "  </tbody>"
_cBody += "  <tbody>"
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b>"+"TOTAL   GERAL"+"</b></font></td>"
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
_cBody += "      <td width='14%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"
_cBody += "      <td width='15%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='03%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='05%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                              
_cBody += "      <td width='21%' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"                                                                             
_cBody += "      <td width='06%' align='right' bgcolor='"+cBgColor+"'><font size='2' face='Tahoma'><b>"+Alltrim(Transform(nTotalR,"@E 999,999.99"))+"</b></font></td>"         
_cBody += "      <td width='05%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'></font></td>"         
_cBody += "    </tr>"
_cBody += "  </tbody>"

_cBody += "</table>"
 
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2'>"+DtoC(Date())+" - "+Time()+"</font></td>"
_cBody += "</body>"
_cBody += "</html>"
 
cAssunto:= "Residuos eliminados " 
/*
cTipMail:= "000009"
cQuery  := ""
cQuery  += "SELECT ZG.ZG_EMAIL "
cQuery  += "FROM "+RetSqlName("SZI")+" ZI,"+RetSqlName("SZG")+" ZG "
cQuery  += "WHERE ZI.ZI_FILIAL = '  ' AND ZI.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZI.ZI_TIPO = '"+cTipMail+"' AND ZI.ZI_RESPONS = ZG.ZG_CODIGO "
cQuery  += "  AND ZG.ZG_FILIAL = '  ' AND ZG.D_E_L_E_T_ <> '*' "
cQuery  += "  AND ZG.ZG_ATIVO = 'S' "
cQuery  := ChangeQuery(cQuery)
TCQuery cQuery NEW ALIAS "SZGS" 
*/
cEmail:= "depto.admvendas@brascola.com.br" 
/*
dbSelectArea("SZGS")
dbGoTop()
While !EOF()
	cEmail += Alltrim(SZGS->ZG_EMAIL)+";"
	dbSkip()
Enddo

cEmail:= SubStr(cEmail,1,Len(cEmail)-1) //tira o ultimo ';'
*/
If !Empty(cEmail)
	//Envio do email
	U_SendMail(cEmail,cAssunto,_cBody,"",.f.)
EndIf	
/*
dbSelectArea("SZGS")
dbCloseArea()
*/
Return