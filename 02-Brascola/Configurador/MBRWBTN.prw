#include "Rwmake.ch" 
#include "Protheus.ch"
#include "Topconn.ch"    
#include "TbiConn.ch"

/*/
----------------------------------------------------------------------------
PROGRAMA: MBRWBTN        AUTOR: FERNANDO S. MAIA           DATA: 19/12/11
----------------------------------------------------------------------------

DESCRICAO: Ponto de Entrada para controlar um botao pressionado na MBROWSE.
           Sera acessado em qualquer programa que utilize esta funcao.
----------------------------------------------------------------------------
CONTROLE DE ALTERACOES

DATA:                     AUTOR:
OBJETIVO:
----------------------------------------------------------------------------
/*/     

/*
¦¦¦Parametros¦ Enviado ao Ponto de Entrada um vetor com 3 informacoes: ¦¦¦
¦¦¦ ¦ PARAMIXB[1] = Alias atual; ¦¦¦
¦¦¦ ¦ PARAMIXB[2] = Registro atual; ¦¦¦
¦¦¦ ¦ PARAMIXB[3] = Numero da opcao selecionada ¦¦¦
PARAMIXB[3]:
Incluir = 3
Alterar = 4
Excluir = 5
*/

User Function MBRWBTN()

lRet:= .T.
nBotao:= PARAMIXB[3]
cFuncao:= ""
cRotina:= AllTrim(FunName())

Private cString := "SZA"
cQuery := ""
cQuery += "SELECT *  "
cQuery += "FROM "+RetSqlName("SZA")+" (NOLOCK) "
cQuery += "WHERE D_E_L_E_T_ = '' "
cQuery += "AND ZA_ROTINA = '"+cRotina+"' ORDER BY ZA_ROTINA"
cQuery := ChangeQuery(cQuery)

If Select("FER") <> 0
	dbSelectArea("FER")
	dbCloseArea()
Endif

TCQuery cQuery NEW ALIAS "FER"

DbSelectArea("FER")
dbGotop()

cFuncao:= AllTrim((FER->ZA_FUNCAO))

If  (AllTrim(Str(nBotao)) $ AllTrim(cFuncao))
	
	If (AllTrim(FER->ZA_ROTINA) == cRotina)
		cTitulo:= FER->ZA_TITULO
		cMensagem:= FER->ZA_MENSAGE
		cUsuario1:= FER->ZA_USER1
		cUsuario2:= FER->ZA_USER2
		
		If  AllTrim(Upper(cUsername)) $ AllTrim(Upper(AllTrim(cUsuario1)+"/"+AllTrim(cUsuario2)))
			lRet:= .T.
		Else
			Aviso(cTitulo,cMensagem+cTitulo,{"&Ok"},,"Usuário : "+AllTrim(cUserName))
			lRet:= .F.
		EndIf
	Endif
	
	DbSelectArea("FER")
	DbSkip()
EndIf
Return lRet    
