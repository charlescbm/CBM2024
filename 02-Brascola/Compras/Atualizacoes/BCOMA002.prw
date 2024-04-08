#include "rwmake.ch"
#include "topconn.ch"
#include "colors.ch"
#include "font.ch"
#include "tbiconn.ch"
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BCOMA002 ºAutor  ³ Marcelo da Cunha   º Data ³  13/09/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para liberacao dos pedidos de compra pelo CC      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function BCOMA002()
*********************
PRIVATE cMarca, cFiltroSC7, aIndexSC7 := {}, nTipoPed := 1
PRIVATE l120Auto := .F., lInverte := .F., lSeleciona:= .F.
PRIVATE c002Custo := Space(9), c002CodUsr := RetCodUsr()
PRIVATE cCadastro:= "Liberacao Gestores", bFilSC7Brw := Nil
PRIVATE aRotina  := {{"Pesquisar"  ,"AxPesqui"       ,0,1},;
                     {"Parametros" ,"u_BCA002Param"  ,0,3},;
                     {"Analisar"   ,"u_BCA002Libera" ,0,4},;
                     {"Legenda"    ,"u_BCA002Legend" ,0,2}}
PRIVATE aFixe    := {{"Numero do PC","C7_NUM    "   },;
					   	{"Data Emissao","C7_EMISSAO"   },;
					   	{"Conta"       ,"C7_CONTA"     },;
					   	{"CC"          ,"C7_CC"        },;
							{"Fornecedor  ","C7_FORNECE"   }}
PRIVATE aCores   := {{'C7_CCLIBER$"L "','ENABLE'    },;
							{'C7_CCLIBER=="B"','BR_CINZA'  },;
							{'C7_CCLIBER=="X"','BR_AZUL'   },;
							{'C7_CCLIBER=="M"','BR_AMARELO'},;
							{'C7_CCLIBER=="O"','DISABLE'   }}

//Verifico se o gestor possui acesso a rotina
/////////////////////////////////////////////
Processa({|| c002Custo := u_BCA002Gestor(1) })
If Empty(c002Custo)
	Help("",1,"BRASCOLA",,OemToAnsi("Voce nao possui nenhum Centro de Custo para aprovacao!"),1,0) 
	Return
Endif

//Posiciono no arquivo correto
//////////////////////////////
dbSelectArea("SC7")
dbSetOrder(1)
                    
//Solcito os paramentros da rotina
//////////////////////////////////
u_BCA002Param()

//Aplico filtro e mostro o browse
/////////////////////////////////
dbSelectArea("SC7")
mBrowse(6,1,22,75,"SC7",aFixe,,,,,aCores)
EndFilBrw("SC7",aIndexSC7)

Return   

User Function BCA002Param(cAlias,nReg,nOpcx)
****************************************
LOCAL cPerg := "BCOMA002", aRegs := {}
LOCAL cGesMaster := SuperGetMV("BR_CCGESTO",,"")
    
//Crio o grupo de perguntas
///////////////////////////
aadd(aRegs,{cPerg,"01","Data Emissao De   ?","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"02","Data Emissao Ate  ?","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"03","Fornecedor De     ?","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","FOR"})
aadd(aRegs,{cPerg,"04","Fornecedor Ate    ?","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","FOR"})
aadd(aRegs,{cPerg,"05","Loja De           ?","mv_ch5","C",02,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"06","Loja Ate          ?","mv_ch6","C",02,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"07","Produto De        ?","mv_ch7","C",15,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","SB1"})
aadd(aRegs,{cPerg,"08","Produto Ate       ?","mv_ch8","C",15,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","SB1"})
aadd(aRegs,{cPerg,"09","Mostrar Pedidos   ?","mv_ch9","N",01,0,0,"C","","MV_PAR09","Todos","","","Apenas meu CC","","","","","","","","","","",""})
aadd(aRegs,{cPerg,"10","Centro Custo De   ?","mv_chA","C",09,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","CTT"})
aadd(aRegs,{cPerg,"11","Centro Custo Ate  ?","mv_chB","C",09,0,0,"G","","MV_PAR11","","","","","","","","","","","","","","","CTT"})
u_BXCriaPer(cPerg,aRegs)
If (nOpcx!=Nil)
	If !Pergunte(cPerg,.T.)
		Return .F.
	Endif
Else
	Pergunte(cPerg,.F.)
Endif
      
//Monto filtro arquivo de pedidos de compra
///////////////////////////////////////////
cFiltroSC7 := "(C7_CONAPRO=='B').AND.!EMPTY(C7_CCLIBER)"
If (c002CodUsr $ cGesMaster) //Gestor Master
	If (mv_par09 == 1) //Todos
		cFiltroSC7 += ".AND.(C7_CCLIBER$'BM')" 
	Elseif (mv_par09 == 2) //Apenas meu CC
		cFiltroSC7 += ".AND.(((C7_CCLIBER=='B').AND.(C7_CC$'"+c002Custo+"')).OR.(C7_CCLIBER=='M'))"
	Endif
Else
	cFiltroSC7 += ".AND.(C7_CCLIBER$'BM').AND.(C7_CC$'"+c002Custo+"')"
Endif
If !Empty(mv_par01)
	cFiltroSC7 += ".AND.(DTOS(C7_EMISSAO)>='"+dtos(mv_par01)+"')"
Endif              
If !Empty(mv_par02)
	cFiltroSC7 += ".AND.(DTOS(C7_EMISSAO)<='"+dtos(mv_par02)+"')"
Endif
If !Empty(mv_par03)
	cFiltroSC7 += ".AND.(C7_FORNECE>='"+mv_par03+"')"
Endif
If !Empty(mv_par04)
	cFiltroSC7 += ".AND.(C7_FORNECE<='"+mv_par04+"')"
Endif
If !Empty(mv_par05)
	cFiltroSC7 += ".AND.(C7_LOJA>='"+mv_par05+"')"
Endif
If !Empty(mv_par06)
	cFiltroSC7 += ".AND.(C7_LOJA<='"+mv_par06+"')"
Endif
If !Empty(mv_par07)
	cFiltroSC7 += ".AND.(C7_PRODUTO>='"+mv_par07+"')"
Endif
If !Empty(mv_par08)
	cFiltroSC7 += ".AND.(C7_PRODUTO<='"+mv_par08+"')"
Endif
If !Empty(mv_par10)
	cFiltroSC7 += ".AND.(C7_CC>='"+mv_par10+"')"
Endif
If !Empty(mv_par11)
	cFiltroSC7 += ".AND.(C7_CC<='"+mv_par11+"')"
Endif

//Aplico filtro e mostro o browse
/////////////////////////////////
dbSelectArea("SC7")
bFilSC7Brw := {|| FilBrowse("SC7",@aIndexSC7,@cFiltroSC7) }
Eval(bFilSC7Brw)

Return .T.

User Function BCA002Libera(cAlias,nReg,nOpcx)
*****************************************
LOCAL cPedido := Space(6), cTexto := "", aLimite := {}
LOCAL aAprov := {}, lAlcada := .F., lAchei := .F., nValLib
LOCAL lPCOINTE := (SuperGetMV("MV_PCOINTE",.F.,"2")=="1")

PRIVATE oDlgM := Nil, oFont1 := Nil, oFont2 := Nil
PRIVATE cJustif := "", lTemOrc := .T., lLibera := .T., nOpca := 0

DEFINE FONT oFont1 NAME 'ARIAL' SIZE 12,15 BOLD
DEFINE FONT oFont2 NAME 'ARIAL' SIZE 9,12

//Chamo rotina para validar orcamento
/////////////////////////////////////
cPedido := SC7->C7_num
aValOrc := BCA002ValOrc()
lTemOrc := aValOrc[1]
lLibera := (SC7->C7_ccliber$" LO")
If (lLibera)                                   
	dbselectarea("SYP")
	cJustif := MSMM(SC7->C7_ccjusti)
Else
	SZ5->(dbSetOrder(2)) //Usuario+CC
	If !SZ5->(dbSeek(xFilial("SZ5")+c002CodUsr+SC7->C7_cc))
		Help("",1,"BRASCOLA",,OemToAnsi("Voce nao possui nenhum Centro de Custo para aprovacao!"),1,0) 
		Return
	Endif
Endif         

//Busco limites diario e mensal 
///////////////////////////////
//aLimite := u_BCA002BLimite(c002CodUsr,SC7->C7_cc,MsDate())
//If (aLimite[1] < SC7->C7_total)
//	Help("",1,"BRASCOLA",,OemToAnsi("Voce nao possui limite DIARIO para aprovacao deste pedido!"),1,0) 
//	Return
//Elseif (aLimite[2] < SC7->C7_total)
//	Help("",1,"BRASCOLA",,OemToAnsi("Voce nao possui limite MENSAL para aprovacao deste pedido!"),1,0) 
//	Return
//Endif

//Posiciono nas tabelas corretas
////////////////////////////////
SA2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SC7->C7_fornece+SC7->C7_loja,.T.))
SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+SC7->C7_produto,.T.))
CTT->(dbSetOrder(1))
CTT->(dbSeek(xFilial("CTT")+SC7->C7_cc,.T.))
CT1->(dbSetOrder(1))
CT1->(dbSeek(xFilial("CT1")+SC7->C7_conta,.T.))
                                      
//Mostro tela e verifico se Gestor deseja confirmar
///////////////////////////////////////////////////
dbselectarea("SC7")
DEFINE MSDIALOG oDlgM FROM 000,000 TO 375,600 TITLE OemToAnsi(cCadastro+iif(lLibera," - Ja Liberado","")) Of oMainWnd PIXEL
If !Empty(SC7->C7_ccgesto)
	@ 009,010 SAY "GESTOR: "+Alltrim(SC7->C7_ccgesto)+" - "+UsrFullName(SC7->C7_ccgesto) SIZE 300,10 COLOR CLR_BLUE OBJECT oSay1
Elseif (!lLibera)
	@ 009,010 SAY "GESTOR: "+Alltrim(c002CodUsr)+" - "+UsrFullName(c002CodUsr) SIZE 300,10 COLOR CLR_BLUE OBJECT oSay1
Endif             
@ 024,010 SAY "CONTA: "+Alltrim(SC7->C7_conta)+" - "+Alltrim(CT1->CT1_desc01) COLOR CLR_BLUE OBJECT oSay2
@ 033,010 SAY "CC: "+Alltrim(SC7->C7_cc)+" - "+Alltrim(CTT->CTT_desc01) COLOR CLR_BLUE OBJECT oSay3
@ 042,010 SAY "ORÇADO: "+Alltrim(Transform(aValOrc[4],PesqPict("SC7","C7_TOTAL"))) COLOR CLR_BLUE OBJECT oSayP
@ 042,100 SAY "REALIZADO: "+Alltrim(Transform(aValOrc[5],PesqPict("SC7","C7_TOTAL"))) COLOR CLR_BLUE OBJECT oSayR
@ 042,190 SAY "SOLICITADO: "+Alltrim(Transform(aValOrc[6],PesqPict("SC7","C7_TOTAL"))) COLOR CLR_BLUE OBJECT oSayS 
@ 057,010 SAY "Pedido: "+SC7->C7_num SIZE 60,10 COLOR CLR_GREEN 
@ 057,060 SAY "Item: "+SC7->C7_item SIZE 60,10 COLOR CLR_GREEN
@ 057,097 SAY "Data Entrega: "+dtoc(SC7->C7_datprf) SIZE 60,10 COLOR CLR_GREEN 
@ 067,010 SAY "Fornecedor: "+Alltrim(SC7->C7_fornece)+"/"+Alltrim(SC7->C7_loja)+" - "+Alltrim(SA2->A2_nome) SIZE 280,10 COLOR CLR_GREEN 
@ 077,010 SAY "Produto: "+Alltrim(SC7->C7_produto)+" - "+Alltrim(SB1->B1_desc) SIZE 280,10 COLOR CLR_GREEN 
@ 087,010 SAY "Quantidade: "+Alltrim(Transform(SC7->C7_quant,PesqPict("SC7","C7_QUANT"))) SIZE 90,10 COLOR CLR_GREEN 
@ 087,100 SAY "Preço Unitário: "+Alltrim(Transform(SC7->C7_preco,PesqPict("SC7","C7_PRECO"))) SIZE 90,10 COLOR CLR_GREEN 
@ 087,190 SAY "Valor Total: "+Alltrim(Transform(SC7->C7_total,PesqPict("SC7","C7_TOTAL"))) SIZE 90,10 COLOR CLR_GREEN 
@ 103,010 SAY "Justificativa: " SIZE 40,10 COLOR CLR_BLUE
@ 113,010 GET cJustif MEMO SIZE 280,040 WHEN (!lLibera)
If (!lLibera)
	@ 161,010 BUTTON OemToAnsi("&Liberar")  SIZE 50,10 ACTION iif(BCA002ValLib(1),(nOpca:=1,Close(oDlgM)),)
	@ 161,060 BUTTON OemToAnsi("&Bloquear") SIZE 50,10 ACTION iif(BCA002ValLib(2),(nOpca:=2,Close(oDlgM)),)
Else
	@ 161,010 BUTTON OemToAnsi("&OK") SIZE 50,10 ACTION Close(oDlgM)
Endif
@ 161,130 BUTTON OemToAnsi("&Solicitacao")   SIZE 50,10 ACTION BCA002VSC()
@ 161,180 BUTTON OemToAnsi("&Pedido Compra") SIZE 50,10 ACTION BCA002VPC()
@ 161,230 BUTTON OemToAnsi("&OS Manutencao") SIZE 50,10 ACTION BCA002VOS()
@ 171,130 BUTTON OemToAnsi("&Mot.Bloqueio")  SIZE 50,10 ACTION BCA002VBL()
@ 171,180 BUTTON OemToAnsi("&Obs.Adicional") SIZE 50,10 ACTION BCA002VAP()
@ 171,230 BUTTON OemToAnsi("&Fechar")   SIZE 50,10 ACTION Close(oDlgM)
oSay1:oFont := oFont1 ; oSay2:oFont := oFont2 ; oSay3:oFont := oFont2
oSayP:oFont := oFont2 ; oSayR:oFont := oFont2 ; oSayS:oFont := oFont2
ACTIVATE MSDIALOG oDlgM CENTERED

//Liberacao/Bloqueio pedido
///////////////////////////
If (!lLibera)
	
	If (nOpca == 1) //Liberar

		//Libero item selecionado
		///////////////////////// 
		dbSelectArea("SC7")
		Reclock("SC7",.F.)
		SC7->C7_ccgesto := c002CodUsr
		SC7->C7_ccdtlib := MsDate()
		SC7->C7_cchrlib := Time()
		SC7->C7_ccliber := iif(lTemOrc,"L","O") //L=Liberado ou O=Lib.sem Orcamento
		MsUnlock("SC7") 
		nValLib := SC7->C7_total
		cJustif := Alltrim(cJustif)
		If !Empty(SC7->C7_ccjusti)
			MSMM(SC7->C7_ccjusti,80,,cJustif,4,,,"SC7","C7_CCJUSTI")
		Else
			MSMM(,80,,cJustif,1,,,"SC7","C7_CCJUSTI")
		Endif
		cEmail := ""
		SY1->(dbSetOrder(3))
		If SY1->(dbSeek(xFilial("SY1")+SC7->C7_user)).and.(SC7->C7_user!="000000")
			cEmail := Alltrim(SY1->Y1_email)
		Endif

		//Efetivo saldo EM=Empenhado
		///////////////////////// //
		If (lPCOINTE)
			PcoIniLan("000055")
			PcoDetLan("000055","90","MATA097")
			PcoFinLan("000055")
		Endif
	
		//Removo filtro para analisar pedido
		////////////////////////////////////
		dbSelectArea("SC7")
		RetIndex("SC7")
		dbClearFilter()

		//Verifico se posso liberar alcada
		//////////////////////////////////
		lAlcada := .T.
		SC7->(dbSetOrder(1))
		SC7->(dbSeek(xFilial("SC7")+cPedido,.T.))
		While !SC7->(Eof()).and.(xFilial("SC7") == SC7->C7_filial).and.(SC7->C7_num == cPedido)
			If (SC7->C7_ccliber $ "BMX") 
				lAlcada := .F.
				Exit
			Endif
			SC7->(dbSkip())
		Enddo     
		If (lAlcada)
			lAchei := .F.
			aAprov := {}
			SCR->(dbSetOrder(1))
			SCR->(dbSeek(xFilial("SCR")+"PC"+Alltrim(cPedido),.T.))
			While !SCR->(Eof()).and.(xFilial("SCR") == SCR->CR_filial).and.(Alltrim(SCR->CR_num) == Alltrim(cPedido))
				lAchei := .T.
				If (SCR->CR_nivel == "01").and.(SCR->CR_status == "02").and.(SCR->CR_user!="000000")
					aadd(aAprov,SCR->CR_user)
				Endif
				RecLock("SCR",.F.)
				SCR->CR_ccliber := iif(lTemOrc,"L","O") //L=Liberado ou O=Lib.sem Orcamento
				MsUnlock("SCR")
				SCR->(dbSkip())
			Enddo
			If (!lAchei)
				SC7->(dbSetOrder(1))
				SC7->(dbSeek(xFilial("SC7")+cPedido,.T.))
				While !SC7->(Eof()).and.(xFilial("SC7") == SC7->C7_filial).and.(SC7->C7_num == cPedido)
					Reclock("SC7",.F.)
					SC7->C7_conapro := "L"
					MsUnlock("SC7")
					SC7->(dbSkip())
				Enddo
			Endif
			If (Len(aAprov) > 0)
				BCA002Alcada(@aAprov,cPedido)
			Endif
			If Empty(cEmail)
				cEmail := "charlesm@brascola.com.br"
			Endif
			cTitulo := "Aviso Pedido Compra para Liberacao: "+cPedido
			cTexto  := "O pedido "+cPedido+" está disponivel para compra."
			u_GDVWFAviso("PEDLIB","100001",cTitulo,cTexto,cEmail)
		Endif

		//Remonto filtro
		////////////////
		dbSelectArea("SC7")
		dbSetOrder(1)
		bFilSC7Brw := {|| FilBrowse("SC7",@aIndexSC7,@cFiltroSC7) }
		Eval(bFilSC7Brw)
		oObjBrw := GetObjBrow()
		oObjBrw:Refresh()

	Elseif (nOpca == 2) //Bloqueio
	                              
		//Gravo justificativa para bloqueio
		///////////////////////////////////
		dbSelectArea("SC7")
		Reclock("SC7",.F.)
		SC7->C7_conapro := "B" 
		SC7->C7_ccliber := "X" //X=Bloqueado pelo Gestor
		MsUnlock("SC7")
		cJustif := Alltrim(cJustif)
		cTexto  := "USUARIO:"+Alltrim(cUserName)+Space(5)+"DATA:"+dtoc(MsDate())+Space(5)+"HORA:"+Time()
		cTexto  += chr(13)+chr(10)
		cTexto  += cJustif
		cTexto  += chr(13)+chr(10)+chr(13)+chr(10)
		cTexto  += MSMM(SC7->C7_ccobsbl)
		If !Empty(SC7->C7_ccobsbl)
			MSMM(SC7->C7_ccobsbl,80,,cTexto,4,,,"SC7","C7_CCOBSBL")	
		Else
			MSMM(,80,,cTexto,1,,,"SC7","C7_CCOBSBL")	
		Endif
	          
		//Envio email para responsavel
		// de compras e solicitante
		//////////////////////////////
		BCA002Bloq(@cJustif)

		//Remonto filtro
		////////////////
		dbSelectArea("SC7")
		dbSetOrder(1)
		bFilSC7Brw := {|| FilBrowse("SC7",@aIndexSC7,@cFiltroSC7) }
		Eval(bFilSC7Brw)
		oObjBrw := GetObjBrow()
		oObjBrw:Refresh()
	
	Endif

Endif

//Seleciono alias do Browse
///////////////////////////
dbSelectArea("SC7")

Return

User Function BCA002Gestor(xTipo)
******************************
c002Custo := ""
Procregua(SZ5->(Reccount()))
SZ5->(dbSetOrder(2)) //Codigo Usuario
SZ5->(dbSeek(xFilial("SZ5")+c002CodUsr,.T.))
While !SZ5->(Eof()).and.(xFilial("SZ5") == SZ5->Z5_filial).and.(SZ5->Z5_codusu == c002CodUsr)
	Incproc("> Centro Custo: "+SZ5->Z5_custo)
	If !(Alltrim(SZ5->Z5_custo) $ c002Custo)
		If (xTipo == 1)
			c002Custo += SZ5->Z5_custo+"/"
		Else
			c002Custo += "'"+Alltrim(SZ5->Z5_custo)+"',"
		Endif
	Endif
	SZ5->(dbSkip())
Enddo
If !Empty(c002Custo)
	c002Custo := Substr(c002Custo,1,Len(c002Custo)-1)
Endif
Return c002Custo

Static Function BCA002ValLib(xTipo)
*******************************
LOCAL lRetu := .T.             
If (xTipo == 1)
	If (!lTemOrc).and.Empty(cJustif)
		Help("",1,"BRASCOLA",,OemToAnsi("Pedido sem Orcamento! Favor informar a Justificativa."),1,0) 
		lRetu := .F.
	Endif
Elseif (xTipo == 2)
	If Empty(cJustif)
		Help("",1,"BRASCOLA",,OemToAnsi("Favor informar a Justificativa para o bloqueio."),1,0) 
		lRetu := .F. 
	Elseif !MsgYesNo("> Confirma o Bloqueio deste Pedido?","ATENCAO")
		lRetu := .F. 
	Endif
Endif
Return lRetu

Static Function BCA002Alcada(xAprov,xPedido)
****************************************
LOCAL cTitulo := "", cTexto := "", cNome := "", cEmail := "", _x

//Envio email para os aprovadores
/////////////////////////////////
For _x := 1 to Len(xAprov)

	//Busco o email solicitante
	///////////////////////////
	PswOrder(1)
	If PswSeek(xAprov[_x],.T.)
		cNome  := Alltrim(PswRet(1)[1,2])
		cEmail := Alltrim(PswRet(1)[1,14])
	Endif

	//Variaveis utilizadas pelo Aviso
	/////////////////////////////////
	cTitulo := "Aviso Pedido Compra para Liberacao Alcada: "+xPedido
	cTexto  := Alltrim(cNome)+", o pedido de compra "+xPedido+" está disponivel para sua analise no nível de alçada."
	u_GDVWFAviso("PEDCOM","100001",cTitulo,cTexto,cEmail)

Next _x

Return .T.

Static Function BCA002Bloq(xJustif)
********************************
LOCAL cTitulo := "", cTexto := "", cEmail := "", cSolicit := ""

//Busco o email solicitante
///////////////////////////
If !Empty(SC7->C7_numsc).and.!Empty(SC7->C7_itemsc)
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(xFilial("SC1")+SC7->C7_numsc+SC7->C7_itemsc))
		PswOrder(2)
		If PswSeek(SC1->C1_solicit,.T.)             
			cSolicit := Alltrim(PswRet(1)[1,14])
		Endif
	Endif
Endif

//Email destino
///////////////
cEmail := "marcelo@goldenview.com.br"
SY1->(dbSetOrder(3))
If SY1->(dbSeek(xFilial("SY1")+SC7->C7_user)).and.(SC7->C7_user!="000000")
	cEmail := Alltrim(SY1->Y1_email)
Endif
If !Empty(cSolicit)
	cEmail += ";"+cSolicit
Endif

//Variaveis utilizadas pelo Aviso
/////////////////////////////////
cTitulo := "Aviso de Pedido de Compras: "+SC7->C7_num
cTexto  := "Atenção! O pedido de compra para o produto "+Alltrim(SB1->B1_cod)+" - "+Alltrim(SB1->B1_desc)
cTexto  += " de "+Alltrim(Transform(SC7->C7_quant,PesqPict("SC7","C7_QUANT")))+" "+SC7->C7_um+" ao preço de "
cTexto  += Alltrim(Transform(SC7->C7_total,PesqPict("SC7","C7_TOTAL")))+" foi BLOQUEADO."
cTexto  += "<br><br>"
cTexto  += "Motivo: "+xJustif
u_GDVWFAviso("PEDCOM","100001",cTitulo,cTexto,cEmail)

Return .T.
      
Static Function BCA002VBL()
************************
LOCAL oDlg1 := Nil, oMemo1 := Nil, nOpca1 := 0
LOCAL cObsBlo := "", cAux := "", cRotina := ""
                                   
//Valido informacoes do item
////////////////////////////
If !Empty(SC7->C7_ccobsbl)
	dbSelectArea("SYP")
	cObsBlo := MSMM(SC7->C7_ccobsbl)
Endif
cRotina := Alltrim(Funname())
cAux := Alltrim(SC7->C7_produto)+" - "+Alltrim(SC7->C7_descri)
DEFINE MSDIALOG oDlg1 FROM 000,000 TO 320,600 TITLE OemToAnsi("Motivo Bloqueio - "+cAux) Of oMainWnd PIXEL
@ 008,010 SAY "Motivo Bloqueio: " SIZE 60,10 COLOR CLR_BLUE
@ 018,010 GET cObsBlo MEMO SIZE 280,110 OBJECT oMemo1 
oMemo1:lReadOnly := .T.
@ 140,010 BUTTON OemToAnsi("&Fechar")   SIZE 60,10 ACTION (nOpca1:=2,Close(oDlg1))
ACTIVATE MSDIALOG oDlg1 CENTERED

Return

Static Function BCA002VAP()
************************
LOCAL oDlg1 := Nil, oMemo1 := Nil, nOpca1 := 0
LOCAL cObsApr := "", cAux := "", cRotina := ""
                                   
//Valido informacoes do item
////////////////////////////
If !Empty(SC7->C7_ccobsap)
	dbSelectArea("SYP")
	cObsApr := MSMM(SC7->C7_ccobsap)
Endif
cRotina := Alltrim(Funname())
cAux := Alltrim(SC7->C7_produto)+" - "+Alltrim(SC7->C7_descri)
DEFINE MSDIALOG oDlg1 FROM 000,000 TO 320,600 TITLE OemToAnsi("Observacao Adicional - "+cAux) Of oMainWnd PIXEL
@ 008,010 SAY "Observacao Adicional: " SIZE 60,10 COLOR CLR_BLUE
@ 018,010 GET cObsApr MEMO SIZE 280,110 OBJECT oMemo1 
oMemo1:lReadOnly := .T.
@ 140,010 BUTTON OemToAnsi("&Fechar")   SIZE 60,10 ACTION (nOpca1:=2,Close(oDlg1))
ACTIVATE MSDIALOG oDlg1 CENTERED

Return

Static Function BCA002VPC()
************************
MATA120(NIL,NIL,NIL,2)
If (!lLibera)
	dbSelectArea("SC7")
	bFilSC7Brw := {|| FilBrowse("SC7",@aIndexSC7,@cFiltroSC7) }
	Eval(bFilSC7Brw)
Endif
Return

Static Function BCA002VSC()
************************
If !Empty(SC7->C7_numsc).and.!Empty(SC7->C7_itemsc)
	LCOPIA := .F. ; LVLDHEAD := .F.
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(xFilial("SC1")+SC7->C7_numsc+SC7->C7_itemsc))
		A110Visual("SC1",Recno("SC1"),2)
	Endif
Else
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido sem Solicitacao de Compras!"),1,0) 
Endif
Return

Static Function BCA002VOS()
************************
LOCAL nSegMod := nModulo
If !Empty(SC7->C7_numsc).and.!Empty(SC7->C7_itemsc)
	SC1->(dbSetOrder(1))
	If SC1->(dbSeek(xFilial("SC1")+SC7->C7_numsc+SC7->C7_itemsc)).and.("OS"$SC1->C1_op)
		STJ->(dbSetOrder(1))
		STJ->(dbSeek(xFilial("STJ")+Substr(SC1->C1_op,1,6),.T.))
		If (STJ->TJ_ordem == Substr(SC1->C1_op,1,6))
			TIPOACOM := {} ; TIPOACOM2 := {} ; LSITUACA := .F. ; nModulo := 19
			AxVisual("STJ",Recno("STJ"),2)                                     
			nModulo := nSegMod 
		Endif
	Else
		Help("",1,"BRASCOLA",,OemToAnsi("Solicitacao nao esta vinculada com OS de manutencao!"),1,0) 
	Endif
Else
	Help("",1,"BRASCOLA",,OemToAnsi("Pedido sem Solicitacao de Compras!"),1,0) 
Endif
Return

User Function BCA002Legend(cAlias,nReg,nOpcx)
*****************************************
BrwLegenda(cCadastro,"Legenda",{{"ENABLE","Liberado"},{"DISABLE","Lib.s/Orcamento"},{"BR_CINZA","Bloqueado"},{"BR_AMARELO","Bloqueado [Atrasado]"},{"BR_AZUL","Bloqueado pelo Gestor"}})
Return

User Function BCA002AvalPC(xPedido)
*******************************
LOCAL nn, lBloqCC := .F., cEmail := "", aCusto := {}, aSeg := GetArea()
SC7->(dbSeek(xFilial("SC7")+xPedido,.T.))
While !SC7->(Eof()).and.(xFilial("SC7") == SC7->C7_filial).and.(SC7->C7_num == xPedido)
	If (Substr(SC7->C7_conta,1,1) $ "45").and.!Empty(SC7->C7_cc)
		RecLock("SC7",.F.)
		SC7->C7_conapro := "B" //Bloqueado
		SC7->C7_ccliber := "B" //Bloqueado CC
		SC7->C7_ccgesto := Space(6)
		SC7->C7_ccdtlib := ctod("//")
		SC7->C7_cchrlib := Space(8)
		MsUnlock("SC7")
		lBloqCC := .T.
		If (aScan(aCusto,SC7->C7_cc) == 0)
			aadd(aCusto,SC7->C7_cc)
		Endif
	Elseif !Empty(SC7->C7_ccliber)
		RecLock("SC7",.F.)
		SC7->C7_ccliber := Space(1)
		SC7->C7_ccgesto := Space(6)
		SC7->C7_ccdtlib := ctod("//")
		SC7->C7_cchrlib := Space(8)
		MsUnlock("SC7")
	Endif
	SC7->(dbSkip())
Enddo  
If (lBloqCC)
	SCR->(dbSeek(xFilial("SCR")+"PC"+Alltrim(xPedido),.T.))
	While !SCR->(Eof()).and.(xFilial("SCR") == SCR->CR_filial).and.(Alltrim(SCR->CR_num) == Alltrim(xPedido))
		RecLock("SCR",.F.)
		SCR->CR_ccliber := "B" //Bloqueado CC
		MsUnlock("SCR")
		SCR->(dbSkip())
	Enddo
	For nn := 1 to Len(aCusto)
		cEmail := u_BCA001Email(aCusto[nn])
		If Empty(cEmail)
			cEmail := "charlesm@brascola.com.br"
		Endif
		cTitulo := "Aviso Pedido Compra para Liberacao: "+xPedido
		cTexto  := "O pedido "+Alltrim(xPedido)+" está disponivel analise do gestor."
		u_GDVWFAviso("PEDAPR","100001",cTitulo,cTexto,cEmail)
	Next nn
Endif
RestArea(aSeg)
Return

User Function BCA002BLimite(xUserID,xCusto,xData)
********************************************
LOCAL aRetu1 := {0,0}, cQuery1 := "", aSeg1 := GetArea()
//Buscar Limites por Usuario/////////
SZ5->(dbSetOrder(2)) //Codigo Usuario
SZ5->(dbSeek(xFilial("SZ5")+xUserID+xCusto,.T.))
While !SZ5->(Eof()).and.(xFilial("SZ5") == SZ5->Z5_filial).and.(SZ5->Z5_codusu+SZ5->Z5_custo == xUserID+xCusto)
	If (SZ5->Z5_msblql != "1") 
		aRetu1[1] += SZ5->Z5_limdia //Limite por Dia
		aRetu1[2] += SZ5->Z5_limmes //Limite por Mensal
	Endif
	SZ5->(dbSkip())
Enddo
//Buscar Utilizacao no Periodo///////
cQuery1 := "SELECT C7_CCDTLIB,SUM(C7_TOTAL) C7_TOTAL FROM "+RetSqlName("SC7")+" C7 "
cQuery1 += "WHERE C7.D_E_L_E_T_ = '' AND C7.C7_FILIAL = '"+xFilial("SC7")+"' "
cQuery1 += "AND C7.C7_CCLIBER IN ('L','O') AND C7.C7_CCGESTO = '"+xUserID+"' AND C7.C7_CC = '"+xCusto+"' "
cQuery1 += "AND C7.C7_CCDTLIB BETWEEN '"+Left(dtos(xData),6)+"' AND '"+Left(dtos(xData),6)+"99' "
cQuery1 += "GROUP BY C7_CCDTLIB ORDER BY C7_CCDTLIB "
cQuery1 := ChangeQuery(cQuery1)
If (Select("MLIM") <> 0)
	dbSelectArea("MLIM")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MLIM"
TCSetField("MLIM","C7_CCDTLIB","D",08,0)
While !MLIM->(Eof())
	If (xData == MLIM->C7_ccdtlib)
		aRetu1[1] -= MLIM->C7_total
	Endif
	aRetu1[2] -= MLIM->C7_total
	MLIM->(dbSkip())
Enddo
If (Select("MLIM") <> 0)
	dbSelectArea("MLIM")
	dbCloseArea()
Endif
RestArea(aSeg1)
/////////////////////////////////////
Return aRetu1

Static Function BCA002ValOrc()
***************************
LOCAL aRetu1 := {.F.,Space(20),Space(9),0,0,SC7->C7_total}
LOCAL cPlanilha:= Space(15), cVersao:= Space(4)
LOCAL cAnoMes := Substr(dtos(SC7->C7_emissao),1,6)
LOCAL cQuery1 := ""
                              
//Busco a planilha orcamentaria ativa
/////////////////////////////////////
AK1->(dbSetOrder(1))
AK1->(dbSeek(xFilial("AK1"),.T.))
While !AK1->(Eof()).and.(xFilial("AK1") == AK1->AK1_filial)
	If (Substr(cAnoMes,1,4) == Substr(dtos(AK1->AK1_iniper),1,4))
		cPlanilha := AK1->AK1_codigo
		cVersao   := AK1->AK1_versao
		Exit
	Endif
	AK1->(dbSkip())
Enddo
If Empty(cPlanilha).and.(SC7->C7_ccliber$"BM")
	MsgStop("> Nao foi encontrada a Planilha orcamentaria para o Periodo informado!!!","ATENCAO")
	Return aRetu1
Endif

//Busco valor previsto
//////////////////////
cQuery1 := "SELECT SUM(AK2.AK2_VALOR) AK2_VALOR "
cQuery1 += "FROM "+RetSqlName("AK2")+" AK2 "
cQuery1 += "WHERE AK2.D_E_L_E_T_ = '' AND AK2.AK2_FILIAL = '"+xFilial("AK2")+"' "
cQuery1 += "AND AK2.AK2_ORCAME = '"+cPlanilha+"' AND AK2.AK2_VERSAO = '"+cVersao+"' "
cQuery1 += "AND AK2.AK2_PERIOD BETWEEN '"+cAnoMes+"' AND '"+cAnoMes+"99' "
cQuery1 += "AND AK2.AK2_CO = '"+SC7->C7_conta+"' AND AK2.AK2_CC = '"+SC7->C7_cc+"' "
If !Empty(SC7->C7_unorc)
	cQuery1 += "AND AK2.AK2_CLASSE = '"+SC7->C7_unorc+"' "
Endif
If !Empty(SC2->C2_operac)
	cQuery1 += "AND AK2.AK2_OPER = '"+SC2->C2_operac+"' "
Endif
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
aRetu1[4] := MAR->AK2_valor

//Busco valor realizado
///////////////////////
cQuery1 := "SELECT SUM(CASE WHEN AKD.AKD_TIPO = '2' THEN AKD.AKD_VALOR1 ELSE AKD.AKD_VALOR1*-1 END) AKD_VALOR1 "
cQuery1 += "FROM "+RetSqlName("AKD")+" AKD "
cQuery1 += "WHERE AKD.D_E_L_E_T_ = '' AND AKD.AKD_FILIAL = '"+xFilial("AKD")+"' "
cQuery1 += "AND AKD.AKD_STATUS = '1' AND AKD.AKD_TPSALD = 'EM' " //Saldo Empenhado
cQuery1 += "AND AKD.AKD_DATA BETWEEN '"+cAnoMes+"' AND '"+cAnoMes+"99' "
cQuery1 += "AND AKD.AKD_CO = '"+SC7->C7_conta+"' AND AKD.AKD_CC = '"+SC7->C7_cc+"' "
If !Empty(SC7->C7_unorc)
	cQuery1 += "AND AKD.AKD_CLASSE = '"+SC7->C7_unorc+"' "
Endif
If !Empty(SC2->C2_operac)
	cQuery1 += "AND AKD.AKD_OPER = '"+SC2->C2_operac+"' "
Endif
cQuery1 := ChangeQuery(cQuery1)
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif
TCQuery cQuery1 NEW ALIAS "MAR"
aRetu1[5] := MAR->AKD_valor1

//Alimento retorno
//////////////////
aRetu1[1] := !Empty(aRetu1[4]).and.(aRetu1[4] >= (aRetu1[5]+aRetu1[6]))
aRetu1[2] := SC7->C7_conta
aRetu1[3] := SC7->C7_cc
            
If (Select("MAR") <> 0)
	dbSelectArea("MAR")
	dbCloseArea()
Endif

Return aRetu1

User Function BCA002ExcPCO(xPedido)
*******************************
LOCAL lPCOINTE := (SuperGetMV("MV_PCOINTE",.F.,"2")=="1"), nx
LOCAL cProcesso := "000055", cItem := "90", aRecAKD := {},cChave := ""
If (lPCOINTE)
	SC7->(dbSeek(xFilial("SC7")+xPedido,.T.))
	While !SC7->(Eof()).and.(xFilial("SC7") == SC7->C7_filial).and.(SC7->C7_num == xPedido)
		If (Substr(SC7->C7_conta,1,1) $ "45").and.!Empty(SC7->C7_cc).and.(SC7->C7_ccliber $ "LO")
			dbSelectArea("AKB")
			dbSetOrder(1)
			MsSeek(xFilial()+cProcesso+cItem)
			dbSelectArea(AKB->AKB_ENTIDA)
			dbSetOrder(AKB->AKB_INDICE)
			cChave := Padr(AKB->AKB_ENTIDA+&(IndexKey()),Len(AKD->AKD_CHAVE))
			If !Empty(cChave)
				dbSelectArea("AKD")
				dbSetOrder(10)
				MsSeek(xFilial()+cChave)
				While !Eof() .And. xFilial()+cChave==AKD_FILIAL+AKD_CHAVE
					aAdd(aRecAKD,AKD->(RecNo()))
					dbSkip()
				Enddo
			EndIf
			For nx := 1 to Len(aRecAKD)
				If aRecAKD[nx] > 0
					dbSelectArea("AKD")
					dbGoto(aRecAKD[nx])
					PcoAtuSld(If(AKD->AKD_TIPO=="1","C","D"),"AKD",{-AKD->AKD_VALOR1,-AKD->AKD_VALOR2,-AKD->AKD_VALOR3,-AKD->AKD_VALOR4,-AKD->AKD_VALOR5},AKD->AKD_DATA)
					RecLock("AKD",.F.,.T.)
					dbDelete()
					MsUnlock()
				EndIf
			Next nx
		Endif
		SC7->(dbSkip())
	Enddo
Endif
Return