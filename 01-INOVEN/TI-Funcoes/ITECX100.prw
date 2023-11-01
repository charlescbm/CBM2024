#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX100													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio do saldo dos produtos			 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 19/07/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX100( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SB1","SB2"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Saldo de Produtos - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC100()

RpcClearEnv()

Return

User Function WFTEC100()

//Local cDirClient	:= GetTempPath()

Private cFile := "itecx100_"+DTOS(dDataBase)+Replace(Time(),':','')

If File("\workflow\estoque_prd.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"
		SELECT B1_GRUPO, B2_COD, B1_DESC,B1_UM,SUM((B2_QATU - B2_QEMP - B2_RESERVA)) SALDO 
		FROM %table:SB2% B2
		INNER JOIN %table:SB1% B1 ON B1_COD = B2_COD
		WHERE B2.%notdel% AND B1.%notdel%
		AND B2_LOCAL IN ('01','03')
		AND B1_MSBLQL = '2' AND B1_TIPO = 'ME'
		GROUP BY B1_GRUPO, B2_COD, B1_DESC,B1_UM
		ORDER BY B1_GRUPO, B2_COD
	ENDSQL

	//Impressao em PDF
	//goImpPDF()

	//Copiar o PDF para uma pasta do servidor
	//if CpyT2S( cDirClient+"totvsprinter\"+cFile+".pdf", "\boletos_spool", .F., .T. )	//Se copiou
	//endif

	QRY->(dbGoTop())

	oProcess := TWFProcess():New("000001", OemToAnsi("Saldo de Produtos"))
	oProcess:NewTask("000001", "\workflow\estoque_prd.htm")
	
	oProcess:cSubject 	:= "Relação de Saldo de Produto em " + dtoc(dDataBase)
	oProcess:bTimeOut	:= {}
	oProcess:fDesc 		:= "Relação de Saldo de Produto em " + dtoc(dDataBase)
	oProcess:ClientName(cUserName)
	oHTML := oProcess:oHTML

	oHTML:ValByName('dtbase', dDataBase)

	QRY->(dbGoTop())
	While !QRY->(EOF())
		AAdd(oProcess:oHtml:ValByName('sld.grupo'), QRY->B1_GRUPO)
		AAdd(oProcess:oHtml:ValByName('sld.cod')  , QRY->B2_COD)
		AAdd(oProcess:oHtml:ValByName('sld.descr'), QRY->B1_DESC)
		AAdd(oProcess:oHtml:ValByName('sld.um')   , QRY->B1_UM)
		AAdd(oProcess:oHtml:ValByName('sld.saldo'), transform(iif(QRY->SALDO<0,0,QRY->SALDO),"@E 999,999,999")+"&nbsp;")

		QRY->(dbSkip())
	End

	//if file("\boletos_spool\"+cFile+".pdf")
	//	oProcess:AttachFile( "\boletos_spool\"+cFile+".pdf" )
	//endif

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif

	oProcess:cTo := GetNewPar("IN_WFSLDPR", "crelec@gmail.com")			
	//oProcess:cTo := "crelec@gmail.com"
			
	// Inicia o processo
	oProcess:Start()
	// Finaliza o processo
	oProcess:Finish()					

Endif
Return

Static Function goImpPDF()

	oReport := goRelImp()
	oReport:PrintDialog()

Return

Static Function goRelImp()
***************************
Local oReport
Local oSection1

oReport := TReport():New("ITECX100","Relação de Saldo de Produtos em " + dtoc(dDataBase),NIL,{|oReport| goPrtImp(oReport)},"Relação de Saldo de Produtos")
oReport:SetTotalInLine(.F.)
oReport:nFontBody := 8

oReport:setFile(cFile)

oReport:cFile       := cFile
oReport:nRemoteType := NO_REMOTE
oReport:nDevice     := 6
oReport:SetEnvironment(2)
        
oReport:SetViewPDF(.F.)

oSection1 := TRSection():New(oReport,"SaldoProdutos",{"QRY"})
TRCell():New(oSection1,"B1_GRUPO"	,"","Grupo"     ,,,,{|| QRY->B1_GRUPO })
TRCell():New(oSection1,"B2_COD"		,"","Produto"  	,,,,{|| QRY->B2_COD })
TRCell():New(oSection1,"B1_DESC"	,"","Descrição"	,,,,{|| QRY->B1_DESC })
TRCell():New(oSection1,"B1_UM"		,"","UM"       	,,,,{|| QRY->B1_UM })
TRCell():New(oSection1,"SALDO"		,"","Saldo"     ,PesqPict("SB2","B2_QATU"),,,{|| QRY->SALDO })


oSection1:Cell("B1_GRUPO"):SetSize(10)
oSection1:Cell("B2_COD"):SetSize(20)
oSection1:Cell("B1_UM"):SetSize(6)
oSection1:Cell("SALDO"):SetSize(25)

Return oReport

Static Function goPrtImp(oReport)
************************************
LOCAL nCount := 0

//Impressao do Relatorio
////////////////////////
QRY->(dbGoTop())
QRY->( DBEval({|| nCount++}) )
oReport:SetMeter(nCount)
oReport:Section(1):Init()

QRY->(dbGoTop())
While QRY->(!eof()) .and. !oReport:Cancel()
	oReport:IncMeter()
	oReport:Section(1):PrintLine()
	
	QRY->(dbSkip())		
EndDo
oReport:Section(1):Finish()

//oReport:Print(.F.)

//VarInfo("oReport", oReport,,.F.)
Return
