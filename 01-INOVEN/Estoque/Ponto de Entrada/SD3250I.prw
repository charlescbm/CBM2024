#Include 'Protheus.ch'
/*/{Protheus.doc} SD3250R

SD3250I - Inclusao de apontamento de producao

@author GoOne Consultoria - Crele Cristia
@since 02/12/2021
@version 1.0
/*/
User Function SD3250I()

Local oDlgMain
Local aStrucTab    := {}

Local aCabec	:= {}
Local aItens	:= {}
Local aLin685	:= {}

Private cAliXML
Private aHeader := {}
Private aRotina := {{ "aRotina Falso", "AxPesq",	0, 1 },;
					{ "aRotina Falso", "AxVisual",	0, 2 },;
					{ "aRotina Falso", "AxInclui",	0, 3 },;
					{ "aRotina Falso", "AxAltera",	0, 4 }}

Private aSize      := MsAdvSize(.F., .F.)
Private aObjects   := {{ 100, 100 , .T., .T. }} 
Private aInfo      := {aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], -3, -13}
Private aPosObj    := MsObjSize( aInfo, aObjects)

Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.

	If alltrim(cFilAnt) <> '0103'
		Return
	endif

	AAdd(aStrucTab, {"BC_PRODUTO"	, "C", tamSx3('BC_PRODUTO')[1], tamSx3('BC_PRODUTO')[2]})
	AAdd(aStrucTab, {"BC_LOCORIG"	, "C", tamSx3('BC_LOCORIG')[1], tamSx3('BC_LOCORIG')[2]})
	AAdd(aStrucTab, {"BC_MOTIVO"	, "C", tamSx3('BC_MOTIVO')[1], tamSx3('BC_MOTIVO')[2]})
	AAdd(aStrucTab, {"BCQUANT"		, "N", tamSx3('BC_QUANT')[1], tamSx3('BC_QUANT')[2]})
	AAdd(aStrucTab, {"BC_LOTECTL"	, "C", tamSx3('BC_LOTECTL')[1], tamSx3('BC_LOTECTL')[2]})
	AAdd(aStrucTab, {"BC_DTVALID"	, "D", tamSx3('BC_DTVALID')[1], tamSx3('BC_DTVALID')[2]})

	Aadd(aHeader, {"Produto", "BC_PRODUTO", "", tamSx3('BC_PRODUTO')[1], tamSx3('BC_PRODUTO')[2], "", "", "C", "", ""})
	Aadd(aHeader, {"Almoxarifado", "BC_LOCORIG", "", tamSx3('BC_LOCORIG')[1], tamSx3('BC_LOCORIG')[2], "", "", "C", "", ""})
	Aadd(aHeader, {"Motivo", "BC_MOTIVO" , "", tamSx3('BC_MOTIVO')[1], tamSx3('BC_MOTIVO')[2], "", "", "C", "", ""})
	Aadd(aHeader, {"Qtde", "BCQUANT"  , PesqPict("SBC","BC_QUANT"), tamSx3('BC_QUANT')[1], tamSx3('BC_QUANT')[2], "", "", "C", "", ""})
	Aadd(aHeader, {"Lote", "BC_LOTECTL" , "", tamSx3('BC_LOTECTL')[1], tamSx3('BC_LOTECTL')[2], "", "", "C", "", ""})
	Aadd(aHeader, {"Data Valid", "BC_DTVALID" , "", tamSx3('BC_DTVALID')[1], tamSx3('BC_DTVALID')[2], "", "", "D", "", ""})

	If MsgYesNo("Este apontamento [ OP: " + SD3->D3_OP + " ] possui perda?")

		cAliXML := GFECriaTab({aStrucTab, {}})

		//Carregar os empenhos
		SD4->(DbSetOrder(2))
		SD4->(DbSeek(xFilial("SD4")+SD3->D3_OP))
		While !SD4->(Eof()) .And. SD4->(D4_FILIAL+D4_OP) == xFilial("SD4")+SD3->D3_OP
			If SD4->D4_QTDEORI < 0
				SD4->(DbSkip())
				Loop
			EndIf	

			(cAliXML)->(recLock(cAliXML, .T.))
			(cAliXML)->BC_PRODUTO	:= SD4->D4_COD
			(cAliXML)->BC_LOCORIG	:= SD4->D4_LOCAL
			(cAliXML)->(msUnlock())

			SD4->(dbSkip())
		End

		//Set Key VK_F4 TO goApShowF4()
		SetKEY( VK_F4, {|| goAptShowF4()} )

		DEFINE MSDIALOG oDlgMain FROM aSize[7], 0 TO aSize[6]/2, aSize[5]/2 TITLE '' OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE, WS_POPUP) PIXEL

			//oDlgMain:lEscClose := .F.

			oLayerXML := FWLayer():New()
			oLayerXML:Init(oDlgMain, .F.)

			oLayerXML:AddLine('MAIN', 95, .F.)
			
				oLayerXML:AddCollumn('COL_MAIN', 100, .T., 'MAIN')
				
				oLayerXML:AddWindow('COL_MAIN', 'WIN_COL_MAIN', "APONTAMENTO DE PERDA DOS COMPONENTES", 100, .F., .T., , 'MAIN',)

				oBrwXML := MsGetDB():New(05, 05, 145, 195, 3, "AlwaysTrue", "AlwaysTrue", , .T., {"BC_MOTIVO","BCQUANT"},, .F., 999, cAliXML, , , .F., oLayerXML:GetWinPanel('COL_MAIN', 'WIN_COL_MAIN', 'MAIN'), , , "AlwaysTrue",)
				oBrwXML:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

				oBrwXML:oBrowse:bAdd := {|| }


			oLayerXML:AddLine('BUTTON', 5, .F.)
				
				oLayerXML:AddCollumn('COL_BUTTON', 100, .T., 'BUTTON')

				oPanelBot := tPanel():New(0, 0, "", oLayerXML:GetColPanel('COL_BUTTON', 'BUTTON'), , , , , RGB(239, 243, 247), 000, 015)
				oPanelBot:Align	:= CONTROL_ALIGN_ALLCLIENT

				oQuit := THButton():New(0, 0, "&CANCELAR", oPanelBot, {|| (_lOk := .F.,oDlgMain:End())}, , , )
				oQuit:nWidth  := 80
				oQuit:nHeight := 10
				oQuit:Align   := CONTROL_ALIGN_RIGHT
				oQuit:SetColor(RGB(002, 070, 112), )
				
				//oQuit := THButton():New(0, 0, "&OK AJUSTE", oPanelBot, {|| iif(stESTAER(),(_lOk := .T.,oDlgMain:End()),_lOk := .F.) }, , , )
				oGrava := THButton():New(0, 0, "&OK PERDAS", oPanelBot, {|| iif(goVerLote(),(_lOk := .T.,oDlgMain:End()),_lOk := .F.) }, , , )
				oGrava:nWidth  := 80
				oGrava:nHeight := 10
				oGrava:Align   := CONTROL_ALIGN_RIGHT
				oGrava:SetColor(RGB(002, 070, 112), )

		
		ACTIVATE MSDIALOG oDlgMain CENTERED

		if _lOk

			aCabec := {{"BC_OP",SD3->D3_OP,NIL}}          

			(cAliXML)->(dbGoTop())
			While !(cAliXML)->(eof())
			
				if !empty((cAliXML)->BCQUANT)

					aItens := {{"BC_QUANT"	, (cAliXML)->BCQUANT,NIL},;           
							{"BC_PRODUTO"	,(cAliXML)->BC_PRODUTO,NIL},;           
							{"BC_LOCORIG"	,(cAliXML)->BC_LOCORIG,NIL},;
							{"BC_MOTIVO"	,(cAliXML)->BC_MOTIVO,NIL}}                      

						//	{"BC_CODDEST"	,(cAliXML)->BC_PRODUTO,NIL},;           
						//	{"BC_LOCAL"		,(cAliXML)->BC_LOCORIG,NIL}}                      

					if !empty((cAliXML)->BC_LOTECTL)
						aadd(aItens,{"BC_LOTECTL",(cAliXML)->BC_LOTECTL,NIL})
						aadd(aItens,{"BC_DTVALID",(cAliXML)->BC_DTVALID,NIL})
					endif

					AAdd(aLin685 ,aItens)
				Endif

				(cAliXML)->(dbSkip())
			End
			
			if !empty(len(aLin685))
				MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, aCabec, aLin685, 3)

				If lMsErroAuto
					MostraErro()
				else
					MsgAlert("Apontamento de Perda realizado com sucesso.")
				EndIf
			else
				MsgAlert("Nenhuma perda para gravar.")
			endif

		endif
		(cAliXML)->(dbcloseArea())

	Endif
	SET KEY VK_F4 TO

Return


Static Function goAptShowF4()

Local cOP       := NIL

Private n 	:= 1
Private aCols := {{'',ctod('')}}
Private nPosLotCTL := 1
Private nPosDValid := 2

F4Lote(,,,"A685",(cAliXML)->BC_PRODUTO,(cAliXML)->BC_LOCORIG,.F.,,,cOP)

(cAliXML)->(recLock(cAliXML,.F.))
(cAliXML)->BC_LOTECTL	:= aCols[1][1]
(cAliXML)->BC_DTVALID	:= aCols[1][2]
(cAliXML)->(msUnlock())

Return

Static Function goVerLote()
Local lRet := .T.

(cAliXML)->(dbGoTop())
While !(cAliXML)->(eof())

	if !empty((cAliXML)->BCQUANT)

		if (Rastro((cAliXML)->BC_PRODUTO)) .and. empty((cAliXML)->BC_LOTECTL)
			Help ( " ", 1, "BC_LOTECTL" )
			lRet := .F.
		endif
	Endif

	(cAliXML)->(dbSkip())
End
(cAliXML)->(dbGoTop())

Return( lRet )
