#include 'protheus.ch'
#INCLUDE "Dbstruct.ch"

Static _oFINA0601

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA    	                 		!
+-------------------------------------------------------------------------------+
!Programa			! UFINA005 - Baixas e transferencias por lote - INOVEN	! 
+-------------------+-----------------------------------------------------------+
!Descricao			! Rotina para processar baixas ou transferencia dos a receber!
+-------------------+-----------------------------------------------------------+
!Autor         	! GOONE CONSULTORIA - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao 	! 10/06/2021							                	!
+-------------------+-----------------------------------------------------------+
*/

user function UFINA005()

Local pAcao	    	:= { "Baixar","Transferir" }
Local pCarteira		:= { "Simples","Descontada", "Sem Carteira", "Todos" }
Local pBanco        := padR("",tamSx3("E1_PORTADO")[1])
Local pBorDe		:= padR("",tamSx3("E1_NUMBOR")[1])
Local pEmisDe		:= dDataBase
Local pEmisAte		:= dDataBase
Local pVenDe		:= dDataBase
Local pVenAte		:= dDataBase

Local aStru			:= {}
Local aStruSE1		:= {}
Local nJ

Private aCampos		:= {}
Private cMarca   	:= GetMark()
Private oMark
Private lInverte	:= .F.
Private aParam		:= {}
Private nAcao       := 0
Private nCarteira	:= 0
Private cBanco      := ''
Private cBordDe		:= ''
Private dEmisDe		:= ctod('')
Private dEmisAte	:= ctod('')
Private dVencDe		:= ctod('')
Private dVencAte	:= ctod('')

Private nIndice		:= SE1->(Indexord())
Private aSeek       := {}
Private nValor		:= 0
Private nQtdTit		:= 0
Private nSomaData 	:= 0
Private cPict06014	:= PesqPict("SE1","E1_VALOR",16,1)
Private oPrazoMed

IF PARAMBOX( {	{3,"Ação Desejada",1,pAcao,80,"",.T.},;
                {1,"Nr. Bordero", pBorDe,"@!",".T.","","",30,.F.},;
                {1,"Codigo Banco", pBanco,"@!",".T.","BCO","",30,.F.},;
				{1,"Emissao De", pEmisDe,"",".T.","","",60,.T.},;
				{1,"Emissao Ate", pEmisAte,"",".T.","","",60,.T.},;
				{1,"Vencimento De", pVenDe,"",".T.","","",60,.T.},;
				{1,"Vencimento Ate", pVenAte,"",".T.","","",60,.T.},;
				{3,"Carteira",1,pCarteira,80,"",.T.}	;
                }, "Defina os parametros para o Filtro", @aParam,,,,,,,,.F.,.T.)


	nAcao       := mv_par01
    cBordDe		:= mv_par02
    cBanco      := mv_par03
	dEmisDe		:= mv_par04
	dEmisAte	:= mv_par05
	dVencDe		:= mv_par06
	dVencAte	:= mv_par07
	nCarteira	:= mv_par08

    if nAcao == 2 .and. nCarteira == 4
        MsgAlert("Para executar a transferencia, escolha uma carteira. A opcao de AMBAS não será aceita.")
        Return
    endif
    if nAcao == 2 .and. empty(cBanco)  //Se transferencia
        MsgAlert("Para a operação de transferencia o banco precisa ser informado.")
        Return
    endif

    //Criação da estrutura de TRB com base em SE1.
    SE1->(DbSetOrder(nIndice))

    aStruSE1 := SE1->(DbStruct())
    aStru	 := {}
	For nJ := 1 To Len(aStruSE1)
		If aStruSE1[nJ][DBS_TYPE] <> "M"
			AAdd(aStru, aStruSE1[nJ])
		EndIf
	Next nJ
    ASize(aStruSE1,0)

    AAdd(aStru,{"RECSE1","N",10,0})

	//Certifico de que o TRB esta fechado.
	If (Select("TRB") <> 0)
		TRB->(DbCloseArea())
	EndIf

	//cIndice	:= SE1->(IndexKey())
	//aChaveTRB := TTFtIndex(Strtokarr2(cIndice, "+"))

	//Cria tabela temporária
	If _oFINA0601 <> Nil
		_oFINA0601:Delete()
		_oFINA0601 := Nil
	EndIf

	_oFINA0601 := FwTemporaryTable():New("TRB")
	_oFINA0601:SetFields(aStru)
	//_oFINA0601:AddIndex("1", {"E1_PREFIXO","E1_NUM","E1_PARCELA","E1_TIPO"})
	_oFINA0601:AddIndex("1", {"E1_NUM","E1_PARCELA","E1_TIPO"})
	_oFINA0601:AddIndex("2", {"E1_NUMBCO"})
	_oFINA0601:AddIndex("3", {"E1_VENCREA"})
	_oFINA0601:AddIndex("4", {"E1_NOMCLI"})

	//Criação da tabela temporaria
	_oFINA0601:Create()

    //nTamI := tamSx3('E1_PREFIXO')[1]+tamSx3('E1_NUM')[1]+tamSx3('E1_PARCELA')[1]+tamSx3('E1_TIPO')[1]
    //aAdd(aSeek,{"Prefixo+Numero+Parcela+Tipo"    ,{{"","C",nTamI,0,"Prefixo+Numero+Parcela+Tipo"    ,"@!"}} } )
    nTamI := tamSx3('E1_NUM')[1]+tamSx3('E1_PARCELA')[1]+tamSx3('E1_TIPO')[1]
    aAdd(aSeek,{"Numero+Parcela+Tipo"    ,{{"","C",nTamI,0,"Numero+Parcela+Tipo"    ,"@!"}} } )
    nTamI := tamSx3('E1_NUMBCO')[1]
    aAdd(aSeek,{"Nosso Numero"    ,{{"","C",nTamI,0,"Nosso Numero"    ,"@!"}} } )
    nTamI := tamSx3('E1_VENCREA')[1]
    aAdd(aSeek,{"Vencimento Real"    ,{{"","D",nTamI,0,"Vencimento Real"    ,""}} } )
    nTamI := tamSx3('E1_NOMCLI')[1]
    aAdd(aSeek,{"Nome do Cliente"    ,{{"","C",nTamI,0,"Nome do Cliente"    ,""}} } )

	//Montagem de array para tratamento na MarkBrowse com o arquivo TRB
    aPriori := {"E1_PREFIXO",;
                "E1_NUM    ",;
                "E1_PARCELA",;
                "E1_CLIENTE",;
                "E1_LOJA   ",;
                "E1_NOMCLI ",;
                "E1_EMISSAO",;
                "E1_VENCTO ",;
                "E1_VENCREA",;
                "E1_VALOR  ",;
                "E1_SALDO  ",;
                "E1_PORTADO",;
                "E1_AGEDEP ",;
                "E1_CONTA  ",;
                "E1_SITUACA",;
                "E1_NUMBCO ",;
                "E1_VEND1  "}
	//AAdd(aCampos,{"E1_OK",""," "," "})
    for nJ := 1 to len(aPriori)
    	SX3->(DbSetOrder(2))
	    SX3->(DbSeek(aPriori[nJ]))
        AAdd(aCampos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE})
    next
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SE1"))
	While !SX3->(EOF()) .And. SX3->X3_ARQUIVO=="SE1"
		If (x3Uso(SX3->x3_usado) .And. AllTrim(SX3->X3_CAMPO) != "E1_OK" .And. SX3->X3_CONTEXT != "V" .And. SX3->X3_TIPO != "M")
			if empty(aScan(aPriori,SX3->X3_CAMPO))
                //AAdd(aCampos,{SX3->X3_CAMPO,"",AllTrim(X3Titulo()),SX3->X3_PICTURE})
                AAdd(aCampos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE})
            endif
		EndIf
		SX3->(DbSkip())
	EndDo


	//Realiza o filtro e alimenta o arquivo
	goFazFiltro()

	//Verifica a existencia de registros no TRB.
	DbSelectArea("TRB")
	DbGoTop()
	lSaida := .T.
	If BOF() .And. EOF()
		Help(" ",1,"RECNO")
		return
	EndIf

	
	//Mostra a tela com os titulos
	nIndice	:= SE1->(Indexord())
	nOpca := goViewWin()

	If nOpca == 2
		//Exit
		lSaida := .T.
	ElseIf nOpca == 0
		TRB->(DbCloseArea())
		If _oFINA0601 <> Nil
			_oFINA0601:Delete()
			_oFINA0601 := Nil
		EndIf
		SE1->(DbSetOrder(nIndice))
		lSaida := .F.
		//Loop
	EndIf
	DbSelectArea("SE1")

	//fazer o processamento
    if nOpca == 1   //CONFIRMOU
        if nAcao == 1   //Baixas
            if MsgYesNo("OS TITULOS SELECIONADOS SERAO BAIXADOS. CONTINUA?")
                MsAguarde({|lEndTra| u_goOkBaixa(@lEndTra)},"Aguarde...","Processando Títulos",.T.)
            else
                Alert("O processo foi cancelado.")
            endif
        endif
        if nAcao == 2   //Transferencias
            xTexto1 := iif(nCarteira==1,"SIMPLES","DESCONTADA")
            xTexto2 := iif(nCarteira==1,"DESCONTADA","SIMPLES")
            if MsgYesNo("OS TITULOS SELECIONADOS SERAO TRANSFERIDOS DE CARTEIRA " + xTexto1 + " PARA " + xTexto2 + ". CONTINUA?")
                MsAguarde({|lEndTra| u_goOkTrans(@lEndTra, nCarteira)},"Aguarde...","Processando Títulos",.T.)
            else
                Alert("O processo foi cancelado.")
            endif
        endif
    endif

ENDIF

Return


Static Function goFazFiltro()
	Local aStru := {}
	Local nJ, ni

	SE1->(DbSetOrder(12))            // Chave (Numero do Bordero+DTOS(Data de Emissao))
	aStru := SE1->(DbStruct())

	cQuery := "SELECT "
	For nj:= 1 to Len(aStru)
		If aStru[nJ][DBS_TYPE] <> "M"
			cQuery += aStru[nj,1]+", "
		EndIf
	Next
	cQuery += "R_E_C_N_O_ RECNO "
	cQuery += "  FROM "+	RetSqlName("SE1") + " SE1 "
	cQuery += " WHERE "
    if !empty(cBordDe)
	    cQuery += "   E1_NUMBOR = '" + cBordDe + "' AND "
    endif
    cQuery += "   E1_PORTADO = '" + cBanco + "'"
	cQuery += "   AND E1_EMISSAO between '" + DTOS(dEmisDe)+ "' AND '" + DTOS(dEmisAte) + "'"
	cQuery += "   AND E1_VENCREA between '" + DTOS(dVencDe)+ "' AND '" + DTOS(dVencAte) + "'"
	if nCarteira == 1
		cQuery += "   AND E1_SITUACA = '1'"
	elseif nCarteira == 2
		cQuery += "   AND E1_SITUACA = '2'"
	elseif nCarteira == 3
		cQuery += "   AND E1_SITUACA = '0'"
	else
		cQuery += "   AND E1_SITUACA IN ('0','1','2')"
	endif
	cQuery += "   AND E1_SALDO > 0 "
	cQuery += "   AND E1_TIPO NOT IN " + F060NotIN(.F.) 	//F060NotIN(lMarkAbt)
	cQuery += "   AND D_E_L_E_T_ <> '*' "
	cQuery += " ORDER BY "+ SqlOrder(SE1->(IndexKey()))

	cQuery := ChangeQuery(cQuery)

	//SE1->(DbCloseArea())
	//SA1->(DbSelectArea("SA1"))

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TSE1', .F., .T.)

	For ni := 1 to Len(aStru)
		If aStru[ni,2] != 'C' .AND. aStru[ni,2] != "M"
			TCSetField('TSE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
		EndIf
	Next
	
	While !TSE1->(EOF())

		//Gravar campos de TRB.
		If TSE1->E1_SALDO > 0
			TRB->(RecLock("TRB",.T.))
			For ni := 1 to SE1->(FCount())
				If TRB->(FieldName(nI)) == TSE1->(FieldName(nI))
					If TSE1->(ValType(FieldName(nI))) # "M"
						TRB->(FieldPut(nI,TSE1->(FieldGet(ni))))
					EndIf
				EndIf
			Next

			TRB->RECSE1 	:= TSE1->RECNO
			TRB->E1_OK  	:= Space(2)
			//TRB->E1_NUMBOR	:= cNumBor

			TRB->(MsUnLock())
		EndIf
		TSE1->(DbSkip())
	EndDo

    TSE1->(DbCloseArea())
    //ChKFile("SE1")
    //SE1->(DbSetOrder(12))

Return



Static Function goViewWin()

//fA060MarkB("TRB",nLimite,dVencIni,dVencFim,cSituacao,oPrazoMed,ovalor,aCampos,cNumbor,lMarkAbt,nIndice,cIndF060CH)


    Local oDlg1
    Local oFnt
    //Local bWhile
    //Local nRec		:= 0
    Local nOpca		:= 0
    Local aBut060	:= {}
    Local bSet16	:= SetKey(16,{||Fa060Pesq(oMark,"TRB",nIndice)})
    Local aChaveLbn := {}
    Local oSize		:= Nil
    Local a1stRow	:= {}
    Local a2ndRow	:= {}
    Local iX		:= 0

    aBut060 := {{"PESQUISA",{||Fa060Pesq(oMark,"TRB",nIndice,"")}, "Pesquisar..(CTRL-P)","Pesquisar"}}

    DEFINE FONT oFnt NAME "Arial" SIZE 12,14 BOLD

    nPrazo := 0
    nValor := 0

    DbSelectArea('TRB')
    /*
    bWhile := { || ! EOF() }
    nRec:=RecNo()
    DbSeek(xFilial("SE1"))
    DBEVAL({ |a| go060DBEVA(0,dVencDe,dVencAte,"TRB",aChaveLbn,.F.) } , bWhile)
    DbGoTo(nRec)
    */
    nOpca :=0

    //If !_lF060Auto
        //Faz o calculo automatico de dimensoes de objetos
        oSize := FwDefSize():New(.T.)

        oSize:lLateral := .F.
        oSize:lProp	:= .T. // Proporcional

        oSize:AddObject("1STROW" ,  100, 10, .T., .T.) // Totalmente dimensionavel
        oSize:AddObject("2NDROW" ,  100, 90, .T., .T.) // Totalmente dimensionavel

        oSize:aMargins := { 2, 2, 1, 2 } // Espaco ao lado dos objetos 0, entre eles 3

        oSize:Process() // Dispara os calculos

        a1stRow := {oSize:GetDimension("1STROW","LININI"),;
                    oSize:GetDimension("1STROW","COLINI"),;
                    oSize:GetDimension("1STROW","LINEND"),;
                    oSize:GetDimension("1STROW","COLEND")}

        a2ndRow := {oSize:GetDimension("2NDROW","LININI"),;
                    oSize:GetDimension("2NDROW","COLINI"),;
                    oSize:GetDimension("2NDROW","LINEND"),;
                    oSize:GetDimension("2NDROW","COLEND")}

        xTitulo := OemToAnsi(iif(nAcao == 1, "BAIXAS - INOVEN", "TRANSFERENCIA - INOVEN") )

        DEFINE MSDIALOG oDlg1 TITLE xTitulo From oSize:aWindSize[1],oSize:aWindSize[2] to oSize:aWindSize[3],oSize:aWindSize[4] OF oMainWnd PIXEL
        oDlg1:lMaximized := .T.

            oPanel := TPanel():New(a2ndRow[1],a2ndRow[2],,oDlg1,,,,,,oSize:GetDimension("2NDROW","XSIZE"),oSize:GetDimension("2NDROW","YSIZE"),.F.,.T.)
            //oPanel := TPanel():New(a2ndRow[1]+20,a2ndRow[2],,oDlg1,,,,,,0,0,.F.,.T.)
                //oPanel:Align := CONTROL_ALIGN_ALLCLIENT

        ////////
        // Panel
            
            @ a1stRow[1] + 001 , a1stRow[2] + 001  To a1stRow[3]-10,a1stRow[4] PIXEL OF oDlg1
            @ a1stRow[1] + 008 , a1stRow[2] + 003 Say OemToAnsi("Valor Total:") PIXEl OF oDlg1  // "Valor Total:"
            @ a1stRow[1] + 008 , a1stRow[2] + 040 Say oValor VAR nValor Picture cPict06014 SIZE 60,8 PIXEl OF oDlg1
            @ a1stRow[1] + 008 , a1stRow[2] + 100 Say OemToAnsi("Quantidade:") PIXEl OF oDlg1 // "Quantidade:"
            @ a1stRow[1] + 008 , a1stRow[2] + 150 Say oQtda VAR nQtdTit Picture "@E 99999" SIZE 50,8 PIXEl OF oDlg1
        // Panel
        ////////
    //EndIf

    /*If FN022SITCB(cSituacao)[3]		//cSituacao $ "27"
        If nValor != 0
            nPrazoMed := nPrazo / nValor
        Else
            nPrazoMed := 0
        EndIf
        If !_lF060Auto
            @ a1stRow[1] + 003 , a1stRow[2] + 100 Say OemToAnsi(STR0050) SIZE 70,8 PIXEl OF oDlg1 // "Prazo M‚dio Vencimento:"
            @ a1stRow[1] + 003 , a1stRow[2] + 175 Say oPrazoMed VAR nPrazoMed Picture "@E 9999.99" SIZE 50,8 PIXEl OF oDlg1
        EndIf
    EndIf*/


    //If !_lF060Auto
        //////////////
        // Mark Browse
            /*
            oMark := MsSelect():New("TRB","E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{a2ndRow[1],a2ndRow[2],a2ndRow[3],a2ndRow[4]})
            oMark:bMark := {| | fa060disp(cMarca,lInverte,oValor,oQtda,oPrazoMed,.F.,0,.F.)}
            oMark:oBrowse:lhasMark = .T.
            oMark:oBrowse:lCanAllmark := .T.
            oMark:bAval	:= {||go060bAval(cMarca,oValor,oQtda,oPrazoMed,0,.F.,aChaveLbn,.F.)}
            oMark:oBrowse:bAllMark := { || FA060Inverte(cMarca,oValor,oQtda,oPrazoMed,0,.F.,aChaveLbn,,,.F.) }
            */
            
            oMark := FWMarkBrowse():New()                        // Cria o objeto oMark - MarkBrowse
            oMark:SetOwner(oPanel)  				// Tamanho específico
            oMark:SetAlias('TRB')                                 // Define a tabela do MarkBrowse
            oMark:SetTemporary(.T.)                                  // Indica que é referente a uma tabela temporária
            oMark:SetFields(aCampos)                                 // Define os campos a serem mostrados no MarkBrowse
            oMark:SetAllMark({|| FA060Inverte(cMarca,oValor,oQtda,oPrazoMed,0,.F.,aChaveLbn,,,.F.)})                  // Marca / Desmarca todos
            oMark:SetCustomMarkRec({|| fa060disp(cMarca,lInverte,oValor,oQtda,oPrazoMed,.F.,0,.F.)})            // Ação ao marcar
            oMark:SetFieldMark("E1_OK")                             // Define o campo utilizado para a marcacao
            oMark:oBrowse:SetFixedBrowse(.T.)                    // Não deixa minimizar
            oMark:DisableDetails()
            oMark:DisableConfig(.T.)                                    // Não habilita as configurações
            oMark:DisableReport(.T.)                                    // Desabilita a opcao de imprimir
            oMark:oBrowse:SetSeek(.T.,aSeek) //Habilita a utilização da pesquisa de registros no Browse
            oMark:SetMenuDef("") 
            oMark:Activate()
            
        // Mark Browse
        //////////////

        //AAdd(aBut060, {"S4WB005N",{ || Fa060Visu() }, OemToAnsi(STR0078)+" "+OemToAnsi("Baixa/Transferencia - INOVEN"), OemToAnsi(STR0078)})
        //AAdd(aBut060, {"S4WB005N",{ || Fa060Visu() }, OemToAnsi("Baixa/Transferencia - INOVEN"), OemToAnsi("CRELE")})
        // Caso a rotina tenha sido chamada através da automação de testes, não apresenta a interface.

        //If IsPanelFin()
        //    ACTIVATE MSDIALOG oDlg1 ON INIT (FaMyBar(oDlg1,;
        //    {|| nOpca := 1,If(ABS(NVALOR)>0,oDlg1:End(),Help(" ",1,"FA060VALOR"))},;
        //    {|| nOpca := 2,oDlg1:End()},aBut060),oMark:oBrowse:Refresh())
        //Else
            ACTIVATE MSDIALOG oDlg1 ON INIT (MayIUseCode("SE1"+xFilial("SE1")+cBordDe),EnchoiceBar(oDlg1,;
            {|| nOpca := 1,If(ABS(NVALOR)>0,oDlg1:End(),Help(" ",1,"FA060VALOR"))},;
            {|| nOpca := 2,oDlg1:End()},,),oMark:oBrowse:Refresh()) CENTERED

        //EndIf

        SetKey(16,bSet16)
    //EndIf

    If !Empty(aChaveLbn)
        For iX := 1 to Len(aChaveLbn)
            SE1->(msRUnlock(aChaveLbn[iX]))
        Next
    EndIf

Return nOpca


Static Function Fa060Pesq(oMark, cAlias,nIndice,cIndF060CH)
    Local nRecno  := 0
    Local nRecTrb := 0
    Local cCampos := {}
    Local aPesqui := {}
    Local aSIXVal := {}
    Local cSeek   := ""

    Default  nIndice := cAlias->(Indexord())
    Default  cIndF060CH := ""

    If Empty(cIndF060CH)
        aSIXVal := aClone(FIndPesq("SE1"))//Retorna a descricao do indice posicionado para compor a pesquisa

        If ValType(aSIXVal) == "A" .And. Len(aSIXVal) > 0 //Precaucao caso o retorno da rotina tenha algum problema
            aPesqui := {aClone(aSIXVal[nIndice])}
        Else
            SIX->(DbSeek("SE1"+AllTrim(STR(nIndice))))
            AAdd(aPesqui,{SIX->DESCRICAO,1})
        EndIf
    Else
        AAdd(aPesqui,{cIndF060CH,1})
    EndIf

    DbSelectArea(cAlias)
    nRecno  := Recno()
    nRecTrb := TRB->(RecNo())
    cCampos := TRB->(IndexKey())
    // Obtem os campos de pesquisa de cAlias, para pesquisar no TRB, pois
    // os indice do TRB eh unico (FILIAL+PREFIXO+NUMERO+PARCELA+TIPO) e em
    // AxPesqui, o usuario pode escolher a chave desejada.
    cCampos := cAlias + "->(" + cCampos + ")"

    WndxPesqui(oMark:oBrowse,aPesqui,cSeek,.F.)

    oMark:oBrowse:Refresh(.T.)

Return Nil

Static Function Fa060Disp(cMarca,lInverte,oValor,oQtda,oPrazoMed,lF060Mark,nLimite,lMarkAbt)
    Local nData := 0
    Local lMarcado
    Local nAbat := 0
    Local nVlJur := 0

    Private aParam		:= {}

    lMarcado := oMark:IsMark(oMark:Mark())

    SE1->(DbGoTo(TRB->RECSE1))
    nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA,,,E1_TIPO)
  
    if nAcao == 1 //Se baixa
        if dtos(TRB->E1_VENCREA) < dtos(dDataBAse)  //se vencido, pedir valor de juros

            IF PARAMBOX( {	{1,"Vlr.Juros", nVlJur,"@E 999,999,999.99",".T.","","",80,.F.};
                        }, "Informe os dados p/Baixa", @aParam,,,,,,,,.F.,.T.)

                TRB->(recLock('TRB',.F.))
                TRB->E1_VALJUR := mv_par01
                TRB->(msUnlock())
            Endif

        endif
    endif

    //Se acao transferir e carteira descontada para simples, solicitar valor de juros individualmente
    if nAcao == 2 .and. nCarteira == 2
        IF PARAMBOX( {	{1,"Vlr.Juros", nVlJur,"@E 999,999,999.99",".T.","","",80,.F.};
                    }, "Informe os dados p/Transferencia", @aParam,,,,,,,,.F.,.T.)

            TRB->(recLock('TRB',.F.))
            TRB->E1_VALJUR := mv_par01
            TRB->(msUnlock())
        Endif
    endif

	Begin Sequence
	
		TRB->(RecLock('TRB', .F.))
			TRB->E1_OK := IIf(lMarcado, Space(2), oMark:Mark())
		TRB->( MsUnlock() )

        if TRB->E1_OK == oMark:Mark()

            If TRB->E1_TIPO $ MVABATIM
                nValor	-= E1_SALDO
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	-= (nData * E1_SALDO)
            Else
                nValor	+= (E1_SALDO-nAbat)
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	+= (nData * (E1_SALDO-nAbat))
            EndIf
            nQtdTit++
            nSomaData += nData
            If nValor != 0
                nPrazoMed := nPrazo / nValor
            Else
                nPrazoMed := 0
            EndIf
        Elseif lMarcado
            If TRB->E1_TIPO $ MVABATIM
                nValor	+= (E1_SALDO-nAbat)
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	+= (nData * E1_SALDO)
            Else
                nValor	-= (E1_SALDO-nAbat)
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	-= (nData * (E1_SALDO-nAbat))
            EndIf
            nQtdTit--
            nSomaData -= nData
            If nValor != 0
                nPrazoMed := nPrazo / nValor
            Else
                nPrazoMed := 0
            EndIf
        EndIf
        nQtdTit:= IIf(nQtdTit<0,0,nQtdTit)
        nSomaData := IIf(nSomaData<0,0,nSomaData)

	End Sequence

    /*
    If (lMarcado := IsMark("E1_OK",cMarca,lInverte))
        If (nValor + E1_SALDO) <= (nLimite) .Or. Empty(nLimite)
            If E1_TIPO $ MVABATIM
                nValor -= E1_SALDO
                If VALTYPE(oPrazoMed) == "O"
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	-= (nData * E1_SALDO)
                EndIf
            Else
                nValor += (E1_SALDO-nAbat)
                If VALTYPE(oPrazoMed) == "O"
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	+= (nData * (E1_SALDO-nAbat))
                EndIf
            EndIf
            nQtdTit++
            nSomaData += nData
        Else
            If IsMark("E1_OK",cMarca,lInverte)
                Reclock("TRB")
                TRB->E1_OK := "  "
                MsUnlock()
            EndIf
        EndIf
    Elseif !lMarcado
        If E1_TIPO $ MVABATIM
            nValor += E1_SALDO
            If VALTYPE(oPrazoMed) == "O"
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	+= (nData * E1_SALDO)
            EndIf
        Else
            nValor -= (E1_SALDO-nAbat)
            If VALTYPE(oPrazoMed) == "O"
                nData := E1_VENCREA - E1_EMISSAO
                nPrazo	-= (nData * (E1_SALDO-nAbat))
	        EndIf
        EndIf
        nQtdTit--
        nSomaData -= nData
        nQtdTit:= IIf(nQtdTit<0,0,nQtdTit)
        nSomaData := IIf(nSomaData<0,0,nSomaData)
    EndIf
    */
    oValor:Refresh()
    oQtda:Refresh()
    If VALTYPE(oPrazoMed) == "O"
        If nValor != 0
            nPrazoMed := nPrazo / nValor
        Else
            nPrazoMed := 0
        EndIf
        oPrazoMed:Refresh()
    EndIf
Return

Static Function Fa060Inverte(cMarca,oValor,oQtda,oPrazoMed,nLimite,lMarkAbt,aChaveLbn,cChaveLbn, lTodos,lF060Mark)
    Local nReg := TRB->(Recno())
    Local lMarcado
    Local nAbat := 0
    Local nAscan
    Local aAreaSE1 := SE1->(getArea())
    Local lRet := .T.

    nSomaData := 0
    Default lTodos := .T.

    //Se transferencia e descontada para simples, nao permite escolher marcar todos
    if nAcao == 2 .and. nCarteira == 2
        MsgAlert("Para esta operação não é permitido escolher MARCAR TODOS. Selecione os títulos individualmente.")
        Return
    endif

    DbSelectArea("TRB")
    //If lTodos
    //    DbSeek(Xfilial("SE1"),.T.)
    //EndIf
    While !lTodos .Or. (!EOF() .And. E1_FILIAL >= Xfilial("SE1") .And. E1_FILIAL <= Xfilial("SE1"))
        If lTodos .Or. cChaveLbn == Nil
            cChaveLbn := "BOR" + E1_FILIAL +E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
        EndIf

        SE1->(DbGoTo(TRB->RECSE1))

        If lRet .And. (!lTodos .Or. (lTodos .And. SE1->(SimpleLock())))
            nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA,E1_FILIAL,,E1_TIPO)
            RecLock("TRB", .F.)
            //(lMarcado := IsMark("E1_OK", cMarca, lInverte))
            (lMarcado := oMark:IsMark(oMark:Mark()))
            If lMarcado //.Or. lInverte
                Replace E1_OK With Space(2)
                nAscan := AScan(aChaveLbn, TRB->RECSE1)
                If nAscan > 0
                    SE1->(MsrUnlock(TRB->RECSE1))
                    aDel(aChaveLbn,nAscan)
                    ASize(aChaveLbn,Len(aChaveLbn)-1) // Libera Lock
                EndIf
            Else
                If (nValor + (E1_SALDO-nAbat)) <= (nLimite) .Or. Empty(nLimite)
                    Replace E1_OK With oMark:Mark()  //cMarca
                    If AScan(aChaveLbn, TRB->RECSE1) == 0
                        AAdd(aChaveLbn,TRB->RECSE1)
                    EndIf
                EndIf
            EndIf
            MsUnLock()
            //If E1_OK == cMarca
   			if TRB->E1_OK == oMark:Mark()

                If TRB->E1_TIPO $ MVABATIM
                    nValor	-= E1_SALDO
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	-= (nData * E1_SALDO)
                Else
                    nValor	+= (E1_SALDO-nAbat)
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	+= (nData * (E1_SALDO-nAbat))
                EndIf
                nQtdTit++
                nSomaData += nData
                If nValor != 0
                    nPrazoMed := nPrazo / nValor
                Else
                    nPrazoMed := 0
                EndIf
            Elseif lMarcado
                If TRB->E1_TIPO $ MVABATIM
                    nValor	+= (E1_SALDO-nAbat)
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	+= (nData * E1_SALDO)
                Else
                    nValor	-= (E1_SALDO-nAbat)
                    nData := E1_VENCREA - E1_EMISSAO
                    nPrazo	-= (nData * (E1_SALDO-nAbat))
                EndIf
                nQtdTit--
                nSomaData -= nData
                If nValor != 0
                    nPrazoMed := nPrazo / nValor
                Else
                    nPrazoMed := 0
                EndIf
            EndIf
            nQtdTit:= IIf(nQtdTit<0,0,nQtdTit)
            nSomaData := IIf(nSomaData<0,0,nSomaData)
        EndIf
        If lTodos
            TRB->(DbSkip())
        Else
            Exit
        EndIf
    EndDo
    TRB->(DbGoTo(nReg))
    oValor:Refresh()
    oQtda:Refresh()
    If VALTYPE(oPrazoMed) == "O"
	    oPrazoMed:Refresh()
    EndIf
    //oMark:oBrowse:Refresh(.T.)
    oMark:Refresh(.T.)
    RestArea(aAreaSE1)

Return Nil

Static Function F060NotIN(lMarkAbt,lIntegra)

    Local cTipos := ""
    Default lIntegra := .F.

    If (cPaisLoc == "CHI")
        cTipos := 'RA /NCC/NDC/NF /FT /LTC'
    EndIf

    If !Empty(MVPROVIS) .Or. !Empty(MVRECANT) .Or. !Empty(MV_CRNEG) .Or. !Empty(MVENVBCOR)
        If !Empty(cTipos)
            cTipos += "/"
        EndIf

        cTipos += MVPROVIS+"/"+MVRECANT+"/"+MV_CRNEG+"/"+MVENVBCOR
    EndIf

    If !lMarkAbt
        If !Empty(cTipos)
            cTipos += "/"
        EndIf

        cTipos += MVABATIM+"/"+MVIRABT+"/"+MVCSABT+"/"+MVCFABT+"/"+MVPIABT
    EndIf

    cTipos := FINFormTp(cTipos)

Return cTipos


Static Function go060DbEva(nLimite,dVencIni,dVencFim,cAlias,aChaveLbn,lMarkAbt)

    Local nData 	 := 0
    Local nAbat 	 := 0
    Local cChaveLbn := ""
    Local bCond
    Local lRet	    := .T.

	bCond	:=	{|| (((nValor + E1_SALDO) <= (nLimite) .Or. Empty(nLimite)) .And.;
				E1_VENCREA >= dVencIni .And. E1_VENCREA <= dVencFim) }

    If Eval(bCond) //.And. MV_PAR11 == 1
        DbSelectArea("SA1")
        DbSeek(xFilial("SA1")+(cAlias)->E1_CLIENTE+(cAlias)->E1_LOJA)
        DbSelectArea(cAlias)
        //If !(FINTP01(.F., cAlias)) // Restringe o uso do programa Financeiro quando a origem do titulo for de origem Totvs Incorporação = FINTP01(.F.) == .T.
            //If (lConsBco .And. cPort060 $ (SA1->A1_BCO1+"/"+SA1->A1_BCO2+"/"+SA1->A1_BCO3+"/"+SA1->A1_BCO4+"/"+SA1->A1_BCO5)) .Or. (!lConsBco)
                cChaveLbn := "BOR" + (cAlias)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
                SE1->(DbGoTo((cAlias)->RECSE1))

                If SE1->(SimpleLock()) .And. lRet
                    Reclock(cAlias,.F.)
                    Replace (cAlias)->E1_OK With cMarca
                    MsUnlock()
                    //If !lMarkAbt .And. !lACAtivo
                        nAbat := SomaAbat(E1_PREFIXO,E1_NUM,E1_PARCELA,"R",E1_MOEDA,dDataBase,E1_CLIENTE,E1_LOJA,E1_FILIAL,,E1_TIPO)
                    //EndIf
                    If (cAlias)->E1_TIPO $ MVABATIM
                        nValor  -= E1_SALDO
                    Else
                        nValor  += (E1_SALDO - nAbat)
                        //Se considerar Acrescimos e Decrescimos
                        //If MV_PAR09 == 1
                        //    nValor += E1_SDACRES - E1_SDDECRE
                        //EndIf
                        //Calculo de Valor Acessorio
                        //If _lExistVA
                        //    nValor += FValAcess(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_NATUREZ, IIf(Empty(SE1->E1_BAIXA),.F.,.T.),"","R",SE1->E1_BAIXA)
                        //EndIf
                    EndIf
                    //If lF060DPM
                    //    nData := ExecBlock("F060DPM",.F.,.F.)
                    //Else
                        nData := E1_VENCREA - E1_EMISSAO
                    //EndIf
                    nPrazo	  += (nData * E1_SALDO)
                    nQtdTit++
                    nSomaData  += nData
                    If AScan(aChaveLbn, (cAlias)->RECSE1) == 0
                        AAdd(aChaveLbn,(cAlias)->RECSE1)
                    EndIf
                EndIf
            //EndIf
        //EndIf
    EndIf

Return

Static Function go060bAval(cMarca,oValor,oQtda,oPrazoMed,nLimite,lMarkAbt,aChaveLbn,lF060Mark)
    Local lRet 		:= .T.
    Local cChaveLbn
    Local aAreaSE1	:= SE1->(getArea())

    cChaveLbn := "BOR" + TRB->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
    // Verifica se o registro nao esta sendo utilizado em outro terminal
    //-- Parametros da Funcao LockByName() :
    //   1o - Nome da Trava
    //   2o - usa informacoes da Empresa na chave
    //   3o - usa informacoes da Filial na chave
    SE1->(DbGoTo(TRB->RECSE1))
    If SE1->(SimpleLock())
        If lRet
            FA060Inverte(cMarca,oValor,oQtda,oPrazoMed,nLimite,lMarkAbt,aChaveLbn,cChaveLbn, .F.,lF060Mark)
        EndIf
    Else
        IW_MsgBox("Este titulo está sendo utilizado em outro terminal, não pode ser utilizado neste Borderô","Atenção","STOP") //###
        lRet := .F.
    EndIf
    oMark:oBrowse:Refresh(.T.)
    RestArea(aAreaSE1)
Return lRet


User Function goOkTrans( lEndTra, nCarteira )

    Local aTit200   := {}
    Local pDtMov    := dDataBase
    Local pNaturez  := SubStr(&(GetMV("MV_NATDESC")),1,TamSX3('ED_CODIGO')[1])
    Local pHistori  := padr("Titulos para desconto", 40)
    Local pVlrTAC   := 0
    Local pVlrIOF   := 0
    Local pVlrJur   := 0
    Local lContinua := .T.
    Local nCntErr

    Private lMsErroAuto     := .F.
    Private lMSHelpAuto     := .T.
    Private lAutoErrNoFile  := .T.
    Private dDtMov      := ctod('')
    Private cNatu005    := ''
    Private cHist005    := ''
    Private nVlrTac     := 0
    Private nVlrIOF     := 0
    Private nVlrJur     := 0
    Private aParam		:= {}

    if nCarteira == 1
        IF PARAMBOX( {	{1,"Dt.Movimentacao", pDtMov,"@!",".T.","","",60,.T.},;
                    {1,"Natureza", pNaturez,"@!",".T.","SED","",80,.T.},;
                    {1,"Historico", pHistori,"@!",".T.","","",120,.T.},;
                    {1,"Vlr unico TAC", pVlrTAC,"@E 999,999,999.99",".T.","","",120,.F.},;
                    {1,"Vlr unico IOF", pVlrIOF,"@E 999,999,999.99",".T.","","",120,.F.},;
                    {1,"Vlr unico Juros", pVlrJur,"@E 999,999,999.99",".T.","","",120,.F.};
                    }, "Informe os dados p/Transferencia", @aParam,,,,,,,,.F.,.T.)

            dDtMov   := mv_par01
            cNatu005 := mv_par02
            cHist005 := mv_par03
            nVlrTac  := mv_par04
            nVlrIOF  := mv_par05
            nVlrJur  := mv_par06

            lContinua := .T.

        else
            lContinua := .F.
        Endif
    else

        IF PARAMBOX( {	{1,"Dt.Movimentacao", pDtMov,"@!",".T.","","",60,.T.};
                    }, "Informe os dados p/Transferencia", @aParam,,,,,,,,.F.,.T.)

            dDtMov   := mv_par01

            lContinua := .T.

        else
            lContinua := .F.
        Endif

    Endif

    if lContinua
        TRB->(dbGoTop())
        While !TRB->(eof())

            SE1->(DbGoTo(TRB->RECSE1))

            //If TRB->E1_OK == cMarca
            if TRB->E1_OK == oMark:Mark()

                aTit200   := {}
                lMsErroAuto     := .F.

                //Chave do título
                AAdd(aTit200, {"E1_PREFIXO",   SE1->E1_PREFIXO,   Nil})
                AAdd(aTit200, {"E1_NUM",       SE1->E1_NUM,       Nil})
                AAdd(aTit200, {"E1_PARCELA",   SE1->E1_PARCELA,   Nil})
                AAdd(aTit200, {"E1_TIPO",      SE1->E1_TIPO,      Nil})
            
                //Informações bancárias
                AAdd(aTit200, {"AUTDATAMOV",   dDtMov,   		Nil})	//Vem no arquivo de retorno
                AAdd(aTit200, {"AUTBANCO",     SE1->E1_PORTADO,	Nil})
                AAdd(aTit200, {"AUTAGENCIA",   SE1->E1_AGEDEP,		Nil})
                AAdd(aTit200, {"AUTCONTA",     SE1->E1_CONTA,		Nil})
                AAdd(aTit200, {"AUTSITUACA",   iif(nCarteira==1,'2','1'),				Nil})
                AAdd(aTit200, {"AUTNUMBCO",    SE1->E1_NUMBCO,		Nil})
                AAdd(aTit200, {"AUTGRVFI2",    .F.,				Nil})
            
                //Carteira descontada deve ser encaminhado o valor de crédito, desconto e IOF já calculados
                //If cSituaca $ "2|7"
                    //AAdd(aTit, {"AUTDESCONT",   nDescont,    Nil})
                    //AAdd(aTit, {"AUTCREDIT",    nValCrd,    Nil})
                    AAdd(aTit200, {"AUTCREDIT",    SE1->E1_SALDO,    Nil})
                    //AAdd(aTit, {"AUTIOF",       nValIOF,    Nil})
                //EndIf
                xDtMov := dDtMov
            
                MsExecAuto({|operacao, titulo| FINA060(operacao, titulo)}, 2, aTit200)

                If lMsErroAuto
                    aErroAuto := GetAutoGRLog()
                    
                    cErroRet := ''
                    For nCntErr := 1 To Len(aErroAuto)
                    	if !empty(AT('DADOSERR',aErroAuto[nCntErr]))
                            lMsErroAuto := .F.
                            Exit
                        endif
                        cErroRet += aErroAuto[nCntErr]
                    Next nCntErr
            
                    if !empty(cErroRet)
                        Alert(cErroRet)
                    endif
                    //MostraErro()
                
                endif

                If !lMsErroAuto

                    if nCarteira == 2 .and. !empty(TRB->E1_VALJUR)
                        SE1->(DbGoTo(TRB->RECSE1))

                        lMsErroAuto     := .F.
                        SED->(dbSetOrder(1))
                        SED->(msSeek(xFilial('SED') + padr('2.5.2.01',tamsx3('ED_CODIGO')[1])))
                        cHistor := alltrim(SED->ED_DESCRIC) + ' - ' + SE1->E1_NUM

                        aSE5 := {}
                        aAdd( aSE5, {"E5_DATA"    , xDtMov  , NIL} )
                        aAdd( aSE5, {"E5_DTDIGIT" , xDtMov  , NIL} )
                        aAdd( aSE5, {"E5_DTDISPO" , xDtMov  , NIL} )
                        aAdd( aSE5, {"E5_VALOR"   , TRB->E1_VALJUR    , NIL} )
                        aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                        aAdd( aSE5, {"E5_BANCO"   , SE1->E1_PORTADO    , NIL} )
                        aAdd( aSE5, {"E5_AGENCIA" , SE1->E1_AGEDEP  , NIL} )
                        aAdd( aSE5, {"E5_CONTA"   , SE1->E1_CONTA    , NIL} )
                        aAdd( aSE5, {"E5_NATUREZ" , '2.5.2.01' , NIL} )
                        aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                        MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                        If lMsErroAuto
                            aErroAuto := GetAutoGRLog()
                            
                            cErroRet := ''
                            For nCntErr := 1 To Len(aErroAuto)
                                cErroRet += aErroAuto[nCntErr]
                            Next nCntErr
                    
                            Alert(cErroRet)
                            //MostraErro()
                        EndIf
                    endif
                    
                EndIf

            endif

            TRB->(dbSkip())
        End
        if nCarteira == 1
            //Gera movimento bancario das taxas
            if !empty(nVlrTac)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('2.5.2.02',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrTac    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '2.5.2.02' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    aErroAuto := GetAutoGRLog()
                    
                    cErroRet := ''
                    For nCntErr := 1 To Len(aErroAuto)
                    	cErroRet += aErroAuto[nCntErr]
                    Next nCntErr
            
                    Alert(cErroRet)
                    //MostraErro()
                EndIf

            endif
            if !empty(nVlrIof)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('2.5.2.03',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrIof    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '2.5.2.03' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    aErroAuto := GetAutoGRLog()
                    
                    cErroRet := ''
                    For nCntErr := 1 To Len(aErroAuto)
                    	cErroRet += aErroAuto[nCntErr]
                    Next nCntErr
            
                    Alert(cErroRet)
                    //MostraErro()
                EndIf

            endif
            if !empty(nVlrJur)
                lMsErroAuto     := .F.
                SA6->(dbSetOrder(1))
                SA6->(msSeek(xFilial('SA6') + cBanco, .T.))
                SED->(dbSetOrder(1))
                SED->(msSeek(xFilial('SED') + padr('2.5.2.01',tamsx3('ED_CODIGO')[1])))
                cHistor := alltrim(SED->ED_DESCRIC)
                aSE5 := {}
                aAdd( aSE5, {"E5_DATA"    , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDIGIT" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_DTDISPO" , xDtMov  , NIL} )
                aAdd( aSE5, {"E5_VALOR"   , nVlrJur    , NIL} )
                aAdd( aSE5, {"E5_MOEDA"   , "M1"       , NIL} )
                aAdd( aSE5, {"E5_BANCO"   , SA6->A6_COD    , NIL} )
                aAdd( aSE5, {"E5_AGENCIA" , SA6->A6_AGENCIA  , NIL} )
                aAdd( aSE5, {"E5_CONTA"   , SA6->A6_NUMCON    , NIL} )
                aAdd( aSE5, {"E5_NATUREZ" , '2.5.2.01' , NIL} )
                aAdd( aSE5, {"E5_HISTOR"  , cHistor   , NIL} )

                MsExecAuto( {|w,x, y| FINA100(w, x, y)}, 0, aSE5, 3 ) //Incluir movimento a pagar

                If lMsErroAuto
                    aErroAuto := GetAutoGRLog()
                    
                    cErroRet := ''
                    For nCntErr := 1 To Len(aErroAuto)
                    	cErroRet += aErroAuto[nCntErr]
                    Next nCntErr
            
                    Alert(cErroRet)
                    //MostraErro()
                EndIf

            endif
        endif


    else
        Alert('Processo Abortado.')
    endif

Return( lEndTra := .T. )

User Function goOkBaixa( lEndTra )

    Local aTit200   := {}
    //Local pNaturez  := SubStr(&(GetMV("MV_NATDESC")),1,TamSX3('ED_CODIGO')[1])
    Local pDtMov    := dDataBase
    Local pCdBco    := padR('',tamSx3('E1_PORTADO')[1])
    Local pCdAge    := padR('',tamSx3('E1_AGEDEP')[1])
    Local pCdCta    := padR('',tamSx3('E1_CONTA')[1])
    Local pHistori  := padr("", 40)
    Local lContinua := .T.
    Local nCntErr

    Private lMsErroAuto     := .F.
    //Private cNatu005    := ''
    Private dDtMov      := ctod('')
    Private cCdBco      := ''
    Private cCdAge      := ''
    Private cCdCta      := ''
    Private cHist005    := ''
    Private aParam		:= {}

    if !empty(cBanco)
        IF PARAMBOX( {	{1,"Dt.Movimentacao", pDtMov,"@!",".T.","","",60,.T.},;
                        {1,"Historico", pHistori,"@!",".T.","","",120,.T.};
                    }, "Informe os dados p/Baixa", @aParam,,,,,,,,.F.,.T.)

            //cNatu005 := mv_par01
            dDtMov   := mv_par01
            cHist005 := mv_par02
            lContinua := .T.

        else
            lContinua := .F.
        Endif
    else
        IF PARAMBOX( {	{1,"Dt.Movimentacao", pDtMov,"@!",".T.","","",60,.T.},;
                        {1,"Banco", pCdBco,"@!",".T.","SA6","",80,.T.},;
                        {1,"Agencia", pCdAge,"@!",".T.","","",80,.T.},;
                        {1,"Conta", pCdCta,"@!",".T.","","",80,.T.},;
                        {1,"Historico", pHistori,"@!",".T.","","",120,.T.};
                    }, "Informe os dados p/Baixa", @aParam,,,,,,,,.F.,.T.)

            //cNatu005 := mv_par01
            dDtMov      := mv_par01
            cCdBco      := mv_par02
            cCdAge      := mv_par03
            cCdCta      := mv_par04
            cHist005    := mv_par05
            lContinua := .T.
        else
            lContinua := .F.
        Endif
    endif

    if lContinua
        TRB->(dbGoTop())
        While !TRB->(eof())

            SE1->(DbGoTo(TRB->RECSE1))

            //If TRB->E1_OK == cMarca
            if TRB->E1_OK == oMark:Mark()
                lMsErroAuto     := .F.

			    SA6->(dbSetOrder(1))
                if !empty(cBanco)
                    SA6->(msSeek(xFilial('SA6') + SE1->E1_PORTADO + SE1->E1_AGEDEP + SE1->E1_CONTA))
                else
                    SA6->(msSeek(xFilial('SA6') + cCdBco + cCdAge + cCdCta))
                endif

                aTit200 :={{"E1_FILIAL"	,SE1->E1_FILIAL				,Nil},;
			    			{"E1_PREFIXO"	,SE1->E1_PREFIXO			,Nil},;
			    			{"E1_NUM"		,SE1->E1_NUM				,Nil},;
			    			{"E1_PARCELA"	,SE1->E1_PARCELA			,Nil},;
			    			{"E1_TIPO"		,SE1->E1_TIPO				,Nil},;
			    			{"E1_CLIENTE"	,SE1->E1_CLIENTE			,Nil},;
			    			{"E1_LOJA"		,SE1->E1_LOJA				,Nil},;
			    			{"AUTMOTBX"		,"NOR"						,Nil},;
			    			{"AUTBANCO"		,SA6->A6_COD			    ,Nil},;
			    			{"AUTAGENCIA"	,SA6->A6_AGENCIA 			,Nil},;
			    			{"AUTCONTA"		,SA6->A6_NUMCON				,Nil},;
			    			{"AUTDTBAIXA"	,dDtMov 					,Nil},;
			    			{"AUTDTCREDITO"	,dDtMov 					,Nil},;
			    			{"AUTHIST"		,cHist005					,Nil},;
			    			{"AUTDESCONT"	,0                  		,Nil},;
			    			{"AUTMULTA"		,0							,Nil},;
			    			{"AUTJUROS"		,TRB->E1_VALJUR        		,Nil},;
			    			{"AUTDECRESC"	,0							,Nil},;
			    			{"AUTACRESC"	,0							,Nil},;
			    			{"AUTVALREC"	,SE1->E1_SALDO + TRB->E1_VALJUR	,Nil},;
			    			{"AUTTXMOEDA"	,1							,Nil}}

			    MSExecAuto({|x,y|FINA070(x,y)},aTit200,3)
                
                If lMsErroAuto
                    aErroAuto := GetAutoGRLog()
                    
                    cErroRet := ''
                    For nCntErr := 1 To Len(aErroAuto)
                    	cErroRet += aErroAuto[nCntErr]
                    Next nCntErr
            
                    Alert(cErroRet)
                    //Conout(cErroRet)
                    //MostraErro()
                EndIf

            endif

            TRB->(dbSkip())
        End
    
    else
        Alert('Processo Abortado.')
    endif

Return( lEndTra := .T. )

