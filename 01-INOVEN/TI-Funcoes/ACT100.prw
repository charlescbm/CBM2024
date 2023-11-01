#Include 'Protheus.ch'
/*/{Protheus.doc} ACT100

Rotina para alterar os parametros de fechamento do sistema 

/*/
User Function ACT100()
	Local cUsrPAR 		:= SUPERGETMV("UN_USRPAR",,"000000")
	//Local _afields:={}     
	Local aArea		:=	SM0->(GetArea())
	Private cMatriz		:=	SM0->M0_CODIGO
	Private arotina 	:= {}
	Private cCadastro := "Atualização de Parametro"
	Private cMark		:=	GetMark()
	//Private cAlias		:=	GetNextAlias()
	Private oTab

	If (__cUserId $ cUsrPAR)

		A500Altera()

	Else
		MsgInfo("Você não possui acesso. "+CRLF+"Usuário:"+RETCODUSR()+" [UN_USRPAR]",ProcName()+" [ACT100]")
	EndIf
	
	RestArea(aArea)
Return Nil



/*/{Protheus.doc} A500Altera

Alterar parametros

/*/
Static Function A500Altera

	Local nOpt	:=	0
	local iLinha			
	
	Private dULMES	 		:= iif(!empty(SuperGetMv('MV_ULMES', .F.)),SuperGetMv('MV_ULMES', .F.), ctod(''))
	Private dDATAFIS 		:= iif(!empty(SuperGetMv('MV_DATAFIS', .F.)),SuperGetMv('MV_DATAFIS', .F.), ctod(''))
	Private dDATAFIN 		:= iif(!empty(SuperGetMv('MV_DATAFIN', .F.)),SuperGetMv('MV_DATAFIN', .F.), ctod(''))
	Private dDATAFAT 		:= iif(!empty(SuperGetMv('MV_DATAFAT', .F.)),SuperGetMv('MV_DATAFAT', .F.), ctod(''))
	
	iLinha := 10
	
	DEFINE MSDIALOG oDlg FROM 01,1 TO 250,295 TITLE "Alteração de Parâmetros" PIXEL
	
	@ iLinha, 010 Say "Fechamento Estoque" OF oDlg PIXEL
	@ iLinha, 080 Get dULMES Picture PesqPict("SD1","D1_EMISSAO") WHEN .T. SIZE 49, 7 OF oDlg PIXEL
	iLinha += 15
	@ iLinha, 010 Say "Fechamento Fiscal" OF oDlg PIXEL
	@ iLInha, 080 Get dDATAFIS Picture PesqPict("SD1","D1_EMISSAO") WHEN .T. SIZE 49, 7 OF oDlg PIXEL
	iLinha += 15
	@ iLinha, 010 Say "Fechamento Financeiro" OF oDlg PIXEL
	@ iLinha, 080 Get dDATAFIN Picture PesqPict("SD1","D1_EMISSAO") WHEN .T. SIZE 49, 7 OF oDlg PIXEL
	iLinha += 15
	@ iLinha, 010 Say "Fechamento Faturamento" OF oDlg PIXEL
	@ iLinha, 080 Get dDATAFAT Picture PesqPict("SD1","D1_EMISSAO") WHEN .T. SIZE 49, 7 OF oDlg PIXEL
	iLinha += 15
	
	@ 003, 003 TO iLinha, 145 OF oDlg  PIXEL
	iLinha += 5
	
	DEFINE SBUTTON FROM iLinha,040 TYPE 1 ACTION (nOpt := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM iLinha,100 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED
	
	If nOpt == 1
		A500Confir()
		//(cAlias)->(dbGoTop())
	Endif
	
Return nil

/*/{Protheus.doc} A500Confir

Confirma no SX6

/*/	
Static Function A500Confir()
	Local cMsgLog	:=	""
	Local _x

	//Envio de WF
	If File("\workflow\wf_alt_parametros.htm")

		oProcess := TWFProcess():New("000001", OemToAnsi("Alteracao de Parametros"))
		oProcess:NewTask("000001", "\workflow\wf_alt_parametros.htm")
		
		oProcess:cSubject 	:= "Alteracao de Parametros Realizada em " + dtoc(dDataBase)
		oProcess:bTimeOut	:= {}
		oProcess:fDesc 		:= "Alteracao de Parametros Realizada em " + dtoc(dDataBase)
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		oHTML:ValByName('origem', cEmpAnt + cFilAnt)
		oHTML:ValByName('dtalt', dDataBase)
		oHTML:ValByName('dtbase', dDataBase)
		oHTML:ValByName('usrparam', cUserName)

		//DE
		oHTML:ValByName('mvulmes_de', DTOC(SuperGetMv('MV_ULMES', .F.)))
		oHTML:ValByName('mvdtfis_de', DTOC(SuperGetMv('MV_DATAFIS', .F.)))
		oHTML:ValByName('mvdtfin_de', DTOC(SuperGetMv('MV_DATAFIN', .F.)))
		oHTML:ValByName('mvdtfat_de', DTOC(SuperGetMv('MV_DATAFAT', .F.)))

		//PARA
		oHTML:ValByName('mvulmes_para', DTOC(dULMES))
		oHTML:ValByName('mvdtfis_para', DTOC(dDATAFIS))
		oHTML:ValByName('mvdtfin_para', DTOC(dDATAFIN))
		oHTML:ValByName('mvdtfat_para', DTOC(dDATAFAT))

		//Prepara os emails
		cEnvio := ""
		cUsers := GetNewPar("UN_WFUSRPR", "charlesbattisti@gmail.com")			
		aUsers := Strtokarr(cUsers, ";")
		for _x := 1 to len(aUsers)
			cEnvio += iif(_x > 1, ";", "")
			cEnvio += UsrRetMail(aUsers[_x])
		next

		oProcess:cTo := cEnvio	//GetNewPar("UN_WFUSRPR", "charlesbattisti@gmail.com")			
		//oProcess:cTo := "crelec@gmail.com"
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()					

	endif

	//dbSelectArea(cAlias)
	//dbgotop()
	//While !(cAlias)->(Eof()) 
	//	If !Empty((cAlias)->OK) 
				/*cMsgLog	+=	If(!Empty(dULMES),CRLF+UsPutMv(cFilAnt,"MV_ULMES",iif(!empty(dULMES),DTOS(dULMES),'')),"")
				cMsgLog	+=	If(!Empty(dDATAFIS),CRLF+UsPutMv(cFilAnt,"MV_DATAFIS",iif(!empty(dDATAFIS),DTOS(dDATAFIS),'')),"")
				cMsgLog	+=	If(!Empty(dDATAFIN),CRLF+UsPutMv(cFilAnt,"MV_DATAFIN",iif(!empty(dDATAFIN),DTOS(dDATAFIN),'')),"")
				cMsgLog	+=	If(!Empty(dDATAFAT),CRLF+UsPutMv(cFilAnt,"MV_DATAFAT",iif(!empty(dDATAFAT),DTOS(dDATAFAT),'')),"")*/
				cMsgLog	+=	CRLF+UsPutMv(cFilAnt,"MV_ULMES",iif(!empty(dULMES),DTOS(dULMES),''))
				cMsgLog	+=	CRLF+UsPutMv(cFilAnt,"MV_DATAFIS",iif(!empty(dDATAFIS),DTOS(dDATAFIS),''))
				cMsgLog	+=	CRLF+UsPutMv(cFilAnt,"MV_DATAFIN",iif(!empty(dDATAFIN),DTOS(dDATAFIN),''))
				cMsgLog	+=	CRLF+UsPutMv(cFilAnt,"MV_DATAFAT",iif(!empty(dDATAFAT),DTOS(dDATAFAT),''))
	//	EndIf
	//	(cAlias)->(dbSkip())
	//EndDo

	
	Aviso("Finalizado!",cMsgLog,{"OK"},3)
Return Nil


/*/{Protheus.doc} UsPutMv

Atualiza parametro

/*/	
Static Function UsPutMv(_cFilFind,_cParam,_cValor)
	Local cRet		:=	""
	Local cDePara	:=	""
	
	DbSelectArea ("SX6")
	DbSetorder(1)
	DbGoTop()
	IF dbseek(_cFilFind+_cParam)
		If reclock("SX6",.F.)
			cDePara	:=	"De:"+Alltrim(SX6->(U_LGFGet("X6_conteud")))+" Para:"+_cValor
			SX6->(U_LGFPut("X6_conteud", _cValor))
			SX6->( msunlock() )
		EndIf
		cRet	:=	"Filial: "+_cFilFind+". Alterado "+_cParam+" com sucesso. "+cDePara
	Else
		IF dbseek(xFilial()+_cParam)
			If reclock("SX6",.F.)
				cDePara	:=	"De:"+Alltrim(SX6->(U_LGFGet("X6_conteud")))+" Para:"+_cValor
				SX6->(U_LGFPut("X6_conteud", _cValor))
				SX6->( msunlock() )
			EndIf
			cRet	:=	"Filial: "+_cFilFind+". Alterado "+_cParam+" com sucesso. "+cDePara
		Else
			cRet	:=	"Filial: "+_cFilFind+". Parâmetro "+_cParam+" não encontrado."
		EndIf
	ENDIF

Return  cRet

// Função para quando usar RecLock em dicionário, colocar o valor nos campos
User Function LGFPut(cField, xVal)
	
	FieldPut(FieldPos(cField), xVal)
	
Return

// Função para retornar valor dos campos da tabela
User Function LGFGet(cField)
	
Return FieldGet(FieldPos(cField))

