#include "rwmake.ch"  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MA040TOK ºAutor  ³ Marcelo da Cunha   º Data ³  30/01/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar informacoes do vendedor      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP10/MP11                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MA040TOK()
*********************
LOCAL lRetu := .T.

//Validacao de Alcada
/////////////////////
If (M->A3_tipocad == "1").and.(!Empty(M->A3_super).or.!Empty(M->A3_geren))
	Help("",1,"BRASCOLA",,OemToAnsi("Para informar tipo 1=Presidente, nao deve ser informado o codigo do Supervisor e/ou Gerente.! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif (M->A3_tipocad == "2").and.(!Empty(M->A3_super).or.!Empty(M->A3_geren))
	Help("",1,"BRASCOLA",,OemToAnsi("Para informar tipo 2=Diretor, nao deve ser informado o codigo do Supervisor e/ou Gerente.! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif (M->A3_tipocad == "3").and.(!Empty(M->A3_super).or.!Empty(M->A3_geren))
	Help("",1,"BRASCOLA",,OemToAnsi("Para informar tipo 3=Gerente, nao deve ser informado o codigo do Supervisor e/ou Gerente.! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif (M->A3_tipocad == "4").and.(!Empty(M->A3_super).or.Empty(M->A3_geren))
	Help("",1,"BRASCOLA",,OemToAnsi("Para informar tipo 4=Supervisor, nao deve ser informado o codigo do Supervisor e deve ser informado o codigo do Gerente.! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Elseif (M->A3_tipocad == "5").and.Empty(M->A3_super).and.Empty(M->A3_geren)
	Help("",1,"BRASCOLA",,OemToAnsi("Para informar tipo 5=Representante, deve ser informado o codigo do Supervisor ou o codigo do Gerente.! Favor verificar."),1,0) 
	Return (lRetu := .F.)
Endif
     
//Gravo historico
/////////////////
If (lRetu)
	u_GDVHCompara("SA3")
Endif

Return lRetu