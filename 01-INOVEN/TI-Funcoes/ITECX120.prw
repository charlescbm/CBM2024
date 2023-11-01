#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX120													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de alteração da cond.pagamento dos clientes 		!
!					! com titulos em atraso										!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 14/09/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX120( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SE1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Alteracao Cond.Pagto - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC120()

RpcClearEnv()

Return

User Function WFTEC120()

If File("\workflow\wf_alt_condicao.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1

	cNewCd := GetNewPar("IN_WFTRCON", "003")

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif
	BEGINSQL ALIAS "QRY"

		SELECT DISTINCT E1_CLIENTE, E1_LOJA, A1_COND, A1_NOME  FROM %table:SE1% E1
		INNER JOIN %table:SA1% A1 ON A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA
		WHERE E1.%notdel% AND A1.%notdel%
		AND E1_SALDO > 0
		AND E1_VENCREA < %exp:dtos(dDataBase)%
		AND E1_TIPO <> 'NCC' AND E1_TIPO <> 'RA '

		AND DATEDIFF(DAY,SUBSTRING(E1_VENCREA,1,4)+'-'+SUBSTRING(E1_VENCREA,5,2)+'-'+SUBSTRING(E1_VENCREA,7,2),CONVERT(CHAR(10),GETDATE(),121)) >= 6
		AND E1_ZENVCOB = 'S' AND A1_ZENVCOB = 'S' AND A1_COND <> %exp:cNewCd%
		ORDER BY E1_CLIENTE, E1_LOJA

	ENDSQL

	lTem := .F.
	QRY->(dbGoTop())
	While !QRY->(EOF())
		lTem := .T.
		exit
		QRY->(dbSkip())
	End
	if lTem
		oProcess := TWFProcess():New("000001", OemToAnsi("Clientes com Cond.Pagto Alterada em " + dtoc(dDataBase)))
		oProcess:NewTask("000001", "\workflow\wf_alt_condicao.htm")
		
		oProcess:cSubject 	:= "Clientes com Cond.Pagto Alterada em " + dtoc(dDataBase)
		oProcess:bTimeOut	:= {}
		oProcess:fDesc 		:= "Clientes com Cond.Pagto Alterada em " + dtoc(dDataBase)
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		oHTML:ValByName('dtbase', dDataBase)
	endif

	cCli := ""
	QRY->(dbGoTop())
	While !QRY->(EOF())

		cCli := QRY->E1_CLIENTE + QRY->E1_LOJA

		SA1->(dbSetOrder(1))
		SA1->(msSeek(xFilial('SA1') + cCli))

		AAdd(oProcess:oHtml:ValByName('cli.cod')	, QRY->E1_CLIENTE)
		AAdd(oProcess:oHtml:ValByName('cli.loja')   , QRY->E1_LOJA)
		AAdd(oProcess:oHtml:ValByName('cli.nome')	, QRY->A1_NOME)
		AAdd(oProcess:oHtml:ValByName('cli.cond')   , iif(empty(QRY->A1_COND), '-', QRY->A1_COND))
		AAdd(oProcess:oHtml:ValByName('cli.newcond'), cNewCd)

		SA1->(recLock('SA1', .F.))
		SA1->A1_COND := cNewCd
		SA1->(msUnlock())

		QRY->(dbSkip())

	End

	If (Select("QRY") <> 0)
		QRY->(dbCloseArea())
	Endif

	if lTem

		oProcess:cTo := GetNewPar("IN_WFEMCON", "crelec@gmail.com")			
		//oProcess:cTo := "crelec@gmail.com"
		//oProcess:cTo := "crelec@gmail.com;charlesbattisti@gmail.com"
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()	

	endif

Endif
Return

