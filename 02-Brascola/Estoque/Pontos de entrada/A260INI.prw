#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณA260INI  บAutor  ณFernando Maia        บ Data ณ  21/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao dos produtos transferidos.                        บฑฑ
ฑฑบ          ณo produto origem tem que ser identico ao destino.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ      Brascola                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function A260INI()

lRet := .T. 

If !Empty(clocorig) 
	If clocorig $ '10*40*76*77*79' .And. !(Upper(AllTrim(cUserName))$Upper(GetMv("BR_000052")))
		lRet:=.F.
		Help("",1,"BRASCOLA",,OemToAnsi("Usuario nao autorizado para fazer movimenta็ใo no local 10/40/76/77/79"),1,0)
	EndIf
EndIf

If !Empty(ccodorig) .And. !Empty(ccoddest)
	
	If ccodorig <> ccoddest
		If (Upper(AllTrim(cUserName))$Upper(GetMv("BR_000038")))
			lRet:=.T.
		Else
			Help("",1,"BRASCOLA",,OemToAnsi("O Produto Origem,Cod:"+alltrim(ccodorig)+", possui um codigo diferente do destino,Cod:"+alltrim(ccoddest)+" nao permitida transferencia!Ligue para Controladoria"),1,0)
			lRet:=.F.
		EndIf
	EndIf
EndIf

Return(lRet)
