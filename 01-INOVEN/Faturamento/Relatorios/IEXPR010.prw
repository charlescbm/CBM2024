#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPRINTSETUP.CH"

Static nMaxPag    := 800

//-------------------------------------------------------------------
/*/{Protheus.doc} IEXPR010
Impressão do Romaneio
@author  Victor Andrade
@since   23/04/2018
@version 1
/*/
//-------------------------------------------------------------------
//DESENVOLVIDO POR INOVEN

User Function IEXPR010()

Local nFlags        := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN // indica quais opcoes estarao disponiveis
Local cFilePrint    := "ROMANEIO_" + DtoS(MSDate()) + StrTran(Time(),":","")
Local cPerg         := PadR( "TFATR002", 10 )
Local lPerg         := .T.

Private oFWPrint    := Nil
Private oFont       := TFont():New("Courier New",0,-8,,.T.,,,,,)
Private oFont1      := TFont():New('Arial',,-25,,.T.)
Private oFont2      := TFont():New('Arial',,-12,,.T.)
Private oFont3      := TFont():New('Arial',,-8,,.T.)
Private oFont4      := TFont():New('Arial',,-10,,.F.)
Private oFont5      := TFont():New('Arial',,-12,,.F.)
Private oFont6      := TFont():New('Arial',,-14,,.T.)
Private cNextAlias  := GetNextAlias()

U_ITECX010("IEXPR010","Impressão do Romaneio")//Grava detalhes da rotina usada

//Default nRecno := 0

CriaSX1( cPerg )

/*
If nRecno <> 0
    Pergunte( cPerg, .F. )

    DbSelectArea( "ZZE" )
    ZZE->( DbGoTo( nRecno ) )
    mv_par01 := ZZE->ZZE_DTENTR
    mv_par02 := ZZE->ZZE_DTENTR
    mv_par03 := ZZE->ZZE_CODIGO
    mv_par04 := ZZE->ZZE_CODIGO
    mv_par05 := ZZE->ZZE_CODCLI
    mv_par06 := ZZE->ZZE_LOJA
    mv_par07 := ZZE->ZZE_CODCLI
    mv_par08 := ZZE->ZZE_LOJA
Else
    lPerg := Pergunte( cPerg, .T. )
EndIf
*/

lPerg := Pergunte( cPerg, .T. )

If lPerg

    oSetup := FWPrintSetup():New(nFlags, "ROMANEIO")

    oSetup:SetPropert(PD_PRINTTYPE   , 6)
    oSetup:SetPropert(PD_ORIENTATION , 2)
    oSetup:SetPropert(PD_DESTINATION , 2)
    oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
    oSetup:SetPropert(PD_PAPERSIZE   , 2)
    oSetup:cQtdCopia := "01"

    oFWPrint := FWMSPrinter():New(cFilePrint, IMP_PDF, .F. /*lAdjustToLegacy*/, /*cPathInServer*/, .T.)
    oFWPrint:SetCopies( Val(oSetup:cQtdCopia) )

    If oSetup:Activate()

        oFWPrint:lServer := oSetup:GetProperty(PD_DESTINATION) == AMB_SERVER
        oFWPrint:SetDevice(oSetup:GetProperty(PD_PRINTTYPE))
        oFWPrint:SetPortrait()
        oFWPrint:setCopies( Val( oSetup:cQtdCopia ) )
                
        If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
            oFWPrint:nDevice := IMP_SPOOL
            oFWPrint:cPrinter := oSetup:aOptions[PD_VALUETYPE]
        Else 
            oFWPrint:nDevice := IMP_PDF
            oFWPrint:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
            oFWPrint:SetViewPDF(.T.)
        EndIf

        TR002Proc()

    EndIf

EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TR002Print
Efetua a impressão dos dados 
@author  Victor Andrade
@since   23/04/2018
@version version
/*/
//-------------------------------------------------------------------
Static Function TR002Proc()

If TR002Query()

    // Impressão dos dados
    FWMsgRun(, {|| TR002Print() }, "Aguarde...", "Gerando Relatório")

Else
    MsgAlert( "Não há dados com os parâmetros informados." )
EndIf

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TR002Query
Realiza a Query
@author  Victor Andrade
@since   23/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TR002Query()

Local lRet  := .T.
Local aArea := GetArea()

If Select( cNextAlias ) > 0
    (cNextAlias)->( DbCloseArea() )
EndIf

BeginSQL Alias cNextAlias
    SELECT 
    	ZZE.ZZE_CODIGO, 
    	ZZE.ZZE_NOTA, 
    	ZZE.ZZE_SERIE,
    	ZZE.ZZE_CODCLI,
    	ZZE.ZZE_LOJA,
    	ZZE.ZZE_NOMCLI, 
    	ZZE.ZZE_VLFNF, 
    	ZZE.ZZE_DTENTR,
    	ZZE.ZZE_STATUS, 
    	SA1.A1_MUN, 
    	SA1.A1_EST, 
    	SA1.A1_XAGENDA, 
    	SA4.A4_COD,
        SA4.A4_NOME,
        SA4.A4_EMAIL,
        SA1.A1_NOME,
        SA1.A1_EMAIL 
    FROM %table:ZZE% ZZE
    INNER JOIN %table:SA1% SA1
    ON A1_COD = ZZE_CODCLI AND A1_LOJA = ZZE_LOJA AND SA1.%notdel%
    INNER JOIN %table:ZZD% ZZD
    ON ZZD.ZZD_FILIAL = %xFilial:ZZD% AND ZZD.ZZD_CODIGO = ZZE.ZZE_CODIGO AND ZZD.%notdel%
    INNER JOIN %table:SA4% SA4
    ON SA4.A4_FILIAL = %xFilial:SA4% AND SA4.A4_COD = ZZD.ZZD_TRANSP AND SA4.%notdel%
    WHERE   ZZE_DTENTR BETWEEN %exp:mv_par01% AND %exp:mv_par02%
    AND     ZZE_CODIGO BETWEEN %exp:mv_par03% AND %exp:mv_par04%
    AND     ZZE_CODCLI BETWEEN %exp:mv_par05% AND %exp:mv_par07%
    AND     ZZE_LOJA BETWEEN %exp:mv_par06% AND %exp:mv_par08%
    AND     ZZE.%notdel%
    AND     ZZE.ZZE_FILIAL = %xFilial:ZZE%
    order by ZZE_CODIGO, ZZE_NOTA
EndSQL

(cNextAlias)->( DbGoTop() )

If (cNextAlias)->( Eof() )
    lRet := .F.
EndIf

RestArea( aArea )

Return( lRet )

//-------------------------------------------------------------------
/*/{Protheus.doc} TR002Print
Realliza a impressão dos dados
@author  Victor Andrade
@since   23/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TR002Print()

Local nPag       := 1
Local nSeq       := 1
Local nRow       := 80
Local nTotNF     := 0
Local nTotCx     := 0
Local nTotPeso   := 0
Local nTotM3     := 0
Local nTotFrete  := 0
Local cRomaneio  := ""
Local nTotAge    := 0

cRomaneio := (cNextAlias)->ZZE_CODIGO
cMail     := iif((cNextAlias)->A4_COD <> "900000", (cNextAlias)->A4_EMAIL, (cNextAlias)->A1_EMAIL)

TR002Cabec( nPag, cRomaneio )

//abre WF
if mv_par09 == 1
    Private	oProcess
    Private oHTML
    goOpenWF(cRomaneio)
ENDIF

While (cNextAlias)->( !Eof() )

    // Verifica necessidade de quebra de página
    If cRomaneio == (cNextAlias)->ZZE_CODIGO
        If nRow > nMaxPag
            oFWPrint:EndPage()
            TR002Cabec( nPag, cRomaneio )
            nRow := 80
            nPag ++
        EndIf
    Else
        TR002Footer(nTotNF, nTotCx, nTotPeso, nTotM3, nTotFrete, nRow, nTotAge )

        if mv_par09 == 1
            oProcess:cTo := cMail
            //oProcess:cTo := "crelec@gmail.com"
            //oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
                    
            // Inicia o processo
            oProcess:Start()
            // Finaliza o processo
            oProcess:Finish()					
        ENDIF

        cRomaneio := (cNextAlias)->ZZE_CODIGO
        cMail     := (cNextAlias)->A4_EMAIL

        if mv_par09 == 1
            //abre WF
            goOpenWF(cRomaneio)
        endif

        TR002Cabec( nPag, cRomaneio )
        nTotNF      := 0
        nTotCx      := 0
        nTotPeso    := 0
        nTotM3      := 0
        nTotFrete   := 0
        nRow        := 80
        nTotAge     := 0
        nSeq        := 1
        nPag ++
    EndIf
    
    //-----------------------------+
    // Retornar os totais por nota |
    //-----------------------------+
    nTotCxNf	:= 0
    nTotPesoNf	:= 0
    nTotM3Nf	:= 0
    nFreteNf	:= 0
    TR002Totais( (cNextAlias)->ZZE_NOTA,(cNextAlias)->ZZE_SERIE,(cNextAlias)->ZZE_CODCLI,(cNextAlias)->ZZE_LOJA,@nTotCxNf, @nTotPesoNf, @nTotM3Nf, @nFreteNf)
    
    oFWPrint:Say( nRow, 015, cValToChar( nSeq ) , oFont )
    oFWPrint:Say( nRow, 031, Iif( (cNextAlias)->A1_XAGENDA == "1", "*", "" ) , oFont )
    oFWPrint:Say( nRow, 035, (cNextAlias)->ZZE_NOTA , oFont )
    oFWPrint:Say( nRow, 90 , 'TP' , oFont )
    oFWPrint:Say( nRow, 120, DTOC(STOD((cNextAlias)->ZZE_DTENTR)) , oFont )
    oFWPrint:Say( nRow, 170, SubStr((cNextAlias)->ZZE_NOMCLI,1,20) , oFont )
    oFWPrint:Say( nRow, 280, AllTrim(TransForm( (cNextAlias)->ZZE_VLFNF, PesqPict( "ZZE", "ZZE_VLFNF" ) ) ) , oFont )
    oFWPrint:Say( nRow, 335, AllTrim(TransForm( nTotCxNf, PesqPict( "SD2", "D2_QUANT" ) ) ) , oFont )
    oFWPrint:Say( nRow, 370, AllTrim(TransForm( nTotPesoNf, PesqPict( "SD2", "D2_PESO" ) ) ) , oFont )
    oFWPrint:Say( nRow, 414, AllTrim(TransForm( nTotM3Nf, PesqPict( "SB5", "B5_COMPR" ) ) ) , oFont )
    oFWPrint:Say( nRow, 448, AllTrim(TransForm( nFreteNf, PesqPict( "SD2", "D2_TOTAL" ) ) ) , oFont )
    oFWPrint:Say( nRow, 470, AllTrim( (cNextAlias)->A1_MUN ) + "/" + AllTrim( (cNextAlias)->A1_EST ) , oFont )
    oFWPrint:Say( nRow, 565, Iif( (cNextAlias)->ZZE_STATUS == "3", "X", "" )						 , oFont )

    if mv_par09 == 1
        AAdd(oProcess:oHtml:ValByName('nf.seq')	, cValToChar( nSeq ))
        AAdd(oProcess:oHtml:ValByName('nf.doc')	, (cNextAlias)->ZZE_NOTA)
        AAdd(oProcess:oHtml:ValByName('nf.tipo')	, 'TP')
        AAdd(oProcess:oHtml:ValByName('nf.emissao')	, DTOC(STOD((cNextAlias)->ZZE_DTENTR)))
        AAdd(oProcess:oHtml:ValByName('nf.cliente')	, SubStr((cNextAlias)->ZZE_NOMCLI,1,20))
        AAdd(oProcess:oHtml:ValByName('nf.valor')	, AllTrim(TransForm( (cNextAlias)->ZZE_VLFNF, PesqPict( "ZZE", "ZZE_VLFNF" ) ) ))
        AAdd(oProcess:oHtml:ValByName('nf.caixa')	, AllTrim(TransForm( nTotCxNf, PesqPict( "SD2", "D2_QUANT" ) ) ))
        AAdd(oProcess:oHtml:ValByName('nf.peso')	, AllTrim(TransForm( nTotPesoNf, PesqPict( "SD2", "D2_PESO" ) ) ))
        AAdd(oProcess:oHtml:ValByName('nf.m3')	, AllTrim(TransForm( nTotM3Nf, PesqPict( "SB5", "B5_COMPR" ) ) ))
        AAdd(oProcess:oHtml:ValByName('nf.frete')	, AllTrim(TransForm( nFreteNf, PesqPict( "SD2", "D2_TOTAL" ) ) ))
        AAdd(oProcess:oHtml:ValByName('nf.cidade')	, AllTrim( (cNextAlias)->A1_MUN ) + "/" + AllTrim( (cNextAlias)->A1_EST ))
        //AAdd(oProcess:oHtml:ValByName('nf.conf')	, Iif( (cNextAlias)->ZZE_STATUS == "3", "X", "" ))
    endif

    nTotNF      += (cNextAlias)->ZZE_VLFNF
    nTotCx      += nTotCxNf
    nTotPeso    += nTotPesoNf
    nTotM3      += nTotM3Nf
    nTotFrete   += nFreteNf
    nTotAge     += Iif( (cNextAlias)->A1_XAGENDA == "1", 1, 0 )

    nRow += 10
    nSeq ++
    (cNextAlias)->( DbSkip() )

EndDo

TR002Footer( nTotNF, nTotCx, nTotPeso, nTotM3, nTotFrete, nRow, nTotAge )

oFWPrint:EndPage()
oFWPrint:Preview()

if mv_par09 == 1
    oProcess:cTo := cMail
    //oProcess:cTo := "crelec@gmail.com"
    //oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
            
    // Inicia o processo
    oProcess:Start()
    // Finaliza o processo
    oProcess:Finish()					
ENDIF

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TR002Cabec
Impressão do cabeçalho
@author  Victor Andrade
@since   23/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TR002Cabec( nPag, cRomaneio )
	
oFWPrint:StartPage()

oFWPrint:SayBitMap( 03, 02, "\lgmid.bmp", 100, 50)

oFWPrint:Box( 05, 170, 55, 590, "-6")

oFWPrint:Say( 28, 180, "Romaneio"	        						, oFont6 )
oFWPrint:Say( 28, 240, cRomaneio	        						, oFont6 )
if (cNextAlias)->A4_COD <> "900000"
    oFWPrint:Say( 28, 335, "( " + Alltrim((cNextAlias)->A4_NOME) + " )"	, oFont6 )
else
    oFWPrint:Say( 28, 335, "( " + Alltrim((cNextAlias)->A1_NOME) + " )"	, oFont6 )
endif
oFWPrint:Say( 45, 560, cValToChar( nPag )							, oFont2 )

oFWPrint:Say( 45, 180, "Motorista"	        						, oFont2 )

oFWPrint:Line( 70, 5, 70, 590 )

oFWPrint:Say( 65, 013, "Seq"	    	, oFont3 )
oFWPrint:Say( 65, 035, "Num. NF"		, oFont3 )
oFWPrint:Say( 65, 90 , "Tp"	        	, oFont3 )
oFWPrint:Say( 65, 120, "Data NF"		, oFont3 )
oFWPrint:Say( 65, 170, "Cliente"		, oFont3 )
oFWPrint:Say( 65, 280, "Valor NF"		, oFont3 )
oFWPrint:Say( 65, 335, "Cxs"	    	, oFont3 )
oFWPrint:Say( 65, 370, "Peso"	    	, oFont3 )
oFWPrint:Say( 65, 415, "m3" 	    	, oFont3 )
oFWPrint:Say( 65, 445, "Frete"	    	, oFont3 )
oFWPrint:Say( 65, 470, "Cidade"	    	, oFont3 )
oFWPrint:Say( 65, 550, "Conferido"		, oFont3 )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} TR002Footer
Impressão do footer do relatório
@author  Victor Andrade
@since   24/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function TR002Footer( nTotNF, nTotCx, nTotPeso, nTotM3, nTotFrete, nRow, nTotAge )

Local nLinha := nRow

//---------------------------+
// Verifica quebra de página |
//---------------------------+    
If nLinha >= 470
    oFWPrint:EndPage()
    oFWPrint:StartPage()
    nLinha := 28

    oFWPrint:Say( nLinha, 240, "Total"	, oFont3 )
    oFWPrint:Say( nLinha, 264, TransForm( nTotNF    , PesqPict("ZZE", "ZZE_VLFNF") )	, oFont3 )    
    oFWPrint:Say( nLinha, 324, TransForm( nTotCx    , PesqPict("SD2", "D2_QUANT") )	    , oFont3 )
    oFWPrint:Say( nLinha, 367, TransForm( nTotPeso  , PesqPict("SD2", "D2_PESO") )	    , oFont3 )
    oFWPrint:Say( nLinha, 405, TransForm( nTotM3    , PesqPict("SB5", "B5_COMPR") ) 	, oFont3 )
    oFWPrint:Say( nLinha, 422, TransForm( nTotFrete , PesqPict("SD2", "D2_TOTAL") )	    , oFont3 )

Else

    oFWPrint:Say( nLinha, 240, "--------------------------------------------------------"   , oFont )
    
    nLinha += 7
    oFWPrint:Say( nLinha, 240, "Total"	, oFont3 )
    oFWPrint:Say( nLinha, 264, TransForm( nTotNF    , PesqPict("ZZE", "ZZE_VLFNF") )	, oFont3 )    
    oFWPrint:Say( nLinha, 324, TransForm( nTotCx    , PesqPict("SD2", "D2_QUANT") )	    , oFont3 )
    oFWPrint:Say( nLinha, 367, TransForm( nTotPeso  , PesqPict("SD2", "D2_PESO") )	    , oFont3 )
    oFWPrint:Say( nLinha, 405, TransForm( nTotM3    , PesqPict("SB5", "B5_COMPR") ) 	, oFont3 )
    oFWPrint:Say( nLinha, 422, TransForm( nTotFrete , PesqPict("SD2", "D2_TOTAL") )	    , oFont3 )
    
    nLinha += 3

    oFWPrint:Line( nLinha, 5, nLinha, 590 )
EndIf

nLinha += 15
oFWPrint:Say( nLinha, 010, "Controle"    , oFont )
oFWPrint:Say( nLinha, 055, "Chegada:"    , oFont )
oFWPrint:Say( nLinha, 100, "Data ____/____/____"    , oFont )
oFWPrint:Say( nLinha, 195, "Hora ____:____"    , oFont )

nLinha += 15
oFWPrint:Say( nLinha, 010, "Saída:"    , oFont )
oFWPrint:Say( nLinha, 055, "Data ___/___/___"    , oFont )
oFWPrint:Say( nLinha, 150, "Hora ___:___"    , oFont )

nLinha += 15
oFWPrint:Say( nLinha, 055, "Motorista: _______________________________________"    , oFont )
oFWPrint:Say( nLinha, 290, "CNH: _________________________"    , oFont )

nLinha += 15
oFWPrint:Say( nLinha, 055, "Conferênte: _______________________________________"    , oFont )
oFWPrint:Say( nLinha, 290, "Placa: ____________ "    , oFont )

nLinha += 15
oFWPrint:Say( nLinha, 010, "*= Agendar"    , oFont )
oFWPrint:Say( nLinha, 058, TransForm(nTotAge, '@E 9999' )   , oFont3 )

nLinha += 15
oFWPrint:Box( nLinha, 025, nLinha + 15, 480, "-6")
oFWPrint:Box( nLinha, 480, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 180, "CHECK-LIST DE EXPEDIÇÃO"    , oFont2 )
oFWPrint:Say( nLinha, 485, "Revisão "    , oFont2 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Conferente responsável: "    , oFont2 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 145, "ITENS A SEREM VERIFICADOS (MARCAR COM UM X)", oFont2 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "1. AVALIAÇÃO DOS PRODUTOS", oFont2 )
oFWPrint:Say( nLinha, 305, "SIM", oFont2 )
oFWPrint:Say( nLinha, 355, "NÃO", oFont2 )
oFWPrint:Say( nLinha, 430, "OBSERVAÇÃO", oFont2 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "A quantidade de materiais está de acordo com o descrito na NF?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Todas as caixas estão etiquetadas?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "As caixas estão totalmente íntegras?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "As caixas estão devidamente lacradas?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Pallets expedidos?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 40, 560, "-6")

nLinha += 12
oFWPrint:Say( nLinha, 030, "Quantidade de pallets expedidos:", oFont5 )

nLinha += 15
oFWPrint:Say( nLinha, 030, "Pallets devolvidos? (   ) Sim    (   ) Não", oFont5 )
oFWPrint:Say( nLinha, 310, "Quantidade de pallets devolvidos:", oFont5 )

nLinha += 10
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "2. AVALIAÇÃO DO VEÍCULO", oFont2 )
oFWPrint:Say( nLinha, 305, "SIM", oFont2 )
oFWPrint:Say( nLinha, 355, "NÃO", oFont2 )
oFWPrint:Say( nLinha, 430, "OBSERVAÇÃO", oFont2 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Veículo em bom estado de conservação?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Livre de odores estranhos, mofo ou umidade?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Livre de produtos químicos, tóxicos ou outros?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Livre de pragas e seus vestígios?", oFont4 )

nLinha += 3
oFWPrint:Box( nLinha, 025, nLinha + 15, 300, "-6")
oFWPrint:Box( nLinha, 300, nLinha + 15, 350, "-6")
oFWPrint:Box( nLinha, 350, nLinha + 15, 400, "-6")
oFWPrint:Box( nLinha, 400, nLinha + 15, 560, "-6")

nLinha += 11
oFWPrint:Say( nLinha, 030, "Livre de sujidades, como poeira, farpas de madeira ou outros?", oFont4 )



Return

/******************************************************************************************/
/*/{Protheus.doc} TR002Totais

@description Calcula os totais 

@author Bernard M. Margarido
@since 01/08/2018
@version 1.0

@param nTotNF		, numeric, descricao
@param nTotCx		, numeric, descricao
@param nTotPeso		, numeric, descricao
@param nTotM3		, numeric, descricao
@param nTotFrete	, numeric, descricao
@type function
/*/
/******************************************************************************************/
Static Function TR002Totais(cDoc, cSerie, cCodLoja, cLoja, nTotCxNf, nTotPesoNf, nTotM3Nf, nFreteNf)
Local aArea	:= GetArea()

//----------------+
// Posiciona Nota |
//----------------+
dbSelectArea("SF2")
SF2->( dbSetOrder(1) ) 
SF2->( dbSeek(xFilial("SF2") + cDoc + cSerie + cCodLoja + cLoja) )
nTotCxNf 	:= SF2->F2_VOLUME1
nTotPesoNf	:= SF2->F2_PLIQUI
nFreteNf	:= SF2->F2_FRETE

//----------------------------------+
// Posiciona complemento de produto |
//----------------------------------+
dbSelectArea("SB5")
SB5->( dbSetOrder(1) )

//------------------+
// Calula a Cubagem | 
//------------------+
/*
dbSelectArea("SD2")
SD2->( dbSetOrder(3) )
SD2->( dbSeek(xFilial("SD2") + cDoc + cSerie + cCodLoja + cLoja) )
While SD2->( !Eof() .And. xFilial("SD2") + cDoc + cSerie + cCodLoja + cLoja == SD2->( D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA) )
    SB1->(dbSetOrder(1))
    SB1->(msSeek(xFilial('SB1') + SD2->D2_COD))
	nCalcCub:= Round(SD2->D2_QUANT * SB1->B1_XALTURA * SB1->B1_XLARG * SB1->B1_XCOMPR,4)   	

	nTotM3Nf 	+= nCalcCub 

	SD2->( dbSkip() )
EndDo
*/
nTotM3Nf := SF2->F2_ZCUBA

RestArea(aArea)
Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} CriaSX1
Cria o grupo de perguntas no SX1
@author  Victor Andrade
@since   23/04/2018
@version 1
/*/
//-------------------------------------------------------------------
Static Function CriaSX1( cPerg )

Local aPerg := {}
Local i		:= 0
Local aArea := GetArea()

SX1->( DbSetOrder(1) )

aAdd(aPerg, {cPerg, "01", "Data Inicial:"   , "MV_CH1" , "D", 08, 0, "G", "MV_PAR01", "","",""	,"",""})
aAdd(aPerg, {cPerg, "02", "Data Final:"     , "MV_CH2" , "D", 08, 0, "G", "MV_PAR02", "","",""	,"",""})
aAdd(aPerg, {cPerg, "03", "Romaneio De:"    , "MV_CH3" , "C", TamSX3("ZZE_CODIGO")[1], 0, "G", "MV_PAR03", "","",""	,"",""})
aAdd(aPerg, {cPerg, "04", "Romaneio Até:"   , "MV_CH4" , "C", TamSX3("ZZE_CODIGO")[1], 0, "G", "MV_PAR04", "","",""	,"",""})
aAdd(aPerg, {cPerg, "05", "Cliente De:"     , "MV_CH5" , "C", TamSX3("A1_COD")[1], 0, "G", "MV_PAR05", "SA1","",""	,"",""})
aAdd(aPerg, {cPerg, "06", "Loja De:"        , "MV_CH6" , "C", TamSX3("A1_LOJA")[1], 0, "G", "MV_PAR06", "","",""	,"",""})
aAdd(aPerg, {cPerg, "07", "Cliente Até:"    , "MV_CH7" , "C", TamSX3("A1_COD")[1], 0, "G", "MV_PAR07", "SA1","",""	,"",""})
aAdd(aPerg, {cPerg, "08", "Loja Até:"       , "MV_CH8" , "C", TamSX3("A1_LOJA")[1], 0, "G", "MV_PAR08", "","",""	,"",""})

For i := 1 To Len(aPerg)
	
	If  !SX1->( DbSeek(aPerg[i,1]+aPerg[i,2]) )		
		RecLock("SX1",.T.)
	Else
		RecLock("SX1",.F.)
	EndIf
	
	Replace X1_GRUPO   with aPerg[i,01]
	Replace X1_ORDEM   with aPerg[i,02]
	Replace X1_PERGUNT with aPerg[i,03]
	Replace X1_VARIAVL with aPerg[i,04]
	Replace X1_TIPO	   with aPerg[i,05]
	Replace X1_TAMANHO with aPerg[i,06]
	Replace X1_PRESEL  with aPerg[i,07]
	Replace X1_GSC	   with aPerg[i,08]
	Replace X1_VAR01   with aPerg[i,09]
	Replace X1_F3	   with aPerg[i,10]
	Replace X1_DEF01   with aPerg[i,11]
	Replace X1_DEF02   with aPerg[i,12]
	Replace X1_DEF03   with aPerg[i,13]
	Replace X1_DEF04   with aPerg[i,14]
	
	SX1->( MsUnlock() )
	
Next i

RestArea( aArea )

Return

Static Function goOpenWF(cRomaneio)

	oProcess := TWFProcess():New("000001", OemToAnsi("Relacao de Notas Romaneio: " + cRomaneio))
	oProcess:NewTask("000001", "\workflow\notas_romaneio.htm")
	
	oProcess:cSubject 	:= "Relacao de Notas Romaneio: " + cRomaneio + " em " + dtoc(dDatabase)
	oProcess:bTimeOut	:= {}
	oProcess:fDesc 		:= "Relacao de Notas Romaneio: " + cRomaneio + " em " + dtoc(dDatabase)
	oProcess:ClientName(cUserName)
	oHTML := oProcess:oHTML

	oHTML:ValByName('numrom', cRomaneio)
	oHTML:ValByName('dtbase', dDataBase)

Return
