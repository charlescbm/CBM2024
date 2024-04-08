User Function QD010FIM()
	
	Local nOpcao := PARAMIXB[1] //informa se Confirmou = 1 ou se Cancelou = 2
	Local nOpc   := PARAMIXB[2]// Customizações do usuário    

	If nOpcao = 1 //Confirmado a inclusão
   		Help("",1,"BRASCOLA",,OemToAnsi("Você esta incluindo um Assunto"),1,0)  
    Else
      	Help("",1,"BRASCOLA",,OemToAnsi("Você cancelou a inclusão de um Assunto"),1,0) 
    EndIf
     
	
Return Nil