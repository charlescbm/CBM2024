#INCLUDE "RWMAKE.CH"
#include "tbiconn.ch"
#include "topconn.ch"
#include "colors.ch" 
#INCLUDE "MATR110.CH"
#INCLUDE "FIVEWIN.CH"

User Function BCOMW01()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Cliente     ³ Brascola LTDA                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programa     ³ B.PRW       ³ Responsavel ³ Charles Battisti Medeiros   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o    ³ Envia Email Com P.C. Aprovados aos Fornecedores         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Data        ³ 01/09/2010       ³ Implantacao ³   /  /                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador ³ Charles Battisti Medeiros                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

@ 270, 180 To 410,450 Dialog oDlg Title 'Selecione a Opção Desejada'
@ 001, 001 Say 'Deseja IMPRIMIR ou ENVIAR por E-MAIL...?'
@ 040, 010 BUTTON "Imprimir" SIZE 35,15 ACTION Imprimef() Object oBtn
@ 040, 050 BUTTON "Enviar E-Mail" SIZE 35,15 ACTION Envia() Object oBtn
@ 040, 090 BUTTON "Cancelar" SIZE 35,15 ACTION Close(oDlg) Object oBtn
Activate Dialog oDlg CENTERED  

Static Function Envia()

Private cEmail2		:= ""
Private cNomFor 	:= ""
Private cCondPg		:= ""
Private cContato	:= ""
Private cMailFor 	:= ""
Private cMailOut 	:= ""
Private _cServer  	:= 	GetMV("MV_RELSERV")   // Servidor
Private _cConta 	:= "" // Conta
Private cEnvia  	:= "" // Conta
Private cMaiDes   	:= ""
Private _cPass    	:= Space(15) // Senha da conta
//Private cAnexo    	:= 	' '
Private _cAssunto	:= 	""
Private _cBody		:= ""
Private	cPedido     := Space(6)
Private nValTot 	:= 0
Private xTotIpi 	:= 0
Private xValIpi 	:= 0
Private cTpFrete 	:= ""
Private cNome		:= ""
//Private aAreaSC7	:= 	SC7->(GetArea())
//Private aAreaSM0	:= 	SM0->(GetArea())
Private cOBSItem 	:= ""

PswOrder(2)
If PswSeek(Alltrim(cUsername),.T.)
	NmailUser := PswRet(1)[1,14]
	cNomeUser := PswRet(1)[1,04] 
Endif

Private cMailUser := NmailUser


cPerg := "BCOMW01"
dbSelectArea("SX1")
dbSetOrder(1)
If !dbseek(cPerg)
	PutSx1(cPerg,"01"	 ,"Numero Pedido"	,"","" ,"mv_ch1 ","C"  ,06,0,0	,"C" ,""	,"SC7"		,""		 ,""	,"mv_par01"	,""    			,""		,""		 ,""	,""				,""		 ,""	  ,""	 		,""	  	 	 ,""	   	,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})
	PutSx1(cPerg,"02"	 ,"Filial Pedido"	,"","" ,"mv_ch2 ","C"  ,02,0,0	,"C" ,""	,"SM0"		,""		 ,""	,"mv_par02"	,""	   		,""		,""		 ,""	,""			,""		 ,""	  ,""	 		," "	  	 	 ,""		,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})
	PutSx1(cPerg,"03"	 ,"E-mail 1"		,"","" ,"mv_ch3 ","C"  ,40,0,0	,"C" ,""	,""			,""		 ,""	,"mv_par03"	,""    			,""		,""		 ,""	,""				,""		 ,""	  ,""	 		,""	  	 	 ,""	   	,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})
	PutSx1(cPerg,"04"	 ,"E-mail 2"		,"","" ,"mv_ch4 ","C"  ,40,0,0	,"C" ,""	,""			,""		 ,""	,"mv_par04"	,""    			,""		,""		 ,""	,""				,""		 ,""	  ,""	 		,""	  	 	 ,""	   	,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})
	PutSx1(cPerg,"05"	 ,"Reenvia Pedido"	,"","" ,"mv_ch5 ","N"  ,01,0,0	,"C" ,""	,""			,""		 ,""	,"mv_par05"	,"Não"	   		,""		,""		 ,""	,"Sim"			,""		 ,""	  ,""	 		,""	  	 	 ,""		,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})
	PutSx1(cPerg,"06"	 ,"Msg Comprador"	,"","" ,"mv_ch6 ","C"  ,80,0,0	,"C" ,""	,""			,""		 ,""	,"mv_par06"	,""	   		,""		,""		 ,""	,""			,""		 ,""	  ,""	 		,""	  	 	 ,""		,""					,""		,""			,""			,""		 ,""		,{""},{""},{""})	
Endif


If !Pergunte(cPerg,.T.)
	Return
EndIf

Private cPedido := (MV_PAR01)

If EMPTY (MV_PAR03)
	If EMPTY (MV_PAR04)
		cMailOut  := ''
	Else
		cMailOut  := MV_PAR04
	Endif
Elseif	EMPTY (MV_PAR04)
	cMailOut  := MV_PAR03
Else
	cMailOut  := (MV_PAR03+";"+MV_PAR04)
Endif  

//


dBselectArea('SM0')
dbSetOrder(1)
SM0->(DbSeek(M0_CODIGO+(mv_par02),.t.))    


//Verifico se o Pedido está Liberado

dBselectArea('SC7')
dbSetOrder(1)
SC7->(DbSeek(MV_PAR02+(mv_par01),.t.))

If SC7->C7_NUM == MV_PAR01
	
Else  
	msginfo( "Pedido numero "+ MV_PAR01+" não encontrado para Filial")
	Return
endif


If SC7->C7_CONAPRO <> "L"
	MsgBox("Pedido não Liberado !!")
	RETURN
Endif


//Verifico se o Pedido ja foi enviado

If !EMPTY(SC7->C7_DATMAIL) .OR. !EMPTY(SC7->C7_USEMAIL)
	If MV_PAR05 == 1
		MsgBox("Pedido ja foi Enviado !!")
		RETURN
	Endif
Endif

// CHAMO A FUNÇÃO QUE GERA O HTML NO CORPO DO E-MAIL //

SalvaAne()     // Função para montar o html no corpo do e-mail

UEmail()		// Função para enviar o e-mail

/*
//PERGUNTO PASSWORD

@ 270, 180 To 410,450 Dialog oDlg Title 'Informe sua Senha de E-Mail'
@ 001, 003 Say 'Digite sua Senha :'
@ 001, 009 Get _cPass Picture 'XXXXXXXXXXXXXXX' SIZE 40,10 Valid .t. PASSWORD
@ 045, 040 BmpButton Type 1 Action UEmail()
@ 045, 080 BmpButton Type 2 Action Close(oDlg)
Activate Dialog oDlg CENTERED

Return
*/
// FIM DO PROGRAMA

Return

///////////////////////////////////////////////////////////////////////////////////
//////////////////////////FUNÇÕES LOCAIS DO RDMAKE/////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////


///// FUNÇÃO QUE SALVA ANEXO

Static Function SalvaAne()


//POSICIONO NO SC7

dBselectArea('SC7')
dbSetOrder(1)

SET DELETE ON

SC7->(DbSeek(MV_PAR02+(mv_par01),.t.))

//ALIMENTAR VARIAVEIS

// FRETE

If SC7->C7_TPFRETE == "C"
	cTpFrete :="CIF</FONT></P>"
Else
	cTpFrete :="FOB</FONT></P>"
Endif

// INFORMAÇÕES DO USUÁRIO

cComp   := SC7->C7_user
PswOrder(1)
If PswSeek(cComp,.T.)
	aArray := PSWRET()
Endif

If!Empty(SC7->C7_user)
	cEmail2 	:= aArray[1,14]
	cNome		:= aArray[1,04]
	cFone		:= "(47) 3205-2702"
Else
	cEmail2 := " "
Endif
                  

// CONDIÇÃO DE PAGAMENTO

SE4->(DbSeek(XFILIAL('SE4')+SC7->C7_COND))
cCondPg := SE4->E4_DESCRI

// INFORMAÇÃO SOBRE FORNECEDOR

SA2->(DbSeek(XFILIAL('SA2')+SC7->C7_FORNECE+SC7->C7_LOJA))
cNomFor  := SA2->A2_NOME  
cMailFor := SA2->A2_EMAIL

// CABEÇALHO DO E-MAIL

_cBody := "<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
_cBody += "<html>"
_cBody += "<head>"
_cBody += "<title>Documento sem t&iacute;tulo</title>"
_cBody += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
_cBody += "</head>"

// BUSCA LOGO DA BRASCOLA

_cBody +=""
//_cBody +="<td width=20%><img border=0 src=http://www.brascola.com.br/images/logo/brascola.jpg style=float: right></td>"
//_cBody +="<td width=20%><img border=0 src=http://mail.brascola.com.br/imagens/logo.jpg style=float: right></td>"    
_cBody +="<td width=20%><img border=0 src=http://mail.brascola.com.br/Logo%20Brascola_Protheus.jpg style=float: right></td>"    
_cBody +=""

// INFORMAÇÕES ABAIXO DA LOGO

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>EMPRESA: BRASCOLA LTDA </font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>ENDEREÇO: "+ALLTRIM(SM0->M0_ENDENT)+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>CEP: "+ALLTRIM(SM0->M0_CEPENT)+" - "+ALLTRIM(SM0->M0_CIDENT)+" - "+ALLTRIM(SM0->M0_ESTENT)+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>CNPJ: "+ALLTRIM(SM0->M0_CGC)+"</b></font></tr>"
_cBody += "</body>"                                                                                       

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>INSCRICAO ESTADUAL: "+ALLTRIM(SM0->M0_INSC)+"</b></font></tr>"
_cBody += "</body>"

// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

// TITULO NO CORPO DO E-MAIL

_cBody += "<body>"
//_cBody += "   <tr><font align='center' face='Tahoma' size='3'COLOR=#99CC00>Pedido de Compras - BRASCOLA </font></tr>"
_cBody += '   <p align="center" ><font face="Tahoma" size="3" COLOR="#99CC00"><b>Pedido de Compras '+cPedido+' - BRASCOLA </font></p> '
_cBody += "</body>"

// LINHA HORIZONTAL 100%

_cBody += " <hr> "

// CABEÇALHO DO PEDIDO DE COMPRAS

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Número do pedido: <b>"+cPedido+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Fornecedor: "+SC7->C7_FORNECE+" - "+cNomFor+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Emissão: "+DTOC(SC7->C7_EMISSAO)+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Cond. Pagamento:"+SC7->C7_COND+" - "+cCondPg+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Contato: "+cNome+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>E-mail Contato: "+cEmail2+" - E-mail Envio: "+cMailUser+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Telefone: ( 47 ) 3205-2702</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000>Tipo de Frete: "+cTpFrete+"</b></font></tr>"
_cBody += "</body>"

// LINHA HORIZONTAL 100%

_cBody += " <hr> "


// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

//COMEÇA O CABEÇALHO DA TABELA
_cBody += "<table border='1' cellspacing='1' width='100%'>"
_cBody += "<tr>"
_cBody += " <td width='05%' align='center'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Item</b></font></td>"
_cBody += " <td width='33%' align='center'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Produto</b></font></td>"
_cBody += " <td width='07%' align='center'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Quantidade</b></font></td>"
_cBody += " <td width='05%' align='center'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>UM</b></font></td>"
_cBody += " <td width='10%' align='center'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Vlr.Unit.</b></font></td>"
_cBody += " <td width='10%' align='center'	 bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>VLR.IPI</b></font></td>"
_cBody += " <td width='10%' align='center'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>VLR. Total</b></font></td>"
_cBody += " <td width='07%' align='center'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Data Entr.</b></font></td>"
_cBody += " <td width='07%' align='center'   bgcolor='#d2e9ff'><font face='Tahoma' size='1'><b>Obs. Item</b></font></td>"
_cBody += " <td width='06%' align='center'   bgcolor='#b7dbff'><font face='Tahoma' size='1'><b>Sol.C.</b></font></td>"
_cBody += "</tr>"

cBgColor := '#ffffff'
cBgColorC:= '#f0f0f0'

While SC7->C7_NUM == cPedido
	
	_cBody += "<tr>"
	_cBody += " <td width='05%' align='Center'  bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+SC7->C7_ITEM+"</font></td>"
	_cBody += " <td width='33%' align='Center'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+SC7->C7_PRODUTO+" - "+SC7->C7_DESCRI+"</font></td>"
	_cBody += " <td width='07%' align='Center'  bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>"+AllTrim(Str(SC7->C7_QUANT))+"</font></td>"
	_cBody += " <td width='05%' align='Center'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+SC7->C7_UM+"</font></td>"

	If SC7->C7_MOEDA = 1.0
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>R$ "+Transform(SC7->C7_PRECO,"@E 999,999.999999")+"</font></td>"
		_cBody += " <td width='10%' align='right' 	bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>% "+Transform(SC7->C7_IPI,"@E 999,999.99")+"</font></td>"
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>R$ "+Transform(SC7->C7_TOTAL,"@E 999,999.999999")+"</font></td>"
	Elseif SC7->C7_MOEDA = 2.0
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>$ "+Transform(SC7->C7_PRECO,"@E 999,999.999999")+"</font></td>"
		_cBody += " <td width='10%' align='right' 	bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>% "+Transform(SC7->C7_IPI,"@E 999,999.99")+"</font></td>"
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>$ "+Transform(SC7->C7_TOTAL,"@E 999,999.999999")+"</font></td>"		    
	Elseif SC7->C7_MOEDA = 4.0		                                                                                                                                 
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>€ "+Transform(SC7->C7_PRECO,"@E 999,999.999999")+"</font></td>"
		_cBody += " <td width='10%' align='right' 	bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>% "+Transform(SC7->C7_IPI,"@E 999,999.99")+"</font></td>"
		_cBody += " <td width='10%' align='right'	bgcolor='"+cBgColor+"' ><font face='Tahoma' size='1'>€ "+Transform(SC7->C7_TOTAL,"@E 999,999.999999")+"</font></td>"	
    Endif
    
	_cBody += " <td width='07%' align='Center'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+DTOC(SC7->C7_DATPRF)+"</font></td>"
	_cBody += " <td width='07%' align='Center'  bgcolor='"+cBgColor+"'><font face='Tahoma' size='1'>"+SC7->C7_OBS+"</font></td>"
	_cBody += " <td width='06%' align='Center'  bgcolor='"+cBgColorC+"'><font face='Tahoma' size='1'>"+SC7->C7_NUMSC+"</font></td>"
	_cBody += "</tr>"

	xValIpi := (xValIpi + SC7->C7_VALIPI)
	nValTot := (nValTot+SC7->C7_TOTAL+SC7->C7_VALIPI) 
	cOBSItem := SC7->C7_OBS
		
	
	DbSkip()
	Loop
	
ENDDO
_cBody += "</table>"

// LINHA HORIZONTAL 100%

_cBody += " <hr> "

dBselectArea('SC7')
dbSetOrder(1)
SET DELETE ON
SC7->(DbSeek(MV_PAR02+(mv_par01),.t.))

If SC7->C7_MOEDA = 1.0

	// FINALIZA PEDIDO INFORMANDO VALOR DE IPI DO PEDIDO//

	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor IPI: <b>R$ "+Transform(xValIpi,"@E 999,999.99")+"</b></font></tr>"
	_cBody += "</body>"

	// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	_cBody += "</body>"

	// FINALIZA PEDIDO INFORMANDO VALOR TOTAL DO PEDIDO//

	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor Total: <b>R$ "+Transform(nValTot,"@E 999,999.999999")+"</b></font></tr>"
	_cBody += "</body>"

ElseIf SC7->C7_MOEDA = 2.0
	
	// FINALIZA PEDIDO INFORMANDO VALOR DE IPI DO PEDIDO//

	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor IPI: <b>$ "+Transform(xValIpi,"@E 999,999.99")+"</b></font></tr>"
	_cBody += "</body>"
	
	// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA
	
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	_cBody += "</body>"
	
	// FINALIZA PEDIDO INFORMANDO VALOR TOTAL DO PEDIDO//
	
	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor Total: <b>$ "+Transform(nValTot,"@E 999,999.999999")+"</b></font></tr>"
	_cBody += "</body>"   

ElseIf SC7->C7_MOEDA = 4.0

	// FINALIZA PEDIDO INFORMANDO VALOR DE IPI DO PEDIDO//

	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor IPI: <b>€ "+Transform(xValIpi,"@E 999,999.99")+"</b></font></tr>"
	_cBody += "</body>"
	
	// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA
	
	_cBody += "<body>"
	_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
	_cBody += "</body>"
	
	// FINALIZA PEDIDO INFORMANDO VALOR TOTAL DO PEDIDO//
	
	_cBody += "<body>"
	_cBody += "   <tr><font face=Verdana size=1 color=#000000>Valor Total: <b>€ "+Transform(nValTot,"@E 999,999.999999")+"</b></font></tr>"
	_cBody += "</body>"   

	
Endif	

// LINHA HORIZONTAL 100%

_cBody += " <hr> "

///////////////////////  OBSERVAÇÕES NO RODAPÉ DO PEDIDO //////////////////////////////////////////////////////

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=0 color=#000000><b> OBSERVAÇÕES: <b></b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - Favor Acusar o Recebimento do Pedido;</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - Informar na N.F., o nº do Pedido e o Código do Produto;</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - Toda Mercadoria Fica Sujeita a Analise do Nosso Controle de Qualidade;</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - Qualquer Irregularidade ou Desacordo com o Pedido, Reserva-nos o Direito de Devolução no Prazo de 30 dias</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> 	sem Assumir a Responsabilidade por Frete ou Qualquer Outra Despesa que Venha Acarretar;</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> -	+++FAVOR ENVIAR CERTIFICADO ANALISE e FISPQ (Quando for produto químico) +++</b></font></tr>" 
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - As Entregas Devem Ser 100% no Prazo;</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=1 color=#000000><b> - Enviar arquivo XML para nfelogistica@brascola.com.br.</b></font></tr>"
_cBody += "</body>"

// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

// OBS DO PEDIDO - CAMPO C7_OBS //

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>-> OBSERVAÇÃO DO COMPRADOR: "+MV_PAR06+"</b></font></tr>"
_cBody += "</body>"



///////////////////////  FINALIZA AS OBSERVAÇÕES //////////////////////////////////////////////////////


// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

// LOCAL DE ENTREGA

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>-> LOCAL DE ENTREGA: "+ALLTRIM(SM0->M0_ENDENT)+" - "+ALLTRIM(SM0->M0_CIDENT)+"."+ ALLTRIM(SM0->M0_ESTENT)+" - CEP: "+ALLTRIM(SM0->M0_CEPENT)+"</b></font></tr>"
_cBody += "</body>"

// LOCAL DE COBRANÇA

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>-> LOCAL DE COBRANCA: "+ALLTRIM(SM0->M0_ENDCOB)+" - "+ALLTRIM(SM0->M0_CIDCOB)+". "+ALLTRIM(SM0->M0_ESTCOB)+" - CEP: "+ALLTRIM(SM0->M0_CEPCOB)+"</b></font></tr>"
_cBody += "</body>"

// LINHA HORIZONTAL 100%

_cBody += " <hr> "

// PULA DE LINHA MAIOR ESCREVENDO (.) NA COR BRANCA

_cBody += "<body>"
_cBody += "   <td><font face='Tahoma' size='2' color='#ffffff' >.</font></b></td>"
_cBody += "</body>"

//ASSINATURA DO COMPRADOR

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000><b>Atenciosamente:</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>"+cNomeUser+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>"+NmailUser+"</b></font></tr>"
_cBody += "</body>"

_cBody += "<body>"
_cBody += "   <tr><font face=Verdana size=-1 color=#000000>Brascola LTDA</b></font></tr>"
_cBody += "</body>"

// FINALIZO O HTML NO CORPO DO E-MAIL

_cBody +="</table>"
_cBody +="</BODY>"
_cBody +="</html>"     

Return

///////////////////////////
///////////////////////////
/////FUNÇÃO QUE ENVIA E-MAIL ATACHADO /////////

Static Function UEmail()

If Empty(cMailFor)
   If MsgYesNo("Fornecedor sem e-mail Cadastrado, Deseja Enviar E-mail ? ")
   
   Else
       Return
   Endif
Endif
                                                        

// Alimento variavel com E-mail´s de destino //////// 

cMaiDes := (alltrim(cMailUser)+";"+alltrim(cMailFor)+";"+alltrim(cMailOut))
//cMaiDes := "charles.medeiros@brascola.com.br"


//Verifico se existe E-mail Destino
If Empty(cMaiDes)
	MsgBox("Não existe e-mail destino Cadastrado ou Parametrizado !!")
	RETURN
Endif

_cServer  := 	GetMV("MV_RELSERV")   // Servidor
_cConta 	:=  Alltrim(cMailUser)  // Conta
cEnvia    := 	Alltrim(cMailUser)  // Conta
//cMaiDes   := 	(cMailUser+";"+cMailFor+";"+cMailOut)
//_cPass    := 	alltrim(MV_PAR03)   // Senha da conta
cAnexo    := 	' '
nI        := 	1
_cAssunto	:= 	"BRASCOLA - Pedido de Compras "+cPedido
//Local cTos
//Local CRLF      := Chr(13) + Chr(10)

//Validação da parametrização//
/*
If Empty (_cPass)
	MsgBox("Favor Informar Sua Senha de E-mail nos Parametros da Rotina !!")
	RETURN
Endif
*/
If Empty (_cConta)
	MsgBox("Usuário sem conta de e-mail para enviar Pedido !!")
	RETURN
Endif


CONNECT SMTP SERVER _cServer ACCOUNT _cConta PASSWORD _cPass RESULT lConectou

//If lConectou
//msginfo("Conectado com servidor de E-Mail - " + _cServer)
//Endif

//AADD(aFiles,"c:\temp\arq.pdf")
//aadd(aFiles,"\pedidos.htm")
//cAnexo:='C:\P10\Charles\HTMs\pedidos.htm'

//SEND MAIL FROM _cConta TO cMaiDes SUBJECT _cAssunto BODY "" RESULT lOk

//If MsgYesNo("Envia Atachado")
SEND MAIL FROM _cConta;
TO cMaiDes;
SUBJECT _cAssunto ;
BODY _cBody ;
RESULT lEnviado
//ATTACHMENT aFiles[1];
// RESULT lEnviado
//Else
//        SEND MAIL FROM cEnvia;
//        TO cRecebe;
//        SUBJECT 'Email pelo Protheus';
//        BODY cMensagem;
//        RESULT lEnviado
//Endif


If lEnviado
	If !empty (cMailOut)
		MsgBox("Pedidos Enviados Com Sucesso!!!","Aviso","INFO")
		Msginfo(">>> E-mail enviado para Fornecedor "+Alltrim(cMailFor)+" , Comprador: "+alltrim(cMailUser)+ " e Outros: "+Alltrim(cMailOut))
		
		dBselectArea('SC7')
		dbSetOrder(1)
		SC7->(DbSeek(MV_PAR02+(cPedido),.t.))
		
		While !eof().and.SC7->C7_NUM == cPedido
			
			RecLock("SC7",.F.)
			SC7->C7_DATMAIL := Date()
			SC7->C7_USEMAIL := Alltrim(cUsername)
			MsUnLock("SC7")
			
			DbSkip()
						
		ENDDO
		
	Else
		Msginfo("Enviado E-Mail para Fornecedor: "+Alltrim(cMailFor)+ " e Comprador: "+Alltrim(cMailUser))

		dBselectArea('SC7')
		dbSetOrder(1)
		SC7->(DbSeek(MV_PAR02+(cPedido),.t.))

   		While !eof().and.SC7->C7_NUM == cPedido
			
			RecLock("SC7",.F.)
			SC7->C7_DATMAIL := Date()
			SC7->C7_USEMAIL := Alltrim(cUsername)
			MsUnLock("SC7")
			
			DbSkip()
						
		ENDDO
		
	Endif
Else
	cMensagem := ""
	GET MAIL ERROR cMensagem
	Alert(cMensagem)
Endif

DISCONNECT SMTP SERVER Result lDisConectou

//SM0->( RestArea(aAreaSM0) )

//dBselectArea('SC7')
//dbSetOrder(1)

//SC7->( RestArea(aAreaSC7) )

//RestArea(aAreaSC7)
//RestArea(aAreaSM0)

Close(oDlg)    
  
//If lDisConectou
//	Msginfo("Desconectado com servidor de E-Mail - " + _cServer)
//Endif

Return

Static Function Imprimef(cAlias,nReg,nOpcx)

LOCAL wnrel		:= "MATR110"
LOCAL cDesc1	:= STR0001	//"Emissao dos pedidos de compras ou autorizacoes de entrega"
LOCAL cDesc2	:= STR0002	//"cadastradados e que ainda nao foram impressos"
LOCAL cDesc3	:= " "
LOCAL cString	:= "SC7"   
LOCAL cQuery,cQuer2  //Querys de Inspecao de Entrada
LOCAL _cRevQ8,_cTexto   

PRIVATE lAuto		:= (nReg!=Nil)
PRIVATE Tamanho	:= "G"
PRIVATE titulo	 	:=STR0003										//"Emissao dos Pedidos de Compras ou Autorizacoes de Entrega"
PRIVATE aReturn 	:= {STR0004, 1,STR0005, 1, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog	:="RCOMR01"             
PRIVATE nLastKey	:= 0
PRIVATE nBegin		:= 0
PRIVATE nDifColCC   := 0
PRIVATE aLinha		:= {}
PRIVATE aSenhas		:= {}
PRIVATE aUsuarios	:= {}
PRIVATE M_PAG	:= 1
If Type("lPedido") != "L"
	lPedido := .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01               Do Pedido                             ³
//³ mv_par02               Ate o Pedido                          ³
//³ mv_par03               A partir da data de emissao           ³
//³ mv_par04               Ate a data de emissao                 ³
//³ mv_par05               Somente os Novos                      ³
//³ mv_par06               Campo Descricao do Produto    	     ³
//³ mv_par07               Unidade de Medida:Primaria ou Secund. ³
//³ mv_par08               Imprime ? Pedido Compra ou Aut. Entreg³
//³ mv_par09               Numero de vias                        ³
//³ mv_par10               Pedidos ? Liberados Bloqueados Ambos  ³
//³ mv_par11               Impr. SC's Firmes, Previstas ou Ambas ³
//³ mv_par12               Qual a Moeda ?                        ³
//³ mv_par13               Endereco de Entrega                   ³
//³ mv_par14               todas ou em aberto ou atendidos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
Pergunte("MTR110",.F.)                                           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se no SX3 o C7_CC esta com tamanho 9 (Default) se igual a 9 muda o tamanho do relatorio           ³
//³ para Medio possibilitando a impressao em modo Paisagem ou retrato atraves da reducao na variavel nDifColCC ³
//³ se o tamanho do C7_CC no SX3 estiver > que 9 o relatorio sera impresso comprrimido com espaco para o campo ³
//³ C7_CC centro de custo para ate 20 posicoes,Obs.desabilitando a selecao do modo de impresso retrato/paisagem³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3")
dbSetOrder(2)
If dbSeek("C7_CC")
   If SX3->X3_TAMANHO == 9
	nDifColCC := 11
     Tamanho   := "M"
   Endif
Endif 

//Tamanho   := "G"

wnrel:=SetPrint(cString,wnrel,If(lAuto,Nil,"MTR110"),@Titulo,cDesc1,cDesc2,cDesc3,.T.,,,Tamanho,,!lAuto)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

If lAuto
	mv_par08 := SC7->C7_TIPO
EndIf

If lPedido
	mv_par12 := MAX(SC7->C7_MOEDA,1)
Endif

If mv_par08 == 1
	RptStatus({|lEnd| C110PC(@lEnd,wnRel,cString,nReg)},titulo)
Else
	RptStatus({|lEnd| C110AE(@lEnd,wnRel,cString,nReg)},titulo)
EndIf

lPedido := .F.

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110PC   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110PC(lEnd,WnRel,cString,nReg)
Local nReem
Local nOrder
Local cCondBus
Local nSavRec
Local aSavRec := {}
Local nLinObs := 0 
Local i       := 0
Local ncw     := 0

Private cCGCPict, cCepPict
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

If nDifColCC >0
   limite   := 129
Else
   limite   := 141   
Endif

li       := 80
nDescProd:= 0
nTotal   := 0
nTotMerc := 0
NumPed   := Space(6)

	 
If lAuto
	dbSelectArea("SC7")
	dbGoto(nReg)
	SetRegua(1)
	mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	mv_par05 := 2
	mv_par08 := C7_TIPO
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
EndIf
                 
//Utilizado o parametro MV_PCOMPRA 
   mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	//mv_par05 := 2
	//mv_par08 := C7_TIPO
	//mv_par09 := 1
	//mv_par10 := 3
	//mv_par11 := 3

If ( cPaisLoc$"ARG|POR|EUA" )
	cCondBus	:=	"1"+strzero(val(mv_par01),6)
	nOrder	:=	10
	nTipo		:= 1 
Else
	cCondBus	:=mv_par01
	nOrder	:=	1
EndIf

dbSelectArea("SC7")
dbSetOrder(nOrder)
SetRegua(RecCount())
dbSeek(xFilial("SC7")+cCondBus,.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay AvalImp(Iif(nDifColCC > 0,132,220))

While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. ;
		C7_NUM <= mv_par02
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (C7_CONAPRO != "B" .And. mv_par10 == 2)
		dbSkip()
		Loop
	Endif
	If (C7_EMISSAO < mv_par03) .Or. (C7_EMISSAO > mv_par04)
		dbSkip()
		Loop
	Endif
	If C7_TIPO == 2
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. EM ABERTO                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par14 == 2
		If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
	    	dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par14 == 3
		If SC7->C7_QUANT > SC7->C7_QUJE
	    	dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
		dbSkip()
		Loop
	EndIf
		
	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec(ncw)
		
		nTotal   := 0
		nTotMerc	:= 0
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
        nLinObs  := 0

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. EM ABERTO                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par14 == 2
				If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
			    	dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. ATENDIDOS                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par14 == 3
				If SC7->C7_QUANT > SC7->C7_QUJE
			    	dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif
		
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
			If lEnd
				@PROW()+1,001 PSAY STR0006	//"CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 56
				nOrdem++
				ImpRodape()			// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec(ncw)
			Endif
			
			li++
			
			@ li,001 PSAY "|"
			@ li,002 PSAY C7_ITEM  		Picture PesqPict("SC7","c7_item")
			@ li,006 PSAY "|"
			@ li,007 PSAY C7_PRODUTO	Picture PesqPict("SC7","c7_produto")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pesquisa Descricao do Produto                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ImpProd()        
			
			
			ImpInsp()
			
			
         
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
				nDescProd+=SC7->C7_VLDESC
			Endif 
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
                nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif
            
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)
        
		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec(ncw)
		Endif

		FinalPed(nDescProd)		// Imprime os dados complementares do PC
        
	Next

	MaFisEnd()
		
	If Len(aSavRec)>0
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			Replace C7_EMITIDO With "S"
			MsUnLock()
		Next
		dbGoto(aSavRec[Len(aSavRec)])		// Posiciona no ultimo elemento e limpa array
	Endif
	
	aSavRec := {}
	
	dbSkip()
EndDo

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)

if aReturn[5] == 3
	Eject
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C110AE   ³ Autor ³ Cristina M. Ogura     ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR110			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C110AE(lEnd,WnRel,cString,nReg)
Local nReem
Local nSavRec,aSavRec := {}
Local nLinObs := 0 
Local ncw     := 0
Local i       := 0

Private cCGCPict, cCepPict
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definir as pictures                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cCepPict:=PesqPict("SA2","A2_CEP")
cCGCPict:=PesqPict("SA2","A2_CGC")

If nDifColCC >0
   limite   := 129
Else
   limite   := 141   
Endif

li       := 80
nDescProd:= 0
nTotal   := 0
nTotMerc	:= 0
NumPed   := Space(6)

If !lAuto
	dbSelectArea("SC7")
	dbSetOrder(10)
	dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
Else
	dbSelectArea("SC7")
	dbGoto(nReg)
	mv_par01 := C7_NUM
	mv_par02 := C7_NUM
	mv_par03 := C7_EMISSAO
	mv_par04 := C7_EMISSAO
	mv_par05 := 2
	mv_par08 := C7_TIPO
	mv_par09 := 1
	mv_par10 := 3
	mv_par11 := 3
	dbSelectArea("SC7")
	dbSetOrder(10)
	dbSeek(xFilial("SC7")+"2"+mv_par01,.T.)
EndIf

SetRegua(Reccount())
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz manualmente porque nao chama a funcao Cabec()                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
@ 0,0 PSay AvalImp(Iif(nDifColCC > 0,132,220))
While !Eof().And.C7_FILIAL = xFilial("SC7") .And. C7_NUM >= mv_par01 .And. C7_NUM <= mv_par02
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria as variaveis para armazenar os valores do pedido        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOrdem   := 1
	nReem    := 0
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	
	If C7_EMITIDO == "S" .And. mv_par05 == 1
    	dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If (C7_CONAPRO == "B" .And. mv_par10 == 1) .Or.;
	   (C7_CONAPRO != "B" .And. mv_par10 == 2)
    	dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If (SC7->C7_EMISSAO < mv_par03) .Or. (SC7->C7_EMISSAO > mv_par04)
    	dbSelectArea("SC7")
		dbSkip()
		Loop
	Endif
	If SC7->C7_TIPO != 2
    	dbSelectArea("SC7")
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. EM ABERTO                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par14 == 2
		If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
	    	dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste este item. ATENDIDOS                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par14 == 3
		If SC7->C7_QUANT > SC7->C7_QUJE
	    	dbSelectArea("SC7")
			dbSkip()
			Loop
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra Tipo de SCs Firmes ou Previstas                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !MtrAValOP(mv_par11, 'SC7')
    	dbSelectArea("SC7")
		dbSkip()
		Loop
	EndIf
	
	MaFisEnd()
	MaFisIniPC(SC7->C7_NUM)

	For ncw := 1 To mv_par09		// Imprime o numero de vias informadas
		
		ImpCabec(ncw)

		nTotal   := 0
		nTotMerc	:= 0
		
		nDescProd:= 0
		nReem    := SC7->C7_QTDREEM + 1
		nSavRec  := SC7->(Recno())
		NumPed   := SC7->C7_NUM
        nLinObs := 0 

		While !Eof() .And. C7_FILIAL = xFilial("SC7") .And. C7_NUM == NumPed
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. EM ABERTO                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par14 == 2
				If SC7->C7_QUANT-SC7->C7_QUJE <= 0 .Or. !EMPTY(SC7->C7_RESIDUO)
			    	dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Consiste este item. ATENDIDOS                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par14 == 3
				If SC7->C7_QUANT > SC7->C7_QUJE
			    	dbSelectArea("SC7")
					dbSkip()
					Loop
				Endif
			Endif
			
			If Ascan(aSavRec,Recno()) == 0		// Guardo recno p/gravacao
				AADD(aSavRec,Recno())
			Endif
						
			If lEnd
				@PROW()+1,001 PSAY STR0006		//"CANCELADO PELO OPERADOR"
				Goto Bottom
				Exit
			Endif
			
			IncRegua()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se havera salto de formulario                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If li > 56
				nOrdem++
				ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
				ImpCabec(ncw)
			Endif
			li++
			@ li,001 PSAY "|"
			@ li,002 PSAY SC7->C7_ITEM  	Picture PesqPict("SC7","C7_ITEM")
			@ li,006 PSAY "|"
			@ li,007 PSAY SC7->C7_PRODUTO	Picture PesqPict("SC7","C7_PRODUTO")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Pesquisa Descricao do Produto                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ImpProd()		// Imprime dados do Produto
			
			If SC7->C7_DESC1 != 0 .or. SC7->C7_DESC2 != 0 .or. SC7->C7_DESC3 != 0
				nDescProd+= CalcDesc(SC7->C7_TOTAL,SC7->C7_DESC1,SC7->C7_DESC2,SC7->C7_DESC3)
			Else
			   nDescProd+=SC7->C7_VLDESC
			Endif		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializacao da Observacao do Pedido.                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If !EMPTY(SC7->C7_OBS) .And. nLinObs < 5
                nLinObs++
				cVar:="cObs"+StrZero(nLinObs,2)
				Eval(MemVarBlock(cVar),SC7->C7_OBS)
			Endif                                                             

         	dbSelectArea("SC7")
			dbSkip()
		EndDo
		
		dbGoto(nSavRec)
		If li>38
			nOrdem++
			ImpRodape()		// Imprime rodape do formulario e salta para a proxima folha
			ImpCabec(ncw)
		Endif
		
		FinalAE(nDescProd)		// dados complementares da Autorizacao de Entrega
	Next

	MaFisEnd()
	
	If Len(aSavRec)>0
		dbGoto(aSavRec[Len(aSavRec)])
		For i:=1 to Len(aSavRec)
			dbGoto(aSavRec[i])
			RecLock("SC7",.F.)  //Atualizacao do flag de Impressao
			Replace C7_EMITIDO With "S"
			Replace C7_QTDREEM With (C7_QTDREEM+1)
			MsUnLock()
		Next
	Endif
	aSavRec := {}
    dbSelectArea("SC7")
	dbSkip()
End

dbSelectArea("SC7")
dbClearFilter()
dbSetOrder(1)

dbSelectArea("SX3")
dbSetOrder(1)
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpProd  ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Pesquisar e imprimir  dados Cadastrais do Produto.         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpProd(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpProd()
LOCAL nBegin := 0, cDescri := "", nLinha:=0
Local	nTamDesc := 26, aColuna := Array(8)

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao generica do Produto.                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B1_DESC"
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek( xFilial()+SC7->C7_PRODUTO)
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao da descricao cientifica do Produto.                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek( xFilial()+SC7->C7_PRODUTO )
		cDescri := Alltrim(B5_CEME)
	EndIf
	dbSelectArea("SC7")
EndIf

dbSelectArea("SC7")
If AllTrim(mv_par06) == "C7_DESCRI"
	cDescri := Alltrim(SC7->C7_DESCRI)
EndIf

If Empty(cDescri)
	dbSelectArea("SB1")
	dbSetOrder(1)
	MsSeek( xFilial()+SC7->C7_PRODUTO )
	cDescri := Alltrim(SB1->B1_DESC)
	dbSelectArea("SC7")
EndIf

dbSelectArea("SA5")
dbSetOrder(1)
If dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO).And. !Empty(SA5->A5_CODPRF)
	cDescri := cDescri + " ("+Alltrim(A5_CODPRF)+")"
EndIf
dbSelectArea("SC7")
aColuna[1] :=  49
aColuna[2] :=  52
aColuna[3] :=  65
aColuna[4] :=  80
aColuna[5] :=  86
aColuna[6] := 103
aColuna[7] := 114
acoluna[8] := 142 - nDifColCC

nLinha:= MLCount(cDescri,nTamDesc)

@ li,022 PSAY "|"
@ li,023 PSAY MemoLine(cDescri,nTamDesc,1)

ImpCampos()

 
For nBegin := 2 To nLinha
	li++
	@ li,001 PSAY "|"
	//@ li,006 PSAY "|"
	//@ li,022 PSAY "|"
	@ li,023 PSAY Memoline(cDescri,nTamDesc,nBegin)
	//@ li,aColuna[1] PSAY "|"
	//@ li,acoluna[2] PSAY "|"  
	//@ li,acoluna[3] PSAY "|"  
   // @ li,aColuna[4] PSAY "|"

	//If mv_par08 == 1
	//   	If cPaisLoc == "BRA"
	//    	@ li,aColuna[5] PSAY "|"
	//	else
	//		@ li,aColuna[5] PSAY " "
	//	EndIf
		@ li,aColuna[6] PSAY "|^^^^^^^^^^|"
	//@ li,114 PSAY "|"
	 //	@ li,135 - nDIfColCC PSAY "|"
		@ li,aColuna[8] PSAY "|"
	//Else
	//	@ li,097 PSAY "|"
	//	@ li,108 PSAY "|"
	//	@ li,142 - nDifColCC PSAY "|"
	//EndIf
Next nBegin
  


Return NIL
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCampos³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprimir dados Complementares do Produto no Pedido.        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCampos(Void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCampos()

LOCAL aColuna[6]
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)
dbSelectArea("SC7")

	aColuna[1] :=  49
	aColuna[2] :=  52
	aColuna[3] :=  65
	aColuna[4] :=  80
	aColuna[5] :=  86
	aColuna[6] := 103

@ li,aColuna[1] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_SEGUM)
   @ li,PCOL() PSAY SC7->C7_SEGUM Picture PesqPict("SC7","C7_UM")
Else
   @ li,PCOL() PSAY SC7->C7_UM    Picture PesqPict("SC7","C7_UM")
EndIf
@ li,aColuna[2] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM) 
   @ li,PCOL()	PSAY SC7->C7_QTSEGUM Picture PesqPictQt("C7_QUANT",12)
Else
   @ li,PCOL()	PSAY SC7->C7_QUANT   Picture PesqPictQt("C7_QUANT",12)
EndIf
@ li,aColuna[3] PSAY "|"
If MV_PAR07 == 2 .And. !Empty(SC7->C7_QTSEGUM)  
   @ li,PCOL()	PSAY xMoeda((SC7->C7_TOTAL/SC7->C7_QTSEGUM),SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture PesqPict("SC7","C7_PRECO",14, mv_par12)
Else
   @ li,PCOL()	PSAY xMoeda(SC7->C7_PRECO,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture PesqPict("SC7","C7_PRECO",14,mv_par12)
EndIf
@ li,aColuna[4] PSAY "|"

If mv_par08 == 1
	If cPaisLoc == "BRA"
		@ li,    PCOL() PSAY SC7->C7_IPI Picture PesqPictQt("C7_IPI",5)
		@ li,    aColuna[5] PSAY "|"
	Else
		@ li,    PCOL() 	PSAY "  "
		@ li,aColuna[5]-2 	PSAY " "
		@ li,    PCOL() 	PSAY " "
	EndIf
	@ li,    PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture PesqPict("SC7","C7_TOTAL",16,mv_par12)
	@ li,aColuna[6] PSAY "|"
	@ li,  (PCOL())+1 PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,114 PSAY "|"
	@ li,PCOL() PSAY SC7->C7_CC      				 Picture PesqPict("SC7","C7_CC",20)
	@ li,135 - nDifColCC PSAY "|"
	@ li,  PCOL() PSAY SC7->C7_NUMSC
	@ li,142 - nDifColCC PSAY "|"
Else
   @ li,  PCOL() PSAY xMoeda(SC7->C7_TOTAL,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture PesqPict("SC7","C7_TOTAL",16,mv_par12)
	@ li,  097 PSAY "|"
	@ li,  PCOL() PSAY SC7->C7_DATPRF  				 Picture PesqPict("SC7","C7_DATPRF")
	@ li,  108 PSAY "|"
	// Tenta imprimir OP
	If !Empty(SC7->C7_OP)
		@ li,  PCOL() PSAY STR0065
		@ li,  PCOL() PSAY SC7->C7_OP
	// Caso Op esteja vazia imprime Centro de Custos
	ElseIf !Empty(SC7->C7_CC)
		@ li,  PCOL() PSAY STR0066
		@ li,PCOL() PSAY SC7->C7_CC      				 Picture PesqPict("SC7","C7_CC",20)
	EndIf
	@ li,142 - nDifColCC PSAY "|"
EndIf 

nTotal  :=nTotal+SC7->C7_TOTAL
nTotMerc:=MaFisRet(,"NF_TOTAL")
Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPINSP   ºAutor  ³Daniel Neves        º Data ³  09/23/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Imprime as Inspecoes de acordo com as tabelas QE7 e QE8.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

STATIC FUNCTION ImpInsp()          
DBSELECTAREA("SC7")

_cProdC7 := SC7->C7_PRODUTO 
_cProd   := ""
_cEnsaio := ""
_cRevQ8  := ""
_cTexto  := ""          

cQuery := "SELECT MAX(QE7_REVI)REVISAO,(QE7_PRODUT)PRODUT,(QE7_ENSAIO)ENSAIO,(QE7_LIE)LIE,(QE7_LSE)LSE,(QE7_NOMINA)NOM,(QE1_DESCPO)DESCPO "
cQuery += "FROM "+RetSqlName("QE7")+","+RetSqlName("QE1")+" "
cQuery += "WHERE QE7_PRODUT = '"+_cProdC7+"' AND QE1_ENSAIO = QE7_ENSAIO AND "    
cQuery += RetSqlName("QE7")+".D_E_L_E_T_ <> '*' AND "+RetSqlName("QE1")+".D_E_L_E_T_ <> '*' "
cQuery += "GROUP BY QE7_PRODUT,QE7_ENSAIO,QE7_LIE,QE7_LSE,QE7_NOMINA,QE1_DESCPO " 
 
DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.F.)
                                        
cQuer2 := "SELECT MAX(QE8_REVI)REVISAO,(QE8_PRODUT)PRODUT, (QE8_TEXTO)TEXTO "
cQuer2 += "FROM "+RetSqlName("QE8")+","+RetSqlName("QE1")+" "
cQuer2 += "WHERE QE8_PRODUT = '"+_cProdC7+"' AND QE1_ENSAIO = QE8_ENSAIO AND "      
cQuer2 += RetSqlName("QE8")+".D_E_L_E_T_ <> '*' AND "+RetSqlName("QE1")+".D_E_L_E_T_ <> '*' " 
cQuer2 += "GROUP BY QE8_PRODUT, QE8_REVI, QE8_TEXTO "

DBUseArea(.T.,"TOPCONN",TcGenQry(,,cQuer2),"TM2",.F.,.F.)

DBSELECTAREA("TMP")
DBSELECTAREA("TM2")


AREAC7 := SC7->(GETAREA())    
TMP->(dBGotop())
TM2->(dBGotop())

DO WHILE TMP->(!EOF()) 
_cRevisao := TMP->REVISAO
_cProd    := TMP->PRODUT
_cEnsaio  := TMP->ENSAIO
_cLIE     := TMP->LIE
_cLSE     := TMP->LSE                                 
_cNom     := TMP->NOM
_cDescpo  := TMP->DESCPO  

IF !empty(_cRevisao) .and. !empty(_cDescpo) 
li++              
 @ li, 001  PSAY "|"
 @ li, 002  PSAY "Especificacoes: "
 @ li, 019  PSAY SUBSTR(_cDescpo,1,60)
 @ li, 080  PSAY "NOR:"
 @ li, 085  PSAY _cNom
 @ li, 095  PSAY "MIN:" 
 @ li, 098  PSAY _cLIE
 @ li, 108  PSAY "MAX:"
 @ li, 113  PSAY _cLSE
 @ li, 131  PSAY "|"
ENDIF
TMP->(DBSKIP())
ENDDO

DO WHILE TM2->(!EOF()) 
_cRevQ8   := TM2->REVISAO
_cProdQ8  := TM2->PRODUT
_cTexto   := TM2->TEXTO 
IF !empty(_cRevQ8) .and. !empty(_cTexto) 
li++ 
 @ li, 001  PSAY "|"
 @ li, 002  PSAY "Aparencia: "
 @ li, 019  PSAY _cTexto
 @ li, 131  PSAY "|"

ENDIF                                

TM2->(DBSKIP())
ENDDO


If Select("TMP") > 0 .or. Select("TM2") > 0
li++
@ li, 001 PSAY "|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -|"
ENDIF 

DBSELECTAREA("TMP")
If Select("TMP") > 0
	TMP->(DBCLOSEAREA())
Endif

DBSELECTAREA("TM2")
If Select("TM2") > 0
	TM2->(DBCLOSEAREA())
Endif

DBSELECTAREA("SC7")
SC7->(RESTAREA(AREAC7))
   
//FIM

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalPed ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares do Pedido de Compra        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalPed(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalPed(nDescProd)

Local nk 		:= 1,nG
Local nX       := 0
Local nQuebra	:= 0
Local nTotDesc	:= nDescProd
Local lNewAlc	:= .F.
Local lLiber 	:= .F.
Local lImpLeg	:= .T.
Local cComprador:=""
LOcal cAlter	:=""
Local cAprov	:=""
Local nTotIpi	:= MaFisRet(,'NF_VALIPI')
Local nTotIcms	:= MaFisRet(,'NF_VALICM')
Local nTotDesp	:= MaFisRet(,'NF_DESPESA')
Local nTotFrete	:= MaFisRet(,'NF_FRETE')
Local nTotalNF	:= MaFisRet(,'NF_TOTAL')
Local nTotSeguro:= MaFisRet(,'NF_SEGURO')
Local aValIVA   := MaFisRet(,"NF_VALIMP")
Local nValIVA   :=0
Local aColuna   := Array(8), nTotLinhas
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil)

If cPaisLoc <> "BRA" .And. !Empty(aValIVA)
   For nG:=1 to Len(aValIVA)
       nValIVA+=aValIVA[nG]
   Next
Endif
cMensagem:= Formula(C7_MSG)

If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,142 - nDifColCC PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++

aColuna[1] :=  49
aColuna[2] :=  52
aColuna[3] :=  65
aColuna[4] :=  80
aColuna[5] :=  86
aColuna[6] := 103
acoluna[7] := 114
aColuna[8] := 142 - nDifColCC 
nTotLinhas :=  39

//li := nTotLinhas //Daniel 
   

While li<nTotLinhas
	@ li,001 PSAY "|"
	@ li,006 PSAY "|"
	@ li,022 PSAY "|"
	@ li,022 + nk PSAY "*"
	nk := IIf( nk == 42 , 1 , nk + 1 )
	@ li,aColuna[1] PSAY "|"
	@ li,aColuna[2] PSAY "|"
	@ li,aColuna[3] PSAY "|"
	@ li,aColuna[4] PSAY "|"
	If cPaisLoc == "BRA"
		@ li,aColuna[5] PSAY "|"
	EndIf
	@ li,aColuna[6] PSAY "|"
	@ li,114 PSAY "|"
	@ li,135 - nDifColCC PSAY "|"
	@ li,aColuna[8] PSAY "|"
	li++
EndDo

@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,015 PSAY STR0007		//"D E S C O N T O S -->"
@ li,037 PSAY C7_DESC1 Picture "999.99"
@ li,046 PSAY C7_DESC2 Picture "999.99"
@ li,055 PSAY C7_DESC3 Picture "999.99"

@ li,068 PSAY xMoeda(nTotDesc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture PesqPict("SC7","C7_VLDESC",14, mv_par12)

@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(MV_PAR13)
	@ li,003 PSAY STR0008 + SM0->M0_ENDENT		//"Local de Entrega  : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDENT
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTENT
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
Else
	@ li,003 PSAY STR0008 + MV_PAR13		//"Local de Entrega  : " imprime o endereco digitado na pergunte
Endif

@ li,142 - nDifColCC PSAY "|"
dbGoto(nRegistro)
dbSelectArea( cAlias )

li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0010 + SM0->M0_ENDCOB		//"Local de Cobranca : "
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY STR0009	//"CEP :"
@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,15)		//"Condicao de Pagto "
@ li,038 PSAY STR0012		//"|Data de Emissao|"
@ li,056 PSAY STR0013		//"Total das Mercadorias : "
@ li,094 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
If cPaisLoc<>"BRA"
   	@ li,056 PSAY OemtoAnsi(STR0063)	//"Total de los Impuestos : "
	@ li,094 PSAY xMoeda(nValIVA,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nValIVA,14,MsDecimais(MV_PAR12))
Else
	@ li,056 PSAY STR0064		//"Total com Impostos : "
	@ li,094 PSAY xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotMerc,14,MsDecimais(MV_PAR12))
Endif
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
dbSelectArea("SM4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")

@ li,001 PSAY "|"
@ li,003 PSAY STR0014		//"Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust",,mv_par12)
@ li,018 PSAY substr(SM4->M4_DESCR,1,33)

If cPaisLoc == "BRA"
	@ li,054 PSAY STR0015		//"| IPI   :"
	@ li,064 PSAY xMoeda(nTotIPI,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotIpi,14,MsDecimais(MV_PAR12))
	@ li,088 PSAY "| ICMS   : "
	@ li,100 PSAY xMoeda(nTotIcms,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotIcms,14,MsDecimais(MV_PAR12))
	@ li,142 - nDifColCC PSAY "|"
Else	
	@ li,054 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
EndIf

li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY (STR0049) //"| Frete :"
@ li,064 PSAY xMoeda(nTotFrete,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotFrete,14,MsDecimais(MV_PAR12))
@ li,088 PSAY (STR0058) //"| Despesas :"
@ li,100 PSAY xMoeda(nTotDesp,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotDesp,14,MsDecimais(MV_PAR12))

@ li,142 - nDifColCC PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs := cObs01
		cObs01 := Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

dbSelectArea("SC7")
If !Empty(C7_APROV)
	lNewAlc := .T.
	cComprador := UsrFullName(SC7->C7_USER)
	If C7_CONAPRO != "B"
		lLiber := .T.
	EndIf
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbSeek(xFilial()+"PC"+SC7->C7_NUM)
	While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM)==xFilial("SCR")+SC7->C7_NUM .And. SCR->CR_TIPO == "PC"
	  cAprov += AllTrim(UsrFullName(SCR->CR_USER))+" ["+;
	 	  IF(SCR->CR_STATUS=="03","Ok",IF(SCR->CR_STATUS=="04","BLQ","??"))+"] - "
	  dbSelectArea("SCR")
	  dbSkip()
	Enddo
	If !Empty(SC7->C7_GRUPCOM)
		dbSelectArea("SAJ")
		dbSetOrder(1)
		dbSeek(xFilial()+SC7->C7_GRUPCOM)
		While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
			If SAJ->AJ_USER != SC7->C7_USER
				cAlter += AllTrim(UsrFullName(SAJ->AJ_USER))+"/"
			EndIf
			dbSelectArea("SAJ")
			dbSkip()
		EndDo
	EndIf
EndIf

li++
@ li,001 PSAY STR0016		//"| Observacoes"
@ li,054 PSAY STR0017		//"| Grupo :"
@ li,088 PSAY STR0059      //"| SEGURO :"
@ li,100 PSAY xMoeda(nTotSeguro,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotSeguro,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"+Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY STR0018		//"| Total Geral : "

If !lNewAlc
	@ li,094 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotalNF,14,MsDecimais(MV_PAR12))
Else
	If lLiber
		@ li,094 PSAY xMoeda(nTotalNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotalNF,14,MsDecimais(MV_PAR12))
	Else
		@ li,080 PSAY (STR0051)
	EndIf
EndIf
		
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"+Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++

If !lNewAlc
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,061 PSAY STR0019		//"|           Liberacao do Pedido"
	@ li,102 PSAY STR0020		//"| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"+Replicate("-",59)
	@ li,061 PSAY "|"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	
	li++
	cLiberador := ""
	nPosicao := 0
	@ li,001 PSAY "|"
	@ li,007 PSAY STR0021		//"Comprador"
	@ li,021 PSAY "|"
	@ li,028 PSAY STR0022		//"Gerencia"
	@ li,041 PSAY "|"
	@ li,046 PSAY STR0023		//"Diretoria"
	@ li,061 PSAY "|     ------------------------------"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,021 PSAY "|"
	@ li,041 PSAY "|"
	@ li,061 PSAY "|     " + R110Center(cLiberador) // 30 posicoes
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
Else
	@ li,001 PSAY "|"
	@ li,003 PSAY cObs04
	@ li,054 PSAY "|"
	@ li,059 PSAY IF(lLiber,STR0050,STR0051)		//"     P E D I D O   L I B E R A D O"#"|     P E D I D O   B L O Q U E A D O !!!"
	@ li,102 PSAY STR0020		//"| Obs. do Frete: "
	@ li,119 PSAY IF( SC7->C7_TPFRETE $ "F","FOB",IF(SC7->C7_TPFRETE $ "C","CIF"," " ))
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"+Replicate("-",99)
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,003 PSAY STR0052		//"Comprador Responsavel :"
	@ li,027 PSAY Substr(cComprador,1,60)
	@ li,088 PSAY "|"
	//@ li,089 PSAY STR0060      //"BLQ:Bloqueado"
	@ li,102 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++	
	//nAuxLin := Len(cAlter)
	//@ li,001 PSAY "|"
	//@ li,003 PSAY STR0053		//"Compradores Alternativos :"
	//While nAuxLin > 0 .oR. lImpLeg
	//	@ li,029 PSAY Substr(cAlter,Len(cAlter)-nAuxLin+1,60)
	//	@ li,088 PSAY "|"
	//	If lImpLeg 
	// 		@ li,089 PSAY STR0061   //"Ok:Liberado"
	//		lImpLeg := .F.
	//	EndIf
	//	@ li,102 PSAY "|"
	//	@ li,142 - nDifColCC PSAY "|"
	//	nAuxLin -= 60
	//	li++	
	//EndDo		
	//nAuxLin := Len(cAprov)
	//lImpLeg := .T.
	//@ li,001 PSAY "|"
	//@ li,003 PSAY STR0054		//"Aprovador(es) :"
	//While nAuxLin > 0	.Or. lImpLeg
	//	@ li,019 PSAY Substr(cAprov,Len(cAprov)-nAuxLin+1,70)
	//	@ li,088 PSAY "|"
	//	If lImpLeg
	//		@ li,089 PSAY STR0062  //"??:Aguar.Lib"
	//		lImpLeg := .F.
	//	EndIf
	//	@ li,102 PSAY "|"
	//	@ li,142 - nDifColCC PSAY "|"
	//	nAUxLin -=70
	//	li++	
	//EndDo
	//If nAuxLin == 0
	//	li++
	//EndIf
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"
	li++
//	@ li,001 PSAY STR0024		//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero do nosso Pedido de Compras."
	@ li,001 PSAY "| - Citar na N.F.,o nosso pedido e o codigo o produto usado por vossa empresa."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "| - Toda mercadoria fica sujeita a analise do nosso Controle de Qualidade."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "| - Qualquer irregulariedade ou desacordo com o pedido, reserva-nos o direito de devolucao no prazo de 30 dias sem assumir "
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|   responsabilidade por frete ou qualquer outra despesa que venha acarretar.  + + + FAVOR ENVIAR CERTIFICADO ANALISE + + +"
	@ li,142 - nDifColCC PSAY "|"
	li++           
	@ li,001 PSAY "| Obs. O fornecedor devera entregar 100% na data programada/prevista."
	@ li,142 - nDifColCC PSAY "|"
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Replicate("-",limite)
	@ li,142 - nDifColCC PSAY "|"	
EndIf

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FinalAE  ³ Autor ³ Cristina Ogura        ³ Data ³ 05.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime os dados complementares da Autorizacao de Entrega  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FinalAE(Void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FinalAE(nDescProd)
Local nk := 1
Local nX := 0
Local nTotDesc:= nDescProd
Local nTotNF	:= MaFisRet(,'NF_TOTAL')
Local nTxMoeda := IIF(SC7->C7_TXMOEDA > 0,SC7->C7_TXMOEDA,Nil) 

cMensagem:= Formula(C7_MSG)

If !Empty(cMensagem)
	li++
	@ li,001 PSAY "|"
	@ li,002 PSAY Padc(cMensagem,129)
	@ li,142 - nDifColCC PSAY "|"
Endif
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
While li<39
	@ li,001 PSAY "|"
	@ li,006 PSAY "|"
	@ li,022 PSAY "|"
	@ li,022 + nk PSAY "*"
	nk := IIf( nk == 32 , 1 , nk + 1 )
	@ li,049 PSAY "|"
	@ li,052 PSAY "|"
	@ li,065 PSAY "|"
	@ li,080 PSAY "|"
	@ li,097 PSAY "|"
	@ li,108 PSAY "|"
	@ li,142 - nDifColCC PSAY "|"
	li++
EndDo
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o Arquivo de Empresa SM0.                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cAlias := Alias()
dbSelectArea("SM0")
dbSetOrder(1)   // forca o indice na ordem certa
nRegistro := Recno()
dbSeek(SUBS(cNumEmp,1,2)+SC7->C7_FILENT)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime endereco de entrega do SM0 somente se o MV_PAR13 =" "³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(MV_PAR13)
	@ li,003 PSAY STR0008 + SM0->M0_ENDENT		//"Local de Entrega  : "
	@ li,057 PSAY "-"
	@ li,061 PSAY SM0->M0_CIDENT
	@ li,083 PSAY "-"
	@ li,085 PSAY SM0->M0_ESTENT
	@ li,088 PSAY "-"
	@ li,090 PSAY STR0009	//"CEP :"
	@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPENT),cCepPict)
Else
	@ li,003 PSAY STR0008 + MV_PAR13		//"Local de Entrega  : " imprime o endereco digitado na pergunte
Endif

@ li,142 - nDifColCC PSAY "|"
dbGoto(nRegistro)
dbSelectArea(cAlias)

li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0010 + SM0->M0_ENDCOB		//"Local de Cobranca : "
@ li,057 PSAY "-"
@ li,061 PSAY SM0->M0_CIDCOB
@ li,083 PSAY "-"
@ li,085 PSAY SM0->M0_ESTCOB
@ li,088 PSAY "-"
@ li,090 PSAY STR0009	//"CEP :"
@ li,096 PSAY Trans(Alltrim(SM0->M0_CEPCOB),cCepPict)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"

dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_COND)
dbSelectArea("SC7")
li++
@ li,001 PSAY "|"
@ li,003 PSAY STR0011+SubStr(SE4->E4_COND,1,15)		//"Condicao de Pagto "
@ li,038 PSAY STR0012		// "|Data de Emissao|"
@ li,056 PSAY STR0013		// "Total das Mercadorias : "
@ li,094 PSAY xMoeda(nTotal,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotal,14,MsDecimais(MV_PAR12))

@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,003 PSAY SubStr(SE4->E4_DESCRI,1,34)
@ li,038 PSAY "|"
@ li,043 PSAY SC7->C7_EMISSAO
@ li,054 PSAY "|"
@ li,056 PSAY STR0064		// "Total com Impostos : "
@ li,094 PSAY xMoeda(nTotMerc,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda) Picture tm(nTotMerc,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",52)
@ li,054 PSAY "|"
@ li,055 PSAY Replicate("-",86 - nDifColCC)
@ li,142 - nDifColCC PSAY "|"
li++
dbSelectArea("SM4")
dbSeek(xFilial()+SC7->C7_REAJUST)
dbSelectArea("SC7")
@ li,001 PSAY "|"
@ li,003 PSAY STR0014		//"Reajuste :"
@ li,014 PSAY SC7->C7_REAJUST Picture PesqPict("SC7","c7_reajust",,mv_par12)
@ li,018 PSAY SM4->M4_DESCR
@ li,054 PSAY STR0018		//"| Total Geral : "

@ li,094 PSAY xMoeda(nTotNF,SC7->C7_MOEDA,MV_PAR12,SC7->C7_DATPRF,,nTxMoeda)      Picture tm(nTotNF,14,MsDecimais(MV_PAR12))
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializar campos de Observacoes.                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cObs02)
	If Len(cObs01) > 50
		cObs 	:= cObs01
		cObs01:= Substr(cObs,1,50)
		For nX := 2 To 4
			cVar  := "cObs"+StrZero(nX,2)
			&cVar := Substr(cObs,(50*(nX-1))+1,50)
		Next
	EndIf
Else
	cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
	cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
	cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
	cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
EndIf

li++
@ li,001 PSAY STR0025	//"| Observacoes"
@ li,054 PSAY STR0026	//"| Comprador    "
@ li,070 PSAY STR0027	//"| Gerencia     "
@ li,085 PSAY STR0028	//"| Diretoria    "
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs01
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs02
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs03
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"

li++
@ li,001 PSAY "|"
@ li,003 PSAY cObs04
@ li,054 PSAY "|"
@ li,070 PSAY "|"
@ li,085 PSAY "|"
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY STR0029	//"|   NOTA: So aceitaremos a mercadoria se na sua Nota Fiscal constar o numero da Autorizacao de Entrega."
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpRodape³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o rodape do formulario e salta para a proxima folha³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpRodape(Void)   			         					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 					                     				      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpRodape()
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,070 PSAY STR0030		//"Continua ..."
@ li,142 - nDifColCC PSAY "|"
li++
@ li,001 PSAY "|"
@ li,002 PSAY Replicate("-",limite)
@ li,142 - nDifColCC PSAY "|"
li:=0
Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpCabec ³ Autor ³ Wagner Xavier         ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime o Cabecalho do Pedido de Compra                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ImpCabec(Void)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpCabec(ncw)
Local nOrden, cCGC
LOCAL cMoeda

cMoeda := Iif(mv_par12<10,Str(mv_par12,1),Str(mv_par12,2))

@ 01,001 PSAY "|"
@ 01,002 PSAY Replicate("-",limite)
@ 01,142 - nDifColCC PSAY "|"
//@ 02,001 PSAY "|"
//@ 02,029 PSAY IIf(nOrdem>1,(STR0033)," ")		//" - continuacao"

If mv_par08 == 1 
	@ 02,001 PSAY (STR0031)+" - "//+GetMV("MV_MOEDA"+cMoeda) 	//"| P E D I D O  D E  C O M P R A S"
Else
	@ 02,001 PSAY (STR0032)+" - "//+GetMV("MV_MOEDA"+cMoeda)  //"| A U T. D E  E N T R E G A     "
EndIf

If ( Mv_PAR08==2 )
	@ 02,045 PSAY " N U M E R O :  "
	@ 02,060 PSAY SC7->C7_NUMSC + "/PEDIDO:" + SC7->C7_NUM  //    Picture PesqPict("SC7","c7_num")	
Else
	@ 02,045 PSAY " N U M E R O : "
	@ 02,060 PSAY SC7->C7_NUM    Picture PesqPict("SC7","c7_num")
EndIf

If mv_par08 == 1
@ 02,068 PSAY "ITEM:"+Str(nOrdem,1)
ENDIF
@ 02,090 PSAY IIf(SC7->C7_QTDREEM>0,Str(SC7->C7_QTDREEM+1,2)+STR0034+Str(ncw,2)+STR0035," ")		//"a.Emissao "###"a.VIA"
@ 02,131 PSAY "|"//- nDifColCC PSAY "|"
@ 03,001 PSAY "|"
@ 03,131 PSAY "|"
@ 04,001 PSAY "|"
@ 04,003 PSAY SM0->M0_NOMECOM
@ 04,045 PSAY "|"+Replicate("-",95 - nDifColCC)
@ 04,142 - nDifColCC PSAY "|"
@ 05,001 PSAY "|"
@ 05,003 PSAY SM0->M0_ENDENT
dbSelectArea("SA2")
dbSetOrder(1)
dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
@ 05,045 PSAY "|"
If ( cPaisLoc$"ARG|POR|EUA" )
	@ 05,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+"-"+SA2->A2_LOJA	
Else
	@ 05,047 PSAY Substr(SA2->A2_NOME,1,35)+"-"+SA2->A2_COD+"-"+SA2->A2_LOJA+(STR0036)+" " + SA2->A2_INSCR		//" I.E.: "	
EndIf
@ 05,142 - nDifColCC PSAY "|"
@ 06,001 PSAY "|"
@ 06,003 PSAY (STR0009)+Trans(SM0->M0_CEPENT,cCepPict)+" - "+Trim(SM0->M0_CIDENT)+" - "+SM0->M0_ESTENT		//"CEP :"
@ 06,045 PSAY "|"
@ 06,047 PSAY SA2->A2_END    		Picture PesqPict("SA2","A2_END")
@ 06,089 PSAY "-  "+Trim(SA2->A2_BAIRRO)	Picture "@!"
@ 06,142 - nDifColCC PSAY "|"
@ 07,001 PSAY "|"
@ 07,003 PSAY STR0037+SM0->M0_TEL		//"TEL: "
@ 07,023 PSAY STR0038+SM0->M0_FAX		//"FAX: "
@ 07,045 PSAY "|"
@ 07,047 PSAY Trim(SA2->A2_MUN)  Picture "@!"
@ 07,069 PSAY SA2->A2_EST    		Picture PesqPict("SA2","A2_EST")
@ 07,074 PSAY STR0009	//"CEP :"
@ 07,081 PSAY SA2->A2_CEP    		Picture PesqPict("SA2","A2_CEP")

dbSelectArea("SX3")
nOrden = IndexOrd()
dbSetOrder(2)
dbSeek("A2_CGC")
cCGC := Alltrim(X3TITULO())
@ 07,093 PSAY cCGC //"CGC: "
dbSetOrder(nOrden)

dbSelectArea("SA2")
@ 07,103 PSAY SA2->A2_CGC    		Picture PesqPict("SA2","A2_CGC")
@ 07,142 - nDifColCC PSAY "|"
@ 08,001 PSAY "|"
@ 08,002 PSAY (cCGC) + " "+ Transform(SM0->M0_CGC,cCgcPict)		//"CGC: "
If cPaisLoc == "BRA"
	@ 08,029 PSAY (STR0041)+ InscrEst()		//"IE:"
EndIf
@ 08,045 PSAY "|"
@ 08,047 PSAY SC7->C7_CONTATO Picture PesqPict("SC7","C7_CONTATO")
@ 08,069 PSAY STR0042	//"FONE: "
@ 08,075 PSAY "("+Substr(SA2->A2_DDD,1,3)+") "+Substr(SA2->A2_TEL,1,15)
@ 08,100 PSAY (STR0038)	//"FAX: "
@ 08,106 PSAY "("+Substr(SA2->A2_DDD,1,3)+") "+SubStr(SA2->A2_FAX,1,15)
@ 08,142 - nDifColCC PSAY "|"
@ 09,001 PSAY "|"
@ 09,002 PSAY Replicate("-",limite)
@ 09,142 - nDifColCC PSAY "|"

If mv_par08 == 1
	@ 10,001 PSAY "|"
	@ 10,002 PSAY STR0043	//"Itm|"
	@ 10,009 PSAY STR0044	//"Codigo      "
	@ 10,022 PSAY STR0045	//"|Descricao do Material"
	@ 10,049 PSAY STR0046	//"|UM|  Quant."
	If cPaisLoc <> "BRA"
		@ 10,065 PSAY IIF(nDifColcc == 0,STR0056,STR0057)	//"|Valor Unitario|      Valor Total   |Entrega   |  C.C.   | S.C. |"
	Else
		@ 10,065 PSAY IIF(nDifColcc == 0,STR0047,STR0055)	//"|Valor Unitario|IPI% |  Valor Total   | Entrega  |  C.C.   | S.C. |"
	EndIf
	@ 11,001 PSAY "|"
	@ 11,002 PSAY Replicate("-",limite)
	@ 11,142 - nDifColCC PSAY "|"
Else
	@ 10,001 PSAY "|"
	@ 10,002 PSAY STR0043	//"Itm|"
	@ 10,009 PSAY STR0044	//"Codigo      "
	@ 10,022 PSAY STR0045	//"|Descricao do Material"
	@ 10,049 PSAY STR0046	//"|UM|  Quant."
	@ 10,065 PSAY STR0048	//"|Valor Unitario|  Valor Total   |Entrega | Numero da OP  "
	@ 10,142 - nDifColCC PSAY "|"
	@ 11,001 PSAY "|"
	@ 11,002 PSAY Replicate("-",limite)
	@ 11,142 - nDifColCC PSAY "|"
EndIf
dbSelectArea("SC7")
li := 11   

Close(oDlg)

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³R110Center³ Autor ³ Jose Lucas            ³ Data ³          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Centralizar o Nome do Liberador do Pedido.                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpC1 := R110CenteR(ExpC2)                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 := Nome do Liberador                                 ³±±
±±³Parametros³ ExpC2 := Nome do Liberador Centralizado                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MatR110                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R110Center(cLiberador)
Return( Space((30-Len(AllTrim(cLiberador)))/2)+AllTrim(cLiberador) )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Alexandre Lemes     º Data ³ 17/12/2002  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATR110                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Filtra os itens do PC a serem impressos " )
Aadd( aHelpPor, "Todos,somente os abertos ou Atendidos.  " )

Aadd( aHelpEng, "                                        " )
Aadd( aHelpEng, "                                        " )

Aadd( aHelpSpa, "                                        " )
Aadd( aHelpSpa, "                                        " )
 
PutSx1("MTR110","14","Lista quais ?       ","Cuales Lista ?      ","List which ?        ","mv_che","N",1,0,1,"C","","","","","mv_par14",;
"Todos ","Todos ","All ","","Em Aberto ","En abierto ","Open ","Atendidos ","Atendidos ","Serviced ","","","","","","","","","","")
PutSX1Help("P.MTR11014.",aHelpPor,aHelpEng,aHelpSpa)	 

Return

