#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA456R  ºAutor  ³ Marcelo da Cunha   º Data ³  11/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Aviso para representante e supervisor sobre pedido         º±±
±±º          ³ bloqueado na analise do credito.                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA456R()
********************
LOCAL cCodProc 	:= "Pedidos", cMotRej, nTotPed, cPedido, nOpcx
LOCAL cDescProc	:= "Pedidos Bloqueado na Analise de Credito "
LOCAL cHTMLModelo	:= "\workflow\wfblqcred.htm"
LOCAL cSubject		:= "WORKFLOW:Pedido "+SC9->C9_pedido+" Bloqueado Credito | "+dtoc(MsDate())+" às "+Substr(Time(),1,5)
LOCAL cFromName	:= "Workflow - BRASCOLA"
LOCAL cPntEnt     := iif(paramixb!=Nil,paramixb[1],"")
LOCAL cRotina     := Upper(Alltrim(Funname()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifico orgem chamada    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (cPntEnt == "MTA450R").and.(cRotina == "MATA450A")
	Return
Endif
If (cPntEnt == "MTA450RP")
	nOpcx := paramixb[2]
	cPedido := paramixb[3]
	If (nOpcx == 3) //Rejeitar

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria Processo de Workflow ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess	:= TWFProcess():New(cCodProc,cDescProc)
		oProcess:NewTask(cDescProc,cHTMLModelo)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifico pedido bloqueado ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ           
		nTotPed := 0		
		SA1->(dbSetOrder(1)) ; SA3->(dbSetOrder(1)) 
		SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
		SC5->(dbSeek(xFilial("SC5")+cPedido,.T.)) 
		cEmail1 := "" ; cEmail2 := ""
		If SA3->(dbSeek(xFilial("SA3")+SC5->C5_vend1))
			cEmail1 := Alltrim(SA3->A3_email)
			aRespon := {SA3->A3_super,SA3->A3_geren}
			If Empty(cEmail2).and.!Empty(aRespon[1]).and.SA3->(dbSeek(xFilial("SA3")+aRespon[1]))
				cEmail2 := Alltrim(SA3->A3_email) //Supervisor
			Endif
			If Empty(cEmail2).and.!Empty(aRespon[2]).and.SA3->(dbSeek(xFilial("SA3")+aRespon[2]))
				cEmail2 := Alltrim(SA3->A3_email) //Gerente
			Endif
		Endif		
		SA1->(dbSeek(xFilial("SA1")+SC5->C5_cliente+SC5->C5_lojacli,.T.))
		SC6->(dbSeek(xFilial("SC6")+cPedido,.T.))
		While !SC6->(Eof()).and.(xFilial("SC6") == SC6->C6_filial).and.(SC6->C6_num == cPedido)
			nTotPed += SC6->C6_valor
			SC6->(dbSkip())
		Enddo
		cMotRej := ""
		cQuery := "SELECT C9_MOTREJ FROM "+RetSqlName("SC9")+" C9 "
		cQuery += "WHERE C9.D_E_L_E_T_ = '' AND C9.C9_FILIAL = '"+xFilial("SC9")+"' "
		cQuery += "AND C9.C9_PEDIDO = '"+cPedido+"' AND C9.C9_MOTREJ <> '' "
		cQuery := ChangeQuery(cQuery)
		If (Select("MSC9") <> 0)
			dbSelectArea("MSC9")
			dbCloseArea()
		Endif
		TCQuery cQuery NEW ALIAS "MSC9"
		dbSelectArea("MSC9")
		While !MSC9->(Eof())
			If !(Alltrim(MSC9->C9_motrej) $ cMotRej)
				cMotRej += Alltrim(MSC9->C9_motrej)+"/"
			Endif
			MSC9->(dbSkip())
		Enddo		
		cMotRej := Left(cMotRej,Len(cMotRej)-1)
		oProcess:oHtml:ValByName("motivo",cMotRej)
		AAdd( oProcess:oHtml:ValByName("Item.ped")  , cPedido )
		AAdd( oProcess:oHtml:ValByName("Item.cli")  , SA1->A1_cod+"/"+SA1->A1_loja )
		AAdd( oProcess:oHtml:ValByName("Item.desc") , SA1->A1_nome )
		AAdd( oProcess:oHtml:ValByName("Item.est")  , SA1->A1_est  )
		AAdd( oProcess:oHtml:ValByName("Item.val")  , Transform(nTotPed,PesqPict("SC6","C6_VALOR")) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Finaliza Processo Workflow³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oProcess:ClientName(cUserName)
		//oProcess:cTo := "marcelo@goldenview.com.br"
		cEmail1 := u_BXFormatEmail(cEmail1)
		oProcess:cTo := cEmail1
		cEmail2 := u_BXFormatEmail(cEmail2)
		If !Empty(cEmail2)
			oProcess:cCC := cEmail2
		Else
			oProcess:cCC := "charlesm@brascola.com.br"
		Endif
		oProcess:cSubject := cSubject
		oProcess:cFromName:= cFromName
		oProcess:Start()
		oProcess:Free()                                                                                
	
	Endif
	
Elseif (SC9->C9_blcred == "09") //Bloqueio Credito

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria Processo de Workflow ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess	:= TWFProcess():New(cCodProc,cDescProc)
	oProcess:NewTask(cDescProc,cHTMLModelo)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifico pedido bloqueado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ           
	SA1->(dbSetOrder(1)) ; SC5->(dbSetOrder(1)) ; SC6->(dbSetOrder(1))
	SC5->(dbSeek(xFilial("SC5")+SC9->C9_pedido,.T.)) 
	cEmail1 := "" ; cEmail2 := ""
	If SA3->(dbSeek(xFilial("SA3")+SC5->C5_vend1))
		cEmail1 := Alltrim(SA3->A3_email)
		aRespon := {SA3->A3_super,SA3->A3_geren}
		If Empty(cEmail2).and.!Empty(aRespon[1]).and.SA3->(dbSeek(xFilial("SA3")+aRespon[1]))
			cEmail2 := Alltrim(SA3->A3_email) //Supervisor
		Endif
		If Empty(cEmail2).and.!Empty(aRespon[2]).and.SA3->(dbSeek(xFilial("SA3")+aRespon[2]))
			cEmail2 := Alltrim(SA3->A3_email) //Gerente
		Endif
	Endif		
	SA1->(dbSeek(xFilial("SA1")+SC9->C9_cliente+SC9->C9_loja,.T.))
	oProcess:oHtml:ValByName("motivo",SC9->C9_motrej)
	AAdd( oProcess:oHtml:ValByName("Item.ped")  , SC9->C9_pedido+"/"+SC9->C9_item )      
	AAdd( oProcess:oHtml:ValByName("Item.cli")  , SA1->A1_cod+"/"+SA1->A1_loja )
	AAdd( oProcess:oHtml:ValByName("Item.desc") , SA1->A1_nome   )
	AAdd( oProcess:oHtml:ValByName("Item.est")  , SA1->A1_est    )
	AAdd( oProcess:oHtml:ValByName("Item.val")  , Transform(SC9->C9_qtdlib*SC9->C9_prcven,PesqPict("SC6","C6_VALOR"))  )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza Processo Workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:ClientName(cUserName)
	//oProcess:cTo := "marcelo@goldenview.com.br"
	cEmail1 := u_BXFormatEmail(cEmail1)
	oProcess:cTo := cEmail1
	cEmail2 := u_BXFormatEmail(cEmail2)
	If !Empty(cEmail2)
		oProcess:cCC := cEmail2
	Else
		oProcess:cCC := "charlesm@brascola.com.br"
	Endif
	oProcess:cSubject := cSubject
	oProcess:cFromName:= cFromName
	oProcess:Start()
	oProcess:Free()                                                                                
	
Endif
If (Select("MSC9") <> 0)
	dbSelectArea("MSC9")
	dbCloseArea()
Endif

	
Return