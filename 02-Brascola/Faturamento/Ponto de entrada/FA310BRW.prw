User Function FA310BRW()
Local cFilBrw := ""	// Sintax de filtro da mBrowse

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿝etorna condicao de filtro para o Browse de Apontamentos �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�     
cFilBrw := "AD5_VEND == 'VEN001' .AND. AD5_CODCLI == '00000012' .AND. AD5_LOJA == '01  ' "

Return(cFilBrw)