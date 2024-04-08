User Function QD010FIM()
Local nOpcao := PARAMIXB[1]
Local nOpc   := PARAMIXB[2]// Customizações do usuário

if nOpcao = 1
	msgalert("você confirmou o cadastro")
else
	msgalert("você cancelou o cadastro") 
endif

Return Nil
