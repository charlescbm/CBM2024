#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"        
#INCLUDE "TbiConn.ch"

******************************************************************************************************
User Function DelChrEsp(cString)
******************************************************************************************************

Local aChrEsp	:= {}
Local nLoop		:= 0

aAdd(aChrEsp, Chr(13))//Caracter Enter
aAdd(aChrEsp, Chr(10))//
aAdd(aChrEsp, Chr(9))//Adicionado o Caracter de tabulação : 13/03/14: Fernando

For nLoop := 1 To Len(aChrEsp)
	cString	:= StrTran(cString, aChrEsp[nLoop], " ")
Next nLoop

Return(cString)