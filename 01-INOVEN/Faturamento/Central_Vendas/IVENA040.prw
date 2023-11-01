#Include "Protheus.ch"      

Static oEndFat
Static cEndFat	:= Space(TamSx3("A1_END")[1])
Static oBaiFat
Static cBaiFat	:= Space(TamSx3("A1_BAIRRO")[1])
Static oMunFat
Static cMunFat	:= Space(TamSx3("A1_MUN")[1])
Static oEstFat
Static cEstFat	:= Space(TamSx3("A1_EST")[1])
Static oCepFat
Static cCepFat	:= Space(TamSx3("A1_CEP")[1]) 
Static oEndCob
Static cEndCob	:= Space(TamSx3("A1_ENDCOB")[1])
Static oBaiCob
Static cBaiCob	:= Space(TamSx3("A1_BAIRROC")[1])
Static oMunCob
Static cMunCob 	:= Space(TamSx3("A1_MUNC")[1])
Static oEstCob
Static cEstCob	:= Space(TamSx3("A1_ESTC")[1])
Static oCepCob
Static cCepCOb	:= Space(TamSx3("A1_CEPC")[1])
Static oEndEnt
Static cEndEnt	:= Space(TamSx3("A1_ENDENT")[1]) 
Static oBaiEnt
Static cBaiEnt	:= Space(TamSx3("A1_BAIRROE")[1])
Static oMunEnt
Static cMunEnt	:= Space(TamSx3("A1_MUNE")[1]) 
Static oEstEnt
Static cEstEnt	:= Space(TamSx3("A1_ESTE")[1]) 	
Static oCepEnt
Static cCepEnt	:= Space(TamSx3("A1_CEPE")[1])

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IVENA040 ºAutor  ³Microsiga           º Data ³  06/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para fazer a gravacao dos enderecos do cliente      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
//DESENVOLVIDO POR INOVEN

User Function IVENA040(lProsp,cCli,cLoj)
Local aArea		   := GetArea()
//Local aSizeAut 	   := MsAdvSize()
//Local aObjects	   := {}
//Local aInfo 	   := {}
//Local aPosObj	   := {}
//Local aTitles 	   := {}
//Local aButtons 	   := {}
//Local aListColumns := {}
//Local aTitulo 	   := {}
//Local bOk
//Local bCancel
//Local oList
//Local aArea
//Local nSaveSX8     := GetSX8Len()   
Local oGrpCob
Local oGrpEnt
Local oGrpFat  
//Local oBtnSlv	
Local oBtnSai
Local lSit         := lProsp

Private oDlgEnd	
Private aTela[0][0],aGets[0]
Private lLocRes	:= .F.	
Private cMarca  := GetMark()
Private aLugar  := { "", "", "", "" }   

If !Empty(cCli) .and. !Empty(cLoj)
	If lProsp
//		DbSelectArea("SUS")
//		DbSetOrder(1)
//		DbSeek(xFilial("SUS") + cod_cli + coja_cli ) 
		If !Empty(SUS->US_CODCLI) .and. !Empty(SUS->US_LOJACLI)
			lSit := .F.     // Prospect Virou Cliente então gravo no Cliente, esqueço o SUS
		Endif
	 	cEndCob	:= SUS->US_END
	 	cBaiCob	:= SUS->US_BAIRRO
	 	cMunCob	:= SUS->US_MUN
	 	cEstCob	:= SUS->US_EST
	 	cCepCOb	:= SUS->US_CEP
	Endif

	If lSit       			// É Prospect - atualizo SUS
		cEndFat	:= Space(TamSx3("A1_END")   [1])
	 	cBaiFat	:= Space(TamSx3("A1_BAIRRO")[1])
	 	cMunFat	:= Space(TamSx3("A1_MUN")   [1])
	 	cEstFat	:= Space(TamSx3("A1_EST")   [1])
	 	cCepFat	:= Space(TamSx3("A1_CEP")   [1]) 
	 	cEndCob	:= SUS->US_END
	 	cBaiCob	:= SUS->US_BAIRRO
	 	cMunCob	:= SUS->US_MUN
	 	cEstCob	:= SUS->US_EST
	 	cCepCOb	:= SUS->US_CEP
	 	cEndEnt	:= Space(TamSx3("A1_ENDENT") [1]) 
	 	cBaiEnt	:= Space(TamSx3("A1_BAIRROE")[1])
	 	cMunEnt	:= Space(TamSx3("A1_MUNE")   [1])
	 	cEstEnt	:= Space(TamSx3("A1_ESTE")   [1])
	 	cCepEnt	:= Space(TamSx3("A1_CEPE")   [1])
	Else
		// Não é Prospect OU o Prospect é Cliente, gravo no SA1
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+Alltrim(cCli) + AllTrim(cLoj))       
			cEndFat	:= SA1->A1_END
		 	cBaiFat	:= SA1->A1_BAIRRO
		 	cMunFat	:= SA1->A1_MUN
		 	cEstFat	:= SA1->A1_EST
		 	cCepFat	:= SA1->A1_CEP
		 	cEndCob	:= If(Empty(SA1->A1_ENDCOB),  cEndCob, SA1->A1_ENDCOB)
		 	cBaiCob	:= If(Empty(SA1->A1_BAIRROC), cBaiCob, SA1->A1_BAIRROC)
		 	cMunCob	:= If(Empty(SA1->A1_MUNC),	  cMunCob, SA1->A1_MUNC)
		 	cEstCob	:= If(Empty(SA1->A1_ESTC),	  cEstCob, SA1->A1_ESTC)
		 	cCepCOb	:= If(Empty(SA1->A1_CEPC),	  cCepCob, SA1->A1_CEPC)
		 	cEndEnt	:= If(Empty(SA1->A1_ENDENT),  cEndEnt, SA1->A1_ENDENT)
		 	cBaiEnt	:= If(Empty(SA1->A1_BAIRROE), cBaiEnt, SA1->A1_BAIRROE)
		 	cMunEnt	:= If(Empty(SA1->A1_MUNE),    cMunEnt, SA1->A1_MUNE)
		 	cEstEnt	:= If(Empty(SA1->A1_ESTE),    cEstEnt, SA1->A1_ESTE)
		 	cCepEnt	:= If(Empty(SA1->A1_CEPE),    cCepEnt, SA1->A1_CEPE)
		EndIf	
	EndIf
	
	DEFINE MSDIALOG oDlgEnd TITLE OemToAnsi("Endereços de Cliente") FROM C(200),C(300)  TO C(750),C(1100) OF oDlgVendas PIXEL         

	   	@ C(005),C(005) GROUP oGrpFat TO C(080),C(335) PROMPT "Faturamento"	OF oDlgEnd COLOR 0, 16777215 PIXEL  
		@ C(090),C(005) GROUP oGrpCob TO C(165),C(335) PROMPT "Cobrança" 	OF oDlgEnd COLOR 0, 16777215 PIXEL     
		@ C(175),C(005) GROUP oGrpEnt TO C(250),C(335) PROMPT "Entrega" 	OF oDlgEnd COLOR 0, 16777215 PIXEL
	    
		@ C(015),C(010) SAY oEndFat  PROMPT "Endereço" 		SIZE C(036),C(007) 	OF oGrpFat COLORS 0, 16777215 PIXEL   
		@ C(014),C(050) MSGET cEndFat  						SIZE C(270),C(009) 	OF oGrpFat COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_END') 	WHEN .F. PIXEL
		@ C(027),C(010) SAY oBaiFat	PROMPT "Bairro"			SIZE C(036),C(007) 	OF oGrpFat COLORS 0, 16777215 PIXEL
		@ C(026),C(050) MSGET cBaiFat  						SIZE C(270),C(009) 	OF oGrpFat COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_BAIRRO')	WHEN .F. PIXEL
		@ C(039),C(010) SAY oCepFat	PROMPT "CEP"			SIZE C(036),C(007) 	OF oGrpFat COLORS 0, 16777215 PIXEL  
		@ C(038),C(050) MSGET cCepFat  						SIZE C(270),C(009) 	OF oGrpFat COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_CEP') 	WHEN .F. PIXEL
		@ C(051),C(010) SAY oMunFat	PROMPT "Município"		SIZE C(036),C(007) 	OF oGrpFat COLORS 0, 16777215 PIXEL 
		@ C(050),C(050) MSGET cMunFat  						SIZE C(270),C(009) 	OF oGrpFat COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_MUN') 	WHEN .F. PIXEL 
		@ C(063),C(010) SAY oEstFat	PROMPT "Estado"	   		SIZE C(036),C(007) 	OF oGrpFat COLORS 0, 16777215 PIXEL    
		@ C(062),C(050) MSGET cEstFat  						SIZE C(270),C(009) 	OF oGrpFat COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_EST')  F3 "12" VALID ExistCpo("SX5","12"+cEstFat) WHEN .F. PIXEL 
		
		@ C(100),C(010) SAY oEndCob  PROMPT "Endereço" 		SIZE C(036),C(007) 	OF oGrpCob COLORS 0, 16777215 PIXEL
		@ C(099),C(050) MSGET cEndCob 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_ENDCOB') 	PIXEL WHEN .F.
		@ C(112),C(010) SAY oBaiCob	PROMPT "Bairro"			SIZE C(036),C(007) 	OF oGrpCob COLORS 0, 16777215 PIXEL
		@ C(111),C(050) MSGET cBaiCob						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_BAIRROC') PIXEL WHEN .F.
		@ C(124),C(010) SAY oCepCob	PROMPT "CEP"			SIZE C(036),C(007) 	OF oGrpCob COLORS 0, 16777215 PIXEL
	 	@ C(123),C(050) MSGET cCepCob 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_CEPC') 	PIXEL WHEN .F.
		@ C(136),C(010) SAY oMunCob	PROMPT "Município"		SIZE C(036),C(007) 	OF oGrpCob COLORS 0, 16777215 PIXEL
		@ C(135),C(050) MSGET cMunCob 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_MUNC') 	PIXEL   WHEN .F.
		@ C(148),C(010) SAY oEstCob	PROMPT "Estado"	   		SIZE C(036),C(007) 	OF oGrpCob COLORS 0, 16777215 PIXEL
		@ C(147),C(050) MSGET cEstCob 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_ESTC')  F3 "12" VALID ExistCpo("SX5","12"+cEstCob) PIXEL  WHEN .F.
		
		@ C(185),C(010) SAY oEndEnt  PROMPT "Endereço" 		SIZE C(036),C(007) 	OF oGrpEnt COLORS 0, 16777215 PIXEL   
		@ C(184),C(050) MSGET cEndEnt 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_ENDENT') 	WHEN .F. PIXEL     
		@ C(197),C(010) SAY oBaiEnt	PROMPT "Bairro"			SIZE C(036),C(007) 	OF oGrpEnt COLORS 0, 16777215 PIXEL
		@ C(196),C(050) MSGET cBaiEnt 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_BAIRROE') WHEN .F. PIXEL 
		@ C(209),C(010) SAY oCepEnt	PROMPT "CEP"			SIZE C(036),C(007) 	OF oGrpEnt COLORS 0, 16777215 PIXEL 
		@ C(208),C(050) MSGET cCepEnt 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_CEPE') 	WHEN .F. PIXEL 
		@ C(221),C(010) SAY oMunEnt	PROMPT "Município"		SIZE C(036),C(007) 	OF oGrpEnt COLORS 0, 16777215 PIXEL 
		@ C(220),C(050) MSGET cMunEnt 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_MUNE') 	WHEN .F. PIXEL  
		@ C(233),C(010) SAY oEstEnt	PROMPT "Estado"	   		SIZE C(036),C(007) 	OF oGrpEnt COLORS 0, 16777215 PIXEL 
		@ C(232),C(050) MSGET cEstEnt 						SIZE C(270),C(009) 	OF oGrpCob COLORS 0, 16777215 PICTURE PesqPict('SA1', 'A1_ESTE')  F3 "12" VALID ExistCpo("SX5","12"+cEstEnt) WHEN .F. PIXEL 
	
//	    @ C(010),C(350) BUTTON oBtnSlv PROMPT "&Atualizar"	SIZE C(049),C(012)  OF oDlgEnd ACTION DnyAtuEnd( lSit )	PIXEL
		@ C(030),C(350) BUTTON oBtnSai PROMPT "  &Sair   "	SIZE C(049),C(012)  OF oDlgEnd ACTION oDlgEnd:END()	    PIXEL
	
	ACTIVATE MSDIALOG oDlgEnd CENTERED

Else

//	Alert( "Selecione um Cliente antes de realizar a manutenção de Endereços do Cliente" )
	Alert( "Selecione um Cliente Antes de Realizar a Consulta de Endereços do Cliente" )

Endif

RestArea(aArea)
	
Return()         


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DNYATUEND ºAutor  ³Microsiga           º Data ³  06/29/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza enderecos do cliente                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function DNYATUEND( lSit )                     

If MsgYesNo("Deseja atualizar os endereços do cliente?")

	If lSit                     // É Prospect
//		DbSelectArea("SUS")
//		DbSetOrder(1)
//		If DbSeek(xFilial("SUS")+Alltrim(cod_cli) + AllTrim(coja_cli))       
			SUS->(RecLock("SUS"),.F.)
			SUS->US_END		:= cEndCob
		 	SUS->US_BAIRRO	:= cBaiCob
		 	SUS->US_MUN		:= cMunCob
		 	SUS->US_EST		:= cEstCob
		 	SUS->US_CEP		:= cCepCob
		 	SUS->(MsUnlock())	
//        Endif
	Else
			// É Cliente 
//		DbSelectArea("SA1")
//		DbSetOrder(1)
//		If DbSeek(xFilial("SA1") + AllTrim(cod_cli) + AllTrim(coja_cli) )  
			SA1->(RecLock("SA1"),.F.)
			SA1->A1_END 	:= cEndFat	 
		 	SA1->A1_BAIRRO 	:= cBaiFat	 
		 	SA1->A1_MUN 	:= cMunFat	 
		 	SA1->A1_EST		:= cEstFat	 
		 	SA1->A1_CEP		:= cCepFat	 
		 	SA1->A1_ENDCOB	:= cEndCob	 
		 	SA1->A1_BAIRROC	:= cBaiCob	 
		 	SA1->A1_MUNC	:= cMunCob	 
	   	 	SA1->A1_ESTC	:= cEstCob	 
		 	SA1->A1_CEPC	:= cCepCOb	 
		 	SA1->A1_ENDENT	:= cEndEnt	 
		 	SA1->A1_BAIRROE	:= cBaiEnt	 
		 	SA1->A1_MUNE	:= cMunEnt	
		 	SA1->A1_ESTE	:= cEstEnt	 
		 	SA1->A1_CEPE	:= cCepEnt
		 	SA1->(MsUnlock())	
//		EndIf     
	Endif
	Alert("Gravação realizada!")
	oDlgEnd:End()
EndIf	                            

Return()
