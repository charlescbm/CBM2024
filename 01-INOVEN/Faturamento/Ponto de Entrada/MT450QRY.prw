#Include "Protheus.ch"
/*
+---------------------------------------------------------------------------+
| Programa   | MT450QRY                             | Data | 28/09/2021     |
|---------------------------------------------------------------------------|
| Descricao  | Ponto de entrada para o filtro dos pedidos na opcao de       |
|            | liberacao automatica.                                        |
|            |                                                              |
|------------|--------------------------------------------------------------|
| Autor      | GoOne Consultoria - Crele Cristina                           |
+---------------------------------------------------------------------------+
*/
//DESENVOLVIDO POR INOVEN

User Function MT450QRY()
***********************
Local cQry		:= PARAMIXB[1]
Local cFilRet	:= cQry

if !IsInCallStack("MATA455") .and. !IsInCallStack("U_ITECX400") 
    xCPS := alltrim(GetNewPar("IN_CPADIAN", "003"))
    xCPS := StrTran(xCPS, ";", "','")

    //cFilRet += " AND SC5.C5_CONDPAG <> '003' "
    cFilRet += " AND SC5.C5_CONDPAG NOT IN ('"+xCPS+"') "
endif

Return(cFilRet)
