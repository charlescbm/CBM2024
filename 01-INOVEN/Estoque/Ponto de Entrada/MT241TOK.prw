#Include "Protheus.ch"
#Include "rWmake.CH"

// ##############################################################################
// Modulo   : Faturamento
// Função   : MT241TOK
// Descrição: Validação dos campos da movimentação múltipla. 
//			  Grava data e hora
// ---------+-------------------+------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+------------------------------------------------		

User Function MT241TOK()

//Local aAreaSF5  := SF5->(GetArea())
//Local oDlg		
//Local oJustif	
//Local lRet 		:= .T.
//Local lOpca		:= .T.

//Local cJustif 	:= ""
                                       

If !IsBlind() .AND. !l241auto //-- Verifica se tem interface com o usuário.
			//If MsgYesNo("Deseja informar o motivo de retorno para nota fiscal de devolução?")
				fInfMot()
			//EndIf
EndIf


Return .t.

//------------------------------------------------------------------- 
/*/{Protheus.doc} fInfMot
Abre tela para informar motivo da devolução.
         
@author 	.iNi Sistemas (IR)
@since 		15/05/2019
@version 	P12.17
@obs  
Projeto 
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       Programador     Motivo 
/*/                                                                          	
//------------------------------------------------------------------
Static Function fInfMot()

Local oDlgEsp
//Local oCliente
//Local oFornece
//sLocal oDocto
//Local lDocto   := .T.
Local lMotObrig := .T. //X3Obrigat("F1_MOTRET")
Local nOpcao   := 0
Local aSize    := MsAdvSize(.F.)

Local nPosMot 	:= aScan(aHeader,{|x|AllTrim(x[2])=="D3_XMOTIVO"})
Local nPosJust := aScan(aHeader,{|x|AllTrim(x[2])=="D3_XJUSTIF"})
Local nx

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
		
//DEFINE SBUTTON FROM __DlgHeight(oDlgEsp)-24,__DlgWidth(oDlgEsp)-35 TYPE 2 OF oDlgEsp ENABLE PIXEL ACTION (nOpcao := 0,oDlgEsp:End())

ACTIVATE MSDIALOG oDlgEsp CENTERED

If nOpcao == 1
	
	For nX := 1 to len(aCols)
			aCols[nX][nPosJust] := cHistRet// Grava justificativa  
			aCols[nX][nPosMot]  := cMotRet // Grava justificativa
	Next nX	

	//Workflow 
	If File("\workflow\movto_estoque.htm")

		oProcess := TWFProcess():New("000001", OemToAnsi("Movimento de Estoque"))
		oProcess:NewTask("000001", "\workflow\movto_estoque.htm")
		
		oProcess:cSubject 	:= "Movimento de Estoque em " + dtoc(dA241Data)
		oProcess:bTimeOut	:= {}
		oProcess:fDesc 		:= "Movimento de Estoque em " + dtoc(dA241Data)
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		oHTML:ValByName('d3doc', cDocumento)
		oHTML:ValByName('d3emissao', dA241Data)
		oHTML:ValByName('dtbase', dDataBase)

		nPosCod 	:= aScan(aHeader,{|x|AllTrim(x[2])=="D3_COD"})
		nPosQtde 	:= aScan(aHeader,{|x|AllTrim(x[2])=="D3_QUANT"})
		nPosAlmo 	:= aScan(aHeader,{|x|AllTrim(x[2])=="D3_LOCAL"})

		For nX := 1 to len(aCols)

			SB1->(dbSetOrder(1))
			SB1->(msSeek(xFilial('SB1') + aCols[nX][nPosCod]))
			DHI->(dbSetOrder(1))
			DHI->(msSeek(xFilial('DHI') + aCols[nX][nPosMot]))
			SB2->(dbSetOrder(1))
			SB2->(msSeek(xFilial('SB2') + aCols[nX][nPosCod] + aCols[nX][nPosAlmo]))

			cMotivo := alltrim(aCols[nX][nPosMot]) + ' - ' + alltrim(DHI->DHI_DESCRI)

			AAdd(oProcess:oHtml:ValByName('d3.tm'), cTM)
			AAdd(oProcess:oHtml:ValByName('d3.cod'), aCols[nX][nPosCod])
			AAdd(oProcess:oHtml:ValByName('d3.nome'), alltrim(SB1->B1_DESC))
			AAdd(oProcess:oHtml:ValByName('d3.motivo'), cMotivo)
			AAdd(oProcess:oHtml:ValByName('d3.just'), aCols[nX][nPosJust])
			AAdd(oProcess:oHtml:ValByName('d3.valor'), 'R$ ' + transform(aCols[nX][nPosQtde] * SB2->B2_CM1,"@E 999,999,999.99")+"&nbsp;")

		Next nX	

		oProcess:cTo := GetNewPar("IN_WFMVEST", "charlesbattisti@gmail.com")			
		//oProcess:cTo := "crelec@gmail.com"
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()					

	endif
	
EndIf

Return .t.




                                          