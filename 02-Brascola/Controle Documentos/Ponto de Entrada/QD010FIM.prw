User Function QD010FIM()
Local nOpcao := PARAMIXB[1]
Local nOpc   := PARAMIXB[2]// Customiza��es do usu�rio

if nOpcao = 1
	msgalert("voc� confirmou o cadastro")
else
	msgalert("voc� cancelou o cadastro") 
endif

Return Nil
