#INCLUDE "RWMAKE.CH"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "PROTHEUS.CH"                                 
#INCLUDE "FONT.CH"
#include "topconn.ch"            
#DEFINE CRLF ( chr(13)+chr(10) )
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ IVENR030   ºAutor  ³Fabio Luiz Gesser   º Data ³  04/06/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Envio de pedido por e-mail ao cliente                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function IVENR030(_cPed45, _cMsg45, _cEmail45)
**********************
//LOCAL oDlg 		   := NIL
//LOCAL cString	   := "SC5"
Default _cPed45   := ''
Default _cMsg45   := ''
Default _cEmail45 := ''		  
Private _cPed450   := _cPed45
Private _cEmail450 := _cEmail45
Private _cMsg450   := _cMsg45
PRIVATE nLastKey:= 0
PRIVATE cPerg	:= "DNY003"
PRIVATE nomeProg:= FunName()
PRIVATE cTitulo := "Envio de Pedido de Vendas por E-Mail a Cliente"
//Private nLastKey:= 0

mv_par01 	:= SC5->C5_NUM

AjustaSx1()

If AllTrim(FunName()) == 'MATA410'
	mv_par01 	:= SC5->C5_NUM
Else
	If Empty(_cPed450)
	   If ! Pergunte(cPerg,.T.)
	     	Return
	   Endif
	Else
	   mv_par01 := _cPed450   
	EndIf   
EndIf	
wnrel     := FunName()

nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27
   Return
Endif

EnvEmail()

Return

STATIC FUNCTION EnvEmail()
**************************

MsgRun("Aguarde Processando HTML para envio de E-mail...",,{||Orcamento()})

Return

STATIC FUNCTION Orcamento()   
***************************
dbSelectArea("SC5")
dbSetOrder(01)
dbSeek(xFilial("SC5")+mv_par01)

dbSelectArea("SA1")
dbSetOrder(01)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)  

dbSelectArea("SA4")
dbSetOrder(01)
dbSeek(xFilial("SA4")+SC5->C5_TRANSP)       

dbSelectArea("SA3")
dbSetOrder(01)
dbSeek(xFilial("SA3")+SC5->C5_VEND1)
	
dbSelectArea("SE4")
dbSetOrder(01)
dbSeek(xFilial("SE4")+SC5->C5_CONDPAG)  

cHtml := '<html> ' + CRLF
cHtml += '<head> ' + CRLF
cHtml += '   <meta http-equiv="Content-Language" content="pt-br"> ' + CRLF
cHtml += '   <meta http-equiv="Content-Type" content="text/html; charset=windows-1252"> ' + CRLF
cHtml += '   <meta name="GENERATOR" content="Microsoft FrontPage 4.0"> ' + CRLF
cHtml += '   <meta name="ProgId" content="FrontPage.Editor.Document"> ' + CRLF
cHtml += '   <title>Pedido</title> ' + CRLF
cHtml += '</head> ' + CRLF
cHtml += '<body bgcolor="#FFFFFF"> ' + CRLF

cHtml += '<h2><p><b><font Color="#000080" face="Arial"><CENTER>Pedido: '+MV_PAR01+' - Data Emissão: '+DTOC(SC5->C5_EMISSAO)+'</CENTER></font></b></p></h2> ' + CRLF
cHtml += '<table border=0 WIDTH=100% cellpadding="1"> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Cliente:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SA1->A1_COD + "-" +;
                                                                                              SA1->A1_LOJA + " - " +;
                                                                                              SA1->A1_NOME + "   CNPJ: " +;
                                                                                              Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99") +;
                                                                                              "   I.E.: " + Transform(Alltrim(SA1->A1_INSCR),"@R 999.999.999.999")+'</font></td> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Endereço Fat.:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SA1->A1_END + "  " + SA1->A1_BAIRRO + "  " + SA1->A1_MUN + "  " + SA1->A1_EST + "    CEP: " + SA1->A1_CEP+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Vendedor:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">'+SA3->A3_NOME+'</font></td> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Endereço Cob.:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SA1->A1_ENDCOB + "  " + SA1->A1_BAIRROC + "  " + SA1->A1_MUNC + "  " + SA1->A1_ESTC + "    CEP: " + SA1->A1_CEPC+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Frete:</font></b></td> ' + CRLF
IF SC5->C5_TPFRETE = "C"
   cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">CIF</font></td> ' + CRLF
ELSE
   cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">FOB</font></td> ' + CRLF
ENDIF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Endereço Ent.:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SA1->A1_ENDENT + "  " + SA1->A1_BAIRROE + "  " +SA1->A1_MUNE + "  " +  SA1->A1_ESTE +  "    CEP: " + SA1->A1_CEPE+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Data Entrega:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">'+Dtoc(SC5->C5_FECENT)+'</font></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Transportadora:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SA4->A4_COD + "  " + SA4->A4_NOME + "  " + SA4->A4_BAIRRO + "  "  + SA4->A4_MUN +"  " + SA4->A4_EST+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">E-Mail:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">'+SA1->A1_EMAIL+'</font></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Condição Pagto:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="1000"><font face="Arial" size="1">'+SE4->E4_CODIGO + "  " + SE4-> E4_DESCRI+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="150"><b><font face="Arial" size="2">Ordem Compra:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="left" width="800"><font face="Arial" size="1">'+SC5->C5_PEDCLI+'</font></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '</table> ' + CRLF
cHtml += '<div align="left"> ' + CRLF
cHtml += '<p><b><font Color="#000080" face="Arial">Itens:</font></b></p> ' + CRLF
cHtml += '<table border=0 WIDTH=100% cellpadding="2"> ' + CRLF
cHtml += '    <tr> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="12%" ><b><font face="Arial" size="2">Código</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="31%" ><b><font face="Arial" size="2">Descrição</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="04%" ><b><font face="Arial" size="2">UM</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="11%" ><b><font face="Arial" size="2">Cod.Cli</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="08%" ><b><font face="Arial" size="2">Quantidade</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="11%" ><b><font face="Arial" size="2">Pr.Unitário</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="11%" ><b><font face="Arial" size="2">Pr.Total</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="05%" ><b><font face="Arial" size="2">%IPI</font></b></td> ' + CRLF
cHtml += '       <td bgcolor="#C0C0C0" align="center" width="07%" ><b><font face="Arial" size="2">Vlr IPI</font></b></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '    <tr> ' + CRLF

nVlrIPI    := 0.00
nTotalItem := 0.00
nTpeso     := 0.00
nSubTot    := 0.00
nTotIPI    := 0.00
nTotalNota := 0.00

dbSelectArea("SC6")
dbSetOrder(01)
dbSeek(xFilial("SC6")+SC5->C5_NUM)
While !Eof() .And. SC6->C6_NUM ==SC5->C5_NUM  

      cUni 	     := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_UM") 
      nPercIPI   := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_IPI")
      nIPI       := Posicione("SF4",1,xFilial("SF4")+SC6->C6_TES    ,"F4_IPI")
      nPesoItem  := Posicione("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_PESBRU")

      nVlrIPI    := Iif(nIPI=="S",(SC6->C6_VALOR*nPercIPI)/100,0) 
      if SC5->C5_FRETE > 0.00
         nVlrIPI :=nVlrIPI + ((SC5->C5_frete*nPercIPI)/100)
      endif
      nTotalItem := (SC6->C6_QTDVEN*nPesoItem) 
      nTpeso     := nTPeso     + nTotalItem
      nSubTot    := nSubTot    + SC6->C6_VALOR
      nTotIPI    := nTotIPI    + nVlrIPI
      nTotalNota := nTotalNota + nTotalItem

      DbSelectArea("SB2")
      DbSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)

      DbSelectArea("SA7") 
      DbSetOrder(1)
      if DbSeek(xFilial("SA7")+SC5->C5_CLIENTE+ SC5->C5_LOJACLI + SC6->C6_PRODUTO) 
         cCodCli := SA7->A7_CODCLI	
      ELSE
         cCodCli := ""            
      endif        

      cHtml += '       <td bgcolor="#EEEEEE" align="left"   width="185"><font face="Arial" size="1">'+SC6->C6_PRODUTO+'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="left"   width="300"><font face="Arial" size="1">'+SC6->C6_DESCRI+'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="center" width="030"><font face="Arial" size="1">'+cUni+'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="left"   width="185"><font face="Arial" size="1">'+cCodcli+'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="right"  width="150"><font face="Arial" size="1">'+Transform(SC6->C6_QTDVEN,"@E  9,999,999")  +'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="right"  width="185"><font face="Arial" size="1">'+Transform(SC6->C6_PRCVEN,"@E 999,999.99")  +'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="right"  width="185"><font face="Arial" size="1">'+Transform(SC6->C6_VALOR, "@E 999,999.99")  +'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="right"  width="080"><font face="Arial" size="1">'+Transform(nPercIpi,      "@E 99.99")       +'</font></td> ' + CRLF
      cHtml += '       <td bgcolor="#EEEEEE" align="right"  width="170"><font face="Arial" size="1">'+Transform(nVlrIPI,       "@E 9,999,999.99")+'</font></td> ' + CRLF
      cHtml += '    </tr> ' + CRLF
      cHtml += '    <tr> ' + CRLF

      DBSELECTAREA("SC6")
      DBSKIP()
ENDDO 		

nTotalGeral := nSubTot+nTotIPI+SC5->C5_FRETE+SC5->C5_DESPESA

cHtml += '    </tr> ' + CRLF
cHtml += '</table> ' + CRLF
cHtml += '<table border=0 WIDTH=100% cellpadding="2"> ' + CRLF
cHtml += '    <tr align="left" bgcolor="#C0C0C0"> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="08%" ><b><font face="Arial" size="2">Total Mercadoria:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(nSubTot,"@E 9,999,999.99")+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="07%" ><b><font face="Arial" size="2">Total IPI:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(nTotIPI,"@E 9,999,999.99")+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="06%" ><b><font face="Arial" size="2">Frete:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(SC5->C5_FRETE,"@E 9,999,999.99")+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="07%" ><b><font face="Arial" size="2">Despesa:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(SC5->C5_DESPESA,"@E 9,999,999.99")+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="06%" ><b><font face="Arial" size="2">Peso:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(nTpeso,"@E 99,999.999")+'</font></td> ' + CRLF
cHtml += '      <td bgcolor="#C0C0C0" align="center" width="07%" ><b><font face="Arial" size="2">Total Geral:</font></b></td> ' + CRLF
cHtml += '      <td bgcolor="#EEEEEE" align="center" width="60"><font face="Arial" size="1">'+Transform(nTotalGeral,"@E 9,999,999.99")+'</font></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '</table> ' + CRLF
cHtml += '<table border=0 WIDTH=100% cellpadding="2"> ' + CRLF
cHtml += '    <tr align="left" bgcolor="#C0C0C0"> ' + CRLF
cHtml += '      <td colspan="6" bgcolor="#C0C0C0"><strong><font size="2" face="Arial, Helvetica, sans-serif">Observa&ccedil;&atilde;o</font></strong></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '    <tr align="left" bgcolor="#EEEEEE"> ' + CRLF
cHtml += '      <td colspan="6" bgcolor="#EEEEEE"><font size="1" face="Arial, Helvetica, sans-serif">'+ALLTRIM(SC5->C5_XOBSEXP)+'</font></td> ' + CRLF
cHtml += '    </tr> ' + CRLF
cHtml += '</table> ' + CRLF
cHtml += '</div> ' + CRLF
cHtml += '<U> ' + CRLF
cHtml += '<br><hr> ' + CRLF
cHtml += '</body> ' + CRLF
cHtml += '</html> ' + CRLF

arq:="Ped"+mv_par01+".htm"
MEMOWRITE(ARQ,cHtml)
arq2:="Ped"+mv_par01+".htm"

EnEMail()

FErase( arq2 )

Return

Static Function AjustaSX1()
***************************

PutSx1(cPerg,"01","Pedido           ?"," "," ","mv_ch1","C",06,0,0,	"G","","SC5","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe numero do Pedido Vendas"},{"Informe o numero do Pedido de Vendas de"},{"Informe o Numero do Pedido de Vendas"})
Return


Static Function EnEmail()
**************************
Local users      := RetCodUsr()

Local cAccount   := UsrRetMail(users)  //Alltrim(GetMV("MV_WFMAIL"))
Local _nome      := UsrFullName(users)
Local cServer    := "" //Alltrim(GetMV("MV_WFSMTP"))
Local cRecebe    := space(120)
Local cPassword  := ""//"c40*d390"  //Alltrim(GetMV("MV_WFPASSW"))
Local _cCc       := UsrRetMail(users)

Local cPath      := GetSrvProfString("StartPath","")
Local cMensagem  := ''
//local _cNossoMail:= ""
//Local cMensagem	 := ""
//Local nTentativa := 1
Local lConectou  := .F.
Local lEnviado	 := .F.
//Local lAuth 	 := GetMv("MV_RELAUTH",,.F.)
Local oDlg
//Local _cAnexo    := ''

IF SM0->M0_CODIGO == "01"
   cAccount   := UsrRetMail(users)  //Alltrim(GetMV("MV_WFMAIL"))
   _nome      := UsrFullName(users)
   cServer    := "" //Alltrim(GetMV("MV_WFSMTP"))
   cPassword  := ""//"c40*d390"  //Alltrim(GetMV("MV_WFPASSW"))
   //_cCc       := UsrRetMail(users)
ELSE
   cAccount   := UsrRetMail(users)  //Alltrim(GetMV("MV_WFMAIL"))
   _nome      := UsrFullName(users)
   cServer    := "smtp.vicsa.com.br:587" //Alltrim(GetMV("MV_WFSMTP"))
   cPassword  := ""//"c40*d390"  //Alltrim(GetMV("MV_WFPASSW"))
   //_cCc       := UsrRetMail(users)
ENDIF		   		
             
If Type('_cEmail450')<>'C' .or. Empty(_cEmail450)
   DEFINE MSDIALOG oDlg TITLE "E-Mail do cliente: "+ALLTRIM(SA1->A1_NREDUZ) From 000,000 To 120,500 Of oMainWnd Pixel 
 
   @ 005,010 SAY "De: "     OF oDlg PIXEL SIZE 200,09
   @ 005,030 MSGET cAccount OF oDlg PIXEL SIZE 200,09 WHEN .F.

   @ 020,010 SAY "Para: "   OF oDlg PIXEL SIZE 200,09
   @ 020,030 MSGET cRecebe  OF oDlg PIXEL SIZE 200,09
	
   DEFINE SBUTTON FROM 040,015 TYPE 1 ACTION(lEnviado:=.F.,oDlg:End()) ENABLE OF oDlg
   DEFINE SBUTTON FROM 040,065 TYPE 2 ACTION(lEnviado:=.T.,oDlg:End()) ENABLE OF oDlg 

   Activate MsDialog oDlg CENTERED

   //Renato Bandeira em 25/4/14
Else
   cRecebe := _cEmail450
	_cCc      := ""
EndIf

//TEMPORARIO [GUSTAVO]================================================================
cServer   := AllTrim(GetMv('MV_RELSERV',.F.,''))	//smtp do email
cAccount  := AllTrim(GetMv('MV_RELAUSR',.F.,''))	//colocar email de quem envia
cEnvia    := AllTrim(GetMv('MV_RELACNT',.F.,''))	//colocar email de quem envia

/*/
If Type('_cPed450')<>'C' .and. !Empty(_cPed450)
   cRecebe := _cEmail450
EndIf
/*/

IF Empty(cRecebe)
   //Renato Bandeira em 25/4/14 - NAO ENCONTRADO, VAI PARA TI POR CONTINENCIA
   cRecebe   := "charlesbattisti@gmail.com.br"	//anderson.zanni@meliora.com.br" //"gustavo.oliveira@meliora.com.br"	//cToEmail
ENDIF
cPassword := AllTrim(GetMv('MV_RELAPSW',.F.,'')) 	//colocar senha de quem manda     
//TEMPORARIO [GUSTAVO]================================================================

If Empty(_cPed450)
   IF Len(alltrim(cRecebe)) < 10
          Alert("E-Mail não Enviado")
          lEnviado := .T.
   ELSEIF lEnviado
          Alert("E-Mail não Enviado")
   ENDIF
EndIf   
/*
cMensagem := "Prezado Cliente," + CRLF + CRLF
cMensagem += "Segue cópia do seu pedido para conferência." + CRLF 
cMensagem += "Por gentileza, confira se as quantidades, tamanhos, cores e descrições dos itens estão corretas. E também se o local de entrega, "+;
             "faturamento e condições de pagamento estão de acordo com sua solicitação." + CRLF + CRLF 
cMensagem += "Agradecemos o seu pedido!" + CRLF 
*/


//Renato Bandeira em 25/4/14 - Correcao do conteudo do e-mail
If Type('_cEmail450')<>'C' .or. Empty(_cEmail450)
//If !Empty(_cPed450)
   cMensagem :=	"Prezado Cliente," +CRLF+CRLF+;
				"Segue cópia do seu pedido para conferência."+CRLF+; 
				"Por gentileza confira as quantidades, os itens e o frete."+CRLF+;
             	"E também se o local de entrega, faturamento e condições de pagamento "+CRLF+;
            	"estão de acordo com sua solicitação."+CRLF+CRLF+; 
				"Agradecemos a preferência !"+CRLF 
   assunto := "Pedido de Vendas Nº "+mv_par01

	_cCc      := UsrRetMail(users)                                                                        

Else           
   If Type('_cMsg450') == 'C'
      cMensagem := _cMsg450
   Else
      cMensagem :=	"Prezado Cliente," +CRLF+CRLF+;
				"Segue cópia do seu pedido para conferência."+CRLF+; 
				"Por gentileza confira as quantidades, os itens e o frete."+CRLF+;
             	"E também se o local de entrega, faturamento e condições de pagamento "+CRLF+;
            	"estão de acordo com sua solicitação."+CRLF+CRLF+; 
				"Agradecemos a preferência !"+CRLF 
   EndIf   
   assunto := "Liberação de Pedido de Vendas Nº "+mv_par01
EndIf				

Path    := cPath+arq2                       

//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou     //realiza conexão com o servidor de internet

If lConectou
	lRet := Mailauth(cAccount,cPassword)
	if lRet
		SEND MAIL FROM cEnvia;
		TO cRecebe;
		CC _cCc;
		SUBJECT assunto ;
		BODY cmensagem ;
		ATTACHMENT Path;
		RESULT lEnviado
	Else
		SEND MAIL FROM cEnvia;
		TO cRecebe;      
		CC _cCc;
		SUBJECT assunto;
		BODY cmensagem;
		ATTACHMENT Path;
		RESULT lEnviado
	Endif
Endif

If lEnviado
	//Renato Bandeira em 25/4/14 - se for da liberacao nao ira avisar
	If Type('_cEmail450')<>'C' .or. Empty(_cEmail450)
		Alert("Enviado E-Mail para o Cliente: "+SA1->A1_NREDUZ)
	Endif
Else
	cMensagem := ""
	GET MAIL ERROR cMensagem
	Alert(cMensagem+CRLF+CRLF+"Pedido para o E-mail "+Alltrim(cRecebe)+", não Enviado ao Cliente. Verifique o Endereço de E-mail Digitado.")	
Endif

DISCONNECT SMTP SERVER Result lDisConectou
//[##Meliora/Gustavo]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>[ Alteração ]<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

/*
While lEnviado == .F. .and. nTentativa < 6 .and. lConectou == .F.
	
 	  CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
	  If lAuth
		 lConectou := MailAuth(cAccount,cPassword)
		 If !lConectou
			lConectou := QADGetMail() // Funcao que abre uma janela perguntando o usuario e senha para fazer autenticacao
		 EndIf
	  EndIf
	
	  If lConectou == .F.
		 nTentativa += 1	
		 Alert('Erro no envio! ')
		 Return
	  EndIf

	  Path   :=cPath+arq2
	  assunto:="Pedido de Vendas Nº "+mv_par01

	  If path <> ""
		 SEND MAIL FROM cAccount;
		 TO cRecebe;
		 CC _cCc;
		 BCC _cCc;
		 SUBJECT assunto;
		 BODY cmensagem;
		 ATTACHMENT Path;
		 RESULT lEnviado
	  Else
		 SEND MAIL FROM cAccount;
		 TO cRecebe;
		 SUBJECT assunto;
		 BODY cMensagem;
		 RESULT lEnviado
	  Endif
	
	  If lEnviado
		 Alert("Enviado E-Mail para o Cliente: "+SA1->A1_NREDUZ)
	  Else
		 cMensagem := ""
		 GET MAIL ERROR cMensagem

		 Alert(cMensagem+CRLF+CRLF+"Pedido para o E-mail "+Alltrim(cRecebe)+", não Enviado ao Cliente. Verifique o Endereço de E-mail Digitado.")

	  Endif
	  DISCONNECT SMTP SERVER Result lDisConectou
Enddo
*/
Return
