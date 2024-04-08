#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "ap5mail.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBFATR006   บ Autor ณ Paulo Bindo       บ Data ณ  10/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Grafico de Faturamento                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function BFATR006()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local aDados := {}
Local nz:=0
Local dData
Local oRadio := {"Diario","Mensal","Anual"}
Local oDlg2
Private cTitulo:="Faturamento - "
Private cPerg := "BFATR006"
Private mv_par03:= 1
Private aGraph := {} // DATA, VALOR

  
U_BCFGA002("BFATR006")//Grava detalhes da rotina usada

cPerg	:=	cPerg+space((Len(SX1->X1_GRUPO)-len(cperg))) //Altera็ใo devido a versao 10 (tamanho do X1_GRUPO)


dbSelectArea("SX1")
dbSetOrder(1)
if !dbseek(cPerg)
	//	PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng  	,cVar    ,cTipo,nTam,nDec,nPres,cGSC,cValid		,cF3	, cGrpSxg,cPyme	,cVar01		,cDef01,cDefSpa1,cDefEng1,cCnt01, cDef02,cDefSpa2,cDefEng2,cDef03		,cDefSpa3,cDefEng3 , cDef04		,cDefSpa4,cDefEng4, cDef05		,cDefSpa5,cDefEng5, aHelpPor,aHelpEng,aHelpSpa,cHelp)
	PutSx1(cPerg,"01","Da  Data           ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Ate a Data         ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Opcao              ?","","","mv_ch03","C",01,0,0,"C","","mv_par03","Diario","","","","","Mensal","","","","","Anual","","","","","","","","","","","","","","","","")
endif

//If !Pergunte(cPerg,.T.)
  //	Return
//Endif


//validPerg()
If Pergunte("BFATR006",.T.)
	
	// DIARIO
	If(mv_par03) == "1"
		cTitulo+="Diario"+" x "+"Valor"+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL
		// MENSAL
	ElseIf(mv_par03) == "2"
		cTitulo+="Mensal"+" x "+"Valor"+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL
		// ANUAL
	ElseIf(mv_par03) == "3"
		cTitulo+="Anual"+" x "+"Valor"+" - "+AllTrim(SM0->M0_NOME)+"/"+SM0->M0_FILIAL
	EndIf
	
	MsgRun("Selecionando os Registros, Aguarde...","",{|| CursorWait(), DADOS(70,80) ,CursorArrow()})
	
	// Chama funcao generica para montagem de grafico
	/*
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณDescri…o ณ Funcao generica para montagem de dialog com grafico        ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	ฑฑณParametrosณ                                                            ณฑฑ
	ฑฑณ        01ณ ExpC1 = Titulo da Janela                                   ณฑฑ
	ฑฑณ        02ณ ExpL1 = Flag indicando se inicializa grafico em 3 dimensoesณฑฑ
	ฑฑณ        03ณ ExpL2 = Flag indicando se mostra menu para mudar caracterisณฑฑ
	ฑฑณ          ณ ticas do grafico como tipo e numero de dimensoes (2 ou 3)  ณฑฑ
	ฑฑณ        04ณ ExpL3 = Indica se muda a cor em cada barra ou faixa de vlr ณฑฑ
	ฑฑณ        05ณ ExpN1 = Indica o tipo inicial do grafico                   ณฑฑ
	ฑฑณ        06ณ ExpN2 = Indica a cor inicial dos valores apresentados      ณฑฑ
	ฑฑณ        07ณ ExpA1 = Array com os dados a serem apresentados. Dimensoes:ณฑฑ
	ฑฑณ          ณ [1] Nome a ser colocado no eixo x (Caracter)               ณฑฑ
	ฑฑณ          ณ [2] Valor do eixo y (Numerico)                             ณฑฑ
	ฑฑณ        08ณ ExpC2 = Alias do arquivo de trabalho que contem os dados   ณฑฑ
	ฑฑณ        09ณ ExpA2 = Array com os campos que devem ter o conteudo lido  ณฑฑ
	ฑฑณ          ณ [1] Nome do campo que tem os dados do eixo x (Caracter)    ณฑฑ
	ฑฑณ          ณ [2] Nome do campo que tem os valores do eixo y (Caracter)  ณฑฑ
	ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
	*/
	
	MatGraph(cTitulo,.T.,.T.,.T.,2,5,aGraph)
	EnviaEmail()
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDADOS     บAutor  ณPaulo Bindo         บ Data ณ  12/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta a array com o faturamento diแrio                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function DADOS()


If (mv_par03) == "1"
	cQuery := " SELECT SUM(D2_TOTAL) D2_TOTAL, D2_EMISSAO FROM SD2010"
ElseIf (mv_par03) == "2"
	cQuery := " SELECT SUM(D2_TOTAL) D2_TOTAL, SUBSTRING(D2_EMISSAO,1,6) D2_EMISSAO FROM SD2010"
ElseIf (mv_par03) == "3"
	cQuery := " SELECT SUM(D2_TOTAL) D2_TOTAL, SUBSTRING(D2_EMISSAO,1,4) D2_EMISSAO FROM SD2010"
EndIf

cQuery += " INNER JOIN SF4010 ON F4_CODIGO = D2_TES AND F4_DUPLIC = 'S'"
cQuery += " WHERE D2_EMISSAO BETWEEN  '"+DTOS(mv_par01)+"' AND '"+DTOS(mv_par02)+"' AND SD2010.D_E_L_E_T_ <> '*'"

If (mv_par03) == "1"
	cQuery += " GROUP BY D2_EMISSAO"
	cQuery += " ORDER BY D2_EMISSAO"
ElseIf (mv_par03) == "2"
	cQuery += " GROUP BY SUBSTRING(D2_EMISSAO,1,6)"
	cQuery += " ORDER BY SUBSTRING(D2_EMISSAO,1,6)"
ElseIf (mv_par03) == '3"
	cQuery += " GROUP BY SUBSTRING(D2_EMISSAO,1,4)"
	cQuery += " ORDER BY SUBSTRING(D2_EMISSAO,1,4)"
EndIf

TcQuery cQuery New Alias("QRYDIA")
If (mv_par03) == "1"
	TCSETFIELD("QRYDIA","D2_EMISSAO","D")
EndIf

dbSelectArea("QRYDIA")

While ! EOF()
	If mv_par03 == "1" 
		aAdd(aGraph,{DTOC(D2_EMISSAO), D2_TOTAL})
	ElseIf mv_par03 =="2"
		aAdd(aGraph,{SubStr(D2_EMISSAO,5,2)+"/"+SubStr(D2_EMISSAO,1,4), D2_TOTAL})
	Else
		aAdd(aGraph,{D2_EMISSAO, D2_TOTAL})
	EndIf
	dbSkip()
End
dbCloseArea("QRYDIA")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณENVIAEMAILบAutor  ณMicrosiga           บ Data ณ  12/12/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ENVIAEMAIL()

Local lResult   := .f.				// Resultado da tentativa de comunicacao com servidor de E-Mail
Local cTitulo1

cDestin := "fmaia@brascola.com.br"
cTitulo1:= "Aviso de visualiza็ใo"
cMensagem:= "O Grแfico "+cTitulo+" foi gerado pelo usuario "+Alltrim(cUsername);
			+"no dia "+DTOC(DDATABASE)+" as "+SubStr(Time(),1,5)
cAnexo:= ""


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tenta conexao com o servidor de E-Mail ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
CONNECT SMTP                         ;
	SERVER 	 GetMV("MV_RELSERV"); 	// Nome do servidor de e-mail
	ACCOUNT  GetMV("MV_RELACNT"); 	// Nome da conta a ser usada no e-mail
	PASSWORD GetMV("MV_RELPSW") ; 	// Senha
RESULT lResult             	// Resultado da tentativa de conexใo

If !lResult
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Nao foi possivel estabelecer conexao com o servidor ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Help(" ",1,"ACAA170_01") 	// _cErro := MailGetErr()
	
Else
	
	SEND MAIL;
	FROM 		GetMV("MV_RELACNT");
	TO 		cDestin;
	SUBJECT 	cTitulo;
	BODY 		cMensagem;
	RESULT 	lResult
	
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza conexao com o servidor de E-Mail ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	DISCONNECT SMTP SERVER
	
EndIf

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBFATR006   บAutor  ณMicrosiga           บ Data ณ  12/10/03   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg()
Private i,j
dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
aRegs:={}
// Grupo/Ordem/Pergunta/Perg.Espanhol/Perg.Ingles/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefIng1/Cnt01/Var02/Def02/DefSPA2/DefIng2/Cnt02/Var03/Def03/DefSPA3/DefIng3/Cnt03/Var04/Def04/DefSPA4/DefIng4/Cnt04/Var05/Def05/DefSPA5/DefIng5/Cnt05/Alias/Grupo
AADD(aRegs,{cPerg,"01","Da  Data           ?","","","mv_ch01","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Ate a Data         ?","","","mv_ch02","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Opcao              ?","","","mv_ch03","C",01,0,0,"C","","mv_par03","Diario","","","","","Mensal","","","","","Anual","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		/*For j:=1 to len(aRegs[i])
			FieldPut(j,aRegs[i,j])
		Next     */ 
		For j:=1 to Max(FCount(), Len(aRegs[i]))
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
		dbCommit()
	Endif
Next
Return
