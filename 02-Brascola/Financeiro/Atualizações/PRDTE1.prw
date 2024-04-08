/**************************************************************************
* Rotina para acertar data do SE1                                         *
* Cleiton - 28/12/2007                                                    *
*         - 18/12/2009 - Alter: Thiago (Onsten) - Inclusao de parametros  *
* Uso     - Exclusivo da Brascola                                         *
***************************************************************************/


User Function PRDTE1()
**********************
Private cPerg:= U_CriaPerg("PRDTE1")

U_BCFGA002("PRDTE1")//Grava detalhes da rotina usada

ValPergunte(cPerg)

If !Pergunte(cPerg)
	Return
EndIf	

If MsgYesNo("Deseja realmente alterar os vencimentos das duplicatas conforme informado nos parametros?")
	Processa({ ||U_PRDTE1BR()}, "Aguarde...",,.t.)
EndIf	

Return



User Function PRDTE1BR()
************************
DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+mv_par03+mv_par01)

ProcRegua(Val(mv_par02)-Val(mv_par01))

nContNF:= 0

While !Eof() .And. E1_FILIAL==xFilial("SE1") .And. E1_NUM<=mv_par02
	
	IncProc("Acertando vencimentos...  "+SE1->E1_NUM)
	
	If AllTrim(SE1->E1_TIPO)<>'NF'
		DbSkip()
		Loop
	EndIf

	
	if !Empty(mv_par08)
	   IF alltrim(SE1->E1_NUM) $ AllTrim(mv_par08)
	       DBSKIP()
	       LOOP
	   ENDIF
	ENDIF
	
	cEstadoCli:= Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_EST")
	
	If Empty(mv_par06)	
		If !Empty(mv_par07)
			If cEstadoCli $ AllTrim(mv_par07)
				DbSelectArea("SE1")
				DbSkip()
				Loop
			EndIf	
		EndIf
	Else
		If !(cEstadoCli$AllTrim(mv_par06)) //.Or. cEstadoCli == mv_par07
			DbSelectArea("SE1")
			DbSkip()
			Loop
		EndIf	
	EndIf
	
	If !Empty(mv_par08)	
		If !(AllTrim(SE1->E1_PARCELA)$AllTrim(mv_par08)) 
			DbSelectArea("SE1")
			DbSkip()
			Loop
		EndIf	
	EndIf

               
	While !RecLock("SE1", .f.)
	EndDo
	
	SE1->E1_X_VENCP:= SE1->E1_VENCTO
	SE1->E1_VENCTO := E1_VENCTO + mv_par04
	SE1->E1_VENCREA:= DataValida(E1_VENCTO, .t.)
	SE1->E1_OBSERV := Iif(!Empty(mv_par05), mv_par05, "PRORR. + "+AllTrim(Transform(mv_par04,"@E 999999"))+" CONFORME SOLICITADO")
	MsUnlock()

	nContNF++
	
	DbSkip()
EndDo

SE1->(DbCloseArea())

MsgAlert(AllTrim(Transform(nContNF,"@E 999999"))+" notas fiscais atualizadas.")

Return(Nil)



Static Function ValPergunte(cPerg)
*********************************
DbSelectArea("SX1")
DbSetOrder(1)

aRegs:= {}
//          Grupo/Ordem/Pergunta/                              Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01     /Def01                    /Cnt01/Var02/Def02                  /Cnt02/Var03/Def03                     /Cnt03/Var04/Def04                    /Cnt04/Var05/Def05         /Cnt05 /F3   /Pyme /GrpSXG /Help /Picture/IDFil
aAdd(aRegs,{cPerg,"01" ,"Nota Fiscal De? "              ,"","","mv_ch1","C" ,9      ,0      ,0     ,"G",""   ,"mv_par01",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"02" ,"Nota Fiscal Ate?"              ,"","","mv_ch2","C" ,9      ,0      ,0     ,"G",""   ,"mv_par02",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"SF2",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"03" ,"Serie? "                       ,"","","mv_ch3","C" ,3      ,0      ,0     ,"G",""   ,"mv_par03",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"04" ,"Dias a Prorrogar?"             ,"","","mv_ch4","N" ,8      ,0      ,0     ,"G",""   ,"mv_par04",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"05" ,"Mensagem para Obs.:"           ,"","","mv_ch5","C" ,60     ,0      ,0     ,"G",""   ,"mv_par05",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"06" ,"Estado:  (Em Branco = Todos) " ,"","","mv_ch6","C" ,60     ,0      ,0     ,"G",""   ,"mv_par06",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"07" ,"Exceto Estado:"                ,"","","mv_ch7","C" ,60     ,0      ,0     ,"G",""   ,"mv_par07",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"12 ",""    ,""     ,""   ,"",    ""})
aAdd(aRegs,{cPerg,"08" ,"Parcelas:(Em Branco = Todos) " ,"","","mv_ch8","C" ,15     ,0      ,0     ,"G",""   ,"mv_par08",""                ,"","" ,""   ,""   ,""              ,"","" ,""   ,""   ,""                 ,"","" ,""   ,""   ,""                ,"","" ,""   ,""   ,"",     "","" ,""    ,"   ",""    ,""     ,""   ,"",    ""})

For i:=1 to Len(aRegs)
	If !DbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		DbCommit()
	Endif
Next

Return