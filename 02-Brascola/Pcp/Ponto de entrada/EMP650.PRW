// Grava no arquivo SC2, SD4, SC1 o armaz�m = 20 = produ��o. A Brascola ir� transferir
// os produtos para o armaz�m 20 e no apontamento da produ��o o sistema automaticamente
// ir� fazer a requisi��o = saida do armaz�m correto. Por�m devemos acertar o almoxari-
// fado do SC1 para que o sistema fa�a a grava��o do armaz�m padr�o SB1. Com isso,
// n�o teremos erro na compra e no recebimento do material, devido o mesmo estar em 
// armaz�m padr�o. - Cristina - 03/06/05


User Function Emp650()                                      
                      
Local _cLocPad := ""

if SM0->M0_CODFIL == '01'

  _cLocPad :=  Alltrim(GETMV("BR_ESTPROD"))

ELSE
  _cLocPad :=  '10'

ENDIF



IF SUBSTR(_cLocPad,1,1) = '"'
	_cLocPad := SUBSTR(_cLocPad,2,2)
ENDIF

For nI := 1 to len(aCols)
    
    
    aCols[nI,3] := _cLocPad //aCols[nI,3] := "20" 
    
    if substr(aCols[nI,1],1,3) = 'MOD'
       aCols[nI,2] := 0
    ENDIF   


Next nI

Return(.T.)
           