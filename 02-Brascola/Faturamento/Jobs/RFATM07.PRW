#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATM07  ³ Autor ³ Thiago (Onsten)       ³ Data ³ 05/02/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email para repres. dos pedidos com residuo eliminado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RFATM07()
***********************
Local aAreaAtu	:= GetArea()
Local cCadastro	:= OemToAnsi("Relatorio de pedidos com residuos eliminados")
Local nProcessa	:= 3
Local lJob		:= .t.

RPCSetType(3)  // Nao usar Licensa

PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "U_RFATM07()"  TABLES "SC5","SC6"

U_ProcM07A()

RESET ENVIRONMENT

RestArea(aAreaAtu)

Return(Nil)



User Function ProcM07A()
************************
Local cQuery   := ""           
Local cVendAux := ""
Local aDadMail := {}

cQuery:= "SELECT SC5.C5_VEND1, SC5.C5_NUM, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SA1.A1_NREDUZ, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_QTDVEN, SC6.C6_QTDENT, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG"
cQuery+= " FROM "+RetSQLName("SC5")+" SC5, "+RetSQLName("SC6")+" SC6, "+RetSQLName("SA1")+" SA1 "
cQuery+= " WHERE SC5.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SC6.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SA1.D_E_L_E_T_ = ' ' "
cQuery+= "   AND SC5.C5_FILIAL = '"+xFilial("SC5")+"' "
cQuery+= "   AND SC6.C6_FILIAL = '"+xFilial("SC6")+"' "
cQuery+= "   AND C5_NUM = C6_NUM "
cQuery+= "   AND C5_CLIENTE = A1_COD "
cQuery+= "   AND C5_LOJACLI = A1_LOJA "
cQuery+= "   AND C6_BLQ = 'R'    "
cQuery+= "   AND C6_NOTA = '' "
cQuery+= "   AND C6_X_DATR = '"+DtoS(dDataBase)+"' "
cQuery+= " ORDER BY 1,2,6 "
If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
//MemoWrite("\QUERYSYS\RFATM07.SQL",cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
dbGotop()
                                                  
//ConOut("+--------------------------------------+")
//ConOut("|  Enviando emails...        "+Time()+"  |")
//ConOut("+--------------------------------------+")

cVendAux:= Space(6)
aDadMail:= {}

While !Eof()

    aDadMail  := {}	
	cVendAux  := TRAB->C5_VEND1
	cEmailVend:= Posicione("SA3",1,xFilial("SA3")+TRAB->C5_VEND1,"A3_EMAIL") 

	If !Empty(cEmailVend)
	
		While !Eof() .And. cVendAux==TRAB->C5_VEND1
				
		    aAdd(aDadMail, {TRAB->C5_NUM,    TRAB->C5_CLIENTE,	TRAB->C5_LOJACLI, TRAB->C6_ITEM,;
		  				   TRAB->C6_PRODUTO, TRAB->C6_DESCRI, /*TRAB->C6_VALOR*/ ((TRAB->C6_QTDVEN-TRAB->C6_QTDENT)*TRAB->C6_PRCVEN), TRAB->C6_ENTREG, TRAB->A1_NREDUZ} )
	
			dbSkip()                   	
		EndDo
	
		EnvMailM07(cVendAux,SA3->A3_NOME,cEmailVend,aDadMail)
	EndIf
		
	dbSelectArea("TRAB") 
EndDo

Return(.T.)



Static Function EnvMailM07(cVendAx, cNomVAx ,cEmailAx, aDadosAx)
**************************
Local _cBody  := ""
Local cAssunto:= ""
Local cAnexo  := ""
Local cPLin   := Chr(13)+Chr(10)

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
_cBody += "   <tr><font face='Tahoma' size='2'>Segue abaixo os itens onde foram eliminados resíduos nesta data:</font></b></tr>" 
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<table border='1' cellspacing='1' width='100%'>"                                                                                                                     
_cBody += "  <TBODY>"                                                                                                                                                           
_cBody += "    <tr>"                                                                                                                                                            
_cBody += "      <td width='23%' align='left' bgcolor='#ffff99'><font face='Tahoma' size='2'>Cliente</font></td>"                                                       
_cBody += "      <td width='06%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='2'>Pedido</font></td>"                                                          
_cBody += "      <td width='05%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='2'>Item</font></td>"                                                    
_cBody += "      <td width='10%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='2'>Produto</font></td>"                                                          
_cBody += "      <td width='38%' align='left' bgcolor='#ffff99'><font face='Tahoma' size='2'>Descrição</font></td>"                                                       
_cBody += "      <td width='10%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='2'>Total</font></td>"                                                       
_cBody += "      <td width='08%' align='center' bgcolor='#ffff99'><font face='Tahoma' size='2'>Dt.Entrega</font></td>"                                                    
_cBody += "    </tr>"                                                                                                                                                           
_cBody += "  <tbody>"                                                                                                                                                           
For nI:= 1 to Len(aDadosAx)
	_cBody += "    <tr>"                                                                                                                                                            
	_cBody += "      <td width='23%' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+aDadosAx[nI][2]+"/"+aDadosAx[nI][3]+"     "+AllTrim(aDadosAx[nI][9])+"</font></td>"                                                                             
	_cBody += "      <td width='06%' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+aDadosAx[nI][1]+"</font></td>"                                                                              
	_cBody += "      <td width='05%' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+aDadosAx[nI][4]+"</font></td>"                                                                              
	_cBody += "      <td width='10%' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+aDadosAx[nI][5]+"</font></td>"                                                                              
	_cBody += "      <td width='38%' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+aDadosAx[nI][6]+"</font></td>"                                                                             
	_cBody += "      <td width='10%' align='right' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+Alltrim(Transform(aDadosAx[nI][7],"@E 999,999.99"))+"</font></td>"         
	_cBody += "      <td width='08%' align='center' bgcolor='#ffffff'><font size='1' face='Tahoma'>"+DtoC(StoD(aDadosAx[nI][8]))+"</font></td>"         
	_cBody += "    </tr>"                                                                                                                                                           
//	_cBody += "    </tr>"
Next
_cBody += "  </tbody>"
_cBody += "</table>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"                                                                                        
_cBody += "</body>"
_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2'>"+DtoC(Date())+" - "+Time()+"</font></td>"
_cBody += "</body>"
_cBody += "</html>"


cAssunto  := "Residuos eliminados " 

//Envio dos emails aos Representantes
U_SendMail(cEmailAx,cAssunto,_cBody,"",.f.)

Return