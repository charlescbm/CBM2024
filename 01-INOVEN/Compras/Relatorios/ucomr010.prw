#include 'protheus.ch'
#include 'rwmake.ch'

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	               		!
+-------------------------------------------------------------------------------+
!Programa			! UCOMR010 - Acompanhamento Custo do Produto               	! 
+-------------------+-----------------------------------------------------------+
!Autor         	    ! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 04/10/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UCOMR010()

	Private cPerg    := "UCOMR010"
	
	Pergunte(cPerg, .T.)
	
	@ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Acompanhamento Custo do Produto"
	@ 8,10 TO 84,222

	@ 91,139 BMPBUTTON TYPE 5 ACTION PERGUNTE(cPerg,.T.)
	@ 91,168 BMPBUTTON TYPE 1 ACTION OKRun()  
	@ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

	@ 23,14 SAY "Esta rotina ira gerar uma consulta com os valores do custo pro produto"
	@ 33,14 SAY "conforme os parametros informados."

	ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function OKRun()

oProcpln := MsNewProcess():New({|| ProcIni(oProcpln)}, "Aguarde...", "Processando dados...")
oProcpln:Activate()

Return

/*/{Protheus.doc} ProcIni
Função de processamento da rotina
@type function
@author Crele Cristina da Costa
@since 19/03/2015
@version 1.0
@param oProcess, objeto, Objeto de processamento
/*/Static Function ProcIni(oProcpln)	
Local aStruSQL := {}
Local _x

Private aColunas := {}
Private aFormula := {}

    //Define as colunas dos periodos
    lAtual := .F.
    dDtIni := LastDay(mv_par05, 1)  //primeiro dia
    dDtFim := LastDay(mv_par06)     //ultimo dia
    While dDtIni <= dDtFim
        if month(dDtIni) ==  month(dDataBase) .and. year(dDtIni) == year(dDataBase)
            lAtual := .T.
        endif
        aadd(aColunas, {'C'+substr(dtos(dDtIni),1,6), substr(upper(MesExtenso(month(dDtIni))),1,3) + "/" + strzero(year(dDtIni),4) })
        aadd(aColunas, {'V'+substr(dtos(dDtIni),1,6), "Variação %" })
        dDtIni := MonthSum(dDtIni,1)
    End
    if !lAtual
        aadd(aColunas, {'C'+substr(dtos(dDataBase),1,6), substr(upper(MesExtenso(month(dDataBase))),1,3) + "/" + strzero(year(dDataBase),4) })
        aadd(aColunas, {'V'+substr(dtos(dDataBase),1,6), "Variação %" })
    endif

    //Montando formulas de variacao das colunas
    For _x := 1 to len(aColunas) step 2
        if _x + 2 > len(aColunas)
            exit
        endif
        aadd(aFormula,{aColunas[_x + 1][1], aColunas[_x + 3][1]})
    Next

	If ( Select('TRBD') <> 0 )
		TRBD->(dbCloseArea())
	Endif

	aStruSQL := {}
	AADD(aStruSQL,{"B9_COD"	    ,"C", TamSx3("B9_COD")[1], TamSx3("B9_COD")[2] })
	AADD(aStruSQL,{"B1_DESC"	,"C", TamSx3("B1_DESC")[1], TamSx3("B1_DESC")[2] })
	AADD(aStruSQL,{"B9_LOCAL"	,"C", TamSx3("B9_LOCAL")[1], TamSx3("B9_LOCAL")[2] })
	//AADD(aStruSQL,{"B9_CM1"	,"C", TamSx3("E5_TIPODOC")[1], TamSx3("E5_TIPODOC")[2] })
    For _x := 1 to len(aColunas)
        if substr(aColunas[_x][1],1,1) == "C"
            AADD(aStruSQL,{aColunas[_x][1]	,"N", TamSx3("B9_CM1")[1], TamSx3("B9_CM1")[2] })
        else
            AADD(aStruSQL,{aColunas[_x][1]	,"N", 10, 2 })
        endif
    Next
    AADD(aStruSQL,{"V999999"	,"N", 10, 2 })

    //Cria temporario
	oTRBD := FwTemporaryTable():New("TRBD")
	oTRBD:SetFields(aStruSQL)
    oTRBD:AddIndex("01", {"B9_COD", "B9_LOCAL"} )
	//Criação da tabela temporaria
	oTRBD:Create()

	//Realiza a busca dos dados
	ProcQryTab(oProcpln)

    Private aHeader := {}
    Aadd(aHeader, {"Produto"    , "B9_COD", "", tamSx3('B9_COD')[1], tamSx3('B9_COD')[2], "", "", "C", "", ""})
    Aadd(aHeader, {"Descricao"  , "B1_DESC", "", tamSx3('B1_DESC')[1], tamSx3('B1_DESC')[2], "", "", "C", "", ""})
    Aadd(aHeader, {"Local"      , "B9_LOCAL", "", tamSx3('B9_LOCAL')[1], tamSx3('B9_LOCAL')[2], "", "", "C", "", ""})
    For _x := 1 to len(aColunas)
        if substr(aColunas[_x][1],1,1) == "C"
            Aadd(aHeader, {aColunas[_x][2] , aColunas[_x][1], PesqPict("SB9","B9_CM1"), tamSx3('B9_CM1')[1], tamSx3('B9_CM1')[2], "", "", "N", "", ""})
        elseif _x > 2
            Aadd(aHeader, {aColunas[_x][2] , aColunas[_x][1], "@E 999,999.99", 10, 2, "", "", "N", "", ""})
        endif
    Next
    Aadd(aHeader, {"Var.Inicial x Final" , "V999999", "@E 999,999.99", 10, 2, "", "", "N", "", ""})

    goBuildWin()

Return


Static Function ProcQryTab(oProcpln)
Local _x

	oProcpln:IncRegua1("Montando CONSULTA...")
	SysRefresh()
	
	pergunte(cPerg, .F.)

	If ( Select('QRY') <> 0 )
		QRY->(dbCloseArea())
	Endif

    cQuery := ""
    cQuery += "select b9_cod, b1_desc, b9_local, substring(b9_data,1,6) b9_data, b9_cm1 "
    cQuery += "from "+RetSqlName("SB9")+" b9 "
    cQuery += "inner join "+RetSqlName("SB1")+" b1 on b1_cod = b9_cod "
    cQuery += "where b9.d_e_l_e_t_ = ' ' and b1.d_e_l_e_t_ = ' ' "
    cQuery += "and b9_cod between '" + mv_par01 + "' and '" + mv_par02 + "' "
    cQuery += "and b9_local between '" + mv_par03 + "' and '" + mv_par04 + "' "
    cQuery += "and b9_data <> ' ' "
    cQuery += "and b9_data between '" + dtos(mv_par05) + "' and '" + dtos(mv_par06) + "' "

    cQuery += "union all "    

    cQuery += "select b2_cod, b1_desc, b2_local, '" + substring(dtos(dDataBAse),1,6) + "' b9_data, b2_cm1 "
    cQuery += "from "+RetSqlName("SB2")+" b2 "
    cQuery += "inner join "+RetSqlName("SB1")+" b1 on b1_cod = b2_cod "
    cQuery += "where b2.d_e_l_e_t_ = ' ' and b1.d_e_l_e_t_ = ' ' "
    cQuery += "and b2_cod between '" + mv_par01 + "' and '" + mv_par02 + "' "
    cQuery += "and b2_local between '" + mv_par03 + "' and '" + mv_par04 + "' "
    //cQuery += "and b9_data <> ' ' "
    //cQuery += "and b9_data between '" + dtos(mv_par05) + "' and '" + dtos(mv_par06) + "' "

    cQuery += "order by b9_cod, b9_local, b9_data "

    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'QRY')

    //MemoWrite('\temp\query_resumo_natureza.txt', cQuery)
    
    nCount := 0
	dbEval( {|x| nCount++ },,{|| QRY->(!EOF()) })
	
	QRY->(dbGotop())
	oProcpln:SetRegua2(nCount)
	SysRefresh()
	
	While QRY->(!eof())
	
		oProcpln:IncRegua2('Alimentando temporario....')
		SysRefresh()
		
		if !TRBD->(msSeek(QRY->B9_COD + QRY->B9_LOCAL))
            TRBD->(reclock('TRBD', .T.))
            TRBD->B9_COD    := QRY->B9_COD
            TRBD->B1_DESC   := QRY->B1_DESC
            TRBD->B9_LOCAL  := QRY->B9_LOCAL
        else
            TRBD->(reclock('TRBD', .F.))
        endif
        cCampo := 'TRBD->C'+QRY->B9_DATA
        &(cCampo) := QRY->B9_CM1


		TRBD->(msUnlock())
		
		QRY->(dbSkip())
	End
	QRY->(dbCloseArea())


    //Calculo da variacao
    TRBD->(dbGoTop())
    While !TRBD->(eof())
    
        for _x := 1 to len(aFormula)
            //variacao de cada periodo
            cCampo := 'TRBD->'+aFormula[_x][2]

            xVlrFim := &('TRBD->C'+substr(aFormula[_x][2],2,10))
            xVlrIni := &('TRBD->C'+substr(aFormula[_x][1],2,10))

            if empty(xVlrFim) .and. empty(xVlrIni)
                xValor := 0
            else
                xValor := ((xVlrFim / xVlrIni) - 1) * 100
            endif

            TRBD->(recLock('TRBD', .F.))
            &(cCampo) := xValor
            TRBD->(msUnlock())
        next

        //Variação geral
        xVlrFim := &('TRBD->C'+substr(aFormula[len(aFormula)][2],2,10))
        xVlrIni := &('TRBD->C'+substr(aFormula[1][1],2,10))

        if empty(xVlrFim) .and. empty(xVlrIni)
            xValor := 0
        else
            xValor := ((xVlrFim / xVlrIni) - 1) * 100
        endif
        TRBD->(recLock('TRBD', .F.))
        TRBD->V999999 := xValor
        TRBD->(msUnlock())

        TRBD->(dbSkip())
    End

Return

Static Function goBuildWin()

	Local oDlgMain
    Local lOkMan := .F.

	Private aRotina := {{ "aRotina Falso", "AxPesq",	0, 1 },;
						{ "aRotina Falso", "AxVisual",	0, 2 },;
						{ "aRotina Falso", "AxInclui",	0, 3 },;
						{ "aRotina Falso", "AxAltera",	0, 4 }}

	Private aSize      := MsAdvSize(.F., .F.)
	Private aObjects   := {{ 100, 100 , .T., .T. }} 
	Private aInfo      := {aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], -3, -13}
	Private aPosObj    := MsObjSize( aInfo, aObjects)

	//DEFINE MSDIALOG oDlgMain FROM aSize[7], 0 TO aSize[6]/1.3, aSize[5]/1.3 TITLE 'RELATORIO DE NATUREZAS' OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE, WS_POPUP) PIXEL
	DEFINE MSDIALOG oDlgMain FROM aSize[7], 0 TO aSize[6], aSize[5] TITLE 'ACOMPANHAMENTO DE CUSTO' OF oMainWnd COLOR "W+/W" PIXEL

		//oDlgMain:lEscClose := .F.

		oLayerXML := FWLayer():New()
		oLayerXML:Init(oDlgMain, .F.)

		oLayerXML:AddLine('MAIN', 95, .F.)
		
			oLayerXML:AddCollumn('COL_MAIN', 100, .T., 'MAIN')
			
			oLayerXML:AddWindow('COL_MAIN', 'WIN_COL_MAIN', "RELACAO DE PRODUTOS", 100, .F., .T., , 'MAIN',)

			//oBrwXML := MsGetDB():New(05, 05, 145, 195, 3, "AlwaysTrue", "AlwaysTrue", , .T., {"QTDEU","C6_ZMOTRES"},, .F., 999, cAliXML, , , .F., oLayerXML:GetWinPanel('COL_MAIN', 'WIN_COL_MAIN', 'MAIN'), , , "AlwaysTrue",)
			oBrwXML := MsGetDB():New(05, 05, 145, 195, 3, "AlwaysTrue", "AlwaysTrue", , .T.,,, .F., 999, "TRBD", , , .F., oLayerXML:GetWinPanel('COL_MAIN', 'WIN_COL_MAIN', 'MAIN'), , , "AlwaysTrue",)
			oBrwXML:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

			oBrwXML:oBrowse:bAdd := {|| }
			//oBrwXML:oBrowse:bLDblClick := {|nRow, nCol| U_SENX8CLK(nRow, nCol)}


		oLayerXML:AddLine('BUTTON', 5, .F.)
			
			oLayerXML:AddCollumn('COL_BUTTON', 100, .T., 'BUTTON')

			oPanelBot := tPanel():New(0, 0, "", oLayerXML:GetColPanel('COL_BUTTON', 'BUTTON'), , , , , RGB(239, 243, 247), 000, 015)
			oPanelBot:Align	:= CONTROL_ALIGN_ALLCLIENT

			oQuit := THButton():New(0, 0, "&FECHAR", oPanelBot, {|| (lOkMan := .F.,oDlgMain:End()) }, , , )
			oQuit:nWidth  := 80
			oQuit:nHeight := 10
			oQuit:Align   := CONTROL_ALIGN_RIGHT
			oQuit:SetColor(RGB(002, 070, 112), )

			oExpo := THButton():New(0, 0, "&EXPORTAR EXCEL", oPanelBot, {|| (MsAguarde({|lEnd| goBuildExcel()},"Aguarde...","Preparando dados para a planilha...",.T.), oBrwXML:oBrowse:goTop(.T.)) }, , , )
			oExpo:nWidth  := 120
			oExpo:nHeight := 10
			oExpo:Align   := CONTROL_ALIGN_RIGHT
			oExpo:SetColor(RGB(002, 070, 112), )
	
	ACTIVATE MSDIALOG oDlgMain CENTERED on INIT oBrwXML:oBrowse:goTop(.T.)

Return




Static Function goBuildExcel( )

Local oExcel		:= FWMsExcelEx():New()

Local cWrkSht       := ""
Local cTabTitle     := ""

Local lTotalize		:= .F.

Local nField, _x

BEGIN SEQUENCE
	
	MsProcTxt("Criando a estrutura da Planilha...")

    aHeadGrupo	:= {}
    Aadd(aHeadGrupo, {"Produto"    , "B9_COD", "C", tamSx3('B9_COD')[1], tamSx3('B9_COD')[2], ""})
    Aadd(aHeadGrupo, {"Descricao"  , "B1_DESC", "C", tamSx3('B1_DESC')[1], tamSx3('B1_DESC')[2], ""})
    Aadd(aHeadGrupo, {"Local"      , "B9_LOCAL", "C", tamSx3('B9_LOCAL')[1], tamSx3('B9_LOCAL')[2], ""})
    For _x := 1 to len(aColunas)
        if substr(aColunas[_x][1],1,1) == "C"
            Aadd(aHeadGrupo, {aColunas[_x][2] , aColunas[_x][1], "N", tamSx3('B9_CM1')[1], tamSx3('B9_CM1')[2], PesqPict("SB9","B9_CM1")})
        elseif _x > 2
            Aadd(aHeadGrupo, {aColunas[_x][2] , aColunas[_x][1], "N", 10, 2, "@E 999,999.99"})
        endif
    Next
    Aadd(aHeadGrupo, {"Var.Inicial x Final" , "V999999", "N", 10, 2,"@E 999,999.99"})

    cTabTitle   := "ACOMPANHAMENTO DE CUSTO - " + substr(upper(MesExtenso(month(mv_par05))),1,3) + "/" + strzero(year(mv_par05),4) + ' ATE ' + substr(upper(MesExtenso(month(mv_par06))),1,3) + "/" + strzero(year(mv_par06),4)
    cWrkSht    := 'RELACAO DOS PRODUTOS'
    
    
    //Primeira planilha
    oExcel:AddworkSheet(cWrkSht)
    oExcel:AddTable(cWrkSht, cTabTitle)

    //Cria as colunas 
    nFields := Len( aHeadGrupo )
    For nField := 1 To nFields
        
        //If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
            cType := aHeadGrupo[nField][3]	//__AHEADER_TYPE__
            nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
            nFormat := IF(cType=="D",4,IF(cType=="N",2,1)) 
            cColumn := aHeadGrupo[nField][1]	//__AHEADER_TITLE__
            lTotal := ( lTotalize .and. cType == "N" )
            oExcel:AddColumn(@cWrkSht,@cTabTitle,@cColumn,@nAlign,@nFormat,@lTotal)
        //EndIf
        
    Next nField

    aNegri := {}
    for nField := 6 To nFields-1 Step 2
        aadd(aNegri, nField)
    next
    aadd(aNegri, nFields)

    //Popula a planilha
    aCells := Array(nFields)

    MsProcTxt("Populando a planilha com os valores...")

    cBkgCor := "#B8CCE4"
    TRBD->(dbGotop())
    While TRBD->(!eof())
        
        For nField := 1 To nFields
            
            //If MV_PAR07 == 2 .Or. (aScan(aNoFields, {|x| x[1] == AllTrim(aHead01[nField][2])})) == 0
                uCell := &('TRBD->' + aHeadGrupo[nField][2])
                cPicture := aHeadGrupo[nField][6]	//__AHEADER_PICTURE__
                IF ValType(uCell) # "N" .And. !( Empty(cPicture) )
                    uCell := Transform(uCell,cPicture)
                ElseIf ValType(uCell) == "N"
                    uCell := AllTrim(Transform(uCell,"@E 999,999,999,999.99"))
                EndIF
                aCells[nField] := uCell
            //EndIf
            
        Next
        
        oExcel:SetCelBold(.T.)
        oExcel:SetCelBgColor(cBkgCor)
        oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),aNegri)

        cBkgCor := iif(cBkgCor == "#B8CCE4", "#DCE6FA", "#B8CCE4")
        /*
        if empty(TRBG->ED_PAI)
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#FFFFFF")
            oExcel:SetCelBgColor("#203764")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        elseif len(alltrim(TRBG->ED_PAI)) == 1
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#8EA9DB")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        else
            oExcel:SetCelBold(.T.)
            oExcel:SetCelFrColor("#000000")
            oExcel:SetCelBgColor("#D9E1F2")
            oExcel:AddRow(@cWrkSht,@cTabTitle,aClone(aCells),{1,2,3})
        endif
        */

        TRBD->(dbSkip())
        
    EndDo

	oExcel:Activate()
	
	MsProcTxt("Criando a planilha para visualização...")
	
	//Nome do Arquivo
	cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	
	While File( cFile )
		cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
	End While
	
	oExcel:GetXMLFile( cFile )
	
	oExcel:DeActivate()
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	cFileTMP := ( GetTempPath() + cFile )
	IF .NOT.( __CopyFile( cFile , cFileTMP ) )
		alert('nao deu de copiar')
		fErase( cFile )
		cFile := ""
		BREAK
	EndIF

	fErase( cFile )
	
	cFile := cFileTMP
	
	IF .NOT.( File( cFile ) )
		cFile := ""
		BREAK
	EndIF
	
	IF .NOT.( ApOleClient("MsExcel") )
		alert('nao sera possivel abrir excel')
		BREAK
	EndIF
	
	oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open( cFile )
	oMsExcel:SetVisible( .T. )
	oMsExcel := oMsExcel:Destroy()

END SEQUENCE

oExcel := FreeObj( oExcel )

Return


