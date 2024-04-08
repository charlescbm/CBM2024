#include "rwmake.ch"
#include "totvs.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function BGPER006()
Local cOptions :="1;0;1;Funcionarios"

CallCrys("funcionarios",         ,cOptions  ,           ,             ,               ,    .T.   )  

Return