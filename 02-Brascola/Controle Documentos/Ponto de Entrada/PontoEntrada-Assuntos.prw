User Function QD010FIM()
	
	Local nOpcao := PARAMIXB[1] //informa se Confirmou = 1 ou se Cancelou = 2
	Local nOpc   := PARAMIXB[2]// Customiza��es do usu�rio    

	If nOpcao = 1 //Confirmado a inclus�o
   		Help("",1,"BRASCOLA",,OemToAnsi("Voc� esta incluindo um Assunto"),1,0)  
    Else
      	Help("",1,"BRASCOLA",,OemToAnsi("Voc� cancelou a inclus�o de um Assunto"),1,0) 
    EndIf
     
	
Return Nil