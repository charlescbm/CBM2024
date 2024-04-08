#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "ap5mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BFATR007   ºAutor  ³ Cezar J. P. Barater º Data ³  23/07/09º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Consulta se alguma nota fiscal de saida nao foi transmitidaº±±
±±º          ³ a Receita Federal durante o dia                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP		                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function BFATR007()
***********************

//Abre ambiente para trabalho
Prepare environment empresa '01' filial '01' tables 'SF2'

conout(" ")
conout("> BFATR007 - Consulta Nota Nao Transmitida ao Sefaz... Inicio: "+Time())
U_BFATR7A()
conout("> BFATR007 - Consulta Nota Nao Transmitida ao Sefaz... Fim: "+Time())
RESET ENVIRONMENT

Return()

//Filiais de Pecas
User Function BFATR7A()
************************
Local	aNota	:=	{}
Local	cDir	:= GetMV("MV_WFDIR"), cWFSaida := "ConsSaida_Nfe.htm", cWFEntrada := "ConsEntrada_Nfe.htm"  
Local   cParam  := GetMV("BR_000015")//Emails de usuários que recebem workflow 

//Coloco a barra no final do parametro do diretorio
If Substr(cDir,Len(cDir),1) != "\"
	cDir += "\"
Endif

//Busco Dados da Nota Fiscal de Saida  

For u := 1 To 1 //Quantidade de Empresas (Brascola e BrascolaTec)

	cQuery := " "
	cQuery += "SELECT F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, F2.F2_EMISSAO, F2.F2_HORA "
	If u == 1
		cQuery += "FROM SF2010 F2 "
		cQuery += "WHERE F2.D_E_L_E_T_ <> '*' "
		//cQuery += "AND F2.F2_FILIAL NOT IN('10','20') "
	/*ElseIf u == 2
		cQuery += "FROM  SF2300 F2 "
		cQuery += "WHERE F2.D_E_L_E_T_ <> '*' " */
	Endif
	
	cQuery += "AND F2.F2_CHVNFE = ' ' AND F2.F2_TIPO = 'N' "
	//cQuery += "AND F2_EMISSAO >= '20090401' "
	cQuery += "AND F2.F2_EMISSAO >= '"+Dtos(msdate()-30)+"' "
	cQuery += "ORDER BY F2.F2_DOC ASC "
	//cQuery := ChangeQuery(cQuery)
	
	
	If (Select("MSF2") <> 0)
		dbSelectArea("MSF2")
		dbCloseArea()
	Endif
	
	TCQuery cQuery NEW ALIAS "MSF2"
	TCSetField("MSF2","F2_EMISSAO","D",08,0)    

	
	cEmp	:=	''
	If MSF2->F2_FILIAL == '01' .And. u == 1
		cEmp	:=	'Brascola - Matriz-Jlle'
	ElseIf MSF2->F2_FILIAL == '02' .And. u == 1
		cEmp	:=	'Brascola - NHamburgo'
	ElseIf MSF2->F2_FILIAL == '03' .And. u == 1
		cEmp	:=	'Brascola - Franca'
	ElseIf MSF2->F2_FILIAL == '04' .And. u == 1
		cEmp	:=	'Brascola - Filial-Jlle'
	ElseIf MSF2->F2_FILIAL == '08' .And. u == 1
		cEmp	:=	'Brascola - SBC'  
	//ElseIf MSF2->F2_FILIAL == '01' .And. u == 2
		//cEmp	:=	'Brascola Tec'  	
	Endif
	
	If Empty(cEmp)
		If u == 1
			cEmp	:=	'Brascola'
		ElseIf u == 2
			cEmp	:=	'Brascola Tec'
		Endif
		Aadd(aNota,{"Nao Existe Nota Pendente","",Msdate(),Substr(Time(),1,5),cEmp})
	Endif
	
	DbSelectArea("MSF2")
	DbGotop()
	While !Eof()
		
		Aadd(aNota,{MSF2->F2_DOC,MSF2->F2_SERIE,MSF2->F2_EMISSAO,MSF2->F2_HORA,cEmp})
		
		DbSelectArea("MSF2")
		DbSkip()
		Loop
	Enddo
	
Next u                                              

//Inicio o processo do envio de workflow
oProcess := TWFProcess():New("BFATR007","Consulta Nota Fiscal Saida Nao Transmitida a Receita Federal")
oProcess:NewTask("BFATR007",cDir+cWFSaida)
oProcess:cSubject := "Consulta Nota Fiscal Saida Nao Transmitida a Receita Federal "
cParam := u_BXFormatEmail(cParam)
oProcess:cTo := cParam //"fmaia@brascola.com.br;charlesm@brascola.com.br"
oProcess:UserSiga := "000000"

For i:=1 To Len(aNota)
	
	aadd(oProcess:oHtml:ValByName("TB.nota"),Alltrim(aNota[i,1]))
	aadd(oProcess:oHtml:ValByName("TB.serie"),Alltrim(aNota[i,2]))
	aadd(oProcess:oHtml:ValByName("TB.emissao"),dToc(aNota[i,3]))
	aadd(oProcess:oHtml:ValByName("TB.hora"),Alltrim(aNota[i,4]))
	aadd(oProcess:oHtml:ValByName("TB.empresa"),Alltrim(aNota[i,5]))
	
Next i

//Envio email
oProcess:Start()
oProcess:Finish()

//Busco Dados da Nota Fiscal de Entrada
For u := 1 To 1
	
	cQuery := " "
	cQuery += " SELECT F1.F1_FILIAL, F1.F1_DOC, F1.F1_SERIE, F1.F1_DTDIGIT, F1.F1_HORA "
	If u == 1
		cQuery += "FROM  SF1010 F1 "
		cQuery += "WHERE F1.D_E_L_E_T_ <> '*' "
		//cQuery += "AND F1.F1_FILIAL NOT IN('10','20') "
	//ElseIf u == 2
	//	cQuery += "FROM  SF1300 F1 "
	//	cQuery += "WHERE F1.D_E_L_E_T_ <> '*' "
	Endif
	
	cQuery += "AND F1.F1_CHVNFE = ' ' AND F1.F1_TIPO IN('D','N') AND F1.F1_FORMUL = 'S' "
	cQuery += "AND F1.F1_DTDIGIT >= '"+Dtos(msdate()-30)+"' "
	//cQuery += "AND F1_DTDIGIT >= '20090801' "
	cQuery += "ORDER BY F1.F1_DOC ASC "
	//cQuery := ChangeQuery(cQuery)
	
	
	If (Select("MSF1") <> 0)
		dbSelectArea("MSF1")
		dbCloseArea()
	Endif
	
	TCQuery cQuery NEW ALIAS "MSF1"
	TCSetField("MSF1","F1_DTDIGIT","D",08,0)
	
	cEmp	:=	'' 
	If MSF1->F1_FILIAL == '01' .And. u == 1
		cEmp	:=	'Brascola - Matriz-Jlle'
	ElseIf MSF1->F1_FILIAL == '02' .And. u == 1
		cEmp	:=	'Brascola - NHamburgo'
	ElseIf MSF1->F1_FILIAL == '03' .And. u == 1
		cEmp	:=	'Brascola - Franca'
	ElseIf MSF1->F1_FILIAL == '04' .And. u == 1
		cEmp	:=	'Brascola - Filial-Jlle'
	ElseIf MSF1->F1_FILIAL == '08' .And. u == 1
		cEmp	:=	'Brascola - SBC'  
	//ElseIf MSF2->F2_FILIAL == '01' .And. u == 2
		//cEmp	:=	'Brascola Tec'  	
	Endif

	If Empty(cEmp)
		If u == 1
			cEmp	:=	'Brascola'
		ElseIf u == 2
			cEmp	:=	'Brascola Tec'
		Endif
		Aadd(aNota,{"Nao Existe Nota Pendente","",Msdate(),Substr(Time(),1,5),cEmp})
	Endif
	
	DbSelectArea("MSF1")
	DbGotop()
	While !Eof()
		
		Aadd(aNota,{MSF1->F1_DOC,MSF1->F1_SERIE,MSF1->F1_DTDIGIT,MSF1->F1_HORA,cEmp})
		
		DbSelectArea("MSF1")
		DbSkip()
		Loop
	Enddo
	
Next u

//Inicio o processo do envio de workflow
oProcess := TWFProcess():New("BFATR007","Consulta Nota Fiscal Entrada Nao Transmitida a Receita Federal")
oProcess:NewTask("BFATR007",cDir+cWFEntrada)
oProcess:cSubject := "Consulta Nota Fiscal Entrada Nao Transmitida a Receita Federal "
cParam := u_BXFormatEmail(cParam)
oProcess:cTo := cParam //"fmaia@brascola.com.br;charlesm@brascola.com.br"
oProcess:UserSiga := "000000"

For i:=1 To Len(aNota)
	
	aadd(oProcess:oHtml:ValByName("TB.nota"),Alltrim(aNota[i,1]))
	aadd(oProcess:oHtml:ValByName("TB.serie"),Alltrim(aNota[i,2]))
	aadd(oProcess:oHtml:ValByName("TB.emissao"),dToc(aNota[i,3]))
	aadd(oProcess:oHtml:ValByName("TB.hora"),Alltrim(aNota[i,4]))
	aadd(oProcess:oHtml:ValByName("TB.empresa"),Alltrim(aNota[i,5]))
	
Next i

//Envio email
oProcess:Start()
oProcess:Finish()

Return()