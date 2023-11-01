#INCLUDE "RWMAKE.CH"        

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! TMKVA1													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Ponto de entrada para conversão de prospect em cliente	! 
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne Consultoria											!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 18/10/2021 												!
+-------------------+-----------------------------------------------------------+
*/
User Function TMKVA1(cCliTmk,cLoja)        

Local cCodSA1 	:= ""
Local lRet	  	:= .F.
Local aArea		:= GetArea()

Local aPergs

Local x

Private cMailPad := GetNewPar("MU_WF001", "") //Chamado 26573 - 26/03/2015 - Fabricio Sensus.

PRIVATE aParam	:= {}

PRIVATE lMsErroAuto    := .F.

// Posiciona o PROSPECT e GRAVA um novo CLIENTE
SUS->(DbSetorder(1))
If SUS->(msSeek(xFilial("SUS")+cCliTmk+cLoja))

	If Empty(SUS->US_CODCLI) .AND. Empty(SUS->US_LOJACLI)
	
    	// VERIFICA SE JÁ NÃO EXISTE CLIENTE COM O MESMO CNPJ/CPF
    	SA1->(dbSetOrder(3))	// FILIAL+CGC
    	IF SA1->(msSeek(XFILIAL('SA1')+SUS->US_CGC))

			WHILE !SA1->(EOF()) .AND. ALLTRIM(SA1->A1_CGC)==ALLTRIM(SUS->US_CGC)
				IF ALLTRIM(SA1->A1_INSCR)==ALLTRIM(SUS->US_INSCR)
					cCGC := ""
					IF LEN(ALLTRIM(SA1->A1_CGC))==14
						cCGC := "CNPJ "+TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")
					ELSE
						cCGC := "CPF "+TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99")
					ENDIF
					APMSGALERT("Não é possível converter este prospect em cliente pois já existe um cliente cadastrado com o "+cCGC+" ("+SA1->A1_COD+"/"+SA1->A1_LOJA+").","CPF/CNPJ EXISTENTE-"+ALLTRIM(PROCNAME())+"-TMKVA1")
					Return .F.
		   		ENDIF
		   		SA1->(dbSkip())
		   ENDDO
    	ENDIF

		if LEN(ALLTRIM(SUS->US_CGC))==14
			BeginSql alias "SA1R"
				select count(A1_COD||A1_LOJA) CLIENTES from %table:SA1% a1
				where a1.%notDel%
				and substring(A1_CGC,1,8) = %exp:substr(ALLTRIM(SUS->US_CGC),1,8)%
			EndSql
			if !empty(SA1R->CLIENTES)
				APMSGALERT("AVISO: Já existe um ou mais cliente(s) cadastrado(s) com o mesmo radical deste CNPJ. A conversão irá continuar.","CPF/CNPJ EXISTENTE-"+ALLTRIM(PROCNAME())+"-TMKVA1")
			endif
			SA1R->(dbCloseArea()) 
		endif
    	
    	//if empty(SUS->US_INSCR)
    	//	APMSGALERT("Não é possível converter este prospect, informe corretamente a Inscrição Estadual.","INSCR.ESTADUAL INVALIDA-"+ALLTRIM(PROCNAME())+"-TMKVA1")
    	//	Return .F.
    	//endif

		//Campos obrigatorios no cadastro de clientes
		cCNAE 	:= CriaVar("A1_CNAE", .F.) 
		cContat := CriaVar("A1_CONTATO", .F.) 
		//cCtaCtb := CriaVar("A1_CONTA", .F.) 
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("A1_CONTRIB")
		cContri	:= X3CBox() // SX3->X3_CBOX
		aContri	:= Separa(cContri,";",.F.)
		cGrpCli := CriaVar("A1_GRPTRIB", .F.) 
		cPaisB 	:= "01058"	//Brasil	//CriaVar("A1_CODPAIS", .F.) 
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("A1_TPESSOA")
		cTPess	:= X3CBox() // SX3->X3_CBOX
		aTPess	:= Separa(cTPess,";",.F.)

		M->A1_EST	:= SUS->US_EST

		//				{1,"C.Contabil",cCtaCtb,PesqPict("SA1","A1_CONTA"),"","CT1","",100,.F.},	;
		aPergs	:= {	{1,"Cod.CNAE",cCNAE,PesqPict("SA1","A1_CNAE"),"","CC3","",100,.T.},	;
						{1,"Contato",cContat,PesqPict("SA1","A1_CONTATO"),"","","",100,.T.},	;
						{2,"Contribuinte"," ",aContri,50,"",.T.},	;  //{2,"Risco","E",aRisco,50,"",.T.},	; //Alterado Chamado 29142
						{1,"Grp.Clientes",cGrpCli,PesqPict("SA1","A1_GRPTRIB"),"","SX5ZH","",100,.T.},;
						{2,"Tipo Pessoa"," ",aTPess,100,"",.T.},;
						{1,"Pais Bacen",cPaisB,PesqPict("SA1","A1_CODPAIS"),"","CCH","",100,.T.}	}
		
		IF !PARAMBOX(aPergs,"CONVERSÃO DE PROSPECT-Parâmetros",@aParam,,,,,,,,.F.,.T.)
    		APMSGALERT("O prospect não foi convertido para cliente pois você cancelou a tela de parâmetros","CONVERSÃO CANCELADA-"+ALLTRIM(PROCNAME())+"-TMKVA1")
    		Return .F.
    	ENDIF
    	
		cCNAE 	:= mv_par01
		cContat := mv_par02
		//cCtaCtb := mv_par03
		cContri	:= mv_par03
		cGrpCli := mv_par04
		cTPess	:= mv_par05
		cPaisB 	:= mv_par06
				
		BEGIN TRANSACTION
			
			MSGRUN("Incluindo cliente ...","PROCESSANDO - "+ALLTRIM(ProcName()),{|| inkey(0.01)})
			
			cUNome := StrTran(SUS->US_NOME, Chr(160) , "")
			cUNred := StrTran(SUS->US_NREDUZ, Chr(160) , "")
			cUMail := StrTran(SUS->US_EMAIL, Chr(160) , "")
			cUEnd  := StrTran(SUS->US_END, Chr(160) , "")
			
			aRotAuto := {}			
			//aadd(aRotAuto,{"A1_LOJA",SUS->US_LOJA,NIL})
			aadd(aRotAuto,{"A1_NOME",cUNome,NIL})
			aadd(aRotAuto,{"A1_NREDUZ",cUNred,NIL})
			aadd(aRotAuto,{"A1_EST",SUS->US_EST,NIL})
			//aadd(aRotAuto,{"A1_COD_MUN"	,cCodMun,NIL})
			aadd(aRotAuto,{"A1_MUN",SUS->US_MUN,NIL})
			aadd(aRotAuto,{"A1_BAIRRO",SUS->US_BAIRRO,NIL})
			aadd(aRotAuto,{"A1_END",cUEnd,NIL})
			aadd(aRotAuto,{"A1_CEP",SUS->US_CEP,NIL})
			aadd(aRotAuto,{"A1_TIPO",SUS->US_TIPO,NIL})
			aadd(aRotAuto,{"A1_PESSOA",IIF(LEN(ALLTRIM(SUS->US_CGC))==14,"J","F"),NIL})
			aadd(aRotAuto,{"A1_CGC",SUS->US_CGC,NIL})
			aadd(aRotAuto,{"A1_TEL",SUS->US_TEL,NIL})
			aadd(aRotAuto,{"A1_EMAIL",cUMail,NIL})
			aadd(aRotAuto,{"A1_FAX",SUS->US_FAX,NIL})
			aadd(aRotAuto,{"A1_HPAGE",SUS->US_URL,NIL})
			aadd(aRotAuto,{"A1_DDD",SUS->US_DDD,NIL})
			aadd(aRotAuto,{"A1_DDI",SUS->US_DDI,NIL})
			aadd(aRotAuto,{"A1_INSCR",SUS->US_INSCR,NIL})
			aadd(aRotAuto,{"A1_DTINCLU",DDATABASE,NIL})
			//aadd(aRotAuto,{"A1_CONTA",cCtaCtb,NIL})
			aadd(aRotAuto,{"A1_GRPTRIB",cGrpCli,NIL})
			aadd(aRotAuto,{"A1_MSBLQL","1",NIL})	//BLOQUEADO
			aadd(aRotAuto,{"A1_CNAE",cCNAE,NIL})	
			aadd(aRotAuto,{"A1_CONTATO",cContat,NIL})	
			aadd(aRotAuto,{"A1_CODPAIS",cPaisB,NIL})	
			aadd(aRotAuto,{"A1_TPESSOA",cTPess,NIL})	
			aadd(aRotAuto,{"A1_CONTRIB",cContri,NIL})	

			//MATA030(aRotAuto,3)
			lOkGravou := .T.
			MSExecAuto({|x,y| MATA030(x,y)},aRotAuto,3)
			If lMsErroAuto				
			    DisarmTransaction()
			    lOkGravou := .F.
				APMSGALERT("Houve erro na gravação do cliente."+CHR(13)+"A conversão será cancelada. Efetuar a correção do cadastro.","ERRO EM CONTATOS-"+ALLTRIM(PROCNAME())+"-TMKVA1")
				MOSTRAERRO()
				//Return .F.
			EndIf
			//MsUnLock()
			//CONFIRMSX8()
			
			if lOkGravou
				cCodSA1	:= SA1->A1_COD
					
				// Atualiza o STATUS do prospect
				MSGRUN("Atualizando prospect...","PROCESSANDO - "+ALLTRIM(ProcName()),{|| inkey(0.01)})
				SUS->(Reclock("SUS",.F.))
					//US_STATUS  	:= "1" //Classificado
				SUS->US_STATUS  	:= "6" // Cliente
				SUS->US_CODCLI  	:= cCodSA1
				SUS->US_LOJACLI 	:= SUS->US_LOJA
				SUS->US_DTCONV	:= DDATABASE
				SUS->US_HRCONV	:= TIME()
				SUS->(MsUnlock())
				
			endif
			
		END TRANSACTION

		if lOkGravou
	
			// Esse e o NOVO CODIGO do CLIENTE
			cCliTmk := cCodSA1
			lRet := .T.
		else
			lRet := .F.
		endif

	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se eventualmente o Operador escolheu um PROSPECT que ja esta relacionado      ³
		//³com um CLIENTE DA BASE (proveniente da Administracao de Vendas) o atendimento ³
		//³sera gravado para o cliente e nao para o prospect                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCliTmk := SUS->US_CODCLI 
		cLoja	:= SUS->US_LOJACLI
	Endif
ELSE
	lRet := .F.
Endif

RestArea(aArea)

Return(lRet)
