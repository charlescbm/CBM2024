#INCLUDE "PROTHEUS.CH"

User Function UGOX001()
	
	Private aSize := MsAdvSize(.F., .F.)
	Private oDlgAut
	Private oLayerMan
	Private lEnv  := .F.
	Private oImp
	
	If Select("SM0") == 0
		
		RpcSetType(3)
		If !RpcSetEnv("01", "01")
			
			Final("Não foi possível carregar o ambiente!!!")
			
		EndIf
		
		lEnv := .T.
		
	EndIf
	
	lMsFinalAuto := .F.
	lMsHelpAuto  := .F.

	Private nG  := 0
	Private nO  := 0
	Private nO2 := 0
	Private nN  := 0
	Private nE  := 0
	Private cFile := ""
	Private oFile
	
	If lEnv
		DEFINE WINDOW oDlgAut FROM 1, 1 TO 22, 75 TITLE "Execução de Comandos Advpl"
	Else
		DEFINE MSDIALOG oDlgAut FROM aSize[7], 0 TO aSize[6]/1.5, aSize[5]/1.8 TITLE '' OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE, WS_POPUP) PIXEL
	EndIf
		
		oDlgAut:lEscClose := .F.
					
	If lEnv
		ACTIVATE WINDOW oDlgAut MAXIMIZED VALID (IIf(MsgYesNo("Você tem certeza que deseja sair?"), .T.,.F.)) ON INIT AtuTela()
	Else
		
		AtuTela()
		
		ACTIVATE MSDIALOG oDlgAut CENTERED
	EndIf
	
	If lEnv
		
		RpcClearEnv()
		
	EndIf
	
Return

Static Function Tecla(cTecla)
	
	If nG == 0
		
		If cTecla == "G"
			nG++
		Else
			nG := nO := nN := nE := 0
		EndIf
		
	ElseIf nG == 1 .And.(nO == 0 .Or. nO == 1)
		
		If cTecla == "O"
			nO++
		Else
			nG := nO := nN := nE := 0
		EndIf
		
	ElseIf nG == 1 .And. nO == 2 .And. nN == 0
		
		If cTecla == "N"
			nN++
		Else
			nG := nO := nN := nE := 0
		EndIf
		
	ElseIf nG == 1 .And. nO == 2 .And. nN == 1 .And. nE == 0 
		
		If cTecla == "E"
			oImp:Show()
		Else
			nG := nO := nN := nE := 0
		EndIf
		
	Else
		
		nG := nO := nN := nE := 0
		
	EndIf
	
Return

Static Function ValidaFunc(cFunc)
	
	Local bBlock := ErrorBlock({|e| Help(,, 'Help',, "Erro na função! Erro: " + e:Description, 1, 0 ), _lRet := .F.})
	Local xResult
	Local bReadWrite
	
	Private _lRet     := .T.
	
	If FindFunction("U_GrLogPut")
		U_GrLogPut("Usuário executando a seguinte linha de código de execução de função: ")
		U_GrLogPut(cFunc)
	EndIf
	
	bReadWrite := __COMPSTR(cFunc)
	
	Begin Sequence
		
		__runcb(bReadWrite)
		
	Recover
		_lRet := .F.
	End Sequence
	
	ErrorBlock(bBlock)
	
Return _lRet

Static Function AtuTela()
	
	oLayerMan := FWLayer():New()
	oLayerMan:Init(oDlgAut, .F.)
		
		oLayerMan:AddLine('MAIN', 95, .F.)
					
			oLayerMan:AddCollumn('MAN_ARQ', 100, .T., 'MAIN')
				
				oLayerMan:AddWindow('MAN_ARQ', 'WIN_MAN_ARQ', "Executar Código ADVPL", 100, .F., .T., , 'MAIN',)
					
					oFunc := tMultiget():New(10, 10, {|u| If(Pcount() > 0, cFile := u, cFile)}, ;
								oLayerMan:GetWinPanel('MAN_ARQ', 'WIN_MAN_ARQ', 'MAIN'), ;
								100, 100, , , , , , .T., , , , , , .F., , , , .F.)
					oFunc:Align := CONTROL_ALIGN_ALLCLIENT
					oFunc:EnableVScroll(.T.)
					oFunc:EnableHScroll(.F.)
					oFunc:lWordWrap := .T.
					oFunc:Refresh()
				
					//oFile := TGet():New(02, 02, {|u| IF(Pcount() > 0, cFile := u, cFile)}, oLayerMan:GetWinPanel('MAN_ARQ', 'WIN_MAN_ARQ', 'MAIN'), 200, 12, ,,,,,,, .T.,,,,,,, .F.,,, "cFile",,,,,,, "Função"/* Label */)
					//oFile:bValid := {|| }
					
					//oButton := tButton():New(3, 235, 'Buscar', oLayerMan:GetWinPanel('MAN_ARQ', 'WIN_MAN_ARQ', 'MAIN'), {|| cFile := cGetFile("Arquivos PDF(*.CSV)|*.csv|", "Arquivos CSV", 1,,, nOR(GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE), .F., .T.), IIf(Empty(cFile), (cFile := Space(254)), )}, 25, 10, , , , .T.)
					
		oLayerMan:AddLine('BOTTOM', 5, .F.)
			
			oLayerMan:AddCollumn('MAN_BOTTOM', 100, .T., 'BOTTOM')
				
				oPanelBot := tPanel():New(0, 0, "", oLayerMan:GetColPanel('MAN_BOTTOM', 'BOTTOM'),,,,, RGB(239,243,247), 000, 015)
				oPanelBot:Align	:= CONTROL_ALIGN_ALLCLIENT
				
				oQuit := THButton():New(0, 0, "&Sair", oPanelBot, {|| oDlgAut:End()}, , , )
				oQuit:nWidth  := 80
				oQuit:nHeight := 10
				oQuit:Align := CONTROL_ALIGN_RIGHT
				oQuit:SetColor(RGB(002, 070, 112), )
				
				oImp := THButton():New(0, 0, "&Executar", oPanelBot, {|| ValidaFunc(cFile)}, , , )
				oImp:nWidth  := 80
				oImp:nHeight := 10
				oImp:Align := CONTROL_ALIGN_RIGHT
				oImp:SetColor(RGB(002, 070, 112), )
				
				oImp:Hide()
				
				SetKey(K_CTRL_G, {|| Tecla("G")})
				SetKey(K_CTRL_O, {|| Tecla("O")})
				SetKey(K_CTRL_N, {|| Tecla("N")})
				SetKey(K_CTRL_E, {|| Tecla("E")})
	
Return
