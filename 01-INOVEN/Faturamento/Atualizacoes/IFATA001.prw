#INCLUDE "Protheus.ch"    
#Include "TopConn.ch"

/**************************************************************************
* Rotina para acertar data do SE1                                         *
* DESENVOLVIDO POR INOVEN                                                 *
***************************************************************************/

User Function IFATA001()
**********************
//Private cPerg:= U_CriaPerg("UFINA050")
Private cPerg:= "IFATA001  "

U_ITECX010("IFATA001","Prorrogar Titulos Fin.")//Grava detalhes da rotina usada

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
SE1->(DbSetOrder(1))
SE1->(DbSeek(xFilial("SE1")+mv_par03+mv_par01))

ProcRegua(Val(mv_par02)-Val(mv_par01))

nContNF:= 0

While SE1->(!Eof()) .And. SE1->E1_FILIAL==xFilial("SE1") .And. SE1->E1_NUM<=mv_par02
	
	IncProc("Acertando vencimentos...  "+SE1->E1_NUM)
	
	If AllTrim(SE1->E1_TIPO)<>'NF'
		SE1->(DbSkip())
		Loop
	EndIf

	
	if !Empty(mv_par08)
	   IF alltrim(SE1->E1_NUM) $ AllTrim(mv_par08)
	       SE1->(DBSKIP())
	       LOOP
	   ENDIF
	ENDIF
	
	cEstadoCli:= Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_EST")
	
	If Empty(mv_par06)	
		If !Empty(mv_par07)
			If cEstadoCli $ AllTrim(mv_par07)
				SE1->(DbSkip())
				Loop
			EndIf	
		EndIf
	Else
		If !(cEstadoCli$AllTrim(mv_par06)) //.Or. cEstadoCli == mv_par07
			SE1->(DbSkip())
			Loop
		EndIf	
	EndIf
	
	If !Empty(mv_par08)	
		If !(AllTrim(SE1->E1_PARCELA)$AllTrim(mv_par08)) 
			SE1->(DbSkip())
			Loop
		EndIf	
	EndIf

               
	SE1->(RecLock("SE1", .f.))
    SE1->E1_ZVCTOOR:= SE1->E1_VENCREA
	SE1->E1_VENCTO := SE1->E1_VENCTO + mv_par04
	SE1->E1_VENCREA:= DataValida(SE1->E1_VENCTO, .t.)
	SE1->E1_VENCORI:= DataValida(SE1->E1_VENCTO, .t.)
	//SE1->E1_OBSERV := Iif(!Empty(mv_par05), mv_par05, "PRORR. + "+AllTrim(Transform(mv_par04,"@E 999999"))+" CONFORME SOLICITADO")
	SE1->(MsUnlock())

	nContNF++
	
	SE1->(DbSkip())
EndDo

//SE1->(DbCloseArea())

MsgAlert(AllTrim(Transform(nContNF,"@E 999999"))+" notas fiscais atualizadas.")

Return(Nil)



Static Function ValPergunte(cPerg)
*********************************
Local j, i
Local xPerg := cPerg

SX1->(DbSetOrder(1))

xPerg := Alltrim(xPerg)+Space(Len(SX1->X1_grupo)-Len(Alltrim(xPerg)))
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
	If !SX1->(DbSeek(xPerg+aRegs[i,2]))
		SX1->(RecLock("SX1",.T.))
		For j:=1 to Max(SX1->(FCount()), Len(aRegs[i]))
			SX1->(FieldPut(j,aRegs[i,j]))
		Next
		SX1->(MsUnlock())
		DbCommit()
	Endif
Next

Return
