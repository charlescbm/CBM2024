#include 'protheus.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 		!
+-------------------------------------------------------------------------------+
!Programa			! UINOV001 - Programa para chamar as importações em geral		! 
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para processar os arquivos .csv manualment		!
+-------------------+-----------------------------------------------------------+
!Autor         	! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 29/05/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UINOV001()

	Private cPar001	:= space(200)
	
	Private cExecRot	:= space(3)
	Private aExecRot	:= {}
	aadd(aExecRot, "   = ")
	/*aadd(aExecRot, "SA1=Clientes")
	aadd(aExecRot, "SA2=Fornecedores")
	aadd(aExecRot, "AGB=Telefones")
	aadd(aExecRot, "SB1=Produtos")*/
	aadd(aExecRot, "SE1=Contas a Receber")
	/*aadd(aExecRot, "SE2=Contas a Pagar")
	aadd(aExecRot, "SC5=Ped.Venda Aberto")
	aadd(aExecRot, "SA3=Amarrar Vendedores Cli")
	aadd(aExecRot, "SED=Amarrar Natureza Forne")
	aadd(aExecRot, "XA2=Fornecedores x Bancos")
	aadd(aExecRot, "XA1=Clientes 733")
	aadd(aExecRot, "CT2=Contabilização")
	aadd(aExecRot, "SN1=Ativo Fixo")
	aadd(aExecRot, "ZA1=Clientes Nobre")*/
	
	 
	_aSize      := MsAdvSize(.F., .F.)
	_aObjects   := {{ 100, 100 , .T., .T. }}
	_aInfo      := {_aSize[ 1 ], _aSize[ 2 ], _aSize[ 3 ], _aSize[ 4 ], -3, -13}
	_aPosObj    := MsObjSize( _aInfo, _aObjects)

	oFont := TFont():New('Courier new',,-18,.T.,.T.)

	DEFINE MSDIALOG oDlgMain FROM _aSize[7], 0 TO _aSize[6]/2, _aSize[5]/1.3 TITLE 'Cargas Manuais INOVEN -> Protheus' OF oMainWnd COLOR "W+/W" PIXEL

	oLayerXML := FWLayer():New()
	oLayerXML:Init(oDlgMain, .F.)

	oLayerXML:AddLine('TOP', 92, .F.)
	
	oLayerXML:AddCollumn('COL_TOP', 100, .T., 'TOP')

	oSayCfg := tSay():New(008,010,{|| "PARAMETROS:" },oLayerXML:GetColPanel('COL_TOP', 'TOP'),,oFont,,,,.T.,CLR_BLUE,CLR_WHITE,100,9)

	oSayIP := tSay():New(025,010,{|| "Arquivo para leitura:" },oLayerXML:GetColPanel('COL_TOP', 'TOP'),,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oGetIP := tGet():New(023,060,{|u| if(PCount()>0,cPar001:=u,cPar001)}, oLayerXML:GetColPanel('COL_TOP', 'TOP'),200,9,'@!',{ ||  },,,,,,.T.,,, {|| .T. } ,,,,.T.,,,'cPar001')
	SButton():New( 23,265,14,{|| goOpenFile() },oLayerXML:GetColPanel('COL_TOP', 'TOP'),.T.,,)

	oSayExec := tSay():New(025,310,{|| "Executar:" },oLayerXML:GetColPanel('COL_TOP', 'TOP'),,,,,,.T.,CLR_BLACK,CLR_WHITE,50,9)
	oCmbSrv := tComboBox():New(024,335,{|u|if(PCount()>0,cExecRot:=u,cExecRot)},aExecRot,180,9,oLayerXML:GetColPanel('COL_TOP', 'TOP'),, { ||  } ,,,,.T.,,,,,,,,,'cExecRot')
	oCmbSrv:bWhen := {|| .T.  }


	//--
	oLayerXML:AddLine('BUTTON', 8, .F.)
		
	oLayerXML:AddCollumn('COL_BUTTON', 100, .T., 'BUTTON')

	oPanelBot := tPanel():New(0, 0, "", oLayerXML:GetColPanel('COL_BUTTON', 'BUTTON'), , , , , RGB(239, 243, 247), 000, 015)
	oPanelBot:Align	:= CONTROL_ALIGN_ALLCLIENT
		
	oQuit := THButton():New(0, 0, "&CANCELAR", oPanelBot, {|| oDlgMain:End() }, , , )
	oQuit:nWidth  := 100
	oQuit:nHeight := 10
	oQuit:Align   := CONTROL_ALIGN_RIGHT
	oQuit:SetColor(RGB(002, 070, 112), )



	oQuit := THButton():New(0, 0, "&PROCESSAR", oPanelBot, {|| iif(FWMsgRun(, {|oSay| goOKProc( oSay ) }, "Cargas Manuais INOVEN -> Protheus", "Aguarde...processando dados..." ),(_lOk := .T.,oDlgMain:End()),_lOk := .F.) }, , , )
	oQuit:nWidth  := 100
	oQuit:nHeight := 10
	oQuit:Align   := CONTROL_ALIGN_RIGHT
	oQuit:SetColor(RGB(002, 070, 112), )
		

	ACTIVATE MSDIALOG oDlgMain CENTERED

	
return(  )


//Validações


Static Function goOKProc( oSay )

Local lRet		:= .T.
//Local aHeader	:= {} 

	if empty(cPar001)
		Aviso("Cargas Manuais INOVEN -> Protheus", "UM ARQUIVO PRECISA SER ESCOLHIDO!", {"Ok"}, 2)
		Return( .F. )
	endif
	
	if empty(substr(cExecRot,1,1)) .or. substr(cExecRot,1,1) == '=' 
		Aviso("Cargas Manuais INOVEN -> Protheus", "ESCOLHA QUAL ARQUIVO A SER PROCESSADO!", {"Ok"}, 2)
		Return( .F. )
	endif
	
	lRet := .F.
	//Seu programa deve retornar .T. ou .F.
	do Case
		Case alltrim(cExecRot) == 'SA1'; lRet := u_UNOBR002( cPar001 )
		Case alltrim(cExecRot) == 'SA2'; lRet := u_UNOBR003( cPar001 )
		Case alltrim(cExecRot) == 'AGB'; alert('chamar programa')
		Case alltrim(cExecRot) == 'SB1'; lRet := u_UNOBR004( cPar001 )
		Case alltrim(cExecRot) == 'SE1'; lRet := u_UINOV005( cPar001 )
		Case alltrim(cExecRot) == 'SE2'; lRet := u_UNOBR006( cPar001 )
		Case alltrim(cExecRot) == 'SC5'; lRet := u_UNOBR007( cPar001 )
		Case alltrim(cExecRot) == 'SA3'; lRet := u_UNOBR008( cPar001 )
		Case alltrim(cExecRot) == 'SED'; lRet := u_UNOBR009( cPar001 )
		Case alltrim(cExecRot) == 'XA2'; lRet := u_UNOBR010( cPar001 )
		Case alltrim(cExecRot) == 'XA1'; lRet := u_UNOBR011( cPar001 )
		Case alltrim(cExecRot) == 'CT2'; lRet := u_UNOBR012( cPar001 )
		Case alltrim(cExecRot) == 'SN1'; lRet := u_UNOBR013( cPar001 )
		Case alltrim(cExecRot) == 'ZA1'; lRet := u_UNOBR014( cPar001 )
	EndCase

	if lRet
		Aviso("Cargas Manuais INOVEN -> Protheus", "Arquivo Processado com Sucesso!", {"Ok"}, 2)
	else
		Aviso("Cargas Manuais INOVEN -> Protheus", "Ocorreu algum problema na execução do seu arquivo!", {"Ok"}, 2)
	endif
	
Return( .F. )


//Selecionar o arquivo a ser lido
Static Function goOpenFile()

	//Local aFiles
	Local cPath := ""
	cTipo := "Todos |*.csv"
	
	cPath := cGetFile( cTipo, OemToAnsi( "Abrir Arquivo..." ),1,,.F.,nOR( GETF_LOCALHARD, GETF_NETWORKDRIVE ), .T. )
	/* Fim */
	If !Empty(cPath)
		cPar001 := Alltrim(cPath)
		//oArqOrigem:Refresh()
	Else
	    ApMsgAlert("Nenhum arquivo não selecionado.","ATENÇÃO - "+ProcName())
		cPar001 := ""
	EndIf

Return
