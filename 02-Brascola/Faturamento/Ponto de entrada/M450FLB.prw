#Include "Protheus.ch"

User Function M450FLB()
Local cCondicao := ParamIXB[1]
		 		
If Aviso("Passou pelo Ponto M450FLB!!","Condi��o: " + cCondicao + "Altera condi��o ? ",{"Sim","Nao"}) == 1
	cCondicao := ".T."
EndIf

Return cCondicao