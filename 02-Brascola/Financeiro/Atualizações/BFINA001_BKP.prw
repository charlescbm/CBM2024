#include "topconn.ch"
#include "rwmake.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  BFINA001   º Autor ³ AP6 IDE            º Data ³  27/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importa Titulos Base antiga para nova                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BFINA001()
***********************    
 cData:= "10/03/2011"//Fernando: adicionei esta variavel, porque da forma que estava não dava certo
 dData := CtoD(cData) 
 cArqQry := "MSE1"


//Abre ambiente para trabalho
prepare environment empresa '01' filial '01' tables 'SE1' 
 
cQuery := "SELECT  * "
cQuery += "FROM DADOS10.dbo.SE1020 E1 "
cQuery += "WHERE E1.E1_FILIAL = '01' "
cQuery += "AND E1.E1_EMISSAO = '"+DtoS(dData)+"' " 
cQuery += "AND E1.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY E1_EMISSAO "

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cArqQry,.T.,.T.)  

aStruMSE1 := MSE1->(dbStruct())//Fernando: estava abaixo do For, coloquei acima do For, pois estava dando erro
aStruSE1  :=  SE1->(dbStruct())//Fernando: estava abaixo do For, coloquei acima do For, pois estava dando erro
For nCntFor := 1 To Len(aStruSE1)
	If ( aStruSE1[nCntFor,2]<>"C" )
		TcSetField(cArqQry,aStruSE1[nCntFor,1],aStruSE1[nCntFor,2],aStruSE1[nCntFor,3],aStruSE1[nCntFor,4])
	EndIf
Next nCntFor


DbSelectArea("MSE1")
DbGotop()
While !Eof()
	
	DbSelectArea("SE1")
	RecLock("SE1",.T.)
	
	For _x := 1 To Len(aStruSE1)
		
		If aStruSE1[_x,1] == "R_E_C_N_O_" .OR. aStruSE1[_x,1] == "D_E_L_E_T_" .OR. aStruSE1[_x,1] == "R_E_C_D_E_L_"
			//aStruSE1[_x,1] == "E1_X_OBS" .OR. aStruSE1[_x,1] == "E1_USERLGI" .OR. aStruSE1[_x,1] == "E1_USERLGA" .OR.;
			Loop
		EndIf
		
		If AScan(aStruMSE1,{|x| x[1] == aStruSE1[_x,1]}) != 0
			
			cCampo := aStruSE1[_x,1]
			
			SE1->(&cCampo) := MSE1->(&cCampo)
			
		EndIf
		
	Next _x
	
	SE1->(MsUnLock())
	
	DbSelectArea("MSE1")
	DbSkip()
EndDo


Return
