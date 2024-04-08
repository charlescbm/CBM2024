User Function FA310BRW()
Local cFilBrw := ""	// Sintax de filtro da mBrowse

//зддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//ЁRetorna condicao de filtro para o Browse de Apontamentos Ё
//юддддддддддддддддддддддддддддддддддддддддддддддддддддддддды     
cFilBrw := "AD5_VEND == 'VEN001' .AND. AD5_CODCLI == '00000012' .AND. AD5_LOJA == '01  ' "

Return(cFilBrw)