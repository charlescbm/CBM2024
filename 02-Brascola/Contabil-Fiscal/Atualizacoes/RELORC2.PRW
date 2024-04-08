#INCLUDE "Rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "dbTree.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa    ³ RELORC2  ³ Rel. de valores Reais x Orçados da Contabilidade             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Autor       ³ 02.04.09 ³ Zanardo / Thiago                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Observações ³ Especifico para Brascola                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
User Function RELORC2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cPerg  := "RELORC   " //U_CriaPerg("RELORC")
Private cAlias := "TRB"
Private titulo := "Lista Real x Orcado da Contabilidade"
Private cDesc1 := "O relatorio irá apresentar as informações dos valores real x orçado"
Private cDesc2 := "digitado no periodo"
Private cDesc3 := ""
Private cString:= "CT2"
Private aOrd   := {OemToAnsi("Por Grupo Contabil")	/*,OemToAnsi("Por C.Custo")*/}  
Private aRegs  := {}
Private cCadastro:= "Lista Real x Orcado da Contab."
Private	mvpar01
Private	mvpar02

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIfica se usuario esta cadastrado na SZO (amarracao com c.custo)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SZO")
dbSetOrder(1)
MsSeek(xFilial("SZO")+AllTrim(__cUserId))
If !Found()
	MsgBox("Usuário não autorizado a emitir este relatório. Verifique suas permissões com o depto de Custos.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ VerIfica as perguntas selecionadas                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
Aadd(aRegs,{cPerg,"01","Centro de Custo de  ?" ,"Centro de Custo de  ?" ,"Centro de Custo de  ?" ,"mv_ch1","C",9,0,0,"C","","mv_par01",""          ,""           ,""        ,"","",""           ,""           ,""           ,"","",""              ,""              ,""              ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"","CTT","S","","",""})
Aadd(aRegs,{cPerg,"02","Centro de Custo ate ?" ,"Centro de Custo ate ?" ,"Centro de Custo ate ?" ,"mv_ch2","C",9,0,0,"C","","mv_par02",""          ,""           ,""        ,"","",""           ,""           ,""           ,"","",""              ,""              ,""              ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"","CTT","S","","",""})
aAdd(aRegs,{cPerg,"03","Consolida ?"           ,"Consolida ?"           ,"Consolida ?"           ,"mv_ch3","N",1,0,1,"C","","mv_par03","Nao"       ,"Nao"        ,"Nao"     ,"","","Sim"        ,"Sim"        ,"Sim"        ,"","","Geral"         ,"Geral"         ,"Geral"         ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"",""   ,"S","","",""})
aAdd(aRegs,{cPerg,"04","Tipo de Consolidacao ?","Tipo de Consolidacao ?","Tipo de Consolidacao ?","mv_ch4","N",1,0,1,"C","","mv_par04","Direto"    ,"Direto"     ,"Direto"  ,"","","Indiretos"  ,"Indiretos"  ,"Indiretos"  ,"","","Administrativo","Administrativo","Administrativo","","","Comercial","Comercial","Comercial","","","Marketing","Marketing","Marketing","",""   ,"S","","",""})
aAdd(aRegs,{cPerg,"05","Data de ?"             ,"Data de ?"             ,"Data de ?"             ,"mv_ch5","D",8,0,0,"D","","mv_par05",""          ,""           ,""        ,"","",""           ,""           ,""           ,"","",""              ,"","","","","","",""             ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"",""   ,"S","","",""})
aAdd(aRegs,{cPerg,"06","Data Ate ?"            ,"Data Ate ?"            ,"Data Ate ?"            ,"mv_ch6","D",8,0,0,"D","","mv_par06",""          ,""           ,""        ,"","",""           ,""           ,""           ,"","",""              ,"","","","","","",""             ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"",""   ,"S","","",""})
aAdd(aRegs,{cPerg,"07","Data Referencia ?"     ,"Data Referencia ?"     ,"Data Referencia ?"     ,"mv_ch7","D",8,0,0,"D","","mv_par07",""          ,""           ,""        ,"","",""           ,""           ,""           ,"","",""              ,"","","","","","",""             ,"","",""         ,""         ,""         ,"","",""         ,""         ,""         ,"",""   ,"S","","",""})
lValidPerg(aRegs)
*/
Pergunte(cPerg,.t.)

If LastKey() = 27 
	Return  .F. 
Endif 

Processa({|| RunRePrv() },"Processando...")

Return NIL
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RunRePrv  ºAutor  ³Microsiga           º Data ³  03/18/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Rotina                                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RunRePrv()

If Upper(SubStr(AllTrim(SZO->ZO_CCUSTO),1,6))=="ZZZZZZ"
	
	If mv_par03 = 1 .OR. mv_par03 = 3
		mvpar01:=mv_par01
		mvpar02:=mv_par02
	Else
		If mv_par04 = 1
			mvpar01:=GetMV("BR_ORCDIR")
			If RTrim(GetMV("BR_ORCDIR1"))<>''
				mvpar01:=mvpar01+','+GetMV("BR_ORCDIR1")
			EndIf
		ElseIf mv_par04 = 2
			mvpar01:=GetMV("BR_ORCIND")
			If RTrim(GetMV("BR_ORCIND1"))<>''
				mvpar01:=mvpar01+','+GetMV("BR_ORCIND1")
			EndIf
		ElseIf mv_par04 = 3
			mvpar01:=GetMV("BR_ORCADM")
			If RTrim(GetMV("BR_ORCADM1"))<>''
				mvpar01:=mvpar01+','+GetMV("BR_ORCADM1")
			EndIf
		ElseIf mv_par04 = 4
			mvpar01:="'4422','1422','4427','1424','4428','1428',"+GetMV("BR_ORCCOM")
			If RTrim(GetMV("BR_ORCCOM1"))<>''
				mvpar01:=mvpar01+','+GetMV("BR_ORCCOM1")
			EndIf
		Else
			mvpar01:=GetMV("BR_ORCMKT")
			If RTrim(GetMV("BR_ORCMKT1"))<>''
				mvpar01:=mvpar01+','+GetMV("BR_ORCMKT1")
			EndIf
		EndIf
	EndIf
Else
	 
	If Empty(mv_par01) .and. Upper(SubStr(mv_par02,1,1))=="Z"
		mvpar01:= AllTrim(SZO->ZO_CCUSTO)
	Else
		//pesquisa no conteudo do campo se ok mvpar01=mv_par01
      	cVarAux1:= AllTrim(SZO->ZO_CCUSTO)
      	cVarAux1:= StrTran(cVarAux1,"'","")  
      	cVarAux1:= StrTran(cVarAux1,",","*")
      	
      	If Alltrim(mv_par01)==Alltrim(mv_par02)
	      	If Alltrim(mv_par01)$cVarAux1 
				mvpar01=mv_par01      		
			Else

			    MsgBox("Parametros invalidos! Verifique os parametros Centros de Custo De/Ate.")

				mvpar01=mv_par01      		
				mvpar02:=mv_par02
//			    Return
			EndIf
		Else
		    MsgBox("Parametros invalidos! Para informações agrupadas os centros de custo devem ser de branco a ZZZZ.")

			mvpar01=mv_par01      		
			mvpar02:=mv_par02
//		    Return
		EndIf
			
	EndIf

EndIf

mvpar06  := Month(mv_par06)
mvpar06A := Month(mv_par07)

Do Case
	Case Month(mv_par06) = 1
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData02:=_cData03:=_cData04:=_cData05:=_cData06:=_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 2
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData03:=_cData04:=_cData05:=_cData06:=_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 3
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData04:=_cData05:=_cData06:=_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 4
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData05:=_cData06:=_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 5
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData06:=_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 6
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData07:=_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 7
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData08:=_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 8
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-7,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData08:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData09:=_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 9
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-8,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-7,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData08:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData09:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData10:=_cData11:=_cData12:=''
	Case Month(mv_par06) = 10
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-9,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-8,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-7,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData08:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData09:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData10:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData11:=_cData12:=''
	Case Month(mv_par06) = 11
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-10,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-9,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-8,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-7,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData08:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData09:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData10:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData11:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
		_cData12:=''
	Case Month(mv_par06) = 12
		_cData01:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-11,2)
		_cData02:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-10,2)
		_cData03:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-9,2)
		_cData04:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-8,2)
		_cData05:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-7,2)
		_cData06:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-6,2)
		_cData07:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-5,2)
		_cData08:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-4,2)
		_cData09:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-3,2)
		_cData10:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-2,2)
		_cData11:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06)-1,2)
		_cData12:=StrZero(Year(mv_par06),4)+StrZero(Month(mv_par06),2)
EndCase

cQuery :="SELECT CT2_DEBITO,CT1_GRUPO CT1_GRUPO,CT2_TPSALD CT2_TPSALD,SUM(Janeiro) Janeiro ,SUM(Fevereiro) Fevereiro ,SUM(Marco) Marco ,SUM(Abril) Abril ,SUM(Maio) Maio ,SUM(Junho) Junho,"
cQuery +="SUM(Julho) Julho ,SUM(Agosto) Agosto ,SUM(Setembro) Setembro ,SUM(Outubro) Outubro ,SUM(Novembro) Novembro ,SUM(Dezembro) Dezembro FROM ("
cQuery +="SELECT CT2_DEBITO CT2_DEBITO,CT1_GRUPO CT1_GRUPO,CT2_TPSALD CT2_TPSALD,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData01+"' THEN CT2_VALOR ELSE 0 END) AS Janeiro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData02+"' THEN CT2_VALOR ELSE 0 END) AS Fevereiro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData03+"' THEN CT2_VALOR ELSE 0 END) AS Marco,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData04+"' THEN CT2_VALOR ELSE 0 END) AS Abril,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData05+"' THEN CT2_VALOR ELSE 0 END) AS Maio,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData06+"' THEN CT2_VALOR ELSE 0 END) AS Junho,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData07+"' THEN CT2_VALOR ELSE 0 END) AS Julho,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData08+"' THEN CT2_VALOR ELSE 0 END) AS Agosto,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData09+"' THEN CT2_VALOR ELSE 0 END) AS Setembro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData10+"' THEN CT2_VALOR ELSE 0 END) AS Outubro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData11+"' THEN CT2_VALOR ELSE 0 END) AS Novembro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData12+"' THEN CT2_VALOR ELSE 0 END) AS Dezembro"
cQuery +=" FROM " + RETSQLNAME("CT2")+' CT2,'+RETSQLNAME("CT1")+' CT1'
cQuery +=" WHERE CT2_TPSALD IN('1','2')"
If mv_par03 = 2
    If At("'",mvpar01) > 0
		cQuery +=" AND CT2_CCD IN ("+mvpar01+") "
	Else    
		cQuery +=" AND CT2_CCD = '"+mvpar01+"' "
	EndIf	
Else
	If Upper(SubStr(AllTrim(SZO->ZO_CCUSTO),1,6))=="ZZZZZZ"
		cQuery +=" AND CT2_CCD BETWEEN '"+mvpar01+"' AND '"+mvpar02+"'"
	Else
	    If At("'",mvpar01) > 0
			cQuery +=" AND CT2_CCD IN ("+mvpar01+") "
		Else    
			cQuery +=" AND CT2_CCD = '"+mvpar01+"' "
		EndIf		
	EndIf		
EndIf
cQuery +=" AND CT2_DATA BETWEEN  '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"'"
cQuery +=" AND CT2_DEBITO=CT1_CONTA"
cQuery +=" AND CT2_LOTE NOT IN ('777777','888888','5000','6000','999999')  "
cQuery +=" AND CT2.D_E_L_E_T_ = ''"
cQuery +=" AND CT1.D_E_L_E_T_ = ''"
cQuery +=" AND CT1_GRUPO <> ''"
cQuery +=" GROUP BY CT2_DEBITO,CT2_TPSALD,CT1_GRUPO"

cQuery +=" UNION"

cQuery +=" SELECT CT2_CREDIT CT2_DEBITO,CT1_GRUPO CT1_GRUPO,CT2_TPSALD CT2_TPSALD,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData01+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Janeiro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData02+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Fevereiro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData03+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Marco,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData04+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Abril,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData05+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Maio,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData06+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Junho,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData07+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Julho,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData08+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Agosto,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData09+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Setembro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData10+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Outubro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData11+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Novembro,"
cQuery +=" SUM(CASE WHEN SUBSTRING(CT2_DATA,1,6)='"+_cData12+"' THEN CT2_VALOR*-1 ELSE 0 END) AS Dezembro"
cQuery +=" FROM " + RETSQLNAME("CT2")+' CT2,'+RETSQLNAME("CT1")+' CT1'              
cQuery +=" WHERE CT2_TPSALD IN('1','2')"
If mv_par03 = 2
    If At("'",mvpar01) > 0
		cQuery +=" AND CT2_CCC IN ("+mvpar01+") "
	Else    
		cQuery +=" AND CT2_CCC = '"+mvpar01+"'"
	EndIf		
Else
	If Upper(SubStr(AllTrim(SZO->ZO_CCUSTO),1,6))=="ZZZZZZ"
		cQuery +=" AND CT2_CCC BETWEEN '"+mvpar01+"' AND '"+mvpar02+"'"
	Else
	    If At("'",mvpar01) > 0
			cQuery +=" AND CT2_CCC IN ("+mvpar01+") "
		Else    
			cQuery +=" AND CT2_CCC = '"+mvpar01+"'"
		EndIf		
	EndIf		
EndIf
cQuery +=" AND CT2_DATA BETWEEN  '"+DTOS(mv_par05)+"' AND '"+DTOS(mv_par06)+"'"
cQuery +=" AND CT2_CREDIT=CT1_CONTA"
cQuery +=" AND CT2_LOTE NOT IN ('777777','888888','5000','6000','999999')  "
cQuery +=" AND CT2.D_E_L_E_T_ = ''"
cQuery +=" AND CT1.D_E_L_E_T_ = ''"
cQuery +=" AND CT1_GRUPO <> ''"
cQuery +=" GROUP BY CT2_CREDIT,CT2_TPSALD,CT1_GRUPO"
cQuery +=") AGRUPA"
cQuery +=" GROUP BY CT2_DEBITO,CT2_TPSALD,CT1_GRUPO"
cQuery +=" ORDER BY CT1_GRUPO,CT2_DEBITO,CT2_TPSALD"

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'SLDORC',.F.,.T.)

aCampos:={}

Aadd(aCampos,{"GRUPO"      ,"C",008,0})
Aadd(aCampos,{"CONTA"      ,"C",015,0})
Aadd(aCampos,{"DESCRICAO"  ,"C",050,0})
Aadd(aCampos,{"JAN_REAL"   ,"N",016,2})
Aadd(aCampos,{"JAN_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_JAN"    ,"N",016,2})
Aadd(aCampos,{"FEV_REAL"   ,"N",016,2})
Aadd(aCampos,{"FEV_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_FEV"    ,"N",016,2})
Aadd(aCampos,{"MAR_REAL"   ,"N",016,2})
Aadd(aCampos,{"MAR_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_MAR"    ,"N",016,2})
Aadd(aCampos,{"ABR_REAL"   ,"N",016,2})
Aadd(aCampos,{"ABR_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_ABR"    ,"N",016,2})
Aadd(aCampos,{"MAI_REAL"   ,"N",016,2})
Aadd(aCampos,{"MAI_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_MAI"    ,"N",016,2})
Aadd(aCampos,{"JUN_REAL"   ,"N",016,2})
Aadd(aCampos,{"JUN_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_JUN"    ,"N",016,2})
Aadd(aCampos,{"JUL_REAL"   ,"N",016,2})
Aadd(aCampos,{"JUL_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_JUL"    ,"N",016,2})
Aadd(aCampos,{"AGO_REAL"   ,"N",016,2})
Aadd(aCampos,{"AGO_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_AGO"    ,"N",016,2})
Aadd(aCampos,{"SET_REAL"   ,"N",016,2})
Aadd(aCampos,{"SET_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_SET"    ,"N",016,2})
Aadd(aCampos,{"OUT_REAL"   ,"N",016,2})
Aadd(aCampos,{"OUT_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_OUT"    ,"N",016,2})
Aadd(aCampos,{"NOV_REAL"   ,"N",016,2})
Aadd(aCampos,{"NOV_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_NOV"    ,"N",016,2})
Aadd(aCampos,{"DEZ_REAL"   ,"N",016,2})
Aadd(aCampos,{"DEZ_ORC"    ,"N",016,2})
Aadd(aCampos,{"VAR_DEZ"    ,"N",016,2})
Aadd(aCampos,{"TOTAL_REAL" ,"N",016,2})
Aadd(aCampos,{"TOTALORCP"  ,"N",016,2})
Aadd(aCampos,{"VAR_TOTAL"  ,"N",016,2})
Aadd(aCampos,{"TOTAL_ORC"  ,"N",016,2})
Aadd(aCampos,{"MEDIA_REAL" ,"N",016,2})
Aadd(aCampos,{"MEDIA_ORC"  ,"N",016,2})

cKey    := "GRUPO+CONTA"
_cArqTmp:= CriaTrab(aCampos,.T.)
cIndex1 := CriaTrab(nil,.f.)

dbUseArea( .T.,,_cArqTmp, "TRB", .F., .F. )
IndRegua("TRB",cIndex1,cKey,,,OemToAnsi("Selecionando Registros..."))
RecLock("TRB",.T.)
Descricao:=	_cDescri:='REAL X PREVISTO - '+StrZero(Year(mv_par06),4)
MSUnlock()
 
DbSelectArea("SLDORC")
DbGoTop()

TOTG01R:=TOTG02R:=TOTG03R:=TOTG04R:=TOTG05R:=TOTG06R:=TOTG07R:=TOTG08R:=TOTG09R:=TOTG10R:=TOTG11R:=TOTG12R:=0
TOTG01O:=TOTG02O:=TOTG03O:=TOTG04O:=TOTG05O:=TOTG06O:=TOTG07O:=TOTG08O:=TOTG09O:=TOTG10O:=TOTG11O:=TOTG12O:=0

TOTALORCPG:= 0
TOTAL_ORCG:= 0

While !Eof()
	_cGrupo:= CT1_GRUPO
	
	DESCGRUPO:= POSICIONE("CTR",1,XFILIAL("CTR")+SLDORC->CT1_GRUPO,"CTR_DESC")
	
	TOT01R:=TOT02R:=TOT03R:=TOT04R:=TOT05R:=TOT06R:=TOT07R:=TOT08R:=TOT09R:=TOT10R:=TOT11R:=TOT12R:= 0
	TOT01O:=TOT02O:=TOT03O:=TOT04O:=TOT05O:=TOT06O:=TOT07O:=TOT08O:=TOT09O:=TOT10O:=TOT11O:=TOT12O:= 0

	TOTALORCPT:= 0
	TOTAL_ORCT:= 0
	
	While !Eof() .AND. ( CT1_GRUPO = _cGrupo )
		_cCta:= CT2_DEBITO
		
		RecLock( "TRB", .T. )
			GRUPO	 := _cGrupo
			CONTA	 := AllTrim( SLDORC->CT2_DEBITO )
			DESCRICAO:= POSICIONE( "CT1", 1, XFILIAL("CT1") + SLDORC->CT2_DEBITO , "CT1_DESC01" )
			
			DbSelectArea("SLDORC")
			
			While !Eof()  .And. ( CT1_GRUPO = _cGrupo ) .And. ( _cCta = CT2_DEBITO )
				DbSelectArea("TRB")
				
				If SLDORC->CT2_TPSALD = '1'
					// Total do real
					_cTotalR:=            If( mvpar06A >= 1 , SLDORC->janeiro  , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 2 , SLDORC->fevereiro, 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 3 , SLDORC->marco    , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 4 , SLDORC->abril    , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 5 , SLDORC->maio     , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 6 , SLDORC->junho    , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 7 , SLDORC->julho    , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 8 , SLDORC->agosto   , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 9 , SLDORC->setembro , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 10, SLDORC->outubro  , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 11, SLDORC->novembro , 0 )
					_cTotalR:= _cTotalR + If( mvpar06A >= 12, SLDORC->dezembro , 0 )
	
					// Media do real
					_cMediaR:= Round( _cTotalR / mvpar06A, 2 )
     
			        // Grava real
					JAN_REAL:= If( mvpar06A >= 1 , SLDORC->janeiro  , 0 )
					FEV_REAL:= If( mvpar06A >= 2 , SLDORC->fevereiro, 0 )
					MAR_REAL:= If( mvpar06A >= 3 , SLDORC->marco    , 0 )
					ABR_REAL:= If( mvpar06A >= 4 , SLDORC->abril    , 0 )
					MAI_REAL:= If( mvpar06A >= 5 , SLDORC->maio     , 0 )
					JUN_REAL:= If( mvpar06A >= 6 , SLDORC->junho    , 0 )
					JUL_REAL:= If( mvpar06A >= 7 , SLDORC->julho    , 0 )
					AGO_REAL:= If( mvpar06A >= 8 , SLDORC->agosto   , 0 )
					SET_REAL:= If( mvpar06A >= 9 , SLDORC->setembro , 0 )
					OUT_REAL:= If( mvpar06A >= 10, SLDORC->outubro  , 0 )
					NOV_REAL:= If( mvpar06A >= 11, SLDORC->novembro , 0 )
					DEZ_REAL:= If( mvpar06A >= 12, SLDORC->dezembro , 0 )
					
					// Somatória do real
					TOT01R:= TOT01R + If( mvpar06A >= 1 , SLDORC->janeiro  , 0 )
					TOT02R:= TOT02R + If( mvpar06A >= 2 , SLDORC->fevereiro, 0 )
					TOT03R:= TOT03R + If( mvpar06A >= 3 , SLDORC->marco    , 0 )
					TOT04R:= TOT04R + If( mvpar06A >= 4 , SLDORC->abril    , 0 )
					TOT05R:= TOT05R + If( mvpar06A >= 5 , SLDORC->maio     , 0 )
					TOT06R:= TOT06R + If( mvpar06A >= 6 , SLDORC->junho    , 0 )
					TOT07R:= TOT07R + If( mvpar06A >= 7 , SLDORC->julho    , 0 )
					TOT08R:= TOT08R + If( mvpar06A >= 8 , SLDORC->agosto   , 0 )
					TOT09R:= TOT09R + If( mvpar06A >= 9 , SLDORC->setembro , 0 )
					TOT10R:= TOT10R + If( mvpar06A >= 10, SLDORC->outubro  , 0 )
					TOT11R:= TOT11R + If( mvpar06A >= 11, SLDORC->novembro , 0 )
					TOT12R:= TOT12R + If( mvpar06A >= 12, SLDORC->dezembro , 0 )

					TOTAL_REAL:=  _cTotalR
					MEDIA_REAL:=  _cMediaR
				Else
					// Total orçado
					_cTotalO:=            If( mvpar06A >= 1 , SLDORC->janeiro  , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 2 , SLDORC->fevereiro, 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 3 , SLDORC->marco    , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 4 , SLDORC->abril    , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 5 , SLDORC->maio     , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 6 , SLDORC->junho    , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 7 , SLDORC->julho    , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 8 , SLDORC->agosto   , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 9 , SLDORC->setembro , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 10, SLDORC->outubro  , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 11, SLDORC->novembro , 0 )
					_cTotalO:= _cTotalO + If( mvpar06A >= 12, SLDORC->dezembro , 0 )
	
					// Grava o orçado
					JAN_ORC:=  SLDORC->janeiro   
					FEV_ORC:=  SLDORC->fevereiro 
					MAR_ORC:=  SLDORC->marco     
					ABR_ORC:=  SLDORC->abril     
					MAI_ORC:=  SLDORC->maio      
					JUN_ORC:=  SLDORC->junho     
					JUL_ORC:=  SLDORC->julho     
					AGO_ORC:=  SLDORC->agosto    
					SET_ORC:=  SLDORC->setembro  
					OUT_ORC:=  SLDORC->outubro   
					NOV_ORC:=  SLDORC->novembro  
					DEZ_ORC:=  SLDORC->dezembro  

					// Somatória do orçado
					TOT01O:= TOT01O + SLDORC->janeiro   
					TOT02O:= TOT02O + SLDORC->fevereiro 
					TOT03O:= TOT03O + SLDORC->marco     
					TOT04O:= TOT04O + SLDORC->abril     
					TOT05O:= TOT05O + SLDORC->maio      
					TOT06O:= TOT06O + SLDORC->junho     
					TOT07O:= TOT07O + SLDORC->julho     
					TOT08O:= TOT08O + SLDORC->agosto    
					TOT09O:= TOT09O + SLDORC->setembro  
					TOT10O:= TOT10O + SLDORC->outubro   
					TOT11O:= TOT11O + SLDORC->novembro  
					TOT12O:= TOT12O + SLDORC->dezembro  

					TOTAL_ORC := SLDORC->janeiro + SLDORC->fevereiro + SLDORC->marco    + SLDORC->abril   + SLDORC->maio     + SLDORC->junho +;
				                 SLDORC->julho   + SLDORC->agosto    + SLDORC->setembro + SLDORC->outubro + SLDORC->novembro + SLDORC->dezembro

					TOTAL_ORCT:= TOTAL_ORCT + SLDORC->janeiro + SLDORC->fevereiro + SLDORC->marco    + SLDORC->abril   + SLDORC->maio     + SLDORC->junho +;
									          SLDORC->julho   + SLDORC->agosto    + SLDORC->setembro + SLDORC->outubro + SLDORC->novembro + SLDORC->dezembro

					TOTALORCP := _cTotalO
					TOTALORCPT:= TOTALORCPT + _cTotalO

					// Media do orçado
					_cMediaO:= Round( TOTAL_ORC / mvpar06, 2 )

					MEDIA_ORC := _cMediaO
	
				EndIf
		
				DbSelectArea("SLDORC")
				DbSkip()
				
			EndDo

		MsUnlock()

		DbSelectArea("TRB")

        // Calcula a variação da linha
		RecLock("TRB",.F.)
			VAR_JAN  := ROUND((( JAN_REAL   / IIF( JAN_ORC   <> 0, JAN_ORC  , JAN_REAL   )) * 100) - 100, 2 )
			VAR_FEV  := ROUND((( FEV_REAL   / IIF( FEV_ORC   <> 0, FEV_ORC  , FEV_REAL   )) * 100) - 100, 2 )
			VAR_MAR  := ROUND((( MAR_REAL   / IIF( MAR_ORC   <> 0, MAR_ORC  , MAR_REAL   )) * 100) - 100, 2 )
			VAR_ABR  := ROUND((( ABR_REAL   / IIF( ABR_ORC   <> 0, ABR_ORC  , ABR_REAL   )) * 100) - 100, 2 )
			VAR_MAI  := ROUND((( MAI_REAL   / IIF( MAI_ORC   <> 0, MAI_ORC  , MAI_REAL   )) * 100) - 100, 2 )
			VAR_JUN  := ROUND((( JUN_REAL   / IIF( JUN_ORC   <> 0, JUN_ORC  , JUN_REAL   )) * 100) - 100, 2 )
			VAR_JUL  := ROUND((( JUL_REAL   / IIF( JUL_ORC   <> 0, JUL_ORC  , JUL_REAL   )) * 100) - 100, 2 )
			VAR_AGO  := ROUND((( AGO_REAL   / IIF( AGO_ORC   <> 0, AGO_ORC  , AGO_REAL   )) * 100) - 100, 2 )
			VAR_SET  := ROUND((( SET_REAL   / IIF( SET_ORC   <> 0, SET_ORC  , SET_REAL   )) * 100) - 100, 2 )
			VAR_OUT  := ROUND((( OUT_REAL   / IIF( OUT_ORC   <> 0, OUT_ORC  , OUT_REAL   )) * 100) - 100, 2 )
			VAR_NOV  := ROUND((( NOV_REAL   / IIF( NOV_ORC   <> 0, NOV_ORC  , NOV_REAL   )) * 100) - 100, 2 )
			VAR_DEZ  := ROUND((( DEZ_REAL   / IIF( DEZ_ORC   <> 0, DEZ_ORC  , DEZ_REAL   )) * 100) - 100, 2 )
			VAR_TOTAL:= ROUND((( TOTAL_REAL / IIF( TOTALORCP <> 0, TOTALORCP, TOTAL_REAL )) * 100) - 100, 2 )
		MSUnlock()
					
	EndDo

	RecLock("TRB",.T.)
		GRUPO		:= _cGrupo
		CONTA		:= 'TOTAL DO GRUPO ' + _cGrupo
		DESCRICAO	:= DESCGRUPO
		
		JAN_REAL	:= TOT01R
		FEV_REAL	:= TOT02R
		MAR_REAL	:= TOT03R
		ABR_REAL	:= TOT04R
		MAI_REAL	:= TOT05R
		JUN_REAL	:= TOT06R
		JUL_REAL	:= TOT07R
		AGO_REAL	:= TOT08R
		SET_REAL	:= TOT09R
		OUT_REAL	:= TOT10R
		NOV_REAL	:= TOT11R
		DEZ_REAL	:= TOT12R
		TOTAL_REAL	:= ( TOT01R + TOT02R + TOT03R + TOT04R + TOT05R + TOT06R + TOT07R + TOT08R + TOT09R + TOT10R + TOT11R + TOT12R )
		MEDIA_REAL	:= Round( ( TOT01R + TOT02R + TOT03R + TOT04R + TOT05R + TOT06R + TOT07R + TOT08R + TOT09R + TOT10R + TOT11R + TOT12R ) / mvpar06A, 2 )
		
		JAN_ORC		:= TOT01O
		FEV_ORC		:= TOT02O
		MAR_ORC		:= TOT03O
		ABR_ORC		:= TOT04O
		MAI_ORC		:= TOT05O
		JUN_ORC		:= TOT06O
		JUL_ORC		:= TOT07O
		AGO_ORC		:= TOT08O
		SET_ORC		:= TOT09O
		OUT_ORC		:= TOT10O
		NOV_ORC		:= TOT11O
		DEZ_ORC		:= TOT12O
		TOTAL_ORC	:= TOTAL_ORCT
		MEDIA_ORC   := Round( TOTAL_ORCT / mvpar06, 2 )
		
		VAR_JAN	 := ROUND((( JAN_REAL   / IIf( JAN_ORC  <> 0, JAN_ORC, 1 )) * 100) - 100, 2)
		VAR_FEV	 := ROUND((( FEV_REAL   / IIf( FEV_ORC  <> 0, FEV_ORC, 1 )) * 100) - 100, 2)
		VAR_MAR	 := ROUND((( MAR_REAL   / IIf( JAN_ORC  <> 0, MAR_ORC, 1 )) * 100) - 100, 2)
		VAR_ABR	 := ROUND((( ABR_REAL   / IIf( JAN_ORC  <> 0, ABR_ORC, 1 )) * 100) - 100, 2)
		VAR_MAI	 := ROUND((( MAI_REAL   / IIf( JAN_ORC  <> 0, MAI_ORC, 1 )) * 100) - 100, 2)
		VAR_JUN	 := ROUND((( JUN_REAL   / IIf( JAN_ORC  <> 0, JUN_ORC, 1 )) * 100) - 100, 2)
		VAR_JUL	 := ROUND((( JUL_REAL   / IIf( JAN_ORC  <> 0, JUL_ORC, 1 )) * 100) - 100, 2)
		VAR_AGO	 := ROUND((( AGO_REAL   / IIf( JAN_ORC  <> 0, AGO_ORC, 1 )) * 100) - 100, 2)
		VAR_SET	 := ROUND((( SET_REAL   / IIf( JAN_ORC  <> 0, SET_ORC, 1 )) * 100) - 100, 2)
		VAR_OUT	 := ROUND((( OUT_REAL   / IIf( JAN_ORC  <> 0, OUT_ORC, 1 )) * 100) - 100, 2)
		VAR_NOV	 := ROUND((( NOV_REAL   / IIf( JAN_ORC  <> 0, NOV_ORC, 1 )) * 100) - 100, 2)
		VAR_DEZ	 := ROUND((( DEZ_REAL   / IIf( JAN_ORC  <> 0, DEZ_ORC, 1 )) * 100) - 100, 2)
		VAR_TOTAL:= ROUND((( TOTAL_REAL / IIf( TOTAL_ORC<> 0,TOTAL_ORC,1 )) * 100) - 100, 2)

		TOTALORCP := TOTALORCPT

		TOTALORCPG:= TOTALORCPG + TOTALORCPT
		TOTAL_ORCG:= TOTAL_ORCG + TOTAL_ORCT
	
	MsUnlock()
	
	RecLock("TRB",.T.)
		GRUPO		:= _cGrupo
		CONTA		:= 'X========================'
	MsUnlock()
	
	TOTG01R	:= TOTG01R + TOT01R
	TOTG02R	:= TOTG02R + TOT02R
	TOTG03R	:= TOTG03R + TOT03R
	TOTG04R	:= TOTG04R + TOT04R
	TOTG05R	:= TOTG05R + TOT05R
	TOTG06R	:= TOTG06R + TOT06R
	TOTG07R	:= TOTG07R + TOT07R
	TOTG08R	:= TOTG08R + TOT08R
	TOTG09R	:= TOTG09R + TOT09R
	TOTG10R	:= TOTG10R + TOT10R
	TOTG11R	:= TOTG11R + TOT11R
	TOTG12R	:= TOTG12R + TOT12R
	
	TOTG01O	:= TOTG01O + TOT01O
	TOTG02O	:= TOTG02O + TOT02O
	TOTG03O	:= TOTG03O + TOT03O
	TOTG04O	:= TOTG04O + TOT04O
	TOTG05O	:= TOTG05O + TOT05O
	TOTG06O	:= TOTG06O + TOT06O
	TOTG07O	:= TOTG07O + TOT07O
	TOTG08O	:= TOTG08O + TOT08O
	TOTG09O	:= TOTG09O + TOT09O
	TOTG10O	:= TOTG10O + TOT10O
	TOTG11O	:= TOTG11O + TOT11O
	TOTG12O	:= TOTG12O + TOT12O
	
	DbSelectArea("SLDORC")

EndDo

RECLOCK("TRB",.T.)
	CONTA		:= 'TOTAL GERAL '
	GRUPO		:= '999'
	JAN_REAL	:= TOTG01R
	FEV_REAL	:= TOTG02R
	MAR_REAL	:= TOTG03R
	ABR_REAL	:= TOTG04R
	MAI_REAL	:= TOTG05R
	JUN_REAL	:= TOTG06R
	JUL_REAL	:= TOTG07R
	AGO_REAL	:= TOTG08R
	SET_REAL	:= TOTG09R
	OUT_REAL	:= TOTG10R
	NOV_REAL	:= TOTG11R
	DEZ_REAL	:= TOTG12R
	TOTAL_REAL	:= ( TOTG01R + TOTG02R + TOTG03R + TOTG04R + TOTG05R + TOTG06R + TOTG07R + TOTG08R + TOTG09R + TOTG10R + TOTG11R + TOTG12R )
	MEDIA_REAL	:= Round( ( TOTG01R + TOTG02R + TOTG03R + TOTG04R + TOTG05R + TOTG06R + TOTG07R + TOTG08R + TOTG09R + TOTG10R + TOTG11R + TOTG12R ) / mvpar06A, 2 )
	
	JAN_ORC		:= TOTG01O
	FEV_ORC		:= TOTG02O
	MAR_ORC		:= TOTG03O
	ABR_ORC		:= TOTG04O
	MAI_ORC		:= TOTG05O
	JUN_ORC		:= TOTG06O
	JUL_ORC		:= TOTG07O
	AGO_ORC		:= TOTG08O
	SET_ORC		:= TOTG09O
	OUT_ORC		:= TOTG10O
	NOV_ORC		:= TOTG11O
	DEZ_ORC		:= TOTG12O
	TOTAL_ORC	:= TOTAL_ORCG
	MEDIA_ORC	:= Round( TOTAL_ORCG / mvpar06, 2 )
	
	VAR_JAN	 := ROUND((( JAN_REAL  / IIf(JAN_ORC   <> 0, JAN_ORC  ,1)) * 100) - 100, 2)
	VAR_FEV	 := ROUND((( FEV_REAL  / IIf(FEV_ORC   <> 0, FEV_ORC  ,1)) * 100) - 100, 2)
	VAR_MAR	 := ROUND((( MAR_REAL  / IIf(JAN_ORC   <> 0, MAR_ORC  ,1)) * 100) - 100, 2)
	VAR_ABR	 := ROUND((( ABR_REAL  / IIf(JAN_ORC   <> 0, ABR_ORC  ,1)) * 100) - 100, 2)
	VAR_MAI	 := ROUND((( MAI_REAL  / IIf(JAN_ORC   <> 0, MAI_ORC  ,1)) * 100) - 100, 2)
	VAR_JUN	 := ROUND((( JUN_REAL  / IIf(JAN_ORC   <> 0, JUN_ORC  ,1)) * 100) - 100, 2)
	VAR_JUL	 := ROUND((( JUL_REAL  / IIf(JAN_ORC   <> 0, JUL_ORC  ,1)) * 100) - 100, 2)
	VAR_AGO	 := ROUND((( AGO_REAL  / IIf(JAN_ORC   <> 0, AGO_ORC  ,1)) * 100) - 100, 2)
	VAR_SET	 := ROUND((( SET_REAL  / IIf(JAN_ORC   <> 0, SET_ORC  ,1)) * 100) - 100, 2)
	VAR_OUT	 := ROUND((( OUT_REAL  / IIf(JAN_ORC   <> 0, OUT_ORC  ,1)) * 100) - 100, 2)
	VAR_NOV	 := ROUND((( NOV_REAL  / IIf(JAN_ORC   <> 0, NOV_ORC  ,1)) * 100) - 100, 2)
	VAR_DEZ	 := ROUND((( DEZ_REAL  / IIf(JAN_ORC   <> 0, DEZ_ORC  ,1)) * 100) - 100, 2)
	VAR_TOTAL:= ROUND((( TOTAL_REAL/ IIf(TOTAL_ORC <> 0, TOTAL_ORC,1)) * 100) - 100, 2)

	TOTALORCP:= TOTALORCPG	

MsUnlock()

Private cMarca    := ''
Private _aTela	  := ''
Private aRotina   := {}
Private aHeadSC6  := {}
Private _aCampos  := {}
Private aCores    := {}
Private aRotina   := {{"Imprimir"  , "U_RelOrc2b()"       ,0,0},;
				   	  {"Gera Excel", "U_ProcExcel('TRB')" ,0,0} }

_aTela   := {{"GRUPO"    ,"","GRUPO"}                      ,{"CONTA"    ,"","CONTA"}                      ,{"DESCRICAO","","DESCRICAO"},;
			{"JAN_REAL"  ,"","JAN/REAL"  ,"@E 999,999,999"},{"JAN_ORC"  ,"","JAN/ORC"   ,"@E 999,999,999"},{"VAR_JAN"  ,"","VAR/JAN"  ,"@ 999999,99"},;
			{"FEV_REAL"  ,"","FEV/REAL"  ,"@E 999,999,999"},{"FEV_ORC"  ,"","FEV/ORC"   ,"@E 999,999,999"},{"VAR_FEV"  ,"","VAR/FEV"  ,"@ 999999,99"},;
			{"MAR_REAL"  ,"","MAR/REAL"  ,"@E 999,999,999"},{"MAR_ORC"  ,"","MAR/ORC"   ,"@E 999,999,999"},{"VAR_MAR"  ,"","VAR/MAR"  ,"@ 999999,99"},;
			{"ABR_REAL"  ,"","ABR/REAL"  ,"@E 999,999,999"},{"ABR_ORC"  ,"","ABR/ORC"   ,"@E 999,999,999"},{"VAR_ABR"  ,"","VAR/ABR"  ,"@ 999999,99"},;
			{"MAI_REAL"  ,"","MAI/REAL"  ,"@E 999,999,999"},{"MAI_ORC"  ,"","MAI/ORC"   ,"@E 999,999,999"},{"VAR_MAI"  ,"","VAR/MAI"  ,"@ 999999,99"},;
			{"JUN_REAL"  ,"","JUN/REAL"  ,"@E 999,999,999"},{"JUN_ORC"  ,"","JUN/ORC"   ,"@E 999,999,999"},{"VAR_JUN"  ,"","VAR/JUN"  ,"@ 999999,99"},;
			{"JUL_REAL"  ,"","JUL/REAL"  ,"@E 999,999,999"},{"JUL_ORC"  ,"","JUL/ORC"   ,"@E 999,999,999"},{"VAR_JUL"  ,"","VAR/JUL"  ,"@ 999999,99"},;
			{"AGO_REAL"  ,"","AGO/REAL"  ,"@E 999,999,999"},{"AGO_ORC"  ,"","AGO/ORC"   ,"@E 999,999,999"},{"VAR_AGO"  ,"","VAR/AGO"  ,"@ 999999,99"},;
			{"SET_REAL"  ,"","SET/REAL"  ,"@E 999,999,999"},{"SET_ORC"  ,"","SET/ORC"   ,"@E 999,999,999"},{"VAR_SET"  ,"","VAR/SET"  ,"@ 999999,99"},;
			{"OUT_REAL"  ,"","OUT/REAL"  ,"@E 999,999,999"},{"OUT_ORC"  ,"","OUT/ORC"   ,"@E 999,999,999"},{"VAR_OUT"  ,"","VAR/OUT"  ,"@ 999999,99"},;
			{"NOV_REAL"  ,"","NOV/REAL"  ,"@E 999,999,999"},{"NOV_ORC"  ,"","NOV/ORC"   ,"@E 999,999,999"},{"VAR_NOV"  ,"","VAR/NOV"  ,"@ 999999,99"},;
			{"DEZ_REAL"  ,"","DEZ/REAL"  ,"@E 999,999,999"},{"DEZ_ORC"  ,"","DEZ/ORC"   ,"@E 999,999,999"},{"VAR_DEZ"  ,"","VAR/DEZ"  ,"@ 999999,99"},;
			{"TOTAL_REAL","","TOTAL/REAL","@E 999,999,999"},{"TOTALORCP","","TOTAL/ORCP","@E 999,999,999"},{"VAR_TOTAL","","VAR/TOTAL","@ 999999,99"},;
			{"MEDIA_REAL","","MEDIA/REAL","@E 999,999,999"},{"MEDIA_ORC","","MEDIA/ORC" ,"@E 999,999,999"},{"TOTAL_ORC","","TOTAL-GERAL/ORC","@E 999,999,999"}}


DbSelectArea("TRB")
DbGoTop()

cMarca:= GetMark()

MarkBrowse("TRB",,,_aTela,,cMarca)
	
DbSelectArea("SLDORC")
dbCloseArea()

DbSelectArea("TRB")
DbCloseArea()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelOrc2b  ºAutor  ³Microsiga           º Data ³  03/18/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Emissao de relatório                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RelOrc2b()

Private Tamanho := "G"
Private wnrel   := "RELORC2"
Private aReturn := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administração"), 2, 2, 1, "",1 }
Private nLastKey:= 0 
Private cKey, lContinua := .T.
Private li := 80 ,m_pag := 1, limite := 220
Private nTipo   := 0
Private	_cAno   := ""
Private	cabec1  := ""
Private	cabec2  := ""
                         
_cAno := StrZero(Year(mv_par06),4)
Cabec1:= "CONTA    DESCRICAO                                                         JAN/"+_cAno+"   FEV/"+_cAno+"   MAR/"+_cAno+"   ABR/"+_cAno+"   MAI/"+_cAno+"   JUN/"+_cAno+"   JUL/"+_cAno+"   AGO/"+_cAno+"   SET/"+_cAno+"   OUT/"+_cAno+"   NOV/"+_cAno+"   DEZ/"+_cAno+"   ACUMULADO"//  MEDIA"
Cabec2:= ""	
//        123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 1234567890
//                  1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21     220

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:= SetPrint(cString,wnrel,"",@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

dbSelectArea("SLDORC")
dbGoTop()

_cTtg01O:=_cTtg02O:=_cTtg03O:=_cTtg04O:=_cTtg05O:=_cTtg06O:=_cTtg07O:=_cTtg08O:=_cTtg09O:=_cTtg10O:=_cTtg11O:=_cTtg12O:= 0
_cTtg01R:=_cTtg02R:=_cTtg03R:=_cTtg04R:=_cTtg05R:=_cTtg06R:=_cTtg07R:=_cTtg08R:=_cTtg09R:=_cTtg10R:=_cTtg11R:=_cTtg12R:= 0
_tTgeral:=_cValImp:=nImpReal:=nImpOrca:= 0

While !Eof()
	_cGrupo:=CT1_GRUPO
	_tTgrpR:=_tTgrpO:=0
	
	_cTt01O:=_cTt02O:=_cTt03O:=_cTt04O:=_cTt05O:=_cTt06O:=_cTt07O:=_cTt08O:=_cTt09O:=_cTt10O:=_cTt11O:=_cTt12O:=0
	_cTt01R:=_cTt02R:=_cTt03R:=_cTt04R:=_cTt05R:=_cTt06R:=_cTt07R:=_cTt08R:=_cTt09R:=_cTt10R:=_cTt11R:=_cTt12R:=0
	
	While !Eof() .And. CT1_GRUPO==_cGrupo
		If li > 60
			cabec(titulo,cabec1,cabec2,wnrel,tamanho,ntipo)
		EndIf
		
		nDescPro := Posicione("CT1",1,xFilial("CT1")+SLDORC->CT2_DEBITO,"CT1_DESC01")
		_cCta    := CT2_DEBITO
		_cInicial:= _cTotalO:= _cTotalR:= 0
		lFirstLin:= .t.
		nImpReal := 0
		nImpOrca := 0
		
		While !Eof() .And. CT1_GRUPO==_cGrupo .And. _cCta==CT2_DEBITO
			_cMediaR:=_cTotalR/Month(mv_par06)

			Li++
			@ li,000 PSay AllTrim(_cCta)+' - '+SubStr(nDescPro,1,40)
			
			If SLDORC->CT2_TPSALD='1'
				_cTotalR:= SLDORC->janeiro + SLDORC->fevereiro + SLDORC->marco    + SLDORC->abril   + SLDORC->maio     + SLDORC->junho + ;
				           SLDORC->julho   + SLDORC->agosto    + SLDORC->setembro + SLDORC->outubro + SLDORC->novembro + SLDORC->dezembro
				
				_cTt01R:= _cTt01R + SLDORC->janeiro
				_cTt02R:= _cTt02R + SLDORC->fevereiro
				_cTt03R:= _cTt03R + SLDORC->marco
				_cTt04R:= _cTt04R + SLDORC->abril
				_cTt05R:= _cTt05R + SLDORC->maio
				_cTt06R:= _cTt06R + SLDORC->junho
				_cTt07R:= _cTt07R + SLDORC->julho
				_cTt08R:= _cTt08R + SLDORC->agosto
				_cTt09R:= _cTt09R + SLDORC->setembro
				_cTt10R:= _cTt10R + SLDORC->outubro
				_cTt11R:= _cTt11R + SLDORC->novembro
				_cTt12R:= _cTt12R + SLDORC->dezembro

				@ Li,065 PSay "REAL"
				@ Li,073 PSay SLDORC->janeiro 	 Picture '@E 99,999,999'
				@ Li,084 PSay SLDORC->fevereiro  Picture '@E 99,999,999'
				@ Li,095 PSay SLDORC->marco  	 Picture '@E 99,999,999'
				@ Li,106 PSay SLDORC->abril  	 Picture '@E 99,999,999'
				@ Li,117 PSay SLDORC->maio   	 Picture '@E 99,999,999'
				@ Li,128 PSay SLDORC->junho  	 Picture '@E 99,999,999'
				@ Li,139 PSay SLDORC->julho  	 Picture '@E 99,999,999'
				@ Li,150 PSay SLDORC->agosto  	 Picture '@E 99,999,999'
				@ Li,161 PSay SLDORC->setembro   Picture '@E 99,999,999'
				@ Li,172 PSay SLDORC->outubro  	 Picture '@E 99,999,999'
				@ Li,183 PSay SLDORC->novembro   Picture '@E 99,999,999'
				@ Li,194 PSay SLDORC->dezembro   Picture '@E 99,999,999'
				@ Li,205 PSay _cTotalR 		 	 Picture '@E 99,999,999'

				nImpReal:= 1
				lFirstLin:= .f.
				
				_tTgrpR:=_tTgrpR+_cTotalR
				
			Else
				_cTotalO:= SLDORC->janeiro + SLDORC->fevereiro + SLDORC->marco    + SLDORC->abril   + SLDORC->maio     + SLDORC->junho +;
				           SLDORC->julho   + SLDORC->agosto    + SLDORC->setembro + SLDORC->outubro + SLDORC->novembro + SLDORC->dezembro
				
				_cTt01O:= _cTt01O + SLDORC->janeiro
				_cTt02O:= _cTt02O + SLDORC->fevereiro
				_cTt03O:= _cTt03O + SLDORC->marco
				_cTt04O:= _cTt04O + SLDORC->abril
				_cTt05O:= _cTt05O + SLDORC->maio
				_cTt06O:= _cTt06O + SLDORC->junho
				_cTt07O:= _cTt07O + SLDORC->julho
				_cTt08O:= _cTt08O + SLDORC->agosto
				_cTt09O:= _cTt09O + SLDORC->setembro
				_cTt10O:= _cTt10O + SLDORC->outubro
				_cTt11O:= _cTt11O + SLDORC->novembro
				_cTt12O:= _cTt12O + SLDORC->dezembro
			    
				If lFirstLin
					@ Li,065 PSay "REAL"
					@ Li,073 PSay _cValImp	Picture '@E 99,999,999'
					@ Li,084 PSay _cValImp	Picture '@E 99,999,999'
					@ Li,095 PSay _cValImp	Picture '@E 99,999,999'
					@ Li,106 PSay _cValImp 	Picture '@E 99,999,999'
					@ Li,117 PSay _cValImp  Picture '@E 99,999,999'
					@ Li,128 PSay _cValImp 	Picture '@E 99,999,999'
					@ Li,139 PSay _cValImp 	Picture '@E 99,999,999'
					@ Li,150 PSay _cValImp 	Picture '@E 99,999,999'
					@ Li,161 PSay _cValImp  Picture '@E 99,999,999'
					@ Li,172 PSay _cValImp 	Picture '@E 99,999,999'
					@ Li,183 PSay _cValImp  Picture '@E 99,999,999'
					@ Li,194 PSay _cValImp  Picture '@E 99,999,999'
					@ Li,205 PSay _cValImp	Picture '@E 99,999,999'
		
					Li++
					@ Li,000 PSay AllTrim(_cCta)+' - '+SubStr(nDescPro,1,40)
				EndIf
			
				@ Li,065 PSay "ORCADO"
				@ Li,073 PSay SLDORC->janeiro 	 Picture '@E 99,999,999'
				@ Li,084 PSay SLDORC->fevereiro  Picture '@E 99,999,999'
				@ Li,095 PSay SLDORC->marco  	 Picture '@E 99,999,999'
				@ Li,106 PSay SLDORC->abril  	 Picture '@E 99,999,999'
				@ Li,117 PSay SLDORC->maio   	 Picture '@E 99,999,999'
				@ Li,128 PSay SLDORC->junho  	 Picture '@E 99,999,999'
				@ Li,139 PSay SLDORC->julho  	 Picture '@E 99,999,999'
				@ Li,150 PSay SLDORC->agosto  	 Picture '@E 99,999,999'
				@ Li,161 PSay SLDORC->setembro   Picture '@E 99,999,999'
				@ Li,172 PSay SLDORC->outubro  	 Picture '@E 99,999,999'
				@ Li,183 PSay SLDORC->novembro   Picture '@E 99,999,999'
				@ Li,194 PSay SLDORC->dezembro   Picture '@E 99,999,999'
				@ Li,205 PSay _cTotalO 		 	 Picture '@E 99,999,999'

				nImpOrca:= 1
				
				_tTgrpO:=_tTgrpO+_cTotalO

			EndIf

			DbSelectArea("SLDORC")
			DbSkip()
		EndDo

		If nImpReal==1 .And. nImpOrca==0
			Li++
			@ Li,000 PSay AllTrim(_cCta)+' - '+SubStr(nDescPro,1,40)
			@ Li,065 PSay "ORCADO"
			@ Li,073 PSay _cValImp	Picture '@E 99,999,999'
			@ Li,084 PSay _cValImp	Picture '@E 99,999,999'
			@ Li,095 PSay _cValImp	Picture '@E 99,999,999'
			@ Li,106 PSay _cValImp 	Picture '@E 99,999,999'
			@ Li,117 PSay _cValImp  Picture '@E 99,999,999'
			@ Li,128 PSay _cValImp 	Picture '@E 99,999,999'
			@ Li,139 PSay _cValImp 	Picture '@E 99,999,999'
			@ Li,150 PSay _cValImp 	Picture '@E 99,999,999'
			@ Li,161 PSay _cValImp  Picture '@E 99,999,999'
			@ Li,172 PSay _cValImp 	Picture '@E 99,999,999'
			@ Li,183 PSay _cValImp  Picture '@E 99,999,999'
			@ Li,194 PSay _cValImp  Picture '@E 99,999,999'
			@ Li,205 PSay _cValImp	Picture '@E 99,999,999'
		EndIf

		Li++
	EndDo

	Li++
	@ Li,000 PSay "TOTAL REAL DO GRUPO   : "+_cGrupo+'-'+Posicione("CTR",1,xFilial("CTR")+_cGrupo,"CTR_DESC")
	@ Li,073 PSay _cTt01R	Picture '@E 99,999,999'
	@ Li,084 PSay _cTt02R	Picture '@E 99,999,999'
	@ Li,095 PSay _cTt03R	Picture '@E 99,999,999'
	@ Li,106 PSay _cTt04R 	Picture '@E 99,999,999'
	@ Li,117 PSay _cTt05R   Picture '@E 99,999,999'
	@ Li,128 PSay _cTt06R 	Picture '@E 99,999,999'
	@ Li,139 PSay _cTt07R 	Picture '@E 99,999,999'
	@ Li,150 PSay _cTt08R 	Picture '@E 99,999,999'
	@ Li,161 PSay _cTt09R   Picture '@E 99,999,999'
	@ Li,172 PSay _cTt10R 	Picture '@E 99,999,999'
	@ Li,183 PSay _cTt11R   Picture '@E 99,999,999'
	@ Li,194 PSay _cTt12R   Picture '@E 99,999,999'
	@ Li,205 PSay _tTgrpR 	Picture '@E 99,999,999'
	
	Li++
	@ Li,000 PSay "TOTAL ORCADO DO GRUPO : "+_cGrupo+'-'+Posicione("CTR",1,xFilial("CTR")+_cGrupo,"CTR_DESC")
	@ Li,073 PSay _cTt01O	Picture '@E 99,999,999'
	@ Li,084 PSay _cTt02O	Picture '@E 99,999,999'
	@ Li,095 PSay _cTt03O	Picture '@E 99,999,999'
	@ Li,106 PSay _cTt04O 	Picture '@E 99,999,999'
	@ Li,117 PSay _cTt05O   Picture '@E 99,999,999'
	@ Li,128 PSay _cTt06O 	Picture '@E 99,999,999'
	@ Li,139 PSay _cTt07O 	Picture '@E 99,999,999'
	@ Li,150 PSay _cTt08O 	Picture '@E 99,999,999'
	@ Li,161 PSay _cTt09O   Picture '@E 99,999,999'
	@ Li,172 PSay _cTt10O 	Picture '@E 99,999,999'
	@ li,183 PSay _cTt11O   Picture '@E 99,999,999'
	@ Li,194 PSay _cTt12O   Picture '@E 99,999,999'
	@ Li,205 PSay _tTgrpO 	Picture '@E 99,999,999'
	
	@ ++Li,000 PSay __PrtThinLine()
	Li++
	
	_cTtg01O+=_cTt01O
	_cTtg02O+=_cTt02O
	_cTtg03O+=_cTt03O
	_cTtg04O+=_cTt04O
	_cTtg05O+=_cTt05O
	_cTtg06O+=_cTt06O
	_cTtg07O+=_cTt07O
	_cTtg08O+=_cTt08O
	_cTtg09O+=_cTt09O
	_cTtg10O+=_cTt10O
	_cTtg11O+=_cTt11O
	_cTtg12O+=_cTt12O
	_cTtg01R+=_cTt01R
	_cTtg02R+=_cTt02R
	_cTtg03R+=_cTt03R
	_cTtg04R+=_cTt04R
	_cTtg05R+=_cTt05R
	_cTtg06R+=_cTt06R
	_cTtg07R+=_cTt07R
	_cTtg08R+=_cTt08R
	_cTtg09R+=_cTt09R
	_cTtg10R+=_cTt10R
	_cTtg11R+=_cTt11R
	_cTtg12R+=_cTt12R
EndDo

@ li,000 PSay "TOTAL REAL GERAL   : "
@ li,073 PSay _cTtG01R	Picture '@E 99,999,999'
@ li,084 PSay _cTtG02R	Picture '@E 99,999,999'
@ li,095 PSay _cTtG03R	Picture '@E 99,999,999'
@ li,106 PSay _cTtG04R 	Picture '@E 99,999,999'
@ li,117 PSay _cTtG05R  Picture '@E 99,999,999'
@ li,128 PSay _cTtG06R 	Picture '@E 99,999,999'
@ li,139 PSay _cTtG07R 	Picture '@E 99,999,999'
@ li,150 PSay _cTtG08R 	Picture '@E 99,999,999'
@ li,161 PSay _cTtG09R  Picture '@E 99,999,999'
@ li,172 PSay _cTtG10R 	Picture '@E 99,999,999'
@ li,183 PSay _cTtG11R  Picture '@E 99,999,999'
@ li,194 PSay _cTtG12R  Picture '@E 99,999,999'
@ li,205 PSay _cTtG01R+_cTtG02R+_cTtG03R+_cTtG04R+_cTtG05R+_cTtG06R+_cTtG07R+_cTtG08R+_cTtG09R+_cTtG10R+_cTtG11R+_cTtG12R Picture '@E 99,999,999'

Li++
@ li,000 PSay "TOTAL ORCADO GERAL : "
@ li,073 PSay _cTtG01O	Picture '@E 99,999,999'
@ li,084 PSay _cTtG02O	Picture '@E 99,999,999'
@ li,095 PSay _cTtG03O	Picture '@E 99,999,999'
@ li,106 PSay _cTtG04O 	Picture '@E 99,999,999'
@ li,117 PSay _cTtG05O  Picture '@E 99,999,999'
@ li,128 PSay _cTtG06O 	Picture '@E 99,999,999'
@ li,139 PSay _cTtG07O 	Picture '@E 99,999,999'
@ li,150 PSay _cTtG08O 	Picture '@E 99,999,999'
@ li,161 PSay _cTtG09O  Picture '@E 99,999,999'
@ li,172 PSay _cTtG10O 	Picture '@E 99,999,999'
@ li,183 PSay _cTtG11O  Picture '@E 99,999,999'
@ li,194 PSay _cTtG12O  Picture '@E 99,999,999'
@ li,205 PSay _cTtG01O+_cTtG02O+_cTtG03O+_cTtG04O+_cTtG05O+_cTtG06O+_cTtG07O+_cTtG08O+_cTtG09O+_cTtG10O+_cTtG11O+_cTtG12O Picture '@E 99,999,999'

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return