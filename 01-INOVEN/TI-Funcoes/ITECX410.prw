#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX410													!
+-------------------+-----------------------------------------------------------+
!Descricao			! Workflow de envio da variação de custo do produto	 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 24/07/2023												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX410( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SB1","SB2","SB9"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Variação de Custo do Produto - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_WFTEC410()

RpcClearEnv()

Return

User Function WFTEC410()

Local dDataPro := dDataBase
Local _x, _f

//If File("\workflow\quadro_fat.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1
If File("\workflow\variacao_custo.htm") .and. dow(dDataBase) <> 7 .and. dow(dDataBase) <> 1

	For _f := 1 to 2
	//For _f := 1 to 1

		//Montando estrutura do arquivo geral temporario
		aStruSQL := {}
		AADD(aStruSQL,{"CODPRO"		,"C", TamSx3("B1_COD")[1], TamSx3("B1_COD")[2] })
		AADD(aStruSQL,{"DESPRO"		,"C", TamSx3("B1_DESC")[1], TamSx3("B1_DESC")[2] })
		//AADD(aStruSQL,{"B9LOCAL"	,"C", TamSx3("B2_LOCAL")[1], TamSx3("B2_LOCAL")[2] })
		AADD(aStruSQL,{"B9DATA"		,"D", TamSx3("B9_DATA")[1], TamSx3("B9_DATA")[2] })
		AADD(aStruSQL,{"B9CM1"		,"N", TamSx3("B2_CM1")[1], TamSx3("B2_CM1")[2] })
		AADD(aStruSQL,{"B2LOCAL"	,"C", TamSx3("B2_LOCAL")[1], TamSx3("B2_LOCAL")[2] })
		AADD(aStruSQL,{"B2CM1"		,"N", TamSx3("B2_CM1")[1], TamSx3("B2_CM1")[2] })
		AADD(aStruSQL,{"VARIA"		,"N", 12 , 2 })
		AADD(aStruSQL,{"CVARIA"		,"C", 20 , 0 })

		If ( Select('TRB1') <> 0 )
			TRB1->(dbCloseArea())
			if valType(oTRB1) <> 'U'
				oTRB1:Delete()
			endif
		Endif
		
		oTRB1 := U_LGTab(aStruSQL, 'TRB1', {{"CODPRO"},{"CVARIA"}})

		oProcess := TWFProcess():New("000001", OemToAnsi("Variaçã de Custo do Produto"))
		//oProcess:NewTask("000001", "\workflow\quadro_fat.htm")
		oProcess:NewTask("000001", "\workflow\variacao_custo.htm")
		oProcess:cSubject 	:= "Variação de Custo do Produto em " + dtoc(dDataPro) + " Filial: " + iif(_f == 1, "0102", "0103")
		oProcess:fDesc 		:= "Variação de Custo do Produto em " + dtoc(dDataPro) + " Filial: " + iif(_f == 1, "0102", "0103")
		
		oProcess:bTimeOut	:= {}
		oProcess:ClientName(cUserName)
		oHTML := oProcess:oHTML

		cStrFil := iif(_f==1,"%SB2.B2_FILIAL IN ('0101','0102')%", "%SB2.B2_FILIAL IN ('0103','0104')%")

		//Saldo Atual - Almoxarifado 01
		If (Select("QRYSLD") <> 0)
			QRYSLD->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYSLD"
			SELECT B2_COD, B2_LOCAL, B2_CM1, B1_DESC
			FROM %table:SB2% SB2 
			INNER JOIN %table:SB1% SB1 ON (SB1.B1_COD = SB2.B2_COD) 
			WHERE  SB2.%notdel% AND SB1.%notdel%
			AND SB2.B2_LOCAL = '01' AND SB2.B2_CM1 > 0
			AND B1_MSBLQL = '2' AND B1_TIPO = 'ME'
			AND %exp:cStrFil%
		ENDSQL

		nCont := 1
		QRYSLD->(dbGoTop())
		While !QRYSLD->(EOF())

			//if nCont > 100
			//	EXIT
			//endif

			if !TRB1->(dbSeek(QRYSLD->B2_COD))
				TRB1->(recLock('TRB1', .T.))
				TRB1->CODPRO	:= QRYSLD->B2_COD
				TRB1->DESPRO	:= QRYSLD->B1_DESC
				TRB1->B2LOCAL	:= QRYSLD->B2_LOCAL
				TRB1->B2CM1		:= QRYSLD->B2_CM1
				TRB1->(msUnlock())
			endif
			nCont++

			QRYSLD->(dbSkip())
		End

		cStrFil := iif(_f==1,"%SB2.B2_FILIAL IN ('0101','0102')%", "%SB2.B2_FILIAL IN ('0103','0104')%")
		//Saldo Atual - Almoxarifado 03
		If (Select("QRYSLD") <> 0)
			QRYSLD->(dbCloseArea())
		Endif
		BEGINSQL ALIAS "QRYSLD"
			SELECT B2_COD, B2_LOCAL, B2_CM1, B1_DESC
			FROM %table:SB2% SB2 
			INNER JOIN %table:SB1% SB1 ON (SB1.B1_COD = SB2.B2_COD) 
			WHERE  SB2.%notdel% AND SB1.%notdel%
			AND SB2.B2_LOCAL = '03' AND SB2.B2_CM1 > 0 
			AND B1_MSBLQL = '2' AND B1_TIPO = 'ME'
			AND %exp:cStrFil%
		ENDSQL

		nCont := 1
		QRYSLD->(dbGoTop())
		While !QRYSLD->(EOF())

			//if nCont > 100
			//	EXIT
			//endif

			if !TRB1->(dbSeek(QRYSLD->B2_COD))
				TRB1->(recLock('TRB1', .T.))
				TRB1->CODPRO	:= QRYSLD->B2_COD
				TRB1->DESPRO	:= QRYSLD->B1_DESC
				TRB1->B2LOCAL	:= QRYSLD->B2_LOCAL
				TRB1->B2CM1		:= QRYSLD->B2_CM1
				TRB1->(msUnlock())
			endif
			nCont++

			QRYSLD->(dbSkip())
		End

		cStrFil := iif(_f==1,"%SB9.B9_FILIAL IN ('0101','0102')%", "%SB9.B9_FILIAL IN ('0103','0104')%")

		cCrele := ""
		TRB1->(dbGoTop())
		While !TRB1->(eof())

			If (Select("QRYSLD") <> 0)
				QRYSLD->(dbCloseArea())
			Endif
			BEGINSQL ALIAS "QRYSLD"
				column B9_DATA as Date
				SELECT TOP 1 B9_COD, B9_LOCAL, B9_DATA, B9_CM1, B1_DESC
				FROM %table:SB9% SB9 
				INNER JOIN %table:SB1% SB1 ON (SB1.B1_COD = SB9.B9_COD) 
				WHERE  SB9.%notdel% AND SB1.%notdel%
				AND SB9.B9_COD = %exp:TRB1->CODPRO%
				AND SB9.B9_CM1 <> 0 
				AND %exp:cStrFil%
				order by B9_DATA DESC
			ENDSQL

			nVaria := round(((TRB1->B2CM1 - QRYSLD->B9_CM1) / QRYSLD->B9_CM1) * 100,2)
			//cCrele += alltrim(str(nVaria)) + " - "
			//cCrele += alltrim(str(iif(nVaria < 0, nVaria * (-1), nVaria))) + " - "
			cVaria := 99999999 - iif(nVaria < 0, nVaria * (-1), nVaria)
			//cCrele += alltrim(str(cVaria)) + chr(13)+chr(10)

			TRB1->(recLock('TRB1', .F.))
			//TRB1->B9LOCAL	:= QRYSLD->B9_LOCAL
			TRB1->B9DATA	:= QRYSLD->B9_DATA
			TRB1->B9CM1		:= QRYSLD->B9_CM1
			TRB1->VARIA 	:= nVaria
			TRB1->CVARIA 	:= alltrim(str(cVaria))
			TRB1->(msUnlock())

			/*
			AAdd(oProcess:oHtml:ValByName('it.cod'), TRB1->CODPRO)
			AAdd(oProcess:oHtml:ValByName('it.nome'), TRB1->DESPRO)
			//AAdd(oProcess:oHtml:ValByName('it.b9local'), TRB1->B9LOCAL)
			AAdd(oProcess:oHtml:ValByName('it.b9data'), dtoc(TRB1->B9DATA))
			AAdd(oProcess:oHtml:ValByName('it.b9cm1'), transform(TRB1->B9CM1, '@E 999,999,999.99')+"&nbsp;")
			AAdd(oProcess:oHtml:ValByName('it.b2local'), TRB1->B2LOCAL)
			AAdd(oProcess:oHtml:ValByName('it.b2cm1'), transform(TRB1->B2CM1, '@E 999,999,999.99')+"&nbsp;")
			if empty(nVaria)
				AAdd(oProcess:oHtml:ValByName('it.varia'), "<b>-&nbsp;</b>")
			else
				AAdd(oProcess:oHtml:ValByName('it.varia'), "<b>"+transform(nVaria, '@E 9,999.99')+"%&nbsp;</b>")
			endif
			*/

			TRB1->(dbSkip())
		end
		//MemoWrite("\temp\calculo_custo.txt",cCrele)

		//Monta HTML
		cCrele := ""
		TRB1->(dbSetOrder(2))
		TRB1->(dbGoTop())
		While !TRB1->(eof())

			if empty(TRB1->VARIA)
				TRB1->(dbSkip())
				loop
			endif

			//cCrele += TRB1->CODPRO + " - " + dtoc(TRB1->B9DATA) + " - " + transform(TRB1->B9CM1, '@E 999,999,999.99') + " - " +; 
			//          TRB1->B2LOCAL + " - " + transform(TRB1->B2CM1, '@E 999,999,999.99') + " - " +;
			//		  alltrim(str(TRB1->VARIA)) + " - " + str(iif(TRB1->VARIA < 0, TRB1->VARIA * (-1), TRB1->VARIA)) + " - " + TRB1->CVARIA + chr(13)+chr(10)
			
			AAdd(oProcess:oHtml:ValByName('it.cod'), TRB1->CODPRO)
			AAdd(oProcess:oHtml:ValByName('it.nome'), TRB1->DESPRO)
			//AAdd(oProcess:oHtml:ValByName('it.b9local'), TRB1->B9LOCAL)
			AAdd(oProcess:oHtml:ValByName('it.b9data'), dtoc(TRB1->B9DATA))
			AAdd(oProcess:oHtml:ValByName('it.b9cm1'), transform(TRB1->B9CM1, '@E 999,999,999.99')+"&nbsp;")
			AAdd(oProcess:oHtml:ValByName('it.b2local'), TRB1->B2LOCAL)
			AAdd(oProcess:oHtml:ValByName('it.b2cm1'), transform(TRB1->B2CM1, '@E 999,999,999.99')+"&nbsp;")
			if empty(TRB1->VARIA)
				AAdd(oProcess:oHtml:ValByName('it.varia'), "<b>-&nbsp;</b>")
			else
				AAdd(oProcess:oHtml:ValByName('it.varia'), iif(TRB1->VARIA < 0,"<font color='red'>","") + "<b>"+transform(TRB1->VARIA, '@E 999,999.99')+"%&nbsp;</b>" + iif(TRB1->VARIA < 0,"</font>",""))
			endif
			
			TRB1->(dbSkip())
		end

		oHTML:ValByName('dtbase', dDataPro)
		oHTML:ValByName('desfil', iif(_f == 1, "0102", "0103"))

		//Prepara os emails
		cEnvio := ""
		cUsers := GetNewPar("IN_WFVRCUS", "charlesbattisti@gmail.com")	
		aUsers := Strtokarr(cUsers, ";")
		for _x := 1 to len(aUsers)
			cEnvio += iif(_x > 1, ";", "")
			cEnvio += UsrRetMail(aUsers[_x])
		next
		
		oProcess:cTo := cEnvio	//GetNewPar("IN_WFVRCUS", "crelec@gmail.com")			
		//oProcess:cTo := "crelec@gmail.com"
		//Envio de copia oculta
		//if !Empty(GetNewPar("IN_WFVLFAX", ""))
		//	oProcess:cBcc := GetNewPar("IN_WFVLFAX", "")
		//endif
				
		// Inicia o processo
		oProcess:Start()
		// Finaliza o processo
		oProcess:Finish()			

	Next
	//MemoWrite("\temp\variacao_custo.txt",cCrele)


Endif
Return

