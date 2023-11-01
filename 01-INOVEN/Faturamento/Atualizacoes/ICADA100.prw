#INCLUDE "PROTHEUS.CH"
#INCLUDE "MSMGADD.CH"

/*/{Protheus.doc} ICADA100
Cadastro de Faixas % de Comissao
@author Crele C. Da Costa
@since 01/08/2022
@version 1.0
@see (links_or_references)
/*/
User FUNCTION ICADA100()
	
	Local cAlias	  := "Z93"	
	Private cCadastro := "Cadastro Faixas % de Comissão"
	Private	aRotina	  := MenuDef()	 

	(cAlias)->(dbSetOrder(1))
	(cAlias)->(dbGoTop())
	
	mBrowse(6,1,22,75,cAlias,,,,,,,,,,,,,,) 
	
Return(Nil)              
//--------------------------------------------------------------------------------------
/*/
{Protheus.doc} MenuDef
Função utilizada para Criar definir botões do Menu

@author		.iNi Sistemas [Rodolfo]
@since     	16/02/19
@version  	P.12
@param		Nenhum
@return    	Nenhum
@obs        Nenhum

Alterações Realizadas desde a Estruturação Inicial
------------+-----------------+---------------------------------------------------------
Data       	|Desenvolvedor    |Motivo                                                    
------------+-----------------+---------------------------------------------------------
/*/
//---------------------------------------------------------------------------------------
Static Function MenuDef() 

  Local aBrwRot :={}
                    	
  aAdd(aBrwRot,{"Pesquisar"		,"AxPesqui"	,0,1,0,.F.})
  aAdd(aBrwRot,{"Visualizar"	,"U_ICADM100"	,0,2,0,Nil})
  aAdd(aBrwRot,{"Incluir"		,"U_ICADM100"	,0,3,0,Nil})
  aAdd(aBrwRot,{"Alterar"		,"U_ICADM100"	,0,4,0,Nil})
  aAdd(aBrwRot,{"Excluir"		,"U_ICADM100"	,0,5,0,Nil})                	
                    	                    	
Return(aBrwRot)
//--------------------------------------------------------------------------------------

User Function ICADM100(cAlias,nReg,nOpc)

Local c, nX
Private INCLUI := iif(nOpc == 3, .T., .F.)
Private ALTERA := iif(nOpc == 4, .T., .F.)
Private EXCLUI := iif(nOpc == 5, .T., .F.)
Private oGetZ93, aColsZ93 := {}

//Resolucao de Tela 
aSize := MSADVSIZE()
aCoors := FWGetDialogSize( oMainWnd )

nUsadoZ93 := 0
aHeadZ93  := {}
aCampos := FWSX3Util():GetAllFields( "Z93" , .T. )
For c := 1 to len(aCampos)
	IF X3USO(TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_USADO'))) .AND.;
	   cNivel >= Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_NIVEL')
		nUsadoZ93++
		AADD(aHeadZ93,{ TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3Titulo()')),;
			alltrim(aCampos[c]),;
			X3Picture( alltrim(aCampos[c]) ),;
			tamSx3( alltrim(aCampos[c]) )[1],;
			tamSx3( alltrim(aCampos[c]) )[2],;
			TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_VALID')),;
			TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_USADO')),;
			FWSX3Util():GetFieldType( alltrim(aCampos[c]) ),;
			TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_F3')),;
			TRIM(Posicione('SX3', 2, alltrim(aCampos[c]), 'X3_CONTEXT')) } )
	EndIf
Next

//RegToMemory(cAlias, If(INCLUI,.T.,.F.))
if INCLUI
	M->Z93_ANO	:= Criavar('Z93_ANO')
	M->Z93_MES	:= Criavar('Z93_MES')
	M->Z93_TIPO	:= Criavar('Z93_TIPO')
	M->Z93_VEND	:= Criavar('Z93_VEND')
	aadd(aColsZ93,Array(nUsadoZ93+1))
	For nX := 1 To nUsadoZ93
		if aHeadZ93[nX,2] <> "Z93_ITEM"
			aColsZ93[1,nX] := CriaVar(aHeadZ93[nX,2])
		else
			aColsZ93[1,nX] := "01"
		endif
	Next nX
	aColsZ93[1,nUsadoZ93+1] := .F.
else
	M->Z93_ANO	:= Z93->Z93_ANO
	M->Z93_MES	:= Z93->Z93_MES
	M->Z93_TIPO	:= Z93->Z93_TIPO
	M->Z93_VEND	:= Z93->Z93_VEND
	Z93->(dbSetOrder(1))
	Z93->(msSeek(xFilial("Z93") + M->Z93_ANO + M->Z93_MES + M->Z93_TIPO + M->Z93_VEND,.T.))
	While !Z93->(eof()) .and. Z93->Z93_FILIAL == xFilial("Z93") .and. Z93->Z93_ANO + Z93->Z93_MES + Z93->Z93_TIPO + Z93->Z93_VEND == M->Z93_ANO + M->Z93_MES + M->Z93_TIPO + M->Z93_VEND
		aadd(aColsZ93,Array(nUsadoZ93+1))

		aColsZ93[len(aColsZ93),1] := Z93->Z93_ITEM
		aColsZ93[len(aColsZ93),2] := Z93->Z93_FAIXA1
		aColsZ93[len(aColsZ93),3] := Z93->Z93_FAIXA2
		aColsZ93[len(aColsZ93),4] := Z93->Z93_COMIS
		aColsZ93[len(aColsZ93),nUsadoZ93+1] := .F.
		
		Z93->(dbSkip())
	End
endif

aFields := {}


DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
DEFINE MSDIALOG oDlgS TITLE "Faixas % de Comissão" PIXEL FROM aCoors[1], aCoors[2] To aCoors[3], aCoors[4]

	oFWLayer := FWLayer():New()
	oFWLayer:Init(oDlgS, .F., .T.)
	
	oFWLayer:AddLine('TOP', 30, .F.)
	oFWLayer:AddCollumn('VEND', 100, .T., 'TOP') //Dados vendedor
	oLayerT := oFWLayer:GetColPanel('VEND', 'TOP')
	
	oFWLayer:AddWindow('VEND', 'WIN_VEND', "Vendedor", 100, .F., .T.,, 'TOP',)
		ADD FIELD aFields TITULO "Mês" CAMPO "MESFAI" TIPO "C" TAMANHO TamSx3('Z93_MES')[1] DECIMAL 0 PICTURE "" VALID "" OBRIGAT NIVEL 1 WHEN INCLUI
		//M->MESFAI := space(TamSx3('Z93_MES')[1])
		M->MESFAI := M->Z93_MES

		ADD FIELD aFields TITULO "Ano" CAMPO "ANOFAI" TIPO "C" TAMANHO TamSx3('Z93_ANO')[1] DECIMAL 0 PICTURE "" VALID "" OBRIGAT NIVEL 1 WHEN INCLUI
		M->ANOFAI := iif(INCLUI, strzero(year(dDataBase),4), M->Z93_ANO)

		ADD FIELD aFields TITULO "Tipo" CAMPO "TIPOFAI" TIPO "C" TAMANHO TamSx3('Z93_TIPO')[1] DECIMAL 0 PICTURE "" VALID PERTENCE("VS")  OBRIGAT NIVEL 1 WHEN INCLUI
		aFields[len(aFields)][15] := "V=Vendedor;S=Supervisor"
		M->TIPOFAI := iif(INCLUI, "V", M->Z93_TIPO)

		ADD FIELD aFields TITULO "Vendedor" CAMPO "VNDFAI" TIPO "C" TAMANHO TamSx3('Z93_VEND')[1] DECIMAL 0 PICTURE "" VALID "Vazio().or.ExistCPO('SA3', M->VNDFAI )"  NIVEL 1 WHEN INCLUI F3 "SA3"
		M->VNDFAI := M->Z93_VEND

		ADD FIELD aFields TITULO "Nome" CAMPO "DESVND" TIPO "C" TAMANHO TamSx3('A3_NOME')[1] DECIMAL 0 PICTURE "" VALID "" NIVEL 1 WHEN .F.
		M->DESVND := space(TamSx3('A3_NOME')[1])

		oVends := MsMGet():New(,, 4,,,,, {0,0,0,0},,,,,, oFWLayer:GetWinPanel('VEND', 'WIN_VEND', 'TOP'),,.T.,,,,.T., aFields,,.T.,,,.T.)
		oVends:oBox:Align := CONTROL_ALIGN_ALLCLIENT

		
	oFWLayer:AddLine('CENTER', 60, .F.) 
	oFWLayer:AddCollumn('BRWC', 100, .T., 'CENTER') //Browse Clientes
	oLayerR := oFWLayer:GetColPanel('BRWC', 'CENTER')	
	oFWLayer:AddWindow('BRWC', 'WIN_CLI', "Faixas", 100, .F., .T.,, 'CENTER',)

	//Browses
	oGetZ93 := MsNewGetDados():New(030,005,95,245,IIF(INCLUI.or.ALTERA,GD_INSERT+GD_UPDATE+GD_DELETE,0),"U_CAD100LO","U_CAD100TO","",,,999,/*fieldok*/,/*superdel*/,/*delok*/,oFWLayer:GetWinPanel('BRWC', 'WIN_CLI', 'CENTER'),aHeadZ93,aColsZ93)
	oGetZ93:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

	oFWLayer:AddLine('BOTT', 10, .F.)
	oFWLayer:AddCollumn('BUTTONS', 100, .T., 'BOTT') //Botoes
	oLayerB := oFWLayer:GetColPanel('BUTTONS', 'BOTT')

	oQuit := THButton():New(0, 0, "SAIR", oLayerB, {|| oDlgS:End(), lRetOk := .F.}, , ,)
	oQuit:nWidth  := 80
	oQuit:nHeight := 10
	oQuit:Align := CONTROL_ALIGN_RIGHT
	oQuit:SetColor(RGB(002,070,112),)
	
	oAglut := THButton():New(0, 0, "GRAVAR DADOS", oLayerB, {|| CADAOK100()}, , ,)
	oAglut:nWidth  := 100
	oAglut:nHeight := 10
	oAglut:Align := CONTROL_ALIGN_RIGHT
	oAglut:SetColor(RGB(002,070,112),)


ACTIVATE MSDIALOG oDlgS CENTERED //ON INIT fAliTrb()

RETURN

USER FUNCTION CAD100LO()
Local lOK	:= .T.
Return lOK

USER FUNCTION CAD100TO()
Local lOK	:= .T.

if INCLUI .or. ALTERA
	if empty(M->ANOFAI) .or. empty(M->MESFAI)
		lOk := .F.
		MsgAlert("O ANO e/ou MES devem ser informados!")
		return lOk
	endif
endif

if INCLUI
	/*if !empty(M->VNDFAI)
		SA3->(dbSetOrder(1))
		SA3->(msSeek(xFilial('SA3') + M->VNDFAI))
		if SA3->A3_TIPO <> 'I'
			lOk := .F.
			MsgAlert("Apenas vendedores do tipo INTERNO podem ser usados!")
			return lOk
		endif
	endif*/

	Z93->(dbSetOrder(1))
	Z93->(msSeek(xFilial('Z93') + M->ANOFAI + M->MESFAI + M->TIPOFAI + M->VNDFAI, .T.))
	if Z93->Z93_FILIAL + Z93->Z93_ANO + Z93->Z93_MES + Z93->Z93_TIPO + Z93->Z93_VEND = xFilial('Z93') + M->ANOFAI + M->MESFAI + M->TIPOFAI + M->VNDFAI
		lOk := .F.
		MsgAlert("Já existe um periodo de faixas cadastrado para este vendedor!")
	endif
endif

Return lOK

Static Function CADAOK100()
Local _x

	if (INCLUI.or.ALTERA) .and. U_CAD100TO()

		For _x:= 1 to len(oGetZ93:aCols)
			if !empty(oGetZ93:aCols[_x][1]) .and. !oGetZ93:aCols[_x,nUsadoZ93+1]
			
				Z93->(dbSetOrder(1))
				if !Z93->(msSeek(xFilial("Z93") + M->ANOFAI + M->MESFAI + M->TIPOFAI + M->VNDFAI + oGetZ93:aCols[_x][1]))
					Z93->(recLock("Z93", .T.))
				else
					Z93->(recLock("Z93", .F.))
				endif
				Z93->Z93_FILIAL	:= xFilial("Z93")
				Z93->Z93_ANO	:= M->ANOFAI
				Z93->Z93_MES	:= M->MESFAI
				Z93->Z93_TIPO	:= M->TIPOFAI
				Z93->Z93_VEND	:= M->VNDFAI
				Z93->Z93_ITEM	:= oGetZ93:aCols[_x][1]
				Z93->Z93_FAIXA1	:= oGetZ93:aCols[_x][2]
				Z93->Z93_FAIXA2	:= oGetZ93:aCols[_x][3]
				Z93->Z93_COMIS	:= oGetZ93:aCols[_x][4]
				Z93->(msUnlock())
			
			elseif !empty(oGetZ93:aCols[_x][1])
			
				Z93->(dbSetOrder(1))
				if Z93->(msSeek(xFilial("Z93") + M->ANOFAI + M->MESFAI + M->TIPOFAI + M->VNDFAI + oGetZ93:aCols[_x][1]))
					Z93->(recLock("Z93", .F.))
					Z93->(dbDelete())
					Z93->(msUnlock())
				endif
				
			endif
		Next
	
		msgAlert("Dados Gravados com Sucesso!!!","Gravar Dados")
		oDlgS:End()
	endif
	if EXCLUI
		For _x:= 1 to len(oGetZ93:aCols)
			Z93->(dbSetOrder(1))
			if Z93->(msSeek(xFilial("Z93") + M->ANOFAI + M->MESFAI + M->TIPOFAI + M->VNDFAI + oGetZ93:aCols[_x][1]))
				Z93->(recLock("Z93", .F.))
				Z93->(dbDelete())
				Z93->(msUnlock())
			endif
		Next
	
		msgAlert("Dados Excluídos com Sucesso!!!","Gravar Dados")
		oDlgS:End()
	endif
	if !INCLUI .and. !ALTERA .and. !EXCLUI
		oDlgS:End()
	endif	
Return
