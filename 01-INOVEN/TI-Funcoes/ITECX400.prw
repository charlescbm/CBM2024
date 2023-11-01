#INCLUDE "protheus.ch"

/*
+-------------------------------------------------------------------------------+
!                             FICHA TECNICA DO PROGRAMA                     	!
+-------------------------------------------------------------------------------+
!Programa          	! ITECX400													!
+-------------------+-----------------------------------------------------------+
!Descricao			! JOB de Liberacao de estoque automatico			 		!
!					! 															!
+-------------------+-----------------------------------------------------------+
!Autor             	! GoOne COnsultoria - Crele Cristina						!
+-------------------+-----------------------------------------------------------+
!Data de Criacao   	! 29/09/2021												!
+-------------------+-----------------------------------------------------------+
*/
User Function ITECX400( aParams )

Default aParams := {"01","0102"}

RpcSetType( 3 )
RPCSetEnv(aParams[1],aParams[2],"","","","",{"SF2"})
FwLogMsg("INFO", /*cTransactionId*/, "INOVLOG", FunName(), "", "01", "Liberacao de Estoque Automatica - Empresa: " + aParams[1] + "/" + aParams[2] + " - " + DtoC(Date()), 0, 0, {})
U_LBTEC400()

RpcClearEnv()

Return

User Function LBTEC400()

//Local nOpca    := 0
//Local aSays    := {}
//Local aButtons := {}
Local cPerg    := "LIBAT2" //U_CriaPerg("LIBAT2")
Local cAlias   := "SC9"
//Local cMvAvalEst

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utiliza arquivo de liberados para geracao na nota            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 Pedido de          ?                                 ³
//³ mv_par02 Pedido ate         ?                                 ³
//³ mv_par03 Cliente de         ?                                 ³
//³ mv_par04 Cliente ate        ?                                 ³
//³ mv_par05 Dta Liberacao de   ?                                 ³
//³ mv_par06 Dta Liberacao ate  ?                                 ³
//³ mv_par07 Quanto ao Estoque  ? Estoque/WMS  WMS                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)
                      
mv_par01 := Space(6)
mv_par02 := "ZZZZZZ"
mv_par03 := Space(8)
mv_par04 := "ZZZZZZZZ"
mv_par05 := ctod("01/01/13") //dDataBase - 5
mv_par06 := (dDataBase)
mv_par07 := 1

If dDataBase==DataValida(dDataBase)
	ConOut("> U_ITECX400: Inicio de Liberacao de Pedidos "+Time())
	//PutMV("MV_AVALEST",1)
	lMSErroAuto := .F. ; lMSHelpAuto := .T. ; lEnd := .F. ; lEmp := .F.
	//Processa({|lEnd| Ma450Processa(cAlias,.F.,.T.,@lEnd,@lEmp,MV_PAR07==2)},,,.T.)
	
	Ma450Proces( "SC9", .F., .T., .F., Nil, MV_PAR07==2)

	//PutMV("MV_AVALEST",3) 
 	
	//cEmail    := "charles.medeiros@brascola.com.br;vviana@brascola.com.br"
	//cAssunto  := "Liberacao de Estoque em Joinville realizado as "+Time()
	//cTexto    := "Liberacao de Estoque em Joinville ( filial 01 ) realizado as "+Time()	

	/*	
		If U_SendMail(cEmail,cAssunto,cTexto,"",.T.)
			ConOut("--------------------------------------------------")
			ConOut("  Enviado e-mail - Liberacao de Estoque ")
			ConOut("--------------------------------------------------")
		Else
			ConOut("-----------------------------------------------------")
			ConOut("  Problema no envio de e-mail - Liberacao de Estoque ")
			ConOut("-----------------------------------------------------")
		EndIf
	*/  
	
	//U_RFATM03B() //Job para Eliminar residuos e enviar e-mail com aviso
	//U_RFATM02B() //Job Estorno Liberacao Clientes Devedores

	ConOut("> U_ITECX400: Final de Liberacao de Pedidos "+Time())

Endif

Return
