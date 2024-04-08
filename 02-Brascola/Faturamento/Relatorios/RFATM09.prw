#INCLUDE "Protheus.ch"                        
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "Font.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RFATM09  ³ Autor ³ Thiago (Onsten)       ³ Data ³ 11/02/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Envia email para supervisores do faturamento diario        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Brascola                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RFATM09()
*********************
LOCAL aAreaAtu	:= GetArea()

RPCSetType(3) //Filial 01 - Joinville
RpcSetEnv("01","01","","","FAT","",{"SA1","SA3","SD2","SF2"})
U_PROCM09A()
RpcClearEnv()
RestArea(aAreaAtu)

Return

User Function RFATM09FR()
***********************
LOCAL aAreaAtu	:= GetArea()

RPCSetType(3) //Filial 03 - Franca
RpcSetEnv("01","03","","","FAT","",{"SA1","SA3","SD2","SF2"})
U_PROCM09A()
RpcClearEnv()
RestArea(aAreaAtu)

Return

User Function PROCM09A()
**********************
LOCAL cQuery := "", cVendAux := "", aDadMail := {}

cQuery:= "SELECT SA3.A3_SUPER, SF2.F2_VEND1, SF2.F2_CLIENTE, SF2.F2_LOJA, SA1.A1_NREDUZ, SF2.F2_DOC, SD2.D2_PEDIDO, SD2.D2_ITEMPV, SD2.D2_COD, SB1.B1_DESC, SD2.D2_TOTAL, SF2.F2_EMISSAO "
cQuery+= " FROM "+RetSQLName("SF2")+" SF2, "+RetSQLName("SD2")+" SD2, "+RetSQLName("SF4")+" SF4, "+RetSQLName("SA1")+" SA1, "+RetSQLName("SB1")+" SB1, "+RetSQLName("SA3")+" SA3 "
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
cQuery+= "   AND F2_VEND1= A3_COD "
cQuery+= "   AND A3_SUPER <> ''   "
cQuery+= " ORDER BY A3_SUPER, F2_VEND1, F2_DOC, D2_PEDIDO, D2_ITEMPV "
If Select("TRAB") > 0 
	TRAB->(dbCloseArea())
EndIf      
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRAB",.T.,.T.)
TRAB->(dbGotop())
cSupervAux := Space(6)
aDadMail := {}
While !TRAB->(Eof())
    aDadMail  := {}	
	cSupervAux:= TRAB->A3_SUPER
	cEmailSup := AllTrim(Posicione("SA3",1,xFilial("SA3")+TRAB->A3_SUPER,"A3_EMAIL"))
	If !Empty(cEmailSup)
		While !TRAB->(Eof()).And.(cSupervAux == TRAB->A3_SUPER)
		   aAdd(aDadMail, {TRAB->F2_VEND1, TRAB->F2_CLIENTE, TRAB->F2_LOJA, TRAB->A1_NREDUZ, TRAB->F2_DOC, TRAB->D2_PEDIDO, TRAB->D2_ITEMPV, TRAB->D2_COD, TRAB->B1_DESC, TRAB->D2_TOTAL, TRAB->F2_EMISSAO} )
			TRAB->(dbSkip())
		EndDo
		EnvMailM09(cSupervAux,SA3->A3_NOME,cEmailSup,aDadMail)
	Else
		dbSelectArea("TRAB") 
		TRAB->(dbSkip())
		Loop
	EndIf
	dbSelectArea("TRAB") 
Enddo

Return(.T.)

Static Function EnvMailM09(cSupeAx,cNomSAx,cEmailAx,aDadosAx)
*******************************************************
LOCAL cCodProc 	:= "AVISUP", oProcess := Nil
LOCAL cDescProc	:= "Faturamento Diario Supervisores"
LOCAL cHTMLModelo	:= "\workflow\wfavisosuper.htm"
LOCAL cSubject    := "WORKFLOW:Aviso Faturamento Diário para Supervisores | "+dtoc(MsDate())+" às "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow -  BRASCOLA"
LOCAL _cBody  := "", cAssunto:= "", cAnexo := ""

If (oProcess != Nil)
	oProcess:Free()
Endif
oProcess	:= TWFProcess():New(cCodProc,cDescProc)
oProcess:NewTask(cDescProc,cHTMLModelo)
oProcess:oHtml:ValByName("Super",Alltrim(cNomSAx))

nTotDiaAx := 0
cRepAux := aDadosAx[1][1]
cBgColor:= "#ffffff" //branco 
nCtColor:= 0

For nI := 1 to Len(aDadosAx)
	If (cRepAux != aDadosAx[nI][1]) //Controle para alternar cor de fundo conforme muda o pedido
		If (nCtColor == 0)
			cBgColor := "#FFFFCC" //Amarelo claro 
			nCtColor++
		Else
			cBgColor := "#FFFFFF" //Branco 
			nCtColor := 0
		EndIf	
		cRepAux := aDadosAx[nI][1]
	EndIf
   AAdd( oProcess:oHtml:ValByName("it.corlin")  , cBgColor )
   AAdd( oProcess:oHtml:ValByName("it.repre")   , aDadosAx[nI][1]+"  "+SubStr(AllTrim(Posicione("SA3",1,xFilial("SA3")+aDadosAx[nI][1],"A3_NOME")),1,20) )
  	AAdd( oProcess:oHtml:ValByName("it.cliente") , aDadosAx[nI][2]+"/"+aDadosAx[nI][3]+"-"+AllTrim(aDadosAx[nI][4]) )
   AAdd( oProcess:oHtml:ValByName("it.nota")    , aDadosAx[nI][5])
  	AAdd( oProcess:oHtml:ValByName("it.pedido")  , aDadosAx[nI][6])
  	AAdd( oProcess:oHtml:ValByName("it.item")    , aDadosAx[nI][7])
  	AAdd( oProcess:oHtml:ValByName("it.produto") , aDadosAx[nI][8])
  	AAdd( oProcess:oHtml:ValByName("it.descri")  , aDadosAx[nI][9])
  	AAdd( oProcess:oHtml:ValByName("it.total")   , Alltrim(Transform(aDadosAx[nI][10],"@E 999,999,999.99")))
  	AAdd( oProcess:oHtml:ValByName("it.emissao") , dtoc(stod(aDadosAx[nI][11])))
	nTotDiaAx += aDadosAx[nI][10]
Next nI

AAdd( oProcess:oHtml:ValByName("it.corlin")  , "#EEEEEE" )
AAdd( oProcess:oHtml:ValByName("it.repre")   , "<b>TOTAL:</b>" )
AAdd( oProcess:oHtml:ValByName("it.cliente") , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.nota")    , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.pedido")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.item")    , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.produto") , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.descri")  , "&nbsp;" )
AAdd( oProcess:oHtml:ValByName("it.total")   , "<b>"+Alltrim(Transform(nTotDiaAx,"@E 999,999,999.99"))+"</b>" )
AAdd( oProcess:oHtml:ValByName("it.emissao") , "&nbsp;" )

cEmailAx := cEmailAx+";gefferson.landarini@brascola.com.br;whay@brascola.com.br"
oProcess:ClientName(cUserName)
cEmailAx := u_BXFormatEmail(cEmailAx)
oProcess:cTo := cEmailAx
//oProcess:cCC := "charlesm@brascola.com.br;marcelo@goldenview.com.br"
oProcess:cSubject := cSubject
oProcess:cFromName:= cFromName
oProcess:Start()
oProcess:Finish()

Return