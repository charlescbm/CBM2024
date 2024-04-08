#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RFATM08  � Autor � Thiago (Onsten)       � Data � 06/02/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Envia email para repres. do faturamento diario             ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Brascola                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RFATM08()
***********************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= OemToAnsi("Rela��o do faturamento diario por representante")
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(3)  // Nao usar Licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "U_RFATM08()"  TABLES "SF2","SD2","SF4","SA1","SB1"

U_ProcM08A()

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)
             

User Function RFATMFR()
***********************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= OemToAnsi("Rela��o do faturamento diario por representante")
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(3)  // Nao usar Licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" FUNNAME "U_RFATM08()"  TABLES "SF2","SD2","SF4","SA1","SB1"

U_ProcM08A()

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)


User Function ProcM08A()
************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

cQuery:= "SELECT SF2.F2_VEND1, SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NREDUZ, SF2.F2_DOC, SD2.D2_PEDIDO, SD2.D2_ITEMPV, SD2.D2_COD, SB1.B1_DESC, SD2.D2_TOTAL, SF2.F2_EMISSAO "
cQuery+= " FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SF4")+" SF4, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SB1")+" SB1 "
cQuery+= " WHERE SF2.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SD2.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SA1.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SB1.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SF4.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery+= "   AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery+= "   AND F2_DOC = D2_DOC "
cQuery+= "   AND F2_SERIE = D2_SERIE "
cQuery+= "   AND F2_CLIENTE = D2_CLIENTE "
cQuery+= "   AND F2_LOJA = D2_LOJA "
cQuery+= "   AND F2_CLIENTE = A1_COD " 
cQuery+= "   AND F2_LOJA = A1_LOJA "
cQuery+= "   AND D2_COD = B1_COD "
cQuery+= "   AND D2_TES = F4_CODIGO "
cQuery+= "   AND F4_DUPLIC = 'S' " 
cQuery+= "   AND F4_ESTOQUE = 'S' "
cQuery+= "   AND F2_EMISSAO = '"+DtoS(dDataBase)+"' " 

cQuery+= " ORDER BY F2_VEND1, F2_DOC, D2_PEDIDO, D2_ITEMPV "

If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
//MemoWrite("\QUERYSYS\RFATM07.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
dbGotop()

cVendAux:= Space(6)
aDadMail:= {}

While !Eof()
    aDadMail  := {}	
	cVendAux  := TRAB->F2_VEND1
	cEmailVend:= AllTrim(Posicione("SA3",1,xFilial("SA3")+TRAB->F2_VEND1,"A3_EMAIL"))

	If !Empty(cEmailVend)
	
		While !Eof() .And. cVendAux==TRAB->F2_VEND1
				
		    aAdd(aDadMail, {TRAB->F2_CLIENTE, TRAB->F2_LOJA, TRAB->A1_NREDUZ, TRAB->F2_DOC, TRAB->D2_PEDIDO, TRAB->D2_ITEMPV, TRAB->D2_COD, TRAB->B1_DESC, TRAB->D2_TOTAL, TRAB->F2_EMISSAO} )
			dbSkip()                   	
		EndDo
	
		EnvMailM08(cVendAux,SA3->A3_NOME,cEmailVend,aDadMail)
	ELSE
	   
		dbSkip()  
	
	EndIf
		
	dbSelectArea("TRAB")
	 
EndDo

Return(.T.)



Static Function EnvMailM08(cVendAx, cNomVAx ,cEmailAx, aDadosAx)
**************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""
/*
24                              6       5      4     9           36                                                    9      7
CLIENTE                         NUM.NF  PEDIDO ITEM  PRODUTO     DESCRI�AO                                            TOTAL   EMISSAO 
054156/01  CASA DO ELETRICISTA  043595  032321  04   0491812     SILICONE BRASCOVED SUPER TRANSPAR.12 BLISTERS   999.999,99  99/99/99
                                12345678       123456            123456789*123456789*123456789*123456789*12345678            123456789*
123456789*123456789*123456789*12        1234567      123456789*12                                                123456789*12
123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*123456789*12345
*/
_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"                                                                                                                                                              
_cBody += "<head>"                                                                                                                                                              
_cBody += "<title>Documento sem t&iacute;tulo</title>"                                                                                                                          
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"                                                                                            
_cBody += "</head>"                                                                                                                                                             
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'>Representante: "+cVendAx+"-"+cNomVAx+"</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"                                                                                                                                                              
_cBody += "   <tr><font face='Tahoma' size='2'>Segue abaixo os itens faturados nesta data:</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<table border='1' cellspacing='1' width='100%'>"                                                                                                                     
_cBody += "  <TBODY>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='24%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='2'>Cliente</font></td>"                                                       
_cBody += "      <td width='06%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>N.Fiscal</font></td>"                                                          
_cBody += "      <td width='05%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>Pedido</font></td>"                                                          
_cBody += "      <td width='04%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>Item</font></td>"                                                    
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>Produto</font></td>"                                                          
_cBody += "      <td width='36%' align='left'   bgcolor='#ccffcc'><font face='Tahoma' size='2'>Descri��o</font></td>"                                                       
_cBody += "      <td width='09%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>Total</font></td>"                                                       
_cBody += "      <td width='07%' align='center' bgcolor='#ccffcc'><font face='Tahoma' size='2'>Emissao</font></td>"                                                    
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  <tbody>"                                                                                                                                                           

nTotDiaAx := 0

cPedAux := aDadosAx[1][5]
cBgColor:= "#ffffff" //branco 
nCtColor:= 0

For nI:= 1 to Len(aDadosAx)
	If cPedAux<> aDadosAx[nI][5] //controle para alternar cor de fundo conforme muda o pedido
		If nCtColor==0
			cBgColor:= "#ffffcc" //amarelo claro 
			nCtColor++
		Else
			cBgColor:= "#ffffff" //branco 
			nCtColor:= 0
		EndIf	
		cPedAux:= aDadosAx[nI][5]
	EndIf

	_cBody += "    <tr>"                                                                                                                                                            
	_cBody += "      <td width='24%' align='left'   bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][1]+"/"+aDadosAx[nI][2]+"     "+AllTrim(aDadosAx[nI][3])+"</font></td>"                                                                             
	_cBody += "      <td width='06%'                bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][4]+"</font></td>"                                                                              
	_cBody += "      <td width='05%'                bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][5]+"</font></td>"                                                                              
	_cBody += "      <td width='04%'                bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][6]+"</font></td>"                                                                              
	_cBody += "      <td width='09%'                bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][7]+"</font></td>"                                                                              
	_cBody += "      <td width='36%'                bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+aDadosAx[nI][8]+"</font></td>"                                                                             
	_cBody += "      <td width='09%' align='right'  bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][9],"@E 999,999.99"))+"</font></td>"         
	_cBody += "      <td width='07%' align='center' bgcolor='"+cBgColor+"'><font size='1' face='Tahoma'>"+DtoC(StoD(aDadosAx[nI][10]))+"</font></td>"         
	_cBody += "    </tr>"                                                                                                                                                           

	nTotDiaAx+= aDadosAx[nI][9]
Next

_cBody += "  </tbody>"
_cBody += "  <tbody>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='24%' align='left'   bgcolor='#cccccc'><b><font size='1' face='Tahoma'>T O T A L</font></b></td>"
_cBody += "      <td width='06%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='05%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='04%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='09%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='36%'                bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></td>"
_cBody += "      <td width='09%' align='right'  bgcolor='#cccccc'><b><font size='1' face='Tahoma'>"+Alltrim(Transform(nTotDiaAx,"@E 999,999.99"))+"</font></b></td>"
_cBody += "      <td width='07%' align='center' bgcolor='#cccccc'><font size='1' face='Tahoma'> </font></b></td>"
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

cAssunto:= "Pedidos faturados em "+DtoC(Date())

cEmailAx:= cEmailAx+";gefferson.landarini@brascola.com.br;whay@brascola.com.br" 

//Envio dos emails aos Representantes
U_SendMail(cEmailAx,cAssunto,_cBody,"",.f.)

Return