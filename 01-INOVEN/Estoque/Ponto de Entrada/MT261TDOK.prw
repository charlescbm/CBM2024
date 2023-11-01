#Include "Protheus.ch"
#Include "rWmake.CH"

// ##############################################################################
// Modulo   : Estoque
// Função   : MT261TDOK
// Descrição: Após gravacao da transferencia
//			  Grava data e hora
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------		

User Function MT261TDOK()

Local lPede := .F.

If !IsBlind() .AND. !lAutoma261 //-- Verifica se tem interface com o usuário.

	SD3->(dbSetOrder(2))
	SD3->(msSeek(xFilial('SD3') + cDocumento, .T.))
	While SD3->(!eof()) .and. SD3->D3_FILIAL == xFilial('SD3') .and. SD3->D3_DOC == cDocumento
	
		if substr(SD3->D3_CF, 1, 2) == 'DE' .and. alltrim(SD3->D3_LOCAL) == '02'
			lPede := .T.
			Exit
		endif

		SD3->(dbSkip())
	End

	if lPede
		goInfMot()
	endif
EndIf


Return .t.

//------------------------------------------------------------------- 
/*/{Protheus.doc} goInfMot
Abre tela para informar motivo da devolução.
/*/                                                                          	
//------------------------------------------------------------------
Static Function goInfMot()

Local oDlgEsp
Local lMotObrig := .T. //X3Obrigat("F1_MOTRET")
Local nOpcao	:= 0
Local aSize		:= MsAdvSize(.F.)
Local lWf		:= .F.

Private cMotRet  := CriaVar("DHI_CODIGO",.F.)
Private cDescRet := CriaVar("DHI_DESCRI",.F.)
Private cHistRet := CriaVar("F1_HISTRET",.F.)
Private oMemoRet := Nil


DEFINE MSDIALOG oDlgEsp From aSize[7],0 To aSize[6]/3,aSize[5]/2 OF oMainWnd TITLE 'Motivo acerto estoque' PIXEL STYLE DS_MODALFRAME

@ __DlgHeight(oDlgEsp)-110,005 TO __DlgHeight(oDlgEsp)-025,__DlgWidth(oDlgEsp)-5 LABEL 'Motivo do acerto' OF oDlgEsp PIXEL

@ __DlgHeight(oDlgEsp)-94,010 SAY RetTitle("D3_XMOTIVO") PIXEL
@ __DlgHeight(oDlgEsp)-95,040 MSGET cMotRet SIZE 95, 10 OF oDlgEsp F3 "DHI" PIXEL VALID;
 (cDescRet:=Posicione("DHI",1,xFilial("DHI")+cMotRet,"DHI_DESCRI"), Vazio() .Or. ExistCpo('DHI',cMotRet,1))

@ __DlgHeight(oDlgEsp)-95,145 MSGET cDescRet SIZE __DlgWidth(oDlgEsp)-165, 10 OF oDlgEsp PIXEL VALID Vazio() WHEN .F.

@ __DlgHeight(oDlgEsp)-70,010 SAY RetTitle("D3_XJUSTIF") PIXEL
@ __DlgHeight(oDlgEsp)-71,040 GET oMemoRet VAR cHistRet Of oDlgEsp MEMO size __DlgWidth(oDlgEsp)-60,37 pixel

oDlgEsp:lEscClose := .F.

DEFINE SBUTTON FROM __DlgHeight(oDlgEsp)-24,__DlgWidth(oDlgEsp)-65 TYPE 1 OF oDlgEsp ENABLE PIXEL ACTION ;
Eval({|| iIf(Iif(!Empty(cMotRet),.T.,Iif(lMotObrig,(MsgAlert("Informe um código de motivo valido."),.F.),.T.)),;
			(nOpcao := 1,oDlgEsp:End()),.F.)})

ACTIVATE MSDIALOG oDlgEsp CENTERED

If nOpcao == 1

	//Workflow 
	If File("\workflow\transf02_estoque.htm")
		lWf := .T.

		oProcess := TWFProcess():New("000001", OemToAnsi("Transferencia Armazem 02"))
		oProcess:NewTask("000001", "\workflow\transf02_estoque.htm")
		
		oProcess:cSubject 	:= "Transferencia Armazem 02 em " + dtoc(dA261Data)
		oProcess:bTimeOut	:= {}
		oProcess:fDesc 		:= "Transferencia Armazem 02 em " + dtoc(dA261Data)
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		oHTML:ValByName('d3doc', cDocumento)
		oHTML:ValByName('d3emissao', dA261Data)
		oHTML:ValByName('dtbase', dDataBase)

	endif

	SD3->(dbSetOrder(2))
	SD3->(msSeek(xFilial('SD3') + cDocumento, .T.))
	While SD3->(!eof()) .and. SD3->D3_FILIAL == xFilial('SD3') .and. SD3->D3_DOC == cDocumento
	
		if substr(SD3->D3_CF, 1, 2) == 'DE' .and. alltrim(SD3->D3_LOCAL) == '02'
			SD3->(recLOck('SD3', .F.))
			SD3->D3_XMOTIVO	:= cMotRet
			SD3->D3_XJUSTIF	:= cHistRet
			SD3->(msUnlock())

			if lWf
				SB1->(dbSetOrder(1))
				SB1->(msSeek(xFilial('SB1') + SD3->D3_COD))
				DHI->(dbSetOrder(1))
				DHI->(msSeek(xFilial('DHI') + SD3->D3_XMOTIVO))
				SB2->(dbSetOrder(1))
				SB2->(msSeek(xFilial('SB2') + SD3->D3_COD + SD3->D3_LOCAL))

				cMotivo := alltrim(SD3->D3_XMOTIVO) + ' - ' + alltrim(DHI->DHI_DESCRI)

				AAdd(oProcess:oHtml:ValByName('d3.tm'), SD3->D3_TM)
				AAdd(oProcess:oHtml:ValByName('d3.cod'), SD3->D3_COD)
				AAdd(oProcess:oHtml:ValByName('d3.nome'), alltrim(SB1->B1_DESC))
				AAdd(oProcess:oHtml:ValByName('d3.motivo'), cMotivo)
				AAdd(oProcess:oHtml:ValByName('d3.just'), SD3->D3_XJUSTIF)
				AAdd(oProcess:oHtml:ValByName('d3.qtde'), transform(SD3->D3_QUANT,PesqPict("SD3","D3_QUANT"))+"&nbsp;")
			endif

		endif

		SD3->(dbSkip())
	End

	if lWf
		oProcess:cTo := GetNewPar("IN_WFTREST", "charlesbattisti@gmail.com")			
		//oProcess:cTo := "crelec@gmail.com"
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()					

	endif
	
EndIf

Return .t.




                                          