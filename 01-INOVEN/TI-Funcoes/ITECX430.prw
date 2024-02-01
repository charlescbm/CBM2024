#INCLUDE "protheus.ch"
#include 'TBICONN.CH'
#include 'TBICODE.CH' 

Static lFWCodFil := FindFunction("FWCodFil")

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX430													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Ajuste do saldo dos clientes						 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 30/11/2023												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX430( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SE1","SA1"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Ajuste do saldo dos clientes - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_XFTEC430()

RpcClearEnv()

Return

User Function XFTEC430()

Private cCadastro := OemToAnsi("Refaz Dados Clientes/Fornecedores")  //

go430Processa(.T.)

Return

Static Function go430Processa(lBat)

// Variaveis utilizadas na chamada da stored procedure - TOP

Local nSaldoTit:=0
Local nMoeda  	:= Int(Val(GetMv("MV_MCUSTO")))
Local nMoedaF 	:= 0
Local cFilBusca := "  "
Local nTaxaM	:=0

Local nMaiorVDA		:= 0
Local nMaiorVDAaux	:= 0
Local nMSaldo		:= 0 
Local cCliente   	:= " "
Local cCliPad  		:= SuperGetMv("MV_CLIPAD",,"")		// Cliente Padrao
Local cLojaPad  	:= SuperGetMv("MV_LOJAPAD",,"")		// Loja Padrao                                                                 
Local lGestao		:= Iif( lFWCodFil, FWSizeFilial() > 2, .F. )	// Indica se usa Gestao Corporativa
Local lFilExc		:= .T.
Local lFilSA1C		:= If( lGestao, FWModeAccess("SA1",3) == "C", FWModeAccess("SA1",1) == "C" )
Local nValLiq 		:= 0
Local nValSld 		:= 0 


// Fim das variaveis utilizadas na chamada da stored procedure
DEFAULT lBat	:= .F.
//?Verifica parametros informados                               ?

DbSelectArea("SA1")

//cCodCliD := '22211915'
//cCodCliA := '22211915'
cCodCliD := ''
//cCodCliA := replace('Z', tamsx3('A1_COD')[1])
cCodCliA := padR(cCodCliD, len(SA1->A1_COD), 'Z')

DbSelectArea("SA1")
If Empty(cCodCliD)		
	dbGotop()
Else
	dbSetOrder(1)		
	MsSeek(xFilial("SA1")+cCodCliD,.T.)		
EndIf
While !Eof() .And. (SA1->A1_COD >= cCodCliD .And. SA1->A1_COD <= cCodCliA)
	If SA1->A1_COD >= cCodCliD .And. SA1->A1_COD <= cCodCliA
		Reclock( "SA1" )
		SA1->A1_SALDUP := 0
		MsUnlock()
	Endif
	dbSkip()
Enddo

// Busca primeira filial do SIGAMAT
//DbSelectArea("SM0")
//DbGoTOp()
//DbSeek(cEmpAnt)
//cFirstFIL := Iif( lFWCodFil, FWGETCODFILIAL, SM0->M0_CODFIL )
	
//?Titulos a Receber - Atualiza saldos clientes                              ?
/*dbSelectArea( "SE1" )
dbSetOrder(2) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                                                                                               
If Empty(cCodCliD)
	dbGotop()
Else
	If lGestao
		If lFilSA1C  // Se filial SA1 for totalmente compartilhada, varrer todas filiais da SE1
			MsSeek(FWxFilial("SE1",cFirstFIL)+cCodCliD,.T.)
		Else
			MsSeek(FWxFilial("SE1")+cCodCliD,.T.)
		EndiF
	Else

		If lFilSA1C  // Se filial SA1 for totalmente compartilhada, varrer todas filiais da SE1
			MsSeek(xFilial("SE1",cFirstFIL)+cCodCliD,.T.)
		Else
			MsSeek(xFilial("SE1")+cCodCliD,.T.)
		EndiF
	Endif

EndIf
*/
/*
nMaiorVDA := 0
While !Eof() .And. ((SE1->E1_CLIENTE >= cCodCliD .And. SE1->E1_CLIENTE <= cCodCliA) .OR. lFilSA1C)

	If SE1->E1_CLIENTE >= cCodCliD .And. SE1->E1_CLIENTE <= cCodCliA

		//DESCONSIDERAR FORM CC - CARTAO DE CREDITO
		if empty(SE1->E1_SALDO)
			SE1->(DbSkip())
			Loop
		endif
		if !empty(SE1->E1_XFORMA) .and. alltrim(SE1->E1_XFORMA) == 'CC'
			SE1->(DbSkip())
			Loop
		endif

		//?No caso dos modulos Sigaloja e Front Loja nao atualiza?
		//?os saldos de duplicatas para o cliente padrao	 	  ?
		If (nModulo == 12 ) .OR. ( nModulo == 72) 
			If cCliPad + cLojaPad == SE1->E1_ClIENTE + SE1->E1_LOJA 
				SE1->(DbSkip())
				Loop
			EndIf	
		EndIf
		//?Atualiza Saldo do Cliente                                             ?
		dbSelectArea( "SA1" )
		
		If lGestao
			lFilExc := ( !Empty( FWFilial("SA1") ) .and. !Empty( FWFilial("SE1") ) )
		Else	
			lFilExc := !Empty( xFilial( "SA1" ) ) .and. !Empty( xFilial( "SE1" ) )
		EndIf

		If lFilExc
			cFilBusca := SE1->E1_FILIAL		// Ambos exclusivos, neste caso
														// a filial serah 1 para 1
		Else
			cFilBusca := xFilial("SA1",SE1->E1_FILORIG)		// filial do cliente (SA1)
		Endif

		//?Monta a chave de busca para o SA1    ?
		cChaveSe1 := cFilBusca + SE1->E1_CLIENTE+ SE1->E1_LOJA
					
		dbSelectArea( "SA1" )
		If (dbSeek( cChaveSe1 ) )
			If !(SA1->(A1_FILIAL+A1_COD+A1_LOJA) ==  cCliente)
				cCliente     := SA1->(A1_FILIAL+A1_COD+A1_LOJA)
				nMaiorVDA    := 0
				nMaiorVDAaux := 0
				nMSaldo      := 0
			EndIf

			nMoedaF	  := If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMoeda)
			nTaxaM	  := Round(SE1->E1_VLCRUZ/SE1->E1_VALOR,3)
			nValLiq   := xMoeda(SE1->E1_VALLIQ,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
			nValSld   := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)

			If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
				AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
			Else
				nSaldoTit := SE1->E1_SALDO
				nSaldoTit := Iif(nSaldoTit < 0, 0, nSaldoTit)
				IF !(SE1->E1_TIPO $ MVPROVIS)
					AtuSalDup("+",nSaldoTit,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
				Endif

			Endif
		Endif
	Endif	
	
	dbSelectArea( "SE1" )
	dbSkip()
Enddo
*/

If Select("QRYSE1") <> 0
	QRYSE1->(dbCloseArea())
EndIf

BeginSQL Alias "QRYSE1"
SELECT
	E1.R_E_C_N_O_ E1RECNO
FROM 
	%Table:SE1% E1
WHERE
	E1.%NotDel%
	AND E1_CLIENTE >= %exp:cCodCliD%
	AND E1_CLIENTE <= %exp:cCodCliA%
	AND E1_SALDO > 0
	AND E1_XFORMA <> 'CC'
ORDER BY E1_CLIENTE, E1_LOJA, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO
EndSql

//alert(GetLastQuery()[2])
//MemoWrite("\temp\query_refazcli.txt", GetLastQuery()[2])

lFez := .F.
nMaiorVDA := 0
While QRYSE1->(!Eof())

	dbSelectArea('SE1')
	dbGoto(QRYSE1->E1RECNO)

	//?No caso dos modulos Sigaloja e Front Loja nao atualiza?
	//?os saldos de duplicatas para o cliente padrao	 	  ?
	If (nModulo == 12 ) .OR. ( nModulo == 72) 
		If cCliPad + cLojaPad == SE1->E1_ClIENTE + SE1->E1_LOJA 
			QRYSE1->(DbSkip())
			Loop
		EndIf	
	EndIf
	//?Atualiza Saldo do Cliente                                             ?
	dbSelectArea( "SA1" )
	
	If lGestao
		lFilExc := ( !Empty( FWFilial("SA1") ) .and. !Empty( FWFilial("SE1") ) )
	Else	
		lFilExc := !Empty( xFilial( "SA1" ) ) .and. !Empty( xFilial( "SE1" ) )
	EndIf

	If lFilExc
		cFilBusca := SE1->E1_FILIAL		// Ambos exclusivos, neste caso
													// a filial serah 1 para 1
	Else
		cFilBusca := xFilial("SA1",SE1->E1_FILORIG)		// filial do cliente (SA1)
	Endif

	//?Monta a chave de busca para o SA1    ?
	cChaveSe1 := cFilBusca + SE1->E1_CLIENTE+ SE1->E1_LOJA
				
	dbSelectArea( "SA1" )
	If (dbSeek( cChaveSe1 ) )
		If !(SA1->(A1_FILIAL+A1_COD+A1_LOJA) ==  cCliente)
			cCliente     := SA1->(A1_FILIAL+A1_COD+A1_LOJA)
			nMaiorVDA    := 0
			nMaiorVDAaux := 0
			nMSaldo      := 0
		EndIf

		nMoedaF	  := If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMoeda)
		nTaxaM	  := Round(SE1->E1_VLCRUZ/SE1->E1_VALOR,3)
		nValLiq   := xMoeda(SE1->E1_VALLIQ,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)
		nValSld   := xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO,3,SE1->E1_TXMOEDA)

		If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
			AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
		Else
			nSaldoTit := SE1->E1_SALDO
			nSaldoTit := Iif(nSaldoTit < 0, 0, nSaldoTit)
			IF !(SE1->E1_TIPO $ MVPROVIS)
				AtuSalDup("+",nSaldoTit,SE1->E1_MOEDA,SE1->E1_TIPO,Iif(nTaxaM==1,Nil,nTaxaM),SE1->E1_EMISSAO)
			Endif

		Endif
	Endif
	lFez := .T.
	
	QRYSE1->(DbSkip())
Enddo
QRYSE1->(dbCloseArea())

FSEmail()

dbSelectArea( "SE1" )
dbSetOrder(1)
MsUnlockAll()
	
Return

Static Function FSEmail()
	
	Local cServer	:=  AllTrim(GetMv("MV_RELSERV"))
	Local cAccount  :=  AllTrim(GetMv("MV_RELACNT"))
	Local cPassword :=  AllTrim(GetMv("MV_RELPSW"))
   	Local cFrom     :=  AllTrim(GetMv("MV_RELFROM"))
   	Local lRelauth  :=  SuperGetMv("MV_RELAUTH",, .F.)
	Local lConnect  := .F.
	Local lEnviou   := .F.
	Local lRet      := .T.
	Local cError	:= ''
	//Local cEmailTi	:= ''         
	Local cTo		:= ''
	Local cSubject	:= 'RECALCULO A1_SALDUP'
	Local cCorpo	:= ''
	//Local cEmail	:= ''
	//Local nPosPrd	:= 0
	Local cAnexos	:= ''	
	//Local lRet		:= .F.
	//--Limpa variavel
	cCorpo:=''
	//Atualiza variavel
	cBody:= 'PROCESSO DE RECALCULO A1_SALDUP CONCLUIDO!'
	
	//--Valida se retornou email
	cTo:= 'charlesbattisti@gmail.com'
	//cTo:= 'crelec@gmail.com'
   	
 	//--Enviando Email(s)
	If !Empty(cServer) .And. !Empty(cAccount) .And. !Empty(cTo)
		//Realiza conexao com o Servidor
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword RESULT lConnect
		//--Verifica se existe autenticação
		If lRelauth
			lRet := Mailauth(cAccount,cPassword)        
		EndIf
		//--Se conseguiu Conexao ao Servidor SMTP	
		If lConnect 
			SEND MAIL FROM cFrom TO cTo SUBJECT cSubject BODY cBody ATTACHMENT cAnexos RESULT lEnviou													
			If !lEnviou //Se conseguiu Enviar o e-Mail
				lRet:=.F.
				//Erro no envio do email
				GET MAIL ERROR cError
				ConOut("Erro de autenticação","Verifique a conta e a senha para envio",cError)
			EndIf
		Else
			lRet:=.F.
			GET MAIL ERROR cError
			ConOut("Erro de autenticação","Verifique a conta e a senha para envio ",cError)
		EndIf      	   
		If lRet
			DISCONNECT SMTP SERVER
		EndIf
	EndIf
	
	/*If lRet
		//--Mensagem de envio
		MsgBox("Email(s) enviado(s) com sucesso","","INFO")
	EndIf*/	

Return()
