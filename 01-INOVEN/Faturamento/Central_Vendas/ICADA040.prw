#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICADA040 ºAutor  ³Microsiga           º Data ³ 19/01/11 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro Z05					                              º±±
±±º          ³  		   Status de Pedidos de Vendas                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function ICADA040(cAlias,nReg,nOpc)
Local aAreaSA3		:= SA3->(GetArea())
Local aSize		  	:= MsAdvSize()
Local aObjects	  	:= {}
Local aInfo		  	:= {}
Local aPosObj	  	:= {}
Local nOpca      	:= 0
//Local aTmpCols   	:= {}
Local aButtons   	:= {}
Local nX         	:= 0
//Local nY         	:= 0
Local nI         	:= 0
//Local lRec          := .T.
Local aCpoGDa       := {"Z05_STATUS", "Z05_DESCST", "Z05_DATA", "Z05_HORA", "Z05_NOMUSU"}
Local lVendUsu		:= .F.
//Local nSaveSx8      := GetSx8Len()

Local cLinhaOk     	:= "AllwaysTrue"   // Funcao executada para validar o contexto da linha atual do aCols
Local cTudoOk      	:= "AllwaysTrue"   // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)
Local cIniCpos     	:= ""              	// "+Z9_ITEM"               // Nome dos campos do tipo caracter que utilizarao incremento automatico
Local aAlter       	:= {} 			     // Vetor com os campos que poderao ser alterados
Local nFreeze      	:= 000              // Campos estaticos na GetDados
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99
Local cCampoOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo
Local cSuperApagar 	:= ""               // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>
Local cApagaOk     	:= "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols
Local oWnd
//Local aAux				:= {}
Local 	oButton1
Private oCodPed, oCodCli, oCodLoj, oFont, oNomCli
Private cCodPed		:= Space(TamSx3("C5_NUM")[1])
Private cCodCli		:= Space(TamSx3("C5_CLIENTE")[1])
Private cCodLoj		:= Space(TamSx3("C5_LOJACLI")[1])
Private cNomCli		:= Space(TamSx3("A1_NOME")[1])
Private oGet
Private __aHeader   	:= {}
Private N        	:= 1
Private __aCols    	:= {}
Private aRegs    	:= {}
Private aTela[0][0],aGets[0]
Private lConsultaF3 := .f.
Private cCadastro := "Cadastro Status Pedido"
Private oDlg

oWnd          	:= oDlg        //Objeto para refencia da GetDados

dbSelectArea("SA3")
dbSetOrder(7)
//lVendUsu		:= SA3->(dbSeek(xFilial("SA3")+__cUserID))

// Renato Bandeira em 07/11/16 - LIberado para todos a pedido do Bandeira e do Flavio (P2P)
lVendUsu		:= .T.

DbSelectArea("SX3")
SX3->(DbSetOrder(2)) // Campo
For nX := 1 to Len(aCpoGDa)
	If SX3->(DbSeek(aCpoGDa[nX]))
		Aadd(__aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO	,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID	,;
		SX3->X3_USADO	,;
		SX3->X3_TIPO	,;
		SX3->X3_F3 		,;
		SX3->X3_CONTEXT,;
		SX3->X3_CBOX	,;
		SX3->X3_RELACAO})
	Endif
Next nX

dbSelectArea("Z05")
dbSetOrder(1)

If !IsInCallStack("MATA410") .AND. !IsInCallStack("MATA440")
	DbSelectArea("SC5")
	DbSetORder(1)
	DbSeek(xFilial("SC5") + SC9->C9_PEDIDO)
EndIf
         

If IsInCallStack("U_IVENA020")
	DbSelectArea("SC5")
	DbSetORder(1)
	DbSeek(xFilial("SC5") + Padr(Alltrim(MV_PAR01),TAMSX3("C5_NUM")[1])  )
endif


cCodCli	:= SC5->C5_CLIENTE
cCodLoj	:= SC5->C5_LOJACLI
cCodPed	:= SC5->C5_NUM
cNomCli	:= Posicione("SA1",1,xFilial("SA1")+cCodCli+cCodLoj,"A1_NOME")

DBSELECTAREA("Z05")
DBSETORDER(1)
If dbSeek(xFilial("Z05")+cCodPed)
	
	RegToMemory("Z05",.F.)
	
	//If lVendUsu
	//	aAdd(__aCols,Array(Len(__aHeader) + 1))
	//Endif
	
	SELECT Z05
	While M->Z05_FILIAL+cCodPed == xFilial( "Z05" )+Z05->Z05_PEDIDO
		// Renato Bandeira em 07/11/16 - Mostra todos os Status
		//If !lVendUsu
			aAdd(__aCols,Array(Len(__aHeader) + 1))
		//Endif
		
		N := Len(__aCols)
		For nI := 1 To Len(__aHeader)
			If     __aHeader[nI,10] <> "V" // Real ou Virtual
				__aCols[N,nI] := &(__aHeader[nI,2])
			ElseIf AllTrim(__aHeader[nI,2]) == "Z05_DESCST"
				__aCols[N,nI] := Posicione("Z04",1,xFilial("Z04") + __aCols[N,ASCAn(__aHeader, {|x|, AllTrim(x[2]) == "Z05_STATUS" })],"Z04_DESC")
			EndIf
		Next
		select Z05
		__aCols[N,nI] := .F. // Nao apagado
		Z05->(DbSkip())
	End
Else
	aAdd(__aCols,Array(Len(__aHeader) + 1))
	N := Len(__aCols)
	For nI := 1 To Len(__aHeader)
		If __aHeader[nI,10] <> "V" // Real ou Virtual
			__aCols[N,nI] := &(__aHeader[nI,2])
		ElseIf AllTrim(__aHeader[nI,2]) == "Z05_DESCST"
			__aCols[N][nI] = Space(TamSx3("Z05_DESCST")[1])
		EndIf
	Next
	__aCols[N,nI] := .F. // Nao apagado
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Calcula as dimensoes dos objetos.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aObjects, { 100,070,.T.,.T. } )
aAdd( aObjects, { 100,030,.T.,.T. } )

aInfo    := { aSize[1],aSize[2],aSize[3],aSize[4], 3, 3 }
aPosObj  := MsObjSize( aInfo, aObjects,.T. )

DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] PIXEL
DEFINE FONT oFont NAME "Arial" SIZE 0,-11 BOLD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a Enchoice.                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ C(030),C(005) Say "Numero do Pedido:"	   		Size C(050),C(008) PIXEL OF oDlg
@ C(028),C(050) MsGet oCodPed Var cCodPed 		Size C(025),C(008) FONT oFont PIXEL OF oDlg  WHEN .F.  Picture "@!"
@ C(042),C(005) Say "Numero Cliente/Loja:" 		Size C(050),C(008) PIXEL OF oDlg
@ C(040),C(050) MsGet oCodCli Var cCodCli		Size C(025),C(008) FONT oFont PIXEL OF oDlg WHEN .F.   Picture "@!"
@ C(040),C(075) MsGet oCodLoj Var cCodLoj		Size C(008),C(008) FONT oFont PIXEL OF oDlg WHEN .F.   Picture "@!"
@ C(054),C(005) Say "Nome do Cliente:" 			Size C(050),C(008) PIXEL OF oDlg
@ C(052),C(050) MsGet oNomCli Var cNomCli		Size C(200),C(008) FONT oFont PIXEL OF oDlg WHEN .F.   Picture "@!"

If Alltrim(SC5->C5_XSTATUS)="000004" .OR. Alltrim(SC5->C5_XSTATUS)="000036"	
	//--Somente usuario que não sejam vendedores podem mudar status
	SA3->(dbSetOrder(7))
	If !SA3->(DbSeek(xFilial("SA3") + __CUSERID))
		@ 060, 400 BUTTON oButton1 PROMPT "&Incluir" 	SIZE 038, 015 OF oDlg ACTION Z05_IncReg(SC5->C5_NUM) PIXEL
	Endif		
Else                                                                                                          
	If __cUserID $ GetMV('LI_410LIB',.F.,'000000') .Or. __cUserID == '000000'
		@ 060, 400 BUTTON oButton1 PROMPT "&Incluir" 	SIZE 038, 015 OF oDlg ACTION Z05_IncReg(SC5->C5_NUM) PIXEL
	EndIf
EndIf

oGet:=MsNewGetDados():New(aPosObj[1,1]+49 ,aPosObj[1,2],aPosObj[2,3],aPosObj[2,4], 2;
,cLinhaOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cCampoOk,cSuperApagar,cApagaOk,oWnd,__aHeader,__aCols)

oGet:oBrowse:bLdblClick := {|| AxSTAVis(SC5->C5_NUM,oGet:nAt)}
oGet:oBrowse:lDisablePaint := .F.
oGet:ForceRefresh()

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar( oDlg, {|| nOpcA:= 1, oDlg:End()}, {|| nOpcA := 2, oDlg:End() },, aButtons ),oGet:oBrowse:SetFocus()) CENTER

RestArea(aAreaSA3)
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICADA040 ºAutor  ³Microsiga           º Data ³ 19/01/11 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro Z05					                              º±±
±±º          ³  		   Status de Pedidos de Vendas                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Z05_IncReg(cNUM)
Local aArea			:= GetArea()
Local cAlias2		:= "Z05"
Local nReg
Local nOpc
Local aCampos		:= {}
Local i

DbSelectArea(cAlias2)
DbSetOrder(1)
SX3->(DbSeek(cAlias2))
While !EOF() .And. SX3->X3_ARQUIVO == cAlias2
	If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
		If !(AllTrim(SubStr(SX3->X3_CAMPO,5,6)) $ "FILIAL/PEDIDO/DATA/HORA/NOMUSU/")
			aAdd(aCampos,SX3->X3_CAMPO) // Campos a serem alterados, exceto os campos chave.
			
			&("M->"+SX3->X3_CAMPO) := Space(TamSx3(SX3->X3_CAMPO)[1])
		EndIf
	EndIf
	SX3->(DbSkip())
End

nOpca := AxInclui(cAlias2,nReg,nOpc,aCampos,,,,,,)

If nOpca == 1 // Gravado
	RecLock(cAlias2,.F.)
	&(cAlias2 + "->" + cAlias2 + "_PEDIDO")	:= cNum
	&(cAlias2 + "->" + cAlias2 + "_DATA")	:= dDatabase
	&(cAlias2 + "->" + cAlias2 + "_HORA")	:= Left(Time(),5)
	&(cAlias2 + "->" + cAlias2 + "_NOMUSU")	:= UsrRetName(__cUserID)
	(cAlias2)->(MsUnlock())
	
	Reclock("SC5", .F.)
	SC5->C5_XSTATUS := Z05->Z05_STATUS
	SC5->(MsUnlock())
	
	If empty(oGet:aCols[1][1])
		oGet:aCols := {}
	Endif
	
	aAdd(oGet:aCols,Array(Len(oGet:aHeader) + 1))
	n := Len(oGet:aCols)
	For i := 1 To Len(oGet:aHeader)
		If oGet:aHeader[i,10] <> "V" // Real ou Virtual
			//			oGet:aCols[n,i] := &(oGet:aHeader[i,2])
			oGet:aCols[n,i] := &(cAlias2 + "->" +oGet:aHeader[i,2])
		ElseIf AllTrim(oGet:aHeader[i,2]) == "Z05_DESCST"
			oGet:aCols[n,i] := Posicione("Z04",1,xFilial("Z04") + oGet:aCols[n,ASCAn(oGet:aHeader, {|x|, AllTrim(x[2]) == "Z05_STATUS" })],"Z04_DESC")
		EndIf
	Next
	oGet:aCols[n,i] := .F. // Nao apagado
EndIf

RestArea(aArea)
//oGet:Refresh()

oDlg:End()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AxSTAVis ºAutor  ³Microsiga           º Data ³ 19/01/11 	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro Z05					                              º±±
±±º          ³  		   Status de Pedidos de Vendas                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AxSTAVis(cNUM, N)

//Local aArea			:= GetArea()
Local cAlias2		:= "Z05"
Local nReg
Local nOpc			:= 1
Local aCampos 		:= {}
Local nPosData		:= Ascan(oGet:aHeader, {|x| AllTrim(x[2]) == "Z05_DATA"})
Local nPosHora		:= Ascan(oGet:aHeader, {|x| AllTrim(x[2]) == "Z05_HORA"})
Local nPosStatus	:= Ascan(oGet:aHeader, {|x| AllTrim(x[2]) == "Z05_STATUS"})

If !empty(oGet:aCols[1][1])
	DbSelectArea(cAlias2)
	DbSetOrder(1)
	(cAlias2)->(dbSeek(xFilial(cAlias2)+ cNum+ DTOS(oGet:aCols[N][nPosData])+ oGet:aCols[N][nPosHora] + oGet:aCols[N][nPosStatus]))
	
	SX3->(DbSeek(cAlias2))
	While !EOF() .And. SX3->X3_ARQUIVO == cAlias2
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL
			If !(AllTrim(SubStr(SX3->X3_CAMPO,5,6)) $ "FILIAL/PEDIDO/DATA/HORA/NOMUSU/")
				aAdd(aCampos,SX3->X3_CAMPO) // Campos a serem alterados, exceto os campos chave.
			EndIf
		EndIf
		SX3->(DbSkip())
	End
	
	M->Z05_DESCST := Posicione("Z04",1,xFilial("Z04") + oGet:aCols[N,nPosStatus],"Z04_DESC")
	
	AxVisual(cAlias2,nReg,nOpc,aCampos,,,,,,)
Else
	Alert("Não há Registros de Status no Pedido: " + cNum)
Endif

oGet:Refresh()
Return .T.
