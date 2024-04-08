// Grava no arquivo SC2, SD4, SC1 o armazém = 20 = produção. A Brascola irá transferir
// os produtos para o armazém 20 e no apontamento da produção o sistema automaticamente
// irá fazer a requisição = saida do armazém correto. Porém devemos acertar o almoxari-
// fado do SC1 para que o sistema faça a gravação do armazém padrão SB1. Com isso,
// não teremos erro na compra e no recebimento do material, devido o mesmo estar em 
// armazém padrão. - Cristina - 03/06/05


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
           